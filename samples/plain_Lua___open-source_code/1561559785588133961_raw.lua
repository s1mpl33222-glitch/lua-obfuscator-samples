-- Syrianhub
local SoundService = game:GetService("SoundService")
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local camera = workspace.CurrentCamera
local InsertService = game:GetService("InsertService")

local soundFolder = Instance.new("Folder")
soundFolder.Name = "AT_Sounds"
soundFolder.Parent = SoundService

local currentSoundId = ""
local activeLoopSound = nil

local function playKeySound(pitch)
	if not currentSoundId or currentSoundId == "" then return end
	local s = Instance.new("Sound")
	s.SoundId = currentSoundId
	s.Volume = 0.7
	s.PlaybackSpeed = pitch or (0.95 + math.random() * 0.15)
	s.Parent = soundFolder
	s:Play()
	task.delay(2, function() pcall(function() s:Destroy() end) end)
end

-- ============================================================
-- SKIN APPLY LOGIC
-- ============================================================
local function tryApplySkin(code)
    if not code or code == "" then return end
    code = tostring(code):gsub("^%s+", ""):gsub("%s+$", "")
    if code == "" then return end
    
    local char = LP.Character
    if not char then print("[Skin] Character not found") return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then print("[Skin] HRP not found") return end
    
    local cleanCode = code:gsub("%s+", "")
    local applied = false
    
    local assetId = tonumber(cleanCode)
    
    if not assetId and cleanCode:match("^%x+$") and #cleanCode <= 12 then
        local ok, hexVal = pcall(function() return tonumber(cleanCode, 16) end)
        if ok and hexVal then
            assetId = hexVal
            print("[Skin] Interpreted as hex -> " .. tostring(assetId))
        end
    end
    
    if assetId then
        pcall(function()
            local asset = InsertService:LoadAsset(assetId)
            if asset then
                for _, child in ipairs(asset:GetChildren()) do
                    if child:IsA("Model") or child:IsA("Accessory") or child:IsA("Shirt") or child:IsA("Pants") then
                        local clone = child:Clone()
                        clone.Parent = char
                        if clone:IsA("Model") then
                            local primary = clone.PrimaryPart or clone:FindFirstChildWhichIsA("BasePart")
                            if primary then
                                clone:PivotTo(hrp.CFrame)
                                for _, part in ipairs(clone:GetDescendants()) do
                                    if part:IsA("BasePart") and not part.Anchored then
                                        local weld = Instance.new("WeldConstraint")
                                        weld.Part0 = hrp
                                        weld.Part1 = part
                                        weld.Parent = part
                                    end
                                end
                            end
                        end
                        applied = true
                        print("[Skin] Loaded via InsertService (asset " .. assetId .. ")")
                        break
                    end
                end
                asset:Destroy()
            end
        end)
    end
    
    for _, svcName in ipairs({"ReplicatedStorage", "ServerStorage", "Workspace", "StarterGui", "ReplicatedFirst"}) do
        pcall(function()
            local svc = game:GetService(svcName)
            if svc then
                local found = svc:FindFirstChild(cleanCode, true)
                if found and (found:IsA("Model") or found:IsA("Accessory") or found:IsA("Shirt") or found:IsA("Pants")) then
                    local clone = found:Clone()
                    clone.Parent = char
                    if clone:IsA("Model") then
                        local primary = clone.PrimaryPart or clone:FindFirstChildWhichIsA("BasePart")
                        if primary then
                            clone:PivotTo(hrp.CFrame)
                            for _, part in ipairs(clone:GetDescendants()) do
                                if part:IsA("BasePart") and not part.Anchored then
                                    local weld = Instance.new("WeldConstraint")
                                    weld.Part0 = hrp
                                    weld.Part1 = part
                                    weld.Parent = part
                                end
                            end
                        end
                    end
                    applied = true
                    print("[Skin] Found matching object in " .. svcName)
                end
            end
        end)
    end
    
    pcall(function()
        for _, obj in ipairs(game:GetDescendants()) do
            if obj:IsA("TextBox") and obj.Visible then
                local n = obj.Name:lower()
                if n:find("skin") or n:find("code") or n:find("redeem") or n:find("promo") then
                    obj.Text = code
                    print("[Skin] Filled game TextBox: " .. obj:GetFullName())
                    applied = true
                end
            end
        end
    end)
    
    pcall(function()
        for _, remote in ipairs(game:GetDescendants()) do
            if remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction") then
                local n = remote.Name:lower()
                if n:find("skin") or n:find("redeem") or n:find("equip") or n:find("code") then
                    pcall(function() remote:FireServer(code) end)
                    pcall(function() remote:FireServer(cleanCode) end)
                    pcall(function() remote:FireServer(code, cleanCode) end)
                end
            end
        end
    end)
    
    pcall(function()
        for _, attr in ipairs({"Skin", "SkinId", "SelectedSkin", "CurrentSkin", "EquippedSkin", "OwnedSkin"}) do
            pcall(function() LP:SetAttribute(attr, cleanCode) end)
        end
    end)
    
    if not applied then
        print("[Skin] Could not apply with code: " .. cleanCode)
        print("[Skin] This may be a game-specific code that requires the game's own UI")
    end
end

