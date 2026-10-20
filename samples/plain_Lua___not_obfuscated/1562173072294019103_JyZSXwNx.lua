local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local LP = Players.LocalPlayer
local Cam = workspace.CurrentCamera
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local conns, esp, drones = {}, {}, {}
local pMode, dMode, maxDist = 1, 3, 1000
local isOptimized, mellMode = false, false
local flyMode, speedMode, jumpMode, spinEnabled = false, false, false, false
local antiAfkEnabled, wmEnabled = false, false
local weatherMode = 0
local espColorMode = 1
local espColors = {
    Color3.fromRGB(255, 50, 50), Color3.fromRGB(50, 255, 50), Color3.fromRGB(50, 150, 255), Color3.fromRGB(255, 255, 50)
}
local colorNames = {"Красный", "Зеленый", "Синий", "Желтый"}

local flySpeed, walkSpeedVal = 50, 50
local currentLang = "ru"
local fovMode = false
local fovValue = 70
local timeValue = 14
local mellImgId = "rbxassetid://133184124481935"
local tgLink = "https://t.me/+Kqqs0F6TAcdiMzI6"

local aimEnabled, aimTargetMode, aimFov, aimVisibleOnly = false, 1, 200, false
local aimPrediction = 0.1
local aimCurrentTarget = nil
local extTPEnabled = false

local lang = {
    ru = {v="Визуал", m="Движение", f="Бой", mel="Меллстрой", misc="Разное", l="Язык", s="Настройки", inf="Инфо", p="Люди: ", d="Дроны: ", dist="Дистанция: ", opt="Оптимизация: ", time="Время: ", fly="Полет: ", spd="Скорость: ", fly_spd="Скор. полета: ", jmp="Прыжок: ", spin="Спин: ", warn="Включите ESP Дронов!", del="УДАЛИТЬ СКРИПТ", on="ВКЛ", off="ВЫКЛ", move_title="Движение", world_title="Мир / World", cam_title="Камера", fov="FOV: ", fight_title="Бой / Fight", esp_title="ESP", sa="Aimlock: ", sa_t="Цель: ", sa_fov="FOV Aim: ", sa_pr="Предикт: ", sa_vis="Только видимые: ", t_people="Люди", t_drones="Дроны", t_both="Оба", cfg_name="Имя конфига:", cfg_save="СОХРАНИТЬ", cfg_load="ЗАГРУЗИТЬ", cfg_saved="Сохранено!", cfg_loaded="Загружено!", cfg_err="Ошибка!", tp_title="Телепорт", tp_plr="ТП к ближ. игроку", tp_drn="ТП к ближ. дрону", ext_tp="Внешняя ТП: ", ext_tp_info="(Только к людям)", other_title="Прочее", anti_afk="Anti-AFK: ", color="Цвет: ", wm="Водяной знак (FPS): ", weather="Погода: ", w_off="ВЫКЛ", w_snow="СНЕГ", w_rain="ДОЖДЬ", plist="Игроки (ТП):", refill="Пополнить дроны (ТП)", kf="Лог смертей: ", info_title="Мой Телеграм:", copy_msg="Ссылка скопирована!"},
    en = {v="Visuals", m="Movement", f="Fight", mel="Mellstroy", misc="Misc", l="Language", s="Settings", inf="Info", p="People: ", d="Drones: ", dist="Distance: ", opt="Optimization: ", time="Time: ", fly="Fly: ", spd="Speed: ", fly_spd="Fly Speed: ", jmp="Jump: ", spin="Spin: ", warn="Enable Drone ESP!", del="DELETE SCRIPT", on="ON", off="OFF", move_title="Movement", world_title="World", cam_title="Camera", fov="FOV: ", fight_title="Fight", esp_title="ESP", sa="Aimlock: ", sa_t="Target: ", sa_fov="FOV Aim: ", sa_pr="Predict: ", sa_vis="Only Visible: ", t_people="People", t_drones="Drones", t_both="Both", cfg_name="Config Name:", cfg_save="SAVE", cfg_load="LOAD", cfg_saved="Saved!", cfg_loaded="Loaded!", cfg_err="Error!", tp_title="Teleport", tp_plr="TP to nearest player", tp_drn="TP to nearest drone", ext_tp="External TP: ", ext_tp_info="(People only)", other_title="Other", anti_afk="Anti-AFK: ", color="Color: ", wm="Watermark (FPS): ", weather="Weather: ", w_off="OFF", w_snow="SNOW", w_rain="RAIN", plist="Players (TP):", refill="Refill drones (TP)", kf="Kill Feed: ", info_title="My Telegram:", copy_msg="Link copied!"}
}
local function L(k) return lang[currentLang][k] end

local function create(i, p, pa) 
    local o = Instance.new(i)
    for k, v in pairs(p) do o[k] = v end
    o.Parent = pa
    return o 
end

local loadGui = create("ScreenGui", {Name="LoadGui", ResetOnSpawn=false, IgnoreGuiInset=true}, CoreGui)
local loadFrame = create("Frame", {Size=UDim2.new(1,0,1,0), BackgroundColor3=Color3.fromRGB(15,15,20), BorderSizePixel=0, ZIndex=100}, loadGui)
create("TextLabel", {Size=UDim2.new(1,0,0,60), Position=UDim2.new(0,0,0.5,-30), BackgroundTransparency=1, Text="pidorashub", TextColor3=Color3.fromRGB(255,255,255), Font=Enum.Font.GothamBold, TextSize=48, ZIndex=101}, loadFrame)
create("TextLabel", {Size=UDim2.new(1,0,0,20), Position=UDim2.new(0,0,0.5,30), BackgroundTransparency=1, Text="Загрузка модулей...", TextColor3=Color3.fromRGB(150,150,150), Font=Enum.Font.Gotham, TextSize=16, ZIndex=101}, loadFrame)

local gui = create("ScreenGui", {Name="ESP_GUI", ResetOnSpawn=false, Enabled=false, IgnoreGuiInset=true}, CoreGui)
local watermark = create("TextLabel", {Size=UDim2.new(0,200,0,20), Position=UDim2.new(0.5,-100,0,10), BackgroundTransparency=1, Text="pidorashub | FPS: 60", TextColor3=Color3.fromRGB(255,255,255), Font=Enum.Font.GothamBold, TextSize=14, TextXAlignment=Enum.TextXAlignment.Center, ZIndex=100, Visible=false}, gui)
local killFeedFrame = create("Frame", {Size=UDim2.new(0,300,0,200), Position=UDim2.new(1,-20,0,60), AnchorPoint=Vector2.new(1,0), BackgroundTransparency=1, ZIndex=90}, gui)
create("UIListLayout", {Padding=UDim.new(0,5), SortOrder=Enum.SortOrder.LayoutOrder, HorizontalAlignment=Enum.HorizontalAlignment.Right, VerticalAlignment=Enum.VerticalAlignment.Top}, killFeedFrame)

task.spawn(function()
    task.wait(3)
    pcall(function() if loadGui then loadGui:Destroy() end end)
    gui.Enabled = true
end)

local main = create("Frame", {Size=UDim2.new(0,360,0,280), Position=UDim2.new(0.5,0,0.5,0), AnchorPoint=Vector2.new(0.5,0.5), BackgroundColor3=Color3.fromRGB(20,20,25), BorderSizePixel=0, ClipsDescendants=true}, gui)
create("UICorner", {CornerRadius=UDim.new(0,10)}, main)
create("UIStroke", {Color=Color3.fromRGB(60,60,70), Thickness=1.5}, main)

local topBar = create("Frame", {Size=UDim2.new(1,0,0,35), BackgroundColor3=Color3.fromRGB(30,30,40), BorderSizePixel=0}, main)
create("UICorner", {CornerRadius=UDim.new(0,10)}, topBar)
create("Frame", {Size=UDim2.new(1,0,0,15), Position=UDim2.new(0,0,1,-15), BackgroundColor3=Color3.fromRGB(30,30,40), BorderSizePixel=0}, topBar)
create("TextLabel", {Size=UDim2.new(1,-40,1,0), Position=UDim2.new(0,15,0,0), BackgroundTransparency=1, Text="pidorashub", TextColor3=Color3.fromRGB(255,255,255), Font=Enum.Font.GothamBold, TextSize=14, TextXAlignment=Enum.TextXAlignment.Left}, topBar)
local closeBtn = create("TextButton", {Size=UDim2.new(0,25,0,25), Position=UDim2.new(1,-30,0,5), BackgroundTransparency=1, Text="-", TextColor3=Color3.fromRGB(255,100,100), Font=Enum.Font.GothamBold, TextSize=20}, topBar)

local menuBtn = create("TextButton", {Size=UDim2.new(0,65,0,65), Position=UDim2.new(0,20,0.5,-32), BackgroundTransparency=1, Text="", BorderSizePixel=0, Visible=false, ZIndex=100, ClipsDescendants=true}, gui)
create("UICorner", {CornerRadius=UDim.new(0,12)}, menuBtn)
create("UIStroke", {Color=Color3.fromRGB(0,200,255), Thickness=2.5}, menuBtn)
local menuImg = create("ImageLabel", {Size=UDim2.new(1,0,1,0), Position=UDim2.new(0,0,0,0), BackgroundTransparency=1, Image=mellImgId, ScaleType=Enum.ScaleType.Crop, ZIndex=1}, menuBtn)
create("UICorner", {CornerRadius=UDim.new(0,12)}, menuImg)
local menuTxt = create("TextLabel", {Size=UDim2.new(1,0,1,0), BackgroundTransparency=1, Text="PHub", TextColor3=Color3.new(1,1,1), Font=Enum.Font.GothamBlack, TextSize=16, ZIndex=2, TextStrokeTransparency=0, TextStrokeColor3=Color3.new(0,0,0)}, menuBtn)

local sideBar = create("Frame", {Size=UDim2.new(0,90,1,-35), Position=UDim2.new(0,0,0,35), BackgroundColor3=Color3.fromRGB(25,25,30), BorderSizePixel=0}, main)
create("UICorner", {CornerRadius=UDim.new(0,10)}, sideBar)
create("UIListLayout", {Padding=UDim.new(0,2), SortOrder=Enum.SortOrder.LayoutOrder, HorizontalAlignment=Enum.HorizontalAlignment.Center}, sideBar)
local contentArea = create("Frame", {Size=UDim2.new(1,-90,1,-35), Position=UDim2.new(0,90,0,35), BackgroundColor3=Color3.fromRGB(20,20,25), BorderSizePixel=0}, main)
create("UICorner", {CornerRadius=UDim.new(0,10)}, contentArea)

local function createTab(name, ord) 
    return create("TextButton", {Size=UDim2.new(1,-10,0,28), LayoutOrder=ord, BackgroundColor3=Color3.fromRGB(40,40,50), Text=name, TextColor3=Color3.fromRGB(200,200,200), Font=Enum.Font.GothamBold, TextSize=11, BorderSizePixel=0}, sideBar) 
