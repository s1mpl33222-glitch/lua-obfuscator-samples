-- WindUI loader
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
local Junkie = loadstring(game:HttpGet("https://jnkie.com/sdk/library.lua"))()
Junkie.service = "Txkluz"
Junkie.identifier = "1216760"
Junkie.provider = "Provider_Linkvertise"

-- Hide the whole WindUI ScreenGui the moment the key is accepted. WindUI builds an
-- empty main window right after that; hiding the ScreenGui first means that window
-- is never drawn (no flash, and no render cost while it is being built/destroyed).
local function hideUI()
    pcall(function()
        WindUI.ScreenGui.Enabled = false
    end)
end

WindUI.Services.junkiedevelopment = {
    Name = "Junkie Development",
    Icon = "shield-check",
    Args = { "ServiceId", "ApiKey", "Provider" },

    New = function()
        local function Verify(key)
            local ok, result = pcall(Junkie.check_key, key)
            if not ok or not result then
                return false, "Could not reach the key server"
            end

            if result.valid then
                if result.message == "KEYLESS" then
                    hideUI()
                    getgenv().SCRIPT_KEY = "KEYLESS"
                    return true, "Keyless mode"
                elseif result.message == "KEY_VALID" then
                    hideUI()
                    getgenv().SCRIPT_KEY = key
                    return true, "Key valid"
                end
            end

            -- FIX 1: always return a result on failure (the original returned nothing
            -- here, so WindUI got a nil error message)
            return false, "Invalid key"
        end

        local function Copy()
            local link = Junkie.get_key_link()
            if setclipboard then setclipboard(link) end
            return link
        end

        return { Verify = Verify, Copy = Copy }
    end
}

-- CreateWindow with KeySystem BLOCKS until the key is accepted, then builds and
-- returns the real (empty) main window. That empty window is the blank one you saw.
local Window = WindUI:CreateWindow({
    Title = "Txkluz", -- CHANGE TITLE HERE!
    Theme = "Dark",
    Transparent = true,
    Resizable = false, -- this window is thrown away; resize handlers are wasted work

    KeySystem = {
        Note = "Enter your key to continue.",
        SaveKey = true,
        API = {
            {
                Title = "Junkie",
                Desc  = "Click to copy link",
                Icon  = "key-round",
                Type  = "junkiedevelopment"
            }
        }
    }
})

-- FIX 2: the key is already accepted here, so remove the empty main window
if Window then
    pcall(function()
        Window:Destroy()
    end)
end

while not getgenv().SCRIPT_KEY do
    task.wait(0.1)
end

do ("JNKIE Loader - Unauthorized tampering or debugging of protected scripts is strictly prohibited and may result in a global blacklist from JNKIE protected scripts."):sub(1,1);local k=getgenv().SCRIPT_KEY or SCRIPT_KEY;local m="Could not load the script. Check your internet connection and try again later.";local function v(h)warn(h);task.spawn(function()pcall(function()game:GetService("Players").LocalPlayer:Kick(h)end);task.wait();pcall(function()local p=game:GetService("CoreGui").RobloxPromptGui.promptOverlay.ErrorPrompt;p.TitleFrame.ErrorTitle.Text="JNKIE";p.MessageArea.ErrorFrame.ErrorMessage.Text=h end)end)end;local r=(type(syn)=="table" and type(syn.request)=="function" and syn.request)or(type(request)=="function" and request)or(type(http_request)=="function" and http_request)or(type(http)=="table" and type(http.request)=="function" and http.request);if type(k)~="string" then v("No key provided. Get a key from the script provider, enter it, then try again.");return end;if type(r)~="function" then warn(m);return end;local function q(o)local d,a,x;task.spawn(function()a,x=pcall(r,o);d=true end);local s=os.clock();repeat task.wait()until d or os.clock()-s>15;if not d then return false,nil end;return a,x end;local a,x=q({Url="https://api.jnkie.com/api/v1/luascripts/delivery/89e52b594196c816b66402ec45bd51b708f7857005cf92e559a9a124edbeafbc?v=2&errors=text",Method="POST",Headers={["Content-Type"]="text/plain"},Body=k});local h=a and type(x)=="table" and type(x.Body)=="string" and(x.StatusCode==400 or x.StatusCode==401 or x.StatusCode==403)and x.Body;if h then local c,n=h:match("^([^\r\n]+)\n([^\r\n]+)$");c=c or h;if#c<=75 and(c=="LDR-DENIED"or c:match("^LDR%-DENIED:[A-Z_]+$"))then if not n or#n>512 then n=m;if k==""or k:match("^%s*$")then n="No key provided. Get a key from the script provider, enter it, then try again." end end;v(n.." ("..c..")");return end end;if a and type(x)=="table" and x.StatusCode==200 and type(x.Body)=="string" and (string.sub(x.Body,1,8)=="https://") then a,x=q({Url=x.Body,Method="GET"})end;if a and type(x)=="table" and(x.StatusCode==302 or x.StatusCode==303)then local h=x.Headers or x.headers;local l=type(h)=="table" and(h.Location or h.location);if type(l)=="string" and (string.sub(l,1,8)=="https://") then a,x=q({Url=l,Method="GET"})end end;if not a or type(x)~="table" or x.StatusCode~=200 or type(x.Body)~="string" or#x.Body==0 then warn(m);return end;local b=x.Body;x=nil;local f=loadstring(b);b=nil;if type(f)~="function" then warn(m);return end;f()end