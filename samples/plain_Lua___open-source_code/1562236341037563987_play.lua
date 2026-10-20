local VIM = game:GetService("VirtualInputManager")
local GuiService = game:GetService("GuiService")

local function sendKey(key, state)
    VIM:SendKeyEvent(state, key, false, game)
end

sendKey(Enum.KeyCode.BackSlash, true)
task.wait(0.1)
sendKey(Enum.KeyCode.BackSlash, false)
task.wait(0.3)

if not GuiService.SelectedObject then
    local t = 0
    repeat task.wait(0.1) t += 0.1 until GuiService.SelectedObject or t >= 5
end

sendKey(Enum.KeyCode.Return, true)
task.wait(0.1)
sendKey(Enum.KeyCode.Return, false)
VIM:SendGamepadButtonEvent(0, Enum.KeyCode.ButtonA, true, game)
task.wait(0.1)
VIM:SendGamepadButtonEvent(0, Enum.KeyCode.ButtonA, false, game)

task.wait(0.2)
sendKey(Enum.KeyCode.BackSlash, true)
task.wait(0.1)
sendKey(Enum.KeyCode.BackSlash, false)
