-- [[ 🍓✨ sprout script scan 🍓 ]] --
-- [[ 🎀 VERSION: AVATAR SCAN PRO + PRICE CHECK 🎀 ]] --

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local MarketplaceService = game:GetService("MarketplaceService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

if game.CoreGui:FindFirstChild("SproutUltra") then game.CoreGui.SproutUltra:Destroy() end

local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "SproutUltra"
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 999 

-- [[ 🛠️ Drag Logic ]]
local function MakeDraggable(obj)
    local dragging, dragStart, startPos
    obj.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true dragStart = input.Position startPos = obj.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function() dragging = false end)
end

-- [[ 🍓 Mini Icon ]]
local MiniIcon = Instance.new("TextButton", ScreenGui)
MiniIcon.Size = UDim2.new(0, 65, 0, 65); MiniIcon.Position = UDim2.new(0, 50, 0, 50)
MiniIcon.Text = "🍓"; MiniIcon.TextSize = 40; MiniIcon.BackgroundColor3 = Color3.fromRGB(255, 40, 80)
MiniIcon.ZIndex = 2000; MiniIcon.Visible = false; Instance.new("UICorner", MiniIcon).CornerRadius = UDim.new(1, 0)
local IconStroke = Instance.new("UIStroke", MiniIcon); IconStroke.Color = Color3.new(1,1,1); IconStroke.Thickness = 3
MakeDraggable(MiniIcon)

-- [[ 🏰 Main Frame ]]
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 410, 0, 450); MainFrame.Position = UDim2.new(0.5, -205, 0.5, -225)
MainFrame.BackgroundColor3 = Color3.fromRGB(255, 240, 245); MainFrame.ZIndex = 10; Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 20)
local MainStroke = Instance.new("UIStroke", MainFrame); MainStroke.Color = Color3.fromRGB(255, 105, 180); MainStroke.Thickness = 2
MakeDraggable(MainFrame)

-- [[ 🎀 Header ]]
local Header = Instance.new("Frame", MainFrame)
Header.Size = UDim2.new(1, 0, 0, 45); Header.BackgroundColor3 = Color3.fromRGB(255, 40, 80); Header.ZIndex = 100; Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 20)
local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, 0, 1, 0); Title.Position = UDim2.new(0, 15, 0, 0); Title.ZIndex = 101
Title.Text = "🍓 SPROUT SCRIPT SCAN ULTIMATE 🍓"; Title.TextColor3 = Color3.new(1, 1, 1); Title.Font = Enum.Font.FredokaOne; Title.TextSize = 16; Title.TextXAlignment = 0; Title.BackgroundTransparency = 1

local CloseBtn = Instance.new("TextButton", Header); CloseBtn.Size = UDim2.new(0, 30, 0, 30); CloseBtn.Position = UDim2.new(1, -35, 0, 7.5); CloseBtn.ZIndex = 102; CloseBtn.Text = "❌"; CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0); Instance.new("UICorner", CloseBtn)
local MiniBtn = Instance.new("TextButton", Header); MiniBtn.Size = UDim2.new(0, 30, 0, 30); MiniBtn.Position = UDim2.new(1, -70, 0, 7.5); MiniBtn.ZIndex = 102; MiniBtn.Text = "➖"; MiniBtn.BackgroundColor3 = Color3.fromRGB(255, 150, 180); Instance.new("UICorner", MiniBtn)

MiniBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false; MiniIcon.Visible = true end)
MiniIcon.MouseButton1Click:Connect(function() MainFrame.Visible = true; MiniIcon.Visible = false end)
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- [[ Pages ]]
local ScanPage = Instance.new("Frame", MainFrame); ScanPage.Size = UDim2.new(1, 0, 1, -45); ScanPage.Position = UDim2.new(0, 0, 0, 45); ScanPage.BackgroundTransparency = 1; ScanPage.ZIndex = 20
local AiPage = Instance.new("Frame", MainFrame); AiPage.Size = UDim2.new(1, 0, 1, -45); AiPage.Position = UDim2.new(0, 0, 0, 45); AiPage.BackgroundTransparency = 1; AiPage.Visible = false; AiPage.ZIndex = 20
local ItemPage = Instance.new("Frame", MainFrame); ItemPage.Size = UDim2.new(1, 0, 1, -45); ItemPage.Position = UDim2.new(0, 0, 0, 45); ItemPage.BackgroundTransparency = 1; ItemPage.Visible = false; ItemPage.ZIndex = 20

local function ShowPage(page)
    ScanPage.Visible = false; AiPage.Visible = false; ItemPage.Visible = false; page.Visible = true
end

