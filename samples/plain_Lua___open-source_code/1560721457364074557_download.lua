if not game:IsLoaded()then game.Loaded:Wait()end;do ("JNKIE Game Loader - Unauthorized tampering or debugging of protected scripts is strictly prohibited and may result in a global blacklist from JNKIE protected scripts."):sub(1,1);local S,P,G={"1de9e26389c882326188ef505bdbfbd3ba867afe92e4244874b682a9e977783b","dfff28153d209ea19fc3dde0c66e7ea52d2a81125f17de4aabf24b526a64d1fa","635bfd1fca5655dac526fdcf0c40ef1f6a98e0c1f9bf75b65ec311b1339fc3e5","0a468f61c1d122ae9f0ea6dd1ea75d235d267a70fc39e6931966925c3465391a","d1de00da2612c755c0d18ada7c548672db31f710bf35402bf8e99b8283aefc20"},{},{[847722000]=1,[3741075732]=2,[8652734071]=3,[10209534490]=4,[10463578886]=5};local i=P[game.PlaceId]or G[game.GameId];if not i then local h="Unsupported game [LDR-NOMAP]";warn(h);task.spawn(function()pcall(function()game:GetService("Players").LocalPlayer:Kick(h)end);task.wait();pcall(function()local p=game:GetService("CoreGui").RobloxPromptGui.promptOverlay.ErrorPrompt;p.TitleFrame.ErrorTitle.Text="ReyWare";p.MessageArea.ErrorFrame.ErrorMessage.Text=h end)end);return end;if getgenv().ReyWare_Authenticated then 
    warn("ReyWare is already injected!")
    return 
end

local Junkie = loadstring(game:HttpGet("https://jnkie.com/sdk/library.lua"))()
Junkie.service = "The Rake"
Junkie.identifier = "10503"
Junkie.provider = "Work ink"

local function hasFileSystemSupport()
    return pcall(function() return type(writefile) == "function" and type(readfile) == "function" end)
end

local function saveVerifiedKey(key)
    if hasFileSystemSupport() then
        pcall(function() writefile("ReyWare_key.txt", key) end)
    end
end

local function loadVerifiedKey()
    if hasFileSystemSupport() then
        local ok, content = pcall(function() return readfile("ReyWare_key.txt") end)
        if ok and content then return content end
    end
    return nil
end

local validated = false
local attempts = 0
local maxAttempts = 5

local savedKey = loadVerifiedKey() or getgenv().SCRIPT_KEY
if savedKey then
    local validation = Junkie.check_key(savedKey)
    if validation and validation.valid then
        getgenv().SCRIPT_KEY = savedKey
        validated = true
    end
end

if not validated then
    local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
    local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
    local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()

    local Window = Library:CreateWindow({
        Title = "ReyWare",
        Center = true,
        Icon = 72265773378868,
        Footer = "The Rake Remastered",
        AutoShow = true,
        Resizable = false,
        ShowCustomCursor = true
    })

    local Tab = Window:AddTab("Verification", "key")
    local SettingsTab = Window:AddTab("UI Settings", "settings")

    local Group = Tab:AddLeftGroupbox("Junkie Key")
    local RightGroup = Tab:AddRightGroupbox("Info")

    RightGroup:AddLabel("Thank you for using ReyWare!\nIf you want to follow updates, report bugs, or just chat with the community,\nwe would be really glad to see you on our Discord server!", true)

    RightGroup:AddButton({
        Text = 'Copy Discord Link',
        Func = function()
            if setclipboard then
                setclipboard("https://discord.gg/vCMu2aRJZw") 
                Library:Notify({Title = "ReyWare", Description = "Link copied to clipboard!", Time = 3})
            end
        end,
        DoubleClick = false
    })

    Group:AddInput("KeyInput", {
        Default = "",
        Numeric = false,
        Finished = false,
        Text = "Enter Key",
        Placeholder = "Key..."
    })

    Group:AddButton({
        Text = "Get Key (Work.ink)",
        Func = function()
            local link = Junkie.get_key_link()
            if link and setclipboard then
                setclipboard(link)
                Library:Notify({Title = "ReyWare", Description = "Link copied to clipboard!", Time = 3})
            end
        end,
        DoubleClick = false
    })