end
local tabVis = createTab("Visuals", 1); create("UICorner", {CornerRadius=UDim.new(0,6)}, tabVis)
local tabMove = createTab("Movement", 2); create("UICorner", {CornerRadius=UDim.new(0,6)}, tabMove)
local tabFight = createTab("Fight", 3); create("UICorner", {CornerRadius=UDim.new(0,6)}, tabFight)
local tabMell = createTab("Mellstroy", 4); create("UICorner", {CornerRadius=UDim.new(0,6)}, tabMell)
local tabMisc = createTab("Misc", 5); create("UICorner", {CornerRadius=UDim.new(0,6)}, tabMisc)
local tabLang = createTab("Language", 6); create("UICorner", {CornerRadius=UDim.new(0,6)}, tabLang)
local tabSet = createTab("Settings", 7); create("UICorner", {CornerRadius=UDim.new(0,6)}, tabSet)
local tabInfo = createTab("Info", 8); create("UICorner", {CornerRadius=UDim.new(0,6)}, tabInfo)

local pageVis = create("ScrollingFrame", {Size=UDim2.new(1,0,1,0), BackgroundTransparency=1, BorderSizePixel=0, ScrollBarThickness=2, CanvasSize=UDim2.new(0,0,0,0), AutomaticCanvasSize=Enum.AutomaticSize.Y, Visible=true}, contentArea)
create("UIListLayout", {Padding=UDim.new(0,10), SortOrder=Enum.SortOrder.LayoutOrder, HorizontalAlignment=Enum.HorizontalAlignment.Center, VerticalAlignment=Enum.VerticalAlignment.Top}, pageVis)
local pageMove = create("ScrollingFrame", {Size=UDim2.new(1,0,1,0), BackgroundTransparency=1, BorderSizePixel=0, ScrollBarThickness=2, CanvasSize=UDim2.new(0,0,0,0), AutomaticCanvasSize=Enum.AutomaticSize.Y, Visible=false}, contentArea)
create("UIListLayout", {Padding=UDim.new(0,10), SortOrder=Enum.SortOrder.LayoutOrder, HorizontalAlignment=Enum.HorizontalAlignment.Center, VerticalAlignment=Enum.VerticalAlignment.Top}, pageMove)
local pageFight = create("ScrollingFrame", {Size=UDim2.new(1,0,1,0), BackgroundTransparency=1, BorderSizePixel=0, ScrollBarThickness=2, CanvasSize=UDim2.new(0,0,0,0), AutomaticCanvasSize=Enum.AutomaticSize.Y, Visible=false}, contentArea)
create("UIListLayout", {Padding=UDim.new(0,10), SortOrder=Enum.SortOrder.LayoutOrder, HorizontalAlignment=Enum.HorizontalAlignment.Center, VerticalAlignment=Enum.VerticalAlignment.Top}, pageFight)
local pageMell = create("Frame", {Size=UDim2.new(1,0,1,0), BackgroundTransparency=1, Visible=false}, contentArea)
local pageMisc = create("ScrollingFrame", {Size=UDim2.new(1,0,1,0), BackgroundTransparency=1, BorderSizePixel=0, ScrollBarThickness=2, CanvasSize=UDim2.new(0,0,0,0), AutomaticCanvasSize=Enum.AutomaticSize.Y, Visible=false}, contentArea)
create("UIListLayout", {Padding=UDim.new(0,10), SortOrder=Enum.SortOrder.LayoutOrder, HorizontalAlignment=Enum.HorizontalAlignment.Center, VerticalAlignment=Enum.VerticalAlignment.Top}, pageMisc)
local pageLang = create("Frame", {Size=UDim2.new(1,0,1,0), BackgroundTransparency=1, Visible=false}, contentArea)
local pageSet = create("ScrollingFrame", {Size=UDim2.new(1,0,1,0), BackgroundTransparency=1, BorderSizePixel=0, ScrollBarThickness=2, CanvasSize=UDim2.new(0,0,0,0), AutomaticCanvasSize=Enum.AutomaticSize.Y, Visible=false}, contentArea)
create("UIListLayout", {Padding=UDim.new(0,10), SortOrder=Enum.SortOrder.LayoutOrder, HorizontalAlignment=Enum.HorizontalAlignment.Center, VerticalAlignment=Enum.VerticalAlignment.Top}, pageSet)

local pageInfo = create("Frame", {Size=UDim2.new(1,0,1,0), BackgroundTransparency=1, Visible=false}, contentArea)

local function switchTab(btn, page)
    for _, b in pairs({tabVis, tabMove, tabFight, tabMell, tabMisc, tabLang, tabSet, tabInfo}) do b.BackgroundColor3 = Color3.fromRGB(40,40,50); b.TextColor3 = Color3.fromRGB(200,200,200) end
    for _, p in pairs({pageVis, pageMove, pageFight, pageMell, pageMisc, pageLang, pageSet, pageInfo}) do p.Visible = false end
    btn.BackgroundColor3 = Color3.fromRGB(0,150,255); btn.TextColor3 = Color3.new(1,1,1); page.Visible = true
end

tabVis.MouseButton1Click:Connect(function() switchTab(tabVis, pageVis) end)
tabMove.MouseButton1Click:Connect(function() switchTab(tabMove, pageMove) end)
tabFight.MouseButton1Click:Connect(function() switchTab(tabFight, pageFight) end)
tabMell.MouseButton1Click:Connect(function() switchTab(tabMell, pageMell) end)
tabMisc.MouseButton1Click:Connect(function() switchTab(tabMisc, pageMisc) end)
tabLang.MouseButton1Click:Connect(function() switchTab(tabLang, pageLang) end)
tabSet.MouseButton1Click:Connect(function() switchTab(tabSet, pageSet) end)
tabInfo.MouseButton1Click:Connect(function() switchTab(tabInfo, pageInfo) end)

-- VISUALS
local lblEsp = create("TextLabel", {Size=UDim2.new(0,220,0,20), BackgroundTransparency=1, Text="ESP", TextColor3=Color3.new(1,1,1), Font=Enum.Font.GothamBold, TextSize=14, LayoutOrder=1}, pageVis)
local grid = create("Frame", {Size=UDim2.new(0,230,0,30), BackgroundTransparency=1, LayoutOrder=2}, pageVis)
create("UIGridLayout", {CellSize=UDim2.new(0,110,0,30), CellPadding=UDim2.new(0,10,0,10), SortOrder=Enum.SortOrder.LayoutOrder, HorizontalAlignment=Enum.HorizontalAlignment.Center}, grid)
local btnP = create("TextButton", {LayoutOrder=1, BackgroundColor3=Color3.fromRGB(0,150,80), Text="Люди: 3D", TextColor3=Color3.new(1,1,1), Font=Enum.Font.GothamBold, TextSize=11, BorderSizePixel=0}, grid); create("UICorner", {CornerRadius=UDim.new(0,6)}, btnP)
local btnD = create("TextButton", {LayoutOrder=2, BackgroundColor3=Color3.fromRGB(100,100,100), Text="Дроны: ВЫКЛ", TextColor3=Color3.new(1,1,1), Font=Enum.Font.GothamBold, TextSize=11, BorderSizePixel=0}, grid); create("UICorner", {CornerRadius=UDim.new(0,6)}, btnD)
local btnEspColor = create("TextButton", {Size=UDim2.new(0,220,0,30), BackgroundColor3=Color3.fromRGB(50,50,60), Text="Цвет: Красный", TextColor3=Color3.new(1,1,1), Font=Enum.Font.GothamBold, TextSize=12, BorderSizePixel=0, LayoutOrder=3}, pageVis); create("UICorner", {CornerRadius=UDim.new(0,6)}, btnEspColor)
local lblDist = create("TextLabel", {Size=UDim2.new(0,220,0,20), BackgroundTransparency=1, Text="Дистанция: 1000м", TextColor3=Color3.fromRGB(200,200,200), Font=Enum.Font.Gotham, TextSize=12, TextXAlignment=Enum.TextXAlignment.Left, LayoutOrder=4}, pageVis)
local sliderBg = create("Frame", {Size=UDim2.new(0,220,0,6), BackgroundColor3=Color3.fromRGB(60,60,70), BorderSizePixel=0, LayoutOrder=5}, pageVis); create("UICorner", {CornerRadius=UDim.new(0,3)}, sliderBg)
local sliderFill = create("Frame", {Size=UDim2.new(1000/2000,0,1,0), BackgroundColor3=Color3.fromRGB(0,150,255), BorderSizePixel=0}, sliderBg); create("UICorner", {CornerRadius=UDim.new(0,3)}, sliderFill)
local sliderKnob = create("Frame", {Size=UDim2.new(0,16,0,16), Position=UDim2.new(1000/2000,-8,0.5,-8), BackgroundColor3=Color3.new(1,1,1), BorderSizePixel=0, ZIndex=2}, sliderBg); create("UICorner", {CornerRadius=UDim.new(0,8)}, sliderKnob)
local lblCam = create("TextLabel", {Size=UDim2.new(0,220,0,20), BackgroundTransparency=1, Text="Камера", TextColor3=Color3.new(1,1,1), Font=Enum.Font.GothamBold, TextSize=14, LayoutOrder=6}, pageVis)
local btnFov = create("TextButton", {Size=UDim2.new(0,220,0,30), BackgroundColor3=Color3.fromRGB(50,50,60), Text="FOV: ВЫКЛ", TextColor3=Color3.new(1,1,1), Font=Enum.Font.GothamBold, TextSize=12, BorderSizePixel=0, LayoutOrder=7}, pageVis); create("UICorner", {CornerRadius=UDim.new(0,6)}, btnFov)
local fovSliderBg = create("Frame", {Size=UDim2.new(0,220,0,6), BackgroundColor3=Color3.fromRGB(60,60,70), BorderSizePixel=0, Visible=false, LayoutOrder=8}, pageVis); create("UICorner", {CornerRadius=UDim.new(0,3)}, fovSliderBg)
local fovSliderFill = create("Frame", {Size=UDim2.new(0/50,0,1,0), BackgroundColor3=Color3.fromRGB(0,150,255), BorderSizePixel=0}, fovSliderBg); create("UICorner", {CornerRadius=UDim.new(0,3)}, fovSliderFill)
local fovSliderKnob = create("Frame", {Size=UDim2.new(0,16,0,16), Position=UDim2.new(0/50,-8,0.5,-8), BackgroundColor3=Color3.new(1,1,1), BorderSizePixel=0, ZIndex=2}, fovSliderBg); create("UICorner", {CornerRadius=UDim.new(0,8)}, fovSliderKnob)
local lblWorld = create("TextLabel", {Size=UDim2.new(0,220,0,20), BackgroundTransparency=1, Text="Мир / World", TextColor3=Color3.new(1,1,1), Font=Enum.Font.GothamBold, TextSize=14, LayoutOrder=9}, pageVis)
local optBtn = create("TextButton", {Size=UDim2.new(0,220,0,30), BackgroundColor3=Color3.fromRGB(50,50,60), Text="Оптимизация: ВЫКЛ", TextColor3=Color3.new(1,1,1), Font=Enum.Font.GothamBold, TextSize=12, BorderSizePixel=0, LayoutOrder=10}, pageVis); create("UICorner", {CornerRadius=UDim.new(0,6)}, optBtn)
local timeLabel = create("TextLabel", {Size=UDim2.new(0,220,0,20), BackgroundTransparency=1, Text="Время: 14:00", TextColor3=Color3.fromRGB(200,200,200), Font=Enum.Font.Gotham, TextSize=12, TextXAlignment=Enum.TextXAlignment.Left, LayoutOrder=11}, pageVis)
local timeSliderBg = create("Frame", {Size=UDim2.new(0,220,0,6), BackgroundColor3=Color3.fromRGB(60,60,70), BorderSizePixel=0, LayoutOrder=12}, pageVis); create("UICorner", {CornerRadius=UDim.new(0,3)}, timeSliderBg)
local timeSliderFill = create("Frame", {Size=UDim2.new(14/24,0,1,0), BackgroundColor3=Color3.fromRGB(255,200,0), BorderSizePixel=0}, timeSliderBg); create("UICorner", {CornerRadius=UDim.new(0,3)}, timeSliderFill)
local timeSliderKnob = create("Frame", {Size=UDim2.new(0,16,0,16), Position=UDim2.new(14/24,-8,0.5,-8), BackgroundColor3=Color3.new(1,1,1), BorderSizePixel=0, ZIndex=2}, timeSliderBg); create("UICorner", {CornerRadius=UDim.new(0,8)}, timeSliderKnob)
local btnWeather = create("TextButton", {Size=UDim2.new(0,220,0,30), BackgroundColor3=Color3.fromRGB(50,50,60), Text="Погода: ВЫКЛ", TextColor3=Color3.new(1,1,1), Font=Enum.Font.GothamBold, TextSize=12, BorderSizePixel=0, LayoutOrder=13}, pageVis); create("UICorner", {CornerRadius=UDim.new(0,6)}, btnWeather)

