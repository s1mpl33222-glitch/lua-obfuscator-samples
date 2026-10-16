local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local TextService = game:GetService("TextService")
local LocalPlayer = Players.LocalPlayer

local NAME = "YinYang_Mantenimiento"
local GROUP_IMG = "rbxassetid://97389367768202"

local TEXT_ES = {
    chip = "EN MANTENIMIENTO",
    body = "Nuestro script estará en mantenimiento hasta mañana, sea paciente, y lamentamos lo ocurrido, volverá Yin Yang!",
    button = "Entendido",
}

local LANGS = {
    es = TEXT_ES,
    en = {
        chip = "UNDER MAINTENANCE",
        body = "Our script is under maintenance, please be patient, and we are sorry for what happened. Yin Yang will be back soon!",
        button = "Got it",
    },
    pt = {
        chip = "EM MANUTENÇÃO",
        body = "Nosso script está em manutenção, tenha paciência, e lamentamos o ocorrido. O Yin Yang voltará em breve!",
        button = "Entendi",
    },
    fr = {
        chip = "EN MAINTENANCE",
        body = "Notre script est en maintenance, merci de patienter, et nous sommes désolés pour ce qui s'est passé. Yin Yang reviendra bientôt !",
        button = "Compris",
    },
    de = {
        chip = "IN WARTUNG",
        body = "Unser Script wird gerade gewartet, bitte habt Geduld. Es tut uns leid, was passiert ist. Yin Yang ist bald zurück!",
        button = "Verstanden",
    },
    it = {
        chip = "IN MANUTENZIONE",
        body = "Il nostro script è in manutenzione, abbiate pazienza, e ci scusiamo per l'accaduto. Yin Yang tornerà presto!",
        button = "Capito",
    },
    ru = {
        chip = "ТЕХНИЧЕСКОЕ ОБСЛУЖИВАНИЕ",
        body = "Наш скрипт находится на техническом обслуживании, пожалуйста, наберитесь терпения. Приносим извинения за случившееся. Yin Yang скоро вернётся!",
        button = "Понятно",
    },
    tr = {
        chip = "BAKIMDA",
        body = "Scriptimiz bakımda, lütfen sabırlı olun. Yaşananlar için özür dileriz. Yin Yang yakında geri dönecek!",
        button = "Anladım",
    },
    id = {
        chip = "SEDANG PEMELIHARAAN",
        body = "Script kami sedang dalam pemeliharaan, mohon bersabar, dan kami mohon maaf atas apa yang terjadi. Yin Yang akan segera kembali!",
        button = "Mengerti",
    },
    vi = {
        chip = "ĐANG BẢO TRÌ",
        body = "Script của chúng tôi đang được bảo trì, vui lòng kiên nhẫn. Chúng tôi xin lỗi về sự cố vừa qua. Yin Yang sẽ sớm quay trở lại!",
        button = "Đã hiểu",
    },
    pl = {
        chip = "PRZERWA TECHNICZNA",
        body = "Nasz skrypt jest w trakcie konserwacji, prosimy o cierpliwość. Przepraszamy za to, co się stało. Yin Yang wkrótce wróci!",
        button = "Rozumiem",
    },
    ja = {
        chip = "メンテナンス中",
        body = "現在スクリプトはメンテナンス中です。今回の件についてお詫び申し上げます。しばらくお待ちください。Yin Yang はまもなく戻ってきます！",
        button = "了解",
    },
    ko = {
        chip = "점검 중",
        body = "현재 스크립트가 점검 중입니다. 불편을 드려 죄송하며, 조금만 기다려 주세요. Yin Yang은 곧 돌아옵니다!",
        button = "확인",
    },
    ["zh-CN"] = {
        chip = "维护中",
        body = "我们的脚本正在维护中，请耐心等待，对于发生的事情我们深表歉意。Yin Yang 很快就会回来！",
        button = "知道了",
    },
    ["zh-TW"] = {
        chip = "維護中",
        body = "我們的腳本正在維護中，請耐心等待，對於發生的事情我們深感抱歉。Yin Yang 很快就會回來！",
        button = "知道了",
    },
    ar = {
        chip = "قيد الصيانة",
        body = "السكربت الخاص بنا قيد الصيانة، يرجى التحلي بالصبر، ونعتذر عما حدث. سيعود Yin Yang قريبًا!",
        button = "حسنًا",
    },
}

