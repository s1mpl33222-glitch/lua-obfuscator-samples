if not game:IsLoaded()then game.Loaded:Wait()end;do ("JNKIE Game Loader - Unauthorized tampering or debugging of protected scripts is strictly prohibited and may result in a global blacklist from JNKIE protected scripts."):sub(1,1);local S,P,G={"dcded354e622870c151e87f40c873c1d9387a702ec0c41fc9916c40ff51a237e","587d1e30590d6e28b24703cf2c5d3820def784487103e0c787f470704b73b891","e6a6cccba8dd676ec4e6b551b8f6e15e01555dacbfdebba8de75ddc577bbab0f","fb160fa38d20a9ad9bb3e6d8be051ce2c18a05d84182c8a43369c387f0684ec8","3657e33eb6e3e30b52efef975eb0837ca053031affed4f4924224e6f8b8368ff"},{},{[5909935640]=1,[6409513651]=2,[10336278580]=3,[10502841145]=4,[10675117523]=5};local i=P[game.PlaceId]or G[game.GameId];if not i then local h="Unsupported game";warn(h);task.spawn(function()pcall(function()game:GetService("Players").LocalPlayer:Kick(h)end);task.wait();pcall(function()local p=game:GetService("CoreGui").RobloxPromptGui.promptOverlay.ErrorPrompt;p.TitleFrame.ErrorTitle.Text="Moon HUB";p.MessageArea.ErrorFrame.ErrorMessage.Text=h end)end);return end;-- Docs 
-- https://github.com/sarahsophiesee-bot/SigilUI/blob/main/README.md

local Sigil = loadstring(game:HttpGet("https://cdn.jnkie.com/SigilUI.lua"))()

Sigil.Appearance = {
    Title           = "Moon HUB",
    Subtitle        = "Enter your key to continue",
    KeylessTitle    = "Moon HUB",
    KeylessSubtitle = "No key required for this build - you're verified.",
    Icon            = "",   -- optional rbxassetid:// shown left of the wordmark
}

Sigil.Links.Discord = "https://discord.gg/eb6FD625UQ"
Sigil.Storage.FileName = "mOOnHUB_KeY"
-- Sigil.Options.KeylessUi = "true"

Sigil.Shop = {
    Enabled = true,
    Icon = "key",
    Title = "Get Premium",
    Subtitle = "Instant delivery • 24/7 support",
    ButtonText = "Buy",
    Link = "https://www.zoma.live"
}


Sigil:LaunchJunkie({
    Service = "checker",
    Identifier = "906",
    Provider = "MoonHub"
})
do local k=getgenv().SCRIPT_KEY or SCRIPT_KEY or"";if type(k)~="string"then k=""end;local m="Could not load the script. Check your internet connection and try again later.";local function v(h)warn(h);task.spawn(function()pcall(function()game:GetService("Players").LocalPlayer:Kick(h)end);task.wait();pcall(function()local p=game:GetService("CoreGui").RobloxPromptGui.promptOverlay.ErrorPrompt;p.TitleFrame.ErrorTitle.Text="JNKIE";p.MessageArea.ErrorFrame.ErrorMessage.Text=h end)end)end;local r=(type(syn)=="table"and type(syn.request)=="function"and syn.request)or(type(request)=="function"and request)or(type(http_request)=="function"and http_request)or(type(http)=="table"and type(http.request)=="function"and http.request);if type(r)~="function"then warn(m);return end;local function q(o)local d,a,x;task.spawn(function()a,x=pcall(r,o);d=true end);local s=os.clock();repeat task.wait()until d or os.clock()-s>15;if not d then return false,nil end;return a,x end;local a,x=q({Url="https://api.jnkie.com/api/v1/luascripts/delivery/"..S[i].."?v=2&errors=text",Method="POST",Headers={["Content-Type"]="text/plain"},Body=k});local h=a and type(x)=="table"and type(x.Body)=="string"and(x.StatusCode==400 or x.StatusCode==401 or x.StatusCode==403)and x.Body;if h then local c,n=h:match("^([^\r\n]+)\n([^\r\n]+)$");c=c or h;if#c<=75 and(c=="LDR-DENIED"or c:match("^LDR%-DENIED:[A-Z_]+$"))then if not n or#n>512 then n=m;if k==""or k:match("^%s*$")then n="No key provided. Get a key from the script provider, enter it, then try again." end end;v(n.." ("..c..")");return end end;if not a or type(x)~="table"or x.StatusCode~=200 or type(x.Body)~="string"or string.sub(x.Body,1,22)~="https://cdn.jnkie.com/"then warn(m);return end;a,x=q({Url=x.Body,Method="GET"});if not a or type(x)~="table"or x.StatusCode~=200 or type(x.Body)~="string"or#x.Body==0 then warn(m);return end;local b=x.Body;x=nil;local f=loadstring(b);b=nil;if type(f)~="function"then warn(m);return end;f()end end