local repStorage = game:GetService("ReplicatedStorage")
local plrs = game:GetService("Players")
local coreGui = game:GetService("CoreGui")

local lplr = plrs.LocalPlayer
local events = repStorage._PROTECTED.Events
local checks = require(14499825459)
local clientSideInstances = {"CanvasGroup", "Frame", "ImageButton", "ImageLabel", "Frame",
                    "ScreenGui", "ScrollingFrame", "TextBox", "TextButton", "TextLabel", "Folder",
                    "UIAspectRatioConstraint", "UICorner", "UIGradient", "UIGridLayout", "Animation",
                    "UIListLayout", "UIPadding", "UIPageLayout", "UIScale", "UISizeConstraint",
                    "UIStroke", "UITableLayout", "UITextSizeConstraint", "VideoFrame", "ViewportFrame",
                    "AnimationTrack"}

print("** - FILTERING DISABLED - **")

local oldNamecall; oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
    local args, method = {...}, getnamecallmethod()
    if(typeof(self) == "Instance" and (self.ClassName == "Animation" or self.ClassName == "AnimationTrack")) then return oldNamecall(self, ...) end
    if((typeof(self) == "Instance" and table.find(clientSideInstances, self.ClassName)) or self == coreGui or self.IsDescendantOf(self, coreGui)) then return oldNamecall(self, ...) end
    
    if(table.find({"Destroy", "Remove", "ClearAllChildren", "Kick", "Clone"}, method)) then
        local resp = events.InvokeMethod:InvokeServer(self, method, ...)
        if(resp) then error(resp) end
        return
    end

    return oldNamecall(self, ...)
end))

local old; old = hookmetamethod(game, "__newindex", function(self, index, value)
    if(typeof(self) == "Instance" and (self:IsA("LocalScript") or self:IsA("Camera") or self:IsA("Sound") or self:IsA("UserInputService") or self:IsA("Animation") or self:IsA("AnimationTrack"))) then return old(self, index, value) end -- synbaopse
    if(table.find(clientSideInstances, self.ClassName) or typeof(value) == coreGui or self:IsDescendantOf(coreGui) or (typeof(value) == "Instance" and value:IsDescendantOf(coreGui))) then return old(self, index, value) end
    task.spawn(function()
        local resp = events.ChangeProperty:InvokeServer(self, index, value)
        if(resp) then print(self) error(resp) end
    end)
end)

local _old; _old = hookfunction(Instance.new, newcclosure(function(class, parent, ...)
    if(class == "LocalScript" or (parent and (parent:IsDescendantOf(coreGui) or parent == coreGui))) then return _old(class, parent, ...) end
    if(table.find(clientSideInstances, class)) then return _old(class, parent, ...) end

    local resp = events.CreateInstance:InvokeServer(class, parent, ...)
    if(type(resp) == "string") then error(resp) end
    return resp
end))
