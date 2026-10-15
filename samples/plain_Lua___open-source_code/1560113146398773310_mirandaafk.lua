local Players=game:GetService("Players")
local TweenService=game:GetService("TweenService")
local P=Players.LocalPlayer
local PG=P:WaitForChild("PlayerGui")

local old=PG:FindFirstChild("MirandaUpdatedUI")
if old then old:Destroy() end

local GUI=Instance.new("ScreenGui")
GUI.Name="MirandaUpdatedUI"
GUI.ResetOnSpawn=false
GUI.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
GUI.Parent=PG

local Main=Instance.new("CanvasGroup")
Main.AnchorPoint=Vector2.new(.5,.5)
Main.Position=UDim2.fromScale(.5,.5)
Main.Size=UDim2.fromOffset(500,210)
Main.BackgroundColor3=Color3.fromRGB(18,18,22)
Main.BorderSizePixel=0
Main.Active=true
Main.Draggable=true
Main.GroupTransparency=1
Main.Parent=GUI

Instance.new("UICorner",Main).CornerRadius=UDim.new(0,14)

local stroke=Instance.new("UIStroke",Main)
stroke.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
stroke.Color=Color3.fromRGB(220,38,44)
stroke.Thickness=2

local scale=Instance.new("UIScale",Main)
scale.Scale=.92

local Header=Instance.new("Frame",Main)
Header.Position=UDim2.fromOffset(24,18)
Header.Size=UDim2.new(1,-72,0,46)
Header.BackgroundTransparency=1

local Title=Instance.new("TextLabel",Header)
Title.Size=UDim2.new(.58,0,1,0)
Title.BackgroundTransparency=1
Title.RichText=true
Title.Text='<font color="rgb(220,38,44)">MIRANDA</font> <font color="rgb(255,255,255)">HUB</font>'
Title.Font=Enum.Font.GothamBlack
Title.TextSize=23
Title.TextColor3=Color3.new(1,1,1)
Title.TextXAlignment=Enum.TextXAlignment.Left

local Divider=Instance.new("Frame",Header)
Divider.AnchorPoint=Vector2.new(.5,.5)
Divider.Position=UDim2.new(.59,0,.5,0)
Divider.Size=UDim2.fromOffset(2,29)
Divider.BackgroundColor3=Color3.fromRGB(220,38,44)
Divider.BorderSizePixel=0

local Updated=Instance.new("TextLabel",Header)
Updated.Position=UDim2.new(.62,0,0,0)
Updated.Size=UDim2.new(.38,0,1,0)
Updated.BackgroundTransparency=1
Updated.Text="UPDATED!!!"
Updated.TextColor3=Color3.new(1,1,1)
Updated.Font=Enum.Font.GothamBlack
Updated.TextSize=19
Updated.TextXAlignment=Enum.TextXAlignment.Center

local Close=Instance.new("TextButton",Main)
Close.AnchorPoint=Vector2.new(1,0)
Close.Position=UDim2.new(1,-10,0,10)
Close.Size=UDim2.fromOffset(30,30)
Close.BackgroundColor3=Color3.fromRGB(27,27,33)
Close.BorderSizePixel=0
Close.Text="X"
Close.TextColor3=Color3.fromRGB(220,220,225)
Close.Font=Enum.Font.GothamBold
Close.TextSize=11
Close.AutoButtonColor=false
Instance.new("UICorner",Close).CornerRadius=UDim.new(0,8)

local Rail=Instance.new("Frame",Main)
Rail.Position=UDim2.fromOffset(24,67)
Rail.Size=UDim2.new(1,-48,0,2)
Rail.BackgroundColor3=Color3.fromRGB(220,38,44)
Rail.BorderSizePixel=0

local Desc=Instance.new("TextLabel",Main)
Desc.Position=UDim2.fromOffset(28,82)
Desc.Size=UDim2.new(1,-56,0,31)
Desc.BackgroundTransparency=1
Desc.Text="Get the updated version now in our official Discord."
Desc.TextColor3=Color3.fromRGB(178,175,185)
Desc.Font=Enum.Font.GothamMedium
Desc.TextSize=13
Desc.TextXAlignment=Enum.TextXAlignment.Center

local Copy=Instance.new("TextButton",Main)
Copy.AnchorPoint=Vector2.new(.5,0)
Copy.Position=UDim2.new(.5,0,0,126)
Copy.Size=UDim2.fromOffset(330,55)
Copy.BackgroundColor3=Color3.fromRGB(88,101,242)
Copy.BorderSizePixel=0
Copy.AutoButtonColor=false
Copy.Text=""
Instance.new("UICorner",Copy).CornerRadius=UDim.new(0,11)

local DiscordIcon=Instance.new("ImageLabel",Copy)
DiscordIcon.AnchorPoint=Vector2.new(0,.5)
DiscordIcon.Position=UDim2.new(0,70,.5,0)
DiscordIcon.Size=UDim2.fromOffset(30,30)
DiscordIcon.BackgroundTransparency=1
DiscordIcon.Image="rbxassetid://10367063084"
DiscordIcon.ScaleType=Enum.ScaleType.Fit

local CopyText=Instance.new("TextLabel",Copy)
CopyText.Position=UDim2.fromOffset(108,0)
CopyText.Size=UDim2.new(1,-128,1,0)
CopyText.BackgroundTransparency=1
CopyText.Text="COPY DISCORD"
CopyText.TextColor3=Color3.new(1,1,1)
CopyText.Font=Enum.Font.GothamBlack
CopyText.TextSize=15
CopyText.TextXAlignment=Enum.TextXAlignment.Left

local DISCORD="https://discord.gg/8cqVS3DUzu"

Copy.MouseEnter:Connect(function()
	TweenService:Create(Copy,TweenInfo.new(.12),{BackgroundColor3=Color3.fromRGB(100,112,255)}):Play()
end)

Copy.MouseLeave:Connect(function()
	TweenService:Create(Copy,TweenInfo.new(.12),{BackgroundColor3=Color3.fromRGB(88,101,242)}):Play()
end)

Copy.MouseButton1Click:Connect(function()
	if setclipboard then
		setclipboard(DISCORD)
	elseif toclipboard then
		toclipboard(DISCORD)
	end
	CopyText.Text="COPIED!"
	task.delay(1,function()
		if CopyText.Parent then CopyText.Text="COPY DISCORD" end
	end)
end)

Close.MouseButton1Click:Connect(function()
	GUI:Destroy()
end)

TweenService:Create(Main,TweenInfo.new(.28,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{
	GroupTransparency=0
}):Play()
TweenService:Create(scale,TweenInfo.new(.28,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{
	Scale=1
}):Play()
