local new = Instance.new("ScreenGui")
local new_1 = Instance.new("TextLabel")
local service = game.GetService(game, "CoreGui")
new.Parent = service
new_1.Parent = new
new_1.Size = UDim2.new(0, 600, 0, 200)
new_1.Position = UDim2.new(0.5, -300, 0.5, -100)
new_1.Text = [[Felix's Streamable
Silent]]
new_1.Font = Enum.Font.Arcade
new_1.TextSize = 50
new_1.TextColor3 = Color3.fromRGB(255, 0, 0)
new_1.BackgroundTransparency = 1
new_1.TextTransparency = 1
new_1.TextStrokeTransparency = 0
new_1.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
new_1.TextWrapped = true
new_1.TextYAlignment = Enum.TextYAlignment.Center
Instance.new("BlurEffect").Size = 0
local service = game.GetService(game, "Lighting")
Instance.new("BlurEffect").Parent = service
for l_7 = 1, 100, 1 do
  Instance.new("BlurEffect").Size = r7 * 0.1
  new_1.TextTransparency = 1 - r7 / 100
  task.wait(0.01)
end
task.spawn(function(a0)
  while true do
    for l_4 = 0, 1, 0.01 do
      local from_h_s_v = Color3.fromHSV(r4, 1, 1)
      a0.TextColor3 = from_h_s_v
      task.wait(0.05)
    end
  end
end, new_1)
task.wait(5)
for l_7 = 1, 100, 1 do
  Instance.new("BlurEffect").Size = 10 - r7 * 0.1
  new_1.TextTransparency = r7 / 100
  task.wait(0.01)
end
Instance.new("BlurEffect").Destroy(Instance.new("BlurEffect"))
new.Destroy(new)
local getgenv = getgenv()
getgenv.Silent = {
  Settings = {
    Toggled = true,
    AimPart = "UpperTorso",
    HitChance = 9999,
    Prediction = {
      Toggled = true,
      Value = 0.124231,
      AutoPred = false,
      JumpOffset = 0.08,
      AntiGroundShots = true,
      Resolve = false
    },
    Circle = {
      Visible = false,
      Transparency = 0.5,
      Thickness = 3,
      NumSides = 100,
      Radius = 100,
      Filled = false
    },
    RainbowTarget = false,
    WallCheck = true,
    AutoShoot = false,
    BulletTp = false,
    FriendCheck = false
  }
}
loadstring()()
