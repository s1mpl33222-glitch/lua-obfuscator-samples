-- Source by Daily discord.gg/irsh
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- remove old copy if the script is executed again
local old = PlayerGui:FindFirstChild("ANAS anti bat")
if old then old:Destroy() end

local ANASantibat = Instance.new("ScreenGui")
ANASantibat.Name = "ANAS anti bat"
ANASantibat.ResetOnSpawn = false
ANASantibat.IgnoreGuiInset = true
ANASantibat.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ANASantibat.ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Active = true
Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.BackgroundColor3 = Color3.fromRGB(3, 8, 16)
Main.BackgroundTransparency = 0.079999983310699463
Main.ClipsDescendants = true
Main.Position = UDim2.new(0.5, 0, 0.5, 0)
Main.Size = UDim2.new(0, 250, 0, 210)
Main.Parent = ANASantibat
-- Source by Daily discord.gg/irsh

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 18)
UICorner.Parent = Main

local UIScale = Instance.new("UIScale")
UIScale.Parent = Main

local Backdrop = Instance.new("ImageLabel")
Backdrop.Name = "Backdrop"
Backdrop.BackgroundTransparency = 0
Backdrop.Size = UDim2.new(1, 0, 1, 0)
Backdrop.Size = UDim2.new(1, 0, 1, 0)
Backdrop.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Backdrop.ImageTransparency = 1
Backdrop.ScaleType = Enum.ScaleType.Crop
Backdrop.Parent = Main

local UICorner_2 = Instance.new("UICorner")
UICorner_2.CornerRadius = UDim.new(0, 18)
UICorner_2.Parent = Backdrop

local BlueGlow = Instance.new("Frame")
BlueGlow.Name = "BlueGlow"
BlueGlow.BackgroundColor3 = Color3.fromRGB(0, 90, 180)
BlueGlow.BackgroundTransparency = 0.77999997138977051
BlueGlow.BorderSizePixel = 0
BlueGlow.Size = UDim2.new(1, 0, 1, 0)
BlueGlow.ZIndex = 2
BlueGlow.Parent = Main
-- Source by Daily discord.gg/irsh

local UICorner_3 = Instance.new("UICorner")
UICorner_3.CornerRadius = UDim.new(0, 18)
UICorner_3.Parent = BlueGlow

local UIGradient = Instance.new("UIGradient")
UIGradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 80, 170)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 20, 55)), ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 110, 220))})
UIGradient.Rotation = 90
UIGradient.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.25, 0), NumberSequenceKeypoint.new(0.5, 0.55000001192092896, 0), NumberSequenceKeypoint.new(1, 0.20000000298023224, 0)})
UIGradient.Parent = BlueGlow

local UIStroke = Instance.new("UIStroke")
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke.Color = Color3.fromRGB(0, 170, 255)
UIStroke.Thickness = 2.2000000476837158
UIStroke.Transparency = 0.079999983310699463
UIStroke.Parent = Main

local UIGradient_2 = Instance.new("UIGradient")
UIGradient_2.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 120, 255)), ColorSequenceKeypoint.new(0.2199999988079071, Color3.fromRGB(0, 190, 255)), ColorSequenceKeypoint.new(0.44999998807907104, Color3.fromRGB(90, 220, 255)), ColorSequenceKeypoint.new(0.68000000715255737, Color3.fromRGB(0, 110, 230)), ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 170, 255))})
UIGradient_2.Rotation = 47.776172637939453
UIGradient_2.Parent = UIStroke

local BlueParticles = Instance.new("Frame")
BlueParticles.Name = "BlueParticles"
BlueParticles.BackgroundTransparency = 1
BlueParticles.ClipsDescendants = true
BlueParticles.Size = UDim2.new(1, 0, 1, 0)
BlueParticles.ZIndex = 2
BlueParticles.Parent = Main
-- Source by Daily discord.gg/irsh

local Frame = Instance.new("Frame")
Frame.BackgroundColor3 = Color3.fromRGB(70, 200, 255)
Frame.BackgroundTransparency = 0.75
Frame.Position = UDim2.new(0.54154080152511597, 0, 0.29119324684143066, 0)
Frame.Size = UDim2.new(0, 5, 0, 3)
Frame.ZIndex = 2
Frame.Parent = BlueParticles

local UICorner_4 = Instance.new("UICorner")
UICorner_4.CornerRadius = UDim.new(0, 99)
UICorner_4.Parent = Frame

local Frame_2 = Instance.new("Frame")
Frame_2.BackgroundColor3 = Color3.fromRGB(70, 200, 255)
Frame_2.BackgroundTransparency = 0.75999999046325684
Frame_2.Position = UDim2.new(0.8729863166809082, 0, 0.45499089360237122, 0)
Frame_2.Size = UDim2.new(0, 2, 0, 5)
Frame_2.ZIndex = 2
Frame_2.Parent = BlueParticles

local UICorner_5 = Instance.new("UICorner")
UICorner_5.CornerRadius = UDim.new(0, 99)
UICorner_5.Parent = Frame_2

local Frame_3 = Instance.new("Frame")
Frame_3.BackgroundColor3 = Color3.fromRGB(70, 200, 255)
Frame_3.BackgroundTransparency = 0.56999999284744263
Frame_3.Position = UDim2.new(0.45112070441246033, 0, 0.61733329296112061, 0)
Frame_3.Size = UDim2.new(0, 3, 0, 3)
Frame_3.ZIndex = 2
Frame_3.Parent = BlueParticles
-- Source by Daily discord.gg/irsh

local UICorner_6 = Instance.new("UICorner")
UICorner_6.CornerRadius = UDim.new(0, 99)
UICorner_6.Parent = Frame_3

