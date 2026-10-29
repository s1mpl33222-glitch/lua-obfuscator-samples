-- This file was generated at discord.gg/syncrypt

loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/Utilities/main/Functions.lua"))()

local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/Utilities/main/Doors/Custom%20Shop%20Items/Source.lua"))()
local UserInputService = game:GetService("UserInputService")
local v3 = LoadCustomInstance("rbxassetid://12848567274")

if game:GetService("Players").LocalPlayer.PlayerGui.MainUI.ItemShop.Visible == true then
	lib.CreateItem(v3, {
		Title = "Harry Potter Wand",
		Desc = "Works on entities",
		Image = "https://cdn.discordapp.com/attachments/1049016956231102465/1078727375631679688/image_2023-02-24_121721211-removebg-preview.png",
		Price = "gun",
		Stack = 1
	})
else
	v3.Parent = game.Players.LocalPlayer.Backpack
end

local function v4()
	local v5 = game:GetObjects("rbxassetid://12848374097")[1]

	task.wait()
	v5.Anchored = false
	v5.Massless = false

	local Sound = Instance.new("Sound", game.StarterPlayer)

	Sound.Volume = 3.5
	Sound.SoundId = "rbxassetid://5238024665"
	Sound.PlayOnRemove = true
	Sound:Destroy()
	HRP = v3.BulletPart.CFrame * CFrame.Angles(0, -1.5707963267948966, 0)

	local Attachment = Instance.new("Attachment", v5)
	local LinearVelocity = Instance.new("LinearVelocity", Attachment)

	LinearVelocity.MaxForce = math.huge
	LinearVelocity.VectorVelocity = (game:GetService("Players").LocalPlayer:GetMouse().Hit.Position - v3.BulletPart.Position).Unit * 100
	LinearVelocity.Attachment0 = Attachment
	v5.Parent = game.Workspace
	v5.CFrame = v3.BulletPart.CFrame * CFrame.Angles(0, 1.5707963267948966, 1.5707963267948966)
	v5.Touched:Connect(function(part)
		local Model = part:FindFirstAncestorWhichIsA("Model")
		local v10 = Model ~= nil

		if v10 then
			v10 = Model:GetAttribute("IsCustomEntity") == true
		end

		if not v10 then
			return
		end

		Model:Destroy()
	end)
	task.wait(0.3)
	v5:Destroy()
end

UserInputService.InputBegan:Connect(function(input)
	if not (v3.Parent == game.Players.LocalPlayer.Character and input.UserInputType == Enum.UserInputType.MouseButton1) then
		return
	end

	getgenv().BulletType = "12848374097"
	v4()
end)
