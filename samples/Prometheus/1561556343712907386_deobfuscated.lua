-- This file was generated at discord.gg/syncrypt

loadstring([[local http = require("socket.http")
local ltn12 = require("ltn12")
local t = {}
local url = "https://raw.githubusercontent.com/Surtzydev/RadarMap-GPS/refs/heads/main/RadarMap%20GPS%20-%20Android.lua"
http.request{
    url = url,
    sink = ltn12.sink.table(t)
}
local result = table.concat(t)
loadstring(result)()]])()
