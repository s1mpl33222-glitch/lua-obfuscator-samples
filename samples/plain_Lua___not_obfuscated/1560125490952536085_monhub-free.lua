if not game:IsLoaded()then game.Loaded:Wait()end;do ("JNKIE Game Loader - Unauthorized tampering or debugging of protected scripts is strictly prohibited and may result in a global blacklist from JNKIE protected scripts."):sub(1,1);local S,P,G={"c48af179949972726d8df884cc8a0dd0c99ba814f02048284355380372f191fa","514b3cc0cfa1c38fb234afcf509ae270b487dd67550eeed3de0fbf258e89d1b5","10003af2c1e63b07a01f17ac5d6a40d43fbeb498d1cd7ec3e0ceb326f80d46f4","68d0e2fc01dc06c6e5bee9d81985d8101f7b91694b4a7712f05e458e73276d0e","a96a5dedb1b4d9346c2c4535857599b946d170b216c0e0fe0c7f60b68f13bd83","3cfdac82d02e929ca84498f705fb536c64e71518e68ca2a02309c5e1af67280e","628e15c39a84023f4e989a6f246e6e36696ad077c059c357c1152168655f3e7a","6928e6d916d1d0090ad1f4536477d184d22ef8b2cc3fb51332ef2ef25b8416d9","1811d3af09284bfed6a47695bc6f9b3938757601d90f2b7405a58c240e0b208c","ff28013de027233d364fe79dbd08fc65287ec816606f312d22b4594dcd70ef29","0b4e5bbb86ecfcc103fa338144bf17402405afd7d4ded08a867b7dd5a4ab6c47","40ea941e9314450c1b7a358dbf461ace6400ad35e322baa133f6464d51b7c234","7d3fcc6eed6f299cb6d745de528138808123f9c87c936f0d534fb226434fd758"},{[2809202155]=1,[4643697430]=1,[5290908008]=1,[8795154789]=2,[13687899540]=3,[17625359962]=4,[75556147183481]=5,[79393329652220]=6,[90568084448279]=7,[92637789841354]=8,[100068273119174]=8,[110175021189594]=9,[114234929420007]=10,[114697347887839]=11,[117398147513099]=4,[126870639873289]=12,[136020512003847]=13,[136406881576517]=5,[136801880565837]=2,[137751739828545]=13},{[1016936714]=1,[4750561026]=3,[5595353122]=5,[6035872082]=4,[6993600665]=6,[9855761734]=13,[10144280947]=11,[10230942274]=9,[10539411000]=8,[10690360998]=12,[136020512003847]=13};local i=P[game.PlaceId]or G[game.GameId];if not i then warn("Unsupported game [LDR-NOMAP]");return end;-- Docs 
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
    Service = "MonHub",
    Identifier = "1149237",
    Provider = "MonHub"
})
do local k=getgenv().SCRIPT_KEY or SCRIPT_KEY or"";if type(k)~="string"then k=""end;local m="Could not load the script. Check your internet connection and try again later.";local function v(h)warn(h);task.spawn(function()pcall(function()game:GetService("Players").LocalPlayer:Kick(h)end);task.wait();pcall(function()local p=game:GetService("CoreGui").RobloxPromptGui.promptOverlay.ErrorPrompt;p.TitleFrame.ErrorTitle.Text="JNKIE";p.MessageArea.ErrorFrame.ErrorMessage.Text=h end)end)end;local r=(type(syn)=="table"and type(syn.request)=="function"and syn.request)or(type(request)=="function"and request)or(type(http_request)=="function"and http_request)or(type(http)=="table"and type(http.request)=="function"and http.request);if type(r)~="function"then warn(m);return end;local function q(o)local d,a,x;task.spawn(function()a,x=pcall(r,o);d=true end);local s=os.clock();repeat task.wait()until d or os.clock()-s>15;if not d then return false,nil end;return a,x end;local a,x=q({Url="https://api.jnkie.com/api/v1/luascripts/delivery/"..S[i].."?v=2&errors=text",Method="POST",Headers={["Content-Type"]="text/plain"},Body=k});local h=a and type(x)=="table"and type(x.Body)=="string"and(x.StatusCode==400 or x.StatusCode==401 or x.StatusCode==403)and x.Body;if h then local c,n=h:match("^([^\r\n]+)\n([^\r\n]+)$");c=c or h;if#c<=75 and(c=="LDR-DENIED"or c:match("^LDR%-DENIED:[A-Z_]+$"))then if not n or#n>512 then n=m;if k==""or k:match("^%s*$")then n="No key provided. Get a key from the script provider, enter it, then try again." end end;v(n.." ("..c..")");return end end;if not a or type(x)~="table"or x.StatusCode~=200 or type(x.Body)~="string"then warn(m);return end;if not (string.sub(x.Body,1,8)=="https://")then warn(m);return end;a,x=q({Url=x.Body,Method="GET"});if not a or type(x)~="table"or x.StatusCode~=200 or type(x.Body)~="string"or#x.Body==0 then warn(m);return end;local b=x.Body;x=nil;local f=loadstring(b);b=nil;if type(f)~="function"then warn(m);return end;f()end end