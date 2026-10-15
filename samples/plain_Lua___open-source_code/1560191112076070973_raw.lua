local U62, U63, U64, U65, U66, U67, U68, U69, U70, U71
local U72, U73, U74, U75, U76, U77, U78, U79, U80, U81
local U82, U83, U84, U85, U86, L0_312, U87, U88, U89, U90
local U91, U92, U93, U94, U95, U96, U97, U98, U99, U100

do
	do
		if game.PlaceId ~= 6961824067 then
			-- game:GetService("Players").LocalPlayer:Kick("FTAP SCRIPT")
			-- return
		end

		pcall(function()
			if getgenv then
				if typeof(getgenv().SilentTarget_Unload) == "function" then
					pcall(getgenv().SilentTarget_Unload)
					getgenv().SilentTarget_Unload = nil
				end

				if getgenv().SilentTarget_Library and typeof(getgenv().SilentTarget_Library.Unload) == "function" then
					pcall(function()
						getgenv().SilentTarget_Library:Unload()
					end)

					getgenv().SilentTarget_Library = nil
				end
			end

			local L97_1 = typeof(gethui) == "function" and gethui() or game:GetService("CoreGui")

			if L97_1 then
				for I41, I42 in ipairs(L97_1:GetChildren()) do
					if I42.Name == "ST_WatermarkFrame" or I42.Name == "ST_IronManHUD" or I42.Name == "Obsidian" or I42.Name:find("SilentTarget") or I42.Name:find("Obsidian") or I42.Name == "NeuroniumStickyUI" or I42.Name == "FakePosUI" or I42.Name:find("urban1") then
						pcall(function()
							I42:Destroy()
						end)
					end
				end
			end

			local U101 = workspace:FindFirstChild("ST_IronManSuitContainer")

			if U101 then
				pcall(function()
					U101:Destroy()
				end)
			end
		end)

		loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
		U62 = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/main/Library.lua"))()
		U63 = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/main/addons/ThemeManager.lua"))()
		U64 = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/main/addons/SaveManager.lua"))()
		U65 = U62.Options
		U66 = U62.Toggles

		pcall(function()
			local U102 = U62.GetCustomIcon

			U62.GetCustomIcon = function(A102_1, A102_2)
				local L102_1 = U102(A102_1, A102_2)

				if not L102_1 and U62.GetIcon and typeof(A102_2) == "string" then
					L102_1 = U62:GetIcon(A102_2)
				end

				return L102_1
			end
		end)

		U62.CornerRadius = 20

		pcall(function()
			U63:SetLibrary(U62)
			U63:SetFolder("SilentTarget")

			U63:SetDefaultTheme({
				FontColor = Color3.fromHex("ffffff"),
				MainColor = Color3.fromHex("111111"),
				AccentColor = Color3.fromHex("ffffff"),
				BackgroundColor = Color3.fromHex("0a0a0a"),
				OutlineColor = Color3.fromHex("292929"),
				FontFace = Enum.Font.Gotham,
			})

			U62.Scheme.AccentColor = Color3.fromHex("ffffff")
			U62.Scheme.OutlineColor = Color3.fromHex("292929")
			U62.Scheme.MainColor = Color3.fromHex("111111")
			U62.Scheme.BackgroundColor = Color3.fromHex("0a0a0a")
			U62.Scheme.FontColor = Color3.fromHex("ffffff")
			U62:SetFont(Enum.Font.Gotham)
			U62:UpdateColorsUsingRegistry()
		end)

		U67 = game:GetService("Players")
		U68 = U67.LocalPlayer
		U69 = game:GetService("RunService")
		U70 = game:GetService("TweenService")
		U71 = game:GetService("Workspace")
		U72 = game:GetService("Debris")
		U73 = game:GetService("ReplicatedStorage")
		U74 = tick()

		do
			local U103 = {
				Active = false,
				Camera = nil,
				LockedCFrame = nil,
				BindName = "ST_SmoothTPRenderLock",
				Depth = 0,
			}

			local function F_000104(A104_1, A104_2)
				if not A104_1 then
					return
				end

				for I43, I44 in ipairs(A104_1:GetDescendants()) do
					if I44:IsA("BasePart") or I44:IsA("Decal") then
						pcall(function()
							I44.LocalTransparencyModifier = A104_2 and 1 or 0
						end)
					end
				end
			end

			local function F_000106()
				if U103.Depth > 0 then
					U103.Depth = U103.Depth - 1
				end

				if U103.Depth > 0 then
					return
				end

				if not U103.Active then
					return
				end
				U103.Active = false

				pcall(function()
					U69:UnbindFromRenderStep(U103.BindName)
				end)

				F_000104(U68.Character, false)

				if U103.Camera then
					pcall(function()
						U103.Camera.CameraType = Enum.CameraType.Custom
					end)
				end

				U103.Camera = nil
				U103.LockedCFrame = nil
			end

			U68.CharacterAdded:Connect(function()
				if U103.Active then
					U103.Depth = 0
					F_000106()
				end
			end)
		end

		do
			local U104 = 0
			local U105 = ""

			U75 = function(A110_1)
				local L110_1 = tick()
				if A110_1.Title == U105 and L110_1 - U104 < 2 then
					return
				end
				U105 = A110_1.Title
				U104 = L110_1
				A110_1.Duration = A110_1.Duration or 2
				U62:Notify(A110_1)
			end
		end

		U76 = "cpu"
		local U106
		U106 = nil
		local U107
		U107 = false
		local U108
		U108 = true
		U77 = nil
		U78 = nil
		U79 = nil
		U80 = nil
		local U109
		U109 = nil
		local U110
		U110 = nil
		local U111
		U111 = nil
		local U112, U113, U114

		do
			local U115 = nil
			U81 = nil
			U82 = nil
			U83 = nil
			local U116 = nil
			local U117 = true
			U84 = nil
			U85 = nil
			local U118 = nil
			U86 = 0
			local U119 = ""
			local U120 = nil

			U112 = function(A111_1)
				local L111_1 = tostring(A111_1 or ""):gsub("^%s*(.-)%s*$", "%1")
				U119 = L111_1

				if U116 then
					if L111_1 ~= "" then
						if tonumber(L111_1) then
							L111_1 = "rbxassetid://" .. L111_1
						end

						U116.Image = L111_1
					else
						U116.Image = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(U68.UserId) .. "&w=150&h=150"
					end
				end
			end

			U113 = function(A112_1)
				U108 = A112_1

				if not A112_1 then
					U107 = false
				end

				if U120 then
					U120()
				end
			end

			U114 = function()
				if U106 then
					return
				end

				pcall(function()
					local L114_1 = U62.ScreenGui and U62.ScreenGui:FindFirstChild("Floats") or U62.ScreenGui or game:GetService("CoreGui")
					local U121 = Instance.new("Frame")
					U121.Name = "ST_CustomWatermark"
					U121.AutomaticSize = Enum.AutomaticSize.XY
					U121.Size = UDim2.fromOffset(0, 0)
					U121.Position = UDim2.fromOffset(20, 20)
					U121.BackgroundColor3 = U62.Scheme.BackgroundColor or Color3.fromHex("0a0a0a")
					U121.BorderSizePixel = 0
					U121.ZIndex = 50
					U121.Parent = L114_1
					local L114_2 = Instance.new("UICorner")
					L114_2.CornerRadius = UDim.new(0, 9)
					L114_2.Parent = U121

					if U62.Corners then
						table.insert(U62.Corners, L114_2)
					end

					local L114_3 = Instance.new("UIStroke")
					L114_3.Color = U62.Scheme.OutlineColor or Color3.fromHex("292929")
					L114_3.Thickness = 1
					L114_3.Parent = U121
					local L114_4 = Instance.new("UIListLayout")
					L114_4.FillDirection = Enum.FillDirection.Vertical
					L114_4.SortOrder = Enum.SortOrder.LayoutOrder
					L114_4.Padding = UDim.new(0, 0)
					L114_4.HorizontalAlignment = Enum.HorizontalAlignment.Left
					L114_4.Parent = U121
					local L114_5 = Instance.new("UIPadding")
					L114_5.PaddingTop = UDim.new(0, 7)
					L114_5.PaddingBottom = UDim.new(0, 7)
					L114_5.PaddingLeft = UDim.new(0, 10)
					L114_5.PaddingRight = UDim.new(0, 10)
					L114_5.Parent = U121
					local U122 = Instance.new("Frame")
					U122.Name = "TopBar"
					U122.BackgroundTransparency = 1
					U122.AutomaticSize = Enum.AutomaticSize.XY
					U122.Size = UDim2.fromOffset(0, 21)
					U122.LayoutOrder = 1
					U122.Parent = U121
					local L114_6 = Instance.new("UIListLayout")
					L114_6.FillDirection = Enum.FillDirection.Horizontal
					L114_6.SortOrder = Enum.SortOrder.LayoutOrder
					L114_6.VerticalAlignment = Enum.VerticalAlignment.Center
					L114_6.Padding = UDim.new(0, 7)
					L114_6.Parent = U122
					local U123 = Instance.new("ImageLabel")
					U123.Name = "CpuIcon"
					U123.BackgroundTransparency = 1
					U123.Size = UDim2.fromOffset(18, 18)
					U123.ImageColor3 = U62.Scheme.FontColor or Color3.new(1, 1, 1)
					U123.LayoutOrder = 1
					U123.Parent = U122

					pcall(function()
						local L115_1 = U62:GetCustomIcon("cpu")

						if L115_1 then
							U62:ApplyLucideIcon(U123, L115_1)
						end
					end)

					local L114_7 = Instance.new("TextLabel")
					L114_7.Name = "TitleLabel"
					L114_7.BackgroundTransparency = 1
					L114_7.AutomaticSize = Enum.AutomaticSize.XY
					L114_7.Font = Enum.Font.GothamBold
					L114_7.Text = "<b>SILENT TARGET</b>"
					L114_7.RichText = true
					L114_7.TextColor3 = U62.Scheme.FontColor or Color3.new(1, 1, 1)
					L114_7.TextSize = 15
					L114_7.LayoutOrder = 2
					L114_7.Parent = U122
					U109 = L114_7
					local L114_8 = Instance.new("TextLabel")
					L114_8.BackgroundTransparency = 1
					L114_8.AutomaticSize = Enum.AutomaticSize.XY
					L114_8.Font = Enum.Font.Gotham
					L114_8.Text = "|"
					L114_8.TextColor3 = Color3.fromRGB(120, 120, 120)
					L114_8.TextSize = 15
					L114_8.LayoutOrder = 3
					L114_8.Parent = U122
					U84 = L114_8
					local U124 = Instance.new("ImageLabel")
					U124.Name = "FpsWarn"
					U124.BackgroundTransparency = 1
					U124.Size = UDim2.fromOffset(11, 11)
					U124.ScaleType = Enum.ScaleType.Fit
					U124.ImageColor3 = Color3.fromRGB(255, 30, 30)
					U124.Visible = false
					U124.LayoutOrder = 4
					U124.Parent = U122

					pcall(function()
						local L116_1 = U62:GetCustomIcon("info")

						if L116_1 then
							U62:ApplyLucideIcon(U124, L116_1)
							U124.ImageColor3 = Color3.fromRGB(255, 30, 30)
						end
					end)

					U77 = U124
					local L114_9 = Instance.new("TextLabel")
					L114_9.Name = "FpsLabel"
					L114_9.BackgroundTransparency = 1
					L114_9.AutomaticSize = Enum.AutomaticSize.XY
					L114_9.Font = Enum.Font.Gotham
					L114_9.Text = "0 fps"
					L114_9.TextColor3 = U62.Scheme.FontColor or Color3.new(1, 1, 1)
					L114_9.TextSize = 15
					L114_9.LayoutOrder = 5
					L114_9.Parent = U122
					U79 = L114_9
					local L114_10 = Instance.new("TextLabel")
					L114_10.BackgroundTransparency = 1
					L114_10.AutomaticSize = Enum.AutomaticSize.XY
					L114_10.Font = Enum.Font.Gotham
					L114_10.Text = "|"
					L114_10.TextColor3 = Color3.fromRGB(120, 120, 120)
					L114_10.TextSize = 15
					L114_10.LayoutOrder = 6
					L114_10.Parent = U122
					U85 = L114_10
					local U125 = Instance.new("ImageLabel")
					U125.Name = "PingWarn"
					U125.BackgroundTransparency = 1
					U125.Size = UDim2.fromOffset(11, 11)
					U125.ScaleType = Enum.ScaleType.Fit
					U125.ImageColor3 = Color3.fromRGB(255, 30, 30)
					U125.Visible = false
					U125.LayoutOrder = 7
					U125.Parent = U122

					pcall(function()
						local L117_1 = U62:GetCustomIcon("wifi-off")

						if L117_1 then
							U62:ApplyLucideIcon(U125, L117_1)
							U125.ImageColor3 = Color3.fromRGB(255, 30, 30)
						end
					end)

					U78 = U125
					local L114_11 = Instance.new("TextLabel")
					L114_11.Name = "PingLabel"
					L114_11.BackgroundTransparency = 1
					L114_11.AutomaticSize = Enum.AutomaticSize.XY
					L114_11.Font = Enum.Font.Gotham
					L114_11.Text = "0 ms"
					L114_11.TextColor3 = U62.Scheme.FontColor or Color3.new(1, 1, 1)
					L114_11.TextSize = 15
					L114_11.LayoutOrder = 8
					L114_11.Parent = U122
					U80 = L114_11
					local U126 = Instance.new("TextLabel")
					U126.BackgroundTransparency = 1
					U126.AutomaticSize = Enum.AutomaticSize.XY
					U126.Font = Enum.Font.Gotham
					U126.Text = "|"
					U126.TextColor3 = Color3.fromRGB(120, 120, 120)
					U126.TextSize = 15
					U126.LayoutOrder = 9
					U126.Parent = U122
					U118 = U126
					local U127 = Instance.new("Frame")
					U127.Name = "ArrowHolder"
					U127.BackgroundTransparency = 1
					U127.Size = UDim2.fromOffset(18, 18)
					U127.LayoutOrder = 10
					U127.Parent = U122
					local U128 = Instance.new("TextButton")
					U128.Name = "ArrowBtn"
					U128.BackgroundTransparency = 1
					U128.AnchorPoint = Vector2.new(0.5, 0.5)
					U128.Position = UDim2.new(0.5, 0, 0.5, 0)
					U128.Size = UDim2.fromOffset(18, 18)
					U128.Font = Enum.Font.GothamBold
					U128.Text = "▲"
					U128.TextColor3 = U62.Scheme.FontColor or Color3.new(1, 1, 1)
					U128.TextSize = 13
					U128.Rotation = 0
					U128.Parent = U127
					U110 = U128
					local U129 = Instance.new("Frame")
					U129.Name = "DrawerHolder"
					U129.BackgroundTransparency = 1
					U129.ClipsDescendants = true
					U129.BorderSizePixel = 0
					U129.Size = UDim2.fromOffset(0, 0)
					U129.LayoutOrder = 2
					U129.Visible = false
					U129.Parent = U121
					U115 = U129
					local L114_12 = Instance.new("Frame")
					L114_12.Name = "WatermarkDivider"
					L114_12.BackgroundColor3 = U62.Scheme.OutlineColor or Color3.fromHex("292929")
					L114_12.BorderSizePixel = 0
					L114_12.Position = UDim2.fromOffset(0, 7)
					L114_12.Size = UDim2.new(1, 0, 0, 1)
					L114_12.Parent = U129
					U111 = L114_12
					local L114_13 = Instance.new("Frame")
					L114_13.Name = "DrawerContent"
					L114_13.BackgroundTransparency = 1
					L114_13.Position = UDim2.fromOffset(0, 15)
					L114_13.Size = UDim2.new(1, 0, 0, 55)
					L114_13.Parent = U129
					local L114_14 = Instance.new("UIListLayout")
					L114_14.FillDirection = Enum.FillDirection.Horizontal
					L114_14.SortOrder = Enum.SortOrder.LayoutOrder
					L114_14.VerticalAlignment = Enum.VerticalAlignment.Center
					L114_14.Padding = UDim.new(0, 9)
					L114_14.Parent = L114_13
					local L114_15 = Instance.new("ImageLabel")
					L114_15.Name = "ProfileImage"
					L114_15.Size = UDim2.fromOffset(55, 55)
					L114_15.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
					L114_15.Image = U119 ~= "" and U119 or "rbxthumb://type=AvatarHeadShot&id=" .. tostring(U68.UserId) .. "&w=150&h=150"
					L114_15.LayoutOrder = 1
					L114_15.Parent = L114_13
					U116 = L114_15
					local L114_16 = Instance.new("UICorner")
					L114_16.CornerRadius = UDim.new(1, 0)
					L114_16.Parent = L114_15
					local L114_17 = Instance.new("UIStroke")
					L114_17.Color = U62.Scheme.OutlineColor or Color3.fromHex("292929")
					L114_17.Thickness = 1
					L114_17.Parent = L114_15
					local L114_18 = Instance.new("Frame")
					L114_18.Name = "InfoColumn"
					L114_18.BackgroundTransparency = 1
					L114_18.AutomaticSize = Enum.AutomaticSize.XY
					L114_18.Size = UDim2.fromOffset(0, 0)
					L114_18.LayoutOrder = 2
					L114_18.Parent = L114_13
					local L114_19 = Instance.new("UIListLayout")
					L114_19.FillDirection = Enum.FillDirection.Vertical
					L114_19.SortOrder = Enum.SortOrder.LayoutOrder
					L114_19.Padding = UDim.new(0, 4)
					L114_19.Parent = L114_18
					local L114_20 = Instance.new("TextLabel")
					L114_20.Name = "UserLabel"
					L114_20.BackgroundTransparency = 1
					L114_20.AutomaticSize = Enum.AutomaticSize.XY
					L114_20.Font = Enum.Font.Gotham
					L114_20.RichText = true
					L114_20.Text = "User: <b>@" .. U68.Name .. "</b>"
					L114_20.TextColor3 = U62.Scheme.FontColor or Color3.new(1, 1, 1)
					L114_20.TextSize = 14
					L114_20.LayoutOrder = 1
					L114_20.Parent = L114_18
					U83 = L114_20
					local L114_21 = Instance.new("TextLabel")
					L114_21.Name = "KickedLabel"
					L114_21.BackgroundTransparency = 1
					L114_21.AutomaticSize = Enum.AutomaticSize.XY
					L114_21.Font = Enum.Font.Gotham
					L114_21.RichText = true
					L114_21.Text = "Kicked Players: <b>0</b>"
					L114_21.TextColor3 = U62.Scheme.FontColor or Color3.new(1, 1, 1)
					L114_21.TextSize = 14
					L114_21.LayoutOrder = 2
					L114_21.Parent = L114_18
					U82 = L114_21
					local L114_22 = Instance.new("TextLabel")
					L114_22.Name = "ElapsedLabel"
					L114_22.BackgroundTransparency = 1
					L114_22.AutomaticSize = Enum.AutomaticSize.XY
					L114_22.Font = Enum.Font.Gotham
					L114_22.RichText = true
					L114_22.Text = "Elapsed time: <b>00:00:00</b>"
					L114_22.TextColor3 = U62.Scheme.FontColor or Color3.new(1, 1, 1)
					L114_22.TextSize = 14
					L114_22.LayoutOrder = 3
					L114_22.Parent = L114_18
					U81 = L114_22
					local U130 = nil
					local U131 = nil

					local function F_000118()
						if U122 and U122.AbsoluteSize.X > 0 then
							return U122.AbsoluteSize.X
						end
						return 280
					end

					U122:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
						if U122 and U129 and U107 then
							local L119_1 = U122.AbsoluteSize.X

							if L119_1 > 0 then
								U129.Size = UDim2.new(0, L119_1, 0, U129.Size.Y.Offset)
							end
						end
					end)

					U120 = function(A120_1)
						if not U108 then
							if U130 then
								U130:Cancel()
								U130 = nil
							end

							if U131 then
								U131:Cancel()
								U131 = nil
							end

							U127.Visible = false
							U126.Visible = false
							U129.Visible = false
							U129.Size = UDim2.new(0, F_000118(), 0, 0)
							U128.Rotation = 0
							U107 = false
						else
							U127.Visible = true
							U126.Visible = true
							local L120_1 = F_000118()

							if U107 then
								U129.Visible = true

								if A120_1 then
									if U130 then
										U130:Cancel()
									end

									if U131 then
										U131:Cancel()
									end

									U130 = U70:Create(U129, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Size = UDim2.new(0, L120_1, 0, 70) })
									U131 = U70:Create(U128, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Rotation = 180 })
									U130:Play()
									U131:Play()
								else
									U129.Size = UDim2.new(0, L120_1, 0, 70)
									U128.Rotation = 180
								end
							elseif A120_1 then
								if U130 then
									U130:Cancel()
								end

								if U131 then
									U131:Cancel()
								end

								U130 = U70:Create(U129, TweenInfo.new(0.28, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Size = UDim2.new(0, L120_1, 0, 0) })
								U131 = U70:Create(U128, TweenInfo.new(0.28, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Rotation = 0 })
								U130:Play()
								U131:Play()

								task.spawn(function()
									local L121_1 = U130
									L121_1.Completed:Wait()

									if not U107 and U130 == L121_1 then
										U129.Visible = false
									end
								end)
							else
								U129.Size = UDim2.new(0, L120_1, 0, 0)
								U129.Visible = false
								U128.Rotation = 0
							end
						end
					end

					U128.MouseButton1Click:Connect(function()
						if not U108 then
							return
						end
						U107 = not U107
						U120(true)
					end)

					pcall(function()
						U62:MakeDraggable(U121, U122, true)
					end)

					U106 = U121
					U120(false)
				end)
			end

			U62.SetWatermark = function()
				if not U106 then
					U114()
				end
			end

			U62.SetWatermarkVisibility = function(A125_1, A125_2)
				U117 = A125_2

				if not U106 then
					U114()
				end

				if U106 then
					U106.Visible = A125_2
				end
			end
		end

		local U132

		U132 = {
			Snowball = "snowflake",
			Blobman = "bot",
			Coconut = "nut",
			BallBasketball = "circle",
			BallMagicLight = "sparkles",
			Banana = "banana",
			Burger = "sandwich",
			Pizza = "pizza",
			Hotdog = "utensils",
			Donut = "circle",
			Cake = "cake",
			Fries = "utensils",
			Mushroom = "leaf",
			Mayo = "droplet",
			Mayonnaise = "droplet",
			Poop = "trash-2",
			SparklePoop = "sparkles",
			Bread = "croissant",
			Egg = "egg",
			MeatStick = "beef",
			Pepperoni = "pizza",
			WhiteMug = "coffee",
			BrownMug = "coffee",
			Banjo = "music",
			Violin = "music",
			Ukulele = "music",
			Sax = "music-2",
			Trumpet = "volume-2",
			Vuvuzela = "megaphone",
			Bongos = "disc",
			Snare = "disc",
			Mic = "mic",
			Piano = "music",
			Ocarina = "wind",
			Lyre = "music",
			["Tractor (Invisible)"] = "tractor",
			Tractor = "tractor",
			Train = "train-front",
			Kill = "skull",
			Kick = "user-x",
			Superlock = "lock",
			Grab = "hand",
			["Destroy Gucci"] = "trash-2",
			DestroyGucci = "trash-2",
			["Remove Food"] = "utensils",
			["Death Aura"] = "skull",
			["Fling Aura"] = "wind",
			Fling = "wind",
			["Super Strength"] = "zap",
			["Noclip Grab"] = "ghost",
			["Ragdoll Grab"] = "activity",
			["Kill Grab"] = "skull",
			["Kick Grab"] = "user-x",
			Heart = "heart",
			["Heart-Outline"] = "heart",
			["Non-Gamepass"] = "ban",
			Gamepass = "badge-dollar-sign",
			Chain = "link",
			Torso = "shirt",
			Head = "circle-user",
			["Right Arm"] = "hand",
			["Left Arm"] = "hand",
			["Right Leg"] = "footprints",
			["Left Leg"] = "footprints",
			["Closest Part"] = "crosshair",
			["Random Part"] = "shuffle",
			["Closest Object"] = "crosshair",
			["Spawned In Toys"] = "package",
			PalletLightBrown = "box",
			Missile = "bomb",
			Crown = "crown",
			Star = "star",
			Heart = "heart",
			Sparkles = "sparkles",
			Flame = "flame",
			Zap = "zap",
			Skull = "skull",
			Crosshair = "crosshair",
			Shield = "shield-check",
			Ghost = "ghost",
			Diamond = "gem",
			Target = "target",
			Swords = "swords",
			Lock = "lock",
			Checkmark = "check",
			["Neon Glow"] = "zap",
			["Animated Typing"] = "terminal",
			["Rainbow RGB"] = "sparkles",
			["Pulse Breathe"] = "activity",
			["Cyber Glitch"] = "binary",
			["Gold Elegance"] = "crown",
			["Fire Flame"] = "flame",
			["Ice Frost"] = "snowflake",
			["Electric Violet"] = "atom",
			["Clean White"] = "circle",
			Spin = "rotate-cw",
			Blink = "sparkle",
			["Glow Pulse"] = "flame",
			["Fade In"] = "sunrise",
			Bounce = "activity",
			Static = "circle",
			Normal = "target",
			ThroughObjects = "layers",
			Stick = "magnet",
			Wall = "shield",
			["Only Pallet"] = "box",
			Everything = "globe",
			Void = "circle",
			["Dark Void"] = "circle-dot",
			["Sand Storm"] = "wind",
			["Elite Purple"] = "sparkles",
			["Realistic Blackhole"] = "disc",
			Gotham = "type",
			GothamBold = "bold",
			GothamSemibold = "type",
			Arial = "type",
			ArialBold = "bold",
			Code = "code",
			RobotoMono = "terminal",
			Oswald = "type",
			Nunito = "type",
			Merriweather = "type",
			Left = "arrow-left",
			Right = "arrow-right",
			["50%"] = "monitor",
			["75%"] = "monitor",
			["100%"] = "monitor",
			["125%"] = "monitor",
			["150%"] = "monitor",
			["175%"] = "monitor",
			["200%"] = "monitor",
			["1st Warning"] = "triangle-alert",
			["2nd Warning"] = "octagon-alert",
			Safe = "shield-check",
			Random = "shuffle",
			Sticky = "magnet",
			Item = "package",
			None = "ban",
			["---"] = "minus",
			Default = "building-2",
			Avengers = "building-2",
			["Half-Life 2"] = "radiation",
			Instant = "zap",
			Smooth = "wind",
			["Spider Web"] = "network",
			Mouse = "mouse-pointer",
			Camera = "camera",
			Spawn = "map-pin",
			VoidPlatform = "disc",
			Rectangle = "square",
			Blocky = "user",
			Water = "droplet",
			Glass = "square",
			Neon = "zap",
			SmoothPlastic = "layers",
			Ice = "snowflake",
			Sand = "footprints",
			Rock = "mountain",
			Basalt = "stone",
			Slate = "file",
			Mud = "waves",
			Cobblestone = "grid-2x2",
			["Arctic Horizon"] = "snowflake",
			["Black Tempest"] = "cloud-lightning",
			["Blossom Morning"] = "flower-2",
			["Blue Cosmos"] = "orbit",
			["Blue Nebula"] = "sparkles",
			["Blue Planet"] = "globe",
			["Midnight Blue"] = "moon",
			["Stormfront Rain"] = "cloud-rain",
			["Dark Rainstorm"] = "cloud-drizzle",
			["Cosmic Rift"] = "zap",
			["Celestial Abyss"] = "eye",
			["Galaxy Core"] = "sun",
			["Ultra HD"] = "tv",
			["Pixel Craft"] = "box",
			["Cotton Candy"] = "cloud",
			["Pink Horizon"] = "sunrise",
			["Amethyst Dusk"] = "gem",
			["Crimson Night"] = "flame",
			["True Vision"] = "compass",
			["Default Roblox"] = "home",
			["Outer Space"] = "telescope",
			["Summer Glow"] = "sun-medium",
			["Stylized Dream"] = "palette",
			["Golden Sunset"] = "sunset",
			Thunderhead = "cloud-lightning",
			["Winter Frost"] = "thermometer-snowflake",
			["City 17"] = "radiation",
			["Not A Human"] = "user",
			["City 8"] = "building",
			["Dawn of Aurora"] = "chart-column",
			Prediction = "sparkles",
			["---"] = "user-x",
			["-"] = "user-x",
			["No Players"] = "user-x",
		}

		L0_312 = U132

		U87 = function()
			local L126_1 = {}

			for I45, I46 in ipairs(U67:GetPlayers()) do
				if I46 ~= U68 then
					table.insert(L126_1, I46.DisplayName .. " (@" .. I46.Name .. ")")
				end
			end

			if #L126_1 == 0 then
				table.insert(L126_1, "---")
			end

			return L126_1
		end

		U88 = function(A127_1)
			if not A127_1 or A127_1 == "---" or A127_1 == "-" or A127_1 == "No Players" or A127_1 == "No player found" then
				return nil
			end

			if type(A127_1) == "table" then
				for I47, I48 in pairs(A127_1) do
					I48 = I48 and I47 ~= "---" and I47 ~= "-" and I47 ~= "No Players"
					if I48 then
						A127_1 = I47
						break
					end
				end
			end

			if type(A127_1) ~= "string" or A127_1 == "---" or A127_1 == "-" or A127_1 == "No Players" then
				return nil
			end
			local L127_1 = A127_1:match("@([^%)]+)") or A127_1:match("%((.-)%)")
			if L127_1 then
				return U67:FindFirstChild(L127_1)
			end
			return U67:FindFirstChild(A127_1)
		end

		U89 = function()
			local L128_1 = U68.Character
			if not L128_1 or not L128_1:FindFirstChild("Head") then
				return nil
			end
			local L128_2 = L128_1.Head:FindFirstChild("PartOwner")
			if not L128_2 or not L128_2:IsA("StringValue") then
				return nil
			end
			return U67:FindFirstChild(L128_2.Value)
		end

		U90 = function(A129_1, A129_2)
			local U133 = U68:FindFirstChild("CanSpawnToy")

			if U133 and not U133.Value then
				pcall(function()
					U133.Changed:Wait()
				end)
			end

			local L129_1 = U71:FindFirstChild(U68.Name .. "SpawnedInToys")
			local U134 = nil
			local L129_2 = nil

			if L129_1 then
				L129_2 = L129_1.ChildAdded:Connect(function(A131_1)
					if A131_1.Name == A129_1 then
						U134 = A131_1
					end
				end)
			end

			pcall(function()
				local L132_1 = U73.MenuToys.SpawnToyRemoteFunction
				local L132_2 = L132_1.InvokeServer
				local L132_3 = A129_2

				if not A129_2 then
					L132_3 = U68.Character and U68.Character.HumanoidRootPart.CFrame * CFrame.new(5, 5, 20)
				end

				L132_2(L132_1, A129_1, L132_3, Vector3.zero)
			end)

			local L129_3 = tick() + 1.5

			while true do
				task.wait(0.05)
				if not (U134 or tick() > L129_3) then
					continue
				end
				break
			end

			if L129_2 then
				L129_2:Disconnect()
			end

			if U134 then
				return U134
			end
			local L129_4 = U71:FindFirstChild(U68.Name .. "SpawnedInToys")
			return L129_4 and L129_4:FindFirstChild(A129_1)
		end

		pcall(function()
			local U135 = U62.ApplyLucideIcon

			if U135 then
				U62.ApplyLucideIcon = function(A134_1, A134_2, A134_3, A134_4)
					U135(A134_1, A134_2, A134_3, A134_4)

					pcall(function()
						local L135_1 = U62:GetCustomIcon("cpu")

						if A134_3 and L135_1 and (A134_3 == L135_1 or A134_3.Url == L135_1.Url and A134_3.ImageRectOffset == L135_1.ImageRectOffset) then
							A134_2.ImageColor3 = Color3.fromRGB(255, 255, 255)
						end
					end)
				end
			end
		end)

		local U136

		U136 = function(A136_1, A136_2, A136_3)
			task.spawn(function()
				local U137 = U68.Character

				if not U137 or not U137:FindFirstChild("HumanoidRootPart") then
					U137 = U68.CharacterAdded:Wait()
				end

				if not U137 then
					return
				end

				pcall(function()
					U137.Archivable = true
					local U138 = U137:Clone()
					U137.Archivable = false
					if not U138 then
						return
					end

					for I49, I50 in ipairs(U138:GetDescendants()) do
						if I50:IsA("Script") or I50:IsA("LocalScript") or I50:IsA("Sound") or I50:IsA("AnimationTrack") or I50:IsA("Animator") then
							I50:Destroy()
						elseif I50:IsA("Motor6D") then
							I50.Transform = CFrame.identity
							I50.CurrentAngle = 0
						end
					end

					local L138_1 = U138:FindFirstChildOfClass("Humanoid")

					if L138_1 then
						L138_1.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
						L138_1.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
						L138_1.Sit = false
						L138_1.PlatformStand = false
					end

					for I51, I52 in ipairs(U138:GetDescendants()) do
						if I52:IsA("BasePart") then
							I52.Anchored = true
							I52.CanCollide = false
						end
					end

					local L138_2 = U138:FindFirstChild("HumanoidRootPart")

					if L138_2 then
						L138_2.Transparency = 1
					end

					if not U138.PrimaryPart and L138_2 then
						U138.PrimaryPart = L138_2
					end

					local U139 = 3.1415926535897931
					U138:PivotTo(CFrame.new(0, 0, 0) * CFrame.Angles(0, U139, 0))
					local L138_3 = U138:GetBoundingBox().Position
					local L138_4 = U138:FindFirstChild("HumanoidRootPart")

					if L138_4 then
						L138_4 = L138_4.Position.Y + (A136_2 and 0.35 or 0.15)
					end

					L138_4 = L138_4 or L138_3.Y + 0.1
					local L138_5 = Instance.new("Camera")
					L138_5.FieldOfView = 44
					local L138_6 = A136_3 or A136_2 and 7.5 or 4.25
					local L138_7 = Vector3.new(0, L138_4, 0)
					L138_5.CFrame = CFrame.new(Vector3.new(0, L138_4, L138_6), L138_7)
					L138_5.Parent = A136_1
					A136_1.CurrentCamera = L138_5
					U138.Parent = A136_1

					task.spawn(function()
						while A136_1 and A136_1.Parent and U138 and U138.Parent do
							U139 += 0.035
							U138:PivotTo(CFrame.new(0, 0, 0) * CFrame.Angles(0, U139, 0))
							task.wait(0.02)
						end
					end)
				end)
			end)
		end

		U91 = U62:CreateWindow({
			Title = "<b>Silent Target</b>",
			Footer = "<b>Project Silent Target | Beta</b>",
			Icon = U76,
			IconSize = UDim2.fromOffset(30, 30),
			NotifySide = "Right",
			ShowCustomCursor = true,
			AutoShow = false,
			EnableCompacting = true,
			SidebarCompacted = true,
			EnableSidebarResize = true,
			DisableCompactingSnap = true,
			MinSidebarWidth = 64,
			CornerRadius = 20,
			Size = UDim2.fromOffset(720, 665),
			TabButtonsStyle = {
				Gap = 6,
				Padding = 6,
				CornerRadius = 6,
				Indicator = false,
				IndicatorWidth = 0,
				IndicatorHeight = 0,
			},
			Animations = {
				ToggleWindow = true,
				TabSwitch = true,
				Groupbox = true,
				Dropdown = true,
				KeyPicker = true,
			},
			TabTransitionTime = 0.42,
			TabSwipeOffset = 16,
			TabSwipeFrom = "bottom",
		})

		pcall(function()
			U62.TweenInfo = TweenInfo.new(0.38, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
			U62.TabTransitionInfo = TweenInfo.new(0.42, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

			if U91 and U91.SetAnimations then
				U91:SetAnimations({ ToggleWindow = true, TabSwitch = true, Groupbox = true, Dropdown = true, KeyPicker = true }, 0.42, 16, "bottom")
			end
		end)

		local U140

		do
			local U141 = true
			local U142 = nil
			local U143 = nil
			local U144 = nil

			local function F_000141()
				if U143 then
					U143:Disconnect()
					U143 = nil
				end

				if not U142 or not U144 then
					return
				end

				U143 = game:GetService("RunService").RenderStepped:Connect(function()
					if not U141 or not U142 or not U142.Parent then
						if U143 then
							U143:Disconnect()
							U143 = nil
						end

						return
					end

					local L142_1 = os.clock()

					for I53, I54 in ipairs(U144) do
						local L142_2 = I54.cfg
						local L142_3 = (L142_2.pos.Y - L142_1 * 0.03 * L142_2.spd) % 2 - 0.5
						I54.img.Position = UDim2.fromScale(L142_2.pos.X + 0.05 * math.sin(L142_1 * L142_2.spd + I53), L142_3)
						I54.img.ImageTransparency = L142_2.trans + 0.03 * math.sin(L142_1 * 0.4 + I53)
					end
				end)
			end

			U140 = function(A143_1)
				U141 = A143_1

				if U142 then
					U142.Visible = A143_1
				end

				if A143_1 then
					F_000141()

					if U66 and U66.EnableCustomButtons and not U66.EnableCustomButtons.Value then
						pcall(function()
							U66.EnableCustomButtons:SetValue(true)
						end)
					end
				else
					if U143 then
						U143:Disconnect()
						U143 = nil
					end

					if U66 and U66.EnableCustomButtons and U66.EnableCustomButtons.Value then
						pcall(function()
							U66.EnableCustomButtons:SetValue(false)
						end)
					end
				end
			end

			pcall(function()
				local L146_1 = U91 and U91.MainFrame
				local U145

				if L146_1 then
					U145 = L146_1
				else
					local L146_2 = U62

					if U62 then
						U145 = U62.MainFrame
					else
						U145 = L146_2
					end
				end

				if not U145 then
					return
				end
				U145.ClipsDescendants = true
				local L146_3 = U145:FindFirstChild("ST_2DAuraBG")

				if not L146_3 then
					local L146_4 = Instance.new("Frame")
					L146_4.Name = "ST_2DAuraBG"
					L146_4.Size = UDim2.fromScale(1, 1)
					L146_4.Position = UDim2.fromScale(0, 0)
					L146_4.BackgroundTransparency = 1
					L146_4.BorderSizePixel = 0
					L146_4.ZIndex = 0
					L146_4.ClipsDescendants = true
					L146_4.Parent = U145
					U142 = L146_4
					local L146_5 = Instance.new("UICorner")
					L146_5.CornerRadius = UDim.new(0, 20)
					L146_5.Parent = L146_4
					local L146_6 = Instance.new("Frame")
					L146_6.Name = "AuraBase"
					L146_6.Size = UDim2.fromScale(1, 1)
					L146_6.Position = UDim2.fromScale(0, 0)
					L146_6.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
					L146_6.BackgroundTransparency = 0.04
					L146_6.BorderSizePixel = 0
					L146_6.ZIndex = 0
					L146_6.Parent = L146_4
					local L146_7 = Instance.new("UICorner")
					L146_7.CornerRadius = UDim.new(0, 20)
					L146_7.Parent = L146_6
					local L146_8 = {}

					local L146_9 = {
						pos = Vector2.new(0.20000000298023224, 0.20000000298023224),
						size = UDim2.fromScale(3.2, 3.2),
						col = Color3.fromRGB(38, 38, 46),
						spd = 0.25,
						rot = 0.2,
						trans = 0.72,
					}

					local L146_10 = {
						pos = Vector2.new(0.80000001192092896, 0.30000001192092896),
						size = UDim2.fromScale(3.6, 2.8),
						col = Color3.fromRGB(44, 44, 52),
						spd = 0.2,
						rot = 0.24,
						trans = 0.75,
					}

					local L146_11 = {
						pos = Vector2.new(0.30000001192092896, 0.80000001192092896),
						size = UDim2.fromScale(3, 3.5),
						col = Color3.fromRGB(30, 30, 36),
						spd = 0.22,
						rot = 0.18,
						trans = 0.7,
					}

					local L146_12 = {
						pos = Vector2.new(0.80000001192092896, 0.80000001192092896),
						size = UDim2.fromScale(3.4, 3),
						col = Color3.fromRGB(42, 42, 50),
						spd = 0.28,
						rot = 0.22,
						trans = 0.74,
					}

					L146_8[1] = L146_9
					L146_8[2] = L146_10
					L146_8[3] = L146_11
					L146_8[4] = L146_12
					local L146_13 = {}

					for I55, I56 in ipairs(L146_8) do
						local L146_14 = Instance.new("ImageLabel")
						L146_14.Name = "AuraSmoke" .. I55
						L146_14.Image = "rbxassetid://5028857084"
						L146_14.BackgroundTransparency = 1
						L146_14.ImageColor3 = I56.col
						L146_14.ImageTransparency = I56.trans
						L146_14.Size = I56.size
						L146_14.AnchorPoint = Vector2.new(0.5, 0.5)
						L146_14.Position = UDim2.fromScale(I56.pos.X, I56.pos.Y)
						L146_14.ZIndex = 1
						L146_14.ResampleMode = Enum.ResamplerMode.Default
						L146_14.Parent = L146_4
						L146_13[I55] = { img = L146_14, cfg = I56 }
					end

					U144 = L146_13
					local L146_15 = Instance.new("ImageLabel")
					L146_15.Name = "TabSpillLight"
					L146_15.Image = "rbxassetid://5028857084"
					L146_15.BackgroundTransparency = 1
					L146_15.ImageColor3 = Color3.fromRGB(85, 90, 105)
					L146_15.ImageTransparency = 0.88
					L146_15.Size = UDim2.fromScale(1.4, 1.4)
					L146_15.AnchorPoint = Vector2.new(0, 0.5)
					L146_15.Position = UDim2.fromScale(-0.1, 0.25)
					L146_15.ZIndex = 2
					L146_15.ResampleMode = Enum.ResamplerMode.Default
					L146_15.Parent = L146_4
					F_000141()
				else
					U142 = L146_3
				end

				local function F_000147(A147_1)
					if not A147_1 or A147_1 == U145 then
						return
					end

					if A147_1:IsA("Frame") or A147_1:IsA("ScrollingFrame") then
						if A147_1.Name:find("Aura") or A147_1.Name:find("Smoke") or A147_1.Name:find("Spill") then
							return
						end

						pcall(function()
							if A147_1.BackgroundTransparency < 0.38 and A147_1.BackgroundColor3 ~= Color3.fromRGB(255, 255, 255) then
								A147_1.BackgroundTransparency = 0.38
							end
						end)
					end
				end

				for I57, I58 in ipairs(U145:GetDescendants()) do
					F_000147(I58)
				end

				U145.DescendantAdded:Connect(function(A149_1)
					task.defer(function()
						F_000147(A149_1)
					end)
				end)
			end)
		end

		U114()

		pcall(function()
			local function F_000152(A152_1, A152_2)
				if not A152_1 then
					return
				end
				local L152_1 = A152_1:FindFirstChild("ST_RotatingBorder")

				if L152_1 then
					L152_1:Destroy()
				end

				for I59, I60 in ipairs(A152_1:GetChildren()) do
					if I60:IsA("UIStroke") and I60.Name ~= "ST_RotatingBorder" then
						I60.Enabled = false
					end
				end

				local U146 = Instance.new("UIStroke")
				U146.Name = "ST_RotatingBorder"
				U146.Thickness = A152_2 or 1.5
				U146.Color = Color3.fromRGB(255, 255, 255)
				U146.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
				U146.Parent = A152_1
				local U147 = Instance.new("UIGradient")
				U147.Name = "ST_BeamGradient"
				local L152_2 = ColorSequence.new
				local L152_3 = {}
				local L152_4 = ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255))
				local L152_5 = ColorSequenceKeypoint.new(0.25, Color3.fromRGB(130, 130, 130))
				local L152_6 = ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255))
				local L152_7 = ColorSequenceKeypoint.new(0.75, Color3.fromRGB(130, 130, 130))
				local L152_8 = ColorSequenceKeypoint.new
				local L152_9 = Color3.fromRGB
				L152_3[1] = L152_4
				L152_3[2] = L152_5
				L152_3[3] = L152_6
				L152_3[4] = L152_7

				do
					local L152_10 = table.pack(L152_8(1, L152_9(255, 255, 255)))
					table.move(L152_10, 1, L152_10.n, 5, L152_3)
				end

				U147.Color = L152_2(L152_3)
				U147.Parent = U146
				local U148 = 0
				local U149 = nil

				U149 = game:GetService("RunService").RenderStepped:Connect(function(A153_1)
					if not U147 or not U147.Parent or not U146.Parent or not A152_1.Parent then
						if U149 then
							U149:Disconnect()
						end

						return
					end

					U148 = (U148 + A153_1 * 45) % 360
					U147.Rotation = U148
				end)
			end

			task.defer(function()
				task.wait(0.1)
				local L154_1 = U91 and U91.MainFrame or U62 and U62.MainFrame

				if L154_1 then
					local L154_2 = L154_1:FindFirstChild("ST_RotatingBorder")

					if L154_2 then
						L154_2:Destroy()
					end

					for I61, I62 in ipairs(L154_1:GetChildren()) do
						if I62:IsA("UIStroke") then
							I62.Enabled = true
						end
					end
				end

				if U106 then
					F_000152(U106, 1.5)
				else
					task.delay(1.5, function()
						if U106 then
							F_000152(U106, 1.5)
						end
					end)
				end
			end)
		end)

		pcall(function()
			local U150 = game:GetService("TweenService")
			local U151 = TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
			local U152 = TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

			local function F_000157(A157_1)
				if not A157_1 or A157_1:FindFirstChild("ST_TooltipHooked") then
					return
				end

				if not (A157_1:FindFirstChildOfClass("UIPadding") and (A157_1.ZIndex >= 25 or A157_1.Parent == U62.ScreenGui)) then
					return
				end
				local L157_1 = Instance.new("BoolValue")
				L157_1.Name = "ST_TooltipHooked"
				L157_1.Parent = A157_1
				local U153 = A157_1:FindFirstChildOfClass("UIScale")

				if not U153 then
					U153 = Instance.new("UIScale")
					U153.Parent = A157_1
				end

				local U154 = nil
				local U155 = nil
				local U156 = nil

				local function F_000158()
					local L158_1 = U62 and U62.DPIScale or 1

					if U154 then
						U154:Cancel()
					end

					if U155 then
						U155:Cancel()
					end

					if U156 then
						U156:Cancel()
					end

					U153.Scale = 0.05
					A157_1.TextTransparency = 0.8
					local L158_2 = A157_1:FindFirstChildOfClass("UIStroke")

					if L158_2 then
						L158_2.Transparency = 0.8
					end

					U154 = U150:Create(U153, U151, { Scale = L158_1 })
					U155 = U150:Create(A157_1, U152, { TextTransparency = 0 })
					U154:Play()
					U155:Play()

					if L158_2 then
						U156 = U150:Create(L158_2, U152, { Transparency = 0 })
						U156:Play()
					end
				end

				local function F_000159()
					if U62 then
					end

					if U154 then
						U154:Cancel()
					end

					if U155 then
						U155:Cancel()
					end

					if U156 then
						U156:Cancel()
					end

					U153.Scale = 0.05
				end

				A157_1:GetPropertyChangedSignal("Visible"):Connect(function()
					if A157_1.Visible then
						F_000158()
					else
						F_000159()
					end
				end)

				if A157_1.Visible then
					F_000158()
				else
					F_000159()
				end
			end

			if U62 and U62.ScreenGui then
				for I63, I64 in ipairs(U62.ScreenGui:GetDescendants()) do
					if I64:IsA("TextLabel") and I64:FindFirstChildOfClass("UIPadding") and not I64:FindFirstChildOfClass("UIListLayout") then
						F_000157(I64)
					end
				end

				U62.ScreenGui.DescendantAdded:Connect(function(A161_1)
					if A161_1:IsA("TextLabel") and A161_1:FindFirstChildOfClass("UIPadding") and not A161_1:FindFirstChildOfClass("UIListLayout") then
						task.defer(function()
							F_000157(A161_1)
						end)
					end
				end)
			end
		end)

		pcall(function()
			local U157 = Color3.fromRGB(255, 255, 255)

			local function F_000164(A164_1)
				if A164_1 and A164_1:IsA("ImageLabel") then
					A164_1.Size = UDim2.fromOffset(30, 30)
					A164_1.ImageColor3 = U157

					pcall(function()
						A164_1:GetPropertyChangedSignal("ImageColor3"):Connect(function()
							if A164_1.ImageColor3 ~= U157 then
								A164_1.ImageColor3 = U157
							end
						end)
					end)
				end
			end

			local function F_000167(A167_1)
				if not A167_1 or not A167_1:IsA("ImageLabel") then
					return
				end
				local L167_1 = A167_1.Parent
				if not L167_1 then
					return
				end
				local L167_2 = false

				for I65, I66 in ipairs(L167_1:GetChildren()) do
					if I66:IsA("TextLabel") and I66.Text:find("Silent Target") then
						L167_2 = true
						break
					end
				end

				if L167_2 then
					F_000164(A167_1)
				end
			end

			local function F_000168()
				if U62.ScreenGui then
					for I67, I68 in ipairs(U62.ScreenGui:GetDescendants()) do
						F_000167(I68)
					end
				end
			end

			F_000168()

			if U62.ScreenGui then
				U62.ScreenGui.DescendantAdded:Connect(function(A169_1)
					task.defer(function()
						F_000167(A169_1)
					end)
				end)
			end
		end)

		pcall(function()
			U62.TweenInfo = TweenInfo.new(0.24, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
			U62.TabTransitionInfo = TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
			U91:SetAnimations({ ToggleWindow = true, TabSwitch = true, Groupbox = true, Dropdown = true, KeyPicker = true }, 0.22, 18, "bottom")
		end)

		pcall(function()
			local U158 = U91.MainFrame

			if U158 then
				U158.Size = UDim2.fromOffset(720, 665)
				local U159 = Instance.new("UIScale")
				U159.Scale = 0.94
				U159.Parent = U158
				U62.CantDragForced = true
				local L172_1 = game:GetService("UserInputService")
				local U160 = false
				local U161 = Vector2.zero
				local U162 = U158.Position
				local U163 = U158.Position
				local L172_2 = nil

				for I69, I70 in ipairs(U158:GetChildren()) do
					if I70:IsA("Frame") and I70.Size.Y.Offset == 48 and I70.Size.X.Scale == 1 then
						L172_2 = I70
						L172_2.Name = "ObsidianTopBar"

						pcall(function()
							I70.BackgroundTransparency = 1

							for I71, I72 in ipairs(I70:GetChildren()) do
								if I72:IsA("Frame") and not I72:FindFirstChildWhichIsA("TextBox") and I72.BackgroundTransparency < 0.5 then
									I72.BackgroundTransparency = 1
								end
							end
						end)

						break
					else
						L172_2 = nil
					end
				end

				local function F_000174(A174_1)
					local L174_1 = U158.AbsolutePosition
					local L174_2 = U62.DPIScale or 1
					local L174_3 = A174_1.X - L174_1.X
					local L174_4 = A174_1.Y - L174_1.Y
					return L174_3 >= 0 and L174_3 <= U158.AbsoluteSize.X and L174_4 >= 0 and L174_4 <= 48 * L174_2
				end
				;(L172_2 or U158).InputBegan:Connect(function(A175_1)
					if A175_1.UserInputType == Enum.UserInputType.MouseButton1 or A175_1.UserInputType == Enum.UserInputType.Touch then
						if not F_000174(A175_1.Position) then
							return
						end
						U160 = true
						U161 = Vector2.new(A175_1.Position.X, A175_1.Position.Y)
						U162 = U158.Position
						U163 = U158.Position
						local U164 = nil

						U164 = A175_1.Changed:Connect(function()
							if A175_1.UserInputState == Enum.UserInputState.End then
								U160 = false

								if U164 then
									U164:Disconnect()
								end
							end
						end)
					end
				end)

				L172_1.InputEnded:Connect(function(A177_1)
					if A177_1.UserInputType == Enum.UserInputType.MouseButton1 or A177_1.UserInputType == Enum.UserInputType.Touch then
						U160 = false
					end
				end)

				L172_1.InputChanged:Connect(function(A178_1)
					local L178_1 = U160

					if U160 then
						L178_1 = A178_1.UserInputType == Enum.UserInputType.MouseMovement or A178_1.UserInputType == Enum.UserInputType.Touch
					end

					if L178_1 then
						U163 = UDim2.new(U162.X.Scale, U162.X.Offset + A178_1.Position.X - U161.X, U162.Y.Scale, U162.Y.Offset + A178_1.Position.Y - U161.Y)
					end
				end)

				U69.RenderStepped:Connect(function(A179_1)
					if not U158 or not U158.Parent then
						return
					end

					if not U160 then
						return
					end
					local L179_1 = U158.Position
					local L179_2 = U163.X.Offset - L179_1.X.Offset
					local L179_3 = U163.Y.Offset - L179_1.Y.Offset

					if math.abs(L179_2) > 0.1 or math.abs(L179_3) > 0.1 then
						local L179_4 = 1 - math.exp(-28 * A179_1)
						local L179_5 = L179_1.Y.Offset + L179_3 * L179_4
						U158.Position = UDim2.new(U163.X.Scale, math.round(L179_1.X.Offset + L179_2 * L179_4), U163.Y.Scale, math.round(L179_5))
					else
						U158.Position = U163
					end
				end)

				local U165 = U62.Toggle

				U62.Toggle = function(A180_1, A180_2)
					local L180_1

					if A180_2 ~= nil then
						L180_1 = A180_2
					else
						L180_1 = not U62.Toggled
					end

					if L180_1 then
						U159.Scale = 0.94
						U70:Create(U159, TweenInfo.new(0.26, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Scale = 1 }):Play()
					else
						U70:Create(U159, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.In), { Scale = 0.94 }):Play()
					end

					return U165(A180_1, A180_2)
				end

				U158:GetPropertyChangedSignal("Visible"):Connect(function()
					if U158.Visible and U62.Toggled then
						U159.Scale = 0.94
						U70:Create(U159, TweenInfo.new(0.26, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Scale = 1 }):Play()
					end
				end)
			end
		end)

		do
			local function F_000182()
				pcall(function()
					local L183_1 = Instance.new("Sound")
					L183_1.SoundId = "rbxassetid://129485210015224"
					L183_1.Volume = 1
					L183_1.Parent = game:GetService("SoundService")
					L183_1:Play()
					U72:AddItem(L183_1, 5)
				end)
			end

			local function F_000184(A184_1)
				if not A184_1 or A184_1 == "" then
					return ""
				end
				local L184_1 = A184_1:find("<b>") and A184_1:find("</b>")

				local L184_2 = A184_1:gsub("<b>", ""):gsub("</b>", ""):gsub("(%a)([%w_']*)", function(A185_1, A185_2)
					return A185_1:upper() .. A185_2:lower()
				end)

				if L184_1 then
					return "<b>" .. L184_2 .. "</b>"
				end
				return L184_2
			end

			local function F_000186(A186_1)
				if not A186_1 or type(A186_1) ~= "table" or not A186_1.Holder then
					return
				end

				pcall(function()
					local L187_1 = A186_1.Holder
					local U166 = L187_1.Parent
					local L187_2 = L187_1:FindFirstChildOfClass("UICorner")

					if L187_2 then
						L187_2.CornerRadius = UDim.new(0, 6)

						if U62.Corners then
							local L187_3 = table.find(U62.Corners, L187_2)

							if L187_3 then
								table.remove(U62.Corners, L187_3)
							end
						end
					end

					for I73, I74 in ipairs(L187_1:GetDescendants()) do
						if I74:IsA("ImageLabel") and I74.Name ~= "CloseButton" then
							local L187_4 = U62:GetCustomIcon("cpu")

							if L187_4 then
								U62:ApplyLucideIcon(I74, L187_4)
							end

							I74.ImageColor3 = Color3.fromRGB(255, 255, 255)
						elseif I74:IsA("TextLabel") then
							I74.RichText = true
						end
					end

					local U167 = A186_1.Resize

					A186_1.Resize = function(A188_1)
						if U167 then
							pcall(U167, A188_1)
						end

						pcall(function()
							if U166 and U166:IsA("GuiObject") then
								U166.Size = UDim2.fromOffset(math.max(260, U166.Size.X.Offset), 0)
							end
						end)
					end

					if A186_1.Resize then
						A186_1:Resize()
					end
				end)
			end

			local U168 = U62.Notify

			U62.Notify = function(A190_1, ...)
				local L190_1 = { ... }
				local L190_2 = L190_1[1]
				local L190_3

				if type(L190_2) ~= "string" then
					L190_3 = L190_2
				else
					L190_3 = { Description = L190_2 }
					L190_1[1] = L190_3
				end

				if type(L190_3) == "table" then
					F_000182()

					if not L190_3.Title then
						L190_3.Title = "<b>Silent Target</b>"
					else
						local L190_4 = F_000184(tostring(L190_3.Title))

						if not L190_4:find("<b>") then
							L190_3.Title = "<b>" .. L190_4 .. "</b>"
						else
							L190_3.Title = L190_4
						end
					end

					if L190_3.Description and type(L190_3.Description) == "string" then
						if L190_3.Description:find("Silent Target") and not L190_3.Description:find("<b>Silent Target</b>") then
							L190_3.Description = L190_3.Description:gsub("Silent Target", "<b>Silent Target</b>")
						end
					end

					L190_3.BigIcon = U76
					L190_3.Icon = nil
					L190_3.IconColor = Color3.fromRGB(255, 255, 255)
				end

				local L190_5 = U168(A190_1, unpack(L190_1))
				F_000186(L190_5)
				return L190_5
			end
		end

		task.spawn(function()
			task.wait(1)

			pcall(function()
				if U62.NotificationArea then
					U62.NotificationArea.ChildAdded:Connect(function(A193_1)
						task.defer(function()
							local L194_1 = A193_1:FindFirstChild("Holder") or A193_1:FindFirstChildOfClass("Frame")

							if L194_1 then
								local L194_2 = L194_1:FindFirstChildOfClass("UICorner")

								if L194_2 then
									L194_2.CornerRadius = UDim.new(0, 6)

									if U62.Corners then
										local L194_3 = table.find(U62.Corners, L194_2)

										if L194_3 then
											table.remove(U62.Corners, L194_3)
										end
									end
								end
							end
						end)
					end)
				end
			end)
		end)

		U62.Animations = setmetatable({}, { __index = function()
			return true
		end })

		U62.ForceCheckbox = true

		U92 = {
			Home = U91:AddTab("<b>Home</b>", "house", "Welcome and script statistics"),
			Defence = U91:AddTab("<b>Anti's</b>", "shield", "Protection"),
			Target = U91:AddTab("<b>Target</b>", "swords", "Loop targets"),
			Blob = U91:AddTab("<b>Blob</b>", "bot", "Blobman settings"),
			Server = U91:AddTab("<b>Server</b>", "server", "Server lag and map configuration"),
			Grabs = U91:AddTab("<b>Grabs</b>", "hand-fist", "Grabs and Aimbot settings"),
			Player = U91:AddTab("<b>Player</b>", "user", "Player-focused settings"),
			Miscs = U91:AddTab("<b>Miscs</b>", "chart-bar", "Miscellaneous features"),
			Fun = U91:AddTab("<b>Fun</b>", "aperture", "Fun animations and toys"),
			Whitelist = U91:AddTab("<b>Whitelist</b>", "scroll", "Whitelist People and your friends"),
			Keyboard = U91:AddTab("<b>Keyboard</b>", "keyboard", "Able to use keybinds"),
			UISettings = U91:AddTab("<b>UI Settings</b>", "settings", "Settings"),
		}

		U92.Blobman = U92.Blob

		pcall(function()
			local L196_1 = getmetatable(U92.Home)

			if L196_1 and L196_1.__index then
				local function F_000197(A197_1)
					if type(A197_1) ~= "string" then
						return A197_1
					end

					if not A197_1:find("<b>") then
						return "<b>" .. A197_1 .. "</b>"
					end
					return A197_1
				end

				if L196_1.__index.AddDropdown then
					local U169 = L196_1.__index.AddDropdown

					L196_1.__index.AddDropdown = function(A198_1, A198_2, A198_3)
						if type(A198_3) == "table" then
							A198_3.ValueImages = A198_3.ValueImages or {}

							if A198_3.Values then
								for I75, I76 in ipairs(A198_3.Values) do
									if typeof(I76) == "string" and not A198_3.ValueImages[I76] and U132[I76] then
										A198_3.ValueImages[I76] = U132[I76]
									end
								end
							end
						end

						return U169(A198_1, A198_2, A198_3)
					end
				end

				local function F_000199(A199_1)
					if not A199_1 or A199_1._stBoldHooked then
						return
					end
					A199_1._stBoldHooked = true
					local U170 = A199_1.AddToggle

					if U170 then
						A199_1.AddToggle = function(A200_1, A200_2, A200_3)
							if type(A200_3) == "table" and A200_3.Text and not A200_3.Text:find("<b>") then
								A200_3.Text = F_000197(A200_3.Text)
							end

							local U171 = U170(A200_1, A200_2, A200_3)

							if U171 and U171.TextLabel then
								pcall(function()
									U171.TextLabel.RichText = true
									U171.TextLabel.Font = Enum.Font.GothamBold
								end)
							end

							return U171
						end
					end

					local U172 = A199_1.AddCheckbox

					if U172 then
						A199_1.AddCheckbox = function(A202_1, A202_2, A202_3)
							if type(A202_3) == "table" and A202_3.Text and not A202_3.Text:find("<b>") then
								A202_3.Text = F_000197(A202_3.Text)
							end

							local U173 = U172(A202_1, A202_2, A202_3)

							if U173 and U173.TextLabel then
								pcall(function()
									U173.TextLabel.RichText = true
									U173.TextLabel.Font = Enum.Font.GothamBold
								end)
							end

							return U173
						end
					end

					local U174 = A199_1.AddButton

					if U174 then
						A199_1.AddButton = function(A204_1, ...)
							local L204_1 = { ... }

							if type(L204_1[1]) == "table" and L204_1[1].Text and not L204_1[1].Text:find("<b>") then
								L204_1[1].Text = F_000197(L204_1[1].Text)
							elseif type(L204_1[1]) == "string" and not L204_1[1]:find("<b>") then
								L204_1[1] = F_000197(L204_1[1])
							elseif type(L204_1[2]) == "table" and L204_1[2].Text and not L204_1[2].Text:find("<b>") then
								L204_1[2].Text = F_000197(L204_1[2].Text)
							end

							local U175 = U174(A204_1, unpack(L204_1))

							if U175 and U175.Base then
								pcall(function()
									U175.Base.RichText = true
									U175.Base.Font = Enum.Font.GothamBold
								end)
							end

							if U175 and U175.AddButton then
								local U176 = U175.AddButton

								U175.AddButton = function(A206_1, ...)
									local L206_1 = { ... }

									if type(L206_1[1]) == "table" and L206_1[1].Text and not L206_1[1].Text:find("<b>") then
										L206_1[1].Text = F_000197(L206_1[1].Text)
									elseif type(L206_1[1]) == "string" and not L206_1[1]:find("<b>") then
										L206_1[1] = F_000197(L206_1[1])
									elseif type(L206_1[2]) == "table" and L206_1[2].Text and not L206_1[2].Text:find("<b>") then
										L206_1[2].Text = F_000197(L206_1[2].Text)
									end

									local U177 = U176(A206_1, unpack(L206_1))

									if U177 and U177.Base then
										pcall(function()
											U177.Base.RichText = true
											U177.Base.Font = Enum.Font.GothamBold
										end)
									end

									return U177
								end
							end

							return U175
						end
					end
				end

				local function F_000208(A208_1)
					if not A208_1 then
						return
					end

					if A208_1.AddGroupbox then
						local U178 = A208_1.AddGroupbox

						A208_1.AddGroupbox = function(A209_1, A209_2)
							local L209_1 = U178(A209_1, A209_2)

							if L209_1 then
								F_000199(L209_1)
							end

							return L209_1
						end
					end

					if A208_1.AddLeftGroupbox then
						local U179 = A208_1.AddLeftGroupbox

						A208_1.AddLeftGroupbox = function(A210_1, A210_2)
							local L210_1 = U179(A210_1, A210_2)

							if L210_1 then
								F_000199(L210_1)
							end

							return L210_1
						end
					end

					if A208_1.AddRightGroupbox then
						local U180 = A208_1.AddRightGroupbox

						A208_1.AddRightGroupbox = function(A211_1, A211_2)
							local L211_1 = U180(A211_1, A211_2)

							if L211_1 then
								F_000199(L211_1)
							end

							return L211_1
						end
					end

					if A208_1.AddTabbox then
						local U181 = A208_1.AddTabbox

						A208_1.AddTabbox = function(A212_1, A212_2)
							local L212_1 = U181(A212_1, A212_2)

							if L212_1 and L212_1.AddTab then
								local U182 = L212_1.AddTab

								L212_1.AddTab = function(A213_1, A213_2, A213_3)
									local L213_1 = U182(A213_1, A213_2, A213_3)

									if L213_1 then
										F_000199(L213_1)
									end

									return L213_1
								end
							end

							return L212_1
						end
					end
				end

				F_000208(U92.Home)
				F_000208(U92.UISettings)
			end
		end)

		pcall(function()
			local U183 = game:GetService("UserInputService")
			local U184 = game:GetService("TweenService")
			local U185 = game:GetService("RunService")
			local U186 = U62.MakeBoxPopOut
			if not U186 then
				return
			end

			U62.MakeBoxPopOut = function(A215_1, A215_2, A215_3)
				U186(A215_1, A215_2, A215_3)
				if not A215_2.PopOutEnabled then
					return
				end
				local U187 = A215_2.SetPoppedOut
				if not U187 then
					return
				end
				local U188 = A215_2.Resize

				if U188 then
					A215_2.Resize = function(A216_1)
						if A215_2.PoppedOut and A215_2.PopOutCustomHeight and A215_2.Holder then
							pcall(function()
								local L217_1 = A215_2.PopOutCustomHeight
								local L217_2 = A215_2.PopOutWidth or A215_2.PopOutFloat and A215_2.PopOutFloat.Size.X.Offset or 250
								local L217_3 = A215_2.Header and A215_2.Header.AbsoluteSize.Y / (U62.DPIScale or 1) or 24
								local L217_4 = math.max(L217_1 - 22, 50)

								if A215_2.Container then
									A215_2.Container.Size = UDim2.new(1, 0, 0, math.max(L217_4 - L217_3 - 1, 30))
								end

								A215_2.Holder.Size = UDim2.new(1, 0, 0, L217_4)

								if A215_2.PopOutFloat then
									A215_2.PopOutFloat.AutomaticSize = Enum.AutomaticSize.None
									A215_2.PopOutFloat.Size = UDim2.fromOffset(L217_2, L217_1)
								end
							end)

							return
						end

						U188(A216_1)
					end
				end

				A215_2.SetPoppedOut = function(A218_1, A218_2, A218_3)
					U187(A218_1, A218_2, A218_3)

					if A218_2 and A215_2.PopOutFloat then
						local U189 = A215_2.PopOutFloat
						U189.AutomaticSize = Enum.AutomaticSize.None

						if A215_2.PopOutCustomHeight and A215_2.Holder then
							pcall(function()
								local L219_1 = A215_2.PopOutCustomHeight
								local L219_2 = A215_2.PopOutWidth or U189.Size.X.Offset
								local L219_3 = A215_2.Header and A215_2.Header.AbsoluteSize.Y / (U62.DPIScale or 1) or 24
								local L219_4 = math.max(L219_1 - 22, 50)

								if A215_2.Container then
									A215_2.Container.Size = UDim2.new(1, 0, 0, math.max(L219_4 - L219_3 - 1, 30))
								end

								A215_2.Holder.Size = UDim2.new(1, 0, 0, L219_4)
								U189.Size = UDim2.fromOffset(L219_2, L219_1)
							end)
						end

						if not U189:FindFirstChild("ST_PopoutResizeBar") then
							local L218_1 = Instance.new("Frame")
							L218_1.Name = "ST_PopoutResizeBar"
							L218_1.Size = UDim2.new(1, 0, 0, 16)
							L218_1.BackgroundTransparency = 1
							L218_1.BorderSizePixel = 0
							L218_1.LayoutOrder = 999999
							L218_1.Parent = U189
							local L218_2 = Instance.new("TextButton")
							L218_2.Name = "ResizeGripBtn"
							L218_2.Size = UDim2.fromOffset(20, 16)
							L218_2.AnchorPoint = Vector2.new(1, 0.5)
							L218_2.Position = UDim2.new(1, -2, 0.5, 0)
							L218_2.BackgroundTransparency = 1
							L218_2.Text = ""
							L218_2.AutoButtonColor = false
							L218_2.ZIndex = 70
							L218_2.Parent = L218_1
							local U190 = Instance.new("UIScale")
							U190.Scale = 1
							U190.Parent = L218_2
							local U191 = Instance.new("ImageLabel")
							U191.Name = "ArrowIcon"
							U191.Size = UDim2.fromOffset(13, 13)
							U191.AnchorPoint = Vector2.new(0.5, 0.5)
							U191.Position = UDim2.fromScale(0.5, 0.5)
							U191.BackgroundTransparency = 1
							U191.ImageColor3 = Color3.fromRGB(160, 160, 160)
							U191.ImageTransparency = 0.35
							U191.ZIndex = 71
							U191.Parent = L218_2
							local U192 = false

							pcall(function()
								local L220_1 = U62.GetCustomIcon and (U62:GetCustomIcon("move-diagonal-2") or U62:GetCustomIcon("move-diagonal") or U62:GetCustomIcon("maximize-2")) or U62.GetIcon and (U62:GetIcon("move-diagonal-2") or U62:GetIcon("move-diagonal") or U62:GetIcon("maximize-2"))

								if L220_1 and U62.ApplyLucideIcon then
									U62:ApplyLucideIcon(U191, L220_1)
									U192 = true
								end
							end)

							if not U192 then
								U191.Image = "rbxassetid://10709791437"
							end

							local U193 = false
							local U194 = false

							local function F_000221(A221_1, A221_2)
								local L221_1 = A221_2 and 1.35 or A221_1 and 1.2 or 1
								local L221_2 = (A221_1 or A221_2) and 0 or 0.35
								A221_2 = (A221_1 or A221_2) and (U62.Scheme.AccentColor or Color3.fromRGB(255, 255, 255)) or Color3.fromRGB(160, 160, 160)
								U184:Create(U190, TweenInfo.new(0.18, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = L221_1 }):Play()
								U184:Create(U191, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { ImageTransparency = L221_2, ImageColor3 = A221_2 }):Play()
							end

							L218_2.MouseEnter:Connect(function()
								U193 = true

								if not U194 then
									F_000221(true, false)
								end
							end)

							L218_2.MouseLeave:Connect(function()
								U193 = false

								if not U194 then
									F_000221(false, false)
								end
							end)

							local U195 = nil
							local U196 = nil

							L218_2.InputBegan:Connect(function(A224_1)
								if A224_1.UserInputType == Enum.UserInputType.MouseButton1 or A224_1.UserInputType == Enum.UserInputType.Touch then
									U194 = true
									F_000221(true, true)
									local L224_1 = U62.DPIScale or 1
									local U197 = U183:GetMouseLocation()
									local U198 = U189.Size.X.Offset > 50 and U189.Size.X.Offset or A215_2.PopOutWidth or 250
									local U199 = U189.Size.Y.Offset > 50 and U189.Size.Y.Offset or A215_2.PopOutCustomHeight or U189.AbsoluteSize.Y / L224_1

									if U199 < 80 then
										U199 = 300
									end

									U189.AutomaticSize = Enum.AutomaticSize.None

									if U195 then
										U195:Disconnect()
										U195 = nil
									end

									U195 = U185.RenderStepped:Connect(function()
										if not U194 or not A215_2.PoppedOut or not U189.Parent then
											if U195 then
												U195:Disconnect()
												U195 = nil
											end

											return
										end

										local L225_1 = U183:GetMouseLocation()
										local L225_2 = U62.DPIScale or 1
										local L225_3 = (L225_1.X - U197.X) / L225_2
										local L225_4 = (L225_1.Y - U197.Y) / L225_2
										local L225_5 = math.clamp(math.round(U198 + L225_3), 160, 950)
										local L225_6 = math.clamp(math.round(U199 + L225_4), 80, 1600)
										A215_2.PopOutWidth = L225_5
										A215_2.PopOutCustomHeight = L225_6
										A215_2.PopOutMaxHeight = L225_6
										U189.Size = UDim2.fromOffset(L225_5, L225_6)
										local L225_7 = A215_2.Header and A215_2.Header.AbsoluteSize.Y / L225_2 or 24
										local L225_8 = math.max(L225_6 - 22, 50)

										if A215_2.Holder then
											A215_2.Holder.Size = UDim2.new(1, 0, 0, L225_8)
										end

										if A215_2.Container then
											A215_2.Container.Size = UDim2.new(1, 0, 0, math.max(L225_8 - L225_7 - 1, 30))
										end
									end)

									U196 = U183.InputEnded:Connect(function(A226_1)
										if A226_1.UserInputType == Enum.UserInputType.MouseButton1 or A226_1.UserInputType == Enum.UserInputType.Touch then
											U194 = false
											F_000221(U193, false)

											if U195 then
												U195:Disconnect()
												U195 = nil
											end

											if U196 then
												U196:Disconnect()
												U196 = nil
											end
										end
									end)
								end
							end)
						end
					end
				end
			end
		end)

		do
			local U200 = {}
			local U201 = nil
			local U202 = nil
			local U203 = nil

			local function F_000227(A227_1)
				if U203 then
					U203.running = false

					if U203.icon and U203.icon.Parent then
						U203.icon.Rotation = 0
					end
				end

				local U204 = { running = true, icon = A227_1 }
				U203 = U204

				task.spawn(function()
					local L228_1 = 0

					while U204.running and A227_1 and A227_1.Parent do
						L228_1 = (L228_1 + 1.8) % 360
						A227_1.Rotation = L228_1
						task.wait(0.02)
					end

					if A227_1 and A227_1.Parent then
						A227_1.Rotation = 0
					end
				end)
			end

			local function F_000229(A229_1)
				local L229_1 = A229_1:FindFirstChild("ST_BottomIndicator")

				if not L229_1 then
					L229_1 = Instance.new("Frame")
					L229_1.Name = "ST_BottomIndicator"
					L229_1.Size = UDim2.fromOffset(28, 4)
					L229_1.AnchorPoint = Vector2.new(0.5, 1)
					L229_1.Position = UDim2.new(0.5, 0, 1, -2)
					L229_1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					L229_1.BackgroundTransparency = 1
					L229_1.BorderSizePixel = 0
					L229_1.ZIndex = math.max(3, A229_1.ZIndex + 5)
					L229_1.Parent = A229_1
					local L229_2 = Instance.new("UICorner")
					L229_2.CornerRadius = UDim.new(1, 0)
					L229_2.Parent = L229_1
				end

				local L229_3 = A229_1:FindFirstChild("ST_BottomLight")

				if not L229_3 then
					L229_3 = Instance.new("ImageLabel")
					L229_3.Name = "ST_BottomLight"
					L229_3.Size = UDim2.new(0.85, 0, 0.65, 0)
					L229_3.AnchorPoint = Vector2.new(0.5, 1)
					L229_3.Position = UDim2.new(0.5, 0, 1, -2)
					L229_3.BackgroundTransparency = 1
					L229_3.Image = "rbxassetid://5028857084"
					L229_3.ImageColor3 = Color3.fromRGB(255, 255, 255)
					L229_3.ImageTransparency = 1
					L229_3.BorderSizePixel = 0
					L229_3.ZIndex = math.max(2, A229_1.ZIndex + 2)
					L229_3.Parent = A229_1
				end

				if not A229_1:FindFirstChild("ST_SlotGradient") then
					local L229_4 = Instance.new("UIGradient")
					L229_4.Name = "ST_SlotGradient"
					L229_4.Rotation = -90
					local L229_5 = ColorSequenceKeypoint.new
					local L229_6 = Color3.fromRGB
					L229_4.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(46, 46, 54)), L229_5(1, L229_6(18, 18, 22)) })
					L229_4.Parent = A229_1
				end

				return L229_1, L229_3
			end

			U93 = function(A230_1, A230_2)
				if not A230_1 then
					return
				end

				if U201 and U201 ~= A230_1 then
					local U205 = U201
					local U206 = U205:FindFirstChild("ST_BottomIndicator")
					local U207 = U205:FindFirstChild("ST_BottomLight")

					if U206 then
						pcall(function()
							U70:Create(U206, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { BackgroundTransparency = 1 }):Play()
						end)
					end

					if U207 then
						pcall(function()
							U70:Create(U207, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { ImageTransparency = 1 }):Play()
						end)
					end

					pcall(function()
						U70:Create(U205, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { BackgroundTransparency = 1 }):Play()
					end)
				end

				if U202 and U202 ~= A230_2 then
					local U208 = U202

					pcall(function()
						U70:Create(U208, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { ImageColor3 = Color3.fromRGB(150, 150, 160), ImageTransparency = 0.5 }):Play()
					end)
				end

				U201 = A230_1
				U202 = A230_2
				local U209, U210 = F_000229(A230_1)

				pcall(function()
					A230_1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					U70:Create(A230_1, TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { BackgroundTransparency = 0 }):Play()
					U70:Create(U209, TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { BackgroundTransparency = 0 }):Play()

					if U210 then
						U70:Create(U210, TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { ImageTransparency = 0.78 }):Play()
					end

					local L235_1 = A230_1:FindFirstChild("ST_TabHighlight", true)

					if L235_1 then
						L235_1:Destroy()
					end

					local L235_2 = A230_1:FindFirstChild("ButtonHolder")

					if L235_2 then
						L235_2.BackgroundTransparency = 1
						L235_2.BorderSizePixel = 0
						local L235_3 = L235_2:FindFirstChild("ST_TabHighlight")

						if L235_3 then
							L235_3:Destroy()
						end
					end

					local L235_4 = U91 and U91.MainFrame or U62 and U62.MainFrame

					if L235_4 then
						for I77, I78 in ipairs(L235_4:GetDescendants()) do
							if I78.Name == "ST_SmoothSidebarSlider" or I78.Name == "TabIndicator" or I78.Name == "SideIndicator" then
								I78:Destroy()
							end
						end
					end

					if A230_2 then
						U70:Create(A230_2, TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { ImageColor3 = Color3.fromRGB(255, 255, 255), ImageTransparency = 0 }):Play()
						F_000227(A230_2)
					end
				end)
			end

			local function F_000236(A236_1, A236_2)
				if not A236_1 or not A236_2 or U200[A236_1] then
					return
				end
				U200[A236_1] = true
				A236_2.Active = false
				local U211 = UDim2.new(0.5, 0, 0.5, -2)
				local U212 = UDim2.fromOffset(29, 29)
				local U213 = UDim2.fromOffset(32, 32)

				pcall(function()
					A236_2.AnchorPoint = Vector2.new(0.5, 0.5)
					A236_2.ScaleType = Enum.ScaleType.Fit
					A236_2.Position = U211
					A236_2.Size = U212

					if not A236_1:FindFirstChildOfClass("UICorner") then
						local L237_1 = Instance.new("UICorner")
						L237_1.CornerRadius = UDim.new(0, 8)
						L237_1.Parent = A236_1
					end

					A236_1.BorderSizePixel = 0

					if U201 == A236_1 then
						A236_1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
						A236_1.BackgroundTransparency = 0
					else
						A236_1.BackgroundTransparency = 1
					end

					local L237_2 = A236_1:FindFirstChild("ButtonHolder")

					if L237_2 then
						L237_2.BackgroundTransparency = 1
						L237_2.BorderSizePixel = 0

						for I79, I80 in ipairs(L237_2:GetChildren()) do
							if I80:IsA("UIStroke") then
								I80.Enabled = false
							end
						end
					end

					for I81, I82 in ipairs(A236_1:GetChildren()) do
						if I82:IsA("UIStroke") then
							I82.Enabled = false
						end
					end

					F_000229(A236_1)
				end)

				A236_1.MouseEnter:Connect(function()
					pcall(function()
						local L239_1 = { Size = U213 }
						U70:Create(A236_2, TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), L239_1):Play()
					end)
				end)

				A236_1.MouseLeave:Connect(function()
					pcall(function()
						local L241_1 = { Size = U212 }
						U70:Create(A236_2, TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), L241_1):Play()
					end)
				end)

				A236_1.MouseButton1Click:Connect(function()
					U93(A236_1, A236_2)
				end)

				A236_1.InputBegan:Connect(function(A243_1)
					if A243_1.UserInputType == Enum.UserInputType.MouseButton1 or A243_1.UserInputType == Enum.UserInputType.Touch then
						U93(A236_1, A236_2)
					end
				end)
			end

			local function F_000244()
				pcall(function()
					if U92 and typeof(U92) == "table" then
						for I83, I84 in pairs(U92) do
							if typeof(I84) == "table" and I84.Button and not I84._stHooked then
								I84._stHooked = true
								local U214 = I84.Button
								local L245_1 = U214:FindFirstChildWhichIsA("ImageLabel", true)

								if L245_1 then
									F_000236(U214, L245_1)
								end

								local U215 = I84.Show

								if typeof(U215) == "function" then
									I84.Show = function(A246_1)
										U215(A246_1)
										local L246_1 = U214:FindFirstChildWhichIsA("ImageLabel", true)
										U93(U214, L246_1)
									end
								end
							end
						end
					end

					if U62.TabButtons then
						for I85, I86 in ipairs(U62.TabButtons) do
							if I86.Icon then
								F_000236(I86.Icon:FindFirstAncestorOfClass("TextButton") or I86.Icon.Parent, I86.Icon)
							end
						end
					end

					local L245_2 = U62.MainFrame

					if L245_2 then
						for I87, I88 in ipairs(L245_2:GetDescendants()) do
							if I88:IsA("TextButton") then
								local L245_3 = I88.Parent

								if L245_3 then
									L245_3 = L245_3.Name == "Tabs" or L245_3.Name == "TabboxButtons"
								end

								if L245_3 or I88.Name == "TabButton" or I88:FindFirstChild("ButtonHolder") or I88:FindFirstChild("ButtonContent") then
									local L245_4 = I88:FindFirstChildWhichIsA("ImageLabel", true)

									if L245_4 then
										F_000236(I88, L245_4)
									end
								end
							end
						end
					end
				end)
			end

			F_000244()

			task.spawn(function()
				task.wait(0.3)
				F_000244()
				task.wait(0.7)
				F_000244()
				task.wait(1.5)
				F_000244()
			end)

			task.defer(function()
				pcall(function()
					if U62.MainFrame then
						U62.MainFrame.DescendantAdded:Connect(function(A250_1)
							if A250_1:IsA("TextButton") then
								task.defer(function()
									local L251_1 = A250_1.Parent

									if L251_1 then
										L251_1 = L251_1.Name == "Tabs" or L251_1.Name == "TabboxButtons"
									end

									if L251_1 or A250_1.Name == "TabButton" or A250_1:FindFirstChild("ButtonHolder") or A250_1:FindFirstChild("ButtonContent") then
										local L251_2 = A250_1:FindFirstChildWhichIsA("ImageLabel", true)

										if L251_2 then
											F_000236(A250_1, L251_2)
										end
									end
								end)
							end
						end)
					end
				end)
			end)
		end

		do
			local U216 = 20

			local function F_000252(A252_1, A252_2)
				if not A252_1 or not A252_1:IsA("UICorner") then
					return
				end

				if A252_1.CornerRadius.Scale == 1 then
					return
				end
				local L252_1 = A252_1.Parent
				if not L252_1 then
					return
				end

				if L252_1.Name == "TabButton" or L252_1.Name == "TabIndicator" or L252_1.Name == "ST_WhatsNewVideoCard" then
					return
				end

				if L252_1:IsA("GuiObject") and L252_1.Parent and L252_1.Parent.Name == "TabboxButtons" then
					pcall(function()
						A252_1.CornerRadius = UDim.new(0, 4)

						if A252_1.TopLeftRadius then
							A252_1.TopLeftRadius = UDim.new(0, 4)
						end

						if A252_1.TopRightRadius then
							A252_1.TopRightRadius = UDim.new(0, 4)
						end

						if A252_1.BottomLeftRadius then
							A252_1.BottomLeftRadius = UDim.new(0, 0)
						end

						if A252_1.BottomRightRadius then
							A252_1.BottomRightRadius = UDim.new(0, 0)
						end
					end)

					return
				end

				local L252_2 = L252_1.Name
				local L252_3 = L252_2 == "MainFrame" or L252_2 == "SideBar" or L252_2 == "GroupboxHolder" or L252_2 == "ST_2DAuraBG" or L252_2 == "AuraBase" or L252_2 == "TabboxHolder" or L252_2 == "KeybindFrame" or L252_2 == "WarningBox" or L252_2 == "DialogFrame" or L252_2 == "BottomBackground" or L252_2 == "SearchBox"
				local L252_4 = false

				if L252_3 then
					L252_4 = true
				end

				A252_2 = A252_2 or 20
				local U217 = L252_4 and A252_2 or math.max(1, math.floor(A252_2 * 0.5))

				pcall(function()
					if A252_1.CornerRadius.Scale == 0 then
						A252_1.CornerRadius = UDim.new(0, U217)
					end
				end)

				pcall(function()
					if A252_1.TopLeftRadius and A252_1.TopLeftRadius.Offset > 0 then
						A252_1.TopLeftRadius = UDim.new(0, U217)
					end

					if A252_1.TopRightRadius and A252_1.TopRightRadius.Offset > 0 then
						A252_1.TopRightRadius = UDim.new(0, U217)
					end

					if A252_1.BottomLeftRadius and A252_1.BottomLeftRadius.Offset > 0 then
						A252_1.BottomLeftRadius = UDim.new(0, U217)
					end

					if A252_1.BottomRightRadius and A252_1.BottomRightRadius.Offset > 0 then
						A252_1.BottomRightRadius = UDim.new(0, U217)
					end
				end)
			end

			U94 = function(A256_1)
				U216 = A256_1 or 20

				pcall(function()
					U91:SetCornerRadius(U216)
				end)

				pcall(function()
					if U62.ScreenGui then
						for I89, I90 in ipairs(U62.ScreenGui:GetDescendants()) do
							if I90:IsA("UICorner") then
								F_000252(I90, U216)
							end
						end
					end

					local L258_1 = U91 and U91.MainFrame
					local L258_2

					if L258_1 then
						L258_2 = L258_1
					else
						local L258_3 = U62

						if U62 then
							L258_2 = U62.MainFrame
						else
							L258_2 = L258_3
						end
					end

					if L258_2 then
						local L258_4 = L258_2:FindFirstChild("ST_2DAuraBG")

						if L258_4 then
							for I91, I92 in ipairs(L258_4:GetDescendants()) do
								if I92:IsA("UICorner") and I92.CornerRadius.Scale == 0 then
									I92.CornerRadius = UDim.new(0, U216)
								end
							end

							local L258_5 = L258_4:FindFirstChildOfClass("UICorner")

							if L258_5 then
								L258_5.CornerRadius = UDim.new(0, U216)
							end
						end
					end
				end)
			end

			pcall(function()
				if U62.ScreenGui then
					U62.ScreenGui.DescendantAdded:Connect(function(A260_1)
						if A260_1:IsA("UICorner") then
							task.defer(function()
								F_000252(A260_1, U216)
							end)
						end
					end)
				end
			end)
		end

		U94(20)

		pcall(function()
			local L262_1 = getmetatable(U92.Home).__index
			local U218 = L262_1.AddCheckbox

			L262_1.AddCheckbox = function(A263_1, A263_2, A263_3)
				local L263_1 = U218(A263_1, A263_2, A263_3)

				if L263_1 and L263_1.Holder then
					for I93, I94 in ipairs(L263_1.Holder:GetChildren()) do
						if I94:IsA("Frame") then
							local L263_2 = I94:FindFirstChildOfClass("UICorner")

							if L263_2 then
								L263_2.CornerRadius = UDim.new(1, 0)
								local L263_3 = table.find(U62.Corners, L263_2)

								if L263_3 then
									table.remove(U62.Corners, L263_3)
								end
							end
						end
					end
				end

				return L263_1
			end

			local U219 = L262_1.AddTabbox

			if U219 then
				L262_1.AddTabbox = function(A264_1, A264_2)
					local U220 = U219(A264_1, A264_2)

					if U220 and U220.AddTab then
						local U221 = U220.AddTab

						U220.AddTab = function(A265_1, A265_2, A265_3)
							local L265_1 = U221(A265_1, A265_2, A265_3)

							pcall(function()
								if U220.Holder then
									for I95, I96 in ipairs(U220.Holder:GetDescendants()) do
										if I96:IsA("UICorner") and I96.Parent and I96.Parent.Parent and I96.Parent.Parent.Name == "TabboxButtons" then
											I96.CornerRadius = UDim.new(0, 4)

											if I96.TopLeftRadius then
												I96.TopLeftRadius = UDim.new(0, 4)
											end

											if I96.TopRightRadius then
												I96.TopRightRadius = UDim.new(0, 4)
											end

											if I96.BottomLeftRadius then
												I96.BottomLeftRadius = UDim.new(0, 0)
											end

											if I96.BottomRightRadius then
												I96.BottomRightRadius = UDim.new(0, 0)
											end

											local L266_1 = table.find(U62.Corners, I96)

											if L266_1 then
												table.remove(U62.Corners, L266_1)
											end

											local L266_2 = table.find(U62.SpecificCorners, I96)

											if L266_2 then
												table.remove(U62.SpecificCorners, L266_2)
											end
										end
									end
								end
							end)

							return L265_1
						end
					end

					return U220
				end
			end

			local function F_000267(A267_1, A267_2)
				local L267_1 = {}

				if typeof(A267_2) == "table" then
					for I97, I98 in pairs(A267_2) do
						L267_1[I97] = I98
					end
				end

				if typeof(A267_1) == "table" then
					for I99, I100 in pairs(A267_1) do
						if typeof(I100) == "string" and not L267_1[I100] then
							if U132[I100] then
								L267_1[I100] = U132[I100]
							elseif I100:find("@") or U67:FindFirstChild(I100) then
								L267_1[I100] = "user"
							else
								L267_1[I100] = "circle-dot"
							end
						end
					end
				end

				return L267_1
			end

			local U222 = L262_1.AddDropdown

			if U222 then
				L262_1.AddDropdown = function(A268_1, A268_2, A268_3)
					if typeof(A268_3) == "table" then
						A268_3.ValueImages = F_000267(A268_3.Values, A268_3.ValueImages)
					end

					local U223 = U222(A268_1, A268_2, A268_3)

					if U223 and U223.SetValues then
						local U224 = U223.SetValues

						U223.SetValues = function(A269_1, A269_2)
							U223.ValueImages = F_000267(A269_2, U223.ValueImages)
							return U224(A269_1, A269_2)
						end
					end

					return U223
				end
			end
		end)

		U95 = function()
			pcall(function()
				if writefile then
					local L271_1 = {
						AutoExecute = U66.HomeAutoExecute and U66.HomeAutoExecute.Value or false,
						AutoAntiLag = U66.HomeAutoAntiLag and U66.HomeAutoAntiLag.Value or U66.AutoAntiLag and U66.AutoAntiLag.Value or false,
					}

					writefile("SilentTarget_HomeConfig.json", game:GetService("HttpService"):JSONEncode(L271_1))
				end
			end)
		end

		local U225

		do
			local L0_313 = U92.Home:AddGroupbox({
				Side = 1,
				Name = "<b>Silent Target</b>",
				IconName = "info",
				Description = "Welcome & Community",
				MaxPopOutHeight = 600,
				PopOutWidth = 250,
			}):AddTabbox({ MaxPopOutHeight = 600 })

			U225 = L0_313:AddTab("<b>Welcome</b>", "award")

			pcall(function()
				local L272_1 = Instance.new("Frame")
				L272_1.Name = "ST_GreetingsCharCard"
				L272_1.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
				L272_1.BorderSizePixel = 0
				L272_1.Size = UDim2.new(1, 0, 0, 150)
				L272_1.ClipsDescendants = true
				L272_1.Parent = U225.Container
				local L272_2 = Instance.new("UICorner")
				L272_2.CornerRadius = UDim.new(0, 16)
				L272_2.Parent = L272_1
				local L272_3 = Instance.new("UIStroke")
				L272_3.Color = Color3.fromRGB(38, 38, 46)
				L272_3.Thickness = 1
				L272_3.Parent = L272_1
				local L272_4 = Instance.new("ViewportFrame")
				L272_4.Name = "ST_CharViewport"
				L272_4.BackgroundTransparency = 1
				L272_4.Size = UDim2.fromScale(1, 1)
				L272_4.Position = UDim2.fromScale(0.5, 0.5)
				L272_4.AnchorPoint = Vector2.new(0.5, 0.5)
				L272_4.LightColor = Color3.fromRGB(255, 255, 255)
				L272_4.LightDirection = Vector3.new(-1, -1, -2)
				L272_4.Ambient = Color3.fromRGB(180, 180, 180)
				L272_4.Parent = L272_1
				U136(L272_4, true, 7.5)
			end)

			local L0_314 = tonumber(os.date("%H"))
			local L0_315

			if L0_314 >= 5 and L0_314 < 12 then
				L0_315 = "Good Morning"
			else
				local L0_316 = L0_314 >= 12 and L0_314 < 18
				L0_315 = "Good Evening"

				if L0_316 then
					L0_315 = "Good Afternoon"
				end
			end

			local function F_000273(A273_1)
				local U226 = U225:AddLabel(A273_1, true)

				pcall(function()
					if U226 and U226.TextLabel then
						U226.TextLabel.AutoLocalize = false
					end
				end)

				return U226
			end

			F_000273(L0_315 .. ", <b>" .. U68.Name .. "</b>")
			F_000273("Make sure to <b>report</b> bugs to <b>us</b>")
			U225:AddDivider()
			F_000273("The <b>Owner</b> is <b>Gg13_ST</b>")
			F_000273("<b>Developed</b> by <b>8msd</b>")
			U225:AddDivider()
			F_000273("<b>Thank You</b> for buying....")
			local U227 = L0_313:AddTab("<b>DISCORD</b>", "bell")
			U227:AddDivider("LINK")

			U227:AddButton({
				Text = "<b>Copy DISCORD Link</b>",
				Func = function()
					pcall(function()
						if setclipboard then
							setclipboard("https://discord.gg/bCfzhHfZS5")
						elseif syn and syn.write_clipboard then
							syn.write_clipboard("https://discord.gg/bCfzhHfZS5")
						elseif toclipboard then
							toclipboard("https://discord.gg/bCfzhHfZS5")
						elseif Clipboard and Clipboard.set then
							Clipboard.set("https://discord.gg/bCfzhHfZS5")
						end
					end)

					pcall(function()
						if U62 and U62.Notify then
							U62:Notify({ Title = "DISCORD", Description = "Copied to Clipboard!", Duration = 3 })
						end
					end)
				end,
				DoubleClick = false,
			})

			local function F_000278(A278_1)
				local U228 = U227:AddLabel(A278_1, true)

				pcall(function()
					if U228 and U228.TextLabel then
						U228.TextLabel.AutoLocalize = false
					end
				end)

				return U228
			end

			F_000278("<b>Contact</b> with <b>8msd</b>")
		end

		pcall(function()
			U225:Show()
		end)

		local U229, U230

		local L0_317 = U92.Home:AddGroupbox({
			Side = 2,
			Name = "<b>Other</b>",
			IconName = "menu",
			Description = "Updates & Menu",
			MaxPopOutHeight = 600,
			PopOutWidth = 250,
		}):AddTabbox({ MaxPopOutHeight = 600 })

		U229 = L0_317:AddTab("<b>Menu</b>", "user-lock")

		U229:AddToggle("EnableBetterGUI", {
			Text = "<b>Enable Better GUI</b>",
			Default = true,
			Callback = function(A281_1)
				U140(A281_1)
			end,
		})

		U229:AddDivider()

		U229:AddToggle("WatermarkInfoToggle", {
			Text = "<b>Info</b>",
			Default = true,
			Callback = function(A282_1)
				U113(A282_1)
			end,
		})

		U229:AddInput("CustomWatermarkImage", {
			Text = "<b>Custom Image</b>",
			Default = "",
			Placeholder = "Image URL or Asset ID",
			Finished = true,
			Callback = function(A283_1)
				U112(A283_1)
			end,
		})

		U229:AddDivider()

		U229:AddToggle("WatermarkToggle", {
			Text = "<b>Watermark</b>",
			Default = true,
			Callback = function(A284_1)
				U62:SetWatermarkVisibility(A284_1)
			end,
		})

		U229:AddDivider()

		U229:AddToggle("ShowCustomCursor", {
			Text = "<b>Custom Cursor</b>",
			Default = true,
			Callback = function(A285_1)
				U62.ShowCustomCursor = A285_1
			end,
		})

		U229:AddDropdown("NotificationSide", {
			Values = { "Left", "Right" },
			ValueImages = { Left = "arrow-left", Right = "arrow-right" },
			Default = "Right",
			Text = "<b>Notification Side</b>",
			Callback = function(A286_1)
				U62:SetNotifySide(A286_1)
			end,
		})

		U229:AddDropdown("DPIDropdown", {
			Values = { "50%", "75%", "100%", "125%", "150%", "175%", "200%" },
			ValueImages = {
				["50%"] = "monitor",
				["75%"] = "monitor",
				["100%"] = "monitor",
				["125%"] = "monitor",
				["150%"] = "monitor",
				["175%"] = "monitor",
				["200%"] = "monitor",
			},
			Default = "100%",
			Text = "<b>DPI Scale</b>",
			Callback = function(A287_1)
				local L287_1 = A287_1:gsub("%%", "")
				U62:SetDPIScale(tonumber(L287_1))
			end,
		})

		U229:AddSlider("CornerRadiusSlider", {
			Text = "Corner Radius",
			Default = 20,
			Min = 1,
			Max = 40,
			Rounding = 0,
			Compact = true,
			Callback = function(A288_1)
				U94(A288_1)
			end,
		})

		U229:AddDivider()
		U229:AddLabel("<b>Menu bind</b>"):AddKeyPicker("MenuKeybind", { Default = "RightShift", NoUI = true, Text = "<b>Menu keybind</b>" })

		U229:AddButton({
			Text = "<b>Unload</b>",
			Func = function()
				U62:Unload()
			end,
			DoubleClick = false,
		})

		U62.ToggleKeybind = U65.MenuKeybind
		U230 = L0_317:AddTab("<b>Whats New?</b>", "sparkles")
		local L0_318

		L0_318 = function(A290_1)
			local U231 = U230:AddLabel(A290_1, true)

			pcall(function()
				if U231 and U231.TextLabel then
					U231.TextLabel.AutoLocalize = false
				end
			end)

			return U231
		end

		U230:AddDivider("View")
		local U232
		U232 = Instance.new("Frame")
		U232.Name = "ST_WhatsNewVideoCard"
		U232.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
		U232.BorderSizePixel = 0
		U232.Size = UDim2.new(1, 0, 0, 150)
		U232.ClipsDescendants = true
		U232.Parent = U230.Container
		local L0_319 = Instance.new("UIStroke")
		L0_319.Color = Color3.fromRGB(40, 40, 48)
		L0_319.Thickness = 1
		L0_319.Parent = U232
		local U233 = Instance.new("ImageLabel")
		U233.Name = "ST_SpriteDisplay"
		U233.BackgroundTransparency = 1
		U233.Size = UDim2.fromScale(1, 1)
		U233.Position = UDim2.fromScale(0.5, 0.5)
		U233.AnchorPoint = Vector2.new(0.5, 0.5)
		U233.ScaleType = Enum.ScaleType.Fit
		U233.Parent = U232

		task.spawn(function()
			local L292_1 = {
				{ url = "https://files.catbox.moe/tkxnbp.png", file = "ST_Video_Crisp1.png" },
				{ url = "https://files.catbox.moe/ajoxsc.png", file = "ST_Video_Crisp2.png" },
			}

			local function F_000293(A293_1, A293_2)
				if not (writefile and getcustomasset) then
					return A293_1
				end

				if isfile and isfile(A293_2) then
					local L293_1, L293_2 = pcall(function()
						return getcustomasset(A293_2)
					end)

					if L293_1 and L293_2 then
						return L293_2
					end
				end

				local function F_000295(A295_1)
					local U234 = syn and syn.request or http and http.request or http_request or request

					if U234 then
						local L295_1, L295_2 = pcall(function()
							return U234({ Url = A295_1, Method = "GET", Headers = { ["User-Agent"] = "Roblox/WinInet" } })
						end)

						local L295_3 = L295_1 and L295_2
						local L295_4

						if L295_3 then
							L295_4 = L295_2.StatusCode == 200 or L295_2.Status == 200
						else
							L295_4 = L295_3
						end

						if L295_4 and L295_2.Body and #L295_2.Body > 500 then
							return L295_2.Body
						end
					end

					local L295_5, L295_6 = pcall(function()
						return game:HttpGet(A295_1)
					end)

					if L295_5 and L295_6 and #L295_6 > 500 then
						return L295_6
					end
					return nil
				end

				local U235 = F_000295(A293_1)

				if U235 and #U235 > 500 then
					pcall(function()
						writefile(A293_2, U235)
					end)

					if isfile and isfile(A293_2) then
						local L293_3, L293_4 = pcall(function()
							return getcustomasset(A293_2)
						end)

						if L293_3 and L293_4 then
							return L293_4
						end
					end
				end

				return A293_1
			end

			local L292_2 = F_000293(L292_1[1].url, L292_1[1].file)
			local L292_3 = F_000293(L292_1[2].url, L292_1[2].file)
			U233.ImageRectSize = Vector2.new(252, 134)
			local L292_4 = 0

			while U232 and U232.Parent do
				local L292_5 = L292_4 >= 28 and L292_3 or L292_2

				if U233.Image ~= L292_5 then
					U233.Image = L292_5
				end

				local L292_6 = L292_4 % 28
				U233.ImageRectOffset = Vector2.new(L292_6 % 4 * 256 + 2, math.floor(L292_6 / 4) * 144 + 5)
				L292_4 = (L292_4 + 1) % 56
				task.wait(0.0625)
			end
		end)

		L0_318("<b>Might take a while for the video to load!</b>")

		pcall(function()
			U230:Resize()
		end)

		U230:AddDivider()

		local function F_000301()
			local L301_1 = Instance.new("Frame")
			L301_1.Name = "Spacer"
			L301_1.BackgroundTransparency = 1
			L301_1.Size = UDim2.new(1, 0, 0, 4)
			L301_1.Parent = U230.Container
		end

		L0_318("<b>Added Smooth Clone</b>")
		F_000301()
		L0_318("<b>Added Custom Maps</b>")
		F_000301()
		L0_318("<b>Added Toy Kill</b>")
		F_000301()
		L0_318("<b>Fixed Bugs</b>")
		U230:AddDivider()
		L0_318("Are <b>you</b> feeling full of <b>ideas</b>?")
		local U236 = L0_318("Let <b>us</b> know on <font color=\"#5865F2\"><b>DISCORD</b></font>")

		task.spawn(function()
			local function F_000303(A303_1)
				pcall(function()
					if U236 and U236.SetText then
						U236:SetText(A303_1)
					elseif U236 and U236.TextLabel then
						U236.TextLabel.Text = A303_1
					end
				end)
			end

			while U230 and U230.Container and U230.Container.Parent do
				for I101 = 1, 7 do
					F_000303("Let <b>us</b> know on " .. "<font color=\"#5865F2\"><b>" .. ("DISCORD"):sub(1, I101) .. "</b></font>")
					task.wait(0.24285714285714285)
				end

				for I102 = 1, 3 do
					task.wait(0.2)
					F_000303("Let <b>us</b> know on ")
					task.wait(0.2)
					F_000303("Let <b>us</b> know on <font color=\"#5865F2\"><b>DISCORD</b></font>")
				end

				task.wait(1)
			end
		end)

		pcall(function()
			U229:Show()
		end)

		local L0_320

		L0_320 = U92.Defence:AddGroupbox({
			Side = 1,
			Name = "<b>Defence</b>",
			IconName = "shield",
			Description = "Protection",
			MaxPopOutHeight = 600,
			PopOutWidth = 250,
		})

		local U237
		U237 = false
		local U238, U239, U240

		do
			local U241 = nil
			U238 = nil
			local U242 = nil
			local U243 = nil

			U239 = function()
				if U241 then
					task.cancel(U241)
					U241 = nil
				end

				pcall(function()
					local L307_1 = typeof(gethui) == "function" and gethui() or game:GetService("CoreGui")

					if L307_1 then
						local L307_2 = L307_1:FindFirstChild("urban1's universal GUI")

						if L307_2 then
							L307_2:Destroy()
						end
					end

					local L307_3 = U68:FindFirstChild("PlayerGui")

					if L307_3 then
						local L307_4 = L307_3:FindFirstChild("urban1's universal GUI")

						if L307_4 then
							L307_4:Destroy()
						end
					end
				end)

				local L306_1 = U68.Character
				local L306_2 = L306_1 and L306_1:FindFirstChild("HumanoidRootPart")
				L306_1 = L306_1 and L306_1:FindFirstChildOfClass("Humanoid")
				if not L306_2 then
					return
				end
				local L306_3 = L306_2.Position.Y
				local U244

				if (U65 and U65.FakePosType and U65.FakePosType.Value or "Normal") == "Safe (House)" then
					U244 = CFrame.new(544.24, -7.35, 75.92)
				else
					U244 = CFrame.new(0, 0, 0)
				end

				if U242 then
					U242:Destroy()
					U242 = nil
				end

				local L306_4 = Instance.new("Part")
				L306_4.Name = "FakePosPart"
				L306_4.Anchored = false
				L306_4.CanCollide = false
				L306_4.CanTouch = false
				L306_4.CanQuery = false
				L306_4.Transparency = 1
				L306_4.Size = Vector3.new(200000, 200000, 200000)
				L306_4.CFrame = U244
				L306_4.Parent = workspace
				U242 = L306_4
				local L306_5 = Instance.new("BodyPosition")
				L306_5.Position = U244.Position
				L306_5.MaxForce = Vector3.new(1e9, 0, 1e9)
				L306_5.D = 500
				L306_5.P = 10000
				L306_5.Parent = L306_4

				if U243 then
					U243:Destroy()
				end

				U243 = Instance.new("BodyPosition")
				U243.Name = "YAxisLock"
				U243.Position = Vector3.new(0, L306_3, 0)
				U243.MaxForce = Vector3.new(0, 1e9, 0)
				U243.P = 100000
				U243.D = 500
				U243.Parent = L306_2

				if L306_1 then
					L306_1:SetStateEnabled(Enum.HumanoidStateType.Jumping, false)
				end

				pcall(sethiddenproperty, L306_2, "PhysicsRepRootPart", U242)

				U241 = task.spawn(function()
					while U237 do
						local L308_1 = U68.Character and U68.Character:FindFirstChild("HumanoidRootPart")

						if L308_1 and U242 and U242.Parent then
							U242.CFrame = U244
							U242.AssemblyLinearVelocity = Vector3.zero
							U242.AssemblyAngularVelocity = Vector3.zero
							local L308_2 = L308_1.AssemblyLinearVelocity
							L308_1.AssemblyLinearVelocity = Vector3.new(L308_2.X, 0, L308_2.Z)
							pcall(sethiddenproperty, L308_1, "PhysicsRepRootPart", U242)
						end

						U69.Heartbeat:Wait()
					end
				end)
			end

			U240 = function()
				U237 = false

				if U241 then
					task.cancel(U241)
					U241 = nil
				end

				local L309_1 = U68.Character
				local L309_2 = L309_1 and L309_1:FindFirstChild("HumanoidRootPart")
				L309_1 = L309_1 and L309_1:FindFirstChildOfClass("Humanoid")

				if L309_2 then
					pcall(sethiddenproperty, L309_2, "PhysicsRepRootPart", L309_2)
				end

				if U242 then
					U242:Destroy()
					U242 = nil
				end

				if U243 then
					U243:Destroy()
					U243 = nil
				end

				if L309_1 then
					L309_1:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
				end
			end
		end

		do
			local U245 = false
			local U246 = nil
			local U247 = nil

			L0_320:AddToggle("AntiGrab", {
				Tooltip = "Grab Protection",
				Text = "Anti Grab",
				Default = false,
				Callback = function(A310_1)
					U245 = A310_1

					if A310_1 then
						U247 = U69.Stepped:Connect(function()
							if not U245 then
								return
							end
							local L311_1 = U68:FindFirstChild("IsHeld")

							if L311_1 and L311_1.Value then
								local L311_2 = U68.Character

								if L311_2 then
									local L311_3 = L311_2:FindFirstChild("Humanoid")

									if L311_3 then
										if L311_3.Sit then
											L311_3.Sit = false
										end

										if L311_3.PlatformStand then
											L311_3.PlatformStand = false
										end
									end
								end
							end
						end)

						U246 = task.spawn(function()
							while U245 do
								pcall(function()
									local L313_1 = U68:FindFirstChild("IsHeld")

									if L313_1 and L313_1.Value then
										local L313_2 = U68.Character

										if L313_2 then
											local L313_3 = L313_2:FindFirstChild("Humanoid")
											local L313_4 = L313_2:FindFirstChild("HumanoidRootPart")

											if L313_3 and L313_4 then
												game:GetService("ReplicatedStorage").CharacterEvents.Struggle:FireServer(U68)
												game:GetService("ReplicatedStorage").CharacterEvents.RagdollRemote:FireServer(L313_4, 1e-11)

												if L313_3.Sit then
													L313_3.Sit = false
												end
											end
										end
									end
								end)

								task.wait(0.025)
							end
						end)
					else
						if U247 then
							U247:Disconnect()
							U247 = nil
						end

						if U246 then
							task.cancel(U246)
							U246 = nil
						end
					end
				end,
			}):AddKeyPicker("AntiGrabKey", {
				Default = "None",
				Mode = "Toggle",
				SyncToggleState = true,
				Text = "Anti Grab Keybind",
				Callback = function()
				end,
			})
		end

		do
			local U248 = {
				Coconut = "FoodCoconut",
				Banana = "FoodBanana",
				Fries = "FoodFrenchFries",
				MeatStick = "FoodMeatStick",
				Poop = "PoopPile",
				Donut = "FoodDonut",
				Cake = "FoodCakePink",
				Burger = "FoodHamburger",
				Hamburger = "FoodHamburger",
				Pizza = "FoodPizzaCheese",
				Hotdog = "FoodHotdog",
				Mushroom = "FoodMushroomPoison",
				Banjo = "InstrumentGuitarBanjo",
				Violin = "InstrumentGuitarViolin",
				Ukulele = "InstrumentGuitarUkulele",
				Sax = "InstrumentWoodwindSaxophone",
				Vuvuzela = "InstrumentBrassVuvuzela",
				Bongos = "InstrumentDrumBongos",
				Mic = "InstrumentVoiceMicrophone",
				Pepperoni = "FoodPizzaPepperoni",
				Piano = "InstrumentPianoMelodica",
				Bread = "FoodBread",
				Egg = "FoodDippyEgg",
				Mayo = "FoodMayonnaise",
				WhiteMug = "CupMugWhite",
				Ocarina = "InstrumentWoodwindOcarina",
				SparklePoop = "PoopPileSparkle",
				BrownMug = "CupMugBrown",
				Trumpet = "InstrumentBrassTrumpet",
				Snare = "InstrumentDrumSnare",
				Lyre = "InstrumentGuitarLyre",
				Watermelon = "FoodWatermelon",
				["Turkey Leg"] = "PetTurkeyLeg",
				["Ice Cream"] = "FoodIceCream",
				Apple = "FoodApple",
				Taco = "FoodTaco",
				Cookie = "FoodCookie",
			}

			local U249 = false
			local U250 = nil
			local U251 = nil

			L0_320:AddToggle("AntiNetworkOwnership", {
				Tooltip = "Prevents other players from taking network ownership",
				Text = "Anti Network Ownership",
				Default = false,
				Callback = function(A315_1)
					U249 = A315_1

					if A315_1 then
						if U251 then
							U251:Disconnect()
						end

						U251 = U68.CharacterAdded:Connect(function()
							task.wait(1)
						end)

						U250 = task.spawn(function()
							local U252 = U68
							local U253 = game:GetService("ReplicatedStorage").MenuToys.SpawnToyRemoteFunction

							while U249 do
								pcall(function()
									local L318_1 = U65.AntiNetworkFood and U65.AntiNetworkFood.Value or "Burger"
									local U254 = U248[L318_1] or "Food" .. L318_1
									local U255 = U252.Character
									local U256 = U255 and U255:FindFirstChild("HumanoidRootPart")

									if U256 then
										local L318_2 = workspace:FindFirstChild(U252.Name .. "SpawnedInToys")
										local U257 = L318_2 and L318_2:FindFirstChild(U254)

										if not U257 then
											task.spawn(function()
												pcall(function()
													U253:InvokeServer(U254, U256.CFrame * CFrame.new(0, -12, 0), Vector3.zero)
												end)
											end)

											task.wait(0.1)
											local L318_3 = workspace:FindFirstChild(U252.Name .. "SpawnedInToys")
											U257 = L318_3 and L318_3:FindFirstChild(U254)
										end

										if U257 and U257.Parent then
											local U258 = U257:FindFirstChild("HoldPart")

											if U258 then
												for I103, I104 in pairs(U257:GetDescendants()) do
													if I104:IsA("BasePart") then
														I104.CanCollide = false
														I104.Massless = true
													end
												end

												task.spawn(function()
													pcall(function()
														U258.HoldItemRemoteFunction:InvokeServer(U257, U255)
													end)
												end)

												task.wait(0.02)

												task.spawn(function()
													pcall(function()
														U258.DropItemRemoteFunction:InvokeServer(U257, CFrame.new(0, 5000, 0), Vector3.zero)
													end)
												end)
											end
										end
									end
								end)

								task.wait(U65.AntiNetworkDelay and U65.AntiNetworkDelay.Value or 0.02)
							end
						end)
					else
						if U250 then
							task.cancel(U250)
							U250 = nil
						end

						if U251 then
							U251:Disconnect()
							U251 = nil
						end
					end
				end,
			}):AddKeyPicker("AntiNetworkOwnershipKey", {
				Default = "None",
				Mode = "Toggle",
				SyncToggleState = true,
				Text = "Anti Network Ownership Keybind",
				Callback = function()
				end,
			})
		end

		pcall(function()
			setfflag("S2PhysicsSenderRate", 1000)
		end)

		do
			local U259 = false
			local U260 = nil
			local U261 = sethiddenproperty or set_hidden_property or set_hidden_prop
			local U262 = nil

			local function F_000327()
				if not U262 or not U262.Parent then
					U262 = Instance.new("Part")
					U262.Name = "DesyncDummy"
					U262.Transparency = 1
					U262.CanCollide = false
					U262.Anchored = false
					U262.CFrame = CFrame.new(0, 10000000, 0)

					pcall(function()
						U262.Parent = workspace:FindFirstChild("Terrain") or workspace
					end)
				end

				return U262
			end

			local function F_000329(A329_1, A329_2)
				if not U261 or not A329_1 or not A329_1.Parent then
					return
				end

				if not pcall(function()
					U261(A329_1, "PhysicsRepRootPart", A329_2)
				end) and A329_2 == nil then
					pcall(function()
						U261(A329_1, "PhysicsRepRootPart", F_000327())
					end)
				end
			end

			local function F_000332()
				if U260 then
					task.cancel(U260)
					U260 = nil
				end

				U260 = task.spawn(function()
					while U259 do
						local L333_1 = U68.Character
						local L333_2 = L333_1 and L333_1:FindFirstChild("HumanoidRootPart")

						if L333_1 and L333_2 and L333_2.Parent and L333_1.Parent then
							local L333_3 = 0

							while true do
								if U259 and U68.Character == L333_1 and L333_2.Parent then
									if L333_3 <= 0 then
										F_000329(L333_2, nil)
										task.wait(0.1)

										if not (not U259 or U68.Character ~= L333_1 or not L333_2.Parent) then
											F_000329(L333_2, L333_2)
											L333_3 = 20
											task.wait(0.0041666666666666666)
											continue
										end
									else
										L333_3 -= 1
										F_000329(L333_2, L333_2)
										task.wait(0.0041666666666666666)
										continue
									end
								end

								break
							end
						else
							task.wait(0.3)
						end
					end
				end)
			end

			local function F_000334()
				U259 = false

				if U260 then
					task.cancel(U260)
					U260 = nil
				end

				local L334_1 = U68.Character
				local L334_2 = L334_1 and L334_1:FindFirstChild("HumanoidRootPart")

				if L334_2 and L334_2.Parent then
					F_000329(L334_2, L334_2)
				end

				if U262 then
					pcall(function()
						U262:Destroy()
					end)

					U262 = nil
				end
			end

			local U263 = nil

			local function F_000336(A336_1)
				U259 = A336_1

				if U259 then
					F_000332()

					if U263 then
						U263:Disconnect()
					end

					U263 = U68.CharacterAdded:Connect(function(A337_1)
						A337_1:WaitForChild("HumanoidRootPart")
						F_000332()
					end)
				else
					F_000334()

					if U263 then
						U263:Disconnect()
						U263 = nil
					end
				end
			end

			L0_320:AddToggle("Desync", {
				Tooltip = "Seatless Gucci",
				Text = "Desync",
				Default = false,
				Callback = function(A338_1)
					F_000336(A338_1)
				end,
			}):AddKeyPicker("DesyncKey", {
				Default = "None",
				Mode = "Toggle",
				SyncToggleState = true,
				Text = "Desync Keybind",
				Callback = function()
				end,
			})
		end

		local U264, U265

		do
			local U266 = 0
			U264 = false
			U265 = nil

			local function F_000340(A340_1, A340_2, A340_3)
				local L340_1 = A340_1:FindFirstChild(A340_2)

				if not L340_1 then
					L340_1 = A340_1:WaitForChild(A340_2, A340_3 or 3)
				end

				return L340_1
			end

			local function F_000341(A341_1)
				if not A341_1 then
					return
				end

				pcall(function()
					local L342_1 = U73:FindFirstChild("GrabEvents")
					L342_1 = L342_1 and L342_1:FindFirstChild("SetNetworkOwner")

					if L342_1 then
						L342_1:FireServer(A341_1, A341_1.CFrame)
					end
				end)
			end

			local function F_000343(A343_1, A343_2)
				if not A343_1 then
					return
				end

				pcall(function()
					local L344_1 = U73:FindFirstChild("CharacterEvents")

					if L344_1 and L344_1:FindFirstChild("RagdollRemote") then
						L344_1.RagdollRemote:FireServer(A343_1, A343_2)
					end
				end)

				pcall(function()
					local L345_1 = U73:FindFirstChild("RagdollRemote")

					if L345_1 then
						L345_1:FireServer(A343_1, A343_2)
					end
				end)
			end

			local function F_000346(A346_1, A346_2, A346_3)
				local U267 = U73:FindFirstChild("MenuToys") and U73.MenuToys:FindFirstChild("SpawnToyRemoteFunction")
				if not U267 then
					return false
				end
				local L346_1 = U71:FindFirstChild(U68.Name .. "SpawnedInToys") or U71:WaitForChild(U68.Name .. "SpawnedInToys", 3)
				if not L346_1 then
					return false
				end
				local U268 = U73:FindFirstChild("MenuToys") and U73.MenuToys:FindFirstChild("DestroyToy")

				for I105, I106 in ipairs(L346_1:GetChildren()) do
					if I106.Name == A346_1 or I106.Name == "CreatureBlobman" or I106.Name == "Gucci" or #L346_1:GetChildren() >= 3 then
						if U268 then
							pcall(function()
								U268:FireServer(I106)
							end)
						end

						pcall(function()
							I106:Destroy()
						end)
					end
				end

				local L346_2 = U68:FindFirstChild("CanSpawnToy")

				if L346_2 and not L346_2.Value then
					local L346_3 = tick()

					while L346_2 and not L346_2.Value and tick() - L346_3 < 2.5 do
						task.wait(0.02)
					end
				end

				for I107 = 1, 2 do
					if L346_2 and not L346_2.Value then
						local L346_4 = tick()

						while L346_2 and not L346_2.Value and tick() - L346_4 < 2 do
							task.wait(0.02)
						end
					end

					local U269 = nil

					local L346_5 = L346_1.ChildAdded:Connect(function(A349_1)
						if (A349_1.Name == A346_1 or A349_1.Name == "CreatureBlobman") and A349_1:IsA("Model") then
							U269 = A349_1
						end
					end)

					pcall(function()
						U267:InvokeServer(A346_1, A346_2, A346_3 or Vector3.new())
					end)

					local L346_6 = tick()

					while true do
						if not U269 and tick() - L346_6 < 1.5 then
							local L346_7 = L346_1:FindFirstChild("CreatureBlobman") or L346_1:FindFirstChild(A346_1)

							if L346_7 and L346_7:IsA("Model") and L346_7 ~= U265 then
								U269 = L346_7
								break
							else
								task.wait(0.02)
								continue
							end
						end

						break
					end

					L346_5:Disconnect()
					if U269 and U269.Parent then
						return U269
					end
					task.wait(0.1)
				end

				return false
			end

			local function F_000351()
				U266 += 1
				local U270 = U73:FindFirstChild("MenuToys") and U73.MenuToys:FindFirstChild("DestroyToy")

				if U265 and U265.Parent then
					pcall(function()
						if U270 then
							U270:FireServer(U265)
						end

						U265:Destroy()
					end)
				end

				U265 = nil
				local L351_1 = U71:FindFirstChild(U68.Name .. "SpawnedInToys")

				if L351_1 then
					for I108, I109 in pairs(L351_1:GetChildren()) do
						if I109.Name == "Gucci" or I109.Name == "CreatureBlobman" or I109.Name == "TractorGreen" then
							pcall(function()
								if U270 then
									U270:FireServer(I109)
								end

								I109:Destroy()
							end)
						end
					end
				end

				local L351_2 = U68.Character

				if L351_2 then
					local L351_3 = L351_2:FindFirstChildOfClass("Humanoid")
					local L351_4 = L351_2:FindFirstChild("HumanoidRootPart")

					if L351_3 then
						L351_3.Sit = false
						L351_3.PlatformStand = false
						L351_3:ChangeState(Enum.HumanoidStateType.GettingUp)
					end

					if L351_4 then
						L351_4.Velocity = Vector3.zero
						L351_4.RotVelocity = Vector3.zero
					end
				end
			end

			local function F_000354()
				local U271 = U68.Character
				if not U271 then
					return
				end
				local U272 = U271:FindFirstChildOfClass("Humanoid")
				local U273 = U271:FindFirstChild("HumanoidRootPart")

				pcall(function()
					local L355_1 = U73:FindFirstChild("GrabEvents")

					if L355_1 then
						local L355_2 = L355_1:FindFirstChild("SetNetworkOwner")
						local L355_3 = L355_1:FindFirstChild("DestroyGrabLine")

						if U273 and U273.Parent then
							if L355_3 then
								L355_3:FireServer(U273)
							end

							if L355_2 then
								L355_2:FireServer(U273, U273.CFrame)
							end
						end

						if L355_2 then
							for I110, I111 in ipairs(U271:GetChildren()) do
								if I111:IsA("BasePart") then
									L355_2:FireServer(I111, I111.CFrame)
								end
							end
						end
					end

					local L355_4 = U73:FindFirstChild("CharacterEvents")

					if L355_4 and L355_4:FindFirstChild("Struggle") then
						L355_4.Struggle:FireServer(U68)
					end
				end)

				pcall(function()
					if U273 and U273.Parent then
						F_000343(U273, 0)
						U273.AssemblyLinearVelocity = Vector3.zero
						U273.AssemblyAngularVelocity = Vector3.zero
					end

					if U272 and U272.Parent then
						U272.PlatformStand = false
						U272.Sit = false
						U272:ChangeState(Enum.HumanoidStateType.GettingUp)
					end
				end)

				pcall(function()
					if sethiddenproperty then
						sethiddenproperty(U68, "SimulationRadius", math.huge)
						sethiddenproperty(U68, "MaxSimulationRadius", math.huge)
					end

					if typeof(isnetworkowner) == "function" and U273 and not isnetworkowner(U273) then
						pcall(function()
							U273:SetNetworkOwner(U68)
						end)
					end
				end)
			end

			local U274 = nil

			local function F_000359()
				U266 += 1
				local U275 = U266
				local U276 = U68.Character or U68.CharacterAdded:Wait()
				local U277 = F_000340(U276, "Humanoid", 3)
				local U278 = F_000340(U276, "HumanoidRootPart", 3)
				if not U277 or not U278 then
					return false
				end
				F_000354()

				if U277 and U277.Parent then
					U277.PlatformStand = false
					U277.Sit = false

					pcall(function()
						U277:ChangeState(Enum.HumanoidStateType.GettingUp)
					end)
				end

				if U278 and U278.Parent then
					F_000343(U278, 0)
				end

				task.wait(0.02)
				U277.Sit = true
				task.wait(0.02)
				U277.Sit = false
				task.wait(0.02)
				F_000354()

				task.spawn(function()
					local L361_1 = tick()

					while tick() - L361_1 < 0.8 and U275 == U266 do
						if U276 and U276.Parent then
							for I112, I113 in pairs(U276:GetChildren()) do
								if I113:IsA("BasePart") then
									I113.Velocity = Vector3.new()
								end
							end
						end

						task.wait(0.01)
					end
				end)

				local U279 = true
				local U280 = nil
				local U281 = nil

				task.spawn(function()
					local L362_1 = tick()

					while not U280 and U275 == U266 and tick() - L362_1 < 3 do
						task.wait(0.01)
					end

					if U275 ~= U266 or not U280 then
						return
					end
					U281 = F_000340(U280, "Head", 3)
					local L362_2 = F_000340(U280, "GrabbableHitbox", 3)
					local L362_3 = tick()

					while U275 == U266 and U281 and L362_2 and tick() - L362_3 < 1.5 and (not U281:FindFirstChild("PartOwner") or U281.PartOwner.Value ~= U68.Name) do
						F_000341(L362_2)
						task.wait(0.02)
					end
				end)

				local L359_1 = U65.GucciType and U65.GucciType.Value or "Blobman"
				local U282

				if L359_1 == "Train" then
					if not U274 or not U274.Parent then
						U274 = nil

						for I114, I115 in ipairs(workspace:GetDescendants()) do
							if I115:IsA("Model") and I115.Name:lower():find("train") then
								U274 = I115
								break
							end
						end
					end

					local L359_2 = U274
					local L359_3 = U274

					if not L359_2 then
						local L359_4 = workspace:FindFirstChild(U68.Name .. "SpawnedInToys")

						if L359_4 then
							local PC1 = nil

							for I116 in ipairs(L359_4:GetChildren()) do
								if L359_3.Name:lower():find("train") then
									PC1 = 1
									break
								end
							end

							if PC1 ~= 1 then
								L359_3 = L359_2
							end
						else
							L359_3 = L359_2
						end
					end

					if not L359_3 then
						return false
					end
					local U283 = nil

					for I117, I118 in ipairs(L359_3:GetDescendants()) do
						if I118:IsA("VehicleSeat") or I118:IsA("Seat") then
							U283 = I118
							break
						end
					end

					if not U283 then
						return false
					end
					U280 = L359_3
					U265 = U280
					U281 = L359_3:FindFirstChild("Head")
					U282 = true

					task.defer(function()
						if not (U276 and U277) then
							return
						end
						local L363_1 = tick()

						while U279 and U275 == U266 and tick() - L363_1 < 0.15 do
							if U283 and U283.Parent and U283.Occupant ~= U277 then
								U283:Sit(U277)
							end

							task.wait(0.01)

							if U276 and U277 and U277.Parent then
								U277:ChangeState(Enum.HumanoidStateType.Jumping)
							end

							task.wait(0.01)
						end

						U279 = false
						U282 = false
					end)
				else
					local L359_5 = "CreatureBlobman"

					if L359_1 == "Tractor (Invisible)" then
						L359_5 = "TractorGreen"
					end

					U280 = F_000346(L359_5, U278.CFrame * CFrame.new(0, 0, -5), Vector3.new(0, -15.716, 0))
					if not U280 or not U280.Parent then
						return false
					end
					U265 = U280
					local L359_6 = F_000340(U280, "VehicleSeat", 3)
					local U284

					if L359_6 then
						U284 = L359_6
					else
						local function F_000364()
							for I119, I120 in ipairs(U280:GetDescendants()) do
								if I120:IsA("VehicleSeat") or I120:IsA("Seat") then
									return I120
								end
							end
						end

						U284 = F_000364()
					end

					if not U284 then
						return false
					end

					if L359_1 == "Blobman" then
						U281 = F_000340(U280, "Head", 3)
					end

					U282 = true

					task.defer(function()
						if not (U276 and U277) then
							return
						end
						local L365_1 = tick()

						while U279 and U275 == U266 and tick() - L365_1 < 0.15 do
							if U284 and U284.Parent and U284.Occupant ~= U277 then
								U284:Sit(U277)
							end

							task.wait(0.01)

							if U276 and U277 and U277.Parent then
								U277:ChangeState(Enum.HumanoidStateType.Jumping)
							end

							task.wait(0.01)
						end

						U279 = false
						U282 = false
					end)
				end

				task.defer(function()
					while U282 and U275 == U266 do
						if U276 and U278 and U278.Parent then
							F_000343(U278, 0)
							F_000341(U278)
						end

						task.wait(0.01)
					end
				end)

				task.wait(0.12)
				if U275 ~= U266 then
					return false
				end

				if U277 and U277.Parent then
					U277.Sit = false
				end

				U280.Name = "Gucci"

				for I121, I122 in pairs(U280:GetChildren()) do
					if I122:IsA("BasePart") then
						I122.CanCollide = false
						I122.CanTouch = false
						I122.CanQuery = false
					end
				end

				task.defer(function()
					while U275 == U266 and U280 and U280.Parent and U281 and U281.Parent do
						U281.CFrame = CFrame.new(U281.Position.X, 100000, U281.Position.Z)
						task.wait(0.01)
					end
				end)

				pcall(function()
					local L368_1 = U71:FindFirstChild(U68.Name .. "SpawnedInToys")
					local L368_2 = nil

					if L368_1 then
						L368_2 = nil

						for I123, I124 in ipairs(L368_1:GetChildren()) do
							if I124 == U280 or I124.Name == "Gucci" then
								L368_2 = I123
								break
							else
								L368_2 = nil
							end
						end
					end

					local L368_3 = U68.PlayerGui.MenuGui.Menu.TabContents.ToyDestroy.Contents

					if L368_3 and L368_2 then
						for I125, I126 in ipairs(L368_3:GetChildren()) do
							if I126.Name == "CreatureBlobman" and I125 == L368_2 then
								local L368_4 = I126:FindFirstChild("ViewItemButton")

								if L368_4 then
									L368_4.Text = "GUCCI"
									L368_4.TextScaled = true

									if L368_4:FindFirstChild("LowResImage") then
										L368_4.LowResImage.Image = ""
									end
								end
							end
						end
					end
				end)

				F_000354()
				return true
			end

			local U285 = nil

			local function F_000369(A369_1, A369_2)
				if not A369_1 or not A369_2 then
					return false
				end
				local L369_1 = A369_2:FindFirstChild("Ragdolled")
				if L369_1 and L369_1:IsA("BoolValue") and L369_1.Value then
					return true
				end

				if A369_2.PlatformStand then
					return true
				end
				local L369_2 = A369_2:GetState()
				if L369_2 == Enum.HumanoidStateType.Ragdoll or L369_2 == Enum.HumanoidStateType.FallingDown or L369_2 == Enum.HumanoidStateType.Physics then
					return true
				end
				local L369_3 = U68:FindFirstChild("IsHeld")
				if L369_3 and L369_3:IsA("BoolValue") and L369_3.Value then
					return true
				end
				local L369_4 = A369_1:FindFirstChild("Right Arm") or A369_1:FindFirstChild("RightUpperArm")

				if L369_4 and L369_4:FindFirstChild("RagdollLimbPart") then
					local L369_5 = L369_4:FindFirstChild("RagdollLimbPart")
					if L369_5 and L369_5.CanCollide then
						return true
					end
				end

				return false
			end

			local function F_000370(A370_1, A370_2, A370_3)
				if A370_3 and A370_3.Parent then
					F_000343(A370_3, 0)
				end

				if A370_2 then
					A370_2.PlatformStand = false
					A370_2.Sit = false
					A370_2:ChangeState(Enum.HumanoidStateType.GettingUp)
				end
			end

			local function F_000371()
				if U285 then
					task.cancel(U285)
					U285 = nil
				end

				if not U264 then
					return
				end

				U285 = task.spawn(function()
					while U264 do
						local L372_1 = U68.Character
						local U286 = L372_1 and L372_1:FindFirstChildOfClass("Humanoid")
						local L372_2 = L372_1 and L372_1:FindFirstChild("HumanoidRootPart")

						if not L372_1 or not U286 or not L372_2 or U286.Health <= 0 then
							U68.CharacterAdded:Wait()
							task.wait(0.5)
						else
							F_000354()
							F_000370(L372_1, U286, L372_2)

							if U286 and U286.Parent then
								U286.PlatformStand = false
								U286.Sit = false

								pcall(function()
									U286:ChangeState(Enum.HumanoidStateType.GettingUp)
								end)
							end

							local L372_3 = U68:FindFirstChild("IsHeld")

							if L372_3 and L372_3.Value then
								local L372_4 = tick()

								while L372_3 and L372_3.Value and U264 and tick() - L372_4 < 0.4 do
									pcall(function()
										local L374_1 = U73:FindFirstChild("CharacterEvents")

										if L374_1 and L374_1:FindFirstChild("Struggle") then
											L374_1.Struggle:FireServer(U68)
										end
									end)

									F_000354()
									task.wait(0.04)
								end
							end

							if not U264 then
								break
							else
								local L372_5 = F_000359()

								if not U264 then
									break
								elseif not L372_5 or not U265 or not U265.Parent then
									F_000351()
									F_000354()
									task.wait(0.4)
								else
									F_000354()
									task.wait(0.5)

									if not U264 then
										break
									else
										local L372_6 = tick()

										while U264 do
											local L372_7 = U68.Character
											U286 = L372_7 and L372_7:FindFirstChildOfClass("Humanoid")
											local L372_8 = L372_7 and L372_7:FindFirstChild("HumanoidRootPart")

											if not L372_7 or not U286 or not L372_8 or U286.Health <= 0 then
												F_000351()
												break
											else
												local L372_9 = not U265 or not U265.Parent
												local L372_10 = U68:FindFirstChild("IsHeld") and U68.IsHeld.Value
												local L372_11 = F_000369(L372_7, U286)

												if L372_9 or L372_10 or L372_11 then
													F_000351()
													F_000354()
													F_000370(L372_7, U286, L372_8)
													break
												elseif not (tick() - L372_6 >= 2.5) then
													task.wait(0.03)
												else
													L372_6 = tick()

													if L372_8 and L372_8.Parent then
														F_000343(L372_8, 0.1)
													end

													task.wait(0.2)
													local L372_12 = U68.Character
													U286 = L372_12 and L372_12:FindFirstChildOfClass("Humanoid")
													local L372_13 = L372_12 and L372_12:FindFirstChild("HumanoidRootPart")

													if not L372_12 or not U286 or not L372_13 or U286.Health <= 0 then
														F_000351()
														break
													elseif F_000369(L372_12, U286) then
														F_000351()
														F_000354()
														F_000370(L372_12, U286, L372_13)
														break
													else
														task.wait(0.03)
													end
												end
											end
										end
									end
								end
							end
						end
					end
				end)
			end

			L0_320:AddToggle("AutoGucci", {
				Tooltip = "People wont able to grab you",
				Text = "Auto Gucci",
				Default = false,
				Callback = function(A375_1)
					U264 = A375_1

					if A375_1 then
						F_000354()
						F_000371()
					else
						if U285 then
							task.cancel(U285)
							U285 = nil
						end

						F_000354()
						F_000351()
					end
				end,
			}):AddKeyPicker("AutoGucciKey", {
				Default = "None",
				Mode = "Toggle",
				SyncToggleState = false,
				Text = "Auto Gucci Keybind",
				Callback = function()
					if not U264 then
						if U66.AutoGucci then
							U66.AutoGucci:SetValue(true)
						end
					else
						F_000371()
					end
				end,
			})

			U68.CharacterAdded:Connect(function(A377_1)
				if U264 then
					task.wait(1)

					if U264 and U68.Character == A377_1 then
						F_000371()
					end
				end
			end)
		end

		do
			local L0_321, L0_322 = pcall(function()
				local L378_1 = game:GetService("Players")
				local U287 = game:GetService("RunService")
				local U288 = L378_1.LocalPlayer
				local U289 = typeof(getgenv) == "function" and getgenv() or _G

				if type(U289.ST_TPDecoyCleanup) == "function" then
					pcall(U289.ST_TPDecoyCleanup)
				end

				local K15 = 10
				local K16 = 0.6
				local K17 = 999999
				local K18 = 16
				local K19 = 50
				local U290 = nil
				local U291 = nil
				local U292 = nil
				local U293 = nil
				local U294 = 0
				local U295 = 0
				local U296 = os.clock()
				local U297 = nil
				local U298 = 0
				local U299 = 0
				local U300 = {}
				local U301 = false
				local U302 = nil

				local function F_000379(A379_1)
					return A379_1.X == A379_1.X and A379_1.Y == A379_1.Y and A379_1.Z == A379_1.Z and math.abs(A379_1.X) < 1000000 and math.abs(A379_1.Y) < 1000000 and math.abs(A379_1.Z) < 1000000
				end

				local function F_000380()
					local L380_1 = U288.Character
					if not L380_1 then
						return nil
					end
					local L380_2 = L380_1:FindFirstChildOfClass("Humanoid")
					local L380_3 = L380_1:FindFirstChild("HumanoidRootPart")
					if not L380_2 or not L380_3 then
						return nil
					end
					return L380_1, L380_2, L380_3
				end

				task.spawn(function()
					pcall(function()
						local L382_1 = U288:WaitForChild("PlayerScripts", 10)
						L382_1 = L382_1 and L382_1:WaitForChild("PlayerModule", 10)

						if L382_1 then
							U302 = require(L382_1):GetControls()
						end
					end)
				end)

				local function F_000383(A383_1, A383_2)
					local L383_1 = A383_2.RigType == Enum.HumanoidRigType.R15 and {
						idle = "rbxassetid://507766666",
						walk = "rbxassetid://507777826",
						jump = "rbxassetid://507765000",
						fall = "rbxassetid://507767968",
					} or {
						idle = "rbxassetid://180435571",
						walk = "rbxassetid://180426354",
						jump = "rbxassetid://125750702",
						fall = "rbxassetid://180436148",
					}

					local U303 = { idle = L383_1.idle, walk = L383_1.walk, jump = L383_1.jump, fall = L383_1.fall }
					local U304 = A383_1:FindFirstChild("Animate")

					if U304 then
						local function F_000384(A384_1, A384_2, A384_3)
							local L384_1 = U304:FindFirstChild(A384_1)
							L384_1 = L384_1 and L384_1:FindFirstChild(A384_2)

							if L384_1 and L384_1:IsA("Animation") and L384_1.AnimationId ~= "" then
								U303[A384_3] = L384_1.AnimationId
							end
						end

						F_000384("idle", "Animation1", "idle")
						F_000384("walk", "WalkAnim", "walk")
						F_000384("jump", "JumpAnim", "jump")
						F_000384("fall", "FallAnim", "fall")
					end

					return U303
				end

				local function F_000385(A385_1, A385_2)
					if A385_1.Health <= 0 or A385_1.Sit then
						return false
					end
					local L385_1 = A385_1:GetState()
					if L385_1 == Enum.HumanoidStateType.Ragdoll or L385_1 == Enum.HumanoidStateType.Dead or L385_1 == Enum.HumanoidStateType.Physics or L385_1 == Enum.HumanoidStateType.FallingDown or L385_1 == Enum.HumanoidStateType.Seated then
						return false
					end

					if not F_000379(A385_2.Position) then
						return false
					end
					return true
				end

				local function F_000386(A386_1)
					local L386_1 = A386_1.Archivable
					A386_1.Archivable = true

					local L386_2, L386_3 = pcall(function()
						return A386_1:Clone()
					end)

					A386_1.Archivable = L386_1
					if not L386_2 or not L386_3 then
						return nil
					end

					for I127, I128 in ipairs(L386_3:GetDescendants()) do
						if I128:IsA("BaseScript") or I128:IsA("Sound") or I128:IsA("ForceField") or I128:IsA("Constraint") or I128:IsA("BodyMover") or I128:IsA("BillboardGui") then
							pcall(function()
								I128:Destroy()
							end)
						end
					end

					local U305 = L386_3:FindFirstChildOfClass("Humanoid")
					local L386_4 = L386_3:FindFirstChild("HumanoidRootPart")
					if not U305 or not L386_4 then
						L386_3:Destroy()
						return nil
					end

					for I129, I130 in ipairs(L386_3:GetDescendants()) do
						if I130:IsA("BasePart") then
							I130.CanCollide = false
							I130.CanTouch = false
							I130.CanQuery = false
							I130.LocalTransparencyModifier = 0
						end
					end

					U305.PlatformStand = false
					U305.Sit = false
					U305.BreakJointsOnDeath = false
					U305.RequiresNeck = false
					U305.WalkSpeed = K18
					U305.UseJumpPower = true
					U305.JumpPower = K19

					if U305.MaxHealth > 0 then
						U305.Health = U305.MaxHealth
					end

					pcall(function()
						U305.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
						U305.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
					end)

					L386_3.PrimaryPart = L386_4
					return L386_3
				end

				local function F_000390(A390_1)
					local L390_1 = {}

					for I131, I132 in ipairs(A390_1:GetDescendants()) do
						if I132:IsA("BasePart") or I132:IsA("Decal") then
							L390_1[#L390_1 + 1] = I132
						end
					end

					return L390_1
				end

				local function F_000391(A391_1, A391_2)
					for I133 = 1, #A391_1 do
						local L391_1 = A391_1[I133]

						if L391_1.Parent then
							L391_1.LocalTransparencyModifier = A391_2
						end
					end
				end

				local function F_000392(A392_1, A392_2)
					local L392_1 = A392_1.tracks[A392_2]

					if not L392_1 then
						if not (A392_1.ids and A392_1.ids[A392_2]) then
							return nil
						end
						local U306 = Instance.new("Animation")
						U306.AnimationId = A392_1.ids[A392_2]
						local L392_2

						L392_2, L392_1 = pcall(function()
							return A392_1.animator:LoadAnimation(U306)
						end)

						if not L392_2 or not L392_1 then
							return nil
						end
						L392_1.Priority = Enum.AnimationPriority.Core
						L392_1.Looped = A392_2 == "idle" or A392_2 == "walk"
						A392_1.tracks[A392_2] = L392_1
					end

					return L392_1
				end

				local function F_000394(A394_1, A394_2)
					local L394_1 = Vector3.new(A394_2.X, 0, A394_2.Z).Magnitude
					local L394_2 = A394_1.hum:GetState()
					local L394_3

					if L394_2 == Enum.HumanoidStateType.Jumping then
						L394_3 = "jump"
					elseif L394_2 == Enum.HumanoidStateType.Freefall then
						L394_3 = "fall"
					elseif L394_1 > 0.05 then
						L394_3 = "walk"
					else
						L394_3 = "idle"
					end

					if L394_3 ~= A394_1.animState then
						local L394_4 = A394_1.animState and A394_1.tracks[A394_1.animState]

						if L394_4 then
							L394_4:Stop(0.15)
						end

						local L394_5 = F_000392(A394_1, L394_3)

						if L394_5 then
							L394_5:Play(0.15)
						end

						A394_1.animState = L394_3
					end
				end

				local function F_000395(A395_1, A395_2, A395_3)
					if U290 or not U291 then
						return
					end
					local L395_1 = U291:Clone()
					L395_1.Name = "ST_TPClone"
					L395_1:PivotTo(A395_1)
					L395_1.Parent = workspace
					local L395_2 = L395_1:FindFirstChildOfClass("Humanoid")
					local L395_3 = L395_1:FindFirstChild("HumanoidRootPart")
					if not L395_2 or not L395_3 then
						L395_1:Destroy()
						return
					end
					local L395_4 = L395_2:FindFirstChildOfClass("Animator") or Instance.new("Animator", L395_2)
					local U307 = nil

					if A395_3 then
						pcall(function()
							U307 = { ddt = A395_3.DisplayDistanceType, hdt = A395_3.HealthDisplayType }
							A395_3.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
							A395_3.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
						end)
					end

					local L395_5 = {}

					for I134, I135 in ipairs(A395_2:GetDescendants()) do
						if I135:IsA("BillboardGui") and I135.Enabled then
							L395_5[#L395_5 + 1] = I135

							pcall(function()
								I135.Enabled = false
							end)
						end
					end

					U290 = {
						model = L395_1,
						hum = L395_2,
						hrp = L395_3,
						animator = L395_4,
						tracks = {},
						animState = nil,
						ids = U293,
						realParts = {},
						partsTime = 0,
						realHum = A395_3,
						savedHum = U307,
						guis = L395_5,
						realLastPos = A395_1.Position,
						quietSince = os.clock(),
						startTime = os.clock(),
					}

					local L395_6 = workspace.CurrentCamera

					if L395_6 then
						L395_6.CameraSubject = L395_2
					end
				end

				local function F_000398()
					local U308 = U290
					if not U308 then
						return
					end
					U290 = nil
					pcall(F_000391, U308.realParts, 0)

					if U308.realHum and U308.savedHum and U308.realHum.Parent then
						pcall(function()
							U308.realHum.DisplayDistanceType = U308.savedHum.ddt
							U308.realHum.HealthDisplayType = U308.savedHum.hdt
						end)
					end

					for I136, I137 in ipairs(U308.guis) do
						if I137.Parent then
							pcall(function()
								I137.Enabled = true
							end)
						end
					end

					local L398_1, L398_2, U309 = F_000380()
					local L398_3 = workspace.CurrentCamera

					if L398_3 and L398_2 and L398_3.CameraSubject == U308.hum then
						L398_3.CameraSubject = L398_2
					end

					local U310 = U308.hrp and U308.hrp.Parent and U308.hrp.CFrame or nil

					if U309 and U310 then
						pcall(function()
							U309.CFrame = U310
							U309.AssemblyLinearVelocity = Vector3.zero
							U309.AssemblyAngularVelocity = Vector3.zero
						end)

						U298 = os.clock() + 0.25
					end

					for I138, I139 in pairs(U308.tracks) do
						pcall(function()
							I139:Stop(0)
						end)
					end

					pcall(function()
						U308.model:Destroy()
					end)

					if U309 and F_000379(U309.Position) then
						U297 = U309.CFrame
					else
						U297 = U310
					end
				end

				local function F_000404()
					local L404_1 = os.clock()
					local L404_2, L404_3, L404_4 = F_000380()
					if not L404_2 then
						return
					end

					if not U290 and L404_1 >= U295 and L404_1 - U296 > 0.8 and (not U291 or U292 ~= L404_2 or L404_1 - U294 > K17) then
						U295 = L404_1 + 0.25

						if F_000385(L404_3, L404_4) then
							local L404_5 = F_000386(L404_2)

							if L404_5 then
								if U291 then
									pcall(function()
										U291:Destroy()
									end)
								end

								U291 = L404_5
								U292 = L404_2
								U293 = F_000383(L404_2, L404_3)
								U294 = L404_1
							end
						end
					end

					local L404_6 = L404_4.Position
					local L404_7 = F_000379(L404_6)

					if L404_1 < U298 or L404_1 < U299 then
						if L404_7 then
							U297 = L404_4.CFrame
						end

						return
					end

					if not U290 then
						if not L404_7 or L404_7 and U297 and (L404_6 - U297.Position).Magnitude > K15 then
							if U297 then
								F_000395(U297, L404_2, L404_3)
							end

							L404_7 = not U290 and L404_7

							if L404_7 then
								U297 = L404_4.CFrame
							end
						elseif L404_7 then
							U297 = L404_4.CFrame
						end

						return
					end

					local L404_8 = U290
					if not L404_8.model.Parent then
						U290 = nil
						return
					end

					if L404_8.startTime and L404_1 - L404_8.startTime > 10 then
						F_000398()
						return
					end
					local L404_9 = workspace.CurrentCamera

					if L404_9 then
						local L404_10 = L404_9.CameraSubject

						if L404_10 ~= L404_8.hum and (L404_10 == nil or L404_10 == L404_3) then
							L404_9.CameraSubject = L404_8.hum
						end
					end

					if L404_1 - L404_8.partsTime > 0.5 then
						L404_8.realParts = F_000390(L404_2)
						L404_8.partsTime = L404_1
					end

					pcall(F_000391, L404_8.realParts, 1)
					local L404_11 = Vector3.zero

					if U302 then
						local L404_12

						L404_12, L404_11 = pcall(function()
							return U302:GetMoveVector()
						end)

						L404_12 = L404_12 and typeof(L404_11) == "Vector3"
						local L404_13 = Vector3.zero

						if not L404_12 then
							L404_11 = L404_13
						end
					end

					L404_8.hum:Move(L404_11, true)
					F_000394(L404_8, L404_11)

					if not L404_7 then
						L404_8.quietSince = nil
					else
						if L404_8.realLastPos and (L404_6 - L404_8.realLastPos).Magnitude > K15 then
							L404_8.quietSince = nil
						else
							L404_8.quietSince = L404_8.quietSince or L404_1
						end

						L404_8.realLastPos = L404_6
					end

					if L404_8.quietSince and L404_1 - L404_8.quietSince >= K16 then
						F_000398()
					end

					if L404_7 and L404_8.realLastPos and (L404_6 - L404_8.realLastPos).Magnitude > 60 then
						F_000398()
					end
				end

				local function F_000407(A407_1)
					F_000398()
					U297 = nil
					U296 = os.clock()
					U295 = 0
					local L407_1 = A407_1:WaitForChild("Humanoid", 10)

					if L407_1 then
						table.insert(U300, L407_1.Died:Connect(function()
							F_000398()
						end))
					end
				end

				table.insert(U300, U288.CharacterAdded:Connect(function(A409_1)
					task.spawn(F_000407, A409_1)
				end))

				if U288.Character then
					task.spawn(F_000407, U288.Character)
				end

				pcall(function()
					U287:UnbindFromRenderStep("ST_TPDecoyPre")
				end)

				U287:BindToRenderStep("ST_TPDecoyPre", Enum.RenderPriority.Camera.Value - 1, function(A411_1)
					local L411_1, L411_2 = pcall(F_000404, A411_1)

					if not L411_1 and not U301 then
						U301 = true
						warn("[ST] TP Clone error: " .. tostring(L411_2))
					end
				end)

				U289.ST_DecoyManual = function(A412_1)
					U299 = os.clock() + (tonumber(A412_1) or 2.5)
					F_000398()
					U297 = nil
				end

				U289.ST_TPDecoyCleanup = function()
					pcall(function()
						U287:UnbindFromRenderStep("ST_TPDecoyPre")
					end)

					F_000398()

					for I140, I141 in ipairs(U300) do
						pcall(function()
							I141:Disconnect()
						end)
					end

					table.clear(U300)

					if U291 then
						pcall(function()
							U291:Destroy()
						end)

						U291 = nil
					end

					U289.ST_DecoyManual = nil
					U289.ST_TPDecoyCleanup = nil
				end

				pcall(function()
					U62:OnUnload(function()
						if type(U289.ST_TPDecoyCleanup) == "function" then
							pcall(U289.ST_TPDecoyCleanup)
						end
					end)
				end)
			end)

			if not L0_321 then
				warn("[ST] TP Clone init error: " .. tostring(L0_322))
			end
		end

		local U311 = false

		L0_320:AddToggle("AntiLag", {
			Tooltip = "Protects from line lags",
			Text = "Anti Lag",
			Default = false,
			Callback = function(A419_1)
				U311 = A419_1

				if A419_1 then
					pcall(function()
						U68.PlayerScripts.CharacterAndBeamMove.Disabled = true

						for I142, I143 in pairs(U67:GetPlayers()) do
							if I143.Character and I143.Character:FindFirstChild("GrabParts") then
								I143.Character.GrabParts:Destroy()
							end
						end
					end)
				else
					pcall(function()
						U68.PlayerScripts.CharacterAndBeamMove.Disabled = false
					end)
				end
			end,
		}):AddKeyPicker("AntiLagKey", {
			Default = "None",
			Mode = "Toggle",
			SyncToggleState = true,
			Text = "Anti Lag Keybind",
			Callback = function()
			end,
		})

		do
			local U312 = {}
			local U313 = false
			local U314 = nil

			local function F_000423(A423_1)
				if U313 and A423_1 then
					for I144, I145 in ipairs(U312) do
						if A423_1 == I145 or A423_1.IsDescendantOf and A423_1:IsDescendantOf(I145) then
							return
						end
					end

					if A423_1.Name == "NinjaShuriken" or string.find(A423_1.Name:lower(), "ninjashuriken") then
						task.defer(function()
							pcall(function()
								A423_1:Destroy()
							end)
						end)
					end
				end
			end

			L0_320:AddToggle("AntiStickyLag", {
				Tooltip = "Deletes Stickys (Anti Kick may not work!)",
				Text = "Anti Sticky Lag",
				Default = false,
				Callback = function(A426_1)
					U313 = A426_1

					if A426_1 then
						for I146, I147 in ipairs(workspace:GetDescendants()) do
							F_000423(I147)
						end

						if not U314 then
							U314 = workspace.DescendantAdded:Connect(F_000423)
						end
					elseif U314 then
						U314:Disconnect()
						U314 = nil
					end
				end,
			}):AddKeyPicker("AntiStickyLagKey", {
				Default = "None",
				Mode = "Toggle",
				SyncToggleState = true,
				Text = "Anti Sticky Lag Keybind",
				Callback = function()
				end,
			})
		end

		L0_320:AddToggle("Anti Banana", {
			Tooltip = "Delete Legs",
			Text = "Anti Banana",
			Default = false,
			Callback = function(A428_1)
				if A428_1 then
					pcall(function()
						local U315 = U68.Character
						if not U315 then
							return
						end

						if U315:FindFirstChild("Left Leg") and U315:FindFirstChild("Right Leg") then
							local L429_1 = U315:FindFirstChild("Left Leg")
							local L429_2 = U315:FindFirstChild("Right Leg")
							local L429_3 = workspace.FallenPartsDestroyHeight
							local L429_4 = U315:FindFirstChild("Torso") or U315:FindFirstChild("UpperTorso")
							if not L429_4 then
								return
							end
							local L429_5 = L429_4.CFrame
							local L429_6 = U315:FindFirstChild("HumanoidRootPart")
							local U316 = U315:FindFirstChild("Humanoid")
							if not L429_6 or not U316 then
								return
							end
							workspace.FallenPartsDestroyHeight = -100
							game:GetService("ReplicatedStorage").CharacterEvents.RagdollRemote:FireServer(L429_6, 2)
							task.wait(0.5)
							L429_2.CFrame = CFrame.new(0, -10000, 0)
							L429_1.CFrame = CFrame.new(0, -10000, 0)
							task.wait(0.3)
							L429_4.CFrame = CFrame.new(0, -9970, 0)
							task.wait(0.5)
							L429_4.CFrame = L429_5
							task.wait(0.5)
							workspace.FallenPartsDestroyHeight = L429_3

							task.spawn(function()
								if not U315:FindFirstChild("Left Leg") and not U315:FindFirstChild("Right Leg") then
									while U315 and U315.Parent and U316 and U316.Health > 0 do
										pcall(function()
											local L431_1 = U68.PlayerGui:FindFirstChild("ControlsGui")

											if L431_1 and L431_1:FindFirstChild("PCFrame") and L431_1.PCFrame:FindFirstChild("Stand") then
												if L431_1.PCFrame.Stand.Visible == false then
													U316.HipHeight = 2
												else
													U316.HipHeight = 0
												end
											end
										end)

										task.wait()
									end
								end
							end)
						end
					end)
				end
			end,
		})

		local U317 = nil

		L0_320:AddToggle("BreakPCLD", {
			Tooltip = "Resets Twice",
			Text = "BreakPCLD",
			Default = false,
			Callback = function(A432_1)
				local U318 = false

				local function F_000433(A433_1)
					if not A433_1 then
						return
					end
					local L433_1 = A433_1:WaitForChild("Humanoid", 5)
					if not L433_1 then
						return
					end

					if not U318 then
						U318 = true
						L433_1:ChangeState(Enum.HumanoidStateType.Dead)
					else
						U318 = false
					end
				end

				if A432_1 then
					U317 = U68.CharacterAdded:Connect(function(A434_1)
						F_000433(A434_1)
					end)

					U318 = false
					local L432_1 = U68.Character
					L432_1 = L432_1 and L432_1:FindFirstChildOfClass("Humanoid")

					if L432_1 then
						L432_1.Health = 0
					end
				elseif U317 then
					U317:Disconnect()
					U317 = nil
				end
			end,
		})

		local U319 = false

		L0_320:AddToggle("AntiBlob", {
			Tooltip = "Protects from loops",
			Text = "Anti Blob",
			Default = false,
			Callback = function(A435_1)
				U319 = A435_1

				if A435_1 then
					task.spawn(function()
						while U319 do
							local L436_1 = U68.Character

							if L436_1 then
								if not L436_1:FindFirstChild("TruePositionPart") then
									local L436_2 = Instance.new("Part")
									L436_2.Parent = L436_1
									L436_2.Name = "TruePositionPart"
									L436_2.Anchored = true
									L436_2.CFrame = CFrame.new(0, -100, 0)
								end

								for I148, I149 in pairs(L436_1:GetChildren()) do
									if I149:IsA("BasePart") and I149.Massless then
										I149.Massless = false
									end

									if I149.Name == "HumanoidRootPart" and L436_1.HumanoidRootPart:FindFirstChild("RootAttachment") then
										for I150 = 1, 10 do
											task.wait()
										end

										if L436_1:FindFirstChild("HumanoidRootPart") and L436_1.HumanoidRootPart:FindFirstChild("RootAttachment") and L436_1:FindFirstChild("TruePositionPart") then
											L436_1.HumanoidRootPart.RootAttachment.Parent = L436_1.TruePositionPart
										end
									end
								end
							end

							task.wait()
						end
					end)
				else
					local L435_1 = U68.Character

					if L435_1 and L435_1:FindFirstChild("HumanoidRootPart") and L435_1:FindFirstChild("TruePositionPart") then
						if L435_1.TruePositionPart:FindFirstChild("RootAttachment") then
							L435_1.TruePositionPart.RootAttachment.Parent = L435_1.HumanoidRootPart
						end
					end
				end
			end,
		})

		do
			local U320 = true
			local U321 = nil

			local function F_000437()
				local U322 = game:GetService("ReplicatedStorage")
				local U323 = U322:WaitForChild("GrabEvents"):WaitForChild("SetNetworkOwner")
				local U324 = U322:WaitForChild("PlayerEvents"):WaitForChild("StickyPartEvent")
				local U325 = U322:WaitForChild("MenuToys"):WaitForChild("DestroyToy")
				local U326 = U68:WaitForChild("CanSpawnToy")

				local function F_000438()
					if U68.Character and U68.Character:FindFirstChild("HumanoidRootPart") then
						return U68.Character.HumanoidRootPart
					end
					return U68.CharacterAdded:Wait():WaitForChild("HumanoidRootPart")
				end

				local function F_000439()
					local U327

					pcall(function()
						if not workspace.PlotItems.PlayersInPlots:FindFirstChild(U68.Name) then
							return
						end

						for I151, I152 in pairs(workspace.Plots:GetChildren()) do
							pcall(function()
								for I153, I154 in pairs(I152.PlotSign.ThisPlotsOwners:GetChildren()) do
									if I154.Value == U68.Name then
										U327 = workspace.PlotItems[I152.Name]
									end
								end
							end)
						end
					end)

					if U327 then
						return true, U327
					end
					return false
				end

				local function F_000442(A442_1)
					if not A442_1 or not A442_1:FindFirstChild("StickyPart") then
						return
					end
					local L442_1 = F_000438()
					if not L442_1 then
						return
					end

					if A442_1:FindFirstChild("SoundPart") then
						if not A442_1.SoundPart:FindFirstChild("PartOwner") or A442_1.SoundPart.PartOwner.Value ~= U68.Name then
							U323:FireServer(A442_1.SoundPart, A442_1.SoundPart.CFrame)
						end
					end

					U324:FireServer(A442_1.StickyPart, L442_1:FindFirstChild("FirePlayerPart") or L442_1:WaitForChild("FirePlayerPart"), CFrame.new(0, 0, 0) * CFrame.Angles(0, 1.5707963267948966, 1.5707963267948966))

					for I155, I156 in pairs(A442_1:GetChildren()) do
						if I156.Name == "Pyramid" or I156.Name == "Main" then
							I156.CanTouch = false
							I156.CanCollide = false
							I156.CanQuery = false
							I156.Transparency = 0

							for I157, I158 in pairs(I156:GetChildren()) do
								if I158:IsA("Highlight") then
									I158:Destroy()
								end
							end
						elseif I156:IsA("BasePart") then
							I156.CanTouch = false
							I156.CanCollide = false
							I156.CanQuery = false
							I156.Transparency = 1
						end
					end

					pcall(function()
						if applyAntiKickESP then
							applyAntiKickESP(A442_1)
						end
					end)
				end

				local function F_000444()
					local L444_1 = workspace:FindFirstChild(U68.Name .. "SpawnedInToys")

					if L444_1 and U325 then
						for I159, I160 in pairs(L444_1:GetChildren()) do
							if I160.Name == "AntiKick" or I160.Name == "NinjaShuriken" then
								pcall(function()
									U325:FireServer(I160)
								end)
							end
						end
					end
				end

				local function F_000446(A446_1)
					while not U326.Value do
						U326.Changed:Wait()
					end

					local U328 = F_000438()
					if not U328 then
						return nil
					end

					task.spawn(function()
						pcall(function()
							U322.MenuToys.SpawnToyRemoteFunction:InvokeServer(A446_1, U328.CFrame * CFrame.new(0, 12, 20), Vector3.zero)
						end)
					end)

					local L446_1, L446_2 = F_000439()
					local L446_3 = workspace:FindFirstChild(U68.Name .. "SpawnedInToys")
					if L446_1 then
						return L446_2:WaitForChild(A446_1, 2)
					end

					if pcall(function()
						return not workspace.PlotItems.PlayersInPlots:FindFirstChild(U68.Name)
					end) then
						return L446_3 and L446_3:WaitForChild(A446_1, 2)
					end
					return nil
				end

				while U320 do
					task.wait(0.005)

					pcall(function()
						if not U68.Character or not U68.Character:FindFirstChild("Humanoid") or U68.Character.Humanoid.Health <= 0 then
							return
						end
						local L450_1 = workspace:FindFirstChild(U68.Name .. "SpawnedInToys")
						if not L450_1 then
							return
						end
						local U329 = L450_1:FindFirstChild("NinjaShuriken")

						local L450_2 = pcall(function()
							return workspace.PlotItems.PlayersInPlots:FindFirstChild(U68.Name)
						end) and workspace.PlotItems.PlayersInPlots:FindFirstChild(U68.Name)

						if L450_2 then
							local L450_3, U330 = F_000439()

							if L450_3 and U330 and workspace.Plots:FindFirstChild(U330.Name) then
								pcall(function()
									if workspace.Plots[U330.Name].PlotSign.ThisPlotsOwners:FindFirstChild("Value") and workspace.Plots[U330.Name].PlotSign.ThisPlotsOwners.Value.TimeRemainingNum.Value > 89 then
										U329 = F_000446("NinjaShuriken")

										if U329 then
											U329.Name = "AntiKick"
											F_000442(U329)
										end
									end
								end)
							end
						end

						if not U329 then
							if L450_2 then
								return
							end
							U329 = F_000446("NinjaShuriken")
							if not U329 then
								return
							end
							U329.Name = "AntiKick"
						end

						while true do
							if U329 and U329:FindFirstChild("StickyPart") and U329.StickyPart.CanTouch == true then
								F_000442(U329)
								U329.Name = "AntiKick"
							end

							task.wait(0.3)
							if not (not U329 or not U320 or not U329:FindFirstChild("StickyPart") or U329.StickyPart.CanTouch == false or not U68.Character or not U68.Character:FindFirstChild("HumanoidRootPart") or (U68.Character.HumanoidRootPart.Position - U329.StickyPart.Position).Magnitude >= 20) then
								continue
							end
							break
						end

						if not U329 or not U329:FindFirstChild("StickyPart") or not U68.Character or not U68.Character:FindFirstChild("HumanoidRootPart") or (U68.Character.HumanoidRootPart.Position - U329.StickyPart.Position).Magnitude >= 20 then
							F_000444()
						end

						pcall(function()
							while true do
								task.wait(0.05)
								if not (not U320 or not U68.Character or not U68.Character:FindFirstChild("Humanoid") or not U329 or not U329:FindFirstChild("StickyPart") or not U329.StickyPart:FindFirstChild("StickyWeld") or not U329.StickyPart.StickyWeld.Part1) then
									continue
								end
								break
							end

							if not U329 or not U329:FindFirstChild("StickyPart") or U68.Character and U68.Character:FindFirstChild("Humanoid") and U68.Character.Humanoid.Health <= 0 or not U329.StickyPart:FindFirstChild("StickyWeld").Part1 then
								F_000444()
							end
						end)
					end)
				end

				pcall(F_000444)
			end

			local function F_000454()
				if not U320 then
					return
				end

				if U321 then
					pcall(function()
						task.cancel(U321)
					end)

					U321 = nil
				end

				pcall(function()
					local L456_1 = workspace:FindFirstChild(U68.Name .. "SpawnedInToys")
					local U331 = game:GetService("ReplicatedStorage"):FindFirstChild("MenuToys") and game:GetService("ReplicatedStorage").MenuToys:FindFirstChild("DestroyToy")

					if L456_1 and U331 then
						for I161, I162 in pairs(L456_1:GetChildren()) do
							if I162.Name == "AntiKick" or I162.Name == "NinjaShuriken" then
								pcall(function()
									U331:FireServer(I162)
								end)
							end
						end
					end
				end)

				task.wait(0.2)

				if U320 then
					U321 = task.spawn(F_000437)
				end
			end

			U68.CharacterAdded:Connect(function(A458_1)
				task.spawn(function()
					A458_1:WaitForChild("HumanoidRootPart", 10)
					task.wait(0.3)

					if U320 then
						F_000454()
					end
				end)
			end)

			L0_320:AddToggle("AntiKick", {
				Tooltip = "Prevents you from getting kicked",
				Text = "Anti Kick",
				Default = true,
				Callback = function(A460_1)
					U320 = A460_1

					if A460_1 then
						F_000454()
					else
						if U321 then
							pcall(function()
								task.cancel(U321)
							end)

							U321 = nil
						end

						pcall(function()
							local L462_1 = workspace:FindFirstChild(U68.Name .. "SpawnedInToys")
							local U332 = game:GetService("ReplicatedStorage"):FindFirstChild("MenuToys") and game:GetService("ReplicatedStorage").MenuToys:FindFirstChild("DestroyToy")

							if L462_1 and U332 then
								for I163, I164 in pairs(L462_1:GetChildren()) do
									if I164.Name == "AntiKick" or I164.Name == "NinjaShuriken" then
										pcall(function()
											U332:FireServer(I164)
										end)
									end
								end
							end
						end)
					end
				end,
			})

			task.defer(function()
				task.wait(0.5)

				if U320 and F_000454 then
					F_000454()
				end
			end)
		end

		do
			local U333 = false
			local U334 = nil

			local function F_000465()
				if U334 then
					U334:Disconnect()
					U334 = nil
				end

				if not U333 then
					return
				end

				U334 = workspace.ChildAdded:Connect(function(A466_1)
					if A466_1.Name == "Part" and U333 then
						pcall(function()
							local L467_1 = U68.Character
							local L467_2 = L467_1 and L467_1:FindFirstChild("HumanoidRootPart")

							if L467_2 and (A466_1.Position - L467_2.Position).Magnitude <= 20 then
								L467_2.Anchored = true
								task.wait(0.01)
								local L467_3 = L467_1:FindFirstChild("Right Arm")

								if L467_3 then
									local L467_4 = L467_3:FindFirstChild("RagdollLimbPart")

									if L467_4 then
										while L467_4.CanCollide and U333 do
											task.wait(0.001)
										end
									end
								end

								if U333 and L467_2 and L467_2.Parent then
									L467_2.Anchored = false
								end
							end
						end)
					end
				end)
			end

			L0_320:AddToggle("AntiExplosion", {
				Tooltip = "Protects against rocket explosions",
				Text = "Anti Explosion",
				Default = false,
				Callback = function(A468_1)
					U333 = A468_1

					if A468_1 then
						F_000465()
					else
						if U334 then
							U334:Disconnect()
							U334 = nil
						end

						local L468_1 = U68.Character
						L468_1 = L468_1 and L468_1:FindFirstChild("HumanoidRootPart")

						if L468_1 then
							L468_1.Anchored = false
						end
					end
				end,
			})
		end

		do
			local U335 = false
			local U336 = nil
			local U337 = nil

			L0_320:AddToggle("AntiBurn", {
				Tooltip = "Prevents fire and burning damage",
				Text = "Anti Burn",
				Default = false,
				Callback = function(A469_1)
					U335 = A469_1

					if A469_1 then
						U336 = task.spawn(function()
							while U335 do
								pcall(function()
									local L471_1 = nil

									if U337 then
										L471_1 = U68.Character
									end

									if L471_1 and U68.Character:FindFirstChild("HumanoidRootPart") then
										U337.CFrame = U68.Character.HumanoidRootPart.CFrame
									end
								end)

								task.wait()
							end
						end)
					elseif U336 then
						task.cancel(U336)
						U336 = nil
					end
				end,
			})
		end

		L0_320:AddToggle("AntiVoid", {
			Tooltip = "Prevents you from dying to the void",
			Text = "Anti Void",
			Default = false,
			Callback = function(A472_1)
				if A472_1 then
					workspace.FallenPartsDestroyHeight = (0/0)
				else
					workspace.FallenPartsDestroyHeight = -100
				end
			end,
		})

		do
			local U338 = false
			local U339 = nil
			local U340 = nil

			L0_320:AddToggle("AntiPosion", {
				Tooltip = "Protects from posion",
				Text = "Anti Posion",
				Default = false,
				Callback = function(A473_1)
					U338 = A473_1

					if A473_1 then
						local function F_000474(A474_1)
							if A474_1:IsA("BasePart") and (A474_1.Name:lower():find("poison") or A474_1.Name:lower():find("mushroom")) then
								A474_1.CanTouch = false
								A474_1.CanCollide = false
								A474_1.CanQuery = false
								local U341 = A474_1:FindFirstChildWhichIsA("TouchTransmitter")

								if U341 then
									pcall(function()
										U341:Destroy()
									end)
								end
							end
						end

						for I165, I166 in ipairs(workspace:GetDescendants()) do
							F_000474(I166)
						end

						U339 = workspace.DescendantAdded:Connect(function(A476_1)
							if not U338 then
								return
							end

							task.defer(function()
								F_000474(A476_1)
							end)
						end)

						U340 = task.spawn(function()
							while U338 do
								pcall(function()
									local L479_1 = U68.Character

									if L479_1 then
										local L479_2 = L479_1:FindFirstChild("Humanoid")

										if L479_2 and L479_2.Health < 100 and L479_2.Health > 0 then
											L479_2.Health = 100
										end
									end
								end)

								task.wait(0.1)
							end
						end)
					else
						if U339 then
							U339:Disconnect()
							U339 = nil
						end

						if U340 then
							task.cancel(U340)
							U340 = nil
						end
					end
				end,
			})
		end

		do
			local U342 = {}
			local U343 = {}

			L0_320:AddToggle("AntiPaint", {
				Tooltip = "Prevents you from getting painted",
				Text = "Anti Paint",
				Default = false,
				Callback = function(A480_1)
					if A480_1 then
						pcall(function()
							for I167, I168 in ipairs(workspace:GetDescendants()) do
								if I168:IsA("BasePart") and I168.Name == "PaintPlayerPart" then
									U342[I168:GetDebugId()] = { clone = I168:Clone(), parent = I168.Parent }
									I168:Destroy()
								end
							end
						end)

						table.insert(U343, workspace.DescendantAdded:Connect(function(A482_1)
							if A482_1:IsA("BasePart") and A482_1.Name == "PaintPlayerPart" then
								task.defer(function()
									if A482_1 and A482_1.Parent then
										U342[A482_1:GetDebugId()] = { clone = A482_1:Clone(), parent = A482_1.Parent }
										A482_1:Destroy()
									end
								end)
							end
						end))
					else
						for I169, I170 in pairs(U342) do
							if I170.clone and I170.parent then
								I170.clone.Parent = I170.parent
							end
						end

						U342 = {}

						for I171, I172 in ipairs(U343) do
							if I172.Connected then
								I172:Disconnect()
							end
						end

						U343 = {}
					end
				end,
			})
		end

		do
			local U344 = nil
			local U345 = nil

			AntiLoopToggle = L0_320:AddToggle("AntiLoop", {
				Tooltip = "TP",
				Text = "Anti Loop",
				Default = false,
				Callback = function(A484_1)
					if U344 then
						U344:Disconnect()
						U344 = nil
					end

					if U345 then
						U345:Disconnect()
						U345 = nil
					end

					if A484_1 then
						local L484_1 = U65.AntiLoopType and U65.AntiLoopType.Value or "Safe"

						if L484_1 == "Safe" then
							U344 = U69.RenderStepped:Connect(function()
								pcall(function()
									local L486_1 = U68.Character
									L486_1 = L486_1 and L486_1:FindFirstChild("HumanoidRootPart")

									if L486_1 then
										L486_1.CFrame = CFrame.new(280, -4, 465)
									end
								end)
							end)
						elseif L484_1 == "Random" then
							local U346 = 0

							U345 = U69.RenderStepped:Connect(function(A487_1)
								pcall(function()
									local L488_1 = U68.Character
									L488_1 = L488_1 and L488_1:FindFirstChild("HumanoidRootPart")

									if L488_1 then
										U346 += A487_1 * 50000
										local L488_2 = math.rad(U346)
										L488_1.CFrame = CFrame.new(math.cos(L488_2) * 10000, 0, math.sin(L488_2) * 10000)
									end
								end)
							end)
						end
					end
				end,
			})
		end

		AntiLoopToggle:AddKeyPicker("AntiLoopKey", {
			Default = "None",
			Mode = "Toggle",
			SyncToggleState = true,
			Text = "Anti Loop Keybind",
			Callback = function()
			end,
		})

		do
			local U347 = false
			local U348 = nil

			L0_320:AddToggle("AntiSticky", {
				Tooltip = "Prevents sticky parts from sticking to you",
				Text = "Anti Sticky",
				Default = false,
				Callback = function(A490_1)
					U347 = A490_1

					if A490_1 then
						U348 = task.spawn(function()
							while U347 do
								pcall(function()
									local L492_1 = U68.Character

									if L492_1 then
										for I173, I174 in ipairs(L492_1:GetDescendants()) do
											if (I174:IsA("Weld") or I174:IsA("WeldConstraint") or I174:IsA("TouchTransmitter")) and (I174.Name:lower():find("sticky") or I174.Parent and I174.Parent.Name:lower():find("sticky")) then
												I174:Destroy()
											end
										end
									end
								end)

								task.wait(0.1)
							end
						end)
					elseif U348 then
						task.cancel(U348)
						U348 = nil
					end
				end,
			})
		end

		do
			local L0_323 = U92.Defence:AddGroupbox({
				Side = 1,
				Name = "<b>Other</b>",
				IconName = "layers",
				Description = "Other Tools",
				MaxPopOutHeight = 600,
				PopOutWidth = 250,
			}):AddTabbox({ MaxPopOutHeight = 600 }):AddTab("<b>Settings</b>", "settings-2")

			L0_323:AddToggle("OtherFakePos", {
				Text = "Fakepos",
				IconName = "map-pin-off",
				Default = false,
				Tooltip = "Got Patched May not work!",
				Callback = function(A493_1)
					U237 = A493_1

					if _G.updateFakePosUI then
						_G.updateFakePosUI()
					end

					if A493_1 then
						U239()

						if U238 then
							U238:Disconnect()
						end

						U238 = U68.CharacterAdded:Connect(function(A494_1)
							A494_1:WaitForChild("HumanoidRootPart")
							U239()
						end)
					else
						U240()

						if U238 then
							U238:Disconnect()
							U238 = nil
						end
					end
				end,
			}):AddKeyPicker("OtherFakePosKey", {
				Default = "H",
				Mode = "Toggle",
				SyncToggleState = true,
				Text = "Fakepos Keybind",
				Callback = function()
				end,
			})

			L0_323:AddDropdown("FakePosType", {
				Text = "Fakepos Type",
				IconName = "list-filter",
				Default = "Normal",
				Values = { "Normal", "Safe (House)" },
				ValueImages = { Normal = "map-pin", ["Safe (House)"] = "house" },
				Callback = function()
				end,
			})

			local U349 = false
			local U350 = nil

			L0_323:AddToggle("LoopRagdoll", {
				Tooltip = "Ragdoll your own character",
				Text = "Loop Ragdoll",
				Default = false,
				Callback = function(A497_1)
					U349 = A497_1

					if A497_1 then
						U350 = task.spawn(function()
							while U349 do
								pcall(function()
									local L499_1 = U68.Character
									L499_1 = L499_1 and L499_1:FindFirstChild("HumanoidRootPart")

									if L499_1 then
										game:GetService("ReplicatedStorage").CharacterEvents.RagdollRemote:FireServer(L499_1, 0.5)
									end
								end)

								task.wait(0.05)
							end
						end)
					elseif U350 then
						task.cancel(U350)
						U350 = nil
					end
				end,
			}):AddKeyPicker("LoopRagdollKey", {
				Default = "None",
				Mode = "Toggle",
				SyncToggleState = true,
				Text = "Loop Ragdoll Keybind",
				Callback = function()
				end,
			})

			L0_323:AddDivider()

			L0_323:AddToggle("AutoReset", {
				Text = "Auto Reset",
				Tooltip = "Auto Reset for Kick frames",
				Default = true,
				Callback = function()
				end,
			})

			L0_323:AddDivider("Settings")

			L0_323:AddDropdown("AutoResetType", {
				Text = "AutoResetType",
				Values = { "1st Warning", "Prediction" },
				ValueImages = { ["1st Warning"] = "triangle-alert", Prediction = "sparkles" },
				Default = 1,
				Callback = function()
				end,
			})
		end

		do
			local U351 = nil
			local U352 = nil

			local function F_000503()
				if U351 then
					U351:Disconnect()
					U351 = nil
				end

				if U352 then
					pcall(function()
						task.cancel(U352)
					end)

					U352 = nil
				end

				if not (U66.AutoReset and U66.AutoReset.Value) then
					return
				end
				local L503_1 = U65.AutoResetType and U65.AutoResetType.Value

				if L503_1 == "1st Warning" then
					local L503_2 = game:GetService("ReplicatedStorage")
					local L503_3 = L503_2:WaitForChild("CharacterEvents", 2)
					local U353 = L503_3 and L503_3:WaitForChild("Struggle", 2)
					local L503_4 = L503_2:WaitForChild("GameCorrectionEvents", 2)
					L503_4 = L503_4 and L503_4:WaitForChild("GameCorrectionsNotify", 2)

					if L503_4 then
						U351 = L503_4.OnClientEvent:Connect(function(A505_1)
							if A505_1 == "Flying" then
								if U353 then
									pcall(function()
										U353:FireServer(U68)
									end)
								end

								local L505_1 = U68.Character

								if L505_1 then
									local L505_2 = L505_1:FindFirstChildOfClass("Humanoid")

									if L505_2 and L505_2.Health > 0 then
										L505_2.Health = 0

										if U62 and U62.Notify then
											U62:Notify("Kick Frame Detected.", 3)
										end
									end
								end
							end
						end)
					end
				elseif L503_1 == "Prediction" then
					U352 = task.spawn(function()
						while true do
							if (_G.ST_cachedPing or 0) >= 2000 then
								local L507_1 = U68.Character

								if L507_1 then
									local L507_2 = L507_1:FindFirstChildOfClass("Humanoid")

									if L507_2 and L507_2.Health > 0 then
										L507_2.Health = 0

										if U62 and U62.Notify then
											U62:Notify("Kick Frame Detected.", 3)
										end

										task.wait(2)
									end
								end
							end

							task.wait(0.2)
						end
					end)
				end
			end

			U66.AutoReset:OnChanged(F_000503)
			U65.AutoResetType:OnChanged(F_000503)
		end

		local L0_324

		do
			local L0_325 = U92.Defence:AddGroupbox({
				Side = 2,
				Name = "<b>Defence Config</b>",
				IconName = "sliders-horizontal",
				Description = "Config",
				MaxPopOutHeight = 600,
				PopOutWidth = 250,
			}):AddTabbox({ MaxPopOutHeight = 600 })

			local L0_326 = L0_325:AddTab("<b>Settings</b>", "settings")
			L0_326:AddDivider("Gucci Options")

			L0_326:AddDropdown("GucciType", {
				Text = "Gucci Type",
				Values = { "Blobman", "Tractor (Invisible)", "Train" },
				ValueImages = { Blobman = "bot", ["Tractor (Invisible)"] = "tractor", Train = "train-front" },
				Default = "Blobman",
				Callback = function()
				end,
			})

			L0_326:AddDropdown("AntiNetworkFood", {
				Text = "AntiNetworkFood",
				Values = {
					"Coconut",
					"Banana",
					"Fries",
					"MeatStick",
					"Poop",
					"Donut",
					"Cake",
					"Burger",
					"Pizza",
					"Hotdog",
					"Mushroom",
					"Banjo",
					"Violin",
					"Ukulele",
					"Sax",
					"Vuvuzela",
					"Bongos",
					"Mic",
					"Pepperoni",
					"Piano",
					"Bread",
					"Egg",
					"Mayo",
					"WhiteMug",
					"Ocarina",
					"SparklePoop",
					"BrownMug",
					"Trumpet",
					"Snare",
					"Lyre",
				},
				ValueImages = L0_312,
				Default = "Burger",
				Callback = function()
				end,
			})

			L0_326:AddSlider("AntiNetworkDelay", {
				Text = "AntiNetworkDelay",
				Default = 0.1,
				Min = 0,
				Max = 0.5,
				Rounding = 2,
				Suffix = "sec",
				Compact = true,
				Callback = function()
				end,
			})

			L0_326:AddDivider()

			L0_326:AddDropdown("AntiLoopType", {
				Text = "Anti Loop Type",
				Values = { "Safe", "Random" },
				ValueImages = { Safe = "shield-check", Random = "shuffle" },
				Default = 1,
				Callback = function()
					if U66.AntiLoop and U66.AntiLoop.Value then
						U66.AntiLoop:SetValue(false)
						task.wait(0.05)
						U66.AntiLoop:SetValue(true)
					end
				end,
			})

			L0_326:AddToggle("AutoAntiLag", {
				Text = "Auto Anti Lag",
				Tooltip = "Automatically enables Anti Lag on FPS drops",
				Default = true,
				Callback = function(A512_1)
					pcall(U95)

					if U66.HomeAutoAntiLag and U66.HomeAutoAntiLag.Value ~= A512_1 then
						U66.HomeAutoAntiLag:SetValue(A512_1)
					end
				end,
			})

			L0_326:AddDivider()

			L0_326:AddSlider("AntiLagLimit", {
				Text = "Anti-Lag Limit",
				Default = 15,
				Min = 0,
				Max = 60,
				Rounding = 0,
				Suffix = " FPS",
				Compact = true,
				Callback = function()
				end,
			})

			local U354 = 0

			task.spawn(function()
				while true do
					task.wait(0.5)
					local L514_1 = U66.AutoAntiLag and U66.AutoAntiLag.Value
					local L514_2

					if L514_1 then
						L514_2 = L514_1
					else
						L514_2 = U66.HomeAutoAntiLag and U66.HomeAutoAntiLag.Value
					end

					if L514_2 then
						if cachedFps and cachedFps > 0 and cachedFps < (U65.AntiLagLimit and U65.AntiLagLimit.Value or 15) then
							if U66.AntiLag and not U66.AntiLag.Value then
								U66.AntiLag:SetValue(true)
								if not (tick() - U354 > 5) then
									continue
								end
								U354 = tick()

								U62:Notify({
									Title = "Silent Target",
									Description = "Auto Anti Lag Enabled.",
									Duration = 3,
									Icon = U76,
								})

								continue
							end
						end
					end
				end
			end)

			local L0_327 = L0_325:AddTab("<b>Other</b>", "shield-alert")
			L0_327:AddDivider()

			L0_327:AddDropdown("AntiKickType", {
				Text = "Anti Kick Type",
				Values = { "Sticky", "Item" },
				ValueImages = { Sticky = "magnet", Item = "package" },
				Default = 1,
				Multi = false,
				Callback = function()
				end,
			})

			L0_324 = L0_327:AddDependencyBox()
		end

		L0_324:SetupDependencies({ { U65.AntiKickType, "Sticky" } })
		L0_324:AddDivider("ESP")

		do
			local U355 = true
			local U356 = false
			local U357 = Color3.fromRGB(0, 0, 0)
			local U358 = {}

			local function F_000516()
				for I175, I176 in pairs(U358) do
					if I176 and I176.Parent then
						local L516_1 = U65.AntiKickOutlineColor and U65.AntiKickOutlineColor.Value or Color3.fromRGB(255, 255, 255)
						local L516_2 = U356 and U357 or U65.AntiKickChamsColor and U65.AntiKickChamsColor.Value or Color3.fromRGB(60, 60, 60)
						local L516_3 = U65.AntiKickChamsTransparency and U65.AntiKickChamsTransparency.Value or 0.58
						local L516_4 = U65.AntiKickOutlineTransparency and U65.AntiKickOutlineTransparency.Value or 0.1
						I176.FillColor = L516_2
						I176.OutlineColor = L516_1
						I176.FillTransparency = L516_3
						I176.OutlineTransparency = L516_4
					end
				end
			end

			local function F_000517(A517_1)
				if not A517_1 or U358[A517_1] then
					return
				end
				local L517_1 = Instance.new("Highlight")
				L517_1.Name = "AntiKick_ESP_Highlight"
				L517_1.Adornee = A517_1
				L517_1.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
				L517_1.Parent = A517_1
				U358[A517_1] = L517_1
				F_000516()
			end

			local function F_000518()
				for I177, I178 in pairs(U358) do
					pcall(function()
						if I178 then
							I178:Destroy()
						end
					end)
				end

				U358 = {}
			end

			task.spawn(function()
				while true do
					if U355 then
						local L520_1 = workspace:FindFirstChild(U68.Name .. "SpawnedInToys")

						if L520_1 then
							for I179, I180 in ipairs(L520_1:GetChildren()) do
								if I180.Name == "AntiKickItem" or I180.Name == "AntiKick" or I180.Name == "NinjaShuriken" or I180.Name == "NinjaShuriken1" or I180.Name == "SpookyCandle1" then
									if not U358[I180] then
										F_000517(I180)
									end
								end
							end
						end

						for I181, I182 in pairs(U358) do
							if not I181 or not I181.Parent then
								pcall(function()
									if I182 then
										I182:Destroy()
									end
								end)

								U358[I181] = nil
							end
						end
					end

					task.wait(0.5)
				end
			end)

			L0_324:AddToggle("EnableAntiKickESP", {
				Tooltip = "ESP",
				Text = "Enable Anti Kick ESP",
				Default = true,
				Callback = function(A522_1)
					U355 = A522_1

					if not A522_1 then
						F_000518()
					else
						F_000516()
					end
				end,
			})

			L0_324:AddLabel("Outline"):AddColorPicker("AntiKickOutlineColor", {
				Default = Color3.fromRGB(255, 255, 255),
				Title = "Outline Colors",
				Callback = function()
					F_000516()
				end,
			})

			L0_324:AddLabel("Chams"):AddColorPicker("AntiKickChamsColor", {
				Default = Color3.fromRGB(60, 60, 60),
				Title = "Chams Colors",
				Callback = function()
					F_000516()
				end,
			})

			L0_324:AddToggle("AntiKickRainbowESP", {
				Tooltip = "Rainbow ESP",
				Text = "Rainbow ESP",
				Default = false,
				Callback = function(A525_1)
					U356 = A525_1

					if A525_1 then
						task.spawn(function()
							while U356 and U355 do
								local L526_1 = U65.AntiKickRainbowSpeed and U65.AntiKickRainbowSpeed.Value or 5
								U357 = Color3.fromHSV(tick() * L526_1 / 5 % 1, 1, 1)
								F_000516()
								task.wait(0.05)
							end
						end)
					else
						F_000516()
					end
				end,
			})

			L0_324:AddSlider("AntiKickRainbowSpeed", {
				Text = "Rainbow Speed",
				Default = 5,
				Min = 1,
				Max = 10,
				Rounding = 0,
				Compact = true,
				Callback = function()
				end,
			})

			L0_324:AddDivider()

			L0_324:AddSlider("AntiKickOutlineTransparency", {
				Text = "Outline Transparency",
				Default = 0.1,
				Min = 0,
				Max = 1,
				Rounding = 2,
				Compact = true,
				Callback = function()
					F_000516()
				end,
			})

			L0_324:AddSlider("AntiKickChamsTransparency", {
				Text = "Chams Transparency",
				Default = 0.58,
				Min = 0,
				Max = 1,
				Rounding = 2,
				Compact = true,
				Callback = function()
					F_000516()
				end,
			})
		end

		L0_324:AddSlider("AntiKickOutlineThickness", {
			Text = "Outline Thickness",
			Default = 0.02,
			Min = 0.01,
			Max = 1,
			Rounding = 2,
			Compact = true,
			Callback = function()
			end,
		})

		local L0_328 = U92.Defence:AddGroupbox({
			Side = 2,
			Name = "<b>Status</b>",
			IconName = "activity",
			Description = "FPS and PING",
			MaxPopOutHeight = 600,
			PopOutWidth = 250,
		})

		FpsLabel = L0_328:AddLabel("FPS: <b>0</b>", true)
		PingLabel = L0_328:AddLabel("Ping: <b>0ms</b>", true)
		L0_328:AddDivider()

		L0_328:AddToggle("ShowOnScreen", {
			Tooltip = "Show FPS and PING on screen",
			Text = "Show On Screen",
			Default = true,
			Callback = function(A531_1)
				pcall(function()
					if A531_1 then
						U62:SetWatermark("<b>Silent Target</b> | " .. tostring(cachedFps) .. " fps | " .. tostring(cachedPing) .. " ms")
					else
						U62:SetWatermark("<b>Silent Target</b>")
					end
				end)
			end,
		})

		local U359
		local U360 = {}

		U359 = function(A533_1, A533_2)
			local L533_1 = tick()
			local L533_2 = U360[A533_1]

			if L533_2 then
				L533_2 = L533_1 - U360[A533_1] < (A533_2 or 5)
			end

			if L533_2 then
				return false
			end
			U360[A533_1] = L533_1
			return true
		end

		do
			local function F_000534(A534_1)
				if not A534_1 or A534_1 == "" then
					return "Unknown"
				end

				if typeof(A534_1) == "Instance" and A534_1:IsA("Player") then
					local L534_1 = A534_1.Name
					local L534_2 = A534_1.DisplayName or ""
					return L534_2 ~= "" and L534_2 ~= L534_1 and L534_1 .. " (" .. L534_2 .. ")" or L534_1
				end

				if type(A534_1) == "string" then
					local L534_3 = U67:FindFirstChild(A534_1)

					if L534_3 then
						local L534_4 = L534_3.Name
						local L534_5 = L534_3.DisplayName or ""
						return L534_5 ~= "" and L534_5 ~= L534_4 and L534_4 .. " (" .. L534_5 .. ")" or L534_4
					end

					return A534_1
				end

				if type(A534_1) == "number" then
					local L534_6 = U67:GetPlayerByUserId(A534_1)

					if L534_6 then
						local L534_7 = L534_6.Name
						local L534_8 = L534_6.DisplayName or ""
						return L534_8 ~= "" and L534_8 ~= L534_7 and L534_7 .. " (" .. L534_8 .. ")" or L534_7
					end

					local L534_9, L534_10 = pcall(function()
						return U67:GetNameFromUserIdAsync(A534_1)
					end)

					if L534_9 and L534_10 then
						return L534_10
					end
				end

				return tostring(A534_1)
			end

			local function F_000536(A536_1)
				if not A536_1 then
					return nil
				end
				local L536_1 = math.huge
				local L536_2 = nil

				for I183, I184 in pairs(U67:GetPlayers()) do
					if I184 ~= U68 and I184.Character then
						local L536_3 = I184.Character:FindFirstChild("HumanoidRootPart")

						if L536_3 then
							local L536_4 = (L536_3.Position - A536_1).Magnitude

							if L536_4 < L536_1 then
								L536_1 = L536_4
								L536_2 = I184
							end
						end
					end
				end

				return L536_2
			end

			local function F_000537(A537_1)
				if not A537_1 then
					return false
				end

				if U65.NoBlobmanTarget and U65.NoBlobmanTarget.Value then
					local L537_1 = tostring(U65.NoBlobmanTarget.Value)
					if L537_1 == A537_1.Name or L537_1:find(A537_1.Name) then
						return true
					end
				end

				if U65.BlobmanTarget and U65.BlobmanTarget.Value then
					local L537_2 = tostring(U65.BlobmanTarget.Value)
					if L537_2 == A537_1.Name or L537_2:find(A537_1.Name) then
						return true
					end
				end

				if hkKickTargets and hkKickTargets[A537_1.UserId] then
					return true
				end

				if hkKillTargets and hkKillTargets[A537_1.UserId] then
					return true
				end
				return false
			end

			local U361 = 0
			local U362 = {}

			local U363 = {
				blackholekick = true,
				["blackholekicktweens(old)"] = true,
				blackholekicktweens = true,
				jhole = true,
				blackhole = true,
				black_hole = true,
				voidhole = true,
				singularity = true,
			}

			U71.ChildAdded:Connect(function(A538_1)
				if not A538_1 or not A538_1.Name or not U363[A538_1.Name:lower()] then
					return
				end
				U361 = tick()

				task.delay(0.2, function()
					if A538_1 and A538_1.Parent then
						local L539_1 = A538_1:IsA("BasePart") and A538_1.Position or A538_1:FindFirstChildWhichIsA("BasePart", true) and A538_1:FindFirstChildWhichIsA("BasePart", true).Position

						if L539_1 then
							local L539_2 = F_000536(L539_1)

							if L539_2 and L539_2.Character and L539_2.Character:FindFirstChild("HumanoidRootPart") then
								if (L539_2.Character.HumanoidRootPart.Position - L539_1).Magnitude < 18 then
									U362[L539_2.UserId] = tick()
								end
							end
						end
					end
				end)
			end)

			U67.PlayerRemoving:Connect(function(A540_1)
				local L540_1 = U362[A540_1.UserId]

				if L540_1 then
					local L540_2 = U362[A540_1.UserId]
					L540_1 = tick() - L540_2 < 5
				end

				local L540_3

				if L540_1 then
					L540_3 = true
				else
					L540_3 = false

					if tick() - U361 < 3.5 then
						L540_3 = true
					end
				end

				if L540_3 then
					U86 += 1

					pcall(function()
						if U82 then
							U82.Text = "Kicked Players: <b>" .. tostring(U86) .. "</b>"
						end
					end)
				end

				if F_000537(A540_1) then
					if L540_3 then
						U62:Notify({
							Title = "<b>Target Kicked</b>",
							Description = "Target " .. F_000534(A540_1) .. " has been kicked!",
							Duration = 6,
							BigIcon = U76,
							Icon = U76,
						})
					else
						U62:Notify({
							Title = "<b>Target Left</b>",
							Description = "Target " .. F_000534(A540_1) .. " left the game!",
							Duration = 6,
							BigIcon = U76,
							Icon = U76,
						})
					end
				elseif L540_3 then
					if U359("kick_notify_" .. A540_1.UserId, 5) then
						U62:Notify({
							Title = "<b>Kick Detected</b>",
							Description = F_000534(A540_1) .. " has been kicked",
							Duration = 6,
							BigIcon = U76,
							Icon = U76,
						})
					end
				end
			end)

			local U364 = false
			local U365 = {}
			local U366 = 0
			local U367 = {}

			task.spawn(function()
				local L542_1 = U73:WaitForChild("GrabEvents", 10)
				if not L542_1 then
					return
				end
				local L542_2 = L542_1:WaitForChild("ExtendGrabLine", 5)

				if L542_2 then
					L542_2.OnClientEvent:Connect(function(A543_1, A543_2)
						if U66.PacketServerNotifications and not U66.PacketServerNotifications.Value then
							return
						end

						if typeof(A543_2) == "string" and not U364 then
							local L543_1 = string.len(A543_2)

							if L543_1 > 300 then
								U364 = true
								local L543_2 = math.round(L543_1 / 1048576 * 1000) / 1000
								local L543_3 = F_000534(A543_1)

								if A543_1 == U68 or A543_1 == U68.Name or A543_1 == U68.DisplayName then
									L543_3 = U68.Name .. " [YOU]"
								end

								U62:Notify({
									Title = "<b>Packet Lag Detected</b>",
									Description = "Source: " .. L543_3 .. "\nSize: " .. tostring(L543_2) .. " MB",
									Duration = 5,
									BigIcon = U76,
									Icon = U76,
								})

								task.delay(4, function()
									U364 = false
								end)
							end
						end
					end)
				end

				local L542_3 = L542_1:WaitForChild("CreateGrabLine", 5)

				if L542_3 then
					U69.RenderStepped:Connect(function()
						U366 += 1

						for I185, I186 in pairs(U367) do
							if I186 < U366 then
								local L545_1 = U365[I185]

								if L545_1 then
									L545_1.frameBurst = 0
								end

								U367[I185] = nil
							end
						end
					end)

					L542_3.OnClientEvent:Connect(function(A546_1, ...)
						if U66.LineServerNotifications and not U66.LineServerNotifications.Value then
							return
						end

						if typeof(A546_1) ~= "Instance" or not A546_1:IsA("Player") then
							return
						end

						if A546_1 == U68 and not lagLineActive then
							return
						end

						if not U365[A546_1] then
							U365[A546_1] = { count = 0, lastCallTime = 0, lastFrame = 0, frameBurst = 0 }
						end

						local L546_1 = U365[A546_1]
						local L546_2 = os.clock()

						if L546_1.lastFrame == U366 then
							L546_1.frameBurst = L546_1.frameBurst + 1
						else
							L546_1.lastFrame = U366
							L546_1.frameBurst = 1
							U367[A546_1] = U366
						end

						if L546_1.lastCallTime ~= 0 and L546_2 - L546_1.lastCallTime <= 0.025 then
							L546_1.count = 27
						else
							L546_1.count = L546_1.count + 1
						end

						L546_1.lastCallTime = L546_2
						local L546_3 = false

						for I187, I188 in ipairs({ ... }) do
							local L546_4

							if typeof(I188) == "CFrame" then
								L546_4 = I188.Position
							else
								L546_4 = nil

								if typeof(I188) == "Vector3" then
									L546_4 = I188
								end
							end

							if L546_4 then
								if math.abs(L546_4.X) > 10000 or math.abs(L546_4.Y) > 10000 or math.abs(L546_4.Z) > 10000 or L546_4.X ~= L546_4.X or L546_4.Y ~= L546_4.Y or L546_4.Z ~= L546_4.Z then
									L546_3 = true
									break
								end
							end
						end

						if L546_3 then
							if U359("line_abnormal_" .. A546_1.UserId, 5) then
								U62:Notify({
									Title = "<b>Line Lag Detected</b>",
									Description = "Source: " .. F_000534(A546_1),
									Duration = 5,
									BigIcon = U76,
									Icon = U76,
								})
							end

							L546_1.count = 0
						end
					end)
				end
			end)

			task.spawn(function()
				local function F_000548(A548_1)
					if not A548_1 then
						return
					end

					A548_1.Changed:Connect(function(A549_1)
						if U66.GrabNotifications and not U66.GrabNotifications.Value then
							return
						end

						if A549_1 then
							if not U359("grabbed_self", 3) then
								return
							end

							task.delay(0.05, function()
								if U66.GrabNotifications and not U66.GrabNotifications.Value then
									return
								end
								local L550_1 = U89()
								local L550_2 = L550_1 and F_000534(L550_1)

								if not L550_2 then
									local L550_3 = U68.Character and U68.Character:FindFirstChild("Head")
									L550_3 = L550_3 and L550_3:FindFirstChild("PartOwner")

									if L550_3 and L550_3.Value ~= "" then
										local L550_4 = U67:FindFirstChild(L550_3.Value)
										L550_2 = L550_4 and F_000534(L550_4) or L550_3.Value
									end
								end

								U62:Notify({
									Title = "<b>Grabbed</b>",
									Description = (L550_2 or "Someone") .. " is grabbing you!",
									Duration = 5,
									BigIcon = U76,
									Icon = U76,
								})
							end)
						elseif U359("released_self", 3) then
							U62:Notify({
								Title = "<b>Released</b>",
								Description = "You were released",
								Duration = 3,
								BigIcon = U76,
								Icon = U76,
							})
						end
					end)
				end

				local L547_1 = U68:FindFirstChild("IsHeld") or U68:WaitForChild("IsHeld", 10)

				if L547_1 then
					F_000548(L547_1)
				end

				U68.ChildAdded:Connect(function(A551_1)
					if A551_1.Name == "IsHeld" and A551_1:IsA("BoolValue") then
						F_000548(A551_1)
					end
				end)
			end)
		end

		local L0_329 = U92.Defence:AddGroupbox({
			Side = 2,
			Name = "<b>Infos</b>",
			IconName = "info",
			Description = "Player tracker",
			MaxPopOutHeight = 600,
			PopOutWidth = 250,
		})

		PlayerStatusLabel = L0_329:AddLabel("PlayerStatus: <b>None</b>", true)
		L0_329:AddDivider()
		LastPlayerLabel = L0_329:AddLabel("LastPlayerGrabbedYou: <b>None</b>", true)

		L0_329:AddToggle("GrabNotifications", {
			Text = "Notifications",
			Default = false,
			Tooltip = "Notifies you when someone grabs or releases you",
			Callback = function()
			end,
		})

		do
			local L0_330 = game:GetService("ReplicatedStorage"):WaitForChild("GrabEvents")
			local U368 = L0_330:WaitForChild("SetNetworkOwner")
			local U369 = L0_330:FindFirstChild("DestroyGrabLine")
			local U370 = false
			local U371 = nil

			local function F_000553(A553_1)
				if not A553_1 or not A553_1.Character then
					return
				end
				local U372 = A553_1.Character:FindFirstChild("HumanoidRootPart")
				if not U372 then
					return
				end

				pcall(function()
					U368:FireServer(U372, U372.CFrame)

					if U369 then
						U369:FireServer(U372)
					end

					local L554_1 = (U372.Position - U68.Character.HumanoidRootPart.Position).Unit
					local L554_2 = Vector3.new(L554_1.X, 0, L554_1.Z) * 99999999999999
					local L554_3 = Instance.new("BodyVelocity")
					L554_3.Name = "RinneganFling"
					L554_3.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
					L554_3.Velocity = L554_2
					L554_3.P = 12500
					L554_3.Parent = U372
					U72:AddItem(L554_3, 0.01)
				end)
			end

			local function F_000555()
				if U371 then
					return
				end

				U371 = U69.Heartbeat:Connect(function()
					if not U370 then
						return
					end
					local L556_1 = U89()

					if L556_1 then
						F_000553(L556_1)
					end
				end)
			end

			local function F_000557()
				if U371 then
					U371:Disconnect()
					U371 = nil
				end
			end

			local L0_331 = U92.Defence:AddGroupbox({
				Side = 2,
				Name = "<b>Counter</b>",
				IconName = "swords",
				Description = "Auto Attack",
				MaxPopOutHeight = 600,
				PopOutWidth = 250,
			})

			L0_331:AddDropdown("Consequence", {
				Text = "Consequence",
				Values = { "Kill" },
				ValueImages = { Kill = "skull" },
				Default = 1,
				Callback = function()
				end,
			})

			L0_331:AddToggle("CounterAttack", {
				Tooltip = "Auto Attack",
				Text = "Auto Attack",
				Default = false,
				Callback = function(A559_1)
					U370 = A559_1

					if A559_1 then
						F_000555()
					else
						F_000557()
					end
				end,
			})
		end

		local L0_332

		do
			local U373 = false
			local U374 = false
			local U375 = nil
			local U376 = nil

			local function F_000560(A560_1)
				local L560_1 = game:GetService("ReplicatedStorage"):WaitForChild("GrabEvents"):WaitForChild("CreateGrabLine")
				local L560_2 = 1 / math.max(1, A560_1 / 1000 * 60)

				while U373 do
					local L560_3 = workspace:FindFirstChild("SpawnLocation") or workspace:FindFirstChild("Spawn")
					local L560_4

					if L560_3 then
						L560_4 = L560_3
					else
						L560_4 = U68.Character and U68.Character:FindFirstChild("HumanoidRootPart")
					end

					if L560_4 then
						L560_1:FireServer(L560_4, CFrame.new(math.random(-9e9, 9e9), 0, math.random(-9e9, 9e9)))
					end

					if A560_1 >= 1000 then
						task.wait()
					else
						task.wait(L560_2)
					end
				end
			end

			L0_332 = U92.Server:AddGroupbox({
				Side = 1,
				Name = "<b>Server Lag</b>",
				IconName = "table-of-contents",
				Description = "Lag Types",
				MaxPopOutHeight = 600,
				PopOutWidth = 250,
			}):AddTabbox({ MaxPopOutHeight = 600 })

			local L0_333 = L0_332:AddTab("<b>Line Lag</b>", "waypoints")

			L0_333:AddToggle("ServerLagLineToggle", {
				Text = "Line Lag",
				Default = false,
				Callback = function(A561_1)
					U373 = A561_1
					local U377 = U65.LineLagIntensity and U65.LineLagIntensity.Value or 150

					if A561_1 then
						U375 = task.spawn(function()
							F_000560(U377)
						end)
					else
						if U375 then
							task.cancel(U375)
							U375 = nil
						end

						lineLagBurstData[U68] = nil
					end
				end,
			}):AddKeyPicker("LineLag", {
				Default = "None",
				Mode = "Toggle",
				SyncToggleState = true,
				Text = "LineLag",
				Callback = function()
				end,
			})

			L0_333:AddDivider("Line Lag Settings")

			L0_333:AddSlider("LineLagIntensity", {
				Text = "Line Lag Intensity",
				Default = 150,
				Min = 1,
				Max = 1000,
				Rounding = 0,
				Compact = true,
				Callback = function(A564_1)
					if U373 then
						if U375 then
							task.cancel(U375)
							U375 = nil
						end

						U375 = task.spawn(function()
							F_000560(A564_1)
						end)
					end
				end,
			})

			L0_333:AddDivider()

			L0_333:AddToggle("LineServerNotifications", {
				Text = "Turn On/Off <b>Notifications</b>",
				Default = true,
				Callback = function()
				end,
			})

			local L0_334 = L0_332:AddTab("<b>Packet Lag</b>", "package")

			L0_334:AddToggle("PacketLagToggle", {
				Text = "Packet Lag",
				Default = false,
				Callback = function(A567_1)
					U374 = A567_1

					if A567_1 then
						U376 = task.spawn(function()
							local L568_1 = game.ReplicatedStorage.GrabEvents.ExtendGrabLine

							while U374 do
								task.wait(U65.PacketDelay and U65.PacketDelay.Value or 1)
								local L568_2 = math.floor((U65.PacketLagStrength and U65.PacketLagStrength.Value or 19) * 1024 * 1024 / 32)
								L568_1:FireServer(string.rep("😂😂😂😂🤣🤣🤣🤣", L568_2))
							end
						end)
					elseif U376 then
						task.cancel(U376)
						U376 = nil
					end
				end,
			}):AddKeyPicker("PacketLagKey", {
				Default = "None",
				Mode = "Toggle",
				SyncToggleState = true,
				Text = "Packet Lag Keybind",
				Callback = function()
				end,
			})

			L0_334:AddDivider("Packet Settings")

			L0_334:AddSlider("PacketLagStrength", {
				Text = "Packet Lag Strength",
				Default = 19,
				Min = 0,
				Max = 19,
				Rounding = 1,
				Suffix = " MB",
				Compact = true,
				Callback = function()
				end,
			})

			L0_334:AddSlider("PacketDelay", {
				Text = "Packet Delay",
				Default = 1,
				Min = 0,
				Max = 10,
				Rounding = 1,
				Compact = true,
				Callback = function()
				end,
			})

			local function F_000572()
				local U378 = math.floor((U65.PacketLagStrength and U65.PacketLagStrength.Value or 19) * 1024 * 1024 / 32)

				pcall(function()
					game.ReplicatedStorage.GrabEvents.ExtendGrabLine:FireServer(string.rep("😂😂😂😂🤣🤣🤣🤣", U378))
				end)
			end

			local U379 = L0_334:AddButton({ Text = "Send One-Time Packet", Func = F_000572, DoubleClick = false })

			pcall(function()
				U379:AddKeyPicker("OneTimePacketKey", { Default = "None", Mode = "Press", Text = "Send One-Time Packet Key", Callback = F_000572 })
			end)

			L0_334:AddDivider()

			L0_334:AddToggle("PacketServerNotifications", {
				Text = "Turn On/Off <b>Notifications</b>",
				Default = true,
				Callback = function()
				end,
			})
		end

		do
			local L0_335 = L0_332:AddTab("<b>Sticky Lag</b>", "shrink")
			local U380 = false
			local U381 = nil
			local U382 = nil
			local U383 = 1
			local U384 = nil
			local U385 = 0

			local function F_000576(A576_1)
				if not A576_1 then
					return
				end

				pcall(function()
					local L577_1 = game:GetService("ReplicatedStorage")
					local L577_2 = L577_1:FindFirstChild("GrabEvents") and L577_1.GrabEvents:FindFirstChild("SetNetworkOwner")
					local L577_3 = CFrame.new(A576_1.Position.X, 10000, A576_1.Position.Z)
					A576_1.CFrame = L577_3
					A576_1.AssemblyLinearVelocity = Vector3.zero

					if L577_2 then
						L577_2:FireServer(A576_1, L577_3)
					end
				end)
			end

			local function F_000578()
				local L578_1 = tick()
				if U384 and U384.Parent and L578_1 - U385 < 0.15 then
					return U384
				end
				U385 = L578_1
				local L578_2 = U68.Character and U68.Character:FindFirstChild("HumanoidRootPart")
				if not L578_2 then
					return nil
				end
				local L578_3 = L578_2.Position
				local L578_4 = math.huge
				local L578_5 = nil

				for I189, I190 in ipairs(workspace:GetChildren()) do
					local L578_6 = I190:IsA("BasePart")

					if L578_6 then
						L578_6 = not (U68.Character and I190:IsDescendantOf(U68.Character))
					end

					if L578_6 and I190 ~= U382 then
						local L578_7 = (I190.Position - L578_3).Magnitude

						if L578_7 < L578_4 then
							L578_4 = L578_7
							L578_5 = I190
						end
					else
						local L578_8 = I190:IsA("Model")

						if L578_8 then
							L578_8 = not (U68.Character and I190 == U68.Character)
						end

						if L578_8 then
							for I191, I192 in ipairs(I190:GetChildren()) do
								if I192:IsA("BasePart") and I192 ~= U382 then
									local L578_9 = (I192.Position - L578_3).Magnitude

									if L578_9 < L578_4 then
										L578_4 = L578_9
										L578_5 = I192
									end
								end
							end
						end
					end
				end

				local L578_10 = ipairs
				local L578_11 = game:GetService("Players")

				for I193, I194 in L578_10(L578_11:GetPlayers()) do
					if I194 ~= U68 and I194.Character then
						local L578_12 = I194.Character:FindFirstChild("HumanoidRootPart") or I194.Character:FindFirstChild("Torso")

						if L578_12 then
							local L578_13 = (L578_12.Position - L578_3).Magnitude

							if L578_13 < L578_4 then
								L578_4 = L578_13
								L578_5 = L578_12
							end
						end
					end
				end

				U384 = L578_5 or workspace:FindFirstChildWhichIsA("BasePart", true)
				return U384
			end

			local function F_000579()
				local U386 = U68.Character and U68.Character:FindFirstChild("HumanoidRootPart")
				if not U386 then
					return nil
				end
				local U387 = game:GetService("ReplicatedStorage"):WaitForChild("MenuToys"):WaitForChild("SpawnToyRemoteFunction")

				pcall(function()
					U387:InvokeServer("NinjaShuriken", U386.CFrame * CFrame.new(0, 5, 0), Vector3.zero)
				end)

				local U388 = workspace:WaitForChild(U68.Name .. "SpawnedInToys", 2)
				local L579_1 = tick()
				local L579_2 = nil

				while tick() - L579_1 < 1.5 do
					if U388 then
						for I195, I196 in ipairs(U388:GetChildren()) do
							if (I196.Name == "NinjaShuriken" or I196.Name:lower():find("ninjashuriken")) and I196:FindFirstChild("StickyPart") then
								L579_2 = I196.StickyPart

								pcall(function()
									I196:Destroy()
								end)

								pcall(function()
									U388:ClearAllChildren()
								end)

								break
							end
						end
					end

					if not L579_2 then
						task.wait(0.05)
						continue
					end
					break
				end

				return L579_2
			end

			local function F_000583()
				local U389 = game:GetService("ReplicatedStorage"):WaitForChild("PlayerEvents"):WaitForChild("StickyPartEvent")
				local U390 = CFrame.new(0, -2.3e9, 0)
				U382 = F_000579()

				if (U65 and U65.StickyLagIntensity and U65.StickyLagIntensity.Value or U383 or 1) == 10 and U382 then
					F_000576(U382)
				end

				while U380 do
					local L583_1 = U65 and U65.StickyLagIntensity and U65.StickyLagIntensity.Value or U383 or 1

					if U382 then
						local U391 = F_000578()

						if U391 and U391.Parent then
							for I197 = 1, L583_1 do
								pcall(function()
									U389:FireServer(U382, U391, U390)
								end)
							end
						end
					end

					U69.Heartbeat:Wait()
				end

				U382 = nil
				U384 = nil
			end

			L0_335:AddToggle("StickyLagToggle", {
				Text = "Sticky Lag",
				Default = false,
				Callback = function(A585_1)
					U380 = A585_1

					if _G.updateNeuroniumStickyUI then
						_G.updateNeuroniumStickyUI()
					end

					if A585_1 then
						U381 = task.spawn(F_000583)
					else
						if U381 then
							task.cancel(U381)
							U381 = nil
						end

						U382 = nil
						U384 = nil
					end
				end,
			}):AddKeyPicker("StickyLagKey", {
				Default = "Three",
				Mode = "Toggle",
				SyncToggleState = true,
				Text = "Sticky Lag Keybind",
				Callback = function()
				end,
			})

			L0_335:AddDivider("Settings")

			L0_335:AddSlider("StickyLagIntensity", {
				Text = "Sticky Lag Intensity",
				Default = 1,
				Min = 1,
				Max = 10,
				Rounding = 0,
				Compact = true,
				Callback = function(A587_1)
					U383 = A587_1

					if _G.updateNeuroniumStickyUI then
						_G.updateNeuroniumStickyUI()
					end

					if U383 == 10 and U382 then
						F_000576(U382)
					end
				end,
			})
		end
	end

	pcall(function()
		local L588_1 = typeof(gethui) == "function" and gethui() or game:GetService("CoreGui") or U68:FindFirstChild("PlayerGui")

		if L588_1 then
			local L588_2 = L588_1:FindFirstChild("NeuroniumStickyUI")

			if L588_2 then
				L588_2:Destroy()
			end

			local L588_3 = L588_1:FindFirstChild("FakePosUI")

			if L588_3 then
				L588_3:Destroy()
			end
		end
	end)

	_G.updateNeuroniumStickyUI = function()
	end

	_G.updateFakePosUI = function()
	end

	task.spawn(function()
		UserInputService.InputBegan:Connect(function(A592_1, A592_2)
			if A592_2 then
				return
			end

			if A592_1.KeyCode == Enum.KeyCode.Three then
				if U66 and U66.StickyLagToggle then
					U66.StickyLagToggle:SetValue(not U66.StickyLagToggle.Value)
				end
			elseif A592_1.KeyCode == Enum.KeyCode.H then
				if U66 and U66.OtherFakePos then
					U66.OtherFakePos:SetValue(not U66.OtherFakePos.Value)
				end
			elseif A592_1.KeyCode == Enum.KeyCode.X then
				local L592_1 = U68.Character
				L592_1 = L592_1 and L592_1:FindFirstChild("HumanoidRootPart")
				local L592_2 = U68:GetMouse()

				if L592_1 and L592_2 and L592_2.Hit then
					local L592_3 = L592_2.Hit.Position + Vector3.new(0, 3, 0)
					L592_1.CFrame = CFrame.new(L592_3)

					if fakePosActive and charYLock then
						charYLock.Position = Vector3.new(0, L592_3.Y, 0)
					end
				end
			end
		end)
	end)

	local U392
	U392 = false
	local U393
	U393 = false

	do
		local U394 = false
		local U395 = nil
		local U396 = false
		local U397 = false
		local U398 = {}
		local U399 = {}
		local U400 = {}

		local function F_000593(A593_1)
			if not A593_1 then
				return false
			end
			local L593_1 = A593_1:FindFirstChildOfClass("Humanoid")
			if not L593_1 then
				return false
			end
			return L593_1.SeatPart ~= nil
		end

		local function F_000594(A594_1)
			if A594_1 and A594_1.Parent then
				pcall(function()
					game:GetService("ReplicatedStorage").MenuToys.DestroyToy:FireServer(A594_1)
				end)
			end
		end

		task.spawn(function()
			local U401 = game:GetService("ReplicatedStorage")

			while true do
				local L596_1 = U392 or U393
				local L596_2 = 1

				if L596_1 then
					L596_2 = 2
				end

				U394 = false

				for I198, I199 in pairs(U67:GetPlayers()) do
					if I199 == U68 then
						continue
					end

					if U398[I199.UserId] and I199.Character and I199.Character:FindFirstChild("HumanoidRootPart") and F_000593(I199.Character) then
						if U398[I199.UserId] == "none" or U398[I199.UserId] == "crip" or not U398[I199.UserId] or U398[I199.UserId] == "bris" then
							if U398[I199.UserId] == "crip" then
								local L596_3 = I199.Character:FindFirstChild("Humanoid")

								if L596_3 then
									L596_3.WalkSpeed = 0
								end
							end

							U398[I199.UserId] = nil
							continue
						end

						local L596_4 = I199.Character:FindFirstChild("HumanoidRootPart")

						if L596_4 then
							L596_4.CFrame = U398[I199.UserId]
							L596_4.AssemblyLinearVelocity = Vector3.zero
						end

						U398[I199.UserId] = nil
						local L596_5 = U399[I199.UserId]

						if not L596_5 then
							L596_5 = U392

							if U392 then
								L596_5 = not (_G.isWhitelisted and _G.isWhitelisted(I199))
							end
						end

						if L596_5 then
							hkAction = "Kick"
							continue
						end
						continue
					end

					if U399[I199.UserId] or U400[I199.UserId] or U398[I199.UserId] or U392 or U393 then
						local L596_6 = U68.Character and U68.Character:FindFirstChild("HumanoidRootPart")
						local L596_7 = nil
						local L596_8 = nil

						if L596_6 then
							L596_7 = U68.Character.HumanoidRootPart.CFrame
							L596_8 = U68.Character.HumanoidRootPart.AssemblyLinearVelocity
						end

						local L596_9

						if U398[I199.UserId] and U398[I199.UserId] ~= "bris" then
							L596_9 = "Bring"
						elseif U400[I199.UserId] or U398[I199.UserId] == "bris" then
							L596_9 = "Kill"
						elseif U399[I199.UserId] then
							L596_9 = "Kick"
						else
							L596_9 = nil

							if U392 then
								local L596_10 = _G.isWhitelisted and _G.isWhitelisted(I199)
								L596_9 = nil

								if not L596_10 then
									L596_9 = "Kick"
								end
							end

							if U393 then
								if not (_G.isWhitelisted and _G.isWhitelisted(I199)) then
									L596_9 = "Kill"
								end
							end
						end

						if I199 ~= U68 and L596_9 then
							local L596_11 = I199.Character and I199.Character:FindFirstChild("HumanoidRootPart")
							local L596_12 = false

							if L596_11 then
								if I199.Character.HumanoidRootPart.Massless then
									if I199.Character:FindFirstChild("Humanoid") and I199.Character.Humanoid.SeatPart then
										L596_12 = true
									end
								else
									L596_12 = true
								end
							end

							local L596_13 = true

							while true do
								local L596_14 = L596_13 and U68.Character and U68.Character:FindFirstChild("HumanoidRootPart") and I199 and I199.Character
								local L596_15

								if L596_14 then
									L596_15 = L596_9 == "Kick" or L596_9 == "Kill" or L596_9 == "Bring"
								else
									L596_15 = L596_14
								end

								L596_15 = L596_15 and I199.Character:FindFirstChild("HumanoidRootPart")
								local L596_16 = L596_15 and I199.Character.HumanoidRootPart.CFrame.Position.Magnitude < 1000000 and I199.Character:FindFirstChild("Humanoid")

								if L596_16 then
									local L596_17 = Enum.HumanoidStateType.Dead
									L596_16 = I199.Character.Humanoid:GetState() ~= L596_17
								end

								L596_12 = L596_16 and L596_12

								if L596_12 then
									if L596_2 == 2 then
										if not U392 and not U393 then
											L596_13 = false
										elseif _G.isWhitelisted and _G.isWhitelisted(I199) then
											L596_13 = false
										end
									elseif not U399[I199.UserId] and not U400[I199.UserId] and not U398[I199.UserId] then
										L596_13 = false
									end

									U394 = true
									local L596_18 = true
									L596_18 = L596_13 and L596_18 and U68.Character and U68.Character:FindFirstChild("Humanoid")

									if L596_18 then
										local L596_19 = Enum.HumanoidStateType.Dead
										L596_18 = I199.Character.Humanoid:GetState() ~= L596_19
									end

									if L596_18 and U68.Character.Humanoid.SeatPart and U68.Character.Humanoid.SeatPart.Parent and U68.Character.Humanoid.SeatPart.Parent.Name == "CreatureBlobman" then
										U396 = true
										U395 = U68.Character.Humanoid.SeatPart.Parent

										if U395:FindFirstChild("HumanoidCreature") then
											U395.HumanoidCreature.PlatformStand = true
										end

										local L596_20 = U395:FindFirstChild("RightDetector")
										local L596_21 = L596_20 and L596_20:FindFirstChild("RightWeld")
										local L596_22 = U395:FindFirstChild("BlobmanSeatAndOwnerScript")
										local L596_23 = L596_22 and L596_22:FindFirstChild("CreatureGrab")
										local L596_24 = L596_22 and L596_22:FindFirstChild("CreatureRelease")
										L596_22 = L596_22 and L596_22:FindFirstChild("CreatureDrop")

										if L596_20 and L596_21 and L596_23 and L596_24 and L596_22 then
											local L596_25 = I199.Character:FindFirstChild("HumanoidRootPart")

											if L596_25 then
												local L596_26 = L596_25.AssemblyLinearVelocity / 3.1415926535897931
												U68.Character.HumanoidRootPart.CFrame = L596_25.CFrame * CFrame.new(0, -20, 10) + L596_26
												U68.Character.HumanoidRootPart.AssemblyLinearVelocity = L596_25.AssemblyLinearVelocity

												if I199.Character and I199.Character:FindFirstChild("HumanoidRootPart") then
													if L596_9 == "Bring" then
														local L596_27 = I199.Character:FindFirstChild("Humanoid")

														if L596_27 and L596_27.Health ~= 0 and U395 then
															if F_000593(I199.Character) then
																local L596_28 = U398[I199.UserId]

																if L596_28 == "none" or L596_28 == "crip" or not L596_28 then
																	local L596_29 = I199.Character:FindFirstChild("HumanoidRootPart")

																	if L596_29 then
																		L596_29.AssemblyLinearVelocity = Vector3.zero

																		if L596_28 == "crip" then
																			L596_27.WalkSpeed = 0
																		end
																	end

																	U398[I199.UserId] = nil
																else
																	local L596_30 = I199.Character:FindFirstChild("HumanoidRootPart")

																	if L596_30 then
																		L596_30.CFrame = L596_28
																		L596_30.AssemblyLinearVelocity = Vector3.zero
																	end

																	U398[I199.UserId] = nil
																	local L596_31 = U399[I199.UserId]

																	if not L596_31 then
																		L596_31 = U392

																		if U392 then
																			L596_31 = not (_G.isWhitelisted and _G.isWhitelisted(I199))
																		end
																	end

																	if L596_31 then
																		L596_9 = "Kick"
																	end
																end
															else
																L596_23:FireServer(L596_20, L596_25, L596_21)
																L596_24:FireServer(L596_21, L596_25)
															end
														end
													elseif L596_9 == "Kick" then
														if I199.Character.Parent == workspace then
															local L596_32 = I199.Character:FindFirstChild("HumanoidRootPart")

															if L596_32 then
																U401.GrabEvents.SetNetworkOwner:FireServer(L596_32, L596_32.CFrame)
																L596_32.AssemblyLinearVelocity = Vector3.new(0, 1e10, 0)
																U401.GrabEvents.DestroyGrabLine:FireServer(L596_32)
																local L596_33 = U68.Character:FindFirstChild("HumanoidRootPart")
																L596_23:FireServer(L596_20, L596_32, L596_21)

																if L596_33 then
																	L596_23:FireServer(L596_20, L596_33, L596_21)
																end

																L596_22:FireServer(L596_21, L596_32)
															end
														else
															U398[I199.UserId] = CFrame.new(-73, -6, -265.5)
															L596_13 = false
														end
													else
														local L596_34 = I199.Character:FindFirstChild("Humanoid")

														if L596_34 and L596_34.Health ~= 0 and U395 then
															if U398[I199.UserId] == "bris" then
																U398[I199.UserId] = nil
															end

															L596_34:ChangeState(Enum.HumanoidStateType.Dead)
															local L596_35 = I199.Character:FindFirstChild("HumanoidRootPart")

															if L596_35 then
																L596_23:FireServer(L596_20, L596_35, L596_21)
																L596_24:FireServer(L596_21, L596_35)
															end
														end
													end
												end
											end
										else
											local L596_36 = workspace:FindFirstChild(U68.Name .. "SpawnedInToys")

											if L596_36 then
												local L596_37 = L596_36:FindFirstChild("CreatureBlobman")

												if L596_37 then
													F_000594(L596_37)
												end
											end
										end
									else
										U396 = true
										local L596_38 = U68.Character:FindFirstChild("Humanoid")

										if L596_38 and L596_38.SeatPart and (not L596_38.SeatPart.Parent or L596_38.SeatPart.Parent.Name ~= "CreatureBlobman") then
											L596_38.Sit = false
										end

										if U395 and U395:FindFirstChild("VehicleSeat") then
											local L596_39 = U68.Character and U68.Character:FindFirstChild("Humanoid")

											if L596_39 then
												local L596_40 = Enum.HumanoidStateType.Dead
												L596_39 = I199.Character.Humanoid:GetState() ~= L596_40
											end

											if L596_39 then
												U395.VehicleSeat:Sit(U68.Character.Humanoid)
											end
										else
											U397 = false
											U395 = nil
											local L596_41 = workspace:FindFirstChild(U68.Name .. "SpawnedInToys")

											if L596_41 then
												for I200, I201 in pairs(L596_41:GetChildren()) do
													if I201.Name == "CreatureBlobman" and I201:FindFirstChild("VehicleSeat") then
														local L596_42 = I201:FindFirstChild("RightDetector")
														local L596_43 = L596_42 and L596_42:FindFirstChild("RightWeld")

														if L596_42 and L596_43 then
															U397 = true
															U395 = I201
															continue
														end

														F_000594(I201)
														continue
													end

													if I201.Name ~= "CreatureBlobman" then
														continue
													end
													F_000594(I201)
													task.wait(0.1)
												end
											end

											local L596_44 = U395 and U68.Character and U68.Character:FindFirstChild("Humanoid")

											if L596_44 then
												local L596_45 = Enum.HumanoidStateType.Dead
												L596_44 = I199.Character.Humanoid:GetState() ~= L596_45
											end

											if L596_44 then
												U395.VehicleSeat:Sit(U68.Character.Humanoid)
											end

											if not U397 then
												local L596_46 = U68.Character and U68.Character:FindFirstChild("HumanoidRootPart")

												if L596_46 then
													if U68.Character.Parent ~= workspace then
														L596_46.CFrame = CFrame.new(0, -10, 0)
														L596_46.AssemblyLinearVelocity = Vector3.zero
													end

													while L596_13 and not U395 do
														if L596_2 == 2 then
															if not U392 and not U393 then
																L596_13 = false
															elseif _G.isWhitelisted and _G.isWhitelisted(I199) then
																L596_13 = false
															end
														elseif not (U399[I199.UserId] or U400[I199.UserId] or U398[I199.UserId]) then
															L596_13 = false
														end

														local L596_47 = workspace:FindFirstChild(U68.Name .. "SpawnedInToys")

														if L596_47 then
															local L596_48 = L596_47:FindFirstChild("CreatureBlobman")

															if L596_48 then
																local L596_49 = L596_48:FindFirstChild("RightDetector")
																local L596_50 = L596_49 and L596_49:FindFirstChild("RightWeld")

																if L596_49 and L596_50 then
																	U395 = L596_48
																else
																	F_000594(L596_48)
																end
															end
														end

														if not U395 then
															task.spawn(function()
																pcall(function()
																	U401.MenuToys.SpawnToyRemoteFunction:InvokeServer("CreatureBlobman", CFrame.new(U68.Character.HumanoidRootPart.CFrame.Position) + Vector3.new(0, 0, 15), Vector3.zero)
																end)
															end)
														end

														task.wait()
													end
												end
											end
										end
									end

									task.wait()
									L596_12 = true
									continue
								end

								break
							end
						end

						if U68.Character and U68.Character:FindFirstChild("HumanoidRootPart") then
							U68.Character.HumanoidRootPart.CFrame = L596_7
							U68.Character.HumanoidRootPart.AssemblyLinearVelocity = L596_8
						end
					end
				end

				if not U394 and U395 then
					if U68.Character and U68.Character:FindFirstChild("Humanoid") and U68.Character.Humanoid.SeatPart and U68.Character.Humanoid.SeatPart.Parent == U395 then
						U68.Character.Humanoid.Sit = false
					end

					task.wait()

					if U395 and U395:FindFirstChild("HumanoidRootPart") then
						U395.HumanoidRootPart.CFrame = CFrame.new(0, 1e15, 0)
					end
				end

				U396 = false
				task.wait()
			end
		end)
	end

	do
		local U402 = nil
		local U403 = false
		local U404 = nil

		local function F_000599()
			U403 = false

			if U404 then
				pcall(function()
					coroutine.close(U404)
				end)

				U404 = nil
			end
		end

		local function F_000601()
			local U405 = game:GetService("ReplicatedStorage"):FindFirstChild("GrabEvents")

			local function F_000602()
				local L602_1 = {}

				for I202, I203 in pairs(U67:GetPlayers()) do
					if I203 ~= U68 then
						if not (_G.isWhitelisted and _G.isWhitelisted(I203)) then
							table.insert(L602_1, I203)
						end
					end
				end

				return L602_1
			end

			local function F_000603(A603_1)
				if not U405 then
					return
				end
				local U406 = U405:FindFirstChild("SetNetworkOwner")

				if U406 and A603_1 then
					pcall(function()
						U406:FireServer(A603_1, A603_1.CFrame)
					end)
				end
			end

			local function F_000605(A605_1, A605_2)
				if not A605_1 or not A605_2 then
					return
				end

				pcall(function()
					A605_1.CFrame = A605_2.CFrame * CFrame.new(0, 5, 5)
					A605_1.AssemblyLinearVelocity = Vector3.zero
				end)
			end

			local function F_000607(A607_1)
				if not U405 then
					return
				end
				local U407 = U405:FindFirstChild("CreateGrabLine")
				local U408 = U405:FindFirstChild("DestroyGrabLine")
				if not U407 or not U408 then
					return
				end

				pcall(function()
					U407:FireServer(A607_1, CFrame.new(0, 1e9, 0))
					task.wait()
					U408:FireServer(A607_1)
				end)
			end

			F_000599()
			U403 = true

			U404 = coroutine.create(function()
				if not U405 then
					return
				end
				local L609_1 = U405:FindFirstChild("CreateGrabLine")
				if not L609_1 then
					return
				end

				while U403 do
					local L609_2 = workspace:FindFirstChild("SpawnLocation") or workspace:FindFirstChild("Spawn") or U68.Character and U68.Character:FindFirstChild("HumanoidRootPart")

					if L609_2 then
						local L609_3 = math.random(-1e9, 1e9)
						local L609_4 = math.random(-1e9, 1e9)
						local L609_5 = {}
						local L609_6 = CFrame.new(L609_3, 0, L609_4)
						local L609_7 = CFrame.new(-L609_3, 0, -L609_4)
						local L609_8 = CFrame.new(L609_3, 0, -L609_4)
						local L609_9 = CFrame.new
						L609_5[1] = L609_6
						L609_5[2] = L609_7
						L609_5[3] = L609_8

						do
							local L609_10 = table.pack(L609_9(-L609_3, 0, L609_4))
							table.move(L609_10, 1, L609_10.n, 4, L609_5)
						end

						for I204, I205 in pairs(L609_5) do
							L609_1:FireServer(L609_2, I205)
						end
					end

					task.wait()
				end
			end)

			coroutine.resume(U404)
			task.wait(1)
			local L601_1 = F_000602()
			if #L601_1 == 0 then
				F_000599()
				return
			end
			local L601_2 = U68.Character
			L601_2 = L601_2 and L601_2:FindFirstChild("HumanoidRootPart")
			if not L601_2 then
				F_000599()
				return
			end
			local L601_3 = {}

			for I206, I207 in ipairs(L601_1) do
				local L601_4 = I207.Character
				L601_4 = L601_4 and L601_4:FindFirstChild("HumanoidRootPart")

				if L601_4 then
					table.insert(L601_3, { player = I207, hrp = L601_4 })
				end
			end

			for I208, I209 in ipairs(L601_3) do
				F_000605(L601_2, I209.hrp)
				task.wait(0.2)
				F_000603(I209.hrp)
				task.wait()
			end

			local L601_5 = 6.2831853071795862 / #L601_3

			for I210, I211 in ipairs(L601_3) do
				local L601_6 = (I210 - 1) * L601_5
				local U409 = math.cos(L601_6) * 40
				local U410 = math.sin(L601_6) * 40

				pcall(function()
					I211.hrp.CFrame = CFrame.new(U409, 35, U410)
					I211.hrp.AssemblyLinearVelocity = Vector3.zero
				end)

				local U411 = Instance.new("BodyPosition")
				U411.MaxForce = Vector3.new(1e9, 1e9, 1e9)
				U411.P = 40000000
				U411.Position = Vector3.new(U409, 35, U410)
				U411.Parent = I211.hrp

				task.delay(2, function()
					pcall(function()
						U411:Destroy()
					end)
				end)

				task.wait()
			end

			for I212 = 1, 8 do
				for I213, I214 in ipairs(L601_3) do
					F_000607(I214.hrp)
				end

				task.wait(0.3)
			end

			F_000599()
		end

		local L0_336 = U92.Server:AddGroupbox({
			Side = 1,
			Name = "<b>Players</b>",
			IconName = "users",
			Description = "Everyone",
			MaxPopOutHeight = 600,
			PopOutWidth = 250,
		}):AddTabbox({ MaxPopOutHeight = 600 })

		local L0_337 = L0_336:AddTab("<b>Kick Server</b>", "user-x")

		L0_337:AddToggle("KickServer", {
			Text = "Kick Server",
			Default = false,
			Callback = function(A613_1)
				if (U65.KickServerMethod and U65.KickServerMethod.Value or "None") == "Blobman" then
					U392 = A613_1

					if not A613_1 then
						F_000599()
					end
				elseif A613_1 then
					U402 = task.spawn(function()
						while U66.KickServer and U66.KickServer.Value do
							F_000601()
							task.wait(3)
						end
					end)
				else
					F_000599()

					if U402 then
						task.cancel(U402)
						U402 = nil
					end
				end
			end,
		})

		L0_337:AddDropdown("KickServerMethod", {
			Text = "Method",
			Values = { "None", "Blobman" },
			ValueImages = { None = "ban", Blobman = "bot" },
			Default = 1,
			Callback = function()
				if U66.KickServer and U66.KickServer.Value then
					U66.KickServer:SetValue(false)
					task.wait(0.1)
					U66.KickServer:SetValue(true)
				end
			end,
		})

		local L0_338 = L0_336:AddTab("<b>Kill All</b>", "skull")

		L0_338:AddToggle("KillAll", {
			Text = "Kill All",
			Default = false,
			Callback = function(A616_1)
				U393 = A616_1
			end,
		})

		L0_338:AddDropdown("KillAllMethod", {
			Text = "Method",
			Values = { "Blobman" },
			ValueImages = { Blobman = "bot" },
			Default = 1,
			Callback = function()
				if U66.KillAll and U66.KillAll.Value then
					U66.KillAll:SetValue(false)
					task.wait(0.1)
					U66.KillAll:SetValue(true)
				end
			end,
		})
	end

	local U412

	local function F_000618()
		local L618_1 = U68.Character
		if L618_1 and L618_1:FindFirstChild("HumanoidRootPart") then
			return L618_1.HumanoidRootPart
		end
		return U68.CharacterAdded:Wait():WaitForChild("HumanoidRootPart")
	end

	U412 = function()
		local L619_1 = workspace:FindFirstChild("PlotItems") and workspace.PlotItems:FindFirstChild("PlayersInPlots")

		if L619_1 and L619_1:FindFirstChild(U68.Name) then
			pcall(function()
				U62:Notify({ Title = "<b>Break Plot</b>", Description = "You Are In safe zone!", Duration = 3 })
			end)

			return nil
		end

		local L619_2 = workspace:FindFirstChild(U68.Name .. "SpawnedInToys")
		if not L619_2 then
			return nil
		end
		local L619_3 = F_000618()

		for I215, I216 in pairs(L619_2:GetChildren()) do
			if (I216.Name == "NinjaShuriken" or I216.Name == "Noclipped") and I216:FindFirstChild("StickyPart") and I216:FindFirstChild("SoundPart") then
				if L619_3 and (I216.StickyPart.Position - L619_3.Position).Magnitude <= 15 then
					return I216
				end
			end
		end

		local U413 = F_000618()
		if not U413 then
			return nil
		end
		local U414 = nil
		local U415 = nil

		U414 = L619_2.ChildAdded:Connect(function(A621_1)
			if A621_1.Name == "NinjaShuriken" then
				U415 = A621_1
				U414:Disconnect()
			end
		end)

		pcall(function()
			game:GetService("ReplicatedStorage").MenuToys.SpawnToyRemoteFunction:InvokeServer("NinjaShuriken", U413.CFrame * CFrame.new(5, 8, 20), Vector3.zero)
		end)

		local L619_4 = tick()

		repeat
			if U415 and U415:FindFirstChild("StickyPart") and U415:FindFirstChild("SoundPart") then
				return U415
			end
			task.wait(0.01)
		until tick() - L619_4 > 0.5

		return L619_2:FindFirstChild("NinjaShuriken")
	end

	local U416
	U416 = "1"
	local U417

	U417 = {
		TudorHouse = "1",
		PinkRoofHouse = "2",
		HauntedHouse = "3",
		BlueHouse = "4",
		JapaneseHouse = "5",
	}

	local U418
	U418 = {}
	local U419
	local U420 = 0

	U419 = function()
		if tick() - U420 < 0.8 then
			return
		end
		U420 = tick()
		U62:Notify({ Title = "Silent Target", Description = "Part was successfully broken.", Duration = 3 })
	end

	local U421, L0_339

	do
		local function F_000624(A624_1, A624_2)
			if not A624_1 then
				return
			end

			pcall(function()
				local U422 = Color3.fromRGB(255, 255, 255)

				local function F_000626(A626_1)
					if not A626_1 or not A626_1:IsA("BasePart") then
						return
					end

					if U418[A626_1] == nil then
						U418[A626_1] = A626_1.Transparency
					end

					A626_1.Transparency = 0.5
					local U423 = A626_1:FindFirstChild("ST_Effect_Highlight") or Instance.new("Highlight")
					U423.Name = "ST_Effect_Highlight"
					U423.FillColor = U422
					U423.FillTransparency = 1
					U423.OutlineColor = U422
					U423.OutlineTransparency = 0
					U423.Adornee = A626_1
					U423.Parent = A626_1
					local U424 = A626_1:FindFirstChild("ST_Effect_SelectionBox") or Instance.new("SelectionBox")
					U424.Name = "ST_Effect_SelectionBox"
					U424.Color3 = U422
					U424.SurfaceTransparency = 1
					U424.LineThickness = 0.035
					U424.Adornee = A626_1
					U424.Parent = A626_1

					task.spawn(function()
						local L627_1 = tick()

						while tick() - L627_1 < 2 and A626_1 and A626_1.Parent do
							local L627_2 = (math.sin((tick() - L627_1) * 10) + 1) / 2

							if U423 and U423.Parent then
								U423.OutlineTransparency = L627_2 * 0.75
							end

							if U424 and U424.Parent then
								U424.Transparency = L627_2 * 0.75
							end

							task.wait(0.03)
						end

						if U423 and U423.Parent then
							U423.OutlineTransparency = 0
						end

						if U424 and U424.Parent then
							U424.Transparency = 0
						end
					end)
				end

				if A624_2 or A624_1:IsA("BasePart") then
					if A624_1:IsA("BasePart") then
						F_000626(A624_1)
					elseif A624_1:IsA("Model") and A624_1.PrimaryPart then
						F_000626(A624_1.PrimaryPart)
					end
				else
					for I217, I218 in ipairs(A624_1:GetDescendants()) do
						if I218:IsA("BasePart") then
							F_000626(I218)
						end
					end
				end
			end)
		end

		local function F_000628(A628_1, A628_2)
			F_000624(A628_1, A628_2)
		end

		local function F_000629(A629_1, A629_2)
			F_000624(A629_1, A629_2)
		end

		local function F_000630()
			local L630_1 = U412()
			if not L630_1 then
				return
			end
			local U425 = L630_1:FindFirstChild("SoundPart")
			local U426 = L630_1:FindFirstChild("StickyPart")
			if not U426 then
				return
			end

			if U425 then
				for I219 = 1, 20 do
					pcall(function()
						game:GetService("ReplicatedStorage").GrabEvents.SetNetworkOwner:FireServer(U425, U425.CFrame)
					end)

					if not (U425:FindFirstChild("PartOwner") and U425.PartOwner.Value == U68.Name) then
						continue
					end
					break
				end
			end

			for I220, I221 in pairs(L630_1:GetChildren()) do
				if I221:IsA("BasePart") then
					I221.CanTouch = false
					I221.CanCollide = false
					I221.CanQuery = false

					if I221.Transparency == 0 then
						I221.Transparency = 1
					end
				end
			end

			L630_1.Name = "Noclipped"
			local L630_2 = workspace.Plots:FindFirstChild("Plot" .. tostring(U416))
			if not L630_2 then
				return
			end
			local U427 = L630_2:FindFirstChild("PlotArea")
			if not U427 then
				return
			end
			F_000628(L630_2, false)

			pcall(function()
				game:GetService("ReplicatedStorage").PlayerEvents.StickyPartEvent:FireServer(U426, U427, CFrame.new(1099511627776, 1099511627776, 1099511627776, 1, 0, 0, 0, 1, 0, 0, 0, 1))
				U419()
			end)
		end

		local function F_000633()
			local L633_1 = U412()
			if not L633_1 then
				return
			end
			local U428 = L633_1:FindFirstChild("SoundPart")
			local U429 = L633_1:FindFirstChild("StickyPart")
			if not U429 then
				return
			end

			if U428 then
				for I222 = 1, 20 do
					pcall(function()
						game:GetService("ReplicatedStorage").GrabEvents.SetNetworkOwner:FireServer(U428, U428.CFrame)
					end)

					if not (U428:FindFirstChild("PartOwner") and U428.PartOwner.Value == U68.Name) then
						continue
					end
					break
				end
			end

			local L633_2 = workspace:FindFirstChild("GrabParts")
			local U430 = nil

			if L633_2 then
				local L633_3 = L633_2:FindFirstChild("GrabPart")

				if L633_3 then
					local L633_4 = L633_3:FindFirstChild("WeldConstraint")

					if L633_4 then
						U430 = L633_4.Part1
					end
				end
			end

			if not U430 then
				local L633_5 = U68:GetMouse()

				if L633_5 and L633_5.Target then
					U430 = L633_5.Target
				end
			end

			if not U430 then
				return
			end
			F_000628(U430, true)

			pcall(function()
				game:GetService("ReplicatedStorage").PlayerEvents.StickyPartEvent:FireServer(U429, U430, CFrame.new(1099511627776, 1099511627776, 1099511627776, 1, 0, 0, 0, 1, 0, 0, 0, 1))
				U419()
			end)
		end

		U421 = function()
			local L636_1 = U412()
			if not L636_1 then
				return
			end
			local U431 = L636_1:FindFirstChild("SoundPart")
			local U432 = L636_1:FindFirstChild("StickyPart")
			if not U432 then
				return
			end

			if U431 then
				for I223 = 1, 20 do
					pcall(function()
						game:GetService("ReplicatedStorage").GrabEvents.SetNetworkOwner:FireServer(U431, U431.CFrame)
					end)

					if not (U431:FindFirstChild("PartOwner") and U431.PartOwner.Value == U68.Name) then
						continue
					end
					break
				end
			end

			local L636_2 = workspace:FindFirstChild("GrabParts")
			local U433 = nil

			if L636_2 then
				local L636_3 = L636_2:FindFirstChild("GrabPart")

				if L636_3 then
					local L636_4 = L636_3:FindFirstChild("WeldConstraint")

					if L636_4 then
						U433 = L636_4.Part1
					end
				end
			end

			if not U433 then
				local L636_5 = U68:GetMouse()

				if L636_5 and L636_5.Target then
					U433 = L636_5.Target
				end
			end

			if not U433 then
				return
			end
			F_000629(U433, true)

			pcall(function()
				game:GetService("ReplicatedStorage").PlayerEvents.StickyPartEvent:FireServer(U432, U433, CFrame.new(0, -2.3e9, 0))
				U419()
			end)
		end

		local function F_000639()
			local U434 = game:GetService("ReplicatedStorage"):FindFirstChild("MenuToys") and game:GetService("ReplicatedStorage").MenuToys:FindFirstChild("DestroyToy")
			local L639_1 = workspace:FindFirstChild(U68.Name .. "SpawnedInToys")

			if L639_1 and U434 then
				for I224, I225 in pairs(L639_1:GetChildren()) do
					if I225:IsA("Model") and (I225.Name:find("Shuriken") or I225.Name == "Noclipped" or I225.Name == "AntiKick") then
						pcall(function()
							U434:FireServer(I225)
						end)
					end
				end
			end

			pcall(function()
				for I226, I227 in pairs(U418) do
					if I226 and I226.Parent then
						I226.Transparency = I227
					end
				end

				table.clear(U418)
			end)

			pcall(function()
				for I228, I229 in ipairs(workspace:GetDescendants()) do
					if I229.Name:find("ST_Effect_") or I229.Name:find("ST_NaN_") or I229.Name:find("ST_Kick_") then
						I229:Destroy()
					end
				end
			end)
		end

		L0_339 = function()
			local L643_1 = U412()
			if not L643_1 then
				return
			end
			local U435 = L643_1:FindFirstChild("SoundPart")
			local U436 = L643_1:FindFirstChild("StickyPart")
			if not U436 then
				return
			end

			if U435 then
				for I230 = 1, 20 do
					pcall(function()
						game:GetService("ReplicatedStorage").GrabEvents.SetNetworkOwner:FireServer(U435, U435.CFrame)
					end)

					if not (U435:FindFirstChild("PartOwner") and U435.PartOwner.Value == U68.Name) then
						continue
					end
					break
				end
			end

			local U437 = nil

			pcall(function()
				U437 = workspace.Map.AlwaysHereTweenedObjects.Ocean.Object.ObjectModel:GetChildren()[1]
			end)

			local L643_2 = not U437

			if L643_2 then
				pcall(function()
					local L646_1 = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("AlwaysHereTweenedObjects") and workspace.Map.AlwaysHereTweenedObjects:FindFirstChild("Ocean")

					if L646_1 then
						for I231, I232 in ipairs(L646_1:GetDescendants()) do
							if I232:IsA("BasePart") then
								U437 = I232
								break
							end
						end
					end
				end)
			end

			if L643_2 then
				return
			end

			pcall(function()
				game:GetService("ReplicatedStorage").PlayerEvents.StickyPartEvent:FireServer(U436, U437, CFrame.new(0, -2e38, 0))
				U419()
			end)
		end

		local L0_340 = U92.Server:AddGroupbox({
			Side = 2,
			Name = "<b>Break Parts</b>",
			IconName = "hammer",
			Description = "Breaking parts, sticky ect.",
			MaxPopOutHeight = 600,
			PopOutWidth = 250,
		}):AddTabbox({ MaxPopOutHeight = 600 })

		local L0_341 = L0_340:AddTab("<b>NaN</b>", "diamond-percent")

		L0_341:AddDropdown("NaNPlots", {
			Text = "Plots",
			Values = { "TudorHouse", "PinkRoofHouse", "HauntedHouse", "BlueHouse", "JapaneseHouse" },
			ValueImages = {
				TudorHouse = "rbxassetid://8989327148",
				PinkRoofHouse = "rbxassetid://8989326312",
				HauntedHouse = "rbxassetid://9909725942",
				BlueHouse = "rbxassetid://9909733734",
				JapaneseHouse = "rbxassetid://9108988013",
			},
			Default = "TudorHouse",
			Callback = function(A648_1)
				U416 = U417[A648_1] or "1"
			end,
		})

		L0_341:AddToggle("BreakPlotToggle", {
			Text = "Break Plot",
			Default = false,
			Callback = function(A649_1)
				if A649_1 then
					F_000630()
				else
					F_000639()
				end
			end,
		}):AddKeyPicker("BreakPlotKey", {
			Default = "None",
			Mode = "Toggle",
			SyncToggleState = true,
			Text = "Break Plot Keybind",
			Callback = function()
			end,
		})

		L0_341:AddDivider("NaN Settings")
		local U438 = L0_341:AddButton({ Text = "Noclip The Aiming Part", Func = F_000633, DoubleClick = false })

		pcall(function()
			U438:AddKeyPicker("NoclipAimKey", { Default = "None", Mode = "Press", Text = "Noclip Aiming Part Key", Callback = F_000633 })
		end)

		local U439 = L0_341:AddButton({ Text = "Unnoclip All Parts", Func = F_000639, DoubleClick = false })

		pcall(function()
			U439:AddKeyPicker("UnnoclipAllKey", { Default = "None", Mode = "Press", Text = "Unnoclip All Key", Callback = F_000639 })
		end)

		local L0_342 = L0_340:AddTab("<b>Part Kick</b>", "ear-off")
		local U440 = L0_342:AddButton({ Text = "Apply to Aiming Part", Func = U421, DoubleClick = false })

		pcall(function()
			U440:AddKeyPicker("ApplyAimingKey", { Default = "None", Mode = "Press", Text = "Apply Aiming Part Key", Callback = U421 })
		end)

		L0_342:AddButton({ Text = "Return To Normal", Func = F_000639, DoubleClick = false })
		L0_340:AddTab("<b>Ocean</b>", "waves-horizontal"):AddButton({ Text = "Break Ocean", Func = L0_339, DoubleClick = false })
	end

	do
		local L0_343 = U92.Server:AddGroupbox({
			Side = 2,
			Name = "<b>House Barrier</b>",
			IconName = "house",
			Description = "Barrier break",
			MaxPopOutHeight = 600,
			PopOutWidth = 250,
		})

		local U441 = L0_343:AddLabel("House Barrier Status: <font color=\"#55e87a\">Clean</font>", true)
		local U442 = false
		local U443 = nil
		local U444 = false

		local function F_000654()
			if U444 then
				return true
			end
			local L654_1 = workspace:FindFirstChild("Plots")
			if not L654_1 then
				return false
			end
			local L654_2 = false
			local L654_3 = false

			for I233, I234 in ipairs(L654_1:GetChildren()) do
				local L654_4 = I234:FindFirstChild("Barrier")

				if L654_4 then
					for I235, I236 in ipairs(L654_4:GetChildren()) do
						if I236:IsA("BasePart") and (I236.Name == "PlotBarrier" or I236.Name:find("Barrier")) then
							L654_2 = true
							if I236.CanCollide then
								L654_3 = true
								break
							end
						end
					end
				end

				if not L654_3 then
					continue
				end
				break
			end

			if L654_2 and not L654_3 then
				return true
			end
			return false
		end

		local function F_000655()
			if F_000654() then
				U441:SetText("House Barrier Status: <font color=\"#ff5050\">Broken</font>")
			else
				U441:SetText("House Barrier Status: <font color=\"#55e87a\">Clean</font>")
			end
		end

		task.spawn(function()
			while true do
				pcall(F_000655)
				task.wait(2)
			end
		end)

		L0_343:AddDivider()

		L0_343:AddToggle("DestroyBarrierHouse", {
			Text = "Break Barrier",
			Default = false,
			Callback = function(A657_1)
				if A657_1 and U444 then
					pcall(function()
						U62:Notify({ Title = "Already Broken", Description = "Plots are already broken!", Duration = 4 })
					end)

					return
				end

				U442 = A657_1

				if U443 then
					task.cancel(U443)
					U443 = nil
				end

				if A657_1 then
					local L657_1 = workspace:FindFirstChild(U68.Name .. "SpawnedInToys")

					if L657_1 then
						for I237, I238 in ipairs(L657_1:GetChildren()) do
							if I238.Name == "BallSnowball" then
								pcall(function()
									U73.MenuToys.DestroyToy:FireServer(I238)
								end)
							end
						end
					end

					F_000655()

					U443 = task.spawn(function()
						local U445 = U73:WaitForChild("MenuToys")
						local L660_1 = U73:WaitForChild("GrabEvents")
						local U446 = L660_1:WaitForChild("SetNetworkOwner")
						L660_1:WaitForChild("DestroyGrabLine")
						local U447 = CFrame.new(264.57925415039062, -5.4770703315734863, 433.45578002929688)

						local function F_000661()
							local L661_1 = {}
							local L661_2 = workspace:FindFirstChild(U68.Name .. "SpawnedInToys")

							if L661_2 then
								for I239, I240 in ipairs(L661_2:GetChildren()) do
									if I240.Name == "BallSnowball" then
										table.insert(L661_1, I240)
									end
								end
							end

							return L661_1
						end

						local function F_000662()
							if not U442 then
								return
							end
							local U448 = CFrame.new(U68.Character and U68.Character.PrimaryPart and U68.Character.PrimaryPart.Position or Vector3.zero) * CFrame.Angles(-0.807, -0.884, -0.679)

							task.spawn(function()
								pcall(function()
									U445.SpawnToyRemoteFunction:InvokeServer("BallSnowball", U448, Vector3.new(0, -120.211, 0))
								end)
							end)
						end

						local function F_000665(A665_1)
							if not U442 then
								return
							end
							local U449 = A665_1:FindFirstChild("SoundPart")

							if U449 then
								task.spawn(function()
									pcall(function()
										U446:FireServer(U449, U449.CFrame)
									end)
								end)
							end
						end

						local function F_000668(A668_1)
							if not U442 then
								return
							end

							for I241, I242 in ipairs(A668_1) do
								task.spawn(function()
									for I243, I244 in ipairs(I242:GetDescendants()) do
										if I244:IsA("BasePart") then
											I244.CFrame = U447
										end
									end
								end)
							end
						end

						local function F_000670()
							if not U442 then
								return false
							end
							local U450 = CFrame.new(242.66055297851562, -9.1965494155883789, 444.37588500976562)

							pcall(function()
								U445.SpawnToyRemoteFunction:InvokeServer("OvenDarkGray", U450, Vector3.new(0, -74.079, 0))
							end)

							task.wait(0.5)
							local L670_1 = workspace:FindFirstChild(U68.Name .. "SpawnedInToys")
							local L670_2 = nil

							if L670_1 then
								L670_2 = nil

								for I245, I246 in ipairs(L670_1:GetChildren()) do
									if I246.Name == "OvenDarkGray" and I246:GetAttribute("AtSpawned") == nil then
										L670_2 = I246
										break
									else
										L670_2 = nil
									end
								end
							end

							local L670_3 = L670_2 ~= nil

							if L670_3 then
								U444 = true
								F_000655()

								pcall(function()
									U62:Notify({ Title = "Success!", Description = "The plots have been broken successfully!", Duration = 5 })
								end)

								if U66.DestroyBarrierHouse then
									U66.DestroyBarrierHouse:SetValue(false)
								end
							end

							return L670_3
						end

						while U442 do
							local L660_2 = F_000661()
							local L660_3

							if #L660_2 < 2 then
								if #L660_2 < 1 then
									F_000662()
									task.wait(0.02)
								end

								F_000662()
								task.wait(0.02)
								L660_3 = F_000661()
							else
								L660_3 = L660_2
							end

							if not (#L660_3 >= 2) then
								task.wait(0.05)
								continue
							else
								for I247, I248 in ipairs(L660_3) do
									F_000665(I248)
								end

								F_000668(L660_3)

								if not F_000670() then
									task.wait(0.05)
									task.wait(0.05)
									continue
								end
							end

							break
						end
					end)
				else
					local L657_2 = workspace:FindFirstChild(U68.Name .. "SpawnedInToys")

					if L657_2 then
						for I249, I250 in ipairs(L657_2:GetChildren()) do
							if I250.Name == "BallSnowball" or I250.Name == "OvenDarkGray" then
								pcall(function()
									U73.MenuToys.DestroyToy:FireServer(I250)
								end)
							end
						end
					end

					F_000655()
				end
			end,
		})

		L0_343:AddDivider()
	end

	local L0_344

	L0_344 = U92.Target:AddGroupbox({
		Side = 2,
		Name = "<b>Looping Methods</b>",
		IconName = "toy-brick",
		Description = "Types",
		MaxPopOutHeight = 600,
		PopOutWidth = 250,
	}):AddTabbox({ MaxPopOutHeight = 600 })

	local U451
	U451 = L0_344:AddTab("<b>Loop</b>", "repeat")

	U451:AddDropdown("NoBlobMethodType", {
		Text = "Type",
		Values = { "Kill", "Kick", "Destroy Gucci", "Remove Food" },
		ValueImages = {
			Kill = "skull",
			Kick = "user-x",
			["Destroy Gucci"] = "trash-2",
			["Remove Food"] = "utensils",
		},
		Default = { "Kick" },
		Multi = true,
		Callback = function()
			if U66.NoBlobLoopApply and U66.NoBlobLoopApply.Value then
				U66.NoBlobLoopApply:SetValue(false)
				task.wait(0.1)
				U66.NoBlobLoopApply:SetValue(true)
			end
		end,
	})

	local L0_345 = U451:AddDependencyBox()

	L0_345:AddToggle("NoBlobRemoveAntiKick", {
		Text = "Remove Anti Kick",
		Default = true,
		Callback = function()
		end,
	})

	L0_345:AddToggle("NoBlobRagdollTarget", {
		Text = "Ragdoll Target",
		Default = true,
		Callback = function()
		end,
	})

	L0_345:AddDivider()

	L0_345:AddSlider("NoBlobKickX", {
		Text = "X",
		Default = 0,
		Min = -10,
		Max = 10,
		Rounding = 1,
		Compact = true,
		Callback = function()
		end,
	})

	L0_345:AddSlider("NoBlobKickY", {
		Text = "Y",
		Default = 15,
		Min = -30,
		Max = 30,
		Rounding = 1,
		Compact = true,
		Callback = function()
		end,
	})

	L0_345:AddSlider("NoBlobKickZ", {
		Text = "Z",
		Default = 0,
		Min = -10,
		Max = 10,
		Rounding = 1,
		Compact = true,
		Callback = function()
		end,
	})

	L0_345:AddDivider()
	L0_345:SetupDependencies({ { U65.NoBlobMethodType, "Kick" } })

	do
		local function F_000680()
			local U452 = U88(U65.NoBlobmanTarget and U65.NoBlobmanTarget.Value)
			if not U452 or not U452.Character then
				return
			end
			local U453 = U452.Character:FindFirstChild("HumanoidRootPart")
			local U454 = game:GetService("Players").LocalPlayer.Character
			local U455 = U454 and U454:FindFirstChild("HumanoidRootPart")
			local U456 = U454 and U454:FindFirstChildOfClass("Humanoid")
			if not U453 or not U455 then
				return
			end

			local function F_000681(A681_1)
				if _G.pcldPlayerCache then
					for I251, I252 in pairs(_G.pcldPlayerCache) do
						if I252 == A681_1 and I251 and I251.Parent then
							return I251
						end
					end
				end

				local L681_1 = math.huge
				local L681_2 = nil

				for I253, I254 in ipairs(workspace:GetChildren()) do
					if I254.Name == "PlayerCharacterLocationDetector" and I254:IsA("BasePart") then
						local U457 = false

						pcall(function()
							for I255, I256 in ipairs({ "Player", "Owner", "UserId", "PlayerName" }) do
								local L682_1 = I254:GetAttribute(I256)

								if L682_1 then
									if typeof(L682_1) == "Instance" and L682_1 == A681_1 then
										U457 = true
									elseif typeof(L682_1) == "number" and L682_1 == A681_1.UserId then
										U457 = true
									elseif typeof(L682_1) == "string" and (L682_1 == A681_1.Name or L682_1 == A681_1.DisplayName) then
										U457 = true
									end
								end
							end

							if not U457 then
								for I257, I258 in ipairs(I254:GetChildren()) do
									if I258:IsA("ObjectValue") and (I258.Value == A681_1 or I258.Value == A681_1.Character) then
										U457 = true
									elseif I258:IsA("StringValue") and (I258.Value == A681_1.Name or I258.Value == A681_1.DisplayName) then
										U457 = true
									end
								end
							end
						end)

						if U457 then
							return I254
						end

						if A681_1.Character and A681_1.Character:FindFirstChild("HumanoidRootPart") then
							local L681_3 = (I254.Position - A681_1.Character.HumanoidRootPart.Position).Magnitude

							if L681_3 < L681_1 then
								L681_2 = I254
								L681_1 = L681_3
							end
						end
					end
				end

				return L681_2
			end

			local U458 = game:GetService("ReplicatedStorage"):FindFirstChild("GrabEvents")
			U458 = U458 and U458:FindFirstChild("SetNetworkOwner")

			task.spawn(function()
				local L683_1 = F_000681(U452)
				local L683_2 = L683_1 and L683_1.CFrame or U453.CFrame
				local U459 = U455.CFrame

				pcall(function()
					beginDecoy(U459, U454, U456)
				end)

				U455.CFrame = L683_2
				U455.Velocity = Vector3.zero
				task.wait(0.2)

				pcall(function()
					if not U453 or not U455 then
						return
					end

					if U458 then
						for I259 = 1, 3 do
							pcall(function()
								U458:FireServer(U453, U458)
							end)

							pcall(function()
								U458:FireServer(U453, U453.CFrame)
							end)

							task.wait(0.05)
						end
					end
				end)

				if U455 then
					U455.CFrame = U459
					U455.Velocity = Vector3.zero
				end

				pcall(function()
					endDecoy()
				end)
			end)
		end

		local U460 = U451:AddButton({ Text = "Break Desync", Func = F_000680 })

		pcall(function()
			U460:AddKeyPicker("BreakDesyncKey", { Default = "None", Mode = "Press", Text = "Break Desync", Callback = F_000680 })
		end)
	end

	U451:AddDivider()
	local L0_346
	L0_346 = L0_344:AddTab("<b>Explode</b>", "bomb")

	pcall(function()
		U451:Show()
	end)

	local L0_347

	L0_347 = U92.Target:AddGroupbox({
		Side = 1,
		Name = "<b>Players</b>",
		IconName = "users",
		Description = "Target picker",
		MaxPopOutHeight = 600,
		PopOutWidth = 250,
	}):AddTabbox({ MaxPopOutHeight = 600 }):AddTab("<b>Players</b>", "users")

	L0_347:AddDivider()

	L0_347:AddDropdown("NoBlobmanTarget", {
		Text = "Select Target",
		Values = U87(),
		Default = 1,
		AllowNull = true,
		Multi = false,
		Searchable = true,
		Callback = function()
			if U66.NoBlobLoopApply and U66.NoBlobLoopApply.Value then
				U66.NoBlobLoopApply:SetValue(false)
				task.wait(0.1)
				U66.NoBlobLoopApply:SetValue(true)
			end
		end,
	})

	local U461
	U461 = {}
	local U462, U463, U464

	do
		local U465 = {}
		local U466 = false
		local U467 = {}

		U462 = function()
			for I260, I261 in pairs(U461) do
				if I261 then
					pcall(function()
						task.cancel(I261)
					end)
				end
			end

			U461 = {}
			U466 = false

			for I262, I263 in pairs(U465) do
				if I263 then
					pcall(function()
						I263:Destroy()
					end)
				end
			end

			U465 = {}
		end

		U463 = function()
			return U88(U65.NoBlobmanTarget and U65.NoBlobmanTarget.Value)
		end

		local function F_000696(A696_1)
			if A696_1 == U68 then
				return
			end

			local function F_000697(A697_1)
				task.spawn(function()
					local U468 = A697_1:FindFirstChildOfClass("Humanoid") or A697_1:WaitForChild("Humanoid", 1)

					if U468 then
						U468:GetPropertyChangedSignal("SeatPart"):Connect(function()
							if U468.SeatPart then
								U467[A696_1.Name] = U468.SeatPart
							end
						end)

						if U468.SeatPart then
							U467[A696_1.Name] = U468.SeatPart
						end
					end
				end)
			end

			if A696_1.Character then
				F_000697(A696_1.Character)
			end

			A696_1.CharacterAdded:Connect(F_000697)
		end

		task.spawn(function()
			for I264, I265 in ipairs(U67:GetPlayers()) do
				F_000696(I265)
			end

			U67.PlayerAdded:Connect(F_000696)
		end)

		U464 = function(A701_1, A701_2)
			local L701_1 = game:GetService("ReplicatedStorage"):WaitForChild("GrabEvents")
			local U469 = L701_1:WaitForChild("SetNetworkOwner")
			local U470 = L701_1:WaitForChild("CreateGrabLine")
			local U471 = L701_1:WaitForChild("DestroyGrabLine")
			local L701_2 = U67:FindFirstChild(A701_1)
			if not L701_2 then
				return
			end

			local function F_000702(A702_1)
				if not A702_1 or not A702_1.Parent then
					return
				end
				local L702_1 = U68.Character
				L702_1 = L702_1 and L702_1:FindFirstChild("HumanoidRootPart")
				if not L702_1 then
					return
				end

				if (L702_1.Position - A702_1.Position).Magnitude <= 30 then
					pcall(function()
						U469:FireServer(A702_1, U469)
					end)
				end
			end

			local function F_000704(A704_1)
				if A704_1 and A704_1.Character then
					local L704_1 = A704_1.Character:FindFirstChild("Head")
					if L704_1 and L704_1:FindFirstChild("PartOwner") and L704_1.PartOwner.Value == U68.Name then
						return true
					end
				end

				return false
			end

			local function F_000705(A705_1)
				if A705_1 and not A705_1:FindFirstChild("SkyVelocity") then
					local L705_1 = Instance.new("BodyVelocity", A705_1)
					L705_1.Name = "SkyVelocity"
					L705_1.Velocity = Vector3.new(0, 1000, 0)
					L705_1.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
				end
			end

			local function F_000706(A706_1)
				if not A706_1 then
					return
				end

				task.spawn(function()
					for I266 = 1, 3 do
						pcall(function()
							U470:FireServer(A706_1)
						end)

						task.wait(0.06)
					end
				end)
			end

			local L701_3 = nil

			while A701_2() and L701_2 do
				if not L701_2.Parent or not L701_2.Character then
					task.wait(0.5)
				else
					local L701_4 = L701_2.Character
					local U472 = L701_4:FindFirstChild("HumanoidRootPart")
					local L701_5 = L701_4:FindFirstChildOfClass("Humanoid")
					local U473 = U68.Character
					local L701_6 = U473 and U473:FindFirstChild("HumanoidRootPart")

					if not U472 or not L701_5 or L701_5.Health <= 0 or not L701_6 then
						task.wait(0.5)
					elseif L701_2:FindFirstChild("InPlot") and L701_2.InPlot.Value or L701_5.FloorMaterial == Enum.Material.Air then
						task.wait(0.5)
					else
						L701_3 = L701_6.CFrame

						for I267 = 0, 50 do
							if A701_2() then
								pcall(function()
									for I268, I269 in ipairs(U473:GetDescendants()) do
										if I269:IsA("BasePart") then
											I269.CanCollide = false
										end
									end
								end)

								F_000702(U472)
								F_000706(U472)

								if F_000704(L701_2) or U472 and U472.AssemblyLinearVelocity.Magnitude > 500 then
									pcall(function()
										U471:FireServer(U472)
									end)

									F_000705(U472)
									break
								else
									task.wait()

									if U472 and U472.Parent then
										if U472.Position.Y <= -12 then
											L701_6.CFrame = CFrame.new(U472.Position + Vector3.new(0, 5, -15))
										else
											L701_6.CFrame = CFrame.new(U472.Position + Vector3.new(0, -10, -10))
										end

										L701_5.BreakJointsOnDeath = false
										L701_5:ChangeState(Enum.HumanoidStateType.Dead)
										L701_5.Jump = true
										L701_5.Sit = false
									end

									continue
								end
							end

							break
						end

						if L701_6 and L701_6.Parent then
							L701_6.CFrame = L701_3
							L701_6.AssemblyLinearVelocity = Vector3.zero
						end

						task.wait(0.2)
					end
				end
			end

			pcall(function()
				local L711_1 = U68.Character

				if L711_1 then
					for I270, I271 in ipairs(L711_1:GetDescendants()) do
						if I271:IsA("BasePart") then
							I271.CanCollide = true
						end
					end
				end
			end)

			if L701_3 and U68.Character and U68.Character:FindFirstChild("HumanoidRootPart") then
				U68.Character.HumanoidRootPart.CFrame = L701_3
			end
		end

		local function F_000712(A712_1, A712_2)
			local U474 = game:GetService("ReplicatedStorage")
			local U475 = game:GetService("RunService")
			local U476 = U67:FindFirstChild(A712_1)
			if not U476 then
				return
			end
			local L712_1 = U474:WaitForChild("GrabEvents")
			local U477 = L712_1:WaitForChild("SetNetworkOwner")
			local U478 = L712_1:WaitForChild("DestroyGrabLine")
			local U479 = Vector3.zero
			local U480 = CFrame.new(0, 1e9, 0)
			local U481 = nil
			local U482 = false
			local U483 = nil

			local function F_000713(A713_1)
				if not A713_1 or not A713_1.Parent then
					return
				end

				pcall(function()
					U477:FireServer(A713_1, A713_1.CFrame)
				end)
			end

			local function F_000715(A715_1)
				if not A715_1 or not A715_1.Parent then
					return
				end

				pcall(function()
					U478:FireServer(A715_1)
				end)
			end

			local function F_000717()
				U482 = false
				U483 = nil

				for I272, I273 in pairs(U465) do
					if I273 then
						pcall(function()
							I273:Destroy()
						end)
					end
				end

				U465 = {}
			end

			local function F_000719()
				if not U476 or not U476.Parent then
					return false
				end
				local L719_1 = U476.Character
				if not L719_1 then
					return false
				end
				local L719_2 = L719_1:FindFirstChild("Humanoid")
				if not L719_2 or L719_2.Health <= 0 then
					return false
				end
				local L719_3 = L719_1:FindFirstChild("HumanoidRootPart")
				if not L719_3 then
					return false
				end

				if L719_3 ~= U483 then
					U483 = L719_3
				end

				return true
			end

			task.spawn(function()
				while A712_2() and U476 and U476.Parent do
					local L720_1 = U476.Character
					local U484 = L720_1 and L720_1:FindFirstChild("HumanoidRootPart")

					if U484 then
						pcall(function()
							U477:FireServer(U484, U484.CFrame)
							U484.AssemblyLinearVelocity = U479
							U484.AssemblyAngularVelocity = U479
						end)
					end

					U475.RenderStepped:Wait()
				end
			end)

			local L712_2 = workspace:FindFirstChild(U68.Name .. "SpawnedInToys")
			local L712_3 = L712_2 and L712_2:FindFirstChild("PalletLightBrown")

			if not L712_3 and U68.CanSpawnToy.Value then
				pcall(function()
					U474.MenuToys.SpawnToyRemoteFunction:InvokeServer("PalletLightBrown", U480, Vector3.new(0, -90, 0))
				end)

				task.wait(0.05)
				local L712_4 = workspace:FindFirstChild(U68.Name .. "SpawnedInToys")
				L712_3 = L712_4 and L712_4:FindFirstChild("PalletLightBrown")
			end

			local U485 = L712_3 and L712_3:FindFirstChild("SoundPart")
			local L712_5 = nil
			local L712_6 = nil
			local L712_7 = nil
			local L712_8 = 0
			local L712_9 = 0
			if not U485 then
				return
			end

			while A712_2() and U476 do
				U475.Stepped:Wait()

				if not F_000719() then
					F_000717()
					local L712_10 = tick()

					while true do
						if A712_2() and U476 and tick() - L712_10 < 0.5 then
							if not F_000719() then
								task.wait(0.1)
								continue
							end
						end

						break
					end

					if not F_000719() then
						local L712_11 = U68.Character
						L712_11 = L712_11 and L712_11:FindFirstChild("HumanoidRootPart")

						if L712_11 then
							U481 = L712_11.CFrame
						end

						L712_5 = nil
						L712_6 = nil
						L712_7 = nil
					end

					task.wait(0.1)
				else
					local L712_12 = U68.Character
					L712_12 = L712_12 and L712_12:FindFirstChild("HumanoidRootPart")

					if not L712_12 then
						task.wait()
					else
						U481 = U481 or L712_12.CFrame
						local U486 = U476.Character
						local U487 = U486 and U486:FindFirstChild("Humanoid")
						local L712_13 = U483

						if not L712_13 or not U487 then
							task.wait()
						else
							F_000713(L712_13)

							pcall(function()
								local L723_1 = U486:FindFirstChild("Torso")

								if L723_1 then
									L723_1.Velocity = U479
									L723_1.RotVelocity = U479
									L723_1.CanCollide = false
								end

								U487.PlatformStand = false
								U487.Sit = false
								U487:ChangeState(Enum.HumanoidStateType.Physics)

								for I274, I275 in ipairs(U487:GetPlayingAnimationTracks()) do
									I275:Stop()
								end
							end)

							local U488 = U65.NoBlobKickX and U65.NoBlobKickX.Value or 0
							local U489 = U65.NoBlobKickY and U65.NoBlobKickY.Value or 15
							local U490 = U65.NoBlobKickZ and U65.NoBlobKickZ.Value or 0

							if not U482 then
								L712_12.CFrame = L712_13.CFrame * CFrame.new(U488, -6, U490)
								L712_12.Velocity = U479
								L712_6 = L712_6 or tick()
								L712_5 = L712_5 or tick()

								if tick() - L712_5 > 0.2 then
									U482 = true
									L712_12.CFrame = U481
									L712_12.Velocity = U479
									local L712_14 = Instance.new("Attachment", L712_13)
									local L712_15 = Instance.new("Attachment", L712_12)
									L712_15.CFrame = CFrame.new(U488, U489, U490)
									local L712_16 = Instance.new("AlignPosition", L712_13)
									L712_16.Attachment0 = L712_14
									L712_16.Attachment1 = L712_15
									L712_16.MaxForce = math.huge
									L712_16.MaxVelocity = math.huge
									L712_16.Responsiveness = 200
									L712_16.ApplyAtCenterOfMass = true
									local L712_17 = Instance.new("AlignOrientation", L712_13)
									L712_17.Attachment0 = L712_14
									L712_17.Attachment1 = L712_15
									L712_17.MaxTorque = math.huge
									L712_17.Responsiveness = 200
									U465 = { att0 = L712_14, att1 = L712_15, ap = L712_16, ao = L712_17 }
									L712_5 = nil
									L712_6 = nil

									if doRagdoll then
										pcall(function()
											U487:ChangeState(Enum.HumanoidStateType.Physics)
										end)

										L712_5 = nil
										L712_6 = nil
									end
								end
							else
								if U465.att1 then
									pcall(function()
										U465.att1.CFrame = CFrame.new(U488, U489, U490)
									end)
								end

								if not F_000719() then
									F_000717()
									U481 = L712_12.CFrame
									L712_12.CFrame = U481
									L712_12.Velocity = U479
									task.wait(0.1)
								else
									local U491 = U483
									L712_7 = L712_7 or tick() + 0.25
									local L712_18

									if L712_7 and tick() >= L712_7 then
										if (L712_12.Position - U491.Position).Magnitude > 25 then
											F_000717()
											U482 = false
											L712_5 = tick()
											U481 = L712_12.CFrame
											L712_12.CFrame = U491.CFrame * CFrame.new(0, -8, 0)
											L712_12.Velocity = U479
											F_000713(U491)
											F_000715(U491)
											task.wait()
											L712_6 = nil
											L712_7 = nil
										else
											F_000713(U491)
											F_000715(U491)
											U491.Velocity = U479
											U491.RotVelocity = U479

											if tick() - L712_8 > 0.05 then
												pcall(function()
													F_000715(U491)
												end)

												L712_8 = tick()
											end

											L712_18 = tick()

											if L712_18 - L712_9 >= 0.05 then
												pcall(function()
													U485.CFrame = U491.CFrame * CFrame.new(0, 2, 0)
													U477:FireServer(U485, U485.CFrame)
												end)

												task.wait()

												pcall(function()
													U485.CFrame = U480
												end)

												L712_9 = L712_18
											end

											task.wait()
										end

										continue
									else
										F_000713(U491)
										F_000715(U491)
										U491.Velocity = U479
										U491.RotVelocity = U479

										if tick() - L712_8 > 0.05 then
											pcall(function()
												F_000715(U491)
											end)

											L712_8 = tick()
										end

										L712_18 = tick()

										if L712_18 - L712_9 >= 0.05 then
											pcall(function()
												U485.CFrame = U491.CFrame * CFrame.new(0, 2, 0)
												U477:FireServer(U485, U485.CFrame)
											end)

											task.wait()

											pcall(function()
												U485.CFrame = U480
											end)

											L712_9 = L712_18
										end
									end

									task.wait()
									continue
								end

								continue
							end

							task.wait()
						end
					end
				end
			end

			F_000717()

			if myRoot and U481 then
				pcall(function()
					myRoot.CFrame = U481
				end)
			end
		end

		local function F_000733(A733_1)
			if not A733_1 or A733_1 == U68 then
				return false
			end
			local L733_1 = U467[A733_1.Name]
			if not L733_1 or not L733_1.Parent then
				return false
			end
			local L733_2 = U68.Character
			local L733_3 = L733_2 and L733_2:FindFirstChildOfClass("Humanoid")
			L733_2 = L733_2 and L733_2:FindFirstChild("HumanoidRootPart")
			if not L733_3 or not L733_2 then
				return false
			end
			local U492 = L733_1:FindFirstAncestorWhichIsA("Model")
			local L733_4 = U492 and U492:FindFirstChild("Head")
			local U493 = U73:FindFirstChild("MenuToys") and U73.MenuToys:FindFirstChild("DestroyToy")
			local U494 = U73:FindFirstChild("GrabEvents") and U73.GrabEvents:FindFirstChild("SetNetworkOwner")
			local L733_5 = L733_2.CFrame
			local L733_6 = L733_2.AssemblyLinearVelocity
			L733_2.CFrame = L733_1.CFrame
			L733_2.AssemblyLinearVelocity = Vector3.zero
			L733_2.AssemblyAngularVelocity = Vector3.zero
			L733_1:Sit(L733_3)
			task.wait(0.2)

			if U492 and U492.Parent then
				for I276, I277 in ipairs(U492:GetDescendants()) do
					if I277:IsA("BasePart") then
						if U494 then
							pcall(function()
								U494:FireServer(I277, I277.CFrame)
							end)
						end

						I277.CanCollide = false
						I277.AssemblyLinearVelocity = Vector3.new(0, -9999, 0)
					end
				end

				if L733_4 and L733_4.Parent then
					L733_4.CFrame = CFrame.new(L733_4.Position.X, 0, L733_4.Position.Z)
				end
			end

			L733_3.Sit = false
			L733_3:ChangeState(Enum.HumanoidStateType.GettingUp)
			task.wait(0.05)
			L733_2.CFrame = L733_5
			L733_2.AssemblyLinearVelocity = L733_6

			if U492 and U492.Parent then
				if U493 then
					pcall(function()
						U493:FireServer(U492)
					end)
				end

				pcall(function()
					U492:Destroy()
				end)
			end

			return true
		end

		local function F_000737(A737_1)
			while A737_1() do
				pcall(function()
					local L738_1 = U463()
					if not L738_1 then
						return
					end
					F_000733(L738_1)
				end)

				task.wait(0.15)
			end
		end

		local function F_000739(A739_1)
			local U495 = {
				FoodHamburger = true,
				FoodCoconut = true,
				FoodPizzaCheese = true,
				FoodPizzaPepperoni = true,
				FoodHotdog = true,
				FoodMushroomPoison = true,
				FoodBread = true,
				FoodDippyEgg = true,
				FoodMayonnaise = true,
				FoodFrenchFries = true,
				FoodMeatStick = true,
				FoodDonut = true,
				FoodCakePink = true,
				InstrumentGuitarBanjo = true,
				InstrumentGuitarViolin = true,
				InstrumentGuitarUkulele = true,
				InstrumentWoodwindSaxophone = true,
				InstrumentWoodwindOcarina = true,
				InstrumentBrassVuvuzelaQwizik = true,
				InstrumentBrassTrumpet = true,
				InstrumentDrumBongos = true,
				InstrumentDrumSnare = true,
				InstrumentPianoMelodica = true,
				InstrumentVoiceMicrophone = true,
				CupMugWhite = true,
				CupMugBrown = true,
				PoopPile = true,
				PoopPileSparkle = true,
			}

			local U496 = {}

			local L739_1 = workspace.DescendantAdded:Connect(function(A740_1)
				if U495[A740_1.Name] and A740_1:IsA("Model") then
					table.insert(U496, A740_1)
				end
			end)

			for I278, I279 in ipairs(workspace:GetDescendants()) do
				if U495[I279.Name] and I279:IsA("Model") then
					table.insert(U496, I279)
				end
			end

			while A739_1() do
				local U497 = game.Players.LocalPlayer.Character
				local U498 = U497 and U497:FindFirstChild("HumanoidRootPart")

				if U498 then
					for I280 = #U496, 1, -1 do
						local U499 = U496[I280]

						if A739_1() then
							if not U499 or not U499.Parent then
								table.remove(U496, I280)
							elseif U499:FindFirstChild("HoldPart") then
								local U500 = U499.HoldPart

								pcall(function()
									U500.HoldItemRemoteFunction:InvokeServer(U499, U497)
								end)

								task.wait()

								pcall(function()
									U500.DropItemRemoteFunction:InvokeServer(U499, CFrame.new(U498.Position + Vector3.new(0, -2000, 0)), Vector3.zero)
								end)
							end

							continue
						end

						break
					end
				end

				task.wait(0.2)
			end

			L739_1:Disconnect()
		end

		local function F_000743(A743_1)
			local U501 = game:GetService("ReplicatedStorage").GrabEvents.SetNetworkOwner

			while A743_1() do
				pcall(function()
					local L744_1 = U463()
					if not L744_1 then
						return
					end
					local L744_2 = workspace:FindFirstChild(L744_1.Name .. "SpawnedInToys")
					if not L744_2 then
						return
					end

					for I281, I282 in ipairs({ "NinjaKunai", "NinjaShuriken", "AntiKick" }) do
						local L744_3 = L744_2:FindFirstChild(I282)

						if L744_3 then
							local L744_4 = L744_3:FindFirstChild("SoundPart")

							if L744_4 then
								U501:FireServer(L744_4, L744_4.CFrame)

								if L744_4:FindFirstChild("PartOwner") and L744_4.PartOwner.Value == U68.Name then
									L744_4.CFrame = CFrame.new(0, 1000, 0)
								end
							end
						end
					end
				end)

				task.wait(0.1)
			end
		end

		local U502 = false

		local function F_000745()
			local L745_1 = game:GetService("ReplicatedStorage")
			local U503 = L745_1.GrabEvents.SetNetworkOwner
			local U504 = L745_1.MenuToys.DestroyToy

			local function F_000746(A746_1)
				if A746_1 and A746_1.Parent then
					pcall(function()
						U503:FireServer(A746_1, A746_1.CFrame)
					end)
				end
			end

			while U502 do
				pcall(function()
					local L748_1 = U463()
					if not L748_1 or not L748_1.Character or not L748_1.Character:FindFirstChild("Head") then
						return
					end
					local L748_2 = workspace:FindFirstChild(U68.Name .. "SpawnedInToys")
					local U505 = L748_2 and L748_2:FindFirstChild("BallSnowball")

					if not U505 then
						U505 = U90("BallSnowball", CFrame.new(0, 500, 0))
						if not U505 then
							return
						end
					end

					local L748_3 = U505:FindFirstChild("SoundPart")
					local L748_4 = 0

					while not L748_3 and U505.Parent and U502 and L748_4 < 50 do
						task.wait(0.05)
						L748_4 += 1
						L748_3 = U505:FindFirstChild("SoundPart")
					end

					if not L748_3 or not U505.Parent then
						return
					end

					for I283 = 1, 5 do
						F_000746(L748_3)
						task.wait()
					end

					L748_3.CFrame = CFrame.new(L748_1.Character.Head.Position + Vector3.new(0, 10, 0))
					L748_3.AssemblyLinearVelocity = Vector3.new(0, -300, 0)

					for I284 = 1, 30 do
						if U502 then
							local L748_5 = U505:FindFirstChild("SoundPart")

							if L748_5 then
								F_000746(L748_5)
								L748_5.AssemblyLinearVelocity = Vector3.new(0, -300, 0)
								task.wait()
								continue
							end
						end

						break
					end

					if U505 and U505.Parent then
						pcall(function()
							U504:FireServer(U505)
						end)

						local L748_6 = 0

						while L748_2 and L748_2:FindFirstChild("BallSnowball") and U502 and L748_6 < 20 do
							task.wait(0.05)
							L748_6 += 1
						end
					end
				end)

				task.wait(0.1)
			end
		end

		L0_347:AddDivider()

		L0_347:AddToggle("NoBlobLoopApply", {
			Text = "Loop Apply Method Selected",
			Default = false,
			Callback = function(A750_1)
				U462()
				if not A750_1 then
					return
				end
				local L750_1 = U463()

				if not L750_1 then
					if U62 then
						U62:Notify({ Title = "Error", Description = "Select target first!", Duration = 3 })
					end

					return
				end

				local U506 = L750_1.Name
				local L750_2 = U65.NoBlobMethodType and U65.NoBlobMethodType.Value or {}
				local L750_3 = type(L750_2) == "table" and L750_2.Kill or L750_2 == "Kill"
				local L750_4 = type(L750_2) == "table" and L750_2.Kick or L750_2 == "Kick"
				local L750_5 = type(L750_2) == "table" and L750_2["Destroy Gucci"] or L750_2 == "Destroy Gucci"
				local L750_6 = type(L750_2) == "table" and L750_2["Remove Food"] or L750_2 == "Remove Food"
				local L750_7 = U66.NoBlobRemoveAntiKick and U66.NoBlobRemoveAntiKick.Value

				local function F_000751()
					return U66.NoBlobLoopApply and U66.NoBlobLoopApply.Value
				end

				if L750_3 then
					U461.kill = task.spawn(function()
						U464(U506, F_000751)
					end)
				end

				if L750_4 then
					U461.kick = task.spawn(function()
						F_000712(U506, F_000751)
					end)
				end

				if L750_5 then
					U461.gucci = task.spawn(function()
						F_000737(F_000751)
					end)
				end

				if L750_6 then
					U461.food = task.spawn(function()
						F_000739(F_000751)
					end)
				end

				if L750_7 then
					U461.antikick = task.spawn(function()
						F_000743(F_000751)
					end)
				end
			end,
		}):AddKeyPicker("NoBlobLoopApplyKey", {
			Default = "None",
			Mode = "Toggle",
			SyncToggleState = true,
			Text = "Loop Apply Method Selected",
		})

		L0_346:AddDropdown("ExplodeMethod", {
			Text = "Select Method",
			Values = { "Snowball" },
			ValueImages = L0_312,
			Default = 1,
			Callback = function()
			end,
		})

		L0_346:AddToggle("ApplyMethod", {
			Text = "Apply Method",
			Default = false,
			Callback = function(A758_1)
				U502 = A758_1

				if A758_1 then
					U461.snowball = task.spawn(F_000745)
				elseif U461.snowball then
					pcall(function()
						task.cancel(U461.snowball)
					end)

					U461.snowball = nil
				end
			end,
		}):AddKeyPicker("ApplyMethodKey", {
			Default = "None",
			Mode = "Toggle",
			SyncToggleState = true,
			Text = "Apply Method Keybind",
			Callback = function()
			end,
		})
	end

	do
		local U507 = false
		local U508 = nil

		local function F_000761(A761_1)
			U507 = A761_1

			if A761_1 then
				U508 = task.spawn(function()
					local U509 = game:GetService("ReplicatedStorage").MenuToys.SpawnToyRemoteFunction

					while U507 do
						pcall(function()
							local L763_1 = U68.Character
							if not L763_1 then
								return
							end
							local U510 = L763_1:FindFirstChildOfClass("Humanoid")
							local U511 = L763_1:FindFirstChild("HumanoidRootPart")
							if not U510 or not U511 then
								return
							end

							if U510.SeatPart then
								task.wait(0.1)
								return
							end
							local L763_2 = workspace:FindFirstChild(U68.Name .. "SpawnedInToys")
							L763_2 = L763_2 and L763_2:FindFirstChild("CreatureBlobman")

							if not L763_2 then
								pcall(function()
									U509:InvokeServer("CreatureBlobman", U511.CFrame * CFrame.new(0, 5, 5), Vector3.zero)
								end)

								local L763_3 = tick()

								while true do
									U69.Heartbeat:Wait()
									L763_2 = workspace:FindFirstChild(U68.Name .. "SpawnedInToys")
									L763_2 = L763_2 and L763_2:FindFirstChild("CreatureBlobman")
									if not (L763_2 or tick() - L763_3 > 5 or not U507) then
										continue
									end
									break
								end
							end

							if L763_2 then
								local U512 = L763_2:FindFirstChildWhichIsA("VehicleSeat")

								if U512 then
									U511.CFrame = U512.CFrame * CFrame.new(0, 1, 0)
									U511.Velocity = Vector3.zero

									pcall(function()
										U512:Sit(U510)
									end)
								end
							end
						end)

						task.wait(0.1)
					end
				end)
			else
				U507 = false

				if U508 then
					task.cancel(U508)
					U508 = nil
				end
			end
		end

		local U513 = false
		local U514 = nil

		local function F_000766()
			U513 = false

			if U514 then
				task.cancel(U514)
				U514 = nil
			end
		end

		local function F_000767(A767_1, A767_2)
			F_000766()
			if not A767_1 then
				return
			end
			U513 = true

			U514 = task.spawn(function()
				local U515 = game:GetService("ReplicatedStorage"):FindFirstChild("GrabEvents")
				local L768_1 = U68.Character
				local U516 = L768_1 and L768_1:FindFirstChild("HumanoidRootPart")
				if not U516 then
					return
				end
				local L768_2 = U516.CFrame
				local L768_3 = false
				local L768_4 = 0

				while true do
					if U513 and A767_2() then
						if not (not A767_1 or not A767_1.Parent or not A767_1.Character) then
							local L768_5 = A767_1.Character
							local U517 = L768_5:FindFirstChild("HumanoidRootPart")
							local U518 = L768_5:FindFirstChild("Humanoid")
							local L768_6 = L768_1 and L768_1:FindFirstChild("Humanoid") and L768_1.Humanoid.SeatPart

							if U517 and U518 and U518.Health > 0 then
								U517.AssemblyLinearVelocity = Vector3.zero
								U517.Velocity = Vector3.zero

								pcall(function()
									U518.PlatformStand = false
									U518.Sit = false
									U518:ChangeState(Enum.HumanoidStateType.Physics)

									for I285, I286 in ipairs(U518:GetPlayingAnimationTracks()) do
										I286:Stop()
									end
								end)

								if L768_6 then
									local L768_7 = L768_6.Parent
									local L768_8 = L768_7 and L768_7:FindFirstChild("BlobmanSeatAndOwnerScript")
									local U519 = L768_8 and L768_8:FindFirstChild("CreatureGrab")
									local U520 = L768_8 and L768_8:FindFirstChild("CreatureDrop")
									local U521 = L768_7:FindFirstChild("LeftDetector")
									local U522 = L768_7:FindFirstChild("RightDetector")
									local U523

									if U521 then
										U523 = U521:FindFirstChild("LeftWeld") or U521:FindFirstChild("RigidConstraint")
									else
										U523 = U521
									end

									local U524

									if U522 then
										U524 = U522:FindFirstChild("RightWeld") or U522:FindFirstChild("RigidConstraint")
									else
										U524 = U522
									end

									if U519 and U520 and U523 and U524 then
										pcall(function()
											U519:FireServer(U521, U517, U523)
											U519:FireServer(U522, U517, U524)
											U520:FireServer(U523, U517)
											U520:FireServer(U524, U517)
										end)
									end
								end

								if not L768_3 then
									U516.CFrame = U517.CFrame

									if U515 then
										pcall(function()
											if U515.SetNetworkOwner then
												U515.SetNetworkOwner:FireServer(U517, U516.CFrame)
											end

											if U515.CreateGrabLine then
												U515.CreateGrabLine:FireServer(U517, Vector3.zero, U517.Position, false)
											end
										end)
									end

									if L768_4 == 0 then
										L768_4 = tick()
									end

									if tick() - L768_4 > 0.3 then
										L768_3 = true
										L768_4 = 0
									end
								else
									local U525 = L768_2 * CFrame.new(U65.BlobKickX and U65.BlobKickX.Value or 0, U65.BlobKickY and U65.BlobKickY.Value or 25, U65.BlobKickZ and U65.BlobKickZ.Value or 0)
									U516.CFrame = L768_2
									U517.CFrame = U525

									if U515 then
										pcall(function()
											U518.PlatformStand = true

											if U515.SetNetworkOwner then
												U515.SetNetworkOwner:FireServer(U517, U525)
											end

											if U515.DestroyGrabLine then
												U515.DestroyGrabLine:FireServer(U517)
											end

											if U515.CreateGrabLine then
												U515.CreateGrabLine:FireServer(U517, Vector3.zero, U517.Position, false)
											end
										end)
									end
								end
							else
								L768_3 = false
								L768_4 = 0
							end

							U69.RenderStepped:Wait()
							continue
						end
					end

					break
				end

				if U516 and L768_2 then
					U516.CFrame = L768_2
				end

				U513 = false
			end)
		end

		local L0_348 = U92.Blob:AddGroupbox({
			Side = 1,
			Name = "<b>Blobman</b>",
			IconName = "users",
			Description = "Blob controls",
			MaxPopOutHeight = 600,
			PopOutWidth = 250,
		}):AddTabbox({ MaxPopOutHeight = 600 })

		local L0_349 = L0_348:AddTab("<b>Target</b>", "bot")
		L0_349:AddDivider()

		L0_349:AddDropdown("BlobmanTarget", {
			Text = "Select Target",
			Values = U87(),
			Default = 1,
			AllowNull = true,
			Multi = true,
			Searchable = true,
			Callback = function()
				if U66.BlobLoopApply and U66.BlobLoopApply.Value then
					U66.BlobLoopApply:SetValue(false)
					task.wait(0.1)
					U66.BlobLoopApply:SetValue(true)
				end
			end,
		})

		L0_349:AddDivider()

		L0_349:AddToggle("BlobLoopApply", {
			Text = "Loop Apply Method Selected",
			Default = false,
			Callback = function(A774_1)
				F_000766()

				if not A774_1 then
					for I287 in pairs(hkKillTargets) do
						hkKillTargets[I287] = nil
					end

					return
				end

				local L774_1 = U88(U65.BlobmanTarget and U65.BlobmanTarget.Value)

				if not L774_1 then
					if U62 then
						U62:Notify({ Title = "Error", Description = "Select target first!", Duration = 3 })
					end

					U66.BlobLoopApply:SetValue(false)
					return
				end

				local L774_2 = U65.BlobMethodType and U65.BlobMethodType.Value or {}
				local L774_3 = type(L774_2) == "table" and L774_2.Kill or L774_2 == "Kill"
				local L774_4 = type(L774_2) == "table" and L774_2.Kick or L774_2 == "Kick"

				local function F_000775()
					return U66.BlobLoopApply and U66.BlobLoopApply.Value
				end

				if L774_3 then
					hkKillTargets[L774_1.UserId] = true
				end

				if L774_4 then
					F_000767(L774_1, F_000775)
				end
			end,
		}):AddKeyPicker("BlobLoopKey", {
			Default = "None",
			Mode = "Toggle",
			SyncToggleState = true,
			Text = "Loop Apply Method Keybind",
			Callback = function()
			end,
		})

		L0_348:AddTab("<b>Features</b>", "zap"):AddToggle("AutoSeat", {
			Text = "AutoSeat",
			Default = false,
			Callback = function(A777_1)
				F_000761(A777_1)
			end,
		})
	end

	do
		local L0_350 = U92.Blob:AddGroupbox({
			Side = 2,
			Name = "<b>Method</b>",
			IconName = "paperclip",
			Description = "Blob attacks",
			MaxPopOutHeight = 600,
			PopOutWidth = 250,
		})

		L0_350:AddDropdown("BlobMethodType", {
			Text = "Type",
			Values = { "Kill", "Kick" },
			ValueImages = { Kill = "skull", Kick = "user-x" },
			Default = { "Kick" },
			Multi = true,
			Callback = function()
				if U66.BlobLoopApply and U66.BlobLoopApply.Value then
					U66.BlobLoopApply:SetValue(false)
					task.wait(0.1)
					U66.BlobLoopApply:SetValue(true)
				end
			end,
		})

		L0_350:AddDivider()
		local L0_351 = L0_350:AddDependencyBox()
		L0_351:AddDivider("Settings")

		L0_351:AddDropdown("BlobKickType", {
			Text = "Kick Type",
			Values = { "Grab" },
			ValueImages = { Grab = "hand" },
			Default = 1,
			Callback = function()
			end,
		})

		L0_351:AddSlider("BlobKickX", {
			Text = "X",
			Default = 0,
			Min = -10,
			Max = 10,
			Rounding = 1,
			Compact = true,
			Callback = function()
			end,
		})

		L0_351:AddSlider("BlobKickY", {
			Text = "Y",
			Default = 25,
			Min = -40,
			Max = 40,
			Rounding = 1,
			Compact = true,
			Callback = function()
			end,
		})

		L0_351:AddSlider("BlobKickZ", {
			Text = "Z",
			Default = 0,
			Min = -10,
			Max = 10,
			Rounding = 1,
			Compact = true,
			Callback = function()
			end,
		})

		L0_351:SetupDependencies({ { U65.BlobMethodType, "Kick" } })
	end

	local U526
	U526 = game:GetService("UserInputService")
	local U527, U528, U529
	local L0_352 = U73:FindFirstChild("GrabEvents") or U73:WaitForChild("GrabEvents", 5)

	if L0_352 then
		U527 = L0_352:FindFirstChild("CreateGrabLine") or L0_352:WaitForChild("CreateGrabLine", 3)
	else
		U527 = L0_352
	end

	if L0_352 then
		U528 = L0_352:FindFirstChild("SetNetworkOwner") or L0_352:WaitForChild("SetNetworkOwner", 3)
	else
		U528 = L0_352
	end

	if L0_352 then
		U529 = L0_352:FindFirstChild("DestroyGrabLine") or L0_352:WaitForChild("DestroyGrabLine", 3)
	else
		U529 = L0_352
	end

	local U530, L0_353

	do
		local U531 = nil
		local U532 = nil
		local U533 = nil
		local U534 = nil
		local U535 = nil
		local U536 = nil
		local U537 = nil
		local U538 = nil
		local U539 = nil
		local U540 = nil
		local U541 = nil
		U530 = 11

		local function F_000783(A783_1)
			if U531 then
				U531:Disconnect()
				U531 = nil
			end

			if not A783_1 then
				return
			end

			U531 = U71.ChildAdded:Connect(function(A784_1)
				if A784_1.Name ~= "GrabParts" then
					return
				end
				local L784_1 = A784_1:FindFirstChild("GrabPart")
				L784_1 = L784_1 and L784_1:FindFirstChild("WeldConstraint")
				L784_1 = L784_1 and L784_1.Part1
				if not L784_1 then
					return
				end
				local U542 = Instance.new("BodyVelocity", L784_1)

				A784_1:GetPropertyChangedSignal("Parent"):Connect(function()
					if A784_1.Parent then
						return
					end
					local L785_1 = Enum.UserInputType.MouseButton2

					if U526:GetLastInputType() == L785_1 then
						U542.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
						U542.Velocity = U71.CurrentCamera.CFrame.LookVector * (U65.StrengthPower and U65.StrengthPower.Value or 80000)
						U72:AddItem(U542, 1)
					else
						U542:Destroy()
					end
				end)
			end)
		end

		local function F_000786()
			local L786_1 = U71:FindFirstChild("GrabParts")
			L786_1 = L786_1 and L786_1:FindFirstChild("GrabPart")
			L786_1 = L786_1 and L786_1:FindFirstChildOfClass("WeldConstraint")
			L786_1 = L786_1 and L786_1.Part1
			return L786_1 and L786_1:FindFirstAncestorOfClass("Model")
		end

		local U557 = {
			["Super Strength"] = F_000783,
			["Noclip Grab"] = function(A787_1)
				if U532 then
					U532:Disconnect()
					U532 = nil
				end

				if not A787_1 then
					local L787_1 = F_000786()

					if L787_1 then
						for I288, I289 in ipairs(L787_1:GetDescendants()) do
							if I289:IsA("BasePart") and not I289.Anchored then
								I289.CanCollide = true
							end
						end
					end

					return
				end

				U532 = U69.Heartbeat:Connect(function()
					local L788_1 = F_000786()
					if not L788_1 then
						return
					end

					for I290, I291 in ipairs(L788_1:GetDescendants()) do
						if I291:IsA("BasePart") and not I291.Anchored then
							I291.CanCollide = false
						end
					end
				end)
			end,
			["Ragdoll Grab"] = function(A789_1)
				if U534 then
					U534:Disconnect()
					U534 = nil
				end

				if U533 and U533.Parent then
					pcall(function()
						local L790_1 = U73:FindFirstChild("MenuToys") and U73.MenuToys:FindFirstChild("DestroyToyRemoteEvent")

						if L790_1 then
							L790_1:FireServer(U533)
						end
					end)

					U533 = nil
				end

				if not A789_1 then
					return
				end
				local L789_1 = U68.Character
				local U543 = L789_1 and L789_1:FindFirstChild("HumanoidRootPart")
				if not U543 then
					return
				end

				task.spawn(function()
					local L791_1 = U90("PalletLightBrown", U543.CFrame * CFrame.new(5, 5, 20))
					if not L791_1 then
						return
					end
					U533 = L791_1
					local U544 = L791_1:WaitForChild("SoundPart", 2)
					if not U544 then
						return
					end
					L791_1.Name = "ragdoll"

					if U528 then
						for I292 = 1, 10 do
							U528:FireServer(U544, U543.CFrame)
							task.wait(0.05)
							if not U544:FindFirstChild("PartOwner") then
								continue
							end
							break
						end
					end

					U544.AssemblyLinearVelocity = Vector3.new(0, 10000, 0)

					for I293, I294 in pairs(L791_1:GetDescendants()) do
						if I294:IsA("BasePart") then
							I294.Transparency = 1
							I294.CanCollide = false
						end
					end

					U534 = U71.ChildAdded:Connect(function(A792_1)
						if A792_1.Name ~= "GrabParts" then
							return
						end
						local L792_1 = A792_1:FindFirstChild("GrabPart") or A792_1:WaitForChild("GrabPart", 3)
						if not L792_1 then
							return
						end
						local L792_2 = L792_1:FindFirstChildOfClass("WeldConstraint")
						L792_2 = L792_2 and L792_2.Part1

						while U71:FindFirstChild("GrabParts") and task.wait() do
							if L792_2 and L792_2.Parent and L792_2.Parent:FindFirstChild("HumanoidRootPart") and L792_2.Parent:FindFirstChild("Humanoid") then
								local L792_3 = L792_2.Parent.Humanoid:FindFirstChild("Ragdolled")

								if not L792_3 or L792_3.Value == false then
									U544.AssemblyLinearVelocity = Vector3.new(0, 100, 0)
									U544.CFrame = L792_2.Parent.HumanoidRootPart.CFrame
									task.wait(0.05)
									U544.CFrame = CFrame.new(0, 1e9, 0)
								end
							end
						end
					end)
				end)
			end,
			["Kill Grab"] = function(A793_1)
				if U535 then
					U535:Disconnect()
					U535 = nil
				end

				if not A793_1 then
					return
				end

				U535 = U71.ChildAdded:Connect(function(A794_1)
					if not (A794_1:IsA("Model") and A794_1.Name == "GrabParts") then
						return
					end
					task.wait(0.05)
					local L794_1 = A794_1:FindFirstChild("GrabPart")
					L794_1 = L794_1 and L794_1:FindFirstChild("WeldConstraint")
					local U545 = L794_1 and L794_1.Part1
					if not U545 or U68.Character and U545:IsDescendantOf(U68.Character) then
						return
					end
					local U546 = U545.Parent and U545.Parent:FindFirstChildOfClass("Humanoid")

					if U546 then
						pcall(function()
							U546.Health = 0
							U545.Parent:BreakJoints()
						end)
					end
				end)
			end,
			["Kick Grab"] = function(A796_1)
				if U536 then
					pcall(function()
						task.cancel(U536)
					end)

					U536 = nil
				end

				if not A796_1 then
					return
				end

				U536 = task.spawn(function()
					while true do
						local L798_1 = U71:FindFirstChild("GrabParts")

						if L798_1 then
							local L798_2 = L798_1:FindFirstChild("GrabPart")
							L798_2 = L798_2 and L798_2:FindFirstChildOfClass("WeldConstraint")
							L798_2 = L798_2 and L798_2.Part1

							if L798_2 then
								local L798_3 = nil

								for I295, I296 in ipairs(U67:GetPlayers()) do
									if I296 ~= U68 and I296.Character and L798_2:IsDescendantOf(I296.Character) then
										L798_3 = I296
										break
									end
									L798_3 = nil
								end

								while U71:FindFirstChild("GrabParts") and L798_3 and L798_3.Character do
									local U547 = L798_3.Character:FindFirstChild("HumanoidRootPart")
									local U548 = L798_3.Character:FindFirstChild("Head")
									local U549 = U68.Character and U68.Character:FindFirstChild("HumanoidRootPart")

									if U547 and U549 and U548 and U528 and U529 then
										pcall(function()
											U528:FireServer(U547, CFrame.lookAt(U549.Position, U547.Position))
										end)

										task.wait()

										pcall(function()
											U529:FireServer(U548)
										end)
									end

									task.wait()
								end
							end
						end

						task.wait(0.05)
					end
				end)
			end,
			["Loop Grab"] = function(A801_1)
				if U537 then
					pcall(function()
						task.cancel(U537)
					end)

					U537 = nil
				end

				if not A801_1 then
					return
				end

				U537 = task.spawn(function()
					while true do
						local L803_1 = U71:FindFirstChild("GrabParts")

						if L803_1 then
							local L803_2 = L803_1:FindFirstChild("GrabPart")
							L803_2 = L803_2 and L803_2:FindFirstChildOfClass("WeldConstraint")
							local U550 = L803_2 and L803_2.Part1

							if U550 and U528 then
								local L803_3 = nil

								for I297, I298 in ipairs(U67:GetPlayers()) do
									if I298 ~= U68 and I298.Character and U550:IsDescendantOf(I298.Character) then
										L803_3 = I298
										break
									end
									L803_3 = nil
								end

								while U71:FindFirstChild("GrabParts") do
									local U551 = U68.Character and U68.Character:FindFirstChild("HumanoidRootPart")

									if L803_3 and L803_3.Character then
										local U552 = L803_3.Character:FindFirstChild("HumanoidRootPart")

										if U552 and U551 then
											pcall(function()
												U528:FireServer(U552, CFrame.lookAt(U551.Position, U552.Position))
											end)
										end
									elseif U551 and U550.Parent then
										pcall(function()
											U528:FireServer(U550, CFrame.lookAt(U551.Position, U550.Position))
										end)
									end

									task.wait()
								end
							end
						end

						task.wait(0.05)
					end
				end)
			end,
			["Massless Grab"] = function(A806_1)
				if U538 then
					U538:Disconnect()
					U538 = nil
				end

				if not A806_1 then
					return
				end

				U538 = U71.ChildAdded:Connect(function(A807_1)
					if A807_1.Name ~= "GrabParts" then
						return
					end
					local L807_1 = A807_1:FindFirstChild("DragPart") or A807_1:WaitForChild("DragPart", 1)
					if not L807_1 then
						return
					end
					local U553 = L807_1:FindFirstChild("AlignPosition") or L807_1:WaitForChild("AlignPosition", 1)
					local U554 = L807_1:FindFirstChild("AlignOrientation") or L807_1:WaitForChild("AlignOrientation", 1)

					if U553 and U554 then
						pcall(function()
							local L808_1 = U65.MasslessPower and U65.MasslessPower.Value or 500
							U553.Responsiveness = L808_1
							U553.MaxForce = math.huge
							U553.MaxVelocity = math.huge
							U554.Responsiveness = L808_1
							U554.MaxTorque = math.huge
						end)
					end
				end)
			end,
			["Invisible Grab"] = function(A809_1)
				if U539 then
					pcall(function()
						task.cancel(U539)
					end)

					U539 = nil
				end

				if not A809_1 then
					return
				end

				U539 = task.spawn(function()
					while true do
						if U527 then
							pcall(function()
								U527:FireServer()
							end)
						end

						task.wait(0.05)
					end
				end)
			end,
			["Line Extender"] = function(A813_1)
				if U540 then
					U540:Disconnect()
					U540 = nil
				end

				if U541 then
					U541:Disconnect()
					U541 = nil
				end

				U530 = U65.LineExtendDistance and U65.LineExtendDistance.Value or 40
				if not A813_1 then
					return
				end

				U540 = U526.InputChanged:Connect(function(A814_1)
					if A814_1.UserInputType == Enum.UserInputType.MouseWheel then
						local L814_1 = U65.ScrollSpeed and U65.ScrollSpeed.Value or 2
						local L814_2 = U65.LineExtendDistance and U65.LineExtendDistance.Value or U530

						if A814_1.Position.Z > 0 then
							U530 = math.min(L814_2, U530 + L814_1)
						elseif A814_1.Position.Z < 0 then
							U530 = math.max(1, U530 - L814_1)
						end
					end
				end)

				U541 = U71.ChildAdded:Connect(function(A815_1)
					if A815_1.Name ~= "GrabParts" or not A815_1:IsA("Model") then
						return
					end
					local L815_1 = A815_1:WaitForChild("DragPart", 2)
					if not L815_1 then
						return
					end
					local U555 = L815_1:Clone()
					U555.Name = "DragPart1"
					local L815_2 = U555:FindFirstChild("DragAttach")

					if U555:FindFirstChild("AlignPosition") and L815_2 then
						U555.AlignPosition.Attachment1 = L815_2
					end

					U555.Parent = A815_1
					local U556 = U71.CurrentCamera

					if U555:FindFirstChild("AlignOrientation") then
						U555.AlignOrientation.Enabled = false
					end

					if L815_1:FindFirstChild("AlignPosition") then
						L815_1.AlignPosition.Enabled = false
					end

					task.spawn(function()
						while true do
							local L816_1 = A815_1.Parent
							local L816_2

							if L816_1 then
								L816_2 = U66.GrabToggle and U66.GrabToggle.Value
							else
								L816_2 = L816_1
							end

							if L816_2 then
								U555.Position = U556.CFrame.Position + U556.CFrame.LookVector * (U66.InfiniteDistance and U66.InfiniteDistance.Value and 9999 or U65.LineExtendDistance and U65.LineExtendDistance.Value or U530)
								U69.RenderStepped:Wait()
								continue
							end

							break
						end
					end)
				end)
			end,
		}

		local function F_000817()
			local L817_1 = U66.GrabToggle and U66.GrabToggle.Value
			local L817_2 = U65.GrabMode and U65.GrabMode.Value or {}

			for I299, I300 in pairs(U557) do
				local L817_3

				if type(L817_2) == "table" then
					L817_3 = L817_2[I299] == true
				else
					L817_3 = false

					if type(L817_2) == "string" then
						L817_3 = L817_2 == I299
					end
				end

				L817_3 = L817_1 and L817_3
				I300(L817_3)
			end
		end

		local L0_354 = U92.Grabs:AddGroupbox({
			Side = 1,
			Name = "<b>Grabs</b>",
			IconName = "hand",
			Description = "Line power",
			MaxPopOutHeight = 600,
			PopOutWidth = 250,
		}):AddTabbox({ MaxPopOutHeight = 600 })

		local L0_355 = L0_354:AddTab("<b>Settings</b>", "settings")
		L0_353 = L0_354:AddTab("<b>Gamepass</b>", "badge-dollar-sign")

		L0_355:AddDropdown("GrabMode", {
			Text = "Grab Mode",
			Values = {
				"Super Strength",
				"Noclip Grab",
				"Ragdoll Grab",
				"Kill Grab",
				"Kick Grab",
				"Loop Grab",
				"Massless Grab",
				"Invisible Grab",
				"Line Extender",
			},
			ValueImages = {
				["Super Strength"] = "zap",
				["Noclip Grab"] = "ghost",
				["Ragdoll Grab"] = "activity",
				["Kill Grab"] = "skull",
				["Kick Grab"] = "user-x",
				["Loop Grab"] = "repeat",
				["Massless Grab"] = "feather",
				["Invisible Grab"] = "eye-off",
				["Line Extender"] = "move-diagonal",
			},
			Default = { "Super Strength" },
			AllowNull = true,
			Multi = true,
			Callback = function()
				F_000817()
			end,
		})

		L0_355:AddToggle("GrabToggle", {
			Text = "Toggle",
			Default = false,
			Callback = function()
				F_000817()
			end,
		}):AddKeyPicker("GrabToggleKey", {
			Default = "None",
			Mode = "Toggle",
			SyncToggleState = true,
			Text = "Grab Keybind",
			Callback = function()
			end,
		})

		L0_355:AddDivider("Grab Settings")

		L0_355:AddSlider("MasslessPower", {
			Text = "Maseless Power",
			Default = 500,
			Min = 0,
			Max = 2000,
			Rounding = 0,
			Compact = true,
			Callback = function()
			end,
		})

		L0_355:AddDivider()

		L0_355:AddToggle("InfiniteDistance", {
			Text = "Infinite Distance",
			Default = false,
			Callback = function()
			end,
		})

		L0_355:AddSlider("StrengthPower", {
			Text = "Strength Power",
			Default = 80000,
			Min = 0,
			Max = 100000,
			Rounding = 0,
			Compact = true,
			Callback = function()
			end,
		})

		L0_355:AddSlider("LineExtendDistance", {
			Text = "Line Extend Distance",
			Default = 40,
			Min = 1,
			Max = 1000,
			Rounding = 0,
			Compact = true,
			Callback = function(A824_1)
				U530 = A824_1
			end,
		})

		L0_355:AddSlider("ScrollSpeed", {
			Text = "Scroll Speed",
			Default = 2,
			Min = 1,
			Max = 100,
			Rounding = 0,
			Compact = true,
			Callback = function()
			end,
		})
	end

	do
		local U558 = false
		local U559 = 25

		local function F_000826(A826_1)
			U559 = A826_1

			pcall(function()
				local L827_1 = ColorSequenceKeypoint.new
				local L827_2 = Color3.fromRGB
				U73.DataEvents.UpdateLineColorsEvent:FireServer(ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)), L827_1(1, L827_2(0, 255, 195)) }))
			end)

			pcall(function()
				local L828_1 = U73:FindFirstChild("GamepassEvents") and U73.GamepassEvents:FindFirstChild("FurtherReachBoughtNotifier")

				if L828_1 and getconnections then
					for I301, I302 in pairs(getconnections(L828_1.OnClientEvent)) do
						if debug and debug.getupvalues and debug.setupvalue and I302.Function then
							for I303 in debug.getupvalues(I302.Function) do
								debug.setupvalue(I302.Function, I303, A826_1)
							end
						end
					end
				end
			end)
		end

		L0_353:AddToggle("GrabReachToggle", {
			Text = "Further Reach",
			Default = false,
			Callback = function(A829_1)
				U558 = A829_1

				if A829_1 then
					F_000826(U559)
				else
					F_000826(25)
				end
			end,
		})

		L0_353:AddSlider("GrabReachSlider", {
			Text = "Reach Distance",
			Default = 25,
			Min = 25,
			Max = 45,
			Rounding = 0,
			Compact = true,
			Callback = function(A830_1)
				U559 = A830_1

				if U558 then
					F_000826(A830_1)
				end
			end,
		})
	end

	local U560
	U560 = "Heart"
	local U561
	U561 = false
	local U562, U563

	do
		local K20 = true
		U562 = Color3.fromRGB(255, 255, 255)
		U563 = Color3.fromRGB(255, 255, 255)
		local U564 = false
		local U565 = 0
		local K21 = 0.5
		local U566 = nil
		local U567 = nil

		local U568 = {
			Heart = "rbxassetid://89015294175898",
			["Heart-Outline"] = "rbxassetid://125373934805238",
			["Non-Gamepass"] = "rbxassetid://8933346550",
			Gamepass = "rbxassetid://8933355899",
			Chain = "rbxassetid://81358145120405",
			["Chain 2"] = "rbxassetid://132910145874066",
			["Chain 3"] = "rbxassetid://128466395060514",
			["Chain 4"] = "rbxassetid://73368670987191",
			Rope = "rbxassetid://78999022056924",
			Spring = "rbxassetid://18837732116",
			Circle = "rbxassetid://5367817750",
			["Circle-Outline"] = "rbxassetid://12201347372",
			Triangle = "rbxassetid://4704920160",
			["Triangle-Outline"] = "rbxassetid://94666748694025",
			Square = "rbxassetid://15007588972",
			["Square-Outline"] = "rbxassetid://15420927706",
			Moon = "rbxassetid://9013498676",
			Dots = "rbxassetid://9169659357",
			Bubble = "rbxassetid://1249690853",
			Star = "rbxassetid://5639840603",
			Robux = "rbxassetid://11560341132",
			["Roblox-Logo"] = "rbxassetid://12348119032",
			Brick = "rbxassetid://4430903072",
			Studs = "rbxassetid://15539356451",
			Fire = "rbxassetid://18654087326",
			Lazar = "rbxassetid://8922958725",
			["Spider-Web"] = "rbxassetid://123815660139244",
			Smoke = "rbxassetid://12900071392",
			["Audio-Visualiser"] = "rbxassetid://81588563590679",
			Pulse = "rbxassetid://82163767314193",
			Arrow = "rbxassetid://9006027964",
			["Arrow 2"] = "rbxassetid://10249261576",
			["Low Quality"] = "",
		}

		local function F_000831()
			local L831_1 = workspace:FindFirstChild("GrabParts")
			return L831_1 and L831_1:FindFirstChild("BeamPart")
		end

		local function F_000832()
			local L832_1 = F_000831()
			if not L832_1 then
				return
			end
			local L832_2 = L832_1:FindFirstChild("GrabBeam")
			if not L832_2 or not L832_2:IsA("Beam") then
				return
			end

			if U561 then
				L832_2.Texture = U568[U560] or ""
			end

			if not U564 then
				if K20 then
					L832_2.Color = ColorSequence.new(U562, U563)
				end
			end
		end

		local function F_000833(A833_1)
			U564 = A833_1

			if U567 then
				U567:Disconnect()
				U567 = nil
			end

			if not A833_1 then
				F_000832()
				return
			end

			U567 = U69.Heartbeat:Connect(function(A834_1)
				U565 = (U565 + A834_1 * K21) % 1
				local L834_1 = Color3.fromHSV(U565, 1, 1)
				local L834_2 = F_000831()
				if not L834_2 then
					return
				end
				local L834_3 = L834_2:FindFirstChild("GrabBeam")

				if L834_3 and L834_3:IsA("Beam") then
					L834_3.Color = ColorSequence.new(L834_1, L834_1)
				end
			end)
		end

		local function F_000835()
			if U566 then
				return
			end

			U566 = U69.Heartbeat:Connect(function()
				if U561 or true then
					F_000832()
				end
			end)
		end

		workspace.DescendantAdded:Connect(function(A837_1)
			if A837_1:IsA("Beam") and A837_1.Name == "GrabBeam" then
				task.defer(F_000832)
			elseif A837_1.Name == "BeamPart" or A837_1.Name == "GrabPart" then
				task.defer(F_000832)
			end
		end)

		local L0_356 = U92.Grabs:AddGroupbox({
			Side = 2,
			Name = "<b>Line</b>",
			IconName = "link",
			Description = "Custom beam",
			MaxPopOutHeight = 600,
			PopOutWidth = 250,
		})

		L0_356:AddDropdown("TextureDropdown", {
			Text = "Decal",
			Values = {
				"Heart",
				"Heart-Outline",
				"Non-Gamepass",
				"Gamepass",
				"Chain",
				"Chain 2",
				"Chain 3",
				"Chain 4",
				"Rope",
				"Spring",
				"Circle",
				"Circle-Outline",
				"Triangle",
				"Triangle-Outline",
				"Square",
				"Square-Outline",
				"Moon",
				"Dots",
				"Bubble",
				"Star",
				"Robux",
				"Roblox-Logo",
				"Brick",
				"Studs",
				"Fire",
				"Lazar",
				"Spider-Web",
				"Smoke",
				"Audio-Visualiser",
				"Pulse",
				"Arrow",
				"Arrow 2",
				"Low Quality",
			},
			ValueImages = U568,
			Default = "Heart",
			Callback = function(A838_1)
				U560 = A838_1
				F_000835()
				F_000832()
			end,
		})

		L0_356:AddToggle("UseSelectedTexture", {
			Text = "Enable",
			Default = false,
			Callback = function(A839_1)
				U561 = A839_1
				F_000835()
				F_000832()
			end,
		})

		L0_356:AddDivider("Settings")

		L0_356:AddLabel("Start/End"):AddColorPicker("BeamColor0", {
			Default = Color3.fromRGB(255, 255, 255),
			Callback = function(A840_1)
				U562 = A840_1
				F_000832()
			end,
		}):AddColorPicker("BeamColor1", {
			Default = Color3.fromRGB(255, 255, 255),
			Callback = function(A841_1)
				U563 = A841_1
				F_000832()
			end,
		})

		L0_356:AddDivider()

		L0_356:AddToggle("RainbowBeam", {
			Text = "Rainbow",
			Default = false,
			Callback = function(A842_1)
				F_000833(A842_1)
			end,
		})
	end

	do
		local U569 = {}
		local U570 = {}

		local function F_000843(A843_1, A843_2, A843_3)
			local L843_1 = Instance.new("BodyPosition")
			L843_1.P = 15000
			L843_1.D = 200
			L843_1.MaxForce = Vector3.new(5000000, 5000000, 5000000)
			L843_1.Position = A843_2
			L843_1.Parent = A843_1
			local L843_2 = Instance.new("BodyGyro")
			L843_2.P = 15000
			L843_2.D = 200
			L843_2.MaxTorque = Vector3.new(5000000, 5000000, 5000000)
			L843_2.CFrame = A843_3
			L843_2.Parent = A843_1
		end

		local function F_000844(A844_1)
			local L844_1 = Instance.new("Highlight")
			L844_1.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
			L844_1.FillColor = Color3.fromRGB(90, 0, 0)
			L844_1.FillTransparency = 0.75
			L844_1.Name = "GrabAnchorHL"
			L844_1.OutlineColor = Color3.fromRGB(130, 0, 0)
			L844_1.OutlineTransparency = 0
			L844_1.Parent = A844_1
			return L844_1
		end

		local function F_000845()
			for I304, I305 in ipairs(U569) do
				if I305 then
					local L845_1 = I305:FindFirstChild("BodyPosition")
					local L845_2 = I305:FindFirstChild("BodyGyro")
					local L845_3 = I305.Parent and I305.Parent:FindFirstChild("GrabAnchorHL")

					if L845_1 then
						L845_1:Destroy()
					end

					if L845_2 then
						L845_2:Destroy()
					end

					if L845_3 then
						L845_3:Destroy()
					end
				end
			end

			for I306, I307 in ipairs(U570) do
				if I307 and I307.Connected then
					I307:Disconnect()
				end
			end

			table.clear(U570)
			table.clear(U569)
		end

		local function F_000846()
			local L846_1 = U71:FindFirstChild("GrabParts")
			local L846_2 = L846_1 and L846_1:FindFirstChild("GrabPart")
			L846_2 = L846_2 and L846_2:FindFirstChild("WeldConstraint")
			L846_2 = L846_2 and L846_2.Part1
			local L846_3 = L846_2 and L846_2.Parent and (L846_2.Parent.PrimaryPart or L846_2)
			if not L846_3 then
				U75({ Title = "Anchor System", Description = "Grab an object first!" })
				return
			end

			if U528 then
				U528:FireServer(L846_3, L846_3.CFrame)
			end

			for I308, I309 in ipairs(L846_3:GetChildren()) do
				if I309:IsA("BodyPosition") or I309:IsA("BodyGyro") then
					I309:Destroy()
				end
			end

			F_000844(L846_3.Parent or L846_3)
			table.insert(U569, L846_3)
			F_000843(L846_3, L846_3.Position, L846_3.CFrame)
			U75({ Title = "Anchor System", Description = "Anchored: " .. L846_3.Name })
		end

		local L0_357 = U92.Grabs:AddGroupbox({
			Side = 2,
			Name = "<b>Anchor</b>",
			IconName = "anchor",
			Description = "Lock unlock",
			MaxPopOutHeight = 600,
			PopOutWidth = 250,
		})

		L0_357:AddDivider("Anchor Settings")

		local U571 = L0_357:AddButton({
			Text = "Anchor Grabbing Part",
			Func = function()
				F_000846()
			end,
			DoubleClick = false,
		})

		pcall(function()
			U571:AddKeyPicker("AnchorBtnKey", {
				Default = "None",
				Mode = "Press",
				Text = "Anchor Key",
				Callback = function()
					F_000846()
				end,
			})
		end)

		local U572 = L0_357:AddButton({
			Text = "UnAnchor",
			Func = function()
				F_000845()
				U75({ Title = "Anchor System", Description = "All anchored parts released" })
			end,
			DoubleClick = false,
		})

		pcall(function()
			U572:AddKeyPicker("UnAnchorBtnKey", {
				Default = "None",
				Mode = "Press",
				Text = "UnAnchor Key",
				Callback = function()
					F_000845()
					U75({ Title = "Anchor System", Description = "All anchored parts released" })
				end,
			})
		end)
	end

	do
		local L0_358 = U92.Grabs:AddGroupbox({
			Side = 2,
			Name = "<b>Auras</b>",
			IconName = "flame",
			Description = "Aura Types",
			MaxPopOutHeight = 600,
			PopOutWidth = 250,
		}):AddTabbox({ MaxPopOutHeight = 600 })

		local L0_359 = L0_358:AddTab("<b>Aura</b>", "maximize-2")

		L0_359:AddDropdown("AuraMethod", {
			Text = "Method",
			Values = { "Death Aura", "Fling Aura" },
			ValueImages = { ["Death Aura"] = "skull", ["Fling Aura"] = "wind" },
			Default = "Death Aura",
			Callback = function()
				syncAura()
			end,
		})

		L0_359:AddDivider("Aura Settings")

		L0_359:AddToggle("AuraApplyMethod", {
			Text = "Apply Method",
			Default = false,
			Callback = function()
				syncAura()
			end,
		}):AddKeyPicker("AuraApplyKey", {
			Default = "None",
			Mode = "Toggle",
			SyncToggleState = true,
			Text = "Apply Method Keybind",
			Callback = function()
			end,
		})

		L0_359:AddSlider("AuraRange", {
			Text = "Range",
			Default = 15,
			Min = 5,
			Max = 25,
			Rounding = 0,
			Compact = true,
			Callback = function()
			end,
		})

		local L0_360 = L0_358:AddTab("<b>Toy Aura</b>", "blocks")

		L0_360:AddDropdown("ToyAuraMethod", {
			Text = "Method",
			Values = { "Fling" },
			ValueImages = { Fling = "wind" },
			Default = "Fling",
			Callback = function()
			end,
		})

		L0_360:AddDivider("Aura Settings")

		L0_360:AddToggle("ToyAuraApplyMethod", {
			Text = "Apply Method",
			Default = false,
			Callback = function(A858_1)
				if A858_1 then
					startFlingToyAura()
				else
					stopFlingToyAura()
				end
			end,
		}):AddKeyPicker("ToyAuraApplyKey", {
			Default = "None",
			Mode = "Toggle",
			SyncToggleState = true,
			Text = "Apply Method Keybind",
			Callback = function()
			end,
		})

		L0_360:AddSlider("ToyAuraRange", {
			Text = "Range",
			Default = 15,
			Min = 5,
			Max = 25,
			Rounding = 0,
			Compact = true,
			Callback = function()
			end,
		})

		L0_360:AddSlider("ToyFlingPower", {
			Text = "Fling Power",
			Default = 400,
			Min = 400,
			Max = 12000,
			Rounding = 0,
			Compact = true,
			Callback = function(A861_1)
				toyFlingPower = A861_1
			end,
		})
	end

	local L0_361

	L0_361 = U92.Grabs:AddGroupbox({
		Side = 1,
		Name = "<b>Aim</b>",
		IconName = "align-end-horizontal",
		Description = "Aimbots",
		MaxPopOutHeight = 600,
		PopOutWidth = 250,
	}):AddTabbox({ MaxPopOutHeight = 600 })

	local L0_362 = L0_361:AddTab("<b>Aimbot</b>", "maximize")

	L0_362:AddToggle("ToggleAimbot", {
		Text = "Toggle Aimbot",
		Default = false,
		Callback = function(A862_1)
			if not A862_1 then
				_aimbotPlayerTarget = nil
			end
		end,
	}):AddKeyPicker("AimbotKey", {
		Default = "None",
		Mode = "Toggle",
		SyncToggleState = true,
		Text = "Toggle Aimbot Keybind",
		Callback = function()
		end,
	})

	L0_362:AddDivider("Aimbot Settings")

	L0_362:AddDropdown("AimbotTargets", {
		Text = "Targets",
		Values = U87(),
		Default = 1,
		AllowNull = true,
		Multi = true,
		Searchable = true,
		Callback = function()
		end,
	})

	L0_362:AddToggle("AimbotTargetEveryone", {
		Text = "Target Everyone",
		Default = false,
		Callback = function()
		end,
	})

	L0_362:AddDivider()

	L0_362:AddDropdown("AimbotAimAt", {
		Text = "Aim At",
		Values = {
			"Closest Part",
			"Random Part",
			"Head",
			"Torso",
			"Right Arm",
			"Right Leg",
			"Left Arm",
			"Left Leg",
		},
		ValueImages = {
			["Closest Part"] = "crosshair",
			["Random Part"] = "shuffle",
			Head = "circle-user",
			Torso = "shirt",
			["Right Arm"] = "hand",
			["Right Leg"] = "footprints",
			["Left Arm"] = "hand",
			["Left Leg"] = "footprints",
		},
		Default = 1,
		Callback = function()
		end,
	})

	L0_362:AddDropdown("AimbotMode", {
		Text = "Mode",
		Values = { "Normal", "ThroughObjects" },
		ValueImages = { Normal = "target", ThroughObjects = "layers" },
		Default = 1,
		Callback = function()
		end,
	})

	L0_362:AddSlider("AimbotDistance", {
		Text = "Distance",
		Default = 30,
		Min = 0,
		Max = 2000,
		Rounding = 0,
		Compact = true,
		Suffix = " studs",
		Callback = function()
		end,
	})

	L0_362:AddSlider("AimbotFov", {
		Text = "Aimbot Fov",
		Default = 90,
		Min = 1,
		Max = 360,
		Rounding = 0,
		Compact = true,
		Callback = function()
		end,
	})

	L0_362:AddToggle("ShowAimbotFovCircle", {
		Text = "Show Fov Circle",
		Default = false,
		Callback = function()
		end,
	})

	L0_362:AddDivider("Fov Circle Settings")

	L0_362:AddLabel("Circle color"):AddColorPicker("AimbotCircleColor", {
		Default = Color3.new(1, 1, 1),
		Title = "Circle color",
		Callback = function()
		end,
	})

	L0_362:AddSlider("AimbotCircleTransparency", {
		Text = "Transparency",
		Default = 1,
		Min = 0,
		Max = 1,
		Rounding = 2,
		Compact = true,
		Callback = function()
		end,
	})

	do
		local L0_363 = L0_361:AddTab("<b>Object Lock</b>", "chart-no-axes-gantt")

		L0_363:AddDropdown("SelectObject", {
			Text = "Select Object",
			Values = { "Closest Object", "Spawned In Toys", "PalletLightBrown" },
			ValueImages = {
				["Closest Object"] = "crosshair",
				["Spawned In Toys"] = "package",
				PalletLightBrown = "box",
			},
			Default = { "Closest Object", "Spawned In Toys", "PalletLightBrown" },
			AllowNull = true,
			Multi = true,
			Callback = function()
			end,
		})

		local L0_364 = L0_363:AddDependencyBox()

		L0_364:AddToggle("WhitelistOwnPallet", {
			Text = "Whitelist Own Pallet",
			Default = false,
			Callback = function()
			end,
		})

		L0_364:SetupDependencies({ { U65.SelectObject, "PalletLightBrown" } })

		L0_363:AddToggle("ToggleObjectLock", {
			Text = "Toggle Object Lock",
			Default = false,
			Callback = function()
			end,
		}):AddKeyPicker("ObjectLockKey", {
			Default = "None",
			Mode = "Toggle",
			SyncToggleState = true,
			Text = "Toggle Object Lock Keybind",
			Callback = function()
			end,
		})

		L0_363:AddDivider("Settings")

		L0_363:AddSlider("ObjectLockDistance", {
			Text = "Distance",
			Default = 30,
			Min = 1,
			Max = 80,
			Rounding = 0,
			Compact = true,
			Callback = function()
			end,
		})

		L0_363:AddSlider("ObjectLockFov", {
			Text = "Aimbot Fov",
			Default = 90,
			Min = 1,
			Max = 360,
			Rounding = 0,
			Compact = true,
			Callback = function()
			end,
		})

		L0_363:AddToggle("ShowObjectLockFovCircle", {
			Text = "Show Fov Circle",
			Default = false,
			Callback = function()
			end,
		})

		L0_363:AddDivider("Fov Circle Settings")

		L0_363:AddLabel("Circle color"):AddColorPicker("ObjectLockCircleColor", {
			Default = Color3.new(1, 1, 1),
			Title = "Circle color",
			Callback = function()
			end,
		})

		L0_363:AddSlider("ObjectLockCircleTransparency", {
			Text = "Transparency",
			Default = 1,
			Min = 0,
			Max = 1,
			Rounding = 2,
			Compact = true,
			Callback = function()
			end,
		})
	end

	local U573, U574, U575
	local L0_365 = L0_361:AddTab("<b>Silent Aim</b>", "scan")
	U573 = false
	U574 = false
	U575 = false

	L0_365:AddToggle("ToggleSilentAim", {
		Text = "Toggle Silent Aim",
		Default = false,
		Callback = function(A882_1)
			if U574 then
				return
			end
			U573 = A882_1

			if not A882_1 then
				U575 = false
				_playerSilentTarget = nil
				_playerSilentPlayer = nil
			end
		end,
	}):AddKeyPicker("SilentAimKey", {
		Default = "None",
		Mode = "Toggle",
		SyncToggleState = true,
		Text = "Toggle Silent Aim Keybind",
		Callback = function()
		end,
	})

	L0_365:AddDivider("Silent Aim Settings")

	L0_365:AddDropdown("SilentAimTargets", {
		Text = "Targets",
		Values = U87(),
		Default = 1,
		AllowNull = true,
		Multi = true,
		Searchable = true,
		Callback = function()
		end,
	})

	L0_365:AddToggle("SilentAimTargetEveryone", {
		Text = "Target Everyone",
		Default = true,
		Callback = function()
		end,
	})

	L0_365:AddDropdown("SilentAimMode", {
		Text = "Mode",
		Values = { "Normal", "ThroughObjects" },
		ValueImages = { Normal = "target", ThroughObjects = "layers" },
		Default = 1,
		Callback = function()
			_playerSilentTarget = nil
			_playerSilentPlayer = nil
		end,
	})

	L0_365:AddSlider("SilentAimDistance", {
		Text = "Distance",
		Default = 45,
		Min = 5,
		Max = 80,
		Rounding = 0,
		Compact = true,
		Callback = function()
		end,
	})

	do
		local U576 = nil
		local U577 = nil

		local function F_000888()
			local L888_1 = U67.LocalPlayer

			if not L888_1 or not L888_1.Character or not L888_1.Character:FindFirstChild("HumanoidRootPart") then
				U576 = nil
				U577 = nil
				return nil
			end

			local L888_2 = L888_1.Character.HumanoidRootPart
			local L888_3 = U65.SilentAimDistance and U65.SilentAimDistance.Value or 45
			local L888_4 = U66.SilentAimTargetEveryone and U66.SilentAimTargetEveryone.Value
			local L888_5 = U65.SilentAimTargets and U65.SilentAimTargets.Value or {}
			local L888_6 = false

			if type(L888_5) == "table" then
				local L888_7, L888_8, L888_9 = pairs(L888_5)
				local L888_10 = table.pack(d_1())

				if L888_10[1] then
					L888_6 = true
				end
			end

			if not L888_4 and not L888_6 then
				U576 = nil
				U577 = nil
				return nil
			end

			local L888_11 = { "Head", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg" }
			local L888_12 = math.huge
			local L888_13 = nil
			local L888_14 = nil

			for I310, I311 in ipairs(U67:GetPlayers()) do
				if I311 ~= L888_1 and I311.Character then
					local L888_15 = I311.Character:FindFirstChild("HumanoidRootPart") or I311.Character:FindFirstChild("Torso")
					local L888_16 = I311.Character:FindFirstChildOfClass("Humanoid")

					if L888_15 and (not L888_16 or L888_16.Health > 0) then
						local L888_17

						if not L888_4 and type(L888_5) == "table" then
							L888_17 = L888_5[I311.DisplayName] or L888_5[I311.Name]
						else
							L888_17 = L888_4
						end

						if L888_17 then
							local L888_18 = (L888_2.Position - L888_15.Position).Magnitude

							if L888_18 <= L888_3 and L888_18 < L888_12 then
								local L888_19 = math.huge
								L888_13 = nil

								for I312, I313 in ipairs(L888_11) do
									local L888_20 = I311.Character:FindFirstChild(I313)

									if L888_20 then
										local L888_21 = (L888_2.Position - L888_20.Position).Magnitude

										if L888_21 < L888_19 then
											L888_19 = L888_21
											L888_13 = L888_20
										end
									end
								end

								if L888_13 then
									L888_12 = L888_18
									L888_14 = I311
								else
									L888_12 = L888_18
									L888_13 = L888_15
									L888_14 = I311
								end
							end
						end
					end
				end
			end

			U576 = L888_13
			U577 = L888_14
			return U576
		end

		local U578 = nil
		local U579 = nil

		local function F_000889(A889_1)
			local L889_1 = U71.CurrentCamera
			if not L889_1 or L889_1.ViewportSize.Y <= 0 then
				return 100
			end
			local L889_2 = math.rad(L889_1.FieldOfView)
			local L889_3 = L889_1.ViewportSize.Y / 2
			return math.max(math.tan(math.rad(A889_1 / 2)) / math.tan(L889_2 / 2) * L889_3, 5)
		end

		local function F_000890()
			local U580 = U68
			if not U580.Character or not U580.Character:FindFirstChild("HumanoidRootPart") then
				U579 = nil
				return nil
			end
			local U581 = U580.Character.HumanoidRootPart
			local U582 = U71.CurrentCamera
			local U583 = U65.AimbotDistance and U65.AimbotDistance.Value or 1000
			local U584 = U65.AimbotFov and U65.AimbotFov.Value or 90
			local U585 = U584 >= 360
			local L890_1 = true

			if U66.AimbotTargetEveryone ~= nil then
				L890_1 = U66.AimbotTargetEveryone.Value
			end

			local L890_2 = U65.AimbotTargets and U65.AimbotTargets.Value or {}
			local L890_3 = not L890_1 and type(L890_2) == "table"
			local L890_4 = false

			if L890_3 then
				for I314, I315 in pairs(L890_2) do
					if I315 == true then
						L890_4 = true
						break
					end
				end
			end

			local U586 = U65.AimbotMode and U65.AimbotMode.Value == "Normal"

			local function F_000891(A891_1)
				if not A891_1 or not A891_1.Parent or not A891_1.Character then
					return false
				end
				local L891_1 = A891_1.Character:FindFirstChildOfClass("Humanoid")
				local L891_2 = A891_1.Character:FindFirstChild("HumanoidRootPart") or A891_1.Character:FindFirstChild("Torso") or A891_1.Character:FindFirstChild("UpperTorso")
				if not L891_1 or L891_1.Health <= 0 or not L891_2 then
					return false
				end

				if U583 < (U581.Position - L891_2.Position).Magnitude then
					return false
				end

				if U586 then
					local L891_3 = RaycastParams.new()
					L891_3.FilterType = Enum.RaycastFilterType.Exclude
					L891_3.FilterDescendantsInstances = { U580.Character, A891_1.Character }
					if U71:Raycast(U582.CFrame.Position, L891_2.Position - U582.CFrame.Position, L891_3) then
						return false
					end
				end

				if not U585 then
					local L891_4 = U582.CFrame.LookVector:Dot((L891_2.Position - U582.CFrame.Position).Unit)
					if L891_4 <= 0 then
						return false
					end

					if U584 / 2 < math.deg(math.acos(math.clamp(L891_4, -1, 1))) then
						return false
					end
				end

				return true
			end

			if U579 and F_000891(U579) then
				return U579
			end
			local L890_5 = math.huge
			local L890_6 = nil

			for I316, I317 in pairs(U67:GetPlayers()) do
				if I317 ~= U580 and I317.Character then
					local L890_7 = I317.Character:FindFirstChild("HumanoidRootPart") or I317.Character:FindFirstChild("Torso") or I317.Character:FindFirstChild("UpperTorso")
					local L890_8 = I317.Character:FindFirstChildOfClass("Humanoid")

					if L890_7 and L890_8 and L890_8.Health > 0 then
						local L890_9 = L890_1 or not L890_4

						if not L890_9 then
							local L890_10 = I317.DisplayName .. " (@" .. I317.Name .. ")"

							if type(L890_2) == "table" then
								L890_9 = L890_2[L890_10] == true or L890_2[I317.Name] == true
							end
						end

						if L890_9 then
							local L890_11 = (U581.Position - L890_7.Position).Magnitude

							if L890_11 <= U583 then
								if U586 then
									local L890_12 = RaycastParams.new()
									L890_12.FilterType = Enum.RaycastFilterType.Exclude
									L890_12.FilterDescendantsInstances = { U580.Character, I317.Character }

									if not U71:Raycast(U582.CFrame.Position, L890_7.Position - U582.CFrame.Position, L890_12) then
										if U585 then
											if L890_11 < L890_5 then
												L890_5 = L890_11
												L890_6 = I317
											end
										else
											local L890_13 = U582.CFrame.LookVector:Dot((L890_7.Position - U582.CFrame.Position).Unit)

											if L890_13 > 0 then
												local L890_14 = math.deg(math.acos(math.clamp(L890_13, -1, 1)))

												if L890_14 <= U584 / 2 and L890_14 < L890_5 then
													L890_5 = L890_14
													L890_6 = I317
												end
											end
										end
									end
								elseif U585 then
									if L890_11 < L890_5 then
										L890_5 = L890_11
										L890_6 = I317
									end
								else
									local L890_15 = U582.CFrame.LookVector:Dot((L890_7.Position - U582.CFrame.Position).Unit)

									if L890_15 > 0 then
										local L890_16 = math.deg(math.acos(math.clamp(L890_15, -1, 1)))

										if L890_16 <= U584 / 2 and L890_16 < L890_5 then
											L890_5 = L890_16
											L890_6 = I317
										end
									end
								end
							end
						end
					end
				end
			end

			U579 = L890_6
			return U579
		end

		local function F_000892()
			local L892_1 = U68
			if not L892_1.Character or not L892_1.Character:FindFirstChild("HumanoidRootPart") then
				U578 = nil
				return nil
			end
			local L892_2 = L892_1.Character.HumanoidRootPart
			local L892_3 = U71.CurrentCamera
			local L892_4 = U65.ObjectLockDistance and U65.ObjectLockDistance.Value or 40
			local L892_5 = U65.ObjectLockFov and U65.ObjectLockFov.Value or 90
			local L892_6 = L892_5 >= 360
			local L892_7 = U65.SelectObject and U65.SelectObject.Value or {}
			local L892_8 = L892_7["Closest Object"] == true
			local L892_9 = L892_7["Spawned In Toys"] == true
			local L892_10 = L892_7.PalletLightBrown == true

			if not L892_8 and not L892_9 and not L892_10 then
				L892_9 = true
				L892_8 = true
				L892_10 = true
			end

			local L892_11 = U66.WhitelistOwnPallet and U66.WhitelistOwnPallet.Value
			local L892_12 = U71:FindFirstChild(L892_1.Name .. "SpawnedInToys")
			local L892_13 = OverlapParams.new()
			L892_13.FilterType = Enum.RaycastFilterType.Exclude
			L892_13.FilterDescendantsInstances = { L892_1.Character }
			local L892_14 = U71:GetPartBoundsInRadius(L892_2.Position, L892_4, L892_13)
			local L892_15 = {}

			for I318, I319 in ipairs(L892_14) do
				if I319:IsA("BasePart") and not I319.Anchored then
					local L892_16 = I319:FindFirstAncestorOfClass("Model")

					if not (L892_16 and L892_16:FindFirstChildOfClass("Humanoid")) then
						local L892_17 = I319.Name == "PalletLightBrown" or I319.Name == "SoundPart" or I319.Parent and I319.Parent.Name:find("Pallet")
						local L892_18 = I319:FindFirstAncestorWhichIsA("Folder") and I319:FindFirstAncestorWhichIsA("Folder").Name:find("SpawnedInToys")
						local L892_19 = L892_12 and I319:IsDescendantOf(L892_12)

						if not (L892_11 and L892_19 and L892_17) then
							if not (not L892_9 and L892_19) then
								local L892_20

								if L892_10 and L892_17 then
									L892_20 = true
								elseif L892_9 and (L892_18 or L892_19) then
									L892_20 = true
								else
									L892_20 = false

									if L892_8 then
										L892_20 = true
									end
								end

								if L892_20 then
									table.insert(L892_15, I319)
								end
							end
						end
					end
				end
			end

			local L892_21 = math.huge
			local L892_22 = nil

			for I320, I321 in ipairs(L892_15) do
				local L892_23 = (L892_2.Position - I321.Position).Magnitude

				if L892_23 <= L892_4 then
					if L892_6 then
						if L892_23 < L892_21 then
							L892_21 = L892_23
							L892_22 = I321
						end
					else
						local L892_24 = L892_3.CFrame.LookVector:Dot((I321.Position - L892_3.CFrame.Position).Unit)

						if L892_24 > 0 then
							local L892_25 = math.deg(math.acos(math.clamp(L892_24, -1, 1)))

							if L892_25 <= L892_5 / 2 and L892_25 < L892_21 then
								L892_21 = L892_25
								L892_22 = I321
							end
						end
					end
				end
			end

			U578 = L892_22
			return U578
		end

		task.spawn(function()
			while true do
				task.wait(0.03)

				if U66.ToggleAimbot and U66.ToggleAimbot.Value then
					F_000890()
				else
					U579 = nil
				end

				if U66.ToggleObjectLock and U66.ToggleObjectLock.Value then
					F_000892()
				else
					U578 = nil
				end

				if U573 then
					if F_000888() then
						U575 = true
						local L893_1 = U66.ToggleSilentAim

						if L893_1 and not L893_1.Value then
							U574 = true
							L893_1:SetValue(true)
							U574 = false
							continue
						end

						continue
					end

					U575 = false
					U576 = nil
					U577 = nil
					local L893_2 = U66.ToggleSilentAim

					if L893_2 and L893_2.Value then
						U574 = true
						L893_2:SetValue(false)
						U574 = false
						continue
					end

					continue
				end

				U575 = false
				U576 = nil
				U577 = nil
			end
		end)

		U69.RenderStepped:Connect(function()
			if U66.ToggleAimbot and U66.ToggleAimbot.Value and U579 and U579.Character then
				local L894_1 = U65.AimbotAimAt and U65.AimbotAimAt.Value or "Head"
				local L894_2

				if L894_1 == "Head" then
					L894_2 = U579.Character:FindFirstChild("Head")
				elseif L894_1 == "Torso" then
					L894_2 = U579.Character:FindFirstChild("HumanoidRootPart") or U579.Character:FindFirstChild("Torso") or U579.Character:FindFirstChild("UpperTorso")
				else
					L894_2 = U579.Character:FindFirstChild(L894_1) or U579.Character:FindFirstChild("HumanoidRootPart")
				end

				if L894_2 then
					local L894_3 = U71.CurrentCamera
					L894_3.CFrame = CFrame.new(L894_3.CFrame.Position, L894_2.Position)
				end
			end
		end)

		if typeof(hookmetamethod) == "function" and typeof(newcclosure) == "function" and typeof(checkcaller) == "function" and typeof(getnamecallmethod) == "function" then
			pcall(function()
				local U587 = nil

				local function F_000896(A896_1, ...)
					local L896_1 = table.pack(...)
					local L896_2 = getnamecallmethod()
					local L896_3 = { ... }

					if not checkcaller() and A896_1 == U71 and L896_2 == "Raycast" then
						local L896_4 = L896_3[3]

						if U575 then
							local L896_5 = U576

							if not L896_5 or not L896_5.Parent then
								L896_5 = F_000888()
							end

							if L896_5 and L896_5.Parent and U577 and U577.Character then
								local L896_6 = U67.LocalPlayer
								local L896_7 = U65 and U65.SilentAimMode and U65.SilentAimMode.Value or "Normal"

								if typeof(L896_4) == "RaycastParams" then
									if L896_7 == "ThroughObjects" then
										L896_4.FilterType = Enum.RaycastFilterType.Include
										L896_4.FilterDescendantsInstances = { U577.Character }
									else
										L896_4.FilterType = Enum.RaycastFilterType.Exclude

										if L896_6 and L896_6.Character then
											L896_4.FilterDescendantsInstances = { L896_6.Character }
										end
									end
								end

								L896_3[2] = (L896_5.Position - L896_3[1]).Unit * 1000
								return U587(A896_1, unpack(L896_3))
							end

							U575 = false
							U576 = nil
							U577 = nil
						end

						if U66 and U66.ToggleObjectLock and U66.ToggleObjectLock.Value and U578 and U578.Parent then
							if typeof(L896_4) == "RaycastParams" then
								if L896_4.FilterType == Enum.RaycastFilterType.Include then
									L896_4.FilterType = Enum.RaycastFilterType.Exclude
									local L896_8 = U67.LocalPlayer

									if L896_8 and L896_8.Character then
										L896_4.FilterDescendantsInstances = { L896_8.Character }
									end
								end
							end

							L896_3[2] = (U578.Position - L896_3[1]).Unit * 1000
							return U587(A896_1, unpack(L896_3))
						end
					end

					return U587(A896_1, table.unpack(L896_1, 1, L896_1.n))
				end

				U587 = hookmetamethod
				U587 = U587(game, "__namecall", newcclosure(F_000896))
			end)
		end

		local U588 = nil
		local U589 = nil

		pcall(function()
			if Drawing and Drawing.new then
				U588 = Drawing.new("Circle")
				U588.Thickness = 1.5
				U588.NumSides = 64
				U588.Filled = false
				U588.Visible = false
				U589 = Drawing.new("Circle")
				U589.Thickness = 1.5
				U589.NumSides = 64
				U589.Filled = false
				U589.Visible = false
			end
		end)

		U69.RenderStepped:Connect(function()
			local L898_1 = UserInputService:GetMouseLocation()

			if U588 then
				local L898_2 = U66.ToggleAimbot and U66.ToggleAimbot.Value
				local L898_3 = U66.ShowAimbotFovCircle and U66.ShowAimbotFovCircle.Value
				local L898_4 = U65.AimbotFov and U65.AimbotFov.Value or 90

				if L898_2 and L898_3 and L898_4 < 360 then
					U588.Position = L898_1
					U588.Radius = F_000889(L898_4)
					U588.Color = U65.AimbotCircleColor and U65.AimbotCircleColor.Value or Color3.fromRGB(255, 255, 255)
					U588.Transparency = U65.AimbotCircleTransparency and U65.AimbotCircleTransparency.Value or 1
					U588.Visible = true
				else
					U588.Visible = false
				end
			end

			if U589 then
				local L898_5 = U66.ToggleObjectLock and U66.ToggleObjectLock.Value
				local L898_6 = U66.ShowObjectLockFovCircle and U66.ShowObjectLockFovCircle.Value
				local L898_7 = U65.ObjectLockFov and U65.ObjectLockFov.Value or 90

				if L898_5 and L898_6 and L898_7 < 360 then
					U589.Position = L898_1
					U589.Radius = F_000889(L898_7)
					U589.Color = U65.ObjectLockCircleColor and U65.ObjectLockCircleColor.Value or Color3.fromRGB(255, 255, 255)
					U589.Transparency = U65.ObjectLockCircleTransparency and U65.ObjectLockCircleTransparency.Value or 1
					U589.Visible = true
				else
					U589.Visible = false
				end
			end
		end)
	end

	local L0_366 = Enum.RaycastFilterType.Exclude
	RaycastParams.new().FilterType = L0_366
	local L0_367

	do
		local L0_368 = U92.Grabs:AddGroupbox({
			Side = 2,
			Name = "<b>Triggerbots</b>",
			IconName = "mouse-pointer",
			Description = "Auto fire",
			MaxPopOutHeight = 600,
			PopOutWidth = 250,
		}):AddTabbox({ MaxPopOutHeight = 600 })

		local L0_369 = L0_368:AddTab("<b>Player</b>", "user")

		L0_369:AddToggle("TriggerbotToggle", {
			Text = "Triggerbot",
			Default = false,
			Callback = function(A899_1)
				applyTriggerBot(A899_1)
			end,
		}):AddKeyPicker("TriggerbotKey", {
			Default = "None",
			Mode = "Toggle",
			SyncToggleState = true,
			Text = "Triggerbot Keybind",
			Callback = function()
			end,
		})

		L0_369:AddDivider("Trigger Settings")

		L0_369:AddSlider("TriggerbotDistance", {
			Text = "Distance",
			Default = 30,
			Min = 1,
			Max = 80,
			Rounding = 0,
			Compact = true,
			Callback = function()
			end,
		})

		L0_369:AddSlider("TriggerbotDelay", {
			Text = "Triggerbot Delay",
			Default = 0,
			Min = 0,
			Max = 20,
			Rounding = 1,
			Compact = true,
			Suffix = " ms",
			Callback = function()
			end,
		})

		L0_369:AddDivider()

		L0_369:AddDropdown("TriggerbotSelectPart", {
			Text = "Select Part",
			Values = { "Torso", "Head", "Right Arm", "Left Arm", "Right Leg", "Left Leg" },
			ValueImages = {
				Torso = "shirt",
				Head = "circle-user",
				["Right Arm"] = "hand",
				["Left Arm"] = "hand",
				["Right Leg"] = "footprints",
				["Left Leg"] = "footprints",
			},
			Default = { "Torso", "Head", "Right Arm", "Left Arm", "Right Leg", "Left Leg" },
			Multi = true,
			Callback = function()
			end,
		})

		L0_367 = L0_368:AddTab("<b>Object Trigger</b>", "square-dashed-kanban")
	end

	do
		local U590 = nil
		local U591 = true
		local U592 = nil
		local U593 = 0
		local U594 = 0

		local function F_000904()
			local L904_1 = U68.Character
			if not L904_1 or not L904_1:FindFirstChild("HumanoidRootPart") then
				return nil
			end

			if U71:FindFirstChild("GrabParts") then
				return nil
			end
			local L904_2 = U71.CurrentCamera
			local L904_3 = L904_2.CFrame.Position
			local L904_4 = L904_2.CFrame.LookVector
			local L904_5 = U65.ObjectTriggerDistance and U65.ObjectTriggerDistance.Value or 30
			local L904_6 = RaycastParams.new()
			L904_6.FilterType = Enum.RaycastFilterType.Exclude
			L904_6.FilterDescendantsInstances = { L904_1, U71.Terrain }
			local L904_7 = U71:Raycast(L904_3, L904_4 * L904_5, L904_6)
			if not L904_7 or not L904_7.Instance then
				return nil
			end
			local L904_8 = L904_7.Instance
			local L904_9 = L904_8:FindFirstAncestorOfClass("Model")
			if L904_9 and L904_9:FindFirstChildOfClass("Humanoid") then
				return nil
			end

			if L904_8.Anchored then
				return nil
			end

			if U66.WhitelistPallet and U66.WhitelistPallet.Value then
				if L904_8.Name == "PalletLightBrown" or L904_8.Name == "SoundPart" or L904_8.Parent and L904_8.Parent.Name:find("Pallet") then
					return nil
				end
			end

			if L904_5 < (L904_1.HumanoidRootPart.Position - L904_8.Position).Magnitude then
				return nil
			end
			return L904_8
		end

		local function F_000905(A905_1)
			if U590 then
				U590:Disconnect()
				U590 = nil
			end

			if not A905_1 then
				return
			end

			U590 = U69.Heartbeat:Connect(function()
				if not U591 then
					return
				end

				if UserInputService:GetFocusedTextBox() then
					return
				end

				if tick() - U594 < 0.008 then
					return
				end
				U594 = tick()
				local L906_1 = F_000904()

				if L906_1 then
					U592 = L906_1
					U593 = tick()
				elseif U592 and tick() - U593 > 0.1 then
					U592 = nil
				end

				local L906_2 = U68.Character
				if not (U592 and L906_2 and L906_2:FindFirstChild("HumanoidRootPart")) then
					return
				end

				if (L906_2.HumanoidRootPart.Position - U592.Position).Magnitude > (U65.ObjectTriggerDistance and U65.ObjectTriggerDistance.Value or 30) then
					U592 = nil
					return
				end
				U591 = false

				task.spawn(function()
					local L907_1 = U65.ObjectTriggerDelay and U65.ObjectTriggerDelay.Value or 0

					if L907_1 > 0 then
						task.wait(L907_1 / 1000)
					end

					pcall(mouse1press)
					local L907_2 = tick()

					while true do
						task.wait(0.02)
						if not (not U71:FindFirstChild("GrabParts") or tick() - L907_2 > 1.6) then
							continue
						end
						break
					end

					pcall(mouse1release)
					task.wait(0.05)
					U591 = true
					U592 = nil
				end)
			end)
		end

		L0_367:AddToggle("ToggleObjectTriggerbot", {
			Text = "Toggle Object Trigger bot",
			Default = false,
			Callback = function(A908_1)
				F_000905(A908_1)
			end,
		}):AddKeyPicker("ObjectTriggerKey", {
			Default = "None",
			Mode = "Toggle",
			SyncToggleState = true,
			Text = "Toggle Object Trigger Keybind",
			Callback = function()
			end,
		})
	end

	L0_367:AddDivider("Trigger Settings")

	L0_367:AddSlider("ObjectTriggerDistance", {
		Text = "Distance",
		Default = 30,
		Min = 1,
		Max = 80,
		Rounding = 0,
		Compact = true,
		Callback = function()
		end,
	})

	L0_367:AddSlider("ObjectTriggerDelay", {
		Text = "Triggerbot Delay",
		Default = 0,
		Min = 0,
		Max = 20,
		Rounding = 1,
		Compact = true,
		Suffix = " ms",
		Callback = function()
		end,
	})

	L0_367:AddDivider()

	L0_367:AddToggle("WhitelistPallet", {
		Text = "Whitelist Pallet",
		Default = false,
		Callback = function()
		end,
	})

	local L0_370

	L0_370 = U92.Grabs:AddGroupbox({
		Side = 1,
		Name = "<b>Movement</b>",
		IconName = "component",
		Description = "Pallet scripts",
		MaxPopOutHeight = 600,
		PopOutWidth = 250,
	})

	local U595
	U595 = false
	local U596

	do
		local U597 = nil
		local U598 = nil
		local U599 = nil
		local U600 = nil
		local U601 = nil

		U596 = function(A913_1)
			U595 = false
			local U602 = A913_1 or U68.Character

			if U602 and U602:FindFirstChild("Humanoid") then
				pcall(function()
					U602.Humanoid.PlatformStand = false
				end)
			end

			pcall(function()
				if U598 then
					U598:Destroy()
				end
			end)

			pcall(function()
				if U599 then
					U599:Destroy()
				end
			end)

			pcall(function()
				if U600 then
					U600:Destroy()
				end
			end)

			pcall(function()
				if U601 then
					U601:Destroy()
				end
			end)

			U598 = nil
			U599 = nil
			U600 = nil
			U601 = nil
			U597 = nil

			pcall(function()
				U69:UnbindFromRenderStep("MountedRotation")
			end)
		end

		local function F_000920(A920_1)
			local L920_1 = U68.Character
			if not L920_1 then
				return
			end
			local L920_2 = L920_1:FindFirstChild("Humanoid") or L920_1:WaitForChild("Humanoid", 3)
			local L920_3 = L920_1:FindFirstChild("Left Leg") or L920_1:FindFirstChild("LeftLowerLeg") or L920_1:FindFirstChild("HumanoidRootPart")
			local U603 = L920_1:FindFirstChild("HumanoidRootPart")
			if not L920_2 or not L920_3 or not U603 then
				return
			end
			U596(L920_1)
			U595 = true
			U597 = A920_1
			L920_2.PlatformStand = true
			U598 = Instance.new("Attachment", L920_3)
			U598.Position = Vector3.new(0, -1, 0)
			U599 = Instance.new("Attachment", A920_1)
			U599.Position = Vector3.zero
			U600 = Instance.new("AlignPosition")
			U600.Attachment0 = U598
			U600.Attachment1 = U599
			U600.MaxForce = 500000
			U600.Responsiveness = 40
			U600.Parent = L920_3
			U601 = Instance.new("AlignOrientation")
			U601.Attachment0 = U598
			U601.Attachment1 = U599
			U601.MaxTorque = 500000
			U601.Responsiveness = 40
			U601.Parent = L920_3
			U69:UnbindFromRenderStep("MountedRotation")

			U69:BindToRenderStep("MountedRotation", Enum.RenderPriority.Camera.Value, function()
				if U595 and U603 and U603.Parent then
					local L921_1 = U71.CurrentCamera

					if L921_1 then
						local L921_2 = L921_1.CFrame.LookVector
						local L921_3 = Vector3.new(L921_2.X, 0, L921_2.Z)

						if L921_3.Magnitude > 0 then
							U603.CFrame = CFrame.new(U603.Position, U603.Position + L921_3)
						end
					end
				end
			end)
		end

		local function F_000922()
			if U595 then
				U596(U68.Character)
				return
			end
			local L922_1 = U68:GetMouse()
			L922_1 = L922_1 and L922_1.Target
			if not L922_1 or not L922_1:IsA("BasePart") then
				return
			end

			if (U65.StickType and U65.StickType.Value or "Only Pallet") == "Everything" then
				F_000920(L922_1)
			elseif L922_1.Name == "PalletLightBrown" or L922_1.Name == "SoundPart" and L922_1.Parent and L922_1.Parent.Name == "PalletLightBrown" then
				F_000920(L922_1)
			end
		end

		local U604 = nil

		local function F_000923()
			local L923_1 = U68.Character
			local U605 = L923_1 and L923_1:FindFirstChild("HumanoidRootPart")
			if not U605 then
				return
			end
			local U606 = U605.CFrame * CFrame.new(0, -2, -2)
			local U607 = U606 * CFrame.new(0, 2, 0)

			pcall(function()
				U605.CFrame = U607
			end)

			local U608 = U66.AutoStickWallOnClutch and U66.AutoStickWallOnClutch.Value
			local L923_2 = U71:FindFirstChild(U68.Name .. "SpawnedInToys")
			local U609 = false
			local U610 = nil

			local function F_000925(A925_1)
				if U609 or A925_1.Name ~= "PalletLightBrown" then
					return
				end
				U609 = true

				if U610 then
					pcall(function()
						U610:Disconnect()
					end)
				end

				local U611 = A925_1:FindFirstChild("SoundPart") or A925_1:FindFirstChildWhichIsA("BasePart")

				if U611 then
					pcall(function()
						U605.CFrame = U611.CFrame * CFrame.new(0, 2, 0)
					end)

					if U608 then
						F_000920(U611)
					end
				else
					local U612 = nil

					U612 = A925_1.ChildAdded:Connect(function(A928_1)
						if A928_1.Name == "SoundPart" or A928_1:IsA("BasePart") then
							pcall(function()
								U612:Disconnect()
							end)

							pcall(function()
								U605.CFrame = A928_1.CFrame * CFrame.new(0, 2, 0)
							end)

							if U608 then
								F_000920(A928_1)
							end
						end
					end)

					task.delay(1.5, function()
						pcall(function()
							U612:Disconnect()
						end)
					end)
				end
			end

			local U613 = {}

			if L923_2 then
				for I322, I323 in ipairs(L923_2:GetChildren()) do
					U613[I323] = true
				end

				U610 = L923_2.ChildAdded:Connect(function(A933_1)
					if not U613[A933_1] then
						F_000925(A933_1)
					end
				end)
			end

			task.spawn(function()
				pcall(function()
					local L935_1 = U68:FindFirstChild("CanSpawnToy")

					if L935_1 and not L935_1.Value then
						L935_1.Changed:Wait()
					end

					U73.MenuToys.SpawnToyRemoteFunction:InvokeServer("PalletLightBrown", U606, Vector3.zero)
				end)

				task.wait(2)

				if U610 then
					pcall(function()
						U610:Disconnect()
					end)
				end
			end)
		end

		L0_370:AddToggle("MovementToggle", {
			Text = "Movement",
			Default = false,
			Callback = function(A937_1)
				if not A937_1 then
					U596(U68.Character)
				end
			end,
		}):AddKeyPicker("MovementKey", {
			Default = "Y",
			Mode = "Toggle",
			SyncToggleState = true,
			Text = "Movement Keybind",
			Callback = function(A938_1)
				if A938_1 then
					if not U65.MovementType or U65.MovementType.Value == "Stick" then
						F_000922()
					end
				end
			end,
		})

		L0_370:AddDivider("Settings")

		L0_370:AddDropdown("MovementType", {
			Text = "Movement Type",
			Values = { "Stick", "Wall" },
			ValueImages = { Stick = "magnet", Wall = "shield" },
			Default = 1,
			Callback = function(A939_1)
				if A939_1 ~= "Stick" and U595 then
					U596(U68.Character)
				end
			end,
		})

		local L0_371 = L0_370:AddDependencyBox()

		L0_371:AddDropdown("StickType", {
			Text = "Stick Type",
			Values = { "Only Pallet", "Everything" },
			ValueImages = { ["Only Pallet"] = "box", Everything = "globe" },
			Default = 1,
			Callback = function()
			end,
		})

		L0_371:SetupDependencies({ { U65.MovementType, "Stick" } })
		L0_370:AddDivider()

		L0_370:AddLabel("Auto Clutch"):AddKeyPicker("AutoClutchKey", {
			Default = "None",
			Mode = "Press",
			Text = "Auto Clutch Keybind",
			Callback = function()
				if U604 then
					task.cancel(U604)
				end

				U604 = task.spawn(F_000923)
			end,
		})
	end

	L0_370:AddDivider("Clutch Settings")

	L0_370:AddToggle("AutoStickWallOnClutch", {
		Text = "Auto Stick/Wall on Clutch",
		Default = false,
		Callback = function()
		end,
	})

	U68.CharacterAdded:Connect(function(A943_1)
		U596(A943_1)
	end)

	do
		local L0_372 = U92.Player:AddGroupbox({
			Side = 1,
			Name = "<b>Players</b>",
			IconName = "user-pen",
			Description = "Spectate TP",
			MaxPopOutHeight = 600,
			PopOutWidth = 250,
		})

		local function F_000944()
			local L944_1 = U65.PlayerSelect and U65.PlayerSelect.Value
			if not L944_1 then
				return nil
			end
			return U88(L944_1) or U67:FindFirstChild(L944_1)
		end

		local U614 = nil

		local function F_000945(A945_1)
			if U614 then
				U614:Disconnect()
				U614 = nil
			end

			if not A945_1 then
				return
			end

			U614 = U69.Heartbeat:Connect(function()
				if not (U66.LoopTP and U66.LoopTP.Value) then
					if U614 then
						U614:Disconnect()
						U614 = nil
					end

					return
				end

				local L946_1 = F_000944()
				if not L946_1 or not L946_1.Character then
					return
				end
				local L946_2 = L946_1.Character:FindFirstChild("HumanoidRootPart")
				local L946_3 = U68.Character
				local L946_4 = L946_3 and L946_3:FindFirstChild("HumanoidRootPart")
				L946_3 = L946_3 and L946_3:FindFirstChildOfClass("Humanoid")

				if L946_4 and L946_2 and L946_3 and L946_3.Health > 0 then
					L946_4.CFrame = L946_2.CFrame * CFrame.new(0, 0, 3)
					L946_4.AssemblyLinearVelocity = Vector3.zero
				end
			end)
		end

		local U615 = nil
		local U616 = nil

		local function F_000947(A947_1)
			if U615 then
				U615:Disconnect()
				U615 = nil
			end

			if U616 then
				U616:Disconnect()
				U616 = nil
			end

			local U617 = workspace.CurrentCamera

			if not A947_1 then
				local L947_1 = U68.Character
				L947_1 = L947_1 and L947_1:FindFirstChildOfClass("Humanoid")

				if U617 and L947_1 then
					U617.CameraSubject = L947_1
				end

				return
			end

			local function F_000948()
				local L948_1 = F_000944()
				if not L948_1 then
					return
				end
				local L948_2 = L948_1.Character and L948_1.Character:FindFirstChildOfClass("Humanoid")

				if U617 and L948_2 then
					U617.CameraSubject = L948_2
				end
			end

			F_000948()
			local L947_2 = F_000944()

			if L947_2 then
				U616 = L947_2.CharacterAdded:Connect(function(A949_1)
					task.wait(0.2)

					if U66.SpectatePlayer and U66.SpectatePlayer.Value then
						local L949_1 = A949_1:WaitForChild("Humanoid", 3)

						if U617 and L949_1 then
							U617.CameraSubject = L949_1
						end
					end
				end)
			end

			U615 = U69.RenderStepped:Connect(function()
				if not (U66.SpectatePlayer and U66.SpectatePlayer.Value) then
					if U615 then
						U615:Disconnect()
						U615 = nil
					end

					local L950_1 = U68.Character
					L950_1 = L950_1 and L950_1:FindFirstChildOfClass("Humanoid")

					if U617 and L950_1 then
						U617.CameraSubject = L950_1
					end

					return
				end

				local L950_2 = F_000944()
				local L950_3 = L950_2 and L950_2.Character and L950_2.Character:FindFirstChildOfClass("Humanoid")
				local L950_4 = U617
				local L950_5

				if U617 then
					L950_5 = L950_3
				else
					L950_5 = L950_4
				end

				if L950_5 and U617.CameraSubject ~= L950_3 then
					U617.CameraSubject = L950_3
				end
			end)
		end

		local function F_000951()
			local L951_1 = F_000944()
			if not L951_1 or not L951_1.Character then
				return
			end
			local L951_2 = L951_1.Character:FindFirstChild("HumanoidRootPart")
			local L951_3 = U68.Character
			L951_3 = L951_3 and L951_3:FindFirstChild("HumanoidRootPart")

			if L951_3 and L951_2 then
				L951_3.CFrame = L951_2.CFrame * CFrame.new(0, 0, 3)
				L951_3.AssemblyLinearVelocity = Vector3.zero
			end
		end

		L0_372:AddDropdown("PlayerSelect", {
			Text = "Player",
			Values = U87(),
			Default = 1,
			AllowNull = true,
			Searchable = true,
			Callback = function()
				if U66.SpectatePlayer and U66.SpectatePlayer.Value then
					F_000947(true)
				end
			end,
		})

		L0_372:AddToggle("LoopTP", { Text = "Loop TP", Default = false, Callback = F_000945 }):AddKeyPicker("LoopTPKey", {
			Default = "None",
			Mode = "Toggle",
			SyncToggleState = true,
			Text = "Loop TP Keybind",
			Callback = function()
			end,
		})

		L0_372:AddToggle("SpectatePlayer", { Text = "Spectate Player", Default = false, Callback = F_000947 })
		L0_372:AddDivider()
		L0_372:AddButton({ Text = "TP to Player", Func = F_000951, DoubleClick = false })
	end

	U96 = function(A954_1)
		pcall(function()
			local L955_1 = workspace.CurrentCamera

			if L955_1 then
				L955_1.FieldOfView = A954_1
			end
		end)
	end

	local U618
	U618 = nil

	U97 = function(A956_1)
		if U618 then
			U618:Disconnect()
			U618 = nil
		end

		if A956_1 then
			U618 = U69.Stepped:Connect(function()
				if not (U66.NoClip and U66.NoClip.Value) then
					if U618 then
						U618:Disconnect()
						U618 = nil
					end

					return
				end

				local L957_1 = U68.Character

				if L957_1 then
					for I324, I325 in ipairs(L957_1:GetDescendants()) do
						if I325:IsA("BasePart") and I325.CanCollide then
							I325.CanCollide = false
						end
					end
				end
			end)
		end
	end

	U98 = function()
		pcall(function()
			local L959_1 = U68.Character
			L959_1 = L959_1 and L959_1:FindFirstChildOfClass("Humanoid")

			if L959_1 then
				if U66.SuperJumpToggle and U66.SuperJumpToggle.Value then
					local L959_2 = U65.SuperJump and U65.SuperJump.Value or 100
					L959_1.UseJumpPower = true
					L959_1.JumpPower = L959_2
					L959_1.JumpHeight = L959_2 * 0.144
				else
					L959_1.UseJumpPower = true
					L959_1.JumpPower = 50
					L959_1.JumpHeight = 7.2
				end
			end
		end)
	end

	do
		local U619 = nil

		local function F_000960()
			if U619 then
				return
			end

			U619 = UserInputService.JumpRequest:Connect(function()
				if U66.InfiniteJump and U66.InfiniteJump.Value then
					local L961_1 = U68.Character
					L961_1 = L961_1 and L961_1:FindFirstChildOfClass("Humanoid")

					if L961_1 then
						L961_1:ChangeState(Enum.HumanoidStateType.Jumping)
					end
				end
			end)
		end

		F_000960()
	end

	do
		local U620 = nil

		U99 = function(A962_1)
			if U620 then
				U620:Disconnect()
				U620 = nil
			end

			if not A962_1 then
				return
			end

			U620 = U69.Heartbeat:Connect(function(A963_1)
				if not (U66.WalkSpeedToggle and U66.WalkSpeedToggle.Value) then
					if U620 then
						U620:Disconnect()
						U620 = nil
					end

					return
				end

				local L963_1 = U68.Character
				local L963_2 = L963_1 and L963_1:FindFirstChildOfClass("Humanoid")
				local L963_3 = L963_1 and L963_1:FindFirstChild("HumanoidRootPart")
				if not L963_1 or not L963_2 or not L963_3 or L963_2.Health <= 0 then
					return
				end
				local L963_4 = U65.WalkSpeed and U65.WalkSpeed.Value or 16
				local L963_5 = L963_2.MoveDirection

				if L963_5.Magnitude == 0 and not UserInputService:GetFocusedTextBox() then
					local L963_6 = workspace.CurrentCamera

					if L963_6 then
						local L963_7 = UserInputService
						local L963_8 = Vector3.zero

						if L963_7:IsKeyDown(Enum.KeyCode.W) then
							L963_8 = Vector3.zero + L963_6.CFrame.LookVector
						end

						if UserInputService:IsKeyDown(Enum.KeyCode.S) then
							L963_8 -= L963_6.CFrame.LookVector
						end

						if UserInputService:IsKeyDown(Enum.KeyCode.A) then
							L963_8 -= L963_6.CFrame.RightVector
						end

						if UserInputService:IsKeyDown(Enum.KeyCode.D) then
							L963_8 += L963_6.CFrame.RightVector
						end

						L963_5 = Vector3.new(L963_8.X, 0, L963_8.Z)
					end
				end

				if L963_5.Magnitude > 0 then
					L963_3.CFrame = L963_3.CFrame + L963_5.Unit * math.max(0, L963_4 - 16) * A963_1
				end

				for I326, I327 in ipairs(L963_2:GetPlayingAnimationTracks()) do
					local L963_9 = I327.Name:lower()

					if L963_9:find("walk") or L963_9:find("run") then
						I327:AdjustSpeed(1)
					end
				end
			end)
		end

		local U621 = nil
		local U622 = nil
		local U623 = nil

		local function F_000964()
			if not (U66.NoClip and U66.NoClip.Value) then
				pcall(function()
					local L965_1 = U68.Character

					if L965_1 then
						for I328, I329 in ipairs(L965_1:GetDescendants()) do
							if I329:IsA("BasePart") and I329.Name ~= "HumanoidRootPart" then
								I329.CanCollide = true
							end
						end
					end
				end)
			end
		end

		local function F_000966()
			if U622 then
				pcall(function()
					U622:Destroy()
				end)

				U622 = nil
			end

			if U623 then
				pcall(function()
					U623:Destroy()
				end)

				U623 = nil
			end

			pcall(function()
				UserInputService.MouseBehavior = Enum.MouseBehavior.Default
			end)

			F_000964()
		end

		U100 = function(A970_1)
			if U621 then
				U621:Disconnect()
				U621 = nil
			end

			F_000966()
			local L970_1 = U68.Character
			local U624 = L970_1 and L970_1:FindFirstChildOfClass("Humanoid")
			local L970_2 = L970_1 and L970_1:FindFirstChild("HumanoidRootPart")

			if not A970_1 then
				if U624 then
					U624.AutoRotate = true
					U624.PlatformStand = false

					pcall(function()
						U624:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
						U624:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
					end)
				end

				if L970_1 then
					local L970_3 = L970_1:FindFirstChild("Animate")

					if L970_3 and L970_3:IsA("LocalScript") then
						L970_3.Enabled = true
					end
				end

				if L970_2 then
					L970_2.AssemblyLinearVelocity = Vector3.zero
					L970_2.AssemblyAngularVelocity = Vector3.zero
				end

				F_000964()
				return
			end

			U621 = U69.RenderStepped:Connect(function()
				if not (U66.FlyToggle and U66.FlyToggle.Value) then
					if U621 then
						U621:Disconnect()
						U621 = nil
					end

					F_000966()
					local L972_1 = U68.Character
					local U625 = L972_1 and L972_1:FindFirstChildOfClass("Humanoid")

					if U625 then
						U625.AutoRotate = true
						U625.PlatformStand = false

						pcall(function()
							U625:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
							U625:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
						end)
					end

					if L972_1 then
						local L972_2 = L972_1:FindFirstChild("Animate")

						if L972_2 and L972_2:IsA("LocalScript") then
							L972_2.Enabled = true
						end
					end

					F_000964()
					return
				end

				local U626 = U68.Character
				local U627 = U626 and U626:FindFirstChildOfClass("Humanoid")
				local L972_3 = U626 and U626:FindFirstChild("HumanoidRootPart")
				local L972_4 = workspace.CurrentCamera
				if not U626 or not U627 or not L972_3 or not L972_4 or U627.Health <= 0 then
					F_000966()
					return
				end

				if not U622 or not U622.Parent or not U623 or not U623.Parent then
					F_000966()
					U622 = Instance.new("BodyVelocity")
					U622.Name = "ST_FlyVelocity"
					U622.MaxForce = Vector3.new(1e9, 1e9, 1e9)
					U622.Velocity = Vector3.zero
					U622.Parent = L972_3
					U623 = Instance.new("BodyGyro")
					U623.Name = "ST_FlyGyro"
					U623.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
					U623.P = 20000
					U623.D = 500
					U623.CFrame = L972_3.CFrame
					U623.Parent = L972_3
				end

				U627.AutoRotate = false
				L972_4.CameraSubject = U627
				UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter

				pcall(function()
					local L974_1 = U626:FindFirstChild("Animate")

					if L974_1 and L974_1:IsA("LocalScript") and L974_1.Enabled then
						L974_1.Enabled = false
					end

					U627:SetStateEnabled(Enum.HumanoidStateType.Freefall, false)
					U627:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)

					for I330, I331 in ipairs(U627:GetPlayingAnimationTracks()) do
						I331:Stop(0)
					end
				end)

				local L972_5, L972_6 = L972_4.CFrame:ToOrientation()

				if U623 and U623.Parent then
					U623.CFrame = CFrame.fromOrientation(0, L972_6, 0)
				end

				local L972_7 = U65.FlySpeed and U65.FlySpeed.Value or 50
				local L972_8 = UserInputService
				local L972_9 = Vector3.zero

				if not L972_8:GetFocusedTextBox() then
					local L972_10 = UserInputService
					L972_9 = Vector3.zero

					if L972_10:IsKeyDown(Enum.KeyCode.W) then
						L972_9 = Vector3.zero + L972_4.CFrame.LookVector
					end

					if UserInputService:IsKeyDown(Enum.KeyCode.S) then
						L972_9 -= L972_4.CFrame.LookVector
					end

					if UserInputService:IsKeyDown(Enum.KeyCode.A) then
						L972_9 -= L972_4.CFrame.RightVector
					end

					if UserInputService:IsKeyDown(Enum.KeyCode.D) then
						L972_9 += L972_4.CFrame.RightVector
					end

					if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
						L972_9 += Vector3.new(0, 1, 0)
					end

					if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
						L972_9 -= Vector3.new(0, 1, 0)
					end
				end

				if U622 and U622.Parent then
					if L972_9.Magnitude > 0 then
						U622.Velocity = L972_9.Unit * L972_7
					else
						U622.Velocity = Vector3.zero
					end
				end
			end)
		end

		U68.CharacterAdded:Connect(function(A975_1)
			task.spawn(function()
				local L976_1 = A975_1:WaitForChild("Humanoid", 15)
				local L976_2 = A975_1:WaitForChild("HumanoidRootPart", 15)
				if not L976_1 or not L976_2 then
					return
				end
				task.wait(0.2)

				if U65.FOV and U65.FOV.Value then
					U96(U65.FOV.Value)
				end

				if U66.ThirdPersonToggle and U66.ThirdPersonToggle.Value then
					pcall(function()
						U68.CameraMode = Enum.CameraMode.Classic
						U68.CameraMaxZoomDistance = 1000
						U68.CameraMinZoomDistance = 0.5
					end)
				end

				if U66.NoClip and U66.NoClip.Value then
					U97(true)
				end

				if U66.SuperJumpToggle and U66.SuperJumpToggle.Value then
					U98()
				end

				if U66.WalkSpeedToggle and U66.WalkSpeedToggle.Value then
					U99(true)
				end

				if U66.FlyToggle and U66.FlyToggle.Value then
					U100(true)
				end

				if antiExplosionActive and setupAntiExplosion then
					setupAntiExplosion()
				end

				if playerEspEnabled and updateAllPlayerESP then
					updateAllPlayerESP()
				end

				if antiKickActive and restartAntiKick then
					restartAntiKick()
				end
			end)
		end)

		task.spawn(function()
			while true do
				task.wait(0.5)
				local L978_1 = U68.Character
				local L978_2 = L978_1 and L978_1:FindFirstChildOfClass("Humanoid")
				local L978_3 = L978_1 and L978_1:FindFirstChild("HumanoidRootPart")

				if L978_1 and L978_2 and L978_3 and L978_2.Health > 0 then
					if U66.NoClip and U66.NoClip.Value and not U618 then
						U97(true)
					end

					if U66.WalkSpeedToggle and U66.WalkSpeedToggle.Value and not U620 then
						U99(true)
					end

					if U66.FlyToggle and U66.FlyToggle.Value and not U621 then
						U100(true)
					end

					if U66.SuperJumpToggle and U66.SuperJumpToggle.Value then
						local L978_4 = U65.SuperJump and U65.SuperJump.Value or 100
						if L978_2.JumpPower ~= L978_4 and L978_2.JumpHeight ~= L978_4 * 0.144 then
							U98()
							continue
						end
					end
				end
			end
		end)
	end
end

local L0_373, L0_374, U628, U629, U630, U631, U632, U633, U634, U635
local U636, U637

do
	do
		local U638
		U638 = game:GetService("KeyframeSequenceProvider")
		local U639
		U639 = "74987847468722"
		local U640
		U640 = "idle"
		local U641
		U641 = nil
		local U642
		U642 = nil
		local U643
		U643 = nil
		local U644
		U644 = nil
		local U645
		U645 = 0
		local U646
		U646 = 0
		local U647
		U647 = 0
		local U648
		U648 = 0
		local U649
		U649 = 0
		local U650
		U650 = Vector3.zero
		local U651
		U651 = nil
		local U652
		U652 = true
		local U653
		U653 = nil
		local U654
		U654 = nil
		local U655
		U655 = nil
		local U656

		U656 = {
			grass = "rbxassetid://9083837523",
			sand = "rbxassetid://9083846829",
			wastegrass = "rbxassetid://9083849830",
			rock = "rbxassetid://9083855231",
		}

		local U657
		U657 = {}
		local U658
		U658 = {}
		local U659, U660

		do
			local U661 = nil
			U659 = {}

			local U662 = {
				idle = { "idle" },
				walk = { "walk" },
				run = { "run", "sprint" },
				jump = { "jump" },
				fall = { "fall" },
			}

			local function F_000979(A979_1)
				if not A979_1 then
					return nil
				end
				local L979_1 = A979_1:lower()

				for I332, I333 in pairs(U662) do
					for I334, I335 in ipairs(I333) do
						if L979_1:find(I335) then
							return I332
						end
					end
				end

				return nil
			end

			local function F_000980(A980_1)
				if not A980_1 or not A980_1:IsA("KeyframeSequence") then
					return nil
				end
				local L980_1 = {}

				for I336, I337 in ipairs(A980_1:GetChildren()) do
					if I337:IsA("Keyframe") then
						local U663 = { Time = I337.Time, Poses = {} }
						local U664 = nil

						U664 = function(A981_1)
							for I338, I339 in ipairs(A981_1:GetChildren()) do
								if I339:IsA("Pose") then
									U663.Poses[I339.Name] = I339.CFrame
									U664(I339)
								end
							end
						end

						U664(I337)
						table.insert(L980_1, U663)
					end
				end

				table.sort(L980_1, function(A982_1, A982_2)
					return A982_1.Time < A982_2.Time
				end)

				if #L980_1 == 0 then
					return nil
				end
				return { Keyframes = L980_1, Duration = math.max(0.1, L980_1[#L980_1].Time) }
			end

			U660 = function()
				if not U661 then
					local L983_1, L983_2 = pcall(function()
						return game:GetObjects("rbxassetid://" .. U639)
					end)

					if L983_1 and L983_2 and #L983_2 > 0 then
						U661 = L983_2[1]
					end
				end

				if U661 then
					for I340, I341 in ipairs(U661:GetDescendants()) do
						if I341:IsA("KeyframeSequence") then
							local L983_3 = F_000979(I341.Name)

							if L983_3 and not U659[L983_3] then
								U659[L983_3] = F_000980(I341)
							end
						elseif I341:IsA("Animation") then
							local U665 = F_000979(I341.Name) or I341.Parent and F_000979(I341.Parent.Name)

							if U665 and not U659[U665] and I341.AnimationId and I341.AnimationId ~= "" then
								pcall(function()
									local L985_1 = U638:GetKeyframeSequenceAsync(I341.AnimationId)

									if L985_1 then
										U659[U665] = F_000980(L985_1)
									end
								end)
							end
						end
					end
				end

				for I342, I343 in pairs({
					idle = "rbxassetid://129742834441667",
					walk = "rbxassetid://71571120030557",
					run = "rbxassetid://81826955334128",
					jump = "rbxassetid://133493676622480",
					fall = "rbxassetid://71235254431331",
				}) do
					if not U659[I342] then
						pcall(function()
							local L986_1 = U638:GetKeyframeSequenceAsync(I343)

							if L986_1 then
								U659[I342] = F_000980(L986_1)
							end
						end)
					end
				end
			end
		end

		local U666

		do
			local function F_000987(A987_1)
				local L987_1 = {}
				if not A987_1 then
					return L987_1
				end
				local L987_2 = A987_1:FindFirstChild("Torso")
				local L987_3 = A987_1:FindFirstChild("HumanoidRootPart")

				if L987_2 then
					L987_1.Head = L987_2:FindFirstChild("Neck")
					L987_1["Right Arm"] = L987_2:FindFirstChild("Right Shoulder")
					L987_1["Left Arm"] = L987_2:FindFirstChild("Left Shoulder")
					L987_1["Right Leg"] = L987_2:FindFirstChild("Right Hip")
					L987_1["Left Leg"] = L987_2:FindFirstChild("Left Hip")

					if L987_3 then
						L987_1.Torso = L987_3:FindFirstChild("RootJoint")
					end
				else
					local L987_4 = A987_1:FindFirstChild("Head")
					local L987_5 = A987_1:FindFirstChild("UpperTorso")
					local L987_6 = A987_1:FindFirstChild("LowerTorso")
					local L987_7 = A987_1:FindFirstChild("RightUpperArm")
					local L987_8 = A987_1:FindFirstChild("RightLowerArm")
					local L987_9 = A987_1:FindFirstChild("RightHand")
					local L987_10 = A987_1:FindFirstChild("LeftUpperArm")
					local L987_11 = A987_1:FindFirstChild("LeftLowerArm")
					local L987_12 = A987_1:FindFirstChild("LeftHand")
					local L987_13 = A987_1:FindFirstChild("RightUpperLeg")
					local L987_14 = A987_1:FindFirstChild("RightLowerLeg")
					local L987_15 = A987_1:FindFirstChild("RightFoot")
					local L987_16 = A987_1:FindFirstChild("LeftUpperLeg")
					local L987_17 = A987_1:FindFirstChild("LeftLowerLeg")
					local L987_18 = A987_1:FindFirstChild("LeftFoot")

					if L987_4 then
						L987_1.Head = L987_4:FindFirstChild("Neck")
					end

					if L987_5 then
						L987_1.UpperTorso = L987_5:FindFirstChild("Waist")
					end

					if L987_6 then
						L987_1.Torso = L987_6:FindFirstChild("Root")
						L987_1.LowerTorso = L987_6:FindFirstChild("Root")
					end

					if L987_7 then
						L987_1.RightUpperArm = L987_7:FindFirstChild("RightShoulder")
						L987_1["Right Arm"] = L987_7:FindFirstChild("RightShoulder")
					end

					if L987_8 then
						L987_1.RightLowerArm = L987_8:FindFirstChild("RightElbow")
					end

					if L987_9 then
						L987_1.RightHand = L987_9:FindFirstChild("RightWrist")
					end

					if L987_10 then
						L987_1.LeftUpperArm = L987_10:FindFirstChild("LeftShoulder")
						L987_1["Left Arm"] = L987_10:FindFirstChild("LeftShoulder")
					end

					if L987_11 then
						L987_1.LeftLowerArm = L987_11:FindFirstChild("LeftElbow")
					end

					if L987_12 then
						L987_1.LeftHand = L987_12:FindFirstChild("LeftWrist")
					end

					if L987_13 then
						L987_1.RightUpperLeg = L987_13:FindFirstChild("RightHip")
						L987_1["Right Leg"] = L987_13:FindFirstChild("RightHip")
					end

					if L987_14 then
						L987_1.RightLowerLeg = L987_14:FindFirstChild("RightKnee")
					end

					if L987_15 then
						L987_1.RightFoot = L987_15:FindFirstChild("RightAnkle")
					end

					if L987_16 then
						L987_1.LeftUpperLeg = L987_16:FindFirstChild("LeftHip")
						L987_1["Left Leg"] = L987_16:FindFirstChild("LeftHip")
					end

					if L987_17 then
						L987_1.LeftLowerLeg = L987_17:FindFirstChild("LeftKnee")
					end

					if L987_18 then
						L987_1.LeftFoot = L987_18:FindFirstChild("LeftAnkle")
					end
				end

				return L987_1
			end

			local function F_000988(A988_1, A988_2)
				if not A988_1 or not A988_1.Keyframes or #A988_1.Keyframes == 0 then
					return {}
				end
				local L988_1 = A988_1.Keyframes
				local L988_2 = A988_1.Duration
				if #L988_1 == 1 then
					return L988_1[1].Poses
				end
				local L988_3 = A988_2 % L988_2
				local L988_4 = L988_1[1]
				local L988_5 = L988_1[#L988_1]

				for I344 = 1, #L988_1 - 1 do
					if L988_3 >= L988_1[I344].Time and L988_3 <= L988_1[I344 + 1].Time then
						L988_4 = L988_1[I344]
						L988_5 = L988_1[I344 + 1]
						break
					end
				end

				local L988_6 = L988_5.Time - L988_4.Time
				local L988_7 = math.clamp(L988_6 > 0 and (L988_3 - L988_4.Time) / L988_6 or 0, 0, 1)
				local L988_8 = {}

				for I345, I346 in pairs(L988_4.Poses) do
					L988_8[I345] = I346:Lerp(L988_5.Poses[I345] or I346, L988_7)
				end

				for I347, I348 in pairs(L988_5.Poses) do
					if not L988_8[I347] then
						L988_8[I347] = I348
					end
				end

				return L988_8
			end

			U666 = function()
				for I349, I350 in pairs(U657) do
					if I349 and I349.Parent then
						pcall(function()
							I349.C0 = I350
						end)
					end
				end

				table.clear(U657)
				table.clear(U658)
			end

			local function F_000991(A991_1)
				local L991_1 = A991_1 and A991_1:FindFirstChild("HumanoidRootPart")
				if not L991_1 then
					return nil, nil
				end
				local L991_2 = L991_1.Position
				local L991_3 = RaycastParams.new()
				L991_3.FilterDescendantsInstances = { A991_1 }
				L991_3.FilterType = Enum.RaycastFilterType.Exclude
				L991_3.IgnoreWater = true
				local L991_4 = workspace:Raycast(L991_2, Vector3.new(0, -6, 0), L991_3)
				if L991_4 and L991_4.Instance then
					return L991_4.Material, L991_4.Instance.Name
				end
				local L991_5 = A991_1:FindFirstChildOfClass("Humanoid")
				if L991_5 then
					return L991_5.FloorMaterial, nil
				end
				return nil, nil
			end

			local function F_000992(A992_1, A992_2)
				local L992_1 = (A992_2 or ""):lower()
				if L992_1:find("wastegrass") or L992_1:find("waste") then
					return U656.wastegrass
				end

				if L992_1:find("lushgrass") or L992_1:find("grass") then
					return U656.grass
				end

				if L992_1:find("sand") then
					return U656.sand
				end

				if L992_1:find("rock") or L992_1:find("stone") or L992_1:find("marble") or L992_1:find("slate") or L992_1:find("concrete") or L992_1:find("brick") then
					return U656.rock
				end

				if A992_1 then
					if A992_1 == Enum.Material.Grass or A992_1 == Enum.Material.LeafyGrass then
						return U656.grass
					end

					if A992_1 == Enum.Material.Sand then
						return U656.sand
					end

					if A992_1 == Enum.Material.Ground or A992_1 == Enum.Material.Mud then
						return U656.wastegrass
					end

					if A992_1 == Enum.Material.Rock or A992_1 == Enum.Material.Slate or A992_1 == Enum.Material.Basalt or A992_1 == Enum.Material.Limestone or A992_1 == Enum.Material.Concrete or A992_1 == Enum.Material.Brick or A992_1 == Enum.Material.CorrodedMetal or A992_1 == Enum.Material.DiamondPlate or A992_1 == Enum.Material.Metal then
						return U656.rock
					end
				end

				return U656.grass
			end

			local function F_000993(A993_1, A993_2)
				A993_1 = A993_1 and A993_1:FindFirstChild("HumanoidRootPart")
				if not A993_1 then
					return nil
				end

				if not U653 or U653.Parent ~= A993_1 then
					if U653 then
						pcall(function()
							U653:Destroy()
						end)

						U653 = nil
					end

					local L993_1 = Instance.new("Sound")
					L993_1.Name = "ST_CustomFootstep"
					L993_1.Looped = true
					L993_1.Parent = A993_1
					U653 = L993_1
					U655 = nil
				end

				if U655 ~= A993_2 then
					U653.SoundId = A993_2
					U655 = A993_2
				end

				return U653
			end

			local function F_000995()
				if U653 then
					pcall(function()
						U653:Stop()
					end)
				end
			end

			local function F_000997(A997_1, A997_2)
				if A997_2 <= 0 then
					return
				end
				A997_1 = A997_1 and A997_1:FindFirstChild("HumanoidRootPart")
				if not A997_1 then
					return
				end

				if not U654 or U654.Parent ~= A997_1 then
					if U654 then
						pcall(function()
							U654:Destroy()
						end)

						U654 = nil
					end

					local L997_1 = Instance.new("Sound")
					L997_1.Name = "ST_CustomJumpSound"
					L997_1.SoundId = "rbxasset://sounds/action_jump.mp3"
					L997_1.Volume = 0.75 * A997_2
					L997_1.Parent = A997_1
					U654 = L997_1
				end

				U654.Volume = 0.75 * A997_2

				pcall(function()
					U654:Play()
				end)
			end

			local function F_001000(A1000_1)
				if U644 then
					U644:Disconnect()
					U644 = nil
				end

				local U667 = A1000_1:FindFirstChildOfClass("Humanoid")
				if not U667 then
					return
				end
				local U668 = F_000987(A1000_1)

				for I351, I352 in pairs(U668) do
					if I352 and not U657[I352] then
						U657[I352] = I352.C0
					end
				end

				U644 = U69.RenderStepped:Connect(function(A1001_1)
					if not (U66.EnableAnimation and U66.EnableAnimation.Value) then
						return
					end

					if not A1000_1 or not A1000_1.Parent or U667.Health <= 0 then
						return
					end
					local L1001_1 = U659[U640 or "idle"]
					if not L1001_1 then
						return
					end
					U645 += A1001_1
					local L1001_2 = F_000988(L1001_1, U645)

					for I353, I354 in pairs(U668) do
						local U669 = U657[I354]
						local L1001_3 = L1001_2[I353] or CFrame.identity

						if I354 and I354.Parent and U669 then
							U658[I353] = (U658[I353] or L1001_3):Lerp(L1001_3, math.clamp(A1001_1 * 13, 0, 1))

							pcall(function()
								I354.C0 = U669 * cur
							end)
						end
					end
				end)
			end

			local function F_001003(A1003_1)
				if U640 == A1003_1 then
					return
				end
				U640 = A1003_1
				U645 = 0
			end

			local function F_001004(A1004_1)
				if U641 then
					U641:Disconnect()
					U641 = nil
				end

				local U670 = A1004_1:FindFirstChildOfClass("Humanoid")
				local U671 = A1004_1:FindFirstChild("HumanoidRootPart")
				if not U670 or not U671 then
					return
				end

				U641 = U69.Heartbeat:Connect(function()
					if not (U66.EnableAnimation and U66.EnableAnimation.Value) then
						if U641 then
							U641:Disconnect()
							U641 = nil
						end

						return
					end

					if not A1004_1 or not A1004_1.Parent or U670.Health <= 0 then
						if U641 then
							U641:Disconnect()
							U641 = nil
						end

						return
					end

					local L1005_1 = U670.MoveDirection.Magnitude > 0.05
					local L1005_2 = U66.Sprinting and U66.Sprinting.Value and L1005_1
					local L1005_3 = U670.FloorMaterial ~= Enum.Material.Air
					local L1005_4 = (U671.AssemblyLinearVelocity or U671.Velocity).Y
					local L1005_5 = (U65 and U65.AnimSoundEffects and U65.AnimSoundEffects.Value or 100) / 100

					if U652 and not L1005_3 and L1005_4 > 2 then
						U648 = 1.35
						F_000997(A1004_1, L1005_5)
					elseif not U652 and L1005_3 then
						U649 = 0.85
					end

					U652 = L1005_3

					if L1005_5 > 0 and L1005_3 and L1005_1 then
						local L1005_6

						if (U65 and U65.SoundType and U65.SoundType.Value or "Realistic") == "Realistic" then
							local L1005_7, L1005_8 = F_000991(A1004_1)
							L1005_6 = F_000992(L1005_7, L1005_8)
						else
							L1005_6 = "rbxasset://sounds/action_footsteps_plastic.mp3"
						end

						local L1005_9 = F_000993(A1004_1, L1005_6)

						if L1005_9 then
							local L1005_10 = U65.SpeedWhileRunning and U65.SpeedWhileRunning.Value or U65.SpeedWhileRunnings and U65.SpeedWhileRunnings.Value or 32

							if L1005_2 then
								L1005_9.PlaybackSpeed = math.clamp(1 + (L1005_10 - 16) * 0.035, 1.25, 2.2)
								L1005_9.Volume = 0.85 * L1005_5
							else
								L1005_9.PlaybackSpeed = 1
								L1005_9.Volume = 0.65 * L1005_5
							end

							if not L1005_9.IsPlaying then
								L1005_9:Play()
							end
						end
					else
						F_000995()
					end

					local L1005_11

					if not L1005_3 then
						if U640 == "jump" then
							if L1005_4 < -3 then
								L1005_11 = "fall"
							else
								L1005_11 = "jump"
							end
						elseif L1005_4 > 2.5 then
							L1005_11 = "jump"
						else
							L1005_11 = "fall"
						end
					elseif L1005_1 then
						if L1005_2 then
							L1005_11 = "run"
						else
							L1005_11 = "walk"
						end
					else
						L1005_11 = "idle"
					end

					F_001003(L1005_11)
				end)
			end

			local function F_001006(A1006_1, A1006_2, A1006_3)
				local L1006_1 = workspace.CurrentCamera
				if not L1006_1 then
					return
				end
				local L1006_2 = U65 and U65.FOV and U65.FOV.Value or 70
				local L1006_3 = U65 and U65.FovWhileRunning and U65.FovWhileRunning.Value or 88

				if not (A1006_3 and A1006_2) then
					L1006_3 = L1006_2
				end

				if U651 == nil then
					U651 = L1006_1.FieldOfView
				end

				U651 += (L1006_3 - U651) * math.clamp(A1006_1 * 7.5, 0, 1)
				L1006_1.FieldOfView = U651
			end

			local function F_001007(A1007_1)
				if U642 then
					U642:Disconnect()
					U642 = nil
				end

				local U672 = A1007_1:FindFirstChildOfClass("Humanoid")
				local U673 = A1007_1:FindFirstChild("HumanoidRootPart")
				if not U672 or not U673 then
					return
				end

				U642 = U69.RenderStepped:Connect(function(A1008_1)
					if not (U66.EnableAnimation and U66.EnableAnimation.Value or false) or not A1007_1 or not A1007_1.Parent or U672.Health <= 0 then
						if U672 then
							U672.CameraOffset = U672.CameraOffset:Lerp(Vector3.zero, math.clamp(A1008_1 * 12, 0, 1))
						end

						F_001006(A1008_1, false, false)
						return
					end

					local L1008_1 = (U65 and U65.CameraBobbingIntensity and U65.CameraBobbingIntensity.Value or 100) / 100
					local L1008_2 = U672.MoveDirection.Magnitude > 0.05
					local L1008_3 = U66.Sprinting and U66.Sprinting.Value and L1008_2
					local L1008_4 = U672.FloorMaterial ~= Enum.Material.Air
					F_001006(A1008_1, L1008_3, true)

					if U648 > 0 then
						U647 += A1008_1 * 20
						U648 = math.max(0, U648 - A1008_1 * 2.8)
					else
						U647 = 0
					end

					if U649 > 0 then
						U649 = math.max(0, U649 - A1008_1 * 4)
					end

					local L1008_5

					if L1008_4 then
						local L1008_6 = -math.sin(math.clamp(U649 * 3.1415926535897931, 0, 3.1415926535897931)) * 0.65 * L1008_1

						if L1008_2 then
							if L1008_3 then
								U646 += A1008_1 * 16
								L1008_5 = Vector3.new(math.cos(U646) * 0.75 * L1008_1, math.abs(math.sin(U646)) * 0.9 * L1008_1 + L1008_6, 0)
							else
								U646 += A1008_1 * 8.5
								L1008_5 = Vector3.new(math.cos(U646) * 0.16 * L1008_1, math.abs(math.sin(U646)) * 0.2 * L1008_1 + L1008_6, 0)
							end
						else
							L1008_5 = Vector3.new(0, L1008_6, 0)
						end
					else
						local L1008_7 = math.clamp((U673.AssemblyLinearVelocity or U673.Velocity).Y, -70, 70)
						local L1008_8 = U648 * 1.15 * L1008_1
						L1008_5 = Vector3.new(0, math.sin(U647) * L1008_8 + math.clamp(-L1008_7 * 0.022 * L1008_1, -0.75 * L1008_1, 0.75 * L1008_1), 0)
					end

					U650 = U650:Lerp(L1008_5, math.clamp(A1008_1 * 15, 0, 1))
					U672.CameraOffset = U650
				end)
			end

			local function F_001009()
				if U642 then
					U642:Disconnect()
					U642 = nil
				end

				local L1009_1 = U68.Character
				local L1009_2 = L1009_1 and L1009_1:FindFirstChildOfClass("Humanoid")

				if L1009_2 then
					L1009_2.CameraOffset = Vector3.zero
				end

				U650 = Vector3.zero
				U648 = 0
				U649 = 0
				U647 = 0
				local L1009_3 = workspace.CurrentCamera

				if L1009_3 then
					L1009_3.FieldOfView = U65 and U65.FOV and U65.FOV.Value or 70
				end

				U651 = nil
			end

			local function F_001010(A1010_1)
				local U674 = U68.Character
				if not U674 then
					return
				end
				local L1010_1 = U674:FindFirstChildOfClass("Humanoid")

				if A1010_1 then
					task.spawn(function()
						U660()
						F_001000(U674)
						F_001004(U674)
						F_001007(U674)
					end)

					local L1010_2 = U674:FindFirstChild("Animate")

					if L1010_2 and L1010_2:IsA("LocalScript") then
						L1010_2.Enabled = false
					end

					if L1010_1 then
						for I355, I356 in ipairs(L1010_1:GetPlayingAnimationTracks()) do
							pcall(function()
								I356:Stop(0.1)
							end)
						end
					end
				else
					if U644 then
						U644:Disconnect()
						U644 = nil
					end

					if U641 then
						U641:Disconnect()
						U641 = nil
					end

					F_001009()
					F_000995()
					U666()
					local L1010_3 = U674:FindFirstChild("Animate")

					if L1010_3 and L1010_3:IsA("LocalScript") then
						L1010_3.Enabled = true
					end
				end
			end

			local function F_001013(A1013_1)
				if U643 then
					U643:Disconnect()
					U643 = nil
				end

				if not A1013_1 then
					return
				end

				U643 = U69.Heartbeat:Connect(function(A1014_1)
					if not (U66.Sprinting and U66.Sprinting.Value or false) then
						if U643 then
							U643:Disconnect()
							U643 = nil
						end

						return
					end

					local L1014_1 = U68.Character
					local L1014_2 = L1014_1 and L1014_1:FindFirstChildOfClass("Humanoid")
					local L1014_3 = L1014_1 and L1014_1:FindFirstChild("HumanoidRootPart")
					if not L1014_1 or not L1014_2 or not L1014_3 or L1014_2.Health <= 0 then
						return
					end
					local L1014_4 = U65.SpeedWhileRunning and U65.SpeedWhileRunning.Value or U65.SpeedWhileRunnings and U65.SpeedWhileRunnings.Value or 32
					local L1014_5 = L1014_2.MoveDirection

					if L1014_5.Magnitude == 0 and not UserInputService:GetFocusedTextBox() then
						local L1014_6 = workspace.CurrentCamera

						if L1014_6 then
							local L1014_7 = UserInputService
							local L1014_8 = Vector3.zero

							if L1014_7:IsKeyDown(Enum.KeyCode.W) then
								L1014_8 = Vector3.zero + L1014_6.CFrame.LookVector
							end

							if UserInputService:IsKeyDown(Enum.KeyCode.S) then
								L1014_8 -= L1014_6.CFrame.LookVector
							end

							if UserInputService:IsKeyDown(Enum.KeyCode.A) then
								L1014_8 -= L1014_6.CFrame.RightVector
							end

							if UserInputService:IsKeyDown(Enum.KeyCode.D) then
								L1014_8 += L1014_6.CFrame.RightVector
							end

							L1014_5 = Vector3.new(L1014_8.X, 0, L1014_8.Z)
						end
					end

					if L1014_5.Magnitude > 0 then
						L1014_3.CFrame = L1014_3.CFrame + L1014_5.Unit * math.max(0, L1014_4 - 16) * A1014_1
					end
				end)
			end

			U68.CharacterAdded:Connect(function()
				table.clear(U657)
				table.clear(U658)
				U652 = true

				task.delay(0.6, function()
					if U66.EnableAnimation and U66.EnableAnimation.Value then
						F_001010(true)
					end
				end)
			end)

			local L0_375 = U92.Player:AddGroupbox({
				Side = 2,
				Name = "<b>Animations</b>",
				IconName = "person-standing",
				Description = "Idle/Run ect.",
				MaxPopOutHeight = 600,
				PopOutWidth = 250,
			}):AddTabbox({ MaxPopOutHeight = 600 })

			local L0_376 = L0_375:AddTab("<b>Bundles</b>", "package")
			L0_376:AddDivider()

			L0_376:AddToggle("EnableAnimation", {
				Text = "Enable Animation",
				Default = false,
				Callback = function(A1017_1)
					F_001010(A1017_1)
				end,
			})

			L0_376:AddDropdown("AnimationStyle", {
				Text = "Animation Style",
				IconName = "sparkles",
				Default = "Evade",
				Values = { "Evade" },
				ValueImages = { Evade = "zap" },
				Callback = function()
					if U66.EnableAnimation and U66.EnableAnimation.Value then
						F_001010(true)
					end
				end,
			})

			L0_376:AddDivider("Settings")

			L0_376:AddSlider("CameraBobbingIntensity", {
				Text = "Camera Bobbing",
				Default = 100,
				Min = 0,
				Max = 200,
				Rounding = 0,
				Compact = true,
				Suffix = "%",
				Callback = function()
				end,
			})

			L0_376:AddSlider("SpeedWhileRunning", {
				Text = "Speed While Running",
				Default = 32,
				Min = 1,
				Max = 200,
				Rounding = 0,
				Compact = true,
				Callback = function()
				end,
			})

			L0_376:AddSlider("FovWhileRunning", {
				Text = "FOV While Running",
				Default = 88,
				Min = 1,
				Max = 120,
				Rounding = 0,
				Compact = true,
				Callback = function()
				end,
			})

			L0_376:AddDivider()

			L0_376:AddToggle("Sprinting", {
				Text = "Sprinting",
				Default = false,
				Callback = function(A1022_1)
					F_001013(A1022_1)
				end,
			}):AddKeyPicker("SprintingKey", {
				Default = "LeftShift",
				Mode = "Hold",
				SyncToggleState = true,
				Text = "Sprinting Keybind",
				Callback = function(A1023_1)
					F_001013(A1023_1)
				end,
			})

			L0_376:AddDivider("Sounds")

			L0_376:AddDropdown("SoundType", {
				Text = "Sound Type",
				IconName = "volume-2",
				Default = "Realistic",
				Values = { "Realistic", "Default" },
				ValueImages = { Realistic = "sparkles", Default = "audio-lines" },
				Callback = function()
				end,
			})

			L0_376:AddSlider("AnimSoundEffects", {
				Text = "Sound Effects",
				Default = 100,
				Min = 0,
				Max = 100,
				Rounding = 0,
				Compact = true,
				Suffix = "%",
				Callback = function()
				end,
			})

			local U675 = L0_375:AddTab("<b>Emotes</b>", "smile")

			task.spawn(function()
				local L1026_1 = game:GetService("Players")
				local U676 = game:GetService("UserInputService")
				local U677 = game:GetService("RunService")
				local U678 = game:GetService("TweenService")
				local U679 = game:GetService("GuiService")
				local U680 = game:GetService("SoundService")
				local L1026_2 = game:GetService("Lighting")
				local U681 = game:GetService("KeyframeSequenceProvider")
				local U682 = L1026_1.LocalPlayer

				local function F_001027()
					return typeof(gethui) == "function" and gethui() or U682:FindFirstChildOfClass("PlayerGui") or game:GetService("CoreGui")
				end

				local K22 = 210
				local K23 = 72
				local K24 = 138
				local K25 = 96

				local U683 = {
					{
						Name = "Peter Parker",
						AnimationId = "rbxassetid://138803618344014",
						Looped = true,
						CameraOrbit = true,
					},
					{ Name = "Jump Style", AnimationId = "rbxassetid://104602874038663", Looped = true },
					{ Name = "Take The L", AnimationId = "rbxassetid://92332453089300", Looped = true },
					{ Name = "Hold On.", AnimationId = "rbxassetid://135407053078217", Looped = true },
					{
						Name = "RickRoll",
						AnimationId = "rbxassetid://136169400893453",
						Looped = true,
						CameraRise = true,
						MusicUrl = "https://files.catbox.moe/qg0lrl.mp3",
					},
				}

				local U684 = { U683[1], U683[2], U683[3], U683[4], U683[5] }
				local U685 = L1026_2:FindFirstChild("ST_StandaloneEmoteBlur")

				if not U685 then
					U685 = Instance.new("BlurEffect")
					U685.Name = "ST_StandaloneEmoteBlur"
					U685.Size = 0
					U685.Parent = L1026_2
				end

				local function F_001028(A1028_1, A1028_2, A1028_3)
					local L1028_1 = Instance.new("Sound")
					L1028_1.SoundId = A1028_1
					L1028_1.Volume = A1028_2
					L1028_1.PlaybackSpeed = A1028_3
					L1028_1.Parent = U680
					return L1028_1
				end

				local U686 = F_001028("rbxassetid://4982298914", 0.5, 1.05)
				local U687 = F_001028("rbxassetid://4982298914", 0.3, 0.7)
				local U688 = F_001028("rbxassetid://6042053626", 0.15, 1.4)
				local U689 = F_001028("rbxassetid://4590662766", 0.5, 1)

				local function F_001029(A1029_1)
					local L1029_1 = {}
					if not A1029_1 then
						return L1029_1
					end
					local L1029_2 = A1029_1:FindFirstChild("Torso")
					local L1029_3 = A1029_1:FindFirstChild("HumanoidRootPart")

					if L1029_2 then
						L1029_1.Head = L1029_2:FindFirstChild("Neck")
						L1029_1["Right Arm"] = L1029_2:FindFirstChild("Right Shoulder")
						L1029_1["Left Arm"] = L1029_2:FindFirstChild("Left Shoulder")
						L1029_1["Right Leg"] = L1029_2:FindFirstChild("Right Hip")
						L1029_1["Left Leg"] = L1029_2:FindFirstChild("Left Hip")

						if L1029_3 then
							L1029_1.Torso = L1029_3:FindFirstChild("RootJoint")
						end
					else
						local L1029_4 = A1029_1:FindFirstChild("UpperTorso")
						local L1029_5 = A1029_1:FindFirstChild("LowerTorso")
						local L1029_6 = A1029_1:FindFirstChild("Head")

						if L1029_6 and L1029_4 then
							L1029_1.Head = L1029_6:FindFirstChild("Neck")
						end

						if L1029_4 and L1029_3 then
							L1029_1.UpperTorso = L1029_4:FindFirstChild("Root") or L1029_4:FindFirstChild("Waist")
						end

						if L1029_5 and L1029_4 then
							L1029_1.LowerTorso = L1029_5:FindFirstChild("Waist")
						end
					end

					return L1029_1
				end

				local function F_001030(A1030_1)
					if not A1030_1 or not A1030_1:IsA("KeyframeSequence") then
						return nil
					end
					local L1030_1 = {}

					for I357, I358 in ipairs(A1030_1:GetChildren()) do
						if I358:IsA("Keyframe") then
							local U690 = { Time = I358.Time, Poses = {} }
							local U691 = nil

							U691 = function(A1031_1)
								for I359, I360 in ipairs(A1031_1:GetChildren()) do
									if I360:IsA("Pose") then
										U690.Poses[I360.Name] = I360.CFrame
										U691(I360)
									end
								end
							end

							U691(I358)
							table.insert(L1030_1, U690)
						end
					end

					table.sort(L1030_1, function(A1032_1, A1032_2)
						return A1032_1.Time < A1032_2.Time
					end)

					if #L1030_1 == 0 then
						return nil
					end
					return { Keyframes = L1030_1, Duration = math.max(0.1, L1030_1[#L1030_1].Time) }
				end

				local function F_001033(A1033_1, A1033_2)
					if not A1033_1 or not A1033_1.Keyframes or #A1033_1.Keyframes == 0 then
						return {}
					end
					local L1033_1 = A1033_1.Keyframes
					local L1033_2 = A1033_1.Duration
					if #L1033_1 == 1 then
						return L1033_1[1].Poses
					end
					local L1033_3 = A1033_2 % L1033_2
					local L1033_4 = L1033_1[1]
					local L1033_5 = L1033_1[#L1033_1]

					for I361 = 1, #L1033_1 - 1 do
						if L1033_3 >= L1033_1[I361].Time and L1033_3 <= L1033_1[I361 + 1].Time then
							L1033_4 = L1033_1[I361]
							L1033_5 = L1033_1[I361 + 1]
							break
						end
					end

					local L1033_6 = L1033_5.Time - L1033_4.Time
					local L1033_7 = math.clamp(L1033_6 > 0 and (L1033_3 - L1033_4.Time) / L1033_6 or 0, 0, 1)
					local L1033_8 = {}

					for I362, I363 in pairs(L1033_4.Poses) do
						L1033_8[I362] = I363:Lerp(L1033_5.Poses[I362] or I363, L1033_7)
					end

					for I364, I365 in pairs(L1033_5.Poses) do
						if not L1033_8[I364] then
							L1033_8[I364] = I365
						end
					end

					return L1033_8
				end

				local U692 = {}
				local U693 = {}
				local U694 = { 6830462326, 80439718712779 }

				local function F_001034()
					for I366, I367 in ipairs(U694) do
						if not U692[I367] then
							pcall(function()
								local L1035_1 = game:GetObjects("rbxassetid://" .. I367)

								if L1035_1 and #L1035_1 > 0 then
									local U695 = L1035_1[1]

									pcall(function()
										U695.Parent = game:GetService("ReplicatedStorage")
									end)

									U692[I367] = U695
								end
							end)
						end
					end

					return U692
				end

				local function F_001037(A1037_1)
					if U693[A1037_1.Name] then
						return U693[A1037_1.Name]
					end
					F_001034()

					for I368, I369 in pairs(U692) do
						for I370, I371 in ipairs(I369:GetDescendants()) do
							if I371:IsA("KeyframeSequence") then
								local L1037_1 = I371.Name:lower()
								local L1037_2 = A1037_1.Name:lower():sub(1, 4)

								if L1037_1:find(L1037_2) or A1037_1.Name == "Hold On." and (L1037_1:find("hold") or I371.Parent and I371.Parent.Name == "AnimSaves") then
									local L1037_3 = F_001030(I371)

									if L1037_3 then
										L1037_3.Looped = A1037_1.Looped
										U693[A1037_1.Name] = L1037_3
										return L1037_3
									end
								end
							end
						end
					end

					if A1037_1.AnimationId and A1037_1.AnimationId ~= "" then
						pcall(function()
							local L1038_1 = U681:GetKeyframeSequenceAsync(A1037_1.AnimationId)

							if L1038_1 then
								local L1038_2 = F_001030(L1038_1)

								if L1038_2 then
									L1038_2.Looped = A1037_1.Looped
									U693[A1037_1.Name] = L1038_2
								end
							end
						end)
					end

					return U693[A1037_1.Name]
				end

				task.spawn(function()
					for I372, I373 in ipairs(U684) do
						pcall(F_001037, I373)
					end
				end)

				local K26 = 0.5
				local K27 = 8
				local K28 = 0.5
				local K29 = 12
				local K30 = 4
				local U696 = Color3.fromRGB(255, 255, 255)
				local K31 = 0.45
				local U697 = nil
				local U698 = nil
				local U699 = false

				local function F_001040()
					if U698 and U698.Parent then
						return U698
					end
					local L1040_1 = Instance.new("ScreenGui")
					L1040_1.Name = "ST_ScreenFlashGui"
					L1040_1.ResetOnSpawn = false
					L1040_1.IgnoreGuiInset = true
					L1040_1.DisplayOrder = 1000
					L1040_1.Parent = F_001027()
					local L1040_2 = Instance.new("Frame")
					L1040_2.Size = UDim2.fromScale(1, 1)
					L1040_2.BackgroundColor3 = U696
					L1040_2.BackgroundTransparency = 1
					L1040_2.BorderSizePixel = 0
					L1040_2.ZIndex = 1
					L1040_2.Parent = L1040_1
					U697 = L1040_1
					U698 = L1040_2
					return L1040_2
				end

				local function F_001041()
					if not U699 then
						return
					end
					local U700 = F_001040()

					pcall(function()
						local L1042_1 = { BackgroundTransparency = K31 }
						U678:Create(U700, TweenInfo.new(0.12, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), L1042_1):Play()
					end)

					task.delay(0.12, function()
						if not U699 then
							return
						end

						pcall(function()
							U678:Create(U700, TweenInfo.new(0.35, Enum.EasingStyle.Sine, Enum.EasingDirection.In), { BackgroundTransparency = 1 }):Play()
						end)
					end)
				end

				local function F_001045()
					U699 = true
					F_001040()
				end

				local function F_001046()
					U699 = false

					if U698 then
						pcall(function()
							U678:Create(U698, TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), { BackgroundTransparency = 1 }):Play()
						end)
					end
				end

				local K32 = 0.3
				local K33 = 0.65
				local K34 = 0.12
				local K35 = 10
				local K36 = 18
				local K37 = 0.3
				local K38 = true
				local K39 = 0.78239608801956
				local U701 = {}

				local L1026_3 = {
					u0 = 0,
					u1 = 0.55,
					bottom = { slant = 0.4532 },
					dir = Vector2.new(-1, 0),
					bg = Color3.fromRGB(246, 246, 246),
					focus = "Head",
					camOffset = Vector3.new(0.9, 0.25, -1),
					camDist = 3,
					fov = 30,
				}

				local L1026_4 = {
					u0 = 0.55,
					u1 = 1,
					bottom = { slant = 0.4532 },
					dir = Vector2.new(0, -1),
					bg = Color3.fromRGB(226, 226, 226),
					focus = "UpperBody",
					camOffset = Vector3.new(-0.4, 0.3, 1),
					camDist = 7,
					fov = 40,
				}

				local L1026_5 = {
					u0 = 0.415,
					u1 = 1,
					top = { slant = 0.4532 },
					bottom = { flat = 0.7427 },
					dir = Vector2.new(1, 0),
					bg = Color3.fromRGB(240, 240, 240),
					focus = "Root",
					camOffset = Vector3.new(1, -0.3, -1.6),
					camDist = 13,
					fov = 40,
				}

				local L1026_6 = {
					u0 = 0,
					u1 = 0.415,
					top = { slant = 0.4532 },
					bottom = { slant = 0.771 },
					dir = Vector2.new(-1, 0),
					bg = Color3.fromRGB(230, 230, 230),
					focus = "UpperBody",
					camOffset = Vector3.new(-2.2, 0.4, -1.4),
					camDist = 5,
					fov = 42,
				}

				local L1026_7 = {
					u0 = 0,
					u1 = 0.415,
					top = { slant = 0.771 },
					dir = Vector2.new(0, 1),
					bg = Color3.fromRGB(248, 248, 248),
					focus = "LeftLeg",
					camOffset = Vector3.new(1.6, -0.2, -1.4),
					camDist = 4,
					fov = 30,
				}

				local L1026_8 = {
					u0 = 0.415,
					u1 = 1,
					top = { flat = 0.7427 },
					dir = Vector2.new(0, 1),
					bg = Color3.fromRGB(232, 232, 232),
					focus = "RightLeg",
					camOffset = Vector3.new(-1.6, -0.2, -1.4),
					camDist = 4,
					fov = 30,
				}

				U701[1] = L1026_3
				U701[2] = L1026_4
				U701[3] = L1026_5
				U701[4] = L1026_6
				U701[5] = L1026_7
				U701[6] = L1026_8
				local U702 = 0
				local U703 = 0
				local U704 = nil
				local U705 = nil
				local U706 = nil
				local U707 = nil
				local U708 = {}
				local U709 = nil
				local U710 = false
				local U711 = false

				local function F_001048(A1048_1, A1048_2)
					if not A1048_1 then
						return nil
					end

					if A1048_2 == "Head" then
						return A1048_1:FindFirstChild("Head")
					end

					if A1048_2 == "UpperBody" then
						return A1048_1:FindFirstChild("UpperTorso") or A1048_1:FindFirstChild("Torso")
					end

					if A1048_2 == "LeftLeg" then
						return A1048_1:FindFirstChild("LeftLowerLeg") or A1048_1:FindFirstChild("Left Leg") or A1048_1:FindFirstChild("LeftUpperLeg")
					end

					if A1048_2 == "RightLeg" then
						return A1048_1:FindFirstChild("RightLowerLeg") or A1048_1:FindFirstChild("Right Leg") or A1048_1:FindFirstChild("RightUpperLeg")
					end
					return A1048_1:FindFirstChild("HumanoidRootPart")
				end

				local function F_001049(A1049_1, A1049_2, A1049_3, A1049_4, A1049_5, A1049_6)
					local L1049_1 = -K37 * A1049_4 / A1049_3
					local L1049_2 = math.atan(L1049_1)
					local L1049_3 = math.cos(L1049_2)
					local L1049_4 = math.sin(L1049_2)
					local L1049_5 = A1049_4 / 720
					local L1049_6 = K35 * L1049_5
					local L1049_7 = K36 * L1049_5 / 2
					local L1049_8 = A1049_5 * L1049_5
					local L1049_9 = A1049_2.u0 <= 0 and L1049_6 or A1049_2.u0 * A1049_3 + L1049_7
					local L1049_10 = A1049_2.u1 >= 1 and A1049_3 - L1049_6 or A1049_2.u1 * A1049_3 - L1049_7
					local L1049_11 = L1049_9 - L1049_8
					local L1049_12 = L1049_10 + L1049_8
					local L1049_13 = L1049_12 - L1049_11
					local L1049_14 = A1049_2.top
					local L1049_15 = A1049_2.bottom
					local L1049_16, L1049_17

					if not L1049_14 then
						L1049_16 = L1049_6 - L1049_8
						L1049_17 = nil
					elseif L1049_14.flat then
						L1049_16 = L1049_14.flat * A1049_4 + L1049_7 - L1049_8
						L1049_17 = nil
					else
						L1049_17 = L1049_14.slant * A1049_4 + (L1049_7 - L1049_8) / L1049_3
						L1049_16 = L1049_17 + L1049_1 * L1049_12
					end

					local L1049_18, L1049_19

					if not L1049_15 then
						L1049_18 = A1049_4 - L1049_6 + L1049_8
						L1049_19 = nil
					elseif L1049_15.flat then
						L1049_18 = L1049_15.flat * A1049_4 - L1049_7 + L1049_8
						L1049_19 = nil
					else
						L1049_19 = L1049_15.slant * A1049_4 - (L1049_7 - L1049_8) / L1049_3
						L1049_18 = L1049_19 + L1049_1 * L1049_11
					end

					local L1049_20 = L1049_18 - L1049_16
					local L1049_21 = Instance.new("CanvasGroup")
					L1049_21.BackgroundTransparency = 1
					L1049_21.BorderSizePixel = 0
					L1049_21.ClipsDescendants = true
					L1049_21.Position = UDim2.fromOffset(L1049_11, L1049_16)
					L1049_21.Size = UDim2.fromOffset(L1049_13, L1049_20)
					L1049_21.Parent = A1049_1
					local L1049_22 = A1049_6((L1049_17 ~= nil or L1049_19 ~= nil) and -L1049_2 or 0)

					if L1049_17 or L1049_19 then
						L1049_17 = L1049_17 or L1049_16 - L1049_1 * L1049_11 - 4
						L1049_19 = L1049_19 or L1049_18 - L1049_1 * L1049_12 + 4
						local L1049_23 = (L1049_19 - L1049_17) * L1049_3
						local L1049_24 = (L1049_13 * L1049_3 + L1049_20 * math.abs(L1049_4)) * 1.05 + 60
						local L1049_25 = L1049_11 + L1049_13 / 2
						local L1049_26 = (L1049_17 + L1049_19) / 2 + L1049_1 * L1049_25
						local L1049_27 = Instance.new("CanvasGroup")
						L1049_27.BackgroundTransparency = 1
						L1049_27.BorderSizePixel = 0
						L1049_27.AnchorPoint = Vector2.new(0.5, 0.5)
						L1049_27.Position = UDim2.fromOffset(L1049_25 - L1049_11, L1049_26 - L1049_16)
						L1049_27.Size = UDim2.fromOffset(L1049_24, L1049_23)
						L1049_27.Rotation = math.deg(L1049_2)
						L1049_27.Parent = L1049_21
						local L1049_28 = L1049_11 + L1049_13 / 2 - L1049_25
						local L1049_29 = L1049_16 + L1049_20 / 2 - L1049_26
						L1049_22.AnchorPoint = Vector2.new(0.5, 0.5)
						L1049_22.Position = UDim2.fromOffset(L1049_24 / 2 + L1049_3 * L1049_28 + L1049_4 * L1049_29, L1049_23 / 2 + -L1049_4 * L1049_28 + L1049_3 * L1049_29)
						L1049_22.Size = UDim2.fromOffset((L1049_13 * L1049_3 + L1049_20 * math.abs(L1049_4)) * 1.03 + 4, (L1049_20 * L1049_3 + L1049_13 * math.abs(L1049_4)) * 1.03 + 4)
						L1049_22.Rotation = 0
						L1049_22.Parent = L1049_27
					else
						L1049_22.Size = UDim2.fromScale(1, 1)
						L1049_22.Parent = L1049_21
					end

					return L1049_21, L1049_22
				end

				local function F_001050()
					U710 = false
					U711 = false
					U703 = 0

					if U709 then
						U709:Disconnect()
						U709 = nil
					end

					for I374, I375 in ipairs(U708) do
						pcall(function()
							if I375.wrap then
								I375.wrap:Destroy()
							end
						end)
					end

					table.clear(U708)

					if U704 then
						pcall(function()
							U704:Destroy()
						end)

						U704 = nil
						U707 = nil
						U705 = nil
						U706 = nil
					end
				end

				local function F_001053()
					if not U710 then
						F_001050()
						return
					end
					U710 = false

					if U709 then
						U709:Disconnect()
						U709 = nil
					end

					for I376, I377 in ipairs(U708) do
						if I377.wrap then
							pcall(function()
								U678:Create(I377.wrap, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { Position = UDim2.fromOffset(I377.offset.X, I377.offset.Y) }):Play()
							end)
						end
					end

					if U705 then
						pcall(function()
							U678:Create(U705, TweenInfo.new(0.3), { BackgroundTransparency = 1 }):Play()
						end)
					end

					if U706 then
						pcall(function()
							U678:Create(U706, TweenInfo.new(0.3), { BackgroundTransparency = 1 }):Play()
						end)
					end

					task.delay(K32 + 0.08, function()
						F_001050()
					end)
				end

				local function F_001058(A1058_1)
					if not U710 or U711 then
						return
					end
					U711 = true
					local L1058_1 = workspace.CurrentCamera
					local U712 = (L1058_1 and L1058_1.ViewportSize.Y or 1080) * 1.25

					if U706 then
						pcall(function()
							U678:Create(U706, TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), { BackgroundTransparency = 1 }):Play()
						end)
					end

					if U705 then
						pcall(function()
							U678:Create(U705, TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), { BackgroundTransparency = 1 }):Play()
						end)
					end

					for I378, I379 in ipairs(U708) do
						task.delay((I378 - 1) * K34, function()
							if A1058_1 ~= U702 or not I379.wrap or not I379.wrap.Parent then
								return
							end

							pcall(function()
								U678:Create(I379.wrap, TweenInfo.new(0.65, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { Position = UDim2.fromOffset(0, U712) }):Play()
							end)
						end)
					end

					task.delay((#U708 - 1) * K34 + K33 + 0.1, function()
						if A1058_1 ~= U702 then
							return
						end
						F_001050()
					end)
				end

				local function F_001064()
					if not U710 or U711 then
						return
					end
					U703 += 1
					local U713 = U708[U703]
					if not U713 then
						return
					end

					pcall(function()
						if U703 == 1 then
							if U705 then
								U678:Create(U705, TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), { BackgroundTransparency = 0.35 }):Play()
							end

							if U706 then
								U678:Create(U706, TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), { BackgroundTransparency = 0 }):Play()
							end
						end

						U678:Create(U713.wrap, TweenInfo.new(0.55, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Position = UDim2.fromOffset(0, 0) }):Play()
					end)
				end

				local function F_001066(A1066_1)
					F_001050()
					if not A1066_1 then
						return
					end
					local U714 = A1066_1.Archivable

					pcall(function()
						A1066_1.Archivable = true
					end)

					local U715 = A1066_1:Clone()

					pcall(function()
						A1066_1.Archivable = U714
					end)

					if not U715 then
						return
					end

					for I380, I381 in ipairs(U715:GetDescendants()) do
						if I381:IsA("BaseScript") or I381:IsA("Sound") or I381:IsA("BillboardGui") or I381:IsA("ForceField") then
							pcall(function()
								I381:Destroy()
							end)
						elseif I381:IsA("BasePart") then
							I381.Anchored = false
							I381.CanCollide = false
							I381.CanTouch = false
							I381.CanQuery = false
						end
					end

					local U716 = U715:FindFirstChildOfClass("Humanoid")

					if U716 then
						pcall(function()
							U716.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
						end)

						pcall(function()
							U716.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
						end)

						pcall(function()
							U716.EvaluateStateMachine = false
						end)

						pcall(function()
							U716.PlatformStand = true
						end)
					end

					local L1066_1 = U715:FindFirstChild("HumanoidRootPart")
					if not L1066_1 then
						U715:Destroy()
						return
					end
					L1066_1.Anchored = true
					local L1066_2 = F_001029(A1066_1)
					local L1066_3 = F_001029(U715)

					for I382, I383 in pairs(L1066_2) do
						local U717 = L1066_3[I382]

						if I383 and U717 then
							pcall(function()
								U717.C0 = I383.C0
							end)
						end
					end

					local L1066_4 = workspace.CurrentCamera
					L1066_4 = L1066_4 and L1066_4.ViewportSize or Vector2.new(1280, 720)
					local L1066_5 = L1066_4.X
					local L1066_6 = L1066_4.Y

					if not K38 then
						local L1066_7 = L1066_6 * K39

						if not (L1066_5 < L1066_7) then
							L1066_5 = L1066_7
						else
							L1066_6 = L1066_5 / K39
						end
					end

					U704 = Instance.new("ScreenGui")
					U704.Name = "ST_MangaPanelsGui"
					U704.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
					U704.ResetOnSpawn = false
					U704.IgnoreGuiInset = true
					U704.DisplayOrder = 900
					U704.Parent = F_001027()
					U705 = Instance.new("Frame")
					U705.Name = "Backdrop"
					U705.Size = UDim2.fromScale(1, 1)
					U705.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
					U705.BackgroundTransparency = 1
					U705.BorderSizePixel = 0
					U705.ZIndex = 1
					U705.Parent = U704
					U706 = Instance.new("Frame")
					U706.Name = "Page"
					U706.AnchorPoint = Vector2.new(0.5, 0.5)
					U706.Position = UDim2.fromScale(0.5, 0.5)
					U706.Size = UDim2.fromOffset(L1066_5, L1066_6)
					U706.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					U706.BackgroundTransparency = 1
					U706.BorderSizePixel = 0
					U706.ZIndex = 2
					U706.Parent = U704
					U707 = Instance.new("Frame")
					U707.Name = "MangaContainer"
					U707.Size = UDim2.fromScale(1, 1)
					U707.BackgroundTransparency = 1
					U707.BorderSizePixel = 0
					U707.ZIndex = 2
					U707.Parent = U706
					U708 = {}

					for I384, I385 in ipairs(U701) do
						local L1066_8 = Vector2.new(I385.dir.X * L1066_5, I385.dir.Y * L1066_6)
						local L1066_9 = Instance.new("Frame")
						L1066_9.Name = "Panel" .. I384
						L1066_9.Size = UDim2.fromScale(1, 1)
						L1066_9.BackgroundTransparency = 1
						L1066_9.BorderSizePixel = 0
						L1066_9.Position = UDim2.fromOffset(L1066_8.X, L1066_8.Y)
						L1066_9.Parent = U707

						F_001049(L1066_9, I385, L1066_5, L1066_6, 4, function()
							local L1075_1 = Instance.new("Frame")
							L1075_1.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
							L1075_1.BorderSizePixel = 0
							return L1075_1
						end)

						local U718 = nil

						F_001049(L1066_9, I385, L1066_5, L1066_6, 0, function(A1076_1)
							local L1076_1 = Instance.new("ViewportFrame")
							L1076_1.Size = UDim2.fromScale(1, 1)
							L1076_1.BackgroundColor3 = I385.bg
							L1076_1.BackgroundTransparency = 0
							L1076_1.BorderSizePixel = 0
							L1076_1.Ambient = Color3.fromRGB(200, 200, 200)
							L1076_1.LightColor = Color3.fromRGB(255, 255, 255)
							L1076_1.LightDirection = Vector3.new(0.3, -0.5, 1)
							local L1076_2 = Instance.new("WorldModel")
							L1076_2.Parent = L1076_1
							local L1076_3 = U715:Clone()
							L1076_3.Parent = L1076_2
							U718 = L1076_3
							local L1076_4 = L1076_3:FindFirstChild("HumanoidRootPart")
							local L1076_5 = F_001048(L1076_3, I385.focus) or L1076_4
							local L1076_6 = Instance.new("Camera")
							L1076_6.FieldOfView = I385.fov

							if L1076_5 then
								L1076_4 = L1076_4 and L1076_4.CFrame or CFrame.new()
								local L1076_7 = I385.camDist
								L1076_6.CFrame = CFrame.lookAt(L1076_5.Position + L1076_4:VectorToWorldSpace(I385.camOffset.Unit) * L1076_7, L1076_5.Position) * CFrame.Angles(0, 0, A1076_1 or 0)
							end

							L1076_6.Parent = L1076_1
							L1076_1.CurrentCamera = L1076_6
							return L1076_1
						end)

						table.insert(U708, { wrap = L1066_9, offset = L1066_8, model = U718, motors = F_001029(U718) })
					end

					U715:Destroy()
					U710 = true
					U703 = 0
					F_001064()

					U709 = U677.RenderStepped:Connect(function()
						if not U710 then
							return
						end
						local L1077_1 = U682.Character
						if not L1077_1 then
							return
						end
						local L1077_2 = F_001029(L1077_1)

						for I386, I387 in ipairs(U708) do
							for I388, I389 in pairs(I387.motors) do
								local U719 = L1077_2[I388]

								if U719 and I389 then
									pcall(function()
										I389.C0 = U719.C0
									end)
								end
							end
						end
					end)
				end

				local U720 = nil
				local U721 = nil
				local U722 = 70

				local function F_001079()
					if U720 then
						U720:Disconnect()
						U720 = nil
						local L1079_1 = workspace.CurrentCamera

						if L1079_1 then
							L1079_1.FieldOfView = U722
							L1079_1.CameraType = Enum.CameraType.Custom
						end
					end

					if U721 then
						pcall(function()
							U721:Destroy()
						end)

						U721 = nil
					end

					F_001046()
					U702 += 1
					F_001053()
				end

				local function F_001081(A1081_1, A1081_2)
					F_001079()
					local U723 = workspace.CurrentCamera
					if not U723 or not A1081_1 then
						return
					end
					U722 = U723.FieldOfView
					local U724 = U722
					local U725 = 1
					local U726 = 0
					local U727 = tick()
					local U728 = Instance.new("Sound")
					U728.SoundId = "rbxassetid://9114175176"
					U728.Volume = 0.5
					U728.Parent = U680
					U721 = U728
					F_001045()
					U723.CameraType = Enum.CameraType.Scriptable

					U720 = U677.RenderStepped:Connect(function(A1082_1)
						local L1082_1 = A1081_1:FindFirstChild("HumanoidRootPart")
						if not A1081_1.Parent or not L1082_1 or not A1081_2 or A1081_2.Health <= 0 then
							F_001079()
							return
						end
						local L1082_2 = tick()

						if L1082_2 - U727 >= K26 then
							U727 = L1082_2
							U728:Play()
							F_001041()
							F_001064()
						end

						local L1082_3 = L1082_2 - U727
						local L1082_4

						if L1082_3 <= 0.25 then
							local L1082_5 = math.sin(L1082_3 / 0.25 * 3.1415926535897931 * 0.5)
							L1082_4 = (K27 * (1 - L1082_5) + K28 * L1082_5) / K27
						else
							local L1082_6 = math.sin((L1082_3 - 0.25) / 0.25 * 3.1415926535897931 * 0.5)
							L1082_4 = (K28 * (1 - L1082_6) + K27 * L1082_6) / K27
						end

						U724 = math.lerp(U724, 50, A1082_1 * 2.5)
						U723.FieldOfView = U724
						U725 = math.lerp(U725, L1082_4, A1082_1 * 10)
						U726 += A1082_1 * K27 * U725
						local L1082_7 = L1082_1.Position
						U723.CFrame = CFrame.new(L1082_1.Position + Vector3.new(math.cos(U726) * K29, 4, math.sin(U726) * K29), L1082_7 + Vector3.new(0, K30 * 0.5, 0))
					end)
				end

				local K40 = 4
				local K41 = 6.5
				local K42 = 4.6
				local U729 = -2.6
				local K43 = 1.9
				local U730 = -2.7
				local K44 = 1.6
				local K45 = 55
				local K46 = 38

				local function F_001083(A1083_1, A1083_2)
					F_001079()
					local U731 = workspace.CurrentCamera
					if not U731 or not A1083_1 then
						return
					end
					U722 = U731.FieldOfView
					U731.CameraType = Enum.CameraType.Scriptable
					local U732 = 0

					U720 = U677.RenderStepped:Connect(function(A1084_1)
						local L1084_1 = A1083_1:FindFirstChild("HumanoidRootPart")
						if not A1083_1.Parent or not L1084_1 or not A1083_2 or A1083_2.Health <= 0 then
							F_001079()
							return
						end
						U732 += A1084_1
						local L1084_2 = 0.5 - 0.5 * math.cos(math.clamp(U732 / K40, 0, 1) * 3.1415926535897931)
						local L1084_3 = math.max(0, U732 - K40) * 0.10471975511965978
						local L1084_4 = math.rad(38) + L1084_3
						local L1084_5 = K41 + (K42 - K41) * L1084_2
						local L1084_6 = U729 + (K43 - U729) * L1084_2
						local L1084_7 = U730 + (K44 - U730) * L1084_2
						local L1084_8 = L1084_1.CFrame
						local L1084_9 = Vector3.new(math.sin(L1084_4), 0, -math.cos(L1084_4))
						local L1084_10 = L1084_8:VectorToWorldSpace(L1084_9)
						U731.CFrame = CFrame.lookAt(L1084_1.Position + Vector3.new(L1084_10.X, 0, L1084_10.Z).Unit * L1084_5 + Vector3.new(0, L1084_6, 0), L1084_1.Position + Vector3.new(0, L1084_7, 0)) * CFrame.Angles(0, 0, math.rad(9))
						U731.FieldOfView = K45 + (K46 - K45) * L1084_2
					end)
				end

				local U733 = nil
				local U734 = 0
				local U735 = nil
				local U736 = {}
				local U737 = {}
				local U738 = nil
				local U739 = nil

				local function F_001085()
					F_001079()

					if U735 then
						U735:Disconnect()
						U735 = nil
					end

					if U738 then
						pcall(function()
							U738:Stop()
						end)

						U738 = nil
					end

					for I390, I391 in pairs(U736) do
						if I390 and I390.Parent then
							pcall(function()
								I390.C0 = I391
							end)
						end
					end

					table.clear(U736)
					table.clear(U737)

					if U739 then
						pcall(function()
							U739:Stop()
							U739:Destroy()
						end)

						U739 = nil
					end

					U733 = nil
					U734 = 0
				end

				local function F_001089(A1089_1)
					local U740 = U684[A1089_1]
					if not U740 then
						return
					end
					local U741 = U682.Character
					local U742 = U741 and U741:FindFirstChildOfClass("Humanoid")
					if not U742 or U742.Health <= 0 then
						return
					end
					F_001085()

					if U740.MusicUrl then
						pcall(function()
							local U743 = Instance.new("Sound")
							U743.SoundId = U740.MusicUrl
							U743.Volume = 0.7
							U743.Looped = true
							U743.RollOffMaxDistance = 0
							U743.Parent = U680

							task.delay(0.5, function()
								pcall(function()
									U743:Play()
								end)
							end)

							U739 = U743
						end)
					end

					if U740.CameraOrbit then
						F_001081(U741, U742)
						U702 += 1
						local U744 = U702

						task.delay(2, function()
							if U744 ~= U702 then
								return
							end
							local L1093_1 = U682.Character

							if L1093_1 and U720 then
								F_001066(L1093_1)

								task.delay(3, function()
									if U744 ~= U702 then
										return
									end
									F_001058(U744)
								end)
							end
						end)
					end

					if U740.CameraRise then
						F_001083(U741, U742)
					end

					local L1089_1 = F_001037(U740)

					if L1089_1 then
						U733 = L1089_1
						U734 = 0
						local U745 = F_001029(U741)

						for I392, I393 in pairs(U745) do
							if I393 and not U736[I393] then
								U736[I393] = I393.C0
							end
						end

						U735 = U677.RenderStepped:Connect(function(A1095_1)
							if not U733 or not U741 or not U741.Parent or U742.Health <= 0 then
								F_001085()
								return
							end
							U734 += A1095_1
							local L1095_1 = U734

							if U733.Looped then
								L1095_1 = U734 % U733.Duration
							elseif U733.Duration < U734 then
								F_001085()
								return
							end

							local L1095_2 = F_001033(U733, L1095_1)

							for I394, I395 in pairs(U745) do
								local U746 = U736[I395]
								local L1095_3 = L1095_2[I394] or CFrame.identity

								if I395 and I395.Parent and U746 then
									local U747 = (U737[I394] or L1095_3):Lerp(L1095_3, math.clamp(A1095_1 * 18, 0, 1))
									U737[I394] = U747

									pcall(function()
										I395.C0 = U746 * U747
									end)
								end
							end
						end)

						return
					end

					local U748 = U742:FindFirstChildOfClass("Animator") or U742:WaitForChild("Animator", 2)
					local U749 = Instance.new("Animation")
					U749.AnimationId = U740.AnimationId
					local U750 = nil

					if U748 then
						pcall(function()
							U750 = U748:LoadAnimation(U749)
						end)
					end

					if not U750 then
						pcall(function()
							U750 = U742:LoadAnimation(U749)
						end)
					end

					if U750 then
						U750.Priority = Enum.AnimationPriority.Action4
						U750.Looped = U740.Looped == true
						U750:Play(0.1)
						U738 = U750

						U750.Stopped:Connect(function()
							if U738 == U750 then
								F_001085()
							end
						end)
					end
				end

				local function F_001100(A1100_1)
					F_001085()

					A1100_1:WaitForChild("Humanoid").Running:Connect(function(A1101_1)
						if A1101_1 > 0.5 then
							F_001085()
						end
					end)
				end

				if U682.Character then
					task.spawn(F_001100, U682.Character)
				end

				U682.CharacterAdded:Connect(F_001100)
				local L1026_9 = F_001027()
				local U751 = L1026_9:FindFirstChild("StandaloneEmoteGui")

				if U751 then
					pcall(function()
						U751:Destroy()
					end)
				end

				local U752 = Instance.new("ScreenGui")
				U752.Name = "StandaloneEmoteGui"
				U752.ResetOnSpawn = false
				U752.IgnoreGuiInset = true
				U752.DisplayOrder = 999
				U752.Parent = L1026_9
				local U753 = Instance.new("TextButton")
				U753.Size = UDim2.fromScale(1, 1)
				U753.BackgroundColor3 = Color3.new(0, 0, 0)
				U753.BackgroundTransparency = 1
				U753.Text = ""
				U753.AutoButtonColor = false
				U753.ZIndex = 1
				U753.Visible = false
				U753.Parent = U752
				local U754 = Instance.new("Frame")
				U754.AnchorPoint = Vector2.new(0.5, 0.5)
				U754.Position = UDim2.fromScale(0.5, 0.5)
				U754.Size = UDim2.fromOffset(K22 * 2, K22 * 2)
				U754.BackgroundTransparency = 1
				U754.Visible = false
				U754.ZIndex = 2
				U754.Parent = U752
				Instance.new("UICorner", U754).CornerRadius = UDim.new(1, 0)
				local U755 = Instance.new("UIStroke")
				U755.Thickness = 1.5
				U755.Color = Color3.fromRGB(0, 0, 0)
				U755.Transparency = 0.25
				U755.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
				U755.Parent = U754
				local K47 = 0.78
				local L1026_10 = Instance.new("Frame")
				L1026_10.Name = "Ring"
				L1026_10.AnchorPoint = Vector2.new(0.5, 0.5)
				L1026_10.Position = UDim2.fromScale(0.5, 0.5)
				L1026_10.Size = UDim2.fromOffset(K23 * 2, K23 * 2)
				L1026_10.BackgroundTransparency = 1
				L1026_10.ZIndex = 2
				L1026_10.Parent = U754
				Instance.new("UICorner", L1026_10).CornerRadius = UDim.new(1, 0)
				local U756 = Instance.new("UIStroke")
				U756.Thickness = K22 - K23
				U756.Color = Color3.fromRGB(0, 0, 0)
				U756.Transparency = K47
				U756.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
				U756.Parent = L1026_10
				local L1026_11 = Instance.new("Frame")
				L1026_11.Name = "Hole"
				L1026_11.AnchorPoint = Vector2.new(0.5, 0.5)
				L1026_11.Position = UDim2.fromScale(0.5, 0.5)
				L1026_11.Size = UDim2.fromOffset(K23 * 2, K23 * 2)
				L1026_11.BackgroundTransparency = 1
				L1026_11.ZIndex = 2
				L1026_11.Parent = U754
				Instance.new("UICorner", L1026_11).CornerRadius = UDim.new(1, 0)
				local U757 = Instance.new("UIStroke")
				U757.Thickness = 1.5
				U757.Color = Color3.fromRGB(0, 0, 0)
				U757.Transparency = 0.25
				U757.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
				U757.Parent = L1026_11
				local U758 = Instance.new("UIScale")
				U758.Parent = U754
				local U759 = {}
				local U760 = {}
				local U761 = {}
				local U762 = nil
				local U763 = nil
				local U764 = {}
				local U765 = nil
				local U766 = 0
				local U767 = nil

				local function F_001103()
					for I396, I397 in ipairs(U759) do
						pcall(function()
							I397:Destroy()
						end)
					end

					for I398, I399 in ipairs(U761) do
						pcall(function()
							I399:Destroy()
						end)
					end

					table.clear(U759)
					table.clear(U761)
					table.clear(U760)
					U764 = {}
					U765 = nil
					U762 = nil
					local L1103_1 = #U684
					if L1103_1 == 0 then
						return
					end
					local L1103_2 = 360 / L1103_1
					local L1103_3 = (K23 + K22) / 2

					for I400, I401 in ipairs(U684) do
						local L1103_4 = math.rad((I400 - 0.5) * L1103_2)
						local L1103_5 = Instance.new("Frame")
						L1103_5.AnchorPoint = Vector2.new(0.5, 0.5)
						L1103_5.Size = UDim2.fromOffset(1, K22 - K23 - 4)
						L1103_5.Position = UDim2.new(0.5, math.sin(L1103_4) * L1103_3, 0.5, -math.cos(L1103_4) * L1103_3)
						L1103_5.Rotation = (I400 - 0.5) * L1103_2
						L1103_5.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
						L1103_5.BackgroundTransparency = 0.65
						L1103_5.BorderSizePixel = 0
						L1103_5.ZIndex = 2
						L1103_5.Parent = U754
						table.insert(U761, L1103_5)
						local L1103_6 = math.rad((I400 - 1) * L1103_2)
						local L1103_7 = Instance.new("Frame")
						L1103_7.AnchorPoint = Vector2.new(0.5, 0.5)
						L1103_7.Position = UDim2.new(0.5, math.sin(L1103_6) * K24, 0.5, -math.cos(L1103_6) * K24)
						L1103_7.Size = UDim2.fromOffset(96, 96)
						L1103_7.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
						L1103_7.BackgroundTransparency = 0.7
						L1103_7.ZIndex = 3
						L1103_7.Parent = U754
						Instance.new("UICorner", L1103_7).CornerRadius = UDim.new(1, 0)
						local L1103_8 = Instance.new("UIStroke")
						L1103_8.Thickness = 1
						L1103_8.Color = Color3.fromRGB(0, 0, 0)
						L1103_8.Transparency = 0.4
						L1103_8.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
						L1103_8.Parent = L1103_7
						local L1103_9 = Instance.new("ViewportFrame")
						L1103_9.BackgroundTransparency = 1
						L1103_9.Size = UDim2.fromScale(1, 1)
						L1103_9.Ambient = Color3.fromRGB(190, 190, 190)
						L1103_9.LightColor = Color3.fromRGB(255, 255, 255)
						L1103_9.LightDirection = Vector3.new(0.4, -0.6, 1)
						L1103_9.ZIndex = 3
						L1103_9.Parent = L1103_7
						Instance.new("UICorner", L1103_9).CornerRadius = UDim.new(1, 0)
						U760[I400] = L1103_9
						local L1103_10 = Instance.new("TextLabel")
						L1103_10.BackgroundTransparency = 1
						L1103_10.AnchorPoint = Vector2.new(0.5, 0.5)
						L1103_10.Position = UDim2.fromScale(0.5, 0.84)
						L1103_10.Size = UDim2.fromScale(0.86, 0.2)
						L1103_10.Font = Enum.Font.GothamBold
						L1103_10.TextScaled = true
						L1103_10.Text = I401.Name
						L1103_10.TextColor3 = Color3.new(1, 1, 1)
						L1103_10.TextStrokeTransparency = 0.45
						L1103_10.TextStrokeColor3 = Color3.new(0, 0, 0)
						L1103_10.ZIndex = 4
						L1103_10.Parent = L1103_7
						Instance.new("UITextSizeConstraint", L1103_10).MaxTextSize = 12
						local L1103_11 = Instance.new("TextButton")
						L1103_11.Size = UDim2.fromScale(1, 1)
						L1103_11.BackgroundTransparency = 1
						L1103_11.Text = ""
						L1103_11.ZIndex = 5
						L1103_11.Parent = L1103_7

						L1103_11.Activated:Connect(function()
							U689:Play()
							F_001089(I400)

							if U763 then
								U763()
							end
						end)

						U759[I400] = L1103_7
					end
				end

				F_001103()

				local function F_001107()
					local U768 = U682.Character
					local L1107_1 = U768 and U768:FindFirstChild("HumanoidRootPart")
					if not U768 or not L1107_1 then
						return
					end
					local L1107_2 = #U768:GetDescendants()
					if U765 == U768 and U766 == L1107_2 and #U764 == #U684 then
						return
					end
					U764 = {}
					U765 = U768
					U766 = L1107_2
					local U769 = U768.Archivable

					pcall(function()
						U768.Archivable = true
					end)

					local L1107_3 = U768:Clone()

					pcall(function()
						U768.Archivable = U769
					end)

					if not L1107_3 then
						U765 = nil
						return
					end

					for I402, I403 in ipairs(L1107_3:GetDescendants()) do
						if I403:IsA("BaseScript") or I403:IsA("Sound") or I403:IsA("BillboardGui") or I403:IsA("ForceField") then
							pcall(function()
								I403:Destroy()
							end)
						elseif I403:IsA("BasePart") then
							I403.Anchored = false
							I403.CanCollide = false
							I403.CanTouch = false
							I403.CanQuery = false
						end
					end

					local U770 = L1107_3:FindFirstChildOfClass("Humanoid")

					if U770 then
						pcall(function()
							U770.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
						end)

						pcall(function()
							U770.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
						end)

						pcall(function()
							U770.EvaluateStateMachine = false
						end)

						pcall(function()
							U770.PlatformStand = true
						end)
					end

					local L1107_4 = L1107_3:FindFirstChild("HumanoidRootPart")

					if not L1107_4 then
						L1107_3:Destroy()
						U765 = nil
						return
					end

					L1107_4.Anchored = true
					L1107_3.PrimaryPart = L1107_4

					for I404, I405 in pairs(U736) do
						if I404 and I404.Parent then
							local L1107_5 = L1107_3:FindFirstChild(I404.Parent.Name, true)
							L1107_5 = L1107_5 and L1107_5:FindFirstChild(I404.Name)

							if L1107_5 and L1107_5:IsA("Motor6D") then
								L1107_5.C0 = I405
							end
						end
					end

					local U771 = {}

					for I406, I407 in ipairs(U684) do
						local L1107_6 = U760[I406]

						if L1107_6 then
							local L1107_7 = L1107_3:Clone()
							L1107_7:PivotTo(CFrame.Angles(0, 0.3490658503988659, 0))
							local L1107_8 = Instance.new("WorldModel")
							L1107_8.Parent = L1107_6
							L1107_7.Parent = L1107_8
							local L1107_9 = Instance.new("Camera")
							L1107_9.FieldOfView = 28
							local L1107_10, L1107_11 = L1107_7:GetBoundingBox()
							local L1107_12 = L1107_10.Position
							L1107_9.CFrame = CFrame.lookAt(L1107_10.Position + Vector3.new(0, 0, -(math.max(L1107_11.Y, L1107_11.X) / 2 / math.tan(math.rad(L1107_9.FieldOfView / 2)) * 1.3)), L1107_12)
							L1107_9.Parent = L1107_6
							L1107_6.CurrentCamera = L1107_9
							local L1107_13 = F_001029(L1107_7)
							local L1107_14 = {}

							for I408, I409 in pairs(L1107_13) do
								if I409 then
									L1107_14[I409] = I409.C0
								end
							end

							U771[I406] = { Data = I407, Model = L1107_7, Motors = L1107_13, Orig = L1107_14, Time = 0, KData = nil }
						end
					end

					L1107_3:Destroy()
					U764 = U771

					task.spawn(function()
						for I410, I411 in pairs(U771) do
							if not I411.KData then
								local L1115_1, L1115_2 = pcall(F_001037, I411.Data)

								if L1115_1 then
									I411.KData = L1115_2
								end
							end
						end
					end)

					for I412, I413 in pairs(U771) do
						I413.KData = U693[I413.Data.Name]
					end
				end

				local function F_001116(A1116_1)
					for I414, I415 in pairs(U764) do
						local L1116_1 = I415.KData or U693[I415.Data.Name]

						if L1116_1 then
							I415.KData = L1116_1
							I415.Time = I415.Time + A1116_1
							local L1116_2 = F_001033(L1116_1, I415.Time)

							for I416, I417 in pairs(I415.Motors) do
								local L1116_3 = I415.Orig[I417]

								if I417 and I417.Parent and L1116_3 then
									I417.C0 = L1116_3 * (L1116_2[I416] or CFrame.identity)
								end
							end
						end
					end
				end

				local U772 = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

				local function F_001117(A1117_1)
					local L1117_1 = #U684
					if L1117_1 == 0 then
						return nil
					end
					local L1117_2 = 360 / L1117_1
					return math.floor(((math.deg(math.atan2(A1117_1.X, -A1117_1.Y)) - U754.Rotation) % 360 + L1117_2 / 2) % 360 / L1117_2) + 1
				end

				local function F_001118(A1118_1)
					if #U684 == 0 then
						return nil
					end
					local L1118_1 = A1118_1 - U752.AbsoluteSize / 2
					local L1118_2 = L1118_1.Magnitude
					local L1118_3 = U758.Scale
					if L1118_2 < K23 * L1118_3 or L1118_2 > K22 * L1118_3 then
						return nil
					end
					return F_001117(L1118_1)
				end

				local function F_001119(A1119_1)
					if A1119_1 == U762 then
						return
					end

					if U762 and U759[U762] then
						U678:Create(U759[U762], U772, { BackgroundTransparency = 0.7, Size = UDim2.fromOffset(96, 96) }):Play()
					end

					U762 = A1119_1

					if A1119_1 and U759[A1119_1] then
						U688:Play()
						U678:Create(U759[A1119_1], U772, { BackgroundTransparency = 0.3, Size = UDim2.fromOffset(K25 * 1.2, K25 * 1.2) }):Play()
					end
				end

				local function F_001120()
					return U676:GetMouseLocation() - U679:GetGuiInset()
				end

				local U773 = false
				local U774 = nil
				local U775 = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
				local U776 = TweenInfo.new(0.18, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
				local U777 = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
				local K48 = 9

				local function F_001121()
					local L1121_1 = workspace.CurrentCamera
					return math.clamp((L1121_1 and L1121_1.ViewportSize.Y or 720) / 650, 0.55, 1.2)
				end

				U763 = function()
					if not U773 then
						return
					end
					U773 = false

					if U774 then
						U774:Disconnect()
						U774 = nil
					end

					F_001119(nil)
					U687:Play()
					U678:Create(U758, U776, { Scale = F_001121() * 0.6 }):Play()
					U678:Create(U756, U776, { Transparency = 1 }):Play()
					U678:Create(U755, U776, { Transparency = 1 }):Play()
					U678:Create(U757, U776, { Transparency = 1 }):Play()
					U678:Create(U753, U776, { BackgroundTransparency = 1 }):Play()
					U678:Create(U685, U777, { Size = 0 }):Play()

					for I418 = #U759, 1, -1 do
						local U778 = U759[I418]
						local U779 = U760[I418]

						if U778 then
							task.delay((#U759 - I418) * 0.018, function()
								if U778 then
									U678:Create(U778, TweenInfo.new(0.1), { BackgroundTransparency = 1 }):Play()
								end

								if U779 then
									U678:Create(U779, TweenInfo.new(0.1), { ImageTransparency = 1 }):Play()
								end
							end)
						end
					end

					task.delay(0.22, function()
						if not U773 then
							U754.Visible = false
							U753.Visible = false

							for I419, I420 in ipairs(U759) do
								if I420 then
									I420.BackgroundTransparency = 0.7
								end
							end

							if U767 then
								U767:Disconnect()
								U767 = nil
							end
						end
					end)
				end

				local function F_001125()
					if #U684 == 0 then
						return
					end

					if U773 then
						U763()
						return
					end
					U773 = true
					pcall(F_001107)

					for I421, I422 in pairs(U764) do
						I422.Time = 0
					end

					if not U767 then
						U767 = U677.RenderStepped:Connect(F_001116)
					end

					local L1125_1 = F_001121()
					U758.Scale = L1125_1 * 0.5
					U754.Rotation = 0

					for I423, I424 in ipairs(U759) do
						I424.Rotation = 0
					end

					U756.Transparency = 1
					U755.Transparency = 1
					U757.Transparency = 1
					U754.Visible = true
					U753.Visible = true
					U753.BackgroundTransparency = 1

					for I425, I426 in ipairs(U759) do
						if I426 then
							I426.BackgroundTransparency = 1
						end

						if U760[I425] then
							U760[I425].ImageTransparency = 1
						end
					end

					U686:Play()
					local L1125_2 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
					U678:Create(U758, U775, { Scale = L1125_1 }):Play()
					U678:Create(U756, L1125_2, { Transparency = K47 }):Play()
					U678:Create(U755, L1125_2, { Transparency = 0.25 }):Play()
					U678:Create(U757, L1125_2, { Transparency = 0.25 }):Play()
					U678:Create(U753, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundTransparency = 0.42 }):Play()
					U678:Create(U685, U777, { Size = 28 }):Play()

					for I427, I428 in ipairs(U759) do
						task.delay(I427 * 0.022, function()
							if U773 and I428 then
								U678:Create(I428, TweenInfo.new(0.18, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { BackgroundTransparency = 0.7 }):Play()
								local L1126_1 = U760[I427]

								if L1126_1 then
									U678:Create(L1126_1, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { ImageTransparency = 0 }):Play()
								end
							end
						end)
					end

					U774 = U677.RenderStepped:Connect(function(A1127_1)
						U754.Rotation = U754.Rotation + A1127_1 * K48

						for I429, I430 in ipairs(U759) do
							I430.Rotation = -U754.Rotation
						end

						local L1127_1 = U676:GetLastInputType()
						if L1127_1 == Enum.UserInputType.Touch or L1127_1.Name:find("Gamepad") then
							return
						end
						F_001119(F_001118(F_001120()))
					end)
				end

				U753.Activated:Connect(U763)

				U676.InputBegan:Connect(function(A1128_1, A1128_2)
					if A1128_1.KeyCode == Enum.KeyCode.B or A1128_1.KeyCode == Enum.KeyCode.DPadRight then
						if not A1128_2 then
							F_001125()
						end

						return
					end

					if not U773 then
						return
					end

					if A1128_1.UserInputType == Enum.UserInputType.MouseButton1 then
						local L1128_1 = F_001118(F_001120())

						if L1128_1 then
							U689:Play()
							F_001089(L1128_1)
						end

						U763()
					elseif A1128_1.UserInputType == Enum.UserInputType.Touch then
						local L1128_2 = F_001118(Vector2.new(A1128_1.Position.X, A1128_1.Position.Y))

						if L1128_2 then
							U689:Play()
							F_001089(L1128_2)
						end

						U763()
					elseif A1128_1.KeyCode == Enum.KeyCode.ButtonA then
						if U762 then
							U689:Play()
							F_001089(U762)
						end

						U763()
					elseif A1128_1.KeyCode == Enum.KeyCode.ButtonB or A1128_1.KeyCode == Enum.KeyCode.Escape then
						U763()
					end
				end)

				U676.InputChanged:Connect(function(A1129_1)
					if not U773 then
						return
					end

					if A1129_1.KeyCode == Enum.KeyCode.Thumbstick1 or A1129_1.KeyCode == Enum.KeyCode.Thumbstick2 then
						local L1129_1 = Vector2.new(A1129_1.Position.X, -A1129_1.Position.Y)

						if L1129_1.Magnitude > 0.5 then
							F_001119(F_001117(L1129_1))
						else
							F_001119(nil)
						end
					end
				end)

				U675:AddDivider()

				U675:AddToggle("EnableEmotes", {
					Text = "Enable Emotes",
					Default = false,
					Callback = function(A1130_1)
						if not A1130_1 and U773 then
							U763()
						end
					end,
				})

				local function F_001131(A1131_1)
					table.clear(U684)

					if typeof(A1131_1) == "table" then
						for I431, I432 in ipairs(U683) do
							if A1131_1[I432.Name] == true or table.find(A1131_1, I432.Name) then
								table.insert(U684, I432)
							end
						end
					end

					if #U684 == 0 then
						for I433, I434 in ipairs(U683) do
							table.insert(U684, I434)
						end
					end

					F_001103()
				end

				U675:AddDropdown("EmoteSelection", {
					Text = "Emote Selection",
					IconName = "smile",
					Values = { "Peter Parker", "Jump Style", "Take The L", "Hold On.", "RickRoll" },
					ValueImages = {
						["Peter Parker"] = "zap",
						["Jump Style"] = "footprints",
						["Take The L"] = "trophy",
						["Hold On."] = "hand",
						RickRoll = "music",
					},
					Default = { "Peter Parker", "Jump Style", "Take The L", "Hold On.", "RickRoll" },
					Multi = true,
					Callback = function(A1132_1)
						F_001131(A1132_1)
					end,
				})

				U675:AddDivider("Music Settings")

				U675:AddToggle("EnableEmoteMusics", {
					Text = "Enable Emote Musics",
					Default = true,
					Callback = function()
					end,
				})

				U675:AddSlider("EmoteMusicVolume", {
					Text = "Volume",
					Default = 75,
					Min = 0,
					Max = 100,
					Rounding = 0,
					Compact = true,
					Suffix = "%",
					Callback = function()
					end,
				})

				U675:AddDivider()
			end)
		end

		local L0_377 = U92.Player:AddGroupbox({
			Side = 2,
			Name = "<b>Character</b>",
			IconName = "user",
			Description = "Speed fly",
			MaxPopOutHeight = 600,
			PopOutWidth = 250,
		})

		L0_377:AddSlider("FOV", {
			Text = "FOV",
			Default = 70,
			Min = 0,
			Max = 120,
			Rounding = 0,
			Compact = true,
			Callback = function(A1135_1)
				U96(A1135_1)
			end,
		})

		L0_377:AddDivider()

		L0_377:AddToggle("ThirdPersonToggle", {
			Text = "Thirdperson",
			Default = true,
			Callback = function(A1136_1)
				pcall(function()
					U68.CameraMode = Enum.CameraMode.Classic

					if A1136_1 then
						U68.CameraMaxZoomDistance = 1000
						U68.CameraMinZoomDistance = 15

						task.delay(0.1, function()
							pcall(function()
								U68.CameraMinZoomDistance = 0.5
							end)
						end)
					else
						U68.CameraMaxZoomDistance = 0.6
						U68.CameraMinZoomDistance = 0.5
					end
				end)
			end,
		}):AddKeyPicker("ThirdPersonKey", {
			Default = "None",
			Mode = "Toggle",
			SyncToggleState = true,
			Text = "Thirdperson Keybind",
			Callback = function()
			end,
		})

		L0_377:AddToggle("NoClip", {
			Text = "NoClip",
			Default = false,
			Callback = function(A1141_1)
				U97(A1141_1)
			end,
		})

		L0_377:AddToggle("SuperJumpToggle", {
			Text = "Super Jump Toggle",
			Default = false,
			Callback = function()
				U98()
			end,
		}):AddKeyPicker("SuperJumpKey", {
			Default = "None",
			Mode = "Toggle",
			SyncToggleState = true,
			Text = "Super Jump Keybind",
			Callback = function()
			end,
		})

		L0_377:AddSlider("SuperJump", {
			Text = "Super Jump",
			Default = 100,
			Min = 1,
			Max = 2000,
			Rounding = 0,
			Compact = true,
			Callback = function()
				if U66.SuperJumpToggle and U66.SuperJumpToggle.Value then
					U98()
				end
			end,
		})

		L0_377:AddDivider()

		L0_377:AddToggle("InfiniteJump", {
			Text = "Infinite Jump",
			Default = false,
			Callback = function()
			end,
		})

		L0_377:AddToggle("WalkSpeedToggle", {
			Text = "Walk Speed Toggle",
			Default = false,
			Callback = function(A1146_1)
				U99(A1146_1)
			end,
		}):AddKeyPicker("WalkSpeedKey", {
			Default = "None",
			Mode = "Toggle",
			SyncToggleState = true,
			Text = "Walk Speed Keybind",
			Callback = function()
			end,
		})

		L0_377:AddSlider("WalkSpeed", {
			Text = "Walk Speed",
			Default = 16,
			Min = 1,
			Max = 1500,
			Rounding = 0,
			Compact = true,
			Callback = function()
				if U66.WalkSpeedToggle and U66.WalkSpeedToggle.Value then
					U99(true)
				end
			end,
		})

		L0_377:AddDivider()

		L0_377:AddToggle("FlyToggle", {
			Text = "Fly Toggle",
			Default = false,
			Callback = function(A1149_1)
				U100(A1149_1)
			end,
		}):AddKeyPicker("FlyKey", {
			Default = "None",
			Mode = "Toggle",
			SyncToggleState = true,
			Text = "Fly Keybind",
			Callback = function()
			end,
		})

		L0_377:AddSlider("FlySpeed", {
			Text = "Fly Speed",
			Default = 50,
			Min = 1,
			Max = 300,
			Rounding = 0,
			Compact = true,
			Callback = function()
			end,
		})

		local U780

		U780 = function(A1152_1)
			if not A1152_1 then
				return nil
			end
			local L1152_1 = U71:FindFirstChild("Plots")
			local L1152_2 = { TudorHouse = 1, PinkRoofHouse = 2, HauntedHouse = 3, BlueHouse = 4, JapaneseHouse = 5 }

			if A1152_1 == "Spawn" then
				local L1152_3 = U71:FindFirstChild("SpawnLocation") or U71:FindFirstChild("Spawn")

				if not L1152_3 then
					for I435, I436 in ipairs(U71:GetDescendants()) do
						if I436:IsA("SpawnLocation") then
							L1152_3 = I436
							break
						end
					end
				end

				if L1152_3 then
					return L1152_3.CFrame + Vector3.new(0, 4, 0)
				end
				return CFrame.new(0, 50, 0)
			end

			if A1152_1 == "VoidPlatform" then
				local L1152_4 = U71:FindFirstChild("VoidPlatform") or U71:FindFirstChild("Void Platform")

				if L1152_4 then
					if L1152_4:IsA("BasePart") then
						return L1152_4.CFrame + Vector3.new(0, 4, 0)
					end

					if L1152_4:IsA("Model") then
						return L1152_4:GetPivot() + Vector3.new(0, 4, 0)
					end
				end

				for I437, I438 in ipairs(U71:GetChildren()) do
					if I438.Name:lower():find("voidplatform") or I438.Name:lower():find("void") then
						if I438:IsA("BasePart") then
							return I438.CFrame + Vector3.new(0, 4, 0)
						end

						if I438:IsA("Model") then
							return I438:GetPivot() + Vector3.new(0, 4, 0)
						end
					end
				end

				return CFrame.new(0, -200, 0)
			end

			local L1152_5 = nil

			if L1152_1 then
				L1152_5 = L1152_1:FindFirstChild(A1152_1)

				if not L1152_5 and L1152_2[A1152_1] then
					local L1152_6 = L1152_2[A1152_1]
					L1152_5 = L1152_1:FindFirstChild("Plot" .. L1152_6) or L1152_1:GetChildren()[L1152_6]
				end

				if not L1152_5 then
					for I439, I440 in ipairs(L1152_1:GetChildren()) do
						if I440.Name:lower():find(A1152_1:lower()) then
							L1152_5 = I440
							break
						end
					end
				end
			end

			L1152_5 = L1152_5 or U71:FindFirstChild(A1152_1)

			if L1152_5 then
				local L1152_7 = L1152_5:FindFirstChild("PlotSign")
				local L1152_8 = L1152_7 and L1152_7:FindFirstChild("Sign") and L1152_7.Sign:FindFirstChild("Plus") and L1152_7.Sign.Plus:FindFirstChild("PlusGrabPart")
				if L1152_8 then
					local L1152_9 = L1152_8.Position + L1152_8.CFrame.LookVector * 5 + Vector3.new(0, 2, 0)
					return CFrame.new(L1152_9, L1152_9 - L1152_8.CFrame.LookVector)
				end

				if L1152_7 then
					local L1152_10 = L1152_7:FindFirstChildWhichIsA("BasePart") or L1152_7:IsA("BasePart") and L1152_7
					if L1152_10 then
						local L1152_11 = L1152_10.Position + L1152_10.CFrame.LookVector * 5 + Vector3.new(0, 2, 0)
						return CFrame.new(L1152_11, L1152_11 - L1152_10.CFrame.LookVector)
					end
					return L1152_7:GetPivot() + Vector3.new(0, 4, 0)
				end

				local L1152_12 = L1152_5:FindFirstChild("Region") or L1152_5:FindFirstChild("Zone") or L1152_5:FindFirstChild("Base")
				if L1152_12 and L1152_12:IsA("BasePart") then
					return L1152_12.CFrame + Vector3.new(0, 4, 0)
				end

				if L1152_5:IsA("Model") then
					return L1152_5:GetPivot() + Vector3.new(0, 4, 0)
				end

				if L1152_5:IsA("BasePart") then
					return L1152_5.CFrame + Vector3.new(0, 4, 0)
				end
			end

			return nil
		end

		do
			local L0_378 = U92.Player:AddGroupbox({
				Side = 1,
				Name = "<b>Teleporting</b>",
				IconName = "chevrons-left-right-ellipsis",
				Description = "Location jump",
				MaxPopOutHeight = 600,
				PopOutWidth = 250,
			}):AddTabbox({ MaxPopOutHeight = 600 })

			local L0_379 = L0_378:AddTab("<b>Aim TP</b>", "crosshair")

			local L0_380 = L0_379:AddToggle("ToggleAimTeleport", {
				Text = "Toggle Aim Teleport",
				Default = true,
				Callback = function()
				end,
			})

			pcall(function()
				U66.ToggleAimTeleport:SetValue(true)
			end)

			L0_380:AddKeyPicker("ToggleAimTeleportKey", {
				Default = "None",
				Mode = "Toggle",
				SyncToggleState = true,
				Text = "Aim Teleport Keybind",
				Callback = function()
				end,
			})

			L0_379:AddDropdown("AimTpType", {
				Text = "Type",
				Values = { "Instant", "Smooth", "Spider Web" },
				ValueImages = { Instant = "zap", Smooth = "wind", ["Spider Web"] = "network" },
				Default = "Smooth",
			})

			local L0_381 = L0_379:AddDependencyBox()
			L0_381:AddDivider()

			L0_381:AddSlider("SmoothTpSpeed", {
				Text = "Smooth TP Speed",
				Default = 1000,
				Min = 10,
				Max = 3000,
				Rounding = 0,
				Compact = true,
			})

			L0_381:SetupDependencies({ { U65.AimTpType, "Smooth" } })
			local U781 = nil

			local function F_001156()
				local L1156_1 = workspace.CurrentCamera
				local L1156_2 = U65.AimTpDistance and U65.AimTpDistance.Value or 30000

				if (U65.AimTpTargetMode and tostring(U65.AimTpTargetMode.Value) or "Mouse"):lower():find("cam") then
					if not L1156_1 then
						return nil
					end
					local L1156_3 = RaycastParams.new()
					L1156_3.FilterType = Enum.RaycastFilterType.Exclude
					local L1156_4 = {}
					local L1156_5 = U68.Character

					if L1156_5 then
						table.insert(L1156_4, L1156_5)
					end

					L1156_3.FilterDescendantsInstances = L1156_4
					local L1156_6 = L1156_1.ViewportSize
					local L1156_7 = L1156_1:ViewportPointToRay(L1156_6.X / 2, L1156_6.Y / 2)
					local L1156_8 = workspace:Raycast(L1156_7.Origin, L1156_7.Direction * L1156_2, L1156_3)
					if L1156_8 then
						return L1156_8.Position + Vector3.new(0, 3, 0)
					end
					local L1156_9 = L1156_7.Origin + L1156_7.Direction * math.min(L1156_2, 1000)
					local L1156_10 = workspace:Raycast(L1156_9, Vector3.new(0, -500, 0), L1156_3)
					if L1156_10 then
						return L1156_10.Position + Vector3.new(0, 3, 0)
					end
					return L1156_9
				end

				local L1156_11 = U68:GetMouse()
				if not L1156_11 or not L1156_1 then
					return nil
				end

				if L1156_11.Target then
					if (L1156_11.Hit.Position - L1156_1.CFrame.Position).Magnitude <= L1156_2 then
						return L1156_11.Hit.Position + Vector3.new(0, 3, 0)
					end
					return L1156_1.CFrame.Position + L1156_11.UnitRay.Direction.Unit * L1156_2
				end

				return L1156_1.CFrame.Position + L1156_11.UnitRay.Direction.Unit * L1156_2
			end

			local function F_001157()
				pcall(function()
					local L1158_1 = typeof(getgenv) == "function" and getgenv() or _G

					if type(L1158_1.ST_DecoyManual) == "function" then
						L1158_1.ST_DecoyManual(2.5)
					end
				end)

				if not (U66.ToggleAimTeleport and U66.ToggleAimTeleport.Value) then
					return
				end
				local U782 = U68.Character
				local U783 = U782 and U782:FindFirstChild("HumanoidRootPart")
				local U784 = U782 and U782:FindFirstChildOfClass("Humanoid")
				if not U782 or not U783 or not U784 or U784.Health <= 0 then
					return
				end
				local L1157_1 = U65.AimTpType and U65.AimTpType.Value or "Smooth"
				if L1157_1 == "Spider Web" then
					return
				end
				local U785 = F_001156()
				if not U785 then
					return
				end

				if L1157_1 == "Instant" then
					if U781 then
						task.cancel(U781)
						U781 = nil
					end

					U783.CFrame = CFrame.new(U785, U785 + U783.CFrame.LookVector)
					U783.AssemblyLinearVelocity = Vector3.zero
				elseif L1157_1 == "Smooth" then
					if U781 then
						task.cancel(U781)
						U781 = nil
					end

					U781 = task.spawn(function()
						local L1159_1 = U65.SmoothTpSpeed and U65.SmoothTpSpeed.Value or 1000
						local L1159_2 = U783.Position
						local L1159_3 = (U785 - L1159_2).Magnitude
						if L1159_3 < 1 then
							U783.CFrame = CFrame.new(U785)
							return
						end
						local L1159_4 = (U785 - L1159_2).Unit
						local L1159_5 = {}

						for I441, I442 in ipairs(U782:GetDescendants()) do
							if I442:IsA("BasePart") and I442.CanCollide then
								table.insert(L1159_5, I442)
								I442.CanCollide = false
							end
						end

						local L1159_6 = math.max(0.18, L1159_3 / math.max(L1159_1, 10))
						local L1159_7 = 0

						while L1159_7 < L1159_6 do
							local L1159_8 = U69.Heartbeat:Wait()

							if not (not U782 or not U783 or not U784 or U784.Health <= 0) then
								L1159_7 += L1159_8
								local L1159_9 = math.clamp(L1159_7 / L1159_6, 0, 1)

								for I443, I444 in ipairs(U782:GetDescendants()) do
									if I444:IsA("BasePart") then
										I444.CanCollide = false
									end
								end

								local L1159_10 = L1159_2:Lerp(U785, L1159_9)
								U783.CFrame = CFrame.new(L1159_10, L1159_10 + L1159_4)
								U783.AssemblyLinearVelocity = Vector3.zero
								U783.AssemblyAngularVelocity = Vector3.zero
								continue
							end

							break
						end

						if U783 and U783.Parent then
							U783.CFrame = CFrame.new(U785, U785 + L1159_4)
							U783.AssemblyLinearVelocity = Vector3.zero
							U783.AssemblyAngularVelocity = Vector3.zero
						end

						for I445, I446 in ipairs(L1159_5) do
							pcall(function()
								I446.CanCollide = true
							end)
						end

						U781 = nil
					end)
				end
			end

			L0_379:AddLabel("Teleport to Aiming Part"):AddKeyPicker("TeleportToAimingPartKey", {
				Default = "X",
				Mode = "Press",
				Text = "Teleport to Aiming Part",
				NoUI = false,
				Callback = F_001157,
			})

			L0_379:AddDivider("Settings")

			L0_379:AddDropdown("AimTpTargetMode", {
				Text = "Teleporting",
				Values = { "Mouse", "Camera" },
				ValueImages = { Mouse = "mouse-pointer", Camera = "camera" },
				Default = "Mouse",
			})

			L0_379:AddSlider("AimTpDistance", {
				Text = "Distance",
				Default = 5000,
				Min = 100,
				Max = 30000,
				Rounding = 0,
				Compact = true,
			})

			UserInputService.InputBegan:Connect(function(A1161_1, A1161_2)
				if A1161_2 then
					return
				end

				if A1161_1.UserInputType == Enum.UserInputType.MouseButton1 then
					if U66.ToggleAimTeleport and U66.ToggleAimTeleport.Value then
						F_001157()
					end
				end
			end)

			local L0_382 = L0_378:AddTab("<b>House</b>", "house")

			L0_382:AddDropdown("TeleportLocation", {
				Text = "Location",
				Values = {
					"TudorHouse",
					"PinkRoofHouse",
					"HauntedHouse",
					"BlueHouse",
					"JapaneseHouse",
					"Spawn",
					"VoidPlatform",
				},
				ValueImages = {
					TudorHouse = "rbxassetid://8989327148",
					PinkRoofHouse = "rbxassetid://8989326312",
					HauntedHouse = "rbxassetid://9909725942",
					BlueHouse = "rbxassetid://9909733734",
					JapaneseHouse = "rbxassetid://9108988013",
					Spawn = "map-pin",
					VoidPlatform = "disc",
				},
				Default = 1,
				Callback = function()
				end,
			})

			L0_382:AddButton({
				Text = "Teleport Once",
				Func = function()
					local L1163_1 = U780(U65.TeleportLocation and U65.TeleportLocation.Value)
					local L1163_2 = U68.Character
					L1163_2 = L1163_2 and L1163_2:FindFirstChild("HumanoidRootPart")

					if L1163_2 and L1163_1 then
						L1163_2.CFrame = L1163_1
						L1163_2.AssemblyLinearVelocity = Vector3.zero
					end
				end,
				DoubleClick = false,
			})

			local U786 = nil

			local function F_001164(A1164_1)
				if U786 then
					U786:Disconnect()
					U786 = nil
				end

				if not A1164_1 then
					return
				end

				U786 = U69.Heartbeat:Connect(function()
					if not (U66.LoopTpLocToggle and U66.LoopTpLocToggle.Value) then
						if U786 then
							U786:Disconnect()
							U786 = nil
						end

						return
					end

					local L1165_1 = U780(U65.TeleportLocation and U65.TeleportLocation.Value)
					local L1165_2 = U68.Character
					L1165_2 = L1165_2 and L1165_2:FindFirstChild("HumanoidRootPart")

					if L1165_2 and L1165_1 then
						L1165_2.CFrame = L1165_1
						L1165_2.AssemblyLinearVelocity = Vector3.zero
					end
				end)
			end

			L0_382:AddDivider()

			L0_382:AddToggle("LoopTpLocToggle", { Text = "Loop Tp", Default = false, Callback = F_001164 }):AddKeyPicker("LoopTpLocKey", {
				Default = "None",
				Mode = "Toggle",
				SyncToggleState = true,
				Text = "Loop Tp Keybind",
				Callback = function()
				end,
			})
		end

		local L0_383

		L0_383 = U92.Fun:AddGroupbox({
			Side = 1,
			Name = "<b>Poses</b>",
			IconName = "cone",
			Description = "Pose control",
			MaxPopOutHeight = 600,
			PopOutWidth = 250,
		})

		L0_383:AddDropdown("PosesTarget", {
			Text = "Select Target",
			Values = U87(),
			Default = 1,
			AllowNull = true,
			Multi = false,
			Searchable = true,
			Callback = function()
			end,
		})

		L0_383:AddLabel("Aim to Select Target"):AddKeyPicker("PosesTargetKey", {
			Default = "None",
			Mode = "Press",
			Text = "Aim to Select Target",
			NoUI = false,
			Callback = function()
				local L1168_1 = GetClosestPlayerToMouse()

				if L1168_1 then
					local L1168_2 = string.format("%s (@%s)", L1168_1.DisplayName, L1168_1.Name)

					if U65.PosesTarget then
						U65.PosesTarget:SetValue(L1168_2)
					end
				end
			end,
			ChangedCallback = function()
			end,
		})

		do
			local U787 = {
				["Pose 1"] = {
					Target = {
						Offset = CFrame.new(0, -2.1, -1.4),
						Limbs = {
							Head = CFrame.new(0, 1, 0) * CFrame.Angles(-0.43633231299858238, 0, 0),
							["Left Arm"] = CFrame.new(-1, 0.5, 0) * CFrame.Angles(1.5707963267948966, 0, 0),
							["Right Arm"] = CFrame.new(1, 0.5, 0) * CFrame.Angles(1.5707963267948966, 0, 0),
							["Left Leg"] = CFrame.new(0, 1, 0) * CFrame.Angles(-1.6580627893946132, 0, -0.26179938779914941),
							["Right Leg"] = CFrame.new(0, 1, 0) * CFrame.Angles(-1.6580627893946132, 0, 0.26179938779914941),
							Torso = CFrame.new(0, 0, 0),
						},
					},
				},
				["Pose 2"] = {
					Target = {
						Offset = CFrame.new(0, -1.4, -1.4),
						Limbs = {
							Head = CFrame.new(0, 1, 0) * CFrame.Angles(1.5707963267948966, 0, 0),
							["Left Arm"] = CFrame.new(-1, 0.5, 0) * CFrame.Angles(1.7453292519943295, 0, 0),
							["Right Arm"] = CFrame.new(1, 0.5, 0) * CFrame.Angles(1.7453292519943295, 0, 0),
							["Left Leg"] = CFrame.new(0, 1, 0) * CFrame.Angles(1.5707963267948966, 0, -0.69813170079773179),
							["Right Leg"] = CFrame.new(0, 1, 0) * CFrame.Angles(1.5707963267948966, 0, 0.69813170079773179),
							Torso = CFrame.new(0, 0, 0) * CFrame.Angles(1.7453292519943295, -3.1415926535897931, 0),
						},
					},
				},
				["Pose 3"] = {
					Target = {
						Offset = CFrame.new(0, 0, -1.2),
						Limbs = {
							Head = CFrame.new(0, 1, 0) * CFrame.Angles(-0.17453292519943295, 0, 0),
							["Left Arm"] = CFrame.new(-1, 0.5, 0) * CFrame.Angles(1.9198621771937625, 0, 0.52359877559829882),
							["Right Arm"] = CFrame.new(1, 0.5, 0) * CFrame.Angles(1.9198621771937625, 0, -0.52359877559829882),
							["Left Leg"] = CFrame.new(0, 1, 0) * CFrame.Angles(1.3089969389957472, 0, -0.3490658503988659),
							["Right Leg"] = CFrame.new(0, 1, 0) * CFrame.Angles(1.3089969389957472, 0, 0.3490658503988659),
							Torso = CFrame.new(0, 0, 0),
						},
					},
				},
				["Pose 4"] = {
					Target = {
						Offset = CFrame.new(0, -1.4, -1.4),
						Limbs = {
							Head = CFrame.new(0, 1, 0) * CFrame.Angles(-0.78539816339744828, 0, 0),
							["Left Arm"] = CFrame.new(-1, 0.5, 0) * CFrame.Angles(0, 0, 0),
							["Right Arm"] = CFrame.new(1, 0.5, 0) * CFrame.Angles(0, 0, 0),
							["Left Leg"] = CFrame.new(0, 1, 0) * CFrame.Angles(0, 0, -0.78539816339744828),
							["Right Leg"] = CFrame.new(0, 1, 0) * CFrame.Angles(0, 0, 0.78539816339744828),
							Torso = CFrame.new(0, 0, 0) * CFrame.Angles(1.5707963267948966, 0, 0),
						},
					},
				},
				["Pose 5"] = {
					Target = {
						Offset = CFrame.new(0, 2.3, 1),
						Limbs = {
							Head = CFrame.new(0, 1, 0) * CFrame.Angles(-0.3490658503988659, 0, 0),
							["Left Arm"] = CFrame.new(-1, 0.5, 0) * CFrame.Angles(0.52359877559829882, 0, 0.69813170079773179),
							["Right Arm"] = CFrame.new(1, 0.5, 0) * CFrame.Angles(0.52359877559829882, 0, -0.69813170079773179),
							["Left Leg"] = CFrame.new(0, 1, 0) * CFrame.Angles(1.3264502315156905, 0.12217304763960307, -0.50614548307835561),
							["Right Leg"] = CFrame.new(0, 1, 0) * CFrame.Angles(1.3264502315156905, 0.12217304763960307, 0.50614548307835561),
							Torso = CFrame.new(0, 0, 0) * CFrame.Angles(0.13962634015954636, 0, 0),
						},
					},
				},
			}

			U787.pose1 = U787["Pose 1"]
			U787.pose2 = U787["Pose 2"]
			U787.pose3 = U787["Pose 3"]
			U787.pose4 = U787["Pose 4"]
			U787.pose5 = U787["Pose 5"]
			local U788 = nil
			local U789 = {}

			local function F_001170(A1170_1)
				if not A1170_1 or not A1170_1:IsA("BasePart") then
					return nil, nil
				end
				local L1170_1 = A1170_1:FindFirstChild("ST_PoseBP")

				if not L1170_1 then
					L1170_1 = Instance.new("BodyPosition")
					L1170_1.Name = "ST_PoseBP"
					L1170_1.MaxForce = Vector3.new(100000000, 100000000, 100000000)
					L1170_1.P = 60000
					L1170_1.D = 2500
					L1170_1.Parent = A1170_1
					table.insert(U789, L1170_1)
				else
					L1170_1.MaxForce = Vector3.new(100000000, 100000000, 100000000)
					L1170_1.P = 60000
					L1170_1.D = 2500
				end

				local L1170_2 = A1170_1:FindFirstChild("ST_PoseBG")

				if not L1170_2 then
					L1170_2 = Instance.new("BodyGyro")
					L1170_2.Name = "ST_PoseBG"
					L1170_2.MaxTorque = Vector3.new(100000000, 100000000, 100000000)
					L1170_2.P = 60000
					L1170_2.D = 2500
					L1170_2.Parent = A1170_1
					table.insert(U789, L1170_2)
				else
					L1170_2.MaxTorque = Vector3.new(100000000, 100000000, 100000000)
					L1170_2.P = 60000
					L1170_2.D = 2500
				end

				return L1170_1, L1170_2
			end

			local function F_001171()
				for I447, I448 in ipairs(U789) do
					if I448 and I448.Parent then
						pcall(function()
							I448:Destroy()
						end)
					end
				end

				table.clear(U789)
				local L1171_1 = U88(U65.PosesTarget and U65.PosesTarget.Value)

				if L1171_1 and L1171_1.Character then
					for I449, I450 in ipairs(L1171_1.Character:GetDescendants()) do
						if I450.Name == "ST_PoseBP" or I450.Name == "ST_PoseBG" then
							pcall(function()
								I450:Destroy()
							end)
						end
					end

					local L1171_2 = L1171_1.Character:FindFirstChildOfClass("Humanoid")

					if L1171_2 then
						L1171_2.PlatformStand = false
					end
				end
			end

			local U790 = nil

			local function F_001174()
				local L1174_1 = workspace:FindFirstChild(U68.Name .. "SpawnedInToys")
				L1174_1 = L1174_1 and L1174_1:FindFirstChild("ST_PosePallet")

				if not L1174_1 or not L1174_1.Parent then
					local L1174_2 = U68.Character
					local L1174_3 = L1174_2 and L1174_2:FindFirstChild("HumanoidRootPart")
					L1174_1 = U90("PalletLightBrown", L1174_3 and L1174_3.CFrame * CFrame.new(0, 100, 0) or CFrame.new(0, 1e9, 0))

					if L1174_1 then
						L1174_1.Name = "ST_PosePallet"

						for I451, I452 in ipairs(L1174_1:GetDescendants()) do
							if I452:IsA("BasePart") then
								I452.Transparency = 1
								I452.CanCollide = false
							end
						end
					end
				end

				U790 = L1174_1
				return L1174_1
			end

			local function F_001175(A1175_1)
				if not A1175_1 then
					return
				end
				local L1175_1 = F_001174()
				local U791 = L1175_1 and L1175_1:FindFirstChild("SoundPart")
				if not U791 then
					return
				end
				local L1175_2 = game:GetService("ReplicatedStorage")
				local U792 = L1175_2:FindFirstChild("GrabEvents") and L1175_2.GrabEvents:FindFirstChild("SetNetworkOwner")

				if U792 then
					for I453 = 1, 3 do
						pcall(function()
							U792:FireServer(U791, U791.CFrame)
						end)

						if not (U791:FindFirstChild("PartOwner") and U791.PartOwner.Value == U68.Name) then
							task.wait(0.02)
							continue
						end
						break
					end
				end

				pcall(function()
					U791.AssemblyLinearVelocity = Vector3.new(0, 15, 0)
					U791.CanCollide = true
					U791.CFrame = A1175_1.CFrame
					task.wait(0.04)
					U791.CanCollide = false
					U791.CFrame = CFrame.new(0, 1e9, 0)
					U791.AssemblyLinearVelocity = Vector3.zero
				end)
			end

			local function F_001178()
				if U790 and U790.Parent then
					pcall(function()
						local L1179_1 = game:GetService("ReplicatedStorage"):FindFirstChild("MenuToys") and game:GetService("ReplicatedStorage").MenuToys:FindFirstChild("DestroyToy")

						if L1179_1 then
							L1179_1:FireServer(U790)
						end
					end)

					U790 = nil
				end

				local L1178_1 = workspace:FindFirstChild(U68.Name .. "SpawnedInToys")

				if L1178_1 then
					for I454, I455 in ipairs(L1178_1:GetChildren()) do
						if I455.Name == "ST_PosePallet" then
							pcall(function()
								local L1180_1 = game:GetService("ReplicatedStorage"):FindFirstChild("MenuToys") and game:GetService("ReplicatedStorage").MenuToys:FindFirstChild("DestroyToy")

								if L1180_1 then
									L1180_1:FireServer(I455)
								end
							end)
						end
					end
				end
			end

			local function F_001181()
				F_001171()

				if U788 then
					pcall(function()
						task.cancel(U788)
					end)

					U788 = nil
				end

				U788 = task.spawn(function()
					local L1183_1 = game:GetService("ReplicatedStorage"):WaitForChild("GrabEvents")
					local U793 = L1183_1:WaitForChild("SetNetworkOwner")
					local U794 = L1183_1:WaitForChild("DestroyGrabLine")
					local U795 = Vector3.zero
					local U796 = nil

					local function F_001184()
						return U88(U65.PosesTarget and U65.PosesTarget.Value)
					end

					local function F_001185(A1185_1)
						if not A1185_1 or not A1185_1.Parent then
							return false
						end
						local L1185_1 = A1185_1.Character
						if not L1185_1 then
							return false
						end
						local L1185_2 = L1185_1:FindFirstChild("Humanoid")
						if not L1185_2 or L1185_2.Health <= 0 then
							return false
						end
						return L1185_1:FindFirstChild("HumanoidRootPart") ~= nil
					end

					local function F_001186(A1186_1, A1186_2, A1186_3, A1186_4)
						pcall(function()
							local L1187_1 = typeof(getgenv) == "function" and getgenv() or _G

							if type(L1187_1.ST_DecoyManual) == "function" then
								L1187_1.ST_DecoyManual(2.5)
							end
						end)

						A1186_4.CFrame = A1186_1.CFrame * CFrame.new(0, -6, 0)
						A1186_4.AssemblyLinearVelocity = U795
						A1186_4.AssemblyAngularVelocity = U795

						pcall(function()
							A1186_2.PlatformStand = true
							A1186_2.Sit = false
						end)

						F_001175(A1186_1)

						pcall(function()
							U793:FireServer(A1186_1, A1186_1.CFrame)
							U794:FireServer(A1186_1)

							for I456, I457 in ipairs(A1186_3:GetChildren()) do
								if I457:IsA("BasePart") then
									U793:FireServer(I457, I457.CFrame)
								end
							end
						end)

						task.wait(0.06)

						pcall(function()
							A1186_2:ChangeState(Enum.HumanoidStateType.Physics)
						end)

						A1186_4.CFrame = U796
						A1186_4.AssemblyLinearVelocity = U795
						A1186_4.AssemblyAngularVelocity = U795
					end

					local L1183_2 = nil
					local L1183_3 = false
					local L1183_4 = nil

					while U66.PosesLoopApply and U66.PosesLoopApply.Value do
						task.wait(0.02)
						local L1183_5 = F_001184()

						if L1183_5 ~= L1183_2 then
							F_001171()
							L1183_3 = false
							L1183_4 = nil
							L1183_2 = L1183_5
						end

						if not L1183_5 then
							task.wait(0.2)
						elseif not F_001185(L1183_5) then
							F_001171()
							task.wait(0.3)
							L1183_3 = false
							L1183_4 = nil
						else
							local L1183_6 = U68.Character
							L1183_6 = L1183_6 and L1183_6:FindFirstChild("HumanoidRootPart")

							if not L1183_6 then
								task.wait()
							else
								local U797 = L1183_5.Character
								local U798 = U797:FindFirstChild("HumanoidRootPart")
								local L1183_7 = U797:FindFirstChildOfClass("Humanoid")

								if not U798 or not L1183_7 then
									task.wait()
								else
									local L1183_8 = U787[U65.SelectPose and U65.SelectPose.Value or "Pose 1"] or U787["Pose 1"]

									if L1183_8 then
										if not L1183_3 then
											U796 = L1183_6.CFrame
											F_001186(U798, L1183_7, U797, L1183_6)
											L1183_4 = tick() + 0.5
											L1183_3 = true
										else
											U796 = L1183_6.CFrame
											local L1183_9 = (L1183_6.Position - U798.Position).Magnitude
											local L1183_10 = L1183_7:FindFirstChild("Ragdolled") and L1183_7.Ragdolled.Value == true or L1183_7.PlatformStand == true
											local L1183_11, L1183_12, L1183_13, L1183_14, L1183_15, L1183_16, L1183_17, L1183_18, L1183_19, L1183_20, L1183_21, L1183_22, L1183_23, L1183_24, L1183_25, L1183_26, L1183_27, L1183_28, L1183_29, L1183_30, L1183_31

											if L1183_4 and tick() >= L1183_4 then
												if L1183_9 > 40 or not L1183_10 then
													F_001171()
													L1183_3 = false
													L1183_4 = nil
												else
													pcall(function()
														U793:FireServer(U798, U798.CFrame)

														for I458, I459 in ipairs(U797:GetChildren()) do
															if I459:IsA("BasePart") then
																U793:FireServer(I459, I459.CFrame)
															end
														end
													end)

													L1183_11 = U65.PoseDistX and U65.PoseDistX.Value or 0
													L1183_12 = U65.PoseDistY and U65.PoseDistY.Value or 0
													L1183_13 = U65.PoseDistZ and U65.PoseDistZ.Value or 0
													L1183_14 = CFrame.new(L1183_11, L1183_12, L1183_13)
													L1183_15 = U65.PoseRotX and U65.PoseRotX.Value or 0
													L1183_16 = U65.PoseRotY and U65.PoseRotY.Value or -180
													L1183_17 = U65.PoseRotZ and U65.PoseRotZ.Value
													L1183_18 = L1183_17 or 0
													L1183_19 = CFrame.Angles
													L1183_20 = math.rad(L1183_15)
													L1183_21 = math.rad
													L1183_22 = L1183_6.CFrame * L1183_8.Target.Offset * L1183_14 * L1183_19(L1183_20, math.rad(L1183_16), L1183_21(L1183_18))
													L1183_23, L1183_24 = F_001170(U798)
													L1183_25 = L1183_23 and L1183_24

													if L1183_25 then
														L1183_23.Position = L1183_22.Position
														L1183_24.CFrame = L1183_22
														U798.CanCollide = false
														U798.AssemblyLinearVelocity = U795
														U798.AssemblyAngularVelocity = U795
													end

													if L1183_8.Target.Limbs then
														for I460, I461 in pairs(L1183_8.Target.Limbs) do
															L1183_26 = U797:FindFirstChild(I460)
															L1183_27 = L1183_26 and L1183_26:IsA("BasePart")

															if L1183_27 then
																L1183_28, L1183_29 = F_001170(L1183_26)
																L1183_30 = L1183_28 and L1183_29

																if L1183_30 then
																	L1183_31 = L1183_22 * I461
																	L1183_28.Position = L1183_31.Position
																	L1183_29.CFrame = L1183_31
																	L1183_26.CanCollide = false
																	L1183_26.AssemblyLinearVelocity = U795
																	L1183_26.AssemblyAngularVelocity = U795
																end
															end
														end
													end
												end
											else
												pcall(function()
													U793:FireServer(U798, U798.CFrame)

													for I462, I463 in ipairs(U797:GetChildren()) do
														if I463:IsA("BasePart") then
															U793:FireServer(I463, I463.CFrame)
														end
													end
												end)

												L1183_11 = U65.PoseDistX and U65.PoseDistX.Value or 0
												L1183_12 = U65.PoseDistY and U65.PoseDistY.Value or 0
												L1183_13 = U65.PoseDistZ and U65.PoseDistZ.Value or 0
												L1183_14 = CFrame.new(L1183_11, L1183_12, L1183_13)
												L1183_15 = U65.PoseRotX and U65.PoseRotX.Value or 0
												L1183_16 = U65.PoseRotY and U65.PoseRotY.Value or -180
												L1183_17 = U65.PoseRotZ and U65.PoseRotZ.Value
												L1183_18 = L1183_17 or 0
												L1183_19 = CFrame.Angles
												L1183_20 = math.rad(L1183_15)
												L1183_21 = math.rad
												L1183_22 = L1183_6.CFrame * L1183_8.Target.Offset * L1183_14 * L1183_19(L1183_20, math.rad(L1183_16), L1183_21(L1183_18))
												L1183_23, L1183_24 = F_001170(U798)
												L1183_25 = L1183_23 and L1183_24

												if L1183_25 then
													L1183_23.Position = L1183_22.Position
													L1183_24.CFrame = L1183_22
													U798.CanCollide = false
													U798.AssemblyLinearVelocity = U795
													U798.AssemblyAngularVelocity = U795
												end

												if L1183_8.Target.Limbs then
													for I464, I465 in pairs(L1183_8.Target.Limbs) do
														L1183_26 = U797:FindFirstChild(I464)
														L1183_27 = L1183_26 and L1183_26:IsA("BasePart")

														if L1183_27 then
															L1183_28, L1183_29 = F_001170(L1183_26)
															L1183_30 = L1183_28 and L1183_29

															if L1183_30 then
																L1183_31 = L1183_22 * I465
																L1183_28.Position = L1183_31.Position
																L1183_29.CFrame = L1183_31
																L1183_26.CanCollide = false
																L1183_26.AssemblyLinearVelocity = U795
																L1183_26.AssemblyAngularVelocity = U795
															end
														end
													end
												end
											end
										end
									end
								end
							end
						end
					end

					F_001171()
					F_001178()
				end)
			end

			L0_383:AddToggle("PosesLoopApply", {
				Text = "Loop Apply Method Selected",
				Default = false,
				Callback = function(A1193_1)
					if A1193_1 then
						F_001181()
					else
						if U788 then
							pcall(function()
								task.cancel(U788)
							end)

							U788 = nil
						end

						F_001171()
						F_001178()
					end
				end,
			})
		end

		L0_383:AddDivider("Pose Settings")

		L0_383:AddDropdown("SelectPose", {
			Text = "Select Pose",
			Values = { "Pose 1", "Pose 2", "Pose 3", "Pose 4", "Pose 5" },
			ValueImages = {
				["Pose 1"] = "user",
				["Pose 2"] = "user",
				["Pose 3"] = "user",
				["Pose 4"] = "user",
				["Pose 5"] = "user",
			},
			Default = 1,
			Callback = function()
			end,
		})

		L0_383:AddDivider()

		L0_383:AddSlider("PoseDistX", {
			Text = "Distance X",
			Default = 0,
			Min = -30,
			Max = 30,
			Rounding = 1,
			Compact = true,
			Callback = function()
			end,
		})

		L0_383:AddSlider("PoseDistY", {
			Text = "Distance Y",
			Default = 0,
			Min = -30,
			Max = 30,
			Rounding = 1,
			Compact = true,
			Callback = function()
			end,
		})

		L0_383:AddSlider("PoseDistZ", {
			Text = "Distance Z",
			Default = 0,
			Min = -30,
			Max = 30,
			Rounding = 1,
			Compact = true,
			Callback = function()
			end,
		})

		L0_383:AddDivider()

		L0_383:AddSlider("PoseRotX", {
			Text = "Rotation X",
			Default = 0,
			Min = -180,
			Max = 180,
			Rounding = 0,
			Compact = true,
			Callback = function()
			end,
		})

		L0_383:AddSlider("PoseRotY", {
			Text = "Rotation Y",
			Default = -180,
			Min = -180,
			Max = 180,
			Rounding = 0,
			Compact = true,
			Callback = function()
			end,
		})

		L0_383:AddSlider("PoseRotZ", {
			Text = "Rotation Z",
			Default = 0,
			Min = -180,
			Max = 180,
			Rounding = 0,
			Compact = true,
			Callback = function()
			end,
		})

		do
			local U799 = false
			local U800 = nil

			local function F_001202()
				local L1202_1 = workspace:FindFirstChild(U68.Name .. "SpawnedInToys")
				local U801 = game:GetService("ReplicatedStorage"):FindFirstChild("MenuToys") and game:GetService("ReplicatedStorage").MenuToys:FindFirstChild("DestroyToy")

				if L1202_1 and U801 then
					for I466, I467 in ipairs(L1202_1:GetChildren()) do
						local L1202_2 = I467.Name:lower()

						if L1202_2:find("coconut") or L1202_2:find("basketball") or L1202_2:find("magiclight") or L1202_2:find("magic") or L1202_2:find("mayonnaise") then
							pcall(function()
								U801:FireServer(I467)
							end)
						end
					end
				end
			end

			local function F_001204()
				local L1204_1 = U68
				local L1204_2 = game:GetService("ReplicatedStorage")
				local U802 = L1204_2.GrabEvents.SetNetworkOwner
				local U803 = L1204_2.MenuToys.SpawnToyRemoteFunction
				local U804 = L1204_2.MenuToys.DestroyToy
				local L1204_3 = { CFrame.new(-0.45, -1.2, -0.7), CFrame.new(0.45, -1.2, -0.7), (CFrame.new(0, -1, 0.8)) }
				local L1204_4 = {}
				local L1204_5 = { Coconut = "FoodCoconut", BallBasketball = "BallBasketball", BallMagicLight = "BallMagicLight" }

				while U799 do
					local L1204_6 = L1204_1.Character
					local U805 = L1204_6 and L1204_6:FindFirstChild("HumanoidRootPart")

					if not U805 then
						task.wait(0.1)
					else
						local L1204_7 = workspace:FindFirstChild(L1204_1.Name .. "SpawnedInToys")
						local L1204_8 = U65.SelectPenisDropdown and U65.SelectPenisDropdown.Value or "Coconut"
						local U806 = L1204_5[L1204_8] or "FoodCoconut"

						if not L1204_7 then
							task.spawn(function()
								pcall(function()
									U803:InvokeServer(U806, U805.CFrame * CFrame.new(-5, 0, 10), Vector3.zero)
								end)
							end)

							task.wait(0.2)
						else
							local L1204_9 = U65.CustomPenisLength and U65.CustomPenisLength.Value or 10
							table.clear(L1204_4)

							for I468, I469 in ipairs(L1204_7:GetChildren()) do
								local L1204_10 = I469.Name:lower()
								local L1204_11 = L1204_8 == "Coconut" and (L1204_10:find("coconut") ~= nil or I469.Name == "FoodCoconut") or L1204_8 == "BallBasketball" and (L1204_10:find("basketball") ~= nil or I469.Name == "BallBasketball")

								if not L1204_11 then
									L1204_11 = L1204_8 == "BallMagicLight"

									if L1204_11 then
										L1204_11 = L1204_10:find("magiclight") ~= nil or L1204_10:find("magic") ~= nil or I469.Name == "BallMagicLight"
									end
								end

								if L1204_11 or I469.Name == U806 then
									table.insert(L1204_4, I469)
								end
							end

							if #L1204_4 < L1204_9 + 2 then
								task.spawn(function()
									pcall(function()
										U803:InvokeServer(U806, U805.CFrame * CFrame.new(-5, 0, 10), Vector3.zero)
									end)
								end)
							end

							local L1204_12 = U65.CustomPenisLength and U65.CustomPenisLength.Value or 10
							local L1204_13 = U65.CustomPenisSpacing and U65.CustomPenisSpacing.Value or 1
							local L1204_14 = U65.CustomPenisHeight and U65.CustomPenisHeight.Value or 0
							local L1204_15 = U65.CustomPenisHorizontal and U65.CustomPenisHorizontal.Value or 0
							local L1204_16 = U65.CustomPenisCurve and U65.CustomPenisCurve.Value or 0
							local L1204_17 = CFrame.new(0, L1204_14 * 0.1, -L1204_15 * 0.1)

							for I470, I471 in ipairs(L1204_4) do
								local U807 = I471:FindFirstChild("SoundPart") or I471:FindFirstChild("HoldPart") or I471:FindFirstChildWhichIsA("BasePart")

								if U807 then
									local L1204_18 = U807:FindFirstChild("PartOwner") or I471:FindFirstChild("PartOwner")

									if not L1204_18 or L1204_18.Value == L1204_1.Name then
										local L1204_19

										if I470 <= 2 then
											L1204_19 = U805.CFrame * L1204_3[I470] * L1204_17
										else
											local L1204_20 = I470 - 3
											local L1204_21 = L1204_3[3].Z - 3.2 - L1204_20 * L1204_13
											L1204_19 = U805.CFrame * L1204_3[3] * L1204_17 * CFrame.Angles(math.rad(L1204_16 * 1.5 * L1204_20 / math.max(1, L1204_12)), 0, 0) * CFrame.new(0, L1204_20 ^ 1.3 * L1204_16 * 0.015, L1204_21)
										end

										U807.CFrame = L1204_19
										U807.Velocity = Vector3.zero
									else
										pcall(function()
											U802:FireServer(U807, U807.CFrame)
										end)
									end

									local L1204_22 = I471:FindFirstChild("HoldPart")
									L1204_22 = L1204_22 and L1204_22:FindFirstChild("RigidConstraint")

									if L1204_22 and L1204_22.Attachment1 then
										pcall(function()
											U804:FireServer(I471)
										end)
									end

									for I472, I473 in ipairs(I471:GetChildren()) do
										if I473:IsA("BasePart") then
											I473.CanCollide = false
											I473.CanQuery = false

											if I473.Transparency ~= 1 then
												I473.Transparency = 0
											end
										end
									end
								end
							end

							task.wait(0.01)
						end
					end
				end
			end

			local L0_384 = U92.Fun:AddGroupbox({
				Side = 2,
				Name = "<b>Custom Penis</b>",
				IconName = "pencil",
				Description = "Toy attach",
				MaxPopOutHeight = 600,
				PopOutWidth = 250,
			})

			L0_384:AddToggle("EnablePenis", {
				Text = "Enable Penis",
				Default = false,
				Callback = function(A1211_1)
					U799 = A1211_1

					if A1211_1 then
						U800 = task.spawn(F_001204)
					else
						if U800 then
							task.cancel(U800)
							U800 = nil
						end

						F_001202()
					end
				end,
			}):AddKeyPicker("EnablePenisKey", {
				Default = "None",
				Mode = "Toggle",
				SyncToggleState = true,
				Text = "Enable Penis Key",
				Callback = function()
				end,
			})

			L0_384:AddDivider("Select Penis")

			L0_384:AddDropdown("SelectPenisDropdown", {
				Values = { "Coconut", "BallBasketball", "BallMagicLight" },
				ValueImages = L0_312,
				Default = 1,
				Callback = function()
					if U799 then
						F_001202()
					end
				end,
			})

			L0_384:AddDivider("Settings")

			L0_384:AddSlider("CustomPenisLength", {
				Text = "Amount",
				Default = 10,
				Min = 1,
				Max = 33,
				Rounding = 0,
				Compact = true,
				Callback = function()
				end,
			})

			L0_384:AddSlider("CustomPenisSpacing", {
				Text = "Spacing",
				Default = 1,
				Min = 0.1,
				Max = 3,
				Rounding = 2,
				Compact = true,
				Callback = function()
				end,
			})

			L0_384:AddLabel("<b>Don't use more than 13 if you don't have Raised Toys Limit gamepass!</b>", true)
			L0_384:AddDivider()

			L0_384:AddSlider("CustomPenisHeight", {
				Text = "Height",
				Default = 0,
				Min = -20,
				Max = 20,
				Rounding = 1,
				Compact = true,
				Callback = function()
				end,
			})

			L0_384:AddSlider("CustomPenisHorizontal", {
				Text = "Horizontal",
				Default = 0,
				Min = -20,
				Max = 20,
				Rounding = 1,
				Compact = true,
				Callback = function()
				end,
			})

			L0_384:AddSlider("CustomPenisCurve", {
				Text = "Curve",
				Default = 0,
				Min = -30,
				Max = 30,
				Rounding = 1,
				Compact = true,
				Callback = function()
				end,
			})
		end

		local L0_385, U808, U809

		do
			local L0_386 = U92.Miscs:AddGroupbox({
				Side = 1,
				Name = "<b>GUI & Visuals</b>",
				IconName = "layout-grid",
				Description = "UI tweaks",
				MaxPopOutHeight = 600,
				PopOutWidth = 250,
			}):AddTabbox({ MaxPopOutHeight = 600 })

			L0_385 = L0_386:AddTab("<b>Blackholes</b>", "moon")
			L0_385:AddDivider("Blackhole Settings")

			U808 = {
				Void = "118291966494307",
				["Dark Void"] = "8039917116",
				["Sand Storm"] = "15637811539",
				["Elite Purple"] = "15062760533",
				["Realistic Blackhole"] = "92962502578497",
			}

			U809 = {}

			L0_385:AddToggle("ToggleCustomBlackhole", {
				Text = "Custom Black Hole",
				Default = true,
				Callback = function()
				end,
			})

			L0_385:AddDropdown("SelectBlackhole", {
				Text = "Blackhole Type",
				Values = {
					"Void",
					"Dark Void",
					"Sand Storm",
					"Elite Purple",
					"Realistic Blackhole",
					"Random",
				},
				ValueImages = {
					Void = "circle",
					["Dark Void"] = "circle-dot",
					["Sand Storm"] = "wind",
					["Elite Purple"] = "sparkles",
					["Realistic Blackhole"] = "disc",
					Random = "shuffle",
				},
				Default = "Void",
				Callback = function()
				end,
			})

			L0_385:AddDivider()

			L0_385:AddInput("BlackholeAssetInput", {
				Default = "",
				Numeric = true,
				Finished = true,
				Text = "Add Custom Asset ID",
				Placeholder = "Enter Asset ID...",
				Callback = function(A1221_1)
					local U810 = tostring(A1221_1):gsub("%D", "")

					if #U810 >= 5 then
						U808[U810] = U810
						U809[U810] = true
						local L1221_1 = U65.SelectBlackhole.Values

						if not table.find(L1221_1, U810) then
							table.insert(L1221_1, U810)
							U65.SelectBlackhole:SetValues(L1221_1)
						end

						U65.SelectBlackhole:SetValue(U810)

						pcall(function()
							U62:Notify({ Title = "Custom Blackhole", Description = "Added custom asset: " .. U810, Duration = 3 })
						end)
					end
				end,
			})

			L0_385:AddButton({
				Text = "Add Asset to List",
				Func = function()
					local U811 = tostring(U65.BlackholeAssetInput and U65.BlackholeAssetInput.Value or ""):gsub("%D", "")

					if #U811 >= 5 then
						U808[U811] = U811
						U809[U811] = true
						local L1223_1 = U65.SelectBlackhole.Values

						if not table.find(L1223_1, U811) then
							table.insert(L1223_1, U811)
							U65.SelectBlackhole:SetValues(L1223_1)
						end

						U65.SelectBlackhole:SetValue(U811)

						pcall(function()
							U62:Notify({ Title = "Custom Blackhole", Description = "Added custom asset: " .. U811, Duration = 3 })
						end)
					end
				end,
				DoubleClick = false,
			})

			local L0_387 = L0_386:AddTab("<b>Gui</b>", "panel-bottom-dashed")
			local U812 = nil
			local U813 = nil

			local function F_001225()
				local L1225_1 = U68:FindFirstChildOfClass("PlayerGui") or U68:FindFirstChild("PlayerGui")
				if not L1225_1 then
					return nil, nil
				end

				for I474, I475 in ipairs(L1225_1:GetChildren()) do
					if I475:IsA("ScreenGui") then
						local L1225_2 = I475:FindFirstChild("TopRight", true)

						if L1225_2 then
							local L1225_3 = L1225_2:FindFirstChild("CoinsFrame") or L1225_2:FindFirstChild("CoinsFrame", true)

							if L1225_3 then
								local L1225_4 = L1225_3:FindFirstChild("CoinsDisplay") or L1225_3:FindFirstChild("CoinsDisplay", true)
								if L1225_4 then
									return L1225_4, L1225_3
								end
								continue
							end
						end
					end
				end

				for I476, I477 in ipairs(L1225_1:GetDescendants()) do
					if I477.Name == "CoinsDisplay" and I477.Parent and I477.Parent.Name == "CoinsFrame" then
						return I477, I477.Parent
					end
				end

				return nil, nil
			end

			local function F_001226()
				if not (U66.EnableCustomCoins and U66.EnableCustomCoins.Value) then
					return
				end
				local L1226_1 = U65.CoinsInput and U65.CoinsInput.Value
				if not L1226_1 or L1226_1 == "" then
					return
				end
				local L1226_2 = F_001225()
				L1226_2 = L1226_2 and L1226_2:FindFirstChild("Coins")

				if L1226_2 and L1226_2.Text ~= tostring(L1226_1) then
					L1226_2.Text = tostring(L1226_1)
				end
			end

			U68.CharacterAdded:Connect(function()
				task.delay(0.5, F_001226)
			end)

			local function F_001228(A1228_1)
				local L1228_1, L1228_2 = F_001225()
				if not L1228_1 then
					return
				end
				local U814 = L1228_1:FindFirstChild("CoinImage")
				local L1228_3 = L1228_1:FindFirstChild("Coins")

				if not U812 then
					U812 = {
						Image = U814 and U814.Image,
						ImageRectOffset = U814 and U814.ImageRectOffset,
						ImageRectSize = U814 and U814.ImageRectSize,
						ImageColor3 = U814 and U814.ImageColor3,
						TextColor3 = L1228_3 and L1228_3.TextColor3,
					}
				end

				if U813 then
					U813:Disconnect()
					U813 = nil
				end

				local L1228_4 = L1228_1:FindFirstChild("ST_BorderBeamStroke")

				if L1228_4 then
					L1228_4:Destroy()
				end

				if A1228_1 == "ST" then
					if U814 then
						for I478, I479 in ipairs(U814:GetChildren()) do
							if I479.Name == "_CPUDrawn" or I479.Name == "_CPUOverlay" then
								I479:Destroy()
							end
						end

						U814.ImageTransparency = 0
						U814.ImageColor3 = Color3.fromRGB(255, 255, 255)
						U814.ScaleType = Enum.ScaleType.Fit

						pcall(function()
							U814.ResampleMode = Enum.ResamplerMode.Default
						end)

						local U815 = false

						pcall(function()
							if typeof(getcustomasset) == "function" then
								if not (isfile and isfile("st_lucide_cpu_256.png")) then
									if typeof(writefile) == "function" then
										writefile("st_lucide_cpu_256.png", game:HttpGet("https://files.catbox.moe/ck0vya.png"))
									end
								end

								if isfile and isfile("st_lucide_cpu_256.png") then
									U814.Image = getcustomasset("st_lucide_cpu_256.png")
									U814.ImageRectOffset = Vector2.zero
									U814.ImageRectSize = Vector2.zero
									U815 = true
								end
							end
						end)

						if not U815 then
							pcall(function()
								local L1231_1 = U62.GetCustomIcon and U62:GetCustomIcon("cpu")
								local L1231_2

								if L1231_1 then
									L1231_2 = L1231_1
								else
									L1231_2 = U62.GetIcon and U62:GetIcon("cpu")
								end

								if L1231_2 and U62.ApplyLucideIcon then
									U62:ApplyLucideIcon(U814, L1231_2)
								end
							end)
						end
					end

					if L1228_3 then
						L1228_3.TextColor3 = Color3.fromRGB(255, 255, 255)
					end

					local L1228_5 = L1228_1:FindFirstChildOfClass("UICorner") or L1228_2 and L1228_2:FindFirstChildOfClass("UICorner")
					L1228_5 = L1228_5 and L1228_5.CornerRadius or UDim.new(0, 8)

					if not L1228_1:FindFirstChildOfClass("UICorner") then
						local L1228_6 = Instance.new("UICorner")
						L1228_6.Name = "ST_CoinsDisplayCorner"
						L1228_6.CornerRadius = L1228_5
						L1228_6.Parent = L1228_1
					end

					local L1228_7 = Instance.new("UIStroke")
					L1228_7.Name = "ST_BorderBeamStroke"
					L1228_7.Thickness = 2.5
					L1228_7.Color = Color3.fromRGB(255, 255, 255)
					L1228_7.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
					L1228_7.Parent = L1228_1
					local U816 = Instance.new("UIGradient")
					U816.Name = "ST_BeamGradient"
					U816.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255))
					local L1228_8 = NumberSequence.new
					local L1228_9 = {}
					local L1228_10 = NumberSequenceKeypoint.new(0, 0)
					local L1228_11 = NumberSequenceKeypoint.new(0.12, 0.05)
					local L1228_12 = NumberSequenceKeypoint.new(0.3, 0.25)
					local L1228_13 = NumberSequenceKeypoint.new(0.6, 0.75)
					local L1228_14 = NumberSequenceKeypoint.new(0.85, 0.96)
					L1228_9[1] = L1228_10
					L1228_9[2] = L1228_11
					L1228_9[3] = L1228_12
					L1228_9[4] = L1228_13
					L1228_9[5] = L1228_14

					do
						local L1228_15 = table.pack(NumberSequenceKeypoint.new(1, 1))
						table.move(L1228_15, 1, L1228_15.n, 6, L1228_9)
					end

					U816.Transparency = L1228_8(L1228_9)
					U816.Parent = L1228_7
					local U817 = 0

					U813 = U69.RenderStepped:Connect(function(A1232_1)
						if not U816 or not U816.Parent then
							if U813 then
								U813:Disconnect()
								U813 = nil
							end

							return
						end

						U817 = (U817 + A1232_1 * 130) % 360
						U816.Rotation = U817
					end)
				elseif A1228_1 == "Old Coin UI" or A1228_1 == "Old" then
					if U814 and U812 then
						U814.Image = U812.Image
						U814.ImageRectOffset = U812.ImageRectOffset
						U814.ImageRectSize = U812.ImageRectSize
						U814.ImageColor3 = Color3.fromRGB(255, 215, 0)
					end

					if L1228_3 then
						L1228_3.TextColor3 = Color3.fromRGB(255, 215, 0)
					end
				else
					if U814 and U812 then
						U814.Image = U812.Image
						U814.ImageRectOffset = U812.ImageRectOffset
						U814.ImageRectSize = U812.ImageRectSize
						U814.ImageColor3 = U812.ImageColor3 or Color3.fromRGB(255, 255, 255)
					end

					if L1228_3 and U812 then
						L1228_3.TextColor3 = U812.TextColor3 or Color3.fromRGB(255, 255, 255)
					end
				end
			end

			L0_387:AddDivider("Coins")

			L0_387:AddToggle("EnableCustomCoins", {
				Text = "Enable Custom Coins",
				Default = false,
				Callback = function(A1233_1)
					if A1233_1 then
						F_001226()
					end
				end,
			})

			L0_387:AddInput("CoinsInput", {
				Default = "",
				Numeric = false,
				Finished = false,
				Text = "Coins",
				Placeholder = "Enter coin value...",
				Callback = function()
					F_001226()
				end,
			})

			L0_387:AddDivider("GUI Settings")

			L0_387:AddDropdown("GuiTypeDropdown", {
				Text = "Type",
				IconName = "layout",
				Values = { "Default", "ST" },
				ValueImages = {
					Default = "undo",
					["Old Coin UI"] = "coins",
					["Old Toy Menu"] = "package",
					ST = "cpu",
				},
				Default = "ST",
				Callback = function(A1235_1)
					F_001228(A1235_1)
				end,
			})

			task.spawn(function()
				task.wait(0.2)

				pcall(function()
					F_001228("ST")
				end)
			end)
		end

		do
			local U818 = {}

			local function F_001238(A1238_1)
				local U819 = tostring(A1238_1 or "118291966494307"):gsub("%D", "")

				if U819 == "" then
					U819 = "118291966494307"
				end

				if U818[U819] then
					return U818[U819]:Clone()
				end

				local L1238_1, U820 = pcall(function()
					return game:GetObjects("rbxassetid://" .. U819)[1]
				end)

				if L1238_1 and U820 then
					pcall(function()
						for I480, I481 in pairs(U820:GetDescendants()) do
							if I481:IsA("Sound") then
								I481:Destroy()
							end
						end

						if U820:IsA("Sound") then
							U820.Volume = 0
							U820.Playing = false
						end
					end)

					U818[U819] = U820
					return U820:Clone()
				end

				return nil
			end

			task.spawn(function()
				for I482, I483 in pairs(U808) do
					pcall(function()
						F_001238(I483)
					end)
				end
			end)

			local function F_001243(A1243_1, A1243_2)
				if not A1243_1 then
					return
				end
				local L1243_1 = {}

				for I484, I485 in ipairs(A1243_1.Keypoints) do
					table.insert(L1243_1, NumberSequenceKeypoint.new(I485.Time, I485.Value * A1243_2, I485.Envelope * A1243_2))
				end

				return NumberSequence.new(L1243_1)
			end

			local function F_001244(A1244_1, A1244_2)
				if not A1244_1 then
					return
				end
				return NumberRange.new(A1244_1.Min * A1244_2, A1244_1.Max * A1244_2)
			end

			local function F_001245(A1245_1)
				for I486, I487 in pairs(A1245_1:GetDescendants()) do
					if I487.Name == "Drone" then
						task.defer(function()
							pcall(function()
								I487:Destroy()
							end)
						end)
					end
				end

				A1245_1.DescendantAdded:Connect(function(A1248_1)
					if A1248_1.Name == "Drone" then
						task.defer(function()
							pcall(function()
								A1248_1:Destroy()
							end)
						end)
					end
				end)
			end

			local function F_001251(A1251_1)
				if U66.ToggleCustomBlackhole and not U66.ToggleCustomBlackhole.Value then
					return
				end

				if A1251_1.Name == "Drone" then
					task.defer(function()
						pcall(function()
							A1251_1:Destroy()
						end)
					end)

					return
				end

				if A1251_1.Name == "BillboardGui" and A1251_1:IsA("BillboardGui") then
					local function F_001254()
						A1251_1.Enabled = false

						for I488, I489 in pairs(A1251_1:GetDescendants()) do
							pcall(function()
								I489.BackgroundTransparency = 1
							end)

							pcall(function()
								I489.TextTransparency = 1
							end)

							pcall(function()
								I489.ImageTransparency = 1
							end)
						end
					end

					F_001254()
					A1251_1.Changed:Connect(F_001254)
					A1251_1.DescendantAdded:Connect(F_001254)
				elseif A1251_1.Name == "Hole" and A1251_1:IsA("BasePart") then
					task.wait(0.08)
					A1251_1.Transparency = 1
					A1251_1.CanCollide = false
					A1251_1.CanTouch = false
					A1251_1.CanQuery = false
					A1251_1.Massless = true

					A1251_1:GetPropertyChangedSignal("Transparency"):Connect(function()
						if A1251_1.Transparency ~= 1 then
							A1251_1.Transparency = 1
						end
					end)

					local L1251_1 = U65.SelectBlackhole and U65.SelectBlackhole.Value or "Void"

					if L1251_1 == "Random" then
						local L1251_2 = { "Void", "Dark Void", "Sand Storm", "Elite Purple", "Realistic Blackhole" }
						L1251_1 = L1251_2[math.random(1, #L1251_2)]
					end

					local L1251_3 = U808[L1251_1] or L1251_1:gsub("%D", "")

					if not L1251_3 or L1251_3 == "" then
						L1251_3 = "118291966494307"
					end

					local U821

					if L1251_1 == "Sand Storm" or L1251_3 == "15637811539" then
						U821 = 0.5
					else
						local L1251_4 = U809[L1251_1] or U809[L1251_3]

						if not L1251_4 then
							L1251_4 = not U808[L1251_1]

							if L1251_4 then
								L1251_4 = not (L1251_1 == "Void" or L1251_1 == "Dark Void" or L1251_1 == "Elite Purple" or L1251_1 == "Realistic Blackhole")
							end
						end

						if L1251_4 then
							U821 = 1
						else
							U821 = 1.8
						end
					end

					local L1251_5 = (L1251_1 == "Elite Purple" or L1251_1 == "Purple Storm" or L1251_1:lower():find("purple") or L1251_3 == "15062760533") and 4 or 0
					local L1251_6 = F_001238(L1251_3)

					if L1251_6 and not A1251_1:GetAttribute("HasCustomHole") then
						A1251_1:SetAttribute("HasCustomHole", true)
						local U822 = A1251_1.CFrame * CFrame.new(0, L1251_5, 0)
						A1251_1.Anchored = true
						A1251_1.CFrame = U822
						A1251_1.AssemblyLinearVelocity = Vector3.zero
						A1251_1.AssemblyAngularVelocity = Vector3.zero
						local U823 = L1251_6
						U823.Name = "CustomHoleModel"
						U823.Parent = U71

						for I490, I491 in pairs(U823:GetDescendants()) do
							if I491:IsA("Sound") then
								I491:Destroy()
							end
						end

						if U821 ~= 1 then
							pcall(function()
								if U823:IsA("Model") then
									U823:ScaleTo(U821)
								elseif U823:IsA("BasePart") then
									U823.Size = U823.Size * U821
								end
							end)
						end

						local function F_001260(A1260_1)
							if A1260_1:IsA("BasePart") then
								A1260_1.CanCollide = false
								A1260_1.CanTouch = false
								A1260_1.CanQuery = false
								A1260_1.Massless = true
							elseif A1260_1:IsA("TouchTransmitter") or A1260_1:IsA("ClickDetector") or A1260_1:IsA("ProximityPrompt") then
								pcall(function()
									A1260_1:Destroy()
								end)
							end
						end

						for I492, I493 in ipairs(U823:GetDescendants()) do
							F_001260(I493)
						end

						if U823:IsA("BasePart") then
							F_001260(U823)
						end

						U823.DescendantAdded:Connect(F_001260)
						local L1251_7 = CFrame.Angles(1.5707963267948966, 0, 0)
						local U824 = {}

						local function F_001262(A1262_1)
							if A1262_1:IsA("BasePart") then
								U824[A1262_1] = { Size = A1262_1.Size }
							elseif A1262_1:IsA("SpecialMesh") or A1262_1:IsA("BlockMesh") or A1262_1:IsA("CylinderMesh") then
								U824[A1262_1] = { Scale = A1262_1.Scale }
							elseif A1262_1:IsA("Attachment") then
								U824[A1262_1] = { Position = A1262_1.Position }
							elseif A1262_1:IsA("ParticleEmitter") then
								U824[A1262_1] = { Size = A1262_1.Size, Speed = A1262_1.Speed }
							elseif A1262_1:IsA("Beam") then
								U824[A1262_1] = {
									Width0 = A1262_1.Width0,
									Width1 = A1262_1.Width1,
									CurveSize0 = A1262_1.CurveSize0,
									CurveSize1 = A1262_1.CurveSize1,
								}
							elseif A1262_1:IsA("Trail") then
								U824[A1262_1] = { WidthScale = A1262_1.WidthScale }
							elseif A1262_1:IsA("PointLight") or A1262_1:IsA("SurfaceLight") or A1262_1:IsA("SpotLight") then
								U824[A1262_1] = { Range = A1262_1.Range }
							end
						end

						if U823:IsA("Model") then
							local L1251_8 = U823:GetBoundingBox()

							for I494, I495 in pairs(U823:GetDescendants()) do
								if I495:IsA("BasePart") then
									I495.Anchored = false
									I495.CanCollide = false
									I495.CanTouch = false
									I495.CanQuery = false
									I495.Massless = true
									I495.CFrame = A1251_1.CFrame * L1251_7 * L1251_8:ToObjectSpace(I495.CFrame)
									local L1251_9 = Instance.new("WeldConstraint")
									L1251_9.Part0 = I495
									L1251_9.Part1 = A1251_1
									L1251_9.Parent = I495

									for I496, I497 in pairs(I495:GetChildren()) do
										if I497:IsA("Attachment") then
											I497.CFrame = L1251_7 * I497.CFrame
										end
									end
								end
							end
						elseif U823:IsA("BasePart") then
							U823.Anchored = false
							U823.CanCollide = false
							U823.CanTouch = false
							U823.CanQuery = false
							U823.Massless = true
							U823.CFrame = A1251_1.CFrame * L1251_7

							for I498, I499 in pairs(U823:GetChildren()) do
								if I499:IsA("Attachment") then
									I499.CFrame = L1251_7 * I499.CFrame
								end
							end

							local L1251_10 = Instance.new("WeldConstraint")
							L1251_10.Part0 = U823
							L1251_10.Part1 = A1251_1
							L1251_10.Parent = U823
						end

						if not (U823:IsA("BasePart") and U823) then
							U823:FindFirstChildWhichIsA("BasePart", true)
						end

						F_001262(U823)

						for I500, I501 in pairs(U823:GetDescendants()) do
							F_001262(I501)
						end

						local K49 = 40
						local U825 = 0
						local U826 = false
						local U827 = 1
						local K50 = 1.2

						local function F_001263()
							if U826 then
								return
							end
							U826 = true

							for I502, I503 in pairs(U823:GetDescendants()) do
								if I503:IsA("BasePart") then
									I503.Anchored = true
								end
							end

							if U823:IsA("BasePart") then
								U823.Anchored = true
							end
						end

						A1251_1.AncestryChanged:Connect(function(A1264_1, A1264_2)
							if not A1264_2 then
								F_001263()
							end
						end)

						local U828 = nil

						U828 = U69.Heartbeat:Connect(function(A1265_1)
							if not U823 or not U823.Parent then
								if U828 then
									U828:Disconnect()
								end

								return
							end

							if not U826 and A1251_1 and A1251_1.Parent then
								U825 = (U825 + A1265_1 * K49) % 360
								A1251_1.CFrame = U822 * CFrame.Angles(0, math.rad(U825), 0)
								A1251_1.AssemblyLinearVelocity = Vector3.zero
								A1251_1.AssemblyAngularVelocity = Vector3.zero
							end

							if U826 then
								U827 -= A1265_1 * K50

								if U827 <= 0 then
									U827 = 0

									if U828 then
										U828:Disconnect()
									end

									U823:Destroy()
									return
								end
							end

							local L1265_1 = U827
							local L1265_2 = U827

							for I504, I505 in pairs(U824) do
								if I504:IsA("BasePart") then
									I504.Size = I505.Size * L1265_1
								elseif I504:IsA("SpecialMesh") or I504:IsA("BlockMesh") or I504:IsA("CylinderMesh") then
									I504.Scale = I505.Scale * L1265_1
								elseif I504:IsA("Attachment") then
									I504.Position = I505.Position * L1265_1
								elseif I504:IsA("ParticleEmitter") then
									I504.Size = F_001243(I505.Size, L1265_2)

									if I505.Speed then
										I504.Speed = F_001244(I505.Speed, L1265_2)
									end
								elseif I504:IsA("Beam") then
									I504.Width0 = I505.Width0 * L1265_2
									I504.Width1 = I505.Width1 * L1265_2

									if I505.CurveSize0 then
										I504.CurveSize0 = I505.CurveSize0 * L1265_2
										I504.CurveSize1 = I505.CurveSize1 * L1265_2
									end
								elseif I504:IsA("Trail") then
									I504.WidthScale = F_001243(I505.WidthScale, L1265_2)
								elseif I504:IsA("PointLight") or I504:IsA("SurfaceLight") or I504:IsA("SpotLight") then
									I504.Range = I505.Range * L1265_2
								end
							end
						end)
					end
				end
			end

			local function F_001266(A1266_1)
				for I506, I507 in pairs(A1266_1:GetDescendants()) do
					if I507.Name == "Hole" and I507:IsA("BasePart") then
						F_001245(I507)
					end

					if I507.Name == "Drone" then
						task.defer(function()
							pcall(function()
								I507:Destroy()
							end)
						end)
					end
				end

				A1266_1.DescendantAdded:Connect(function(A1269_1)
					if A1269_1.Name == "Hole" and A1269_1:IsA("BasePart") then
						F_001245(A1269_1)
					end

					if A1269_1.Name == "Drone" then
						task.defer(function()
							pcall(function()
								A1269_1:Destroy()
							end)
						end)
					end
				end)

				for I508, I509 in pairs(A1266_1:GetDescendants()) do
					F_001251(I509)
				end

				A1266_1.DescendantAdded:Connect(F_001251)
			end

			for I510, I511 in pairs(U71:GetDescendants()) do
				if I511.Name == "BlackHoleKick" or I511.Name == "BlackHoleDetected" then
					F_001266(I511)
				end
			end

			U71.DescendantAdded:Connect(function(A1272_1)
				if A1272_1.Name == "BlackHoleKick" or A1272_1.Name == "BlackHoleDetected" then
					F_001266(A1272_1)
				end
			end)
		end

		do
			local function F_001273(A1273_1)
				local L1273_1 = U68.Character
				L1273_1 = L1273_1 and L1273_1:FindFirstChild("HumanoidRootPart")
				A1273_1 = A1273_1 or L1273_1 and L1273_1.CFrame * CFrame.new(0, 4, -10) or CFrame.new(0, 10, 0)
				local U829 = Instance.new("Model")
				U829.Name = "BlackHoleKick"
				local L1273_2 = Instance.new("Part")
				L1273_2.Name = "Hole"
				L1273_2.Shape = Enum.PartType.Ball
				L1273_2.Size = Vector3.new(24, 24, 24)
				L1273_2.CFrame = A1273_1
				L1273_2.Anchored = true
				L1273_2.CanCollide = false
				L1273_2.CanTouch = false
				L1273_2.CanQuery = false
				L1273_2.Transparency = 1
				L1273_2.Parent = U829
				U829.PrimaryPart = L1273_2
				U829.Parent = U71

				task.delay(8, function()
					if U829 and U829.Parent then
						U829:Destroy()
					end
				end)
			end

			local function F_001275()
				local L1275_1 = U68:GetMouse()

				if L1275_1 and L1275_1.Hit then
					F_001273(L1275_1.Hit * CFrame.new(0, 4, 0))
				end
			end

			L0_385:AddDivider("Blackhole Spawner / Test")

			L0_385:AddButton({
				Text = "Spawn Black Hole (At You)",
				Func = function()
					F_001273()
				end,
				DoubleClick = false,
			})

			local U830 = L0_385:AddButton({ Text = "Spawn Black Hole (At Cursor)", Func = F_001275, DoubleClick = false })

			pcall(function()
				U830:AddKeyPicker("SpawnAtCursorKey", { Default = "None", Mode = "Press", Text = "Spawn at Cursor Key", Callback = F_001275 })
			end)
		end
	end

	local L0_388

	do
		local L0_389 = U92.Miscs:AddGroupbox({
			Side = 2,
			Name = "<b>ESP Settings</b>",
			IconName = "eye",
			Description = "Visual",
			MaxPopOutHeight = 600,
			PopOutWidth = 250,
		}):AddTabbox({ MaxPopOutHeight = 600 })

		local L0_390 = L0_389:AddTab("<b>Player ESP</b>", "eye")
		local L0_391 = L0_389:AddTab("<b>Name ESP</b>", "tag")
		local L0_392 = L0_389:AddTab("<b>PCLD ESP</b>", "users-round")
		local U831 = false
		local U832 = Color3.fromRGB(0, 0, 0)
		local U833 = false
		local U834 = {}
		local U835 = {}

		local function F_001278(A1278_1)
			if not A1278_1 or not A1278_1.Character then
				return
			end
			local L1278_1 = A1278_1.Character
			local U836 = L1278_1:FindFirstChild("HumanoidRootPart")
			if not U836 then
				return
			end
			local L1278_2 = U65.PlayerOutlineColor and U65.PlayerOutlineColor.Value or Color3.fromRGB(255, 255, 255)
			local L1278_3 = U65.PlayerChamsColor and U65.PlayerChamsColor.Value or U832
			local L1278_4 = U65.PlayerChamsTransparency and U65.PlayerChamsTransparency.Value or 0.4
			local L1278_5 = U65.PlayerOutlineTransparency and U65.PlayerOutlineTransparency.Value or 0
			local L1278_6 = Instance.new("Highlight")
			L1278_6.Name = "ESP_Highlight"
			L1278_6.Adornee = L1278_1
			L1278_6.FillColor = L1278_3
			L1278_6.OutlineColor = L1278_2
			L1278_6.FillTransparency = L1278_4
			L1278_6.OutlineTransparency = L1278_5
			L1278_6.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
			L1278_6.Parent = L1278_1
			local U837 = Instance.new("BillboardGui")
			U837.Name = "ESP_Distance"
			U837.Adornee = U836
			U837.Size = UDim2.new(0, 100, 0, 20)
			U837.StudsOffset = Vector3.new(0, -2, 0)
			U837.AlwaysOnTop = true
			U837.Parent = U836
			local U838 = Instance.new("TextLabel")
			U838.Size = UDim2.new(1, 0, 1, 0)
			U838.BackgroundTransparency = 1
			U838.Text = "0 studs"
			U838.TextColor3 = Color3.fromRGB(255, 255, 255)
			U838.TextStrokeTransparency = 0
			U838.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
			U838.Font = Enum.Font.GothamBold
			U838.TextScaled = true
			U838.Parent = U837
			table.insert(U835, { player = A1278_1, highlight = L1278_6, distBillboard = U837, distLabel = U838 })

			local L1278_7 = U69.RenderStepped:Connect(function()
				if not U831 or not A1278_1.Character then
					conn:Disconnect()
					return
				end
				local L1279_1 = U68.Character
				L1279_1 = L1279_1 and L1279_1:FindFirstChild("HumanoidRootPart")

				if L1279_1 and U836 and U836.Parent then
					U838.Text = math.floor((U836.Position - L1279_1.Position).Magnitude) .. " studs"
				end

				U837.Visible = U66.ShowDistance and U66.ShowDistance.Value or false
			end)

			table.insert(U834, L1278_7)
		end

		local function F_001280()
			for I512, I513 in ipairs(U834) do
				pcall(function()
					I513:Disconnect()
				end)
			end

			U834 = {}

			for I514, I515 in ipairs(U835) do
				pcall(function()
					if I515.highlight then
						I515.highlight:Destroy()
					end

					if I515.billboard then
						I515.billboard:Destroy()
					end

					if I515.distBillboard then
						I515.distBillboard:Destroy()
					end
				end)
			end

			U835 = {}
		end

		local function F_001283()
			F_001280()
			if not U831 then
				return
			end
			local L1283_1 = U66.PlayerESPOnlySelected and U66.PlayerESPOnlySelected.Value
			local L1283_2 = U65.PlayerESPPlayers and U65.PlayerESPPlayers.Value

			for I516, I517 in pairs(U67:GetPlayers()) do
				if I517 ~= U68 and I517.Character then
					local L1283_3 = L1283_1 and L1283_2
					local L1283_4 = true

					if L1283_3 then
						if type(L1283_2) == "table" then
							L1283_4 = L1283_2[I517.DisplayName .. " (@" .. I517.Name .. ")"] == true or L1283_2[I517.Name] == true
						elseif type(L1283_2) == "string" then
							L1283_4 = L1283_2:find(I517.Name) ~= nil
						end
					end

					if L1283_4 then
						F_001278(I517)
					end
				end
			end
		end

		local function F_001284()
			for I518, I519 in ipairs(U835) do
				pcall(function()
					if I519.highlight then
						I519.highlight.FillColor = U832

						if not U833 and U65.PlayerChamsColor then
							I519.highlight.FillColor = U65.PlayerChamsColor.Value
						end
					end
				end)
			end
		end

		local U839 = false
		local U840 = {}
		local U841 = false

		local U842 = {
			Gotham = Enum.Font.Gotham,
			GothamBold = Enum.Font.GothamBold,
			GothamSemibold = Enum.Font.GothamSemibold,
			Arial = Enum.Font.Arial,
			ArialBold = Enum.Font.ArialBold,
			Code = Enum.Font.Code,
			RobotoMono = Enum.Font.RobotoMono,
			Oswald = Enum.Font.Oswald,
			Nunito = Enum.Font.Nunito,
			Merriweather = Enum.Font.Merriweather,
		}

		local function F_001286(A1286_1)
			if not A1286_1 or not A1286_1.Character then
				return
			end
			local L1286_1 = A1286_1.Character:FindFirstChild("HumanoidRootPart")
			if not L1286_1 then
				return
			end
			local L1286_2 = U842[U65.NameESPFontType and U65.NameESPFontType.Value or "GothamBold"] or Enum.Font.GothamBold
			local L1286_3 = U65.NameESPFontSize and U65.NameESPFontSize.Value or 14
			local L1286_4 = U65.NameESPColor and U65.NameESPColor.Value or Color3.fromRGB(255, 255, 255)
			local L1286_5 = U65.NameESPOutlineColor and U65.NameESPOutlineColor.Value or Color3.fromRGB(0, 0, 0)
			local L1286_6 = Instance.new("BillboardGui")
			L1286_6.Name = "ST_NameESP_Billboard"
			L1286_6.Adornee = L1286_1
			L1286_6.Size = UDim2.new(0, 250, 0, 40)
			L1286_6.StudsOffset = Vector3.new(0, 3.5, 0)
			L1286_6.AlwaysOnTop = true
			L1286_6.Parent = L1286_1
			local L1286_7 = Instance.new("TextLabel")
			L1286_7.Size = UDim2.new(1, 0, 1, 0)
			L1286_7.BackgroundTransparency = 1
			L1286_7.Text = A1286_1.DisplayName .. " (@" .. A1286_1.Name .. ")"
			L1286_7.TextColor3 = L1286_4
			L1286_7.TextStrokeTransparency = 0
			L1286_7.TextStrokeColor3 = L1286_5
			L1286_7.Font = L1286_2
			L1286_7.TextSize = L1286_3
			L1286_7.Parent = L1286_6
			table.insert(U840, { player = A1286_1, billboard = L1286_6, label = L1286_7 })
		end

		local function F_001287()
			for I520, I521 in ipairs(U840) do
				pcall(function()
					if I521.billboard then
						I521.billboard:Destroy()
					end
				end)
			end

			U840 = {}
		end

		local function F_001289()
			F_001287()
			if not U839 then
				return
			end

			for I522, I523 in pairs(U67:GetPlayers()) do
				if I523 ~= U68 and I523.Character then
					F_001286(I523)
				end
			end
		end

		local U843 = {}
		_G.pcldPlayerCache = _G.pcldPlayerCache or {}
		local U844 = _G.pcldPlayerCache
		Color3.fromRGB(0, 0, 0)
		local U845 = {}
		local U846 = false

		local function F_001290(A1290_1)
			if U844[A1290_1] and U844[A1290_1].Parent then
				return U844[A1290_1]
			end

			for I524, I525 in ipairs({ "Player", "Owner", "UserId", "PlayerName" }) do
				local L1290_1 = A1290_1:GetAttribute(I525)

				if L1290_1 then
					if typeof(L1290_1) == "Instance" and L1290_1:IsA("Player") then
						U844[A1290_1] = L1290_1
						return L1290_1
					end

					if typeof(L1290_1) == "number" then
						local L1290_2 = U67:GetPlayerByUserId(L1290_1)
						if L1290_2 then
							U844[A1290_1] = L1290_2
							return L1290_2
						end
						continue
					end

					if typeof(L1290_1) ~= "string" then
						continue
					end
					local L1290_3 = U67:FindFirstChild(L1290_1)
					if L1290_3 then
						U844[A1290_1] = L1290_3
						return L1290_3
					end
				end
			end

			for I526, I527 in ipairs(A1290_1:GetChildren()) do
				if I527:IsA("ObjectValue") and I527.Value and I527.Value:IsA("Player") then
					U844[A1290_1] = I527.Value
					return I527.Value
				end

				if I527:IsA("ObjectValue") and I527.Value and I527.Value:IsA("Model") then
					local L1290_4 = U67:GetPlayerFromCharacter(I527.Value)
					if L1290_4 then
						U844[A1290_1] = L1290_4
						return L1290_4
					end
					continue
				end

				if I527:IsA("StringValue") then
					local L1290_5 = U67:FindFirstChild(I527.Value)
					if L1290_5 then
						U844[A1290_1] = L1290_5
						return L1290_5
					end
				end
			end

			local L1290_6 = A1290_1.Position
			local L1290_7 = 20
			local L1290_8 = nil

			for I528, I529 in ipairs(U67:GetPlayers()) do
				local L1290_9 = I529.Character
				L1290_9 = L1290_9 and L1290_9:FindFirstChild("HumanoidRootPart")

				if L1290_9 then
					local L1290_10 = (L1290_9.Position - L1290_6).Magnitude

					if L1290_10 < L1290_7 then
						L1290_7 = L1290_10
						L1290_8 = I529
					end
				end
			end

			if L1290_8 then
				U844[A1290_1] = L1290_8
				return L1290_8
			end

			for I530, I531 in ipairs(U67:GetPlayers()) do
				local L1290_11 = I531.Character
				L1290_11 = L1290_11 and L1290_11:FindFirstChild("HumanoidRootPart")

				if L1290_11 then
					if (L1290_11.Position - L1290_6).Magnitude < 60 then
						L1290_8 = I531
					end
				end
			end

			if L1290_8 then
				U844[A1290_1] = L1290_8
				return L1290_8
			end
			return nil
		end

		local function F_001291(A1291_1)
			local L1291_1 = workspace.CurrentCamera
			if not L1291_1 then
				return false
			end
			local L1291_2 = A1291_1.Position

			if (L1291_2 - L1291_1.CFrame.Position).Magnitude < 3 then
				local L1291_3 = U68.Character
				L1291_3 = L1291_3 and L1291_3:FindFirstChild("HumanoidRootPart")
				if not L1291_3 or (L1291_2 - L1291_3.Position).Magnitude > 3 then
					return true
				end
			end

			return false
		end

		local function F_001292(A1292_1, A1292_2)
			if not A1292_1 then
				return nil
			end
			local L1292_1 = A1292_1:FindFirstChild(A1292_2)
			if L1292_1 and L1292_1:IsA("BasePart") then
				return L1292_1
			end

			if A1292_2 == "Torso" then
				return A1292_1:FindFirstChild("UpperTorso") or A1292_1:FindFirstChild("LowerTorso")
			end

			if A1292_2 == "Head" then
				return A1292_1:FindFirstChild("Head")
			end

			if A1292_2 == "Right Arm" then
				return A1292_1:FindFirstChild("RightUpperArm") or A1292_1:FindFirstChild("RightHand")
			end

			if A1292_2 == "Left Arm" then
				return A1292_1:FindFirstChild("LeftUpperArm") or A1292_1:FindFirstChild("LeftHand")
			end

			if A1292_2 == "Right Leg" then
				return A1292_1:FindFirstChild("RightUpperLeg") or A1292_1:FindFirstChild("RightFoot")
			end

			if A1292_2 == "Left Leg" then
				return A1292_1:FindFirstChild("LeftUpperLeg") or A1292_1:FindFirstChild("LeftFoot")
			end

			if A1292_2 == "HumanoidRootPart" then
				return A1292_1:FindFirstChild("HumanoidRootPart")
			end
			return nil
		end

		local U847 = {
			Head = CFrame.new(0, 1.5, 0),
			Torso = CFrame.new(0, 0, 0),
			["Left Arm"] = CFrame.new(-1.5, 0, 0),
			["Right Arm"] = CFrame.new(1.5, 0, 0),
			["Left Leg"] = CFrame.new(-0.5, -2, 0),
			["Right Leg"] = CFrame.new(0.5, -2, 0),
			HumanoidRootPart = CFrame.new(0, 0, 0),
		}

		local function F_001293(A1293_1)
			local L1293_1 = A1293_1 and A1293_1.Character

			if not L1293_1 and A1293_1 == U68 then
				L1293_1 = U68.Character
			end

			local L1293_2 = Instance.new("Model")
			L1293_2.Name = "PCLD_Blocky_" .. (A1293_1 and A1293_1.Name or "Rig")
			local L1293_3 = {}
			local L1293_4 = {}
			local U848 = {}
			local L1293_5 = U65.BlockyChamsTransparency and U65.BlockyChamsTransparency.Value or 0.8
			local U849 = U65.BlockyOutlineColor and U65.BlockyOutlineColor.Value or Color3.fromRGB(255, 255, 255)
			local U850 = U65.BlockyOutlineTransparency and U65.BlockyOutlineTransparency.Value or 0
			local U851 = U65.BlockyOutlineThickness and U65.BlockyOutlineThickness.Value or 0.01
			local L1293_6 = U65.BlockyChamsColor and U65.BlockyChamsColor.Value or Color3.fromRGB(0, 0, 0)

			if L1293_1 then
				L1293_1:FindFirstChild("HumanoidRootPart")
			end

			local L1293_7 = Instance.new("Humanoid")
			L1293_7.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
			L1293_7.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
			L1293_7.EvaluateStateMachine = false
			L1293_7.PlatformStand = true
			L1293_7.Parent = L1293_2

			local function F_001294(A1294_1)
				local L1294_1 = Instance.new("SelectionBox")
				L1294_1.Name = "PCLD_PartOutline"
				L1294_1.Adornee = A1294_1
				L1294_1.Color3 = U849
				L1294_1.LineThickness = U851
				L1294_1.SurfaceTransparency = 1
				L1294_1.Transparency = U850
				L1294_1.Parent = A1294_1
				table.insert(U848, L1294_1)
			end

			local L1293_8 = {
				{ "Head", Vector3.new(2, 1, 1) },
				{ "Torso", Vector3.new(2, 2, 1) },
				{ "Left Arm", Vector3.new(1, 2, 1) },
				{ "Right Arm", Vector3.new(1, 2, 1) },
				{ "Left Leg", Vector3.new(1, 2, 1) },
				{ "Right Leg", Vector3.new(1, 2, 1) },
				{ "HumanoidRootPart", Vector3.new(2, 2, 1) },
			}

			local L1293_9 = L1293_1 and L1293_1:FindFirstChildOfClass("BodyColors")

			for I532, I533 in ipairs(L1293_8) do
				local L1293_10 = I533[1]
				local L1293_11 = I533[2]
				local L1293_12 = L1293_10 == "HumanoidRootPart"
				local L1293_13 = Instance.new("Part")
				L1293_13.Name = L1293_10
				L1293_13.Size = L1293_11
				L1293_13.Anchored = true
				L1293_13.CanCollide = false
				L1293_13.CanTouch = false
				L1293_13.CanQuery = false
				L1293_13.CastShadow = false
				L1293_13.Massless = true
				L1293_13.TopSurface = Enum.SurfaceType.Smooth
				L1293_13.BottomSurface = Enum.SurfaceType.Smooth
				L1293_13.LeftSurface = Enum.SurfaceType.Smooth
				L1293_13.RightSurface = Enum.SurfaceType.Smooth
				L1293_13.FrontSurface = Enum.SurfaceType.Smooth
				L1293_13.BackSurface = Enum.SurfaceType.Smooth
				L1293_13.Material = Enum.Material.SmoothPlastic
				L1293_13.Color = L1293_6
				local L1293_14 = F_001292(L1293_1, L1293_10)

				if L1293_10 == "Head" then
					local L1293_15 = Instance.new("SpecialMesh")
					L1293_15.MeshType = Enum.MeshType.Head
					L1293_15.Scale = Vector3.new(1.25, 1.25, 1.25)
					L1293_15.Parent = L1293_13
					local L1293_16 = L1293_1 and (L1293_1:FindFirstChild("Head") or L1293_14)

					if L1293_16 and L1293_16:FindFirstChild("face") then
						local L1293_17 = L1293_16.face:Clone()
						L1293_17.Transparency = L1293_5
						L1293_17.Parent = L1293_13
					end
				end

				L1293_13.Transparency = L1293_12 and 1 or L1293_5
				L1293_13.Parent = L1293_2

				if L1293_12 then
					L1293_2.PrimaryPart = L1293_13
				else
					table.insert(L1293_3, L1293_13)
					F_001294(L1293_13)
				end

				table.insert(L1293_4, { real = L1293_14, clone = L1293_13, isLimb = true, limbName = L1293_10 })
			end

			if L1293_1 then
				local L1293_18 = L1293_1:FindFirstChildOfClass("Shirt")

				if L1293_18 then
					L1293_18:Clone().Parent = L1293_2
				end

				local L1293_19 = L1293_1:FindFirstChildOfClass("Pants")

				if L1293_19 then
					L1293_19:Clone().Parent = L1293_2
				end

				local L1293_20 = L1293_1:FindFirstChildOfClass("ShirtGraphic")

				if L1293_20 then
					L1293_20:Clone().Parent = L1293_2
				end

				if L1293_9 then
					L1293_9:Clone().Parent = L1293_2
				end

				for I534, I535 in ipairs(L1293_1:GetChildren()) do
					if I535:IsA("Accessory") then
						local L1293_21 = I535:FindFirstChild("Handle")

						if L1293_21 and L1293_21:IsA("BasePart") then
							local L1293_22 = L1293_21:Clone()

							for I536, I537 in ipairs(L1293_22:GetChildren()) do
								if I537:IsA("Weld") or I537:IsA("Motor6D") or I537:IsA("WeldConstraint") or I537:IsA("Script") or I537:IsA("Sound") or I537:IsA("Highlight") or I537:IsA("SelectionBox") then
									pcall(function()
										I537:Destroy()
									end)
								end
							end

							L1293_22.Anchored = true
							L1293_22.CanCollide = false
							L1293_22.CanTouch = false
							L1293_22.CanQuery = false
							L1293_22.CastShadow = false
							L1293_22.Massless = true
							L1293_22.Transparency = L1293_5
							L1293_22.Parent = L1293_2
							table.insert(L1293_3, L1293_22)
							table.insert(L1293_4, { real = L1293_21, clone = L1293_22, accName = I535.Name })
						end
					end
				end
			end

			if not L1293_2.PrimaryPart and #L1293_3 > 0 then
				L1293_2.PrimaryPart = L1293_3[1]
			end

			local L1293_23 = Instance.new("Highlight")
			L1293_23.Name = "PCLD_Highlight"
			L1293_23.Adornee = L1293_2
			L1293_23.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
			L1293_23.OutlineColor = U849
			L1293_23.FillColor = L1293_6
			L1293_23.OutlineTransparency = U850
			L1293_23.FillTransparency = math.clamp(L1293_5, 0.45, 0.9)
			L1293_23.Parent = L1293_2
			L1293_2.Parent = U71
			return L1293_2, U848, L1293_3, L1293_4, L1293_23
		end

		local function F_001296(A1296_1)
			if U843[A1296_1] then
				return
			end
			A1296_1.Transparency = 1
			A1296_1.LocalTransparencyModifier = 1

			pcall(function()
				A1296_1.CanCollide = false
				A1296_1.CanTouch = false
				A1296_1.CanQuery = false
			end)

			for I538, I539 in ipairs(A1296_1:GetChildren()) do
				if I539:IsA("SelectionBox") or I539:IsA("BoxHandleAdornment") or I539:IsA("Highlight") or I539:IsA("BillboardGui") then
					pcall(function()
						I539:Destroy()
					end)
				end
			end

			if F_001291(A1296_1) then
				local U852 = nil

				U852 = U69.RenderStepped:Connect(function()
					if not A1296_1.Parent then
						if U852 then
							U852:Disconnect()
						end

						return
					end

					A1296_1.Transparency = 1
					A1296_1.LocalTransparencyModifier = 1
					A1296_1.CanCollide = false
				end)

				return
			end

			local L1296_1 = U65.PCLDType and U65.PCLDType.Value or "Blocky"
			local L1296_2, L1296_3, L1296_4, L1296_5, L1296_6

			if L1296_1 == "Blocky" or L1296_1 == "Avatar" then
				L1296_2 = U65.BlockyChamsColor and U65.BlockyChamsColor.Value or Color3.fromRGB(0, 0, 0)
				L1296_3 = U65.BlockyChamsTransparency and U65.BlockyChamsTransparency.Value or 0.8
				L1296_4 = U65.BlockyOutlineColor and U65.BlockyOutlineColor.Value or Color3.fromRGB(255, 255, 255)
				L1296_5 = U65.BlockyOutlineTransparency and U65.BlockyOutlineTransparency.Value or 0
				L1296_6 = U65.BlockyOutlineThickness and U65.BlockyOutlineThickness.Value or 0.01
			else
				L1296_2 = U65.RectangleChamsColor and U65.RectangleChamsColor.Value or Color3.fromRGB(0, 0, 0)
				L1296_3 = U65.RectangleChamsTransparency and U65.RectangleChamsTransparency.Value or 0.45
				L1296_4 = U65.RectangleOutlineColor and U65.RectangleOutlineColor.Value or Color3.fromRGB(255, 255, 255)
				L1296_5 = U65.RectangleOutlineTransparency and U65.RectangleOutlineTransparency.Value or 0.1
				L1296_6 = U65.RectangleOutlineThickness and U65.RectangleOutlineThickness.Value or 0.02
			end

			local U853 = F_001290(A1296_1)

			if not U853 and U68.Character then
				local L1296_7 = U68.Character:FindFirstChild("HumanoidRootPart")

				if L1296_7 and (A1296_1.Position - L1296_7.Position).Magnitude < 30 then
					U853 = U68
					U844[A1296_1] = U68
				end
			end

			if not U853 and (L1296_1 == "Blocky" or L1296_1 == "Avatar") then
				L1296_1 = "Rectangle"
			end

			local U854 = {
				original = A1296_1,
				type = L1296_1,
				player = U853,
				lastUpdate = tick(),
				tween = nil,
				transConn = A1296_1:GetPropertyChangedSignal("Transparency"):Connect(function()
					if A1296_1.Transparency ~= 1 then
						A1296_1.Transparency = 1
						A1296_1.LocalTransparencyModifier = 1
					end
				end),
				modConn = A1296_1:GetPropertyChangedSignal("LocalTransparencyModifier"):Connect(function()
					if A1296_1.LocalTransparencyModifier ~= 1 then
						A1296_1.LocalTransparencyModifier = 1
					end
				end),
				childConn = A1296_1.ChildAdded:Connect(function(A1302_1)
					if A1302_1:IsA("SelectionBox") or A1302_1:IsA("BoxHandleAdornment") or A1302_1:IsA("Highlight") or A1302_1:IsA("BillboardGui") then
						pcall(function()
							A1302_1:Destroy()
						end)
					end
				end),
			}

			U854.steppedConn = U69.Stepped:Connect(function()
				if A1296_1 and A1296_1.Parent then
					A1296_1.CanCollide = false
				end

				if U854.parts then
					for I540, I541 in ipairs(U854.parts) do
						if I541 and I541.Parent then
							I541.CanCollide = false
						end
					end
				end

				if U854.box and U854.box.Parent then
					U854.box.CanCollide = false
				end
			end)

			if L1296_1 == "Blocky" or L1296_1 == "Avatar" then
				if not U853 then
					local L1296_8 = 60

					for I542, I543 in ipairs(U67:GetPlayers()) do
						local L1296_9 = I543.Character
						L1296_9 = L1296_9 and L1296_9:FindFirstChild("HumanoidRootPart")

						if L1296_9 then
							local L1296_10 = (L1296_9.Position - A1296_1.Position).Magnitude

							if L1296_10 < L1296_8 then
								U853 = I543
								L1296_8 = L1296_10
							end
						end
					end

					U853 = U853 or U68
					U854.player = U853
				end

				local U855, L1296_11, L1296_12, L1296_13, L1296_14 = F_001293(U853)
				local U856 = Instance.new("Part")
				U856.Name = "PCLD_BlockyRoot"
				U856.Size = Vector3.one
				U856.CFrame = A1296_1.CFrame
				U856.Anchored = true
				U856.CanCollide = false
				U856.CanTouch = false
				U856.CanQuery = false
				U856.Transparency = 1
				U856.Parent = U71
				U854.model = U855
				U854.rootPart = U856
				U854.selectionBoxes = L1296_11
				U854.parts = L1296_12
				U854.partPairs = L1296_13
				U854.highlight = L1296_14

				local function F_001305()
					if not U855 or not A1296_1.Parent or not U856.Parent then
						return
					end
					local L1305_1 = U71.CurrentCamera
					if L1305_1 and (L1305_1.CFrame.Position - A1296_1.Position).Magnitude > 600 then
						return
					end
					A1296_1.Transparency = 1
					A1296_1.LocalTransparencyModifier = 1

					if A1296_1.CanCollide then
						A1296_1.CanCollide = false
					end

					if U855.Parent ~= U71 then
						U855.Parent = U71
					end

					local L1305_2 = U853 and U853.Character
					local L1305_3 = L1305_2 and L1305_2:FindFirstChild("HumanoidRootPart")

					if L1305_2 and L1305_2 ~= U854.lastChar then
						U854.lastChar = L1305_2
						local L1305_4 = ipairs
						local L1305_5 = U854.partPairs or {}

						for I544, I545 in L1305_4(L1305_5) do
							if I545.isLimb then
								local L1305_6 = F_001292(L1305_2, I545.limbName)

								if L1305_6 then
									I545.real = L1305_6
								end
							elseif I545.accName then
								local L1305_7 = L1305_2:FindFirstChild(I545.accName)
								L1305_7 = L1305_7 and L1305_7:FindFirstChild("Handle")

								if L1305_7 then
									I545.real = L1305_7
								end
							end
						end
					end

					local L1305_8 = U854.cachedYDiff or math.max(0, 3 - A1296_1.Size.Y / 2)

					if L1305_3 and L1305_3.Parent then
						if Vector2.new(L1305_3.Position.X - A1296_1.Position.X, L1305_3.Position.Z - A1296_1.Position.Z).Magnitude < 3 then
							U854.cachedYDiff = L1305_3.Position.Y - A1296_1.Position.Y
							L1305_8 = U854.cachedYDiff
						end
					end

					local L1305_9 = U856.CFrame * CFrame.new(0, L1305_8, 0)

					if L1305_2 and L1305_3 and L1305_3.Parent then
						local L1305_10 = L1305_3.CFrame
						local L1305_11 = ipairs
						local L1305_12 = U854.partPairs or {}

						for I546, I547 in L1305_11(L1305_12) do
							local L1305_13 = I547.real
							local L1305_14 = I547.clone

							if L1305_14 and L1305_14.Parent then
								if L1305_13 and L1305_13.Parent then
									if I547.limbName == "Head" or L1305_14.Name == "Head" then
										local L1305_15, L1305_16 = L1305_10:ToObjectSpace(L1305_13.CFrame):ToEulerAnglesYXZ()
										L1305_14.CFrame = L1305_9 * (U847.Head or CFrame.new(0, 1.5, 0)) * CFrame.Angles(0, L1305_16, 0)
									else
										L1305_14.CFrame = L1305_9 * L1305_10:ToObjectSpace(L1305_13.CFrame)
									end
								elseif I547.isLimb and U847[I547.limbName] then
									L1305_14.CFrame = L1305_9 * U847[I547.limbName]
								end
							end
						end
					else
						local L1305_17 = ipairs
						local L1305_18 = U854.partPairs or {}

						for I548, I549 in L1305_17(L1305_18) do
							local L1305_19 = I549.clone

							if L1305_19 and L1305_19.Parent then
								if I549.isLimb and U847[I549.limbName] then
									L1305_19.CFrame = L1305_9 * U847[I549.limbName]
								else
									L1305_19.CFrame = L1305_9
								end
							end
						end
					end
				end

				F_001305()
				U854.renderConn = U69.RenderStepped:Connect(F_001305)

				if U853 then
					U854.charConn = U853.CharacterAdded:Connect(function(A1306_1)
						task.wait(0.3)

						if U843[A1296_1] == U854 and A1296_1.Parent and U854.model and U854.model.Parent then
							local L1306_1 = {}
							local L1306_2 = ipairs
							local L1306_3 = U854.parts or {}

							for I550, I551 in L1306_2(L1306_3) do
								local L1306_4 = A1306_1:FindFirstChild(I551.Name)

								if L1306_4 then
									table.insert(L1306_1, { real = L1306_4, clone = I551 })
								end
							end

							U854.partPairs = L1306_1
						end
					end)
				end
			else
				local L1296_15 = Instance.new("Part")
				L1296_15.Name = "PCLD_Box"
				L1296_15.Size = A1296_1.Size
				L1296_15.CFrame = A1296_1.CFrame * CFrame.new(0, 0, 0.2)
				L1296_15.Anchored = true
				L1296_15.CanCollide = false
				L1296_15.CanTouch = false
				L1296_15.CanQuery = false
				L1296_15.CastShadow = false
				L1296_15.Material = Enum.Material.Neon
				L1296_15.Color = L1296_2
				L1296_15.Transparency = L1296_3
				L1296_15.Parent = U71
				local L1296_16 = Instance.new("SelectionBox")
				L1296_16.Adornee = L1296_15
				L1296_16.LineThickness = L1296_6
				L1296_16.Color3 = L1296_4
				L1296_16.Transparency = L1296_5
				L1296_16.Parent = L1296_15
				U854.box = L1296_15
				U854.outline = L1296_16
			end

			U843[A1296_1] = U854

			task.spawn(function()
				local L1307_1 = A1296_1.Position

				while U843[A1296_1] == U854 and A1296_1.Parent do
					local L1307_2 = A1296_1.Position
					local L1307_3 = A1296_1.CFrame

					if (L1307_2 - L1307_1).Magnitude > 0.02 then
						if U854.type == "Rectangle" and U854.box then
							if U854.tween then
								U854.tween:Cancel()
							end

							local L1307_4 = L1307_3 * CFrame.new(0, 0, 0.2)
							U854.tween = U70:Create(U854.box, TweenInfo.new(0.18, Enum.EasingStyle.Linear), { CFrame = L1307_4 })
							U854.tween:Play()
							L1307_1 = L1307_2
						elseif (U854.type == "Blocky" or U854.type == "Avatar") and U854.rootPart then
							if U854.tween then
								U854.tween:Cancel()
							end

							U854.tween = U70:Create(U854.rootPart, TweenInfo.new(0.18, Enum.EasingStyle.Linear), { CFrame = L1307_3 })
							U854.tween:Play()
							L1307_1 = L1307_2
						else
							L1307_1 = L1307_2
						end
					end

					task.wait(0.03)
				end
			end)
		end

		local function F_001308(A1308_1)
			local L1308_1 = U843[A1308_1]
			if not L1308_1 then
				return
			end

			if L1308_1.transConn then
				L1308_1.transConn:Disconnect()
				L1308_1.transConn = nil
			end

			if L1308_1.modConn then
				L1308_1.modConn:Disconnect()
				L1308_1.modConn = nil
			end

			if L1308_1.childConn then
				L1308_1.childConn:Disconnect()
				L1308_1.childConn = nil
			end

			if L1308_1.renderConn then
				L1308_1.renderConn:Disconnect()
				L1308_1.renderConn = nil
			end

			if L1308_1.steppedConn then
				L1308_1.steppedConn:Disconnect()
				L1308_1.steppedConn = nil
			end

			if L1308_1.charConn then
				L1308_1.charConn:Disconnect()
				L1308_1.charConn = nil
			end

			if L1308_1.tween then
				L1308_1.tween:Cancel()
			end

			if L1308_1.box then
				L1308_1.box:Destroy()
			end

			if L1308_1.rootPart then
				L1308_1.rootPart:Destroy()
			end

			if L1308_1.model then
				L1308_1.model:Destroy()
			end

			if L1308_1.cfVal then
				L1308_1.cfVal:Destroy()
			end

			U843[A1308_1] = nil
			U844[A1308_1] = nil
		end

		local function F_001309()
			for I552, I553 in pairs(U843) do
				if I553.transConn then
					I553.transConn:Disconnect()
					I553.transConn = nil
				end

				if I553.modConn then
					I553.modConn:Disconnect()
					I553.modConn = nil
				end

				if I553.childConn then
					I553.childConn:Disconnect()
					I553.childConn = nil
				end

				if I553.renderConn then
					I553.renderConn:Disconnect()
					I553.renderConn = nil
				end

				if I553.steppedConn then
					I553.steppedConn:Disconnect()
					I553.steppedConn = nil
				end

				if I553.charConn then
					I553.charConn:Disconnect()
					I553.charConn = nil
				end

				if I553.tween then
					I553.tween:Cancel()
				end

				if I553.box then
					I553.box:Destroy()
				end

				if I553.rootPart then
					I553.rootPart:Destroy()
				end

				if I553.model then
					I553.model:Destroy()
				end

				if I553.cfVal then
					I553.cfVal:Destroy()
				end
			end

			U843 = {}
			U844 = {}

			pcall(function()
				for I554, I555 in ipairs(U71:GetChildren()) do
					if I555.Name == "PCLD_Box" then
						I555:Destroy()
					end
				end
			end)
		end

		L0_390:AddToggle("EnablePlayerESP", {
			Text = "Enable Player ESP",
			Default = false,
			Callback = function(A1311_1)
				U831 = A1311_1

				if A1311_1 then
					F_001283()

					local function F_001312(A1312_1)
						if A1312_1 == U68 then
							return
						end

						local L1312_1 = A1312_1.CharacterAdded:Connect(function()
							task.wait(0.4)

							if U831 and A1312_1.Character then
								for I556 = #U835, 1, -1 do
									local U857 = U835[I556]

									if U857.player == A1312_1 then
										pcall(function()
											if U857.highlight then
												U857.highlight:Destroy()
											end

											if U857.billboard then
												U857.billboard:Destroy()
											end

											if U857.distBillboard then
												U857.distBillboard:Destroy()
											end
										end)

										table.remove(U835, I556)
									end
								end

								F_001278(A1312_1)
							end
						end)

						table.insert(U834, L1312_1)
					end

					local L1311_1 = U67.PlayerAdded:Connect(function(A1315_1)
						F_001312(A1315_1)
						task.wait(0.5)

						if U831 and A1315_1 ~= U68 and A1315_1.Character then
							F_001278(A1315_1)
						end
					end)

					table.insert(U834, L1311_1)

					for I557, I558 in ipairs(U67:GetPlayers()) do
						F_001312(I558)
					end
				else
					F_001280()
				end
			end,
		})

		L0_390:AddDivider("Settings")

		L0_390:AddToggle("ShowDistance", {
			Text = "Show Distance",
			Default = true,
			Callback = function(A1316_1)
				for I559, I560 in ipairs(U835) do
					if I560.distBillboard then
						I560.distBillboard.Visible = A1316_1
					end
				end
			end,
		})

		L0_390:AddDivider()

		L0_390:AddDropdown("PlayerESPPlayers", {
			Text = "Players",
			Values = U87(),
			Default = 1,
			AllowNull = true,
			Multi = true,
			Searchable = true,
			Callback = function()
				if U831 then
					F_001283()
				end
			end,
		})

		L0_390:AddToggle("PlayerESPOnlySelected", {
			Text = "Show only the selected player's ESP",
			Default = false,
			Callback = function()
				if U831 then
					F_001283()
				end
			end,
		})

		L0_390:AddDivider("ESP")

		L0_390:AddLabel("ESP Colors"):AddColorPicker("PlayerESPColor", {
			Default = Color3.fromRGB(0, 0, 0),
			Title = "ESP Colors",
			Callback = function(A1319_1)
				U832 = A1319_1

				if not U833 then
					F_001284()
				end
			end,
		})

		L0_390:AddDivider()

		L0_390:AddLabel("Outline"):AddColorPicker("PlayerOutlineColor", {
			Default = Color3.fromRGB(255, 255, 255),
			Title = "Outline Colors",
			Callback = function(A1320_1)
				for I561, I562 in ipairs(U835) do
					if I562.highlight then
						I562.highlight.OutlineColor = A1320_1
					end
				end
			end,
		})

		L0_390:AddDivider()

		L0_390:AddLabel("Chams"):AddColorPicker("PlayerChamsColor", {
			Default = Color3.fromRGB(0, 0, 0),
			Title = "Chams Colors",
			Callback = function(A1321_1)
				for I563, I564 in ipairs(U835) do
					if I564.highlight then
						I564.highlight.FillColor = A1321_1
					end
				end
			end,
		})

		L0_390:AddDivider()

		L0_390:AddToggle("PlayerRainbowESP", {
			Text = "Rainbow ESP",
			Default = false,
			Callback = function(A1322_1)
				U833 = A1322_1

				if A1322_1 then
					task.spawn(function()
						while U833 and U831 do
							local L1323_1 = U65.PlayerRainbowSpeed and U65.PlayerRainbowSpeed.Value or 5
							U832 = Color3.fromHSV(tick() * L1323_1 / 5 % 1, 1, 1)
							F_001284()
							task.wait(0.05)
						end
					end)
				else
					U832 = U65.PlayerESPColor and U65.PlayerESPColor.Value or Color3.fromRGB(0, 0, 0)
					F_001284()
				end
			end,
		})

		L0_390:AddSlider("PlayerRainbowSpeed", {
			Text = "Rainbow Speed",
			Default = 5,
			Min = 1,
			Max = 10,
			Rounding = 0,
			Compact = true,
			Callback = function()
			end,
		})

		L0_390:AddDivider()

		L0_390:AddSlider("PlayerOutlineTransparency", {
			Text = "Outline Transparency",
			Default = 0,
			Min = 0,
			Max = 1,
			Rounding = 2,
			Compact = true,
			Callback = function(A1325_1)
				for I565, I566 in ipairs(U835) do
					if I566.highlight then
						I566.highlight.OutlineTransparency = A1325_1
					end
				end
			end,
		})

		L0_390:AddSlider("PlayerChamsTransparency", {
			Text = "Chams Transparency",
			Default = 0.4,
			Min = 0,
			Max = 1,
			Rounding = 2,
			Compact = true,
			Callback = function(A1326_1)
				for I567, I568 in ipairs(U835) do
					if I568.highlight then
						I568.highlight.FillTransparency = A1326_1
					end
				end
			end,
		})

		L0_390:AddSlider("PlayerOutlineThickness", {
			Text = "Outline Thickness",
			Default = 1,
			Min = 1,
			Max = 10,
			Rounding = 0,
			Compact = true,
			Callback = function()
			end,
		})

		L0_391:AddToggle("EnableNameESP", {
			Text = "Enable Name ESP",
			Default = false,
			Callback = function(A1328_1)
				U839 = A1328_1

				if A1328_1 then
					F_001289()

					local L1328_1 = U67.PlayerAdded:Connect(function(A1329_1)
						task.wait(0.5)

						if U839 and A1329_1 ~= U68 and A1329_1.Character then
							F_001286(A1329_1)
						end
					end)

					table.insert(U834, L1328_1)
				else
					F_001287()
				end
			end,
		})

		L0_391:AddDivider("Settings")

		L0_391:AddDropdown("NameESPFontType", {
			Text = "Font Type",
			Values = {
				"Gotham",
				"GothamBold",
				"GothamSemibold",
				"Arial",
				"ArialBold",
				"Code",
				"RobotoMono",
				"Oswald",
				"Nunito",
				"Merriweather",
			},
			ValueImages = {
				Gotham = "type",
				GothamBold = "bold",
				GothamSemibold = "type",
				Arial = "type",
				ArialBold = "bold",
				Code = "code",
				RobotoMono = "terminal",
				Oswald = "type",
				Nunito = "type",
				Merriweather = "type",
			},
			Default = "GothamBold",
			Callback = function(A1330_1)
				local L1330_1 = U842[A1330_1] or Enum.Font.GothamBold

				for I569, I570 in ipairs(U840) do
					if I570.label then
						I570.label.Font = L1330_1
					end
				end
			end,
		})

		L0_391:AddSlider("NameESPFontSize", {
			Text = "Font Size",
			Default = 14,
			Min = 8,
			Max = 36,
			Rounding = 0,
			Compact = true,
			Callback = function(A1331_1)
				for I571, I572 in ipairs(U840) do
					if I572.label then
						I572.label.TextSize = A1331_1
					end
				end
			end,
		})

		L0_391:AddDivider()

		L0_391:AddLabel("Name Color"):AddColorPicker("NameESPColor", {
			Default = Color3.fromRGB(255, 255, 255),
			Title = "Name Color",
			Callback = function(A1332_1)
				for I573, I574 in ipairs(U840) do
					if I574.label then
						I574.label.TextColor3 = A1332_1
					end
				end
			end,
		})

		L0_391:AddLabel("Outline"):AddColorPicker("NameESPOutlineColor", {
			Default = Color3.fromRGB(0, 0, 0),
			Title = "Outline Color",
			Callback = function(A1333_1)
				for I575, I576 in ipairs(U840) do
					if I576.label then
						I576.label.TextStrokeColor3 = A1333_1
					end
				end
			end,
		})

		L0_391:AddToggle("NameESPRainbow", {
			Text = "Rainbow Name",
			Default = false,
			Callback = function(A1334_1)
				U841 = A1334_1

				if A1334_1 then
					task.spawn(function()
						while U841 and U839 do
							local L1335_1 = U65.NameESPRainbowSpeed and U65.NameESPRainbowSpeed.Value or 5
							local L1335_2 = Color3.fromHSV(tick() * L1335_1 / 5 % 1, 1, 1)

							for I577, I578 in ipairs(U840) do
								if I578.label then
									I578.label.TextColor3 = L1335_2
								end
							end

							task.wait(0.05)
						end
					end)
				else
					local L1334_1 = U65.NameESPColor and U65.NameESPColor.Value or Color3.fromRGB(255, 255, 255)

					for I579, I580 in ipairs(U840) do
						if I580.label then
							I580.label.TextColor3 = L1334_1
						end
					end
				end
			end,
		})

		L0_391:AddSlider("NameESPRainbowSpeed", {
			Text = "Rainbow Speed",
			Default = 5,
			Min = 1,
			Max = 10,
			Rounding = 0,
			Compact = true,
			Callback = function()
			end,
		})

		L0_392:AddToggle("EnablePCLDESP", {
			Text = "Enable PCLD ESP",
			Default = false,
			Callback = function(A1337_1)
				if A1337_1 then
					for I581, I582 in ipairs(U71:GetChildren()) do
						if I582.Name == "PlayerCharacterLocationDetector" then
							F_001296(I582)
						end
					end

					U845.viewpcld = U71.ChildAdded:Connect(function(A1338_1)
						if A1338_1.Name == "PlayerCharacterLocationDetector" then
							task.wait(0.1)
							F_001296(A1338_1)
						end
					end)

					U845.pcldRemoved = U71.ChildRemoved:Connect(function(A1339_1)
						if A1339_1.Name == "PlayerCharacterLocationDetector" then
							F_001308(A1339_1)
						end
					end)
				else
					if U845.viewpcld then
						U845.viewpcld:Disconnect()
						U845.viewpcld = nil
					end

					if U845.pcldRemoved then
						U845.pcldRemoved:Disconnect()
						U845.pcldRemoved = nil
					end

					F_001309()
				end
			end,
		})

		L0_392:AddDivider("Settings")

		L0_392:AddDropdown("PCLDESPPlayers", {
			Text = "Players",
			Values = U87(),
			Default = 1,
			AllowNull = true,
			Multi = true,
			Searchable = true,
			Callback = function()
			end,
		})

		L0_392:AddToggle("PCLDESPOnlySelected", {
			Text = "Show only the selected player's ESP",
			Default = false,
			Callback = function()
			end,
		})

		L0_392:AddDivider("ESP")

		L0_392:AddDropdown("PCLDType", {
			Text = "PCLD Type",
			Values = { "Blocky", "Rectangle" },
			ValueImages = { Blocky = "user", Rectangle = "square" },
			Default = "Rectangle",
			Callback = function()
				if U66.EnablePCLDESP and U66.EnablePCLDESP.Value then
					F_001309()

					for I583, I584 in ipairs(U71:GetChildren()) do
						if I584.Name == "PlayerCharacterLocationDetector" and I584:IsA("BasePart") then
							F_001296(I584)
						end
					end
				end
			end,
		})

		local L0_393 = L0_392:AddDependencyBox()

		L0_393:AddLabel("Outline"):AddColorPicker("BlockyOutlineColor", {
			Default = Color3.fromRGB(255, 255, 255),
			Title = "Outline Colors",
			Callback = function(A1343_1)
				for I585, I586 in pairs(U843) do
					if I586.type == "Blocky" or I586.type == "Avatar" then
						if I586.outline then
							I586.outline.Color3 = A1343_1
						end

						if I586.selectionBoxes then
							for I587, I588 in ipairs(I586.selectionBoxes) do
								if I588 and I588.Parent then
									I588.Color3 = A1343_1
								end
							end
						end

						if I586.highlight then
							I586.highlight.OutlineColor = A1343_1
						end
					end
				end
			end,
		})

		L0_393:AddDivider()

		L0_393:AddLabel("Chams"):AddColorPicker("BlockyChamsColor", {
			Default = Color3.fromRGB(0, 0, 0),
			Title = "Chams Colors",
			Callback = function(A1344_1)
				for I589, I590 in pairs(U843) do
					if I590.type == "Blocky" or I590.type == "Avatar" then
						if I590.box then
							I590.box.Color = A1344_1
						end

						if I590.parts then
							for I591, I592 in ipairs(I590.parts) do
								if I592:IsA("BasePart") and I592.Name ~= "HumanoidRootPart" then
									I592.Color = A1344_1
								end
							end
						end

						if I590.highlight then
							I590.highlight.FillColor = A1344_1
						end
					end
				end
			end,
		})

		L0_393:AddDivider()

		L0_393:AddToggle("BlockyRainbowESP", {
			Text = "Rainbow ESP",
			Default = false,
			Callback = function(A1345_1)
				U846 = A1345_1

				if A1345_1 then
					task.spawn(function()
						while U846 do
							local L1346_1 = U65.BlockyRainbowSpeed and U65.BlockyRainbowSpeed.Value or 5
							local L1346_2 = Color3.fromHSV(tick() * L1346_1 / 5 % 1, 1, 1)

							for I593, I594 in pairs(U843) do
								if I594.type == "Blocky" or I594.type == "Avatar" then
									if I594.box then
										I594.box.Color = L1346_2
									end

									if I594.outline then
										I594.outline.Color3 = L1346_2
									end

									if I594.parts then
										for I595, I596 in ipairs(I594.parts) do
											if I596:IsA("BasePart") and I596.Name ~= "HumanoidRootPart" then
												I596.Color = L1346_2
											end
										end
									end

									if I594.selectionBoxes then
										for I597, I598 in ipairs(I594.selectionBoxes) do
											if I598 and I598.Parent then
												I598.Color3 = L1346_2
											end
										end
									end

									if I594.highlight then
										I594.highlight.OutlineColor = L1346_2
										I594.highlight.FillColor = L1346_2
									end
								end
							end

							task.wait(0.05)
						end
					end)
				else
					local L1345_1 = U65.BlockyChamsColor and U65.BlockyChamsColor.Value or Color3.fromRGB(0, 0, 0)
					local L1345_2 = U65.BlockyOutlineColor and U65.BlockyOutlineColor.Value or Color3.fromRGB(255, 255, 255)

					for I599, I600 in pairs(U843) do
						if I600.type == "Blocky" or I600.type == "Avatar" then
							if I600.box then
								I600.box.Color = L1345_1
							end

							if I600.outline then
								I600.outline.Color3 = L1345_2
							end

							if I600.parts then
								for I601, I602 in ipairs(I600.parts) do
									if I602:IsA("BasePart") and I602.Name ~= "HumanoidRootPart" then
										I602.Color = L1345_1
									end
								end
							end

							if I600.selectionBoxes then
								for I603, I604 in ipairs(I600.selectionBoxes) do
									if I604 and I604.Parent then
										I604.Color3 = L1345_2
									end
								end
							end

							if I600.highlight then
								I600.highlight.OutlineColor = L1345_2
								I600.highlight.FillColor = L1345_1
							end
						end
					end
				end
			end,
		})

		L0_393:AddSlider("BlockyRainbowSpeed", {
			Text = "Rainbow Speed",
			Default = 5,
			Min = 1,
			Max = 10,
			Rounding = 0,
			Compact = true,
			Callback = function()
			end,
		})

		L0_393:AddDivider()

		L0_393:AddSlider("BlockyOutlineTransparency", {
			Text = "Outline Transparency",
			Default = 0,
			Min = 0,
			Max = 1,
			Rounding = 2,
			Compact = true,
			Callback = function(A1348_1)
				for I605, I606 in pairs(U843) do
					if I606.type == "Blocky" or I606.type == "Avatar" then
						if I606.outline then
							I606.outline.Transparency = A1348_1
						end

						if I606.selectionBoxes then
							for I607, I608 in ipairs(I606.selectionBoxes) do
								if I608 and I608.Parent then
									I608.Transparency = A1348_1
								end
							end
						end

						if I606.highlight then
							I606.highlight.OutlineTransparency = A1348_1
						end
					end
				end
			end,
		})

		L0_393:AddSlider("BlockyChamsTransparency", {
			Text = "Chams Transparency",
			Default = 0.8,
			Min = 0,
			Max = 1,
			Rounding = 2,
			Compact = true,
			Callback = function(A1349_1)
				for I609, I610 in pairs(U843) do
					if I610.type == "Blocky" or I610.type == "Avatar" then
						if I610.box then
							I610.box.Transparency = A1349_1
						end

						if I610.parts then
							for I611, I612 in ipairs(I610.parts) do
								if I612:IsA("BasePart") and I612.Name ~= "HumanoidRootPart" then
									I612.Transparency = A1349_1

									for I613, I614 in ipairs(I612:GetChildren()) do
										if I614:IsA("Decal") then
											I614.Transparency = A1349_1
										end
									end
								end
							end
						end

						if I610.highlight then
							I610.highlight.FillTransparency = math.clamp(A1349_1, 0.4, 0.95)
						end
					end
				end
			end,
		})

		L0_393:AddSlider("BlockyOutlineThickness", {
			Text = "Outline Thickness",
			Default = 0.01,
			Min = 0.01,
			Max = 1,
			Rounding = 2,
			Compact = true,
			Callback = function(A1350_1)
				for I615, I616 in pairs(U843) do
					if I616.type == "Blocky" or I616.type == "Avatar" then
						if I616.outline then
							I616.outline.LineThickness = A1350_1
						end

						if I616.selectionBoxes then
							for I617, I618 in ipairs(I616.selectionBoxes) do
								if I618 and I618.Parent then
									I618.LineThickness = A1350_1
								end
							end
						end
					end
				end
			end,
		})

		L0_393:SetupDependencies({ { U65.PCLDType, "Blocky" } })
		local L0_394 = L0_392:AddDependencyBox()

		L0_394:AddLabel("Outline"):AddColorPicker("RectangleOutlineColor", {
			Default = Color3.fromRGB(255, 255, 255),
			Title = "Outline Colors",
			Callback = function(A1351_1)
				for I619, I620 in pairs(U843) do
					if I620.type == "Rectangle" then
						if I620.outline then
							I620.outline.Color3 = A1351_1
						end

						if I620.highlight then
							I620.highlight.OutlineColor = A1351_1
						end
					end
				end
			end,
		})

		L0_394:AddDivider()

		L0_394:AddLabel("Chams"):AddColorPicker("RectangleChamsColor", {
			Default = Color3.fromRGB(0, 0, 0),
			Title = "Chams Colors",
			Callback = function(A1352_1)
				for I621, I622 in pairs(U843) do
					if I622.type == "Rectangle" then
						if I622.box then
							I622.box.Color = A1352_1
						end

						if I622.highlight then
							I622.highlight.FillColor = A1352_1
						end
					end
				end
			end,
		})

		L0_394:AddDivider()

		L0_394:AddToggle("RectangleRainbowESP", {
			Text = "Rainbow ESP",
			Default = false,
			Callback = function(A1353_1)
				U846 = A1353_1

				if A1353_1 then
					task.spawn(function()
						while U846 do
							local L1354_1 = U65.RectangleRainbowSpeed and U65.RectangleRainbowSpeed.Value or 5
							local L1354_2 = Color3.fromHSV(tick() * L1354_1 / 5 % 1, 1, 1)

							for I623, I624 in pairs(U843) do
								if I624.type == "Rectangle" then
									if I624.box then
										I624.box.Color = L1354_2
									end

									if I624.outline then
										I624.outline.Color3 = L1354_2
									end
								end
							end

							task.wait(0.05)
						end
					end)
				else
					local L1353_1 = U65.RectangleChamsColor and U65.RectangleChamsColor.Value or Color3.fromRGB(0, 0, 0)
					local L1353_2 = U65.RectangleOutlineColor and U65.RectangleOutlineColor.Value or Color3.fromRGB(255, 255, 255)

					for I625, I626 in pairs(U843) do
						if I626.type == "Rectangle" then
							if I626.box then
								I626.box.Color = L1353_1
							end

							if I626.outline then
								I626.outline.Color3 = L1353_2
							end
						end
					end
				end
			end,
		})

		L0_394:AddSlider("RectangleRainbowSpeed", {
			Text = "Rainbow Speed",
			Default = 5,
			Min = 1,
			Max = 10,
			Rounding = 0,
			Compact = true,
			Callback = function()
			end,
		})

		L0_394:AddDivider()

		L0_394:AddSlider("RectangleOutlineTransparency", {
			Text = "Outline Transparency",
			Default = 0.1,
			Min = 0,
			Max = 1,
			Rounding = 2,
			Compact = true,
			Callback = function(A1356_1)
				for I627, I628 in pairs(U843) do
					if I628.type == "Rectangle" and I628.outline then
						I628.outline.Transparency = A1356_1
					end
				end
			end,
		})

		L0_394:AddSlider("RectangleChamsTransparency", {
			Text = "Chams Transparency",
			Default = 0.45,
			Min = 0,
			Max = 1,
			Rounding = 2,
			Compact = true,
			Callback = function(A1357_1)
				for I629, I630 in pairs(U843) do
					if I630.type == "Rectangle" and I630.box then
						I630.box.Transparency = A1357_1
					end
				end
			end,
		})

		L0_394:AddSlider("RectangleOutlineThickness", {
			Text = "Outline Thickness",
			Default = 0.02,
			Min = 0.01,
			Max = 1,
			Rounding = 2,
			Compact = true,
			Callback = function(A1358_1)
				for I631, I632 in pairs(U843) do
					if I632.type == "Rectangle" and I632.outline then
						I632.outline.LineThickness = A1358_1
					end
				end
			end,
		})

		L0_394:SetupDependencies({ { U65.PCLDType, "Rectangle" } })

		U67.PlayerRemoving:Connect(function(A1359_1)
			for I633, I634 in ipairs(U835) do
				if I634.player == A1359_1 then
					pcall(function()
						if I634.highlight then
							I634.highlight:Destroy()
						end

						if I634.billboard then
							I634.billboard:Destroy()
						end

						if I634.distBillboard then
							I634.distBillboard:Destroy()
						end
					end)

					table.remove(U835, I633)
					break
				end
			end

			for I635, I636 in ipairs(U840) do
				if I636.player == A1359_1 then
					pcall(function()
						if I636.billboard then
							I636.billboard:Destroy()
						end
					end)

					table.remove(U840, I635)
					break
				end
			end
		end)

		L0_388 = U92.Miscs:AddGroupbox({
			Side = 1,
			Name = "<b>Autos</b>",
			IconName = "bot",
			Description = "Automated tasks",
			MaxPopOutHeight = 600,
			PopOutWidth = 250,
		}):AddTabbox({ MaxPopOutHeight = 600 })

		local L0_395 = L0_388:AddTab("<b>Auto Claim Plot</b>", "flag")

		local U858 = {
			TudorHouse = 1,
			PinkRoofHouse = 2,
			HauntedHouse = 3,
			BlueHouse = 4,
			JapaneseHouse = 5,
		}

		local U859 = "TudorHouse"
		local U860 = false
		local U861 = {}
		local U862 = {}

		local function F_001362(A1362_1)
			local L1362_1 = math.floor(A1362_1)
			local L1362_2 = math.floor(L1362_1 / 3600)
			local L1362_3 = math.floor(L1362_1 % 3600 / 60)
			local L1362_4 = L1362_1 % 60
			if L1362_2 > 0 then
				return string.format("%02ih %02im %02is", L1362_2, L1362_3, L1362_4)
			end

			if L1362_3 > 0 then
				return string.format("%02im %02is", L1362_3, L1362_4)
			end
			return string.format("%02is", L1362_4)
		end

		local function F_001363(A1363_1, A1363_2)
			local L1363_1 = A1363_1.CFrame:PointToObjectSpace(A1363_2)
			local L1363_2 = A1363_1.Size * 0.5
			local L1363_3 = L1363_2.X
			local L1363_4 = math.abs(L1363_1.X) <= L1363_3
			local L1363_5

			if L1363_4 then
				local L1363_6 = L1363_2.Y
				L1363_5 = math.abs(L1363_1.Y) <= L1363_6
			else
				L1363_5 = L1363_4
			end

			if L1363_5 then
				local L1363_7 = L1363_2.Z
				L1363_5 = math.abs(L1363_1.Z) <= L1363_7
			end

			return L1363_5
		end

		local function F_001364(A1364_1)
			local L1364_1 = U71:FindFirstChild("Plots")
			if not L1364_1 then
				return nil
			end
			local L1364_2 = L1364_1:FindFirstChild("Plot" .. A1364_1)
			if L1364_2 then
				return L1364_2
			end
			return L1364_1:GetChildren()[A1364_1]
		end

		local function F_001365(A1365_1)
			local L1365_1 = A1365_1:FindFirstChild("Region") or A1365_1:FindFirstChild("Zone") or A1365_1:FindFirstChild("Base") or A1365_1:FindFirstChildWhichIsA("BasePart")
			if not L1365_1 then
				return {}
			end
			local L1365_2 = {}

			for I637, I638 in ipairs(U67:GetPlayers()) do
				local L1365_3 = I638.Character
				L1365_3 = L1365_3 and L1365_3:FindFirstChild("HumanoidRootPart")

				if L1365_3 and F_001363(L1365_1, L1365_3.Position) then
					table.insert(L1365_2, I638)
				end
			end

			return L1365_2
		end

		local U863 = nil
		local U864 = nil

		local function F_001366()
			if not U859 or not U863 or not U864 then
				return
			end
			local L1366_1 = F_001364(U858[U859] or 1)

			if not L1366_1 then
				U863:SetText("Ownership Time: N/A")
				U864:SetText("Inside Plot: N/A")
				return
			end

			local L1366_2 = L1366_1:FindFirstChild("PlotSign")
			local L1366_3 = L1366_2 and L1366_2:FindFirstChild("ThisPlotsOwners")
			local L1366_4, L1366_5, L1366_6 = ipairs(L1366_3 and L1366_3:GetChildren() or {})
			local L1366_7 = false

			for I639, I640 in L1366_4, L1366_5, L1366_6 do
				if I640.Value and I640.Value ~= "" then
					if I640.Value == U68.Name then
						L1366_7 = true
					end

					if not U862[I640.Value] then
						U862[I640.Value] = tick()
					end
				end
			end

			if L1366_7 then
				if not U861[U859] then
					U861[U859] = tick()
				end
			else
				U861[U859] = nil
			end

			local L1366_8 = U861[U859]

			if L1366_8 then
				local L1366_9 = U861[U859]
				L1366_8 = tick() - L1366_9
			end

			L1366_8 = L1366_8 or nil
			local L1366_10 = F_001365(L1366_1)
			local L1366_11 = {}

			for I641, I642 in ipairs(L1366_10) do
				table.insert(L1366_11, I642.DisplayName or I642.Name)
			end

			U863:SetText("Ownership Time: " .. (L1366_8 and F_001362(L1366_8) or "N/A"))
			U864:SetText("Inside Plot: " .. (#L1366_11 > 0 and table.concat(L1366_11, ", ") or "None"))
		end

		L0_395:AddDropdown("AutoClaimSelectPlot", {
			Text = "Select Plot",
			Values = { "TudorHouse", "PinkRoofHouse", "HauntedHouse", "BlueHouse", "JapaneseHouse" },
			ValueImages = {
				TudorHouse = "rbxassetid://8989327148",
				PinkRoofHouse = "rbxassetid://8989326312",
				HauntedHouse = "rbxassetid://9909725942",
				BlueHouse = "rbxassetid://9909733734",
				JapaneseHouse = "rbxassetid://9108988013",
			},
			Default = "TudorHouse",
			Multi = false,
			Callback = function(A1367_1)
				U859 = A1367_1
				pcall(F_001366)
			end,
		})

		L0_395:AddToggle("ClaimSelectedPlot", {
			Text = "Claim Selected Plot",
			Tooltip = "Claims chosen plot automatically",
			Default = false,
			Callback = function(A1368_1)
				U860 = A1368_1
			end,
		}):AddKeyPicker("ClaimPlotKey", {
			Default = "None",
			Mode = "Toggle",
			SyncToggleState = true,
			Text = "Claim Plot Key",
			Callback = function()
			end,
		})

		L0_395:AddDivider("Details")
		U863 = L0_395:AddLabel("Ownership Time: N/A")
		U864 = L0_395:AddLabel("Inside Plot: N/A")

		task.spawn(function()
			while true do
				task.wait(1)
				pcall(F_001366)
			end
		end)

		task.spawn(function()
			while true do
				task.wait(0.1)
				if not U860 or not U859 then
					continue
				end
				local L1371_1 = U68.Character
				L1371_1 = L1371_1 and L1371_1:FindFirstChild("HumanoidRootPart")
				if not L1371_1 then
					continue
				end
				local L1371_2 = F_001364(U858[U859] or 1)
				if not L1371_2 then
					continue
				end
				local L1371_3 = L1371_2:FindFirstChild("PlotSign")
				local L1371_4 = L1371_3 and L1371_3:FindFirstChild("ThisPlotsOwners")

				if L1371_4 and #L1371_4:GetChildren() <= 0 then
					local U865 = L1371_3:FindFirstChild("Sign") and L1371_3.Sign:FindFirstChild("Plus") and L1371_3.Sign.Plus:FindFirstChild("PlusGrabPart")

					if U865 then
						local L1371_5 = L1371_1.CFrame
						local L1371_6 = L1371_1.AssemblyLinearVelocity

						while #L1371_4:GetChildren() <= 0 and U860 do
							if U68.Character and U68.Character:FindFirstChild("HumanoidRootPart") then
								L1371_1.CFrame = U865.CFrame + Vector3.new(0, 3, 0)

								pcall(function()
									U73.GrabEvents.SetNetworkOwner:FireServer(U865, U865.CFrame)
								end)
							end

							task.wait(0.1)
						end

						if L1371_1 and L1371_1.Parent then
							L1371_1.CFrame = L1371_5
							L1371_1.AssemblyLinearVelocity = L1371_6
							continue
						end
					end
				end
			end
		end)
	end

	local L0_396 = L0_388:AddTab("<b>Auto Spin</b>", "coins")
	local U866 = false
	local U867 = nil
	local K51 = "0:00"

	local function F_001373()
		local L1373_1 = U71:FindFirstChild("Slots")
		L1373_1 = L1373_1 and L1373_1:FindFirstChild("Slots")
		L1373_1 = L1373_1 and L1373_1:FindFirstChild("Screen")
		L1373_1 = L1373_1 and L1373_1:FindFirstChild("SlotGui")
		L1373_1 = L1373_1 and L1373_1:FindFirstChild("TimeLeftFrame")
		local L1373_2 = L1373_1 and L1373_1:FindFirstChild("TimeText")
		return L1373_2 and L1373_2.Text or "N/A"
	end

	local function F_001374()
		while U866 do
			task.wait(1)
			local L1374_1 = U68.Character
			L1374_1 = L1374_1 and L1374_1:FindFirstChild("HumanoidRootPart")

			if L1374_1 then
				U867 = L1374_1.CFrame

				if F_001373() == K51 then
					L1374_1.CFrame = CFrame.new(Vector3.new(-224.94118, 91.364975, 425.75116))
					task.wait(1)

					pcall(function()
						local L1375_1 = U71:FindFirstChild("Slots")
						L1375_1 = L1375_1 and L1375_1:FindFirstChild("Slots")
						L1375_1 = L1375_1 and L1375_1:FindFirstChild("SlotHandle")
						L1375_1 = L1375_1 and L1375_1:FindFirstChild("Handle")

						if L1375_1 then
							U73.GrabEvents.SetNetworkOwner:FireServer(L1375_1, CFrame.new(Vector3.new(-224.94118, 91.364975, 425.75116)))
						end
					end)

					task.wait(1)

					if L1374_1 and L1374_1.Parent and U867 then
						L1374_1.CFrame = U867
					end
				end
			end
		end
	end

	L0_396:AddToggle("AutoFarmToggle", {
		Text = "Start Auto",
		Tooltip = "Automatically spins a slot for you",
		Default = false,
		Callback = function(A1376_1)
			U866 = A1376_1

			if A1376_1 then
				task.spawn(F_001374)
			end
		end,
	}):AddKeyPicker("AutoSpinKey", {
		Default = "None",
		Mode = "Toggle",
		SyncToggleState = true,
		Text = "Start Auto Key",
		Callback = function()
		end,
	})

	L0_396:AddDivider()
	local U868 = L0_396:AddLabel("Time Left: N/A")

	task.spawn(function()
		while true do
			task.wait(1)

			if U868 then
				pcall(function()
					U868:SetText("Time Left: " .. F_001373())
				end)
			end
		end
	end)

	U68.CharacterAdded:Connect(function(A1380_1)
		A1380_1:WaitForChild("HumanoidRootPart", 5)

		if U866 then
			task.spawn(F_001374)
		end
	end)

	local L0_397 = U92.Miscs:AddGroupbox({
		Side = 1,
		Name = "<b>Visual Buildings</b>",
		IconName = "building",
		Description = "Visuals",
		MaxPopOutHeight = 600,
		PopOutWidth = 250,
	}):AddTabbox({ MaxPopOutHeight = 600 })

	local L0_398 = L0_397:AddTab("<b>City</b>", "building-2")
	L0_398:AddDivider("Buildings")
	local L0_399 = L0_397:AddTab("<b>Half-Life</b>", "radiation")
	L0_399:AddDivider("Half-Life 2")
	L0_373 = L0_397:AddTab("<b>Cyberpunk</b>", "chart-column")
	L0_373:AddDivider("Cyberpunk")

	local function F_001381(A1381_1, A1381_2, A1381_3, A1381_4)
		task.spawn(function()
			if not A1381_1 or not A1381_2 or A1381_2 == "" then
				return
			end
			local L1382_1 = A1381_3
			local U869

			if A1381_3 then
				U869 = L1382_1
			else
				U869 = "ST_Map_Preview.jpg"
			end

			local U870 = nil

			local function F_001383(A1383_1)
				local L1383_1 = syn and syn.request
				local L1383_2

				if L1383_1 then
					L1383_2 = L1383_1
				else
					L1383_2 = http and http.request
				end

				local U871 = L1383_2 or http_request or request

				if U871 then
					local L1383_3, L1383_4 = pcall(function()
						return U871({ Url = A1383_1, Method = "GET", Headers = { ["User-Agent"] = "Roblox/WinInet" } })
					end)

					if L1383_3 and L1383_4 and L1383_4.StatusCode == 200 and L1383_4.Body and #L1383_4.Body > 500 then
						return L1383_4.Body
					end
				end

				local L1383_5, L1383_6 = pcall(function()
					return game:HttpGet(A1383_1)
				end)

				if L1383_5 and L1383_6 and #L1383_6 > 500 then
					return L1383_6
				end
				return nil
			end

			local L1382_2 = isfile and isfile(U869)
			local L1382_3 = true

			if L1382_2 then
				local L1382_4, L1382_5 = pcall(function()
					return readfile(U869)
				end)

				if L1382_4 and L1382_5 and #L1382_5 > 1000 then
					L1382_3 = false
				end
			end

			if L1382_3 and writefile then
				local U872 = F_001383(A1381_2)

				if (not U872 or #U872 < 500) and A1381_4 then
					U872 = F_001383(A1381_4)
				end

				if U872 and #U872 > 500 then
					pcall(function()
						writefile(U869, U872)
					end)
				end
			end

			if isfile and isfile(U869) and getcustomasset then
				local L1382_6, L1382_7 = pcall(function()
					return getcustomasset(U869)
				end)

				if L1382_6 and L1382_7 then
					U870 = L1382_7
				end
			end

			if U870 and A1381_1 and A1381_1.Parent then
				pcall(function()
					A1381_1.Image = U870
				end)
			end
		end)
	end

	L0_374 = function(A1390_1, A1390_2, A1390_3, A1390_4, A1390_5)
		local L1390_1 = Instance.new("Frame")
		L1390_1.Name = "MapPreviewCard"
		L1390_1.Size = UDim2.new(1, 0, 0, 140)
		L1390_1.BackgroundColor3 = Color3.fromHex("141414")
		L1390_1.BorderSizePixel = 0
		L1390_1.ClipsDescendants = true
		L1390_1.Parent = A1390_1
		local L1390_2 = Instance.new("UICorner")
		L1390_2.CornerRadius = UDim.new(0, 8)
		L1390_2.Parent = L1390_1
		local L1390_3 = Instance.new("UIStroke")
		L1390_3.Color = Color3.fromHex("292929")
		L1390_3.Thickness = 1
		L1390_3.Parent = L1390_1
		local U873 = Instance.new("ImageLabel")
		U873.Name = "PreviewImage"
		U873.Size = UDim2.new(1, 0, 1, 0)
		U873.BackgroundTransparency = 1
		U873.ScaleType = Enum.ScaleType.Crop
		U873.Parent = L1390_1
		local L1390_4 = Instance.new("Frame")
		L1390_4.Name = "GradientOverlay"
		L1390_4.Size = UDim2.new(1, 0, 0.45, 0)
		L1390_4.Position = UDim2.new(0, 0, 0.55, 0)
		L1390_4.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		L1390_4.BorderSizePixel = 0
		L1390_4.Parent = L1390_1
		local L1390_5 = Instance.new("UIGradient")
		L1390_5.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0.2) })
		L1390_5.Rotation = 90
		L1390_5.Parent = L1390_4
		local U874 = Instance.new("TextLabel")
		U874.Name = "TitleOverlay"
		U874.Size = UDim2.new(1, -16, 0, 24)
		U874.Position = UDim2.new(0, 10, 1, -28)
		U874.BackgroundTransparency = 1
		U874.Font = Enum.Font.GothamBold
		U874.Text = A1390_2 or ""
		U874.TextColor3 = Color3.fromRGB(255, 255, 255)
		U874.TextSize = 13
		U874.TextXAlignment = Enum.TextXAlignment.Left
		U874.ZIndex = 2
		U874.Parent = L1390_1

		if A1390_3 then
			F_001381(U873, A1390_3, A1390_4, A1390_5)
		end

		return {
			Card = L1390_1,
			Image = U873,
			Title = U874,
			Set = function(A1391_1, A1391_2, A1391_3, A1391_4)
				if U874 then
					U874.Text = A1391_1
				end

				local L1391_1 = U873
				local L1391_2

				if U873 then
					L1391_2 = A1391_2
				else
					L1391_2 = L1391_1
				end

				if L1391_2 then
					F_001381(U873, A1391_2, A1391_3, A1391_4)
				end
			end,
		}
	end

	local U875 = {
		Avengers = {
			Name = "Avengers Tower",
			AssetId = "12643995455",
			BasePos = Vector3.new(-19951.31, -163.5, 513.46),
			ImageUrl = "https://sm.ign.com/t/ign_ap/feature/h/how-much-w/how-much-would-it-cost-to-buy-avengers-tower-we-asked-a-nyc_1fau.1280.jpg",
			ImageFile = "ST_Avengers_Preview.jpg",
			TargetName = "Remastered Couch",
		},
		["Half-Life 2"] = {
			Name = "City 17 (Half-Life 2)",
			AssetId = "135593697999704",
			BasePos = Vector3.new(-4246.72, -25.23, 6553.75),
			ImageUrl = "https://developer.valvesoftware.com/w/images/thumb/8/8a/City17_terminalsquare.jpg/500px-City17_terminalsquare.jpg",
			ImageFile = "ST_HL2_Preview.jpg",
			TargetName = "DoorLocked",
		},
	}

	local U876 = nil
	local U877 = false
	local U878 = { X = 0, Y = 0, Z = 0 }
	local U879 = nil

	local function F_001392()
		task.spawn(function()
			if not writefile or not getcustomasset then
				return
			end

			if not (isfile and isfile("ST_City_Ambient.mp3")) then
				pcall(function()
					local L1394_1 = game:HttpGet("https://files.catbox.moe/hyy77f.mp3")
					writefile("ST_City_Ambient.mp3", L1394_1)
				end)
			end

			if isfile and isfile("ST_City_Ambient.mp3") then
				if not U879 or not U879.Parent then
					U879 = Instance.new("Sound")
					U879.Name = "ST_City_AmbientSound"
					U879.Looped = true
					U879.Parent = game:GetService("SoundService")
				end

				U879.SoundId = getcustomasset("ST_City_Ambient.mp3")
				U879.Volume = (U65.CityAmbientVolume and U65.CityAmbientVolume.Value or 50) / 100 * 5

				if not U879.IsPlaying then
					U879:Play()
				end
			end
		end)
	end

	local function F_001395()
		if U879 then
			pcall(function()
				U879:Stop()
				U879:Destroy()
			end)

			U879 = nil
		end
	end

	local function F_001397()
		return (U875[U65.CityType and U65.CityType.Value or "Avengers"] or U875.Avengers).BasePos + Vector3.new(U878.X, U878.Y, U878.Z)
	end

	local function F_001398()
		if U876 and U876.Parent then
			local U880 = F_001397()

			pcall(function()
				if U876:IsA("Model") then
					U876:PivotTo(CFrame.new(U880))
				elseif U876:IsA("BasePart") then
					U876.CFrame = CFrame.new(U880)
				end
			end)
		end
	end

	local function F_001400()
		if not U876 or not U876.Parent then
			return nil
		end

		if (U65.CityType and U65.CityType.Value or "Avengers") == "Half-Life 2" then
			local L1400_1 = nil

			for I643, I644 in ipairs(U876:GetDescendants()) do
				if I644.Name == "DoorLocked" or I644.Name:lower() == "doorlocked" then
					L1400_1 = I644
					break
				else
					L1400_1 = nil
				end
			end

			if not L1400_1 then
				for I645, I646 in ipairs(U876:GetDescendants()) do
					if I646.Name:lower():find("doorlocked") or I646.Name:lower():find("door_locked") then
						L1400_1 = I646
						break
					end
				end
			end

			if L1400_1 then
				if L1400_1:IsA("BasePart") then
					return L1400_1.CFrame * CFrame.new(0, 3, 3)
				end

				if L1400_1:IsA("Model") then
					local L1400_2 = L1400_1.PrimaryPart or L1400_1:FindFirstChildWhichIsA("BasePart", true)
					if L1400_2 then
						return L1400_2.CFrame * CFrame.new(0, 3, 3)
					end
					return L1400_1:GetBoundingBox() * CFrame.new(0, 3, 3)
				end
			end
		else
			local L1400_3 = nil

			for I647, I648 in ipairs(U876:GetDescendants()) do
				if I648.Name == "Remastered Couch" or I648.Name == "Main Couch" then
					L1400_3 = I648
					break
				else
					L1400_3 = nil
				end
			end

			local L1400_4

			if not L1400_3 then
				for I649, I650 in ipairs(U876:GetDescendants()) do
					local L1400_5 = I650.Name:lower()
					if L1400_5:find("remastered couch") or L1400_5:find("main couch") or L1400_5:find("avengers") then
						L1400_3 = I650
						break
					end
				end

				L1400_4 = L1400_3
			else
				L1400_4 = L1400_3
			end

			if L1400_4 then
				if L1400_4:IsA("Model") then
					local L1400_6 = L1400_4:FindFirstChild("Main Couch", true) or L1400_4:FindFirstChild("chair", true) or L1400_4:FindFirstChildWhichIsA("BasePart", true)
					if L1400_6 and L1400_6:IsA("BasePart") then
						return L1400_6.CFrame * CFrame.new(0, 3.5, 3)
					end
					return L1400_4:GetBoundingBox() * CFrame.new(0, 3.5, 3)
				end

				if L1400_4:IsA("BasePart") then
					return L1400_4.CFrame * CFrame.new(0, 3.5, 3)
				end
			end
		end

		return nil
	end

	local U881 = nil

	local function F_001401()
		if U876 and U876.Parent then
			return
		end

		if U877 then
			return
		end
		U877 = true
		local U882 = U875[U65.CityType and U65.CityType.Value or "Avengers"] or U875.Avengers

		task.spawn(function()
			pcall(function()
				U62:Notify({
					Title = "City",
					Description = "Loading " .. U882.Name .. " (" .. U882.AssetId .. ")... Please wait.",
					Duration = 4,
				})
			end)

			local L1402_1, L1402_2 = pcall(function()
				return game:GetObjects("rbxassetid://" .. U882.AssetId)[1]
			end)

			if L1402_1 and L1402_2 then
				if not L1402_2:IsA("Model") then
					local L1402_3 = Instance.new("Model")
					L1402_3.Name = "ST_CustomCity_" .. U882.AssetId
					L1402_2.Parent = L1402_3
					U876 = L1402_3
				else
					U876 = L1402_2
					U876.Name = "ST_CustomCity_" .. U882.AssetId
				end

				if not U876.PrimaryPart then
					local L1402_4 = U876:FindFirstChildWhichIsA("BasePart", true)

					if L1402_4 then
						U876.PrimaryPart = L1402_4
					end
				end

				for I651, I652 in ipairs(U876:GetDescendants()) do
					if I652:IsA("BasePart") then
						I652.Anchored = true
					end
				end

				if U876:IsA("BasePart") then
					U876.Anchored = true
				end

				local L1402_5 = (U65.CityAmbientVolume and U65.CityAmbientVolume.Value or 50) / 100 * 5

				for I653, I654 in ipairs(U876:GetDescendants()) do
					if I654:IsA("Sound") then
						I654.Volume = I654.Volume * L1402_5
					end
				end

				local L1402_6 = F_001397()

				if U876:IsA("Model") then
					U876:PivotTo(CFrame.new(L1402_6))
				elseif U876:IsA("BasePart") then
					U876.CFrame = CFrame.new(L1402_6)
				end

				U876.Parent = U71
				F_001392()

				task.spawn(function()
					task.wait(0.4)

					if U881 then
						U881()
					end
				end)
			else
				pcall(function()
					U62:Notify({
						Title = "City Error",
						Description = "Failed to load city asset " .. U882.AssetId .. ".",
						Duration = 4,
					})
				end)
			end

			U877 = false
		end)
	end

	local function F_001407()
		F_001395()

		if U876 then
			pcall(function()
				U876:Destroy()
			end)

			U876 = nil
		end
	end

	U881 = function()
		local U883 = U68.Character
		local U884 = U883 and U883:FindFirstChild("HumanoidRootPart")
		local U885 = U883 and U883:FindFirstChildOfClass("Humanoid")
		if not U884 then
			return
		end
		local U886 = U875[U65.CityType and U65.CityType.Value or "Avengers"] or U875.Avengers

		if not U876 or not U876.Parent then
			if U66.EnableCity and not U66.EnableCity.Value then
				U66.EnableCity:SetValue(true)
			else
				F_001401()
			end

			pcall(function()
				U62:Notify({
					Title = "City",
					Description = "Loading City first... Teleporting to " .. U886.Name .. " upon load.",
					Duration = 4,
				})
			end)

			task.spawn(function()
				local L1411_1 = tick()

				while (not U876 or not U876.Parent) and tick() - L1411_1 < 15 do
					task.wait(0.2)
				end

				if U876 and U876.Parent then
					task.wait(0.6)
					U881()
				end
			end)

			return
		end

		local U887 = F_001400() or CFrame.new(F_001397() + Vector3.new(0, 10, 0))

		pcall(function()
			if U885 then
				U885.Sit = false
			end

			U884.Anchored = true
			U884.AssemblyLinearVelocity = Vector3.zero
			U884.AssemblyAngularVelocity = Vector3.zero
			U884.CFrame = U887
			U883:PivotTo(U887)
			task.wait(0.25)
			U884.CFrame = U887
			U883:PivotTo(U887)
			task.wait(0.25)
			U884.Anchored = false
			U62:Notify({ Title = "Map", Description = "Teleported to the map successfully!", Duration = 3 })
		end)
	end

	local U888 = nil

	local function F_001413(A1413_1)
		local L1413_1 = U875[A1413_1 or U65.CityType and U65.CityType.Value or "Avengers"] or U875.Avengers

		if L1413_1 and U888 then
			U888.Set(L1413_1.Name, L1413_1.ImageUrl, L1413_1.ImageFile)
		end
	end

	L0_398:AddDropdown("CityType", {
		Text = "City Type",
		Values = { "Avengers" },
		ValueImages = { Avengers = "building-2" },
		Default = "Avengers",
		Callback = function(A1414_1)
			F_001413(A1414_1)

			if U66.EnableCity and U66.EnableCity.Value then
				F_001407()
				F_001401()
			end
		end,
	})

	L0_398:AddLabel("<b>Twilight shader is recommended.</b>", true)
	L0_398:AddDivider("Preview")
	local U889 = L0_398:AddDependencyBox()
	U888 = L0_374
	U888 = U888(U889.Container, "Avengers Tower", U875.Avengers.ImageUrl, U875.Avengers.ImageFile)
	U889.Container.Visible = true
	U889.Visible = true

	pcall(function()
		U889:Update()
		U889:Resize()
	end)

	L0_398:AddDivider()

	L0_398:AddToggle("EnableCity", {
		Text = "Enable City",
		Tooltip = "For strong devices only!",
		Default = false,
		Callback = function(A1416_1)
			if A1416_1 then
				F_001401()
				F_001392()
			else
				F_001407()
				F_001395()
			end
		end,
	})

	L0_398:AddButton({
		Text = "Teleport to City",
		Func = function()
			U881()
		end,
		DoubleClick = false,
	})

	L0_398:AddDivider("City Settings")

	L0_398:AddSlider("CityAmbientVolume", {
		Text = "Ambient Volume",
		Default = 50,
		Min = 0,
		Max = 100,
		Rounding = 0,
		Suffix = "%",
		Compact = true,
		Callback = function(A1418_1)
			local L1418_1 = A1418_1 / 100 * 5

			if U879 and U879.Parent then
				U879.Volume = L1418_1
			end

			if U876 and U876.Parent then
				for I655, I656 in ipairs(U876:GetDescendants()) do
					if I656:IsA("Sound") and I656 ~= U879 then
						I656.Volume = L1418_1
					end
				end
			end
		end,
	})

	L0_398:AddDivider("XYZ")

	L0_398:AddSlider("CityOffsetX", {
		Text = "Offset X",
		Default = 0,
		Min = -10000,
		Max = 10000,
		Rounding = 0,
		Compact = true,
		Callback = function(A1419_1)
			U878.X = A1419_1
			F_001398()
		end,
	})

	L0_398:AddSlider("CityOffsetY", {
		Text = "Offset Y",
		Default = 0,
		Min = -10000,
		Max = 10000,
		Rounding = 0,
		Compact = true,
		Callback = function(A1420_1)
			U878.Y = A1420_1
			F_001398()
		end,
	})

	L0_398:AddSlider("CityOffsetZ", {
		Text = "Offset Z",
		Default = 0,
		Min = -10000,
		Max = 10000,
		Rounding = 0,
		Compact = true,
		Callback = function(A1421_1)
			U878.Z = A1421_1
			F_001398()
		end,
	})

	local U890 = nil

	local function F_001422()
		if U890 then
			pcall(function()
				U890:Stop()
				U890:Destroy()
			end)

			U890 = nil
		end
	end

	local function F_001424()
		task.spawn(function()
			F_001422()
			if not writefile or not getcustomasset then
				return
			end

			if not (isfile and isfile("ST_HL2_Ambient.mp3")) then
				pcall(function()
					local L1426_1 = game:HttpGet("https://files.catbox.moe/fb7uqm.mp3")

					if L1426_1 and #L1426_1 > 0 then
						writefile("ST_HL2_Ambient.mp3", L1426_1)
					end
				end)
			end

			if isfile and isfile("ST_HL2_Ambient.mp3") then
				pcall(function()
					U890 = Instance.new("Sound")
					U890.Name = "ST_HL2_AmbientSound"
					U890.Looped = true
					U890.Parent = game:GetService("SoundService")
					U890.SoundId = getcustomasset("ST_HL2_Ambient.mp3")
					U890.Volume = (U65.HalfLifeAmbientVolume and U65.HalfLifeAmbientVolume.Value or 50) / 100 * 5
					U890:Play()
				end)
			end
		end)
	end

	local U891 = {
		["City 17"] = {
			Name = "City 17 (Half-Life 2)",
			AssetId = "135593697999704",
			BasePos = Vector3.new(-4246.72, -25.23, 6553.75),
			ImageUrl = "https://developer.valvesoftware.com/w/images/thumb/8/8a/City17_terminalsquare.jpg/500px-City17_terminalsquare.jpg",
			ImageFile = "ST_HL2_Preview.jpg",
			AudioUrl = "https://files.catbox.moe/fb7uqm.mp3",
			AudioFile = "ST_HL2_Ambient.mp3",
			TargetName = "DoorLocked",
		},
	}

	local function F_001428()
		return U891[U65.HalfLifeCityType and U65.HalfLifeCityType.Value or "City 17"] or U891["City 17"]
	end

	local U892 = setmetatable({}, { __index = function(A1429_1, A1429_2)
		return F_001428()[A1429_2]
	end })

	local U893 = nil
	local U894 = false
	local U895 = { X = 0, Y = 0, Z = 0 }

	local function F_001430()
		return U892.BasePos + Vector3.new(U895.X, U895.Y, U895.Z)
	end

	local function F_001431()
		if U893 and U893.Parent then
			local U896 = F_001430()

			pcall(function()
				if U893:IsA("Model") then
					U893:PivotTo(CFrame.new(U896))
				elseif U893:IsA("BasePart") then
					U893.CFrame = CFrame.new(U896)
				end
			end)
		end
	end

	local function F_001433()
		if not U893 or not U893.Parent then
			return nil
		end
		local L1433_1 = nil

		for I657, I658 in ipairs(U893:GetDescendants()) do
			if I658.Name == "DoorLocked" or I658.Name:lower() == "doorlocked" then
				L1433_1 = I658
				break
			else
				L1433_1 = nil
			end
		end

		if not L1433_1 then
			for I659, I660 in ipairs(U893:GetDescendants()) do
				if I660.Name:lower():find("doorlocked") or I660.Name:lower():find("door_locked") then
					L1433_1 = I660
					break
				end
			end
		end

		if L1433_1 then
			if L1433_1:IsA("BasePart") then
				return L1433_1.CFrame * CFrame.new(0, 3, 3)
			end

			if L1433_1:IsA("Model") then
				local L1433_2 = L1433_1.PrimaryPart or L1433_1:FindFirstChildWhichIsA("BasePart", true)
				if L1433_2 then
					return L1433_2.CFrame * CFrame.new(0, 3, 3)
				end
				return L1433_1:GetBoundingBox() * CFrame.new(0, 3, 3)
			end
		end

		return nil
	end

	local U897 = nil

	local function F_001434()
		if U893 and U893.Parent then
			return
		end

		if U894 then
			return
		end
		U894 = true

		task.spawn(function()
			pcall(function()
				U62:Notify({
					Title = "Half-Life",
					Description = "Loading " .. U892.Name .. " (" .. U892.AssetId .. ")... Please wait.",
					Duration = 4,
				})
			end)

			local L1435_1, L1435_2 = pcall(function()
				return game:GetObjects("rbxassetid://" .. U892.AssetId)[1]
			end)

			if L1435_1 and L1435_2 then
				if not L1435_2:IsA("Model") then
					local L1435_3 = Instance.new("Model")
					L1435_3.Name = "ST_CustomHL2_" .. U892.AssetId
					L1435_2.Parent = L1435_3
					U893 = L1435_3
				else
					U893 = L1435_2
					U893.Name = "ST_CustomHL2_" .. U892.AssetId
				end

				if not U893.PrimaryPart then
					local L1435_4 = U893:FindFirstChildWhichIsA("BasePart", true)

					if L1435_4 then
						U893.PrimaryPart = L1435_4
					end
				end

				for I661, I662 in ipairs(U893:GetDescendants()) do
					if I662:IsA("BasePart") then
						I662.Anchored = true
					end
				end

				if U893:IsA("BasePart") then
					U893.Anchored = true
				end

				local L1435_5 = (U65.HalfLifeAmbientVolume and U65.HalfLifeAmbientVolume.Value or 50) / 100

				for I663, I664 in ipairs(U893:GetDescendants()) do
					if I664:IsA("Sound") then
						I664.Volume = I664.Volume * L1435_5
					end
				end

				local L1435_6 = F_001430()

				if U893:IsA("Model") then
					U893:PivotTo(CFrame.new(L1435_6))
				elseif U893:IsA("BasePart") then
					U893.CFrame = CFrame.new(L1435_6)
				end

				U893.Parent = U71
				F_001424()

				task.spawn(function()
					task.wait(0.4)

					if U897 then
						U897()
					end
				end)
			else
				pcall(function()
					U62:Notify({
						Title = "Half-Life Error",
						Description = "Failed to load asset " .. U892.AssetId .. ".",
						Duration = 4,
					})
				end)
			end

			U894 = false
		end)
	end

	local function F_001440()
		F_001422()

		if U893 then
			pcall(function()
				U893:Destroy()
			end)

			U893 = nil
		end
	end

	U897 = function()
		local U898 = U68.Character
		local U899 = U898 and U898:FindFirstChild("HumanoidRootPart")
		local U900 = U898 and U898:FindFirstChildOfClass("Humanoid")
		if not U899 then
			return
		end

		if not U893 or not U893.Parent then
			if U66.EnableHalfLife and not U66.EnableHalfLife.Value then
				U66.EnableHalfLife:SetValue(true)
			else
				F_001434()
			end

			pcall(function()
				U62:Notify({
					Title = "Half-Life",
					Description = "Loading " .. U892.Name .. " first... Teleporting upon load.",
					Duration = 4,
				})
			end)

			task.spawn(function()
				local L1444_1 = tick()

				while (not U893 or not U893.Parent) and tick() - L1444_1 < 15 do
					task.wait(0.2)
				end

				if U893 and U893.Parent then
					task.wait(0.6)
					U897()
				end
			end)

			return
		end

		local L1442_1 = F_001433()
		local U901

		if L1442_1 then
			U901 = L1442_1 * CFrame.new(0, -1, 0)
		else
			U901 = CFrame.new(F_001430() + Vector3.new(0, 9, 0))
		end

		pcall(function()
			if U900 then
				U900.Sit = false
			end

			U899.Anchored = true
			U899.AssemblyLinearVelocity = Vector3.zero
			U899.AssemblyAngularVelocity = Vector3.zero
			U899.CFrame = U901
			U898:PivotTo(U901)
			task.wait(0.25)
			U899.CFrame = U901
			U898:PivotTo(U901)
			task.wait(0.25)
			U899.Anchored = false
			U62:Notify({ Title = "Map", Description = "Teleported to the map successfully!", Duration = 3 })
		end)
	end

	local U902 = nil

	L0_399:AddDropdown("HalfLifeCityType", {
		Text = "City Type",
		Values = { "City 17" },
		ValueImages = { ["City 17"] = "radiation" },
		Default = "City 17",
		Callback = function(A1446_1)
			local L1446_1 = U891[A1446_1] or U891["City 17"]

			if U902 and U902.Set then
				U902.Set(L1446_1.Name, L1446_1.ImageUrl, L1446_1.ImageFile)
			end

			if U893 and U893.Parent then
				F_001440()
				task.wait(0.2)
				F_001434()
			end
		end,
	})

	L0_399:AddLabel("<b>Twilight shader is recommended.</b>", true)
	L0_399:AddDivider("Preview")
	local U903 = L0_399:AddDependencyBox()
	U902 = L0_374
	U902 = U902(U903.Container, U892.Name, U892.ImageUrl, U892.ImageFile)
	U903.Container.Visible = true
	U903.Visible = true

	pcall(function()
		U903:Update()
		U903:Resize()
	end)

	L0_399:AddDivider()

	L0_399:AddToggle("EnableHalfLife", {
		Text = "Enable Half-Life",
		Tooltip = "Spawn and load Half-Life map",
		Default = false,
		Callback = function(A1448_1)
			if A1448_1 then
				U892 = U891["City 17"]
				F_001434()
				F_001424()
			else
				F_001440()
				F_001422()
			end
		end,
	})

	L0_399:AddButton({
		Text = "Teleport to Half-Life",
		Func = function()
			U897()
		end,
		DoubleClick = false,
	})

	L0_399:AddDivider("Half-Life Settings")

	L0_399:AddSlider("HalfLifeAmbientVolume", {
		Text = "Ambient Volume",
		Default = 50,
		Min = 0,
		Max = 100,
		Rounding = 0,
		Suffix = "%",
		Compact = true,
		Callback = function(A1450_1)
			local L1450_1 = A1450_1 / 100 * 5

			if U890 and U890.Parent then
				U890.Volume = L1450_1
			end

			if U893 and U893.Parent then
				for I665, I666 in ipairs(U893:GetDescendants()) do
					if I666:IsA("Sound") and I666 ~= U890 then
						I666.Volume = L1450_1
					end
				end
			end
		end,
	})

	L0_399:AddDivider("XYZ")

	L0_399:AddSlider("HalfLifeOffsetX", {
		Text = "Offset X",
		Default = 0,
		Min = -10000,
		Max = 10000,
		Rounding = 0,
		Compact = true,
		Callback = function(A1451_1)
			U895.X = A1451_1
			F_001431()
		end,
	})

	L0_399:AddSlider("HalfLifeOffsetY", {
		Text = "Offset Y",
		Default = 0,
		Min = -10000,
		Max = 10000,
		Rounding = 0,
		Compact = true,
		Callback = function(A1452_1)
			U895.Y = A1452_1
			F_001431()
		end,
	})

	L0_399:AddSlider("HalfLifeOffsetZ", {
		Text = "Offset Z",
		Default = 0,
		Min = -10000,
		Max = 10000,
		Rounding = 0,
		Compact = true,
		Callback = function(A1453_1)
			U895.Z = A1453_1
			F_001431()
		end,
	})

	U628 = nil

	local function F_001454()
		task.spawn(function()
			if not writefile or not getcustomasset then
				return
			end

			if not (isfile and isfile("ST_Cyberpunk_Ambient.mp3")) then
				pcall(function()
					local L1456_1 = game:HttpGet("https://files.catbox.moe/7agwqf.mp3")
					writefile("ST_Cyberpunk_Ambient.mp3", L1456_1)
				end)
			end

			if isfile and isfile("ST_Cyberpunk_Ambient.mp3") then
				if not U628 or not U628.Parent then
					U628 = Instance.new("Sound")
					U628.Name = "ST_Cyberpunk_AmbientSound"
					U628.Looped = true
					U628.Parent = game:GetService("SoundService")
				end

				U628.SoundId = getcustomasset("ST_Cyberpunk_Ambient.mp3")
				U628.Volume = (U65.CyberpunkAmbientVolume and U65.CyberpunkAmbientVolume.Value or 50) / 100 * 5

				if not U628.IsPlaying then
					U628:Play()
				end
			end
		end)
	end

	U629 = function()
		if U628 then
			pcall(function()
				U628:Stop()
				U628:Destroy()
			end)

			U628 = nil
		end
	end

	U630 = {
		Name = "Dawn of Aurora",
		AssetId = "130479738068241",
		BasePos = Vector3.new(4860.1, 330.01, -5821.08),
		ImageUrl = "https://spaces.filmstories.co.uk/uploads/2023/02/cyberpunk__1_-scaled-5.jpg",
		ImageFallbackUrl = "https://files.catbox.moe/kvv40l.jpg",
		ImageFile = "ST_DawnOfAurora_Preview_v5.jpg",
	}

	U631 = nil
	local U904 = false
	U632 = { X = 0, Y = 0, Z = 0 }

	U633 = function()
		return U630.BasePos + Vector3.new(U632.X, U632.Y, U632.Z)
	end

	U634 = function()
		if U631 and U631.Parent then
			local U905 = U633()

			pcall(function()
				if U631:IsA("Model") then
					U631:PivotTo(CFrame.new(U905))
				elseif U631:IsA("BasePart") then
					U631.CFrame = CFrame.new(U905)
				end
			end)
		end
	end

	U635 = function()
		if not U631 or not U631.Parent then
			return nil
		end
		local L1462_1 = {}

		for I667, I668 in ipairs(U631:GetDescendants()) do
			local L1462_2 = I668.Name:lower()

			if L1462_2:find("aurora") and L1462_2:find("container") then
				table.insert(L1462_1, I668)
			end
		end

		if #L1462_1 == 0 then
			for I669, I670 in ipairs(U631:GetDescendants()) do
				if I670.Name:lower():find("auroracontainer") then
					table.insert(L1462_1, I670)
				end
			end
		end

		if #L1462_1 == 0 then
			for I671, I672 in ipairs(U631:GetDescendants()) do
				if I672.Name:lower():find("container") then
					table.insert(L1462_1, I672)
				end
			end
		end

		if #L1462_1 == 0 then
			for I673, I674 in ipairs(U631:GetDescendants()) do
				if I674.Name:lower():find("aurora") then
					table.insert(L1462_1, I674)
				end
			end
		end

		local L1462_3 = L1462_1[15] or L1462_1[#L1462_1] or L1462_1[1]

		if L1462_3 then
			if L1462_3:IsA("BasePart") then
				return L1462_3.CFrame * CFrame.new(0, 4, 0)
			end

			if L1462_3:IsA("Model") then
				local L1462_4 = L1462_3.PrimaryPart or L1462_3:FindFirstChildWhichIsA("BasePart", true)
				if L1462_4 then
					return L1462_4.CFrame * CFrame.new(0, 4, 0)
				end
				return L1462_3:GetBoundingBox() * CFrame.new(0, 4, 0)
			end
		end

		return CFrame.new(U633() + Vector3.new(0, 10, 0))
	end

	U636 = nil

	U637 = function()
		if U631 and U631.Parent then
			return
		end

		if U904 then
			return
		end
		U904 = true

		task.spawn(function()
			pcall(function()
				U62:Notify({
					Title = "Cyberpunk",
					Description = "Loading " .. U630.Name .. " (" .. U630.AssetId .. ")... Please wait.",
					Duration = 4,
				})
			end)

			local L1464_1, L1464_2 = pcall(function()
				return game:GetObjects("rbxassetid://" .. U630.AssetId)[1]
			end)

			if L1464_1 and L1464_2 then
				if not L1464_2:IsA("Model") then
					local L1464_3 = Instance.new("Model")
					L1464_3.Name = "ST_CustomCyberpunk_" .. U630.AssetId
					L1464_2.Parent = L1464_3
					U631 = L1464_3
				else
					U631 = L1464_2
					U631.Name = "ST_CustomCyberpunk_" .. U630.AssetId
				end

				for I675, I676 in ipairs(U631:GetDescendants()) do
					if I676:IsA("LuaSourceContainer") then
						pcall(function()
							I676:Destroy()
						end)
					elseif I676:IsA("BasePart") then
						I676.Anchored = true
					end
				end

				if U631:IsA("BasePart") then
					U631.Anchored = true
				end

				local L1464_4 = (U65.CyberpunkAmbientVolume and U65.CyberpunkAmbientVolume.Value or 50) / 100 * 5

				for I677, I678 in ipairs(U631:GetDescendants()) do
					if I678:IsA("Sound") then
						I678.Volume = I678.Volume * L1464_4
					end
				end

				local L1464_5 = U633()

				if U631:IsA("Model") then
					U631:PivotTo(CFrame.new(L1464_5))
				elseif U631:IsA("BasePart") then
					U631.CFrame = CFrame.new(L1464_5)
				end

				U631.Parent = U71
				F_001454()

				pcall(function()
					U62:Notify({ Title = "Silent Target", Description = "Made by The First Encounter Assault Recon", Duration = 6 })
				end)

				task.spawn(function()
					task.wait(0.4)

					if U636 then
						U636()
					end
				end)
			else
				pcall(function()
					U62:Notify({
						Title = "Cyberpunk Error",
						Description = "Failed to load Dawn of Aurora asset " .. U630.AssetId .. ".",
						Duration = 5,
					})
				end)
			end

			U904 = false
		end)
	end
end

local U906, U907, U908, U909, U910, L0_400

do
	local U911, U912, U913, U914, U915, U916, U917, U918, U919, U920
	local U921, U922, U923, U924, U925, U926, U927, U928, U929, U930
	local U931, U932, U933, U934, U935, U936

	do
		local U937, U938, U939, U940, U941, U942, U943
		local U944, U945, U946
		local U947, U948, U949
		local U950, U951, U952

		local function F_IronManSuit_Init()
			local U953, U954, U955, U956, U957, U958, U959, U960, U961, U962
			local U963, U964, U965, U966, U967

			do
				do
					do
						do
							local function F_001471()
								U629()

								if U631 then
									pcall(function()
										U631:Destroy()
									end)

									U631 = nil
								end
							end

							U636 = function()
								local U968 = U68.Character
								local U969 = U968 and U968:FindFirstChild("HumanoidRootPart")
								local U970 = U968 and U968:FindFirstChildOfClass("Humanoid")
								if not U969 then
									return
								end

								if not U631 or not U631.Parent then
									if U66.EnableCyberpunk and not U66.EnableCyberpunk.Value then
										U66.EnableCyberpunk:SetValue(true)
									else
										U637()
									end

									pcall(function()
										U62:Notify({
											Title = "Cyberpunk",
											Description = "Loading Dawn of Aurora first... Teleporting upon load.",
											Duration = 4,
										})
									end)

									task.spawn(function()
										local L1475_1 = tick()

										while (not U631 or not U631.Parent) and tick() - L1475_1 < 15 do
											task.wait(0.2)
										end

										if U631 and U631.Parent then
											task.wait(0.6)
											U636()
										end
									end)

									return
								end

								local U971 = U635() or CFrame.new(U633() + Vector3.new(0, 10, 0))

								pcall(function()
									if U970 then
										U970.Sit = false
									end

									U969.Anchored = true
									U969.AssemblyLinearVelocity = Vector3.zero
									U969.AssemblyAngularVelocity = Vector3.zero
									U969.CFrame = U971
									U968:PivotTo(U971)
									task.wait(0.25)
									U969.CFrame = U971
									U968:PivotTo(U971)
									task.wait(0.25)
									U969.Anchored = false
									U62:Notify({ Title = "Map", Description = "Teleported to the map successfully!", Duration = 3 })
								end)
							end

							L0_373:AddDropdown("CyberpunkCityType", {
								Text = "City Type",
								Values = { "Dawn of Aurora" },
								ValueImages = { ["Dawn of Aurora"] = "chart-column" },
								Default = "Dawn of Aurora",
								Callback = function()
								end,
							})

							L0_373:AddLabel("<b>Twilight shader is recommended.</b>", true)
							L0_373:AddDivider("Preview")
							local U972 = L0_373:AddDependencyBox()
							L0_374(U972.Container, U630.Name, U630.ImageUrl, U630.ImageFile, U630.ImageFallbackUrl)
							U972.Container.Visible = true
							U972.Visible = true

							pcall(function()
								U972:Update()
								U972:Resize()
							end)

							L0_373:AddDivider()

							L0_373:AddToggle("EnableCyberpunk", {
								Text = "Enable Cyberpunk",
								Tooltip = "Cyberpunk futuristic neon skyline",
								Default = false,
								Callback = function(A1479_1)
									if A1479_1 then
										U637()
									else
										F_001471()
									end
								end,
							})
						end
					end

					L0_373:AddButton({
						Text = "Teleport to Cyberpunk",
						Func = function()
							U636()
						end,
						DoubleClick = false,
					})

					L0_373:AddDivider("Cyberpunk Settings")

					L0_373:AddSlider("CyberpunkAmbientVolume", {
						Text = "Ambient Volume",
						Default = 50,
						Min = 0,
						Max = 100,
						Rounding = 0,
						Suffix = "%",
						Compact = true,
						Callback = function(A1481_1)
							local L1481_1 = A1481_1 / 100 * 5

							if U628 and U628.Parent then
								U628.Volume = L1481_1
							end

							if U631 and U631.Parent then
								for I679, I680 in ipairs(U631:GetDescendants()) do
									if I680:IsA("Sound") and I680 ~= U628 then
										I680.Volume = L1481_1
									end
								end
							end
						end,
					})

					L0_373:AddDivider("XYZ")

					L0_373:AddSlider("CyberpunkOffsetX", {
						Text = "Offset X",
						Default = 0,
						Min = -10000,
						Max = 10000,
						Rounding = 0,
						Compact = true,
						Callback = function(A1482_1)
							U632.X = A1482_1
							U634()
						end,
					})

					L0_373:AddSlider("CyberpunkOffsetY", {
						Text = "Offset Y",
						Default = 0,
						Min = -10000,
						Max = 10000,
						Rounding = 0,
						Compact = true,
						Callback = function(A1483_1)
							U632.Y = A1483_1
							U634()
						end,
					})

					L0_373:AddSlider("CyberpunkOffsetZ", {
						Text = "Offset Z",
						Default = 0,
						Min = -10000,
						Max = 10000,
						Rounding = 0,
						Compact = true,
						Callback = function(A1484_1)
							U632.Z = A1484_1
							U634()
						end,
					})

					U911 = game:GetService("RunService")
					U913 = game:GetService("UserInputService")
					U953 = game:GetService("TweenService")
					U912 = game:GetService("Debris")

					do
						local U973 = nil

						U906 = function(A1485_1)
							local U974 = game:GetService("CoreGui")
							local L1485_1 = false

							if not A1485_1 then
								if U66.EnableIronManSuit and U66.EnableIronManSuit.Value and U66.IronManEnableUI and U66.IronManEnableUI.Value and (U65.IronManUIType and U65.IronManUIType.Value) == "Red" then
									L1485_1 = true
								end
							end

							if L1485_1 then
								if U974:FindFirstChild("ExecutorRedVignette") then
									return
								end
								U973 = Instance.new("ScreenGui")
								U973.Name = "ExecutorRedVignette"
								U973.IgnoreGuiInset = true
								U973.ResetOnSpawn = false

								pcall(function()
									U973.Parent = U974
								end)

								if not U973.Parent then
									pcall(function()
										U973.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
									end)
								end

								local function F_001488(A1488_1, A1488_2, A1488_3, A1488_4)
									local L1488_1 = Instance.new("Frame")
									L1488_1.AnchorPoint = A1488_1
									L1488_1.Position = A1488_2
									L1488_1.Size = A1488_3
									L1488_1.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
									L1488_1.BackgroundTransparency = 0
									L1488_1.BorderSizePixel = 0
									L1488_1.Parent = U973
									local L1488_2 = Instance.new("UIGradient")
									L1488_2.Rotation = A1488_4
									local L1488_3 = NumberSequenceKeypoint.new
									L1488_2.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.8), L1488_3(1, 1) })
									L1488_2.Parent = L1488_1
								end

								F_001488(Vector2.new(0, 0), UDim2.new(0, 0, 0, 0), UDim2.new(1, 0, 0, 120), 90)
								F_001488(Vector2.new(0, 1), UDim2.new(0, 0, 1, 0), UDim2.new(1, 0, 0, 120), 270)
								F_001488(Vector2.new(0, 0), UDim2.new(0, 0, 0, 0), UDim2.new(0, 120, 1, 0), 0)
								F_001488(Vector2.new(1, 0), UDim2.new(1, 0, 0, 0), UDim2.new(0, 120, 1, 0), 180)
							else
								if U973 then
									U973:Destroy()
									U973 = nil
								end

								if U974:FindFirstChild("ExecutorRedVignette") then
									U974.ExecutorRedVignette:Destroy()
								end
							end
						end
					end
				end

				do
					local U975, U976

					do
						U937 = "rbxassetid://139104989458527"
						U938 = "13879598825"
						U954 = "101526512794542"

						U939 = {
							{
								Id = "77623932623785",
								Key = Enum.KeyCode.One,
								Name = "Skill 1",
								KfsName = "First Skill",
							},
							{
								Id = "77018069010304",
								Key = Enum.KeyCode.Two,
								Name = "Skill 2",
								KfsName = "2nd Skill",
							},
						}

						U955 = 0
						U940 = nil
						U941 = nil
						U942 = nil
						U943 = {}
						U956 = nil
						U957 = nil
						U944 = nil
						U945 = nil
						U916 = nil
						U975 = nil
						U976 = nil

						do
							local U977 = nil
							U958 = nil
							U959 = nil
							U920 = nil
							U946 = false
							U919 = nil
							U960 = nil
							U918 = nil
							U917 = nil
							U915 = nil
							U914 = false
							U923 = 0
							U924 = false
							U922 = 0
							U921 = {}
							U927 = {}
							U961 = nil
							U947 = nil
							U948 = nil
							U962 = nil
							U949 = {}
							U963 = {}
							U926 = false

							task.spawn(function()
								local L1489_1 = writefile

								if L1489_1 then
									L1489_1 = not (isfile and isfile("ST_IronMan_Skill1.mp3"))
								end

								if L1489_1 then
									pcall(function()
										local L1490_1 = game:HttpGet("https://files.catbox.moe/8qgrr0.mp3")
										writefile("ST_IronMan_Skill1.mp3", L1490_1)
									end)
								end
							end)

							U964 = function()
								if U977 then
									pcall(function()
										U977:Stop()
										U977:Destroy()
									end)

									U977 = nil
								end
							end

							U965 = function()
								U964()
								local U978 = U65 and U65.AmbientSound and U65.AmbientSound.Value or 60
								if U978 <= 0 then
									return
								end

								pcall(function()
									local L1494_1 = Instance.new("Sound")
									L1494_1.Name = "ST_IronMan_AmbientHum"
									L1494_1.SoundId = "rbxassetid://9069609268"
									L1494_1.Volume = U978 / 100 * 1.5
									L1494_1.Looped = true
									L1494_1.RollOffMaxDistance = 150
									local L1494_2 = U68.Character
									L1494_1.Parent = L1494_2 and (L1494_2:FindFirstChild("Torso") or L1494_2:FindFirstChild("HumanoidRootPart")) or game:GetService("SoundService")
									L1494_1:Play()
									U977 = L1494_1
								end)
							end

							U925 = function()
								if U977 then
									U977.Volume = (U65 and U65.AmbientSound and U65.AmbientSound.Value or 60) / 100 * 1.5
								end
							end
						end
					end

					U928 = function()
						local L1496_1 = U65 and U65.SoundEffects and U65.SoundEffects.Value or 100

						if U976 then
							U976.Volume = L1496_1 / 100 * 3
						end
					end

					do
						local function F_001497()
							U976 = nil

							task.spawn(function()
								if not writefile or not getcustomasset then
									return
								end

								if not (isfile and isfile("ST_IronMan_SuitUp.mp3")) then
									pcall(function()
										local L1499_1 = game:HttpGet("https://files.catbox.moe/v5epsu.mp3")
										writefile("ST_IronMan_SuitUp.mp3", L1499_1)
									end)
								end

								if isfile and isfile("ST_IronMan_SuitUp.mp3") then
									local U979 = (U65 and U65.SoundEffects and U65.SoundEffects.Value or 100) / 100

									pcall(function()
										for I681 = 1, 2 do
											local L1500_1 = Instance.new("Sound")
											L1500_1.Name = "ST_IronManSuitSound_" .. I681
											L1500_1.SoundId = getcustomasset("ST_IronMan_SuitUp.mp3")
											L1500_1.Volume = 3 * U979
											L1500_1.RollOffMaxDistance = 10000
											L1500_1.Parent = game:GetService("SoundService")
											L1500_1:Play()
											U912:AddItem(L1500_1, 25)

											if I681 == 1 then
												U976 = L1500_1
											end
										end
									end)
								end
							end)
						end

						U929 = function()
							if U975 then
								pcall(function()
									U975:Destroy()
								end)

								U975 = nil
							end
						end

						U932 = function()
							if U66.SkipIntro and U66.SkipIntro.Value then
								return
							end
							U929()
							local L1503_1 = gethui and gethui() or game:GetService("CoreGui") or U68 and U68:FindFirstChildOfClass("PlayerGui")
							if not L1503_1 then
								return
							end
							local U980 = Instance.new("ScreenGui")
							U980.Name = "ST_IronManCinematic"
							U980.DisplayOrder = 999999
							U980.IgnoreGuiInset = true
							U980.ResetOnSpawn = false
							U980.Parent = L1503_1
							U975 = U980
							local U981 = Instance.new("Frame")
							U981.Name = "Blackout"
							U981.Size = UDim2.new(1, 0, 1, 0)
							U981.Position = UDim2.new(0, 0, 0, 0)
							U981.BackgroundColor3 = Color3.new(0, 0, 0)
							U981.BackgroundTransparency = 0
							U981.BorderSizePixel = 0
							U981.ZIndex = 1
							U981.Parent = U980
							local U982 = Instance.new("Frame")
							U982.Name = "IlluminationFlash"
							U982.Size = UDim2.new(1, 0, 1, 0)
							U982.BackgroundColor3 = Color3.fromRGB(210, 245, 255)
							U982.BackgroundTransparency = 1
							U982.BorderSizePixel = 0
							U982.ZIndex = 10
							U982.Parent = U980
							local U983 = Instance.new("TextLabel")
							U983.Name = "HackerCode"
							U983.Size = UDim2.new(0.9, 0, 0.85, 0)
							U983.Position = UDim2.new(0, 35, 0, 35)
							U983.BackgroundTransparency = 1
							U983.Font = Enum.Font.Code
							U983.TextSize = 16
							U983.TextColor3 = Color3.fromRGB(0, 255, 130)
							U983.TextXAlignment = Enum.TextXAlignment.Left
							U983.TextYAlignment = Enum.TextYAlignment.Top
							U983.RichText = true
							U983.Text = ""
							U983.ZIndex = 5
							U983.Parent = U980
							F_001497()

							local U984 = {
								"> [LOCAL] SUIT ENABLE: IRON MAN PROTOCOL DETECTED",
								"> [SYSTEM] INITIALIZING J.A.R.V.I.S. INTERFACE...",
								"> [AUTH] BIOMETRIC VERIFICATION: STARK INDUSTRIES CONFIRMED",
								"> [LINK] ACCESSING MODEL ASSET #" .. U954 .. "...",
								"> [DEPLOY] CONSTRUCTING NANOTECH PLATING...",
								"> [ARMOR] CHEST, REPULSORS & HELMET ONLINE",
								"> [POWER] ARC REACTOR AT 100% CAPACITY",
								"> [HUD] SYNCHRONIZING NEURAL SENSORS & LIMBS...",
								"> [STATUS] SUIT ENGAGED. READY FOR COMBAT.",
								"> [SYSTEM] INITIALIZATION COMPLETE.",
							}

							task.spawn(function()
								local L1504_1 = os.clock()

								while true do
									local L1504_2 = U980.Parent
									local L1504_3

									if L1504_2 then
										L1504_3 = not U976 or not U976.Parent or not U976.IsPlaying
									else
										L1504_3 = L1504_2
									end

									L1504_3 = L1504_3 and os.clock() - L1504_1 < 3
									if L1504_3 then
										task.wait(0.04)
										continue
									end
									break
								end

								local L1504_4 = U976 and U976.TimeLength and U976.TimeLength > 2
								local L1504_5 = 6.5

								if L1504_4 then
									L1504_5 = U976.TimeLength
								end

								local L1504_6 = math.max(3, L1504_5 - 0.7) / #U984
								local L1504_7 = ""

								for I682, I683 in ipairs(U984) do
									if U980.Parent then
										local L1504_8 = L1504_7 .. (I682 > 1 and "\n" or "")
										local L1504_9 = L1504_6 / math.max(1, #I683)

										for I684 = 1, #I683 do
											if U980.Parent then
												U983.Text = L1504_8 .. I683:sub(1, I684) .. " _"
												task.wait(L1504_9)
												continue
											end

											break
										end

										L1504_7 = L1504_8 .. I683
										U983.Text = L1504_7 .. "\n"
										continue
									end

									break
								end

								if U980.Parent then
									U983.Text = L1504_7 .. "\n> [ACTIVE] SUIT DEPLOYED - SYSTEMS NOMINAL _"
								end

								if U976 and U976.Parent and U980.Parent then
									while true do
										if U980.Parent and U976 and U976.Parent and U976.IsPlaying then
											if not (U976.TimeLength > 0 and U976.TimePosition >= U976.TimeLength - 0.08) then
												task.wait(0.03)
												continue
											end
										end

										break
									end
								end

								if not U980.Parent then
									return
								end
								U982.BackgroundTransparency = 0.15
								local L1504_10 = U953:Create(U982, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundTransparency = 1 })
								local L1504_11 = U953:Create(U981, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundTransparency = 1 })
								local L1504_12 = U953:Create(U983, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { TextTransparency = 1 })
								L1504_10:Play()
								L1504_11:Play()
								L1504_12:Play()
								L1504_11.Completed:Wait()

								pcall(function()
									U980:Destroy()
								end)

								if U975 == U980 then
									U975 = nil
								end
							end)
						end
					end
				end

				U966 = nil

				do
					local U985 = nil

					U967 = function()
						if U985 then
							return U985
						end

						if getcustomasset and writefile and (isfile or readfile) then
							pcall(function()
								if not (isfile and isfile("ST_HeliosHUD.png")) then
									if game and game.HttpGet then
										local L1507_1 = game:HttpGet("https://files.catbox.moe/gju4bv.png")

										if L1507_1 and #L1507_1 > 0 then
											writefile("ST_HeliosHUD.png", L1507_1)
										end
									end
								end

								if isfile and isfile("ST_HeliosHUD.png") then
									U985 = getcustomasset("ST_HeliosHUD.png")
								end
							end)
						end

						if U985 then
							return U985
						end
						return "https://files.catbox.moe/gju4bv.png"
					end
				end
			end

			local U986, U987, U988, U989

			do
				do
					U907 = function()
						if not U966 or not U966.Parent then
							return
						end
						local L1508_1 = true

						if U66.IronManEnableUI ~= nil then
							L1508_1 = U66.IronManEnableUI.Value
						end

						U966.Visible = L1508_1
						local L1508_2 = 0

						if U65.IronManUITransparency ~= nil then
							L1508_2 = tonumber(U65.IronManUITransparency.Value) or 0
						end

						U966.ImageTransparency = math.clamp(L1508_2, 0, 1)
					end

					task.spawn(function()
						pcall(U967)
					end)

					U986 = function()
						if U959 then
							pcall(function()
								U959:Disconnect()
							end)

							U959 = nil
						end

						if U958 then
							pcall(function()
								U958:Destroy()
							end)

							U958 = nil
						end

						U966 = nil
						U918 = nil
						U917 = nil
						U915 = nil
						U919 = nil
						U960 = nil
						U914 = false
						U923 += 1
						U924 = false
						U922 += 1
						local U990 = game:GetService("ReplicatedStorage"):FindFirstChild("MenuToys") and game:GetService("ReplicatedStorage").MenuToys:FindFirstChild("DestroyToy")

						if U990 then
							for I685, I686 in ipairs(U921) do
								if I686 and I686.Parent then
									pcall(function()
										U990:FireServer(I686)
									end)
								end
							end

							for I687, I688 in ipairs(U927) do
								if I688 and I688.Parent then
									pcall(function()
										U990:FireServer(I688)
									end)
								end
							end
						end

						U921 = {}
						U927 = {}
						local L1510_1 = U68.Character
						L1510_1 = L1510_1 and L1510_1:FindFirstChildOfClass("Humanoid")

						if L1510_1 then
							L1510_1.CameraOffset = Vector3.zero
						end

						local U991 = gethui and gethui():FindFirstChild("ST_IronManHUD") or game:GetService("CoreGui"):FindFirstChild("ST_IronManHUD")

						if U991 then
							pcall(function()
								U991:Destroy()
							end)
						end
					end

					U987 = function()
						if U961 then
							pcall(function()
								U961:Stop()
								U961:Destroy()
							end)

							U961 = nil
						end

						local L1516_1 = U68.Character

						if L1516_1 then
							for I689, I690 in ipairs(L1516_1:GetDescendants()) do
								if I690.Name == "ST_FootThrusterAtt" or I690.Name == "ST_HandThrusterAtt" or I690.Name == "ST_IronManThrusterFlames" then
									pcall(function()
										I690:Destroy()
									end)
								end
							end
						end

						if U920 then
							pcall(function()
								U920:Destroy()
							end)

							U920 = nil
						end
					end

					do
						local function F_001520()
							local U992 = (U65 and U65.SoundEffects and U65.SoundEffects.Value or 100) / 100

							pcall(function()
								local L1521_1 = Instance.new("Sound")
								L1521_1.Name = "ST_IronMan_RobotMech"
								L1521_1.SoundId = "rbxassetid://9114223170"
								L1521_1.Volume = 2.8 * U992
								L1521_1.PlaybackSpeed = math.random(95, 105) / 100
								L1521_1.Parent = workspace.CurrentCamera or game:GetService("SoundService")
								L1521_1:Play()
								U912:AddItem(L1521_1, 1.2)
							end)
						end

						U988 = function()
							if U940 then
								pcall(function()
									U940:Disconnect()
								end)

								U940 = nil
							end
						end

						U950 = function(A1524_1)
							U988()
							if not A1524_1 then
								return
							end

							task.spawn(function()
								local U993 = A1524_1:WaitForChild("Humanoid", 3)
								local U994 = A1524_1:WaitForChild("HumanoidRootPart", 3) or A1524_1:WaitForChild("Torso", 3)
								if not U993 or not U994 then
									return
								end

								U940 = U911.Heartbeat:Connect(function()
									if not (U66.EnableIronManSuit and U66.EnableIronManSuit.Value) then
										return
									end

									if U66.FlyToggle and U66.FlyToggle.Value then
										return
									end

									if U946 then
										return
									end
									local L1526_1 = U993.MoveDirection
									local L1526_2 = U994.AssemblyLinearVelocity or U994.Velocity
									local L1526_3 = Vector3.new(L1526_2.X, 0, L1526_2.Z).Magnitude
									local L1526_4 = L1526_1.Magnitude > 0.05 or L1526_3 > 1.2
									local L1526_5 = U993.FloorMaterial ~= Enum.Material.Air

									if not L1526_5 then
										local L1526_6 = Enum.HumanoidStateType.Running
										L1526_5 = U993:GetState() == L1526_6
									end

									if not L1526_5 then
										local L1526_7 = Enum.HumanoidStateType.RunningNoPhysics
										L1526_5 = U993:GetState() == L1526_7
									end

									if L1526_4 and L1526_5 then
										if math.clamp(0.35 / math.max(L1526_3 / 16, 0.6), 0.22, 0.4) <= tick() - U955 then
											U955 = tick()
											F_001520()
										end
									end
								end)
							end)
						end
					end
				end

				do
					local function F_001527(A1527_1)
						local L1527_1 = U68.Character

						if L1527_1 then
							for I691, I692 in ipairs(L1527_1:GetDescendants()) do
								if I692.Name == "ST_FootThrusterAtt" then
									local L1527_2 = I692:FindFirstChild("ThrusterFlame")

									if L1527_2 then
										L1527_2.Enabled = A1527_1
									end
								end
							end
						end

						if U916 and U916.Parent then
							for I693, I694 in ipairs(U916:GetDescendants()) do
								if I694.Name == "ST_FootThrusterAtt" then
									local L1527_3 = I694:FindFirstChild("ThrusterFlame")

									if L1527_3 then
										L1527_3.Enabled = A1527_1
									end
								end
							end
						end

						if A1527_1 then
							if not U961 or not U961.Parent then
								local L1527_4 = U65 and U65.SoundEffects and U65.SoundEffects.Value or 100
								local L1527_5 = Instance.new("Sound")
								L1527_5.Name = "ST_IronMan_FootJetRoar"
								L1527_5.SoundId = "rbxassetid://9069609268"
								L1527_5.Volume = 3 * L1527_4 / 100
								L1527_5.Looped = true
								L1527_5.Parent = workspace.CurrentCamera or game:GetService("SoundService")
								L1527_5:Play()
								U961 = L1527_5
							elseif not U961.Playing then
								U961:Play()
							end
						elseif U961 then
							pcall(function()
								U961:Stop()
								U961:Destroy()
							end)

							U961 = nil
						end
					end

					U951 = function(A1529_1)
						local L1529_1 = U68.Character

						if L1529_1 then
							for I695, I696 in ipairs(L1529_1:GetDescendants()) do
								if I696.Name == "ST_HandThrusterAtt" then
									local L1529_2 = I696:FindFirstChild("ThrusterFlame")

									if L1529_2 then
										L1529_2.Enabled = A1529_1
									end
								end
							end
						end

						if U916 and U916.Parent then
							for I697, I698 in ipairs(U916:GetDescendants()) do
								if I698.Name == "ST_HandThrusterAtt" then
									local L1529_3 = I698:FindFirstChild("ThrusterFlame")

									if L1529_3 then
										L1529_3.Enabled = A1529_1
									end
								end
							end
						end

						if A1529_1 then
							task.spawn(function()
								local U995 = (U65 and U65.SoundEffects and U65.SoundEffects.Value or 100) / 100

								pcall(function()
									local L1531_1 = Instance.new("Sound")
									L1531_1.Name = "ST_IronMan_HandJetSound"
									L1531_1.SoundId = "rbxassetid://90804156043814"
									L1531_1.Volume = 3 * U995
									L1531_1.PlaybackSpeed = 1.25
									L1531_1.Parent = workspace.CurrentCamera or game:GetService("SoundService")
									L1531_1:Play()
									U912:AddItem(L1531_1, 3)
								end)
							end)
						end
					end

					U952 = function(A1532_1)
						F_001527(A1532_1)
					end

					U989 = function(A1533_1, A1533_2)
						U987()
						if not A1533_1 then
							return
						end

						local function F_001534(A1534_1)
							if A1533_2 then
								for I699, I700 in ipairs(A1533_2:GetDescendants()) do
									if I700:IsA("BasePart") then
										local L1534_1 = I700.Name:lower():gsub("%s+", ""):gsub("[_%-]", "")
										if A1534_1 == "Left Leg" and (L1534_1 == "leftleg" or L1534_1 == "leftfoot" or L1534_1 == "lleg" or L1534_1 == "lfoot") then
											return I700
										end
										local L1534_2 = A1534_1 == "Right Leg"

										if L1534_2 then
											L1534_2 = L1534_1 == "rightleg" or L1534_1 == "rightfoot" or L1534_1 == "rleg" or L1534_1 == "rfoot"
										end

										if L1534_2 then
											return I700
										end
										local L1534_3 = A1534_1 == "Left Arm"

										if L1534_3 then
											L1534_3 = L1534_1 == "leftarm" or L1534_1 == "lefthand" or L1534_1 == "larm" or L1534_1 == "lhand"
										end

										if L1534_3 then
											return I700
										end

										if A1534_1 == "Right Arm" and (L1534_1 == "rightarm" or L1534_1 == "righthand" or L1534_1 == "rarm" or L1534_1 == "rhand") then
											return I700
										end

										if A1534_1 == "Torso" and (L1534_1 == "torso" or L1534_1 == "chest" or L1534_1 == "body" or L1534_1 == "uppertorso") then
											return I700
										end
									end
								end
							end

							if A1533_1 then
								if A1534_1 == "Left Leg" then
									return A1533_1:FindFirstChild("Left Leg") or A1533_1:FindFirstChild("LeftFoot") or A1533_1:FindFirstChild("LeftLowerLeg")
								end

								if A1534_1 == "Right Leg" then
									return A1533_1:FindFirstChild("Right Leg") or A1533_1:FindFirstChild("RightFoot") or A1533_1:FindFirstChild("RightLowerLeg")
								end

								if A1534_1 == "Left Arm" then
									return A1533_1:FindFirstChild("Left Arm") or A1533_1:FindFirstChild("LeftHand") or A1533_1:FindFirstChild("LeftLowerArm")
								end

								if A1534_1 == "Right Arm" then
									return A1533_1:FindFirstChild("Right Arm") or A1533_1:FindFirstChild("RightHand") or A1533_1:FindFirstChild("RightLowerArm")
								end

								if A1534_1 == "Torso" then
									return A1533_1:FindFirstChild("Torso") or A1533_1:FindFirstChild("UpperTorso") or A1533_1:FindFirstChild("HumanoidRootPart")
								end
							end

							return nil
						end

						local function F_001535(A1535_1, A1535_2, A1535_3)
							if not A1535_1 then
								return
							end
							local L1535_1 = Instance.new("Attachment")
							L1535_1.Name = A1535_3 and "ST_HandThrusterAtt" or "ST_FootThrusterAtt"
							L1535_1.CFrame = A1535_2
							L1535_1.Parent = A1535_1
							local L1535_2 = Instance.new("ParticleEmitter")
							L1535_2.Name = "ThrusterFlame"
							L1535_2.Texture = "rbxasset://textures/particles/fire_main.dds"
							local L1535_3 = ColorSequence.new
							local L1535_4 = {}
							local L1535_5 = ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255))
							local L1535_6 = ColorSequenceKeypoint.new(0.25, Color3.fromRGB(255, 230, 80))
							local L1535_7 = ColorSequenceKeypoint.new(0.6, Color3.fromRGB(255, 110, 20))
							local L1535_8 = ColorSequenceKeypoint.new(0.85, Color3.fromRGB(200, 35, 10))
							L1535_4[1] = L1535_5
							L1535_4[2] = L1535_6
							L1535_4[3] = L1535_7
							L1535_4[4] = L1535_8

							do
								local L1535_9 = table.pack(ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 10, 5)))
								table.move(L1535_9, 1, L1535_9.n, 5, L1535_4)
							end

							L1535_2.Color = L1535_3(L1535_4)
							local L1535_10 = NumberSequence.new
							local L1535_11 = {}
							local L1535_12 = NumberSequenceKeypoint.new(0, A1535_3 and 0.26 or 0.35)
							local L1535_13 = NumberSequenceKeypoint.new(0.45, A1535_3 and 0.42 or 0.52)
							local L1535_14 = table.pack(NumberSequenceKeypoint.new(1, 0.05))
							L1535_11[1] = L1535_12
							L1535_11[2] = L1535_13

							do
								local L1535_15 = table.pack(table.unpack(L1535_14, 1, L1535_14.n))
								table.move(L1535_15, 1, L1535_15.n, 3, L1535_11)
							end

							L1535_2.Size = L1535_10(L1535_11)
							L1535_2.Speed = NumberRange.new(9, 15)
							L1535_2.Lifetime = NumberRange.new(0.08, 0.16)
							L1535_2.Rate = 120
							local L1535_16 = NumberSequence.new
							local L1535_17 = {}
							local L1535_18 = NumberSequenceKeypoint.new(0, 0.05)
							local L1535_19 = NumberSequenceKeypoint.new(0.5, 0.25)
							local L1535_20 = NumberSequenceKeypoint.new
							L1535_17[1] = L1535_18
							L1535_17[2] = L1535_19

							do
								local L1535_21 = table.pack(L1535_20(1, 1))
								table.move(L1535_21, 1, L1535_21.n, 3, L1535_17)
							end

							L1535_2.Transparency = L1535_16(L1535_17)
							L1535_2.LightEmission = 1
							L1535_2.LightInfluence = 0
							L1535_2.SpreadAngle = Vector2.new(4, 4)
							L1535_2.EmissionDirection = Enum.NormalId.Bottom
							L1535_2.Enabled = false
							L1535_2.Parent = L1535_1
							return L1535_1
						end

						local L1533_1 = F_001534("Left Leg") or A1533_1 and (A1533_1:FindFirstChild("Left Leg") or A1533_1:FindFirstChild("LeftFoot") or A1533_1:FindFirstChild("LeftLowerLeg"))
						local L1533_2 = F_001534("Right Leg")

						if L1533_2 then
							A1533_1 = L1533_2
						elseif A1533_1 then
							A1533_1 = A1533_1:FindFirstChild("Right Leg") or A1533_1:FindFirstChild("RightFoot") or A1533_1:FindFirstChild("RightLowerLeg")
						end

						if L1533_1 then
							F_001535(L1533_1, CFrame.new(0, -1, 0), false)
						end

						if A1533_1 then
							F_001535(A1533_1, CFrame.new(0, -1, 0), false)
						end

						local L1533_3 = F_001534("Left Arm")
						local L1533_4 = F_001534("Right Arm")

						if L1533_3 then
							F_001535(L1533_3, CFrame.new(0, -1, 0), true)
						end

						if L1533_4 then
							F_001535(L1533_4, CFrame.new(0, -1, 0), true)
						end

						F_001527(U66.FlyToggle and U66.FlyToggle.Value or false)
						U951(false)
					end
				end
			end

			local function F_IronManHUD_Init()
				local function F_001536()
					U986()
					local L1536_1 = gethui and gethui() or game:GetService("CoreGui") or U68 and U68:FindFirstChildOfClass("PlayerGui")
					if not L1536_1 then
						return
					end
					local U996 = Instance.new("ScreenGui")
					U996.Name = "ST_IronManHUD"
					U996.DisplayOrder = 9999
					U996.IgnoreGuiInset = true
					U996.ResetOnSpawn = false
					U996.Parent = L1536_1
					U958 = U996
					local U997 = Color3.fromRGB(255, 255, 255)
					local U998 = Color3.fromRGB(255, 25, 25)
					local U999 = Instance.new("ImageLabel")
					U999.Name = "HeliosHelmetOverlay"
					U999.Size = UDim2.new(1, 0, 1, 0)
					U999.Position = UDim2.new(0, 0, 0, 0)
					U999.BackgroundTransparency = 1
					U999.BorderSizePixel = 0
					U999.ScaleType = Enum.ScaleType.Stretch
					U999.ZIndex = 2
					local L1536_2 = true

					if U66.IronManEnableUI ~= nil then
						L1536_2 = U66.IronManEnableUI.Value
					end

					U999.Visible = L1536_2
					local L1536_3 = 0

					if U65.IronManUITransparency ~= nil then
						L1536_3 = tonumber(U65.IronManUITransparency.Value) or 0
					end

					U999.ImageTransparency = math.clamp(L1536_3, 0, 1)
					U999.Parent = U996
					U966 = U999

					task.spawn(function()
						local L1537_1 = U967()

						if U999 and U999.Parent then
							U999.Image = L1537_1
						end
					end)

					local U1000 = Instance.new("Frame")
					U1000.Name = "IronManCrosshair"
					U1000.Size = UDim2.new(0, 46, 0, 46)
					U1000.AnchorPoint = Vector2.new(0.5, 0.5)
					U1000.Position = UDim2.new(0.5, 0, 0.5, 0)
					U1000.BackgroundTransparency = 1
					U1000.ZIndex = 10
					U1000.Parent = U996
					local U1001 = Instance.new("Frame")
					U1001.Name = "CenterDot"
					U1001.Size = UDim2.new(0, 5, 0, 5)
					U1001.AnchorPoint = Vector2.new(0.5, 0.5)
					U1001.Position = UDim2.new(0.5, 0, 0.5, 0)
					U1001.BackgroundColor3 = U997
					U1001.BorderSizePixel = 0
					U1001.Parent = U1000
					local L1536_4 = Instance.new("UICorner")
					L1536_4.CornerRadius = UDim.new(1, 0)
					L1536_4.Parent = U1001
					local U1002 = Instance.new("Frame")
					U1002.Name = "SpinningRing"
					U1002.Size = UDim2.new(1, 0, 1, 0)
					U1002.AnchorPoint = Vector2.new(0.5, 0.5)
					U1002.Position = UDim2.new(0.5, 0, 0.5, 0)
					U1002.BackgroundTransparency = 1
					U1002.Parent = U1000
					local L1536_5 = Instance.new("Frame")
					L1536_5.Name = "LeftArc"
					L1536_5.Size = UDim2.new(0, 18, 0, 38)
					L1536_5.Position = UDim2.new(0.5, -18, 0.5, -19)
					L1536_5.BackgroundTransparency = 1
					L1536_5.ClipsDescendants = true
					L1536_5.Parent = U1002
					local L1536_6 = Instance.new("Frame")
					L1536_6.Size = UDim2.new(0, 36, 0, 36)
					L1536_6.Position = UDim2.new(0, 0, 0.5, -18)
					L1536_6.BackgroundTransparency = 1
					L1536_6.Parent = L1536_5
					local L1536_7 = Instance.new("UICorner")
					L1536_7.CornerRadius = UDim.new(1, 0)
					L1536_7.Parent = L1536_6
					local U1003 = Instance.new("UIStroke")
					U1003.Name = "ArcStroke"
					U1003.Thickness = 2
					U1003.Color = U997
					U1003.Parent = L1536_6
					local L1536_8 = Instance.new("Frame")
					L1536_8.Name = "RightArc"
					L1536_8.Size = UDim2.new(0, 18, 0, 38)
					L1536_8.Position = UDim2.new(0.5, 0, 0.5, -19)
					L1536_8.BackgroundTransparency = 1
					L1536_8.ClipsDescendants = true
					L1536_8.Parent = U1002
					local L1536_9 = Instance.new("Frame")
					L1536_9.Size = UDim2.new(0, 36, 0, 36)
					L1536_9.Position = UDim2.new(0, -18, 0.5, -18)
					L1536_9.BackgroundTransparency = 1
					L1536_9.Parent = L1536_8
					local L1536_10 = Instance.new("UICorner")
					L1536_10.CornerRadius = UDim.new(1, 0)
					L1536_10.Parent = L1536_9
					local U1004 = Instance.new("UIStroke")
					U1004.Name = "ArcStroke"
					U1004.Thickness = 2
					U1004.Color = U997
					U1004.Parent = L1536_9
					local U1005 = {}

					for I701 = 1, 4 do
						local L1536_11 = Instance.new("Frame")
						L1536_11.Size = UDim2.new(0, 6, 0, 1.6)
						L1536_11.AnchorPoint = Vector2.new(0.5, 0.5)
						L1536_11.BackgroundColor3 = U997
						L1536_11.BorderSizePixel = 0
						local L1536_12 = I701 * 90 - 45
						local L1536_13 = math.rad(L1536_12)
						L1536_11.Position = UDim2.new(0.5, math.cos(L1536_13) * 23, 0.5, math.sin(L1536_13) * 23)
						L1536_11.Rotation = L1536_12
						L1536_11.Parent = U1002
						table.insert(U1005, L1536_11)
					end

					local U1006 = Instance.new("TextLabel")
					U1006.Name = "TargetInfoLabel"
					U1006.Size = UDim2.new(0, 180, 0, 100)
					U1006.Position = UDim2.new(1, 48, 0.5, -40)
					U1006.BackgroundTransparency = 1
					U1006.Font = Enum.Font.Code
					U1006.TextSize = 13
					U1006.TextColor3 = U998
					U1006.TextStrokeColor3 = Color3.fromRGB(80, 0, 0)
					U1006.TextStrokeTransparency = 1
					U1006.TextTransparency = 1
					U1006.TextXAlignment = Enum.TextXAlignment.Left
					U1006.TextYAlignment = Enum.TextYAlignment.Top
					U1006.LineHeight = 1.15
					U1006.Visible = false
					U1006.Parent = U1000
					local U1007 = Instance.new("Frame")
					U1007.Name = "ScanBracket"
					U1007.Size = UDim2.new(0, 2, 1, 0)
					U1007.Position = UDim2.new(0, -6, 0, 0)
					U1007.BackgroundColor3 = U998
					U1007.BackgroundTransparency = 1
					U1007.BorderSizePixel = 0
					U1007.Parent = U1006
					local L1536_14 = Instance.new("Frame")
					L1536_14.Name = "SkillChargeContainer"
					L1536_14.Size = UDim2.new(0, 68, 0, 5)
					L1536_14.AnchorPoint = Vector2.new(0.5, 0)
					L1536_14.Position = UDim2.new(0.5, 0, 1, 10)
					L1536_14.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
					L1536_14.BackgroundTransparency = 0.2
					L1536_14.BorderSizePixel = 0
					L1536_14.Visible = false
					L1536_14.Parent = U1000
					local L1536_15 = Instance.new("UICorner")
					L1536_15.CornerRadius = UDim.new(0, 3)
					L1536_15.Parent = L1536_14
					local L1536_16 = Instance.new("UIStroke")
					L1536_16.Thickness = 1
					L1536_16.Color = U997
					L1536_16.Transparency = 0.4
					L1536_16.Parent = L1536_14
					local L1536_17 = Instance.new("Frame")
					L1536_17.Name = "ChargeFill"
					L1536_17.Size = UDim2.new(0, 0, 1, 0)
					L1536_17.BackgroundColor3 = U997
					L1536_17.BorderSizePixel = 0
					L1536_17.Parent = L1536_14
					local L1536_18 = Instance.new("UICorner")
					L1536_18.CornerRadius = UDim.new(0, 3)
					L1536_18.Parent = L1536_17
					local L1536_19 = Instance.new("TextLabel")
					L1536_19.Name = "ChargeLabel"
					L1536_19.Size = UDim2.new(1, 0, 0, 10)
					L1536_19.AnchorPoint = Vector2.new(0.5, 0)
					L1536_19.Position = UDim2.new(0.5, 0, 1, 3)
					L1536_19.BackgroundTransparency = 1
					L1536_19.Font = Enum.Font.Code
					L1536_19.TextSize = 10
					L1536_19.TextColor3 = U997
					L1536_19.TextStrokeColor3 = Color3.fromRGB(30, 30, 30)
					L1536_19.TextStrokeTransparency = 0.4
					L1536_19.Text = "0%"
					L1536_19.Parent = L1536_14
					U918 = L1536_14
					U917 = L1536_17
					U915 = L1536_19
					local U1008 = 0
					local U1009 = nil
					local U1010 = false
					local U1011 = nil
					local U1012 = nil

					U959 = U911.RenderStepped:Connect(function(A1538_1)
						if not U996 or not U996.Parent then
							return
						end
						local L1538_1 = U913:GetMouseLocation()
						local L1538_2 = workspace.CurrentCamera
						local L1538_3 = U68.Character
						U1002.Rotation = (U1002.Rotation + A1538_1 * 135) % 360
						local L1538_4 = U1011 and U1011.Parent and L1538_2
						local L1538_5 = nil
						local L1538_6 = nil

						if L1538_4 then
							local L1538_7 = U1011:FindFirstChildOfClass("Humanoid")
							local L1538_8 = U1011:FindFirstChild("HumanoidRootPart") or U1011:FindFirstChild("Torso") or U1011:FindFirstChild("Head")

							if L1538_7 and L1538_7.Health > 0 and L1538_8 then
								local L1538_9 = math.clamp(L1538_2:ViewportPointToRay(L1538_1.X, L1538_1.Y).Direction.Unit:Dot((L1538_8.Position - L1538_2.CFrame.Position).Unit), -1, 1)

								if math.deg(math.acos(L1538_9)) <= 10 then
									local L1538_10, L1538_11 = L1538_2:WorldToViewportPoint(L1538_8.Position)

									if L1538_11 and L1538_10.Z > 0 then
										L1538_6 = U1011
										L1538_5 = U67:GetPlayerFromCharacter(U1011)
										local L1538_12 = L1538_10.X
										local L1538_13 = L1538_10.Y

										if not U1012 then
											U1012 = Vector2.new(L1538_12, L1538_13)
										else
											local L1538_14 = math.clamp
											U1012 = U1012:Lerp(Vector2.new(L1538_12, L1538_13), L1538_14(A1538_1 * 26, 0, 1))
										end
									else
										U1011 = nil
										L1538_5 = nil
										L1538_6 = nil
									end
								else
									U1011 = nil
									L1538_5 = nil
									L1538_6 = nil
								end
							else
								U1011 = nil
								L1538_5 = nil
								L1538_6 = nil
							end
						end

						local L1538_15

						if not L1538_6 and L1538_2 then
							local L1538_16 = L1538_2:ViewportPointToRay(L1538_1.X, L1538_1.Y)
							local L1538_17 = RaycastParams.new()
							L1538_17.FilterType = Enum.RaycastFilterType.Exclude
							local L1538_18 = { L1538_3, L1538_2 }

							if U916 then
								table.insert(L1538_18, U916)
							end

							if U920 then
								table.insert(L1538_18, U920)
							end

							L1538_17.FilterDescendantsInstances = L1538_18
							local L1538_19 = workspace:Raycast(L1538_16.Origin, L1538_16.Direction * 2500, L1538_17)

							if L1538_19 and L1538_19.Instance then
								local L1538_20 = L1538_19.Instance:FindFirstAncestorOfClass("Model")

								if L1538_20 and L1538_20 ~= L1538_3 then
									local L1538_21 = L1538_20:FindFirstChildOfClass("Humanoid")

									if L1538_21 and L1538_21.Health > 0 then
										L1538_5 = U67:GetPlayerFromCharacter(L1538_20)
										U1011 = L1538_20
										L1538_6 = L1538_20
									end
								end
							end

							if not L1538_6 then
								local L1538_22 = U68:GetMouse().Target

								if L1538_22 then
									local L1538_23 = L1538_22:FindFirstAncestorOfClass("Model")

									if L1538_23 and L1538_23 ~= L1538_3 then
										local L1538_24 = L1538_23:FindFirstChildOfClass("Humanoid")

										if L1538_24 and L1538_24.Health > 0 then
											L1538_5 = U67:GetPlayerFromCharacter(L1538_23)
											U1011 = L1538_23
											L1538_15 = L1538_23
										else
											L1538_15 = L1538_6
										end
									else
										L1538_15 = L1538_6
									end
								else
									L1538_15 = L1538_6
								end
							else
								L1538_15 = L1538_6
							end
						else
							L1538_15 = L1538_6
						end

						if L1538_15 and U1012 then
							U1000.Position = UDim2.new(0, U1012.X, 0, U1012.Y)
						else
							if U1012 then
								local L1538_25 = math.clamp
								U1012 = U1012:Lerp(Vector2.new(L1538_1.X, L1538_1.Y), L1538_25(A1538_1 * 24, 0, 1))

								if (U1012 - Vector2.new(L1538_1.X, L1538_1.Y)).Magnitude < 1.5 then
									U1012 = nil
								end
							end

							local L1538_26 = U1012 or Vector2.new(L1538_1.X, L1538_1.Y)
							U1000.Position = UDim2.new(0, L1538_26.X, 0, L1538_26.Y)
						end

						if L1538_15 then
							if not U1010 then
								U1010 = true
							end

							U919 = L1538_15
							U960 = L1538_5
							U1001.BackgroundColor3 = U998
							U1003.Color = U998
							U1004.Color = U998

							for I702, I703 in ipairs(U1005) do
								I703.BackgroundColor3 = U998
							end

							if U1009 ~= L1538_15 then
								U1009 = L1538_15
								U1008 = 0
							end

							U1008 = math.clamp(U1008 + A1538_1 * 7, 0, 1)
							local L1538_27 = L1538_15:FindFirstChildOfClass("Humanoid")
							local L1538_28 = L1538_5 and L1538_5.DisplayName or L1538_15.Name
							local L1538_29 = math.floor(L1538_27 and L1538_27.Health or 100)
							local L1538_30 = L1538_15:FindFirstChild("HumanoidRootPart") or L1538_15:FindFirstChild("Torso")

							if L1538_3 then
								L1538_3 = L1538_3:FindFirstChild("HumanoidRootPart") or L1538_3:FindFirstChild("Torso")
							end

							local L1538_31 = L1538_30 and L1538_3 and math.floor((L1538_30.Position - L1538_3.Position).Magnitude) or 0
							local L1538_32 = L1538_30 and math.floor(L1538_30.AssemblyLinearVelocity.Magnitude) or 0
							local L1538_33 = L1538_5 and L1538_5.AccountAge .. "D" or "N/A"
							U1006.Text = "NAME:\n" .. L1538_28:upper() .. "\n" .. "HEALTH: " .. L1538_29 .. "\n" .. "VELOCITY: " .. L1538_32 .. "\n" .. "DISTANCE: " .. L1538_31 .. "\n" .. "AGE: " .. L1538_33
							U1006.Position = UDim2.new(1, 14 + (1 - U1008) * 16, 0.5, -40)
							U1006.TextTransparency = 1 - U1008
							U1006.TextStrokeTransparency = 0.25 + (1 - U1008) * 0.75
							U1007.BackgroundTransparency = 1 - U1008
							U1006.Visible = true
						else
							if U1010 then
								U1010 = false
							end

							U919 = nil
							U960 = nil
							U1001.BackgroundColor3 = U997
							U1003.Color = U997
							U1004.Color = U997

							for I704, I705 in ipairs(U1005) do
								I705.BackgroundColor3 = U997
							end

							U1009 = nil

							if U1008 > 0 then
								U1008 = math.clamp(U1008 - A1538_1 * 8, 0, 1)
								U1006.Position = UDim2.new(1, 14 + (1 - U1008) * 16, 0.5, -40)
								U1006.TextTransparency = 1 - U1008
								U1006.TextStrokeTransparency = 0.25 + (1 - U1008) * 0.75
								U1007.BackgroundTransparency = 1 - U1008

								if U1008 <= 0.01 then
									U1006.Visible = false
								end
							else
								U1006.Visible = false
							end
						end
					end)
				end

				U908 = false
				local U1013 = nil
				local U1014 = nil

				U909 = function(A1539_1)
					local L1539_1 = game:GetService("Lighting")

					if A1539_1 and U66 and U66.EnableZoomEffects and U66.EnableZoomEffects.Value then
						if not U1014 then
							U1014 = Instance.new("BlurEffect")
							U1014.Name = "ST_ZoomBlur"
							U1014.Size = 0
							U1014.Parent = L1539_1
						end

						U953:Create(U1014, TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Size = 4 }):Play()
					elseif U1014 then
						local L1539_2 = U953:Create(U1014, TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Size = 0 })
						L1539_2:Play()

						L1539_2.Completed:Connect(function()
							if not U908 and U1014 then
								pcall(function()
									U1014:Destroy()
								end)

								U1014 = nil
							end
						end)
					end
				end

				U910 = function(A1542_1)
					local L1542_1 = workspace.CurrentCamera
					if not L1542_1 then
						return
					end

					if U1013 then
						U1013:Cancel()
						U1013 = nil
					end

					if A1542_1 then
						local L1542_2 = U65 and U65.ZoomDistance and U65.ZoomDistance.Value or 42
						U1013 = U953:Create(L1542_1, TweenInfo.new(0.24, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { FieldOfView = L1542_2 })
						U1013:Play()
						U909(true)
					else
						local L1542_3 = U65 and U65.FOV and U65.FOV.Value or 70
						U1013 = U953:Create(L1542_1, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { FieldOfView = L1542_3 })
						U1013:Play()
						U909(false)
					end
				end

				U913.InputBegan:Connect(function(A1543_1, A1543_2)
					if A1543_2 then
						return
					end

					if not (U66 and U66.EnableZoom and U66.EnableZoom.Value) then
						return
					end
					local L1543_1 = A1543_1.UserInputType == Enum.UserInputType.MouseButton2
					local L1543_2 = U65 and U65.ZoomKeybind and U65.ZoomKeybind.Value

					if L1543_1 or L1543_2 and L1543_2 ~= "None" and (A1543_1.KeyCode.Name == L1543_2 or L1543_2 == "MB2" and L1543_1) then
						U908 = true
						U910(true)
					end
				end)

				U913.InputEnded:Connect(function(A1544_1)
					if not U908 then
						return
					end
					local L1544_1 = A1544_1.UserInputType == Enum.UserInputType.MouseButton2
					local L1544_2 = U65 and U65.ZoomKeybind and U65.ZoomKeybind.Value

					if L1544_1 or L1544_2 and L1544_2 ~= "None" and (A1544_1.KeyCode.Name == L1544_2 or L1544_2 == "MB2" and L1544_1) then
						U908 = false
						U910(false)
					end
				end)

				U930 = function()
					U964()
					U987()
					U986()

					if U962 then
						pcall(function()
							U962:Disconnect()
						end)

						U962 = nil
					end

					U988()

					if U916 then
						pcall(function()
							U916:Destroy()
						end)

						U916 = nil
					end

					local U1015 = workspace:FindFirstChild("ST_IronManSuitContainer")

					if U1015 then
						pcall(function()
							U1015:Destroy()
						end)
					end

					local L1545_1 = U68.Character

					if L1545_1 then
						for I706, I707 in ipairs(L1545_1:GetChildren()) do
							if I707.Name:find("ST_IronManSuit") then
								pcall(function()
									I707:Destroy()
								end)
							end
						end
					end

					for I708, I709 in pairs(U963) do
						if I708 and I708.Parent then
							pcall(function()
								if type(I709) == "table" then
									I708.Transparency = I709.Transparency

									if I708:IsA("BasePart") then
										I708.CanCollide = I709.CanCollide
									end
								else
									I708.Transparency = I709
								end
							end)
						end
					end

					U963 = {}
				end

				U931 = function(A1551_1)
					if not A1551_1 then
						return
					end
					U930()

					task.spawn(function()
						if not U956 or U957 ~= U954 then
							local L1552_1, L1552_2 = pcall(function()
								return game:GetObjects("rbxassetid://" .. U954)
							end)

							if L1552_1 and L1552_2 and #L1552_2 > 0 then
								local L1552_3 = L1552_2[1]

								if L1552_3:IsA("Folder") or not L1552_3:FindFirstChildOfClass("BasePart") and #L1552_3:GetChildren() == 1 and L1552_3:GetChildren()[1]:IsA("Model") then
									for I710, I711 in ipairs(L1552_3:GetChildren()) do
										if I711:IsA("Model") then
											L1552_3 = I711
											break
										end
									end
								end

								if not L1552_3:FindFirstChild("Torso") and not L1552_3:FindFirstChildOfClass("BasePart") then
									for I712, I713 in ipairs(L1552_3:GetChildren()) do
										if I713:IsA("Model") and (I713:FindFirstChild("Torso") or I713:FindFirstChild("Head") or I713:FindFirstChildOfClass("BasePart")) then
											L1552_3 = I713
											break
										end
									end
								end

								U956 = L1552_3
								U957 = U954
							end
						end

						if not U956 then
							return
						end
						local U1016 = U956:Clone()
						U1016.Name = "ST_IronManSuit_" .. U954

						for I714, I715 in ipairs(U1016:GetDescendants()) do
							if I715:IsA("Script") or I715:IsA("LocalScript") or I715:IsA("Light") then
								pcall(function()
									I715:Destroy()
								end)
							end
						end

						local U1017 = U1016:FindFirstChildOfClass("Humanoid")

						if U1017 then
							pcall(function()
								U1017:Destroy()
							end)
						end

						for I716, I717 in ipairs(U1016:GetDescendants()) do
							if I717:IsA("Decal") and I717.Parent and I717.Parent.Name:lower():find("head") then
								I717.Transparency = 1
							end
						end

						for I718, I719 in ipairs(U1016:GetDescendants()) do
							if I719:IsA("BasePart") and I719.Name:lower():find("head") then
								I719.Color = Color3.fromRGB(35, 35, 35)
								I719.Material = Enum.Material.SmoothPlastic
							end
						end

						for I720, I721 in ipairs(U1016:GetDescendants()) do
							if I721:IsA("BasePart") then
								I721.CanCollide = false
								I721.CanTouch = false
								I721.CanQuery = false
								I721.Massless = true
								I721.Anchored = false

								if I721.Name == "HumanoidRootPart" or I721.Name:lower() == "rootpart" or I721.Name:lower() == "root" then
									I721.Transparency = 1
								end
							end
						end

						local L1552_4 = {
							head = "Head",
							torso = "Torso",
							leftarm = "Left Arm",
							rightarm = "Right Arm",
							leftleg = "Left Leg",
							rightleg = "Right Leg",
						}

						local U1018 = {}

						for I722, I723 in ipairs(U1016:GetDescendants()) do
							if I723:IsA("BasePart") then
								local L1552_5 = L1552_4[I723.Name:lower():gsub("%s+", ""):gsub("[_%-]", "")]

								if L1552_5 and not U1018[L1552_5] then
									U1018[L1552_5] = I723
								end
							end
						end

						local U1019 = A1551_1:FindFirstChild("HumanoidRootPart") or A1551_1:FindFirstChild("Torso")

						if U1019 then
							pcall(function()
								if U1016.PrimaryPart then
									U1016:SetPrimaryPartCFrame(U1019.CFrame)
								elseif U1016:FindFirstChild("HumanoidRootPart") or U1018.Torso or U1016:FindFirstChildOfClass("BasePart") then
									U1016:PivotTo(U1019.CFrame)
								end
							end)
						end

						U1016.Parent = A1551_1
						U916 = U1016

						for I724, I725 in ipairs(U1016:GetDescendants()) do
							if I725:IsA("JointInstance") or I725:IsA("WeldConstraint") then
								local L1552_6 = I725.Part0
								local L1552_7 = I725.Part1

								if L1552_6 and L1552_7 then
									local L1552_8 = nil
									local L1552_9 = nil

									for I726, I727 in pairs(U1018) do
										if L1552_6 == I727 then
											L1552_8 = I726
										end

										if L1552_7 == I727 then
											L1552_9 = I726
										end
									end

									if L1552_8 and L1552_9 and L1552_8 ~= L1552_9 then
										pcall(function()
											I725:Destroy()
										end)
									end
								end
							end
						end

						for I728, I729 in pairs(U1018) do
							local L1552_10 = A1551_1:FindFirstChild(I728)

							if L1552_10 then
								I729.CFrame = L1552_10.CFrame
								local L1552_11 = Instance.new("WeldConstraint")
								L1552_11.Name = "ST_Weld_" .. I728
								L1552_11.Part0 = I729
								L1552_11.Part1 = L1552_10
								L1552_11.Parent = I729
							end
						end

						for I730, I731 in ipairs(U1016:GetDescendants()) do
							if I731:IsA("BasePart") and not I731.Name:lower():find("root") then
								local L1552_12 = I731.Name:lower()
								local L1552_13 = L1552_12:find("head") or L1552_12:find("helm") or L1552_12:find("mask") or L1552_12:find("visor") or L1552_12:find("face")

								if L1552_13 and U1018.Head and I731 ~= U1018.Head then
									for I732, I733 in ipairs(I731:GetJoints()) do
										local L1552_14 = I733.Part0 == I731 and I733.Part1 or I733.Part0

										if L1552_14 then
											L1552_14 = L1552_14 == U1018.Torso or L1552_14.Name:lower():find("torso") or L1552_14.Name:lower():find("root")
										end

										if L1552_14 then
											pcall(function()
												I733:Destroy()
											end)
										end
									end
								end

								local L1552_15 = false

								for I734, I735 in ipairs(I731:GetJoints()) do
									if I735:IsA("Weld") or I735:IsA("WeldConstraint") or I735:IsA("Motor6D") or I735:IsA("Snap") then
										L1552_15 = true
										break
									end
								end

								if not L1552_15 then
									local L1552_16

									if L1552_13 and U1018.Head then
										L1552_16 = U1018.Head
									else
										local L1552_17 = math.huge
										L1552_16 = nil

										for I736, I737 in pairs(U1018) do
											local L1552_18 = (I731.Position - I737.Position).Magnitude

											if L1552_18 < L1552_17 then
												L1552_17 = L1552_18
												L1552_16 = I737
											end
										end
									end

									if L1552_16 then
										local L1552_19 = Instance.new("WeldConstraint")
										L1552_19.Part0 = I731
										L1552_19.Part1 = L1552_16
										L1552_19.Parent = I731
									end
								end
							end
						end

						U962 = U911.Stepped:Connect(function()
							local L1559_1 = U68.Character
							if not L1559_1 or not L1559_1.Parent or not U1016 or not U1016.Parent then
								return
							end

							for I738, I739 in ipairs(L1559_1:GetDescendants()) do
								if I739:IsA("BasePart") then
									if I739.Parent == U1016 or I739:IsDescendantOf(U1016) then
										I739.CanCollide = false
										I739.CanTouch = false
										I739.CanQuery = false
									elseif I739.Name ~= "HumanoidRootPart" and not I739.Name:find("Plasma") and not I739.Name:find("Jet") and not I739.Name:find("BackJet") and not I739:FindFirstAncestor("ST_IronManThrusterFlames") then
										if not U963[I739] then
											U963[I739] = { Transparency = I739.Transparency, CanCollide = I739.CanCollide }
										end

										I739.Transparency = 1
										I739.CanCollide = false
									end
								elseif I739:IsA("Decal") then
									if not I739:IsDescendantOf(U1016) then
										if not U963[I739] then
											U963[I739] = { Transparency = I739.Transparency, CanCollide = false }
										end

										I739.Transparency = 1
									end
								end
							end
						end)

						U989(A1551_1, U1016)
						F_001536()
						U965()
						U950(A1551_1)
					end)
				end
			end
			F_IronManHUD_Init()
		end
		F_IronManSuit_Init()

		do
			local U1020, U1021, U1022

			do
				U1020 = function()
					if not U941 then
						local L1560_1 = Instance.new("Animation")
						L1560_1.Name = "IronManIdleAnim"
						L1560_1.AnimationId = U937
						U941 = L1560_1
					end

					return U941
				end

				do
					local function F_001561(A1561_1)
						local L1561_1, L1561_2 = pcall(function()
							return game:GetObjects("rbxassetid://" .. U938)
						end)

						if not L1561_1 or not L1561_2 or #L1561_2 == 0 then
							return nil
						end
						local L1561_3 = L1561_2[1]
						local L1561_4 = nil

						for I740, I741 in ipairs(L1561_3:GetDescendants()) do
							if I741.Name:lower():find(A1561_1:lower()) then
								L1561_4 = I741
								break
							else
								L1561_4 = nil
							end
						end

						if not (not L1561_4 and L1561_3.Name:lower():find(A1561_1:lower())) then
							L1561_3 = L1561_4
						end

						if not L1561_3 then
							return nil
						end
						local L1561_5 = {}

						for I742, I743 in ipairs(L1561_3:GetChildren()) do
							if I743:IsA("Keyframe") then
								local U1023 = { Time = I743.Time, Poses = {} }
								local U1024 = nil

								U1024 = function(A1563_1)
									for I744, I745 in ipairs(A1563_1:GetChildren()) do
										if I745:IsA("Pose") then
											U1023.Poses[I745.Name] = I745.CFrame
											U1024(I745)
										end
									end
								end

								U1024(I743)
								table.insert(L1561_5, U1023)
							end
						end

						table.sort(L1561_5, function(A1564_1, A1564_2)
							return A1564_1.Time < A1564_2.Time
						end)

						if #L1561_5 == 0 then
							return nil
						end
						return { Keyframes = L1561_5, Duration = math.max(0.1, L1561_5[#L1561_5].Time) }
					end

					U1021 = function()
						if U942 then
							return U942
						end
						U942 = F_001561("Iron Man Idle")
						return U942
					end

					U1022 = function(A1566_1)
						if U943[A1566_1] then
							return U943[A1566_1]
						end
						local L1566_1 = F_001561(A1566_1)

						if L1566_1 then
							U943[A1566_1] = L1566_1
						end

						return L1566_1
					end
				end
			end

			do
				local function F_001567(A1567_1)
					local L1567_1 = {}
					if not A1567_1 then
						return L1567_1
					end
					local L1567_2 = A1567_1:FindFirstChild("Torso")
					local L1567_3 = A1567_1:FindFirstChild("HumanoidRootPart")

					if L1567_2 then
						L1567_1.Head = L1567_2:FindFirstChild("Neck")
						L1567_1["Right Arm"] = L1567_2:FindFirstChild("Right Shoulder")
						L1567_1["Left Arm"] = L1567_2:FindFirstChild("Left Shoulder")
						L1567_1["Right Leg"] = L1567_2:FindFirstChild("Right Hip")
						L1567_1["Left Leg"] = L1567_2:FindFirstChild("Left Hip")

						if L1567_3 then
							L1567_1.Torso = L1567_3:FindFirstChild("RootJoint")
						end
					else
						local L1567_4 = A1567_1:FindFirstChild("Head")
						local L1567_5 = A1567_1:FindFirstChild("RightUpperArm")
						local L1567_6 = A1567_1:FindFirstChild("LeftUpperArm")
						local L1567_7 = A1567_1:FindFirstChild("RightUpperLeg")
						local L1567_8 = A1567_1:FindFirstChild("LeftUpperLeg")
						local L1567_9 = A1567_1:FindFirstChild("LowerTorso")

						if L1567_4 then
							L1567_1.Head = L1567_4:FindFirstChild("Neck")
						end

						if L1567_5 then
							L1567_1["Right Arm"] = L1567_5:FindFirstChild("RightShoulder")
						end

						if L1567_6 then
							L1567_1["Left Arm"] = L1567_6:FindFirstChild("LeftShoulder")
						end

						if L1567_7 then
							L1567_1["Right Leg"] = L1567_7:FindFirstChild("RightHip")
						end

						if L1567_8 then
							L1567_1["Left Leg"] = L1567_8:FindFirstChild("LeftHip")
						end

						if L1567_9 then
							L1567_1.Torso = L1567_9:FindFirstChild("Root")
						end
					end

					return L1567_1
				end

				local function F_001568(A1568_1, A1568_2)
					local L1568_1 = A1568_1.Keyframes
					local L1568_2 = A1568_1.Duration
					if #L1568_1 == 1 then
						return L1568_1[1].Poses
					end
					local L1568_3 = A1568_2 % L1568_2
					local L1568_4 = L1568_1[1]
					local L1568_5 = L1568_1[#L1568_1]

					for I746 = 1, #L1568_1 - 1 do
						if L1568_3 >= L1568_1[I746].Time and L1568_3 <= L1568_1[I746 + 1].Time then
							L1568_4 = L1568_1[I746]
							L1568_5 = L1568_1[I746 + 1]
							break
						end
					end

					local L1568_6 = L1568_5.Time - L1568_4.Time
					local L1568_7 = math.clamp(L1568_6 > 0 and (L1568_3 - L1568_4.Time) / L1568_6 or 0, 0, 1)
					local L1568_8 = {}

					for I747, I748 in pairs(L1568_4.Poses) do
						L1568_8[I747] = I748:Lerp(L1568_5.Poses[I747] or I748, L1568_7)
					end

					for I749, I750 in pairs(L1568_5.Poses) do
						if not L1568_8[I749] then
							L1568_8[I749] = I750
						end
					end

					return L1568_8
				end

				local function F_001569()
					for I751, I752 in pairs(U949) do
						if I751 and I751.Parent then
							pcall(function()
								I751.C0 = I752
							end)
						end
					end
				end

				U935 = function()
					if U947 then
						pcall(function()
							U947:Disconnect()
						end)

						U947 = nil
					end

					F_001569()
					table.clear(U949)

					if U944 then
						pcall(function()
							U944:Stop(0.15)
							U944:Destroy()
						end)

						U944 = nil
					end

					local L1571_1 = U68.Character

					if L1571_1 then
						local L1571_2 = L1571_1:FindFirstChild("Animate")

						if L1571_2 and L1571_2:IsA("LocalScript") then
							L1571_2.Enabled = true
						end

						local L1571_3 = L1571_1:FindFirstChildOfClass("Humanoid")

						if L1571_3 then
							L1571_3.PlatformStand = false
							L1571_3.AutoRotate = true

							if not U946 then
								L1571_3.CameraOffset = Vector3.zero
							end
						end
					end
				end

				local function F_001574(A1574_1, A1574_2)
					if U947 then
						U947:Disconnect()
						U947 = nil
					end

					local U1025 = F_001567(A1574_1)

					for I753, I754 in pairs(U1025) do
						if I754 and not U949[I754] then
							U949[I754] = I754.C0
						end
					end

					local U1026 = 0

					U947 = U911.RenderStepped:Connect(function(A1575_1)
						if not A1574_1 or not A1574_1.Parent then
							return
						end

						if U946 then
							return
						end
						U1026 = (U1026 + A1575_1) % A1574_2.Duration
						local L1575_1 = F_001568(A1574_2, U1026)

						for I755, I756 in pairs(U1025) do
							local L1575_2 = U949[I756]
							local L1575_3 = L1575_1[I755]

							if I756 and I756.Parent and L1575_2 then
								if L1575_3 then
									I756.C0 = L1575_2 * L1575_3
								else
									I756.C0 = L1575_2
								end
							end
						end
					end)
				end

				U933 = function()
					if U946 then
						return
					end

					if U66.FlyToggle and not U66.FlyToggle.Value then
						U935()
						return
					end
					U935()
					local U1027 = U68.Character
					if not U1027 then
						return
					end
					local L1576_1 = U1027:FindFirstChildOfClass("Humanoid")
					if not L1576_1 then
						return
					end
					local U1028 = L1576_1:FindFirstChildOfClass("Animator")

					if not U1028 then
						U1028 = Instance.new("Animator")
						U1028.Parent = L1576_1
					end

					local U1029 = U1020()

					pcall(function()
						local L1577_1 = U1028:LoadAnimation(U1029)

						if L1577_1 then
							L1577_1.Priority = Enum.AnimationPriority.Action4
							L1577_1.Looped = true
							L1577_1:Play(0.1)
							U944 = L1577_1
						end
					end)

					task.spawn(function()
						local L1578_1 = U1021()

						if L1578_1 and U66.EnableIronManSuit and U66.EnableIronManSuit.Value and not U946 then
							F_001574(U1027, L1578_1)
						end
					end)
				end

				task.spawn(function()
					while not U66.FlyToggle do
						task.wait(0.1)
					end

					U66.FlyToggle:OnChanged(function(A1580_1)
						if U66.EnableIronManSuit and U66.EnableIronManSuit.Value then
							if A1580_1 then
								if not U946 then
									U933()
								end

								U952(true)
							else
								U935()
								U952(false)
								local L1580_1 = U68.Character

								if L1580_1 and not U940 then
									U950(L1580_1)
								end
							end
						end
					end)
				end)

				U934 = function()
					if U948 then
						U948:Disconnect()
						U948 = nil
					end

					if U945 then
						pcall(function()
							U945:Stop(0.1)
							U945:Destroy()
						end)

						U945 = nil
					end

					U946 = false
					U951(false)
					F_001569()
				end

				U936 = function(A1583_1)
					local U1030 = U939[A1583_1]
					if not U1030 then
						return
					end
					local U1031 = U68.Character
					if not U1031 then
						return
					end
					local L1583_1 = U1031:FindFirstChildOfClass("Humanoid")
					if not L1583_1 then
						return
					end
					local U1032 = L1583_1:FindFirstChildOfClass("Animator")

					if not U1032 then
						U1032 = Instance.new("Animator")
						U1032.Parent = L1583_1
					end

					U934()
					U946 = true
					U951(true)
					F_001569()
					local U1033 = 1.5
					local U1034 = Instance.new("Animation")
					U1034.Name = "IronManSkill" .. A1583_1 .. "Anim"
					U1034.AnimationId = "rbxassetid://" .. U1030.Id
					U1034.Parent = L1583_1

					local L1583_2, L1583_3 = pcall(function()
						return U1032:LoadAnimation(U1034)
					end)

					if L1583_2 and L1583_3 then
						L1583_3.Priority = Enum.AnimationPriority.Action4
						L1583_3.Looped = false
						L1583_3:Play(0.1)
						U945 = L1583_3

						if L1583_3.Length and L1583_3.Length > 0.2 then
							U1033 = L1583_3.Length
						end
					end

					task.spawn(function()
						local U1035 = U1022(U1030.KfsName)

						if U1035 and U946 then
							U1033 = math.max(U1033, U1035.Duration)
							local U1036 = F_001567(U1031)

							for I757, I758 in pairs(U1036) do
								if I758 and not U949[I758] then
									U949[I758] = I758.C0
								end
							end

							local U1037 = 0

							if U948 then
								U948:Disconnect()
							end

							U948 = U911.RenderStepped:Connect(function(A1586_1)
								if not U1031 or not U1031.Parent or not U946 then
									if U948 then
										U948:Disconnect()
										U948 = nil
									end

									return
								end

								U1037 += A1586_1

								if U1035.Duration < U1037 then
									if U948 then
										U948:Disconnect()
										U948 = nil
									end

									return
								end

								local L1586_1 = F_001568(U1035, U1037)

								for I759, I760 in pairs(U1036) do
									local L1586_2 = U949[I760]
									local L1586_3 = L1586_1[I759]

									if I760 and I760.Parent and L1586_2 then
										if L1586_3 then
											I760.C0 = L1586_2 * L1586_3
										else
											I760.C0 = L1586_2
										end
									end
								end
							end)
						end
					end)

					local U1038 = U945

					task.spawn(function()
						task.wait(U1033)

						if U946 and (U945 == U1038 or not U945) then
							U934()

							if U66.EnableIronManSuit and U66.EnableIronManSuit.Value then
								U933()
							end
						end
					end)
				end
			end
		end
	end

	local U1039, U1040, U1041, U1042, U1043, U1044

	do
		do
			U1039 = function(A1588_1, A1588_2, A1588_3)
				if U918 and U917 then
					U918.Visible = A1588_2
					local L1588_1 = math.clamp(A1588_1, 0, 1)
					U917.Size = UDim2.new(L1588_1, 0, 1, 0)
					local L1588_2 = U919 ~= nil and U919.Parent ~= nil
					local L1588_3 = L1588_2 and Color3.fromRGB(255, 25, 25) or Color3.fromRGB(255, 255, 255)
					U917.BackgroundColor3 = L1588_3
					local L1588_4 = U918:FindFirstChildOfClass("UIStroke")

					if L1588_4 then
						L1588_4.Color = L1588_3
					end

					if U915 then
						U915.Text = A1588_3 or string.format("%d%%", math.floor(L1588_1 * 100))
						U915.TextColor3 = L1588_3
						U915.TextStrokeColor3 = L1588_2 and Color3.fromRGB(40, 0, 0) or Color3.fromRGB(25, 25, 25)
					end

					if A1588_2 and L1588_1 > 0 and L1588_1 < 1 then
						U918.Position = UDim2.new(0.5, (math.random() - 0.5) * 3.4, 1, 10 + (math.random() - 0.5) * 2.2)
					else
						U918.Position = UDim2.new(0.5, 0, 1, 10)
					end
				end
			end

			U1040 = function(A1589_1)
				local L1589_1 = U68.Character
				local L1589_2 = L1589_1 and L1589_1:FindFirstChildOfClass("Humanoid")

				if L1589_2 then
					local L1589_3 = tick() * 36
					local L1589_4 = 0.05 + A1589_1 * 0.14
					L1589_2.CameraOffset = Vector3.new(math.sin(L1589_3 * 1.3) * L1589_4, math.cos(L1589_3 * 1.7) * L1589_4, 0)
				end
			end

			U1041 = function(A1590_1)
				task.spawn(function()
					local L1591_1 = U68.Character
					local L1591_2 = L1591_1 and L1591_1:FindFirstChildOfClass("Humanoid")
					if not L1591_2 then
						return
					end
					local L1591_3 = A1590_1 or 1
					local L1591_4 = tick()

					while tick() - L1591_4 < 0.48 do
						local L1591_5 = 3.2 * (1 - (tick() - L1591_4) / 0.48) ^ 1.4 * L1591_3
						L1591_2.CameraOffset = Vector3.new((math.random() - 0.5) * 2 * L1591_5, (math.random() - 0.5) * 2 * L1591_5, (math.random() - 0.5) * 1.5 * L1591_5)
						U911.RenderStepped:Wait()
					end

					if L1591_2 then
						L1591_2.CameraOffset = Vector3.zero
					end
				end)
			end

			do
				local function F_001592()
					if U919 and U919.Parent then
						local L1592_1 = U919:FindFirstChild("HumanoidRootPart") or U919:FindFirstChild("Torso")
						local L1592_2 = U919:FindFirstChildOfClass("Humanoid")
						if L1592_1 and L1592_2 and L1592_2.Health > 0 then
							return U919, L1592_1
						end
					end

					local L1592_3 = U68:GetMouse()

					if L1592_3 and L1592_3.Target then
						local L1592_4 = L1592_3.Target:FindFirstAncestorOfClass("Model")

						if L1592_4 and L1592_4 ~= U68.Character then
							local L1592_5 = L1592_4:FindFirstChildOfClass("Humanoid")
							local L1592_6 = L1592_4:FindFirstChild("HumanoidRootPart") or L1592_4:FindFirstChild("Torso")
							if L1592_5 and L1592_5.Health > 0 and L1592_6 then
								return L1592_4, L1592_6
							end
						end
					end

					local L1592_7 = workspace.CurrentCamera
					local L1592_8 = U913:GetMouseLocation()

					if L1592_7 then
						local L1592_9 = L1592_7:ViewportPointToRay(L1592_8.X, L1592_8.Y)
						local L1592_10 = RaycastParams.new()
						L1592_10.FilterType = Enum.RaycastFilterType.Exclude
						local L1592_11 = { U68.Character, L1592_7 }

						if U916 then
							table.insert(L1592_11, U916)
						end

						if U920 then
							table.insert(L1592_11, U920)
						end

						L1592_10.FilterDescendantsInstances = L1592_11
						local L1592_12 = workspace:Raycast(L1592_9.Origin, L1592_9.Direction * 2500, L1592_10)

						if L1592_12 and L1592_12.Instance then
							local L1592_13 = L1592_12.Instance:FindFirstAncestorOfClass("Model")

							if L1592_13 and L1592_13 ~= U68.Character then
								local L1592_14 = L1592_13:FindFirstChildOfClass("Humanoid")
								local L1592_15 = L1592_13:FindFirstChild("HumanoidRootPart") or L1592_13:FindFirstChild("Torso")
								if L1592_14 and L1592_14.Health > 0 and L1592_15 then
									return L1592_13, L1592_15
								end
							end
						end
					end

					return nil, nil
				end

				U1042 = function()
					task.spawn(function()
						local U1045 = (U65 and U65.SoundEffects and U65.SoundEffects.Value or 100) / 100

						pcall(function()
							local L1595_1 = Instance.new("Sound")
							L1595_1.Name = "ST_Skill_OfficialSound"
							L1595_1.SoundId = "rbxassetid://90804156043814"
							L1595_1.Volume = 4 * U1045
							L1595_1.RollOffMaxDistance = 100000
							L1595_1.Parent = workspace.CurrentCamera or game:GetService("SoundService")
							L1595_1:Play()
							U912:AddItem(L1595_1, 10)
						end)
					end)
				end

				U1043 = function()
					local L1596_1 = U68.Character

					if L1596_1 then
						L1596_1 = L1596_1:FindFirstChild("HumanoidRootPart") or L1596_1:FindFirstChild("Torso")
					end

					local L1596_2
					L1596_2, L1596_2 = F_001592()

					if L1596_2 then
						local L1596_3 = L1596_2.Position
						local L1596_4 = L1596_2.AssemblyLinearVelocity or L1596_2.Velocity

						if L1596_4 then
							L1596_3 += L1596_4 / 1.93
						end

						return L1596_3, L1596_2
					end

					local L1596_5 = U68:GetMouse()
					if L1596_5 and L1596_5.Hit then
						local L1596_6 = L1596_5.Target
						return L1596_5.Hit.Position, L1596_6 and L1596_6:IsA("BasePart") and L1596_6 ~= workspace.Terrain and L1596_6 or L1596_1
					end
					local L1596_7 = workspace.CurrentCamera

					if L1596_7 then
						local L1596_8 = U913:GetMouseLocation()
						local L1596_9 = L1596_7:ViewportPointToRay(L1596_8.X, L1596_8.Y)
						local L1596_10 = RaycastParams.new()
						L1596_10.FilterType = Enum.RaycastFilterType.Exclude
						local L1596_11 = { U68.Character, L1596_7 }

						if U916 then
							table.insert(L1596_11, U916)
						end

						L1596_10.FilterDescendantsInstances = L1596_11
						local L1596_12 = workspace:Raycast(L1596_9.Origin, L1596_9.Direction * 5000, L1596_10)
						if L1596_12 and L1596_12.Position then
							return L1596_12.Position, L1596_12.Instance and L1596_12.Instance:IsA("BasePart") and L1596_12.Instance ~= workspace.Terrain and L1596_12.Instance or L1596_1
						end
						return L1596_9.Origin + L1596_9.Direction * 300, L1596_1
					end

					return L1596_1 and L1596_1.Position or Vector3.zero, L1596_1
				end
			end
		end

		do
			local function F_001597(A1597_1, A1597_2)
				local L1597_1 = (A1597_2 - A1597_1).Unit
				local L1597_2 = L1597_1:Cross(Vector3.new(0, 1, 0))
				local L1597_3 = L1597_2:Cross(L1597_1)
				return CFrame.fromMatrix(A1597_1, L1597_2, L1597_3)
			end

			local function F_001598(A1598_1)
				if not A1598_1 then
					return
				end
				local U1046 = U68.Character

				if U1046 then
					U1046 = U1046:FindFirstChild("HumanoidRootPart") or U1046:FindFirstChild("Torso")
				end

				local U1047 = U73:FindFirstChild("GrabEvents")
				U1047 = U1047 and U1047:FindFirstChild("SetNetworkOwner")

				if U1046 and U1047 then
					pcall(function()
						U1047:FireServer(A1598_1, F_001597(U1046.Position, A1598_1.Position))
					end)
				end
			end

			U1044 = function(A1600_1)
				if not A1600_1 or not A1600_1.PrimaryPart then
					return
				end
				local L1600_1 = A1600_1:FindFirstChild("Body")
				if not L1600_1 then
					return
				end
				F_001598(L1600_1)
				task.wait(0.05)

				pcall(function()
					for I761, I762 in pairs(A1600_1.PrimaryPart:GetChildren()) do
						if I762:IsA("BodyVelocity") or I762.Name == "Stable" then
							I762:Destroy()
						end
					end

					local L1601_1 = Instance.new("BodyVelocity")
					L1601_1.Velocity = Vector3.zero
					L1601_1.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
					L1601_1.Name = "Stable"
					L1601_1.Parent = A1600_1.PrimaryPart
					local L1601_2 = math.random
					A1600_1:PivotTo(CFrame.new(math.random(-500, 500), 10000, L1601_2(-500, 500)))
				end)
			end
		end
	end

	do
		do
			local function F_001602(A1602_1, A1602_2, A1602_3)
				if not A1602_1 or not A1602_2 then
					return
				end
				local U1048 = A1602_1:FindFirstChild("PartHitDetector")
				local U1049 = U73:FindFirstChild("BombEvents")
				U1049 = U1049 and U1049:FindFirstChild("BombExplode")

				if U1048 and U1049 then
					pcall(function()
						U1049:FireServer({ Hitbox = U1048, PositionPart = A1602_2 }, A1602_3)
					end)
				end
			end

			local function F_001604()
				task.wait(0.15)
				local L1604_1 = U71:FindFirstChild(U68.Name .. "SpawnedInToys")
				local L1604_2 = U73:FindFirstChild("MenuToys")
				local U1050 = L1604_2 and L1604_2:FindFirstChild("DestroyToy")

				if L1604_1 and U1050 then
					for I763, I764 in pairs(L1604_1:GetChildren()) do
						if I764.Name == "BombMissile" then
							pcall(function()
								U1050:FireServer(I764)
							end)
						end
					end
				end
			end

			local function F_001606(A1606_1, A1606_2)
				local L1606_1 = U73:FindFirstChild("MenuToys")
				local U1051 = L1606_1 and L1606_1:FindFirstChild("SpawnToyRemoteFunction")
				local U1052 = L1606_1 and L1606_1:FindFirstChild("BuyToyRemoteFunction")
				local L1606_2 = U68.Character
				local U1053

				if L1606_2 then
					U1053 = L1606_2:FindFirstChild("HumanoidRootPart") or L1606_2:FindFirstChild("Torso")
				else
					U1053 = L1606_2
				end

				if not U1053 then
					return {}
				end
				F_001604()
				if not A1606_2() then
					return {}
				end

				for I765 = 1, A1606_1 do
					if U1051 and U1052 then
						pcall(function()
							U1051:InvokeServer("BombMissile", CFrame.new(U1053.Position + Vector3.new((I765 - 1) * 3, 5, 0)), Vector3.zero)
							U1052:InvokeServer("BombMissile")
						end)
					end
				end

				local L1606_3 = {}
				local L1606_4 = tick()

				while tick() - L1606_4 < 0.6 and A1606_2() and #L1606_3 < A1606_1 do
					local L1606_5 = U71:FindFirstChild(U68.Name .. "SpawnedInToys")

					if L1606_5 then
						for I766, I767 in pairs(L1606_5:GetChildren()) do
							if I767.Name == "BombMissile" and I767.PrimaryPart and not table.find(L1606_3, I767) then
								table.insert(L1606_3, I767)
								U1044(I767)
								if not (A1606_1 <= #L1606_3) then
									continue
								end
							else
								continue
							end

							break
						end
					end

					task.wait(0.02)
				end

				if not A1606_2() then
					F_001604()
					return {}
				end
				return L1606_3
			end

			U913.InputBegan:Connect(function(A1608_1, A1608_2)
				if A1608_2 then
					return
				end

				if not (U66.EnableIronManSuit and U66.EnableIronManSuit.Value) then
					return
				end
				local L1608_1 = U65 and U65.Skill1Keybind and U65.Skill1Keybind.Value or "One"
				local L1608_2 = U65 and U65.Skill2Keybind and U65.Skill2Keybind.Value or "Two"

				if A1608_1.KeyCode.Name == L1608_1 then
					U914 = true
					U923 += 1
					local U1054 = U923

					task.spawn(function()
						local L1609_1 = F_001606(1, function()
							return U914 and U923 == U1054
						end)

						if U914 and U923 == U1054 then
							U921 = L1609_1
						else
							F_001604()
						end
					end)

					task.spawn(function()
						local L1611_1 = tick()
						U1039(0, true, "0%")

						while U914 and U923 == U1054 and tick() - L1611_1 < 0.8 do
							local L1611_2 = math.clamp((tick() - L1611_1) / 0.8, 0, 1)
							U1039(L1611_2, true, string.format("%d%%", math.floor(L1611_2 * 100)))
							U1040(L1611_2)
							U911.RenderStepped:Wait()
						end

						if not U914 or U923 ~= U1054 then
							U1039(0, false)
							local L1611_3 = U68.Character
							L1611_3 = L1611_3 and L1611_3:FindFirstChildOfClass("Humanoid")

							if L1611_3 then
								L1611_3.CameraOffset = Vector3.zero
							end

							F_001604()
							U921 = {}
							return
						end

						U914 = false
						U1039(1, false)
						local L1611_4 = U68.Character
						local L1611_5 = L1611_4 and L1611_4:FindFirstChildOfClass("Humanoid")

						if L1611_5 then
							L1611_5.CameraOffset = Vector3.zero
						end

						U1042()
						U936(1)
						local L1611_6, L1611_7 = U1043()
						local L1611_8 = U921
						U921 = {}

						if #L1611_8 == 0 then
							local L1611_9 = U71:FindFirstChild(U68.Name .. "SpawnedInToys")

							if L1611_9 then
								for I768, I769 in pairs(L1611_9:GetChildren()) do
									if I769.Name == "BombMissile" and I769.PrimaryPart then
										U1044(I769)
										table.insert(L1611_8, I769)
										break
									end
								end
							end
						end

						if #L1611_8 > 0 then
							F_001602(L1611_8[1], L1611_7, L1611_6)
							U1041(1.4)
						end

						task.spawn(F_001604)
					end)
				elseif A1608_1.KeyCode.Name == L1608_2 then
					U924 = true
					U922 += 1
					local U1055 = U922

					task.spawn(function()
						local L1612_1 = F_001606(2, function()
							return U924 and U922 == U1055
						end)

						if U924 and U922 == U1055 then
							U927 = L1612_1
						else
							F_001604()
						end
					end)

					task.spawn(function()
						local L1614_1 = tick()
						U1039(0, true, "0%")

						while U924 and U922 == U1055 and tick() - L1614_1 < 0.45 do
							local L1614_2 = math.clamp((tick() - L1614_1) / 0.45, 0, 1)
							U1039(L1614_2, true, string.format("%d%%", math.floor(L1614_2 * 100)))
							U1040(L1614_2)
							U911.RenderStepped:Wait()
						end

						if not U924 or U922 ~= U1055 then
							U1039(0, false)
							local L1614_3 = U68.Character
							local L1614_4 = L1614_3 and L1614_3:FindFirstChildOfClass("Humanoid")

							if L1614_4 then
								L1614_4.CameraOffset = Vector3.zero
							end

							F_001604()
							U927 = {}
							return
						end

						U924 = false
						U1039(1, false)
						local L1614_5 = U68.Character
						local L1614_6 = L1614_5 and L1614_5:FindFirstChildOfClass("Humanoid")

						if L1614_6 then
							L1614_6.CameraOffset = Vector3.zero
						end

						U1042()
						U936(2)
						local L1614_7, L1614_8 = U1043()
						local L1614_9 = U927
						U927 = {}

						if #L1614_9 < 2 then
							local L1614_10 = U71:FindFirstChild(U68.Name .. "SpawnedInToys")

							if L1614_10 then
								for I770, I771 in pairs(L1614_10:GetChildren()) do
									if I771.Name == "BombMissile" and I771.PrimaryPart and not table.find(L1614_9, I771) then
										U1044(I771)
										table.insert(L1614_9, I771)
										if not (#L1614_9 >= 2) then
											continue
										end
									else
										continue
									end

									break
								end
							end
						end

						local L1614_11 = workspace.CurrentCamera
						L1614_11 = L1614_11 and L1614_11.CFrame.RightVector or Vector3.new(1, 0, 0)
						local L1614_12 = Vector3.new(L1614_11.X, 0, L1614_11.Z).Unit

						if L1614_12.Magnitude < 0.1 then
							L1614_12 = Vector3.new(1, 0, 0)
						end

						local L1614_13 = L1614_12 * 2.5
						local L1614_14 = L1614_7 - L1614_13
						local L1614_15 = L1614_7 + L1614_13

						if #L1614_9 >= 2 then
							F_001602(L1614_9[1], L1614_8, L1614_14)
							F_001602(L1614_9[2], L1614_8, L1614_15)
							U1041(2)
						elseif #L1614_9 == 1 then
							F_001602(L1614_9[1], L1614_8, L1614_7)
							U1041(1.6)
						end

						task.spawn(F_001604)
					end)
				end
			end)

			U913.InputEnded:Connect(function(A1615_1)
				local L1615_1 = U65 and U65.Skill1Keybind and U65.Skill1Keybind.Value or "One"
				local L1615_2 = U65 and U65.Skill2Keybind and U65.Skill2Keybind.Value or "Two"

				if A1615_1.KeyCode.Name == L1615_1 then
					if U914 then
						U914 = false
						U923 += 1
						U1039(0, false)
						local L1615_3 = U68.Character
						L1615_3 = L1615_3 and L1615_3:FindFirstChildOfClass("Humanoid")

						if L1615_3 then
							L1615_3.CameraOffset = Vector3.zero
						end

						F_001604()
						U921 = {}
					end
				elseif A1615_1.KeyCode.Name == L1615_2 then
					if U924 then
						U924 = false
						U922 += 1
						U1039(0, false)
						local L1615_4 = U68.Character
						L1615_4 = L1615_4 and L1615_4:FindFirstChildOfClass("Humanoid")

						if L1615_4 then
							L1615_4.CameraOffset = Vector3.zero
						end

						F_001604()
						U927 = {}
					end
				end
			end)
		end
	end

	U68.CharacterAdded:Connect(function(A1616_1)
		if U66.EnableIronManSuit and U66.EnableIronManSuit.Value then
			task.spawn(function()
				A1616_1:WaitForChild("HumanoidRootPart", 5)
				local L1617_1 = A1616_1:WaitForChild("Humanoid", 5)

				if L1617_1 then
					L1617_1.Died:Connect(function()
						U930()
					end)
				end

				task.wait(0.3)

				if U66.EnableIronManSuit and U66.EnableIronManSuit.Value then
					if U66.FlyToggle and U66.FlyToggle.Value then
						U933()
					else
						U935()
					end

					U931(A1616_1)
				end
			end)
		end
	end)

	L0_400 = U92.Miscs:AddGroupbox({
		Side = 1,
		Name = "<b>Iron Man Suit</b>",
		IconName = "bot",
		Description = "Visual Suits",
		MaxPopOutHeight = 600,
		PopOutWidth = 250,
	}):AddTabbox({ MaxPopOutHeight = 600 })

	do
		local L0_401 = L0_400:AddTab("<b>Suit</b>", "bot")

		L0_401:AddToggle("EnableIronManSuit", {
			Text = "Enable Suit",
			Default = false,
			Callback = function(A1619_1)
				if A1619_1 then
					task.spawn(function()
						if U926 then
							return
						end
						U926 = true

						pcall(function()
							if U66.FlyToggle and not U66.FlyToggle.Value then
								U66.FlyToggle:SetValue(true)
							end

							if not flyConn then
								updateFly(true)
							end
						end)

						if not (U66.SkipIntro and U66.SkipIntro.Value) then
							U932()
						end

						U933()
						U931(U68.Character)
						local L1620_1 = U68.Character and U68.Character:FindFirstChildOfClass("Humanoid")

						if L1620_1 then
							L1620_1.Died:Connect(function()
								U930()
							end)
						end

						U926 = false
						U906()
					end)
				else
					U929()
					U934()
					U935()
					U930()
					U906(true)
				end
			end,
		})

		L0_401:AddDivider()

		L0_401:AddDropdown("SuitType", {
			Text = "Suit Type",
			IconName = "bot",
			Default = "Mark 6",
			Values = { "Mark 6" },
			ValueImages = { ["Mark 6"] = "bot" },
			Callback = function()
			end,
		})

		L0_401:AddDivider()

		L0_401:AddSlider("SoundEffects", {
			Text = "Sound Effects",
			Default = 100,
			Min = 0,
			Max = 100,
			Rounding = 0,
			Compact = true,
			Suffix = "%",
			Callback = function()
				U928()
			end,
		})

		L0_401:AddSlider("AmbientSound", {
			Text = "Ambient Sound",
			Default = 60,
			Min = 0,
			Max = 100,
			Rounding = 0,
			Compact = true,
			Suffix = "%",
			Callback = function()
				U925()
			end,
		})

		L0_401:AddDivider()

		L0_401:AddToggle("EnableJarvis", {
			Text = "Enable Jarvis",
			Default = false,
			Callback = function(A1626_1)
				if A1626_1 then
					U75({ Title = "<b>J.A.R.V.I.S.</b>", Description = "Systems online and ready, sir.", Duration = 3 })
				end
			end,
		})

		L0_401:AddDivider("Commands")

		L0_401:AddDropdown("JarvisCommands", {
			Text = "Jarvis Commands",
			IconName = "terminal",
			Default = { "Jarvis Kill Me", "Jarvis Rejoin", "Jarvis Hop Servers" },
			Multi = true,
			Values = { "Jarvis Kill Me", "Jarvis Rejoin", "Jarvis Hop Servers" },
			ValueImages = {
				["Jarvis Kill Me"] = "skull",
				["Jarvis Rejoin"] = "rotate-ccw",
				["Jarvis Hop Servers"] = "server",
			},
			Callback = function()
			end,
		})
	end
end

local L0_402 = L0_400:AddTab("<b>Settings</b>", "settings")

L0_402:AddToggle("IronManEnableUI", {
	Text = "Enable UI",
	Default = true,
	Callback = function()
		U907()
		U906()
	end,
})

L0_402:AddSlider("IronManUITransparency", {
	Text = "UI Transparency",
	Default = 0,
	Min = 0,
	Max = 1,
	Rounding = 2,
	Compact = true,
	Callback = function()
		U907()
	end,
})

L0_402:AddDropdown("IronManUIType", {
	Text = "UI TYPE",
	IconName = "palette",
	Default = "Red",
	Values = { "Red" },
	ValueImages = { Red = "flame" },
	Callback = function()
		U907()
		U906()
	end,
})

L0_402:AddDivider("Other")

L0_402:AddToggle("SkipIntro", {
	Text = "Skip Intro",
	Default = false,
	Callback = function()
	end,
})

L0_402:AddDivider()

L0_402:AddLabel("Skill 1 Keybind"):AddKeyPicker("Skill1Keybind", {
	Default = "One",
	NoUI = false,
	Text = "Skill 1 Keybind",
	Callback = function()
	end,
})

L0_402:AddDivider()

L0_402:AddLabel("Skill 2 Keybind"):AddKeyPicker("Skill2Keybind", {
	Default = "Two",
	NoUI = false,
	Text = "Skill 2 Keybind",
	Callback = function()
	end,
})

L0_402:AddDivider("Zoom")

L0_402:AddToggle("EnableZoom", {
	Text = "Enable Zoom",
	Default = true,
	Callback = function(A1634_1)
		if not A1634_1 and U908 then
			U908 = false
			U910(false)
		end
	end,
}):AddKeyPicker("ZoomKeybind", {
	Default = "MB2",
	Mode = "Hold",
	SyncToggleState = true,
	Text = "Zoom Keybind",
	Callback = function(A1635_1)
		if U66.EnableZoom and U66.EnableZoom.Value then
			U908 = A1635_1
			U910(A1635_1)
		end
	end,
})

L0_402:AddSlider("ZoomDistance", {
	Text = "Zoom Distance",
	Default = 42,
	Min = 5,
	Max = 120,
	Rounding = 0,
	Compact = true,
	Callback = function()
		if U908 then
			U910(true)
		end
	end,
})

L0_402:AddDropdown("ZoomType", {
	Text = "Zoom Type",
	Default = "Smooth",
	Values = { "Smooth" },
	Callback = function()
	end,
})

L0_402:AddDivider()

L0_402:AddToggle("EnableZoomEffects", {
	Text = "Enable Zoom Effects",
	Default = true,
	Callback = function(A1638_1)
		if not A1638_1 then
			U909(false)
		elseif U908 then
			U909(true)
		end
	end,
})

local function F_001639(A1639_1)
	if not A1639_1 then
		return
	end

	if not (U66.EnableJarvis and U66.EnableJarvis.Value) then
		return
	end

	local function F_001640(A1640_1)
		if not U65.JarvisCommands or not U65.JarvisCommands.Value then
			return true
		end
		local L1640_1 = U65.JarvisCommands.Value
		if type(L1640_1) == "table" then
			return L1640_1[A1640_1] == true or L1640_1[A1640_1] == "true"
		end

		if type(L1640_1) == "string" then
			return L1640_1 == A1640_1
		end
		return false
	end

	local L1639_1 = tostring(A1639_1):lower():gsub("^%s+", ""):gsub("%s+$", "")

	if L1639_1 == "jarvis kill me" or L1639_1 == "jarvis, kill me" or L1639_1:find("^jarvis%s*kill%s*me") then
		if not F_001640("Jarvis Kill Me") then
			return
		end
		local L1639_2 = U68.Character

		if L1639_2 then
			U75({
				Title = "<b>J.A.R.V.I.S.</b>",
				Description = "Self-destruct sequence authorized. Goodbye, sir.",
				Duration = 3,
			})

			local L1639_3 = L1639_2:FindFirstChildOfClass("Humanoid")

			if L1639_3 then
				L1639_3.Health = 0
			else
				L1639_2:BreakJoints()
			end
		end
	elseif L1639_1 == "jarvis rejoin" or L1639_1 == "jarvis, rejoin" or L1639_1:find("^jarvis%s*rejoin") then
		if not F_001640("Jarvis Rejoin") then
			return
		end

		U75({
			Title = "<b>J.A.R.V.I.S.</b>",
			Description = "Reconnecting to current server, sir...",
			Duration = 3,
		})

		task.spawn(function()
			local U1056 = game:GetService("TeleportService")

			pcall(function()
				U1056:TeleportToPlaceInstance(game.PlaceId, game.JobId, U68)
			end)
		end)
	elseif L1639_1 == "jarvis hop servers" or L1639_1 == "jarvis hop server" or L1639_1 == "jarvis server hop" or L1639_1:find("^jarvis%s*hop") then
		if not F_001640("Jarvis Hop Servers") then
			return
		end

		U75({
			Title = "<b>J.A.R.V.I.S.</b>",
			Description = "Locating an optimal server, sir...",
			Duration = 3,
		})

		task.spawn(function()
			local U1057 = game:GetService("TeleportService")
			local L1643_1 = game:GetService("HttpService")
			local U1058 = string.format("https://games.roblox.com/v1/games/%s/servers/Public?sortOrder=Desc&limit=100", tostring(game.PlaceId))

			local L1643_2, L1643_3 = pcall(function()
				return game:HttpGet(U1058)
			end)

			if L1643_2 and L1643_3 then
				local L1643_4 = L1643_1:JSONDecode(L1643_3)

				if L1643_4 and L1643_4.data then
					for I772, I773 in ipairs(L1643_4.data) do
						if I773.id ~= game.JobId and I773.playing < I773.maxPlayers then
							U1057:TeleportToPlaceInstance(game.PlaceId, I773.id, U68)
							return
						end
					end
				end
			end

			pcall(function()
				U1057:Teleport(game.PlaceId, U68)
			end)
		end)
	end
end

pcall(function()
	U68.Chatted:Connect(function(A1647_1)
		pcall(function()
			F_001639(A1647_1)
		end)
	end)
end)

pcall(function()
	local L1649_1 = game:GetService("TextChatService")

	if L1649_1 then
		L1649_1.MessageReceived:Connect(function(A1650_1)
			if A1650_1 and A1650_1.TextSource then
				if A1650_1.TextSource.UserId == U68.UserId then
					F_001639(A1650_1.Text)
				end
			end
		end)
	end
end)

local U1059
U1059 = "94654236903069"
local U1060, U1061, U1062, U1063, U1064

do
	local U1065 = Vector3.new(4474.63, -13.74, 2075.96)
	U1060 = nil
	U1061 = false
	U1062 = { X = 0, Y = 0, Z = 0 }
	U1063 = nil

	local function F_001651()
		return U1065 + Vector3.new(U1062.X, U1062.Y, U1062.Z)
	end

	U1064 = function()
		if U1060 and U1060.Parent then
			local L1652_1 = F_001651()

			if U1060:IsA("Model") then
				U1060:PivotTo(CFrame.new(L1652_1))
			elseif U1060:IsA("BasePart") then
				U1060.CFrame = CFrame.new(L1652_1)
			end
		end
	end

	local U1066 = { FogEnd = Lighting.FogEnd, FogStart = Lighting.FogStart }

	local function F_001653()
		pcall(function()
			U1066.FogEnd = Lighting.FogEnd
			U1066.FogStart = Lighting.FogStart

			if U65.SelectShader and U65.SelectShader.SetValue then
				U65.SelectShader:SetValue("Arctic")
			end

			if U66.EnableShader and U66.EnableShader.SetValue then
				U66.EnableShader:SetValue(true)
			end

			if U65.Preset and U65.Preset.SetValue then
				U65.Preset:SetValue("Midnight")
			end

			if U66.EnablePresets and U66.EnablePresets.SetValue then
				U66.EnablePresets:SetValue(true)
			end

			Lighting.FogStart = 0
			Lighting.FogEnd = 50

			task.delay(0.9, function()
				pcall(function()
					Lighting.FogStart = 0
					Lighting.FogEnd = 50
				end)
			end)
		end)
	end

	local function F_001657()
		pcall(function()
			if U66.EnableShader and U66.EnableShader.SetValue then
				U66.EnableShader:SetValue(false)
			end

			if U66.EnablePresets and U66.EnablePresets.SetValue then
				U66.EnablePresets:SetValue(false)
			end

			if U1066.FogEnd then
				Lighting.FogEnd = U1066.FogEnd
				Lighting.FogStart = U1066.FogStart
			else
				Lighting.FogEnd = 100000
				Lighting.FogStart = 0
			end
		end)
	end

	local function F_001659()
		if U1063 then
			pcall(function()
				U1063:Stop()
				U1063:Destroy()
			end)

			U1063 = nil
		end
	end

	local function F_001661()
		task.spawn(function()
			F_001659()
			if not writefile or not getcustomasset then
				return
			end

			if not (isfile and isfile("ST_NotAHuman_Ambient_v3.mp3")) then
				pcall(function()
					local L1663_1 = game:HttpGet("https://files.catbox.moe/n7r24k.mp3")

					if L1663_1 and #L1663_1 > 0 then
						writefile("ST_NotAHuman_Ambient_v3.mp3", L1663_1)
					end
				end)
			end

			if isfile and isfile("ST_NotAHuman_Ambient_v3.mp3") then
				pcall(function()
					U1063 = Instance.new("Sound")
					U1063.Name = "ST_NAH_AmbientSound"
					U1063.Looped = true
					U1063.Parent = game:GetService("SoundService")
					U1063.SoundId = getcustomasset("ST_NotAHuman_Ambient_v3.mp3")
					U1063.Volume = (U65.NAHAmbientVolume and U65.NAHAmbientVolume.Value or 50) / 100 * 5
					U1063:Play()
				end)
			end
		end)
	end

	local function F_001665()
		if not U1060 or not U1060.Parent then
			return nil
		end

		for I774, I775 in ipairs(U1060:GetDescendants()) do
			local L1665_1 = I775.Name:lower()
			if L1665_1 == "radio" or L1665_1 == "radyo" then
				return I775
			end
		end

		for I776, I777 in ipairs(U1060:GetDescendants()) do
			local L1665_2 = I777.Name:lower()
			if L1665_2:find("radio") or L1665_2:find("radyo") then
				return I777
			end
		end

		return nil
	end

	local function F_001666()
		local U1067 = U68.Character
		local U1068 = U1067 and U1067:FindFirstChild("HumanoidRootPart")
		local U1069 = U1067 and U1067:FindFirstChildOfClass("Humanoid")
		if not U1068 then
			return
		end
		local L1666_1 = F_001665()
		local U1070 = nil

		if L1666_1 then
			local L1666_2

			if L1666_1:IsA("BasePart") then
				L1666_2 = L1666_1.CFrame
			else
				L1666_2 = nil

				if L1666_1:IsA("Model") then
					local L1666_3 = L1666_1.PrimaryPart or L1666_1:FindFirstChildWhichIsA("BasePart", true)

					if L1666_3 then
						L1666_2 = L1666_3.CFrame
					else
						local L1666_4
						L1666_2, L1666_4 = L1666_1:GetBoundingBox()
						_ = L1666_4
					end
				end
			end

			if L1666_2 then
				U1070 = L1666_2 * CFrame.new(0, -0.5, 0)
			end
		end

		U1070 = U1070 or CFrame.new(F_001651() + Vector3.new(0, 5, 0))

		pcall(function()
			if U1069 then
				U1069.Sit = false
			end

			U1067:PivotTo(U1070)
			U1068.CFrame = U1070
			U62:Notify({ Title = "Map", Description = "Teleported to the map successfully!", Duration = 3 })
		end)
	end

	local function F_001668()
		F_001659()
		F_001657()

		if U1060 then
			pcall(function()
				U1060:Destroy()
			end)

			U1060 = nil
		end
	end

	local function F_001670(A1670_1)
		if not A1670_1 then
			return
		end

		for I778, I779 in ipairs(A1670_1:GetDescendants()) do
			pcall(function()
				if I779:IsA("Script") or I779:IsA("LocalScript") or I779:IsA("ModuleScript") then
					pcall(function()
						I779.Disabled = true
					end)

					I779:Destroy()
				elseif I779:IsA("TouchTransmitter") then
					I779:Destroy()
				elseif I779:IsA("Humanoid") then
					I779.Health = 0
					I779:Destroy()
				elseif I779:IsA("BasePart") then
					I779.Anchored = true
					I779.CanTouch = false
				end
			end)
		end
	end

	local function F_001673(A1673_1)
		if not A1673_1 then
			return
		end
		local U1071 = false

		pcall(function()
			if A1673_1:IsA("Model") and A1673_1.ScaleTo then
				A1673_1:ScaleTo(1.5)
				U1071 = true
			end
		end)

		if not U1071 then
			pcall(function()
				local L1675_1 = A1673_1:GetBoundingBox().Position

				for I780, I781 in ipairs(A1673_1:GetDescendants()) do
					if I781:IsA("BasePart") then
						I781.Size = I781.Size * 1.5
						local L1675_2 = I781.CFrame.Rotation
						I781.CFrame = CFrame.new(L1675_1 + (I781.Position - L1675_1) * 1.5) * L1675_2
					end
				end
			end)
		end
	end

	local function F_001676()
		if U1061 then
			return
		end
		U1061 = true

		task.spawn(function()
			F_001668()
			task.wait(0.15)

			local L1677_1, L1677_2 = pcall(function()
				return game:GetObjects("rbxassetid://" .. U1059)[1]
			end)

			if L1677_1 and L1677_2 then
				if not L1677_2:IsA("Model") then
					local L1677_3 = Instance.new("Model")
					L1677_3.Name = "ST_CustomNAH_" .. U1059
					L1677_2.Parent = L1677_3
					U1060 = L1677_3
				else
					U1060 = L1677_2
					U1060.Name = "ST_CustomNAH_" .. U1059
				end

				if not U1060.PrimaryPart then
					local L1677_4 = U1060:FindFirstChildWhichIsA("BasePart", true)

					if L1677_4 then
						U1060.PrimaryPart = L1677_4
					end
				end

				F_001670(U1060)
				F_001673(U1060)

				for I782, I783 in ipairs(U1060:GetDescendants()) do
					if I783:IsA("BasePart") then
						I783.Anchored = true
						I783.CanTouch = false
					end
				end

				if U1060:IsA("BasePart") then
					U1060.Anchored = true
				end

				local L1677_5 = (U65.NAHAmbientVolume and U65.NAHAmbientVolume.Value or 50) / 100

				for I784, I785 in ipairs(U1060:GetDescendants()) do
					if I785:IsA("Sound") then
						I785.Volume = I785.Volume * L1677_5
					end
				end

				local L1677_6 = F_001651()

				if U1060:IsA("Model") then
					U1060:PivotTo(CFrame.new(L1677_6))
				elseif U1060:IsA("BasePart") then
					U1060.CFrame = CFrame.new(L1677_6)
				end

				U1060.Parent = U71
				F_001661()
				F_001653()

				task.spawn(function()
					task.wait(0.4)
					F_001666()
				end)
			else
				pcall(function()
					U62:Notify({ Title = "N.A.H. Error", Description = "Failed to load asset " .. U1059 .. ".", Duration = 4 })
				end)
			end

			U1061 = false
		end)
	end

	local function F_001681(A1681_1, A1681_2, A1681_3)
		task.spawn(function()
			if not A1681_1 or not A1681_2 or A1681_2 == "" then
				return
			end
			local L1682_1 = A1681_3
			local U1072

			if A1681_3 then
				U1072 = L1682_1
			else
				U1072 = "ST_NotAHuman_Preview.jpg"
			end

			local U1073 = nil

			local function F_001683(A1683_1)
				local U1074 = syn and syn.request or http and http.request or http_request or request

				if U1074 then
					local L1683_1, L1683_2 = pcall(function()
						return U1074({ Url = A1683_1, Method = "GET", Headers = { ["User-Agent"] = "Roblox/WinInet" } })
					end)

					if L1683_1 and L1683_2 and L1683_2.StatusCode == 200 and L1683_2.Body and #L1683_2.Body > 500 then
						return L1683_2.Body
					end
				end

				local L1683_3, L1683_4 = pcall(function()
					return game:HttpGet(A1683_1)
				end)

				if L1683_3 and L1683_4 and #L1683_4 > 500 then
					return L1683_4
				end
				return nil
			end

			local L1682_2 = isfile and isfile(U1072)
			local L1682_3 = true

			if L1682_2 then
				local L1682_4, L1682_5 = pcall(function()
					return readfile(U1072)
				end)

				if L1682_4 and L1682_5 and #L1682_5 > 1000 then
					L1682_3 = false
				end
			end

			if L1682_3 and writefile then
				local U1075 = F_001683(A1681_2)

				if U1075 and #U1075 > 500 then
					pcall(function()
						writefile(U1072, U1075)
					end)
				end
			end

			if isfile and isfile(U1072) and getcustomasset then
				local L1682_6, L1682_7 = pcall(function()
					return getcustomasset(U1072)
				end)

				if L1682_6 and L1682_7 then
					U1073 = L1682_7
				end
			end

			if U1073 and A1681_1 and A1681_1.Parent then
				pcall(function()
					A1681_1.Image = U1073
				end)
			end
		end)
	end

	local L0_403 = U92.Miscs:AddGroupbox({
		Side = 1,
		Name = "<b>Not A Human</b>",
		IconName = "user",
		Description = "Not A Human map settings",
		MaxPopOutHeight = 600,
		PopOutWidth = 250,
	})

	L0_403:AddDivider("Preview")
	local U1076 = L0_403:AddDependencyBox()

	pcall(function()
		local L1690_1 = Instance.new("Frame")
		L1690_1.Name = "NAHMapPreviewCard"
		L1690_1.Size = UDim2.new(1, 0, 0, 140)
		L1690_1.BackgroundColor3 = Color3.fromHex("141414")
		L1690_1.BorderSizePixel = 0
		L1690_1.ClipsDescendants = true
		L1690_1.Parent = U1076.Container
		local L1690_2 = Instance.new("UICorner")
		L1690_2.CornerRadius = UDim.new(0, 8)
		L1690_2.Parent = L1690_1
		local L1690_3 = Instance.new("UIStroke")
		L1690_3.Color = Color3.fromHex("292929")
		L1690_3.Thickness = 1
		L1690_3.Parent = L1690_1
		local L1690_4 = Instance.new("ImageLabel")
		L1690_4.Name = "PreviewImage"
		L1690_4.Size = UDim2.new(1, 0, 1, 0)
		L1690_4.BackgroundTransparency = 1
		L1690_4.ScaleType = Enum.ScaleType.Crop
		L1690_4.Parent = L1690_1
		local L1690_5 = Instance.new("Frame")
		L1690_5.Name = "GradientOverlay"
		L1690_5.Size = UDim2.new(1, 0, 0.45, 0)
		L1690_5.Position = UDim2.new(0, 0, 0.55, 0)
		L1690_5.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		L1690_5.BorderSizePixel = 0
		L1690_5.Parent = L1690_1
		local L1690_6 = Instance.new("UIGradient")
		local L1690_7 = NumberSequenceKeypoint.new
		L1690_6.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), L1690_7(1, 0.2) })
		L1690_6.Rotation = 90
		L1690_6.Parent = L1690_5
		local L1690_8 = Instance.new("TextLabel")
		L1690_8.Name = "TitleOverlay"
		L1690_8.Size = UDim2.new(1, -16, 0, 24)
		L1690_8.Position = UDim2.new(0, 10, 1, -28)
		L1690_8.BackgroundTransparency = 1
		L1690_8.Font = Enum.Font.GothamBold
		L1690_8.Text = "Not A Human"
		L1690_8.TextColor3 = Color3.fromRGB(255, 255, 255)
		L1690_8.TextSize = 13
		L1690_8.TextXAlignment = Enum.TextXAlignment.Left
		L1690_8.ZIndex = 2
		L1690_8.Parent = L1690_1
		F_001681(L1690_4, "https://adventuregamehotspot.com/images/posts/5252/29039-no-im-not-a-human-review-teaser.jpg", "ST_NotAHuman_Preview.jpg")
		U1076.Container.Visible = true
		U1076.Visible = true

		pcall(function()
			U1076:Update()
			U1076:Resize()
		end)
	end)

	local U1077 = false
	local U1078 = nil
	local U1079 = nil

	local function F_001692(A1692_1)
		if U1077 then
			return
		end
		U1077 = true
		local U1080 = game:GetService("CoreGui")
		local U1081 = Instance.new("ScreenGui")
		U1081.Name = "ST_StoryModeIntroGui"
		U1081.DisplayOrder = 999999
		U1081.IgnoreGuiInset = true
		U1081.ResetOnSpawn = false

		pcall(function()
			if syn and syn.protect_gui then
				syn.protect_gui(U1081)
			elseif gethui then
				U1081.Parent = gethui()
			else
				U1081.Parent = U1080
			end
		end)

		if not U1081.Parent then
			U1081.Parent = U1080
		end

		local U1082 = Instance.new("Frame")
		U1082.Name = "Background"
		U1082.Size = UDim2.fromScale(1, 1)
		U1082.Position = UDim2.fromScale(0, 0)
		U1082.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		U1082.BorderSizePixel = 0
		U1082.Parent = U1081
		local L1692_1 = Instance.new("Frame")
		L1692_1.Name = "CinemaFrame"
		L1692_1.Size = UDim2.fromScale(1, 1)
		L1692_1.Position = UDim2.fromScale(0.5, 0.5)
		L1692_1.AnchorPoint = Vector2.new(0.5, 0.5)
		L1692_1.BackgroundTransparency = 1
		L1692_1.Parent = U1082
		local L1692_2 = Instance.new("UIAspectRatioConstraint")
		L1692_2.AspectRatio = 1.7777777777777777
		L1692_2.AspectType = Enum.AspectType.FitWithinMaxSize
		L1692_2.DominantAxis = Enum.DominantAxis.Width
		L1692_2.Parent = L1692_1
		local U1083 = Instance.new("ImageLabel")
		U1083.Name = "VideoDisplay"
		U1083.Size = UDim2.fromScale(1, 1)
		U1083.Position = UDim2.fromScale(0.5, 0.5)
		U1083.AnchorPoint = Vector2.new(0.5, 0.5)
		U1083.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		U1083.BackgroundTransparency = 0
		U1083.BorderSizePixel = 0
		U1083.ScaleType = Enum.ScaleType.Fit
		U1083.Parent = L1692_1
		local U1084 = Instance.new("TextLabel")
		U1084.Name = "StorySubtitle"
		U1084.Size = UDim2.new(1, -60, 0, 50)
		U1084.Position = UDim2.new(0.5, 0, 1, -45)
		U1084.AnchorPoint = Vector2.new(0.5, 0.5)
		U1084.BackgroundTransparency = 1
		U1084.Font = Enum.Font.Arcade
		U1084.TextSize = 22
		U1084.TextColor3 = Color3.fromRGB(255, 255, 255)
		U1084.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
		U1084.TextStrokeTransparency = 0.2
		U1084.Text = ""
		U1084.TextWrapped = true
		U1084.ZIndex = 10
		U1084.Parent = L1692_1
		local U1085 = Instance.new("Sound")
		U1085.Name = "ST_StoryIntroSound"
		U1085.Volume = 1
		U1085.Looped = false
		U1085.Parent = game:GetService("SoundService")

		local function F_001694(A1694_1)
			if not U1077 then
				return
			end
			U1077 = false
			U1079 = nil

			if U1078 then
				pcall(function()
					task.cancel(U1078)
				end)

				U1078 = nil
			end

			pcall(function()
				U1085:Stop()
			end)

			pcall(function()
				U1085:Destroy()
			end)

			pcall(function()
				U1084.Text = ""
				U1084.Visible = false
				U1083.Visible = false
				U1082.Visible = false
				U1081.Enabled = false
				U1081.Parent = nil
				U1081:Destroy()
			end)

			if A1694_1 and A1692_1 then
				local L1694_1 = A1692_1
				A1692_1 = nil
				task.spawn(L1694_1)
			end
		end

		U1079 = F_001694

		U1085.Ended:Connect(function()
			if U1077 and U1085.TimePosition >= 70 then
				F_001694(true)
			end
		end)

		U1078 = task.spawn(function()
			task.spawn(function()
				local L1701_1 = os.clock()

				for I786, I787 in ipairs({
					{ time = 10, dur = 2, text = "A long time has passed." },
					{ time = 15, dur = 2, text = "and i still cant forget" },
					{ time = 19, dur = 2, text = "that i messed up everything" },
					{ time = 28, dur = 2, text = "i am a fucking loser" },
					{ time = 32, dur = 2, text = "how can i fix this?" },
					{ time = 34, dur = 2, text = "right?" },
					{ time = 43, dur = 2, text = "i still cant forget her" },
					{ time = 49, dur = 3, text = "does she even know that i exist" },
					{ time = 60, dur = 3, text = "but what you can do about it?" },
					{ time = 66, dur = 4, text = "the world keeps spinning on its axis" },
				}) do
					local L1701_2 = L1701_1 + I787.time - os.clock()

					if L1701_2 > 0 then
						task.wait(L1701_2)
					end

					if not (not U1077 or not U1081.Parent) then
						U1084.Text = I787.text
						task.wait(I787.dur or 2)

						if not (not U1077 or not U1081.Parent) then
							if U1084.Text == I787.text then
								U1084.Text = ""
							end

							continue
						end
					end

					break
				end
			end)

			local U1086 = {
				{ url = "https://files.catbox.moe/qlcz6o.jpg", file = "ST_Scene_1.jpg", dur = 2.25 },
				{ url = "https://files.catbox.moe/b4v4h0.jpg", file = "ST_Scene_2.jpg", dur = 4 },
				{ url = "https://files.catbox.moe/q6jp61.jpg", file = "ST_Scene_3.jpg", dur = 4 },
				{ url = "https://files.catbox.moe/3v5at5.jpg", file = "ST_Scene_4.jpg", dur = 1.75 },
				{ url = "https://files.catbox.moe/b53417.jpg", file = "ST_Scene_5.jpg", dur = 6 },
				{ url = "https://files.catbox.moe/gamc6e.jpg", file = "ST_Scene_6.jpg", dur = 4 },
				{ url = "https://files.catbox.moe/tu8gff.jpg", file = "ST_Scene_7.jpg", dur = 4.75 },
				{ url = "https://files.catbox.moe/ls9tyz.jpg", file = "ST_Scene_8.jpg", dur = 1.25 },
				{ url = "https://files.catbox.moe/28rvyl.jpg", file = "ST_Scene_9.jpg", dur = 6 },
				{ url = "https://files.catbox.moe/xxpd7z.jpg", file = "ST_Scene_10.jpg", dur = 4 },
				{ url = "https://files.catbox.moe/0wevaj.jpg", file = "ST_Scene_11.jpg", dur = 4.75 },
				{ url = "https://files.catbox.moe/y92v4l.jpg", file = "ST_Scene_12.jpg", dur = 4.25 },
				{ url = "https://files.catbox.moe/7v34ly.jpg", file = "ST_Scene_13.jpg", dur = 4 },
				{ url = "https://files.catbox.moe/s1ywz2.jpg", file = "ST_Scene_14.jpg", dur = 3 },
				{ url = "https://files.catbox.moe/6m73a2.jpg", file = "ST_Scene_15.jpg", dur = 4.75 },
				{ url = "https://files.catbox.moe/owrsdo.jpg", file = "ST_Scene_16.jpg", dur = 13.75 },
			}

			local function F_001702(A1702_1)
				local U1087 = syn and syn.request or http and http.request or http_request or request

				if U1087 then
					local L1702_1, L1702_2 = pcall(function()
						return U1087({ Url = A1702_1, Method = "GET", Headers = { ["User-Agent"] = "Roblox/WinInet" } })
					end)

					if L1702_1 and L1702_2 and (L1702_2.StatusCode == 200 or L1702_2.Status == 200) and L1702_2.Body and #L1702_2.Body > 500 then
						return L1702_2.Body
					end
				end

				local L1702_3, L1702_4 = pcall(function()
					return game:HttpGet(A1702_1)
				end)

				if L1702_3 and L1702_4 and #L1702_4 > 500 then
					return L1702_4
				end
				return nil
			end

			local function F_001705(A1705_1, A1705_2)
				if not (writefile and getcustomasset) then
					return A1705_1
				end

				if isfile and isfile(A1705_2) then
					local L1705_1, L1705_2 = pcall(function()
						return getcustomasset(A1705_2)
					end)

					if L1705_1 and L1705_2 then
						return L1705_2
					end
				end

				local U1088 = F_001702(A1705_1)

				if U1088 and #U1088 > 500 then
					pcall(function()
						writefile(A1705_2, U1088)
					end)

					if isfile and isfile(A1705_2) then
						local L1705_3, L1705_4 = pcall(function()
							return getcustomasset(A1705_2)
						end)

						if L1705_3 and L1705_4 then
							return L1705_4
						end
					end
				end

				return A1705_1
			end

			task.spawn(function()
				local L1709_1 = F_001705("https://files.catbox.moe/zt82r3.mp3", "ST_Story_Intro.mp3")

				if L1709_1 and U1085 and U1085.Parent then
					U1085.SoundId = L1709_1
					U1085:Play()
				end
			end)

			U1083.ImageRectSize = Vector2.new(0, 0)
			U1083.ImageRectOffset = Vector2.new(0, 0)
			U1083.ScaleType = Enum.ScaleType.Fit
			local U1089 = { (F_001705(U1086[1].url, U1086[1].file)) }

			if U1089[1] then
				U1083.Image = U1089[1]
			end

			task.spawn(function()
				for I788 = 2, #U1086 do
					if U1077 then
						U1089[I788] = F_001705(U1086[I788].url, U1086[I788].file)
						continue
					end
					break
				end
			end)

			for I789 = 1, #U1086 do
				if not (not U1077 or not U1081.Parent) then
					local L1700_1 = U1089[I789]

					if not L1700_1 then
						L1700_1 = F_001705(U1086[I789].url, U1086[I789].file)
						U1089[I789] = L1700_1
					end

					if L1700_1 and L1700_1 ~= "" and U1083.Image ~= L1700_1 then
						U1083.Image = L1700_1
					end

					task.wait(U1086[I789].dur or 4)
					continue
				end

				break
			end

			F_001694(true)
		end)
	end

	L0_403:AddDivider()

	L0_403:AddToggle("EnableNAH", {
		Text = "Story Mode",
		Tooltip = "Play Story Mode intro and enter Not A Human map",
		Default = false,
		Callback = function(A1711_1)
			if A1711_1 then
				F_001692(function()
					F_001676()

					pcall(function()
						if U66.NoClip and U66.NoClip.SetValue then
							U66.NoClip:SetValue(true)
						end
					end)
				end)
			else
				if U1079 then
					U1079(false)
				end

				F_001668()

				pcall(function()
					if U66.NoClip and U66.NoClip.SetValue then
						U66.NoClip:SetValue(false)
					end
				end)
			end
		end,
	})

	L0_403:AddButton({
		Text = "Teleport to N.A.H.",
		Func = function()
			F_001666()
		end,
		DoubleClick = false,
	})

	L0_403:AddDivider("N.A.H. Settings")

	L0_403:AddButton({
		Text = "Enable N.A.H. Map",
		Func = function()
			if U1060 and U1060.Parent then
				F_001668()

				pcall(function()
					if U66.NoClip and U66.NoClip.SetValue then
						U66.NoClip:SetValue(false)
					end
				end)
			else
				F_001676()

				pcall(function()
					if U66.NoClip and U66.NoClip.SetValue then
						U66.NoClip:SetValue(true)
					end
				end)
			end
		end,
		DoubleClick = false,
	})

	L0_403:AddSlider("NAHAmbientVolume", {
		Text = "Ambient Volume",
		Default = 50,
		Min = 0,
		Max = 100,
		Rounding = 0,
		Suffix = "%",
		Compact = true,
		Callback = function(A1719_1)
			local L1719_1 = A1719_1 / 100 * 5

			if U1063 and U1063.Parent then
				U1063.Volume = L1719_1
			end

			if U1060 and U1060.Parent then
				for I790, I791 in ipairs(U1060:GetDescendants()) do
					if I791:IsA("Sound") and I791 ~= U1063 then
						I791.Volume = L1719_1
					end
				end
			end
		end,
	})

	L0_403:AddDivider("XYZ")

	L0_403:AddSlider("NAHOffsetX", {
		Text = "Offset X",
		Default = 0,
		Min = -10000,
		Max = 10000,
		Rounding = 0,
		Compact = true,
		Callback = function(A1720_1)
			U1062.X = A1720_1
			U1064()
		end,
	})

	L0_403:AddSlider("NAHOffsetY", {
		Text = "Offset Y",
		Default = 0,
		Min = -10000,
		Max = 10000,
		Rounding = 0,
		Compact = true,
		Callback = function(A1721_1)
			U1062.Y = A1721_1
			U1064()
		end,
	})

	L0_403:AddSlider("NAHOffsetZ", {
		Text = "Offset Z",
		Default = 0,
		Min = -10000,
		Max = 10000,
		Rounding = 0,
		Compact = true,
		Callback = function(A1722_1)
			U1062.Z = A1722_1
			U1064()
		end,
	})
end

local L0_404

L0_404 = U92.Miscs:AddGroupbox({
	Side = 2,
	Name = "<b>Map</b>",
	IconName = "eclipse",
	Description = "Custom map, skies, shaders and water",
	MaxPopOutHeight = 600,
	PopOutWidth = 250,
}):AddTabbox({ MaxPopOutHeight = 600 })

local L0_405
L0_405 = L0_404:AddTab("<b>Custom Map</b>", "parasol")
L0_405:AddDivider()
local U1090
U1090 = false

task.defer(function()
	task.wait(1.5)
	U1090 = true
end)

do
	local U1091 = {
		Ambient = Lighting.Ambient,
		OutdoorAmbient = Lighting.OutdoorAmbient,
		GlobalShadows = Lighting.GlobalShadows,
		Brightness = Lighting.Brightness,
		ClockTime = Lighting.ClockTime,
		FogEnd = Lighting.FogEnd,
		FogStart = Lighting.FogStart,
		FogColor = Lighting.FogColor,
	}

	local function F_001724(A1724_1)
		for I792, I793 in pairs(Lighting:GetChildren()) do
			if I793:IsA("PostEffect") or I793:IsA("Sky") or I793:IsA("Atmosphere") then
				I793:Destroy()
			end
		end

		Lighting.Brightness = 2
		Lighting.ExposureCompensation = 0
		Lighting.ClockTime = 14
		Lighting.ColorShift_Bottom = Color3.fromRGB(0, 0, 0)
		Lighting.ColorShift_Top = Color3.fromRGB(0, 0, 0)
		Lighting.OutdoorAmbient = Color3.fromRGB(200, 200, 200)
		Lighting.FogColor = Color3.fromRGB(192, 192, 192)
		Lighting.FogEnd = 100000
		Lighting.FogStart = 0
		Lighting.ShadowSoftness = 0
		Lighting.Ambient = Color3.fromRGB(120, 120, 120)

		if A1724_1 == "Classic" then
			local L1724_1 = Instance.new("Sky", Lighting)
			L1724_1.Name = "ST_Shader_Sky"
			L1724_1.StarCount = 5000
			L1724_1.SunAngularSize = 5
			local L1724_2 = Instance.new("BloomEffect", Lighting)
			L1724_2.Intensity = 0.3
			L1724_2.Size = 10
			L1724_2.Threshold = 0.8
			Instance.new("BlurEffect", Lighting).Size = 5
			local L1724_3 = Instance.new("ColorCorrectionEffect", Lighting)
			L1724_3.Brightness = 0
			L1724_3.Contrast = 0.1
			L1724_3.Saturation = 0.25
			L1724_3.TintColor = Color3.fromRGB(255, 255, 255)
			local L1724_4 = Instance.new("SunRaysEffect", Lighting)
			L1724_4.Intensity = 0.1
			L1724_4.Spread = 0.8
			Lighting.Brightness = 2.25
			Lighting.ExposureCompensation = 0.1
			Lighting.ClockTime = 17.55
		elseif A1724_1 == "Twilight" then
			local L1724_5 = Instance.new("BloomEffect", Lighting)
			L1724_5.Intensity = 0.1
			L1724_5.Threshold = 0
			L1724_5.Size = 100
			local L1724_6 = Instance.new("Sky", Lighting)
			L1724_6.Name = "ST_Shader_Sky"
			L1724_6.SkyboxUp = "rbxassetid://323493360"
			L1724_6.SkyboxLf = "rbxassetid://323494252"
			L1724_6.SkyboxBk = "rbxassetid://323494035"
			L1724_6.SkyboxFt = "rbxassetid://323494130"
			L1724_6.SkyboxDn = "rbxassetid://323494368"
			L1724_6.SunAngularSize = 14
			L1724_6.SkyboxRt = "rbxassetid://323494067"
			local L1724_7 = Instance.new("ColorCorrectionEffect", Lighting)
			L1724_7.Saturation = 0.05
			L1724_7.TintColor = Color3.fromRGB(255, 224, 219)
			Instance.new("SunRaysEffect", Lighting).Intensity = 0.05
			Lighting.Brightness = 3.5
			Lighting.ColorShift_Bottom = Color3.fromRGB(11, 0, 20)
			Lighting.ColorShift_Top = Color3.fromRGB(240, 127, 14)
			Lighting.OutdoorAmbient = Color3.fromRGB(34, 0, 49)
			Lighting.ClockTime = 6.7
			Lighting.FogColor = Color3.fromRGB(94, 76, 106)
			Lighting.FogEnd = 1000
			Lighting.ExposureCompensation = 0.24
			Lighting.Ambient = Color3.fromRGB(59, 33, 27)
		elseif A1724_1 == "Luminous" then
			local L1724_8 = Instance.new("BloomEffect", Lighting)
			L1724_8.Intensity = 0.1
			L1724_8.Threshold = 0
			L1724_8.Size = 100
			local L1724_9 = Instance.new("Sky", Lighting)
			L1724_9.Name = "ST_Shader_Sky"
			L1724_9.SkyboxUp = "rbxassetid://323493360"
			L1724_9.SkyboxLf = "rbxassetid://323494252"
			L1724_9.SkyboxBk = "rbxassetid://323494035"
			L1724_9.SkyboxFt = "rbxassetid://323494130"
			L1724_9.SkyboxDn = "rbxassetid://323494368"
			L1724_9.SunAngularSize = 14
			L1724_9.SkyboxRt = "rbxassetid://323494067"
			Lighting.Brightness = 2
			Lighting.ColorShift_Bottom = Color3.fromRGB(250, 250, 250)
			Lighting.ColorShift_Top = Color3.fromRGB(250, 250, 250)
			Lighting.OutdoorAmbient = Color3.fromRGB(150, 150, 150)
			Lighting.ClockTime = 10
			Lighting.FogColor = Color3.fromRGB(20, 20, 20)
			Lighting.FogEnd = 10000
			Lighting.ExposureCompensation = 0.5
			Lighting.Ambient = Color3.fromRGB(50, 50, 50)
		elseif A1724_1 == "Sandstorm" then
			local L1724_10 = Instance.new("BloomEffect", Lighting)
			L1724_10.Intensity = 0.1
			L1724_10.Threshold = 0
			L1724_10.Size = 100
			local L1724_11 = Instance.new("Sky", Lighting)
			L1724_11.Name = "ST_Shader_Sky"
			L1724_11.SkyboxUp = "rbxassetid://323493360"
			L1724_11.SkyboxLf = "rbxassetid://323494252"
			L1724_11.SkyboxBk = "rbxassetid://323494035"
			L1724_11.SkyboxFt = "rbxassetid://323494130"
			L1724_11.SkyboxDn = "rbxassetid://323494368"
			L1724_11.SunAngularSize = 14
			L1724_11.SkyboxRt = "rbxassetid://323494067"
			Lighting.Brightness = 2.5
			Lighting.ColorShift_Bottom = Color3.fromRGB(240, 120, 20)
			Lighting.ColorShift_Top = Color3.fromRGB(240, 127, 14)
			Lighting.OutdoorAmbient = Color3.fromRGB(100, 50, 10)
			Lighting.ClockTime = 7
			Lighting.FogColor = Color3.fromRGB(100, 55, 20)
			Lighting.FogEnd = 1000
			Lighting.ExposureCompensation = 0.5
			Lighting.Ambient = Color3.fromRGB(80, 40, 10)
		elseif A1724_1 == "Arctic" then
			local L1724_12 = Instance.new("ColorCorrectionEffect", Lighting)
			L1724_12.Saturation = -0.3
			L1724_12.Contrast = 0.2
			L1724_12.TintColor = Color3.fromRGB(220, 240, 255)
			local L1724_13 = Instance.new("BloomEffect", Lighting)
			L1724_13.Intensity = 0.8
			L1724_13.Size = 24
			L1724_13.Threshold = 0.6
			local L1724_14 = Instance.new("Atmosphere", Lighting)
			L1724_14.Density = 0.45
			L1724_14.Color = Color3.fromRGB(180, 200, 255)
			L1724_14.Decay = Color3.fromRGB(255, 255, 255)
			L1724_14.Glare = 0.6
			Lighting.Ambient = Color3.fromRGB(0, 50, 100)
			Lighting.OutdoorAmbient = Color3.fromRGB(150, 170, 200)
			Lighting.GlobalShadows = true
		end
	end

	local function F_001725()
		for I794, I795 in pairs(Lighting:GetChildren()) do
			if (I795:IsA("PostEffect") or I795:IsA("Sky") or I795:IsA("Atmosphere")) and I795.Name:find("ST_") then
				pcall(function()
					I795:Destroy()
				end)
			end
		end

		Lighting.Brightness = U1091.Brightness or 2
		Lighting.ExposureCompensation = 0
		Lighting.ClockTime = U1091.ClockTime or 14
		Lighting.ColorShift_Bottom = Color3.fromRGB(0, 0, 0)
		Lighting.ColorShift_Top = Color3.fromRGB(0, 0, 0)
		Lighting.OutdoorAmbient = U1091.OutdoorAmbient or Color3.fromRGB(200, 200, 200)
		Lighting.FogColor = U1091.FogColor or Color3.fromRGB(192, 192, 192)
		Lighting.FogEnd = U1091.FogEnd or 100000
		Lighting.FogStart = U1091.FogStart or 0
		Lighting.ShadowSoftness = 0
		Lighting.Ambient = U1091.Ambient or Color3.fromRGB(120, 120, 120)
		Lighting.GlobalShadows = U1091.GlobalShadows ~= nil and U1091.GlobalShadows or true
	end

	L0_405:AddDropdown("SelectShader", {
		Values = { "Classic", "Twilight", "Luminous", "Sandstorm", "Arctic" },
		Default = "Twilight",
		Text = "Select Shader",
		ValueImages = {
			Classic = "sparkles",
			Twilight = "sunset",
			Luminous = "sun-medium",
			Sandstorm = "wind",
			Arctic = "snowflake",
		},
		Callback = function(A1727_1)
			if U66.EnableShader and U66.EnableShader.Value then
				F_001724(A1727_1)
			end
		end,
	})

	L0_405:AddToggle("EnableShader", {
		Text = "Enable Shader",
		Default = false,
		Callback = function(A1728_1)
			if not U1090 then
				return
			end

			if A1728_1 then
				F_001724(U65.SelectShader and U65.SelectShader.Value or "Twilight")
			else
				F_001725()
			end
		end,
	})
end

L0_405:AddDivider("Sky")

do
	local U1092 = {
		["Arctic Horizon"] = {
			Bk = "http://www.roblox.com/asset/?id=225469390",
			Dn = "http://www.roblox.com/asset/?id=225469395",
			Ft = "http://www.roblox.com/asset/?id=225469403",
			Lf = "http://www.roblox.com/asset/?id=225469450",
			Rt = "http://www.roblox.com/asset/?id=225469471",
			Up = "http://www.roblox.com/asset/?id=225469481",
		},
		["Black Tempest"] = {
			Bk = "rbxassetid://15502511288",
			Dn = "rbxassetid://15502508460",
			Ft = "rbxassetid://15502510289",
			Lf = "rbxassetid://15502507918",
			Rt = "rbxassetid://15502509398",
			Up = "rbxassetid://15502511911",
		},
		["Blossom Morning"] = {
			Bk = "http://www.roblox.com/asset/?id=271042516",
			Dn = "http://www.roblox.com/asset/?id=271077243",
			Ft = "http://www.roblox.com/asset/?id=271042556",
			Lf = "http://www.roblox.com/asset/?id=271042310",
			Rt = "http://www.roblox.com/asset/?id=271042467",
			Up = "http://www.roblox.com/asset/?id=271077958",
		},
		["Blue Cosmos"] = {
			Bk = "rbxassetid://15536110634",
			Dn = "rbxassetid://15536112543",
			Ft = "rbxassetid://15536116141",
			Lf = "rbxassetid://15536114370",
			Rt = "rbxassetid://15536118762",
			Up = "rbxassetid://15536117282",
		},
		["Blue Nebula"] = {
			Bk = "http://www.roblox.com/asset?id=135207744",
			Dn = "http://www.roblox.com/asset?id=135207662",
			Ft = "http://www.roblox.com/asset?id=135207770",
			Lf = "http://www.roblox.com/asset?id=135207615",
			Rt = "http://www.roblox.com/asset?id=135207695",
			Up = "http://www.roblox.com/asset?id=135207794",
		},
		["Blue Planet"] = {
			Bk = "rbxassetid://218955819",
			Dn = "rbxassetid://218953419",
			Ft = "rbxassetid://218954524",
			Lf = "rbxassetid://218958493",
			Rt = "rbxassetid://218957134",
			Up = "rbxassetid://218950090",
		},
		["Midnight Blue"] = {
			Bk = "http://www.roblox.com/asset/?id=12064107",
			Dn = "http://www.roblox.com/asset/?id=12064152",
			Ft = "http://www.roblox.com/asset/?id=12064121",
			Lf = "http://www.roblox.com/asset/?id=12063984",
			Rt = "http://www.roblox.com/asset/?id=12064115",
			Up = "http://www.roblox.com/asset/?id=12064131",
		},
		["Stormfront Rain"] = {
			Bk = "http://www.roblox.com/asset/?id=4498828382",
			Dn = "http://www.roblox.com/asset/?id=4498828812",
			Ft = "http://www.roblox.com/asset/?id=4498829917",
			Lf = "http://www.roblox.com/asset/?id=4498830911",
			Rt = "http://www.roblox.com/asset/?id=4498830417",
			Up = "http://www.roblox.com/asset/?id=4498831746",
		},
		["Dark Rainstorm"] = {
			Bk = "http://www.roblox.com/asset/?id=149679669",
			Dn = "http://www.roblox.com/asset/?id=149681979",
			Ft = "http://www.roblox.com/asset/?id=149679690",
			Lf = "http://www.roblox.com/asset/?id=149679709",
			Rt = "http://www.roblox.com/asset/?id=149679722",
			Up = "http://www.roblox.com/asset/?id=149680199",
		},
		["Cosmic Rift"] = {
			Bk = "http://www.roblox.com/asset/?id=149397692",
			Dn = "http://www.roblox.com/asset/?id=149397686",
			Ft = "http://www.roblox.com/asset/?id=149397697",
			Lf = "http://www.roblox.com/asset/?id=149397684",
			Rt = "http://www.roblox.com/asset/?id=149397688",
			Up = "http://www.roblox.com/asset/?id=149397702",
		},
		["Celestial Abyss"] = {
			Bk = "http://www.roblox.com/asset/?id=159248188",
			Dn = "http://www.roblox.com/asset/?id=159248183",
			Ft = "http://www.roblox.com/asset/?id=159248187",
			Lf = "http://www.roblox.com/asset/?id=159248173",
			Rt = "http://www.roblox.com/asset/?id=159248192",
			Up = "http://www.roblox.com/asset/?id=159248176",
		},
		["Galaxy Core"] = {
			Bk = "rbxassetid://15983968922",
			Dn = "rbxassetid://15983966825",
			Ft = "rbxassetid://15983965025",
			Lf = "rbxassetid://15983967420",
			Rt = "rbxassetid://15983966246",
			Up = "rbxassetid://15983964246",
		},
		["Ultra HD"] = {
			Bk = "http://www.roblox.com/asset/?id=16553658937",
			Dn = "http://www.roblox.com/asset/?id=16553660713",
			Ft = "http://www.roblox.com/asset/?id=16553662144",
			Lf = "http://www.roblox.com/asset/?id=16553664042",
			Rt = "http://www.roblox.com/asset/?id=16553665766",
			Up = "http://www.roblox.com/asset/?id=16553667750",
		},
		["Pixel Craft"] = {
			Bk = "rbxassetid://8735166756",
			Dn = "http://www.roblox.com/asset/?id=8735166707",
			Ft = "http://www.roblox.com/asset/?id=8735231668",
			Lf = "http://www.roblox.com/asset/?id=8735166755",
			Rt = "http://www.roblox.com/asset/?id=8735166751",
			Up = "http://www.roblox.com/asset/?id=8735166729",
		},
		["Cotton Candy"] = {
			Bk = "rbxassetid://12216109205",
			Dn = "rbxassetid://12216109875",
			Ft = "rbxassetid://12216109489",
			Lf = "rbxassetid://12216110170",
			Rt = "rbxassetid://12216110471",
			Up = "rbxassetid://12216108877",
		},
		["Pink Horizon"] = {
			Bk = "http://www.roblox.com/asset/?id=151165214",
			Dn = "http://www.roblox.com/asset/?id=151165197",
			Ft = "http://www.roblox.com/asset/?id=151165224",
			Lf = "http://www.roblox.com/asset/?id=151165191",
			Rt = "http://www.roblox.com/asset/?id=151165206",
			Up = "http://www.roblox.com/asset/?id=151165227",
		},
		["Amethyst Dusk"] = {
			Bk = "rbxassetid://264908339",
			Dn = "rbxassetid://264907909",
			Ft = "rbxassetid://264909420",
			Lf = "rbxassetid://264909758",
			Rt = "rbxassetid://264908886",
			Up = "rbxassetid://264907379",
		},
		["Crimson Night"] = {
			Bk = "http://www.roblox.com/asset/?id=401664839",
			Dn = "http://www.roblox.com/asset/?id=401664862",
			Ft = "http://www.roblox.com/asset/?id=401664960",
			Lf = "http://www.roblox.com/asset/?id=401664881",
			Rt = "http://www.roblox.com/asset/?id=401664901",
			Up = "http://www.roblox.com/asset/?id=401664936",
		},
		["True Vision"] = {
			Bk = "rbxassetid://653719502",
			Dn = "rbxassetid://653718790",
			Ft = "rbxassetid://653719067",
			Lf = "rbxassetid://653719190",
			Rt = "rbxassetid://653718931",
			Up = "rbxassetid://653719321",
		},
		["Default Roblox"] = {
			Bk = "rbxasset://textures/sky/sky512_bk.tex",
			Dn = "rbxasset://textures/sky/sky512_dn.tex",
			Ft = "rbxasset://textures/sky/sky512_ft.tex",
			Lf = "rbxasset://textures/sky/sky512_lf.tex",
			Rt = "rbxasset://textures/sky/sky512_rt.tex",
			Up = "rbxasset://textures/sky/sky512_up.tex",
		},
		["Outer Space"] = {
			Bk = "http://www.roblox.com/asset/?id=166509999",
			Dn = "http://www.roblox.com/asset/?id=166510057",
			Ft = "http://www.roblox.com/asset/?id=166510116",
			Lf = "http://www.roblox.com/asset/?id=166510092",
			Rt = "http://www.roblox.com/asset/?id=166510131",
			Up = "http://www.roblox.com/asset/?id=166510114",
		},
		["Summer Glow"] = {
			Bk = "rbxassetid://16648590964",
			Dn = "rbxassetid://16648617436",
			Ft = "rbxassetid://16648595424",
			Lf = "rbxassetid://16648566370",
			Rt = "rbxassetid://16648577071",
			Up = "rbxassetid://16648598180",
		},
		["Stylized Dream"] = {
			Bk = "rbxassetid://18351376859",
			Dn = "rbxassetid://18351374919",
			Ft = "rbxassetid://18351376800",
			Lf = "rbxassetid://18351376469",
			Rt = "rbxassetid://18351376457",
			Up = "rbxassetid://18351377189",
		},
		["Golden Sunset"] = {
			Bk = "rbxassetid://600830446",
			Dn = "rbxassetid://600831635",
			Ft = "rbxassetid://600832720",
			Lf = "rbxassetid://600886090",
			Rt = "rbxassetid://600833862",
			Up = "rbxassetid://600835177",
		},
		Thunderhead = {
			Bk = "http://www.roblox.com/asset/?id=18703245834",
			Dn = "http://www.roblox.com/asset/?id=18703243349",
			Ft = "http://www.roblox.com/asset/?id=18703240532",
			Lf = "http://www.roblox.com/asset/?id=18703237556",
			Rt = "http://www.roblox.com/asset/?id=18703235430",
			Up = "http://www.roblox.com/asset/?id=18703232671",
		},
		["Winter Frost"] = {
			Bk = "http://www.roblox.com/asset/?id=155657655",
			Dn = "http://www.roblox.com/asset/?id=155674246",
			Ft = "http://www.roblox.com/asset/?id=155657609",
			Lf = "http://www.roblox.com/asset/?id=155657671",
			Rt = "http://www.roblox.com/asset/?id=155657619",
			Up = "http://www.roblox.com/asset/?id=155674931",
		},
	}

	local U1093 = nil

	local function F_001729(A1729_1)
		local L1729_1 = U1092[A1729_1]
		if not L1729_1 then
			return
		end

		if U1093 then
			pcall(function()
				U1093:Destroy()
			end)

			U1093 = nil
		end

		local L1729_2 = Instance.new("Sky")
		L1729_2.Name = "ST_CustomSky"
		L1729_2.SkyboxBk = L1729_1.Bk
		L1729_2.SkyboxDn = L1729_1.Dn
		L1729_2.SkyboxFt = L1729_1.Ft
		L1729_2.SkyboxLf = L1729_1.Lf
		L1729_2.SkyboxRt = L1729_1.Rt
		L1729_2.SkyboxUp = L1729_1.Up
		L1729_2.Parent = Lighting
		U1093 = L1729_2
	end

	local function F_001731()
		if U1093 then
			pcall(function()
				U1093:Destroy()
			end)

			U1093 = nil
		end
	end

	L0_405:AddDropdown("SelectSkybox", {
		Values = {
			"Arctic Horizon",
			"Black Tempest",
			"Blossom Morning",
			"Blue Cosmos",
			"Blue Nebula",
			"Blue Planet",
			"Midnight Blue",
			"Stormfront Rain",
			"Dark Rainstorm",
			"Cosmic Rift",
			"Celestial Abyss",
			"Galaxy Core",
			"Ultra HD",
			"Pixel Craft",
			"Cotton Candy",
			"Pink Horizon",
			"Amethyst Dusk",
			"Crimson Night",
			"True Vision",
			"Default Roblox",
			"Outer Space",
			"Summer Glow",
			"Stylized Dream",
			"Golden Sunset",
			"Thunderhead",
			"Winter Frost",
		},
		Default = "Arctic Horizon",
		Text = "Select Skybox",
		ValueImages = {
			["Arctic Horizon"] = "snowflake",
			["Black Tempest"] = "cloud-lightning",
			["Blossom Morning"] = "flower-2",
			["Blue Cosmos"] = "orbit",
			["Blue Nebula"] = "sparkles",
			["Blue Planet"] = "globe",
			["Midnight Blue"] = "moon",
			["Stormfront Rain"] = "cloud-rain",
			["Dark Rainstorm"] = "cloud-drizzle",
			["Cosmic Rift"] = "zap",
			["Celestial Abyss"] = "eye",
			["Galaxy Core"] = "sun",
			["Ultra HD"] = "tv",
			["Pixel Craft"] = "box",
			["Cotton Candy"] = "cloud",
			["Pink Horizon"] = "sunrise",
			["Amethyst Dusk"] = "gem",
			["Crimson Night"] = "flame",
			["True Vision"] = "compass",
			["Default Roblox"] = "home",
			["Outer Space"] = "telescope",
			["Summer Glow"] = "sun-medium",
			["Stylized Dream"] = "palette",
			["Golden Sunset"] = "sunset",
			Thunderhead = "cloud-lightning",
			["Winter Frost"] = "thermometer-snowflake",
		},
		Callback = function(A1733_1)
			if U66.CustomSkybox and U66.CustomSkybox.Value then
				F_001729(A1733_1)
			end
		end,
	})

	L0_405:AddToggle("CustomSkybox", {
		Text = "Custom Skybox",
		Default = false,
		Callback = function(A1734_1)
			if not U1090 then
				return
			end

			if A1734_1 then
				F_001729(U65.SelectSkybox and U65.SelectSkybox.Value or "Arctic Horizon")
			else
				F_001731()
			end
		end,
	})
end

L0_405:AddDivider("Water")

do
	local U1094 = nil

	local function F_001735()
		if U1094 then
			return U1094
		end
		local U1095 = {}

		pcall(function()
			for I796, I797 in ipairs(workspace.Map.AlwaysHereTweenedObjects.Ocean.Object.ObjectModel:GetDescendants()) do
				if I797:IsA("BasePart") then
					table.insert(U1095, I797)
				end
			end
		end)

		U1094 = U1095
		return U1095
	end

	local function F_001737(A1737_1)
		local U1096 = Enum.Material[A1737_1]
		if not U1096 then
			return
		end

		for I798, I799 in ipairs(F_001735()) do
			pcall(function()
				I799.Material = U1096
			end)
		end
	end

	local function F_001739(A1739_1)
		for I800, I801 in ipairs(F_001735()) do
			pcall(function()
				I801.Color = A1739_1
			end)
		end
	end

	L0_405:AddDropdown("WaterMaterial", {
		Text = "Material",
		Values = {
			"Water",
			"Glass",
			"Neon",
			"SmoothPlastic",
			"Ice",
			"Sand",
			"Rock",
			"Basalt",
			"Slate",
			"Mud",
			"Cobblestone",
		},
		Default = "Water",
		ValueImages = {
			Water = "droplet",
			Glass = "square",
			Neon = "zap",
			SmoothPlastic = "layers",
			Ice = "snowflake",
			Sand = "footprints",
			Rock = "mountain",
			Basalt = "stone",
			Slate = "file",
			Mud = "waves",
			Cobblestone = "grid-2x2",
		},
		Callback = function(A1741_1)
			F_001737(A1741_1)
		end,
	})

	L0_405:AddDivider()

	L0_405:AddToggle("CustomWaterColor", {
		Text = "Custom Water Color",
		Default = false,
		Callback = function(A1742_1)
			if A1742_1 then
				F_001739(U65.WaterColorPicker and U65.WaterColorPicker.Value or Color3.fromRGB(0, 170, 255))
			end
		end,
	}):AddColorPicker("WaterColorPicker", {
		Default = Color3.fromRGB(0, 170, 255),
		Title = "Water Color",
		Callback = function(A1743_1)
			if U66.CustomWaterColor and U66.CustomWaterColor.Value then
				F_001739(A1743_1)
			end
		end,
	})
end

L0_405:AddToggle("RealisticWater", {
	Text = "Realistic Water",
	Default = false,
	Callback = function(A1744_1)
		if A1744_1 then
			pcall(function()
				local L1745_1 = workspace.Terrain

				for I802, I803 in ipairs(workspace.Map.AlwaysHereTweenedObjects.Ocean.Object.ObjectModel:GetChildren()) do
					if I803:IsA("Part") then
						local L1745_2 = I803.Size
						local L1745_3 = I803.CFrame
						L1745_1:FillRegion(Region3.new(L1745_3.Position - L1745_2 / 2, L1745_3.Position + L1745_2 / 2):ExpandToGrid(4), 4, Enum.Material.Water)
						I803:Destroy()
					end
				end
			end)
		end
	end,
})

do
	local L0_406 = L0_404:AddTab("<b>Settings</b>", "settings")
	L0_406:AddDivider("Settings")

	local U1097 = {
		Ambient = Lighting.Ambient,
		OutdoorAmbient = Lighting.OutdoorAmbient,
		Brightness = Lighting.Brightness,
		ClockTime = Lighting.ClockTime,
		FogEnd = Lighting.FogEnd,
		FogStart = Lighting.FogStart,
		FogColor = Lighting.FogColor,
		GlobalShadows = Lighting.GlobalShadows,
		ColorShift_Bottom = Lighting.ColorShift_Bottom,
		ColorShift_Top = Lighting.ColorShift_Top,
		ExposureCompensation = Lighting.ExposureCompensation,
	}

	local function F_001746(A1746_1, A1746_2)
		local L1746_1 = U70:Create(Lighting, TweenInfo.new(A1746_2 or 0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), A1746_1)
		L1746_1:Play()
		return L1746_1
	end

	local U1098 = {
		Default = function()
			F_001746({
				Ambient = U1097.Ambient,
				OutdoorAmbient = U1097.OutdoorAmbient,
				Brightness = U1097.Brightness,
				ClockTime = U1097.ClockTime,
				FogEnd = U1097.FogEnd,
				FogColor = U1097.FogColor,
			}, 0.8)

			Lighting.ColorShift_Top = U1097.ColorShift_Top
			Lighting.ColorShift_Bottom = U1097.ColorShift_Bottom
		end,
		Midnight = function()
			F_001746({
				Ambient = Color3.fromRGB(5, 5, 15),
				OutdoorAmbient = Color3.fromRGB(8, 8, 25),
				Brightness = 0.5,
				ClockTime = 0,
				FogEnd = 400,
				FogColor = Color3.fromRGB(5, 5, 20),
			}, 0.8)
		end,
		GoldenHour = function()
			F_001746({
				Ambient = Color3.fromRGB(90, 60, 30),
				OutdoorAmbient = Color3.fromRGB(200, 130, 60),
				Brightness = 3.5,
				ClockTime = 18.2,
				FogEnd = 2000,
				FogColor = Color3.fromRGB(255, 180, 100),
			}, 0.8)
		end,
		Overcast = function()
			F_001746({
				Ambient = Color3.fromRGB(100, 100, 110),
				OutdoorAmbient = Color3.fromRGB(140, 145, 155),
				Brightness = 1,
				ClockTime = 12,
				FogEnd = 600,
				FogColor = Color3.fromRGB(180, 185, 195),
			}, 0.8)
		end,
		Neon = function()
			F_001746({
				Ambient = Color3.fromRGB(10, 0, 25),
				OutdoorAmbient = Color3.fromRGB(20, 0, 50),
				Brightness = 0.3,
				ClockTime = 0,
				FogEnd = 300,
				FogColor = Color3.fromRGB(20, 0, 60),
			}, 0.8)

			Lighting.ColorShift_Top = Color3.fromRGB(80, 0, 180)
			Lighting.ColorShift_Bottom = Color3.fromRGB(0, 180, 120)
		end,
		Sunset = function()
			F_001746({
				Ambient = Color3.fromRGB(120, 70, 40),
				OutdoorAmbient = Color3.fromRGB(240, 100, 40),
				Brightness = 2.8,
				ClockTime = 19.5,
				FogEnd = 1500,
				FogColor = Color3.fromRGB(255, 140, 80),
			}, 0.8)
		end,
		Arctic = function()
			F_001746({
				Ambient = Color3.fromRGB(140, 160, 180),
				OutdoorAmbient = Color3.fromRGB(180, 200, 220),
				Brightness = 1.8,
				ClockTime = 10,
				FogEnd = 800,
				FogColor = Color3.fromRGB(200, 215, 235),
			}, 0.8)
		end,
	}

	local function F_001754(A1754_1)
		local L1754_1 = U1098[A1754_1]

		if L1754_1 then
			pcall(L1754_1)
		end
	end

	local function F_001755()
		for I804, I805 in pairs(U1097) do
			pcall(function()
				Lighting[I804] = I805
			end)
		end
	end

	L0_406:AddDropdown("Preset", {
		Text = "Preset",
		Values = { "Default", "Midnight", "GoldenHour", "Overcast", "Neon", "Sunset", "Arctic" },
		Default = "Default",
		ValueImages = {
			Default = "sun",
			Midnight = "moon",
			GoldenHour = "sunset",
			Overcast = "cloud",
			Neon = "sparkles",
			Sunset = "sunrise",
			Arctic = "snowflake",
		},
		Callback = function(A1757_1)
			if U66.EnablePresets and U66.EnablePresets.Value then
				F_001754(A1757_1)
			end
		end,
	})

	L0_406:AddToggle("EnablePresets", {
		Text = "Enable Presets",
		Default = false,
		Callback = function(A1758_1)
			if not U1090 then
				return
			end

			if A1758_1 then
				F_001754(U65.Preset and U65.Preset.Value or "Default")
			else
				F_001755()
			end
		end,
	})

	L0_406:AddDivider()

	L0_406:AddSlider("EnvBrightness", {
		Text = "Brightness",
		Default = math.floor(Lighting.Brightness * 10),
		Min = 0,
		Max = 50,
		Rounding = 0,
		Compact = true,
		Callback = function(A1759_1)
			if not U1090 then
				return
			end
			Lighting.Brightness = A1759_1 / 10
		end,
	})

	L0_406:AddSlider("EnvClockTime", {
		Text = "Time of Day",
		Default = math.floor(Lighting.ClockTime),
		Min = 0,
		Max = 24,
		Rounding = 0,
		Compact = true,
		Callback = function(A1760_1)
			if not U1090 then
				return
			end
			Lighting.ClockTime = A1760_1
		end,
	})

	L0_406:AddSlider("FogDistance", {
		Text = "Fog Distance",
		Default = math.clamp(math.floor(Lighting.FogEnd), 50, 10000),
		Min = 50,
		Max = 10000,
		Rounding = 0,
		Compact = true,
		Callback = function(A1761_1)
			if not U1090 then
				return
			end
			Lighting.FogEnd = A1761_1
		end,
	})
end

local L0_407 = U92.Whitelist:AddGroupbox({
	Side = 1,
	Name = "<b>Select To Whitelist</b>",
	IconName = "scroll-text",
	Description = "Safe players",
	MaxPopOutHeight = 600,
	PopOutWidth = 250,
})

L0_407:AddDropdown("WhitelistPlayerSelect", {
	Text = "Select Player",
	Values = U87(),
	Default = 1,
	AllowNull = true,
	Multi = true,
	Searchable = true,
	Callback = function()
	end,
})

L0_407:AddToggle("WhitelistSelectedPlayer", {
	Text = "Whitelist Selected Player",
	Default = false,
	Callback = function()
	end,
})

L0_407:AddDivider()

L0_407:AddToggle("AutoWhitelistFriends", {
	Text = "Auto Whitelist Friends",
	Default = false,
	Callback = function()
	end,
})

do
	local U1099 = {}
	local U1100 = false
	local U1101 = false
	local U1102 = nil
	local U1103 = nil

	local function F_001765(A1765_1)
		if not A1765_1 then
			return nil
		end
		return A1765_1:match("@([%w_]+)") or A1765_1:match("%(([%w_]+)%)") or A1765_1:match("([%w_]+)")
	end

	local function F_001766(A1766_1, A1766_2)
		local L1766_1 = U68
		if not L1766_1 then
			return nil
		end
		local U1104 = U68:FindFirstChild("CanSpawnToy")

		if U1104 and not U1104.Value then
			pcall(function()
				U1104.Changed:Wait()
			end)
		end

		local L1766_2 = workspace:FindFirstChild(L1766_1.Name .. "SpawnedInToys")
		local U1105 = nil
		local U1106 = nil

		if L1766_2 then
			U1106 = L1766_2.ChildAdded:Connect(function(A1768_1)
				if A1768_1.Name == A1766_1 then
					U1105 = A1768_1
				end
			end)
		end

		task.spawn(function()
			pcall(function()
				game:GetService("ReplicatedStorage").MenuToys.SpawnToyRemoteFunction:InvokeServer(A1766_1, A1766_2, Vector3.zero)
			end)
		end)

		local L1766_3 = tick() + 2

		while true do
			task.wait(0.05)
			if not (U1105 or tick() > L1766_3) then
				continue
			end
			break
		end

		if U1106 then
			pcall(function()
				U1106:Disconnect()
			end)
		end

		if U1105 then
			return U1105
		end
		local L1766_4 = workspace:FindFirstChild(L1766_1.Name .. "SpawnedInToys")
		return L1766_4 and L1766_4:FindFirstChild(A1766_1)
	end

	local L0_408 = U92.Whitelist:AddGroupbox({
		Side = 2,
		Name = "<b>Third Party Protection</b>",
		IconName = "shield",
		Description = "Protect players",
		MaxPopOutHeight = 600,
		PopOutWidth = 250,
	})

	L0_408:AddDropdown("ThirdPartyTarget", {
		Values = U87(),
		Multi = true,
		Searchable = true,
		Text = "Select Players",
		Callback = function(A1772_1)
			U1099 = {}

			if type(A1772_1) == "table" then
				for I806, I807 in pairs(A1772_1) do
					if I807 == true or I807 == "true" then
						local L1772_1 = F_001765(I806)

						if L1772_1 and L1772_1 ~= "" then
							table.insert(U1099, L1772_1)
						end
					end
				end
			elseif type(A1772_1) == "string" then
				local L1772_2 = F_001765(A1772_1)

				if L1772_2 and L1772_2 ~= "" then
					table.insert(U1099, L1772_2)
				end
			end
		end,
	})

	L0_408:AddDivider("Settings")

	L0_408:AddToggle("ThirdPartyAntiKick", {
		Text = "Give Anti Kick",
		Default = false,
		Callback = function(A1773_1)
			U1100 = A1773_1

			if A1773_1 then
				if #U1099 == 0 then
					U1100 = false
					U66.ThirdPartyAntiKick:SetValue(false)
					return
				end

				U1102 = task.spawn(function()
					local L1774_1 = game:GetService("ReplicatedStorage")
					local U1107 = L1774_1:WaitForChild("MenuToys"):WaitForChild("DestroyToy")
					local U1108 = L1774_1:WaitForChild("PlayerEvents"):WaitForChild("StickyPartEvent")
					local U1109 = L1774_1:WaitForChild("GrabEvents"):WaitForChild("SetNetworkOwner")
					local L1774_2 = { shurikens = {} }

					while U1100 and task.wait(0.4) do
						for I808, I809 in pairs(L1774_2.shurikens) do
							local L1774_3 = false

							for I810, I811 in ipairs(U1099) do
								if I811 == I808 then
									L1774_3 = true
									break
								end
							end

							if not L1774_3 or not I809 or not I809.Parent then
								pcall(function()
									if I809 and I809.Parent then
										U1107:FireServer(I809)
									end
								end)

								L1774_2.shurikens[I808] = nil
							end
						end

						for I812, I813 in ipairs(U1099) do
							local L1774_4 = U67:FindFirstChild(I813)

							if not (not L1774_4 or not L1774_4.Character) then
								local U1110 = L1774_4.Character:FindFirstChild("HumanoidRootPart")

								if U1110 then
									if L1774_2.shurikens[I813] and L1774_2.shurikens[I813].Parent then
										local U1111 = L1774_2.shurikens[I813]
										local U1112 = U1111:FindFirstChild("StickyPart")

										if U1112 then
											local U1113 = U1110:FindFirstChild("FirePlayerPart") or U1110:WaitForChild("FirePlayerPart", 1)

											pcall(function()
												if U1112:FindFirstChild("PartOwner") and U1112.PartOwner.Value ~= U68.Name then
													U1109:FireServer(U1112, U1112.CFrame)
												end

												if U1112:FindFirstChild("StickyWeld") and U1112.StickyWeld.Part1 ~= U1113 then
													U1109:FireServer(U1112, U1112.CFrame)

													if U1113 then
														U1108:FireServer(U1112, U1113, CFrame.new(0, 0, 0, 1, 0, 0, 0, 0, -1, 0, 1, 0))
													end
												end

												if (U1112.Position - U1110.Position).Magnitude > 50 then
													U1111:PivotTo(U1110.CFrame * CFrame.new(5, 10, 5))
												end
											end)
										end
									else
										local L1774_5 = U68.Character and U68.Character:FindFirstChild("HumanoidRootPart")
										local U1114 = F_001766("NinjaShuriken", L1774_5 and L1774_5.CFrame * CFrame.new(0, 3, 0) or U1110.CFrame * CFrame.new(5, 10, 5))

										if U1114 then
											U1114.Name = "ThirdPartyShuriken_" .. I813
											local L1774_6 = U1114:WaitForChild("StickyPart", 2)

											if not L1774_6 then
												pcall(function()
													U1107:FireServer(U1114)
												end)
											else
												U1109:FireServer(L1774_6, L1774_6.CFrame)
												local L1774_7 = U1114:FindFirstChild("SoundPart")

												if L1774_7 then
													U1109:FireServer(L1774_7, L1774_7.CFrame)
												end

												local L1774_8 = 0

												while not L1774_6:FindFirstChild("PartOwner") and L1774_8 < 2 do
													task.wait(0.05)
													U1109:FireServer(L1774_6, L1774_6.CFrame)

													if L1774_7 then
														U1109:FireServer(L1774_7, L1774_7.CFrame)
													end

													L1774_8 += 0.05
												end

												local L1774_9 = U1110:FindFirstChild("FirePlayerPart") or U1110:WaitForChild("FirePlayerPart", 2)

												if L1774_9 then
													U1108:FireServer(L1774_6, L1774_9, CFrame.new(0, 0, 0, 1, 0, 0, 0, 0, -1, 0, 1, 0))
												end

												for I814, I815 in pairs(U1114:GetChildren()) do
													if I815.Name == "Pyramid" or I815.Name == "Main" then
														I815.CanTouch = false
														I815.CanCollide = false
														I815.CanQuery = false
														I815.Transparency = 0
													elseif I815:IsA("BasePart") then
														I815.CanTouch = false
														I815.CanCollide = false
														I815.CanQuery = false
														I815.Transparency = 1
													end
												end

												L1774_2.shurikens[I813] = U1114
											end
										end
									end
								end
							end
						end
					end

					for I816, I817 in pairs(L1774_2.shurikens) do
						pcall(function()
							if I817 and I817.Parent then
								U1107:FireServer(I817)
							end
						end)
					end

					L1774_2.shurikens = {}
				end)
			else
				U1100 = false

				if U1102 then
					task.cancel(U1102)
					U1102 = nil
				end

				local L1773_1 = workspace:FindFirstChild(U68.Name .. "SpawnedInToys")
				local U1115 = game:GetService("ReplicatedStorage"):FindFirstChild("MenuToys") and game:GetService("ReplicatedStorage").MenuToys:FindFirstChild("DestroyToy")

				if L1773_1 and U1115 then
					for I818, I819 in pairs(L1773_1:GetChildren()) do
						if I819.Name:find("ThirdPartyShuriken_") or I819.Name == "NinjaShuriken" then
							pcall(function()
								U1115:FireServer(I819)
							end)
						end
					end
				end
			end
		end,
	})

	L0_408:AddToggle("ThirdPartyAntiGrab", {
		Text = "Give Anti Grab",
		Default = false,
		Callback = function(A1780_1)
			U1101 = A1780_1

			if A1780_1 then
				if #U1099 == 0 then
					U1101 = false
					U66.ThirdPartyAntiGrab:SetValue(false)
					return
				end

				U1103 = task.spawn(function()
					local U1116 = game:GetService("ReplicatedStorage"):WaitForChild("CharacterEvents"):WaitForChild("Struggle")
					local U1117 = game:GetService("ReplicatedStorage"):WaitForChild("GrabEvents"):WaitForChild("DestroyGrabLine")
					local U1118 = game:GetService("ReplicatedStorage"):WaitForChild("GrabEvents"):WaitForChild("SetNetworkOwner")
					local U1119 = { returnPoses = {} }

					while U1101 and task.wait(0.05) do
						for I820, I821 in ipairs(U1099) do
							local L1781_1 = U67:FindFirstChild(I821)

							if not (not L1781_1 or not L1781_1.Character) then
								local L1781_2 = L1781_1.Character
								local U1120 = L1781_2:FindFirstChild("HumanoidRootPart")
								local U1121 = L1781_2:FindFirstChild("Humanoid")

								if not (not U1120 or not U1121) then
									local L1781_3 = U1121.SeatPart == nil

									if L1781_3 then
										local L1781_4 = Enum.HumanoidStateType.Dead
										L1781_3 = U1121:GetState() ~= L1781_4
									end

									if L1781_3 then
										U1119.returnPoses[I821] = U1120.CFrame
									end

									if U1121.SeatPart then
										local L1781_5 = U1121.SeatPart

										if L1781_5.Parent and L1781_5.Parent.Name ~= "CreatureBlobman" and L1781_5.Parent.Name ~= "TractorGreen" and not L1781_5.Parent.Name:find("Train") then
											pcall(function()
												U1116:FireServer()
												U1118:FireServer(U1120, U1120.CFrame)
												task.wait(0.03)
												U1117:FireServer(U1120)
												task.wait(0.03)
												U1120.Anchored = true
												U1120.AssemblyLinearVelocity = Vector3.zero
												U1120.AssemblyAngularVelocity = Vector3.zero
												task.wait(0.05)
												U1120.Anchored = false
												U1121.Sit = false
												U1121.PlatformStand = false
												U1121:ChangeState(Enum.HumanoidStateType.Running)

												if U1119.returnPoses[I821] then
													U1120.CFrame = U1119.returnPoses[I821]
													U1120.AssemblyLinearVelocity = Vector3.zero
													U1120.AssemblyAngularVelocity = Vector3.zero
												end

												U1116:FireServer()
											end)
										end
									end
								end
							end
						end
					end
				end)
			else
				U1101 = false

				if U1103 then
					task.cancel(U1103)
					U1103 = nil
				end
			end
		end,
	})
end

do
	local U1122 = nil

	local function F_001783()
		if U1122 and U1122.Parent then
			return U1122
		end
		local U1123 = U62.ScreenGui or game:GetService("CoreGui")
		local U1124 = Instance.new("ScreenGui")
		U1124.Name = "ST_MobileKeyboardGui"
		U1124.ResetOnSpawn = false
		U1124.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

		pcall(function()
			if syn and syn.protect_gui then
				syn.protect_gui(U1124)
				U1124.Parent = game:GetService("CoreGui")
			elseif gethui then
				U1124.Parent = gethui()
			else
				U1124.Parent = U1123
			end
		end)

		if not U1124.Parent then
			U1124.Parent = U1123
		end

		local U1125 = Instance.new("Frame")
		U1125.Name = "Main"
		U1125.Size = UDim2.fromOffset(530, 186)
		U1125.Position = UDim2.new(0.5, -265, 0.72, -93)
		U1125.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
		U1125.BackgroundTransparency = 0.55
		U1125.BorderSizePixel = 0
		U1125.Active = true
		U1125.Parent = U1124
		local L1783_1 = Instance.new("UICorner")
		L1783_1.CornerRadius = UDim.new(0, 14)
		L1783_1.Parent = U1125
		local L1783_2 = Instance.new("UIStroke")
		L1783_2.Color = Color3.fromRGB(255, 255, 255)
		L1783_2.Thickness = 1
		L1783_2.Transparency = 0.85
		L1783_2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		L1783_2.Parent = U1125
		local L1783_3 = Instance.new("Frame")
		L1783_3.Name = "TopBar"
		L1783_3.Size = UDim2.new(1, 0, 0, 20)
		L1783_3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		L1783_3.BackgroundTransparency = 0.95
		L1783_3.BorderSizePixel = 0
		L1783_3.Parent = U1125
		local L1783_4 = Instance.new("UICorner")
		L1783_4.CornerRadius = UDim.new(0, 14)
		L1783_4.Parent = L1783_3
		local L1783_5 = Instance.new("Frame")
		L1783_5.Name = "DragPill"
		L1783_5.Size = UDim2.fromOffset(36, 4)
		L1783_5.Position = UDim2.new(0.5, -18, 0.5, -2)
		L1783_5.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		L1783_5.BackgroundTransparency = 0.72
		L1783_5.BorderSizePixel = 0
		L1783_5.Parent = L1783_3
		local L1783_6 = Instance.new("UICorner")
		L1783_6.CornerRadius = UDim.new(1, 0)
		L1783_6.Parent = L1783_5
		local L1783_7 = Instance.new("TextButton")
		L1783_7.Name = "CloseBtn"
		L1783_7.Size = UDim2.fromOffset(20, 16)
		L1783_7.Position = UDim2.new(1, -23, 0, 2)
		L1783_7.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		L1783_7.BackgroundTransparency = 0.85
		L1783_7.Text = "X"
		L1783_7.TextColor3 = Color3.fromRGB(220, 220, 225)
		L1783_7.TextSize = 11
		L1783_7.Font = Enum.Font.GothamBold
		L1783_7.Parent = L1783_3
		local L1783_8 = Instance.new("UICorner")
		L1783_8.CornerRadius = UDim.new(0, 6)
		L1783_8.Parent = L1783_7
		local L1783_9 = Instance.new("UIStroke")
		L1783_9.Color = Color3.fromRGB(255, 255, 255)
		L1783_9.Thickness = 1
		L1783_9.Transparency = 0.85
		L1783_9.Parent = L1783_7

		L1783_7.MouseButton1Click:Connect(function()
			if U66 and U66.ShowMobileKeyboard then
				U66.ShowMobileKeyboard:SetValue(false)
			else
				U1124.Enabled = false
			end
		end)

		local U1126 = false
		local U1127 = nil
		local U1128 = nil
		local U1129 = nil

		local function F_001786(A1786_1)
			if A1786_1.UserInputType == Enum.UserInputType.MouseButton1 or A1786_1.UserInputType == Enum.UserInputType.Touch then
				U1126 = true
				U1128 = A1786_1.Position
				U1129 = U1125.Position

				A1786_1.Changed:Connect(function()
					if A1786_1.UserInputState == Enum.UserInputState.End then
						U1126 = false
					end
				end)
			end
		end

		L1783_3.InputBegan:Connect(F_001786)

		U1125.InputBegan:Connect(function(A1788_1)
			if A1788_1.UserInputType == Enum.UserInputType.MouseButton1 or A1788_1.UserInputType == Enum.UserInputType.Touch then
				F_001786(A1788_1)
			end
		end)

		L1783_3.InputChanged:Connect(function(A1789_1)
			if A1789_1.UserInputType == Enum.UserInputType.MouseMovement or A1789_1.UserInputType == Enum.UserInputType.Touch then
				U1127 = A1789_1
			end
		end)

		game:GetService("UserInputService").InputChanged:Connect(function(A1790_1)
			if A1790_1 == U1127 and U1126 then
				local L1790_1 = A1790_1.Position - U1128
				U1125.Position = UDim2.new(U1129.X.Scale, U1129.X.Offset + L1790_1.X, U1129.Y.Scale, U1129.Y.Offset + L1790_1.Y)
			end
		end)

		local L1783_10 = Instance.new("Frame")
		L1783_10.Name = "KeysHolder"
		L1783_10.Size = UDim2.new(1, -12, 1, -26)
		L1783_10.Position = UDim2.fromOffset(6, 22)
		L1783_10.BackgroundTransparency = 1
		L1783_10.Parent = U1125
		local L1783_11 = Instance.new("UIListLayout")
		L1783_11.Padding = UDim.new(0, 4)
		L1783_11.SortOrder = Enum.SortOrder.LayoutOrder
		L1783_11.Parent = L1783_10
		local U1130 = game:GetService("VirtualInputManager")

		local function F_001791(A1791_1, A1791_2)
			task.spawn(function()
				pcall(function()
					U70:Create(A1791_2, TweenInfo.new(0.08), { BackgroundColor3 = Color3.fromRGB(255, 255, 255), BackgroundTransparency = 0.45 }):Play()
				end)

				pcall(function()
					U1130:SendKeyEvent(true, A1791_1, false, game)
				end)

				pcall(function()
					if keypress then
						keypress(A1791_1.Value)
					end
				end)

				task.wait(0.08)

				pcall(function()
					U1130:SendKeyEvent(false, A1791_1, false, game)
				end)

				pcall(function()
					if keyrelease then
						keyrelease(A1791_1.Value)
					end
				end)

				pcall(function()
					U70:Create(A1791_2, TweenInfo.new(0.14), { BackgroundColor3 = Color3.fromRGB(255, 255, 255), BackgroundTransparency = 0.88 }):Play()
				end)
			end)
		end

		for I822, I823 in ipairs({
			{
				{ "Esc", Enum.KeyCode.Escape, 30 },
				{ "1", Enum.KeyCode.One, 28 },
				{ "2", Enum.KeyCode.Two, 28 },
				{ "3", Enum.KeyCode.Three, 28 },
				{ "4", Enum.KeyCode.Four, 28 },
				{ "5", Enum.KeyCode.Five, 28 },
				{ "6", Enum.KeyCode.Six, 28 },
				{ "7", Enum.KeyCode.Seven, 28 },
				{ "8", Enum.KeyCode.Eight, 28 },
				{ "9", Enum.KeyCode.Nine, 28 },
				{ "0", Enum.KeyCode.Zero, 28 },
				{ "-", Enum.KeyCode.Minus, 28 },
				{ "=", Enum.KeyCode.Equals, 28 },
				{ "Back", Enum.KeyCode.Backspace, 48 },
			},
			{
				{ "Tab", Enum.KeyCode.Tab, 40 },
				{ "Q", Enum.KeyCode.Q, 29 },
				{ "W", Enum.KeyCode.W, 29 },
				{ "E", Enum.KeyCode.E, 29 },
				{ "R", Enum.KeyCode.R, 29 },
				{ "T", Enum.KeyCode.T, 29 },
				{ "Y", Enum.KeyCode.Y, 29 },
				{ "U", Enum.KeyCode.U, 29 },
				{ "I", Enum.KeyCode.I, 29 },
				{ "O", Enum.KeyCode.O, 29 },
				{ "P", Enum.KeyCode.P, 29 },
				{ "[", Enum.KeyCode.LeftBracket, 29 },
				{ "]", Enum.KeyCode.RightBracket, 29 },
				{ "\\", Enum.KeyCode.BackSlash, 33 },
			},
			{
				{ "Caps", Enum.KeyCode.CapsLock, 44 },
				{ "A", Enum.KeyCode.A, 29 },
				{ "S", Enum.KeyCode.S, 29 },
				{ "D", Enum.KeyCode.D, 29 },
				{ "F", Enum.KeyCode.F, 29 },
				{ "G", Enum.KeyCode.G, 29 },
				{ "H", Enum.KeyCode.H, 29 },
				{ "J", Enum.KeyCode.J, 29 },
				{ "K", Enum.KeyCode.K, 29 },
				{ "L", Enum.KeyCode.L, 29 },
				{ ";", Enum.KeyCode.Semicolon, 29 },
				{ "'", Enum.KeyCode.Quote, 29 },
				{ "Enter", Enum.KeyCode.Return, 55 },
			},
			{
				{ "Shift", Enum.KeyCode.LeftShift, 52 },
				{ "Z", Enum.KeyCode.Z, 29 },
				{ "X", Enum.KeyCode.X, 29 },
				{ "C", Enum.KeyCode.C, 29 },
				{ "V", Enum.KeyCode.V, 29 },
				{ "B", Enum.KeyCode.B, 29 },
				{ "N", Enum.KeyCode.N, 29 },
				{ "M", Enum.KeyCode.M, 29 },
				{ ",", Enum.KeyCode.Comma, 29 },
				{ ".", Enum.KeyCode.Period, 29 },
				{ "/", Enum.KeyCode.Slash, 29 },
				{ "^", Enum.KeyCode.Up, 29 },
				{ "Del", Enum.KeyCode.Delete, 35 },
			},
			{
				{ "Ctrl", Enum.KeyCode.LeftControl, 44 },
				{ "Alt", Enum.KeyCode.LeftAlt, 40 },
				{ "Space", Enum.KeyCode.Space, 190 },
				{ "<", Enum.KeyCode.Left, 32 },
				{ "v", Enum.KeyCode.Down, 32 },
				{ ">", Enum.KeyCode.Right, 32 },
			},
		}) do
			local L1783_12 = Instance.new("Frame")
			L1783_12.Name = "Row_" .. tostring(I822)
			L1783_12.Size = UDim2.new(1, 0, 0, 30)
			L1783_12.BackgroundTransparency = 1
			L1783_12.LayoutOrder = I822
			L1783_12.Parent = L1783_10
			local L1783_13 = Instance.new("UIListLayout")
			L1783_13.FillDirection = Enum.FillDirection.Horizontal
			L1783_13.Padding = UDim.new(0, 4)
			L1783_13.HorizontalAlignment = Enum.HorizontalAlignment.Center
			L1783_13.SortOrder = Enum.SortOrder.LayoutOrder
			L1783_13.Parent = L1783_12

			for I824, I825 in ipairs(I823) do
				local L1783_14 = I825[1]
				local U1131 = I825[2]
				local L1783_15 = I825[3]
				local U1132 = Instance.new("TextButton")
				U1132.Name = L1783_14
				U1132.Size = UDim2.fromOffset(L1783_15, 28)
				U1132.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				U1132.BackgroundTransparency = 0.88
				U1132.Text = L1783_14
				U1132.TextColor3 = Color3.fromRGB(245, 245, 250)
				U1132.TextSize = 11
				U1132.Font = Enum.Font.GothamMedium
				U1132.LayoutOrder = I824
				U1132.AutoButtonColor = false
				U1132.Parent = L1783_12
				local L1783_16 = Instance.new("UICorner")
				L1783_16.CornerRadius = UDim.new(0, 6)
				L1783_16.Parent = U1132
				local L1783_17 = Instance.new("UIStroke")
				L1783_17.Color = Color3.fromRGB(255, 255, 255)
				L1783_17.Thickness = 1
				L1783_17.Transparency = 0.86
				L1783_17.Parent = U1132

				U1132.MouseButton1Down:Connect(function()
					F_001791(U1131, U1132)
				end)
			end
		end

		U1122 = U1124
		return U1124
	end

	local function F_001800(A1800_1)
		local L1800_1 = F_001783()

		if L1800_1 then
			L1800_1.Enabled = A1800_1
		end
	end

	local L0_409 = U92.Keyboard:AddGroupbox({
		Side = 1,
		Name = "<b>Keybinds</b>",
		IconName = "square-plus",
		Description = "Configure all keybinds in one place",
		MaxPopOutHeight = 600,
		PopOutWidth = 250,
	})

	L0_409:AddDivider()

	L0_409:AddToggle("KeybindMenuOpen", {
		Default = U62.KeybindFrame.Visible,
		Text = "<b>Open Keybind Menu</b>",
		Callback = function(A1801_1)
			U62.KeybindFrame.Visible = A1801_1
		end,
	})

	local L0_410 = U92.Keyboard:AddGroupbox({
		Side = 2,
		Name = "<b>Mobile Keyboard</b>",
		IconName = "chevron-up",
		Description = "Able to use keybinds",
		MaxPopOutHeight = 600,
		PopOutWidth = 250,
	})

	L0_410:AddDivider("Keyboard")

	L0_410:AddToggle("ShowMobileKeyboard", {
		Text = "<b>Show Keyboard</b>",
		Default = false,
		Callback = function(A1802_1)
			F_001800(A1802_1)
		end,
	})
end

local L0_411 = U92.UISettings:AddGroupbox({
	Side = 1,
	Name = "<b>Script</b>",
	IconName = "terminal",
	Description = "Quick actions",
	MaxPopOutHeight = 600,
	PopOutWidth = 250,
})

L0_411:AddDivider("Settings")

L0_411:AddButton({
	Text = "<b>Change Servers</b>",
	Func = function()
		pcall(function()
			game:GetService("TeleportService"):Teleport(game.PlaceId, U68)
		end)
	end,
	DoubleClick = false,
})

L0_411:AddButton({
	Text = "<b>Rejoin</b>",
	Func = function()
		pcall(function()
			game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, U68)
		end)
	end,
	DoubleClick = false,
})

L0_411:AddDivider()

L0_411:AddToggle("HomeAutoExecute", {
	Text = "<b>Auto Execute</b>",
	Default = false,
	Callback = function(A1807_1)
		U95()

		if A1807_1 then
			pcall(function()
				local L1808_1 = syn and syn.queue_on_teleport or queue_on_teleport or fluxus and fluxus.queue_on_teleport

				if L1808_1 then
					L1808_1("loadstring(game:HttpGet(\"https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source\"))()")
				end
			end)
		end
	end,
})

L0_411:AddToggle("HomeAutoAntiLag", {
	Text = "<b>Auto Anti-Lag</b>",
	Default = true,
	Callback = function(A1809_1)
		U95()

		if U66.AutoAntiLag and U66.AutoAntiLag.Value ~= A1809_1 then
			U66.AutoAntiLag:SetValue(A1809_1)
		end
	end,
})

do
	local U1133 = {
		Crown = "crown",
		Star = "star",
		Heart = "heart",
		Sparkles = "sparkles",
		Flame = "flame",
		Zap = "zap",
		Skull = "skull",
		Crosshair = "crosshair",
		Shield = "shield-check",
		Ghost = "ghost",
		Diamond = "gem",
		Target = "target",
		Swords = "swords",
		Lock = "lock",
		Checkmark = "check",
	}

	local U1134 = {}
	local U1135 = { "#", "$", "%", "&", "@", "?", "!", "0", "1", "<", ">", "/", "*" }

	local function F_001810(A1810_1)
		if not A1810_1 or not A1810_1:IsA("ImageLabel") then
			return
		end
		local U1136 = U66.EnableCustomButtons and U66.EnableCustomButtons.Value and (U1133[U65.CustomButtonType and U65.CustomButtonType.Value or "Crown"] or "crown") or "check"
		local L1810_1 = U62.GetIcon and U62:GetIcon(U1136)
		local U1137

		if L1810_1 then
			U1137 = L1810_1
		else
			U1137 = U62.GetCustomIcon and U62:GetCustomIcon(U1136)
		end

		if U1137 then
			pcall(function()
				if U62.ApplyLucideIcon then
					U62:ApplyLucideIcon(A1810_1, U1137)
				else
					A1810_1.Image = U1137.Url or A1810_1.Image
					A1810_1.ImageRectOffset = U1137.ImageRectOffset or A1810_1.ImageRectOffset
					A1810_1.ImageRectSize = U1137.ImageRectSize or A1810_1.ImageRectSize
				end

				A1810_1:SetAttribute("ST_CurrentIconName", U1136)
			end)
		end
	end

	local U1138 = {}

	local function F_001812(A1812_1)
		if A1812_1 and A1812_1:IsA("ImageLabel") and A1812_1.Parent and A1812_1.Parent:IsA("Frame") and A1812_1.Parent.Parent and A1812_1.Parent.Parent:IsA("TextButton") then
			local L1812_1 = A1812_1.Parent
			if L1812_1:FindFirstChildOfClass("UICorner") or L1812_1.SizeConstraint == Enum.SizeConstraint.RelativeYY or A1812_1:GetAttribute("ST_IsCheckImage") then
				return true
			end
		end

		return false
	end

	local function F_001813(A1813_1)
		if F_001812(A1813_1) then
			if not table.find(U1138, A1813_1) then
				table.insert(U1138, A1813_1)
			end
		end
	end

	local function F_001814()
		U1138 = {}

		if U62.ScreenGui then
			for I826, I827 in ipairs(U62.ScreenGui:GetDescendants()) do
				F_001813(I827)
			end
		end
	end

	pcall(function()
		if U62.ScreenGui then
			U62.ScreenGui.DescendantAdded:Connect(function(A1816_1)
				if A1816_1:IsA("ImageLabel") then
					task.defer(function()
						F_001813(A1816_1)
					end)
				end
			end)
		end
	end)

	local function F_001818()
		local L1818_1 = U66.EnableCustomButtons and U66.EnableCustomButtons.Value

		for I828 = #U1138, 1, -1 do
			local L1818_2 = U1138[I828]

			if L1818_2 and L1818_2.Parent then
				F_001810(L1818_2)

				if not L1818_1 then
					L1818_2.Rotation = 0
					L1818_2.Position = UDim2.fromOffset(2, 2)
					L1818_2.ImageColor3 = U62.Scheme.FontColor or Color3.fromRGB(255, 255, 255)
				end
			else
				table.remove(U1138, I828)
			end
		end
	end

	local function F_001819(A1819_1)
		if not A1819_1 or not A1819_1.TextLabel then
			return
		end
		local L1819_1 = U1134[A1819_1]

		if L1819_1 then
			A1819_1.TextLabel.Text = L1819_1.Text
			A1819_1.TextLabel.TextColor3 = L1819_1.Color or U62.Scheme.FontColor or Color3.fromRGB(255, 255, 255)
			A1819_1.TextLabel.TextStrokeTransparency = 1
			A1819_1.TextLabel.TextTransparency = A1819_1.Value == true and 0 or 0.4
		else
			A1819_1.TextLabel.TextTransparency = A1819_1.Value == true and 0 or 0.4
			A1819_1.TextLabel.TextColor3 = U62.Scheme.FontColor or Color3.fromRGB(255, 255, 255)
			A1819_1.TextLabel.TextStrokeTransparency = 1
		end
	end

	local function F_001820()
		if not (U66.EnableCustomTexts and U66.EnableCustomTexts.Value) then
			if U62.Toggles then
				for I829, I830 in pairs(U62.Toggles) do
					pcall(function()
						F_001819(I830)
					end)
				end
			end
		end
	end

	task.spawn(function()
		task.wait(0.5)
		F_001814()

		while true do
			local L1822_1 = U66.EnableCustomTexts and U66.EnableCustomTexts.Value
			local L1822_2 = U66.EnableCustomButtons and U66.EnableCustomButtons.Value
			if not L1822_1 and not L1822_2 then
				task.wait(0.8)
				continue
			end
			task.wait(0.04)
			local L1822_3 = tick()

			if L1822_2 then
				local L1822_4 = U1133[U65.CustomButtonType and U65.CustomButtonType.Value or "Crown"] or "crown"
				local L1822_5 = U65.ButtonAnimType and U65.ButtonAnimType.Value or "Fade In"
				local L1822_6 = U65.CustomButtonColor and U65.CustomButtonColor.Value or Color3.fromRGB(255, 255, 255)

				for I831 = #U1138, 1, -1 do
					local L1822_7 = U1138[I831]
					if not L1822_7 or not L1822_7.Parent then
						table.remove(U1138, I831)
						continue
					end

					if L1822_7:GetAttribute("ST_CurrentIconName") ~= L1822_4 then
						F_001810(L1822_7)
					end

					if L1822_7.ImageTransparency < 0.9 then
						if L1822_5 == "Rainbow" then
							L1822_7.ImageColor3 = Color3.fromHSV(L1822_3 * 0.45 % 1, 1, 1)
						else
							L1822_7.ImageColor3 = L1822_6
						end

						if L1822_5 == "Fade In" then
							L1822_7.Rotation = 0
							L1822_7.ImageTransparency = (math.sin(L1822_3 * 2.5) + 1) / 2 * 0.6
							L1822_7.Position = UDim2.fromOffset(2, 2)
							continue
						end

						if L1822_5 == "Spin" then
							L1822_7.Rotation = L1822_3 * 140 % 360
							L1822_7.Position = UDim2.fromOffset(2, 2)
							continue
						end

						if L1822_5 == "Blink" then
							L1822_7.Rotation = 0
							L1822_7.ImageTransparency = (math.sin(L1822_3 * 7) + 1) / 2 > 0.4 and 0 or 0.8
							L1822_7.Position = UDim2.fromOffset(2, 2)
							continue
						end

						if L1822_5 == "Glow Pulse" then
							L1822_7.Rotation = 0
							L1822_7.ImageTransparency = (math.sin(L1822_3 * 4.5) + 1) / 2 * 0.55
							L1822_7.Position = UDim2.fromOffset(2, 2)
							continue
						end

						if L1822_5 == "Bounce" then
							L1822_7.Rotation = 0
							L1822_7.Position = UDim2.fromOffset(2, 2 + math.sin(L1822_3 * 9) * 1.8)
							L1822_7.ImageTransparency = 0
							continue
						end

						L1822_7.Rotation = 0
						L1822_7.Position = UDim2.fromOffset(2, 2)
						L1822_7.ImageTransparency = 0
					end
				end
			end

			if U62.Toggles then
				for I832, I833 in pairs(U62.Toggles) do
					if I833 and I833.TextLabel and I833.TextLabel.Parent then
						if not U1134[I833] then
							local L1822_8 = I833.TextLabel.Text

							U1134[I833] = {
								Text = L1822_8,
								CleanText = L1822_8:gsub("<[^>]->", ""),
								Color = I833.TextLabel.TextColor3,
							}
						end

						local U1139 = U1134[I833]

						if L1822_1 and I833.Value == true then
							pcall(function()
								I833.TextLabel.RichText = true
								local L1823_1 = baseTextColor

								if textType == "Rainbow" then
									L1823_1 = Color3.fromHSV(tick() * 0.35 % 1, 0.9, 1)
								end

								if textType == "Rainbow" then
									I833.TextLabel.TextColor3 = L1823_1
									I833.TextLabel.TextStrokeColor3 = Color3.fromHSV((tick() * 0.35 + 0.5) % 1, 0.9, 0.4)
									I833.TextLabel.TextStrokeTransparency = 0.5
									I833.TextLabel.TextTransparency = 0
									I833.TextLabel.Text = U1139.Text
								elseif textType == "Neon Glow" then
									local L1823_2 = (math.sin(tick() * 4) + 1) / 2
									I833.TextLabel.TextColor3 = L1823_1:Lerp(Color3.fromRGB(255, 255, 255), L1823_2 * 0.4)
									I833.TextLabel.TextStrokeColor3 = L1823_1
									I833.TextLabel.TextStrokeTransparency = 0.35 + L1823_2 * 0.3
									I833.TextLabel.TextTransparency = 0
									I833.TextLabel.Text = U1139.Text
								elseif textType == "Animated Typing" then
									local L1823_3 = U1139.CleanText or "Toggle"
									local L1823_4 = math.floor(tick() * 12 % (#L1823_3 + 10))

									if L1823_4 <= #L1823_3 then
										I833.TextLabel.Text = "<b>" .. L1823_3:sub(1, L1823_4) .. "<font color=\"#" .. L1823_1:ToHex() .. "\">_</font></b>"
									else
										I833.TextLabel.Text = "<b>" .. L1823_3 .. "</b>"
									end

									I833.TextLabel.TextColor3 = L1823_1
									I833.TextLabel.TextStrokeTransparency = 0.6
									I833.TextLabel.TextTransparency = 0
								elseif textType == "Pulse Breathe" then
									local L1823_5 = (math.sin(tick() * 4) + 1) / 2
									I833.TextLabel.TextTransparency = 0.05 + L1823_5 * 0.45
									I833.TextLabel.TextColor3 = L1823_1
									I833.TextLabel.TextStrokeTransparency = 0.5 + L1823_5 * 0.3
									I833.TextLabel.TextStrokeColor3 = Color3.fromRGB(30, 30, 30)
									I833.TextLabel.Text = U1139.Text
								elseif textType == "Cyber Glitch" then
									if math.random() < 0.12 then
										local L1823_6 = (U1139.CleanText or "Toggle"):split("")
										local L1823_7 = U1135
										L1823_6[math.random(1, #L1823_6)] = L1823_7[math.random(1, #U1135)]
										I833.TextLabel.Text = "<b>" .. table.concat(L1823_6, "") .. "</b>"
										I833.TextLabel.TextColor3 = L1823_1
										I833.TextLabel.TextStrokeTransparency = 0.2
										I833.TextLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
									else
										I833.TextLabel.Text = U1139.Text
										I833.TextLabel.TextColor3 = L1823_1
										I833.TextLabel.TextStrokeTransparency = 0.5
									end

									I833.TextLabel.TextTransparency = 0
								elseif textType == "Gold Elegance" then
									local L1823_8 = (math.sin(tick() * 3) + 1) / 2
									I833.TextLabel.TextColor3 = Color3.fromRGB(255, 215, 0):Lerp(L1823_1, 0.4):Lerp(Color3.fromRGB(255, 245, 150), L1823_8)
									I833.TextLabel.TextStrokeColor3 = Color3.fromRGB(130, 85, 0)
									I833.TextLabel.TextStrokeTransparency = 0.35
									I833.TextLabel.TextTransparency = 0
									I833.TextLabel.Text = U1139.Text
								elseif textType == "Fire Flame" then
									local L1823_9 = (math.sin(tick() * 6) + 1) / 2
									I833.TextLabel.TextColor3 = Color3.fromRGB(255, 60, 0):Lerp(L1823_1, 0.3):Lerp(Color3.fromRGB(255, 185, 30), L1823_9)
									I833.TextLabel.TextStrokeColor3 = Color3.fromRGB(110, 20, 0)
									I833.TextLabel.TextStrokeTransparency = 0.3
									I833.TextLabel.TextTransparency = 0
									I833.TextLabel.Text = U1139.Text
								elseif textType == "Ice Frost" then
									local L1823_10 = (math.sin(tick() * 3) + 1) / 2
									I833.TextLabel.TextColor3 = Color3.fromRGB(110, 215, 255):Lerp(L1823_1, 0.3):Lerp(Color3.fromRGB(220, 250, 255), L1823_10)
									I833.TextLabel.TextStrokeColor3 = Color3.fromRGB(0, 90, 160)
									I833.TextLabel.TextStrokeTransparency = 0.35
									I833.TextLabel.TextTransparency = 0
									I833.TextLabel.Text = U1139.Text
								elseif textType == "Electric Violet" then
									local L1823_11 = (math.sin(tick() * 3.5) + 1) / 2
									I833.TextLabel.TextColor3 = Color3.fromRGB(190, 65, 255):Lerp(L1823_1, 0.3):Lerp(Color3.fromRGB(240, 170, 255), L1823_11)
									I833.TextLabel.TextStrokeColor3 = Color3.fromRGB(80, 0, 130)
									I833.TextLabel.TextStrokeTransparency = 0.35
									I833.TextLabel.TextTransparency = 0
									I833.TextLabel.Text = U1139.Text
								elseif textType == "Clean White" then
									I833.TextLabel.TextColor3 = L1823_1
									I833.TextLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
									I833.TextLabel.TextStrokeTransparency = 0.2
									I833.TextLabel.TextTransparency = 0
									I833.TextLabel.Text = U1139.Text
								end
							end)

							continue
						end

						if I833.Value == false then
							if U1139 and I833.TextLabel.Text ~= U1139.Text then
								I833.TextLabel.Text = U1139.Text
							end

							I833.TextLabel.TextTransparency = 0.4
							I833.TextLabel.TextColor3 = U62.Scheme.FontColor or Color3.fromRGB(255, 255, 255)
							I833.TextLabel.TextStrokeTransparency = 1
							continue
						end

						if not L1822_1 then
							F_001819(I833)
						end
					end
				end
			end
		end
	end)

	local U1140 = U92.UISettings:AddGroupbox({
		Side = 2,
		Name = "<b>Custom Buttons</b>",
		IconName = "sliders-horizontal",
		Description = "Customize",
		MaxPopOutHeight = 600,
		PopOutWidth = 250,
	})

	task.spawn(function()
		for I834 = 1, 10 do
			task.wait(0.2)

			if U1140 and U1140.Holder then
				local L1824_1 = U1140.Holder:FindFirstChild("GroupboxTop")

				if L1824_1 and not L1824_1:FindFirstChildOfClass("ImageLabel") then
					local L1824_2 = U62.GetIcon and U62:GetIcon("sliders-horizontal") or U62.GetCustomIcon and U62:GetCustomIcon("sliders-horizontal")

					if L1824_2 and U62.ApplyLucideIcon then
						local L1824_3 = Instance.new("ImageLabel")
						L1824_3.Name = "GroupboxHeaderIcon"
						L1824_3.AnchorPoint = Vector2.new(0, 0.5)
						L1824_3.Position = UDim2.fromScale(0, 0.5)
						L1824_3.Size = UDim2.fromOffset(22, 22)
						L1824_3.BackgroundTransparency = 1
						L1824_3.ImageColor3 = U62.Scheme.AccentColor or Color3.fromRGB(255, 255, 255)
						L1824_3.Parent = L1824_1
						U62:ApplyLucideIcon(L1824_3, L1824_2)
						break
					end
				end
			end
		end
	end)

	U1140:AddDivider()

	U1140:AddToggle("EnableCustomButtons", {
		Text = "<b>Enable Custom Buttons</b>",
		Default = true,
		Callback = function()
			F_001818()
		end,
	})

	U1140:AddDropdown("CustomButtonType", {
		Text = "<b>Type</b>",
		Values = {
			"Crown",
			"Star",
			"Heart",
			"Sparkles",
			"Flame",
			"Zap",
			"Skull",
			"Crosshair",
			"Shield",
			"Ghost",
			"Diamond",
			"Target",
			"Swords",
			"Lock",
			"Checkmark",
		},
		ValueImages = {
			Crown = "crown",
			Star = "star",
			Heart = "heart",
			Sparkles = "sparkles",
			Flame = "flame",
			Zap = "zap",
			Skull = "skull",
			Crosshair = "crosshair",
			Shield = "shield-check",
			Ghost = "ghost",
			Diamond = "gem",
			Target = "target",
			Swords = "swords",
			Lock = "lock",
			Checkmark = "check",
		},
		Default = "Crown",
		Callback = function()
			F_001818()
		end,
	})

	U1140:AddLabel("Main Color"):AddColorPicker("CustomButtonColor", {
		Default = Color3.fromRGB(255, 255, 255),
		Title = "Main Color",
		Callback = function()
		end,
	})

	U1140:AddDivider("Animations")

	U1140:AddDropdown("ButtonAnimType", {
		Text = "<b>Animation Type</b>",
		Values = { "Rainbow", "Spin", "Blink", "Glow Pulse", "Fade In", "Bounce", "Static" },
		ValueImages = {
			Rainbow = "sparkles",
			Spin = "rotate-cw",
			Blink = "sparkle",
			["Glow Pulse"] = "flame",
			["Fade In"] = "sunrise",
			Bounce = "activity",
			Static = "circle",
		},
		Default = "Fade In",
		Callback = function()
		end,
	})

	U1140:AddDivider("Text Type")

	U1140:AddToggle("EnableCustomTexts", {
		Text = "<b>Enable Custom Texts</b>",
		Default = false,
		Callback = function()
			F_001820()
		end,
	})

	U1140:AddDropdown("CustomTextType", {
		Text = "<b>Text Type</b>",
		Values = {
			"Rainbow",
			"Neon Glow",
			"Animated Typing",
			"Pulse Breathe",
			"Cyber Glitch",
			"Gold Elegance",
			"Fire Flame",
			"Ice Frost",
			"Electric Violet",
			"Clean White",
		},
		ValueImages = {
			Rainbow = "sparkles",
			["Neon Glow"] = "zap",
			["Animated Typing"] = "terminal",
			["Pulse Breathe"] = "activity",
			["Cyber Glitch"] = "binary",
			["Gold Elegance"] = "crown",
			["Fire Flame"] = "flame",
			["Ice Frost"] = "snowflake",
			["Electric Violet"] = "atom",
			["Clean White"] = "circle",
		},
		Default = "Neon Glow",
		Callback = function()
			F_001820()
		end,
	})

	U1140:AddLabel("Main Color"):AddColorPicker("CustomTextColor", {
		Default = Color3.fromRGB(0, 255, 170),
		Title = "Main Color",
		Callback = function()
		end,
	})

	U1140:AddDivider()
end

do
	local L0_412 = U92.UISettings:AddGroupbox({
		Side = 2,
		Name = "<b>Background</b>",
		IconName = "image",
		Description = "Custom bg",
		MaxPopOutHeight = 600,
		PopOutWidth = 250,
	})

	local U1141 = ""
	local U1142 = false

	local function F_001832(A1832_1, A1832_2)
		if not A1832_1 or A1832_1 == "" then
			pcall(function()
				if U62.SetBackgroundImage then
					U62:SetBackgroundImage("")
				end

				if U62.MainFrame and U62.MainFrame:FindFirstChild("ST_CustomBackground") then
					U62.MainFrame.ST_CustomBackground.Visible = false
					U62.MainFrame.ST_CustomBackground.Image = ""
				end
			end)

			return
		end

		if tonumber(A1832_1) then
			A1832_1 = "rbxassetid://" .. tostring(A1832_1)
		end

		pcall(function()
			if U62.SetBackgroundImage then
				U62:SetBackgroundImage(A1832_1)
			end
		end)

		pcall(function()
			if U62.MainFrame then
				local L1835_1 = U62.MainFrame:FindFirstChild("ST_CustomBackground")

				if not L1835_1 then
					local L1835_2 = Instance.new("ImageLabel")
					L1835_2.Name = "ST_CustomBackground"
					L1835_2.Size = UDim2.fromScale(1, 1)
					L1835_2.Position = UDim2.fromScale(0, 0)
					L1835_2.BackgroundTransparency = 1
					L1835_2.ScaleType = Enum.ScaleType.Crop
					L1835_2.ZIndex = 0
					L1835_2.Parent = U62.MainFrame
					local L1835_3 = U62.MainFrame:FindFirstChildOfClass("UICorner")

					if L1835_3 then
						L1835_3:Clone().Parent = L1835_2
						L1835_1 = L1835_2
					else
						L1835_1 = L1835_2
					end
				end

				L1835_1.Image = A1832_1
				L1835_1.ImageTransparency = A1832_2 or U65.BackgroundTransparency and U65.BackgroundTransparency.Value or 0
				L1835_1.Visible = true
			end
		end)
	end

	L0_412:AddInput("BackgroundId", {
		Default = "",
		Numeric = false,
		Finished = false,
		Text = "Background ID",
		Placeholder = "Enter image URL / Asset ID",
		Callback = function(A1836_1)
			U1141 = A1836_1

			if U1142 then
				F_001832(U1141, U65.BackgroundTransparency and U65.BackgroundTransparency.Value or 0)
			end
		end,
	})

	L0_412:AddToggle("ToggleBackground", {
		Text = "<b>Toggle Background</b>",
		Default = false,
		Callback = function(A1837_1)
			U1142 = A1837_1

			if A1837_1 then
				F_001832(U1141, U65.BackgroundTransparency and U65.BackgroundTransparency.Value or 0)
			else
				F_001832("")
			end
		end,
	})

	L0_412:AddSlider("BackgroundTransparency", {
		Text = "Background Transparency",
		Default = 0,
		Min = 0,
		Max = 1,
		Rounding = 2,
		Compact = true,
		Callback = function(A1838_1)
			if U1142 then
				F_001832(U1141, A1838_1)
			end
		end,
	})
end

do
	local U1143 = 60
	local U1144 = 0
	local U1145 = 0
	local U1146 = tick()

	U69.RenderStepped:Connect(function()
		U1145 += 1
	end)

	task.spawn(function()
		while true do
			task.wait(0.4)
			local L1840_1 = tick()
			local L1840_2 = L1840_1 - U1146

			if L1840_2 > 0 then
				U1143 = math.floor(U1145 / L1840_2)
			end

			U1145 = 0
			U1146 = L1840_1
			local U1147 = 0

			pcall(function()
				local L1841_1 = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]

				if L1841_1 then
					local L1841_2 = L1841_1:GetValue()

					if L1841_2 and L1841_2 > 0 then
						U1147 = math.floor(L1841_2)
					else
						local L1841_3 = tonumber(L1841_1:GetValueString():match("[%d%.]+"))

						if L1841_3 then
							U1147 = math.floor(L1841_3)
						end
					end
				end
			end)

			if U1147 <= 0 then
				pcall(function()
					U1147 = math.floor(U68:GetNetworkPing() * 1000)
				end)
			end

			if U1147 <= 0 then
				U1147 = math.random
				U1147 = U1147(15, 65)
			end

			U1144 = U1147
			_G.ST_cachedPing = U1147
			local U1148 = math.floor(tick() - U74)
			local U1149 = _G.ST_UICache or {}
			_G.ST_UICache = U1149

			pcall(function()
				local L1843_1 = U1148 % 60
				local L1843_2 = string.format("%02d:%02d:%02d", math.floor(U1148 / 3600), math.floor(U1148 % 3600 / 60), L1843_1)
				local L1843_3 = "Elapsed time: <b>" .. tostring(U1148) .. " seconds</b>"

				if ElapsedTimeLabel and U1149.t1 ~= L1843_3 then
					U1149.t1 = L1843_3
					ElapsedTimeLabel:SetText(L1843_3)
				end

				local L1843_4 = "Current time: <b>" .. os.date("%H:%M") .. "</b>"

				if CurrentTimeLabel and U1149.t2 ~= L1843_4 then
					U1149.t2 = L1843_4
					CurrentTimeLabel:SetText(L1843_4)
				end

				local L1843_5 = "Ping: <b>" .. tostring(U1144) .. "ms</b>"

				if HomePingLabel and U1149.t3 ~= L1843_5 then
					U1149.t3 = L1843_5
					HomePingLabel:SetText(L1843_5)
				end

				if PingLabel and U1149.t3b ~= L1843_5 then
					U1149.t3b = L1843_5
					PingLabel:SetText(L1843_5)
				end

				local L1843_6 = "FPS: <b>" .. tostring(U1143) .. "</b>"

				if HomeFpsLabel and U1149.t4 ~= L1843_6 then
					U1149.t4 = L1843_6
					HomeFpsLabel:SetText(L1843_6)
				end

				if FpsLabel and U1149.t4b ~= L1843_6 then
					U1149.t4b = L1843_6
					FpsLabel:SetText(L1843_6)
				end

				local L1843_7 = U62.Scheme.FontColor or Color3.new(1, 1, 1)

				if U81 then
					local L1843_8 = "Elapsed time: <b>" .. L1843_2 .. "</b>"

					if U81.Text ~= L1843_8 then
						U81.Text = L1843_8
					end

					if U81.TextColor3 ~= L1843_7 then
						U81.TextColor3 = L1843_7
					end
				end

				if U82 then
					local L1843_9 = "Kicked Players: <b>" .. tostring(U86) .. "</b>"

					if U82.Text ~= L1843_9 then
						U82.Text = L1843_9
					end

					if U82.TextColor3 ~= L1843_7 then
						U82.TextColor3 = L1843_7
					end
				end

				if U83 then
					local L1843_10 = "User: <b>@" .. U68.Name .. "</b>"

					if U83.Text ~= L1843_10 then
						U83.Text = L1843_10
					end

					if U83.TextColor3 ~= L1843_7 then
						U83.TextColor3 = L1843_7
					end
				end

				local L1843_11 = tostring(U1143) .. " fps"

				if U79 and U79.Text ~= L1843_11 then
					U79.Text = L1843_11
				end

				local L1843_12 = tostring(U1144) .. " ms"

				if U80 and U80.Text ~= L1843_12 then
					U80.Text = L1843_12
				end

				local L1843_13 = true

				if U66.ShowOnScreen ~= nil then
					L1843_13 = U66.ShowOnScreen.Value
				end

				if L1843_13 then
					if U79 and not U79.Visible then
						U79.Visible = true
					end

					if U80 and not U80.Visible then
						U80.Visible = true
					end

					if U84 and not U84.Visible then
						U84.Visible = true
					end

					if U85 and not U85.Visible then
						U85.Visible = true
					end

					if U77 then
						if not U77.Visible and U1143 < 30 then
							U77.Visible = true
						elseif U77.Visible and U1143 >= 30 then
							U77.Visible = false
						end
					end

					if U78 then
						if not U78.Visible and U1144 > 300 then
							U78.Visible = true
						elseif U78.Visible and U1144 <= 300 then
							U78.Visible = false
						end
					end
				else
					if U79 and U79.Visible then
						U79.Visible = false
					end

					if U80 and U80.Visible then
						U80.Visible = false
					end

					if U84 and U84.Visible then
						U84.Visible = false
					end

					if U85 and U85.Visible then
						U85.Visible = false
					end

					if U77 and U77.Visible then
						U77.Visible = false
					end

					if U78 and U78.Visible then
						U78.Visible = false
					end
				end
			end)
		end
	end)
end

task.spawn(function()
	local U1150 = _G.ST_UICache or {}

	while true do
		pcall(function()
			local L1845_1 = U68.Character
			local L1845_2 = L1845_1 and L1845_1:FindFirstChild("Humanoid")
			local L1845_3 = U68:FindFirstChild("IsHeld")
			local L1845_4

			if not L1845_1 or not L1845_2 or L1845_2.Health <= 0 then
				L1845_4 = "Dead"
			elseif L1845_3 and L1845_3.Value then
				L1845_4 = "Held"
			else
				L1845_4 = "Alive"

				if L1845_2.Sit then
					L1845_4 = "Ragdoll / Seated"
				end
			end

			local L1845_5 = "PlayerStatus: <b>" .. L1845_4 .. "</b>"

			if PlayerStatusLabel and U1150.t10 ~= L1845_5 then
				U1150.t10 = L1845_5
				PlayerStatusLabel:SetText(L1845_5)
			end

			local L1845_6 = U89()
			local L1845_7 = "LastPlayerGrabbedYou: <b>" .. (L1845_6 and L1845_6.DisplayName .. " (@" .. L1845_6.Name .. ")" or "None") .. "</b>"

			if LastPlayerLabel and L1845_6 and U1150.t11 ~= L1845_7 then
				U1150.t11 = L1845_7
				LastPlayerLabel:SetText(L1845_7)
			end
		end)

		task.wait(0.1)
	end
end)

local function F_001846()
	local U1151 = U87()

	for I835, I836 in ipairs({
		"NoBlobmanTarget",
		"BlobmanTarget",
		"ToyKillTarget",
		"PosesTarget",
		"SilentAimTargets",
		"AimbotTargets",
		"PlayerSelect",
		"MiscTarget",
		"WhitelistPlayerSelect",
		"PlayerESPPlayers",
		"PCLDESPPlayers",
		"ThirdPartyTarget",
	}) do
		if U65[I836] then
			pcall(function()
				U65[I836]:SetValues(U1151)
			end)
		end
	end
end

U67.PlayerAdded:Connect(function()
	task.wait(1)
	F_001846()
end)

U67.PlayerRemoving:Connect(function()
	task.wait(0.5)
	F_001846()
end)

U63:SetLibrary(U62)

pcall(function()
	U64:SetLibrary(U62)

	U63:SetDefaultTheme({
		FontColor = Color3.fromHex("ffffff"),
		MainColor = Color3.fromHex("111111"),
		AccentColor = Color3.fromHex("ffffff"),
		BackgroundColor = Color3.fromHex("0a0a0a"),
		OutlineColor = Color3.fromHex("292929"),
		FontFace = Enum.Font.Gotham,
	})

	U64:IgnoreThemeSettings()

	U64:SetIgnoreIndexes({
		"MenuKeybind",
		"ThirdPersonToggle",
		"CustomSkybox",
		"EnableShader",
		"SelectSkybox",
		"SelectShader",
		"EnablePresets",
		"Preset",
		"EnvBrightness",
		"EnvClockTime",
		"FogDistance",
	})

	U63:SetFolder("SilentTarget")
	U64:SetFolder("SilentTarget/FlingThings")
	U64:SetSubFolder("game-config")
end)

U63.CreateGroupBox = function(A1851_1, A1851_2, A1851_3)
	return A1851_2:AddGroupbox({
		Side = "Left",
		Name = "<b>Theme</b>",
		IconName = A1851_3 or "paintbrush",
		MaxPopOutHeight = 600,
		PopOutWidth = 250,
	})
end

local U1152 = U63.CreateThemeManager

U63.CreateThemeManager = function(A1852_1, A1852_2)
	local U1153 = A1852_2.AddLabel

	A1852_2.AddLabel = function(A1853_1, A1853_2, ...)
		local L1853_1 = type(A1853_2) == "table"
		local L1853_2 = L1853_1 and A1853_2.Text or A1853_2

		if type(L1853_2) == "string" then
			if L1853_2:find("Background color") then
				if L1853_1 then
					A1853_2.Text = "<b>Background color</b>"
				else
					A1853_2 = "<b>Background color</b>"
				end
			elseif L1853_2:find("Main color") then
				A1853_1:AddDivider()

				if L1853_1 then
					A1853_2.Text = "<b>Main color</b>"
				else
					A1853_2 = "<b>Main color</b>"
				end
			elseif L1853_2:find("Accent color") then
				A1853_1:AddDivider()

				if L1853_1 then
					A1853_2.Text = "<b>Accent color</b>"
				else
					A1853_2 = "<b>Accent color</b>"
				end
			elseif L1853_2:find("Outline color") then
				A1853_1:AddDivider()

				if L1853_1 then
					A1853_2.Text = "<b>Outline color</b>"
				else
					A1853_2 = "<b>Outline color</b>"
				end
			elseif L1853_2:find("Font color") then
				A1853_1:AddDivider()

				if L1853_1 then
					A1853_2.Text = "<b>Font color</b>"
				else
					A1853_2 = "<b>Font color</b>"
				end
			elseif L1853_2:find("Contrast check") then
				A1853_1:AddDivider()

				if L1853_1 then
					A1853_2.Text = "<b>Contrast check:</b> n/a"
				else
					A1853_2 = "<b>Contrast check:</b> n/a"
				end

				local U1154 = U1153(A1853_1, A1853_2, ...)

				if U1154 and U1154.TextLabel then
					pcall(function()
						U1154.TextLabel.RichText = true
					end)
				end

				A1853_1:AddDivider()
				return U1154
			end
		end

		local U1155 = U1153(A1853_1, A1853_2, ...)

		if U1155 and U1155.TextLabel then
			pcall(function()
				U1155.TextLabel.RichText = true
			end)
		end

		return U1155
	end

	return (U1152(A1852_1, A1852_2))
end

U63.UpdateContrastWarning = function()
	local L1856_1 = U63.ContrastLabel
	if not L1856_1 or L1856_1.Destroyed then
		return
	end
	local L1856_2 = U63:GetContrastReport()
	local L1856_3 = L1856_1.TextLabel

	if L1856_3 then
		L1856_3.RichText = true
	end

	local L1856_4

	if L1856_2.Ratio >= 4.5 then
		L1856_4 = "<font color=\"#55e87a\">good</font>"
	elseif L1856_2.Ratio >= 3 then
		L1856_4 = "<font color=\"#ffcc00\">fair</font>"
	else
		L1856_4 = "<font color=\"#ff5050\">poor</font>"
	end

	L1856_1:SetText(string.format("<b>Contrast check:</b> %s (%.1f:1)", L1856_4, L1856_2.Ratio))
end

local U1156 = U64.BuildConfigSection

U64.BuildConfigSection = function(A1857_1, A1857_2, A1857_3)
	local U1157 = A1857_2.AddGroupbox

	A1857_2.AddGroupbox = function(A1858_1, A1858_2)
		if type(A1858_2) == "table" and (A1858_2.Name == "Configuration" or tostring(A1858_2.Name):find("Configuration")) then
			A1858_2.Name = "<b>Configuration</b>"
		end

		local L1858_1 = U1157(A1858_1, A1858_2)
		local L1858_2

		if A1858_2 then
			L1858_2 = A1858_2.Name == "<b>Configuration</b>" or tostring(A1858_2.Name):find("Configuration")
		else
			L1858_2 = A1858_2
		end

		if L1858_2 then
			local U1158 = L1858_1.AddInput

			L1858_1.AddInput = function(A1859_1, A1859_2, A1859_3)
				if type(A1859_3) == "table" and A1859_3.Text and not A1859_3.Text:find("<b>") then
					A1859_3.Text = "<b>" .. A1859_3.Text .. "</b>"
				end

				return U1158(A1859_1, A1859_2, A1859_3)
			end

			local U1159 = L1858_1.AddDropdown

			L1858_1.AddDropdown = function(A1860_1, A1860_2, A1860_3)
				if type(A1860_3) == "table" and A1860_3.Text and not A1860_3.Text:find("<b>") then
					A1860_3.Text = "<b>" .. A1860_3.Text .. "</b>"
				end

				return U1159(A1860_1, A1860_2, A1860_3)
			end

			local U1160 = L1858_1.AddLabel

			L1858_1.AddLabel = function(A1861_1, A1861_2, ...)
				if type(A1861_2) == "string" and not A1861_2:find("<b>") then
					A1861_2 = "<b>" .. A1861_2 .. "</b>"
				elseif type(A1861_2) == "table" and A1861_2.Text and not A1861_2.Text:find("<b>") then
					A1861_2.Text = "<b>" .. A1861_2.Text .. "</b>"
				end

				local U1161 = U1160(A1861_1, A1861_2, ...)

				if U1161 and U1161.TextLabel then
					pcall(function()
						U1161.TextLabel.RichText = true
						U1161.TextLabel.Font = Enum.Font.GothamBold
					end)

					local U1162 = U1161.SetText

					U1161.SetText = function(A1863_1, A1863_2)
						if type(A1863_2) == "string" and not A1863_2:find("<b>") then
							A1863_2 = "<b>" .. A1863_2 .. "</b>"
						end

						return U1162(A1863_1, A1863_2)
					end
				end

				return U1161
			end

			local U1163 = L1858_1.AddButton

			L1858_1.AddButton = function(A1864_1, ...)
				local L1864_1 = { ... }

				if type(L1864_1[1]) == "table" and L1864_1[1].Text and not L1864_1[1].Text:find("<b>") then
					L1864_1[1].Text = "<b>" .. L1864_1[1].Text .. "</b>"
				elseif type(L1864_1[1]) == "string" and not L1864_1[1]:find("<b>") then
					L1864_1[1] = "<b>" .. L1864_1[1] .. "</b>"
				end

				local U1164 = U1163(A1864_1, unpack(L1864_1))

				if U1164 and U1164.Base then
					pcall(function()
						U1164.Base.RichText = true
						U1164.Base.Font = Enum.Font.GothamBold
					end)
				end

				return U1164
			end
		end

		return L1858_1
	end

	local L1857_1 = U1156(A1857_1, A1857_2, A1857_3)
	A1857_2.AddGroupbox = U1157
	return L1857_1
end

pcall(function()
	U63:ApplyToTab(U92.UISettings)
end)

pcall(function()
	U65.BackgroundImage.Main.Visible = false
end)

pcall(function()
	U65.BackgroundImage.Visible = false
end)

pcall(function()
	U64:BuildConfigSection(U92.UISettings)
end)

U62.Scheme.AccentColor = Color3.fromHex("ffffff")
U62.Scheme.OutlineColor = Color3.fromHex("292929")
U62.Scheme.MainColor = Color3.fromHex("111111")
U62.Scheme.BackgroundColor = Color3.fromHex("0a0a0a")
U62.Scheme.FontColor = Color3.fromHex("ffffff")
U62:SetFont(Enum.Font.Gotham)
U62:UpdateColorsUsingRegistry()

pcall(function()
	U62:SetWatermarkVisibility(true)
	U62:SetWatermark("<b>Silent Target</b> | 0 fps | 0 ms")
end)

U94(20)
local L0_413 = Instance.new("Sound")
L0_413.SoundId = "rbxassetid://129485210015224"
L0_413.Volume = 1
L0_413.Parent = game:GetService("SoundService")
L0_413:Play()
U72:AddItem(L0_413, 5)

U62:Notify({
	Title = "<b>Silent Target</b>",
	Description = "Script loaded successfully",
	Duration = 5,
	BigIcon = U76,
})

task.defer(function()
	task.wait(0.15)

	pcall(function()
		if U91 and U91.Show then
			U91:Show()
		elseif U91 and U91.Toggle then
			U91:Toggle(true)
		elseif U62 and U62.Show then
			U62:Show()
		end
	end)

	pcall(function()
		if U92 and U92.Home and U92.Home.Button then
			local L1873_1 = U92.Home.Button:FindFirstChildWhichIsA("ImageLabel", true)
			U93(U92.Home.Button, L1873_1)
		end
	end)
end)

pcall(function()
	U64:LoadAutoloadConfig()
end)

pcall(function()
	if isfile and readfile and isfile("SilentTarget_HomeConfig.json") then
		local L1875_1 = readfile("SilentTarget_HomeConfig.json")
		local L1875_2 = game:GetService("HttpService"):JSONDecode(L1875_1)

		if L1875_2 then
			if L1875_2.AutoAntiLag then
				task.spawn(function()
					task.wait(0.5)

					if U66.AntiLag then
						U66.AntiLag:SetValue(true)
					end

					if U66.HomeAutoAntiLag then
						U66.HomeAutoAntiLag:SetValue(true)
					end

					if U66.AutoAntiLag then
						U66.AutoAntiLag:SetValue(true)
					end
				end)
			end

			if L1875_2.AutoExecute and U66.HomeAutoExecute then
				U66.HomeAutoExecute:SetValue(true)
			end
		end
	end
end)

if U66.ThirdPersonToggle then
	U66.ThirdPersonToggle:SetValue(true)
end

if U66.ToggleAimTeleport then
	U66.ToggleAimTeleport:SetValue(true)
end

task.spawn(function()
	task.wait(0.6)

	if U66.ToggleAimTeleport and not U66.ToggleAimTeleport.Value then
		U66.ToggleAimTeleport:SetValue(true)
	end
end)

task.defer(function()
	task.wait(0.1)

	pcall(function()
		if typeof(moveSlidingBoxTo) == "function" and U92.Home and U92.Home.Button then
			moveSlidingBoxTo(U92.Home)
		end
	end)
end)

print("Silent Target ready")

pcall(function()
	if getgenv then
		getgenv().SilentTarget_Library = U62

		getgenv().SilentTarget_Unload = function()
			pcall(function()
				if U62 and not U62.Unloaded then
					U62:Unload()
				end
			end)

			pcall(function()
				local L1883_1 = typeof(gethui) == "function" and gethui() or game:GetService("CoreGui")

				if L1883_1 then
					for I837, I838 in ipairs(L1883_1:GetChildren()) do
						if I838.Name == "ST_WatermarkFrame" or I838.Name == "ST_IronManHUD" or I838.Name == "Obsidian" or I838.Name:find("SilentTarget") or I838.Name:find("Obsidian") or I838.Name == "NeuroniumStickyUI" or I838.Name == "FakePosUI" or I838.Name:find("urban1") then
							pcall(function()
								I838:Destroy()
							end)
						end
					end
				end

				local U1165 = workspace:FindFirstChild("ST_IronManSuitContainer")

				if U1165 then
					pcall(function()
						U1165:Destroy()
					end)
				end
			end)
		end
	end
end)
