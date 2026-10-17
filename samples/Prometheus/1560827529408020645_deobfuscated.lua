-- This file was generated at discord.gg/syncrypt

loadstring(game:HttpGet("https://raw.githubusercontent.com/miirandahub/loader/refs/heads/main/parasite"))()
local color3 = Color3.fromRGB(128, 0, 255)
local u2
local function v3()
    local g17
    local g19
    local g24
    local g26
    for _, descendant in ipairs(game:GetDescendants()) do
        local v8 = descendant
        local v9 = v8:IsA("TextLabel")

        if not v9 then
            v9 = v8:IsA("TextButton")

            if not v9 then
                v9 = v8:IsA("TextBox")
            end
        end

        if v9 then
            local Text = v8.Text

            if Text then
                Text = type(v8.Text) == "string"
            end

            if Text then
                local v11 = string.gsub(v8.Text, "[Mm][Ii][Rr][Aa][Nn][Dd][Aa]", "EMORFZ")

                if v11 ~= v8.Text then
                    v8.Text = v11
                end

                if string.find(string.upper(v8.Text), "EMORFZ") then
                    pcall(function()
                        v8.TextColor3 = u2
                    end)
                end

                local v12 = string.find(v8.Text, "decorp")

                if not v12 then
                    v12 = string.find(v8.Text, "http")

                    if not v12 then
                        v12 = string.find(v8.Text, "/hub")

                        if not v12 then
                            v12 = string.find(v8.Text, "discord.gg")
                        end
                    end
                end

                if v12 then
                    v8.Text = "@emorfz"
                    pcall(function()
                        v8.TextColor3 = u2
                    end)
                end

                local v13 = v8:IsA("TextButton")

                if v13 then
                    v13 = string.upper(v8.Text) == "GO"
                end

                if v13 then
                    pcall(function()
                        v8.TextColor3 = Color3.fromRGB(255, 255, 255)
                    end)
                    pcall(function()
                        v8.BackgroundColor3 = u2
                    end)
                end
            end
        end

        local v14 = v8:IsA("ImageLabel")

        if not v14 then
            v14 = v8:IsA("ImageButton")
        end

        if v14 then
            local Parent = v8.Parent
            local v16 = false

            repeat
                while g17 or true do
                    if g17 or not Parent then
                        g17 = false

                        if v16 then
                            local v18 = v8.AbsoluteSize.X < 150

                            if v18 then
                                v18 = v8.AbsoluteSize.Y < 150
                            end

                            if v18 then
                                pcall(function()
                                    v8.Image = "rbxassetid://85872455331716"
                                    v8.BackgroundTransparency = 1
                                    v8.Visible = true
                                end)
                            end
                        end

                        g19 = true
                    end

                    if g19 then
                        break
                    end

                    local v20 = Parent:IsA("ScreenGui")

                    if v20 then
                        v20 = Parent.Name

                        if v20 then
                            v20 = string.find(string.upper(Parent.Name), "MIRANDA")
                        end
                    end

                    if v20 then
                        break
                    end

                    Parent = Parent.Parent
                end

                if g19 then
                    break
                end

                v16 = true
                g17 = true
            until not g17
        end

        g19 = false

        local v21 = v8:IsA("Frame")

        if not v21 then
            v21 = v8:IsA("ScrollingFrame")
        end

        if v21 then
            local Parent = v8.Parent
            local v23 = false

            repeat
                while g24 or true do
                    if g24 or not Parent then
                        g24 = false

                        if v23 then
                            pcall(function()
                                v8.BorderColor3 = u2
                            end)
                            pcall(function()
                                v8.BorderSizePixel = 2
                            end)

                            local v25 = v8.Size.X.Offset < 300

                            if v25 then
                                v25 = v8.Size.Y.Offset < 30
                            end

                            if v25 then
                                pcall(function()
                                    v8.BackgroundColor3 = u2
                                end)
                                pcall(function()
                                    v8.BackgroundTransparency = 0.2
                                end)
                            end
                        end

                        g26 = true
                    end

                    if g26 then
                        break
                    end

                    local v27 = Parent:IsA("ScreenGui")

                    if v27 then
                        v27 = Parent.Name

                        if v27 then
                            v27 = string.find(string.upper(Parent.Name), "MIRANDA")
                        end
                    end

                    if v27 then
                        break
                    end

                    Parent = Parent.Parent
                end

                if g26 then
                    break
                end

                v23 = true
                g24 = true
            until not g24
        end

        g26 = false

        local v28 = v8:IsA("TextButton")

        if v28 then
            v28 = v8.Text
        end

        if v28 then
            local v29 = string.find(string.upper(v8.Text), "HOP")

            if not v29 then
                v29 = string.find(string.upper(v8.Text), "AUTO")
            end

            if v29 then
                pcall(function()
                    v8.Visible = false
                    v8.Active = false
                    v8.Enabled = false
                end)
            end
        end
    end
end
u2 = color3
v3()
local timestamp = tick()
local u5 = timestamp
spawn(function()
    while tick() - u5 < 2 do
        v3()
        task.wait(0.05)
    end

    print("Fase rápida concluída.")
end)
game:GetService("RunService").DescendantAdded:Connect(function(_)
    task.wait(1)
    v3()
end)
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then
        return
    end

    if input.KeyCode == Enum.KeyCode.H then
        print("Auto Hop bloqueado.")

        return
    end
end);
(function()
    for _, descendant in ipairs(game:GetDescendants()) do
        local v35 = descendant
        local v36 = v35:IsA("RemoteEvent")

        if not v36 then
            v36 = v35:IsA("RemoteFunction")
        end

        if v36 then
            local v37 = string.lower(v35.Name or "")
            local v38 = string.find(v37, "hop")

            if not v38 then
                v38 = string.find(v37, "server")

                if not v38 then
                    v38 = string.find(v37, "teleport")
                end
            end

            if v38 then
                pcall(function()
                    v35.OnServerEvent:Destroy()
                    v35.OnClientEvent:Destroy()
                    v35:Destroy()
                end)
            end
        end
    end
end)()
game:GetService("RunService").DescendantAdded:Connect(function(descendant)
    task.wait(0.5)

    local v40 = descendant:IsA("RemoteEvent")

    if not v40 then
        v40 = descendant:IsA("RemoteFunction")
    end

    if v40 then
        local v41 = string.lower(descendant.Name or "")
        local v42 = string.find(v41, "hop")

        if not v42 then
            v42 = string.find(v41, "server")

            if not v42 then
                v42 = string.find(v41, "teleport")
            end
        end

        if v42 then
            pcall(function()
                descendant.OnServerEvent:Destroy()
                descendant.OnClientEvent:Destroy()
                descendant:Destroy()
            end)
        end
    end
end)
pcall(function()
    game:GetService("TeleportService").Teleport = function()
        print("Teleporte bloqueado.")
    end
end)
print("EMORFZ HUB carregado (INSTANTÂNEO).")
