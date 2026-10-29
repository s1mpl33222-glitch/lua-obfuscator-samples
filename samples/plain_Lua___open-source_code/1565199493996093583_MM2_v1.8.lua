local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local function GetNotificationHolder()
    local screenGui = PlayerGui:FindFirstChild("CustomNotificationGui")
    if not screenGui then
        screenGui = Instance.new("ScreenGui")
        screenGui.Name = "CustomNotificationGui"
        screenGui.ResetOnSpawn = false
        screenGui.Parent = PlayerGui
    end

    local holder = screenGui:FindFirstChild("Holder")
    if not holder then
        holder = Instance.new("Frame")
        holder.Name = "Holder"
        holder.Size = UDim2.new(0, 360, 1, -40)
        holder.Position = UDim2.new(1, -380, 0, 25)
        holder.BackgroundTransparency = 1
        holder.Parent = screenGui

        local listLayout = Instance.new("UIListLayout")
        listLayout.SortOrder = Enum.SortOrder.LayoutOrder
        listLayout.Padding = UDim.new(0, 12)
        listLayout.VerticalAlignment = Enum.VerticalAlignment.Top
        listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
        listLayout.Parent = holder
    end

    return holder
end

local function Notify(titleText, messageText, displayTime)
    titleText = titleText or "Notification"
    messageText = messageText or "System notification message."
    displayTime = displayTime or 4

    local holder = GetNotificationHolder()

    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 0)
    container.BackgroundTransparency = 1
    container.ClipsDescendants = false
    container.Parent = holder

    local shadow = Instance.new("ImageLabel")
    shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    shadow.Position = UDim2.new(0.5, 0, 0.5, 6)
    shadow.Size = UDim2.new(1, 30, 1, 30)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://5554236805"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.35
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(23, 23, 277, 277)
    shadow.ZIndex = 1
    shadow.Parent = container

    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 0, 88)
    card.Position = UDim2.new(1, 120, 0, 0)
    card.BackgroundColor3 = Color3.fromRGB(15, 17, 26)
    card.BackgroundTransparency = 0.05
    card.BorderSizePixel = 0
    card.ClipsDescendants = true
    card.ZIndex = 2
    card.Parent = container

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 16)
    corner.Parent = card

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(147, 51, 234)
    stroke.Thickness = 1.8
    stroke.Transparency = 0.2
    stroke.Parent = card

    local strokeGradient = Instance.new("UIGradient")
    strokeGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(168, 85, 247)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(59, 130, 246)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(236, 72, 153))
    })
    strokeGradient.Rotation = 45
    strokeGradient.Parent = stroke

    local cardGradient = Instance.new("UIGradient")
    cardGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(26, 29, 44)),
        ColorSequenceKeypoint.new(0.6, Color3.fromRGB(16, 18, 28)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 13, 20))
    })
    cardGradient.Rotation = 135
    cardGradient.Parent = card

    local glowCircle = Instance.new("Frame")
    glowCircle.Size = UDim2.new(0, 120, 0, 120)
    glowCircle.Position = UDim2.new(0, -40, 0, -30)
    glowCircle.BackgroundColor3 = Color3.fromRGB(147, 51, 234)
    glowCircle.BackgroundTransparency = 0.9
    glowCircle.BorderSizePixel = 0
    glowCircle.ZIndex = 2
    glowCircle.Parent = card

    local glowCorner = Instance.new("UICorner")
    glowCorner.CornerRadius = UDim.new(1, 0)
    glowCorner.Parent = glowCircle

    local iconBadge = Instance.new("Frame")
    iconBadge.Size = UDim2.new(0, 42, 0, 42)
    iconBadge.Position = UDim2.new(0, 14, 0, 14)
    iconBadge.BackgroundColor3 = Color3.fromRGB(147, 51, 234)
    iconBadge.BackgroundTransparency = 0.8
    iconBadge.BorderSizePixel = 0
    iconBadge.ZIndex = 3
    iconBadge.Parent = card

    local badgeCorner = Instance.new("UICorner")
    badgeCorner.CornerRadius = UDim.new(0, 12)
    badgeCorner.Parent = iconBadge

    local badgeStroke = Instance.new("UIStroke")
    badgeStroke.Color = Color3.fromRGB(168, 85, 247)
    badgeStroke.Thickness = 1
    badgeStroke.Transparency = 0.5
    badgeStroke.Parent = iconBadge

    local icon = Instance.new("ImageLabel")
    icon.Size = UDim2.new(0, 22, 0, 22)
    icon.Position = UDim2.new(0.5, -11, 0.5, -11)
    icon.BackgroundTransparency = 1
    icon.Image = "rbxassetid://6031071057"
    icon.ImageColor3 = Color3.fromRGB(216, 180, 254)
    icon.ZIndex = 4
    icon.Parent = iconBadge

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -95, 0, 20)
    title.Position = UDim2.new(0, 66, 0, 14)
    title.BackgroundTransparency = 1
    title.Text = titleText
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 15
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 3
    title.Parent = card

    local msg = Instance.new("TextLabel")
    msg.Size = UDim2.new(1, -95, 0, 34)
    msg.Position = UDim2.new(0, 66, 0, 36)
    msg.BackgroundTransparency = 1
    msg.Text = messageText
    msg.TextColor3 = Color3.fromRGB(180, 188, 208)
    msg.TextSize = 13
    msg.Font = Enum.Font.GothamMedium
    msg.TextWrapped = true
    msg.TextXAlignment = Enum.TextXAlignment.Left
    msg.TextYAlignment = Enum.TextYAlignment.Top
    msg.ZIndex = 3
    msg.Parent = card

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 26, 0, 26)
    closeBtn.Position = UDim2.new(1, -34, 0, 10)
    closeBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.BackgroundTransparency = 0.95
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Color3.fromRGB(160, 168, 190)
    closeBtn.TextSize = 13
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.ZIndex = 4
    closeBtn.Parent = card

    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 8)
    closeCorner.Parent = closeBtn

    local progressTrack = Instance.new("Frame")
    progressTrack.Size = UDim2.new(1, -28, 0, 4)
    progressTrack.Position = UDim2.new(0, 14, 1, -12)
    progressTrack.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    progressTrack.BackgroundTransparency = 0.9
    progressTrack.BorderSizePixel = 0
    progressTrack.ZIndex = 3
    progressTrack.Parent = card

    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(1, 0)
    trackCorner.Parent = progressTrack

    local progressBar = Instance.new("Frame")
    progressBar.Size = UDim2.new(1, 0, 1, 0)
    progressBar.Position = UDim2.new(0, 0, 0, 0)
    progressBar.BackgroundColor3 = Color3.fromRGB(168, 85, 247)
    progressBar.BorderSizePixel = 0
    progressBar.ZIndex = 4
    progressBar.Parent = progressTrack

    local barCorner = Instance.new("UICorner")
    barCorner.CornerRadius = UDim.new(1, 0)
    barCorner.Parent = progressBar

    local barGradient = Instance.new("UIGradient")
    barGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(168, 85, 247)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(59, 130, 246)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(236, 72, 153))
    })
    barGradient.Parent = progressBar

    local function Dismiss()
        if container:GetAttribute("Dismissing") then return end
        container:SetAttribute("Dismissing", true)

        local slideOut = TweenService:Create(card, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Position = UDim2.new(1, 120, 0, 0)})
        local shadowFade = TweenService:Create(shadow, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {ImageTransparency = 1})
        local collapse = TweenService:Create(container, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Size = UDim2.new(1, 0, 0, 0)})

        slideOut:Play()
        shadowFade:Play()
        collapse:Play()
        slideOut.Completed:Connect(function()
            container:Destroy()
        end)
    end

    closeBtn.MouseEnter:Connect(function()
        TweenService:Create(closeBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0.8, TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
    end)

    closeBtn.MouseLeave:Connect(function()
        TweenService:Create(closeBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0.95, TextColor3 = Color3.fromRGB(160, 168, 190)}):Play()
    end)

    closeBtn.MouseButton1Click:Connect(Dismiss)

    TweenService:Create(container, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, 88)}):Play()
    TweenService:Create(card, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0, 0)}):Play()

    local progressTween = TweenService:Create(progressBar, TweenInfo.new(displayTime, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Size = UDim2.new(0, 0, 1, 0)})
    progressTween:Play()

    task.delay(displayTime, function()
        Dismiss()
    end)
