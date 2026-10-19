-- This file was generated at discord.gg/syncrypt

local t1 = {}
local unpack_ = unpack or table.unpack
local t2 = {
	value1 = {
		["Treascure"] = true,
		["den4imen4ick"] = true
	},
	value2 = "wss://rglobal-chat.onrender.com"
}
local Players = game:GetService("Players")

t2.value3 = game:GetService("HttpService")

local CoreGui = game:GetService("CoreGui")

t2.value4 = game:GetService("RunService")
t2.value5 = game:GetService("MarketplaceService")
game:GetService("TweenService")
t2.value6 = game:GetService("UserInputService")
t2.value7 = Players.LocalPlayer
t2.value8 = "global"
t2.value9 = nil
t2.value10 = 75
t2.value11 = {}
t2.value12 = "GlobalChatConnections.json"
Players = "GlobalChatBan.json"
t2.value13 = "GlobalChatMuted.json"
t2.value14 = "GlobalChatSettings.json"
t2.value15 = {}
t2.value16 = {}
t2.value17 = {}
t2.value18 = false
t2.value19 = false
t2.value20 = 0
t2.value21 = {
	["ShowGame"] = true,
	["BlockedUsers"] = {}
}
if t2.value6.TouchEnabled then
    t1.value1 = not t2.value6.KeyboardEnabled
end
t2.value22 = "Unknown Game"
task.spawn(function()
    local function v6()
        local productInfo = t2.value5:GetProductInfo(game.PlaceId)

        if not productInfo then
            return
        end

        t2.value22 = productInfo.Name
    end

    pcall(v6)
end)

local function v8(p1, p2)
    local isfile_ = isfile

    if not isfile_ then
        if not isfile_ then
            return p2
        end

        return
    end

    isfile_ = isfile(p1)

    if not isfile_ then
        return p2
    end
end
local isfile_ = isfile
if isfile_ then
    isfile_ = isfile(Players)
end
if isfile_ then
    Players = v8(Players, {})

    if Players then
        Players = Players.banned
    end

    t1.value2 = Players

    if t1.value2 then
        t2.value18 = true
    end
end
t2.value15 = v8(t2.value12, {})
t2.value16 = v8("GlobalChatMods.json", {})
t2.value21 = v8(t2.value14, t2.value21)
Players = v8(t2.value13, {
	["muted"] = false,
	["endTime"] = 0
})
if Players then
    v8 = Players.muted
else
    v8 = Players
end
if v8 then
    v8 = Players.endTime

    if v8 then
        v8 = Players.endTime > 0
    end

    if v8 then
        t1.value3 = Players.endTime
        t1.value4 = os.time()

        if t1.value3 > t1.value4 then
            t2.value19 = true
            t2.value20 = Players.endTime
        else
            t2.value19 = false
            t2.value20 = 0
            t1 = t2.value13
            Players = {
				["muted"] = false,
				["endTime"] = 0
			}

            if writefile then
                pcall(function()
                    writefile(t1, t2.value3:JSONEncode(Players))
                end)
            end
        end
    else
        t2.value19 = true
        t2.value20 = 0
    end
end
if CoreGui:FindFirstChild("GlobalChatUI_V12") then
    CoreGui.GlobalChatUI_V12:Destroy()
