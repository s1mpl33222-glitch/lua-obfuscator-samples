local HYDRA_URL = "https://raw.githubusercontent.com/Yinyangzx/Yin-Imag/refs/heads/main/HydraUI"

local HydraKey = {
    PORTAL = "https://yinyangkeysystemnick.up.railway.app/",
    FILE = "Hydra_Key.txt",
    LOGO = "rbxassetid://114974832117287",
    lib = nil,
    ENABLED = false, -- false = sistema key desactivado temporalmente (no carga la GUI ni valida); true = vuelve a funcionar como antes
}
HydraKey.VALIDATE = HydraKey.PORTAL .. "api/validate?key="
task.spawn(function()
    local ok, source = pcall(function() return game:HttpGet(HYDRA_URL) end)
    if ok and type(source) == "string" and #source > 0 then HydraKey.lib = source end
end)
HydraKey.TEXT = {
    es = {sub = "Acceso personal de 24 horas", step1 = "Enlace", step2 = "Portal", step3 = "Key", check = "VERIFICAR", link = "OBTENER ENLACE",
        checking = "VERIFICANDO", granted = "ACCESO CONCEDIDO", placeholder = "Peg\195\161 tu key ac\195\161",
        secure = "Verificaci\195\179n segura del servidor", revalidating = "Revalidando la key guardada", contacting = "Contactando al servidor",
        accepted = "Key aceptada \194\183 cargando Hydra", link_copied = "Enlace copiado", portal = "Portal", no_file = "Tu ejecutor no guarda archivos: la key no se recuerda",
        invalid_format = "Formato inv\195\161lido", server_unavailable = "Servidor no disponible", invalid_response = "Respuesta inv\195\161lida",
        invalid_expired = "Key inv\195\161lida o vencida", removed = "se borr\195\179 la guardada"},
    en = {sub = "Personal 24-hour access", step1 = "Link", step2 = "Portal", step3 = "Key", check = "CHECK KEY", link = "GET LINK",
        checking = "CHECKING", granted = "ACCESS GRANTED", placeholder = "Paste your key here",
        secure = "Secure server verification", revalidating = "Revalidating saved key", contacting = "Contacting server",
        accepted = "Key accepted \194\183 loading Hydra", link_copied = "Link copied", portal = "Portal", no_file = "Your executor can't save files: the key won't be remembered",
        invalid_format = "Invalid format", server_unavailable = "Server unavailable", invalid_response = "Invalid response",
        invalid_expired = "Invalid or expired key", removed = "saved key removed"},
}

function HydraKey.normalize(value) return (tostring(value or ""):gsub("%s+", ""):upper()) end
function HydraKey.isFormat(value) return value:match("^YINYANG%-%w%w%w%-%w%w%w%-%w%w%w%-%w%w%w%-%w%w%w$") ~= nil end
function HydraKey.canCache()
    return type(isfile) == "function" and type(readfile) == "function" and type(writefile) == "function" and type(delfile) == "function"
end
function HydraKey.loadCached()
    if not HydraKey.canCache() then return nil end
    local ok, cached = pcall(function()
        if isfile(HydraKey.FILE) then return HydraKey.normalize(readfile(HydraKey.FILE)) end
        return nil
    end)
    if ok and HydraKey.isFormat(cached or "") then return cached end
    return nil
end
function HydraKey.save(key) if HydraKey.canCache() then pcall(writefile, HydraKey.FILE, HydraKey.normalize(key)) end end
function HydraKey.clear()
    if HydraKey.canCache() then
        pcall(function() if isfile(HydraKey.FILE) then delfile(HydraKey.FILE) end end)
    end
end
function HydraKey.validate(value)
    local key = HydraKey.normalize(value)
    if not HydraKey.isFormat(key) then return false, "invalid_format" end
    local HttpService = game:GetService("HttpService")
    local requestFunction = (syn and syn.request) or http_request or request or (fluxus and fluxus.request)
    local ok, body = pcall(function()
        if requestFunction then
            local response = requestFunction({Url = HydraKey.VALIDATE .. HttpService:UrlEncode(key), Method = "GET"})
            if not response or tonumber(response.StatusCode) ~= 200 then error("HTTP validation failed") end
            return response.Body
        end
        return game:HttpGet(HydraKey.VALIDATE .. HttpService:UrlEncode(key))
    end)
    if not ok or type(body) ~= "string" then return false, "server_unavailable" end
    local okJson, data = pcall(function() return HttpService:JSONDecode(body) end)
    if not okJson or type(data) ~= "table" then return false, "invalid_response" end
    if data.valid == true then return true, "accepted" end
    return false, "invalid_expired"
end

