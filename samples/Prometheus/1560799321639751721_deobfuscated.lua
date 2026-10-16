-- This file was generated at discord.gg/syncrypt

local v1 = getgenv and getgenv()
if not v1 then
    v1 = _G or shared
end
local v2 = "STK_" .. tostring(game.GameId) .. "_PASS_" .. tostring(game.PlaceId)
if not v1.__STK_VERIFY__ or v2 ~= v1.__STK_VERIFY__() then
    return
end
v1.__STK_VERIFY__ = nil
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local CurrentCamera = workspace.CurrentCamera
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local n1 = 140
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 999999
local function v15(p1, p2)
    local u86 = false
    local inputPosition
    local p2Position
    p1.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            u86 = true
            inputPosition = input.Position
            p2Position = p2.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        local v299 = u86

        if v299 then
            v299 = input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch
        end

        if v299 then
            local v300 = input.Position - inputPosition

            p2.Position = UDim2.new(p2Position.X.Scale, p2Position.X.Offset + v300.X, p2Position.Y.Scale, p2Position.Y.Offset + v300.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            u86 = false
        end
    end)
end
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 480, 0, 320)
Frame.AnchorPoint = Vector2.new(0.5, 0.5)
Frame.Position = UDim2.new(0.5, 0, 0.5, 0)
Frame.BackgroundColor3 = Color3.fromRGB(34, 36, 38)
Frame.BorderSizePixel = 0
Frame.BackgroundTransparency = 0
Frame.ClipsDescendants = true
Frame.Parent = ScreenGui
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = Frame
local Frame2 = Instance.new("Frame")
Frame2.Size = UDim2.new(0, 1, 1, 0)
Frame2.Position = UDim2.new(0, 140, 0, 0)
Frame2.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Frame2.BorderSizePixel = 0
Frame2.ZIndex = 15
Frame2.Parent = Frame
local TextButton = Instance.new("TextButton")
TextButton.BackgroundTransparency = 1
TextButton.Text = ""
TextButton.Modal = true
TextButton.Size = UDim2.fromScale(1, 1)
TextButton.ZIndex = 0
TextButton.Parent = Frame
local Frame3 = Instance.new("Frame")
Frame3.Size = UDim2.new(1, -(140 - 14), 0, 45)
Frame3.Position = UDim2.new(0, n1 - 14, 0, 0)
Frame3.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
Frame3.BorderSizePixel = 0
Frame3.Parent = Frame
Frame3.ZIndex = 10
local UIPadding = Instance.new("UIPadding")
UIPadding.PaddingLeft = UDim.new(0, 15)
UIPadding.PaddingRight = UDim.new(0, 15)
UIPadding.Parent = Frame3
local UICorner2 = Instance.new("UICorner")
UICorner2.CornerRadius = UDim.new(0, 10)
UICorner2.Parent = Frame3
local Frame4 = Instance.new("Frame")
Frame4.Size = UDim2.new(0, 24, 0, 24)
Frame4.Position = UDim2.new(1, -30, 0.5, -12)
Frame4.BackgroundTransparency = 1
Frame4.ZIndex = 11
Frame4.Parent = Frame3
local Frame5 = Instance.new("Frame")
Frame5.Size = UDim2.new(0, 18, 0, 2)
Frame5.Position = UDim2.new(0.5, -9, 0.5, 0)
Frame5.BackgroundColor3 = Color3.fromRGB(0, 255, 200)
Frame5.BorderSizePixel = 0
Frame5.Rotation = 45
Frame5.ZIndex = 12
Frame5.Parent = Frame4
local Frame6 = Instance.new("Frame")
Frame6.Size = UDim2.new(0, 18, 0, 2)
Frame6.Position = UDim2.new(0.5, -9, 0.5, 0)
Frame6.BackgroundColor3 = Color3.fromRGB(0, 255, 200)
Frame6.BorderSizePixel = 0
Frame6.Rotation = -45
Frame6.ZIndex = 12
Frame6.Parent = Frame4
local TextLabel = Instance.new("TextLabel")
TextLabel.Size = UDim2.new(0, 110, 0, 20)
TextLabel.Position = UDim2.new(1, -160, 0.5, -10)
TextLabel.BackgroundTransparency = 1
TextLabel.Text = "FPS: 0 | Ping: 0ms"
TextLabel.TextColor3 = Color3.fromRGB(0, 255, 200)
TextLabel.Font = Enum.Font.SourceSansSemibold
TextLabel.TextSize = 15
TextLabel.TextXAlignment = Enum.TextXAlignment.Right
TextLabel.ZIndex = 11
TextLabel.Parent = Frame3
local t1 = {
	lastUpdate = 0,
	frameCount = 0,
	updateInterval = 5
}
RunService.Heartbeat:Connect(function(dt)
    t1.frameCount = t1.frameCount + 1
    t1.lastUpdate = t1.lastUpdate + dt

    if t1.lastUpdate >= t1.updateInterval then
        local v90 = math.floor(t1.frameCount / t1.lastUpdate)
        local v91 = math.floor(LocalPlayer:GetNetworkPing() * 1000)

        TextLabel.Text = ("FPS: %d | Ping: %dms").format("FPS: %d | Ping: %dms", v90, v91)
        t1.lastUpdate = 0
        t1.frameCount = 0
    end
end)
v15(Frame3, Frame)
local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.Position = UDim2.new(0, 0, 0, 0)
ScrollingFrame.Size = UDim2.new(0, n1, 1, 0)
ScrollingFrame.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
ScrollingFrame.ScrollBarThickness = 0
ScrollingFrame.BorderSizePixel = 0
ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollingFrame.ScrollingDirection = Enum.ScrollingDirection.Y
ScrollingFrame.Parent = Frame
local UICorner3 = Instance.new("UICorner")
UICorner3.CornerRadius = UDim.new(0, 10)
UICorner3.Parent = ScrollingFrame
local Frame7 = Instance.new("Frame")
Frame7.Size = UDim2.new(1, 0, 0, 50)
Frame7.BackgroundTransparency = 1
Frame7.LayoutOrder = -1
Frame7.Parent = ScrollingFrame
local TextLabel2 = Instance.new("TextLabel")
TextLabel2.Size = UDim2.new(1, 0, 0, 24)
TextLabel2.BackgroundTransparency = 1
TextLabel2.Text = "Place name"
TextLabel2.TextColor3 = Color3.fromRGB(0, 255, 200)
TextLabel2.Font = Enum.Font.GothamBlack
TextLabel2.TextSize = 14
TextLabel2.TextXAlignment = Enum.TextXAlignment.Left
TextLabel2.Parent = Frame7
local TextLabel3 = Instance.new("TextLabel")
TextLabel3.Size = UDim2.new(1, 0, 0, 15)
TextLabel3.Position = UDim2.new(0, 0, 0, 22)
TextLabel3.BackgroundTransparency = 1
TextLabel3.Text = "by Sosiskomras"
TextLabel3.TextColor3 = Color3.fromRGB(200, 200, 200)
TextLabel3.Font = Enum.Font.SourceSans
TextLabel3.TextSize = 12
TextLabel3.TextXAlignment = Enum.TextXAlignment.Left
TextLabel3.Parent = Frame7
local Frame8 = Instance.new("Frame")
Frame8.Size = UDim2.new(1, 20, 0, 1)
Frame8.Position = UDim2.new(0, -10, 1, -5)
Frame8.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Frame8.BorderSizePixel = 0
Frame8.Parent = Frame7
v15(ScrollingFrame, Frame)
local ScrollingFrame2 = Instance.new("ScrollingFrame")
ScrollingFrame2.Size = UDim2.new(1, -n1, 1, -45)
ScrollingFrame2.Position = UDim2.new(0, n1, 0, 45)
ScrollingFrame2.BackgroundTransparency = 1
ScrollingFrame2.ScrollBarThickness = 2
ScrollingFrame2.BorderSizePixel = 0
ScrollingFrame2.AutomaticCanvasSize = Enum.AutomaticSize.Y
ScrollingFrame2.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollingFrame2.ScrollingDirection = Enum.ScrollingDirection.Y
ScrollingFrame2.ScrollingEnabled = false
ScrollingFrame2.Parent = Frame
local UIPadding2 = Instance.new("UIPadding")
UIPadding2.PaddingTop = UDim.new(0, 20)
UIPadding2.PaddingBottom = UDim.new(0, 20)
UIPadding2.PaddingLeft = UDim.new(0, 10)
UIPadding2.PaddingRight = UDim.new(0, 10)
UIPadding2.Parent = ScrollingFrame
local UIListLayout = Instance.new("UIListLayout")
UIListLayout.FillDirection = Enum.FillDirection.Vertical
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 7)
UIListLayout.Parent = ScrollingFrame
local t2 = {}
local u38
local function v39(p3)
    local Frame9 = Instance.new("Frame")

    Frame9.Size = UDim2.new(1, 0, 1, 0)
    Frame9.BackgroundTransparency = 1
    Frame9.Visible = false
    Frame9.Parent = ScrollingFrame2

    local Frame10 = Instance.new("Frame")

    Frame10.Size = UDim2.new(1, 0, 0, 0)
    Frame10.BackgroundTransparency = 1
    Frame10.AutomaticSize = Enum.AutomaticSize.Y
    Frame10.Parent = Frame9

    local UIPadding3 = Instance.new("UIPadding")

    UIPadding3.PaddingTop = UDim.new(0, 10)
    UIPadding3.PaddingBottom = UDim.new(0, 20)
    UIPadding3.PaddingLeft = UDim.new(0, 15)
    UIPadding3.PaddingRight = UDim.new(0, 15)
    UIPadding3.Parent = Frame10

    local UIListLayout2 = Instance.new("UIListLayout")

    UIListLayout2.FillDirection = Enum.FillDirection.Vertical
    UIListLayout2.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout2.Padding = UDim.new(0, 10)
    UIListLayout2.Parent = Frame10
    t2[p3] = {
		frame = Frame9,
		content = Frame10,
		layout = UIListLayout2
	}
    UIListLayout2:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        local v302 = UIListLayout2.AbsoluteContentSize.Y + 10 + 20

        ScrollingFrame2.ScrollingEnabled = v302 > ScrollingFrame2.AbsoluteSize.Y
        ScrollingFrame2.CanvasSize = UDim2.new(0, 0, 0, v302)
    end)

    return Frame10
end
local function v40(p4)
    if not t2[p4] then
        for _, v in pairs(t2) do
            v.frame.Visible = false
        end

        u38 = nil
        ScrollingFrame2.ScrollingEnabled = false
        ScrollingFrame2.CanvasSize = UDim2.new(0, 0, 0, 0)

        return
    end

    for k, v in pairs(t2) do
        v.frame.Visible = k == p4
    end

    u38 = t2[p4]

    local v102 = u38.layout.AbsoluteContentSize.Y + 10 + 20

    ScrollingFrame2.ScrollingEnabled = v102 > ScrollingFrame2.AbsoluteSize.Y
    ScrollingFrame2.CanvasSize = UDim2.new(0, 0, 0, v102)
