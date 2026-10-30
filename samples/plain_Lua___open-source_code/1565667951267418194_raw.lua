-- Create GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ProductFakerGui"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = game:GetService("CoreGui")

-- Title Bar (draggable)
local TitleBar = Instance.new("TextButton")
TitleBar.Font = Enum.Font.GothamBold
TitleBar.Text = "Product Faker"
TitleBar.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleBar.TextSize = 16
TitleBar.AutoButtonColor = false
TitleBar.BackgroundColor3 = Color3.fromRGB(46, 46, 46)
TitleBar.BorderSizePixel = 0
TitleBar.Position = UDim2.new(0.35, 0, 0.3, 0)
TitleBar.Size = UDim2.new(0, 252, 0, 35)
TitleBar.Parent = ScreenGui

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 6)
TitleCorner.Parent = TitleBar

-- Minimize Button
local MinButton = Instance.new("TextButton")
MinButton.Font = Enum.Font.GothamBold
MinButton.Text = "-"
MinButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinButton.TextSize = 18
MinButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
MinButton.BorderSizePixel = 0
MinButton.Position = UDim2.new(0, 2, 0, 2.5)
MinButton.Size = UDim2.new(0, 30, 0, 30)
MinButton.Parent = TitleBar

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 6)
MinCorner.Parent = MinButton

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 18
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseButton.BorderSizePixel = 0
CloseButton.Position = UDim2.new(1, -32, 0, 2.5)
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Parent = TitleBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseButton

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.BackgroundColor3 = Color3.fromRGB(46, 46, 46)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0, 0, 1, 2)
MainFrame.Size = UDim2.new(0, 252, 0, 441)
MainFrame.Parent = TitleBar

local FrameCorner = Instance.new("UICorner")
FrameCorner.Parent = MainFrame

local FrameStroke = Instance.new("UIStroke")
FrameStroke.Color = Color3.fromRGB(113, 113, 113)
FrameStroke.Parent = MainFrame

-- Global Buy All Button
local GlobalBuyButton = Instance.new("TextButton")
GlobalBuyButton.Font = Enum.Font.GothamBold
GlobalBuyButton.Text = "Loading..."
GlobalBuyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
GlobalBuyButton.TextSize = 12
GlobalBuyButton.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
GlobalBuyButton.BorderSizePixel = 0
GlobalBuyButton.Position = UDim2.new(0.025, 0, 0.015, 0)
GlobalBuyButton.Size = UDim2.new(0.95, 0, 0, 30)
GlobalBuyButton.Parent = MainFrame

local GlobalCorner = Instance.new("UICorner")
GlobalCorner.CornerRadius = UDim.new(0, 6)
GlobalCorner.Parent = GlobalBuyButton

-- Scrolling Frame
local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
ScrollingFrame.ScrollBarThickness = 5
ScrollingFrame.Active = true
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.BorderSizePixel = 0
ScrollingFrame.Position = UDim2.new(0, 0, 0, 38)
ScrollingFrame.Size = UDim2.new(1, 0, 1, -38)
ScrollingFrame.Parent = MainFrame

local ListLayout = Instance.new("UIListLayout")
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ListLayout.Parent = ScrollingFrame

-- Example Frame Template
local ExampleFrame = Instance.new("Frame")
ExampleFrame.BackgroundTransparency = 1
ExampleFrame.BorderSizePixel = 0
ExampleFrame.Size = UDim2.new(1, 0, 0, 85) -- Slightly taller to fit 3 buttons nicely
ExampleFrame.Visible = false
ExampleFrame.Name = "ExampleFrame"
ExampleFrame.Parent = ScrollingFrame

-- Hover Background
local HoverBg = Instance.new("Frame")
HoverBg.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
HoverBg.BackgroundTransparency = 1
HoverBg.BorderSizePixel = 0
HoverBg.Size = UDim2.new(1, 0, 1, 0)
HoverBg.Name = "HoverBg"
HoverBg.Parent = ExampleFrame

local HoverCorner = Instance.new("UICorner")
HoverCorner.CornerRadius = UDim.new(0, 6)
HoverCorner.Parent = HoverBg

local NameLabel = Instance.new("TextLabel")
NameLabel.Font = Enum.Font.Gotham
NameLabel.Text = "Product Name:"
NameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
NameLabel.TextSize = 14
NameLabel.TextXAlignment = Enum.TextXAlignment.Left
NameLabel.BackgroundTransparency = 1
NameLabel.BorderSizePixel = 0
NameLabel.Position = UDim2.new(0.048, 0, 0.15, 0)
NameLabel.Size = UDim2.new(0, 200, 0, 21)
NameLabel.Name = "NameLabel"
NameLabel.Parent = ExampleFrame

