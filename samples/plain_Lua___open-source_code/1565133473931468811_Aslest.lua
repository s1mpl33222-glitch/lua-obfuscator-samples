local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

WindUI:Notify({
    Title = "Success",
    Content = "Operation completed successfully",
    Duration = 3
})

local Window = WindUI:CreateWindow({
    Title = "ZYX | TBD ", -- window title
    Icon = "bomb", -- lucide icon or "rbxassetid://" or URL. optional
    Author = "By lea", -- window subtitle. optional
    Folder = "By lea", -- folder to save keys and images
    
    Size = UDim2.fromOffset(580, 460), -- window size
    MinSize = Vector2.new(560, 350), -- minimal window size
    MaxSize = Vector2.new(850, 560), -- maximum window size
    Transparent = true, -- window transparency
    Theme = "Indigo", -- library theme
    Resizable = true, -- the ability to rezize window
    SideBarWidth = 200, -- sidebar (tabs) width
    HideSearchBar = true, -- hide search bar
    ScrollBarEnabled = false, -- scrollbars that are located to the right of the scroll frame
 
    BackgroundImageTransparency = 0.42, -- background image transparency
    Background = "rbxassetid://11379739543", -- rbxassetid
    
    User = { -- user information located at the bottom left
        Enabled = false, -- can be toggled with Window.User:Enable() or Window.User:Disable()
        Anonymous = false, -- can be toggled with Window.User:SetAnonymous(true) --(true or false)
        Callback = function() -- callback on click. optional. it can be removed
            print("clicked to the 'user icon'")
        end,
    },
    
    KeySystem = { -- key system from this library
        --  ↓ DEPRECATED
        -- Key = { "1234", "5678" },
 
        -- ✓ use this instead:
        KeyValidator = function(enteredKey)
            if enteredKey == "1234" then
                return true -- this means the key is correct
            end
            return false -- this is if the key is not correct 
        end,
 
        Note = "Example Key System.",
        
        Thumbnail = { -- the image which is located on the left. optional. it can be removed
            Image = "rbxassetid://1234",
            Title = "Thumbnail example", -- optional. it can be removed
        },
        URL = "YOUR LINK TO GET KEY (Discord, Linkvertise, Pastebin, etc.)", -- link to get the key
        
        SaveKey = true, -- automatically save and load the key.
    },
})

local FirstTab = Window:Tab({
    Title = "Combat",
    Icon = "crosshair", -- optional
})

local Toggle = FirstTab:Toggle({
    Title = "اسيست",
    Callback = function(state)
-- =====================================================================
-- MH | TIMEBOMB DUELS - WIND UI TOGGLE INTEGRATION
-- Target Map ID: 11379739543
-- =====================================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- التأكد التام من تحميل الماب بالكامل
if not game:IsLoaded() then
    game.Loaded:Wait()
end

-- التحقق الصارم من آيدي الماب
if game.PlaceId ~= 11379739543 then
    warn("MH Script: Access Denied! Strict Security: Works only in Timebomb Duels [Alpha].")
    return
end

-- متغير حالة الأسيست (مرتبط بالـ Toggle)
local assistEnabled = false

-- التحقق من امتلاك القنبلة بدقة متناهية
local function hasBomb(player)
    if not player or not player.Character then return false end
    local char = player.Character
    if char:FindFirstChild("Bomb") or char:FindFirstChild("Timebomb") or LocalPlayer.Backpack:FindFirstChild("Bomb") or LocalPlayer.Backpack:FindFirstChild("Timebomb") then
        return true
    end
    if player:GetAttribute("HasBomb") == true or char:GetAttribute("HasBomb") == true then
        return true
    end
    return false
end

-- استهداف أقرب خصم صالح
local function getBestTarget()
    local targetChar = nil
    local shortestDist = math.huge
    
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local humanoid = p.Character:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Health > 0 then
                local isTeammate = (p.Team and p.Team == LocalPlayer.Team)
                local enemyHasBomb = hasBomb(p)
                
                if not isTeammate and not enemyHasBomb then
                    local dist = (LocalPlayer.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                    if dist < shortestDist then
                        shortestDist = dist
                        targetChar = p.Character.HumanoidRootPart
                    end
                end
            end
        end
    end
    return targetChar
end

-- تشغيل المحرك الذكي في الخلفية (يعمل فقط إذا كان الـ Toggle مفعلاً)
RunService.RenderStepped:Connect(function()
    if not assistEnabled then return end
    
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") or not char:FindFirstChildOfClass("Humanoid") then return end
    
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    local rootPart = char.HumanoidRootPart
    
    if hasBomb(LocalPlayer) then
        local targetRoot = getBestTarget()
        if targetRoot then
            local raycastParams = RaycastParams.new()
            raycastParams.FilterDescendantsInstances = {char, targetRoot.Parent}
            raycastParams.FilterType = Enum.RaycastFilterType.Exclude
            
            local raycastResult = workspace:Raycast(rootPart.Position, (targetRoot.Position - rootPart.Position), raycastParams)
            local playerVelocity = rootPart.Velocity.Magnitude
            
            if raycastResult then
                local evasionPos = targetRoot.Position + Vector3.new(math.random(-3, 3), 0, math.random(-3, 3))
                humanoid:MoveTo(evasionPos)
            else
                if playerVelocity < 2 then
                    local offsetDirection = (rootPart.Position - targetRoot.Position).Unit
                    local desiredPosition = targetRoot.Position + (offsetDirection * 2.0)
                    humanoid:MoveTo(desiredPosition)
                end
            end
        end
    end
end)
        print("Toggle state:", state)
    end
})