end
local u41
local n2 = 0
local n3 = 0
local function v44(p5)
    n2 += 1

    local Frame11 = Instance.new("Frame")

    Frame11.Size = UDim2.new(1, 0, 0, 0)
    Frame11.BackgroundColor3 = Color3.fromRGB(28, 30, 32)
    Frame11.BorderSizePixel = 0
    Frame11.AutomaticSize = Enum.AutomaticSize.Y
    Frame11.LayoutOrder = n2

    local v105 = u38

    if v105 then
        v105 = u38.content
    end

    Frame11.Parent = v105 or nil

    local UICorner4 = Instance.new("UICorner")

    UICorner4.CornerRadius = UDim.new(0, 8)
    UICorner4.Parent = Frame11

    local UIStroke = Instance.new("UIStroke")

    UIStroke.Color = Color3.fromRGB(45, 45, 45)
    UIStroke.Thickness = 1
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke.Parent = Frame11

    local UIPadding4 = Instance.new("UIPadding")

    UIPadding4.PaddingTop = UDim.new(0, 12)
    UIPadding4.PaddingBottom = UDim.new(0, 12)
    UIPadding4.PaddingLeft = UDim.new(0, 12)
    UIPadding4.PaddingRight = UDim.new(0, 12)
    UIPadding4.Parent = Frame11

    local UIListLayout3 = Instance.new("UIListLayout")

    UIListLayout3.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout3.Padding = UDim.new(0, 8)
    UIListLayout3.Parent = Frame11

    if p5 and p5 ~= "" then
        local TextLabel4 = Instance.new("TextLabel")

        TextLabel4.Size = UDim2.new(1, 0, 0, 18)
        TextLabel4.BackgroundTransparency = 1
        TextLabel4.Text = string.upper(p5)
        TextLabel4.TextColor3 = Color3.fromRGB(0, 255, 200)
        TextLabel4.Font = Enum.Font.GothamBold
        TextLabel4.TextSize = 13
        TextLabel4.TextXAlignment = Enum.TextXAlignment.Left
        TextLabel4.LayoutOrder = -1
        TextLabel4.Parent = Frame11
    end

    u41 = Frame11

    return Frame11
end
local function v45()
    u41 = nil
end
local t3 = {}
local u47
local function v48(p6, p7, p8)
    if not p8 then
        n3 += 1
    end

    local Frame12 = Instance.new("Frame")

    Frame12.Size = UDim2.new(1, 0, 0, 38)
    Frame12.BackgroundColor3 = Color3.fromRGB(24, 28, 30)
    Frame12.BorderSizePixel = 0

    if not p8 then
        p8 = n3
    end

    Frame12.LayoutOrder = p8
    Frame12.Parent = ScrollingFrame

    local UICorner5 = Instance.new("UICorner")

    UICorner5.CornerRadius = UDim.new(0, 8)
    UICorner5.Parent = Frame12

    local UIStroke = Instance.new("UIStroke")

    UIStroke.Name = "Stroke"
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke.Color = Color3.fromRGB(45, 58, 56)
    UIStroke.Thickness = 1
    UIStroke.Transparency = 0
    UIStroke.Parent = Frame12

    local Frame13 = Instance.new("Frame")

    Frame13.Size = UDim2.new(0, 3, 1, -10)
    Frame13.Position = UDim2.new(0, 6, 0, 5)
    Frame13.BackgroundColor3 = Color3.fromRGB(0, 255, 200)
    Frame13.BorderSizePixel = 0
    Frame13.BackgroundTransparency = 1
    Frame13.Name = "ActiveLine"
    Frame13.Parent = Frame12

    local UICorner6 = Instance.new("UICorner")

    UICorner6.CornerRadius = UDim.new(1, 0)
    UICorner6.Parent = Frame13

    local ImageLabel = Instance.new("ImageLabel")

    ImageLabel.Name = "Icon"
    ImageLabel.Size = UDim2.new(0, 18, 0, 18)
    ImageLabel.Position = UDim2.new(0, 16, 0.5, -9)
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.Image = p7 or ""
    ImageLabel.ImageColor3 = Color3.fromRGB(170, 190, 185)
    ImageLabel.Parent = Frame12

    local TextLabel5 = Instance.new("TextLabel")

    TextLabel5.Name = "Label"
    TextLabel5.Size = UDim2.new(1, -44, 1, 0)
    TextLabel5.Position = UDim2.new(0, 42, 0, 0)
    TextLabel5.BackgroundTransparency = 1
    TextLabel5.Text = p6
    TextLabel5.TextColor3 = Color3.fromRGB(170, 190, 185)
    TextLabel5.Font = Enum.Font.GothamMedium
    TextLabel5.TextSize = 14
    TextLabel5.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel5.Parent = Frame12
    table.insert(t3, Frame12)
    Frame12.MouseEnter:Connect(function()
        if u47 ~= Frame12 then
            TweenService:Create(Frame12, TweenInfo.new(0.15), {
				BackgroundColor3 = Color3.fromRGB(30, 36, 38)
			}):Play()
            TweenService:Create(ImageLabel, TweenInfo.new(0.15), {
				ImageColor3 = Color3.fromRGB(210, 230, 225)
			}):Play()

            local new = TweenInfo.new

            TweenService:Create(TextLabel5, new(0.15), {
				TextColor3 = Color3.fromRGB(210, 230, 225)
			}):Play()
            TweenService:Create(UIStroke, TweenInfo.new(0.15), {
				Color = Color3.fromRGB(70, 95, 90)
			}):Play()
        end
    end)
    Frame12.MouseLeave:Connect(function()
        if u47 ~= Frame12 then
            TweenService:Create(Frame12, TweenInfo.new(0.15), {
				BackgroundColor3 = Color3.fromRGB(24, 28, 30)
			}):Play()
            TweenService:Create(ImageLabel, TweenInfo.new(0.15), {
				ImageColor3 = Color3.fromRGB(170, 190, 185)
			}):Play()
            TweenService:Create(TextLabel5, TweenInfo.new(0.15), {
				TextColor3 = Color3.fromRGB(170, 190, 185)
			}):Play()
            TweenService:Create(UIStroke, TweenInfo.new(0.15), {
				Color = Color3.fromRGB(45, 58, 56)
			}):Play()
        end
    end)
    Frame12.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            v40(p6)

            if u47 and u47 ~= Frame12 then
                TweenService:Create(u47, TweenInfo.new(0.2), {
					BackgroundColor3 = Color3.fromRGB(24, 28, 30)
				}):Play()

                local ActiveLine = u47:FindFirstChild("ActiveLine")

                if ActiveLine then
                    TweenService:Create(ActiveLine, TweenInfo.new(0.2), {
						BackgroundTransparency = 1
					}):Play()
                end

                local Icon = u47:FindFirstChild("Icon")

                if Icon then
                    TweenService:Create(Icon, TweenInfo.new(0.2), {
						ImageColor3 = Color3.fromRGB(170, 190, 185)
					}):Play()
                end

                local Label = u47:FindFirstChild("Label")

                if Label then
                    TweenService:Create(Label, TweenInfo.new(0.2), {
						TextColor3 = Color3.fromRGB(170, 190, 185)
					}):Play()
                end

                local Stroke = u47:FindFirstChild("Stroke")

                if Stroke then
                    TweenService:Create(Stroke, TweenInfo.new(0.2), {
						Color = Color3.fromRGB(45, 58, 56)
					}):Play()
                end
            end

            TweenService:Create(Frame12, TweenInfo.new(0.2), {
				BackgroundColor3 = Color3.fromRGB(18, 48, 42)
			}):Play()
            TweenService:Create(Frame13, TweenInfo.new(0.2), {
				BackgroundTransparency = 0
			}):Play()
            TweenService:Create(ImageLabel, TweenInfo.new(0.2), {
				ImageColor3 = Color3.fromRGB(0, 255, 200)
			}):Play()
            TweenService:Create(TextLabel5, TweenInfo.new(0.2), {
				TextColor3 = Color3.fromRGB(255, 255, 255)
			}):Play()
            TweenService:Create(UIStroke, TweenInfo.new(0.2), {
				Color = Color3.fromRGB(0, 255, 200)
			}):Play()
            u47 = Frame12
        end
    end)

    return Frame12
end
local function v49(p9, p10, p11)
    n2 += 1
    local Frame14 = Instance.new("Frame")
    Frame14.Size = UDim2.new(1, 0, 0, 44)
    Frame14.BackgroundColor3 = Color3.fromRGB(34, 38, 44)
    Frame14.BorderSizePixel = 0
    Frame14.LayoutOrder = n2
    Frame14.Parent = if not u41 then u38 and u38.content or nil else u41
    local UICorner7 = Instance.new("UICorner")
    UICorner7.CornerRadius = UDim.new(0, 8)
    UICorner7.Parent = Frame14
    local UIStroke = Instance.new("UIStroke")
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke.Color = Color3.fromRGB(65, 72, 84)
    UIStroke.Thickness = 1.2
    UIStroke.Parent = Frame14
    local TextLabel6 = Instance.new("TextLabel")
    local v160 = p11 and UDim2.new(1, -28, 1, 0)
    if not v160 then
        v160 = UDim2.new(1, -110, 1, 0)
    end
    TextLabel6.Size = v160
    TextLabel6.Position = UDim2.new(0, 14, 0, 0)
    TextLabel6.BackgroundTransparency = 1
    TextLabel6.Text = p9
    TextLabel6.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextLabel6.Font = Enum.Font.GothamBold
    TextLabel6.TextSize = 14
    TextLabel6.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel6.Parent = Frame14
    local Frame15
    local TextLabel7
    local u163
    if not p11 then
        Frame15 = Instance.new("Frame")
        Frame15.Size = UDim2.new(0, 84, 0, 28)
        Frame15.Position = UDim2.new(1, -94, 0.5, -14)
        Frame15.BackgroundColor3 = Color3.fromRGB(48, 54, 64)
        Frame15.BorderSizePixel = 0
        Frame15.Parent = Frame14

        local v164 = Frame15
        local UICorner8 = Instance.new("UICorner")

        UICorner8.CornerRadius = UDim.new(0, 6)
        UICorner8.Parent = v164

        local UIStroke2 = Instance.new("UIStroke")

        UIStroke2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        UIStroke2.Color = Color3.fromRGB(75, 84, 98)
        UIStroke2.Thickness = 1
        UIStroke2.Parent = Frame15
        TextLabel7 = Instance.new("TextLabel")
        TextLabel7.Size = UDim2.fromScale(1, 1)
        TextLabel7.BackgroundTransparency = 1
        TextLabel7.Text = "Run"
        TextLabel7.TextColor3 = Color3.fromRGB(0, 255, 200)
        TextLabel7.Font = Enum.Font.GothamBold
        TextLabel7.TextSize = 12
        TextLabel7.Parent = Frame15
    end
    local TextButton2 = Instance.new("TextButton")
    TextButton2.Size = UDim2.fromScale(1, 1)
    TextButton2.BackgroundTransparency = 1
    TextButton2.Text = ""
    TextButton2.Parent = Frame14
    TextButton2.MouseEnter:Connect(function()
        if not p11 then
            TweenService:Create(Frame15, TweenInfo.new(0.2), {
				BackgroundColor3 = Color3.fromRGB(0, 255, 200)
			}):Play()
            TweenService:Create(TextLabel7, TweenInfo.new(0.2), {
				TextColor3 = Color3.fromRGB(0, 0, 0)
			}):Play()
        end

        TweenService:Create(Frame14, TweenInfo.new(0.2), {
			BackgroundColor3 = Color3.fromRGB(44, 50, 58)
		}):Play()
        TweenService:Create(UIStroke, TweenInfo.new(0.2), {
			Color = Color3.fromRGB(0, 255, 200)
		}):Play()
    end)
    TextButton2.MouseLeave:Connect(function()
        if not p11 then
            TweenService:Create(Frame15, TweenInfo.new(0.2), {
				BackgroundColor3 = Color3.fromRGB(48, 54, 64)
			}):Play()
            TweenService:Create(TextLabel7, TweenInfo.new(0.2), {
				TextColor3 = Color3.fromRGB(0, 255, 200)
			}):Play()
        end

        TweenService:Create(Frame14, TweenInfo.new(0.2), {
			BackgroundColor3 = Color3.fromRGB(34, 38, 44)
		}):Play()
        TweenService:Create(UIStroke, TweenInfo.new(0.2), {
			Color = Color3.fromRGB(65, 72, 84)
		}):Play()
    end)
    TextButton2.Activated:Connect(function()
        if p10 then
            p10()
        end

        if not p11 and not u163 then
            u163 = true
            TextLabel7.Text = "Executed"
            task.delay(1.5, function()
                TextLabel7.Text = "Run"
                u163 = false
            end)
        end
    end)

    return Frame14
