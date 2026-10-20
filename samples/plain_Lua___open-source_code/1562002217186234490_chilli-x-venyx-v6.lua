-- ==============================================================================
--  CHILLI HUB V6 - DYNAMIC ISLAND & MASTER 100% TRANSLATION
-- ==============================================================================

-- Chống chạy chồng: mỗi lần chạy script có một "thế hệ" riêng; bản cũ tự dừng mọi vòng lặp khi có bản mới
local GENV = (getgenv and getgenv()) or _G
GENV.__ChilliVenyxGen = (GENV.__ChilliVenyxGen or 0) + 1
local MY_GEN = GENV.__ChilliVenyxGen
local function alive() return GENV.__ChilliVenyxGen == MY_GEN end

local VERSION = "V6"
-- HUB_NAME: tên ở HEADER ĐỎ (menu Chilli) và ISLAND.
-- VENYX_TITLE: tên thay cho chữ "VENYX" ở tiêu đề cửa sổ Venyx khi chạy menu Venyx.
local HUB_NAME = "Chilli × Venyx"
local VENYX_TITLE = "Venyx × Chilli"
local BRAND = HUB_NAME
-- Ở mọi chỗ khác (hộp thoại, nút trong Venyx...) giữ tên thường: Chilli Hub / Venyx
local TEXT_BRAND = "Chilli Hub " .. VERSION
-- Phân biệt HEADER của cửa sổ chính với widget nhỏ có chữ "Chilli Hub" (vd thẻ "Chống Vệ Sĩ").
-- Header chính chỉ chứa tiêu đề (+ nút đóng X); widget còn có thêm nhãn chữ khác (tên chức năng...).
local CLOSE_TEXTS = {["x"] = true, ["✕"] = true, ["×"] = true, ["✖"] = true, ["✗"] = true}
local function headerState(frame, titleObj)
    if not frame then return "main" end
    for _, d in ipairs(frame:GetDescendants()) do
        if d ~= titleObj and (d:IsA("TextLabel") or d:IsA("TextButton"))
            and not d:FindFirstAncestor("Sparkling_New_Badge") and d.Name ~= "Sparkling_New_Badge" then
            local t = (d.Text or ""):match("^%s*(.-)%s*$") or ""
            if t ~= "" and not CLOSE_TEXTS[t:lower()] then return "widget" end
        end
    end
    return "main"
end

-- Nhận diện nhãn tiêu đề hub: tên gốc "Chilli Hub" của hub hoặc tên mới sau khi đã đổi
local function looksLikeHubTitle(text)
    local low = tostring(text or ""):lower()
    return low:find("chilli hub", 1, true) ~= nil or low:find(HUB_NAME:lower(), 1, true) ~= nil
end

-- ==================== 0. DỌN DẸP SẠCH TÀN DƯ GUI CŨ ====================
local cleanupList = {
    "Chilli_Dynamic_Island",
    "Chilli_AutoConfig_Btn",
    "Chilli_AutoFarm_Widget",
    "Chilli_Liquid_Capsule",
    "Sparkling_New_Badge"
}

local cleanupRoots = {}
pcall(function() if gethui then table.insert(cleanupRoots, gethui()) end end)
table.insert(cleanupRoots, game:GetService("CoreGui"))
do
    local pg = game:GetService("Players").LocalPlayer
    pg = pg and pg:FindFirstChild("PlayerGui")
    if pg then table.insert(cleanupRoots, pg) end
end

for _, root in ipairs(cleanupRoots) do
    if root then
        for _, name in ipairs(cleanupList) do
            local f = root:FindFirstChild(name, true)
            local guard = 0
            while f and guard < 20 do
                guard = guard + 1
                pcall(function() f:Destroy() end)
                f = root:FindFirstChild(name, true)
            end
        end
    end
end

-- ==================== 1. CHỜ GAME & NHÂN VẬT LOAD XONG ====================
if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer or Players:GetPropertyChangedSignal("LocalPlayer"):Wait()

