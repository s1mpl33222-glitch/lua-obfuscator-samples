-- =========================================================================
-- 🌶️ KAI ROBLOX LOADER MENU V6.0 — CHILLI x VENYX VIỆT HÓA
-- Được share bởi Kai Roblox
-- V6.0: Đổi tên Chilli x Venyx, thêm Sự Kiện Halloween, Quái Vật Halloween,
--       Chó Ma & Câu Cá, Tàu Tốc Hành Bóng Ma. Việt hóa toàn bộ giao diện.
-- =========================================================================

local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- ═══════════════════════════════════════════════════════════════════
-- ⚙️ CẤU HÌNH
-- ═══════════════════════════════════════════════════════════════════
local CONFIG = {
    ScriptURL = "https://id.tomroblox.com/raw/kairoblox/chilli-x-venyx-v6",
    AuthorName = "Kai Roblox",
    HubName = "Chilli x Venyx",
    -- Logo: điền "rbxassetid://ID" nếu có; nếu để trống sẽ thử tải từ LogoURL (cần writefile + getcustomasset)
    LogoImageId = "",
    LogoURL = "https://i.ibb.co/JwYwzW1x/file-00000000dbe481faa20bf82514925602.png",
    DiscordLink = "https://discord.gg/WC4QDfTyXX",
    DiscordLabel = "discord.gg/WC4QDfTyXX",
    YouTubeLink = "https://youtube.com/@startkairoblox",
    YouTubeLabel = "youtube.com/@startkairoblox",
    Version = "v6.0.0",
    AutoHideDelay = 0.8,
    GameLoadTimeout = 10, -- giây chờ game load xong trước khi chạy script
}

local UPDATES_V6 = {
    { Icon = "🎃", Title = "Sự Kiện Chiều Không Gian Halloween", Color = Color3.fromRGB(251, 146, 60) },
    { Icon = "👻", Title = "Quái Vật Halloween",                 Color = Color3.fromRGB(192, 132, 252) },
    { Icon = "🎣", Title = "Chó Ma & Câu Cá",                    Color = Color3.fromRGB(56, 189, 248) },
    { Icon = "🚂", Title = "Tàu Tốc Hành Bóng Ma",               Color = Color3.fromRGB(74, 222, 128) },
}

-- ═══════════════════════════════════════════════════════════════════
-- 🧰 HELPER UI
-- ═══════════════════════════════════════════════════════════════════
local function New(class, props, children)
    local inst = Instance.new(class)
    for k, v in pairs(props or {}) do
        if k ~= "Parent" then inst[k] = v end
    end
    for _, c in ipairs(children or {}) do c.Parent = inst end
    if props and props.Parent then inst.Parent = props.Parent end
    return inst
end

local function Round(parent, px)
    return New("UICorner", { CornerRadius = UDim.new(0, px), Parent = parent })
end

local function Circle(parent)
    return New("UICorner", { CornerRadius = UDim.new(1, 0), Parent = parent })
end

local function Stroke(parent, color, thickness)
    return New("UIStroke", { Color = color, Thickness = thickness or 1, Parent = parent })
end

local function Label(props)
    props.BackgroundTransparency = 1
    props.Font = props.Font or Enum.Font.GothamMedium
    props.TextXAlignment = props.TextXAlignment or Enum.TextXAlignment.Left
    return New("TextLabel", props)
end

local CENTER = Enum.TextXAlignment.Center

-- ═══════════════════════════════════════════════════════════════════
-- 🔎 KIỂM TRA EXECUTOR + TẢI SCRIPT
-- ═══════════════════════════════════════════════════════════════════
local function GetExecutorName()
    local ok, name, ver = pcall(function()
        if identifyexecutor then return identifyexecutor() end
    end)
    if ok and name then
        return tostring(name) .. (ver and (" " .. tostring(ver)) or "")
    end
    return "Không rõ"
end

local EXECUTOR = GetExecutorName()

local function HasGameHttpGet()
    local ok, fn = pcall(function() return game.HttpGet end)
    return ok and fn ~= nil
end

local function GetRequestFunction()
    local fn = (syn and syn.request) or (http and http.request) or http_request or request or (fluxus and fluxus.request)
    if type(fn) == "function" then return fn end
    return nil
end

local function GetClipboardFunction()
    local fn = setclipboard or toclipboard or set_clipboard
    if type(fn) == "function" then return fn end
    return nil
end

local function copyToClipboard(text)
    local fn = GetClipboardFunction()
    if not fn then return false end
    return (pcall(fn, text))
end

local function Has(str, ...)
    for _, needle in ipairs({ ... }) do
        if str:find(needle, 1, true) then return true end
    end
    return false
end

local STAGE_NAME = {
    env = "Kiểm tra executor",
    http = "Tải script",
    compile = "Biên dịch script",
    runtime = "Chạy script",
}

local function Err(stage, title, hint, raw)
    return { stage = stage, title = title, hint = hint, raw = tostring(raw or "") }
end