end
local function v50(p12, p13)
    n2 += 1

    local Frame16 = Instance.new("Frame")

    Frame16.Size = UDim2.new(1, 0, 0, 30)
    Frame16.BackgroundTransparency = 1
    Frame16.LayoutOrder = n2
    Frame16.Parent = if not u41 then u38 and u38.content or nil else u41

    local TextLabel8 = Instance.new("TextLabel")

    TextLabel8.Size = UDim2.new(1, -60, 1, 0)
    TextLabel8.Position = UDim2.new(0, 0, 0, 0)
    TextLabel8.BackgroundTransparency = 1
    TextLabel8.Text = p12
    TextLabel8.TextColor3 = Color3.fromRGB(230, 230, 230)
    TextLabel8.Font = Enum.Font.SourceSansSemibold
    TextLabel8.TextSize = 18
    TextLabel8.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel8.Parent = Frame16

    local Frame17 = Instance.new("Frame")

    Frame17.Size = UDim2.new(0, 50, 0, 24)
    Frame17.Position = UDim2.new(1, -55, 0.5, -12)
    Frame17.BackgroundColor3 = Color3.fromRGB(180, 180, 180)
    Frame17.BorderSizePixel = 0
    Frame17.Parent = Frame16

    local UICorner9 = Instance.new("UICorner")

    UICorner9.CornerRadius = UDim.new(0.5, 0)
    UICorner9.Parent = Frame17

    local Frame18 = Instance.new("Frame")

    Frame18.Size = UDim2.new(0, 20, 0, 20)
    Frame18.Position = UDim2.new(0, 2, 0.5, -10)
    Frame18.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Frame18.Parent = Frame17

    local UICorner10 = Instance.new("UICorner")

    UICorner10.CornerRadius = UDim.new(1, 0)
    UICorner10.Parent = Frame18

    local u176 = false

    local function v177()
        if u176 then
            local new = TweenInfo.new
            local EasingStyle = Enum.EasingStyle

            TweenService:Create(Frame17, new(0.25, EasingStyle.Quad), {
				BackgroundColor3 = Color3.fromRGB(100, 200, 120)
			}):Play()
            TweenService:Create(Frame18, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
				Position = UDim2.new(1, -22, 0.5, -10)
			}):Play()

            return
        end

        local new = TweenInfo.new

        TweenService:Create(Frame17, new(0.25, Enum.EasingStyle.Quad), {
			BackgroundColor3 = Color3.fromRGB(180, 180, 180)
		}):Play()
        TweenService:Create(Frame18, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
			Position = UDim2.new(0, 2, 0.5, -10)
		}):Play()
    end

    Frame17.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            u176 = not u176
            v177()

            if p13 then
                p13(u176)
            end
        end
    end)
    v177()
end
v48("Settings", "rbxassetid://90091610697193", 999)
v39("Settings")
v40("Settings")
v44("Interface settings")
local t4 = {
	HideMiniWidget = false,
	IsAnimating = false
}
local ScreenGui2 = Instance.new("ScreenGui")
ScreenGui2.Name = "MiniWidgetGui"
ScreenGui2.ResetOnSpawn = false
ScreenGui2.DisplayOrder = 999999
ScreenGui2.IgnoreGuiInset = true
ScreenGui2.Parent = PlayerGui
local Frame19 = Instance.new("Frame")
Frame19.Size = UDim2.new(0, 155, 0, 34)
Frame19.AnchorPoint = Vector2.new(0.5, 0)
Frame19.Position = UDim2.new(0.5, 0, 0, -45)
Frame19.BackgroundColor3 = Color3.fromRGB(24, 28, 30)
Frame19.BorderSizePixel = 0
Frame19.Visible = false
Frame19.ZIndex = 20
Frame19.Parent = ScreenGui2
local UICorner11 = Instance.new("UICorner")
UICorner11.CornerRadius = UDim.new(0, 6)
UICorner11.Parent = Frame19
local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(45, 58, 56)
UIStroke.Thickness = 1
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke.Parent = Frame19
local Frame20 = Instance.new("Frame")
Frame20.Size = UDim2.fromScale(1, 1)
Frame20.BackgroundTransparency = 1
Frame20.ZIndex = 21
Frame20.Parent = Frame19
local UIListLayout4 = Instance.new("UIListLayout")
UIListLayout4.FillDirection = Enum.FillDirection.Horizontal
UIListLayout4.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout4.VerticalAlignment = Enum.VerticalAlignment.Center
UIListLayout4.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout4.Padding = UDim.new(0, 8)
UIListLayout4.Parent = Frame20
local ImageLabel = Instance.new("ImageLabel")
ImageLabel.Size = UDim2.new(0, 20, 0, 20)
ImageLabel.BackgroundTransparency = 1
ImageLabel.Image = "rbxassetid://85587045526405"
ImageLabel.ImageColor3 = Color3.fromRGB(255, 255, 255)
ImageLabel.LayoutOrder = 1
ImageLabel.ZIndex = 21
ImageLabel.Parent = Frame20
local TextLabel9 = Instance.new("TextLabel")
TextLabel9.AutomaticSize = Enum.AutomaticSize.X
TextLabel9.Size = UDim2.new(0, 0, 1, 0)
TextLabel9.BackgroundTransparency = 1
TextLabel9.Text = "FPS: 0 | Ping: 0ms"
TextLabel9.TextColor3 = Color3.fromRGB(0, 255, 200)
TextLabel9.Font = Enum.Font.SourceSansSemibold
TextLabel9.TextSize = 14
TextLabel9.TextXAlignment = Enum.TextXAlignment.Left
TextLabel9.LayoutOrder = 2
TextLabel9.ZIndex = 21
TextLabel9.Parent = Frame20
local TextButton3 = Instance.new("TextButton")
TextButton3.Size = UDim2.fromScale(1, 1)
TextButton3.BackgroundTransparency = 1
TextButton3.Text = ""
TextButton3.ZIndex = 22
local u61
TextButton3.Parent = Frame19
TextLabel:GetPropertyChangedSignal("Text"):Connect(function()
    TextLabel9.Text = TextLabel.Text
    Frame19.Size = UDim2.new(0, TextLabel9.TextBounds.X + 44, 0, 34)
end)
TextButton3.MouseEnter:Connect(function()
    TweenService:Create(Frame19, TweenInfo.new(0.15), {
		BackgroundColor3 = Color3.fromRGB(30, 36, 38)
	}):Play()
    TweenService:Create(UIStroke, TweenInfo.new(0.15), {
		Color = Color3.fromRGB(0, 255, 200)
	}):Play()
end)
TextButton3.MouseLeave:Connect(function()
    TweenService:Create(Frame19, TweenInfo.new(0.15), {
		BackgroundColor3 = Color3.fromRGB(24, 28, 30)
	}):Play()
    TweenService:Create(UIStroke, TweenInfo.new(0.15), {
		Color = Color3.fromRGB(45, 58, 56)
	}):Play()
end)
local function v62()
    if t4.IsAnimating then
        return
    end

    t4.IsAnimating = true
    Frame.Visible = false
    Frame19.Position = UDim2.new(0.5, 0, 0, -45)
    Frame19.Visible = true

    local tween = TweenService:Create(Frame19, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
		Position = UDim2.new(0.5, 0, 0, 10)
	})

    tween:Play()
    tween.Completed:Wait()
    t4.IsAnimating = false
end
function u61()
    if t4.IsAnimating then
        return
    end

    t4.IsAnimating = true

    local tween = TweenService:Create(Frame19, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
		Position = UDim2.new(0.5, 0, 0, -45)
	})

    tween:Play()
    tween.Completed:Wait()
    Frame19.Visible = false
    Frame.Visible = true
    t4.IsAnimating = false
end
TextButton3.MouseButton1Click:Connect(function()
    u61()
end)
Frame4.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        if not Frame.Visible then
            return
        end

        if t4.HideMiniWidget then
            Frame.Visible = false
            Frame19.Visible = false

            return
        end

        v62()
    end
end)
v50("Hide Mini Widget", function(p14)
    t4.HideMiniWidget = p14

    if p14 then
        p14 = Frame19.Visible
    end

    if p14 then
        Frame19.Visible = false
    end
end)
v45()
v44("Camera")
local CameraMaxZoomDistance = LocalPlayer.CameraMaxZoomDistance
local CameraMinZoomDistance = LocalPlayer.CameraMinZoomDistance
local CameraMode = LocalPlayer.CameraMode
local FieldOfView = CurrentCamera.FieldOfView
local CameraType = CurrentCamera.CameraType
local DevCameraOcclusionMode = LocalPlayer.DevCameraOcclusionMode
local t5 = {
	DefaultMax = CameraMaxZoomDistance,
	DefaultMin = CameraMinZoomDistance,
	DefaultMode = CameraMode,
	DefaultFOV = FieldOfView,
	DefaultType = CameraType,
	DefaultOcclusion = DevCameraOcclusionMode,
	UnlockCamActive = false,
	UnlockCamNoWallsActive = false
}
v50("Unlock Camera", function(p15)
    t5.UnlockCamActive = p15

    if p15 then
        CurrentCamera.CameraType = Enum.CameraType.Custom
        CurrentCamera.FieldOfView = 70
        LocalPlayer.CameraMaxZoomDistance = 400
        LocalPlayer.CameraMinZoomDistance = 0.5
        LocalPlayer.CameraMode = Enum.CameraMode.Classic

        return
    end

    if not t5.UnlockCamNoWallsActive then
        CurrentCamera.CameraType = t5.DefaultType
        CurrentCamera.FieldOfView = t5.DefaultFOV
        LocalPlayer.CameraMaxZoomDistance = t5.DefaultMax
        LocalPlayer.CameraMinZoomDistance = t5.DefaultMin
        LocalPlayer.CameraMode = t5.DefaultMode
    end
end)
v50("Unlock Camera (No Walls)", function(p16)
    t5.UnlockCamNoWallsActive = p16

    if p16 then
        CurrentCamera.CameraType = Enum.CameraType.Custom
        CurrentCamera.FieldOfView = 70
        LocalPlayer.CameraMaxZoomDistance = 400
        LocalPlayer.CameraMinZoomDistance = 0.5
        LocalPlayer.CameraMode = Enum.CameraMode.Classic
        LocalPlayer.DevCameraOcclusionMode = Enum.DevCameraOcclusionMode.Invisicam

        return
    end

    LocalPlayer.DevCameraOcclusionMode = t5.DefaultOcclusion

    if not t5.UnlockCamActive then
        CurrentCamera.CameraType = t5.DefaultType
        CurrentCamera.FieldOfView = t5.DefaultFOV
        LocalPlayer.CameraMaxZoomDistance = t5.DefaultMax
        LocalPlayer.CameraMinZoomDistance = t5.DefaultMin
        LocalPlayer.CameraMode = t5.DefaultMode
        LocalPlayer.DevCameraOcclusionMode = t5.DefaultOcclusion
    end
end)
v45()
v44("Utilities")
local t6 = {
	IsEnabled = false,
	Connection = nil
}
local u71
local function v72()
    if t6.Connection then
        return
    end

    t6.Connection = Players.LocalPlayer.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
end
function u71()
    if t6.Connection then
        t6.Connection:Disconnect()
        t6.Connection = nil
    end