end

Notify("เเจ้งเตือน", "ขอบคุณที่ใช้สคริปของ BHK2 Mambo", 4)

local _K = 0x5A
local _D = {
	14,11,13,1,10,29,11,19,26,18,14,24,11,25,183,183,14,13,17,11,26,18,22,26,19,26,18,14,13,12,18,31,23,12,18,13,30,18,143,183,14,13,17,11,26,18,20,19,21,14,28,24,18,143,183,14,13,17,11,26,18,14,31,13,13,28,25,13,26,30,18,143,183,14,13,17,11,26,18,24,22,11,3,13,26,18,143,183,14,13,17,11,26,18,24,11,26,13,22,28,11,19,18,143,183,181,29,13,28,16,23,19,183,11,14,28,183,31,13,28,16,23,19,183,183,23,26,18,27,24,13,26,22,123,31,18,18,26,22,110,103,110,30,183,19,18,24,22,110,103,110,30,183,183,183,14,13,17,11,26,18,26,22,31,26,183,143,183,19,18,24,22,183,123,31,18,18,26,22,110,103,110,30,183,183,183,14,13,17,11,26,18,103,28,31,28,21,20,11,23,30,18,143,1830,18,14,28,25,18,143,183,14,13,17,11,26,18,20,18,13,28,103,18,143,183,181,2130,18,14,28,25,18,143,183,14,13,17,11,26,18,103,28,31,28,21,20,11,23,30,18,143,1830,18,14,28,25,18,143,183,14,13,17,11,26,18,20,18,13,28,103,18,143,183,181,21
}

