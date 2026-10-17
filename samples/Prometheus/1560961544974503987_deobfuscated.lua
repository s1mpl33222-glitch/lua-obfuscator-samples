-- This file was generated at discord.gg/syncrypt

game:GetService("RunService").RenderStepped:Connect(function()
	game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0, 100000, 0)
	game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero

	local _SelectedPart2 = SelectedPart2

	if _SelectedPart2 then
		_SelectedPart2 = true

		if _SelectedPart2 then
			_SelectedPart2 = (game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position - SelectedPart2.Position).Magnitude <= 15
		end
	end

	if _SelectedPart2 then
		MenHub:Set("RageBotOrbit", false, true)
	end
end)

return {
	load = function()
	end,
	unload = function()
	end
}