local function ClassifyHttp(raw)
    local low = tostring(raw):lower()
    if Has(low, "404", "not found") then
        return Err("http", "Không tìm thấy file script (404)",
            "Link GitHub đã bị xoá hoặc đổi tên. Hãy báo tác giả cập nhật lại ScriptURL.", raw)
    elseif Has(low, "403", "forbidden") then
        return Err("http", "GitHub từ chối truy cập (403)",
            "Link bị chặn hoặc repo chuyển sang riêng tư. Thử đổi mạng/VPN hoặc báo tác giả.", raw)
    elseif Has(low, "429", "too many") then
        return Err("http", "Bị giới hạn lượt tải (429)",
            "Bạn tải quá nhiều lần trong thời gian ngắn. Đợi 1-2 phút rồi thử lại.", raw)
    elseif Has(low, "timed out", "timeout") then
        return Err("http", "Tải script quá thời gian chờ",
            "Mạng chậm hoặc không ổn định. Kiểm tra kết nối rồi bấm thử lại.", raw)
    elseif Has(low, "ssl", "certificate", "tls") then
        return Err("http", "Lỗi chứng chỉ bảo mật (SSL)",
            "Executor không xác thực được HTTPS. Thử executor khác hoặc đổi mạng.", raw)
    elseif Has(low, "trust", "not allowed", "blocked", "not enabled", "whitelist", "permission") then
        return Err("http", "Executor chặn truy cập link",
            "Executor/HttpService đang chặn domain raw.githubusercontent.com. Thử executor khác.", raw)
    elseif Has(low, "resolve", "dns", "connect", "network", "unreachable", "internet") then
        return Err("http", "Không kết nối được mạng",
            "Không tới được GitHub. Kiểm tra Wi-Fi/4G hoặc đổi DNS/VPN.", raw)
    end
    return Err("http", "Tải script thất bại",
        "Không rõ nguyên nhân. Bấm vào khung này để copy chi tiết gửi cho tác giả.", raw)
end

local function ClassifyCompile(raw)
    local low = tostring(raw):lower()
    if Has(low, "unexpected symbol", "expected", "malformed", "unfinished", "near") then
        return Err("compile", "Executor không hiểu cú pháp script",
            "Script dùng cú pháp Luau mà executor của bạn chưa hỗ trợ. Hãy cập nhật hoặc đổi executor.", raw)
    end
    return Err("compile", "Không biên dịch được script",
        "loadstring từ chối code tải về. Có thể file bị lỗi hoặc executor hạn chế loadstring.", raw)
end

local function ClassifyRuntime(raw)
    raw = tostring(raw)
    local low = raw:lower()
    local _, fname = raw:match("attempt to call a nil value %((%a+) '([^']+)'%)")
    if fname then
        return Err("runtime", "Executor thiếu hàm: " .. fname,
            "Script cần hàm '" .. fname .. "' nhưng executor của bạn không có. Hãy dùng executor hỗ trợ đầy đủ hơn.", raw)
    elseif Has(low, "not a valid member") then
        return Err("runtime", "Thiếu hàm/đối tượng cần thiết",
            "Executor hoặc game thiếu một thành phần mà script yêu cầu. Thử vào lại game rồi chạy lại.", raw)
    elseif Has(low, "lacking capability", "lacking permission", "security", "identity", "access denied") then
        return Err("runtime", "Executor không đủ quyền (identity thấp)",
            "Executor bị giới hạn quyền nên script không chạy được. Dùng executor mạnh hơn.", raw)
    elseif Has(low, "not supported", "unsupported", "not implemented") then
        return Err("runtime", "Executor không hỗ trợ tính năng của script",
            "Một chức năng script cần chưa được executor hỗ trợ. Thử executor khác.", raw)
    elseif Has(low, "attempt to index nil", "attempt to index a nil") then
        return Err("runtime", "Script lỗi do thiếu dữ liệu game",
            "Game chưa load xong hoặc không được script hỗ trợ. Chờ vào game hẳn rồi thử lại.", raw)
    end
    return Err("runtime", "Script báo lỗi khi chạy",
        "Bấm vào khung này để copy chi tiết lỗi gửi cho tác giả.", raw)
end

local function Preflight()
    if type(loadstring) ~= "function" then
        return Err("env", "Executor không hỗ trợ loadstring",
            "Thiếu loadstring nên không thể chạy script tải về. Hãy dùng executor hỗ trợ loadstring.", "loadstring == nil")
    end
    if not HasGameHttpGet() and not GetRequestFunction() then
        return Err("env", "Executor không hỗ trợ tải từ mạng",
            "Thiếu game:HttpGet và request/http_request nên không tải được script. Đổi executor.", "HttpGet/request == nil")
    end
    return nil
end

