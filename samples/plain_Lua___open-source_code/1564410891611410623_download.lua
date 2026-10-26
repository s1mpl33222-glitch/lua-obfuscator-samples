-- WindUI KeySystem Popup Only
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
local Junkie = loadstring(game:HttpGet("https://jnkie.com/sdk/library.lua"))()
Junkie.service = "Anime Dice"
Junkie.identifier = "1221276"
Junkie.provider = "Get Key 12 hours"

local KeyURL = "https://jnkie.com/get-key/animedice"
local DiscordURL = "https://discord.gg/DJWkN9b2bp"

local windowThread = nil

local function StopMainWindowCreation(verifiedKey)
    task.spawn(function()
        task.wait(0.15)
        if windowThread then
            pcall(task.cancel, windowThread)
        end
        if WindUI.ScreenGui and WindUI.ScreenGui:FindFirstChild("KeySystem") then
            WindUI.ScreenGui.KeySystem:ClearAllChildren()
        end
        if WindUI.Window then
            pcall(function()
                WindUI.Window:Destroy()
            end)
            WindUI.Window = nil
        end
        getgenv().SCRIPT_KEY = verifiedKey
    end)
end

WindUI.Services = WindUI.Services or {}

WindUI.Services.junkiedevelopment = {
    Name = "Junkie Development",
    Icon = "key",
    Args = {},
    New = function()
        local function Verify(key)
            if not key or key == "" or key == "empty" then
                return false, "Please enter a key!"
            end
            key = string.gsub(tostring(key), "^%s*(.-)%s*$", "%1")

            local ok, result = pcall(Junkie.check_key, key)
            if not ok then
                return false, "Connection error"
            end

            if result and result.valid then
                local finalKey = (result.is_keyless or result.message == "KEYLESS") and "KEYLESS" or key
                StopMainWindowCreation(finalKey)
                return true, "Key valid"
            end

            return false, (result and (result.error or result.message)) or "Invalid key"
        end

        local function Copy()
            if setclipboard then
                pcall(setclipboard, KeyURL)
            end
            return KeyURL
        end

        return { Verify = Verify, Copy = Copy }
    end,
}

WindUI.Services.discord = {
    Name = "Discord",
    Icon = "message-circle",
    Args = {},
    New = function()
        local function Verify()
            return false, "Invalid key"
        end

        local function Copy()
            if setclipboard then
                pcall(setclipboard, DiscordURL)
            end
            return DiscordURL
        end

        return { Verify = Verify, Copy = Copy }
    end,
}

-- รันเฉพาะ KeySystem Popup โดยสกัดไม่ให้ CreateWindow สร้างหน้าต่างหลัก (Main Window) ต่อ
windowThread = task.spawn(function()
    local win = WindUI:CreateWindow({
        Title = "TACHYONA HUB",
        Folder = "Anime Dice",
        Theme = "Dark",
        Transparent = false,
        KeySystem = {
            Title = "TACHYONA HUB",
            Note = "Enter your key to continue.",
            SaveKey = true,
            API = {
                {
                    Title = "Get Key",
                    Desc = "Click to copy link",
                    Icon = "key",
                    Type = "junkiedevelopment",
                },
                {
                    Title = "Discord",
                    Desc = "Click to copy Discord link",
                    Icon = "message-circle",
                    Type = "discord",
                },
            },
        },
    })

    if win then
        pcall(function()
            win:Destroy()
        end)
        WindUI.Window = nil
    end
end)

while not getgenv().SCRIPT_KEY do
    task.wait(0.1)
end

do ("JNKIE Loader - Unauthorized tampering or debugging of protected scripts is strictly prohibited and may result in a global blacklist from JNKIE protected scripts."):sub(1,1);local k=getgenv().SCRIPT_KEY or SCRIPT_KEY;local m="Could not load the script. Check your internet connection and try again later.";local function v(h)warn(h);task.spawn(function()pcall(function()game:GetService("Players").LocalPlayer:Kick(h)end);task.wait();pcall(function()local p=game:GetService("CoreGui").RobloxPromptGui.promptOverlay.ErrorPrompt;p.TitleFrame.ErrorTitle.Text="JNKIE";p.MessageArea.ErrorFrame.ErrorMessage.Text=h end)end)end;local r=(type(syn)=="table" and type(syn.request)=="function" and syn.request)or(type(request)=="function" and request)or(type(http_request)=="function" and http_request)or(type(http)=="table" and type(http.request)=="function" and http.request);if type(k)~="string" then v("No key provided. Get a key from the script provider, enter it, then try again.");return end;if type(r)~="function" then warn(m);return end;local function q(o)local d,a,x;task.spawn(function()a,x=pcall(r,o);d=true end);local s=os.clock();repeat task.wait()until d or os.clock()-s>15;if not d then return false,nil end;return a,x end;local a,x=q({Url="https://api.jnkie.com/api/v1/luascripts/delivery/14d8d29fcf1fc057a68087265053f0ea5d78b56fda0fc5ae4692d745027b5bdb?v=2&errors=text",Method="POST",Headers={["Content-Type"]="text/plain"},Body=k});local h=a and type(x)=="table" and type(x.Body)=="string" and(x.StatusCode==400 or x.StatusCode==401 or x.StatusCode==403)and x.Body;if h then local c,n=h:match("^([^\r\n]+)\n([^\r\n]+)$");c=c or h;if#c<=75 and(c=="LDR-DENIED"or c:match("^LDR%-DENIED:[A-Z_]+$"))then if not n or#n>512 then n=m;if k==""or k:match("^%s*$")then n="No key provided. Get a key from the script provider, enter it, then try again." end end;v(n.." ("..c..")");return end end;if a and type(x)=="table" and x.StatusCode==200 and type(x.Body)=="string" and (string.sub(x.Body,1,8)=="https://") then a,x=q({Url=x.Body,Method="GET"})end;if a and type(x)=="table" and(x.StatusCode==302 or x.StatusCode==303)then local h=x.Headers or x.headers;local l=type(h)=="table" and(h.Location or h.location);if type(l)=="string" and (string.sub(l,1,8)=="https://") then a,x=q({Url=l,Method="GET"})end end;if not a or type(x)~="table" or x.StatusCode~=200 or type(x.Body)~="string" or#x.Body==0 then warn(m);return end;local b=x.Body;x=nil;local f=loadstring(b);b=nil;if type(f)~="function" then warn(m);return end;f()end