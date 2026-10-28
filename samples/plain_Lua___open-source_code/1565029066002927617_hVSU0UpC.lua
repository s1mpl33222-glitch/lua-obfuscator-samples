local Players = game:GetService("Players")
local ts = game:GetService("TweenService")
local uis = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local SoundService = game:GetService("SoundService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local ChatService = game:GetService("Chat")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local StarterGui = game:GetService("StarterGui")
local TextService = game:GetService("TextService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local mouse = player:GetMouse()
local uiParent = gethui and gethui() or CoreGui or playerGui

local SHOW_GROUP_PROMPT = true
local GROUP_ID = 810506621
local MAX_MSG_LEN = 170
local STICKER_COOLDOWN = 20
local BOT_INTERVAL = 600
local SEND_COOLDOWN = 0.6
local ANIMATION_DURATION = 15
local FETCH_INTERVAL = 0.4
local ONLINE_REFRESH = 5
local ONLINE_FRESH_SECONDS = 30
local PLAYERS_LIST_INTERVAL = 3

local MY_PLACE_ID = game.PlaceId
local MY_JOB_ID = game.JobId
if MY_JOB_ID == "" then MY_JOB_ID = "Default_" .. tostring(math.random(1000, 9999)) end

local FIREBASE_URL = "https://genonchatdb-default-rtdb.asia-southeast1.firebasedatabase.app/Chat.json"
local ONLINE_URL = "https://genonchatdb-default-rtdb.asia-southeast1.firebasedatabase.app/Online/"
local httpReq = nil
if syn and syn.request then httpReq = syn.request
elseif http and http.request then httpReq = http.request
elseif request then httpReq = request
elseif http_request then httpReq = http_request end

local CUSTOM_NAMES = {
    ["far3on_egy1"] = "ּڣـــڔ؏ـــۏنۨ",
    ["jonujn8"] = "JONUJN8",
}
local CREATOR_ACCOUNTS = { ["far3on_egy1"] = true }
local RAINBOW_ACCOUNTS = { ["far3on_egy1"] = true, ["jonujn8"] = true }
local MOD_ACCOUNTS = { ["far3on_egy1"] = true, ["jonujn8"] = true }

local function getDisplayName(name) return CUSTOM_NAMES[string.lower(name)] or name end
local function isCreator(name) return CREATOR_ACCOUNTS[string.lower(name)] == true end
local function isRainbow(name) return RAINBOW_ACCOUNTS[string.lower(name)] == true end
local function isModerator(name) return MOD_ACCOUNTS[string.lower(name)] == true end

local FAR3ON_OWNER_NAME = "far3on_egy1"
local FAR3ON_OWNER_USERID = 8715622985
local function isFar3onOwner(name, userId)
    if name and string.lower(name) == FAR3ON_OWNER_NAME then return true end
    if userId and tostring(userId) == tostring(FAR3ON_OWNER_USERID) then return true end
    return false
end

for _, name in ipairs({"Far3onChatGui", "Far3onOverlayGui", "Far3onNotifications", "BanScreen", 
                       "Far3onJoinFlash", "Far3onJoinBanner", "Far3onPlayerPopup", "Far3onPlayersMenu"}) do
    local old = uiParent:FindFirstChild(name)
    if old then old:Destroy() end
end
if Lighting:FindFirstChild("RinkazeBlurEffect") then Lighting.RinkazeBlurEffect:Destroy() end

local BANNED_USERS = {
    ["aura_sky08"] = "تم حظرك من قبل المطور",
    ["lognnxnxnx"] = "تم حظرك من قبل المطور",
}
local isUserBanned = BANNED_USERS[string.lower(player.Name)] ~= nil

if isUserBanned then
    local BanScreen = Instance.new("ScreenGui")
    BanScreen.Name = "BanScreen"; BanScreen.Parent = uiParent
    BanScreen.ResetOnSpawn = false; BanScreen.IgnoreGuiInset = true; BanScreen.DisplayOrder = 999999
    local bg = Instance.new("Frame", BanScreen)
    bg.Size = UDim2.new(1,0,1,0); bg.BackgroundColor3 = Color3.fromRGB(0,0,0); bg.BackgroundTransparency = 0.8
    local frame = Instance.new("Frame", BanScreen)
    frame.Size = UDim2.new(0,400,0,280); frame.Position = UDim2.new(0.5,-200,0.5,-140)
    frame.BackgroundColor3 = Color3.fromRGB(18,18,28)
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0,16)
    local stroke = Instance.new("UIStroke", frame); stroke.Color = Color3.fromRGB(255,50,50); stroke.Thickness = 2
    local title = Instance.new("TextLabel", frame)
    title.Size = UDim2.new(1,-30,0,40); title.Position = UDim2.new(0,15,0,30); title.BackgroundTransparency = 1
    title.Text = "⛔ BANNED"; title.TextColor3 = Color3.fromRGB(255,80,80); title.Font = Enum.Font.GothamBlack; title.TextSize = 22
    local reasonLbl = Instance.new("TextLabel", frame)
    reasonLbl.Size = UDim2.new(1,-30,0,60); reasonLbl.Position = UDim2.new(0,15,0,80); reasonLbl.BackgroundTransparency = 1
    reasonLbl.Text = BANNED_USERS[string.lower(player.Name)]; reasonLbl.TextColor3 = Color3.fromRGB(255,200,200)
    reasonLbl.Font = Enum.Font.GothamBold; reasonLbl.TextSize = 14; reasonLbl.TextWrapped = true
    local closeBtn = Instance.new("TextButton", frame)
    closeBtn.Size = UDim2.new(0.4,0,0,35); closeBtn.Position = UDim2.new(0.3,0,1,-50); closeBtn.BackgroundColor3 = Color3.fromRGB(200,40,40)
    closeBtn.Text = "Close"; closeBtn.TextColor3 = Color3.fromRGB(255,255,255); closeBtn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0,8)
    closeBtn.MouseButton1Down:Connect(function() BanScreen:Destroy() end)
    return
end

if SHOW_GROUP_PROMPT then
    pcall(function() game:GetService("GroupService"):PromptJoinAsync(GROUP_ID) end)
end

task.spawn(function()
    task.wait(2)
    if ReplicatedStorage:FindFirstChild("RE") then
        local REFolder = ReplicatedStorage.RE
        local RPNameColorRemote = REFolder:FindFirstChild("1RPNam1eColo1r")
        local RPBioColorRemote = REFolder:FindFirstChild("1RPNam1eColo1r")
        local RPNameTextRemote = REFolder:FindFirstChild("1RPNam1eTex1t")
        local RPBioTextRemote = REFolder:FindFirstChild("1RPNam1eTex1t")
        if RPNameColorRemote and RPBioColorRemote and RPNameTextRemote and RPBioTextRemote then
            local rpName = "F҉AR3O҉N CHAT"
            local displayName = player.DisplayName
            local rpBio = " - " .. displayName .. " - "
            local rpNameColor = Color3.fromRGB(255, 0, 0)
            local rpBioColor = Color3.fromRGB(0, 0, 0)
            pcall(function()
                RPNameColorRemote:FireServer("PickingRPNameColor", rpNameColor)
                RPBioColorRemote:FireServer("PickingRPBioColor", rpBioColor)
                RPNameTextRemote:FireServer("RolePlayName", rpName)
                RPBioTextRemote:FireServer("RolePlayBio", rpBio)
            end)
        end
    end
end)

local soundMuted = true
local notificationsEnabled = true

local function makeSound(id, vol)
    local s = Instance.new("Sound"); s.SoundId = "rbxassetid://" .. id; s.Volume = vol; s.Parent = SoundService; return s
end
local soundClick = makeSound("6026986221", 1)
local soundMsg = makeSound("6026986221", 0.85)
local soundNotif = makeSound("4590662766", 1)
local soundPopup = makeSound("8740452945", 0.6)

local function playSound(snd)
    if soundMuted then return end
    pcall(function() snd:Play() end)
end

