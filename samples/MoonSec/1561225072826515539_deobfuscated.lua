script_author("HG")
script_name("Correr Autom\195\161tico / Auto Run")
require("widgets")
require("samp.events")

local module = require("SAMemory")

module.require("CPlayerData")

local u2 = false

function CORRE()
	while u2 do
		wait(0)
		setGameKeyState(1, -255)
	end
end
function main()
	while not isSampAvailable() do
		wait(0)
	end

	lua_thread.create(function()
		while true do
			repeat
				wait(0)
				u2 = isWidgetSwipedRight(WIDGET_BUTTON_SPRINT) and not u2
			until u2

			lua_thread.create(CORRE)
		end
	end)
end

lua_thread.create(function()
	while true do
		local pPlayerData = module.player_ped[0]

		if pPlayerData ~= module.nullptr then
			pPlayerData = pPlayerData.pPlayerData

			if pPlayerData ~= module.nullptr then
				pPlayerData.fSprintEnergy = 0.4
			end
		end

		wait(0)
	end
end)
