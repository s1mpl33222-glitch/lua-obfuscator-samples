-- ==============================================================================
--  CHILLI HUB V5 - RONNEI OFFICIAL EDITION (100% TELEPORT LOCK & FAKE 85-120 FPS)
--  Tích hợp chuẩn:
--    1. LINK CHÍNH THỨC: raw.githubusercontent.com/ronnei/hihi/refs/heads/main/chillihubv5.lua
--    2. CHẶN TUYỆT ĐỐI VENYX GỐC KHI REJOIN: Khóa 100% queue_on_teleport,
--       chặn clearteleportqueue và ngắt kết nối OnTeleport của script gốc.
--    3. CANH GÁC LIÊN TỤC KHÔNG BAO GIỜ NGẮT SỚM: Bắt trọn GUI và thanh FPS
--       dù khi Rejoin game tải chậm 15-30 giây.
--    4. KHÓA CỨNG FPS ẢO (85 - 120 FPS): Đè trực tiếp ở mọi thời điểm.
-- ==============================================================================

local MY_CHILLI_URL  = "https://raw.githubusercontent.com/ronnei/hihi/refs/heads/main/chillihubv5.lua"
local AUTO_RUN_FILE  = "ChilliHubV5_AutoRun.lua"
local LANG_SAVE_FILE = "ChilliV5_Lang.txt"

local CHILLI_CORE_PAYLOAD = [===[
local NEW_TITLE = "Chilli Hub V5"
local CHILLI_LOGO_ID = "rbxassetid://92622270383869"
local LOGO_BG_COLOR = Color3.fromRGB(5, 7, 15)
local ISLAND_BLACK_BG = Color3.fromRGB(0, 0, 0)

local MY_CHILLI_URL  = "https://raw.githubusercontent.com/ronnei/hihi/refs/heads/main/chillihubv5.lua"
local AUTO_RUN_FILE  = "ChilliHubV5_AutoRun.lua"
local LANG_SAVE_FILE = "ChilliV5_Lang.txt"

-- ==================== 1. BỘ CHẶN TELEPORT TUYỆT ĐỐI (100% CHỈ CHẠY CHILLI HUB V5) ====================
do
    local env = (getgenv and getgenv()) or _G
    local realQueue = env.__ChilliOrigQueue
        or env.queue_on_teleport
        or env.queueonteleport
        or (syn and syn.queue_on_teleport)
        or (fluxus and fluxus.queue_on_teleport)
        or (delta and delta.queue_on_teleport)

    -- Đoạn mã tự chạy khi vào Server mới: Đợi game tải xong rồi chạy Chilli Hub V5 của bạn
    local teleportBootstrap = string.format([[
        --CHILLI_V5_AUTHORIZED_TELEPORT--
        task.spawn(function()
            if not game:IsLoaded() then
                game.Loaded:Wait()
            end
            local Players = game:GetService("Players")
            while not Players.LocalPlayer do
                task.wait(0.1)
            end
            task.wait(1.0)
            local executed = false
            if isfile and readfile and isfile("%s") then
                local ok, fn = pcall(function() return loadstring(readfile("%s")) end)
                if ok and type(fn) == "function" then
                    executed = true
                    task.spawn(fn)
                end
            end
            if not executed then
                pcall(function()
                    loadstring(game:HttpGet("%s"))()
                end)
            end
        end)
    ]], AUTO_RUN_FILE, AUTO_RUN_FILE, MY_CHILLI_URL)

    if realQueue then
        env.__ChilliOrigQueue = realQueue

        -- Bất kỳ script nào (kể cả Venyx đã mã hóa) gọi queue_on_teleport đều bị ép đổi thành Chilli Hub V5!
        local function forceChilliQueue(scriptCode)
            local codeStr = tostring(scriptCode or "")
            if codeStr:find("CHILLI_V5_AUTHORIZED_TELEPORT", 1, true) then
                return realQueue(scriptCode)
            end
            return realQueue(teleportBootstrap)
        end

        -- 1. Ghi đè trên toàn bộ bảng môi trường
        env.queue_on_teleport = forceChilliQueue
        env.queueonteleport = forceChilliQueue
        pcall(function() getfenv(0).queue_on_teleport = forceChilliQueue end)
        pcall(function() getfenv(0).queueonteleport = forceChilliQueue end)
        if syn then pcall(function() syn.queue_on_teleport = forceChilliQueue end) end
        if fluxus then pcall(function() fluxus.queue_on_teleport = forceChilliQueue end) end
        if delta then pcall(function() delta.queue_on_teleport = forceChilliQueue end) end

        -- 2. Hook trực tiếp C-Closure nếu Executor hỗ trợ hookfunction
        if hookfunction and not env.__ChilliHookFuncDone then
            env.__ChilliHookFuncDone = true
            pcall(function()
                local oldHook
                oldHook = hookfunction(realQueue, function(code)
                    local s = tostring(code or "")
                    if s:find("CHILLI_V5_AUTHORIZED_TELEPORT", 1, true) then
                        return oldHook(code)
                    end
                    return oldHook(teleportBootstrap)
                end)
            end)
        end

        -- 3. Vô hiệu hóa clearteleportqueue để Venyx không thể xóa hàng đợi của bạn
        local noop = function() end
        env.clearteleportqueue = noop
        env.clear_teleport_queue = noop
        if syn then pcall(function() syn.clear_teleport_queue = noop end) end
        if fluxus then pcall(function() fluxus.clear_teleport_queue = noop end) end

        -- 4. Nạp ngay Chilli Hub V5 vào hàng đợi Teleport
        pcall(function()
            realQueue(teleportBootstrap)
        end)

        -- 5. Ngắt kết nối OnTeleport của Venyx và ép nạp lại Chilli Hub V5 ngay giây phút chuyển server
        task.spawn(function()
            local Players = game:GetService("Players")
            local lp = Players.LocalPlayer or Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
            if lp and lp.OnTeleport then
                lp.OnTeleport:Connect(function()
                    if getconnections then
                        pcall(function()
                            for _, conn in ipairs(getconnections(lp.OnTeleport)) do
                                if conn.Function and not isexecutorclosure(conn.Function) then
                                    conn:Disable()
                                end
                            end
                        end)
                    end
                    pcall(function()
                        realQueue(teleportBootstrap)
                    end)
                end)
            end
        end)
    end
end

-- Khởi chạy Base Script VenyxHub trong luồng riêng
if not getgenv().__VenyxV5NewLoaded then
    getgenv().__VenyxV5NewLoaded = true
    task.spawn(function()
        if not game:IsLoaded() then
            game.Loaded:Wait()
        end
        pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/tienkhanh1/Venyx/main/VenyxHub"))()
        end)
    end)
end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer or Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local scanRoots = {
    gethui and gethui(),
    CoreGui,
    LocalPlayer:WaitForChild("PlayerGui")
}

local IGNORED_GUI_NAMES = {
    ["RobloxGui"] = true, ["TopBarApp"] = true, ["TouchGui"] = true,
    ["Chat"] = true, ["BubbleChat"] = true, ["Freecam"] = true,
    ["BackpackGui"] = true, ["PlayerList"] = true, ["PurchasePrompt"] = true
}

-- Danh sách chứa các Gradient để xoay chung trong 1 luồng duy nhất (0% CPU)
local ActiveGradients = {}

local COLOR_SEQ_RAINBOW = ColorSequence.new({
    ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 55, 55)),
    ColorSequenceKeypoint.new(0.20, Color3.fromRGB(255, 175, 40)),
    ColorSequenceKeypoint.new(0.40, Color3.fromRGB(255, 235, 50)),
    ColorSequenceKeypoint.new(0.60, Color3.fromRGB(50, 255, 130)),
    ColorSequenceKeypoint.new(0.80, Color3.fromRGB(60, 185, 255)),
    ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 55, 55))
})