-- MOVEMENT
local lblMove = create("TextLabel", {Size=UDim2.new(0,220,0,20), BackgroundTransparency=1, Text="Движение", TextColor3=Color3.new(1,1,1), Font=Enum.Font.GothamBold, TextSize=14, LayoutOrder=1}, pageMove)
local btnFly = create("TextButton", {Size=UDim2.new(0,220,0,30), BackgroundColor3=Color3.fromRGB(100,100,100), Text="Полет: ВЫКЛ", TextColor3=Color3.new(1,1,1), Font=Enum.Font.GothamBold, TextSize=12, BorderSizePixel=0, LayoutOrder=2}, pageMove); create("UICorner", {CornerRadius=UDim.new(0,6)}, btnFly)
local flySpeedLabel = create("TextLabel", {Size=UDim2.new(0,220,0,20), BackgroundTransparency=1, Text="Скор. полета: 50", TextColor3=Color3.fromRGB(200,200,200), Font=Enum.Font.Gotham, TextSize=12, TextXAlignment=Enum.TextXAlignment.Left, LayoutOrder=3, Visible=false}, pageMove)
local flySpeedSliderBg = create("Frame", {Size=UDim2.new(0,220,0,6), BackgroundColor3=Color3.fromRGB(60,60,70), BorderSizePixel=0, LayoutOrder=4, Visible=false}, pageMove); create("UICorner", {CornerRadius=UDim.new(0,3)}, flySpeedSliderBg)
local flySpeedSliderFill = create("Frame", {Size=UDim2.new((50-10)/(200-10),0,1,0), BackgroundColor3=Color3.fromRGB(0,255,150), BorderSizePixel=0}, flySpeedSliderBg); create("UICorner", {CornerRadius=UDim.new(0,3)}, flySpeedSliderFill)
local flySpeedSliderKnob = create("Frame", {Size=UDim2.new(0,16,0,16), Position=UDim2.new((50-10)/(200-10),-8,0.5,-8), BackgroundColor3=Color3.new(1,1,1), BorderSizePixel=0, ZIndex=2}, flySpeedSliderBg); create("UICorner", {CornerRadius=UDim.new(0,8)}, flySpeedSliderKnob)
local btnSpd = create("TextButton", {Size=UDim2.new(0,220,0,30), BackgroundColor3=Color3.fromRGB(100,100,100), Text="Скорость: ВЫКЛ", TextColor3=Color3.new(1,1,1), Font=Enum.Font.GothamBold, TextSize=12, BorderSizePixel=0, LayoutOrder=5}, pageMove); create("UICorner", {CornerRadius=UDim.new(0,6)}, btnSpd)
local wSliderBg = create("Frame", {Size=UDim2.new(0,220,0,6), BackgroundColor3=Color3.fromRGB(60,60,70), BorderSizePixel=0, Visible=false, LayoutOrder=6}, pageMove); create("UICorner", {CornerRadius=UDim.new(0,3)}, wSliderBg)
local wSliderFill = create("Frame", {Size=UDim2.new(50/150,0,1,0), BackgroundColor3=Color3.fromRGB(0,150,255), BorderSizePixel=0}, wSliderBg); create("UICorner", {CornerRadius=UDim.new(0,3)}, wSliderFill)
local wSliderKnob = create("Frame", {Size=UDim2.new(0,16,0,16), Position=UDim2.new(50/150,-8,0.5,-8), BackgroundColor3=Color3.new(1,1,1), BorderSizePixel=0, ZIndex=2}, wSliderBg); create("UICorner", {CornerRadius=UDim.new(0,8)}, wSliderKnob)
local btnJmp = create("TextButton", {Size=UDim2.new(0,220,0,30), BackgroundColor3=Color3.fromRGB(100,100,100), Text="Прыжок: ВЫКЛ", TextColor3=Color3.new(1,1,1), Font=Enum.Font.GothamBold, TextSize=12, BorderSizePixel=0, LayoutOrder=7}, pageMove); create("UICorner", {CornerRadius=UDim.new(0,6)}, btnJmp)
local btnSpin = create("TextButton", {Size=UDim2.new(0,220,0,30), BackgroundColor3=Color3.fromRGB(100,100,100), Text="Спин: ВЫКЛ", TextColor3=Color3.new(1,1,1), Font=Enum.Font.GothamBold, TextSize=12, BorderSizePixel=0, LayoutOrder=8}, pageMove); create("UICorner", {CornerRadius=UDim.new(0,6)}, btnSpin)

-- FIGHT
local lblFight = create("TextLabel", {Size=UDim2.new(0,220,0,20), BackgroundTransparency=1, Text="Бой / Fight", TextColor3=Color3.new(1,1,1), Font=Enum.Font.GothamBold, TextSize=14, LayoutOrder=1}, pageFight)
local btnAim = create("TextButton", {Size=UDim2.new(0,220,0,30), BackgroundColor3=Color3.fromRGB(100,100,100), Text="Aimlock: ВЫКЛ", TextColor3=Color3.new(1,1,1), Font=Enum.Font.GothamBold, TextSize=12, BorderSizePixel=0, LayoutOrder=2}, pageFight); create("UICorner", {CornerRadius=UDim.new(0,6)}, btnAim)
local btnAimTarget = create("TextButton", {Size=UDim2.new(0,220,0,30), BackgroundColor3=Color3.fromRGB(50,50,60), Text="Цель: Люди", TextColor3=Color3.new(1,1,1), Font=Enum.Font.GothamBold, TextSize=12, BorderSizePixel=0, LayoutOrder=3}, pageFight); create("UICorner", {CornerRadius=UDim.new(0,6)}, btnAimTarget)
local btnAimVisible = create("TextButton", {Size=UDim2.new(0,220,0,30), BackgroundColor3=Color3.fromRGB(50,50,60), Text="Только видимые: ВЫКЛ", TextColor3=Color3.new(1,1,1), Font=Enum.Font.GothamBold, TextSize=12, BorderSizePixel=0, LayoutOrder=4}, pageFight); create("UICorner", {CornerRadius=UDim.new(0,6)}, btnAimVisible)
local aimFovLabel = create("TextLabel", {Size=UDim2.new(0,220,0,20), BackgroundTransparency=1, Text="FOV Aim: 200", TextColor3=Color3.fromRGB(200,200,200), Font=Enum.Font.Gotham, TextSize=12, TextXAlignment=Enum.TextXAlignment.Left, LayoutOrder=5}, pageFight)
local aimFovSliderBg = create("Frame", {Size=UDim2.new(0,220,0,6), BackgroundColor3=Color3.fromRGB(60,60,70), BorderSizePixel=0, LayoutOrder=6}, pageFight); create("UICorner", {CornerRadius=UDim.new(0,3)}, aimFovSliderBg)
local aimFovSliderFill = create("Frame", {Size=UDim2.new((200-50)/(500-50),0,1,0), BackgroundColor3=Color3.fromRGB(255,50,50), BorderSizePixel=0}, aimFovSliderBg); create("UICorner", {CornerRadius=UDim.new(0,3)}, aimFovSliderFill)
local aimFovSliderKnob = create("Frame", {Size=UDim2.new(0,16,0,16), Position=UDim2.new((200-50)/(500-50),-8,0.5,-8), BackgroundColor3=Color3.new(1,1,1), BorderSizePixel=0, ZIndex=2}, aimFovSliderBg); create("UICorner", {CornerRadius=UDim.new(0,8)}, aimFovSliderKnob)
local aimPredLabel = create("TextLabel", {Size=UDim2.new(0,220,0,20), BackgroundTransparency=1, Text="Предикт: 0.10", TextColor3=Color3.fromRGB(200,200,200), Font=Enum.Font.Gotham, TextSize=12, TextXAlignment=Enum.TextXAlignment.Left, LayoutOrder=7}, pageFight)
local aimPredSliderBg = create("Frame", {Size=UDim2.new(0,220,0,6), BackgroundColor3=Color3.fromRGB(60,60,70), BorderSizePixel=0, LayoutOrder=8}, pageFight); create("UICorner", {CornerRadius=UDim.new(0,3)}, aimPredSliderBg)
local aimPredSliderFill = create("Frame", {Size=UDim2.new((0.1-0.0)/(0.3-0.0),0,1,0), BackgroundColor3=Color3.fromRGB(0,255,150), BorderSizePixel=0}, aimPredSliderBg); create("UICorner", {CornerRadius=UDim.new(0,3)}, aimPredSliderFill)
local aimPredSliderKnob = create("Frame", {Size=UDim2.new(0,16,0,16), Position=UDim2.new((0.1-0.0)/(0.3-0.0),-8,0.5,-8), BackgroundColor3=Color3.new(1,1,1), BorderSizePixel=0, ZIndex=2}, aimPredSliderBg); create("UICorner", {CornerRadius=UDim.new(0,8)}, aimPredSliderKnob)
local fovCircle = create("Frame", {Size=UDim2.new(0, aimFov*2, 0, aimFov*2), Position=UDim2.new(0.5,-aimFov,0.5,-aimFov), BackgroundTransparency=1, Visible=false, ZIndex=50}, gui)
create("UICorner", {CornerRadius=UDim.new(1,0)}, fovCircle)
create("UIStroke", {Color=Color3.fromRGB(255,0,0), Thickness=1, Transparency=0.5}, fovCircle)