-- Trả về (true) nếu chạy xong, hoặc (false, errTable)
local function LoadMainScript()
    local pre = Preflight()
    if pre then return false, pre end

    -- 1) Tải nội dung
    local body, rawErr
    if HasGameHttpGet() then
        local ok, res = pcall(function() return game:HttpGet(CONFIG.ScriptURL) end)
        if ok then body = res else rawErr = tostring(res) end
    end
    if body == nil then
        local req = GetRequestFunction()
        if req then
            local ok, res = pcall(req, { Url = CONFIG.ScriptURL, Method = "GET" })
            if ok and type(res) == "table" then
                local status = tonumber(res.StatusCode or res.Status)
                if res.Success == false or (status and status >= 400) then
                    local e = "HTTP " .. tostring(status) .. " " .. tostring(res.StatusMessage or "")
                    rawErr = rawErr and (rawErr .. " | " .. e) or e
                else
                    body = res.Body
                end
            elseif not ok then
                local e = tostring(res)
                rawErr = rawErr and (rawErr .. " | " .. e) or e
            end
        end
    end
    if body == nil then return false, ClassifyHttp(rawErr or "unknown") end

    if type(body) ~= "string" or body:match("^%s*$") then
        return false, Err("http", "Server trả về nội dung rỗng",
            "File script trống hoặc bị chặn. Thử lại sau hoặc báo tác giả.", "empty body")
    end
    if body:match("^%s*404: Not Found") then
        return false, ClassifyHttp("404: Not Found")
    end
    if body:match("^%s*<!DOCTYPE") or body:match("^%s*<[Hh][Tt][Mm][Ll]") then
        return false, Err("http", "Nhận về trang web thay vì code",
            "Mạng/ISP/Cloudflare chặn và trả trang HTML. Thử đổi mạng hoặc dùng VPN.", body:sub(1, 120))
    end

    -- 2) Biên dịch
    local fn, compileErr = loadstring(body)
    if not fn then return false, ClassifyCompile(compileErr) end

    -- 3) Chờ game load xong rồi chạy
    local t0 = os.clock()
    while not game:IsLoaded() and os.clock() - t0 < CONFIG.GameLoadTimeout do
        task.wait(0.2)
    end

    -- Script chính giờ có hộp chọn menu Chilli/Venyx (chờ người chơi bấm tới 20 giây), nên KHÔNG chờ nó chạy xong.
    -- Chạy ở luồng riêng, chỉ canh lỗi xảy ra ngay lúc khởi động (~1.5 giây); không lỗi thì coi là mở thành công
    -- để menu loader tự đóng, nhường chỗ cho hộp chọn menu.
    local state = { done = false, err = nil }
    task.spawn(function()
        local ok, runErr = pcall(fn)
        state.done = true
        if not ok then
            state.err = runErr
            warn("[KaiLoader V6.0] Script chính báo lỗi: " .. tostring(runErr))
        end
    end)

    local t1 = os.clock()
    while os.clock() - t1 < 1.5 and not state.done do
        task.wait(0.1)
    end
    if state.done and state.err then return false, ClassifyRuntime(state.err) end
    return true
end

local function BuildReport(e)
    return table.concat({
        "[" .. CONFIG.HubName .. " Loader " .. CONFIG.Version .. "]",
        "Executor: " .. EXECUTOR,
        "Bước lỗi: " .. (STAGE_NAME[e.stage] or e.stage),
        "Lỗi: " .. e.title,
        "Chi tiết: " .. e.raw,
        "URL: " .. CONFIG.ScriptURL,
    }, "\n")
end

-- ═══════════════════════════════════════════════════════════════════
-- 📱 RESPONSIVE
-- ═══════════════════════════════════════════════════════════════════
local BASE_W = 340
local hasYT = CONFIG.YouTubeLink ~= ""

-- Bố cục dọc (px): lưới cập nhật 2x2 cao 78 → các phần bên dưới dịch xuống
local UPDATE_Y = 146
local UPDATE_H = 78
local authorY = UPDATE_Y + UPDATE_H + 8   -- 232
local discordY = authorY + 47             -- 279
local youtubeY = discordY + 47            -- 326
local buttonY = hasYT and (youtubeY + 47) or youtubeY
local belowY = buttonY + 57
local ERR_H = 70
local NORMAL_H = belowY + 28
local ERROR_H = belowY + ERR_H + 8 + 28

local function GetResponsiveScale()
    local camera = workspace.CurrentCamera
    if not camera then return 0.7 end
    local vp = camera.ViewportSize
    local pad = 40
    return math.clamp(math.min((vp.X - pad) / BASE_W, (vp.Y - pad) / ERROR_H), 0.5, 1.0)
end

local function IsMobile()
    return UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
end

-- ═══════════════════════════════════════════════════════════════════
-- 🎨 KHỞI TẠO UI
-- ═══════════════════════════════════════════════════════════════════
local parentTarget = (gethui and gethui()) or CoreGui or LocalPlayer:WaitForChild("PlayerGui")

for _, name in ipairs({ "KaiRoblox_Menu", "KaiRoblox_Toast" }) do
    local old = parentTarget:FindFirstChild(name)
    if old then old:Destroy() end
end

