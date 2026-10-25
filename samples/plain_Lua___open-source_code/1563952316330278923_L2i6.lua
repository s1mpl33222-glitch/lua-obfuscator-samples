local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer

local OpenCase = nil
local config = {Cases = {}}

pcall(function()
OpenCase = RS.Remotes.Cases.OpenCase
end)

pcall(function()
config = require(RS.Datas.CaseConfig)
end)

if player.PlayerGui:FindFirstChild("CaseMenu") then
player.PlayerGui.CaseMenu:Destroy()
end

local gui = Instance.new("ScreenGui")
gui.Name = "CaseMenu"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = player.PlayerGui

-- Discord en haut
local discordTop = Instance.new("TextLabel")
discordTop.Size = UDim2.new(1, 0, 0, 22)
discordTop.Position = UDim2.new(0, 0, 0, 8)
discordTop.BackgroundTransparency = 1
discordTop.Text = "discord.gg/YYjbEynDe"
discordTop.TextColor3 = Color3.fromRGB(255, 105, 180)
discordTop.Font = Enum.Font.GothamBold
discordTop.TextSize = 14
discordTop.TextXAlignment = Enum.TextXAlignment.Center
discordTop.ZIndex = 10
discordTop.Parent = gui

-- Fenêtre principale
local win = Instance.new("Frame")
win.Size = UDim2.new(0, 240, 0, 340)
win.Position = UDim2.new(0.5, -120, 0.5, -170)
win.BackgroundColor3 = Color3.fromRGB(12, 10, 14)
win.BorderSizePixel = 0
win.Active = true
win.Parent = gui

Instance.new("UICorner", win).CornerRadius = UDim.new(0, 10)

local winStroke = Instance.new("UIStroke", win)
winStroke.Color = Color3.fromRGB(255, 105, 180)
winStroke.Thickness = 1.5

-- Barre du haut (déplacer)
local top = Instance.new("Frame")
top.Size = UDim2.new(1, 0, 0, 42)
top.BackgroundTransparency = 1
top.Parent = win

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -20, 0, 22)
title.Position = UDim2.new(0, 12, 0, 4)
title.BackgroundTransparency = 1
title.Text = "case opener"
title.TextColor3 = Color3.fromRGB(255, 140, 200)
title.Font = Enum.Font.GothamBold
title.TextSize = 15
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = top

local credit = Instance.new("TextLabel")
credit.Size = UDim2.new(1, -20, 0, 14)
credit.Position = UDim2.new(0, 12, 0, 24)
credit.BackgroundTransparency = 1
credit.Text = "By L2i6"
credit.TextColor3 = Color3.fromRGB(255, 105, 180)
credit.Font = Enum.Font.GothamMedium
credit.TextSize = 11
credit.TextXAlignment = Enum.TextXAlignment.Left
credit.Parent = top

local sep = Instance.new("Frame")
sep.Size = UDim2.new(1, -24, 0, 1)
sep.Position = UDim2.new(0, 12, 0, 44)
sep.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
sep.BorderSizePixel = 0
sep.Parent = win

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -24, 1, -95)
scroll.Position = UDim2.new(0, 12, 0, 52)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 3
scroll.ScrollBarImageColor3 = Color3.fromRGB(255, 105, 180)
scroll.CanvasSize = UDim2.new()
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroll.ScrollBarImageTransparency = 0.4
scroll.Parent = win

local list = Instance.new("UIListLayout", scroll)
list.Padding = UDim.new(0, 5)
list.SortOrder = Enum.SortOrder.LayoutOrder

-- Création des cases (sans G5 et Hardware)
if config and config.Cases then
for i, c in pairs(config.Cases) do
local titleText = string.lower(tostring(c.Title or c.Name or ""))