-- MELLSTROY
create("TextLabel", {Size=UDim2.new(1,0,0,30), Position=UDim2.new(0,0,0,10), BackgroundTransparency=1, Text="Mellstroy Mode", TextColor3=Color3.new(1,1,1), Font=Enum.Font.GothamBold, TextSize=14}, pageMell)
local lblWarn = create("TextLabel", {Size=UDim2.new(1,0,0,20), Position=UDim2.new(0,0,0,35), BackgroundTransparency=1, Text="Включите ESP Дронов!", TextColor3=Color3.fromRGB(255,50,50), Font=Enum.Font.GothamBold, TextSize=12}, pageMell)
local btnMell = create("TextButton", {Size=UDim2.new(0,220,0,35), Position=UDim2.new(0,10,0,70), BackgroundColor3=Color3.fromRGB(100,100,100), Text="Mellstroy: ВЫКЛ", TextColor3=Color3.new(1,1,1), Font=Enum.Font.GothamBold, TextSize=13, BorderSizePixel=0}, pageMell); create("UICorner", {CornerRadius=UDim.new(0,6)}, btnMell)

-- MISC
local lblTpTitle = create("TextLabel", {Size=UDim2.new(1,0,0,30), BackgroundTransparency=1, Text="Телепорт", TextColor3=Color3.new(1,1,1), Font=Enum.Font.GothamBold, TextSize=14, LayoutOrder=1}, pageMisc)
local btnTpPlr = create("TextButton", {Size=UDim2.new(0,220,0,35), BackgroundColor3=Color3.fromRGB(50,50,60), Text="ТП к ближ. игроку", TextColor3=Color3.new(1,1,1), Font=Enum.Font.GothamBold, TextSize=13, BorderSizePixel=0, LayoutOrder=2}, pageMisc); create("UICorner", {CornerRadius=UDim.new(0,6)}, btnTpPlr)
local btnTpDrn = create("TextButton", {Size=UDim2.new(0,220,0,35), BackgroundColor3=Color3.fromRGB(50,50,60), Text="ТП к ближ. дрону", TextColor3=Color3.new(1,1,1), Font=Enum.Font.GothamBold, TextSize=13, BorderSizePixel=0, LayoutOrder=3}, pageMisc); create("UICorner", {CornerRadius=UDim.new(0,6)}, btnTpDrn)
local btnRefillDrones = create("TextButton", {Size=UDim2.new(0,220,0,35), BackgroundColor3=Color3.fromRGB(0,150,255), Text="Пополнить дроны (ТП)", TextColor3=Color3.new(1,1,1), Font=Enum.Font.GothamBold, TextSize=13, BorderSizePixel=0, LayoutOrder=4}, pageMisc); create("UICorner", {CornerRadius=UDim.new(0,6)}, btnRefillDrones)
local btnToggleExtTP = create("TextButton", {Size=UDim2.new(0,220,0,35), BackgroundColor3=Color3.fromRGB(100,100,100), Text="Внешняя ТП: ВЫКЛ", TextColor3=Color3.new(1,1,1), Font=Enum.Font.GothamBold, TextSize=13, BorderSizePixel=0, LayoutOrder=5}, pageMisc); create("UICorner", {CornerRadius=UDim.new(0,6)}, btnToggleExtTP)
local lblExtTpInfo = create("TextLabel", {Size=UDim2.new(0,220,0,15), BackgroundTransparency=1, Text="(Только к людям)", TextColor3=Color3.fromRGB(150,150,150), Font=Enum.Font.Gotham, TextSize=11, TextXAlignment=Enum.TextXAlignment.Center, LayoutOrder=6}, pageMisc)
local lblPList = create("TextLabel", {Size=UDim2.new(0,220,0,20), BackgroundTransparency=1, Text="Игроки (ТП):", TextColor3=Color3.fromRGB(200,200,200), Font=Enum.Font.GothamBold, TextSize=12, TextXAlignment=Enum.TextXAlignment.Left, LayoutOrder=7}, pageMisc)
local playerListFrame = create("ScrollingFrame", {Size=UDim2.new(0,220,0,150), BackgroundColor3=Color3.fromRGB(30,30,40), BorderSizePixel=0, ScrollBarThickness=2, CanvasSize=UDim2.new(0,0,0,0), AutomaticCanvasSize=Enum.AutomaticSize.Y, LayoutOrder=8}, pageMisc)
create("UICorner", {CornerRadius=UDim.new(0,6)}, playerListFrame)
create("UIListLayout", {Padding=UDim.new(0,2), SortOrder=Enum.SortOrder.LayoutOrder}, playerListFrame)
create("UIPadding", {PaddingTop=UDim.new(0,5), PaddingBottom=UDim.new(0,5), PaddingLeft=UDim.new(0,5), PaddingRight=UDim.new(0,5)}, playerListFrame)

-- ВНЕШНЯЯ КНОПКА ТП
local extBtn = create("TextButton", {Size=UDim2.new(0,60,0,60), Position=UDim2.new(1,-80,0.5,-30), BackgroundColor3=Color3.fromRGB(0,150,80), Text="TP", TextColor3=Color3.new(1,1,1), Font=Enum.Font.GothamBold, TextSize=18, ZIndex=100, Visible=false}, gui)
create("UICorner", {CornerRadius=UDim.new(1,0)}, extBtn)
create("UIStroke", {Color=Color3.fromRGB(0,255,100), Thickness=2}, extBtn)

-- LANGUAGE
create("TextLabel", {Size=UDim2.new(1,0,0,30), Position=UDim2.new(0,0,0,10), BackgroundTransparency=1, Text="Язык / Language", TextColor3=Color3.new(1,1,1), Font=Enum.Font.GothamBold, TextSize=14}, pageLang)
local btnRu = create("TextButton", {Size=UDim2.new(0,105,0,35), Position=UDim2.new(0,10,0,50), BackgroundColor3=Color3.fromRGB(0,150,80), Text="Русский", TextColor3=Color3.new(1,1,1), Font=Enum.Font.GothamBold, TextSize=13, BorderSizePixel=0}, pageLang); create("UICorner", {CornerRadius=UDim.new(0,6)}, btnRu)
local btnEn = create("TextButton", {Size=UDim2.new(0,105,0,35), Position=UDim2.new(0,125,0,50), BackgroundColor3=Color3.fromRGB(100,100,100), Text="English", TextColor3=Color3.new(1,1,1), Font=Enum.Font.GothamBold, TextSize=13, BorderSizePixel=0}, pageLang); create("UICorner", {CornerRadius=UDim.new(0,6)}, btnEn)

-- SETTINGS
local cfgLabel = create("TextLabel", {Size=UDim2.new(0,220,0,20), BackgroundTransparency=1, Text="Имя конфига:", TextColor3=Color3.fromRGB(200,200,200), Font=Enum.Font.Gotham, TextSize=12, TextXAlignment=Enum.TextXAlignment.Left, LayoutOrder=1}, pageSet)
local txtConfigName = create("TextBox", {Size=UDim2.new(0,220,0,30), BackgroundColor3=Color3.fromRGB(40,40,50), Text="", PlaceholderText="Введите имя...", TextColor3=Color3.new(1,1,1), Font=Enum.Font.Gotham, TextSize=12, BorderSizePixel=0, LayoutOrder=2}, pageSet); create("UICorner", {CornerRadius=UDim.new(0,6)}, txtConfigName)
local cfgButtonsFrame = create("Frame", {Size=UDim2.new(0,220,0,30), BackgroundTransparency=1, LayoutOrder=3}, pageSet)
local btnSaveConfig = create("TextButton", {Size=UDim2.new(0,105,0,30), Position=UDim2.new(0,0,0,0), BackgroundColor3=Color3.fromRGB(0,150,80), Text="СОХРАНИТЬ", TextColor3=Color3.new(1,1,1), Font=Enum.Font.GothamBold, TextSize=12, BorderSizePixel=0}, cfgButtonsFrame); create("UICorner", {CornerRadius=UDim.new(0,6)}, btnSaveConfig)
local btnLoadConfig = create("TextButton", {Size=UDim2.new(0,105,0,30), Position=UDim2.new(0,115,0,0), BackgroundColor3=Color3.fromRGB(0,150,255), Text="ЗАГРУЗИТЬ", TextColor3=Color3.new(1,1,1), Font=Enum.Font.GothamBold, TextSize=12, BorderSizePixel=0}, cfgButtonsFrame); create("UICorner", {CornerRadius=UDim.new(0,6)}, btnLoadConfig)
local cfgStatus = create("TextLabel", {Size=UDim2.new(0,220,0,20), BackgroundTransparency=1, Text="", TextColor3=Color3.fromRGB(0,255,0), Font=Enum.Font.GothamBold, TextSize=12, TextXAlignment=Enum.TextXAlignment.Center, LayoutOrder=4}, pageSet)
local lblOther = create("TextLabel", {Size=UDim2.new(0,220,0,20), BackgroundTransparency=1, Text="Прочее", TextColor3=Color3.fromRGB(200,200,200), Font=Enum.Font.GothamBold, TextSize=14, TextXAlignment=Enum.TextXAlignment.Left, LayoutOrder=5}, pageSet)
local btnAntiAfly = create("TextButton", {Size=UDim2.new(0,220,0,30), BackgroundColor3=Color3.fromRGB(50,50,60), Text="Anti-AFK: ВЫКЛ", TextColor3=Color3.new(1,1,1), Font=Enum.Font.GothamBold, TextSize=12, BorderSizePixel=0, LayoutOrder=6}, pageSet); create("UICorner", {CornerRadius=UDim.new(0,6)}, btnAntiAfly)
local btnWatermark = create("TextButton", {Size=UDim2.new(0,220,0,30), BackgroundColor3=Color3.fromRGB(50,50,60), Text="Водяной знак (FPS): ВЫКЛ", TextColor3=Color3.new(1,1,1), Font=Enum.Font.GothamBold, TextSize=12, BorderSizePixel=0, LayoutOrder=7}, pageSet); create("UICorner", {CornerRadius=UDim.new(0,6)}, btnWatermark)
local btnKillFeed = create("TextButton", {Size=UDim2.new(0,220,0,30), BackgroundColor3=Color3.fromRGB(50,50,60), Text="Лог смертей: ВЫКЛ", TextColor3=Color3.new(1,1,1), Font=Enum.Font.GothamBold, TextSize=12, BorderSizePixel=0, LayoutOrder=8}, pageSet); create("UICorner", {CornerRadius=UDim.new(0,6)}, btnKillFeed)
local btnKill = create("TextButton", {Size=UDim2.new(0,200,0,35), Position=UDim2.new(0.5,-100,0,10), BackgroundColor3=Color3.fromRGB(150,30,30), Text="УДАЛИТЬ СКРИПТ", TextColor3=Color3.new(1,1,1), Font=Enum.Font.GothamBold, TextSize=14, BorderSizePixel=0, LayoutOrder=9}, pageSet); create("UICorner", {CornerRadius=UDim.new(0,6)}, btnKill)