-- ============================================================
-- UI LIBRARY
-- ============================================================
local lib = {}
function lib:Window(title, accent, keybind)
	local ACCENT = Color3.fromRGB(60, 180, 255)
	local ACCENT_LIGHT = Color3.fromRGB(130, 220, 255)
	local ACCENT_2 = Color3.fromRGB(170, 110, 255)
	local BG_DARK = Color3.fromRGB(8, 12, 25)
	local BG_PANEL = Color3.fromRGB(18, 22, 42)
	local BG_ITEM = Color3.fromRGB(25, 30, 55)
	local BG_HOVER = Color3.fromRGB(38, 45, 78)
	local TEXT_WHITE = Color3.fromRGB(240, 245, 255)
	local TEXT_DIM = Color3.fromRGB(130, 150, 190)

	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "Syrianhub_Main"
	ScreenGui.ResetOnSpawn = false
	ScreenGui.IgnoreGuiInset = true
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	ScreenGui.Parent = CoreGui

	local main = Instance.new("Frame")
	main.Size = UDim2.new(0, 340, 0, 290)
	main.Position = UDim2.new(0.5, -170, 0.5, -145)
	main.BackgroundColor3 = BG_DARK
	main.BorderSizePixel = 0
	main.Active = true
	main.ClipsDescendants = true
	main.Parent = ScreenGui

	local mainCorner = Instance.new("UICorner")
	mainCorner.CornerRadius = UDim.new(0, 14)
	mainCorner.Parent = main

	local glowStroke = Instance.new("UIStroke")
	glowStroke.Color = ACCENT
	glowStroke.Thickness = 1.5
	glowStroke.Transparency = 0.15
	glowStroke.Parent = main

	local glowTween = TweenService:Create(glowStroke, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
		Color = ACCENT_2, Thickness = 2.5, Transparency = 0
	})
	glowTween:Play()

	local bgGradient = Instance.new("UIGradient")
	bgGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(8, 12, 25)),
		ColorSequenceKeypoint.new(0.25, Color3.fromRGB(15, 20, 48)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(22, 15, 55)),
		ColorSequenceKeypoint.new(0.75, Color3.fromRGB(15, 25, 48)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 12, 25)),
	})
	bgGradient.Rotation = 45
	bgGradient.Parent = main

	task.spawn(function()
		local rot = 45
		while main.Parent do
			rot = (rot + 0.5) % 360
			bgGradient.Rotation = rot
			task.wait(0.03)
		end
	end)

	local shadow = Instance.new("ImageLabel")
	shadow.AnchorPoint = Vector2.new(0.5, 0.5)
	shadow.Position = UDim2.new(0.5, 0, 0.5, 5)
	shadow.Size = UDim2.new(1, 40, 1, 40)
	shadow.BackgroundTransparency = 1
	shadow.Image = "rbxassetid://5028857084"
	shadow.ImageColor3 = ACCENT
	shadow.ImageTransparency = 0.65
	shadow.ScaleType = Enum.ScaleType.Slice
	shadow.SliceCenter = Rect.new(24, 24, 276, 276)
	shadow.ZIndex = -1
	shadow.Parent = main

	local shadowTween = TweenService:Create(shadow, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
		ImageColor3 = ACCENT_2, ImageTransparency = 0.45
	})
	shadowTween:Play()

	task.spawn(function()
		for i = 1, 18 do
			local particle = Instance.new("Frame")
			particle.Size = UDim2.new(0, math.random(2, 4), 0, math.random(2, 4))
			particle.BackgroundColor3 = (i % 3 == 0) and ACCENT_2 or ACCENT
			particle.BorderSizePixel = 0
			particle.BackgroundTransparency = math.random(55, 85) / 100
			particle.ZIndex = 0
			particle.Position = UDim2.new(math.random(), 0, math.random(), 0)
			particle.Parent = main
			local pc = Instance.new("UICorner")
			pc.CornerRadius = UDim.new(1, 0)
			pc.Parent = particle
			task.spawn(function()
				while particle.Parent do
					local dur = math.random(2, 6)
					TweenService:Create(particle, TweenInfo.new(dur, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
						Position = UDim2.new(math.random(), 0, math.random(), 0),
						BackgroundTransparency = math.random(50, 85) / 100
					}):Play()
					task.wait(dur)
				end
			end)
		end
	end)

	local shimmer = Instance.new("Frame")
	shimmer.Size = UDim2.new(0, 60, 1, 0)
	shimmer.Position = UDim2.new(-0.2, 0, 0, 0)
	shimmer.BackgroundColor3 = Color3.new(1, 1, 1)
	shimmer.BackgroundTransparency = 0.88
	shimmer.BorderSizePixel = 0
	shimmer.Rotation = 15
	shimmer.ZIndex = 1
	shimmer.Parent = main

	local shimmerGrad = Instance.new("UIGradient")
	shimmerGrad.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 1),
		NumberSequenceKeypoint.new(0.5, 0.6),
		NumberSequenceKeypoint.new(1, 1),
	})
	shimmerGrad.Parent = shimmer

	task.spawn(function()
		while main.Parent do
			shimmer.Position = UDim2.new(-0.2, 0, 0, 0)
			TweenService:Create(shimmer, TweenInfo.new(1.8, Enum.EasingStyle.Linear), {
				Position = UDim2.new(1.2, 0, 0, 0)
			}):Play()
			task.wait(4.5)
		end
	end)

	local titleBar = Instance.new("Frame")
	titleBar.Size = UDim2.new(1, 0, 0, 34)
	titleBar.BackgroundColor3 = BG_PANEL
	titleBar.BorderSizePixel = 0
	titleBar.ZIndex = 5
	titleBar.Parent = main

	local tbCorner = Instance.new("UICorner")
	tbCorner.CornerRadius = UDim.new(0, 14)
	tbCorner.Parent = titleBar

	local tbFix = Instance.new("Frame")
	tbFix.Size = UDim2.new(1, 0, 0, 14)
	tbFix.Position = UDim2.new(0, 0, 1, -14)
	tbFix.BackgroundColor3 = BG_PANEL
	tbFix.BorderSizePixel = 0
	tbFix.ZIndex = 5
	tbFix.Parent = titleBar

	local titleGrad = Instance.new("UIGradient")
	titleGrad.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, BG_PANEL),
		ColorSequenceKeypoint.new(0.3, Color3.fromRGB(30, 40, 75)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(45, 30, 75)),
		ColorSequenceKeypoint.new(0.7, Color3.fromRGB(30, 40, 75)),
		ColorSequenceKeypoint.new(1, BG_PANEL),
	})
	titleGrad.Parent = titleBar

	task.spawn(function()
		local rot = 0
		while titleBar.Parent do
			rot = (rot + 3) % 360
			titleGrad.Rotation = rot
			task.wait(0.03)
		end
	end)

	local tbAccent = Instance.new("Frame")
	tbAccent.Size = UDim2.new(1, -20, 0, 1.5)
	tbAccent.Position = UDim2.new(0, 10, 1, -1)
	tbAccent.BackgroundColor3 = ACCENT
	tbAccent.BorderSizePixel = 0
	tbAccent.ZIndex = 6
	tbAccent.Parent = titleBar

	local tbAccentGrad = Instance.new("UIGradient")
	tbAccentGrad.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, ACCENT),
		ColorSequenceKeypoint.new(0.5, ACCENT_2),
		ColorSequenceKeypoint.new(1, ACCENT),
	})
	tbAccentGrad.Parent = tbAccent

	task.spawn(function()
		local x = 0
		while tbAccent.Parent do
			x = (x + 2) % 200
			tbAccentGrad.Offset = Vector2.new(x / 100, 0)
			task.wait(0.03)
		end
	end)

	-- ===== Title Label with Marquee Effect =====
	local titleLbl = Instance.new("TextLabel")
	titleLbl.BackgroundTransparency = 1
	titleLbl.Position = UDim2.new(0, 14, 0, 0)
	titleLbl.Size = UDim2.new(1, -50, 1, 0)
	titleLbl.Font = Enum.Font.GothamBold
	titleLbl.TextSize = 11
	titleLbl.TextColor3 = TEXT_WHITE
	titleLbl.Text = ""
	titleLbl.TextXAlignment = Enum.TextXAlignment.Left
	titleLbl.ClipsDescendants = true
	titleLbl.ZIndex = 8
	titleLbl.Parent = titleBar

	local titleGrad2 = Instance.new("UIGradient")
	titleGrad2.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, ACCENT_LIGHT),
		ColorSequenceKeypoint.new(1, ACCENT_2),
	})
	titleGrad2.Parent = titleLbl

	-- Marquee effect: النص يتحرك من اليمين لليسار
	local marqueeText = title .. "        •        "
	task.spawn(function()
		local i = 1
		local speed = 0.1
		while titleLbl.Parent do
			titleLbl.Text = string.sub(marqueeText, i) .. string.sub(marqueeText, 1, i - 1)
			i = i + 1
			if i > #marqueeText then i = 1 end
			task.wait(speed)
		end
	end)

	local minBtn = Instance.new("TextButton")
	minBtn.Size = UDim2.new(0, 22, 0, 22)
	minBtn.Position = UDim2.new(1, -28, 0.5, -11)
	minBtn.Text = "—"
	minBtn.TextSize = 14
	minBtn.Font = Enum.Font.GothamBold
	minBtn.BackgroundColor3 = ACCENT
	minBtn.TextColor3 = Color3.new(1, 1, 1)
	minBtn.BorderSizePixel = 0
	minBtn.AutoButtonColor = false
	minBtn.ZIndex = 10
	minBtn.Parent = titleBar

	local minCorner = Instance.new("UICorner")
	minCorner.CornerRadius = UDim.new(1, 0)
	minCorner.Parent = minBtn

	local circleGui = Instance.new("ScreenGui")
	circleGui.Name = "Syrianhub_Circle"
	circleGui.ResetOnSpawn = false
	circleGui.IgnoreGuiInset = true
	circleGui.Parent = CoreGui

	local circleContainer = Instance.new("Frame")
	circleContainer.Size = UDim2.new(0, 44, 0, 44)
	circleContainer.AnchorPoint = Vector2.new(1, 0)
	circleContainer.Position = UDim2.new(1, -10, 0, 10)
	circleContainer.BackgroundTransparency = 1
	circleContainer.Visible = false
	circleContainer.Parent = circleGui

	local circleBtn = Instance.new("TextButton")
	circleBtn.Size = UDim2.new(1, 0, 1, 0)
	circleBtn.Text = "963"
	circleBtn.TextSize = 14
	circleBtn.Font = Enum.Font.GothamBold
	circleBtn.BackgroundColor3 = ACCENT
	circleBtn.TextColor3 = Color3.new(1, 1, 1)
	circleBtn.BorderSizePixel = 0
	circleBtn.AutoButtonColor = false
	circleBtn.Parent = circleContainer

	local cCorner = Instance.new("UICorner")
	cCorner.CornerRadius = UDim.new(1, 0)
	cCorner.Parent = circleBtn

	local cStroke = Instance.new("UIStroke")
	cStroke.Color = ACCENT_LIGHT
	cStroke.Thickness = 2
	cStroke.Transparency = 0.3
	cStroke.Parent = circleBtn

	local cStrokeTween = TweenService:Create(cStroke, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
		Thickness = 3, Color = ACCENT_2, Transparency = 0
	})
	cStrokeTween:Play()

	minBtn.MouseButton1Click:Connect(function()
		playKeySound()
		main.Visible = false
		circleContainer.Visible = true
		circleContainer.Size = UDim2.new(0, 0, 0, 0)
		TweenService:Create(circleContainer, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
			Size = UDim2.new(0, 44, 0, 44)
		}):Play()
	end)

	circleBtn.MouseButton1Click:Connect(function()
		playKeySound()
		main.Visible = true
		circleContainer.Visible = false
	end)

	local draggingMain, dragStartMain, startPosMain, dragInputMain
	titleBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			draggingMain = true
			dragStartMain = input.Position
			startPosMain = main.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					draggingMain = false
				end
			end)
		end
	end)
	titleBar.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInputMain = input
		end
	end)
	UIS.InputChanged:Connect(function(input)
		if input == dragInputMain and draggingMain then
			local delta = input.Position - dragStartMain
			main.Position = UDim2.new(startPosMain.X.Scale, startPosMain.X.Offset + delta.X,
				startPosMain.Y.Scale, startPosMain.Y.Offset + delta.Y)
		end
	end)

	local tabBar = Instance.new("Frame")
	tabBar.Size = UDim2.new(0, 100, 1, -48)
	tabBar.Position = UDim2.new(1, -108, 0, 42)
	tabBar.BackgroundColor3 = BG_PANEL
	tabBar.BorderSizePixel = 0
	tabBar.ZIndex = 2
	tabBar.Parent = main

	local tbBarCorner = Instance.new("UICorner")
	tbBarCorner.CornerRadius = UDim.new(0, 10)
	tbBarCorner.Parent = tabBar

	local tbBarStroke = Instance.new("UIStroke")
	tbBarStroke.Color = ACCENT
	tbBarStroke.Thickness = 1
	tbBarStroke.Transparency = 0.6
	tbBarStroke.Parent = tabBar

	local tabBarTween = TweenService:Create(tbBarStroke, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
		Color = ACCENT_2, Transparency = 0.3
	})
	tabBarTween:Play()

	local tabListLayout = Instance.new("UIListLayout")
	tabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	tabListLayout.Padding = UDim.new(0, 4)
	tabListLayout.Parent = tabBar

	local tabPad = Instance.new("UIPadding")
	tabPad.PaddingTop = UDim.new(0, 6)
	tabPad.PaddingLeft = UDim.new(0, 5)
	tabPad.PaddingRight = UDim.new(0, 5)
	tabPad.Parent = tabBar

	local content = Instance.new("Frame")
	content.Size = UDim2.new(1, -118, 1, -50)
	content.Position = UDim2.new(0, 10, 0, 42)
	content.BackgroundTransparency = 1
	content.ZIndex = 3
	content.Parent = main

	local win = { tabs = {}, currentTab = nil, mainFrame = main }
	local colorRefs = { toggles = {}, sliders = {}, buttons = {} }

	UIS.InputBegan:Connect(function(input, gp)
		if gp then return end
		if input.KeyCode == keybind then
			playKeySound()
			main.Visible = not main.Visible
			if main.Visible then circleContainer.Visible = false end
		end
	end)

	local function addHover(gui, normalColor, hoverColor, scale)
		local originalSize = gui.Size
		gui.MouseEnter:Connect(function()
			TweenService:Create(gui, TweenInfo.new(0.15), {
				BackgroundColor3 = hoverColor,
				Size = UDim2.new(originalSize.X.Scale, originalSize.X.Offset + (scale or 2), originalSize.Y.Scale, originalSize.Y.Offset)
			}):Play()
		end)
		gui.MouseLeave:Connect(function()
			TweenService:Create(gui, TweenInfo.new(0.15), {
				BackgroundColor3 = normalColor,
				Size = originalSize
			}):Play()
		end)
	end

	function win:Tab(name)
		local tabBtn = Instance.new("TextButton")
		tabBtn.Size = UDim2.new(1, 0, 0, 26)
		tabBtn.BackgroundColor3 = BG_ITEM
		tabBtn.BorderSizePixel = 0
		tabBtn.Text = name
		tabBtn.Font = Enum.Font.GothamSemibold
		tabBtn.TextSize = 10
		tabBtn.TextColor3 = TEXT_DIM
		tabBtn.AutoButtonColor = false
		tabBtn.ZIndex = 3
		tabBtn.Parent = tabBar

		local btnCorner = Instance.new("UICorner")
		btnCorner.CornerRadius = UDim.new(0, 6)
		btnCorner.Parent = tabBtn

		local page = Instance.new("ScrollingFrame")
		page.Size = UDim2.new(1, 0, 1, 0)
		page.BackgroundTransparency = 1
		page.BorderSizePixel = 0
		page.ScrollBarThickness = 2
		page.ScrollBarImageColor3 = ACCENT
		page.CanvasSize = UDim2.new(0, 0, 0, 0)
		page.AutomaticCanvasSize = Enum.AutomaticSize.Y
		page.Visible = false
		page.ZIndex = 4
		page.Parent = content

		local pageLayout = Instance.new("UIListLayout")
		pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
		pageLayout.Padding = UDim.new(0, 5)
		pageLayout.Parent = page

		local pagePad = Instance.new("UIPadding")
		pagePad.PaddingTop = UDim.new(0, 3)
		pagePad.PaddingLeft = UDim.new(0, 3)
		pagePad.PaddingRight = UDim.new(0, 3)
		pagePad.PaddingBottom = UDim.new(0, 6)
		pagePad.Parent = page

		local tab = { page = page, btn = tabBtn }
		local function selectTab()
			if self.currentTab == tab then return end
			for _, t in ipairs(self.tabs) do
				t.page.Visible = false
				t.btn.TextColor3 = TEXT_DIM
				TweenService:Create(t.btn, TweenInfo.new(0.15), { BackgroundColor3 = BG_ITEM }):Play()
			end
			page.Visible = true
			tabBtn.TextColor3 = Color3.new(1, 1, 1)
			TweenService:Create(tabBtn, TweenInfo.new(0.15), { BackgroundColor3 = ACCENT }):Play()
			self.currentTab = tab
		end

		tabBtn.MouseButton1Click:Connect(function()
			playKeySound(1.1)
			selectTab()
		end)

		addHover(tabBtn, BG_ITEM, BG_HOVER, 0)

		table.insert(self.tabs, tab)
		if #self.tabs == 1 then selectTab() end

		function tab:Toggle(name, default, callback)
			local btn = Instance.new("TextButton")
			btn.Size = UDim2.new(1, 0, 0, 30)
			btn.BackgroundColor3 = BG_ITEM
			btn.BorderSizePixel = 0
			btn.Text = ""
			btn.AutoButtonColor = false
			btn.ZIndex = 5
			btn.Parent = page

			local c = Instance.new("UICorner")
			c.CornerRadius = UDim.new(0, 6)
			c.Parent = btn

			local stroke = Instance.new("UIStroke")
			stroke.Color = ACCENT
			stroke.Thickness = 1
			stroke.Transparency = 0.8
			stroke.Parent = btn

			local lbl = Instance.new("TextLabel")
			lbl.BackgroundTransparency = 1
			lbl.Position = UDim2.new(0, 10, 0, 0)
			lbl.Size = UDim2.new(1, -55, 1, 0)
			lbl.Font = Enum.Font.GothamSemibold
			lbl.TextSize = 11
			lbl.TextColor3 = TEXT_WHITE
			lbl.Text = name
			lbl.TextXAlignment = Enum.TextXAlignment.Left
			lbl.ZIndex = 6
			lbl.Parent = btn

			local ind = Instance.new("Frame")
			ind.Size = UDim2.new(0, 30, 0, 16)
			ind.Position = UDim2.new(1, -42, 0.5, -8)
			ind.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
			ind.BorderSizePixel = 0
			ind.ZIndex = 6
			ind.Parent = btn

			local indCorner = Instance.new("UICorner")
			indCorner.CornerRadius = UDim.new(1, 0)
			indCorner.Parent = ind

			local dot = Instance.new("Frame")
			dot.Size = UDim2.new(0, 12, 0, 12)
			dot.Position = UDim2.new(0, 2, 0.5, -6)
			dot.BackgroundColor3 = Color3.fromRGB(200, 200, 210)
			dot.BorderSizePixel = 0
			dot.ZIndex = 7
			dot.Parent = ind

			local dotCorner = Instance.new("UICorner")
			dotCorner.CornerRadius = UDim.new(1, 0)
			dotCorner.Parent = dot

			local state = default or false
			local function update(animate)
				local dotPos = state and UDim2.new(0, 16, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
				local indColor = state and ACCENT or Color3.fromRGB(50, 50, 65)
				stroke.Color = ACCENT
				if animate then
					TweenService:Create(dot, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
						Position = dotPos, BackgroundColor3 = Color3.new(1, 1, 1)
					}):Play()
					TweenService:Create(ind, TweenInfo.new(0.2), { BackgroundColor3 = indColor }):Play()
					TweenService:Create(stroke, TweenInfo.new(0.2), { Transparency = state and 0.3 or 0.8 }):Play()
				else
					dot.Position = dotPos
					ind.BackgroundColor3 = indColor
					stroke.Transparency = state and 0.3 or 0.8
				end
			end

			update(false)

			btn.MouseButton1Click:Connect(function()
				playKeySound(state and 0.9 or 1.2)
				state = not state
				update(true)
				if callback then pcall(callback, state) end
			end)

			addHover(btn, BG_ITEM, BG_HOVER, 2)
			table.insert(colorRefs.toggles, { update = update, stroke = stroke })
			return btn
		end

		function tab:Slider(name, min, max, default, callback)
			local holder = Instance.new("Frame")
			holder.Size = UDim2.new(1, 0, 0, 38)
			holder.BackgroundColor3 = BG_ITEM
			holder.BorderSizePixel = 0
			holder.ZIndex = 5
			holder.Parent = page

			local hc = Instance.new("UICorner")
			hc.CornerRadius = UDim.new(0, 6)
			hc.Parent = holder

			local hStroke = Instance.new("UIStroke")
			hStroke.Color = ACCENT
			hStroke.Thickness = 1
			hStroke.Transparency = 0.85
			hStroke.Parent = holder

			local lbl = Instance.new("TextLabel")
			lbl.BackgroundTransparency = 1
			lbl.Position = UDim2.new(0, 10, 0, 2)
			lbl.Size = UDim2.new(1, -75, 0, 16)
			lbl.Font = Enum.Font.GothamSemibold
			lbl.TextSize = 10
			lbl.TextColor3 = TEXT_WHITE
			lbl.Text = name
			lbl.TextXAlignment = Enum.TextXAlignment.Left
			lbl.ZIndex = 6
			lbl.Parent = holder

			local valBox = Instance.new("TextBox")
			valBox.BackgroundTransparency = 1
			valBox.Position = UDim2.new(1, -62, 0, 2)
			valBox.Size = UDim2.new(0, 52, 0, 16)
			valBox.Font = Enum.Font.GothamBold
			valBox.TextSize = 10
			valBox.TextColor3 = ACCENT_LIGHT
			valBox.Text = tostring(math.floor(default))
			valBox.TextXAlignment = Enum.TextXAlignment.Right
			valBox.ClearTextOnFocus = false
			valBox.ZIndex = 6
			valBox.Parent = holder

			local bar = Instance.new("Frame")
			bar.Size = UDim2.new(1, -20, 0, 5)
			bar.Position = UDim2.new(0, 10, 1, -12)
			bar.BackgroundColor3 = Color3.fromRGB(45, 45, 58)
			bar.BorderSizePixel = 0
			bar.ZIndex = 6
			bar.Parent = holder

			local barC = Instance.new("UICorner")
			barC.CornerRadius = UDim.new(1, 0)
			barC.Parent = bar

			local fill = Instance.new("Frame")
			fill.Size = UDim2.new(0, 0, 1, 0)
			fill.BackgroundColor3 = ACCENT
			fill.BorderSizePixel = 0
			fill.ZIndex = 7
			fill.Parent = bar

			local fillC = Instance.new("UICorner")
			fillC.CornerRadius = UDim.new(1, 0)
			fillC.Parent = fill

			local fillGrad = Instance.new("UIGradient")
			fillGrad.Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, ACCENT),
				ColorSequenceKeypoint.new(1, ACCENT_2),
			})
			fillGrad.Parent = fill

			local knob = Instance.new("Frame")
			knob.Size = UDim2.new(0, 10, 0, 10)
			knob.AnchorPoint = Vector2.new(0.5, 0.5)
			knob.Position = UDim2.new(0, 0, 0.5, 0)
			knob.BackgroundColor3 = Color3.new(1, 1, 1)
			knob.BorderSizePixel = 0
			knob.ZIndex = 8
			knob.Parent = bar

			local knobC = Instance.new("UICorner")
			knobC.CornerRadius = UDim.new(1, 0)
			knobC.Parent = knob

			local knobStroke = Instance.new("UIStroke")
			knobStroke.Color = ACCENT
			knobStroke.Thickness = 1.5
			knobStroke.Parent = knob

			local value = default
			local function setValue(v, fire)
				v = math.clamp(v, min, max)
				value = v
				local alpha = (v - min) / (max - min)
				fill.Size = UDim2.new(alpha, 0, 1, 0)
				knob.Position = UDim2.new(alpha, 0, 0.5, 0)
				if not valBox:IsFocused() then
					valBox.Text = tostring(math.floor(v))
				end
				if fire and callback then pcall(callback, v) end
			end

			setValue(default, true)

			valBox.FocusLost:Connect(function()
				local n = tonumber(valBox.Text)
				if n then
					setValue(n, true)
					playKeySound(1.3)
				else
					valBox.Text = tostring(math.floor(value))
				end
			end)

			local draggingSlider = false
			local function updateFromInput(inputX)
				local relX = inputX - bar.AbsolutePosition.X
				local alpha = math.clamp(relX / bar.AbsoluteSize.X, 0, 1)
				setValue(min + alpha * (max - min), true)
			end

			bar.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					draggingSlider = true
					updateFromInput(input.Position.X)
				end
			end)

			UIS.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					draggingSlider = false
				end
			end)

			UIS.InputChanged:Connect(function(input)
				if draggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
					updateFromInput(input.Position.X)
				end
			end)

			addHover(holder, BG_ITEM, BG_HOVER, 1)
			table.insert(colorRefs.sliders, {
				fill = fill, fillGrad = fillGrad, valBox = valBox,
				knobStroke = knobStroke, hStroke = hStroke,
			})
			return holder
		end

		function tab:Label(text)
			local lbl = Instance.new("TextLabel")
			lbl.Size = UDim2.new(1, 0, 0, 20)
			lbl.BackgroundTransparency = 1
			lbl.Font = Enum.Font.GothamSemibold
			lbl.TextSize = 11
			lbl.TextColor3 = TEXT_WHITE
			lbl.Text = text
			lbl.TextXAlignment = Enum.TextXAlignment.Left
			lbl.ZIndex = 5
			lbl.Parent = page
			return lbl
		end

		function tab:Button(text, callback)
			local btn = Instance.new("TextButton")
			btn.Size = UDim2.new(1, 0, 0, 30)
			btn.BackgroundColor3 = ACCENT
			btn.BorderSizePixel = 0
			btn.Text = text
			btn.Font = Enum.Font.GothamBold
			btn.TextSize = 11
			btn.TextColor3 = Color3.new(1, 1, 1)
			btn.AutoButtonColor = false
			btn.ZIndex = 5
			btn.Parent = page

			local c = Instance.new("UICorner")
			c.CornerRadius = UDim.new(0, 6)
			c.Parent = btn

			local grad = Instance.new("UIGradient")
			grad.Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, ACCENT),
				ColorSequenceKeypoint.new(1, ACCENT_2),
			})
			grad.Parent = btn

			btn.MouseButton1Click:Connect(function()
				playKeySound(1.2)
				if callback then pcall(callback) end
			end)

			table.insert(colorRefs.buttons, { btn = btn, grad = grad })
			return btn
		end

		local function makePicker(pickerName, items, cellSize, pickerType, onSelect)
			local wrapper = Instance.new("Frame")
			wrapper.Size = UDim2.new(1, 0, 0, 30)
			wrapper.AutomaticSize = Enum.AutomaticSize.Y
			wrapper.BackgroundTransparency = 1
			wrapper.ZIndex = 5
			wrapper.Parent = page

			local wrapperLayout = Instance.new("UIListLayout")
			wrapperLayout.SortOrder = Enum.SortOrder.LayoutOrder
			wrapperLayout.Padding = UDim.new(0, 0)
			wrapperLayout.Parent = wrapper

			local header = Instance.new("TextButton")
			header.Size = UDim2.new(1, 0, 0, 30)
			header.BackgroundColor3 = BG_ITEM
			header.BorderSizePixel = 0
			header.Text = ""
			header.AutoButtonColor = false
			header.LayoutOrder = 1
			header.ZIndex = 5
			header.Parent = wrapper

			local hc = Instance.new("UICorner")
			hc.CornerRadius = UDim.new(0, 6)
			hc.Parent = header

			local hStroke = Instance.new("UIStroke")
			hStroke.Color = ACCENT
			hStroke.Thickness = 1
			hStroke.Transparency = 0.85
			hStroke.Parent = header

			local lbl = Instance.new("TextLabel")
			lbl.BackgroundTransparency = 1
			lbl.Position = UDim2.new(0, 10, 0, 0)
			lbl.Size = UDim2.new(1, -40, 1, 0)
			lbl.Font = Enum.Font.GothamSemibold
			lbl.TextSize = 11
			lbl.TextColor3 = TEXT_WHITE
			lbl.Text = pickerName
			lbl.TextXAlignment = Enum.TextXAlignment.Left
			lbl.ZIndex = 6
			lbl.Parent = header

			local arrow = Instance.new("TextLabel")
			arrow.BackgroundTransparency = 1
			arrow.AnchorPoint = Vector2.new(1, 0.5)
			arrow.Position = UDim2.new(1, -10, 0.5, 0)
			arrow.Size = UDim2.new(0, 18, 1, 0)
			arrow.Font = Enum.Font.GothamBold
			arrow.TextSize = 12
			arrow.TextColor3 = ACCENT_LIGHT
			arrow.Text = "▶"
			arrow.ZIndex = 6
			arrow.Parent = header

			local container = Instance.new("Frame")
			container.Size = UDim2.new(1, 0, 0, 0)
			container.BackgroundTransparency = 1
			container.ClipsDescendants = true
			container.LayoutOrder = 2
			container.ZIndex = 5
			container.Parent = wrapper

			local gridFrame = Instance.new("Frame")
			gridFrame.Size = UDim2.new(1, 0, 0, 0)
			gridFrame.AutomaticSize = Enum.AutomaticSize.Y
			gridFrame.BackgroundTransparency = 1
			gridFrame.ZIndex = 5
			gridFrame.Parent = container

			local grid = Instance.new("UIGridLayout")
			grid.CellSize = cellSize
			grid.CellPadding = UDim2.new(0, 4, 0, 4)
			grid.SortOrder = Enum.SortOrder.LayoutOrder
			grid.Parent = gridFrame

			local gridPad = Instance.new("UIPadding")
			gridPad.PaddingTop = UDim.new(0, 4)
			gridPad.PaddingLeft = UDim.new(0, 4)
			gridPad.PaddingRight = UDim.new(0, 4)
			gridPad.PaddingBottom = UDim.new(0, 4)
			gridPad.Parent = gridFrame

			local allButtons = {}
			
			for i, item in ipairs(items) do
				local btn = Instance.new("TextButton")
				btn.Size = cellSize
				btn.BorderSizePixel = 0
				btn.Text = item.name or ""
				btn.Font = Enum.Font.GothamBold
				btn.TextSize = item.isNo and 8 or (cellSize.X.Offset < 30 and 12 or 9)
				btn.TextColor3 = item.textColor or Color3.fromRGB(0, 0, 0)
				btn.AutoButtonColor = false
				btn.LayoutOrder = i
				btn.ZIndex = 6
				btn.Parent = gridFrame

				if pickerType == "color" then
					btn.BackgroundColor3 = item.c1
					local grad = Instance.new("UIGradient")
					grad.Color = ColorSequence.new({
						ColorSequenceKeypoint.new(0, item.c1),
						ColorSequenceKeypoint.new(1, item.c2 or item.c1),
					})
					grad.Rotation = 45
					grad.Parent = btn
				else
					btn.BackgroundColor3 = item.color or Color3.fromRGB(50, 50, 50)
				end

				local bc = Instance.new("UICorner")
				bc.CornerRadius = UDim.new(0, 4)
				bc.Parent = btn

				local bStroke = Instance.new("UIStroke")
				bStroke.Color = Color3.new(1, 1, 1)
				bStroke.Thickness = 1
				bStroke.Transparency = 0.5
				bStroke.Parent = btn

				table.insert(allButtons, { btn = btn, stroke = bStroke })

				btn.MouseEnter:Connect(function()
					TweenService:Create(bStroke, TweenInfo.new(0.15), { Transparency = 0 }):Play()
				end)
				btn.MouseLeave:Connect(function()
					TweenService:Create(bStroke, TweenInfo.new(0.15), { Transparency = 0.5 }):Play()
				end)

				btn.MouseButton1Click:Connect(function()
					playKeySound()

					if item.isNo then
						if pickerType == "sound" then
							currentSoundId = ""
						elseif pickerType == "video" then
							if activeLoopSound then
								activeLoopSound:Stop()
								activeLoopSound:Destroy()
								activeLoopSound = nil
							end
						end
						for _, b in ipairs(allButtons) do
							TweenService:Create(b.stroke, TweenInfo.new(0.2), { Transparency = 0.5 }):Play()
						end
						TweenService:Create(bStroke, TweenInfo.new(0.2), { Transparency = 0 }):Play()
						return
					end

					if pickerType == "color" then
						if onSelect then onSelect(item.c1, item.c2 or item.c1) end
						for _, b in ipairs(allButtons) do
							TweenService:Create(b.stroke, TweenInfo.new(0.2), { Transparency = 0.5 }):Play()
						end
						TweenService:Create(bStroke, TweenInfo.new(0.2), { Transparency = 0 }):Play()

					elseif pickerType == "sound" then
						if activeLoopSound then
							activeLoopSound:Stop()
							activeLoopSound:Destroy()
							activeLoopSound = nil
						end

						if item.id and item.id ~= "" then
							local preview = Instance.new("Sound")
							preview.SoundId = item.id
							preview.Volume = 0.7
							preview.Parent = soundFolder
							preview:Play()
							task.delay(5, function() pcall(function() preview:Destroy() end) end)
						end
						
						for _, b in ipairs(allButtons) do
							TweenService:Create(b.stroke, TweenInfo.new(0.2), { Transparency = 0.5 }):Play()
						end
						TweenService:Create(bStroke, TweenInfo.new(0.2), { Transparency = 0 }):Play()
						if onSelect then onSelect(item.id) end

					elseif pickerType == "video" then
						if activeLoopSound then
							activeLoopSound:Stop()
							activeLoopSound:Destroy()
							activeLoopSound = nil
						end
						
						for _, b in ipairs(allButtons) do
							TweenService:Create(b.stroke, TweenInfo.new(0.2), { Transparency = 0.5 }):Play()
						end
						
						if item.id and item.id ~= "" then
							local s = Instance.new("Sound")
							s.SoundId = item.id
							s.Volume = 1
							s.Looped = true
							s.Parent = soundFolder
							s:Play()
							activeLoopSound = s
							TweenService:Create(bStroke, TweenInfo.new(0.2), { Transparency = 0 }):Play()
						end
					elseif pickerType == "skin" then
						if onSelect then onSelect(item.id) end
						for _, b in ipairs(allButtons) do
							TweenService:Create(b.stroke, TweenInfo.new(0.2), { Transparency = 0.5 }):Play()
						end
						TweenService:Create(bStroke, TweenInfo.new(0.2), { Transparency = 0 }):Play()
					end
				end)
			end

			local open = false
			local itemCount = #items
			local cellW = cellSize.X.Offset + 4
			local cellH = cellSize.Y.Offset + 4

			header.MouseButton1Click:Connect(function()
				playKeySound()
				open = not open
				if open then
					arrow.Text = "▼"
					task.spawn(function()
						task.wait(0.05)
						local containerW = wrapper.AbsoluteSize.X
						if containerW <= 0 then containerW = 200 end
						local cols = math.max(1, math.floor((containerW - 8) / cellW))
						local rows = math.ceil(itemCount / cols)
						local contentH = rows * cellH + 8
						TweenService:Create(container, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
							Size = UDim2.new(1, 0, 0, contentH)
						}):Play()
					end)
				else
					arrow.Text = "▶"
					TweenService:Create(container, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
						Size = UDim2.new(1, 0, 0, 0)
					}):Play()
				end
			end)

			addHover(header, BG_ITEM, BG_HOVER, 0)
			return header, container
		end

		function tab:ColorPicker(pickerName, colors, onSelect)
			return makePicker(pickerName, colors, UDim2.new(0, 20, 0, 20), "color", onSelect)
		end

		function tab:SoundPicker(pickerName, sounds, onSelect)
			return makePicker(pickerName, sounds, UDim2.new(0, 48, 0, 22), "sound", onSelect)
		end

		function tab:VideoPicker(pickerName, videos)
			return makePicker(pickerName, videos, UDim2.new(0, 48, 0, 22), "video", nil)
		end

		function tab:SkinPicker(pickerName, skins, onSelect)
			return makePicker(pickerName, skins, UDim2.new(0, 48, 0, 22), "skin", onSelect)
		end

		return tab
	end

	function win:SetColor(c1, c2)
		local c1Light = c1:Lerp(Color3.new(1, 1, 1), 0.4)
		ACCENT = c1
		ACCENT_LIGHT = c1Light
		ACCENT_2 = c2

		if titleGrad2 then
			titleGrad2.Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, c1Light),
				ColorSequenceKeypoint.new(1, c2),
			})
		end
		if tbAccent then tbAccent.BackgroundColor3 = c1 end
		if tbAccentGrad then
			tbAccentGrad.Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, c1),
				ColorSequenceKeypoint.new(0.5, c2),
				ColorSequenceKeypoint.new(1, c1),
			})
		end
		if minBtn then minBtn.BackgroundColor3 = c1 end
		if circleBtn then circleBtn.BackgroundColor3 = c1 end

		if glowTween then glowTween:Cancel() end
		glowStroke.Color = c1
		glowStroke.Transparency = 0.15
		glowStroke.Thickness = 1.5
		glowTween = TweenService:Create(glowStroke, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
			Color = c2, Thickness = 2.5, Transparency = 0
		})
		glowTween:Play()

		if shadowTween then shadowTween:Cancel() end
		shadow.ImageColor3 = c1
		shadow.ImageTransparency = 0.65
		shadowTween = TweenService:Create(shadow, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
			ImageColor3 = c2, ImageTransparency = 0.45
		})
		shadowTween:Play()

		if cStrokeTween then cStrokeTween:Cancel() end
		cStroke.Color = c1Light
		cStroke.Thickness = 2
		cStroke.Transparency = 0.3
		cStrokeTween = TweenService:Create(cStroke, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
			Thickness = 3, Color = c2, Transparency = 0
		})
		cStrokeTween:Play()

		if tabBarTween then tabBarTween:Cancel() end
		tbBarStroke.Color = c1
		tbBarStroke.Transparency = 0.6
		tabBarTween = TweenService:Create(tbBarStroke, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
			Color = c2, Transparency = 0.3
		})
		tabBarTween:Play()

		for _, t in ipairs(colorRefs.toggles) do
			pcall(function() t.update(false) end)
		end

		for _, s in ipairs(colorRefs.sliders) do
			if s.fill then s.fill.BackgroundColor3 = c1 end
			if s.fillGrad then
				s.fillGrad.Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, c1),
					ColorSequenceKeypoint.new(1, c2),
				})
			end
			if s.valBox then s.valBox.TextColor3 = c1Light end
			if s.knobStroke then s.knobStroke.Color = c1 end
			if s.hStroke then s.hStroke.Color = c1 end
		end

		for _, b in ipairs(colorRefs.buttons) do
			if b.btn then b.btn.BackgroundColor3 = c1 end
			if b.grad then
				b.grad.Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, c1),
					ColorSequenceKeypoint.new(1, c2),
				})
			end
		end

		for _, tab in ipairs(self.tabs) do
			if tab == self.currentTab then
				tab.btn.BackgroundColor3 = c1
			else
				tab.btn.BackgroundColor3 = BG_ITEM
			end
			tab.page.ScrollBarImageColor3 = c1
		end
	end

	return win
