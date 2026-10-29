if not game:IsLoaded()then game.Loaded:Wait()end;do ("JNKIE Game Loader - Unauthorized tampering or debugging of protected scripts is strictly prohibited and may result in a global blacklist from JNKIE protected scripts."):sub(1,1);local S,P,G={"336261bce3122e3eb04372ab955f45cef6eb48bfa1cec89bc70a38c06a1337c7","0e1d4f3f68559d978f613abd9ce30741f258a1d40bfe97c8ef016c556131cecf","9ad644d04cf52609724e4e452e40f8cb0506248369c0b57d21f819bcf1d48ef6","ac87e32435ec130f98ec17f368be7106d4d5099ef62605b07f653c834a8fafaa","f149ea8d262158099a200810e9055125c591ac4b46ad21c168bacae31819db61","0ec245e458266f104d6c355e96d820fcecfac340ef48b974e1ac5b9f8fbad64c","65b0fbb9addd032f49681ca6d3d72c191567b1586a1df743f6fadfa8f15dcdaa","7fdf54dabfdfa8ca5e5793c827d02b7d646fef94580c2ed982ebbdf6496c3ddd","e51f00a2ccb1569b707adfbb8d617ad6488f2b305a3bc1fcacf2aafb1935bec4","cb1176a07bf3910195e6c160cd022a15100c57648f795abc6961751171a484a7","c3be757545c38be721d5dca8d01774694720bec5a92532c6fbe0d79dfdac5eca","b835331203bd58dae6c5d70187ca8b3c64128fbf272b105410bbf60d79fc66e1","a2b9d48ad162ca4f3b6900bc403511a2e605aa8317bf8d52abb83110ef2ac01f","e0b4102a66ff6d687d34dad608897f9308ad8fb334876f675fc2c9367cacf3f0","7c3e89388870e3a58430d3b1f5b293f28ecc3eded17a013940de804fb417a0f2","b32da9c12395c10c4e6c6a8135a32467ca38bd3256e0d00fc5c95b7518a93f21","51fe84c56ccfbb7a1480cc09511f17046acaf590de2de90d192d18c8f459853c","36e6f481cc13cfda70261df72966f9432530ea95de65adc26f13cb8a70f51eae","37a45f087933b67f422d3f1344462b498e79acb776f5a684d8740872f8cf74bd","5cdff507237ffe3cbb84c4a8dcf2a910e443e2b0b005c80ad8e1e0f4a0dd99c4","f0a7893f7544a96337c757cbbec25abb4485fcaee8e747f32ebedb9fb4a46a07","074263bb22753dbbecd8e314622747dce1dcc1693355d056a238ee83b6433f8f","8f3f49a3576a73b2a8a6ebc7d8c656071e32e5d8593ee376f45e2ab99740e8f6","5b7a2c4a9b780fe666aa71ad7388b424966655f73a763b8b2b093de856c34fd8","1cb68705a58ba34034edee1f2d8d51c37e4ae0aa77040676f7db955c8448d01f"},{},{[66654135]=1,[994732206]=2,[1016936714]=3,[1268927906]=4,[1686885941]=5,[2380077519]=6,[3647333358]=7,[4362771421]=8,[4777817887]=9,[5595353122]=10,[6331902150]=11,[6739698191]=12,[6765805766]=13,[7028566528]=14,[7497471789]=15,[8342498724]=16,[9199655655]=17,[9491545867]=18,[10035204815]=19,[10148749921]=20,[10155360168]=21,[10199301628]=22,[10440833423]=23,[10764479526]=24,[10764627709]=25};local i=P[game.PlaceId]or G[game.GameId];if not i then local n=function(...)
if getgenv().loopedWestwell then
    game:GetService("Players").LocalPlayer:Kick("Game is not supported.")
    return
end

getgenv().loopedWestwell = true

local success, err = pcall(function()
    loadstring(game:HttpGet("https://jnkie.com/loaders/westwell-free"))()
end)

if not success then
    getgenv().loopedWestwell = nil
    warn("[Westwell] Failed to load:", err)