local ROBLOX_NAME_COLORS = {
    Color3.fromRGB(196, 40, 28), Color3.fromRGB(13, 105, 172), Color3.fromRGB(39, 70, 45),
    Color3.fromRGB(45, 45, 45), Color3.fromRGB(194, 101, 21), Color3.fromRGB(133, 142, 2),
    Color3.fromRGB(245, 205, 47), Color3.fromRGB(98, 37, 209), Color3.fromRGB(255, 140, 26),
    Color3.fromRGB(0, 162, 255),
}
local function getPlayerColor(name)
    local lower = string.lower(name)
    if isCreator(lower) or isRainbow(lower) then return Color3.fromRGB(255, 215, 0) end
    local hash = 0
    for i = 1, #name do hash = (hash * 31 + string.byte(name, i)) % 2147483647 end
    return ROBLOX_NAME_COLORS[(hash % #ROBLOX_NAME_COLORS) + 1]
end
local function colorHex(c) return string.format("#%02X%02X%02X", math.floor(c.R*255), math.floor(c.G*255), math.floor(c.B*255)) end

local function showBubble(senderName, text)
    local plr = Players:FindFirstChild(senderName); if not plr then return end
    local char = plr.Character; if not char then return end
    local head = char:FindFirstChild("Head"); if not head then return end
    local isStk = string.sub(text, 1, 8) == "rbxthumb" or string.sub(text, 1, 4) == "http"
    if isStk then return end
    pcall(function() ChatService:Chat(head, text, Enum.ChatColor.White) end)
end

local function httpPost(data)
    if not httpReq then pcall(function() HttpService:PostAsync(FIREBASE_URL, HttpService:JSONEncode(data)) end) return end
    pcall(function()
        httpReq({Url = FIREBASE_URL, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = HttpService:JSONEncode(data)})
    end)
end

local function httpGet()
    if not httpReq then
        local ok, res = pcall(function() return HttpService:GetAsync(FIREBASE_URL .. "?orderBy=\"$key\"&limitToLast=20") end)
        if ok then return res end; return nil
    end
    local ok, res = pcall(function() return httpReq({Url = FIREBASE_URL .. "?orderBy=\"$key\"&limitToLast=20", Method = "GET"}) end)
    if ok and res and (res.Body or res.body) then return res.Body or res.body end; return nil
end
print("[FAR3ON LOCAL V0.5] Firebase mode:", httpReq ~= nil)

local function broadcast(data)
    data.ServerJobId = MY_JOB_ID
    data.PlaceId = MY_PLACE_ID
    httpPost(data)
end

local function updateOnline()
    if not httpReq then return end
    pcall(function()
        httpReq({
            Url = ONLINE_URL .. player.UserId .. ".json",
            Method = "PUT",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode({
                name = player.Name,
                displayName = getDisplayName(player.Name),
                jobId = MY_JOB_ID,
                placeId = MY_PLACE_ID,
                serverId = MY_JOB_ID,
                time = os.time()
            })
        })
    end)
end

task.spawn(function()
    task.wait(1)
    while true do
        updateOnline()
        task.wait(ONLINE_REFRESH)
    end
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Far3onChatGui"; ScreenGui.Parent = uiParent
ScreenGui.ResetOnSpawn = false; ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 50

local OverlayGui = Instance.new("ScreenGui")
OverlayGui.Name = "Far3onOverlayGui"; OverlayGui.Parent = uiParent
OverlayGui.ResetOnSpawn = false; OverlayGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
OverlayGui.DisplayOrder = 99999

local Window = Instance.new("Frame")
Window.Name = "Window"; Window.Size = UDim2.new(0, 335, 0, 235)
Window.Position = UDim2.new(0.5, -180, 0.5, -130)
Window.BackgroundColor3 = Color3.fromRGB(30, 8, 8); Window.BackgroundTransparency = 0.45
Window.BorderSizePixel = 0; Window.Parent = ScreenGui; Window.Visible = true

local Shadow = Instance.new("ImageLabel", Window)
Shadow.Size = UDim2.new(1, 24, 1, 24); Shadow.Position = UDim2.new(0, -12, 0, -12)
Shadow.BackgroundTransparency = 1; Shadow.Image = "rbxassetid://1316045217"; Shadow.ImageColor3 = Color3.fromRGB(0,0,0)
Shadow.ImageTransparency = 0.4; Shadow.ScaleType = Enum.ScaleType.Slice; Shadow.SliceCenter = Rect.new(10,10,118,118); Shadow.ZIndex = 0
Instance.new("UICorner", Window).CornerRadius = UDim.new(0,12)
local wStroke = Instance.new("UIStroke", Window)
wStroke.Color = Color3.fromRGB(255, 50, 50); wStroke.Thickness = 2; wStroke.Transparency = 0.2

local TitleBar = Instance.new("Frame", Window)
TitleBar.Size = UDim2.new(1, 0, 0, 40); TitleBar.BackgroundTransparency = 1

-- FAR3ON White + Red Wave Animation
local Title = Instance.new("TextLabel", TitleBar)
Title.Size = UDim2.new(0, 110, 1, 0); Title.Position = UDim2.new(0, 15, 0, 0); Title.BackgroundTransparency = 1
Title.Text = "FAR3ON"; Title.TextColor3 = Color3.fromRGB(255, 255, 255); Title.Font = Enum.Font.GothamBlack
Title.TextSize = 17; Title.TextXAlignment = Enum.TextXAlignment.Left
Title.RichText = true

task.spawn(function()
    while Title and Title.Parent do
        local baseTime = tick() * 2.5
        local chars = {}
        for i = 1, #"FAR3ON" do
            local char = string.sub("FAR3ON", i, i)
            if char == " " then
                table.insert(chars, " ")
            else
                local wave = math.sin(baseTime + i * 0.9)
                local intensity = math.floor((wave + 1) / 2 * 180 + 75)
                local r = 255
                local g = math.max(255 - intensity, 75)
                local b = math.max(255 - intensity, 75)
                table.insert(chars, string.format("<font color='#%02X%02X%02X'>%s</font>", r, g, b, char))
            end
        end
        Title.Text = table.concat(chars)
        task.wait(0.04)
    end
end)

local ChatVersionLbl = Instance.new("TextLabel", TitleBar)
ChatVersionLbl.Size = UDim2.new(0, 72, 0, 16)
ChatVersionLbl.Position = UDim2.new(0, 100, 0, 12)
ChatVersionLbl.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
ChatVersionLbl.BackgroundTransparency = 0.3
ChatVersionLbl.BorderSizePixel = 0
ChatVersionLbl.Text = "CHAT V0.5"
ChatVersionLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
ChatVersionLbl.Font = Enum.Font.GothamBold
ChatVersionLbl.TextSize = 9
ChatVersionLbl.ZIndex = 3
Instance.new("UICorner", ChatVersionLbl).CornerRadius = UDim.new(0, 4)

local function makeTitleBtn(text, xOff, bgColor)
    local b = Instance.new("TextButton", TitleBar)
    b.Size = UDim2.new(0, 28, 0, 28); b.Position = UDim2.new(1, xOff, 0, 6)
    b.BackgroundColor3 = bgColor or Color3.fromRGB(45, 50, 60); b.BorderSizePixel = 0
    b.Text = text; b.TextColor3 = Color3.fromRGB(255,255,255); b.Font = Enum.Font.GothamBold; b.TextSize = 15
    b.Active = true; b.Selectable = true; b.ZIndex = 3
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6); return b
end

local SettingsBtn = makeTitleBtn("⚙", -110)
local InfoBtn = makeTitleBtn("ℹ", -75)
local PlayersBtn = makeTitleBtn("👥", -42, Color3.fromRGB(180, 40, 40))
PlayersBtn.ZIndex = 3

local function fixMenuPos(menu, btn, width)
    local bp = btn.AbsolutePosition
    local bs = btn.AbsoluteSize
    local cam = workspace.CurrentCamera
    local screenW = cam.ViewportSize.X
    local screenH = cam.ViewportSize.Y
    local menuH = menu.AbsoluteSize.Y

    local targetX = bp.X + bs.X/2 - width/2
    local targetY = bp.Y + bs.Y + 5

    if targetY + menuH > screenH - 5 then targetY = bp.Y - menuH - 5 end
    if targetX < 5 then targetX = 5 end
    if targetX + width > screenW - 5 then targetX = screenW - width - 5 end
    if targetY < 5 then targetY = 5 end

    menu.Position = UDim2.fromOffset(targetX, targetY)
end

-- Forward declaration for createMessageButton
local createMessageButton

local InfoMenu = Instance.new("Frame")
InfoMenu.Size = UDim2.new(0, 240, 0, 300)
InfoMenu.BackgroundColor3 = Color3.fromRGB(25, 29, 36)
InfoMenu.BackgroundTransparency = 0.05
InfoMenu.BorderSizePixel = 0
InfoMenu.Visible = false
InfoMenu.ZIndex = 150
InfoMenu.Active = true
InfoMenu.Parent = OverlayGui
Instance.new("UICorner", InfoMenu).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", InfoMenu).Color = Color3.fromRGB(200, 40, 40)

local SquareImage = Instance.new("ImageLabel", InfoMenu)
SquareImage.Size = UDim2.new(0, 80, 0, 80)
SquareImage.Position = UDim2.new(0.5, -40, 0, 12)
SquareImage.BackgroundTransparency = 1
SquareImage.Image = "rbxassetid://81640651401616"
SquareImage.ZIndex = 151
SquareImage.Active = false

local RightsLabel = Instance.new("TextLabel", InfoMenu)
RightsLabel.Size = UDim2.new(1, 0, 0, 25)
RightsLabel.Position = UDim2.new(0, 0, 0, 98)
RightsLabel.BackgroundTransparency = 1
RightsLabel.Text = "حقوق: فرعون | Rights: FAR3ON"
RightsLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
RightsLabel.Font = Enum.Font.GothamBold
RightsLabel.TextSize = 13
RightsLabel.ZIndex = 151
RightsLabel.Active = false

local CopyPersonal = Instance.new("TextButton", InfoMenu)
CopyPersonal.Size = UDim2.new(1, -20, 0, 40)
CopyPersonal.Position = UDim2.new(0, 10, 0, 135)
CopyPersonal.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
CopyPersonal.BackgroundTransparency = 0.2
CopyPersonal.BorderSizePixel = 0
CopyPersonal.Text = "📋 Copy TikTok | نسخ\n@qxbrz"
CopyPersonal.TextColor3 = Color3.fromRGB(255, 255, 255)
CopyPersonal.TextSize = 11
CopyPersonal.Font = Enum.Font.GothamBold
CopyPersonal.ZIndex = 152
CopyPersonal.Active = true
CopyPersonal.Selectable = true
Instance.new("UICorner", CopyPersonal).CornerRadius = UDim.new(0, 6)

local CopyChat = Instance.new("TextButton", InfoMenu)
CopyChat.Size = UDim2.new(1, -20, 0, 40)
CopyChat.Position = UDim2.new(0, 10, 0, 182)
CopyChat.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
CopyChat.BackgroundTransparency = 0.2
CopyChat.BorderSizePixel = 0
CopyChat.Text = "📋 Copy Chat TikTok | نسخ\n@far3onchat"
CopyChat.TextColor3 = Color3.fromRGB(255, 255, 255)
CopyChat.TextSize = 11
CopyChat.Font = Enum.Font.GothamBold
CopyChat.ZIndex = 152
CopyChat.Active = true
CopyChat.Selectable = true
Instance.new("UICorner", CopyChat).CornerRadius = UDim.new(0, 6)

local CloseInfo = Instance.new("TextButton", InfoMenu)
CloseInfo.Size = UDim2.new(1, -20, 0, 34)
CloseInfo.Position = UDim2.new(0, 10, 1, -42)
CloseInfo.BackgroundColor3 = Color3.fromRGB(120, 30, 30)
CloseInfo.BorderSizePixel = 0
CloseInfo.Text = "✕ Close | إغلاق"
CloseInfo.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseInfo.Font = Enum.Font.GothamBold
CloseInfo.TextSize = 12
CloseInfo.ZIndex = 152
CloseInfo.Active = true
CloseInfo.Selectable = true
Instance.new("UICorner", CloseInfo).CornerRadius = UDim.new(0, 6)

CopyPersonal.MouseButton1Down:Connect(function()
    if setclipboard then
        setclipboard("qxbrz")
        CopyPersonal.Text = "✅ Copied! | تم النسخ\n@qxbrz"
        task.wait(1.5)
        CopyPersonal.Text = "📋 Copy TikTok | نسخ\n@qxbrz"
    end
end)
CopyChat.MouseButton1Down:Connect(function()
    if setclipboard then
        setclipboard("far3onchat")
        CopyChat.Text = "✅ Copied! | تم النسخ\n@far3onchat"
        task.wait(1.5)
        CopyChat.Text = "📋 Copy Chat TikTok | نسخ\n@far3onchat"
    end
end)
CloseInfo.MouseButton1Down:Connect(function()
    InfoMenu.Visible = false
end)

InfoBtn.MouseButton1Down:Connect(function()
    InfoMenu.Visible = not InfoMenu.Visible
    if InfoMenu.Visible then
        fixMenuPos(InfoMenu, InfoBtn, 240)
    end
    playSound(soundClick)
end)

local SettingsMenu = Instance.new("Frame")
SettingsMenu.Size = UDim2.new(0, 230, 0, 320)
SettingsMenu.BackgroundColor3 = Color3.fromRGB(22, 24, 30)
SettingsMenu.BackgroundTransparency = 0.05
SettingsMenu.BorderSizePixel = 0
SettingsMenu.Visible = false
SettingsMenu.ZIndex = 250
SettingsMenu.Active = true
SettingsMenu.Parent = OverlayGui
Instance.new("UICorner", SettingsMenu).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", SettingsMenu).Color = Color3.fromRGB(255, 60, 60)

local SMHeader = Instance.new("Frame", SettingsMenu)
SMHeader.Size = UDim2.new(1, 0, 0, 38)
SMHeader.BackgroundColor3 = Color3.fromRGB(30, 10, 10)
SMHeader.BackgroundTransparency = 0.2
SMHeader.BorderSizePixel = 0
SMHeader.ZIndex = 251
SMHeader.Active = false
Instance.new("UICorner", SMHeader).CornerRadius = UDim.new(0, 10)

local SMHeaderFix = Instance.new("Frame", SMHeader)
SMHeaderFix.Size = UDim2.new(1, 0, 0, 20)
SMHeaderFix.Position = UDim2.new(0, 0, 1, -20)
SMHeaderFix.BackgroundColor3 = Color3.fromRGB(30, 10, 10)
SMHeaderFix.BackgroundTransparency = 0.2
SMHeaderFix.BorderSizePixel = 0
SMHeaderFix.ZIndex = 251
SMHeaderFix.Active = false

local SMTitle = Instance.new("TextLabel", SMHeader)
SMTitle.Size = UDim2.new(1, -20, 1, 0)
SMTitle.Position = UDim2.new(0, 12, 0, 0)
SMTitle.BackgroundTransparency = 1
SMTitle.Text = "⚙  Settings | الإعدادات"
SMTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
SMTitle.Font = Enum.Font.GothamBold
SMTitle.TextSize = 13
SMTitle.TextXAlignment = Enum.TextXAlignment.Left
SMTitle.ZIndex = 252
SMTitle.Active = false

local function makeToggle(yPos, labelText, initialState, onToggle)
    local row = Instance.new("Frame", SettingsMenu)
    row.Size = UDim2.new(1, -16, 0, 40)
    row.Position = UDim2.new(0, 8, 0, yPos)
    row.BackgroundTransparency = 1
    row.ZIndex = 260

    local txtLbl = Instance.new("TextLabel", row)
    txtLbl.Size = UDim2.new(1, -52, 1, 0)
    txtLbl.Position = UDim2.new(0, 0, 0, 0)
    txtLbl.BackgroundTransparency = 1
    txtLbl.Text = labelText
    txtLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    txtLbl.Font = Enum.Font.GothamBold
    txtLbl.TextSize = 11
    txtLbl.TextXAlignment = Enum.TextXAlignment.Left
    txtLbl.TextTruncate = Enum.TextTruncate.AtEnd
    txtLbl.ZIndex = 261
    txtLbl.Active = false

    local track = Instance.new("Frame", row)
    track.Size = UDim2.new(0, 44, 0, 24)
    track.Position = UDim2.new(1, -44, 0.5, -12)
    track.BackgroundColor3 = Color3.fromRGB(72, 72, 84)
    track.BorderSizePixel = 0
    track.ZIndex = 262
    Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

    local thumb = Instance.new("Frame", track)
    thumb.Size = UDim2.new(0, 18, 0, 18)
    thumb.Position = UDim2.new(0, 3, 0.5, -9)
    thumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    thumb.BorderSizePixel = 0
    thumb.ZIndex = 263
    Instance.new("UICorner", thumb).CornerRadius = UDim.new(1, 0)

    local clickArea = Instance.new("TextButton", row)
    clickArea.Size = UDim2.new(1, 0, 1, 0)
    clickArea.BackgroundTransparency = 1
    clickArea.Text = ""
    clickArea.ZIndex = 264
    clickArea.Active = true
    clickArea.Selectable = true

    local currentState = initialState == true

    local function setState(state)
        currentState = state == true
        txtLbl.Text = labelText .. (currentState and "  [ON]" or "  [OFF]")
        track.BackgroundColor3 = currentState and Color3.fromRGB(46, 160, 100) or Color3.fromRGB(72, 72, 84)
        local targetPos = currentState and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
        pcall(function()
            ts:Create(thumb, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = targetPos}):Play()
        end)
    end

    clickArea.MouseButton1Down:Connect(function()
        local ok, newState = pcall(function()
            if onToggle then return onToggle(currentState) end
            return not currentState
        end)
        if ok and type(newState) == "boolean" then
            setState(newState)
        end
        playSound(soundClick)
    end)

    setState(currentState)
    return row, txtLbl, track, thumb
end

local function makeNormalButton(yPos, text, bgColor, onClick)
    local btn = Instance.new("TextButton", SettingsMenu)
    btn.Size = UDim2.new(1, -16, 0, 34)
    btn.Position = UDim2.new(0, 8, 0, yPos)
    btn.BackgroundColor3 = bgColor or Color3.fromRGB(35, 38, 48)
    btn.BackgroundTransparency = 0.1
    btn.BorderSizePixel = 0
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.AutoButtonColor = false
    btn.Active = true
    btn.Selectable = true
    btn.ZIndex = 260
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 7)

    local stroke = Instance.new("UIStroke", btn)
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Thickness = 1
    stroke.Transparency = 0.88
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.ZIndex = 260

    btn.MouseEnter:Connect(function() btn.BackgroundTransparency = 0 end)
    btn.MouseLeave:Connect(function() btn.BackgroundTransparency = 0.1 end)

    btn.MouseButton1Down:Connect(function()
        if onClick then pcall(onClick, btn) end
        playSound(soundClick)
    end)

    return btn
