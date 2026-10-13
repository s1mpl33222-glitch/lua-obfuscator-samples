-- ดีใจอะดิมาเจอหน้านี้ แต่มึงดูดีๆมันไม่ใช่โค้ดเเฮกเกมไอ้ควาย
-- ฝากดิส https://discord.gg/Ugssja4wqQ
local a = game:GetService("Players")
local b = game:GetService("CoreGui")
local c = a.LocalPlayer
local d = c:FindFirstChild("PlayerGui") or c:WaitForChild("PlayerGui")
local e = (pcall(function() return b end) and b) or d
local f = e:FindFirstChild("GKHUB_MAP_SELECTOR")
if f then f:Destroy() end

local g = Instance.new("ScreenGui")
g.Name = "GKHUB_MAP_SELECTOR"
g.ResetOnSpawn = false
g.IgnoreGuiInset = true
g.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
g.Parent = e

local h = Instance.new("Frame")
h.Size = UDim2.fromOffset(330, 230)
h.AnchorPoint = Vector2.new(0.5, 0.5)
h.Position = UDim2.fromScale(0.5, 0.5)
h.BackgroundColor3 = Color3.fromRGB(12, 14, 20)
h.BorderSizePixel = 0
h.Parent = g

local i = Instance.new("UICorner")
i.CornerRadius = UDim.new(0, 10)
i.Parent = h

local j = Instance.new("UIStroke")
j.Color = Color3.fromRGB(45, 110, 200)
j.Transparency = 0.3
j.Thickness = 1.5
j.Parent = h

local k = Instance.new("TextLabel")
k.Size = UDim2.new(1, -30, 0, 35)
k.Position = UDim2.fromOffset(12, 2)
k.BackgroundTransparency = 1
k.Text = "GKHUB --> https://discord.gg/Ugssja4wqQ"
k.TextColor3 = Color3.fromRGB(80, 180, 255)
k.TextSize = 14
k.Font = Enum.Font.GothamBold
k.TextXAlignment = Enum.TextXAlignment.Left
k.Parent = h

local l = Instance.new("TextButton")
l.Size = UDim2.fromOffset(24, 24)
l.AnchorPoint = Vector2.new(1, 0)
l.Position = UDim2.new(1, -8, 0, 6)
l.BackgroundColor3 = Color3.fromRGB(20, 25, 35)
l.BorderSizePixel = 0
l.Text = "X"
l.TextColor3 = Color3.fromRGB(180, 200, 220)
l.TextSize = 10
l.Font = Enum.Font.GothamBold
l.Parent = h

local m = Instance.new("UICorner")
m.CornerRadius = UDim.new(0, 6)
m.Parent = l

l.MouseButton1Click:Connect(function()
    g:Destroy()
end)

local n = Instance.new("Frame")
n.Size = UDim2.new(1, 0, 0, 1)
n.Position = UDim2.fromOffset(0, 36)
n.BackgroundColor3 = Color3.fromRGB(25, 45, 75)
n.BorderSizePixel = 0
n.Parent = h

local o = Instance.new("ScrollingFrame")
o.Size = UDim2.new(1, -16, 1, -44)
o.Position = UDim2.fromOffset(8, 40)
o.BackgroundTransparency = 1
o.BorderSizePixel = 0
o.CanvasSize = UDim2.new(0, 0, 0, 0)
o.ScrollBarThickness = 3
o.Parent = h

local p = Instance.new("UIGridLayout")
p.CellSize = UDim2.fromOffset(148, 110)
p.CellPadding = UDim2.fromOffset(8, 8)
p.Parent = o

p:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    o.CanvasSize = UDim2.new(0, 0, 0, p.AbsoluteContentSize.Y + 10)
end)