end
t1 = Instance.new("ScreenGui")
t1.Name = "GlobalChatUI_V12"
t1.Parent = CoreGui
t1.IgnoreGuiInset = true
t1.ResetOnSpawn = false
Players = function(p3)
    local u11 = false
    local u12
    local Position
    local Position2
    p3.InputBegan:Connect(function(input)
        if not (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            return
        end
        u11 = true
        Position = input.Position
        Position2 = p3.Position
        local connection
        connection = input.Changed:Connect(function()
            if input.UserInputState ~= Enum.UserInputState.End then
                return
            end

            u11 = false

            if not connection then
                return
            end

            connection:Disconnect()
        end)
    end)
    p3.InputChanged:Connect(function(input)
        if not (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            return
        end

        u12 = input
    end)
    t2.value6.InputChanged:Connect(function(input)
        if input == u12 then
            v22 = u11
        else
            v22 = false
        end

        if not v22 then
            return
        end

        local v16 = input.Position - Position

        p3.Position = UDim2.new(Position2.X.Scale, Position2.X.Offset + v16.X, Position2.Y.Scale, Position2.Y.Offset + v16.Y)
    end)
end
t2.value23 = Instance.new("TextButton", t1)
t2.value23.Size = UDim2.new(0, 100, 0, 50)
t2.value23.Position = UDim2.new(0, 10, 0.1, 0)
t2.value23.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
t2.value23.TextColor3 = Color3.fromRGB(255, 255, 255)
t2.value23.Text = "MENU"
t2.value23.Font = Enum.Font.SourceSansBold
t2.value23.TextSize = 18
t2.value23.ZIndex = 10
Instance.new("UICorner", t2.value23).CornerRadius = UDim.new(0, 10)
Players(t2.value23)
t2.value24 = Instance.new("Frame", t1)
t2.value24.Size = UDim2.new(0.6, 0, 0.6, 0)
t2.value24.Position = UDim2.new(0.2, 0, 0.2, 0)
t2.value24.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
t2.value24.Visible = false
t2.value24.Active = true
t2.value24.ZIndex = 5
Instance.new("UICorner", t2.value24).CornerRadius = UDim.new(0, 12)
Players(t2.value24)
t2.value25 = Instance.new("TextLabel", t2.value24)
t2.value25.Size = UDim2.new(1, -120, 0, 40)
t2.value25.Position = UDim2.new(0, 40, 0, 0)
t2.value25.BackgroundTransparency = 1
t2.value25.Text = "Global Chat Hub"
t2.value25.TextColor3 = Color3.fromRGB(255, 255, 255)
t2.value25.Font = Enum.Font.SourceSansBold
t2.value25.TextSize = 20
t2.value25.ZIndex = 6
t1 = Instance.new("TextButton", t2.value24)
t1.Size = UDim2.new(0, 30, 0, 30)
t1.Position = UDim2.new(1, -35, 0, 5)
t1.BackgroundTransparency = 1
t1.Text = "X"
t1.TextColor3 = Color3.fromRGB(255, 50, 50)
t1.TextSize = 22
t1.Font = Enum.Font.SourceSansBold
t1.ZIndex = 6
Players = Instance.new("TextButton", t2.value24)
Players.Size = UDim2.new(0, 30, 0, 30)
Players.Position = UDim2.new(1, -70, 0, 5)
Players.BackgroundTransparency = 1
Players.Text = "="
Players.TextColor3 = Color3.fromRGB(200, 200, 200)
Players.TextSize = 22
Players.ZIndex = 6
t2.value26 = Instance.new("TextButton", t2.value24)
t2.value26.Size = UDim2.new(0, 30, 0, 30)
t2.value26.Position = UDim2.new(1, -105, 0, 5)
t2.value26.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
t2.value26.Text = "X"
t2.value26.TextColor3 = Color3.fromRGB(255, 255, 255)
t2.value26.TextSize = 16
t2.value26.Visible = false
t2.value26.ZIndex = 6
Instance.new("UICorner", t2.value26).CornerRadius = UDim.new(0, 6)
t2.value27 = Instance.new("TextButton", t2.value24)
t2.value27.Size = UDim2.new(0, 60, 0, 30)
t2.value27.Position = UDim2.new(0, 5, 0, 5)
t2.value27.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
t2.value27.Text = "Back"
t2.value27.TextColor3 = Color3.fromRGB(255, 255, 255)
t2.value27.Visible = false
t2.value27.ZIndex = 6
Instance.new("UICorner", t2.value27).CornerRadius = UDim.new(0, 6)
CoreGui = Instance.new("Frame", t2.value24)
CoreGui.Size = UDim2.new(1, 0, 1, -50)
CoreGui.Position = UDim2.new(0, 0, 0, 50)
CoreGui.BackgroundTransparency = 1
CoreGui.ClipsDescendants = true
CoreGui.ZIndex = 5
t2.value28 = Instance.new("Frame", CoreGui)
t2.value28.Size = UDim2.new(1, 0, 1, 0)
t2.value28.BackgroundTransparency = 1
t2.value28.Visible = true
t2.value28.ZIndex = 5
t2.value28.Name = "MenuPage"
v8 = Instance.new("UIListLayout", t2.value28)
v8.SortOrder = Enum.SortOrder.LayoutOrder
v8.Padding = UDim.new(0, 12)
v8.HorizontalAlignment = Enum.HorizontalAlignment.Center
v8.VerticalAlignment = Enum.VerticalAlignment.Center
v8 = function(p4, p5, p6)
    local TextButton = Instance.new("TextButton", t2.value28)

    TextButton.Size = UDim2.new(0.75, 0, 0, 45)
    TextButton.BackgroundColor3 = p6 or Color3.fromRGB(50, 50, 50)
    TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextButton.Text = p4
    TextButton.Font = Enum.Font.SourceSansBold
    TextButton.TextSize = 18
    TextButton.LayoutOrder = p5
    TextButton.ZIndex = 6
    Instance.new("UICorner", TextButton).CornerRadius = UDim.new(0, 10)

    return TextButton
end
isfile_ = v8("World Chat", 1, Color3.fromRGB(50, 100, 150))
t2.value29 = v8("Connections", 2, Color3.fromRGB(80, 80, 80))
v8 = v8("Lobbies", 3, Color3.fromRGB(80, 80, 80))
t2.value30 = Instance.new("Frame", CoreGui)
t2.value30.Size = UDim2.new(1, 0, 1, 0)
t2.value30.BackgroundTransparency = 1
t2.value30.Visible = false
t2.value30.ClipsDescendants = true
t2.value30.ZIndex = 5
t2.value30.Name = "ChatPage"
t2.value31 = Instance.new("ScrollingFrame", t2.value30)
t2.value31.Size = UDim2.new(1, -20, 1, -50)
t2.value31.Position = UDim2.new(0, 10, 0, 0)
t2.value31.BackgroundTransparency = 1
t2.value31.AutomaticCanvasSize = Enum.AutomaticSize.Y
t2.value31.CanvasSize = UDim2.new(0, 0, 0, 0)
t2.value31.ScrollBarThickness = 4
t2.value31.ScrollingDirection = Enum.ScrollingDirection.Y
t2.value31.ZIndex = 5
Instance.new("UIListLayout", t2.value31).Padding = UDim.new(0, 5)

local Frame = Instance.new("Frame", t2.value30)

Frame.Size = UDim2.new(1, -20, 0, 38)
Frame.AnchorPoint = Vector2.new(0, 1)
Frame.Position = UDim2.new(0, 10, 1, -5)
Frame.BackgroundTransparency = 1
Frame.ZIndex = 6
t2.value32 = Instance.new("TextBox", Frame)
t2.value32.Size = UDim2.new(0.82, 0, 1, 0)
t2.value32.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
t2.value32.TextColor3 = Color3.fromRGB(255, 255, 255)
t2.value32.Text = ""
t2.value32.PlaceholderText = "Type a message..."
t2.value32.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
t2.value32.ClearTextOnFocus = false
t2.value32.TextXAlignment = Enum.TextXAlignment.Left
t2.value32.ZIndex = 7
t2.value32.Font = Enum.Font.SourceSans
t2.value32.TextSize = 16
Instance.new("UICorner", t2.value32).CornerRadius = UDim.new(0, 8)
Instance.new("UIPadding", t2.value32).PaddingLeft = UDim.new(0, 10)
t2.value33 = Instance.new("TextButton", Frame)
t2.value33.Size = UDim2.new(0.16, 0, 1, 0)
t2.value33.Position = UDim2.new(0.84, 0, 0, 0)
t2.value33.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
t2.value33.Text = ">"
t2.value33.TextColor3 = Color3.fromRGB(255, 255, 255)
t2.value33.TextSize = 20
t2.value33.ZIndex = 7
Instance.new("UICorner", t2.value33).CornerRadius = UDim.new(0, 8)
t2.value34 = Instance.new("TextButton", t2.value30)
t2.value34.Size = UDim2.new(0, 35, 0, 35)
t2.value34.Position = UDim2.new(1, -50, 1, -90)
t2.value34.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
t2.value34.TextColor3 = Color3.fromRGB(255, 255, 255)
t2.value34.Text = "v"
t2.value34.TextSize = 18
t2.value34.Visible = false
t2.value34.ZIndex = 7
Instance.new("UICorner", t2.value34).CornerRadius = UDim.new(1, 0)
t2.value35 = Instance.new("Frame", CoreGui)
t2.value35.Size = UDim2.new(1, 0, 1, 0)
t2.value35.BackgroundTransparency = 1
t2.value35.Visible = false
t2.value35.ZIndex = 5
t2.value35.Name = "SettingsPage"
t2.value36 = Instance.new("ScrollingFrame", t2.value35)
t2.value36.Size = UDim2.new(1, -20, 1, 0)
t2.value36.Position = UDim2.new(0, 10, 0, 0)
t2.value36.BackgroundTransparency = 1
t2.value36.AutomaticCanvasSize = Enum.AutomaticSize.Y
t2.value36.CanvasSize = UDim2.new(0, 0, 0, 0)
t2.value36.ScrollBarThickness = 4
t2.value36.ZIndex = 5
Frame = Instance.new("UIListLayout", t2.value36)
Frame.Padding = UDim.new(0, 10)
Frame.HorizontalAlignment = Enum.HorizontalAlignment.Center
t2.value37 = Instance.new("Frame", CoreGui)
t2.value37.Size = UDim2.new(1, 0, 1, 0)
t2.value37.BackgroundTransparency = 1
t2.value37.Visible = false
t2.value37.ZIndex = 5
t2.value37.Name = "ConnectionsPage"
t2.value38 = Instance.new("TextBox", t2.value37)
t2.value38.Size = UDim2.new(0.6, 0, 0, 38)
t2.value38.Position = UDim2.new(0, 10, 0, 5)
t2.value38.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
t2.value38.TextColor3 = Color3.fromRGB(255, 255, 255)
t2.value38.PlaceholderText = "Enter username..."
t2.value38.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
t2.value38.Text = ""
t2.value38.ZIndex = 6
t2.value38.Font = Enum.Font.SourceSans
t2.value38.TextSize = 16
Instance.new("UICorner", t2.value38).CornerRadius = UDim.new(0, 8)
Instance.new("UIPadding", t2.value38).PaddingLeft = UDim.new(0, 10)
Frame = Instance.new("TextButton", t2.value37)
Frame.Size = UDim2.new(0.35, -15, 0, 38)
Frame.Position = UDim2.new(0.65, 0, 0, 5)
Frame.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
Frame.Text = "Open Chat"
Frame.TextColor3 = Color3.fromRGB(255, 255, 255)
Frame.ZIndex = 6
Frame.Font = Enum.Font.SourceSansBold
Frame.TextSize = 16
Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)
t2.value39 = Instance.new("ScrollingFrame", t2.value37)
t2.value39.Size = UDim2.new(1, -20, 1, -55)
t2.value39.Position = UDim2.new(0, 10, 0, 50)
t2.value39.BackgroundTransparency = 1
t2.value39.AutomaticCanvasSize = Enum.AutomaticSize.Y
t2.value39.CanvasSize = UDim2.new(0, 0, 0, 0)
t2.value39.ScrollingDirection = Enum.ScrollingDirection.Y
t2.value39.ScrollBarThickness = 4
t2.value39.ZIndex = 5
Instance.new("UIListLayout", t2.value39).Padding = UDim.new(0, 8)
t2.value40 = Instance.new("Frame", CoreGui)
t2.value40.Size = UDim2.new(1, 0, 1, 0)
t2.value40.BackgroundTransparency = 1
t2.value40.Visible = false
t2.value40.ZIndex = 5
t2.value40.Name = "LobbyPage"
CoreGui = Instance.new("ScrollingFrame", t2.value40)
CoreGui.Size = UDim2.new(1, -20, 1, 0)
CoreGui.Position = UDim2.new(0, 10, 0, 0)
CoreGui.BackgroundTransparency = 1
CoreGui.AutomaticCanvasSize = Enum.AutomaticSize.Y
CoreGui.CanvasSize = UDim2.new(0, 0, 0, 0)
CoreGui.ScrollBarThickness = 4
CoreGui.ZIndex = 5
local UIListLayout = Instance.new("UIListLayout", CoreGui)

UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 15)
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
Instance.new("UIPadding", CoreGui).PaddingTop = UDim.new(0, 20)
UIListLayout = Instance.new("Frame", CoreGui)
UIListLayout.Size = UDim2.new(0.95, 0, 0, 130)
UIListLayout.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
UIListLayout.LayoutOrder = 1
UIListLayout.ZIndex = 6
Instance.new("UICorner", UIListLayout).CornerRadius = UDim.new(0, 12)