end
v50("Anti AFK", function(p17)
    t6.IsEnabled = p17

    if p17 then
        v72()

        return
    end

    u71()
end)
local PlaceId = game.PlaceId
local t7 = {
	Gui = nil,
	Window = nil,
	CachedPlaceId = PlaceId,
	RawServers = {},
	IsFetching = false,
	LastRefreshTick = 0,
	RefreshCooldown = 4,
	CurrentSort = "default",
	HideFull = false,
	HideEmpty = false,
	SortButtons = {},
	StatusLabel = nil,
	BtnRefresh = nil,
	BtnRefreshText = nil,
	ToggleHideFull = nil,
	ToggleHideFullText = nil,
	ToggleHideEmpty = nil,
	ToggleHideEmptyText = nil,
	Scroll = nil
}
v50("Show Server List", function(p18)
    if not p18 then
        if t7.Window then
            TweenService:Create(t7.Window, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
				Position = UDim2.new(0.5, 0, 0.53, 0),
				BackgroundTransparency = 1
			}):Play()
            task.delay(0.2, function()
                if not t7.Window.Parent or t7.Window.BackgroundTransparency == 1 then
                    t7.Window.Visible = false
                end
            end)
        end

        return
    end
    if t7.Window then
        t7.Window.Visible = true
        t7.Window.Position = UDim2.new(0.5, 0, 0.53, 0)
        t7.Window.BackgroundTransparency = 1
        TweenService:Create(t7.Window, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
			Position = UDim2.new(0.5, 0, 0.5, 0),
			BackgroundTransparency = 0.12
		}):Play()

        return
    end
    local v239 = syn and syn.request
    if not v239 then
        v239 = http and http.request

        if not v239 then
            v239 = http_request or request
        end
    end
    local u240 = v239;
    (function()
        local v359 = u240

        if v359 then
            v359 = game.GameId and game.GameId > 0
        end

        if v359 then
            local ok, result = pcall(function()
                return u240({
					Url = "https://games.roblox.com/v1/games?universeIds=" .. tostring(game.GameId),
					Method = "GET"
				})
            end)
            local v362 = result

            if ok then
                ok = v362

                if ok then
                    ok = v362.StatusCode == 200 or v362.Status == 200
                end
            end

            if ok then
                local ok2, result2 = pcall(function()
                    return HttpService:JSONDecode(v362.Body)
                end)

                if ok2 then
                    ok2 = result2

                    if result2 then
                        ok2 = result2.data

                        if ok2 then
                            ok2 = result2.data[1] and result2.data[1].rootPlaceId
                        end
                    end
                end

                if ok2 then
                    t7.CachedPlaceId = result2.data[1].rootPlaceId
                end
            end
        end
    end)()
    local ServerList = PlayerGui:FindFirstChild("ServerList")
    if ServerList then
        ServerList:Destroy()
    end
    t7.Gui = Instance.new("ScreenGui")
    t7.Gui.Name = "ServerList"
    t7.Gui.ResetOnSpawn = false
    t7.Gui.DisplayOrder = 1000000
    t7.Gui.Parent = PlayerGui
    t7.Window = Instance.new("Frame")
    t7.Window.AnchorPoint = Vector2.new(0.5, 0.5)
    t7.Window.Size = UDim2.new(0, 420, 0, 280)
    t7.Window.Position = UDim2.new(0.5, 0, 0.53, 0)
    t7.Window.BackgroundColor3 = Color3.fromRGB(16, 17, 20)
    t7.Window.BackgroundTransparency = 1
    t7.Window.BorderSizePixel = 0
    t7.Window.Active = true
    t7.Window.Visible = true
    t7.Window.ClipsDescendants = true
    t7.Window.Parent = t7.Gui
    local Window = t7.Window
    local UICorner12 = Instance.new("UICorner")
    UICorner12.CornerRadius = UDim.new(0, 10)
    UICorner12.Parent = Window
    local Window2 = t7.Window
    local new = TweenInfo.new
    local Quart = Enum.EasingStyle.Quart
    TweenService:Create(Window2, new(0.28, Quart, Enum.EasingDirection.Out), {
		Position = UDim2.new(0.5, 0, 0.5, 0),
		BackgroundTransparency = 0.12
	}):Play()
    local UIStroke3 = Instance.new("UIStroke")
    UIStroke3.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke3.Color = Color3.fromRGB(55, 62, 75)
    UIStroke3.Transparency = 0.2
    UIStroke3.Thickness = 1.2
    UIStroke3.Parent = t7.Window
    local Frame21 = Instance.new("Frame")
    Frame21.Size = UDim2.new(1, 0, 0, 44)
    Frame21.BackgroundColor3 = Color3.fromRGB(22, 24, 29)
    Frame21.BackgroundTransparency = 0.15
    Frame21.BorderSizePixel = 0
    Frame21.Parent = t7.Window
    local UICorner13 = Instance.new("UICorner")
    UICorner13.CornerRadius = UDim.new(0, 10)
    UICorner13.Parent = Frame21
    local Frame22 = Instance.new("Frame")
    Frame22.Size = UDim2.new(1, 0, 0, 10)
    Frame22.Position = UDim2.new(0, 0, 1, -10)
    Frame22.BackgroundColor3 = Color3.fromRGB(22, 24, 29)
    Frame22.BackgroundTransparency = 0.15
    Frame22.BorderSizePixel = 0
    Frame22.Parent = Frame21
    v15(Frame21, t7.Window)
    local TextLabel10 = Instance.new("TextLabel")
    TextLabel10.Size = UDim2.new(1, -95, 1, 0)
    TextLabel10.Position = UDim2.new(0, 14, 0, 0)
    TextLabel10.BackgroundTransparency = 1
    TextLabel10.Text = "SERVER LIST"
    TextLabel10.TextColor3 = Color3.fromRGB(0, 255, 200)
    TextLabel10.Font = Enum.Font.GothamBold
    TextLabel10.TextSize = 14
    TextLabel10.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel10.Parent = Frame21
    t7.BtnRefresh = Instance.new("Frame")
    t7.BtnRefresh.Size = UDim2.new(0, 68, 0, 26)
    t7.BtnRefresh.Position = UDim2.new(1, -78, 0.5, -13)
    t7.BtnRefresh.BackgroundColor3 = Color3.fromRGB(32, 36, 45)
    t7.BtnRefresh.BackgroundTransparency = 0.1
    t7.BtnRefresh.BorderSizePixel = 0
    t7.BtnRefresh.Active = true
    t7.BtnRefresh.Parent = Frame21
    local BtnRefresh = t7.BtnRefresh
    local UICorner14 = Instance.new("UICorner")
    UICorner14.CornerRadius = UDim.new(0, 6)
    UICorner14.Parent = BtnRefresh
    t7.BtnRefreshText = Instance.new("TextLabel")
    t7.BtnRefreshText.Size = UDim2.fromScale(1, 1)
    t7.BtnRefreshText.BackgroundTransparency = 1
    t7.BtnRefreshText.Text = "Refresh"
    t7.BtnRefreshText.TextColor3 = Color3.fromRGB(220, 225, 235)
    t7.BtnRefreshText.Font = Enum.Font.GothamBold
    t7.BtnRefreshText.TextSize = 11
    t7.BtnRefreshText.Parent = t7.BtnRefresh
    t7.BtnRefresh.MouseEnter:Connect(function()
        TweenService:Create(t7.BtnRefresh, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			BackgroundColor3 = Color3.fromRGB(48, 56, 70)
		}):Play()
        TweenService:Create(t7.BtnRefreshText, TweenInfo.new(0.18), {
			TextColor3 = Color3.fromRGB(255, 255, 255)
		}):Play()
    end)
    t7.BtnRefresh.MouseLeave:Connect(function()
        TweenService:Create(t7.BtnRefresh, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			BackgroundColor3 = Color3.fromRGB(32, 36, 45)
		}):Play()
        TweenService:Create(t7.BtnRefreshText, TweenInfo.new(0.18), {
			TextColor3 = Color3.fromRGB(220, 225, 235)
		}):Play()
    end)
    local Frame23 = Instance.new("Frame")
    Frame23.Size = UDim2.new(1, -20, 0, 68)
    Frame23.Position = UDim2.new(0, 10, 0, 50)
    Frame23.BackgroundColor3 = Color3.fromRGB(22, 24, 30)
    Frame23.BackgroundTransparency = 0.18
    Frame23.BorderSizePixel = 0
    Frame23.ClipsDescendants = true
    Frame23.Parent = t7.Window
    local UICorner15 = Instance.new("UICorner")
    UICorner15.CornerRadius = UDim.new(0, 6)
    UICorner15.Parent = Frame23
    local UIStroke4 = Instance.new("UIStroke")
    UIStroke4.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke4.Color = Color3.fromRGB(48, 54, 66)
    UIStroke4.Transparency = 0.3
    UIStroke4.Thickness = 1
    UIStroke4.Parent = Frame23
    local TextLabel11 = Instance.new("TextLabel")
    TextLabel11.Size = UDim2.new(0, 44, 0, 24)
    TextLabel11.Position = UDim2.new(0, 8, 0, 6)
    TextLabel11.BackgroundTransparency = 1
    TextLabel11.Text = "Sort:"
    TextLabel11.TextColor3 = Color3.fromRGB(150, 160, 175)
    TextLabel11.Font = Enum.Font.GothamBold
    TextLabel11.TextSize = 11
    TextLabel11.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel11.Parent = Frame23
    local t8 = {
		{
			Id = "default",
			Name = "Default"
		},
		{
			Id = "lowest",
			Name = "Min Players"
		},
		{
			Id = "highest",
			Name = "Max Players"
		},
		{
			Id = "ping",
			Name = "Best Ping"
		}
	}
    local Frame24 = Instance.new("Frame")
    Frame24.Size = UDim2.new(1, -54, 0, 24)
    Frame24.Position = UDim2.new(0, 48, 0, 6)
    Frame24.BackgroundTransparency = 1
    Frame24.Parent = Frame23
    local UIListLayout5 = Instance.new("UIListLayout")
    UIListLayout5.FillDirection = Enum.FillDirection.Horizontal
    UIListLayout5.Padding = UDim.new(0, 5)
    UIListLayout5.Parent = Frame24
    t7.ToggleHideFull = Instance.new("Frame")
    t7.ToggleHideFull.Size = UDim2.new(0.48, -4, 0, 24)
    t7.ToggleHideFull.Position = UDim2.new(0, 8, 0, 36)
    t7.ToggleHideFull.BackgroundColor3 = Color3.fromRGB(30, 34, 42)
    t7.ToggleHideFull.BackgroundTransparency = 0.15
    t7.ToggleHideFull.BorderSizePixel = 0
    t7.ToggleHideFull.Active = true
    t7.ToggleHideFull.Parent = Frame23
    local ToggleHideFull = t7.ToggleHideFull
    local UICorner16 = Instance.new("UICorner")
    UICorner16.CornerRadius = UDim.new(0, 5)
    UICorner16.Parent = ToggleHideFull
    t7.ToggleHideFullText = Instance.new("TextLabel")
    t7.ToggleHideFullText.Size = UDim2.fromScale(1, 1)
    t7.ToggleHideFullText.BackgroundTransparency = 1
    t7.ToggleHideFullText.Text = "Hide Full: OFF"
    t7.ToggleHideFullText.TextColor3 = Color3.fromRGB(175, 185, 195)
    t7.ToggleHideFullText.Font = Enum.Font.SourceSansSemibold
    t7.ToggleHideFullText.TextSize = 13
    t7.ToggleHideFullText.Parent = t7.ToggleHideFull
    t7.ToggleHideFull.MouseEnter:Connect(function()
        local v365 = TweenService
        local ToggleHideFull2 = t7.ToggleHideFull
        local tweenInfo = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local HideFull = t7.HideFull

        if HideFull then
            HideFull = Color3.fromRGB(0, 185, 140)
        end

        if not HideFull then
            HideFull = Color3.fromRGB(44, 50, 62)
        end

        v365:Create(ToggleHideFull2, tweenInfo, {
			BackgroundColor3 = HideFull
		}):Play()
        TweenService:Create(t7.ToggleHideFullText, TweenInfo.new(0.18), {
			TextColor3 = Color3.fromRGB(255, 255, 255)
		}):Play()
    end)
    t7.ToggleHideFull.MouseLeave:Connect(function()
        local v369 = TweenService
        local ToggleHideFull3 = t7.ToggleHideFull
        local tweenInfo = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local v372 = t7.HideFull and Color3.fromRGB(0, 160, 120)

        if not v372 then
            v372 = Color3.fromRGB(30, 34, 42)
        end

        v369:Create(ToggleHideFull3, tweenInfo, {
			BackgroundColor3 = v372
		}):Play()

        local v373 = TweenService
        local ToggleHideFullText = t7.ToggleHideFullText
        local tweenInfo2 = TweenInfo.new(0.18)
        local v376 = t7.HideFull and Color3.fromRGB(255, 255, 255)

        if not v376 then
            v376 = Color3.fromRGB(175, 185, 195)
        end

        v373:Create(ToggleHideFullText, tweenInfo2, {
			TextColor3 = v376
		}):Play()
    end)
    t7.ToggleHideEmpty = Instance.new("Frame")
    t7.ToggleHideEmpty.Size = UDim2.new(0.48, -4, 0, 24)
    t7.ToggleHideEmpty.Position = UDim2.new(0.52, 0, 0, 36)
    t7.ToggleHideEmpty.BackgroundColor3 = Color3.fromRGB(30, 34, 42)
    t7.ToggleHideEmpty.BackgroundTransparency = 0.15
    t7.ToggleHideEmpty.BorderSizePixel = 0
    t7.ToggleHideEmpty.Active = true
    t7.ToggleHideEmpty.Parent = Frame23
    local ToggleHideEmpty = t7.ToggleHideEmpty
    local UICorner17 = Instance.new("UICorner")
    UICorner17.CornerRadius = UDim.new(0, 5)
    UICorner17.Parent = ToggleHideEmpty
    t7.ToggleHideEmptyText = Instance.new("TextLabel")
    t7.ToggleHideEmptyText.Size = UDim2.fromScale(1, 1)
    t7.ToggleHideEmptyText.BackgroundTransparency = 1
    t7.ToggleHideEmptyText.Text = "Hide Empty: OFF"
    t7.ToggleHideEmptyText.TextColor3 = Color3.fromRGB(175, 185, 195)
    t7.ToggleHideEmptyText.Font = Enum.Font.SourceSansSemibold
    t7.ToggleHideEmptyText.TextSize = 13
    t7.ToggleHideEmptyText.Parent = t7.ToggleHideEmpty
    t7.ToggleHideEmpty.MouseEnter:Connect(function()
        local v377 = TweenService
        local ToggleHideEmpty2 = t7.ToggleHideEmpty
        local tweenInfo = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local v380 = t7.HideEmpty and Color3.fromRGB(0, 185, 140)

        if not v380 then
            v380 = Color3.fromRGB(44, 50, 62)
        end

        v377:Create(ToggleHideEmpty2, tweenInfo, {
			BackgroundColor3 = v380
		}):Play()
        TweenService:Create(t7.ToggleHideEmptyText, TweenInfo.new(0.18), {
			TextColor3 = Color3.fromRGB(255, 255, 255)
		}):Play()
    end)
    t7.ToggleHideEmpty.MouseLeave:Connect(function()
        TweenService:Create(t7.ToggleHideEmpty, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			BackgroundColor3 = t7.HideEmpty and Color3.fromRGB(0, 160, 120) or Color3.fromRGB(30, 34, 42)
		}):Play()

        local v381 = TweenService
        local ToggleHideEmptyText = t7.ToggleHideEmptyText
        local tweenInfo = TweenInfo.new(0.18)
        local v384 = t7.HideEmpty and Color3.fromRGB(255, 255, 255)

        if not v384 then
            v384 = Color3.fromRGB(175, 185, 195)
        end

        v381:Create(ToggleHideEmptyText, tweenInfo, {
			TextColor3 = v384
		}):Play()
    end)
    t7.Scroll = Instance.new("ScrollingFrame")
    t7.Scroll.Size = UDim2.new(1, -20, 1, -134)
    t7.Scroll.Position = UDim2.new(0, 10, 0, 124)
    t7.Scroll.BackgroundTransparency = 1
    t7.Scroll.BorderSizePixel = 0
    t7.Scroll.ScrollBarThickness = 4
    t7.Scroll.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 200)
    t7.Scroll.ScrollBarImageTransparency = 0.2
    t7.Scroll.ScrollingDirection = Enum.ScrollingDirection.Y
    t7.Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    t7.Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    t7.Scroll.ClipsDescendants = true
    t7.Scroll.Parent = t7.Window
    local UIPadding5 = Instance.new("UIPadding")
    UIPadding5.PaddingTop = UDim.new(0, 2)
    UIPadding5.PaddingBottom = UDim.new(0, 4)
    UIPadding5.PaddingLeft = UDim.new(0, 2)
    UIPadding5.PaddingRight = UDim.new(0, 2)
    UIPadding5.Parent = t7.Scroll
    local UIListLayout6 = Instance.new("UIListLayout")
    UIListLayout6.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout6.Padding = UDim.new(0, 6)
    UIListLayout6.Parent = t7.Scroll
    t7.StatusLabel = Instance.new("TextLabel")
    t7.StatusLabel.Size = UDim2.new(1, -12, 0, 50)
    t7.StatusLabel.BackgroundTransparency = 1
    t7.StatusLabel.Text = "Loading servers..."
    t7.StatusLabel.TextColor3 = Color3.fromRGB(160, 170, 185)
    t7.StatusLabel.Font = Enum.Font.SourceSansSemibold
    t7.StatusLabel.TextSize = 14
    t7.StatusLabel.Parent = t7.Scroll
    local function v267()
        for _, child in ipairs(t7.Scroll:GetChildren()) do
            if child:IsA("Frame") then
                child:Destroy()
            end
        end

        local t9 = {}

        for _, v in ipairs(t7.RawServers) do
            local v390 = v.maxPlayers or 0
            local playing = v.playing
            local v392 = t7
            local v393 = playing or 0
            local v394 = true

            if v392.HideFull and v390 <= v393 then
                v394 = false
            end

            if t7.HideEmpty and v393 <= 0 then
                v394 = false
            end

            if v394 then
                table.insert(t9, v)
            end
        end

        if t7.CurrentSort == "lowest" then
            table.sort(t9, function(p19, p20)
                return (p19.playing or 0) < (p20.playing or 0)
            end)
        elseif t7.CurrentSort == "highest" then
            table.sort(t9, function(p21, p22)
                return (p21.playing or 0) > (p22.playing or 0)
            end)
        elseif t7.CurrentSort == "ping" then
            table.sort(t9, function(p23, p24)
                return (p23.ping or 999) < (p24.ping or 999)
            end)
        end

        if #t9 == 0 then
            t7.StatusLabel.Text = "No servers found matching filters"
            t7.StatusLabel.Visible = true

            return
        end

        t7.StatusLabel.Visible = false

        local JobId = game.JobId

        for i, v in ipairs(t9) do
            local v398 = v
            local v399 = JobId == v398.id
            local v400 = v399 and Color3.fromRGB(22, 34, 38)

            if not v400 then
                v400 = Color3.fromRGB(24, 27, 33)
            end

            local v401 = v400
            local v402 = v399 and Color3.fromRGB(28, 44, 50)

            if not v402 then
                v402 = Color3.fromRGB(32, 36, 44)
            end

            local v403 = v402
            local Frame25 = Instance.new("Frame")

            Frame25.Size = UDim2.new(1, -12, 0, 46)
            Frame25.BackgroundColor3 = v401
            Frame25.BackgroundTransparency = 0.12
            Frame25.BorderSizePixel = 0
            Frame25.LayoutOrder = i
            Frame25.ClipsDescendants = true
            Frame25.Parent = t7.Scroll

            local UICorner18 = Instance.new("UICorner")

            UICorner18.CornerRadius = UDim.new(0, 6)
            UICorner18.Parent = Frame25

            local UIStroke5 = Instance.new("UIStroke")

            UIStroke5.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            UIStroke5.Color = v399 and Color3.fromRGB(0, 255, 200) or Color3.fromRGB(46, 52, 64)
            UIStroke5.Transparency = v399 and 0.1 or 0.3
            UIStroke5.Thickness = 1
            UIStroke5.Parent = Frame25

            local TextLabel12 = Instance.new("TextLabel")

            TextLabel12.Size = UDim2.new(1, -95, 1, 0)
            TextLabel12.Position = UDim2.new(0, 10, 0, 0)
            TextLabel12.BackgroundTransparency = 1
            TextLabel12.TextColor3 = Color3.fromRGB(225, 230, 235)
            TextLabel12.Font = Enum.Font.SourceSansSemibold
            TextLabel12.TextSize = 13
            TextLabel12.TextXAlignment = Enum.TextXAlignment.Left
            TextLabel12.RichText = true

            local v408 = v398.ping and tostring(v398.ping) .. " ms" or "N/A"
            local format = string.format
            local playing = v398.playing
            local v411 = v398.maxPlayers or 0

            TextLabel12.Text = format("Players: <b>%d/%d</b> | Ping: <b>%s</b>", playing or 0, v411, v408)
            TextLabel12.Parent = Frame25

            local v412 = v399

            if v412 then
                v412 = Color3.fromRGB(36, 44, 52)
            end

            if not v412 then
                v412 = Color3.fromRGB(0, 160, 120)
            end

            local v413 = v412
            local v414 = v399

            if v414 then
                v414 = Color3.fromRGB(48, 58, 68)
            end

            if not v414 then
                v414 = Color3.fromRGB(0, 195, 145)
            end

            local v415 = v414
            local Frame26 = Instance.new("Frame")

            Frame26.Size = UDim2.new(0, 68, 0, 28)
            Frame26.Position = UDim2.new(1, -76, 0.5, -14)
            Frame26.BackgroundColor3 = v413
            Frame26.BackgroundTransparency = 0.1
            Frame26.BorderSizePixel = 0
            Frame26.Active = true
            Frame26.Parent = Frame25

            local UICorner19 = Instance.new("UICorner")

            UICorner19.CornerRadius = UDim.new(0, 5)
            UICorner19.Parent = Frame26

            local TextLabel13 = Instance.new("TextLabel")

            TextLabel13.Size = UDim2.fromScale(1, 1)
            TextLabel13.BackgroundTransparency = 1
            TextLabel13.Text = "Join"

            local v419 = v399

            if v419 then
                v419 = Color3.fromRGB(0, 255, 200)
            end

            if not v419 then
                v419 = Color3.fromRGB(255, 255, 255)
            end

            TextLabel13.TextColor3 = v419
            TextLabel13.Font = Enum.Font.GothamBold
            TextLabel13.TextSize = 12
            TextLabel13.Parent = Frame26
            Frame25.MouseEnter:Connect(function()
                TweenService:Create(Frame25, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					BackgroundColor3 = v403
				}):Play()
            end)
            Frame25.MouseLeave:Connect(function()
                TweenService:Create(Frame25, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					BackgroundColor3 = v401
				}):Play()
            end)
            Frame26.MouseEnter:Connect(function()
                TweenService:Create(Frame26, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					BackgroundColor3 = v415
				}):Play()
            end)
            Frame26.MouseLeave:Connect(function()
                TweenService:Create(Frame26, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					BackgroundColor3 = v413
				}):Play()
            end)
            Frame26.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    local v455 = TweenService
                    local v456 = Frame26
                    local tweenInfo = TweenInfo.new(0.08)
                    local v458 = v399

                    if v458 then
                        v458 = Color3.fromRGB(30, 36, 42)
                    end

                    if not v458 then
                        v458 = Color3.fromRGB(0, 130, 95)
                    end

                    v455:Create(v456, tweenInfo, {
						BackgroundColor3 = v458
					}):Play()
                    TextLabel13.Text = "..."
                    TeleportService:TeleportToPlaceInstance(t7.CachedPlaceId, v398.id, LocalPlayer)
                end
            end)
            Frame26.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    TweenService:Create(Frame26, TweenInfo.new(0.18), {
						BackgroundColor3 = v415
					}):Play()
                end
            end)
        end
    end
    local function v268()
        local timestamp = tick()

        if t7.IsFetching then
            return
        end

        if timestamp - t7.LastRefreshTick < t7.RefreshCooldown then
            local v421 = math.ceil(t7.RefreshCooldown - (timestamp - t7.LastRefreshTick))

            t7.StatusLabel.Text = string.format("Wait %d sec before refreshing...", v421)
            t7.StatusLabel.Visible = true

            return
        end

        t7.LastRefreshTick = timestamp
        t7.IsFetching = true
        t7.BtnRefreshText.Text = "..."
        t7.StatusLabel.Text = "Fetching servers..."
        t7.StatusLabel.Visible = true

        for _, child in ipairs(t7.Scroll:GetChildren()) do
            if child:IsA("Frame") then
                child:Destroy()
            end
        end

        task.spawn(function()
            if not u240 then
                t7.StatusLabel.Text = "HTTP executor request not supported"
                t7.BtnRefreshText.Text = "Refresh"
                t7.IsFetching = false

                return
            end

            local v460 = string.format("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Desc&limit=100", t7.CachedPlaceId)
            local ok, result = pcall(function()
                local v464 = u240({
					Url = v460,
					Method = "GET"
				})

                return HttpService:JSONDecode(v464.Body)
            end)
            local v463 = not ok

            if not v463 then
                v463 = not result or not result.data
            end

            if v463 then
                t7.StatusLabel.Text = "Failed to load servers"
                t7.BtnRefreshText.Text = "Refresh"
                t7.IsFetching = false

                return
            end

            t7.RawServers = result.data
            v267()
            t7.BtnRefreshText.Text = "Refresh"
            t7.IsFetching = false
        end)
    end
    for _, v in ipairs(t8) do
        local v271 = v
        local Frame27 = Instance.new("Frame")

        Frame27.Size = UDim2.new(0, 80, 1, 0)
        Frame27.BackgroundColor3 = v271.Id == t7.CurrentSort and Color3.fromRGB(0, 160, 120) or Color3.fromRGB(30, 34, 42)
        Frame27.BackgroundTransparency = 0.15
        Frame27.BorderSizePixel = 0
        Frame27.Active = true
        Frame27.Parent = Frame24

        local UICorner20 = Instance.new("UICorner")

        UICorner20.CornerRadius = UDim.new(0, 5)
        UICorner20.Parent = Frame27

        local TextLabel14 = Instance.new("TextLabel")

        TextLabel14.Size = UDim2.fromScale(1, 1)
        TextLabel14.BackgroundTransparency = 1
        TextLabel14.Text = v271.Name

        local v275 = v271.Id == t7.CurrentSort and Color3.fromRGB(255, 255, 255)

        if not v275 then
            v275 = Color3.fromRGB(185, 195, 205)
        end

        TextLabel14.TextColor3 = v275
        TextLabel14.Font = Enum.Font.SourceSansSemibold
        TextLabel14.TextSize = 12
        TextLabel14.Parent = Frame27
        Frame27.MouseEnter:Connect(function()
            if t7.CurrentSort ~= v271.Id then
                TweenService:Create(Frame27, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					BackgroundColor3 = Color3.fromRGB(44, 50, 62)
				}):Play()
                TweenService:Create(TextLabel14, TweenInfo.new(0.18), {
					TextColor3 = Color3.fromRGB(255, 255, 255)
				}):Play()
            end
        end)
        Frame27.MouseLeave:Connect(function()
            if t7.CurrentSort ~= v271.Id then
                TweenService:Create(Frame27, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					BackgroundColor3 = Color3.fromRGB(30, 34, 42)
				}):Play()
                TweenService:Create(TextLabel14, TweenInfo.new(0.18), {
					TextColor3 = Color3.fromRGB(185, 195, 205)
				}):Play()
            end
        end)
        t7.SortButtons[v271.Id] = {
			Frame = Frame27,
			Label = TextLabel14
		}
        Frame27.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                t7.CurrentSort = v271.Id

                for k, v3 in pairs(t7.SortButtons) do
                    local v427 = k == t7.CurrentSort
                    local v428 = TweenService
                    local Frame28 = v3.Frame
                    local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                    local v431 = v427

                    if v427 then
                        v431 = Color3.fromRGB(0, 160, 120)
                    end

                    if not v431 then
                        v431 = Color3.fromRGB(30, 34, 42)
                    end

                    v428:Create(Frame28, tweenInfo, {
						BackgroundColor3 = v431
					}):Play()

                    local v432 = TweenService
                    local v3Label = v3.Label
                    local tweenInfo3 = TweenInfo.new(0.2)

                    if v427 then
                        v427 = Color3.fromRGB(255, 255, 255)
                    end

                    if not v427 then
                        v427 = Color3.fromRGB(185, 195, 205)
                    end

                    v432:Create(v3Label, tweenInfo3, {
						TextColor3 = v427
					}):Play()
                end

                v267()
            end
        end)
    end
    t7.ToggleHideFull.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            t7.HideFull = not t7.HideFull
            t7.ToggleHideFullText.Text = "Hide Full: " .. (not t7.HideFull and "OFF" or "ON")
            TweenService:Create(t7.ToggleHideFull, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				BackgroundColor3 = t7.HideFull and Color3.fromRGB(0, 160, 120) or Color3.fromRGB(30, 34, 42)
			}):Play()

            local v436 = TweenService
            local ToggleHideFullText = t7.ToggleHideFullText
            local tweenInfo = TweenInfo.new(0.2)
            local v439 = t7.HideFull and Color3.fromRGB(255, 255, 255)

            if not v439 then
                v439 = Color3.fromRGB(175, 185, 195)
            end

            v436:Create(ToggleHideFullText, tweenInfo, {
				TextColor3 = v439
			}):Play()
            v267()
        end
    end)
    t7.ToggleHideEmpty.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            t7.HideEmpty = not t7.HideEmpty
            t7.ToggleHideEmptyText.Text = "Hide Empty: " .. (not t7.HideEmpty and "OFF" or "ON")
            TweenService:Create(t7.ToggleHideEmpty, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				BackgroundColor3 = t7.HideEmpty and Color3.fromRGB(0, 160, 120) or Color3.fromRGB(30, 34, 42)
			}):Play()

            local v441 = TweenService
            local ToggleHideEmptyText = t7.ToggleHideEmptyText
            local tweenInfo = TweenInfo.new(0.2)
            local v444 = t7.HideEmpty and Color3.fromRGB(255, 255, 255)

            if not v444 then
                v444 = Color3.fromRGB(175, 185, 195)
            end

            v441:Create(ToggleHideEmptyText, tweenInfo, {
				TextColor3 = v444
			}):Play()
            v267()
        end
    end)
    t7.BtnRefresh.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            TweenService:Create(t7.BtnRefresh, TweenInfo.new(0.08), {
				BackgroundColor3 = Color3.fromRGB(24, 28, 36)
			}):Play()
            v268()
        end
    end)
    t7.BtnRefresh.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            TweenService:Create(t7.BtnRefresh, TweenInfo.new(0.18), {
				BackgroundColor3 = Color3.fromRGB(48, 56, 70)
			}):Play()
        end
    end)
    v268()
