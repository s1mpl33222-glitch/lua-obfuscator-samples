-- This file was generated at discord.gg/syncrypt

local lib = loadstring(game:HttpGet("https://gist.githubusercontent.com/wateringcancan-eng/9bdf2e8c05744b0f39655fda2c40e140/raw/45662c5a971096072ef754a53ca96a54cae7063d/CoolUI.lua"))()
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local HttpService = game:GetService("HttpService")
local Name = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
local data = HttpService:JSONDecode(request({
	Url = "https://scriptblox.com/api/script/search?q=" .. HttpService:UrlEncode(Name),
	Method = "GET"
}).Body)

if data.result.scripts[1] then
	local slug = data.result.scripts[1].slug
	local v10 = request({
		Url = "https://scriptblox.com/api/script/raw/" .. slug,
		Method = "GET"
	})
	local BindableFunction = Instance.new("BindableFunction")

	function BindableFunction.OnInvoke(p1)
		if p1 ~= "Yes" then
			return
		end

		loadstring(v10.Body)()
	end

	StarterGui:SetCore("SendNotification", {
		Title = "Suggestion",
		Text = "We noticed you\'re currently playing " .. Name .. ". Do you want to execute a script for that game?",
		Duration = 6,
		Button1 = "Yes",
		Button2 = "No",
		Callback = BindableFunction
	})
end

local u12 = false
local u13 = false
local u14 = false
local u15 = false
local looped = false
local u17 = false
local u18 = false
local n1 = 0.05
local n2 = 0.5
local n3 = 5
local connection = nil
local connection2 = nil
local Part = nil
local connection3 = nil
local connection4 = nil
local v27 = lib:CreateWindow("C00lkidd Cl4n v2.0")
local Credits = v27:AddTab("Credits")

Credits:AddText("C00lkidd cl4n v2.0 development-team: C00lkiddk1ng - YouTube, vex0rrs - Discord, wateringcan0559 - Discord, and United.", 0.2)
Credits:AddButton("Copy Team c00lkidd Discord server link.", function()
	setclipboard("https://discord.gg/c00l")
end)
Credits:AddButton("Copy C00lkiddk1ng YouTube channel link.", function()
	setclipboard("https://www.youtube.com/@c00lkiddk1ng?sub_confirmation=1")
end)

local Player = v27:AddTab("Player")

