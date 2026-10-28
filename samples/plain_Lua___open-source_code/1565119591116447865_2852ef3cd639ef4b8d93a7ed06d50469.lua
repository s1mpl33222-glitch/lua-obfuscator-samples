if type(script_key) ~= "string" or script_key == "" then
    error("[Deflua] script_key not set before loading this script.")
    return
end
local _k = script_key
local _l = "5dff755126e504cb47"
local _base = "https://api.deflua.net"
local _pid = tostring(game.PlaceId)
local _gid = tostring(game.GameId)
local _u = _base.."/local_script.lua?script_key=".._k.."&loader=".._l.."&place_id=".._pid.."&game_id=".._gid
local _ok, _res = pcall(function() return game:HttpGet(_u, false) end)
if not _ok then error("[Deflua] Connection failed: "..tostring(_res)) return end
if _res == "GAME_NOT_SUPPORTED" then
    error("[Deflua] This game is not supported.")
    return
end
local _fn, _err = loadstring(_res)
if not _fn then error("[Deflua] Script error: "..tostring(_err)) return end
_fn()