-- INFO
create("TextLabel", {Size=UDim2.new(1,0,0,30), Position=UDim2.new(0,0,0,10), BackgroundTransparency=1, Text="Информация", TextColor3=Color3.new(1,1,1), Font=Enum.Font.GothamBold, TextSize=14}, pageInfo)
local tgTitle = create("TextLabel", {Size=UDim2.new(1,0,0,20), Position=UDim2.new(0,0,0,50), BackgroundTransparency=1, Text="Мой Телеграм:", TextColor3=Color3.fromRGB(200,200,200), Font=Enum.Font.Gotham, TextSize=12}, pageInfo)
local tgBtn = create("TextButton", {Size=UDim2.new(0,220,0,35), Position=UDim2.new(0.5,-110,0,80), BackgroundColor3=Color3.fromRGB(50,50,60), Text=tgLink, TextColor3=Color3.fromRGB(0,150,255), Font=Enum.Font.GothamBold, TextSize=11, BorderSizePixel=0}, pageInfo)
create("UICorner", {CornerRadius=UDim.new(0,6)}, tgBtn)
local copyStatus = create("TextLabel", {Size=UDim2.new(1,0,0,20), Position=UDim2.new(0,0,0,125), BackgroundTransparency=1, Text="Ссылка скопирована!", TextColor3=Color3.fromRGB(0,255,0), Font=Enum.Font.GothamBold, TextSize=12, Visible=false}, pageInfo)
function updateUI()
    tabVis.Text = L("v"); tabMove.Text = L("m"); tabFight.Text = L("f"); tabMell.Text = L("mel"); tabMisc.Text = L("misc"); tabLang.Text = L("l"); tabSet.Text = L("s"); tabInfo.Text = L("inf")
    lblMove.Text = L("move_title"); lblWorld.Text = L("world_title"); lblCam.Text = L("cam_title"); lblFight.Text = L("fight_title"); lblEsp.Text = L("esp_title")
    btnP.Text = L("p")..(pMode==1 and "3D" or pMode==2 and "2D" or L("off")); btnP.BackgroundColor3 = pMode==1 and Color3.fromRGB(0,150,80) or pMode==2 and Color3.fromRGB(0,150,255) or Color3.fromRGB(100,100,100)
    btnD.Text = L("d")..(dMode==1 and "3D" or dMode==2 and "2D" or L("off")); btnD.BackgroundColor3 = dMode==1 and Color3.fromRGB(255,200,0) or dMode==2 and Color3.fromRGB(255,150,0) or Color3.fromRGB(100,100,100)
    
    btnEspColor.Text = L("color")..colorNames[espColorMode]; btnEspColor.BackgroundColor3 = espColors[espColorMode]
    
    lblDist.Text = L("dist")..tostring(maxDist).."м"
    btnFov.Text = L("fov")..(fovMode and tostring(fovValue) or L("off")); btnFov.BackgroundColor3 = fovMode and Color3.fromRGB(0,150,80) or Color3.fromRGB(50,50,60)
    btnFly.Text = L("fly")..(flyMode and L("on") or L("off")); btnFly.BackgroundColor3 = flyMode and Color3.fromRGB(0,150,80) or Color3.fromRGB(100,100,100)
    if speedMode then btnSpd.Text = L("spd")..tostring(walkSpeedVal); btnSpd.BackgroundColor3 = Color3.fromRGB(0,150,80) else btnSpd.Text = L("spd")..L("off"); btnSpd.BackgroundColor3 = Color3.fromRGB(100,100,100) end
    btnJmp.Text = L("jmp")..(jumpMode and L("on") or L("off")); btnJmp.BackgroundColor3 = jumpMode and Color3.fromRGB(0,150,80) or Color3.fromRGB(100,100,100)
    btnSpin.Text = L("spin")..(spinEnabled and L("on") or L("off")); btnSpin.BackgroundColor3 = spinEnabled and Color3.fromRGB(0,150,80) or Color3.fromRGB(100,100,100)
    
    optBtn.Text = L("opt")..(isOptimized and L("on") or L("off")); optBtn.BackgroundColor3 = isOptimized and Color3.fromRGB(0,150,80) or Color3.fromRGB(50,50,60)
    timeLabel.Text = L("time")..string.format("%02d:00", timeValue)
    lblWarn.Text = L("warn")
    btnMell.Text = "Mellstroy: "..(mellMode and L("on") or L("off")); btnMell.BackgroundColor3 = mellMode and Color3.fromRGB(200,50,50) or Color3.fromRGB(100,100,100)
    btnKill.Text = L("del")
    btnRu.BackgroundColor3 = currentLang=="ru" and Color3.fromRGB(0,150,80) or Color3.fromRGB(100,100,100)
    btnEn.BackgroundColor3 = currentLang=="en" and Color3.fromRGB(0,150,80) or Color3.fromRGB(100,100,100)
    btnAim.Text = L("sa")..(aimEnabled and L("on") or L("off")); btnAim.BackgroundColor3 = aimEnabled and Color3.fromRGB(0,150,80) or Color3.fromRGB(100,100,100)
    local tName = aimTargetMode==1 and L("t_people") or aimTargetMode==2 and L("t_drones") or L("t_both")
    btnAimTarget.Text = L("sa_t")..tName
    btnAimVisible.Text = L("sa_vis")..(aimVisibleOnly and L("on") or L("off")); btnAimVisible.BackgroundColor3 = aimVisibleOnly and Color3.fromRGB(0,150,80) or Color3.fromRGB(50,50,60)
    aimFovLabel.Text = L("sa_fov")..tostring(aimFov)
    aimPredLabel.Text = L("sa_pr")..string.format("%.2f", aimPrediction)
    fovCircle.Visible = aimEnabled
    
    flySpeedLabel.Text = L("fly_spd")..tostring(math.floor(flySpeed))
    flySpeedLabel.Visible = flyMode
    flySpeedSliderBg.Visible = flyMode
    
    btnTpPlr.Text = L("tp_plr"); btnTpDrn.Text = L("tp_drn")
    btnRefillDrones.Text = L("refill")
    btnToggleExtTP.Text = L("ext_tp")..(extTPEnabled and L("on") or L("off"))
    btnToggleExtTP.BackgroundColor3 = extTPEnabled and Color3.fromRGB(0,150,80) or Color3.fromRGB(100,100,100)
    lblExtTpInfo.Text = L("ext_tp_info")
    lblPList.Text = L("plist")
    
    lblOther.Text = L("other_title")
    btnAntiAfly.Text = L("anti_afk")..(antiAfkEnabled and L("on") or L("off"))
    btnAntiAfly.BackgroundColor3 = antiAfkEnabled and Color3.fromRGB(0,150,80) or Color3.fromRGB(50,50,60)
    
    btnWatermark.Text = L("wm")..(wmEnabled and L("on") or L("off"))
    btnWatermark.BackgroundColor3 = wmEnabled and Color3.fromRGB(0,150,80) or Color3.fromRGB(50,50,60)
    btnKillFeed.Text = L("kf")..(killFeedEnabled and L("on") or L("off"))
    btnKillFeed.BackgroundColor3 = killFeedEnabled and Color3.fromRGB(0,150,80) or Color3.fromRGB(50,50,60)
    
    local wName = weatherMode==0 and L("w_off") or weatherMode==1 and L("w_snow") or L("w_rain")
    btnWeather.Text = L("weather")..wName
    btnWeather.BackgroundColor3 = weatherMode>0 and Color3.fromRGB(0,150,255) or Color3.fromRGB(50,50,60)
    
    cfgLabel.Text = L("cfg_name"); btnSaveConfig.Text = L("cfg_save"); btnLoadConfig.Text = L("cfg_load")
    tgTitle.Text = L("info_title"); copyStatus.Text = L("copy_msg")
end

local function setupSlider(sliderBg, fill, knob, min, max, callback)
    local sliding = false
    sliderBg.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then sliding=true end end)
    UIS.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then sliding=false end end)
    UIS.InputChanged:Connect(function(i)
        if sliding and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
            local percent = math.clamp((i.Position.X-sliderBg.AbsolutePosition.X)/sliderBg.AbsoluteSize.X, 0, 1)
            local val = min + percent*(max-min)
            fill.Size = UDim2.new(percent,0,1,0); knob.Position = UDim2.new(percent,-8,0.5,-8); callback(val)
        end
    end)
end
setupSlider(sliderBg, sliderFill, sliderKnob, 100, 2000, function(v) maxDist = math.floor(v); lblDist.Text = L("dist")..tostring(maxDist).."м" end)
setupSlider(fovSliderBg, fovSliderFill, fovSliderKnob, 70, 120, function(v) fovValue = math.floor(v); btnFov.Text = L("fov")..tostring(fovValue) end)
setupSlider(wSliderBg, wSliderFill, wSliderKnob, 16, 150, function(v) walkSpeedVal = math.floor(v); btnSpd.Text = L("spd")..tostring(walkSpeedVal) end)
setupSlider(timeSliderBg, timeSliderFill, timeSliderKnob, 0, 24, function(v) timeValue = math.floor(v); timeLabel.Text = L("time")..string.format("%02d:00", timeValue); Lighting.ClockTime = timeValue end)
setupSlider(aimFovSliderBg, aimFovSliderFill, aimFovSliderKnob, 50, 500, function(v) aimFov = math.floor(v); aimFovLabel.Text = L("sa_fov")..tostring(aimFov); fovCircle.Size = UDim2.new(0, aimFov*2, 0, aimFov*2); fovCircle.Position = UDim2.new(0.5,-aimFov,0.5,-aimFov) end)
setupSlider(aimPredSliderBg, aimPredSliderFill, aimPredSliderKnob, 0.0, 0.3, function(v) aimPrediction = v; aimPredLabel.Text = L("sa_pr")..string.format("%.2f", v) end)
setupSlider(flySpeedSliderBg, flySpeedSliderFill, flySpeedSliderKnob, 10, 200, function(v) flySpeed = v; flySpeedLabel.Text = L("fly_spd")..tostring(math.floor(v)) end)

