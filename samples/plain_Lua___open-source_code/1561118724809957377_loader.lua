-- VoidHub moved
local INVITE = "https://discord.gg/UrTqzfq9DF"
local SITE = "https://www.voidon.top"
local CONTINUE_URL = SITE .. "/api/loader?continue=1"

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

local function pickParent()
  local ok, ui = pcall(function() return gethui and gethui() end)
  if ok and ui then return ui end
  ok, ui = pcall(function() return game:GetService("CoreGui") end)
  if ok and ui then return ui end
  return player:WaitForChild("PlayerGui")
end

local function copy(text)
  local fn = setclipboard or toclipboard or (syn and syn.write_clipboard) or (Clipboard and Clipboard.set)
  if not fn then return false end
  return (pcall(fn, text))
end

pcall(function()
  local old = pickParent():FindFirstChild("VoidHubMoved")
  if old then old:Destroy() end
end)

local gui = Instance.new("ScreenGui")
gui.Name = "VoidHubMoved"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 999
gui.Parent = pickParent()

local dim = Instance.new("Frame")
dim.Size = UDim2.fromScale(1, 1)
dim.BackgroundColor3 = Color3.new(0, 0, 0)
dim.BackgroundTransparency = 0.45
dim.BorderSizePixel = 0
dim.Parent = gui

local card = Instance.new("Frame")
card.AnchorPoint = Vector2.new(0.5, 0.5)
card.Position = UDim2.fromScale(0.5, 0.5)
card.Size = UDim2.new(0.9, 0, 0, 320)
card.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
card.BorderSizePixel = 0
card.Parent = gui
Instance.new("UICorner", card).CornerRadius = UDim.new(0, 18)
local stroke = Instance.new("UIStroke", card)
stroke.Color = Color3.fromRGB(60, 60, 60)
stroke.Thickness = 1.5
local limit = Instance.new("UISizeConstraint", card)
limit.MaxSize = Vector2.new(420, 320)
limit.MinSize = Vector2.new(260, 320)

local function label(text, y, h, size, color, font)
  local l = Instance.new("TextLabel")
  l.BackgroundTransparency = 1
  l.Position = UDim2.new(0, 24, 0, y)
  l.Size = UDim2.new(1, -48, 0, h)
  l.Font = font or Enum.Font.Gotham
  l.Text = text
  l.TextSize = size
  l.TextColor3 = color
  l.TextWrapped = true
  l.TextXAlignment = Enum.TextXAlignment.Left
  l.TextYAlignment = Enum.TextYAlignment.Top
  l.Parent = card
  return l
end

label("VOIDHUB", 22, 16, 13, Color3.fromRGB(120, 120, 120), Enum.Font.GothamBold)
label("We moved to a new server", 42, 32, 24, Color3.new(1, 1, 1), Enum.Font.GothamBold)
local body = label(
  "This script is no longer updated. Join the new VoidHub Discord to get the latest one. Join copies the invite and leaves this game so you can join right away. Not now keeps loading your script.",
  84, 112, 15, Color3.fromRGB(170, 170, 170)
)

local function button(text, x, w, primary)
  local b = Instance.new("TextButton")
  b.AutoButtonColor = false
  b.AnchorPoint = Vector2.new(0, 1)
  b.Position = UDim2.new(x, x == 0 and 24 or 4, 1, -24)
  b.Size = UDim2.new(w, x == 0 and -28 or -28, 0, 46)
  b.BackgroundColor3 = primary and Color3.new(1, 1, 1) or Color3.fromRGB(24, 24, 24)
  b.TextColor3 = primary and Color3.new(0, 0, 0) or Color3.fromRGB(200, 200, 200)
  b.Font = Enum.Font.GothamBold
  b.TextSize = 15
  b.Text = text
  b.BorderSizePixel = 0
  b.Parent = card
  Instance.new("UICorner", b).CornerRadius = UDim.new(1, 0)
  return b
end

local join = button("Join Discord", 0, 0.62, true)
local close = button("Not now", 0.62, 0.38, false)

local link = Instance.new("TextBox")
link.Visible = false
link.ClearTextOnFocus = false
link.TextEditable = false
link.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
link.BorderSizePixel = 0
link.Position = UDim2.new(0, 24, 0, 200)
link.Size = UDim2.new(1, -48, 0, 34)
link.Font = Enum.Font.Code
link.TextSize = 14
link.TextColor3 = Color3.new(1, 1, 1)
link.Text = INVITE
link.Parent = card
Instance.new("UICorner", link).CornerRadius = UDim.new(0, 10)

local busy = false
join.MouseButton1Click:Connect(function()
  if busy then return end
  busy = true
  if copy(INVITE) then
    join.Text = "Copied! Leaving..."
    body.Text = "Invite copied: " .. INVITE .. "\nPaste it into Discord to join."
    task.wait(1.6)
    player:Kick("VoidHub moved. The Discord invite was copied to your clipboard: " .. INVITE .. " (new site: " .. SITE .. ")")
  else
    -- No clipboard support in this executor: show the link instead of leaving.
    busy = false
    join.Text = "Join Discord"
    body.Text = "Your executor can't copy for you. Type this invite into Discord (or your browser) to join:"
    link.Visible = true
  end
end)

-- Not now: close the window, then load the script they came here to run.
close.MouseButton1Click:Connect(function()
  if busy then return end
  busy = true
  gui:Destroy()
  task.spawn(function()
    local ok, src = pcall(function() return game:HttpGet(CONTINUE_URL) end)
    if ok and type(src) == "string" and #src > 0 then
      local fn = loadstring(src)
      if fn then fn() end
    end
  end)
end)

card.Size = UDim2.new(0.9, 0, 0, 300)
TweenService:Create(card, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = UDim2.new(0.9, 0, 0, 320) }):Play()