Player:AddSlider("Walk speed", 16, 175, 25, function(p2)
	game.Players.LocalPlayer.Character:WaitForChild("Humanoid").WalkSpeed = p2
end)
Player:AddSlider("Jump power", 50, 175, 65, function(p3)
	game.Players.LocalPlayer.Character:WaitForChild("Humanoid").JumpPower = p3
end)
Player:AddToggle("No-clip", function(p4)
	u12 = p4
end)
task.spawn(function()
	while task.wait() do
		if u12 then
			local pairs_ = pairs
			local Character = game.Players.LocalPlayer.Character

			for _, descendant in pairs_(Character.GetDescendants(Character)) do
				if descendant:IsA("BasePart") then
					descendant.CanCollide = false
				end
			end
		else
			for _, descendant in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
				if descendant:IsA("BasePart") then
					descendant.CanCollide = true
				end
			end
		end
	end
end)
Player:AddToggle("Infinite jump", function(p5)
	if not p5 then
		connection:Disconnect()

		return
	end

	connection = UserInputService.JumpRequest:Connect(function()
		game.Players.LocalPlayer.Character:WaitForChild("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
	end)
end)
Player:AddToggle("Slow falling", function(p6)
	u13 = p6
end)
task.spawn(function()
	while task.wait() do
		if u13 then
			local HumanoidRootPart = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")

			if HumanoidRootPart.AssemblyLinearVelocity.Y < -20 then
				HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(HumanoidRootPart.AssemblyLinearVelocity.X, -20, HumanoidRootPart.AssemblyLinearVelocity.Z)
			end
		end
	end
end)
Player:AddToggle("Climb walls", function(p7)
	u14 = p7
end)
task.spawn(function()
	while task.wait() do
		local HumanoidRootPart = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
		local raycastParams = RaycastParams.new()

		raycastParams.FilterDescendantsInstances = { HumanoidRootPart }
		raycastParams.FilterType = Enum.RaycastFilterType.Exclude

		if u14 and workspace:Raycast(HumanoidRootPart.Position, HumanoidRootPart.CFrame.LookVector * 3, raycastParams) then
			HumanoidRootPart.Velocity = Vector3.new(0, 50, 0)
		end
	end
end)
Player:AddToggle("Click teleport", function(p8)
	if not p8 then
		connection2:Disconnect()

		return
	end

	local mouse = game.Players.LocalPlayer:GetMouse()

	connection2 = mouse.Button1Down:Connect(function()
		game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = mouse.Hit
	end)
end)
Player:AddToggle("Anchor your character", function(p9)
	if p9 then
		local pairs_ = pairs
		local Character = game.Players.LocalPlayer.Character

		for _, descendant in pairs_(Character.GetDescendants(Character)) do
			if descendant:IsA("BasePart") then
				descendant.Anchored = true
			end
		end
	else
		for _, descendant in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
			if descendant:IsA("BasePart") then
				descendant.Anchored = false
			end
		end
	end
end)
Player:AddButton("Reset your character", function(_)
	game.Players.LocalPlayer.Character:WaitForChild("Humanoid").Health = 0
end)
Player:AddButton("Fly GUI V3", function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt"))()
end)
Player:AddButton("Touch fling", function()
	loadstring(game:HttpGet("https://pastebin.com/raw/LgZwZ7ZB", true))()
end)

local Visuals = v27:AddTab("Visuals")

Visuals:AddSlider("Field Of View", 70, 180, 75, function(p10)
	workspace.Camera.FieldOfView = p10
end)
Visuals:AddToggle("Infinite zoom", function(p11)
	if p11 then
		game.Players.LocalPlayer.CameraMaxZoomDistance = math.huge
	else
		game.Players.LocalPlayer.CameraMaxZoomDistance = 256
	end
end)

local t1 = {}

Visuals:AddToggle("Highlight players", function(p12)
	if p12 then
		local pairs_ = pairs
		local Players = game.Players

		for _, player in pairs_(Players.GetPlayers(Players)) do
			if player ~= game.Players.LocalPlayer then
				local Highlight = Instance.new("Highlight")

				Highlight.FillColor = Color3.fromRGB(0, 0, 255)
				Highlight.OutlineColor = Color3.fromRGB(237, 237, 237)
				Highlight.Parent = player.Character

				local v53 = t1

				table.insert(v53, Highlight)
			end
		end
	else
		for _, v in pairs(t1) do
			v:Destroy()
		end
	end
end)
Visuals:AddToggle("Camera lock", function(p13)
	if p13 then
		local HumanoidRootPart = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
		local Camera = workspace.Camera

		Part = Instance.new("Part")
		Part.CanCollide = false
		Part.Anchored = true
		Part.CFrame = HumanoidRootPart.CFrame
		Part.Transparency = 1
		Part.Parent = workspace
		Camera.CameraSubject = Part
	else
		local Camera = workspace.Camera
		local HumanoidRootPart = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")

		Part:Destroy()
		Camera.CameraSubject = HumanoidRootPart
	end
end)
Visuals:AddToggle("Fullbright", function(p14)
	if p14 then
		local Lighting = game.Lighting

		Lighting.Brightness = 10
		Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
	else
		local Lighting = game.Lighting

		Lighting.Brightness = 5
		Lighting.OutdoorAmbient = Color3.fromRGB(123, 123, 123)
	end
end)
Visuals:AddButton("John Doe Fling", function()
	loadstring(game:HttpGet("https://pastebin.com/raw/RqbZqrVQ"))()
end)
Visuals:AddButton("First person view unlock", function()
	local LocalPlayer = game.Players.LocalPlayer

	LocalPlayer.CameraMaxZoomDistance = 256
	LocalPlayer.CameraMode = Enum.CameraMode.Classic
end)

local World = v27:AddTab("World")

World:AddButton("Low gravity", function()
	workspace.Gravity = 5
end)
World:AddButton("High gravity", function()
	workspace.Gravity = 1000
end)
World:AddButton("Regular gravity", function()
	workspace.Gravity = 192.6
end)
World:AddText("", 0.01)
World:AddToggle("Click a part to orbit it", function(p15)
	if not p15 then
		connection3:Disconnect()

		return
	end

	local mouse = game.Players.LocalPlayer:GetMouse()

	u15 = true
	connection3 = mouse.Button1Down:Connect(function()
		local Target = mouse.Target
		local HumanoidRootPart = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")

		if Target:IsGrounded() then
			return
		end

		Target.CanCollide = false
		Target.CanTouch = false
		Target.CanQuery = false
		Target.Massless = true

		local n4 = 0

		task.spawn(function()
			while u15 do
				n4 = n4 + n1

				local v68 = n4
				local v69 = n4
				local vector3 = Vector3.new(math.cos(v68) * n3, n2, math.sin(v69) * n3)

				Target.CFrame = CFrame.new(HumanoidRootPart.Position + vector3, HumanoidRootPart.Position)
				task.wait()
			end
		end)
	end)
end)
World:AddSlider("Orbit radius", 5, 20, 6, function(p16)
	n3 = p16
end)
World:AddSlider("Orbit height", 0.5, 10, 0.6, function(p17)
	n2 = p17
end)
World:AddSlider("Orbit speed", 0.05, 1, 0.06, function(p18)
	n1 = p18
end)
World:AddText("", 0.01)
World:AddToggle("Click a part to fling it", function(p19)
	if not p19 then
		connection4:Disconnect()

		return
	end

	local mouse = game.Players.LocalPlayer:GetMouse()

	connection4 = mouse.Button1Down:Connect(function()
		local Target = mouse.Target

		if Target:IsGrounded() then
			return
		end

		Target.Velocity = Vector3.new(300, 300, 300)
	end)
end)
World:AddButton("Super ring parts", function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/chesslovers69/Super-ring-parts-v6/refs/heads/main/Bylukaslol"))()
end)

local Animations = v27:AddTab("Animations")
local t2 = {
	"rbxassetid://125176243437210",
	"rbxassetid://133747057485171",
	"rbxassetid://77855691082488",
	"rbxassetid://79757971761739",
	"rbxassetid://10714360343",
	"rbxassetid://10714016223",
	"rbxassetid://10713954623"
}

for k, v in pairs({
	"Obby Head",
	"Happy Dog",
	"Death Pose",
	"Shattered",
	"Sleep",
	"Celebrate",
	"Agree"
}) do
	Animations.AddButton(Animations, v, function()
		local Animator = game.Players.LocalPlayer.Character.Humanoid:WaitForChild("Animator")
		local Animation = Instance.new("Animation")

		Animation.AnimationId = t2[k]

		local v79 = Animator:LoadAnimation(Animation)

		v79.Looped = looped
		v79:Play()
	end)
end

Animations:AddText("", 0.01)
Animations:AddTextBox("Emote ID", "Play", function(p20)
	local Animator = game.Players.LocalPlayer.Character.Humanoid:WaitForChild("Animator")
	local objects = game:GetObjects("rbxassetid://" .. p20)

	if not objects[1]:IsA("Animation") then
		return
	end

	local Animation = Instance.new("Animation")

	Animation.AnimationId = objects[1].AnimationId

	local v83 = Animator:LoadAnimation(Animation)

	v83.Looped = looped
	v83:Play()
end)
Animations:AddToggle("Loop animation", function(p21)
	looped = p21
end)
Animations:AddText("", 0.01)
Animations:AddButton("Drop kick", function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/wateringc4n/Miscellaneous_scripts/refs/heads/main/Drop_kick.lua"))()
end)
Animations:AddButton("Creepy Stalker", function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/wateringc4n/Miscellaneous_scripts/refs/heads/main/Creepy_stalker.lua"))()
end)
Animations:AddButton("R6 animations pack", function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/wateringc4n/Miscellaneous_scripts/refs/heads/main/R6_animations_pack.lua"))()
end)

local Utility = v27:AddTab("Utility")

Utility:AddButton("Rejoin", function()
	TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, game.Players.LocalPlayer)
end)
Utility:AddButton("Switch servers", function()
	TeleportService:Teleport(game.PlaceId, game.Players.LocalPlayer)
end)
Utility:AddToggle("Anti AFK kick", function(p22)
	u17 = p22
end)
task.spawn(function()
	while task.wait() do
		if u17 then
			local mouse = game.Players.LocalPlayer:GetMouse()

			task.wait(1)
			VirtualInputManager:SendMouseButtonEvent(mouse.X, mouse.Y, 0, true, game, 1)
			VirtualInputManager:SendMouseButtonEvent(mouse.X, mouse.Y, 0, false, game, 1)
			task.wait(300)
		end
	end
end)
Utility:AddToggle("Auto click", function(p23)
	task.wait(2)
	u18 = p23
end)
task.spawn(function()
	while task.wait() do
		if u18 then
			local mouse = game.Players.LocalPlayer:GetMouse()

			VirtualInputManager:SendMouseButtonEvent(mouse.X, mouse.Y, 0, true, game, 1)
			task.wait(0.3)
			VirtualInputManager:SendMouseButtonEvent(mouse.X, mouse.Y, 0, false, game, 1)
		end
	end
end)
Utility:AddButton("Infinite Yield", function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
end)
Utility:AddButton("DEX explorer", function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"))()
end)
