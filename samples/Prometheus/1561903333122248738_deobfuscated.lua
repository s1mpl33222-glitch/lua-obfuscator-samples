-- This file was generated at discord.gg/syncrypt

local unpack_ = unpack or table.unpack
local cloneref_ = cloneref or function(p1)
    return p1
end
cloneref_(unpack_({ game:GetService("TweenService") }))
local _ = cloneref_(game:GetService("RunService"))
local LocalPlayer = cloneref_(game:GetService("Players"))
cloneref_(game:GetService("HttpService"))
LocalPlayer = LocalPlayer.LocalPlayer
local v5 = ({
	[66654135] = "635f8a19762b4067444342ce0cc2df18"
})[game.GameId]
if not v5 then
    LocalPlayer:Kick("[PERSEUS] You are not in a supported game!")

    return
end