function HydraKey.run()
    local Players = game:GetService("Players")
    local TweenService = game:GetService("TweenService")
    local LocalizationService = game:GetService("LocalizationService")
    local player = Players.LocalPlayer
    local C = {Bg = Color3.fromRGB(12, 14, 19), Field = Color3.fromRGB(38, 43, 54), Text = Color3.fromRGB(248, 249, 252), Dim = Color3.fromRGB(190, 195, 208),
        Accent = Color3.fromRGB(236, 239, 245), AccentDark = Color3.fromRGB(140, 146, 160), Stroke = Color3.fromRGB(150, 156, 172),
        OK = Color3.fromRGB(46, 214, 170), ERR = Color3.fromRGB(255, 96, 110)}
    local lang = "en"
    local function setLang(locale)
        lang = string.sub(string.lower(tostring(locale or "")), 1, 2) == "es" and "es" or "en"
    end
    pcall(function() setLang(LocalizationService.SystemLocaleId) end)
    local function t(k) return HydraKey.TEXT[lang][k] or HydraKey.TEXT.en[k] or k end
    local function mk(class, props)
        local inst = Instance.new(class)
        for k, v in pairs(props) do if k ~= "Parent" then inst[k] = v end end
        if class == "TextLabel" or class == "TextBox" or class == "TextButton" then
            local o = Instance.new("UIStroke")
            o.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
            o.Color = Color3.new(0, 0, 0)
            o.Thickness = 1
            o.Transparency = 0.55
            o.Parent = inst
        end
        inst.Parent = props.Parent
        return inst
    end
    local function corner(p, r) return mk("UICorner", {CornerRadius = UDim.new(0, r), Parent = p}) end
    local function stroke(p, color, tr, th) return mk("UIStroke", {Color = color, Transparency = tr or 0, Thickness = th or 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = p}) end
    local function tween(i, time, goals, style, dir)
        local tw = TweenService:Create(i, TweenInfo.new(time, style or Enum.EasingStyle.Quint, dir or Enum.EasingDirection.Out), goals)
        tw:Play()
        return tw
    end

    local parent = nil
    pcall(function() if typeof(gethui) == "function" then parent = gethui() end end)
    if not parent then pcall(function() parent = game:GetService("CoreGui") end) end
    parent = parent or player:WaitForChild("PlayerGui")
    local old = parent:FindFirstChild("HydraKey")
    if old then old:Destroy() end
    local gui = mk("ScreenGui", {Name = "HydraKey", ResetOnSpawn = false, IgnoreGuiInset = true, ZIndexBehavior = Enum.ZIndexBehavior.Sibling, DisplayOrder = 100, Parent = parent})
    local shade = mk("Frame", {Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.new(0, 0, 0), BackgroundTransparency = 1, BorderSizePixel = 0, Parent = gui})

    local panel = mk("Frame", {Size = UDim2.new(0.92, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
        BackgroundColor3 = C.Bg, BackgroundTransparency = 0.06, BorderSizePixel = 0, Parent = gui})
    mk("UISizeConstraint", {MaxSize = Vector2.new(360, math.huge), Parent = panel})
    corner(panel, 18)
    local scale = mk("UIScale", {Scale = 0.88, Parent = panel})

    local ring = stroke(panel, Color3.new(1, 1, 1), 0.15, 1.4)
    local ringGrad = mk("UIGradient", {Color = ColorSequence.new({ColorSequenceKeypoint.new(0, C.AccentDark), ColorSequenceKeypoint.new(0.45, C.AccentDark),
        ColorSequenceKeypoint.new(0.5, Color3.new(1, 1, 1)), ColorSequenceKeypoint.new(0.55, C.AccentDark), ColorSequenceKeypoint.new(1, C.AccentDark)}), Parent = ring})
    local ringSpin = TweenService:Create(ringGrad, TweenInfo.new(4, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), {Rotation = 360})
    ringSpin:Play()

    local glow = mk("Frame", {Size = UDim2.new(1, 0, 0, 120), BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0, Parent = panel})
    corner(glow, 18)
    mk("UIGradient", {Rotation = 90, Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.9), NumberSequenceKeypoint.new(1, 1)}), Parent = glow})
    local body = mk("Frame", {Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Parent = panel})
    mk("UIPadding", {PaddingTop = UDim.new(0, 18), PaddingBottom = UDim.new(0, 16), PaddingLeft = UDim.new(0, 18), PaddingRight = UDim.new(0, 18), Parent = body})
    mk("UIListLayout", {Padding = UDim.new(0, 12), SortOrder = Enum.SortOrder.LayoutOrder, Parent = body})

    local head = mk("Frame", {Size = UDim2.new(1, 0, 0, 52), BackgroundTransparency = 1, LayoutOrder = 1, Parent = body})
    local logo = mk("ImageLabel", {Size = UDim2.fromOffset(50, 50), BackgroundTransparency = 1, Image = HydraKey.LOGO, ScaleType = Enum.ScaleType.Fit, Parent = head})
    TweenService:Create(logo, TweenInfo.new(2.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {Rotation = 4}):Play()
    local title = mk("TextLabel", {Size = UDim2.new(1, -110, 0, 28), Position = UDim2.fromOffset(60, 2), BackgroundTransparency = 1, Text = "HYDRA", TextColor3 = Color3.new(1, 1, 1),
        Font = Enum.Font.GothamBlack, TextSize = 26, TextXAlignment = Enum.TextXAlignment.Left, Parent = head})
    local shine = mk("UIGradient", {Color = ColorSequence.new({ColorSequenceKeypoint.new(0, C.AccentDark), ColorSequenceKeypoint.new(0.45, C.Accent),
        ColorSequenceKeypoint.new(0.5, Color3.new(1, 1, 1)), ColorSequenceKeypoint.new(0.55, C.Accent), ColorSequenceKeypoint.new(1, C.AccentDark)}), Offset = Vector2.new(-1, 0), Parent = title})
    TweenService:Create(shine, TweenInfo.new(2.4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, false, 0.6), {Offset = Vector2.new(1, 0)}):Play()
    local sub = mk("TextLabel", {Size = UDim2.new(1, -110, 0, 16), Position = UDim2.fromOffset(60, 31), BackgroundTransparency = 1, Text = t("sub"), TextColor3 = C.Dim,
        Font = Enum.Font.GothamSemibold, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, Parent = head})
    local close = mk("TextButton", {Size = UDim2.fromOffset(32, 32), AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, 0, 0, 2), BackgroundColor3 = Color3.new(1, 1, 1),
        BackgroundTransparency = 0.9, AutoButtonColor = false, Text = "\195\151", TextColor3 = C.Text, Font = Enum.Font.GothamBold, TextSize = 20, Parent = head})
    corner(close, 99)
    stroke(close, C.Stroke, 0.6)

    local steps = mk("Frame", {Size = UDim2.new(1, 0, 0, 30), BackgroundTransparency = 1, LayoutOrder = 2, Parent = body})
    mk("UIListLayout", {FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder, Parent = steps})
    local stepPills = {}
    for i = 1, 3 do
        local pill = mk("Frame", {Size = UDim2.new(1 / 3, -4, 1, 0), BackgroundColor3 = C.Field, BackgroundTransparency = 0.35, BorderSizePixel = 0, LayoutOrder = i, Parent = steps})
        corner(pill, 10)
        local pillStroke = stroke(pill, C.Stroke, 0.7)
        local num = mk("TextLabel", {Size = UDim2.fromOffset(20, 20), Position = UDim2.new(0, 6, 0.5, -10), BackgroundColor3 = C.Bg, Text = tostring(i), TextColor3 = C.Dim,
            Font = Enum.Font.GothamBlack, TextSize = 11, Parent = pill})
        corner(num, 99)
        local label = mk("TextLabel", {Size = UDim2.new(1, -32, 1, 0), Position = UDim2.fromOffset(30, 0), BackgroundTransparency = 1, Text = t("step" .. i), TextColor3 = C.Dim,
            Font = Enum.Font.GothamBold, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, Parent = pill})
        stepPills[i] = {pill = pill, stroke = pillStroke, num = num, label = label}
    end
    local function markSteps(n)
        for i, s in ipairs(stepPills) do
            local on = i <= n
            tween(s.pill, 0.25, {BackgroundColor3 = on and C.Accent or C.Field, BackgroundTransparency = on and 0.82 or 0.35})
            tween(s.stroke, 0.25, {Color = on and C.Accent or C.Stroke, Transparency = on and 0.25 or 0.7})
            tween(s.num, 0.25, {BackgroundColor3 = on and C.Accent or C.Bg, TextColor3 = on and C.Bg or C.Dim})
            tween(s.label, 0.25, {TextColor3 = on and C.Text or C.Dim})
        end
    end

    local field = mk("Frame", {Size = UDim2.new(1, 0, 0, 46), BackgroundColor3 = C.Field, BackgroundTransparency = 0.25, BorderSizePixel = 0, LayoutOrder = 3, Parent = body})
    corner(field, 12)
    local fieldStroke = stroke(field, C.Stroke, 0.55, 1.2)
    local input = mk("TextBox", {Size = UDim2.new(1, -66, 1, 0), Position = UDim2.fromOffset(14, 0), BackgroundTransparency = 1, Text = "", PlaceholderText = t("placeholder"),
        PlaceholderColor3 = C.Dim, TextColor3 = C.Text, Font = Enum.Font.Code, TextSize = 13, ClearTextOnFocus = false, TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd, Parent = field})
    local counter = mk("TextLabel", {Size = UDim2.fromOffset(42, 22), AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -10, 0.5, 0), BackgroundColor3 = C.Bg,
        BackgroundTransparency = 0.3, Text = "0/5", TextColor3 = C.Dim, Font = Enum.Font.GothamBold, TextSize = 11, Parent = field})
    corner(counter, 99)

    local buttons = mk("Frame", {Size = UDim2.new(1, 0, 0, 42), BackgroundTransparency = 1, LayoutOrder = 4, Parent = body})
    local check = mk("TextButton", {Size = UDim2.new(0.55, -4, 1, 0), BackgroundColor3 = C.Accent, AutoButtonColor = false, Text = t("check"), TextColor3 = C.Bg,
        Font = Enum.Font.GothamBlack, TextSize = 13, Parent = buttons})
    corner(check, 12)
    local checkGrad = mk("UIGradient", {Rotation = 90, Color = ColorSequence.new(Color3.new(1, 1, 1), Color3.fromRGB(178, 183, 195)), Parent = check})
    local link = mk("TextButton", {Size = UDim2.new(0.45, -4, 1, 0), AnchorPoint = Vector2.new(1, 0), Position = UDim2.fromScale(1, 0), BackgroundColor3 = Color3.new(1, 1, 1),
        BackgroundTransparency = 0.92, AutoButtonColor = false, Text = t("link"), TextColor3 = C.Text, Font = Enum.Font.GothamBold, TextSize = 12, Parent = buttons})
    corner(link, 12)
    stroke(link, C.Stroke, 0.5)
    for _, b in ipairs({check, link, close}) do
        local s = mk("UIScale", {Scale = 1, Parent = b})
        b.MouseEnter:Connect(function() tween(s, 0.15, {Scale = 1.03}) end)
        b.MouseLeave:Connect(function() tween(s, 0.2, {Scale = 1}) end)
        b.MouseButton1Down:Connect(function() tween(s, 0.08, {Scale = 0.95}) end)
        b.MouseButton1Up:Connect(function() tween(s, 0.3, {Scale = 1}, Enum.EasingStyle.Back) end)
    end

    local statusRow = mk("Frame", {Size = UDim2.new(1, 0, 0, 30), BackgroundTransparency = 1, LayoutOrder = 5, Parent = body})
    local dot = mk("Frame", {Size = UDim2.fromOffset(8, 8), Position = UDim2.fromOffset(2, 4), BackgroundColor3 = C.Dim, BorderSizePixel = 0, Parent = statusRow})
    corner(dot, 99)
    local status = mk("TextLabel", {Size = UDim2.new(1, -16, 0, 16), Position = UDim2.fromOffset(16, 0), BackgroundTransparency = 1, Text = t("secure"), TextColor3 = C.Dim,
        Font = Enum.Font.GothamSemibold, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, Parent = statusRow})
    local track = mk("Frame", {Size = UDim2.new(1, 0, 0, 3), Position = UDim2.fromOffset(0, 24), BackgroundColor3 = C.Field, BorderSizePixel = 0, ClipsDescendants = true, Parent = statusRow})
    corner(track, 99)
    local fill = mk("Frame", {Size = UDim2.fromScale(0, 1), BackgroundColor3 = C.Accent, BorderSizePixel = 0, Parent = track})
    corner(fill, 99)
    local fillLoop = nil

    local state = {busy = false, authorized = false, closed = false, kind = "secure", color = C.Dim, removed = false}
    local function statusText()
        local k = state.kind
        if k == "link_copied" then return t("link_copied") .. " \194\183 " .. HydraKey.PORTAL end
        if k == "portal" then return t("portal") .. ": " .. HydraKey.PORTAL end
        if k == "invalid_expired" and state.removed then return t("invalid_expired") .. " \194\183 " .. t("removed") end
        return t(k)
    end
    local function setStatus(kind, color, working)
        state.kind, state.color = kind, color
        status.Text = statusText()
        status.TextColor3 = color
        dot.BackgroundColor3 = color
        if fillLoop then fillLoop:Cancel() fillLoop = nil end
        fill.BackgroundColor3 = color
        if working then
            fill.Size, fill.Position = UDim2.fromScale(0.3, 1), UDim2.fromScale(-0.3, 0)
            fillLoop = TweenService:Create(fill, TweenInfo.new(0.9, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1), {Position = UDim2.fromScale(1, 0)})
            fillLoop:Play()
        else
            fill.Position = UDim2.fromScale(0, 0)
            fill.Size = UDim2.fromScale(0, 1)
            tween(fill, 0.45, {Size = UDim2.fromScale(color == C.Dim and 0 or 1, 1)})
        end
    end
    local function refresh()
        sub.Text = t("sub")
        for i, s in ipairs(stepPills) do s.label.Text = t("step" .. i) end
        input.PlaceholderText = t("placeholder")
        link.Text = t("link")
        check.Text = state.busy and t("checking") or (state.authorized and t("granted") or t("check"))
        status.Text = statusText()
    end
    task.spawn(function()
        local ok, translator = pcall(function() return LocalizationService:GetTranslatorForPlayerAsync(player) end)
        if ok and translator then
            setLang(translator.LocaleId)
            refresh()
            pcall(function()
                translator:GetPropertyChangedSignal("LocaleId"):Connect(function() setLang(translator.LocaleId) refresh() end)
            end)
        end
    end)

    local function refreshFormat()
        local key = HydraKey.normalize(input.Text)
        local blocks = 0
        local rest = key:match("^YINYANG%-(.*)$")
        if rest then
            for part in rest:gmatch("[^%-]+") do
                if part:match("^%w%w%w$") then blocks = blocks + 1 end
            end
        end
        local ready = HydraKey.isFormat(key)
        counter.Text = math.min(blocks, 5) .. "/5"
        counter.TextColor3 = ready and C.OK or C.Dim
        markSteps(ready and 3 or (key ~= "" and 2 or 1))
    end
    input:GetPropertyChangedSignal("Text"):Connect(refreshFormat)
    input.Focused:Connect(function() tween(fieldStroke, 0.18, {Color = C.Accent, Transparency = 0.15}) end)
    input.FocusLost:Connect(function() tween(fieldStroke, 0.25, {Color = C.Stroke, Transparency = 0.55}) end)

    local function shake()
        local base = panel.Position
        for _, dx in ipairs({10, -8, 6, -4, 0}) do
            tween(panel, 0.05, {Position = UDim2.new(base.X.Scale, base.X.Offset + dx, base.Y.Scale, base.Y.Offset)}, Enum.EasingStyle.Sine)
            task.wait(0.05)
        end
        panel.Position = base
    end
    local function dismiss()
        pcall(function() ringSpin:Cancel() end)
        if fillLoop then pcall(function() fillLoop:Cancel() end) end
        tween(shade, 0.22, {BackgroundTransparency = 1})
        local out = tween(scale, 0.22, {Scale = 0.9}, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        out.Completed:Wait()
        if gui.Parent then gui:Destroy() end
    end

    local function tryAccess(value, fromCache)
        if state.busy or state.closed then return end
        state.busy = true
        state.removed = false
        input.Text = HydraKey.normalize(value)
        check.Text = t("checking")
        setStatus(fromCache and "revalidating" or "contacting", C.Accent, true)
        local valid, kind = HydraKey.validate(input.Text)
        if valid then
            HydraKey.save(input.Text)
            state.authorized = true
            pcall(function() getgenv().HydraKeyValidated = true end)
            setStatus("accepted", C.OK, false)
            check.Text = t("granted")
            tween(checkGrad, 0.25, {Rotation = 270})
            tween(check, 0.25, {BackgroundColor3 = C.OK})
            markSteps(3)
            task.wait(0.45)
            dismiss()
        else
            if fromCache and kind == "invalid_expired" then
                HydraKey.clear()
                input.Text = ""
                state.removed = true
            end
            setStatus(kind, C.ERR, false)
            check.Text = t("check")
            fieldStroke.Color = C.ERR
            fieldStroke.Transparency = 0.1
            shake()
            task.delay(1.2, function()
                if fieldStroke.Parent then tween(fieldStroke, 0.3, {Color = C.Stroke, Transparency = 0.55}) end
            end)
        end
        state.busy = false
    end

    input.FocusLost:Connect(function(enter) if enter then tryAccess(input.Text, false) end end)
    check.Activated:Connect(function() tryAccess(input.Text, false) end)
    link.Activated:Connect(function()
        if setclipboard then
            pcall(setclipboard, HydraKey.PORTAL)
            setStatus("link_copied", C.OK, false)
        else
            setStatus("portal", C.Accent, false)
        end
        if HydraKey.normalize(input.Text) == "" then markSteps(2) end
    end)
    close.Activated:Connect(function()
        state.closed = true
        task.spawn(dismiss)
    end)

    tween(shade, 0.3, {BackgroundTransparency = 0.35})
    tween(scale, 0.45, {Scale = 1}, Enum.EasingStyle.Back)
    refreshFormat()
    local cached = HydraKey.loadCached()
    if cached then
        input.Text = cached
        task.spawn(function()
            task.wait()
            tryAccess(cached, true)
        end)
    elseif not HydraKey.canCache() then
        setStatus("no_file", C.Accent, false)
    end
    while not state.authorized and not state.closed do task.wait() end
    return state.authorized
end

-- Aviso de mantenimiento (se muestra mientras el sistema key esta desactivado: HydraKey.ENABLED = false)
HydraKey.MAINT = {
    LOGO = "rbxassetid://138681977482040",
    DURATION = 25, -- segundos antes de cerrarse solo (0 = no se cierra solo)
    TEXT = {
        en = {tag = "MAINTENANCE",
            msg = "Yin Yang will be undergoing maintenance. We apologize for this, but it's for the good of our script. It will be back in a few days. We'll announce everything on our Discord server!"},
        es = {tag = "MANTENIMIENTO",
            msg = "Yin Yang entrar\195\161 en mantenimiento. Pedimos disculpas por esto, pero es por el bien de nuestro script. Volver\195\161 en unos d\195\173as. \194\161Anunciaremos todo en nuestro servidor de Discord!"},
        pt = {tag = "MANUTEN\195\135\195\131O",
            msg = "O Yin Yang entrar\195\161 em manuten\195\167\195\163o. Pedimos desculpas por isso, mas \195\169 para o bem do nosso script. Ele voltar\195\161 em alguns dias. Vamos anunciar tudo no nosso servidor do Discord!"},
        fr = {tag = "MAINTENANCE",
            msg = "Yin Yang va entrer en maintenance. Nous nous en excusons, mais c'est pour le bien de notre script. Il sera de retour dans quelques jours. Nous annoncerons tout sur notre serveur Discord !"},
        de = {tag = "WARTUNG",
            msg = "Yin Yang wird gewartet. Wir entschuldigen uns daf\195\188r, aber es dient dem Wohl unseres Scripts. Es ist in ein paar Tagen wieder da. Wir geben alles auf unserem Discord-Server bekannt!"},
        it = {tag = "MANUTENZIONE",
            msg = "Yin Yang andr\195\160 in manutenzione. Ci scusiamo per questo, ma \195\168 per il bene del nostro script. Torner\195\160 tra pochi giorni. Annunceremo tutto sul nostro server Discord!"},
        ru = {tag = "\208\162\208\149\208\165\208\160\208\144\208\145\208\158\208\162\208\171",
            msg = "Yin Yang \209\131\209\133\208\190\208\180\208\184\209\130 \208\189\208\176 \209\130\208\181\209\133\208\189\208\184\209\135\208\181\209\129\208\186\208\190\208\181 \208\190\208\177\209\129\208\187\209\131\208\182\208\184\208\178\208\176\208\189\208\184\208\181. \208\159\209\128\208\184\208\189\208\190\209\129\208\184\208\188 \208\184\208\183\208\178\208\184\208\189\208\181\208\189\208\184\209\143, \208\189\208\190 \209\141\209\130\208\190 \208\189\209\131\208\182\208\189\208\190 \208\180\208\187\209\143 \209\131\208\187\209\131\209\135\209\136\208\181\208\189\208\184\209\143 \208\189\208\176\209\136\208\181\208\179\208\190 \209\129\208\186\209\128\208\184\208\191\209\130\208\176. \208\158\208\189 \208\178\208\181\209\128\208\189\209\145\209\130\209\129\209\143 \209\135\208\181\209\128\208\181\208\183 \208\189\208\181\209\129\208\186\208\190\208\187\209\140\208\186\208\190 \208\180\208\189\208\181\208\185. \208\158\208\177\208\190 \208\178\209\129\209\145\208\188 \208\190\208\177\209\138\209\143\208\178\208\184\208\188 \208\189\208\176 \208\189\208\176\209\136\208\181\208\188 Discord-\209\129\208\181\209\128\208\178\208\181\209\128\208\181!"},
        tr = {tag = "BAKIM",
            msg = "Yin Yang bak\196\177ma al\196\177nacak. Bunun i\195\167in \195\182z\195\188r dileriz, ancak bu scriptimizin iyili\196\159i i\195\167in. Birka\195\167 g\195\188n i\195\167inde geri d\195\182necek. Her \197\159eyi Discord sunucumuzda duyuraca\196\159\196\177z!"},
        pl = {tag = "KONSERWACJA",
            msg = "Yin Yang przechodzi konserwacj\196\153. Przepraszamy za to, ale robimy to dla dobra naszego skryptu. Wr\195\179ci za kilka dni. Wszystko og\197\130osimy na naszym serwerze Discord!"},
        id = {tag = "PEMELIHARAAN",
            msg = "Yin Yang akan menjalani pemeliharaan. Kami mohon maaf, tetapi ini demi kebaikan script kami. Script akan kembali dalam beberapa hari. Kami akan mengumumkan semuanya di server Discord kami!"},
        vi = {tag = "B\225\186\162O TR\195\140",
            msg = "Yin Yang s\225\186\189 \196\145\198\176\225\187\163c b\225\186\163o tr\195\172. Ch\195\186ng t\195\180i xin l\225\187\151i v\195\172 \196\145i\225\187\129u n\195\160y, nh\198\176ng \196\145\195\162y l\195\160 v\195\172 l\225\187\163i \195\173ch c\225\187\167a script. Script s\225\186\189 tr\225\187\159 l\225\186\161i sau v\195\160i ng\195\160y. Ch\195\186ng t\195\180i s\225\186\189 th\195\180ng b\195\161o m\225\187\141i th\225\187\169 tr\195\170n m\195\161y ch\225\187\167 Discord c\225\187\167a m\195\172nh!"},
        ja = {tag = "\227\131\161\227\131\179\227\131\134\227\131\138\227\131\179\227\130\185",
            msg = "Yin Yang\227\129\175\227\131\161\227\131\179\227\131\134\227\131\138\227\131\179\227\130\185\227\129\171\229\133\165\227\130\138\227\129\190\227\129\153\227\128\130\227\129\148\232\191\183\230\131\145\227\130\146\227\129\138\227\129\139\227\129\145\227\129\151\227\129\166\231\148\179\227\129\151\232\168\179\227\129\130\227\130\138\227\129\190\227\129\155\227\130\147\227\129\140\227\128\129\227\130\185\227\130\175\227\131\170\227\131\151\227\131\136\227\130\146\227\130\136\227\130\138\232\137\175\227\129\143\227\129\153\227\130\139\227\129\159\227\130\129\227\129\167\227\129\153\227\128\130\230\149\176\230\151\165\229\190\140\227\129\171\229\190\169\229\184\176\227\129\151\227\129\190\227\129\153\227\128\130\232\169\179\231\180\176\227\129\175Discord\227\130\181\227\131\188\227\131\144\227\131\188\227\129\167\227\129\138\231\159\165\227\130\137\227\129\155\227\129\151\227\129\190\227\129\153\239\188\129"},
        ko = {tag = "\236\160\144\234\178\128",
            msg = "Yin Yang\236\157\180 \236\160\144\234\178\128\236\151\144 \235\147\164\236\150\180\234\176\145\235\139\136\235\139\164. \235\182\136\237\142\184\236\157\132 \235\147\156\235\160\164 \236\163\132\236\134\161\237\149\152\236\167\128\235\167\140, \236\138\164\237\129\172\235\166\189\237\138\184\235\165\188 \235\141\148 \236\162\139\234\178\140 \235\167\140\235\147\164\234\184\176 \236\156\132\237\149\156 \234\178\131\236\158\133\235\139\136\235\139\164. \235\169\176\236\185\160 \237\155\132 \235\139\164\236\139\156 \235\143\140\236\149\132\236\152\181\235\139\136\235\139\164. \235\170\168\235\147\160 \235\130\180\236\154\169\236\157\128 Discord \236\132\156\235\178\132\236\151\144\236\132\156 \234\179\181\236\167\128\237\149\152\234\178\160\236\138\181\235\139\136\235\139\164!"},
        zh_cn = {tag = "\231\187\180\230\138\164\228\184\173",
            msg = "Yin Yang \229\141\179\229\176\134\232\191\155\229\133\165\231\187\180\230\138\164\227\128\130\229\175\185\230\173\164\230\136\145\228\187\172\230\183\177\232\161\168\230\173\137\230\132\143\239\188\140\228\189\134\232\191\153\230\152\175\228\184\186\228\186\134\232\174\169\232\132\154\230\156\172\229\143\152\229\190\151\230\155\180\229\165\189\227\128\130\229\135\160\229\164\169\229\144\142\229\176\177\228\188\154\230\129\162\229\164\141\227\128\130\230\136\145\228\187\172\228\188\154\229\156\168 Discord \230\156\141\229\138\161\229\153\168\228\184\138\229\143\145\229\184\131\230\137\128\230\156\137\229\133\172\229\145\138\239\188\129"},
        zh_tw = {tag = "\231\182\173\232\173\183\228\184\173",
            msg = "Yin Yang \229\141\179\229\176\135\233\128\178\229\133\165\231\182\173\232\173\183\227\128\130\229\176\141\230\173\164\230\136\145\229\128\145\230\183\177\230\132\159\230\138\177\230\173\137\239\188\140\228\189\134\233\128\153\230\152\175\231\130\186\228\186\134\232\174\147\232\133\179\230\156\172\232\174\138\229\190\151\230\155\180\229\165\189\227\128\130\229\185\190\229\164\169\229\190\140\229\176\177\230\156\131\230\129\162\229\190\169\227\128\130\230\136\145\229\128\145\230\156\131\229\156\168 Discord \228\188\186\230\156\141\229\153\168\228\184\138\231\153\188\228\189\136\230\137\128\230\156\137\229\133\172\229\145\138\239\188\129"},
    },
}
function HydraKey.maintenance()
    local Players = game:GetService("Players")
    local TweenService = game:GetService("TweenService")
    local LocalizationService = game:GetService("LocalizationService")
    local player = Players.LocalPlayer
    local M = HydraKey.MAINT
    local C = {Bg = Color3.fromRGB(12, 14, 19), Field = Color3.fromRGB(38, 43, 54), Text = Color3.fromRGB(248, 249, 252), Dim = Color3.fromRGB(190, 195, 208),
        Accent = Color3.fromRGB(236, 239, 245), AccentDark = Color3.fromRGB(140, 146, 160), Stroke = Color3.fromRGB(150, 156, 172)}
    local lang = "en"
    local function pickLang(locale)
        local l = string.lower(tostring(locale or "")):gsub("_", "-")
        local code = string.sub(l, 1, 2)
        if code == "zh" then
            if string.find(l, "tw", 1, true) or string.find(l, "hk", 1, true) or string.find(l, "hant", 1, true) then return "zh_tw" end
            return "zh_cn"
        end
        if M.TEXT[code] then return code end
        return "en"
    end
    pcall(function() lang = pickLang(LocalizationService.SystemLocaleId) end)
    pcall(function()
        local id = player.LocaleId
        if type(id) == "string" and #id > 0 then lang = pickLang(id) end
    end)
    local function t(k) return (M.TEXT[lang] or M.TEXT.en)[k] end
    local function mk(class, props)
        local inst = Instance.new(class)
        for k, v in pairs(props) do if k ~= "Parent" then inst[k] = v end end
        if class == "TextLabel" or class == "TextBox" or class == "TextButton" then
            local o = Instance.new("UIStroke")
            o.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
            o.Color = Color3.new(0, 0, 0)
            o.Thickness = 1
            o.Transparency = 0.55
            o.Parent = inst
        end
        inst.Parent = props.Parent
        return inst
    end
    local function corner(p, r) return mk("UICorner", {CornerRadius = UDim.new(0, r), Parent = p}) end
    local function stroke(p, color, tr, th) return mk("UIStroke", {Color = color, Transparency = tr or 0, Thickness = th or 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = p}) end
    local function tween(i, time, goals, style, dir)
        local tw = TweenService:Create(i, TweenInfo.new(time, style or Enum.EasingStyle.Quint, dir or Enum.EasingDirection.Out), goals)
        tw:Play()
        return tw
    end

    local parent = nil
    pcall(function() if typeof(gethui) == "function" then parent = gethui() end end)
    if not parent then pcall(function() parent = game:GetService("CoreGui") end) end
    parent = parent or player:WaitForChild("PlayerGui")
    local old = parent:FindFirstChild("HydraMaintenance")
    if old then old:Destroy() end
    local gui = mk("ScreenGui", {Name = "HydraMaintenance", ResetOnSpawn = false, IgnoreGuiInset = false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling, DisplayOrder = 100, Parent = parent})

    local panel = mk("Frame", {Size = UDim2.new(0.92, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0, -220),
        BackgroundColor3 = C.Bg, BackgroundTransparency = 0.04, BorderSizePixel = 0, Parent = gui})
    mk("UISizeConstraint", {MaxSize = Vector2.new(340, math.huge), Parent = panel})
    corner(panel, 16)
    local scale = mk("UIScale", {Scale = 0.9, Parent = panel})

    local ring = stroke(panel, Color3.new(1, 1, 1), 0.15, 1.4)
    local ringGrad = mk("UIGradient", {Color = ColorSequence.new({ColorSequenceKeypoint.new(0, C.AccentDark), ColorSequenceKeypoint.new(0.45, C.AccentDark),
        ColorSequenceKeypoint.new(0.5, Color3.new(1, 1, 1)), ColorSequenceKeypoint.new(0.55, C.AccentDark), ColorSequenceKeypoint.new(1, C.AccentDark)}), Parent = ring})
    local ringSpin = TweenService:Create(ringGrad, TweenInfo.new(4, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), {Rotation = 360})
    ringSpin:Play()

    local glow = mk("Frame", {Size = UDim2.new(1, 0, 0, 90), BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0, Parent = panel})
    corner(glow, 16)
    mk("UIGradient", {Rotation = 90, Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.9), NumberSequenceKeypoint.new(1, 1)}), Parent = glow})
    local body = mk("Frame", {Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Parent = panel})
    mk("UIPadding", {PaddingTop = UDim.new(0, 14), PaddingBottom = UDim.new(0, 14), PaddingLeft = UDim.new(0, 16), PaddingRight = UDim.new(0, 16), Parent = body})
    mk("UIListLayout", {Padding = UDim.new(0, 10), SortOrder = Enum.SortOrder.LayoutOrder, Parent = body})

    local head = mk("Frame", {Size = UDim2.new(1, 0, 0, 46), BackgroundTransparency = 1, LayoutOrder = 1, Parent = body})
    local logo = mk("ImageLabel", {Size = UDim2.fromOffset(44, 44), BackgroundTransparency = 1, Image = M.LOGO, ScaleType = Enum.ScaleType.Fit, Parent = head})
    TweenService:Create(logo, TweenInfo.new(2.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {Rotation = 4}):Play()
    local title = mk("TextLabel", {Size = UDim2.new(1, -100, 0, 26), Position = UDim2.fromOffset(54, 0), BackgroundTransparency = 1, Text = "YIN YANG", TextColor3 = Color3.new(1, 1, 1),
        Font = Enum.Font.GothamBlack, TextSize = 22, TextXAlignment = Enum.TextXAlignment.Left, Parent = head})
    local shine = mk("UIGradient", {Color = ColorSequence.new({ColorSequenceKeypoint.new(0, C.AccentDark), ColorSequenceKeypoint.new(0.45, C.Accent),
        ColorSequenceKeypoint.new(0.5, Color3.new(1, 1, 1)), ColorSequenceKeypoint.new(0.55, C.Accent), ColorSequenceKeypoint.new(1, C.AccentDark)}), Offset = Vector2.new(-1, 0), Parent = title})
    TweenService:Create(shine, TweenInfo.new(2.4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, false, 0.6), {Offset = Vector2.new(1, 0)}):Play()
    local tag = mk("TextLabel", {Size = UDim2.fromOffset(0, 17), AutomaticSize = Enum.AutomaticSize.X, Position = UDim2.fromOffset(54, 27), BackgroundColor3 = Color3.new(1, 1, 1),
        BackgroundTransparency = 0.88, Text = t("tag"), TextColor3 = C.Text, Font = Enum.Font.GothamBold, TextSize = 10, Parent = head})
    mk("UIPadding", {PaddingLeft = UDim.new(0, 9), PaddingRight = UDim.new(0, 9), Parent = tag})
    corner(tag, 99)
    stroke(tag, C.Stroke, 0.55)
    local close = mk("TextButton", {Size = UDim2.fromOffset(28, 28), AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, 0, 0, 0), BackgroundColor3 = Color3.new(1, 1, 1),
        BackgroundTransparency = 0.9, AutoButtonColor = false, Text = "\195\151", TextColor3 = C.Text, Font = Enum.Font.GothamBold, TextSize = 18, Parent = head})
    corner(close, 99)
    stroke(close, C.Stroke, 0.6)
    local closeScale = mk("UIScale", {Scale = 1, Parent = close})
    close.MouseEnter:Connect(function() tween(closeScale, 0.15, {Scale = 1.06}) end)
    close.MouseLeave:Connect(function() tween(closeScale, 0.2, {Scale = 1}) end)
    close.MouseButton1Down:Connect(function() tween(closeScale, 0.08, {Scale = 0.94}) end)
    close.MouseButton1Up:Connect(function() tween(closeScale, 0.3, {Scale = 1}, Enum.EasingStyle.Back) end)

    mk("Frame", {Size = UDim2.new(1, 0, 0, 1), BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 0.88, BorderSizePixel = 0, LayoutOrder = 2, Parent = body})
    local msg = mk("TextLabel", {Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Text = t("msg"), TextColor3 = C.Text,
        Font = Enum.Font.GothamMedium, TextSize = 13, LineHeight = 1.15, TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top,
        LayoutOrder = 3, Parent = body})

    local track = mk("Frame", {Size = UDim2.new(1, 0, 0, 3), BackgroundColor3 = C.Field, BorderSizePixel = 0, ClipsDescendants = true, LayoutOrder = 4, Parent = body})
    corner(track, 99)
    local fill = mk("Frame", {Size = UDim2.fromScale(1, 1), BackgroundColor3 = C.Accent, BorderSizePixel = 0, Parent = track})
    corner(fill, 99)

    local state = {closed = false}
    local function refresh()
        tag.Text = t("tag")
        msg.Text = t("msg")
    end
    task.spawn(function()
        local ok, translator = pcall(function() return LocalizationService:GetTranslatorForPlayerAsync(player) end)
        if ok and translator then
            lang = pickLang(translator.LocaleId)
            refresh()
            pcall(function()
                translator:GetPropertyChangedSignal("LocaleId"):Connect(function() lang = pickLang(translator.LocaleId) refresh() end)
            end)
        end
    end)

    local function dismiss()
        if state.closed then return end
        state.closed = true
        pcall(function() ringSpin:Cancel() end)
        tween(panel, 0.3, {Position = UDim2.new(0.5, 0, 0, -(panel.AbsoluteSize.Y + 30))}, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        local out = tween(scale, 0.3, {Scale = 0.9}, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        out.Completed:Wait()
        if gui.Parent then gui:Destroy() end
    end
    close.Activated:Connect(function() task.spawn(dismiss) end)

    tween(panel, 0.55, {Position = UDim2.new(0.5, 0, 0, 12)}, Enum.EasingStyle.Back)
    tween(scale, 0.45, {Scale = 1}, Enum.EasingStyle.Back)
    if type(M.DURATION) == "number" and M.DURATION > 0 then
        tween(fill, M.DURATION, {Size = UDim2.fromScale(0, 1)}, Enum.EasingStyle.Linear)
        task.delay(M.DURATION, function() task.spawn(dismiss) end)
    else
        track.Visible = false
    end
end

if HydraKey.ENABLED then
    if not HydraKey.run() then return end
else
    task.spawn(HydraKey.maintenance)
end

local Hydra = loadstring(HydraKey.lib or game:HttpGet(HYDRA_URL))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

local Core = {steps = {}, preSteps = {}, hooked = false, safeMode = false}
pcall(function()
    if identifyexecutor then
        Core.safeMode = string.find(string.lower(tostring(identifyexecutor())), "solara", 1, true) ~= nil
    end
end)

function Core.module(...)
    local node = ReplicatedStorage
    for _, name in ipairs({...}) do
        node = node and node:FindFirstChild(name)
    end
    return node
end

function Core.hook()
    if Core.hooked then return true end
    if Core.safeMode then
        RunService.Stepped:Connect(function(_, dt)
            local char = LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if not hrp or not hum or hum.Health <= 0 then return end
            local ctx = {char = char, root = hrp, hum = hum, dt = dt, grounded = hum.FloorMaterial ~= Enum.Material.Air,
                jumpHeld = hum.Jump == true, jump = function() hum:ChangeState(Enum.HumanoidStateType.Jumping) end}
            for _, fn in pairs(Core.steps) do pcall(fn, ctx) end
        end)
        Core.hooked = true
        return true
    end
    local moduleScript = Core.module("Objects", "Game", "Character", "Client", "Movement")
    if not moduleScript then return false end
    local ok, Movement = pcall(require, moduleScript)
    if not ok or type(Movement) ~= "table" or type(Movement.Update) ~= "function" then return false end
    local old = Movement.Update
    Movement.Update = function(self, dt, ...)

        if self.Character and self.Character == LocalPlayer.Character then
            for _, fn in pairs(Core.preSteps) do pcall(fn, self) end
        end
        old(self, dt, ...)
        if not (self.Character and self.Character == LocalPlayer.Character) then return end
        local hrp = self.Character:FindFirstChild("HumanoidRootPart")
        local hum = self.Character:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum or hum.Health <= 0 then return end
        local okG, g = pcall(function() return self.DataRegistry:Get("Grounded") end)
        local ctx = {char = self.Character, root = hrp, hum = hum, dt = tonumber(dt) or (1 / 60), registry = self.DataRegistry,
            grounded = (okG and g ~= nil) and (g == true) or (not (okG and g ~= nil) and hum.FloorMaterial ~= Enum.Material.Air),
            jumpHeld = self.JumpHeldDown == true, movement = self, jump = function() pcall(function() self:AttemptJump() end) end}
        for _, fn in pairs(Core.steps) do pcall(fn, ctx) end
    end
    Core.hooked = true
    return true
end

function Core.setModifier(name, value)
    if not Core.safeMode then
        local ok = pcall(function()
            local service = require(Core.module("Services", "Asset", "CharacterService"))
            local data = service:GetCharacterFromPlayer(LocalPlayer)
            local stats = data.Movement.MoveStats
            stats.Modifiers = stats.Modifiers or {}
            stats.Modifiers[name] = value
            stats:Reset()
        end)
        if ok then return true end
    end
    local fire = firesignal
    local char = LocalPlayer.Character
    local tag = char and char:GetAttribute("Tag")
    local event = Core.module("Events", "CharacterTask")
    if type(fire) ~= "function" or not tag or not event then return false end
    return (pcall(fire, event.OnClientEvent, tag, "ModifyMovement", {name, value}))
end

local SP = {Enabled = false, Value = 55, Token = 0, SPRINT_CAP = 2}
function SP.apply()
    if SP.Enabled then return Core.setModifier("Speed", SP.Value * 90 / SP.SPRINT_CAP) end
    return Core.setModifier("Speed", nil)
end
LocalPlayer.CharacterAdded:Connect(function()
    SP.Token = SP.Token + 1
    local token = SP.Token
    if not SP.Enabled then return end
    task.spawn(function()
        for _ = 1, 20 do
            task.wait(0.5)
            if token ~= SP.Token or not SP.Enabled then return end
            if SP.apply() then return end
        end
    end)
end)

local AJ = {Enabled = false, Height = 10, Token = 0}
function AJ.apply()
    if AJ.Enabled then return Core.setModifier("JumpHeight", AJ.Height) end
    return Core.setModifier("JumpHeight", nil)
end
LocalPlayer.CharacterAdded:Connect(function()
    AJ.Token = AJ.Token + 1
    local token = AJ.Token
    if not AJ.Enabled then return end
    task.spawn(function()
        for _ = 1, 20 do
            task.wait(0.5)
            if token ~= AJ.Token or not AJ.Enabled then return end
            if AJ.apply() then return end
        end
    end)
end)

local Front = {rays = RaycastParams.new()}
Front.rays.FilterType = Enum.RaycastFilterType.Exclude
pcall(function() Front.rays.RespectCanCollide = true end)

function Front.obstacle(char, root, dir, speed)
    local ignore = {char}
    for _, name in ipairs({"Players", "Rigs"}) do
        local folder = workspace:FindFirstChild(name)
        if folder then ignore[#ignore + 1] = folder end
    end
    Front.rays.FilterDescendantsInstances = ignore
    local dist = math.clamp(speed * 0.15, 5, 12)
    local hit = workspace:Raycast(root.Position - Vector3.new(0, 1.5, 0), dir * dist, Front.rays)
    if not hit or hit.Normal.Y > 0.9 then return nil end
    local isRamp = hit.Normal.Y >= 0.2
    if not isRamp then
        local n = Vector3.new(hit.Normal.X, 0, hit.Normal.Z)
        if n.Magnitude > 0.05 and dir:Dot(-n.Unit) < 0.3 then return nil end
    end
    return hit, isRamp
end

function Front.lift(root, vy)
    local v = root.AssemblyLinearVelocity
    if v.Y < vy then root.AssemblyLinearVelocity = Vector3.new(v.X, vy, v.Z) end
end

function Front.new(sign)
    local F = {
        Enabled = false, Sign = sign, MaxSpeed = 99, Accel = 9, Smooth = true, FollowMove = false,
        RampPower = 42, RampMult = 1.55, BoostManual = false,
        Speed = 0, Dir = Vector3.new(1, 0, 0), Seen = 0, LastAuto = 0, LastAir = 0, WasGrounded = true, OurJumpUntil = 0,
    }
    function F.wantedDir(hum)
        if F.FollowMove then
            local md = hum.MoveDirection
            return md.Magnitude > 0.05 and Vector3.new(md.X, 0, md.Z).Unit or nil
        end
        local cam = workspace.CurrentCamera
        if not cam then return nil end
        local look = cam.CFrame.LookVector * F.Sign
        local flat = Vector3.new(look.X, 0, look.Z)
        return flat.Magnitude > 0.05 and flat.Unit or nil
    end

    function F.step(ctx)
        if not F.Enabled then F.Speed = 0 return end
        local hum, root = ctx.hum, ctx.root
        local grounded = ctx.grounded
        if ctx.registry then
            local okG, g = pcall(function() return ctx.registry:Get("Grounded") end)
            grounded = (okG and g ~= nil) and (g == true) or hum.FloorMaterial ~= Enum.Material.Air
        end
        local dir = F.wantedDir(hum)
        local moving = dir ~= nil and (not F.FollowMove or hum.MoveDirection.Magnitude > 0.05)
        if dir then F.Dir = dir end
        local target = moving and F.MaxSpeed or 0
        if F.Smooth then
            local rate = target > F.Speed and F.Accel or F.Accel * 0.6
            F.Speed = F.Speed + (target - F.Speed) * math.min(rate * ctx.dt, 1)
        else
            F.Speed = target
        end
        local vel = F.Dir * F.Speed
        if ctx.registry then pcall(function() ctx.registry:Set("Velocity", vel * 90) end) end
        local cur = root.AssemblyLinearVelocity
        root.AssemblyLinearVelocity = Vector3.new(vel.X, cur.Y, vel.Z)

        local now = os.clock()
        local lift = F.RampPower * F.RampMult * 0.8
        if moving and F.Speed > 3 then
            local hit = Front.obstacle(ctx.char, root, F.Dir, F.Speed)
            F.Seen = hit and F.Seen + 1 or 0
            if F.Seen < 2 then hit = nil end
            if hit then
                if grounded and now - F.LastAuto > 0.45 then
                    F.LastAuto = now
                    F.OurJumpUntil = now + 0.4
                    ctx.jump()
                    task.delay(0.1, function() if root.Parent then Front.lift(root, lift) end end)
                elseif not grounded and now - F.LastAir > 0.3 then
                    F.LastAir = now
                    Front.lift(root, lift * 0.6)
                end
            end
        end

        if F.BoostManual and ctx.jumpHeld and F.WasGrounded and not grounded and now > F.OurJumpUntil then
            F.OurJumpUntil = now + 0.4
            Front.lift(root, lift)
        end
        F.WasGrounded = grounded
    end
    return F
end

local SF = Front.new(1)
local BF = Front.new(-1)
Core.steps.speedFront = SF.step
Core.steps.backFront = BF.step

local SWJ = {Enabled = false, Power = 34, Delay = 0, AirMult = 1, OnlyMoving = true, GroundSpeed = 0, Last = 0}
Core.steps.speedWithJump = function(ctx)
    if not SWJ.Enabled then return end
    local md = ctx.hum.MoveDirection
    local moving = md.Magnitude > 0.05
    local now = os.clock()
    local flat = Vector3.new(ctx.root.AssemblyLinearVelocity.X, 0, ctx.root.AssemblyLinearVelocity.Z)
    if ctx.grounded then
        if moving then SWJ.GroundSpeed = flat.Magnitude end
        if (moving or not SWJ.OnlyMoving) and now - SWJ.Last >= SWJ.Delay + 0.15 then
            SWJ.Last = now
            ctx.jump()
            local root = ctx.root
            task.delay(0.05, function() if root.Parent then Front.lift(root, SWJ.Power) end end)
        end
    elseif moving and not SF.Enabled and not BF.Enabled and SWJ.GroundSpeed > 1 then
        local vel = Vector3.new(md.X, 0, md.Z).Unit * SWJ.GroundSpeed * SWJ.AirMult
        if ctx.registry then pcall(function() ctx.registry:Set("Velocity", vel * 90) end) end
        ctx.root.AssemblyLinearVelocity = Vector3.new(vel.X, ctx.root.AssemblyLinearVelocity.Y, vel.Z)
    end
end

local IS = {Enabled = false, Boost = 8, Applied = nil, ExitUntil = 0, Cap = 3000, Jumped = false,
    SLIDES = {Slide = true, EmotingSlide = true, CarrySlide = true}}
function IS.crouchHeld(movement)
    local ok, held = pcall(function() return movement.DataRegistry:Get("CrouchKey") end)
    return ok and held == true
end
function IS.setFriction(movement, value)
    if IS.Applied == value then return end
    IS.Applied = value
    pcall(function()
        local stats = movement.MoveStats
        stats.Modifiers = stats.Modifiers or {}
        stats.Modifiers.Friction = value
        stats:Reset()
    end)
end
function IS.exitGuard(movement)
    local cap = IS.Cap
    local v = movement.DataRegistry:Get("Velocity")
    if typeof(v) == "Vector3" and v.Magnitude > cap then movement.DataRegistry:Set("Velocity", v.Unit * cap) end
    local root = movement.Character and movement.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local av = root.AssemblyLinearVelocity
    local flat = Vector3.new(av.X, 0, av.Z)
    local vy = av.Y
    if movement.JumpHeldDown == true then IS.Jumped = true end
    if not IS.Jumped and vy > 4 then vy = 0 end
    if flat.Magnitude > cap / 90 then flat = flat.Unit * (cap / 90) end
    root.AssemblyLinearVelocity = Vector3.new(flat.X, vy, flat.Z)
end

Core.preSteps.infiniteSlide = function(movement)
    if os.clock() < IS.ExitUntil then pcall(IS.exitGuard, movement) end
    if IS.Applied == nil or IS.crouchHeld(movement) then return end
    IS.setFriction(movement, nil)
    pcall(function()
        local stats = movement.MoveStats.MoveStats
        IS.Cap = (tonumber(stats.Speed) or 1500) * (tonumber(stats.SprintCap) or 2)
    end)
    IS.Jumped = movement.JumpHeldDown == true
    IS.ExitUntil = os.clock() + 0.4
    pcall(IS.exitGuard, movement)
end

Core.steps.infiniteSlide = function(ctx)
    local movement = ctx.movement
    if not movement then return end
    local sliding = IS.Enabled and IS.SLIDES[movement.State] == true and IS.crouchHeld(movement)
    IS.setFriction(movement, sliding and -IS.Boost or nil)
end

local AC = {Enabled = false, Rate = 1.5, Down = false, Next = 0, Movement = nil}
Core.steps.autoCrouch = function(ctx)
    if not AC.Enabled or not ctx.movement then return end
    AC.Movement = ctx.movement
    local now = os.clock()
    if now < AC.Next then return end
    AC.Next = now + 1 / math.max(AC.Rate, 0.5)
    AC.Down = not AC.Down
    pcall(function() ctx.movement:KeyUsed({Key = "Crouching", Down = AC.Down}) end)
end
function AC.release()
    if AC.Down and AC.Movement then pcall(function() AC.Movement:KeyUsed({Key = "Crouching", Down = false}) end) end
    AC.Down = false
end

local JL = {Enabled = false, Layers = 3, Token = 0}
function JL.apply()
    if JL.Enabled then return Core.setModifier("JumpCap", JL.Layers + 1) end
    return Core.setModifier("JumpCap", nil)
end

LocalPlayer.CharacterAdded:Connect(function()
    JL.Token = JL.Token + 1
    local token = JL.Token
    if not JL.Enabled then return end
    task.spawn(function()
        for _ = 1, 20 do
            task.wait(0.5)
            if token ~= JL.Token or not JL.Enabled then return end
            if JL.apply() then return end
        end
    end)
end)

local Paint = {WHITE = Color3.new(1, 1, 1), DARK = Color3.fromRGB(28, 28, 32), last = setmetatable({}, {__mode = "k"})}

function Paint.lock(inst, prop, convert)
    if not inst then return end
    local function apply()
        local current = inst[prop]
        if Paint.last[inst] == current then return end
        local wanted = convert(current)
        Paint.last[inst] = wanted
        if current ~= wanted then inst[prop] = wanted end
    end
    inst:GetPropertyChangedSignal(prop):Connect(apply)
    apply()
end

function Paint.white() return Paint.WHITE end

function Paint.downed(color)
    local t = math.clamp((1 - color.R) / (1 - 20 / 255), 0, 1)
    return Paint.WHITE:Lerp(Paint.DARK, t)
end

function Paint.notice(frame)
    local skull = frame:FindFirstChild("Skull")
    local arrow = frame:FindFirstChild("Arrow")
    local arrowImage = arrow and arrow:FindFirstChild("ImageLabel")
    if skull and skull:IsA("ImageLabel") then Paint.lock(skull, "ImageColor3", Paint.downed) end
    if arrowImage and arrowImage:IsA("ImageLabel") then Paint.lock(arrowImage, "ImageColor3", Paint.downed) end
end

Paint.spin = {}
RunService.Heartbeat:Connect(function(dt)
    for gradient in pairs(Paint.spin) do
        if gradient.Parent then
            gradient.Rotation = (gradient.Rotation + dt * 45) % 360
        else
            Paint.spin[gradient] = nil
        end
    end
end)

function Paint.shine(label)
    if not label then return end
    local gradient = label:FindFirstChildOfClass("UIGradient") or Instance.new("UIGradient")
    gradient.Color = ColorSequence.new(Paint.WHITE)
    gradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.3), NumberSequenceKeypoint.new(0.5, 0), NumberSequenceKeypoint.new(1, 0.3),
    })
    gradient.Rotation = 0
    gradient.Offset = Vector2.new(-1, 0)
    gradient.Parent = label
    game:GetService("TweenService"):Create(gradient, TweenInfo.new(2.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, false, 1), {Offset = Vector2.new(1, 0)}):Play()