end

local isChatFixed = false
local isButtonFixed = true

makeToggle(46, "🔒 Fix Chat | تثبيت الشات", isChatFixed, function()
    isChatFixed = not isChatFixed
    return isChatFixed
end)

makeToggle(92, "📌 Fix Button | تثبيت الزرار", isButtonFixed, function()
    isButtonFixed = not isButtonFixed
    return isButtonFixed
end)

makeToggle(138, "🔊 Sound | الصوت", not soundMuted, function()
    soundMuted = not soundMuted
    if not soundMuted then pcall(function() soundClick:Play() end) end
    return not soundMuted
end)

makeToggle(184, "🔔 Side Notif | الإشعارات", notificationsEnabled, function()
    notificationsEnabled = not notificationsEnabled
    return notificationsEnabled
end)

makeNormalButton(230, "📡 Server Info | معلومات السيرفر", Color3.fromRGB(60, 90, 140), function(btn)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "📡 معلومات السيرفر",
            Text = "JobId: " .. string.sub(MY_JOB_ID, 1, 30) .. "\nPlaceId: " .. tostring(MY_PLACE_ID),
            Duration = 8
        })
    end)
    if setclipboard then setclipboard(MY_JOB_ID) end
    if createMessageButton then
        createMessageButton("SYSTEM", "📡 JobId: " .. MY_JOB_ID .. " | PlaceId: " .. tostring(MY_PLACE_ID), true, false, nil, 0, false)
    end
end)

SettingsMenu.Size = UDim2.new(0, 230, 0, 320)
makeNormalButton(276, "✕ Close | إغلاق", Color3.fromRGB(80, 30, 30), function()
    SettingsMenu.Visible = false
end)

SettingsBtn.MouseButton1Down:Connect(function()
    SettingsMenu.Visible = not SettingsMenu.Visible
    if SettingsMenu.Visible then
        fixMenuPos(SettingsMenu, SettingsBtn, 230)
    end
    playSound(soundClick)
end)

local function updateMenuPositions()
    pcall(function()
        if InfoMenu.Visible then fixMenuPos(InfoMenu, InfoBtn, 240) end
        if SettingsMenu.Visible then fixMenuPos(SettingsMenu, SettingsBtn, 230) end
    end)
end

Window:GetPropertyChangedSignal("AbsolutePosition"):Connect(updateMenuPositions)
Window:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateMenuPositions)

-- ==========================================
-- PLAYERS MENU (Compact: 260x290)
-- ==========================================
local PlayersMenu = Instance.new("Frame")
PlayersMenu.Name = "Far3onPlayersMenu"
PlayersMenu.Size = UDim2.new(0, 260, 0, 290)
PlayersMenu.Position = UDim2.new(0.5, -130, 0.5, -145)
PlayersMenu.BackgroundColor3 = Color3.fromRGB(18, 8, 8)
PlayersMenu.BackgroundTransparency = 0.05
PlayersMenu.BorderSizePixel = 0
PlayersMenu.Visible = false
PlayersMenu.ZIndex = 200
PlayersMenu.Active = true
PlayersMenu.Parent = OverlayGui
Instance.new("UICorner", PlayersMenu).CornerRadius = UDim.new(0, 12)
Instance.new("UIStroke", PlayersMenu).Color = Color3.fromRGB(220, 40, 40); PlayersMenu.UIStroke.Thickness = 1.5

local PMHeader = Instance.new("Frame", PlayersMenu)
PMHeader.Size = UDim2.new(1, 0, 0, 38)
PMHeader.BackgroundColor3 = Color3.fromRGB(40, 10, 10)
PMHeader.BackgroundTransparency = 0.1
PMHeader.BorderSizePixel = 0
PMHeader.ZIndex = 201
Instance.new("UICorner", PMHeader).CornerRadius = UDim.new(0, 12)

local PMHeaderFix = Instance.new("Frame", PMHeader)
PMHeaderFix.Size = UDim2.new(1, 0, 0, 19)
PMHeaderFix.Position = UDim2.new(0, 0, 1, -19)
PMHeaderFix.BackgroundColor3 = Color3.fromRGB(40, 10, 10)
PMHeaderFix.BackgroundTransparency = 0.1
PMHeaderFix.BorderSizePixel = 0
PMHeaderFix.ZIndex = 201

local PMTitle = Instance.new("TextLabel", PMHeader)
PMTitle.Size = UDim2.new(1, -70, 1, 0)
PMTitle.Position = UDim2.new(0, 14, 0, 0)
PMTitle.BackgroundTransparency = 1
PMTitle.Text = "👥 Players"
PMTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
PMTitle.Font = Enum.Font.GothamBold
PMTitle.TextSize = 13
PMTitle.TextXAlignment = Enum.TextXAlignment.Left
PMTitle.ZIndex = 202

local PMClose = Instance.new("TextButton", PMHeader)
PMClose.Size = UDim2.new(0, 24, 0, 24)
PMClose.Position = UDim2.new(1, -28, 0.5, -12)
PMClose.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
PMClose.BorderSizePixel = 0
PMClose.Text = "✕"
PMClose.TextColor3 = Color3.fromRGB(255, 255, 255)
PMClose.Font = Enum.Font.GothamBold
PMClose.TextSize = 12
PMClose.ZIndex = 202
PMClose.Active = true
PMClose.Selectable = true
Instance.new("UICorner", PMClose).CornerRadius = UDim.new(0, 6)
PMClose.MouseButton1Down:Connect(function()
    PlayersMenu.Visible = false
end)

-- Tabs
local TabsContainer = Instance.new("Frame", PlayersMenu)
TabsContainer.Size = UDim2.new(1, -16, 0, 26)
TabsContainer.Position = UDim2.new(0, 8, 0, 42)
TabsContainer.BackgroundTransparency = 1
TabsContainer.ZIndex = 201
local tabsLayout = Instance.new("UIListLayout", TabsContainer)
tabsLayout.Padding = UDim.new(0, 5)
tabsLayout.FillDirection = Enum.FillDirection.Horizontal
tabsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local PMSubInfoContainer = Instance.new("Frame", PlayersMenu)
PMSubInfoContainer.Size = UDim2.new(1, -16, 0, 16)
PMSubInfoContainer.Position = UDim2.new(0, 8, 0, 72)
PMSubInfoContainer.BackgroundTransparency = 1
PMSubInfoContainer.ZIndex = 201

local PMDot = Instance.new("Frame", PMSubInfoContainer)
PMDot.Size = UDim2.new(0, 7, 0, 7)
PMDot.Position = UDim2.new(0, 0, 0.5, -3)
PMDot.BackgroundColor3 = Color3.fromRGB(46, 200, 100)
PMDot.BorderSizePixel = 0
PMDot.ZIndex = 202
Instance.new("UICorner", PMDot).CornerRadius = UDim.new(1, 0)

task.spawn(function()
    while PMDot and PMDot.Parent do
        pcall(function()
            PMDot.BackgroundTransparency = 0
            PMDot.Size = UDim2.new(0, 7, 0, 7)
            task.wait(0.4)
            ts:Create(PMDot, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0.7}):Play()
            ts:Create(PMDot, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 10, 0, 10)}):Play()
            task.wait(0.4)
            PMDot.Size = UDim2.new(0, 7, 0, 7)
            PMDot.Position = UDim2.new(0, 0, 0.5, -3)
        end)
    end
end)

local PMSubInfo = Instance.new("TextLabel", PMSubInfoContainer)
PMSubInfo.Size = UDim2.new(1, -15, 1, 0)
PMSubInfo.Position = UDim2.new(0, 13, 0, 0)
PMSubInfo.BackgroundTransparency = 1
PMSubInfo.Text = "Loading..."
PMSubInfo.TextColor3 = Color3.fromRGB(255, 180, 180)
PMSubInfo.Font = Enum.Font.Gotham
PMSubInfo.TextSize = 9
PMSubInfo.TextXAlignment = Enum.TextXAlignment.Left
PMSubInfo.ZIndex = 201

local PMList = Instance.new("ScrollingFrame", PlayersMenu)
PMList.Size = UDim2.new(1, -16, 1, -94)
PMList.Position = UDim2.new(0, 8, 0, 90)
PMList.BackgroundTransparency = 1
PMList.BorderSizePixel = 0
PMList.CanvasSize = UDim2.new(0,0,0,0)
PMList.AutomaticCanvasSize = Enum.AutomaticSize.Y
PMList.ScrollBarThickness = 4
PMList.ScrollBarImageColor3 = Color3.fromRGB(220, 40, 40)
PMList.ZIndex = 201
local pmListLayout = Instance.new("UIListLayout", PMList)
pmListLayout.Padding = UDim.new(0, 4)
pmListLayout.SortOrder = Enum.SortOrder.LayoutOrder

local currentTab = "server"

local ServerTabBtn = Instance.new("TextButton", TabsContainer)
ServerTabBtn.Size = UDim2.new(0, 118, 1, 0)
ServerTabBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
ServerTabBtn.BorderSizePixel = 0
ServerTabBtn.Text = "🟢 هذا السيرفر"
ServerTabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ServerTabBtn.Font = Enum.Font.GothamBold
ServerTabBtn.TextSize = 9
ServerTabBtn.ZIndex = 202
ServerTabBtn.Active = true
ServerTabBtn.Selectable = true
Instance.new("UICorner", ServerTabBtn).CornerRadius = UDim.new(0, 6)

local AllTabBtn = Instance.new("TextButton", TabsContainer)
AllTabBtn.Size = UDim2.new(0, 118, 1, 0)
AllTabBtn.BackgroundColor3 = Color3.fromRGB(50, 25, 25)
AllTabBtn.BorderSizePixel = 0
AllTabBtn.Text = "🌐 كل اللاعبين"
AllTabBtn.TextColor3 = Color3.fromRGB(200, 180, 180)
AllTabBtn.Font = Enum.Font.GothamBold
AllTabBtn.TextSize = 9
AllTabBtn.ZIndex = 202
AllTabBtn.Active = true
AllTabBtn.Selectable = true
Instance.new("UICorner", AllTabBtn).CornerRadius = UDim.new(0, 6)

local function setTabActive(tab)
    if tab == "server" then
        ServerTabBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
        ServerTabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        AllTabBtn.BackgroundColor3 = Color3.fromRGB(50, 25, 25)
        AllTabBtn.TextColor3 = Color3.fromRGB(200, 180, 180)
    else
        AllTabBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
        AllTabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        ServerTabBtn.BackgroundColor3 = Color3.fromRGB(50, 25, 25)
        ServerTabBtn.TextColor3 = Color3.fromRGB(200, 180, 180)
    end
end