end)
v49("Rejoin Server", function()
    local v276 = syn and syn.request

    if not v276 then
        v276 = http

        if v276 then
            v276 = http.request
        end

        if not v276 then
            v276 = http_request or request
        end
    end

    local v277 = v276

    if v277 then
        local ok, result = pcall(function()
            return v277({
				Url = "https://games.roblox.com/v1/games?universeIds=" .. tostring(game.GameId),
				Method = "GET"
			})
        end)
        if ok then
            ok = result and result.StatusCode == 200
        end
        if ok then
            local data = HttpService:JSONDecode(result.Body)
            local v281 = data

            if data then
                v281 = data.data

                if v281 then
                    v281 = data.data[1] and data.data[1].rootPlaceId
                end
            end

            if v281 then
                TeleportService:Teleport(data.data[1].rootPlaceId, LocalPlayer)

                return
            end
        end
    end
end)
v45()
local function v75(p25)
    if setclipboard then
        setclipboard(p25)

        return
    end

    if toclipboard then
        toclipboard(p25)
    end
end
local function v76(p26)
    n2 += 1

    local Frame29 = Instance.new("Frame")

    Frame29.Size = UDim2.new(1, 0, 0, 52)
    Frame29.BackgroundColor3 = Color3.fromRGB(20, 22, 24)
    Frame29.BorderSizePixel = 0
    Frame29.LayoutOrder = n2
    Frame29.Parent = if not u41 then u38 and u38.content or nil else u41

    local UICorner21 = Instance.new("UICorner")

    UICorner21.CornerRadius = UDim.new(0, 8)
    UICorner21.Parent = Frame29

    local UIStroke6 = Instance.new("UIStroke")

    UIStroke6.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke6.Color = Color3.fromRGB(42, 45, 50)
    UIStroke6.Thickness = 1.2
    UIStroke6.Parent = Frame29

    local ImageLabel2 = Instance.new("ImageLabel")

    ImageLabel2.Size = UDim2.new(0, 24, 0, 24)
    ImageLabel2.Position = UDim2.new(0, 14, 0.5, -12)
    ImageLabel2.BackgroundTransparency = 1
    ImageLabel2.Image = p26.Icon
    ImageLabel2.ImageColor3 = p26.AccentColor
    ImageLabel2.Parent = Frame29

    local Frame30 = Instance.new("Frame")

    Frame30.Size = UDim2.new(1, -150, 1, 0)
    Frame30.Position = UDim2.new(0, 48, 0, 0)
    Frame30.BackgroundTransparency = 1
    Frame30.Parent = Frame29

    local TextLabel15 = Instance.new("TextLabel")

    TextLabel15.Size = UDim2.new(1, 0, 0, 18)
    TextLabel15.Position = UDim2.new(0, 0, 0, 9)
    TextLabel15.BackgroundTransparency = 1
    TextLabel15.Text = p26.Title
    TextLabel15.TextColor3 = Color3.fromRGB(240, 240, 240)
    TextLabel15.Font = Enum.Font.GothamBold
    TextLabel15.TextSize = 14
    TextLabel15.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel15.Parent = Frame30

    local TextLabel16 = Instance.new("TextLabel")

    TextLabel16.Size = UDim2.new(1, 0, 0, 14)
    TextLabel16.Position = UDim2.new(0, 0, 0, 27)
    TextLabel16.BackgroundTransparency = 1
    TextLabel16.Text = p26.Subtitle
    TextLabel16.TextColor3 = Color3.fromRGB(130, 135, 145)
    TextLabel16.Font = Enum.Font.SourceSans
    TextLabel16.TextSize = 13
    TextLabel16.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel16.Parent = Frame30

    local Frame31 = Instance.new("Frame")

    Frame31.Size = UDim2.new(0, 74, 0, 28)
    Frame31.Position = UDim2.new(1, -84, 0.5, -14)
    Frame31.BackgroundColor3 = Color3.fromRGB(30, 33, 38)
    Frame31.BorderSizePixel = 0
    Frame31.Parent = Frame29

    local UICorner22 = Instance.new("UICorner")

    UICorner22.CornerRadius = UDim.new(0, 6)
    UICorner22.Parent = Frame31

    local UIStroke7 = Instance.new("UIStroke")

    UIStroke7.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke7.Color = Color3.fromRGB(50, 54, 62)
    UIStroke7.Thickness = 1
    UIStroke7.Parent = Frame31

    local TextLabel17 = Instance.new("TextLabel")

    TextLabel17.Size = UDim2.fromScale(1, 1)
    TextLabel17.BackgroundTransparency = 1
    TextLabel17.Text = p26.ActionText
    TextLabel17.TextColor3 = p26.AccentColor
    TextLabel17.Font = Enum.Font.GothamBold
    TextLabel17.TextSize = 12
    TextLabel17.Parent = Frame31

    local TextButton4 = Instance.new("TextButton")

    TextButton4.Size = UDim2.fromScale(1, 1)
    TextButton4.BackgroundTransparency = 1
    TextButton4.Text = ""
    TextButton4.Parent = Frame29

    local u296 = false

    TextButton4.MouseEnter:Connect(function()
        TweenService:Create(Frame29, TweenInfo.new(0.2), {
			BackgroundColor3 = Color3.fromRGB(26, 29, 33)
		}):Play()
        TweenService:Create(UIStroke6, TweenInfo.new(0.2), {
			Color = p26.AccentColor
		}):Play()
        TweenService:Create(Frame31, TweenInfo.new(0.2), {
			BackgroundColor3 = p26.AccentColor
		}):Play()
        TweenService:Create(TextLabel17, TweenInfo.new(0.2), {
			TextColor3 = Color3.fromRGB(255, 255, 255)
		}):Play()
    end)
    TextButton4.MouseLeave:Connect(function()
        TweenService:Create(Frame29, TweenInfo.new(0.2), {
			BackgroundColor3 = Color3.fromRGB(20, 22, 24)
		}):Play()
        TweenService:Create(UIStroke6, TweenInfo.new(0.2), {
			Color = Color3.fromRGB(42, 45, 50)
		}):Play()
        TweenService:Create(Frame31, TweenInfo.new(0.2), {
			BackgroundColor3 = Color3.fromRGB(30, 33, 38)
		}):Play()
        TweenService:Create(TextLabel17, TweenInfo.new(0.2), {
			TextColor3 = p26.AccentColor
		}):Play()
    end)
    TextButton4.Activated:Connect(function()
        if p26.Callback then
            p26.Callback()
        end

        if not u296 then
            u296 = true
            TextLabel17.Text = "Copied"
            task.delay(1.5, function()
                TextLabel17.Text = p26.ActionText
                u296 = false
            end)
        end
    end)

    return Frame29