local IDLabel = Instance.new("TextLabel")
IDLabel.Font = Enum.Font.Gotham
IDLabel.Text = "Product ID:"
IDLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
IDLabel.TextSize = 14
IDLabel.TextXAlignment = Enum.TextXAlignment.Left
IDLabel.BackgroundTransparency = 1
IDLabel.BorderSizePixel = 0
IDLabel.Position = UDim2.new(0.048, 0, 0.4, 0)
IDLabel.Size = UDim2.new(0, 108, 0, 21)
IDLabel.Name = "IDLabel"
IDLabel.Parent = ExampleFrame

local PriceLabel = Instance.new("TextLabel")
PriceLabel.Font = Enum.Font.Gotham
PriceLabel.Text = "Product Price:"
PriceLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
PriceLabel.TextSize = 14
PriceLabel.TextXAlignment = Enum.TextXAlignment.Left
PriceLabel.BackgroundTransparency = 1
PriceLabel.BorderSizePixel = 0
PriceLabel.Position = UDim2.new(0.048, 0, 0.65, 0)
PriceLabel.Size = UDim2.new(0, 108, 0, 21)
PriceLabel.Name = "PriceLabel"
PriceLabel.Parent = ExampleFrame

local Divider = Instance.new("Frame")
Divider.BackgroundColor3 = Color3.fromRGB(102, 102, 102)
Divider.BorderSizePixel = 0
Divider.Position = UDim2.new(0, 0, 1, 0)
Divider.Size = UDim2.new(1, 0, 0, 2)
Divider.Name = "Divider"
Divider.Parent = ExampleFrame

local ClickButton = Instance.new("TextButton")
ClickButton.Font = Enum.Font.SourceSans
ClickButton.Text = " "
ClickButton.TextTransparency = 1
ClickButton.BackgroundTransparency = 0.99
ClickButton.BorderSizePixel = 0
ClickButton.Size = UDim2.new(1, 0, 1, 0)
ClickButton.Name = "Click"
ClickButton.Parent = ExampleFrame

-- [RESTORED] Copy ID Button (Top Right)
local CopyButton = Instance.new("TextButton")
CopyButton.Font = Enum.Font.GothamBold
CopyButton.Text = "Copy ID"
CopyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CopyButton.TextSize = 11
CopyButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
CopyButton.BorderSizePixel = 0
CopyButton.Position = UDim2.new(0.65, 0, 0.12, 0)
CopyButton.Size = UDim2.new(0, 80, 0, 20)
CopyButton.Name = "CopyButton"
CopyButton.Parent = ExampleFrame

local CopyCorner = Instance.new("UICorner")
CopyCorner.CornerRadius = UDim.new(0, 4)
CopyCorner.Parent = CopyButton

-- Auto Buy Button (Middle Right)
local AutoBuyButton = Instance.new("TextButton")
AutoBuyButton.Font = Enum.Font.GothamBold
AutoBuyButton.Text = "Auto Buy"
AutoBuyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoBuyButton.TextSize = 11
AutoBuyButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
AutoBuyButton.BorderSizePixel = 0
AutoBuyButton.Position = UDim2.new(0.65, 0, 0.41, 0)
AutoBuyButton.Size = UDim2.new(0, 80, 0, 20)
AutoBuyButton.Name = "AutoBuyButton"
AutoBuyButton.Parent = ExampleFrame

local AutoBuyCorner = Instance.new("UICorner")
AutoBuyCorner.CornerRadius = UDim.new(0, 4)
AutoBuyCorner.Parent = AutoBuyButton

-- Buy Product Button (Bottom Right)
local BuyButton = Instance.new("TextButton")
BuyButton.Font = Enum.Font.GothamBold
BuyButton.Text = "Buy Product"
BuyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
BuyButton.TextSize = 11
BuyButton.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
BuyButton.BorderSizePixel = 0
BuyButton.Position = UDim2.new(0.65, 0, 0.70, 0)
BuyButton.Size = UDim2.new(0, 80, 0, 20)
BuyButton.Name = "BuyButton"
BuyButton.Parent = ExampleFrame

local BuyAllCorner = Instance.new("UICorner")
BuyAllCorner.CornerRadius = UDim.new(0, 4)
BuyAllCorner.Parent = BuyButton

-- Load Developer Products
local MarketplaceService = game:GetService("MarketplaceService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local success, developerProducts = pcall(function()
	return MarketplaceService:GetDeveloperProductsAsync():GetCurrentPage()
end)

if not success then developerProducts = {} end