local function detectLang()
    local loc = ""
    pcall(function() loc = tostring(game:GetService("LocalizationService").RobloxLocaleId or "") end)
    if loc == "" then pcall(function() loc = tostring(LocalPlayer.LocaleId or "") end) end
    if loc == "" then pcall(function() loc = tostring(game:GetService("LocalizationService").SystemLocaleId or "") end) end
    loc = string.lower(loc ~= "" and loc or "es-es"):gsub("_", "-")
    local lang = loc:match("^(%a+)") or "es"
    if lang == "zh" then lang = (loc:find("tw") or loc:find("hk") or loc:find("hant")) and "zh-TW" or "zh-CN" end
    return lang
end

local function getRequest()
    return (syn and syn.request) or (http and http.request) or fluxus_request or http_request or request
end

local function googleTranslate(text, tl)
    local req = getRequest()
    if not req then return nil end
    local ok, res = pcall(function()
        return req({
            Url = "https://translate.googleapis.com/translate_a/single?client=gtx&sl=es&tl=" .. HttpService:UrlEncode(tl)
                .. "&dt=t&q=" .. HttpService:UrlEncode(text),
            Method = "GET",
        })
    end)
    if not ok or type(res) ~= "table" or type(res.Body) ~= "string" or res.Body == "" then return nil end
    local okD, data = pcall(HttpService.JSONDecode, HttpService, res.Body)
    if not okD or type(data) ~= "table" or type(data[1]) ~= "table" then return nil end
    local out = {}
    for _, seg in ipairs(data[1]) do
        if type(seg) == "table" and type(seg[1]) == "string" then out[#out + 1] = seg[1] end
    end
    return #out > 0 and table.concat(out) or nil
end

local function robloxTranslate(text, tl)
    local ok, out = pcall(function()
        local r = TextService:FilterAndTranslateStringAsync(text, LocalPlayer.UserId, {tl})
        local t = r:GetTranslations()
        if type(t) ~= "table" then return nil end
        local v = t[tl]
        if v == nil then for _, x in pairs(t) do v = x break end end
        return type(v) == "string" and v ~= "" and v ~= text and v or nil
    end)
    return ok and out or nil
end

local function translate(text, tl)
    return robloxTranslate(text, tl) or googleTranslate(text, tl)
end

pcall(function()
    local pg = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    local old = pg and pg:FindFirstChild(NAME)
    if old then old:Destroy() end
end)

local function mk(className, props, parent)
    local obj = Instance.new(className)
    for k, v in pairs(props or {}) do obj[k] = v end
    obj.Parent = parent
    return obj
end

local function corner(obj, r)
    return mk("UICorner", {CornerRadius = UDim.new(0, r)}, obj)
end

local function tween(obj, t, props, style)
    local tw = TweenService:Create(obj, TweenInfo.new(t, style or Enum.EasingStyle.Quint, Enum.EasingDirection.Out), props)
    tw:Play()
    return tw
end

local Gui = mk("ScreenGui", {
    Name = NAME,
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    DisplayOrder = 2147483000,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
}, LocalPlayer:WaitForChild("PlayerGui"))

local Dim = mk("Frame", {
    Size = UDim2.fromScale(1, 1),
    BackgroundColor3 = Color3.new(0, 0, 0),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
}, Gui)

local Card = mk("Frame", {
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.fromOffset(440, 0),
    AutomaticSize = Enum.AutomaticSize.Y,
    BackgroundColor3 = Color3.fromRGB(14, 14, 16),
    BorderSizePixel = 0,
}, Dim)
corner(Card, 26)
local Scale = mk("UIScale", {Scale = 0.85}, Card)
local cardStroke = mk("UIStroke", {Color = Color3.new(1, 1, 1), Thickness = 1.6, Transparency = 0.1}, Card)
mk("UIGradient", {
    Rotation = 35,
    Color = ColorSequence.new(Color3.fromRGB(131, 58, 180), Color3.fromRGB(64, 93, 230)),
}, cardStroke)
mk("UIGradient", {
    Rotation = 90,
    Color = ColorSequence.new(Color3.fromRGB(28, 22, 44), Color3.fromRGB(12, 12, 14)),
}, Card)
mk("UIPadding", {
    PaddingTop = UDim.new(0, 26), PaddingBottom = UDim.new(0, 24),
    PaddingLeft = UDim.new(0, 26), PaddingRight = UDim.new(0, 26),
}, Card)
mk("UIListLayout", {
    SortOrder = Enum.SortOrder.LayoutOrder,
    HorizontalAlignment = Enum.HorizontalAlignment.Center,
    Padding = UDim.new(0, 14),
}, Card)

local Logo = mk("ImageLabel", {
    Size = UDim2.fromOffset(84, 84),
    BackgroundColor3 = Color3.fromRGB(28, 28, 32),
    BorderSizePixel = 0,
    Image = GROUP_IMG,
    ScaleType = Enum.ScaleType.Crop,
    LayoutOrder = 1,
}, Card)
corner(Logo, 42)
local ring = mk("UIStroke", {Color = Color3.new(1, 1, 1), Thickness = 3}, Logo)
local ringGrad = mk("UIGradient", {
    Rotation = 0,
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(254, 218, 117)),
        ColorSequenceKeypoint.new(0.35, Color3.fromRGB(250, 126, 30)),
        ColorSequenceKeypoint.new(0.65, Color3.fromRGB(214, 41, 118)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 47, 191)),
    }),
}, ring)

