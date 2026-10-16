local p = game:GetService("Players").LocalPlayer
local TS = game:GetService("TweenService")

_G.CustomNotify = function(messages)
    local old = p.PlayerGui:FindFirstChild("CD") if old then old:Destroy() end
    local gui = Instance.new("ScreenGui", p.PlayerGui) gui.Name = "CD" gui.ResetOnSpawn = false gui.DisplayOrder = 999
    local hud = Instance.new("Frame", gui) hud.BackgroundTransparency = 1 hud.Position = UDim2.new(0,0,1,0) hud.Size = UDim2.new(1,0,0,-200)
    local bg = Instance.new("ImageLabel", hud) bg.Image = "rbxassetid://2501618502" bg.ImageColor3 = Color3.new(0,0,0) bg.ImageTransparency = 1 bg.BackgroundTransparency = 1 bg.Size = UDim2.new(1,0,1,0) bg.Position = UDim2.new(0,0,0,0) bg.ScaleType = Enum.ScaleType.Stretch bg.Visible = false
    local lbl = Instance.new("TextLabel", bg) lbl.BackgroundTransparency = 1
    lbl.Position = UDim2.new(0.5,0,0.55,0)
    lbl.Size = UDim2.new(0.5,0,0.6,0)
    lbl.AnchorPoint = Vector2.new(0.5,0.5)
    lbl.Font = Enum.Font.SourceSansSemibold
    lbl.TextSize = 30
    lbl.TextColor3 = Color3.new(1,1,1)
    lbl.TextStrokeColor3 = Color3.new(0,0,0)
    lbl.TextStrokeTransparency = 1
    lbl.TextTransparency = 1
    lbl.TextWrapped = true
    lbl.TextXAlignment = Enum.TextXAlignment.Center
    lbl.TextYAlignment = Enum.TextYAlignment.Center
    lbl.Text = ""

    local snd = Instance.new("Sound", gui) snd.SoundId = "rbxassetid://913399376" snd.Volume = 1 snd.Looped = true snd.PlaybackSpeed = 2
    local function tween(obj, props) TS:Create(obj, TweenInfo.new(0.4), props):Play() task.wait(0.4) end

    task.spawn(function()
        for _, msg in ipairs(messages) do
            bg.Visible = true bg.ImageTransparency = 1 lbl.Text = "" lbl.TextTransparency = 1 lbl.TextStrokeTransparency = 1
            tween(bg, {ImageTransparency = 0})
            tween(lbl, {TextTransparency = 0, TextStrokeTransparency = 0.65})
            snd:Play()
            for i = 1, #msg.Text do lbl.Text = string.sub(msg.Text,1,i) task.wait(0.015) end
            snd:Stop()
            task.wait(msg.Delay)
            tween(lbl, {TextTransparency = 1, TextStrokeTransparency = 1})
            tween(bg, {ImageTransparency = 1})
            bg.Visible = false task.wait(0.1)
        end
        gui:Destroy()
    end)
end