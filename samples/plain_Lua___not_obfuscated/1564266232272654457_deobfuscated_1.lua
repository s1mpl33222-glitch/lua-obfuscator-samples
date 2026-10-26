-- This file was generated at discord.gg/syncrypt

local data = game:GetService("HttpService"):JSONDecode("{\"schemaVersion\":1,\"projectId\":\"mm2-main\",\"runtimeVersion\":\"1.1.0\",\"uiLibraryId\":\"fluent-modded\",\"appearance\":{\"themeId\":\"Deep Violet\",\"density\":\"normal\",\"playstyle\":\"custom\",\"windowTitle\":\"Malaphas \",\"usageNotify\":true,\"usageNotifyText\":\"Version loaded. Toggle UI: RightControl.\",\"libraryOptions\":{\"acrylic\":true,\"transparency\":true,\"animated\":true,\"background\":true,\"search\":true,\"userInfo\":true}},\"layout\":[{\"id\":\"gameplay\",\"enabled\":true,\"sections\":[{\"id\":\"tools\",\"enabled\":true,\"controls\":[{\"id\":\"pick-up-gun\",\"enabled\":true},{\"id\":\"auto-pick-up-gun\",\"enabled\":true}]},{\"id\":\"basic-stuff\",\"enabled\":true,\"controls\":[{\"id\":\"noclip\",\"enabled\":true},{\"id\":\"fly-gui\",\"enabled\":true}]},{\"id\":\"more-tools\",\"enabled\":true,\"controls\":[{\"id\":\"kill-everyone\",\"enabled\":true},{\"id\":\"bring-all-players\",\"enabled\":true},{\"id\":\"auto-shoot-murderer\",\"enabled\":true},{\"id\":\"shoot-murderer\",\"enabled\":true}]},{\"id\":\"annoying-stuff\",\"enabled\":true,\"controls\":[{\"id\":\"pick-player\",\"enabled\":true},{\"id\":\"fling-chosen-player\",\"enabled\":true},{\"id\":\"fling-murderer\",\"enabled\":true},{\"id\":\"fling-sheriff\",\"enabled\":true},{\"id\":\"fling-all\",\"enabled\":true},{\"id\":\"fling-random\",\"enabled\":true},{\"id\":\"loop-fling-all\",\"enabled\":true}]},{\"id\":\"other-tools\",\"enabled\":true,\"controls\":[{\"id\":\"teleport-map\",\"enabled\":true},{\"id\":\"teleport-lobby\",\"enabled\":true},{\"id\":\"notify-murderer\",\"enabled\":true},{\"id\":\"notify-sheriff\",\"enabled\":true},{\"id\":\"reveal-roles\",\"enabled\":true},{\"id\":\"auto-reveal-roles\",\"enabled\":true}]},{\"id\":\"movement\",\"enabled\":true,\"controls\":[{\"id\":\"walk-speed\",\"enabled\":true},{\"id\":\"jump-power\",\"enabled\":true}]}]},{\"id\":\"esp\",\"enabled\":true,\"sections\":[{\"id\":\"esp-settings\",\"enabled\":true,\"controls\":[{\"id\":\"players-esp\",\"enabled\":true},{\"id\":\"dropped-gun-esp\",\"enabled\":true},{\"id\":\"trap-esp\",\"enabled\":true}]}]},{\"id\":\"auto-farm\",\"enabled\":true,\"sections\":[{\"id\":\"autofarm-features\",\"enabled\":true,\"controls\":[{\"id\":\"auto-teleport-spawn\",\"enabled\":true},{\"id\":\"auto-kill-all\",\"enabled\":true},{\"id\":\"auto-prestige\",\"enabled\":true}]},{\"id\":\"autofarm-more\",\"enabled\":true,\"controls\":[{\"id\":\"auto-fling-murderer\",\"enabled\":true},{\"id\":\"auto-fling-sheriff\",\"enabled\":true},{\"id\":\"empty-server-hop\",\"enabled\":true},{\"id\":\"server-hop-threshold\",\"enabled\":true}]}]},{\"id\":\"coin-farm\",\"enabled\":true,\"sections\":[{\"id\":\"coin-farm-one\",\"enabled\":true,\"controls\":[{\"id\":\"coin-farm-one-enable\",\"enabled\":true},{\"id\":\"coin-farm-one-speed\",\"enabled\":true}]},{\"id\":\"coin-farm-two\",\"enabled\":true,\"controls\":[{\"id\":\"coin-farm-two-enable\",\"enabled\":true}]},{\"id\":\"coin-settings\",\"enabled\":true,\"controls\":[{\"id\":\"destroy-player-models\",\"enabled\":true},{\"id\":\"destroy-map\",\"enabled\":true},{\"id\":\"die-full-bag\",\"enabled\":true},{\"id\":\"under-map-full-bag\",\"enabled\":true},{\"id\":\"fling-murderer-full-bag\",\"enabled\":true},{\"id\":\"disable-rendering\",\"enabled\":true},{\"id\":\"stats-overlay\",\"enabled\":true}]},{\"id\":\"auto-crates\",\"enabled\":true,\"controls\":[{\"id\":\"auto-open-crates\",\"enabled\":true},{\"id\":\"choose-box\",\"enabled\":true}]}]},{\"id\":\"summer-farm\",\"enabled\":true,\"sections\":[{\"id\":\"summer-statistics\",\"enabled\":true,\"controls\":[{\"id\":\"summer-active-event\",\"enabled\":true},{\"id\":\"summer-progress\",\"enabled\":true}]},{\"id\":\"summer-farming\",\"enabled\":true,\"controls\":[{\"id\":\"summer-farm-enable\",\"enabled\":true}]},{\"id\":\"summer-settings\",\"enabled\":true,\"controls\":[{\"id\":\"summer-coin-types\",\"enabled\":true},{\"id\":\"summer-teleport-mode\",\"enabled\":true},{\"id\":\"summer-farm-speed\",\"enabled\":true}]},{\"id\":\"summer-full-bag\",\"enabled\":true,\"controls\":[{\"id\":\"summer-kill-all\",\"enabled\":true},{\"id\":\"summer-reset\",\"enabled\":true},{\"id\":\"summer-fling-murderer\",\"enabled\":true}]},{\"id\":\"summer-utilities\",\"enabled\":true,\"controls\":[{\"id\":\"summer-anti-fling\",\"enabled\":true},{\"id\":\"summer-disable-rendering\",\"enabled\":true}]}]},{\"id\":\"trade-helper\",\"enabled\":true,\"sections\":[{\"id\":\"trade-info\",\"enabled\":true,\"controls\":[{\"id\":\"trade-helper-info\",\"enabled\":true},{\"id\":\"item-price-display\",\"enabled\":true},{\"id\":\"show-trade-values\",\"enabled\":true}]},{\"id\":\"auto-trade\",\"enabled\":true,\"controls\":[{\"id\":\"auto-trade-warning\",\"enabled\":true},{\"id\":\"auto-generate-offers\",\"enabled\":true},{\"id\":\"generate-offer\",\"enabled\":true},{\"id\":\"refresh-offer\",\"enabled\":true},{\"id\":\"minimum-profit\",\"enabled\":true}]}]},{\"id\":\"inventory\",\"enabled\":true,\"sections\":[{\"id\":\"inventory-analyzer\",\"enabled\":true,\"controls\":[{\"id\":\"inventory-about\",\"enabled\":true},{\"id\":\"inventory-result\",\"enabled\":true},{\"id\":\"inventory-analyze\",\"enabled\":true},{\"id\":\"inventory-copy\",\"enabled\":true}]},{\"id\":\"other-inventories\",\"enabled\":true,\"controls\":[{\"id\":\"other-inventory-about\",\"enabled\":true},{\"id\":\"other-inventory-results\",\"enabled\":true},{\"id\":\"other-inventory-auto-scan\",\"enabled\":true},{\"id\":\"other-inventory-scan\",\"enabled\":true}]}]},{\"id\":\"spawner\",\"enabled\":true,\"sections\":[{\"id\":\"spawner-catalog\",\"enabled\":true,\"controls\":[{\"id\":\"spawner-search\",\"enabled\":true},{\"id\":\"spawner-select-items\",\"enabled\":true},{\"id\":\"spawner-select-all\",\"enabled\":true},{\"id\":\"spawner-clear\",\"enabled\":true},{\"id\":\"spawner-amount\",\"enabled\":true},{\"id\":\"spawner-spawn-selected\",\"enabled\":true},{\"id\":\"spawner-selection\",\"enabled\":true}]}]},{\"id\":\"crates\",\"enabled\":true,\"sections\":[{\"id\":\"crate-catalog\",\"enabled\":true,\"controls\":[{\"id\":\"crate-search\",\"enabled\":true},{\"id\":\"crate-select-items\",\"enabled\":true},{\"id\":\"crate-select-all\",\"enabled\":true},{\"id\":\"crate-clear\",\"enabled\":true},{\"id\":\"crate-open-selected\",\"enabled\":true},{\"id\":\"crate-selection\",\"enabled\":true}]}]},{\"id\":\"misc\",\"enabled\":true,\"sections\":[{\"id\":\"server-crasher\",\"enabled\":true,\"controls\":[{\"id\":\"server-crash-warning\",\"enabled\":true},{\"id\":\"crash-server\",\"enabled\":true}]},{\"id\":\"unlock-emotes\",\"enabled\":true,\"controls\":[{\"id\":\"unlock-all-emotes\",\"enabled\":true}]},{\"id\":\"server-stuff\",\"enabled\":true,\"controls\":[{\"id\":\"rejoin-server\",\"enabled\":true},{\"id\":\"server-hop\",\"enabled\":true}]},{\"id\":\"random-emotes\",\"enabled\":true,\"controls\":[{\"id\":\"random-emotes-enable\",\"enabled\":true},{\"id\":\"random-emotes-speed\",\"enabled\":true}]},{\"id\":\"selected-emote\",\"enabled\":true,\"controls\":[{\"id\":\"selected-emote-enable\",\"enabled\":true},{\"id\":\"selected-emote-picker\",\"enabled\":true}]},{\"id\":\"skin-swapper\",\"enabled\":true,\"controls\":[{\"id\":\"shuffle-weapons\",\"enabled\":true}]}]},{\"id\":\"settings\",\"enabled\":true,\"sections\":[{\"id\":\"theme\",\"enabled\":true,\"controls\":[{\"id\":\"theme-preset\",\"enabled\":true},{\"id\":\"theme-accent\",\"enabled\":true}]},{\"id\":\"about\",\"enabled\":true,\"controls\":[{\"id\":\"about-project\",\"enabled\":true},{\"id\":\"about-credits\",\"enabled\":true},{\"id\":\"about-game-guard\",\"enabled\":true}]}]}]}")
local v2 = (function()
	local result = nil

	for i = 1, 3 do
		local ok

		ok, result = pcall(function()
			return game:HttpGet("https://cdn.project-reverse.org/builder/mm2/v1/main.luau", true)
		end)

		if ok then
			if type(result) == "string" then
				ok = #result > 0
			else
				ok = false
			end
		end

		if ok then
			return result
		end

		if i < 3 then
			task.wait(0.35 * i)
		end
	end

	error("MM2 runtime download failed: " .. tostring(result))
end)()
local chunk, v7 = loadstring(v2)
local v8 = "MM2 runtime compile failed: " .. tostring(v7)

assert(chunk, v8)

local v9 = chunk()
local v10 = type(v9) == "function"

assert(v10, "MM2 runtime entrypoint is invalid")

local getgenv_ = getgenv
local genv

if typeof(getgenv_) == "function" then
	genv = getgenv()
else
	genv = false
end

local _G_ = genv or _G
local ProjectReverseHub = _G_.ProjectReverseHub
local v15 = type(ProjectReverseHub) == "table"

if v15 then
	local destroy = _G_.ProjectReverseHub.destroy

	v15 = type(destroy) == "function"
end

if v15 then
	pcall(function()
		_G_.ProjectReverseHub.destroy()
	end)
end

local v17 = v9(data)
local assert_ = assert
local v19 = type(v17) == "table"

if not v19 then
	assert_(v19, "MM2 runtime did not start; inspect the executor console")
	_G_.ProjectReverseHub = v17

	return v17
end

local destroy = v17.destroy

v19 = type(destroy) == "function"
assert_(v19, "MM2 runtime did not start; inspect the executor console")
_G_.ProjectReverseHub = v17

return v17
