local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

local Player = Players.LocalPlayer
local MapID = tostring(game.PlaceId)

-- ลบ UI เก่าหากมีอยู่
pcall(function()
	if CoreGui:FindFirstChild("X-WACK_STORE") then
		CoreGui["X-WACK_STORE"]:Destroy()
	end
end)

local Library = {}

-- [[ ฟังก์ชันทำให้ Frame ลากได้ ]]
local function MakeDraggable(frame, handle)
	local dragging, dragInput, dragStart, startPos
	handle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = frame.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then dragging = false end
			end)
		end
	end)
	frame.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			local delta = input.Position - dragStart
			frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
end

-- [[ สร้างหน้าต่างหลัก (ปรับขนาดให้เล็กลง Compact Size) ]]
function Library:NewWindow(title)
	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "X-WACK_STORE"
	ScreenGui.ResetOnSpawn = false
	ScreenGui.Parent = CoreGui

	local MainFrame = Instance.new("Frame")
	MainFrame.Name = "MainFrame"
	MainFrame.Size = UDim2.new(0, 440, 0, 280) -- ปรับขนาดให้เล็กลง ไม่เกะกะ
	MainFrame.Position = UDim2.new(0.5, -220, 0.5, -140)
	MainFrame.BackgroundColor3 = Color3.fromRGB(15, 16, 22)
	MainFrame.BorderSizePixel = 0
	MainFrame.Parent = ScreenGui

	Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)

	-- Glow Stroke
	local GlowFrame = Instance.new("Frame", MainFrame)
	GlowFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	GlowFrame.Position = UDim2.fromScale(0.5, 0.5)
	GlowFrame.Size = UDim2.new(1, 6, 1, 6)
	GlowFrame.BackgroundTransparency = 1
	GlowFrame.ZIndex = 0
	Instance.new("UICorner", GlowFrame).CornerRadius = UDim.new(0, 10)

	local GlowStroke = Instance.new("UIStroke", GlowFrame)
	GlowStroke.Thickness = 2
	GlowStroke.Transparency = 0.6

	local Stroke = Instance.new("UIStroke", MainFrame)
	Stroke.Thickness = 1.2
	Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

	local UIGradient = Instance.new("UIGradient", Stroke)
	UIGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 210, 255)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 0, 130)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 210, 255))
	})

	task.spawn(function()
		local rot = 0
		while task.wait() do
			rot = (rot + 1.5) % 360
			UIGradient.Rotation = rot
			GlowStroke.Color = Color3.fromHSV((rot / 360), 0.75, 1)
		end
	end)

	-- Title Bar (ขนาดเล็กลง)
	local TitleBar = Instance.new("Frame", MainFrame)
	TitleBar.Size = UDim2.new(1, 0, 0, 32)
	TitleBar.BackgroundColor3 = Color3.fromRGB(20, 22, 30)
	TitleBar.BorderSizePixel = 0
	Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 8)

	local TitleBottomCover = Instance.new("Frame", TitleBar)
	TitleBottomCover.Size = UDim2.new(1, 0, 0, 8)
	TitleBottomCover.Position = UDim2.new(0, 0, 1, -8)
	TitleBottomCover.BackgroundColor3 = Color3.fromRGB(20, 22, 30)
	TitleBottomCover.BorderSizePixel = 0

	local TitleLabel = Instance.new("TextLabel", TitleBar)
	TitleLabel.Size = UDim2.new(1, -50, 1, 0)
	TitleLabel.Position = UDim2.new(0, 12, 0, 0)
	TitleLabel.BackgroundTransparency = 1
	TitleLabel.Text = title
	TitleLabel.TextColor3 = Color3.fromRGB(240, 240, 250)
	TitleLabel.Font = Enum.Font.GothamBold
	TitleLabel.TextSize = 11
	TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

	local CloseBtn = Instance.new("TextButton", TitleBar)
	CloseBtn.Size = UDim2.fromOffset(18, 18)
	CloseBtn.Position = UDim2.new(1, -26, 0.5, -9)
	CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 90)
	CloseBtn.Text = "✕"
	CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	CloseBtn.Font = Enum.Font.GothamBold
	CloseBtn.TextSize = 9
	CloseBtn.AutoButtonColor = false
	Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 5)

	CloseBtn.MouseButton1Click:Connect(function()
		TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Size = UDim2.fromOffset(0, 0), BackgroundTransparency = 1}):Play()
		task.wait(0.2)
		ScreenGui:Destroy()
	end)

	-- Sidebar (ย่อให้แคบลง)
	local Sidebar = Instance.new("Frame", MainFrame)
	Sidebar.Size = UDim2.new(0, 110, 1, -38)
	Sidebar.Position = UDim2.new(0, 5, 0, 33)
	Sidebar.BackgroundColor3 = Color3.fromRGB(11, 12, 16)
	Sidebar.BorderSizePixel = 0
	Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 6)

	local SidebarList = Instance.new("ScrollingFrame", Sidebar)
	SidebarList.Size = UDim2.new(1, -6, 1, -8)
	SidebarList.Position = UDim2.new(0, 3, 0, 4)
	SidebarList.BackgroundTransparency = 1
	SidebarList.ScrollBarThickness = 0
	SidebarList.AutomaticCanvasSize = Enum.AutomaticSize.Y

	local SidebarLayout = Instance.new("UIListLayout", SidebarList)
	SidebarLayout.Padding = UDim.new(0, 4)

	-- Content Area
	local ContentFrame = Instance.new("Frame", MainFrame)
	ContentFrame.Size = UDim2.new(1, -125, 1, -38)
	ContentFrame.Position = UDim2.new(0, 120, 0, 33)
	ContentFrame.BackgroundTransparency = 1

	-- Floating Toggle Button
	local ToggleBtn = Instance.new("TextButton", ScreenGui)
	ToggleBtn.Size = UDim2.new(0, 36, 0, 36)
	ToggleBtn.Position = UDim2.new(0, 20, 0.5, -18)
	ToggleBtn.BackgroundColor3 = Color3.fromRGB(20, 22, 30)
	ToggleBtn.Text = "W"
	ToggleBtn.TextColor3 = Color3.fromRGB(0, 210, 255)
	ToggleBtn.Font = Enum.Font.GothamBold
	ToggleBtn.TextSize = 14
	ToggleBtn.AutoButtonColor = false
	Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)

	local ToggleStroke = Instance.new("UIStroke", ToggleBtn)
	ToggleStroke.Color = Color3.fromRGB(0, 210, 255)
	ToggleStroke.Thickness = 1.2

	ToggleBtn.MouseButton1Click:Connect(function()
		MainFrame.Visible = not MainFrame.Visible
		ToggleBtn.Text = MainFrame.Visible and "✕" or "W"
		ToggleBtn.TextColor3 = MainFrame.Visible and Color3.fromRGB(255, 0, 130) or Color3.fromRGB(0, 210, 255)
		ToggleStroke.Color = ToggleBtn.TextColor3
	end)

	MakeDraggable(MainFrame, TitleBar)
	MakeDraggable(ToggleBtn, ToggleBtn)

	local Tabs = {}
	local WindowFunctions = {}

	function WindowFunctions:NewTab(name, icon)
		local TabBtn = Instance.new("TextButton", SidebarList)
		TabBtn.Size = UDim2.new(1, 0, 0, 28)
		TabBtn.BackgroundColor3 = Color3.fromRGB(22, 24, 34)
		TabBtn.BackgroundTransparency = 1
		TabBtn.Text = " " .. icon .. " " .. name
		TabBtn.TextColor3 = Color3.fromRGB(130, 135, 150)
		TabBtn.Font = Enum.Font.GothamMedium
		TabBtn.TextSize = 11
		TabBtn.TextXAlignment = Enum.TextXAlignment.Left
		TabBtn.AutoButtonColor = false
		Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 5)

		local TabStroke = Instance.new("UIStroke", TabBtn)
		TabStroke.Thickness = 1
		TabStroke.Color = Color3.fromRGB(0, 210, 255)
		TabStroke.Transparency = 1

		local TabContent = Instance.new("ScrollingFrame", ContentFrame)
		TabContent.Size = UDim2.new(1, -5, 1, -5)
		TabContent.BackgroundTransparency = 1
		TabContent.Visible = false
		TabContent.ScrollBarThickness = 2
		TabContent.ScrollBarImageColor3 = Color3.fromRGB(40, 45, 60)
		TabContent.AutomaticCanvasSize = Enum.AutomaticSize.Y

		local ContentLayout = Instance.new("UIListLayout", TabContent)
		ContentLayout.Padding = UDim.new(0, 5)

		TabBtn.MouseButton1Click:Connect(function()
			for _, v in pairs(Tabs) do
				TweenService:Create(v.Btn, TweenInfo.new(0.15), {BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(130, 135, 150)}):Play()
				TweenService:Create(v.Stroke, TweenInfo.new(0.15), {Transparency = 1}):Play()
				v.Content.Visible = false
			end
			TweenService:Create(TabBtn, TweenInfo.new(0.15), {BackgroundTransparency = 0, TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
			TweenService:Create(TabStroke, TweenInfo.new(0.15), {Transparency = 0.8}):Play()
			TabContent.Visible = true
		end)

		table.insert(Tabs, {Btn = TabBtn, Content = TabContent, Stroke = TabStroke})

		local TabFunctions = {Content = TabContent}

		-- Container สำหรับจัดปุ่มแบบ Grid (2 ปุ่มต่อแถว ไม่ให้หน้าจอโล่ง)
		function TabFunctions:CreateGrid()
			local GridFrame = Instance.new("Frame", TabContent)
			GridFrame.Size = UDim2.new(1, 0, 0, 0)
			GridFrame.BackgroundTransparency = 1
			GridFrame.AutomaticSize = Enum.AutomaticSize.Y

			local GridLayout = Instance.new("UIGridLayout", GridFrame)
			GridLayout.CellSize = UDim2.new(0.5, -3, 0, 28)
			GridLayout.CellPadding = UDim2.new(0, 6, 0, 5)

			return GridFrame
		end

		-- สร้างปุ่ม
		function TabFunctions:NewButton(text, parent, callback)
			local targetParent = parent or TabContent
			local Button = Instance.new("TextButton", targetParent)
			Button.Size = UDim2.new(1, 0, 0, 28)
			Button.BackgroundColor3 = Color3.fromRGB(22, 25, 36)
			Button.Text = text
			Button.TextColor3 = Color3.fromRGB(220, 225, 235)
			Button.Font = Enum.Font.GothamMedium
			Button.TextSize = 11
			Button.AutoButtonColor = false
			Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 5)

			local BtnStroke = Instance.new("UIStroke", Button)
			BtnStroke.Thickness = 1
			BtnStroke.Color = Color3.fromRGB(32, 36, 52)

			Button.MouseEnter:Connect(function()
				TweenService:Create(Button, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(30, 34, 50)}):Play()
				TweenService:Create(BtnStroke, TweenInfo.new(0.1), {Color = Color3.fromRGB(0, 210, 255)}):Play()
			end)

			Button.MouseLeave:Connect(function()
				TweenService:Create(Button, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(22, 25, 36)}):Play()
				TweenService:Create(BtnStroke, TweenInfo.new(0.1), {Color = Color3.fromRGB(32, 36, 52)}):Play()
			end)

			Button.MouseButton1Click:Connect(function()
				pcall(callback)
			end)
			return Button
		end

		-- ช่องกรอกโค้ด
		function TabFunctions:NewTextBox(placeholder)
			local BoxFrame = Instance.new("Frame", TabContent)
			BoxFrame.Size = UDim2.new(1, 0, 0, 125)
			BoxFrame.BackgroundColor3 = Color3.fromRGB(10, 11, 16)
			Instance.new("UICorner", BoxFrame).CornerRadius = UDim.new(0, 5)

			local BoxStroke = Instance.new("UIStroke", BoxFrame)
			BoxStroke.Thickness = 1
			BoxStroke.Color = Color3.fromRGB(28, 30, 44)

			local TextBox = Instance.new("TextBox", BoxFrame)
			TextBox.Size = UDim2.new(1, 0, 1, 0)
			TextBox.BackgroundTransparency = 1
			TextBox.PlaceholderText = placeholder or "วางโค้ดที่นี่..."
			TextBox.PlaceholderColor3 = Color3.fromRGB(80, 85, 100)
			TextBox.Text = ""
			TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
			TextBox.Font = Enum.Font.Code
			TextBox.TextSize = 10
			TextBox.TextXAlignment = Enum.TextXAlignment.Left
			TextBox.TextYAlignment = Enum.TextYAlignment.Top
			TextBox.ClearTextOnFocus = false
			TextBox.MultiLine = true
			TextBox.TextWrapped = true

			local Padding = Instance.new("UIPadding", TextBox)
			Padding.PaddingTop = UDim.new(0, 6)
			Padding.PaddingLeft = UDim.new(0, 6)
			Padding.PaddingRight = UDim.new(0, 6)
			Padding.PaddingBottom = UDim.new(0, 6)

			TextBox.Focused:Connect(function()
				TweenService:Create(BoxStroke, TweenInfo.new(0.15), {Color = Color3.fromRGB(0, 210, 255)}):Play()
			end)
			TextBox.FocusLost:Connect(function()
				TweenService:Create(BoxStroke, TweenInfo.new(0.15), {Color = Color3.fromRGB(28, 30, 44)}):Play()
			end)

			return TextBox
		end

		-- Toggle Switch
		function TabFunctions:NewToggle(text, callback)
			local TglFrame = Instance.new("Frame", TabContent)
			TglFrame.Size = UDim2.new(1, 0, 0, 28)
			TglFrame.BackgroundColor3 = Color3.fromRGB(22, 25, 36)
			Instance.new("UICorner", TglFrame).CornerRadius = UDim.new(0, 5)

			local TglStroke = Instance.new("UIStroke", TglFrame)
			TglStroke.Thickness = 1
			TglStroke.Color = Color3.fromRGB(32, 36, 52)

			local TglLabel = Instance.new("TextLabel", TglFrame)
			TglLabel.Size = UDim2.new(1, -45, 1, 0)
			TglLabel.Position = UDim2.new(0, 8, 0, 0)
			TglLabel.BackgroundTransparency = 1
			TglLabel.Text = text
			TglLabel.TextColor3 = Color3.fromRGB(180, 185, 195)
			TglLabel.Font = Enum.Font.GothamMedium
			TglLabel.TextSize = 11
			TglLabel.TextXAlignment = Enum.TextXAlignment.Left

			local SwitchBg = Instance.new("Frame", TglFrame)
			SwitchBg.Size = UDim2.new(0, 28, 0, 14)
			SwitchBg.Position = UDim2.new(1, -34, 0.5, -7)
			SwitchBg.BackgroundColor3 = Color3.fromRGB(40, 43, 58)
			Instance.new("UICorner", SwitchBg).CornerRadius = UDim.new(1, 0)

			local SwitchBall = Instance.new("Frame", SwitchBg)
			SwitchBall.Size = UDim2.new(0, 10, 0, 10)
			SwitchBall.Position = UDim2.new(0, 2, 0.5, -5)
			SwitchBall.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Instance.new("UICorner", SwitchBall).CornerRadius = UDim.new(1, 0)

			local ClickBtn = Instance.new("TextButton", TglFrame)
			ClickBtn.Size = UDim2.new(1, 0, 1, 0)
			ClickBtn.BackgroundTransparency = 1
			ClickBtn.Text = ""

			local state = false

			ClickBtn.MouseButton1Click:Connect(function()
				state = not state
				if state then
					TweenService:Create(SwitchBg, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(0, 210, 255)}):Play()
					TweenService:Create(SwitchBall, TweenInfo.new(0.1), {Position = UDim2.new(1, -12, 0.5, -5)}):Play()
					TglLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
				else
					TweenService:Create(SwitchBg, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(40, 43, 58)}):Play()
					TweenService:Create(SwitchBall, TweenInfo.new(0.1), {Position = UDim2.new(0, 2, 0.5, -5)}):Play()
					TglLabel.TextColor3 = Color3.fromRGB(180, 185, 195)
				end
				pcall(callback, state)
			end)
		end

		return TabFunctions
	end

	task.spawn(function()
		task.wait(0.05)
		if Tabs[1] then
			Tabs[1].Btn.BackgroundTransparency = 0
			Tabs[1].Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
			Tabs[1].Stroke.Transparency = 0.8
			Tabs[1].Content.Visible = true
		end
	end)

	return WindowFunctions