if not getgenv().__ChilliV5RainbowLoop then
    getgenv().__ChilliV5RainbowLoop = true
    task.spawn(function()
        local rot = 0
        while true do
            rot = (rot + 4) % 360
            for i = #ActiveGradients, 1, -1 do
                local g = ActiveGradients[i]
                if g and g.Parent then
                    g.Rotation = rot
                else
                    table.remove(ActiveGradients, i)
                end
            end
            task.wait(0.03)
        end
    end)
end

-- ==================== 2. BỘ TẠO FPS ẢO (85 - 120 FPS) BẤT TỬ ====================
local currentFakeFps = math.random(96, 112)
local lastFpsStepClock = 0
local TrackedFpsLabels = {}

local function getSmoothFakeFps()
    local now = os.clock()
    if now - lastFpsStepClock >= 0.65 then
        lastFpsStepClock = now
        local delta = math.random(-4, 4)
        currentFakeFps = math.clamp(currentFakeFps + delta, 85, 120)
    end
    return currentFakeFps
end

local function isFpsCounterText(str)
    if type(str) ~= "string" or str == "" then return false end
    return str:find("FPS", 1, true) ~= nil and str:find("ms", 1, true) ~= nil and str:find("%d+%s*FPS") ~= nil
end

local function forceUpdateFpsLabel(lbl)
    if not (lbl and lbl.Parent) then return end
    if lbl:GetAttribute("__UpdatingFps") then return end
    local raw = lbl.Text
    if not isFpsCounterText(raw) then return end

    local fakeVal = getSmoothFakeFps()
    local patched = raw:gsub("%d+%s*FPS", tostring(fakeVal) .. " FPS", 1)
    if raw ~= patched then
        lbl:SetAttribute("__UpdatingFps", true)
        lbl.Text = patched
        lbl:SetAttribute("__UpdatingFps", false)
    end
end

local function hookFakeFpsCounter(lbl)
    if not (lbl:IsA("TextLabel") or lbl:IsA("TextButton")) then return end
    TrackedFpsLabels[lbl] = true
    forceUpdateFpsLabel(lbl)

    if not lbl:GetAttribute("__FpsHooked") then
        lbl:SetAttribute("__FpsHooked", true)
        lbl:GetPropertyChangedSignal("Text"):Connect(function()
            if not lbl:GetAttribute("__UpdatingFps") then
                forceUpdateFpsLabel(lbl)
            end
        end)
    end
end

-- Vòng lặp duy trì FPS ảo 85-120 xuyên suốt toàn bộ phiên chơi
if not getgenv().__ChilliFpsDaemon then
    getgenv().__ChilliFpsDaemon = true
    task.spawn(function()
        while true do
            task.wait(0.5)
            getSmoothFakeFps()
            for lbl in pairs(TrackedFpsLabels) do
                if lbl and lbl.Parent then
                    forceUpdateFpsLabel(lbl)
                else
                    TrackedFpsLabels[lbl] = nil
                end
            end
        end
    end)
end

-- ==================== 3. HỆ THỐNG TỪ ĐIỂN DỊCH THUẬT 3 TẦNG (100% TIẾNG VIỆT) ====================
local currentLanguage = "VI"
pcall(function()
    if isfile and isfile(LANG_SAVE_FILE) then
        local saved = readfile(LANG_SAVE_FILE)
        if saved == "EN" or saved == "VI" then
            currentLanguage = saved
        end
    end
end)

local FastCache = {}
local TrackedTexts = {}
local GlobalRefreshIslandStatus = nil