local ScreenGui = New("ScreenGui", {
    Name = "KaiRoblox_Menu", ResetOnSpawn = false, IgnoreGuiInset = true,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling, DisplayOrder = 2147483647,
})
pcall(function() ScreenGui.Parent = parentTarget end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

local ToastGui = New("ScreenGui", {
    Name = "KaiRoblox_Toast", ResetOnSpawn = false, DisplayOrder = 2147483646,
})
pcall(function() ToastGui.Parent = parentTarget end)
if not ToastGui.Parent then ToastGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

-- ═══════ KHUNG CHÍNH ═══════
local MainFrame = New("Frame", {
    Name = "MainFrame", AnchorPoint = Vector2.new(0.5, 0.5),
    Size = UDim2.new(0, BASE_W, 0, NORMAL_H), Position = UDim2.new(0.5, 0, 0.5, 0),
    BackgroundColor3 = Color3.fromRGB(20, 8, 10), BorderSizePixel = 0,
    ClipsDescendants = true, ZIndex = 30, Parent = ScreenGui,
})
Round(MainFrame, 16)
local MainScale = New("UIScale", { Scale = 0.5, Parent = MainFrame })
local MainStroke = New("UIStroke", {
    Thickness = 1.6, ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    Color = Color3.fromRGB(239, 68, 68), Parent = MainFrame,
})

-- Quản lý kết nối để dọn sạch khi đóng
local connections = {}
local function Track(conn) table.insert(connections, conn) return conn end

Track(RunService.RenderStepped:Connect(function()
    local val = (math.sin(tick() * 2.5) + 1) / 2
    MainStroke.Color = Color3.new((200 + val * 55) / 255, (40 + val * 45) / 255, (40 + val * 30) / 255)
end))

-- ═══════ TIÊU ĐỀ ═══════
local HeaderBar = New("Frame", {
    Size = UDim2.new(1, -20, 0, 26), Position = UDim2.new(0, 10, 0, 10),
    BackgroundTransparency = 1, ZIndex = 31, Parent = MainFrame,
})
local MiniLogo = New("Frame", {
    Size = UDim2.new(0, 22, 0, 22), Position = UDim2.new(0, 0, 0.5, -11),
    BackgroundColor3 = Color3.fromRGB(36, 12, 16), ZIndex = 32, Parent = HeaderBar,
})
Circle(MiniLogo)
Stroke(MiniLogo, Color3.fromRGB(239, 68, 68))
Label({ Size = UDim2.new(1, 0, 1, 0), Text = "🌶️", TextSize = 11, TextXAlignment = CENTER, ZIndex = 33, Parent = MiniLogo })
Label({
    Size = UDim2.new(1, -60, 1, 0), Position = UDim2.new(0, 28, 0, 0), Text = "CHILLI x VENYX LOADER V6",
    TextColor3 = Color3.fromRGB(254, 226, 226), TextSize = 11, Font = Enum.Font.GothamBold,
    TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 32, Parent = HeaderBar,
})
local CloseBtn = New("TextButton", {
    Size = UDim2.new(0, 22, 0, 22), Position = UDim2.new(1, -22, 0.5, -11),
    BackgroundColor3 = Color3.fromRGB(34, 12, 16), Text = "✕", TextColor3 = Color3.fromRGB(252, 165, 165),
    TextSize = 10, Font = Enum.Font.GothamBold, AutoButtonColor = false, ZIndex = 32, Parent = HeaderBar,
})
Round(CloseBtn, 6)

-- ═══════ KHU GIỚI THIỆU ═══════
local HeroSection = New("Frame", {
    Size = UDim2.new(1, -28, 0, 78), Position = UDim2.new(0, 14, 0, 44),
    BackgroundColor3 = Color3.fromRGB(28, 10, 14), ZIndex = 31, Parent = MainFrame,
})
Round(HeroSection, 12)
Stroke(HeroSection, Color3.fromRGB(80, 30, 36))

local CenterLogoBox = New("Frame", {
    Size = UDim2.new(0, 54, 0, 54), Position = UDim2.new(0, 12, 0.5, -27),
    BackgroundColor3 = Color3.fromRGB(32, 10, 14), ZIndex = 32, Parent = HeroSection,
})
Round(CenterLogoBox, 14)
Stroke(CenterLogoBox, Color3.fromRGB(239, 68, 68), 1.3)
Label({ Size = UDim2.new(1, 0, 1, 0), Text = "🌶️", TextSize = 26, TextXAlignment = CENTER, ZIndex = 33, Parent = CenterLogoBox })
Label({
    Size = UDim2.new(1, -80, 0, 20), Position = UDim2.new(0, 74, 0, 18), Text = "CHILLI x VENYX VIỆT HÓA V6",
    TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 12.5, Font = Enum.Font.GothamBlack,
    TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 32, Parent = HeroSection,
})
Label({
    Size = UDim2.new(1, -80, 0, 16), Position = UDim2.new(0, 74, 0, 40), Text = "Halloween · Quái Vật · Câu Cá · Tàu Ma",
    TextColor3 = Color3.fromRGB(251, 146, 60), TextSize = 10,
    TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 32, Parent = HeroSection,
})

-- ═══════ CẬP NHẬT V6 ═══════
Label({
    Size = UDim2.new(1, -28, 0, 14), Position = UDim2.new(0, 14, 0, 128), Text = "🆕 CẬP NHẬT V6",
    TextColor3 = Color3.fromRGB(251, 146, 60), TextSize = 10, Font = Enum.Font.GothamBold,
    ZIndex = 32, Parent = MainFrame,
})
local UpdateRow = New("Frame", {
    Size = UDim2.new(1, -28, 0, UPDATE_H), Position = UDim2.new(0, 14, 0, UPDATE_Y),
    BackgroundTransparency = 1, ZIndex = 31, Parent = MainFrame,
})
New("UIGridLayout", {
    CellSize = UDim2.new(0, 145, 0, 36), CellPadding = UDim2.new(0, 8, 0, 6),
    SortOrder = Enum.SortOrder.LayoutOrder, HorizontalAlignment = Enum.HorizontalAlignment.Center,
    Parent = UpdateRow,
})
for i, upd in ipairs(UPDATES_V6) do
    local badge = New("Frame", {
        BackgroundColor3 = Color3.fromRGB(36, 14, 18), LayoutOrder = i, ZIndex = 33, Parent = UpdateRow,
    })
    Round(badge, 9)
    Stroke(badge, upd.Color, 1.2)
    Label({
        Size = UDim2.new(0, 26, 0, 26), Position = UDim2.new(0, 5, 0.5, -13), Text = upd.Icon,
        TextSize = 16, TextXAlignment = CENTER, ZIndex = 34, Parent = badge,
    })
    Label({
        Size = UDim2.new(1, -36, 1, -4), Position = UDim2.new(0, 33, 0, 2), Text = upd.Title,
        TextColor3 = upd.Color, TextSize = 9.5, Font = Enum.Font.GothamBold,
        TextWrapped = true, TextYAlignment = Enum.TextYAlignment.Center, ZIndex = 34, Parent = badge,
    })
end

-- ═══════ THẺ TÁC GIẢ ═══════
local AuthorCard = New("Frame", {
    Size = UDim2.new(1, -28, 0, 40), Position = UDim2.new(0, 14, 0, authorY),
    BackgroundColor3 = Color3.fromRGB(28, 10, 14), ZIndex = 31, Parent = MainFrame,
})
Round(AuthorCard, 10)
Stroke(AuthorCard, Color3.fromRGB(80, 30, 36))

local AvatarCircle = New("Frame", {
    Size = UDim2.new(0, 28, 0, 28), Position = UDim2.new(0, 6, 0.5, -14),
    BackgroundColor3 = Color3.fromRGB(50, 15, 20), ZIndex = 32, Parent = AuthorCard,
})
Circle(AvatarCircle)
Stroke(AvatarCircle, Color3.fromRGB(239, 68, 68))

local AvatarImage = New("ImageLabel", {
    Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, ScaleType = Enum.ScaleType.Crop,
    Visible = false, ZIndex = 33, Parent = AvatarCircle,
})
Circle(AvatarImage)
local FallbackIcon = Label({
    Size = UDim2.new(1, 0, 1, 0), Text = "👤", TextSize = 13, TextXAlignment = CENTER,
    TextColor3 = Color3.fromRGB(254, 202, 202), ZIndex = 34, Parent = AvatarCircle,
})

-- Tải logo: ưu tiên asset ID, nếu không thì tải từ URL bằng writefile + getcustomasset
task.spawn(function()
    local function useImage(image)
        AvatarImage.Image = image
        AvatarImage.Visible = true
        FallbackIcon.Visible = false
    end
    if CONFIG.LogoImageId ~= "" then
        useImage(CONFIG.LogoImageId)
        return
    end
    local req = GetRequestFunction()
    if CONFIG.LogoURL ~= "" and req and writefile and getcustomasset then
        pcall(function()
            local res = req({ Url = CONFIG.LogoURL, Method = "GET" })
            if res and res.Body and res.Body:sub(2, 4) == "PNG" then
                writefile("kai_logo.png", res.Body)
                useImage(getcustomasset("kai_logo.png"))
            end
        end)
    end
end)

Label({
    Size = UDim2.new(1, -50, 0, 12), Position = UDim2.new(0, 40, 0, 5), Text = "ĐƯỢC SHARE BỞI",
    TextColor3 = Color3.fromRGB(251, 146, 60), TextSize = 7.5, Font = Enum.Font.GothamBold,
    ZIndex = 32, Parent = AuthorCard,
})
Label({
    Size = UDim2.new(1, -50, 0, 15), Position = UDim2.new(0, 40, 0, 18), Text = CONFIG.AuthorName,
    TextColor3 = Color3.fromRGB(255, 230, 230), TextSize = 11, Font = Enum.Font.GothamBlack,
    ZIndex = 32, Parent = AuthorCard,
})

-- ═══════ THẺ LIÊN KẾT (Discord / YouTube) ═══════
local function MakeLinkCard(o)
    local card = New("TextButton", {
        Size = UDim2.new(1, -28, 0, 40), Position = UDim2.new(0, 14, 0, o.y),
        BackgroundColor3 = o.bg, AutoButtonColor = false, Text = "", ZIndex = 31, Parent = MainFrame,
    })
    Round(card, 10)
    Stroke(card, o.stroke, 1.1)
    local iconBox = New("Frame", {
        Size = UDim2.new(0, 28, 0, 28), Position = UDim2.new(0, 6, 0.5, -14),
        BackgroundColor3 = o.iconBg, ZIndex = 32, Parent = card,
    })
    Circle(iconBox)
    Label({
        Size = UDim2.new(1, 0, 1, 0), Text = o.icon, TextSize = o.iconSize, TextXAlignment = CENTER,
        TextColor3 = Color3.fromRGB(255, 255, 255), ZIndex = 33, Parent = iconBox,
    })
    Label({
        Size = UDim2.new(1, -96, 0, 12), Position = UDim2.new(0, 40, 0, 5), Text = o.label,
        TextColor3 = o.labelColor, TextSize = 7.5, Font = Enum.Font.GothamBold, ZIndex = 32, Parent = card,
    })
    Label({
        Size = UDim2.new(1, -96, 0, 15), Position = UDim2.new(0, 40, 0, 18), Text = o.text,
        TextColor3 = o.textColor, TextSize = 10, Font = Enum.Font.GothamBold,
        TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 32, Parent = card,
    })
    local copyLbl = Label({
        Size = UDim2.new(0, 50, 0, 15), Position = UDim2.new(1, -54, 0.5, -7), Text = "📋 SAO CHÉP",
        TextColor3 = o.labelColor, TextSize = 7.5, Font = Enum.Font.GothamBold,
        TextXAlignment = CENTER, ZIndex = 32, Parent = card,
    })
    return card, copyLbl
end

local DiscordCard, DiscordCopy = MakeLinkCard({
    y = discordY, bg = Color3.fromRGB(30, 20, 42), stroke = Color3.fromRGB(88, 101, 242),
    iconBg = Color3.fromRGB(88, 101, 242), icon = "💬", iconSize = 14,
    label = "MÁY CHỦ DISCORD", labelColor = Color3.fromRGB(165, 180, 252),
    text = CONFIG.DiscordLabel, textColor = Color3.fromRGB(230, 235, 255),
})

local YouTubeCard, YouTubeCopy
if hasYT then
    YouTubeCard, YouTubeCopy = MakeLinkCard({
        y = youtubeY, bg = Color3.fromRGB(42, 15, 18), stroke = Color3.fromRGB(220, 38, 38),
        iconBg = Color3.fromRGB(220, 38, 38), icon = "▶", iconSize = 13,
        label = "KÊNH YOUTUBE", labelColor = Color3.fromRGB(252, 165, 165),
        text = CONFIG.YouTubeLabel, textColor = Color3.fromRGB(255, 230, 230),
    })
end

-- ═══════ NÚT MỞ SCRIPT ═══════
local OpenBtn = New("TextButton", {
    Size = UDim2.new(1, -28, 0, 50), Position = UDim2.new(0, 14, 0, buttonY),
    BackgroundColor3 = Color3.fromRGB(220, 38, 38), Text = "🚀 MỞ SCRIPT CHÍNH V6",
    TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 14, Font = Enum.Font.GothamBlack,
    AutoButtonColor = false, ZIndex = 32, Parent = MainFrame,
})
Round(OpenBtn, 12)
local OpenStroke = Stroke(OpenBtn, Color3.fromRGB(249, 115, 22), 1.5)

local BTN_STATES = {
    idle    = { text = "🚀 MỞ SCRIPT CHÍNH V6",        bg = Color3.fromRGB(220, 38, 38), stroke = Color3.fromRGB(249, 115, 22) },
    loading = { text = "⏳ ĐANG TẢI SCRIPT V6...",       bg = Color3.fromRGB(180, 100, 30), stroke = Color3.fromRGB(251, 191, 36) },
    success = { text = "✔ ĐÃ MỞ CHILLI x VENYX V6",     bg = Color3.fromRGB(22, 101, 52), stroke = Color3.fromRGB(74, 222, 128) },
    failed  = { text = "✖ LỖI — XEM CHI TIẾT BÊN DƯỚI", bg = Color3.fromRGB(120, 20, 30), stroke = Color3.fromRGB(239, 68, 68) },
}
local function SetButtonState(name)
    local s = BTN_STATES[name]
    OpenBtn.Text, OpenBtn.BackgroundColor3, OpenStroke.Color = s.text, s.bg, s.stroke
end

-- ═══════ KHUNG BÁO LỖI ═══════
local ErrBox = New("TextButton", {
    Name = "ErrorBox", Size = UDim2.new(1, -28, 0, ERR_H), Position = UDim2.new(0, 14, 0, belowY),
    BackgroundColor3 = Color3.fromRGB(46, 12, 16), AutoButtonColor = false, Text = "",
    Visible = false, ZIndex = 31, Parent = MainFrame,
})
Round(ErrBox, 10)
Stroke(ErrBox, Color3.fromRGB(239, 68, 68), 1.2)
local ErrTitle = Label({
    Size = UDim2.new(1, -16, 0, 14), Position = UDim2.new(0, 8, 0, 5), Text = "",
    TextColor3 = Color3.fromRGB(252, 165, 165), TextSize = 10, Font = Enum.Font.GothamBold,
    TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 32, Parent = ErrBox,
})
local ErrHint = Label({
    Size = UDim2.new(1, -16, 0, 34), Position = UDim2.new(0, 8, 0, 20), Text = "",
    TextColor3 = Color3.fromRGB(254, 226, 226), TextSize = 8.5, TextWrapped = true,
    TextYAlignment = Enum.TextYAlignment.Top, ZIndex = 32, Parent = ErrBox,
})
local ErrMeta = Label({
    Size = UDim2.new(1, -16, 0, 12), Position = UDim2.new(0, 8, 0, 55), Text = "",
    TextColor3 = Color3.fromRGB(190, 120, 125), TextSize = 7.5,
    TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 32, Parent = ErrBox,
})

-- ═══════ CHÂN TRANG ═══════
local FooterInfo = Label({
    Size = UDim2.new(1, -28, 0, 14), Position = UDim2.new(0, 14, 0, belowY),
    Text = "bởi " .. CONFIG.AuthorName .. " · " .. CONFIG.Version .. " · Executor: " .. EXECUTOR,
    TextColor3 = Color3.fromRGB(120, 80, 85), TextSize = 8, TextTruncate = Enum.TextTruncate.AtEnd,
    ZIndex = 32, Parent = MainFrame,
})

local lastReport = ""
local function ResizeFor(showError)
    local h = showError and ERROR_H or NORMAL_H
    local footerY = showError and (belowY + ERR_H + 8) or belowY
    local info = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    TweenService:Create(MainFrame, info, { Size = UDim2.new(0, BASE_W, 0, h) }):Play()
    TweenService:Create(FooterInfo, info, { Position = UDim2.new(0, 14, 0, footerY) }):Play()
end

local function ShowError(e)
    ErrTitle.Text = "✖ " .. e.title
    ErrHint.Text = e.hint
    ErrMeta.Text = "Bước: " .. (STAGE_NAME[e.stage] or e.stage) .. " · Executor: " .. EXECUTOR .. " · chạm để sao chép"
    lastReport = BuildReport(e)
    ErrBox.Visible = true
    ResizeFor(true)
end

local function HideError()
    if not ErrBox.Visible then return end
    ErrBox.Visible = false
    ResizeFor(false)
end

-- ═══════ THÔNG BÁO NỔI ═══════
local function ShowToast(text, color)
    local old = ToastGui:FindFirstChild("Toast")
    if old then old:Destroy() end
    local Toast = New("Frame", {
        Name = "Toast", AnchorPoint = Vector2.new(0.5, 0), Size = UDim2.new(0, 280, 0, 36),
        Position = UDim2.new(0.5, 0, 0, -60), BackgroundColor3 = Color3.fromRGB(24, 12, 16),
        ZIndex = 100, Parent = ToastGui,
    })
    Round(Toast, 9)
    Stroke(Toast, color or Color3.fromRGB(74, 222, 128), 1.3)
    Label({
        Size = UDim2.new(1, -16, 1, 0), Position = UDim2.new(0, 8, 0, 0), Text = text,
        TextColor3 = Color3.fromRGB(240, 240, 240), TextSize = 10, Font = Enum.Font.GothamBold,
        TextXAlignment = CENTER, TextWrapped = true, ZIndex = 101, Parent = Toast,
    })
    TweenService:Create(Toast, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        { Position = UDim2.new(0.5, 0, 0, 20) }):Play()

    task.delay(2.2, function()
        if Toast and Toast.Parent then
            local t = TweenService:Create(Toast, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
                { Position = UDim2.new(0.5, 0, 0, -60) })
            t.Completed:Connect(function() Toast:Destroy() end)
            t:Play()
        end
    end)
end

-- ═══════ HIỆU ỨNG NHẤN (dùng UIScale, không bị lệch vị trí khi bấm nhanh) ═══════
local function Bounce(btn)
    local s = btn:FindFirstChild("BounceScale") or New("UIScale", { Name = "BounceScale", Parent = btn })
    s.Scale = 1
    local down = TweenService:Create(s, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Scale = 0.95 })
    down.Completed:Connect(function()
        TweenService:Create(s, TweenInfo.new(0.16, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 }):Play()
    end)
    down:Play()
