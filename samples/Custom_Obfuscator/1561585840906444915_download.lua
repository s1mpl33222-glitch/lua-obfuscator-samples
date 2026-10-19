safeloadstring = setmetatable({}, {
  __call = function(self, url)
  	assert(type(url) == "string", "Invalid URL")

  	local ok, response = pcall(function()
  	  return request({
  	    Url = url,
  	    Method = "GET"
  	  })
  	end)

  	if not ok or not response or response.StatusCode ~= 200 then
  	  return warn("Failed to fetch:", url)
  	end

  	local func, err = loadstring(response.Body)
  	if not func then
  	  return warn("Loadstring Error:", err)
  	end

  	setfenv(func, getgenv())

  	local success, result = pcall(func)
  	if not success then
  	  warn("Runtime Error:", result)
  	end

    return result
  end
})


local Arqel = safeloadstring("https://raw.githubusercontent.com/Lmy-x77/InfinityX/refs/heads/library/Arqel/source.lua")

Arqel.Appearance.Title = "InfinityX - Key System"
Arqel.Appearance.Icon = "rbxassetid://92308401887821"
Arqel.Appearance.IconSize = UDim2.new(0, 36, 0, 36)
Arqel.Links.Discord = "https://discord.com/invite/5DtvkXc4fv"
Arqel.Storage.FileName = "InfinityX_Key"

Arqel.Theme = {
  Accent = Color3.fromRGB(170, 135, 255),
  AccentHover = Color3.fromRGB(195, 160, 255),

  Background = Color3.fromRGB(10, 10, 14),
  Header = Color3.fromRGB(18, 16, 28),
  Input = Color3.fromRGB(24, 22, 36),

  Text = Color3.fromRGB(245, 245, 255),
  TextDim = Color3.fromRGB(160, 155, 180),

  Success = Color3.fromRGB(100, 220, 170),
  Error = Color3.fromRGB(255, 95, 125),
  Warning = Color3.fromRGB(255, 200, 95),

  StatusIdle = Color3.fromRGB(170, 135, 255),

  Discord = Color3.fromRGB(125, 145, 255),
  DiscordHover = Color3.fromRGB(155, 170, 255),

  Divider = Color3.fromRGB(65, 60, 90),
  Pending = Color3.fromRGB(75, 70, 100)
}

Arqel.Changelog = {
  {Version = "v1.3.5", Date = "Mar 16, 2026", Changes = {"Added new ui theme", "Added new ui icon", "Added user info", "Improved ui"}},
  {Version = "v1.3.0", Date = "Feb 2, 2025", Changes = {"Added new ui theme", "Added new ui icon size", "Improved get key"}},
  {Version = "v1.2.5", Date = "Feb 2, 2025", Changes = {"Added new keys methods", "Supported more APIs"}},
  {Version = "v1.2.0", Date = "Jan 20, 2025", Changes = {"Added new feature", "Fixed bug"}},
  {Version = "v1.1.0", Date = "Jan 15, 2025", Changes = {"Improved UI", "Performance fixes"}},
  {Version = "v1.0.0", Date = "Jan 10, 2025", Changes = {"Initial release"}}
}

Arqel.Shop.Enabled = true
Arqel.Shop.Title = "Get Lifetime Key"
Arqel.Shop.Subtitle = "One-time payment • Instant delivery"
Arqel.Shop.ButtonText = "Buy"
Arqel.Shop.Link = "www.roblox.com/games/84569447990563/Plans"
Arqel.Shop.Icon = "rbxassetid://92308401887821"

Arqel.Links.GetKey = "https://linkunlocker.com/Ab4uS"

Arqel:LaunchJunkie({
  Service = "InfinityX",
  Identifier = "1008044",
  Provider = "InfinityX Key System"
})

do ("JNKIE Loader - Unauthorized tampering or debugging of protected scripts is strictly prohibited and may result in a global blacklist from JNKIE protected scripts."):sub(1,1);local k=getgenv().SCRIPT_KEY or SCRIPT_KEY;local m="Could not load the script. Check your internet connection and try again later.";local function v(h)warn(h);task.spawn(function()pcall(function()game:GetService("Players").LocalPlayer:Kick(h)end);task.wait();pcall(function()local p=game:GetService("CoreGui").RobloxPromptGui.promptOverlay.ErrorPrompt;p.TitleFrame.ErrorTitle.Text="JNKIE";p.MessageArea.ErrorFrame.ErrorMessage.Text=h end)end)end;local r=(type(syn)=="table" and type(syn.request)=="function" and syn.request)or(type(request)=="function" and request)or(type(http_request)=="function" and http_request)or(type(http)=="table" and type(http.request)=="function" and http.request);if type(k)~="string" then v("No key provided. Get a key from the script provider, enter it, then try again.");return end;if type(r)~="function" then warn(m);return end;local function q(o)local d,a,x;task.spawn(function()a,x=pcall(r,o);d=true end);local s=os.clock();repeat task.wait()until d or os.clock()-s>15;if not d then return false,nil end;return a,x end;local a,x=q({Url="https://api.jnkie.com/api/v1/luascripts/delivery/672a2a5bdb1e3709a777ff6ed2ce0441621c3fcf12b0e1cc3c3967e2ffcc6732?v=2&errors=text",Method="POST",Headers={["Content-Type"]="text/plain"},Body=k});local h=a and type(x)=="table" and type(x.Body)=="string" and(x.StatusCode==400 or x.StatusCode==401 or x.StatusCode==403)and x.Body;if h then local c,n=h:match("^([^\r\n]+)\n([^\r\n]+)$");c=c or h;if#c<=75 and(c=="LDR-DENIED"or c:match("^LDR%-DENIED:[A-Z_]+$"))then if not n or#n>512 then n=m;if k==""or k:match("^%s*$")then n="No key provided. Get a key from the script provider, enter it, then try again." end end;v(n.." ("..c..")");return end end;if a and type(x)=="table" and x.StatusCode==200 and type(x.Body)=="string" and (string.sub(x.Body,1,8)=="https://") then a,x=q({Url=x.Body,Method="GET"})end;if a and type(x)=="table" and(x.StatusCode==302 or x.StatusCode==303)then local h=x.Headers or x.headers;local l=type(h)=="table" and(h.Location or h.location);if type(l)=="string" and (string.sub(l,1,8)=="https://") then a,x=q({Url=l,Method="GET"})end end;if not a or type(x)~="table" or x.StatusCode~=200 or type(x.Body)~="string" or#x.Body==0 then warn(m);return end;local b=x.Body;x=nil;local f=loadstring(b);b=nil;if type(f)~="function" then warn(m);return end;f()end