local TextLabel = Instance.new("TextLabel", UIListLayout)

TextLabel.Size = UDim2.new(1, 0, 0, 30)
TextLabel.Position = UDim2.new(0, 0, 0, 10)
TextLabel.BackgroundTransparency = 1
TextLabel.Text = "Join Existing Lobby"
TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.Font = Enum.Font.SourceSansBold
TextLabel.TextSize = 18
TextLabel.ZIndex = 7
t2.value41 = Instance.new("TextBox", UIListLayout)
t2.value41.Size = UDim2.new(0.9, 0, 0, 40)
t2.value41.Position = UDim2.new(0.05, 0, 0, 45)
t2.value41.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
t2.value41.TextColor3 = Color3.fromRGB(255, 255, 255)
t2.value41.Text = ""
t2.value41.PlaceholderText = "Enter lobby code..."
t2.value41.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
t2.value41.TextSize = 18
t2.value41.Font = Enum.Font.SourceSans
t2.value41.ZIndex = 7
Instance.new("UICorner", t2.value41).CornerRadius = UDim.new(0, 8)
Instance.new("UIPadding", t2.value41).PaddingLeft = UDim.new(0, 12)
UIListLayout = Instance.new("TextButton", UIListLayout)
UIListLayout.Size = UDim2.new(0.9, 0, 0, 35)
UIListLayout.Position = UDim2.new(0.05, 0, 0, 90)
UIListLayout.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
UIListLayout.Text = "Join Lobby"
UIListLayout.TextColor3 = Color3.fromRGB(255, 255, 255)
UIListLayout.TextSize = 16
UIListLayout.Font = Enum.Font.SourceSansBold
UIListLayout.ZIndex = 7
Instance.new("UICorner", UIListLayout).CornerRadius = UDim.new(0, 8)
TextLabel = Instance.new("Frame", CoreGui)
TextLabel.Size = UDim2.new(0.95, 0, 0, 100)
TextLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
TextLabel.LayoutOrder = 2
TextLabel.ZIndex = 6
Instance.new("UICorner", TextLabel).CornerRadius = UDim.new(0, 12)

local TextLabel2 = Instance.new("TextLabel", TextLabel)

TextLabel2.Size = UDim2.new(1, 0, 0, 30)
TextLabel2.Position = UDim2.new(0, 0, 0, 10)
TextLabel2.BackgroundTransparency = 1
TextLabel2.Text = "Create New Lobby"
TextLabel2.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel2.Font = Enum.Font.SourceSansBold
TextLabel2.TextSize = 18
TextLabel2.ZIndex = 7
TextLabel = Instance.new("TextButton", TextLabel)
TextLabel.Size = UDim2.new(0.9, 0, 0, 45)
TextLabel.Position = UDim2.new(0.05, 0, 0, 48)
TextLabel.BackgroundColor3 = Color3.fromRGB(40, 160, 40)
TextLabel.Text = "Generate Random Code"
TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.TextSize = 16
TextLabel.Font = Enum.Font.SourceSansBold
TextLabel.ZIndex = 7
Instance.new("UICorner", TextLabel).CornerRadius = UDim.new(0, 8)
t2.value42 = Instance.new("Frame", CoreGui)
t2.value42.Size = UDim2.new(0.95, 0, 0, 110)
t2.value42.BackgroundColor3 = Color3.fromRGB(60, 40, 80)
t2.value42.LayoutOrder = 3
t2.value42.Visible = false
t2.value42.ZIndex = 6
Instance.new("UICorner", t2.value42).CornerRadius = UDim.new(0, 12)
CoreGui = Instance.new("TextLabel", t2.value42)
CoreGui.Size = UDim2.new(1, 0, 0, 25)
CoreGui.Position = UDim2.new(0, 0, 0, 10)
CoreGui.BackgroundTransparency = 1
CoreGui.Text = "Current Lobby"
CoreGui.TextColor3 = Color3.fromRGB(200, 180, 255)
CoreGui.Font = Enum.Font.SourceSansBold
CoreGui.TextSize = 16
CoreGui.ZIndex = 7
t2.value43 = Instance.new("TextLabel", t2.value42)
t2.value43.Size = UDim2.new(1, 0, 0, 30)
t2.value43.Position = UDim2.new(0, 0, 0, 35)
t2.value43.BackgroundTransparency = 1
t2.value43.Text = ""
t2.value43.TextColor3 = Color3.fromRGB(255, 255, 255)
t2.value43.Font = Enum.Font.SourceSansBold
t2.value43.TextSize = 22
t2.value43.ZIndex = 7
CoreGui = Instance.new("TextButton", t2.value42)
CoreGui.Size = UDim2.new(0.9, 0, 0, 32)
CoreGui.Position = UDim2.new(0.05, 0, 0, 70)
CoreGui.BackgroundColor3 = Color3.fromRGB(100, 60, 140)
CoreGui.Text = "Return to Lobby"
CoreGui.TextColor3 = Color3.fromRGB(255, 255, 255)
CoreGui.TextSize = 15
CoreGui.Font = Enum.Font.SourceSansBold
CoreGui.ZIndex = 7
Instance.new("UICorner", CoreGui).CornerRadius = UDim.new(0, 8)
TextLabel2 = function(p7)
    if type(p7) == "string" then
        local v23 = string.gsub(p7, "&", "&amp;")

        v23 = string.gsub(v23, "<", "&lt;")
        v23 = string.gsub(v23, ">", "&gt;")
        v23 = string.gsub(v23, "\"", "&quot;")

        return string.gsub(v23, "\'", "&apos;")
    else
        return ""
    end