end

-- ═══════ MỞ / ĐÓNG MENU ═══════
local targetScale = GetResponsiveScale()
MainFrame.BackgroundTransparency = 1
MainScale.Scale = targetScale * 0.4
TweenService:Create(MainFrame, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    { BackgroundTransparency = 0 }):Play()
TweenService:Create(MainScale, TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    { Scale = targetScale }):Play()

local camera = workspace.CurrentCamera
if camera then
    Track(camera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
        local newScale = GetResponsiveScale()
        if math.abs(newScale - targetScale) > 0.02 then
            targetScale = newScale
            TweenService:Create(MainScale, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                { Scale = newScale }):Play()
        end
    end))
end

local cleaned, closing = false, false
local function Cleanup()
    if cleaned then return end
    cleaned = true
    for _, c in ipairs(connections) do pcall(function() c:Disconnect() end) end
    if ScreenGui then ScreenGui:Destroy() end
    -- Giữ thông báo nổi thêm vài giây để người chơi kịp đọc
    task.delay(3, function() if ToastGui then ToastGui:Destroy() end end)
end

local function CloseMenu()
    if closing then return end
    closing = true
    local tw = TweenService:Create(MainScale, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
        { Scale = targetScale * 0.4 })
    tw.Completed:Connect(Cleanup)
    tw:Play()
    task.delay(0.6, Cleanup) -- dự phòng
