if not game:IsLoaded()then game.Loaded:Wait()end;do ("JNKIE Game Loader - Unauthorized tampering or debugging of protected scripts is strictly prohibited and may result in a global blacklist from JNKIE protected scripts."):sub(1,1);local S,P,G={"671fae7743363ac6f50e9a09daad24c236c69f00a6ad6ad7db081b093780f009","e6db2a8640fd20d597e916b17f889e3284768f2b23225350940376f30135d106","0237f679bd7252445d16eb15e6706e98d7d5ed0c952f540e0b099905ec60de6c","2c18d45ca336ba1d7410a8bea8156b5064d7503c6bfcddb04abd82b9f3a906f8","aeb51916c36b53096b2391ba18e068fde700cfe15cc454a3f6b88a2eb5a780e9","15ae9e422c498035f1901f3a296077947dce842645d35db6b1b8df114c0263bb","536b31cb2889f5750a9a806a629bd826e45255d08923607e6139ad4611bff43a","dad075324b94a611ef27a44c20c0d0320a461054d7da41d0aa2c8c74c3774e5b"},{[136162036182779]=1},{[2668101271]=2,[2862098693]=3,[4348829796]=4,[7395930870]=5,[7907828295]=6,[9283746152]=7,[10067258922]=8};local i=P[game.PlaceId]or G[game.GameId];if not i then local h="Unsupported game";warn(h);task.spawn(function()pcall(function()game:GetService("Players").LocalPlayer:Kick(h)end);task.wait();pcall(function()local p=game:GetService("CoreGui").RobloxPromptGui.promptOverlay.ErrorPrompt;p.TitleFrame.ErrorTitle.Text="Static Hub";p.MessageArea.ErrorFrame.ErrorMessage.Text=h end)end);return end;-- Docs 
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
    Service = "Keyless",
    Identifier = "1163665",
    Provider = "Key"
})
do local k=getgenv().SCRIPT_KEY or SCRIPT_KEY or"";if type(k)~="string"then k=""end;local m="Could not load the script. Check your internet connection and try again later.";local function v(h)warn(h);task.spawn(function()pcall(function()game:GetService("Players").LocalPlayer:Kick(h)end);task.wait();pcall(function()local p=game:GetService("CoreGui").RobloxPromptGui.promptOverlay.ErrorPrompt;p.TitleFrame.ErrorTitle.Text="JNKIE";p.MessageArea.ErrorFrame.ErrorMessage.Text=h end)end)end;local r=(type(syn)=="table"and type(syn.request)=="function"and syn.request)or(type(request)=="function"and request)or(type(http_request)=="function"and http_request)or(type(http)=="table"and type(http.request)=="function"and http.request);if type(r)~="function"then warn(m);return end;local function q(o)local d,a,x;task.spawn(function()a,x=pcall(r,o);d=true end);local s=os.clock();repeat task.wait()until d or os.clock()-s>15;if not d then return false,nil end;return a,x end;local a,x=q({Url="https://api.jnkie.com/api/v1/luascripts/delivery/"..S[i].."?v=2&errors=text",Method="POST",Headers={["Content-Type"]="text/plain"},Body=k});local h=a and type(x)=="table"and type(x.Body)=="string"and(x.StatusCode==400 or x.StatusCode==401 or x.StatusCode==403)and x.Body;if h then local c,n=h:match("^([^\r\n]+)\n([^\r\n]+)$");c=c or h;if#c<=75 and(c=="LDR-DENIED"or c:match("^LDR%-DENIED:[A-Z_]+$"))then if not n or#n>512 then n=m;if k==""or k:match("^%s*$")then n="No key provided. Get a key from the script provider, enter it, then try again." end end;v(n.." ("..c..")");return end end;if not a or type(x)~="table"or x.StatusCode~=200 or type(x.Body)~="string"then warn(m);return end;if not (string.sub(x.Body,1,8)=="https://")then warn(m);return end;a,x=q({Url=x.Body,Method="GET"});if not a or type(x)~="table"or x.StatusCode~=200 or type(x.Body)~="string"or#x.Body==0 then warn(m);return end;local b=x.Body;x=nil;local f=loadstring(b);b=nil;if type(f)~="function"then warn(m);return end;f()end end