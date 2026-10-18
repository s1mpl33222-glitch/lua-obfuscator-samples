local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local Junkie = loadstring(game:HttpGet("https://jnkie.com/sdk/library.lua"))()
Junkie.service = "Frostrose"
Junkie.identifier = "1205037"
Junkie.provider = "Frostrose"

WindUI.Services.junkiedevelopment = {
    Name = "Junkie Development",
    Icon = "shield-check",
    Args = { "ServiceId", "ApiKey", "Provider" },
    New = function()
        local function Verify(key)
            local ok, result = pcall(Junkie.check_key, key)
            if not ok then
                return false, "Request failed"
            end
            if result and result.valid then
                if result.message == "KEYLESS" then
                    getgenv().SCRIPT_KEY = "KEYLESS"
                    return true, "Keyless mode"
                elseif result.message == "KEY_VALID" then
                    getgenv().SCRIPT_KEY = key
                    return true, "Key valid"
                end
            end
            return false, (result and result.error) or "Invalid key"
        end

        local function Copy()
            local ok, link, err = pcall(Junkie.get_key_link)
            if not ok then return "Request failed" end
            if link then
                if setclipboard then setclipboard(link) end
                return link
            end
            return err or "Unknown error"
        end

        return { Verify = Verify, Copy = Copy }
    end
}

local KeyWindow = WindUI:CreateWindow({
    Title = "Frost Rose",
    Theme = "Dark",
    Transparent = true,
    Resizable = true,
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

while not getgenv().SCRIPT_KEY do
    task.wait(0.1)
end

if KeyWindow then
    if KeyWindow.Destroy then
        pcall(function() KeyWindow:Destroy() end)
    elseif KeyWindow.Close then
        pcall(function() KeyWindow:Close() end)
    elseif KeyWindow.Hide then
        pcall(function() KeyWindow:Hide() end)
    elseif KeyWindow.Toggle then
        pcall(function() KeyWindow:Toggle(false) end)
    end
end

do ("JNKIE Loader - Unauthorized tampering or debugging of protected scripts is strictly prohibited and may result in a global blacklist from JNKIE protected scripts."):sub(1,1);local k=getgenv().SCRIPT_KEY or SCRIPT_KEY;local m="Could not load the script. Check your internet connection and try again later.";local function v(h)warn(h);task.spawn(function()pcall(function()game:GetService("Players").LocalPlayer:Kick(h)end);task.wait();pcall(function()local p=game:GetService("CoreGui").RobloxPromptGui.promptOverlay.ErrorPrompt;p.TitleFrame.ErrorTitle.Text="JNKIE";p.MessageArea.ErrorFrame.ErrorMessage.Text=h end)end)end;local r=(type(syn)=="table" and type(syn.request)=="function" and syn.request)or(type(request)=="function" and request)or(type(http_request)=="function" and http_request)or(type(http)=="table" and type(http.request)=="function" and http.request);if type(k)~="string" then v("No key provided. Get a key from the script provider, enter it, then try again.");return end;if type(r)~="function" then warn(m);return end;local function q(o)local d,a,x;task.spawn(function()a,x=pcall(r,o);d=true end);local s=os.clock();repeat task.wait()until d or os.clock()-s>15;if not d then return false,nil end;return a,x end;local a,x=q({Url="https://api.jnkie.com/api/v1/luascripts/delivery/bd7de287a4f4686ae3e37b7fac9452b655d6faef91a7a2fdc9376bb633d30fed?v=2&errors=text",Method="POST",Headers={["Content-Type"]="text/plain"},Body=k});local h=a and type(x)=="table" and type(x.Body)=="string" and(x.StatusCode==400 or x.StatusCode==401 or x.StatusCode==403)and x.Body;if h then local c,n=h:match("^([^\r\n]+)\n([^\r\n]+)$");c=c or h;if#c<=75 and(c=="LDR-DENIED"or c:match("^LDR%-DENIED:[A-Z_]+$"))then if not n or#n>512 then n=m;if k==""or k:match("^%s*$")then n="No key provided. Get a key from the script provider, enter it, then try again." end end;v(n.." ("..c..")");return end end;if a and type(x)=="table" and x.StatusCode==200 and type(x.Body)=="string" and (string.sub(x.Body,1,8)=="https://") then a,x=q({Url=x.Body,Method="GET"})end;if a and type(x)=="table" and(x.StatusCode==302 or x.StatusCode==303)then local h=x.Headers or x.headers;local l=type(h)=="table" and(h.Location or h.location);if type(l)=="string" and (string.sub(l,1,8)=="https://") then a,x=q({Url=l,Method="GET"})end end;if not a or type(x)~="table" or x.StatusCode~=200 or type(x.Body)~="string" or#x.Body==0 then warn(m);return end;local b=x.Body;x=nil;local f=loadstring(b);b=nil;if type(f)~="function" then warn(m);return end;f()end