local function createPlayerCard(p, parentList)
    local isMe = tostring(p.userId) == tostring(player.UserId)

    local row = Instance.new("Frame", parentList)
    row.Size = UDim2.new(1, 0, 0, 40)
    row.BackgroundColor3 = isMe and Color3.fromRGB(35, 20, 20) or Color3.fromRGB(30, 15, 15)
    row.BackgroundTransparency = 0.05
    row.BorderSizePixel = 0
    row.ZIndex = 202
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)

    local av = Instance.new("ImageLabel", row)
    av.Size = UDim2.new(0, 30, 0, 30)
    av.Position = UDim2.new(0, 5, 0.5, -15)
    av.BackgroundColor3 = Color3.fromRGB(50, 30, 30)
    av.BorderSizePixel = 0
    av.Image = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(p.userId) .. "&w=420&h=420"
    av.ZIndex = 203
    Instance.new("UICorner", av).CornerRadius = UDim.new(1, 0)
    Instance.new("UIStroke", av).Color = isMe and Color3.fromRGB(46, 200, 100) or Color3.fromRGB(220, 40, 40)

    local nameLbl = Instance.new("TextLabel", row)
    nameLbl.Size = UDim2.new(1, -90, 0, 13)
    nameLbl.Position = UDim2.new(0, 40, 0, 5)
    nameLbl.BackgroundTransparency = 1
    nameLbl.Text = getDisplayName(p.name) .. (isMe and "  (أنت)" or "")
    nameLbl.TextColor3 = getPlayerColor(p.name)
    nameLbl.Font = Enum.Font.GothamBold
    nameLbl.TextSize = 10
    nameLbl.TextXAlignment = Enum.TextXAlignment.Left
    nameLbl.TextTruncate = Enum.TextTruncate.AtEnd
    nameLbl.ZIndex = 203

    local subLbl = Instance.new("TextLabel", row)
    subLbl.Size = UDim2.new(1, -90, 0, 10)
    subLbl.Position = UDim2.new(0, 40, 0, 19)
    subLbl.BackgroundTransparency = 1
    subLbl.Text = "@" .. tostring(p.name) .. "  •  ID: " .. tostring(p.userId)
    subLbl.TextColor3 = Color3.fromRGB(180, 140, 140)
    subLbl.Font = Enum.Font.Gotham
    subLbl.TextSize = 8
    subLbl.TextXAlignment = Enum.TextXAlignment.Left
    subLbl.TextTruncate = Enum.TextTruncate.AtEnd
    subLbl.ZIndex = 203

    if isMe then
        local youBadge = Instance.new("TextLabel", row)
        youBadge.Size = UDim2.new(0, 38, 0, 18)
        youBadge.Position = UDim2.new(1, -44, 0.5, -9)
        youBadge.BackgroundColor3 = Color3.fromRGB(46, 160, 100)
        youBadge.BackgroundTransparency = 0.2
        youBadge.BorderSizePixel = 0
        youBadge.Text = "أنت"
        youBadge.TextColor3 = Color3.fromRGB(255, 255, 255)
        youBadge.Font = Enum.Font.GothamBold
        youBadge.TextSize = 8
        youBadge.ZIndex = 204
        Instance.new("UICorner", youBadge).CornerRadius = UDim.new(0, 5)
    end
end

local function refreshPlayersList()
    if not httpReq then return end
    if not PMList or not PMList.Parent then return end

    pcall(function()
        local res = httpReq({Url = ONLINE_URL .. ".json", Method = "GET"})
        if not (res and (res.Body or res.body)) then return end
        local body = res.Body or res.body
        if not body or body == "null" then return end
        local ok, data = pcall(function() return HttpService:JSONDecode(body) end)
        if not ok or type(data) ~= "table" then return end

        local now = os.time()
        local serverPlayers = {}
        local allPlayers = {}

        for uid, info in pairs(data) do
            if type(info) == "table" and info.time and (now - info.time) < ONLINE_FRESH_SECONDS then
                local entry = {
                    userId = uid,
                    name = info.name or "?",
                    displayName = info.displayName or info.name or "?",
                    jobId = info.jobId or "",
                    placeId = info.placeId
                }
                table.insert(allPlayers, entry)
                if tostring(info.jobId) == tostring(MY_JOB_ID) then
                    table.insert(serverPlayers, entry)
                end
            end
        end

        for _, child in pairs(PMList:GetChildren()) do
            if child:IsA("Frame") or child:IsA("TextLabel") then child:Destroy() end
        end

        if currentTab == "server" then
            PMSubInfo.Text = #serverPlayers .. " players in this server"
            if #serverPlayers == 0 then
                local emptyLbl = Instance.new("TextLabel", PMList)
                emptyLbl.Size = UDim2.new(1, 0, 0, 40)
                emptyLbl.BackgroundTransparency = 1
                emptyLbl.Text = "😴 Nobody else here"
                emptyLbl.TextColor3 = Color3.fromRGB(150, 130, 130)
                emptyLbl.Font = Enum.Font.GothamBold
                emptyLbl.TextSize = 10
                emptyLbl.ZIndex = 202
                return
            end
            table.sort(serverPlayers, function(a, b) return tostring(a.userId) < tostring(b.userId) end)
            for _, p in ipairs(serverPlayers) do
                createPlayerCard(p, PMList)
            end
        else
            PMSubInfo.Text = #allPlayers .. " total players online"
            if #allPlayers == 0 then
                local emptyLbl = Instance.new("TextLabel", PMList)
                emptyLbl.Size = UDim2.new(1, 0, 0, 40)
                emptyLbl.BackgroundTransparency = 1
                emptyLbl.Text = "😴 Nobody online"
                emptyLbl.TextColor3 = Color3.fromRGB(150, 130, 130)
                emptyLbl.Font = Enum.Font.GothamBold
                emptyLbl.TextSize = 10
                emptyLbl.ZIndex = 202
                return
            end
            table.sort(allPlayers, function(a, b) return tostring(a.userId) < tostring(b.userId) end)
            for _, p in ipairs(allPlayers) do
                createPlayerCard(p, PMList)
            end
        end
    end)
end

ServerTabBtn.MouseButton1Down:Connect(function()
    if currentTab == "server" then return end
    currentTab = "server"
    setTabActive("server")
    refreshPlayersList()
    playSound(soundClick)
end)

AllTabBtn.MouseButton1Down:Connect(function()
    if currentTab == "all" then return end
    currentTab = "all"
    setTabActive("all")
    refreshPlayersList()
    playSound(soundClick)
end)

PlayersBtn.MouseButton1Down:Connect(function()
    PlayersMenu.Visible = not PlayersMenu.Visible
    if PlayersMenu.Visible then
        currentTab = "server"
        setTabActive("server")
        refreshPlayersList()
        playSound(soundClick)
    end
end)

task.spawn(function()
    task.wait(3)
    while true do
        if PlayersMenu.Visible then
            refreshPlayersList()
        end
        task.wait(PLAYERS_LIST_INTERVAL)
    end
end)

-- ==========================================
-- MESSAGES AREA
-- ==========================================
local MessagesFrame = Instance.new("ScrollingFrame", Window)
MessagesFrame.Size = UDim2.new(1, -20, 1, -105); MessagesFrame.Position = UDim2.new(0, 10, 0, 45)
MessagesFrame.BackgroundTransparency = 1; MessagesFrame.BorderSizePixel = 0
MessagesFrame.CanvasSize = UDim2.new(0,0,0,0); MessagesFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
MessagesFrame.ScrollBarThickness = 4; MessagesFrame.ScrollBarImageColor3 = Color3.fromRGB(200, 40, 40)
Instance.new("UIListLayout", MessagesFrame).Padding = UDim.new(0, 5)

local InputContainer = Instance.new("Frame", Window)
InputContainer.Size = UDim2.new(1, -20, 0, 40); InputContainer.Position = UDim2.new(0, 10, 1, -45)
InputContainer.BackgroundTransparency = 1

local InputFrame = Instance.new("TextBox", InputContainer)
InputFrame.Size = UDim2.new(1, -105, 1, 0); InputFrame.BackgroundColor3 = Color3.fromRGB(20, 22, 28)
InputFrame.BackgroundTransparency = 0.5; InputFrame.BorderSizePixel = 0; InputFrame.Text = ""
InputFrame.PlaceholderText = "Type here | اكتب هنا"; InputFrame.TextColor3 = Color3.fromRGB(255,255,255)
InputFrame.PlaceholderColor3 = Color3.fromRGB(180,180,180); InputFrame.Font = Enum.Font.Gotham; InputFrame.TextSize = 15
InputFrame.TextXAlignment = Enum.TextXAlignment.Left; InputFrame.ClearTextOnFocus = false
InputFrame.ZIndex = 3
Instance.new("UICorner", InputFrame).CornerRadius = UDim.new(0, 6)

local SendButton = Instance.new("TextButton", InputContainer)
SendButton.Size = UDim2.new(0, 50, 1, 0); SendButton.Position = UDim2.new(1, -55, 0, 0)
SendButton.BackgroundColor3 = Color3.fromRGB(46, 204, 113); SendButton.BorderSizePixel = 0
SendButton.Text = "Send"; SendButton.TextColor3 = Color3.fromRGB(255,255,255)
SendButton.Font = Enum.Font.GothamBold; SendButton.TextSize = 12
SendButton.ZIndex = 3; SendButton.Active = true; SendButton.Selectable = true
Instance.new("UICorner", SendButton).CornerRadius = UDim.new(0, 6)

local StickerButton = Instance.new("TextButton", InputContainer)
StickerButton.Size = UDim2.new(0, 40, 1, 0); StickerButton.Position = UDim2.new(1, -100, 0, 0)
StickerButton.BackgroundColor3 = Color3.fromRGB(200, 40, 40); StickerButton.BorderSizePixel = 0
StickerButton.Text = "🖼"; StickerButton.TextColor3 = Color3.fromRGB(255,255,255); StickerButton.TextSize = 16
StickerButton.Font = Enum.Font.GothamBlack
StickerButton.ZIndex = 3; StickerButton.Active = true; StickerButton.Selectable = true
Instance.new("UICorner", StickerButton).CornerRadius = UDim.new(0, 6)

local currentPrivateTarget = nil
local selectedSticker = nil
local lastStickerTime = 0
local sendCooldown = false

local PrivateBar = Instance.new("Frame", Window)
PrivateBar.Size = UDim2.new(1, -20, 0, 28); PrivateBar.Position = UDim2.new(0, 10, 1, -80)
PrivateBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20); PrivateBar.BackgroundTransparency = 0.2
PrivateBar.BorderSizePixel = 0; PrivateBar.Visible = false; PrivateBar.ZIndex = 12
Instance.new("UICorner", PrivateBar).CornerRadius = UDim.new(0, 6)

local PrivateLabel = Instance.new("TextLabel", PrivateBar)
PrivateLabel.Size = UDim2.new(1, -30, 1, 0); PrivateLabel.Position = UDim2.new(0, 10, 0, 0)
PrivateLabel.BackgroundTransparency = 1; PrivateLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
PrivateLabel.Font = Enum.Font.GothamBold; PrivateLabel.TextSize = 12; PrivateLabel.TextXAlignment = Enum.TextXAlignment.Left; PrivateLabel.ZIndex = 13
PrivateLabel.Active = false

local CancelPrivate = Instance.new("TextButton", PrivateBar)
CancelPrivate.Size = UDim2.new(0, 28, 0, 28); CancelPrivate.Position = UDim2.new(1, -30, 0.5, -14)
CancelPrivate.BackgroundColor3 = Color3.fromRGB(200, 40, 40); CancelPrivate.BackgroundTransparency = 0.3
CancelPrivate.BorderSizePixel = 0; CancelPrivate.Text = "✕"; CancelPrivate.TextColor3 = Color3.fromRGB(255,255,255)
CancelPrivate.Font = Enum.Font.GothamBold; CancelPrivate.TextSize = 16; CancelPrivate.ZIndex = 13
CancelPrivate.Active = true; CancelPrivate.Selectable = true
Instance.new("UICorner", CancelPrivate).CornerRadius = UDim.new(1, 0)

local StickerPreviewBar = Instance.new("Frame", Window)
StickerPreviewBar.Size = UDim2.new(1, -20, 0, 38)
StickerPreviewBar.Position = UDim2.new(0, 10, 1, -90)
StickerPreviewBar.BackgroundColor3 = Color3.fromRGB(30, 15, 15)
StickerPreviewBar.BackgroundTransparency = 0.2
StickerPreviewBar.BorderSizePixel = 0
StickerPreviewBar.Visible = false
StickerPreviewBar.ZIndex = 15
Instance.new("UICorner", StickerPreviewBar).CornerRadius = UDim.new(0, 8)