do
    local waited = 0
    while waited < 20 and not (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")) do
        task.wait(0.2)
        waited = waited + 0.2
    end
end

task.wait(2.5) -- Đệm chờ mọi thứ load ổn định

-- ==================== LOGO (nhúng sẵn, tự ghi ra file rồi nạp bằng getcustomasset) ====================
local LOGO_B64 = {
    chilli = [===[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]===],
    kai = [===[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]===],
    vx = [===[iVBORw0KGgoAAAANSUhEUgAAAHAAAABwBAMAAAA0zul4AAAAMFBMVEUFBQf6+voAAAAUFBaenp9dXV8bGxxaWlv39/empqY7O0o/P0BIJCRVAFVwcHKAf4GvBnhrAAAAEHRSTlP+/gGi/v5eHQQKE/8HA4P/t6W5dQAABDBJREFUeNqdmc/L3EQYxz+ZSd7WH8Xd0vfQ01v2UJS3QuDFgvq2pjcPBXP1ZEG9KRb8Mzwo+A+8vXpaUOilh2Ar9tDKFqxUQVyhyIoFVxF/vEl2PUyymSQzSWbnsOy82U+eH99nnsnk9SZU4+jGDPs4+PJYm/na9yuX6Rr3ufikmnkbi/7TM/qG3Nt8FS4c+c9tcAinkyV4eRAH+eM66B0xcBzv1sAfGTzu6eBqOEc+18C5A1hYEa4GgUUJBnM38L8SzNw48qgALzmCHBXgkSu4ikGAh/NYghyzWjqDD0YIGLlb9EHAzB08jhHbhAhLBO9vA85gcs7h9/FmGU9ElZv+wvOWWnaer/6828MF46prTYSoJlnUDR5WvTS/jtaQx+O409GxpvhEaB055KsucITmUSTyapLQ5awHU8sWIOFbe2aerf22ashqQedWk1chtYGEdpNBAqFeOjUwsZu8qi5bLEqsJhN11QJm2Ex6rZ5WAwmBh2YN6yE2wRGQxcYV3+wU8vTv2uz7k8D83xb42oJGpzgr2ndut4Rg1iiVlqtK4lZ6suqaBVTMQ1NqmrdrgFMMe4lfXbKCvsnXvCyODjAte1jL06wbVCp7Bi/CHjCpt8GNp62NoglKDdcz3cxNC1ShBE31m/K3QRVL1rpV2gsmTUFiY24aRQ74JwAWVaH/CsCjBndWmJasHlKASX6Dq6kmQRVi1g8W4cU9IRrAaV3JxCi/CfRrSgYY5TeBKsh1MVtjlN8EqiDzWqGmg8CpXgKRuZkYCqBRAn+YFqixAOp1HthCNLmqRFtruUkHgkmVldwWohGUVcnEFhXNYFY+kxYfphCNoApytvlIB4NJmdDAGqIZlGVC19YQzWBWJjS3hmgGlXNxkdTUAZwWGV0CRPFw0C8yOgOY3imC9Ee9YKqtYZ8X31FfTkW9IEtgzXPqJkm+CwSn5LQflEDOnypRPlkMh/VWZ1iPAKungNdfmIP8htXLi8d/e0uWPetxI8idpNA0IY9GDT1t4LSUP1QF9ABeHQT6tbqNADkdBKahfoMvgAsMAstWvr/RdTQQ9HXeg+YJwQqmOj5qb1ii6zgLv5UGDxq+hnZQ6qLKW+FAHZVrfvnccYHb5LXlJWSXr/vFLfyELKo//XC+49RXHPuunFFntjPohzL7ETkN14WnhwD8pR3DuKYdPG1S+mVsfqQdPJmE2xyudyaCrUCPLcF9BJ9uA4YIS6PuBeV4tbdwz813CMtm1D0kCPjcHXwTBFsEKc+pN0hvuL7R8eZqWd12tXgNkGPYeeLo6bJYyMfX3cCXyg7wzE038BUKV9PVW3cduBO/VD3HxaT8SGtW6YcOEX5C6SrwaLCWO7LeHr8euCzle2URlK+e/B8GcXuthpydH2BTfmDo5Nk/b/dxFz+uNldP/7fFuz/d78AOTn+mzf4HP+f7VeLvoG4AAAAASUVORK5CYII=]===],
}

local function b64decode(data)
    local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
    local idx = {}
    for i = 1, #chars do idx[chars:byte(i)] = i - 1 end
    local out, n = {}, 0
    local buf, bits = 0, 0
    for i = 1, #data do
        local v = idx[data:byte(i)]
        if v then
            buf = buf * 64 + v
            bits = bits + 6
            if bits >= 8 then
                bits = bits - 8
                local div = 2 ^ bits
                local byte = math.floor(buf / div)
                buf = buf - byte * div
                n = n + 1
                out[n] = string.char(byte)
            end
        end
    end
    return table.concat(out)
end

local LogoCache = {}
-- Trả về đường dẫn ảnh dùng cho ImageLabel, hoặc nil nếu executor không hỗ trợ (khi đó dùng emoji dự phòng)
local function getLogo(name)
    if LogoCache[name] ~= nil then return LogoCache[name] or nil end
    local ok, asset = pcall(function()
        local loader = getcustomasset or getsynasset
        if not (writefile and loader and LOGO_B64[name]) then return nil end
        local fname = "ChilliVenyx_logo_" .. name .. ".png"
        local bytes = b64decode(LOGO_B64[name])
        local same = false
        if isfile and readfile and isfile(fname) then
            local cur = readfile(fname)
            same = (#cur == #bytes)
        end
        if not same then writefile(fname, bytes) end
        return loader(fname)
    end)
    LogoCache[name] = (ok and asset) or false
    return LogoCache[name] or nil
end

-- ==================== 1b. TỰ CHẠY LẠI KHI VÀO GAME (AUTO-RUN) ====================
-- Ghi 1 file chỉ chứa đúng 1 dòng tải script (không chứa code) để executor / cloud tự chạy lại sau khi bị văng và vào lại game.
-- Nếu executor có thư mục autoexec sẵn thì ghi vào đó; không thì ghi file ở thư mục workspace. Tắt bằng AUTORUN_ENABLED = false.
local AUTORUN_ENABLED = true
local AUTORUN_URL  = "https://id.tomroblox.com/raw/kairoblox/chilli-x-venyx-v6"
local AUTORUN_FILE = "ChilliHubV6_AutoRun.lua"
if AUTORUN_ENABLED and writefile then
    pcall(function()
        local loader = 'pcall(function() loadstring(game:HttpGet("' .. AUTORUN_URL .. '"))() end)'
        local target = AUTORUN_FILE
        if isfolder then
            for _, folder in ipairs({"autoexec", "Autoexec", "AutoExec", "autoexecute", "Autoexecute"}) do
                if isfolder(folder) then target = folder .. "/" .. AUTORUN_FILE break end
            end
        end
        -- Không ghi lại nếu nội dung đã đúng (đỡ ghi đĩa mỗi lần chạy)
        local same = false
        if isfile and readfile and isfile(target) then same = (readfile(target) == loader) end
        if not same then writefile(target, loader) end
    end)
end

-- ==================== 2. CHỌN MENU & TẢI SCRIPT ====================
local CHILLI_URL = "https://raw.githubusercontent.com/tienkhanh1/spicy/main/Chilli.lua"
local VENYX_URL  = "https://raw.githubusercontent.com/tienkhanh1/Venyx/main/VenyxHub"
local CHOICE_FILE = "ChilliVenyx_Choice.txt"
local DIAG_LOG = true   -- ghi nhật ký RAM mỗi 60 giây vào ChilliVenyx_Diag.txt (đặt false để tắt)
local SELECTED_HUB = "chilli"   -- "chilli" hoặc "venyx"

do
    -- Lựa chọn lần trước (nếu executor hỗ trợ đọc/ghi file)
    local last, hasSaved = "chilli", false
    pcall(function()
        if isfile and readfile and isfile(CHOICE_FILE) then
            local v = readfile(CHOICE_FILE):match("%a+")
            if v == "venyx" or v == "chilli" then last, hasSaved = v, true end
        end
    end)

    -- Chạy lại script nhiều lần: xóa hộp chọn cũ nếu còn sót
    pcall(function()
        local roots = {}
        if gethui then table.insert(roots, gethui()) end
        table.insert(roots, game:GetService("CoreGui"))
        for _, root in ipairs(roots) do
            local old = root:FindFirstChild("Chilli_Hub_Picker")
            if old then old:Destroy() end
        end
    end)

    local chosen = nil
    local picker = Instance.new("ScreenGui")
    picker.Name = "Chilli_Hub_Picker"
    picker.ResetOnSpawn = false
    picker.IgnoreGuiInset = true
    picker.DisplayOrder = 999999
    local okParent = pcall(function()
        picker.Parent = (gethui and gethui()) or game:GetService("CoreGui")
    end)
    if not okParent or not picker.Parent then
        picker.Parent = LocalPlayer:WaitForChild("PlayerGui")
    end

    local card = Instance.new("Frame")
    card.AnchorPoint = Vector2.new(0.5, 0.5)
    card.Position = UDim2.new(0.5, 0, 0.5, 0)
    card.Size = UDim2.new(0, 300, 0, 236)
    card.BackgroundColor3 = Color3.fromRGB(26, 14, 14)
    card.BorderSizePixel = 0
    card.Parent = picker
    do
        local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 14); c.Parent = card
        local st = Instance.new("UIStroke"); st.Color = Color3.fromRGB(220, 70, 60); st.Thickness = 1.5; st.Parent = card
    end

    local title = Instance.new("TextLabel")
    title.BackgroundTransparency = 1
    title.Position = UDim2.new(0, 10, 0, 8)
    title.Size = UDim2.new(1, -20, 0, 22)
    title.Font = Enum.Font.GothamBlack
    title.TextSize = 14
    title.TextColor3 = Color3.fromRGB(255, 235, 225)
    title.Text = "Chilli × Venyx — Chọn menu"
    title.Parent = card

    local function makeBtn(y, text, sub, accent, logoName, emoji)
        local logo = getLogo(logoName)
        local b = Instance.new("TextButton")
        b.Position = UDim2.new(0, 12, 0, y)
        b.Size = UDim2.new(1, -24, 0, 56)
        b.BackgroundColor3 = accent
        b.BorderSizePixel = 0
        b.AutoButtonColor = true
        b.Font = Enum.Font.GothamBold
        b.TextSize = 13
        b.TextColor3 = Color3.fromRGB(255, 255, 255)
        b.RichText = true
        b.Text = (logo and "" or (emoji .. " ")) .. '<font size="14">' .. text .. '</font>\n<font size="11">' .. sub .. '</font>'
        b.Parent = card
        local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 10); c.Parent = b
        if logo then
            b.TextXAlignment = Enum.TextXAlignment.Left
            local pad = Instance.new("UIPadding"); pad.PaddingLeft = UDim.new(0, 52); pad.Parent = b
            local img = Instance.new("ImageLabel")
            img.BackgroundTransparency = 1
            img.Image = logo
            img.Size = UDim2.new(0, 38, 0, 38)
            img.Position = UDim2.new(0, -48, 0.5, -19)
            img.Parent = b
        end
        return b
    end
    local btnChilli = makeBtn(36, "Chilli Hub", "Đầy đủ chức năng\nHợp máy tầm trung - Mạnh", Color3.fromRGB(200, 60, 50), "chilli", "🌶️")
    local btnVenyx  = makeBtn(100, "Venyx", "Nhẹ, mượt\nFull chức năng, hợp máy yếu", Color3.fromRGB(60, 90, 190), "vx", "⚡")

    local note = Instance.new("TextLabel")
    note.BackgroundTransparency = 1
    note.Position = UDim2.new(0, 12, 0, 164)
    note.Size = UDim2.new(1, -24, 0, 40)
    note.Font = Enum.Font.GothamMedium
    note.TextSize = 10.5
    note.TextWrapped = true
    note.TextXAlignment = Enum.TextXAlignment.Left
    note.TextYAlignment = Enum.TextYAlignment.Top
    note.TextColor3 = Color3.fromRGB(255, 225, 205)
    note.Text = "✨ Cả 2 bản đều là bản cập nhật mới nhất và Việt hóa đầy đủ — anh em thích bản nào thì chọn bản đó."
    note.Parent = card

    local info = Instance.new("TextLabel")
    info.BackgroundTransparency = 1
    info.Position = UDim2.new(0, 12, 0, 202)
    info.Size = UDim2.new(1, -24, 0, 26)
    info.Font = Enum.Font.GothamMedium
    info.TextSize = 10.5
    info.TextWrapped = true
    info.TextXAlignment = Enum.TextXAlignment.Left
    info.TextYAlignment = Enum.TextYAlignment.Center
    info.TextColor3 = Color3.fromRGB(255, 200, 120)
    info.Parent = card

    btnChilli.MouseButton1Click:Connect(function() chosen = "chilli" end)
    btnVenyx.MouseButton1Click:Connect(function() chosen = "venyx" end)

    -- Tự vào lựa chọn lần trước sau 20 giây (để chạy tự động khi rejoin vẫn không bị kẹt)
    local deadline = os.clock() + 20
    while not chosen and os.clock() < deadline and picker.Parent do
        info.Text = string.format("⏳ Tự vào %s sau %d giây nếu bạn không chọn menu",
            last == "venyx" and "Venyx" or "Chilli",
            math.max(0, math.ceil(deadline - os.clock())))
        task.wait(0.25)
    end
    SELECTED_HUB = chosen or last
    pcall(function() if writefile then writefile(CHOICE_FILE, SELECTED_HUB) end end)
    pcall(function() picker:Destroy() end)
end

task.spawn(function()
    pcall(function()
        loadstring(game:HttpGet(SELECTED_HUB == "venyx" and VENYX_URL or CHILLI_URL))()
    end)
end)

local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

-- ==================== DỮ LIỆU CẤU HÌNH JSON ====================
local RAW_CONFIG_JSON = [===[{"Config":{"Profile":"main","Version":2,"States":{"Farm HUD Stealing Position":{"Value":[]},"Quick Panel Collapsed":{"Value":{"1":true}},"Quick Keybinds":{"Value":{"Player > Movement > Speed Boost":"Q"}},"Farm HUD World Position":{"Value":[]},"Farm HUD Stolen Eggs":{"Value":{"History":[{"At":1791707562,"Name":"Parrotfish Egg","Category":"Parrotfish","Scale":0.9196704573013789,"Rarity":"Rare","Value":659.493259982963}],"Count":1,"Best":{"Category":"Parrotfish","Name":"Parrotfish Egg","Rarity":"Rare","Rank":3}}},"Farm HUD Top Eggs Position":{"Value":[]},"Anti Guard Enabled":{"Value":false},"Farm HUD Steal History Position":{"Value":[]},"Quick Pinned Features":{"Value":["Player > Movement > Speed Boost","Player > Movement > Boost Speed"]},"Open On Launch":{"Value":true},"Quick Panel Position":{"Value":{"1":{"Y":0.32634490728378298,"X":0.8134856224060059}}},"Notifications":{"Value":true},"Farm HUD Top Pets Position":{"Value":[]},"Quick Open Key":{"Value":"LeftControl"},"FPS and Ping Position":{"Value":{"XOffset":16,"XScale":0,"YScale":0,"YOffset":47}},"Farm HUD Status Position":{"Value":[]},"Farm HUD Events Position":{"Value":[]},"Steal Panel Open":{"Value":false},"Quick LeftCenter Hidden":{"Value":true},"Farm HUD Economy Position":{"Value":[]},"Quick Pin Groups":{"Value":[]},"Farm HUD Collection Position":{"Value":[]}},"Values":{"Admin Abuse":{"Minigame Eggs":{"Auto Steal Minigame Egg":{"Value":true,"Type":"toggle"}},"Instant Steal V3":{"Instant Steal V3 Note":{"Value":"Cần Máy Tập Admin","Type":"text"},"Instant Steal V3":{"Value":false,"Type":"toggle"}},"Admin Treadmill":{"Auto Use Admin Treadmill":{"Value":true,"Type":"toggle"}},"Capture The Egg":{"Hold Height":{"Value":45,"Type":"slider","Unit":"studs"},"Auto Capture Event Egg":{"Value":false,"Type":"toggle"},"Keep Away Distance":{"Value":45,"Type":"slider","Unit":"studs"},"Take It From The Holder":{"Value":true,"Type":"toggle"}}},"Predictor":{"Egg Predictor":{"Sort By":{"Value":"Value","Type":"dropdown"},"Preview Card":{"Value":true,"Type":"toggle"}},"Discord Webhook":{"Webhook URL":{"Value":"","Type":"input"},"Notify Fused Eggs":{"Value":false,"Type":"toggle"},"Notify Stolen Eggs":{"Value":false,"Type":"toggle"},"Webhook Min Rarity":{"Value":"Any","Type":"dropdown"},"Webhook Eggs":{"Value":[],"Type":"multidropdown"},"Webhook Min Value":{"Value":0,"Type":"slider"},"Ping @everyone":{"Value":false,"Type":"toggle"}}},"Progress":{"Auto Progression":{"Auto Buy Trail":{"Value":true,"Type":"toggle"},"Auto Claim Index":{"Value":true,"Type":"toggle"},"Auto Upgrade Treadmill":{"Value":true,"Type":"toggle"},"Auto Claim":{"Value":true,"Type":"toggle"},"Auto Upgrade Base":{"Value":true,"Type":"toggle"}}},"Quick":{"Pin Pad":{"Pad Size":{"Value":150,"Type":"slider","Unit":"%"},"Enable Keybinds":{"Value":true,"Type":"toggle"},"Show Pin Pads":{"Value":true,"Type":"toggle"},"Visible Quick Bars":{"Value":["Quick Bar 1","Quick Bar 2","Quick Bar 3","Quick Bar 4","Quick Bar 5"],"Type":"multidropdown"}}},"Auto Hop":{"Egg Finder":{"Hop Mode":{"Value":"Steal Then Hop","Type":"dropdown"},"Min Rarity":{"Value":"Secret","Type":"dropdown"},"Rarity To Wait For":{"Value":"Cosmic","Type":"dropdown"},"First Hop Delay":{"Value":5,"Type":"slider","Unit":"s"},"Sync With Auto Steal Filters":{"Value":true,"Type":"toggle"},"Target Specific Eggs":{"Value":[],"Type":"multidropdown"},"Min Value To Find":{"Value":700.11,"Type":"slider"},"Auto Hop":{"Value":false,"Type":"toggle"},"Target Areas":{"Value":["Cherry Blossom","Light Dark","Titan Temple","Enchanted Forest"],"Type":"multidropdown"}}},"Player":{"ESP":{"ESP Eggs":{"Value":true,"Type":"toggle"},"ESP Show Info":{"Value":["Icon","Name","Value"],"Type":"multidropdown"},"ESP Guard Size":{"Value":75,"Type":"slider","Unit":"%"},"ESP Player Info":{"Value":["Name","Tool"],"Type":"multidropdown"},"ESP Other Base Eggs":{"Value":false,"Type":"toggle"},"ESP Min Rarity":{"Value":"7 - Cosmic","Type":"dropdown"},"ESP Guards":{"Value":true,"Type":"toggle"},"Min ESP Value":{"Value":0,"Type":"slider"},"ESP Player Size":{"Value":75,"Type":"slider","Unit":"%"},"ESP Players":{"Value":true,"Type":"toggle"},"ESP Own Base Eggs":{"Value":true,"Type":"toggle"},"ESP Fixed Size":{"Value":false,"Type":"toggle"},"ESP Egg Size":{"Value":75,"Type":"slider","Unit":"%"}},"Character":{"Instant Prompts":{"Value":true,"Type":"toggle"},"Anti Ragdoll":{"Value":true,"Type":"toggle"},"Anti Trap":{"Value":true,"Type":"toggle"},"Invisibility":{"Value":false,"Type":"toggle"}},"Movement":{"Speed Boost":{"Value":false,"Type":"toggle"},"Boost Speed":{"Value":1000,"Type":"slider","Unit":"studs/s"},"Infinite Jump":{"Value":false,"Type":"toggle"}},"Combat":{"Auto Hit Egg Holders":{"Value":false,"Type":"toggle"},"Hit Max Speed":{"Value":750,"Type":"slider","Unit":"studs/s"},"Auto Hit Nearest Player":{"Value":false,"Type":"toggle"},"Hit Player":{"Value":"67sixseven16690","Type":"dropdown"},"Hit Lead":{"Value":-275,"Type":"slider"},"Hit Tween Speed":{"Value":400,"Type":"slider","Unit":"studs/s"},"Hit Sweep":{"Value":60,"Type":"slider","Unit":"%"},"Chase Settings":{"Value":"Cài Đặt Đuổi Đánh","Type":"label"},"Auto Hit Specific Player":{"Value":false,"Type":"toggle"},"Hit Aura":{"Value":true,"Type":"toggle"},"Hit Status":{"Value":"Aura ready, nobody in reach","Type":"text"}}},"Settings":{"Interface":{"UI Size":{"Value":100,"Type":"slider","Unit":"%"}}},"Farm":{"Auto Steal":{"Drop Eggs At Safe Zone":{"Value":false,"Type":"toggle"},"Target Specific Eggs":{"Value":[],"Type":"multidropdown"},"Biohazard Lab Eggs":{"Value":["Red Panda Egg (43%)","Snowy Owl Egg (40%)","Salamander Egg (38%)"],"Type":"multidropdown"},"Anti Guard Panel":{"Value":true,"Type":"toggle"},"Steal Missing Lab Eggs":{"Value":false,"Type":"toggle"},"Instant Steal Steps":{"Value":2,"Type":"slider"},"Instant Steal Zones":{"Value":["Titan Temple","Light Dark","Enchanted Forest"],"Type":"multidropdown"},"Target Areas":{"Value":["Cherry Blossom","Light Dark","Titan Temple","Enchanted Forest"],"Type":"multidropdown"},"Unstable DNA Lab Eggs":{"Value":["Toro Egg (24%)","Winged Lamb Egg (23%)","Bladehide Egg (23%)","Imp Egg (22%)","Crustacia Egg (22%)"],"Type":"multidropdown"},"Stock Per Egg":{"Value":3,"Type":"slider","Unit":""},"Auto Steal":{"Value":true,"Type":"toggle"},"Min Rarity":{"Value":"Secret","Type":"dropdown"},"Teleport To Egg":{"Value":true,"Type":"toggle"},"Carry Speed":{"Value":120,"Type":"slider","Unit":"%"},"Experimental Lab Eggs":{"Value":["Bladehide Egg (34%)","Red Panda Egg (34%)","Crustacia Egg (33%)","Salamander Egg (33%)","Snowy Owl Egg (32%)"],"Type":"multidropdown"},"Fast Delivery":{"Value":true,"Type":"toggle"},"Skip Owned Lab Eggs":{"Value":true,"Type":"toggle"},"Steal Priority":{"Value":"Highest Value","Type":"dropdown"},"Instant Steal V2":{"Value":true,"Type":"toggle"},"Instant Steal":{"Value":false,"Type":"toggle"},"Steal Missing Index Eggs":{"Value":false,"Type":"toggle"},"Min Steal Value":{"Value":700.11,"Type":"slider"},"Tween Speed":{"Value":120,"Type":"slider","Unit":"%"},"Stock Lab Eggs For":{"Value":[],"Type":"multidropdown"}},"Auto Sell":{"Egg Sell Value":{"Value":0,"Type":"slider"},"Sell Egg Rule":{"Value":"Rarity Only","Type":"dropdown"},"Auto Sell Egg":{"Value":false,"Type":"toggle"},"Blacklist Sell Eggs":{"Value":[],"Type":"multidropdown"},"Keep Mutated Eggs":{"Value":true,"Type":"toggle"},"Egg Max Rarity":{"Value":"3 - Rare","Type":"dropdown"},"Blacklist Sell Pets":{"Value":[],"Type":"multidropdown"},"Egg Sell Preview":{"Value":"Egg matches  -  0 eggs for $0","Type":"text"},"Auto Sell Pet":{"Value":false,"Type":"toggle"},"Pet Sell Value":{"Value":777.78,"Type":"slider"},"Pet Sell Preview":{"Value":"Pet matches  -  0 pets for $0","Type":"text"},"Keep Mutated Pets":{"Value":false,"Type":"toggle"},"Sell Pet Rule":{"Value":"Rarity Only","Type":"dropdown"},"Pet Max Rarity":{"Value":"8 - Secret","Type":"dropdown"}},"Auto Fuse Machine":{"Max Rarity to Fuse":{"Value":"6 - Mythic","Type":"dropdown"},"Skip Mutated Pets":{"Value":true,"Type":"toggle"},"Auto Fuse Machine":{"Value":true,"Type":"toggle"},"Specific Species to Fuse":{"Value":[],"Type":"multidropdown"},"Eject Incomplete Slots":{"Value":true,"Type":"toggle"},"Pets To Use":{"Value":"Lowest To Highest","Type":"dropdown"},"Fuse Priority Mode":{"Value":"Lowest Rarity First","Type":"dropdown"},"Fuse Preview":{"Value":"Không đủ 3 pet trùng khớp","Type":"text"}},"Auto Favorite":{"Favorite Mutations":{"Value":[],"Type":"multidropdown"},"Favorite Preview":{"Value":"Favorite matches  -  5 pets, 0 to mark  |  23 favorited","Type":"text"},"Favorite Min Rarity":{"Value":"10 - Divine","Type":"dropdown"},"Auto Favorite Equipped":{"Value":true,"Type":"toggle"},"Auto Favorite Pet":{"Value":true,"Type":"toggle"},"Always Favorite Species":{"Value":[],"Type":"multidropdown"},"Min Favorite Value":{"Value":797.34,"Type":"slider"},"Auto Unfavorite Equipped":{"Value":true,"Type":"toggle"},"Favorite Rule":{"Value":"Match All","Type":"dropdown"}},"Auto Treadmill":{"Stay On Treadmill":{"Value":true,"Type":"toggle"},"Auto Treadmill":{"Value":true,"Type":"toggle"}},"Auto Place Egg":{"Place Egg Rule":{"Value":"Always","Type":"dropdown"},"Place Rarities":{"Value":[],"Type":"multidropdown"},"Pen Status":{"Value":"Eggs placed 5/30  -  19/19 pets equipped, 0 in bag","Type":"text"},"Auto Place Egg":{"Value":true,"Type":"toggle"},"Place Egg Order":{"Value":"Highest Value","Type":"dropdown"},"Min Place Value":{"Value":0,"Type":"slider"},"Place Specific Eggs":{"Value":[],"Type":"multidropdown"}},"Wisp Companion":{"Auto Banjo Cricket":{"Value":true,"Type":"toggle"},"Auto Wisp":{"Value":true,"Type":"toggle"},"Wisp Status":{"Value":"Banjo Cricket: Done, Cricket's Banjo is yours","Type":"text"}},"Butterfly Bloom":{"Auto Butterfly Bloom":{"Value":true,"Type":"toggle"},"Trade Up Tiers":{"Value":["Emerald To Sapphire","Sapphire To Amethyst","Amethyst To Radiant"],"Type":"multidropdown"},"Auto Craft Essence":{"Value":true,"Type":"toggle"},"Auto Trade Up":{"Value":true,"Type":"toggle"},"Catch Priority":{"Value":"Rarest","Type":"dropdown"},"Tween Speed  ":{"Value":600,"Type":"slider","Unit":"studs/s"},"Catch Mode":{"Value":"Chase","Type":"dropdown"},"Catch Butterflies":{"Value":["Radiant Butterfly","Amethyst Butterfly","Sapphire Butterfly","Emerald Butterfly"],"Type":"multidropdown"},"Smart Trade For Essence":{"Value":true,"Type":"toggle"}},"Racing Event":{"Race Speed":{"Value":400,"Type":"slider"},"Auto Race":{"Value":true,"Type":"toggle"},"Race Shop Items":{"Value":["Nitro Mutation"],"Type":"multidropdown"},"Auto Equip Racer":{"Value":true,"Type":"toggle"},"Auto Buy Race Shop":{"Value":true,"Type":"toggle"},"Auto Claim Race Rewards":{"Value":true,"Type":"toggle"},"Auto Use Power-Ups":{"Value":true,"Type":"toggle"},"Racer":{"Value":"Best Owned","Type":"dropdown"}},"Auto Mutation":{"Mutate Priority":{"Value":"Highest Value","Type":"dropdown"},"Mutations To Use":{"Value":["Fractured","Scrambled","Enchanted","Nitro"],"Type":"multidropdown"},"Mutate Target Eggs":{"Value":[],"Type":"multidropdown"},"Mutate Min Value":{"Value":797.34,"Type":"slider"},"Auto Mutate":{"Value":true,"Type":"toggle"},"Mutate Status":{"Value":"Waiting  |  No egg to mutate","Type":"text"},"Auto Buy Nitro":{"Value":true,"Type":"toggle"},"Mutate Min Rarity":{"Value":"Secret","Type":"dropdown"}},"Auto Sell Lab Egg":{"Lab Egg Sell Value":{"Value":700.11,"Type":"slider"},"Sell Lab Egg Rule":{"Value":"Rarity And Value","Type":"dropdown"},"Lab Egg Max Rarity":{"Value":"Off","Type":"dropdown"},"Auto Sell Lab Egg":{"Value":true,"Type":"toggle"},"Lab Egg Sell Preview":{"Value":"Lab egg matches  -  0 eggs for $0","Type":"text"},"Keep Lab Pets":{"Value":[],"Type":"multidropdown"},"Keep Mutated Lab Eggs":{"Value":true,"Type":"toggle"}},"Auto Hatch & Equip":{"Hatch Specific Eggs":{"Value":[],"Type":"multidropdown"},"Auto Hatch":{"Value":false,"Type":"toggle"},"Hatch Min Rarity":{"Value":"Any","Type":"dropdown"},"Min Hatch Value":{"Value":0,"Type":"slider"},"Auto Equip Best":{"Value":true,"Type":"toggle"}},"Dr Scramble Lab":{"Lab Banners":{"Value":[],"Type":"multidropdown"},"Lab Status":{"Value":"Unstable DNA  -  needs Flame Sprite, Salamander, Bladehide  -  pity 0/100  -  free rerolls 0  -  rotates in 19:58  -  Need a Flame Sprite egg","Type":"text"},"Auto Place Lab Reward Eggs":{"Value":true,"Type":"toggle"},"Auto Reroll Lab Recipe":{"Value":true,"Type":"toggle"},"Auto Lab Trade-In":{"Value":true,"Type":"toggle"}},"Shooting Star":{"Auto Catch Shooting Star":{"Value":true,"Type":"toggle"},"Shooting Star Status":{"Value":"Đang chờ sao băng rơi","Type":"text"}}},"Misc":{"Performance":{"Optimizer":{"Value":true,"Type":"toggle"},"Farm HUD":{"Value":false,"Type":"toggle"},"Background Color":{"Value":"White","Type":"dropdown"},"Egg Card Image":{"Value":"Egg Image","Type":"dropdown"},"Disable 3D Render":{"Value":false,"Type":"toggle"},"FPS and Ping":{"Value":true,"Type":"toggle"},"FPS Cap":{"Value":240,"Type":"slider","Unit":" FPS"},"HUD Size":{"Value":70,"Type":"slider","Unit":"%"},"Showcase Cards":{"Value":4,"Type":"slider"},"Hide Game UI":{"Value":true,"Type":"toggle"},"HUD Items":{"Value":["Money","Income","Speed","Treadmill","Eggs Stolen","Best Steal","Night Timer","Session Time","Activity","Racing Event","Race Wins","Shooting Star","Pets","Eggs","Top Pets","Top Eggs","Steal History"],"Type":"multidropdown"},"FPS and Ping Size":{"Value":100,"Type":"slider","Unit":"%"}},"Utility":{"Anti AFK":{"Value":true,"Type":"toggle"}}},"Server":{"Server":{"Server Hop Mode":{"Value":"Least Players","Type":"dropdown"},"Auto Load Script":{"Value":true,"Type":"toggle"},"Auto Rejoin When Disconnect":{"Value":true,"Type":"toggle"}}}},"SavedAt":1791729602},"Format":"ChilliLibraryConfig","ExportVersion":1,"Name":"main"}]===]

-- ==================== CẤU HÌNH TẮT (TỰ SINH TỪ CẤU HÌNH BẬT) ====================
local HttpService = game:GetService("HttpService")
local ON_PROFILE = "main"
local OFF_PROFILE = "AutoOff"

-- Tạo bản sao của cấu hình trên nhưng tắt các công tắc hành động thuộc nhóm
-- Farm / Admin Abuse / Progress / Auto Hop / Player > Combat / Movement / ESP.
-- Các mục khác (Anti AFK, Auto Rejoin, Optimizer, FPS...) và các công tắc bảo vệ
-- như "Keep Mutated Eggs", "Skip Mutated Pets", "Anti Guard Panel" được giữ nguyên.
local function buildOffConfig()
    local ok, data = pcall(function() return HttpService:JSONDecode(RAW_CONFIG_JSON) end)
    if not ok or type(data) ~= "table" or type(data.Config) ~= "table" or type(data.Config.Values) ~= "table" then
        return nil
    end

    data.Name = OFF_PROFILE
    data.Config.Profile = OFF_PROFILE

    -- Công tắc "hành động": tên bắt đầu bằng "Auto " / "ESP " hoặc nằm trong danh sách này
    local ACTION_EXACT = {
        ["Hit Aura"] = true, ["Instant Steal"] = true, ["Instant Steal V2"] = true,
        ["Instant Steal V3"] = true, ["Stay On Treadmill"] = true,
        ["Speed Boost"] = true, ["Infinite Jump"] = true
    }

    local function disableToggles(node)
        for key, v in pairs(node) do
            if type(v) == "table" then
                if v.Type == "toggle" then
                    if type(key) == "string" and (key:sub(1, 5) == "Auto " or key:sub(1, 4) == "ESP " or ACTION_EXACT[key]) then
                        v.Value = false
                    end
                else
                    disableToggles(v)
                end
            end
        end
    end

    local paths = {
        {"Farm"}, {"Admin Abuse"}, {"Progress"}, {"Auto Hop"},
        {"Player", "Combat"}, {"Player", "Movement"}, {"Player", "ESP"}
    }
    for _, path in ipairs(paths) do
        local node = data.Config.Values
        for _, key in ipairs(path) do
            node = type(node) == "table" and node[key] or nil
        end
        if type(node) == "table" then disableToggles(node) end
    end

    local okEnc, json = pcall(function() return HttpService:JSONEncode(data) end)
    return okEnc and json or nil
end

-- ==================== 3. TỪ ĐIỂN DỊCH THUẬT ====================
local currentLanguage = "VI"
local switchGlobalLanguage = nil
local updateIslandContentLanguage = nil

-- Thay thế chuỗi thường (plain), không dùng pattern nên an toàn với ký tự đặc biệt như "-" "%" "("
local function replaceAll(str, findStr, replaceStr)
    local startIdx, endIdx = str:find(findStr, 1, true)
    while startIdx do
        str = str:sub(1, startIdx - 1) .. replaceStr .. str:sub(endIdx + 1)
        startIdx, endIdx = str:find(findStr, startIdx + #replaceStr, true)
    end
    return str
end

local EXACT_MATCH_VI = {
    ["Hop"] = "Đổi Server",
    ["Join"] = "Vào Phòng",
    ["Copy"] = "Sao Chép",
    ["Rejoin"] = "Vào Lại",
    ["Add"] = "Thêm",
    ["Sell"] = "Bán",
    ["Favorite"] = "Khóa",
    ["Unfavorite"] = "Mở Khóa",
    ["RESET"] = "ĐẶT LẠI",
    ["All"] = "Tất cả",
    ["ALL"] = "TẤT CẢ",
    ["Any"] = "Tất cả",
    ["None"] = "Không có",
    ["Off"] = "Tắt",
    ["OFF"] = "TẮT",
    ["On"] = "Bật",
    ["ON"] = "BẬT",
    ["Idle"] = "Đang chờ",
    ["IDLE"] = "ĐANG CHỜ",
    ["Stand"] = "Đứng yên",
    ["Chase"] = "Đuổi theo",
    ["Circle"] = "Xoay vòng",
    ["Patrol"] = "Tuần tra",
    ["Rarest"] = "Hiếm nhất",
    ["Nearest"] = "Gần nhất",
    ["Always"] = "Luôn luôn",
    ["Value"] = "Giá trị",
    ["Cosmic"] = "Vũ Trụ (Cosmic)",
    ["Divine"] = "Thánh Thần (Divine)",
    ["Eternal"] = "Vĩnh Cửu (Eternal)",
    ["Mythic"] = "Thần Thoại (Mythic)",
    ["Legendary"] = "Huyền Thoại (Legendary)",
    ["Epic"] = "Sử Thi (Epic)",
    ["Rare"] = "Hiếm (Rare)",
    ["Uncommon"] = "Thường (Uncommon)",
    ["Common"] = "Phổ Thông (Common)",
    ["Secret"] = "Bí Ẩn (Secret)",
    ["Least Players"] = "Ít người chơi nhất",
    ["Steal Then Hop"] = "Cướp xong đổi server",
    ["Rarity Only"] = "Chỉ theo độ hiếm",
    ["Rarity And Value"] = "Độ hiếm & Giá trị",
    ["Value Only"] = "Chỉ theo giá trị",
    ["Lowest Rarity First"] = "Độ hiếm thấp trước",
    ["Lowest To Highest"] = "Từ thấp đến cao",
    ["Highest To Lowest"] = "Từ cao đến thấp",
    ["Match All"] = "Khớp tất cả",
    ["Match Any"] = "Khớp bất kỳ",
    ["Highest Value"] = "Giá trị cao nhất",
    ["Lowest Value"] = "Giá trị thấp nhất",
    ["3 - Rare"] = "3 - Hiếm (Rare)",
    ["6 - Mythic"] = "6 - Thần Thoại (Mythic)",
    ["8 - Secret"] = "8 - Bí Ẩn (Secret)",
    ["10 - Divine"] = "10 - Thánh Thần (Divine)",
    ["EGGS"] = "TRỨNG",
    ["READY"] = "SẴN SÀNG",
    ["GROWING"] = "ĐANG LỚN",
    ["IN BAG"] = "TRONG TÚI",
    ["TOTAL / S"] = "TỔNG / GIÂY",
    ["WAITING"] = "ĐANG CHỜ",
    ["INACTIVE"] = "KHÔNG HOẠT ĐỘNG",

    -- Từ ngắn/chung chung: chỉ khớp NGUYÊN CHUỖI để không làm hỏng chuỗi dài hơn
    -- Đột biến
    ["Fractured"] = "Rạn Nứt",
    ["Scrambled"] = "Hỗn Loạn",
    ["Enchanted"] = "Phù Phép",
    ["Nitro"] = "Nitro",
    ["FRACTURED"] = "RẠN NỨT",
    ["SCRAMBLED"] = "HỖN LOẠN",
    ["ENCHANTED"] = "PHÙ PHÉP",
    ["NITRO"] = "NITRO",
    -- Nhóm / tiêu đề con
    ["ESP"] = "Định Vị (ESP)",
    ["Combat"] = "Chiến Đấu",
    ["COMBAT"] = "CHIẾN ĐẤU",
    ["Movement"] = "Tốc Độ & Di Chuyển",
    ["MOVEMENT"] = "TỐC ĐỘ & DI CHUYỂN",
    ["Interface"] = "Giao Diện",
    ["INTERFACE"] = "GIAO DIỆN",
    ["Treadmill"] = "Máy Tập",
    ["TREADMILL"] = "MÁY TẬP CHẠY",
    ["Pets"] = "Thú Cưng (Pets)",
    ["PETS"] = "THÚ CƯNG (PETS)",
    ["MINIGAME EGGS"] = "TRỨNG MINIGAME",
    ["Name"] = "Tên",
    ["White"] = "Màu Trắng",
    -- HUD
    ["Session Time"] = "Thời gian",
    ["SESSION TIME"] = "THỜI GIAN",
    ["Best Steal"] = "Cướp tốt nhất",
    ["BEST STEAL"] = "CƯỚP TỐT NHẤT"
}

local MAP_VI = {
    ["Steal Panel"] = "Bảng Cướp Trứng",
    ["Sort: Highest Value"] = "Xếp: Giá Trị Cao Nhất",
    ["Eggs: All"] = "Trứng: Tất Cả",
    ["Held by You"] = "Bạn đang cầm",
    [": ON"] = ": BẬT",
    [": OFF"] = ": TẮT",
    -- MENU CHÍNH
    ["Farm"] = "Cày Cuốc",
    ["Player"] = "Người Chơi",
    ["Predictor"] = "Dự Đoán",
    ["Progress"] = "Tiến Trình",
    ["Server"] = "Máy Chủ",
    ["Misc"] = "Khác",
    ["Auto Hop"] = "Tự Đổi Máy Chủ",
    ["Admin Abuse"] = "Menu Admin (Abuse)",
    ["Discord"] = "Discord",
    ["Quick & Keys"] = "Phím Tắt & Key",
    ["Settings"] = "Cài Đặt",
    ["Config"] = "Cấu Hình",
    ["Filter features..."] = "Lọc tính năng...",
    ["Search"] = "Tìm kiếm",

    -- TIỆN ÍCH NGOÀI MÀN HÌNH
    ["Anti Guard"] = "Chống Vệ Sĩ",

    -- KHU VỰC (mới)
    ["Enchanted Forest"] = "Rừng Phù Phép",
    ["Light Dark"] = "Sáng Tối",
    ["Titan Temple"] = "Đền Titan",
    ["Cherry Blossom"] = "Hoa Anh Đào",

    -- TÍNH NĂNG (mới)
    ["Teleport To Egg"] = "Dịch chuyển tới trứng",
    ["Drop Eggs At Safe Zone"] = "Thả trứng ở vùng an toàn",
    ["Minigame Eggs"] = "Trứng Minigame",
    ["Auto Steal Minigame Egg"] = "Tự cướp trứng Minigame",
    ["Hide Game UI"] = "Ẩn giao diện gốc của Game",
    ["Background Color"] = "Màu nền màn hình",

    -- TIẾN TRÌNH (AUTO PROGRESSION)
    ["Auto Progression"] = "Tự Động Tiến Trình",
    ["Auto Buy Trail"] = "Tự Mua Vệt Sáng",
    ["Automatically buy available trails when affordable"] = "Tự động mua vệt sáng khi đủ tiền",
    ["Auto Upgrade Base"] = "Tự Nâng Cấp Căn Cứ",
    ["Automatically upgrade base when money is available"] = "Tự động nâng cấp căn cứ khi đủ tiền",
    ["Auto Upgrade Treadmill"] = "Tự Nâng Cấp Máy Tập",
    ["Automatically upgrade treadmill when money is available"] = "Tự động nâng cấp máy tập khi đủ tiền",
    ["Auto Claim Index"] = "Tự Nhận Thưởng Chỉ Mục",
    ["Claim index rewards as soon as they unlock"] = "Nhận thưởng chỉ mục ngay khi mở khóa",
    ["Auto Claim"] = "Tự Nhận Thưởng",
    ["Claim offline money & index rewards"] = "Nhận tiền offline & thưởng chỉ mục",

    -- MÁY CHỦ (SERVER)
    ["Auto Load Script"] = "Tự Động Nạp Script",
    ["Server Hop Mode"] = "Chế Độ Đổi Server",
    ["Server Hop"] = "Đổi Server",
    ["Job ID"] = "Mã Phòng (Job ID)",
    ["Paste a server Job ID..."] = "Dán mã Job ID máy chủ...",
    ["Join Job ID"] = "Vào Bằng Job ID",
    ["Copy Current Job ID"] = "Sao Chép Job ID Hiện Tại",
    ["Rejoin Server"] = "Vào Lại Máy Chủ",
    ["Auto Rejoin When Disconnect"] = "Tự Kết Nối Lại Khi Mất Mạng",

    -- HIỆU NĂNG & TIỆN ÍCH
    ["Performance"] = "Hiệu Năng",
    ["FPS Cap"] = "Giới Hạn FPS",
    ["Optimizer"] = "Tối Ưu Hóa (Giảm Lag)",
    ["Strip shadows, textures and effects for the highest FPS"] = "Xóa bóng, bề mặt và hiệu ứng để tối đa FPS",
    ["FPS and Ping Size"] = "Cỡ FPS & Ping",
    ["FPS and Ping"] = "Hiện FPS & Ping",
    ["Disable 3D Render"] = "Tắt Đồ Họa 3D",
    ["Farm HUD"] = "Bảng Cày Cuốc (Farm HUD)",
    ["Drag any panel to place it where you like"] = "Kéo bất kỳ bảng nào đến vị trí bạn muốn",
    ["Utility"] = "Tiện Ích",
    ["Anti AFK"] = "Chống Treo Máy (Anti AFK)",

    -- DÒ TÌM TRỨNG
    ["Egg Finder"] = "Dò Tìm Trứng",
    ["Joins new servers to find eggs that match the filters below"] = "Tự vào server mới để tìm trứng khớp bộ lọc dưới",
    ["Turn on Auto Hop to start hunting"] = "Bật Tự Đổi Máy Chủ để bắt đầu săn trứng",
    ["Hop Mode"] = "Chế Độ Đổi Server",
    ["When to move on to the next server"] = "Thời điểm chuyển sang máy chủ tiếp theo",
    ["Rarity To Wait For"] = "Độ Hiếm Cần Đợi",
    ["For After A Rare Spawns this rarity or higher"] = "Chờ sau khi xuất hiện trứng từ độ hiếm này trở lên",
    ["For After A Rare Spawns: this rarity or higher"] = "Chờ sau khi xuất hiện trứng từ độ hiếm này trở lên",
    ["Sync With Auto Steal Filters"] = "Đồng Bộ Bộ Lọc Cướp",
    ["Changing a filter here also changes it in Auto Steal, and back"] = "Thay đổi bộ lọc tại đây sẽ đồng bộ với Tự Động Cướp",
    ["First Hop Delay"] = "Độ Trễ Lần Đổi Server Đầu",
    ["Wait after the script loads before the first hop"] = "Chờ sau khi nạp script hoàn tất trước khi đổi server",
    ["Min Value To Find"] = "Giá Trị Min Cần Tìm",
    ["Skip eggs worth less than this. Drag or type 350k, 50m, 10b"] = "Bỏ qua trứng giá nhỏ hơn mức này. Kéo hoặc nhập 350k, 50m, 10b",
    ["Find eggs of the chosen rarity and every rarity above it"] = "Tìm trứng thuộc độ hiếm đã chọn và cao hơn",
    ["Target Specific Eggs"] = "Mục Tiêu Trứng Chỉ Định",
    ["Only look for these eggs (empty = all)"] = "Chỉ tìm các trứng này (trống = tất cả)",
    ["Target Areas"] = "Khu Vực Mục Tiêu",

    -- DISCORD WEBHOOK & PREDICTOR
    ["Discord Webhook"] = "Webhook Discord",
    ["Webhook URL"] = "Đường Dẫn Webhook",
    ["Ping @everyone"] = "Tag @everyone",
    ["Notify Stolen Eggs"] = "Báo Cáo Cướp Trứng",
    ["Post eggs you bring home that match the filter"] = "Gửi thông báo các trứng mang về khớp bộ lọc",
    ["Notify Fused Eggs"] = "Báo Cáo Trứng Dung Hợp",
    ["Post eggs from the Fuse Machine that match the filter"] = "Gửi thông báo các trứng từ Máy Dung Hợp khớp bộ lọc",
    ["Webhook Min Rarity"] = "Độ Hiếm Webhook Min",
    ["Only post eggs of this rarity and above"] = "Chỉ gửi trứng từ độ hiếm này trở lên",
    ["Webhook Min Value"] = "Giá Trị Webhook Min",
    ["Only post eggs worth at least this. Drag or type 350k, 50m, 10b"] = "Chỉ gửi trứng đạt giá trị tối thiểu mức này. Kéo hoặc nhập 350k, 50m, 10b",
    ["Egg Predictor"] = "Dự Đoán Trứng",
    ["Fuse Predictor"] = "Dự Đoán Dung Hợp",
    ["Sort By"] = "Sắp Xếp Theo",
    ["Preview Card"] = "Thẻ Xem Trước",
    ["Search eggs..."] = "Tìm kiếm trứng...",
    ["FLY TO EGG"] = "BAY ĐẾN TRỨNG",

    -- ADMIN
    ["Capture The Egg"] = "Cướp Trứng Sự Kiện",
    ["Turn on Capture The Egg below to join the event"] = "Bật Cướp Trứng Sự Kiện bên dưới để tham gia",
    ["Auto Capture Event Egg"] = "Tự Cướp Trứng Sự Kiện",
    ["Take It From The Holder"] = "Giật Trứng Từ Người Bê",
    ["Hold Height"] = "Độ Cao Bê Trứng",
    ["Keep Away Distance"] = "Khoảng Cách Giữ An Toàn",
    ["Admin Treadmill"] = "Máy Tập Admin",
    ["Waiting for the Admin Treadmill"] = "Đang chờ Máy Tập Admin",
    ["Auto Use Admin Treadmill"] = "Tự Dùng Máy Tập Admin",
    ["Instant Steal V3 Note"] = "Ghi Chú Cướp Siêu Tốc V3",
    ["Instant Steal V3"] = "Cướp Siêu Tốc V3",
    ["Instant Steal V2"] = "Cướp Siêu Tốc V2",
    ["Instant Steal"] = "Cướp Siêu Tốc",
    ["Needs Admin Treadmill"] = "Cần Máy Tập Admin",
    ["Toggle is off"] = "Đang tắt",

    -- DANH MỤC TAB CÀY CUỐC
    ["Shooting Star"] = "Sao Băng Rơi",
    ["Butterfly Bloom"] = "Sự Kiện Bắt Bướm",
    ["Wisp Companion"] = "Đồng Hành Wisp",
    ["Auto Steal"] = "Tự Động Cướp Trứng",
    ["Auto Mutation"] = "Tự Động Đột Biến",
    ["Auto Place Egg"] = "Tự Động Đặt Trứng",
    ["Auto Treadmill"] = "Tự Động Máy Tập",
    ["Auto Hatch & Equip"] = "Tự Ấp Trứng & Trang Bị",
    ["Auto Sell"] = "Tự Động Bán",
    ["Auto Sell Lab Egg"] = "Tự Động Bán Trứng Lab",
    ["Auto Sell Egg"] = "Tự Động Bán Trứng",
    ["Auto Sell Pet"] = "Tự Động Bán Pet",
    ["Auto Fuse Machine"] = "Máy Dung Hợp Pet",
    ["Auto Favorite"] = "Tự Động Khóa Pet",

    -- CHI TIẾT FARM
    ["Nitro Mutation"] = "Đột Biến Nitro",
    ["Best Owned"] = "Tốt Nhất Đang Có",
    ["Auto Catch Shooting Star"] = "Tự Động Bắt Sao Băng",
    ["Shooting Star Status"] = "Trạng Thái Sao Băng",
    ["Waiting for a shooting star"] = "Đang chờ sao băng rơi",
    ["Mutate Priority"] = "Ưu Tiên Đột Biến",
    ["Mutations To Use"] = "Loại Đột Biến Dùng",
    ["Mutate Target Eggs"] = "Mục Tiêu Trứng Đột Biến",
    ["Mutate Min Value"] = "Giá Trị Đột Biến Min",
    ["Auto Mutate"] = "Tự Động Đột Biến",
    ["Mutate Status"] = "Trạng Thái Đột Biến",
    ["Auto Buy Nitro"] = "Tự Mua Nitro",
    ["Mutate Min Rarity"] = "Độ Hiếm Đột Biến Min",
    ["Steal eggs of the chosen rarity and every rarity above it"] = "Cướp trứng thuộc độ hiếm đã chọn và cao hơn",
    ["Min Steal Value"] = "Giá Trị Cướp Min",
    ["Steal Missing Lab Eggs"] = "Cướp Trứng Lab Còn Thiếu",
    ["Steal Missing Index Eggs"] = "Cướp Trứng Sách Còn Thiếu",
    ["Also steal eggs missing from your index, highest area first"] = "Cướp trứng thiếu trong sách, ưu tiên khu cao nhất",
    ["Steal Priority"] = "Ưu Tiên Cướp",
    ["Tween Speed"] = "Tốc Độ Bay (Tween)",
    ["Over 100% may glitch"] = "Trên 100% có thể bị lỗi vị trí",
    ["Carry Speed"] = "Tốc Độ Bê Trứng",
    ["Anti Guard Panel"] = "Bảng Chống Vệ Sĩ",
    ["Delivers the egg to the safe zone in a few seconds, needs enough Speed"] = "Vận chuyển trứng về căn cứ trong vài giây (cần đủ tốc độ)",
    ["Instant Steal Steps"] = "Số Bước Cướp Siêu Tốc",
    ["Higher is safer but takes longer"] = "Càng nhiều bước càng an toàn nhưng bay chậm hơn",
    ["Place Egg Rule"] = "Quy Tắc Đặt Trứng",
    ["Place Egg Order"] = "Thứ Tự Đặt Trứng",
    ["Place Rarities"] = "Độ Hiếm Đặt Trứng",
    ["Only place eggs of the picked rarities (empty = all)"] = "Chỉ đặt trứng thuộc độ hiếm đã chọn (trống = tất cả)",
    ["Place Specific Eggs"] = "Chọn Đích Danh Trứng Đặt",
    ["Only place these eggs (empty = all)"] = "Chỉ đặt các loại trứng này (trống = tất cả)",
    ["Min Place Value"] = "Giá Trị Đặt Min",
    ["Skip eggs worth less than this (0 = off)"] = "Bỏ qua trứng giá nhỏ hơn mức này (0 = tắt)",
    ["Stay On Treadmill"] = "Luôn Ở Trên Máy Tập",
    ["Auto Hatch"] = "Tự Động Ấp Trứng",
    ["Hatch Min Rarity"] = "Độ Hiếm Ấp Min",
    ["Hatch eggs of the chosen rarity and every rarity above it"] = "Ấp trứng từ độ hiếm đã chọn trở lên",
    ["Min Hatch Value"] = "Giá Trị Ấp Min",
    ["Hatch Specific Eggs"] = "Chọn Đích Danh Trứng Ấp",
    ["Auto Equip Best"] = "Tự Trang Bị Pet Tốt Nhất",
    ["Equip Best when a better pet appears"] = "Tự trang bị khi xuất hiện pet mạnh hơn",
    ["Sell Pets Now"] = "Bán Pet Ngay",
    ["Sell matching pets once"] = "Bán một lần các pet khớp điều kiện",
    ["Sell Pet Rule"] = "Quy Tắc Bán Pet",
    ["Pet Max Rarity"] = "Độ Hiếm Bán Pet Max",
    ["Sell pets at or below this rarity"] = "Bán pet từ độ hiếm này trở xuống",
    ["Pet Sell Value"] = "Giá Trị Bán Pet",
    ["Keep Mutated Pets"] = "Giữ Lại Pet Đột Biến",
    ["Blacklist Sell Pets"] = "Danh Sách Đen Bán Pet",
    ["Sell bag eggs matching the rules below"] = "Bán trứng trong túi khớp quy tắc dưới",
    ["Sell Eggs Now"] = "Bán Trứng Ngay",
    ["Sell matching eggs once"] = "Bán một lần các trứng khớp điều kiện",
    ["Sell Egg Rule"] = "Quy Tắc Bán Trứng",
    ["Egg Max Rarity"] = "Độ Hiếm Bán Trứng Max",
    ["Sell eggs at or below this rarity"] = "Bán trứng từ độ hiếm này trở xuống",
    ["Egg Sell Value"] = "Giá Trị Bán Trứng",
    ["Keep Mutated Eggs"] = "Giữ Lại Trứng Đột Biến",
    ["Blacklist Sell Eggs"] = "Danh Sách Đen Bán Trứng",
    ["Sell Lab Eggs Now"] = "Bán Trứng Lab Ngay",
    ["Sell Lab Egg Rule"] = "Quy Tắc Bán Trứng Lab",
    ["Lab Egg Max Rarity"] = "Độ Hiếm Bán Trứng Lab Max",
    ["Lab Egg Sell Value"] = "Giá Trị Bán Trứng Lab",
    ["Keep Mutated Lab Eggs"] = "Giữ Lại Trứng Lab Đột Biến",
    ["Keep Lab Pets"] = "Giữ Lại Pet Lab",
    ["No three matching pets"] = "Không đủ 3 pet trùng khớp",
    ["Fuse 3 same pets into an egg, nonstop"] = "Dung hợp 3 pet cùng loại thành 1 trứng liên tục",
    ["Fuse Priority Mode"] = "Chế Độ Ưu Tiên Dung Hợp",
    ["Pets To Use"] = "Loại Pet Sử Dụng",
    ["Max Rarity to Fuse"] = "Độ Hiếm Dung Hợp Max",
    ["Specific Species to Fuse"] = "Chỉ Định Loài Dung Hợp",
    ["Skip Mutated Pets"] = "Bỏ Qua Pet Đột Biến",
    ["Eject Incomplete Slots"] = "Nhả Các Ô Chưa Đủ Bộ",
    ["Auto Favorite Pet"] = "Tự Động Khóa Pet",
    ["Favorite Pets Now"] = "Khóa Pet Ngay",
    ["Favorite Rule"] = "Quy Tắc Khóa",
    ["Favorite Min Rarity"] = "Độ Hiếm Khóa Min",
    ["Favorite Mutations"] = "Đột Biến Cần Khóa",
    ["Min Favorite Value"] = "Giá Trị Khóa Min",
    ["Always Favorite Species"] = "Luôn Khóa Các Loài Này",
    ["Auto Favorite Equipped"] = "Tự Khóa Pet Đang Dùng",
    ["Auto Unfavorite Equipped"] = "Tự Bỏ Khóa Pet Đang Dùng",
    ["Auto Butterfly Bloom"] = "Tự Động Bắt Bướm",
    ["Catch Mode"] = "Chế Độ Bắt",
    ["Catch Priority"] = "Ưu Tiên Bắt",
    ["Catch Butterflies"] = "Chọn Bướm Muốn Bắt",
    ["Radiant Butterfly"] = "Bướm Rực Rỡ",
    ["Amethyst Butterfly"] = "Bướm Thạch Anh Tím",
    ["Sapphire Butterfly"] = "Bướm Lam Ngọc (Sapphire)",
    ["Emerald Butterfly"] = "Bướm Lục Bảo (Emerald)",
    ["Auto Trade Up"] = "Tự Nâng Cấp Bướm",
    ["Trade Up Tiers"] = "Bậc Nâng Cấp",
    ["Smart Trade For Essence"] = "Đổi Bướm Lấy Tinh Chất Thông Minh",
    ["Going to the middle of the bloom"] = "Đang đi tới trung tâm khu bướm nở",
    ["Auto Craft Essence"] = "Tự Chế Tạo Tinh Chất",
    ["Auto Use Enchanted Essence"] = "Tự Dùng Tinh Chất Phù Phép",
    ["Auto Wisp"] = "Tự Động Nhặt Wisp",
    ["Auto Banjo Cricket"] = "Tự Động Bắt Dế Banjo",
    ["Chase Settings"] = "Cài Đặt Đuổi Đánh",
    ["Hit Tween Speed"] = "Tốc Độ Bay Đánh",
    ["Hit Max Speed"] = "Tốc Độ Đánh Tối Đa",
    ["Hit Lead"] = "Đón Đầu Mục Tiêu (Hit Lead)",
    ["Hit Sweep"] = "Quét Đòn Đánh (Hit Sweep)",
    ["Auto Hit Nearest Player"] = "Tự Đánh Người Gần Nhất",
    ["Auto Hit Egg Holders"] = "Tự Đánh Người Bê Trứng",
    ["Auto Hit Specific Player"] = "Tự Đánh Người Chỉ Định",
    ["Hit Player"] = "Chọn Người Cần Đánh",
    ["Hit Aura"] = "Vòng Đánh Tự Động (Hit Aura)",
    ["Speed Boost"] = "Tăng Tốc Chạy",
    ["Boost Speed"] = "Tốc Độ Tăng Tốc",
    ["Infinite Jump"] = "Nhảy Vô Hạn",
    ["Invisibility"] = "Tàng Hình (Invisibility)",
    ["Anti Ragdoll"] = "Chống Ngã (Anti Ragdoll)",
    ["Anti Trap"] = "Chống Bẫy (Anti Trap)",
    ["Instant Prompts"] = "Tương Tác Nhanh (Instant E)",
    ["ESP Eggs"] = "ESP Trứng",
    ["ESP Guards"] = "ESP Vệ Sĩ",
    ["ESP Lost Parts"] = "ESP Phụ Tùng Rơi",
    ["ESP Players"] = "ESP Người Chơi",
    ["Set Startup Config"] = "Cấu Hình Khởi Động",
    ["Load Config"] = "Tải Cấu Hình",
    ["Save Config"] = "Lưu Cấu Hình",
    ["Import / Export"] = "Nhập / Xuất Cấu Hình",
    ["Export Config"] = "Xuất Cấu Hình",
    ["Import Config Text"] = "Nhập Văn Bản Cấu Hình",
    ["Import Config"] = "Nhập Cấu Hình",
    ["Creates a config only; use Load Config or Set Startup after"] = "Chỉ tạo cấu hình; hãy dùng Tải Cấu Hình hoặc Cài Khởi Động sau",
    ["Pick a config, then press Load to apply it now"] = "Chọn một cấu hình, sau đó bấm Tải để áp dụng ngay",
    ["selected"] = "đã chọn"
}

local DYNAMIC_PATTERNS = {
    { pattern = "ALL (%d+)", format = function(l, c) return l == "VI" and ("TẤT CẢ " .. c) or ("ALL " .. c) end },
    { pattern = "READY (%d+)", format = function(l, c) return l == "VI" and ("SẴN SÀNG " .. c) or ("READY " .. c) end },
    { pattern = "GROWING (%d+)", format = function(l, c) return l == "VI" and ("ĐANG LỚN " .. c) or ("GROWING " .. c) end },
    { pattern = "IN BAG (%d+)", format = function(l, c) return l == "VI" and ("TRONG TÚI " .. c) or ("IN BAG " .. c) end },
    { pattern = "Ends in (%d+h %d+m %d+s)", format = function(l, t) return l == "VI" and ("Kết thúc sau " .. t) or ("Ends in " .. t) end },
    { pattern = "Players (%d+)/(%d+)", format = function(l, p1, p2) return l == "VI" and string.format("Người chơi %s/%s", p1, p2) or string.format("Players %s/%s", p1, p2) end },
    { pattern = "#(%d+) of (%d+) eggs by value", format = function(l, r, t) return l == "VI" and string.format("#%s / %s trứng theo giá trị", r, t) or string.format("#%s of %s eggs by value", r, t) end },
    { pattern = "Eggs placed (%d+)/(%d+) %- (%d+)/(%d+) pets equipped, (%d+) in bag", format = function(l, p1, p2, p3, p4, p5)
        return l == "VI" and string.format("Trứng đã đặt %s/%s - %s/%s pet trang bị, %s trong túi", p1, p2, p3, p4, p5) or string.format("Eggs placed %s/%s - %s/%s pets equipped, %s in bag", p1, p2, p3, p4, p5)
    end },
    { pattern = "Pet matches %- (%d+) pets? for %$(.+)", format = function(l, c, v)
        return l == "VI" and string.format("Khớp pet - %s pet giá $%s", c, v) or string.format("Pet matches - %s pets for $%s", c, v)
    end },
    { pattern = "Egg matches %- (%d+) eggs? for %$(.+)", format = function(l, c, v)
        return l == "VI" and string.format("Khớp trứng - %s trứng giá $%s", c, v) or string.format("Egg matches - %s eggs for $%s", c, v)
    end }
}

-- ==================== BỘ DỊCH RIÊNG CHO VENYX HUB (TỪ ĐIỂN V5 + BỔ SUNG) ====================
-- Dịch theo NGUYÊN CHUỖI (exact) + mẫu câu trạng thái (pattern), nên không làm hỏng chuỗi dài.
-- Khi không khớp, bộ dịch V4 phía trên vẫn được dùng làm phương án dự phòng.
local VX_EXACT_VI = {
    ["Idle"] = "Đang rảnh",
    ["Waiting"] = "Đang chờ",
    ["Nothing"] = "Không có gì",
    ["No egg matches your targets"] = "Không có trứng nào khớp mục tiêu",
    ["No eggs match your targets"] = "Không có trứng nào khớp mục tiêu",
    ["No egg matches filter"] = "Không có trứng khớp bộ lọc",
    ["No eggs match filter"] = "Không có trứng khớp bộ lọc",
    ["No target egg found"] = "Không tìm thấy trứng mục tiêu",
    ["No matching eggs"] = "Không có trứng nào khớp",
    ["No matching pets"] = "Không có pet nào khớp",
    ["No valid targets"] = "Không có mục tiêu hợp lệ",
    ["No targets found"] = "Không tìm thấy mục tiêu",
    ["Bag is full"] = "Túi đã đầy",
    ["Egg bag is full"] = "Túi trứng đã đầy",
    ["Pet bag is full"] = "Túi pet đã đầy",
    ["Pen is full"] = "Chuồng ấp đã đầy",
    ["All pens are full"] = "Tất cả chuồng đã đầy",
    ["Field is closed"] = "Sân trứng đang đóng",
    ["Waiting for field to open"] = "Đang chờ sân trứng mở",
    ["Waiting for eggs to spawn"] = "Đang chờ trứng xuất hiện",
    ["Waiting for shooting star"] = "Đang chờ sao băng rơi",
    ["Waiting for butterfly bloom"] = "Đang chờ mùa bướm nở",
    ["Waiting in safe zone"] = "Đợi ở vùng an toàn",
    ["Returning to safe zone"] = "Đang về vùng an toàn",
    ["Returning home"] = "Đang quay về nhà",
    ["Going home"] = "Đang về nhà",
    ["Going to safe zone"] = "Đang về vùng an toàn",
    ["Delivering egg"] = "Đang giao trứng về chuồng",
    ["Dropping egg"] = "Đang thả trứng",
    ["Dropping eggs"] = "Đang thả trứng",
    ["Selling eggs"] = "Đang bán trứng",
    ["Selling pets"] = "Đang bán pet",
    ["Selling lab eggs"] = "Đang bán trứng Lab",
    ["Hatching eggs"] = "Đang ấp trứng",
    ["Placing eggs"] = "Đang đặt trứng",
    ["Mutating eggs"] = "Đang đột biến trứng",
    ["Fusing pets"] = "Đang dung hợp pet",
    ["Hopping server"] = "Đang đổi máy chủ",
    ["Finding server"] = "Đang tìm máy chủ mới",
    ["Rejoining"] = "Đang vào lại phòng",
    ["Avoiding guard"] = "Đang né vệ sĩ",
    ["Evading guard"] = "Đang né vệ sĩ",
    ["Using treadmill"] = "Đang chạy máy tập",
    ["Upgrading treadmill"] = "Đang nâng cấp máy tập",
    ["Upgrading base"] = "Đang nâng cấp căn cứ",
    ["Claiming rewards"] = "Đang nhận thưởng",
    ["Claiming offline cash"] = "Đang nhận tiền ngoại tuyến",
    ["Catching shooting star"] = "Đang bắt sao băng",
    ["Catching butterfly"] = "Đang bắt bướm",

    -- Trang Home & Dashboard Mới
    ["Home"] = "Trang Chủ",
    ["Dashboard"] = "Bảng Điều Khiển",
    ["Welcome back"] = "Chào mừng trở lại",
    ["Venyx Discord"] = "Discord Venyx",
    ["Updates, keys, support"] = "Cập nhật, nhận key, hỗ trợ",
    ["Copy Invite"] = "Chép Link Mời",
    ["Discord"] = "Discord",
    ["MONEY /S"] = "TIỀN /GIÂY",
    ["OPEN"] = "MỞ",
    ["Open"] = "Mở",
    ["Close"] = "Đóng",
    ["Welcome to Venyx 1.0.0! Join our Discord for updates and support"] = "Chào mừng tới Venyx 1.0.0! Tham gia Discord để cập nhật và nhận hỗ trợ",
    ["Beta version"] = "Phiên bản Beta",
    ["This is a test build. Features may change and bugs can happen."] = "Đây là bản thử nghiệm. Tính năng có thể thay đổi và phát sinh lỗi.",
    ["Rejoin"] = "Vào lại",
    ["Server hop"] = "Đổi server",
    ["Copy Job ID"] = "Chép Job ID",
    ["Unload hub"] = "Tắt Hub",
    ["Save config"] = "Lưu cấu hình",
    ["Hide UI"] = "Ẩn Menu",
    ["SESSION"] = "PHIÊN CHƠI",
    ["STOLEN"] = "ĐÃ CƯỚP",
    ["LAST EGG"] = "TRỨNG CUỐI",
    ["PLACED"] = "ĐÃ ĐẶT",
    ["HATCHED"] = "ĐÃ ẤP",
    ["NIGHT IN"] = "ĐÊM SAU",
    ["SESSION TIME"] = "THỜI GIAN",
    ["BEST STEAL"] = "CƯỚP TỐT NHẤT",
    ["EGG BAG"] = "TÚI TRỨNG",
    ["PET BAG"] = "TÚI PET",
    ["WHAT'S NEW"] = "CÓ GÌ MỚI",
    ["NEW"] = "MỚI",
    ["Event"] = "Sự Kiện",
    ["Shooting Star catcher with ragdoll jump and run fallback"] = "Bắt Sao Băng kết hợp nhảy ragdoll và chạy dự phòng",
    ["Steal panel joins the game buttons and lists every egg"] = "Bảng Cướp tích hợp nút game và liệt kê mọi quả trứng",
    ["Search"] = "Tìm kiếm",
    ["Filter"] = "Lọc tìm",

    -- Steal & Egg Predictor
    ["Steal"] = "Cướp Trứng",
    ["Auto Steal"] = "Tự Động Cướp",
    ["AUTO STEAL"] = "TỰ ĐỘNG CƯỚP",
    ["Auto steal"] = "Tự động cướp",
    ["Egg Predictor"] = "Dự Đoán Trứng",
    ["EGG PREDICTOR"] = "DỰ ĐOÁN TRỨNG",
    ["Go to egg"] = "Di chuyển tới trứng",
    ["Teleport to egg"] = "Dịch chuyển tới trứng",
    ["Teleport zones"] = "Khu vực dịch chuyển",
    ["Teleport zone"] = "Khu vực dịch chuyển",
    ["Tween"] = "Bay (Tween)",
    ["Walk"] = "Đi bộ",
    ["Delivery method"] = "Cách mang về",
    ["Fast tween speed"] = "Tốc độ bay nhanh",
    ["Tween speed"] = "Tốc độ bay",
    ["Steal missing index eggs"] = "Cướp trứng thiếu trong Chỉ mục",
    ["Steal back from players"] = "Cướp lại từ người chơi",
    ["Steal from other players"] = "Cướp từ người chơi khác",
    ["Steal from players"] = "Cướp từ người chơi",
    ["Anti guard"] = "Chống vệ sĩ",
    ["Drop eggs at safe zone"] = "Thả trứng ở vùng an toàn",
    ["FILTER"] = "BỘ LỌC",
    ["Zones"] = "Khu vực",
    ["Zone"] = "Khu vực",
    ["None"] = "Không có",
    ["Steal first"] = "Ưu tiên cướp",
    ["Best value"] = "Giá trị cao nhất",
    ["Lowest value"] = "Giá trị thấp nhất",
    ["Best rarity"] = "Độ hiếm cao nhất",
    ["Best mutation"] = "Đột biến tốt nhất",
    ["Biggest"] = "Kích thước to nhất",
    ["Closest"] = "Khoảng cách gần nhất",
    ["Mutations"] = "Đột biến",
    ["Rarities"] = "Độ hiếm",
    ["Only these eggs"] = "Chỉ những trứng này",
    ["Min value /s"] = "Giá trị tối thiểu /s",
    ["Max value /s"] = "Giá trị tối đa /s",
    ["Off"] = "Tắt",
    ["OFF"] = "TẮT",
    ["On"] = "Bật",
    ["ON"] = "BẬT",
    ["Sell cheapest egg when bag is full"] = "Bán trứng rẻ nhất khi đầy túi",
    ["Keep lab eggs"] = "Giữ lại trứng Lab",
    ["AUTO HOP SERVER"] = "TỰ ĐỔI MÁY CHỦ",
    ["Auto hop server"] = "Tự đổi máy chủ",
    ["Hop when no matching egg"] = "Đổi server khi không có trứng khớp",
    ["Hop when no egg matches"] = "Đổi server khi không có trứng khớp",
    ["Hop delay"] = "Độ trễ đổi server",
    ["Only sell eggs below /s"] = "Chỉ bán trứng dưới mức /s",
    ["EGG SHOWCASE"] = "TRƯNG BÀY TRỨNG",
    ["Sort eggs"] = "Sắp xếp trứng",
    ["Preview card"] = "Thẻ xem trước",
    ["Pick one"] = "Chọn một mục",
    ["Pick any"] = "Chọn bất kỳ",
    ["Value"] = "Giá trị",
    ["Rarity"] = "Độ hiếm",
    ["Time left"] = "Thời gian còn lại",
    ["Default"] = "Mặc định",
    ["Clear"] = "Xóa chọn",
    ["Select all"] = "Chọn tất cả",
    ["SIZE"] = "KÍCH CỠ",
    ["WEIGHT"] = "CÂN NẶNG",
    ["READY"] = "SẴN SÀNG",
    ["IN BAG"] = "TRONG TÚI",
    ["GROWING"] = "ĐANG LỚN",
    ["Hatch now"] = "Ấp ngay",
    ["Hold egg"] = "Cầm trứng",
    ["Fly to egg"] = "Bay tới trứng",
    ["Steal egg"] = "Cướp trứng",

    -- Zones (Khu vực)
    ["Enchanted Forest"] = "Rừng Phù Phép",
    ["Light Dark"] = "Sáng Tối",
    ["Titan Temple"] = "Đền Titan",
    ["Cherry Blossom"] = "Hoa Anh Đào",
    ["Prehistoric"] = "Tiền Sử",
    ["Abyss Ocean"] = "Đáy Đại Dương",
    ["Volcano"] = "Núi Lửa",
    ["Snow"] = "Tuyết",
    ["Jungle"] = "Rừng Rậm",
    ["Desert"] = "Sa Mạc",
    ["Lake"] = "Hồ Nước",
    ["Forest"] = "Khu Rừng",

    -- Mutations (Đột biến)
    ["Silver"] = "Bạc",
    ["Rainbow"] = "Cầu Vồng",
    ["Golden"] = "Vàng",
    ["Fractured"] = "Rạn Nứt",
    ["Scrambled"] = "Hỗn Loạn",
    ["Enchanted"] = "Phù Phép",
    ["Nitro"] = "Nitro",
    ["SCRAMBLED"] = "HỖN LOẠN",
    ["NITRO"] = "NITRO",
    ["FRACTURED"] = "RẠN NỨT",
    ["ENCHANTED"] = "PHÙ PHÉP",

    -- Farm: Pen, Treadmill, Mutate, Sell, Fuse, Priority
    ["Farm"] = "Cày Cuốc",
    ["Pen"] = "Chuồng Ấp",
    ["PEN"] = "CHUỒNG ẤP",
    ["Treadmill"] = "Máy Tập",
    ["TREADMILL"] = "MÁY TẬP CHẠY",
    ["Mutate"] = "Đột Biến",
    ["MUTATE"] = "ĐỘT BIẾN",
    ["Sell"] = "Bán",
    ["SELL"] = "BÁN TỰ ĐỘNG",
    ["Fuse"] = "Dung Hợp",
    ["FUSE"] = "DUNG HỢP",
    ["Priority"] = "Ưu Tiên",
    ["PRIORITY"] = "THỨ TỰ ƯU TIÊN",
    ["AUTO PLACE"] = "TỰ ĐỘNG ĐẶT TRỨNG",
    ["Auto place"] = "Tự động đặt trứng",
    ["Place when"] = "Đặt khi",
    ["Always"] = "Luôn luôn",
    ["Place first"] = "Ưu tiên đặt",
    ["AUTO HATCH"] = "TỰ ĐỘNG ẤP TRỨNG",
    ["Auto hatch"] = "Tự động ấp trứng",
    ["Equip best pets"] = "Trang bị pet mạnh nhất",
    ["READY NOW"] = "SẴN SÀNG ẤP",
    ["Auto treadmill"] = "Tự chạy máy tập",
    ["Auto upgrade treadmill"] = "Tự nâng cấp máy tập",
    ["PROGRESS"] = "TIẾN TRÌNH",
    ["Auto upgrade base"] = "Tự nâng cấp căn cứ",
    ["Auto buy trails"] = "Tự mua vệt sáng",
    ["Auto claim offline cash"] = "Tự nhận tiền ngoại tuyến",
    ["Auto claim index rewards"] = "Tự nhận thưởng Chỉ mục",
    ["AUTO MUTATE"] = "TỰ ĐỘNG ĐỘT BIẾN",
    ["Auto mutate"] = "Tự động đột biến",
    ["MUTATE FILTER"] = "BỘ LỌC ĐỘT BIẾN",
    ["Use items"] = "Dùng vật phẩm",
    ["Mutate first"] = "Ưu tiên đột biến",
    ["Auto buy Nitro"] = "Tự mua Nitro",
    ["PETS"] = "THÚ CƯNG (PETS)",
    ["EGGS"] = "TRỨNG (EGGS)",
    ["Auto sell pets"] = "Tự động bán pet",
    ["Auto sell eggs"] = "Tự động bán trứng",
    ["Sell rarities"] = "Độ hiếm bán",
    ["Never sell"] = "Không bao giờ bán",
    ["Only mutations"] = "Chỉ bán đột biến",
    ["Only below /s"] = "Chỉ dưới mức /s",
    ["Keep mutated"] = "Giữ lại đồ đột biến",
    ["Sell matching pets now"] = "Bán các pet khớp ngay",
    ["Sell matching eggs now"] = "Bán các trứng khớp ngay",
    ["LAB EGGS"] = "TRỨNG PHÒNG LAB",
    ["FAVORITE"] = "YÊU THÍCH (KHÓA)",
    ["Auto favorite"] = "Tự động khóa bảo vệ",
    ["Auto sell lab eggs"] = "Tự động bán trứng Lab",
    ["Sell matching lab eggs now"] = "Bán trứng Lab khớp ngay",
    ["Match"] = "Điều kiện khớp",
    ["All picked rules"] = "Khớp tất cả quy tắc",
    ["Any picked rule"] = "Khớp bất kỳ quy tắc",
    ["Always favorite"] = "Luôn khóa loài này",
    ["Favorite equipped"] = "Khóa pet đang trang bị",
    ["FUSE MACHINE"] = "MÁY DUNG HỢP",
    ["No 3 matching pets"] = "Chưa đủ 3 pet cùng loại",
    ["Auto fuse"] = "Tự động dung hợp",
    ["Fuse first"] = "Ưu tiên dung hợp",
    ["Lowest rarity"] = "Độ hiếm thấp nhất",
    ["Highest rarity"] = "Độ hiếm cao nhất",
    ["Use pets"] = "Sử dụng pet",
    ["Lowest value first"] = "Giá trị thấp nhất trước",
    ["Highest value first"] = "Giá trị cao nhất trước",
    ["Skip mutated"] = "Bỏ qua pet đột biến",
    ["Eject odd pets"] = "Đẩy pet lẻ ra ngoài",
    ["FUSE FILTER"] = "BỘ LỌC DUNG HỢP",
    ["Only these pets"] = "Chỉ những pet này",
    ["Never fuse"] = "Không bao giờ dung hợp",
    ["FUSE PREDICTOR"] = "DỰ ĐOÁN DUNG HỢP",
    ["SLOTS"] = "Ô CHỨA",
    ["STATUS"] = "TRẠNG THÁI",
    ["Waiting for pets"] = "Đang chờ pet",
    ["LIKELY SIZE"] = "KÍCH CỠ DỰ KIẾN",
    ["CHANCE"] = "TỶ LỆ",
    ["VALUE"] = "GIÁ TRỊ",
    ["BEST CASE"] = "TỐT NHẤT CÓ THỂ",
    ["TASK ORDER"] = "THỨ TỰ TÁC VỤ",
    ["Top goes first. A carried egg is always delivered first, and before the field opens every task waits in the safe zone."] = "Mục ở trên làm trước. Trứng đang bê luôn được giao trước, và trước khi khu vực mở thì mọi tác vụ sẽ đợi ở vùng an toàn.",
    ["DOING"] = "ĐANG LÀM",
    ["WAITING"] = "ĐANG CHỜ",
    ["Steal filter eggs"] = "Cướp trứng theo bộ lọc",
    ["Shooting Star"] = "Bắt Sao Băng",
    ["Butterfly"] = "Bắt Bướm",
    ["Steal wisp eggs"] = "Cướp trứng Wisp",
    ["Wisp"] = "Nhặt Wisp",
    ["Steal missing index"] = "Cướp trứng thiếu trong Chỉ mục",
    ["Steal lab eggs"] = "Cướp trứng phòng Lab",
    ["Place"] = "Đặt trứng vào chuồng",
    ["Butterfly machine"] = "Máy đổi Bướm",

    -- Event: Race, Star, Butterfly, Lab, AA
    ["Star"] = "Sao Băng",
    ["STAR"] = "SAO BĂNG",
    ["BUTTERFLY"] = "BẮT BƯỚM",
    ["AA"] = "Admin (AA)",
    ["WINS"] = "THẮNG",
    ["TROPHIES"] = "CÚP",
    ["REWARDS"] = "PHẦN THƯỞNG",
    ["Auto claim rewards"] = "Tự nhận phần thưởng",
    ["SHOOTING STAR"] = "SAO BĂNG RƠI",
    ["LANDS IN"] = "RƠI SAU",
    ["CATCH"] = "BẮT SAO BĂNG",
    ["A Shooting Star is rare and only you can catch yours. It lands in Cosmic, runs from you, and needs a 1.6 s hold."] = "Sao Băng rất hiếm và chỉ bạn mới bắt được của mình. Nó rơi ở khu Vũ Trụ (Cosmic), chạy trốn bạn và cần nhấn giữ 1.6 giây.",
    ["CAUGHT"] = "ĐÃ BẮT",
    ["EXPIRES IN"] = "BIẾN MẤT SAU",
    ["SLIPPED"] = "TUỘT MẤT",
    ["TRIES"] = "SỐ LẦN THỬ",
    ["DISTANCE"] = "KHOẢNG CÁCH",
    ["Auto catch shooting star"] = "Tự động bắt sao băng",
    ["BUTTERFLY BLOOM"] = "MÙA BƯỚM NỞ",
    ["Auto butterfly bloom"] = "Tự động bắt bướm",
    ["EMERALD"] = "LỤC BẢO",
    ["SAPPHIRE"] = "LAM NGỌC",
    ["AMETHYST"] = "THẠCH ANH TÍM",
    ["RADIANT"] = "RỰC RỠ",
    ["ESSENCE"] = "TINH CHẤT",
    ["Catch mode"] = "Chế độ bắt",
    ["Stand"] = "Đứng yên",
    ["Chase"] = "Đuổi theo",
    ["BUTTERFLY MACHINE"] = "MÁY ĐỔI BƯỚM",
    ["Auto trade up"] = "Tự nâng cấp bậc bướm",
    ["Trade"] = "Giao dịch đổi",
    ["Smart trade for essence"] = "Đổi bướm lấy tinh chất thông minh",
    ["Auto craft essence"] = "Tự chế tạo tinh chất",
    ["WISP COMPANION"] = "ĐỒNG HÀNH WISP",
    ["Catch priority"] = "Ưu tiên bắt",
    ["Rarest"] = "Hiếm nhất",
    ["Catch"] = "Loại bướm bắt",
    ["Radiant"] = "Rực Rỡ",
    ["Catch speed"] = "Tốc độ bắt",
    ["Auto wisp quest"] = "Tự làm nhiệm vụ Wisp",
    ["Auto banjo cricket"] = "Tự bắt dế Banjo",
    ["STAGE"] = "GIAI ĐOẠN",
    ["ENDS IN"] = "KẾT THÚC SAU",
    ["NEXT"] = "TIẾP THEO",
    ["ADMIN ABUSE"] = "LẠM DỤNG ADMIN (ABUSE)",
    ["No admin boost right now"] = "Hiện không có buff Admin nào",
    ["Instant steal (Admin Treadmill)"] = "Cướp tức thì (Máy tập Admin)",
    ["Use admin treadmill"] = "Tự dùng máy tập Admin",
    ["CAPTURE THE EGG"] = "CƯỚP TRỨNG SỰ KIỆN",
    ["Auto capture event egg"] = "Tự bắt trứng sự kiện",
    ["Take it from the holder"] = "Giật trứng từ người đang cầm",
    ["Hold height"] = "Độ cao giữ trứng",
    ["Keep away"] = "Khoảng cách né tránh",
    ["MINIGAME EGGS"] = "TRỨNG MINIGAME",
    ["Waiting for Red Light Green Light or T-Rex Run"] = "Đang chờ Đèn Đỏ Đèn Xanh hoặc Chạy Trốn T-Rex",
    ["Auto steal minigame egg"] = "Tự cướp trứng Minigame",

    -- Player: ESP, Move, Combat
    ["Player"] = "Người Chơi",
    ["ESP"] = "Định Vị (ESP)",
    ["Move"] = "Di Chuyển",
    ["MOVE"] = "DI CHUYỂN",
    ["Combat"] = "Chiến Đấu",
    ["COMBAT"] = "CHIẾN ĐẤU",
    ["FIELD EGGS"] = "TRỨNG NGOÀI SÂN",
    ["Egg ESP"] = "ESP Trứng",
    ["Show"] = "Hiển thị",
    ["Name"] = "Tên",
    ["Fixed size"] = "Cố định kích cỡ",
    ["OTHERS"] = "MỤC KHÁC",
    ["Pen egg ESP"] = "ESP trứng trong chuồng",
    ["Other pens ESP"] = "ESP chuồng người khác",
    ["Guard ESP"] = "ESP Vệ sĩ",
    ["Player ESP"] = "ESP Người chơi",
    ["ESP size"] = "Kích cỡ ESP",
    ["MOVEMENT"] = "TỐC ĐỘ & DI CHUYỂN",
    ["Speed boost"] = "Tăng tốc chạy",
    ["Boost speed"] = "Tốc độ tăng thêm",
    ["Infinite jump"] = "Nhảy vô hạn",
    ["God mode"] = "Bất tử (God mode)",
    ["PROTECTION"] = "BẢO VỆ NHÂN VẬT",
    ["Anti ragdoll"] = "Chống ngã (Anti Ragdoll)",
    ["Ignore traps"] = "Bỏ qua bẫy",
    ["Instant prompts"] = "Tương tác nhấn giữ tức thì",
    ["Anti AFK"] = "Chống treo máy (Anti AFK)",
    ["Invisible"] = "Tàng hình",
    ["AUTO HIT"] = "TỰ ĐỘNG ĐÁNH",
    ["Auto hit"] = "Tự động đánh",
    ["Hit who"] = "Mục tiêu đánh",
    ["Nearest player"] = "Người chơi gần nhất",
    ["Chosen player"] = "Người chơi chỉ định",
    ["Chase speed"] = "Tốc độ đuổi theo",
    ["HIT AURA"] = "VÒNG ĐÁNH TỰ ĐỘNG",
    ["Hit aura"] = "Vòng đánh tự động (Hit Aura)",
    ["Skip friends"] = "Bỏ qua bạn bè",
    ["WEAPONS"] = "VŨ KHÍ",
    ["Use weapons"] = "Sử dụng vũ khí",
    ["Hold each"] = "Thời gian cầm mỗi món",

    -- System: Server, Webhook, Optimizer, Interface, Config
    ["System"] = "Hệ Thống",
    ["Server"] = "Máy Chủ",
    ["SERVER"] = "MÁY CHỦ",
    ["Webhook"] = "Webhook",
    ["WEBHOOK"] = "WEBHOOK",
    ["Optimizer"] = "Tối Ưu Hóa",
    ["OPTIMIZER"] = "TỐI ƯU HÓA (GIẢM LAG)",
    ["Interface"] = "Giao Diện",
    ["INTERFACE"] = "GIAO DIỆN",
    ["Config"] = "Cấu Hình",
    ["CONFIG"] = "CẤU HÌNH",
    ["Hop to"] = "Chuyển tới server",
    ["Least players"] = "Ít người chơi nhất",
    ["Most players"] = "Đông người chơi nhất",
    ["Random"] = "Ngẫu nhiên",
    ["Hop server"] = "Đổi máy chủ",
    ["Hop"] = "Đổi ngay",
    ["Rejoin this server"] = "Vào lại máy chủ này",
    ["Copy"] = "Sao chép",
    ["JOIN AND STAY"] = "VÀO PHÒNG & DUY TRÌ",
    ["Job ID"] = "Mã phòng (Job ID)",
    ["Paste a Job ID"] = "Dán mã Job ID vào đây",
    ["Join that server"] = "Vào máy chủ đó",
    ["Join"] = "Vào ngay",
    ["Rejoin on kick"] = "Tự vào lại khi bị văng/kick",
    ["Auto load script"] = "Tự chạy lại script khi chuyển server",
    ["DISCORD WEBHOOK"] = "WEBHOOK DISCORD",
    ["Webhook URL"] = "Đường dẫn Webhook",
    ["Ping everyone"] = "Tag @everyone",
    ["WHAT TO POST"] = "NỘI DUNG GỬI BÁO CÁO",
    ["Post stolen eggs"] = "Báo cáo trứng cướp được",
    ["Post fused eggs"] = "Báo cáo trứng dung hợp",
    ["POSTED"] = "ĐÃ GỬI",
    ["Send a test post"] = "Gửi tin nhắn thử nghiệm",
    ["Test"] = "Thử nghiệm",
    ["Post when bag is full"] = "Gửi thông báo khi đầy túi",
    ["GRAPHICS"] = "ĐỒ HỌA",
    ["Low graphics"] = "Đồ họa thấp (Tăng FPS)",
    ["Disable 3D Render"] = "Tắt kết xuất 3D (Treo máy)",
    ["Background color"] = "Màu nền màn hình",
    ["Black"] = "Màu Đen",
    ["White"] = "Màu Trắng",
    ["Hide game UI"] = "Ẩn giao diện gốc của Game",
    ["FRAME RATE"] = "TỐC ĐỘ KHUNG HÌNH (FPS)",
    ["FPS cap"] = "Giới hạn FPS",
    ["Show FPS and ping"] = "Hiện chỉ số FPS và Ping",
    ["BASES"] = "CĂN CỨ (BASES)",
    ["Hide other players' pets and eggs"] = "Ẩn pet và trứng của người chơi khác",
    ["Hide my pets and eggs"] = "Ẩn pet và trứng của bản thân",
    ["Theme"] = "Chủ đề màu",
    ["Toggle key"] = "Phím đóng/mở Menu",
    ["Quick bar"] = "Thanh phím tắt nhanh",
    ["QUICK BAR"] = "THANH PHÍM TẮT NHANH",
    ["Auto save"] = "Tự động lưu cấu hình",
    ["Auto load"] = "Tự động nạp cấu hình",
    ["Load config"] = "Nạp cấu hình",
    ["Reset config"] = "Đặt lại mặc định",
    ["Delete config"] = "Xóa cấu hình",

    -- Độ hiếm
    ["Common"] = "Phổ Thông",
    ["Uncommon"] = "Thường",
    ["Rare"] = "Hiếm",
    ["Epic"] = "Sử Thi",
    ["Legendary"] = "Huyền Thoại",
    ["Mythic"] = "Thần Thoại",
    ["Cosmic"] = "Vũ Trụ",
    ["Secret"] = "Bí Ẩn",
    ["Divine"] = "Thánh Thần",
    ["Eternal"] = "Vĩnh Cửu",
    ["COMMON"] = "PHỔ THÔNG",
    ["UNCOMMON"] = "THƯỜNG",
    ["RARE"] = "HIẾM",
    ["EPIC"] = "SỬ THI",
    ["LEGENDARY"] = "HUYỀN THOẠI",
    ["MYTHIC"] = "THẦN THOẠI",
    ["COSMIC"] = "VŨ TRỤ",
    ["SECRET"] = "BÍ ẨN",
    ["DIVINE"] = "THÁNH THẦN",
    ["ETERNAL"] = "VĨNH CỬU"
}

local VX_STATUS_PATTERNS = {
    { pat = "^[Ff]ighting (.+)$", rep = "Đang đánh %1" },
    { pat = "^[Hh]alloween: (%l.+)$", rep = "Halloween: %1" },
    { pat = "^[Cc]asting (.+)$", rep = "Đang quăng cần %1" },
    { pat = "^[Rr]eeling in(.+)$", rep = "Đang kéo cá%1" },
    { pat = "^[Gg]host [Dd]og: (.+)$", rep = "Chó Ma: %1" },
    { pat = "^[Ww]aiting for an? (.+)$", rep = "Đang chờ %1" },
    { pat = "^[Nn]o eggs? match%(?e?s?%)? your (.+)$", rep = "Không có trứng nào khớp %1" },
    { pat = "^[Nn]o eggs? match%(?e?s?%)? (.+)$", rep = "Không có trứng nào khớp %1" },
    { pat = "^[Nn]o pets? match%(?e?s?%)? (.+)$", rep = "Không có pet nào khớp %1" },
    { pat = "^[Nn]o (.+) found$", rep = "Không tìm thấy %1" },
    { pat = "^[Nn]o (.+) available$", rep = "Không có sẵn %1" },
    { pat = "^[Nn]o (.+) to (.+)$", rep = "Không có %1 để %2" },
    { pat = "^[Cc]arrying (.+) to safe zone$", rep = "Đang mang %1 về vùng an toàn" },
    { pat = "^[Cc]arrying (.+) to base$", rep = "Đang mang %1 về căn cứ" },
    { pat = "^[Cc]arrying (.+) to pen$", rep = "Đang mang %1 về chuồng" },
    { pat = "^[Cc]arrying (.+) home$", rep = "Đang mang %1 về nhà" },
    { pat = "^[Cc]arrying (.+)$", rep = "Đang bê %1" },
    { pat = "^[Dd]elivering (.+) to (.+)$", rep = "Đang giao %1 tới %2" },
    { pat = "^[Dd]elivering (.+) home$", rep = "Đang giao %1 về nhà" },
    { pat = "^[Dd]elivering (.+)$", rep = "Đang giao %1" },
    { pat = "^[Bb]ringing (.+) home$", rep = "Đang mang %1 về nhà" },
    { pat = "^[Bb]ringing (.+)$", rep = "Đang mang %1" },
    { pat = "^[Tt]aking (.+) from (.+)$", rep = "Đang giật %1 từ %2" },
    { pat = "^[Tt]aking (.+) home$", rep = "Đang đem %1 về nhà" },
    { pat = "^[Tt]aking (.+)$", rep = "Đang lấy %1" },
    { pat = "^[Ss]tealing (.+) from (.+)$", rep = "Đang cướp %1 từ %2" },
    { pat = "^[Ss]tealing (.+)$", rep = "Đang cướp %1" },
    { pat = "^[Gg]rabbing (.+)$", rep = "Đang chộp lấy %1" },
    { pat = "^[Pp]icking up (.+)$", rep = "Đang nhặt %1" },
    { pat = "^[Cc]ollecting (.+)$", rep = "Đang thu thập %1" },
    { pat = "^[Hh]olding (.+)$", rep = "Đang giữ %1" },
    { pat = "^[Cc]apturing (.+)$", rep = "Đang bắt giữ %1" },
    { pat = "^[Dd]ropping (.+) at (.+)$", rep = "Đang thả %1 tại %2" },
    { pat = "^[Dd]ropping (.+)$", rep = "Đang thả %1" },
    { pat = "^[Tt]weening to (.+)$", rep = "Đang bay tới %1" },
    { pat = "^[Tt]eleporting to (.+)$", rep = "Đang dịch chuyển tới %1" },
    { pat = "^[Gg]oing to (.+)$", rep = "Đang đi tới %1" },
    { pat = "^[Mm]oving to (.+)$", rep = "Đang di chuyển tới %1" },
    { pat = "^[Ww]alking to (.+)$", rep = "Đang chạy tới %1" },
    { pat = "^[Rr]unning to (.+)$", rep = "Đang chạy tới %1" },
    { pat = "^[Ff]lying to (.+)$", rep = "Đang bay tới %1" },
    { pat = "^[Rr]eturning to (.+)$", rep = "Đang quay về %1" },
    { pat = "^[Hh]eading to (.+)$", rep = "Đang hướng tới %1" },
    { pat = "^[Pp]lacing (.+)$", rep = "Đang đặt %1" },
    { pat = "^[Hh]atching (.+)$", rep = "Đang ấp %1" },
    { pat = "^[Mm]utating (.+)$", rep = "Đang đột biến %1" },
    { pat = "^[Ss]elling (.+)$", rep = "Đang bán %1" },
    { pat = "^[Ff]using (.+)$", rep = "Đang dung hợp %1" },
    { pat = "^[Uu]pgrading (.+)$", rep = "Đang nâng cấp %1" },
    { pat = "^[Bb]uying (.+)$", rep = "Đang mua %1" },
    { pat = "^[Cc]laiming (.+)$", rep = "Đang nhận %1" },
    { pat = "^[Ee]quipping (.+)$", rep = "Đang trang bị %1" },
    { pat = "^[Ff]avoriting (.+)$", rep = "Đang khóa bảo vệ %1" },
    { pat = "^[Ee]jecting (.+)$", rep = "Đang đẩy %1 ra" },
    { pat = "^[Cc]atching (.+)$", rep = "Đang bắt %1" },
    { pat = "^[Cc]hasing (.+)$", rep = "Đang đuổi theo %1" },
    { pat = "^[Aa]ttacking (.+)$", rep = "Đang tấn công %1" },
    { pat = "^[Hh]itting (.+)$", rep = "Đang đánh %1" },
    { pat = "^[Kk]illing (.+)$", rep = "Đang hạ %1" },
    { pat = "^[Tt]rading (.+) for (.+)$", rep = "Đang đổi %1 lấy %2" },
    { pat = "^[Tt]rading in (.+)$", rep = "Đang đổi %1" },
    { pat = "^[Tt]rading (.+)$", rep = "Đang giao dịch %1" },
    { pat = "^[Cc]rafting (.+)$", rep = "Đang chế tạo %1" },
    { pat = "^[Rr]erolling (.+)$", rep = "Đang đổi lại %1" },
    { pat = "^[Aa]voiding (.+)$", rep = "Đang né %1" },
    { pat = "^[Ee]vading (.+)$", rep = "Đang tránh %1" },
    { pat = "^[Ww]aiting for (.+)$", rep = "Đang chờ %1" },
    { pat = "^[Ww]aiting in (.+)$", rep = "Đang đợi ở %1" },
    { pat = "^[Ww]aiting %((.+)%)$", rep = "Đang chờ (%1)" },
    { pat = "^[Ss]earching for (.+)$", rep = "Đang tìm %1" },
    { pat = "^[Ll]ooking for (.+)$", rep = "Đang tìm %1" },
    { pat = "^[Ff]arming (.+)$", rep = "Đang cày %1" },
    { pat = "^[Uu]sing (.+)$", rep = "Đang dùng %1" },
    { pat = "^[Jj]oining (.+)$", rep = "Đang tham gia %1" },
    { pat = "^[Hh]opping (.+)$", rep = "Đang đổi %1" }
}

local VX_SMART_PHRASES = {
    { "No egg matches your targets", "Không có trứng nào khớp mục tiêu" },
    { "no egg matches your targets", "không có trứng nào khớp mục tiêu" },
    { "your targets", "mục tiêu của bạn" },
    { "matches your", "khớp với" },
    { "matches filter", "khớp bộ lọc" },
    { "safe zone", "vùng an toàn" },
    { "other players", "người chơi khác" },
    { "from players", "từ người chơi" },
    { "missing index", "thiếu trong Chỉ mục" },
    { "Halloween monsters", "quái vật Halloween" },
    { "Halloween fishing", "câu cá Halloween" },
    { "halloween fishing", "câu cá Halloween" },
    { "Large monster", "quái vật lớn" },
    { "Small monster", "quái vật nhỏ" },
    { "Medium monster", "quái vật vừa" },
    { "Perfect", "Hoàn Hảo" },
    { "carrying the egg to safety", "đang bê trứng về nơi an toàn" },
    { "carrying the egg", "đang bê trứng" },
    { "underwater chase", "đuổi dưới nước" },
    { "the fishing spot", "điểm câu cá" },
    { "halloween monsters", "quái vật Halloween" },
    { "shooting star", "sao băng" },
    { "butterfly bloom", "mùa bướm nở" },
    { "admin treadmill", "máy tập Admin" },
    { "offline cash", "tiền ngoại tuyến" },
    { "index rewards", "thưởng Chỉ mục" },
    { "lab eggs", "trứng Lab" },
    { "lab egg", "trứng Lab" },
    { "event egg", "trứng sự kiện" },
    { "minigame egg", "trứng Minigame" },
    { "is full", "đã đầy" },
    { "is closed", "đang đóng" },
    { "is open", "đang mở" },
    { "to open", "mở cửa" },
    { "Carrying ", "Đang mang " },
    { "Delivering ", "Đang giao " },
    { "Stealing ", "Đang cướp " },
    { "Teleporting ", "Đang dịch chuyển " },
    { "Tweening ", "Đang bay " },
    { "Moving ", "Đang di chuyển " },
    { "Walking ", "Đang đi bộ " },
    { "Running ", "Đang chạy " },
    { "Placing ", "Đang đặt " },
    { "Hatching ", "Đang ấp " },
    { "Mutating ", "Đang đột biến " },
    { "Selling ", "Đang bán " },
    { "Fusing ", "Đang dung hợp " },
    { "Catching ", "Đang bắt " },
    { "Chasing ", "Đang đuổi theo " },
    { "Waiting ", "Đang chờ " },
    { "Searching ", "Đang tìm " },
    { "Claiming ", "Đang nhận " },
    { "Upgrading ", "Đang nâng cấp " },
    { "Buying ", "Đang mua " },
    { "Trading ", "Đang đổi " },
    { "Crafting ", "Đang chế tạo " },
    { "Collecting ", "Đang thu thập " },
    { "Holding ", "Đang giữ " },
    { "Dropping ", "Đang thả " },
    { "Returning ", "Đang quay về " },
    { "Avoiding ", "Đang né " },
    { "Evading ", "Đang né " },
    { "Attacking ", "Đang đánh " },
    { "Hitting ", "Đang đánh " },
    { "Finding ", "Đang tìm " },
    { "Checking ", "Đang kiểm tra " },
    { "Skipping ", "Đang bỏ qua " },
    { " home", " về nhà" },
    { "targets", "mục tiêu" },
    { "target", "mục tiêu" },
    { "guards", "vệ sĩ" },
    { "guard", "vệ sĩ" }
}

local VX_DYNAMIC_PATTERNS = {
    { pat = "^Quest: Done | Fish caught: (%d+)$", rep = "Nhiệm vụ: Xong | Cá đã câu: %1" },
    { pat = "^Quest: (.-) | Fish caught: (%d+)$", rep = "Nhiệm vụ: %1 | Cá đã câu: %2" },
    { pat = "^QUICK BAR (%d+)$", rep = "THANH NHANH %1" },
    { pat = "Venyx(.-)(%d+) hours? ago", rep = "Venyx%1%2 giờ trước" },
    { pat = "Venyx(.-)(%d+) minutes? ago", rep = "Venyx%1%2 phút trước" },
    { pat = "Venyx(.-)(%d+) days? ago", rep = "Venyx%1%2 ngày trước" },
    { pat = "^ALL (%d+)$", rep = "TẤT CẢ %1" },
    { pat = "^READY (%d+)$", rep = "SẴN SÀNG %1" },
    { pat = "^GROWING (%d+)$", rep = "ĐANG LỚN %1" },
    { pat = "^IN BAG (%d+)$", rep = "TRONG TÚI %1" },
    { pat = "Pen (%d+/%d+) · (%d+) egg%(s%) ready to place", rep = "Chuồng %1 · %2 trứng sẵn sàng đặt" },
    { pat = "(%d+) egg%(s%) can be mutated", rep = "%1 trứng có thể đột biến" },
    { pat = "(%d+) pet%(s%) match", rep = "%1 pet khớp bộ lọc" },
    { pat = "(%d+) egg%(s%) match", rep = "%1 trứng khớp bộ lọc" },
    { pat = "(%d+) lab egg%(s%) match", rep = "%1 trứng Lab khớp bộ lọc" },
    { pat = "^(%d+) pets$", rep = "%1 thú cưng" },
    { pat = "(%d+ / %d+) players · (.+)", rep = "%1 người chơi · %2" },
    { pat = "^Mythic · 1 in ([%d%.]+)$", rep = "Thần Thoại · 1 trên %1" },
    { pat = "^Cosmic · 1 in ([%d%.]+)$", rep = "Vũ Trụ · 1 trên %1" },
    { pat = "^Secret · 1 in ([%d%.]+)$", rep = "Bí Ẩn · 1 trên %1" },
    { pat = "^Divine · 1 in ([%d%.]+)$", rep = "Thánh Thần · 1 trên %1" },
    { pat = "^Eternal · 1 in ([%d%.]+)$", rep = "Vĩnh Cửu · 1 trên %1" }
}

-- Bổ sung thêm (lấy từ video thực tế khi chuyển sang Venyx)
local VX_EXTRA = {
    ["Monsters"] = "Quái Vật",
    -- Bổ sung đợt Halloween / Cursed Island Wars (tra không phân biệt hoa/thường)
    ["Auto farm monsters"] = "Tự Động Cày Quái Vật",
    ["Only during Blood Moon"] = "Chỉ Trong Trăng Máu",
    ["Take Halloween Eggs From Holders"] = "Giật Trứng Halloween Từ Người Đang Cầm",
    ["Steal Missing Halloween Index"] = "Cướp Trứng Halloween Thiếu Trong Chỉ Mục",
    ["Place And Hatch Missing Index Eggs"] = "Đặt Và Ấp Trứng Thiếu Trong Chỉ Mục",
    ["Fishing Spot"] = "Điểm Câu Cá",
    ["Save Spot Here"] = "Lưu Điểm Tại Đây",
    ["Save"] = "Lưu",
    ["Done"] = "Xong",
    ["Waiting for a star"] = "Đang chờ sao băng",
    ["Waiting for bite"] = "Đang chờ cá cắn câu",
    ["Waiting for a bite"] = "Đang chờ cá cắn câu",
    ["Fighting Large monster"] = "Đang đánh quái vật lớn",
    ["Reeling in"] = "Đang kéo cá",
    ["Casting"] = "Đang quăng cần",
    ["Ghost Dog: underwater chase"] = "Chó Ma: đuổi dưới nước",
    ["Instant steal"] = "Cướp Siêu Tốc",
    ["Admin treadmill"] = "Máy Tập Admin",
    ["Auto play Cursed Island Wars"] = "Tự Động Chơi Cursed Island Wars",
    ["Island Wars target"] = "Mục Tiêu Island Wars",
    ["Enemies and base"] = "Kẻ Địch Và Căn Cứ",
    ["Ghost Dog and Fishing"] = "Chó Ma và Câu Cá",
    ["Train"] = "Tàu",
    ["Souls"] = "Linh Hồn",
    ["Not here"] = "Chưa đến",
    ["Quest"] = "Nhiệm Vụ",
    ["Fish caught"] = "Cá Đã Câu",
    ["Halloween eggs"] = "Trứng Halloween",
    ["Halloween rarities"] = "Độ Hiếm Trứng Halloween",
    ["Halloween Dimension"] = "Chiều Không Gian Halloween",
    ["Halloween Monsters"] = "Quái Vật Halloween",
    ["Ghost Dog & Fishing"] = "Chó Ma & Câu Cá",
    ["Phantom Express"] = "Tàu Tốc Hành Bóng Ma",
    ["Auto Phantom Express"] = "Tự Động Tàu Tốc Hành Bóng Ma",
    ["Auto Vacuum Ghouler Boss"] = "Tự Động Hút Boss Ghouler",
    ["Ghost Target"] = "Mục Tiêu Ma",
    ["Rarest First"] = "Hiếm Nhất Trước",
    ["Most Tokens"] = "Nhiều Token Nhất",
    ["Walk Speed"] = "Tốc Độ Đi Bộ",
    ["Auto Trade Souls"] = "Tự Động Đổi Linh Hồn",
    ["Auto Pumpkin Moon"] = "Tự Động Trăng Bí Ngô",
    ["Auto Buy Halloween Dimension Egg"] = "Tự Động Mua Trứng Chiều Không Gian Halloween",
    ["Auto Kill Monsters"] = "Tự Động Diệt Quái Vật",
    ["Monsters To Kill"] = "Quái Vật Cần Diệt",
    ["Monster Order"] = "Thứ Tự Quái Vật",
    ["Use Weapons"] = "Dùng Vũ Khí",
    ["Auto Ghost Dog Quest"] = "Tự Động Nhiệm Vụ Chó Ma",
    ["Auto Fishing"] = "Tự Động Câu Cá",
    ["Cast Luck"] = "May Mắn Khi Quăng Cần",
    ["Auto Steal Halloween Eggs"] = "Tự Động Cướp Trứng Halloween",
    ["Instant Steal Halloween Eggs"] = "Cướp Siêu Tốc Trứng Halloween",
    ["Steal Speed"] = "Tốc Độ Cướp",
    ["Halloween Eggs To Steal"] = "Trứng Halloween Cần Cướp",
    ["Halloween Egg Rarities"] = "Độ Hiếm Trứng Halloween",
    ["Min Value"] = "Giá Trị Tối Thiểu",
    ["Nothing to do"] = "Không có việc để làm",
    ["VENYX"] = VENYX_TITLE,
    ["Later"] = "Để sau",
    ["Apply"] = "Áp dụng",
    ["Chilli config found"] = "Đã tìm thấy cấu hình Chilli",
    ["From Chilli"] = "Từ Chilli",
    ["Switch to Chilli Hub V4"] = "Chuyển sang Chilli Hub V4",
    ["Cancel"] = "Hủy",
    ["Switch"] = "Chuyển",
    ["Try now"] = "Thử ngay",
    ["Try Now"] = "Thử ngay",
    ["Smoother, faster and more ways to steal."] = "Mượt hơn, nhanh hơn và nhiều cách cướp hơn.",
    ["Smoother & faster"] = "Mượt hơn & nhanh hơn",
    ["Less lag, quick to load."] = "Ít lag hơn, tải nhanh.",
    ["More steal methods"] = "Thêm nhiều cách cướp",
    ["Teleport, Fast tween and more."] = "Dịch chuyển, Tween nhanh và hơn thế nữa.",
    ["Steal from players"] = "Cướp từ người chơi",
    ["Hits whoever takes your egg."] = "Đánh trả bất kỳ ai lấy trứng của bạn.",
    ["Easy setup"] = "Cài đặt dễ dàng",
    ["Bring your Chilli config over."] = "Mang cấu hình Chilli của bạn sang.",
    ["Venyx closes completely and Chilli Hub V4 loads. You stay in this server."] = "Venyx sẽ đóng hoàn toàn và Chilli Hub V4 sẽ tải. Bạn vẫn ở lại server này.",
    ["Copy invite"] = "Chép link mời",
    ["Copy Invite"] = "Chép link mời",
    ["Fixed lag back with the Tween delivery method"] = "Đã sửa lỗi lag giật lùi ở phương thức giao trứng Tween",
    ["Just now"] = "Vừa xong",
    ["RAINBOW"] = "CẦU VỒNG",
    ["GOLDEN"] = "VÀNG",
    ["SILVER"] = "BẠC",
    ["Stolen"] = "Đã cướp",
    ["Quick Bar"] = "Thanh phím tắt nhanh",
    ["Quick bar"] = "Thanh phím tắt nhanh",
    ["QUICK BAR"] = "THANH PHÍM TẮT NHANH",
    ["Speed Boost"] = "Tăng Tốc Chạy",
    ["Boost Speed"] = "Tốc Độ Tăng Tốc",
    ["Chilli Hub settings applied"] = "Đã áp dụng cấu hình Chilli Hub"
}
for en, vi in pairs(VX_EXTRA) do
    if VX_EXACT_VI[en] == nil then VX_EXACT_VI[en] = vi end
end

for _, p in ipairs({
    { pat = "^Welcome to Venyx ([%d%.]+)! Join our Discord for updates and support$",
      rep = "Chào mừng tới Venyx %1! Tham gia Discord để cập nhật và nhận hỗ trợ" },
    { pat = "^QUICK BAR (%d+)$", rep = "THANH PHÍM TẮT %1" },
    { pat = "^[Ss]tealing now: (.+)$", rep = "Đang cướp: %1" },
    { pat = "^(x[%d%.]+) Perfect$", rep = "%1 Hoàn Hảo" },
    { pat = "^[Ff]ind (%d+) memories$", rep = "Tìm %1 ký ức" },
    { pat = "^(x[%d%.]+) Fastest$", rep = "%1 Nhanh Nhất" },
    { pat = "^[Hh]opping to (.+)$", rep = "Đang chuyển tới %1" },
    { pat = "^[Hh]opping to a new server$", rep = "Đang đổi sang server mới" },
    { pat = "^[Pp]lacing eggs? (%d+/%d+)$", rep = "Đang đặt trứng %1" },
    { pat = "^[Tt]eleporting to egg$", rep = "Đang dịch chuyển tới trứng" },
    { pat = "^[Cc]arrying egg to base$", rep = "Đang mang trứng về căn cứ" },
    { pat = "^(.-) ?config found$", rep = "Đã tìm thấy cấu hình %1" },
    { pat = "^Apply your (.-) ?settings to Venyx now%? You can also load them later from (.-) as \"From Chilli\"%.$",
      rep = "Áp dụng cài đặt %1 cho Venyx ngay bây giờ? Bạn cũng có thể tải lại sau trong %2 với tên \"Từ Chilli\"." },
    { pat = "^Switch to (.+)$", rep = "Chuyển sang %1" },
    { pat = "^Venyx closes completely and (.-) ?loads%. You stay in this server%.$", rep = "Venyx sẽ đóng hoàn toàn và %1 sẽ tải. Bạn vẫn ở lại server này." },
    { pat = "^Quick [Bb]ar (%d+)$", rep = "Thanh phím tắt %1" },
    { pat = "^(%d+) seconds? ago$", rep = "%1 giây trước" },
    { pat = "^(%d+) minutes? ago$", rep = "%1 phút trước" },
    { pat = "^(%d+) hours? ago$", rep = "%1 giờ trước" },
    { pat = "^(%d+) days? ago$", rep = "%1 ngày trước" }
}) do
    table.insert(VX_DYNAMIC_PATTERNS, 1, p)
end

local function vxApplySmartPhrases(str)
    local out = str
    for _, pair in ipairs(VX_SMART_PHRASES) do
        if out:find(pair[1], 1, true) then
            out = replaceAll(out, pair[1], pair[2])
        end
    end
    return out
end

-- Trả về bản dịch, hoặc nil nếu không có trong từ điển Venyx
-- Chuyển chữ Việt sang IN HOA (string.upper của Roblox chỉ xử lý chữ không dấu)
local VI_UPPER = {}
do
    local lower = "àáảãạăằắẳẵặâầấẩẫậèéẻẽẹêềếểễệìíỉĩịòóỏõọôồốổỗộơờớởỡợùúủũụưừứửữựỳýỷỹỵđ"
    local upper = "ÀÁẢÃẠĂẰẮẲẴẶÂẦẤẨẪẬÈÉẺẼẸÊỀẾỂỄỆÌÍỈĨỊÒÓỎÕỌÔỒỐỔỖỘƠỜỚỞỠỢÙÚỦŨỤƯỪỨỬỮỰỲÝỶỸỴĐ"
    local li, ui = {}, {}
    for ch in lower:gmatch(utf8.charpattern) do li[#li + 1] = ch end
    for ch in upper:gmatch(utf8.charpattern) do ui[#ui + 1] = ch end
    for k = 1, #li do VI_UPPER[li[k]] = ui[k] end
end
local function viUpper(str)
    return (str:gsub(utf8.charpattern, function(ch)
        return VI_UPPER[ch] or ch:upper()
    end))
end

-- Tra cứu không phân biệt hoa/thường: "Auto steal eggs" = "Auto Steal Eggs"; "PHANTOM EXPRESS" -> in hoa
local VX_LOWER = {}
for en, vi in pairs(VX_EXACT_VI) do
    -- Bỏ các khóa viết HOA toàn bộ (vd "VENYX", "NEW"): chúng đã được tra đúng chữ ở bước trước,
    -- không được dùng cho chữ viết thường/hỗn hợp (nếu không, nút "Venyx" sẽ bị đổi thành tiêu đề cửa sổ)
    if en ~= en:upper() then
        local key = en:lower()
        if VX_LOWER[key] == nil then VX_LOWER[key] = vi end
    end
end

-- Phần đuôi hay gặp của "Waiting: ..." (khóa viết thường)
local VX_WAIT_TAIL = {
    ["steal"] = "cướp",
    ["nothing to do"] = "không có việc để làm",
    ["halloween monsters"] = "quái vật Halloween",
    ["halloween fishing"] = "câu cá Halloween",
}

local function translateVenyx(raw)
    local normalized = (raw:match("^%s*(.-)%s*$") or raw):gsub("%s+", " ")

    if VX_EXACT_VI[normalized] then
        return VX_EXACT_VI[normalized]
    end

    do
        local viLow = VX_LOWER[normalized:lower()]
        if viLow then
            local isCaps = normalized == normalized:upper() and normalized:find("%a%a") ~= nil
            return isCaps and viUpper(viLow) or viLow
        end
    end

    -- Chuỗi kết thúc bằng "..." (ví dụ "Search...")
    local baseBeforeDots = normalized:match("^(.+)%.%.%.$")
    if baseBeforeDots then
        baseBeforeDots = baseBeforeDots:match("^%s*(.-)%s*$") or baseBeforeDots
        if VX_EXACT_VI[baseBeforeDots] then
            return VX_EXACT_VI[baseBeforeDots] .. "..."
        end
    end

    -- Chuỗi có ký hiệu/icon phía trước (ví dụ "+ Add")
    local prefix, wordPart = normalized:match("^([^%w%s]+%s*)(.+)$")
    if prefix and wordPart and VX_EXACT_VI[wordPart] then
        return prefix .. VX_EXACT_VI[wordPart]
    end

    -- "Waiting: <việc>" -> "Đang chờ: <việc đã dịch>" (dịch phần đuôi bằng từ điển rồi cụm từ thông minh)
    do
        local tail = normalized:match("^[Ww]aiting: (.+)$")
        if tail then
            local low = tail:lower()
            local t = VX_WAIT_TAIL[low] or VX_EXACT_VI[tail] or VX_LOWER[low] or vxApplySmartPhrases(tail)
            return "Đang chờ: " .. t
        end
    end

    for _, item in ipairs(VX_DYNAMIC_PATTERNS) do
        if normalized:find(item.pat) then
            return (normalized:gsub(item.pat, item.rep))
        end
    end

    for _, item in ipairs(VX_STATUS_PATTERNS) do
        if normalized:find(item.pat) then
            local out = normalized:gsub(item.pat, item.rep)
            return vxApplySmartPhrases(out)
        end
    end

    return nil
end

-- Loại GUI của một phần tử: "hub" (menu Chilli gốc), "venyx" hoặc "other" (bảng phụ, thông báo...)
-- Bộ nhớ đệm theo từng phần tử (bảng yếu, tự dọn khi phần tử bị huỷ) -> tránh leo cây GUI và ghi thuộc tính liên tục
local ST = {
    gui = setmetatable({}, {__mode = "k"}),      -- [inst] = ScreenGui chứa nó
    skip = setmetatable({}, {__mode = "k"}),     -- [inst] = true nếu thuộc Island / huy hiệu (không dịch)
    busy = setmetatable({}, {__mode = "k"}),     -- [inst] = đang tự đổi chữ
    lastText = setmetatable({}, {__mode = "k"}), -- [inst] = chữ đã dịch gần nhất
    lastPh = setmetatable({}, {__mode = "k"}),
    hooked = setmetatable({}, {__mode = "k"}),
    orig = setmetatable({}, {__mode = "k"}),   -- chữ gốc (tiếng Anh) của từng nhãn
    origPh = setmetatable({}, {__mode = "k"}),
    learned = setmetatable({}, {__mode = "k"}),  -- nhãn trạng thái của menu Chilli đã nhận diện (về sau lấy mọi nội dung của nhãn này)
    conn = setmetatable({}, {__mode = "k"}),   -- [inst] = {kết nối Text, kết nối Placeholder} để ngắt khi phần tử bị gỡ
    ws = setmetatable({}, {__mode = "k"}),     -- đầu cửa sổ 1 giây đếm số lần đổi chữ
    wc = setmetatable({}, {__mode = "k"}),     -- số lần đổi chữ trong cửa sổ
    mute = setmetatable({}, {__mode = "k"}),   -- [inst] = thời điểm hết "tạm dừng dịch" (nhãn bị game ghi liên tục)
}
local STAT = {writes = 0, mutes = 0}   -- số liệu cho nhật ký chẩn đoán
local function setTextRaw(i, t) i.Text = t end   -- hàm tĩnh: không tạo closure mỗi lần ghi

local function guiOf(inst)
    local gui = ST.gui[inst]
    if gui and gui.Parent then return gui end
    gui = inst:FindFirstAncestorOfClass("ScreenGui")
    ST.gui[inst] = gui
    return gui
end

local function guiKindOf(inst)
    local gui = guiOf(inst)
    return gui and gui:GetAttribute("ChilliKind") or nil
end

local function isSkipped(inst)
    local v = ST.skip[inst]
    if v == nil then
        v = (inst:FindFirstAncestor("Chilli_Dynamic_Island") or inst:FindFirstAncestor("Sparkling_New_Badge")) and true or false
        ST.skip[inst] = v
    end
    return v
end

local SortedVI = {}
for en, vi in pairs(MAP_VI) do table.insert(SortedVI, {en = en, out = vi, len = #en}) end
table.sort(SortedVI, function(a, b) return a.len > b.len end)

local FastCacheCount = 0
local function newFC() return {VX = {VI = {}, EN = {}}, HB = {VI = {}, EN = {}}} end
local FC = newFC()

-- venyxFirst = true: ưu tiên từ điển Venyx (GUI Venyx / bảng phụ); false: ưu tiên từ điển V4 (menu Chilli gốc)
local function translateText(raw, venyxFirst)
    if raw == nil or raw == "" or not raw:find("%a") then return raw end

    -- Cache 2 tầng (không nối chuỗi mỗi lần gọi -> ít rác cho GC trên máy yếu)
    local FastCache = (FC[venyxFirst and "VX" or "HB"] or FC.HB)[currentLanguage] or FC.HB.VI
    local cacheKey = raw
    local hit = FastCache[cacheKey]
    if hit then return hit end

    -- Văn bản số/đồng hồ đổi liên tục có thể làm cache phình to -> dọn định kỳ
    FastCacheCount = FastCacheCount + 1
    if FastCacheCount > 4000 then
        FC = newFC()
        FastCache = (FC[venyxFirst and "VX" or "HB"] or FC.HB)[currentLanguage] or FC.HB.VI
        FastCacheCount = 0
    end

    if raw:find("Chilli Hub", 1, true) then
        local fixedBrand = raw:gsub("Chilli Hub()(%s*V?[%d%.]*)()", function(_, ver, pos)
            local num = ver:match("^%s*V(%d[%d%.]*)")
            if not num then
                -- Không có số phiên bản: chỉ coi là tên hub khi đứng một mình; "Chilli Hub Venyx"... giữ nguyên
                if raw:match("^%s*Chilli Hub%s*$") then return TEXT_BRAND end
                return nil
            end
            -- giữ dấu chấm cuối câu, chèn khoảng trắng nếu chữ liền ngay sau tên (vd "V4config" -> "V4 config")
            return TEXT_BRAND .. (num:sub(-1) == "." and "." or "") .. (raw:sub(pos, pos):match("%a") and " " or "")
        end)
        if fixedBrand:match("^%s*" .. TEXT_BRAND:gsub("%p", "%%%0") .. "%s*$") then
            -- Tiêu đề thuần của hub gốc -> tên mới; ở Venyx/bảng phụ giữ "Chilli Hub V4"
            local shown = venyxFirst and fixedBrand or BRAND
            FastCache[cacheKey] = shown
            return shown
        end
        raw = fixedBrand
    end

    if currentLanguage == "EN" then
        FastCache[cacheKey] = raw
        return raw
    end

    if venyxFirst then
        local vx = translateVenyx(raw)
        if vx then
            FastCache[cacheKey] = vx
            return vx
        end
    end

    local trimmed = raw:match("^%s*(.-)%s*$") or raw
    if EXACT_MATCH_VI[trimmed] then
        -- FIX: dùng replaceAll (plain) thay vì gsub (pattern) để chuỗi như "3 - Rare" khớp đúng
        local res = replaceAll(raw, trimmed, EXACT_MATCH_VI[trimmed])
        FastCache[cacheKey] = res
        return res
    end

    if not venyxFirst then
        local vx = translateVenyx(raw)
        if vx then
            FastCache[cacheKey] = vx
            return vx
        end
    end

    local result = raw
    local matched = false

    for _, item in ipairs(DYNAMIC_PATTERNS) do
        local n
        result, n = result:gsub(item.pattern, function(...)
            return item.format(currentLanguage, ...)
        end)
        if n > 0 then matched = true end
    end

    for _, item in ipairs(SortedVI) do
        if result:find(item.en, 1, true) then
            result = replaceAll(result, item.en, item.out)
            matched = true
        end
    end

    FastCache[cacheKey] = matched and result or raw
    return FastCache[cacheKey]
end

-- Tập phần tử đang theo dõi: khoá yếu -> phần tử bị xoá được trình dọn rác thu hồi ngay, không giữ RAM
local TrackedElements = setmetatable({}, {__mode = "k"})

local function normStatus(t)
    t = tostring(t or ""):gsub("●", ""):gsub("•", ""):gsub("·", ""):gsub("<[^>]->", "")
    -- string.lower không hạ "Đ" -> "đ" (chữ Việt nhiều byte); không xử lý thì "Đang ..." không bao giờ khớp tiền tố "đang "
    return ((t:match("^%s*(.-)%s*$") or ""):lower():gsub("Đ", "đ"))
end

local function isIdleText(t)
    local n = normStatus(t)
    return n == "idle" or n == "đang rảnh" or n:find("^idle%f[%W]") ~= nil or n:find("rảnh", 1, true) ~= nil
end

local ACTION_PREFIXES = {
    "đang ", "halloween: đang", "chó ma:", "ghost dog:", "fighting", "stealing", "hopping", "waiting", "selling", "placing", "fusing", "collecting",
    "claiming", "teleporting", "buying", "mutating", "hatching", "crafting", "trading",
}

local function cleanStatus(t)
    t = tostring(t or ""):gsub("<[^>]->", ""):gsub("●", ""):gsub("•", "")
    return t:match("^%s*(.-)%s*$") or ""
end

local function isActionText(raw)
    local n = normStatus(raw)
    if #n < 6 or #n > 70 then return false end
    if isIdleText(n) then return false end
    if n:find("trước", 1, true) or n:find(" ago", 1, true) then return false end
    for _, pre in ipairs(ACTION_PREFIXES) do
        if n:sub(1, #pre) == pre then return true end
    end
    return false
end

local function reallyVisible(d)
    local cur = d
    while cur and cur ~= game do
        if cur:IsA("GuiObject") and not cur.Visible then return false end
        if cur:IsA("ScreenGui") and not cur.Enabled then return false end
        cur = cur.Parent
    end
    return d.TextTransparency < 0.95
end


-- Danh sách nhãn có vẻ là "trạng thái đang làm" (cập nhật theo sự kiện, không phải quét cả cây GUI)
local StatusCandidates = setmetatable({}, {__mode = "k"})
local function noteStatusCandidate(inst)
    if not inst:IsA("TextLabel") then return end
    local t = inst.Text
    if #t < 6 or #t > 90 then StatusCandidates[inst] = nil return end
    local isAct = isActionText(t)
    -- Menu Chilli dùng MỘT nhãn cố định cho trạng thái, chữ đổi liên tục. Khi nhãn đó đã từng hiện một trạng thái nhận ra được,
    -- ghi nhớ nó: các trạng thái mới chưa có trong danh sách tiền tố ("Fighting...", "Reeling in"...) vẫn lên Island.
    if isAct and guiKindOf(inst) == "hub" then ST.learned[inst] = true end
    StatusCandidates[inst] = (isAct or ST.learned[inst]) or nil
end


local function applyTranslation(inst)
    if not (inst:IsA("TextLabel") or inst:IsA("TextButton") or inst:IsA("TextBox")) then return end
    if isSkipped(inst) then return end
    if ST.busy[inst] then return end

    -- Menu Chilli gốc ưu tiên từ điển V4; GUI Venyx và các bảng phụ ưu tiên từ điển Venyx
    local venyxFirst = (guiKindOf(inst) ~= "hub")

    if inst:IsA("TextBox") then
        -- Dịch chữ gợi ý (placeholder), KHÔNG dịch nội dung người dùng đang gõ
        local origPh = ST.origPh[inst]
        if not origPh and inst.PlaceholderText ~= "" then
            origPh = inst.PlaceholderText
            ST.origPh[inst] = origPh
        end
        if origPh then
            local mappedPh = translateText(origPh, venyxFirst)
            if inst.PlaceholderText ~= mappedPh then
                ST.lastPh[inst] = mappedPh
                pcall(function() inst.PlaceholderText = mappedPh end)
            end
        end

        -- Ô hiển thị giá trị "Off"/"None" dạng TextBox
        local boxTxt = (inst.Text or ""):match("^%s*(.-)%s*$") or ""
        if not inst:IsFocused() and (boxTxt == "Off" or boxTxt == "None" or boxTxt == "Tắt" or boxTxt == "Không có") then
            local origBox = (boxTxt == "Tắt") and "Off" or ((boxTxt == "Không có") and "None" or boxTxt)
            local mappedBox = translateText(origBox, venyxFirst)
            if inst.Text ~= mappedBox then
                ST.busy[inst] = true
                ST.lastText[inst] = mappedBox
                pcall(function() inst.Text = mappedBox end)
                task.defer(function() ST.busy[inst] = nil end)
            end
        end
        return
    end

    local original = ST.orig[inst]
    if not original then
        original = inst.Text
        ST.orig[inst] = original
    end

    local mappedText = translateText(original, venyxFirst)
    if mappedText == BRAND and not venyxFirst then
        -- tiêu đề của widget nhỏ (không phải header chính) giữ tên thường "Chilli Hub V6"
        local hf = inst:FindFirstAncestorOfClass("Frame")
        if hf and hf:GetAttribute("__HdrDecided") and headerState(hf, inst) == "widget" then
            mappedText = TEXT_BRAND
        end
    end
    if inst.Text ~= mappedText then
        -- Không cần cờ busy: tiếng vọng của chính lần ghi này bị chặn bởi so sánh với lastText
        ST.lastText[inst] = mappedText
        STAT.writes = STAT.writes + 1
        pcall(setTextRaw, inst, mappedText)
    end
end

-- ==================== 4. ĐỔI MÀU & HUY HIỆU '✨ NEW' ====================
local COLOR_FACE_TOP     = Color3.fromRGB(255, 130, 100)
local COLOR_FACE_BOTTOM  = Color3.fromRGB(220, 70, 60)
local COLOR_BEVEL_SHADOW = Color3.fromRGB(150, 35, 35)

local TARGET_BUTTON_KEYWORDS = {
    ["cày cuốc"] = true, ["farm"] = true,
    ["người chơi"] = true, ["player"] = true,
    ["dự đoán"] = true, ["predictor"] = true,
    ["tiến trình"] = true, ["progress"] = true,
    ["máy chủ"] = true, ["server"] = true,
    ["khác"] = true, ["misc"] = true,
    ["tự đổi máy chủ"] = true, ["tự đổi server"] = true, ["auto hop"] = true,
    ["admin abuse"] = true, ["menu admin (abuse)"] = true,
    ["discord"] = true,
    ["phím tắt & key"] = true, ["quick & keys"] = true,
    ["cài đặt"] = true, ["settings"] = true,
    ["cấu hình"] = true, ["config"] = true
}

local function attachSparklingNewBadge(headerFrame)
    if not headerFrame then return end
    -- FIX: nếu huy hiệu đã tồn tại thì giữ nguyên, không tạo lại (trước đây bị tạo lại mỗi 0.25s)
    if headerFrame:FindFirstChild("Sparkling_New_Badge") then return end

    -- Huy hiệu là MỘT TextLabel duy nhất (không Frame con, không UIStroke/UIGradient)
    -- để hub không thể vẽ vành/cục đen quanh nó. Nền vàng sáng + chữ đỏ đậm để nổi bật là bản mới.
    local Badge = Instance.new("TextLabel")
    Badge.Name = "Sparkling_New_Badge"
    Badge.Size = UDim2.new(0, 78, 0, 18)
    Badge.AnchorPoint = Vector2.new(1, 0.5)
    Badge.Position = UDim2.new(1, -44, 0.5, 0)
    Badge.BackgroundColor3 = Color3.fromRGB(255, 205, 50)
    Badge.BackgroundTransparency = 0
    Badge.BorderSizePixel = 0
    Badge.Text = "✨ VIỆT HÓA " .. VERSION
    Badge.Font = Enum.Font.GothamBlack
    Badge.TextSize = 9
    Badge.TextWrapped = false
    Badge.TextTruncate = Enum.TextTruncate.None
    Badge.TextColor3 = Color3.fromRGB(125, 18, 18)
    Badge.ZIndex = 50
    Badge.Parent = headerFrame

    local BadgeCorner = Instance.new("UICorner")
    BadgeCorner.CornerRadius = UDim.new(0, 6)
    BadgeCorner.Parent = Badge

    -- Nhấp nháy nhẹ giữa vàng và cam (4 lần/giây, rất nhẹ cho máy yếu)
    task.spawn(function()
        local on = false
        while Badge and Badge.Parent and alive() do
            on = not on
            Badge.BackgroundColor3 = on and Color3.fromRGB(255, 232, 90) or Color3.fromRGB(255, 170, 40)
            task.wait(0.5)
        end
    end)
end

local function recolorSingleButton(btnContainer, labelObj)
    if not btnContainer then return end

    local grad = btnContainer:FindFirstChildOfClass("UIGradient")
    if not grad then
        grad = Instance.new("UIGradient")
        grad.Rotation = 90
        grad.Parent = btnContainer
    end
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, COLOR_FACE_TOP),
        ColorSequenceKeypoint.new(1, COLOR_FACE_BOTTOM)
    })
    btnContainer.BackgroundColor3 = COLOR_FACE_BOTTOM

    if btnContainer.Parent and btnContainer.Parent:IsA("Frame") and btnContainer.Parent ~= btnContainer then
        local p = btnContainer.Parent
        if p.BackgroundColor3.R > 0.4 and p.BackgroundColor3.G < 0.35 then
            p.BackgroundColor3 = COLOR_BEVEL_SHADOW
        end
    end

    if labelObj and (labelObj:IsA("TextLabel") or labelObj:IsA("TextButton")) then
        labelObj.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
end

local function recolorHeaderBar(headerFrame, titleObj)
    if not headerFrame then return end
    local grad = headerFrame:FindFirstChildOfClass("UIGradient")
    if not grad then
        grad = Instance.new("UIGradient")
        grad.Rotation = 90
        grad.Parent = headerFrame
    end
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, COLOR_FACE_TOP),
        ColorSequenceKeypoint.new(1, COLOR_FACE_BOTTOM)
    })
    headerFrame.BackgroundColor3 = COLOR_FACE_BOTTOM

    local function finishHeader()
        if not (headerFrame.Parent and titleObj and titleObj.Parent) then return end
        if headerState(headerFrame, titleObj) == "main" then
            if titleObj:IsA("TextLabel") or titleObj:IsA("TextButton") then
                titleObj.TextColor3 = Color3.fromRGB(255, 255, 255)
                if titleObj.Text ~= BRAND then titleObj.Text = BRAND end
            end
            attachSparklingNewBadge(headerFrame)
        else
            -- widget nhỏ: giữ tên thường, không huy hiệu
            if titleObj.Text ~= TEXT_BRAND then titleObj.Text = TEXT_BRAND end
            local old = headerFrame:FindFirstChild("Sparkling_New_Badge")
            if old then old:Destroy() end
        end
    end

    if headerFrame:GetAttribute("__HdrDecided") then
        finishHeader()
    elseif not headerFrame:GetAttribute("__HdrPending") then
        headerFrame:SetAttribute("__HdrPending", true)
        task.delay(0.4, function()
            headerFrame:SetAttribute("__HdrDecided", true)
            finishHeader()
        end)
    end

    for _, item in ipairs(headerFrame:GetDescendants()) do
        if item:IsA("TextButton") or item:IsA("ImageButton") then
            item.BackgroundColor3 = COLOR_FACE_BOTTOM
            local xGrad = item:FindFirstChildOfClass("UIGradient")
            if xGrad then
                xGrad.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, COLOR_FACE_TOP),
                    ColorSequenceKeypoint.new(1, COLOR_FACE_BOTTOM)
                })
            end
            if item:IsA("TextButton") then
                item.TextColor3 = Color3.fromRGB(255, 255, 255)
            end
        end
    end