end

-- ===== INIT =====
local win = lib:Window("Syrianhub - https://discord.gg/yM4QS7HJ6", Color3.fromRGB(60, 180, 255), Enum.KeyCode.P)
local tab = win:Tab("Main")
local settingsTab = win:Tab("Settings")

local AP_CONFIG = {
	WalkSpeed = 19, ChaseSpeed = 28, BackstabOffset = 2,
	DodgeSpeed = 38, DodgeInterval = 0.25,
	ToggleKey = Enum.KeyCode.F,
	BombKeywords = {"bomb", "timebomb", "c4", "explosive", "grenade"},
	LoopDelay = 0.02,
	AutoPlayHoldTime = 2,
	AutoPlayStayDistance = 2,
	AutoPlayEscapeSpeed = 70,
	AutoPlayEscapeDistance = 40,
	AutoPlayEscapeTime = 0.4,
	AutoPlayDodgeTime = 2,
	AutoPlayCrouchTime = 2,
	PassSpeed = 55,
}

local PRO_CONFIG = {
	BehindDistance = 5, StickTolerance = 2, PassSpeed = 55,
	HoldBeforeFace = 1.5, FaceDuration = 0.4, PassTimeout = 3,
}

local UIState = { Auto = false, Pro = false, Lock = false }
local AP_State = {
	Enabled = false, LastHadBomb = false, CrouchActive = false,
	LastEnemyPos = nil, LastDodgeUpdate = 0, LoopRunning = false,
	AutoPlayEscaping = false, AutoPlayEscapeTarget = nil,
	AutoPlayPhase = "idle", AutoPlayPhaseStart = 0,
	AutoPlayEscapeSub = "none", AutoPlaySubStart = 0,
}
local ProState = { Enabled = false, WasHoldingBomb = false, Phase = "idle", PhaseStart = 0 }
local LockState = { Enabled = false, Speed = 12 }

