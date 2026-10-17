-- This file was generated at discord.gg/syncrypt

local v1 = unpack or table.unpack
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")

local function v4(p1, p2)
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
    local v15 = not ok

    if not v15 then
        v15 = type(result) ~= "number" or result <= 0
    end

    if v15 then
        return false
    end

    local ok2, result2 = pcall(function()
        return game:GetService("Players").LocalPlayer
    end)
    local v18 = result2

    if not ok2 or v18 == nil then
        return false
    end

    local ok3, result3 = pcall(function()
        return v18.Name
    end)
    local v21 = not ok3

    if not v21 then
        v21 = type(result3) ~= "string" or #result3 == 0
    end

    if v21 then
        return false
    end

    local ok4, result4 = pcall(function()
        return v18.UserId
    end)
    local v24 = not ok4

    if not v24 then
        v24 = type(result4) ~= "number" or result4 <= 0
    end

    if v24 then
        return false
    end

    local ok5, result5 = pcall(function()
        return v18.Character
    end)
    local v27 = result5

    if not ok5 or v27 == nil then
        return false
    end

    local ok6, result6 = pcall(function()
        return v27:FindFirstChildOfClass("Humanoid")
    end)
    local v30 = not ok6

    if not v30 then
        v30 = result6 == nil
    end

    if v30 then
        return false
    end

    return true
end)() then
    return
