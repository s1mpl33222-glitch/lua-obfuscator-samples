-- Avatar Copier v25.0.1
-- Copyright (C) 2026 lyraEz
-- Licensed under the GNU General Public License, version 3 or (at your option) any later version.
-- See LICENSE in the source repository.

-- AutoReapply, MapPersist and CopyAnimation follow the Settings page once the hub loads.
-- CopyAnimation is only the default for "Copy animations".
local Config = {
    AutoReapply = true,
    MapPersist = true,
    -- Username or id to preview on start (needs CopyAvatar or CopyAvatarHD).
    -- "restore" or "stop" resets your character and exits instead.
    TargetUsername = "",
    CopyAvatarHD = false,
    CopyAvatar = true,
    AnimResync = true, -- Replays the animation swap once so other players load it completely.
    CopyAnimation = false,
    EnableFreeCam = true,
    FreeCamKey = Enum.KeyCode.V,
    FreeCamSpeed = 1.5,
    DualWieldKey = Enum.KeyCode.R,
    ToolsGiverKey = Enum.KeyCode.L,
    HideUIKey = Enum.KeyCode.K,
    -- Skin sync server, see docs/features/skin-sync.md. Empty keeps skin sync off.
    SyncUrl = "",
}

if type(_G.Copier_Cleanup) == "function" then pcall(_G.Copier_Cleanup) end
_G.Copier_ExecutionID = (_G.Copier_ExecutionID or 0) + 1; local MyScriptID = _G.Copier_ExecutionID
local function IsAlive() return _G.Copier_ExecutionID == MyScriptID end

local Players = game:GetService("Players"); local lp = Players.LocalPlayer
local RS = game:GetService("RunService"); local UIS = game:GetService("UserInputService")
local MPS = game:GetService("MarketplaceService"); local SG = game:GetService("StarterGui")
local HttpService = game:GetService("HttpService")
local isMobile = UIS.TouchEnabled and not UIS.KeyboardEnabled

if _G.Copier_Connections then for _, conn in ipairs(_G.Copier_Connections) do pcall(function() conn:Disconnect() end) end end
_G.Copier_Connections = {}
local OwnedConnections = _G.Copier_Connections
local function RegisterConnection(conn) table.insert(OwnedConnections, conn); return conn end
-- Newer avatars join parts with AnimationConstraints instead of Motor6Ds, so both kinds are walked.
local Rig = {}
function Rig.links(model)
    local links={}
    local function add(object,a,b,c0,c1,transform)
        if a and b and a:IsA("BasePart") and b:IsA("BasePart") and a:IsDescendantOf(model) and b:IsDescendantOf(model) then
            table.insert(links,{Object=object,A=a,B=b,C0=c0,C1=c1,Transform=transform or CFrame.new()})
        end
    end
    for _,item in ipairs(model:GetDescendants()) do
        if item:IsA("JointInstance") then
            add(item,item.Part0,item.Part1,item.C0,item.C1,item:IsA("Motor6D") and item.Transform or nil)
        elseif item:IsA("WeldConstraint") then
            local a,b=item.Part0,item.Part1
            if a and b then add(item,a,b,a.CFrame:ToObjectSpace(b.CFrame),CFrame.new()) end
        elseif item:IsA("AnimationConstraint") or item:IsA("RigidConstraint") then
            local a,b=item.Attachment0,item.Attachment1
            if a and b then add(item,a.Parent,b.Parent,a.CFrame,b.CFrame,item:IsA("AnimationConstraint") and item.Transform or nil) end
        end
    end
    return links
end
function Rig.reachable(model,pose)
    local root=model:FindFirstChild("HumanoidRootPart")
    assert(root and root:IsA("BasePart"),"Model has no HumanoidRootPart.")
    local known={[root]=true}; local links=Rig.links(model)
    for _=1,#links+1 do
        local changed=false
        for _,link in ipairs(links) do
            local a,b=link.A,link.B
            if known[a] and not known[b] then
                if pose then b.CFrame=a.CFrame*link.C0*link.Transform*link.C1:Inverse() end
                known[b]=true; changed=true
            elseif known[b] and not known[a] then
                if pose then a.CFrame=b.CFrame*link.C1*link.Transform:Inverse()*link.C0:Inverse() end
                known[a]=true; changed=true
            end
        end
        if not changed then break end
    end
    return known
end
function Rig.repair(model)
    local known=Rig.reachable(model,false)
    local groups={}
    for _,part in ipairs(model:GetChildren()) do
        if part:IsA("BasePart") then
            for _,attachment in ipairs(part:GetChildren()) do
                if attachment:IsA("Attachment") and attachment.Name:match("RigAttachment$") then
                    groups[attachment.Name]=groups[attachment.Name] or {}
                    table.insert(groups[attachment.Name],attachment)
                end
            end
        end
    end
    -- Only bridge reached -> unreached parts, or this creates duplicate motors and cycles.
    for _=1,20 do
        local changed=false
        for name,attachments in pairs(groups) do
            for _,a in ipairs(attachments) do
                if known[a.Parent] then
                    for _,b in ipairs(attachments) do
                        if a.Parent~=b.Parent and not known[b.Parent] then
                            local joint=Instance.new("Motor6D"); joint.Name=name:gsub("RigAttachment$","")
                            joint.C0=a.CFrame; joint.C1=b.CFrame; joint.Part0=a.Parent; joint.Part1=b.Parent; joint.Parent=b.Parent
                            known=Rig.reachable(model,false); changed=true
                        end
                    end
                end
            end
        end
        if not changed then break end
    end
    return known
end

local API = {}
function API.description(id)
    local ok, result = pcall(function() return Players:GetHumanoidDescriptionFromUserIdAsync(id) end)
    if not ok then ok, result = pcall(function() return Players:GetHumanoidDescriptionFromUserId(id) end) end
    if not ok or not result then error("Avatar unavailable: " .. tostring(result), 0) end
    return result
end
function API.model(desc, rig)
    local ok, result = pcall(function() return Players:CreateHumanoidModelFromDescriptionAsync(desc, rig) end)
    if not ok then ok, result = pcall(function() return Players:CreateHumanoidModelFromDescription(desc, rig) end) end
    if not ok or not result then error("The avatar model could not be created: " .. tostring(result), 0) end
    return result
end

pcall(function() RS:UnbindFromRenderStep("CopierFreeCam") end)
if _G.Copier_UIAnnihilator then _G.Copier_UIAnnihilator:Disconnect(); _G.Copier_UIAnnihilator = nil end
pcall(function() local pg = lp:FindFirstChild("PlayerGui"); if pg then for _, n in ipairs({"ToolsGiverPopupGUI", "CopierMobileControls", "FCControls"}) do local g = pg:FindFirstChild(n); if g then g:Destroy() end end end end)

_G.Copier_TargetID = nil; _G.ToolsGiverActive = false; _G.Copier_LeftToolClone = nil; _G.Copier_UIHidden = false; _G.Copier_FCControls = nil

local targetLower = Config.TargetUsername:lower()
if targetLower == "restore" or targetLower == "stop" or targetLower == lp.Name:lower() then
    print("[Copier] RESTORE MODE: Wiping scripts and resetting character to fully restore game models & animations...")
    local cam = workspace.CurrentCamera; local ch = lp.Character
    if cam and ch then cam.CameraType = Enum.CameraType.Custom; cam.CameraSubject = ch:FindFirstChildOfClass("Humanoid") or ch:FindFirstChild("Head"); local hrp = ch:FindFirstChild("HumanoidRootPart"); if hrp then hrp.Anchored = false end end
    pcall(function() SG:SetCore("TopbarEnabled", true) end); pcall(function() SG:SetCoreGuiEnabled(Enum.CoreGuiType.All, true) end)
    pcall(function() for _, gui in ipairs(game:GetService("CoreGui"):GetChildren()) do if gui:IsA("LayerCollector") and gui:GetAttribute("Copier_WasEnabled") ~= nil then gui.Enabled = gui:GetAttribute("Copier_WasEnabled"); gui:SetAttribute("Copier_WasEnabled", nil) end end end)
    if ch then local hm = ch:FindFirstChildOfClass("Humanoid"); if hm then hm.Health = 0 end end
    return
end

local US = game:GetService("UserService"); local Debris = game:GetService("Debris"); local localBackpack = lp:WaitForChild("Backpack", 5)
local S = { cD = nil, cU = nil, tN = "", tD = "", iC = false, fvOn = false, hdOn = false, hdName = "", hdUser = nil, customDesc = nil, cameraLockActive = false, lockedCamSubject = nil, lockedCamType = nil, suspendedCamScripts = {}, strictCamEnd = 0, appliedChar = nil, currentRigType = nil, freeCamActive = false, freeCamPosition = Vector3.zero, freeCamKeysPressed = {}, savedHRPAnchored = false, mouseRightDown = false, cameraRotX = 0, cameraRotY = 0, originalTags = {}, hasSavedOriginalTags = false, leaderstatConnections = {}, tagWatcherConnection = nil, BD = {Head=1, HumanoidRootPart=1, UpperTorso=1, LowerTorso=1, LeftFoot=1, LeftLowerLeg=1, LeftUpperLeg=1, RightFoot=1, RightLowerLeg=1, RightUpperLeg=1, LeftHand=1, LeftLowerArm=1, LeftUpperArm=1, RightHand=1, RightLowerArm=1, RightUpperArm=1, Torso=1, ["Left Arm"]=1, ["Right Arm"]=1, ["Left Leg"]=1, ["Right Leg"]=1}, R15M = {Head=Enum.BodyPartR15.Head, UpperTorso=Enum.BodyPartR15.UpperTorso, LowerTorso=Enum.BodyPartR15.LowerTorso, LeftFoot=Enum.BodyPartR15.LeftFoot, LeftLowerLeg=Enum.BodyPartR15.LeftLowerLeg, LeftUpperLeg=Enum.BodyPartR15.LeftUpperLeg, RightFoot=Enum.BodyPartR15.RightFoot, RightLowerLeg=Enum.BodyPartR15.RightLowerLeg, RightUpperLeg=Enum.BodyPartR15.RightUpperLeg, LeftHand=Enum.BodyPartR15.LeftHand, LeftLowerArm=Enum.BodyPartR15.LeftLowerArm, LeftUpperArm=Enum.BodyPartR15.LeftUpperArm, RightHand=Enum.BodyPartR15.RightHand, RightLowerArm=Enum.BodyPartR15.RightLowerArm, RightUpperArm=Enum.BodyPartR15.RightUpperArm} }
local F = {}

local S_SafeTools = {}

-- Game accessories (MM2 waist weapons, for example) must survive an avatar swap.
S.ownAccNames = nil
F.getSafeAccessoryNames = function()
    if S.ownAccNames ~= nil then return S.ownAccNames end
    local names = {}
    pcall(function()
        local desc = API.description(lp.UserId)
        if desc then
            local rt = (F.getTrueRigType(lp.Character)) or Enum.HumanoidRigType.R15
            local own = API.model(desc, rt)
            if own then
                for _, ac in ipairs(own:GetChildren()) do if ac:IsA("Accessory") then names[ac.Name] = true end end
                pcall(function() own:Destroy() end)
            end
        end
    end)
    if next(names) ~= nil then S.ownAccNames = names end
    return names
end

local HiddenGuis = {}
local HiddenCoreStates = {}
F.ToggleUI = function()
    _G.Copier_UIHidden = not _G.Copier_UIHidden
    if _G.Copier_UIHidden then
        local pg = lp:FindFirstChild("PlayerGui")
        if pg then
            for _, gui in ipairs(pg:GetChildren()) do
                if gui:IsA("ScreenGui") and gui.Name ~= "CopierHubGUI" and gui.Name ~= "TouchGui" then
                    HiddenGuis[gui] = gui.Enabled
                    gui.Enabled = false
                end
            end
        end
        for _, kind in ipairs(Enum.CoreGuiType:GetEnumItems()) do
            if kind ~= Enum.CoreGuiType.All then
                local ok, enabled = pcall(function() return SG:GetCoreGuiEnabled(kind) end)
                if ok then HiddenCoreStates[kind] = enabled; pcall(function() SG:SetCoreGuiEnabled(kind, false) end) end
            end
        end
    else
        for gui, enabled in pairs(HiddenGuis) do pcall(function() gui.Enabled = enabled end) end
        for kind, enabled in pairs(HiddenCoreStates) do pcall(function() SG:SetCoreGuiEnabled(kind, enabled) end) end
        table.clear(HiddenGuis); table.clear(HiddenCoreStates)
    end
end

_G.Copier_ToolsGiverToggle = function() if not IsAlive() then return end; task.spawn(function() _G.ToolsGiverActive = not _G.ToolsGiverActive; if _G.ToolsGiverActive then F.showToolsGUI(true); F.startToolsGiverLoop() else F.showToolsGUI(false) end end) end
F.startToolsGiverLoop = function() task.spawn(function() while _G.ToolsGiverActive and IsAlive() do local bp = lp:FindFirstChild("Backpack"); local char = lp.Character; if bp then local safeServices = {workspace, game:GetService("Lighting"), game:GetService("ReplicatedStorage"), game:GetService("ReplicatedFirst"), game:GetService("StarterPack"), game:GetService("Players")}; for _, service in ipairs(safeServices) do pcall(function() for _, obj in ipairs(service:GetDescendants()) do if obj:IsA("Tool") or obj:IsA("HopperBin") then local hasTool = bp:FindFirstChild(obj.Name) or (char and char:FindFirstChild(obj.Name)); if not hasTool then if obj:IsDescendantOf(workspace) and firetouchinterest then local hrp = char and char:FindFirstChild("HumanoidRootPart"); local handle = obj:FindFirstChild("Handle") or obj:FindFirstChildWhichIsA("BasePart"); if hrp and handle then pcall(function() firetouchinterest(hrp, handle, 0); task.wait(); firetouchinterest(hrp, handle, 1) end) end end; pcall(function() local clone = obj:Clone(); clone.Parent = bp end) end end end end) end end; task.wait(1.5) end end) end
F.showToolsGUI = function(isActive) if not IsAlive() then return end; local guiParent = lp:WaitForChild("PlayerGui", 5); if not guiParent then return end; local existing = guiParent:FindFirstChild("ToolsGiverPopupGUI"); if existing then existing:Destroy() end; local sg = Instance.new("ScreenGui"); sg.Name = "ToolsGiverPopupGUI"; sg.Parent = guiParent; local frame = Instance.new("Frame", sg); frame.Size = UDim2.new(0, 320, 0, 45); frame.Position = UDim2.new(0.5, -160, 0.85, 0); frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20); frame.BackgroundTransparency = 0.15; frame.BorderSizePixel = 0; local corner = Instance.new("UICorner", frame); corner.CornerRadius = UDim.new(0, 8); local stroke = Instance.new("UIStroke", frame); stroke.Thickness = 1.5; stroke.Color = isActive and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(255, 60, 60); local txt = Instance.new("TextLabel", frame); txt.Size = UDim2.new(1, 0, 1, 0); txt.BackgroundTransparency = 1; txt.Font = Enum.Font.GothamBold; txt.TextSize = 15; txt.TextColor3 = Color3.fromRGB(255, 255, 255); txt.Text = isActive and "ToolsGiver [ON] - Scanning Safely..." or "ToolsGiver [OFF]"; task.spawn(function() task.wait(3.5); if sg and sg.Parent then for i = 0, 1, 0.1 do if frame then frame.BackgroundTransparency = 0.15 + (i * 0.85); txt.TextTransparency = i; stroke.Transparency = i end; task.wait(0.05) end; sg:Destroy() end end) end

F.getTrueRigType = function(ch) if not ch then return nil end; if ch:FindFirstChild("UpperTorso") then return Enum.HumanoidRigType.R15 end; if ch:FindFirstChild("Torso") then return Enum.HumanoidRigType.R6 end; local hm = ch:FindFirstChildOfClass("Humanoid"); if hm then return hm.RigType end; return nil end

F.resolveAnimationTrackId = function(assetId)
    if not assetId or tonumber(assetId) == 0 then return nil end
    local idNum = tonumber(assetId)
    -- Catalog animation assets wrap the real Animation; GetObjects unpacks it.
    local rawAnimId = nil
    pcall(function()
        local objs = game:GetObjects("rbxassetid://" .. tostring(idNum))
        if objs and #objs > 0 then
            for _, root in ipairs(objs) do
                if root:IsA("Animation") and root.AnimationId ~= "" then
                    rawAnimId = root.AnimationId
                    break
                else
                    for _, desc in ipairs(root:GetDescendants()) do
                        if desc:IsA("Animation") and desc.AnimationId ~= "" then
                            rawAnimId = desc.AnimationId
                            break
                        end
                    end
                end
                if rawAnimId then break end
            end
        end
    end)
    return rawAnimId or ("rbxassetid://" .. tostring(idNum))
end

F.applyAnimationIdsToAnimate = function(ch, desc)
    if not desc then return false end
    -- Description animation ids are R15 animations. On R6 or custom rigs they play nothing and the
    -- character stands stiff, so those rigs keep the game's animations.
    if F.getTrueRigType(ch) ~= Enum.HumanoidRigType.R15 then return false end
    local animate = ch:FindFirstChild("Animate"); if not animate then return false end
    -- The native Animate folders are lowercase.
    local map = {
        climb = "ClimbAnimation",
        fall = "FallAnimation",
        idle = "IdleAnimation",
        jump = "JumpAnimation",
        run = "RunAnimation",
        swim = "SwimAnimation",
        walk = "WalkAnimation"
    }
    local applied = 0
    for folderName, field in pairs(map) do
        local animAssetId = desc[field]
        if animAssetId and tonumber(animAssetId) ~= 0 then
            local folder = animate:FindFirstChild(folderName)
            if folder then
                local realAnimId = F.resolveAnimationTrackId(animAssetId)
                if realAnimId then
                    for _, node in ipairs(folder:GetDescendants()) do
                        if node:IsA("Animation") then
                            pcall(function()
                                F.setAnimationId(node, realAnimId)
                                applied = applied + 1
                            end)
                        end
                    end
                end
            end
        end
    end
    return applied > 0
end

local Appearance = {}
function Appearance.isBody(part, character)
    return part and part:IsA("BasePart") and part.Parent == character and S.BD[part.Name] ~= nil
end
function Appearance.isAvatarAccessory(item)
    if item:GetAttribute("Copier_CopiedItem") then return true end
    if item:FindFirstChildWhichIsA("Script", true) or item:FindFirstChildWhichIsA("LocalScript", true) then return false end
    -- Your own avatar's accessory names, not what the character wears now (that includes game items).
    -- Unknown items are left to the game.
    return S.ownAccNames and S.ownAccNames[item.Name] == true or false
end

function Appearance.attach(character, accessory)
    local hum = character:FindFirstChildOfClass("Humanoid")
    local handle = accessory:FindFirstChild("Handle")
    if not hum or not handle or not handle:IsA("BasePart") then accessory:Destroy(); return nil, "accessory has no Handle" end
    for _, item in ipairs(accessory:GetDescendants()) do
        if item:IsA("BasePart") then item.Anchored = false; item.CanCollide = false; item.Massless = true
        elseif item:IsA("JointInstance") or item:IsA("WeldConstraint") then
            if item.Name == "AccessoryWeld" or (item.Part0 and not item.Part0:IsDescendantOf(accessory)) or (item.Part1 and not item.Part1:IsDescendantOf(accessory)) then item:Destroy() end
        elseif item:IsA("AnimationConstraint") or item:IsA("RigidConstraint") then
            local a,b=item.Attachment0,item.Attachment1
            if (a and not a:IsDescendantOf(accessory)) or (b and not b:IsDescendantOf(accessory)) then item:Destroy() end
        end
    end
    -- AddAccessory warns "already being worn by another character" if the accessory is still parented,
    -- so detach it first. It is parented back below if AddAccessory fails.
    accessory.Parent = nil
    local ok = pcall(function() hum:AddAccessory(accessory) end)
    if accessory.Parent ~= character then accessory.Parent = character end
    local function connected()
        for _,link in ipairs(Rig.links(character)) do
            if (Appearance.isBody(link.A,character) and link.B:IsDescendantOf(accessory))
                or (Appearance.isBody(link.B,character) and link.A:IsDescendantOf(accessory)) then return true end
        end
        return false
    end
    if not connected() then
        local attachment = handle:FindFirstChildOfClass("Attachment")
        local body, targetAttachment
        if attachment then
            for _, part in ipairs(character:GetChildren()) do
                if Appearance.isBody(part, character) then
                    local candidate = part:FindFirstChild(attachment.Name)
                    if candidate and candidate:IsA("Attachment") then body = part; targetAttachment = candidate; break end
                end
            end
        end
        if body then
            local weld = Instance.new("Weld"); weld.Name = "AccessoryWeld"
            weld.C0 = targetAttachment.CFrame; weld.C1 = attachment.CFrame
            handle.CFrame = body.CFrame * weld.C0 * weld.C1:Inverse()
            weld.Part0 = body; weld.Part1 = handle; weld.Parent = handle
        elseif not attachment and character:FindFirstChild("Head") then
            local head = character.Head; local weld = Instance.new("Weld"); weld.Name = "AccessoryWeld"
            weld.C0 = CFrame.new(0, head.Size.Y * 0.5, 0); weld.C1 = accessory.AttachmentPoint
            handle.CFrame = head.CFrame * weld.C0 * weld.C1:Inverse(); weld.Part0 = head; weld.Part1 = handle; weld.Parent = handle
        end
    end
    if not connected() then accessory:Destroy(); return nil, ok and "incompatible attachment" or "accessory was rejected" end
    return accessory
end

function Appearance.item(source, character, key)
    local clone = source:Clone()
    clone:SetAttribute("Copier_CopiedItem", true); clone:SetAttribute("Lyra_ItemKey", key)
    if clone:IsA("Accessory") then return Appearance.attach(character, clone) end
    clone.Parent = character; return clone
end
function Appearance.copySurface(target, source)
    local physical={}
    for _,key in ipairs({"Size","CFrame","Anchored","CanCollide","CanTouch","CanQuery","Massless","RootPriority","CollisionGroup","CustomPhysicalProperties"}) do
        pcall(function() physical[key]=target[key] end)
    end
    local ok,err=pcall(function()
        if target:IsA("MeshPart") and source:IsA("MeshPart") then
            target:ApplyMesh(source)
        elseif target:IsA("MeshPart") ~= source:IsA("MeshPart") then
            error("Incompatible body-part types for in-place application")
        end
        local function cosmetic(item)
            return item:IsA("DataModelMesh") or item:IsA("Decal") or item:IsA("SurfaceAppearance")
                or item:IsA("FaceControls") or item:IsA("Bone") or item:IsA("WrapTarget")
        end
        local prepared={}
        for _,child in ipairs(source:GetChildren()) do if cosmetic(child) then table.insert(prepared,child:Clone()) end end
        for _,child in ipairs(target:GetChildren()) do if cosmetic(child) then child:Destroy() end end
        for _,child in ipairs(prepared) do child.Parent=target end
        target.Color=source.Color; target.Transparency=source.Transparency
        pcall(function() target.Material=source.Material end)
    end)
    -- ApplyMesh must not resize or move the live rig.
    for key,value in pairs(physical) do pcall(function() target[key]=value end) end
    return ok,err
end
-- Some games replicate MeshParts that reject ApplyMesh. Those keep their part and joint, and a
-- welded, non-colliding local visual is drawn instead.
function Appearance.clearVisuals(character)
    for _,item in ipairs(character:GetChildren()) do
        if item:IsA("BasePart") and item:GetAttribute("Lyra_VisualFor") then item:Destroy()
        elseif Appearance.isBody(item,character) then
            local transparency=item:GetAttribute("Lyra_BeforeOverlay")
            if transparency~=nil then item.Transparency=transparency; item:SetAttribute("Lyra_BeforeOverlay",nil) end
            for _,child in ipairs(item:GetChildren()) do
                local old=child:GetAttribute("Lyra_BeforeOverlay")
                if old~=nil and child:IsA("Decal") then child.Transparency=old; child:SetAttribute("Lyra_BeforeOverlay",nil) end
            end
        end
    end
end
function Appearance.visualFallback(character,target,source)
    local display=source:Clone(); assert(display,"Could not prepare the visual part "..source.Name)
    display.Name="LyraVisual_"..target.Name; display:SetAttribute("Lyra_VisualFor",target.Name)
    for _,child in ipairs(display:GetDescendants()) do
        if child:IsA("JointInstance") or child:IsA("WeldConstraint") or child:IsA("Constraint")
            or child:IsA("Script") or child:IsA("LocalScript") or child:IsA("ModuleScript")
            or child:IsA("Attachment") and not child:IsA("Bone") then child:Destroy() end
    end
    display.Anchored=false; display.CanCollide=false; display.CanTouch=false; display.CanQuery=false; display.Massless=true; display.RootPriority=-127
    display.CFrame=target.CFrame; display.Parent=character
    local weld=Instance.new("Weld"); weld.Name="LyraVisualWeld"; weld.Part0=target; weld.Part1=display; weld.Parent=display
    target:SetAttribute("Lyra_BeforeOverlay",target.Transparency); target.Transparency=1
    for _,child in ipairs(target:GetChildren()) do
        if child:IsA("Decal") then child:SetAttribute("Lyra_BeforeOverlay",child.Transparency); child.Transparency=1 end
    end
end
function Appearance.checkLiveRig(character)
    local known=Rig.reachable(character,false)
    local missing={}
    for _,part in ipairs(character:GetChildren()) do
        if Appearance.isBody(part,character) and not known[part] then table.insert(missing,part.Name) end
    end
    assert(#missing==0,"The character rig is already disconnected. Respawn or rejoin before applying another avatar.")
end

function Appearance.beginGeometry(hum)
    local original=hum:GetAttribute("Lyra_OriginalAutomaticScaling")
    if original==nil then hum:SetAttribute("Lyra_OriginalAutomaticScaling",hum.AutomaticScalingEnabled) end
    -- The generated model is already scaled; automatic scaling would apply it twice.
    hum.AutomaticScalingEnabled=false
end
function Appearance.releaseGeometry(hum)
    if not hum then return end
    local original=hum:GetAttribute("Lyra_OriginalAutomaticScaling")
    if original~=nil then hum.AutomaticScalingEnabled=original; hum:SetAttribute("Lyra_OriginalAutomaticScaling",nil) end
end
function Appearance.fitGeometry(character,sourceModel,copied,dryRun)
    local hum=character:FindFirstChildOfClass("Humanoid")
    local sourceHum=sourceModel:FindFirstChildOfClass("Humanoid")
    local sourceLinks=Rig.links(sourceModel)
    local liveLinks=Rig.links(character)
    local function targetOffsets(a,b)
        for _,link in ipairs(sourceLinks) do
            if link.A.Parent==sourceModel and link.B.Parent==sourceModel then
                if link.A.Name==a.Name and link.B.Name==b.Name then return link.C0,link.C1 end
                if link.B.Name==a.Name and link.A.Name==b.Name then return link.C1,link.C0 end
            end
        end
        -- Some generated models have the rig attachments but no joints yet.
        local sa,sb=sourceModel:FindFirstChild(a.Name),sourceModel:FindFirstChild(b.Name)
        if sa and sb then
            for _,at in ipairs(sa:GetChildren()) do
                if at:IsA("Attachment") and at.Name:match("RigAttachment$") then
                    local bt=sb:FindFirstChild(at.Name)
                    if bt and bt:IsA("Attachment") then return at.CFrame,bt.CFrame end
                end
            end
        end
    end
    local updates={}
    for _,link in ipairs(liveLinks) do
        if Appearance.isBody(link.A,character) and Appearance.isBody(link.B,character) then
            local a,b=targetOffsets(link.A,link.B)
            -- Unknown or fixed links keep the game's offsets instead of failing the whole apply.
            if a and b and not link.Object:IsA("WeldConstraint") then table.insert(updates,{Link=link,C0=a,C1=b}) end
        end
    end
    if dryRun then return end
    for _,source in ipairs(sourceModel:GetChildren()) do
        local target=copied[source.Name] and character:FindFirstChild(source.Name)
        if target then
            target.Size=source.Size
            for _,name in ipairs({"OriginalSize","AvatarPartScaleType"}) do
                local value=source:FindFirstChild(name); local current=target:FindFirstChild(name)
                if value then
                    if current and current.ClassName==value.ClassName then current.Value=value.Value
                    elseif not current then value:Clone().Parent=target end
                end
            end
            -- Update attachments in place: game weapons hold references to them.
            for _,at in ipairs(source:GetChildren()) do
                if at:IsA("Attachment") and not at:IsA("Bone") then
                    local current=target:FindFirstChild(at.Name)
                    if current and current:IsA("Attachment") then current.CFrame=at.CFrame
                    elseif not current then at:Clone().Parent=target end
                end
            end
        end
    end
    for _,row in ipairs(updates) do
        local link=row.Link; local joint=link.Object
        if (copied[link.A.Name] or link.A.Name=="HumanoidRootPart") and (copied[link.B.Name] or link.B.Name=="HumanoidRootPart") then
            if joint:IsA("JointInstance") then joint.C0=row.C0; joint.C1=row.C1
            else joint.Attachment0.CFrame=row.C0; joint.Attachment1.CFrame=row.C1 end
        end
    end
    if sourceHum then
        for _,name in ipairs({"BodyDepthScale","BodyHeightScale","BodyWidthScale","HeadScale","BodyProportionScale","BodyTypeScale"}) do
            local source=sourceHum:FindFirstChild(name); local target=hum:FindFirstChild(name)
            if source and source:IsA("NumberValue") then
                if target and target:IsA("NumberValue") then target.Value=source.Value
                elseif not target then source:Clone().Parent=hum end
            end
        end
    end
    -- Only take the new HipHeight when every leg part took the new size. A HipHeight taller than the
    -- real legs makes the character hover and lets it jump again in mid-air.
    local legsResized=false
    for _,name in ipairs({"LowerTorso","LeftUpperLeg","LeftLowerLeg","LeftFoot","RightUpperLeg","RightLowerLeg","RightFoot","Left Leg","Right Leg"}) do
        if character:FindFirstChild(name) then
            if not copied[name] then legsResized=false; break end
            legsResized=true
        end
    end
    if legsResized and sourceHum and type(sourceHum.HipHeight)=="number" then
        local sourceRoot=sourceModel:FindFirstChild("HumanoidRootPart")
        local root=character:FindFirstChild("HumanoidRootPart")
        local delta=sourceRoot and root and (sourceRoot.Size.Y-root.Size.Y)*0.5 or 0
        hum.HipHeight=sourceHum.HipHeight+delta
    end
end

-- Changes the live character in place: its parts, joints and Humanoid stay, only meshes, sizes, joint
-- offsets and avatar items change. That is what keeps the game's tools, welds and tags attached.
function Appearance.apply(character, sourceModel)
    local hum = character:FindFirstChildOfClass("Humanoid")
    assert(hum and sourceModel, "Character or model unavailable.")
    local report = {Items = {}, Skipped = {}, BodyErrors = {}}
    Appearance.checkLiveRig(character)
    -- Custom characters often miss parts. Apply what matches and only fail when nothing does.
    local expected, missing = {}, {}
    for _,source in ipairs(sourceModel:GetChildren()) do
        if Appearance.isBody(source,sourceModel) and source.Name~="HumanoidRootPart" then
            if Appearance.isBody(character:FindFirstChild(source.Name),character) then expected[source.Name]=true
            else table.insert(missing,source.Name) end
        end
    end
    assert(next(expected),"This game's character has none of the expected body parts ("..table.concat(missing,", ")..").")
    Appearance.fitGeometry(character,sourceModel,expected,true)
    local previousAutoScale=hum.AutomaticScalingEnabled
    local previousNeck=hum.RequiresNeck
    local ok, err = xpcall(function()
        Appearance.beginGeometry(hum)
        hum.RequiresNeck=false
        Appearance.clearVisuals(character)
        local copied={}
        for _, item in ipairs(character:GetChildren()) do
            if item:IsA("Shirt") or item:IsA("Pants") or item:IsA("ShirtGraphic") or item:IsA("BodyColors") or item:IsA("CharacterMesh")
                or (item:IsA("Accessory") and (Appearance.isAvatarAccessory(item) or
                    sourceModel:GetAttribute("Lyra_VisualSnapshot") and not item:FindFirstChildWhichIsA("Script",true) and not item:FindFirstChildWhichIsA("LocalScript",true))) then item:Destroy() end
        end
        -- Meshes first, then sizes and offsets from the already scaled source.
        for _,source in ipairs(sourceModel:GetChildren()) do
            if source:IsA("BasePart") and source.Name~="HumanoidRootPart" and S.BD[source.Name] then
                local target=character:FindFirstChild(source.Name)
                if target and Appearance.isBody(target,character) then
                    local success,reason=Appearance.copySurface(target,source)
                    if not success then
                        Appearance.visualFallback(character,target,source)
                        copied[source.Name]=true
                        report.LocalVisuals=(report.LocalVisuals or 0)+1
                        warn("[Lyra Appearance] "..source.Name..": using a local visual; "..tostring(reason))
                    else copied[source.Name]=true end
                else table.insert(report.BodyErrors,source.Name) end
            end
        end
        Appearance.fitGeometry(character,sourceModel,copied)
        local index = 0
        for _, source in ipairs(sourceModel:GetChildren()) do
            if source:IsA("Accessory") or source:IsA("Shirt") or source:IsA("Pants") or source:IsA("ShirtGraphic") or source:IsA("BodyColors") or source:IsA("CharacterMesh") then
                index = index + 1; local key = source.ClassName .. ":" .. tostring(index)
                local applied, item, reason = pcall(Appearance.item, source, character, key)
                if applied and item then
                    table.insert(report.Items, {Key = key, Instance = item, Template = source:Clone(), Attempts = 0, Suppressed = false})
                else table.insert(report.Skipped, source.Name .. (reason and (" (" .. reason .. ")") or "")) end
            end
        end
        -- Parenting BodyColors can repaint the limbs; the source colors win.
        for name in pairs(copied) do character:FindFirstChild(name).Color=sourceModel:FindFirstChild(name).Color end
    end, function(message) return tostring(message) end)
    pcall(function() hum.RequiresNeck=previousNeck end)
    if not ok then
        pcall(function() hum.AutomaticScalingEnabled=previousAutoScale end)
        for _,item in ipairs(report.Items) do item.Template:Destroy() end
        error(err,0)
    end
    return report
end
F.aAv = function(character, model) return Appearance.apply(character, model) end

-- Other players only see what the local Animator actually plays. An Animation edited in place keeps
-- serving cached tracks, and restarting Animate before the asset loads sends the first Play too early.
-- So changed Animations are replaced, preloaded, and restarts are serialized.
F.normalizeAnimId = function(id)
    local text = tostring(id or "")
    local number = text:match("^rbxassetid://(%d+)$") or text:match("[?&]id=(%d+)") or text:match("^(%d+)$")
    return number and ("rbxassetid://" .. number) or text
end
F.setAnimationId = function(animation, id)
    local wanted = F.normalizeAnimId(id)
    if wanted == "" or F.normalizeAnimId(animation.AnimationId) == wanted then return false end
    local replaced = false
    local parent = animation.Parent
    if parent then
        local fresh
        pcall(function() fresh = animation:Clone() end)
        if fresh then
            fresh.AnimationId = wanted
            if pcall(function() fresh.Parent = parent end) then
                replaced = true
                pcall(function() animation:Destroy() end)
            end
        end
    end
    if not replaced then animation.AnimationId = wanted end
    return true
end
F.warmAnimations = function(ch, timeout)
    local animate = ch and ch:FindFirstChild("Animate"); if not animate then return end
    local hum = ch:FindFirstChildOfClass("Humanoid")
    local animator = hum and hum:FindFirstChildOfClass("Animator")
    local list, seen = {}, {}
    for _, item in ipairs(animate:GetDescendants()) do
        if item:IsA("Animation") and item.AnimationId ~= "" and not seen[item.AnimationId] then
            seen[item.AnimationId] = true; table.insert(list, item)
        end
    end
    if #list == 0 then return end
    local deadline = os.clock() + (timeout or 3)
    local preloaded = false
    task.spawn(function() pcall(function() game:GetService("ContentProvider"):PreloadAsync(list) end); preloaded = true end)
    while not preloaded and os.clock() < deadline and IsAlive() do task.wait(0.05) end
    if not animator then return end
    local tracks = {}
    for _, animation in ipairs(list) do
        local ok, track = pcall(function() return animator:LoadAnimation(animation) end)
        if ok and track then table.insert(tracks, track) end
    end
    while os.clock() < deadline and IsAlive() do
        local ready = true
        for _, track in ipairs(tracks) do if track.Length <= 0 then ready = false; break end end
        if ready then break end
        task.wait(0.05)
    end
    for _, track in ipairs(tracks) do pcall(function() track:Destroy() end) end
end
F.AnimSerial = 0
-- Playing tracks fade out while Animate restarts a frame later, so the character never stands stiff.
-- The resync repeats the swap once for players who missed the first one.
F.restartAnimate = function(ch, resync)
    local animate = ch and ch:FindFirstChild("Animate")
    if not animate then return end
    F.AnimSerial = F.AnimSerial + 1
    local serial = F.AnimSerial
    task.spawn(function()
        local hum = ch:FindFirstChildOfClass("Humanoid")
        local function cycle()
            if not ch.Parent or not animate.Parent then return false end
            local animator = hum and hum:FindFirstChildOfClass("Animator")
            if animator then for _, tr in ipairs(animator:GetPlayingAnimationTracks()) do pcall(function() tr:Stop(0.15) end) end end
            animate.Enabled = false
            RS.Heartbeat:Wait()
            if ch.Parent and animate.Parent then animate.Enabled = true end
            return true
        end
        task.spawn(pcall, F.warmAnimations, ch, 3)
        task.wait(0.2)
        if serial ~= F.AnimSerial or not IsAlive() then return end
        if not cycle() then return end
        if not resync or not Config.AnimResync then return end
        task.wait(1.2)
        if serial ~= F.AnimSerial or not IsAlive() then return end
        cycle()
    end)
end

F.resumeCamScripts = function() for _, s in ipairs(S.suspendedCamScripts) do pcall(function() s.Enabled = true end) end; table.clear(S.suspendedCamScripts) end
F.unlockCamera = function() S.cameraLockActive = false; S.lockedCamSubject = nil; S.lockedCamType = nil end
RegisterConnection(RS.RenderStepped:Connect(function() if S.cameraLockActive and S.lockedCamSubject then local cam = workspace.CurrentCamera; if cam then pcall(function() if cam.CameraSubject ~= S.lockedCamSubject then cam.CameraSubject = S.lockedCamSubject end; if cam.CameraType ~= S.lockedCamType then cam.CameraType = S.lockedCamType end end) end end end))

F.enableFreeCam = function()
    local char = lp.Character; if not char then return end; local hrp = char:FindFirstChild("HumanoidRootPart"); if hrp then S.savedHRPAnchored = hrp.Anchored; hrp.Anchored = true end; local cam = workspace.CurrentCamera
    if cam then S.freeCamPosition = cam.CFrame.Position; local rx, ry, rz = cam.CFrame:ToEulerAnglesYXZ(); S.cameraRotX = rx; S.cameraRotY = ry; cam.CameraType = Enum.CameraType.Scriptable end; S.freeCamActive = true; if _G.Copier_FCControls then _G.Copier_FCControls.Visible = true end; print("[FreeCam] Spectator mode activated. Controls: Arrow keys to move, hold Right-Click to rotate.")
    RS:BindToRenderStep("CopierFreeCam", Enum.RenderPriority.Camera.Value + 1, function(dt) if not S.freeCamActive then return end; local c = workspace.CurrentCamera; if not c then return end; c.CameraType = Enum.CameraType.Scriptable; local rotCFrame = CFrame.fromEulerAnglesYXZ(S.cameraRotX, S.cameraRotY, 0); local moveVector = Vector3.zero; if S.freeCamKeysPressed[Enum.KeyCode.Up] then moveVector = moveVector + rotCFrame.LookVector end; if S.freeCamKeysPressed[Enum.KeyCode.Down] then moveVector = moveVector - rotCFrame.LookVector end; if S.freeCamKeysPressed[Enum.KeyCode.Left] then moveVector = moveVector - rotCFrame.RightVector end; if S.freeCamKeysPressed[Enum.KeyCode.Right] then moveVector = moveVector + rotCFrame.RightVector end; if moveVector.Magnitude > 0 then S.freeCamPosition = S.freeCamPosition + (moveVector.Unit * Config.FreeCamSpeed * math.min(dt, 0.1) * 60) end; c.CFrame = CFrame.new(S.freeCamPosition) * rotCFrame end)
end

F.disableFreeCam = function()
    S.freeCamActive = false; table.clear(S.freeCamKeysPressed); pcall(function() RS:UnbindFromRenderStep("CopierFreeCam") end); local char = lp.Character; if char then local hrp = char:FindFirstChild("HumanoidRootPart"); if hrp and S.savedHRPAnchored ~= nil then hrp.Anchored = S.savedHRPAnchored end end; local cam = workspace.CurrentCamera; if cam then cam.CameraType = Enum.CameraType.Custom; if char then cam.CameraSubject = char:FindFirstChildOfClass("Humanoid") or char:FindFirstChild("Head") end end; if _G.Copier_FCControls then _G.Copier_FCControls.Visible = false end; print("[FreeCam] Spectator mode deactivated.")
end

RegisterConnection(UIS.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Config.ToolsGiverKey then if _G.Copier_ToolsGiverToggle then _G.Copier_ToolsGiverToggle() end end
    if input.KeyCode == Config.HideUIKey then F.ToggleUI() end
    if input.KeyCode == Config.DualWieldKey then local char = lp.Character; if char then if _G.Copier_LeftToolClone and _G.Copier_LeftToolClone.Parent then _G.Copier_LeftToolClone:Destroy(); _G.Copier_LeftToolClone = nil else local rightHandTool = char:FindFirstChildOfClass("Tool"); if rightHandTool then local handle = rightHandTool:FindFirstChild("Handle"); if handle then local leftHand = char:FindFirstChild("LeftHand") or char:FindFirstChild("Left Arm"); if leftHand then _G.Copier_LeftToolClone = Instance.new("Model"); _G.Copier_LeftToolClone.Name = rightHandTool.Name .. "_LeftWield"; local fakeHandle = handle:Clone(); for _, v in ipairs(fakeHandle:GetDescendants()) do if v:IsA("Script") or v:IsA("LocalScript") then v:Destroy() end end; fakeHandle.Parent = _G.Copier_LeftToolClone; _G.Copier_LeftToolClone.Parent = char; fakeHandle.CFrame = leftHand.CFrame; local weld = Instance.new("WeldConstraint"); weld.Part0 = leftHand; weld.Part1 = fakeHandle; weld.Parent = fakeHandle end end end end end end
    if S.freeCamActive and input.UserInputType == Enum.UserInputType.MouseButton2 then S.mouseRightDown = true; UIS.MouseBehavior = Enum.MouseBehavior.LockCurrentPosition elseif input.KeyCode == Config.FreeCamKey then if Config.EnableFreeCam then if S.freeCamActive then F.disableFreeCam() else F.enableFreeCam() end end elseif S.freeCamActive then if input.KeyCode == Enum.KeyCode.Up or input.KeyCode == Enum.KeyCode.Down or input.KeyCode == Enum.KeyCode.Left or input.KeyCode == Enum.KeyCode.Right then S.freeCamKeysPressed[input.KeyCode] = true end end
end))
RegisterConnection(UIS.InputEnded:Connect(function(input, processed) if S.freeCamActive and input.UserInputType == Enum.UserInputType.MouseButton2 then S.mouseRightDown = false; UIS.MouseBehavior = Enum.MouseBehavior.Default elseif S.freeCamActive then if input.KeyCode == Enum.KeyCode.Up or input.KeyCode == Enum.KeyCode.Down or input.KeyCode == Enum.KeyCode.Left or input.KeyCode == Enum.KeyCode.Right then S.freeCamKeysPressed[input.KeyCode] = nil end end end))
RegisterConnection(UIS.InputChanged:Connect(function(input, processed) if S.freeCamActive and input.UserInputType == Enum.UserInputType.MouseMovement then if S.mouseRightDown then local delta = input.Delta; S.cameraRotX = S.cameraRotX - delta.Y * 0.003; S.cameraRotY = S.cameraRotY - delta.X * 0.003; S.cameraRotX = math.clamp(S.cameraRotX, -math.rad(80), math.rad(80)) end end end))
RegisterConnection(lp.CharacterRemoving:Connect(function() if S.freeCamActive then F.disableFreeCam() end end))

F.ensureTagsVisible = function(head) if not head then return end; for _, gui in ipairs(head:GetChildren()) do if gui:IsA("BillboardGui") or gui:IsA("SurfaceGui") then gui.Enabled = true; for _, child in ipairs(gui:GetDescendants()) do if child:IsA("TextLabel") or child:IsA("TextBox") then child.Visible = true; child.TextTransparency = 0; if child.BackgroundTransparency ~= 1 then child.BackgroundTransparency = 0 end elseif child:IsA("ImageLabel") then child.Visible = true; child.ImageTransparency = 0 end end end end end
F.scanYourOriginalTags = function(ch) if S.hasSavedOriginalTags then return end; if not ch then return end; local head = ch:FindFirstChild("Head"); if not head then return end; table.clear(S.originalTags); local foundTags = false; for _, child in ipairs(head:GetChildren()) do if child:IsA("BillboardGui") or child:IsA("SurfaceGui") then pcall(function() child.Archivable = true; table.insert(S.originalTags, child:Clone()); foundTags = true end) end end; if foundTags then S.hasSavedOriginalTags = true end end
F.ensureOriginalTagsScanned = function(ch) if S.hasSavedOriginalTags then return end; if not ch then return end; F.scanYourOriginalTags(ch); if not S.hasSavedOriginalTags then local head = ch:WaitForChild("Head", 5); if not head then return end; local conn; conn = head.ChildAdded:Connect(function(child) if child:IsA("BillboardGui") or child:IsA("SurfaceGui") then task.wait(0.1); if not S.hasSavedOriginalTags and head.Parent then F.scanYourOriginalTags(ch); if S.hasSavedOriginalTags and conn then conn:Disconnect() end end end end); RegisterConnection(conn); task.delay(3, function() if conn then conn:Disconnect() end end) end end

-- HumanoidDescription <-> plain table (format v2). Older flat tables still decode.
local Codec = {}
Codec.assetFields = {"Face", "Head", "Torso", "LeftArm", "RightArm", "LeftLeg", "RightLeg", "Shirt", "Pants", "GraphicTShirt",
    "ClimbAnimation", "FallAnimation", "IdleAnimation", "JumpAnimation", "RunAnimation", "SwimAnimation", "WalkAnimation", "MoodAnimation"}
Codec.scaleFields = {"BodyTypeScale", "DepthScale", "HeadScale", "HeightScale", "ProportionScale", "WidthScale"}
Codec.colorFields = {"HeadColor", "LeftArmColor", "RightArmColor", "LeftLegColor", "RightLegColor", "TorsoColor"}
Codec.accessoryFields = {"HatAccessory", "HairAccessory", "FaceAccessory", "NeckAccessory", "ShouldersAccessory", "FrontAccessory", "BackAccessory", "WaistAccessory"}
function Codec.number(v, low, high)
    return type(v) == "number" and v == v and v >= low and v <= high
end
function Codec.id(v)
    local n = tonumber(v)
    return Codec.number(n, 1, 9007199254740991) and n % 1 == 0 and n or nil
end
function Codec.encode(desc)
    local data = {Version = 2, Properties = {}, Colors = {}, Accessories = {}, Emotes = {}, EquippedEmotes = {}}
    for _, fields in ipairs({Codec.assetFields, Codec.scaleFields, Codec.accessoryFields}) do
        for _, field in ipairs(fields) do pcall(function() data.Properties[field] = desc[field] end) end
    end
    for _, field in ipairs(Codec.colorFields) do
        local c = desc[field]; data.Colors[field] = {c.R, c.G, c.B}
    end
    local ok, list = pcall(function() return desc:GetAccessories(true) end)
    data.HasAccessories = ok
    if ok then
        for _, item in ipairs(list) do
            local row = {AssetId = item.AssetId, AccessoryType = item.AccessoryType.Name, IsLayered = item.IsLayered}
            if item.Order ~= nil then row.Order = item.Order end
            if item.Puffiness ~= nil then row.Puffiness = item.Puffiness end
            for _, key in ipairs({"Position", "Rotation", "Scale"}) do
                local v = item[key]
                if typeof(v) == "Vector3" then row[key] = {v.X, v.Y, v.Z} end
            end
            table.insert(data.Accessories, row)
        end
    end
    pcall(function() data.Emotes = desc:GetEmotes() end)
    pcall(function() data.EquippedEmotes = desc:GetEquippedEmotes() end)
    return data
end
function Codec.decode(data)
    assert(type(data) == "table", "Invalid avatar data.")
    assert(data.Version == nil or data.Version == 2, "Unsupported avatar version.")
    local props = data.Version == 2 and data.Properties or data
    assert(type(props) == "table" and next(props) ~= nil, "Saved avatar data is incomplete.")
    local desc = Instance.new("HumanoidDescription")
    local assigned = 0
    for _, field in ipairs(Codec.assetFields) do
        local v = props[field]
        if Codec.number(v, 0, 9007199254740991) and v % 1 == 0 then
            local ok = pcall(function() desc[field] = v end); if ok then assigned = assigned + 1 end
        end
    end
    for _, field in ipairs(Codec.scaleFields) do
        if Codec.number(props[field], 0, 10) then desc[field] = props[field] end
    end
    for _, field in ipairs(Codec.accessoryFields) do
        local v = props[field]
        if type(v) == "string" and #v < 6000 and v:match("^[%d,%s]*$") then pcall(function() desc[field] = v end) end
    end
    for _, field in ipairs(Codec.colorFields) do
        local c = type(data.Colors) == "table" and data.Colors[field]
        if type(c) == "table" and Codec.number(c[1], 0, 1) and Codec.number(c[2], 0, 1) and Codec.number(c[3], 0, 1) then
            desc[field] = Color3.new(c[1], c[2], c[3])
        end
    end
    if data.HasAccessories and type(data.Accessories) == "table" then
        local accessories = {}
        for i, row in ipairs(data.Accessories) do
            if i > 150 then break end
            if type(row) == "table" and Codec.id(row.AssetId) and type(row.AccessoryType) == "string" then
                local ok, kind = pcall(function() return Enum.AccessoryType[row.AccessoryType] end)
                if ok and kind then
                    local item = {AssetId = row.AssetId, AccessoryType = kind, IsLayered = row.IsLayered == true}
                    if Codec.number(row.Order, 0, 1000) then item.Order = row.Order end
                    if Codec.number(row.Puffiness, 0, 10) then item.Puffiness = row.Puffiness end
                    for _, key in ipairs({"Position", "Rotation", "Scale"}) do
                        local v = row[key]
                        if type(v) == "table" and Codec.number(v[1], -10000, 10000) and Codec.number(v[2], -10000, 10000) and Codec.number(v[3], -10000, 10000) then
                            item[key] = Vector3.new(v[1], v[2], v[3])
                        end
                    end
                    table.insert(accessories, item)
                end
            end
        end
        local ok, err = pcall(function() desc:SetAccessories(accessories, true) end)
        if not ok then desc:Destroy(); error("Saved accessories are incompatible: " .. tostring(err), 0) end
    end
    if type(data.Emotes) == "table" then
        local emotes = {}; local count = 0
        for name, ids in pairs(data.Emotes) do
            if type(name) == "string" and #name <= 100 and type(ids) == "table" and count < 100 then
                local valid = {}
                for i, id in ipairs(ids) do if i > 20 then break end; if Codec.id(id) then table.insert(valid, id) end end
                if #valid > 0 then emotes[name] = valid; count = count + 1 end
            end
        end
        pcall(function() desc:SetEmotes(emotes) end)
    end
    if type(data.EquippedEmotes) == "table" then
        local equipped = {}
        for i, row in ipairs(data.EquippedEmotes) do
            if i > 8 then break end
            if type(row) == "table" and type(row.Name) == "string" and Codec.number(row.Slot, 1, 8) and row.Slot % 1 == 0 then table.insert(equipped, {Name = row.Name, Slot = row.Slot}) end
        end
        pcall(function() desc:SetEquippedEmotes(equipped) end)
    end
    if assigned == 0 then desc:Destroy(); error("No valid avatar data was found.", 0) end
    return desc
end

-- Visual snapshots record the actual parts of a character, for skins a description can't rebuild.
local Visual = {}
-- Defined further down; declared here so applySnapshot can reach them.
local Overlay, Sync = {Active = {}}, {Peers = {}, Shown = {}}
Visual.MeshCache = {}; Visual.MeshOrder = {}
function Visual.clearCache()
    for _,part in pairs(Visual.MeshCache) do part:Destroy() end
    Visual.MeshCache = {}; Visual.MeshOrder = {}
end
function Visual.remember(part)
    if not part:IsA("MeshPart") or part.MeshId=="" or Visual.MeshCache[part.MeshId] then return end
    local ok,copy=pcall(function() return part:Clone() end)
    if not ok or not copy then return end
    copy.Parent=nil
    for _,child in ipairs(copy:GetChildren()) do child:Destroy() end
    Visual.MeshCache[part.MeshId]=copy; table.insert(Visual.MeshOrder,part.MeshId)
    if #Visual.MeshOrder>64 then
        local id=table.remove(Visual.MeshOrder,1); Visual.MeshCache[id]:Destroy(); Visual.MeshCache[id]=nil
    end
end
Visual.schemas = {
    Attachment = {CFrame="CFrame"}, Bone = {CFrame="CFrame"},
    SpecialMesh = {MeshId="string",TextureId="string",MeshType="Enum",Scale="Vector3",Offset="Vector3",VertexColor="Vector3"},
    BlockMesh = {Scale="Vector3",Offset="Vector3"}, CylinderMesh = {Scale="Vector3",Offset="Vector3"},
    Decal = {Texture="string",Face="Enum",Color3="Color3",Transparency="number"},
    Texture = {Texture="string",Face="Enum",Color3="Color3",Transparency="number",StudsPerTileU="number",StudsPerTileV="number",OffsetStudsU="number",OffsetStudsV="number"},
    SurfaceAppearance = {ColorMap="string",MetalnessMap="string",NormalMap="string",RoughnessMap="string",AlphaMode="Enum",Color="Color3"},
    WrapTarget = {CageMeshId="string",CageOrigin="CFrame",ImportOrigin="CFrame",Stiffness="number"},
    WrapLayer = {CageMeshId="string",CageOrigin="CFrame",ImportOrigin="CFrame",ReferenceMeshId="string",ReferenceOrigin="CFrame",BindOffset="CFrame",Order="number",Puffiness="number",Enabled="boolean",AutoSkin="Enum"},
    FaceControls = {},
}
-- Effects created here are tagged Lyra_Effect, so a later skin only removes its own and never the game's.
Visual.effects = {
    ParticleEmitter = {Enabled="boolean",Texture="string",Color="ColorSequence",Size="NumberSequence",Transparency="NumberSequence",
        Lifetime="NumberRange",Speed="NumberRange",Rate="number",SpreadAngle="Vector2",Rotation="NumberRange",RotSpeed="NumberRange",
        LightEmission="number",LightInfluence="number",Drag="number",Acceleration="Vector3",EmissionDirection="Enum",Shape="Enum",ZOffset="number"},
    Fire = {Enabled="boolean",Color="Color3",SecondaryColor="Color3",Heat="number",Size="number"},
    Sparkles = {Enabled="boolean",Color="Color3",SparkleColor="Color3"},
    Smoke = {Enabled="boolean",Color="Color3",Opacity="number",RiseVelocity="number",Size="number"},
    PointLight = {Enabled="boolean",Color="Color3",Brightness="number",Range="number",Shadows="boolean"},
    SpotLight = {Enabled="boolean",Color="Color3",Brightness="number",Range="number",Angle="number",Face="Enum",Shadows="boolean"},
    SurfaceLight = {Enabled="boolean",Color="Color3",Brightness="number",Range="number",Angle="number",Face="Enum",Shadows="boolean"},
    -- Trails and beams point at attachments; only sibling attachments (saved by name) can be rebuilt.
    Trail = {Enabled="boolean",Attachment0="Attachment",Attachment1="Attachment",Color="ColorSequence",Transparency="NumberSequence",
        WidthScale="NumberSequence",Texture="string",TextureLength="number",TextureMode="Enum",Lifetime="number",MinLength="number",
        MaxLength="number",LightEmission="number",LightInfluence="number",Brightness="number",FaceCamera="boolean"},
    Beam = {Enabled="boolean",Attachment0="Attachment",Attachment1="Attachment",Color="ColorSequence",Transparency="NumberSequence",
        Texture="string",TextureLength="number",TextureMode="Enum",TextureSpeed="number",Width0="number",Width1="number",
        CurveSize0="number",CurveSize1="number",Segments="number",LightEmission="number",LightInfluence="number",Brightness="number",
        FaceCamera="boolean",ZOffset="number"},
}
for class,fields in pairs(Visual.effects) do Visual.schemas[class]=fields end
function Visual.array(value, length, low, high)
    if type(value) ~= "table" or #value ~= length then return false end
    for i=1,length do if not Codec.number(value[i],low,high) then return false end end
    return true
end
function Visual.asset(value)
    return type(value)=="string" and #value<=300 and (value=="" or value:match("^rbxassetid://%d+$") or value:match("^https?://[%w%.%-]+/[^%s]*[?&]id=%d+") or value:match("^rbxasset://[%w%p]+$"))
end
function Visual.pack(value, kind)
    if kind=="CFrame" then return {value:GetComponents()} end
    if kind=="Vector3" then return {value.X,value.Y,value.Z} end
    if kind=="Color3" then return {value.R,value.G,value.B} end
    if kind=="Enum" then return {tostring(value.EnumType):gsub("^Enum%.",""),value.Name} end
    if kind=="Vector2" then return {value.X,value.Y} end
    if kind=="NumberRange" then return {value.Min,value.Max} end
    if kind=="ColorSequence" then
        local keys={}
        for i,key in ipairs(value.Keypoints) do keys[i]={key.Time,key.Value.R,key.Value.G,key.Value.B} end
        return keys
    end
    if kind=="NumberSequence" then
        local keys={}
        for i,key in ipairs(value.Keypoints) do keys[i]={key.Time,key.Value,key.Envelope} end
        return keys
    end
    return value
end
function Visual.unpack(value, kind)
    if kind=="CFrame" then return CFrame.new(table.unpack(value)) end
    if kind=="Vector3" then return Vector3.new(table.unpack(value)) end
    if kind=="Color3" then return Color3.new(table.unpack(value)) end
    if kind=="Enum" then return Enum[value[1]][value[2]] end
    if kind=="Vector2" then return Vector2.new(table.unpack(value)) end
    if kind=="NumberRange" then return NumberRange.new(value[1],value[2]) end
    if kind=="ColorSequence" then
        local keys={}
        for i,key in ipairs(value) do keys[i]=ColorSequenceKeypoint.new(key[1],Color3.new(key[2],key[3],key[4])) end
        return ColorSequence.new(keys)
    end
    if kind=="NumberSequence" then
        local keys={}
        for i,key in ipairs(value) do keys[i]=NumberSequenceKeypoint.new(key[1],key[2],key[3] or 0) end
        return NumberSequence.new(keys)
    end
    return value
end
function Visual.valueValid(value, kind, effect)
    if kind=="CFrame" then
        if not Visual.array(value,12,-128,128) then return false end
        for i=4,12 do if math.abs(value[i])>1.001 then return false end end
        return true
    end
    -- Effect vectors are forces (particle acceleration such as gravity), not sizes.
    if kind=="Vector3" then local limit=effect and 100000 or 128; return Visual.array(value,3,-limit,limit) end
    -- Roblox accepts colour channels above 1 (HDR glow, used by particle, fire and light effects).
    if kind=="Color3" then return Visual.array(value,3,-100000,100000) end
    if kind=="Enum" then
        return type(value)=="table" and #value==2 and type(value[1])=="string" and #value[1]<60 and type(value[2])=="string" and #value[2]<60
    end
    if kind=="Vector2" or kind=="NumberRange" then return Visual.array(value,2,-100000,100000) end
    if kind=="ColorSequence" then
        if type(value)~="table" or #value<2 or #value>20 then return false end
        for _,key in ipairs(value) do
            if not (Visual.array(key,4,-100000,100000) and Codec.number(key[1],0,1)) then return false end
        end
        return true
    end
    if kind=="NumberSequence" then
        if type(value)~="table" or #value<2 or #value>20 then return false end
        for _,key in ipairs(value) do
            if not (Codec.number(key[1],0,1) and Codec.number(key[2],-100000,100000) and Codec.number(key[3] or 0,-100000,100000)) then return false end
        end
        return true
    end
    if kind=="Attachment" then return type(value)=="string" and #value<=120 end
    if kind=="number" then return Codec.number(value,-100000,100000) end
    return type(value)==kind and (kind~="string" or #value<=300)
end
function Visual.nodes(parent, depth)
    assert(depth<12,"Visual hierarchy is too deep.")
    local rows={}
    for _,item in ipairs(parent:GetChildren()) do
        local schema=Visual.schemas[item.ClassName]
        if schema then
            local row={Class=item.ClassName,Name=item.Name,Properties={},Children=Visual.nodes(item,depth+1)}
            for field,kind in pairs(schema) do
                local ok,value=pcall(function() return item[field] end)
                if ok and kind=="Attachment" then
                    if typeof(value)=="Instance" and value:IsA("Attachment") and value.Parent==parent then row.Properties[field]=value.Name end
                elseif ok then row.Properties[field]=Visual.pack(value,kind) end
            end
            table.insert(rows,row)
        end
    end
    return rows
end
function Visual.validateNodes(rows, depth, budget)
    assert(type(rows)=="table" and depth<12,"Invalid visual nodes.")
    for _,row in ipairs(rows) do
        budget[1]=budget[1]+1; assert(budget[1]<=4000,"Skin is too complex.")
        assert(type(row)=="table" and Visual.schemas[row.Class] and type(row.Name)=="string" and #row.Name<=120,"Invalid visual node.")
        assert(type(row.Properties)=="table","Missing visual properties.")
        for field,value in pairs(row.Properties) do
            local kind=Visual.schemas[row.Class][field]
            if not (kind and Visual.valueValid(value,kind,Visual.effects[row.Class]~=nil)) then
                -- A bad effect value is dropped; the rest of the skin still applies.
                assert(Visual.effects[row.Class],"Invalid visual property: "..tostring(field))
                row.Properties[field]=nil
            end
        end
        Visual.validateNodes(row.Children or {},depth+1,budget)
    end
end
function Visual.part(part)
    Visual.remember(part)
    local row={Class=part:IsA("MeshPart") and "MeshPart" or "Part",Size=Visual.pack(part.Size,"Vector3"),Color=Visual.pack(part.Color,"Color3"),Transparency=part.Transparency,Nodes=Visual.nodes(part,0)}
    if part:IsA("MeshPart") then row.MeshId=part.MeshId; row.TextureId=part.TextureID end
    row.Material=part.Material.Name; row.Reflectance=part.Reflectance
    local original=part:FindFirstChild("OriginalSize")
    if original and original:IsA("Vector3Value") then row.OriginalSize=Visual.pack(original.Value,"Vector3") end
    local scaleType=part:FindFirstChild("AvatarPartScaleType")
    if scaleType and scaleType:IsA("StringValue") then row.ScaleType=scaleType.Value end
    return row
end
function Visual.validate(v)
    assert(type(v)=="table" and v.Version==1 and (v.RigType=="R15" or v.RigType=="R6"),"Invalid skin format or rig.")
    assert(type(v.Body)=="table" and type(v.Accessories)=="table" and #v.Accessories<=150,"Invalid body/accessories.")
    local count,budget=0,{0}
    local function part(row)
        assert(type(row)=="table" and (row.Class=="Part" or row.Class=="MeshPart"),"Invalid part type.")
        assert(Visual.array(row.Size,3,0.001,64) and Visual.array(row.Color,3,0,1) and Codec.number(row.Transparency,0,1),"Invalid dimensions or colors.")
        if row.Class=="MeshPart" then assert(Visual.asset(row.MeshId) and row.MeshId~="" and Visual.asset(row.TextureId or ""),"Invalid mesh/texture ID.") end
        if row.Nodes then Visual.validateNodes(row.Nodes,0,budget) end
        if row.OriginalSize then assert(Visual.array(row.OriginalSize,3,0.001,64),"Invalid original dimensions.") end
        if row.ScaleType then assert(type(row.ScaleType)=="string" and #row.ScaleType<80,"Invalid scale type.") end
    end
    for name,row in pairs(v.Body) do assert(S.BD[name] and name~="HumanoidRootPart","Unknown body part."); part(row); count=count+1 end
    assert(count>0 and count<=20,"The skin contains no body.")
    for _,row in ipairs(v.Accessories) do
        assert(type(row)=="table" and type(row.Name)=="string" and #row.Name<=120,"Invalid accessory."); part(row.Handle)
        if row.AttachmentPoint then assert(Visual.valueValid(row.AttachmentPoint,"CFrame"),"Invalid attachment.") end
    end
    for name,id in pairs(v.Clothes or {}) do assert((name=="Shirt" or name=="Pants" or name=="Graphic") and Visual.asset(id),"Invalid clothing.") end
    for name,color in pairs(v.Colors or {}) do assert(({Head=true,Torso=true,LeftArm=true,RightArm=true,LeftLeg=true,RightLeg=true})[name] and Visual.array(color,3,0,1),"Invalid color.") end
    assert(type(v.Links or {})=="table" and #(v.Links or {})<=32,"Invalid joints.")
    for _,link in ipairs(v.Links or {}) do
        assert(type(link)=="table" and S.BD[link.A] and S.BD[link.B] and Visual.valueValid(link.C0,"CFrame") and Visual.valueValid(link.C1,"CFrame"),"Invalid body connection.")
    end
    for name,value in pairs(v.Scales or {}) do
        assert(({BodyDepthScale=true,BodyHeightScale=true,BodyWidthScale=true,HeadScale=true,BodyProportionScale=true,BodyTypeScale=true})[name] and Codec.number(value,0,10),"Invalid scale.")
    end
    if v.HipHeight~=nil then assert(Codec.number(v.HipHeight,0,64),"Invalid height.") end
    if v.RootSize then assert(Visual.array(v.RootSize,3,0.001,64),"Invalid root dimensions.") end
    assert(type(v.Animations or {})=="table" and #(v.Animations or {})<=100,"Invalid animations.")
    for _,row in ipairs(v.Animations or {}) do
        assert(type(row)=="table" and type(row.Path)=="table" and #row.Path<=12 and Visual.asset(row.Id),"Invalid animation.")
        for _,name in ipairs(row.Path) do assert(type(name)=="string" and #name<=120,"Invalid animation path.") end
    end
    return v
end
function Visual.capture(character, animations)
    local hum=character and character:FindFirstChildOfClass("Humanoid")
    assert(hum and character==lp.Character,"Wait for your character to load.")
    local v={Version=1,RigType=hum.RigType.Name,Body={},Accessories={},Clothes={},Colors={},Scales={},Links={},HipHeight=hum.HipHeight,Animations=animations or {}}
    local root=character:FindFirstChild("HumanoidRootPart")
    assert(root and root:IsA("BasePart"),"Wait for your character's root to load.")
    v.RootSize=Visual.pack(root.Size,"Vector3")
    for _,part in ipairs(character:GetChildren()) do
        if Appearance.isBody(part,character) and part.Name~="HumanoidRootPart" then
            local display=character:FindFirstChild("LyraVisual_"..part.Name)
            if display and display:GetAttribute("Lyra_VisualFor")~=part.Name then display=nil end
            local row=Visual.part(display or part)
            if display then
                for i=#row.Nodes,1,-1 do if row.Nodes[i].Class=="Attachment" then table.remove(row.Nodes,i) end end
                for _,node in ipairs(Visual.nodes(part,0)) do if node.Class=="Attachment" then table.insert(row.Nodes,node) end end
            end
            row.Size=Visual.pack(part.Size,"Vector3"); v.Body[part.Name]=row
        elseif part:IsA("Accessory") then
            local handle=part:FindFirstChild("Handle")
            if handle and handle:IsA("BasePart") then
                for _,child in ipairs(part:GetDescendants()) do assert(not child:IsA("BasePart") or child==handle,"Multi-part accessories are not supported: "..part.Name) end
                table.insert(v.Accessories,{Name=part.Name,Type=part.AccessoryType.Name,Handle=Visual.part(handle),AttachmentPoint=Visual.pack(part.AttachmentPoint,"CFrame")})
            end
        elseif part:IsA("Shirt") then v.Clothes.Shirt=part.ShirtTemplate
        elseif part:IsA("Pants") then v.Clothes.Pants=part.PantsTemplate
        elseif part:IsA("ShirtGraphic") then v.Clothes.Graphic=part.Graphic
        elseif part:IsA("BodyColors") then
            for _,name in ipairs({"Head","Torso","LeftArm","RightArm","LeftLeg","RightLeg"}) do v.Colors[name]=Visual.pack(part[name.."Color3"],"Color3") end
        end
    end
    for _,name in ipairs({"BodyDepthScale","BodyHeightScale","BodyWidthScale","HeadScale","BodyProportionScale","BodyTypeScale"}) do
        local value=hum:FindFirstChild(name); if value and value:IsA("NumberValue") then v.Scales[name]=value.Value end
    end
    for _,link in ipairs(Rig.links(character)) do
        if Appearance.isBody(link.A,character) and Appearance.isBody(link.B,character) then
            table.insert(v.Links,{A=link.A.Name,B=link.B.Name,C0=Visual.pack(link.C0,"CFrame"),C1=Visual.pack(link.C1,"CFrame")})
        end
    end
    return Visual.validate(v)
end
function Visual.legacy(raw)
    assert(type(raw)=="table" and (type(raw.MembrosCorpo)=="table" or type(raw.MembrosCustom)=="table"),"Old JSON not recognized.")
    local v={Version=1,RigType=raw.RigType,Body={},Accessories={},Clothes=raw.Roupas or {},Colors=raw.Cores or {},Scales=raw.Escalas or {},Links={},Animations={},Legacy=true}
    local function part(old, accessory)
        local row={Class="MeshPart",Size=old.Size,Color=old.Color,Transparency=old.Transparency or 0,MeshId=old.MeshId,TextureId=old.TextureId or "",Nodes={}}
        if old.SurfaceColorMap and old.SurfaceColorMap~="" then table.insert(row.Nodes,{Class="SurfaceAppearance",Name="SurfaceAppearance",Properties={ColorMap=old.SurfaceColorMap},Children={}}) end
        if accessory and old.AttachmentName then table.insert(row.Nodes,{Class="Attachment",Name=old.AttachmentName,Properties={CFrame=old.AttachmentCFrame},Children={}}) end
        -- These files do not record whether a Handle was a SpecialMesh or MeshPart.
        -- Non-default mesh transforms identify the SpecialMesh form unambiguously.
        local sc,off=old.Scale,old.Offset
        if accessory and ((sc and (sc[1]~=1 or sc[2]~=1 or sc[3]~=1)) or (off and (off[1]~=0 or off[2]~=0 or off[3]~=0))) then
            row.Class="Part"
            table.insert(row.Nodes,{Class="SpecialMesh",Name="Mesh",Properties={MeshType={"MeshType","FileMesh"},MeshId=old.MeshId,TextureId=old.TextureId or "",Scale=sc or {1,1,1},Offset=off or {0,0,0}},Children={}})
        end
        return row
    end
    for name,row in pairs(raw.MembrosCustom or raw.MembrosCorpo) do v.Body[name]=part(row,false) end
    for _,row in ipairs(raw.Acessorios or {}) do table.insert(v.Accessories,{Name=row.Nome or "Accessory",Handle=part(row,true)}) end
    if raw.IsHeadless and v.Body.Head then v.Body.Head.Transparency=1 end
    for name,id in pairs(raw.Animacoes or {}) do table.insert(v.Animations,{Path={name},Id=id}) end
    Visual.validate(v)
    local properties={}; for _,field in ipairs(Codec.assetFields) do properties[field]=0 end
    local map={BodyTypeScale="BodyTypeScale",BodyProportionScale="ProportionScale",HeadScale="HeadScale",BodyWidthScale="WidthScale",BodyDepthScale="DepthScale",BodyHeightScale="HeightScale"}
    for name,value in pairs(v.Scales) do properties[map[name]]=value end
    local colors={}; for name,color in pairs(v.Colors) do colors[name.."Color"]=color end
    return {Version=2,Properties=properties,Colors=colors,Accessories={},HasAccessories=true,Emotes={},EquippedEmotes={},Visual=v}
end
function Visual.restoreNodes(parent, rows, preserveAttachments)
    local kept,links={},{}
    for _,row in ipairs(rows or {}) do
        local item=parent:FindFirstChild(row.Name)
        if item and item.ClassName~=row.Class then item:Destroy(); item=nil end
        local effect=Visual.effects[row.Class]~=nil
        if not item then
            item=Instance.new(row.Class); item.Name=row.Name; item.Parent=parent
            if effect then item:SetAttribute("Lyra_Effect",true) end
        end
        kept[item]=true
        for field,value in pairs(row.Properties) do
            local kind=Visual.schemas[row.Class][field]
            if kind=="Attachment" then
                table.insert(links,{Item=item,Field=field,Name=value})
            else
                local ok,err=pcall(function()
                    local decoded=Visual.unpack(value,kind)
                    if item[field]~=decoded then item[field]=decoded end
                end)
                if not ok and not effect then error("Could not rebuild "..row.Class.."."..field..": "..tostring(err),0) end
            end
        end
        Visual.restoreNodes(item,row.Children,false)
    end
    -- Attachments may come after the trail/beam that uses them, so links are set once every sibling exists.
    for _,link in ipairs(links) do
        local target=parent:FindFirstChild(link.Name)
        if target and target:IsA("Attachment") then pcall(function() link.Item[link.Field]=target end) end
    end
    for _,item in ipairs(parent:GetChildren()) do
        local ours=Visual.effects[item.ClassName]~=nil and item:GetAttribute("Lyra_Effect")==true
        local schemaOwned=Visual.schemas[item.ClassName] and Visual.effects[item.ClassName]==nil
        if (schemaOwned or ours) and not kept[item] and not (preserveAttachments and item:IsA("Attachment")) then item:Destroy() end
    end
end
function Visual.mesh(id)
    if Visual.MeshCache[id] then return Visual.MeshCache[id]:Clone() end
    local ok,part=pcall(function() return game:GetService("AssetService"):CreateMeshPartAsync(Content.fromUri(id),{}) end)
    if not ok then ok,part=pcall(function() return game:GetService("InsertService"):CreateMeshPartAsync(id,Enum.CollisionFidelity.Default,Enum.RenderFidelity.Automatic) end) end
    assert(ok and part and part:IsA("MeshPart"),"Roblox could not load mesh "..id..". Your character has not been changed yet.")
    if not IsAlive() then part:Destroy(); error("Execution ended.",0) end
    Visual.remember(part)
    return part
end
function Visual.applyPart(target,row,preserveAttachments)
    if row.Class=="MeshPart" and target.MeshId~=row.MeshId then
        local mesh=Visual.mesh(row.MeshId)
        local ok,err=pcall(function() target:ApplyMesh(mesh) end); mesh:Destroy()
        assert(ok,"Could not prepare the mesh: "..tostring(err))
    end
    target.Size=Visual.unpack(row.Size,"Vector3"); target.Color=Visual.unpack(row.Color,"Color3"); target.Transparency=row.Transparency
    if target:IsA("MeshPart") then target.TextureID=row.TextureId or "" end
    if row.Material then pcall(function() target.Material=Enum.Material[row.Material] end) end
    target.Reflectance=row.Reflectance or 0
    Visual.restoreNodes(target,row.Nodes,preserveAttachments)
    local original=target:FindFirstChild("OriginalSize") or Instance.new("Vector3Value")
    original.Name="OriginalSize"; original.Value=Visual.unpack(row.OriginalSize or row.Size,"Vector3"); original.Parent=target
    if row.ScaleType then
        local scaleType=target:FindFirstChild("AvatarPartScaleType") or Instance.new("StringValue")
        scaleType.Name="AvatarPartScaleType"; scaleType.Value=row.ScaleType; scaleType.Parent=target
    end
end
function Visual.overlay(model,v)
    Visual.validate(v)
    model:SetAttribute("Lyra_VisualSnapshot",true)
    local hum=model:FindFirstChildOfClass("Humanoid")
    assert(hum and hum.RigType.Name==v.RigType,"This skin is "..v.RigType.."; apply it to a character of the same rig type.")
    hum.AutomaticScalingEnabled=false
    if v.RootSize then model:FindFirstChild("HumanoidRootPart").Size=Visual.unpack(v.RootSize,"Vector3") end
    local oldSizes={}
    for name,row in pairs(v.Body) do
        local part=model:FindFirstChild(name); assert(part and part:IsA("BasePart"),"Missing limb: "..name)
        oldSizes[name]=part.Size
        if part.ClassName~=row.Class then
            local replacement=Instance.new(row.Class); replacement.Name=name; replacement.CFrame=part.CFrame; replacement.Size=part.Size; replacement.Parent=model
            for _,child in ipairs(part:GetChildren()) do child.Parent=replacement end
            for _,joint in ipairs(model:GetDescendants()) do
                if joint:IsA("JointInstance") or joint:IsA("WeldConstraint") then
                    if joint.Part0==part then joint.Part0=replacement end
                    if joint.Part1==part then joint.Part1=replacement end
                end
            end
            replacement.Parent=model; part:Destroy(); part=replacement
        end
        -- Generated AnimationConstraints may refer to sockets absent in an older
        -- Motor6D snapshot. Retain those instances and set their offsets below.
        Visual.applyPart(part,row,true)
    end
    local function scaleOffset(cf,ratio) return CFrame.new(cf.Position*ratio)*(cf-cf.Position) end
    local links=Rig.links(model)
    if v.Legacy then
        for name,old in pairs(oldSizes) do
            local part=model:FindFirstChild(name)
            for _,at in ipairs(part:GetChildren()) do if at:IsA("Attachment") and not at:IsA("Bone") then at.CFrame=scaleOffset(at.CFrame,part.Size/old) end end
        end
    end
    for _,link in ipairs(links) do
        if Appearance.isBody(link.A,model) and Appearance.isBody(link.B,model) then
            local a,b
            for _,saved in ipairs(v.Links) do
                if saved.A==link.A.Name and saved.B==link.B.Name then a=Visual.unpack(saved.C0,"CFrame"); b=Visual.unpack(saved.C1,"CFrame"); break end
                if saved.B==link.A.Name and saved.A==link.B.Name then b=Visual.unpack(saved.C0,"CFrame"); a=Visual.unpack(saved.C1,"CFrame"); break end
            end
            if not a and v.Legacy then
                local ra=oldSizes[link.A.Name] and link.A.Size/oldSizes[link.A.Name] or Vector3.new(1,1,1)
                local rb=oldSizes[link.B.Name] and link.B.Size/oldSizes[link.B.Name] or Vector3.new(1,1,1)
                a=scaleOffset(link.C0,ra); b=scaleOffset(link.C1,rb)
            end
            assert(a and b,"The skin is missing the joints required for "..link.A.Name.." / "..link.B.Name)
            if link.Object:IsA("JointInstance") then link.Object.C0=a; link.Object.C1=b
            elseif link.Object:IsA("RigidConstraint") or link.Object:IsA("AnimationConstraint") then link.Object.Attachment0.CFrame=a; link.Object.Attachment1.CFrame=b
            else error("Body joint cannot be adjusted.",0) end
        end
    end
    for _,item in ipairs(model:GetChildren()) do
        if item:IsA("Accessory") or item:IsA("Shirt") or item:IsA("Pants") or item:IsA("ShirtGraphic") or item:IsA("BodyColors") then item:Destroy() end
    end
    for name,id in pairs(v.Clothes or {}) do
        local item=Instance.new(name=="Graphic" and "ShirtGraphic" or name)
        item[name=="Graphic" and "Graphic" or name.."Template"]=id; item.Parent=model
    end
    if next(v.Colors or {}) then
        local colors=Instance.new("BodyColors")
        for name,color in pairs(v.Colors) do colors[name.."Color3"]=Visual.unpack(color,"Color3") end
        colors.Parent=model
    end
    for name,row in pairs(v.Body) do model:FindFirstChild(name).Color=Visual.unpack(row.Color,"Color3") end
    for _,row in ipairs(v.Accessories) do
        local accessory=Instance.new("Accessory"); accessory.Name=row.Name; accessory.Parent=model
        if row.Type then pcall(function() accessory.AccessoryType=Enum.AccessoryType[row.Type] end) end
        if row.AttachmentPoint then accessory.AttachmentPoint=Visual.unpack(row.AttachmentPoint,"CFrame") end
        local handle=Instance.new(row.Handle.Class); handle.Name="Handle"; handle.Parent=accessory
        Visual.applyPart(handle,row.Handle,false)
        local attached,err=Appearance.attach(model,accessory); assert(attached,"Invalid attachment: "..row.Name.." / "..tostring(err))
    end
    for name,value in pairs(v.Scales or {}) do
        local scale=hum:FindFirstChild(name) or Instance.new("NumberValue"); scale.Name=name; scale.Value=value; scale.Parent=hum
    end
    if v.HipHeight then hum.HipHeight=v.HipHeight
    elseif v.Legacy and v.RigType=="R15" then
        Rig.reachable(model,true)
        local root=model:FindFirstChild("HumanoidRootPart"); local bottom=math.huge
        for _,name in ipairs({"LeftFoot","RightFoot"}) do local foot=model:FindFirstChild(name); if foot then bottom=math.min(bottom,foot.Position.Y-foot.Size.Y/2) end end
        if root and bottom<math.huge then hum.HipHeight=math.max(0,root.Position.Y-root.Size.Y/2-bottom) end
    end
    return model
end
function Visual.model(data,desc,rig)
    local visual,note=data.Visual,nil
    if visual and visual.RigType~=rig.Name then
        -- Snapshots are rig specific. On another rig the skin is rebuilt from its description.
        note="This skin was saved on "..visual.RigType.." but your character is "..rig.Name.."; it was rebuilt from its avatar description, so custom details may differ."
        visual=nil
    end
    local model=API.model(desc,rig)
    if visual then
        local ok,err=pcall(Visual.overlay,model,visual)
        if not ok then model:Destroy(); error(err,0) end
    end
    return model,note
end

local Store = {File = "Copier_SavedProfiles.json", Favorites = {}, Recent = {}, Looks = {}, LoadIssue = nil, Generation = 0}
Store.Settings = {AutoReset = false, CopyAnims = Config.CopyAnimation, AutoReapply = true, MapPersist = true,
    GlassBlur = true, MobileOrb = true, ReducedMotion = false, LowEffects = false, Keybind = "RightControl",
    SwapEffect = true, Notifications = true, StartHidden = false, MenuReopen = true, HideTipSeen = false, MenuAvatar = true, SkinSync = true, VisualOnly = false, UIScale = 85, ScaleMigrated = false, WindowW = 0, WindowH = 0}
-- 0 means automatic. Window sizes are unscaled pixels.
Store.SettingRanges = {UIScale = {70, 130}, WindowW = {300, 4000}, WindowH = {240, 4000}}
-- Entries are a Roblox profile ({Kind="User"}) or a saved skin ({Kind="Look"}).
Store.Auto = {LoadEnabled = false, LoadSource = "Chosen", LoadDelay = 2, Chosen = nil, Last = nil, Games = {},
    CycleEnabled = false, Trigger = "Death", EveryDeaths = 1, TimerSeconds = 120, Order = "Sequential", Cooldown = 3,
    EndAction = "Loop", Resume = true, Notify = true, Index = 0, List = {}}
Store.AutoOptions = {LoadSource = {"Chosen", "Last", "Random", "Cycle"}, Trigger = {"Death", "Respawn", "Timer", "Both"},
    Order = {"Sequential", "Shuffle", "Random", "PingPong"}, EndAction = {"Loop", "Stop", "Restore"}}
-- Discord invite pacing, see UI.schedulePromo.
Store.Promo = {Runs = 0, Shown = 0, FirstAt = 0}
Store.AutoRanges = {LoadDelay = {0, 30}, EveryDeaths = {1, 50}, TimerSeconds = {10, 3600}, Cooldown = {0, 300}, Index = {0, 50}}
function Store.entry(row)
    if type(row) ~= "table" then return nil end
    if row.Kind == "Look" then
        local key = type(row.Key) == "string" and row.Key:sub(1, 80) or ""
        if key == "" then return nil end
        return {Kind = "Look", Key = key, Name = type(row.Name) == "string" and row.Name:sub(1, 48) or "Saved skin"}
    end
    local id = Codec.id(row.Id)
    local name = type(row.Name) == "string" and row.Name:sub(1, 64) or ""
    if not id and not name:match("^[%w_]+$") then return nil end
    if name == "" then name = tostring(id) end
    return {Kind = "User", Id = id, Name = name, DisplayName = type(row.DisplayName) == "string" and row.DisplayName:sub(1, 80) or name}
end
function Store.loadAuto(saved)
    if type(saved) ~= "table" then return end
    local auto = Store.Auto
    for _, key in ipairs({"LoadEnabled", "CycleEnabled", "Resume", "Notify"}) do
        if type(saved[key]) == "boolean" then auto[key] = saved[key] end
    end
    for key, range in pairs(Store.AutoRanges) do
        if type(saved[key]) == "number" and saved[key] == saved[key] then auto[key] = math.clamp(math.floor(saved[key]), range[1], range[2]) end
    end
    for key, options in pairs(Store.AutoOptions) do
        if table.find(options, saved[key]) then auto[key] = saved[key] end
    end
    auto.Chosen = Store.entry(saved.Chosen); auto.Last = Store.entry(saved.Last)
    if type(saved.Games) == "table" then
        local count = 0
        for place, row in pairs(saved.Games) do
            local entry = Store.entry(row)
            if count < 100 and type(place) == "string" and place:match("^%d+$") and entry then auto.Games[place] = entry; count = count + 1 end
        end
    end
    if type(saved.List) == "table" then
        for _, row in ipairs(saved.List) do
            local entry = Store.entry(row)
            if #auto.List >= 50 then break end
            if entry then table.insert(auto.List, entry) end
        end
    end
    if auto.Index > #auto.List then auto.Index = 0 end
end
function Store.read(file)
    if type(readfile) ~= "function" then return nil, "Storage unavailable. Data will remain in this session." end
    local knownExists = false
    if type(isfile) == "function" then local ok, exists = pcall(isfile, file); if ok and not exists then return nil end; knownExists = ok and exists end
    local ok, raw = pcall(readfile, file)
    if not ok then return nil, knownExists and "The saved file could not be opened." or nil end
    if type(raw) ~= "string" or #raw > 16000000 then return nil, "The saved file is invalid or too large." end
    local decoded, data = pcall(function() return HttpService:JSONDecode(raw) end)
    if not decoded or type(data) ~= "table" then return nil, "The saved file could not be read." end
    return data
end
function Store.write(file, data)
    if type(writefile) ~= "function" then return false, "File access unavailable. Changes will remain in this session." end
    local ok, result = pcall(function() return HttpService:JSONEncode(data) end)
    if not ok then return false, "The data could not be prepared." end
    if #result > 16000000 then return false, "Storage is full (16 MB). Remove some skins to save again." end
    -- Writing a large file can freeze a phone for a moment, so skip unchanged writes.
    Store.Written = Store.Written or {}
    if Store.Written[file] == result then return true end
    -- Back up the previous file first. A full parse is slow on big files, so a shape check skips one
    -- that an interrupted write left cut short.
    if type(readfile) == "function" then
        local oldOK, old = pcall(readfile, file)
        if oldOK and type(old) == "string" and #old <= 16000000 and old:match("^%s*{") and old:match("}%s*$") then
            pcall(writefile, file .. ".bak", old)
        end
    end
    local written = pcall(writefile, file, result)
    if written then Store.Written[file] = result end
    if written then return true end
    return false, "Saving failed. Your data remains available in this session."
end
function Store.normalize(list, limit)
    local rows, seen = {}, {}
    if type(list) ~= "table" then return rows end
    for _, row in ipairs(list) do
        if #rows >= limit then break end
        if type(row) == "table" then
            local id = Codec.id(row.Id)
            local name = type(row.Name) == "string" and row.Name:sub(1, 64) or ""
            local key = id and tostring(id) or name:lower()
            if not seen[key] and (id or name:match("^[%w_]+$")) then
                seen[key] = true
                table.insert(rows, {Id = id, Name = name ~= "" and name or tostring(id),
                    DisplayName = type(row.DisplayName) == "string" and row.DisplayName:sub(1, 80) or name})
            end
        end
    end
    return rows
end
function Store.load()
    local data, err = Store.read(Store.File)
    if err then
        local backup = Store.read(Store.File .. ".bak")
        if backup then data = backup; err = "A recovery copy of your data was loaded." end
    end
    Store.LoadIssue = err
    if not data then return end
    if data.Version ~= nil and (type(data.Version) ~= "number" or data.Version > 4) then Store.LoadIssue = "Unsupported data format. Saving was disabled to protect the file."; Store.ReadOnly = true; return end
    Store.Favorites = Store.normalize(data.Favorites or data.SavedUsers, 200)
    Store.Recent = Store.normalize(data.Recent, 30)
    if type(data.Looks) == "table" then
        local seen = {}
        for _, row in ipairs(data.Looks) do
            if #Store.Looks >= 100 then break end
            if type(row) == "table" and type(row.Name) == "string" and type(row.Data) == "table" then
                local name = row.Name:match("^%s*(.-)%s*$"):sub(1, 48)
                local id = type(row.Key) == "string" and row.Key:sub(1, 80) or ""
                if name ~= "" and id ~= "" and not seen[id] then
                    local valid, description = pcall(function()
                        if row.Data.Visual then Visual.validate(row.Data.Visual) end
                        return Codec.decode(row.Data)
                    end)
                    if valid then
                        description:Destroy(); seen[id] = true
                        -- Names and sources saved by older Portuguese builds.
                        if name == "Novo visual" then name = "New skin" end
                        local source = type(row.Source) == "string" and row.Source:sub(1, 80) or "Imported"
                        source = source:gsub("^Meu personagem", "My character"):gsub("^Importado", "Imported"):gsub("^Código compartilhado", "Shared code")
                        table.insert(Store.Looks, {Key = id, Name = name, Data = row.Data,
                            Source = source,
                            Updated = Codec.number(row.Updated, 0, 9007199254740991) and row.Updated or os.time()})
                    end
                end
            end
        end
    end
    if type(data.Settings) == "table" then
        for key, value in pairs(Store.Settings) do
            local saved = data.Settings[key]
            if type(value) == "boolean" and type(saved) == "boolean" then Store.Settings[key] = saved end
        end
        if type(data.Settings.Keybind) == "string" then
            local ok, key = pcall(function() return Enum.KeyCode[data.Settings.Keybind] end)
            if ok and key and key ~= Enum.KeyCode.Unknown then Store.Settings.Keybind = key.Name end
        end
        for key, range in pairs(Store.SettingRanges) do
            local saved = data.Settings[key]
            if type(saved) == "number" and saved == saved then
                Store.Settings[key] = saved <= 0 and 0 or math.clamp(math.floor(saved), range[1], range[2])
            end
        end
    end
    pcall(Store.loadAuto, data.Auto)
    if type(data.Promo) == "table" then
        for key, range in pairs({Runs = 1000, Shown = 2, FirstAt = 1000}) do
            local saved = data.Promo[key]
            if type(saved) == "number" and saved == saved then Store.Promo[key] = math.clamp(math.floor(saved), 0, range) end
        end
    end
end
function Store.sync()
    Config.CopyAnimation = Store.Settings.CopyAnims
    Config.AutoReapply = Store.Settings.AutoReapply
    Config.MapPersist = Store.Settings.MapPersist
end
function Store.save()
    Store.sync()
    if Store.ReadOnly then return false, Store.LoadIssue end
    return Store.write(Store.File, {Version = 4, Favorites = Store.Favorites, Recent = Store.Recent, Looks = Store.Looks, Settings = Store.Settings, Auto = Store.Auto, Promo = Store.Promo})
end
Store.load()
-- One-time migration: a saved Auto (0) from before 85% was the default becomes 85.
if not Store.Settings.ScaleMigrated then
    if Store.Settings.UIScale == 0 then Store.Settings.UIScale = 85 end
    Store.Settings.ScaleMigrated = true
end
Store.sync()

local App = {Busy = false, QueryToken = 0, Preview = nil, Cache = {}, History = {}, Initial = nil, Current = nil, Closed = false}
App.Creator = {Name = "lyraEz", GitHub = "https://github.com/lyraEz", Discord = "https://discord.gg/8bxXcn2Vfb"}
App.Notify = function(message, kind) if kind == "error" then warn("[Lyra] " .. message) end end
App.Refresh = function() end
function App.alive() return IsAlive() and not App.Closed end
function App.report(message, kind) if App.alive() then App.Notify(message, kind or "info") end end
App.ToastSink = nil
function App.toast(spec) if App.alive() and App.ToastSink and Store.Settings.Notifications then pcall(App.ToastSink, spec) end end
function App.persist()
    local ok, err = Store.save(); if not ok then App.report(err, "warning") end
    return ok
end
function App.favoriteIndex(profile)
    for i, row in ipairs(Store.Favorites) do
        if (profile.Id and row.Id == profile.Id) or row.Name:lower() == profile.Name:lower() then return i end
    end
end
function App.toggleFavorite(profile)
    if not profile then return end
    local i = App.favoriteIndex(profile)
    if i then table.remove(Store.Favorites, i) else
        if #Store.Favorites >= 200 then App.report("The 200-favorite limit has been reached.", "warning"); return end
        table.insert(Store.Favorites, 1, {Id = profile.Id, Name = profile.Name, DisplayName = profile.DisplayName})
    end
    App.Refresh(); App.persist()
end
function App.addRecent(profile)
    for i = #Store.Recent, 1, -1 do if Store.Recent[i].Id == profile.Id then table.remove(Store.Recent, i) end end
    table.insert(Store.Recent, 1, {Id = profile.Id, Name = profile.Name, DisplayName = profile.DisplayName})
    while #Store.Recent > 30 do table.remove(Store.Recent) end
    App.Refresh(); App.persist()
end
function App.resolve(raw, valid)
    local text = tostring(raw):match("^%s*(.-)%s*$"):gsub("^@", "")
    local id = Codec.id(text)
    if not id and (not text:match("^[%w_]+$") or #text < 3 or #text > 20 or text:match("^%d+$")) then
        return nil, "Enter a valid username or numeric user ID."
    end
    local name, display
    if not id then
        for _, player in ipairs(Players:GetPlayers()) do if player.Name:lower() == text:lower() then id = player.UserId; name = player.Name; display = player.DisplayName; break end end
        if not id then
            local ok, value = pcall(function() return Players:GetUserIdFromNameAsync(text) end)
            if not valid() then return nil, "cancelled" end
            if not ok or not Codec.id(value) then return nil, "User not found or the service is unavailable. Check the username." end
            id = value
        end
    end
    if not valid() then return nil, "cancelled" end
    local cached = App.Cache[id]
    if cached and os.clock() - cached.Time < 120 then return cached.Profile end
    if not name then
        local ok, value = pcall(function() return Players:GetNameFromUserIdAsync(id) end)
        if not valid() then return nil, "cancelled" end
        if not ok then return nil, "This user ID could not be retrieved. Try again." end
        name = value
    end
    local okInfo, info = pcall(function() return US:GetUserInfosByUserIdsAsync({id}) end)
    if not valid() then return nil, "cancelled" end
    display = (okInfo and info and info[1] and info[1].DisplayName) or display or name
    local ok, desc = pcall(API.description, id)
    if not valid() then if ok and desc then desc:Destroy() end; return nil, "cancelled" end
    if not ok then return nil, "The profile exists, but its avatar could not be loaded. Try again." end
    local profile = {Id = id, Name = name, DisplayName = display, Description = desc}
    if cached then cached.Profile.Description:Destroy() end
    App.Cache[id] = {Time = os.clock(), Profile = profile}
    local count, oldestId, oldest = 0, nil, math.huge
    for k, row in pairs(App.Cache) do count = count + 1; if row.Time < oldest and k ~= id and (not App.Preview or k ~= App.Preview.Id) then oldestId = k; oldest = row.Time end end
    if count > 20 and oldestId then App.Cache[oldestId].Profile.Description:Destroy(); App.Cache[oldestId] = nil end
    return profile
end
function App.captureInitial(char)
    if App.Initial then return true end
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum then return false end
    local ok, desc = pcall(function() return hum:GetAppliedDescription() end)
    if not ok or not desc then return false end
    App.Initial = {Data = Codec.encode(desc), Name = "Initial appearance", Original = true, Animations = {}}
    local animate = char:FindFirstChild("Animate")
    if animate then
        for _, item in ipairs(animate:GetDescendants()) do
            if item:IsA("Animation") then
                local path, cursor = {}, item
                while cursor and cursor ~= animate do table.insert(path, 1, cursor.Name); cursor = cursor.Parent end
                table.insert(App.Initial.Animations, {Path = path, Id = item.AnimationId})
            end
        end
    end
    local visualOK, visual = pcall(Visual.capture, char, App.Initial.Animations)
    if visualOK then App.Initial.Data.Visual = visual
    else warn("[Lyra Initial] Visual backup unavailable: " .. tostring(visual)) end
    App.Current = App.Initial
    desc:Destroy()
    return true
end
function App.restoreAnimations(char, snapshot)
    local animate = char:FindFirstChild("Animate")
    if animate and snapshot.Animations then
        local changed = false
        for _, row in ipairs(snapshot.Animations) do
            local node = animate
            for _, name in ipairs(row.Path) do node = node and node:FindFirstChild(name) end
            if node and node:IsA("Animation") then
                if F.setAnimationId(node, row.Id) then changed = true end
            elseif node then
                for _, child in ipairs(node:GetDescendants()) do
                    if child:IsA("Animation") and F.setAnimationId(child, row.Id) then changed = true end
                end
            end
        end
        -- Unchanged ids are already playing; restarting Animate then would only interrupt them.
        if changed then F.restartAnimate(char, true) end
    end
end
function App.captureAnimations(char)
    local rows = {}; local animate = char and char:FindFirstChild("Animate")
    if animate then for _, item in ipairs(animate:GetDescendants()) do
        if item:IsA("Animation") then
            local path, cursor = {}, item
            while cursor and cursor ~= animate do table.insert(path, 1, cursor.Name); cursor = cursor.Parent end
            table.insert(rows, {Path = path, Id = item.AnimationId})
        end
    end end
    return rows
end

-- Re-adds items the game removes. Driven by ChildRemoved, never by polling the body.
local Repair = {Generation = 0, Rows = {}, Connections = {}, Budget = 0}
function Repair.stop()
    Repair.Generation = Repair.Generation + 1
    for _, connection in ipairs(Repair.Connections) do connection:Disconnect() end
    table.clear(Repair.Connections)
    for _, row in ipairs(Repair.Rows) do if row.Template then row.Template:Destroy() end end
    table.clear(Repair.Rows); Repair.Budget = 0; Repair.Character = nil
end
function Repair.present(row)
    if row.Instance and row.Instance.Parent == Repair.Character then return row.Instance end
    if not Repair.Character then return nil end
    for _, child in ipairs(Repair.Character:GetChildren()) do
        if child:GetAttribute("Lyra_ItemKey") == row.Key then row.Instance = child; return child end
    end
end
function Repair.queue(row)
    if row.Pending or row.Suppressed or not Config.MapPersist or App.Busy or not S.fvOn or not App.alive() then return end
    if Repair.present(row) then return end
    local generation = Repair.Generation
    row.Pending = true
    task.delay(0.8, function()
        row.Pending = false
        if generation ~= Repair.Generation or not App.alive() or App.Busy or not Config.MapPersist or not S.fvOn then return end
        local char = Repair.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not char or char ~= lp.Character or not char.Parent or not hum or hum.Health <= 0 or Repair.present(row) then return end
        if row.Attempts >= 2 or Repair.Budget >= 12 then
            row.Suppressed = true
            if not Repair.Warned then Repair.Warned = true; App.report("The game keeps removing some items. Recovery was paused to prevent repeated reconstruction.", "warning") end
            return
        end
        row.Attempts = row.Attempts + 1; Repair.Budget = Repair.Budget + 1
        local ok, item = pcall(Appearance.item, row.Template, char, row.Key)
        if ok and item then row.Instance = item else row.Suppressed = true end
    end)
end
function Repair.watch(report, character)
    Repair.stop()
    Repair.Character = character; Repair.Rows = report and report.Items or {}; Repair.Warned = false
    if not character then return end
    table.insert(Repair.Connections, character.ChildRemoved:Connect(function(child)
        for _, row in ipairs(Repair.Rows) do if row.Instance == child then Repair.queue(row); break end end
    end))
end
function Repair.resume()
    if not Config.MapPersist then return end
    -- Changing the toggle does not reset a repeatedly rejected item's budget.
    for _, row in ipairs(Repair.Rows) do if not Repair.present(row) then Repair.queue(row) end end
end

-- The swap glow lives in the camera, outside the character, so applying an avatar never touches it.
F.Swap = {Tweens = game:GetService("TweenService"), Color = Color3.fromRGB(188, 167, 246)}
function F.Swap.begin(char)
    if not Store.Settings.SwapEffect or Store.Settings.ReducedMotion or not char then return nil end
    local fx = {}
    pcall(function()
        local glow = Instance.new("Highlight")
        glow.Name = "LyraSwapGlow"; glow.Adornee = char; glow.DepthMode = Enum.HighlightDepthMode.Occluded
        glow.FillColor = F.Swap.Color; glow.OutlineColor = Color3.fromRGB(244, 239, 255)
        glow.FillTransparency = 1; glow.OutlineTransparency = 1
        glow.Parent = workspace.CurrentCamera or workspace
        fx.Glow = glow
        F.Swap.Tweens:Create(glow, TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {FillTransparency = 0.3, OutlineTransparency = 0.1}):Play()
    end)
    return fx
end
function F.Swap.burst(fx, char)
    if not fx or Store.Settings.LowEffects then return end
    pcall(function()
        local root = char:FindFirstChild("HumanoidRootPart"); if not root then return end
        local anchor = Instance.new("Part")
        anchor.Name = "LyraSwapBurst"; anchor.Anchored = true; anchor.CanCollide = false; anchor.CanQuery = false; anchor.CanTouch = false
        anchor.Transparency = 1; anchor.Size = Vector3.new(2, 4, 1); anchor.CFrame = root.CFrame
        local emitter = Instance.new("ParticleEmitter")
        emitter.Texture = "rbxasset://textures/particles/sparkles_main.dds"
        emitter.Color = ColorSequence.new(F.Swap.Color, Color3.fromRGB(255, 255, 255))
        emitter.LightEmission = 1; emitter.Rate = 0; emitter.Lifetime = NumberRange.new(0.5, 0.9)
        emitter.Speed = NumberRange.new(4, 9); emitter.SpreadAngle = Vector2.new(180, 180)
        emitter.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.45), NumberSequenceKeypoint.new(1, 0)})
        emitter.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1)})
        emitter.Parent = anchor
        anchor.Parent = workspace.CurrentCamera or workspace
        emitter:Emit(36)
        task.delay(1.5, function() pcall(function() anchor:Destroy() end) end)
    end)
end
function F.Swap.finish(fx)
    if not fx or not fx.Glow then return end
    local glow = fx.Glow; fx.Glow = nil
    pcall(function() F.Swap.Tweens:Create(glow, TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {FillTransparency = 1, OutlineTransparency = 1}):Play() end)
    task.delay(0.5, function() pcall(function() glow:Destroy() end) end)
end

-- Defined after Looks; declared here so applySnapshot can reach it.
local Auto = {Deaths = 0, DeathsSince = 0, LastSwitch = -math.huge, TimerStart = os.clock(), Pending = nil, Switching = false,
    Bag = {}, Direction = 1, SkipDeath = false, SkipRespawn = false, Rng = Random.new(), OnChange = function() end, OnTick = function() end}

-- The one path that changes the character: apply, undo, restore, respawn and cycle. Previews never use it.
function App.applySnapshot(snapshot, mode, readyChar)
    if App.Busy or not App.alive() then return false end
    local char = readyChar or lp.Character
    if not char or not App.captureInitial(char) then App.report("Wait for your character to load.", "warning"); return false end
    App.Busy = true; S.applyBusy = true; App.Refresh()
    App.report(mode == "undo" and "Returning to the previous appearance…" or mode == "restore" and "Restoring the initial appearance…" or "Preparing the avatar…", "loading")
    local desc, dummy, oldAnchored, anchorPart, oldRequiresNeck, applicationReport, rigNote, swapFx
    local previous = App.Current
    if previous and mode ~= "reapply" then previous.Animations = App.captureAnimations(char) end
    -- A catalog edit keeps the animations being played unless it changed an animation item.
    if mode == "catalog" and previous and not snapshot.ForceAnims and not snapshot.Animations then snapshot.Animations = previous.Animations end
    -- Reuses an untouched copy of the last model built for this snapshot and rig, so a respawn skips the rebuild.
    local function build(rig)
        local cache = App.ModelCache
        if cache and cache.Snapshot == snapshot and cache.Rig == rig then
            local cloned, copy = pcall(function() return cache.Model:Clone() end)
            if cloned and copy then return copy, cache.Note end
        end
        local model, note = Visual.model(snapshot.Data, desc, rig)
        local copied, copy = pcall(function() return model:Clone() end)
        if copied and copy then
            if cache then pcall(function() cache.Model:Destroy() end) end
            App.ModelCache = {Snapshot = snapshot, Rig = rig, Model = copy, Note = note}
        end
        return model, note
    end
    local ok, err = xpcall(function()
        local visualOnly = Overlay.visualOnly()
        desc = Codec.decode(snapshot.Data)
        local rig = visualOnly and Overlay.rigType(char) or F.getTrueRigType(char)
        assert(rig, "The character rig could not be identified.")
        dummy, rigNote = build(rig)
        assert(App.alive(), "Execution ended.")
        if Store.Settings.AutoReset and mode == "apply" and not visualOnly then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                App.report("Waiting for your character to respawn…", "loading")
                -- This respawn is ours: the avatar cycle must not count it as a death.
                Auto.SkipDeath = true; Auto.SkipRespawn = true
                task.delay(15, function() Auto.SkipDeath = false; Auto.SkipRespawn = false end)
                local old = char; hum.Health = 0; local deadline = os.clock() + 12
                repeat task.wait(0.1); char = lp.Character until not App.alive() or (char and char ~= old and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChildOfClass("Humanoid")) or os.clock() >= deadline
                assert(App.alive(), "Execution ended.")
                if char and char ~= old and char:FindFirstChild("HumanoidRootPart") then
                    local appearanceDeadline = os.clock() + 5
                    while not lp:HasAppearanceLoaded() and os.clock() < appearanceDeadline and App.alive() do task.wait(0.1) end
                    if F.getTrueRigType(char) ~= rig then
                        dummy:Destroy(); rig = F.getTrueRigType(char); dummy, rigNote = build(rig)
                    end
                else
                    -- Round-based games can block or delay respawns; keep going if the current character is alive.
                    char = lp.Character
                    local liveHum = char and char:FindFirstChildOfClass("Humanoid")
                    assert(liveHum and liveHum.Health > 0 and char:FindFirstChild("HumanoidRootPart"),
                        "This game did not respawn your character. Turn off \"Reset character first\" in Settings, wait until you can move, and try again.")
                    App.report("This game blocked the respawn, so the avatar is being applied to your current character…", "loading")
                end
            end
        end
        assert(char == lp.Character and char.Parent and App.alive(), "Your character changed during the operation. Try again.")
        local hum = char:FindFirstChildOfClass("Humanoid")
        assert(hum and hum.Health > 0, "Wait for your character to respawn.")
        S.operationSerial = (S.operationSerial or 0) + 1
        if S.freeCamActive then F.disableFreeCam() end
        if not visualOnly then
            anchorPart = char:FindFirstChild("HumanoidRootPart"); oldAnchored = anchorPart and anchorPart.Anchored
            oldRequiresNeck = hum.RequiresNeck
            F.ensureOriginalTagsScanned(char)
            F.getSafeAccessoryNames()
        end
        if mode ~= "reapply" then swapFx = F.Swap.begin(char); if swapFx then task.wait(0.14) end end
        assert(App.alive() and char == lp.Character and char.Parent and hum.Health > 0, "Your character changed. Wait and try again.")
        App.report("Applying appearance, clothing, and accessories…", "loading")
        if visualOnly then
            Repair.stop()
            if snapshot.Original then Overlay.clear(char) else Overlay.showLocal(char, dummy) end
        else
            Overlay.clear(char)
            Appearance.checkLiveRig(char)
            App.Dirty = true
            Repair.stop()
            applicationReport = F.aAv(char, dummy)
        end
        F.Swap.burst(swapFx, char)
        assert(App.alive() and char == lp.Character and char.Parent, "Your character changed while the avatar was being applied.")
        if not visualOnly then
            for _, item in ipairs(hum:GetChildren()) do if item:IsA("HumanoidDescription") then item:Destroy() end end
            local attached = desc:Clone(); attached.Name = "HumanoidDescription"; attached.Parent = hum
            -- Emotes live on the HumanoidDescription, not on the Humanoid or Animator.
            pcall(function() attached:SetEmotes(desc:GetEmotes()); attached:SetEquippedEmotes(desc:GetEquippedEmotes()) end)
            if snapshot.Animations then App.restoreAnimations(char, snapshot)
            elseif snapshot.Data.Visual and not rigNote then App.restoreAnimations(char, {Animations = snapshot.Data.Visual.Animations})
            elseif Store.Settings.CopyAnims or snapshot.ForceAnims then
                if F.applyAnimationIdsToAnimate(char, desc) then F.restartAnimate(char, true) end
            end
            local currentHead=char:FindFirstChild("Head")
            if currentHead then F.ensureTagsVisible(currentHead) end
        end
        assert(App.alive() and char == lp.Character and char.Parent, "Your character changed before the operation finished.")
        App.Dirty = false
        if mode == "undo" then table.remove(App.History)
        elseif mode ~= "reapply" and previous then
            -- Jumping back moves that entry out of the history instead of duplicating it.
            if mode == "history" then for i = #App.History, 1, -1 do if App.History[i] == snapshot then table.remove(App.History, i); break end end end
            table.insert(App.History, previous); while #App.History > 12 do table.remove(App.History, 1) end
        end
        App.Current = snapshot
        if S.cD and S.cD ~= dummy then pcall(function() S.cD:Destroy() end) end
        S.cD = dummy; dummy = nil
        S.cU = snapshot.Id or "SAVED"; S.tN = snapshot.Name or "SavedAvatar"
        if S.customDesc then S.customDesc:Destroy() end
        S.customDesc = desc:Clone()
        S.fvOn = not snapshot.Original; S.hdOn = false
        S.appliedChar = char; S.currentRigType = F.getTrueRigType(char)
        _G.Copier_TargetID = nil
        if not visualOnly then
            Repair.watch(applicationReport, char)
            if snapshot.Original then Appearance.releaseGeometry(hum) end
        end
        if oldRequiresNeck ~= nil then hum.RequiresNeck = oldRequiresNeck end
    end, function(e) return tostring(e) end)
    if anchorPart and oldAnchored ~= nil then pcall(function() anchorPart.Anchored = oldAnchored end) end
    if char and oldRequiresNeck ~= nil then pcall(function() char:FindFirstChildOfClass("Humanoid").RequiresNeck = oldRequiresNeck end) end
    pcall(F.unlockCamera); pcall(F.resumeCamScripts)
    F.Swap.finish(swapFx)
    table.clear(S_SafeTools)
    if desc then desc:Destroy() end; if dummy then dummy:Destroy() end
    App.Busy = false; S.applyBusy = false
    if ok then Repair.resume() end
    if ok and not snapshot.Original and Auto.remember(snapshot) then App.persist() end
    if ok and mode == "apply" and snapshot.Id and not snapshot.LookKey then
        App.addRecent({Id = snapshot.Id, Name = tostring(snapshot.Name or snapshot.Id), DisplayName = snapshot.DisplayName or snapshot.Name})
    end
    if not ok then
        if applicationReport then for _, row in ipairs(applicationReport.Items or {}) do if row.Template then row.Template:Destroy() end end end
        S.lastError = err; S.operationSerial = (S.operationSerial or 0) + 1; S.fvOn = false; App.report(err .. (App.Dirty and " Use Restore original to recover your appearance." or ""), "error") else
        App.report(mode == "undo" and "Previous appearance restored." or mode == "restore" and "Initial appearance restored." or mode == "reapply" and "Avatar reapplied." or mode == "catalog" and "Catalog change applied." or mode == "cycle" and ("Avatar cycle: now wearing " .. tostring(snapshot.Name or "the next avatar") .. ".") or mode == "history" and ("Back to " .. (snapshot.Original and "your initial appearance" or tostring(snapshot.Name or "that avatar")) .. ".") or ((char and F.getTrueRigType(char) ~= Enum.HumanoidRigType.R15) and "Avatar applied. This game does not use an R15 rig, so its own animations were kept." or "Avatar applied. Tap Customize to remove its items or add new ones."), "success")
    end
    if ok and rigNote then
        App.report(rigNote, "warning")
    elseif ok and applicationReport and (#applicationReport.Skipped > 0 or #applicationReport.BodyErrors > 0) then
        App.report("Avatar applied with limitations: " .. tostring(#applicationReport.Skipped + #applicationReport.BodyErrors) .. " unavailable items/body parts in this game.", "warning")
    elseif ok and snapshot.Data.Visual and snapshot.Data.Visual.Legacy then
        App.report("Old JSON applied. Attachments were estimated because the backup contains no joints.", "warning")
    end
    if App.alive() then App.Refresh() end
    return ok
end
function App.applyPreview()
    if not App.Preview or App.Busy then return end
    local profile = App.Preview
    local snapshot = {Data = profile.SnapshotData or Codec.encode(profile.Description), Id = profile.Id, Name = profile.Name, LookKey = profile.LookKey}
    task.spawn(App.applySnapshot, snapshot, "apply")
end
function App.undo()
    if #App.History > 0 and not App.Busy then task.spawn(App.applySnapshot, App.History[#App.History], "undo") end
end
function App.jump(snapshot)
    if not snapshot or snapshot == App.Current or App.Busy then return end
    task.spawn(App.applySnapshot, snapshot, "history")
end
function App.wearProfile(profile)
    if not profile or App.Busy then return end
    App.report("Loading " .. tostring(profile.DisplayName or profile.Name) .. "…", "loading")
    task.spawn(function()
        local ok, resolved, err = pcall(App.resolve, tostring(profile.Id or profile.Name), App.alive)
        if not ok then err = tostring(resolved); resolved = nil end
        if not resolved then if err ~= "cancelled" then App.report(err or "This profile is unavailable.", "error") end; return end
        App.applySnapshot({Data = Codec.encode(resolved.Description), Id = resolved.Id, Name = resolved.Name}, "apply")
    end)
end
function App.restore()
    if App.Initial and not App.Busy then task.spawn(App.applySnapshot, App.Initial, "restore") end
end

-- A catalog edit is a normal snapshot, so the timeline and Undo cover it.
local Catalog = {Info = {}, Bundles = {}}
Catalog.AvatarEditor = game:GetService("AvatarEditorService")
Catalog.Assets = game:GetService("AssetService")
-- Asset type id -> description field or accessory type. Rank orders a bundle's parts.
Catalog.Types = {
    [2] = {Name = "TShirt", Field = "GraphicTShirt", Label = "T-shirt", Rank = 30},
    [8] = {Name = "Hat", Accessory = "Hat", Label = "Hat", Rank = 20},
    [11] = {Name = "Shirt", Field = "Shirt", Label = "Shirt", Rank = 30},
    [12] = {Name = "Pants", Field = "Pants", Label = "Pants", Rank = 30},
    [17] = {Name = "Head", Field = "Head", Label = "Head", Rank = 1},
    [18] = {Name = "Face", Field = "Face", Label = "Face", Rank = 2},
    [27] = {Name = "Torso", Field = "Torso", Label = "Torso", Rank = 3},
    [28] = {Name = "RightArm", Field = "RightArm", Label = "Right arm", Rank = 5},
    [29] = {Name = "LeftArm", Field = "LeftArm", Label = "Left arm", Rank = 4},
    [30] = {Name = "LeftLeg", Field = "LeftLeg", Label = "Left leg", Rank = 6},
    [31] = {Name = "RightLeg", Field = "RightLeg", Label = "Right leg", Rank = 7},
    [41] = {Name = "HairAccessory", Accessory = "Hair", Label = "Hair", Rank = 20},
    [42] = {Name = "FaceAccessory", Accessory = "Face", Label = "Face accessory", Rank = 20},
    [43] = {Name = "NeckAccessory", Accessory = "Neck", Label = "Neck", Rank = 20},
    [44] = {Name = "ShoulderAccessory", Accessory = "Shoulder", Label = "Shoulder", Rank = 20},
    [45] = {Name = "FrontAccessory", Accessory = "Front", Label = "Front", Rank = 20},
    [46] = {Name = "BackAccessory", Accessory = "Back", Label = "Back", Rank = 20},
    [47] = {Name = "WaistAccessory", Accessory = "Waist", Label = "Waist", Rank = 20},
    [48] = {Name = "ClimbAnimation", Field = "ClimbAnimation", Label = "Climb animation", Rank = 40},
    [50] = {Name = "FallAnimation", Field = "FallAnimation", Label = "Fall animation", Rank = 40},
    [51] = {Name = "IdleAnimation", Field = "IdleAnimation", Label = "Idle animation", Rank = 40},
    [52] = {Name = "JumpAnimation", Field = "JumpAnimation", Label = "Jump animation", Rank = 40},
    [53] = {Name = "RunAnimation", Field = "RunAnimation", Label = "Run animation", Rank = 40},
    [54] = {Name = "SwimAnimation", Field = "SwimAnimation", Label = "Swim animation", Rank = 40},
    [55] = {Name = "WalkAnimation", Field = "WalkAnimation", Label = "Walk animation", Rank = 40},
    [64] = {Name = "TShirtAccessory", Accessory = "TShirt", Layered = true, Label = "T-shirt", Rank = 30},
    [65] = {Name = "ShirtAccessory", Accessory = "Shirt", Layered = true, Label = "Shirt", Rank = 30},
    [66] = {Name = "PantsAccessory", Accessory = "Pants", Layered = true, Label = "Pants", Rank = 30},
    [67] = {Name = "JacketAccessory", Accessory = "Jacket", Layered = true, Label = "Jacket", Rank = 30},
    [68] = {Name = "SweaterAccessory", Accessory = "Sweater", Layered = true, Label = "Sweater", Rank = 30},
    [69] = {Name = "ShortsAccessory", Accessory = "Shorts", Layered = true, Label = "Shorts", Rank = 30},
    [70] = {Name = "LeftShoeAccessory", Accessory = "LeftShoe", Layered = true, Label = "Left shoe", Rank = 30},
    [71] = {Name = "RightShoeAccessory", Accessory = "RightShoe", Layered = true, Label = "Right shoe", Rank = 30},
    [72] = {Name = "DressSkirtAccessory", Accessory = "DressSkirt", Layered = true, Label = "Dress / skirt", Rank = 30},
    [76] = {Name = "EyebrowAccessory", Accessory = "Eyebrow", Layered = true, Label = "Eyebrows", Rank = 2},
    [77] = {Name = "EyelashAccessory", Accessory = "Eyelash", Layered = true, Label = "Eyelashes", Rank = 2},
    [78] = {Name = "MoodAnimation", Field = "MoodAnimation", Label = "Mood", Rank = 40},
    [79] = {Name = "DynamicHead", Field = "Head", Label = "Head", Rank = 1},
    [61] = {Name = "EmoteAnimation", Emote = true, Label = "Emote", Rank = 45},
}
Catalog.ByName = {}
for _, row in pairs(Catalog.Types) do Catalog.ByName[row.Name:lower()] = row end
Catalog.ByName.hair = Catalog.Types[41]
Catalog.BundleKinds = {[1] = "BodyParts", [2] = "Animations", [3] = "Shoes", [4] = "DynamicHead", [5] = "DynamicHeadAvatar"}
Catalog.BundleLabels = {BodyParts = "Body", Animations = "Animation pack", Shoes = "Shoes", DynamicHead = "Head", DynamicHeadAvatar = "Avatar"}
-- Asset and bundle types are never mixed in one request.
Catalog.Filters = {"All", "Limiteds", "Bodies", "Heads", "Hair", "Hats", "Accessories", "Clothing", "Faces", "Animations", "Emotes"}
Catalog.Categories = {
    All = {},
    Limiteds = {Limited = true},
    Bodies = {Bundles = {"BodyParts"}},
    Heads = {Assets = {"DynamicHead", "Head"}},
    Hair = {Assets = {"HairAccessory"}},
    Hats = {Assets = {"Hat"}},
    Accessories = {Assets = {"FaceAccessory", "NeckAccessory", "ShoulderAccessory", "FrontAccessory", "BackAccessory", "WaistAccessory"}},
    Clothing = {Assets = {"Shirt", "Pants", "TShirt", "TShirtAccessory", "ShirtAccessory", "PantsAccessory", "JacketAccessory", "SweaterAccessory",
        "ShortsAccessory", "DressSkirtAccessory", "LeftShoeAccessory", "RightShoeAccessory"}},
    Faces = {Assets = {"Face", "EyebrowAccessory", "EyelashAccessory"}},
    Animations = {Bundles = {"Animations"}},
    Emotes = {Assets = {"EmoteAnimation"}},
}
Catalog.Subs = {
    Clothing = {"All", "Shirts", "Pants", "T-Shirts", "Layered"},
    Accessories = {"All", "Face", "Neck", "Shoulder", "Front", "Back", "Waist"},
}
Catalog.SubLabels = {Shirts = "Classic shirts", Pants = "Classic pants", ["T-Shirts"] = "Classic T-shirts", Layered = "Layered clothing"}
Catalog.SubCategories = {
    ["Clothing/Shirts"] = {Assets = {"Shirt"}}, ["Clothing/Pants"] = {Assets = {"Pants"}}, ["Clothing/T-Shirts"] = {Assets = {"TShirt"}},
    ["Clothing/Layered"] = {Assets = {"TShirtAccessory", "ShirtAccessory", "PantsAccessory", "JacketAccessory", "SweaterAccessory",
        "ShortsAccessory", "DressSkirtAccessory", "LeftShoeAccessory", "RightShoeAccessory"}},
    ["Accessories/Face"] = {Assets = {"FaceAccessory"}}, ["Accessories/Neck"] = {Assets = {"NeckAccessory"}},
    ["Accessories/Shoulder"] = {Assets = {"ShoulderAccessory"}}, ["Accessories/Front"] = {Assets = {"FrontAccessory"}},
    ["Accessories/Back"] = {Assets = {"BackAccessory"}}, ["Accessories/Waist"] = {Assets = {"WaistAccessory"}},
}
function Catalog.filterFor(query)
    local sub = query.Sub and query.Sub ~= "All" and Catalog.SubCategories[tostring(query.Category) .. "/" .. query.Sub]
    return sub or Catalog.Categories[query.Category] or Catalog.Categories.All
end
-- Most popular (all time) is the default so searches like "korblox" lead with the original item.
Catalog.Sorts = {
    {Value = "Popular", Label = "Most popular", Enum = {"MostFavorited"}, Web = 1, AllTime = true},
    {Value = "BestSelling", Label = "Best selling", Enum = {"Bestselling", "BestSelling"}, Web = 2, AllTime = true},
    {Value = "Relevance", Label = "Best match", Enum = {"Relevance"}, Web = 0},
    {Value = "Newest", Label = "Newest", Enum = {"RecentlyCreated", "RecentlyUpdated"}, Web = 3},
    {Value = "PriceLow", Label = "Price: low to high", Enum = {"PriceLowToHigh"}, Web = 4},
    {Value = "PriceHigh", Label = "Price: high to low", Enum = {"PriceHighToLow"}, Web = 5},
}
Catalog.Prices = {
    {Value = "Any", Label = "Any price"},
    {Value = "ForSale", Label = "For sale only", ForSale = true},
    {Value = "Free", Label = "Free", Min = 0, Max = 0, ForSale = true},
    {Value = "Low", Label = "Up to R$ 100", Min = 1, Max = 100, ForSale = true},
    {Value = "Mid", Label = "R$ 100 to 1,000", Min = 100, Max = 1000, ForSale = true},
    {Value = "High", Label = "R$ 1,000 and up", Min = 1000, ForSale = true},
}
function Catalog.option(list, value)
    for _, row in ipairs(list) do if row.Value == value then return row end end
    return list[1]
end
function Catalog.kind(value)
    if typeof(value) == "EnumItem" then value = value.Name end
    if type(value) == "string" and tonumber(value) then value = tonumber(value) end
    if type(value) == "number" then return Catalog.Types[value] end
    if type(value) == "string" then return Catalog.ByName[(value:lower():gsub("[%s_]", ""))] end
end
function Catalog.bundleKind(value)
    if typeof(value) == "EnumItem" then return value.Name end
    if type(value) == "string" and tonumber(value) then value = tonumber(value) end
    if type(value) == "number" then return Catalog.BundleKinds[value] end
    if type(value) == "string" then return value end
end
-- Yields. Cached per session.
function Catalog.info(id)
    local cached = Catalog.Info[id]
    if cached ~= nil then return cached or nil end
    local ok, info = pcall(function() return MPS:GetProductInfo(id, Enum.InfoType.Asset) end)
    Catalog.Info[id] = ok and type(info) == "table" and info or false
    return Catalog.Info[id] or nil
end
function Catalog.normalize(raw)
    if type(raw) ~= "table" then return nil end
    local id = Codec.id(raw.Id or raw.id)
    if not id then return nil end
    local item = {Id = id, Name = tostring(raw.Name or raw.name or ("Item " .. id)), Creator = raw.CreatorName or raw.creatorName,
        Price = tonumber(raw.Price or raw.price or raw.LowestPrice or raw.lowestPrice)}
    local status = tostring(raw.PriceStatus or raw.priceStatus or ""):lower()
    item.OffSale = raw.IsOffSale == true or raw.isOffSale == true or status:find("off") ~= nil
    local restrictions = raw.ItemRestrictions or raw.itemRestrictions
    if type(restrictions) == "table" then
        item.Limited = false
        for _, value in ipairs(restrictions) do
            local name = tostring(value):lower()
            if name:find("limited") or name:find("collectible") then item.Limited = true; break end
        end
    end
    if tostring(raw.ItemType or raw.itemType or "Asset"):lower():find("bundle") then
        item.Bundle = true; item.BundleKind = Catalog.bundleKind(raw.BundleType or raw.bundleType)
    else
        -- Known types with no place on an avatar (gear, emotes…) are listed but can't be added.
        local assetType = raw.AssetType or raw.assetType
        item.Kind = Catalog.kind(assetType)
        item.Unwearable = assetType ~= nil and item.Kind == nil
    end
    return item
end
function Catalog.accepts(item, filter)
    if not filter.Assets and not filter.Bundles then return true end
    if item.Bundle then return filter.Bundles ~= nil and table.find(filter.Bundles, item.BundleKind) ~= nil end
    return filter.Assets ~= nil and item.Kind ~= nil and table.find(filter.Assets, item.Kind.Name) ~= nil
end
-- The search already filters by price; this guards the web fallback and items without a price.
function Catalog.priced(item, price)
    if item.Bundle and not price.Min and not price.Max then return not (price.ForSale and item.OffSale) end
    if price.ForSale and item.OffSale then return false end
    if price.Min or price.Max then
        if not item.Price then return false end
        if price.Min and item.Price < price.Min then return false end
        if price.Max and item.Price > price.Max then return false end
    end
    return true
end
function Catalog.read(list, query)
    local items = {}
    local price, filter = Catalog.option(Catalog.Prices, query.Price), Catalog.filterFor(query)
    for _, raw in ipairs(type(list) == "table" and list or {}) do
        local item = Catalog.normalize(raw)
        if item and Catalog.accepts(item, filter) and Catalog.priced(item, price) and not (filter.Limited and item.Limited == false) then table.insert(items, item) end
    end
    return items
end
function Catalog.params(query)
    local params = CatalogSearchParams.new()
    params.SearchKeyword = query.Keyword
    local filter = Catalog.filterFor(query)
    local function enums(enum, names)
        local list = {}
        for _, name in ipairs(names) do local ok, item = pcall(function() return enum[name] end); if ok and item then table.insert(list, item) end end
        return list
    end
    if filter.Assets then params.AssetTypes = enums(Enum.AvatarAssetType, filter.Assets) end
    if filter.Bundles then params.BundleTypes = enums(Enum.BundleType, filter.Bundles) end
    if filter.Limited then pcall(function() params.SalesTypeFilter = Enum.SalesTypeFilter.Collectibles end) end
    local sort, price = Catalog.option(Catalog.Sorts, query.Sort), Catalog.option(Catalog.Prices, query.Price)
    for _, name in ipairs(sort.Enum) do
        local ok, item = pcall(function() return Enum.CatalogSortType[name] end)
        if ok and item then pcall(function() params.SortType = item end); break end
    end
    if sort.AllTime then pcall(function() params.SortAggregation = Enum.CatalogSortAggregation.AllTime end) end
    -- Off-sale items still load on a local avatar, so they are included unless a price filter is set.
    pcall(function() params.IncludeOffSale = not price.ForSale end)
    if price.Min then pcall(function() params.MinPrice = price.Min end) end
    if price.Max then pcall(function() params.MaxPrice = price.Max end) end
    return params
end
-- Executor HTTP fallback for games where the in-game catalog search is unavailable.
function Catalog.web(query)
    local sort, price = Catalog.option(Catalog.Sorts, query.Sort), Catalog.option(Catalog.Prices, query.Price)
    local url = "https://catalog.roblox.com/v1/search/items/details?Limit=30&SortType=" .. sort.Web .. (sort.AllTime and "&SortAggregation=5" or "")
        .. "&IncludeNotForSale=" .. (price.ForSale and "false" or "true") .. "&Keyword=" .. HttpService:UrlEncode(query.Keyword)
    if price.Min then url = url .. "&MinPrice=" .. price.Min end
    if price.Max then url = url .. "&MaxPrice=" .. price.Max end
    if Catalog.filterFor(query).Limited then url = url .. "&SalesTypeFilter=2" end
    if query.Cursor then url = url .. "&Cursor=" .. HttpService:UrlEncode(query.Cursor) end
    local ok, body = pcall(function() return game:HttpGet(url) end)
    assert(ok and type(body) == "string", "The catalog is unavailable right now. Try again in a moment.")
    local decoded, data = pcall(function() return HttpService:JSONDecode(body) end)
    assert(decoded and type(data) == "table" and type(data.data) == "table", "The catalog returned an unexpected answer.")
    query.Cursor = type(data.nextPageCursor) == "string" and data.nextPageCursor ~= "" and data.nextPageCursor or nil
    query.Finished = query.Cursor == nil
    return Catalog.read(data.data, query)
end
-- Item id or catalog/bundle link -> id, "Asset" | "Bundle" | nil.
function Catalog.idFrom(keyword)
    local text, kind = tostring(keyword):lower(), nil
    local id = text:match("/catalog/(%d+)")
    if id then kind = "Asset" else
        id = text:match("/bundles/(%d+)")
        if id then kind = "Bundle" else id = text:match("^#?(%d+)$") end
    end
    id = Codec.id(id)
    if not id then return nil end
    return id, kind
end
-- Yields. Item and bundle ids overlap, so a bare number is tried as an item first.
function Catalog.byId(id, kind)
    local asset
    if kind ~= "Bundle" then
        local info = Catalog.info(id)
        if info and info.AssetTypeId then
            asset = Catalog.normalize({Id = id, Name = info.Name, AssetType = info.AssetTypeId, Price = info.IsForSale and info.PriceInRobux or nil,
                IsOffSale = info.IsForSale == false, CreatorName = type(info.Creator) == "table" and info.Creator.Name or nil,
                ItemRestrictions = (info.IsLimited or info.IsLimitedUnique or info.CollectibleItemId) and {"Limited"} or {}})
            if asset and not asset.Unwearable then return asset end
        end
    end
    if kind ~= "Asset" then
        local ok, details = pcall(function() return Catalog.Assets:GetBundleDetailsAsync(id) end)
        if ok and type(details) == "table" and details.Name then
            return Catalog.normalize({Id = id, Name = details.Name, ItemType = "Bundle", BundleType = details.BundleType})
        end
    end
    return asset
end
-- Yields. The query keeps the paging state, so "more" continues the same search.
function Catalog.search(query, more)
    if not more then
        local id, kind = Catalog.idFrom(query.Keyword)
        if id then
            query.Finished = true
            local item = Catalog.byId(id, kind)
            assert(item, "No catalog item or bundle was found with the ID " .. tostring(id) .. ".")
            return {item}
        end
    end
    if more then
        assert(not query.Finished, "There are no more results.")
        if query.Pages then
            query.Pages:AdvanceToNextPageAsync(); query.Finished = query.Pages.IsFinished
            return Catalog.read(query.Pages:GetCurrentPage(), query)
        end
        return Catalog.web(query)
    end
    local ok, pages = pcall(function() return Catalog.AvatarEditor:SearchCatalog(Catalog.params(query)) end)
    if ok and pages then
        query.Pages = pages; query.Finished = pages.IsFinished
        return Catalog.read(pages:GetCurrentPage(), query)
    end
    warn("[Lyra Catalog] In-game search unavailable, using the web catalog: " .. tostring(pages))
    return Catalog.web(query)
end
-- Yields. Body parts first.
function Catalog.bundle(id)
    if Catalog.Bundles[id] then return Catalog.Bundles[id] end
    local ok, details = pcall(function() return Catalog.Assets:GetBundleDetailsAsync(id) end)
    assert(ok and type(details) == "table" and type(details.Items) == "table", "This bundle could not be loaded. Try again.")
    local parts, pending = {}, 0
    for _, entry in ipairs(details.Items) do
        local assetId = Codec.id(entry.Id)
        if assetId and tostring(entry.Type) == "Asset" then
            local part = {Id = assetId, Name = tostring(entry.Name or ("Item " .. assetId))}
            table.insert(parts, part); pending = pending + 1
            task.spawn(function()
                local info = Catalog.info(assetId)
                part.Kind = info and Catalog.kind(info.AssetTypeId)
                pending = pending - 1
            end)
        end
    end
    local deadline = os.clock() + 15
    while pending > 0 and os.clock() < deadline and App.alive() do task.wait(0.05) end
    for _, part in ipairs(parts) do
        if not part.Kind then
            -- Names such as "Robloxian 2.0 - Left Arm" still identify a limb when product info fails.
            local name = part.Name:lower()
            for typeId, pattern in pairs({[29] = "left arm", [28] = "right arm", [30] = "left leg", [31] = "right leg", [27] = "torso", [17] = "head"}) do
                if name:find(pattern, 1, true) then part.Kind = Catalog.Types[typeId]; break end
            end
        end
    end
    table.sort(parts, function(a, b)
        local ra, rb = a.Kind and a.Kind.Rank or 99, b.Kind and b.Kind.Rank or 99
        if ra ~= rb then return ra < rb end
        return a.Id < b.Id
    end)
    local bundle = {Id = id, Name = tostring(details.Name or ("Bundle " .. id)), Parts = parts}
    Catalog.Bundles[id] = bundle
    return bundle
end
function Catalog.base()
    if not App.Current and not App.Initial then App.captureInitial(lp.Character) end
    return App.Current or App.Initial
end
function Catalog.worn()
    local snapshot = Catalog.base()
    if Catalog.WornFor == snapshot and Catalog.WornSet then return Catalog.WornSet end
    local set = {}
    local data = snapshot and snapshot.Data
    if type(data) == "table" then
        local props = data.Version == 2 and data.Properties or data
        if type(props) == "table" then
            for _, field in ipairs(Codec.assetFields) do local id = Codec.id(props[field]); if id then set[id] = {Field = field} end end
        end
        if data.HasAccessories and type(data.Accessories) == "table" then
            for _, row in ipairs(data.Accessories) do
                local id = type(row) == "table" and Codec.id(row.AssetId)
                if id then set[id] = {Accessory = tostring(row.AccessoryType or "Accessory")} end
            end
        elseif type(props) == "table" then
            for _, field in ipairs(Codec.accessoryFields) do
                if type(props[field]) == "string" then
                    for value in props[field]:gmatch("%d+") do local id = Codec.id(tonumber(value)); if id then set[id] = {Accessory = (field:gsub("Accessory$", ""))} end end
                end
            end
        end
    end
    if type(data) == "table" and type(data.Emotes) == "table" then
        for _, ids in pairs(data.Emotes) do
            for _, value in ipairs(type(ids) == "table" and ids or {}) do local id = Codec.id(value); if id then set[id] = {Emote = true} end end
        end
    end
    Catalog.WornFor = snapshot; Catalog.WornSet = set
    return set
end
function Catalog.slotLabel(slot)
    if slot.Emote then return "Emote", 45 end
    for _, row in pairs(Catalog.Types) do
        if (slot.Field and row.Field == slot.Field) or (slot.Accessory and row.Accessory == slot.Accessory) then return row.Label, row.Rank end
    end
    return tostring(slot.Accessory or slot.Field or "Item"), 99
end
-- Yields. context = {Id, Name, Bundle} when several parts of one bundle change at once.
function Catalog.edit(items, remove, context)
    if App.Busy or not App.alive() then App.report("Wait for the current change to finish.", "warning"); return false end
    local base = Catalog.base()
    if not base then App.report("Wait for your character to load.", "warning"); return false end
    App.report(remove and "Removing from your avatar…" or "Adding to your avatar…", "loading")
    if not remove then
        for _, item in ipairs(items) do
            if not item.Kind then local info = Catalog.info(item.Id); item.Kind = info and Catalog.kind(info.AssetTypeId) end
        end
    end
    if App.Busy or not App.alive() then return false end
    local decoded, desc = pcall(Codec.decode, base.Data)
    if not decoded then App.report("The current appearance could not be read: " .. tostring(desc), "error"); return false end
    local changed, animations = 0, false
    local playName
    local ok, err = pcall(function()
        -- A snapshot of your own avatar has no emotes, so start from the live ones or adding one wipes the wheel.
        local emotes, equipped, emoteChanged
        local function loadEmotes()
            if emotes then return end
            emotes, equipped = desc:GetEmotes(), desc:GetEquippedEmotes()
            if next(emotes) == nil then
                local humanoid = lp.Character and lp.Character:FindFirstChildOfClass("Humanoid")
                local live = humanoid and humanoid:FindFirstChildOfClass("HumanoidDescription")
                if live then emotes, equipped = live:GetEmotes(), live:GetEquippedEmotes() end
            end
        end
        local accessories = desc:GetAccessories(true)
        local top = 0
        for _, row in ipairs(accessories) do if row.IsLayered and type(row.Order) == "number" and row.Order > top then top = row.Order end end
        for _, item in ipairs(items) do
            local before = #accessories
            for i = #accessories, 1, -1 do if accessories[i].AssetId == item.Id then table.remove(accessories, i) end end
            if remove then
                if #accessories < before then changed = changed + 1 end
                loadEmotes()
                for name, ids in pairs(emotes) do
                    local kept = {}
                    for _, value in ipairs(ids) do if value ~= item.Id then table.insert(kept, value) end end
                    if #kept < #ids then
                        changed = changed + 1; emoteChanged = true
                        if #kept == 0 then
                            emotes[name] = nil
                            for i = #equipped, 1, -1 do if equipped[i].Name == name then table.remove(equipped, i) end end
                        else emotes[name] = kept end
                    end
                end
                for _, field in ipairs(Codec.assetFields) do
                    if desc[field] == item.Id then desc[field] = 0; changed = changed + 1; animations = animations or field:find("Animation") ~= nil end
                end
            elseif item.Kind and item.Kind.Accessory then
                local row = {AssetId = item.Id, AccessoryType = Enum.AccessoryType[item.Kind.Accessory], IsLayered = item.Kind.Layered == true}
                if row.IsLayered then top = math.min(1000, top + 1); row.Order = top end
                table.insert(accessories, row); changed = changed + 1
            elseif item.Kind and item.Kind.Emote then
                -- First free slot of the wheel, slot 8 when all are taken.
                loadEmotes()
                local name = tostring(item.Name or "Emote"):gsub("[%c]", " "):sub(1, 40)
                local used = {}
                for i = #equipped, 1, -1 do if equipped[i].Name == name then table.remove(equipped, i) else used[equipped[i].Slot] = true end end
                local slot = 8
                for candidate = 1, 8 do if not used[candidate] then slot = candidate; break end end
                for i = #equipped, 1, -1 do if equipped[i].Slot == slot then table.remove(equipped, i) end end
                emotes[name] = {item.Id}; table.insert(equipped, {Name = name, Slot = slot})
                changed = changed + 1; emoteChanged = true; playName = name
            elseif item.Kind and item.Kind.Field then
                desc[item.Kind.Field] = item.Id; changed = changed + 1
                animations = animations or item.Kind.Field:find("Animation") ~= nil
            end
        end
        desc:SetAccessories(accessories, true)
        if emoteChanged then desc:SetEmotes(emotes); desc:SetEquippedEmotes(equipped) end
    end)
    if not ok or changed == 0 then
        desc:Destroy()
        App.report(not ok and ("Roblox rejected this change: " .. tostring(err)) or remove and "That item is not on your avatar." or "This item cannot be worn on an avatar.", not ok and "error" or "warning")
        return false
    end
    local data = Codec.encode(desc); desc:Destroy()
    local name = base.Original and "My avatar" or tostring(base.Name or "Avatar")
    name = name:gsub(" %(edited%)$", "")
    local subject = context or items[1]
    local info = not context and Catalog.Info[subject.Id]
    local itemName = tostring(subject.Name or (info and info.Name) or "an item")
    local verb = remove and "Removed " or "Added "
    local snapshot = {Data = data, Name = name .. " (edited)", Catalog = true, ThumbId = base.Id or base.ThumbId, ForceAnims = animations or nil,
        Change = {Text = verb .. (context and #items > 1 and (tostring(#items) .. " parts of " .. itemName) or itemName), Id = subject.Id, Bundle = context and context.Bundle or nil}}
    local applied = App.applySnapshot(snapshot, "catalog")
    if applied and playName then
        task.wait(0.4)
        local humanoid = lp.Character and lp.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then pcall(function() humanoid:PlayEmote(playName) end) end
    end
    return applied
end

-- A look is a standalone snapshot; it never follows a username or a catalog edit.
local Looks = {}
function Looks.name(value)
    local name = tostring(value or ""):gsub("[%c]", " "):match("^%s*(.-)%s*$"):sub(1, 48)
    return name ~= "" and name or nil
end
function Looks.find(key)
    for index, row in ipairs(Store.Looks) do if row.Key == key then return row, index end end
end
function Looks.description(model)
    assert(model and model.Parent, "Your character is not available yet. Wait for it to respawn.")
    local hum = model:FindFirstChildOfClass("Humanoid")
    assert(hum, "The source has no Humanoid.")
    local desc = hum:FindFirstChildOfClass("HumanoidDescription") or model:FindFirstChildOfClass("HumanoidDescription")
    if desc then return desc:Clone(), "preview description" end
    local ok, applied = pcall(function() return hum:GetAppliedDescription() end)
    assert(ok and applied, "Could not read the character description.")
    return applied, "description applied to the Humanoid"
end
function Looks.capture(model, name, existingKey)
    assert(App.alive() and not App.Busy and not App.Dirty, "Wait for the application to finish or restore your character before saving.")
    assert(model == lp.Character, "Capture only accepts your current character.")
    local desc = Looks.description(model)
    local ok, data = pcall(Codec.encode, desc); desc:Destroy()
    assert(ok and data, "Could not save the description.")
    data.Visual = Visual.capture(model, App.captureAnimations(model))
    assert(App.alive() and model == lp.Character, "Your character changed during the capture.")
    local row = existingKey and Looks.find(existingKey)
    if existingKey then assert(row, "The selected skin no longer exists.") end
    if not row then
        assert(#Store.Looks < 100, "Limit of 100 skins.")
        row = {Key = HttpService:GenerateGUID(false)}; table.insert(Store.Looks, 1, row)
    end
    row.Name = Looks.name(name) or row.Name or "New skin"
    row.Data = data; row.Source = "My character · " .. data.Visual.RigType; row.Updated = os.time()
    return row, "the character's real appearance", false, App.persist()
end
function Looks.import(raw, name)
    assert(type(raw) == "string" and #raw <= 2000000, "Invalid code/JSON or larger than 2 MB.")
    raw = raw:match("^%s*(.-)%s*$")
    local prefixed = raw:sub(1,6) == "LYRA2:" or raw:sub(1,6) == "LYRA3:"
    local ok, packet = pcall(function() return HttpService:JSONDecode(prefixed and raw:sub(7) or raw) end)
    assert(ok and type(packet) == "table", "Paste a LYRA code or the full contents of the old JSON.")
    local data, title
    if packet.MembrosCorpo or packet.MembrosCustom then data = Visual.legacy(packet); title = Looks.name(name) or "Old skin"
    else
        assert((packet.Version == 1 or packet.Version == 2) and type(packet.Data) == "table", "Code not recognized.")
        if packet.Data.Visual then Visual.validate(packet.Data.Visual) end
        local valid, desc = pcall(Codec.decode, packet.Data)
        assert(valid and desc, "Incompatible description.")
        data = Codec.encode(desc); desc:Destroy(); data.Visual = packet.Data.Visual
        title = Looks.name(packet.Name) or Looks.name(name) or "Imported skin"
    end
    assert(#Store.Looks < 100, "Limit of 100 skins.")
    local row = {Key = HttpService:GenerateGUID(false), Name = title, Data = data,
        Source = data.Visual and data.Visual.Legacy and "Old JSON · estimated attachments" or "Shared code", Updated = os.time()}
    table.insert(Store.Looks, 1, row)
    return row, App.persist()
end
function Looks.share(row)
    return "LYRA3:" .. HttpService:JSONEncode({Version = 2, Name = row.Name, Data = row.Data})
end

-- Entries never store a description: profiles are fetched again and skins are read from the library.
function Auto.entryFrom(source)
    if type(source) ~= "table" or source.Original then return nil end
    if source.LookKey then
        local row = Looks.find(source.LookKey)
        return Store.entry({Kind = "Look", Key = source.LookKey, Name = row and row.Name or source.Name})
    end
    if source.Id then return Store.entry({Kind = "User", Id = source.Id, Name = source.Name, DisplayName = source.DisplayName}) end
end
function Auto.same(a, b)
    if not a or not b or a.Kind ~= b.Kind then return false end
    if a.Kind == "Look" then return a.Key == b.Key end
    if a.Id and b.Id then return a.Id == b.Id end
    return a.Name:lower() == b.Name:lower()
end
function Auto.name(entry)
    if not entry then return "None" end
    if entry.Kind == "Look" then local row = Looks.find(entry.Key); return row and row.Name or entry.Name end
    return (entry.DisplayName ~= "" and entry.DisplayName ~= entry.Name) and (entry.DisplayName .. " (@" .. entry.Name .. ")") or ("@" .. entry.Name)
end
function Auto.remember(snapshot)
    local entry = Auto.entryFrom(snapshot)
    if not entry or Auto.same(entry, Store.Auto.Last) then return false end
    Store.Auto.Last = entry; return true
end
-- Yields.
function Auto.resolve(entry)
    if not entry then return nil, "No avatar is selected." end
    if entry.Kind == "Look" then
        local row = Looks.find(entry.Key)
        if not row then return nil, "The saved skin '" .. entry.Name .. "' no longer exists." end
        return {Data = row.Data, Name = row.Name, LookKey = row.Key}
    end
    local profile, err = App.resolve(tostring(entry.Id or entry.Name), App.alive)
    if not profile then return nil, err ~= "cancelled" and (Auto.name(entry) .. ": " .. tostring(err)) or nil end
    return {Data = Codec.encode(profile.Description), Id = profile.Id, Name = profile.Name}
end
-- Returns an index, "stop" or "restore".
function Auto.pick(step)
    local auto, list = Store.Auto, Store.Auto.List
    local count, current = #list, Store.Auto.Index
    if count == 0 then return nil end
    if current > count then current = 0 end
    if step < 0 then return current <= 1 and count or current - 1 end
    if count == 1 then return 1 end
    if auto.Order == "Random" then
        local index; repeat index = Auto.Rng:NextInteger(1, count) until index ~= current
        return index
    elseif auto.Order == "Shuffle" then
        for i = #Auto.Bag, 1, -1 do if Auto.Bag[i] > count then table.remove(Auto.Bag, i) end end
        if #Auto.Bag == 0 then
            -- Every avatar once per round; a new round never starts with the avatar being worn.
            for i = 1, count do table.insert(Auto.Bag, i) end
            for i = #Auto.Bag, 2, -1 do local j = Auto.Rng:NextInteger(1, i); Auto.Bag[i], Auto.Bag[j] = Auto.Bag[j], Auto.Bag[i] end
            if Auto.Bag[count] == current then Auto.Bag[count], Auto.Bag[1] = Auto.Bag[1], Auto.Bag[count] end
        end
        local index = table.remove(Auto.Bag)
        -- A manual Wear/Previous can make the next card the avatar already on; take the following one.
        if index == current and #Auto.Bag > 0 then index, Auto.Bag[#Auto.Bag] = Auto.Bag[#Auto.Bag], index end
        return index
    elseif auto.Order == "PingPong" then
        if current == 0 then Auto.Direction = 1; return 1 end
        local nextIndex = current + Auto.Direction
        if nextIndex > count or nextIndex < 1 then Auto.Direction = -Auto.Direction; nextIndex = current + Auto.Direction end
        return nextIndex
    end
    if current < count then return current + 1 end
    return auto.EndAction == "Loop" and 1 or auto.EndAction == "Restore" and "restore" or "stop"
end
-- Yields. Skips entries that can't be loaded.
function Auto.prepare(step, forced)
    local lastError
    for _ = 1, math.min(#Store.Auto.List, 5) do
        local index = forced or Auto.pick(step)
        if index == "restore" then
            if App.Initial then return App.Initial, nil, 0 end
            return nil, "The cycle ended, but the initial appearance is unknown."
        end
        if index == "stop" or not index then return nil, index == "stop" and "The avatar cycle reached the end of the list." or "The cycle list is empty." end
        local entry = Store.Auto.List[index]
        local ok, snapshot, err = pcall(Auto.resolve, entry)
        if ok and snapshot then return snapshot, nil, index end
        lastError = ok and err or tostring(snapshot)
        if forced or not App.alive() then break end
        Store.Auto.Index = index
    end
    return nil, lastError or "No avatar in the cycle could be loaded."
end
function Auto.commit(index, snapshot)
    if index then Store.Auto.Index = index end
    Auto.LastSwitch = os.clock(); Auto.TimerStart = os.clock(); Auto.DeathsSince = 0
    App.persist(); Auto.OnChange()
    if Store.Auto.Notify then
        App.toast({Title = "Avatar cycle", Text = snapshot.Original and "Initial appearance restored." or ("Now wearing " .. tostring(snapshot.Name) .. "."), Kind = "success", Icon = "repeat", Duration = 3})
    end
end
function Auto.switchNow(step, forced)
    if Auto.Switching or App.Busy or not App.alive() then return false end
    if #Store.Auto.List == 0 then App.report("Add avatars to the cycle list first.", "warning"); return false end
    local char = lp.Character; local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then App.report("Wait for your character to respawn.", "warning"); return false end
    Auto.Switching = true; Auto.OnChange()
    task.spawn(function()
        local snapshot, err, index = Auto.prepare(step, forced)
        if snapshot and App.alive() and char == lp.Character then
            if App.applySnapshot(snapshot, snapshot.Original and "restore" or "cycle", char) then Auto.commit(index, snapshot) end
        elseif err then App.report(err, "warning") end
        Auto.Switching = false; Auto.OnChange()
    end)
    return true
end
function Auto.move(from, to)
    local list = Store.Auto.List
    if from == to or from < 1 or from > #list or to < 1 or to > #list then return false end
    local item = table.remove(list, from); table.insert(list, to, item)
    local current = Store.Auto.Index
    if current == from then Store.Auto.Index = to
    elseif from < current and to >= current then Store.Auto.Index = current - 1
    elseif from > current and to <= current and current > 0 then Store.Auto.Index = current + 1 end
    table.clear(Auto.Bag)
    return true
end
function Auto.countsAs(kind)
    local trigger = Store.Auto.Trigger
    if kind == "death" then return trigger == "Death" or trigger == "Both" end
    return trigger == "Respawn"
end
-- When the threshold is met, the next avatar loads during the respawn timer.
function Auto.count(kind)
    local auto = Store.Auto
    if kind == "death" then Auto.Deaths = Auto.Deaths + 1 end
    if not auto.CycleEnabled or #auto.List == 0 or not Auto.countsAs(kind) or Auto.Pending then Auto.OnChange(); return end
    Auto.DeathsSince = Auto.DeathsSince + 1
    -- During the cooldown the counter is kept, so the next death after it switches.
    if Auto.DeathsSince < auto.EveryDeaths or os.clock() - Auto.LastSwitch < auto.Cooldown then Auto.OnChange(); return end
    local pending = {Done = false}
    Auto.Pending = pending
    task.spawn(function()
        local ok, snapshot, err, index = pcall(Auto.prepare, 1)
        if ok then pending.Snapshot, pending.Error, pending.Index = snapshot, err, index else pending.Error = tostring(snapshot) end
        pending.Done = true
    end)
    Auto.OnChange()
end
-- True when the cycle takes over this respawn; F.reapply stays out of it then.
function Auto.onRespawn(char)
    if Auto.SkipRespawn then Auto.SkipRespawn = false; return false end
    Auto.count("respawn")
    local pending = Auto.Pending
    if not pending then return false end
    Auto.Pending = nil
    task.spawn(function()
        local deadline = os.clock() + 15
        while not pending.Done and os.clock() < deadline and App.alive() do task.wait(0.1) end
        local hum = char:WaitForChild("Humanoid", 8); local root = char:WaitForChild("HumanoidRootPart", 8)
        if not App.alive() or char ~= lp.Character or not hum or not root then return end
        local loaded = os.clock() + 4
        while not lp:HasAppearanceLoaded() and os.clock() < loaded and App.alive() do task.wait(0.15) end
        local idle = os.clock() + 10
        while App.Busy and os.clock() < idle and App.alive() do task.wait(0.1) end
        if not App.alive() or char ~= lp.Character or hum.Health <= 0 then return end
        if pending.Snapshot then
            if App.applySnapshot(pending.Snapshot, pending.Snapshot.Original and "restore" or "cycle", char) then Auto.commit(pending.Index, pending.Snapshot); return end
        elseif pending.Error then App.report(pending.Error, "warning") end
        F.reapply(char, false)
    end)
    return true
end
function Auto.watch(char)
    if Auto.DiedConnection then Auto.DiedConnection:Disconnect(); Auto.DiedConnection = nil end
    local hum = char and char:WaitForChild("Humanoid", 10)
    if not hum or char ~= lp.Character or not App.alive() then return end
    Auto.DiedConnection = RegisterConnection(hum.Died:Connect(function()
        if not App.alive() or char ~= lp.Character then return end
        if Auto.SkipDeath then Auto.SkipDeath = false; return end
        Auto.count("death")
    end))
end
function Auto.startTimer()
    task.spawn(function()
        while App.alive() do
            task.wait(1)
            local auto = Store.Auto
            local timed = auto.CycleEnabled and (auto.Trigger == "Timer" or auto.Trigger == "Both") and #auto.List > 0
            if not timed or App.Busy or Auto.Switching or Auto.Pending then
                if not timed then Auto.TimerStart = os.clock() end
            elseif os.clock() - Auto.TimerStart >= auto.TimerSeconds and os.clock() - Auto.LastSwitch >= auto.Cooldown then
                Auto.TimerStart = os.clock()
                Auto.switchNow(1)
            end
            pcall(Auto.OnTick)
        end
    end)
end
-- A per-game choice wins over the general source.
function Auto.startEntry()
    local auto = Store.Auto
    local perGame = auto.Games[tostring(game.PlaceId)]
    if perGame then return perGame, nil, "this game's avatar" end
    if auto.LoadSource == "Last" then return auto.Last, nil, "last applied avatar" end
    if auto.LoadSource == "Random" then
        local pool = {}
        for _, row in ipairs(Store.Favorites) do local entry = Store.entry({Kind = "User", Id = row.Id, Name = row.Name, DisplayName = row.DisplayName}); if entry then table.insert(pool, entry) end end
        if #pool == 0 then return nil, nil, "random favorite" end
        return pool[Auto.Rng:NextInteger(1, #pool)], nil, "random favorite"
    end
    if auto.LoadSource == "Cycle" then
        local count = #auto.List
        if count == 0 then return nil, nil, "cycle avatar" end
        local index = (auto.Index >= 1 and auto.Index <= count) and auto.Index or 1
        return auto.List[index], index, "cycle avatar"
    end
    return auto.Chosen, nil, "chosen avatar"
end
function Auto.boot()
    if not Store.Auto.Resume then Store.Auto.Index = 0 end
    if not Store.Auto.LoadEnabled or Config.TargetUsername ~= "" then return false end
    local entry, index, label = Auto.startEntry()
    if not entry then App.report("Auto-load is on, but no " .. label .. " is set. Choose one in Auto & Cycle.", "warning"); return false end
    task.spawn(function()
        local char = lp.Character or lp.CharacterAdded:Wait()
        local deadline = os.clock() + 20
        repeat
            char = lp.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            local ready = hum and hum.Health > 0 and char:FindFirstChild("HumanoidRootPart")
            if not ready then task.wait(0.2) end
        until ready or os.clock() > deadline or not App.alive()
        local loaded = os.clock() + 6
        while not lp:HasAppearanceLoaded() and os.clock() < loaded and App.alive() do task.wait(0.15) end
        task.wait(Store.Auto.LoadDelay)
        while App.Busy and App.alive() do task.wait(0.2) end
        if not App.alive() then return end
        App.report("Auto-load: preparing " .. Auto.name(entry) .. "…", "loading")
        local ok, snapshot, err = pcall(Auto.resolve, entry)
        if not ok then err = tostring(snapshot); snapshot = nil end
        if not snapshot then App.report("Auto-load failed: " .. tostring(err or "unknown error"), "error"); return end
        if App.applySnapshot(snapshot, "apply") and index then
            Store.Auto.Index = index; Auto.LastSwitch = os.clock(); Auto.TimerStart = os.clock(); App.persist(); Auto.OnChange()
        end
    end)
    return true
end

F.reapply = function(char, transition)
    if not App.alive() or App.Busy or not App.Current or App.Current.Original then return end
    if transition and not Config.MapPersist then return end
    if not transition and not Config.AutoReapply then return end
    local stamp = S.operationSerial
    local hum = char:WaitForChild("Humanoid", 8); local root = char:WaitForChild("HumanoidRootPart", 8)
    if not hum or not root or hum.Health <= 0 or not App.alive() or char ~= lp.Character then return end
    local deadline = os.clock() + 4
    while not lp:HasAppearanceLoaded() and os.clock() < deadline and App.alive() do task.wait(0.05) end
    if App.Busy or stamp ~= S.operationSerial or S.appliedChar == char and not transition then return end
    App.applySnapshot(App.Current, "reapply", char)
end
RegisterConnection(lp.CharacterAdded:Connect(function(char)
    Repair.stop()
    if not App.alive() then return end
    task.spawn(Auto.watch, char)
    if not Auto.onRespawn(char) then task.spawn(F.reapply, char, false) end
end))
if lp.Character then task.spawn(Auto.watch, lp.Character) end
-- Some round-based games create a local stand-in model instead of respawning.
local ProcessedClones = setmetatable({}, {__mode = "k"})
local function applyToStandIn(model)
    if not Config.MapPersist or App.Busy or not App.Current or App.Current.Original or Overlay.visualOnly() then return end
    local stamp = S.operationSerial
    local hum = model:WaitForChild("Humanoid", 3)
    if not hum or not App.alive() or not model.Parent or model == lp.Character then return end
    if ProcessedClones[model] == stamp then return end
    local desc, dummy
    local ok = pcall(function()
        desc = Codec.decode(App.Current.Data)
        dummy = API.model(desc, F.getTrueRigType(model) or hum.RigType)
        if not App.alive() or stamp ~= S.operationSerial or App.Busy or model == lp.Character then return end
        local report = F.aAv(model, dummy); ProcessedClones[model] = stamp
        for _, row in ipairs(report.Items) do row.Template:Destroy() end
    end)
    if desc then desc:Destroy() end; if dummy then dummy:Destroy() end
    if not ok then ProcessedClones[model] = nil end
end
RegisterConnection(workspace.DescendantAdded:Connect(function(item)
    if item:IsA("Model") and item.Name == lp.Name and item ~= lp.Character then task.spawn(applyToStandIn, item) end
end))
_G.Copier_ToolsGiverToggle = function()
    _G.ToolsGiverActive = not _G.ToolsGiverActive
    if _G.ToolsGiverActive then F.startToolsGiverLoop() end
    App.report(_G.ToolsGiverActive and "ToolsGiver enabled." or "ToolsGiver disabled.", "info")
end

-- Toast notifier. Self-contained (TweenService, TextService and its own instances); the options are
-- documented in docs/reference/development.md.
local Toast = {}
Toast.__index = Toast
Toast.Tweens = game:GetService("TweenService")
Toast.Text = game:GetService("TextService")
Toast.DefaultTheme = {
    Background = Color3.fromRGB(24, 22, 36), Text = Color3.fromRGB(244, 239, 255),
    Muted = Color3.fromRGB(201, 193, 223), Line = Color3.fromRGB(78, 69, 101),
    Kinds = {info = Color3.fromRGB(188, 167, 246), success = Color3.fromRGB(137, 221, 187),
        warning = Color3.fromRGB(239, 205, 143), error = Color3.fromRGB(244, 151, 171)},
}
Toast.KindGlyphs = {info = "info", success = "check", warning = "alert", error = "cross"}
Toast.Badge = 24

function Toast.new(options)
    assert(type(options) == "table" and options.Parent, "Toast.new needs {Parent = Instance}")
    local self = setmetatable({}, Toast)
    self.Options = options
    local theme, kinds = {}, {}
    for key, value in pairs(Toast.DefaultTheme) do theme[key] = value end
    for key, value in pairs(options.Theme or {}) do theme[key] = value end
    for key, value in pairs(Toast.DefaultTheme.Kinds) do kinds[key] = value end
    for key, value in pairs(type(options.Theme) == "table" and type(options.Theme.Kinds) == "table" and options.Theme.Kinds or {}) do kinds[key] = value end
    self.Theme, self.Kinds = theme, kinds
    self.Font = options.Font or {Regular = Enum.Font.Gotham, Bold = Enum.Font.GothamBold}
    self.Width, self.Max, self.Margin, self.Lift = options.Width or 264, options.Max or 4, options.Margin or 12, options.Lift or 0
    self.Active = {}
    self.Container = Instance.new("Frame")
    self.Container.Name = "LyraToasts"; self.Container.BackgroundTransparency = 1; self.Container.ZIndex = 200
    self.Container.AnchorPoint = Vector2.new(1, 1)
    self.Container.Position = UDim2.new(1, -self.Margin, 1, -(self.Margin + self.Lift))
    self.Container.Size = UDim2.new(0, self.Width, 1, -(self.Margin * 2 + self.Lift))
    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder; layout.Padding = UDim.new(0, 6)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
    layout.Parent = self.Container
    self.Container.Parent = options.Parent
    self.Order = 0
    return self
end

function Toast:_reduced()
    local check = self.Options.ReducedMotion
    return type(check) == "function" and check() == true
end
function Toast:_tween(item, goal, duration)
    if self:_reduced() then for key, value in pairs(goal) do item[key] = value end; return nil end
    local tween = Toast.Tweens:Create(item, TweenInfo.new(duration, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), goal)
    tween:Play(); return tween
end
local function toastNew(class, props, parent)
    local item = Instance.new(class)
    for key, value in pairs(props) do item[key] = value end
    item.Parent = parent
    return item
end
function Toast.glyph(parent, name, color)
    local function stroke(x1, y1, x2, y2)
        local dx, dy = x2 - x1, y2 - y1
        local item = toastNew("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset((x1 + x2) / 2, (y1 + y2) / 2),
            Size = UDim2.fromOffset(math.sqrt(dx * dx + dy * dy) + 2, 2), Rotation = math.deg(math.atan2(dy, dx)),
            BackgroundColor3 = color, BorderSizePixel = 0, ZIndex = 203}, parent)
        toastNew("UICorner", {CornerRadius = UDim.new(1, 0)}, item)
    end
    local function dot(x, y)
        local item = toastNew("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(x, y), Size = UDim2.fromOffset(2.6, 2.6),
            BackgroundColor3 = color, BorderSizePixel = 0, ZIndex = 203}, parent)
        toastNew("UICorner", {CornerRadius = UDim.new(1, 0)}, item)
    end
    if name == "check" then stroke(7.5, 12.5, 10.5, 15.5); stroke(10.5, 15.5, 16.5, 9)
    elseif name == "cross" then stroke(8.5, 8.5, 15.5, 15.5); stroke(15.5, 8.5, 8.5, 15.5)
    elseif name == "alert" then stroke(12, 7.5, 12, 12.5); dot(12, 16.2)
    else dot(12, 7.8); stroke(12, 11, 12, 16.5) end
end

function Toast:Notify(spec)
    assert(type(spec) == "table" and spec.Title, "Notify needs {Title = string}")
    local kind = self.Kinds[spec.Kind or "info"] and (spec.Kind or "info") or "info"
    local color, theme = self.Kinds[kind], self.Theme
    local duration = spec.Duration == nil and 4 or spec.Duration
    local featured = spec.Featured == true
    local parentWidth = self.Options.Parent.AbsoluteSize.X
    local wanted = featured and self.Width + 56 or self.Width
    local width = parentWidth > 0 and math.min(wanted, parentWidth - self.Margin * 2) or wanted
    self.Container.Size = UDim2.new(0, math.min(self.Width, width), 1, -(self.Margin * 2 + self.Lift))
    self.Order = self.Order + 1

    -- Heights are measured with TextService. AutomaticSize here can feed back on itself and stretch the card.
    local title, text = tostring(spec.Title), spec.Text and tostring(spec.Text) or ""
    local badgeSize = featured and 40 or Toast.Badge
    local textLeft, textRight = 20 + badgeSize, 14
    local textWidth = math.max(60, width - textLeft - textRight)
    local function measure(value, size, font)
        if value == "" then return 0 end
        local ok, bounds = pcall(function() return Toast.Text:GetTextSize(value, size, font, Vector2.new(textWidth, 10000)) end)
        return ok and math.ceil(bounds.Y) or size + 4
    end
    local titleHeight = measure(title, 13, self.Font.Bold)
    local textHeight = measure(text, 12, self.Font.Regular)
    local action = type(spec.Action) == "table" and spec.Action or nil
    local actionHeight = action and 38 or 0
    local contentHeight = math.max(badgeSize, titleHeight + (textHeight > 0 and textHeight + 1 or 0) + actionHeight)
    local height = 10 + contentHeight + 11

    local holder = toastNew("Frame", {Name = "Toast", BackgroundTransparency = 1, Size = UDim2.fromOffset(width, height), LayoutOrder = self.Order, ZIndex = 200}, self.Container)
    local card = toastNew("CanvasGroup", {BackgroundColor3 = theme.Background, BackgroundTransparency = 0.06, Size = UDim2.fromScale(1, 1),
        Position = UDim2.fromOffset(24, 0), GroupTransparency = 1, BorderSizePixel = 0, ZIndex = 200}, holder)
    toastNew("UICorner", {CornerRadius = UDim.new(0, 12)}, card)
    toastNew("UIStroke", {Color = featured and color or theme.Line, Transparency = featured and 0.25 or 0.4, Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border}, card)
    local wash = toastNew("Frame", {Size = UDim2.fromScale(1, 1), BackgroundColor3 = color, BackgroundTransparency = 0, BorderSizePixel = 0, ZIndex = 200}, card)
    toastNew("UIGradient", {Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, featured and 0.7 or 0.84), NumberSequenceKeypoint.new(0.45, featured and 0.92 or 0.97), NumberSequenceKeypoint.new(1, 1)})}, wash)
    local badgeTop = 10 + math.floor((contentHeight - badgeSize) / 2)
    if featured then badgeTop = 10 end
    local badge = toastNew("Frame", {Position = UDim2.fromOffset(10, badgeTop), Size = UDim2.fromOffset(badgeSize, badgeSize), BackgroundColor3 = color,
        BackgroundTransparency = 0.82, BorderSizePixel = 0, ZIndex = 201}, card)
    toastNew("UICorner", {CornerRadius = featured and UDim.new(0, 12) or UDim.new(1, 0)}, badge)
    toastNew("UIStroke", {Color = color, Transparency = 0.55, Thickness = 1}, badge)
    local drew = false
    if type(spec.Image) == "string" and spec.Image ~= "" then
        local picture = toastNew("ImageLabel", {Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Image = spec.Image, ScaleType = Enum.ScaleType.Crop, ZIndex = 202}, badge)
        toastNew("UICorner", {CornerRadius = featured and UDim.new(0, 12) or UDim.new(1, 0)}, picture)
        drew = true
    end
    if not drew and spec.Icon and type(self.Options.Icon) == "function" then
        local holderIcon = toastNew("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(24, 24), BackgroundTransparency = 1, ZIndex = 202}, badge)
        toastNew("UIScale", {Scale = featured and 1 or 0.62}, holderIcon)
        drew = pcall(self.Options.Icon, holderIcon, spec.Icon, UDim2.new(), color)
        if not drew then holderIcon:Destroy() end
    end
    if not drew then Toast.glyph(badge, Toast.KindGlyphs[kind], color) end
    local top = 10 + math.floor((contentHeight - titleHeight - (textHeight > 0 and textHeight + 1 or 0) - actionHeight) / 2)
    toastNew("TextLabel", {Position = UDim2.fromOffset(textLeft, top), Size = UDim2.fromOffset(textWidth, titleHeight), BackgroundTransparency = 1, Text = title,
        TextColor3 = theme.Text, Font = self.Font.Bold, TextSize = 13, TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top, ZIndex = 201}, card)
    if textHeight > 0 then
        toastNew("TextLabel", {Position = UDim2.fromOffset(textLeft, top + titleHeight + 1), Size = UDim2.fromOffset(textWidth, textHeight), BackgroundTransparency = 1, Text = text,
            TextColor3 = theme.Muted, Font = self.Font.Regular, TextSize = 12, TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top, ZIndex = 201}, card)
    end
    local fill = toastNew("Frame", {Position = UDim2.new(0, 12, 1, -2), Size = UDim2.new(1, -24, 0, 1), BackgroundColor3 = color, BackgroundTransparency = 0.25,
        BorderSizePixel = 0, ZIndex = 202, Visible = duration > 0}, card)
    local hit = spec.Dismissible ~= false and toastNew("TextButton", {Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "", AutoButtonColor = false, ZIndex = 204}, card) or nil
    local actionButton
    if action then
        local label = tostring(action.Text or "Open")
        local ok, bounds = pcall(function() return Toast.Text:GetTextSize(label, 13, self.Font.Bold, Vector2.new(1000, 40)) end)
        local buttonWidth = math.clamp((ok and math.ceil(bounds.X) or 80) + 28, 90, textWidth)
        actionButton = toastNew("TextButton", {Position = UDim2.fromOffset(textLeft, top + titleHeight + (textHeight > 0 and textHeight + 1 or 0) + 8), Size = UDim2.fromOffset(buttonWidth, 30),
            BackgroundColor3 = color, Text = label, TextColor3 = theme.Background, Font = self.Font.Bold, TextSize = 13, AutoButtonColor = false, BorderSizePixel = 0, ZIndex = 205}, card)
        toastNew("UICorner", {CornerRadius = UDim.new(0, 9)}, actionButton)
    end

    local handle = {Closed = false}
    local notifier = self
    function handle:Dismiss()
        if handle.Closed then return end
        handle.Closed = true
        for i, item in ipairs(notifier.Active) do if item == handle then table.remove(notifier.Active, i); break end end
        if notifier:_reduced() then holder:Destroy(); return end
        notifier:_tween(card, {GroupTransparency = 1, Position = UDim2.fromOffset(24, 0)}, 0.2)
        task.delay(0.22, function() if holder.Parent then holder:Destroy() end end)
    end
    if hit then hit.Activated:Connect(function() handle:Dismiss() end) end
    if actionButton then
        actionButton.Activated:Connect(function()
            handle:Dismiss()
            if type(action.Callback) == "function" then task.spawn(action.Callback) end
        end)
    end
    table.insert(self.Active, handle)
    while #self.Active > self.Max do self.Active[1]:Dismiss() end

    self:_tween(card, {GroupTransparency = 0, Position = UDim2.fromOffset(0, 0)}, 0.3)
    if duration > 0 then
        if not self:_reduced() then
            Toast.Tweens:Create(fill, TweenInfo.new(duration, Enum.EasingStyle.Linear), {Size = UDim2.new(0, 0, 0, 1)}):Play()
        end
        task.delay(duration, function() handle:Dismiss() end)
    end
    return handle
end
function Toast:Clear()
    for i = #self.Active, 1, -1 do self.Active[i]:Dismiss() end
end
function Toast:Destroy()
    self.Active = {}
    if self.Container then self.Container:Destroy(); self.Container = nil end
end

-- The UI is plain Roblox instances; no UI library is loaded.
local UI = {Tab = "Avatar", Collection = "Favorites", Visible = true, Minimized = false, Tweens = {}, Rows = {}, PageToken = 0,
    Rotation = 0, Pitch = 0.05, Zoom = 1, PreviewModel = nil, ModalAction = nil, SearchGeneration = 0}
UI.C = {Base = Color3.fromRGB(19, 18, 29), Card = Color3.fromRGB(30, 28, 45), Raised = Color3.fromRGB(41, 37, 59),
    Line = Color3.fromRGB(78, 69, 101), Accent = Color3.fromRGB(188, 167, 246), AccentDark = Color3.fromRGB(111, 88, 161),
    Text = Color3.fromRGB(244, 239, 255), Muted = Color3.fromRGB(201, 193, 223), Green = Color3.fromRGB(137, 221, 187),
    Red = Color3.fromRGB(244, 151, 171), Gold = Color3.fromRGB(239, 205, 143)}
UI.TweenService = game:GetService("TweenService")
UI.Font = {Regular = Enum.Font.Gotham, Bold = Enum.Font.GothamBold}
pcall(function() UI.Font.Regular = Enum.Font.BuilderSansMedium; UI.Font.Bold = Enum.Font.BuilderSansBold end)
-- One size up for 9-13 px text, so captions stay readable on phones.
function UI.size(n) n = n or 14; if n <= 10 then return 12 elseif n <= 12 then return 13 elseif n <= 13 then return 14 end return n end
-- Icons: Lucide (ISC) and the GitHub/Discord marks from Simple Icons (CC0), packed into one 64 px sprite
-- sheet. See THIRD_PARTY_NOTICES.md. Without writefile/getcustomasset the vector fallbacks are drawn.
UI.IconNames = {"user","users","server","star","history","bookmark","sliders-horizontal","code-xml","search","x","menu","maximize-2","minus","plus","undo-2","copy","check","arrow-right","rotate-ccw","box","refresh-cw","pencil","share-2","trash-2","download","gamepad-2","shirt","save","link","github","discord",
    "bell","info","circle-check","triangle-alert","circle-x","eye-off","repeat","chevron-down","chevron-up"}
UI.IconIndex = {}; for index, iconName in ipairs(UI.IconNames) do UI.IconIndex[iconName] = index end
UI.IconAlias = {avatar = "user", players = "users", collection = "star", settings = "sliders-horizontal", creator = "code-xml", code = "code-xml",
    close = "x", expand = "maximize-2", undo = "undo-2", arrow = "arrow-right", reset = "rotate-ccw"}
UI.VectorAlias = {["sliders-horizontal"] = "settings", ["code-xml"] = "creator", users = "players", server = "players", user = "avatar", bookmark = "collection",
    history = "undo", ["undo-2"] = "undo", ["arrow-right"] = "arrow", ["rotate-ccw"] = "reset", x = "close", ["maximize-2"] = "expand", discord = "code",
    box = "avatar", ["refresh-cw"] = "reset", pencil = "code", ["share-2"] = "copy", ["trash-2"] = "close", download = "arrow", ["gamepad-2"] = "avatar",
    shirt = "avatar", save = "check", link = "copy", github = "github",
    bell = "collection", info = "search", ["circle-check"] = "check", ["triangle-alert"] = "close", ["circle-x"] = "close",
    ["eye-off"] = "minus", ["repeat"] = "reset", ["chevron-down"] = "minus", ["chevron-up"] = "plus"}
UI.IconBytes = 18277
UI.IconData = [=[
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
]=]
-- The AC logo, 160 px. "AC" is drawn as text when custom assets are unavailable.
UI.LogoBytes = 12341
UI.LogoData = [=[
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
]=]
-- Writes an embedded base64 PNG to the executor workspace and returns its asset id.
function UI.embeddedAsset(text, size, path)
    local asset = type(getcustomasset) == "function" and getcustomasset or type(getsynasset) == "function" and getsynasset
    assert(asset and type(writefile) == "function", "Custom assets are unavailable")
    local alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
    local lookup = {}; for i = 1, #alphabet do lookup[alphabet:byte(i)] = i - 1 end
    local data = text:gsub("[^%w%+/]", "")
    local parts = {}
    for i = 1, #data, 4 do
        local remaining = #data - i + 1
        local a, b = lookup[data:byte(i)], lookup[data:byte(i + 1)]
        local c, d = lookup[data:byte(i + 2) or 0] or 0, lookup[data:byte(i + 3) or 0] or 0
        local value = a * 262144 + b * 4096 + c * 64 + d
        if remaining >= 4 then parts[#parts + 1] = string.char(math.floor(value / 65536), math.floor(value / 256) % 256, value % 256)
        elseif remaining == 3 then parts[#parts + 1] = string.char(math.floor(value / 65536), math.floor(value / 256) % 256)
        else parts[#parts + 1] = string.char(math.floor(value / 65536)) end
    end
    local bytes = table.concat(parts)
    assert(#bytes == size and bytes:sub(2, 4) == "PNG", "Embedded image is corrupted")
    writefile(path, bytes)
    local id = asset(path)
    assert(type(id) == "string" and id ~= "", "The image could not be loaded")
    return id
end
function UI.loadIcons()
    if UI.IconSheet ~= nil then return end
    UI.IconSheet = false
    local ok, result = pcall(UI.embeddedAsset, UI.IconData, UI.IconBytes, "LyraAvatarStudio_icons_v14_7.png")
    if ok then UI.IconSheet = result
    else warn("[Lyra Avatar Studio] Icon pack unavailable, using built-in icons: " .. tostring(result)) end
    local logoOK, logo = pcall(UI.embeddedAsset, UI.LogoData, UI.LogoBytes, "LyraAvatarStudio_logo_v15.png")
    UI.LogoImage = logoOK and logo or nil
end
function UI.brandMark(parent, radius, textSize)
    if UI.LogoImage then
        local image = UI.new("ImageLabel", {Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, BorderSizePixel = 0, Image = UI.LogoImage, ScaleType = Enum.ScaleType.Crop}, parent)
        UI.round(image, radius)
        return image
    end
    local letters = UI.text(parent, "AC", textSize or 15, UI.C.Text, true)
    letters.Size = UDim2.fromScale(1, 1); letters.TextXAlignment = Enum.TextXAlignment.Center
    return letters
end
function UI.new(class, props, parent)
    local item = Instance.new(class)
    for key, value in pairs(props or {}) do item[key] = value end
    item.Parent = parent
    return item
end
function UI.connect(event, fn) return RegisterConnection(event:Connect(function(...) if App.alive() then fn(...) end end)) end
function UI.round(item, radius) return UI.new("UICorner", {CornerRadius = UDim.new(0, radius or 14)}, item) end
function UI.stroke(item, transparency, color) return UI.new("UIStroke", {Color = color or UI.C.Line, Transparency = transparency or 0.3, Thickness = 1}, item) end
function UI.tween(item, goal, duration, style, direction)
    if not item or not App.alive() then return end
    local previous = UI.Tweens[item]; if previous then previous:Cancel(); UI.Tweens[item] = nil end
    if Store.Settings.ReducedMotion or Store.Settings.LowEffects or (duration or 0.18) == 0 then for k, v in pairs(goal) do item[k] = v end; return end
    local tween = UI.TweenService:Create(item, TweenInfo.new(duration or 0.18, style or Enum.EasingStyle.Quint, direction or Enum.EasingDirection.Out), goal)
    UI.Tweens[item] = tween
    local connection
    connection = tween.Completed:Connect(function() if UI.Tweens[item] == tween then UI.Tweens[item] = nil end; connection:Disconnect() end)
    tween:Play()
end
function UI.text(parent, value, size, color, bold)
    return UI.new("TextLabel", {BackgroundTransparency = 1, Text = value, TextSize = UI.size(size), TextColor3 = color or UI.C.Text,
        Font = bold and UI.Font.Bold or UI.Font.Regular, TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center, TextTruncate = Enum.TextTruncate.AtEnd, BorderSizePixel = 0}, parent)
end
function UI.card(parent, height)
    local card = UI.new("Frame", {Size = UDim2.new(1, 0, 0, height), BackgroundColor3 = UI.C.Card, BackgroundTransparency = 0.22, BorderSizePixel = 0}, parent)
    UI.round(card, 16); UI.stroke(card, 0.55)
    return card
end
function UI.autoCard(parent, order, gap, padding)
    local card = UI.new("Frame", {Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundColor3 = UI.C.Card, BackgroundTransparency = 0.22, BorderSizePixel = 0, LayoutOrder = order or 0}, parent)
    UI.round(card, 16); UI.stroke(card, 0.55)
    UI.new("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, gap or 10)}, card)
    UI.new("UIPadding", {PaddingTop = UDim.new(0, padding or 16), PaddingBottom = UDim.new(0, padding or 16), PaddingLeft = UDim.new(0, padding or 16), PaddingRight = UDim.new(0, padding or 16)}, card)
    return card
end
function UI.paragraph(parent, value, size, color, bold, order)
    local label = UI.text(parent, value, size, color, bold)
    label.Size = UDim2.new(1, 0, 0, 0); label.AutomaticSize = Enum.AutomaticSize.Y; label.TextWrapped = true
    label.TextTruncate = Enum.TextTruncate.None; label.TextYAlignment = Enum.TextYAlignment.Top; label.LayoutOrder = order or 0
    return label
end
function UI.icon(parent, name, position, color)
    local root = UI.new("Frame", {BackgroundTransparency = 1, Size = UDim2.fromOffset(24, 24), Position = position or UDim2.new()}, parent)
    color = color or UI.C.Muted
    local spriteName = UI.IconAlias[name] or name
    local index = UI.IconIndex[spriteName]
    if UI.IconSheet and index then
        UI.new("ImageLabel", {BackgroundTransparency = 1, BorderSizePixel = 0, Size = UDim2.fromScale(1, 1), Image = UI.IconSheet,
            ImageRectOffset = Vector2.new(((index - 1) % 8) * 64, math.floor((index - 1) / 8) * 64), ImageRectSize = Vector2.new(64, 64),
            ImageColor3 = color, ScaleType = Enum.ScaleType.Fit}, root)
        return root
    end
    name = UI.VectorAlias[name] or name
    local function line(x1, y1, x2, y2)
        local dx, dy = x2-x1, y2-y1
        local item = UI.new("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset((x1+x2)/2, (y1+y2)/2),
            Size = UDim2.fromOffset(math.sqrt(dx*dx+dy*dy), 1.8), Rotation = math.deg(math.atan2(dy, dx)), BackgroundColor3 = color, BorderSizePixel = 0}, root)
        UI.round(item, 2)
    end
    local function box(x, y, w, h, radius, filled)
        local item = UI.new("Frame", {Position = UDim2.fromOffset(x,y), Size = UDim2.fromOffset(w,h), BackgroundColor3 = color, BackgroundTransparency = filled and 0 or 1, BorderSizePixel = 0}, root)
        UI.round(item, radius or 3); if not filled then UI.stroke(item, 0, color) end
    end
    if name == "avatar" then box(8,3,8,8,8); line(5,21,5,18); line(5,18,8,15); line(8,15,16,15); line(16,15,19,18); line(19,18,19,21)
    elseif name == "players" then box(3,4,7,7,7); box(14,5,6,6,6); line(1,20,3,15); line(3,15,10,15); line(10,15,12,20); line(15,15,20,15); line(20,15,22,20)
    elseif name == "collection" then box(3,5,14,16,3); line(8,2,21,2); line(21,2,21,16); line(7,10,13,10); line(7,14,12,14)
    elseif name == "settings" then for _, row in ipairs({{5,8},{12,16},{19,10}}) do line(3,row[1],21,row[1]); box(row[2]-2,row[1]-2,4,4,4,true) end
    elseif name == "creator" or name == "code" then line(8,6,2,12); line(2,12,8,18); line(16,6,22,12); line(22,12,16,18); line(14,3,10,21)
    elseif name == "search" then box(3,3,12,12,12); line(14,14,21,21)
    elseif name == "close" then line(6,6,18,18); line(18,6,6,18)
    elseif name == "menu" then line(4,6,20,6); line(4,12,20,12); line(4,18,20,18)
    elseif name == "expand" then line(4,9,4,4); line(4,4,9,4); line(15,4,20,4); line(20,4,20,9); line(4,15,4,20); line(4,20,9,20); line(15,20,20,20); line(20,20,20,15)
    elseif name == "minus" then line(5,12,19,12)
    elseif name == "plus" then line(5,12,19,12); line(12,5,12,19)
    elseif name == "undo" then line(8,5,3,10); line(3,10,8,15); line(3,10,15,10); line(15,10,19,14); line(19,14,19,18)
    elseif name == "copy" then box(3,7,13,14,3); line(8,3,21,3); line(21,3,21,16)
    elseif name == "github" then box(4,3,5,5,5); box(15,15,5,5,5); box(4,15,5,5,5); line(6.5,8,6.5,15); line(9,5.5,17.5,5.5); line(17.5,5.5,17.5,15)
    elseif name == "star" then
        local points = {}; for i=0,9 do local angle=-math.pi/2+i*math.pi/5; local r=i%2==0 and 10 or 4.5; points[i+1]={12+math.cos(angle)*r,12+math.sin(angle)*r} end
        for i=1,10 do local a,b=points[i],points[i%10+1]; line(a[1],a[2],b[1],b[2]) end
    elseif name == "check" then line(4,12,10,18); line(10,18,21,6)
    elseif name == "arrow" then line(4,12,20,12); line(14,6,20,12); line(20,12,14,18)
    elseif name == "reset" then line(5,9,8,5); line(8,5,17,5); line(17,5,21,12); line(21,12,17,19); line(17,19,8,19); line(8,19,4,15); line(3,4,3,10); line(3,10,9,10)
    end
    return root
end
function UI.button(parent, text, primary, callback, icon, rowKey)
    local button = UI.new("TextButton", {Size = UDim2.new(1,0,0,44), Text = "", AutoButtonColor = false, BackgroundColor3 = primary and UI.C.Accent or UI.C.Raised, BorderSizePixel = 0}, parent)
    UI.round(button, 12)
    local label = UI.text(button, text, 13, primary and UI.C.Base or UI.C.Text, true)
    label.Position = UDim2.fromOffset(icon and 40 or 8,0); label.Size = UDim2.new(1, icon and -48 or -16,1,0); label.TextXAlignment = icon and Enum.TextXAlignment.Left or Enum.TextXAlignment.Center
    local iconFrame = icon and UI.icon(button, icon, UDim2.new(0,10,0.5,-12), primary and UI.C.Base or UI.C.Accent)
    local base = button.BackgroundColor3
    local connect = rowKey and function(event, fn) UI.rowConnect(rowKey, event, fn) end or UI.connect
    connect(button.MouseEnter, function() if button.Active then UI.tween(button, {BackgroundColor3 = base:Lerp(Color3.new(1,1,1), 0.08)}) end end)
    connect(button.MouseLeave, function() UI.tween(button, {BackgroundColor3 = base}) end)
    connect(button.InputBegan, function(input) if button.Active and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then UI.tween(button, {BackgroundColor3 = base:Lerp(UI.C.Base,0.18)},0.08) end end)
    connect(button.InputEnded, function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then UI.tween(button, {BackgroundColor3 = base}) end end)
    connect(button.Activated, function() if button.Active and callback then callback() end end)
    return {Root = button, Label = label, Icon = iconFrame}
end
function UI.enabled(button, enabled)
    button.Root.Active = enabled; button.Root.Selectable = enabled
    button.Label.TextTransparency = enabled and 0 or 0.55
    button.Root.BackgroundTransparency = enabled and 0 or 0.55
end
function UI.input(parent, placeholder, icon)
    local frame = UI.card(parent, 42); frame.BackgroundColor3 = UI.C.Base
    UI.icon(frame, icon or "search", UDim2.new(0,11,0.5,-12))
    local box = UI.new("TextBox", {Position = UDim2.fromOffset(42,0), Size = UDim2.new(1,-54,1,0), BackgroundTransparency = 1,
        Text = "", PlaceholderText = placeholder, PlaceholderColor3 = UI.C.Muted, TextColor3 = UI.C.Text,
        Font = UI.Font.Regular, TextSize = 15, TextXAlignment = Enum.TextXAlignment.Left, ClearTextOnFocus = false}, frame)
    local border = frame:FindFirstChildOfClass("UIStroke")
    UI.connect(box.Focused, function() UI.tween(border,{Color=UI.C.Accent,Transparency=0.15}) end)
    UI.connect(box.FocusLost, function() UI.tween(border,{Color=UI.C.Line,Transparency=0.55}) end)
    return frame, box
end
function UI.section(parent, title, sub)
    local frame = UI.new("Frame", {Size=UDim2.new(1,0,0,sub and 50 or 26),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1},parent)
    UI.new("UIPadding",{PaddingBottom=UDim.new(0,sub and 4 or 0),PaddingTop=UDim.new(0,2)},frame)
    local label=UI.text(frame,title,17,nil,true); label.Size=UDim2.new(1,0,0,24)
    if sub then local hint=UI.text(frame,sub,12,UI.C.Muted); hint.Position=UDim2.fromOffset(0,25); hint.Size=UDim2.new(1,0,0,0); hint.AutomaticSize=Enum.AutomaticSize.Y; hint.TextWrapped=true; hint.TextTruncate=Enum.TextTruncate.None; hint.TextYAlignment=Enum.TextYAlignment.Top end
    return frame
end
function UI.page(name)
    local page = UI.new("ScrollingFrame", {Name=name, Size=UDim2.new(1,0,1,0), BackgroundTransparency=1, BorderSizePixel=0,
        ScrollBarThickness=3, ScrollBarImageColor3=UI.C.AccentDark, CanvasSize=UDim2.new(), AutomaticCanvasSize=Enum.AutomaticSize.Y,
        ScrollingDirection=Enum.ScrollingDirection.Y, Visible=false, ClipsDescendants=true},UI.Content)
    UI.new("UIPadding",{PaddingLeft=UDim.new(0,2),PaddingRight=UDim.new(0,6),PaddingTop=UDim.new(0,2),PaddingBottom=UDim.new(0,10)},page)
    -- An open dropdown list would drift away from its button, so scrolling closes it.
    UI.connect(page:GetPropertyChangedSignal("CanvasPosition"),function() if UI.OpenDrop then UI.closeDropdown() end end)
    UI.Pages[name]=page; return page
end
function UI.stack(parent, gap)
    return UI.new("UIListLayout", {SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,gap or 12)},parent)
end
-- options = {{Value = any, Label = string}, ...}. The list floats in its own layer so no scrolling frame clips it.
function UI.dropdown(parent,options,get,set)
    local button=UI.new("TextButton",{Size=UDim2.new(1,0,0,40),Text="",AutoButtonColor=false,BackgroundColor3=UI.C.Raised,BorderSizePixel=0},parent); UI.round(button,12)
    local stroke=UI.stroke(button,0.6)
    local label=UI.text(button,"",12,UI.C.Text,true); label.Position=UDim2.fromOffset(12,0); label.Size=UDim2.new(1,-42,1,0)
    local chevron=UI.icon(button,"chevron-down",UDim2.new(1,-32,0.5,-12),UI.C.Accent)
    local drop={Root=button,Label=label,Options=options,Get=get,Set=set,Chevron=chevron,Stroke=stroke}
    function drop.refresh()
        local current=get()
        for _,option in ipairs(options) do if option.Value==current then label.Text=option.Label end end
    end
    UI.connect(button.Activated,function() if UI.OpenDrop==drop then UI.closeDropdown() else UI.openDropdown(drop) end end)
    UI.connect(button.MouseEnter,function() UI.tween(button,{BackgroundColor3=UI.C.Raised:Lerp(Color3.new(1,1,1),0.06)}) end)
    UI.connect(button.MouseLeave,function() UI.tween(button,{BackgroundColor3=UI.C.Raised}) end)
    drop.refresh(); return drop
end
function UI.openDropdown(drop)
    UI.closeDropdown(true)
    if not UI.DropLayer then
        UI.DropLayer=UI.new("Frame",{Name="DropdownLayer",Size=UDim2.fromScale(1,1),BackgroundTransparency=1,ZIndex=70,Visible=false},UI.Main)
        local catcher=UI.new("TextButton",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Text="",AutoButtonColor=false},UI.DropLayer)
        UI.connect(catcher.Activated,function() UI.closeDropdown() end)
    end
    -- Children of the window are laid out before its UIScale, so absolute pixels are divided by it.
    local scale=UI.WindowScale.Scale>0 and UI.WindowScale.Scale or 1
    local at=(drop.Root.AbsolutePosition-UI.Main.AbsolutePosition)/scale
    local buttonSize=drop.Root.AbsoluteSize/scale
    local area=UI.Main.AbsoluteSize/scale
    local rowHeight=38
    local width=math.max(180,buttonSize.X)
    local height=math.min(#drop.Options,7)*rowHeight+8
    local below=at.Y+buttonSize.Y+6
    local up=below+height>area.Y-8
    local x=math.clamp(at.X+buttonSize.X-width,8,math.max(8,area.X-width-8))
    local y=up and math.max(8,at.Y-height-6) or below
    local list=UI.new("CanvasGroup",{Position=UDim2.fromOffset(x,y+(up and 6 or -6)),Size=UDim2.fromOffset(width,height),BackgroundColor3=UI.C.Card,
        BorderSizePixel=0,GroupTransparency=1},UI.DropLayer); UI.round(list,12); UI.stroke(list,0.45,UI.C.Accent)
    local scroll=UI.new("ScrollingFrame",{Position=UDim2.fromOffset(4,4),Size=UDim2.new(1,-8,1,-8),BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=2,
        ScrollBarImageColor3=UI.C.AccentDark,CanvasSize=UDim2.fromOffset(0,#drop.Options*rowHeight),ScrollingDirection=Enum.ScrollingDirection.Y},list)
    UI.Rows.dropdown={}
    local current=drop.Get()
    for index,option in ipairs(drop.Options) do
        local selected=option.Value==current
        local row=UI.new("TextButton",{Position=UDim2.fromOffset(0,(index-1)*rowHeight),Size=UDim2.new(1,0,0,rowHeight-2),Text="",AutoButtonColor=false,
            BackgroundColor3=UI.C.AccentDark,BackgroundTransparency=selected and 0.4 or 1,BorderSizePixel=0},scroll); UI.round(row,9)
        local text=UI.text(row,option.Label,12,selected and UI.C.Text or UI.C.Muted,selected); text.Position=UDim2.fromOffset(10,0); text.Size=UDim2.new(1,-40,1,0)
        if selected then UI.icon(row,"check",UDim2.new(1,-30,0.5,-12),UI.C.Accent) end
        UI.rowConnect("dropdown",row.MouseEnter,function() if not selected then UI.tween(row,{BackgroundTransparency=0.75}) end end)
        UI.rowConnect("dropdown",row.MouseLeave,function() if not selected then UI.tween(row,{BackgroundTransparency=1}) end end)
        UI.rowConnect("dropdown",row.Activated,function()
            UI.closeDropdown()
            if option.Value~=drop.Get() then drop.Set(option.Value); drop.refresh() end
        end)
    end
    if #drop.Options>7 then
        for index,option in ipairs(drop.Options) do if option.Value==current then scroll.CanvasPosition=Vector2.new(0,math.max(0,(index-4)*rowHeight)) end end
    end
    UI.OpenDrop=drop; UI.DropList=list; UI.DropLayer.Visible=true
    UI.tween(list,{GroupTransparency=0,Position=UDim2.fromOffset(x,y)},0.16)
    UI.tween(drop.Chevron,{Rotation=180},0.16); UI.tween(drop.Stroke,{Color=UI.C.Accent,Transparency=0.2},0.16)
end
function UI.closeDropdown(instant)
    local drop,list=UI.OpenDrop,UI.DropList
    if not drop then return end
    UI.OpenDrop=nil; UI.DropList=nil
    for _,connection in ipairs(UI.Rows.dropdown or {}) do connection:Disconnect() end
    UI.Rows.dropdown={}
    UI.tween(drop.Chevron,{Rotation=0},instant and 0 or 0.16); UI.tween(drop.Stroke,{Color=UI.C.Line,Transparency=0.6},instant and 0 or 0.16)
    if instant or Store.Settings.ReducedMotion or Store.Settings.LowEffects then list:Destroy(); UI.DropLayer.Visible=false; return end
    UI.tween(list,{GroupTransparency=1},0.1)
    task.delay(0.11,function()
        list:Destroy()
        if not UI.OpenDrop and UI.DropLayer then UI.DropLayer.Visible=false end
    end)
end
function UI.buildShell()
    local pg=lp:FindFirstChild("PlayerGui") or lp:WaitForChild("PlayerGui",10)
    assert(pg,"PlayerGui is unavailable.")
    pcall(UI.loadIcons)
    for _, name in ipairs({"CopierHubGUI","CopierMobileControls","FCControls"}) do local old=pg:FindFirstChild(name); if old then old:Destroy() end end
    local lighting=game:GetService("Lighting")
    for _, name in ipairs({"CopierLiquidBlur","CopierLiquidColor"}) do local old=lighting:FindFirstChild(name); if old then old:Destroy() end end
    UI.Gui=UI.new("ScreenGui",{Name="CopierHubGUI",ResetOnSpawn=false,DisplayOrder=990,ZIndexBehavior=Enum.ZIndexBehavior.Sibling,IgnoreGuiInset=false},pg)
    UI.Surface=UI.new("Frame",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1},UI.Gui)
    -- Built closed when Start hidden is on, so it never flashes. Skipped when nothing could reopen it.
    UI.StartSkipped=Store.Settings.StartHidden and not UI.canReopen()
    UI.Visible=not (Store.Settings.StartHidden and not UI.StartSkipped)
    UI.Main=UI.new("Frame",{Name="LyraHub",Position=UDim2.fromOffset(20,20),Size=UDim2.fromOffset(800,620),BackgroundColor3=UI.C.Base,BackgroundTransparency=0.16,BorderSizePixel=0,ClipsDescendants=true,Visible=UI.Visible},UI.Surface)
    UI.round(UI.Main,22); UI.WindowStroke=UI.stroke(UI.Main,0.28,UI.C.Accent)
    UI.WindowScale=UI.new("UIScale",{Scale=1},UI.Main)
    UI.Sheen=UI.new("UIGradient",{Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(235,211,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(124,120,174))}),Rotation=65},UI.Main)
    UI.Header=UI.new("Frame",{Size=UDim2.new(1,0,0,UI.HeaderH),BackgroundTransparency=1,Active=true},UI.Main)
    local logo=UI.new("Frame",{Position=UDim2.fromOffset(14,10),Size=UDim2.fromOffset(32,32),BackgroundColor3=UI.C.AccentDark,BorderSizePixel=0},UI.Header); UI.round(logo,11); UI.Logo=logo
    UI.brandMark(logo,11,13)
    local title=UI.text(UI.Header,"Avatar Studio",16,nil,true); UI.HeaderTitle=title; title.Position=UDim2.fromOffset(58,8); title.Size=UDim2.new(1,-210,0,22)
    local subtitle=UI.text(UI.Header,"by lyraEz   ·   v25.0.1",10,UI.C.Muted); UI.HeaderSubtitle=subtitle; subtitle.Position=UDim2.fromOffset(58,30); subtitle.Size=UDim2.new(1,-210,0,15)
    local close=UI.button(UI.Header,"",false,function() UI.closeHub() end,"close"); close.Root.Size=UDim2.fromOffset(42,42); close.Root.Position=UDim2.new(1,-48,0,5)
    local min=UI.button(UI.Header,"",false,function() UI.Minimized=not UI.Minimized; UI.layout(false) end,"minus"); min.Root.Size=UDim2.fromOffset(42,42); min.Root.Position=UDim2.new(1,-140,0,5)
    UI.MaxButton=UI.button(UI.Header,"",false,function() UI.Maximized=not UI.Maximized; UI.layout(true) end,"expand")
    UI.MaxButton.Root.Size=UDim2.fromOffset(42,42); UI.MaxButton.Root.Position=UDim2.new(1,-94,0,5)
    UI.MenuButton=UI.button(UI.Header,"",false,function() UI.Drawer=not UI.Drawer; UI.layout(false) end,"menu")
    UI.MenuButton.Root.Position=UDim2.fromOffset(8,5); UI.MenuButton.Root.Size=UDim2.fromOffset(42,42); UI.MenuButton.Root.Visible=false
    UI.Divider=UI.new("Frame",{Position=UDim2.fromOffset(18,UI.HeaderH-1),Size=UDim2.new(1,-36,0,1),BackgroundColor3=UI.C.Line,BackgroundTransparency=0.8,BorderSizePixel=0},UI.Main)
    UI.ContentBack=UI.new("Frame",{BackgroundColor3=UI.C.Card,BackgroundTransparency=0.56,BorderSizePixel=0},UI.Main); UI.round(UI.ContentBack,18); UI.stroke(UI.ContentBack,0.83,UI.C.Accent)
    UI.Content=UI.new("CanvasGroup",{BackgroundTransparency=1,BorderSizePixel=0,GroupTransparency=0},UI.Main)
    UI.Pages={}; UI.NavButtons={}
    UI.DrawerScrim=UI.new("TextButton",{Size=UDim2.new(1,0,1,-64),Position=UDim2.fromOffset(0,64),Text="",BackgroundColor3=Color3.new(0,0,0),BackgroundTransparency=0.4,BorderSizePixel=0,ZIndex=9,Visible=false,AutoButtonColor=false},UI.Main)
    UI.connect(UI.DrawerScrim.Activated,function() UI.Drawer=false; UI.layout(false) end)
    UI.Nav=UI.new("ScrollingFrame",{CanvasSize=UDim2.fromOffset(0,470),ScrollBarThickness=2,ScrollBarImageColor3=UI.C.AccentDark,ScrollingDirection=Enum.ScrollingDirection.Y,BackgroundColor3=UI.C.Base,BackgroundTransparency=0.7,BorderSizePixel=0,ZIndex=10},UI.Main); UI.round(UI.Nav,16)
    UI.NavCaption=UI.text(UI.Nav,"WORKSPACE",9,UI.C.Muted,true); UI.NavCaption.Position=UDim2.fromOffset(14,7); UI.NavCaption.Size=UDim2.new(1,-28,0,18)
    for i, spec in ipairs({{"Avatar","user","Copy Avatar"},{"Players","users","Server"},{"Collection","star","Favorites & Recent"},{"Looks","shirt","Saved Skins"},{"Catalog","box","Roblox Shop"},{"Auto","refresh-cw","Auto & Cycle"},{"Settings","sliders-horizontal","Settings"},{"Creator","code-xml","Creator"}}) do
        local name=spec[1]
        local button=UI.new("TextButton",{Position=UDim2.fromOffset(6,42+(i-1)*54),Size=UDim2.new(1,-12,0,48),Text="",AutoButtonColor=false,BackgroundColor3=UI.C.Raised,BackgroundTransparency=1,BorderSizePixel=0},UI.Nav); UI.round(button,12)
        local icon=UI.icon(button,spec[2],UDim2.fromOffset(12,12),UI.C.Accent)
        local label=UI.text(button,spec[3],12,UI.C.Muted,true); label.Position=UDim2.fromOffset(44,0); label.Size=UDim2.new(1,-48,1,0)
        local marker=UI.new("Frame",{Position=UDim2.new(0,0,0.5,-9),Size=UDim2.fromOffset(3,18),BackgroundColor3=UI.C.Accent,BorderSizePixel=0,Visible=false},button); UI.round(marker,3)
        UI.NavButtons[name]={Root=button,Label=label,Icon=icon,Marker=marker}
        UI.connect(button.Activated,function() UI.selectTab(name) end)
        UI.connect(button.MouseEnter,function() if UI.Tab~=name then UI.tween(button,{BackgroundTransparency=0.55}) end end)
        UI.connect(button.MouseLeave,function() if UI.Tab~=name then UI.tween(button,{BackgroundTransparency=1}) end end)
    end
    UI.NavFooter=UI.text(UI.Nav,"LYRA\nAVATAR STUDIO",9,UI.C.Muted,true); UI.NavFooter.Position=UDim2.new(0,16,1,-46); UI.NavFooter.Size=UDim2.new(1,-32,0,32)
    UI.Status=UI.new("Frame",{Position=UDim2.new(0,20,1,-119),Size=UDim2.new(1,-40,0,30),BackgroundTransparency=1},UI.Main)
    UI.StatusDot=UI.new("Frame",{Position=UDim2.new(0,0,0.5,-3),Size=UDim2.fromOffset(6,6),BackgroundColor3=UI.C.Accent,BorderSizePixel=0},UI.Status); UI.round(UI.StatusDot,6)
    UI.StatusText=UI.text(UI.Status,"Ready to explore avatars.",11,UI.C.Muted); UI.StatusText.Position=UDim2.fromOffset(16,0); UI.StatusText.Size=UDim2.new(1,-16,1,0); UI.StatusText.TextWrapped=true; UI.StatusText.TextTruncate=Enum.TextTruncate.None
    UI.Orb=UI.new("TextButton",{Size=UDim2.fromOffset(52,52),Position=UDim2.new(1,-68,0.5,-26),Text="",BackgroundTransparency=1,AutoButtonColor=false,BorderSizePixel=0,Visible=Store.Settings.MobileOrb},UI.Surface)
    UI.OrbFace=UI.new("Frame",{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.5,0.5),Size=UDim2.fromScale(1,1),BackgroundColor3=UI.C.AccentDark,BorderSizePixel=0},UI.Orb); UI.round(UI.OrbFace,18); UI.stroke(UI.OrbFace,0.15,UI.C.Accent)
    UI.OrbScale=UI.new("UIScale",{Scale=1},UI.OrbFace)
    UI.brandMark(UI.OrbFace,18,20)
    UI.connect(UI.Orb.Activated,function() if os.clock()>(UI.OrbIgnoreUntil or 0) then UI.setVisible(not UI.Visible) end end)
    UI.Blur=UI.new("BlurEffect",{Name="CopierLiquidBlur",Size=0,Enabled=true},lighting)
    UI.drag(UI.Header,UI.Main,false); UI.drag(UI.Orb,UI.Orb,true); UI.buildResizeGrip()
    UI.connect(UI.Surface:GetPropertyChangedSignal("AbsoluteSize"),function() UI.layout(false) end)
    local elapsed=0
    UI.connect(RS.RenderStepped,function(dt)
        if not UI.Visible or UI.Minimized or Store.Settings.LowEffects or Store.Settings.ReducedMotion then return end
        elapsed=elapsed+(dt or 0); if elapsed<1/30 then return end; elapsed=0
        local camera=workspace.CurrentCamera
        if camera and UI.Sheen then
            local look=camera.CFrame.LookVector
            UI.Sheen.Rotation=UI.Sheen.Rotation+(65+look.X*12-look.Y*8-UI.Sheen.Rotation)*0.12
        end
    end)
end
function UI.drag(handle, target, orb)
    local drag, touch, start, origin, moved
    UI.connect(handle.InputBegan,function(input)
        if input.UserInputType~=Enum.UserInputType.MouseButton1 and input.UserInputType~=Enum.UserInputType.Touch then return end
        local scale=UI.CurrentScale or 1
        if not orb and (UI.Maximized or input.Position.X>UI.Main.AbsolutePosition.X+UI.Main.AbsoluteSize.X-146*scale or (UI.Narrow and input.Position.X<UI.Main.AbsolutePosition.X+54*scale)) then return end
        -- A running layout tween would fight the drag.
        if not orb and UI.Tweens[UI.Main] then UI.Tweens[UI.Main]:Cancel(); UI.Tweens[UI.Main]=nil end
        drag=true; touch=input.UserInputType==Enum.UserInputType.Touch and input or nil; start=Vector2.new(input.Position.X,input.Position.Y); origin=target.AbsolutePosition-UI.Surface.AbsolutePosition; moved=false
    end)
    UI.connect(UIS.InputChanged,function(input)
        if not drag then return end
        if touch and input~=touch then return end
        if not touch and input.UserInputType~=Enum.UserInputType.MouseMovement then return end
        local delta=Vector2.new(input.Position.X,input.Position.Y)-start
        if delta.Magnitude>7 then moved=true end
        if moved then
            if orb then UI.OrbIgnoreUntil=os.clock()+1 end
            local size=UI.Surface.AbsoluteSize; local wanted=origin+delta
            target.Position=UDim2.fromOffset(math.clamp(wanted.X,8,math.max(8,size.X-target.AbsoluteSize.X-8)),math.clamp(wanted.Y,8,math.max(8,size.Y-target.AbsoluteSize.Y-8)))
        end
    end)
    UI.connect(UIS.InputEnded,function(input)
        if drag and ((touch and input==touch) or (not touch and input.UserInputType==Enum.UserInputType.MouseButton1)) then
            if orb and moved then UI.OrbIgnoreUntil=os.clock()+0.3 end
            drag=false; touch=nil
        end
    end)
end
-- Sizes are unscaled pixels; UIScale shrinks or grows the window.
UI.HeaderH=52
function UI.scale()
    local percent=Store.Settings.UIScale
    if percent and percent>0 then return percent/100 end
    local size=UI.Surface and UI.Surface.AbsoluteSize or Vector2.new(1280,720)
    return math.min(size.X,size.Y)<500 and 0.94 or 1
end
function UI.layout(center)
    if not UI.Main then return end
    local size=UI.Surface.AbsoluteSize
    if size.X<1 or size.Y<1 then return end
    local scale=UI.scale(); local scaleChanged=UI.CurrentScale~=nil and UI.CurrentScale~=scale; UI.CurrentScale=scale
    local motion=UI.Resizing and 0.08 or 0.25
    if UI.Visible and UI.WindowScale and (scaleChanged or (UI.WindowScale.Scale~=scale and not UI.ShowingTo)) then UI.tween(UI.WindowScale,{Scale=scale},motion) end
    local availW,availH=math.max(300,(size.X-20)/scale),math.max(240,(size.Y-20)/scale)
    local phone=math.min(size.X,size.Y)<500
    local w,h
    if UI.Maximized then w,h=availW,availH
    else
        w=Store.Settings.WindowW>0 and Store.Settings.WindowW or (phone and 560 or 820)
        w=math.clamp(w,300,availW)
        h=Store.Settings.WindowH>0 and Store.Settings.WindowH or ((phone or w<520) and availH or 600)
        h=math.clamp(h,240,availH)
    end
    local header=UI.HeaderH
    UI.Narrow=w<520
    local rail=not UI.Narrow and (w<760 and 60 or 196) or 0
    local left=rail>0 and rail+18 or 10
    local contentWidth=w-left-22
    UI.Compact=contentWidth<470
    UI.LowHeight=h<480
    UI.FullHeight=h
    local visualW,visualH=w*scale,(UI.Minimized and header or h)*scale
    -- While the window flies open, lay out around where it lands.
    local pos=UI.ShowingTo or UI.Main.Position
    local x=center and (size.X-visualW)/2 or pos.X.Offset
    local y=center and (size.Y-visualH)/2 or pos.Y.Offset
    local goal={Size=UDim2.fromOffset(w,UI.Minimized and header or h),
        Position=UDim2.fromOffset(math.clamp(x,10,math.max(10,size.X-visualW-10)),math.clamp(y,10,math.max(10,size.Y-visualH-10)))}
    if not (UI.ShowingTo and UI.ShowingTo==goal.Position and UI.Main.Size==goal.Size) then
        UI.tween(UI.Main,goal,motion)
        if UI.ShowingTo then UI.ShowingTo=goal.Position end
    end
    UI.Content.Visible=not UI.Minimized; UI.Status.Visible=not UI.Minimized; UI.ContentBack.Visible=not UI.Minimized
    UI.ResizeGrip.Visible=not UI.Minimized and not UI.Maximized
    UI.tween(UI.ContentBack,{Position=UDim2.fromOffset(left,header+6),Size=UDim2.new(1,-left-10,1,-(header+6+40))},motion)
    UI.tween(UI.Content,{Position=UDim2.fromOffset(left+8,header+12),Size=UDim2.new(1,-left-26,1,-(header+12+48))},motion)
    UI.tween(UI.Status,{Position=UDim2.new(0,left+6,1,-36),Size=UDim2.new(1,-left-46,0,28)},motion)
    UI.Nav.Visible=not UI.Minimized and (not UI.Narrow or UI.Drawer==true)
    UI.Nav.Position=UDim2.fromOffset(8,header+6)
    UI.tween(UI.Nav,{Size=UDim2.new(0,UI.Narrow and 216 or rail,1,-(header+16))},motion)
    UI.Nav.BackgroundTransparency=UI.Narrow and 0.03 or 0.72
    UI.DrawerScrim.Position=UDim2.fromOffset(0,header); UI.DrawerScrim.Size=UDim2.new(1,0,1,-header)
    UI.DrawerScrim.Visible=UI.Narrow and UI.Drawer==true and not UI.Minimized
    UI.MenuButton.Root.Visible=UI.Narrow; UI.Logo.Visible=not UI.Narrow
    UI.HeaderTitle.TextSize=UI.size(UI.Narrow and 14 or 16)
    UI.HeaderTitle.Position=UDim2.fromOffset(58,8)
    UI.HeaderSubtitle.Position=UDim2.fromOffset(58,30)
    local mini=rail==60
    UI.setNavLabels(not mini,not UI.LowHeight)
    local first,step,height=UI.LowHeight and 6 or 30,UI.LowHeight and 42 or 46,UI.LowHeight and 38 or 42
    for i,name in ipairs({"Avatar","Players","Collection","Looks","Catalog","Auto","Settings","Creator"}) do
        local button=UI.NavButtons[name]
        button.Root.Position=UDim2.fromOffset(5,first+(i-1)*step)
        button.Root.Size=UDim2.new(1,-10,0,height)
        if UI.LastMini~=mini then UI.tween(button.Icon,{Position=UDim2.new(0,mini and 13 or 11,0.5,-12)},motion) end
    end
    UI.LastMini=mini
    UI.Nav.CanvasSize=UDim2.fromOffset(0,first+8*step+(UI.LowHeight and 6 or 46))
    if UI.AvatarHeading then UI.AvatarHeading.Visible=not UI.LowHeight end
    for _,button in ipairs({UI.Undo,UI.Customize,UI.Restore}) do
        if button and button.Icon then
            button.Icon.Visible=not UI.Compact
            button.Label.Position=UDim2.fromOffset(UI.Compact and 6 or 40,0); button.Label.Size=UDim2.new(1,UI.Compact and -12 or -48,1,0)
            button.Label.TextXAlignment=UI.Compact and Enum.TextXAlignment.Center or Enum.TextXAlignment.Left
        end
    end
    if UI.AvatarGrid then
        if UI.Compact then
            UI.AvatarGrid.Size=UDim2.new(1,0,0,446)
            UI.PreviewCard.Position=UDim2.new(); UI.PreviewCard.Size=UDim2.new(1,0,0,226)
            UI.DetailCard.Position=UDim2.fromOffset(0,234); UI.DetailCard.Size=UDim2.new(1,0,0,212)
            UI.DisplayName.Position=UDim2.fromOffset(16,72); UI.DisplayName.TextSize=UI.size(18)
            UI.Username.Position=UDim2.fromOffset(16,100); UI.UserID.Position=UDim2.fromOffset(16,120); UI.UserID.Size=UDim2.new(1,-32,0,20)
            UI.Apply.Root.Position=UDim2.new(0,14,1,-56); UI.Apply.Root.Size=UDim2.new(0.58,-20,0,44)
            UI.Favorite.Root.Position=UDim2.new(0.58,0,1,-56); UI.Favorite.Root.Size=UDim2.new(0.42,-14,0,44)
        else
            local gridHeight=UI.LowHeight and math.max(170,h-200) or math.max(280,h-330)
            UI.AvatarGrid.Size=UDim2.new(1,0,0,gridHeight)
            UI.PreviewCard.Position=UDim2.new(); UI.PreviewCard.Size=UDim2.new(0.52,-5,1,0)
            UI.DetailCard.Position=UDim2.new(0.52,5,0,0); UI.DetailCard.Size=UDim2.new(0.48,-5,1,0)
            UI.DisplayName.Position=UDim2.fromOffset(16,74); UI.DisplayName.TextSize=UI.size(20)
            UI.Username.Position=UDim2.fromOffset(16,104); UI.UserID.Position=UDim2.fromOffset(16,128); UI.UserID.Size=UDim2.new(1,-32,0,20)
            UI.Apply.Root.Position=UDim2.new(0,14,1,-112); UI.Apply.Root.Size=UDim2.new(1,-28,0,44)
            UI.Favorite.Root.Position=UDim2.new(0,14,1,-62); UI.Favorite.Root.Size=UDim2.new(1,-28,0,42)
            if UI.LowHeight then
                UI.DisplayName.Position=UDim2.fromOffset(14,4); UI.DisplayName.TextSize=UI.size(16)
                UI.Username.Position=UDim2.fromOffset(14,30); UI.UserID.Position=UDim2.fromOffset(14,58); UI.UserID.Size=UDim2.new(1,-28,0,19)
                UI.Apply.Root.Position=UDim2.new(0,14,1,-98); UI.Favorite.Root.Position=UDim2.new(0,14,1,-50)
            end
        end
        UI.EmptyMotif.Visible=not UI.LowHeight
        UI.PreviewHint.Position=UI.LowHeight and UDim2.fromOffset(4,0) or UDim2.new(0,12,0.5,10)
        UI.PreviewHint.Size=UI.LowHeight and UDim2.new(1,-8,1,-8) or UDim2.new(1,-24,0,42)
        UI.PreviewHint.TextSize=UI.size(UI.LowHeight and 11 or 13)
        UI.LoadBar.Position=UI.LowHeight and UDim2.new(0.2,0,1,-4) or UDim2.new(0.2,0,0.5,61)
        UI.UserID.Visible=not UI.LowHeight; UI.PreviewThumb.Visible=not UI.LowHeight; UI.RigText.Visible=not UI.LowHeight
        if UI.LocalNote then UI.LocalNote.Visible=false end
    end
    if UI.Orb then local p=UI.Orb.AbsolutePosition-UI.Surface.AbsolutePosition; UI.Orb.Position=UDim2.fromOffset(math.clamp(p.X,8,math.max(8,size.X-60)),math.clamp(p.Y,8,math.max(8,size.Y-60))) end
    UI.effects(); UI.camera(true)
    if UI.Favorite then UI.Favorite.Label.Text=UI.favoriteText() end
end
function UI.favoriteText()
    local starred=App.Preview and App.favoriteIndex(App.Preview)
    if UI.Compact then return starred and "Unfavorite" or "Favorite" end
    return starred and "Remove favorite" or "Add favorite"
end
function UI.setNavLabels(show,extras)
    local state=tostring(show)..tostring(extras)
    if UI.NavLabelState==state then return end
    local first=UI.NavLabelState==nil
    UI.NavLabelState=state
    UI.NavLabelGeneration=(UI.NavLabelGeneration or 0)+1; local generation=UI.NavLabelGeneration
    local items={}
    for _,button in pairs(UI.NavButtons) do table.insert(items,{Label=button.Label,Show=show}) end
    table.insert(items,{Label=UI.NavCaption,Show=show and extras}); table.insert(items,{Label=UI.NavFooter,Show=show and extras})
    for _,item in ipairs(items) do
        local label=item.Label
        if item.Show then
            if first then label.Visible=true; label.TextTransparency=0
            elseif not label.Visible then
                label.TextTransparency=1; label.Visible=true
                task.delay(Store.Settings.ReducedMotion and 0 or 0.08,function() if App.alive() and generation==UI.NavLabelGeneration then UI.tween(label,{TextTransparency=0},0.22) end end)
            end
        elseif first then label.Visible=false
        elseif label.Visible then
            UI.tween(label,{TextTransparency=1},0.1)
            task.delay(Store.Settings.ReducedMotion and 0 or 0.1,function() if App.alive() and generation==UI.NavLabelGeneration then label.Visible=false end end)
        end
    end
end
function UI.buildResizeGrip()
    local grip=UI.new("TextButton",{Name="ResizeGrip",AnchorPoint=Vector2.new(1,1),Position=UDim2.new(1,-7,1,-7),Size=UDim2.fromOffset(28,28),Text="",
        BackgroundColor3=UI.C.Raised,BackgroundTransparency=0.35,AutoButtonColor=false,BorderSizePixel=0,ZIndex=30},UI.Main); UI.round(grip,10)
    for i,length in ipairs({16,10,4}) do
        local line=UI.new("Frame",{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromOffset(14+(i-1)*3.6,14+(i-1)*3.6),Size=UDim2.fromOffset(length,2),Rotation=-45,
            BackgroundColor3=UI.C.Accent,BorderSizePixel=0,ZIndex=31},grip); UI.round(line,2)
    end
    UI.ResizeGrip=grip
    UI.SizeBadge=UI.new("TextLabel",{AnchorPoint=Vector2.new(1,1),Size=UDim2.fromOffset(96,26),BackgroundColor3=UI.C.Base,BackgroundTransparency=1,
        TextColor3=UI.C.Text,TextTransparency=1,Font=UI.Font.Bold,TextSize=UI.size(12),Text="",BorderSizePixel=0,ZIndex=60},UI.Surface)
    UI.round(UI.SizeBadge,9); local badgeStroke=UI.stroke(UI.SizeBadge,1,UI.C.Accent)
    local function badge(visible)
        local w,h=Store.Settings.WindowW,Store.Settings.WindowH
        UI.SizeBadge.Text=tostring(math.floor(w)).." × "..tostring(math.floor(h))
        local corner=UI.Main.AbsolutePosition+UI.Main.AbsoluteSize-UI.Surface.AbsolutePosition
        UI.SizeBadge.Position=UDim2.fromOffset(corner.X-4,corner.Y-40)
        UI.tween(UI.SizeBadge,{BackgroundTransparency=visible and 0.08 or 1,TextTransparency=visible and 0 or 1},visible and 0.12 or 0.4)
        UI.tween(badgeStroke,{Transparency=visible and 0.35 or 1},visible and 0.12 or 0.4)
    end
    local active,touch,start,startW,startH
    UI.connect(grip.InputBegan,function(input)
        if input.UserInputType~=Enum.UserInputType.MouseButton1 and input.UserInputType~=Enum.UserInputType.Touch then return end
        active=true; touch=input.UserInputType==Enum.UserInputType.Touch and input or nil
        start=Vector2.new(input.Position.X,input.Position.Y); startW=UI.Main.Size.X.Offset; startH=UI.Main.Size.Y.Offset
        UI.Resizing=true; UI.Maximized=false
        UI.tween(grip,{BackgroundTransparency=0},0.1)
    end)
    UI.connect(UIS.InputChanged,function(input)
        if not active then return end
        if touch and input~=touch then return end
        if not touch and input.UserInputType~=Enum.UserInputType.MouseMovement then return end
        local scale=UI.CurrentScale or 1
        local delta=(Vector2.new(input.Position.X,input.Position.Y)-start)/scale
        local size=UI.Surface.AbsoluteSize; local corner=UI.Main.AbsolutePosition-UI.Surface.AbsolutePosition
        Store.Settings.WindowW=math.floor(math.clamp(startW+delta.X,300,math.max(300,(size.X-corner.X-10)/scale)))
        Store.Settings.WindowH=math.floor(math.clamp(startH+delta.Y,240,math.max(240,(size.Y-corner.Y-10)/scale)))
        UI.layout(false); badge(true)
    end)
    UI.connect(UIS.InputEnded,function(input)
        if active and ((touch and input==touch) or (not touch and input.UserInputType==Enum.UserInputType.MouseButton1)) then
            active=false; touch=nil; UI.Resizing=false
            UI.tween(grip,{BackgroundTransparency=0.35},0.15)
            UI.layout(false); App.persist()
            task.delay(0.5,function() if App.alive() and not active then badge(false) end end)
        end
    end)
end
function UI.effects(keepOrb)
    if not keepOrb then UI.Orb.Visible=(not UI.Visible or UI.Minimized) and Store.Settings.MobileOrb==true end
    UI.tween(UI.Blur,{Size=UI.Visible and not UI.Minimized and Store.Settings.GlassBlur and not Store.Settings.LowEffects and 9 or 0},0.25)
    UI.Main.BackgroundTransparency=Store.Settings.LowEffects and 0 or 0.16
    UI.ContentBack.BackgroundTransparency=Store.Settings.LowEffects and 0 or 0.56
end
-- Chat counts unless Roblox says this account can't chat; when that is unknown it is still offered.
UI.ChatOK=nil; UI.ChatChecked=false
function UI.detectChat()
    task.spawn(function()
        local ok,can=pcall(function() return game:GetService("TextChatService"):CanUserChatAsync(lp.UserId) end)
        UI.ChatChecked=true
        if App.alive() and ok and type(can)=="boolean" then UI.ChatOK=can end
        if App.alive() then UI.refreshReopenCard() end
    end)
end
function UI.reopenMethods()
    local list={}
    if UIS.KeyboardEnabled then table.insert(list,"press "..Store.Settings.Keybind) end
    if Store.Settings.MenuReopen then table.insert(list,"open and close the Roblox menu 3 times") end
    if UI.ChatOK~=false then table.insert(list,"type /e copier in chat") end
    return list
end
function UI.canReopen() return Store.Settings.MobileOrb==true or #UI.reopenMethods()>0 end
function UI.joinList(list)
    if #list<=1 then return list[1] or "" end
    if #list==2 then return list[1].." or "..list[2] end
    return table.concat(list,", ",1,#list-1)..", or "..list[#list]
end
function UI.reopenText()
    local list=UI.reopenMethods()
    return #list>0 and ("To reopen it, "..UI.joinList(list)..".") or "Turn on a reopen method in Settings."
end
function UI.hiddenHint()
    if not Store.Settings.MobileOrb then
        App.toast({Title = "Avatar Studio hidden", Text = UI.reopenText(), Kind = "info", Icon = "eye-off", Duration = 6})
    end
end
function UI.hide()
    UI.setVisible(false); UI.hiddenHint()
end
-- With the floating button off, the window is never hidden without a working way to reopen it.
function UI.closeHub()
    if not UI.Visible then return end
    if Store.Settings.MobileOrb then UI.hide(); return end
    if #UI.reopenMethods()==0 then
        UI.confirm("Nothing can reopen the window","Chat is unavailable, there is no keyboard and the Roblox menu shortcut is off. Turn the shortcut on and hide the window?",function()
            Store.Settings.MenuReopen=true; App.persist()
            local refresh=UI.Toggles and UI.Toggles.MenuReopen; if refresh then refresh() end
            UI.refreshReopenCard(); UI.hide()
        end,{Confirm="Turn on and hide",Cancel="Keep open",Seconds=15})
        return
    end
    if not Store.Settings.HideTipSeen then
        UI.confirm("Hide Avatar Studio?",UI.reopenText().." Make sure you can use one of these before hiding.",function()
            Store.Settings.HideTipSeen=true; App.persist(); UI.hide()
        end,{Confirm="Hide it",Cancel="Keep open",Seconds=10})
        return
    end
    UI.hide()
end
-- Only Position and UIScale tween during the flight, so nothing inside the window re-lays out.
UI.FlightTime=0.42; UI.FlightScale=0.06
function UI.orbCenter()
    local size=UI.Surface.AbsoluteSize; local p=UI.Orb.Position
    return Vector2.new(p.X.Scale*size.X+p.X.Offset+UI.Orb.Size.X.Offset/2,p.Y.Scale*size.Y+p.Y.Offset+UI.Orb.Size.Y.Offset/2)
end
function UI.windowCenter(position,scale)
    return Vector2.new(position.X.Offset+UI.Main.Size.X.Offset*scale/2,position.Y.Offset+UI.Main.Size.Y.Offset*scale/2)
end
function UI.flightBadge(point)
    if not UI.Badge then
        UI.Badge=UI.new("Frame",{AnchorPoint=Vector2.new(0.5,0.5),Size=UDim2.fromOffset(56,56),BackgroundColor3=UI.C.AccentDark,BorderSizePixel=0,Visible=false,ZIndex=80},UI.Surface)
        UI.round(UI.Badge,18); UI.stroke(UI.Badge,0.15,UI.C.Accent); UI.brandMark(UI.Badge,18,20)
        UI.BadgeScale=UI.new("UIScale",{Scale=0},UI.Badge)
    end
    UI.Badge.Position=UDim2.fromOffset(point.X,point.Y)
    return UI.Badge
end
function UI.setVisible(value)
    -- The chat command can arrive through several events, so a repeated call must do nothing.
    if value==UI.Visible then return end
    UI.VisibilityGeneration=(UI.VisibilityGeneration or 0)+1; local generation=UI.VisibilityGeneration
    if UI.Badge then UI.Badge.Visible=false end
    UI.Visible=value
    if UI.closeDropdown then UI.closeDropdown(true) end
    local scale=UI.CurrentScale or UI.scale()
    local time=UI.FlightTime
    local still=Store.Settings.ReducedMotion or Store.Settings.LowEffects
    local useOrb=Store.Settings.MobileOrb==true
    local function later(delay,fn) task.delay(still and 0 or delay,function() if App.alive() and generation==UI.VisibilityGeneration then fn() end end) end
    local function spot(point) return UDim2.fromOffset(point.X-UI.Main.Size.X.Offset*scale*UI.FlightScale/2,point.Y-UI.Main.Size.Y.Offset*scale*UI.FlightScale/2) end
    if value then
        local home=UI.HomePosition or UI.Main.Position; UI.HomePosition=nil; UI.ShowingTo=home
        later(time,function() UI.ShowingTo=nil end)
        if UI.Main.Visible then
            UI.tween(UI.Main,{Position=home},time*0.7); UI.tween(UI.WindowScale,{Scale=scale},time*0.7)
        else
            local point=useOrb and UI.orbCenter() or UI.windowCenter(home,scale)
            UI.Main.Position=spot(point); UI.WindowScale.Scale=scale*UI.FlightScale; UI.Main.Visible=true
            local delay=0
            if not useOrb then
                local badge=UI.flightBadge(point); badge.Visible=true; UI.BadgeScale.Scale=0.4
                UI.tween(UI.BadgeScale,{Scale=1},0.18,Enum.EasingStyle.Back)
                later(0.2,function() UI.tween(UI.BadgeScale,{Scale=0},0.22,Enum.EasingStyle.Back,Enum.EasingDirection.In) end)
                later(0.44,function() badge.Visible=false end)
                delay=0.1
            end
            later(delay,function()
                UI.tween(UI.Main,{Position=UI.ShowingTo or home},time,Enum.EasingStyle.Quint,Enum.EasingDirection.Out)
                UI.tween(UI.WindowScale,{Scale=scale},time,Enum.EasingStyle.Quint,Enum.EasingDirection.Out)
            end)
        end
        if useOrb and UI.Orb.Visible then
            UI.tween(UI.OrbScale,{Scale=0.55},0.16)
            UI.effects(true); later(0.16,function() UI.effects(); UI.OrbScale.Scale=1 end)
        else UI.effects() end
        return
    end
    if not UI.Main.Visible then UI.effects(); return end
    local home=UI.ShowingTo or UI.Main.Position; UI.ShowingTo=nil; UI.HomePosition=home
    local point=useOrb and UI.orbCenter() or UI.windowCenter(home,scale)
    if useOrb then
        UI.Orb.Visible=true; UI.OrbScale.Scale=0.7; UI.tween(UI.OrbScale,{Scale=1},0.24)
        later(time*0.9,function() UI.OrbScale.Scale=1.14; UI.tween(UI.OrbScale,{Scale=1},0.32,Enum.EasingStyle.Back) end)
    else
        local badge=UI.flightBadge(point); badge.Visible=true; UI.BadgeScale.Scale=0
        UI.tween(UI.BadgeScale,{Scale=1},0.26,Enum.EasingStyle.Back)
        later(time+0.04,function() UI.tween(UI.BadgeScale,{Scale=1.12},0.1) end)
        later(time+0.16,function() UI.tween(UI.BadgeScale,{Scale=0},0.24,Enum.EasingStyle.Back,Enum.EasingDirection.In) end)
        later(time+0.42,function() badge.Visible=false end)
    end
    UI.tween(UI.Main,{Position=spot(point)},time,Enum.EasingStyle.Quint,Enum.EasingDirection.InOut)
    UI.tween(UI.WindowScale,{Scale=scale*UI.FlightScale},time,Enum.EasingStyle.Quint,Enum.EasingDirection.InOut)
    later(time,function() UI.Main.Visible=false end)
    UI.effects(true)
end
function UI.selectTab(name)
    if not UI.Pages[name] then return end
    UI.Tab=name; UI.PageToken=UI.PageToken+1
    UI.closeDropdown(true)
    if UI.Drawer then UI.Drawer=false; UI.layout(false) end
    for key,page in pairs(UI.Pages) do page.Visible=key==name end
    for key,button in pairs(UI.NavButtons) do UI.tween(button.Root,{BackgroundTransparency=key==name and 0 or 1}); button.Label.TextColor3=key==name and UI.C.Text or UI.C.Muted; button.Marker.Visible=key==name end
    UI.Content.GroupTransparency=Store.Settings.ReducedMotion and 0 or 0.25
    UI.tween(UI.Content,{GroupTransparency=0},0.22)
    if name=="Players" then UI.renderPlayers() elseif name=="Collection" then UI.renderCollection() elseif name=="Looks" then UI.renderLooks() elseif name=="Catalog" then UI.renderCatalog() elseif name=="Auto" then UI.renderAuto() elseif name=="Creator" then UI.loadCreatorPhoto() end
end

function UI.buildAvatar()
    local page=UI.page("Avatar"); UI.stack(page,8)
    UI.AvatarHeading=UI.section(page,"Copy any Roblox avatar","Type a username or user ID, preview the avatar in 3D, then apply it to your character.")
    local input,box=UI.input(page,"Type a username or user ID"); input.LayoutOrder=1; UI.SearchBox=box
    box.Size=UDim2.new(1,-108,1,0)
    local search=UI.button(input,"",false,function() UI.query(box.Text,true) end,"arrow"); search.Root.Size=UDim2.fromOffset(38,34); search.Root.Position=UDim2.new(1,-42,0.5,-17)
    UI.AvatarGrid=UI.new("Frame",{LayoutOrder=2,Size=UDim2.new(1,0,0,390),BackgroundTransparency=1},page)
    UI.PreviewCard=UI.card(UI.AvatarGrid,390)
    UI.new("UIGradient",{Color=ColorSequence.new(UI.C.Raised,UI.C.Card),Rotation=60},UI.PreviewCard)
    local tag=UI.text(UI.PreviewCard,"3D PREVIEW",10,UI.C.Accent,true); tag.Position=UDim2.fromOffset(16,13); tag.Size=UDim2.new(1,-32,0,16)
    UI.Viewport=UI.new("ViewportFrame",{Position=UDim2.fromOffset(8,32),Size=UDim2.new(1,-16,1,-87),BackgroundTransparency=1,Ambient=Color3.fromRGB(195,186,213),LightColor=Color3.fromRGB(255,244,233),LightDirection=Vector3.new(-1,-1,-1),Active=true},UI.PreviewCard)
    UI.PreviewFallback=UI.new("ImageLabel",{Position=UDim2.fromOffset(8,30),Size=UDim2.new(1,-16,1,-114),BackgroundTransparency=1,Image="",ScaleType=Enum.ScaleType.Fit,Visible=false},UI.PreviewCard)
    UI.World=UI.new("WorldModel",{},UI.Viewport)
    UI.Camera=UI.new("Camera",{FieldOfView=35},UI.Viewport); UI.Viewport.CurrentCamera=UI.Camera
    UI.EmptyPreview=UI.new("Frame",{Position=UDim2.fromOffset(8,40),Size=UDim2.new(1,-16,1,-106),BackgroundTransparency=1},UI.PreviewCard)
    local motif=UI.icon(UI.EmptyPreview,"avatar",UDim2.new(0.5,-12,0.5,-48),UI.C.AccentDark); UI.EmptyMotif=motif; UI.new("UIScale",{Scale=1.5},motif)
    UI.PreviewHint=UI.text(UI.EmptyPreview,"Search a username above to preview an avatar here.",13,UI.C.Muted); UI.PreviewHint.Position=UDim2.new(0,12,0.5,10); UI.PreviewHint.Size=UDim2.new(1,-24,0,42); UI.PreviewHint.TextWrapped=true; UI.PreviewHint.TextTruncate=Enum.TextTruncate.None; UI.PreviewHint.TextXAlignment=Enum.TextXAlignment.Center
    UI.LoadBar=UI.new("Frame",{Position=UDim2.new(0.2,0,0.5,61),Size=UDim2.new(0.6,0,0,3),BackgroundColor3=UI.C.AccentDark,BackgroundTransparency=0.6,BorderSizePixel=0,Visible=false},UI.EmptyPreview); UI.round(UI.LoadBar,4)
    UI.LoadFill=UI.new("Frame",{Size=UDim2.new(0.2,0,1,0),BackgroundColor3=UI.C.Accent,BorderSizePixel=0},UI.LoadBar); UI.round(UI.LoadFill,4)
    local controls=UI.new("Frame",{Position=UDim2.new(0,12,1,-49),Size=UDim2.new(1,-24,0,38),BackgroundTransparency=1},UI.PreviewCard)
    local minus=UI.button(controls,"",false,function() UI.Zoom=math.clamp(UI.Zoom*1.14,0.55,1.8); UI.camera() end,"minus"); minus.Root.Size=UDim2.fromOffset(38,38)
    local plus=UI.button(controls,"",false,function() UI.Zoom=math.clamp(UI.Zoom/1.14,0.55,1.8); UI.camera() end,"plus"); plus.Root.Size=UDim2.fromOffset(38,38); plus.Root.Position=UDim2.fromOffset(44,0)
    local reset=UI.button(controls,"",false,function() UI.Rotation=0; UI.Pitch=0.05; UI.Zoom=1; UI.camera() end,"reset"); reset.Root.Size=UDim2.fromOffset(38,38); reset.Root.Position=UDim2.fromOffset(88,0)
    local hint=UI.text(controls,"Drag to rotate",10,UI.C.Muted); hint.Position=UDim2.fromOffset(134,0); hint.Size=UDim2.new(1,-138,1,0); hint.TextWrapped=true
    UI.DetailCard=UI.card(UI.AvatarGrid,390)
    UI.PreviewThumb=UI.new("ImageLabel",{Position=UDim2.fromOffset(18,18),Size=UDim2.fromOffset(48,48),Image="",BackgroundColor3=UI.C.Raised,BorderSizePixel=0},UI.DetailCard); UI.round(UI.PreviewThumb,14)
    UI.RigText=UI.text(UI.DetailCard,"ROBLOX PROFILE",9,UI.C.Accent,true); UI.RigText.Position=UDim2.fromOffset(78,24); UI.RigText.Size=UDim2.new(1,-94,0,30); UI.RigText.TextWrapped=true
    UI.DisplayName=UI.text(UI.DetailCard,"No profile selected",20,nil,true); UI.DisplayName.Position=UDim2.fromOffset(18,84); UI.DisplayName.Size=UDim2.new(1,-36,0,30)
    UI.Username=UI.text(UI.DetailCard,"Search by username or user ID.",12,UI.C.Muted); UI.Username.Position=UDim2.fromOffset(18,120); UI.Username.Size=UDim2.new(1,-36,0,20)
    UI.UserID=UI.text(UI.DetailCard,"The preview does not change your character.",10,UI.C.Muted); UI.UserID.Position=UDim2.fromOffset(18,148); UI.UserID.Size=UDim2.new(1,-36,0,36); UI.UserID.TextWrapped=true; UI.UserID.TextTruncate=Enum.TextTruncate.None
    UI.Apply=UI.button(UI.DetailCard,"Apply avatar",true,App.applyPreview,"check"); UI.Apply.Root.Position=UDim2.new(0,16,1,-126); UI.Apply.Root.Size=UDim2.new(1,-32,0,46)
    UI.Favorite=UI.button(UI.DetailCard,"Add favorite",false,function() UI.toggleFavorite(App.Preview) end,"star"); UI.Favorite.Root.Position=UDim2.new(0,16,1,-70); UI.Favorite.Root.Size=UDim2.new(1,-32,0,44)
    local note=UI.text(UI.DetailCard,"LOCAL APPLICATION",9,UI.C.Muted,true); note.Position=UDim2.new(0,16,1,-23); note.Size=UDim2.new(1,-32,0,13); note.TextXAlignment=Enum.TextXAlignment.Center; UI.LocalNote=note
    local history=UI.card(page,156); history.LayoutOrder=3
    UI.icon(history,"history",UDim2.fromOffset(12,9),UI.C.Accent)
    local title=UI.text(history,"Timeline",13,nil,true); title.Position=UDim2.fromOffset(42,9); title.Size=UDim2.fromOffset(90,24)
    UI.HistoryText=UI.text(history,"No changes applied.",11,UI.C.Muted); UI.HistoryText.Position=UDim2.fromOffset(132,9); UI.HistoryText.Size=UDim2.new(1,-146,0,24); UI.HistoryText.TextXAlignment=Enum.TextXAlignment.Right
    UI.TimelineStrip=UI.new("ScrollingFrame",{Position=UDim2.fromOffset(8,40),Size=UDim2.new(1,-16,0,66),BackgroundTransparency=1,BorderSizePixel=0,
        ScrollBarThickness=2,ScrollBarImageColor3=UI.C.AccentDark,ScrollingDirection=Enum.ScrollingDirection.X,CanvasSize=UDim2.new(),
        AutomaticCanvasSize=Enum.AutomaticSize.X,ElasticBehavior=Enum.ElasticBehavior.Never},history)
    UI.new("UIListLayout",{FillDirection=Enum.FillDirection.Horizontal,SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,4)},UI.TimelineStrip)
    UI.Undo=UI.button(history,"Undo",false,App.undo,"undo"); UI.Undo.Root.Position=UDim2.new(0,10,1,-46); UI.Undo.Root.Size=UDim2.new(1/3,-10,0,36)
    UI.Customize=UI.button(history,"Customize",true,UI.openCustomize,"pencil"); UI.Customize.Root.Position=UDim2.new(1/3,4,1,-46); UI.Customize.Root.Size=UDim2.new(1/3,-8,0,36)
    UI.Restore=UI.button(history,"Restore",false,App.restore,"reset"); UI.Restore.Root.Position=UDim2.new(2/3,0,1,-46); UI.Restore.Root.Size=UDim2.new(1/3,-10,0,36)
    UI.connect(box:GetPropertyChangedSignal("Text"),function() UI.query(box.Text,false) end)
    UI.connect(box.FocusLost,function(enter) if enter then UI.query(box.Text,true) end end)
    local dragging,last,touch
    UI.connect(UI.Viewport.InputBegan,function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then dragging=true; last=Vector2.new(input.Position.X,input.Position.Y); touch=input.UserInputType==Enum.UserInputType.Touch and input or nil; page.ScrollingEnabled=false end
    end)
    UI.connect(UIS.InputChanged,function(input)
        if not dragging or (touch and input~=touch) or (not touch and input.UserInputType~=Enum.UserInputType.MouseMovement) then return end
        local pos=Vector2.new(input.Position.X,input.Position.Y); local delta=pos-last; last=pos
        UI.Rotation=UI.Rotation-delta.X*0.012; UI.Pitch=math.clamp(UI.Pitch+delta.Y*0.006,-0.35,0.6); UI.camera(true)
    end)
    UI.connect(UIS.InputEnded,function(input) if dragging and ((touch and input==touch) or (not touch and input.UserInputType==Enum.UserInputType.MouseButton1)) then dragging=false; touch=nil; page.ScrollingEnabled=true end end)
    UI.connect(UI.Viewport.InputChanged,function(input) if input.UserInputType==Enum.UserInputType.MouseWheel then UI.Zoom=math.clamp(UI.Zoom*(input.Position.Z>0 and 0.9 or 1.1),0.55,1.8); UI.camera() end end)
    UI.connect(UI.Viewport:GetPropertyChangedSignal("AbsoluteSize"),function() UI.camera(true) end)
end

function UI.camera(immediate)
    if not UI.Camera or not UI.PreviewBounds then return end
    local b=UI.PreviewBounds; local size=UI.Viewport.AbsoluteSize
    local aspect=math.max(0.3,size.X/math.max(1,size.Y))
    local distance=(math.max(b.Y,b.X/aspect)*0.5/math.tan(math.rad(UI.Camera.FieldOfView/2))+b.Z*0.5)*1.18*UI.Zoom
    local center=UI.PreviewCenter
    local offset=Vector3.new(math.sin(UI.Rotation)*math.cos(UI.Pitch),math.sin(UI.Pitch),-math.cos(UI.Rotation)*math.cos(UI.Pitch))*distance
    UI.tween(UI.Camera,{CFrame=CFrame.lookAt(center+offset,center)},immediate and 0 or 0.16)
end
function UI.loading(value,message)
    UI.LoadBar.Visible=value
    if message then UI.PreviewHint.Text=message end
    UI.LoadGeneration=(UI.LoadGeneration or 0)+1; local generation=UI.LoadGeneration
    if value and not Store.Settings.ReducedMotion and not Store.Settings.LowEffects then
        task.spawn(function()
            while App.alive() and generation==UI.LoadGeneration and UI.LoadBar.Visible do
                UI.LoadFill.Position=UDim2.new(); UI.tween(UI.LoadFill,{Position=UDim2.new(0.8,0,0,0)},0.65); task.wait(0.7)
            end
        end)
    end
end
-- Previews are separate rigs, never the live character.
function UI.preparePreview(model,world)
    local root=model:FindFirstChild("HumanoidRootPart")
    local hum=model:FindFirstChildOfClass("Humanoid")
    assert(root and root:IsA("BasePart") and hum,"Roblox returned an incomplete rig.")
    for _,item in ipairs(model:GetDescendants()) do
        if item:IsA("Script") or item:IsA("LocalScript") or item:IsA("ModuleScript") then item:Destroy()
        elseif item:IsA("BasePart") then item.Anchored=item==root; item.CanCollide=false; item.CanTouch=false; item.CanQuery=false
        elseif item:IsA("Motor6D") or item:IsA("AnimationConstraint") then item.Transform=CFrame.new() end
    end
    model.Parent=world
    root.CFrame=CFrame.new()
    Rig.repair(model)
    local known=Rig.reachable(model,true)
    for _,accessory in ipairs(model:GetChildren()) do
        if accessory:IsA("Accessory") then
            local handle=accessory:FindFirstChild("Handle")
            if handle and not known[handle] then Appearance.attach(model,accessory) end
        end
    end
    known=Rig.reachable(model,true)
    local unresolved={}
    for _,part in ipairs(model:GetChildren()) do
        if Appearance.isBody(part,model) and not known[part] then table.insert(unresolved,part.Name) end
    end
    assert(#unresolved==0,"Rig has no connection points: "..table.concat(unresolved,", "))
end
function UI.showProfile(profile)
    App.Preview=profile
    UI.DisplayName.Text=profile.DisplayName; UI.Username.Text="@"..profile.Name; UI.UserID.Text="ID "..tostring(profile.Id)
    UI.PreviewThumb.Image="rbxthumb://type=AvatarHeadShot&id="..profile.Id.."&w=150&h=150"
    App.addRecent(profile); UI.refresh()
end
function UI.previewFallback(profile,reason)
    UI.loading(false,"3D preview unavailable. You can still apply the avatar.")
    UI.EmptyPreview.Visible=true; UI.EmptyMotif.Visible=false; UI.Viewport.Visible=false
    UI.PreviewFallback.Image="rbxthumb://type=Avatar&id="..profile.Id.."&w=420&h=420"; UI.PreviewFallback.Visible=true
    UI.RigText.Text="PROFILE LOADED"
    UI.showProfile(profile)
    App.report("Profile loaded with an image preview. Avatar application is available.","warning")
    warn("[Lyra Preview] "..tostring(reason))
end

function UI.query(raw,immediate)
    App.QueryToken=App.QueryToken+1; local token=App.QueryToken
    if App.SavedPreviewDesc then App.SavedPreviewDesc:Destroy(); App.SavedPreviewDesc=nil end
    App.Preview=nil; UI.refresh(); UI.EmptyPreview.Visible=true; UI.Viewport.Visible=false
    UI.PreviewFallback.Visible=false; UI.EmptyMotif.Visible=not UI.LowHeight
    UI.DisplayName.Text="No profile selected"; UI.Username.Text="Search by username or user ID."; UI.UserID.Text="The preview does not change your character."; UI.PreviewThumb.Image=""
    UI.loading(false,"Search a username above to preview an avatar here.")
    if tostring(raw):match("^%s*$") then return end
    task.delay(immediate and 0 or 0.6,function()
        local function valid() return App.alive() and token==App.QueryToken end
        if not valid() then return end
        UI.loading(true,"Searching for the profile…"); App.report("Searching for user…","loading")
        task.delay(25,function()
            if valid() and UI.LoadBar.Visible then
                App.QueryToken=App.QueryToken+1
                if App.Preview then UI.previewFallback(App.Preview,"The 3D preview timed out"); return end
                UI.loading(false,"The request timed out. Tap the arrow to try again.")
                App.report("The request timed out. Try again.","error")
            end
        end)
        local ok,profile,err=pcall(App.resolve,raw,valid)
        if not valid() then return end
        if not ok then err="The request failed. Try again."; profile=nil end
        if not profile then UI.loading(false,err); App.report(err,"error"); return end
        UI.showProfile(profile)
        UI.loading(true,"Building the 3D preview…"); App.report("Loading preview…","loading")
        local rig=F.getTrueRigType(lp.Character) or Enum.HumanoidRigType.R15
        local made,model=pcall(API.model,profile.Description,rig)
        if not valid() then if made and model then model:Destroy() end; return end
        if not made or not model then UI.previewFallback(profile,model or "Model unavailable"); return end
        local setupOK,setupError=pcall(function()
            UI.preparePreview(model,UI.World)
            local center,bounds=model:GetBoundingBox(); UI.PreviewCenter=center.Position; UI.PreviewBounds=bounds
            if UI.PreviewModel then UI.PreviewModel:Destroy() end
            UI.PreviewModel=model
        end)
        if not setupOK then model:Destroy(); UI.previewFallback(profile,setupError); return end
        App.Preview=profile; UI.Rotation=0; UI.Pitch=0.05; UI.Zoom=1; UI.camera(true)
        UI.loading(false); UI.EmptyPreview.Visible=false; UI.Viewport.Visible=true
        UI.DisplayName.Text=profile.DisplayName; UI.Username.Text="@"..profile.Name; UI.UserID.Text="ID "..tostring(profile.Id)
        UI.PreviewThumb.Image="rbxthumb://type=AvatarHeadShot&id="..profile.Id.."&w=150&h=150"
        UI.RigText.Text="PREVIEW IN "..rig.Name
        UI.refresh(); App.report("Preview ready. Tap Apply avatar when you are ready.","success")
    end)
end

function UI.clearRows(key, container)
    for _,connection in ipairs(UI.Rows[key] or {}) do connection:Disconnect() end
    UI.Rows[key]={}
    for _,child in ipairs(container:GetChildren()) do if not child:IsA("UIGridStyleLayout") then child:Destroy() end end
end
function UI.rowConnect(key,event,callback)
    table.insert(UI.Rows[key],event:Connect(function(...) if App.alive() then callback(...) end end))
end
function UI.profileRow(container,profile,index,key,onRemove)
    local row=UI.card(container,58); row.LayoutOrder=index
    local wide=not UI.Compact
    local previewWidth=wide and 104 or 40
    local controls=60+6+previewWidth+6+38+10
    local thumb=UI.new("ImageLabel",{Position=UDim2.fromOffset(10,9),Size=UDim2.fromOffset(40,40),BackgroundColor3=UI.C.Raised,BorderSizePixel=0,Image=profile.Id and ("rbxthumb://type=AvatarHeadShot&id="..profile.Id.."&w=150&h=150") or ""},row); UI.round(thumb,12)
    local title=UI.text(row,profile.DisplayName~="" and profile.DisplayName or profile.Name,13,nil,true); title.Position=UDim2.fromOffset(60,8); title.Size=UDim2.new(1,-(60+controls),0,22)
    local sub=UI.text(row,"@"..profile.Name,11,UI.C.Muted); sub.Position=UDim2.fromOffset(60,30); sub.Size=UDim2.new(1,-(60+controls),0,20)
    local wear=UI.button(row,"Wear",true,function() App.wearProfile(profile) end,nil,key)
    wear.Root.Size=UDim2.fromOffset(60,38); wear.Root.Position=UDim2.new(1,-controls,0.5,-19)
    local open=UI.button(row,wide and "Preview" or "",false,function()
        UI.selectTab("Avatar"); UI.SearchBox.Text=tostring(profile.Id or profile.Name); UI.query(UI.SearchBox.Text,true)
    end,"box",key)
    open.Root.Size=UDim2.fromOffset(previewWidth,38); open.Root.Position=UDim2.new(1,-(controls-66),0.5,-19)
    local remove=UI.button(row,"",false,function() if onRemove then onRemove() else UI.toggleFavorite(profile) end end,onRemove and "x" or "star",key)
    remove.Root.Size=UDim2.fromOffset(38,38); remove.Root.Position=UDim2.new(1,-48,0.5,-19)
end
function UI.emptyList(container,title,hint)
    local card=UI.card(container,126)
    local icon=UI.icon(card,"search",UDim2.new(0.5,-12,0,16),UI.C.AccentDark)
    local label=UI.text(card,title,14,nil,true); label.Position=UDim2.fromOffset(14,53); label.Size=UDim2.new(1,-28,0,23); label.TextXAlignment=Enum.TextXAlignment.Center
    local text=UI.text(card,hint,11,UI.C.Muted); text.Position=UDim2.fromOffset(14,80); text.Size=UDim2.new(1,-28,0,31); text.TextWrapped=true; text.TextTruncate=Enum.TextTruncate.None; text.TextXAlignment=Enum.TextXAlignment.Center
end
function UI.buildPlayers()
    local page=UI.page("Players"); UI.stack(page,8)
    UI.section(page,"Players in this server","Tap Preview to see a player's avatar in 3D, or the star to add them to Favorites.")
    local input,box=UI.input(page,"Search players by name or username"); input.LayoutOrder=1; UI.PlayerSearch=box
    UI.PlayerCount=UI.text(page,"",11,UI.C.Muted); UI.PlayerCount.Size=UDim2.new(1,0,0,20); UI.PlayerCount.LayoutOrder=2
    UI.PlayerList=UI.new("Frame",{LayoutOrder=3,Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1},page); UI.stack(UI.PlayerList,6)
    UI.connect(box:GetPropertyChangedSignal("Text"),function() UI.scheduleList("players") end)
    UI.connect(Players.PlayerAdded,function() if UI.Tab=="Players" then UI.scheduleList("players") end end)
    UI.connect(Players.PlayerRemoving,function() if UI.Tab=="Players" then task.defer(function() if App.alive() then UI.scheduleList("players") end end) end end)
end
function UI.scheduleList(kind)
    UI.ListGeneration=UI.ListGeneration or {}; UI.ListGeneration[kind]=(UI.ListGeneration[kind] or 0)+1; local token=UI.ListGeneration[kind]
    task.delay(0.16,function() if App.alive() and token==UI.ListGeneration[kind] then if kind=="players" then UI.renderPlayers() elseif kind=="looks" then UI.renderLooks() else UI.renderCollection() end end end)
end
function UI.matches(profile,term)
    return term=="" or (profile.Name or ""):lower():find(term,1,true) or (profile.DisplayName or ""):lower():find(term,1,true) or tostring(profile.Id or ""):find(term,1,true)
end
function UI.renderPlayers()
    if not UI.PlayerList then return end
    UI.clearRows("players",UI.PlayerList)
    local term=UI.PlayerSearch.Text:lower(); local list=Players:GetPlayers(); local count=0
    table.sort(list,function(a,b) return a.Name:lower()<b.Name:lower() end)
    for _,player in ipairs(list) do
        local profile={Id=player.UserId,Name=player.Name,DisplayName=player.DisplayName}
        if UI.matches(profile,term) then count=count+1; UI.profileRow(UI.PlayerList,profile,count,"players") end
    end
    UI.PlayerCount.Text="Showing "..tostring(count).." of "..tostring(#list).." players"
    if count==0 then UI.emptyList(UI.PlayerList,"No players found","Try another name or clear the search.") end
end
function UI.buildCollection()
    local page=UI.page("Collection"); UI.stack(page,8)
    UI.section(page,"Favorites & Recent","Profiles you starred and avatars you searched lately. Tap Preview to open one.")
    local tabs=UI.new("Frame",{LayoutOrder=1,Size=UDim2.new(1,0,0,44),BackgroundTransparency=1},page)
    UI.FavTab=UI.button(tabs,"Favorites",false,function() UI.Collection="Favorites"; UI.renderCollection() end,"star"); UI.FavTab.Root.Size=UDim2.new(0.5,-6,1,0)
    UI.RecentTab=UI.button(tabs,"Recent searches",false,function() UI.Collection="Recent"; UI.renderCollection() end,"history"); UI.RecentTab.Root.Position=UDim2.new(0.5,6,0,0); UI.RecentTab.Root.Size=UDim2.new(0.5,-6,1,0)
    local input,box=UI.input(page,"Filter this list by name"); input.LayoutOrder=2; UI.CollectionSearch=box
    local toolbar=UI.new("Frame",{LayoutOrder=3,Size=UDim2.new(1,0,0,38),BackgroundTransparency=1},page)
    UI.CollectionCount=UI.text(toolbar,"",11,UI.C.Muted); UI.CollectionCount.Size=UDim2.new(1,-142,1,0)
    UI.ClearCollection=UI.button(toolbar,"Clear list",false,function()
        local target=UI.Collection
        UI.confirm("Clear "..target:lower().."?","This removes every profile from the list. Your current appearance is unchanged.",function()
            if target=="Favorites" then Store.Favorites={} else Store.Recent={} end
            UI.refresh(); UI.renderCollection(); App.persist()
        end)
    end); UI.ClearCollection.Root.Size=UDim2.fromOffset(130,36); UI.ClearCollection.Root.Position=UDim2.new(1,-130,0,0)
    UI.CollectionList=UI.new("Frame",{LayoutOrder=4,Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1},page); UI.stack(UI.CollectionList,6)
    UI.connect(box:GetPropertyChangedSignal("Text"),function() UI.scheduleList("collection") end)
end
function UI.renderCollection()
    if not UI.CollectionList then return end
    UI.clearRows("collection",UI.CollectionList)
    local favorite=UI.Collection=="Favorites"; local list=favorite and Store.Favorites or Store.Recent; local term=UI.CollectionSearch.Text:lower(); local count=0
    UI.tween(UI.FavTab.Root,{BackgroundColor3=favorite and UI.C.AccentDark or UI.C.Raised})
    UI.tween(UI.RecentTab.Root,{BackgroundColor3=not favorite and UI.C.AccentDark or UI.C.Raised})
    for index,profile in ipairs(list) do
        if UI.matches(profile,term) then
            count=count+1
            UI.profileRow(UI.CollectionList,profile,count,"collection",function()
                UI.confirm("Remove this profile?",profile.Name.." will be removed from "..UI.Collection:lower()..".",function()
                    for i=#list,1,-1 do if list[i]==profile then table.remove(list,i); break end end
                    UI.refresh(); UI.renderCollection(); App.persist()
                end)
            end)
        end
    end
    UI.CollectionCount.Text=count.." profiles"; UI.enabled(UI.ClearCollection,#list>0)
    if count==0 then UI.emptyList(UI.CollectionList,term~="" and "No results" or favorite and "Your favorites will appear here" or "No recent searches yet",term~="" and "Try another name or clear the search." or favorite and "Preview a profile in Copy Avatar and tap Add favorite." or "Search for a profile in the Copy Avatar tab.") end
end

function UI.captureLook(model, key, name)
    if UI.CaptureBusy or App.Busy then return end
    UI.CaptureBusy = true; App.report(key and "Updating skin…" or "Capturing skin…", "loading")
    task.spawn(function()
        local ok, row, method, incomplete, persisted = pcall(Looks.capture, model, name, key)
        UI.CaptureBusy = false
        if not App.alive() then return end
        if not ok then App.report(tostring(row), "error"); return end
        UI.SelectedLook = row.Key
        if not key then UI.LookName.Text = "" end
        UI.renderLooks()
        if not persisted then App.report("Skin kept for this session only; the executor could not save the file.", "warning")
        elseif incomplete then App.report("Skin saved, but the preview shows accessories outside the description. Some items may be missing.", "warning")
        else App.report((key and "Skin updated" or "Skin saved") .. " using " .. method .. ".", "success") end
    end)
end
function UI.previewLook(row)
    App.QueryToken = App.QueryToken + 1; local token = App.QueryToken
    if App.SavedPreviewDesc then App.SavedPreviewDesc:Destroy(); App.SavedPreviewDesc = nil end
    local ok, desc = pcall(Codec.decode, row.Data)
    if not ok then App.report("This saved skin is corrupted.", "error"); return end
    App.SavedPreviewDesc = desc
    App.Preview = {Name = row.Name, DisplayName = row.Name, Description = desc, SnapshotData = row.Data, LookKey = row.Key}
    UI.selectTab("Avatar")
    UI.EmptyPreview.Visible = true; UI.Viewport.Visible = false; UI.PreviewFallback.Visible = false
    UI.PreviewThumb.Image = ""; UI.DisplayName.Text = row.Name; UI.Username.Text = "Created skin"; UI.UserID.Text = "Saved in your library"
    UI.RigText.Text = "SAVED SKIN"; UI.loading(true, "Building the 3D preview…"); UI.refresh()
    task.spawn(function()
        local rig = row.Data.Visual and Enum.HumanoidRigType[row.Data.Visual.RigType] or F.getTrueRigType(lp.Character) or Enum.HumanoidRigType.R15
        local made, model = pcall(Visual.model, row.Data, desc, rig)
        if not App.alive() or token ~= App.QueryToken then if made and model then model:Destroy() end; return end
        if not made or not model then
            UI.loading(false, "The preview could not be loaded. Check the message below.")
            App.report(tostring(model or "Roblox did not return the model."), "error"); return
        end
        local ready, problem = pcall(function()
            UI.preparePreview(model, UI.World)
            local center, bounds = model:GetBoundingBox(); UI.PreviewCenter = center.Position; UI.PreviewBounds = bounds
            if UI.PreviewModel then UI.PreviewModel:Destroy() end
            UI.PreviewModel = model
        end)
        if not ready then model:Destroy(); UI.loading(false, "Preview unavailable. You can still apply the skin."); warn("[Lyra Preview] " .. tostring(problem)); return end
        UI.Rotation = 0; UI.Pitch = 0.05; UI.Zoom = 1; UI.camera(true)
        UI.loading(false); UI.EmptyPreview.Visible = false; UI.Viewport.Visible = true
        App.report("Preview ready. The Apply avatar button uses the saved skin.", "success")
    end)
end
function UI.wearLook(row)
    if App.Busy then return end
    task.spawn(App.applySnapshot, {Data = row.Data, Name = row.Name, LookKey = row.Key}, "apply")
end
function UI.lookRow(row, index)
    local selected = row.Key == UI.SelectedLook
    local wearing = App.Current and App.Current.LookKey == row.Key
    local card = UI.card(UI.LookList, 58); card.LayoutOrder = index * 2
    if selected or wearing then local stroke = card:FindFirstChildOfClass("UIStroke"); stroke.Color = UI.C.Accent; stroke.Transparency = selected and 0 or 0.35 end
    local frame = UI.new("Frame", {Position = UDim2.fromOffset(8, 7), Size = UDim2.fromOffset(44, 44), BackgroundColor3 = UI.C.Raised, BorderSizePixel = 0, ClipsDescendants = true}, card); UI.round(frame, 12)
    UI.lookThumb(frame, row.Key)
    local controls = 62 + 6 + 40 + 6 + 40 + 9
    local title = UI.text(card, row.Name, 13, selected and UI.C.Accent or UI.C.Text, true)
    title.Position = UDim2.fromOffset(60, 7); title.Size = UDim2.new(1, -(60 + controls), 0, 22)
    local detail = wearing and "Wearing now" or ((row.Data.Visual and row.Source or "Description only") .. "  ·  " .. os.date("%b %d", row.Updated))
    local sub = UI.text(card, detail, 11, wearing and UI.C.Accent or UI.C.Muted)
    sub.Position = UDim2.fromOffset(60, 30); sub.Size = UDim2.new(1, -(60 + controls), 0, 20)
    local wear = UI.button(card, "Wear", true, function() UI.wearLook(row) end, nil, "looks")
    wear.Root.Size = UDim2.fromOffset(62, 38); wear.Root.Position = UDim2.new(1, -controls, 0.5, -19)
    local preview = UI.button(card, "", false, function() UI.previewLook(row) end, "box", "looks")
    preview.Root.Size = UDim2.fromOffset(40, 38); preview.Root.Position = UDim2.new(1, -(40 + 6 + 40 + 9), 0.5, -19)
    local manage = UI.button(card, "", false, function()
        if selected then UI.SelectedLook = nil else UI.SelectedLook = row.Key end
        UI.renderLooks()
    end, "pencil", "looks")
    manage.Root.Size = UDim2.fromOffset(40, 38); manage.Root.Position = UDim2.new(1, -49, 0.5, -19)
    if selected then manage.Root.BackgroundColor3 = UI.C.AccentDark end
end
function UI.lookManage(row, index)
    local panel = UI.autoCard(UI.LookList, index * 2 + 1, 8, 10)
    panel.BackgroundColor3 = UI.C.Raised
    local nameRow = UI.new("Frame", {LayoutOrder = 1, Size = UDim2.new(1, 0, 0, 38), BackgroundTransparency = 1}, panel)
    local field = UI.new("Frame", {Size = UDim2.new(1, -112, 1, 0), BackgroundColor3 = UI.C.Base, BorderSizePixel = 0}, nameRow); UI.round(field, 10); UI.stroke(field, 0.55)
    local box = UI.new("TextBox", {Position = UDim2.fromOffset(10, 0), Size = UDim2.new(1, -20, 1, 0), BackgroundTransparency = 1, Text = row.Name,
        PlaceholderText = "Skin name", PlaceholderColor3 = UI.C.Muted, TextColor3 = UI.C.Text, Font = UI.Font.Regular, TextSize = UI.size(13),
        TextXAlignment = Enum.TextXAlignment.Left, ClearTextOnFocus = false}, field)
    local rename = UI.button(nameRow, "Rename", false, function()
        local name = Looks.name(box.Text)
        if not name then App.report("Type a name to rename the skin.", "warning"); return end
        row.Name = name; row.Updated = os.time(); local persisted = App.persist(); UI.renderLooks()
        App.report(persisted and "Skin renamed." or "Name changed for this session only; the file could not be saved.", persisted and "success" or "warning")
    end, "pencil", "looks")
    rename.Root.Size = UDim2.fromOffset(104, 38); rename.Root.Position = UDim2.new(1, -104, 0, 0)
    local grid = UI.new("Frame", {LayoutOrder = 2, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1}, panel)
    local columns = UI.Compact and 2 or 3
    UI.new("UIGridLayout", {CellSize = UDim2.new(1 / columns, -6, 0, 38), CellPadding = UDim2.fromOffset(6, 6), SortOrder = Enum.SortOrder.LayoutOrder}, grid)
    local function action(order, text, icon, callback)
        local button = UI.button(grid, text, false, callback, icon, "looks"); button.Root.LayoutOrder = order
    end
    action(1, "Update", "refresh-cw", function() UI.captureLook(lp.Character, row.Key, row.Name) end)
    action(2, "Copy", "copy", function()
        if #Store.Looks >= 100 then App.report("Limit of 100 skins reached.", "warning"); return end
        local copy = {Key = HttpService:GenerateGUID(false), Name = Looks.name(row.Name .. " copy") or "Copy", Data = row.Data, Source = row.Source, Updated = os.time()}
        table.insert(Store.Looks, 1, copy); UI.SelectedLook = copy.Key
        local persisted = App.persist(); UI.renderLooks()
        App.report(persisted and "Skin duplicated." or "Copy created for this session only; the file could not be saved.", persisted and "success" or "warning")
    end)
    action(3, "Share", "share-2", function()
        local code = Looks.share(row); UI.ExportBox.Text = code
        local clipboard = type(setclipboard) == "function" and setclipboard or type(toclipboard) == "function" and toclipboard or nil
        if clipboard and pcall(clipboard, code) then App.report("Code copied. Send it to whoever you want to share it with.", "success")
        else App.report("Code generated in Share & import below. Select and copy it manually.", "info") end
    end)
    action(4, "Cycle", "plus", function()
        local entry = Store.entry({Kind = "Look", Key = row.Key, Name = row.Name})
        if UI.addCycle(entry) then App.persist(); App.report(row.Name .. " added to the avatar cycle.", "success")
        else App.report(#Store.Auto.List >= 50 and "The cycle list is full (50)." or "This skin is already in the cycle.", "warning") end
    end)
    action(5, "Delete", "trash-2", function()
        UI.confirm("Delete skin?", "The skin '" .. row.Name .. "' will be removed from the library.", function()
            local _, position = Looks.find(row.Key)
            if position then
                table.remove(Store.Looks, position); UI.SelectedLook = nil; UI.renderLooks()
                local persisted = App.persist()
                App.report(persisted and "Skin deleted." or "Deletion applies to this session only; the file could not be saved.", persisted and "success" or "warning")
            end
        end)
    end)
end
function UI.renderLooks()
    if not UI.LookList then return end
    UI.clearRows("looks", UI.LookList)
    if UI.SelectedLook and not Looks.find(UI.SelectedLook) then UI.SelectedLook = nil end
    local term = UI.LookSearch.Text:lower(); local count = 0
    for _, row in ipairs(Store.Looks) do
        if term == "" or row.Name:lower():find(term, 1, true) or row.Source:lower():find(term, 1, true) then
            count = count + 1
            UI.lookRow(row, count)
            if row.Key == UI.SelectedLook then UI.lookManage(row, count) end
        end
    end
    UI.LookCount.Text = (term ~= "" and (tostring(count) .. " found  ·  ") or "") .. tostring(#Store.Looks) .. "/100 saved  ·  tap the pencil to rename, update or share"
    if count == 0 then UI.emptyList(UI.LookList, term ~= "" and "No results" or "Your library is empty", term ~= "" and "Try another term." or "Build a skin in a Catalog Creator game, type a name above and tap Save.") end
end
function UI.buildLooks()
    local page = UI.page("Looks"); UI.stack(page, 8)
    local order = 0
    local function add(item) order = order + 1; item.LayoutOrder = order; return item end
    add(UI.section(page, "Catalog saves", "Skins you built in a Catalog Creator game. Tap Wear to put one on."))
    local capture = add(UI.card(page, 56))
    local nameFrame, name = UI.input(capture, "Name the skin you're wearing", "save")
    nameFrame.Position = UDim2.fromOffset(7, 7); nameFrame.Size = UDim2.new(1, -118, 0, 42); UI.LookName = name
    local save = UI.button(capture, "Save", true, function() UI.captureLook(lp.Character, nil, UI.LookName.Text) end, "save")
    save.Root.Position = UDim2.new(1, -105, 0, 7); save.Root.Size = UDim2.fromOffset(98, 42)
    local helpRow = add(UI.new("Frame", {Size = UDim2.new(1, 0, 0, 24), BackgroundTransparency = 1}, page))
    local helpLabel = UI.new("TextLabel", {Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.X, BackgroundTransparency = 1, RichText = true,
        Text = "<u>How it works</u>", TextColor3 = UI.C.Accent, Font = UI.Font.Bold, TextSize = UI.size(12), TextXAlignment = Enum.TextXAlignment.Left}, helpRow)
    local chevrons = UI.new("Frame", {Size = UDim2.fromOffset(18, 18), Position = UDim2.new(0, 0, 0.5, -9), BackgroundTransparency = 1}, helpRow)
    UI.new("UIScale", {Scale = 0.75}, chevrons)
    local expandIcon = UI.icon(chevrons, "chevron-down", UDim2.new(), UI.C.Accent)
    local collapseIcon = UI.icon(chevrons, "chevron-up", UDim2.new(), UI.C.Accent); collapseIcon.Visible = false
    local function placeChevron() chevrons.Position = UDim2.new(0, helpLabel.AbsoluteSize.X / (UI.CurrentScale or 1) + 4, 0.5, -9) end
    UI.connect(helpLabel:GetPropertyChangedSignal("AbsoluteSize"), placeChevron); task.defer(placeChevron)
    local help = UI.new("TextButton", {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "", AutoButtonColor = false, ZIndex = 3}, helpRow)
    local guide = add(UI.autoCard(page, 0, 6, 12)); guide.Visible = false
    for i, text in ipairs({"1. Join a Catalog Creator game and build the skin you want (clothes, accessories and body).",
        "2. Come back here, type a name above and tap Save while you are wearing it.",
        "3. Tap Wear on any saved skin to put it on. The pencil renames, updates, copies, shares or deletes it.",
        "Saved skins stay on this device. Profiles you star live in Favorites & Recent."}) do
        UI.paragraph(guide, text, i == 4 and 11 or 12, i == 4 and UI.C.Muted or UI.C.Text, false, i)
    end
    UI.connect(help.Activated, function()
        guide.Visible = not guide.Visible
        helpLabel.Text = guide.Visible and "<u>Hide how it works</u>" or "<u>How it works</u>"
        expandIcon.Visible = not guide.Visible; collapseIcon.Visible = guide.Visible
    end)
    local searchFrame, search = UI.input(page, "Search your saved skins"); add(searchFrame); UI.LookSearch = search
    UI.LookCount = add(UI.text(page, "", 11, UI.C.Muted)); UI.LookCount.Size = UDim2.new(1, 0, 0, 18)
    UI.LookList = add(UI.new("Frame", {Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1}, page)); UI.stack(UI.LookList, 6)
    add(UI.section(page, "Share & import", "Shared codes appear here. Paste a LYRA code or an old JSON backup to import it."))
    UI.ExportBox = add(UI.new("TextBox", {Size = UDim2.new(1, 0, 0, 58), BackgroundColor3 = UI.C.Card, BorderSizePixel = 0,
        Text = "", PlaceholderText = "Shared code will appear here", PlaceholderColor3 = UI.C.Muted, TextColor3 = UI.C.Text,
        TextSize = UI.size(12), Font = Enum.Font.Code, TextWrapped = true, MultiLine = true, ClearTextOnFocus = false, TextEditable = false,
        TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top}, page)); UI.round(UI.ExportBox, 12)
    UI.ImportBox = add(UI.new("TextBox", {Size = UDim2.new(1, 0, 0, 58), BackgroundColor3 = UI.C.Card, BorderSizePixel = 0,
        Text = "", PlaceholderText = "Paste a LYRA code or the old JSON here", PlaceholderColor3 = UI.C.Muted, TextColor3 = UI.C.Text,
        TextSize = UI.size(12), Font = Enum.Font.Code, TextWrapped = true, MultiLine = true, ClearTextOnFocus = false,
        TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top}, page)); UI.round(UI.ImportBox, 12)
    for _, box in ipairs({UI.ExportBox, UI.ImportBox}) do UI.new("UIPadding", {PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10), PaddingTop = UDim.new(0, 8), PaddingBottom = UDim.new(0, 8)}, box) end
    local import = UI.button(page, "Import code / JSON", true, function()
        local ok, row, persisted = pcall(Looks.import, UI.ImportBox.Text, UI.LookName.Text)
        if not ok then App.report(tostring(row), "error"); return end
        UI.ImportBox.Text = ""; UI.SelectedLook = row.Key; UI.renderLooks()
        App.report(persisted and "Skin imported into the library." or "Skin imported for this session only; the file could not be saved.", persisted and "success" or "warning")
    end, "download"); add(import.Root); import.Root.Size = UDim2.new(1, 0, 0, 42)
    UI.connect(search:GetPropertyChangedSignal("Text"), function() UI.scheduleList("looks") end)
    UI.renderLooks()
end

UI.CatalogView="Search"; UI.CatalogFilter="All"; UI.CatalogSub="All"; UI.CatalogSort="Popular"; UI.CatalogPrice="Any"; UI.CatalogCards={}; UI.CatalogCount=0
UI.CatalogGroups={{Label="Body & face",Max=19},{Label="Accessories",Max=29},{Label="Clothing",Max=39},{Label="Animations",Max=49},{Label="Other",Max=math.huge}}
function UI.catalogThumb(item)
    return "rbxthumb://type="..(item.Bundle and "BundleThumbnail" or "Asset").."&id="..tostring(item.Id).."&w=150&h=150"
end
function UI.catalogCaption(item)
    local kind=item.Bundle and (Catalog.BundleLabels[item.BundleKind] or "Bundle") or (item.Kind and item.Kind.Label) or "Item"
    if item.Limited then kind=kind.."  ·  Limited" end
    if item.Price==0 then return kind.."  ·  Free" elseif item.Price then return kind.."  ·  R$ "..tostring(item.Price) end
    return item.OffSale and (kind.."  ·  Off sale") or kind
end
function UI.catalogClear(key,container) UI.clearRows(key,container); UI.CatalogCards[key]={} end
function UI.catalogAction(parent,key,item)
    local button=UI.new("TextButton",{Size=UDim2.fromScale(1,1),Text="",AutoButtonColor=false,BorderSizePixel=0,BackgroundColor3=UI.C.Accent},parent); UI.round(button,10)
    local label=UI.text(button,"",12,UI.C.Base,true); label.Size=UDim2.fromScale(1,1); label.TextXAlignment=Enum.TextXAlignment.Center
    local entry={Root=button,Label=label,Item=item}
    function entry.update()
        local worn=not item.Bundle and Catalog.worn()[item.Id]~=nil
        entry.Worn=worn
        if entry.Badge then entry.Badge.Visible=worn end
        local idle=not App.Busy and not UI.CatalogPending
        if item.Bundle then label.Text="View parts"
        elseif item.Unwearable then label.Text="Not wearable"
        else label.Text=worn and "Remove" or "Add" end
        local primary=not item.Bundle and not worn and not item.Unwearable
        button.BackgroundColor3=primary and UI.C.Accent or UI.C.Raised
        label.TextColor3=primary and UI.C.Base or (worn and UI.C.Red or UI.C.Text)
        button.Active=item.Bundle or (idle and not item.Unwearable)
        label.TextTransparency=button.Active and 0 or 0.5
        button.BackgroundTransparency=button.Active and 0 or 0.45
    end
    UI.rowConnect(key,button.Activated,function()
        if not button.Active then return end
        if item.Bundle then UI.openBundle(item) else UI.catalogRun({item},entry.Worn) end
    end)
    table.insert(UI.CatalogCards[key],entry)
    entry.update(); return entry
end
function UI.catalogRun(items,remove,context)
    if App.Busy or UI.CatalogPending then App.report("Wait for the current change to finish.","warning"); return end
    UI.CatalogPending=true; UI.refreshCatalog()
    task.spawn(function()
        local ok,err=pcall(Catalog.edit,items,remove,context)
        if not ok then App.report(tostring(err),"error") end
        UI.CatalogPending=nil
        if App.alive() then UI.refreshCatalog() end
    end)
end
function UI.catalogCard(item,index)
    local card=UI.new("Frame",{LayoutOrder=index,BackgroundColor3=UI.C.Card,BackgroundTransparency=0.22,BorderSizePixel=0},UI.CatalogGrid); UI.round(card,14); UI.stroke(card,0.55)
    local thumb=UI.new("TextButton",{Position=UDim2.fromOffset(8,8),Size=UDim2.new(1,-16,0,96),BackgroundColor3=UI.C.Raised,Text="",AutoButtonColor=false,BorderSizePixel=0,ClipsDescendants=true},card); UI.round(thumb,10)
    UI.new("ImageLabel",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,BorderSizePixel=0,ScaleType=Enum.ScaleType.Fit,Image=UI.catalogThumb(item)},thumb)
    if item.Bundle then
        local tag=UI.text(thumb,"BUNDLE",9,UI.C.Base,true); tag.AutomaticSize=Enum.AutomaticSize.X; tag.Size=UDim2.fromOffset(0,18); tag.Position=UDim2.fromOffset(6,6)
        tag.BackgroundTransparency=0; tag.BackgroundColor3=UI.C.Accent; UI.round(tag,9); UI.new("UIPadding",{PaddingLeft=UDim.new(0,7),PaddingRight=UDim.new(0,7)},tag)
        UI.rowConnect("catalog",thumb.Activated,function() UI.openBundle(item) end)
    end
    local badge=UI.new("Frame",{AnchorPoint=Vector2.new(1,0),Position=UDim2.new(1,-6,0,6),Size=UDim2.fromOffset(24,24),BackgroundColor3=UI.C.Green,BorderSizePixel=0,Visible=false},thumb); UI.round(badge,12)
    Toast.glyph(badge,"check",UI.C.Base)
    local name=UI.text(card,item.Name,12,nil,true); name.Position=UDim2.fromOffset(10,110); name.Size=UDim2.new(1,-20,0,32); name.TextWrapped=true; name.TextYAlignment=Enum.TextYAlignment.Top
    local caption=UI.text(card,UI.catalogCaption(item),10,UI.C.Muted); caption.Position=UDim2.fromOffset(10,142); caption.Size=UDim2.new(1,-20,0,16)
    local holder=UI.new("Frame",{Position=UDim2.new(0,8,1,-42),Size=UDim2.new(1,-16,0,34),BackgroundTransparency=1},card)
    local entry=UI.catalogAction(holder,"catalog",item); entry.Badge=badge; entry.update()
end
-- Whole-pixel cells: scale-based cells can round a column onto the next row.
function UI.catalogColumns()
    if not UI.CatalogGridLayout then return end
    local scale=UI.WindowScale.Scale>0 and UI.WindowScale.Scale or 1
    local width=math.floor(UI.CatalogGrid.AbsoluteSize.X/scale)
    if width<=0 then return end
    local columns=math.clamp(math.floor((width+8)/158),2,6)
    local cell=math.floor((width-8*(columns-1))/columns)
    if columns==UI.CatalogColumns and cell==UI.CatalogCell then return end
    UI.CatalogColumns=columns; UI.CatalogCell=cell
    UI.CatalogGridLayout.FillDirectionMaxCells=columns
    UI.CatalogGridLayout.CellSize=UDim2.fromOffset(cell,200)
end
function UI.catalogChips()
    for name,chip in pairs(UI.CatalogChips) do
        local selected=name==UI.CatalogFilter
        chip.BackgroundColor3=selected and UI.C.AccentDark or UI.C.Raised; chip.TextColor3=selected and UI.C.Text or UI.C.Muted
    end
end
function UI.catalogSubs()
    local list=Catalog.Subs[UI.CatalogFilter]
    UI.clearRows("catalogSub",UI.CatalogSubRow)
    UI.CatalogSubRow.Visible=list~=nil
    if not list then return end
    for index,name in ipairs(list) do
        local selected=name==UI.CatalogSub
        local chip=UI.new("TextButton",{LayoutOrder=index,Size=UDim2.fromOffset(0,30),AutomaticSize=Enum.AutomaticSize.X,Text=Catalog.SubLabels[name] or name,Font=UI.Font.Bold,
            TextSize=UI.size(11),TextColor3=selected and UI.C.Text or UI.C.Muted,BackgroundColor3=selected and UI.C.AccentDark or UI.C.Raised,AutoButtonColor=false,BorderSizePixel=0},UI.CatalogSubRow)
        UI.round(chip,15); UI.new("UIPadding",{PaddingLeft=UDim.new(0,12),PaddingRight=UDim.new(0,12)},chip)
        UI.rowConnect("catalogSub",chip.Activated,function() if UI.CatalogSub~=name then UI.CatalogSub=name; UI.catalogSubs(); UI.catalogSearch(false) end end)
    end
end
function UI.catalogSearch(more)
    local query=UI.CatalogQuery
    if more then
        if not query or query.Loading or query.Finished then return end
    else
        query={Keyword=UI.CatalogBox.Text:match("^%s*(.-)%s*$"):sub(1,50),Category=UI.CatalogFilter,Sub=UI.CatalogSub,Sort=UI.CatalogSort,Price=UI.CatalogPrice}
        UI.CatalogQuery=query; UI.closeBundle()
        UI.catalogClear("catalog",UI.CatalogGrid); UI.CatalogCount=0
    end
    query.Loading=true; UI.CatalogMore.Root.Visible=false
    UI.CatalogStatus.Text=more and "Loading more…" or "Searching the Roblox catalog…"; UI.CatalogStatus.TextColor3=UI.C.Muted
    task.spawn(function()
        local ok,items=pcall(Catalog.search,query,more)
        if not App.alive() or UI.CatalogQuery~=query then return end
        query.Loading=false
        if not ok then
            UI.CatalogStatus.Text=tostring(items); UI.CatalogStatus.TextColor3=UI.C.Red
            UI.CatalogMore.Root.Visible=UI.CatalogCount>0 and not query.Finished and not UI.CatalogBundleItem
            return
        end
        for _,item in ipairs(items) do UI.CatalogCount=UI.CatalogCount+1; UI.catalogCard(item,UI.CatalogCount) end
        UI.catalogColumns()
        local sort=Catalog.option(Catalog.Sorts,query.Sort).Label
        UI.CatalogStatus.Text=UI.CatalogCount==0 and "Nothing found. Try another name, filter or price."
            or (sort.."  ·  "..tostring(UI.CatalogCount).." items"..(query.Keyword~="" and (" for \""..query.Keyword.."\"") or "").."  ·  tap a BUNDLE to pick its parts")
        UI.CatalogMore.Root.Visible=not query.Finished and not UI.CatalogBundleItem
    end)
end
function UI.catalogItemRow(parent,order,item,title,detail,key)
    local row=UI.card(parent,58); row.LayoutOrder=order
    local frame=UI.new("Frame",{Position=UDim2.fromOffset(8,8),Size=UDim2.fromOffset(42,42),BackgroundColor3=UI.C.Raised,BorderSizePixel=0,ClipsDescendants=true},row); UI.round(frame,10)
    UI.new("ImageLabel",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,BorderSizePixel=0,ScaleType=Enum.ScaleType.Fit,Image=UI.catalogThumb(item)},frame)
    local buttonWidth=UI.Compact and 86 or 104
    local name=UI.text(row,title,13,nil,true); name.Position=UDim2.fromOffset(60,9); name.Size=UDim2.new(1,-(78+buttonWidth),0,20)
    local sub=UI.text(row,detail,11,UI.C.Muted); sub.Position=UDim2.fromOffset(60,30); sub.Size=UDim2.new(1,-(78+buttonWidth),0,18)
    local holder=UI.new("Frame",{Position=UDim2.new(1,-(buttonWidth+10),0.5,-18),Size=UDim2.fromOffset(buttonWidth,36),BackgroundTransparency=1},row)
    UI.catalogAction(holder,key,item)
    return row,sub
end
function UI.openBundle(item)
    UI.CatalogBundleItem=item; UI.CatalogBundleData=nil
    UI.CatalogBundleToken=(UI.CatalogBundleToken or 0)+1; local token=UI.CatalogBundleToken
    UI.catalogClear("catalogBundle",UI.CatalogBundleBody)
    UI.CatalogGrid.Visible=false; UI.CatalogMore.Root.Visible=false; UI.CatalogBundle.Visible=true
    UI.CatalogPage.CanvasPosition=Vector2.zero
    local body=UI.CatalogBundleBody
    local backRow=UI.new("Frame",{LayoutOrder=1,Size=UDim2.new(1,0,0,40),BackgroundTransparency=1},body)
    local back=UI.button(backRow,"Back to results",false,UI.closeBundle,"arrow","catalogBundle"); back.Root.Size=UDim2.fromOffset(176,40)
    if back.Icon then back.Icon.Rotation=180 end
    local head=UI.new("Frame",{LayoutOrder=2,Size=UDim2.new(1,0,0,64),BackgroundTransparency=1},body)
    local frame=UI.new("Frame",{Size=UDim2.fromOffset(64,64),BackgroundColor3=UI.C.Raised,BorderSizePixel=0,ClipsDescendants=true},head); UI.round(frame,12)
    UI.new("ImageLabel",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,BorderSizePixel=0,ScaleType=Enum.ScaleType.Fit,Image=UI.catalogThumb(item)},frame)
    local title=UI.text(head,item.Name,15,nil,true); title.Position=UDim2.fromOffset(76,8); title.Size=UDim2.new(1,-76,0,22)
    local caption=UI.text(head,(Catalog.BundleLabels[item.BundleKind] or "Bundle").."  ·  loading parts…",11,UI.C.Muted); caption.Position=UDim2.fromOffset(76,32); caption.Size=UDim2.new(1,-76,0,18)
    local actions=UI.new("Frame",{LayoutOrder=3,Size=UDim2.new(1,0,0,42),BackgroundTransparency=1},body)
    local context={Id=item.Id,Name=item.Name,Bundle=true}
    UI.BundleAddAll=UI.button(actions,"Add all",true,function()
        local bundle=UI.CatalogBundleData; if not bundle then return end
        local worn,list=Catalog.worn(),{}
        for _,part in ipairs(bundle.Parts) do if not worn[part.Id] then table.insert(list,part) end end
        if #list>0 then UI.catalogRun(list,false,context) end
    end,"plus","catalogBundle"); UI.BundleAddAll.Root.Size=UDim2.new(0.5,-4,1,0)
    UI.BundleRemoveAll=UI.button(actions,"Remove all",false,function()
        local bundle=UI.CatalogBundleData; if not bundle then return end
        local worn,list=Catalog.worn(),{}
        for _,part in ipairs(bundle.Parts) do if worn[part.Id] then table.insert(list,part) end end
        if #list>0 then UI.catalogRun(list,true,context) end
    end,"trash-2","catalogBundle"); UI.BundleRemoveAll.Root.Position=UDim2.new(0.5,4,0,0); UI.BundleRemoveAll.Root.Size=UDim2.new(0.5,-4,1,0)
    UI.enabled(UI.BundleAddAll,false); UI.enabled(UI.BundleRemoveAll,false)
    UI.paragraph(body,"Add every part at once, or tap Add on just the parts you want. A removed body part goes back to the default Roblox shape.",11,UI.C.Muted,false,4)
    local list=UI.new("Frame",{LayoutOrder=5,Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1},body); UI.stack(list,6)
    task.spawn(function()
        local ok,bundle=pcall(Catalog.bundle,item.Id)
        if not App.alive() or token~=UI.CatalogBundleToken then return end
        if not ok then caption.Text=tostring(bundle); caption.TextColor3=UI.C.Red; return end
        UI.CatalogBundleData=bundle
        caption.Text=(Catalog.BundleLabels[item.BundleKind] or "Bundle").."  ·  "..tostring(#bundle.Parts)..(#bundle.Parts==1 and " part" or " parts")
        for index,part in ipairs(bundle.Parts) do UI.catalogItemRow(list,index,part,part.Kind and part.Kind.Label or "Item",part.Name,"catalogBundle") end
        if #bundle.Parts==0 then UI.emptyList(list,"No wearable parts","This bundle has no items that can be added to an avatar.") end
        UI.refreshCatalog()
    end)
end
function UI.closeBundle()
    UI.CatalogBundleToken=(UI.CatalogBundleToken or 0)+1
    UI.CatalogBundleItem=nil; UI.CatalogBundleData=nil; UI.BundleAddAll=nil; UI.BundleRemoveAll=nil
    UI.catalogClear("catalogBundle",UI.CatalogBundleBody)
    UI.CatalogBundle.Visible=false; UI.CatalogGrid.Visible=true
    local query=UI.CatalogQuery
    UI.CatalogMore.Root.Visible=query~=nil and not query.Finished and not query.Loading and UI.CatalogCount>0
end
function UI.catalogWho(base)
    local userId=base and (base.Id or base.ThumbId) or lp.UserId
    UI.CatalogWhoThumb.Image="rbxthumb://type=AvatarHeadShot&id="..tostring(userId).."&w=150&h=150"
    local name="your own avatar"
    if base and not base.Original then name=(tostring(base.Name or "this avatar"):gsub(" %(edited%)$","")) end
    UI.CatalogWhoTitle.Text="Customizing "..name
end
function UI.renderWearing()
    if not UI.CatalogWearList then return end
    local base=Catalog.base(); UI.CatalogWornFor=base
    UI.catalogWho(base)
    UI.catalogClear("catalogWear",UI.CatalogWearList)
    local rows={}
    for id,slot in pairs(Catalog.worn()) do
        local label,rank=Catalog.slotLabel(slot)
        table.insert(rows,{Id=id,Label=label,Rank=rank})
    end
    table.sort(rows,function(a,b) if a.Rank~=b.Rank then return a.Rank<b.Rank end return a.Id<b.Id end)
    local note=base and type(base.Data)=="table" and base.Data.Visual and "  ·  editing this saved skin rebuilds it from its items" or ""
    UI.CatalogWearCount.Text=tostring(#rows)..(#rows==1 and " item" or " items").." on your current appearance"..note
    local order,group=0,nil
    for _,row in ipairs(rows) do
        local current
        for _,candidate in ipairs(UI.CatalogGroups) do if row.Rank<=candidate.Max then current=candidate; break end end
        if current~=group then
            group=current; order=order+1
            local header=UI.text(UI.CatalogWearList,string.upper(current.Label),10,UI.C.Accent,true); header.LayoutOrder=order; header.Size=UDim2.new(1,0,0,22)
        end
        order=order+1
        local _,sub=UI.catalogItemRow(UI.CatalogWearList,order,{Id=row.Id},row.Label,"ID "..tostring(row.Id),"catalogWear")
        task.spawn(function()
            local info=Catalog.info(row.Id)
            if info and type(info.Name)=="string" and sub.Parent then sub.Text=info.Name end
        end)
    end
    if #rows==0 then UI.emptyList(UI.CatalogWearList,"No catalog items","Add items from Search and they will be listed here.") end
end
function UI.catalogUndoBar()
    local bar=UI.CatalogUndo
    if not bar then return end
    local current=App.Current
    local change=current and current.Change
    bar.Visible=change~=nil and #App.History>0
    if not bar.Visible then return end
    if UI.CatalogUndoFor~=current then
        UI.CatalogUndoFor=current
        UI.CatalogUndoThumb.Image=UI.catalogThumb({Id=change.Id,Bundle=change.Bundle})
        UI.CatalogUndoText.Text=change.Text
    end
    UI.enabled(UI.CatalogUndoButton,not App.Busy and not UI.CatalogPending)
end
function UI.refreshCatalog()
    if not UI.CatalogPage then return end
    for _,group in pairs(UI.CatalogCards) do for _,entry in ipairs(group) do if entry.Root.Parent then entry.update() end end end
    if UI.CatalogView=="Wearing" and UI.CatalogWornFor~=Catalog.base() then UI.renderWearing() end
    UI.catalogUndoBar()
    local bundle=UI.CatalogBundleData
    if bundle and UI.BundleAddAll then
        local worn,missing,wearing=Catalog.worn(),0,0
        for _,part in ipairs(bundle.Parts) do if worn[part.Id] then wearing=wearing+1 else missing=missing+1 end end
        local idle=not App.Busy and not UI.CatalogPending
        UI.enabled(UI.BundleAddAll,idle and missing>0); UI.enabled(UI.BundleRemoveAll,idle and wearing>0)
        UI.BundleAddAll.Label.Text=missing>0 and ("Add all ("..tostring(missing)..")") or "All added"
    end
end
function UI.renderCatalog()
    if not UI.CatalogPage then return end
    local search=UI.CatalogView=="Search"
    UI.CatalogSearchView.Visible=search; UI.CatalogWearView.Visible=not search
    UI.tween(UI.CatSearchTab.Root,{BackgroundColor3=search and UI.C.AccentDark or UI.C.Raised})
    UI.tween(UI.CatWearTab.Root,{BackgroundColor3=not search and UI.C.AccentDark or UI.C.Raised})
    UI.catalogChips()
    if search then
        if not UI.CatalogQuery then UI.catalogSearch(false) end
        UI.catalogColumns()
    else UI.renderWearing() end
    UI.refreshCatalog()
end
function UI.openCustomize()
    UI.CatalogView="Wearing"; UI.selectTab("Catalog")
end
function UI.buildCatalog()
    local page=UI.page("Catalog"); UI.stack(page,8); UI.CatalogPage=page
    local order=0
    local function add(item) order=order+1; item.LayoutOrder=order; return item end
    add(UI.section(page,"Roblox Shop","Try items from the Roblox catalog on the avatar you are wearing. Add puts an item on, Remove takes it off. Only you see the change."))
    local tabs=add(UI.new("Frame",{Size=UDim2.new(1,0,0,44),BackgroundTransparency=1},page))
    UI.CatSearchTab=UI.button(tabs,"Search",false,function() UI.CatalogView="Search"; UI.renderCatalog() end,"search"); UI.CatSearchTab.Root.Size=UDim2.new(0.5,-6,1,0)
    UI.CatWearTab=UI.button(tabs,"Wearing",false,function() UI.CatalogView="Wearing"; UI.renderCatalog() end,"shirt"); UI.CatWearTab.Root.Position=UDim2.new(0.5,6,0,0); UI.CatWearTab.Root.Size=UDim2.new(0.5,-6,1,0)

    UI.CatalogUndo=add(UI.card(page,62)); UI.CatalogUndo.Visible=false
    local undoStroke=UI.CatalogUndo:FindFirstChildOfClass("UIStroke"); undoStroke.Color=UI.C.Accent; undoStroke.Transparency=0.45
    local undoFrame=UI.new("Frame",{Position=UDim2.fromOffset(9,9),Size=UDim2.fromOffset(44,44),BackgroundColor3=UI.C.Raised,BorderSizePixel=0,ClipsDescendants=true},UI.CatalogUndo); UI.round(undoFrame,10)
    UI.CatalogUndoThumb=UI.new("ImageLabel",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,BorderSizePixel=0,ScaleType=Enum.ScaleType.Fit},undoFrame)
    UI.CatalogUndoText=UI.text(UI.CatalogUndo,"",13,nil,true); UI.CatalogUndoText.Position=UDim2.fromOffset(62,10); UI.CatalogUndoText.Size=UDim2.new(1,-180,0,20)
    local undoHint=UI.text(UI.CatalogUndo,"Undo puts your avatar back to how it was before.",11,UI.C.Muted); undoHint.Position=UDim2.fromOffset(62,31); undoHint.Size=UDim2.new(1,-180,0,18)
    UI.CatalogUndoButton=UI.button(UI.CatalogUndo,"Undo",false,function() App.undo() end,"undo"); UI.CatalogUndoButton.Root.Size=UDim2.fromOffset(104,40); UI.CatalogUndoButton.Root.Position=UDim2.new(1,-114,0.5,-20)

    UI.CatalogSearchView=add(UI.new("Frame",{Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1},page)); UI.stack(UI.CatalogSearchView,8)
    local input,box=UI.input(UI.CatalogSearchView,"Search by name or item ID, e.g. Korblox"); input.LayoutOrder=1; UI.CatalogBox=box
    box.Size=UDim2.new(1,-108,1,0)
    local go=UI.button(input,"",false,function() UI.catalogSearch(false) end,"arrow"); go.Root.Size=UDim2.fromOffset(38,34); go.Root.Position=UDim2.new(1,-42,0.5,-17)
    UI.connect(box.FocusLost,function(enter) if enter then UI.catalogSearch(false) end end)
    local chips=UI.new("ScrollingFrame",{LayoutOrder=2,Size=UDim2.new(1,0,0,36),BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=0,
        ScrollingDirection=Enum.ScrollingDirection.X,CanvasSize=UDim2.new(),AutomaticCanvasSize=Enum.AutomaticSize.X,ElasticBehavior=Enum.ElasticBehavior.Never},UI.CatalogSearchView)
    UI.new("UIListLayout",{FillDirection=Enum.FillDirection.Horizontal,SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,6)},chips)
    UI.CatalogChips={}
    for index,name in ipairs(Catalog.Filters) do
        local chip=UI.new("TextButton",{LayoutOrder=index,Size=UDim2.fromOffset(0,34),AutomaticSize=Enum.AutomaticSize.X,Text=name,Font=UI.Font.Bold,TextSize=UI.size(12),
            TextColor3=UI.C.Muted,BackgroundColor3=UI.C.Raised,AutoButtonColor=false,BorderSizePixel=0},chips); UI.round(chip,17)
        UI.new("UIPadding",{PaddingLeft=UDim.new(0,14),PaddingRight=UDim.new(0,14)},chip)
        UI.CatalogChips[name]=chip
        UI.connect(chip.Activated,function() if UI.CatalogFilter~=name then UI.CatalogFilter=name; UI.CatalogSub="All"; UI.catalogChips(); UI.catalogSubs(); UI.catalogSearch(false) end end)
    end
    UI.CatalogSubRow=UI.new("ScrollingFrame",{LayoutOrder=3,Size=UDim2.new(1,0,0,34),BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=0,
        ScrollingDirection=Enum.ScrollingDirection.X,CanvasSize=UDim2.new(),AutomaticCanvasSize=Enum.AutomaticSize.X,ElasticBehavior=Enum.ElasticBehavior.Never,Visible=false},UI.CatalogSearchView)
    UI.new("UIListLayout",{FillDirection=Enum.FillDirection.Horizontal,SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,6)},UI.CatalogSubRow)
    local filters=UI.new("Frame",{LayoutOrder=4,Size=UDim2.new(1,0,0,40),BackgroundTransparency=1},UI.CatalogSearchView)
    local sort=UI.dropdown(filters,Catalog.Sorts,function() return UI.CatalogSort end,function(value) UI.CatalogSort=value; UI.catalogSearch(false) end)
    sort.Root.Size=UDim2.new(0.5,-4,1,0)
    local price=UI.dropdown(filters,Catalog.Prices,function() return UI.CatalogPrice end,function(value) UI.CatalogPrice=value; UI.catalogSearch(false) end)
    price.Root.Position=UDim2.new(0.5,4,0,0); price.Root.Size=UDim2.new(0.5,-4,1,0)
    UI.CatalogStatus=UI.text(UI.CatalogSearchView,"",11,UI.C.Muted); UI.CatalogStatus.LayoutOrder=5; UI.CatalogStatus.Size=UDim2.new(1,0,0,20)
    UI.CatalogBundle=UI.autoCard(UI.CatalogSearchView,6,0,12); UI.CatalogBundle.Visible=false
    UI.CatalogBundleBody=UI.new("Frame",{Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1},UI.CatalogBundle); UI.stack(UI.CatalogBundleBody,10)
    UI.CatalogGrid=UI.new("Frame",{LayoutOrder=7,Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1},UI.CatalogSearchView)
    UI.CatalogGridLayout=UI.new("UIGridLayout",{CellSize=UDim2.fromOffset(150,200),CellPadding=UDim2.fromOffset(8,8),SortOrder=Enum.SortOrder.LayoutOrder},UI.CatalogGrid)
    UI.connect(UI.CatalogGrid:GetPropertyChangedSignal("AbsoluteSize"),UI.catalogColumns)
    UI.CatalogMore=UI.button(UI.CatalogSearchView,"Load more",false,function() UI.catalogSearch(true) end,"chevron-down"); UI.CatalogMore.Root.LayoutOrder=8; UI.CatalogMore.Root.Visible=false

    UI.CatalogWearView=add(UI.new("Frame",{Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,Visible=false},page)); UI.stack(UI.CatalogWearView,6)
    local who=UI.card(UI.CatalogWearView,64); who.LayoutOrder=1
    UI.CatalogWhoThumb=UI.new("ImageLabel",{Position=UDim2.fromOffset(10,10),Size=UDim2.fromOffset(44,44),BackgroundColor3=UI.C.Raised,BorderSizePixel=0},who); UI.round(UI.CatalogWhoThumb,12)
    UI.CatalogWhoTitle=UI.text(who,"Customizing your own avatar",13,nil,true); UI.CatalogWhoTitle.Position=UDim2.fromOffset(64,11); UI.CatalogWhoTitle.Size=UDim2.new(1,-74,0,20)
    local whoHint=UI.text(who,"Remove what you don't want here, then add new items from Search.",11,UI.C.Muted); whoHint.Position=UDim2.fromOffset(64,32); whoHint.Size=UDim2.new(1,-74,0,18)
    UI.CatalogWearCount=UI.text(UI.CatalogWearView,"",11,UI.C.Muted); UI.CatalogWearCount.LayoutOrder=2; UI.CatalogWearCount.Size=UDim2.new(1,0,0,20)
    UI.CatalogWearList=UI.new("Frame",{LayoutOrder=3,Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1},UI.CatalogWearView); UI.stack(UI.CatalogWearList,6)
    for key,container in pairs({catalog=UI.CatalogGrid,catalogBundle=UI.CatalogBundleBody,catalogWear=UI.CatalogWearList}) do UI.catalogClear(key,container) end
end

function UI.toggle(parent,title,description,key,onChange,store)
    store=store or Store.Settings
    local card=UI.controlCard(parent,title,description,58)
    local button=UI.new("TextButton",{Position=UDim2.new(1,-62,0.5,-15),Size=UDim2.fromOffset(50,30),Text="",AutoButtonColor=false,BackgroundColor3=UI.C.Raised,BorderSizePixel=0},card); UI.round(button,30)
    local knob=UI.new("Frame",{Position=UDim2.fromOffset(4,4),Size=UDim2.fromOffset(22,22),BackgroundColor3=UI.C.Text,BorderSizePixel=0},button); UI.round(knob,22)
    local function refresh()
        local val=store[key]
        UI.tween(button,{BackgroundColor3=val and UI.C.AccentDark or UI.C.Raised})
        UI.tween(knob,{Position=UDim2.fromOffset(val and 24 or 4,4),BackgroundColor3=val and UI.C.Text or UI.C.Muted})
    end
    UI.connect(button.Activated,function() store[key]=not store[key]; refresh(); if onChange then onChange(store[key]) end; App.persist() end)
    UI.Toggles=UI.Toggles or {}; UI.Toggles[(store==Store.Auto and "Auto." or "")..key]=refresh
    refresh(); return card
end
function UI.reopenCard(parent)
    local card=UI.autoCard(parent,0,6,14)
    UI.ReopenRows={}
    for index=1,4 do
        local row=UI.new("Frame",{LayoutOrder=index,Size=UDim2.new(1,0,0,22),BackgroundTransparency=1},card)
        local name=UI.text(row,"",12,UI.C.Text,true); name.Size=UDim2.new(0.58,0,1,0)
        local state=UI.text(row,"",12,UI.C.Muted,true); state.Position=UDim2.new(0.58,0,0,0); state.Size=UDim2.new(0.42,0,1,0); state.TextXAlignment=Enum.TextXAlignment.Right
        UI.ReopenRows[index]={Name=name,State=state}
    end
    UI.ReopenWarning=UI.paragraph(card,"",11,UI.C.Gold,true,10)
    return card
end
function UI.refreshReopenCard()
    if not UI.ReopenRows then return end
    local orb,menu,keyboard=Store.Settings.MobileOrb==true,Store.Settings.MenuReopen==true,UIS.KeyboardEnabled
    local chat=UI.ChatOK==false and {"Blocked on this account",UI.C.Gold} or UI.ChatOK==true and {"Ready",UI.C.Green} or UI.ChatChecked and {"Not detected",UI.C.Muted} or {"Checking…",UI.C.Muted}
    local rows={
        {"Floating button",orb and "On" or "Off",orb and UI.C.Green or UI.C.Muted},
        {"Roblox menu shortcut",menu and "On" or "Off",menu and UI.C.Green or UI.C.Muted},
        {"Shortcut key ("..Store.Settings.Keybind..")",keyboard and "Ready" or "No keyboard",keyboard and UI.C.Green or UI.C.Gold},
        {"Chat  /e copier",chat[1],chat[2]},
    }
    for index,row in ipairs(rows) do
        local entry=UI.ReopenRows[index]
        entry.Name.Text=row[1]; entry.State.Text=row[2]; entry.State.TextColor3=row[3]
    end
    UI.ReopenWarning.Text=UI.canReopen() and "" or "Nothing can reopen the window right now. Turn on the floating button or the Roblox menu shortcut."
    UI.ReopenWarning.Visible=not UI.canReopen()
end
function UI.collapsible(parent)
    local holder=UI.new("Frame",{Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1},parent)
    UI.stack(holder,6)
    local body=UI.new("Frame",{LayoutOrder=2,Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,Visible=false},holder)
    UI.stack(body,6)
    local head
    head=UI.button(holder,"Show advanced options",false,function()
        body.Visible=not body.Visible
        head.Label.Text=body.Visible and "Hide advanced options" or "Show advanced options"
        if head.Icon then head.Icon.Rotation=body.Visible and 180 or 0 end
    end,"chevron-down")
    head.Root.LayoutOrder=1
    return holder,body
end
function UI.buildSettings()
    local page=UI.page("Settings"); UI.stack(page,6)
    local order=0
    local function add(item) order=order+1; item.LayoutOrder=order; return item end
    add(UI.section(page,"Settings","The defaults work for most people. Change only what you need."))
    add(UI.stepper(page,"Interface size","Makes the window and its text smaller or larger. Auto fits your screen.","UIScale",
        {0,70,75,80,85,90,95,100,105,110,115,120,130},function(value) return value==0 and "Auto" or (tostring(value).."%") end,Store.Settings,function() UI.layout(false) end))
    local sizeCard=add(UI.controlCard(page,"Window size","Drag the corner at the bottom right of the window to resize it. Reset restores the default size.",96))
    local resetSize=UI.button(sizeCard,"Reset",false,function()
        Store.Settings.WindowW=0; Store.Settings.WindowH=0; Store.Settings.UIScale=85; UI.Maximized=false
        if UI.Steppers and UI.Steppers.UIScale then UI.Steppers.UIScale() end
        App.persist(); UI.layout(true); App.report("Window size and interface size reset.","info")
    end,"reset"); resetSize.Root.Size=UDim2.fromOffset(96,38); resetSize.Root.Position=UDim2.new(1,-108,0.5,-19)
    add(UI.section(page,"Avatar"))
    add(UI.toggle(page,"Copy animations","Also copy the avatar's idle, walk, run and jump animations.","CopyAnims"))
    add(UI.toggle(page,"Keep avatar after respawn","Puts your avatar back on when you respawn.","AutoReapply"))
    add(UI.toggle(page,"See other script users' skins","Script users in your server see each other's skins. Your skin is shared with them while this is on.","SkinSync",function(on) if on then Sync.wake() else Sync.stop() end end))
    add(UI.section(page,"Notifications"))
    add(UI.toggle(page,"Show notifications","Small pop-ups in the bottom-right corner, such as avatar cycle switches. Turn off to hide them all.","Notifications",function(on) if not on and UI.Toasts then UI.Toasts:Clear() end end))
    add(UI.section(page,"Open & close"))
    add(UI.toggle(page,"Start hidden","The window stays closed when the script runs. It is skipped if nothing could reopen the window.","StartHidden"))
    add(UI.section(page,"How to reopen the window","Keep at least one on, so the window can always come back."))
    add(UI.reopenCard(page))
    add(UI.toggle(page,"Floating button","Shows a draggable button while the window is closed.","MobileOrb",function() UI.effects(); UI.refreshReopenCard() end))
    add(UI.toggle(page,"Reopen with the Roblox menu","While the window is hidden, open and close the Roblox menu 3 times in a row (Esc on PC, the Roblox logo on phones). Works without chat.","MenuReopen",UI.refreshReopenCard))
    local keyCard=add(UI.controlCard(page,"Hub shortcut","Tap, then press a key to change it. Esc cancels.",130))
    UI.KeyButton=UI.button(keyCard,Store.Settings.Keybind,false,function()
        UI.CapturingKey=true; UI.KeyButton.Label.Text="Press a key…"
        UI.KeyCaptureToken=(UI.KeyCaptureToken or 0)+1; local token=UI.KeyCaptureToken
        task.delay(10,function() if App.alive() and token==UI.KeyCaptureToken and UI.CapturingKey then UI.CapturingKey=false; UI.KeyButton.Label.Text=Store.Settings.Keybind end end)
    end); UI.KeyButton.Root.Size=UDim2.fromOffset(124,38); UI.KeyButton.Root.Position=UDim2.new(1,-136,0.5,-19)
    local advHolder,adv=UI.collapsible(page); add(advHolder)
    local advOrder=0
    local function addAdv(item) advOrder=advOrder+1; item.LayoutOrder=advOrder; return item end
    addAdv(UI.section(adv,"Avatar"))
    addAdv(UI.toggle(adv,"Keep avatar between rounds","Puts your avatar items back if the game removes them when a round starts.","MapPersist",function() Store.sync(); Repair.resume() end))
    addAdv(UI.toggle(adv,"Reset character first","Respawns you before applying, which gives the cleanest result.","AutoReset"))
    addAdv(UI.toggle(adv,"Visual-only avatar","Draws the avatar over your character instead of changing it. Use it in games where applying breaks movement. Always on in Evade.","VisualOnly",function() App.report("Applies the next time you wear an avatar.","info") end))
    addAdv(UI.toggle(adv,"Glow when avatar changes","A short glow when your avatar changes. Only you can see it.","SwapEffect"))
    addAdv(UI.toggle(adv,"Show my avatar in the Roblox menu","Your picture in the Players tab of the Roblox menu shows the avatar you are wearing. Only you see it.","MenuAvatar",function(on) if not on then pcall(UI.clearMenuAvatar) end end))
    addAdv(UI.section(adv,"Effects"))
    addAdv(UI.toggle(adv,"Background blur","Blurs the game behind the window.","GlassBlur",UI.effects))
    addAdv(UI.toggle(adv,"Reduced motion","Turns off window animations.","ReducedMotion",UI.effects))
    addAdv(UI.toggle(adv,"Performance mode","Turns off extra visual effects. Helps on slower devices.","LowEffects",UI.effects))
    UI.refreshReopenCard()
end

UI.AutoLabels={LoadSource={Chosen="Chosen avatar",Last="Last applied",Random="Random favorite",Cycle="Cycle position"},
    Trigger={Death="On death",Respawn="On respawn",Timer="On a timer",Both="Death or timer"},
    Order={Sequential="In order",Shuffle="Shuffle",Random="Random",PingPong="Ping-pong"},
    EndAction={Loop="Start over",Stop="Stay on last",Restore="Restore mine"}}
function UI.duration(seconds)
    if seconds<60 then return tostring(seconds).." s" end
    if seconds%60==0 then return tostring(seconds/60).." min" end
    return string.format("%d:%02d",math.floor(seconds/60),seconds%60)
end
function UI.clock(seconds)
    seconds=math.max(0,math.ceil(seconds))
    return string.format("%d:%02d",math.floor(seconds/60),seconds%60)
end
function UI.controlCard(parent,title,description,controlWidth)
    local card=UI.card(parent,58)
    local name=UI.text(card,title,13,nil,true); name.Position=UDim2.fromOffset(12,8); name.Size=UDim2.new(1,-(controlWidth+26),0,22)
    local hint=UI.text(card,description,11,UI.C.Muted); hint.Position=UDim2.fromOffset(12,30); hint.Size=UDim2.new(1,-(controlWidth+26),0,0); hint.AutomaticSize=Enum.AutomaticSize.Y; hint.TextWrapped=true; hint.TextTruncate=Enum.TextTruncate.None; hint.TextYAlignment=Enum.TextYAlignment.Top
    card.AutomaticSize=Enum.AutomaticSize.Y; UI.new("UIPadding",{PaddingBottom=UDim.new(0,9)},card)
    return card
end
function UI.choice(parent,title,description,key,onChange)
    local card=UI.controlCard(parent,title,description,150)
    local options={}
    for _,value in ipairs(Store.AutoOptions[key]) do table.insert(options,{Value=value,Label=UI.AutoLabels[key][value]}) end
    local drop=UI.dropdown(card,options,function() return Store.Auto[key] end,function(value)
        Store.Auto[key]=value
        if onChange then onChange(value) end
        App.persist(); UI.renderAuto()
    end)
    drop.Root.Size=UDim2.fromOffset(150,40); drop.Root.Position=UDim2.new(1,-162,0.5,-20)
    UI.Choices=UI.Choices or {}; UI.Choices[key]=drop
    return card
end
function UI.stepper(parent,title,description,key,values,format,store,onChange)
    store=store or Store.Auto
    local card=UI.controlCard(parent,title,description,140)
    local box=UI.new("Frame",{Size=UDim2.fromOffset(140,38),Position=UDim2.new(1,-152,0.5,-19),BackgroundTransparency=1},card)
    local value=UI.text(box,"",13,nil,true); value.Position=UDim2.fromOffset(38,0); value.Size=UDim2.new(1,-76,1,0); value.TextXAlignment=Enum.TextXAlignment.Center
    local function show() value.Text=format(store[key]) end
    local function step(direction)
        local index=1
        for i,item in ipairs(values) do if item<=store[key] then index=i end end
        store[key]=values[math.clamp(index+direction,1,#values)]; show(); App.persist()
        if store==Store.Auto then UI.renderAuto() end
        if onChange then onChange(store[key]) end
    end
    local minus=UI.button(box,"",false,function() step(-1) end,"minus"); minus.Root.Size=UDim2.fromOffset(36,38)
    local plus=UI.button(box,"",false,function() step(1) end,"plus"); plus.Root.Size=UDim2.fromOffset(36,38); plus.Root.Position=UDim2.new(1,-36,0,0)
    UI.Steppers=UI.Steppers or {}; UI.Steppers[key]=show
    show(); return card
end
function UI.entryCard(parent,order,title,hint,get,set)
    local card=UI.autoCard(parent,order,8,14)
    UI.paragraph(card,title,13,UI.C.Text,true,1)
    UI.paragraph(card,hint,11,UI.C.Muted,false,2)
    local value=UI.paragraph(card,"",13,UI.C.Accent,true,3)
    local row=UI.new("Frame",{LayoutOrder=4,Size=UDim2.new(1,0,0,40),BackgroundTransparency=1},card)
    local function choose(entry,missing)
        if not entry then App.report(missing,"warning"); return end
        set(entry); App.persist(); UI.renderAuto(); App.report(title..": "..Auto.name(entry)..".","success")
    end
    local preview=UI.button(row,"Preview",false,function() choose(Auto.entryFrom(App.Preview),"Preview a profile or a saved skin first.") end,"box")
    preview.Root.Size=UDim2.new(0.38,-6,1,0)
    local current=UI.button(row,"Current",false,function() choose(Auto.entryFrom(App.Current),"Apply a profile or a saved skin first.") end,"user")
    current.Root.Position=UDim2.new(0.38,0,0,0); current.Root.Size=UDim2.new(0.38,-6,1,0)
    local clear=UI.button(row,"Clear",false,function() set(nil); App.persist(); UI.renderAuto() end)
    clear.Root.Position=UDim2.new(0.76,0,0,0); clear.Root.Size=UDim2.new(0.24,0,1,0)
    table.insert(UI.AutoEntryLabels,{Label=value,Get=get})
    return card
end
function UI.addCycle(entry)
    if not entry then return false end
    for _,row in ipairs(Store.Auto.List) do if Auto.same(row,entry) then return false end end
    if #Store.Auto.List>=50 then return false end
    table.insert(Store.Auto.List,entry); return true
end
function UI.buildAuto()
    local page=UI.page("Auto"); UI.stack(page,6); UI.AutoPage=page
    -- Saved-skin thumbnails are posed here before being cloned into rows.
    UI.ThumbWorld=UI.new("WorldModel",{},UI.new("ViewportFrame",{Visible=false},UI.Gui))
    local order=0
    local function add(item) order=order+1; item.LayoutOrder=order; return item end
    local function resetCycle() Auto.DeathsSince=0; Auto.TimerStart=os.clock(); Auto.Pending=nil; table.clear(Auto.Bag); Auto.Direction=1 end
    UI.AutoEntryLabels={}
    add(UI.section(page,"Auto & Cycle","Put an avatar on automatically when the script runs, and rotate through a list of avatars while you play."))
    add(UI.section(page,"Auto-load on execute"))
    add(UI.toggle(page,"Apply an avatar on start","Puts an avatar on as soon as the script runs and your character is ready.","LoadEnabled",nil,Store.Auto))
    add(UI.choice(page,"Which avatar to apply","The chosen avatar, the last one you wore, a random favorite or the cycle's current one. An avatar set for this game always wins.","LoadSource"))
    order=order+1; UI.entryCard(page,order,"Chosen avatar","Used when \"Avatar to load\" is Chosen avatar. Preview a profile or saved skin, then tap Preview.",
        function() return Store.Auto.Chosen end,function(entry) Store.Auto.Chosen=entry end)
    local place=tostring(game.PlaceId)
    order=order+1; UI.entryCard(page,order,"This game only","Overrides the avatar to load whenever you play this experience (place "..place..").",
        function() return Store.Auto.Games[place] end,function(entry) Store.Auto.Games[place]=entry end)
    add(UI.stepper(page,"Delay before loading","Waits after your character spawns, for games that change your look on spawn.","LoadDelay",{0,1,2,3,5,8,10,15,20,30},UI.duration))
    UI.AutoLast=add(UI.text(page,"",11,UI.C.Muted)); UI.AutoLast.Size=UDim2.new(1,0,0,20)

    add(UI.section(page,"Avatar cycle"))
    add(UI.toggle(page,"Cycle avatars","Switches to the next avatar in your list on its own.","CycleEnabled",function() resetCycle(); UI.renderAuto() end,Store.Auto))
    local advHolder,advBody=UI.collapsible(page); add(advHolder)
    local advOrder=0
    local function addAdv(item) advOrder=advOrder+1; item.LayoutOrder=advOrder; return item end
    addAdv(UI.choice(advBody,"Switch when","Death uses the game's death event. Respawn counts every new character (games that reset you without killing you). Timer switches while you play.","Trigger",resetCycle))
    addAdv(UI.stepper(advBody,"Deaths per switch","How many deaths (or respawns) before the next avatar.","EveryDeaths",{1,2,3,4,5,6,7,8,9,10,15,20,25,30,40,50},tostring))
    addAdv(UI.stepper(advBody,"Timer interval","How often the timer modes switch.","TimerSeconds",{10,15,20,30,45,60,90,120,180,300,600,900,1200,1800,2700,3600},UI.duration))
    addAdv(UI.choice(advBody,"Order","In order follows the list. Shuffle wears every avatar once before repeating. Random can repeat. Ping-pong goes back and forth.","Order",function() table.clear(Auto.Bag); Auto.Direction=1 end))
    addAdv(UI.choice(advBody,"At the end of the list","For In order: start over, stay on the last avatar, or go back to your own avatar.","EndAction"))
    addAdv(UI.stepper(advBody,"Cooldown","Minimum time between two switches, so quick deaths don't skip avatars.","Cooldown",{0,1,2,3,5,10,15,20,30,45,60,90,120,180,300},UI.duration))
    addAdv(UI.toggle(advBody,"Remember position","Continues from the same avatar the next time you run the script.","Resume",nil,Store.Auto))
    addAdv(UI.toggle(advBody,"Notify on switch","Shows a small notification with the new avatar's name. Needs Show notifications on in Settings.","Notify",nil,Store.Auto))

    local status=add(UI.autoCard(page,0,8,14))
    UI.paragraph(status,"CYCLE STATUS",10,UI.C.Accent,true,1)
    UI.CycleStatus=UI.paragraph(status,"",13,UI.C.Text,true,2)
    UI.CycleDetail=UI.paragraph(status,"",11,UI.C.Muted,false,3)
    local controls=UI.new("Frame",{LayoutOrder=4,Size=UDim2.new(1,0,0,40),BackgroundTransparency=1},status)
    UI.CyclePrev=UI.button(controls,"Previous",false,function() Auto.switchNow(-1) end,"undo"); UI.CyclePrev.Root.Size=UDim2.new(0.36,-6,1,0)
    UI.CycleNext=UI.button(controls,"Next",true,function() Auto.switchNow(1) end,"arrow"); UI.CycleNext.Root.Position=UDim2.new(0.36,0,0,0); UI.CycleNext.Root.Size=UDim2.new(0.36,-6,1,0)
    local reset=UI.button(controls,"Reset",false,function()
        resetCycle(); Auto.Deaths=0; Store.Auto.Index=0; App.persist(); UI.renderAuto()
        App.report("Cycle counters reset. The next switch starts at the top of the list.","info")
    end); reset.Root.Position=UDim2.new(0.72,0,0,0); reset.Root.Size=UDim2.new(0.28,0,1,0)

    add(UI.section(page,"Cycle list","Up to 50 profiles or saved skins. Drag the number or picture to reorder; tap Wear to jump to one now."))
    local tools=add(UI.new("Frame",{Size=UDim2.new(1,0,0,92),BackgroundTransparency=1},page))
    local function added(entry,missing)
        if not entry then App.report(missing,"warning"); return end
        if UI.addCycle(entry) then App.persist(); UI.renderAuto(); App.report(Auto.name(entry).." added to the cycle.","success")
        else App.report(#Store.Auto.List>=50 and "The cycle list is full (50)." or "That avatar is already in the cycle.","warning") end
    end
    local addPreview=UI.button(tools,"Add preview",false,function() added(Auto.entryFrom(App.Preview),"Preview a profile or a saved skin first.") end,"plus")
    addPreview.Root.Size=UDim2.new(0.5,-6,0,42)
    local addCurrent=UI.button(tools,"Add current",false,function() added(Auto.entryFrom(App.Current),"Apply a profile or a saved skin first.") end,"user")
    addCurrent.Root.Position=UDim2.new(0.5,6,0,0); addCurrent.Root.Size=UDim2.new(0.5,-6,0,42)
    local addFavorites=UI.button(tools,"Add favorites",false,function()
        local count=0
        for _,row in ipairs(Store.Favorites) do if UI.addCycle(Store.entry({Kind="User",Id=row.Id,Name=row.Name,DisplayName=row.DisplayName})) then count=count+1 end end
        if count>0 then App.persist() end; UI.renderAuto()
        App.report(count>0 and (tostring(count).." favorites added to the cycle.") or "No new favorites to add.",count>0 and "success" or "info")
    end,"star"); addFavorites.Root.Position=UDim2.fromOffset(0,50); addFavorites.Root.Size=UDim2.new(0.5,-6,0,42)
    UI.CycleClear=UI.button(tools,"Clear list",false,function()
        UI.confirm("Clear the cycle list?","Every avatar is removed from the cycle. Your current appearance is unchanged.",function()
            Store.Auto.List={}; Store.Auto.Index=0; resetCycle(); App.persist(); UI.renderAuto()
        end)
    end,"trash-2"); UI.CycleClear.Root.Position=UDim2.new(0.5,6,0,50); UI.CycleClear.Root.Size=UDim2.new(0.5,-6,0,42)
    UI.CycleCount=add(UI.text(page,"",11,UI.C.Muted)); UI.CycleCount.Size=UDim2.new(1,0,0,20)
    UI.CycleList=add(UI.new("Frame",{Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1},page)); UI.stack(UI.CycleList,6)
    add(UI.paragraph(page,"Chat shortcuts: /e next, /e prev, and /e cycle to turn the cycle on or off.",11,UI.C.Muted,false,0))
    Auto.OnChange=function() if App.alive() and UI.Tab=="Auto" then UI.renderAuto() end end
    Auto.OnTick=function() if UI.Tab=="Auto" and UI.Visible then UI.autoStatus() end end
    UI.renderAuto()
end
-- Saved skins are rendered one at a time and cached as posed templates.
UI.ThumbCache={}; UI.ThumbQueue={}
function UI.runThumbQueue()
    if UI.ThumbBusy then return end
    UI.ThumbBusy=true
    task.spawn(function()
        while App.alive() and #UI.ThumbQueue>0 do
            local job=table.remove(UI.ThumbQueue,1)
            local slot=UI.ThumbCache[job.Id]
            local row=Looks.find(job.Key)
            local model
            local ok,err=pcall(function()
                assert(row,"The saved skin no longer exists.")
                local desc=Codec.decode(row.Data)
                local rig=row.Data.Visual and Enum.HumanoidRigType[row.Data.Visual.RigType] or Enum.HumanoidRigType.R15
                local built,made=pcall(Visual.model,row.Data,desc,rig); desc:Destroy()
                assert(built and made,tostring(made))
                model=made
                UI.preparePreview(model,UI.ThumbWorld)
                -- A client-made SurfaceAppearance can't load its PBR maps and every clone logs a warning, so the
                -- color map becomes the mesh texture on these tiny thumbnails.
                for _,item in ipairs(model:GetDescendants()) do
                    if item:IsA("SurfaceAppearance") then
                        local part=item.Parent
                        pcall(function() if part:IsA("MeshPart") and part.TextureID=="" and item.ColorMap~="" then part.TextureID=item.ColorMap end end)
                        item:Destroy()
                    end
                end
                model.Archivable=true
                for _,item in ipairs(model:GetDescendants()) do pcall(function() item.Archivable=true end) end
            end)
            if ok then slot.Model=model
            else
                slot.Failed=true
                if model then pcall(function() model:Destroy() end) end
                warn("[Lyra Thumbnail] "..tostring(err))
            end
            for _,show in ipairs(slot.Waiters) do pcall(show,slot.Model) end
            slot.Waiters={}
        end
        UI.ThumbBusy=false
    end)
end
function UI.lookThumb(frame,key)
    local row=Looks.find(key)
    local placeholder=UI.icon(frame,"shirt",UDim2.new(0.5,-12,0.5,-12),UI.C.AccentDark)
    if not row then return end
    local viewport=UI.new("ViewportFrame",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Ambient=Color3.fromRGB(195,186,213),LightColor=Color3.fromRGB(255,244,233),LightDirection=Vector3.new(-1,-1,-1)},frame)
    local function show(template)
        if not template or not viewport.Parent or not App.alive() then return end
        local ok=pcall(function()
            local model=template:Clone(); model.Parent=viewport
            local head=model:FindFirstChild("Head")
            local focus=head and head.Position or model:GetBoundingBox().Position
            local size=head and math.max(head.Size.X,head.Size.Y,0.6) or 2
            local camera=UI.new("Camera",{FieldOfView=30},viewport); viewport.CurrentCamera=camera
            -- The rig faces -Z after preparePreview.
            camera.CFrame=CFrame.lookAt(focus+Vector3.new(0,size*0.12,-size*3.4),focus)
        end)
        if ok then placeholder:Destroy() end
    end
    -- Updated skins get a new timestamp, which invalidates the cached thumbnail.
    local id=key..":"..tostring(row.Updated)
    local slot=UI.ThumbCache[id]
    if slot and slot.Model then show(slot.Model); return end
    if slot and slot.Failed then return end
    if not slot then
        slot={Waiters={}}; UI.ThumbCache[id]=slot
        table.insert(UI.ThumbQueue,{Id=id,Key=key}); UI.runThumbQueue()
    end
    table.insert(slot.Waiters,show)
end
function UI.cycleThumb(parent,entry)
    local frame=UI.new("Frame",{Position=UDim2.fromOffset(43,7),Size=UDim2.fromOffset(44,44),BackgroundColor3=UI.C.Raised,BorderSizePixel=0,ClipsDescendants=true},parent); UI.round(frame,12)
    if entry.Kind=="User" and entry.Id then
        UI.new("ImageLabel",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,BorderSizePixel=0,Image="rbxthumb://type=AvatarHeadShot&id="..tostring(entry.Id).."&w=150&h=150"},frame)
    elseif entry.Kind=="Look" then UI.lookThumb(frame,entry.Key)
    else UI.icon(frame,"user",UDim2.new(0.5,-12,0.5,-12),UI.C.AccentDark) end
    return frame
end
UI.CycleStep=64 -- row height 58 + list gap 6
function UI.startCycleDrag(index,row,input)
    if UI.CycleDrag or #Store.Auto.List<2 or not UI.AutoPage then return end
    local touch=input.UserInputType==Enum.UserInputType.Touch and input or nil
    local drag={From=index,Slot=nil,Connections={}}
    UI.CycleDrag=drag
    UI.AutoPage.ScrollingEnabled=false
    local stroke=row:FindFirstChildOfClass("UIStroke")
    if stroke then stroke.Color=UI.C.Accent; stroke.Transparency=0 end
    row.BackgroundTransparency=0.55
    local width=UI.CycleList.AbsoluteSize.X
    drag.Line=UI.new("Frame",{Size=UDim2.fromOffset(width,3),BackgroundColor3=UI.C.Accent,BorderSizePixel=0,ZIndex=40},UI.Surface); UI.round(drag.Line,2)
    drag.Ghost=UI.new("TextLabel",{Size=UDim2.fromOffset(math.min(260,width-24),36),BackgroundColor3=UI.C.AccentDark,BackgroundTransparency=0.05,TextColor3=UI.C.Text,
        Text="  "..Auto.name(Store.Auto.List[index]),Font=UI.Font.Bold,TextSize=UI.size(13),TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,ZIndex=41,BorderSizePixel=0},UI.Surface)
    UI.round(drag.Ghost,10); UI.stroke(drag.Ghost,0.2,UI.C.Accent)
    local function update(y)
        local list=UI.CycleList; local top=list.AbsolutePosition.Y; local surface=UI.Surface.AbsolutePosition
        -- Rows live inside the scaled window, so scale the step too.
        local step=UI.CycleStep*(UI.CurrentScale or 1)
        drag.Slot=math.clamp(math.floor((y-top)/step+0.5),0,#Store.Auto.List)
        drag.Line.Position=UDim2.fromOffset(list.AbsolutePosition.X-surface.X,top+drag.Slot*step-4-surface.Y)
        drag.Ghost.Position=UDim2.fromOffset(list.AbsolutePosition.X-surface.X+12,y-18-surface.Y)
        local page=UI.AutoPage; local pageTop=page.AbsolutePosition.Y; local pageBottom=pageTop+page.AbsoluteSize.Y
        if y<pageTop+48 then page.CanvasPosition=Vector2.new(0,math.max(0,page.CanvasPosition.Y-14))
        elseif y>pageBottom-48 then page.CanvasPosition=Vector2.new(0,page.CanvasPosition.Y+14) end
    end
    local function finish()
        for _,connection in ipairs(drag.Connections) do connection:Disconnect() end
        UI.CycleDrag=nil
        pcall(function() drag.Line:Destroy(); drag.Ghost:Destroy() end)
        if UI.AutoPage then UI.AutoPage.ScrollingEnabled=true end
        if drag.Slot and App.alive() then
            -- Slot s is the gap before item s+1 in the original order.
            local target=drag.Slot>=drag.From and drag.Slot or drag.Slot+1
            if Auto.move(drag.From,target) then App.persist() end
        end
        if App.alive() then UI.renderAuto() end
    end
    table.insert(drag.Connections,RegisterConnection(UIS.InputChanged:Connect(function(changed)
        if touch and changed~=touch then return end
        if not touch and changed.UserInputType~=Enum.UserInputType.MouseMovement then return end
        update(changed.Position.Y)
    end)))
    table.insert(drag.Connections,RegisterConnection(UIS.InputEnded:Connect(function(ended)
        if (touch and ended==touch) or (not touch and ended.UserInputType==Enum.UserInputType.MouseButton1) then finish() end
    end)))
    update(input.Position.Y)
end
function UI.cycleRow(entry,index)
    local list=Store.Auto.List
    local current=index==Store.Auto.Index
    local row=UI.card(UI.CycleList,58); row.LayoutOrder=index
    if current then local stroke=row:FindFirstChildOfClass("UIStroke"); stroke.Color=UI.C.Accent; stroke.Transparency=0.1 end
    local badge=UI.new("Frame",{Position=UDim2.fromOffset(9,15),Size=UDim2.fromOffset(28,28),BackgroundColor3=current and UI.C.Accent or UI.C.Raised,BorderSizePixel=0},row); UI.round(badge,9)
    local number=UI.text(badge,tostring(index),12,current and UI.C.Base or UI.C.Text,true); number.Size=UDim2.fromScale(1,1); number.TextXAlignment=Enum.TextXAlignment.Center
    UI.cycleThumb(row,entry)
    local controls=58+6+40+12
    local title=UI.text(row,Auto.name(entry),13,nil,true); title.Position=UDim2.fromOffset(96,7); title.Size=UDim2.new(1,-(96+controls),0,22)
    local sub=UI.text(row,(entry.Kind=="Look" and "Saved skin" or "Roblox profile")..(current and "  ·  wearing now" or ""),11,current and UI.C.Accent or UI.C.Muted); sub.Position=UDim2.fromOffset(96,30); sub.Size=UDim2.new(1,-(96+controls),0,20)
    local grip=UI.new("TextButton",{Size=UDim2.new(0,92,1,0),BackgroundTransparency=1,Text="",AutoButtonColor=false,BorderSizePixel=0},row)
    UI.rowConnect("cycle",grip.InputBegan,function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then UI.startCycleDrag(index,row,input) end
    end)
    local wear=UI.button(row,"Wear",false,function() Auto.switchNow(1,index) end,nil,"cycle")
    wear.Root.Size=UDim2.fromOffset(58,38); wear.Root.Position=UDim2.new(1,-controls,0.5,-19)
    local remove=UI.button(row,"",false,function()
        table.remove(list,index)
        if Store.Auto.Index>=index then Store.Auto.Index=math.max(0,Store.Auto.Index-1) end
        table.clear(Auto.Bag); App.persist(); UI.renderAuto()
    end,"x","cycle"); remove.Root.Size=UDim2.fromOffset(40,38); remove.Root.Position=UDim2.new(1,-52,0.5,-19)
end
function UI.autoStatus()
    if not UI.CycleStatus then return end
    local auto=Store.Auto; local count=#auto.List
    local wearing=(auto.Index>=1 and auto.Index<=count) and (tostring(auto.Index).."/"..tostring(count).."  ·  "..Auto.name(auto.List[auto.Index])) or nil
    local detail
    if not auto.CycleEnabled then
        UI.CycleStatus.Text="Cycle is off"
        detail=count==0 and "Add avatars below, then turn on Cycle avatars." or (tostring(count).." avatars ready"..(wearing and ("  ·  last: "..wearing) or ""))
    elseif count==0 then
        UI.CycleStatus.Text="Cycle is on, but the list is empty"; detail="Add avatars to the cycle list below."
    else
        UI.CycleStatus.Text=wearing and ("Wearing "..wearing) or "Waiting for the first switch"
        local parts={}
        if Auto.Switching or Auto.Pending then table.insert(parts,"loading the next avatar…") end
        if auto.Trigger~="Timer" then
            table.insert(parts,tostring(math.max(0,auto.EveryDeaths-Auto.DeathsSince)).." more "..(auto.Trigger=="Respawn" and "respawn(s)" or "death(s)").." to switch")
        end
        if auto.Trigger=="Timer" or auto.Trigger=="Both" then table.insert(parts,"timer "..UI.clock(auto.TimerSeconds-(os.clock()-Auto.TimerStart))) end
        local cooldown=auto.Cooldown-(os.clock()-Auto.LastSwitch)
        if cooldown>0 then table.insert(parts,"cooldown "..tostring(math.ceil(cooldown)).." s") end
        table.insert(parts,tostring(Auto.Deaths).." deaths this session")
        detail=table.concat(parts,"  ·  ")
    end
    UI.CycleDetail.Text=detail
    local ready=count>0 and not App.Busy and not Auto.Switching
    UI.enabled(UI.CyclePrev,ready); UI.enabled(UI.CycleNext,ready)
end
function UI.renderAuto()
    if not UI.CycleList then return end
    -- Rebuilding rows mid-drag would drop the grip; the drag re-renders when it ends.
    if UI.CycleDrag then UI.autoStatus(); return end
    for _,row in ipairs(UI.AutoEntryLabels) do row.Label.Text=Auto.name(row.Get()) end
    UI.AutoLast.Text="Last applied: "..Auto.name(Store.Auto.Last)
    for key,refresh in pairs(UI.Toggles or {}) do if key:sub(1,5)=="Auto." then refresh() end end
    for _,drop in pairs(UI.Choices or {}) do drop.refresh() end
    UI.clearRows("cycle",UI.CycleList)
    for index,entry in ipairs(Store.Auto.List) do UI.cycleRow(entry,index) end
    UI.CycleCount.Text=tostring(#Store.Auto.List).."/50 avatars in the cycle"
    UI.enabled(UI.CycleClear,#Store.Auto.List>0)
    if #Store.Auto.List==0 then UI.emptyList(UI.CycleList,"Your cycle is empty","Preview a profile or saved skin and tap Add preview, or add all your favorites.") end
    UI.autoStatus()
end

function UI.loadCreatorPhoto()
    if UI.PhotoRequested or not UI.CreatorPhoto then return end
    UI.PhotoRequested=true
    task.spawn(function()
        local asset=type(getcustomasset)=="function" and getcustomasset or type(getsynasset)=="function" and getsynasset
        if not asset or type(writefile)~="function" then return end
        local path="LyraAvatarStudio_github_lyraEz.png"
        local ok,image=pcall(function()
            local cached=type(isfile)=="function" and isfile(path)
            if not cached then
                local requestFn=type(request)=="function" and request or type(http_request)=="function" and http_request or (type(syn)=="table" and type(syn.request)=="function" and syn.request)
                local body
                if requestFn then
                    local response=requestFn({Url="https://github.com/lyraEz.png?size=256",Method="GET"})
                    assert(response and response.StatusCode==200,"Profile photo unavailable")
                    body=response.Body
                else body=game:HttpGet("https://github.com/lyraEz.png?size=256") end
                assert(type(body)=="string" and #body>16 and #body<2097152,"Invalid profile photo")
                assert(body:sub(1,8)=="\137PNG\13\10\26\10" or body:sub(1,3)=="\255\216\255","Invalid image format")
                writefile(path,body)
            end
            return asset(path)
        end)
        if ok and type(image)=="string" and App.alive() then UI.CreatorPhoto.Image=image end
    end)
end

function UI.buildCreator()
    local page=UI.page("Creator"); UI.stack(page,10)
    UI.section(page,"Made by lyraEz","Find me and my other scripts here. Tap a link to copy it.")
    local LINK_RGB=Color3.fromRGB(108,180,255)
    local LINK_HEX="#6CB4FF"
    local function copyLink(label,url,linkButton,fallback,button)
        local copy=type(setclipboard)=="function" and setclipboard or type(toclipboard)=="function" and toclipboard or nil
        if copy and pcall(copy,url) then
            button.Label.Text="Copied!"; App.report(label.." link copied.","success")
            task.delay(1.5,function() if App.alive() and button and button.Label then button.Label.Text="Copy link" end end)
            return
        end
        linkButton.Visible=false; fallback.Visible=true; fallback:CaptureFocus(); fallback.SelectionStart=1; fallback.CursorPosition=#url+1
        App.report("Automatic clipboard access is unavailable. Select the link and copy it manually.","warning")
    end
    local function finishCard(card,order,label,url)
        local holder=UI.new("Frame",{LayoutOrder=order,Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1},card)
        local linkButton=UI.new("TextButton",{Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,AutoButtonColor=false,RichText=true,
            Text='<u><font color="'..LINK_HEX..'">'..url..'</font></u>',TextColor3=LINK_RGB,TextSize=UI.size(13),Font=UI.Font.Regular,TextWrapped=true,
            TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Top},holder)
        local fallback=UI.new("TextBox",{Visible=false,Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,Text=url,TextEditable=false,
            ClearTextOnFocus=false,TextColor3=LINK_RGB,TextSize=UI.size(13),Font=UI.Font.Regular,TextWrapped=true,TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Top},holder)
        local button
        button=UI.button(card,"Copy link",false,function() copyLink(label,url,linkButton,fallback,button) end,"copy")
        button.Root.LayoutOrder=order+1
        UI.connect(linkButton.Activated,function() copyLink(label,url,linkButton,fallback,button) end)
        UI.connect(fallback.FocusLost,function() fallback.Visible=false; linkButton.Visible=true end)
    end
    local function simpleCard(order,title,subtitle,icon,label,url)
        local card=UI.autoCard(page,order,12,16)
        local header=UI.new("Frame",{LayoutOrder=1,Size=UDim2.new(1,0,0,44),BackgroundTransparency=1},card)
        local badge=UI.new("Frame",{Size=UDim2.fromOffset(44,44),BackgroundColor3=UI.C.Raised,BorderSizePixel=0},header); UI.round(badge,13); UI.icon(badge,icon,UDim2.fromOffset(10,10),UI.C.Accent)
        local heading=UI.text(header,title,17,nil,true); heading.Position=UDim2.fromOffset(58,0); heading.Size=UDim2.new(1,-58,0,24)
        local caption=UI.text(header,subtitle,12,UI.C.Muted); caption.Position=UDim2.fromOffset(58,25); caption.Size=UDim2.new(1,-58,0,20)
        finishCard(card,2,label,url)
        return card
    end

    simpleCard(1,"Discord","Join the community","discord","Discord",App.Creator.Discord)
    local github=UI.autoCard(page,2,8,12)
    UI.new("UIGradient",{Color=ColorSequence.new({ColorSequenceKeypoint.new(0,UI.C.AccentDark),ColorSequenceKeypoint.new(1,UI.C.Card)}),Rotation=28},github)
    local header=UI.new("Frame",{LayoutOrder=1,Size=UDim2.new(1,0,0,52),BackgroundTransparency=1},github)
    local portrait=UI.new("Frame",{Size=UDim2.fromOffset(52,52),BackgroundColor3=UI.C.Accent,BorderSizePixel=0},header); UI.round(portrait,16); UI.stroke(portrait,0.32,UI.C.Accent)
    local letter=UI.text(portrait,"L",28,UI.C.Base,true); letter.Size=UDim2.fromScale(1,1); letter.TextXAlignment=Enum.TextXAlignment.Center
    UI.CreatorPhoto=UI.new("ImageLabel",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Image="",BorderSizePixel=0,ZIndex=2,ScaleType=Enum.ScaleType.Crop},portrait); UI.round(UI.CreatorPhoto,16)
    local platform=UI.text(header,"GITHUB PROFILE",10,UI.C.Accent,true); platform.Position=UDim2.fromOffset(64,0); platform.Size=UDim2.new(1,-64,0,16)
    local name=UI.text(header,App.Creator.Name,19,nil,true); name.Position=UDim2.fromOffset(64,15); name.Size=UDim2.new(1,-64,0,24)
    local handle=UI.text(header,"@lyraEz",11,UI.C.Muted); handle.Position=UDim2.fromOffset(64,37); handle.Size=UDim2.new(1,-64,0,16)
    local bio=UI.paragraph(github,"The moon reminds me that even in darkness, there's always a <b><font color=\"#CBB8FF\">beautiful light</font></b>",12,UI.C.Text,false,2)
    bio.RichText=true
    finishCard(github,3,"GitHub",App.Creator.GitHub)
end

function UI.buildModal()
    UI.Modal=UI.new("Frame",{Size=UDim2.fromScale(1,1),BackgroundColor3=Color3.new(0,0,0),BackgroundTransparency=0.3,ZIndex=50,Visible=false,Active=true},UI.Main)
    local card=UI.new("Frame",{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.5,0.5),Size=UDim2.new(1,-48,0,224),BackgroundColor3=UI.C.Card,BorderSizePixel=0},UI.Modal); UI.round(card,18); UI.stroke(card,0.1)
    UI.new("UISizeConstraint",{MaxSize=Vector2.new(440,224)},card)
    UI.ModalTitle=UI.text(card,"",18,nil,true); UI.ModalTitle.Position=UDim2.fromOffset(18,20); UI.ModalTitle.Size=UDim2.new(1,-36,0,28)
    UI.ModalText=UI.text(card,"",12,UI.C.Muted); UI.ModalText.Position=UDim2.fromOffset(18,61); UI.ModalText.Size=UDim2.new(1,-36,0,88); UI.ModalText.TextWrapped=true; UI.ModalText.TextTruncate=Enum.TextTruncate.None; UI.ModalText.TextYAlignment=Enum.TextYAlignment.Top
    local cancel=UI.button(card,"Cancel",false,function() UI.ModalToken=(UI.ModalToken or 0)+1; UI.Modal.Visible=false; UI.ModalAction=nil end); cancel.Root.Position=UDim2.new(0,16,1,-60); cancel.Root.Size=UDim2.new(0.5,-22,0,44)
    local confirm=UI.button(card,"Confirm",true,function() UI.ModalToken=(UI.ModalToken or 0)+1; local fn=UI.ModalAction; UI.ModalAction=nil; UI.Modal.Visible=false; if fn then fn() end end); confirm.Root.Position=UDim2.new(0.5,6,1,-60); confirm.Root.Size=UDim2.new(0.5,-22,0,44)
    UI.ModalCancel=cancel; UI.ModalConfirm=confirm
end
-- options = {Confirm, Cancel, Seconds}. Seconds auto-cancels, counting down on the Cancel button.
function UI.confirm(title,description,action,options)
    options=options or {}
    UI.ModalToken=(UI.ModalToken or 0)+1; local token=UI.ModalToken
    UI.ModalTitle.Text=title; UI.ModalText.Text=description; UI.ModalAction=action; UI.Modal.Visible=true
    local cancelText=options.Cancel or "Cancel"
    UI.ModalConfirm.Label.Text=options.Confirm or "Confirm"; UI.ModalCancel.Label.Text=cancelText
    if not options.Seconds then return end
    task.spawn(function()
        for left=options.Seconds,1,-1 do
            if not App.alive() or token~=UI.ModalToken then return end
            UI.ModalCancel.Label.Text=cancelText.." ("..tostring(left)..")"
            task.wait(1)
        end
        if App.alive() and token==UI.ModalToken then UI.ModalToken=token+1; UI.Modal.Visible=false; UI.ModalAction=nil; UI.ModalCancel.Label.Text=cancelText end
    end)
end
function UI.toggleFavorite(profile)
    if not profile then return end
    if App.favoriteIndex(profile) then
        UI.confirm("Remove favorite?",profile.Name.." will be removed from your favorites.",function() App.toggleFavorite(profile) end)
    else App.toggleFavorite(profile) end
end
function UI.timelineThumb(frame,snapshot)
    if snapshot.Original then
        UI.new("ImageLabel",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,BorderSizePixel=0,Image="rbxthumb://type=AvatarHeadShot&id="..tostring(lp.UserId).."&w=150&h=150"},frame)
    elseif snapshot.Change then
        UI.new("ImageLabel",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,BorderSizePixel=0,ScaleType=Enum.ScaleType.Fit,Image=UI.catalogThumb({Id=snapshot.Change.Id,Bundle=snapshot.Change.Bundle})},frame)
    elseif snapshot.LookKey and Looks.find(snapshot.LookKey) then UI.lookThumb(frame,snapshot.LookKey)
    elseif snapshot.Id or snapshot.ThumbId then
        UI.new("ImageLabel",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,BorderSizePixel=0,Image="rbxthumb://type=AvatarHeadShot&id="..tostring(snapshot.Id or snapshot.ThumbId).."&w=150&h=150"},frame)
    else UI.icon(frame,"user",UDim2.new(0.5,-12,0.5,-12),UI.C.AccentDark) end
end
function UI.renderTimeline()
    if not UI.TimelineStrip then return end
    local items=table.clone(App.History)
    if App.Current then table.insert(items,App.Current) end
    local signature={tostring(App.Busy)}
    for _,snapshot in ipairs(items) do table.insert(signature,tostring(snapshot)) end
    signature=table.concat(signature,"|")
    if signature==UI.TimelineSignature then return end
    UI.TimelineSignature=signature
    UI.clearRows("timeline",UI.TimelineStrip)
    if #items==0 then
        local empty=UI.text(UI.TimelineStrip,"Avatars you wear appear here.",11,UI.C.Muted); empty.Size=UDim2.new(1,0,1,0)
        return
    end
    for index,snapshot in ipairs(items) do
        local current=snapshot==App.Current
        local tile=UI.new("TextButton",{LayoutOrder=index,Size=UDim2.fromOffset(58,64),BackgroundTransparency=1,Text="",AutoButtonColor=false,BorderSizePixel=0},UI.TimelineStrip)
        local frame=UI.new("Frame",{Position=UDim2.fromOffset(7,0),Size=UDim2.fromOffset(44,44),BackgroundColor3=UI.C.Raised,BorderSizePixel=0,ClipsDescendants=true},tile); UI.round(frame,12)
        UI.stroke(frame,current and 0 or 0.6,current and UI.C.Accent or UI.C.Line).Thickness=current and 2 or 1
        UI.timelineThumb(frame,snapshot)
        local name=snapshot.Original and "Original" or tostring(snapshot.Name or "Avatar")
        local label=UI.text(tile,current and "Now" or name,10,current and UI.C.Accent or UI.C.Muted,current)
        label.Position=UDim2.fromOffset(0,46); label.Size=UDim2.new(1,0,0,18); label.TextXAlignment=Enum.TextXAlignment.Center
        if not current then
            UI.rowConnect("timeline",tile.Activated,function() if not App.Busy then App.jump(snapshot) end end)
            UI.rowConnect("timeline",tile.MouseEnter,function() UI.tween(frame,{BackgroundColor3=UI.C.AccentDark}) end)
            UI.rowConnect("timeline",tile.MouseLeave,function() UI.tween(frame,{BackgroundColor3=UI.C.Raised}) end)
        end
        if App.Busy and not current then tile.Active=false; label.TextTransparency=0.5 end
    end
    task.defer(function()
        if App.alive() and UI.TimelineStrip then
            UI.TimelineStrip.CanvasPosition=Vector2.new(math.max(0,UI.TimelineStrip.AbsoluteCanvasSize.X-UI.TimelineStrip.AbsoluteWindowSize.X),0)
        end
    end)
end
function UI.refresh()
    if not UI.Apply then return end
    UI.enabled(UI.Apply,App.Preview~=nil and not App.Busy)
    UI.enabled(UI.Favorite,App.Preview~=nil and App.Preview.Id~=nil)
    UI.enabled(UI.Undo,#App.History>0 and not App.Busy)
    UI.enabled(UI.Restore,App.Initial~=nil and (App.Dirty or App.Current~=App.Initial) and not App.Busy)
    UI.enabled(UI.Customize,(App.Current~=nil or App.Initial~=nil) and not App.Busy)
    UI.Apply.Label.Text=App.Busy and "Applying…" or "Apply avatar"
    UI.Favorite.Label.Text=UI.favoriteText()
    UI.HistoryText.Text=#App.History>0 and (tostring(#App.History)..(#App.History==1 and " earlier look · tap to go back" or " earlier looks · tap to go back")) or "No changes yet"
    UI.renderTimeline()
    if UI.Tab=="Looks" and UI.LooksCurrent~=App.Current then UI.LooksCurrent=App.Current; UI.renderLooks() end
    if UI.Tab=="Collection" then UI.renderCollection() end
    if UI.Tab=="Catalog" then UI.refreshCatalog() end
end
-- Roblox menu avatar: on this client only, your card in the menu's Players page shows the avatar you
-- wear. Everything is pcall'd because the CoreGui layout can change at any time.
UI.MenuAvatarSerial=0
function UI.menuAvatarModel()
    local snapshot=App.Current
    if not snapshot or snapshot.Original then return nil end
    if UI.MenuAvatar and UI.MenuAvatar.Snapshot==snapshot then return UI.MenuAvatar.Model,UI.MenuAvatar.Serial end
    local ok,model=pcall(function()
        local desc=Codec.decode(snapshot.Data)
        local rig=F.getTrueRigType(lp.Character) or Enum.HumanoidRigType.R15
        local built,made=pcall(Visual.model,snapshot.Data,desc,rig); desc:Destroy()
        assert(built and made,tostring(made))
        UI.preparePreview(made,UI.ThumbWorld)
        for _,item in ipairs(made:GetDescendants()) do
            pcall(function() item.Archivable=true end)
            if item:IsA("SurfaceAppearance") then
                local part=item.Parent
                pcall(function() if part:IsA("MeshPart") and part.TextureID=="" and item.ColorMap~="" then part.TextureID=item.ColorMap end end)
                item:Destroy()
            end
        end
        made.Archivable=true
        return made
    end)
    if not ok or not model then return nil end
    if UI.MenuAvatar then pcall(function() UI.MenuAvatar.Model:Destroy() end) end
    UI.MenuAvatarSerial=UI.MenuAvatarSerial+1
    UI.MenuAvatar={Snapshot=snapshot,Model=model,Serial=UI.MenuAvatarSerial}
    return model,UI.MenuAvatarSerial
end
function UI.menuAvatarView(label,model,serial)
    local view=Instance.new("ViewportFrame")
    view.Name="LyraMenuAvatar"; view.Size=UDim2.fromScale(1,1); view.BackgroundTransparency=1; view.BorderSizePixel=0
    view.ZIndex=label.ZIndex+1; view.Ambient=Color3.fromRGB(195,186,213); view.LightColor=Color3.fromRGB(255,244,233); view.LightDirection=Vector3.new(-1,-1,-1)
    view:SetAttribute("Serial",serial)
    local clone=model:Clone(); clone.Parent=view
    local boxCFrame,box=clone:GetBoundingBox()
    local focus=boxCFrame.Position
    local card=label.AbsoluteSize
    local aspect=card.X>0 and card.Y>0 and math.clamp(card.X/card.Y,0.5,2) or 1
    local fov=30
    local fit=math.max(box.Y,math.min(box.X,box.Y)/aspect)
    local distance=(fit*0.5/math.tan(math.rad(fov/2))+box.Z*0.5)*1.12
    local camera=Instance.new("Camera"); camera.FieldOfView=fov
    camera.CFrame=CFrame.lookAt(focus+Vector3.new(0,box.Y*0.04,-distance),focus); camera.Parent=view; view.CurrentCamera=camera
    local corner=label:FindFirstChildOfClass("UICorner"); if corner then corner:Clone().Parent=view end
    label.ImageTransparency=1
    view.Parent=label
end
-- The list recycles its cards, so every card is checked each time.
function UI.patchMenuAvatar()
    local rgui=game:GetService("CoreGui"):FindFirstChild("RobloxGui")
    local page=rgui and rgui:FindFirstChild("peoplepage",true)
    if not page then return end
    local model,serial=UI.menuAvatarModel()
    local names={[lp.DisplayName]=true,[lp.Name]=true,["@"..lp.Name]=true}
    for _,label in ipairs(page:GetDescendants()) do
        if label.Name=="AvatarThumbnail" and label:IsA("ImageLabel") then
            local root=label.Parent
            while root and root~=page and not root.Name:find("^VirtualizedItem") do root=root.Parent end
            local mine=false
            if root and root~=page then
                for _,item in ipairs(root:GetDescendants()) do
                    if (item:IsA("TextLabel") or item:IsA("TextButton")) and names[item.Text] then mine=true; break end
                end
            end
            local view=label:FindFirstChild("LyraMenuAvatar")
            if mine and model then
                if not view or view:GetAttribute("Serial")~=serial then
                    if view then view:Destroy() end
                    UI.menuAvatarView(label,model,serial)
                end
            elseif view then view:Destroy(); label.ImageTransparency=0 end
        end
    end
end
-- Fast at first while the menu builds its cards, then slower to follow scrolling.
function UI.runMenuAvatar()
    if UI.MenuAvatarRunning or not Store.Settings.MenuAvatar then return end
    UI.MenuAvatarRunning=true
    task.spawn(function()
        local started=os.clock()
        while App.alive() and UI.MenuIsOpen and Store.Settings.MenuAvatar do
            pcall(UI.patchMenuAvatar)
            task.wait(os.clock()-started<4 and 0.2 or 0.6)
        end
        UI.MenuAvatarRunning=false
    end)
end
function UI.clearMenuAvatar()
    local rgui=game:GetService("CoreGui"):FindFirstChild("RobloxGui")
    if rgui then
        for _,item in ipairs(rgui:GetDescendants()) do
            if item.Name=="LyraMenuAvatar" then
                local parent=item.Parent; item:Destroy()
                if parent and parent:IsA("ImageLabel") then parent.ImageTransparency=0 end
            end
        end
    end
    if UI.MenuAvatar then pcall(function() UI.MenuAvatar.Model:Destroy() end); UI.MenuAvatar=nil end
end
-- Opening and closing the Roblox menu 3 times within 5 s reopens a hidden window. It is the only
-- reopen method that shows a notice, so an accidental trigger can be turned off from there.
function UI.menuReopen()
    UI.Minimized=false; UI.setVisible(true); UI.layout(false)
    App.toast({Title="Avatar Studio reopened",Text="You opened the Roblox menu 3 times in a row. If that was by accident, you can turn this shortcut off.",
        Kind="info",Icon="menu",Duration=9,
        Action={Text="Turn off shortcut",Callback=function()
            if not App.alive() then return end
            Store.Settings.MenuReopen=false; App.persist()
            local refresh=UI.Toggles and UI.Toggles.MenuReopen; if refresh then refresh() end
            UI.refreshReopenCard()
            App.report("Roblox menu shortcut turned off. You can turn it back on in Settings.","info")
        end}})
end
function UI.watchMenu()
    local GuiService=game:GetService("GuiService")
    UI.connect(GuiService.MenuOpened,function() UI.MenuIsOpen=true; UI.runMenuAvatar() end)
    UI.connect(GuiService.MenuClosed,function() UI.MenuIsOpen=false end)
    local stamps={}
    local openedAt=nil
    UI.connect(GuiService.MenuOpened,function()
        openedAt=(not UI.Visible and Store.Settings.MenuReopen) and os.clock() or nil
    end)
    -- A close only counts when its open was seen while the window was hidden and the shortcut was on.
    UI.connect(GuiService.MenuClosed,function()
        local opened=openedAt; openedAt=nil
        if not opened or UI.Visible or not Store.Settings.MenuReopen then table.clear(stamps); return end
        local now=os.clock()
        table.insert(stamps,now)
        while #stamps>0 and now-stamps[1]>5 do table.remove(stamps,1) end
        if #stamps>=3 then table.clear(stamps); UI.menuReopen() end
    end)
end
function UI.inputs()
    UI.watchMenu()
    UI.connect(UIS.InputBegan,function(input,processed)
        if UI.CapturingKey and input.UserInputType==Enum.UserInputType.Keyboard then
            UI.CapturingKey=false
            if input.KeyCode~=Enum.KeyCode.Escape and input.KeyCode~=Enum.KeyCode.Unknown then
                local reserved={V=true,L=true,R=true,K=true,W=true,A=true,S=true,D=true,Space=true,Return=true,Tab=true,Backspace=true}
                if reserved[input.KeyCode.Name] then App.report("That key is already used by the game or hub. Choose another one.","warning")
                else Store.Settings.Keybind=input.KeyCode.Name; App.persist(); UI.refreshReopenCard() end
            end
            UI.KeyButton.Label.Text=Store.Settings.Keybind; return
        end
        if processed or UIS:GetFocusedTextBox() then return end
        if input.KeyCode.Name==Store.Settings.Keybind then UI.setVisible(not UI.Visible) end
    end)
    local function chat(message)
        local normalized=message:lower():gsub("%s+","")
        if normalized=="/ecopier" or normalized=="/ehub" or normalized=="/copier" or normalized=="/hub" or normalized=="/edance1" or normalized=="/dance1" then
            UI.Minimized=false; UI.setVisible(true); UI.layout(false); App.report("Hub opened.","info")
            return
        end
        -- The same message can arrive through more than one chat event; act on it once.
        local command=normalized:gsub("^/e","/")
        if command~="/next" and command~="/prev" and command~="/cycle" then return end
        if UI.LastChatCommand==command and os.clock()-(UI.LastChatAt or 0)<1 then return end
        UI.LastChatCommand=command; UI.LastChatAt=os.clock()
        if command=="/next" then Auto.switchNow(1)
        elseif command=="/prev" then Auto.switchNow(-1)
        else
            Store.Auto.CycleEnabled=not Store.Auto.CycleEnabled
            Auto.DeathsSince=0; Auto.TimerStart=os.clock(); Auto.Pending=nil
            App.persist(); UI.renderAuto()
            App.report(Store.Auto.CycleEnabled and "Avatar cycle on." or "Avatar cycle off.","info")
        end
    end
    UI.connect(lp.Chatted,chat)
    pcall(function()
        local tcs=game:GetService("TextChatService")
        -- "/e copier" is handled by Roblox's emote command, so it never reaches the chat window.
        pcall(function()
            local commands=tcs:FindFirstChild("TextChatCommands")
            local emote=commands and commands:FindFirstChild("RBXEmoteCommand")
            if emote then UI.connect(emote.Triggered,function(source,text) if (not source or source.UserId==lp.UserId) and type(text)=="string" then chat(text) end end) end
        end)
        UI.connect(tcs.MessageReceived,function(message) if message.TextSource and message.TextSource.UserId==lp.UserId then chat(message.Text) end end)
        local command=UI.new("TextChatCommand",{Name="LyraCopierCommand",PrimaryAlias="/copier",SecondaryAlias="/hub"},tcs)
        UI.ChatCommand=command
        UI.connect(command.Triggered,function(source) if not source or source.UserId==lp.UserId then chat("/copier") end end)
    end)
end

-- At most two invites ever: 5 minutes into the first session, then 1 minute into the 10th run after
-- that. Never without saved data, since the counters would reset every run.
function UI.schedulePromo()
    if type(writefile)~="function" or Store.ReadOnly then return end
    local promo=Store.Promo
    if promo.Shown>=2 then return end
    promo.Runs=math.min(promo.Runs+1,1000)
    if not App.persist() then return end
    local second=promo.Shown==1
    if second and (promo.Runs<10 or promo.Runs<=promo.FirstAt) then return end
    task.delay(second and 60 or 300,function()
        if not App.alive() or not Store.Settings.Notifications or not UI.Toasts then return end
        promo.Shown=promo.Shown+1
        if promo.Shown==1 then promo.FirstAt=promo.Runs end
        App.persist()
        local function join()
            local copy=type(setclipboard)=="function" and setclipboard or type(toclipboard)=="function" and toclipboard or nil
            if copy and pcall(copy,App.Creator.Discord) then App.report("Discord invite copied. Paste it in your browser to join.","success"); return end
            UI.Minimized=false; UI.setVisible(true); UI.layout(false); UI.selectTab("Creator")
        end
        UI.Toasts:Notify({Featured=true,Dismissible=false,Kind="info",Image=UI.LogoImage,Icon="discord",Duration=15,
            Title=second and "You're one of the regulars!" or "Enjoying Avatar Studio?",
            Text=second and "Join the Lyra Discord: new features land there first, plus requests, sneak peeks and help."
                or "Join the Lyra Discord to get updates first, request features and get help fast.",
            Action={Text="Join the Discord",Callback=join}})
    end)
end

-- Skin overlay: a separate local model that follows a character every frame, so the game's rig,
-- animations and movement stay untouched. Used for skin sync and visual-only mode.
--   joints: standard rigs. The overlay root follows the real root and each joint copies the real limb's rotation.
--   parts:  everything else. Each overlay part is placed on the visible part with the same name.
Overlay.EvadeGame = 3647333358
function Overlay.visualOnly()
    return Store.Settings.VisualOnly == true or game.GameId == Overlay.EvadeGame
end
-- Kept in the camera: local only, and out of reach of game scripts that scan workspace for characters.
function Overlay.folder()
    local parent = workspace.CurrentCamera or workspace
    local folder = Overlay.Folder
    if folder then
        local moved = pcall(function() if folder.Parent ~= parent then folder.Parent = parent end end)
        if moved and folder.Parent == parent then return folder end
    end
    folder = Instance.new("Folder"); folder.Name = "LyraSkinOverlays"; folder.Parent = parent
    Overlay.Folder = folder
    return folder
end
-- Some games draw the visible body as a separate model named after the player, jointed to the
-- character's root (Evade keeps it in workspace.Rigs). The overlay follows and hides that model.
function Overlay.renderRig(character)
    local root = character:FindFirstChild("HumanoidRootPart")
    local player = Players:GetPlayerFromCharacter(character)
    if not root or not player then return nil end
    local function check(model)
        if not model or model == character or not model:IsA("Model") then return nil end
        for _, item in ipairs(model:GetDescendants()) do
            if item:IsA("JointInstance") or item:IsA("WeldConstraint") then
                local ok, linked = pcall(function() return item.Part0 == root or item.Part1 == root end)
                if ok and linked then return model end
            end
        end
        return nil
    end
    local found = check(workspace:FindFirstChild(player.Name))
    if found then return found end
    for _, holder in ipairs(workspace:GetChildren()) do
        if holder ~= character and (holder:IsA("Folder") or holder:IsA("Model")) then
            found = check(holder:FindFirstChild(player.Name))
            if found then return found end
        end
    end
    return nil
end
function Overlay.target(character)
    return Overlay.renderRig(character) or character
end
function Overlay.rigType(character)
    return F.getTrueRigType(Overlay.target(character)) or F.getTrueRigType(character)
end
-- Root height above the feet when standing (Roblox's HipHeight rule).
function Overlay.standHeight(model)
    local hum = model:FindFirstChildOfClass("Humanoid")
    local root = model:FindFirstChild("HumanoidRootPart")
    if not hum or not root or not root:IsA("BasePart") then return nil end
    local height = hum.HipHeight + root.Size.Y / 2
    if F.getTrueRigType(model) == Enum.HumanoidRigType.R6 then
        local leg = model:FindFirstChild("Left Leg")
        height = height + (leg and leg:IsA("BasePart") and leg.Size.Y or 2)
    end
    return height
end
-- Measured on the real geometry: an avatar's HipHeight doesn't always match its legs (Korblox),
-- which made skins hover.
function Overlay.restHeight(model)
    local root = model:FindFirstChild("HumanoidRootPart")
    if not root or not root:IsA("BasePart") then return nil end
    local lowest
    for _, part in ipairs(model:GetChildren()) do
        if part:IsA("BasePart") and part ~= root and Appearance.isBody(part, model) then
            local cf, half = part.CFrame, part.Size / 2
            for _, x in ipairs({-1, 1}) do
                for _, y in ipairs({-1, 1}) do
                    for _, z in ipairs({-1, 1}) do
                        local point = cf * Vector3.new(half.X * x, half.Y * y, half.Z * z)
                        if not lowest or point.Y < lowest then lowest = point.Y end
                    end
                end
            end
        end
    end
    return lowest and root.Position.Y - lowest or nil
end
-- Turns a built avatar into a puppet: no physics, no Animator, root anchored.
function Overlay.prepare(model)
    local hum = model:FindFirstChildOfClass("Humanoid")
    -- Off before the model enters the world: a live Humanoid turns its head/torso collisions back on.
    if hum then pcall(function() hum.EvaluateStateMachine = false end) end
    UI.preparePreview(model, Overlay.folder())
    model.Name = "LyraSkinOverlay"
    -- Measured now, while the model is still in its rest pose (preparePreview just posed it from its joints).
    local stand = Overlay.restHeight(model)
    if stand then model:SetAttribute("LyraStandHeight", stand) end
    pcall(function()
        hum.EvaluateStateMachine = false
        hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
        hum.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
        hum.RequiresNeck = false; hum.BreakJointsOnDeath = false
    end)
    -- Only the copied joint transforms may move the overlay's joints.
    for _, item in ipairs(model:GetDescendants()) do
        if item:IsA("Animator") then item:Destroy()
        elseif item:IsA("BasePart") then item.Massless = true end
    end
end
function Overlay.setMode(entry, mode)
    if entry.Mode == mode then return end
    entry.Mode = mode
    local model = entry.Model
    for _, item in ipairs(model:GetDescendants()) do
        if item:IsA("Motor6D") or item:IsA("AnimationConstraint") then item.Enabled = mode == "joints" end
    end
    for _, part in ipairs(model:GetChildren()) do
        if part:IsA("BasePart") and (part.Name == "HumanoidRootPart" or Appearance.isBody(part, model)) then
            part.Anchored = mode == "parts" or part.Name == "HumanoidRootPart"
        end
    end
end
function Overlay.build(data, rig)
    local desc = Codec.decode(data)
    local built, model = pcall(Visual.model, data, desc, rig); desc:Destroy()
    assert(built and model, tostring(model))
    Overlay.prepare(model)
    return model
end
function Overlay.showLocal(character, source)
    local model = source:Clone(); assert(model, "Could not prepare the avatar.")
    Overlay.prepare(model)
    Overlay.attach(character, model, true, "local")
end
function Overlay.original(entry, item)
    if entry.HiddenProp[item] == "Transparency" then return entry.Hidden[item] end
    return item.Transparency
end
-- Some games nest the visible body. A body part with no visible direct child falls back to parts of
-- that name deeper in the model, outside tools.
function Overlay.bodyParts(entry, model)
    local direct, nested = {}, {}
    for _, item in ipairs(model:GetDescendants()) do
        if item:IsA("BasePart") and item.Name ~= "HumanoidRootPart" and S.BD[item.Name] ~= nil and not item:FindFirstAncestorOfClass("Tool") then
            local group = item.Parent == model and direct or nested
            local list = group[item.Name]
            if not list then list = {}; group[item.Name] = list end
            table.insert(list, item)
        end
    end
    local found = {}
    for name, list in pairs(direct) do
        local visible = false
        for _, item in ipairs(list) do if Overlay.original(entry, item) < 1 then visible = true; break end end
        found[name] = visible and list or nil
    end
    for name, list in pairs(nested) do
        if not found[name] then
            local merged = table.clone(direct[name] or {})
            for _, item in ipairs(list) do table.insert(merged, item) end
            found[name] = merged
        end
    end
    return found
end
function Overlay.pick(entry, list)
    local best, bestScore
    for _, item in ipairs(list or {}) do
        local score = Overlay.original(entry, item) + (item.Parent == entry.Target and 0 or 0.001)
        if not best or score < bestScore then best, bestScore = item, score end
    end
    return best
end
function Overlay.jointInfo(joint)
    if joint:IsA("Motor6D") then return joint.Part0, joint.Part1, joint.C0, joint.C1 end
    local a0, a1 = joint.Attachment0, joint.Attachment1
    if a0 and a1 then return a0.Parent, a1.Parent, a0.CFrame, a1.CFrame end
end
-- Joints are paired by part names because games rename or rebuild joints. The real joint, when there
-- is one, only lends its animation offset.
function Overlay.pairJoints(entry, model, target, found, realRoot)
    local realJoints = {}
    for _, item in ipairs(target:GetDescendants()) do
        if (item:IsA("Motor6D") or item:IsA("AnimationConstraint")) and not item:FindFirstAncestorOfClass("Tool") then
            local ok, a, b = pcall(Overlay.jointInfo, item)
            if ok and a and b then
                local key = a.Name .. "|" .. b.Name
                if realJoints[key] == nil then realJoints[key] = item end
            end
        end
    end
    local function realPart(name)
        if name == "HumanoidRootPart" then return realRoot end
        return Overlay.pick(entry, found[name])
    end
    local rows, total = {}, 0
    for _, item in ipairs(model:GetDescendants()) do
        if item:IsA("Motor6D") or item:IsA("AnimationConstraint") then
            local ok, p0, p1, c0, c1 = pcall(Overlay.jointInfo, item)
            if ok and p0 and p1 and c0 and c1 and S.BD[p1.Name] ~= nil and p1.Parent == model then
                total = total + 1
                local a, b = realPart(p0.Name), realPart(p1.Name)
                if a and b then
                    local toOwn = (c0 - c0.Position):Inverse()
                    local realJoint = realJoints[p0.Name .. "|" .. p1.Name]
                    local shift
                    if realJoint then
                        local okReal, _, _, realC0 = pcall(Overlay.jointInfo, realJoint)
                        if okReal and realC0 then shift = toOwn * (realC0 - realC0.Position) end
                    end
                    table.insert(rows, {item, realJoint, a, b, toOwn, c1 - c1.Position, shift})
                end
            end
        end
    end
    return rows, total
end
function Overlay.link(entry)
    local character, model = entry.Character, entry.Model
    local target = Overlay.target(character)
    entry.Target = target
    local root, realRoot = model:FindFirstChild("HumanoidRootPart"), character:FindFirstChild("HumanoidRootPart")
    if realRoot and not realRoot:IsA("BasePart") then realRoot = nil end
    entry.Root, entry.RealRoot = root, realRoot
    local found = Overlay.bodyParts(entry, target)
    entry.Found = next(found) ~= nil
    entry.RealHead = Overlay.pick(entry, found.Head)
    local rows, total = Overlay.pairJoints(entry, model, target, found, realRoot)
    -- A separate render model (Evade) moves its parts itself, sliding and crouching included: parts mode follows it
    -- exactly. Joints mode is for characters whose own body is the visible one.
    if target == character and root and realRoot and total >= 5 and #rows >= total * 0.8 then
        Overlay.setMode(entry, "joints")
        -- The overlay's lowest point lands where the character stands: never above it, never pushed below it.
        local own, real = model:GetAttribute("LyraStandHeight") or Overlay.standHeight(model), Overlay.standHeight(character)
        entry.Lift = CFrame.new(0, (own and real) and (own - real) or 0, 0)
        -- Copy the limb's rotation relative to its parent in the overlay joint's own axes. Games build joints
        -- with different C0/C1 axes, so copying Transform as is would twist the limbs.
        entry.Joints, entry.Links = rows, {}
        return
    end
    Overlay.setMode(entry, "parts")
    -- Parts the target does not have follow the character's root with their rest-pose offset.
    local links = {}
    for _, part in ipairs(model:GetChildren()) do
        if part:IsA("BasePart") and part.Anchored then
            local real = part.Name == "HumanoidRootPart" and realRoot or Overlay.pick(entry, found[part.Name])
            if real then table.insert(links, {part, real})
            elseif root and realRoot then table.insert(links, {part, realRoot, root.CFrame:ToObjectSpace(part.CFrame)})
            else part.Transparency = 1 end
        end
    end
    entry.Joints, entry.Links = {}, links
end
-- Your own character is hidden with Transparency because the camera rewrites its LocalTransparencyModifier.
-- Other characters use LocalTransparencyModifier; a separate render model uses Transparency.
function Overlay.hide(entry)
    local character = entry.Character
    local function hide(item, property)
        local ok, current = pcall(function() return item[property] end)
        if not ok or current == 1 then return end
        if entry.Hidden[item] == nil then entry.Hidden[item] = current; entry.HiddenProp[item] = property end
        pcall(function() item[property] = 1 end)
    end
    local function sweep(model)
        local property = (model ~= character or entry.Local) and "Transparency" or "LocalTransparencyModifier"
        for _, list in pairs(Overlay.bodyParts(entry, model)) do
            for _, part in ipairs(list) do
                hide(part, property)
                for _, decal in ipairs(part:GetChildren()) do if decal:IsA("Decal") then hide(decal, property) end end
            end
        end
        for _, item in ipairs(model:GetDescendants()) do
            if item:IsA("Accessory") and not item:FindFirstAncestorOfClass("Tool") then
                for _, child in ipairs(item:GetDescendants()) do if child:IsA("BasePart") or child:IsA("Decal") then hide(child, property) end end
            end
        end
    end
    sweep(character)
    if entry.Target and entry.Target ~= character and entry.Target.Parent then sweep(entry.Target) end
end
function Overlay.inert(entry)
    for _, item in ipairs(entry.Model:GetDescendants()) do
        if item:IsA("BasePart") and (item.CanCollide or item.CanQuery or item.CanTouch) then
            item.CanCollide = false; item.CanQuery = false; item.CanTouch = false
        end
    end
end
function Overlay.attach(character, model, isLocal, key)
    Overlay.clear(character)
    local entry = {Character = character, Model = model, Links = {}, Joints = {}, Hidden = {}, HiddenProp = {}, Local = isLocal, Key = key}
    local copied, spare = pcall(function() return model:Clone() end)
    entry.Spare = copied and spare or nil
    Overlay.Active[character] = entry
    Overlay.link(entry)
    Overlay.hide(entry)
    Overlay.start()
    return entry
end
-- The game removed the overlay (cleared the camera, for example).
function Overlay.revive(entry)
    entry.Revives = (entry.Revives or 0) + 1
    if entry.Revives > 20 then return false end
    local moved = pcall(function() entry.Model.Parent = Overlay.folder() end)
    if not moved or not entry.Model:IsDescendantOf(workspace) then
        if not entry.Spare then return false end
        local copied, model = pcall(function() return entry.Spare:Clone() end)
        if not copied or not model then return false end
        pcall(function() entry.Model:Destroy() end)
        model.Parent = Overlay.folder(); entry.Model = model; entry.Close = nil; entry.Mode = nil
    end
    Overlay.link(entry)
    return true
end
function Overlay.clear(character)
    local entry = character and Overlay.Active[character]
    if not entry then return end
    Overlay.Active[character] = nil
    for item, old in pairs(entry.Hidden) do
        local property = entry.HiddenProp[item]
        pcall(function() if item.Parent then item[property] = old end end)
    end
    pcall(function() entry.Model:Destroy() end)
    if entry.Spare then pcall(function() entry.Spare:Destroy() end) end
end
function Overlay.clearAll()
    for character in pairs(Overlay.Active) do Overlay.clear(character) end
    if Overlay.Connection then Overlay.Connection:Disconnect(); Overlay.Connection = nil end
    if Overlay.Folder then pcall(function() Overlay.Folder:Destroy() end); Overlay.Folder = nil end
end
function Overlay.start()
    if Overlay.Connection then return end
    local frame = 0
    Overlay.Connection = RS.RenderStepped:Connect(function()
        frame = frame + 1
        local parts, frames = {}, {}
        local camera = workspace.CurrentCamera
        for character, entry in pairs(Overlay.Active) do
            if not character.Parent then
                Overlay.clear(character)
            elseif not entry.Model.Parent or not entry.Model:IsDescendantOf(workspace) then
                if not Overlay.revive(entry) then Overlay.clear(character) end
            else
                local stale = false
                if entry.Mode == "joints" then
                    local realRoot = entry.RealRoot
                    if realRoot and realRoot.Parent then parts[#parts + 1] = entry.Root; frames[#frames + 1] = realRoot.CFrame * entry.Lift
                    else stale = true end
                    for _, row in ipairs(entry.Joints) do
                        local a, b = row[3], row[4]
                        if a.Parent and b.Parent then
                            local relative = a.CFrame:ToObjectSpace(b.CFrame)
                            local turn = row[5] * (relative - relative.Position) * row[6]
                            local real = row[2]
                            if row[7] and real and real.Parent then turn = CFrame.new(row[7] * real.Transform.Position) * turn end
                            row[1].Transform = turn
                        else stale = true end
                    end
                else
                    for _, link in ipairs(entry.Links) do
                        if link[2].Parent then parts[#parts + 1] = link[1]; frames[#frames + 1] = link[3] and link[2].CFrame * link[3] or link[2].CFrame
                        else stale = true end
                    end
                end
                if entry.Target ~= character and not (entry.Target and entry.Target.Parent) then stale = true end
                -- Twice a second: relink rebuilt parts, hide what loaded late and keep the overlay out of physics.
                if frame % 30 == 0 then
                    Overlay.folder()
                    if stale or (entry.Target == character and not entry.Found) then Overlay.link(entry) end
                    Overlay.hide(entry); Overlay.inert(entry)
                end
                -- In first person your own overlay would cover the camera, so it fades with the real head.
                if entry.Local and camera then
                    local head = entry.RealHead or character:FindFirstChild("Head")
                    local close = false
                    if head and head.Parent then
                        local faded = false
                        pcall(function() faded = head.LocalTransparencyModifier >= 0.5 end)
                        close = faded or (camera.CFrame.Position - head.Position).Magnitude < 0.75
                    end
                    if close ~= entry.Close then
                        entry.Close = close
                        for _, item in ipairs(entry.Model:GetDescendants()) do
                            if item:IsA("BasePart") or item:IsA("Decal") then pcall(function() item.LocalTransparencyModifier = close and 1 or 0 end) end
                        end
                    end
                end
            end
        end
        if #parts > 0 then pcall(function() workspace:BulkMoveTo(parts, frames, Enum.BulkMoveMode.FireCFrameChanged) end) end
        if next(Overlay.Active) == nil and Overlay.Connection then Overlay.Connection:Disconnect(); Overlay.Connection = nil end
    end)
end

-- Skin sync: while the setting is on, the skin you wear is posted to the sync server for this Roblox
-- server only, and other script users' skins are drawn over their characters on your screen.
Sync.Url = type(Config.SyncUrl) == "string" and Config.SyncUrl or ""
Sync.Interval = 8
function Sync.requestFn()
    return type(request) == "function" and request or type(http_request) == "function" and http_request
        or (type(syn) == "table" and type(syn.request) == "function" and syn.request) or nil
end
function Sync.enabled()
    return Store.Settings.SkinSync == true and App.alive() and not Sync.Closed and Sync.Url ~= "" and game.JobId ~= "" and Sync.requestFn() ~= nil
end
function Sync.call(body)
    local requestFn = Sync.requestFn(); if not requestFn then return nil end
    local ok, response = pcall(requestFn, {Url = Sync.Url, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = HttpService:JSONEncode(body)})
    if not ok or type(response) ~= "table" or type(response.Body) ~= "string" then return nil end
    local decoded, reply = pcall(function() return HttpService:JSONDecode(response.Body) end)
    return decoded and type(reply) == "table" and reply or nil
end
-- FNV-1a (32-bit) plus the length: only used to notice that a skin changed.
function Sync.hash(text)
    local h = 2166136261
    for i = 1, #text do h = bit32.bxor(h, string.byte(text, i)); h = (bit32.lshift(h, 24) + h * 403) % 4294967296 end
    return string.format("%08x%08x", h, #text)
end
function Sync.mine()
    local snapshot = App.Current
    if not snapshot or snapshot.Original or type(snapshot.Data) ~= "table" then return nil end
    if Sync.MineFor ~= snapshot then
        local ok, text = pcall(function() return HttpService:JSONEncode({Version = 2, Data = snapshot.Data}) end)
        Sync.MineFor = snapshot
        Sync.MineText = ok and type(text) == "string" and #text <= 250000 and text or nil
        Sync.MineHash = Sync.MineText and Sync.hash(Sync.MineText) or nil
    end
    return Sync.MineText, Sync.MineHash
end
-- Another user's skin is untrusted: it goes through the same checks as an imported skin code.
function Sync.decode(text)
    assert(type(text) == "string" and #text <= 262144, "Invalid skin.")
    local ok, packet = pcall(function() return HttpService:JSONDecode(text) end)
    assert(ok and type(packet) == "table" and packet.Version == 2 and type(packet.Data) == "table", "Invalid skin.")
    if packet.Data.Visual then Visual.validate(packet.Data.Visual) end
    local valid, desc = pcall(Codec.decode, packet.Data)
    assert(valid and desc, "Invalid skin.")
    local data = Codec.encode(desc); desc:Destroy(); data.Visual = packet.Data.Visual
    return data
end
function Sync.beat()
    local text, hash = Sync.mine()
    local body = {a = "beat", job = game.JobId, user = lp.UserId, hash = hash or ""}
    if hash and Sync.Sent ~= hash then body.data = text end
    local reply = Sync.call(body)
    if not reply or reply.ok ~= true then return end
    if hash and reply.need then
        body.data = text
        reply = Sync.call(body)
        if not reply or reply.ok ~= true then return end
    end
    Sync.Sent = hash
    local listed = {}
    if type(reply.peers) == "table" then
        for _, peer in ipairs(reply.peers) do
            if type(peer) == "table" and type(peer.user) == "number" and type(peer.hash) == "string" then listed[peer.user] = peer.hash end
        end
    end
    Sync.Peers = listed
end
function Sync.draw()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= lp then
            local uid, character = player.UserId, player.Character
            local hash, shown = Sync.Peers[uid], Sync.Shown[uid]
            if not hash then
                if shown then Sync.Shown[uid] = nil; if character then Overlay.clear(character) end end
            else
                if not shown or shown.Hash ~= hash or (not shown.Data and os.clock() >= shown.Retry) then
                    local reply = Sync.call({a = "get", job = game.JobId, user = lp.UserId, peer = uid})
                    local ok, data = pcall(function()
                        assert(reply and reply.ok == true and reply.hash == hash, "Skin unavailable.")
                        return Sync.decode(reply.data)
                    end)
                    shown = {Hash = hash, Data = ok and data or nil, Retry = os.clock() + 8, BuildFails = 0}
                    Sync.Shown[uid] = shown
                end
                local entry = character and Overlay.Active[character]
                if shown.Data and character and character.Parent and (not entry or entry.Key ~= hash) and os.clock() >= (shown.BuildRetry or 0) then
                    local rig = Overlay.rigType(character)
                    if rig and character:FindFirstChildOfClass("Humanoid") then
                        local ok, model = pcall(Overlay.build, shown.Data, rig)
                        if ok and model then
                            if Sync.enabled() and character.Parent and Sync.Peers[uid] == hash then Overlay.attach(character, model, false, hash)
                            else pcall(function() model:Destroy() end) end
                        else
                            -- Back off 10 s per failed build, up to 60 s.
                            shown.BuildFails = (shown.BuildFails or 0) + 1
                            shown.BuildRetry = os.clock() + math.min(60, 10 * shown.BuildFails)
                        end
                    end
                end
            end
        end
    end
    for uid in pairs(Sync.Shown) do if not Players:GetPlayerByUserId(uid) then Sync.Shown[uid] = nil end end
end
function Sync.start()
    if Sync.Running then return end
    Sync.Running = true
    task.spawn(function()
        local lastBeat = -math.huge
        while App.alive() and not Sync.Closed do
            if Sync.enabled() then
                local _, hash = Sync.mine()
                -- Every Interval seconds, or after 5 s when your avatar just changed.
                if os.clock() - lastBeat >= Sync.Interval or ((Sync.Woken or hash ~= Sync.Sent) and os.clock() - lastBeat >= 5) then
                    Sync.Woken = false; lastBeat = os.clock()
                    pcall(Sync.beat)
                end
                pcall(Sync.draw)
            end
            task.wait(2)
        end
        Sync.Running = false
    end)
end
function Sync.wake() Sync.Woken = true; Sync.Sent = nil end
function Sync.stop()
    Sync.Peers = {}; table.clear(Sync.Shown); Sync.Sent = nil
    for character, entry in pairs(Overlay.Active) do if not entry.Local then Overlay.clear(character) end end
    if Sync.Url ~= "" and Sync.requestFn() and game.JobId ~= "" then task.spawn(Sync.call, {a = "leave", job = game.JobId, user = lp.UserId}) end
end
function Sync.close() Sync.Closed = true; Sync.stop() end

local function cleanup()
    if App.Closed then return end
    Repair.stop(); F.AnimSerial = F.AnimSerial + 1
    App.Closed=true; App.QueryToken=App.QueryToken+1; S.operationSerial=(S.operationSerial or 0)+1
    _G.Copier_TargetID=nil; _G.ToolsGiverActive=false
    if S.freeCamActive then pcall(F.disableFreeCam) end
    pcall(F.unlockCamera); pcall(F.resumeCamScripts)
    if _G.Copier_UIHidden then pcall(F.ToggleUI) end
    for _,connection in ipairs(OwnedConnections) do pcall(function() connection:Disconnect() end) end; table.clear(OwnedConnections)
    for _,group in pairs(UI.Rows) do for _,connection in ipairs(group) do connection:Disconnect() end end
    for _,tween in pairs(UI.Tweens) do pcall(function() tween:Cancel() end) end
    if UI.Toasts then pcall(function() UI.Toasts:Destroy() end) end
    pcall(UI.clearMenuAvatar)
    pcall(Sync.close); pcall(Overlay.clearAll)
    for _,item in ipairs({UI.Gui,UI.Blur,UI.ChatCommand}) do if item then pcall(function() item:Destroy() end) end end
    if S.cD then pcall(function() S.cD:Destroy() end) end
    if S.customDesc then pcall(function() S.customDesc:Destroy() end) end
    if App.ModelCache then pcall(function() App.ModelCache.Model:Destroy() end); App.ModelCache=nil end
    if App.SavedPreviewDesc then pcall(function() App.SavedPreviewDesc:Destroy() end) end
    Visual.clearCache()
    for _,row in pairs(App.Cache) do pcall(function() row.Profile.Description:Destroy() end) end
    if _G.Copier_LeftToolClone then pcall(function() _G.Copier_LeftToolClone:Destroy() end); _G.Copier_LeftToolClone=nil end
    _G.Copier_HookContext=nil; _G.Copier_ToolsGiverToggle=nil
end
_G.Copier_Cleanup=cleanup

local built,buildError=xpcall(function()
    -- Start hidden without the floating button waits (2 s at most) to know if chat can reopen the window.
    UI.detectChat()
    if Store.Settings.StartHidden and not Store.Settings.MobileOrb then
        local deadline=os.clock()+2
        while not UI.ChatChecked and os.clock()<deadline do task.wait(0.05) end
    end
    UI.buildShell(); UI.buildAvatar(); UI.buildPlayers(); UI.buildCollection(); UI.buildLooks(); UI.buildCatalog(); UI.buildAuto(); UI.buildSettings(); UI.buildCreator(); UI.buildModal(); UI.inputs()
    App.Notify=function(message,kind)
        local colors={error=UI.C.Red,warning=UI.C.Gold,success=UI.C.Green,loading=UI.C.Accent,info=UI.C.Muted}
        UI.StatusText.Text=message; UI.StatusText.TextColor3=colors[kind] or UI.C.Muted; UI.StatusDot.BackgroundColor3=colors[kind] or UI.C.Accent
        if kind=="error" then warn("[Lyra Avatar Studio] "..message) end
    end
    App.Refresh=UI.refresh
    UI.Toasts=Toast.new({Parent=UI.Surface,Font=UI.Font,Max=4,Margin=10,
        Icon=function(parent,name,position,color)
            assert(UI.IconSheet and UI.IconIndex[UI.IconAlias[name] or name],"Icon sheet unavailable")
            return UI.icon(parent,name,position,color)
        end,
        Theme={Background=UI.C.Base,Text=UI.C.Text,Muted=UI.C.Muted,Line=UI.C.Line,
            Kinds={info=UI.C.Accent,success=UI.C.Green,warning=UI.C.Gold,error=UI.C.Red}},
        ReducedMotion=function() return Store.Settings.ReducedMotion end})
    App.ToastSink=function(spec) UI.Toasts:Notify(spec) end
    App.captureInitial(lp.Character)
    UI.selectTab("Avatar"); UI.refresh(); UI.layout(true)
    task.defer(function() if App.alive() then UI.layout(true); if Store.LoadIssue then App.report(Store.LoadIssue,"warning") end end end)
    if Config.TargetUsername~="" and (Config.CopyAvatar or Config.CopyAvatarHD) then
        UI.SearchBox.Text=Config.TargetUsername; UI.query(Config.TargetUsername,true)
    end
    Auto.startTimer()
    if not UI.Visible then UI.effects(); UI.hiddenHint() end
    if UI.StartSkipped then App.report("Start hidden was skipped: nothing could reopen the window. Turn on a way to reopen it in Settings.","warning") end
    Auto.boot()
    UI.schedulePromo()
    Sync.start()
end,function(err) return tostring(err) end)
-- No GUI to show a toast in, so this one message uses Roblox's notification.
if not built then cleanup(); warn("[Lyra Avatar Studio] The hub could not be opened: "..tostring(buildError)); pcall(function() SG:SetCore("SendNotification",{Title="Avatar Studio",Text="The interface could not be opened. Check the console.",Duration=8}) end) end