end
t2.value44 = nil
function t2.value44(p8)
    for _, v in pairs({
		"fuck",
		"nigga",
		"nigger",
		"fucker",
		"bitch"
	}) do
        local s1 = ""

        for i = 1, #v do
            local v27 = string.sub(v, i, i)

            s1 = s1 .. "[" .. string.lower(v27) .. string.upper(v27) .. "]"
        end

        p8 = string.gsub(p8, s1, string.rep("#", #v))
    end

    return p8
end
function t2.value45(p9)
    return t2.value44((TextLabel2(p9)))
end
function t2.value46(p10)
    if type(p10) ~= "string" then
        return ""
    end
end
function t2.value47(p11)
    if not p11 or p11 <= 0 then
        return "permanent"
    else
        local v28

        if p11 >= 3600 then
            v28 = p11 / 3600

            return math.floor(v28) .. "h"
        else
            if p11 >= 60 then
                v28 = p11 / 60

                return math.floor(v28) .. "m"
            else
                return p11 .. "s"
            end

            return
        end

        return
    end
end
function t2.value48(p12)
    if not p12 or (p12 == "global" or string.sub(p12, 1, 2) == "L_") then
        return nil
    else
        local Name = t2.value7.Name
        local v30 = #Name + 1

        if string.sub(p12, 1, v30) == Name .. "_" then
            return string.sub(p12, #Name + 2)
        else
            v30 = -#Name - 1

            if string.sub(p12, v30) == "_" .. Name then
                return string.sub(p12, 1, #p12 - #Name - 1)
            else
                return nil
            end

            return
        end

        return
    end
end
t2.value49 = nil
function t2.value50()
    if t2.value9 then
        t2.value42.Visible = true

        local value43 = t2.value43
        local value9 = t2.value9

        value43.Text = string.sub(value9, 3)

        return
    else
        t2.value42.Visible = false
        t2.value43.Text = ""

        return
    end
end
function t2.value51()
    local value26 = t2.value26
    local value8 = t2.value8

    if not value8 then
        value26.Visible = value8

        return
    end

    value8 = t2.value8
    value8 = string.sub(value8, 1, 2) == "L_"

    if not value8 then
        value26.Visible = value8

        return
    end

    value8 = t2.value30.Visible
    value26.Visible = value8
end
function t2.value52()
    local value19 = t2.value19

    if value19 then
        value19 = t2.value20 > 0
    end

    if not value19 then
        return t2.value19
    end

    if not (os.time() >= t2.value20) then
        return true
    end

    t2.value19 = false
    t2.value20 = 0
    value19 = t2.value13

    local t3 = {
		["muted"] = false,
		["endTime"] = 0
	}

    if not writefile then
        return false
    end

    value19 = function()
        writefile(value19, t2.value3:JSONEncode(t3))
    end
    pcall(value19)

    return false
end
TextLabel2 = function()
    t2.value52()

    if t2.value8 ~= "global" then
        t2.value32.TextEditable = true
        t2.value32.PlaceholderText = "Type a message..."
        t2.value33.Visible = true

        return
    end

    if t2.value18 then
        t2.value32.TextEditable = false
        t2.value32.Text = ""
        t2.value32.PlaceholderText = "You are banned"
        t2.value33.Visible = false

        return
    end

    if not t2.value19 then
        t2.value32.TextEditable = true
        t2.value32.PlaceholderText = "Type a message..."
        t2.value33.Visible = true

        return
    end

    t2.value32.TextEditable = false

    local value32 = t2.value32
    local s2 = "PlaceholderText"
    local v39 = t2.value20 > 0

    if v39 then
        v39 = t2.value20 - os.time() > 0
    end

    if not v39 then
        value32[s2] = v39 or "You are muted (permanent)"
        t2.value33.Visible = false

        return
    end

    v39 = "Muted (" .. t2.value47(t2.value20 - os.time()) .. " left)"
    value32[s2] = v39 or "You are muted (permanent)"
    t2.value33.Visible = false
end
function t2.value53()
    local pairs_ = pairs
    local value31 = t2.value31

    for _, child in pairs_(value31:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
end
function t2.value54()
    local n1 = 0

    for _, v in pairs(t2.value17) do
        n1 = n1 + v
    end

    t2.value29.Text = n1 > 0 and "Connections (" .. n1 .. ")" or "Connections"
end
function t2.value55()
    return t2.value31.CanvasPosition.Y + t2.value31.AbsoluteWindowSize.Y >= t2.value31.AbsoluteCanvasSize.Y - 25
end
function t2.value56()
    task.spawn(function()
        t2.value4.RenderStepped:Wait()
        t2.value31.CanvasPosition = Vector2.new(0, t2.value31.AbsoluteCanvasSize.Y)
    end)
end
t2.value34.MouseButton1Click:Connect(t2.value56)
t2.value31:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
    t2.value34.Visible = not t2.value55()
end)
t2.value57 = nil
t2.value58 = nil
t2.value59 = nil
t2.value60 = nil
t2.value58 = nil
t2.value61 = nil
t2.value60 = nil
function t2.value57(p13)
    if not p13 then
        return
    end

    t2.value8 = p13
    t2.value53()
    TextLabel2()

    local dm

    if not t2.value49 then
        v64 = "World Chat"

        if string.sub(p13, 1, 2) == "L_" then
            t2.value9 = p13
            v64 = "Lobby: " .. string.sub(p13, 3)
        else
            if p13 == "global" then
                t2.value60("ChatPage", v64, true)
                t2.value50()

                return
            end

            dm = t2.value48(p13)

            if dm then
                v64 = "DM: " .. dm
                t2.value17[dm] = 0
                t2.value54()
            else
                v64 = "DM"
            end
        end

        t2.value60("ChatPage", v64, true)
        t2.value50()

        return
    end

    local function v48()
        t2.value49:Send(t2.value3:JSONEncode({
			["type"] = "join",
			["username"] = t2.value7.Name,
			["room"] = p13
		}))
    end

    pcall(v48)
    v48 = "World Chat"

    if string.sub(p13, 1, 2) == "L_" then
        t2.value9 = p13
        v48 = "Lobby: " .. string.sub(p13, 3)
    else
        if p13 == "global" then
            t2.value60("ChatPage", v48, true)
            t2.value50()

            return
        end

        dm = t2.value48(p13)

        if dm then
            v48 = "DM: " .. dm
            t2.value17[dm] = 0
            t2.value54()
        else
            v48 = "DM"
        end
    end

    t2.value60("ChatPage", v48, true)
    t2.value50()
end
function t2.value60(p14, p15, p16)
    local v49 = p16 == nil and true or p16
    local Text = t2.value25.Text
    local v51 = t2.value28.Visible and "MenuPage" or (t2.value30.Visible and "ChatPage" or (t2.value37.Visible and "ConnectionsPage" or (t2.value40.Visible and "LobbyPage" or (t2.value35.Visible and "SettingsPage" or nil))))

    if v51 == p14 then
        return
    end

    if not (v49 and v51) then
        t2.value28.Visible = false
        t2.value30.Visible = false
        t2.value37.Visible = false
        t2.value40.Visible = false
        t2.value35.Visible = false

        if p14 == "MenuPage" then
            t2.value28.Visible = true
            t2.value27.Visible = false
            t2.value11 = {}
        elseif p14 == "ChatPage" then
            t2.value30.Visible = true
            t2.value27.Visible = true
        elseif p14 == "ConnectionsPage" then
            t2.value37.Visible = true
            t2.value27.Visible = true
            t2.value58()
        elseif p14 == "LobbyPage" then
            t2.value40.Visible = true
            t2.value27.Visible = true
            t2.value50()
        else
            if p14 ~= "SettingsPage" then
                t2.value25.Text = p15 or "Global Chat Hub"
                t2.value51()

                return
            end

            t2.value35.Visible = true
            t2.value27.Visible = true
        end

        t2.value25.Text = p15 or "Global Chat Hub"
        t2.value51()

        return
    end

    table.insert(t2.value11, {
		["page"] = v51,
		["title"] = Text,
		["room"] = t2.value8
	})
    t2.value28.Visible = false
    t2.value30.Visible = false
    t2.value37.Visible = false
    t2.value40.Visible = false
    t2.value35.Visible = false

    if p14 == "MenuPage" then
        t2.value28.Visible = true
        t2.value27.Visible = false
        t2.value11 = {}
    elseif p14 == "ChatPage" then
        t2.value30.Visible = true
        t2.value27.Visible = true
    elseif p14 == "ConnectionsPage" then
        t2.value37.Visible = true
        t2.value27.Visible = true
        t2.value58()
    elseif p14 == "LobbyPage" then
        t2.value40.Visible = true
        t2.value27.Visible = true
        t2.value50()
    else
        if p14 ~= "SettingsPage" then
            t2.value25.Text = p15 or "Global Chat Hub"
            t2.value51()

            return
        end

        t2.value35.Visible = true
        t2.value27.Visible = true
    end

    t2.value25.Text = p15 or "Global Chat Hub"
    t2.value51()
end
function t2.value59(p17)
    if not p17 or (p17 == t2.value7.Name and true or p17 == "SYSTEM") then
        return
    end
end
function t2.value62(p18)
    for k, v in pairs(t2.value15) do
        if v == p18 then
            table.remove(t2.value15, k)

            local value12 = t2.value12
            local value15 = t2.value15

            if not writefile then
                t2.value17[p18] = nil
                t2.value54()

                return true
            end

            value12 = function()
                writefile(value12, t2.value3:JSONEncode(value15))
            end
            pcall(value12)
            t2.value17[p18] = nil
            t2.value54()

            return true
        end
    end

    return false
end
function t2.value63(p19, p20, p21)
    local TextLabel3 = Instance.new("TextLabel", p19)

    TextLabel3.Size = UDim2.new(1, 0, 0, 0)
    TextLabel3.AutomaticSize = Enum.AutomaticSize.Y
    TextLabel3.BackgroundTransparency = 1
    TextLabel3.Text = t2.value46(t2.value45(p20))
    TextLabel3.TextColor3 = p21 or Color3.fromRGB(255, 255, 255)
    TextLabel3.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel3.Font = Enum.Font.SourceSans
    TextLabel3.TextSize = 16
    TextLabel3.TextWrapped = true
    TextLabel3.RichText = true
    TextLabel3.ZIndex = 6

    return TextLabel3
end
function t2.value64(p22, p23)
    local TextButton = Instance.new("TextButton", p22)

    TextButton.Size = UDim2.new(1, 0, 0, 0)
    TextButton.AutomaticSize = Enum.AutomaticSize.Y
    TextButton.BackgroundTransparency = 1
    TextButton.Text = t2.value45(p23)
    TextButton.TextColor3 = Color3.fromRGB(0, 255, 255)
    TextButton.TextXAlignment = Enum.TextXAlignment.Left
    TextButton.Font = Enum.Font.SourceSans
    TextButton.TextSize = 16
    TextButton.TextWrapped = true
    TextButton.ZIndex = 6
    TextButton.MouseButton1Click:Connect(function()
        if setclipboard then
            setclipboard(p23)
        end

        TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        task.delay(0.2, function()
            local Parent = TextButton

            if Parent then
                Parent = TextButton.Parent
            end

            if not Parent then
                return
            end

            TextButton.TextColor3 = Color3.fromRGB(0, 255, 255)
        end)
    end)

    return TextButton
end
function t2.value65(p24, p25, p26)
    local TextButton = Instance.new("TextButton", p24)

    TextButton.Size = UDim2.new(1, 0, 0, 0)
    TextButton.AutomaticSize = Enum.AutomaticSize.Y
    TextButton.BackgroundTransparency = 1
    TextButton.Text = t2.value45(p25)
    TextButton.TextColor3 = Color3.fromRGB(0, 255, 0)
    TextButton.TextXAlignment = Enum.TextXAlignment.Left
    TextButton.Font = Enum.Font.SourceSansBold
    TextButton.TextSize = 16
    TextButton.TextWrapped = true
    TextButton.ZIndex = 6
    TextButton.MouseButton1Click:Connect(function()
        if setclipboard then
            setclipboard(p26)
        end

        TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        task.delay(0.2, function()
            local Parent = TextButton

            if Parent then
                Parent = TextButton.Parent
            end

            if not Parent then
                return
            end

            TextButton.TextColor3 = Color3.fromRGB(0, 255, 0)
        end)
    end)

    return TextButton
end
function t2.value66(p27, p28, p29)
    local TextButton = Instance.new("TextButton", p27)

    TextButton.Size = UDim2.new(0, 10, 0, 18)
    TextButton.AutomaticSize = Enum.AutomaticSize.X
    TextButton.BackgroundTransparency = 1
    TextButton.Text = p28 .. ":"
    TextButton.TextColor3 = p29
    TextButton.Font = Enum.Font.SourceSansBold
    TextButton.TextSize = 16
    TextButton.TextXAlignment = Enum.TextXAlignment.Left
    TextButton.LayoutOrder = 1
    TextButton.ZIndex = 6
    TextButton.MouseButton1Click:Connect(function()
        local v62 = p28 ~= "SYSTEM"

        if v62 then
            v62 = p28 ~= t2.value7.Name
        end

        if not v62 then
            return
        end

        v62 = p28
        t2.value59(v62)
        v62 = t2.value57

        local v63 = t2.value7.Name < p28

        if v63 then
            v63 = t2.value7.Name .. "_" .. p28
        end

        v62(v63 or p28 .. "_" .. t2.value7.Name)
    end)

    return TextButton
end
function t2.value61(p30, p31, p32, p33, p34)
    if not (p30 and p31) then
        return
    end

    local BlockedUsers = t2.value21.BlockedUsers

    if BlockedUsers then
        BlockedUsers = t2.value21.BlockedUsers[p30]
    end

    if BlockedUsers then
        return
    end

    BlockedUsers = t2.value55()

    local Frame2 = Instance.new("Frame", t2.value31)

    Frame2.BackgroundTransparency = 1
    Frame2.Size = UDim2.new(1, -10, 0, 0)
    Frame2.AutomaticSize = Enum.AutomaticSize.Y
    Frame2.LayoutOrder = tick() * 1000
    Frame2.ZIndex = 5
    Instance.new("UIListLayout", Frame2).SortOrder = Enum.SortOrder.LayoutOrder
    Frame2.UIListLayout.Padding = UDim.new(0, 2)

    local color3 = Color3.fromRGB(100, 255, 100)

    if t2.value1[p30] or p34 == "admin" then
        color3 = Color3.fromRGB(255, 50, 50)
    elseif p30 == "SYSTEM" then
        color3 = Color3.fromRGB(255, 200, 50)
    elseif t2.value16[p30] or p34 == "mod" then
        color3 = Color3.fromRGB(50, 100, 255)
    end

    t2.value66(Frame2, p30, color3)
    color3 = 1

    local t4 = {}
    local v68, v113_, v70

    while color3 <= #p31 do
        v113, v68 = string.find(p31, "%-==.-==%-", color3)
        v113_, v70 = string.find(p31, "%^=.-%^.-=%^", color3)
        local v71
        local v72
        local v73
        if v113 and v113_ then
            if v113 < v113_ then
                v70 = v68
                v113_ = v113
                v72 = "blue"
            else
                v72 = "green"
            end
        elseif v113 then
            v70 = v68
            v113_ = v113
            v72 = "blue"
        elseif v113_ then
            v72 = "green"
        else
            v70 = v71
            v113_ = v73
        end
        if not v113_ then
            color3 = string.sub(p31, color3)

            if color3 ~= "" then
                table.insert(t4, {
					["type"] = "text",
					["content"] = color3
				})
            end

            break
        end
        if color3 < v113_ then
            v113 = table.insert
            v68 = v113_ - 1
            v113(t4, {
				["type"] = "text",
				["content"] = string.sub(p31, color3, v68)
			})
        end
        color3 = string.sub(p31, v113_, v70)
        if v72 == "blue" then
            table.insert(t4, {
				["type"] = "blue",
				["content"] = string.sub(color3, 4, -4)
			})
        elseif v72 == "green" then
            v113 = string.sub(color3, 3, -3)
            v68 = string.find(v113, "%^")

            if v68 then
                color3 = table.insert
                v113_ = v68 - 1
                v113_ = string.sub(v113, 1, v113_)
                v68 = v68 + 1
                color3(t4, {
					["type"] = "green",
					["display"] = v113_,
					["copy"] = string.sub(v113, v68)
				})
            else
                table.insert(t4, {
					["type"] = "text",
					["content"] = color3
				})
            end
        end
        color3 = v70 + 1
    end

    for i, v in ipairs(t4) do
        v113_ = nil

        if v.type == "text" then
            v113_ = t2.value63
            v = v.content
            v70 = p30 == "SYSTEM"

            if v70 then
                v70 = Color3.fromRGB(200, 200, 200)
            end

            v113_ = v113_(Frame2, v, v70 or (p33 or Color3.fromRGB(255, 255, 255)))
        elseif v.type == "blue" then
            v113_ = t2.value64(Frame2, v.content)
        elseif v.type == "green" then
            v113_ = t2.value65(Frame2, v.display, v.copy)
        end

        if v113_ then
            v113_.LayoutOrder = i + 1
        end
    end

    Frame2 = Instance.new("TextLabel", Frame2)
    Frame2.Size = UDim2.new(1, 0, 0, 14)
    Frame2.BackgroundTransparency = 1
    Frame2.TextColor3 = Color3.fromRGB(120, 120, 120)
    Frame2.TextXAlignment = Enum.TextXAlignment.Left
    Frame2.Text = p32 or "Unknown"
    Frame2.Font = Enum.Font.SourceSansItalic
    Frame2.TextSize = 12
    Frame2.LayoutOrder = 9999
    Frame2.ZIndex = 6
    Frame2, color3, t4 = ipairs(t2.value31:GetChildren())

    local t5 = {}

    while true do
        t4, v68 = Frame2(color3, t4)

        if not t4 then
            break
        end

        if v68:IsA("Frame") then
            table.insert(t5, v68)
        end
    end

    if #t5 > t2.value10 then
        table.sort(t5, function(p35, p36)
            return p35.LayoutOrder < p36.LayoutOrder
        end)

        for i = 1, #t5 - t2.value10 do
            t5[i]:Destroy()
        end
    end

    if not BlockedUsers then
        return
    end

    t2.value56()
end
function t2.value58()
    local pairs_ = pairs
    local value39 = t2.value39
    local v80

    pairs_, value39, v80 = pairs_(value39:GetChildren())

    local v81

    while true do
        v80, v81 = pairs_(value39, v80)

        if not v80 then
            break
        end

        if v81:IsA("Frame") then
            v81:Destroy()
        end
    end

    for k, v in pairs(t2.value15) do
        local Frame2 = Instance.new("Frame", t2.value39)

        Frame2.Size = UDim2.new(1, 0, 0, 50)
        Frame2.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        Frame2.LayoutOrder = k
        Frame2.ZIndex = 6
        Instance.new("UICorner", Frame2).CornerRadius = UDim.new(0, 8)
        k = Instance.new("TextLabel", Frame2)
        k.Size = UDim2.new(0.45, 0, 1, 0)
        k.Position = UDim2.new(0.03, 0, 0, 0)
        k.BackgroundTransparency = 1
        k.TextColor3 = Color3.fromRGB(255, 255, 255)
        k.Font = Enum.Font.SourceSansBold
        k.TextSize = 16
        k.TextXAlignment = Enum.TextXAlignment.Left
        k.ZIndex = 7

        local v85 = t2.value17[v] or 0

        if v85 > 0 then
            k.Text = v .. " (" .. v85 .. ")"
            k.TextColor3 = Color3.fromRGB(255, 255, 100)
        else
            k.Text = v
        end

        k = Instance.new("TextButton", Frame2)
        k.Size = UDim2.new(0.22, 0, 0.6, 0)
        k.Position = UDim2.new(0.5, 0, 0.2, 0)
        k.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
        k.Text = "Chat"
        k.TextColor3 = Color3.fromRGB(255, 255, 255)
        k.Font = Enum.Font.SourceSansBold
        k.TextSize = 14
        k.ZIndex = 7
        Instance.new("UICorner", k).CornerRadius = UDim.new(0, 6)
        k.MouseButton1Click:Connect(function()
            local value57 = t2.value57
            local v87 = t2.value7.Name < v
            if not v87 then
                value57(v87 or v .. "_" .. t2.value7.Name)

                return
            end
            value57(t2.value7.Name .. "_" .. v or v .. "_" .. t2.value7.Name)
        end)
        k = Instance.new("TextButton", Frame2)
        k.Size = UDim2.new(0.22, 0, 0.6, 0)
        k.Position = UDim2.new(0.74, 0, 0.2, 0)
        k.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
        k.Text = "Delete"
        k.TextColor3 = Color3.fromRGB(255, 255, 255)
        k.Font = Enum.Font.SourceSansBold
        k.TextSize = 14
        k.ZIndex = 7
        Instance.new("UICorner", k).CornerRadius = UDim.new(0, 6)
        v = function()
            t2.value62(v)
            t2.value58()
        end
        k.MouseButton1Click:Connect(v)
    end
end
task.spawn(function()
    while true do
        if not t2.value49 then
            t2.value25.Text = "Global Chat (CONNECTING...)"

            local WebSocket_ = WebSocket

            if not WebSocket_ then
                WebSocket_ = syn

                if WebSocket_ then
                    WebSocket_ = syn.websocket
                end

                if not WebSocket_ then
                    WebSocket_ = fluxus

                    if WebSocket_ then
                        WebSocket_ = fluxus.websocket
                    end
                end
            end

            if WebSocket_ then
                WebSocket_ = function()
                    return WebSocket_.connect(t2.value2)
                end

                local value49

                WebSocket_, value49 = pcall(WebSocket_)

                if WebSocket_ and value49 then
                    t2.value49 = value49
                    t2.value25.Text = "Global Chat Hub"
                    WebSocket_ = function()
                        t2.value49:Send(t2.value3:JSONEncode({
							["type"] = "join",
							["username"] = t2.value7.Name,
							["room"] = t2.value8
						}))
                    end
                    pcall(WebSocket_)
                    t2.value49.OnMessage:Connect(function(p37)
                        local v90
                        local function v91()
                            return t2.value3:JSONDecode(v90)
                        end
                        v90 = p37
                        local result
                        v91, result = pcall(v91)
                        if not (v91 and result) then
                            return
                        end
                        v91 = result.user
                        if v91 then
                            v91 = result.text

                            if v91 then
                                v91 = result.text
                                v91 = type(v91) == "string"

                                if v91 then
                                    v91 = result.text
                                    v91 = string.sub(v91, 1, 13) ~= "INTERNAL_CMD_"
                                end
                            end
                        end
                        if not v91 then
                            return
                        end
                        v91 = result.room
                        if v91 then
                            v91 = result.room ~= "global"

                            if v91 then
                                v91 = result.room
                                v91 = string.sub(v91, 1, 2) ~= "L_"

                                if v91 then
                                    v91 = result.user ~= t2.value7.Name
                                end
                            end
                        end
                        if v91 then
                            t2.value59(result.user)
                        end
                        t2.value61(result.user, result.text, result.gameName, nil, result.role)
                    end)
                    t2.value49.OnClose:Connect(function()
                        t2.value49 = nil
                        t2.value25.Text = "Global Chat (RECONNECTING...)"
                    end)
                else
                    t2.value25.Text = "Global Chat (FAILED. RETRYING...)"
                end
            else
                t2.value25.Text = "Global Chat (UNSUPPORTED EXECUTOR)"
            end
        end

        task.wait(5)
    end
end)

function t2.value67(p38)
    return t2.value1[p38] or t2.value16[p38] == true
end
function t2.value68()
    t2.value52()

    local value18 = t2.value18

    if value18 then
        value18 = t2.value8 == "global"
    end

    if value18 then
        t2.value61("SYSTEM", "You are banned.", "Alert")

        return
    end

    value18 = t2.value19

    if value18 then
        value18 = t2.value8 == "global"
    end

    if value18 then
        t2.value61("SYSTEM", "You are muted.", "Alert")

        return
    end

    value18 = t2.value32.Text

    if value18 == "" then
        return
    end

    if string.sub(value18, 1, 1) == "/" then
        value18 = string.split(value18, " ")

        local setclipboard_ = string.lower(value18[1])

        t2.value32.Text = ""

        if setclipboard_ == "/help" then
            t2.value61("SYSTEM", "=== Commands ===\n/clear - Clear Chat\n/copy - Copy user (DMs)", "Help")

            return
        end

        if setclipboard_ == "/clear" then
            t2.value53()
            t2.value61("SYSTEM", "Chat cleared.", "Info")

            return
        end

        if setclipboard_ == "/copy" then
            value18 = t2.value48(t2.value8)

            if value18 then
                setclipboard_ = setclipboard
            else
                setclipboard_ = value18
            end

            if setclipboard_ then
                setclipboard(value18)
                t2.value61("SYSTEM", "Copied!", "Info")

                return
            else
                return
            end

            return
        end

        local value49 = t2.value67(t2.value7.Name)

        if value49 then
            value49 = t2.value49
        end

        if not value49 then
            return
        end

        if setclipboard_ == "/ban" then
            value49 = value18[2]
        else
            value49 = false
        end

        if value49 then
            value49 = function()
                local value492 = t2.value49
                local value3 = t2.value3
                local t6 = {
					["type"] = "admin_command",
					["command"] = "ban",
					["target"] = value18[2],
					["sender"] = t2.value7.Name
				}

                value492:Send(value3:JSONEncode(t6))
            end
            pcall(value49)
        else
            if setclipboard_ == "/unban" then
                value49 = value18[2]
            else
                value49 = false
            end

            if value49 then
                pcall(function()
                    local value492 = t2.value49
                    local value3 = t2.value3

                    value492:Send(value3:JSONEncode({
						["type"] = "admin_command",
						["command"] = "unban",
						["target"] = value18[2],
						["sender"] = t2.value7.Name
					}))
                end)
            else
                if setclipboard_ == "/mute" then
                    value49 = value18[2]
                else
                    value49 = false
                end

                if value49 then
                    pcall(function()
                        t2.value49:Send(t2.value3:JSONEncode({
							["type"] = "admin_command",
							["command"] = "mute",
							["target"] = value18[2],
							["sender"] = t2.value7.Name
						}))
                    end)
                else
                    if setclipboard_ == "/unmute" then
                        value49 = value18[2]
                    else
                        value49 = false
                    end

                    if value49 then
                        value49 = function()
                            t2.value49:Send(unpack_({ t2.value3:JSONEncode({
									["type"] = "admin_command",
									["command"] = "unmute",
									["target"] = value18[2],
									["sender"] = t2.value7.Name
								}) }))
                        end
                        pcall(value49)
                    end
                end
            end
        end

        if not t2.value1[t2.value7.Name] then
            return
        end

        if setclipboard_ == "/mod" then
            value49 = value18[2]
        else
            value49 = false
        end

        if value49 then
            value18 = function()
                local value492 = t2.value49
                local value3 = t2.value3

                value492:Send(value3:JSONEncode({
					["type"] = "admin_command",
					["command"] = "mod",
					["target"] = value18[2],
					["sender"] = t2.value7.Name
				}))
            end
            pcall(value18)

            return
        end

        if setclipboard_ == "/unmod" then
            setclipboard_ = value18[2]
        else
            setclipboard_ = false
        end

        if not setclipboard_ then
            return
        end

        value18 = function()
            local value492 = t2.value49
            local value3 = t2.value3

            value492:Send(value3:JSONEncode({
				["type"] = "admin_command",
				["command"] = "unmod",
				["target"] = value18[2],
				["sender"] = t2.value7.Name
			}))
        end
        pcall(value18)
    else
        if not t2.value49 then
            return
        end

        pcall(function()
            t2.value49:Send(unpack_({ t2.value3:JSONEncode({
					["type"] = "chat",
					["username"] = t2.value7.Name,
					["text"] = value18,
					["room"] = t2.value8,
					["gameName"] = t2.value21.ShowGame and t2.value22 or "Hidden Game"
				}) }))
        end)
        t2.value32.Text = ""
        t2.value56()
    end
end
t2.value26.MouseButton1Click:Connect(function()
    if not t2.value9 then
        return
    end

    t2.value61("SYSTEM", "Left lobby", "Info")
    t2.value9 = nil
    t2.value50()
    t2.value57("global")
end);
(function(p39, p40)
    local Frame2 = Instance.new("Frame", t2.value36)

    Frame2.Size = UDim2.new(0.9, 0, 0, 45)
    Frame2.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Frame2.ZIndex = 6
    Instance.new("UICorner", Frame2).CornerRadius = UDim.new(0, 8)

    local TextLabel3 = Instance.new("TextLabel", Frame2)

    TextLabel3.Size = UDim2.new(0.7, 0, 1, 0)
    TextLabel3.Position = UDim2.new(0.05, 0, 0, 0)
    TextLabel3.BackgroundTransparency = 1
    TextLabel3.Text = p39
    TextLabel3.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextLabel3.Font = Enum.Font.SourceSans
    TextLabel3.TextSize = 16
    TextLabel3.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel3.ZIndex = 7
    Frame2 = Instance.new("TextButton", Frame2)
    Frame2.Size = UDim2.new(0, 35, 0, 35)
    Frame2.Position = UDim2.new(0.88, -17, 0.5, -17)
    TextLabel3 = t2.value21[p40]

    if TextLabel3 then
        TextLabel3 = Color3.fromRGB(0, 180, 0)
    end

    Frame2.BackgroundColor3 = TextLabel3 or Color3.fromRGB(180, 0, 0)
    Frame2.Text = t2.value21[p40] and "ON" or "OFF"
    Frame2.TextColor3 = Color3.fromRGB(255, 255, 255)
    Frame2.TextSize = 12
    Frame2.Font = Enum.Font.SourceSansBold
    Frame2.ZIndex = 7
    Instance.new("UICorner", Frame2).CornerRadius = UDim.new(0, 6)
    Frame2.MouseButton1Click:Connect(function()
        local value14 = t2.value21[p40]

        t2.value21[p40] = not value14
        value14 = Frame2

        local color3 = t2.value21[p40]

        if color3 then
            color3 = Color3.fromRGB(0, 180, 0)
        end

        value14.BackgroundColor3 = color3 or Color3.fromRGB(180, 0, 0)
        Frame2.Text = t2.value21[p40] and "ON" or "OFF"
        value14 = t2.value14
        color3 = t2.value21

        if not writefile then
            return
        end

        value14 = function()
            writefile(value14, t2.value3:JSONEncode(color3))
        end
        pcall(value14)
    end)
end)("Show Game Name", "ShowGame")
isfile_.MouseButton1Click:Connect(function()
    t2.value57("global")
end)
t2.value29.MouseButton1Click:Connect(function()
    t2.value60("ConnectionsPage", "Connections", true)
end)
v8.MouseButton1Click:Connect(function()
    t2.value60("LobbyPage", "Lobbies", true)
end)
TextLabel.MouseButton1Click:Connect(function()
    math.randomseed(tick())

    local s3 = ""

    for _ = 1, 5 do
        local v111 = math.random(1, 36)

        s3 = s3 .. string.sub("ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789", v111, v111)
    end

    t2.value57("L_" .. s3)
end)
UIListLayout.MouseButton1Click:Connect(function()
    local v112 = string.upper(string.gsub(t2.value41.Text, "%s+", ""))

    if not (#v112 >= 1) then
        return
    end

    t2.value57("L_" .. v112)
    t2.value41.Text = ""
end)
CoreGui.MouseButton1Click:Connect(function()
    if not t2.value9 then
        return
    end

    t2.value57(t2.value9)
end)
Players.MouseButton1Click:Connect(function()
    t2.value60("SettingsPage", "Settings", true)
end)
Frame.MouseButton1Click:Connect(function()
    local v114 = string.gsub(t2.value38.Text, "%s+", "")
    local v115 = v114 ~= ""

    if v115 then
        v115 = v114 ~= t2.value7.Name
    end

    if not v115 then
        return
    end

    t2.value59(v114)
    t2.value38.Text = ""
    v115 = t2.value57

    local v116 = t2.value7.Name < v114

    if v116 then
        v116 = t2.value7.Name .. "_" .. v114
    end

    v115(v116 or v114 .. "_" .. t2.value7.Name)
end)
t2.value27.MouseButton1Click:Connect(function()
    if not (#t2.value11 > 0) then
        t2.value60("MenuPage", "Global Chat Hub", false)

        return
    end
end)
t2.value33.MouseButton1Click:Connect(t2.value68)
t2.value32.FocusLost:Connect(function(enterPressed)
    if not enterPressed then
        return
    end

    t2.value68()
end)
t2.value23.MouseButton1Click:Connect(function()
    t2.value24.Visible = not t2.value24.Visible
    t2.value23.Text = t2.value24.Visible and "CLOSE" or "MENU"
end)
t1.MouseButton1Click:Connect(function()
    t2.value24.Visible = false
    t2.value23.Text = "MENU"
end)
task.spawn(function()
    while true do
        task.wait(30)

        local value19 = t2.value19

        if value19 then
            value19 = t2.value20 > 0

            if value19 then
                value19 = os.time() >= t2.value20
            end
        end

        if value19 then
            t2.value19 = false
            t2.value20 = 0
            value19 = t2.value13

            local t7 = {
				["muted"] = false,
				["endTime"] = 0
			}

            if writefile then
                value19 = function()
                    writefile(value19, t2.value3:JSONEncode(t7))
                end
                pcall(value19)
            end

            TextLabel2()

            if t2.value30.Visible then
                t2.value61("SYSTEM", "Your mute has expired.", "Info")
            end
        end
    end
end)
t2.value54()
t2.value50()
t2.value51()
TextLabel2()