local function ap_hasBomb(char)
	if not char then return false end
	for _, obj in ipairs(char:GetChildren()) do
		local name = obj.Name:lower()
		for _, kw in ipairs(AP_CONFIG.BombKeywords) do
			if name:find(kw) then return true end
		end
	end
	return false
end

local function ap_getBombHolder()
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr.Character and ap_hasBomb(plr.Character) then return plr end
	end
	return nil
end

local function ap_getTarget(hrp)
	local bombHolder = ap_getBombHolder()
	if bombHolder and bombHolder ~= LP then
		local oChar = bombHolder.Character
		if oChar then
			local oHrp = oChar:FindFirstChild("HumanoidRootPart")
			local oHum = oChar:FindFirstChildOfClass("Humanoid")
			if oHrp and oHum and oHum.Health > 0 then
				return bombHolder, (hrp.Position - oHrp.Position).Magnitude, oHrp
			end
		end
	end
	local closest, closestDist, closestHrp = nil, math.huge, nil
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= LP then
			local oChar = plr.Character
			if oChar then
				local oHum = oChar:FindFirstChildOfClass("Humanoid")
				if oHum and oHum.Health > 0 then
					local oHrp = oChar:FindFirstChild("HumanoidRootPart")
					if oHrp then
						local d = (hrp.Position - oHrp.Position).Magnitude
						if d < closestDist then closestDist = d; closest = plr; closestHrp = oHrp end
					end
				end
			end
		end
	end
	return closest, closestDist, closestHrp