local Title = mk("TextLabel", {
    Size = UDim2.new(1, 0, 0, 44),
    BackgroundTransparency = 1,
    Text = "Yin Yang",
    TextColor3 = Color3.new(1, 1, 1),
    Font = Enum.Font.GothamBlack,
    TextSize = 38,
    TextXAlignment = Enum.TextXAlignment.Center,
    LayoutOrder = 2,
}, Card)
mk("UIStroke", {Color = Color3.new(1, 1, 1), Thickness = 1.2, Transparency = 0.72, ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual}, Title)
local shine = mk("UIGradient", {
    Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.65),
        NumberSequenceKeypoint.new(0.5, 0),
        NumberSequenceKeypoint.new(1, 0.65),
    }),
    Offset = Vector2.new(-1, 0),
}, Title)

local Chip = mk("Frame", {
    Size = UDim2.fromOffset(0, 28),
    AutomaticSize = Enum.AutomaticSize.X,
    BackgroundColor3 = Color3.fromRGB(255, 196, 0),
    BackgroundTransparency = 0.85,
    BorderSizePixel = 0,
    LayoutOrder = 3,
}, Card)
corner(Chip, 14)
mk("UIStroke", {Color = Color3.fromRGB(255, 196, 0), Thickness = 1, Transparency = 0.45}, Chip)
mk("UIPadding", {PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 14)}, Chip)
mk("UIListLayout", {
    FillDirection = Enum.FillDirection.Horizontal,
    VerticalAlignment = Enum.VerticalAlignment.Center,
    Padding = UDim.new(0, 8),
    SortOrder = Enum.SortOrder.LayoutOrder,
}, Chip)
local Dot = mk("Frame", {
    Size = UDim2.fromOffset(8, 8),
    BackgroundColor3 = Color3.fromRGB(255, 196, 0),
    BorderSizePixel = 0,
    LayoutOrder = 1,
}, Chip)
corner(Dot, 4)
local ChipText = mk("TextLabel", {
    Size = UDim2.fromOffset(0, 28),
    AutomaticSize = Enum.AutomaticSize.X,
    BackgroundTransparency = 1,
    Text = TEXT_ES.chip,
    TextColor3 = Color3.fromRGB(255, 214, 90),
    Font = Enum.Font.GothamBlack,
    TextSize = 12,
    LayoutOrder = 2,
}, Chip)

local Body = mk("TextLabel", {
    Size = UDim2.new(1, 0, 0, 0),
    AutomaticSize = Enum.AutomaticSize.Y,
    BackgroundTransparency = 1,
    Text = TEXT_ES.body,
    TextColor3 = Color3.fromRGB(215, 215, 222),
    Font = Enum.Font.GothamMedium,
    TextSize = 18,
    TextWrapped = true,
    LineHeight = 1.15,
    TextXAlignment = Enum.TextXAlignment.Center,
    LayoutOrder = 4,
}, Card)