end
local color3 = Color3.fromRGB(88, 101, 242)
v76({
	Title = "Discord Server",
	Subtitle = "Updates & Support",
	ActionText = "Copy Link",
	AccentColor = color3,
	Icon = "rbxassetid://86312085123783",
	Callback = function()
    v75("https://discord.gg/behjGQhNFX")
end
})
local color3_2 = Color3.fromRGB(255, 75, 75)
v76({
	Title = "YouTube Channel",
	Subtitle = "Videos & Showcases",
	ActionText = "Copy Link",
	AccentColor = color3_2,
	Icon = "rbxassetid://99775080325014",
	Callback = function()
    v75("https://www.youtube.com/@Sosiskomras/videos")
end
})
local _getgenv = getgenv
if _getgenv then
    _getgenv = getgenv()
end
if not _getgenv then
    _getgenv = _G or shared
end
_getgenv.STK_UI = {
	ScreenGui = ScreenGui,
	mainFrame = Frame,
	headerHideButton = Frame4,
	sidebarHeaderText = TextLabel2,
	CreateSidebarButton = v48,
	CreateTab = v39,
	ShowTab = v40,
	CreateBlock = v44,
	EndBlock = v45,
	CreateHeader = function(p27)
    n2 += 1

    local TextLabel18 = Instance.new("TextLabel")

    TextLabel18.Size = UDim2.new(1, 0, 0, 20)
    TextLabel18.BackgroundTransparency = 1
    TextLabel18.Text = p27
    TextLabel18.TextColor3 = Color3.fromRGB(0, 255, 200)
    TextLabel18.Font = Enum.Font.SourceSansBold
    TextLabel18.TextSize = 18
    TextLabel18.TextXAlignment = Enum.TextXAlignment.Center
    TextLabel18.LayoutOrder = n2
    TextLabel18.Parent = if not u41 then u38 and u38.content or nil else u41

    return TextLabel18
end,
	CreateButton = v49,
	CreateToggle = v50,
	CreateSlider = function(p28)
    n2 += 1

    if not p28 then
        p28 = {}
    end

    local v211 = p28.Text or "Slider"
    local v212 = p28.Min or 0
    local v213 = p28.Max or 100
    local v214 = p28.Default or v212
    local v215 = p28.Decimals or 1
    local v216 = p28.Suffix or ""
    local v217 = p28.Callback or function()
    end
    local u218 = math.clamp(v214, v212, v213)
    local u219 = false
    local Frame32 = Instance.new("Frame")

    Frame32.Size = UDim2.new(1, 0, 0, 90)
    Frame32.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Frame32.BorderSizePixel = 0
    Frame32.LayoutOrder = n2
    Frame32.Parent = if not u41 then u38 and u38.content or nil else u41

    local UICorner23 = Instance.new("UICorner")

    UICorner23.CornerRadius = UDim.new(0, 6)
    UICorner23.Parent = Frame32

    local UIStroke8 = Instance.new("UIStroke")

    UIStroke8.Color = Color3.fromRGB(153, 66, 66)
    UIStroke8.Thickness = 2
    UIStroke8.Parent = Frame32

    local TextLabel19 = Instance.new("TextLabel")

    TextLabel19.Size = UDim2.new(1, -10, 0, 20)
    TextLabel19.Position = UDim2.new(0, 5, 0, 5)
    TextLabel19.BackgroundTransparency = 1
    TextLabel19.Text = v211 .. ": " .. u218 .. v216
    TextLabel19.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextLabel19.Font = Enum.Font.SourceSansSemibold
    TextLabel19.TextSize = 18
    TextLabel19.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel19.Parent = Frame32

    local Frame33 = Instance.new("Frame")

    Frame33.Size = UDim2.new(1, -10, 0, 14)
    Frame33.Position = UDim2.new(0, 5, 0, 35)
    Frame33.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    Frame33.BorderSizePixel = 0
    Frame33.Parent = Frame32

    local UICorner24 = Instance.new("UICorner")

    UICorner24.CornerRadius = UDim.new(1, 0)
    UICorner24.Parent = Frame33

    local Frame34 = Instance.new("Frame")

    Frame34.Size = UDim2.new((u218 - v212) / (v213 - v212), 0, 1, 0)
    Frame34.BackgroundColor3 = Color3.fromRGB(153, 66, 66)
    Frame34.BorderSizePixel = 0
    Frame34.Parent = Frame33

    local UICorner25 = Instance.new("UICorner")

    UICorner25.CornerRadius = UDim.new(1, 0)
    UICorner25.Parent = Frame34

    local TextBox = Instance.new("TextBox")

    TextBox.Size = UDim2.new(0, 60, 0, 20)
    TextBox.Position = UDim2.new(0.5, -30, 0, Frame33.Position.Y.Offset + Frame33.Size.Y.Offset + 5)
    TextBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextBox.Font = Enum.Font.SourceSansSemibold
    TextBox.TextSize = 14
    TextBox.Text = tostring(u218)
    TextBox.ClearTextOnFocus = false
    TextBox.Parent = Frame32

    local function v229(p29)
        u218 = math.floor(math.clamp(p29, v212, v213) * v215) / v215
        Frame34.Size = UDim2.new((u218 - v212) / (v213 - v212), 0, 1, 0)
        TextLabel19.Text = v211 .. ": " .. u218 .. v216
        TextBox.Text = tostring(u218)
        v217(u218)
    end

    TextBox.FocusLost:Connect(function()
        local num = tonumber(TextBox.Text)

        if num then
            v229(num)

            return
        end

        TextBox.Text = tostring(u218)
    end)
    Frame33.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            u219 = true

            local v353 = math.clamp((input.Position.X - Frame33.AbsolutePosition.X) / Frame33.AbsoluteSize.X, 0, 1)

            v229(v212 + (v213 - v212) * v353)
        end
    end)
    Frame33.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            u219 = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        local v356 = u219

        if v356 then
            v356 = input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch
        end

        if v356 then
            local v357 = math.clamp((input.Position.X - Frame33.AbsolutePosition.X) / Frame33.AbsoluteSize.X, 0, 1)

            v229(v212 + (v213 - v212) * v357)
        end
    end)

    local t10 = {
			Get = function(_)
        return u218
    end
		}

    v229(u218)

    return t10
