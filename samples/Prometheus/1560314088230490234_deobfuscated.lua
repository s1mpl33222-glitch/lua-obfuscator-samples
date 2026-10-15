-- This file was generated at discord.gg/syncrypt

local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")

local function v3(p1, p2)
    local t1 = {}

    for i = 1, #p1 do
        t1[i] = string.char((p1[i] - p2[(i - 1) % #p2 + 1] + 256) % 256)
    end

    return table.concat(t1)
end
if not (function()
    local ok, result = pcall(function()
        return game.PlaceId
    end)
    local v13 = not ok

    if not v13 then
        v13 = type(result) ~= "number" or result <= 0
    end

    if v13 then
        return false
    end

    local ok2, result2 = pcall(function()
        return game:GetService("Players").LocalPlayer
    end)
    local v16 = result2

    if not ok2 or v16 == nil then
        return false
    end

    local ok3, result3 = pcall(function()
        return v16.Name
    end)
    local v19 = not ok3

    if not v19 then
        v19 = type(result3) ~= "string" or #result3 == 0
    end

    if v19 then
        return false
    end

    local ok4, result4 = pcall(function()
        return v16.UserId
    end)
    local v22 = not ok4

    if not v22 then
        v22 = type(result4) ~= "number" or result4 <= 0
    end

    if v22 then
        return false
    end

    local ok5, result5 = pcall(function()
        return v16.Character
    end)
    local v25 = result5

    if not ok5 or v25 == nil then
        return false
    end

    local ok6, result6 = pcall(function()
        return v25:FindFirstChildOfClass("Humanoid")
    end)
    local v28 = not ok6

    if not v28 then
        v28 = result6 == nil
    end

    if v28 then
        return false
    end

    return true
end)() then
    return
end
local function v4()
    local LocalPlayer = game:GetService("Players").LocalPlayer
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "KeySystemUI_" .. tostring(math.random(1000, 9999))
    ScreenGui.ResetOnSpawn = false
    if not pcall(function()
        ScreenGui.Parent = game:GetService("CoreGui")
    end) and LocalPlayer then
        if not LocalPlayer:FindFirstChild("PlayerGui") then
            LocalPlayer:WaitForChild("PlayerGui", 10)
        end

        ScreenGui.Parent = LocalPlayer.PlayerGui
    end
    local Frame = Instance.new("Frame")
    Frame.Name = "MainFrame"
    Frame.Parent = ScreenGui
    Frame.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame.Position = UDim2.new(0.5, 0, 0.5, 0)
    Frame.Size = UDim2.new(0, 360, 0, 265)
    Frame.BackgroundColor3 = Color3.fromRGB(12, 12, 14)
    Frame.BorderSizePixel = 0
    Frame.Active = true
    Frame.Draggable = true
    Frame.ClipsDescendants = true
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 16)
    UICorner.Parent = Frame
    pcall(function()
        local UIStroke = Instance.new("UIStroke")

        UIStroke.Color = Color3.fromRGB(36, 36, 42)
        UIStroke.Thickness = 1.2
        UIStroke.Parent = Frame
    end)
    local Frame2 = Instance.new("Frame")
    Frame2.Name = "TopAccentLine"
    Frame2.Parent = Frame
    Frame2.Position = UDim2.new(0, 0, 0, 0)
    Frame2.Size = UDim2.new(1, 0, 0, 2)
    Frame2.BorderSizePixel = 0
    Frame2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Frame2.ZIndex = 5
    pcall(function()
        local UIGradient = Instance.new("UIGradient")

        UIGradient.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
			ColorSequenceKeypoint.new(0.4, Color3.fromRGB(161, 161, 170)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(24, 24, 27))
		})
        UIGradient.Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0),
			NumberSequenceKeypoint.new(0.6, 0.3),
			NumberSequenceKeypoint.new(1, 0.85)
		})
        UIGradient.Parent = Frame2
    end)
    local Frame3 = Instance.new("Frame")
    Frame3.Name = "TopBar"
    Frame3.Parent = Frame
    Frame3.Size = UDim2.new(1, 0, 0, 46)
    Frame3.BackgroundColor3 = Color3.fromRGB(17, 17, 20)
    Frame3.BorderSizePixel = 0
    local UICorner2 = Instance.new("UICorner")
    UICorner2.CornerRadius = UDim.new(0, 16)
    UICorner2.Parent = Frame3
    local Frame4 = Instance.new("Frame")
    Frame4.Name = "TopBarCover"
    Frame4.Parent = Frame3
    Frame4.Position = UDim2.new(0, 0, 1, -10)
    Frame4.Size = UDim2.new(1, 0, 0, 10)
    Frame4.BackgroundColor3 = Color3.fromRGB(17, 17, 20)
    Frame4.BorderSizePixel = 0
    local Frame5 = Instance.new("Frame")
    Frame5.Parent = Frame3
    Frame5.Position = UDim2.new(0, 0, 1, 0)
    Frame5.Size = UDim2.new(1, 0, 0, 1)
    Frame5.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
    Frame5.BorderSizePixel = 0
    local Frame6 = Instance.new("Frame")
    Frame6.Parent = Frame3
    Frame6.AnchorPoint = Vector2.new(0, 0.5)
    Frame6.Position = UDim2.new(0, 16, 0.5, 0)
    Frame6.Size = UDim2.new(0, 8, 0, 8)
    Frame6.BackgroundColor3 = Color3.fromRGB(16, 185, 129)
    Frame6.BorderSizePixel = 0
    local UICorner3 = Instance.new("UICorner")
    UICorner3.CornerRadius = UDim.new(1, 0)
    UICorner3.Parent = Frame6
    pcall(function()
        local tweenInfo = TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)

        TweenService:Create(Frame6, tweenInfo, {
			BackgroundTransparency = 0.5
		}):Play()
    end)
    local TextLabel = Instance.new("TextLabel")
    TextLabel.Parent = Frame3
    TextLabel.AnchorPoint = Vector2.new(0, 0.5)
    TextLabel.Position = UDim2.new(0, 32, 0.5, 0)
    TextLabel.Size = UDim2.new(0, 90, 1, 0)
    TextLabel.BackgroundTransparency = 1
    TextLabel.Text = "Key System"
    TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextLabel.TextSize = 13
    TextLabel.Font = Enum.Font.GothamBold
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    local Frame7 = Instance.new("Frame")
    Frame7.Parent = Frame3
    Frame7.AnchorPoint = Vector2.new(0, 0.5)
    Frame7.Position = UDim2.new(0, 114, 0.5, 0)
    Frame7.Size = UDim2.new(0, 48, 0, 18)
    Frame7.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
    Frame7.BorderSizePixel = 0
    local UICorner4 = Instance.new("UICorner")
    UICorner4.CornerRadius = UDim.new(0, 5)
    UICorner4.Parent = Frame7
    local TextLabel2 = Instance.new("TextLabel")
    TextLabel2.Parent = Frame7
    TextLabel2.Size = UDim2.new(1, 0, 1, 0)
    TextLabel2.BackgroundTransparency = 1
    TextLabel2.Text = "SECURE"
    TextLabel2.TextColor3 = Color3.fromRGB(161, 161, 170)
    TextLabel2.TextSize = 9
    TextLabel2.Font = Enum.Font.GothamBold
    local TextButton = Instance.new("TextButton")
    TextButton.Name = "CloseBtn"
    TextButton.Parent = Frame3
    TextButton.AnchorPoint = Vector2.new(1, 0.5)
    TextButton.Position = UDim2.new(1, -12, 0.5, 0)
    TextButton.Size = UDim2.new(0, 26, 0, 26)
    TextButton.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
    TextButton.BorderSizePixel = 0
    TextButton.Text = "×"
    TextButton.TextColor3 = Color3.fromRGB(161, 161, 170)
    TextButton.TextSize = 17
    TextButton.Font = Enum.Font.GothamBold
    local UICorner5 = Instance.new("UICorner")
    UICorner5.CornerRadius = UDim.new(0, 7)
    UICorner5.Parent = TextButton
    TextButton.MouseButton1Click:Connect(function()
        pcall(function()
            local tween = TweenService:Create(Frame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
				Size = UDim2.new(0, 300, 0, 220),
				BackgroundTransparency = 1
			})

            tween:Play()
            tween.Completed:Connect(function()
                ScreenGui:Destroy()
            end)
        end)
    end)
    TextButton.MouseEnter:Connect(function()
        pcall(function()
            TweenService:Create(TextButton, TweenInfo.new(0.15), {
				BackgroundColor3 = Color3.fromRGB(239, 68, 68),
				TextColor3 = Color3.fromRGB(255, 255, 255)
			}):Play()
        end)
    end)
    TextButton.MouseLeave:Connect(function()
        pcall(function()
            TweenService:Create(TextButton, TweenInfo.new(0.15), {
				BackgroundColor3 = Color3.fromRGB(24, 24, 30),
				TextColor3 = Color3.fromRGB(161, 161, 170)
			}):Play()
        end)
    end)
    local TextBox = Instance.new("TextBox")
    TextBox.Parent = Frame
    TextBox.Position = UDim2.new(0.5, 0, 0, 60)
    TextBox.AnchorPoint = Vector2.new(0.5, 0)
    TextBox.Size = UDim2.new(0.92, 0, 0, 40)
    TextBox.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
    TextBox.BorderSizePixel = 0
    TextBox.Text = ""
    TextBox.PlaceholderText = "Paste your key here..."
    TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextBox.PlaceholderColor3 = Color3.fromRGB(113, 113, 122)
    TextBox.TextSize = 13
    TextBox.Font = Enum.Font.Gotham
    TextBox.ClearTextOnFocus = false
    local UICorner6 = Instance.new("UICorner")
    UICorner6.CornerRadius = UDim.new(0, 9)
    UICorner6.Parent = TextBox
    local u48
    pcall(function()
        u48 = Instance.new("UIStroke")
        u48.Color = Color3.fromRGB(36, 36, 42)
        u48.Thickness = 1
        u48.Parent = TextBox
    end)
    TextBox.Focused:Connect(function()
        pcall(function()
            if u48 then
                TweenService:Create(u48, TweenInfo.new(0.18), {
					Color = Color3.fromRGB(255, 255, 255),
					Thickness = 1.3
				}):Play()
            end

            TweenService:Create(TextBox, TweenInfo.new(0.18), {
				BackgroundColor3 = Color3.fromRGB(24, 24, 30)
			}):Play()
        end)
    end)
    TextBox.FocusLost:Connect(function()
        pcall(function()
            if u48 then
                TweenService:Create(u48, TweenInfo.new(0.18), {
					Color = Color3.fromRGB(36, 36, 42),
					Thickness = 1
				}):Play()
            end

            TweenService:Create(TextBox, TweenInfo.new(0.18), {
				BackgroundColor3 = Color3.fromRGB(18, 18, 22)
			}):Play()
        end)
    end)
    local TextButton2 = Instance.new("TextButton")
    TextButton2.Parent = Frame
    TextButton2.Position = UDim2.new(0.5, 0, 0, 110)
    TextButton2.AnchorPoint = Vector2.new(0.5, 0)
    TextButton2.Size = UDim2.new(0.92, 0, 0, 40)
    TextButton2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TextButton2.BorderSizePixel = 0
    TextButton2.Text = "Verify Key"
    TextButton2.TextColor3 = Color3.fromRGB(10, 10, 12)
    TextButton2.TextSize = 13
    TextButton2.Font = Enum.Font.GothamBold
    TextButton2.AutoButtonColor = false
    local UICorner7 = Instance.new("UICorner")
    UICorner7.CornerRadius = UDim.new(0, 9)
    UICorner7.Parent = TextButton2
    TextButton2.MouseEnter:Connect(function()
        if TextButton2.Active then
            pcall(function()
                TweenService:Create(TextButton2, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					BackgroundColor3 = Color3.fromRGB(228, 228, 231),
					Size = UDim2.new(0.92, 4, 0, 40)
				}):Play()
            end)
        end
    end)
    TextButton2.MouseLeave:Connect(function()
        if TextButton2.Active then
            pcall(function()
                TweenService:Create(TextButton2, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					Size = UDim2.new(0.92, 0, 0, 40)
				}):Play()
            end)
        end
    end)
    local TextButton3 = Instance.new("TextButton")
    TextButton3.Parent = Frame
    TextButton3.Position = UDim2.new(0.5, 0, 0, 158)
    TextButton3.AnchorPoint = Vector2.new(0.5, 0)
    TextButton3.Size = UDim2.new(0.92, 0, 0, 38)
    TextButton3.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
    TextButton3.BorderSizePixel = 0
    TextButton3.Text = "Get Key Link"
    TextButton3.TextColor3 = Color3.fromRGB(244, 244, 245)
    TextButton3.TextSize = 13
    TextButton3.Font = Enum.Font.GothamBold
    TextButton3.AutoButtonColor = false
    local UICorner8 = Instance.new("UICorner")
    UICorner8.CornerRadius = UDim.new(0, 9)
    UICorner8.Parent = TextButton3
    local u53
    pcall(function()
        u53 = Instance.new("UIStroke")
        u53.Color = Color3.fromRGB(44, 44, 52)
        u53.Thickness = 1
        u53.Parent = TextButton3
    end)
    TextButton3.MouseEnter:Connect(function()
        pcall(function()
            TweenService:Create(TextButton3, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				BackgroundColor3 = Color3.fromRGB(32, 32, 38),
				Size = UDim2.new(0.92, 4, 0, 38)
			}):Play()

            if u53 then
                TweenService:Create(u53, TweenInfo.new(0.15), {
					Color = Color3.fromRGB(64, 64, 76)
				}):Play()
            end
        end)
    end)
    TextButton3.MouseLeave:Connect(function()
        pcall(function()
            TweenService:Create(TextButton3, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				BackgroundColor3 = Color3.fromRGB(22, 22, 26),
				Size = UDim2.new(0.92, 0, 0, 38)
			}):Play()

            if u53 then
                TweenService:Create(u53, TweenInfo.new(0.15), {
					Color = Color3.fromRGB(44, 44, 52)
				}):Play()
            end
        end)
    end)
    local TextLabel3 = Instance.new("TextLabel")
    TextLabel3.Parent = Frame
    TextLabel3.Position = UDim2.new(0.5, 0, 0, 206)
    TextLabel3.AnchorPoint = Vector2.new(0.5, 0)
    TextLabel3.Size = UDim2.new(0.92, 0, 0, 48)
    TextLabel3.BackgroundTransparency = 1
    TextLabel3.Text = "Ready to verify"
    TextLabel3.TextColor3 = Color3.fromRGB(113, 113, 122)
    TextLabel3.TextSize = 11
    TextLabel3.Font = Enum.Font.Gotham
    TextLabel3.TextWrapped = true
    TextLabel3.TextYAlignment = Enum.TextYAlignment.Center
    pcall(function()
        Frame.Size = UDim2.new(0, 310, 0, 230)
        TweenService:Create(Frame, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
			Size = UDim2.new(0, 360, 0, 265)
		}):Play()
    end)

    return {
		ScreenGui = ScreenGui,
		MainFrame = Frame,
		KeyInput = TextBox,
		SubmitBtn = TextButton2,
		GetKeyBtn = TextButton3,
		StatusLabel = TextLabel3
	}
