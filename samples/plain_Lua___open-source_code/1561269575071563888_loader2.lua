--[[
██╗   ██╗ ██████╗ ██╗██████╗ ██╗    ██╗ █████╗ ██████╗ ███████╗
██║   ██║██╔═══██╗██║██╔══██╗██║    ██║██╔══██╗██╔══██╗██╔════╝
██║   ██║██║   ██║██║██║  ██║██║ █╗ ██║███████║██████╔╝█████╗  
╚██╗ ██╔╝██║   ██║██║██║  ██║██║███╗██║██╔══██║██╔═══╝ ██╔══╝  
 ╚████╔╝ ╚██████╔╝██║██████╔╝╚███╔███╔╝██║  ██║██║     ███████╗
  ╚═══╝   ╚═════╝ ╚═╝╚═════╝  ╚══╝╚══╝ ╚═╝  ╚═╝╚═╝     ╚══════╝

                🚀 VOIDWARE — Loader 🚀
----------------------------------------------------------------------------
  IMPORTANT:
  You must copy and use the FULL script below. Do NOT press on the link.:

  loadstring(game:HttpGet("https://files.vapevoidware.xyz/VapeVoidware/VW-Add/main/loader.lua", true))()

----------------------------------------------------------------------------
  For support head over to discord.gg/voidware
----------------------------------------------------------------------------
]]

-- DEBUG MODE: Set to true to enable detailed debugging output
local DEBUG_MODE = shared.VoidwareLoadingDebug or false

-- Debug helper function
local function debugLog(...)
	if DEBUG_MODE then
		local args = { ... }
		local msg = table.concat(args, " ")
		warn("[DEBUG] " .. msg)
		-- Also save to file if possible
		pcall(function()
			if not isfolder("voidware_debug") then
				makefolder("voidware_debug")
			end
			local debugFile = "voidware_debug/debug_log.txt"
			local current = isfile(debugFile) and readfile(debugFile) or ""
			local timestamp = os.date("%Y-%m-%d %H:%M:%S")
			writefile(debugFile, current .. string.format("[%s] %s\n", timestamp, msg))
		end)
	end
end

repeat
	task.wait()
until game:IsLoaded()

debugLog("Script started. Game ID: " .. tostring(game.GameId))

local meta = {
	[0] = {
		title = "Universal",
		dev = "vwdev/vwrw.lua",
		script = "https://files.vapevoidware.xyz/VapeVoidware/VWRewrite/" .. (shared.CustomCommit and tostring(
			shared.CustomCommit
		) or "master") .. "/NewMainScript.lua",
	},
	[2619619496] = {
		title = "Bedwars",
		dev = "vwdev/vwrw.lua",
		script = "https://files.vapevoidware.xyz/VapeVoidware/VWRewrite/" .. (shared.CustomCommit and tostring(
			shared.CustomCommit
		) or "main") .. "/NewMainScript.lua",
	},
	[7008097940] = {
		no = true,
		title = "Ink Game",
		dev = "vwdev/inkgame.lua",
		script = "https://files.vapevoidware.xyz/VapeVoidware/VW-Add/" .. (shared.CustomCommit and tostring(
			shared.CustomCommit
		) or "main") .. "/inkgame.lua",
	},
	[6331902150] = {
		title = "Forsaken",
		dev = "vwdev/forsaken.lua",
		script = "https://files.vapevoidware.xyz/VapeVoidware/VW-Add/" .. (shared.CustomCommit and tostring(
			shared.CustomCommit
		) or "main") .. "/forsaken.lua",
	},
	[7326934954] = {
		title = "99 Nights In The Forest",
		dev = "vwdev/nightsintheforest.lua",
		script = "https://files.vapevoidware.xyz/VapeVoidware/VW-Add/" .. (shared.CustomCommit and tostring(
			shared.CustomCommit
		) or "main") .. "/nightsintheforest.lua",
	},
}

debugLog("Game ID lookup: " .. tostring(game.GameId))
local data = meta[game.GameId]
if not data then
	debugLog("No specific game data found, using Universal")
	data = meta[0]
	shared.VAPE_SCRIPTS_DISABLE = true
else
	debugLog("Found game data for: " .. tostring(data.title))
end

pcall(function()
	shared.ACTIVE_LOADER:Destroy()
end)

local timedFunction = function(call, timeout, resFunction, ...)
	local suc, err
	local args = {}
	if call ~= nil and call == true then
		call = timeout
		timeout = 5
		args = { resFunction, ... }
	end
	task.spawn(function()
		suc, err = pcall(function()
			return call(unpack(args))
		end)
	end)
	timeout = timeout or 5
	local start = tick()
	repeat
		task.wait()
	until suc ~= nil or tick() - start >= timeout
	if suc == nil then
		suc = false
		err = "TIMEOUT_EXCEEDED"
	end
	if not suc then
		warn(debug.traceback(err))
	end
	if resFunction ~= nil and type(resFunction) == "function" then
		return resFunction(suc, err)
	end
	return suc, err
