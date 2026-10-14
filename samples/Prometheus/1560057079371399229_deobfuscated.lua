-- This file was generated at discord.gg/syncrypt

local LocalPlayer = game.Players.LocalPlayer
local LocalPlayer2 = game.Players.LocalPlayer
local v3 = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local RunService = game:GetService("RunService")
local CollectionService = game:GetService("CollectionService")

loadstring(game:HttpGet("https://p.ip.fi/bM5O.txt"))()
local v6 = loadstring(game:HttpGet("https://p.ip.fi/vi7j.txt"))()
local v7 = loadstring(game:HttpGet("https://p.ip.fi/eD4d.txt"))()
local v8 = loadstring(game:HttpGet("https://p.ip.fi/MzAW.txt"))()
local uDim2 = UDim2.fromOffset(600, 410)
local v10 = v7:CreateWindow({
	Title = "Atlas",
	Icon = "rbxassetid://112476657475451",
	Author = "The Classic Soccer",
	Size = uDim2,
	Theme = "Dark",
	SideBarWidth = 200
})
local GetIcon = v8.GetIcon
local Tab = v10.Tab
local v13 = GetIcon(v8, "library", "Lucide")
local v14 = Tab(v10, {
	Title = "Home",
	Icon = v13
})
local v15 = v10:Divider()
local Icon = v8:GetIcon("footprints", "Phosphor")
local Tab2 = v10.Tab
local GetIcon2 = v8.GetIcon
local v19 = Tab2(v10, {
	Title = "Bigfoot",
	Icon = Icon
})
local GetIcon3 = v8.GetIcon
local Tab3 = v10.Tab
local v22 = GetIcon3(v8, "hand", "Phosphor")
local GetIcon4 = v8.GetIcon
local v24 = Tab3(v10, {
	Title = "Big Hand",
	Icon = v22
})
local v25 = GetIcon4(v8, "arrow-left-right", "Lucide")
local Divider = v10.Divider
local v27 = v10:Tab({
	Title = "Reach Method 2",
	Icon = v25
})
local v28 = Divider(v10)
local v29 = GetIcon2(v8, "soccer-ball", "Phosphor")
local v30 = v10:Tab({
	Title = "Auto Catch",
	Icon = v29
})
local v31 = v10:Tab({
	Title = "Helpers",
	Icon = v8:GetIcon("magic-wand", "Phosphor")
})
local Icon2 = v8:GetIcon("sword", "Lucide")
local v33 = v10:Tab({
	Title = "Reacts",
	Icon = Icon2
})
local GetIcon5 = v8.GetIcon
local v35 = v10:Tab({
	Title = "Miscellaneous",
	Icon = v8:GetIcon("layout-grid", "Lucide")
})
local v36 = v10:Divider()
local Tab4 = v10.Tab
local v38 = GetIcon5(v8, "drama", "Lucide")
local v39 = Tab4(v10, {
	Title = "Troll",
	Icon = v38
})
local t1 = {
	Home = v14,
	a = v15,
	Bigfoot = v19,
	BigHand = v24,
	Reach = v27,
	b = v28,
	Catch = v30,
	Helpers = v31,
	Reacts = v33,
	Misc = v35,
	c = v36,
	Troll = v39,
	Skyes = v10:Tab({
		Title = "Skyes",
		Icon = v8:GetIcon("cloud", "Lucide")
	})
}