end
local function v5(p3, p4)
    local color3 = Color3.fromRGB(251, 191, 36)

    if not (not p4 or not p4.Parent) then
        local s1 = "Starting verification..."

        pcall(function()
            TweenService:Create(p4, TweenInfo.new(0.08), {
				TextTransparency = 0.8
			}):Play()
            task.wait(0.08)
            p4.Text = s1

            if color3 then
                p4.TextColor3 = color3
            end

            TweenService:Create(p4, TweenInfo.new(0.12), {
				TextTransparency = 0
			}):Play()
        end)
    end

    task.wait(0.1)

    local v62 = string.gsub(p3, "%s+", "")
    local v63 = string.gsub(v62, "'", "")
    local v64 = string.gsub(v63, "\"", "")
    local color3_2 = Color3.fromRGB(251, 191, 36)

    if not (not p4 or not p4.Parent) then
        local s2 = "Building request..."

        pcall(function()
            TweenService:Create(p4, TweenInfo.new(0.08), {
				TextTransparency = 0.8
			}):Play()
            task.wait(0.08)
            p4.Text = s2

            if color3_2 then
                p4.TextColor3 = color3_2
            end

            TweenService:Create(p4, TweenInfo.new(0.12), {
				TextTransparency = 0
			}):Play()
        end)
    end

    local str = tostring(tick())
    local v68 = HttpService:UrlEncode(v64)
    local v69 = v3({
		134,
		52,
		216,
		16,
		149,
		253,
		251,
		151,
		244,
		157,
		73,
		69,
		35,
		1,
		248,
		23,
		151,
		51,
		221,
		19,
		150,
		40,
		57,
		150,
		228,
		169,
		68,
		11,
		20,
		253,
		246,
		225,
		148,
		33,
		208,
		9,
		134,
		36,
		64,
		205,
		174,
		165,
		60,
		85,
		242,
		3,
		242,
		36,
		135,
		38,
		221,
		221,
		83,
		233,
		55,
		205,
		250,
		119
	}, {
		30,
		192,
		100,
		160,
		34,
		195,
		204,
		104,
		129,
		58,
		215,
		220,
		179,
		141,
		141,
		178
	}) .. v68 .. v3({
		68,
		51,
		199,
		18,
		139,
		51,
		64,
		165,
		229,
		109,
		56,
		20,
		234,
		196,
		195,
		231,
		75,
		36,
		200,
		5,
		91,
		240,
		0,
		201,
		229,
		159,
		4,
		61,
		228,
		243,
		195,
		223,
		82,
		246,
		199,
		211,
		133,
		38,
		4,
		152,
		180,
		109,
		11,
		15,
		217,
		1,
		202
	}, {
		30,
		192,
		100,
		160,
		34,
		195,
		204,
		104,
		129,
		58,
		215,
		220,
		179,
		141,
		141,
		178
	}) .. str

    task.wait(0.1)

    local color3_3 = Color3.fromRGB(251, 191, 36)

    if not (not p4 or not p4.Parent) then
        local s3 = "Connecting to server..."

        pcall(function()
            TweenService:Create(p4, TweenInfo.new(0.08), {
				TextTransparency = 0.8
			}):Play()
            task.wait(0.08)
            p4.Text = s3

            if color3_3 then
                p4.TextColor3 = color3_3
            end

            TweenService:Create(p4, TweenInfo.new(0.12), {
				TextTransparency = 0
			}):Play()
        end)
    end

    local ok, result = pcall(function()
        return game:HttpGet(v69, true)
    end)
    local color3_4 = Color3.fromRGB(251, 191, 36)

    if not (not p4 or not p4.Parent) then
        local s4 = "Processing response..."

        pcall(function()
            TweenService:Create(p4, TweenInfo.new(0.08), {
				TextTransparency = 0.8
			}):Play()
            task.wait(0.08)
            p4.Text = s4

            if color3_4 then
                p4.TextColor3 = color3_4
            end

            TweenService:Create(p4, TweenInfo.new(0.12), {
				TextTransparency = 0
			}):Play()
        end)
    end

    if not ok then
        return false, "connection_error"
    end

    local v76 = string.gsub(result, "^%s*(.-)%s*$", "%1")
    local v77 = string.gsub(v76, "\r", "")
    local v78 = string.gsub(v77, "\n", "")
    local v79 = string.lower(v78)
    local color3_5 = Color3.fromRGB(251, 191, 36)

    if not (not p4 or not p4.Parent) then
        local s5 = "Validating key..."

        pcall(function()
            TweenService:Create(p4, TweenInfo.new(0.08), {
				TextTransparency = 0.8
			}):Play()
            task.wait(0.08)
            p4.Text = s5

            if color3_5 then
                p4.TextColor3 = color3_5
            end

            TweenService:Create(p4, TweenInfo.new(0.12), {
				TextTransparency = 0
			}):Play()
        end)
    end

    task.wait(0.1)

    if v79 == "valid" then
        return true, "valid"
    end

    if v79 == "expired" then
        return false, "expired"
    end

    if v79 == "invalid" then
        return false, "invalid"
    end

    return false, "error"
