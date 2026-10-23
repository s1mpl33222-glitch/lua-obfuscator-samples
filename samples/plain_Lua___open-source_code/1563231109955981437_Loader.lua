local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local pid = game.PlaceId

local GameList = {
    [114326934417838] = "https://vxezestudio.online/api/scripts/script_7duMHGZTfKaWU/stream/init", -- Break and Steal an Egg
    [113290951185459] = "https://vxezestudio.online/api/scripts/script_82HVMJlLn6Omw/stream/init", -- Anime Dice
    [142823291] = "https://vxezestudio.online/api/scripts/script_r0VeAauEuUxPg/stream/init", -- Murder Mystery 2
    [98502499119821] = "https://vxezestudio.online/api/scripts/script_58QYU7BTt9Dg/stream/init", -- Heavyweight Fishing
    [107778070777162] = "https://vxezestudio.online/api/scripts/script_LlZrCUbDIL2mG/stream/init", -- Steal A Egg
    [9872472334] = "https://api.xhider.xyz/files/v4/loaders/4955e760c9f9b495f25dcdb2ea54d7e5.lua", -- Evade
    [119091355492870] = "https://api.xhider.xyz/files/v4/loaders/5e11f8e2650b675806aaa7ccd238f1f3.lua", -- RockFruit Sea 1
    [132854526011923] = "https://api.xhider.xyz/files/v4/loaders/a0d3fb06848e377e3c760eee682ea5b8.lua", -- RockFruit Sea 2
    [82878101790702] = "https://api.xhider.xyz/files/v4/loaders/5e11f8e2650b675806aaa7ccd238f1f3.lua", -- Raid Rockfruitsea1
    [13772394625] = "https://api.xhider.xyz/files/v4/loaders/b264cc179514f7b3b7115beddfa456d9.lua", -- Blade Ball
    [85211729168715] = "BLOX_FRUITS_SELECTOR", -- Blox Fruits
    [79091703265657] = "BLOX_FRUITS_SELECTOR", -- Blox Fruits
    [100117331123089] = "BLOX_FRUITS_SELECTOR", -- Blox Fruits
}

local function loadUrl(url)
    local ok, err = pcall(function()
        local source = game:HttpGet(url)
        local fn = assert(loadstring(source), "Không biên dịch được script")
        fn()
    end)

    if not ok then
        warn("NhoiiiX Hub load error:", err)
    end
end

local url = GameList[pid]

if url == "BLOX_FRUITS_SELECTOR" then
    local playerGui = lp:WaitForChild("PlayerGui")

    local oldGui = playerGui:FindFirstChild("NhoiiiXHubSelector")
    if oldGui then
        oldGui:Destroy()
    end

    local gui = Instance.new("ScreenGui")
    gui.Name = "NhoiiiXHubSelector"
    gui.ResetOnSpawn = false
    gui.Parent = playerGui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.fromOffset(260, 160)
    frame.Position = UDim2.new(0.5, -130, 0.5, -80)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    frame.Parent = gui

    Instance.new("UICorner", frame).CornerRadius =
        UDim.new(0, 12)

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 45)
    title.BackgroundTransparency = 1
    title.Text = "NhoiiiX - Chọn Hub"
    title.TextColor3 = Color3.new(1, 1, 1)
    title.TextSize = 19
    title.Font = Enum.Font.GothamBold
    title.Parent = frame

    local function makeButton(text, y, hubUrl)
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(1, -30, 0, 40)
        button.Position = UDim2.new(0, 15, 0, y)
        button.BackgroundColor3 = Color3.fromRGB(75, 95, 220)
        button.Text = text
        button.TextColor3 = Color3.new(1, 1, 1)
        button.TextSize = 16
        button.Font = Enum.Font.GothamBold
        button.Parent = frame

        Instance.new("UICorner", button).CornerRadius =
            UDim.new(0, 8)

        button.Activated:Connect(function()
            button.Active = false
            button.Text = "Loading..."

            local ok, err = pcall(function()
                local source = game:HttpGet(hubUrl)
                local fn = assert(loadstring(source),
                    "Load error")

                gui:Destroy()
                fn()
            end)

            if not ok then
                warn("NhoiiiX Hub load error:", err)

                if gui.Parent then
                    button.Active = true
                    button.Text = text
                end
            end
        end)
    end

    makeButton(
        "Aimbot PVP",
        55,
        "https://vxezestudio.online/api/scripts/script_Pa7uy5Z0mpKdN/stream/init"
    )

    makeButton(
        "Main Farm",
        105,
        "https://vxezestudio.online/api/scripts/script_KSNOqPAlOI2lc/stream/init"
    )

elseif url then
    loadUrl(url)

else
    warn("Game not supported. PlaceId:", pid)
end
