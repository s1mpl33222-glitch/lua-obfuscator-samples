-- zunprotector | SCRIPT PROTEGIDO

local luruaadgbk=game:GetService("Players")
local lurue1jpjo=game:GetService("UserInputService")
local luruk32cp6=game:GetService("TweenService")
local lurujjyi5j=luruaadgbk.LocalPlayer
local luru316hgq=lurujjyi5j:WaitForChild("PlayerGui")
local lurusi6ynt={
ToggleKey=Enum.KeyCode.K,
Title="Painel de Controle",
Size=UDim2.fromOffset(420,340),
Accent=Color3.fromRGB(90,140,255),
BgColor=Color3.fromRGB(34,36,44),
BarColor=Color3.fromRGB(26,28,34),
ItemColor=Color3.fromRGB(46,49,60),
TextColor=Color3.fromRGB(235,236,245),
}
local function luruuyldus(luru5h624q,luru154yu1)
local lurulbrr44=Instance.new("UICorner")
lurulbrr44.CornerRadius=UDim.new(0,luru154yu1)
lurulbrr44.Parent=luru5h624q
return lurulbrr44
end
local luruu6xkd0=luru316hgq:FindFirstChild("PainelLuau")
if luruu6xkd0 then luruu6xkd0:Destroy()end
local luruzvjqz4=Instance.new("ScreenGui")
luruzvjqz4.Name="PainelLuau"
luruzvjqz4.ResetOnSpawn=false
luruzvjqz4.IgnoreGuiInset=true
luruzvjqz4.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
luruzvjqz4.Parent=luru316hgq
local luru6hhsqm=Instance.new("Frame")
luru6hhsqm.Name="Panel"
luru6hhsqm.AnchorPoint=Vector2.new(0.5,0.5)
luru6hhsqm.Position=UDim2.fromScale(0.5,0.5)
luru6hhsqm.Size=lurusi6ynt.Size
luru6hhsqm.BackgroundColor3=lurusi6ynt.BgColor
luru6hhsqm.BorderSizePixel=0
luru6hhsqm.ClipsDescendants=true
luru6hhsqm.Visible=false
luru6hhsqm.Parent=luruzvjqz4
luruuyldus(luru6hhsqm,12)
local luruhvo2zb=Instance.new("UIStroke")
luruhvo2zb.Color=Color3.fromRGB(62,66,80)
luruhvo2zb.Thickness=1
luruhvo2zb.Parent=luru6hhsqm
local luru6absni=Instance.new("Frame")
luru6absni.Name="TitleBar"
luru6absni.Size=UDim2.new(1,0,0,44)
luru6absni.BackgroundColor3=lurusi6ynt.BarColor
luru6absni.BorderSizePixel=0
luru6absni.Parent=luru6hhsqm
local lurutcki4r=Instance.new("UIGradient")
lurutcki4r.Color=ColorSequence.new(Color3.fromRGB(44,48,60),lurusi6ynt.BarColor)
lurutcki4r.Rotation=90
lurutcki4r.Parent=luru6absni
local luruukkmy4=Instance.new("TextLabel")
luruukkmy4.BackgroundTransparency=1
luruukkmy4.Position=UDim2.fromOffset(16,0)
luruukkmy4.Size=UDim2.new(1,-60,1,0)
luruukkmy4.Font=Enum.Font.GothamBold
luruukkmy4.TextSize=15
luruukkmy4.TextColor3=lurusi6ynt.TextColor
luruukkmy4.TextXAlignment=Enum.TextXAlignment.Left
luruukkmy4.Text=lurusi6ynt.Title
luruukkmy4.Parent=luru6absni
local luruczz0e4=Instance.new("TextButton")
luruczz0e4.AnchorPoint=Vector2.new(1,0.5)
luruczz0e4.Position=UDim2.new(1,-10,0.5,0)
luruczz0e4.Size=UDim2.fromOffset(28,28)
luruczz0e4.BackgroundColor3=Color3.fromRGB(220,70,80)
luruczz0e4.BackgroundTransparency=1
luruczz0e4.Text="✕"
luruczz0e4.Font=Enum.Font.GothamBold
luruczz0e4.TextSize=14
luruczz0e4.TextColor3=Color3.fromRGB(170,175,190)
luruczz0e4.AutoButtonColor=false
luruczz0e4.Parent=luru6absni
luruuyldus(luruczz0e4,8)
luruczz0e4.MouseEnter:Connect(function()
luruk32cp6:Create(luruczz0e4,TweenInfo.new(0.15),{
BackgroundTransparency=0,
TextColor3=Color3.new(1,1,1),
}):Play()
end)
luruczz0e4.MouseLeave:Connect(function()
luruk32cp6:Create(luruczz0e4,TweenInfo.new(0.15),{
BackgroundTransparency=1,
TextColor3=Color3.fromRGB(170,175,190),
}):Play()
end)
local lurupcvkl8=Instance.new("ScrollingFrame")
lurupcvkl8.Name="Content"
lurupcvkl8.Position=UDim2.fromOffset(0,44)
lurupcvkl8.Size=UDim2.new(1,0,1,-44)
lurupcvkl8.BackgroundTransparency=1
lurupcvkl8.BorderSizePixel=0
lurupcvkl8.ScrollBarThickness=4
lurupcvkl8.ScrollBarImageColor3=Color3.fromRGB(80,85,100)
lurupcvkl8.CanvasSize=UDim2.new()
lurupcvkl8.AutomaticCanvasSize=Enum.AutomaticSize.Y
lurupcvkl8.Parent=luru6hhsqm
local luruqmhy4b=Instance.new("UIPadding")
luruqmhy4b.PaddingTop=UDim.new(0,12)
luruqmhy4b.PaddingBottom=UDim.new(0,12)
luruqmhy4b.PaddingLeft=UDim.new(0,12)
luruqmhy4b.PaddingRight=UDim.new(0,12)
luruqmhy4b.Parent=lurupcvkl8
local lurupeo8hu=Instance.new("UIListLayout")
lurupeo8hu.Padding=UDim.new(0,8)
lurupeo8hu.SortOrder=Enum.SortOrder.LayoutOrder
lurupeo8hu.Parent=lurupcvkl8
local function luru5d1igs(lururai8j8)
local luru8r225y=Instance.new("TextLabel")
luru8r225y.Size=UDim2.new(1,0,0,20)
luru8r225y.BackgroundTransparency=1
luru8r225y.Font=Enum.Font.GothamBold
luru8r225y.TextSize=11
luru8r225y.TextColor3=lurusi6ynt.Accent
luru8r225y.TextXAlignment=Enum.TextXAlignment.Left
luru8r225y.Text=string.upper(lururai8j8)
luru8r225y.Parent=lurupcvkl8
return luru8r225y
end
local function lurucj7x0u(luruswxiis,luruq1b2rm)
local luru4cb9cs=Instance.new("TextButton")
luru4cb9cs.Size=UDim2.new(1,0,0,34)
luru4cb9cs.BackgroundColor3=lurusi6ynt.ItemColor
luru4cb9cs.AutoButtonColor=false
luru4cb9cs.Text=""
luru4cb9cs.Parent=lurupcvkl8
luruuyldus(luru4cb9cs,8)
local lurukwdibl=Instance.new("TextLabel")
lurukwdibl.BackgroundTransparency=1
lurukwdibl.Position=UDim2.fromOffset(12,0)
lurukwdibl.Size=UDim2.new(1,-24,1,0)
lurukwdibl.Font=Enum.Font.GothamMedium
lurukwdibl.TextSize=14
lurukwdibl.TextColor3=lurusi6ynt.TextColor
lurukwdibl.TextXAlignment=Enum.TextXAlignment.Left
lurukwdibl.Text=luruswxiis
lurukwdibl.Parent=luru4cb9cs
luru4cb9cs.MouseEnter:Connect(function()
luruk32cp6:Create(luru4cb9cs,TweenInfo.new(0.15),{
BackgroundColor3=Color3.fromRGB(58,62,76),
}):Play()
end)
luru4cb9cs.MouseLeave:Connect(function()
luruk32cp6:Create(luru4cb9cs,TweenInfo.new(0.15),{
BackgroundColor3=lurusi6ynt.ItemColor,
}):Play()
end)
luru4cb9cs.MouseButton1Click:Connect(luruq1b2rm)
return luru4cb9cs
end
local function luruyl989r(lurufc1rbx,lurupyqk9o,lurunzojq4)
local luru2eufaq=Instance.new("Frame")
luru2eufaq.Size=UDim2.new(1,0,0,34)
luru2eufaq.BackgroundColor3=lurusi6ynt.ItemColor
luru2eufaq.Parent=lurupcvkl8
luruuyldus(luru2eufaq,8)
local lurukcy48v=Instance.new("TextLabel")
lurukcy48v.BackgroundTransparency=1
lurukcy48v.Position=UDim2.fromOffset(12,0)
lurukcy48v.Size=UDim2.new(1,-70,1,0)
lurukcy48v.Font=Enum.Font.GothamMedium
lurukcy48v.TextSize=14
lurukcy48v.TextColor3=lurusi6ynt.TextColor
lurukcy48v.TextXAlignment=Enum.TextXAlignment.Left
lurukcy48v.Text=lurufc1rbx
lurukcy48v.Parent=luru2eufaq
local luruqitll5=Instance.new("Frame")
luruqitll5.AnchorPoint=Vector2.new(1,0.5)
luruqitll5.Position=UDim2.new(1,-10,0.5,0)
luruqitll5.Size=UDim2.fromOffset(40,22)
luruqitll5.BackgroundColor3=Color3.fromRGB(60,64,78)
luruqitll5.Parent=luru2eufaq
luruuyldus(luruqitll5,11)
local lurumym1cb=Instance.new("Frame")
lurumym1cb.AnchorPoint=Vector2.new(0,0.5)
lurumym1cb.Position=UDim2.new(0,3,0.5,0)
lurumym1cb.Size=UDim2.fromOffset(16,16)
lurumym1cb.BackgroundColor3=Color3.fromRGB(200,205,220)
lurumym1cb.Parent=luruqitll5
luruuyldus(lurumym1cb,8)
local luruuhqe0y=lurupyqk9o
local function luruzbg073()
luruk32cp6:Create(lurumym1cb,TweenInfo.new(0.18,Enum.EasingStyle.Quad),{
Position=luruuhqe0y and UDim2.new(1,-19,0.5,0)or UDim2.new(0,3,0.5,0),
BackgroundColor3=luruuhqe0y and Color3.new(1,1,1)or Color3.fromRGB(200,205,220),
}):Play()
luruk32cp6:Create(luruqitll5,TweenInfo.new(0.18),{
BackgroundColor3=luruuhqe0y and lurusi6ynt.Accent or Color3.fromRGB(60,64,78),
}):Play()
end
luruzbg073()
local luruhmfggm=Instance.new("TextButton")
luruhmfggm.BackgroundTransparency=1
luruhmfggm.Size=UDim2.fromScale(1,1)
luruhmfggm.Text=""
luruhmfggm.Parent=luru2eufaq
luruhmfggm.MouseButton1Click:Connect(function()
luruuhqe0y=not luruuhqe0y
luruzbg073()
lurunzojq4(luruuhqe0y)
end)
return luru2eufaq
end
luru5d1igs("Ações")
lurucj7x0u("Dizer olá no chat",function()
print("[Painel] Olá! 👋")
end)
lurucj7x0u("Resetar personagem",function()
local luru3uncv9=lurujjyi5j.Character
local lurur4sjfe=luru3uncv9 and luru3uncv9:FindFirstChildOfClass("Humanoid")
if lurur4sjfe then lurur4sjfe.Health=0 end
end)
luru5d1igs("Opções")
luruyl989r("Modo turbo",false,function(luru17qrgj)
print("[Painel] Modo turbo:",luru17qrgj)
end)
luruyl989r("Mostrar FPS",true,function(luruizn5j5)
print("[Painel] Mostrar FPS:",luruizn5j5)
end)
local luru8ss26n,luru4d4v1h,luru4qvawq
luru6absni.InputBegan:Connect(function(lurupu6zzy)
if lurupu6zzy.UserInputType==Enum.UserInputType.MouseButton1
or lurupu6zzy.UserInputType==Enum.UserInputType.Touch then
luru8ss26n=true
luru4d4v1h=lurupu6zzy.Position
luru4qvawq=luru6hhsqm.Position
lurupu6zzy.Changed:Connect(function()
if lurupu6zzy.UserInputState==Enum.UserInputState.End then
luru8ss26n=false
end
end)
end
end)
lurue1jpjo.InputChanged:Connect(function(luruacg1wv)
if luru8ss26n and(luruacg1wv.UserInputType==Enum.UserInputType.MouseMovement
or luruacg1wv.UserInputType==Enum.UserInputType.Touch)then
local lurus0r6yl=luruacg1wv.Position-luru4d4v1h
luru6hhsqm.Position=UDim2.new(
luru4qvawq.X.Scale,luru4qvawq.X.Offset+lurus0r6yl.X,
luru4qvawq.Y.Scale,luru4qvawq.Y.Offset+lurus0r6yl.Y
)
end
end)
local luruqapbju=false
local function luruq8bvp4(luruvqevyt)
luruqapbju=luruvqevyt
if luruvqevyt then
luru6hhsqm.Visible=true
luru6hhsqm.Size=UDim2.fromOffset(0,0)
luruk32cp6:Create(luru6hhsqm,
TweenInfo.new(0.28,Enum.EasingStyle.Back,Enum.EasingDirection.Out),
{Size=lurusi6ynt.Size}
):Play()
else
local lurua9txbl=luruk32cp6:Create(luru6hhsqm,
TweenInfo.new(0.16,Enum.EasingStyle.Quad,Enum.EasingDirection.In),
{Size=UDim2.fromOffset(0,0)}
)
lurua9txbl:Play()
lurua9txbl.Completed:Connect(function()
if not luruqapbju then luru6hhsqm.Visible=false end
end)
end
end
luruczz0e4.MouseButton1Click:Connect(function()
luruq8bvp4(false)
end)
lurue1jpjo.InputBegan:Connect(function(luru2sbgez,luru9ga1k3)
if luru9ga1k3 then return end
if luru2sbgez.KeyCode==lurusi6ynt.ToggleKey then
luruq8bvp4(not luruqapbju)
end
end)