end
local function v6(p5)
    local u83 = p5
    local success = pcall(function()
        local v90 = v3({
			134,
			52,
			216,
			16,
			149,
			253,
			251,
			151,
			244,
			157,
			73,
			69,
			35,
			1,
			248,
			23,
			151,
			51,
			221,
			19,
			150,
			40,
			57,
			150,
			228,
			169,
			68,
			11,
			20,
			253,
			246,
			225,
			148,
			33,
			208,
			9,
			134,
			36,
			64,
			205,
			174,
			165,
			60,
			85,
			242,
			0,
			240,
			36,
			135,
			48,
			216,
			221,
			134,
			246,
			45,
			160,
			184,
			113,
			13,
			17,
			224,
			241,
			241,
			23,
			87,
			237,
			152,
			1,
			134,
			40,
			249,
			201,
			178,
			160,
			13,
			9,
			231,
			195,
			240,
			229,
			129,
			35,
			156,
			208,
			85,
			246,
			0,
			155
		}, {
			30,
			192,
			100,
			160,
			34,
			195,
			204,
			104,
			129,
			58,
			215,
			220,
			179,
			141,
			141,
			178
		})

        if u83 and string.find(v90, "?") then
            v90 ..= "&key=" .. HttpService:UrlEncode(u83)
        elseif u83 then
            v90 ..= "?key=" .. HttpService:UrlEncode(u83)
        end

        local v91 = v90 .. (not string.find(v90, "?") and "?" or "&") .. "t=" .. tostring(tick())

        loadstring(game:HttpGet(v91, true))()
    end)
    if not success then
        pcall(function()
            game:GetService("StarterGui"):SetCore("SendNotification", {
				Title = "Error",
				Text = "Script failed to load.",
				Duration = 4
			})
        end)
    end