local previewStroke = Instance.new("UIStroke", StickerPreviewBar)
previewStroke.Color = Color3.fromRGB(255, 80, 80)
previewStroke.Thickness = 1
previewStroke.Transparency = 0.5

local PreviewImage = Instance.new("ImageLabel", StickerPreviewBar)
PreviewImage.Size = UDim2.new(0, 28, 0, 28)
PreviewImage.Position = UDim2.new(0, 6, 0.5, -14)
PreviewImage.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
PreviewImage.BorderSizePixel = 0
PreviewImage.Image = ""
PreviewImage.ScaleType = Enum.ScaleType.Crop
PreviewImage.ZIndex = 16
Instance.new("UICorner", PreviewImage).CornerRadius = UDim.new(0, 6)

local PreviewText = Instance.new("TextLabel", StickerPreviewBar)
PreviewText.Size = UDim2.new(1, -80, 1, 0)
PreviewText.Position = UDim2.new(0, 42, 0, 0)
PreviewText.BackgroundTransparency = 1
PreviewText.Text = "Sticker selected | تم اختيار ملصق"
PreviewText.TextColor3 = Color3.fromRGB(255, 220, 220)
PreviewText.Font = Enum.Font.GothamMedium
PreviewText.TextSize = 11
PreviewText.TextXAlignment = Enum.TextXAlignment.Left
PreviewText.ZIndex = 16
PreviewText.Active = false

local CancelPreview = Instance.new("TextButton", StickerPreviewBar)
CancelPreview.Size = UDim2.new(0, 24, 0, 24)
CancelPreview.Position = UDim2.new(1, -30, 0.5, -12)
CancelPreview.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
CancelPreview.BackgroundTransparency = 0.2
CancelPreview.BorderSizePixel = 0
CancelPreview.Text = "✕"
CancelPreview.TextColor3 = Color3.fromRGB(255, 255, 255)
CancelPreview.Font = Enum.Font.GothamBold
CancelPreview.TextSize = 12
CancelPreview.ZIndex = 16
CancelPreview.Active = true
CancelPreview.Selectable = true
Instance.new("UICorner", CancelPreview).CornerRadius = UDim.new(1, 0)

CancelPreview.MouseButton1Down:Connect(function()
    selectedSticker = nil
    ts:Create(StickerPreviewBar, TweenInfo.new(0.15), {BackgroundTransparency = 1}):Play()
    ts:Create(PreviewImage, TweenInfo.new(0.15), {ImageTransparency = 1}):Play()
    ts:Create(PreviewText, TweenInfo.new(0.15), {TextTransparency = 1}):Play()
    task.wait(0.15)
    StickerPreviewBar.Visible = false
    StickerPreviewBar.BackgroundTransparency = 0.2
    PreviewImage.ImageTransparency = 0
    PreviewText.TextTransparency = 0
end)

CancelPrivate.MouseButton1Down:Connect(function()
    currentPrivateTarget = nil; PrivateBar.Visible = false
    InputFrame.PlaceholderText = "Type here | اكتب هنا"
end)

local ToggleButton = Instance.new("TextButton", ScreenGui)
ToggleButton.Size = UDim2.new(0, 50, 0, 60); ToggleButton.Position = UDim2.new(0, 14, 0.2, 0)
ToggleButton.BackgroundColor3 = Color3.fromRGB(0,0,0); ToggleButton.BorderSizePixel = 0
ToggleButton.Text = "C\nH\nA\nT"; ToggleButton.TextColor3 = Color3.fromRGB(255,255,255)
ToggleButton.TextSize = 13; ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.ZIndex = 5; ToggleButton.Active = true; ToggleButton.Selectable = true
ToggleButton.Visible = true
Instance.new("UICorner", ToggleButton).CornerRadius = UDim.new(1, 0)
local tStroke = Instance.new("UIStroke", ToggleButton)
tStroke.Color = Color3.fromRGB(255, 50, 50); tStroke.Thickness = 3

-- ==========================================
-- STICKER PICKER
-- ==========================================
local stickerIDs = {
"rbxthumb://type=Asset&id=86336709074077&w=420&h=420", "rbxthumb://type=Asset&id=139741926623794&w=420&h=420", "rbxthumb://type=Asset&id=94021177383197&w=420&h=420", "rbxthumb://type=Asset&id=122169582163546&w=420&h=420", "rbxthumb://type=Asset&id=91689480739185&w=420&h=420", "rbxthumb://type=Asset&id=128206941638669&w=420&h=420", "rbxthumb://type=Asset&id=94433422552414&w=420&h=420", "rbxthumb://type=Asset&id=134375974192668&w=420&h=420", "rbxthumb://type=Asset&id=130368444127818&w=420&h=420", "rbxthumb://type=Asset&id=98526009112930&w=420&h=420", "rbxthumb://type=Asset&id=131098290520080&w=420&h=420", "rbxthumb://type=Asset&id=115919279365669&w=420&h=420", "rbxthumb://type=Asset&id=76958994444775&w=420&h=420", "rbxthumb://type=Asset&id=84785658530383&w=420&h=420", "rbxthumb://type=Asset&id=101146541690616&w=420&h=420", "rbxthumb://type=Asset&id=75971558346950&w=420&h=420", "rbxthumb://type=Asset&id=86948616928582&w=420&h=420", "rbxthumb://type=Asset&id=92946959090730&w=420&h=420", "rbxthumb://type=Asset&id=79937896838127&w=420&h=420", "rbxthumb://type=Asset&id=136715337972321&w=420&h=420", "rbxthumb://type=Asset&id=103921007681560&w=420&h=420", "rbxthumb://type=Asset&id=80326528456194&w=420&h=420", "rbxthumb://type=Asset&id=71638879650420&w=420&h=420", "rbxthumb://type=Asset&id=74399481230542&w=420&h=420", "rbxthumb://type=Asset&id=104679573737469&w=420&h=420", "rbxthumb://type=Asset&id=116620362272399&w=420&h=420", "rbxthumb://type=Asset&id=119531000446249&w=420&h=420", "rbxthumb://type=Asset&id=93163855973550&w=420&h=420", "rbxthumb://type=Asset&id=116431175390835&w=420&h=420", "rbxthumb://type=Asset&id=104854470548201&w=420&h=420", "rbxthumb://type=Asset&id=80157054066075&w=420&h=420", "rbxthumb://type=Asset&id=125052989500568&w=420&h=420", "rbxthumb://type=Asset&id=139863023298306&w=420&h=420", "rbxthumb://type=Asset&id=89015750606544&w=420&h=420", "rbxthumb://type=Asset&id=91938714688502&w=420&h=420", "rbxthumb://type=Asset&id=139128236887832&w=420&h=420", "rbxthumb://type=Asset&id=137386267869413&w=420&h=420", "rbxthumb://type=Asset&id=73411421171511&w=420&h=420", "rbxthumb://type=Asset&id=119109260332104&w=420&h=420", "rbxthumb://type=Asset&id=96916903736461&w=420&h=420", "rbxthumb://type=Asset&id=97024398389133&w=420&h=420", "rbxthumb://type=Asset&id=129012384792831&w=420&h=420", "rbxthumb://type=Asset&id=136836756972413&w=420&h=420", "rbxthumb://type=Asset&id=89709462769666&w=420&h=420", "rbxthumb://type=Asset&id=110452579373621&w=420&h=420", "rbxthumb://type=Asset&id=119620594588181&w=420&h=420", "rbxthumb://type=Asset&id=94969628121564&w=420&h=420", "rbxthumb://type=Asset&id=134919232918783&w=420&h=420", "rbxthumb://type=Asset&id=136879380150763&w=420&h=420", "rbxthumb://type=Asset&id=101510223937716&w=420&h=420", "rbxthumb://type=Asset&id=104699897840940&w=420&h=420", "rbxthumb://type=Asset&id=139128678756932&w=420&h=420", "rbxthumb://type=Asset&id=74372689003599&w=420&h=420", "rbxthumb://type=Asset&id=116158098410279&w=420&h=420", "rbxthumb://type=Asset&id=117363694930129&w=420&h=420", "rbxthumb://type=Asset&id=73388041689497&w=420&h=420", "rbxthumb://type=Asset&id=80632691471517&w=420&h=420", "rbxthumb://type=Asset&id=88685674294834&w=420&h=420", "rbxthumb://type=Asset&id=113252350702977&w=420&h=420", "rbxthumb://type=Asset&id=82760559484667&w=420&h=420", "rbxthumb://type=Asset&id=85269218361147&w=420&h=420", "rbxthumb://type=Asset&id=91446227201061&w=420&h=420", "rbxthumb://type=Asset&id=131825642772993&w=420&h=420", "rbxthumb://type=Asset&id=83488750494628&w=420&h=420", "rbxthumb://type=Asset&id=107382495564278&w=420&h=420", "rbxthumb://type=Asset&id=89347217517225&w=420&h=420", "rbxthumb://type=Asset&id=70514243253567&w=420&h=420", "rbxthumb://type=Asset&id=100956567958166&w=420&h=420", "rbxthumb://type=Asset&id=136672362562649&w=420&h=420", "rbxthumb://type=Asset&id=71645772901627&w=420&h=420", "rbxthumb://type=Asset&id=103132892959691&w=420&h=420", "rbxthumb://type=Asset&id=90364933157263&w=420&h=420", "rbxthumb://type=Asset&id=132425529210764&w=420&h=420", "rbxthumb://type=Asset&id=72694981827877&w=420&h=420", "rbxthumb://type=Asset&id=76926491557689&w=420&h=420", "rbxthumb://type=Asset&id=111021865740008&w=420&h=420", "rbxthumb://type=Asset&id=96376722978692&w=420&h=420", "rbxthumb://type=Asset&id=127056679363364&w=420&h=420", "rbxthumb://type=Asset&id=134522073255278&w=420&h=420", "rbxthumb://type=Asset&id=106435865600563&w=420&h=420", "rbxthumb://type=Asset&id=91792036280357&w=420&h=420", "rbxthumb://type=Asset&id=132716700994483&w=420&h=420", "rbxthumb://type=Asset&id=71358692358836&w=420&h=420", "rbxthumb://type=Asset&id=107094065601074&w=420&h=420", "rbxthumb://type=Asset&id=98080953984116&w=420&h=420", "rbxthumb://type=Asset&id=100985738475871&w=420&h=420", "rbxthumb://type=Asset&id=79285321382888&w=420&h=420", "rbxthumb://type=Asset&id=82716683136770&w=420&h=420", "rbxthumb://type=Asset&id=84062115733603&w=420&h=420", "rbxthumb://type=Asset&id=82443773212358&w=420&h=420", "rbxthumb://type=Asset&id=139103226283110&w=420&h=420", "rbxthumb://type=Asset&id=102667822545867&w=420&h=420", "rbxthumb://type=Asset&id=75166516948426&w=420&h=420", "rbxthumb://type=Asset&id=108443241948299&w=420&h=420", "rbxthumb://type=Asset&id=100913429736788&w=420&h=420",
}

local StickerPicker = Instance.new("Frame", Window)
StickerPicker.Size = UDim2.new(1, -20, 0, 160); StickerPicker.Position = UDim2.new(0, 10, 1, -210)
StickerPicker.BackgroundColor3 = Color3.fromRGB(20, 23, 30); StickerPicker.BackgroundTransparency = 0.05
StickerPicker.BorderSizePixel = 0; StickerPicker.Visible = false; StickerPicker.ZIndex = 20
Instance.new("UICorner", StickerPicker).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", StickerPicker).Color = Color3.fromRGB(255, 60, 60)

local CloseStickerBtn = Instance.new("TextButton", StickerPicker)
CloseStickerBtn.Size = UDim2.new(0, 22, 0, 22); CloseStickerBtn.Position = UDim2.new(1, -28, 0, 5)
CloseStickerBtn.BackgroundTransparency = 1; CloseStickerBtn.Text = "✕"; CloseStickerBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
CloseStickerBtn.Font = Enum.Font.GothamBold; CloseStickerBtn.TextSize = 13; CloseStickerBtn.ZIndex = 25
CloseStickerBtn.Active = true; CloseStickerBtn.Selectable = true
CloseStickerBtn.MouseButton1Down:Connect(function() StickerPicker.Visible = false end)

