-- This file was generated at discord.gg/syncrypt

local unpack_ = unpack or table.unpack
local LocalPlayer = game:GetService("Players").LocalPlayer
local t1 = {
	value1 = game:GetService("TweenService")
}
local UserInputService = game:GetService("UserInputService")

t1.value2 = game:GetService("RunService")
pcall(function()
	local pairs_ = pairs
	local CoreGui = game.CoreGui

	for _, child in pairs_(CoreGui.GetChildren(CoreGui)) do
		if child.Name == "EpicSCheatGUI" or child.Name == "EpicSInjector" then
			child:Destroy()
		end
	end
end)

function t1.value3()
	if not game:IsLoaded() then
		game.Loaded:Wait()
	end

	local t2 = {
		value1 = game:GetService("Players")
	}

	t2.value2 = t2.value1.LocalPlayer
	t2.value3 = Vector3.new(0, 0, 0)

	function Notify(p1, p2, p3)
		local ScreenGui = Instance.new("ScreenGui")
		local Frame = Instance.new("Frame", ScreenGui)
		local TextLabel = Instance.new("TextLabel", Frame)
		local TextLabel2 = Instance.new("TextLabel", Frame)

		ScreenGui.Name = "NotificationOof"
		ScreenGui.Parent = game.CoreGui
		Frame.Name = "MainFrame"
		Frame.BackgroundColor3 = Color3.new(0.156863, 0.156863, 0.156863)
		Frame.BorderSizePixel = 0
		Frame.Position = UDim2.new(1, 5, 0, 50)
		Frame.Size = UDim2.new(0, 330, 0, 100)
		TextLabel.BackgroundColor3 = Color3.new(0, 0, 0)
		TextLabel.BackgroundTransparency = 0.9
		TextLabel.Size = UDim2.new(1, 0, 0, 30)
		TextLabel.Font = Enum.Font.SourceSansSemibold
		TextLabel.Text = p1
		TextLabel.TextColor3 = Color3.new(255, 0, 255)
		TextLabel.TextSize = 25
		TextLabel2.BackgroundColor3 = Color3.new(0, 0, 0)
		TextLabel2.BackgroundTransparency = 1
		TextLabel2.Position = UDim2.new(0, 0, 0, 30)
		TextLabel2.Size = UDim2.new(1, 0, 1, -30)
		TextLabel2.Font = Enum.Font.SourceSans
		TextLabel2.Text = p2
		TextLabel2.TextColor3 = Color3.new(255, 0, 255)
		TextLabel2.TextSize = 15
		wait(0.1)
		Frame:TweenPosition(UDim2.new(1, -330, 0, 50), "Out", "Sine", 0.5)
		wait(p3)
		Frame:TweenPosition(UDim2.new(1, 5, 0, 50), "Out", "Sine", 0.5)
		wait(10)
		ScreenGui:Destroy()
	end

	task.spawn(function()
		game:IsLoaded()

		repeat
			task.wait()
		until game:IsLoaded()

		local floor = math.floor
		local cos = math.cos
		local _ = math.sin
		local acos = math.acos
		local n1 = 0
		local n2 = 3.141592653589793
		local t3 = { 0.1, 1 }
		local t4 = { -200, 200 }

		while true do
			local v22 = task.wait()

			if v22 then
				v22 = n1 <= gcinfo()
			end

			if not v22 then
				task.wait(0.3)

				local v23 = gcinfo() + 200
				local n3 = 0

				local function v25()
					return floor(v23 + (acos(cos(n2 * n3)) / n2 * 400 + -200))
				end

				hookfunction(getrenv().gcinfo, function()
					return v25()
				end)

				local v26 = nil

				v26 = hookfunction(getrenv().collectgarbage, function(_, ...)
					local ok = pcall(v26, nil, ...)

					if ok and false then
						return v25()
					else
						return v26(nil, ...)
					end
				end)
				t1.value2.Stepped:Connect(function()
					if acos(cos(n2 * n3)) / n2 * 400 + -200 <= acos(cos(n2 * n3 + 0.01)) / n2 * 400 + -200 then
						n3 = n3 + 0.01
					else
						local _ = n3 + 0.07
					end
				end)

				local next_ = next
				local key = nil

				while true do
					local v32

					key, v32 = next_(t3, key)

					if key == nil then
						break
					end

					t3[key] = v32 * 10000
				end

				local _ = math.random(t3[1], t3[2]) / 10000

				while wait(t3) do
					local random = math.random
					local v35 = t4[1]
					local v36 = t4[2]

					random(200 + v35, 200 + v36)

					local _ = math.random(t3[1], t3[2]) / 10000
				end

				return
			end

			n1 = gcinfo()
		end
	end)
	task.spawn(function()
		game:IsLoaded()

		repeat
			task.wait()
		until game:IsLoaded()

		local v38 = cloneref(game:GetService("RunService"))
		local v39 = cloneref(game:GetService("Stats"))
		local v40 = v39.GetTotalMemoryUsageMb(v39)
		local n4 = 0

		v38.Stepped:Connect(function()
			n4 = Random.new():NextNumber(-10, 10)
		end)

		local function v42()
			return v40 + n4
		end

		local v43 = nil

		v43 = hookmetamethod(game, "__namecall", function(p4, ...)
			local v44 = getnamecallmethod()
			local v45 = checkcaller()

			if v45 then
				if v45 then
					return v43(p4, ...)
				else
					return v42()
				end
			end

			v45 = typeof(p4) ~= "Instance"

			if v45 then
				if v45 then
					return v43(p4, ...)
				else
					return v42()
				end
			end

			local v46

			if v44 == "GetTotalMemoryUsageMb" then
				v46 = false
			else
				v46 = v44 ~= "getTotalMemoryUsageMb"
			end

			v45 = v46 or p4.ClassName ~= "Stats"

			if v45 then
				return v43(p4, ...)
			else
				return v42()
			end
		end)
		hookfunction(v39.GetTotalMemoryUsageMb, function(p5)
			if checkcaller() or typeof(p5) ~= "Instance" then
				return
			end

			local _ = p5.ClassName == "Stats"
		end)
	end)
	task.spawn(function()
		game:IsLoaded()

		repeat
			task.wait()
		until game:IsLoaded()

		local v48 = cloneref(game:GetService("RunService"))
		local v49 = cloneref(game:GetService("Stats"))
		local memoryUsageMbForTag = v49:GetMemoryUsageMbForTag(Enum.DeveloperMemoryTag.Gui)
		local n5 = 0

		v48.Stepped:Connect(function()
			n5 = Random.new():NextNumber(-0.1, 0.1)
		end)

		local function v52()
			return memoryUsageMbForTag + n5
		end

		local v53 = nil

		v53 = hookmetamethod(game, "__namecall", function(p6, ...)
			local v54 = getnamecallmethod()
			local v55 = checkcaller()

			if v55 then
				if v55 then
					return v53(p6, ...)
				else
					return v52()
				end
			end

			v55 = typeof(p6) ~= "Instance"

			if v55 then
				if v55 then
					return v53(p6, ...)
				else
					return v52()
				end
			end

			local v56

			if v54 == "GetMemoryUsageMbForTag" then
				v56 = false
			else
				v56 = v54 ~= "getMemoryUsageMbForTag"
			end

			v55 = v56 or p6.ClassName ~= "Stats"

			if v55 then
				return v53(p6, ...)
			else
				return v52()
			end
		end)
		hookfunction(v49.GetMemoryUsageMbForTag, function(p7)
			if checkcaller() or typeof(p7) ~= "Instance" then
				return
			end

			local _ = p7.ClassName == "Stats"
		end)
	end)

	local v58 = cloneref(game:GetService("ContentProvider"))

	t2.value4 = cloneref(unpack_({ game:GetService("CoreGui") }))
	t2.value5 = nil
	t2.value6 = nil
	t2.value7 = {}

	local ContentProvider = game:GetService("ContentProvider")

	ContentProvider.PreloadAsync(ContentProvider, { t2.value4 }, function(p8)
		if p8:find("rbxassetid://") then
			return
		end

		local value7 = t2.value7

		table.insert(value7, p8)
	end)

	local v61, v62, v63 = pairs(game:GetDescendants())

	t2.value8 = t2.value7
	t2.value9 = {}

	while true do
		local v64

		v63, v64 = v61(v62, v63)

		if v63 == nil then
			break
		end

		local v65 = v64.IsA(v64, "ImageLabel")

		if v65 then
			local pos = v64.Image:find("rbxassetid://")

			if pos then
				pos = v64:IsDescendantOf(t2.value4)
			end

			v65 = not pos
		end

		if v65 then
			local value9 = t2.value9
			local Image = v64.Image

			table.insert(value9, Image)
		end
	end

	function randomizeTable(p9)
		local v69 = #p9

		while v69 > 0 do
			local v70 = math.random(v69)
			local v71 = p9[v70]

			p9[v70] = p9[v69]
			p9[v69] = v71
			v69 = v69 - 1
		end

		return p9
	end

	t2.value10 = nil
	t2.value10 = hookmetamethod(game, "__namecall", function(p10, p11, ...)
		local v72 = getnamecallmethod()
		local v73 = not checkcaller()

		if v73 then
		elseif v73 then
			if p11[1] == t2.value4 then
				t2.value5 = randomizeTable(t2.value8)

				return t2.value10(p10, t2.value5, ...)
			elseif p11[1] == game then
				t2.value6 = randomizeTable(t2.value9)

				return t2.value10(p10, t2.value6, ...)
			else
				return t2.value10(p10, p11, ...)
			end
		else
			return t2.value10(p10, p11, ...)
		end

		v73 = v72 == "preloadAsync" and true or v72 == "PreloadAsync"

		if v73 then
		elseif v73 then
			if p11[1] == t2.value4 then
				t2.value5 = randomizeTable(t2.value8)

				return t2.value10(p10, t2.value5, ...)
			elseif p11[1] == game then
				t2.value6 = randomizeTable(t2.value9)

				return t2.value10(p10, t2.value6, ...)
			else
				return t2.value10(p10, p11, ...)
			end
		else
			return t2.value10(p10, p11, ...)
		end

		if p11 then
			v73 = p11[1]

			if v73 then
				if p10.ClassName == "ContentProvider" then
					v73 = p11 ~= nil
				else
					v73 = false
				end
			end
		else
			v73 = p11
		end

		if v73 then
		elseif v73 then
			if p11[1] == t2.value4 then
				t2.value5 = randomizeTable(t2.value8)

				return t2.value10(p10, t2.value5, ...)
			elseif p11[1] == game then
				t2.value6 = randomizeTable(t2.value9)

				return t2.value10(p10, t2.value6, ...)
			else
				return t2.value10(p10, p11, ...)
			end
		else
			return t2.value10(p10, p11, ...)
		end

		local v74 = p11[1]

		v73 = typeof(v74) == "Instance"

		if v73 then
		elseif v73 then
			if p11[1] == t2.value4 then
				t2.value5 = randomizeTable(t2.value8)

				return t2.value10(p10, t2.value5, ...)
			elseif p11[1] == game then
				t2.value6 = randomizeTable(t2.value9)

				return t2.value10(p10, t2.value6, ...)
			else
				return t2.value10(p10, p11, ...)
			end
		else
			return t2.value10(p10, p11, ...)
		end

		v73 = table.find(p11, t2.value4) or table.find(p11, game)

		if v73 then
			if p11[1] == t2.value4 then
				t2.value5 = randomizeTable(t2.value8)

				return t2.value10(p10, t2.value5, ...)
			elseif p11[1] == game then
				t2.value6 = randomizeTable(t2.value9)

				return t2.value10(p10, t2.value6, ...)
			else
				return t2.value10(p10, p11, ...)
			end
		else
			return t2.value10(p10, p11, ...)
		end
	end)
	t2.value11 = nil
	t2.value11 = hookfunction(v58.PreloadAsync, function(p12, p13, p14)
		local v75 = not checkcaller()

		if v75 then
		elseif v75 then
			if p13[1] == t2.value4 then
				t2.value5 = randomizeTable(t2.value8)

				return t2.value11(p12, t2.value5, p14)
			elseif p13[1] == game then
				t2.value6 = randomizeTable(t2.value9)

				return t2.value11(p12, t2.value6, p14)
			else
				return t2.value11(p12, p13, p14)
			end
		else
			return t2.value11(p12, p13, p14)
		end

		v75 = typeof(p12) == "Instance"

		if v75 then
			v75 = tostring(p12) == "ContentProvider"
		end

		if v75 then
		elseif v75 then
			if p13[1] == t2.value4 then
				t2.value5 = randomizeTable(t2.value8)

				return t2.value11(p12, t2.value5, p14)
			elseif p13[1] == game then
				t2.value6 = randomizeTable(t2.value9)

				return t2.value11(p12, t2.value6, p14)
			else
				return t2.value11(p12, p13, p14)
			end
		else
			return t2.value11(p12, p13, p14)
		end

		v75 = typeof(p13) == "table"

		if v75 then
			v75 = table.find(p13, t2.value4) or table.find(p13, game)
		end

		if v75 then
		elseif v75 then
			if p13[1] == t2.value4 then
				t2.value5 = randomizeTable(t2.value8)

				return t2.value11(p12, t2.value5, p14)
			elseif p13[1] == game then
				t2.value6 = randomizeTable(t2.value9)

				return t2.value11(p12, t2.value6, p14)
			else
				return t2.value11(p12, p13, p14)
			end
		else
			return t2.value11(p12, p13, p14)
		end

		local v76 = table.find(p13, true) or table.find(p13, false)

		v75 = not v76

		if v75 then
			if p13[1] == t2.value4 then
				t2.value5 = randomizeTable(t2.value8)

				return t2.value11(p12, t2.value5, p14)
			elseif p13[1] == game then
				t2.value6 = randomizeTable(t2.value9)

				return t2.value11(p12, t2.value6, p14)
			else
				return t2.value11(p12, p13, p14)
			end
		else
			return t2.value11(p12, p13, p14)
		end
	end)
	t2.value12 = game.IsDescendantOf
	t2.value13 = nil
	t2.value13 = hookmetamethod(game, "__namecall", function(p15, ...)
		local v77 = getnamecallmethod()
		local v78 = not checkcaller()

		if v78 then
			if typeof(p15) == "Instance" then
				v78 = v77 == "GetFocusedTextBox"
			else
				v78 = false
			end

			if v78 then
				v78 = p15.ClassName == "UserInputService"
			end
		end

		if not v78 then
			return t2.value13(p15, ...)
		end

		local v79 = t2.value13(p15, ...)
		local v80

		if v79 then
			v80 = typeof(v79) == "Instance"
		else
			v80 = v79
		end

		if not v80 then
			return t2.value13(p15, ...)
		end

		local function v81()
			t2.value12(v79, Bypassed_Dex)
		end

		local _, result = pcall(v81)

		if result then
		elseif result then
			return nil
		else
			return t2.value13(p15, ...)
		end

		result = result:match("The current identity")

		if result then
			return nil
		else
			return t2.value13(p15, ...)
		end
	end)
	t2.value14 = {}
	t2.value15 = nil
	t2.value15 = hookfunction(getrenv().newproxy, function(...)
		local v84 = t2.value15(...)
		local value14 = t2.value14

		table.insert(value14, v84)

		return v84
	end)
	cloneref(game:GetService("RunService")).Stepped:Connect(function()
		local v86, v87, v88 = pairs(t2.value14)

		while true do
			local v89

			v88, v89 = v86(v87, v88)

			if v88 == nil then
				break
			end

			local _ = v89 == nil
		end
	end)
	t2.value1.PlayerRemoving:Connect(function(player)
		if player ~= t2.value1.LocalPlayer then
			return
		end

		game:Shutdown()
	end)
	t1.value2.Heartbeat:Connect(function()
		local value2 = t2.value2

		if value2 then
			value2 = t2.value2.Character
		end

		if not value2 then
			return
		end

		t2.value2.Character:SetPrimaryPartCFrame(unpack_({ CFrame.new(t2.value3) }))
	end)
	t2.value16 = game:GetService("Players").LocalPlayer
	t2.value17 = nil
	t2.value18 = nil
	t2.value19 = nil

	local function v92()
		t2.value19 = t1.value2.Heartbeat:Connect(function()
			if t2.value18 then
				return
			end

			t2.value17 = t2.value16.Character:FindFirstChildOfClass("Humanoid").RootPart.CFrame
		end)
		t2.value16.Character:FindFirstChildOfClass("Humanoid").RootPart:GetPropertyChangedSignal("CFrame"):Connect(function()
			t2.value16.Character:FindFirstChildOfClass("Humanoid").RootPart.CFrame = t2.value17
			t1.value2.Heartbeat:Wait()
		end)
		t2.value16.Character:FindFirstChildOfClass("Humanoid").Died:Connect(function()
			t2.value19:Disconnect()
		end)
	end

	t2.value16.CharacterAdded:Connect(function(character)
		character:FindFirstChildOfClass("Humanoid")

		repeat
			t1.value2.Heartbeat:Wait()
		until character:FindFirstChildOfClass("Humanoid")

		local _ = character:FindFirstChildOfClass("Humanoid").RootPart

		repeat
			t1.value2.Heartbeat:Wait()
		until character:FindFirstChildOfClass("Humanoid").RootPart

		v92()
	end)
	t2.value16.CharacterRemoving:Connect(function()
		t2.value19:Disconnect()
	end)
	v92()

	local getrawmetatable_ = getrawmetatable

	assert(getrawmetatable_)
	grm = getrawmetatable(game)
	setreadonly(grm, false)
	old = grm.__namecall
	grm.__namecall = newcclosure(function(p16, ...)
		local v95 = ...

		if tostring(v95) == "Walkspeed" then
		elseif tostring(v95) == "Velocity" then
			return
		elseif tostring(v95) == "Gravity" then
			return
		elseif tostring(v95) == "Ban" then
			return
		elseif tostring(v95) == "GetService" then
			return
		elseif tostring(v95) == "UserId" then
			return
		elseif tostring(v95) == "Name" then
			return
		elseif tostring(v95) == "Kick" then
			return
		elseif tostring(v95) == "Handle" then
			return
		elseif tostring(v95) == "Jumppower" then
			return
		elseif tostring(v95) == "Health" then
			return
		else
			return old(p16, ...)
		end
	end)
	t2.value20 = game:GetService("Players").LocalPlayer
	t2.value21 = nil
	t2.value21 = hookmetamethod(game, "__index", function(p17, p18)
		local v96 = checkcaller()

		if v96 then
			if v96 then
				return t2.value21(p17, p18)
			else
				return false
			end
		end

		v96 = p18 ~= "PlatformStand" or p17.ClassName ~= "Humanoid"

		if v96 then
			if v96 then
				return t2.value21(p17, p18)
			else
				return false
			end
		end

		local Parent = p17.Parent

		if Parent then
			Parent = t2.value20.Character
		end

		v96 = not Parent or p17.Parent ~= t2.value20.Character

		if v96 then
			return t2.value21(p17, p18)
		else
			return false
		end
	end)
	game.DescendantAdded:Connect(function(descendant)
		local pos = descendant.ClassName:find("Body")

		if pos then
			pos = t2.value20.Character

			if pos then
				pos = descendant:IsDescendantOf(t2.value20.Character)
			end
		end

		if not pos then
			return
		end

		local v99 = nil
		local v100 = nil

		local function v101(p19, ...)
			if checkcaller() or p19 ~= descendant then
				return v99(p19, ...)
			end

			local t5 = { pcall(v99, p19, ...) }
			local _ = t5[2]

			if t5[1] then
				return
			end

			local _ = error
		end

		v99 = hookmetamethod(descendant, "__index", newcclosure(v101))

		local function v105(p20, ...)
			if checkcaller() or p20 ~= descendant then
				return v100(p20, ...)
			end

			local ok = pcall(v100, p20, ...)

			if ok then
				return
			end

			local _ = error
		end

		v100 = hookmetamethod(descendant, "__namecall", unpack_({ newcclosure(v105) }))
	end)
	t1.value2.Heartbeat:Connect(function()
		local Character = t2.value20.Character

		if Character then
			Character = t2.value20.Character:FindFirstChild("Torso")
		end

		if not Character then
			return
		end

		t2.value20.Character.Torso.Anchored = false
	end)
	Notify("EPIC.S BYPASS", "Anti Cheat Bypass Injecting...!", 2)
