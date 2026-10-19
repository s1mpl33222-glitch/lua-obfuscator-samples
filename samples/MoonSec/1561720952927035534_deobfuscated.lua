local next_ = next
local t1 = {
	game.ReplicatedStorage.Util,
	game.ReplicatedStorage.Common,
	game.ReplicatedStorage.Remotes,
	game.ReplicatedStorage.Assets,
	game.ReplicatedStorage.FX
}
local key = nil
local u4 = nil
local attribute = nil

while true do
	local v6

	key, v6 = next_(t1, key)

	if key == nil then
		break
	end

	local next_2 = next
	local children, key2 = v6:GetChildren()

	while true do
		local v10

		key2, v10 = next_2(children, key2)

		if key2 == nil then
			break
		end

		if v10:IsA("RemoteEvent") and v10:GetAttribute("Id") then
			attribute = v10:GetAttribute("Id")
			u4 = v10
		end
	end

	v6.ChildAdded:Connect(function(child)
		if not (child:IsA("RemoteEvent") and child:GetAttribute("Id")) then
			return
		end

		attribute = child:GetAttribute("Id")
		u4 = child
	end)
end

task.spawn(function()
	while task.wait(0.0001) do
		local Character = game.Players.LocalPlayer.Character
		local HumanoidRootPart

		if Character then
			HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
		else
			HumanoidRootPart = Character
		end

		local v13, v14, v15 = ipairs({ workspace.Enemies, workspace.Characters })
		local t2 = {}

		while true do
			local v17

			v15, v17 = v13(v14, v15)

			if v15 == nil then
				break
			end

			local v18, v19

			v17, v18, v19 = ipairs(v17 and v17:GetChildren() or {})

			while true do
				local v20

				v19, v20 = v17(v18, v19)

				if v19 == nil then
					break
				end

				local HumanoidRootPart2 = v20:FindFirstChild("HumanoidRootPart")
				local Humanoid = v20:FindFirstChild("Humanoid")

				if v20 ~= Character and (HumanoidRootPart2 and (Humanoid and (Humanoid.Health > 0 and (HumanoidRootPart2.Position - HumanoidRootPart.Position).Magnitude <= 60))) then
					local v23, v24

					Humanoid, v23, v24 = ipairs(v20:GetChildren())

					while true do
						local v25

						v24, v25 = Humanoid(v23, v24)

						if v24 == nil then
							break
						end

						if v25:IsA("BasePart") and (HumanoidRootPart2.Position - HumanoidRootPart.Position).Magnitude <= 60 then
							t2[#t2 + 1] = { v20, v25 }
						end
					end
				end
			end
		end

		Character = Character:FindFirstChildOfClass("Tool")

		if #t2 > 0 and (Character and (Character:GetAttribute("WeaponType") == "Melee" or Character:GetAttribute("WeaponType") == "Sword")) then
			pcall(function()
				require(game.ReplicatedStorage.Modules.Net):RemoteEvent("RegisterHit", true)
				game.ReplicatedStorage.Modules.Net["RE/RegisterAttack"]:FireServer()

				local Head = t2[1][1]:FindFirstChild("Head")

				if not Head then
					return
				end
			end)
		end
	end
end)