mk("Frame", {Size = UDim2.new(1, 0, 0, 2), BackgroundTransparency = 1, LayoutOrder = 5}, Card)

local Button = mk("TextButton", {
    Size = UDim2.new(1, 0, 0, 48),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    Text = "",
    AutoButtonColor = false,
    LayoutOrder = 6,
}, Card)
local ButtonBg = mk("Frame", {
    Size = UDim2.fromScale(1, 1),
    BackgroundColor3 = Color3.new(1, 1, 1),
    BorderSizePixel = 0,
}, Button)
corner(ButtonBg, 16)
mk("UIGradient", {
    Color = ColorSequence.new(Color3.fromRGB(131, 58, 180), Color3.fromRGB(64, 93, 230)),
}, ButtonBg)
local ButtonText = mk("TextLabel", {
    Size = UDim2.fromScale(1, 1),
    BackgroundTransparency = 1,
    Text = TEXT_ES.button,
    TextColor3 = Color3.new(1, 1, 1),
    Font = Enum.Font.GothamBlack,
    TextSize = 17,
    ZIndex = 2,
}, Button)

local function applyTexts(t)
    ChipText.Text = t.chip or TEXT_ES.chip
    Body.Text = t.body or TEXT_ES.body
    ButtonText.Text = t.button or TEXT_ES.button
end

local function fit()
    local cam = workspace.CurrentCamera
    local vp = cam and cam.ViewportSize or Vector2.new(1280, 720)
    local w = math.clamp(vp.X * 0.88, 280, 440)
    Card.Size = UDim2.fromOffset(w, 0)
    local s = math.clamp(math.min(vp.X / 520, vp.Y / 560), 0.72, 1.15)
    Scale.Scale = s
    Body.TextSize = vp.X < 500 and 16 or 18
end
fit()
pcall(function()
    workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(fit)
end)

local alive = true
local function close()
    if not alive then return end
    alive = false
    tween(Scale, 0.25, {Scale = Scale.Scale * 0.85})
    tween(Dim, 0.25, {BackgroundTransparency = 1})
    tween(Card, 0.25, {BackgroundTransparency = 1})
    task.delay(0.27, function() Gui:Destroy() end)
end
Button.MouseButton1Click:Connect(close)
Button.MouseEnter:Connect(function() tween(ButtonBg, 0.15, {BackgroundTransparency = 0.12}) end)
Button.MouseLeave:Connect(function() tween(ButtonBg, 0.15, {BackgroundTransparency = 0}) end)

pcall(function()
    TweenService:Create(shine, TweenInfo.new(1.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, false, 0.6), {Offset = Vector2.new(1, 0)}):Play()
end)
task.spawn(function()
    while alive and Gui.Parent do
        ringGrad.Rotation = (ringGrad.Rotation + 2) % 360
        task.wait(0.03)
    end
end)
task.spawn(function()
    while alive and Gui.Parent do
        tween(Dot, 0.6, {BackgroundTransparency = 0.7}, Enum.EasingStyle.Sine)
        task.wait(0.6)
        tween(Dot, 0.6, {BackgroundTransparency = 0}, Enum.EasingStyle.Sine)
        task.wait(0.6)
    end
end)

local targetScale = Scale.Scale
Scale.Scale = targetScale * 0.85
tween(Dim, 0.35, {BackgroundTransparency = 0.45})
tween(Scale, 0.45, {Scale = targetScale}, Enum.EasingStyle.Back)

local lang = detectLang()
local known = LANGS[lang] or LANGS[(lang:match("^(%a+)") or "")]
if known then
    applyTexts(known)
else
    applyTexts(LANGS.en)
    task.spawn(function()
        local out = {}
        for _, key in ipairs({"chip", "body", "button"}) do
            out[key] = translate(TEXT_ES[key], lang)
            if not out[key] then return end
        end
        if alive and Gui.Parent then
            out.chip = string.upper(out.chip)
            applyTexts(out)
        end
    end)
end