-- [[ 👕 Avatar Scan Page (UPGRADED) ]]
local ItemList = Instance.new("ScrollingFrame", ItemPage); ItemList.Size = UDim2.new(0.94, 0, 0.8, 0); ItemList.Position = UDim2.new(0.03, 0, 0.02, 0); ItemList.ZIndex = 25; ItemList.BackgroundTransparency = 0.9; ItemList.AutomaticCanvasSize = Enum.AutomaticSize.Y; Instance.new("UIListLayout", ItemList).Padding = UDim.new(0, 5)

local BackToScan1 = Instance.new("TextButton", ItemPage); BackToScan1.Size = UDim2.new(0.94, 0, 0, 35); BackToScan1.Position = UDim2.new(0.03, 0, 0.85, 5); BackToScan1.Text = "🍓 GO BACK"; BackToScan1.BackgroundColor3 = Color3.fromRGB(255, 40, 80); BackToScan1.TextColor3 = Color3.new(1,1,1); BackToScan1.ZIndex = 30; Instance.new("UICorner", BackToScan1)
BackToScan1.MouseButton1Click:Connect(function() ShowPage(ScanPage) end)

local function ScanAvatar(p)
    for _, v in pairs(ItemList:GetChildren()) do if v:IsA("Frame") then v:Destroy() end end
    local success, result = pcall(function() return Players:GetCharacterAppearanceInfoAsync(p.UserId) end)
    
    if success and result and result.assets then
        for _, item in pairs(result.assets) do
            local f = Instance.new("Frame", ItemList); f.Size = UDim2.new(1, -10, 0, 65); f.BackgroundColor3 = Color3.fromRGB(255, 235, 245); f.ZIndex = 26; Instance.new("UICorner", f)
            local img = Instance.new("ImageLabel", f); img.Size = UDim2.new(0, 55, 0, 55); img.Position = UDim2.new(0, 5, 0, 5); img.Image = "rbxthumb://type=Asset&id="..item.id.."&w=150&h=150"; img.ZIndex = 27; Instance.new("UICorner", img)
            local txt = Instance.new("TextLabel", f); txt.Size = UDim2.new(1, -70, 1, 0); txt.Position = UDim2.new(0, 65, 0, 0); txt.TextXAlignment = 0; txt.TextSize = 10; txt.BackgroundTransparency = 1; txt.ZIndex = 27; txt.TextWrapped = true; txt.TextColor3 = Color3.fromRGB(150, 0, 50); txt.Text = "🌸 Loading Item..."

            spawn(function()
                local s, info = pcall(function() return MarketplaceService:GetProductInfo(item.id) end)
                if s and info then
                    local priceText = "Offsale/Event"
                    if info.IsForSale then
                        priceText = (info.PriceInRobux and info.PriceInRobux > 0) and "💰 "..info.PriceInRobux.." Robux" or "✨ FREE ✨"
                    end
                    txt.Text = "🎀 Name: "..info.Name.."\n🏷️ Type: "..(info.AssetTypeId == 8 and "Hat" or info.AssetTypeId == 11 and "Shirt" or info.AssetTypeId == 12 and "Pants" or "Accessory").."\n"..priceText
                else
                    txt.Text = "🍓 Unknown Item (Private/Deleted)"
                end
            end)
        end
    else
        local l = Instance.new("TextLabel", ItemList); l.Size = UDim2.new(1,0,0,50); l.Text = "🍓 No items found or profile private"; l.BackgroundTransparency = 1; l.TextColor3 = Color3.new(1,0,0)
    end
end

-- [[ 🤖 AI Chat Page ]]
local ChatLog = Instance.new("ScrollingFrame", AiPage); ChatLog.Size = UDim2.new(0.94, 0, 0.45, 0); ChatLog.Position = UDim2.new(0.03, 0, 0.02, 0); ChatLog.ZIndex = 21; ChatLog.BackgroundTransparency = 0.8; ChatLog.BackgroundColor3 = Color3.new(1,1,1); ChatLog.AutomaticCanvasSize = Enum.AutomaticSize.Y
local ChatList = Instance.new("UIListLayout", ChatLog); ChatList.Padding = UDim.new(0, 5); ChatList.SortOrder = Enum.SortOrder.LayoutOrder
local QFrame = Instance.new("ScrollingFrame", AiPage); QFrame.Size = UDim2.new(0.94, 0, 0.38, 0); QFrame.Position = UDim2.new(0.03, 0, 0.5, 0); QFrame.ZIndex = 21; Instance.new("UIGridLayout", QFrame).CellSize = UDim2.new(0, 95, 0, 25)
local BackToScan2 = Instance.new("TextButton", AiPage); BackToScan2.Size = UDim2.new(0.94, 0, 0, 30); BackToScan2.Position = UDim2.new(0.03, 0, 0.9, 0); BackToScan2.Text = "🍓 GO BACK"; BackToScan2.BackgroundColor3 = Color3.fromRGB(255, 40, 80); BackToScan2.TextColor3 = Color3.new(1,1,1); BackToScan2.ZIndex = 30; Instance.new("UICorner", BackToScan2)
BackToScan2.MouseButton1Click:Connect(function() ShowPage(ScanPage) end)

