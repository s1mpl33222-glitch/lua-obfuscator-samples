local _ENV = (getgenv or getrenv or getfenv)()
local CURRENT_VERSION = _ENV.Version or "V3"

local Versions = {
	V1 = "https://github.com/TlDinhKhoi/Xeter/raw/refs/heads/main/Version/V1.lua",
	V2 = "https://github.com/TlDinhKhoi/Xeter/raw/refs/heads/main/Version/V2.lua",
	V3 = "https://github.com/TlDinhKhoi/Xeter/raw/refs/heads/main/Version/V3.lua",
	V4 = "https://github.com/TlDinhKhoi/Xeter/raw/refs/heads/main/Version/V4.lua",
}

do
	local last_exec = _ENV.xeter_execute_debounce
	if last_exec and (tick() - last_exec) <= 5 then
		return nil
	end
	_ENV.xeter_execute_debounce = tick()
end

do
	local executor = syn or fluxus
	local queueteleport = queue_on_teleport or (executor and executor.queue_on_teleport)

	if not _ENV.xeter_teleport_queue and type(queueteleport) == "function" then
		_ENV.xeter_teleport_queue = true

		local SourceCode = ("loadstring(game:HttpGet('%s'))()"):format(Versions[CURRENT_VERSION] or Versions.V3)

		pcall(queueteleport, SourceCode)
	end
end

local fetcher = {}

local function CreateMessageError(Text)
	if _ENV.xeter_error_message then
		_ENV.xeter_error_message:Destroy()
	end
	local Message = Instance.new("Message", workspace)
	Message.Text = Text
	error(Text, 2)
end

function fetcher.get(url)
	local success, response = pcall(function()
		return game:HttpGet(url)
	end)
	if success then
		return response
	else
		CreateMessageError(`[Fetcher Error] Failed to get URL: {url}\n>>{response}<<`)
	end
end

function fetcher.load(url)
	local raw = fetcher.get(url)
	local func, err = loadstring(raw)
	if type(func) ~= "function" then
		CreateMessageError(`[Load Error] Syntax error at: {url}\n>>{err}<<`)
	else
		return func
	end
end

local versionUrl = Versions[CURRENT_VERSION] or Versions.V3
return fetcher.load(versionUrl)()