end

-- [[ เริ่มต้น UI ]]
local Window = Library:NewWindow("X-WACK STORE | V7")

local MainTab = Window:NewTab("ตัวรันโค้ด", "⚡")
local HistoryTab = Window:NewTab("ประวัติไฟล์", "📂")

-- 1. ช่องกรอกโค้ด
local CodeBox = MainTab:NewTextBox("วางโค้ด Luau / Roblox Script ที่นี่...")

-- 2. สร้างแถบปุ่มแบบ Grid (2 คอลัมน์) กระชับ ไม่ว่างเปล่า
local BtnGrid = MainTab:CreateGrid()

MainTab:NewButton("▶ รันโค้ด", BtnGrid, function()
	if CodeBox.Text ~= "" then
		local func, err = loadstring(CodeBox.Text)
		if func then
			task.spawn(func)
		else
			warn("Execute Error: ", err)
		end
	end
end)

MainTab:NewButton("📋 คัดลอกโค้ด", BtnGrid, function()
	if setclipboard then
		setclipboard(CodeBox.Text)
		game:GetService("StarterGui"):SetCore("SendNotification", {Title = "X-WACK", Text = "คัดลอกลง Clipboard แล้ว!", Duration = 2})
	end
end)

MainTab:NewButton("💾 บันทึกโค้ด", BtnGrid, function()
	if CodeBox.Text == "" or not writefile then return end
	local folder = "PisitSaves/" .. MapID
	if not isfolder("PisitSaves") then makefolder("PisitSaves") end
	if not isfolder(folder) then makefolder(folder) end
	
	writefile(folder .. "/Save_" .. os.time() .. ".lua", CodeBox.Text)
	game:GetService("StarterGui"):SetCore("SendNotification", {Title = "X-WACK", Text = "บันทึกไฟล์เรียบร้อย!", Duration = 2})
end)

