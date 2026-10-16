local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local gearId = 116040770

-- ==================== [环境自动侦测与补丁系统] ====================
local envState = {
    Mode = "Mouse", -- "Mouse" | "Touch" | "Gamepad"
    IsMobile = false
}

-- 1. 实时监听输入设备无缝切换（触屏 <-> 鼠标 <-> 手柄）
UserInputService.LastInputTypeChanged:Connect(function(lastInputType)
    if lastInputType == Enum.UserInputType.Touch then
        envState.Mode = "Touch"
    elseif lastInputType == Enum.UserInputType.Gamepad1 or string.find(lastInputType.Name, "Gamepad") then
        envState.Mode = "Gamepad"
    elseif string.find(lastInputType.Name, "Mouse") then
        envState.Mode = "Mouse"
    end
end)

-- 2. 动态环境修复补丁（移动端与 PC 统一保持阴影开启与原版亮度 4）
local function applyEnvironmentPatch(light)
    envState.IsMobile = UserInputService.TouchEnabled and not UserInputService.MouseEnabled
    envState.Mode = envState.IsMobile and "Touch" or "Mouse"
    
    if light then
        light.Shadows = true -- 全平台强制开启实时影子
        light.Brightness = 7 -- 保持原版亮度（4 级）
    end
end
-- ==================================================================

local success, objects = pcall(function()
    return game:GetObjects("rbxassetid://" .. gearId)
end)

if success and objects and #objects > 0 then
    local tool = objects[1]
    if not tool:IsA("Tool") then tool = tool:FindFirstChildOfClass("Tool") end

    if tool then
        local handle = tool:FindFirstChild("Handle") or tool:FindFirstChildWhichIsA("BasePart")
        local sound = tool:FindFirstChildWhichIsA("Sound", true)
        
        -- 初始化光效挂载轴
        local attachment = Instance.new("Attachment")
        attachment.Name = "LightPivot"
        attachment.Parent = handle
        
        local light = Instance.new("SpotLight")
        light.Parent = attachment
        light.Range = 80
        light.Angle = 55
        light.Enabled = false
        
        -- 应用全平台阴影与亮度设定
        applyEnvironmentPatch(light)
        
        local isOn = false
        local connection = nil

        -- 清理逻辑（防止重置角色时内存泄漏）
        local function cleanup()
            isOn = false
            light.Enabled = false
            if connection then
                connection:Disconnect()
                connection = nil
            end
        end

        -- 交互逻辑
        tool.Activated:Connect(function()
            isOn = not isOn
            light.Enabled = isOn
            
            if sound then sound:Play() end
            
            if isOn then
                connection = RunService.RenderStepped:Connect(function()
                    local character = LocalPlayer.Character
                    if handle and character and tool.Parent == character then
                        
                        if envState.Mode == "Touch" then
                            -- 触屏模式：锁定角色正前方（影子全开）
                            local hrp = character:FindFirstChild("HumanoidRootPart")
                            if hrp then
                                local forwardPos = handle.Position + (hrp.CFrame.LookVector * 100)
                                attachment.WorldCFrame = CFrame.lookAt(handle.Position, forwardPos)
                            else
                                attachment.WorldCFrame = handle.CFrame
                            end
                        elseif envState.Mode == "Gamepad" then
                            -- 手柄模式：锁定摄像机视角正前方
                            local camera = Workspace.CurrentCamera
                            if camera then
                                local forwardPos = handle.Position + (camera.CFrame.LookVector * 100)
                                attachment.WorldCFrame = CFrame.lookAt(handle.Position, forwardPos)
                            end
                        else
                            -- 鼠标模式：精准追踪鼠标位置
                            local targetPos = Mouse.Hit.Position
                            attachment.WorldCFrame = CFrame.lookAt(handle.Position, targetPos)
                        end

                    end
                end)
            else
                cleanup()
            end
        end)

        tool.Unequipped:Connect(cleanup)
        
        tool.AncestryChanged:Connect(function(_, parent)
            if not parent then cleanup() end
        end)

        tool.Parent = LocalPlayer:WaitForChild("Backpack")
        print("[正式版] 手电筒加载完成，移动端已开启影子并保持原版 4 级亮度！")
    end
end
