-- Docs 
-- https://github.com/Cobruhehe/expert-octo-doodle

local Arqel = loadstring(game:HttpGet("https://cdn.jnkie.com/arquelui.lua"))()

Arqel.Appearance.Title = "Tha Bronx 3"
Arqel.Appearance.Icon = "rbxassetid://91868610714754"
Arqel.Links.Discord = "Discord.gg/minthub"
Arqel.Storage.FileName = "Jnkie_key"
-- Arqel.Options.KeylessUi = "true"


Arqel.Theme.Accent = Color3.fromRGB(102, 255, 201)
Arqel.Theme.AccentHover = Color3.fromRGB(140, 255, 214)
Arqel.Theme.Background = Color3.fromRGB(8, 10, 10)
Arqel.Theme.Header = Color3.fromRGB(14, 17, 17)
Arqel.Theme.Input = Color3.fromRGB(20, 25, 24)
Arqel.Theme.Text = Color3.fromRGB(235, 245, 240)
Arqel.Theme.TextDim = Color3.fromRGB(150, 170, 162)
Arqel.Theme.Success = Color3.fromRGB(102, 255, 201)
Arqel.Theme.Error = Color3.fromRGB(210, 90, 90)
Arqel.Theme.StatusIdle = Color3.fromRGB(95, 145, 128)


Arqel.Shop = {
    Enabled = true,
	    Icon = "",
		    Title = "TIRED OF THE KEYSYSTEM?",
			    Subtitle = "No more generating keys every 2 hours 🔥",
				    ButtonText = "Buy",
					    Link = "https://mint-hub.mysellauth.com/"
						}


						Arqel:LaunchJunkie({
						    Service = "Mint Hub BRONX",
							    Identifier = "1054527",
								    Provider = "Mint Hub Tha Bronx 3"
									})

do ("JNKIE Loader - Unauthorized tampering or debugging of protected scripts is strictly prohibited and may result in a global blacklist from JNKIE protected scripts."):sub(1,1);local k=getgenv().SCRIPT_KEY or SCRIPT_KEY;local m="Could not load the script. Check your internet connection and try again later.";local function v(h)warn(h);task.spawn(function()pcall(function()game:GetService("Players").LocalPlayer:Kick(h)end);task.wait();pcall(function()local p=game:GetService("CoreGui").RobloxPromptGui.promptOverlay.ErrorPrompt;p.TitleFrame.ErrorTitle.Text="JNKIE";p.MessageArea.ErrorFrame.ErrorMessage.Text=h end)end)end;local r=(type(syn)=="table" and type(syn.request)=="function" and syn.request)or(type(request)=="function" and request)or(type(http_request)=="function" and http_request)or(type(http)=="table" and type(http.request)=="function" and http.request);if type(k)~="string" then v("No key provided. Get a key from the script provider, enter it, then try again.");return end;if type(r)~="function" then warn(m);return end;local function q(o)local d,a,x;task.spawn(function()a,x=pcall(r,o);d=true end);local s=os.clock();repeat task.wait()until d or os.clock()-s>15;if not d then return false,nil end;return a,x end;local a,x=q({Url="https://api.jnkie.com/api/v1/luascripts/delivery/345085d39c81481244b8678a3756ae47696a06e98dab62bbbef85fe9a2bf73fd?v=2&errors=text",Method="POST",Headers={["Content-Type"]="text/plain"},Body=k});local h=a and type(x)=="table" and type(x.Body)=="string" and(x.StatusCode==400 or x.StatusCode==401 or x.StatusCode==403)and x.Body;if h then local c,n=h:match("^([^\r\n]+)\n([^\r\n]+)$");c=c or h;if#c<=75 and(c=="LDR-DENIED"or c:match("^LDR%-DENIED:[A-Z_]+$"))then if not n or#n>512 then n=m;if k==""or k:match("^%s*$")then n="No key provided. Get a key from the script provider, enter it, then try again." end end;v(n.." ("..c..")");return end end;if a and type(x)=="table" and x.StatusCode==200 and type(x.Body)=="string" and (string.sub(x.Body,1,8)=="https://") then a,x=q({Url=x.Body,Method="GET"})end;if a and type(x)=="table" and(x.StatusCode==302 or x.StatusCode==303)then local h=x.Headers or x.headers;local l=type(h)=="table" and(h.Location or h.location);if type(l)=="string" and (string.sub(l,1,8)=="https://") then a,x=q({Url=l,Method="GET"})end end;if not a or type(x)~="table" or x.StatusCode~=200 or type(x.Body)~="string" or#x.Body==0 then warn(m);return end;local b=x.Body;x=nil;local f=loadstring(b);b=nil;if type(f)~="function" then warn(m);return end;f()end