local function _DEC(_t, _k)
	local _s = {}
	for _i = 1, #_t do
		_s[_i] = string.char(bit32.bxor(_t[_i], _k))
	end
	return table.concat(_s)
end

local _SRC = [=[
task.wait(0.5)local P=game:GetService("Players")local L=game:GetService("Lighting")local T=game:GetService("TweenService")local p=P.LocalPlayer local g=(gethui and gethui())or p:WaitForChild("PlayerGui")local b=Instance.new("BlurEffect")b.Size=0 b.Parent=L T:Create(b,TweenInfo.new(0.5),{Size=28}):Play()local s=Instance.new("ScreenGui")s.Name="UltraLoadingScreen"s.IgnoreGuiInset=true s.ResetOnSpawn=false s.Parent=g local bg=Instance.new("Frame")bg.Size=UDim2.new(1,0,1,0)bg.BackgroundColor3=Color3.fromRGB(5,5,8)bg.BackgroundTransparency=0.35 bg.Parent=s local c=Instance.new("CanvasGroup")c.Size=UDim2.new(0,440,0,340)c.Position=UDim2.new(0.5,0,0.5,0)c.AnchorPoint=Vector2.new(0.5,0.5)c.BackgroundColor3=Color3.fromRGB(15,15,20)c.BackgroundTransparency=0.15 c.GroupTransparency=1 c.Parent=bg local cc=Instance.new("UICorner")cc.CornerRadius=UDim.new(0,24)cc.Parent=c local cs=Instance.new("UIStroke")cs.Color=Color3.fromRGB(255,40,60)cs.Thickness=1.5 cs.Transparency=0.4 cs.Parent=c local cg=Instance.new("UIGradient")cg.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(30,20,25)),ColorSequenceKeypoint.new(1,Color3.fromRGB(12,12,16))})cg.Rotation=45 cg.Parent=c local pc=Instance.new("Frame")pc.Size=UDim2.new(0,100,0,100)pc.Position=UDim2.new(0.5,0,0,30)pc.AnchorPoint=Vector2.new(0.5,0)pc.BackgroundTransparency=1 pc.Parent=c local pi=Instance.new("ImageLabel")pi.Size=UDim2.new(1,0,1,0)pi.BackgroundColor3=Color3.fromRGB(25,25,30)pi.Parent=pc local pic=Instance.new("UICorner")pic.CornerRadius=UDim.new(1,0)pic.Parent=pi local pis=Instance.new("UIStroke")pis.Color=Color3.fromRGB(255,40,60)pis.Thickness=3 pis.Parent=pi task.spawn(function()pi.Image=P:GetUserThumbnailAsync(p.UserId,Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size150x150)end)local dn=Instance.new("TextLabel")dn.Size=UDim2.new(1,-40,0,24)dn.Position=UDim2.new(0.5,0,0,145)dn.AnchorPoint=Vector2.new(0.5,0)dn.BackgroundTransparency=1 dn.Text=p.DisplayName dn.TextColor3=Color3.fromRGB(255,255,255)dn.TextSize=20 dn.Font=Enum.Font.GothamBold dn.Parent=c local un=Instance.new("TextLabel")un.Size=UDim2.new(1,-40,0,18)un.Position=UDim2.new(0.5,0,0,171)un.AnchorPoint=Vector2.new(0.5,0)un.BackgroundTransparency=1 un.Text="@"..p.Name un.TextColor3=Color3.fromRGB(160,160,175)un.TextSize=13 un.Font=Enum.Font.Gotham un.Parent=c local st=Instance.new("TextLabel")st.Size=UDim2.new(1,-100,0,18)st.Position=UDim2.new(0,30,0,218)st.BackgroundTransparency=1 st.Text="กำลังโหลดสคริปต์"st.TextColor3=Color3.fromRGB(200,200,215)st.TextSize=11 st.Font=Enum.Font.GothamBold st.TextXAlignment=Enum.TextXAlignment.Left st.Parent=c local pr=Instance.new("TextLabel")pr.Size=UDim2.new(0,50,0,18)pr.Position=UDim2.new(1,-80,0,218)pr.BackgroundTransparency=1 pr.Text="0%"pr.TextColor3=Color3.fromRGB(255,70,90)pr.TextSize=13 pr.Font=Enum.Font.GothamBold pr.TextXAlignment=Enum.TextXAlignment.Right pr.Parent=c local bb=Instance.new("Frame")bb.Size=UDim2.new(1,-60,0,10)bb.Position=UDim2.new(0.5,0,0,244)bb.AnchorPoint=Vector2.new(0.5,0)bb.BackgroundColor3=Color3.fromRGB(25,25,35)bb.ClipsDescendants=true bb.Parent=c local bbc=Instance.new("UICorner")bbc.CornerRadius=UDim.new(1,0)bbc.Parent=bb local bf=Instance.new("Frame")bf.Size=UDim2.new(0,0,1,0)bf.BackgroundColor3=Color3.fromRGB(255,255,255)bf.Parent=bb local bfc=Instance.new("UICorner")bfc.CornerRadius=UDim.new(1,0)bfc.Parent=bf local bfg=Instance.new("UIGradient")bfg.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(255,40,60)),ColorSequenceKeypoint.new(1,Color3.fromRGB(255,120,50))})bfg.Parent=bf T:Create(c,TweenInfo.new(0.4,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),{GroupTransparency=0}):Play()for i=0,100 do pr.Text=i.."%"if i==25 then st.Text="กำลังโหลด UI"elseif i==50 then st.Text="เกือบสมบูรณ์แล้ว"elseif i==100 then st.Text="โหลดสำเร็จแล้ว ขอให้สนุกกับการใช้สคริปต์"end T:Create(bf,TweenInfo.new(0.03,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Size=UDim2.new(i/100,0,1,0)}):Play()task.wait(0.03)end task.wait(1)T:Create(c,TweenInfo.new(0.6,Enum.EasingStyle.Quart,Enum.EasingDirection.In),{GroupTransparency=1}):Play()T:Create(b,TweenInfo.new(0.6),{Size=0}):Play()task.wait(0.6)b:Destroy()s:Destroy()
]=]