local Frame_4 = Instance.new("Frame")
Frame_4.BackgroundColor3 = Color3.fromRGB(70, 200, 255)
Frame_4.BackgroundTransparency = 0.56999999284744263
Frame_4.Position = UDim2.new(0.67488080263137817, 0, 0.64670002460479736, 0)
Frame_4.Size = UDim2.new(0, 4, 0, 4)
Frame_4.ZIndex = 2
Frame_4.Parent = BlueParticles

local UICorner_7 = Instance.new("UICorner")
UICorner_7.CornerRadius = UDim.new(0, 99)
UICorner_7.Parent = Frame_4

local Frame_5 = Instance.new("Frame")
Frame_5.BackgroundColor3 = Color3.fromRGB(70, 200, 255)
Frame_5.BackgroundTransparency = 0.68999999761581421
Frame_5.Position = UDim2.new(0.60742747783660889, 0, 0.42797127366065979, 0)
Frame_5.Size = UDim2.new(0, 4, 0, 3)
Frame_5.ZIndex = 2
Frame_5.Parent = BlueParticles

local UICorner_8 = Instance.new("UICorner")
UICorner_8.CornerRadius = UDim.new(0, 99)
UICorner_8.Parent = Frame_5
-- Source by Daily discord.gg/irsh

local Frame_6 = Instance.new("Frame")
Frame_6.BackgroundColor3 = Color3.fromRGB(70, 200, 255)
Frame_6.BackgroundTransparency = 0.75999999046325684
Frame_6.Position = UDim2.new(0.95571994781494141, 0, 0.0039787539280951023, 0)
Frame_6.Size = UDim2.new(0, 2, 0, 3)
Frame_6.ZIndex = 2
Frame_6.Parent = BlueParticles

local UICorner_9 = Instance.new("UICorner")
UICorner_9.CornerRadius = UDim.new(0, 99)
UICorner_9.Parent = Frame_6

local Frame_7 = Instance.new("Frame")
Frame_7.BackgroundColor3 = Color3.fromRGB(70, 200, 255)
Frame_7.BackgroundTransparency = 0.80000001192092896
Frame_7.Position = UDim2.new(0.039143629372119904, 0, 0.035283524543046951, 0)
Frame_7.Size = UDim2.new(0, 4, 0, 2)
Frame_7.ZIndex = 2
Frame_7.Parent = BlueParticles

local UICorner_10 = Instance.new("UICorner")
UICorner_10.CornerRadius = UDim.new(0, 99)
UICorner_10.Parent = Frame_7

local Frame_8 = Instance.new("Frame")
Frame_8.BackgroundColor3 = Color3.fromRGB(70, 200, 255)
Frame_8.BackgroundTransparency = 0.72000002861022949
Frame_8.Position = UDim2.new(0.29729852080345154, 0, 0.71695435047149658, 0)
Frame_8.Size = UDim2.new(0, 2, 0, 5)
Frame_8.ZIndex = 2
Frame_8.Parent = BlueParticles
-- Source by Daily discord.gg/irsh

local UICorner_11 = Instance.new("UICorner")
UICorner_11.CornerRadius = UDim.new(0, 99)
UICorner_11.Parent = Frame_8

local Frame_9 = Instance.new("Frame")
Frame_9.BackgroundColor3 = Color3.fromRGB(70, 200, 255)
Frame_9.BackgroundTransparency = 0.77999997138977051
Frame_9.Position = UDim2.new(0.26959496736526489, 0, 0.34141042828559875, 0)
Frame_9.Size = UDim2.new(0, 4, 0, 2)
Frame_9.ZIndex = 2
Frame_9.Parent = BlueParticles

local UICorner_12 = Instance.new("UICorner")
UICorner_12.CornerRadius = UDim.new(0, 99)
UICorner_12.Parent = Frame_9

local Frame_10 = Instance.new("Frame")
Frame_10.BackgroundColor3 = Color3.fromRGB(70, 200, 255)
Frame_10.BackgroundTransparency = 0.72000002861022949
Frame_10.Position = UDim2.new(0.34649023413658142, 0, 0.079073071479797363, 0)
Frame_10.Size = UDim2.new(0, 5, 0, 4)
Frame_10.ZIndex = 2
Frame_10.Parent = BlueParticles

local UICorner_13 = Instance.new("UICorner")
UICorner_13.CornerRadius = UDim.new(0, 99)
UICorner_13.Parent = Frame_10
-- Source by Daily discord.gg/irsh

local Frame_11 = Instance.new("Frame")
Frame_11.BackgroundColor3 = Color3.fromRGB(70, 200, 255)
Frame_11.BackgroundTransparency = 0.79000002145767212
Frame_11.Position = UDim2.new(0.55422788858413696, 0, 0.038068152964115143, 0)
Frame_11.Size = UDim2.new(0, 3, 0, 4)
Frame_11.ZIndex = 2
Frame_11.Parent = BlueParticles

local UICorner_14 = Instance.new("UICorner")
UICorner_14.CornerRadius = UDim.new(0, 99)
UICorner_14.Parent = Frame_11

local Frame_12 = Instance.new("Frame")
Frame_12.BackgroundColor3 = Color3.fromRGB(70, 200, 255)
Frame_12.BackgroundTransparency = 0.80000001192092896
Frame_12.Position = UDim2.new(0.19328212738037109, 0, 0.26697677373886108, 0)
Frame_12.Size = UDim2.new(0, 2, 0, 5)
Frame_12.ZIndex = 2
Frame_12.Parent = BlueParticles

