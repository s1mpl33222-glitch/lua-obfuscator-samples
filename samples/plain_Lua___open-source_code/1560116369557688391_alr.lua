-- Blox Fruits: Private Server + PlaceId Router (no safe load)

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local BF_PLACEIDS = {
    [4442272183] = true,
    [7449423635] = true,
    [100117331123089] = true,
    [79091703265657] = true,
}

local function isPrivateServer_ByOwnerId()
    local privateServerOwner = ReplicatedStorage:WaitForChild("PrivateServerOwnerId")
    if privateServerOwner and privateServerOwner:IsA("IntValue") then
        return privateServerOwner.Value > 0
    end
    return false
end

local isBFPlace = BF_PLACEIDS[game.PlaceId] == true
local isPrivate = isPrivateServer_ByOwnerId()

if isBFPlace and not isPrivate then
    -- Public server + đúng placeid
    loadstring(game:HttpGet("https://raw.githubusercontent.com/MoziIOnTop/pro/refs/heads/main/gpandjoiner"))()
else
    -- Sai placeid OR đúng placeid nhưng private -> chạy key
    loadstring(game:HttpGet("https://raw.githubusercontent.com/okkkkk112/pro/refs/heads/main/key"))()
end