end

function Paint.roundTimer(container)
    local box = container:WaitForChild("RoundTimer", 15)
    if not box then return end
    local timer = box:FindFirstChild("Timer")
    local about = box:FindFirstChild("About")
    local stroke = box:FindFirstChildOfClass("UIStroke")

    Paint.lock(container, "Visible", function() return true end)
    Paint.lock(box, "Visible", function() return true end)

    Paint.lock(timer, "TextColor3", Paint.white)
    Paint.lock(about, "TextColor3", Paint.white)
    Paint.lock(box:FindFirstChild("ImageLabel"), "ImageColor3", Paint.white)
    Paint.lock(stroke, "Color", Paint.white)

    Paint.shine(timer)
    Paint.shine(about)
    if stroke then
        local light = stroke:FindFirstChildOfClass("UIGradient") or Instance.new("UIGradient")
        light.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(70, 74, 86)), ColorSequenceKeypoint.new(0.45, Paint.WHITE),
            ColorSequenceKeypoint.new(0.55, Paint.WHITE), ColorSequenceKeypoint.new(1, Color3.fromRGB(70, 74, 86)),
        })
        light.Transparency = NumberSequence.new(0)
        light.Rotation = 0
        light.Parent = stroke
        Paint.spin[light] = true
    end
    if timer then
        local pulse = timer:FindFirstChild("HydraPulse") or Instance.new("UIScale")
        pulse.Name = "HydraPulse"
        pulse.Parent = timer
        local tweens = game:GetService("TweenService")
        timer:GetPropertyChangedSignal("Text"):Connect(function()
            local seconds = tonumber(string.match(timer.Text, ":(%d+)$"))
            local minutes = tonumber(string.match(timer.Text, "^(%d+):"))
            local last = minutes == 0 and seconds and seconds <= 10
            pulse.Scale = last and 1.18 or 1.07
            tweens:Create(pulse, TweenInfo.new(last and 0.45 or 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()
        end)
    end

    local ingame = container:FindFirstChild("IngameRoundTimer")
    local ingameTimer = ingame and ingame:FindFirstChild("Timer")
    if ingameTimer and timer then
        Paint.lock(ingame, "Visible", function() return false end)
        ingameTimer:GetPropertyChangedSignal("Text"):Connect(function()
            if timer.Text ~= ingameTimer.Text then timer.Text = ingameTimer.Text end
        end)
    end
end

function Paint.hookGame(gameGui)
    task.spawn(function()
        local hud = gameGui:WaitForChild("HUD", 15)
        if not hud then return end
        local notices = hud:WaitForChild("Notices", 15)
        if notices then
            for _, child in ipairs(notices:GetChildren()) do Paint.notice(child) end
            notices.ChildAdded:Connect(function(child) task.defer(Paint.notice, child) end)
        end
        local ok, health = pcall(function()
            return hud:WaitForChild("Overlay", 15):WaitForChild("CharacterStatus", 15):WaitForChild("BottomLeft", 15):WaitForChild("Health", 15)
        end)
        if ok and health then
            Paint.lock(health:FindFirstChild("HealthIcon"), "ImageColor3", Paint.white)
            Paint.lock(health:FindFirstChild("Health"), "TextColor3", Paint.white)
            local background = health:FindFirstChild("BackgroundStroke")
            Paint.lock(background and background:FindFirstChildOfClass("UIStroke"), "Color", Paint.white)
        end
        local okRound, roundTimer = pcall(function()
            return hud:WaitForChild("Overlay", 15):WaitForChild("RoundOverlay", 15):WaitForChild("RoundTimer", 15)
        end)
        if okRound and roundTimer then Paint.roundTimer(roundTimer) end
    end)
end

do
    local playerGui = LocalPlayer:WaitForChild("PlayerGui")
    local current = playerGui:FindFirstChild("Game")
    if current then Paint.hookGame(current) end

    playerGui.ChildAdded:Connect(function(child)
        if child.Name == "Game" and child:IsA("ScreenGui") then Paint.hookGame(child) end
    end)
end

Hydra:AddTranslations({
    ["Movimiento"] = "Movement", ["MOVER"] = "MOVE", ["Velocidad"] = "Speed", ["Salto"] = "Jump",
    ["Te lleva hacia adelante sin trabarse"] = "Takes you forward without getting stuck",
    ["Velocidad m\195\161xima"] = "Max speed", ["Hasta qu\195\169 velocidad llega"] = "How fast it gets",
    ["Aceleraci\195\179n"] = "Acceleration", ["Qu\195\169 tan r\195\161pido llega a la velocidad"] = "How fast it reaches the speed",
    ["Multiplicador de rampa"] = "Ramp multiplier", ["Cu\195\161nto te impulsa una rampa"] = "How hard a ramp launches you",
    ["Fuerza de rampa"] = "Ramp power", ["Fuerza base del salto en rampas"] = "Base jump power on ramps",
    ["Potenciar mis saltos"] = "Boost my jumps", ["Tus saltos usan la fuerza y el multiplicador de rampa"] = "Your jumps use the ramp power and multiplier",
    ["Suave"] = "Smooth", ["Acelera y frena de a poco"] = "Speeds up and slows down gradually",
    ["Seguir movimiento"] = "Follow movement", ["Va hacia donde camin\195\161s, no hacia la c\195\161mara"] = "Goes where you walk, not where the camera looks",
    ["Saltos extra en el aire"] = "Extra jumps in the air",
    ["Capas"] = "Layers", ["Cu\195\161ntas veces pod\195\169s saltar en el aire"] = "How many times you can jump in the air",
    ["No disponible en este ejecutor"] = "Not available on this executor",
    ["Te lleva hacia atr\195\161s sin trabarse"] = "Takes you backwards without getting stuck",
    ["Va hacia donde camin\195\161s, no hacia atr\195\161s de la c\195\161mara"] = "Goes where you walk, not behind the camera",
    ["Salta solo y segu\195\173s caminando normal en el aire"] = "Jumps by itself and you keep walking normally in the air",
    ["Fuerza de salto"] = "Jump power", ["Qu\195\169 tan alto salta"] = "How high it jumps",
    ["Espera entre saltos"] = "Delay between jumps", ["Pausa al tocar el piso"] = "Pause when touching the ground",
    ["Velocidad en el aire"] = "Air speed", ["1x = la misma que al caminar"] = "1x = the same as walking",
    ["Solo al caminar"] = "Only while walking", ["Si no te mov\195\169s, no salta"] = "If you don't move, it doesn't jump",
    ["Se agacha y se levanta solo"] = "Crouches and stands up by itself",
    ["Cambia qu\195\169 tan r\195\161pido corr\195\169s"] = "Changes how fast you run",
    ["El slide no frena mientras manten\195\169s agacharte"] = "The slide never slows down while you hold crouch",
    ["Velocidad del slide"] = "Slide speed", ["M\195\161s alto = acelera m\195\161s r\195\161pido"] = "Higher = speeds up faster",
    ["Qu\195\169 tan alto salt\195\161s"] = "How high you jump", ["Altura"] = "Height", ["Normal del juego: 3"] = "Game default: 3", ["Normal del juego: 33"] = "Game default: 33",
    ["Ritmo"] = "Rate", ["Cambios por segundo"] = "Changes per second",
})

local TabMove = Hydra:Tab({Id = "Move", Title = "Movimiento", Caption = "MOVER", Icon = "rbxassetid://130468910849957"})

local FA = {Enabled = false, Speed = 42, current = 42, acc = 0, lastTick = tick(), lastJump = tick(), wasAir = false, bv = nil, INTERVAL = 0.65}
function FA.inEmote()
    local ok, value = pcall(function()
        local svc = require(Core.module("Services", "Asset", "CharacterService"))
        return svc:GetCharacterFromPlayer(LocalPlayer).DataRegistry:Get("Emote")
    end)
    return ok and value ~= nil and value ~= false and value ~= 0
end
function FA.push(root, velocity)
    if not FA.bv or not FA.bv.Parent or FA.bv.Parent ~= root then
        if FA.bv then pcall(function() FA.bv:Destroy() end) end
        FA.bv = Instance.new("BodyVelocity")
        FA.bv.MaxForce = Vector3.new(4e5, 0, 4e5)
        FA.bv.P = 1250
        FA.bv.Parent = root
    end
    FA.bv.Velocity = velocity
end
function FA.step()
    if not FA.Enabled then
        if FA.bv then pcall(function() FA.bv:Destroy() end) end
        FA.bv = nil
        return
    end
    local dt = tick() - FA.lastTick
    FA.lastTick = tick()
    local base = math.clamp(tonumber(FA.Speed) or 42, 30, 110)
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChild("Humanoid")
    if not root or not hum then return end
    local isAir = hum.FloorMaterial == Enum.Material.Air
    local st = hum:GetState()
    local isOnGround = (st == Enum.HumanoidStateType.Landed or st == Enum.HumanoidStateType.Running) and not isAir
    if FA.wasAir and isOnGround then
        FA.current = base
        FA.acc = 0
    end
    FA.wasAir = isAir
    local cam = workspace.CurrentCamera
    local look = cam and cam.CFrame.LookVector or Vector3.new(0, 0, -1)
    look = Vector3.new(look.X, 0, look.Z)
    if look.Magnitude ~= 0 then look = look.Unit end
    if isAir then
        FA.push(root, look * FA.current)
        return
    end
    FA.acc = FA.acc + dt
    while FA.acc >= 0.04 do
        FA.acc = FA.acc - 0.04
        FA.current = math.min(base + 10, FA.current + 0.3)
    end
    FA.push(root, look * FA.current)
    FA.current = math.max(base, FA.current - 2.5 * dt)
    if tick() - FA.lastJump >= FA.INTERVAL and not FA.inEmote() then
        hum:ChangeState(Enum.HumanoidStateType.Jumping)
        FA.lastJump = tick()
    end
end
RunService.Heartbeat:Connect(function() pcall(FA.step) end)

Hydra:AddTranslations({
    ["Impulso"] = "Boost", ["Te empuja hacia donde mir\195\161s y salta solo"] = "Pushes you where you look and jumps by itself",
    ["Velocidad del impulso"] = "Boost speed",
})
TabMove:Section("Impulso", "\226\158\164")
local FastAccel = TabMove:Toggle({Id = "fastAccel", Title = "Fast Acceleration", Desc = "Te empuja hacia donde mir\195\161s y salta solo", Icon = "\226\158\164", Keybind = true, Floating = true,
    Callback = function(on)
        FA.Enabled = on
        FA.lastJump = tick()
        FA.current = FA.Speed
    end})
FastAccel:Slider({Id = "fastAccelSpeed", Title = "Impulso", Desc = "Velocidad del impulso", Min = 30, Max = 110, Step = 1, Default = 42,
    Callback = function(v)
        FA.Speed = math.clamp(tonumber(v) or 42, 30, 110)
        if FA.Enabled then FA.current = FA.Speed end
    end})
FA.Speed = Hydra.Options.fastAccelSpeed:Get()
FA.current = FA.Speed

TabMove:Section("Velocidad", "\226\151\183")
local Speed
Speed = TabMove:Toggle({Id = "speedMain", Title = "Speed", Desc = "Cambia qu\195\169 tan r\195\161pido corr\195\169s", Icon = "\226\151\183", Keybind = true, Floating = true,
    Callback = function(on)
        SP.Enabled = on
        if not SP.apply() and on then
            Hydra:Notify("Speed: No disponible en este ejecutor")
            SP.Enabled = false
            task.defer(function() Speed:Set(false, true) end)
        end
    end})
Speed:Slider({Id = "speedValue", Title = "Velocidad", Desc = "Normal del juego: 33", Min = 1, Max = 400, Step = 1, Default = 55,
    Callback = function(v)
        SP.Value = v
        if SP.Enabled then SP.apply() end
    end})
SP.Value = Hydra.Options.speedValue:Get()

local function frontToggle(F, other, otherId, prefix, title, desc, icon, followDesc)
    local toggle
    toggle = TabMove:Toggle({Id = prefix == "sf" and "speedFront" or "backFront", Title = title, Desc = desc, Icon = icon, Keybind = true, Floating = true,
        Callback = function(on)
            if on and not Core.hook() then
                Hydra:Notify(title .. ": No disponible en este ejecutor")
                task.defer(function() toggle:Set(false, true) end)
                return
            end
            F.Enabled = on
            F.Speed = 0

            if on and other.Enabled and Hydra.Options[otherId] then Hydra.Options[otherId]:Set(false) end
        end})
    toggle:Slider({Id = prefix .. "Speed", Title = "Velocidad m\195\161xima", Desc = "Hasta qu\195\169 velocidad llega", Min = 10, Max = 200, Step = 1, Default = 99,
        Callback = function(v) F.MaxSpeed = v end})
    toggle:Slider({Id = prefix .. "Accel", Title = "Aceleraci\195\179n", Desc = "Qu\195\169 tan r\195\161pido llega a la velocidad", Min = 1, Max = 30, Step = 1, Default = 9,
        Callback = function(v) F.Accel = v end})
    toggle:Slider({Id = prefix .. "RampMult", Title = "Multiplicador de rampa", Desc = "Cu\195\161nto te impulsa una rampa", Min = 0.1, Max = 5, Step = 0.05, Default = 1.55, Suffix = "x",
        Callback = function(v) F.RampMult = v end})
    toggle:Slider({Id = prefix .. "RampPower", Title = "Fuerza de rampa", Desc = "Fuerza base del salto en rampas", Min = 30, Max = 110, Step = 1, Default = 42,
        Callback = function(v) F.RampPower = v end})
    toggle:Toggle({Id = prefix .. "Smooth", Title = "Suave", Desc = "Acelera y frena de a poco", Default = true,
        Callback = function(on) F.Smooth = on end})
    toggle:Toggle({Id = prefix .. "Follow", Title = "Seguir movimiento", Desc = followDesc,
        Callback = function(on) F.FollowMove = on end})
    toggle:Toggle({Id = prefix .. "Boost", Title = "Potenciar mis saltos", Desc = "Tus saltos usan la fuerza y el multiplicador de rampa",
        Callback = function(on) F.BoostManual = on end})

    F.MaxSpeed = Hydra.Options[prefix .. "Speed"]:Get()
    F.Accel = Hydra.Options[prefix .. "Accel"]:Get()
    F.RampMult = Hydra.Options[prefix .. "RampMult"]:Get()
    F.RampPower = Hydra.Options[prefix .. "RampPower"]:Get()
    F.Smooth = Hydra.Options[prefix .. "Smooth"]:Get()
    F.FollowMove = Hydra.Options[prefix .. "Follow"]:Get()
    F.BoostManual = Hydra.Options[prefix .. "Boost"]:Get()
    return toggle
end
frontToggle(SF, BF, "backFront", "sf", "Speed Front", "Te lleva hacia adelante sin trabarse", "rbxassetid://116954340494960", "Va hacia donde camin\195\161s, no hacia la c\195\161mara")
frontToggle(BF, SF, "speedFront", "bf", "Back Front", "Te lleva hacia atr\195\161s sin trabarse", "rbxassetid://116954340494960", "Va hacia donde camin\195\161s, no hacia atr\195\161s de la c\195\161mara")

local SpeedWithJump
SpeedWithJump = TabMove:Toggle({Id = "speedWithJump", Title = "Speed with jump", Desc = "Salta solo y segu\195\173s caminando normal en el aire", Icon = "\226\151\142", Keybind = true, Floating = true,
    Callback = function(on)
        if on and not Core.hook() then
            Hydra:Notify("Speed with jump: No disponible en este ejecutor")
            task.defer(function() SpeedWithJump:Set(false, true) end)
            return
        end
        SWJ.Enabled = on
        SWJ.GroundSpeed = 0
    end})
SpeedWithJump:Slider({Id = "swjPower", Title = "Fuerza de salto", Desc = "Qu\195\169 tan alto salta", Min = 20, Max = 90, Step = 1, Default = 34,
    Callback = function(v) SWJ.Power = v end})
SpeedWithJump:Slider({Id = "swjDelay", Title = "Espera entre saltos", Desc = "Pausa al tocar el piso", Min = 0, Max = 1, Step = 0.05, Default = 0, Suffix = " s",
    Callback = function(v) SWJ.Delay = v end})
SpeedWithJump:Slider({Id = "swjAir", Title = "Velocidad en el aire", Desc = "1x = la misma que al caminar", Min = 0.5, Max = 2, Step = 0.05, Default = 1, Suffix = "x",
    Callback = function(v) SWJ.AirMult = v end})
SpeedWithJump:Toggle({Id = "swjOnlyMoving", Title = "Solo al caminar", Desc = "Si no te mov\195\169s, no salta", Default = true,
    Callback = function(on) SWJ.OnlyMoving = on end})
SWJ.Power = Hydra.Options.swjPower:Get()
SWJ.Delay = Hydra.Options.swjDelay:Get()
SWJ.AirMult = Hydra.Options.swjAir:Get()
SWJ.OnlyMoving = Hydra.Options.swjOnlyMoving:Get()

local InfiniteSlide
InfiniteSlide = TabMove:Toggle({Id = "infiniteSlide", Title = "Infinite Slide", Desc = "El slide no frena mientras manten\195\169s agacharte", Icon = "\226\156\166", Keybind = true, Floating = true,
    Callback = function(on)
        if on and (Core.safeMode or not Core.hook()) then
            Hydra:Notify("Infinite Slide: No disponible en este ejecutor")
            task.defer(function() InfiniteSlide:Set(false, true) end)
            return
        end
        IS.Enabled = on
    end})
InfiniteSlide:Slider({Id = "isBoost", Title = "Velocidad del slide", Desc = "M\195\161s alto = acelera m\195\161s r\195\161pido", Min = 1, Max = 150, Step = 1, Default = 8,
    Callback = function(v) IS.Boost = v end})
IS.Boost = Hydra.Options.isBoost:Get()

local AutoCrouch
AutoCrouch = TabMove:Toggle({Id = "autoCrouch", Title = "Auto Crouch", Desc = "Se agacha y se levanta solo", Icon = "\226\156\166", Keybind = true, Floating = true,
    Callback = function(on)
        if on and (Core.safeMode or not Core.hook()) then
            Hydra:Notify("Auto Crouch: No disponible en este ejecutor")
            task.defer(function() AutoCrouch:Set(false, true) end)
            return
        end
        AC.Enabled = on
        AC.Next = 0
        if not on then AC.release() end
    end})
AutoCrouch:Slider({Id = "acRate", Title = "Ritmo", Desc = "Cambios por segundo", Min = 0.5, Max = 100, Step = 0.5, Default = 1.5, Suffix = "/s",
    Callback = function(v) AC.Rate = v end})
AC.Rate = Hydra.Options.acRate:Get()

TabMove:Section("Salto", "\226\151\142")
local JumpLayers
JumpLayers = TabMove:Toggle({Id = "jumpLayers", Title = "Jump Layers", Desc = "Saltos extra en el aire", Icon = "rbxassetid://88035054740813", Keybind = true, Floating = true,
    Callback = function(on)
        JL.Enabled = on
        if not JL.apply() and on then
            Hydra:Notify("Jump Layers: No disponible en este ejecutor")
            JL.Enabled = false
            task.defer(function() JumpLayers:Set(false, true) end)
        end
    end})
JumpLayers:Slider({Id = "jlLayers", Title = "Capas", Desc = "Cu\195\161ntas veces pod\195\169s saltar en el aire", Min = 1, Max = 50, Step = 1, Default = 3,
    Callback = function(v)
        JL.Layers = v
        if JL.Enabled then JL.apply() end
    end})

JL.Layers = Hydra.Options.jlLayers:Get()

local AdjustJump
AdjustJump = TabMove:Toggle({Id = "adjustJump", Title = "Adjust Jump", Desc = "Qu\195\169 tan alto salt\195\161s", Icon = "\226\151\142", Keybind = true, Floating = true,
    Callback = function(on)
        AJ.Enabled = on
        if not AJ.apply() and on then
            Hydra:Notify("Adjust Jump: No disponible en este ejecutor")
            AJ.Enabled = false
            task.defer(function() AdjustJump:Set(false, true) end)
        end
    end})
AdjustJump:Slider({Id = "ajHeight", Title = "Altura", Desc = "Normal del juego: 3", Min = 1, Max = 100, Step = 0.5, Default = 10,
    Callback = function(v)
        AJ.Height = v
        if AJ.Enabled then AJ.apply() end
    end})
AJ.Height = Hydra.Options.ajHeight:Get()

local More = {}
function More.service()
    if More.svc then return More.svc end
    local ok, svc = pcall(function() return require(Core.module("Services", "Asset", "CharacterService")) end)
    if ok and type(svc) == "table" then More.svc = svc end
    return More.svc
end
function More.data(player)
    local svc = More.service()
    if not svc then return nil end
    local ok, data = pcall(function() return svc:GetCharacterFromPlayer(player) end)
    return ok and data or nil
end
function More.reg(data, key)
    local ok, value = pcall(function() return data.DataRegistry:Get(key) end)
    if ok then return value end
    return nil
end
function More.isSet(value) return value ~= nil and value ~= false and value ~= 0 end
function More.myRoot()
    local char = LocalPlayer.Character
    return char and char:FindFirstChild("HumanoidRootPart")
end
function More.event(name) return Core.module("Events", name) end

local AutoCarry = {Enabled = false, Range = 30, Interval = 0.2, Last = 0,
    STATES = {Carry = true, CarrySlide = true, CarrySlideAir = true, CarryAir = true, Carried = true, CarryMove = true, CarryIdle = true}}
function AutoCarry.ragdolled(player, data)
    local char = player.Character
    if not char then return false end
    if char:FindFirstChild("RagdollConstraints") then return true end
    if data and More.reg(data, "Ragdolling") then return true end
    if char.PrimaryPart and char.PrimaryPart.Anchored then return true end
    return false
end
function AutoCarry.step()
    local root = More.myRoot()
    if not root then return end
    local me = More.data(LocalPlayer)
    local movement = me and me.Movement
    if not movement or AutoCarry.STATES[movement.State] then return end
    local interact = More.event("Interact")
    if not interact then return end
    local now = tick()
    if now - AutoCarry.Last < AutoCarry.Interval then return end
    for _, other in ipairs(Players:GetPlayers()) do
        if other ~= LocalPlayer then
            local char = other.Character
            local data = char and More.data(other)
            if data and More.reg(data, "Downed") and not AutoCarry.ragdolled(other, data) then
                local otherRoot = char:FindFirstChild("HumanoidRootPart")
                if otherRoot and (root.Position - otherRoot.Position).Magnitude <= AutoCarry.Range then
                    local tag = char:GetAttribute("Tag")
                    if tag then
                        pcall(function() interact:FireServer("Carry", tag) end)
                        AutoCarry.Last = now
                        break
                    end
                end
            end
        end
    end
end
task.spawn(function()
    while true do
        if AutoCarry.Enabled then pcall(AutoCarry.step) end
        task.wait(AutoCarry.Interval > 0 and AutoCarry.Interval or 0.2)
    end
end)

local AutoRevive = {Enabled = false, Range = 30}
task.spawn(function()
    while true do
        task.wait(0.5)
        if AutoRevive.Enabled then
            pcall(function()
                local root = More.myRoot()
                local interact = More.event("Interact")
                local me = More.data(LocalPlayer)
                if not root or not interact or (me and More.reg(me, "Downed")) then return end
                for _, other in ipairs(Players:GetPlayers()) do
                    if not AutoRevive.Enabled then return end
                    local char = other ~= LocalPlayer and other.Character
                    local otherRoot = char and char:FindFirstChild("HumanoidRootPart")
                    local data = otherRoot and More.data(other)
                    local tag = char and char:GetAttribute("Tag")
                    if data and tag and More.reg(data, "Downed") and (otherRoot.Position - root.Position).Magnitude <= AutoRevive.Range then
                        interact:FireServer("Revive", tag, true)
                        task.wait(tonumber(More.reg(data, "ReviveLength")) or 1.5)
                        if AutoRevive.Enabled and More.reg(data, "Downed") and otherRoot.Parent
                            and (otherRoot.Position - root.Position).Magnitude <= AutoRevive.Range then
                            interact:FireServer("Revive", tag)
                        end
                    end
                end
            end)
        end
    end
end)

local AutoSpawn = {Enabled = false, Last = 0}
task.spawn(function()
    while true do
        task.wait(0.2)
        if AutoSpawn.Enabled and os.clock() - AutoSpawn.Last >= 3 then
            pcall(function()
                local me = More.data(LocalPlayer)
                local remote = More.event("SetPlayerMode")
                if me and remote and More.reg(me, "Downed") then
                    AutoSpawn.Last = os.clock()
                    remote:FireServer(true)
                end
            end)
        end
    end
end)

local ESP = {
    entries = {},
    Players = {Enabled = false, MaxDist = 1500, Names = true, Health = true, Arrows = true, Tracers = false, Outline = true},
    Downed = {Enabled = false, MaxDist = 3000, Arrows = true, Outline = true},
    WHITE = Color3.new(1, 1, 1), RED = Color3.fromRGB(255, 92, 92), DIM = Color3.fromRGB(190, 196, 210),
}
function ESP.gui()
    if ESP.screen and ESP.screen.Parent then return ESP.screen end
    local screen = Instance.new("ScreenGui")
    screen.Name = "HydraESP"
    screen.ResetOnSpawn = false
    screen.IgnoreGuiInset = true
    screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screen.DisplayOrder = 5
    local ok = pcall(function() screen.Parent = (type(gethui) == "function" and gethui()) or game:GetService("CoreGui") end)
    if not ok or not screen.Parent then screen.Parent = LocalPlayer:WaitForChild("PlayerGui") end
    ESP.screen = screen
    return screen
end
function ESP.label(parent, size, font, color)
    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, 0, 0, size + 3)
    label.Font = font
    label.TextSize = size
    label.TextColor3 = color
    label.Text = ""
    local outline = Instance.new("UIStroke")
    outline.Thickness = 1.3
    outline.Transparency = 0.25
    outline.Parent = label
    label.Parent = parent
    return label
end
function ESP.bar(parent, width)
    local back = Instance.new("Frame")
    back.Size = UDim2.fromOffset(width, 4)
    back.BackgroundColor3 = Color3.fromRGB(20, 22, 28)
    back.BackgroundTransparency = 0.25
    back.BorderSizePixel = 0
    Instance.new("UICorner", back).CornerRadius = UDim.new(1, 0)
    local fill = Instance.new("Frame")
    fill.Size = UDim2.fromScale(1, 1)
    fill.BackgroundColor3 = ESP.WHITE
    fill.BorderSizePixel = 0
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
    fill.Parent = back
    back.Parent = parent
    return back, fill
end

function ESP.entry(player)
    local e = ESP.entries[player]
    if e then return e end
    local screen = ESP.gui()
    e = {}
    local bb = Instance.new("BillboardGui")
    bb.Name = "HydraESP_" .. player.Name
    bb.Size = UDim2.fromOffset(170, 58)
    bb.StudsOffset = Vector3.new(0, 3.2, 0)
    bb.AlwaysOnTop = true
    bb.LightInfluence = 0
    bb.Enabled = false
    local list = Instance.new("UIListLayout")
    list.HorizontalAlignment = Enum.HorizontalAlignment.Center
    list.VerticalAlignment = Enum.VerticalAlignment.Bottom
    list.Padding = UDim.new(0, 2)
    list.SortOrder = Enum.SortOrder.LayoutOrder
    list.Parent = bb
    e.tag = ESP.label(bb, 10, Enum.Font.GothamBlack, ESP.RED)
    e.tag.LayoutOrder = 1
    e.name = ESP.label(bb, 13, Enum.Font.GothamBold, ESP.WHITE)
    e.name.LayoutOrder = 2
    e.info = ESP.label(bb, 11, Enum.Font.GothamSemibold, ESP.DIM)
    e.info.LayoutOrder = 3
    e.barBack, e.bar = ESP.bar(bb, 64)
    e.barBack.LayoutOrder = 4
    bb.Parent = screen
    e.bb = bb

    local arrow = Instance.new("Frame")
    arrow.Size = UDim2.fromOffset(46, 46)
    arrow.AnchorPoint = Vector2.new(0.5, 0.5)
    arrow.BackgroundTransparency = 1
    arrow.Visible = false
    local tip = Instance.new("Frame")
    tip.Size = UDim2.fromOffset(12, 12)
    tip.AnchorPoint = Vector2.new(0.5, 0.5)
    tip.Position = UDim2.new(0.5, 0, 0, 4)
    tip.Rotation = 45
    tip.BorderSizePixel = 0
    tip.BackgroundColor3 = ESP.WHITE
    tip.Parent = arrow
    local dot = Instance.new("Frame")
    dot.Size = UDim2.fromOffset(30, 30)
    dot.AnchorPoint = Vector2.new(0.5, 0.5)
    dot.Position = UDim2.fromScale(0.5, 0.55)
    dot.BackgroundColor3 = Color3.fromRGB(14, 15, 20)
    dot.BackgroundTransparency = 0.25
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
    local dotStroke = Instance.new("UIStroke")
    dotStroke.Thickness = 1.5
    dotStroke.Color = ESP.WHITE
    dotStroke.Parent = dot
    dot.Parent = arrow
    local dist = Instance.new("TextLabel")
    dist.BackgroundTransparency = 1
    dist.Size = UDim2.fromScale(1, 1)
    dist.Font = Enum.Font.GothamBlack
    dist.TextSize = 9
    dist.TextColor3 = ESP.WHITE
    dist.Parent = dot
    arrow.Parent = screen

    local arrowName = Instance.new("TextLabel")
    arrowName.BackgroundTransparency = 1
    arrowName.AnchorPoint = Vector2.new(0.5, 0)
    arrowName.Position = UDim2.new(0.5, 0, 1, 2)
    arrowName.Size = UDim2.fromOffset(90, 12)
    arrowName.Font = Enum.Font.GothamBold
    arrowName.TextSize = 10
    arrowName.TextColor3 = ESP.WHITE
    local nameOutline = Instance.new("UIStroke")
    nameOutline.Thickness = 1.2
    nameOutline.Transparency = 0.3
    nameOutline.Parent = arrowName
    arrowName.Parent = dot
    e.arrow, e.tip, e.dot, e.dotStroke, e.arrowText, e.arrowName = arrow, tip, dot, dotStroke, dist, arrowName

    local line = Instance.new("Frame")
    line.AnchorPoint = Vector2.new(0.5, 0.5)
    line.BorderSizePixel = 0
    line.BackgroundTransparency = 0.35
    line.Visible = false
    line.Parent = screen
    e.line = line
    ESP.entries[player] = e
    return e
end
function ESP.remove(player)
    local e = ESP.entries[player]
    if not e then return end
    pcall(function() e.bb:Destroy() end)
    pcall(function() e.arrow:Destroy() end)
    pcall(function() e.line:Destroy() end)
    if e.hl then pcall(function() e.hl:Destroy() end) end
    ESP.entries[player] = nil
end
Players.PlayerRemoving:Connect(ESP.remove)
function ESP.hide(e)
    e.bb.Enabled = false
    e.arrow.Visible = false
    e.line.Visible = false
    if e.hl then e.hl.Enabled = false end
end

function ESP.rigModel(char)
    if ESP.rigService == nil then
        local ok, svc = pcall(function() return require(Core.module("Services", "Asset", "RigService")) end)
        ESP.rigService = (ok and type(svc) == "table") and svc or false
    end
    local tag = char:GetAttribute("Tag")
    if ESP.rigService and tag then
        local ok, rig = pcall(function() return ESP.rigService:GetRigFromTag(tag) end)
        if ok and rig and typeof(rig.Model) == "Instance" and rig.Model:IsA("Model") and rig.Model.Parent then return rig.Model end
    end
    return char
end
function ESP.template()
    if ESP.whistle == nil then
        local found = Core.module("Objects", "Game", "Character", "ActionVisuals", "Actions", "Whistle")
        ESP.whistle = found and found:FindFirstChild("WhistleHighlight") or false
    end
    return ESP.whistle or nil
end
function ESP.outline(e, char, model, color, on)
    if not on then
        if e.hl then e.hl.Enabled = false end
        return
    end
    if not e.hl or e.hl.Parent ~= char then
        if e.hl then pcall(function() e.hl:Destroy() end) end
        local template = ESP.template()
        local hl = template and template:Clone() or Instance.new("Highlight")
        hl.Name = "HydraHL"
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        if not template then
            hl.FillTransparency = 0.5
            hl.OutlineTransparency = 0
        end
        hl.Parent = char
        e.hl = hl
    end
    e.hl.Adornee = model
    e.hl.FillColor = color
    e.hl.OutlineColor = color
    e.hl.Enabled = true
end
function ESP.step()
    local cam = workspace.CurrentCamera
    local myRoot = More.myRoot()
    local screen = ESP.screen
    if not cam or not screen then return end
    local view = cam.ViewportSize
    local center = Vector2.new(view.X / 2, view.Y / 2)
    local radius = math.min(view.X, view.Y) * 0.36
    local anyOn = ESP.Players.Enabled or ESP.Downed.Enabled
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local char = player.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            local e = anyOn and root and ESP.entry(player)
            if e then
                local data = More.data(player)
                local downed = data and More.reg(data, "Downed") == true
                local cfg = downed and ESP.Downed or ESP.Players

                if downed and not ESP.Downed.Enabled then cfg, downed = ESP.Players, false end

                local distance = (root.Position - (myRoot and myRoot.Position or cam.CFrame.Position)).Magnitude
                if not cfg.Enabled or distance > cfg.MaxDist then
                    ESP.hide(e)
                else
                    local color = downed and ESP.RED or ESP.WHITE
                    local model = ESP.rigModel(char)
                    ESP.outline(e, char, model, color, cfg.Outline)

                    e.bb.Adornee = model:FindFirstChild("Head", true) or root
                    e.bb.Enabled = true
                    e.tag.Visible = downed
                    if downed then
                        local carried = More.isSet(More.reg(data, "Carried"))
                        e.tag.Text = Hydra:T(carried and "CARGADO" or "DERRIBADO")
                    end
                    e.name.Visible = downed or cfg.Names
                    e.name.Text = player.DisplayName
                    e.name.TextColor3 = color
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    local health = data and tonumber(More.reg(data, "Health")) or (hum and hum.Health) or 0
                    e.info.Text = math.floor(distance + 0.5) .. "m" .. ((not downed and cfg.Health) and ("  \194\183  " .. math.floor(health + 0.5) .. " hp") or "")
                    local showBar = downed or cfg.Health
                    e.barBack.Visible = showBar
                    if showBar then
                        local fraction
                        if downed then
                            fraction = math.clamp(tonumber(More.reg(data, "DownedPeriod")) or 1, 0, 1)
                        else
                            local maxHealth = hum and hum.MaxHealth or 100
                            fraction = math.clamp(health / math.max(maxHealth, 1), 0, 1)
                        end
                        e.bar.Size = UDim2.fromScale(fraction, 1)
                        e.bar.BackgroundColor3 = downed and ESP.RED:Lerp(Color3.fromRGB(90, 20, 20), 1 - fraction) or ESP.WHITE
                    end

                    local point, onScreen = cam:WorldToViewportPoint(root.Position)
                    local visible = onScreen and point.Z > 0
                    if not visible and cfg.Arrows then
                        local rel = cam.CFrame:PointToObjectSpace(root.Position)
                        local angle = math.atan2(rel.X, -rel.Z)
                        e.arrow.Position = UDim2.fromOffset(center.X + math.sin(angle) * radius, center.Y - math.cos(angle) * radius)
                        e.arrow.Rotation = math.deg(angle)
                        e.dot.Rotation = -math.deg(angle)
                        e.tip.BackgroundColor3 = color
                        e.dotStroke.Color = color
                        e.arrowText.Text = math.floor(distance + 0.5) .. "m"
                        e.arrowName.Text = player.DisplayName
                        e.arrowName.TextColor3 = color
                        e.arrowText.TextColor3 = color
                        e.arrow.Visible = true
                    else
                        e.arrow.Visible = false
                    end
                    if visible and not downed and cfg.Tracers then
                        local from = Vector2.new(center.X, view.Y - 6)
                        local to = Vector2.new(point.X, point.Y)
                        local delta = to - from
                        e.line.Size = UDim2.fromOffset(delta.Magnitude, 1.5)
                        e.line.Position = UDim2.fromOffset((from.X + to.X) / 2, (from.Y + to.Y) / 2)
                        e.line.Rotation = math.deg(math.atan2(delta.Y, delta.X))
                        e.line.BackgroundColor3 = color
                        e.line.Visible = true
                    else
                        e.line.Visible = false
                    end
                end
            elseif ESP.entries[player] then
                ESP.hide(ESP.entries[player])
            end
        end
    end
end
RunService.RenderStepped:Connect(function()
    if ESP.Players.Enabled or ESP.Downed.Enabled then
        pcall(ESP.step)
    elseif ESP.screen then
        for _, e in pairs(ESP.entries) do ESP.hide(e) end
    end
end)

local Farm = {Enabled = false, Return = true, Busy = false}
function Farm.tickets()
    local effects = workspace:FindFirstChild("Effects")
    local folder = effects and effects:FindFirstChild("Tickets")
    local list = {}
    if folder then
        for _, model in ipairs(folder:GetChildren()) do
            if model:IsA("Model") and model.PrimaryPart then list[#list + 1] = model end
        end
    end
    return list
end
function Farm.canMove()
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local me = More.data(LocalPlayer)
    return hum and hum.Health > 0 and not (me and More.reg(me, "Downed"))
end

function Farm.travel(root, target)
    if not Farm.Enabled or not root.Parent then return false end
    root.CFrame = CFrame.new(target)
    root.AssemblyLinearVelocity = Vector3.zero
    return true
end
task.spawn(function()
    while true do
        task.wait(0.5)
        if Farm.Enabled and not Farm.Busy and Farm.canMove() then
            local list = Farm.tickets()
            local root = More.myRoot()
            if #list > 0 and root then
                Farm.Busy = true
                pcall(function()
                    local home = root.CFrame
                    for _ = 1, #list do
                        if not Farm.Enabled or not Farm.canMove() then break end

                        local best, bestDist
                        for _, model in ipairs(Farm.tickets()) do
                            local d = (model.PrimaryPart.Position - root.Position).Magnitude
                            if not bestDist or d < bestDist then best, bestDist = model, d end
                        end
                        if not best then break end

                        local target = best.PrimaryPart.Position + Vector3.new(0, 2, 0)
                        local stopped = false
                        while best.Parent and best.PrimaryPart do
                            if not Farm.Enabled or not Farm.canMove() or not root.Parent then stopped = true break end
                            if (root.Position - target).Magnitude > 6 then Farm.travel(root, target) end
                            task.wait(0.1)
                        end
                        if stopped then break end
                    end

                    if More.afkReturn and More.afkReturn() then return end
                    if Farm.Return and Farm.Enabled and Farm.canMove() and root.Parent then Farm.travel(root, home.Position) end
                end)
                Farm.Busy = false
            end
        end
    end
end)

local AFK = {Enabled = false, Home = nil, Platform = nil, SPOT = Vector3.new(9000, 1600, 9000), LOGO = "rbxassetid://114974832117287"}
function AFK.build()
    if AFK.Platform and AFK.Platform.Parent then return AFK.Platform end
    local model = Instance.new("Model")
    model.Name = "HydraAFK"
    local base = Instance.new("Part")
    base.Name = "Base"
    base.Size = Vector3.new(70, 4, 70)
    base.Anchored = true
    base.CanCollide = true
    base.Material = Enum.Material.SmoothPlastic
    base.Color = Color3.fromRGB(14, 15, 20)
    base.CFrame = CFrame.new(AFK.SPOT)
    base.Parent = model
    for _, face in ipairs({Enum.NormalId.Top, Enum.NormalId.Bottom}) do
        local decal = Instance.new("Decal")
        decal.Face = face
        decal.Texture = AFK.LOGO
        decal.Parent = base
    end

    local edge = Instance.new("SelectionBox")
    edge.Adornee = base
    edge.LineThickness = 0.25
    edge.Color3 = Color3.fromRGB(235, 238, 245)
    edge.SurfaceTransparency = 1
    edge.Parent = base
    local light = Instance.new("PointLight")
    light.Range = 40
    light.Brightness = 1.5
    light.Color = Color3.fromRGB(235, 238, 245)
    light.Parent = base
    model.PrimaryPart = base
    model.Parent = workspace
    AFK.Platform = model
    return model
end
function AFK.goUp()
    local root = More.myRoot()
    if not root then return false end
    AFK.build()
    root.CFrame = CFrame.new(AFK.SPOT + Vector3.new(0, 6, 0))
    root.AssemblyLinearVelocity = Vector3.zero
    return true
end
function AFK.set(on)
    AFK.Enabled = on
    More.afkReturn = on and function() return AFK.Enabled and AFK.goUp() end or nil
    local root = More.myRoot()
    if on then
        AFK.Home = root and root.CFrame or nil
        AFK.goUp()
    else
        if root and AFK.Home then
            root.CFrame = AFK.Home
            root.AssemblyLinearVelocity = Vector3.zero
        end
        AFK.Home = nil
        if AFK.Platform then AFK.Platform:Destroy() AFK.Platform = nil end
    end
end

task.spawn(function()
    while true do
        task.wait(0.25)
        if AFK.Enabled then
            pcall(function()
                local root = More.myRoot()

                if root and not Farm.Busy and (root.Position - AFK.SPOT).Magnitude > 80 then AFK.goUp() end
            end)
        end
    end
end)

LocalPlayer.Idled:Connect(function()
    if not AFK.Enabled then return end
    pcall(function()
        local vu = game:GetService("VirtualUser")
        vu:CaptureController()
        vu:ClickButton2(Vector2.new())
    end)
end)

local AntiBot = {Enabled = false, Distance = 10, Cooldown = 0.15, Last = 0, rays = RaycastParams.new(), acc = 0}
AntiBot.rays.FilterType = Enum.RaycastFilterType.Exclude
function AntiBot.ignore(char)
    local list = {char}
    for _, name in ipairs({"Players", "Rigs"}) do
        local folder = workspace:FindFirstChild(name)
        if folder then list[#list + 1] = folder end
    end
    return list
end
function AntiBot.safeSpot(candidate, char)
    AntiBot.rays.FilterDescendantsInstances = AntiBot.ignore(char)
    local down = workspace:Raycast(candidate + Vector3.new(0, 50, 0), Vector3.new(0, -1000, 0), AntiBot.rays)
    if not down then return nil end
    local spot = Vector3.new(candidate.X, down.Position.Y + 3, candidate.Z)
    if workspace:Raycast(spot, Vector3.new(0, 5, 0), AntiBot.rays) then return nil end
    return spot
end
function AntiBot.step()
    local now = os.clock()
    if now - AntiBot.Last < AntiBot.Cooldown or AFK.Enabled or Farm.Busy then return end
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local svc = More.service()
    local me = More.data(LocalPlayer)
    if not root or not svc or not me then return end
    if More.reg(me, "Downed") or More.isSet(More.reg(me, "Carried")) then return end
    local ok, chars = pcall(function() return svc:GetCharacters() end)
    if not ok or type(chars) ~= "table" then return end
    local myPos = root.Position
    local bots, nearest, nearestDist = {}, nil, math.huge
    local alive = {}
    for _, v in pairs(chars) do
        if type(v) == "table" and v.Done and v.PrimaryPart then
            local okPos, pos = pcall(function() return v.PrimaryPart.Position end)
            if okPos then
                if v.AI == true then
                    bots[#bots + 1] = pos
                    local d = (pos - myPos).Magnitude
                    if d < nearestDist then nearest, nearestDist = pos, d end
                elseif not v.Local and v.PlayerReference and not More.reg(v, "Downed") and not More.isSet(More.reg(v, "Carried")) then
                    alive[#alive + 1] = pos
                end
            end
        end
    end
    if not nearest or nearestDist >= AntiBot.Distance then return end
    local function clearance(p)
        local m = math.huge
        for _, b in ipairs(bots) do m = math.min(m, (b - p).Magnitude) end
        return m
    end
    local candidates = {}
    local away = (myPos - nearest) * Vector3.new(1, 0, 1)
    away = away.Magnitude < 0.1 and Vector3.new(1, 0, 0) or away.Unit
    for _, angle in ipairs({0, 35, -35, 70, -70}) do
        local dir = CFrame.Angles(0, math.rad(angle), 0):VectorToWorldSpace(away)
        for _, radius in ipairs({45, 70, 35}) do candidates[#candidates + 1] = myPos + dir * radius end
    end
    for _, pos in ipairs(alive) do
        candidates[#candidates + 1] = pos + Vector3.new(math.random(-5, 5), 0, math.random(-5, 5))
    end
    local minSafe = math.max(AntiBot.Distance * 2, 30)
    local best, bestScore, checks = nil, -math.huge, 0
    for _, c in ipairs(candidates) do
        local score = clearance(c)
        if score >= minSafe and score > bestScore then
            checks = checks + 1
            local spot = AntiBot.safeSpot(c, char)
            if spot then best, bestScore = spot, score end
            if checks >= 12 then break end
        end
    end
    if not best then return end
    local look = (best - nearest) * Vector3.new(1, 0, 1)
    root.CFrame = look.Magnitude > 0.1 and CFrame.new(best, best + look) or CFrame.new(best)
    AntiBot.Last = now
end
RunService.Heartbeat:Connect(function(dt)
    if not AntiBot.Enabled then return end
    AntiBot.acc = AntiBot.acc + dt
    if AntiBot.acc < 0.1 then return end
    AntiBot.acc = 0
    pcall(AntiBot.step)
end)

Hydra:AddTranslations({
    ["Ayuda"] = "Help", ["Visual"] = "Visual", ["Farm"] = "Farm",
    ["Carga solo a los derribados cerca tuyo"] = "Carries nearby downed players by itself",
    ["Distancia"] = "Range", ["Hasta qu\195\169 distancia act\195\186a"] = "How far it works", ["Espera"] = "Delay", ["Entre intentos"] = "Between attempts",
    ["Revive solo a los derribados cerca tuyo"] = "Revives nearby downed players by itself",
    ["Si qued\195\161s derribado, vuelve a aparecer solo"] = "If you get downed, you respawn by itself",
    ["ESP jugadores"] = "Player ESP", ["Encontr\195\161 a todos, incluso a trav\195\169s de paredes"] = "Find everyone, even through walls",
    ["Distancia m\195\161xima"] = "Max distance", ["M\195\161s lejos no se muestra"] = "Farther away is hidden",
    ["Nombres"] = "Names", ["Vida"] = "Health", ["Flechas en el borde"] = "Edge arrows", ["Apuntan a los que no ves"] = "Point at the ones you can't see",
    ["L\195\173neas"] = "Lines", ["Desde abajo de la pantalla hasta cada uno"] = "From the bottom of the screen to each one",
    ["Contorno"] = "Outline", ["Silueta a trav\195\169s de paredes"] = "Silhouette through walls",
    ["ESP derribados"] = "Downed ESP", ["Derribados con su tiempo restante"] = "Downed players with their remaining time",
    ["Auto farm tickets"] = "Auto farm tickets", ["Junta los tickets del mapa solo"] = "Collects the map tickets by itself",
    ["Velocidad de viaje"] = "Travel speed", ["Qu\195\169 tan r\195\161pido va a cada ticket"] = "How fast it goes to each ticket",
    ["Directo"] = "Instant", ["Aparece en el ticket sin deslizarse"] = "Appears on the ticket without gliding",
    ["Volver"] = "Return", ["Al terminar vuelve a donde estabas"] = "When done, goes back to where you were",
    ["DERRIBADO"] = "DOWNED", ["CARGADO"] = "CARRIED",
    ["Te deja en una plataforma en el cielo, lejos de todo"] = "Leaves you on a platform in the sky, far from everything",
    ["Te aleja de los nextbots cuando se acercan"] = "Moves you away from nextbots when they get close",
    ["Distancia de reacci\195\179n"] = "Reaction distance", ["Si un bot est\195\161 m\195\161s cerca, te mueve"] = "If a bot is closer, it moves you",
    ["Entre teletransportes"] = "Between teleports",
})
ESP.gui()
local TabMore = Hydra:Tab({Id = "More", Title = "More", Caption = "MORE", Icon = "rbxassetid://114688401779019"})

TabMore:Section("Ayuda", "\226\156\166")
local CarryToggle = TabMore:Toggle({Id = "autoCarry", Title = "Auto Carry", Desc = "Carga solo a los derribados cerca tuyo", Icon = "\226\156\166", Keybind = true, Floating = true,
    Callback = function(on) AutoCarry.Enabled = on end})
CarryToggle:Slider({Id = "carryRange", Title = "Distancia", Desc = "Hasta qu\195\169 distancia act\195\186a", Min = 5, Max = 60, Step = 1, Default = 30, Suffix = " m",
    Callback = function(v) AutoCarry.Range = v end})
CarryToggle:Slider({Id = "carryDelay", Title = "Espera", Desc = "Entre intentos", Min = 0.05, Max = 1, Step = 0.05, Default = 0.2, Suffix = " s",
    Callback = function(v) AutoCarry.Interval = v end})
local ReviveToggle = TabMore:Toggle({Id = "autoRevive", Title = "Auto Revive", Desc = "Revive solo a los derribados cerca tuyo", Icon = "\226\156\166", Keybind = true, Floating = true,
    Callback = function(on) AutoRevive.Enabled = on end})
ReviveToggle:Slider({Id = "reviveRange", Title = "Distancia", Desc = "Hasta qu\195\169 distancia act\195\186a", Min = 5, Max = 30, Step = 1, Default = 30, Suffix = " m",
    Callback = function(v) AutoRevive.Range = v end})
TabMore:Toggle({Id = "autoSpawn", Title = "Auto Spawn", Desc = "Si qued\195\161s derribado, vuelve a aparecer solo", Icon = "\226\156\166", Keybind = true, Floating = true,
    Callback = function(on) AutoSpawn.Enabled = on end})
local AntiBotToggle = TabMore:Toggle({Id = "antiBot", Title = "Anti Bot", Desc = "Te aleja de los nextbots cuando se acercan", Icon = "\226\156\166", Keybind = true, Floating = true,
    Callback = function(on) AntiBot.Enabled = on end})
AntiBotToggle:Slider({Id = "antiBotDist", Title = "Distancia de reacci\195\179n", Desc = "Si un bot est\195\161 m\195\161s cerca, te mueve", Min = 1, Max = 25, Step = 1, Default = 10, Suffix = " m",
    Callback = function(v) AntiBot.Distance = v end})
AntiBotToggle:Slider({Id = "antiBotCd", Title = "Espera", Desc = "Entre teletransportes", Min = 0.05, Max = 2, Step = 0.05, Default = 0.15, Suffix = " s",
    Callback = function(v) AntiBot.Cooldown = v end})

TabMore:Section("Visual", "\226\151\142")
local EspToggle = TabMore:Toggle({Id = "espPlayers", Title = "ESP jugadores", Desc = "Encontr\195\161 a todos, incluso a trav\195\169s de paredes", Icon = "\226\151\142", Keybind = true, Floating = true,
    Callback = function(on) ESP.Players.Enabled = on end})
EspToggle:Slider({Id = "espDist", Title = "Distancia m\195\161xima", Desc = "M\195\161s lejos no se muestra", Min = 50, Max = 5000, Step = 50, Default = 1500, Suffix = " m",
    Callback = function(v) ESP.Players.MaxDist = v end})
EspToggle:Toggle({Id = "espNames", Title = "Nombres", Default = true, Callback = function(on) ESP.Players.Names = on end})
EspToggle:Toggle({Id = "espHealth", Title = "Vida", Default = true, Callback = function(on) ESP.Players.Health = on end})
EspToggle:Toggle({Id = "espArrows", Title = "Flechas en el borde", Desc = "Apuntan a los que no ves", Default = true, Callback = function(on) ESP.Players.Arrows = on end})
EspToggle:Toggle({Id = "espLines", Title = "L\195\173neas", Desc = "Desde abajo de la pantalla hasta cada uno", Callback = function(on) ESP.Players.Tracers = on end})
EspToggle:Toggle({Id = "espOutline", Title = "Contorno", Desc = "Silueta a trav\195\169s de paredes", Default = true, Callback = function(on) ESP.Players.Outline = on end})
local DownToggle = TabMore:Toggle({Id = "espDowned", Title = "ESP derribados", Desc = "Derribados con su tiempo restante", Icon = "\226\151\142", Keybind = true, Floating = true,
    Callback = function(on) ESP.Downed.Enabled = on end})
DownToggle:Slider({Id = "espDownDist", Title = "Distancia m\195\161xima", Desc = "M\195\161s lejos no se muestra", Min = 50, Max = 5000, Step = 50, Default = 3000, Suffix = " m",
    Callback = function(v) ESP.Downed.MaxDist = v end})
DownToggle:Toggle({Id = "espDownArrows", Title = "Flechas en el borde", Desc = "Apuntan a los que no ves", Default = true, Callback = function(on) ESP.Downed.Arrows = on end})
DownToggle:Toggle({Id = "espDownOutline", Title = "Contorno", Desc = "Silueta a trav\195\169s de paredes", Default = true, Callback = function(on) ESP.Downed.Outline = on end})

TabMore:Section("Farm", "\226\158\164")
TabMore:Toggle({Id = "afk", Title = "AFK", Desc = "Te deja en una plataforma en el cielo, lejos de todo", Icon = "\226\158\164", Keybind = true, Floating = true,
    Callback = function(on) AFK.set(on) end})
local FarmToggle = TabMore:Toggle({Id = "ticketFarm", Title = "Auto farm tickets", Desc = "Junta los tickets del mapa solo", Icon = "\226\158\164", Keybind = true, Floating = true,
    Callback = function(on) Farm.Enabled = on end})
FarmToggle:Toggle({Id = "farmReturn", Title = "Volver", Desc = "Al terminar vuelve a donde estabas", Default = true, Callback = function(on) Farm.Return = on end})

AutoCarry.Range, AutoCarry.Interval = Hydra.Options.carryRange:Get(), Hydra.Options.carryDelay:Get()
AutoRevive.Range = Hydra.Options.reviveRange:Get()
ESP.Players.MaxDist, ESP.Players.Names, ESP.Players.Health = Hydra.Options.espDist:Get(), Hydra.Options.espNames:Get(), Hydra.Options.espHealth:Get()
ESP.Players.Arrows, ESP.Players.Tracers, ESP.Players.Outline = Hydra.Options.espArrows:Get(), Hydra.Options.espLines:Get(), Hydra.Options.espOutline:Get()
ESP.Downed.MaxDist, ESP.Downed.Arrows, ESP.Downed.Outline = Hydra.Options.espDownDist:Get(), Hydra.Options.espDownArrows:Get(), Hydra.Options.espDownOutline:Get()
Farm.Return = Hydra.Options.farmReturn:Get()
AntiBot.Distance, AntiBot.Cooldown = Hydra.Options.antiBotDist:Get(), Hydra.Options.antiBotCd:Get()

getgenv().HydraScriptText = function(es, en)
    Hydra:AddTranslations({[es] = en})
    return Hydra:T(es)
end
do
local GENV = (type(getgenv) == "function" and getgenv()) or _G
if GENV.HydraUnlockAll and GENV.HydraUnlockAll.Disable then
    pcall(GENV.HydraUnlockAll.Disable)
end

GENV.HydraUnlockAll = (function()
    local M = {}

    local Players = game:GetService("Players")
    local RS = game:GetService("ReplicatedStorage")
    local StarterGui = game:GetService("StarterGui")
    local LP = Players.LocalPlayer

    local PREFIX = "[Hydra-UnlockAll]"
    local LOG = {}
    local function log(...)
        local parts = {}
        for i = 1, select("#", ...) do
            parts[i] = tostring((select(i, ...)))
        end
        local line = PREFIX .. " " .. table.concat(parts, " ")
        LOG[#LOG + 1] = line
        if #LOG > 200 then
            table.remove(LOG, 1)
        end
    end

    local function path(root, ...)
        local cur = root
        for _, name in ipairs({ ... }) do
            if not cur then
                return nil
            end
            cur = cur:WaitForChild(name, 10)
        end
        return cur
    end

    local function req(label, ...)
        local names = { ... }
        local ok, res = pcall(function()
            local inst = path(RS, table.unpack(names))
            if not inst then
                error("no se encontro la ruta")
            end
            return require(inst)
        end)
        if not ok then
            log("FALLO cargando", label, "->", tostring(res))
            return nil
        end
        return res
    end

    local active = false
    local gen = 0
    local patches = {}
    local patchResults = {}

    local fakeE = {}
    local fakeC = {}
    local pending = nil
    local popupInst = nil
    local warnedOverlay = false
    local lastBuild = {}

    local emoteOn, cosOn = false, false

    local UA2 = {
        fakeS = {},
        SKINS = {},
        SKINSET = {},
        skinOn = false,
        extraLocked = false,
        slotsOn = false,
        warnedNoBase = false,
    }
    local fakeS = UA2.fakeS

    local Registry, Inventory, Loadout, PopupService, EmotePopup, EmoteClass, ItemSvc, RigClass, DataRegClass
    local PackageMod, SlotsView
    local EventSvc, ShopsSvc

    local origGetOwned, origOwns, origIsEquipped, origGetFromSlot, origSlotTypeForSlot, origSetEquipped
    local ItemSlotType

    local ALL, ALLSET = {}, {}

    local TYPE_NAMES = { "Cosmetic", "Character", "Unusual", "Perk", "CarryAnimation", "Nametag", "Boombox" }
    local ENABLED, KNOWN = {}, {}
    for _, n in ipairs(TYPE_NAMES) do
        ENABLED[n] = true
        KNOWN[n] = true
    end

    local INGAME = { Perk = true, Nametag = true, Boombox = true }
    local function emptyByType()
        local t = {}
        for _, n in ipairs(TYPE_NAMES) do
            t[n] = {}
        end
        return t
    end
    local BYTYPE = emptyByType()
    local TYPE_OF = {}

    M.Log = LOG
    M.FakeEmotes = fakeE
    M.FakeCosmetics = fakeC
    M.FakeSkins = fakeS
    M.LastBuild = lastBuild

    local function writable(t)
        local function probe()
            return pcall(function()
                t.__hydra_probe = nil
            end)
        end
        if probe() then
            return true
        end
        if type(setreadonly) == "function" then
            pcall(setreadonly, t, false)
        end
        if probe() then
            return true
        end
        if type(make_writeable) == "function" then
            pcall(make_writeable, t)
        end
        return probe()
    end

    local function patch(label, tbl, key, build)
        local orig = tbl[key]
        if type(orig) ~= "function" then
            log("PARCHE NO APLICADO (no existe la funcion):", label)
            patchResults[#patchResults + 1] = { label = label, ok = false }
            return false
        end
        if not writable(tbl) then
            log("PARCHE NO APLICADO (tabla de solo lectura, falta setreadonly):", label)
            patchResults[#patchResults + 1] = { label = label, ok = false }
            return false
        end
        patches[#patches + 1] = { tbl = tbl, key = key, orig = orig }
        tbl[key] = build(orig)
        patchResults[#patchResults + 1] = { label = label, ok = true }
        return true
    end

    local function patchBoth(label, key, build)
        patch("useLoadout." .. label, Loadout, key, build)
        patch("useInventory." .. label, Inventory, key, build)
    end

    local function slotIndex(slot)
        return tonumber(string.match(tostring(slot), "^EmoteSlot_(%d+)$"))
    end

    local function realSlotId(idx)
        local ok, id = pcall(origGetFromSlot, "EmoteSlot_" .. idx)
        if ok and type(id) == "number" then
            return id
        end
        return 0
    end

    local function owns(id)
        local ok, res = pcall(origOwns, id)
        return ok and res == true
    end

    local function pickBase()
        local ok, owned = pcall(origGetOwned, "Emote")
        if not ok or type(owned) ~= "table" then
            return nil
        end
        local list = table.clone(owned)
        table.sort(list)
        for _, id in ipairs(list) do
            if not origIsEquipped(id) then
                return id
            end
        end
        return nil
    end

    local function isExtraSlot(idx)
        return UA2.slotsOn and UA2.extraLocked and type(idx) == "number" and idx > 6
    end

    local function baseEmoteId()
        for i = 1, 6 do
            local id = realSlotId(i)
            if id ~= 0 then
                return id
            end
        end
        return nil
    end

    local function augmentEmotes(list)
        if type(list) ~= "table" or not (UA2.slotsOn and UA2.extraLocked) then
            return list
        end
        local out = table.clone(list)
        local base = baseEmoteId()
        for idx = 7, 12 do
            if fakeE[idx] and base then
                out[idx] = base
            elseif realSlotId(idx) == 0 then
                out[idx] = nil
            end
        end
        if not base and next(fakeE) ~= nil and not UA2.warnedNoBase then
            UA2.warnedNoBase = true
            log("Para usar los slots 7-12 necesitas al menos un emote real equipado en los slots 1-6")
        end
        return out
    end

    local function getPopup()
        if popupInst and popupInst.Frame then
            return popupInst
        end
        if PopupService and type(PopupService.GetPopup) == "function" then
            local ok, p = pcall(PopupService.GetPopup, PopupService, "Emote")
            if ok and p then
                popupInst = p
                return p
            end
        end
        return nil
    end

    local function wheelSlotFrame(popup, idx)
        local wheel = popup.Frame:FindFirstChild(idx <= 6 and "Wheel" or "Wheel2")
        return wheel and wheel:FindFirstChild("Emote" .. ((idx - 1) % 6 + 1))
    end

    local function applyOverlay(popup)
        if not popup or not popup.Frame or type(popup.Emotes) ~= "table" then
            return
        end
        for idx, fid in pairs(fakeE) do
            if popup.Emotes[idx] then
                local ok, err = pcall(function()
                    local sf = wheelSlotFrame(popup, idx)
                    local item = ItemSvc:GetItemFromID(fid)
                    ItemSvc:ClearViewport(sf.ViewportFrame)
                    ItemSvc:CreateViewport(item, sf.ViewportFrame)
                    sf.TextLabel.Text = ItemSvc:GetName(item)
                end)
                if not ok and not warnedOverlay then
                    warnedOverlay = true
                    log("Aviso: no se pudo dibujar el visual en la rueda ->", tostring(err))
                end
            end
        end
    end

    local function refreshWheel()
        local p = getPopup()
        if not p or type(p.Emotes) ~= "table" then
            return
        end
        pcall(origSetEquipped, p, augmentEmotes(p.Emotes))
        applyOverlay(p)
    end

    local function isLocalEmote(self)
        local char = self.Character
        local lc = LP.Character
        if not char or not lc then
            return false
        end
        if char == lc then
            return true
        end
        local a, b = char:GetAttribute("Tag"), lc:GetAttribute("Tag")
        return a ~= nil and a == b
    end

    local function resolveFake(self)
        local mod = self.EmoteModule
        local modId = mod and mod:GetAttribute("ID")
        if not modId then
            return nil
        end
        if pending and tick() - pending.t < 5 then
            local fid = fakeE[pending.slot]
            if fid and (realSlotId(pending.slot) == modId or (isExtraSlot(pending.slot) and pending.base == modId)) then
                pending = nil
                return fid
            end
        end
        for idx = 1, 12 do
            local fid = fakeE[idx]
            if fid and realSlotId(idx) == modId then
                return fid
            end
        end
        return nil
    end

    local function swapTo(fid)
        if type(firesignal) ~= "function" then
            log("Tu ejecutor no tiene firesignal: no se puede cambiar el emote local")
            return
        end
        local char = LP.Character
        local tag = char and char:GetAttribute("Tag")
        if not tag then
            log("No se encontro el Tag del personaje; no se cambia el emote")
            return
        end
        local ok, err = pcall(function()
            local tagBuf = buffer.create(2)
            buffer.writeu16(tagBuf, 0, tag)
            firesignal(RS.Events.UpdateCharacterDataRegistry.OnClientEvent, {
                buffer.fromstring("\24\1"),
                fid,
                tagBuf,
            })
        end)
        if not ok then
            log("Fallo el cambio local de emote ->", tostring(err))
        end
    end

    local function slotType(slot)
        if type(slot) ~= "string" or type(origSlotTypeForSlot) ~= "function" then
            return nil
        end
        local ok, st = pcall(origSlotTypeForSlot, slot)
        if ok and KNOWN[st] then
            return st
        end
        return nil
    end

    local function collectEmoteIds()
        local raw, seen = {}, {}
        local items = RS:FindFirstChild("Items")
        local function walk(parent)
            for _, child in ipairs(parent:GetChildren()) do
                if child:IsA("Folder") then
                    if child.Name == "Emotes" then
                        for _, e in ipairs(child:GetChildren()) do
                            if e:IsA("ModuleScript") then
                                local id = e:GetAttribute("ID")
                                if type(id) == "number" and not seen[id] then
                                    seen[id] = true
                                    raw[#raw + 1] = id
                                end
                            end
                        end
                    else
                        walk(child)
                    end
                end
            end
        end
        if items then
            walk(items)
        end

        local filtered = {}
        for _, id in ipairs(raw) do
            local okSlot, st = pcall(ItemSlotType, id)
            local okReg, entry = pcall(Registry.GetById, id)
            if okSlot and st == "Emote" and okReg and entry and entry.Module then
                filtered[#filtered + 1] = id
            end
        end
        if #filtered == 0 and #raw > 0 then
            log("Aviso: el filtro por slot 'Emote' dejo 0; se usa la lista sin filtrar (", #raw, ")")
            filtered = raw
        end
        table.sort(filtered)
        return filtered, #raw
    end

    local function collectCosmetics()
        local okAll, all = pcall(Registry.GetAll)
        if not okAll or type(all) ~= "table" then
            return nil
        end
        local bytype = emptyByType()
        local typeOf = {}
        local n = 0
        for id in pairs(all) do
            n = n + 1
            if n % 150 == 0 then
                task.wait()
            end
            if type(id) == "number" then
                local ok, st = pcall(ItemSlotType, id)
                if ok and KNOWN[st] then
                    local list = bytype[st]
                    list[#list + 1] = id
                    typeOf[id] = st
                end
            end
        end
        for _, list in pairs(bytype) do
            table.sort(list)
        end
        return bytype, typeOf, n
    end

    local function collectSkins()
        local okAll, all = pcall(Registry.GetAll)
        if not okAll or type(all) ~= "table" then
            return {}, {}
        end
        local list, set, n = {}, {}, 0
        for id in pairs(all) do
            n = n + 1
            if n % 150 == 0 then
                task.wait()
            end
            if type(id) == "number" then
                local ok, isSkin = pcall(function()
                    local entry = Registry.GetById(id)
                    local original = entry and entry.Module and entry.Module:FindFirstChild("Original")
                    return original ~= nil and original:IsA("ObjectValue") and original.Value ~= nil
                end)
                if ok and isSkin then
                    list[#list + 1] = id
                    set[id] = true
                end
            end
        end
        table.sort(list)
        return list, set
    end

    local function substitutePerks(value)
        if type(value) ~= "table" or not (INGAME.Perk and ENABLED.Perk) then
            return value
        end
        local removed, any = {}, false
        for slot in pairs(fakeC) do
            if slotType(slot) == "Perk" then
                any = true
                local okR, rid = pcall(origGetFromSlot, slot)
                if okR and type(rid) == "number" and rid ~= 0 then
                    removed[rid] = true
                end
            end
        end
        if not any then
            return value
        end
        local out, seen = {}, {}
        for _, id in ipairs(value) do
            if not removed[id] then
                out[#out + 1] = id
                seen[id] = true
            end
        end
        for slot, fid in pairs(fakeC) do
            if slotType(slot) == "Perk" and not seen[fid] then
                out[#out + 1] = fid
                seen[fid] = true
            end
        end
        return out
    end

    local function substituteSkins(value)
        if not UA2.skinOn or next(fakeS) == nil then
            return value
        end
        if type(value) ~= "table" then
            value = {}
        end
        local removed = {}
        for item in pairs(fakeS) do
            local okO, realOrig = pcall(function() return UA2.origGetSkin(item) end)
            if okO and type(realOrig) == "number" then
                removed[realOrig] = true
            end
        end
        local out, seen = {}, {}
        for _, id in ipairs(value) do
            if not removed[id] then
                out[#out + 1] = id
                seen[id] = true
            end
        end
        for _, sid in pairs(fakeS) do
            if not seen[sid] then
                out[#out + 1] = sid
                seen[sid] = true
            end
        end
        return out
    end

    local function substituteNametag(value)
        local fid = fakeC["NametagSlot"]
        if type(fid) == "number" and INGAME.Nametag and ENABLED.Nametag then
            return fid
        end
        return value
    end

    local function applyPatches()

        patch("useInventory.GetOwnedBySlotType", Inventory, "GetOwnedBySlotType", function(orig)
            return function(st, ...)
                local list = orig(st, ...)
                if type(list) ~= "table" then
                    return list
                end
                local extra
                if st == "Emote" then
                    if not emoteOn then
                        return list
                    end
                    extra = ALL
                elseif cosOn and ENABLED[st] then
                    extra = BYTYPE[st]
                else
                    return list
                end
                local have = {}
                for _, id in ipairs(list) do
                    have[id] = true
                end
                local out = table.clone(list)
                for _, id in ipairs(extra) do
                    if not have[id] then
                        out[#out + 1] = id
                    end
                end
                return out
            end
        end)

        patchBoth("Equip", "Equip", function(orig)
            return function(slot, id, ...)
                local idx = emoteOn and slotIndex(slot) or nil
                if idx and isExtraSlot(idx) then

                    if type(id) == "number" and id ~= 0 then
                        fakeE[idx] = id
                        log("Slot extra", idx, "-> emote visual", id)
                    else
                        fakeE[idx] = nil
                    end
                    refreshWheel()
                    pcall(function() Loadout.Changed:Fire() end)
                    return
                end
                if idx then
                    if type(id) == "number" and id ~= 0 then
                        if ALLSET[id] and not owns(id) then
                            if realSlotId(idx) == 0 then
                                local base = pickBase()
                                if not base then
                                    log("No tienes ningun emote real para usar de base en el slot", idx)
                                    return
                                end
                                log("Slot", idx, "vacio: se equipa el emote real base", base)
                                orig(slot, base)
                            end
                            fakeE[idx] = id
                            log("Slot", idx, "-> emote visual", id)
                            refreshWheel()
                            return
                        end
                        local had = fakeE[idx] ~= nil
                        fakeE[idx] = nil
                        local r = orig(slot, id, ...)
                        if had then
                            refreshWheel()
                        end
                        return r
                    end
                    if id == nil or id == 0 then
                        fakeE[idx] = nil
                    end
                    return orig(slot, id, ...)
                end

                local st = cosOn and slotType(slot) or nil
                if st and ENABLED[st] then
                    if type(id) == "number" and id ~= 0 then
                        if TYPE_OF[id] == st and not owns(id) then
                            fakeC[slot] = id
                            log("Slot", slot, "-> visual", id)
                            return
                        end
                        fakeC[slot] = nil
                        return orig(slot, id, ...)
                    end
                    if (id == nil or id == 0) and fakeC[slot] ~= nil then
                        fakeC[slot] = nil
                        log("Slot", slot, "-> visual quitado")
                        return
                    end
                end
                return orig(slot, id, ...)
            end
        end)

        patchBoth("Unequip", "Unequip", function(orig)
            return function(slot, ...)
                if cosOn and fakeC[slot] ~= nil then
                    fakeC[slot] = nil
                    log("Slot", slot, "-> visual quitado")
                    return
                end
                local idx = emoteOn and slotIndex(slot) or nil
                if idx and isExtraSlot(idx) then
                    fakeE[idx] = nil
                    refreshWheel()
                    pcall(function() Loadout.Changed:Fire() end)
                    return
                end
                local had = idx and fakeE[idx] ~= nil
                if idx then
                    fakeE[idx] = nil
                end
                local r = orig(slot, ...)
                if had then
                    refreshWheel()
                end
                return r
            end
        end)

        local function buildEquippedMap(orig)
            return function(...)
                local real = orig(...)
                if type(real) ~= "table" or (next(fakeE) == nil and next(fakeC) == nil) then
                    return real
                end
                local out = table.clone(real)
                for idx, fid in pairs(fakeE) do
                    local name = "EmoteSlot_" .. idx
                    if out[name] or isExtraSlot(idx) then
                        out[name] = fid
                    end
                end
                for slot, fid in pairs(fakeC) do
                    out[slot] = fid
                end
                return table.freeze(out)
            end
        end
        patch("useLoadout.GetAll", Loadout, "GetAll", buildEquippedMap)
        patch("useInventory.GetLoadout", Inventory, "GetLoadout", buildEquippedMap)

        patchBoth("IsEquipped", "IsEquipped", function(orig)
            return function(id)
                local eq, s = orig(id)
                if eq then
                    return eq, s
                end
                for idx, fid in pairs(fakeE) do
                    if fid == id then
                        return true, "EmoteSlot_" .. idx
                    end
                end
                for slot, fid in pairs(fakeC) do
                    if fid == id then
                        return true, slot
                    end
                end
                return false, nil
            end
        end)

        if emoteOn then

            patch("EmotePopup.SetEquipped", EmotePopup, "SetEquipped", function(orig)
                return function(self, list, ...)
                    local r = orig(self, augmentEmotes(list), ...)
                    popupInst = self
                    applyOverlay(self)
                    return r
                end
            end)

            patch("EmotePopup.Show", EmotePopup, "Show", function(orig)
                return function(self, ...)
                    local r = orig(self, ...)
                    popupInst = self
                    applyOverlay(self)
                    return r
                end
            end)

            patch("EmotePopup.KeyActivated", EmotePopup, "KeyActivated", function(orig)
                return function(self, slot, ...)
                    if type(slot) == "number" then
                        pending = { slot = slot, t = tick(), base = type(self.Emotes) == "table" and self.Emotes[slot] or nil }
                    end
                    return orig(self, slot, ...)
                end
            end)

            patch("Emote.Activate", EmoteClass, "Activate", function(orig)
                return function(self, preview, p3)
                    local fid = nil
                    if not preview then
                        pcall(function()
                            if isLocalEmote(self) then
                                fid = resolveFake(self)
                            end
                        end)
                    end
                    if fid then
                        task.defer(swapTo, fid)
                    end
                    return orig(self, preview, p3)
                end
            end)
        end

        if UA2.slotsOn and PackageMod then
            patch("UserOwnsPackage.Owns (MoreEmotes)", PackageMod, "Owns", function(orig)
                return function(player, package, ...)
                    if package == "MoreEmotes" and player == LP and UA2.slotsOn then
                        return true
                    end
                    return orig(player, package, ...)
                end
            end)
        end

        local boomboxOn = cosOn and ENABLED.Boombox and #BYTYPE.Boombox > 0
        if SlotsView and (UA2.slotsOn or boomboxOn) then
            patch("Inventario.Slots.SetHeader (12 emotes + boombox)", SlotsView, "SetHeader", function(orig)
                return function(self, ...)
                    if UA2.slotsOn then
                        self.MoreEmotes = true
                    end
                    if cosOn and ENABLED.Boombox and #BYTYPE.Boombox > 0 then
                        self.OwnsRelics = true
                    end
                    return orig(self, ...)
                end
            end)
        end

        if boomboxOn then
            patchBoth("GetEquipped (boombox)", "GetEquipped", function(orig)
                return function(slot, ...)
                    if slot == "BoomboxSlot" and fakeC.BoomboxSlot ~= nil then
                        return fakeC.BoomboxSlot
                    end
                    return orig(slot, ...)
                end
            end)
        end

        if UA2.skinOn then
            patch("useInventory.OwnedIds (skins)", Inventory, "OwnedIds", function(orig)
                return function(...)
                    local list = orig(...)
                    if not UA2.skinOn or type(list) ~= "table" then
                        return list
                    end
                    local have = {}
                    for _, id in ipairs(list) do
                        have[id] = true
                    end
                    local out = table.clone(list)
                    for _, id in ipairs(UA2.SKINS) do
                        if not have[id] then
                            out[#out + 1] = id
                        end
                    end
                    table.sort(out)
                    return out
                end
            end)
            patch("useInventory.GetSkin", Inventory, "GetSkin", function(orig)
                return function(item, ...)
                    if UA2.skinOn and fakeS[item] ~= nil then
                        return fakeS[item]
                    end
                    return orig(item, ...)
                end
            end)

            if DataRegClass then
                patch("DataRegistry.Get (skins de herramientas)", DataRegClass, "Get", function(orig)
                    return function(self, term, ...)
                        local value = orig(self, term, ...)
                        if term == "ToolSkins" and UA2.skinOn and next(fakeS) ~= nil then
                            local okL, isLocal = pcall(function()
                                return self.Parent ~= nil and self.Parent.Local == true
                            end)
                            if okL and isLocal then
                                local okS, res = pcall(substituteSkins, value)
                                if okS and res ~= nil then
                                    return res
                                end
                            end
                        end
                        return value
                    end
                end)
            end
            patch("useInventory.SetSkin", Inventory, "SetSkin", function(orig)
                return function(item, skin, ...)
                    if UA2.skinOn then
                        if type(skin) == "number" and skin ~= 0 and UA2.SKINSET[skin] and not owns(skin) then
                            fakeS[item] = skin
                            log("Skin visual:", item, "->", skin)
                            pcall(function() Inventory.Changed:Fire() end)
                            return
                        end
                        if fakeS[item] ~= nil then
                            fakeS[item] = nil
                            pcall(function() Inventory.Changed:Fire() end)
                        end
                    end
                    return orig(item, skin, ...)
                end
            end)
        end

        if cosOn then

            if RigClass then
                patch("Rig.BuildRig (partida)", RigClass, "BuildRig", function(orig)
                    return function(self, ...)
                        if not self.Built
                            and type(self.Cosmetics) == "table"
                            and self.RigTerm and self.Actions and self.ToolSkins and self.Boombox
                            and next(fakeC) ~= nil
                        then
                            local isLocal = false
                            pcall(function()
                                isLocal = self.Parent ~= nil and self.Parent.Local == true
                            end)
                            if isLocal then
                                local ok, err = pcall(function()
                                    local real = self.Cosmetics
                                    local removed = {}
                                    for slot in pairs(fakeC) do

                                        if slot ~= "BoomboxSlot" then
                                            local okR, rid = pcall(origGetFromSlot, slot)
                                            if okR and type(rid) == "number" and rid ~= 0 then
                                                removed[rid] = true
                                            end
                                        end
                                    end
                                    local out, seen = {}, {}
                                    for _, id in ipairs(real) do
                                        if not removed[id] then
                                            out[#out + 1] = id
                                            seen[id] = true
                                        end
                                    end
                                    for slot, fid in pairs(fakeC) do
                                        if slot ~= "BoomboxSlot" and not seen[fid] then
                                            out[#out + 1] = fid
                                            seen[fid] = true
                                        end
                                    end

                                    local bid = fakeC.BoomboxSlot
                                    if type(bid) == "number" and INGAME.Boombox and ENABLED.Boombox then
                                        self.Boombox = bid
                                    end
                                    table.clear(lastBuild)
                                    lastBuild.Real = table.clone(real)
                                    lastBuild.Fake = table.clone(fakeC)
                                    lastBuild.Final = table.clone(out)
                                    self.Cosmetics = out
                                    log(
                                        "BuildRig local: real = {" .. table.concat(real, ",") .. "}",
                                        "| final = {" .. table.concat(out, ",") .. "}"
                                    )
                                end)
                                if not ok then
                                    log("Fallo al cambiar Cosmetics en BuildRig ->", tostring(err))
                                end
                            end
                        end
                        return orig(self, ...)
                    end
                end)
            else
                log("PARCHE NO APLICADO (no se pudo cargar Objects.Game.Character.Rig): cosmeticos en partida no funcionan")
                patchResults[#patchResults + 1] = { label = "Rig.BuildRig (partida)", ok = false }
            end

            if DataRegClass then
                patch("DataRegistry.SetTerm (ventajas/etiqueta)", DataRegClass, "SetTerm", function(orig)
                    return function(self, term, value, ...)
                        if (term == "Perks" or term == "Nametag" or term == "Boombox") and next(fakeC) ~= nil then
                            local ok, res = pcall(function()
                                if self.Parent == nil or self.Parent.Local ~= true then
                                    return value
                                end
                                if term == "Perks" then
                                    return substitutePerks(value)
                                end
                                if term == "Boombox" then
                                    local fid = fakeC.BoomboxSlot
                                    if type(fid) == "number" and INGAME.Boombox and ENABLED.Boombox then
                                        return fid
                                    end
                                    return value
                                end
                                return substituteNametag(value)
                            end)
                            if ok and res ~= nil and res ~= value then
                                log("En partida:", term, "->", type(res) == "table" and ("{" .. table.concat(res, ",") .. "}") or tostring(res))
                                value = res
                            end
                        end
                        return orig(self, term, value, ...)
                    end
                end)
            else
                log("PARCHE NO APLICADO (no se pudo cargar Objects.Game.Character.DataRegistry): ventajas/etiqueta en partida no funcionan")
                patchResults[#patchResults + 1] = { label = "DataRegistry.SetTerm (ventajas/etiqueta)", ok = false }
            end
        end
    end

    local SHOP_MODE = "B"
    local origTierProgress

    local lastShopNotify = 0
    local function shopNotify(es, en)
        if os.clock() - lastShopNotify < 4 then
            return
        end
        lastShopNotify = os.clock()
        pcall(function()
            local tr = (type(getgenv) == "function" and getgenv().HydraScriptText) or nil
            StarterGui:SetCore("SendNotification", {
                Title = tr and tr("Tienda de evento", "Event shop") or "Tienda de evento",
                Text = tr and tr(es, en) or es,
                Duration = 4,
            })
        end)
    end

    local function applyShopPatches()
        if not (EventSvc and ShopsSvc) then
            log("Tienda de evento: falta UserData.Event o UserData.Shops, parches omitidos")
            return
        end
        origTierProgress = EventSvc.GetTierProgress

        local okBuy = patch("useShops.Purchase (no manda compras de tiers bloqueados)", ShopsSvc, "Purchase", function(orig)
            return function(id, ...)
                local n = tonumber(id)
                if n and type(origTierProgress) == "function" then
                    local ok, tiers = pcall(origTierProgress)
                    if ok and type(tiers) == "table" then
                        for _, t in ipairs(tiers) do
                            if t.status == "Locked" then
                                for _, it in ipairs(t.items or {}) do
                                    if it.itemId == n then
                                        log("Tienda de evento: item", n, "esta en un tier bloqueado de verdad -> no se manda la compra")
                                        shopNotify("Solo visual: ese tier sigue bloqueado y no se puede comprar", "Visual only: that tier is still locked and cannot be bought")
                                        return false
                                    end
                                end
                            end
                        end
                    end
                end
                return orig(id, ...)
            end
        end)
        if not okBuy then
            log("Tienda de evento: no se aplico el bloqueo de compra, asi que tampoco se cambia lo que se muestra")
            return
        end

        patch("useEvent.GetTiers (candado visual)", EventSvc, "GetTiers", function(orig)
            return function(...)
                local real = orig(...)
                if type(real) ~= "table" then
                    return real
                end
                local out = {}
                for i, t in ipairs(real) do
                    local c = t
                    if type(t) == "table" and t.State == "Locked" then
                        if SHOP_MODE == "B" then
                            c = table.clone(t)
                            c.State = "Unlocked"
                            c.IsTimeOpen = true
                            c.IsWaitingOnTimer = false
                            c.ItemsMet = true
                            c.UnlockProgress = nil
                        elseif t.IsWaitingOnTimer then
                            c = table.clone(t)
                            c.IsTimeOpen = true
                            c.IsWaitingOnTimer = false
                            if t.ItemsMet then
                                c.State = "Unlocked"
                            end
                        end
                    end
                    out[i] = c
                end
                return out
            end
        end)
    end

    function M.Disable()
        gen = gen + 1
        if not active then
            return
        end
        for i = #patches, 1, -1 do
            local p = patches[i]
            pcall(function()
                p.tbl[p.key] = p.orig
            end)
        end
        patches = {}
        table.clear(fakeE)
        table.clear(fakeC)
        table.clear(fakeS)
        table.clear(lastBuild)
        pending = nil
        emoteOn, cosOn = false, false
        UA2.skinOn, UA2.slotsOn = false, false
        pcall(function() Inventory.Changed:Fire() end)
        pcall(function() Loadout.Changed:Fire() end)
        active = false
        refreshWheel()
        log("Descargado: todo restaurado")
    end

    local function enableImpl(myGen)

        for _, name in ipairs({}) do
            local ok, t = pcall(function()
                return GENV[name]
            end)
            if ok and type(t) == "table" and type(t.Unload) == "function" then
                pcall(t.Unload)
                log("Se descargo el script de prueba suelto:", name)
            end
        end

        Registry = req("Items.Registry", "Items", "Registry")
        Inventory = req("useInventory", "Client", "Services", "UserData", "Inventory")
        Loadout = req("useLoadout", "Client", "Services", "UserData", "Inventory", "Loadout")
        if not (Registry and Inventory and Loadout) then
            log("ABORTADO: falta al menos un modulo necesario. No se aplico ningun parche.")
            return
        end

        ItemSlotType = Inventory.GetItemSlotType
        do
            local matched, checked, emoteBad = 0, 0, 0
            local okAll, equipped = pcall(Loadout.GetAll)
            if type(ItemSlotType) == "function" and okAll and type(equipped) == "table" then
                for slot, id in pairs(equipped) do
                    if type(id) == "number" and id ~= 0 then
                        local okI, got = pcall(ItemSlotType, id)
                        local okS, want = pcall(Loadout.GetSlotType, slot)
                        if okI and okS and want ~= nil then
                            checked = checked + 1
                            if got == want then
                                matched = matched + 1
                            elseif want == "Emote" then
                                emoteBad = emoteBad + 1
                            end
                        end
                    end
                end
            end
            if matched == 0 or emoteBad > 0 then
                log("ABORTADO: GetItemSlotType no coincide con tu loadout (coinciden " .. matched .. " de " .. checked .. ", emotes mal: " .. emoteBad .. "). No se aplico ningun parche.")
                return
            end
            log("GetItemSlotType verificado contra tu loadout:", matched, "de", checked, "slots")
        end
        RigClass = req("Objects.Game.Character.Rig", "Objects", "Game", "Character", "Rig")
        DataRegClass = req("Objects.Game.Character.DataRegistry", "Objects", "Game", "Character", "DataRegistry")
        PopupService = req("PopupService", "Services", "UI", "PopupService")
        EmotePopup = req("PopupService.Types.Emote", "Services", "UI", "PopupService", "Types", "Emote")
        EmoteClass = req("Objects.Items.Emote", "Objects", "Items", "Emote")
        ItemSvc = req("ClientItemService", "Services", "Items", "ClientItemService")
        PackageMod = req("UserOwnsPackage", "Shared", "Marketplace", "UserOwnsPackage")
        SlotsView = req("Menu.Inventory.Slots", "Objects", "Menu", "Menu", "Views", "Inventory", "Views", "Slots")
        EventSvc = req("useEvent", "Client", "Services", "UserData", "Event")
        ShopsSvc = req("useShops", "Client", "Services", "UserData", "Shops")
        local emoteMods = (EmotePopup and EmoteClass and ItemSvc) and true or false
        if not emoteMods then
            log("Aviso: faltan modulos de emotes; Unlock All se aplica solo a cosmeticos/personajes/auras")
        end

        local newAll, newAllSet, rawCount = {}, {}, 0
        if emoteMods then
            newAll, rawCount = collectEmoteIds()
            for _, id in ipairs(newAll) do
                newAllSet[id] = true
            end
            log("Emotes encontrados:", rawCount, "| validos:", #newAll)
        end

        local newBy, newTypeOf, regCount = collectCosmetics()
        local newSkins, newSkinSet = collectSkins()

        local extraLocked = false
        if PackageMod then
            local okOwn, owned = pcall(PackageMod.Owns, LP, "MoreEmotes")
            extraLocked = not (okOwn and owned == true)
        end
        if myGen ~= gen then
            return
        end
        if active then
            return
        end
        if not newBy then
            log("Aviso: Registry.GetAll no devolvio una tabla; cosmeticos/personajes/auras desactivados")
            newBy = emptyByType()
            newTypeOf = {}
            regCount = 0
        end
        local cosTotal = 0
        local counts = {}
        for _, n in ipairs(TYPE_NAMES) do
            cosTotal = cosTotal + #newBy[n]
            counts[#counts + 1] = n .. ": " .. #newBy[n]
        end
        log("Items en Registry:", regCount, "|", table.concat(counts, " | "))

        log("Skins de herramientas:", #newSkins, "| Emote slots 7-12:", extraLocked and "bloqueados (se desbloquean visuales)" or "ya comprados")

        if #newAll == 0 and cosTotal == 0 and #newSkins == 0 then
            log("ABORTADO: no se encontro ningun emote ni cosmetico. No se aplico ningun parche.")
            return
        end

        ALL, ALLSET = newAll, newAllSet
        BYTYPE, TYPE_OF = newBy, newTypeOf
        emoteOn = emoteMods and #newAll > 0
        cosOn = cosTotal > 0
        UA2.SKINS, UA2.SKINSET = newSkins, newSkinSet
        UA2.skinItem = nil
        UA2.skinOn = #newSkins > 0
        UA2.extraLocked = extraLocked
        UA2.slotsOn = emoteOn and extraLocked
        UA2.warnedNoBase = false
        table.clear(fakeS)
        patches, patchResults = {}, {}
        table.clear(fakeE)
        table.clear(fakeC)
        pending = nil
        popupInst = nil
        warnedOverlay = false

        origGetOwned = Inventory.GetOwnedBySlotType
        origOwns = Inventory.Owns
        origIsEquipped = Loadout.IsEquipped
        origGetFromSlot = Loadout.GetEquipped
        origSlotTypeForSlot = Loadout.GetSlotType
        origSetEquipped = EmotePopup and EmotePopup.SetEquipped or nil
        UA2.origGetSkin = Inventory.GetSkin

        applyPatches()
        applyShopPatches()
        active = true

        if UA2.skinOn then
            task.spawn(function()
                local deploySvc = req("DeployableService", "Services", "Items", "DeployableService")
                if not deploySvc or not active or myGen ~= gen or not UA2.skinOn then
                    return
                end
                patch("DeployableService.Build (skins de colocables)", deploySvc, "Build", function(orig)
                    return function(self, model, ...)
                        if UA2.skinOn and next(fakeS) ~= nil and typeof(model) == "Instance" then
                            pcall(function()
                                local owner = model:GetAttribute("Owner")
                                local mine = owner ~= nil and (owner == LP.Name or owner == LP.DisplayName or owner == LP.UserId)
                                if not UA2.loggedOwner then
                                    UA2.loggedOwner = true
                                    log("Colocable", model.Name, "Owner =", tostring(owner), mine and "(tuyo)" or "(de otro)")
                                end
                                if not mine then
                                    return
                                end
                                for item, sid in pairs(fakeS) do
                                    local entry = Registry.GetById(item)
                                    if entry and entry.Module and entry.Module.Name == model.Name then
                                        model:SetAttribute("Skin", sid)
                                        log("Colocable", model.Name, "-> skin visual", sid)
                                    end
                                end
                            end)
                        end
                        return orig(self, model, ...)
                    end
                end)
            end)
        end
        pcall(function() Inventory.Changed:Fire() end)
        pcall(function() Loadout.Changed:Fire() end)
        refreshWheel()

        local okCount = 0
        for _, r in ipairs(patchResults) do
            if r.ok then
                okCount = okCount + 1
            end
        end
        log("Listo:", okCount .. "/" .. #patchResults, "parches aplicados")
        if okCount < #patchResults then
            log("Algun parche fallo")
        end
        pcall(function()
            StarterGui:SetCore("SendNotification", {
                Title = "Unlock All",
                Text = okCount .. "/" .. #patchResults .. ((type(getgenv) == "function" and getgenv().HydraScriptText) and getgenv().HydraScriptText(" parches aplicados", " patches applied") or " parches aplicados"),
                Duration = 5,
            })
        end)
    end

    function M.Enable()
        if active then
            return
        end
        gen = gen + 1
        local myGen = gen
        task.spawn(function()
            local ok, err = pcall(enableImpl, myGen)
            if not ok then
                log("FALLO Enable ->", tostring(err))
            end
        end)
    end

    function M.IsEnabled()
        return active
    end

    function M.Status()
        log("---- ESTADO ---- activo:", tostring(active), "| emotes:", tostring(emoteOn), "| cosmeticos:", tostring(cosOn))
        for _, r in ipairs(patchResults) do
            log(r.ok and "OK     " or "FALLO  ", r.label)
        end
        for st in pairs(KNOWN) do
            log("Tipo", st, ENABLED[st] and "activo" or "desactivado", "| items:", #BYTYPE[st])
        end
        local any = false
        for idx = 1, 12 do
            if fakeE[idx] then
                any = true
                log("Emote slot", idx, "real:", realSlotId(idx), "| visual:", fakeE[idx])
            end
        end
        for slot, fid in pairs(fakeC) do
            any = true
            local okReal, real = pcall(Loadout.GetEquipped, slot)
            log("Slot", slot, "real:", okReal and real or "?", "| visual:", fid)
        end
        for item, sid in pairs(fakeS) do
            any = true
            log("Skin de", item, "-> visual", sid)
        end
        log("Skins disponibles:", #UA2.SKINS, "| slots 7-12:", UA2.slotsOn and "visuales" or (UA2.extraLocked and "bloqueados" or "comprados"))
        if not any then
            log("Sin slots visuales activos")
        end
    end

    function M.SetType(name, state)
        if not KNOWN[name] then
            log("Tipo desconocido:", tostring(name), "(usa " .. table.concat(TYPE_NAMES, ", ") .. ")")
            return
        end
        ENABLED[name] = state and true or false
        if not ENABLED[name] then
            for slot in pairs(fakeC) do
                if slotType(slot) == name then
                    fakeC[slot] = nil
                end
            end
        end
        log("Tipo", name, ENABLED[name] and "activado" or "desactivado", "(se aplica la proxima vez que abras el selector)")
    end

    function M.GetBoomboxSkins()
        local out, seen = {}, {}
        for _, id in ipairs(BYTYPE.Boombox or {}) do
            local name = tostring(id)
            pcall(function()
                local entry = Registry.GetById(id)
                local ok, info = pcall(require, entry.Module)
                name = (ok and type(info) == "table" and info.AppearanceInfo and info.AppearanceInfo.Name) or entry.Module.Name
            end)
            seen[id] = true
            out[#out + 1] = { id = id, name = name, ugc = false }
        end
        pcall(function()
            for _, tagged in ipairs(game:GetService("CollectionService"):GetTagged("RelicsUGCSkin")) do
                local id = tagged:GetAttribute("ID")
                if type(id) == "number" and not seen[id] then
                    seen[id] = true
                    local display = tagged:GetAttribute("DisplayName")
                    out[#out + 1] = { id = id, name = type(display) == "string" and display or tagged.Name, ugc = true }
                end
            end
        end)
        return out
    end

    function M.GetBoombox()
        return fakeC.BoomboxSlot
    end

    function M.SetBoombox(id)
        if not active then
            log("Activa Unlock All primero")
            return false
        end
        fakeC.BoomboxSlot = type(id) == "number" and id or nil
        log("Boombox visual ->", tostring(fakeC.BoomboxSlot))
        pcall(function() Loadout.Changed:Fire() end)
        return true
    end

    function M.Snapshot()
        local snap = { emotes = {}, cosmetics = {}, skins = {} }
        for idx, fid in pairs(fakeE) do snap.emotes[tostring(idx)] = fid end
        for slot, fid in pairs(fakeC) do snap.cosmetics[slot] = fid end
        for item, sid in pairs(fakeS) do snap.skins[tostring(item)] = sid end
        return snap
    end

    function M.ApplySnapshot(snap)
        if not active or type(snap) ~= "table" then
            return false
        end
        table.clear(fakeE)
        table.clear(fakeC)
        table.clear(fakeS)
        local skipped = 0
        for idx, fid in pairs(snap.emotes or {}) do
            local n = tonumber(idx)
            if not (n and n >= 1 and n <= 12 and ALLSET[fid]) or (n > 6 and UA2.extraLocked and not UA2.slotsOn) then
                skipped += 1
            elseif n <= 6 and realSlotId(n) == 0 then

                local okE = pcall(Loadout.Equip, "EmoteSlot_" .. n, fid)
                if not okE then skipped += 1 end
                task.wait(0.3)
            else
                fakeE[n] = fid
            end
        end
        for slot, fid in pairs(snap.cosmetics or {}) do
            local st = slotType(slot)
            local isUgcBoombox = slot == "BoomboxSlot" and type(fid) == "number" and ENABLED.Boombox
            if (st and TYPE_OF[fid] == st) or isUgcBoombox then fakeC[slot] = fid else skipped += 1 end
        end
        for item, sid in pairs(snap.skins or {}) do
            local n = tonumber(item)
            if n and UA2.SKINSET[sid] then fakeS[n] = sid else skipped += 1 end
        end
        refreshWheel()
        pcall(function() Loadout.Changed:Fire() end)
        pcall(function() Inventory.Changed:Fire() end)
        log("Perfil aplicado", skipped > 0 and ("(" .. skipped .. " items ya no existen)") or "")
        return true, skipped
    end

    function M.Pools()
        return { emotes = ALL, bytype = BYTYPE, skins = UA2.SKINS }
    end

    function M.RandomLook()
        if not active then
            log("Activa Unlock All primero")
            return nil
        end
        local function pick(list)
            if type(list) == "table" and #list > 0 then
                return list[math.random(1, #list)]
            end
            return nil
        end
        local snap = { emotes = {}, cosmetics = {}, skins = {} }
        if emoteOn and #ALL > 0 then
            local maxSlot = (UA2.extraLocked and not UA2.slotsOn) and 6 or 12
            local pool = table.clone(ALL)
            for idx = 1, maxSlot do
                if #pool == 0 then
                    break
                end
                local k = math.random(1, #pool)
                snap.emotes[tostring(idx)] = pool[k]
                pool[k] = pool[#pool]
                pool[#pool] = nil
            end
        end
        if cosOn then
            local used = {}
            for _, slot in ipairs({ "CosmeticSlot_1", "CosmeticSlot_2", "CharacterSlot", "UnusualSlot", "CarryAnimationSlot", "NametagSlot" }) do
                local st = slotType(slot)
                if st and ENABLED[st] then
                    for _ = 1, 4 do
                        local id = pick(BYTYPE[st])
                        if id and not used[id] then
                            used[id] = true
                            snap.cosmetics[slot] = id
                            break
                        end
                    end
                end
            end
            if ENABLED.Boombox then
                local b = pick(M.GetBoomboxSkins())
                if b then
                    snap.cosmetics.BoomboxSlot = b.id
                end
            end
        end
        if UA2.skinOn and #UA2.SKINS > 0 then
            if not UA2.skinItem then

                local map = {}
                for _, sid in ipairs(UA2.SKINS) do
                    local ok, item = pcall(function()
                        return Registry.GetById(sid).Module.Original.Value:GetAttribute("ID")
                    end)
                    if ok and type(item) == "number" then
                        map[item] = map[item] or {}
                        table.insert(map[item], sid)
                    end
                end
                UA2.skinItem = map
            end
            for item, list in pairs(UA2.skinItem) do
                snap.skins[tostring(item)] = pick(list)
            end
        end
        return snap
    end

    function M.SetInGame(name, state)
        if INGAME[name] == nil then
            log("Solo se puede para Perk, Nametag o Boombox")
            return
        end
        INGAME[name] = state and true or false
        log("En partida:", name, INGAME[name] and "activado" or "desactivado", "(aplica en la proxima actualizacion del servidor)")
    end

    return M
end)()
end
local UA = getgenv().HydraUnlockAll
local Unlock = {LOOK_FILE = "Hydra_Look.json", AutoLook = true, Waiting = 0}
function Unlock.saveLook()
    if type(writefile) ~= "function" or not UA then return false end
    local ok = pcall(function()
        writefile(Unlock.LOOK_FILE, game:GetService("HttpService"):JSONEncode(UA.Snapshot()))
    end)
    return ok
end
function Unlock.loadLook()
    if type(readfile) ~= "function" or type(isfile) ~= "function" or not UA then return false end
    local ok, snap = pcall(function()
        if not isfile(Unlock.LOOK_FILE) then return nil end
        return game:GetService("HttpService"):JSONDecode(readfile(Unlock.LOOK_FILE))
    end)
    if not ok or type(snap) ~= "table" then return false end
    return (UA.ApplySnapshot(snap))
end
function Unlock.lastLine()
    local log = UA and UA.Log
    if type(log) == "table" and #log > 0 then return (tostring(log[#log]):gsub("^%[Hydra%-UnlockAll%]%s*", "")) end
    return ""
end

Hydra:AddTranslations({
    ["Desbloquea todo de forma visual (solo lo ves vos)"] = "Unlocks everything visually (only you see it)",
    ["Cosm\195\169ticos"] = "Cosmetics", ["Personajes"] = "Characters", ["Unusuals"] = "Unusuals", ["Perks"] = "Perks",
    ["Animaci\195\179n de cargar"] = "Carry animation", ["Nametags"] = "Nametags", ["Boombox"] = "Boombox",
    ["Perk en partida"] = "Perk in match", ["Nametag en partida"] = "Nametag in match", ["Boombox en partida"] = "Boombox in match",
    ["Tambi\195\169n se ve durante la ronda"] = "Also shows during the round",
    ["Skin del boombox"] = "Boombox skin", ["Eleg\195\173 cualquiera"] = "Pick any",
    ["Look aleatorio"] = "Random look", ["Emotes, cosm\195\169ticos y skins al azar"] = "Random emotes, cosmetics and skins",
    ["Guardar mi look"] = "Save my look", ["Lo que ten\195\169s puesto ahora"] = "What you are wearing now",
    ["Cargar mi look"] = "Load my look", ["El \195\186ltimo que guardaste"] = "The last one you saved",
    ["Cargar mi look al activar"] = "Load my look when turning on", ["Se pone solo cada vez que lo prend\195\169s"] = "It is applied every time you turn it on",
    ["Unlock All activo"] = "Unlock All on", ["Unlock All no se pudo activar"] = "Unlock All could not turn on",
    ["Activ\195\161 Unlock All primero"] = "Turn on Unlock All first", ["Look guardado"] = "Look saved", ["Look aplicado"] = "Look applied",
    ["No hay un look guardado"] = "There is no saved look", ["Tu ejecutor no puede guardar archivos"] = "Your executor can't save files",
})

local TabExtra = Hydra:Tab({Id = "Extra", Title = "Extra", Caption = "EXTRA", Icon = "\226\156\142"})

local Avatar = {FILE = "Hydra_Avatar.json", look = nil, saved = {}, korblox = false, deleted = false, busy = false,
    head = {on = false, conn = nil, faces = {}}, KORBLOX_LEG = 139607718,
    LIST_PROPS = {"HatAccessory", "HairAccessory", "FaceAccessory", "NeckAccessory", "ShouldersAccessory", "FrontAccessory", "BackAccessory", "WaistAccessory"},
    ID_PROPS = {"HatAccessory", "HairAccessory", "FaceAccessory", "NeckAccessory", "ShouldersAccessory", "FrontAccessory", "BackAccessory", "WaistAccessory",
        "Shirt", "Pants", "GraphicTShirt", "Face", "Head", "Torso", "LeftArm", "RightArm", "LeftLeg", "RightLeg"},
    COLOR_PROPS = {"HeadColor", "TorsoColor", "LeftArmColor", "RightArmColor", "LeftLegColor", "RightLegColor"},
    SCALE_PROPS = {"BodyTypeScale", "DepthScale", "HeadScale", "HeightScale", "ProportionScale", "WidthScale"}}

function Avatar.rig()
    local rigs = workspace:FindFirstChild("Rigs")
    if not rigs then return nil end
    local char = LocalPlayer.Character
    local tag = char and char:GetAttribute("Tag")
    if tag ~= nil then
        if Avatar.rigService == nil then
            local ok, svc = pcall(function() return require(Core.module("Services", "Asset", "RigService")) end)
            Avatar.rigService = (ok and type(svc) == "table") and svc or false
        end
        if Avatar.rigService then
            local ok, data = pcall(function() return Avatar.rigService:GetRigFromTag(tag) end)
            local model = ok and type(data) == "table" and data.Model or nil
            if model and model.Parent == rigs then return model, model:FindFirstChildOfClass("Humanoid") end
        end
    end
    for _, model in ipairs(rigs:GetChildren()) do
        if model.Name == LocalPlayer.Name and model:IsA("Model") then
            local head = model:FindFirstChild("Head")
            if head and head:IsA("BasePart") and not head.Anchored then return model, model:FindFirstChildOfClass("Humanoid") end
        end
    end
    return nil
end

function Avatar.repairJoints(rig)
    local joints = rig and rig:FindFirstChild("Joints")
    if not joints then return end
    for _, joint in ipairs(joints:GetDescendants()) do
        if joint:IsA("JointInstance") then
            for _, key in ipairs({"Part0", "Part1"}) do
                local part = joint[key]
                if part and not part:IsDescendantOf(workspace) then
                    local replacement = rig:FindFirstChild(part.Name)
                    if replacement and replacement:IsA("BasePart") then joint[key] = replacement end
                end
            end
        elseif joint:IsA("AnimationConstraint") then
            for _, key in ipairs({"Attachment0", "Attachment1"}) do
                local attachment = joint[key]
                local oldPart = attachment and attachment.Parent
                if attachment and oldPart and not attachment:IsDescendantOf(workspace) then
                    local replacement = rig:FindFirstChild(oldPart.Name)
                    if replacement and replacement:IsA("BasePart") then
                        local newAttachment = replacement:FindFirstChild(attachment.Name)
                        if not (newAttachment and newAttachment:IsA("Attachment")) then
                            newAttachment = attachment:Clone()
                            newAttachment.Parent = replacement
                        end
                        joint[key] = newAttachment
                    end
                end
            end
        end
    end
    for _, part in ipairs(rig:GetChildren()) do
        if part:IsA("BasePart") then
            for _, child in ipairs(part:GetChildren()) do
                if (child:IsA("Motor6D") or child:IsA("AnimationConstraint")) and joints:FindFirstChild(child.Name) then pcall(function() child:Destroy() end) end
            end
        end
    end
end
function Avatar.applySafe(humanoid, description)
    local rig = humanoid and humanoid.Parent
    if rig and not rig:FindFirstChild("HumanoidRootPart") then
        local tempRoot = Instance.new("Part")
        tempRoot.Name = "HumanoidRootPart"
        tempRoot.Size = Vector3.new(2, 2, 1)
        tempRoot.Transparency = 1
        tempRoot.CanCollide, tempRoot.CanQuery, tempRoot.CanTouch = false, false, false
        tempRoot.Massless = true
        tempRoot.Anchored = false
        local reference = nil
        pcall(function()
            local joints = rig:FindFirstChild("Joints")
            local rootJoint = joints and joints:FindFirstChild("Root")
            if rootJoint and rootJoint.Part0 and rootJoint.Part0:IsDescendantOf(workspace) then reference = rootJoint.Part0 end
        end)
        reference = reference or rig:FindFirstChild("LowerTorso") or rig:FindFirstChild("Torso")
        if reference then tempRoot.CFrame = reference.CFrame end
        tempRoot.Parent = rig

        local ok, err = pcall(function() humanoid:ApplyDescription(description) end)
        pcall(function() tempRoot:Destroy() end)
        pcall(Avatar.repairJoints, rig)
        if ok then return true end
        return false, tostring(err)
    end
    local okReset, errReset = pcall(function() humanoid:ApplyDescriptionReset(description) end)
    if okReset then pcall(Avatar.repairJoints, rig) return true end
    local okDiff, errDiff = pcall(function() humanoid:ApplyDescription(description) end)
    pcall(Avatar.repairJoints, rig)
    if okDiff then return true end
    return false, tostring(errDiff or errReset)
end

function Avatar.applyPart(humanoid, description)
    local rig = humanoid and humanoid.Parent
    if rig and not rig:FindFirstChild("HumanoidRootPart") then return Avatar.applySafe(humanoid, description) end
    local ok, err = pcall(function() humanoid:ApplyDescription(description) end)
    pcall(Avatar.repairJoints, rig)
    if ok then return true end
    return false, tostring(err)
end

function Avatar.strip(rig)
    if not rig then return end
    local joints = rig:FindFirstChild("Joints")
    for _, d in ipairs(rig:GetDescendants()) do
        if (d:IsA("Accoutrement") or d:IsA("Clothing") or d:IsA("ShirtGraphic")) and not (joints and d:IsDescendantOf(joints)) then
            pcall(function() d:Destroy() end)
        end
    end
end
function Avatar.removeHeadItems(rig)
    if not rig then return end
    local types = {Hat = true, Hair = true, Face = true, Eyebrow = true, Eyelash = true}
    local attachments = {HatAttachment = true, HairAttachment = true, FaceFrontAttachment = true, FaceCenterAttachment = true}
    for _, child in ipairs(rig:GetChildren()) do
        if child:IsA("Accessory") then
            local isHead = false
            pcall(function() isHead = types[child.AccessoryType.Name] == true end)
            if not isHead then
                local handle = child:FindFirstChild("Handle")
                local attachment = handle and handle:FindFirstChildOfClass("Attachment")
                isHead = attachment ~= nil and attachments[attachment.Name] == true
            end
            if isHead then pcall(function() child:Destroy() end) end
        end
    end
end

function Avatar.saveFile()
    if type(writefile) ~= "function" then return end
    pcall(function()
        if Avatar.look then
            writefile(Avatar.FILE, game:GetService("HttpService"):JSONEncode(Avatar.look))
        elseif type(isfile) == "function" and isfile(Avatar.FILE) and type(delfile) == "function" then
            delfile(Avatar.FILE)
        else
            writefile(Avatar.FILE, "null")
        end
    end)
end
function Avatar.loadFile()
    if type(readfile) ~= "function" or type(isfile) ~= "function" then return end
    pcall(function()
        if not isfile(Avatar.FILE) then return end
        local data = game:GetService("HttpService"):JSONDecode(readfile(Avatar.FILE))
        if type(data) == "table" then Avatar.look = data end
    end)
end
function Avatar.remember(desc, strip)
    if not desc then return end
    local look = {props = {}, colors = {}, scales = {}, layered = {}, strip = strip == true}
    for _, p in ipairs(Avatar.ID_PROPS) do
        local ok, v = pcall(function() return desc[p] end)
        if ok and v ~= nil then look.props[p] = v end
    end

    if Avatar.saved.RightLeg ~= nil then look.props.RightLeg = Avatar.saved.RightLeg end
    for _, p in ipairs(Avatar.COLOR_PROPS) do
        pcall(function()
            local c = desc[p]
            if typeof(c) == "Color3" then look.colors[p] = {c.R, c.G, c.B} end
        end)
    end
    for _, p in ipairs(Avatar.SCALE_PROPS) do
        pcall(function()
            local n = tonumber(desc[p])
            if n then look.scales[p] = n end
        end)
    end
    pcall(function()
        for _, e in ipairs(desc:GetAccessories(false)) do
            local typeName = nil
            pcall(function() typeName = e.AccessoryType.Name end)
            if e.AssetId and typeName then table.insert(look.layered, {id = e.AssetId, t = typeName, o = e.Order}) end
        end
    end)
    Avatar.look = look
    Avatar.saveFile()
end
function Avatar.restoreLook()
    local look = Avatar.look
    if type(look) ~= "table" then return false end
    local rig, humanoid = Avatar.rig()
    if not (rig and humanoid) then return false end
    local ok, desc = pcall(function() return humanoid:GetAppliedDescription() end)
    if not ok or not desc then return false end
    for p, v in pairs(look.props or {}) do
        pcall(function()
            if table.find(Avatar.LIST_PROPS, p) then desc[p] = tostring(v) else desc[p] = tonumber(v) or 0 end
        end)
    end
    for p, c in pairs(look.colors or {}) do pcall(function() desc[p] = Color3.new(c[1], c[2], c[3]) end) end
    for p, n in pairs(look.scales or {}) do pcall(function() desc[p] = tonumber(n) end) end
    if type(look.layered) == "table" then
        local list = {}
        for i, e in ipairs(look.layered) do
            local okT, accessoryType = pcall(function() return Enum.AccessoryType[e.t] end)
            if okT and accessoryType then
                list[#list + 1] = {AssetId = tonumber(e.id), AccessoryType = accessoryType, IsLayered = true, Order = tonumber(e.o) or i}
            end
        end
        pcall(function() desc:SetAccessories(list, false) end)
    end
    if look.strip then pcall(Avatar.strip, rig) end
    return (Avatar.applySafe(humanoid, desc)) == true
end

function Avatar.setKorblox(on)
    local rig, humanoid = Avatar.rig()
    if not (rig and humanoid) then return false end
    local ok, desc = pcall(function() return humanoid:GetAppliedDescription() end)
    if not ok or not desc then return false end
    if on then
        if Avatar.saved.RightLeg == nil then Avatar.saved.RightLeg = desc.RightLeg end
        desc.RightLeg = Avatar.KORBLOX_LEG
    else
        desc.RightLeg = Avatar.saved.RightLeg or 0
        Avatar.saved.RightLeg = nil
    end
    return (Avatar.applyPart(humanoid, desc)) == true
end

function Avatar.setHeadless(on)
    local state = Avatar.head
    if on then
        if state.conn then return end
        state.on = true
        state.conn = RunService.RenderStepped:Connect(function()
            local rig = Avatar.current
            if not (rig and rig.Parent) then rig = Avatar.rig() end
            local head = rig and rig:FindFirstChild("Head")
            if not head or not head:IsA("BasePart") then return end
            head.LocalTransparencyModifier = 1
            for _, child in ipairs(head:GetChildren()) do
                if child:IsA("Decal") then
                    if state.faces[child] == nil then state.faces[child] = child.Transparency end
                    child.Transparency = 1
                end
            end
        end)
        return
    end
    if state.conn then pcall(function() state.conn:Disconnect() end) end
    for decal, transparency in pairs(state.faces) do
        pcall(function() if decal.Parent then decal.Transparency = transparency end end)
    end
    pcall(function()
        local rig = Avatar.rig()
        local head = rig and rig:FindFirstChild("Head")
        if head and head:IsA("BasePart") then head.LocalTransparencyModifier = 0 end
    end)
    Avatar.head = {on = false, conn = nil, faces = {}}
end

function Avatar.reapply()
    local rig, humanoid = Avatar.rig()
    if not (rig and humanoid) then return end
    if Avatar.look then
        pcall(Avatar.restoreLook)
    elseif rig:GetAttribute("HydraLook") ~= nil then

        if not Avatar.ownDesc then
            local ok, desc = pcall(function() return Players:GetHumanoidDescriptionFromUserId(LocalPlayer.UserId) end)
            if ok then Avatar.ownDesc = desc end
        end
        if Avatar.ownDesc then pcall(Avatar.strip, rig) pcall(Avatar.applySafe, humanoid, Avatar.ownDesc) end
    end
    Avatar.saved.RightLeg = nil
    if Avatar.korblox then pcall(Avatar.setKorblox, true) end
    if Avatar.deleted then pcall(Avatar.removeHeadItems, rig) end
    Avatar.mark(rig)
end
function Avatar.hasSaved() return Avatar.look ~= nil or Avatar.korblox or Avatar.deleted end

Avatar.version = 1
function Avatar.mark(rig)
    if rig then pcall(function() rig:SetAttribute("HydraLook", Avatar.version) end) end
end
function Avatar.bump(rig)
    Avatar.version = Avatar.version + 1
    Avatar.mark(rig or (Avatar.rig()))
end

function Avatar.applyUser(info)
    if Avatar.busy then return false, "Esper\195\161 un momento" end
    local rig, humanoid = Avatar.rig()
    if not (rig and humanoid) then return false, "Entr\195\161 a una partida primero" end
    Avatar.busy = true
    local okDesc, desc = pcall(function() return Players:GetHumanoidDescriptionFromUserId(info.id) end)
    if not okDesc or not desc then Avatar.busy = false return false, "No se pudo cargar el avatar" end
    rig, humanoid = Avatar.rig()
    if not (rig and humanoid) then Avatar.busy = false return false, "Entr\195\161 a una partida primero" end
    pcall(Avatar.strip, rig)
    local ok = Avatar.applySafe(humanoid, desc)
    if not ok then Avatar.busy = false return false, "No se pudo aplicar el avatar" end
    Avatar.saved.RightLeg = nil
    Avatar.remember(desc, true)
    if Avatar.korblox then pcall(Avatar.setKorblox, true) end
    if Avatar.deleted then pcall(Avatar.removeHeadItems, rig) end
    Avatar.bump(rig)
    Avatar.busy = false
    return true, "\226\156\147 Avatar aplicado"
end
function Avatar.reset()
    if Avatar.busy then return false, "Esper\195\161 un momento" end
    local rig, humanoid = Avatar.rig()
    if not (rig and humanoid) then return false, "Entr\195\161 a una partida primero" end
    Avatar.busy = true
    local okDesc, desc = pcall(function() return Players:GetHumanoidDescriptionFromUserId(LocalPlayer.UserId) end)
    if not okDesc or not desc then Avatar.busy = false return false, "No se pudo cargar tu avatar" end
    Avatar.ownDesc = desc

    for _, id in ipairs({"avKorblox", "avHeadless", "avDeleted"}) do
        local option = Hydra.Options[id]
        if option then option:Set(false, true) end
    end
    Avatar.korblox, Avatar.deleted = false, false
    Avatar.saved = {}
    Avatar.setHeadless(false)
    Avatar.look = nil
    Avatar.saveFile()
    rig, humanoid = Avatar.rig()
    if not (rig and humanoid) then Avatar.busy = false return false, "Entr\195\161 a una partida primero" end
    pcall(Avatar.strip, rig)
    local ok = Avatar.applySafe(humanoid, desc)
    Avatar.bump(rig)
    Avatar.busy = false
    if not ok then return false, "No se pudo restablecer" end
    return true, "\226\156\147 Tu skin original volvi\195\179"
end

Hydra:AddTranslations({
    ["Avatar"] = "Avatar",
    ["Esper\195\161 un momento"] = "Wait a moment", ["Entr\195\161 a una partida primero"] = "Join a match first",
    ["No se pudo cargar el avatar"] = "The avatar could not be loaded", ["No se pudo aplicar el avatar"] = "The avatar could not be applied",
    ["\226\156\147 Avatar aplicado"] = "\226\156\147 Avatar applied", ["No se pudo cargar tu avatar"] = "Your avatar could not be loaded",
    ["No se pudo restablecer"] = "Could not reset", ["\226\156\147 Tu skin original volvi\195\179"] = "\226\156\147 Your original skin is back",
    ["Restablecer skin"] = "Reset skin", ["Vuelve a tu avatar original"] = "Goes back to your original avatar",
    ["Pierna Korblox"] = "Korblox leg", ["Pierna derecha Korblox"] = "Korblox right leg",
    ["Cabeza invisible"] = "Invisible head", ["Sin cabeza y sin accesorios de la cabeza"] = "No head and no head accessories",
    ["Se pone cuando entres a una partida"] = "It applies when you join a match",
})

TabExtra:Section("Avatar", "A")
local AvatarSearch = TabExtra:PlayerSearch({Placeholder = "Nombre de usuario", ButtonText = "Aplicar",
    Callback = function(info) return Avatar.applyUser(info) end})
TabExtra:Button({Title = "Restablecer skin", Desc = "Vuelve a tu avatar original", Icon = "A",
    Callback = function()
        task.spawn(function()
            local ok, message = Avatar.reset()
            AvatarSearch:SetStatus(message, ok and "ok" or "bad")
            Hydra:Notify(Hydra:T(message))
        end)
    end})
TabExtra:Toggle({Id = "avKorblox", Title = "Pierna Korblox", Desc = "Pierna derecha Korblox", Icon = "A",
    Callback = function(on)
        Avatar.korblox = on
        task.spawn(function()
            if not Avatar.rig() then
                if on then Hydra:Notify(Hydra:T("Se pone cuando entres a una partida")) end
                return
            end
            if not on and Avatar.saved.RightLeg == nil then Avatar.bump() return end
            pcall(Avatar.setKorblox, on)
            Avatar.bump()
        end)
    end})
local HeadlessToggle, DeletedToggle
HeadlessToggle = TabExtra:Toggle({Id = "avHeadless", Title = "Headless", Desc = "Cabeza invisible", Icon = "A",
    Callback = function(on)
        if on and DeletedToggle and DeletedToggle:Get() then DeletedToggle:Set(false, true) Avatar.deleted = false end
        Avatar.setHeadless(on or (DeletedToggle ~= nil and DeletedToggle:Get()))
    end})
DeletedToggle = TabExtra:Toggle({Id = "avDeleted", Title = "Headless + Deleted", Desc = "Sin cabeza y sin accesorios de la cabeza", Icon = "A",
    Callback = function(on)
        if on and HeadlessToggle:Get() then HeadlessToggle:Set(false, true) end
        Avatar.deleted = on
        Avatar.setHeadless(on or HeadlessToggle:Get())
        if on then pcall(Avatar.removeHeadItems, (Avatar.rig())) end
        Avatar.bump()
    end})
Avatar.korblox, Avatar.deleted = Hydra.Options.avKorblox:Get(), DeletedToggle:Get()

Avatar.loadFile()
task.spawn(function()
    while true do
        task.wait(0.5)
        local rig = Avatar.rig()
        Avatar.current = rig
        if rig and not Avatar.busy then
            local mark = rig:GetAttribute("HydraLook")
            if mark ~= Avatar.version and (Avatar.hasSaved() or mark ~= nil) then
                task.wait(0.6)
                if Avatar.rig() == rig and not Avatar.busy then
                    Avatar.busy = true
                    pcall(Avatar.reapply)
                    Avatar.busy = false
                end
            end
        end
    end
end)

TabExtra:Section("Unlock All", "\226\156\142")
local UnlockToggle
UnlockToggle = TabExtra:Toggle({Id = "unlockAll", Title = "Unlock All", Desc = "Desbloquea todo de forma visual (solo lo ves vos)", Icon = "\226\156\142", Keybind = true, Floating = true,
    Callback = function(on)
        if not UA then
            Hydra:Notify("Unlock All: " .. Hydra:T("No disponible en este ejecutor"))
            task.defer(function() UnlockToggle:Set(false, true) end)
            return
        end
        if not on then
            pcall(UA.Disable)
            return
        end
        local logStart = type(UA.Log) == "table" and #UA.Log or 0
        pcall(UA.Enable)
        Unlock.Waiting = Unlock.Waiting + 1
        local token = Unlock.Waiting

        task.spawn(function()
            local t0 = os.clock()
            while os.clock() - t0 < 20 and token == Unlock.Waiting do
                local okOn, isOn = pcall(UA.IsEnabled)
                if okOn and isOn then
                    Hydra:Notify(Hydra:T("Unlock All activo"))
                    if Unlock.AutoLook then task.wait(0.5) Unlock.loadLook() end
                    local boombox = Hydra.Options.uaBoombox and Hydra.Options.uaBoombox:Get()
                    if boombox ~= nil then pcall(UA.SetBoombox, boombox) end
                    return
                end

                local failed = false
                for i = logStart + 1, (type(UA.Log) == "table" and #UA.Log or 0) do
                    local line = tostring(UA.Log[i]):gsub("^%[Hydra%-UnlockAll%]%s*", "")
                    if string.find(line, "^ABORTADO") or string.find(line, "^FALLO") then failed = true end
                end
                if failed then break end
                task.wait(0.3)
            end
            if token ~= Unlock.Waiting then return end
            Hydra:Notify(Hydra:T("Unlock All no se pudo activar"))
            task.defer(function() UnlockToggle:Set(false, true) end)
        end)
    end})

for _, kind in ipairs({
    {"Cosmetic", "Cosm\195\169ticos"}, {"Character", "Personajes"}, {"Unusual", "Unusuals"}, {"Perk", "Perks"},
    {"CarryAnimation", "Animaci\195\179n de cargar"}, {"Nametag", "Nametags"}, {"Boombox", "Boombox"},
}) do
    local typeName = kind[1]
    UnlockToggle:Toggle({Id = "uaType" .. typeName, Title = kind[2], Default = true,
        Callback = function(on) if UA then pcall(UA.SetType, typeName, on) end end})
end

for _, kind in ipairs({{"Perk", "Perk en partida"}, {"Nametag", "Nametag en partida"}, {"Boombox", "Boombox en partida"}}) do
    local typeName = kind[1]
    UnlockToggle:Toggle({Id = "uaInGame" .. typeName, Title = kind[2], Desc = "Tambi\195\169n se ve durante la ronda", Default = true,
        Callback = function(on) if UA then pcall(UA.SetInGame, typeName, on) end end})
end
UnlockToggle:Dropdown({Id = "uaBoombox", Title = "Skin del boombox", Desc = "Eleg\195\173 cualquiera",
    Options = function()
        local list = {}
        if UA then
            local ok, skins = pcall(UA.GetBoomboxSkins)
            if ok and type(skins) == "table" then
                for _, skin in ipairs(skins) do list[#list + 1] = {value = skin.id, text = skin.name} end
            end
        end
        return list
    end,
    Callback = function(id)
        if UA and UA.IsEnabled() then pcall(UA.SetBoombox, id) end
    end})
UnlockToggle:Button({Title = "Look aleatorio", Desc = "Emotes, cosm\195\169ticos y skins al azar",
    Callback = function()
        if not (UA and UA.IsEnabled()) then Hydra:Notify(Hydra:T("Activ\195\161 Unlock All primero")) return end
        local snap = UA.RandomLook()
        if snap then UA.ApplySnapshot(snap) Hydra:Notify(Hydra:T("Look aplicado")) end
    end})
UnlockToggle:Button({Title = "Guardar mi look", Desc = "Lo que ten\195\169s puesto ahora",
    Callback = function()
        if not (UA and UA.IsEnabled()) then Hydra:Notify(Hydra:T("Activ\195\161 Unlock All primero")) return end
        Hydra:Notify(Hydra:T(Unlock.saveLook() and "Look guardado" or "Tu ejecutor no puede guardar archivos"))
    end})
UnlockToggle:Button({Title = "Cargar mi look", Desc = "El \195\186ltimo que guardaste",
    Callback = function()
        if not (UA and UA.IsEnabled()) then Hydra:Notify(Hydra:T("Activ\195\161 Unlock All primero")) return end
        Hydra:Notify(Hydra:T(Unlock.loadLook() and "Look aplicado" or "No hay un look guardado"))
    end})
UnlockToggle:Toggle({Id = "uaAutoLook", Title = "Cargar mi look al activar", Desc = "Se pone solo cada vez que lo prend\195\169s", Default = true,
    Callback = function(on) Unlock.AutoLook = on end})
Unlock.AutoLook = Hydra.Options.uaAutoLook:Get()

if UA then
    for _, typeName in ipairs({"Cosmetic", "Character", "Unusual", "Perk", "CarryAnimation", "Nametag", "Boombox"}) do
        pcall(UA.SetType, typeName, Hydra.Options["uaType" .. typeName]:Get())
    end
    for _, typeName in ipairs({"Perk", "Nametag", "Boombox"}) do
        pcall(UA.SetInGame, typeName, Hydra.Options["uaInGame" .. typeName]:Get())
    end
end

local WallWalk = {Enabled = false, Walking = true, original = nil}
function WallWalk.states()
    local ok, info = pcall(function() return require(Core.module("Objects", "Game", "Character", "Shared", "StateInfo")) end)
    if not ok or type(info) ~= "table" or type(info.GetState) ~= "function" then return {} end
    local list = {}
    for _, name in ipairs({"WallrunLeft", "WallrunRight"}) do
        local okState, state = pcall(info.GetState, info, name)
        if okState and type(state) == "table" and type(state.Requirements) == "table" then list[#list + 1] = state end
    end
    return list
end

function WallWalk.speedRule()
    local lower = WallWalk.Enabled and WallWalk.Walking
    for _, state in ipairs(WallWalk.states()) do
        local rule = state.Requirements.RelativeSpeedTest
        if type(rule) == "table" then
            if WallWalk.original == nil and rule[2] ~= 0 then WallWalk.original = rule[2] end
            rule[2] = lower and 0 or (WallWalk.original or 20)
        end
    end
end
Core.steps.wallWalk = function(ctx)
    if not WallWalk.Enabled or not ctx.movement then return end
    local state = ctx.movement.State
    if state ~= "WallrunLeft" and state ~= "WallrunRight" then return end

    pcall(function()
        local force = ctx.movement.Constraints.Constraints.WallrunForce
        force.Force = Vector3.new(0, ctx.root:GetMass() * workspace.Gravity, 0)
    end)

    local v = ctx.root.AssemblyLinearVelocity
    if v.Y < 0 then ctx.root.AssemblyLinearVelocity = Vector3.new(v.X, 0, v.Z) end
end

Hydra:AddTranslations({
    ["Pared"] = "Wall",
    ["No te ca\195\169s mientras corr\195\169s por la pared"] = "You don't fall while running on the wall",
    ["Tambi\195\169n caminando"] = "Also walking", ["Te qued\195\161s en la pared aunque camines o frenes"] = "You stay on the wall even if you walk or stop",
})
TabExtra:Section("Pared", "W")
local WallToggle
WallToggle = TabExtra:Toggle({Id = "wallWalk", Title = "Wall Walk", Desc = "No te ca\195\169s mientras corr\195\169s por la pared", Icon = "W", Keybind = true, Floating = true,
    Callback = function(on)
        if on and not Core.hook() then
            Hydra:Notify("Wall Walk: " .. Hydra:T("No disponible en este ejecutor"))
            task.defer(function() WallToggle:Set(false, true) end)
            return
        end
        WallWalk.Enabled = on
        WallWalk.speedRule()
    end})
WallToggle:Toggle({Id = "wallWalkSlow", Title = "Tambi\195\169n caminando", Desc = "Te qued\195\161s en la pared aunque camines o frenes", Default = true,
    Callback = function(on)
        WallWalk.Walking = on
        WallWalk.speedRule()
    end})
WallWalk.Walking = Hydra.Options.wallWalkSlow:Get()

local Cam = {On = false, Extra = 12, Height = 1.5, Fov = false, FovValue = 90, Cur = 0, Conn = nil, CS = nil, rays = RaycastParams.new()}
Cam.rays.FilterType = Enum.RaycastFilterType.Exclude
pcall(function() Cam.CS = require(Core.module("Services", "Client", "CameraService")) end)
function Cam.step(dt)
    local cs = Cam.CS
    local want = Cam.On and Cam.Extra or 0
    if want > 0 then
        local base = cs.CameraCFrame
        if typeof(base) == "CFrame" then
            local ignore = {}
            if LocalPlayer.Character then ignore[#ignore + 1] = LocalPlayer.Character end
            for _, name in ipairs({"Players", "Rigs"}) do
                local folder = workspace:FindFirstChild(name)
                if folder then ignore[#ignore + 1] = folder end
            end
            Cam.rays.FilterDescendantsInstances = ignore
            local back = base:VectorToWorldSpace(Vector3.new(0, Cam.Height * (want / 20), want))
            local hit = workspace:Raycast(base.Position, back + back.Unit * 0.8, Cam.rays)
            if hit then want = math.max(0, want * ((hit.Distance - 0.8) / (back.Magnitude + 0.8))) end
        end
    end

    Cam.Cur = Cam.Cur + (want - Cam.Cur) * math.min(1, dt * 10)
    if Cam.Cur < 0.01 and not Cam.On then
        cs:SetCameraOffset("HydraDistance", nil)
    else
        cs:SetCameraOffset("HydraDistance", CFrame.new(0, Cam.Height * (Cam.Cur / 20), Cam.Cur))
    end
    if Cam.Fov then
        local baseFov = tonumber(cs.BaseFOV) or 70
        cs:AdjustFOV("HydraFov", math.clamp(Cam.FovValue / math.max(baseFov, 1), 0.3, 3))
    else
        cs:AdjustFOV("HydraFov", nil)
    end
end

function Cam.loop()
    if Cam.Conn or not Cam.CS then return end
    Cam.Conn = RunService.RenderStepped:Connect(function(dt)
        local ok = pcall(Cam.step, dt)
        if (not ok) or (not Cam.On and not Cam.Fov and Cam.Cur < 0.01) then
            pcall(function()
                Cam.CS:SetCameraOffset("HydraDistance", nil)
                Cam.CS:AdjustFOV("HydraFov", nil)
            end)
            if Cam.Conn then Cam.Conn:Disconnect() Cam.Conn = nil end
        end
    end)
end

Hydra:AddTranslations({
    ["C\195\161mara"] = "Camera", ["C\195\161mara lejana"] = "Far camera", ["Aleja la c\195\161mara de tu personaje"] = "Moves the camera away from your character",
    ["Distancia"] = "Range", ["Cu\195\161nto se aleja"] = "How far it goes",
    ["Campo de visi\195\179n"] = "Field of view", ["M\195\161s o menos \195\161ngulo de visi\195\179n"] = "Wider or narrower view", ["Grados"] = "Degrees",
})
TabExtra:Section("C\195\161mara", "C")
local function cameraToggle(o)
    local toggle
    toggle = TabExtra:Toggle({Id = o.Id, Title = o.Title, Desc = o.Desc, Icon = "C", Keybind = true, Floating = true,
        Callback = function(on)
            if on and not Cam.CS then
                Hydra:Notify(Hydra:T(o.Title) .. ": " .. Hydra:T("No disponible en este ejecutor"))
                task.defer(function() toggle:Set(false, true) end)
                return
            end
            o.set(on)
            Cam.loop()
        end})
    return toggle
end
local FarToggle = cameraToggle({Id = "camFar", Title = "C\195\161mara lejana", Desc = "Aleja la c\195\161mara de tu personaje", set = function(on) Cam.On = on end})
FarToggle:Slider({Id = "camDistance", Title = "Distancia", Desc = "Cu\195\161nto se aleja", Min = 0, Max = 40, Step = 1, Default = 12, Suffix = " m",
    Callback = function(v) Cam.Extra = math.clamp(tonumber(v) or 0, 0, 40) end})
local FovToggle = cameraToggle({Id = "camFov", Title = "FOV", Desc = "M\195\161s o menos \195\161ngulo de visi\195\179n", set = function(on) Cam.Fov = on end})
FovToggle:Slider({Id = "camFovValue", Title = "Campo de visi\195\179n", Desc = "Grados", Min = 50, Max = 120, Step = 1, Default = 90, Suffix = "\194\176",
    Callback = function(v) Cam.FovValue = math.clamp(tonumber(v) or 90, 50, 120) end})
Cam.Extra, Cam.FovValue = Hydra.Options.camDistance:Get(), Hydra.Options.camFovValue:Get()