local EXACT_MATCH_VI = {
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
    ["Waiting for next race"] = "Đang chờ chặng đua tiếp theo",
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
    ["Joining race"] = "Đang vào đường đua",
    ["Racing"] = "Đang đua xe",

    -- Trang Home & Dashboard Mới
    ["Home"] = "Trang Chủ",
    ["Dashboard"] = "Bảng Điều Khiển",
    ["Welcome back"] = "Chào mừng trở lại",
    ["Venyx Discord"] = "Chilli Hub Discord",
    ["Updates, keys, support"] = "Cập nhật, nhận key, hỗ trợ",
    ["Copy Invite"] = "Chép Link Mời",
    ["Discord"] = "Discord",
    ["MONEY /S"] = "TIỀN /GIÂY",
    ["OPEN"] = "MỞ",
    ["Open"] = "Mở",
    ["Close"] = "Đóng",
    ["Welcome to Venyx 1.0.0! Join our Discord for updates and support"] = "Chào mừng tới Chilli Hub V5! Tham gia Discord để cập nhật và nhận hỗ trợ",
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
    ["Racing Event: ragdoll jump to the portal, races, leaves and claims"] = "Sự Kiện Đua Xe: tự nhảy vào cổng, đua, rời đi và nhận thưởng",
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
    ["Racing Event"] = "Sự Kiện Đua Xe",
    ["Butterfly"] = "Bắt Bướm",
    ["Steal wisp eggs"] = "Cướp trứng Wisp",
    ["Wisp"] = "Nhặt Wisp",
    ["Steal missing index"] = "Cướp trứng thiếu trong Chỉ mục",
    ["Steal lab eggs"] = "Cướp trứng phòng Lab",
    ["Place"] = "Đặt trứng vào chuồng",
    ["Butterfly machine"] = "Máy đổi Bướm",

    -- Event: Race, Star, Butterfly, Lab, AA
    ["Race"] = "Đua Xe",
    ["RACE"] = "ĐUA XE",
    ["Star"] = "Sao Băng",
    ["STAR"] = "SAO BĂNG",
    ["BUTTERFLY"] = "BẮT BƯỚM",
    ["Lab"] = "Phòng Lab",
    ["LAB"] = "PHÒNG LAB",
    ["AA"] = "Admin (AA)",
    ["RACING EVENT"] = "SỰ KIỆN ĐUA XE",
    ["NEXT RACE"] = "ĐUA TIẾP THEO",
    ["WINS"] = "THẮNG",
    ["TROPHIES"] = "CÚP",
    ["Auto race"] = "Tự động đua xe",
    ["Race speed"] = "Tốc độ đua",
    ["Lower it if wins do not count"] = "Giảm tốc độ nếu thắng không được tính",
    ["Use power-ups"] = "Tự dùng vật phẩm tăng tốc",
    ["REWARDS"] = "PHẦN THƯỞNG",
    ["Auto claim rewards"] = "Tự nhận phần thưởng",
    ["Auto equip racer"] = "Tự trang bị xe đua",
    ["Racer"] = "Xe đua",
    ["Best owned"] = "Tốt nhất đang có",
    ["Auto buy shop"] = "Tự mua vật phẩm Shop",
    ["Shop items"] = "Vật phẩm Shop",
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
    ["LAB ODDS"] = "TỶ LỆ PHÒNG LAB",
    ["BANNER"] = "BĂNG RÔN",
    ["ENDS IN"] = "KẾT THÚC SAU",
    ["BANNER CHANCE"] = "TỶ LỆ BĂNG RÔN",
    ["NEXT"] = "TIẾP THEO",
    ["Experimental Pets"] = "Pet Thí Nghiệm",
    ["Biohazard Pets"] = "Pet Sinh Học",
    ["Lab banners"] = "Băng rôn phòng Lab",
    ["Auto trade in"] = "Tự động đổi trứng Lab",
    ["Auto reroll recipe"] = "Tự đổi lại công thức",
    ["Place lab reward eggs"] = "Đặt trứng thưởng từ Lab",
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

local STATUS_ACTION_PATTERNS_VI = {
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

local SMART_PHRASE_FALLBACK_VI = {
    { "No egg matches your targets", "Không có trứng nào khớp mục tiêu" },
    { "no egg matches your targets", "không có trứng nào khớp mục tiêu" },
    { "your targets", "mục tiêu của bạn" },
    { "matches your", "khớp với" },
    { "matches filter", "khớp bộ lọc" },
    { "safe zone", "vùng an toàn" },
    { "other players", "người chơi khác" },
    { "from players", "từ người chơi" },
    { "missing index", "thiếu trong Chỉ mục" },
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

local DYNAMIC_PATTERNS_VI = {
    { pat = "^QUICK BAR (%d+)$", rep = "THANH NHANH %1" },
    { pat = "Venyx(.-)(%d+) hours? ago", rep = "Chilli Hub%1%2 giờ trước" },
    { pat = "Venyx(.-)(%d+) minutes? ago", rep = "Chilli Hub%1%2 phút trước" },
    { pat = "Venyx(.-)(%d+) days? ago", rep = "Chilli Hub%1%2 ngày trước" },
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
    { pat = "Experimental Pets · needs (.-) · pity (%d+/%d+) · rerolls (%d+) · (.+)", rep = "Pet Thí Nghiệm · cần %1 · bảo hiểm %2 · lượt đổi %3 · %4" },
    { pat = "Biohazard Pets · needs (.-) · pity (%d+/%d+) · rerolls (%d+) · (.+)", rep = "Pet Sinh Học · cần %1 · bảo hiểm %2 · lượt đổi %3 · %4" },
    { pat = "Unstable DNA · needs (.-) · pity (%d+/%d+) · rerolls (%d+) · (.+)", rep = "DNA Bất Ổn · cần %1 · bảo hiểm %2 · lượt đổi %3 · %4" },
    { pat = "^Mythic · 1 in ([%d%.]+)$", rep = "Thần Thoại · 1 trên %1" },
    { pat = "^Cosmic · 1 in ([%d%.]+)$", rep = "Vũ Trụ · 1 trên %1" },
    { pat = "^Secret · 1 in ([%d%.]+)$", rep = "Bí Ẩn · 1 trên %1" },
    { pat = "^Divine · 1 in ([%d%.]+)$", rep = "Thánh Thần · 1 trên %1" },
    { pat = "^Eternal · 1 in ([%d%.]+)$", rep = "Vĩnh Cửu · 1 trên %1" }
}

local function applySmartPhraseFallback(str)
    local out = str
    for _, pair in ipairs(SMART_PHRASE_FALLBACK_VI) do
        local en, vi = pair[1], pair[2]
        if out:find(en, 1, true) then
            out = out:gsub(en:gsub("([%^%$%(%)%%%.%[%]%*%+%-%?])", "%%%1"), vi)
        end
    end
    return out
end

local function translateStatusAction(cleanEn)
    if not cleanEn or cleanEn == "" then return "Đang rảnh" end
    if currentLanguage == "EN" then
        if cleanEn == "Đang rảnh" then return "Idle" end
        return cleanEn
    end

    local trimmed = (cleanEn:match("^%s*(.-)%s*$") or cleanEn):gsub("%s+", " ")
    if trimmed:lower() == "idle" or trimmed == "Đang rảnh" then
        return "Đang rảnh"
    end

    local cacheKey = "STATUS_VI|" .. trimmed
    if FastCache[cacheKey] then return FastCache[cacheKey] end

    if EXACT_MATCH_VI[trimmed] then
        FastCache[cacheKey] = EXACT_MATCH_VI[trimmed]
        return EXACT_MATCH_VI[trimmed]
    end

    for _, item in ipairs(STATUS_ACTION_PATTERNS_VI) do
        if trimmed:find(item.pat) then
            local out = trimmed:gsub(item.pat, item.rep)
            out = applySmartPhraseFallback(out)
            FastCache[cacheKey] = out
            return out
        end
    end

    local fallbackOut = applySmartPhraseFallback(trimmed)
    FastCache[cacheKey] = fallbackOut
    return fallbackOut
end

local function translateVenyxText(raw)
    if not raw or raw == "" then return raw end
    local cacheKey = currentLanguage .. "|" .. raw
    if FastCache[cacheKey] then return FastCache[cacheKey] end

    if raw:find("Venyx SAE", 1, true) then
        raw = raw:gsub("Venyx SAE", "Chilli SAE")
    elseif raw == "VENYX" then
        raw = NEW_TITLE
    end

    if currentLanguage == "EN" then
        FastCache[cacheKey] = raw
        return raw
    end

    local normalized = (raw:match("^%s*(.-)%s*$") or raw):gsub("%s+", " ")

    if EXACT_MATCH_VI[normalized] then
        local out = EXACT_MATCH_VI[normalized]
        FastCache[cacheKey] = out
        return out
    end

    local baseBeforeDots = normalized:match("^(.+)%.%.%.$")
    if baseBeforeDots then
        baseBeforeDots = baseBeforeDots:match("^%s*(.-)%s*$") or baseBeforeDots
        if EXACT_MATCH_VI[baseBeforeDots] then
            local out = EXACT_MATCH_VI[baseBeforeDots] .. "..."
            FastCache[cacheKey] = out
            return out
        end
    end

    local prefix, wordPart = normalized:match("^([^%w%s]+%s*)(.+)$")
    if prefix and wordPart and EXACT_MATCH_VI[wordPart] then
        local out = prefix .. EXACT_MATCH_VI[wordPart]
        FastCache[cacheKey] = out
        return out
    end

    local result = normalized
    for _, item in ipairs(DYNAMIC_PATTERNS_VI) do
        if result:find(item.pat) then
            result = result:gsub(item.pat, item.rep)
            FastCache[cacheKey] = result
            return result
        end
    end

    for _, item in ipairs(STATUS_ACTION_PATTERNS_VI) do
        if result:find(item.pat) then
            result = result:gsub(item.pat, item.rep)
            result = applySmartPhraseFallback(result)
            FastCache[cacheKey] = result
            return result
        end
    end

    FastCache[cacheKey] = raw
    return raw
end

local function applyElementTranslation(inst)
    if not (inst:IsA("TextLabel") or inst:IsA("TextButton") or inst:IsA("TextBox")) then return end
    if inst:GetAttribute("__IslandDone") or inst:GetAttribute("__FpsHooked") or inst:GetAttribute("__HiddenVxLogo") or inst.Name == "IslandExpandHint" or inst:FindFirstAncestor("ChilliV5_ExpandedIsland") then return end
    if inst:GetAttribute("__IsTranslating") then return end

    if inst:IsA("TextBox") then
        local origPh = inst:GetAttribute("OrigPlaceholder")
        if not origPh and inst.PlaceholderText ~= "" then
            origPh = inst.PlaceholderText
            inst:SetAttribute("OrigPlaceholder", origPh)
        end
        if origPh then
            inst.PlaceholderText = translateVenyxText(origPh)
        end

        if not inst:IsFocused() then
            local boxTxt = inst.Text
            if boxTxt == "Off" or boxTxt == "Tắt" or boxTxt == "None" or boxTxt == "Không có" then
                local origBox = inst:GetAttribute("OrigBoxText")
                if not origBox or (boxTxt == "Off" or boxTxt == "None") then
                    origBox = (boxTxt == "Tắt") and "Off" or ((boxTxt == "Không có") and "None" or boxTxt)
                    inst:SetAttribute("OrigBoxText", origBox)
                end
                local mappedBox = translateVenyxText(origBox)
                if inst.Text ~= mappedBox then
                    inst:SetAttribute("__IsTranslating", true)
                    pcall(function() inst.Text = mappedBox end)
                    inst:SetAttribute("__IsTranslating", false)
                end
            end
        end
        return
    end

    local rawText = inst.Text
    if isFpsCounterText(rawText) then
        hookFakeFpsCounter(inst)
        return
    end

    local original = inst:GetAttribute("OrigRawText")
    if not original then
        original = rawText
        inst:SetAttribute("OrigRawText", original)
    end

    local mapped = translateVenyxText(original)
    if inst.Text ~= mapped then
        inst:SetAttribute("__IsTranslating", true)
        inst:SetAttribute("__LastTranslated", mapped)
        pcall(function() inst.Text = mapped end)
        inst:SetAttribute("__IsTranslating", false)
    end
end

local function hookTextForTranslation(inst)
    if not (inst:IsA("TextLabel") or inst:IsA("TextButton") or inst:IsA("TextBox")) then return end
    if inst:GetAttribute("__IslandDone") or inst:GetAttribute("__HiddenVxLogo") or inst.Name == "IslandExpandHint" or inst:FindFirstAncestor("ChilliV5_ExpandedIsland") then return end

    if not inst:IsA("TextBox") and isFpsCounterText(inst.Text) then
        hookFakeFpsCounter(inst)
        return
    end

    applyElementTranslation(inst)

    if inst:GetAttribute("__TransHooked") then return end
    inst:SetAttribute("__TransHooked", true)
    table.insert(TrackedTexts, inst)

    inst:GetPropertyChangedSignal("Text"):Connect(function()
        if inst:GetAttribute("__IsTranslating") or inst:GetAttribute("__IslandDone") or inst:GetAttribute("__HiddenVxLogo") then return end
        if not inst:IsA("TextBox") and isFpsCounterText(inst.Text) then
            hookFakeFpsCounter(inst)
            return
        end
        if inst:IsA("TextBox") then
            applyElementTranslation(inst)
            return
        end
        if inst.Text ~= inst:GetAttribute("__LastTranslated") then
            inst:SetAttribute("OrigRawText", inst.Text)
            applyElementTranslation(inst)
        end
    end)
end

local function refreshAllTranslations()
    task.spawn(function()
        if GlobalRefreshIslandStatus then
            GlobalRefreshIslandStatus()
        end
        local count = 0
        for i = #TrackedTexts, 1, -1 do
            local el = TrackedTexts[i]
            if el and el.Parent then
                applyElementTranslation(el)
                count = count + 1
                if count % 50 == 0 then
                    task.wait()
                end
            else
                table.remove(TrackedTexts, i)
            end
        end
    end)
end

-- ==================== 4. DYNAMIC ISLAND NỀN ĐEN (GIỮ NGUYÊN 100%) ====================
local function setupDynamicIslandFromStatus(statusLbl, venyxGui)
    local pill = statusLbl.Parent
    if not (pill and pill:IsA("GuiObject")) then return end

    local badHitbox = pill:FindFirstChild("IslandClickHitbox")
    if badHitbox then
        badHitbox:Destroy()
    end

    for _, child in ipairs(pill:GetChildren()) do
        if child:IsA("UIGradient") then
            child:Destroy()
        end
    end

    pill.BackgroundColor3 = ISLAND_BLACK_BG
    pill.BackgroundTransparency = 0
    pill.Size = UDim2.new(0, 0, 0, 28)
    pill.AutomaticSize = Enum.AutomaticSize.X

    if not pill:GetAttribute("__BlackBgLocked") then
        pill:SetAttribute("__BlackBgLocked", true)
        pill:GetPropertyChangedSignal("BackgroundColor3"):Connect(function()
            if pill.BackgroundColor3 ~= ISLAND_BLACK_BG then
                pill.BackgroundColor3 = ISLAND_BLACK_BG
            end
        end)
        pill:GetPropertyChangedSignal("BackgroundTransparency"):Connect(function()
            if pill.BackgroundTransparency ~= 0 then
                pill.BackgroundTransparency = 0
            end
        end)
    end

    local expandHint = pill:FindFirstChild("IslandExpandHint")
    if not expandHint then
        expandHint = Instance.new("TextLabel")
        expandHint.Name = "IslandExpandHint"
        expandHint.Size = UDim2.new(0, 18, 0, 18)
        expandHint.BackgroundColor3 = Color3.fromRGB(28, 32, 48)
        expandHint.BorderSizePixel = 0
        expandHint.Text = "▼"
        expandHint.Font = Enum.Font.GothamBold
        expandHint.TextSize = 9
        expandHint.TextColor3 = Color3.fromRGB(165, 210, 255)
        expandHint.LayoutOrder = 99
        expandHint.ZIndex = 10000
        expandHint.Parent = pill

        local hintCorner = Instance.new("UICorner")
        hintCorner.CornerRadius = UDim.new(1, 0)
        hintCorner.Parent = expandHint

        local hintStroke = Instance.new("UIStroke")
        hintStroke.Thickness = 1
        hintStroke.Color = Color3.fromRGB(90, 130, 200)
        hintStroke.Parent = expandHint
    end

    local function updateStatusText(forceFromSavedOrig)
        if statusLbl:GetAttribute("__Updating") then return end
        statusLbl:SetAttribute("__Updating", true)

        local cleanEn
        if forceFromSavedOrig and statusLbl:GetAttribute("OrigStatusEn") then
            cleanEn = statusLbl:GetAttribute("OrigStatusEn")
        else
            local currentRaw = statusLbl.Text:gsub("●", ""):gsub("•", ""):gsub("✨%s*rainbow", ""):match("^%s*(.-)%s*$") or ""
            if currentRaw ~= "" and currentRaw ~= statusLbl:GetAttribute("__LastTranslatedStatus") then
                cleanEn = currentRaw
                statusLbl:SetAttribute("OrigStatusEn", cleanEn)
            else
                cleanEn = statusLbl:GetAttribute("OrigStatusEn") or currentRaw or "Idle"
            end
        end

        local translatedStatus = translateStatusAction(cleanEn)
        statusLbl:SetAttribute("__LastTranslatedStatus", translatedStatus)

        statusLbl.Text = translatedStatus
        statusLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
        statusLbl.TextTransparency = 0
        statusLbl.Size = UDim2.new(0, 0, 1, 0)
        statusLbl.AutomaticSize = Enum.AutomaticSize.X

        statusLbl:SetAttribute("__Updating", false)
    end

    GlobalRefreshIslandStatus = function()
        updateStatusText(true)
    end

    if statusLbl:GetAttribute("__IslandDone") and venyxGui:FindFirstChild("ChilliV5_ExpandedIsland") then
        updateStatusText(false)
        return
    end
    statusLbl:SetAttribute("__IslandDone", true)

    updateStatusText(false)

    local txtGrad = statusLbl:FindFirstChild("TextRainbow") or Instance.new("UIGradient")
    txtGrad.Name = "TextRainbow"
    txtGrad.Color = COLOR_SEQ_RAINBOW
    txtGrad.Parent = statusLbl
    table.insert(ActiveGradients, txtGrad)

    pill.Parent = venyxGui
    pill.AnchorPoint = Vector2.new(0.5, 0)
    pill.Position = UDim2.new(0.5, 0, 0, 10)
    pill.ZIndex = 9999
    pill.Active = true
    statusLbl.Active = true
    expandHint.Active = true

    local pillCorner = pill:FindFirstChildOfClass("UICorner") or Instance.new("UICorner")
    pillCorner.CornerRadius = UDim.new(1, 0)
    pillCorner.Parent = pill

    local pillStroke = pill:FindFirstChild("IslandStroke") or Instance.new("UIStroke")
    pillStroke.Name = "IslandStroke"
    pillStroke.Thickness = 1.6
    pillStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    pillStroke.Color = Color3.fromRGB(255, 255, 255)
    pillStroke.Parent = pill

    local strokeGrad = pillStroke:FindFirstChildOfClass("UIGradient") or Instance.new("UIGradient")
    strokeGrad.Color = COLOR_SEQ_RAINBOW
    strokeGrad.Parent = pillStroke
    table.insert(ActiveGradients, strokeGrad)

    local oldExp = venyxGui:FindFirstChild("ChilliV5_ExpandedIsland")
    if oldExp then oldExp:Destroy() end

    local ExpandedIsland = Instance.new("Frame")
    ExpandedIsland.Name = "ChilliV5_ExpandedIsland"
    ExpandedIsland.AnchorPoint = Vector2.new(0.5, 0)
    ExpandedIsland.Position = pill.Position
    ExpandedIsland.Size = UDim2.new(0, 260, 0, 78)
    ExpandedIsland.BackgroundColor3 = ISLAND_BLACK_BG
    ExpandedIsland.BackgroundTransparency = 0
    ExpandedIsland.BorderSizePixel = 0
    ExpandedIsland.Visible = false
    ExpandedIsland.Active = true
    ExpandedIsland.ZIndex = 10000
    ExpandedIsland.Parent = venyxGui

    local ExpCorner = Instance.new("UICorner")
    ExpCorner.CornerRadius = UDim.new(0, 16)
    ExpCorner.Parent = ExpandedIsland

    local ExpStroke = Instance.new("UIStroke")
    ExpStroke.Thickness = 1.6
    ExpStroke.Color = Color3.fromRGB(255, 255, 255)
    ExpStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    ExpStroke.Parent = ExpandedIsland

    local ExpStrokeGrad = Instance.new("UIGradient")
    ExpStrokeGrad.Color = COLOR_SEQ_RAINBOW
    ExpStrokeGrad.Parent = ExpStroke
    table.insert(ActiveGradients, ExpStrokeGrad)

    local ExpTitle = Instance.new("TextLabel")
    ExpTitle.Size = UDim2.new(1, -44, 0, 28)
    ExpTitle.Position = UDim2.new(0, 14, 0, 4)
    ExpTitle.BackgroundTransparency = 1
    ExpTitle.Text = "🌶️ Chilli Hub V5"
    ExpTitle.Font = Enum.Font.GothamBold
    ExpTitle.TextSize = 11.5
    ExpTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    ExpTitle.TextXAlignment = Enum.TextXAlignment.Left
    ExpTitle.ZIndex = 10001
    ExpTitle.Parent = ExpandedIsland

    local CollapseBtn = Instance.new("TextButton")
    CollapseBtn.Size = UDim2.new(0, 24, 0, 22)
    CollapseBtn.Position = UDim2.new(1, -32, 0, 7)
    CollapseBtn.BackgroundColor3 = Color3.fromRGB(22, 24, 34)
    CollapseBtn.BorderSizePixel = 0
    CollapseBtn.Text = "▲"
    CollapseBtn.Font = Enum.Font.GothamBold
    CollapseBtn.TextSize = 10
    CollapseBtn.TextColor3 = Color3.fromRGB(160, 205, 255)
    CollapseBtn.ZIndex = 10002
    CollapseBtn.Parent = ExpandedIsland

    local CollapseCorner = Instance.new("UICorner")
    CollapseCorner.CornerRadius = UDim.new(1, 0)
    CollapseCorner.Parent = CollapseBtn

    local LangCapsule = Instance.new("Frame")
    LangCapsule.Size = UDim2.new(1, -20, 0, 34)
    LangCapsule.Position = UDim2.new(0, 10, 0, 36)
    LangCapsule.BackgroundColor3 = Color3.fromRGB(18, 20, 30)
    LangCapsule.BorderSizePixel = 0
    LangCapsule.ZIndex = 10001
    LangCapsule.Parent = ExpandedIsland

    local LangCorner = Instance.new("UICorner")
    LangCorner.CornerRadius = UDim.new(1, 0)
    LangCorner.Parent = LangCapsule

    local LangSlider = Instance.new("Frame")
    LangSlider.Size = UDim2.new(0.5, -4, 1, -4)
    LangSlider.Position = (currentLanguage == "VI") and UDim2.new(0, 2, 0, 2) or UDim2.new(0.5, 2, 0, 2)
    LangSlider.BackgroundColor3 = Color3.fromRGB(95, 110, 235)
    LangSlider.BorderSizePixel = 0
    LangSlider.ZIndex = 10002
    LangSlider.Parent = LangCapsule

    local SliderCorner = Instance.new("UICorner")
    SliderCorner.CornerRadius = UDim.new(1, 0)
    SliderCorner.Parent = LangSlider

    local BtnVI = Instance.new("TextButton")
    BtnVI.Size = UDim2.new(0.5, 0, 1, 0)
    BtnVI.Position = UDim2.new(0, 0, 0, 0)
    BtnVI.BackgroundTransparency = 1
    BtnVI.Text = "🇻🇳 TIẾNG VIỆT"
    BtnVI.Font = Enum.Font.GothamBold
    BtnVI.TextSize = 10.5
    BtnVI.TextColor3 = (currentLanguage == "VI") and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 165, 190)
    BtnVI.ZIndex = 10003
    BtnVI.Parent = LangCapsule

    local BtnEN = Instance.new("TextButton")
    BtnEN.Size = UDim2.new(0.5, 0, 1, 0)
    BtnEN.Position = UDim2.new(0.5, 0, 0, 0)
    BtnEN.BackgroundTransparency = 1
    BtnEN.Text = "🌐 ENGLISH"
    BtnEN.Font = Enum.Font.GothamBold
    BtnEN.TextSize = 10.5
    BtnEN.TextColor3 = (currentLanguage == "EN") and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 165, 190)
    BtnEN.ZIndex = 10003
    BtnEN.Parent = LangCapsule

    local function setLanguage(lang)
        if currentLanguage == lang then return end
        currentLanguage = lang
        pcall(function()
            if writefile then writefile(LANG_SAVE_FILE, lang) end
        end)

        if lang == "VI" then
            TweenService:Create(LangSlider, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Position = UDim2.new(0, 2, 0, 2)
            }):Play()
            BtnVI.TextColor3 = Color3.fromRGB(255, 255, 255)
            BtnEN.TextColor3 = Color3.fromRGB(150, 165, 190)
        else
            TweenService:Create(LangSlider, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Position = UDim2.new(0.5, 2, 0, 2)
            }):Play()
            BtnEN.TextColor3 = Color3.fromRGB(255, 255, 255)
            BtnVI.TextColor3 = Color3.fromRGB(150, 165, 190)
        end

        refreshAllTranslations()
    end

    BtnVI.MouseButton1Click:Connect(function() setLanguage("VI") end)
    BtnEN.MouseButton1Click:Connect(function() setLanguage("EN") end)

    local function toggleIsland(expand)
        if expand then
            ExpandedIsland.Position = pill.Position
            pill.Visible = false
            ExpandedIsland.Size = UDim2.new(0, 150, 0, 28)
            ExpandedIsland.Visible = true
            TweenService:Create(ExpandedIsland, TweenInfo.new(0.28, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 260, 0, 78)
            }):Play()
        else
            pill.Position = ExpandedIsland.Position
            ExpandedIsland.Visible = false
            pill.Visible = true
        end
    end

    CollapseBtn.MouseButton1Click:Connect(function()
        toggleIsland(false)
    end)

    local function attachDragAndClick(triggerObj, moveFrame, onTapCallback)
        if triggerObj:GetAttribute("__DragBound") then return end
        triggerObj:SetAttribute("__DragBound", true)

        local dragging, dragStart, startPos, moved = false, nil, nil, false

        triggerObj.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                moved = false
                dragStart = input.Position
                startPos = moveFrame.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        if dragging and not moved and onTapCallback then
                            onTapCallback()
                        end
                        dragging = false
                    end
                end)
            end
        end)

        triggerObj.InputChanged:Connect(function(input)
            if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and dragging then
                local delta = input.Position - dragStart
                if delta.Magnitude > 6 then
                    moved = true
                end
                local cam = workspace.CurrentCamera
                local maxX = cam and cam.ViewportSize.X - 140 or 800
                local maxY = cam and cam.ViewportSize.Y - 50 or 600
                local newX = math.clamp(startPos.X.Offset + delta.X, -maxX / 2, maxX / 2)
                local newY = math.clamp(startPos.Y.Offset + delta.Y, 4, maxY)
                local newPos = UDim2.new(startPos.X.Scale, newX, startPos.Y.Scale, newY)
                pill.Position = newPos
                ExpandedIsland.Position = newPos
            end
        end)
    end

    local openCallback = function() toggleIsland(true) end
    attachDragAndClick(pill, pill, openCallback)
    attachDragAndClick(statusLbl, pill, openCallback)
    attachDragAndClick(expandHint, pill, openCallback)
    attachDragAndClick(ExpandedIsland, ExpandedIsland, nil)

    statusLbl:GetPropertyChangedSignal("Text"):Connect(function()
        if not statusLbl:GetAttribute("__Updating") and statusLbl.Text ~= statusLbl:GetAttribute("__LastTranslatedStatus") then
            updateStatusText(false)
        end
    end)
