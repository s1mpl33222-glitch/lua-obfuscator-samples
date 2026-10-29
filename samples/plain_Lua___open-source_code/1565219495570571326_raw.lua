local p=game:GetService("Players").LocalPlayer
local s=Instance.new("ScreenGui")
s.Name="MainUI"
s.Parent=p:WaitForChild("PlayerGui")
local f=Instance.new("Frame")
f.Size=UDim2.new(0,300,0,200)
f.Position=UDim2.new(0.5,-150,0.5,-100)
f.BackgroundColor3=Color3.fromRGB(30,30,30)
f.BackgroundTransparency=0.1
f.BorderSizePixel=0
f.Parent=s
local c=Instance.new("UICorner")
c.CornerRadius=UDim.new(0,10)
c.Parent=f
local t=Instance.new("TextLabel")
t.Size=UDim2.new(1,0,0,40)
t.Position=UDim2.new(0,0,0,0)
t.BackgroundTransparency=1
t.Text="Select UI"
t.TextColor3=Color3.fromRGB(255,255,255)
t.TextScaled=true
t.Font=Enum.Font.GothamBold
t.Parent=f
local function q()s:Destroy()end
local o=Instance.new("TextButton")
o.Size=UDim2.new(0,250,0,45)
o.Position=UDim2.new(0.5,-125,0,55)
o.BackgroundColor3=Color3.fromRGB(60,60,60)
o.Text="Old UI (Rayfield)"
o.TextColor3=Color3.fromRGB(255,255,255)
o.TextScaled=true
o.Font=Enum.Font.Gotham
o.Parent=f
local oc=Instance.new("UICorner")
oc.CornerRadius=UDim.new(0,6)
oc.Parent=o
local n=Instance.new("TextButton")
n.Size=UDim2.new(0,250,0,45)
n.Position=UDim2.new(0.5,-125,0,110)
n.BackgroundColor3=Color3.fromRGB(60,60,60)
n.Text="New UI (WindUI)"
n.TextColor3=Color3.fromRGB(255,255,255)
n.TextScaled=true
n.Font=Enum.Font.Gotham
n.Parent=f
local nc=Instance.new("UICorner")
nc.CornerRadius=UDim.new(0,6)
nc.Parent=n
o.MouseButton1Click:Connect(function()
o.BackgroundColor3=Color3.fromRGB(80,80,80)
task.wait(0.1)
o.BackgroundColor3=Color3.fromRGB(60,60,60)
pcall(function()loadstring(game:HttpGet("https://pastefy.app/CLx6Oln7/raw",true))()end)
q()end)
n.MouseButton1Click:Connect(function()
n.BackgroundColor3=Color3.fromRGB(80,80,80)
task.wait(0.1)
n.BackgroundColor3=Color3.fromRGB(60,60,60)
pcall(function()loadstring(game:HttpGet("https://pastefy.app/Zo6SuQcf/raw",true))()end)
q()end)