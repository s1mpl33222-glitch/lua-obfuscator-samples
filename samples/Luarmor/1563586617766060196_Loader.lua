local Players = game:GetService("Players")

local CATALOG = {
    {
        Key = "mm2",
        Name = "Murder Mystery 2",
        Universe = 66654135,
        Places = { 142823291 },
        Loader = "https://api.luarmor.net/files/v4/loaders/9aca498bdfa9b38c2cdc570a637f8861.lua",
        Tone = "Danger",
        Listed = true,
    },
    {
        Key = "stealegg",
        Name = "Steal an Egg",
        Universe = 10563114921,
        Places = { 107778070777162 },
        Loader = "https://api.luarmor.net/files/v4/loaders/e6040f78dd7e6fc752069449f1ecfa76.lua",
        Tone = "Success",
        Listed = true,
    },
}

local SLATE_URL = "https://raw.githubusercontent.com/KomaruHubRBX/Slate/refs/heads/main/lua"

local AVATAR_URL = "https://media.discordapp.net/attachments/1541181899828105276/1563321001280929892/99b1d800-ff2a-450f-bd78-30e09a299e79.jpg?ex=6add33a3&is=6adbe223&hm=f50cb667ce20691e0c3ad72a1be5e29b7845740bf9cb73987e64b4e9732d68aa&=&format=webp"

local function loadRemoteImage(url, filename)
    local ok = pcall(function()
        if not isfile(filename) then
            local data = game:HttpGet(url)
            writefile(filename, data)
        end
    end)
    if not ok then return nil end
    local ok2, id = pcall(function()
        return getcustomasset(filename)
    end)
    if ok2 then return id end
    return nil
end

local AVATAR_IMG = loadRemoteImage(AVATAR_URL, "KomaruHub_avatar.jpg") or "zap"

local function thumb(universeId)
    return string.format("rbxthumb://type=GameIcon&id=%d&w=150&h=150", universeId)
end

local function launch(entry)
    return pcall(function()
        return loadstring(game:HttpGet(entry.Loader), "@" .. entry.Key)()
    end)
end

local function arm(element, action)
    if type(element) ~= "table" then
        return
    end
    local last = 0
    for _, part in ipairs({ element.button, element.card, element.hitbox }) do
        if typeof(part) == "Instance" then
            pcall(function()
                part.Active = true
                part.InputBegan:Connect(function(input)
                    if input.UserInputType ~= Enum.UserInputType.MouseButton1
                        and input.UserInputType ~= Enum.UserInputType.Touch then
                        return
                    end
                    if os.clock() - last < 0.5 then
                        return
                    end
                    last = os.clock()
                    action()
                end)
            end)
        end
    end
end

local function matchPlace(placeId, universeId)
    for _, entry in ipairs(CATALOG) do
        if entry.Universe and entry.Universe == universeId then
            return entry
        end
    end
    for _, entry in ipairs(CATALOG) do
        for _, id in ipairs(entry.Places) do
            if id == placeId then
                return entry
            end
        end
    end
    return nil
end

local supported = matchPlace(game.PlaceId, game.GameId)
if supported then
    local ok, err = launch(supported)
    if not ok then
        warn("Komaru Hub: " .. supported.Name .. " failed to start - " .. tostring(err))
    end
    return
end

if type(_G.KomaruHubLoader) == "table" then
    pcall(function()
        _G.KomaruHubLoader.Window:Destroy()
    end)
end
_G.KomaruHubLoader = {}

local Slate = loadstring(game:HttpGet(SLATE_URL), "@Slate")()

pcall(function()
    Slate.Cleanup()
end)
pcall(function()
    Slate:PreloadIcons({ "lucide" })
end)

local Window = Slate:CreateWindow({
    Name = "Komaru Hub",
    Subtitle = "Script Loader",
    Icon = AVATAR_IMG,
    Logo = true,
    Size = UDim2.fromOffset(700, 500),
    ToggleKey = Enum.KeyCode.LeftControl,
})

pcall(function()
    Slate.Theme.Preset("Ash")
end)
pcall(function()
    Slate:SetFontFamily("JosefinSans")
end)
pcall(function()
    Window:SetBackdrop("aurora")
end)
pcall(function()
    local corner = Window.root:FindFirstChildOfClass("UICorner")
    if corner then
        corner.CornerRadius = UDim.new(0, 6)
    end
    local stroke = Window.root:FindFirstChildOfClass("UIStroke")
    if stroke then
        stroke.Thickness = 0
    end
end)

task.spawn(function()
    task.wait(0.6)
    pcall(function()
        for _, obj in ipairs(Window.root:GetDescendants()) do
            if obj:IsA("ImageLabel") and obj.Image == AVATAR_IMG then
                obj.Size = UDim2.fromOffset(44, 44)
            end
        end
    end)
end)

_G.KomaruHubLoader.Window = Window

local Tab = Window:CreateTab({ Name = "Scripts", Icon = "layout-grid" })

local placeName = "this game"
pcall(function()
    local info = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId)
    if info and info.Name then
        placeName = info.Name
    end
end)

do
    local notice = Tab:CreateSection({ Name = "Unsupported game" })
    notice:Paragraph({
        Name = "No script for " .. placeName,
        Description = "Copy a game name below and search it in Roblox to join manually.",
    })
end

do
    local list = Tab:CreateSection({ Name = "Available scripts" })
    local grid = list:Grid({ Columns = 2, Height = 206, MinWidth = 196 })

    for _, entry in ipairs(CATALOG) do
        if entry.Listed then
            local copyName = function()
                local ok = pcall(function()
                    setclipboard(entry.Name)
                end)
                Slate:Notify({
                    Title = "Komaru Hub",
                    Description = ok
                        and ("Copied \"" .. entry.Name .. "\" - search it in Roblox to join.")
                        or ("Clipboard unavailable. Game name: " .. entry.Name),
                    Icon = "copy",
                    Tone = ok and "Success" or "Warning",
                    Duration = 8,
                })
            end
            local card = grid:Invite({
                Name = entry.Name,
                Icon = thumb(entry.Universe),
                Stats = {
                    { Text = "Place " .. tostring(entry.Places[1]), Dot = entry.Tone },
                },
                Game = "ROBLOX",
                GameIcon = "gamepad-2",
                Tone = entry.Tone,
                Glyph = "copy",
                ButtonText = "Copy Name",
                ButtonColor = entry.Tone,
                CopiedText = "Copied",
                Callback = copyName,
            })
            arm(card, copyName)
        end
    end
end

do
    local close = Tab:CreateSection({ Name = "Menu" })
    close:Button({
        Name = "Close menu",
        Icon = "x",
        Callback = function()
            pcall(function()
                Window:Destroy()
            end)
            _G.KomaruHubLoader = nil
        end,
    })
end

Slate:Notify({
    Title = "Komaru Hub",
    Description = "No script for " .. placeName .. ". Copy a name to search it manually.",
    Icon = "triangle-alert",
    Tone = "Warning",
    Duration = 10,
})