end

-- ==================== 5. NÚT TRÒN NỔI 1:1 & HEADER LOGO (GIỮ NGUYÊN) ====================
local function setupUnclippedCircularLogo(targetObj)
    local topPanel = targetObj
    while topPanel.Parent and topPanel.Parent:IsA("GuiObject") and not topPanel.Parent:IsA("ScreenGui") do
        topPanel = topPanel.Parent
    end

    if topPanel:GetAttribute("__FloatingLogoV5Perfect") then return end

    local sz = topPanel.AbsoluteSize
    local pos = topPanel.AbsolutePosition
    if sz.X > 105 or sz.Y > 105 or sz.X < 28 or math.abs(sz.X - sz.Y) > 25 or pos.X > 350 then
        return
    end

    topPanel:SetAttribute("__FloatingLogoV5Perfect", true)
    local container = topPanel

    for _, child in ipairs(container:GetDescendants()) do
        if child:IsA("UIPadding") or child:IsA("UIAspectRatioConstraint") or child:IsA("UISizeConstraint") then
            if child.Name ~= "PerfectCircleAspect" then
                pcall(function() child:Destroy() end)
            end
        end
        if (child:IsA("ImageLabel") or child:IsA("ImageButton")) and child.Name ~= "ChilliV5CoverLogo" then
            child.ImageTransparency = 1
            child.BackgroundTransparency = 1
        elseif child:IsA("TextLabel") or child:IsA("TextButton") then
            child:SetAttribute("__HiddenVxLogo", true)
            child.TextTransparency = 1
            child.BackgroundTransparency = 1
        end
    end

    if container:IsA("ImageLabel") or container:IsA("ImageButton") then
        container.ImageTransparency = 1
    elseif container:IsA("TextLabel") or container:IsA("TextButton") then
        container:SetAttribute("__HiddenVxLogo", true)
        container.TextTransparency = 1
    end

    container.Size = UDim2.new(0, 60, 0, 60)
    container.BackgroundColor3 = LOGO_BG_COLOR
    container.BackgroundTransparency = 0
    container.BorderSizePixel = 0
    container.ClipsDescendants = true

    local aspect = container:FindFirstChild("PerfectCircleAspect") or Instance.new("UIAspectRatioConstraint")
    aspect.Name = "PerfectCircleAspect"
    aspect.AspectRatio = 1
    aspect.Parent = container

    local cCorner = container:FindFirstChildOfClass("UICorner") or Instance.new("UICorner")
    cCorner.CornerRadius = UDim.new(1, 0)
    cCorner.Parent = container

    if not container:GetAttribute("__SizeLocked") then
        container:SetAttribute("__SizeLocked", true)
        container:GetPropertyChangedSignal("Size"):Connect(function()
            if container.Size ~= UDim2.new(0, 60, 0, 60) then
                container.Size = UDim2.new(0, 60, 0, 60)
            end
        end)
    end

    local stroke = container:FindFirstChild("RainbowBorder") or Instance.new("UIStroke")
    stroke.Name = "RainbowBorder"
    stroke.Thickness = 2.5
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Parent = container

    local strokeGrad = stroke:FindFirstChildOfClass("UIGradient") or Instance.new("UIGradient")
    strokeGrad.Color = COLOR_SEQ_RAINBOW
    strokeGrad.Parent = stroke
    table.insert(ActiveGradients, strokeGrad)

    local coverLogo = container:FindFirstChild("ChilliV5CoverLogo") or Instance.new("ImageLabel")
    coverLogo.Name = "ChilliV5CoverLogo"
    coverLogo.Size = UDim2.new(1, 0, 1, 0)
    coverLogo.Position = UDim2.new(0.5, 0, 0.5, 0)
    coverLogo.AnchorPoint = Vector2.new(0.5, 0.5)
    coverLogo.BackgroundTransparency = 1
    coverLogo.Image = CHILLI_LOGO_ID
    coverLogo.ImageTransparency = 0
    coverLogo.ScaleType = Enum.ScaleType.Fit
    coverLogo.Active = false
    coverLogo.ZIndex = container.ZIndex + 5
    coverLogo.Parent = container

    local logoCorner = coverLogo:FindFirstChildOfClass("UICorner") or Instance.new("UICorner")
    logoCorner.CornerRadius = UDim.new(1, 0)
    logoCorner.Parent = coverLogo