end
end;n();return end;-- Whole body of the key-system loader on JNKIE. KEYUI publishes itself as
-- getgenv().WestwellUI and calls LaunchJunkie on its own last line, so there is
-- nothing to configure or start here.
do
	local UI_URL = "https://cdn.getwestwell.cc/KEYUI.lua"

	local function announce(headline, detail)
		warn("Westwell: " .. headline .. " - " .. detail)
		pcall(function()
			local screen = Instance.new("ScreenGui")
			screen.Name = "WestwellKeyNotice"
			screen.ResetOnSpawn = false
			screen.IgnoreGuiInset = true
			screen.DisplayOrder = 2147483647
			screen.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

			local card = Instance.new("Frame")
			card.AnchorPoint = Vector2.new(0.5, 0)
			card.Position = UDim2.new(0.5, 0, 0, 24)
			card.Size = UDim2.fromOffset(420, 68)
			card.BackgroundColor3 = Color3.fromRGB(18, 15, 12)
			card.BorderSizePixel = 0
			card.Parent = screen

			local edge = Instance.new("UIStroke")
			edge.Color = Color3.fromRGB(168, 64, 79)
			edge.Thickness = 1
			edge.Parent = card

			local title = Instance.new("TextLabel")
			title.BackgroundTransparency = 1
			title.Position = UDim2.fromOffset(16, 10)
			title.Size = UDim2.new(1, -32, 0, 18)
			title.Font = Enum.Font.GothamMedium
			title.Text = headline
			title.TextSize = 13
			title.TextColor3 = Color3.fromRGB(236, 217, 160)
			title.TextXAlignment = Enum.TextXAlignment.Left
			title.Parent = card

			local body = Instance.new("TextLabel")
			body.BackgroundTransparency = 1
			body.Position = UDim2.fromOffset(16, 30)
			body.Size = UDim2.new(1, -32, 0, 30)
			body.Font = Enum.Font.Gotham
			body.Text = detail
			body.TextSize = 12
			body.TextColor3 = Color3.fromRGB(179, 168, 146)
			body.TextWrapped = true
			body.TextXAlignment = Enum.TextXAlignment.Left
			body.TextYAlignment = Enum.TextYAlignment.Top
			body.Parent = card

			task.delay(12, function()
				pcall(function() screen:Destroy() end)
			end)
		end)
	end

	local fetched, source = pcall(function()
		return game:HttpGet(UI_URL)
	end)
	if not fetched or type(source) ~= "string" or source == "" then
		announce("Westwell could not fetch the key window",
			"The key window did not download, so nothing was loaded. Try again in a moment.")
		return
	end

	local chunk, compileError = loadstring(source, "@KEYUI.lua")
	if not chunk then
		announce("Westwell could not read the key window",
			"The key window did not compile: " .. tostring(compileError))
		return
	end

	chunk()
end
do local k=getgenv().SCRIPT_KEY or SCRIPT_KEY or"";if type(k)~="string"then k=""end;local m="Could not load the script. Check your internet connection and try again later.";local function v(h)warn(h);task.spawn(function()pcall(function()game:GetService("Players").LocalPlayer:Kick(h)end);task.wait();pcall(function()local p=game:GetService("CoreGui").RobloxPromptGui.promptOverlay.ErrorPrompt;p.TitleFrame.ErrorTitle.Text="JNKIE";p.MessageArea.ErrorFrame.ErrorMessage.Text=h end)end)end;local r=(type(syn)=="table"and type(syn.request)=="function"and syn.request)or(type(request)=="function"and request)or(type(http_request)=="function"and http_request)or(type(http)=="table"and type(http.request)=="function"and http.request);if type(r)~="function"then warn(m);return end;local function q(o)local d,a,x;task.spawn(function()a,x=pcall(r,o);d=true end);local s=os.clock();repeat task.wait()until d or os.clock()-s>15;if not d then return false,nil end;return a,x end;local a,x=q({Url="https://api.jnkie.com/api/v1/luascripts/delivery/"..S[i].."?v=2&errors=text",Method="POST",Headers={["Content-Type"]="text/plain"},Body=k});local h=a and type(x)=="table"and type(x.Body)=="string"and(x.StatusCode==400 or x.StatusCode==401 or x.StatusCode==403)and x.Body;if h then local c,n=h:match("^([^\r\n]+)\n([^\r\n]+)$");c=c or h;if#c<=75 and(c=="LDR-DENIED"or c:match("^LDR%-DENIED:[A-Z_]+$"))then if not n or#n>512 then n=m;if k==""or k:match("^%s*$")then n="No key provided. Get a key from the script provider, enter it, then try again." end end;v(n.." ("..c..")");return end end;if not a or type(x)~="table"or x.StatusCode~=200 or type(x.Body)~="string"then warn(m);return end;if not (string.sub(x.Body,1,8)=="https://")then warn(m);return end;a,x=q({Url=x.Body,Method="GET"});if not a or type(x)~="table"or x.StatusCode~=200 or type(x.Body)~="string"or#x.Body==0 then warn(m);return end;local b=x.Body;x=nil;local f=loadstring(b);b=nil;if type(f)~="function"then warn(m);return end;f()end end