local UICorner_15 = Instance.new("UICorner")
UICorner_15.CornerRadius = UDim.new(0, 99)
UICorner_15.Parent = Frame_12

local Frame_13 = Instance.new("Frame")
Frame_13.BackgroundColor3 = Color3.fromRGB(70, 200, 255)
Frame_13.BackgroundTransparency = 0.81999999284744263
Frame_13.Position = UDim2.new(0.35361507534980774, 0, 0.33939999341964722, 0)
Frame_13.Size = UDim2.new(0, 2, 0, 5)
Frame_13.ZIndex = 2
Frame_13.Parent = BlueParticles
-- Source by Daily discord.gg/irsh

local UICorner_16 = Instance.new("UICorner")
UICorner_16.CornerRadius = UDim.new(0, 99)
UICorner_16.Parent = Frame_13

local Frame_14 = Instance.new("Frame")
Frame_14.BackgroundColor3 = Color3.fromRGB(70, 200, 255)
Frame_14.BackgroundTransparency = 0.79000002145767212
Frame_14.Position = UDim2.new(0.50907313823699951, 0, -0.032678589224815369, 0)
Frame_14.Size = UDim2.new(0, 4, 0, 5)
Frame_14.ZIndex = 2
Frame_14.Parent = BlueParticles

local UICorner_17 = Instance.new("UICorner")
UICorner_17.CornerRadius = UDim.new(0, 99)
UICorner_17.Parent = Frame_14

local Frame_15 = Instance.new("Frame")
Frame_15.BackgroundColor3 = Color3.fromRGB(70, 200, 255)
Frame_15.BackgroundTransparency = 0.5899999737739563
Frame_15.Position = UDim2.new(0.29508483409881592, 0, 0.31489688158035278, 0)
Frame_15.Size = UDim2.new(0, 5, 0, 2)
Frame_15.ZIndex = 2
Frame_15.Parent = BlueParticles

local UICorner_18 = Instance.new("UICorner")
UICorner_18.CornerRadius = UDim.new(0, 99)
UICorner_18.Parent = Frame_15
-- Source by Daily discord.gg/irsh

local Frame_16 = Instance.new("Frame")
Frame_16.BackgroundColor3 = Color3.fromRGB(70, 200, 255)
Frame_16.BackgroundTransparency = 0.68999999761581421
Frame_16.Position = UDim2.new(0.36656287312507629, 0, 1.0420596599578857, 0)
Frame_16.Size = UDim2.new(0, 2, 0, 5)
Frame_16.ZIndex = 2
Frame_16.Parent = BlueParticles

local UICorner_19 = Instance.new("UICorner")
UICorner_19.CornerRadius = UDim.new(0, 99)
UICorner_19.Parent = Frame_16

local Frame_17 = Instance.new("Frame")
Frame_17.BackgroundColor3 = Color3.fromRGB(70, 200, 255)
Frame_17.BackgroundTransparency = 0.57999998331069946
Frame_17.Position = UDim2.new(0.060228414833545685, 0, 0.95450097322463989, 0)
Frame_17.Size = UDim2.new(0, 2, 0, 4)
Frame_17.ZIndex = 2
Frame_17.Parent = BlueParticles

local UICorner_20 = Instance.new("UICorner")
UICorner_20.CornerRadius = UDim.new(0, 99)
UICorner_20.Parent = Frame_17

local Frame_18 = Instance.new("Frame")
Frame_18.BackgroundColor3 = Color3.fromRGB(70, 200, 255)
Frame_18.BackgroundTransparency = 0.60000002384185791
Frame_18.Position = UDim2.new(0.21667517721652985, 0, 0.57408547401428223, 0)
Frame_18.Size = UDim2.new(0, 4, 0, 2)
Frame_18.ZIndex = 2
Frame_18.Parent = BlueParticles
-- Source by Daily discord.gg/irsh

local UICorner_21 = Instance.new("UICorner")
UICorner_21.CornerRadius = UDim.new(0, 99)
UICorner_21.Parent = Frame_18

local Frame_19 = Instance.new("Frame")
Frame_19.BackgroundTransparency = 1
Frame_19.Size = UDim2.new(1, 0, 0, 48)
Frame_19.ZIndex = 5
Frame_19.Parent = Main

local TextLabel = Instance.new("TextLabel")
TextLabel.BackgroundTransparency = 1
TextLabel.Position = UDim2.new(0, 40, 0, 7)
TextLabel.Size = UDim2.new(1, -80, 0, 24)
TextLabel.ZIndex = 6
TextLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
TextLabel.Text = "ANAS anti bat"
TextLabel.TextColor3 = Color3.fromRGB(245, 250, 255)
TextLabel.TextSize = 15
TextLabel.Parent = Frame_19

local UIGradient_3 = Instance.new("UIGradient")
UIGradient_3.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(70, 200, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))})
UIGradient_3.Offset = Vector2.new(0.19517433643341064, 0)
UIGradient_3.Parent = TextLabel
-- Source by Daily discord.gg/irsh

local Hide = Instance.new("TextButton")
Hide.Name = "Hide"
Hide.BackgroundColor3 = Color3.fromRGB(8, 18, 32)
Hide.BackgroundTransparency = 0.20000000298023224
Hide.Position = UDim2.new(0, 10, 0, 10)
Hide.Size = UDim2.new(0, 25, 0, 25)
Hide.ZIndex = 10
Hide.AutoButtonColor = false
Hide.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
Hide.Text = "−"
Hide.TextColor3 = Color3.fromRGB(245, 250, 255)
Hide.TextSize = 18
Hide.Parent = Frame_19

