local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local COLORS = {
    bg = Color3.fromRGB(14, 14, 16),
        surface = Color3.fromRGB(22, 22, 26),
            disabled = Color3.fromRGB(38, 38, 44),
                border = Color3.fromRGB(60, 60, 68),
                    accent = Color3.fromRGB(230, 35, 35),
                        accentDark = Color3.fromRGB(170, 22, 22),
                            accentBright = Color3.fromRGB(255, 70, 70),
                                crimson = Color3.fromRGB(110, 15, 15),
                                    text = Color3.fromRGB(238, 238, 242),
                                        white = Color3.fromRGB(255, 255, 255),
                                            black = Color3.fromRGB(0, 0, 0),
                                            }

                                            local FONT = Enum.Font.GothamBlack

                                            -- ── GUI ──────────────────────────────────────────────────────────────────────

                                            local screenGui = Instance.new("ScreenGui")
                                            screenGui.Name = "RejoinUI"
                                            screenGui.ResetOnSpawn = false
                                            screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
                                            screenGui.IgnoreGuiInset = true
                                            screenGui.Parent = playerGui

                                            local main = Instance.new("Frame")
                                            main.Name = "MainFrame"
                                            main.Size = UDim2.new(0, 210, 0, 92)
                                            main.Position = UDim2.new(0.5, 0, 0.5, 0)
                                            main.AnchorPoint = Vector2.new(0.5, 0.5)
                                            main.BackgroundColor3 = COLORS.bg
                                            main.BorderSizePixel = 0
                                            main.ClipsDescendants = false
                                            main.Parent = screenGui

                                            local mainCorner = Instance.new("UICorner")
                                            mainCorner.CornerRadius = UDim.new(0, 10)
                                            mainCorner.Parent = main

                                            local mainGrad = Instance.new("UIGradient")
                                            mainGrad.Color = ColorSequence.new(COLORS.bg, Color3.fromRGB(22, 14, 14))
                                            mainGrad.Rotation = 135
                                            mainGrad.Parent = main

                                            local borderFrame = Instance.new("Frame")
                                            borderFrame.Name = "BorderFrame"
                                            borderFrame.Size = UDim2.new(1, 2, 1, 2)
                                            borderFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
                                            borderFrame.AnchorPoint = Vector2.new(0.5, 0.5)
                                            borderFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                                            borderFrame.BorderSizePixel = 0
                                            borderFrame.ZIndex = 0
                                            borderFrame.Parent = main

                                            local borderCorner = Instance.new("UICorner")
                                            borderCorner.CornerRadius = UDim.new(0, 11)
                                            borderCorner.Parent = borderFrame

                                            local borderGrad = Instance.new("UIGradient")
                                            borderGrad.Color = ColorSequence.new({
                                                ColorSequenceKeypoint.new(0.0, Color3.fromRGB(40, 5, 5)),
                                                    ColorSequenceKeypoint.new(0.25, Color3.fromRGB(180, 20, 20)),
                                                        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 90, 90)),
                                                            ColorSequenceKeypoint.new(0.75, Color3.fromRGB(180, 20, 20)),
                                                                ColorSequenceKeypoint.new(1.0, Color3.fromRGB(40, 5, 5)),
                                                                })
                                                                borderGrad.Rotation = 0
                                                                borderGrad.Parent = borderFrame

                                                                local innerMask = Instance.new("Frame")
                                                                innerMask.Name = "InnerMask"
                                                                innerMask.Size = UDim2.new(1, -2, 1, -2)
                                                                innerMask.Position = UDim2.new(0.5, 0, 0.5, 0)
                                                                innerMask.AnchorPoint = Vector2.new(0.5, 0.5)
                                                                innerMask.BackgroundColor3 = COLORS.bg
                                                                innerMask.BorderSizePixel = 0
                                                                innerMask.ZIndex = 1
                                                                innerMask.Parent = main

                                                                local innerCorner = Instance.new("UICorner")
                                                                innerCorner.CornerRadius = UDim.new(0, 9)
                                                                innerCorner.Parent = innerMask

                                                                local innerGrad = Instance.new("UIGradient")
                                                                innerGrad.Color = ColorSequence.new(COLORS.bg, Color3.fromRGB(22, 14, 14))
                                                                innerGrad.Rotation = 135
                                                                innerGrad.Parent = innerMask

                                                                local title = Instance.new("TextLabel")
                                                                title.Name = "Title"
                                                                title.Size = UDim2.new(1, 0, 0, 34)
                                                                title.Position = UDim2.new(0, 0, 0, 0)
                                                                title.BackgroundTransparency = 1
                                                                title.Font = FONT
                                                                title.Text = "Instant Rejoin"
                                                                title.TextColor3 = COLORS.text
                                                                title.TextSize = 14
                                                                title.TextXAlignment = Enum.TextXAlignment.Center
                                                                title.ZIndex = 3
                                                                title.Parent = main

                                                                local toggle = Instance.new("TextButton")
                                                                toggle.Name = "Toggle"
                                                                toggle.Size = UDim2.new(1, -20, 0, 38)
                                                                toggle.Position = UDim2.new(0, 10, 0, 44)
                                                                toggle.BackgroundColor3 = COLORS.accent
                                                                toggle.BorderSizePixel = 0
                                                                toggle.Font = FONT
                                                                toggle.Text = ""
                                                                toggle.TextTransparency = 1
                                                                toggle.AutoButtonColor = false
                                                                toggle.ZIndex = 3
                                                                toggle.Parent = main

                                                                local toggleCorner = Instance.new("UICorner")
                                                                toggleCorner.CornerRadius = UDim.new(0, 8)
                                                                toggleCorner.Parent = toggle

                                                                local toggleGrad = Instance.new("UIGradient")
                                                                toggleGrad.Color = ColorSequence.new(COLORS.accent, COLORS.accentBright)
                                                                toggleGrad.Rotation = 135
                                                                toggleGrad.Parent = toggle

                                                                local toggleStroke = Instance.new("UIStroke")
                                                                toggleStroke.Color = COLORS.accentBright
                                                                toggleStroke.Thickness = 1.66
                                                                toggleStroke.Transparency = 0
                                                                toggleStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                                                                toggleStroke.Parent = toggle

                                                                local toggleLabel = Instance.new("TextLabel")
                                                                toggleLabel.Name = "Label"
                                                                toggleLabel.Size = UDim2.new(1, 0, 1, 0)
                                                                toggleLabel.Position = UDim2.new(0, 0, 0, 0)
                                                                toggleLabel.BackgroundTransparency = 1
                                                                toggleLabel.Font = FONT
                                                                toggleLabel.Text = "REJOIN"
                                                                toggleLabel.TextColor3 = COLORS.black
                                                                toggleLabel.TextTransparency = 0
                                                                toggleLabel.TextSize = 14
                                                                toggleLabel.TextXAlignment = Enum.TextXAlignment.Center
                                                                toggleLabel.TextYAlignment = Enum.TextYAlignment.Center
                                                                toggleLabel.ZIndex = 5
                                                                toggleLabel.Active = false
                                                                toggleLabel.Parent = toggle

                                                                -- ── Border spin (idle) ────────────────────────────────────────────────────────

                                                                RunService.RenderStepped:Connect(function(dt)
                                                                    borderGrad.Rotation = (borderGrad.Rotation + 60 * dt) % 360
                                                                    end)

                                                                    -- ── Rejoin logic ──────────────────────────────────────────────────────────────

                                                                    toggle.MouseButton1Click:Connect(function()
                                                                        toggleLabel.Text = "..."
                                                                            toggle.BackgroundColor3 = COLORS.disabled
                                                                                toggleGrad.Color = ColorSequence.new(COLORS.disabled, Color3.fromRGB(48, 48, 54))
                                                                                    toggleStroke.Color = COLORS.crimson
                                                                                        toggleLabel.TextColor3 = COLORS.white
                                                                                            task.wait(0.1)
                                                                                                pcall(function()
                                                                                                        TeleportService:Teleport(game.PlaceId, player)
                                                                                                            end)
                                                                                                            end)

                                                                                                            -- ── Drag ──────────────────────────────────────────────────────────────────────

                                                                                                            local dragging = false
                                                                                                            local dragStart, startPos

                                                                                                            main.InputBegan:Connect(function(input)
                                                                                                                if input.UserInputType == Enum.UserInputType.MouseButton1
                                                                                                                    or input.UserInputType == Enum.UserInputType.Touch then
                                                                                                                            dragging = true
                                                                                                                                    dragStart = input.Position
                                                                                                                                            startPos = main.Position
                                                                                                                                                end
                                                                                                                                                end)

                                                                                                                                                UserInputService.InputChanged:Connect(function(input)
                                                                                                                                                    if dragging and (
                                                                                                                                                            input.UserInputType == Enum.UserInputType.MouseMovement
                                                                                                                                                                    or input.UserInputType == Enum.UserInputType.Touch
                                                                                                                                                                        ) then
                                                                                                                                                                                local delta = input.Position - dragStart
                                                                                                                                                                                        main.Position = UDim2.new(
                                                                                                                                                                                                    startPos.X.Scale, startPos.X.Offset + delta.X,
                                                                                                                                                                                                                startPos.Y.Scale, startPos.Y.Offset + delta.Y
                                                                                                                                                                                                                        )
                                                                                                                                                                                                                            end
                                                                                                                                                                                                                            end)

                                                                                                                                                                                                                            UserInputService.InputEnded:Connect(function(input)
                                                                                                                                                                                                                                if input.UserInputType == Enum.UserInputType.MouseButton1
                                                                                                                                                                                                                                    or input.UserInputType == Enum.UserInputType.Touch then
                                                                                                                                                                                                                                            dragging = false
                                                                                                                                                                                                                                                end
                                                                                                                                                                                                                                                end)