-- This file was generated at discord.gg/syncrypt

local t1 = {}
local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")
game:GetService("TweenService")
t1.Gamepasses = {}
t1.Clothing = {}
local function v4(p1)
    local str = tostring(p1)

    repeat
        local count

        str, count = str:gsub("^(-?%d+)(%d%d%d)", "%1,%2")
    until count == 0

    return str
end
local uDim2 = UDim2.new(0, 90, 0, 95)
local u6
local function v7(_, p3)
    local v24, v25 = u6(p3)
    local t2 = {}
    local u27 = "https://games.RoProxy.com/v2/users/" .. p3 .. "/games?accessFilter=Public&sortOrder=Asc&limit=50"
    local ok, result = pcall(function()
        return HttpService:GetAsync(u27)
    end)
    local u30 = result
    if ok then
        pcall(function()
            u30 = HttpService:JSONDecode(u30)

            for _, v in pairs(u30.data) do
                local v79 = v.id .. "/game-passes?limit=100&sortOrder=Asc"
                local u80 = "https://games.roproxy.com/v1/games/" .. v79
                local ok2, result2 = pcall(function()
                    return HttpService:GetAsync(u80)
                end)
                if ok2 then
                    local data = HttpService:JSONDecode(result2)

                    for _, v2 in pairs(data.data) do
                        t2[v2.id] = true
                    end
                else
                    warn(result2)
                end
            end
        end)
    else
        warn(u30)
    end
    if next(t2) == nil then
        return v24, nil
    end

    return v24, v25, t2
end
local function v8(p4, p5, p6)
    if not p4 then
        return
    end

    for k in pairs(p4) do
        local v51 = k
        local ok, result = pcall(function()
            return MarketplaceService:GetProductInfo(v51, p5)
        end)

        if ok then
            ok = result.IsForSale
        end

        if ok then
            (function(p7, p8)
                if not p6:FindFirstChild((tostring(p7))) then
                    local clone = script.Template:Clone()

                    clone.Size = uDim2

                    local PriceInRobux = p8.PriceInRobux

                    clone.Name = tostring(p7)
                    clone.PurchaseButton.Text = "\238\128\130" .. v4(PriceInRobux)
                    clone.LayoutOrder = PriceInRobux
                    clone.ImportantValues.AssetId.Value = p7
                    clone.ImportantValues.AssetType.Value = "Gamepass"
                    clone.Parent = p6
                end
            end)(v51, result)
        end
    end
end
function u6(p9)
    local u55 = "https://catalog.RoProxy.com/v1/search/items/details?Category=3&CreatorType=%22User%22&IncludeNotForSale=false&Limit=30&CreatorTargetId=" .. p9
    local ok, result = pcall(function()
        return HttpService:GetAsync(u55, true)
    end)
    local u58 = result
    local v59 = ok == false
    if v59 then
        v59 = u58 == "HTTP 429 (Too Many Requests)"
    end
    if v59 then
        wait(1)

        local result3

        ok, result3 = pcall(function()
            return HttpService:GetAsync(u55, true)
        end)
        u58 = result3

        local v61 = ok == false

        if v61 then
            v61 = u58 == "HTTP 429 (Too Many Requests)"
        end

        if v61 then
            wait(1)

            local result4

            ok, result4 = pcall(function()
                return HttpService:GetAsync(u55, true)
            end)
            u58 = result4
        end
    end
    local t3 = {}
    local t4 = {}
    if ok then
        local _, _ = pcall(function()
            u58 = HttpService:JSONDecode(u58)

            for _, v in pairs(u58.data) do
                t3[v.id] = true
                table.insert(t4, v.assetType)
            end
        end)
    end
    if next(t3) == nil then
        return nil
    end

    return t3, t4
end
function t1.GetAssets(_, p11, p12)
    local v70, _, v72 = v7(p11, p11.UserId)

    v8(v72, Enum.InfoType.GamePass, p12)
    v8(v70, Enum.InfoType.Asset, p12)
end
return t1