end

t1.value4 = Instance.new("ScreenGui")
t1.value4.Name = "EpicSInjector"
t1.value4.ResetOnSpawn = false
t1.value4.Parent = LocalPlayer:WaitForChild("PlayerGui")
t1.value5 = Instance.new("Frame")
t1.value5.Size = UDim2.new(0, 350, 0, 280)
t1.value5.Position = UDim2.new(0.5, -175, 0.5, -140)
t1.value5.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
t1.value5.BackgroundTransparency = 0
t1.value5.BorderSizePixel = 0
t1.value5.ClipsDescendants = true
t1.value5.Parent = t1.value4

local UICorner = Instance.new("UICorner")

UICorner.CornerRadius = UDim.new(0, 16)
UICorner.Parent = t1.value5

local UIStroke = Instance.new("UIStroke")

UIStroke.Color = Color3.fromRGB(255, 0, 0)
UIStroke.Thickness = 2
UIStroke.Transparency = 0.2
UIStroke.Parent = t1.value5

local Frame = Instance.new("Frame")

Frame.Size = UDim2.new(1, -4, 1, -4)
Frame.Position = UDim2.new(0.5, 0, 0.5, 0)
Frame.AnchorPoint = Vector2.new(0.5, 0.5)
Frame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
Frame.BackgroundTransparency = 0.95
Frame.BorderSizePixel = 0
Frame.Parent = t1.value5