end

local function ap_moveTo(targetPos, hrp, hum)
	if not hrp or not hum then return end
	pcall(function() hum:MoveTo(targetPos) end)
end

local AUTO_FOV = 200
local function applyFOV()
	pcall(function()
		if camera and camera.FieldOfView ~= AUTO_FOV then
			camera.FieldOfView = AUTO_FOV
		end
	end)
end
applyFOV()
RunService.RenderStepped:Connect(function() applyFOV() end)

task.spawn(function()
	pcall(function()
		Lighting.GlobalShadows = false
		Lighting.FogEnd = 100000
		Lighting.FogStart = 100000
		Lighting.Brightness = 0.5
		Lighting.EnvironmentDiffuseScale = 0
		Lighting.EnvironmentSpecularScale = 0
		Lighting.Ambient = Color3.fromRGB(80, 80, 80)
		Lighting.OutdoorAmbient = Color3.fromRGB(80, 80, 80)
		Lighting.ClockTime = 12
		pcall(function() Lighting.ShadowSoftness = 0 end)
		for _, effect in ipairs(Lighting:GetChildren()) do
			if effect:IsA("PostEffect") or effect:IsA("Atmosphere") or effect:IsA("Sky") then
				effect:Destroy()
			end
		end
		pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Level01 end)
		pcall(function() settings().Rendering.MeshPartDetail = Enum.MeshPartDetailLevel.Level01 end)
		for _, obj in ipairs(Workspace:GetDescendants()) do
			pcall(function()
				if obj:IsA("BasePart") then
					obj.Material = Enum.Material.SmoothPlastic
					obj.Reflectance = 0
					obj.CastShadow = false
				elseif obj:IsA("ParticleEmitter") or obj:IsA("Fire") or obj:IsA("Smoke")
					or obj:IsA("Sparkles") or obj:IsA("Trail") or obj:IsA("Beam") then
					obj.Enabled = false
				elseif obj:IsA("Decal") or obj:IsA("Texture") then
					obj.Transparency = 1
				elseif obj:IsA("SurfaceAppearance") then
					obj:Destroy()
				end
			end)
		end
	end)
end)

local function ap_fullReset()
	AP_State.LastHadBomb = false
	AP_State.AutoPlayEscaping = false
	AP_State.AutoPlayPhase = "idle"
	AP_State.AutoPlayEscapeSub = "none"
	AP_State.AutoPlayEscapeTarget = nil
	AP_State.LastEnemyPos = nil
	AP_State.LastDodgeUpdate = 0
	ap_stopCrouch()
end
local function pro_fullReset()
	ProState.WasHoldingBomb = false
	ProState.Phase = "idle"
	ProState.PhaseStart = 0
end

local function refreshAP()
	local shouldEnable = UIState.Auto or UIState.Pro
	AP_State.Enabled = shouldEnable
	ProState.Enabled = UIState.Pro
	if shouldEnable then
		local char = LP.Character
		if char then
			local hum = char:FindFirstChildOfClass("Humanoid")
			if hum then
				hum.WalkSpeed = AP_CONFIG.ChaseSpeed
				hum.AutoRotate = true
			end
		end
		ap_mainLoop()
	else
		ap_fullReset()
		pro_fullReset()
		local char = LP.Character
		if char then
			local hum = char:FindFirstChildOfClass("Humanoid")
			if hum then
				hum.WalkSpeed = AP_CONFIG.WalkSpeed
				hum.AutoRotate = true
			end
		end
	end