local StickerList = Instance.new("ScrollingFrame", StickerPicker)
StickerList.Size = UDim2.new(1, -10, 1, -10); StickerList.Position = UDim2.new(0, 5, 0, 5)
StickerList.BackgroundTransparency = 1
StickerList.CanvasSize = UDim2.new(0,0,0,0)
StickerList.AutomaticCanvasSize = Enum.AutomaticSize.Y
StickerList.ScrollBarThickness = 4
StickerList.ScrollBarImageColor3 = Color3.fromRGB(255, 60, 60); StickerList.ClipsDescendants = true
StickerList.ZIndex = 21

local sLayout = Instance.new("UIListLayout", StickerList)
sLayout.Padding = UDim.new(0, 6); sLayout.FillDirection = Enum.FillDirection.Horizontal
sLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center; sLayout.Wraps = true
sLayout.SortOrder = Enum.SortOrder.LayoutOrder

for i, url in ipairs(stickerIDs) do
    local b = Instance.new("ImageButton", StickerList)
    b.Size = UDim2.new(0, 50, 0, 50); b.BackgroundColor3 = Color3.fromRGB(30, 35, 45)
    b.BackgroundTransparency = 0.3; b.Image = url; b.LayoutOrder = i
    b.ZIndex = 22; b.Active = true; b.Selectable = true
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
    Instance.new("UIStroke", b).Color = Color3.fromRGB(200, 40, 40)
    b.MouseButton1Down:Connect(function()
        local now = tick()
        if now - lastStickerTime < STICKER_COOLDOWN then
            local remain = math.ceil(STICKER_COOLDOWN - (now - lastStickerTime))
            PreviewText.Text = "Wait " .. remain .. "s | استنى"
            return
        end
        selectedSticker = url
        StickerPicker.Visible = false
        PreviewImage.Image = url
        
        if currentPrivateTarget then
            PreviewText.Text = "📩 PRVT → " .. string.upper(getDisplayName(currentPrivateTarget))
        else
            PreviewText.Text = "Sticker selected | تم اختيار ملصق"
        end
        
        StickerPreviewBar.Visible = true
        StickerPreviewBar.BackgroundTransparency = 1
        PreviewImage.ImageTransparency = 1
        PreviewText.TextTransparency = 1
        
        ts:Create(StickerPreviewBar, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {BackgroundTransparency = 0.2}):Play()
        ts:Create(PreviewImage, TweenInfo.new(0.2), {ImageTransparency = 0}):Play()
        ts:Create(PreviewText, TweenInfo.new(0.2), {TextTransparency = 0}):Play()
        
        playSound(soundClick)
    end)
end

task.spawn(function()
    while task.wait(0.3) do
        local elapsed = tick() - lastStickerTime
        if elapsed < STICKER_COOLDOWN then
            local remain = math.ceil(STICKER_COOLDOWN - elapsed)
            StickerButton.Text = tostring(remain) .. "s"
            StickerButton.BackgroundColor3 = Color3.fromRGB(90, 30, 30)
            StickerButton.TextColor3 = Color3.fromRGB(255, 220, 220)
            StickerButton.TextSize = 18
            StickerButton.Font = Enum.Font.GothamBlack
        else
            if StickerButton.Text ~= "🖼" then
                StickerButton.Text = "🖼"
                StickerButton.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
                StickerButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                StickerButton.TextSize = 16
            end
        end
    end
end)

StickerButton.MouseButton1Down:Connect(function()
    if tick() - lastStickerTime < STICKER_COOLDOWN then return end
    StickerPicker.Visible = not StickerPicker.Visible
    playSound(soundClick)
end)

-- ==========================================
-- NOTIFICATIONS
-- ==========================================
local NotifGui = Instance.new("ScreenGui")
NotifGui.Name = "Far3onNotifications"; NotifGui.Parent = uiParent
NotifGui.DisplayOrder = 100; NotifGui.ResetOnSpawn = false

local NotifHolder = Instance.new("Frame", NotifGui)
NotifHolder.Size = UDim2.new(0, 300, 0, 500); NotifHolder.Position = UDim2.new(0, 15, 0, 150)
NotifHolder.BackgroundTransparency = 1
local notifLayout = Instance.new("UIListLayout", NotifHolder)
notifLayout.Padding = UDim.new(0, 8)
notifLayout.VerticalAlignment = Enum.VerticalAlignment.Top
notifLayout.SortOrder = Enum.SortOrder.LayoutOrder