local function GeminiThink(msg)
    if not Target then return "🍓 Please select a strawberry target! 🍓" end
    local res = {
        ["hello"] = "Sawatdee ka! 🍓 Scanning @"..Target.Name.." for secrets!",
        ["hi"] = "Hi there! Strawberry power is at 100%! ✨",
        ["yo"] = "Yo! Ready to look at @"..Target.Name.."? 🍓👑",
        ["roast"] = "Target @"..Target.Name.." has no drip! Only seeds! 🔥",
        ["love"] = "Strawberry hearts forever! 💖🍓",
        ["noob"] = "Noob alert! @"..Target.Name.." is definitely a noob! 😂",
        ["how are you?"] = "I'm feeling very pink and happy! 🍓✨",
        ["who is owner?"] = "You're the boss of this garden! 🍓👸",
        ["bye bye"] = "Bye! Stay sweet like a berry! 🍓👋",
        ["dance"] = "Strawberry wiggle! 💃🍓",
        ["sus"] = "RED SUS! @"..Target.Name.." is the one! 📮",
        ["eat strawberry?"] = "Yes please! 🍓😋 Yum!",
        ["afk?"] = "They're staring at the wall! 💤",
        ["help me"] = "What do you need, Boss? Sprout is here! 💪",
        ["happy"] = "Yay! Happy strawberry day! 🍓🌈"
    }
    return res[msg:lower()] or "🍓 Sprout: I'm thinking about that berry much! ✨"
end

local function addQ(txt)
    local b = Instance.new("TextButton", QFrame); b.Text = "🍓 "..txt; b.BackgroundColor3 = Color3.fromRGB(255, 200, 220); b.TextSize = 8; b.ZIndex = 22; b.TextColor3 = Color3.fromRGB(150, 0, 50); Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function()
        local l = Instance.new("TextLabel", ChatLog); l.Size = UDim2.new(1,0,0,20); l.Text = "👤 You: "..txt; l.BackgroundTransparency = 1; l.TextSize = 10; l.ZIndex = 23; l.TextColor3 = Color3.fromRGB(50,50,50)
        local r = Instance.new("TextLabel", ChatLog); r.Size = UDim2.new(1,0,0,20); r.Text = "🤖 Sprout: "..GeminiThink(txt); r.TextColor3 = Color3.fromRGB(255, 40, 80); r.BackgroundTransparency = 1; r.TextSize = 10; r.ZIndex = 23; r.Font = Enum.Font.SourceSansBold
        task.wait(0.05)
        ChatLog.CanvasPosition = Vector2.new(0, ChatList.AbsoluteContentSize.Y - ChatLog.AbsoluteSize.Y)
    end)
end
local qs = {"Hello", "Hi", "Yo", "Roast", "Love", "Noob", "How are you?", "Who is owner?", "Bye bye", "Dance", "Sus", "Eat Strawberry?", "AFK?", "Help Me", "Happy"}
for _, q in pairs(qs) do addQ(q) end

-- [[ 🔍 Scan Page Main UI ]]
local List = Instance.new("ScrollingFrame", ScanPage); List.Size = UDim2.new(0.44, 0, 0.85, 0); List.Position = UDim2.new(0.03, 0, 0.1, 0); List.BackgroundTransparency = 0.95; List.ZIndex = 21; Instance.new("UIListLayout", List).Padding = UDim.new(0, 8)
local InfoSide = Instance.new("Frame", ScanPage); InfoSide.Size = UDim2.new(0.5, 0, 0.95, 0); InfoSide.Position = UDim2.new(0.48, 0, 0.02, 0); InfoSide.BackgroundTransparency = 1; InfoSide.ZIndex = 21
local Avatar = Instance.new("ImageLabel", InfoSide); Avatar.Size = UDim2.new(0, 85, 0, 85); Avatar.Position = UDim2.new(0.5, -42.5, 0, 5); Avatar.ZIndex = 22; Instance.new("UICorner", Avatar); local AvStroke = Instance.new("UIStroke", Avatar); AvStroke.Color = Color3.fromRGB(255, 40, 80); AvStroke.Thickness = 2
local InfoTxt = Instance.new("TextLabel", InfoSide); InfoTxt.Size = UDim2.new(1, 0, 0, 200); InfoTxt.Position = UDim2.new(0, 0, 0, 95); InfoTxt.Text = "🍓 Select a Target"; InfoTxt.TextSize = 8; InfoTxt.BackgroundTransparency = 1; InfoTxt.ZIndex = 22; InfoTxt.TextYAlignment = 0; InfoTxt.TextColor3 = Color3.fromRGB(150, 0, 50)