end

local LockLoopRunning = false
local function lockLoop()
	if LockLoopRunning then return end
	LockLoopRunning = true
	task.spawn(function()
		while LockState.Enabled do
			task.wait(0.02)
			pcall(function()
				local char = LP.Character
				if not char then return end
				local hrp = char:FindFirstChild("HumanoidRootPart")
				local hum = char:FindFirstChildOfClass("Humanoid")
				if not hrp or not hum then return end
				local _, _, oHrp = ap_getTarget(hrp)
				if not oHrp then return end
				if hum.AutoRotate then hum.AutoRotate = false end
				local pos = hrp.Position
				local dir = oHrp.Position - pos
				dir = Vector3.new(dir.X, 0, dir.Z)
				if dir.Magnitude < 0.05 then return end
				dir = dir.Unit
				local currentLook = hrp.CFrame.LookVector
				currentLook = Vector3.new(currentLook.X, 0, currentLook.Z)
				if currentLook.Magnitude < 0.05 then currentLook = dir end
				currentLook = currentLook.Unit
				local alpha = math.clamp(LockState.Speed * 0.02, 0, 1)
				local newLook = (currentLook * (1 - alpha) + dir * alpha)
				if newLook.Magnitude < 0.05 then newLook = dir end
				hrp.CFrame = CFrame.lookAt(pos, pos + newLook.Unit)
			end)
		end
		LockLoopRunning = false
	end)
end

local hitboxEnabled = false
local noCollisionEnabled = false
local hitbox_original_properties = {}
local hitboxSize = 3
local hitboxTransparency = 3
local teamCheck = "FFA"
local defaultBodyParts = { "UpperTorso", "Head", "HumanoidRootPart" }

local ScreenGui = Instance.new("ScreenGui", LP.PlayerGui)
local WarningText = Instance.new("TextLabel", ScreenGui)
WarningText.Size = UDim2.new(0, 200, 0, 50)
WarningText.TextSize = 16
WarningText.Position = UDim2.new(0.5, -100, 0, 0)
WarningText.Text = "Warning: Collisions may occur."
WarningText.TextColor3 = Color3.new(1, 0, 0)
WarningText.BackgroundTransparency = 1
WarningText.Visible = false

local function savedPart(player, part)
	if not hitbox_original_properties[player] then hitbox_original_properties[player] = {} end
	if not hitbox_original_properties[player][part.Name] then
		hitbox_original_properties[player][part.Name] = {
			CanCollide = part.CanCollide, Transparency = part.Transparency, Size = part.Size
		}
	end
end
local function restoredPart(player)
	if hitbox_original_properties[player] then
		for partName, properties in pairs(hitbox_original_properties[player]) do
			local part = player.Character and player.Character:FindFirstChild(partName)
			if part and part:IsA("BasePart") then
				part.CanCollide = properties.CanCollide
				part.Transparency = properties.Transparency
				part.Size = properties.Size
			end
		end
	end
end
local function findClosestPart(player, partName)
	if not player.Character then return nil end
	for _, part in ipairs(player.Character:GetChildren()) do
		if part:IsA("BasePart") and part.Name:lower():match(partName:lower()) then
			return part
		end
	end
	return nil
end
local function extendHitbox(player)
	for _, partName in ipairs(defaultBodyParts) do
		local part = player.Character and (player.Character:FindFirstChild(partName) or findClosestPart(player, partName))
		if part and part:IsA("BasePart") then
			savedPart(player, part)
			if noCollisionEnabled then part.CanCollide = false end
			part.Transparency = hitboxTransparency / 10
			part.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
		end
	end
end
local function isEnemy(player)
	if teamCheck == "FFA" or teamCheck == "Everyone" then return true end
	return player.Team ~= LP.Team
end
local function updateHitboxes()
	for _, v in ipairs(Players:GetPlayers()) do
		if v ~= LP and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
			if isEnemy(v) then extendHitbox(v) else restoredPart(v) end
		end
	end
end
Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function()
		task.wait(0.1)
		if hitboxEnabled then updateHitboxes() end
	end)
	player.CharacterRemoving:Connect(function()
		restoredPart(player)
		hitbox_original_properties[player] = nil
	end)
end)

local function ap_doCrouch(duration)
	pcall(function()
		local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
		if hum then
			hum.CameraOffset = Vector3.new(0, -1.5, 0)
			AP_State.CrouchActive = true
		end
	end)
end
function ap_stopCrouch()
	pcall(function()
		local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
		if hum then hum.CameraOffset = Vector3.new(0, 0, 0) end
		AP_State.CrouchActive = false
	end)
end
local function ap_backstabMove(targetHrp, hrp, hum)
	local targetFacing = targetHrp.CFrame.LookVector
	targetFacing = Vector3.new(targetFacing.X, 0, targetFacing.Z)
	if targetFacing.Magnitude > 0.1 then targetFacing = targetFacing.Unit end
	ap_moveTo(targetHrp.Position - targetFacing * AP_CONFIG.BackstabOffset, hrp, hum)
end
local function apForceLookAt(hrp, hum, targetPos)
	pcall(function()
		if hum.AutoRotate then hum.AutoRotate = false end
		local pos = hrp.Position
		local dir = Vector3.new(targetPos.X - pos.X, 0, targetPos.Z - pos.Z)
		if dir.Magnitude < 0.05 then return end
		hrp.CFrame = CFrame.lookAt(pos, pos + dir.Unit)
	end)
end
local function apFaceDirection(hrp, hum, dir)
	pcall(function()
		if hum.AutoRotate then hum.AutoRotate = false end
		local pos = hrp.Position
		dir = Vector3.new(dir.X, 0, dir.Z)
		if dir.Magnitude < 0.05 then return end
		hrp.CFrame = CFrame.lookAt(pos, pos + dir.Unit)
	end)
end
local function apRestoreAutoRotate(hum)
	pcall(function()
		if not hum.AutoRotate then hum.AutoRotate = true end
	end)
end

local function autoPlayLogic(hrp, hum, char, now)
	local iHaveBomb = ap_hasBomb(char)
	if not iHaveBomb then
		if AP_State.LastHadBomb then
			AP_State.LastHadBomb = false
			AP_State.AutoPlayPhase = "idle"
			AP_State.AutoPlayEscaping = true
			AP_State.AutoPlayEscapeSub = "backdash"
			AP_State.AutoPlaySubStart = now
			AP_State.LastEnemyPos = nil
			local _, _, newHolderHrp = ap_getTarget(hrp)
			local awayDir
			if newHolderHrp then
				local diff = hrp.Position - newHolderHrp.Position
				diff = Vector3.new(diff.X, 0, diff.Z)
				if diff.Magnitude > 0.1 then awayDir = diff.Unit end
			end
			if not awayDir then
				local f = hrp.CFrame.LookVector
				f = Vector3.new(f.X, 0, f.Z)
				awayDir = f.Magnitude > 0.1 and -f.Unit or Vector3.new(0, 0, -1)
			end
			AP_State.AutoPlayEscapeTarget = hrp.Position + awayDir * AP_CONFIG.AutoPlayEscapeDistance
			hum.WalkSpeed = AP_CONFIG.AutoPlayEscapeSpeed
			apRestoreAutoRotate(hum)
			ap_moveTo(AP_State.AutoPlayEscapeTarget, hrp, hum)
			return
		end
		if AP_State.AutoPlayEscaping then
			local sub = AP_State.AutoPlayEscapeSub
			local subElapsed = now - AP_State.AutoPlaySubStart
			if sub == "backdash" then
				if subElapsed < AP_CONFIG.AutoPlayEscapeTime then
					hum.WalkSpeed = AP_CONFIG.AutoPlayEscapeSpeed
					local _, _, oHrp = ap_getTarget(hrp)
					if oHrp then
						local away = hrp.Position - oHrp.Position
						away = Vector3.new(away.X, 0, away.Z)
						if away.Magnitude > 0.1 then away = away.Unit else away = hrp.CFrame.LookVector end
						ap_moveTo(hrp.Position + away * 30, hrp, hum)
					elseif AP_State.AutoPlayEscapeTarget then
						ap_moveTo(AP_State.AutoPlayEscapeTarget, hrp, hum)
					end
				else
					AP_State.AutoPlayEscapeSub = "smartdodge"
					AP_State.AutoPlaySubStart = now
					AP_State.LastEnemyPos = nil
					hum.WalkSpeed = AP_CONFIG.DodgeSpeed
				end
				return
			end
			if sub == "smartdodge" then
				if subElapsed >= AP_CONFIG.AutoPlayDodgeTime then
					AP_State.AutoPlayEscapeSub = "crouch"
					AP_State.AutoPlaySubStart = now
					ap_doCrouch()
					return
				end
				local _, _, oHrp = ap_getTarget(hrp)
				if oHrp then
					local myPos = hrp.Position
					local enemyPos = oHrp.Position
					local away = myPos - enemyPos
					away = Vector3.new(away.X, 0, away.Z)
					if away.Magnitude > 0.1 then away = away.Unit else away = Vector3.new(0, 0, 1) end
					local bestDir, bestScore = away, -math.huge
					for i = 0, 15 do
						local angle = math.rad(i * 22.5)
						local dir = Vector3.new(math.cos(angle), 0, math.sin(angle))
						local score = (myPos + dir * 20 - enemyPos).Magnitude * 3 + dir:Dot(away) * 20
						if score > bestScore then bestScore = score; bestDir = dir end
					end
					hum.WalkSpeed = AP_CONFIG.DodgeSpeed
					ap_moveTo(myPos + bestDir * 25, hrp, hum)
				elseif AP_State.AutoPlayEscapeTarget then
					ap_moveTo(AP_State.AutoPlayEscapeTarget, hrp, hum)
				end
				return
			end
			if sub == "crouch" then
				local _, _, oHrp = ap_getTarget(hrp)
				if oHrp then
					local away = hrp.Position - oHrp.Position
					away = Vector3.new(away.X, 0, away.Z)
					if away.Magnitude > 0.1 then away = away.Unit else away = hrp.CFrame.LookVector end
					hum.WalkSpeed = 14
					ap_moveTo(hrp.Position + away * 20, hrp, hum)
				else
					hum.WalkSpeed = 0
				end
				if subElapsed >= AP_CONFIG.AutoPlayCrouchTime then
					AP_State.AutoPlayEscaping = false
					AP_State.AutoPlayEscapeSub = "none"
					hum.WalkSpeed = AP_CONFIG.ChaseSpeed
					apRestoreAutoRotate(hum)
				end
				return
			end
		end
		local _, _, oHrp = ap_getTarget(hrp)
		if oHrp then
			hum.WalkSpeed = AP_CONFIG.ChaseSpeed
			ap_backstabMove(oHrp, hrp, hum)
		end
		return
	end
	if AP_State.AutoPlayEscaping then
		AP_State.AutoPlayEscaping = false
		AP_State.AutoPlayEscapeSub = "none"
		ap_stopCrouch()
		apRestoreAutoRotate(hum)
	end
	if not AP_State.LastHadBomb then
		AP_State.LastHadBomb = true
		AP_State.AutoPlayPhase = "hold"
		AP_State.AutoPlayPhaseStart = now
	end
	local _, _, oHrp = ap_getTarget(hrp)
	if not oHrp then hum.WalkSpeed = AP_CONFIG.WalkSpeed; return end
	local myPos = hrp.Position
	local targetPos = oHrp.Position
	if AP_State.AutoPlayPhase == "hold" then
		if now - AP_State.AutoPlayPhaseStart < AP_CONFIG.AutoPlayHoldTime then
			local dir = targetPos - myPos
			dir = Vector3.new(dir.X, 0, dir.Z)
			if dir.Magnitude > AP_CONFIG.AutoPlayStayDistance + 0.5 then
				hum.WalkSpeed = AP_CONFIG.WalkSpeed
				ap_moveTo(targetPos - dir.Unit * AP_CONFIG.AutoPlayStayDistance, hrp, hum)
			else
				hum.WalkSpeed = 0
				pcall(function() hum:MoveTo(myPos) end)
			end
			return
		end
	end
	AP_State.AutoPlayPhase = "give"
	hum.WalkSpeed = AP_CONFIG.PassSpeed
	local dir = targetPos - myPos
	dir = Vector3.new(dir.X, 0, dir.Z)
	if dir.Magnitude > 0.05 then
		pcall(function() hum:MoveTo(targetPos) end)
	end