end

local function patchHeaderLogoLeftOfTitle(headerContainer, titleLbl)
    if not headerContainer or not titleLbl then return end
    local headerY = titleLbl.AbsolutePosition.Y
    local titleX = titleLbl.AbsolutePosition.X

    for _, item in ipairs(headerContainer:GetDescendants()) do
        if item ~= titleLbl and item:IsA("GuiObject") and item.Name ~= "ChilliHeaderLogo" then
            local pos = item.AbsolutePosition
            local sz = item.AbsoluteSize
            if math.abs(pos.Y - headerY) < 35 and pos.X < titleX and sz.X >= 10 and sz.X <= 45 then
                if item:IsA("ImageLabel") or item:IsA("ImageButton") then
                    item.Image = CHILLI_LOGO_ID
                    item.ImageTransparency = 0
                    item.BackgroundTransparency = 1
                    item.ScaleType = Enum.ScaleType.Fit
                elseif item:IsA("TextLabel") or item:IsA("TextButton") then
                    item:SetAttribute("__HiddenVxLogo", true)
                    item.TextTransparency = 1
                    local holder = item.Parent
                    if holder and not holder:FindFirstChild("ChilliHeaderLogo") then
                        local hLogo = Instance.new("ImageLabel")
                        hLogo.Name = "ChilliHeaderLogo"
                        hLogo.Size = UDim2.new(0, 24, 0, 24)
                        hLogo.Position = UDim2.new(0.5, 0, 0.5, 0)
                        hLogo.AnchorPoint = Vector2.new(0.5, 0.5)
                        hLogo.BackgroundTransparency = 1
                        hLogo.Image = CHILLI_LOGO_ID
                        hLogo.ScaleType = Enum.ScaleType.Fit
                        hLogo.ZIndex = item.ZIndex + 2
                        hLogo.Parent = holder
                    end
                end
            end
        end
    end
