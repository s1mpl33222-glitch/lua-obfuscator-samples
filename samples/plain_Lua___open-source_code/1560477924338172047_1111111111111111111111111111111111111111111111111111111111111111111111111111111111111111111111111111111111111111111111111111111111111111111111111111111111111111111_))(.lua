getgenv().RAYFIELD_SECURE = true

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/gen2"))()

local Theme = {
    WindowColor = ColorSequence.new(Color3.fromRGB(0, 0, 0)),
    ShadowColor = Color3.fromRGB(0, 0, 0),
    LiveAnimation = false,
    ElementTransparency = 0,
    ElementStroke = Color3.fromRGB(32, 32, 32),
    ElementGradient = ColorSequence.new(Color3.fromRGB(8, 8, 8)),
    AccentColor = Color3.fromRGB(210, 210, 210),
    AccentStroke = Color3.fromRGB(255, 255, 255),
    NeutralButton = Color3.fromRGB(24, 24, 24),
    NeutralButtonHover = Color3.fromRGB(38, 38, 38),
    TitlingColor = Color3.fromRGB(245, 245, 245),
    ContentColor = Color3.fromRGB(205, 205, 205),
}

local Window = Rayfield:CreateWindow({
    name = "Orbit",
    subtitle = "Cobra kai",
    theme = Theme,
    sidebarLayout = true,
})

local StatTab = Window:CreateTab({ name = "Stat" })

local Event = game:GetService("ReplicatedStorage"):WaitForChild("BridgeNet2"):WaitForChild("dataRemoteEvent")

local StrengthEnabled = false
local HealthEnabled = false
local PullUpEnabled = false
local BenchPressEnabled = false
local statLoopRunning = false

local function startStatLoop()
    if statLoopRunning then return end
    statLoopRunning = true

    task.spawn(function()
        while StrengthEnabled or HealthEnabled or PullUpEnabled or BenchPressEnabled do
            if StrengthEnabled then
                Event:FireServer({
                    nil,
                    " "
                })
                task.wait(0.9)
            end

            if BenchPressEnabled then
                Event:FireServer({
                    nil,
                    "("
                })
                task.wait(0.9)
            end
        end

        statLoopRunning = false
        if StrengthEnabled or HealthEnabled or PullUpEnabled or BenchPressEnabled then
            startStatLoop()
        end
    end)
end

StatTab:CreateButton({
    name = "Unload Orbit",
    callback = function()
        StrengthEnabled = false
        HealthEnabled = false
        PullUpEnabled = false
        BenchPressEnabled = false
        Event:FireServer({
            false,
            "\\v"
        })
        Window:Unload()
    end,
})

local divider = StatTab:CreateDivider()

divider:Set("Stats")
divider:Set("Stats")

StatTab:CreateToggle({
    name = "Strength Farm",
    value = false,
    callback = function(enabled)
        StrengthEnabled = enabled
        if enabled then
            startStatLoop()
        end
    end,
})

local divider = StatTab:CreateDivider()

divider:Set("Gamepass")
divider:Set("Gamepass")


StatTab:CreateToggle({
    name = "Bench Press",
    value = false,
    callback = function(enabled)
        BenchPressEnabled = enabled
        if enabled then
            startStatLoop()
        end
    end,
})
