-- Docs 
-- https://github.com/Cobruhehe/expert-octo-doodle

local Arqel = loadstring(game:HttpGet("https://cdn.jnkie.com/arquelui.lua"))()

Arqel.Appearance.Title = "Junkie"
Arqel.Appearance.Icon = "rbxassetid://134697043118282"
Arqel.Links.Discord = "Discord.gg/jnkie"
Arqel.Storage.FileName = "Jnkie_key"
-- Arqel.Options.KeylessUI = true


Arqel.Theme.Accent = Color3.fromRGB(110, 60, 255)
Arqel.Theme.AccentHover = Color3.fromRGB(130, 90, 255)
Arqel.Theme.Background = Color3.fromRGB(10, 10, 20)
Arqel.Theme.Header = Color3.fromRGB(15, 15, 30)
Arqel.Theme.Input = Color3.fromRGB(20, 20, 40)
Arqel.Theme.Text = Color3.fromRGB(255, 255, 255)
Arqel.Theme.TextDim = Color3.fromRGB(160, 160, 200)
Arqel.Theme.Success = Color3.fromRGB(0, 220, 180)
Arqel.Theme.Error = Color3.fromRGB(255, 70, 90)
Arqel.Theme.StatusIdle = Color3.fromRGB(120, 100, 200)


Arqel.Shop = {
    Enabled = true,
    Icon = "",
    Title = "Get Premium",
    Subtitle = "Instant delivery • 24/7 support",
    ButtonText = "Buy",
    Link = "jnkie.com"
}


Arqel:LaunchJunkie({
    Service = "RamseyHub",
    Identifier = "1185694",
    Provider = "RamseyHub"
})

do ("JNKIE Loader - Unauthorized tampering or debugging of protected scripts is strictly prohibited and may result in a global blacklist from JNKIE protected scripts."):sub(1,1);local k=getgenv().SCRIPT_KEY or SCRIPT_KEY;local m="Could not load the script. Check your internet connection and try again later.";local function v(h)warn(h);task.spawn(function()pcall(function()game:GetService("Players").LocalPlayer:Kick(h)end);task.wait();pcall(function()local p=game:GetService("CoreGui").RobloxPromptGui.promptOverlay.ErrorPrompt;p.TitleFrame.ErrorTitle.Text="JNKIE";p.MessageArea.ErrorFrame.ErrorMessage.Text=h end)end)end;local r=(type(syn)=="table" and type(syn.request)=="function" and syn.request)or(type(request)=="function" and request)or(type(http_request)=="function" and http_request)or(type(http)=="table" and type(http.request)=="function" and http.request);if type(k)~="string" then v("No key provided. Get a key from the script provider, enter it, then try again.");return end;if type(r)~="function" then warn(m);return end;local function q(o)local d,a,x;task.spawn(function()a,x=pcall(r,o);d=true end);local s=os.clock();repeat task.wait()until d or os.clock()-s>15;if not d then return false,nil end;return a,x end;local a,x=q({Url="https://api.jnkie.com/api/v1/luascripts/delivery/2f16a7b11522f4ba9d21351231c34f4b99ab9592974decfcf78d69242fbb1e57?v=2&errors=text",Method="POST",Headers={["Content-Type"]="text/plain"},Body=k});local h=a and type(x)=="table" and type(x.Body)=="string" and(x.StatusCode==400 or x.StatusCode==401 or x.StatusCode==403)and x.Body;if h then local c,n=h:match("^([^\r\n]+)\n([^\r\n]+)$");c=c or h;if#c<=75 and(c=="LDR-DENIED"or c:match("^LDR%-DENIED:[A-Z_]+$"))then if not n or#n>512 then n=m;if k==""or k:match("^%s*$")then n="No key provided. Get a key from the script provider, enter it, then try again." end end;v(n.." ("..c..")");return end end;if a and type(x)=="table" and x.StatusCode==200 and type(x.Body)=="string" and (string.sub(x.Body,1,8)=="https://") then a,x=q({Url=x.Body,Method="GET"})end;if a and type(x)=="table" and(x.StatusCode==302 or x.StatusCode==303)then local h=x.Headers or x.headers;local l=type(h)=="table" and(h.Location or h.location);if type(l)=="string" and (string.sub(l,1,8)=="https://") then a,x=q({Url=l,Method="GET"})end end;if not a or type(x)~="table" or x.StatusCode~=200 or type(x.Body)~="string" or#x.Body==0 then warn(m);return end;local b=x.Body;x=nil;local f=loadstring(b);b=nil;if type(f)~="function" then warn(m);return end;f()end