-- On ignore G5 Crate et Hardware Crate  
	if not (titleText:find("g5") or titleText:find("hardware")) then  
		local btn = Instance.new("TextButton")  
		btn.Size = UDim2.new(1, 0, 0, 42)  
		btn.BackgroundColor3 = Color3.fromRGB(22, 18, 24)  
		btn.Text = ""  
		btn.AutoButtonColor = false  
		btn.LayoutOrder = i  
		btn.Parent = scroll  

		Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 7)  

		local stroke = Instance.new("UIStroke", btn)  
		stroke.Color = Color3.fromRGB(60, 40, 55)  
		stroke.Thickness = 1  

		local nameLbl = Instance.new("TextLabel")  
		nameLbl.Size = UDim2.new(1, -16, 0, 20)  
		nameLbl.Position = UDim2.new(0, 10, 0, 3)  
		nameLbl.BackgroundTransparency = 1  
		nameLbl.Text = c.Title or "Case"  
		nameLbl.TextColor3 = Color3.fromRGB(255, 230, 245)  
		nameLbl.Font = Enum.Font.GothamBold  
		nameLbl.TextSize = 12  
		nameLbl.TextXAlignment = Enum.TextXAlignment.Left  
		nameLbl.Parent = btn  

		local priceLbl = Instance.new("TextLabel")  
		priceLbl.Size = UDim2.new(1, -16, 0, 14)  
		priceLbl.Position = UDim2.new(0, 10, 0, 23)  
		priceLbl.BackgroundTransparency = 1  
		priceLbl.Text = "$" .. tostring(c.Price or 0)  
		priceLbl.TextColor3 = Color3.fromRGB(255, 120, 190)  
		priceLbl.Font = Enum.Font.GothamMedium  
		priceLbl.TextSize = 11  
		priceLbl.TextXAlignment = Enum.TextXAlignment.Left  
		priceLbl.Parent = btn  

		btn.MouseEnter:Connect(function()  
			TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 25, 38)}):Play()  
			TweenService:Create(stroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(255, 105, 180)}):Play()  
		end)  

		btn.MouseLeave:Connect(function()  
			TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(22, 18, 24)}):Play()  
			TweenService:Create(stroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(60, 40, 55)}):Play()  
		end)  

		btn.MouseButton1Click:Connect(function()  
			if OpenCase then  
				pcall(function()  
					OpenCase:InvokeServer(c.Name, c.Price)  
				end)  
			end  
		end)  
	end  
end

end

-- Bouton FERMER
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(1, -24, 0, 32)
closeBtn.Position = UDim2.new(0, 12, 1, -42)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
closeBtn.Text = "Fermer le menu"
closeBtn.TextColor3 = Color3.fromRGB(20, 10, 15)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 13
closeBtn.AutoButtonColor = false
closeBtn.Parent = win

Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 7)

closeBtn.MouseEnter:Connect(function()
TweenService:Create(closeBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(255, 140, 200)}):Play()
end)
closeBtn.MouseLeave:Connect(function()
TweenService:Create(closeBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(255, 105, 180)}):Play()
end)

-- Bouton OUVRIR
local openBtn = Instance.new("TextButton")
openBtn.Size = UDim2.new(0, 130, 0, 34)
openBtn.Position = UDim2.new(0, 20, 0.5, -17)
openBtn.BackgroundColor3 = Color3.fromRGB(12, 10, 14)
openBtn.Text = "Ouvrir le menu"
openBtn.TextColor3 = Color3.fromRGB(255, 140, 200)
openBtn.Font = Enum.Font.GothamBold
openBtn.TextSize = 13
openBtn.Visible = false
openBtn.AutoButtonColor = false
openBtn.Parent = gui

Instance.new("UICorner", openBtn).CornerRadius = UDim.new(0, 8)

local openStroke = Instance.new("UIStroke", openBtn)
openStroke.Color = Color3.fromRGB(255, 105, 180)
openStroke.Thickness = 1.5

openBtn.MouseEnter:Connect(function()
TweenService:Create(openBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(40, 25, 38)}):Play()
end)
openBtn.MouseLeave:Connect(function()
TweenService:Create(openBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(12, 10, 14)}):Play()
end)

local function closeMenu()
win.Visible = false
openBtn.Visible = true
end

local function openMenu()
win.Visible = true
openBtn.Visible = false
end

closeBtn.MouseButton1Click:Connect(closeMenu)
openBtn.MouseButton1Click:Connect(openMenu)

-- Drag fenêtre
local dragging, dragInput, dragStart, startPos

top.InputBegan:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
dragging = true
dragStart = input.Position
startPos = win.Position

input.Changed:Connect(function()  
		if input.UserInputState == Enum.UserInputState.End then  
			dragging = false  
		end  
	end)  
end

end)

top.InputChanged:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
dragInput = input
end
end)

UIS.InputChanged:Connect(function(input)
if input == dragInput and dragging then
local delta = input.Position - dragStart
win.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end
end)

-- Drag bouton Ouvrir
local openDragging, openDragInput, openDragStart, openStartPos

openBtn.InputBegan:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
openDragging = true
openDragStart = input.Position
openStartPos = openBtn.Position

input.Changed:Connect(function()  
		if input.UserInputState == Enum.UserInputState.End then  
			openDragging = false  
		end  
	end)  
end

end)

openBtn.InputChanged:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
openDragInput = input
end
end)

UIS.InputChanged:Connect(function(input)
if input == openDragInput and openDragging then
local delta = input.Position - openDragStart
openBtn.Position = UDim2.new(openStartPos.X.Scale, openStartPos.X.Offset + delta.X, openStartPos.Y.Scale, openStartPos.Y.Offset + delta.Y)
end
end)