local UICorner_22 = Instance.new("UICorner")
UICorner_22.CornerRadius = UDim.new(0, 7)
UICorner_22.Parent = Hide

local UIStroke_2 = Instance.new("UIStroke")
UIStroke_2.Color = Color3.fromRGB(0, 170, 255)
UIStroke_2.Thickness = 1.2000000476837158
UIStroke_2.Transparency = 0.34999999403953552
UIStroke_2.Parent = Hide

local Frame_20 = Instance.new("Frame")
Frame_20.BackgroundTransparency = 1
Frame_20.Position = UDim2.new(0, 12, 0, 52)
Frame_20.Size = UDim2.new(1, -24, 1, -62)
Frame_20.ZIndex = 6
Frame_20.Parent = Main
-- Source by Daily discord.gg/irsh

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 8)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Parent = Frame_20

local Frame_21 = Instance.new("Frame")
Frame_21.BackgroundColor3 = Color3.fromRGB(8, 18, 32)
Frame_21.BackgroundTransparency = 0.2199999988079071
Frame_21.ClipsDescendants = true
Frame_21.Size = UDim2.new(1, 0, 0, 40)
Frame_21.ZIndex = 7
Frame_21.Parent = Frame_20

local UICorner_23 = Instance.new("UICorner")
UICorner_23.CornerRadius = UDim.new(0, 10)
UICorner_23.Parent = Frame_21

local UIGradient_4 = Instance.new("UIGradient")
UIGradient_4.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(120, 190, 255))})
UIGradient_4.Rotation = 90
UIGradient_4.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.92000001668930054, 0), NumberSequenceKeypoint.new(0.5, 0.98000001907348633, 0), NumberSequenceKeypoint.new(1, 0.89999997615814209, 0)})
UIGradient_4.Parent = Frame_21

local UIStroke_3 = Instance.new("UIStroke")
UIStroke_3.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke_3.Color = Color3.fromRGB(0, 170, 255)
UIStroke_3.Thickness = 1.25
UIStroke_3.Transparency = 0.20000000298023224
UIStroke_3.Parent = Frame_21
-- Source by Daily discord.gg/irsh

local UIGradient_5 = Instance.new("UIGradient")
UIGradient_5.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 120, 255)), ColorSequenceKeypoint.new(0.2199999988079071, Color3.fromRGB(0, 190, 255)), ColorSequenceKeypoint.new(0.44999998807907104, Color3.fromRGB(90, 220, 255)), ColorSequenceKeypoint.new(0.68000000715255737, Color3.fromRGB(0, 110, 230)), ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 170, 255))})
UIGradient_5.Rotation = 54.943248748779297
UIGradient_5.Parent = UIStroke_3

local TextLabel_2 = Instance.new("TextLabel")
TextLabel_2.BackgroundTransparency = 1
TextLabel_2.Position = UDim2.new(0, 13, 0, 0)
TextLabel_2.Size = UDim2.new(1, -85, 1, 0)
TextLabel_2.ZIndex = 9
TextLabel_2.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
TextLabel_2.Text = "Anti Bat  •  OFF"
TextLabel_2.TextColor3 = Color3.fromRGB(245, 250, 255)
TextLabel_2.TextSize = 12
TextLabel_2.TextXAlignment = Enum.TextXAlignment.Left
TextLabel_2.Parent = Frame_21

local Frame_22 = Instance.new("Frame")
Frame_22.AnchorPoint = Vector2.new(1, 0.5)
Frame_22.BackgroundColor3 = Color3.fromRGB(18, 25, 35)
Frame_22.Position = UDim2.new(1, -11, 0.5, 0)
Frame_22.Size = UDim2.new(0, 42, 0, 23)
Frame_22.ZIndex = 9
Frame_22.Parent = Frame_21
-- Source by Daily discord.gg/irsh

local UICorner_24 = Instance.new("UICorner")
UICorner_24.CornerRadius = UDim.new(0, 99)
UICorner_24.Parent = Frame_22

local UIStroke_4 = Instance.new("UIStroke")
UIStroke_4.Color = Color3.fromRGB(0, 170, 255)
UIStroke_4.Thickness = 1.2000000476837158
UIStroke_4.Transparency = 0.5
UIStroke_4.Parent = Frame_22

local Frame_23 = Instance.new("Frame")
Frame_23.BackgroundColor3 = Color3.fromRGB(245, 250, 255)
Frame_23.Position = UDim2.new(0, 3, 0, 3)
Frame_23.Size = UDim2.new(0, 17, 0, 17)
Frame_23.ZIndex = 11
Frame_23.Parent = Frame_22

local UICorner_25 = Instance.new("UICorner")
UICorner_25.CornerRadius = UDim.new(0, 99)
UICorner_25.Parent = Frame_23

local TextButton = Instance.new("TextButton")
TextButton.BackgroundTransparency = 1
TextButton.Size = UDim2.new(1, 0, 1, 0)
TextButton.ZIndex = 12
TextButton.Text = ""
TextButton.Parent = Frame_21
-- Source by Daily discord.gg/irsh

local Frame_24 = Instance.new("Frame")
Frame_24.BackgroundColor3 = Color3.fromRGB(8, 18, 32)
Frame_24.BackgroundTransparency = 0.2199999988079071
Frame_24.ClipsDescendants = true
Frame_24.Size = UDim2.new(1, 0, 0, 40)
Frame_24.ZIndex = 7
Frame_24.Parent = Frame_20

local UICorner_26 = Instance.new("UICorner")
UICorner_26.CornerRadius = UDim.new(0, 10)
UICorner_26.Parent = Frame_24

