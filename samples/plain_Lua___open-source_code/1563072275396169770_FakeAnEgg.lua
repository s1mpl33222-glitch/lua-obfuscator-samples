-- 安全載入 UI
local success, UIModule = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/ValueHat-Script/Valuehat-script/refs/heads/main/ValueHatGui4.lua"))()
end)

if not success or not UIModule then
    warn("[ValueHat] UI 載入失敗")
    return
end

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local espEnabled = false
local autoHatchEnabled = false
local instantCollectEnabled = false
local equipBestEnabled = false
local espDrawings = {}

-- ==================== 2D Box + Tracer ESP 邏輯 ====================
local function removeESP(player)
    if espDrawings[player] then
        if espDrawings[player].Box then espDrawings[player].Box:Remove() end
        if espDrawings[player].Tracer then espDrawings[player].Tracer:Remove() end
        espDrawings[player] = nil
    end
end

local function setupESP(player)
    if player == LocalPlayer then return end
    
    local box = Drawing.new("Square")
    box.Visible = false
    box.Color = Color3.fromRGB(255, 0, 0)
    box.Thickness = 1
    box.Filled = false

    local tracer = Drawing.new("Line")
    tracer.Visible = false
    tracer.Color = Color3.fromRGB(255, 0, 0)
    tracer.Thickness = 1

    espDrawings[player] = {Box = box, Tracer = tracer}
end

Players.PlayerAdded:Connect(setupESP)
Players.PlayerRemoving:Connect(removeESP)

for _, player in ipairs(Players:GetPlayers()) do
    setupESP(player)
end

-- 每幀更新 ESP 畫面
RunService.RenderStepped:Connect(function()
    if not espEnabled then
        for _, drawings in pairs(espDrawings) do
            drawings.Box.Visible = false
            drawings.Tracer.Visible = false
        end
        return
    end

    for player, drawings in pairs(espDrawings) do
        local character = player.Character
        local hrp = character and character:FindFirstChild("HumanoidRootPart")
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")

        if character and hrp and humanoid and humanoid.Health > 0 then
            local rootPos = hrp.Position
            local topPos = rootPos + Vector3.new(0, 3, 0)
            local bottomPos = rootPos - Vector3.new(0, 3.5, 0)
            
            local topScreen, topOnScreen = Camera:WorldToViewportPoint(topPos)
            local bottomScreen, bottomOnScreen = Camera:WorldToViewportPoint(bottomPos)

            if topOnScreen or bottomOnScreen then
                local height = math.abs(topScreen.Y - bottomScreen.Y)
                local width = height / 2

                -- 更新方框位置與大小
                drawings.Box.Size = Vector2.new(width, height)
                drawings.Box.Position = Vector2.new(topScreen.X - width / 2, topScreen.Y)
                drawings.Box.Visible = true

                -- 更新連線（從畫面底部中央指向玩家）
                drawings.Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                drawings.Tracer.To = Vector2.new(topScreen.X, topScreen.Y + height)
                drawings.Tracer.Visible = true
            else
                drawings.Box.Visible = false
                drawings.Tracer.Visible = false
            end
        else
            drawings.Box.Visible = false
            drawings.Tracer.Visible = false
        end
    end
end)

-- ==================== 找自己的 Base ====================
local function getMyBasePart()
    local bases = Workspace:FindFirstChild("Bases")
    if not bases then 
        warn("[Instant Collect] 找不到 workspace.Bases")
        return nil 
    end

    local accountName = LocalPlayer.Name:lower()
    local displayName = LocalPlayer.DisplayName:lower()

    for i = 1, 10 do
        local baseFolder = bases:FindFirstChild(tostring(i))
        if baseFolder then
            local sign = baseFolder:FindFirstChild("Sign")
            if sign then
                local display = sign:FindFirstChild("Display")
                if display then
                    local gui = display:FindFirstChild("BaseDisplayGui")
                    if gui then
                        local frame = gui:FindFirstChild("Frame")
                        if frame then
                            local info = frame:FindFirstChild("Info")
                            if info then
                                local playerNameLabel = info:FindFirstChild("PlayerName")
                                if playerNameLabel and playerNameLabel:IsA("TextLabel") then
                                    local text = playerNameLabel.Text
                                    if text then
                                        local cleanText = text:match("^%s*(.-)%s*$") or text
                                        cleanText = cleanText:lower()

                                        if cleanText == accountName 
                                        or cleanText == displayName 
                                        or cleanText:find(accountName, 1, true) 
                                        or cleanText:find(displayName, 1, true) then
                                            
                                            local part = baseFolder:FindFirstChild("Part")
                                            if part and part:IsA("BasePart") then
                                                print("[Instant Collect] 找到自己的 Base:", i, "| 名稱:", text)
                                                return part
                                            else
                                                warn("[Instant Collect] Base", i, "有名稱但找不到 Part")
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    
    warn("[Instant Collect] 找不到自己的 Base (已檢查 1-10)")
    return nil
