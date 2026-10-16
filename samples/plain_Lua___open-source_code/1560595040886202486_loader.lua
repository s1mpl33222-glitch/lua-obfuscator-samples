local player = game:GetService("Players").LocalPlayer
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local MarketplaceService = game:GetService("MarketplaceService")

local API_URL = "https://parasitehub.up.railway.app"
local DISCORD_INVITE = "https://discord.gg/parasitehub"
local WEBSITE_URL = "https://parasitehub.up.railway.app"

local function getHWID()
    return (gethwid and gethwid()) or game:GetService("RbxAnalyticsService"):GetClientId()
end

local hwid = getHWID()

local function LoadSubLoader()
    local s, r = pcall(function() return game:HttpGet(API_URL .. "/sub-ee") end)
    if s and r and r ~= "" then
        local fn = loadstring(r)
        if fn then fn() else player:Kick("Failed to load") end
    else
        player:Kick("Failed to load")
    end
end

local function CheckHWIDBan()
    local s, r = pcall(function() return game:HttpGet(API_URL .. "/check-hwid-ban?hwid=" .. HttpService:UrlEncode(hwid)) end)
    if s and r then
        local d = HttpService:JSONDecode(r)
        if d.banned then
            player:Kick("Banned from PARASITE HUB")
            return true
        end
    end
    return false
end

local function AutoVerify()
    local s, r = pcall(function() return game:HttpGet(API_URL .. "/auto-verify?hwid=" .. HttpService:UrlEncode(hwid)) end)
    if s and r then
        local ok, d = pcall(function() return HttpService:JSONDecode(r) end)
        if ok and d and d.valid then return true end
    end
    return false
end

local function checkKick()
    local s, r = pcall(function() return game:HttpGet(API_URL .. "/iwhjaiwuehbwhe") end)
    if s and r and r ~= "-- OK" then
        local fn = loadstring(r)
        if fn then fn() return true end
    end
    return false
end

local function startKickCheck()
    while true do
        if checkKick() then break end
        task.wait(0.1)
    end
end

local function startAnnouncementLoop()
    local lastId = nil
    local annGui = nil
    local annFrame = nil

    task.spawn(function()
        while true do
            task.wait(3)
            local s, resp = pcall(function() return game:HttpGet(API_URL .. "/get-announcement") end)
            if s and resp and resp ~= "" then
                local ok, data = pcall(function() return HttpService:JSONDecode(resp) end)
                if ok and data then
                    if data.active and data.body and data.id then
                        if data.id ~= lastId then
                            lastId = data.id
                            if annGui then annGui:Destroy() end

                            annGui = Instance.new("ScreenGui")
                            annGui.Name = "ParasiteAnn"
                            annGui.ResetOnSpawn = false
                            annGui.IgnoreGuiInset = true
                            annGui.DisplayOrder = 998
                            annGui.Parent = player:WaitForChild("PlayerGui")

                            annFrame = Instance.new("Frame")
                            annFrame.AnchorPoint = Vector2.new(0.5, 0)
                            annFrame.Position = UDim2.new(0.5, 0, 0, -80)
                            annFrame.Size = UDim2.new(0, 420, 0, 60)
                            annFrame.BackgroundColor3 = Color3.fromRGB(24, 12, 12)
                            annFrame.BorderSizePixel = 0
                            annFrame.Parent = annGui

                            local c = Instance.new("UICorner", annFrame)
                            c.CornerRadius = UDim.new(0, 10)

                            local st = Instance.new("UIStroke", annFrame)
                            st.Color = Color3.fromRGB(220, 70, 70)
                            st.Thickness = 1.2
                            st.Transparency = 0.3

                            local accent = Instance.new("Frame", annFrame)
                            accent.Size = UDim2.new(0, 4, 1, 0)
                            accent.BackgroundColor3 = Color3.fromRGB(220, 70, 70)
                            accent.BorderSizePixel = 0

                            local ac = Instance.new("UICorner", accent)
                            ac.CornerRadius = UDim.new(0, 10)

                            local tl = Instance.new("TextLabel", annFrame)
                            tl.Position = UDim2.new(0, 16, 0, 8)
                            tl.Size = UDim2.new(1, -24, 0, 16)
                            tl.BackgroundTransparency = 1
                            tl.Text = "ANNOUNCEMENT"
                            tl.TextColor3 = Color3.fromRGB(255, 140, 140)
                            tl.TextSize = 11
                            tl.Font = Enum.Font.GothamBold
                            tl.TextXAlignment = Enum.TextXAlignment.Left

                            local lbl = Instance.new("TextLabel", annFrame)
                            lbl.Position = UDim2.new(0, 16, 0, 26)
                            lbl.Size = UDim2.new(1, -24, 0, 26)
                            lbl.BackgroundTransparency = 1
                            lbl.Text = data.body
                            lbl.TextColor3 = Color3.fromRGB(240, 230, 230)
                            lbl.TextSize = 13
                            lbl.Font = Enum.Font.Gotham
                            lbl.TextXAlignment = Enum.TextXAlignment.Left
                            lbl.TextWrapped = true

                            annFrame:TweenPosition(UDim2.new(0.5, 0, 0, 16), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.4, true)
                        end
                    else
                        if annGui then
                            if annFrame then
                                annFrame:TweenPosition(UDim2.new(0.5, 0, 0, -80), Enum.EasingDirection.In, Enum.EasingStyle.Quad, 0.3, true)
                            end
                            task.wait(0.35)
                            annGui:Destroy()
                            annGui = nil
                            annFrame = nil
                            lastId = nil
                        end
                    end
                end
            end
        end
    end)