local UIGradient_6 = Instance.new("UIGradient")
UIGradient_6.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(120, 190, 255))})
UIGradient_6.Rotation = 90
UIGradient_6.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.92000001668930054, 0), NumberSequenceKeypoint.new(0.5, 0.98000001907348633, 0), NumberSequenceKeypoint.new(1, 0.89999997615814209, 0)})
UIGradient_6.Parent = Frame_24

local UIStroke_5 = Instance.new("UIStroke")
UIStroke_5.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke_5.Color = Color3.fromRGB(0, 170, 255)
UIStroke_5.Thickness = 1.25
UIStroke_5.Transparency = 0.20000000298023224
UIStroke_5.Parent = Frame_24
-- Source by Daily discord.gg/irsh

local UIGradient_7 = Instance.new("UIGradient")
UIGradient_7.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 120, 255)), ColorSequenceKeypoint.new(0.2199999988079071, Color3.fromRGB(0, 190, 255)), ColorSequenceKeypoint.new(0.44999998807907104, Color3.fromRGB(90, 220, 255)), ColorSequenceKeypoint.new(0.68000000715255737, Color3.fromRGB(0, 110, 230)), ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 170, 255))})
UIGradient_7.Rotation = 56.926673889160156
UIGradient_7.Parent = UIStroke_5

local TextLabel_3 = Instance.new("TextLabel")
TextLabel_3.BackgroundTransparency = 1
TextLabel_3.Position = UDim2.new(0, 13, 0, 0)
TextLabel_3.Size = UDim2.new(1, -85, 1, 0)
TextLabel_3.ZIndex = 9
TextLabel_3.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
TextLabel_3.Text = "Infinite Jump  •  ON"
TextLabel_3.TextColor3 = Color3.fromRGB(70, 200, 255)
TextLabel_3.TextSize = 12
TextLabel_3.TextXAlignment = Enum.TextXAlignment.Left
TextLabel_3.Parent = Frame_24

local Frame_25 = Instance.new("Frame")
Frame_25.AnchorPoint = Vector2.new(1, 0.5)
Frame_25.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
Frame_25.Position = UDim2.new(1, -11, 0.5, 0)
Frame_25.Size = UDim2.new(0, 42, 0, 23)
Frame_25.ZIndex = 9
Frame_25.Parent = Frame_24
-- Source by Daily discord.gg/irsh

local UICorner_27 = Instance.new("UICorner")
UICorner_27.CornerRadius = UDim.new(0, 99)
UICorner_27.Parent = Frame_25

local UIStroke_6 = Instance.new("UIStroke")
UIStroke_6.Color = Color3.fromRGB(0, 170, 255)
UIStroke_6.Thickness = 1.2000000476837158
UIStroke_6.Transparency = 0.050000011920928955
UIStroke_6.Parent = Frame_25

local Frame_26 = Instance.new("Frame")
Frame_26.BackgroundColor3 = Color3.fromRGB(245, 250, 255)
Frame_26.Position = UDim2.new(0, 22, 0, 3)
Frame_26.Size = UDim2.new(0, 17, 0, 17)
Frame_26.ZIndex = 11
Frame_26.Parent = Frame_25

local UICorner_28 = Instance.new("UICorner")
UICorner_28.CornerRadius = UDim.new(0, 99)
UICorner_28.Parent = Frame_26

local TextButton_2 = Instance.new("TextButton")
TextButton_2.BackgroundTransparency = 1
TextButton_2.Size = UDim2.new(1, 0, 1, 0)
TextButton_2.ZIndex = 12
TextButton_2.Text = ""
TextButton_2.Parent = Frame_24
-- Source by Daily discord.gg/irsh

local Keybind = Instance.new("TextButton")
Keybind.Name = "Keybind"
Keybind.BackgroundColor3 = Color3.fromRGB(12, 18, 28)
Keybind.BackgroundTransparency = 0.11999999731779099
Keybind.Size = UDim2.new(1, 0, 0, 38)
Keybind.ZIndex = 7
Keybind.AutoButtonColor = false
Keybind.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
Keybind.Text = "Keybind : B"
Keybind.TextColor3 = Color3.fromRGB(245, 250, 255)
Keybind.TextSize = 13
Keybind.Parent = Frame_20

local UICorner_29 = Instance.new("UICorner")
UICorner_29.CornerRadius = UDim.new(0, 9)
UICorner_29.Parent = Keybind

local UIStroke_7 = Instance.new("UIStroke")
UIStroke_7.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke_7.Color = Color3.fromRGB(0, 170, 255)
UIStroke_7.Thickness = 1.2000000476837158
UIStroke_7.Transparency = 0.44999998807907104
UIStroke_7.Parent = Keybind

-- Source by Daily discord.gg/irsh

ANASantibat.Parent = PlayerGui

------------------------------------------------------------------
-- LOGIC
-- Source by Daily discord.gg/irsh
------------------------------------------------------------------
local connections = {}
-- Source by Daily discord.gg/irsh
local function track(c) table.insert(connections, c) return c end

local state = {
    antiBat = false,      -- starts OFF (same as the design)
    infJumpEnabled = true, -- starts ON  (same as the design)
    infJumpMode = "hold",   -- "hold" or "manual"
    holdInfJumpConn = nil,
    keybind = Enum.KeyCode.B,
    listening = false,
    collapsed = false,
}

local TI = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
-- Source by Daily discord.gg/irsh
local function tween(obj, props) TweenService:Create(obj, TI, props):Play() end

local ON_TRACK, OFF_TRACK = Color3.fromRGB(0, 170, 255), Color3.fromRGB(18, 25, 35)
local ON_TEXT, OFF_TEXT = Color3.fromRGB(70, 200, 255), Color3.fromRGB(245, 250, 255)

