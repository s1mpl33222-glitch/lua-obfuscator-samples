-- This file was generated at discord.gg/syncrypt

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local function v4(p1, p2, p3)
    local v58 = Instance.new(p1)

    for k, v in pairs(p2) do
        v58[k] = v
    end

    v58.Parent = p3

    return v58
end
local t1 = { "SAIGFJHADOSIGSXVVBGSNMDIO" }
local t2 = {
	Name = "KeySystem",
	ResetOnSpawn = false,
	IgnoreGuiInset = true
}
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local ScreenGui = Instance.new("ScreenGui")
for k, v in pairs(t2) do
    ScreenGui[k] = v
end
ScreenGui.Parent = PlayerGui
local v11 = ScreenGui
local uDim2 = UDim2.fromScale(1, 1)
local color3 = Color3.fromRGB(5, 5, 8)
v4("Frame", {
	Size = uDim2,
	BackgroundColor3 = color3,
	BorderSizePixel = 0,
	ZIndex = 1
}, v11)
local uDim2_2 = UDim2.fromOffset(350, 245)
local uDim2_3 = UDim2.fromScale(0.5, 0.5)
local vector2 = Vector2.new(0.5, 0.5)
local color3_2 = Color3.fromRGB(13, 13, 18)
local v18 = v4("Frame", {
	Name = "Main",
	Size = uDim2_2,
	Position = uDim2_3,
	AnchorPoint = vector2,
	BackgroundColor3 = color3_2,
	BorderSizePixel = 0,
	ZIndex = 2,
	ClipsDescendants = true
}, v11)
v4("UICorner", {
	CornerRadius = UDim.new(0, 12)
}, v18)
v4("UIStroke", {
	Color = Color3.fromRGB(130, 80, 255),
	Transparency = 0.55,
	Thickness = 1
}, v18)
local uDim2_4 = UDim2.new(1, 0, 0, 3)
local uDim2_5 = UDim2.fromOffset(0, 0)
local color3_3 = Color3.fromRGB(145, 85, 255)
v4("Frame", {
	Size = uDim2_4,
	Position = uDim2_5,
	BackgroundColor3 = color3_3,
	BorderSizePixel = 0,
	ZIndex = 3
}, v18)
local uDim2_6 = UDim2.new(1, -32, 0, 32)
local uDim2_7 = UDim2.fromOffset(16, 18)
local GothamBold = Enum.Font.GothamBold
local color3_4 = Color3.fromRGB(245, 240, 255)
local Left = Enum.TextXAlignment.Left
v4("TextLabel", {
	BackgroundTransparency = 1,
	Size = uDim2_6,
	Position = uDim2_7,
	Font = GothamBold,
	Text = "KEY SYSTEM",
	TextColor3 = color3_4,
	TextSize = 21,
	TextXAlignment = Left,
	ZIndex = 3
}, v18)
local uDim2_8 = UDim2.fromOffset(7, 7)
local uDim2_9 = UDim2.fromOffset(327, 29)
local color3_5 = Color3.fromRGB(150, 90, 255)
local v30 = v4("Frame", {
	Size = uDim2_8,
	Position = uDim2_9,
	BackgroundColor3 = color3_5,
	BorderSizePixel = 0,
	ZIndex = 4
}, v18)
v4("UICorner", {
	CornerRadius = UDim.new(1, 0)
}, v30)
local uDim2_10 = UDim2.new(1, -32, 0, 20)
local uDim2_11 = UDim2.fromOffset(16, 48)
local Gotham = Enum.Font.Gotham
local color3_6 = Color3.fromRGB(125, 125, 140)
local Left2 = Enum.TextXAlignment.Left
v4("TextLabel", {
	BackgroundTransparency = 1,
	Size = uDim2_10,
	Position = uDim2_11,
	Font = Gotham,
	Text = "Enter your key below to continue",
	TextColor3 = color3_6,
	TextSize = 12,
	TextXAlignment = Left2,
	ZIndex = 3
}, v18)
local uDim2_12 = UDim2.new(1, -32, 0, 43)
local uDim2_13 = UDim2.fromOffset(16, 82)
local color3_7 = Color3.fromRGB(20, 20, 27)
local v39 = v4("Frame", {
	Size = uDim2_12,
	Position = uDim2_13,
	BackgroundColor3 = color3_7,
	BorderSizePixel = 0,
	ZIndex = 3
}, v18)
v4("UICorner", {
	CornerRadius = UDim.new(0, 7)
}, v39)
v4("UIStroke", {
	Color = Color3.fromRGB(70, 65, 90),
	Transparency = 0.25,
	Thickness = 1
}, v39)
local uDim2_14 = UDim2.new(1, -20, 1, 0)
local uDim2_15 = UDim2.fromOffset(10, 0)
local Gotham2 = Enum.Font.Gotham
local color3_8 = Color3.fromRGB(85, 85, 100)
local color3_9 = Color3.fromRGB(235, 230, 245)
local v45 = v4("TextBox", {
	BackgroundTransparency = 1,
	Size = uDim2_14,
	Position = uDim2_15,
	Font = Gotham2,
	PlaceholderText = "Paste key here...",
	PlaceholderColor3 = color3_8,
	Text = "",
	TextColor3 = color3_9,
	TextSize = 13,
	ClearTextOnFocus = false,
	ZIndex = 4
}, v39)
local function v46(p4, p5, p6, p7)
    local v68 = v4
    local uDim2_16 = UDim2.new(0, p6, 0, 40)
    local uDim2_17 = UDim2.fromOffset(p5, 140)
    local v71 = p7

    if p7 then
        v71 = Color3.fromRGB(140, 80, 255)
    end

    if not v71 then
        v71 = Color3.fromRGB(22, 22, 29)
    end

    local GothamBold2 = Enum.Font.GothamBold
    local v73 = p7

    if p7 then
        v73 = Color3.fromRGB(255, 255, 255)
    end

    if not v73 then
        v73 = Color3.fromRGB(205, 200, 215)
    end

    local v74 = v68("TextButton", {
		Size = uDim2_16,
		Position = uDim2_17,
		BackgroundColor3 = v71,
		BackgroundTransparency = 0,
		AutoButtonColor = false,
		Font = GothamBold2,
		Text = p4,
		TextColor3 = v73,
		TextSize = 13,
		ZIndex = 3
	}, v18)

    v4("UICorner", {
		CornerRadius = UDim.new(0, 7)
	}, v74)

    local v75 = v4
    local v76 = p7

    if p7 then
        v76 = Color3.fromRGB(180, 140, 255)
    end

    if not v76 then
        v76 = Color3.fromRGB(65, 60, 80)
    end

    v75("UIStroke", {
		Color = v76,
		Transparency = 0.35,
		Thickness = 1
	}, v74)
    v74.MouseEnter:Connect(function()
        local v93 = TweenService
        local v94 = v74
        local tweenInfo = TweenInfo.new(0.15)
        local v96 = p7

        if v96 then
            v96 = Color3.fromRGB(160, 105, 255)
        end

        if not v96 then
            v96 = Color3.fromRGB(31, 29, 40)
        end

        v93:Create(v94, tweenInfo, {
			BackgroundColor3 = v96
		}):Play()
    end)
    v74.MouseLeave:Connect(function()
        local v97 = TweenService
        local v98 = v74
        local tweenInfo = TweenInfo.new(0.15)
        local v100 = p7

        if v100 then
            v100 = Color3.fromRGB(140, 80, 255)
        end

        if not v100 then
            v100 = Color3.fromRGB(22, 22, 29)
        end

        v97:Create(v98, tweenInfo, {
			BackgroundColor3 = v100
		}):Play()
    end)

    return v74