v10:SelectTab(1)
t1.Home:Paragraph({
	Title = "Welcome to the Atlas",
	Desc = "Most functions: Luxy\nSource & Bypass dev: Skinny"
})
t1.Home:Button({
	Title = "Copy discord server link",
	Callback = function()
		setclipboard("")
	end
})
local u41 = false
local vector3 = Vector3.new(2, 2, 2)
local n1 = 0
local u44 = false
local u45 = false
local vector3_2 = Vector3.new(2, 2, 2)
local n2 = 0
local u48 = false
local n3 = 5
local n4 = 1
local n5 = 5
local n6 = 1
local t2 = {}
local t3 = {
	"ValueAngleBarMPS2",
	"ValueVolleyMPS3",
	"ValueLongMPS",
	"ValueDrivenShotMPS",
	"ValueVolleyMPS"
}
t1.Bigfoot:Section({
	Title = "Bigfoot"
})
t1.Bigfoot:Paragraph({
	Title = "Customize bigfoot size",
	Desc = "Change the size of your leg, which gives you more hitbox/reach."
})
t1.Bigfoot:Toggle({
	Title = "Enable Bigfoot",
	Value = false,
	Icon = "check",
	Callback = function(p1)
		u41 = p1
		v6.ToggleBigfoot(u41, v3, vector3)
	end
})
t1.Bigfoot:Input({
	Title = "Input Bigfoot Size",
	InputIcon = "pencil",
	Placeholder = "Enter Size",
	Callback = function(p2)
		local num = tonumber(p2)

		if num then
			vector3 = Vector3.new(num, 2, num)

			if u41 then
				v6.ToggleBigfoot(true, v3, vector3)
			end
		end
	end
})
t1.Bigfoot:Section({
	Title = "Bigfoot transparency"
})
t1.Bigfoot:Toggle({
	Title = "Bigfoot Transparency",
	Value = false,
	Icon = "check",
	Callback = function(p3)
		u44 = p3
		v6.SetFootTransparency(u44, v3, n1)
	end
})
t1.Bigfoot:Input({
	Title = "Set Foot Transparency (0 to 1)",
	InputIcon = "pencil",
	Placeholder = "use 0.1-1",
	Callback = function(p4)
		local num = tonumber(p4)

		if num then
			n1 = num

			if u44 then
				v6.SetFootTransparency(true, v3, n1)
			end
		end
	end
})
t1.BigHand:Section({
	Title = "Bighand"
})
t1.BigHand:Toggle({
	Title = "Enable Big Hand",
	Value = false,
	Icon = "check",
	Callback = function(p5)
		u45 = p5
		v6.ToggleBigHand(u45, v3, vector3_2)
	end
})
t1.BigHand:Input({
	Title = "Input Big Hand Size",
	InputIcon = "pencil",
	Placeholder = "Enter Size",
	Callback = function(p6)
		local num = tonumber(p6)

		if num then
			vector3_2 = Vector3.new(num, num, num)

			if u45 then
				v6.ToggleBigHand(true, v3, vector3_2)
			end
		end
	end
})
t1.BigHand:Section({
	Title = "Bighand transparency"
})
t1.BigHand:Toggle({
	Title = "BigHand Transparency",
	Value = false,
	Icon = "check",
	Callback = function(p7)
		u48 = p7
		v6.SetHandTransparency(u48, v3, n2)
	end
})
t1.BigHand:Input({
	Title = "Set Hand Transparency (0 to 1)",
	InputIcon = "pencil",
	Placeholder = "use 0.1-1",
	Callback = function(p8)
		local num = tonumber(p8)

		if num then
			n2 = num

			if u48 then
				v6.SetHandTransparency(true, v3, n2)
			end
		end
	end
})
local function v55()
	for _, descendant in ipairs(workspace:GetDescendants()) do
		local v73 = descendant:IsA("BasePart")

		if v73 then
			v73 = descendant.Name == "TPS"

			if not v73 then
				v73 = descendant.Name == "ESA"

				if not v73 then
					v73 = descendant.Name == "MRS"

					if not v73 then
						v73 = descendant.Name == "PRS" or descendant.Name == "MPS"
					end
				end
			end
		end

		if v73 and not CollectionService:HasTag(descendant, "Ball") then
			CollectionService:AddTag(descendant, "Ball")
		end
	end
end
local function v56()
	t2 = CollectionService:GetTagged("Ball")
end
local function v57()
	local WorkspaceCharacters = workspace:FindFirstChild("WorkspaceCharacters")

	if not WorkspaceCharacters then
		return false
	end

	local LocalPlayer2Name = WorkspaceCharacters:FindFirstChild(LocalPlayer2.Name)

	if not LocalPlayer2Name then
		return false
	end

	for _, v in ipairs(t3) do
		if LocalPlayer2Name:FindFirstChild(v) then
			return true
		end
	end

	return false
end
local function u58(p9, p10)
	local Character = LocalPlayer2.Character

	if not Character then
		return
	end

	local p9_2 = Character:FindFirstChild(p9)

	if not p9_2 then
		p9_2 = Character:FindFirstChild(p9 .. "Upper")

		if not p9_2 then
			p9_2 = Character:FindFirstChild(p9 .. "Lower")
		end
	end

	if p9_2 then
		for _, v in ipairs(t2) do
			if p10 > (v.Position - p9_2.Position).Magnitude then
				firetouchinterest(v, p9_2, 0)
				firetouchinterest(v, p9_2, 1)

				return
			end
		end
	end
end
RunService.RenderStepped:Connect(function()
	v56()

	if not v57() then
		u58("Torso", n5)
		u58("Head", n4)
		u58("Right Arm", n6)
		u58("Left Arm", n6)
		u58("Right Leg", n3)
		u58("Left Leg", n3)
	end
end)
task.spawn(function()
	while task.wait(0.5) do
		v55()
	end
end)
t1.Reach:Paragraph({
	Title = "About Reach Method 2",
	Desc = "This method uses firetouchinterest, unlike bigfoot it is stable, undetectable and perfect for use"
})
t1.Reach:Slider({
	Title = "Leg Reach Studs",
	Step = 1,
	Value = {
		Min = 1,
		Max = 30,
		Default = n3
	},
	Callback = function(p11)
		n3 = p11
	end
})
t1.Reach:Slider({
	Title = "Head Reach Studs",
	Step = 1,
	Value = {
		Min = 1,
		Max = 30,
		Default = n4
	},
	Callback = function(p12)
		n4 = p12
	end
})
t1.Reach:Slider({
	Title = "Torso Reach Studs",
	Step = 1,
	Value = {
		Min = 1,
		Max = 30,
		Default = n5
	},
	Callback = function(p13)
		n5 = p13
	end
})
t1.Reach:Slider({
	Title = "Arm Reach Studs",
	Step = 1,
	Value = {
		Min = 1,
		Max = 30,
		Default = n6
	},
	Callback = function(p14)
		n6 = p14
	end
})
