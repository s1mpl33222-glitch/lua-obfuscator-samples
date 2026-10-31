local Library =  {}
function Library:CreateWindow()
local notificationGui = Instance.new("ScreenGui")
notificationGui.Name = "NotificationGui"
notificationGui.Parent = game:GetService("CoreGui")
notificationGui.ZIndexBehavior = Enum.ZIndexBehavior.Global

local notificationWindow = Instance.new("Frame")
notificationWindow.Name = "NotificationWindow"
notificationWindow.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
notificationWindow.BorderColor3 = Color3.fromRGB(0, 0, 0)
notificationWindow.BorderSizePixel = 0
notificationWindow.Position = UDim2.new(1.423, -256,0.986, -74)
notificationWindow.Size = UDim2.fromOffset(343, 91)

local uICorner = Instance.new("UICorner")
uICorner.Name = "UICorner"
uICorner.CornerRadius = UDim.new(0, 12)
uICorner.Parent = notificationWindow

local shadow = Instance.new("Folder")
shadow.Name = "Shadow"

local shadowFrame = Instance.new("Frame")
shadowFrame.Name = "ShadowFrame"
shadowFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
shadowFrame.BackgroundTransparency = 1
shadowFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
shadowFrame.BorderSizePixel = 0
shadowFrame.Size = UDim2.fromScale(1, 1)

local uICorner1 = Instance.new("UICorner")
uICorner1.Name = "UICorner"
uICorner1.CornerRadius = UDim.new(0, 12)
uICorner1.Parent = shadowFrame

local uIStroke = Instance.new("UIStroke")
uIStroke.Name = "UIStroke"
uIStroke.Transparency = 0.95
uIStroke.Parent = shadowFrame

shadowFrame.Parent = shadow

local shadowFrame1 = Instance.new("Frame")
shadowFrame1.Name = "ShadowFrame"
shadowFrame1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
shadowFrame1.BackgroundTransparency = 1
shadowFrame1.BorderColor3 = Color3.fromRGB(0, 0, 0)
shadowFrame1.BorderSizePixel = 0
shadowFrame1.Size = UDim2.fromScale(1, 1)

local uICorner2 = Instance.new("UICorner")
uICorner2.Name = "UICorner"
uICorner2.CornerRadius = UDim.new(0, 12)
uICorner2.Parent = shadowFrame1

local uIStroke1 = Instance.new("UIStroke")
uIStroke1.Name = "UIStroke"
uIStroke1.Thickness = 3
uIStroke1.Transparency = 0.95
uIStroke1.Parent = shadowFrame1

shadowFrame1.Parent = shadow

local shadowFrame2 = Instance.new("Frame")
shadowFrame2.Name = "ShadowFrame"
shadowFrame2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
shadowFrame2.BackgroundTransparency = 1
shadowFrame2.BorderColor3 = Color3.fromRGB(0, 0, 0)
shadowFrame2.BorderSizePixel = 0
shadowFrame2.Size = UDim2.fromScale(1, 1)

local uICorner3 = Instance.new("UICorner")
uICorner3.Name = "UICorner"
uICorner3.CornerRadius = UDim.new(0, 12)
uICorner3.Parent = shadowFrame2

local uIStroke2 = Instance.new("UIStroke")
uIStroke2.Name = "UIStroke"
uIStroke2.Thickness = 5
uIStroke2.Transparency = 0.95
uIStroke2.Parent = shadowFrame2

shadowFrame2.Parent = shadow

local shadowFrame3 = Instance.new("Frame")
shadowFrame3.Name = "ShadowFrame"
shadowFrame3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
shadowFrame3.BackgroundTransparency = 1
shadowFrame3.BorderColor3 = Color3.fromRGB(0, 0, 0)
shadowFrame3.BorderSizePixel = 0
shadowFrame3.Size = UDim2.fromScale(1, 1)

local uICorner4 = Instance.new("UICorner")
uICorner4.Name = "UICorner"
uICorner4.CornerRadius = UDim.new(0, 12)
uICorner4.Parent = shadowFrame3

local uIStroke3 = Instance.new("UIStroke")
uIStroke3.Name = "UIStroke"
uIStroke3.Thickness = 7
uIStroke3.Transparency = 0.95
uIStroke3.Parent = shadowFrame3

shadowFrame3.Parent = shadow

shadow.Parent = notificationWindow

local uIStroke4 = Instance.new("UIStroke")
uIStroke4.Name = "UIStroke"
uIStroke4.Color = Color3.fromRGB(255, 255, 255)
uIStroke4.Thickness = 1.5
uIStroke4.Transparency = 0.9
uIStroke4.Parent = notificationWindow