end

local function inspectAndApplySoftBlue(inst)
    if not (inst:IsA("TextLabel") or inst:IsA("TextButton")) then return end
    if isSkipped(inst) then return end
    -- Chỉ đổi màu / gắn huy hiệu trong menu Chilli gốc, không đụng vào giao diện Venyx hay bảng phụ
    if guiKindOf(inst) ~= "hub" then return end

    local textRaw = inst.Text:lower():match("^%s*(.-)%s*$") or ""
    if looksLikeHubTitle(textRaw) then
        local headerFrame = inst:FindFirstAncestorOfClass("Frame")
        if headerFrame then recolorHeaderBar(headerFrame, inst) end
        return
    end

    if TARGET_BUTTON_KEYWORDS[textRaw] then
        local btnTarget = inst:IsA("TextButton") and inst or inst:FindFirstAncestorOfClass("TextButton") or inst:FindFirstAncestorOfClass("Frame")
        if btnTarget then recolorSingleButton(btnTarget, inst) end
        return
    end
end

local function hookElement(inst)
    if not (inst:IsA("TextLabel") or inst:IsA("TextButton") or inst:IsA("TextBox")) then return end
    -- Luôn nằm trong tập theo dõi (kể cả khi bị tháo cha rồi gắn lại) để đổi ngôn ngữ vẫn cập nhật được
    TrackedElements[inst] = true
    if ST.hooked[inst] then return end
    ST.hooked[inst] = true

    -- hookElement luôn được gọi từ hàng đợi theo lô -> dịch trực tiếp, không tạo thêm task
    applyTranslation(inst)
    inspectAndApplySoftBlue(inst)
    noteStatusCandidate(inst)

    local cText, cPh
    cText = inst:GetPropertyChangedSignal("Text"):Connect(function()
        if not alive() or ST.busy[inst] then return end
        local current = inst.Text
        if current == ST.lastText[inst] then
            noteStatusCandidate(inst)
            return
        end
        -- Nhãn bị game ghi đè liên tục (đồng hồ, bộ đếm...): >25 lần/giây thì tạm ngừng dịch 8 giây
        -- để không "giằng co" với game (mỗi lần ghi là một lần dựng lại chữ -> tốn máy yếu)
        local now = os.clock()
        local muteUntil = ST.mute[inst]
        if muteUntil then
            if now < muteUntil then return end
            ST.mute[inst] = nil
        end
        local ws = ST.ws[inst]
        if not ws or now - ws > 1 then
            ST.ws[inst] = now
            ST.wc[inst] = 1
        else
            local c = (ST.wc[inst] or 0) + 1
            ST.wc[inst] = c
            if c > 25 then
                ST.mute[inst] = now + 8
                ST.ws[inst] = nil
                STAT.mutes = STAT.mutes + 1
                return
            end
        end
        ST.orig[inst] = current
        applyTranslation(inst)
        inspectAndApplySoftBlue(inst)
        noteStatusCandidate(inst)
    end)

    if inst:IsA("TextBox") then
        cPh = inst:GetPropertyChangedSignal("PlaceholderText"):Connect(function()
            local current = inst.PlaceholderText
            if current == ST.lastPh[inst] then return end
            ST.origPh[inst] = current
            applyTranslation(inst)
        end)
    end
    ST.conn[inst] = {cText, cPh}