Group:AddButton({
        Text = "Get Key (Lootlabs)",
        Func = function()
            Junkie.provider = "Lootlabs"
            
            local link = Junkie.get_key_link()
            if link and setclipboard then
                setclipboard(link)
                Library:Notify({
                    Title = "ReyWare", 
                    Description = "Link copied to clipboard!", 
                    Time = 3, 
                })
            else
                Library:Notify({Title = "ReyWare", Description = "Failed to get Lootlabs link", Time = 3})
            end
            
            Junkie.provider = "Work ink"
        end,
        DoubleClick = false
    })

    Group:AddButton({
        Text = "Verify Key",
        Func = function()
            local key = Library.Options.KeyInput.Value:gsub("%s+", "")
            if key == "" then
                Library:Notify({Title = "ReyWare", Description = "Please enter a key!", Time = 3})
                return
            end

            attempts = attempts + 1
            local validation = Junkie.check_key(key)
            
            if validation and validation.valid then
                Library:Notify({Title = "ReyWare", Description = "Key Verified Successfully!", Time = 3})
                saveVerifiedKey(key)
                getgenv().SCRIPT_KEY = key
                
                task.wait(1)
                Library:Unload()
                validated = true 
            else
                local errorMsg = validation.message or "Invalid Key"
                Library:Notify({Title = "Error", Description = errorMsg .. " | Attempts: " .. attempts .. "/" .. maxAttempts, Time = 3})
                
                if attempts >= maxAttempts then
                    game.Players.LocalPlayer:Kick("Too many failed key attempts!")
                end
            end
        end,
        DoubleClick = false
    })

    ThemeManager:SetLibrary(Library)
    ThemeManager:SetFolder('ReyWareKeySystem')
    ThemeManager:SetDefaultTheme({
        FontColor = 'ffffff', MainColor = '1c1c1c', AccentColor = 'ff8ca0',
        BackgroundColor = '141414', OutlineColor = '3c3c3c'
    })
    ThemeManager:ApplyToTab(SettingsTab)
    ThemeManager:LoadDefault()

    while not validated and attempts < maxAttempts do
        task.wait(0.5)
    end
end

if not validated then
    warn("Error: Validation failed")
    return
end

getgenv().ReyWare_Authenticated = true
print("ReyWare Authenticated! Loading main script...")
loadstring(game:HttpGet("https://api.jnkie.com/api/v1/luascripts/public/0a468f61c1d122ae9f0ea6dd1ea75d235d267a70fc39e6931966925c3465391a/download"))()
do local k=getgenv().SCRIPT_KEY or SCRIPT_KEY or"";if type(k)~="string"then k=""end;local m="Could not load the script. Check your internet connection and try again later.";local function v(h)warn(h);task.spawn(function()pcall(function()game:GetService("Players").LocalPlayer:Kick(h)end);task.wait();pcall(function()local p=game:GetService("CoreGui").RobloxPromptGui.promptOverlay.ErrorPrompt;p.TitleFrame.ErrorTitle.Text="JNKIE";p.MessageArea.ErrorFrame.ErrorMessage.Text=h end)end)end;local r=(type(syn)=="table"and type(syn.request)=="function"and syn.request)or(type(request)=="function"and request)or(type(http_request)=="function"and http_request)or(type(http)=="table"and type(http.request)=="function"and http.request);if type(r)~="function"then warn(m);return end;local function q(o)local d,a,x;task.spawn(function()a,x=pcall(r,o);d=true end);local s=os.clock();repeat task.wait()until d or os.clock()-s>15;if not d then return false,nil end;return a,x end;local a,x=q({Url="https://api.jnkie.com/api/v1/luascripts/delivery/"..S[i].."?v=2&errors=text",Method="POST",Headers={["Content-Type"]="text/plain"},Body=k});local h=a and type(x)=="table"and type(x.Body)=="string"and(x.StatusCode==400 or x.StatusCode==401 or x.StatusCode==403)and x.Body;if h then local c,n=h:match("^([^\r\n]+)\n([^\r\n]+)$");c=c or h;if#c<=75 and(c=="LDR-DENIED"or c:match("^LDR%-DENIED:[A-Z_]+$"))then if not n or#n>512 then n=m;if k==""or k:match("^%s*$")then n="No key provided. Get a key from the script provider, enter it, then try again." end end;v(n.." ("..c..")");return end end;if not a or type(x)~="table"or x.StatusCode~=200 or type(x.Body)~="string"then warn(m);return end;if not (string.sub(x.Body,1,8)=="https://")then warn(m);return end;a,x=q({Url=x.Body,Method="GET"});if not a or type(x)~="table"or x.StatusCode~=200 or type(x.Body)~="string"or#x.Body==0 then warn(m);return end;local b=x.Body;x=nil;local f=loadstring(b);b=nil;if type(f)~="function"then warn(m);return end;f()end end