end
local v47 = v46("COPY LINK", 16, 145, false)
local v48 = v46("UNLOCK", 169, 165, true)
local uDim2_18 = UDim2.new(1, -32, 0, 22)
local uDim2_19 = UDim2.fromOffset(16, 193)
local Gotham3 = Enum.Font.Gotham
local color3_10 = Color3.fromRGB(255, 130, 130)
local Left3 = Enum.TextXAlignment.Left
local v54 = v4("TextLabel", {
	BackgroundTransparency = 1,
	Size = uDim2_18,
	Position = uDim2_19,
	Font = Gotham3,
	Text = "",
	TextColor3 = color3_10,
	TextSize = 12,
	TextXAlignment = Left3,
	ZIndex = 3
}, v18)
v47.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard("https://direct-link.net/6243065/YOy6U25jWLOb")

        local v80 = v54
        local color3_11 = Color3.fromRGB(145, 240, 180)

        if not color3_11 then
            color3_11 = Color3.fromRGB(255, 120, 120)
        end

        v80.TextColor3 = color3_11
        v54.Text = "Key link copied!"

        return
    end

    local v82 = v54
    local v83 = false

    if not v83 then
        v83 = Color3.fromRGB(255, 120, 120)
    end

    v82.TextColor3 = v83
    v54.Text = "Clipboard not supported."
end)
v48.MouseButton1Click:Connect(function()
    local Text = v45.Text
    local g88
    local v87
    for _, v in ipairs(t1) do
        if v == Text then
            v87 = true
            g88 = true
        end

        if g88 then
            break
        end
    end
    if not g88 then
        v87 = false
    end
    if v87 then
        local v89 = v54
        local color3_12 = Color3.fromRGB(145, 240, 180)

        if not color3_12 then
            color3_12 = Color3.fromRGB(255, 120, 120)
        end

        v89.TextColor3 = color3_12
        v54.Text = "Key accepted! Loading script..."
        task.wait(0.6)
        v11:Destroy()

        return
    end
    local v91 = v54
    local v92 = false
    if not v92 then
        v92 = Color3.fromRGB(255, 120, 120)
    end
    v91.TextColor3 = v92
    v54.Text = "Invalid key. Try again."
end)