local function createBtn(txt, pos, col)
    local b = Instance.new("TextButton", InfoSide); b.Size = UDim2.new(1, 0, 0, 25); b.Position = pos; b.Text = txt; b.BackgroundColor3 = col; b.TextColor3 = Color3.new(1,1,1); b.Visible = false; b.ZIndex = 23; b.TextSize = 8.5; Instance.new("UICorner", b); return b
end

local FolBtn = createBtn("🎀 FOLLOW", UDim2.new(0,0,1,-130), Color3.fromRGB(255, 40, 80))
local TpBtn = createBtn("🚀 TELEPORT", UDim2.new(0,0,1,-102), Color3.fromRGB(255, 105, 180))
local TBtn = createBtn("👕 AVATAR SCAN", UDim2.new(0,0,1,-74), Color3.fromRGB(150, 80, 255))
local AiBtn = createBtn("🤖 AI CHAT", UDim2.new(0,0,1,-46), Color3.fromRGB(255, 80, 150))
local StopPovBtn = createBtn("🎥 STOP POV", UDim2.new(0,0,1,-18), Color3.fromRGB(180, 0, 0))

StopPovBtn.MouseButton1Click:Connect(function()
    Camera.CameraSubject = LocalPlayer.Character or LocalPlayer
end)

local FollowConnection; local Following = false
FolBtn.MouseButton1Click:Connect(function()
    Following = not Following
    FolBtn.Text = Following and "🍓 FOLLOWING..." or "🎀 FOLLOW"
    FolBtn.BackgroundColor3 = Following and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(255, 40, 80)
    if Following then
        FollowConnection = RunService.Stepped:Connect(function()
            if Target and Target.Character and Target.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = Target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3.5)
            end
        end)
    elseif FollowConnection then FollowConnection:Disconnect() end
end)

TpBtn.MouseButton1Click:Connect(function() if Target and Target.Character then LocalPlayer.Character.HumanoidRootPart.CFrame = Target.Character.HumanoidRootPart.CFrame * CFrame.new(0,0,2) end end)
AiBtn.MouseButton1Click:Connect(function() ShowPage(AiPage) end)
TBtn.MouseButton1Click:Connect(function() ShowPage(ItemPage); ScanAvatar(Target) end)

local function Refresh()
    for _, v in pairs(List:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
    for _, p in pairs(Players:GetPlayers()) do
        local b = Instance.new("TextButton", List); b.Size = UDim2.new(1, -8, 0, 35); b.Text = "👤 "..p.DisplayName; b.BackgroundColor3 = Color3.fromRGB(255, 215, 230); b.TextSize = 10; b.ZIndex = 22; Instance.new("UICorner", b)
        b.MouseButton1Click:Connect(function()
            Target = p; Avatar.Image = "rbxthumb://type=AvatarHeadShot&id="..p.UserId.."&w=150&h=150"
            Camera.CameraSubject = p.Character or p
            local dev = UserInputService.TouchEnabled and "📱 Mobile" or "💻 PC"
            local igFriends = 0; for _, o in pairs(Players:GetPlayers()) do if o ~= p and p:IsFriendsWith(o.UserId) then igFriends = igFriends + 1 end end
            spawn(function()
                local s, r = pcall(function() return Players:GetFriendsAsync(p.UserId) end)
                local total = (s and r) and tostring(#r:GetCurrentPage()).."+" or "Private"
                if Target == p then
                    InfoTxt.Text = "🎀 Name: "..p.Name.."\n🌸 Nick: "..p.DisplayName.."\n⏳ Age: "..p.AccountAge.."d\n🎮 Device: "..dev.."\n❤️ HP: "..(p.Character and p.Character:FindFirstChild("Humanoid") and math.floor(p.Character.Humanoid.Health) or "0").."\n👥 In-Game: "..igFriends.."\n🌎 Total Friends: "..total
                end
            end)
            FolBtn.Visible, TpBtn.Visible, TBtn.Visible, AiBtn.Visible, StopPovBtn.Visible = true, true, true, true, true
        end)
    end
end
Players.PlayerAdded:Connect(Refresh); Players.PlayerRemoving:Connect(Refresh); Refresh()
