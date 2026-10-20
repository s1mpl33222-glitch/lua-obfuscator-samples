repeat wait() until game:IsLoaded() and game:FindFirstChild("CoreGui") and pcall(function() return game.CoreGui end)

getgenv().jinkX = getgenv().jinkX or {}
local _function = {
    ["block_executor"] = function()
        local blockedExecutors = {
            "xeno",
            "solara",
            "velocity"
        }
        if identifyexecutor then
            local current = identifyexecutor():lower()
            for _, name in ipairs(blockedExecutors) do
                if current:find(name) then
                    return true
                end
            end
        end
        return false
    end,
    ["getid"] = function()
        local g = game.GameId
        if getgenv().jinkX and getgenv().jinkX["Fish It"] and getgenv().jinkX["Fish It"]["Enabled"] then return "0708c0109bad431c5513f6d2dcc9b9e5" end -- Fish It Kaitun

        if g == 9051406594 then return "d73b977af0e75026f30f65e1e6c27538" -- Dueling Grounds
        elseif g == 9186719164 then return "a8973c6c4f93baab43a01d8141581e89" -- Sailor Piece
        end
    end,
    ["gamename"] = function()
        local g = game.GameId
        if g == 9051406594 then return "Dueling Grounds"
        elseif g == 9186719164 then return "Sailor Piece"
        end
    end,
}
local keyless_script = {}
local script_id, game_name, block_executor = _function.getid(), _function.gamename(), _function.block_executor()

if block_executor then game.Players.LocalPlayer:Kick("JinkX\nUnsupported executor detected. not supported."); return end
if script_id then
    game.StarterGui:SetCore(
        "SendNotification",
        {
            Title = "JinkX Loaded!",
            Text = (game_name or "Global") .. " Script Loaded!",
            Icon = "rbxassetid://79605757154544",
            Duration = 5
        }
    )
    
    if not table.find(keyless_script, script_id) then
        -- loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/" .. script_id .. ".lua"))()
        local authentication_module = loadstring(game:HttpGet("https://raw.githubusercontent.com/PThitipat/master/main/keysystem.lua"))()
        local auth_status = authentication_module(script_id)
        repeat task.wait() until auth_status.validated
    end
else
    warn("JinkX: This game is not supported.")
end