-- Update Global Button Text
GlobalBuyButton.Text = "Buy All Products (" .. #developerProducts .. ")"

for _, developerProduct in pairs(developerProducts) do
	local newFrame = ExampleFrame:Clone()
	newFrame.Parent = ScrollingFrame
	newFrame.Visible = true

	newFrame.NameLabel.Text = ("Name: " .. (developerProduct.Name or "N/A"))
	newFrame.IDLabel.Text = "ID: " .. (developerProduct.ProductId or "N/A")
	newFrame.PriceLabel.Text = "Price: " .. (developerProduct.PriceInRobux or "N/A")

    -- Hover effects
	local hoverBg = newFrame.HoverBg
	
	newFrame.Click.MouseEnter:Connect(function()
		TweenService:Create(hoverBg, TweenInfo.new(0.2), {BackgroundTransparency = 0.7}):Play()
	end)
	
	newFrame.Click.MouseLeave:Connect(function()
		TweenService:Create(hoverBg, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
	end)

    -- Button hover logic
    local function addButtonHover(button, hoverColor)
		local originalColor = button.BackgroundColor3
		button.MouseEnter:Connect(function()
			TweenService:Create(button, TweenInfo.new(0.15), {BackgroundColor3 = hoverColor}):Play()
		end)
		button.MouseLeave:Connect(function()
			TweenService:Create(button, TweenInfo.new(0.15), {BackgroundColor3 = originalColor}):Play()
		end)
	end
	
    addButtonHover(newFrame.CopyButton, Color3.fromRGB(90, 90, 90))
	addButtonHover(newFrame.AutoBuyButton, Color3.fromRGB(90, 90, 90))
	addButtonHover(newFrame.BuyButton, Color3.fromRGB(180, 70, 70))

    -- Logic: Copy ID
    newFrame.CopyButton.MouseButton1Click:Connect(function()
        setclipboard(tostring(developerProduct.ProductId))
        local oldText = newFrame.CopyButton.Text
        newFrame.CopyButton.Text = "Copied!"
        newFrame.CopyButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
        task.wait(1)
        newFrame.CopyButton.Text = oldText
        newFrame.CopyButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    end)

	-- Logic: Buy Product (Single)
	newFrame.BuyButton.MouseButton1Click:Connect(function()
        local oldText = newFrame.BuyButton.Text
        newFrame.BuyButton.Text = "Buying.."
		MarketplaceService:SignalPromptProductPurchaseFinished(LocalPlayer.UserId, developerProduct.ProductId, true)
        task.wait(1)
        newFrame.BuyButton.Text = oldText
	end)
	
	-- Logic: Auto Buy Toggle
    local autoActive = false
	newFrame.AutoBuyButton.MouseButton1Click:Connect(function()
        autoActive = not autoActive
        
        if autoActive then
            newFrame.AutoBuyButton.Text = "Auto: ON"
		    newFrame.AutoBuyButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
            
            task.spawn(function()
                while autoActive and newFrame.Parent do
                    MarketplaceService:SignalPromptProductPurchaseFinished(LocalPlayer.UserId, developerProduct.ProductId, true)
                    task.wait(0.1)
                end
            end)
        else
            newFrame.AutoBuyButton.Text = "Auto Buy"
		    newFrame.AutoBuyButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        end
	end)
end

-- Global Buy All Logic
GlobalBuyButton.MouseButton1Click:Connect(function()
    local oldText = GlobalBuyButton.Text
    GlobalBuyButton.Text = "Processing..."
    
    for _, developerProduct in pairs(developerProducts) do
        MarketplaceService:SignalPromptProductPurchaseFinished(LocalPlayer.UserId, developerProduct.ProductId, true)
        task.wait(0.01)
    end
    
    GlobalBuyButton.Text = "Done!"
    task.wait(3)
    GlobalBuyButton.Text = oldText
end)

-- Minimize Functionality
MinButton.MouseButton1Click:Connect(function()
	MainFrame.Visible = not MainFrame.Visible
    MinButton.Text = MainFrame.Visible and "-" or "+"
end)

-- Close Button Functionality
CloseButton.MouseButton1Click:Connect(function()
	ScreenGui:Destroy()
end)

-- Dragging Functionality
local dragging = false
local dragInput, mousePos, framePos

TitleBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		mousePos = input.Position
		framePos = TitleBar.Position
		
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

TitleBar.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		dragInput = input
	end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - mousePos
		TitleBar.Position = UDim2.new(
			framePos.X.Scale, 
			framePos.X.Offset + delta.X, 
			framePos.Y.Scale, 
			framePos.Y.Offset + delta.Y
		)
	end
end)