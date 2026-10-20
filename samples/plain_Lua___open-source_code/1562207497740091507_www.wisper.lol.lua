local Config = {
    LoaderUrl = "https://www.wisper.lol",
}

local LocalPlayer = game:GetService("Players").LocalPlayer

local function Stop(Message)
    if LocalPlayer then
        LocalPlayer:Kick(Message)
        return
    end
    error(Message, 0)
end

local RequestOk, Source = pcall(function()
    return game:HttpGet(Config.LoaderUrl .. "?telemetry=1&v=" .. tostring(os.time()))
end)

if not RequestOk or type(Source) ~= "string" or #Source == 0 then
    Stop("Wisper loader could not be downloaded.")
end

local Chunk, LoadError = loadstring(Source)
if type(Chunk) ~= "function" then
    Stop(LoadError or "Wisper loader is invalid.")
end

return Chunk()