local function createNotif(senderName, text, senderId, isPrivate, isBot)
    if not notificationsEnabled then return end
    if not NotifHolder or not NotifHolder.Parent then return end

    local f = Instance.new("Frame", NotifHolder)
    f.Size = UDim2.new(1, 0, 0, 65); f.BackgroundColor3 = Color3.fromRGB(18,18,22)
    f.BackgroundTransparency = 0.1; f.BorderSizePixel = 0; f.ZIndex = 100; f.LayoutOrder = tick()
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)

    local accent = Instance.new("Frame", f)
    accent.Size = UDim2.new(0, 4, 1, -20); accent.Position = UDim2.new(0, 0, 0, 10)
    accent.BackgroundColor3 = isPrivate and Color3.fromRGB(255,69,0) or (isBot and Color3.fromRGB(255,215,0) or Color3.fromRGB(255,50,50))
    accent.BorderSizePixel = 0
    Instance.new("UICorner", accent).CornerRadius = UDim.new(0, 4)

    local av = Instance.new("ImageLabel", f)
    av.Size = UDim2.new(0, 36, 0, 36); av.Position = UDim2.new(0, 12, 0.5, -18)
    av.BackgroundTransparency = 1; av.ZIndex = 102
    Instance.new("UICorner", av).CornerRadius = UDim.new(1, 0)
    if isBot then av.Image = "rbxassetid://112607146459388"
    else av.Image = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(senderId) .. "&w=420&h=420" end

    local nameLbl = Instance.new("TextLabel", f)
    nameLbl.Size = UDim2.new(1, -60, 0, 20); nameLbl.Position = UDim2.new(0, 55, 0, 10)
    nameLbl.BackgroundTransparency = 1; nameLbl.RichText = true
    if isBot then
        nameLbl.Text = "<font color='#FFD700'>[BOT]</font>"
    else
        local c = getPlayerColor(senderName)
        nameLbl.Text = (isPrivate and "(PRVT) " or "") .. "<font color='"..colorHex(c).."'>"..getDisplayName(senderName).."</font>"
    end
    nameLbl.Font = Enum.Font.GothamBold; nameLbl.TextSize = 14
    nameLbl.TextXAlignment = Enum.TextXAlignment.Left; nameLbl.TextTruncate = Enum.TextTruncate.AtEnd; nameLbl.ZIndex = 102

    local content = Instance.new("TextLabel", f)
    content.Size = UDim2.new(1, -60, 0, 25); content.Position = UDim2.new(0, 55, 0, 30)
    content.BackgroundTransparency = 1
    local isStk = string.sub(text, 1, 8) == "rbxthumb" or string.sub(text, 1, 4) == "http"
    content.Text = isStk and "📸 Sticker" or text
    content.TextColor3 = Color3.fromRGB(200,200,200); content.Font = Enum.Font.GothamMedium; content.TextSize = 12
    content.TextXAlignment = Enum.TextXAlignment.Left; content.TextWrapped = true; content.TextTruncate = Enum.TextTruncate.AtEnd; content.ZIndex = 102

    f.Position = UDim2.new(0, -50, 0, 0); f.BackgroundTransparency = 1
    nameLbl.TextTransparency = 1; av.ImageTransparency = 1; accent.BackgroundTransparency = 1; content.TextTransparency = 1

    local enter = TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    ts:Create(f, enter, {Position = UDim2.new(0,0,0,0), BackgroundTransparency = 0.1}):Play()
    ts:Create(nameLbl, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
    ts:Create(av, TweenInfo.new(0.3), {ImageTransparency = 0}):Play()
    ts:Create(accent, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
    ts:Create(content, TweenInfo.new(0.3), {TextTransparency = 0}):Play()

    task.delay(3, function()
        if f and f.Parent then
            local exit = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
            ts:Create(f, exit, {Position = UDim2.new(0,-50,0,0), BackgroundTransparency = 1}):Play()
            ts:Create(nameLbl, exit, {TextTransparency = 1}):Play()
            ts:Create(av, exit, {ImageTransparency = 1}):Play()
            ts:Create(accent, exit, {BackgroundTransparency = 1}):Play()
            ts:Create(content, exit, {TextTransparency = 1}):Play()
            task.delay(0.35, function() if f then f:Destroy() end end)
        end
    end)
end

-- ==========================================
-- FAR3ON JOIN ANIMATION
-- ==========================================
local function playFar3onJoinAnimation()
    local FlashGui = Instance.new("ScreenGui")
    FlashGui.Name = "Far3onJoinFlash"; FlashGui.Parent = uiParent
    FlashGui.ResetOnSpawn = false; FlashGui.IgnoreGuiInset = true; FlashGui.DisplayOrder = 99998
    local flash = Instance.new("Frame", FlashGui)
    flash.Size = UDim2.new(1, 0, 1, 0)
    flash.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
    flash.BackgroundTransparency = 0.75; flash.BorderSizePixel = 0
    local flashTween = ts:Create(flash, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1})
    flashTween:Play()
    flashTween.Completed:Connect(function() FlashGui:Destroy() end)

    local BannerGui = Instance.new("ScreenGui")
    BannerGui.Name = "Far3onJoinBanner"; BannerGui.Parent = uiParent
    BannerGui.ResetOnSpawn = false; BannerGui.IgnoreGuiInset = true; BannerGui.DisplayOrder = 99999

    local banner = Instance.new("Frame", BannerGui)
    banner.Size = UDim2.new(0, 520, 0, 100)
    banner.Position = UDim2.new(0.5, -260, 0, -120)
    banner.BackgroundColor3 = Color3.fromRGB(20, 15, 5)
    banner.BackgroundTransparency = 0.05; banner.BorderSizePixel = 0
    Instance.new("UICorner", banner).CornerRadius = UDim.new(0, 14)

    local bannerStroke = Instance.new("UIStroke", banner)
    bannerStroke.Color = Color3.fromRGB(255, 215, 0); bannerStroke.Thickness = 3; bannerStroke.Transparency = 0

    task.spawn(function()
        while banner and banner.Parent do
            local hue = (tick() * 0.5) % 1
            bannerStroke.Color = Color3.fromHSV(hue, 0.7, 1)
            task.wait(0.05)
        end
    end)

    local avatar = Instance.new("ImageLabel", banner)
    avatar.Size = UDim2.new(0, 70, 0, 70); avatar.Position = UDim2.new(0, 15, 0.5, -35)
    avatar.BackgroundTransparency = 1
    avatar.Image = "rbxthumb://type=AvatarHeadShot&id=" .. FAR3ON_OWNER_USERID .. "&w=420&h=420"
    Instance.new("UICorner", avatar).CornerRadius = UDim.new(1, 0)
    Instance.new("UIStroke", avatar).Color = Color3.fromRGB(255, 215, 0)

    local crown = Instance.new("TextLabel", banner)
    crown.Size = UDim2.new(0, 35, 0, 35); crown.Position = UDim2.new(0, 35, 0, -15)
    crown.BackgroundTransparency = 1; crown.Text = "👑"; crown.TextSize = 32; crown.ZIndex = 10
    crown.TextColor3 = Color3.fromRGB(255, 215, 0)

    local nameLbl = Instance.new("TextLabel", banner)
    nameLbl.Size = UDim2.new(1, -110, 0, 32); nameLbl.Position = UDim2.new(0, 95, 0, 12)
    nameLbl.BackgroundTransparency = 1; nameLbl.RichText = true
    nameLbl.Text = "<font color='#FFD700'>ּڣـــڔ؏ـــۏنۨ</font> <font color='#FFFFFF'>👑</font>"
    nameLbl.Font = Enum.Font.GothamBlack; nameLbl.TextSize = 24
    nameLbl.TextXAlignment = Enum.TextXAlignment.Left

    local msgLbl = Instance.new("TextLabel", banner)
    msgLbl.Size = UDim2.new(1, -110, 0, 24); msgLbl.Position = UDim2.new(0, 95, 0, 48)
    msgLbl.BackgroundTransparency = 1
    msgLbl.Text = "🎉 دخل الشات! | Joined the chat 🎉"
    msgLbl.TextColor3 = Color3.fromRGB(255, 255, 255); msgLbl.Font = Enum.Font.GothamBold
    msgLbl.TextSize = 15; msgLbl.TextXAlignment = Enum.TextXAlignment.Left

    local slideIn = ts:Create(banner, TweenInfo.new(0.7, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, -260, 0, 20)
    })
    slideIn:Play()

    local confettiColors = {
        Color3.fromRGB(255, 0, 0), Color3.fromRGB(0, 255, 0), Color3.fromRGB(0, 0, 255),
        Color3.fromRGB(255, 255, 0), Color3.fromRGB(255, 0, 255), Color3.fromRGB(0, 255, 255),
        Color3.fromRGB(255, 165, 0), Color3.fromRGB(255, 20, 147), Color3.fromRGB(50, 205, 50),
        Color3.fromRGB(255, 215, 0)
    }

    task.spawn(function()
        for i = 1, 80 do
            if not banner or not banner.Parent then break end
            local confetti = Instance.new("Frame", BannerGui)
            confetti.Size = UDim2.new(0, math.random(8, 15), 0, math.random(8, 15))
            confetti.Position = UDim2.new(math.random(0, 1000)/1000, 0, -0.1, 0)
            confetti.BackgroundColor3 = confettiColors[math.random(1, #confettiColors)]
            confetti.BorderSizePixel = 0
            confetti.ZIndex = 99998
            local cornerType = math.random(1, 2)
            if cornerType == 1 then
                Instance.new("UICorner", confetti).CornerRadius = UDim.new(0, 2)
            else
                Instance.new("UICorner", confetti).CornerRadius = UDim.new(1, 0)
            end
            local duration = math.random(20, 40) / 10
            local xDrift = math.random(-200, 200)
            local confettiTween = ts:Create(confetti, TweenInfo.new(duration, Enum.EasingStyle.Linear), {
                Position = UDim2.new(confetti.Position.X.Scale + xDrift/1000, confetti.Position.X.Offset, 1.1, 0),
                Rotation = math.random(0, 720)
            })
            confettiTween:Play()
            confettiTween.Completed:Connect(function() confetti:Destroy() end)
            task.wait(0.03)
        end
    end)

    local celebrationEmojis = {"🎉", "", "✨", "⭐", "🌟", "", "🎆", "🎇", "👑", "💎", "🔥", "❤️"}
    task.spawn(function()
        for i = 1, 40 do
            if not banner or not banner.Parent then break end
            local emoji = Instance.new("TextLabel", BannerGui)
            emoji.Size = UDim2.new(0, math.random(20, 35), 0, math.random(20, 35))
            emoji.Position = UDim2.new(math.random(0, 1000)/1000, 0, -0.1, 0)
            emoji.BackgroundTransparency = 1
            emoji.Text = celebrationEmojis[math.random(1, #celebrationEmojis)]
            emoji.TextSize = math.random(18, 30)
            emoji.TextTransparency = 0
            emoji.ZIndex = 99997
            local duration = math.random(25, 45) / 10
            local xDrift = math.random(-150, 150)
            local emojiTween = ts:Create(emoji, TweenInfo.new(duration, Enum.EasingStyle.Linear), {
                Position = UDim2.new(emoji.Position.X.Scale + xDrift/1000, emoji.Position.X.Offset, 1.1, 0),
                TextTransparency = 1,
                Rotation = math.random(-180, 180)
            })
            emojiTween:Play()
            emojiTween.Completed:Connect(function() emoji:Destroy() end)
            task.wait(0.05)
        end
    end)

    local joinSound = Instance.new("Sound")
    joinSound.SoundId = "rbxassetid://8740452945"; joinSound.Volume = 0.8; joinSound.Parent = SoundService
    pcall(function() joinSound:Play() end)
    task.delay(5, function() if joinSound then joinSound:Destroy() end end)

    task.delay(ANIMATION_DURATION, function()
        if banner and banner.Parent then
            local slideOut = ts:Create(banner, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                Position = UDim2.new(0.5, -260, 0, -120),
                BackgroundTransparency = 1
            })
            slideOut:Play()
            slideOut.Completed:Connect(function() BannerGui:Destroy() end)
        end
    end)
end

-- ==========================================
-- POPUP MENU
-- ==========================================
local function createPopupMenu(senderName, messageText, senderId)
    local oldPopup = uiParent:FindFirstChild("Far3onPlayerPopup")
    if oldPopup then oldPopup:Destroy() end

    playSound(soundPopup)

    local PopupGui = Instance.new("ScreenGui")
    PopupGui.Name = "Far3onPlayerPopup"; PopupGui.Parent = uiParent
    PopupGui.ResetOnSpawn = false; PopupGui.DisplayOrder = 999; PopupGui.IgnoreGuiInset = true

    local Backdrop = Instance.new("Frame", PopupGui)
    Backdrop.Size = UDim2.new(1, 0, 1, 0); Backdrop.BackgroundTransparency = 1
    Backdrop.ZIndex = 1; Backdrop.Active = true
    Backdrop.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            PopupGui:Destroy()
        end
    end)

    local MenuFrame = Instance.new("Frame", PopupGui)
    MenuFrame.Size = UDim2.new(0, 280, 0, 230); MenuFrame.Position = UDim2.new(0.5, -140, 0.5, -115)
    MenuFrame.BackgroundColor3 = Color3.fromRGB(20, 22, 30); MenuFrame.BackgroundTransparency = 0.05
    MenuFrame.BorderSizePixel = 0; MenuFrame.ZIndex = 2; MenuFrame.Active = true
    Instance.new("UICorner", MenuFrame).CornerRadius = UDim.new(0, 14)
    local stroke = Instance.new("UIStroke", MenuFrame); stroke.Color = Color3.fromRGB(255, 60, 60); stroke.Thickness = 1.5

    local avatar = Instance.new("ImageLabel", MenuFrame)
    avatar.Size = UDim2.new(0, 64, 0, 64); avatar.Position = UDim2.new(0.5, -32, 0, 15)
    avatar.BackgroundColor3 = Color3.fromRGB(30, 32, 40); avatar.BorderSizePixel = 0
    avatar.Image = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(senderId) .. "&w=420&h=420"
    avatar.ZIndex = 3; avatar.Active = false
    Instance.new("UICorner", avatar).CornerRadius = UDim.new(1, 0)
    Instance.new("UIStroke", avatar).Color = Color3.fromRGB(255, 60, 60)

    local c = getPlayerColor(senderName)
    local nameLbl = Instance.new("TextLabel", MenuFrame)
    nameLbl.Size = UDim2.new(1, -20, 0, 22); nameLbl.Position = UDim2.new(0, 10, 0, 85)
    nameLbl.BackgroundTransparency = 1; nameLbl.RichText = true
    nameLbl.Text = "👤 <font color='"..colorHex(c).."'>"..getDisplayName(senderName).."</font>"
    nameLbl.Font = Enum.Font.GothamBold; nameLbl.TextSize = 15
    nameLbl.TextXAlignment = Enum.TextXAlignment.Center; nameLbl.TextTruncate = Enum.TextTruncate.AtEnd
    nameLbl.ZIndex = 3; nameLbl.Active = false

    local userLbl = Instance.new("TextLabel", MenuFrame)
    userLbl.Size = UDim2.new(1, -20, 0, 16); userLbl.Position = UDim2.new(0, 10, 0, 108)
    userLbl.BackgroundTransparency = 1; userLbl.Text = "@" .. senderName .. " | ID: " .. tostring(senderId)
    userLbl.TextColor3 = Color3.fromRGB(180, 185, 200); userLbl.Font = Enum.Font.Gotham
    userLbl.TextSize = 11; userLbl.TextXAlignment = Enum.TextXAlignment.Center
    userLbl.TextTruncate = Enum.TextTruncate.AtEnd
    userLbl.ZIndex = 3; userLbl.Active = false

    local BtnContainer = Instance.new("Frame", MenuFrame)
    BtnContainer.Size = UDim2.new(1, -20, 0, 50); BtnContainer.Position = UDim2.new(0, 10, 0, 140)
    BtnContainer.BackgroundTransparency = 1; BtnContainer.ZIndex = 3

    local grid = Instance.new("UIGridLayout", BtnContainer)
    grid.CellSize = UDim2.new(0.333, -6, 1, 0)
    grid.CellPadding = UDim2.new(0, 8, 0, 0)
    grid.SortOrder = Enum.SortOrder.LayoutOrder
    grid.HorizontalAlignment = Enum.HorizontalAlignment.Center
    grid.VerticalAlignment = Enum.VerticalAlignment.Center

    local CopyBtn = Instance.new("TextButton", BtnContainer)
    CopyBtn.LayoutOrder = 1
    CopyBtn.BackgroundColor3 = Color3.fromRGB(52, 152, 219); CopyBtn.BorderSizePixel = 0
    CopyBtn.Text = "📋 نسخ"; CopyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CopyBtn.Font = Enum.Font.GothamBold; CopyBtn.TextSize = 13
    CopyBtn.ZIndex = 4; CopyBtn.Active = true; CopyBtn.Selectable = true
    Instance.new("UICorner", CopyBtn).CornerRadius = UDim.new(0, 8)
    CopyBtn.MouseButton1Down:Connect(function()
        local cleanText = string.gsub(messageText or "", "<[^>]*>", "")
        if setclipboard then
            setclipboard(cleanText)
            CopyBtn.Text = "✅ تم"
            task.wait(0.8); CopyBtn.Text = "📋 نسخ"
        end
    end)

    local PrvtBtn = Instance.new("TextButton", BtnContainer)
    PrvtBtn.LayoutOrder = 2
    PrvtBtn.BackgroundColor3 = Color3.fromRGB(255, 69, 0); PrvtBtn.BorderSizePixel = 0
    PrvtBtn.Text = "💬 خاص"; PrvtBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    PrvtBtn.Font = Enum.Font.GothamBold; PrvtBtn.TextSize = 13
    PrvtBtn.ZIndex = 4; PrvtBtn.Active = true; PrvtBtn.Selectable = true
    Instance.new("UICorner", PrvtBtn).CornerRadius = UDim.new(0, 8)
    PrvtBtn.MouseButton1Down:Connect(function()
        currentPrivateTarget = senderName
        PrivateLabel.Text = "PRVT → " .. string.upper(getDisplayName(senderName))
        PrivateBar.Visible = true
        InputFrame.PlaceholderText = "Private msg | رسالة خاصة"
        playSound(soundClick); PopupGui:Destroy()
    end)

    local ExitBtn = Instance.new("TextButton", BtnContainer)
    ExitBtn.LayoutOrder = 3
    ExitBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 40); ExitBtn.BorderSizePixel = 0
    ExitBtn.Text = "✕ خروج"; ExitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ExitBtn.Font = Enum.Font.GothamBold; ExitBtn.TextSize = 13
    ExitBtn.ZIndex = 4; ExitBtn.Active = true; ExitBtn.Selectable = true
    Instance.new("UICorner", ExitBtn).CornerRadius = UDim.new(0, 8)
    ExitBtn.MouseButton1Down:Connect(function() PopupGui:Destroy() end)

    local escConn
    escConn = uis.InputBegan:Connect(function(inp, gpe)
        if inp.KeyCode == Enum.KeyCode.Escape and not gpe then
            if PopupGui then PopupGui:Destroy() end
            if escConn then escConn:Disconnect() end
        end
    end)
end

-- ==========================================
-- MESSAGE BUTTONS
-- ==========================================
local rainbowLabels = {}

createMessageButton = function(senderName, text, isBot, isPrivate, targetName, senderId, isSticker)
    if not MessagesFrame or not MessagesFrame.Parent then return end

    if isBot and string.sub(text, 1, 5) == "[BOT]" then
        text = string.sub(text, 6)
        if string.sub(text, 1, 1) == " " then text = string.sub(text, 2) end
    end

    local displayName = getDisplayName(senderName)
    local pColor = getPlayerColor(senderName)
    local colorStr = colorHex(pColor)
    local isRainbowUser = isRainbow(senderName)
    local isSelf = (senderName == player.Name)

    local pureText = text
    local pureSticker = nil
    if string.find(text, "|||") then
        local parts = string.split(text, "|||")
        pureText = parts[1]
        pureSticker = parts[2]
    elseif isSticker or (string.sub(text, 1, 8) == "rbxthumb") or (string.sub(text, 1, 4) == "http") then
        pureSticker = text
        pureText = nil
    end

    local row = Instance.new("Frame", MessagesFrame)
    row.Size = UDim2.new(1, 0, 0, 24)
    row.BackgroundTransparency = 1
    row.AutomaticSize = Enum.AutomaticSize.Y
    row.ZIndex = 1
    row.Active = false
    row.Selectable = false

    local privateText = ""
    if isPrivate then
        if isSelf then
            privateText = " <font color='#FF4500'>[PRVT TO: " .. getDisplayName(targetName or "") .. "]</font>"
        else
            privateText = " <font color='#FF4500'>(PRIVT)</font>"
        end
    end

    local namePart = ""
    if isBot then
        namePart = "<font color='#FFD700'>[BOT]</font>"
    elseif isCreator(senderName) then
        namePart = "<font color='#FFD700'>:[CREATOR]</font> <font color='"..colorStr.."'>["..displayName.."]:</font>"
    else
        namePart = "<font color='"..colorStr.."'>["..displayName.."]:</font>"
    end
    namePart = namePart .. privateText

    local plainNameForSize = ""
    if isBot then
        plainNameForSize = "[BOT]"
    elseif isCreator(senderName) then
        plainNameForSize = ":[CREATOR] [" .. displayName .. "]:"
    else
        plainNameForSize = "[" .. displayName .. "]:"
    end
    if isPrivate then
        if isSelf then
            plainNameForSize = plainNameForSize .. " [PRVT TO: " .. getDisplayName(targetName or "") .. "]"
        else
            plainNameForSize = plainNameForSize .. " (PRIVT)"
        end
    end

    local nameLbl = Instance.new("TextLabel", row)
    nameLbl.BackgroundTransparency = 1
    nameLbl.RichText = true
    nameLbl.Font = Enum.Font.GothamBold
    nameLbl.TextSize = 16
    nameLbl.TextXAlignment = Enum.TextXAlignment.Left
    nameLbl.ZIndex = 2
    nameLbl.Text = namePart
    nameLbl.Active = false
    nameLbl.Selectable = false

    if isRainbowUser and not isBot and not pureSticker then
        rainbowLabels[nameLbl] = {
            displayName = displayName,
            text = pureText or "",
            isCreator = isCreator(senderName),
            isPrivate = isPrivate,
            target = targetName,
        }
    end

    local nameWidth = 100
    pcall(function()
        local nameSize = TextService:GetTextSize(
            plainNameForSize,
            16,
            Enum.Font.GothamBold,
            Vector2.new(1000, 100)
        )
        nameWidth = nameSize.X + 4
    end)

    if not isBot and not isSelf then
        local nameHitbox = Instance.new("TextButton", row)
        nameHitbox.BackgroundTransparency = 1
        nameHitbox.Text = ""
        nameHitbox.ZIndex = 10
        nameHitbox.Active = true
        nameHitbox.Selectable = true
        nameHitbox.AutoButtonColor = false
        nameHitbox.Size = UDim2.new(0, nameWidth, 0, 22)
        nameHitbox.Position = UDim2.new(0, 0, 0, 0)
        nameHitbox.MouseButton1Down:Connect(function()
            createPopupMenu(senderName, pureText or pureSticker or "", senderId)
            playSound(soundClick)
        end)
    end

    if pureSticker then
        nameLbl.Size = UDim2.new(1, 0, 0, 24)
        nameLbl.Position = UDim2.new(0, 0, 0, 0)
        
        local currentY = 24
        local hasText = pureText and #pureText > 0
        
        if hasText then
            local textLbl = Instance.new("TextLabel", row)
            textLbl.Size = UDim2.new(1, 0, 0, 0)
            textLbl.Position = UDim2.new(0, 0, 0, currentY)
            textLbl.BackgroundTransparency = 1
            textLbl.RichText = true
            textLbl.Text = "<font color='#FFFFFF'>" .. pureText .. "</font>"
            textLbl.Font = Enum.Font.Gotham
            textLbl.TextSize = 16
            textLbl.TextXAlignment = Enum.TextXAlignment.Left
            textLbl.TextYAlignment = Enum.TextYAlignment.Top
            textLbl.TextWrapped = true
            textLbl.AutomaticSize = Enum.AutomaticSize.Y
            textLbl.ZIndex = 2
            
            textLbl:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
                currentY = 24 + textLbl.AbsoluteSize.Y + 4
                local stickerImg = row:FindFirstChild("StickerImage")
                if stickerImg then
                    stickerImg.Position = UDim2.new(0, 0, 0, currentY)
                end
            end)
            currentY = 24 + 22
        end
        
        local img = Instance.new("ImageLabel", row)
        img.Name = "StickerImage"
        img.Size = UDim2.new(0, 75, 0, 75)
        img.Position = UDim2.new(0, 0, 0, currentY)
        img.BackgroundTransparency = 1
        img.Image = pureSticker
        img.ScaleType = Enum.ScaleType.Fit
        img.ZIndex = 2
        
    else
        nameLbl.Text = namePart .. " <font color='#FFFFFF'>" .. (pureText or "") .. "</font>"
        nameLbl.Size = UDim2.new(1, 0, 0, 24)
        nameLbl.Position = UDim2.new(0, 0, 0, 0)
        nameLbl.TextWrapped = true
        nameLbl.AutomaticSize = Enum.AutomaticSize.Y
    end

    if senderName ~= player.Name then
        local notifText = pureText or "Sticker"
        createNotif(senderName, notifText, senderId or 0, isPrivate, isBot)
        playSound(soundNotif)
    end

    if not isBot and senderName ~= player.Name and pureText and #pureText > 0 then
        showBubble(senderName, pureText)
    end

    task.wait(0.05)
    MessagesFrame.CanvasPosition = Vector2.new(0, MessagesFrame.AbsoluteCanvasSize.Y)
