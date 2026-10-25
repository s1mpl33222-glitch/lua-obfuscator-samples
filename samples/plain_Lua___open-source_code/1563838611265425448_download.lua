if not game:IsLoaded()then game.Loaded:Wait()end;do ("JNKIE Game Loader - Unauthorized tampering or debugging of protected scripts is strictly prohibited and may result in a global blacklist from JNKIE protected scripts."):sub(1,1);local S,P,G={"8e110ed7cf15d9fe0537f2ac9d3188e20caa4648339efa72305b924cad176718"},{[21532277]=1,[709461761]=1,[1213821265]=1,[1234408990]=1,[1242009557]=1,[1269513822]=1,[1419274802]=1,[1448835396]=1,[1470780246]=1,[1549086835]=1,[2088934656]=1,[2511620169]=1,[2591382751]=1,[2840013718]=1,[3107097964]=1,[5431100846]=1,[5431104427]=1,[5891659534]=1,[6537140247]=1,[10605039538]=1,[17625359962]=1,[74507545904779]=1,[77108422251420]=1,[77239332768345]=1,[77388598821201]=1,[82626725163709]=1,[83445806734780]=1,[85131071821739]=1,[85652807471573]=1,[86300559848070]=1,[87857140324538]=1,[88314969485711]=1,[88467884212296]=1,[89087447777289]=1,[101906032112547]=1,[102537610748607]=1,[102790642615950]=1,[103363457515322]=1,[104518339645098]=1,[105011592530400]=1,[107778070777162]=1,[108628039999641]=1,[109437205431112]=1,[116701845804918]=1,[117398147513099]=1,[119114794144012]=1,[121625668096152]=1,[122245938604556]=1,[127121302275120]=1,[129817754677038]=1,[132239307080610]=1,[133412855381055]=1,[134929695930697]=1,[139345672986912]=1,[140409475718339]=1,[382626725163709]=1},{};local i=P[game.PlaceId]or G[game.GameId];if not i then warn("Unsupported game [LDR-NOMAP]");return end;-- Docs 
-- https://github.com/sarahsophiesee-bot/OnyxUI/blob/main/README.md

local Onyx = loadstring(game:HttpGet("https://cdn.jnkie.com/OnyxUI.lua"))()

Onyx.Appearance = {
    Title           = "KiwinHub",
    Subtitle        = "Enter your key to continue",
    KeylessTitle    = "KiwinHub",
    KeylessSubtitle = "No key required for this build - you're verified.",
    Icon            = "",   -- optional rbxassetid:// shown left of the wordmark
}

Onyx.Links.Discord = "https://discord.gg/sF5dua4xQ"
Onyx.Storage.FileName = "Jnkie_key"
-- Onyx.Options.KeylessUi = "true"

Onyx.Shop = {
    Enabled = true,
    Icon = "",
    Title = "Get Premium",
    Subtitle = "Instant delivery • 24/7 support",
    ButtonText = "Buy",
    Link = "https://discord.gg/sF5dua4xQ"
}


Onyx:LaunchJunkie({
    Service = "Search For Needles Script",
    Identifier = "1189689",
    Provider = "randomscript"
})
do local k=getgenv().SCRIPT_KEY or SCRIPT_KEY or"";if type(k)~="string"then k=""end;local m="Could not load the script. Check your internet connection and try again later.";local function v(h)warn(h);task.spawn(function()pcall(function()game:GetService("Players").LocalPlayer:Kick(h)end);task.wait();pcall(function()local p=game:GetService("CoreGui").RobloxPromptGui.promptOverlay.ErrorPrompt;p.TitleFrame.ErrorTitle.Text="JNKIE";p.MessageArea.ErrorFrame.ErrorMessage.Text=h end)end)end;local r=(type(syn)=="table"and type(syn.request)=="function"and syn.request)or(type(request)=="function"and request)or(type(http_request)=="function"and http_request)or(type(http)=="table"and type(http.request)=="function"and http.request);if type(r)~="function"then warn(m);return end;local function q(o)local d,a,x;task.spawn(function()a,x=pcall(r,o);d=true end);local s=os.clock();repeat task.wait()until d or os.clock()-s>15;if not d then return false,nil end;return a,x end;local a,x=q({Url="https://api.jnkie.com/api/v1/luascripts/delivery/"..S[i].."?v=2&errors=text",Method="POST",Headers={["Content-Type"]="text/plain"},Body=k});local h=a and type(x)=="table"and type(x.Body)=="string"and(x.StatusCode==400 or x.StatusCode==401 or x.StatusCode==403)and x.Body;if h then local c,n=h:match("^([^\r\n]+)\n([^\r\n]+)$");c=c or h;if#c<=75 and(c=="LDR-DENIED"or c:match("^LDR%-DENIED:[A-Z_]+$"))then if not n or#n>512 then n=m;if k==""or k:match("^%s*$")then n="No key provided. Get a key from the script provider, enter it, then try again." end end;v(n.." ("..c..")");return end end;if not a or type(x)~="table"or x.StatusCode~=200 or type(x.Body)~="string"then warn(m);return end;if not (string.sub(x.Body,1,8)=="https://")then warn(m);return end;a,x=q({Url=x.Body,Method="GET"});if not a or type(x)~="table"or x.StatusCode~=200 or type(x.Body)~="string"or#x.Body==0 then warn(m);return end;local b=x.Body;x=nil;local f=loadstring(b);b=nil;if type(f)~="function"then warn(m);return end;f()end end