-- visuals for a toggle row
local uiReady = false
local ROSE = Color3.fromRGB(240, 160, 235)
local trackJobs = setmetatable({}, {__mode = "k"})
local KNOB_TI = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local POP_IN = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local POP_OUT = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

-- Source by Daily discord.gg/irsh
local function setToggleVisual(name, on, label, track_, knob, stroke, text)
    label.Text = name .. "  •  " .. (on and "ON" or "OFF")
    tween(label, {TextColor3 = on and ON_TEXT or OFF_TEXT})
    trackJobs[track_] = (trackJobs[track_] or 0) + 1
    local jobId = trackJobs[track_]
    if on and uiReady then
        -- small wait first, then the rose flash, then settle to blue
        task.delay(0.12, function()
            if trackJobs[track_] == jobId then
                TweenService:Create(track_, TweenInfo.new(0.08), {BackgroundColor3 = ROSE}):Play()
            end
        end)
        task.delay(0.34, function()
            if trackJobs[track_] == jobId then
                TweenService:Create(track_, TweenInfo.new(0.35), {BackgroundColor3 = ON_TRACK}):Play()
            end
        end)
    else
        tween(track_, {BackgroundColor3 = on and ON_TRACK or OFF_TRACK})
    end
    tween(stroke, {Transparency = on and 0.05 or 0.5})

    local goal = on and UDim2.new(0, 22, 0, 3) or UDim2.new(0, 3, 0, 3)
    if not uiReady then
        knob.Position = goal
        return
    end
-- Source by Daily discord.gg/irsh

    -- small animation: knob springs across and pops
    TweenService:Create(knob, KNOB_TI, {Position = goal}):Play()
    local pop = knob:FindFirstChild("Pop")
    if not pop then
        pop = Instance.new("UIScale")
        pop.Name = "Pop"
        pop.Parent = knob
    end
    local up = TweenService:Create(pop, POP_IN, {Scale = 1.06})
    up:Play()
    up.Completed:Connect(function()
        TweenService:Create(pop, POP_OUT, {Scale = 1}):Play()
    end)
    -- track pulses a little
    local tpop = track_:FindFirstChild("Pop")
    if not tpop then
        tpop = Instance.new("UIScale")
        tpop.Name = "Pop"
        tpop.Parent = track_
    end
    local tu = TweenService:Create(tpop, POP_IN, {Scale = 1.02})
    tu:Play()
    tu.Completed:Connect(function()
        TweenService:Create(tpop, POP_OUT, {Scale = 1}):Play()
    end)
end
-- Source by Daily discord.gg/irsh

------------------------------------------------------------------
-- Anti Bat (velocity desync)
-- Source by Daily discord.gg/irsh
------------------------------------------------------------------
local antiBatConn = nil
local antiBatBusy = false

-- Source by Daily discord.gg/irsh
local function enableAntiBat()
    if antiBatConn then return end
    antiBatConn = RunService.Heartbeat:Connect(function()
        if not state.antiBat or antiBatBusy then return end
        local char = LocalPlayer.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        antiBatBusy = true
        local ok = pcall(function()
            local vel = hrp.Velocity
            hrp.Velocity = Vector3.new(math.random(-4000, 4000), vel.Y, math.random(-4000, 4000))
            RunService.RenderStepped:Wait()
            if hrp and hrp.Parent then
                -- keep the CURRENT Y so Infinite Jump's boost isn't wiped out
                local cur = hrp.Velocity
                hrp.Velocity = Vector3.new(vel.X, cur.Y, vel.Z)
            end
        end)
        antiBatBusy = false
    end)
end

-- Source by Daily discord.gg/irsh
local function disableAntiBat()
    if antiBatConn then
        antiBatConn:Disconnect()
        antiBatConn = nil
    end
end

-- Source by Daily discord.gg/irsh
local function setAntiBat(on)
    state.antiBat = on
    setToggleVisual("Anti Bat", on, TextLabel_2, Frame_22, Frame_23, UIStroke_4)
    if on then
        enableAntiBat()
    else
        disableAntiBat()
    end
end

------------------------------------------------------------------
-- Infinite Jump
-- Source by Daily discord.gg/irsh
------------------------------------------------------------------
local LP = LocalPlayer
local State = state

-- ================= HOLD INFINITE JUMP =================
-- Source by Daily discord.gg/irsh
local function startHoldInfJump()
	if State.holdInfJumpConn then
		State.holdInfJumpConn:Disconnect()
	end
	State.holdInfJumpConn = RunService.Heartbeat:Connect(function()
		if not State.infJumpEnabled or State.infJumpMode ~= "hold" then return end
		local char = LP.Character
		if not char then return end
		local root = char:FindFirstChild("HumanoidRootPart")
		local hum = char:FindFirstChildOfClass("Humanoid")
		if not root or not hum then return end
		local isJumpHeld = UIS:IsKeyDown(Enum.KeyCode.Space) or (hum.Jump == true)
		if isJumpHeld and root.Velocity.Y < 35 then
			root.Velocity = Vector3.new(root.Velocity.X, 55, root.Velocity.Z)
		end
		if root.Velocity.Y < -120 then
			root.Velocity = Vector3.new(root.Velocity.X, -120, root.Velocity.Z)
		end
	end)
end

-- Source by Daily discord.gg/irsh
local function stopHoldInfJump()
	if State.holdInfJumpConn then
		State.holdInfJumpConn:Disconnect()
		State.holdInfJumpConn = nil
	end
end