btnRu.MouseButton1Click:Connect(function() currentLang="ru"; updateUI() end)
btnEn.MouseButton1Click:Connect(function() currentLang="en"; updateUI() end)
btnP.MouseButton1Click:Connect(function() pMode=pMode%3+1; updateUI() end)
btnD.MouseButton1Click:Connect(function() dMode=dMode%3+1; updateUI() end)
btnFov.MouseButton1Click:Connect(function() fovMode = not fovMode; fovSliderBg.Visible = fovMode; if not fovMode then Cam.FieldOfView = 70 end; updateUI() end)
btnAim.MouseButton1Click:Connect(function() aimEnabled = not aimEnabled; if not aimEnabled then aimCurrentTarget = nil end; updateUI() end)
btnAimTarget.MouseButton1Click:Connect(function() aimTargetMode = aimTargetMode%3+1; updateUI() end)
btnAimVisible.MouseButton1Click:Connect(function() aimVisibleOnly = not aimVisibleOnly; updateUI() end)
btnSpin.MouseButton1Click:Connect(function() spinEnabled = not spinEnabled; updateUI() end)
btnToggleExtTP.MouseButton1Click:Connect(function() extTPEnabled = not extTPEnabled; extBtn.Visible = extTPEnabled; updateUI() end)
btnAntiAfly.MouseButton1Click:Connect(function() antiAfkEnabled = not antiAfkEnabled; updateUI() end)
btnWatermark.MouseButton1Click:Connect(function() wmEnabled = not wmEnabled; watermark.Visible = wmEnabled; updateUI() end)
btnKillFeed.MouseButton1Click:Connect(function() killFeedEnabled = not killFeedEnabled; updateUI() end)
btnEspColor.MouseButton1Click:Connect(function() 
    espColorMode = espColorMode % #espColors + 1
    local newColor = espColors[espColorMode]
    for p, d in pairs(esp) do if d.HL then d.HL.OutlineColor = newColor end; if d.Box2D then d.Box2D.UIStroke.Color = newColor end end
    for m, d in pairs(drones) do if d.HL then d.HL.OutlineColor = newColor end; if d.Box2D then d.Box2D.UIStroke.Color = newColor end end
    for _, t in pairs(tracerPool) do if t.UIStroke then t.UIStroke.Color = newColor end; t.BackgroundColor3 = newColor end
    updateUI() 
end)

-- ЛОГИКА КОПИРОВАНИЯ ССЫЛКИ
tgBtn.MouseButton1Click:Connect(function()
    pcall(function()
        setclipboard(tgLink)
    end)
    copyStatus.Visible = true
    task.wait(2)
    copyStatus.Visible = false
end)

-- Погода
local weatherPart = Instance.new("Part", workspace)
weatherPart.Name = "WeatherPart"; weatherPart.Size = Vector3.new(200, 200, 200); weatherPart.Transparency = 1; weatherPart.CanCollide = false; weatherPart.Anchored = true
local weatherEmitter = Instance.new("ParticleEmitter", weatherPart)
weatherEmitter.Enabled = false; weatherEmitter.LightEmission = 1
weatherEmitter.Shape = Enum.ParticleEmitterShape.Box; weatherEmitter.ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume; weatherEmitter.EmissionDirection = Enum.NormalId.Bottom
local function applyWeather()
    if weatherMode == 0 then weatherEmitter.Enabled = false
    elseif weatherMode == 1 then
        weatherEmitter.Enabled = true; weatherEmitter.Texture = "rbxasset://textures/particles/sparkles_main.dds"; weatherEmitter.Color = ColorSequence.new(Color3.fromRGB(240, 240, 255)); weatherEmitter.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.1),NumberSequenceKeypoint.new(0.5, 0.8),NumberSequenceKeypoint.new(1, 0.1)})
        weatherEmitter.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1),NumberSequenceKeypoint.new(0.2, 0.2),NumberSequenceKeypoint.new(0.8, 0.2),NumberSequenceKeypoint.new(1, 1)})
        weatherEmitter.Speed = NumberRange.new(2, 5); weatherEmitter.Acceleration = Vector3.new(0, -2, 0); weatherEmitter.Rate = 500; weatherEmitter.Lifetime = NumberRange.new(3, 6); weatherEmitter.Rotation = NumberRange.new(0, 360); weatherEmitter.RotSpeed = NumberRange.new(-100, 100)
    elseif weatherMode == 2 then
        weatherEmitter.Enabled = true; weatherEmitter.Texture = "rbxasset://textures/particles/sparkles_main.dds"; weatherEmitter.Color = ColorSequence.new(Color3.fromRGB(150, 200, 255)); weatherEmitter.Size = NumberSequence.new(0.15, 0.9)
        weatherEmitter.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.4),NumberSequenceKeypoint.new(1, 1)})
        weatherEmitter.Speed = NumberRange.new(60, 80); weatherEmitter.Acceleration = Vector3.new(0, -100, 0); weatherEmitter.Rate = 1500; weatherEmitter.Lifetime = NumberRange.new(0.8, 1.2); weatherEmitter.Rotation = NumberRange.new(0, 0); weatherEmitter.RotSpeed = NumberRange.new(0, 0)
    end
end

btnWeather.MouseButton1Click:Connect(function() weatherMode = (weatherMode + 1) % 3; applyWeather(); updateUI() end)

-- Функция ТП
local function tpPlayer()
    local myChar = LP.Character; if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return end
    local myPos = myChar.HumanoidRootPart.Position; local bestPos, bestDist = nil, math.huge
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and (p.Team == nil or p.Team ~= LP.Team) and p.Character then
            local hum = p.Character:FindFirstChildOfClass("Humanoid"); local hrp = p.Character:FindFirstChild("HumanoidRootPart")
            if hum and hum.Health > 0 and hrp then
                local dist = (hrp.Position - myPos).Magnitude
                if dist < bestDist then bestDist = dist; bestPos = hrp.Position end
            end
        end
    end
    if bestPos then myChar.HumanoidRootPart.CFrame = CFrame.new(bestPos + Vector3.new(0, 3, 0)) end
end
btnTpPlr.MouseButton1Click:Connect(tpPlayer)

btnTpDrn.MouseButton1Click:Connect(function()
    local myChar = LP.Character; if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return end
    local myPos = myChar.HumanoidRootPart.Position; local bestPos, bestDist = nil, math.huge
    for m, _ in pairs(drones) do
        if m.Parent and m:FindFirstChildWhichIsA("BasePart") then
            local pos = m:GetPivot().Position; local dist = (pos - myPos).Magnitude
            if dist < bestDist then bestDist = dist; bestPos = pos end
        end
    end
    if bestPos then myChar.HumanoidRootPart.CFrame = CFrame.new(bestPos + Vector3.new(0, 3, 0)) end
end)

-- Пополнение дронов
btnRefillDrones.MouseButton1Click:Connect(function()
    local myChar = LP.Character; if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return end
    local myHRP = myChar.HumanoidRootPart; local oldCFrame = myHRP.CFrame
    task.spawn(function()
        local closestBox, closestDist = nil, math.huge
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("Model") or obj:IsA("BasePart") then
                local n = obj.Name:lower()
                if n:find("box") or n:find("crate") or n:find("loot") or n:find("ящик") then
                    local pos = obj:IsA("Model") and (obj.PrimaryPart and obj.PrimaryPart.Position or obj:GetPivot().Position) or obj.Position
                    if pos then
                        local dist = (pos - myHRP.Position).Magnitude
                        if dist < closestDist then closestDist = dist; closestBox = obj end
                    end
                end
            end
        end
        if closestBox then
            local targetPos = closestBox:IsA("Model") and (closestBox.PrimaryPart and closestBox.PrimaryPart.Position or closestBox:GetPivot().Position) or closestBox.Position
            myHRP.CFrame = CFrame.new(targetPos + Vector3.new(0, 3, 0))
            task.wait(0.15)
            local cd = closestBox:FindFirstChildWhichIsA("ClickDetector", true); local pp = closestBox:FindFirstChildWhichIsA("ProximityPrompt", true)
            if cd then fireclickdetector(cd); task.wait(0.1); fireclickdetector(cd)
            elseif pp then fireproximityprompt(pp); task.wait(0.1); fireproximityprompt(pp) end
            task.wait(0.1); myHRP.CFrame = oldCFrame
        end
    end)
end)

-- Логика перетаскивания Внешней ТП
local eDragging, eDragStart, eStartPos, eMoved = false, nil, nil, false
extBtn.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then eDragging = true; eMoved = false; eDragStart = input.Position; eStartPos = extBtn.Position end end)
UIS.InputChanged:Connect(function(input) if eDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then local delta = input.Position - eDragStart; if math.abs(delta.X) > 5 or math.abs(delta.Y) > 5 then eMoved = true end; extBtn.Position = UDim2.new(eStartPos.X.Scale, eStartPos.X.Offset + delta.X, eStartPos.Y.Scale, eStartPos.Y.Offset + delta.Y) end end)
UIS.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then if eDragging and not eMoved then tpPlayer() end; eDragging = false end end)

-- Меню (PHub)
local mDragging, mDragStart, mStartPos, mMoved = false, nil, nil, false
local isMenuOpen = true
local function toggleMenu(openState)
    isMenuOpen = openState
    if isMenuOpen then
        main.Visible = true; menuBtn.Visible = false; main.Size = UDim2.new(0, 0, 0, 0)
        TweenService:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 360, 0, 280)}):Play()
    else
        local tween = TweenService:Create(main, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)})
        tween:Play(); tween.Completed:Connect(function() if not isMenuOpen then main.Visible = false; menuBtn.Visible = true end end)
    end
end
menuBtn.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then mDragging = true; mMoved = false; mDragStart = input.Position; mStartPos = menuBtn.Position end end)
UIS.InputChanged:Connect(function(input) if mDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then local delta = input.Position - mDragStart; if math.abs(delta.X) > 5 or math.abs(delta.Y) > 5 then mMoved = true end; menuBtn.Position = UDim2.new(mStartPos.X.Scale, mStartPos.X.Offset + delta.X, mStartPos.Y.Scale, mStartPos.Y.Offset + delta.Y) end end)
UIS.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then if mDragging and not mMoved then toggleMenu(true) end; mDragging = false end end)

-- Конфиги
btnSaveConfig.MouseButton1Click:Connect(function()
    local name = txtConfigName.Text
    if name == "" or name == nil then cfgStatus.Text = "Введите имя!"; cfgStatus.TextColor3 = Color3.fromRGB(255,50,50); return end
    local success, err = pcall(function()
        if not isfolder("pidorashub_configs") then makefolder("pidorashub_configs") end
        local data = maxDist.."|"..walkSpeedVal.."|"..fovValue.."|"..timeValue.."|"..aimFov.."|"..aimPrediction.."|"..pMode.."|"..dMode.."|"..aimTargetMode.."|"..tostring(aimVisibleOnly).."|"..tostring(spinEnabled).."|"..tostring(extTPEnabled).."|"..tostring(flySpeed).."|"..tostring(antiAfkEnabled).."|"..tostring(espColorMode).."|"..tostring(wmEnabled).."|"..tostring(weatherMode).."|"..tostring(killFeedEnabled)
        writefile("pidorashub_configs/"..name..".txt", data)
    end)
    if success then cfgStatus.Text = L("cfg_saved"); cfgStatus.TextColor3 = Color3.fromRGB(0,255,0) else cfgStatus.Text = L("cfg_err"); cfgStatus.TextColor3 = Color3.fromRGB(255,50,50) end
    task.wait(2); cfgStatus.Text = ""
end)