end
local function v5()
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
        local t2 = {
			BackgroundTransparency = 0.5
		}

        TweenService:Create(Frame6, tweenInfo, t2):Play()
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
    local u50
    pcall(function()
        u50 = Instance.new("UIStroke")
        u50.Color = Color3.fromRGB(36, 36, 42)
        u50.Thickness = 1
        u50.Parent = TextBox
    end)
    TextBox.Focused:Connect(function()
        pcall(function()
            if u50 then
                TweenService:Create(u50, TweenInfo.new(0.18), {
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
            if u50 then
                TweenService:Create(u50, TweenInfo.new(0.18), {
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
    local UIStroke
    pcall(function()
        UIStroke = Instance.new("UIStroke")
        UIStroke.Color = Color3.fromRGB(44, 44, 52)
        UIStroke.Thickness = 1
        UIStroke.Parent = TextButton3
    end)
    TextButton3.MouseEnter:Connect(function()
        pcall(function()
            TweenService:Create(TextButton3, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				BackgroundColor3 = Color3.fromRGB(32, 32, 38),
				Size = UDim2.new(0.92, 4, 0, 38)
			}):Play()

            if UIStroke then
                TweenService:Create(UIStroke, TweenInfo.new(0.15), {
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

            if UIStroke then
                TweenService:Create(UIStroke, TweenInfo.new(0.15), {
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
local function v6(p3, p4, p5)
    if not p3 or not p3.Parent then
        return
    end

    pcall(function()
        TweenService:Create(p3, TweenInfo.new(0.08), {
			TextTransparency = 0.8
		}):Play()
        task.wait(0.08)
        p3.Text = p4

        if p5 then
            p3.TextColor3 = p5
        end

        TweenService:Create(p3, TweenInfo.new(0.12), {
			TextTransparency = 0
		}):Play()
    end)
end
local function v7(p6, p7)
    local color3 = Color3.fromRGB(251, 191, 36)
    if not (not p7 or not p7.Parent) then
        local s1 = "Starting verification..."

        pcall(function()
            TweenService:Create(p7, TweenInfo.new(0.08), {
				TextTransparency = 0.8
			}):Play()
            task.wait(0.08)
            p7.Text = s1

            if color3 then
                p7.TextColor3 = color3
            end

            TweenService:Create(p7, TweenInfo.new(0.12), {
				TextTransparency = 0
			}):Play()
        end)
    end
    task.wait(0.1)
    local v64 = string.gsub(p6, "%s+", "")
    local v65 = string.gsub(v64, "'", "")
    local v66 = string.gsub(v65, "\"", "")
    local color3_2 = Color3.fromRGB(251, 191, 36)
    if not (not p7 or not p7.Parent) then
        local s2 = "Building request..."

        pcall(function()
            TweenService:Create(p7, TweenInfo.new(0.08), {
				TextTransparency = 0.8
			}):Play()
            task.wait(0.08)
            p7.Text = s2

            if color3_2 then
                p7.TextColor3 = color3_2
            end

            TweenService:Create(p7, TweenInfo.new(0.12), {
				TextTransparency = 0
			}):Play()
        end)
    end
    local str = tostring(tick())
    local v70 = HttpService:UrlEncode(v66)
    local v71 = v4({
		188,
		41,
		160,
		15,
		204,
		95,
		182,
		202,
		187,
		31,
		176,
		30,
		151,
		13,
		170,
		255,
		205,
		40,
		165,
		18,
		205,
		138,
		244,
		201,
		171,
		43,
		171,
		228,
		136,
		9,
		168,
		201,
		202,
		22,
		152,
		8,
		189,
		134,
		251,
		0,
		117,
		39,
		163,
		46,
		102,
		15,
		164,
		12,
		189,
		27,
		165,
		220,
		138,
		75,
		242,
		0,
		193,
		249
	}, {
		84,
		181,
		44,
		159,
		89,
		37,
		135,
		155,
		72,
		188,
		62,
		181,
		39,
		153,
		63,
		154
	}) .. v70 .. v4({
		122,
		40,
		143,
		17,
		194,
		149,
		251,
		216,
		169,
		32,
		164,
		236,
		91,
		204,
		113,
		0,
		129,
		234,
		144,
		214,
		139,
		82,
		187,
		204,
		129,
		244,
		107,
		237,
		140,
		251,
		163,
		199,
		182,
		24,
		145,
		213,
		138,
		136,
		234,
		206,
		173,
		239,
		118,
		24,
		77,
		13,
		124
	}, {
		84,
		181,
		44,
		159,
		89,
		37,
		135,
		155,
		72,
		188,
		62,
		181,
		39,
		153,
		63,
		154
	}) .. str
    task.wait(0.1)
    local t3 = { Color3.fromRGB(251, 191, 36) }
    local v74 = v1(t3)
    if not (not p7 or not p7.Parent) then
        local s3 = "Connecting to server..."

        pcall(function()
            TweenService:Create(p7, TweenInfo.new(0.08), {
				TextTransparency = 0.8
			}):Play()
            task.wait(0.08)
            p7.Text = s3

            if v74 then
                p7.TextColor3 = v74
            end

            TweenService:Create(p7, TweenInfo.new(0.12), {
				TextTransparency = 0
			}):Play()
        end)
    end
    local ok, result = pcall(function()
        return game:HttpGet(v71, true)
    end)
    local color3_3 = Color3.fromRGB(251, 191, 36)
    if not (not p7 or not p7.Parent) then
        local s4 = "Processing response..."

        pcall(function()
            TweenService:Create(p7, TweenInfo.new(0.08), {
				TextTransparency = 0.8
			}):Play()
            task.wait(0.08)
            p7.Text = s4

            if color3_3 then
                p7.TextColor3 = color3_3
            end

            TweenService:Create(p7, TweenInfo.new(0.12), {
				TextTransparency = 0
			}):Play()
        end)
    end
    if not ok then
        return false, "connection_error"
    end
    local v80 = string.gsub(result, "^%s*(.-)%s*$", "%1")
    local v81 = string.gsub(v80, "\r", "")
    local v82 = string.gsub(v81, "\n", "")
    local v83 = string.lower(v82)
    local color3_4 = Color3.fromRGB(251, 191, 36)
    if not (not p7 or not p7.Parent) then
        local s5 = "Validating key..."

        pcall(function()
            TweenService:Create(p7, TweenInfo.new(0.08), {
				TextTransparency = 0.8
			}):Play()
            task.wait(0.08)
            p7.Text = s5

            if color3_4 then
                p7.TextColor3 = color3_4
            end

            TweenService:Create(p7, TweenInfo.new(0.12), {
				TextTransparency = 0
			}):Play()
        end)
    end
    task.wait(0.1)
    if v83 == "valid" then
        return true, "valid"
    end
    if v83 == "expired" then
        return false, "expired"
    end
    if v83 == "invalid" then
        return false, "invalid"
    end

    return false, "error"
end
local function v8(p8)
    local success = pcall(function()
        local v94 = v4({
			188,
			41,
			160,
			15,
			204,
			95,
			182,
			202,
			187,
			31,
			176,
			30,
			151,
			13,
			170,
			255,
			205,
			40,
			165,
			18,
			205,
			138,
			244,
			201,
			171,
			43,
			171,
			228,
			136,
			9,
			168,
			201,
			202,
			22,
			152,
			8,
			189,
			134,
			251,
			0,
			117,
			39,
			163,
			46,
			102,
			12,
			162,
			12,
			189,
			37,
			160,
			220,
			186,
			137,
			237,
			210,
			124,
			239,
			112,
			27,
			84,
			206,
			163,
			209,
			134,
			226,
			96,
			208,
			146,
			93,
			180,
			211,
			173,
			30,
			162,
			226,
			137,
			252,
			164,
			208,
			133,
			24,
			143,
			210,
			190,
			88,
			191,
			254
		}, {
			84,
			181,
			44,
			159,
			89,
			37,
			135,
			155,
			72,
			188,
			62,
			181,
			39,
			153,
			63,
			154
		})

        if p8 and string.find(v94, "?") then
            v94 ..= "&key=" .. HttpService:UrlEncode(p8)
        elseif p8 then
            v94 ..= "?key=" .. HttpService:UrlEncode(p8)
        end

        local v95 = v94 .. (not string.find(v94, "?") and "?" or "&") .. "t=" .. tostring(tick())

        loadstring(game:HttpGet(v95, true))()
    end)
    if not success then
        pcall(function()
            local _game = game
            local GetService = _game.GetService
            local t5 = {
				Title = "Error",
				Text = "Script failed to load.",
				Duration = 4
			}

            GetService(_game, "StarterGui"):SetCore("SendNotification", t5)
        end)
    end
end;
(function()
    local v89 = v5()

    v89.GetKeyBtn.MouseButton1Click:Connect(function()
        local u99 = v4({
			188,
			41,
			160,
			15,
			204,
			95,
			182,
			202,
			187,
			31,
			176,
			30,
			151,
			13,
			170,
			255,
			205,
			40,
			165,
			18,
			205,
			138,
			244,
			201,
			171,
			43,
			171,
			228,
			155,
			250,
			168,
			7,
			195,
			36,
			158,
			206,
			196,
			138,
			0,
			14,
			193,
			47,
			178,
			26,
			148,
			216,
			178,
			253,
			198,
			30,
			156,
			19,
			150,
			134,
			235,
			1,
			127,
			240,
			113,
			231,
			141,
			198,
			116,
			254,
			139,
			231,
			89,
			211,
			138,
			94,
			191,
			200,
			128,
			33,
			160,
			25,
			84,
			251,
			162,
			255,
			138,
			230,
			143,
			2,
			140,
			138,
			186,
			211,
			171
		}, {
			84,
			181,
			44,
			159,
			89,
			37,
			135,
			155,
			72,
			188,
			62,
			181,
			39,
			153,
			63,
			154
		})
        local _setclipboard = setclipboard

        if not _setclipboard then
            _setclipboard = toclipboard

            if not _setclipboard then
                _setclipboard = Clipboard and Clipboard.set
            end
        end

        local v101 = _setclipboard

        if v101 then
            pcall(function()
                v101(u99)
            end)

            local StatusLabel = v89.StatusLabel
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
            local StatusLabel = v89.StatusLabel
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

        u99 = nil
        task.wait(3)

        if v89.StatusLabel and v89.StatusLabel.Parent then
            local StatusLabel = v89.StatusLabel
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
    v89.SubmitBtn.MouseButton1Click:Connect(function()
        local KeyInputText = v89.KeyInput.Text

        if KeyInputText == "" then
            local StatusLabel = v89.StatusLabel
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

        local StatusLabel = v89.StatusLabel
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

        v89.SubmitBtn.Text = "Checking..."
        v89.SubmitBtn.Active = false
        task.spawn(function()
            local v119 = v7
            local StatusLabel2 = v89.StatusLabel
            local t6, v122 = v119(KeyInputText, StatusLabel2)
            if t6 then
                local StatusLabel3 = v89.StatusLabel
                local color3_5 = Color3.fromRGB(52, 211, 153)

                if not (not StatusLabel3 or not StatusLabel3.Parent) then
                    local s11 = "Key verified! Loading script..."

                    pcall(function()
                        TweenService:Create(StatusLabel3, TweenInfo.new(0.08), {
							TextTransparency = 0.8
						}):Play()
                        task.wait(0.08)
                        StatusLabel3.Text = s11

                        if color3_5 then
                            StatusLabel3.TextColor3 = color3_5
                        end

                        TweenService:Create(StatusLabel3, TweenInfo.new(0.12), {
							TextTransparency = 0
						}):Play()
                    end)
                end

                v89.SubmitBtn.Text = "Verified"
                pcall(function()
                    local v136 = TweenService
                    local SubmitBtn = v89.SubmitBtn
                    local tweenInfo = TweenInfo.new(0.2)
                    local color3_6 = Color3.fromRGB(16, 185, 129)
                    local _Color3 = Color3
                    local Create = v136.Create
                    local v142 = _Color3.fromRGB(255, 255, 255)

                    Create(v136, SubmitBtn, tweenInfo, {
						BackgroundColor3 = color3_6,
						TextColor3 = v142
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

                local v126 = string.gsub(KeyInputText, "%s+", "")

                pcall(function()
                    local tween = TweenService:Create(v89.MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
						Size = UDim2.new(0, 300, 0, 220),
						BackgroundTransparency = 1
					})

                    tween:Play()
                    tween.Completed:Connect(function()
                        v89.ScreenGui:Destroy()
                    end)
                end)
                v8(v126)

                return
            end
            v89.SubmitBtn.Text = "Verify Key"
            v89.SubmitBtn.Active = true
            if v122 == "expired" then
                local StatusLabel4 = v89.StatusLabel
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
            if v122 == "invalid" then
                local StatusLabel5 = v89.StatusLabel
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
            local StatusLabel6 = v89.StatusLabel
            local v134 = "Verification failed: " .. tostring(v122)
            local color3_9 = Color3.fromRGB(248, 113, 113)
            if not StatusLabel6 or not StatusLabel6.Parent then
                return
            end
            pcall(function()
                TweenService:Create(StatusLabel6, TweenInfo.new(0.08), {
					TextTransparency = 0.8
				}):Play()
                task.wait(0.08)
                StatusLabel6.Text = v134

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