end

-- Ngắt kết nối của phần tử đã bị gỡ khỏi cây (Parent = nil): tránh giữ phần tử + hàm xử lý trong RAM
local function unhookElement(el)
    local c = ST.conn[el]
    if c then
        for i = 1, 2 do
            if c[i] then pcall(c[i].Disconnect, c[i]) end
        end
        ST.conn[el] = nil
    end
    ST.hooked[el] = nil
    TrackedElements[el] = nil
end

local function updateAllActive()
    for el in pairs(TrackedElements) do
        if el.Parent then
            applyTranslation(el)
        else
            unhookElement(el)
        end
    end
end

-- ==================== 5. CLICK AN TOÀN ====================
local function stealthClick(inst)
    if not inst then return end
    local targets = {inst}
    if inst.Parent and inst.Parent:IsA("GuiObject") then table.insert(targets, inst.Parent) end
    local btnAncestor = inst:FindFirstAncestorWhichIsA("GuiButton")
    if btnAncestor then table.insert(targets, btnAncestor) end

    local seenTarget = {}   -- cùng một đối tượng không được bấm 2 lần (nút bật/tắt sẽ bị đóng lại)
    for _, obj in ipairs(targets) do
      if not seenTarget[obj] then
        seenTarget[obj] = true
        pcall(function()
            if firesignal then
                firesignal(obj.MouseButton1Click)
                firesignal(obj.Activated)
            end
        end)
        pcall(function()
            if getconnections then
                for _, c in ipairs(getconnections(obj.MouseButton1Click)) do c:Fire() end
                for _, c in ipairs(getconnections(obj.Activated)) do c:Fire() end
            end
        end)
      end
    end
