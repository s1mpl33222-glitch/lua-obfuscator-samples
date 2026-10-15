local cloneref = cloneref or function(i: Instance) return i; end;

local SG: StarterGui = cloneref(game:GetService("StarterGui"));
local Players: Players = cloneref(game:GetService("Players"));

local get_id = loadstring(game:HttpGet("https://sneekysscripts.uk/Scripts/FOV_LIBRARY/get_id.luau"))();

local plr = Players.LocalPlayer;

local notifs = {
    ["success"] = function(msg: string)
        if getgenv()["SNEEKY'S SCRIPTS ADVANCED SETTING: BLOCK NOTIFS"] then return; end;
        SG:SetCore("SendNotification", {
            ["Title"] = "SUCCESS - READ BELOW",
            ["Text"] = msg,
            ["Icon"] = get_id("logo");
            ["Duration"] = 60,
            ["Button1"] = "Close"
        });
    end,
    ["info"] = function(info: string)
        if getgenv()["SNEEKY'S SCRIPTS ADVANCED SETTING: BLOCK NOTIFS"] then return; end;
        SG:SetCore("SendNotification", {
            ["Title"] = "INFO - READ BELOW",
            ["Text"] = info,
            ["Icon"] = get_id("logo");
            ["Duration"] = 20,
            ["Button1"] = "Close"
        });
    end,
    ["warning"] = function(w: string)
        if getgenv()["SNEEKY'S SCRIPTS ADVANCED SETTING: BLOCK NOTIFS"] then return; end;
        SG:SetCore("SendNotification", {
            ["Title"] = "WARNING - READ BELOW",
            ["Text"] = w,
            ["Icon"] = get_id("logo");
            ["Duration"] = 30,
            ["Button1"] = "Close"
        });
    end,
    ["error"] = function(err: string)
        if getgenv()["SNEEKY'S SCRIPTS ADVANCED SETTING: BLOCK NOTIFS"] then return; end;
        SG:SetCore("SendNotification", {
            ["Title"] = "ERROR - READ BELOW",
            ["Text"] = err,
            ["Icon"] = get_id("logo");
            ["Duration"] = 60,
            ["Button1"] = "Close"
        });
    end
};

if getgenv()["SNEEKY'S SCRIPT RUNNING"] then
    notifs["warning"]("DO NOT EXECUTE THIS SCRIPT MORE THAN ONCE!");
    --task.wait(1);
    coroutine.yield();
    --plr:Kick("DO NOT EXECUTE THIS SCRIPT MORE THAN ONCE!");
    return;
end;

getgenv()["SNEEKY'S SCRIPT RUNNING"] = true;

local c; c = Players.PlayerRemoving:Connect(function(player)
    if player == plr then getgenv()["SNEEKY'S SCRIPT RUNNING"] = nil; c:Disconnect(); c = nil; end;
end);

loadstring(game:HttpGet("https://sneekysscripts.uk/Scripts/NOTIFICATION_LIBRARY/request.luau"))();

notifs["info"]("Executing...");

return notifs;