-- Source by Daily discord.gg/irsh
local function setupManualInfJump()
	track(UIS.JumpRequest:Connect(function()
		if not State.infJumpEnabled or State.infJumpMode ~= "manual" then return end
		local char = LP.Character
		if not char then return end
		local root = char:FindFirstChild("HumanoidRootPart")
		if root then
			root.Velocity = Vector3.new(root.Velocity.X, 55, root.Velocity.Z)
		end
	end))
	track(UIS.InputBegan:Connect(function(input)
		if not State.infJumpEnabled or State.infJumpMode ~= "manual" then return end
		if UIS:GetFocusedTextBox() then return end
		if input.KeyCode == Enum.KeyCode.Space then
			local char = LP.Character
			if not char then return end
			local root = char:FindFirstChild("HumanoidRootPart")
			if root then
				task.delay(0.12, function()
					if root and root.Parent and State.infJumpEnabled and State.infJumpMode == "manual" then
						root.Velocity = Vector3.new(root.Velocity.X, 55, root.Velocity.Z)
					end
				end)
			end
		end
	end))
end
-- Source by Daily discord.gg/irsh

setupManualInfJump()

-- Source by Daily discord.gg/irsh
local function applyInfJumpMode()
	if State.infJumpEnabled then
		if State.infJumpMode == "hold" then
			startHoldInfJump()
		else
			stopHoldInfJump()
		end
	else
		stopHoldInfJump()
	end
end

-- Source by Daily discord.gg/irsh
local function setInfJump(on)
    state.infJumpEnabled = on
    setToggleVisual("Infinite Jump", on, TextLabel_3, Frame_25, Frame_26, UIStroke_6)
    applyInfJumpMode()
end

------------------------------------------------------------------
-- Buttons
-- Source by Daily discord.gg/irsh
------------------------------------------------------------------
-- Source by Daily discord.gg/irsh
track(TextButton.Activated:Connect(function() setAntiBat(not state.antiBat) end))
-- Source by Daily discord.gg/irsh
track(TextButton_2.Activated:Connect(function() setInfJump(not state.infJumpEnabled) end))

------------------------------------------------------------------
-- Keybind (click it, press a key; Esc cancels) -> toggles Anti Bat
-- Source by Daily discord.gg/irsh
------------------------------------------------------------------
-- Source by Daily discord.gg/irsh
local function keyName(k) return k.Name end
-- Source by Daily discord.gg/irsh
local function refreshKeybindText()
    Keybind.Text = state.listening and "Keybind : ..." or ("Keybind : " .. keyName(state.keybind))
end

-- Source by Daily discord.gg/irsh
track(Keybind.Activated:Connect(function()
    state.listening = true
    refreshKeybindText()
end))

-- Source by Daily discord.gg/irsh
track(UIS.InputBegan:Connect(function(input, processed)
    if input.UserInputType ~= Enum.UserInputType.Keyboard then return end

    if state.listening then
        state.listening = false
        if input.KeyCode ~= Enum.KeyCode.Escape and input.KeyCode ~= Enum.KeyCode.Unknown then
            state.keybind = input.KeyCode
        end
        refreshKeybindText()
        return
    end

    if processed then return end -- ignore while typing in chat
    if input.KeyCode == state.keybind then
        setAntiBat(not state.antiBat)
    end
end))

------------------------------------------------------------------
-- Hide / show (collapse to the title bar)
-- Source by Daily discord.gg/irsh
------------------------------------------------------------------
local FULL_SIZE = Main.Size
local COLLAPSED_SIZE = UDim2.new(0, 187, 0, 65)

-- Source by Daily discord.gg/irsh
track(Hide.Activated:Connect(function()
    state.collapsed = not state.collapsed
    if state.collapsed then
        Frame_20.Visible = false
        Hide.Text = "+"
        tween(Main, {Size = COLLAPSED_SIZE})
    else
        Hide.Text = "−"
        tween(Main, {Size = FULL_SIZE})
        task.delay(0.1, function()
            if not state.collapsed then Frame_20.Visible = true end
        end)
    end
end))

------------------------------------------------------------------
-- Dragging (mouse + touch) from the header or any empty area, smoothed
-- Source by Daily discord.gg/irsh
------------------------------------------------------------------
do
    local DRAG_SMOOTHNESS = 9.3 -- lower = slower / floatier, higher = snappier
    local dragging, dragStart, startPos = false, nil, nil
    local targetX, targetY = Main.Position.X.Offset, Main.Position.Y.Offset

    local function beginDrag(input)
        if dragging then return end
        if input.UserInputType ~= Enum.UserInputType.MouseButton1
            and input.UserInputType ~= Enum.UserInputType.Touch then return end
        dragging = true
        dragStart = input.Position
        startPos = Main.Position
        targetX, targetY = startPos.X.Offset, startPos.Y.Offset
        local c; c = input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
                if c then c:Disconnect() end
            end
        end)
    end
-- Source by Daily discord.gg/irsh

    Main.Active = true
    Frame_19.Active = true
    track(Main.InputBegan:Connect(beginDrag))
    track(Frame_19.InputBegan:Connect(beginDrag))

    track(UIS.InputChanged:Connect(function(input)
        if not dragging then return end
        if input.UserInputType ~= Enum.UserInputType.MouseMovement
            and input.UserInputType ~= Enum.UserInputType.Touch then return end
        local d = (input.Position - dragStart) / UIScale.Scale
        targetX = startPos.X.Offset + d.X
        targetY = startPos.Y.Offset + d.Y
    end))

    track(RunService.RenderStepped:Connect(function(dt)
        local pos = Main.Position
        local cx, cy = pos.X.Offset, pos.Y.Offset
        if not dragging and math.abs(targetX - cx) < 0.3 and math.abs(targetY - cy) < 0.3 then return end
        local a = 1 - math.exp(-DRAG_SMOOTHNESS * dt)
        Main.Position = UDim2.new(pos.X.Scale, cx + (targetX - cx) * a, pos.Y.Scale, cy + (targetY - cy) * a)
    end))