end

local function proModeLogic(hrp, hum, char, now)
	local iHaveBomb = ap_hasBomb(char)
	if not iHaveBomb then
		if ProState.WasHoldingBomb then
			ProState.WasHoldingBomb = false
			ProState.Phase = "reposition"
			ProState.PhaseStart = now
		end
		local _, _, oHrp = ap_getTarget(hrp)
		if not oHrp then hum.WalkSpeed = AP_CONFIG.WalkSpeed; return end
		local tF = oHrp.CFrame.LookVector
		tF = Vector3.new(tF.X, 0, tF.Z)
		if tF.Magnitude > 0.1 then tF = tF.Unit else tF = Vector3.new(0, 0, 1) end
		hum.WalkSpeed = AP_CONFIG.ChaseSpeed
		apFaceDirection(hrp, hum, tF)
		ap_moveTo(oHrp.Position - tF * PRO_CONFIG.BehindDistance, hrp, hum)
		return
	end
	if not ProState.WasHoldingBomb then
		ProState.WasHoldingBomb = true
		ProState.Phase = "hold"
		ProState.PhaseStart = now
	end
	local _, _, oHrp = ap_getTarget(hrp)
	if not oHrp then hum.WalkSpeed = AP_CONFIG.WalkSpeed; return end
	local myPos = hrp.Position
	local targetPos = oHrp.Position
	local tF = oHrp.CFrame.LookVector
	tF = Vector3.new(tF.X, 0, tF.Z)
	if tF.Magnitude > 0.1 then tF = tF.Unit else tF = Vector3.new(0, 0, 1) end
	if ProState.Phase == "hold" then
		local behindPos = targetPos - tF * PRO_CONFIG.BehindDistance
		if (myPos - behindPos).Magnitude > PRO_CONFIG.StickTolerance then
			hum.WalkSpeed = AP_CONFIG.ChaseSpeed
			apFaceDirection(hrp, hum, tF)
			ap_moveTo(behindPos, hrp, hum)
		else
			hum.WalkSpeed = 0
			apFaceDirection(hrp, hum, tF)
			pcall(function() hum:MoveTo(myPos) end)
		end
		if now - ProState.PhaseStart >= PRO_CONFIG.HoldBeforeFace then
			ProState.Phase = "facing"
			ProState.PhaseStart = now
		end
		return
	end
	if ProState.Phase == "facing" then
		hum.WalkSpeed = 0
		apForceLookAt(hrp, hum, targetPos)
		pcall(function() hum:MoveTo(myPos) end)
		if now - ProState.PhaseStart >= PRO_CONFIG.FaceDuration then
			ProState.Phase = "passing"
			ProState.PhaseStart = now
		end
		return
	end
	if ProState.Phase == "passing" then
		hum.WalkSpeed = PRO_CONFIG.PassSpeed
		apForceLookAt(hrp, hum, targetPos)
		local dir = targetPos - myPos
		dir = Vector3.new(dir.X, 0, dir.Z)
		if dir.Magnitude > 0.05 then
			pcall(function() hum:MoveTo(targetPos + dir.Unit * 5) end)
		end
		if not ap_hasBomb(char) then
			ProState.WasHoldingBomb = false
			ProState.Phase = "reposition"
			ProState.PhaseStart = now
			return
		end
		if now - ProState.PhaseStart > PRO_CONFIG.PassTimeout then
			ProState.Phase = "hold"
			ProState.PhaseStart = now
		end
		return
	end
end

function ap_mainLoop()
	if AP_State.LoopRunning then return end
	AP_State.LoopRunning = true
	task.spawn(function()
		while AP_State.Enabled do
			task.wait(AP_CONFIG.LoopDelay)
			local now = tick()
			pcall(function()
				local char = LP.Character
				if not char then return end
				local hrp = char:FindFirstChild("HumanoidRootPart")
				local hum = char:FindFirstChildOfClass("Humanoid")
				if not hrp or not hum then return end
				if ProState.Enabled then
					proModeLogic(hrp, hum, char, now)
					return
				end
				autoPlayLogic(hrp, hum, char, now)
			end)
		end
		AP_State.LoopRunning = false
	end)
end

tab:Toggle("Hitbox", false, function(enabled)
	hitboxEnabled = enabled
	if not enabled then
		for _, player in ipairs(Players:GetPlayers()) do restoredPart(player) end
		hitbox_original_properties = {}
	else
		updateHitboxes()
		task.spawn(function()
			while hitboxEnabled do
				updateHitboxes()
				task.wait(0.1)
			end
		end)
	end
end)

tab:Toggle("Auto Play", false, function(enabled)
	UIState.Auto = enabled
	refreshAP()
end)

tab:Toggle("Pro", false, function(enabled)
	UIState.Pro = enabled
	refreshAP()
end)

tab:Toggle("Lock", false, function(enabled)
	UIState.Lock = enabled
	LockState.Enabled = enabled
	if enabled then
		lockLoop()
	else
		LockLoopRunning = false
		local char = LP.Character
		if char then
			local hum = char:FindFirstChildOfClass("Humanoid")
			if hum then hum.AutoRotate = true end
		end
	end
end)

tab:Toggle("No Collision", false, function(enabled)
	noCollisionEnabled = enabled
	WarningText.Visible = enabled
	task.spawn(function()
		while noCollisionEnabled do
			if hitboxEnabled then updateHitboxes() end
			task.wait(0.05)
		end
	end)
end)

tab:Slider("Hitbox Size", 1, 20, 3, function(value)
	hitboxSize = value
	if hitboxEnabled then updateHitboxes() end
end)

tab:Slider("Hitbox Space", 1, 10, 3, function(value)
	hitboxTransparency = value
	if hitboxEnabled then updateHitboxes() end
end)

tab:Slider("Pro Space", 2, 20, 5, function(value)
	PRO_CONFIG.BehindDistance = value
end)

tab:Slider("Auto Play Space", 1, 10, 2, function(value)
	AP_CONFIG.AutoPlayStayDistance = value
end)

-- ============================================================
-- SETTINGS
-- ============================================================
local COLOR_PALETTE = {
	{name = "", c1 = Color3.fromRGB(230, 60, 60),  c2 = Color3.fromRGB(255, 120, 60)},
	{name = "", c1 = Color3.fromRGB(255, 140, 40), c2 = Color3.fromRGB(255, 80, 30)},
	{name = "", c1 = Color3.fromRGB(255, 200, 50), c2 = Color3.fromRGB(255, 140, 30)},
	{name = "", c1 = Color3.fromRGB(60, 210, 100), c2 = Color3.fromRGB(30, 170, 70)},
	{name = "", c1 = Color3.fromRGB(60, 180, 255), c2 = Color3.fromRGB(170, 110, 255)},
	{name = "", c1 = Color3.fromRGB(60, 120, 255), c2 = Color3.fromRGB(120, 80, 255)},
	{name = "", c1 = Color3.fromRGB(180, 100, 255), c2 = Color3.fromRGB(220, 70, 200)},
	{name = "", c1 = Color3.fromRGB(255, 100, 180), c2 = Color3.fromRGB(255, 60, 130)},
	{name = "", c1 = Color3.fromRGB(220, 220, 235), c2 = Color3.fromRGB(160, 160, 190)},
}

local SOUND_LIST = {
	{name = "FBI",  id = "rbxassetid://102865919016574", color = Color3.fromRGB(180, 210, 240), textColor = Color3.fromRGB(0, 0, 0)},
	{name = "king", id = "rbxassetid://114072050006157", color = Color3.fromRGB(255, 220, 100), textColor = Color3.fromRGB(0, 0, 0)},
	{name = "Rizz", id = "rbxassetid://89068385567682",  color = Color3.fromRGB(210, 180, 255), textColor = Color3.fromRGB(0, 0, 0)},
	{name = "Coin", id = "rbxassetid://75510526696824",  color = Color3.fromRGB(255, 235, 120), textColor = Color3.fromRGB(0, 0, 0)},
	{name = "No",   id = "",                              color = Color3.fromRGB(220, 50, 50),  textColor = Color3.fromRGB(255, 255, 255), isNo = true},
}

