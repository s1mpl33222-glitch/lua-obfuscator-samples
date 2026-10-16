local v8 = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
local v9 = v8:CreateWindow({
    ["Name"] = "EnygmaLoader, by Enygma",
    ["Icon"] = 95163525434706,
    ["LoadingTitle"] = "EnygmaLoader",
    ["LoadingSubtitle"] = "by Enygma",
    ["ShowText"] = "⬇️",
    ["Theme"] = "Black",
    ["ToggleUIKeybind"] = "K",
    ["DisableRayfieldPrompts"] = true,
    ["DisableBuildWarnings"] = true,
    ["ConfigurationSaving"] = { ["Enabled"] = false, ["FolderName"] = nil, ["FileName"] = "EnygmaXIT" },
})
local v10 = v9:CreateTab("Universal🌌", 95163373932392 - -151502314)
local v11 = v9:CreateTab("Games🎮", 95164226162579 - 700727873)
v10:CreateButton({
    ["Name"] = "Universal - EnygmaXIT",
    ["Callback"] = function()
        local v15 = game:GetService("StarterGui")
        local v16 = Instance.new("BindableFunction")
        v16.OnInvoke = function(v22)
            if v22 == "Yes" then
                loadstring(game:HttpGet("https://pastebin.com/raw/EYyXFV1z"))()
            end
        end
        v15:SetCore(
            "SendNotification",
            {
                ["Title"] = "",
                ["Text"] = "Load Universal - EnygmaXIT?",
                ["Duration"] = 6,
                ["Callback"] = v16,
                ["Button1"] = "Yes",
                ["Button2"] = "No",
            }
        )
    end,
})
v11:CreateButton({
    ["Name"] = "Animal Simulator - EnygmaXIT",
    ["Callback"] = function()
        local v18 = 0 - 0
        local v19
        local v20
        while true do
            if v18 == (120 - (30 + 90)) then
                v19 = game:GetService("StarterGui")
                v20 = Instance.new("BindableFunction")
                v18 = 1 + 0
            end
            if v18 == 1 then
                v20.OnInvoke = function(v24)
                    if v24 == "Yes" then
                        loadstring(game:HttpGet("https://pastebin.com/raw/QVLT8SJ7"))()
                    end
                end
                v19:SetCore(
                    "SendNotification",
                    {
                        ["Title"] = "",
                        ["Text"] = "Animal Simulator - EnygmaXIT?",
                        ["Duration"] = 6,
                        ["Callback"] = v20,
                        ["Button1"] = "Yes",
                        ["Button2"] = "No",
                    }
                )
                break
            end
        end
    end,
})