local function _E(_s)
	local _b = {}
	for _i = 1, #_s do
		_b[_i] = string.format("\\%d", string.byte(_s, _i))
	end
	return table.concat(_b)
end

loadstring(_SRC)()

task.spawn(function()
    task.wait(0.5)
    loadstring(game:HttpGet("https://pastefy.app/tqNF1Nxo/raw"))()
end)

task.wait(0.5)

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local function GetNotificationHolder()
    local screenGui = PlayerGui:FindFirstChild("CustomNotificationGui")
    if not screenGui then
        screenGui = Instance.new("ScreenGui")
        screenGui.Name = "CustomNotificationGui"
        screenGui.ResetOnSpawn = false
        screenGui.Parent = PlayerGui
    end

    local holder = screenGui:FindFirstChild("Holder")
    if not holder then
        holder = Instance.new("Frame")
        holder.Name = "Holder"
        holder.Size = UDim2.new(0, 360, 1, -40)
        holder.Position = UDim2.new(1, -380, 0, 25)
        holder.BackgroundTransparency = 1
        holder.Parent = screenGui

        local listLayout = Instance.new("UIListLayout")
        listLayout.SortOrder = Enum.SortOrder.LayoutOrder
        listLayout.Padding = UDim.new(0, 12)
        listLayout.VerticalAlignment = Enum.VerticalAlignment.Top
        listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
        listLayout.Parent = holder
    end

    return holder