end

local __def_table = setmetatable({}, {
	__index = function(self)
		return self
	end,
	__call = function(self)
		return self
	end,
	__newindex = function(self)
		return self
	end,
})

local loaderFile
if data ~= nil and data.no then
	loaderFile = __def_table
end

debugLog("Attempting to load loader file...")
loaderFile = loaderFile
	or timedFunction(
		function()
			debugLog("Fetching loader from URL...")
			local url =
				"https://files.vapevoidware.xyz/VapeVoidware/VWExtra/3ec1c4abde539b3587265577e5c3dfe94d2f1b30/libraries/loader.lua"
			debugLog("Loader URL: " .. url)

			local success, data = pcall(function()
				return game:HttpGet(url, true)
			end)

			if not success then
				debugLog("HTTP GET FAILED: " .. tostring(data))
				debugLog("Error: " .. tostring(data))
				return nil
			end

			debugLog("HTTP GET SUCCESS! Data length: " .. tostring(string.len(data)))
			debugLog("Data preview: " .. string.sub(data, 1, 200) .. "...")

			if data ~= nil and data ~= "nil" then
				debugLog("Data is valid, writing to file...")
				timedFunction(function()
					if not isfolder("voidware_libraries") then
						makefolder("voidware_libraries")
						debugLog("Created voidware_libraries folder")
					end
					writefile("voidware_libraries/loader.lua", data)
					debugLog("Wrote loader.lua file")
				end, 1)
				debugLog("Loading loader string...")
				local loaded = loadstring(data)
				if loaded then
					debugLog("Loader string loaded successfully")
					return loaded()
				else
					debugLog("FAILED to loadstring: data might be invalid")
					return nil
				end
			else
				debugLog("WARNING: Data is nil or 'nil' string!")
				return nil
			end
		end,
		5,
		function(suc, err)
			debugLog("First loader attempt result: success=" .. tostring(suc) .. ", err=" .. tostring(err))
			return suc and err
				or timedFunction(
					function()
						debugLog("Attempting fallback: loading from file...")
						if not isfolder("voidware_libraries") then
							debugLog("voidware_libraries folder doesn't exist, creating...")
							makefolder("voidware_libraries")
						end
						if not isfile("voidware_libraries/loader.lua") then
							debugLog("ERROR: loader file missing!")
							error("loader file missing!")
							return
						end
						debugLog("Reading loader.lua from file...")
						local fileContent = readfile("voidware_libraries/loader.lua")
						debugLog("File loaded, length: " .. tostring(string.len(fileContent)))
						debugLog("File preview: " .. string.sub(fileContent, 1, 200) .. "...")
						local loaded = loadstring(fileContent)
						if loaded then
							debugLog("File loaded successfully")
							return loaded()
						else
							debugLog("FAILED to loadstring from file")
							return nil
						end
					end,
					5,
					function(suc, err)
						debugLog("Fallback attempt result: success=" .. tostring(suc) .. ", err=" .. tostring(err))
						return suc and err or __def_table
					end
				)
		end
	)

debugLog("Checking if loaderFile is valid...")
if loaderFile and type(loaderFile) == "table" and loaderFile.Colors then
	debugLog("loaderFile is a valid table with Colors property")
else
	debugLog("WARNING: loaderFile might be invalid! Type: " .. type(loaderFile))
end

loaderFile.Colors.Gradient = {
	ColorSequenceKeypoint.new(0, Color3.fromHex("#ffd6e8")),
	ColorSequenceKeypoint.new(0.5, Color3.fromHex("#ff8fab")),
	ColorSequenceKeypoint.new(1, Color3.fromHex("#ff477e")),
}

local stitle = "Voidware"
local sicon = nil
pcall(function()
	if tostring(shared.VOIDWARE_SCRIPT_TYPE) == "99_NIGHTS_7Z" then
		loaderFile.Colors.Gradient = {
			ColorSequenceKeypoint.new(0, Color3.fromHex("#e879f9")),
			ColorSequenceKeypoint.new(0.5, Color3.fromHex("#c026d3")),
			ColorSequenceKeypoint.new(1, Color3.fromHex("#7b2fff")),
		}
		stitle = "Pedrin Hub"
		sicon = "rbxassetid://112092059649589"
	end
end)

debugLog("Creating loader instance...")
local loader = loaderFile:Loader(sicon)
shared.ACTIVE_LOADER = loader

loader:Connect(function(res)
	debugLog("Loader result: " .. tostring(res))
	if shared.VoidDev then
		warn(`LOADER RESULT: {tostring(res)}`)
	end
	shared.ACTIVE_LOADER = nil
end)