end

-- ==================== Auto Hatch 邏輯 ====================
task.spawn(function()
    while true do
        if autoHatchEnabled then
            pcall(function()
                local nestEggs = Workspace:FindFirstChild("NestEggs")
                if nestEggs then
                    for _, child in ipairs(nestEggs:GetChildren()) do
                        if child:IsA("Model") then
                            local hatchPrompt = child:FindFirstChild("HatchPrompt", true)
                            if hatchPrompt and hatchPrompt:IsA("ProximityPrompt") then
                                fireproximityprompt(hatchPrompt)
                            end
                        end
                    end
                end
            end)
        end
        task.wait(0.2)
    end
end)

-- ==================== Auto Equip Best 邏輯 ====================
task.spawn(function()
    while true do
        if equipBestEnabled then
            pcall(function()
                local equipBestEvent = ReplicatedStorage:FindFirstChild("RemoteEvents") 
                    and ReplicatedStorage.RemoteEvents:FindFirstChild("EquipBestEvent")
                if equipBestEvent then
                    equipBestEvent:FireServer()
                end
            end)
        end
        task.wait(2) -- 每 2 秒自動裝備一次最佳寵物
    end
end)

-- ==================== 偵測 Remote 購買並執行傳送 ====================
local function setupInstantCollectHook()
    task.spawn(function()
        local eggRemotes = ReplicatedStorage:WaitForChild("EggRemotes", 8)
        if not eggRemotes then return end
        local eggEvent = eggRemotes:WaitForChild("EggEvent", 8)
        if not eggEvent then return end

        local oldNamecall
        oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
            if not instantCollectEnabled then
                return oldNamecall(self, ...)
            end

            local method = getnamecallmethod()
            local args = {...}

            if self == eggEvent and (method == "FireServer" or method == "InvokeServer") then
                if args[1] == "Buy" then
                    -- 1. 執行原本的購買 Remote
                    local result = oldNamecall(self, unpack(args))

                    -- 2. 偵測到購買後等一秒
                    task.spawn(function()
                        task.wait(1)

                        local character = LocalPlayer.Character
                        local hrp = character and character:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            local originalCFrame = hrp.CFrame
                            local basePart = getMyBasePart()

                            if basePart then
                                -- 3. 傳送到 Base
                                hrp.CFrame = basePart.CFrame + Vector3.new(0, 3, 0)
                                print("[Instant Collect] 已傳送到基地，等待一秒...")

                                -- 4. 在基地等一秒
                                task.wait(1)

                                -- 5. 傳回原位
                                hrp.CFrame = originalCFrame
                                print("[Instant Collect] 已傳回原位！")
                            else
                                warn("[Instant Collect] 傳送失敗：找不到自己的 Base Part")
                            end
                        end
                    end)

                    return result
                end
            end

            return oldNamecall(self, ...)
        end)
    end)
end

setupInstantCollectHook()

-- ==================== UI ====================
local Hub = UIModule.CreateWindow("Fake an Egg", "TikTok: ValueHat")

Hub:CreateToggle("Player ESP", false, function(on)
    espEnabled = on
    if on then
        print("[ESP] 已開啟 (紅色方框與連線)")
    else
        print("[ESP] 已關閉")
        for _, drawings in pairs(espDrawings) do
            drawings.Box.Visible = false
            drawings.Tracer.Visible = false
        end
    end
end)

Hub:CreateToggle("Instant Collect", false, function(on)
    instantCollectEnabled = on
    if on then
        print("[Instant Collect] 已開啟 (將自動偵測購買並傳送)")
    else
        print("[Instant Collect] 已關閉")
    end
end)

Hub:CreateToggle("Auto Hatch", false, function(on)
    autoHatchEnabled = on
    if on then
        print("[Auto Hatch] 已開啟")
    else
        print("[Auto Hatch] 已關閉")
    end
end)

-- 將 Equip Best 改為開關
Hub:CreateToggle("Equip Best", false, function(on)
    equipBestEnabled = on
    if on then
        print("[Equip Best] 已開啟 (自動裝備最佳)")
    else
        print("[Equip Best] 已關閉")
    end
end)

print("[ValueHat] Script loaded successfully!")