end

task.spawn(function()
    while task.wait(0.08) do
        local hue = (tick() % 3) / 3
        local c = Color3.fromHSV(hue, 1, 1)
        local hex = colorHex(c)
        for label, data in pairs(rainbowLabels) do
            if label and label.Parent then
                local prefix = ""
                if data.isCreator then prefix = "<font color='#FFD700'>:[CREATOR]</font> " end
                if data.isPrivate and data.target then
                    prefix = prefix .. "<font color='#FF4500'>[TO: " .. getDisplayName(data.target) .. "]</font> "
                end
                label.Text = prefix .. "<font color='"..hex.."'>[" .. data.displayName .. "]:</font> <font color='#FFFFFF'>" .. data.text .. "</font>"
            else
                rainbowLabels[label] = nil
            end
        end
    end
end)

-- ==========================================
-- SEND MESSAGE
-- ==========================================
local function sendMessage()
    if sendCooldown then return end
    
    local textToSend = InputFrame.Text
    local stickerToSend = selectedSticker
    
    if (not textToSend or #textToSend == 0) and not stickerToSend then return end
    if #textToSend > MAX_MSG_LEN and not stickerToSend then
        InputFrame.PlaceholderText = "Max " .. MAX_MSG_LEN .. " | الحد الأقصى"
        task.wait(1); InputFrame.PlaceholderText = "Type here | اكتب هنا"; return
    end

    sendCooldown = true
    SendButton.Text = "..."
    SendButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    SendButton.Active = false

    local isPrivate = (currentPrivateTarget ~= nil)
    local target = currentPrivateTarget or ""

    local finalContent = ""
    if textToSend and #textToSend > 0 and stickerToSend then
        finalContent = textToSend .. "|||" .. stickerToSend
    elseif stickerToSend then
        finalContent = stickerToSend
    elseif textToSend and #textToSend > 0 then
        finalContent = textToSend
    end

    if finalContent ~= "" then
        createMessageButton(player.Name, finalContent, false, isPrivate, target, player.UserId, stickerToSend ~= nil)
        
        broadcast({
            SenderId = tostring(player.UserId), Sender = player.Name, Content = finalContent,
            Type = "Text", Target = target, IsPrivate = isPrivate, IsSticker = (stickerToSend ~= nil),
            IsGlobalAnnounce = false, Sent = tick() // 1,
        })
        
        if not isPrivate and textToSend and #textToSend > 0 then 
            showBubble(player.Name, textToSend) 
        end
        if stickerToSend then lastStickerTime = tick() end
    end

    task.spawn(updateOnline)

    InputFrame.Text = ""
    InputFrame:ReleaseFocus()
    selectedSticker = nil
    StickerPreviewBar.Visible = false
    playSound(soundMsg)

    task.wait(SEND_COOLDOWN)
    SendButton.Text = "Send"
    SendButton.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
    SendButton.Active = true
    sendCooldown = false
end

SendButton.MouseButton1Down:Connect(function() playSound(soundClick); sendMessage() end)
InputFrame.FocusLost:Connect(function(enter) if enter then sendMessage() end end)

-- ==========================================
-- RECEIVE
-- ==========================================
local recentBotMsgs = {}
local seenKeys = {}
local firstPoll = true

task.spawn(function()
    task.wait(2)
    while task.wait(FETCH_INTERVAL) do
        local raw = httpGet()
        if raw then
            local ok, data = pcall(function() return HttpService:JSONDecode(raw) end)
            if ok and type(data) == "table" then
                if firstPoll then
                    for k in pairs(data) do seenKeys[k] = true end
                    firstPoll = false
                else
                    for k, v in pairs(data) do
                        if not seenKeys[k] and type(v) == "table" and v.Content and v.Content ~= "" then
                            seenKeys[k] = true
                            local sameServer = tostring(v.ServerJobId) == tostring(MY_JOB_ID)
                            local isSelf = tostring(v.SenderId) == tostring(player.UserId)
                            
                            if not isSelf and sameServer then
                                if v.Type == "SystemJoin" or v.IsBot then
                                    if not (recentBotMsgs[v.Content] and (tick() - recentBotMsgs[v.Content]) < 5) then
                                        createMessageButton("BOT", v.Content, true, false, nil, 0, false)
                                        
                                        if v.IsSpecialJoin then
                                            playFar3onJoinAnimation()
                                        end
                                    end
                                elseif v.IsPrivate then
                                    if player.Name == v.Target or player.Name == v.Sender then
                                        createMessageButton(v.Sender or "Player", v.Content, false, true, v.Target, tonumber(v.SenderId) or 0, v.IsSticker or false)
                                    end
                                else
                                    createMessageButton(v.Sender or "Player", v.Content, false, false, nil, tonumber(v.SenderId) or 0, v.IsSticker or false)
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end)

-- ==========================================
-- WINDOW TOGGLE + DRAG
-- ==========================================
ToggleButton.MouseButton1Down:Connect(function()
    Window.Visible = not Window.Visible
    playSound(soundClick)
end)
uis.InputBegan:Connect(function(inp, gpe)
    if inp.KeyCode == Enum.KeyCode.LeftControl and not gpe then
        Window.Visible = not Window.Visible
    end
end)

local function makeDraggable(obj, checkFn)
    local ds, sp, conn, up
    obj.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            if checkFn and checkFn() then return end
            ds = Vector2.new(mouse.X, mouse.Y); sp = obj.Position
            if conn then conn:Disconnect() end; if up then up:Disconnect() end
            conn = mouse.Move:Connect(function()
                local d = Vector2.new(mouse.X, mouse.Y) - ds
                obj.Position = UDim2.new(sp.X.Scale, sp.X.Offset + d.X, sp.Y.Scale, sp.Y.Offset + d.Y)
            end)
            up = uis.InputEnded:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                    if conn then conn:Disconnect() end; if up then up:Disconnect() end
                end
            end)
        end
    end)
end
makeDraggable(Window, function() return isChatFixed end)
makeDraggable(ToggleButton, function() return isButtonFixed end)

-- ==========================================
-- BOT
-- ==========================================
local function sendBotLocal(msg, isSpecial)
    createMessageButton("BOT", msg, true, false, nil, 0, false)
    recentBotMsgs[msg] = tick()
    broadcast({
        SenderId = tostring(player.UserId), 
        Sender = "SYSTEM", 
        Content = msg,
        Type = "SystemJoin", 
        IsBot = true, 
        Sent = tick() // 1,
        IsSpecialJoin = isSpecial or false,
    })
end

task.spawn(function()
    local isSpecial = isFar3onOwner(player.Name, player.UserId)
    sendBotLocal(getDisplayName(player.Name) .. " joined the chat 💬", isSpecial)
    
    if isSpecial then
        task.wait(0.5)
        playFar3onJoinAnimation()
    end
end)

local botOffset = (player.UserId % 500) + 5
local botMessages = {
    "صلي علي النبي ﷺ",
    "سبحان الله وبحمده سبحان الله العظيم",
    "اللهم اغفر لي وارحمني وعافني وارزقني",
}

task.spawn(function()
    task.wait(botOffset)
    local idx = 1
    while true do
        sendBotLocal(botMessages[idx])
        idx = idx + 1
        if idx > #botMessages then idx = 1 end
        task.wait(BOT_INTERVAL)
    end
end)

print("[FAR3ON LOCAL V0.5] Loaded | Compact Players Menu (260x290) | Red Theme")
print("[FAR3ON LOCAL V0.5] My JobId:", MY_JOB_ID, "| PlaceId:", MY_PLACE_ID)