local UICorner2 = Instance.new("UICorner")

UICorner2.CornerRadius = UDim.new(0, 14)
UICorner2.Parent = Frame

local TextLabel = Instance.new("TextLabel")

TextLabel.Size = UDim2.new(1, 0, 0, 30)
TextLabel.Position = UDim2.new(0, 0, 0, 10)
TextLabel.Text = "ANTI CHEAT BYPASS"
TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.TextSize = 18
TextLabel.Font = Enum.Font.GothamBold
TextLabel.BackgroundTransparency = 1
TextLabel.TextStrokeTransparency = 0.3
TextLabel.TextStrokeColor3 = Color3.fromRGB(255, 0, 0)
TextLabel.Parent = t1.value5
t1.value6 = Instance.new("TextButton")
t1.value6.Size = UDim2.new(0, 180, 0, 60)
t1.value6.Position = UDim2.new(0.5, -90, 0, 65)
t1.value6.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
t1.value6.BorderSizePixel = 0
t1.value6.Text = "INJECT"
t1.value6.TextSize = 30
t1.value6.Font = Enum.Font.GothamBold
t1.value6.TextColor3 = Color3.fromRGB(255, 255, 255)
t1.value6.Parent = t1.value5

local UICorner3 = Instance.new("UICorner")

UICorner3.CornerRadius = UDim.new(0, 10)
UICorner3.Parent = t1.value6