btnLoadConfig.MouseButton1Click:Connect(function()
    local name = txtConfigName.Text
    if name == "" or name == nil then cfgStatus.Text = "Введите имя!"; cfgStatus.TextColor3 = Color3.fromRGB(255,50,50); return end
    local path = "pidorashub_configs/"..name..".txt"
    if not isfile(path) then cfgStatus.Text = "Файл не найден!"; cfgStatus.TextColor3 = Color3.fromRGB(255,50,50); return end
    local success, err = pcall(function()
        local dataStr = readfile(path)
        local vals = string.split(dataStr, "|")
        if vals[1] then maxDist = tonumber(vals[1]) or maxDist; sliderFill.Size = UDim2.new((maxDist-100)/(2000-100),0,1,0); sliderKnob.Position = UDim2.new((maxDist-100)/(2000-100),-8,0.5,-8) end
        if vals[2] then walkSpeedVal = tonumber(vals[2]) or walkSpeedVal; wSliderFill.Size = UDim2.new((walkSpeedVal-16)/(150-16),0,1,0); wSliderKnob.Position = UDim2.new((walkSpeedVal-16)/(150-16),-8,0.5,-8) end
        if vals[3] then fovValue = tonumber(vals[3]) or fovValue; fovSliderFill.Size = UDim2.new((fovValue-70)/(120-70),0,1,0); fovSliderKnob.Position = UDim2.new((fovValue-70)/(120-70),-8,0.5,-8) end
        if vals[4] then timeValue = tonumber(vals[4]) or timeValue; timeSliderFill.Size = UDim2.new(timeValue/24,0,1,0); timeSliderKnob.Position = UDim2.new(timeValue/24,-8,0.5,-8); Lighting.ClockTime = timeValue end
        if vals[5] then aimFov = tonumber(vals[5]) or aimFov; aimFovSliderFill.Size = UDim2.new((aimFov-50)/(500-50),0,1,0); aimFovSliderKnob.Position = UDim2.new((aimFov-50)/(500-50),-8,0.5,-8); fovCircle.Size = UDim2.new(0, aimFov*2, 0, aimFov*2); fovCircle.Position = UDim2.new(0.5,-aimFov,0.5,-aimFov) end
        if vals[6] then aimPrediction = tonumber(vals[6]) or aimPrediction; aimPredSliderFill.Size = UDim2.new(aimPrediction/0.3,0,1,0); aimPredSliderKnob.Position = UDim2.new(aimPrediction/0.3,-8,0.5,-8) end
        if vals[7] then pMode = tonumber(vals[7]) or pMode end
        if vals[8] then dMode = tonumber(vals[8]) or dMode end
        if vals[9] then aimTargetMode = tonumber(vals[9]) or aimTargetMode end
        if vals[10] then aimVisibleOnly = vals[10] == "true" end
        if vals[11] then spinEnabled = vals[11] == "true" end
        if vals[12] then extTPEnabled = vals[12] == "true"; extBtn.Visible = extTPEnabled end
        if vals[13] then flySpeed = tonumber(vals[13]) or flySpeed; flySpeedSliderFill.Size = UDim2.new((flySpeed-10)/(200-10),0,1,0); flySpeedSliderKnob.Position = UDim2.new((flySpeed-10)/(200-10),-8,0.5,-8) end
        if vals[14] then antiAfkEnabled = vals[14] == "true" end
        if vals[15] then espColorMode = tonumber(vals[15]) or espColorMode; local newColor = espColors[espColorMode]; for p, d in pairs(esp) do if d.HL then d.HL.OutlineColor = newColor end; if d.Box2D then d.Box2D.UIStroke.Color = newColor end end; for m, d in pairs(drones) do if d.HL then d.HL.OutlineColor = newColor end; if d.Box2D then d.Box2D.UIStroke.Color = newColor end end end
        if vals[16] then wmEnabled = vals[16] == "true"; watermark.Visible = wmEnabled end
        if vals[17] then weatherMode = tonumber(vals[17]) or weatherMode; applyWeather() end
        if vals[18] then killFeedEnabled = vals[18] == "true" end
        updateUI()
    end)
    if success then cfgStatus.Text = L("cfg_loaded"); cfgStatus.TextColor3 = Color3.fromRGB(0,255,0) else cfgStatus.Text = L("cfg_err"); cfgStatus.TextColor3 = Color3.fromRGB(255,50,50) end
    task.wait(2); cfgStatus.Text = ""
end)

-- Оптимизация
optBtn.MouseButton1Click:Connect(function()
    isOptimized = not isOptimized
    updateUI()
    task.spawn(function()
        if isOptimized then
            pcall(function() settings().Rendering.QualityLevel = 1 end); if workspace.Terrain then workspace.Terrain.Decoration = false end
            local count = 0
            for _,obj in ipairs(workspace:GetDescendants()) do 
                if obj:IsA("BasePart") then 
                    obj.CastShadow = false
                    local n = obj.Name:lower()
                    if n:find("leaf") or n:find("leaves") or n:find("grass") or n:find("bush") or n:find("tree") then obj.LocalTransparencyModifier = 1 end
                elseif obj:IsA("Decal") or obj:IsA("Texture") then obj.Transparency = 1 
                elseif obj:IsA("ParticleEmitter") then if obj ~= weatherEmitter then obj.Enabled = false end 
                elseif obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then obj.Enabled = false end
                count = count + 1
                if count % 100 == 0 then task.wait() end
            end
            for _,effect in ipairs(Lighting:GetChildren()) do if effect:IsA("PostEffect") then effect.Enabled = false end end
        else
            pcall(function() settings().Rendering.QualityLevel = 10 end); if workspace.Terrain then workspace.Terrain.Decoration = true end
            local count = 0
            for _,obj in ipairs(workspace:GetDescendants()) do 
                if obj:IsA("BasePart") then obj.CastShadow = true; obj.LocalTransparencyModifier = 0
                elseif obj:IsA("Decal") or obj:IsA("Texture") then obj.Transparency = 0 
                elseif obj:IsA("ParticleEmitter") then if obj == weatherEmitter then obj.Enabled = (weatherMode > 0) else obj.Enabled = true end
                elseif obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then obj.Enabled = true end
                count = count + 1
                if count % 100 == 0 then task.wait() end
            end
            for _,effect in ipairs(Lighting:GetChildren()) do if effect:IsA("PostEffect") then effect.Enabled = true end end
        end
    end)
end)

btnFly.MouseButton1Click:Connect(function()
    flyMode = not flyMode; flySpeedLabel.Visible = flyMode; flySpeedSliderBg.Visible = flyMode
    if flyMode then if LP.Character and LP.Character:FindFirstChild("Humanoid") then LP.Character.Humanoid.PlatformStand = true end
    else if LP.Character and LP.Character:FindFirstChild("Humanoid") then LP.Character.Humanoid.PlatformStand = false end
        if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then local bv = LP.Character.HumanoidRootPart:FindFirstChild("FlyBV"); if bv then bv:Destroy() end end end
    updateUI()
end)
btnSpd.MouseButton1Click:Connect(function() speedMode = not speedMode; wSliderBg.Visible = speedMode; if not speedMode and LP.Character and LP.Character:FindFirstChild("Humanoid") then LP.Character.Humanoid.WalkSpeed = 16 end; updateUI() end)
btnJmp.MouseButton1Click:Connect(function() jumpMode=not jumpMode; updateUI() end)
table.insert(conns, UIS.JumpRequest:Connect(function() if jumpMode and LP.Character and LP.Character:FindFirstChild("Humanoid") then LP.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end end))
btnMell.MouseButton1Click:Connect(function() mellMode=not mellMode; updateUI() end)

-- БИНДЫ
UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.Insert then toggleMenu(not isMenuOpen)
    elseif input.KeyCode == Enum.KeyCode.T then tpPlayer()
    elseif input.KeyCode == Enum.KeyCode.F then aimEnabled = not aimEnabled; if not aimEnabled then aimCurrentTarget = nil end; updateUI() end
end)

-- ANTI-AFK
task.spawn(function()
    while task.wait(30) do
        if antiAfkEnabled then
            pcall(function() local vu = game:GetService("VirtualUser"); if vu then vu:CaptureController(); vu:ClickButton2(Vector2.new(math.random(100, 500), math.random(100, 500))) end end)
        end
    end
end)

-- FPS COUNTER
local frames = 0; local lastTime = os.clock()
table.insert(conns, RunService.RenderStepped:Connect(function()
    if wmEnabled then frames = frames + 1; if os.clock() - lastTime >= 1 then local fps = frames; frames = 0; lastTime = os.clock(); watermark.Text = "pidorashub | FPS: "..fps end end
end))

local dragging, dragStart, startPos
topBar.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true; dragStart = input.Position; startPos = main.Position end end)
UIS.InputChanged:Connect(function(input) if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and dragging then local delta = input.Position - dragStart; main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end)
UIS.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end end)

local function create2DBox(parent, color)
    local box = Instance.new("Frame", parent); box.BackgroundTransparency = 1; box.BorderSizePixel = 0; box.Visible = false; box.ZIndex = 10
    local stroke = Instance.new("UIStroke", box); stroke.Color = color; stroke.Thickness = 1; stroke.Transparency = 0.2
    return box
end

local function setupPlr(p)
    if p == LP then return end
    local d = {p=p, LastDist=-1}
    local function onChar(c)
        task.spawn(function()
            task.wait(1); if not c or not c.Parent or not c:FindFirstChild("Head") then return end
            if d.HL then d.HL:Destroy() end; if d.BB then d.BB:Destroy() end; if d.Box2D then d.Box2D:Destroy() end
            d.HL = Instance.new("Highlight", c); d.HL.FillTransparency = 1; d.HL.OutlineColor = espColors[espColorMode]; d.HL.OutlineTransparency = 0.2
            d.BB = Instance.new("BillboardGui", c.Head); d.BB.AlwaysOnTop = true; d.BB.Size = UDim2.new(0,150,0,30); d.BB.Enabled = false
            d.T3D = Instance.new("TextLabel", d.BB); d.T3D.BackgroundTransparency = 1; d.T3D.Size = UDim2.new(1,0,1,0); d.T3D.TextColor3 = Color3.fromRGB(255,100,100); d.T3D.Text = p.Name; d.T3D.TextStrokeTransparency = 0.3; d.T3D.Font = Enum.Font.GothamBold; d.T3D.TextSize = 12
            d.Box2D = create2DBox(gui, espColors[espColorMode])
        end)
        setupDeathListener(p, c)
    end
    if p.Character then onChar(p.Character) end
    table.insert(conns, p.CharacterAdded:Connect(onChar))
    esp[p] = d
end