end

-- ==================== 6. ĐỘNG CƠ NẠP CONFIG ====================
local isConfigInjecting = false

-- mode: "on" (nạp cấu hình bật) hoặc "off" (nạp cấu hình đã tắt hết công tắc)
local function executeAutoConfig(statusCallback, mode)
    if isConfigInjecting then return end
    if SELECTED_HUB == "venyx" then
        -- Cấu hình tự động chỉ dành cho Chilli Hub; Config Venyx sẽ được tích hợp sau
        task.spawn(function()
            statusCallback("🚧 Config Venyx: sắp có", Color3.fromRGB(255, 210, 90))
            task.wait(2)
            if updateIslandContentLanguage then updateIslandContentLanguage(currentLanguage) end
        end)
        return
    end

    local isOff = (mode == "off")
    local configJson
    if isOff then configJson = buildOffConfig() else configJson = RAW_CONFIG_JSON end
    local profileName = isOff and OFF_PROFILE or ON_PROFILE

    if not configJson then
        task.spawn(function()
            statusCallback("❌ Lỗi tạo cấu hình", Color3.fromRGB(255, 90, 90))
            task.wait(2)
            if updateIslandContentLanguage then updateIslandContentLanguage(currentLanguage) end
        end)
        return
    end

    isConfigInjecting = true

    task.spawn(function()
        statusCallback(isOff and "⏳ Đang tắt..." or "⏳ Đang nạp...", Color3.fromRGB(255, 210, 90))

        local prevLang = currentLanguage
        local okRun, errRun = pcall(function()
        if switchGlobalLanguage then
            switchGlobalLanguage("EN")
            task.wait(0.3)
        end

        local roots = {}
        pcall(function() if gethui then table.insert(roots, gethui()) end end)
        table.insert(roots, CoreGui)
        do
            local pg = LocalPlayer:FindFirstChild("PlayerGui")
            if pg then table.insert(roots, pg) end
        end
        local chilliGui = nil

        for _, root in ipairs(roots) do
            if root then
                for _, g in ipairs(root:GetChildren()) do
                    if g:IsA("ScreenGui") and g.Name ~= "Chilli_Dynamic_Island" and g:GetAttribute("ChilliKind") ~= "venyx" then
                        for _, d in ipairs(g:GetDescendants()) do
                            if (d:IsA("TextLabel") or d:IsA("TextButton")) and looksLikeHubTitle(d.Text) then
                                chilliGui = g; break
                            end
                        end
                    end
                    if chilliGui then break end
                end
            end
            if chilliGui then break end
        end

        if not chilliGui then
            statusCallback("❌ Ko thấy Hub", Color3.fromRGB(255, 90, 90))
            task.wait(2)
            if updateIslandContentLanguage then updateIslandContentLanguage(currentLanguage) end
            isConfigInjecting = false; return
        end

        -- 1. Mở Tab Config
        local configTabElement = nil
        for _, d in ipairs(chilliGui:GetDescendants()) do
            if (d:IsA("TextLabel") or d:IsA("TextButton")) and d.Visible then
                local t = d.Text:lower():match("^%s*(.-)%s*$") or ""
                if t == "config" or t == "cấu hình" then
                    configTabElement = d; break
                end
            end
        end

        if configTabElement then
            stealthClick(configTabElement)
            task.wait(0.35)
        end

        -- 2. Tìm ô TextBox Import
        local importTextBox = nil
        for _, d in ipairs(chilliGui:GetDescendants()) do
            if d:IsA("TextBox") then
                local ph = (d.PlaceholderText or ""):lower()
                if ph:find("exported config", 1, true) then
                    importTextBox = d; break
                end
            end
        end

        if not importTextBox then
            for _, lbl in ipairs(chilliGui:GetDescendants()) do
                if lbl:IsA("TextLabel") and lbl.Text:find("Import Config Text", 1, true) then
                    local p = lbl.Parent
                    if p then
                        importTextBox = p:FindFirstChildWhichIsA("TextBox", true)
                        if importTextBox then break end
                    end
                end
            end
        end

        if not importTextBox then
            statusCallback("❌ Ko thấy ô Import", Color3.fromRGB(255, 90, 90))
            task.wait(2)
            if updateIslandContentLanguage then updateIslandContentLanguage(currentLanguage) end
            isConfigInjecting = false; return
        end

        -- 3. Nạp dữ liệu JSON
        importTextBox.Text = configJson
        task.wait(0.1)

        if getconnections then
            pcall(function()
                for _, conn in ipairs(getconnections(importTextBox.FocusLost)) do conn:Fire(true) end
            end)
        end
        task.wait(0.25)

        -- 4. Bấm nút "Import"
        local importBtnElement = nil
        for _, d in ipairs(chilliGui:GetDescendants()) do
            if (d:IsA("TextLabel") or d:IsA("TextButton")) and d.Visible then
                local t = d.Text:gsub("%s+", " "):match("^%s*(.-)%s*$") or ""
                if t == "Import" or t == "Nhập" then
                    importBtnElement = d; break
                end
            end
        end

        if not importBtnElement then
            statusCallback("❌ Ko thấy nút Import", Color3.fromRGB(255, 90, 90))
            task.wait(2)
            if updateIslandContentLanguage then updateIslandContentLanguage(currentLanguage) end
            isConfigInjecting = false; return
        end

        stealthClick(importBtnElement)
        task.wait(0.9)

        -- 5. Mở Dropdown "Load Config"
        local loadDropdownElement = nil
        for _, lbl in ipairs(chilliGui:GetDescendants()) do
            if lbl:IsA("TextLabel") and (lbl.Text:find("Load Config", 1, true) or lbl.Text:find("Tải Cấu Hình", 1, true)) then
                local row = lbl.Parent
                if row then
                    loadDropdownElement = row:FindFirstChildWhichIsA("GuiButton", true)
                    if not loadDropdownElement then
                        for _, c in ipairs(row:GetDescendants()) do
                            if (c:IsA("TextLabel") or c:IsA("TextButton")) and c.Text:find("Default", 1, true) then
                                loadDropdownElement = c; break
                            end
                        end
                    end
                end
                break
            end
        end

        if loadDropdownElement then
            stealthClick(loadDropdownElement)
            task.wait(0.35)
        end

        -- 6. Chọn profile "main"
        local mainProfileElement = nil
        local t0 = tick()
        while tick() - t0 < 4 do
            for _, d in ipairs(chilliGui:GetDescendants()) do
                if (d:IsA("TextLabel") or d:IsA("TextButton")) and d.Visible then
                    local t = d.Text:gsub("%s+", " "):match("^%s*(.-)%s*$") or ""
                    if t:lower() == profileName:lower() then
                        mainProfileElement = d; break
                    end
                end
            end
            if mainProfileElement then break end
            task.wait(0.12)
        end

        if not mainProfileElement then
            statusCallback("❌ Ko có profile " .. profileName, Color3.fromRGB(255, 90, 90))
            task.wait(2)
            if updateIslandContentLanguage then updateIslandContentLanguage(currentLanguage) end
            isConfigInjecting = false; return
        end

        stealthClick(mainProfileElement)
        task.wait(0.35)

        -- 7. Bấm nút "Load"
        local loadBtnElement = nil
        for _, d in ipairs(chilliGui:GetDescendants()) do
            if (d:IsA("TextLabel") or d:IsA("TextButton")) and d.Visible then
                local t = d.Text:gsub("%s+", " "):match("^%s*(.-)%s*$") or ""
                if t == "Load" or t == "Tải" then
                    loadBtnElement = d; break
                end
            end
        end

        if not loadBtnElement then
            statusCallback("❌ Ko thấy nút Load", Color3.fromRGB(255, 90, 90))
            task.wait(2)
            if updateIslandContentLanguage then updateIslandContentLanguage(currentLanguage) end
            isConfigInjecting = false; return
        end

        stealthClick(loadBtnElement)
        task.wait(0.4)

        statusCallback(isOff and "✔ ĐÃ TẮT!" or "✔ ĐÃ NẠP XONG!", Color3.fromRGB(110, 245, 140))
        task.wait(2.2)
        end)

        -- Luôn khôi phục ngôn ngữ người dùng đang chọn và nhả cờ, kể cả khi có lỗi giữa chừng
        if switchGlobalLanguage and currentLanguage ~= prevLang then
            pcall(switchGlobalLanguage, prevLang)
        end
        if not okRun then
            pcall(statusCallback, "❌ Lỗi nạp", Color3.fromRGB(255, 90, 90))
            task.wait(2)
        end
        if updateIslandContentLanguage then pcall(updateIslandContentLanguage, currentLanguage) end
        isConfigInjecting = false
    end)