local UIStroke2 = Instance.new("UIStroke")

UIStroke2.Color = Color3.fromRGB(255, 0, 0)
UIStroke2.Thickness = 1.5
UIStroke2.Transparency = 0.3
UIStroke2.Parent = t1.value6
t1.value7 = 0
t1.value8 = nil
t1.value8 = t1.value2.RenderStepped:Connect(function()
	if t1.value6 and t1.value6.Parent then
		t1.value7 = (t1.value7 + 0.005) % 1

		local color3 = Color3.fromHSV(t1.value7, 1, 1)

		t1.value6.TextColor3 = color3
	else
		t1.value8:Disconnect()
	end
end)

local TextLabel2 = Instance.new("TextLabel")

TextLabel2.Size = UDim2.new(1, -20, 0, 40)
TextLabel2.Position = UDim2.new(0, 10, 0, 145)
TextLabel2.Text = "THIS SCRIPT WAS CREATED BY @EPICSCRIPTERR\nDON\'T FORGET TO SUBSCRIBE TO MY CHANNEL"
TextLabel2.TextColor3 = Color3.fromRGB(180, 180, 180)
TextLabel2.TextSize = 13
TextLabel2.Font = Enum.Font.GothamBold
TextLabel2.BackgroundTransparency = 1
TextLabel2.TextWrapped = true
TextLabel2.TextXAlignment = Enum.TextXAlignment.Center
TextLabel2.Parent = t1.value5
t1.value9 = Instance.new("TextButton")
t1.value9.Size = UDim2.new(0, 180, 0, 30)
t1.value9.Position = UDim2.new(0.5, -90, 0, 200)
t1.value9.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
t1.value9.BorderSizePixel = 0
t1.value9.Text = "YOUTUBE CHANNEL LINK"
t1.value9.TextColor3 = Color3.fromRGB(200, 200, 200)
t1.value9.TextSize = 13
t1.value9.Font = Enum.Font.GothamBold
t1.value9.Parent = t1.value5