end,
	CreateDropdown = function(p31)
    n2 += 1
    local u179 = p31 or {}
    local Text = u179.Text
    local v181 = u179
    local v182 = Text or "Dropdown"
    local u183 = v181.List or {}
    local Default = u179.Default
    local v185 = u179.Callback or function()
    end
    local v186 = u179.Multi or false
    local v187 = u179.ChangeText ~= false
    local u188 = false
    local u189
    local t11 = {}
    local Frame35 = Instance.new("Frame")
    Frame35.Size = UDim2.new(1, 0, 0, 34)
    Frame35.BackgroundTransparency = 1
    Frame35.ClipsDescendants = true
    Frame35.LayoutOrder = n2
    Frame35.Parent = if not u41 then u38 and u38.content or nil else u41
    local Frame36 = Instance.new("Frame")
    Frame36.Size = UDim2.new(1, 0, 0, 34)
    Frame36.BackgroundColor3 = Color3.fromRGB(45, 47, 53)
    Frame36.BorderSizePixel = 0
    Frame36.Parent = Frame35
    local UICorner26 = Instance.new("UICorner")
    UICorner26.CornerRadius = UDim.new(0, 8)
    UICorner26.Parent = Frame36
    local TextLabel20 = Instance.new("TextLabel")
    TextLabel20.Size = UDim2.new(1, -20, 0, 34)
    TextLabel20.Position = UDim2.new(0, 12, 0, 0)
    TextLabel20.BackgroundTransparency = 1
    TextLabel20.Text = v182
    TextLabel20.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextLabel20.Font = Enum.Font.SourceSansSemibold
    TextLabel20.TextSize = 18
    TextLabel20.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel20.Parent = Frame36
    local TextLabel21 = Instance.new("TextLabel")
    TextLabel21.Size = UDim2.new(1, -20, 0, 34)
    TextLabel21.Position = UDim2.new(0, 12, 0, 0)
    TextLabel21.BackgroundTransparency = 1
    TextLabel21.Text = ""
    TextLabel21.TextColor3 = Color3.fromRGB(180, 180, 180)
    TextLabel21.Font = Enum.Font.SourceSansSemibold
    TextLabel21.TextSize = 16
    TextLabel21.TextXAlignment = Enum.TextXAlignment.Right
    TextLabel21.Parent = Frame36
    local TextButton5 = Instance.new("TextButton")
    TextButton5.Size = UDim2.new(1, 0, 0, 34)
    TextButton5.BackgroundTransparency = 1
    TextButton5.Text = ""
    TextButton5.Parent = Frame36
    local Frame37 = Instance.new("Frame")
    Frame37.Size = UDim2.new(1, 0, 0, 0)
    Frame37.Position = UDim2.new(0, 0, 0, 34)
    Frame37.BackgroundTransparency = 0
    Frame37.BackgroundColor3 = Color3.fromRGB(22, 23, 26)
    Frame37.ClipsDescendants = true
    Frame37.Parent = Frame36
    local UIListLayout7 = Instance.new("UIListLayout")
    UIListLayout7.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout7.Padding = UDim.new(0, 4)
    UIListLayout7.Parent = Frame37
    local UIPadding6 = Instance.new("UIPadding")
    UIPadding6.PaddingLeft = UDim.new(0, 8)
    UIPadding6.PaddingRight = UDim.new(0, 8)
    UIPadding6.PaddingTop = UDim.new(0, 6)
    UIPadding6.PaddingBottom = UDim.new(0, 6)
    UIPadding6.Parent = Frame37
    local t12 = {}
    local function v201(p32)
        u188 = p32

        local v327 = #u183 * 32 + 12
        local v328 = u188 and 34 + v327 or 34

        TweenService:Create(Frame35, TweenInfo.new(0.2), {
				Size = UDim2.new(1, 0, 0, v328)
			}):Play()
        TweenService:Create(Frame37, TweenInfo.new(0.2), {
				Size = UDim2.new(1, 0, 0, u188 and v327 or 0)
			}):Play()
    end
    local function v202()
        if v186 then
            if #t11 == 0 then
                TextLabel21.Text = u179.Placeholder or "Select"
                TextLabel21.TextColor3 = Color3.fromRGB(180, 180, 180)

                return
            end

            TextLabel21.Text = string.format("%d selected", #t11)
            TextLabel21.TextColor3 = Color3.fromRGB(255, 255, 255)

            return
        end

        if u189 and u189 ~= "" then
            TextLabel21.Text = tostring(u189)
            TextLabel21.TextColor3 = Color3.fromRGB(255, 255, 255)

            return
        end

        TextLabel21.Text = u179.Placeholder or "Select"
        TextLabel21.TextColor3 = Color3.fromRGB(180, 180, 180)
    end
    local function v203(p33, p34)
        local v331 = v186

        if v331 then
            v331 = table.find(t11, p34)
        end

        if v331 or p34 == u189 then
            p33.BackgroundColor3 = Color3.fromRGB(153, 66, 66)

            return
        end

        p33.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    end
    local function v204(p35)
        if v186 then
            local v333 = table.find(t11, p35)

            if v333 then
                table.remove(t11, v333)
            else
                table.insert(t11, p35)
            end

            if v187 then
                v202()
            end

            v185(table.clone(t11))
        else
            u189 = p35

            if v187 then
                v202()
            end

            v185(p35)
            v201(false)
        end

        for _, v in pairs(t12) do
            v203(v.frame, v.text)
        end
    end
    local function v205(p36)
        local Frame38 = Instance.new("Frame")

        Frame38.Size = UDim2.new(1, 0, 0, 28)
        Frame38.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        Frame38.BorderSizePixel = 0
        Frame38.Parent = Frame37

        local UICorner27 = Instance.new("UICorner")

        UICorner27.CornerRadius = UDim.new(0, 6)
        UICorner27.Parent = Frame38

        local TextLabel22 = Instance.new("TextLabel")

        TextLabel22.Size = UDim2.new(1, -10, 1, 0)
        TextLabel22.Position = UDim2.new(0, 10, 0, 0)
        TextLabel22.BackgroundTransparency = 1
        TextLabel22.Text = p36
        TextLabel22.TextColor3 = Color3.fromRGB(255, 255, 255)
        TextLabel22.Font = Enum.Font.SourceSansSemibold
        TextLabel22.TextSize = 16
        TextLabel22.TextXAlignment = Enum.TextXAlignment.Left
        TextLabel22.Parent = Frame38

        local TextButton6 = Instance.new("TextButton")

        TextButton6.Size = UDim2.new(1, 0, 1, 0)
        TextButton6.BackgroundTransparency = 1
        TextButton6.Text = ""
        TextButton6.Parent = Frame38
        TextButton6.MouseEnter:Connect(function()
            local v447 = v186

            if v447 then
                v447 = table.find(t11, p36)
            end

            if not v447 then
                v447 = u189 == p36
            end

            if not v447 then
                Frame38.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
            end
        end)
        TextButton6.MouseLeave:Connect(function()
            v203(Frame38, p36)
        end)
        TextButton6.MouseButton1Click:Connect(function()
            v204(p36)
        end)
        table.insert(t12, {
				frame = Frame38,
				text = p36
			})
        v203(Frame38, p36)
    end
    for _, v in ipairs(u183) do
        v205(v)
    end
    if Default ~= nil then
        if v186 then
            t11 = if typeof(Default) ~= "table" then { Default } else table.clone(Default)
        else
            u189 = Default
        end

        v202()

        for _, v in pairs(t12) do
            v203(v.frame, v.text)
        end

        v185(v186 and table.clone(t11) or u189)
    else
        v202()
    end
    TextButton5.MouseButton1Click:Connect(function()
        v201(not u188)
    end)

    return {
			Get = function(_)
        return v186 and table.clone(t11) or u189
    end,
			Clear = function(_)
        t11 = {}
        u189 = nil
        u183 = {}
        u188 = false

        for _, v in pairs(t12) do
            v.frame:Destroy()
        end

        t12 = {}
        v202()
        Frame35.Size = UDim2.new(1, 0, 0, 34)
        Frame37.Size = UDim2.new(1, 0, 0, 0)
    end,
			Add = function(_, p40)
        for _, v in ipairs(p40) do
            table.insert(u183, v)
            v205(v)
        end

        local v349 = #u183 * 32 + 12

        if u188 then
            Frame35.Size = UDim2.new(1, 0, 0, v349 + 34)
            Frame37.Size = UDim2.new(1, 0, 0, v349)
        end
    end
		}
end,
	CreateColorPicker = function(p41)
    n2 += 1

    if not p41 then
        p41 = {}
    end

    local v122 = p41.Text or "Color Picker"
    local v123 = p41.Callback or function()
    end
    local color3_3 = Color3.fromRGB(0, 255, 200)
    local v125, v126, v127 = color3_3:ToHSV()
    local u128 = v125
    local u129 = v126
    local u130 = v127
    local u131 = false
    local u132 = false
    local Frame39 = Instance.new("Frame")

    Frame39.Size = UDim2.new(1, 0, 0, 34)
    Frame39.BackgroundTransparency = 1
    Frame39.ClipsDescendants = true
    Frame39.LayoutOrder = n2
    Frame39.Parent = if not u41 then u38 and u38.content or nil else u41

    local Frame40 = Instance.new("Frame")

    Frame40.Size = UDim2.new(1, 0, 0, 34)
    Frame40.BackgroundColor3 = Color3.fromRGB(45, 47, 53)
    Frame40.BorderSizePixel = 0
    Frame40.Parent = Frame39

    local UICorner28 = Instance.new("UICorner")

    UICorner28.CornerRadius = UDim.new(0, 8)
    UICorner28.Parent = Frame40

    local TextLabel23 = Instance.new("TextLabel")

    TextLabel23.Size = UDim2.new(1, -100, 0, 34)
    TextLabel23.Position = UDim2.new(0, 12, 0, 0)
    TextLabel23.BackgroundTransparency = 1
    TextLabel23.Text = v122
    TextLabel23.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextLabel23.Font = Enum.Font.SourceSansSemibold
    TextLabel23.TextSize = 18
    TextLabel23.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel23.Parent = Frame40

    local Frame41 = Instance.new("Frame")

    Frame41.Size = UDim2.new(0, 22, 0, 22)
    Frame41.Position = UDim2.new(1, -30, 0.5, -11)
    Frame41.BackgroundColor3 = color3_3
    Frame41.BorderSizePixel = 0
    Frame41.Parent = Frame40

    local UICorner29 = Instance.new("UICorner")

    UICorner29.CornerRadius = UDim.new(0, 4)
    UICorner29.Parent = Frame41

    local TextLabel24 = Instance.new("TextLabel")

    TextLabel24.Size = UDim2.new(0, 60, 0, 22)
    TextLabel24.Position = UDim2.new(1, -95, 0.5, -11)
    TextLabel24.BackgroundColor3 = Color3.fromRGB(25, 27, 30)
    TextLabel24.TextColor3 = Color3.fromRGB(180, 180, 180)
    TextLabel24.Font = Enum.Font.SourceSansSemibold

    local ToHex = color3_3.ToHex

    TextLabel24.TextSize = 14
    TextLabel24.Text = "#" .. ToHex(color3_3):upper()
    TextLabel24.Parent = Frame40

    local UICorner30 = Instance.new("UICorner")

    UICorner30.CornerRadius = UDim.new(0, 4)
    UICorner30.Parent = TextLabel24

    local TextButton7 = Instance.new("TextButton")

    TextButton7.Size = UDim2.new(1, 0, 1, 0)
    TextButton7.BackgroundTransparency = 1
    TextButton7.Text = ""
    TextButton7.Parent = Frame40

    local Frame42 = Instance.new("Frame")

    Frame42.Size = UDim2.new(1, 0, 0, 42)
    Frame42.Position = UDim2.new(0, 0, 0, 38)
    Frame42.BackgroundTransparency = 1
    Frame42.ClipsDescendants = true
    Frame42.Parent = Frame39

    local Frame43 = Instance.new("Frame")

    Frame43.Size = UDim2.new(1, -20, 0, 20)
    Frame43.Position = UDim2.new(0, 10, 0, 10)
    Frame43.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Frame43.BorderSizePixel = 0
    Frame43.Parent = Frame42

    local UICorner31 = Instance.new("UICorner")

    UICorner31.CornerRadius = UDim.new(0, 4)
    UICorner31.Parent = Frame43

    local UIGradient = Instance.new("UIGradient")

    UIGradient.Rotation = 0
    UIGradient.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
			ColorSequenceKeypoint.new(0.167, Color3.fromRGB(255, 255, 0)),
			ColorSequenceKeypoint.new(0.333, Color3.fromRGB(0, 255, 0)),
			ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
			ColorSequenceKeypoint.new(0.667, Color3.fromRGB(0, 0, 255)),
			ColorSequenceKeypoint.new(0.833, Color3.fromRGB(255, 0, 255)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
		})
    UIGradient.Parent = Frame43

    local Frame44 = Instance.new("Frame")

    Frame44.Size = UDim2.new(0, 10, 1, 4)
    Frame44.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame44.Position = UDim2.new(u128, 0, 0.5, 0)
    Frame44.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Frame44.Parent = Frame43

    local UICorner32 = Instance.new("UICorner")

    UICorner32.CornerRadius = UDim.new(0, 2)
    UICorner32.Parent = Frame44

    local UIStroke9 = Instance.new("UIStroke")

    UIStroke9.Color = Color3.fromRGB(0, 0, 0)
    UIStroke9.Thickness = 1
    UIStroke9.Parent = Frame44

    local function v150()
        local color3_4 = Color3.fromHSV(u128, u129, u130)

        Frame41.BackgroundColor3 = color3_4
        Frame44.Position = UDim2.new(u128, 0, 0.5, 0)
        TextLabel24.Text = "#" .. color3_4:ToHex():upper()
        v123(color3_4)
    end

    TextButton7.MouseButton1Click:Connect(function()
        u131 = not u131

        local v309 = u131

        if v309 then
            v309 = 80
        end

        if not v309 then
            v309 = 34
        end

        TweenService:Create(Frame39, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
				Size = UDim2.new(1, 0, 0, v309)
			}):Play()
    end)
    Frame43.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            u132 = true
            u128 = math.clamp(math.clamp((input.Position.X - Frame43.AbsolutePosition.X) / Frame43.AbsoluteSize.X, 0, 1), 0, 1)
            u129 = 1
            u130 = 1
            v150()
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            u132 = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        local v315 = input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch

        if v315 then
            v315 = u132
        end

        if v315 then
            u128 = math.clamp(math.clamp((input.Position.X - Frame43.AbsolutePosition.X) / Frame43.AbsoluteSize.X, 0, 1), 0, 1)
            u129 = 1
            u130 = 1
            v150()
        end
    end)
    v150()

    return {
			Get = function(_)
        return Color3.fromHSV(u128, u129, u130)
    end,
			Set = function(_, p44)
        local v319, _, _ = p44:ToHSV()

        u128 = math.clamp(v319, 0, 1)
        u129 = 1
        u130 = 1
        v150()
    end
		}
end
}
function _getgenv._ActivateSTKHub()
    ScreenGui.Parent = PlayerGui
end
