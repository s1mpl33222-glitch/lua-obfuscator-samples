-- 잼 Hub 통합 로더 (Jam Hub Universal Loader)
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer

-- 링크 정의
local scripts = {
    FrozenTag = "https://gist.githubusercontent.com/lunarbentony-cmyk/934dd3e8793e4c4b3b2dce3029a2c9d7/raw/088e6087bf0c3fa06e202724f32434037e122045/jamhub.lua",
    Rivals = "https://gist.githubusercontent.com/lunarbentony-cmyk/4bf229b3b42966b46ad278fb2bcf4624/raw/84b592e8e2ef10a69bc32a22b48e3187cc9fcbba/jamhub.lua",
    BombHitbox = "https://gist.githubusercontent.com/lunarbentony-cmyk/94309f0675f95c808229a61e71ec35b2/raw/1719004c7423f3286f25790493a67ee541a35e63/jamhub.lua",
    Backstep = "https://gist.githubusercontent.com/lunarbentony-cmyk/eb6b700d5bb4e366cddb2d77e457512d/raw/1b6019c5f79b87c4cb887bbcd0a5b2c83a9e8c70/jamhub.lua"
}

-- 기존 UI 제거
if CoreGui:FindFirstChild("JamHubUniversalLoader") then
    CoreGui.JamHubUniversalLoader:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "JamHubUniversalLoader"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
if syn and syn.protect_gui then
    syn.protect_gui(ScreenGui)
    ScreenGui.Parent = CoreGui
elseif gethui then
    ScreenGui.Parent = gethui()
else
    ScreenGui.Parent = CoreGui
end

-- 메인 프레임 (버튼이 4개로 늘어나서 세로 크기를 330으로 조정)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 360, 0, 330)
MainFrame.Position = UDim2.new(0.5, -180, 0.5, -165)
MainFrame.BackgroundColor3 = Color3.fromRGB(16, 16, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(40, 40, 50)
MainStroke.Thickness = 1
MainStroke.Transparency = 0.4
MainStroke.Parent = MainFrame

-- 탑바
local Topbar = Instance.new("Frame")
Topbar.Size = UDim2.new(1, 0, 0, 42)
Topbar.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
Topbar.BorderSizePixel = 0
Topbar.Parent = MainFrame

local TopbarCorner = Instance.new("UICorner")
TopbarCorner.CornerRadius = UDim.new(0, 12)
TopbarCorner.Parent = Topbar

local TopbarCover = Instance.new("Frame")
TopbarCover.Size = UDim2.new(1, 0, 0, 14)
TopbarCover.Position = UDim2.new(0, 0, 1, -14)
TopbarCover.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
TopbarCover.BorderSizePixel = 0
TopbarCover.Parent = Topbar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -50, 1, 0)
TitleLabel.Position = UDim2.new(0, 16, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "잼 Hub  ·  v1.0"
TitleLabel.TextColor3 = Color3.fromRGB(240, 240, 245)
TitleLabel.TextSize = 15
TitleLabel.Font = Enum.Font.GothamMedium
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = Topbar

-- 닫기 버튼
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Position = UDim2.new(1, -35, 0.5, -14)
CloseBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.fromRGB(180, 180, 190)
CloseBtn.TextSize = 18
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.BorderSizePixel = 0
CloseBtn.Parent = Topbar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)

-- 드래그
local dragging, dragStart, startPos = false, nil, nil
Topbar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)
Topbar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- 컨텐츠
local Container = Instance.new("Frame")
Container.Size = UDim2.new(1, -32, 1, -58)
Container.Position = UDim2.new(0, 16, 0, 50)
Container.BackgroundTransparency = 1
Container.Parent = MainFrame

local UIList = Instance.new("UIListLayout")
UIList.SortOrder = Enum.SortOrder.LayoutOrder
UIList.Padding = UDim.new(0, 10)
UIList.Parent = Container

-- 안내 텍스트
local DescLabel = Instance.new("TextLabel")
DescLabel.Size = UDim2.new(1, 0, 0, 32)
DescLabel.BackgroundTransparency = 1
DescLabel.Text = "실행할 스크립트를 선택하세요  ·  RightShift 로 창 토글"
DescLabel.TextColor3 = Color3.fromRGB(140, 140, 155)
DescLabel.TextSize = 12
DescLabel.Font = Enum.Font.Gotham
DescLabel.TextXAlignment = Enum.TextXAlignment.Left
DescLabel.TextWrapped = true
DescLabel.LayoutOrder = 1
DescLabel.Parent = Container

-- 버튼 생성 함수
local function createButton(text, color, order)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 44)
    btn.BackgroundColor3 = color
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamMedium
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.LayoutOrder = order
    btn.Parent = Container

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Thickness = 1
    stroke.Transparency = 0.85
    stroke.Parent = btn

    -- 호버 효과
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundTransparency = 0.15}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundTransparency = 0}):Play()
    end)

    return btn
end

local FrozenBtn = createButton("🧊  한국 얼음땡 스크립트 실행", Color3.fromRGB(45, 110, 200), 2)
local RivalsBtn = createButton("⚔️  라이벌(Rivals) 올 스킨 실행", Color3.fromRGB(200, 85, 45), 3)
local BombBtn = createButton("💣  폭탄돌리기 히트박스 실행", Color3.fromRGB(90, 50, 140), 4)
local BackstepBtn = createButton("💨  백스텝 (유니버셜) 실행", Color3.fromRGB(35, 130, 80), 5)

-- 클릭 이벤트 함수 바인딩
local function bindScript(btn, scriptUrl)
    btn.MouseButton1Click:Connect(function()
        local original = btn.Text
        btn.Text = "로딩 중..."
        pcall(function()
            loadstring(game:HttpGet(scriptUrl))()
        end)
        btn.Text = "✓  로드 완료"
        task.wait(1.4)
        btn.Text = original
    end)
end

bindScript(FrozenBtn, scripts.FrozenTag)
bindScript(RivalsBtn, scripts.Rivals)
bindScript(BombBtn, scripts.BombHitbox)
bindScript(BackstepBtn, scripts.Backstep)

-- RightShift 토글
UserInputService.InputBegan:Connect(function(input, gp)
    if not gp and input.KeyCode == Enum.KeyCode.RightShift then
        MainFrame.Visible = not MainFrame.Visible
    end
end)