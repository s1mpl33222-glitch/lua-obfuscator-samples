-- This file was generated at discord.gg/syncrypt

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

if not LocalPlayer then
	return
end

local v4 = LocalPlayer.WaitForChild(LocalPlayer, "PlayerGui")
local t1 = {
	MINIMAL = { "MINIMAL-ACCESS-01", "SAFGIOUPHHSDGUISHGUIS" },
	SPLIT = { "SPLIT-ACCESS-02" },
	FLOATING = { "FLOATING-ACCESS-03" }
}
local s1 = "KeyAccessDim"
local s2 = "KeyAccessPanel"

for _, v in ipairs({ "KeyAccessPanel", "KeyAccessDim" }) do
	local v10 = v4:FindFirstChild(v)

	if v10 then
		v10:Destroy()
	end
end

local v11 = Random.new()
local t2 = {
	{
		Background = Color3.fromRGB(12, 13, 18),
		Panel = Color3.fromRGB(20, 21, 29),
		Surface = Color3.fromRGB(29, 30, 40),
		Accent = Color3.fromRGB(160, 130, 255),
		Text = Color3.fromRGB(244, 244, 250),
		Muted = Color3.fromRGB(145, 146, 163),
		Green = Color3.fromRGB(100, 220, 155),
		Red = Color3.fromRGB(255, 105, 115)
	},
	{
		Background = Color3.fromRGB(10, 14, 17),
		Panel = Color3.fromRGB(17, 24, 28),
		Surface = Color3.fromRGB(26, 36, 41),
		Accent = Color3.fromRGB(85, 220, 190),
		Text = Color3.fromRGB(240, 249, 246),
		Muted = Color3.fromRGB(135, 159, 155),
		Green = Color3.fromRGB(100, 230, 165),
		Red = Color3.fromRGB(255, 110, 110)
	},
	{
		Background = Color3.fromRGB(17, 12, 12),
		Panel = Color3.fromRGB(27, 19, 20),
		Surface = Color3.fromRGB(39, 27, 29),
		Accent = Color3.fromRGB(255, 115, 125),
		Text = Color3.fromRGB(250, 242, 243),
		Muted = Color3.fromRGB(166, 140, 143),
		Green = Color3.fromRGB(120, 225, 150),
		Red = Color3.fromRGB(255, 100, 110)
	},
	{
		Background = Color3.fromRGB(13, 14, 16),
		Panel = Color3.fromRGB(22, 23, 26),
		Surface = Color3.fromRGB(33, 34, 38),
		Accent = Color3.fromRGB(230, 230, 235),
		Text = Color3.fromRGB(250, 250, 252),
		Muted = Color3.fromRGB(150, 151, 158),
		Green = Color3.fromRGB(115, 220, 150),
		Red = Color3.fromRGB(255, 110, 110)
	}
}
local v13 = t2[v11.NextInteger(v11, 1, #t2)]
local t3 = { "MINIMAL", "SPLIT", "FLOATING" }
local v15 = t3[v11:NextInteger(1, #t3)]
local t4 = {
	"ACCESS TERMINAL",
	"VERIFICATION CENTER",
	"KEY AUTHENTICATION",
	"SECURE ENTRY",
	"ACCESS PORTAL"
}
local t5 = {
	"Enter your access key to continue.",
	"Complete verification to proceed.",
	"Provide a valid key to unlock access.",
	"Your session requires verification.",
	"Authenticate below to continue."
}
local v18 = t4[v11.NextInteger(v11, 1, #t4)]

local function v19(p1)
	local v20 = t1[v15]

	if v20 then
		for _, v in ipairs(v20) do
			if p1 == v then
				return true
			end
		end

		return false
	else
		return false
	end
end
local function v23(p2, p3, p4)
	local v24 = TweenService
	local tweenInfoNew = TweenInfo.new
	local Quint = Enum.EasingStyle.Quint
	local EasingDirection = Enum.EasingDirection
	local v28 = v24.Create(v24, p2, tweenInfoNew(p3, Quint, EasingDirection.Out), p4)

	v28:Play()

	return v28
end
local function v29(p5, p6, p7)
	local instance = Instance.new(p5)

	for k, v in pairs(p6 or {}) do
		instance[k] = v
	end

	instance.Parent = p7

	return instance
end

local v33 = t5[v11.NextInteger(v11, 1, #t5)]

local function v34(p8, p9)
	v29("UICorner", {
		CornerRadius = UDim.new(0, p9 or 10)
	}, p8)
end
local function v35(p10, p11, p12)
	return v29("UIStroke", {
		Color = p11,
		Thickness = 1,
		Transparency = p12 or 0
	}, p10)
end

local ScreenGui = v29("ScreenGui", {
	Name = s1,
	IgnoreGuiInset = true,
	ResetOnSpawn = false,
	DisplayOrder = 998,
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling
}, v4)
local Frame = v29("Frame", {
	Name = "Backdrop",
	Size = UDim2.fromScale(1, 1),
	BackgroundColor3 = Color3.new(0, 0, 0),
	BackgroundTransparency = 1,
	BorderSizePixel = 0
}, ScreenGui)
local ScreenGui2 = v29("ScreenGui", {
	Name = s2,
	IgnoreGuiInset = true,
	ResetOnSpawn = false,
	DisplayOrder = 999,
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling
}, v4)
local Frame2 = v29("Frame", {
	Name = "MainPanel",
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.fromScale(0.5, 0.53),
	Size = UDim2.fromOffset(410, 350),
	BackgroundColor3 = v13.Panel,
	BorderSizePixel = 0
}, ScreenGui2)

v34(Frame2, 15)
v35(Frame2, v13.Accent, 0.65)

local n1 = 0

if v15 == "MINIMAL" then
	Frame2.Size = UDim2.fromOffset(390, 350)
elseif v15 == "SPLIT" then
	Frame2.Size = UDim2.fromOffset(450, 370)
	v34(v29("Frame", {
		Name = "AccentSidebar",
		Size = UDim2.new(0, 7, 1, 0),
		BackgroundColor3 = v13.Accent,
		BorderSizePixel = 0
	}, Frame2), 5)
	n1 = 32
elseif v15 == "FLOATING" then
	Frame2.Size = UDim2.fromOffset(410, 360)
	v34(v29("Frame", {
		Name = "TopAccent",
		Position = UDim2.new(0, 20, 0, 0),
		Size = UDim2.new(1, -40, 0, 3),
		BackgroundColor3 = v13.Accent,
		BorderSizePixel = 0
	}, Frame2), 3)
end

local v41 = -40 - n1

v29("TextLabel", {
	Name = "Header",
	Position = UDim2.new(0, 20 + n1, 0, 20),
	Size = UDim2.new(1, v41, 0, 25),
	BackgroundTransparency = 1,
	Font = Enum.Font.GothamBold,
	Text = v18,
	TextColor3 = v13.Text,
	TextSize = 17,
	TextXAlignment = Enum.TextXAlignment.Left
}, Frame2)
v29("TextLabel", {
	Name = "Subtitle",
	Position = UDim2.new(0, 20 + n1, 0, 48),
	Size = UDim2.new(1, v41, 0, 30),
	BackgroundTransparency = 1,
	Font = Enum.Font.Gotham,
	Text = v33,
	TextColor3 = v13.Muted,
	TextSize = 11,
	TextWrapped = true,
	TextXAlignment = Enum.TextXAlignment.Left
}, Frame2)
v29("TextLabel", {
	Name = "LinkHeading",
	Position = UDim2.new(0, 20 + n1, 0, 88),
	Size = UDim2.new(1, v41, 0, 18),
	BackgroundTransparency = 1,
	Font = Enum.Font.GothamSemibold,
	Text = "KEY RETRIEVAL",
	TextColor3 = v13.Text,
	TextSize = 10,
	TextXAlignment = Enum.TextXAlignment.Left
}, Frame2)

local Frame3 = v29("Frame", {
	Name = "LinkContainer",
	Position = UDim2.new(0, 20 + n1, 0, 112),
	Size = UDim2.new(1, v41, 0, 39),
	BackgroundColor3 = v13.Surface,
	BorderSizePixel = 0,
	ClipsDescendants = true
}, Frame2)

v34(Frame3, 8)

local TextLabel = v29("TextLabel", {
	Name = "LinkText",
	Position = UDim2.new(0, 11, 0, 0),
	Size = UDim2.new(1, -22, 1, 0),
	BackgroundTransparency = 1,
	Font = Enum.Font.Code,
	Text = "https://link-target.net/6243065/gLx3e3cqFluV",
	TextColor3 = v13.Accent,
	TextSize = 10,
	TextTruncate = Enum.TextTruncate.AtEnd,
	TextXAlignment = Enum.TextXAlignment.Left
}, Frame3)
local TextBox = v29("TextBox", {
	Name = "ManualCopyField",
	Position = UDim2.new(0, 8, 0, 0),
	Size = UDim2.new(1, -16, 1, 0),
	BackgroundTransparency = 1,
	ClearTextOnFocus = false,
	MultiLine = false,
	TextEditable = true,
	Text = "https://link-target.net/6243065/gLx3e3cqFluV",
	TextColor3 = v13.Accent,
	Font = Enum.Font.Code,
	TextSize = 10,
	TextXAlignment = Enum.TextXAlignment.Left,
	TextYAlignment = Enum.TextYAlignment.Center,
	Visible = false
}, Frame3)
local TextButton = v29("TextButton", {
	Name = "CopyLinkButton",
	Position = UDim2.new(0, 20 + n1, 0, 160),
	Size = UDim2.new(1, v41, 0, 34),
	BackgroundColor3 = v13.Accent,
	BorderSizePixel = 0,
	AutoButtonColor = true,
	Font = Enum.Font.GothamBold,
	Text = "COPY ACCESS LINK",
	TextColor3 = v13.Background,
	TextSize = 10
}, Frame2)

v34(TextButton, 8)
v29("TextLabel", {
	Name = "KeyHeading",
	Position = UDim2.new(0, 20 + n1, 0, 205),
	Size = UDim2.new(1, v41, 0, 17),
	BackgroundTransparency = 1,
	Font = Enum.Font.GothamSemibold,
	Text = "ACCESS KEY",
	TextColor3 = v13.Text,
	TextSize = 10,
	TextXAlignment = Enum.TextXAlignment.Left
}, Frame2)

local TextBox2 = v29("TextBox", {
	Name = "KeyInput",
	Position = UDim2.new(0, 20 + n1, 0, 228),
	Size = UDim2.new(1, v41, 0, 35),
	BackgroundColor3 = v13.Surface,
	BorderSizePixel = 0,
	ClearTextOnFocus = false,
	PlaceholderText = "Enter your key here",
	PlaceholderColor3 = v13.Muted,
	Text = "",
	TextColor3 = v13.Text,
	Font = Enum.Font.Gotham,
	TextSize = 11,
	TextXAlignment = Enum.TextXAlignment.Left
}, Frame2)

v34(TextBox2, 8)
v29("UIPadding", {
	PaddingLeft = UDim.new(0, 11),
	PaddingRight = UDim.new(0, 11)
}, TextBox2)

local TextButton2 = v29("TextButton", {
	Name = "VerifyButton",
	Position = UDim2.new(0, 20 + n1, 0, 273),
	Size = UDim2.new(1, v41, 0, 34),
	BackgroundColor3 = v13.Surface,
	BorderSizePixel = 0,
	AutoButtonColor = true,
	Font = Enum.Font.GothamBold,
	Text = "VERIFY ACCESS",
	TextColor3 = v13.Text,
	TextSize = 10
}, Frame2)

v34(TextButton2, 8)
v35(TextButton2, v13.Accent, 0.55)

local Frame4 = v29("Frame", {
	Name = "StatusContainer",
	Position = UDim2.new(0, 20 + n1, 0, 314),
	Size = UDim2.new(1, v41, 0, 27),
	BackgroundColor3 = v13.Surface,
	BackgroundTransparency = 0.15,
	BorderSizePixel = 0
}, Frame2)

v34(Frame4, 7)

local TextLabel2 = v29("TextLabel", {
	Name = "StatusIndicator",
	Position = UDim2.new(0, 8, 0, 0),
	Size = UDim2.fromOffset(18, 27),
	BackgroundTransparency = 1,
	Font = Enum.Font.GothamBold,
	Text = "•",
	TextColor3 = v13.Muted,
	TextSize = 16,
	TextXAlignment = Enum.TextXAlignment.Center
}, Frame4)
local TextLabel3 = v29("TextLabel", {
	Name = "StatusMessage",
	Position = UDim2.new(0, 29, 0, 0),
	Size = UDim2.new(1, -37, 1, 0),
	BackgroundTransparency = 1,
	Font = Enum.Font.GothamMedium,
	Text = "Ready for verification.",
	TextColor3 = v13.Muted,
	TextSize = 11,
	TextWrapped = true,
	TextXAlignment = Enum.TextXAlignment.Left,
	TextYAlignment = Enum.TextYAlignment.Center
}, Frame4)
local v51 = nil

local function v52(p13, p14, p15)
	v51.Text = p13
	v51.TextColor3 = p14
	TextLabel2.TextColor3 = p14
	TextLabel2.Text = p15 or "•"
end

v51 = TextLabel3
Frame2.Position = UDim2.fromScale(0.5, 0.56)
Frame2.BackgroundTransparency = 1
v23(Frame, 0.25, {
	BackgroundTransparency = 0.35
})
v23(Frame2, 0.4, {
	Position = UDim2.fromScale(0.5, 0.5),
	BackgroundTransparency = 0
})

local u53 = nil
local v54 = nil

local function v55()
	if v54 or not ScreenGui2.Parent then
		return
	end

	u53 = true
	TextLabel.Visible = false
	TextBox.Visible = true
	TextBox.Text = "https://link-target.net/6243065/gLx3e3cqFluV"
	TextButton.Text = "SELECT LINK"
	v52("Select the link above and copy it.", v13.Muted, "i")
	TextBox:CaptureFocus()
	task.defer(function()
		local Parent = TextBox.Parent

		if Parent then
			Parent = TextBox.Visible
		end

		if not Parent then
			return
		end

		TextBox.SelectionStart = 1
		TextBox.CursorPosition = 45
	end)
end

u53 = false
v54 = false
TextButton.MouseButton1Click:Connect(function()
	if v54 then
		return
	end

	if u53 then
		TextBox:CaptureFocus()
		TextBox.SelectionStart = 1
		TextBox.CursorPosition = 45
		v52("Select the link, then copy it.", v13.Muted, "i")

		return
	end

	local ok

	if typeof(setclipboard) == "function" then
		ok = pcall(function()
			setclipboard("https://link-target.net/6243065/gLx3e3cqFluV")
		end)
	else
		ok = false
	end

	if not ok then
		v55()

		return
	end

	TextButton.Text = "LINK COPIED"
	v52("Your access link is copied.", v13.Green, "✓")
	task.delay(1.5, function()
		if v54 then
			return
		end

		if TextButton.Parent then
			TextButton.Text = "COPY ACCESS LINK"
		end

		if not v51.Parent then
			return
		end

		v52("Ready for verification.", v13.Muted, "•")
	end)
end)

local MouseButton1Click = TextButton2.MouseButton1Click

MouseButton1Click.Connect(MouseButton1Click, function()
	if v54 then
		return
	end

	local Text = TextBox2.Text

	if Text == "" then
		v52("Please enter your access key first.", v13.Red, "!")

		return
	end

	if v19(Text) then
		v52("Verification successful.", v13.Green, "✓")
		TextButton2.Text = "ACCESS GRANTED"
		task.wait(0.45)

		local tweenInfo = TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
		local v61 = ScreenGui2

		for _, descendant in ipairs(v61.GetDescendants(v61)) do
			if descendant:IsA("TextLabel") or (descendant:IsA("TextButton") or descendant:IsA("TextBox")) then
				local v64 = TweenService

				v64.Create(v64, descendant, tweenInfo, {
					TextTransparency = 1,
					BackgroundTransparency = 1
				}):Play()
			elseif descendant:IsA("Frame") then
				local v65 = TweenService

				v65.Create(v65, descendant, tweenInfo, {
					BackgroundTransparency = 1
				}):Play()
			elseif descendant:IsA("UIStroke") then
				local v66 = TweenService

				v66.Create(v66, descendant, tweenInfo, {
					Transparency = 1
				}):Play()
			end
		end

		v23(Frame, 0.35, {
			BackgroundTransparency = 1
		})
		v23(Frame2, 0.35, {
			Position = UDim2.fromScale(0.5, 0.53)
		})
		task.wait(0.4)

		if ScreenGui2.Parent then
			ScreenGui2:Destroy()
		end

		if not ScreenGui.Parent then
			return
		end

		ScreenGui:Destroy()

		return
	end

	v52("Invalid key.", v13.Red, "✕")
	v23(TextBox2, 0.08, {
		BackgroundColor3 = Color3.fromRGB(65, 28, 32)
	})
	task.delay(0.5, function()
		local Parent = TextBox2.Parent

		if Parent then
			Parent = not v54
		end

		if not Parent then
			return
		end

		v23(TextBox2, 0.2, {
			BackgroundColor3 = v13.Surface
		})
	end)
end)