end

-- ==================== 7. DYNAMIC ISLAND ====================
local function createDynamicIslandUI()
    local parentTarget = (gethui and gethui()) or CoreGui or LocalPlayer:WaitForChild("PlayerGui")
    local oldIsland = parentTarget:FindFirstChild("Chilli_Dynamic_Island")
    if oldIsland then oldIsland:Destroy() end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "Chilli_Dynamic_Island"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.DisplayOrder = 2147483647
    ScreenGui.Parent = parentTarget

    local isExpanded = false
    -- Tính năng nạp Config (BẬT / TẮT Setting Auto Farm) đang được ẩn; đặt true để hiện lại thẻ này
    local SHOW_CONFIG = false
    local islandPulse = nil   -- gán sau: hiệu ứng "nảy" khi trạng thái đổi

    local COLLAPSED_W, COLLAPSED_H = 196, 40
    local EXPANDED_W = 320
    local STATUS_ROW_H = 34   -- hàng "trạng thái hiện tại" ở đầu khung mở rộng
    local EXPANDED_H = (SHOW_CONFIG and 232 or 132) + STATUS_ROW_H
    local R_PILL, R_BOX = 20, 28

    local Island = Instance.new("Frame")
    Island.Name = "Island"
    Island.Size = UDim2.new(0, 196, 0, 40)
    Island.AnchorPoint = Vector2.new(0.5, 0)
    Island.Position = UDim2.new(0.5, 0, 0, 10)
    Island.BackgroundColor3 = Color3.fromRGB(12, 7, 7)
    Island.BackgroundTransparency = 0
    Island.BorderSizePixel = 0
    Island.ClipsDescendants = true
    Island.Parent = ScreenGui

    local IslandCorner = Instance.new("UICorner")
    IslandCorner.CornerRadius = UDim.new(0, R_PILL)
    IslandCorner.Parent = Island

    local IslandScale = Instance.new("UIScale")   -- hiệu ứng nhấn (thu nhẹ) như iPhone
    IslandScale.Parent = Island

    local IslandStroke = Instance.new("UIStroke")
    IslandStroke.Thickness = 1.4
    IslandStroke.Color = COLOR_FACE_TOP
    IslandStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    IslandStroke.Parent = Island

    -- VIEW THU GỌN
    -- Kích thước cố định để nội dung không bị co giãn khi Island đổi kích thước (Island tự cắt phần thừa)
    local CollapsedView = Instance.new("Frame")
    CollapsedView.Name = "CollapsedView"
    CollapsedView.Size = UDim2.new(0, COLLAPSED_W, 0, COLLAPSED_H)
    CollapsedView.AnchorPoint = Vector2.new(0.5, 0)
    CollapsedView.Position = UDim2.new(0.5, 0, 0, 0)
    CollapsedView.BackgroundTransparency = 1
    CollapsedView.BorderSizePixel = 0
    CollapsedView.Parent = Island

    local CollapsedHit = Instance.new("TextButton")   -- vùng bấm trong suốt phủ toàn bộ Island thu gọn
    CollapsedHit.Name = "CollapsedHit"
    CollapsedHit.Size = UDim2.new(1, 0, 1, 0)
    CollapsedHit.BackgroundTransparency = 1
    CollapsedHit.Text = ""
    CollapsedHit.ZIndex = 10
    CollapsedHit.Parent = CollapsedView

    local hubLogo = getLogo(SELECTED_HUB == "venyx" and "vx" or "chilli")
    if hubLogo then
        local lg = Instance.new("ImageLabel")
        lg.Name = "HubLogo"
        lg.BackgroundTransparency = 1
        lg.Image = hubLogo
        lg.Size = UDim2.new(0, 26, 0, 26)
        lg.Position = UDim2.new(0, 8, 0.5, -13)
        lg.Parent = CollapsedView
    end

    local DotStatus = Instance.new("Frame")
    DotStatus.Size = UDim2.new(0, 7, 0, 7)
    DotStatus.Position = hubLogo and UDim2.new(0, 28, 0.5, 6) or UDim2.new(0, 14, 0.5, -4)
    DotStatus.ZIndex = 3
    DotStatus.BackgroundColor3 = Color3.fromRGB(90, 240, 140)
    DotStatus.BorderSizePixel = 0
    DotStatus.Parent = CollapsedView

    local DotCorner = Instance.new("UICorner")
    DotCorner.CornerRadius = UDim.new(1, 0)
    DotCorner.Parent = DotStatus

    local IslandTitle = Instance.new("TextLabel")
    IslandTitle.Size = UDim2.new(1, hubLogo and -65 or -55, 0, 18)
    IslandTitle.Position = UDim2.new(0, hubLogo and 40 or 28, 0, 4)
    IslandTitle.BackgroundTransparency = 1
    IslandTitle.Text = hubLogo and BRAND or ("🌶️ " .. BRAND)
    IslandTitle.Font = Enum.Font.GothamBold
    IslandTitle.TextSize = 11
    IslandTitle.TextColor3 = Color3.fromRGB(245, 250, 255)
    IslandTitle.TextXAlignment = Enum.TextXAlignment.Left
    IslandTitle.Parent = CollapsedView

    -- Dòng trạng thái (đồng bộ từ nhãn "Đang rảnh / đang làm gì" của Venyx)
    local IslandStatus = Instance.new("TextLabel")
    IslandStatus.Name = "IslandStatus"
    IslandStatus.Size = UDim2.new(1, hubLogo and -65 or -55, 0, 14)
    IslandStatus.Position = UDim2.new(0, hubLogo and 40 or 28, 0, 21)
    IslandStatus.BackgroundTransparency = 1
    IslandStatus.Text = "Sẵn sàng"
    IslandStatus.Font = Enum.Font.Gotham
    IslandStatus.TextSize = 9
    IslandStatus.TextColor3 = Color3.fromRGB(255, 190, 150)
    IslandStatus.TextXAlignment = Enum.TextXAlignment.Left
    IslandStatus.TextTruncate = Enum.TextTruncate.AtEnd
    IslandStatus.Parent = CollapsedView

    local ChevronIcon = Instance.new("TextLabel")
    ChevronIcon.Size = UDim2.new(0, 20, 1, 0)
    ChevronIcon.Position = UDim2.new(1, -26, 0, 0)
    ChevronIcon.BackgroundTransparency = 1
    ChevronIcon.Text = "▼"
    ChevronIcon.Font = Enum.Font.GothamBold
    ChevronIcon.TextSize = 10
    ChevronIcon.TextColor3 = Color3.fromRGB(255, 170, 140)
    ChevronIcon.Parent = CollapsedView

    -- VIEW MỞ RỘNG
    local ExpandedView = Instance.new("Frame")
    ExpandedView.Name = "ExpandedView"
    ExpandedView.Size = UDim2.new(0, EXPANDED_W, 0, EXPANDED_H)
    ExpandedView.AnchorPoint = Vector2.new(0.5, 0)
    ExpandedView.Position = UDim2.new(0.5, 0, 0, 0)
    ExpandedView.BackgroundTransparency = 1
    ExpandedView.BorderSizePixel = 0
    ExpandedView.Visible = false
    ExpandedView.Parent = Island

    -- Hiệu ứng mờ dần NHẸ: một lớp phủ cùng màu Island, chỉ đổi độ trong suốt của 1 khung (rẻ hơn nhiều so với CanvasGroup)
    local FadeCover = Instance.new("Frame")
    FadeCover.Name = "FadeCover"
    FadeCover.Size = UDim2.new(1, 0, 1, 0)
    FadeCover.BackgroundColor3 = Color3.fromRGB(12, 7, 7)
    FadeCover.BackgroundTransparency = 1
    FadeCover.BorderSizePixel = 0
    FadeCover.Active = false
    FadeCover.ZIndex = 50
    FadeCover.Parent = Island
    local CoverCorner = Instance.new("UICorner")
    CoverCorner.CornerRadius = UDim.new(0, R_PILL)
    CoverCorner.Parent = FadeCover

    local ExpandedScale = Instance.new("UIScale")
    ExpandedScale.Scale = 0.92
    ExpandedScale.Parent = ExpandedView

    local ExpHeader = Instance.new("Frame")
    ExpHeader.Size = UDim2.new(1, 0, 0, 32)
    ExpHeader.BackgroundTransparency = 1
    ExpHeader.Parent = ExpandedView

    local ExpTitle = Instance.new("TextLabel")
    ExpTitle.Size = UDim2.new(1, hubLogo and -72 or -50, 1, 0)
    ExpTitle.Position = UDim2.new(0, hubLogo and 38 or 14, 0, 0)
    ExpTitle.BackgroundTransparency = 1
    ExpTitle.Text = (hubLogo and "" or "🌶️ ") .. HUB_NAME .. " Control"
    ExpTitle.Font = Enum.Font.GothamBold
    ExpTitle.TextSize = 11
    ExpTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    ExpTitle.TextXAlignment = Enum.TextXAlignment.Left
    ExpTitle.Parent = ExpHeader
    if hubLogo then
        local lg2 = Instance.new("ImageLabel")
        lg2.BackgroundTransparency = 1
        lg2.Image = hubLogo
        lg2.Size = UDim2.new(0, 22, 0, 22)
        lg2.Position = UDim2.new(0, 12, 0.5, -11)
        lg2.Parent = ExpHeader
    end

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 26, 0, 26)
    CloseBtn.Position = UDim2.new(1, -34, 0, 3)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(50, 24, 24)
    CloseBtn.Text = "▲"
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextSize = 11
    CloseBtn.TextColor3 = Color3.fromRGB(255, 170, 140)
    CloseBtn.Parent = ExpHeader

    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(1, 0)
    CloseCorner.Parent = CloseBtn

    -- Hàng trạng thái: hiện nội dung trạng thái hiện tại (cập nhật cùng vòng quét trạng thái)
    local StatusCard = Instance.new("Frame")
    StatusCard.Name = "StatusCard"
    StatusCard.Size = UDim2.new(1, -24, 0, 28)
    StatusCard.Position = UDim2.new(0, 12, 0, 34)
    StatusCard.BackgroundColor3 = Color3.fromRGB(26, 14, 14)
    StatusCard.BorderSizePixel = 0
    StatusCard.Parent = ExpandedView
    do
        local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 10); c.Parent = StatusCard
    end
    local ExpDot = Instance.new("Frame")
    ExpDot.Size = UDim2.new(0, 8, 0, 8)
    ExpDot.Position = UDim2.new(0, 10, 0.5, -4)
    ExpDot.BackgroundColor3 = Color3.fromRGB(90, 240, 140)
    ExpDot.BorderSizePixel = 0
    ExpDot.Parent = StatusCard
    do
        local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(1, 0); c.Parent = ExpDot
    end
    local ExpStatus = Instance.new("TextLabel")
    ExpStatus.Name = "ExpStatus"
    ExpStatus.BackgroundTransparency = 1
    ExpStatus.Size = UDim2.new(1, -34, 1, 0)
    ExpStatus.Position = UDim2.new(0, 26, 0, 0)
    ExpStatus.Font = Enum.Font.GothamMedium
    ExpStatus.TextSize = 11
    ExpStatus.TextColor3 = Color3.fromRGB(255, 225, 205)
    ExpStatus.TextXAlignment = Enum.TextXAlignment.Left
    ExpStatus.TextTruncate = Enum.TextTruncate.AtEnd
    ExpStatus.Text = "Sẵn sàng"
    ExpStatus.Parent = StatusCard

    -- Hàng 1: Nút đổi ngôn ngữ
    local LangCapsule = Instance.new("Frame")
    LangCapsule.Size = UDim2.new(1, -24, 0, 32)
    LangCapsule.Position = UDim2.new(0, 12, 0, 34 + STATUS_ROW_H)
    LangCapsule.BackgroundColor3 = Color3.fromRGB(36, 18, 18)
    LangCapsule.BorderSizePixel = 0
    LangCapsule.Parent = ExpandedView

    local LangCorner = Instance.new("UICorner")
    LangCorner.CornerRadius = UDim.new(1, 0)
    LangCorner.Parent = LangCapsule

    local LangSlider = Instance.new("Frame")
    LangSlider.Size = UDim2.new(0.5, -2, 1, -4)
    LangSlider.Position = UDim2.new(0, 2, 0, 2)
    LangSlider.BackgroundColor3 = COLOR_FACE_BOTTOM
    LangSlider.BorderSizePixel = 0
    LangSlider.Parent = LangCapsule

    local SliderCorner = Instance.new("UICorner")
    SliderCorner.CornerRadius = UDim.new(1, 0)
    SliderCorner.Parent = LangSlider

    local SliderGrad = Instance.new("UIGradient")
    SliderGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, COLOR_FACE_TOP),
        ColorSequenceKeypoint.new(1, COLOR_FACE_BOTTOM)
    })
    SliderGrad.Rotation = 90
    SliderGrad.Parent = LangSlider

    local BtnVI = Instance.new("TextButton")
    BtnVI.Size = UDim2.new(0.5, 0, 1, 0)
    BtnVI.Position = UDim2.new(0, 0, 0, 0)
    BtnVI.BackgroundTransparency = 1
    BtnVI.Text = "🇻🇳 TIẾNG VIỆT"
    BtnVI.Font = Enum.Font.GothamBold
    BtnVI.TextSize = 10
    BtnVI.TextColor3 = Color3.fromRGB(255, 255, 255)
    BtnVI.ZIndex = 5
    BtnVI.Parent = LangCapsule

    local BtnEN = Instance.new("TextButton")
    BtnEN.Size = UDim2.new(0.5, 0, 1, 0)
    BtnEN.Position = UDim2.new(0.5, 0, 0, 0)
    BtnEN.BackgroundTransparency = 1
    BtnEN.Text = "🌐 ENGLISH"
    BtnEN.Font = Enum.Font.GothamBold
    BtnEN.TextSize = 10
    BtnEN.TextColor3 = Color3.fromRGB(190, 160, 155)
    BtnEN.ZIndex = 5
    BtnEN.Parent = LangCapsule

    -- Hàng 2: Thẻ Setting Auto Farm
    local AutoFarmCard = Instance.new("Frame")
    AutoFarmCard.Size = UDim2.new(1, -24, 0, 96)
    AutoFarmCard.Position = UDim2.new(0, 12, 0, 72 + STATUS_ROW_H)
    AutoFarmCard.BackgroundColor3 = Color3.fromRGB(30, 15, 15)
    AutoFarmCard.BorderSizePixel = 0
    AutoFarmCard.Parent = ExpandedView
    AutoFarmCard.Visible = SHOW_CONFIG

    local AutoFarmCorner = Instance.new("UICorner")
    AutoFarmCorner.CornerRadius = UDim.new(0, 10)
    AutoFarmCorner.Parent = AutoFarmCard

    local AutoFarmStroke = Instance.new("UIStroke")
    AutoFarmStroke.Thickness = 1
    AutoFarmStroke.Color = Color3.fromRGB(140, 50, 45)
    AutoFarmStroke.Parent = AutoFarmCard

    local AutoFarmBtn = Instance.new("TextButton")
    -- Nút BẬT chiếm ~66% bề rộng, nút TẮT chiếm phần còn lại bên phải
    AutoFarmBtn.Size = UDim2.new(0.66, -8, 0, 28)
    AutoFarmBtn.Position = UDim2.new(0, 6, 0, 6)
    AutoFarmBtn.BackgroundColor3 = COLOR_FACE_BOTTOM
    AutoFarmBtn.BorderSizePixel = 0
    AutoFarmBtn.Text = "BẬT ⚙️ SETTING AUTO FARM"
    AutoFarmBtn.Font = Enum.Font.GothamBold
    AutoFarmBtn.TextSize = 9.5
    AutoFarmBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    AutoFarmBtn.Parent = AutoFarmCard

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 8)
    BtnCorner.Parent = AutoFarmBtn

    local BtnGrad = Instance.new("UIGradient")
    BtnGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, COLOR_FACE_TOP),
        ColorSequenceKeypoint.new(1, COLOR_FACE_BOTTOM)
    })
    BtnGrad.Rotation = 90
    BtnGrad.Parent = AutoFarmBtn

    -- Nút TẮT: nạp cấu hình đã tắt hết công tắc farm
    local StopBtn = Instance.new("TextButton")
    StopBtn.Name = "StopAutoFarmBtn"
    StopBtn.Size = UDim2.new(0.34, -8, 0, 28)
    StopBtn.Position = UDim2.new(0.66, 2, 0, 6)
    StopBtn.BackgroundColor3 = Color3.fromRGB(58, 28, 28)
    StopBtn.BorderSizePixel = 0
    StopBtn.Text = "✖ TẮT"
    StopBtn.Font = Enum.Font.GothamBold
    StopBtn.TextSize = 10
    StopBtn.TextScaled = true
    StopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    StopBtn.Parent = AutoFarmCard

    local StopSizeLimit = Instance.new("UITextSizeConstraint")
    StopSizeLimit.MaxTextSize = 10
    StopSizeLimit.MinTextSize = 6
    StopSizeLimit.Parent = StopBtn

    local StopCorner = Instance.new("UICorner")
    StopCorner.CornerRadius = UDim.new(0, 8)
    StopCorner.Parent = StopBtn

    local StopStroke = Instance.new("UIStroke")
    StopStroke.Thickness = 1.1
    StopStroke.Color = COLOR_FACE_BOTTOM
    StopStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    StopStroke.Parent = StopBtn

    local SubLabel = Instance.new("TextLabel")
    SubLabel.Size = UDim2.new(1, -16, 0, 54)
    SubLabel.Position = UDim2.new(0, 8, 0, 37)
    SubLabel.BackgroundTransparency = 1
    SubLabel.Font = Enum.Font.GothamMedium
    SubLabel.TextSize = 8.8
    SubLabel.TextColor3 = Color3.fromRGB(255, 215, 200)
    SubLabel.TextXAlignment = Enum.TextXAlignment.Left
    SubLabel.TextYAlignment = Enum.TextYAlignment.Top
    SubLabel.TextWrapped = true
    SubLabel.Text = "• Tự động làm từ A-Z\n• Nhặt trứng trên Secret 2B+\n• Tự động chạy máy tập khi rảnh rỗi\n• Tự động làm các nhiệm vụ còn thiếu và sự kiện..."
    SubLabel.Parent = AutoFarmCard

    -- Hàng 3: THẺ TIKTOK (logo Kai Roblox + tên kênh + nút sao chép link)
    local TIKTOK_HANDLE = "@kai.roblox7"
    local TIKTOK_URL = "https://www.tiktok.com/" .. TIKTOK_HANDLE

    local TikTokCard = Instance.new("Frame")
    TikTokCard.Name = "TikTokCard"
    TikTokCard.Size = UDim2.new(1, -24, 0, 44)
    TikTokCard.Position = UDim2.new(0, 12, 0, (SHOW_CONFIG and 176 or 74) + STATUS_ROW_H)
    TikTokCard.BackgroundColor3 = Color3.fromRGB(22, 12, 16)
    TikTokCard.BorderSizePixel = 0
    TikTokCard.Parent = ExpandedView

    local TikTokCorner = Instance.new("UICorner")
    TikTokCorner.CornerRadius = UDim.new(0, 12)
    TikTokCorner.Parent = TikTokCard

    local TikTokStroke = Instance.new("UIStroke")
    TikTokStroke.Thickness = 1.2
    TikTokStroke.Color = Color3.fromRGB(0, 230, 255)
    TikTokStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    TikTokStroke.Parent = TikTokCard

    local TikTokStrokeGrad = Instance.new("UIGradient")
    TikTokStrokeGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.0, Color3.fromRGB(0, 242, 254)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(254, 9, 121)),
        ColorSequenceKeypoint.new(1.0, Color3.fromRGB(0, 242, 254))
    })
    TikTokStrokeGrad.Rotation = 20
    TikTokStrokeGrad.Parent = TikTokStroke

    -- Logo Kai Roblox (dạng tròn); nếu executor không nạp được ảnh thì dùng biểu tượng ♪
    local kaiLogo = getLogo("kai")
    local LogoHolder = Instance.new("Frame")
    LogoHolder.Size = UDim2.new(0, 34, 0, 34)
    LogoHolder.Position = UDim2.new(0, 7, 0.5, -17)
    LogoHolder.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    LogoHolder.BorderSizePixel = 0
    LogoHolder.Parent = TikTokCard
    local LogoCorner = Instance.new("UICorner")
    LogoCorner.CornerRadius = UDim.new(1, 0)
    LogoCorner.Parent = LogoHolder
    local LogoStroke = Instance.new("UIStroke")
    LogoStroke.Thickness = 1.5
    LogoStroke.Color = Color3.fromRGB(254, 9, 121)
    LogoStroke.Parent = LogoHolder
    if kaiLogo then
        local img = Instance.new("ImageLabel")
        img.Size = UDim2.new(1, 0, 1, 0)
        img.BackgroundTransparency = 1
        img.Image = kaiLogo
        img.ScaleType = Enum.ScaleType.Crop
        img.Parent = LogoHolder
        local imgCorner = Instance.new("UICorner")
        imgCorner.CornerRadius = UDim.new(1, 0)
        imgCorner.Parent = img
    else
        local note = Instance.new("TextLabel")
        note.Size = UDim2.new(1, 0, 1, 0)
        note.BackgroundTransparency = 1
        note.Text = "♪"
        note.Font = Enum.Font.GothamBold
        note.TextSize = 16
        note.TextColor3 = Color3.fromRGB(0, 242, 254)
        note.Parent = LogoHolder
    end

    local TikTokTag = Instance.new("TextLabel")
    TikTokTag.Size = UDim2.new(1, -150, 0, 12)
    TikTokTag.Position = UDim2.new(0, 50, 0, 8)
    TikTokTag.BackgroundTransparency = 1
    TikTokTag.Text = "TIKTOK"
    TikTokTag.Font = Enum.Font.GothamBold
    TikTokTag.TextSize = 8
    TikTokTag.TextColor3 = Color3.fromRGB(0, 242, 254)
    TikTokTag.TextXAlignment = Enum.TextXAlignment.Left
    TikTokTag.Parent = TikTokCard

    local TikTokLabel = Instance.new("TextLabel")
    TikTokLabel.Name = "TikTokLabel"
    TikTokLabel.Size = UDim2.new(1, -150, 0, 16)
    TikTokLabel.Position = UDim2.new(0, 50, 0, 20)
    TikTokLabel.BackgroundTransparency = 1
    TikTokLabel.Text = "Kai Roblox"
    TikTokLabel.Font = Enum.Font.GothamBlack
    TikTokLabel.TextSize = 13
    TikTokLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TikTokLabel.TextXAlignment = Enum.TextXAlignment.Left
    TikTokLabel.TextTruncate = Enum.TextTruncate.AtEnd
    TikTokLabel.Parent = TikTokCard

    -- Nút SAO CHÉP: chép link TikTok vào clipboard
    local CopyBtn = Instance.new("TextButton")
    CopyBtn.Name = "CopyTikTokBtn"
    CopyBtn.Size = UDim2.new(0, 86, 0, 28)
    CopyBtn.Position = UDim2.new(1, -94, 0.5, -14)
    CopyBtn.BackgroundColor3 = Color3.fromRGB(235, 20, 110)
    CopyBtn.BorderSizePixel = 0
    CopyBtn.AutoButtonColor = false
    CopyBtn.Text = "📋 SAO CHÉP"
    CopyBtn.Font = Enum.Font.GothamBold
    CopyBtn.TextSize = 10
    CopyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CopyBtn.Parent = TikTokCard
    local CopyCorner = Instance.new("UICorner")
    CopyCorner.CornerRadius = UDim.new(0, 8)
    CopyCorner.Parent = CopyBtn
    -- Lưu ý: không dùng UIGradient trên nút này vì UIGradient nhuộm cả màu chữ, làm chữ trùng màu nền (khó đọc)
    CopyBtn.TextStrokeColor3 = Color3.fromRGB(90, 0, 40)
    CopyBtn.TextStrokeTransparency = 0.55
    local CopyScale = Instance.new("UIScale")
    CopyScale.Parent = CopyBtn

    local CopyTagLabel = CopyBtn   -- giữ tên cũ: updateIslandContentLanguage đổi chữ trên nút này
    local isCopiedAnimating = false

    local function triggerCopyLink()
        local copied = false
        pcall(function()
            local fn = setclipboard or toclipboard
            if fn then fn(TIKTOK_URL) copied = true end
        end)

        if isCopiedAnimating then return end
        isCopiedAnimating = true

        TweenService:Create(CopyScale, TweenInfo.new(0.08), {Scale = 0.92}):Play()
        task.delay(0.08, function()
            TweenService:Create(CopyScale, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()
        end)

        if copied then
            CopyBtn.Text = (currentLanguage == "VI") and "✔ ĐÃ CHÉP" or "✔ COPIED"
            CopyBtn.BackgroundColor3 = Color3.fromRGB(40, 170, 90)
        else
            CopyBtn.Text = (currentLanguage == "VI") and "✖ KO HỖ TRỢ" or "✖ NOT SUPPORTED"
            CopyBtn.BackgroundColor3 = Color3.fromRGB(150, 40, 40)
        end

        task.delay(2, function()
            CopyBtn.Text = (currentLanguage == "VI") and "📋 SAO CHÉP" or "📋 COPY"
            CopyBtn.BackgroundColor3 = Color3.fromRGB(235, 20, 110)
            isCopiedAnimating = false
        end)
    end

    CopyBtn.MouseButton1Click:Connect(triggerCopyLink)

    updateIslandContentLanguage = function(lang)
        if SELECTED_HUB == "venyx" then
            AutoFarmBtn.Text = (lang == "VI") and "⚙️ CONFIG VENYX (SẮP CÓ)" or "⚙️ VENYX CONFIG (SOON)"
        else
            AutoFarmBtn.Text = (lang == "VI") and "BẬT ⚙️ SETTING AUTO FARM" or "ENABLE ⚙️ SETTING AUTO FARM"
        end
        StopBtn.Text = (lang == "VI") and "✖ TẮT" or "✖ OFF"
        TweenService:Create(AutoFarmBtn, TweenInfo.new(0.18), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        TweenService:Create(StopBtn, TweenInfo.new(0.18), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        if not isCopiedAnimating then
            CopyTagLabel.Text = (lang == "VI") and "📋 SAO CHÉP" or "📋 COPY"
        end
        if lang == "VI" then
            SubLabel.Text = "• Tự động làm từ A-Z\n• Nhặt trứng trên Secret 2B+\n• Tự động chạy máy tập khi rảnh rỗi\n• Tự động làm các nhiệm vụ còn thiếu và sự kiện..."
        else
            SubLabel.Text = "• Automated from A to Z\n• Steal Secret eggs 2B+\n• Auto run treadmill when idle\n• Complete missing quests & live events..."
        end
    end

    if SELECTED_HUB == "venyx" then
        local baseUpdate = updateIslandContentLanguage
        updateIslandContentLanguage = function(lang)
            baseUpdate(lang)
            SubLabel.Text = (lang == "VI")
                and "• Đang dùng menu Venyx (nhẹ hơn)\n• Config Venyx sẽ được tích hợp ở bản sau"
                or "• Using the Venyx menu (lighter)\n• Venyx config coming in a later version"
        end
    end
    updateIslandContentLanguage(currentLanguage)

    -- ===== ĐỒNG BỘ TRẠNG THÁI TỪ VENYX LÊN ISLAND =====
    -- Tìm "viên thuốc" trạng thái ở hàng header của Venyx. Trạng thái có thể là bất cứ chữ gì
    -- (Idle, "No egg matches your targets", "Waiting...", ...) nên nhận diện theo VỊ TRÍ chứ không theo chữ.
    local NON_STATUS = {
        ["/"] = true, ["search"] = true, ["tìm kiếm"] = true, ["venyx"] = true,
        ["steal an egg"] = true, ["−"] = true, ["-"] = true, ["x"] = true, ["×"] = true,
    }

    local function findVenyxStatusLabel()
        local roots = {}
        pcall(function() if gethui then table.insert(roots, gethui()) end end)
        pcall(function() table.insert(roots, game:GetService("CoreGui")) end)
        pcall(function() table.insert(roots, Players.LocalPlayer:FindFirstChild("PlayerGui")) end)
        for _, root in ipairs(roots) do
            if root then
                for _, g in ipairs(root:GetChildren()) do
                    local kind = g:IsA("ScreenGui") and g:GetAttribute("ChilliKind")
                    if kind == "venyx" then
                        local descs = g:GetDescendants()
                        local titleLbl, versionLbl
                        for _, d in ipairs(descs) do
                            if d:IsA("TextLabel") then
                                if not titleLbl and (d.Text == "VENYX" or d.Text == VENYX_TITLE) then
                                    titleLbl = d
                                elseif not versionLbl and (d.Text or ""):match("^v%d[%d%.]*$") then
                                    versionLbl = d
                                end
                            end
                        end
                        if titleLbl then
                            local rowY = titleLbl.AbsolutePosition.Y + titleLbl.AbsoluteSize.Y / 2
                            local minX = (versionLbl and (versionLbl.AbsolutePosition.X + versionLbl.AbsoluteSize.X - 2))
                                or (titleLbl.AbsolutePosition.X + titleLbl.AbsoluteSize.X)
                            local best, bestX
                            for _, d in ipairs(descs) do
                                if d:IsA("TextLabel") and d ~= titleLbl and d ~= versionLbl
                                    and not d:FindFirstAncestorOfClass("ScrollingFrame")
                                    and not d:FindFirstAncestorOfClass("TextBox") then
                                    local n = normStatus(d.Text)
                                    local cy = d.AbsolutePosition.Y + d.AbsoluteSize.Y / 2
                                    if #n >= 3 and not NON_STATUS[n] and math.abs(cy - rowY) < 30
                                        and d.AbsolutePosition.X >= minX then
                                        if not bestX or d.AbsolutePosition.X < bestX then
                                            best, bestX = d, d.AbsolutePosition.X
                                        end
                                    end
                                end
                            end
                            if best then return best end
                        end
                        -- Dự phòng: nhãn Idle / Đang rảnh bất kỳ (ngoài danh sách cuộn)
                        for _, d in ipairs(descs) do
                            if d:IsA("TextLabel") and not d:FindFirstAncestorOfClass("ScrollingFrame") then
                                local orig = ST.orig[d]
                                if isIdleText(d.Text) or (orig and isIdleText(orig)) then return d end
                            end
                        end
                    end
                end
            end
        end
        return nil
    end

    -- Nhãn "đang làm gì đó" của Venyx (vd: "Đang cướp: Holy Peacock") nằm ở thông báo/bảng phụ,
    -- không nhất thiết ở header -> quét cả các GUI Venyx/bảng phụ, chỉ lấy nhãn đang hiển thị.
    local function scanVenyxStatus()
        for inst in pairs(StatusCandidates) do
            if inst.Parent then
                local kind = guiKindOf(inst)
                if (kind == "venyx" or kind == "other" or kind == "hub") and (isActionText(inst.Text) or (kind == "hub" and ST.learned[inst])) and reallyVisible(inst) then
                    if not isSkipped(inst) then
                        return cleanStatus(inst.Text)
                    end
                end
            else
                StatusCandidates[inst] = nil
            end
        end
        return nil
    end

    task.spawn(function()
        local statusSrc, lastScan = nil, 0
        local lastShown = ""
        local findGap, stable = 3, 0   -- findGap: giãn dần khi tìm nhãn thất bại; stable: số vòng không đổi
        while ScreenGui and ScreenGui.Parent and alive() do
            local ok = pcall(function()
                local txt = scanVenyxStatus()               -- ưu tiên: việc đang làm
                if not txt then                              -- sau đó: nhãn "Đang rảnh" ở header
                    if ((not statusSrc or not statusSrc.Parent) and os.clock() - lastScan > findGap) or os.clock() - lastScan > 60 then
                        lastScan = os.clock()
                        statusSrc = findVenyxStatusLabel()
                        findGap = statusSrc and 3 or math.min(findGap * 2, 30)
                    end
                    if statusSrc and statusSrc.Parent then
                        txt = cleanStatus(statusSrc.Text)
                    end
                end
                if not txt or txt == "" then
                    txt = (currentLanguage == "VI") and "Sẵn sàng" or "Ready"
                end
                stable = (txt == lastShown) and (stable + 1) or 0
                if txt ~= lastShown then
                    local firstTime = (lastShown == "")
                    lastShown = txt
                    if not firstTime and islandPulse then islandPulse() end
                    IslandStatus.Text = txt
                    ExpStatus.Text = txt
                    local low = txt:lower()
                    local idle = low:find("rảnh", 1, true) or low:find("idle", 1, true)
                        or low:find("sẵn sàng", 1, true) or low == "ready" or low:find("không có việc", 1, true)
                    local dotCol = idle and Color3.fromRGB(90, 240, 140) or Color3.fromRGB(255, 190, 60)
                    DotStatus.BackgroundColor3 = dotCol
                    ExpDot.BackgroundColor3 = dotCol
                end
            end)
            task.wait(ok and (stable >= 6 and 2 or 1) or 2)
        end
    end)

    -- ===== HIỆU ỨNG ISLAND KIỂU iPHONE: lò xo (spring) cho kích thước + bo góc, nội dung mờ dần / hiện dần =====
    -- Chỉ chạy trên Heartbeat trong lúc đang chuyển động (~0.5 giây) rồi tự ngắt -> không tốn máy khi đứng yên
    local sp = {
        x = {COLLAPSED_W, COLLAPSED_H, R_PILL},
        v = {0, 0, 0},
        t = {COLLAPSED_W, COLLAPSED_H, R_PILL},
    }
    local SPRING_K = 210                                   -- độ cứng
    local SPRING_C = 2 * math.sqrt(SPRING_K) * 0.74        -- giảm chấn < 1: nảy nhẹ rồi ổn định
    local springConn = nil

    local function applySpring()
        local w, h = math.max(sp.x[1], 20), math.max(sp.x[2], 20)
        Island.Size = UDim2.new(0, w, 0, h)
        local rad = UDim.new(0, math.clamp(sp.x[3], 0, h / 2))
        IslandCorner.CornerRadius = rad
        CoverCorner.CornerRadius = rad
    end

    local function startSpring()
        if springConn then return end
        springConn = RunService.Heartbeat:Connect(function(dt)
            if not (ScreenGui and ScreenGui.Parent) then
                springConn:Disconnect() springConn = nil return
            end
            dt = math.min(dt, 1 / 20)
            local n = math.max(1, math.ceil(dt * 120))
            local h = dt / n
            for _ = 1, n do
                for i = 1, 3 do
                    local a = -SPRING_K * (sp.x[i] - sp.t[i]) - SPRING_C * sp.v[i]
                    sp.v[i] = sp.v[i] + a * h
                    sp.x[i] = sp.x[i] + sp.v[i] * h
                end
            end
            local settled = true
            for i = 1, 3 do
                if math.abs(sp.x[i] - sp.t[i]) > 0.15 or math.abs(sp.v[i]) > 1 then settled = false end
            end
            if settled then
                for i = 1, 3 do sp.x[i] = sp.t[i] sp.v[i] = 0 end
                springConn:Disconnect()
                springConn = nil
            end
            applySpring()
        end)
    end

    local animId = 0
    local function fadeCover(to, dur, delay)
        TweenService:Create(FadeCover, TweenInfo.new(dur, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, delay or 0),
            {BackgroundTransparency = to}):Play()
    end

    local function setExpanded(expand)
        if isExpanded == expand then return end
        isExpanded = expand
        animId = animId + 1
        local myId = animId

        -- Island đổi kích thước bằng lò xo; nội dung cũ mờ đi (lớp phủ), đổi khung nội dung, rồi nội dung mới hiện dần
        sp.t[1], sp.t[2], sp.t[3] = (expand and EXPANDED_W or COLLAPSED_W), (expand and EXPANDED_H or COLLAPSED_H), (expand and R_BOX or R_PILL)
        startSpring()
        fadeCover(0, 0.1)
        task.delay(0.1, function()
            if animId ~= myId then return end
            CollapsedView.Visible = not expand
            ExpandedView.Visible = expand
            if expand then
                ExpandedScale.Scale = 0.94
                TweenService:Create(ExpandedScale, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()
            end
            fadeCover(1, expand and 0.26 or 0.22)
        end)
    end

    -- Khi trạng thái đổi: Island "nảy" rộng ra một chút rồi co lại (giống hoạt động trực tiếp trên iPhone)
    islandPulse = function()
        if isExpanded then return end
        sp.t[1] = COLLAPSED_W + 18
        startSpring()
        task.delay(0.2, function()
            if not isExpanded then
                sp.t[1] = COLLAPSED_W
                startSpring()
            end
        end)
    end

    -- Nhấn giữ: Island thu nhỏ nhẹ như iPhone
    local function pressScale(to)
        TweenService:Create(IslandScale, TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Scale = to}):Play()
    end
    CollapsedHit.MouseButton1Down:Connect(function() pressScale(0.96) end)
    CollapsedHit.MouseButton1Up:Connect(function() pressScale(1) end)
    CollapsedHit.MouseLeave:Connect(function() pressScale(1) end)

    CollapsedHit.MouseButton1Click:Connect(function() setExpanded(true) end)
    CloseBtn.MouseButton1Click:Connect(function() setExpanded(false) end)

    local function switchMode(target)
        if currentLanguage == target then return end
        currentLanguage = target

        if target == "VI" then
            TweenService:Create(LangSlider, TweenInfo.new(0.32, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Position = UDim2.new(0, 2, 0, 2)
            }):Play()
            TweenService:Create(BtnVI, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
            TweenService:Create(BtnEN, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(190, 160, 155)}):Play()
        else
            TweenService:Create(LangSlider, TweenInfo.new(0.32, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Position = UDim2.new(0.5, 0, 0, 2)
            }):Play()
            TweenService:Create(BtnEN, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
            TweenService:Create(BtnVI, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(190, 160, 155)}):Play()
        end

        updateAllActive()

        if updateIslandContentLanguage then
            updateIslandContentLanguage(target)
        end
    end

    switchGlobalLanguage = switchMode
    BtnVI.MouseButton1Click:Connect(function() switchMode("VI") end)
    BtnEN.MouseButton1Click:Connect(function() switchMode("EN") end)

    -- Hiển thị trạng thái ngay trên nút vừa được bấm
    local function makeStatus(btn)
        return function(txt, col)
            btn.Text = txt
            TweenService:Create(btn, TweenInfo.new(0.18), {TextColor3 = col}):Play()
        end
    end

    local function pressCardAnimation()
        TweenService:Create(AutoFarmCard, TweenInfo.new(0.08), {Size = UDim2.new(1, -28, 0, 92)}):Play()
        task.delay(0.08, function()
            TweenService:Create(AutoFarmCard, TweenInfo.new(0.15, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(1, -24, 0, 96)}):Play()
        end)
    end

    AutoFarmBtn.MouseButton1Click:Connect(function()
        if isConfigInjecting then return end
        pressCardAnimation()
        executeAutoConfig(makeStatus(AutoFarmBtn), "on")
    end)

    StopBtn.MouseButton1Click:Connect(function()
        if isConfigInjecting then return end
        pressCardAnimation()
        executeAutoConfig(makeStatus(StopBtn), "off")
    end)

    -- Kéo thả Island, giới hạn biên theo kích thước thật của Island và màn hình
    -- FIX: dùng ScreenGui.AbsoluteSize + Island.AbsoluteSize thay vì số cố định (-180 / -50)
    local dragging, dragStart, startPos = false, nil, nil
    Island.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = Island.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)

    Island.InputChanged:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and dragging then
            local delta = input.Position - dragStart
            local screen = ScreenGui.AbsoluteSize
            local size = Island.AbsoluteSize

            -- Island neo ở giữa-trên (AnchorPoint 0.5, 0), nên X tính từ tâm
            local limitX = math.max((screen.X - size.X) / 2, 0)
            local limitY = math.max(screen.Y - size.Y, 0)

            local baseX = startPos.X.Offset + (startPos.X.Scale - 0.5) * screen.X
            local newX = math.clamp(baseX + delta.X, -limitX, limitX)
            local newY = math.clamp(startPos.Y.Offset + delta.Y, 0, limitY)

            Island.Position = UDim2.new(0.5, newX, 0, newY)
        end
    end)
end

-- ==================== 8. OBSERVER (DỰA TRÊN SỰ KIỆN, THEO DÕI NHIỀU GUI) ====================
task.delay(1.2, function()
    pcall(createDynamicIslandUI)

    local hiddenRoot = nil
    pcall(function()
        if gethui then hiddenRoot = gethui() end
    end)
    -- Một số executor trả về chính CoreGui/PlayerGui: khi đó KHÔNG coi là nơi chỉ chứa GUI của script
    if hiddenRoot == CoreGui or hiddenRoot == LocalPlayer:FindFirstChild("PlayerGui") then
        hiddenRoot = nil
    end

    -- Không dùng bảng có phần tử nil (ipairs sẽ dừng ngay ở nil đầu tiên)
    local searchRoots = {}
    if hiddenRoot then table.insert(searchRoots, hiddenRoot) end
    table.insert(searchRoots, CoreGui)
    do
        local pg = LocalPlayer:FindFirstChild("PlayerGui")
        if pg then table.insert(searchRoots, pg) end
    end

    local IGNORED_GUI_NAMES = {
        ["Chilli_Dynamic_Island"] = true,
        ["RobloxGui"] = true, ["TopBarApp"] = true, ["TouchGui"] = true,
        ["Chat"] = true, ["BubbleChat"] = true, ["Freecam"] = true,
        ["BackpackGui"] = true, ["PlayerList"] = true, ["PurchasePrompt"] = true
    }

    local lastAttach = os.clock()   -- lần gắn GUI gần nhất (để giãn vòng quét khi không có GUI mới)
    local attachedGuis = {}   -- [ScreenGui] = kết nối DescendantAdded
    local kindRechecks = {}   -- [ScreenGui] = số lần đã nhận diện lại
    local hubFirstSeen = {}   -- [ScreenGui] = thời điểm đầu tiên thấy nhãn "Chilli Hub"
    local scanTries = {}      -- [ScreenGui] = số lần đã thử nhận diện (GUI chưa gắn)

    -- Nhận diện: "venyx" (có nhãn VENYX), "hub" (có nhãn Chilli Hub), "other" (còn lại)
    local function classifyGui(gui)
        local sawChilli = false
        for _, d in ipairs(gui:GetDescendants()) do
            if d:IsA("TextLabel") or d:IsA("TextButton") then
                local t = d.Text
                if t == "VENYX" or (t == VENYX_TITLE and ST.orig[d] == "VENYX") then
                    return "venyx"
                end
                if not sawChilli and looksLikeHubTitle(t) then
                    sawChilli = true
                end
            end
        end
        return sawChilli and "hub" or "other"
    end

    -- "hub" phải ổn định >= 2 giây mới được tin (tránh nhận nhầm GUI Venyx đang dựng dở)
    local function desiredKind(gui)
        local kind = classifyGui(gui)
        if kind == "hub" then
            local t0 = hubFirstSeen[gui]
            if not t0 then
                hubFirstSeen[gui] = os.clock()
                return "other"
            end
            if os.clock() - t0 < 2 then
                return "other"
            end
        end
        return kind
    end

    -- Hàng đợi theo lô: GUI lớn (Venyx dựng hàng trăm nhãn cùng lúc) được xử lý dần,
    -- mỗi khung hình chỉ vài chục phần tử -> không đột biến CPU/RAM làm văng game trên điện thoại yếu
    local hookQueue, qHead, qTail, qRunning = {}, 1, 0, false
    local BATCH = 30
    local function pumpQueue()
        if qRunning then return end
        qRunning = true
        task.spawn(function()
            while qHead <= qTail do
                local n = 0
                while qHead <= qTail and n < BATCH do
                    local d = hookQueue[qHead]
                    hookQueue[qHead] = nil
                    qHead = qHead + 1
                    n = n + 1
                    if d.Parent and (d:IsA("TextLabel") or d:IsA("TextButton") or d:IsA("TextBox")) then
                        pcall(hookElement, d)
                    end
                end
                task.wait()
            end
            hookQueue, qHead, qTail, qRunning = {}, 1, 0, false
        end)
    end
    local function processElement(desc)
        if not alive() then return end
        if desc:IsA("TextLabel") or desc:IsA("TextButton") or desc:IsA("TextBox") then
            qTail = qTail + 1
            hookQueue[qTail] = desc
            pumpQueue()
        end
    end

    local function attachGui(gui, kind)
        gui:SetAttribute("ChilliKind", kind)
        lastAttach = os.clock()
        attachedGuis[gui] = gui.DescendantAdded:Connect(function(desc)
            processElement(desc)
        end)
        -- Các phần tử có sẵn cũng đi qua hàng đợi theo lô
        for _, d in ipairs(gui:GetDescendants()) do processElement(d) end
    end

    -- Đổi loại GUI sau khi nhận diện lại: dịch lại và (nếu là menu gốc) đổi màu
    local function changeKind(gui, kind)
        gui:SetAttribute("ChilliKind", kind)
        if kind == "hub" then
            task.spawn(function()
                local list = gui:GetDescendants()
                for i = 1, #list do
                    inspectAndApplySoftBlue(list[i])
                    if i % 60 == 0 then task.wait() end
                end
            end)
        end
        updateAllActive()
    end

    local function scanForGuis()
        for _, root in ipairs(searchRoots) do
            if root then
                local blind = (root == hiddenRoot)
                for _, g in ipairs(root:GetChildren()) do
                    if g:IsA("ScreenGui") and not IGNORED_GUI_NAMES[g.Name] then
                        if not attachedGuis[g] then
                            if blind then
                                -- Thư mục ẩn chỉ chứa GUI của script: gắn dịch cho tất cả (kể cả thông báo, bảng phụ)
                                attachGui(g, desiredKind(g))
                            else
                                local n = (scanTries[g] or 0) + 1
                                scanTries[g] = n
                                if n <= 150 and (n <= 6 or n % 15 == 0) then
                                    local kind = desiredKind(g)
                                    if kind ~= "other" then
                                        attachGui(g, kind)
                                    end
                                end
                            end
                        elseif g:GetAttribute("ChilliKind") == "other" and (kindRechecks[g] or 0) < 30 then
                            kindRechecks[g] = (kindRechecks[g] or 0) + 1
                            local kind = desiredKind(g)
                            if kind ~= "other" then
                                changeKind(g, kind)
                            end
                        end
                    end
                end
            end
        end

        for g, conn in pairs(attachedGuis) do
            if not g.Parent then
                conn:Disconnect()
                attachedGuis[g] = nil
            end
        end
        for g in pairs(scanTries) do
            if not g.Parent then scanTries[g] = nil end
        end
        for g in pairs(hubFirstSeen) do
            if not g.Parent then hubFirstSeen[g] = nil end
        end
        for g in pairs(kindRechecks) do
            if not g.Parent then kindRechecks[g] = nil end
        end
    end

    -- GUI mới trong thư mục ẩn (thông báo, bảng phụ...) được gắn dịch ngay khi vừa tạo
    if hiddenRoot then
        hiddenRoot.ChildAdded:Connect(function(child)
            if child:IsA("ScreenGui") and not IGNORED_GUI_NAMES[child.Name] and not attachedGuis[child] then
                task.defer(function()
                    if child.Parent and not attachedGuis[child] then
                        attachGui(child, "other")
                    end
                end)
            end
        end)
    end

    -- Vòng nhẹ 1 giây/lần: tìm GUI mới, nhận diện lại GUI chưa rõ loại, dọn GUI đã bị xóa
    task.spawn(function()
        local tick30 = 0
        while alive() do
            pcall(scanForGuis)
            tick30 = tick30 + 1
            if tick30 >= 30 then
                tick30 = 0
                -- Dọn phần tử đã bị xóa (bảng yếu cũng tự dọn khi GC)
                for el in pairs(TrackedElements) do
                    if not el.Parent then unhookElement(el) end
                end
            end
            -- Lâu không có GUI mới thì quét thưa hơn (2 giây/lần) cho nhẹ máy
            task.wait((os.clock() - lastAttach > 30) and 2 or 1)
        end
    end)

    -- ===== NHẬT KÝ CHẨN ĐOÁN (bật/tắt bằng DIAG_LOG) =====
    -- Cứ 60 giây ghi 1 dòng vào ChilliVenyx_Diag.txt: RAM game, RAM Lua, số phần tử đang dịch...
    -- Nếu bị văng, gửi file này để biết RAM có tăng dần theo script Việt hóa hay không.
    if DIAG_LOG and writefile then
        task.spawn(function()
            local lines, t0 = {}, os.clock()
            local Stats = game:GetService("Stats")
            -- Giữ lại nhật ký của lần chạy trước (nếu game bị văng rồi vào lại, dòng cuối của phiên cũ cho biết RAM ngay trước lúc văng)
            pcall(function()
                if isfile and readfile and isfile("ChilliVenyx_Diag.txt") then
                    writefile("ChilliVenyx_Diag_prev.txt", readfile("ChilliVenyx_Diag.txt"))
                end
            end)
            pcall(function()
                table.insert(lines, "== phiên mới, giờ máy " .. os.date("%H:%M:%S", os.time()) .. " ==")
                writefile("ChilliVenyx_Diag.txt", table.concat(lines, "\n"))
            end)
            while alive() do
                task.wait(60)
                if not alive() then break end
                pcall(function()
                    local el, gs = 0, 0
                    for _ in pairs(TrackedElements) do el = el + 1 end
                    for _ in pairs(attachedGuis) do gs = gs + 1 end
                    local okM, mem = pcall(function() return Stats:GetTotalMemoryUsageMb() end)
                    local okL, lua = pcall(collectgarbage, "count")
                    local el_s = os.clock() - t0
                    table.insert(lines, string.format(
                        "[%02d:%02d] hub=%s game=%sMB lua=%sMB tracked=%d guis=%d queue=%d cache=%d writes=%d muted=%d",
                        math.floor(el_s / 60), math.floor(el_s % 60), SELECTED_HUB,
                        okM and string.format("%.0f", mem) or "?",
                        okL and string.format("%.1f", lua / 1024) or "?",
                        el, gs, math.max(0, qTail - qHead + 1), FastCacheCount, STAT.writes, STAT.mutes))
                    if #lines > 240 then table.remove(lines, 1) end
                    writefile("ChilliVenyx_Diag.txt", table.concat(lines, "\n"))
                end)
            end
        end)
    end
end)