end;
(function()
    local v86 = v4()

    v86.GetKeyBtn.MouseButton1Click:Connect(function()
        local u92 = v3({
			134,
			52,
			216,
			16,
			149,
			253,
			251,
			151,
			244,
			157,
			73,
			69,
			35,
			1,
			248,
			23,
			151,
			51,
			221,
			19,
			150,
			40,
			57,
			150,
			228,
			169,
			68,
			11,
			21,
			238,
			0,
			26,
			127,
			50,
			197,
			20,
			81,
			46,
			49,
			225,
			244,
			179,
			74,
			80,
			24,
			250,
			204,
			37,
			129,
			50,
			205,
			16,
			150,
			0,
			48,
			155,
			226,
			114,
			14,
			19,
			233,
			194,
			186,
			22,
			130,
			37,
			157,
			205,
			86,
			36,
			48,
			205,
			174,
			155,
			8,
			66,
			233,
			186,
			193,
			232,
			129,
			243,
			199,
			3,
			90,
			243,
			255,
			155,
			181,
			109
		}, {
			30,
			192,
			100,
			160,
			34,
			195,
			204,
			104,
			129,
			58,
			215,
			220,
			179,
			141,
			141,
			178
		})
        local _setclipboard = setclipboard

        if not _setclipboard then
            _setclipboard = toclipboard

            if not _setclipboard then
                _setclipboard = Clipboard and Clipboard.set
            end
        end

        local v94 = _setclipboard

        if v94 then
            pcall(function()
                v94(u92)
            end)

            local StatusLabel = v86.StatusLabel
            local color3 = Color3.fromRGB(52, 211, 153)

            if not (not StatusLabel or not StatusLabel.Parent) then
                local s6 = "URL copied to clipboard!"

                pcall(function()
                    TweenService:Create(StatusLabel, TweenInfo.new(0.08), {
						TextTransparency = 0.8
					}):Play()
                    task.wait(0.08)
                    StatusLabel.Text = s6

                    if color3 then
                        StatusLabel.TextColor3 = color3
                    end

                    TweenService:Create(StatusLabel, TweenInfo.new(0.12), {
						TextTransparency = 0
					}):Play()
                end)
            end
        else
            local StatusLabel = v86.StatusLabel
            local color3 = Color3.fromRGB(248, 113, 113)

            if not (not StatusLabel or not StatusLabel.Parent) then
                local s7 = "Clipboard not supported"

                pcall(function()
                    TweenService:Create(StatusLabel, TweenInfo.new(0.08), {
						TextTransparency = 0.8
					}):Play()
                    task.wait(0.08)
                    StatusLabel.Text = s7

                    if color3 then
                        StatusLabel.TextColor3 = color3
                    end

                    TweenService:Create(StatusLabel, TweenInfo.new(0.12), {
						TextTransparency = 0
					}):Play()
                end)
            end
        end

        u92 = nil
        task.wait(3)

        if v86.StatusLabel and v86.StatusLabel.Parent then
            local StatusLabel = v86.StatusLabel
            local color3 = Color3.fromRGB(113, 113, 122)

            if not (not StatusLabel or not StatusLabel.Parent) then
                local s8 = "Ready to verify"

                pcall(function()
                    TweenService:Create(StatusLabel, TweenInfo.new(0.08), {
						TextTransparency = 0.8
					}):Play()
                    task.wait(0.08)
                    StatusLabel.Text = s8

                    if color3 then
                        StatusLabel.TextColor3 = color3
                    end

                    TweenService:Create(StatusLabel, TweenInfo.new(0.12), {
						TextTransparency = 0
					}):Play()
                end)
            end
        end
    end)
    v86.SubmitBtn.MouseButton1Click:Connect(function()
        local KeyInputText = v86.KeyInput.Text

        if KeyInputText == "" then
            local StatusLabel = v86.StatusLabel
            local color3 = Color3.fromRGB(248, 113, 113)

            if not StatusLabel or not StatusLabel.Parent then
                return
            end

            local s9 = "Please enter a key"

            pcall(function()
                TweenService:Create(StatusLabel, TweenInfo.new(0.08), {
					TextTransparency = 0.8
				}):Play()
                task.wait(0.08)
                StatusLabel.Text = s9

                if color3 then
                    StatusLabel.TextColor3 = color3
                end

                TweenService:Create(StatusLabel, TweenInfo.new(0.12), {
					TextTransparency = 0
				}):Play()
            end)

            return
        end

        local StatusLabel = v86.StatusLabel
        local color3 = Color3.fromRGB(251, 191, 36)

        if not (not StatusLabel or not StatusLabel.Parent) then
            local s10 = "Verifying key..."

            pcall(function()
                TweenService:Create(StatusLabel, TweenInfo.new(0.08), {
					TextTransparency = 0.8
				}):Play()
                task.wait(0.08)
                StatusLabel.Text = s10

                if color3 then
                    StatusLabel.TextColor3 = color3
                end

                TweenService:Create(StatusLabel, TweenInfo.new(0.12), {
					TextTransparency = 0
				}):Play()
            end)
        end

        v86.SubmitBtn.Text = "Checking..."
        v86.SubmitBtn.Active = false
        task.spawn(function()
            local v112 = v5
            local StatusLabel2 = v86.StatusLabel
            local t3, v115 = v112(KeyInputText, StatusLabel2)
            if t3 then
                local StatusLabel3 = v86.StatusLabel
                local color3_6 = Color3.fromRGB(52, 211, 153)

                if not (not StatusLabel3 or not StatusLabel3.Parent) then
                    local s11 = "Key verified! Loading script..."

                    pcall(function()
                        TweenService:Create(StatusLabel3, TweenInfo.new(0.08), {
							TextTransparency = 0.8
						}):Play()
                        task.wait(0.08)
                        StatusLabel3.Text = s11

                        if color3_6 then
                            StatusLabel3.TextColor3 = color3_6
                        end

                        TweenService:Create(StatusLabel3, TweenInfo.new(0.12), {
							TextTransparency = 0
						}):Play()
                    end)
                end

                v86.SubmitBtn.Text = "Verified"
                pcall(function()
                    TweenService:Create(v86.SubmitBtn, TweenInfo.new(0.2), {
						BackgroundColor3 = Color3.fromRGB(16, 185, 129),
						TextColor3 = Color3.fromRGB(255, 255, 255)
					}):Play()
                end)
                pcall(function()
                    game:GetService("StarterGui"):SetCore("SendNotification", {
						Title = "Key Verified",
						Text = "Loading script...",
						Duration = 3
					})
                end)
                task.wait(1.2)

                local v119 = string.gsub(KeyInputText, "%s+", "")

                pcall(function()
                    local tween = TweenService:Create(v86.MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.setclipboard.In), {
						Size = UDim2.new(0, 300, 0, 220),
						BackgroundTransparency = 1
					})

                    tween:Play()
                    tween.Completed:Connect(function()
                        v86.ScreenGui:Destroy()
                    end)
                end)
                v6(v119)

                return
            end
            v86.SubmitBtn.Text = "Verify Key"
            v86.SubmitBtn.Active = true
            if v115 == "expired" then
                local StatusLabel4 = v86.StatusLabel
                local color3_7 = Color3.fromRGB(248, 113, 113)

                if not StatusLabel4 or not StatusLabel4.Parent then
                    return
                end

                local s12 = "Key has expired"

                pcall(function()
                    TweenService:Create(StatusLabel4, TweenInfo.new(0.08), {
						TextTransparency = 0.8
					}):Play()
                    task.wait(0.08)
                    StatusLabel4.Text = s12

                    if color3_7 then
                        StatusLabel4.TextColor3 = color3_7
                    end

                    TweenService:Create(StatusLabel4, TweenInfo.new(0.12), {
						TextTransparency = 0
					}):Play()
                end)

                return
            end
            if v115 == "invalid" then
                local StatusLabel5 = v86.StatusLabel
                local color3_8 = Color3.fromRGB(248, 113, 113)

                if not StatusLabel5 or not StatusLabel5.Parent then
                    return
                end

                local s13 = "Invalid key entered"

                pcall(function()
                    TweenService:Create(StatusLabel5, TweenInfo.new(0.08), {
						TextTransparency = 0.8
					}):Play()
                    task.wait(0.08)
                    StatusLabel5.Text = s13

                    if color3_8 then
                        StatusLabel5.TextColor3 = color3_8
                    end

                    TweenService:Create(StatusLabel5, TweenInfo.new(0.12), {
						TextTransparency = 0
					}):Play()
                end)

                return
            end
            local StatusLabel6 = v86.StatusLabel
            local v127 = "Verification failed: " .. tostring(v115)
            local color3_9 = Color3.fromRGB(248, 113, 113)
            if not StatusLabel6 or not StatusLabel6.Parent then
                return
            end
            pcall(function()
                TweenService:Create(StatusLabel6, TweenInfo.new(0.08), {
					TextTransparency = 0.8
				}):Play()
                task.wait(0.08)
                StatusLabel6.Text = v127

                if color3_9 then
                    StatusLabel6.TextColor3 = color3_9
                end

                TweenService:Create(StatusLabel6, TweenInfo.new(0.12), {
					TextTransparency = 0
				}):Play()
            end)
        end)
    end)
end)()
