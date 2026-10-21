--[[ 🛡️ Protected by LuaShield Obfuscator v2.4 ]]--
--[[ Timestamp: 2026-10-21T21:47:37.261Z ]]--

(function()
    
    
    
    local _0x8a738           = game:GetService(string.char(95, 48, 120, 56, 97, 55, 51, 56))
    local _0x428d09 = game:GetService(string.char(95, 48, 120, 52, 50, 56, 100, 48, 57))
    local _0x11a3b9         = game:GetService(string.char(95, 48, 120, 49, 49, 97, 51, 98, 57))
    
    local _0xb5ef4d   = _0x8a738.LocalPlayer
    local _0x3fce39 = _0xb5ef4d.UserId
    
    
    local _0x8982ca = Instance.new(string.char(83, 99, 114, 101, 101, 110, 71, 117, 105))
    _0x8982ca.Name           = string.char(84, 114, 101, 97, 100, 109, 105, 108, 108, 84, 80)
    _0x8982ca.ResetOnSpawn   = false
    _0x8982ca.IgnoreGuiInset = true
    _0x8982ca.Parent         = _0xb5ef4d:WaitForChild(string.char(80, 108, 97, 121, 101, 114, 71, 117, 105))
    
    local _0x8b9032 = Instance.new(string.char(84, 101, 120, 116, 66, 117, 116, 116, 111, 110))
    _0x8b9032.Size             = UDim2.new(0, 200, 0, 50)
    _0x8b9032.Position         = UDim2.new(0, 30, 0, 130)
    _0x8b9032.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
    _0x8b9032.TextColor3       = Color3.new(1, 1, 1)
    _0x8b9032.Font             = Enum.Font.GothamBold
    _0x8b9032.TextSize         = 16
    _0x8b9032.Text             = string.char(55356, 57283, 32, 32, 73, 114, 32, 112, 97, 114, 97, 32, 84, 114, 101, 97, 100, 109, 105, 108, 108)
    _0x8b9032.BorderSizePixel  = 0
    _0x8b9032.AutoButtonColor  = true
    _0x8b9032.Parent           = _0x8982ca
    
    local _0xd39fc1 = Instance.new(string.char(85, 73, 67, 111, 114, 110, 101, 114))
    _0xd39fc1.CornerRadius = UDim.new(0, 10)
    _0xd39fc1.Parent       = _0x8b9032
    
    local _0xedc078 = Instance.new(string.char(85, 73, 83, 116, 114, 111, 107, 101))
    _0xedc078.Color        = Color3.fromRGB(90, 200, 255)
    _0xedc078.Thickness    = 1.5
    _0xedc078.Transparency = 0.3
    _0xedc078.Parent       = _0x8b9032
    
    
    do
        local _0xa34232, dragStart, startPos
        _0x8b9032.InputBegan:Connect(_0xd83737(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
                _0xa34232, dragStart, startPos = true, input.Position, _0x8b9032.Position
                input.Changed:Connect(_0xd83737()
                    if input.UserInputState == Enum.UserInputState.End then
                        _0xa34232 = false
                    end
                end)
            end
        end)
        _0x8b9032.InputChanged:Connect(_0xd83737(input)
            if _0xa34232 and (input.UserInputType == Enum.UserInputType.MouseMovement
                         or input.UserInputType == Enum.UserInputType.Touch) then
                local _0xf73c6d = input.Position - dragStart
                _0x8b9032.Position = UDim2.new(
                    startPos.X.Scale, startPos.X.Offset + _0xf73c6d.X,
                    startPos.Y.Scale, startPos.Y.Offset + _0xf73c6d.Y)
            end
        end)
    end
    
    
    local _0xd83737 findPlotStateModule()
        local _0x709bee = _0x428d09:FindFirstChild(string.char(67, 108, 105, 101, 110, 116))
        if _0x709bee then
            local _0x8c840a = _0x709bee:FindFirstChild(string.char(80, 108, 111, 116, 83, 116, 97, 116, 101))
            if _0x8c840a and _0x8c840a:IsA(string.char(77, 111, 100, 117, 108, 101, 83, 99, 114, 105, 112, 116)) then return _0x8c840a end
        end
        for _, _0xf73c6d in ipairs(_0x428d09:GetDescendants()) do
            if _0xf73c6d:IsA(string.char(77, 111, 100, 117, 108, 101, 83, 99, 114, 105, 112, 116)) and _0xf73c6d.Name == string.char(80, 108, 111, 116, 83, 116, 97, 116, 101) then return _0xf73c6d end
        end
        return nil
    end
    
    local _0xd83737 loadPlotState()
        local _0x7561f8 = findPlotStateModule()
        if not _0x7561f8 then return nil, string.char(80, 108, 111, 116, 83, 116, 97, 116, 101, 32, 95, 48, 120, 101, 50, 100, 54, 100, 101, 227, 111, 32, 101, 110, 99, 111, 110, 116, 114, 97, 100, 111) end
        local _0x802fac, _0xe998e2 = pcall(require, _0x7561f8)
        if not _0x802fac then return nil, string.char(114, 101, 113, 117, 105, 114, 101, 32, 102, 97, 108, 104, 111, 117, 58, 32) .. tostring(_0xe998e2) end
        return _0xe998e2
    end
    
    local _0xd83737 readOwnersLive(_0xe998e2)
        if type(_0xe998e2.ReadOwners) == string.char(95, 48, 120, 100, 56, 51, 55, 51, 55) then
            local _0x802fac, res = pcall(_0xe998e2.ReadOwners)
            if _0x802fac and type(res) == string.char(116, 97, 98, 108, 101) then
                local _0xc041a6 = {}
                for k, v in pairs(res) do
                    local _0x5401a8, uid
                    if type(k) == string.char(110, 117, 109, 98, 101, 114) and type(v) == string.char(110, 117, 109, 98, 101, 114) then
                        _0x5401a8, uid = k, v
                    elseif type(k) == string.char(110, 117, 109, 98, 101, 114) and type(v) == string.char(116, 97, 98, 108, 101) then
                        _0x5401a8 = k
                        uid = v.UserId or v.OwnerUserId or v.owner
                    elseif type(k) == string.char(115, 116, 114, 105, 110, 103) then
                        _0x5401a8 = tonumber(k:match(string.char(37, 95, 48, 120, 102, 55, 51, 99, 54, 100, 43)))
                        if type(v) == string.char(116, 97, 98, 108, 101) then uid = v.UserId or v.OwnerUserId or v.owner
                        else uid = v end
                    end
                    if _0x5401a8 and uid then _0xc041a6[_0x5401a8] = tonumber(uid) end
                end
                if next(_0xc041a6) then return _0xc041a6 end
            end
        end
        if type(_0xe998e2.LookupOwner) == string.char(95, 48, 120, 100, 56, 51, 55, 51, 55) then
            local _0xc041a6 = {}
            for _0x5401a8 = 1, 7 do
                local _0x802fac, uid = pcall(_0xe998e2.LookupOwner, _0x5401a8)
                if _0x802fac and uid then
                    uid = tonumber(uid)
                    if uid then _0xc041a6[_0x5401a8] = uid end
                end
            end
            if next(_0xc041a6) then return _0xc041a6 end
        end
        return nil
    end
    
    local _0xd83737 findMySlot()
        local _0xe998e2 = loadPlotState()
        if not _0xe998e2 then return nil end
    
        if type(_0xe998e2.ResolveLocalSlot) == string.char(95, 48, 120, 100, 56, 51, 55, 51, 55) then
            local _0x802fac, res = pcall(_0xe998e2.ResolveLocalSlot)
            if _0x802fac and res ~= nil then
                local _0xe2d6de
                if type(res) == string.char(110, 117, 109, 98, 101, 114) then _0xe2d6de = res
                elseif typeof(res) == string.char(73, 110, 115, 116, 97, 110, 99, 101) then _0xe2d6de = tonumber(res.Name:match(string.char(37, 95, 48, 120, 102, 55, 51, 99, 54, 100, 43)))
                elseif type(res) == string.char(116, 97, 98, 108, 101) then
                    _0xe2d6de = tonumber(tostring(res.Slot or res._0x5401a8 or string.char()):match(string.char(37, 95, 48, 120, 102, 55, 51, 99, 54, 100, 43)))
                end
                if _0xe2d6de then return _0xe2d6de end
            end
        end
    
        local _0x6d649f = readOwnersLive(_0xe998e2)
        if _0x6d649f then
            for _0x5401a8, uid in pairs(_0x6d649f) do
                if uid == _0x3fce39 then return _0x5401a8 end
            end
        end
        return nil
    end
    
    
    local _0xd83737 findRender(_0x5401a8)
        local _0xe8974e = _0x11a3b9:FindFirstChild(string.char(95, 95, 67, 108, 105, 101, 110, 116, 84, 114, 101, 97, 100, 109, 105, 108, 108, 82, 101, 110, 100, 101, 114, 115))
        if not _0xe8974e then return nil end
        local _0x58ea29 = _0xe8974e:FindFirstChild(string.char(84, 114, 101, 97, 100, 109, 105, 108, 108, 82, 101, 110, 100, 101, 114, 95) .. _0x5401a8)
        if _0x58ea29 then return _0x58ea29 end
        for _, _0xd39fc1 in ipairs(_0xe8974e:GetChildren()) do
            if _0xd39fc1.Name:match(string.char(95) .. _0x5401a8 .. string.char(36)) then return _0xd39fc1 end
        end
        return nil
    end
    
    
    local _0xd83737 teleport()
        local _0x5401a8 = findMySlot()
        if not _0x5401a8 then return false, string.char(112, 108, 111, 116, 32, 95, 48, 120, 101, 50, 100, 54, 100, 101, 227, 111, 32, 101, 110, 99, 111, 110, 116, 114, 97, 100, 111) end
    
        local _0xaedeb5 = findRender(_0x5401a8)
        if not _0xaedeb5 then return false, string.char(95, 48, 120, 97, 101, 100, 101, 98, 53, 32, 100, 111, 32, 112, 108, 111, 116, 32) .. _0x5401a8 .. string.char(32, 95, 48, 120, 101, 50, 100, 54, 100, 101, 227, 111, 32, 101, 120, 105, 115, 116, 101) end
    
        local _0x74683b = _0xaedeb5:FindFirstChild(string.char(82, 111, 111, 116), true)
        if not _0x74683b or not _0x74683b:IsA(string.char(66, 97, 115, 101, 80, 97, 114, 116)) then
            return false, string.char(82, 111, 111, 116, 32, 105, 110, 118, 225, 108, 105, 100, 111)
        end
    
        local _0xa35b8c = _0xb5ef4d.Character and _0xb5ef4d.Character:FindFirstChild(string.char(72, 117, 109, 97, 110, 111, 105, 100, 82, 111, 111, 116, 80, 97, 114, 116))
        if not _0xa35b8c then return false, string.char(115, 101, 109, 32, 72, 117, 109, 97, 110, 111, 105, 100, 82, 111, 111, 116, 80, 97, 114, 116) end
    
        _0xa35b8c.AssemblyLinearVelocity  = Vector3.zero
        _0xa35b8c.AssemblyAngularVelocity = Vector3.zero
        _0xa35b8c.CFrame = _0x74683b.CFrame * CFrame.new(0, 4, 0)
        return true, string.char(80, 108, 111, 116, 32) .. _0x5401a8
    end
    
    
    _0x8b9032.MouseButton1Click:Connect(_0xd83737()
        local _0x802fac, msg = teleport()
        print(string.char(91, 84, 114, 101, 97, 100, 109, 105, 108, 108, 84, 80, 93), (_0x802fac and string.char(9989, 32) or string.char(10060, 32)) .. tostring(msg))
        _0x8b9032.Text = _0x802fac and string.char(9989, 32, 84, 101, 108, 101, 112, 111, 114, 116, 97, 100, 111, 33) or string.char(10060, 32, 70, 97, 108, 104, 111, 117)
        task.wait(1.5)
        _0x8b9032.Text = string.char(55356, 57283, 32, 32, 73, 114, 32, 112, 97, 114, 97, 32, 84, 114, 101, 97, 100, 109, 105, 108, 108)
    end)
end)();