loader:Update("Booting Up...", 0)
loader:Update("Fetching Game Data...", 10)

if data and data.staging and not shared.VoidDev then
	debugLog("Staging data found but not in dev mode, clearing...")
	data = nil
end

if not data then
	debugLog("Unsupported game detected!")
	print(`Unsupported game :c`)
	loader:Abort(`Unsupported game :c`)
	game:GetService("StarterGui"):SetCore("SendNotification", {
		Title = stitle .. " | Loader",
		Text = "Unsupported game :c",
		Duration = 15,
	})
	return
else
	game:GetService("StarterGui"):SetCore("SendNotification", {
		Title = stitle .. " | Loader",
		Text = "Loading for " .. tostring(data.title) .. "...",
		Duration = 15,
	})
	loader:Update(`Preparing {tostring(stitle)} {tostring(data.title)}...`, 40)
	local res, err

	if shared.VoidDev and data.dev ~= nil and ({ pcall(function()
		return isfile(data.dev)
	end) })[2] then
		debugLog("Using dev file: " .. tostring(data.dev))
		res, err = loadstring(readfile(data.dev))
	else
		debugLog("Fetching script from URL: " .. tostring(data.script))
		local success, scriptContent = pcall(function()
			return game:HttpGet(data.script, true)
		end)

		debugLog("HTTP GET result: success=" .. tostring(success))
		if not success then
			debugLog("HTTP GET FAILED: " .. tostring(scriptContent))
			debugLog("Error: " .. tostring(scriptContent))
		elseif scriptContent == nil or scriptContent == "nil" then
			debugLog("WARNING: Script content is nil or 'nil' string!")
			debugLog("Content type: " .. type(scriptContent))
			debugLog("Content value: " .. tostring(scriptContent))
		else
			debugLog("Script fetched successfully! Length: " .. tostring(string.len(scriptContent)))
			debugLog("Script preview: " .. string.sub(scriptContent, 1, 500) .. "...")
		end

		if scriptContent == nil or scriptContent == "nil" then
			loader:Abort("Voidware Unavailable In Your Region! \n Please use VPN and re execute!")
			game:GetService("StarterGui"):SetCore("SendNotification", {
				Title = "Voidware Unavailable In Your Region",
				Text = "Please use VPN and re execute Voidware!",
				Duration = 15,
			})
			return
		end
		debugLog("Attempting to loadstring...")
		res, err = loadstring(scriptContent)
		if res then
			debugLog("loadstring successful! Function type: " .. type(res))
		else
			debugLog("loadstring FAILED! Error: " .. tostring(err))
		end
	end

	if type(res) ~= "function" then
		debugLog("Res is not a function! Type: " .. type(res))
		game:GetService("StarterGui"):SetCore("SendNotification", {
			Title = stitle .. " Loading Error",
			Text = tostring(res),
			Duration = 15,
		})
		print(`Loading Failed {tostring(err)} :c \n Please try again later\n`)
		loader:Abort(`Loading Failed {tostring(err)} :c \n Please try again later\n`)
		task.delay(0.5, function()
			if shared.VoidDev then
				return
			end
			game:GetService("StarterGui"):SetCore("SendNotification", {
				Title = stitle .. " Loading Error",
				Text = "Please report this issue to erchodev#0 \n or in discord.gg/voidware",
				Duration = 15,
			})
		end)
	else
		debugLog("Executing main script...")
		loader:Update(`Loading {tostring(stitle)}...`, 60)
		local suc, err = pcall(res)
		if not suc then
			debugLog("Main script execution failed: " .. tostring(err))
			print(`Main Loading Error {tostring(err)} :c \n Please try again later\n`)
			loader:Abort(`Main Loading Error {tostring(err)} :c \n Please try again later\n`)
			game:GetService("StarterGui"):SetCore("SendNotification", {
				Title = stitle .. " Main Error",
				Text = tostring(err),
				Duration = 15,
			})
			task.delay(0.5, function()
				if shared.VoidDev then
					return
				end
				game:GetService("StarterGui"):SetCore("SendNotification", {
					Title = stitle .. " Main Error",
					Text = "Please report this issue to erchodev#0 \n or in discord.gg/voidware",
					Duration = 15,
				})
			end)
		else
			debugLog("Main script executed successfully!")
			loader:Update(`Finishing Up...`, 80)
			shared.ACTIVE_LOADER = nil
			loader:Update(`Successfully loaded {tostring(stitle)} {tostring(data.title)} :D`, 100)
			task.delay(0.5, function()
				pcall(function()
					loader:Destroy()
				end)
				debugLog("Loader destroyed")
			end)
		end
	end
end

debugLog("Script completed")