local frame = Instance.new("Frame")
frame.Name = "Frame"
frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
frame.BackgroundTransparency = 1
frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
frame.BorderSizePixel = 0
frame.Size = UDim2.new(1.19, -70, 1, 0)

local uIPadding = Instance.new("UIPadding")
uIPadding.Name = "UIPadding"
uIPadding.PaddingBottom = UDim.new(0, 10)
uIPadding.PaddingLeft = UDim.new(0, 10)
uIPadding.PaddingRight = UDim.new(0, 10)
uIPadding.PaddingTop = UDim.new(0, 10)
uIPadding.Parent = frame

local frame1 = Instance.new("Frame")
frame1.Name = "Frame"
frame1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
frame1.BackgroundTransparency = 1
frame1.BorderColor3 = Color3.fromRGB(0, 0, 0)
frame1.BorderSizePixel = 0
frame1.Position = UDim2.fromScale(0, 0.19)
frame1.Size = UDim2.fromOffset(44, 45)
frame1.Parent = frame
frame.Parent = notificationWindow
notificationWindow.Parent = notificationGui
local Notification = {}
function Notification:CreateNotification(Mode,ContentText,assetid,Duration)
  notificationWindow:TweenPosition(
    UDim2.new(0.918, -256, 0.973, -74), 
    Enum.EasingDirection.Out, 
    Enum.EasingStyle.Quad, 
    0.5, 
    false
  )
  local imageLabel = Instance.new("ImageLabel")
  imageLabel.Name = "ImageLabel"
  imageLabel.Image = "rbxassetid://"..assetid
  imageLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
  imageLabel.BackgroundTransparency = 1
  imageLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
  imageLabel.BorderSizePixel = 0
  imageLabel.Position = UDim2.fromOffset(299, 26)
  imageLabel.Size = UDim2.new(1, -16, 1, -16)
  imageLabel.Parent = frame1
  
  local tittle = Instance.new("TextLabel")
  tittle.Name = "Tittle"
  tittle.FontFace = Font.new(
    "rbxasset://fonts/families/Ubuntu.json",
    Enum.FontWeight.Bold,
    Enum.FontStyle.Normal
  )
  tittle.Text = Mode
  if string.find(Mode, 'Error') then
    tittle.TextColor3 = Color3.fromRGB(225, 0, 0)
  elseif string.find(Mode, 'Info') then
    tittle.TextColor3 = Color3.fromRGB(79, 157, 236)
  elseif  string.find(Mode, 'Warn') then
    tittle.TextColor3 = Color3.fromRGB(241, 241, 0)
  else
    tittle.TextColor3 = Color3.fromRGB(255, 255, 255)
  end
  tittle.TextSize = 16
  tittle.TextXAlignment = Enum.TextXAlignment.Left
  tittle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
  tittle.BackgroundTransparency = 1
  tittle.BorderColor3 = Color3.fromRGB(0, 0, 0)
  tittle.BorderSizePixel = 0
  tittle.Position = UDim2.fromOffset(-1, -23)
  tittle.Size = UDim2.new(3.16, -40, 0.756, 22)
  tittle.Parent = frame1
  
  local description = Instance.new("TextLabel")
  description.Name = "Description"
  description.FontFace = Font.new(
    "rbxasset://fonts/families/Ubuntu.json",
    Enum.FontWeight.Bold,
    Enum.FontStyle.Normal
  )
  description.Text = ContentText
  if string.find(Mode, 'Error') then
    description.TextColor3 = Color3.fromRGB(225, 0, 0)
  elseif  string.find(Mode, 'Info') then
    description.TextColor3 = Color3.fromRGB(79, 157, 236)
  elseif  string.find(Mode, 'Warn') then
    description.TextColor3 = Color3.fromRGB(241, 241, 0)
  else
    description.TextColor3 = Color3.fromRGB(255, 255, 255)
  end
  description.TextSize = 15
  description.TextWrapped = true
  description.TextXAlignment = Enum.TextXAlignment.Left
  description.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
  description.BackgroundTransparency = 1
  description.BorderColor3 = Color3.fromRGB(0, 0, 0)
  description.BorderSizePixel = 0
  description.Position = UDim2.fromOffset(14, 12)
  description.Size = UDim2.new(7.05, -40, 0.622, 22)
  description.Parent = frame1
  task.wait(Duration)
  notificationWindow:TweenPosition(
      UDim2.new(1.423, -256,0.986, -74), 
      Enum.EasingDirection.Out, 
      Enum.EasingStyle.Quad, 
      0.5, 
      false
  )
  
end
return Notification;
end
return Library;
