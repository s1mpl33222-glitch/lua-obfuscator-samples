--!strict

--[[
    🪐 Nexus Hub - Bootstrapper

    Thanks for using Nexus Hub.

    This script tries to load the Nexus Hub script from a primary
    server. If that server doesn't respond, it automatically tries
    a backup server instead. If neither works, an error message
    is shown.

    This bootstrapper itself is open-source and may be freely
    inspected, viewed, and modified. However, this does NOT apply
    to the content served at the sources below, that loader/script
    remains proprietary per the TOS.

    📜 TOS: https://beignet-api.wisp.uno/tos
    🔒 Privacy Policy: https://beignet-api.wisp.uno/privacy
    🛟 Support Server: https://dsc.gg/beignet
--]]

local execName: string, execVersion: string

if identifyexecutor then
	execName, execVersion = identifyexecutor()
elseif getexecutorname then
	execName, execVersion = getexecutorname()
else
	execName, execVersion = "Unknown", "Unknown"
end

print("🪐 Nexus Hub | Using " .. execName .. " " .. execVersion)

local sources: { string } = {
	"https://beignet-api.wisp.uno/static/Loader.luau",
	"http://beignet.deez.nz:15037/static/Loader.luau",
}

local success: boolean = false
for i: number, url: string in ipairs(sources) do
	local ok: boolean = pcall(function(): ()
		loadstring(game:HttpGet(url))()
	end)
	if ok then
		success = true
		break
	else
		if i < #sources then
			warn("🪐 Nexus Hub: URL " .. i .. " failed. Trying the " .. (i + 1) .. "...")
		end
	end
end
if not success then
	error("🪐 Nexus Hub: All servers are down. Please try again later or contact us.")
end