local function setupDrn(m)
    if drones[m] then return end
    local n = m.Name:lower()
    if m:IsA("Model") and (n:find("drone") or n:find("fpv") or n:find("дрон") or n:find("коптер")) and not (n:find("box") or n:find("crate") or n:find("loot") or n:find("spawn")) then
        if m.Parent and m.Parent:IsA("Model") and m.Parent.Name:lower():find("drone") then return end
        local d = {m=m, LastDist=-1}
        d.HL = Instance.new("Highlight", m); d.HL.FillTransparency = 1; d.HL.OutlineColor = espColors[espColorMode]; d.HL.OutlineTransparency = 0.2
        d.BB = Instance.new("BillboardGui", m); d.BB.AlwaysOnTop = true; d.BB.Size = UDim2.new(0,100,0,25); d.BB.Enabled = false
        d.T3D = Instance.new("TextLabel", d.BB); d.T3D.BackgroundTransparency = 1; d.T3D.Size = UDim2.new(1,0,1,0); d.T3D.TextColor3 = Color3.fromRGB(255,200,0); d.T3D.Text = "ДРОН"; d.T3D.TextStrokeTransparency = 0.3; d.T3D.Font = Enum.Font.GothamBold; d.T3D.TextSize = 12
        local pPart = m.PrimaryPart or m:FindFirstChildWhichIsA("BasePart")
        if pPart then local mellBB = Instance.new("BillboardGui", pPart); mellBB.Name = "MellBB"; mellBB.AlwaysOnTop = true; mellBB.Size = UDim2.new(0,30,0,30); mellBB.StudsOffset = Vector3.new(0,0.5,0); mellBB.Enabled = false; local img = Instance.new("ImageLabel", mellBB); img.Size = UDim2.new(1,0,1,0); img.BackgroundTransparency = 1; img.Image = mellImgId; img.ImageTransparency = 0.3; img.ScaleType = Enum.ScaleType.Fit; d.MellBB = mellBB end
        d.Box2D = create2DBox(gui, espColors[espColorMode])
        drones[m] = d
        table.insert(conns, m.AncestryChanged:Connect(function() if not m:IsDescendantOf(workspace) then for _,v in pairs(d) do if type(v)=="table" and v.Remove then v:Remove() elseif type(v)=="userdata" and v.Destroy then v:Destroy() end end; drones[m] = nil end end))
    end
end

task.spawn(function() for _,p in ipairs(Players:GetPlayers()) do setupPlr(p) end end)
task.spawn(function() for _,o in ipairs(workspace:GetChildren()) do setupDrn(o) end end)
table.insert(conns, Players.PlayerAdded:Connect(setupPlr))
table.insert(conns, workspace.DescendantAdded:Connect(setupDrn))
table.insert(conns, Players.PlayerRemoving:Connect(function(p) if esp[p] then for _,v in pairs(esp[p]) do if type(v)=="table" and v.Remove then v:Remove() elseif type(v)=="userdata" and v.Destroy then v:Destroy() end end; esp[p] = nil end end))

local function getAimTarget()
    if not Cam then return nil end
    local vp = Cam.ViewportSize; local center = Vector2.new(vp.X/2, vp.Y/2); local best, bestDist = nil, aimFov
    local rp = RaycastParams.new(); rp.FilterType = Enum.RaycastFilterType.Exclude
    local filter = {}; if LP.Character then table.insert(filter, LP.Character) end; if Cam then table.insert(filter, Cam) end; rp.FilterDescendantsInstances = filter
    if aimTargetMode == 1 or aimTargetMode == 3 then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP and p.Character then
                local part = p.Character:FindFirstChild("Head") or p.Character:FindFirstChild("HumanoidRootPart")
                if part then
                    local sp, onS = Cam:WorldToViewportPoint(part.Position)
                    if onS and sp.Z > 0 then
                        local d = (Vector2.new(sp.X, sp.Y) - center).Magnitude
                        if d < bestDist then 
                            local visible = true
                            if aimVisibleOnly then local res = workspace:Raycast(Cam.CFrame.Position, part.Position - Cam.CFrame.Position, rp); if res and not res.Instance:IsDescendantOf(p.Character) then visible = false end end
                            if visible then bestDist = d; best = part.Position end
                        end
                    end
                end
            end
        end
    end
    if aimTargetMode == 2 or aimTargetMode == 3 then
        for m, d in pairs(drones) do
            if m.Parent then
                local primary = m.PrimaryPart or m:FindFirstChildWhichIsA("BasePart")
                if primary then
                    local vel = primary.Velocity or Vector3.new(0,0,0)
                    local predictedPos = primary.Position + (vel * aimPrediction)
                    local sp, onS = Cam:WorldToViewportPoint(predictedPos)
                    if onS and sp.Z > 0 then
                        local dist = (Vector2.new(sp.X, sp.Y) - center).Magnitude
                        if dist < bestDist then 
                            local visible = true
                            if aimVisibleOnly then local res = workspace:Raycast(Cam.CFrame.Position, predictedPos - Cam.CFrame.Position, rp); if res and not res.Instance:IsDescendantOf(m) then visible = false end end
                            if visible then bestDist = dist; best = predictedPos end
                        end
                    end
                end
            end
        end
    end
    return best
end

local updateESP = function()
    local myChar = LP.Character
    if aimEnabled then
        aimCurrentTarget = getAimTarget()
        if aimCurrentTarget and Cam then Cam.CFrame = CFrame.lookAt(Cam.CFrame.Position, aimCurrentTarget) end
    end
    if Cam then if fovMode then Cam.FieldOfView = fovValue else Cam.FieldOfView = 70 end end
    if myChar and myChar:FindFirstChild("HumanoidRootPart") and myChar:FindFirstChild("Humanoid") then
        local hum = myChar.Humanoid
        if speedMode then hum.WalkSpeed = walkSpeedVal elseif not speedMode and hum.WalkSpeed > 16 then hum.WalkSpeed = 16 end
        if flyMode then
            local bv = myChar.HumanoidRootPart:FindFirstChild("FlyBV")
            if not bv then bv = Instance.new("BodyVelocity", myChar.HumanoidRootPart); bv.Name = "FlyBV"; bv.MaxForce = Vector3.new(math.huge,math.huge,math.huge) end
            local md = hum.MoveDirection
            if md.Magnitude > 0.1 then local camLook = Cam.CFrame.LookVector; local camRight = Cam.CFrame.RightVector; local flatLook = Vector3.new(camLook.X, 0, camLook.Z); if flatLook.Magnitude < 0.01 then flatLook = Vector3.new(0,0,-1) else flatLook = flatLook.Unit end; local flatRight = Vector3.new(camRight.X, 0, camRight.Z).Unit; local dotLook = md:Dot(flatLook); local dotRight = md:Dot(flatRight); local flyDir = (camLook * dotLook) + (camRight * dotRight); bv.Velocity = flyDir * flySpeed else bv.Velocity = Vector3.new(0,0,0) end
        else local bv = myChar.HumanoidRootPart:FindFirstChild("FlyBV"); if bv then bv:Destroy() end end
    end

    if weatherPart and weatherMode > 0 then weatherPart.Position = Cam.CFrame.Position + Vector3.new(0, 25, 0) end

    if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then 
        for _,d in pairs(esp) do if d.Box2D then d.Box2D.Visible = false end end
        for _,d in pairs(drones) do if d.Box2D then d.Box2D.Visible = false end end
        return 
    end
    local myPos = myChar.HumanoidRootPart.Position
    for p,d in pairs(esp) do
        local c = p.Character
        if c and c:FindFirstChild("HumanoidRootPart") and c:FindFirstChild("Head") and c:FindFirstChild("Humanoid") then
            local hrp, head, hum = c.HumanoidRootPart, c.Head, c.Humanoid; local hs, onS = Cam:WorldToViewportPoint(head.Position)
            if onS and hs.Z > 0 then
                local diff = myPos - hrp.Position
                if diff.X^2 + diff.Y^2 + diff.Z^2 > maxDist^2 then d.HL.Enabled, d.BB.Enabled = false, false; if d.Box2D then d.Box2D.Visible = false end; continue end
                d.LastDist = math.floor(diff.Magnitude)
                if pMode == 1 then d.HL.Enabled, d.BB.Enabled = true, true; d.T3D.Text = p.Name.." ["..d.LastDist.."m] | HP: "..math.floor(hum.Health)..(c:FindFirstChildOfClass("Tool") and " | "..c:FindFirstChildOfClass("Tool").Name or "")
                else d.HL.Enabled, d.BB.Enabled = false, false end
                if pMode == 2 and d.Box2D then
                    local topPos, onSTop = Cam:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
                    local botPos, onSBot = Cam:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))
                    if onSTop and onSBot then local height = math.abs(topPos.Y - botPos.Y); local width = height / 2; d.Box2D.Size = UDim2.new(0, width, 0, height); d.Box2D.Position = UDim2.new(0, topPos.X - width/2, 0, topPos.Y); d.Box2D.Visible = true
                    else d.Box2D.Visible = false end
                else if d.Box2D then d.Box2D.Visible = false end end
            else d.HL.Enabled, d.BB.Enabled = false, false; if d.Box2D then d.Box2D.Visible = false end end
        end
    end
    for m,d in pairs(drones) do
        if m.Parent and m:FindFirstChildWhichIsA("BasePart") then
            local cf = m:GetPivot(); local diff = myPos - cf.Position; local sp, onS = Cam:WorldToViewportPoint(cf.Position)
            if onS and sp.Z > 0 then
                if diff.X^2 + diff.Y^2 + diff.Z^2 > maxDist^2 then d.HL.Enabled, d.BB.Enabled = false, false; if d.MellBB then d.MellBB.Enabled = false end; if d.Box2D then d.Box2D.Visible = false end; continue end
                d.LastDist = math.floor(diff.Magnitude); local dText = mellMode and ("ФПВ друн ["..d.LastDist.."m]") or ("ДРОН ["..d.LastDist.."m]")
                if dMode == 1 then d.HL.Enabled, d.BB.Enabled = true, true; d.T3D.Text = dText; if d.MellBB then d.MellBB.Enabled = mellMode end
                else d.HL.Enabled, d.BB.Enabled = false, false; if d.MellBB then d.MellBB.Enabled = false end end
                if dMode == 2 and d.Box2D then
                    local pos, onS = Cam:WorldToViewportPoint(cf.Position); local size = m:GetExtentsSize(); local dist = (Cam.CFrame.Position - cf.Position).Magnitude
                    local screenSize = (size.X / dist) * 500; if screenSize < 20 then screenSize = 20 end
                    d.Box2D.Size = UDim2.new(0, screenSize, 0, screenSize); d.Box2D.Position = UDim2.new(0, pos.X - screenSize/2, 0, pos.Y - screenSize/2); d.Box2D.Visible = true
                else if d.Box2D then d.Box2D.Visible = false end end
            else d.HL.Enabled, d.BB.Enabled = false, false; if d.MellBB then d.MellBB.Enabled = false end; if d.Box2D then d.Box2D.Visible = false end end
        end
    end
end

table.insert(conns, RunService.Heartbeat:Connect(updateESP))

-- СПИН
table.insert(conns, RunService.RenderStepped:Connect(function()
    if spinEnabled and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LP.Character.HumanoidRootPart; local oldCam = Cam.CFrame
        hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(15), 0); Cam.CFrame = oldCam
    end
end))

btnKill.MouseButton1Click:Connect(function()
    if weatherPart then weatherPart:Destroy() end
    if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then local bv = LP.Character.HumanoidRootPart:FindFirstChild("FlyBV"); if bv then bv:Destroy() end end
    if LP.Character and LP.Character:FindFirstChild("Humanoid") then LP.Character.Humanoid.WalkSpeed = 16; LP.Character.Humanoid.PlatformStand = false end
    if Cam then Cam.FieldOfView = 70 end
    for _,c in ipairs(conns) do pcall(function() c:Disconnect() end) end
    gui:Destroy(); if loadGui then loadGui:Destroy() end
end)

closeBtn.MouseButton1Click:Connect(function() toggleMenu(false) end)

updateUI()
switchTab(tabVis, pageVis)