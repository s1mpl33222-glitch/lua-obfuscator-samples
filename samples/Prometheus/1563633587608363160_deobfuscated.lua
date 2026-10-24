-- This file was generated at discord.gg/syncrypt

local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)

local function reportVisibility(_, _, _) end

task.spawn(function()
	while true do
		local ok, result = pcall(function()
			return Knit.GetController("WatcherController")
		end)

		if ok then
			if result then
				ok = result.ReportVisibility
			else
				ok = result
			end
		end

		if ok and result.ReportVisibility ~= reportVisibility then
			local ReportVisibility = result.ReportVisibility

			reportVisibility = function(p1, p2, _)
				return ReportVisibility(p1, p2, true)
			end
			result.ReportVisibility = reportVisibility

			if result.TrackedWatchers then
				for _, trackedWatcher in pairs(result.TrackedWatchers) do
					if trackedWatcher.RuntimeId then
						trackedWatcher.Visible = true
						pcall(function()
							result:ReportVisibility(trackedWatcher.RuntimeId, true)
						end)
					end
				end
			end

			print("[Exploit] WatcherController interceptado y protegido en bucle.")
		end

		task.wait(0.2)
	end
end)