local function q(r, s, t)
    local u = Instance.new("Frame")
    u.BackgroundColor3 = Color3.fromRGB(18, 22, 32)
    u.BorderSizePixel = 0
    u.Parent = o
    
    local v = Instance.new("UICorner")
    v.CornerRadius = UDim.new(0, 8)
    v.Parent = u
    
    local w = Instance.new("UIStroke")
    w.Color = Color3.fromRGB(35, 60, 100)
    w.Transparency = 0.5
    w.Parent = u

    local x = Instance.new("ImageLabel")
    x.Size = UDim2.new(1, -8, 0, 48)
    x.Position = UDim2.fromOffset(4, 4)
    x.BackgroundColor3 = Color3.fromRGB(25, 30, 42)
    x.BorderSizePixel = 0
    x.Image = t ~= "" and ("rbxassetid://" .. tostring(t)) or ""
    x.Parent = u
    
    local y = Instance.new("UICorner")
    y.CornerRadius = UDim.new(0, 6)
    y.Parent = x

    local z = Instance.new("TextLabel")
    z.Size = UDim2.new(1, -6, 0, 22)
    z.Position = UDim2.fromOffset(3, 54)
    z.BackgroundTransparency = 1
    z.Text = r
    z.TextColor3 = Color3.fromRGB(230, 235, 245)
    z.TextSize = 11
    z.Font = Enum.Font.GothamMedium
    z.TextTruncate = Enum.TextTruncate.AtEnd
    z.Parent = u
    
    local aa = Instance.new("TextButton")
    aa.Size = UDim2.new(1, -10, 0, 26)
    aa.AnchorPoint = Vector2.new(0.5, 1)
    aa.Position = UDim2.new(0.5, 0, 1, -4)
    aa.BackgroundColor3 = Color3.fromRGB(25, 50, 85)
    aa.BorderSizePixel = 0
    aa.Text = "รัน"
    aa.TextColor3 = Color3.fromRGB(120, 210, 255)
    aa.TextSize = 12
    aa.Font = Enum.Font.GothamBold
    aa.AutoButtonColor = false
    aa.Parent = u
    
    local ab = Instance.new("UICorner")
    ab.CornerRadius = UDim.new(0, 5)
    ab.Parent = aa
    
    aa.MouseButton1Click:Connect(function()
        aa.Text = "กำลังรัน..."
        task.spawn(function()
            local ac, ad = pcall(function()
                local ae = game:HttpGet(s)
                if not ae or ae == "" then
                    error("Empty response from HttpGet")
                end
                local af, ag = loadstring(ae)
                if not af then
                    error("Loadstring error: " .. tostring(ag))
                end
                af()
            end)
            
            if ac then
                g:Destroy()
            else
                aa.Text = "Error"
                warn("[GKHUB] Failed to run " .. r .. ": " .. tostring(ad))
            end
        end)
    end)
end

q("สคริปต์ทุกแมพ", "https://raw.githubusercontent.com/dmjk2885-ship-it/He-oo/refs/heads/main/..%E0%B8%82", "90288004469209")
q("ดีดคนออกแมพ", "https://raw.githubusercontent.com/dmjk2885-ship-it/GK-HUB/refs/heads/main/%E0%B8%AA%E0%B8%84%E0%B8%A3%E0%B8%B4%E0%B8%9B%E0%B8%94%E0%B8%B5%E0%B8%94%E0%B8%84%E0%B8%99%E0%B8%AD%E0%B8%AD%E0%B8%81%E0%B9%80%E0%B9%80%E0%B8%A1%E0%B8%9E", "4575171283")
q("บูสFPS", "https://raw.githubusercontent.com/dmjk2885-ship-it/Lolppp/refs/heads/main/FPS", "107150024905140")
q("Murder Mystery 2", "https://raw.githubusercontent.com/dmjk2885-ship-it/Yiyifi/refs/heads/main/Mm2", "14260707709")
q("The Strongest Battlegrounds", "https://raw.githubusercontent.com/dmjk2885-ship-it/GKHUB-/refs/heads/main/%E0%B8%AA%E0%B8%84%E0%B8%A3%E0%B8%B4%E0%B8%9B%E0%B9%80%E0%B9%80%E0%B8%A1%E0%B8%9ETSB", "100753048194976")
q("Build a Boat", "https://raw.githubusercontent.com/dmjk2885-ship-it/GKHUB-/refs/heads/main/%E0%B9%80%E0%B9%80%E0%B8%A1%E0%B8%9E%E0%B8%AA%E0%B8%A3%E0%B9%89%E0%B8%B2%E0%B8%87%E0%B9%80%E0%B8%A3%E0%B8%B7%E0%B8%AD", "11981759994")
