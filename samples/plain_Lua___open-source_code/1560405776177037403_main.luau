if not game:IsLoaded() then game.Loaded:Wait(); end;

local cloneref = cloneref or function(i: Instance) return i; end;
local clonefunction = clonefunction or function(f: (...any) -> ...any) return f; end;
local newcclosure = newcclosure or clonefunction;
local executor = identifyexecutor and identifyexecutor() or "Your executor";
local SG = loadstring(game:HttpGet("https://sneekysscripts.uk/Scripts/NOTIFICATION_LIBRARY/main.luau"))();

if not (hookfunction and require) then
    local err = executor .. " is missing " .. (not hookfunction and "hookfunction " or "") .. (not require and "require" or "");
    SG["error"](err);
    return error(err);
end;

local Players: Players = cloneref(game:GetService("Players"));
local UIS: UserInputService = cloneref(game:GetService("UserInputService"));

local plr = Players.LocalPlayer;
local cam = workspace.CurrentCamera;

local isMobile = UIS.TouchEnabled and not UIS.KeyboardEnabled and not UIS.MouseEnabled;

local s, cf = pcall(require, Players.LocalPlayer.PlayerScripts.BallisticsClient.ClientFire);
if not s then
    return warn(executor .. " returned an error while trying to require Players.LocalPlayer.PlayerScripts.BallisticsClient.ClientFire:\n" .. cf);
end;

local ign, map = workspace:FindFirstChild("Ignore"), workspace:FindFirstChild("Map");
if not (ign and map) then
    local err = "Script needs updating";
    SG["error"](err);
    return warn(err);
end;
local trigs: Model?, spawns: Model?, cams: Model?, vs: Folder?, veg: Folder?, barriers: Folder? = map:FindFirstChild("Triggers"),
    map:FindFirstChild("Spawns"),
    map:FindFirstChild("Cameras"),
    map:FindFirstChild("VehicleSpawners"),
    map:FindFirstChild("Vegetation"),
    map:FindFirstChild("Barriers");
map.ChildAdded:Connect(function(c: Instance)
    if c.Name == "Triggers" then
        trigs = c;
    elseif c.Name == "Spawns" then
        spawns = c;
    elseif c.Name == "Cameras" then
        cams = c;
    elseif c.Name == "VehicleSpawners" then
        vs = c;
    elseif c.Name == "Vegetation" then
        veg = c;
    elseif c.Name == "Barriers" then
        barriers = c;
    end;
end);

local rp = RaycastParams.new();
rp.FilterType = Enum.RaycastFilterType.Exclude;
rp.IgnoreWater = true;

local isVisible = function(part: BasePart, origin: Vector3): (boolean, Instance?, Vector3?)
    local char = plr.Character;
    if not (char and part) then return false, nil; end;

    rp.FilterDescendantsInstances = {char, ign, trigs, spawns, cams, vs, veg, barriers};

    local dir = part.Position - origin;
    local result: RaycastResult = workspace:Raycast(origin, dir, rp);
    if not result then return true, nil, nil; end;

    if result.Instance:IsDescendantOf(part.Parent) then
        return true, result.Instance, result.Position;
    end;

    return false, result.Instance, result.Position;
end;

local getTarget = function(origin: Vector3)
    if not getgenv().sneeky_silent_aim then return nil; end;
    local cPart, cDistance, cPos = nil, getgenv().sneeky_fov_size or 300, nil;

    for _, player: Player in next, Players:GetPlayers() do
        local char = player.Character;

        if player == plr or not char or plr.Team == player.Team --[[or (plr.Team == player.Team and not char:GetAttribute("DisguiseName"))]] or (player.Team and player.Team.Name == "Neutral") then continue; end;

        if char:FindFirstChildOfClass("ForceField") or (char:FindFirstChild("Humanoid") and char.Humanoid.Health <= 0.1) --[[or char:GetAttribute("DisguiseName")]] then continue; end;

        local tPart: BasePart = (getgenv().sneeky_blatant and char:FindFirstChild("Head")) or char:FindFirstChild("Torso") or char.PrimaryPart;
        if not tPart then continue; end;

        local pos, onScreen = cam:WorldToViewportPoint(tPart.Position);
        if not onScreen then continue; end;

        local v, nTPart, nTPos = isVisible(tPart, origin);
        if not v then
            v, nTPart, nTPos = isVisible(getgenv().sneeky_blatant and (char:FindFirstChild("Torso") or char.PrimaryPart) or char:FindFirstChild("Head"), origin);
            if not v then continue; end;
        end;

        if nTPart then tPart = nTPart; end;

        local distance = (Vector2.new(pos.X, pos.Y) - (isMobile and Vector2.new(cam.ViewportSize.X/2, cam.ViewportSize.Y/2) or UIS:GetMouseLocation())).Magnitude;
        if distance < cDistance then
            cPart = tPart;
            cPos = nTPos;
            cDistance = distance;
        end;
    end;

    return cPart, cPos;
end;

loadstring(game:HttpGet("https://sneekysscripts.uk/Scripts/UIs/silent_aim.luau"))()(getgenv().sneeky_fov_size or 300, getTarget, true);
-- fireVolley
local old; old = clonefunction(hookfunction((function()
    for k, v in next, cf do
        if k ~= "fire" then
            return v;
        end;
    end;
end)(), newcclosure(function(_, __, ___, origin, bi, ...)
    local c, pos = getTarget(origin);
    if c and pos then
        for i = 1, rawlen(bi), 1 do rawset(bi, i, pos - origin); end;
    end;
    return old(_, __, ___, origin, bi, ...);
end)));

SG["success"]("Silent aim successfully executed!\nIf you have any issues press F9 or type /console in chat and then send me a screenshot of the console.");