end

-- ==================== 6. BỘ QUÉT BẤT TỬ (CHỐNG TRỄ KHI REJOIN & BẮT 100% FPS ẢO) ====================
local function patchVenyxScreenGui(gui, titleLbl)
    if titleLbl.Text ~= NEW_TITLE then
        titleLbl.Text = NEW_TITLE
        titleLbl.AutomaticSize = Enum.AutomaticSize.X
    end

    local mainWindow = nil
    local curr = titleLbl
    while curr.Parent and curr.Parent ~= gui do
        curr = curr.Parent
        if curr:IsA("GuiObject") and curr.AbsoluteSize.X >= 350 and curr.AbsoluteSize.Y >= 220 then
            mainWindow = curr
        end
    end

    local headerY = titleLbl.AbsolutePosition.Y

    if mainWindow then
        patchHeaderLogoLeftOfTitle(mainWindow, titleLbl)
    end

    for _, topChild in ipairs(gui:GetChildren()) do
        if topChild:IsA("GuiObject")
        and topChild ~= mainWindow
        and topChild.Name ~= "ChilliV5_ExpandedIsland"
        and not topChild:FindFirstChild("IslandExpandHint") then
            setupUnclippedCircularLogo(topChild)
        end
    end

    local allDescendants = gui:GetDescendants()
    local pendingTextQueue = {}

    for i = 1, #allDescendants do
        local desc = allDescendants[i]
        if desc:IsA("TextLabel") or desc:IsA("TextButton") or desc:IsA("TextBox") then
            local txt = desc.Text or ""
            local origTxt = desc:GetAttribute("OrigRawText") or ""
            local isAlreadyMovedIdle = desc:GetAttribute("__IslandDone")

            local isStatusKeyword = txt:lower():find("idle", 1, true)
                or origTxt:lower():find("idle", 1, true)
                or txt == "Đang rảnh"

            local isHeaderIdle = (not gui:GetAttribute("__IslandLocked"))
                and (not desc:FindFirstAncestorOfClass("ScrollingFrame"))
                and desc.Parent
                and (not titleLbl:IsDescendantOf(desc.Parent))
                and math.abs(desc.AbsolutePosition.Y - headerY) < 35
                and desc.AbsolutePosition.X > titleLbl.AbsolutePosition.X + 60
                and isStatusKeyword

            if isHeaderIdle or isAlreadyMovedIdle then
                gui:SetAttribute("__IslandLocked", true)
                setupDynamicIslandFromStatus(desc, gui)
            elseif isFpsCounterText(txt) then
                hookFakeFpsCounter(desc)
            elseif not desc:GetAttribute("__TransHooked") then
                pendingTextQueue[#pendingTextQueue + 1] = desc
            end

        elseif (desc:IsA("ImageLabel") or desc:IsA("ImageButton"))
        and desc.Name ~= "ChilliV5CoverLogo"
        and desc.Name ~= "ChilliHeaderLogo"
        and desc.Name ~= "InnerChilliLogo" then
            if not desc:FindFirstAncestorOfClass("ScrollingFrame") then
                if mainWindow and not desc:IsDescendantOf(mainWindow) then
                    setupUnclippedCircularLogo(desc)
                end
            end
        end
    end

    if #pendingTextQueue > 0 and not gui:GetAttribute("__BatchTranslating") then
        gui:SetAttribute("__BatchTranslating", true)
        task.spawn(function()
            for idx = 1, #pendingTextQueue do
                local item = pendingTextQueue[idx]
                if item and item.Parent then
                    hookTextForTranslation(item)
                end
                if idx % 45 == 0 then
                    task.wait()
                end
            end
            gui:SetAttribute("__BatchTranslating", false)
        end)
    end
end

local venyxMainPatched = false

local function attachScreenGuiListeners(gui)
    if not gui:IsA("ScreenGui") or IGNORED_GUI_NAMES[gui.Name] then return end
    if gui:GetAttribute("__GlobalTextListener") then return end
    gui:SetAttribute("__GlobalTextListener", true)

    gui.DescendantAdded:Connect(function(newDesc)
        if newDesc:IsA("TextLabel") or newDesc:IsA("TextButton") or newDesc:IsA("TextBox") then
            task.defer(function()
                if not newDesc:IsA("TextBox") and isFpsCounterText(newDesc.Text) then
                    hookFakeFpsCounter(newDesc)
                else
                    hookTextForTranslation(newDesc)
                end
            end)
        end
    end)
end

local function tryPatchVenyx()
    for _, root in ipairs(scanRoots) do
        if root then
            for _, gui in ipairs(root:GetChildren()) do
                if gui:IsA("ScreenGui") and not IGNORED_GUI_NAMES[gui.Name] then
                    attachScreenGuiListeners(gui)

                    local titleLbl = nil
                    local descendants = gui:GetDescendants()

                    for i = 1, #descendants do
                        local d = descendants[i]
                        if d:IsA("TextLabel") or d:IsA("TextButton") then
                            local t = d.Text
                            if isFpsCounterText(t) then
                                hookFakeFpsCounter(d)
                            elseif (t == "VENYX" or t == NEW_TITLE) and not d:FindFirstAncestorOfClass("ScrollingFrame") then
                                titleLbl = d
                            end
                        end
                    end

                    if titleLbl then
                        venyxMainPatched = true
                        patchVenyxScreenGui(gui, titleLbl)
                    end
                end
            end
        end
    end
end

-- Lắng nghe mọi ScreenGui mới được tạo ra bất kỳ lúc nào (Kể cả khi Rejoin tải chậm)
for _, root in ipairs(scanRoots) do
    if root then
        root.ChildAdded:Connect(function(child)
            if child:IsA("ScreenGui") and not IGNORED_GUI_NAMES[child.Name] then
                attachScreenGuiListeners(child)
                task.wait(0.15)
                pcall(tryPatchVenyx)
            end
        end)
    end
end

-- Quét liên tục đến khi bắt được Venyx (tối đa 60 giây cho trường hợp Rejoin mạng chậm)
-- Sau khi đã bắt được Venyx thì duy trì kiểm tra nhẹ mỗi 1.5s để không bao giờ rớt FPS ảo
pcall(tryPatchVenyx)
task.spawn(function()
    local elapsed = 0
    while not venyxMainPatched and elapsed < 60 do
        task.wait(0.35)
        elapsed = elapsed + 0.35
        pcall(tryPatchVenyx)
    end
    while true do
        task.wait(1.5)
        pcall(tryPatchVenyx)
    end
end)
]===]

-- LƯU BẢN MỚI NHẤT VÀO MÁY NGAY LẬP TỨC ĐỂ KHI REJOIN LUÔN CHẠY BẢN MỚI NHẤT
if writefile then
    pcall(function()
        local selfReplicatingWrapper = "local CHILLI_CORE_PAYLOAD = [===[" .. CHILLI_CORE_PAYLOAD .. "]===]\n" .. [[
if writefile then
    pcall(function()
        writefile("ChilliHubV5_AutoRun.lua", "local CHILLI_CORE_PAYLOAD = [===[" .. CHILLI_CORE_PAYLOAD .. "]===]\nloadstring(CHILLI_CORE_PAYLOAD)()")
    end)
end
loadstring(CHILLI_CORE_PAYLOAD)()
]]
        writefile(AUTO_RUN_FILE, selfReplicatingWrapper)
    end)
end

loadstring(CHILLI_CORE_PAYLOAD)()
