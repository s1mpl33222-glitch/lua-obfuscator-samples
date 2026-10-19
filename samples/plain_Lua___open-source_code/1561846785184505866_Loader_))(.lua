local Services = setmetatable({}, {
    __index = function(_, serviceName)
        return game:GetService(serviceName)
    end
})

local StarterGui = Services.StarterGui
local MarketplaceService = Services.MarketplaceService
local Players = Services.Players
local LocalPlayer = Players.LocalPlayer
local PlaceId = game.PlaceId
local GameId = game.GameId

local BASE_URL = "https://raw.githubusercontent.com/MyG100777/Main/refs/heads/main/Roblox/Games/"

local GamesMap = {
    [131481383443764] = "Sailueatarchiwa.lua",
    [118805555015549] = "LootToForge.lua",
}

local function Notify(title, text, icon, duration)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title or "Gzus Loader",
            Text = text or "",
            Icon = icon or nil,
            Duration = duration or 5
        })
    end)
end

local function GetGameName()
    local success, info = pcall(function()
        return MarketplaceService:GetProductInfo(PlaceId).Name
    end)
    return success and info or "ไม่พบชื่อเกม"
end

local function FetchScript(fileName)
    local fullUrl = BASE_URL .. fileName
    local success, content = pcall(function()
        return game:HttpGet(fullUrl, true)
    end)
    
    if success and content and #content > 0 then
        return content
    end
    return nil
end

local function Main()
    local gameName = GetGameName()
    Notify("Gzus Loader", "กำลังเช็คเกม: " .. gameName, nil, 3)
    task.wait(0.5)

    local targetScript = GamesMap[PlaceId] or GamesMap[GameId]

    if not targetScript then
        LocalPlayer:Kick("Gzus Loader: ยังไม่รองรับแมพนี้ (PlaceId: " .. tostring(PlaceId) .. ")")
        return
    end

    local rawCode = FetchScript(targetScript)

    if not rawCode then
        return
    end

    local loadedFunc, syntaxError = loadstring(rawCode)

    if not loadedFunc then
        warn("[Gzus Loader] Syntax Error: ", syntaxError)
        Notify("Gzus Loader", "โหลดสคริปต์ไม่สำเร็จ (Syntax Error)", nil, 4)
        return
    end

    local success, execError = pcall(loadedFunc)

    if success then
        Notify("Gzus Loader", "โหลด " .. targetScript .. " เรียบร้อย!", nil, 4)
    end
end

Main()