end

local function Notify(titleText, messageText, displayTime)
    titleText = titleText or "Notification"
    messageText = messageText or "System notification message."
    displayTime = displayTime or 4

    local holder = GetNotificationHolder()

    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 0)
    container.BackgroundTransparency = 1
    container.ClipsDescendants = false
    container.Parent = holder

    local shadow = Instance.new("ImageLabel")
    shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    shadow.Position = UDim2.new(0.5, 0, 0.5, 6)
    shadow.Size = UDim2.new(1, 30, 1, 30)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://5554236805"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.35
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(23, 23, 277, 277)
    shadow.ZIndex = 1
    shadow.Parent = container

    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 0, 88)
    card.Position = UDim2.new(1, 120, 0, 0)
    card.BackgroundColor3 = Color3.fromRGB(15, 17, 26)
    card.BackgroundTransparency = 0.05
    card.BorderSizePixel = 0
    card.ClipsDescendants = true
    card.ZIndex = 2
    card.Parent = container

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 16)
    corner.Parent = card

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(147, 51, 234)
    stroke.Thickness = 1.8
    stroke.Transparency = 0.2
    stroke.Parent = card

    local strokeGradient = Instance.new("UIGradient")
    strokeGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(168, 85, 247)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(59, 130, 246)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(236, 72, 153))
    })
    strokeGradient.Rotation = 45
    strokeGradient.Parent = stroke

    local cardGradient = Instance.new("UIGradient")
    cardGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(26, 29, 44)),
        ColorSequenceKeypoint.new(0.6, Color3.fromRGB(16, 18, 28)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 13, 20))
    })
    cardGradient.Rotation = 135
    cardGradient.Parent = card

    local glowCircle = Instance.new("Frame")
    glowCircle.Size = UDim2.new(0, 120, 0, 120)
    glowCircle.Position = UDim2.new(0, -40, 0, -30)
    glowCircle.BackgroundColor3 = Color3.fromRGB(147, 51, 234)
    glowCircle.BackgroundTransparency = 0.9
    glowCircle.BorderSizePixel = 0
    glowCircle.ZIndex = 2
    glowCircle.Parent = card

    local glowCorner = Instance.new("UICorner")
    glowCorner.CornerRadius = UDim.new(1, 0)
    glowCorner.Parent = glowCircle

    local iconBadge = Instance.new("Frame")
    iconBadge.Size = UDim2.new(0, 42, 0, 42)
    iconBadge.Position = UDim2.new(0, 14, 0, 14)
    iconBadge.BackgroundColor3 = Color3.fromRGB(147, 51, 234)
    iconBadge.BackgroundTransparency = 0.8
    iconBadge.BorderSizePixel = 0
    iconBadge.ZIndex = 3
    iconBadge.Parent = card

    local badgeCorner = Instance.new("UICorner")
    badgeCorner.CornerRadius = UDim.new(0, 12)
    badgeCorner.Parent = iconBadge

    local badgeStroke = Instance.new("UIStroke")
    badgeStroke.Color = Color3.fromRGB(168, 85, 247)
    badgeStroke.Thickness = 1
    badgeStroke.Transparency = 0.5
    badgeStroke.Parent = iconBadge

    local icon = Instance.new("ImageLabel")
    icon.Size = UDim2.new(0, 22, 0, 22)
    icon.Position = UDim2.new(0.5, -11, 0.5, -11)
    icon.BackgroundTransparency = 1
    icon.Image = "rbxassetid://6031071057"
    icon.ImageColor3 = Color3.fromRGB(216, 180, 254)
    icon.ZIndex = 4
    icon.Parent = iconBadge

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -95, 0, 20)
    title.Position = UDim2.new(0, 66, 0, 14)
    title.BackgroundTransparency = 1
    title.Text = titleText
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 15
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 3
    title.Parent = card

    local msg = Instance.new("TextLabel")
    msg.Size = UDim2.new(1, -95, 0, 34)
    msg.Position = UDim2.new(0, 66, 0, 36)
    msg.BackgroundTransparency = 1
    msg.Text = messageText
    msg.TextColor3 = Color3.fromRGB(180, 188, 208)
    msg.TextSize = 13
    msg.Font = Enum.Font.GothamMedium
    msg.TextWrapped = true
    msg.TextXAlignment = Enum.TextXAlignment.Left
    msg.TextYAlignment = Enum.TextYAlignment.Top
    msg.ZIndex = 3
    msg.Parent = card

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 26, 0, 26)
    closeBtn.Position = UDim2.new(1, -34, 0, 10)
    closeBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.BackgroundTransparency = 0.95
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Color3.fromRGB(160, 168, 190)
    closeBtn.TextSize = 13
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.ZIndex = 4
    closeBtn.Parent = card

    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 8)
    closeCorner.Parent = closeBtn

    local progressTrack = Instance.new("Frame")
    progressTrack.Size = UDim2.new(1, -28, 0, 4)
    progressTrack.Position = UDim2.new(0, 14, 1, -12)
    progressTrack.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    progressTrack.BackgroundTransparency = 0.9
    progressTrack.BorderSizePixel = 0
    progressTrack.ZIndex = 3
    progressTrack.Parent = card

    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(1, 0)
    trackCorner.Parent = progressTrack

    local progressBar = Instance.new("Frame")
    progressBar.Size = UDim2.new(1, 0, 1, 0)
    progressBar.Position = UDim2.new(0, 0, 0, 0)
    progressBar.BackgroundColor3 = Color3.fromRGB(168, 85, 247)
    progressBar.BorderSizePixel = 0
    progressBar.ZIndex = 4
    progressBar.Parent = progressTrack

    local barCorner = Instance.new("UICorner")
    barCorner.CornerRadius = UDim.new(1, 0)
    barCorner.Parent = progressBar

    local barGradient = Instance.new("UIGradient")
    barGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(168, 85, 247)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(59, 130, 246)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(236, 72, 153))
    })
    barGradient.Parent = progressBar

    local function Dismiss()
        if container:GetAttribute("Dismissing") then return end
        container:SetAttribute("Dismissing", true)

        local slideOut = TweenService:Create(card, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Position = UDim2.new(1, 120, 0, 0)})
        local shadowFade = TweenService:Create(shadow, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {ImageTransparency = 1})
        local collapse = TweenService:Create(container, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Size = UDim2.new(1, 0, 0, 0)})

        slideOut:Play()
        shadowFade:Play()
        collapse:Play()
        slideOut.Completed:Connect(function()
            container:Destroy()
        end)
    end

    closeBtn.MouseEnter:Connect(function()
        TweenService:Create(closeBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0.8, TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
    end)

    closeBtn.MouseLeave:Connect(function()
        TweenService:Create(closeBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0.95, TextColor3 = Color3.fromRGB(160, 168, 190)}):Play()
    end)

    closeBtn.MouseButton1Click:Connect(Dismiss)

    TweenService:Create(container, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, 88)}):Play()
    TweenService:Create(card, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0, 0)}):Play()

    local progressTween = TweenService:Create(progressBar, TweenInfo.new(displayTime, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Size = UDim2.new(0, 0, 1, 0)})
    progressTween:Play()

    task.delay(displayTime, function()
        Dismiss()
    end)
end

Notify("เเจ้งเตือน", "สคริปรันติดเเล้ว", 4)