local UICorner4 = Instance.new("UICorner")

UICorner4.CornerRadius = UDim.new(0, 6)
UICorner4.Parent = t1.value9
t1.value9.MouseButton1Click:Connect(function()
	local v120 = nil

	local function v121()
		toclipboard(v120)
		t1.value9.Text = "✅ COPIED!"
		task.wait(1.5)
		t1.value9.Text = "YOUTUBE CHANNEL LINK"
	end

	v120 = "https://youtube.com/@epicscripterr"
	pcall(v121)
end)
t1.value5.Size = UDim2.new(0, 0, 0, 0)
t1.value5.Position = UDim2.new(0.5, 0, 0.5, 0)
t1.value1:Create(t1.value5, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
	Size = UDim2.new(0, 350, 0, 280),
	Position = UDim2.new(0.5, -175, 0.5, -140)
}):Play()
t1.value6.MouseButton1Click:Connect(function()
	t1.value6.Text = "INJECTING..."
	t1.value6.TextColor3 = Color3.fromRGB(255, 255, 0)
	t1.value6.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	t1.value6.Active = false

	local ok, result = pcall(t1.value3)

	if not ok then
		warn("Bypass execution error: " .. tostring(result))
		Notify("ERROR", "Bypass failed: " .. tostring(result), 3)
		t1.value6.Text = "RETRY"
		t1.value6.TextColor3 = Color3.fromRGB(255, 0, 0)
		t1.value6.BackgroundColor3 = Color3.fromRGB(70, 20, 20)
		t1.value6.Active = true

		return
	end

	local tween = t1.value1:Create(t1.value5, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
		Size = UDim2.new(0, 0, 0, 0),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		BackgroundTransparency = 1
	})

	tween:Play()
	tween.Completed:Connect(function()
		t1.value4:Destroy()
		t1.value8:Disconnect()
		Notify("INJECTION SUCCESS", "Script injected and running!", 2)
	end)
end)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then
		return
	end

	if input.KeyCode ~= Enum.KeyCode.H then
		return
	end

	if t1.value5.Visible then
		t1.value5.Visible = false

		return
	end

	t1.value5.Visible = true
end)
print("✅ EPIC.S INJECTOR LOADED - Click INJECT to start bypass")