MainTab:NewButton("🗑️ ล้างข้อความ", BtnGrid, function()
	CodeBox.Text = ""
end)

-- 3. ระบบรันรัวๆ (ปรับความไวเป็น 0.01 แล้ว)
local IsSpamming = false
MainTab:NewToggle("🔥 Auto Run Loop (ความเร็ว 0.01s)", function(state)
	IsSpamming = state
	task.spawn(function()
		while IsSpamming do
			if CodeBox.Text ~= "" then
				pcall(function()
					loadstring(CodeBox.Text)()
				end)
			end
			task.wait(0.01) -- ความเร็วตามที่ขอ
		end
	end)
end)

-- [[ หน้าประวัติการบันทึก ]]
local function RefreshHistory()
	for _, child in pairs(HistoryTab.Content:GetChildren()) do
		if child:IsA("Frame") then child:Destroy() end
	end

	local folder = "PisitSaves/" .. MapID
	if isfolder and isfolder(folder) then
		for _, file in pairs(listfiles(folder)) do
			local EntryFrame = Instance.new("Frame", HistoryTab.Content)
			EntryFrame.Size = UDim2.new(1, 0, 0, 30)
			EntryFrame.BackgroundColor3 = Color3.fromRGB(22, 25, 36)
			Instance.new("UICorner", EntryFrame).CornerRadius = UDim.new(0, 5)

			local EntryStroke = Instance.new("UIStroke", EntryFrame)
			EntryStroke.Thickness = 1
			EntryStroke.Color = Color3.fromRGB(32, 36, 52)

			local Label = Instance.new("TextLabel", EntryFrame)
			Label.Size = UDim2.new(1, -115, 1, 0)
			Label.Position = UDim2.new(0, 8, 0, 0)
			Label.BackgroundTransparency = 1
			Label.Text = file:sub(#folder + 2)
			Label.TextColor3 = Color3.fromRGB(210, 215, 225)
			Label.Font = Enum.Font.GothamMedium
			Label.TextSize = 10
			Label.TextXAlignment = Enum.TextXAlignment.Left

			-- ปุ่มโหลด
			local UseBtn = Instance.new("TextButton", EntryFrame)
			UseBtn.Size = UDim2.new(0, 34, 0, 20)
			UseBtn.Position = UDim2.new(1, -108, 0.5, -10)
			UseBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
			UseBtn.Text = "โหลด"
			UseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
			UseBtn.Font = Enum.Font.GothamBold
			UseBtn.TextSize = 10
			Instance.new("UICorner", UseBtn).CornerRadius = UDim.new(0, 4)

			UseBtn.MouseButton1Click:Connect(function()
				if readfile then CodeBox.Text = readfile(file) end
			end)

			-- ปุ่มรันทันที
			local ExecBtn = Instance.new("TextButton", EntryFrame)
			ExecBtn.Size = UDim2.new(0, 34, 0, 20)
			ExecBtn.Position = UDim2.new(1, -70, 0.5, -10)
			ExecBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
			ExecBtn.Text = "รัน"
			ExecBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
			ExecBtn.Font = Enum.Font.GothamBold
			ExecBtn.TextSize = 10
			Instance.new("UICorner", ExecBtn).CornerRadius = UDim.new(0, 4)

			ExecBtn.MouseButton1Click:Connect(function()
				if readfile then pcall(loadstring(readfile(file))) end
			end)

			-- ปุ่มลบ
			local DelBtn = Instance.new("TextButton", EntryFrame)
			DelBtn.Size = UDim2.new(0, 30, 0, 20)
			DelBtn.Position = UDim2.new(1, -33, 0.5, -10)
			DelBtn.BackgroundColor3 = Color3.fromRGB(235, 50, 70)
			DelBtn.Text = "ลบ"
			DelBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
			DelBtn.Font = Enum.Font.GothamBold
			DelBtn.TextSize = 10
			Instance.new("UICorner", DelBtn).CornerRadius = UDim.new(0, 4)

			DelBtn.MouseButton1Click:Connect(function()
				if delfile then
					delfile(file)
					EntryFrame:Destroy()
				end
			end)
		end
	end
end

HistoryTab:NewButton("🔄 รีเฟรชรายการไฟล์", nil, function()
	RefreshHistory()
end)

RefreshHistory()

game:GetService("StarterGui"):SetCore("SendNotification", {
	Title = "X-WACK STORE",
	Text = "ปรับปรุง UI สำเร็จ พร้อมใช้งาน!",
	Duration = 3
})