end

function CreateKeyUI()
    local sg = Instance.new("ScreenGui")
    sg.Name = "parasitehub"
    sg.IgnoreGuiInset = true
    sg.ResetOnSpawn = false
    sg.DisplayOrder = 999
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    sg.Parent = player:WaitForChild("PlayerGui")

    local function addClickEffect(button)
        local originalSize = button.Size
        button.MouseButton1Down:Connect(function()
            TweenService:Create(button, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.new(originalSize.X.Scale * 0.95, originalSize.X.Offset * 0.95, originalSize.Y.Scale * 0.95, originalSize.Y.Offset * 0.95)
            }):Play()
        end)
        button.MouseButton1Up:Connect(function()
            TweenService:Create(button, TweenInfo.new(0.12, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Size = originalSize }):Play()
        end)
        button.MouseLeave:Connect(function()
            button.Size = originalSize
        end)
    end

    local Frame = Instance.new("Frame")
    Frame.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame.Position = UDim2.new(0.5, 0, 0.5, 0)
    Frame.Size = UDim2.new(0, 600, 0, 340)
    Frame.BackgroundTransparency = 1
    Frame.Active = true
    Frame.Draggable = true
    Frame.Parent = sg

    local Shadow = Instance.new("ImageLabel")
    Shadow.Position = UDim2.new(0, -25, 0, -25)
    Shadow.Size = UDim2.new(1, 50, 1, 50)
    Shadow.BackgroundTransparency = 1
    Shadow.Image = "rbxassetid://6014261993"
    Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.ImageTransparency = 0.6
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(49, 49, 450, 450)
    Shadow.Parent = Frame

    local CanvasGroup = Instance.new("CanvasGroup")
    CanvasGroup.Size = UDim2.new(1, 0, 1, 0)
    CanvasGroup.BackgroundColor3 = Color3.fromRGB(24, 12, 12)
    CanvasGroup.BorderSizePixel = 0
    CanvasGroup.Parent = Frame

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 10)
    UICorner.Parent = CanvasGroup

    local Glow1 = Instance.new("ImageLabel")
    Glow1.AnchorPoint = Vector2.new(0.5, 0.5)
    Glow1.Position = UDim2.new(0, 300, 0, 348)
    Glow1.Size = UDim2.new(0, 500, 0, 180)
    Glow1.BackgroundTransparency = 1
    Glow1.Image = "rbxassetid://8992230677"
    Glow1.ImageColor3 = Color3.fromRGB(255, 210, 210)
    Glow1.ImageTransparency = 0.86
    Glow1.Parent = CanvasGroup

    local Glow2 = Instance.new("ImageLabel")
    Glow2.AnchorPoint = Vector2.new(0.5, 0.5)
    Glow2.Position = UDim2.new(0, -10, 0, 330)
    Glow2.Size = UDim2.new(0, 130, 0, 60)
    Glow2.BackgroundTransparency = 1
    Glow2.Image = "rbxassetid://8992230677"
    Glow2.ImageColor3 = Color3.fromRGB(255, 210, 210)
    Glow2.ImageTransparency = 0.75
    Glow2.Parent = CanvasGroup

    local Glow3 = Instance.new("ImageLabel")
    Glow3.AnchorPoint = Vector2.new(0.5, 0.5)
    Glow3.Position = UDim2.new(0, 586, 0, 10)
    Glow3.Size = UDim2.new(0, 520, 0, 240)
    Glow3.BackgroundTransparency = 1
    Glow3.Image = "rbxassetid://8992230677"
    Glow3.ImageColor3 = Color3.fromRGB(255, 210, 210)
    Glow3.ImageTransparency = 0.92
    Glow3.Parent = CanvasGroup

    local Frame2 = Instance.new("Frame")
    Frame2.Size = UDim2.new(0, 356, 0, 340)
    Frame2.BackgroundTransparency = 1
    Frame2.Parent = CanvasGroup

    local Logo = Instance.new("ImageLabel")
    Logo.Position = UDim2.new(0, 28, 0, 26)
    Logo.Size = UDim2.new(0, 44, 0, 40)
    Logo.BackgroundTransparency = 1
    Logo.Image = "rbxassetid://964225339530"
    Logo.ImageColor3 = Color3.fromRGB(255, 180, 180)
    Logo.ScaleType = Enum.ScaleType.Fit
    Logo.Parent = Frame2

    local Title = Instance.new("TextLabel")
    Title.Position = UDim2.new(0, 82, 0, 28)
    Title.Size = UDim2.new(0, 200, 0, 24)
    Title.BackgroundTransparency = 1
    Title.Text = "Parasite Hub"
    Title.TextColor3 = Color3.fromRGB(240, 230, 230)
    Title.TextSize = 22
    Title.Font = Enum.Font.Unknown
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Frame2

    local Subtitle = Instance.new("TextLabel")
    Subtitle.Position = UDim2.new(0, 82, 0, 52)
    Subtitle.Size = UDim2.new(0, 200, 0, 14)
    Subtitle.BackgroundTransparency = 1
    Subtitle.Text = "Key system"
    Subtitle.TextColor3 = Color3.fromRGB(160, 110, 110)
    Subtitle.TextSize = 12
    Subtitle.Font = Enum.Font.Unknown
    Subtitle.TextXAlignment = Enum.TextXAlignment.Left
    Subtitle.Parent = Frame2

    local KeyLabel = Instance.new("TextLabel")
    KeyLabel.Position = UDim2.new(0, 28, 0, 100)
    KeyLabel.Size = UDim2.new(0, 200, 0, 14)
    KeyLabel.BackgroundTransparency = 1
    KeyLabel.Text = "License key"
    KeyLabel.TextColor3 = Color3.fromRGB(160, 110, 110)
    KeyLabel.TextSize = 11
    KeyLabel.Font = Enum.Font.Unknown
    KeyLabel.TextXAlignment = Enum.TextXAlignment.Left
    KeyLabel.Parent = Frame2

    local KeyFrame = Instance.new("Frame")
    KeyFrame.Position = UDim2.new(0, 28, 0, 120)
    KeyFrame.Size = UDim2.new(0, 300, 0, 40)
    KeyFrame.BackgroundColor3 = Color3.fromRGB(32, 16, 16)
    KeyFrame.BorderSizePixel = 0
    KeyFrame.Parent = Frame2

    local KeyCorner = Instance.new("UICorner")
    KeyCorner.Parent = KeyFrame

    local KeyStroke = Instance.new("UIStroke")
    KeyStroke.Color = Color3.fromRGB(70, 30, 30)
    KeyStroke.Parent = KeyFrame

    local KeyIconFrame = Instance.new("Frame")
    KeyIconFrame.Position = UDim2.new(0, 13, 0, 12)
    KeyIconFrame.Size = UDim2.new(0, 16, 0, 16)
    KeyIconFrame.BackgroundTransparency = 1
    KeyIconFrame.Parent = KeyFrame

    local KeyIcon = Instance.new("ImageLabel")
    KeyIcon.Size = UDim2.new(1, 0, 1, 0)
    KeyIcon.BackgroundTransparency = 1
    KeyIcon.Image = "rbxassetid://122605056588923"
    KeyIcon.ImageColor3 = Color3.fromRGB(160, 110, 110)
    KeyIcon.ImageRectOffset = Vector2.new(975, 50)
    KeyIcon.ImageRectSize = Vector2.new(24, 24)
    KeyIcon.Parent = KeyIconFrame

    local TextBox = Instance.new("TextBox")
    TextBox.Position = UDim2.new(0, 40, 0, 0)
    TextBox.Size = UDim2.new(1, -52, 1, 0)
    TextBox.BackgroundTransparency = 1
    TextBox.Text = ""
    TextBox.TextColor3 = Color3.fromRGB(240, 230, 230)
    TextBox.TextSize = 13
    TextBox.Font = Enum.Font.Unknown
    TextBox.TextXAlignment = Enum.TextXAlignment.Left
    TextBox.PlaceholderText = "Paste your key here"
    TextBox.PlaceholderColor3 = Color3.fromRGB(160, 110, 110)
    TextBox.ClearTextOnFocus = false
    TextBox.Parent = KeyFrame

    local HWIDLabel = Instance.new("TextLabel")
    HWIDLabel.Position = UDim2.new(0, 28, 0, 164)
    HWIDLabel.Size = UDim2.new(0, 300, 0, 12)
    HWIDLabel.BackgroundTransparency = 1
    HWIDLabel.Text = "HWID: " .. string.sub(hwid, 1, 40) .. "..."
    HWIDLabel.TextColor3 = Color3.fromRGB(110, 70, 70)
    HWIDLabel.TextSize = 10
    HWIDLabel.Font = Enum.Font.Code
    HWIDLabel.TextXAlignment = Enum.TextXAlignment.Left
    HWIDLabel.TextTruncate = Enum.TextTruncate.AtEnd
    HWIDLabel.Parent = Frame2

    local Status = Instance.new("TextLabel")
    Status.Position = UDim2.new(0, 28, 0, 232)
    Status.Size = UDim2.new(0, 300, 0, 16)
    Status.BackgroundTransparency = 1
    Status.Text = ""
    Status.TextColor3 = Color3.fromRGB(160, 110, 110)
    Status.TextSize = 12
    Status.Font = Enum.Font.Unknown
    Status.TextXAlignment = Enum.TextXAlignment.Left
    Status.TextTruncate = Enum.TextTruncate.AtEnd
    Status.Parent = Frame2

    local Hint = Instance.new("TextLabel")
    Hint.Position = UDim2.new(0, 28, 0, 296)
    Hint.Size = UDim2.new(0, 300, 0, 14)
    Hint.BackgroundTransparency = 1
    Hint.Text = "Your key is saved, you only enter it once"
    Hint.TextColor3 = Color3.fromRGB(160, 110, 110)
    Hint.TextSize = 11
    Hint.Font = Enum.Font.Unknown
    Hint.TextXAlignment = Enum.TextXAlignment.Left
    Hint.Parent = Frame2

    local Submit = Instance.new("TextButton")
    Submit.Position = UDim2.new(0, 28, 0, 184)
    Submit.Size = UDim2.new(0, 144, 0, 38)
    Submit.BackgroundColor3 = Color3.fromRGB(220, 70, 70)
    Submit.BackgroundTransparency = 0.12
    Submit.Text = "Submit"
    Submit.TextColor3 = Color3.fromRGB(24, 18, 26)
    Submit.TextSize = 13
    Submit.Font = Enum.Font.Unknown
    Submit.AutoButtonColor = false
    Submit.Parent = Frame2

    local SubmitCorner = Instance.new("UICorner")
    SubmitCorner.CornerRadius = UDim.new(0, 8)
    SubmitCorner.Parent = Submit

    local SubmitStroke = Instance.new("UIStroke")
    SubmitStroke.Color = Color3.fromRGB(220, 70, 70)
    SubmitStroke.Transparency = 0.4
    SubmitStroke.Parent = Submit

    local CopyHWID = Instance.new("TextButton")
    CopyHWID.Position = UDim2.new(0, 184, 0, 184)
    CopyHWID.Size = UDim2.new(0, 144, 0, 38)
    CopyHWID.BackgroundColor3 = Color3.fromRGB(50, 25, 25)
    CopyHWID.Text = "Copy HWID"
    CopyHWID.TextColor3 = Color3.fromRGB(240, 230, 230)
    CopyHWID.TextSize = 13
    CopyHWID.Font = Enum.Font.Unknown
    CopyHWID.AutoButtonColor = false
    CopyHWID.Parent = Frame2

    local CopyCorner = Instance.new("UICorner")
    CopyCorner.CornerRadius = UDim.new(0, 8)
    CopyCorner.Parent = CopyHWID

    local CopyStroke = Instance.new("UIStroke")
    CopyStroke.Color = Color3.fromRGB(70, 30, 30)
    CopyStroke.Parent = CopyHWID

    local Divider = Instance.new("Frame")
    Divider.Position = UDim2.new(0, 356, 0, 28)
    Divider.Size = UDim2.new(0, 1, 1, -56)
    Divider.BackgroundColor3 = Color3.fromRGB(70, 30, 30)
    Divider.BorderSizePixel = 0
    Divider.Parent = CanvasGroup

    local Frame8 = Instance.new("Frame")
    Frame8.Position = UDim2.new(0, 357, 0, 0)
    Frame8.Size = UDim2.new(0, 244, 0, 340)
    Frame8.BackgroundTransparency = 1
    Frame8.Parent = CanvasGroup

    local DetectedLabel = Instance.new("TextLabel")
    DetectedLabel.Position = UDim2.new(0, 28, 0, 30)
    DetectedLabel.Size = UDim2.new(0, 184, 0, 14)
    DetectedLabel.BackgroundTransparency = 1
    DetectedLabel.Text = "Detected game"
    DetectedLabel.TextColor3 = Color3.fromRGB(160, 110, 110)
    DetectedLabel.TextSize = 11
    DetectedLabel.Font = Enum.Font.Unknown
    DetectedLabel.TextXAlignment = Enum.TextXAlignment.Left
    DetectedLabel.Parent = Frame8

    local GameFrame = Instance.new("Frame")
    GameFrame.Position = UDim2.new(0, 28, 0, 50)
    GameFrame.Size = UDim2.new(0, 188, 0, 60)
    GameFrame.BackgroundColor3 = Color3.fromRGB(34, 18, 18)
    GameFrame.BorderSizePixel = 0
    GameFrame.Parent = Frame8

    local GameCorner = Instance.new("UICorner")
    GameCorner.Parent = GameFrame

    local GameStroke = Instance.new("UIStroke")
    GameStroke.Color = Color3.fromRGB(70, 30, 30)
    GameStroke.Parent = GameFrame

    local GameThumb = Instance.new("ImageLabel")
    GameThumb.Position = UDim2.new(0, 11, 0, 11)
    GameThumb.Size = UDim2.new(0, 38, 0, 38)
    GameThumb.BackgroundColor3 = Color3.fromRGB(32, 16, 16)
    GameThumb.BorderSizePixel = 0
    GameThumb.Image = "rbxassetid://74584987850498"
    GameThumb.Parent = GameFrame

    local ThumbCorner = Instance.new("UICorner")
    ThumbCorner.CornerRadius = UDim.new(0, 7)
    ThumbCorner.Parent = GameThumb

    local ThumbStroke = Instance.new("UIStroke")
    ThumbStroke.Color = Color3.fromRGB(70, 30, 30)
    ThumbStroke.Parent = GameThumb

    local GameName = Instance.new("TextLabel")
    GameName.Position = UDim2.new(0, 58, 0, 15)
    GameName.Size = UDim2.new(0, 122, 0, 14)
    GameName.BackgroundTransparency = 1
    GameName.Text = "Detecting..."
    GameName.TextColor3 = Color3.fromRGB(240, 230, 230)
    GameName.TextSize = 12
    GameName.Font = Enum.Font.Unknown
    GameName.TextXAlignment = Enum.TextXAlignment.Left
    GameName.TextTruncate = Enum.TextTruncate.AtEnd
    GameName.Parent = GameFrame

    local GameSupport = Instance.new("TextLabel")
    GameSupport.Position = UDim2.new(0, 58, 0, 32)
    GameSupport.Size = UDim2.new(0, 122, 0, 13)
    GameSupport.BackgroundTransparency = 1
    GameSupport.Text = "Universal support"
    GameSupport.TextColor3 = Color3.fromRGB(120, 220, 120)
    GameSupport.TextSize = 11
    GameSupport.Font = Enum.Font.Unknown
    GameSupport.TextXAlignment = Enum.TextXAlignment.Left
    GameSupport.TextTruncate = Enum.TextTruncate.AtEnd
    GameSupport.Parent = GameFrame

    local ExecLabel = Instance.new("TextLabel")
    ExecLabel.Position = UDim2.new(0, 28, 0, 126)
    ExecLabel.Size = UDim2.new(0, 90, 0, 14)
    ExecLabel.BackgroundTransparency = 1
    ExecLabel.Text = "Executor"
    ExecLabel.TextColor3 = Color3.fromRGB(160, 110, 110)
    ExecLabel.TextSize = 11
    ExecLabel.Font = Enum.Font.Unknown
    ExecLabel.TextXAlignment = Enum.TextXAlignment.Left
    ExecLabel.Parent = Frame8

    local ExecValue = Instance.new("TextLabel")
    ExecValue.Position = UDim2.new(0, 120, 0, 126)
    ExecValue.Size = UDim2.new(0, 96, 0, 14)
    ExecValue.BackgroundTransparency = 1
    ExecValue.Text = "Delta"
    ExecValue.TextColor3 = Color3.fromRGB(240, 230, 230)
    ExecValue.TextSize = 11
    ExecValue.Font = Enum.Font.Unknown
    ExecValue.TextXAlignment = Enum.TextXAlignment.Right
    ExecValue.Parent = Frame8

    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Position = UDim2.new(0, 28, 0, 148)
    StatusLabel.Size = UDim2.new(0, 90, 0, 14)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Text = "Status"
    StatusLabel.TextColor3 = Color3.fromRGB(160, 110, 110)
    StatusLabel.TextSize = 11
    StatusLabel.Font = Enum.Font.Unknown
    StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
    StatusLabel.Parent = Frame8

    local StatusValue = Instance.new("TextLabel")
    StatusValue.Position = UDim2.new(0, 120, 0, 148)
    StatusValue.Size = UDim2.new(0, 96, 0, 14)
    StatusValue.BackgroundTransparency = 1
    StatusValue.Text = "Key required"
    StatusValue.TextColor3 = Color3.fromRGB(255, 140, 110)
    StatusValue.TextSize = 11
    StatusValue.Font = Enum.Font.Unknown
    StatusValue.TextXAlignment = Enum.TextXAlignment.Right
    StatusValue.Parent = Frame8

    local Divider2 = Instance.new("Frame")
    Divider2.Position = UDim2.new(0, 28, 0, 176)
    Divider2.Size = UDim2.new(0, 188, 0, 1)
    Divider2.BackgroundColor3 = Color3.fromRGB(70, 30, 30)
    Divider2.BorderSizePixel = 0
    Divider2.Parent = Frame8

    local DiscordBtn = Instance.new("TextButton")
    DiscordBtn.Position = UDim2.new(0, 28, 0, 190)
    DiscordBtn.Size = UDim2.new(0, 188, 0, 48)
    DiscordBtn.BackgroundColor3 = Color3.fromRGB(34, 18, 18)
    DiscordBtn.Text = ""
    DiscordBtn.AutoButtonColor = false
    DiscordBtn.Parent = Frame8

    local DCorner = Instance.new("UICorner")
    DCorner.Parent = DiscordBtn

    local DStroke = Instance.new("UIStroke")
    DStroke.Color = Color3.fromRGB(70, 30, 30)
    DStroke.Parent = DiscordBtn

    local DText1 = Instance.new("TextLabel")
    DText1.Position = UDim2.new(0, 40, 0, 10)
    DText1.Size = UDim2.new(0, 120, 0, 14)
    DText1.BackgroundTransparency = 1
    DText1.Text = "Discord"
    DText1.TextColor3 = Color3.fromRGB(240, 230, 230)
    DText1.TextSize = 12
    DText1.Font = Enum.Font.Unknown
    DText1.TextXAlignment = Enum.TextXAlignment.Left
    DText1.Parent = DiscordBtn

    local DText2 = Instance.new("TextLabel")
    DText2.Position = UDim2.new(0, 40, 0, 25)
    DText2.Size = UDim2.new(0, 132, 0, 13)
    DText2.BackgroundTransparency = 1
    DText2.Text = "discord.gg/parasitehub"
    DText2.TextColor3 = Color3.fromRGB(160, 110, 110)
    DText2.TextSize = 11
    DText2.Font = Enum.Font.Unknown
    DText2.TextXAlignment = Enum.TextXAlignment.Left
    DText2.Parent = DiscordBtn

    local WebsiteBtn = Instance.new("TextButton")
    WebsiteBtn.Position = UDim2.new(0, 28, 0, 246)
    WebsiteBtn.Size = UDim2.new(0, 188, 0, 48)
    WebsiteBtn.BackgroundColor3 = Color3.fromRGB(34, 18, 18)
    WebsiteBtn.Text = ""
    WebsiteBtn.AutoButtonColor = false
    WebsiteBtn.Parent = Frame8

    local WCorner = Instance.new("UICorner")
    WCorner.Parent = WebsiteBtn

    local WStroke = Instance.new("UIStroke")
    WStroke.Color = Color3.fromRGB(70, 30, 30)
    WStroke.Parent = WebsiteBtn

    local WText1 = Instance.new("TextLabel")
    WText1.Position = UDim2.new(0, 40, 0, 10)
    WText1.Size = UDim2.new(0, 120, 0, 14)
    WText1.BackgroundTransparency = 1
    WText1.Text = "Website"
    WText1.TextColor3 = Color3.fromRGB(240, 230, 230)
    WText1.TextSize = 12
    WText1.Font = Enum.Font.Unknown
    WText1.TextXAlignment = Enum.TextXAlignment.Left
    WText1.Parent = WebsiteBtn

    local WText2 = Instance.new("TextLabel")
    WText2.Position = UDim2.new(0, 40, 0, 25)
    WText2.Size = UDim2.new(0, 132, 0, 13)
    WText2.BackgroundTransparency = 1
    WText2.Text = "parasitehub.up.railway.app"
    WText2.TextColor3 = Color3.fromRGB(160, 110, 110)
    WText2.TextSize = 11
    WText2.Font = Enum.Font.Unknown
    WText2.TextXAlignment = Enum.TextXAlignment.Left
    WText2.Parent = WebsiteBtn

    addClickEffect(Submit)
    addClickEffect(CopyHWID)
    addClickEffect(DiscordBtn)
    addClickEffect(WebsiteBtn)

    local function setStatus(text, color)
        Status.Text = text
        Status.TextColor3 = color or Color3.fromRGB(160, 110, 110)
    end

    local function VerifyKey()
        local key = TextBox.Text
        if key == "" then
            setStatus("Enter a key", Color3.fromRGB(255, 80, 120))
            return
        end
        setStatus("Verifying...", Color3.fromRGB(200, 200, 200))
        StatusValue.Text = "Checking..."
        StatusValue.TextColor3 = Color3.fromRGB(255, 200, 120)
        local url = API_URL .. "/checkkey?key=" .. HttpService:UrlEncode(key) .. "&username=" .. HttpService:UrlEncode(player.Name) .. "&userid=" .. player.UserId .. "&hwid=" .. HttpService:UrlEncode(hwid)
        local ok, r = pcall(function() return game:HttpGet(url) end)
        if not ok or not r then
            setStatus("API Error - try again", Color3.fromRGB(255, 80, 120))
            StatusValue.Text = "Error"
            StatusValue.TextColor3 = Color3.fromRGB(255, 80, 120)
            return
        end
        local ok2, d = pcall(function() return HttpService:JSONDecode(r) end)
        if not ok2 or not d then
            setStatus("Invalid response", Color3.fromRGB(255, 80, 120))
            return
        end
        if d.valid then
            setStatus("Access Granted. Loading...", Color3.fromRGB(0, 255, 170))
            StatusValue.Text = "Verified"
            StatusValue.TextColor3 = Color3.fromRGB(0, 255, 170)
            Submit.Active = false
            CopyHWID.Active = false
            TextBox.Active = false
            pcall(function()
                game:HttpGet(API_URL .. "/register-user?key=" .. HttpService:UrlEncode(key) .. "&hwid=" .. HttpService:UrlEncode(hwid) .. "&player=" .. HttpService:UrlEncode(player.Name) .. "&userid=" .. tostring(player.UserId))
            end)
            task.wait(0.5)
            local fade = TweenService:Create(CanvasGroup, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { GroupTransparency = 1 })
            fade:Play()
            fade.Completed:Wait()
            sg:Destroy()
            task.wait(0.1)
            LoadSubLoader()
        else
            setStatus(d.message or "Invalid key", Color3.fromRGB(255, 80, 120))
            StatusValue.Text = "Invalid"
            StatusValue.TextColor3 = Color3.fromRGB(255, 80, 120)
        end
    end

    Submit.MouseButton1Click:Connect(VerifyKey)
    TextBox.FocusLost:Connect(function(enter)
        if enter then VerifyKey() end
    end)
    CopyHWID.MouseButton1Click:Connect(function()
        setclipboard(hwid)
        setStatus("HWID copied!", Color3.fromRGB(0, 255, 170))
        Hint.Text = "Paste it in the Discord panel"
        Hint.TextColor3 = Color3.fromRGB(120, 220, 120)
    end)
    DiscordBtn.MouseButton1Click:Connect(function()
        setclipboard(DISCORD_INVITE)
        setStatus("Copied: " .. DISCORD_INVITE, Color3.fromRGB(0, 255, 170))
        Hint.Text = "Paste it into your browser to join"
        Hint.TextColor3 = Color3.fromRGB(120, 220, 120)
    end)
    WebsiteBtn.MouseButton1Click:Connect(function()
        setclipboard(WEBSITE_URL)
        setStatus("Copied: " .. WEBSITE_URL, Color3.fromRGB(0, 255, 170))
        Hint.Text = "Paste it into your browser"
        Hint.TextColor3 = Color3.fromRGB(120, 220, 120)
    end)

    task.spawn(function()
        while task.wait(3) do
            if not sg.Parent then break end
            local ok, info = pcall(function() return MarketplaceService:GetProductInfo(game.PlaceId) end)
            if ok and info and info.Name then
                GameName.Text = info.Name
            end
        end
    end)

    task.spawn(function()
        task.wait(1)
        local thumb = nil
        local ok, info = pcall(function() return MarketplaceService:GetProductInfo(game.PlaceId) end)
        if ok and info and info.IconImageAssetId and info.IconImageAssetId > 0 then
            thumb = "rbxassetid://" .. tostring(info.IconImageAssetId)
        end
        if thumb then
            GameThumb.Image = thumb
            GameThumb.ImageColor3 = Color3.fromRGB(255, 255, 255)
        end
    end)
end

local function queueSelf()
    task.spawn(function()
        task.wait(3)
        local queueteleport = queue_on_teleport or (syn and syn.queue_on_teleport) or (fluxus and fluxus.queue_on_teleport)
        if queueteleport then
            local rejoinScript = 'loadstring(game:HttpGet("' .. API_URL .. '/loader"))()'
            pcall(queueteleport, rejoinScript)
            print("[PARASITE HUB] Whole loader queued for next server.")
        else
            warn("[PARASITE HUB] queueteleport not available.")
        end
    end)
end

local function Initialize()
    if CheckHWIDBan() then return end
    startAnnouncementLoop()
    queueSelf()
    if AutoVerify() then
        LoadSubLoader()
        return
    end
    CreateKeyUI()
end

coroutine.wrap(startKickCheck)()
Initialize()