local VIDEO_LIST = {
	{name = "Video 1", id = "rbxassetid://74895850882339",  color = Color3.fromRGB(20, 20, 20), textColor = Color3.fromRGB(255, 255, 255)},
	{name = "Video 2", id = "rbxassetid://133682020019480", color = Color3.fromRGB(20, 20, 20), textColor = Color3.fromRGB(255, 255, 255)},
	{name = "Video 3", id = "rbxassetid://72231213528855",  color = Color3.fromRGB(20, 20, 20), textColor = Color3.fromRGB(255, 255, 255)},
	{name = "Video 4", id = "rbxassetid://124123680327164", color = Color3.fromRGB(20, 20, 20), textColor = Color3.fromRGB(255, 255, 255)},
	{name = "Video 5", id = "rbxassetid://71061449238812",  color = Color3.fromRGB(20, 20, 20), textColor = Color3.fromRGB(255, 255, 255)},
	{name = "Video 6", id = "rbxassetid://115153161936086", color = Color3.fromRGB(20, 20, 20), textColor = Color3.fromRGB(255, 255, 255)},
	{name = "Video 7", id = "rbxassetid://139128960634355", color = Color3.fromRGB(20, 20, 20), textColor = Color3.fromRGB(255, 255, 255)},
	{name = "Video 8", id = "rbxassetid://110782213940529", color = Color3.fromRGB(20, 20, 20), textColor = Color3.fromRGB(255, 255, 255)},
	{name = "Video 9", id = "rbxassetid://87570666848900",  color = Color3.fromRGB(20, 20, 20), textColor = Color3.fromRGB(255, 255, 255)},
	{name = "Video 10", id = "rbxassetid://93297302504653", color = Color3.fromRGB(20, 20, 20), textColor = Color3.fromRGB(255, 255, 255)},
	{name = "Video 11", id = "rbxassetid://97647421021323", color = Color3.fromRGB(20, 20, 20), textColor = Color3.fromRGB(255, 255, 255)},
	{name = "Video 12", id = "rbxassetid://15689451063",    color = Color3.fromRGB(20, 20, 20), textColor = Color3.fromRGB(255, 255, 255)},
	{name = "Video 13", id = "rbxassetid://131794008455004", color = Color3.fromRGB(20, 20, 20), textColor = Color3.fromRGB(255, 255, 255)},
	{name = "Video 14", id = "rbxassetid://126189830749452", color = Color3.fromRGB(20, 20, 20), textColor = Color3.fromRGB(255, 255, 255)},
	{name = "No Video", id = "", color = Color3.fromRGB(220, 50, 50), textColor = Color3.fromRGB(255, 255, 255), isNo = true},
}

local SKIN_LIST = {
	{name = "Skin 1", id = "YOUR_SKIN_ID_HERE", color = Color3.fromRGB(50, 50, 50), textColor = Color3.fromRGB(255, 255, 255)},
	{name = "No Skin", id = "", color = Color3.fromRGB(220, 50, 50), textColor = Color3.fromRGB(255, 255, 255), isNo = true},
}

settingsTab:ColorPicker("Colors", COLOR_PALETTE, function(c1, c2)
	win:SetColor(c1, c2)
end)

settingsTab:SoundPicker("Sounds", SOUND_LIST, function(soundId)
	currentSoundId = soundId
	if activeLoopSound then
		activeLoopSound:Stop()
		activeLoopSound:Destroy()
		activeLoopSound = nil
	end
end)

settingsTab:VideoPicker("Video", VIDEO_LIST)

settingsTab:SkinPicker("Skins", SKIN_LIST, function(skinId)
	if skinId == "" then return end
	tryApplySkin(skinId)
end)

-- ===== Custom Sound/Video ID =====
local customSoundHolder = Instance.new("Frame")
customSoundHolder.Size = UDim2.new(1, 0, 0, 65)
customSoundHolder.BackgroundColor3 = Color3.fromRGB(25, 30, 55)
customSoundHolder.BorderSizePixel = 0
customSoundHolder.ZIndex = 5
customSoundHolder.Parent = settingsTab.page

local chc = Instance.new("UICorner")
chc.CornerRadius = UDim.new(0, 6)
chc.Parent = customSoundHolder

local lbl = Instance.new("TextLabel")
lbl.BackgroundTransparency = 1
lbl.Position = UDim2.new(0, 10, 0, 5)
lbl.Size = UDim2.new(1, -20, 0, 16)
lbl.Font = Enum.Font.GothamSemibold
lbl.TextSize = 11
lbl.TextColor3 = Color3.fromRGB(240, 245, 255)
lbl.Text = "Custom Sound/Video ID"
lbl.TextXAlignment = Enum.TextXAlignment.Left
lbl.ZIndex = 6
lbl.Parent = customSoundHolder

local idInput = Instance.new("TextBox")
idInput.Size = UDim2.new(1, -80, 0, 26)
idInput.Position = UDim2.new(0, 10, 0, 28)
idInput.BackgroundColor3 = Color3.fromRGB(18, 22, 42)
idInput.BorderSizePixel = 0
idInput.Font = Enum.Font.Gotham
idInput.TextSize = 11
idInput.TextColor3 = Color3.new(1, 1, 1)
idInput.PlaceholderText = "Paste ID here..."
idInput.Text = ""
idInput.ClearTextOnFocus = false
idInput.ZIndex = 6
idInput.Parent = customSoundHolder

local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 4)
inputCorner.Parent = idInput

local playBtn = Instance.new("TextButton")
playBtn.Size = UDim2.new(0, 60, 0, 26)
playBtn.Position = UDim2.new(1, -70, 0, 28)
playBtn.BackgroundColor3 = Color3.fromRGB(60, 180, 255)
playBtn.BorderSizePixel = 0
playBtn.Font = Enum.Font.GothamBold
playBtn.TextSize = 11
playBtn.TextColor3 = Color3.new(1, 1, 1)
playBtn.Text = "Play"
playBtn.ZIndex = 6
playBtn.Parent = customSoundHolder

local playCorner = Instance.new("UICorner")
playCorner.CornerRadius = UDim.new(0, 4)
playCorner.Parent = playBtn

local isPlayingCustom = false

playBtn.MouseButton1Click:Connect(function()
    if isPlayingCustom then
        if activeLoopSound then
            activeLoopSound:Stop()
            activeLoopSound:Destroy()
            activeLoopSound = nil
        end
        isPlayingCustom = false
        playBtn.Text = "Play"
        playBtn.BackgroundColor3 = Color3.fromRGB(60, 180, 255)
        return
    end

    local inputText = idInput.Text
    local id = inputText:match("%d+")
    if not id then return end
    
    if activeLoopSound then
        activeLoopSound:Stop()
        activeLoopSound:Destroy()
        activeLoopSound = nil
    end
    
    local s = Instance.new("Sound")
    s.SoundId = "rbxassetid://" .. id
    s.Volume = 0.7
    s.Looped = true
    s.Parent = soundFolder
    s:Play()
    
    activeLoopSound = s
    isPlayingCustom = true
    playBtn.Text = "Stop"
    playBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
    
    playKeySound()
end)

-- ===== Custom Skin Code =====
local customSkinHolder = Instance.new("Frame")
customSkinHolder.Size = UDim2.new(1, 0, 0, 65)
customSkinHolder.BackgroundColor3 = Color3.fromRGB(25, 30, 55)
customSkinHolder.BorderSizePixel = 0
customSkinHolder.ZIndex = 5
customSkinHolder.Parent = settingsTab.page

local cshc = Instance.new("UICorner")
cshc.CornerRadius = UDim.new(0, 6)
cshc.Parent = customSkinHolder

local skinLbl = Instance.new("TextLabel")
skinLbl.BackgroundTransparency = 1
skinLbl.Position = UDim2.new(0, 10, 0, 5)
skinLbl.Size = UDim2.new(1, -20, 0, 16)
skinLbl.Font = Enum.Font.GothamSemibold
skinLbl.TextSize = 11
skinLbl.TextColor3 = Color3.fromRGB(240, 245, 255)
skinLbl.Text = "Custom Skin Code (any format)"
skinLbl.TextXAlignment = Enum.TextXAlignment.Left
skinLbl.ZIndex = 6
skinLbl.Parent = customSkinHolder

local skinInput = Instance.new("TextBox")
skinInput.Size = UDim2.new(1, -80, 0, 26)
skinInput.Position = UDim2.new(0, 10, 0, 28)
skinInput.BackgroundColor3 = Color3.fromRGB(18, 22, 42)
skinInput.BorderSizePixel = 0
skinInput.Font = Enum.Font.Gotham
skinInput.TextSize = 11
skinInput.TextColor3 = Color3.new(1, 1, 1)
skinInput.PlaceholderText = "Enter any code (B1F9AB, UUID, etc.)..."
skinInput.Text = ""
skinInput.ClearTextOnFocus = false
skinInput.ZIndex = 6
skinInput.Parent = customSkinHolder

local skinInputCorner = Instance.new("UICorner")
skinInputCorner.CornerRadius = UDim.new(0, 4)
skinInputCorner.Parent = skinInput

local applyBtn = Instance.new("TextButton")
applyBtn.Size = UDim2.new(0, 60, 0, 26)
applyBtn.Position = UDim2.new(1, -70, 0, 28)
applyBtn.BackgroundColor3 = Color3.fromRGB(60, 180, 255)
applyBtn.BorderSizePixel = 0
applyBtn.Font = Enum.Font.GothamBold
applyBtn.TextSize = 11
applyBtn.TextColor3 = Color3.new(1, 1, 1)
applyBtn.Text = "Apply"
applyBtn.ZIndex = 6
applyBtn.Parent = customSkinHolder

local applyCorner = Instance.new("UICorner")
applyCorner.CornerRadius = UDim.new(0, 4)
applyCorner.Parent = applyBtn

applyBtn.MouseButton1Click:Connect(function()
    local raw = skinInput.Text
    if not raw or raw == "" then
        print("[Skin] Empty input")
        return
    end
    print("[Skin] Trying code: " .. raw)
    tryApplySkin(raw)
    playKeySound()
end)

UIS.InputBegan:Connect(function(input, gp)
	if gp then return end
	if input.KeyCode == AP_CONFIG.ToggleKey then
		UIState.Auto = not UIState.Auto
		refreshAP()
	end
	if input.KeyCode == Enum.KeyCode.L then
		UIState.Lock = not UIState.Lock
		LockState.Enabled = UIState.Lock
		if LockState.Enabled then lockLoop()
		else
			LockLoopRunning = false
			local char = LP.Character
			if char then
				local hum = char:FindFirstChildOfClass("Humanoid")
				if hum then hum.AutoRotate = true end
			end
		end
	end
end)

print("[Syrianhub] Loaded | https://discord.gg/yM4QS7HJ6")