end

CloseBtn.MouseButton1Click:Connect(function()
    Bounce(CloseBtn)
    CloseMenu()
end)

-- ═══════ SAO CHÉP LINK ═══════
local function BindCopy(card, copyLbl, link, name, color)
    card.MouseButton1Click:Connect(function()
        Bounce(card)
        if copyToClipboard(link) then
            ShowToast("✔ Đã sao chép link " .. name .. "!", color)
            copyLbl.Text = "✔ XONG"
            task.delay(2, function()
                if copyLbl and copyLbl.Parent then copyLbl.Text = "📋 SAO CHÉP" end
            end)
        else
            ShowToast("✖ Executor không hỗ trợ sao chép (thiếu setclipboard)", Color3.fromRGB(239, 68, 68))
        end
    end)
end

BindCopy(DiscordCard, DiscordCopy, CONFIG.DiscordLink, "Discord", Color3.fromRGB(88, 101, 242))
if hasYT then
    BindCopy(YouTubeCard, YouTubeCopy, CONFIG.YouTubeLink, "YouTube", Color3.fromRGB(220, 38, 38))
end

-- Chạm vào khung lỗi để sao chép báo cáo
ErrBox.MouseButton1Click:Connect(function()
    Bounce(ErrBox)
    if copyToClipboard(lastReport) then
        ShowToast("✔ Đã sao chép chi tiết lỗi!", Color3.fromRGB(74, 222, 128))
    else
        ShowToast("✖ Không sao chép được. Chi tiết đã in ở Console (F9)", Color3.fromRGB(239, 68, 68))
        warn(lastReport)
    end
end)