end

------------------------------------------------------------------
-- Press flash ("bloated" look) on Hide and Keybind only.
-- Toggle overlays are excluded, they caused the gray blocks.
------------------------------------------------------------------
-- Source by Daily discord.gg/irsh
local function addPressFlash(btn, amount)
    local base = btn.BackgroundTransparency
    track(btn.Activated:Connect(function()
        btn.BackgroundTransparency = math.max(0, base - amount)
        task.delay(0.1, function()
            if btn.Parent then btn.BackgroundTransparency = base end
        end)
    end))
end
addPressFlash(Hide, 0.2)
addPressFlash(Keybind, 0.12)

------------------------------------------------------------------
-- Moving outline colors + title shimmer
-- Source by Daily discord.gg/irsh
------------------------------------------------------------------
do
    -- give the keybind outline the same moving gradient as the others
    local kg = Instance.new("UIGradient")
    kg.Color = UIGradient_2.Color
    kg.Rotation = 0
    kg.Parent = UIStroke_7

    local outlineGradients = {UIGradient_2, UIGradient_5, UIGradient_7, kg}
    track(RunService.RenderStepped:Connect(function(dt)
        for _, g in ipairs(outlineGradients) do
            g.Rotation = (g.Rotation + dt * 70) % 360
        end
    end))
-- Source by Daily discord.gg/irsh

    -- title: stays white for a bit, then the blue band sweeps across, repeat
    task.spawn(function()
        while ANASantibat.Parent do
            UIGradient_3.Offset = Vector2.new(-1, 0)
            local sweep = TweenService:Create(UIGradient_3,
                TweenInfo.new(2, Enum.EasingStyle.Linear), {Offset = Vector2.new(1, 0)})
            sweep:Play()
            sweep.Completed:Wait()
            UIGradient_3.Offset = Vector2.new(1, 0)
            task.wait(0.5) -- white pause
        end
    end)
end

------------------------------------------------------------------
-- Anti Drop (always on, no GUI)
-- Source by Daily discord.gg/irsh
------------------------------------------------------------------
local antiDropMt, antiDropOldIdx, antiDropOldNewIdx = nil, nil, nil
local spoofedVelocity = Vector3.zero

-- Source by Daily discord.gg/irsh
local function startAntiDrop()
    if antiDropOldIdx then return end
    -- needs these executor functions, otherwise skip quietly (no error)
    if typeof(getrawmetatable) ~= "function" or typeof(checkcaller) ~= "function" then return end

    local okMt, mt = pcall(getrawmetatable, game)
    if not okMt or not mt then return end

    local oldIdx, oldNewIdx = mt.__index, mt.__newindex
    if typeof(oldIdx) ~= "function" or typeof(oldNewIdx) ~= "function" then return end

    local newc = (typeof(newcclosure) == "function") and newcclosure or function(f) return f end
    local chk = checkcaller

    local function isMyRoot(self, key)
        return (key == "AssemblyLinearVelocity" or key == "Velocity")
            and typeof(self) == "Instance"
            and self:IsA("BasePart")
            and self.Name == "HumanoidRootPart"
            and LocalPlayer.Character ~= nil
            and self:IsDescendantOf(LocalPlayer.Character)
    end

    pcall(function() if typeof(setreadonly) == "function" then setreadonly(mt, false) end end)
    local ok = pcall(function()
        mt.__index = newc(function(self, key)
            if (key == "AssemblyLinearVelocity" or key == "Velocity") and not chk() and isMyRoot(self, key) then
                return spoofedVelocity
            end
            return oldIdx(self, key)
        end)
        mt.__newindex = newc(function(self, key, value)
            if (key == "AssemblyLinearVelocity" or key == "Velocity") and not chk() and isMyRoot(self, key) then
                spoofedVelocity = value
                return
            end
            return oldNewIdx(self, key, value)
        end)
    end)
    pcall(function() if typeof(setreadonly) == "function" then setreadonly(mt, true) end end)
-- Source by Daily discord.gg/irsh

    if ok then
        antiDropMt, antiDropOldIdx, antiDropOldNewIdx = mt, oldIdx, oldNewIdx
    end
end

-- Source by Daily discord.gg/irsh
local function stopAntiDrop()
    if not (antiDropMt and antiDropOldIdx) then return end
    pcall(function()
        if typeof(setreadonly) == "function" then setreadonly(antiDropMt, false) end
        antiDropMt.__index = antiDropOldIdx
        antiDropMt.__newindex = antiDropOldNewIdx
        if typeof(setreadonly) == "function" then setreadonly(antiDropMt, true) end
    end)
    antiDropMt, antiDropOldIdx, antiDropOldNewIdx = nil, nil, nil
end

------------------------------------------------------------------
-- Init visuals + cleanup
-- Source by Daily discord.gg/irsh
------------------------------------------------------------------
setAntiBat(state.antiBat)
setInfJump(state.infJumpEnabled)
refreshKeybindText()
uiReady = true
pcall(startAntiDrop)

ANASantibat.Destroying:Connect(function()
    for _, c in ipairs(connections) do pcall(function() c:Disconnect() end) end
    stopHoldInfJump()
    disableAntiBat()
    stopAntiDrop()
end)
-- Source by Daily discord.gg/irsh

return ANASantibat
-- Source by Daily discord.gg/irsh