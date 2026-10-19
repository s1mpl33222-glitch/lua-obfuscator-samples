local MainGui = {};

local CoreGui = game:GetService("CoreGui")
MainGui["1"] = Instance.new("ScreenGui", CoreGui);
MainGui["1"]["IgnoreGuiInset"] = true;
MainGui["1"]["DisplayOrder"] = 999999999;
MainGui["1"]["ScreenInsets"] = Enum.ScreenInsets.DeviceSafeInsets;
MainGui["1"]["ZIndexBehavior"] = Enum.ZIndexBehavior.Sibling;
MainGui["1"]["ResetOnSpawn"] = false;

MainGui["2"] = Instance.new("ImageLabel", MainGui["1"]);
MainGui["2"]["BorderSizePixel"] = 0;
MainGui["2"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
MainGui["2"]["Image"] = [[rbxassetid://130647873334585]];
MainGui["2"]["Size"] = UDim2.new(0, 498, 0, 339);
MainGui["2"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
MainGui["2"]["BackgroundTransparency"] = 1;
MainGui["2"]["Position"] = UDim2.new(0.18619, 0, 0.25468, 0);

MainGui["3"] = Instance.new("TextLabel", MainGui["2"]);
MainGui["3"]["TextWrapped"] = true;
MainGui["3"]["BorderSizePixel"] = 0;
MainGui["3"]["TextSize"] = 25;
MainGui["3"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
MainGui["3"]["Font"] = Enum.Font.GothamBold;
MainGui["3"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
MainGui["3"]["BackgroundTransparency"] = 1;
MainGui["3"]["Size"] = UDim2.new(0, 93, 0, 22);
MainGui["3"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
MainGui["3"]["Text"] = [[0]];
MainGui["3"]["Name"] = [[CoinsCollected]];
MainGui["3"]["Position"] = UDim2.new(0.60241, 0, 0.43068, 0);

MainGui["4"] = Instance.new("TextLabel", MainGui["2"]);
MainGui["4"]["TextWrapped"] = true;
MainGui["4"]["BorderSizePixel"] = 0;
MainGui["4"]["TextSize"] = 25;
MainGui["4"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
MainGui["4"]["Font"] = Enum.Font.GothamBold;
MainGui["4"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
MainGui["4"]["BackgroundTransparency"] = 1;
MainGui["4"]["Size"] = UDim2.new(0, 83, 0, 22);
MainGui["4"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
MainGui["4"]["Text"] = [[0]];
MainGui["4"]["Name"] = [[CoinsPerHour]];
MainGui["4"]["Position"] = UDim2.new(0.61245, 0, 0.60177, 0);

MainGui["5"] = Instance.new("TextLabel", MainGui["2"]);
MainGui["5"]["TextWrapped"] = true;
MainGui["5"]["BorderSizePixel"] = 0;
MainGui["5"]["TextSize"] = 25;
MainGui["5"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
MainGui["5"]["Font"] = Enum.Font.GothamBold;
MainGui["5"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
MainGui["5"]["BackgroundTransparency"] = 1;
MainGui["5"]["Size"] = UDim2.new(0, 88, 0, 22);
MainGui["5"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
MainGui["5"]["Text"] = [[00:00]];
MainGui["5"]["Name"] = [[Timer]];
MainGui["5"]["Position"] = UDim2.new(0.61245, 0, 0.77581, 0);

local UserInputService = game:GetService("UserInputService")
local Dragging = false
local DragStart, StartPos

MainGui["2"].InputBegan:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
        Dragging = true
        DragStart = Input.Position
        StartPos = MainGui["2"].Position
        Input.Changed:Connect(function()
            if Input.UserInputState == Enum.UserInputState.End then
                Dragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(Input)
    if Dragging and (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) then
        local Delta = Input.Position - DragStart
        MainGui["2"].Position = UDim2.new(
            StartPos.X.Scale,
            StartPos.X.Offset + Delta.X,
            StartPos.Y.Scale,
            StartPos.Y.Offset + Delta.Y
        )
    end
end)

local TweenService = game:GetService("TweenService")
local Player = game.Players.LocalPlayer
local IsFarming = false
local FarmingThread = nil
local TimerThread = nil
local CoinsCollected = 0
local StartTime = os.time()

local function GetParts()
    local Char = Player.Character
    if Char then
        local Root = Char:FindFirstChild("HumanoidRootPart")
        local Hum = Char:FindFirstChild("Humanoid")
        if Root and Hum then
            return Root, Hum
        end
    end
    return nil, nil
end

local function GetMap()
    while true do
        for _, Obj in ipairs(workspace:GetChildren()) do
            if Obj:GetAttribute("MapID") and Obj:FindFirstChild("CoinContainer") then
                return Obj
            end
        end
        task.wait()
    end
end

local function GetNearest(Root)
    if not Root then return nil end
    local Map = GetMap()
    local Closest, Dist = nil, math.huge
    for _, Coin in ipairs(Map.CoinContainer:GetChildren()) do
        local Visual = Coin:FindFirstChild("CoinVisual")
        if Visual and not Visual:GetAttribute("Collected") then
            local D = (Root.Position - Coin.Position).Magnitude
            if D < Dist then
                Closest = Coin
                Dist = D
            end
        end
    end
    return Closest
end

local function MoveTo(Root, Hum, Target)
    if not Root or not Hum then return end
    Hum:ChangeState(11)
    local D = (Root.Position - Target.Position).Magnitude
    local Tween = TweenService:Create(Root, TweenInfo.new(D / 25, Enum.EasingStyle.Linear), {CFrame = Target.CFrame})
    Tween:Play()
    Tween.Completed:Wait()
end

local function StartFarming()
    if FarmingThread then return end

    CoinsCollected = 0
    StartTime = os.time()
    MainGui["3"].Text = "0"
    MainGui["4"].Text = "0"
    MainGui["5"].Text = "00:00"

    TimerThread = task.spawn(function()
        while IsFarming do
            local Elapsed = os.time() - StartTime
            local Minutes = string.format("%02d", math.floor(Elapsed / 60))
            local Seconds = string.format("%02d", Elapsed % 60)
            if MainGui["5"] and MainGui["5"].Parent then
                MainGui["5"].Text = Minutes .. ":" .. Seconds
            end
            task.wait(1)
        end
    end)

    FarmingThread = task.spawn(function()
        while IsFarming do
            local Success, Err = pcall(function()
                while IsFarming do
                    local Root, Hum = GetParts()
                    if not Root or not Hum or not Player:GetAttribute("Alive") then
                        task.wait(0.5)
                        continue
                    end

                    local Target = GetNearest(Root)
                    if Target then
                        MoveTo(Root, Hum, Target)

                        local Visual = Target:FindFirstChild("CoinVisual")
                        local CollectedByUs = false

                        if Visual and not Visual:GetAttribute("Collected") then
                            while Visual and not Visual:GetAttribute("Collected") and Visual.Parent and IsFarming do
                                if not Player:GetAttribute("Alive") or not GetParts() then break end
                                local Next = GetNearest(Root)
                                if Next and Next ~= Target then
                                    break
                                end
                                task.wait()
                            end

                            if not Visual or not Visual.Parent or Visual:GetAttribute("Collected") then
                                CollectedByUs = true
                            end
                        end

                        if CollectedByUs then
                            CoinsCollected = CoinsCollected + 1
                            if MainGui["3"] and MainGui["3"].Parent then
                                MainGui["3"].Text = tostring(CoinsCollected)
                            end
                        end

                        local Elapsed = os.time() - StartTime
                        if Elapsed > 0 then
                            local Cph = math.floor((CoinsCollected / Elapsed) * 3600)
                            if MainGui["4"] and MainGui["4"].Parent then
                                MainGui["4"].Text = tostring(Cph)
                            end
                        else
                            if MainGui["4"] and MainGui["4"].Parent then
                                MainGui["4"].Text = "0"
                            end
                        end
                    else
                        task.wait(0.5)
                    end
                end
            end)

            if not IsFarming then break end
            if Err then
                warn("Farming error: " .. tostring(Err))
                task.wait(1)
            end
        end
    end)
end

local function StopFarming()
    IsFarming = false
    if FarmingThread then
        FarmingThread = nil
    end
    if TimerThread then
        TimerThread = nil
    end
end

local function ToggleFarming()
    IsFarming = not IsFarming
    if IsFarming then
        StartFarming()
    else
        StopFarming()
    end
end

ToggleFarming()

return MainGui["1"], require;