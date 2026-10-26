-- KaiHub loader: reads version.json, then runs the build it points to.
local BASE = "https://raw.githubusercontent.com/KaiGitSel/KaiHub-Loader/main/"
-- execute counter: fire and forget, never blocks or breaks the load
task.spawn(pcall, function()
    local req = request or http_request
    if req then req({ Url = "https://kaihub-count.kaihub.workers.dev/e", Method = "POST" }) end
end)
local ok, err = pcall(function()
    local info = game:GetService("HttpService"):JSONDecode(game:HttpGet(BASE .. "version.json"))
    local file = info.file
    -- only builds/<name>.lua, plain characters, no ".." (the file name comes from a remote file)
    if type(file) ~= "string" or file:sub(1, 7) ~= "builds/" or file:sub(-4) ~= ".lua"
        or file:find("..", 1, true) or file:find("[^%w%._%-/]") then
        error("invalid build path in version.json")
    end
    loadstring(game:HttpGet(BASE .. file))()
end)
if not ok then warn("[KaiHub] loader failed:", err) end