-- ═══════ BẤM MỞ SCRIPT CHÍNH ═══════
local isLoading = false

OpenBtn.MouseButton1Click:Connect(function()
    if isLoading then return end
    isLoading = true

    Bounce(OpenBtn)
    HideError()
    SetButtonState("loading")
    ShowToast("⏳ Đang tải Chilli x Venyx V6...", Color3.fromRGB(251, 191, 36))

    task.spawn(function()
        local ok, result, e = pcall(LoadMainScript)
        -- LoadMainScript trả (true) hoặc (false, err); pcall bọc thêm một lớp
        local success, errInfo
        if not ok then
            success, errInfo = false, ClassifyRuntime(result)
        else
            success, errInfo = result, e
        end

        if success then
            SetButtonState("success")
            ShowToast("✔ Đã tải xong! Hãy chọn menu Chilli hoặc Venyx", Color3.fromRGB(74, 222, 128))
            task.wait(CONFIG.AutoHideDelay)
            CloseMenu()
        else
            SetButtonState("failed")
            ShowError(errInfo)
            ShowToast("✖ " .. errInfo.title, Color3.fromRGB(239, 68, 68))
            warn("[KaiLoader V6.0] " .. BuildReport(errInfo))

            task.delay(2.5, function()
                if OpenBtn and OpenBtn.Parent then
                    SetButtonState("idle")
                    isLoading = false
                end
            end)
        end
    end)
end)

-- ═══════ NHẬT KÝ ═══════
print("[KaiRoblox Menu " .. CONFIG.Version .. "] ✅ Đã tải xong")
print("  → Executor: " .. EXECUTOR .. " | Tỉ lệ: " .. string.format("%.2f", targetScale) .. " | Di động: " .. tostring(IsMobile()))
print("  → loadstring: " .. tostring(type(loadstring) == "function")
    .. " | HttpGet: " .. tostring(HasGameHttpGet())
    .. " | request: " .. tostring(GetRequestFunction() ~= nil)
    .. " | clipboard: " .. tostring(GetClipboardFunction() ~= nil))
