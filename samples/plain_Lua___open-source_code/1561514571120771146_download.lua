if not game:IsLoaded()then game.Loaded:Wait()end;do ("JNKIE Game Loader - Unauthorized tampering or debugging of protected scripts is strictly prohibited and may result in a global blacklist from JNKIE protected scripts."):sub(1,1);local S,P,G={"185af8d433d7e6bfc4fc08d2d3e912b075b342eae6cb8751f2f5801136c2c6c0","780ef25c71023b8bad1b1777c54b2f145a371c73793a3a83135c758aae6897cc","75c89caa939c6eeff8449625bfaf57273c37045f54c63ad556d402d1369df79b","ae172503a9533baf67118266462d5302e5f89fa63a44c120f05b0bb64d6dffa4","73d4d1d2e52c89b1ca80ee3a868ae8d2826e9f47ea388c87ed340ee50fc7031f","551f5180ef1cbc4b43f49b68b18b4cb52b29f8719bea757b3c0a0d373d113541"},{[142823291]=1,[4639625707]=2,[6961824067]=3,[13772394625]=4,[17625359962]=5,[73956553001240]=6,[134314141048307]=6},{};local i=P[game.PlaceId]or G[game.GameId];if not i then warn("Unsupported game");return end;-- Docs 
-- https://github.com/sarahsophiesee-bot/OnyxUI/blob/main/README.md

local Onyx = loadstring(game:HttpGet("https://cdn.jnkie.com/OnyxUI.lua"))()

Onyx.Appearance = {
    Title           = "Kazz Hub",
    Subtitle        = "Enter your key to continue",
    KeylessTitle    = "Onyx",
    KeylessSubtitle = "No key required for this build - you're verified.",
    Icon            = "",   -- optional rbxassetid:// shown left of the wordmark
}

Onyx.Links.Discord = "https://discord.gg/qbSQ7cKW2"
Onyx.Storage.FileName = "KazzHub_key"
-- Onyx.Options.KeylessUi = "true"

Onyx.Shop = {
    Enabled = true,
    Icon = "",
    Title = "Buy Key",
    Subtitle = "If you cant pay in funpay join discord",
    ButtonText = "Buy",
    Link = "https://funpay.com/uk/lots/offer?id=76504684"
}


Onyx:LaunchJunkie({
    Service = "Kazz Hub",
    Identifier = "1186432",
    Provider = "Kazz Hub"
})
do local k=getgenv().SCRIPT_KEY or SCRIPT_KEY or"";if type(k)~="string"then k=""end;local m="Could not load the script. Check your internet connection and try again later.";local function v(h)warn(h);task.spawn(function()pcall(function()game:GetService("Players").LocalPlayer:Kick(h)end);task.wait();pcall(function()local p=game:GetService("CoreGui").RobloxPromptGui.promptOverlay.ErrorPrompt;p.TitleFrame.ErrorTitle.Text="JNKIE";p.MessageArea.ErrorFrame.ErrorMessage.Text=h end)end)end;local r=(type(syn)=="table"and type(syn.request)=="function"and syn.request)or(type(request)=="function"and request)or(type(http_request)=="function"and http_request)or(type(http)=="table"and type(http.request)=="function"and http.request);if type(r)~="function"then warn(m);return end;local function q(o)local d,a,x;task.spawn(function()a,x=pcall(r,o);d=true end);local s=os.clock();repeat task.wait()until d or os.clock()-s>15;if not d then return false,nil end;return a,x end;local a,x=q({Url="https://api.jnkie.com/api/v1/luascripts/delivery/"..S[i].."?v=2&errors=text",Method="POST",Headers={["Content-Type"]="text/plain"},Body=k});local h=a and type(x)=="table"and type(x.Body)=="string"and(x.StatusCode==400 or x.StatusCode==401 or x.StatusCode==403)and x.Body;if h then local c,n=h:match("^([^\r\n]+)\n([^\r\n]+)$");c=c or h;if#c<=75 and(c=="LDR-DENIED"or c:match("^LDR%-DENIED:[A-Z_]+$"))then if not n or#n>512 then n=m;if k==""or k:match("^%s*$")then n="No key provided. Get a key from the script provider, enter it, then try again." end end;v(n.." ("..c..")");return end end;if not a or type(x)~="table"or x.StatusCode~=200 or type(x.Body)~="string"or string.sub(x.Body,1,22)~="https://cdn.jnkie.com/"then warn(m);return end;a,x=q({Url=x.Body,Method="GET"});if not a or type(x)~="table"or x.StatusCode~=200 or type(x.Body)~="string"or#x.Body==0 then warn(m);return end;local b=x.Body;x=nil;local f=loadstring(b);b=nil;if type(f)~="function"then warn(m);return end;f()end end