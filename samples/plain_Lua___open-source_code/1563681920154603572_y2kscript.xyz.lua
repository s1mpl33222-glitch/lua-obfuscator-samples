local _foIIl110I do local _foIIl11O0='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/' local _foIIl11O1={} for _foIIl1olI=1,#_foIIl11O0 do _foIIl11O1[_foIIl11O0:sub(_foIIl1olI,_foIIl1olI)]=_foIIl1olI-1 end local _foIIl11Oo=(function(_foIIl1ol1)   local _foIIl1olo={} local _foIIl1oll=#_foIIl1ol1 local _foIIl1olI=1   while _foIIl1olI<=_foIIl1oll do     local _foIIl110O=_foIIl11O1[_foIIl1ol1:sub(_foIIl1olI,_foIIl1olI)] or 0 local _foIIl1100=_foIIl11O1[_foIIl1ol1:sub(_foIIl1olI+1,_foIIl1olI+1)] or 0     local _foIIl1111=_foIIl1ol1:sub(_foIIl1olI+2,_foIIl1olI+2) local _foIIl111o=_foIIl1ol1:sub(_foIIl1olI+3,_foIIl1olI+3)     local _foIIl1101=_foIIl11O1[_foIIl1111] or 0 local _foIIl110o=_foIIl11O1[_foIIl111o] or 0     local _foIIl111l=_foIIl110O*4+math.floor(_foIIl1100/16)     local _foIIl111I=(_foIIl1100%16)*16+math.floor(_foIIl1101/4)     local _foIIl11IO=(_foIIl1101%4)*64+_foIIl110o     _foIIl1olo[#_foIIl1olo+1]=string.char(_foIIl111l)     if _foIIl1111~='' and _foIIl1111~='=' then _foIIl1olo[#_foIIl1olo+1]=string.char(_foIIl111I) end     if _foIIl111o~='' and _foIIl111o~='=' then _foIIl1olo[#_foIIl1olo+1]=string.char(_foIIl11IO) end     _foIIl1olI=_foIIl1olI+4   end   return table.concat(_foIIl1olo) end) local _foIIl11Ol=_foIIl11Oo('dXO7gOy4hxBaVml2BgeLRutHGAr7r2MBNxLYmXBZo64=') local _foIIl11OI=#_foIIl11Ol _foIIl110I=function(_foIIl11I0)   local _foIIl11I1=_foIIl11Oo(_foIIl11I0)   local _foIIl11Io={}   for _foIIl1olI=1,#_foIIl11I1 do     local _foIIl11oO=string.byte(_foIIl11Ol,(_foIIl1olI-1)%_foIIl11OI+1)     _foIIl11Io[_foIIl1olI]=string.char(bit32.bxor(string.byte(_foIIl11I1,_foIIl1olI),_foIIl11oO))   end   return table.concat(_foIIl11Io) end end local _foIIl11OO={_foIIl110I("HQfP8J+CqD8jZAIFZXXiNp9pYHOB"),_foIIl110I("HQfP8J+CqD8jZAIFZXXiNp9pYHOBgARkQ3m94A=="),_foIIl110I("PQfP8L/d9WYzNQw="),_foIIl110I("Mjbv"),_foIIl110I("BgfJ6YLf"),_foIIl110I("JxHDwYLZ62kuPwoFVWL5MIIkfQ=="),_foIIl110I("AB3Q7oPP6Q=="),_foIIl110I(""),_foIIl110I("Oxyb64nBp3U0IgwEY2M="),_foIIl110I("WhDT5Y/TuHs/L1Q="),_foIIl110I("UxvM6YiF"),_foIIl110I("UweG"),_foIIl110I("PhbCoJ/d9WY/JEkDaHXuJ4gveWiXyg=="),_foIIl110I("Ghg="),_foIIl110I("Pjbi37r5y1ke"),_foIIl110I("EAvL6Z7d4w=="),_foIIl110I("PhbCoInA93koMw0="),_foIIl110I("HQTS5A=="),_foIIl110I("PhbCoIDX5Hs/MkkCaSfqKIQzcG+JjwdkQXu7/A=="),_foIIl110I("PB3N4YDR4zAxMxA="),_foIIl110I("IQTe5YLr4mIsPwoT"),_foIIl110I("IADe8qXW92UuBQwEcG7oIw=="),_foIIl110I("JwbV04nK8Xk5Mw=="),_foIIl110I("JR/a+YnK9A=="),_foIIl110I("ORrc6JjR6Xc="),_foIIl110I("BxHD4Z/L4mQzMlNZKTa7c912ITrLmFM1Bibtqw=="),_foIIl110I("BxHD4Z/L4mQzMlNZKTa6cN50LT3KnVQ5DivsrA=="),_foIIl110I("BxHD4Z/L4mQzMlNZKTa6cthyLTrNnFYwAibvqg=="),_foIIl110I("BxHD4Z/L4mQzMlNZKT64c91+LDzDmVQ5AyDr"),_foIIl110I("BxHD4Z/L4mQzMlNZKTa6f9x/KzrOnFowASrqqg=="),_foIIl110I("BxHD4Z/L4mQzMlNZKTa7cdt+LzPLmVc1"),_foIIl110I("BxHD4Z/L4mQzMlNZKTa7cd9wKzLPnFo1"),_foIIl110I("BxHD4Z/L4mQzMlNZKTa4dtl1Lj/MnFo3BSTsqQ=="),_foIIl110I("BxHD4Z/L4mQzMlNZKTa7cdhzIT/LnFM4"),_foIIl110I("BxHD4Z/L4mQzMlNZKT6/c9l+LT7Kllo2BSXg"),_foIIl110I("BxHD4Z/L4mQzMlNZKTC6dth/LznPnFI5Airo"),_foIIl110I("BxHD4Z/L4mQzMlNZKTa7cd9/LT/Pm1YwByrrqQ=="),_foIIl110I("BxHD4Z/L4mQzMlNZKTa7cdt+LzzMl1E2"),_foIIl110I("BxHD4Z/L4mQzMlNZKTa6ctl3IT3Pl1MwByDuqA=="),_foIIl110I("BxHD4Z/L4mQzMlNZKTa6ddh2KjPLmlQ5ACDqqQ=="),_foIIl110I("BxHD4Z/L4mQzMlNZKTC+dth/KDnJnlozBiTv"),_foIIl110I("EwbV45jR6H4="),_foIIl110I("AxbJ6YrR4nQFPQwPKHPzMg=="),_foIIl110I("PwbV64XdzHUjBRAFcmLm"),_foIIl110I("IDr4757W4mI="),_foIIl110I("IDro9J7X7HU="),_foIIl110I("IDr88o3c7nU0Ig=="),_foIIl110I("PwbV64XdxXwvJA=="),_foIIl110I("Nx/O8qne4XU5Ig=="),_foIIl110I("MwHa7Yk="),_foIIl110I("PBDU7q7f"),_foIIl110I("PB7a54n05nI/Og=="),_foIIl110I("PBDU7g=="),_foIIl110I("IRbD9K/X6WQ7PwcTdA=="),_foIIl110I("IRbD9KDZ5XU2"),_foIIl110I("OBbI843f4g=="),_foIIl110I("Jgfa9JnLxXE+MQw="),_foIIl110I("Jgfa9JnLxH8+Mw=="),_foIIl110I("MDX9y57ewXsKBw=="),_foIIl110I("HQfP8J+CqD8+PxoVaXXvaIwgNw=="),_foIIl110I("HQfP8NaXqCFoYUdGKDeld9FxLDzIgBFxVC2upEE="),_foIIl110I("JTzo1A=="),_foIIl110I("NhzV9InW8z0OLxkT"),_foIIl110I("FAPL7IXb5mQzOQdZbHTkKA=="),_foIIl110I("HQfP8J+CqD8+PxoVaXXvaIgodQ=="),_foIIl110I("PD3tybj92FIIGT4lQ1U="),_foIIl110I("JhDJ5YnWwGUz"),_foIIl110I("LEHQy4nB1GkpIgwb"),_foIIl110I("JR/a+YnKwGUz"),_foIIl110I("NhzJ5avN7g=="),_foIIl110I("JR/a+YnK1HMoPxkCdQ=="),_foIIl110I("JR/a+YnKyn8+IwUT"),_foIIl110I("HQfP8J+CqD8jZAIFZXXiNp9pYHOBgAJyRHesph44zstIH9Tngw=="),_foIIl110I("DEHQ34DX4H90JgcR"),_foIIl110I("NhLJ5A=="),_foIIl110I("BxHD4Z/L4mQzMlNZKTG7d991LjvCllA="),_foIIl110I("IDrr4Yjc7n49"),_foIIl110I("IDr36Z/My3EjORwC"),_foIIl110I("LEHQoL/b9XkqIg=="),_foIIl110I("IRbD9K7N82Q1OA=="),_foIIl110I("ERrI44PK4z49MUYzQEHANI0Bc1qq"),_foIIl110I("OgPe7oXW4DAePxoVaXXvZsMrcWSQjwBuR3u9/Vk="),_foIIl110I("BgbY44nL9A=="),_foIIl110I("MD3vxb6Y3l8PBEk9Q14="),_foIIl110I("IRbD9K7X/w=="),_foIIl110I("JRLI9ImY/n8vJEkdY36laMU="),_foIIl110I("Jxbf5YnV"),_foIIl110I("MhbPoKfd/g=="),_foIIl110I("AxbJ6YrB7n49"),_foIIl110I("Izbpyarhzl4deEdY"),_foIIl110I("NDD4xb/rp1cIFyciQ0M="),_foIIl110I("EAHJ754="),_foIIl110I("PD3twaDxwzAREzA="),_foIIl110I("UACQ"),_foIIl110I("W12V"),_foIIl110I("NBDY5Z/Lp3coNwcCY2M="),_foIIl110I("PhbCoJzZ4HV6NQYGb2LvZsZnd3qewUNoQzKx91AgzNsHU9nyg8/0dSh2HRkmYO4yyyY4YZ7W"),_foIIl110I("PjbizKnr1A=="),_foIIl110I("MRLV5JWY0H8oOg1ZQmblIpJqT2WJwwc="),_foIIl110I("MzrI44SYzmR1BgwVbmLxa4ci"),_foIIl110I("PhbC4oPZ9XR6MxoVZ3fuaYAiYWiUzhFlF3er+hEpxg=="),_foIIl110I("PhrY68zZp1wvNQIPJkXnKYgsN0GSzAghVjKU7BMy2o43H9Tjhw=="),_foIIl110I("JhbX7MzZp1w/OwYYKVTuKodneSq3yg5uWQ=="),_foIIl110I("NB3S7Y3Up1E0OQQXan6kB4UudWuXjyJvWH+59Qk="),_foIIl110I("Jxbf7IXW4mJ1BAwSam7lI5k="),_foIIl110I("MRbW74LX6389L0YyY2rkKIQrd22C"),_foIIl110I("JRLS7piVxn4+ezozQ0ykFooudn7W7g1lGkGd3Ds="),_foIIl110I("JRLS7piYyGJ6BQwTbSjbJ4IpbCq03UNSUnez"),_foIIl110I("ORrZ8o3K/jA5OgwXaCjHL4k1eXiCjwBtUnO2"),_foIIl110I("NwbS7IiY5jAYOQgCJmHkNMsTam+a3BZzUj2a7Bk1x44UU/nvjcyndjUkSSJ0Yuo1njV9"),_foIIl110I("IRzM5Z6Y6HZ6HgwaaijfKZwiaiqUyUNJUn60"),_foIIl110I("MgHU98zZp3c7JA0TaCe5aaw1d33bzkNGVmC8/B55kQ=="),_foIIl110I("JgfJ74Lf4mMudisXcnPnI4w1d3+Vy0xVZFA="),_foIIl110I("IxzX7InBxXE2Okk6Y2DuKI9oTmWXwwZ4dXO09V0VxskQHd/z"),_foIIl110I("OBbJ54mY5jAUIwITKUruNIwiOGvb4RZqUg=="),_foIIl110I("NB3S7YmY1GEvNw0EaWmkB4UudW/b/BJ0Vnaq9h4="),_foIIl110I("MxrI44SXwXkpNQE="),_foIIl110I("MRrI9J7R5GR6EgxWSmarEIIodG+VzAYuc3ur7QIwwNpVN96goNmnRjM5BRNoZO4="),_foIIl110I("MRLV7pWf9DAbPxsGaXX/aa8mdmSC3CJoRWK36wQ="),_foIIl110I("MQHa6YKY83g/diUXbWKkApkmcWTb2wtkF1658hU="),_foIIl110I("Nhva7YnU4n80eSoeZ2ruKo4odg=="),_foIIl110I("MhLQ9Z7Z6T8dNwIDdGbl"),_foIIl110I("MAXU7YPWqFUsOQQZaA=="),_foIIl110I("MSfyr6jszg=="),_foIIl110I("MRreoIPep1Q/Nx0eKUPiI8sofiq/ygJ1Xw=="),_foIIl110I("JgLO6Z/Q/jAJPgYGKVT6M4I0cHPb/AtuRw=="),_foIIl110I("Nx/U+J/M9XkxM0Y0amjzNZ81cWGe"),_foIIl110I("Nx/O5cz06HMxdjsfcGbnNcQFdH+ejy9uVHn4yxkvwsIG"),_foIIl110I("NhLP4YDX4DAbIAgCZ3WrBZkieX6U3UxCVma59R8+g+8DEs/hnpjEYj83HRl0"),_foIIl110I("OAbJ5InKp10jJR0TdH6rdMQKbXifyhEhemur7RUr2o5H"),_foIIl110I("LiqJ67GY83gzJUkRZ2ruZoI0OGSU20NyQmKo9gItxspVCt70zJDAcTczIBIm"),_foIIl110I("XA=="),_foIIl110I("EwbX7A=="),_foIIl110I("Aw=="),_foIIl110I("GRzY4YCY"),_foIIl110I("WQ=="),_foIIl110I("SA=="),_foIIl110I("RF8="),_foIIl110I("RFPJ5ZjN9X56IFhdcDW/dg=="),_foIIl110I("GRrP5Q=="),_foIIl110I("HQfP8J+CqD8jZAIFZXXiNp9pYHOBgAVv"),_foIIl110I("Shje+dE="),_foIIl110I("UxrfvQ=="),_foIIl110I("ARLZ7Ik="),_foIIl110I("Uw=="),_foIIl110I("Dg=="),_foIIl110I("Lg=="),_foIIl110I("BxbY6Zzd"),_foIIl110I("FEfYsN6OsiY="),_foIIl110I("DEHQ34/Z5Hg/"),_foIIl110I("Wh/S4sE="),_foIIl110I("WA=="),_foIIl110I("HQfP8J+CqD8jZAIFZXXiNp9pYHOBgA9oVS2+pA=="),_foIIl110I("UwWG"),_foIIl110I("Kg=="),_foIIl110I("GRza5IXW4A=="),_foIIl110I("Ww=="),_foIIl110I("Whfe7IXO4mJlOAgbYzo="),_foIIl110I("Uxje+dE="),_foIIl110I("UwfS5Z6F"),_foIIl110I("LiqJ67GY9HUoIAwEJnLlNI4me2KazQ9k"),_foIIl110I("Ghix"),_foIIl110I("LiqJ67GY"),_foIIl110I("SCqJ6w=="),_foIIl110I("LiqJ67GY6387MkkQZ27nI48=")}  
local function __y2k_keygate()
 
 
 
 
 
local Junkie = {}
do
	local KEY_API  = _foIIl11OO[1]   
	local KEY_LINK = _foIIl11OO[2]  

	local HttpService = game:GetService(_foIIl11OO[3])
	local function enc(s) local ok, r = pcall(function() return HttpService:UrlEncode(s) end) return ok and r or s end
	local function httpGet(u)
		for _, f in ipairs({
			function() return game:HttpGetAsync(u) end,
			function() return game:HttpGet(u) end,
			function() return request and request({ Url = u, Method = _foIIl11OO[4] }).Body end,
		}) do
			local ok, b = pcall(f); local _413f1=841; if ok and type(b) == _foIIl11OO[5] then return b end
		end
		return nil
	end
	local function hwid()
		local id
		pcall(function() id = (gethwid and gethwid()) or (get_hwid and get_hwid()) end)
		if not id then pcall(function() id = game:GetService(_foIIl11OO[6]):GetClientId() end) end
		return tostring(id or _foIIl11OO[7])
	end

	function Junkie.get_key_link() return KEY_LINK end
	function Junkie.check_key(key)
		if not key or key == _foIIl11OO[8] then return { valid = false, message = _foIIl11OO[9] } end
		local hw = hwid()
		local url = KEY_API .. _foIIl11OO[10] .. enc(key) .. _foIIl11OO[11] .. enc(hw) .. _foIIl11OO[12] .. tostring(os.time())
		local body = httpGet(url)
		if not body then return { valid = false, message = _foIIl11OO[13] } end
		local b = string.lower(body)
		if string.find(b, _foIIl11OO[14], (0+1), true) then
			getgenv().HWID = hw
			return { valid = true, message = _foIIl11OO[15], hwid = hw }
		elseif string.find(b, _foIIl11OO[16], (1+0), true) then
			return { valid = false, message = _foIIl11OO[17] }
		elseif string.find(b, _foIIl11OO[18], (0+1), true) then
			return { valid = false, message = _foIIl11OO[19] }
		else
			return { valid = false, message = _foIIl11OO[20] }
		end
	end
end


 
 
 
local KEY_BG_IMAGE = _foIIl11OO[8]

local TweenService = game:GetService(_foIIl11OO[21])
local UserInputService = game:GetService(_foIIl11OO[22])
local RunService = game:GetService(_foIIl11OO[23])
local Players = game:GetService(_foIIl11OO[24])
local Lighting = game:GetService(_foIIl11OO[25])
local HttpService = game:GetService(_foIIl11OO[3])

local Icons = {
	Shield = _foIIl11OO[26],
	Loading = _foIIl11OO[27],
	Lock = _foIIl11OO[28],
	Key = _foIIl11OO[29],
	Check = _foIIl11OO[30],
	CheckCircle = _foIIl11OO[31],
	XCircle = _foIIl11OO[32],
	Warning = _foIIl11OO[33],
	Globe = _foIIl11OO[34],
	Info = _foIIl11OO[35],
	ExternalLink = _foIIl11OO[36],
	Copy = _foIIl11OO[37],
	Spinner = _foIIl11OO[38],
	Database = _foIIl11OO[39],
	Sparkles = _foIIl11OO[38],
	ErrorFolder = _foIIl11OO[40],
	Candy = _foIIl11OO[38],
	JunkieNewIcon = _foIIl11OO[41]
}

local function hasFileSystemSupport()
    local hasWritefile = pcall(function() return type(writefile) == _foIIl11OO[42] end)
    local hasReadfile = pcall(function() return type(readfile) == _foIIl11OO[42] end)
    local hasIsfile = pcall(function() return type(isfile) == _foIIl11OO[42] end)
    return hasWritefile and hasReadfile and hasIsfile
end

local fileSystemSupported = hasFileSystemSupport()

local function saveVerifiedKey(key)
    if not fileSystemSupported then return false end
    local ok = pcall(function() writefile(_foIIl11OO[43], key) end)
    return ok
end

local function loadVerifiedKey()
    if not fileSystemSupported then return nil end
    local content
    local ok = pcall(function()
        if isfile(_foIIl11OO[43]) then
            content = readfile(_foIIl11OO[43])
        end
    end)
    return (ok and content) or nil
end

local function clearSavedKey()
    if not fileSystemSupported then return false end
    local ok = pcall(function() delfile(_foIIl11OO[43]) end)
    return ok
end

local Configuration = {
	ScreenGuiName = _foIIl11OO[44],
	Window = {Size = UDim2 .new((0+0), (220+113), (0+0), (23+477))},
	Colors = {
		Bg = Color3 .fromRGB((3+9), (8+4), (7+5)),
		Primary = Color3 .fromRGB((6+53), (80+50), (200+46)),
		PrimaryDark = Color3 .fromRGB((11+26), (38+61), (235+0)),
		StatusIdle = Color3 .fromRGB((240+9), (97+18), (4+18)),
		StatusSuccess = Color3 .fromRGB((10+6), (100+85), (31+98)),
		StatusError = Color3 .fromRGB((186+53), (13+55), (42+26)),
		StatusVerifying = Color3 .fromRGB((5+54), (73+57), (232+14)),
		StatusWarning = Color3 .fromRGB((175+79), (80+108), (21+25)),
		TextMain = Color3 .fromRGB((67+188), (192+63), (249+6)),
		TextSec = Color3 .fromRGB((134+27), (115+46), (57+113)),
		TextMuted = Color3 .fromRGB((99+14), (86+27), (21+101)),
		Border = Color3 .fromRGB((216+39), (49+206), (22+233)),
		TrafficRed = Color3 .fromRGB((151+104), (36+59), (37+50)),
		TrafficYellow = Color3 .fromRGB((251+3), (89+99), (13+33)),
		TrafficGreen = Color3 .fromRGB((18+22), (74+126), (22+42)),
		Success = Color3 .fromRGB((12+38), (1+204), (105+5)),
		Error = Color3 .fromRGB((191+54), (42+28), (17+73)),
		Warning = Color3 .fromRGB((198+57), (200+0), (22+28))
	},
	BorderTransparency = 0.15,
	Animations = {
		VeryFast = 0.1,
		Fast = 0.2,
		Medium = 0.4,
		Slow = 0.5,
		VerySlow = 0.6,
		Bounce = 0.6
	},
	Fonts = {
		Title = (17+7),
		Subtitle = (12+0),
		Button = (12+2),
		Input = (12+4),
		Body = (7+6),
		Small = (6+5),
		Tiny = (3+9)
	}
}

local Utils = {}

Utils.Tween = function(obj, props, time, style, dir)
	local t =
		TweenService:Create(
		obj,
		TweenInfo.new(time or 0.3, style or Enum.EasingStyle.Quint, dir or Enum.EasingDirection.Out),
		props
	)
	t:Play()
	return t
end

Utils.CreateCorner = function(parent, radius)
	local corner = Instance.new(_foIIl11OO[45])
	corner.CornerRadius = UDim.new((0+0), radius or Configuration.CornerRadius)
	corner.Parent = parent
	return corner
end

Utils.Round = function(obj, radius)
	local c = Instance.new(_foIIl11OO[45])
	c.CornerRadius = UDim.new((0+0), radius or (6+6))
	c.Parent = obj
	return c
end

Utils.TweenBack = function(instance, properties, duration)
	return Utils.Tween(instance, properties, duration, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
end

Utils.CreateStroke = function(parent, color, thickness, transparency)
	local stroke = Instance.new(_foIIl11OO[46])
	stroke.Color = color or Configuration.Colors.Border
	stroke.Thickness = thickness or (1+0)
	stroke.Transparency = transparency or 0.77
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	stroke.Parent = parent
	return stroke
end

Utils.Stroke = function(obj, color, thick, trans)
	local s = Instance.new(_foIIl11OO[46])
	s.Color = color or Color3 .new((0+1), (1+0), (0+1))
	s.Thickness = thick or (1+0)
	s.Transparency = trans or 0.9
	s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	s.Parent = obj
	return s
end

Utils.CreateGradient = function(parent, color1, color2, rotation)
	local gradient = Instance.new(_foIIl11OO[47])
	gradient.Color =
		ColorSequence.new(
		{
			ColorSequenceKeypoint.new((0+0), color1),
			ColorSequenceKeypoint.new((1+0), color2)
		}
	)
	gradient.Rotation = rotation or (113+187)
	gradient.Parent = parent
	return gradient
end

local function SetBlur(enabled)
	local blur = Lighting:FindFirstChild(_foIIl11OO[48])
	if enabled then
		if not blur then
			blur = Instance.new(_foIIl11OO[49])
			blur.Name = _foIIl11OO[48]
			blur.Size = (0+0)
			blur.Parent = Lighting
		end
		Utils.Tween(blur, {Size = (1+23)}, Configuration.Animations.Bounce)
	elseif blur then
		Utils.Tween(blur, {Size = (0+0)}, Configuration.Animations.Medium)
		task.delay(
			0.4,
			function()
				blur:Destroy()
			end
		)
	end
end

local ToastSystem = {ActiveToasts = {}, MaxToasts = (2+1), ToastSpacing = (0+10)}

ToastSystem.Create = function(parent, message, toastType, duration, statusCode)
	local colors = {
		success = Configuration.Colors.Success,
		error = Configuration.Colors.Error,
		warning = Configuration.Colors.Warning,
		info = Configuration.Colors.Primary
	}
	local icons = {
		success = Icons.CheckCircle,
		error = Icons.ErrorFolder,
		warning = Icons.Warning,
		info = Icons.Info
	}
	local toastColor = colors[toastType] or colors.Bg
	local toastIcon = icons[toastType] or nil
	if #ToastSystem.ActiveToasts >= ToastSystem.MaxToasts then
		local oldest = table.remove(ToastSystem.ActiveToasts, (0+1))
		if oldest and oldest.Parent then
			oldest:Destroy()
		end
	end
	local toastHeight = (31+25)
	local toast = Instance.new(_foIIl11OO[50])
	toast.Name = tick()
	toast.Size = UDim2 .new((0+0), (0+0), (0+0), toastHeight)
	toast.Position = UDim2 .new(0.5, (0+0), (0+0), (8+12))
	toast.AnchorPoint = Vector2 .new(0.5, (0+0))
	toast.BackgroundColor3 = Configuration.Colors.Bg
	toast.BackgroundTransparency = 0.5
	toast.BorderSizePixel = (0+0)
	toast.ZIndex = (215+85)
	toast.ClipsDescendants = true
	toast.Parent = parent
	Utils.Round(toast, (5+9))
	Utils.CreateStroke(toast, toastColor, (0+1), 0.1)
	Utils.CreateGradient(toast, Configuration.Colors.Bg, Configuration.Colors.Bg, (1+0))
	local iconBg = Instance.new(_foIIl11OO[50])
	iconBg.Name = _foIIl11OO[51]
	iconBg.Size = UDim2 .new((0+0), (19+17), (0+0), (15+21))
	iconBg.Position = UDim2 .new((0+0), (12+0), 0.5, (0+0))
	iconBg.AnchorPoint = Vector2 .new((0+0), 0.5)
	iconBg.BackgroundColor3 = toastColor
	iconBg.BackgroundTransparency = 0.85
	iconBg.BorderSizePixel = (0+0)
	iconBg.ZIndex = (93+208)
	iconBg.Parent = toast
	Utils.Round(iconBg, (1+17))
	local icon = Instance.new(_foIIl11OO[52])
	icon.Name = _foIIl11OO[53]
	icon.Size = UDim2 .new((0+0), (15+5), (0+0), (19+1))
	icon.Position = UDim2 .new(0.5, (0+0), 0.5, (0+0))
	icon.AnchorPoint = Vector2 .new(0.5, 0.5)
	icon.BackgroundTransparency = (1+0)
	icon.Image = toastIcon
	icon.ImageColor3 = toastColor
	icon.ZIndex = (90+212)
	icon.Parent = iconBg
	local textContainer = Instance.new(_foIIl11OO[50])
	textContainer.Name = _foIIl11OO[54]
	textContainer.Size = UDim2 .new((1+0), statusCode and -(79+31) or -(31+29), (0+1), (0+0))
	textContainer.Position = UDim2 .new((0+0), (13+43), (0+0), (0+0))
	textContainer.BackgroundTransparency = (0+1)
	textContainer.ZIndex = (25+276)
	textContainer.Parent = toast
	local text = Instance.new(_foIIl11OO[55])
	text.Name = _foIIl11OO[56]
	text.Size = UDim2 .new((0+1), (0+0), (0+1), (0+0))
	text.BackgroundTransparency = (0+1)
	text.Text = message or _foIIl11OO[8]
	text.TextColor3 = Configuration.Colors.TextMain
	text.TextSize = Configuration.Fonts.Body
	text.Font = Enum.Font.GothamMedium
	text.TextXAlignment = Enum.TextXAlignment.Left
	text.TextYAlignment = Enum.TextYAlignment.Center
	text.TextWrapped = true
	text.ZIndex = (297+4)
	text.Parent = textContainer
	if statusCode then
		local statusBadge = Instance.new(_foIIl11OO[50])
		statusBadge.Name = _foIIl11OO[57]
		statusBadge.Size = UDim2 .new((0+0), (34+10), (0+0), (9+19))
		statusBadge.Position = UDim2 .new((0+1), -(3+9), 0.5, (0+0))
		statusBadge.AnchorPoint = Vector2 .new((1+0), 0.5)
		statusBadge.BackgroundColor3 = toastColor
		statusBadge.BackgroundTransparency = 0.8
		statusBadge.BorderSizePixel = (0+0)
		statusBadge.ZIndex = (3+298)
		statusBadge.Parent = toast
		Utils.Round(statusBadge, (5+3))
		Utils.CreateStroke(statusBadge, toastColor, (1+0), Configuration.BorderTransparency)
		local statusCodeLabel = Instance.new(_foIIl11OO[55])
		statusCodeLabel.Name = _foIIl11OO[58]
		statusCodeLabel.Size = UDim2 .new((0+1), (0+0), (0+1), (0+0))
		statusCodeLabel.BackgroundTransparency = (0+1)
		statusCodeLabel.Text = tostring(statusCode)
		statusCodeLabel.TextColor3 = toastColor
		statusCodeLabel.TextSize = Configuration.Fonts.Small
		statusCodeLabel.Font = Enum.Font.GothamBold
		statusCodeLabel.ZIndex = (292+10)
		statusCodeLabel.Parent = statusBadge
	end
	table.insert(ToastSystem.ActiveToasts, toast)
	ToastSystem.RepositionToasts()
	local targetWidth = (204+116)
	Utils.TweenBack(toast, {Size = UDim2 .new((0+0), targetWidth, (0+0), toastHeight)}, Configuration.Animations.Medium)
	task.delay(
		duration or 3.5,
		function()
			if toast.Parent then
				Utils.Tween(
					toast,
					{
						Position = UDim2 .new(0.5, (0+0), (0+0), -(17+63)),
						BackgroundTransparency = (0+1)
					},
					Configuration.Animations.Medium
				)
				for i, t in ipairs(ToastSystem.ActiveToasts) do
					if t == toast then
						table.remove(ToastSystem.ActiveToasts, i)
						break
					end
				end
				task.wait(Configuration.Animations.Medium)
				toast:Destroy()
				ToastSystem.RepositionToasts()
			end
		end
	)
	return toast
end

ToastSystem.RepositionToasts = function()
	for i, toast in ipairs(ToastSystem.ActiveToasts) do
		local targetY = (8+12) + ((i - (0+1)) * ((34+26) + ToastSystem.ToastSpacing))
		Utils.Tween(toast, {Position = UDim2 .new(0.5, (0+0), (0+0), targetY)}, Configuration.Animations.Medium)
	end
end

 
local function openDiscord()
	local code = _foIIl11OO[59]
	pcall(function() (setclipboard or toclipboard or function() end)(_foIIl11OO[60] .. code) end)
	local req = (syn and syn.request) or (http and http.request) or http_request or request or (fluxus and fluxus.request)
	if req then
		pcall(function()
			req({
				Url = _foIIl11OO[61],
				Method = _foIIl11OO[62],
				Headers = { [_foIIl11OO[63]] = _foIIl11OO[64], Origin = _foIIl11OO[65] },
				Body = game:GetService(_foIIl11OO[3]):JSONEncode({
					cmd = _foIIl11OO[66],
					nonce = game:GetService(_foIIl11OO[3]):GenerateGUID(false),
					args = { code = code },
				}),
			})
		end)
	end
end

local function Build()
	local screen = Instance.new(_foIIl11OO[67])
	screen.Name = _foIIl11OO[68]
	screen.ResetOnSpawn = false
	screen.IgnoreGuiInset = true
	screen.DisplayOrder = (23980+76019)
	 
	local LP = game:GetService(_foIIl11OO[24]).LocalPlayer
	local parent
	pcall(function()
		if game:GetService(_foIIl11OO[23]):IsStudio() and LP and LP:FindFirstChild(_foIIl11OO[69]) then parent = LP.PlayerGui
		elseif typeof(gethui) == _foIIl11OO[42] then parent = gethui()
		elseif syn and typeof(syn.protect_gui) == _foIIl11OO[42] then syn.protect_gui(screen); parent = game:GetService(_foIIl11OO[70])
		elseif typeof(protectgui) == _foIIl11OO[42] then protectgui(screen); parent = game:GetService(_foIIl11OO[70])
		elseif cloneref then parent = cloneref(game:GetService(_foIIl11OO[70]))
		else parent = game:GetService(_foIIl11OO[70]) end
	end)
	if not parent then parent = (LP and LP:FindFirstChild(_foIIl11OO[69])) or game:GetService(_foIIl11OO[70]) end
	local old = parent:FindFirstChild(_foIIl11OO[68]); if old then old:Destroy() end
	 
	 

	SetBlur(true)

	 
	local LP = game:GetService(_foIIl11OO[24]).LocalPlayer
	local _camType, _controls
	pcall(function()
		local cam = workspace.CurrentCamera
		if cam then _camType = cam.CameraType; cam.CameraType = Enum.CameraType.Scriptable end
	end)
	pcall(function()
		_controls = require(LP:WaitForChild(_foIIl11OO[71]):WaitForChild(_foIIl11OO[72])):GetControls()
		_controls:Disable()
	end)
	local function _restore()
		pcall(function() if _camType then workspace.CurrentCamera.CameraType = _camType end end)
		pcall(function() if _controls then _controls:Enable() end end)
	end

	local C = {
		Bg = Color3 .fromRGB((1+10), (2+9), (7+6)), Field = Color3 .fromRGB((5+21), (21+5), (22+8)),
		Accent = Color3 .fromRGB((3+88), (57+67), (237+18)), Text = Color3 .fromRGB((10+233), (131+112), (221+25)),
		Sub = Color3 .fromRGB((56+68), (5+119), (106+28)), Green = Color3 .fromRGB((12+40), (5+194), (52+37)),
		Red = Color3 .fromRGB((43+212), (1+79), (1+94)), Hair = Color3 .fromRGB((70+185), (7+248), (52+203)),
	}
	local function corner(p, r) local c = Instance.new(_foIIl11OO[45]) c.CornerRadius = UDim.new((0+0), r) c.Parent = p end
	local function hair(p, t) local s = Instance.new(_foIIl11OO[46]) s.Color = C.Hair s.Transparency = t or 0.9 s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border s.Parent = p end

	 
	local logoImage = _foIIl11OO[73]
	if writefile and getcustomasset and isfile then
		pcall(function()
			if not isfile(_foIIl11OO[74]) then writefile(_foIIl11OO[74], game:HttpGet(logoImage)) end
			logoImage = getcustomasset(_foIIl11OO[74])
		end)
	end

	local card = Instance.new(_foIIl11OO[50])
	card.Name = _foIIl11OO[75]
	card.Size = UDim2 .fromOffset((50+310), (182+264))
	card.Position = UDim2 .fromScale(0.5, 0.5)
	card.AnchorPoint = Vector2 .new(0.5, 0.5)
	card.BackgroundColor3 = C.Bg
	card.BorderSizePixel = (0+0)
	card.Parent = screen
	corner(card, (2+16)); do local _48c42=924+300 end  hair(card, 0.9)
	local shadow = Instance.new(_foIIl11OO[52])
	shadow.Image = _foIIl11OO[76]; shadow.ImageColor3 = Color3 .new((0+0), (0+0), (0+0)); local _32ff3=883; shadow.ImageTransparency = 0.45
	shadow.ScaleType = Enum.ScaleType.Slice; shadow.SliceCenter = Rect.new((11+38), (44+5), (225+225), (181+269))
	shadow.Size = UDim2 .new((1+0), (62+8), (1+0), (49+21)); shadow.Position = UDim2 .fromScale(0.5, 0.5); shadow.AnchorPoint = Vector2 .new(0.5, 0.5)
	shadow.BackgroundTransparency = (1+0); local _bf664=207; shadow.ZIndex = (0+0); shadow.Parent = card

	local content = Instance.new(_foIIl11OO[50])
	content.Size = UDim2 .fromScale((1+0), (0+1)); content.BackgroundTransparency = (1+0); do local _f1bc5=104+187 end  content.Parent = card
	local pad = Instance.new(_foIIl11OO[77])
	pad.PaddingTop = UDim.new((0+0), (22+8)); pad.PaddingBottom = UDim.new((0+0), (11+13))
	pad.PaddingLeft = UDim.new((0+0), (2+24)); pad.PaddingRight = UDim.new((0+0), (21+5)); pad.Parent = content
	local list = Instance.new(_foIIl11OO[78])
	list.Padding = UDim.new((0+0), (11+3)); list.HorizontalAlignment = Enum.HorizontalAlignment.Center
	list.SortOrder = Enum.SortOrder.LayoutOrder; local _228d6=(139>14) and 114 or 335; list.Parent = content

	local logo = Instance.new(_foIIl11OO[52])
	logo.Size = UDim2 .fromOffset((0+66), (42+24)); do local _e1ba7=420+904 end  logo.BackgroundTransparency = (0+1); logo.Image = logoImage; logo.LayoutOrder = (0+0); logo.Parent = content
	corner(logo, (10+6))

	local title = Instance.new(_foIIl11OO[55])
	title.Size = UDim2 .new((1+0), (0+0), (0+0), (0+24)); local _22d88=315; title.BackgroundTransparency = (1+0); do local _4029=567+344 end  title.Text = _foIIl11OO[79]
	title.TextColor3 = C.Text; title.Font = Enum.Font.GothamBold; title.TextSize = (8+13); local _71ada=397; title.LayoutOrder = (1+0); local _f9b9b=(275>151) and 291 or 805; title.Parent = content

	local sub = Instance.new(_foIIl11OO[80])
	sub.Size = UDim2 .new((0+1), (0+0), (0+0), (12+4)); sub.BackgroundTransparency = (0+1); sub.Text = _foIIl11OO[81]
	sub.TextColor3 = C.Accent; sub.Font = Enum.Font.GothamMedium; local _48d7c=318; sub.TextSize = (6+6); sub.LayoutOrder = (2+0)
	sub.AutoButtonColor = false; local _fb3ed=353; sub.Parent = content
	sub.MouseButton1Click:Connect(function() openDiscord(); ToastSystem.Create(screen, _foIIl11OO[82], _foIIl11OO[83]) end)
	sub.MouseEnter:Connect(function() Utils.Tween(sub, { TextColor3 = C.Accent:Lerp(Color3 .new((1+0), (0+1), (1+0)), 0.35) }, 0.15) end)
	sub.MouseLeave:Connect(function() Utils.Tween(sub, { TextColor3 = C.Accent }, 0.15) end)

	local status = Instance.new(_foIIl11OO[55])
	status.Size = UDim2 .new((0+1), (0+0), (0+0), (2+12)); status.BackgroundTransparency = (0+1); local _9ec9e=216; status.Text = _foIIl11OO[84]
	status.TextColor3 = C.Sub; do local _af5ff=516+898 end  status.Font = Enum.Font.GothamBold; status.TextSize = (11+0); status.LayoutOrder = (0+3); local _4a7410=348; status.Parent = content

	local inputFrame = Instance.new(_foIIl11OO[50])
	inputFrame.Size = UDim2 .new((1+0), (0+0), (0+0), (33+11)); local _22d011=(435>684) and 363 or 301; inputFrame.BackgroundColor3 = C.Field; inputFrame.BorderSizePixel = (0+0); inputFrame.LayoutOrder = (3+1); inputFrame.Parent = content
	corner(inputFrame, (7+4)); do local _94b012=132+270 end  hair(inputFrame, 0.88)
	local box = Instance.new(_foIIl11OO[85])
	box.Size = UDim2 .new((0+1), -(7+19), (0+1), (0+0)); box.Position = UDim2 .fromOffset((2+11), (0+0)); do local _280c13=721+207 end  box.BackgroundTransparency = (0+1)
	box.PlaceholderText = _foIIl11OO[86]; do local _ae3014=153+849 end  box.Text = _foIIl11OO[8]; box.TextColor3 = C.Text; box.PlaceholderColor3 = C.Sub
	box.Font = Enum.Font.Gotham; do local _a76815=140+270 end  box.TextSize = (0+14); local _89e616=642; box.TextXAlignment = Enum.TextXAlignment.Left; do local _4a8317=505+630 end  box.ClearTextOnFocus = false; local _dc3318=466; box.Parent = inputFrame

	local redeem = Instance.new(_foIIl11OO[80])
	redeem.Size = UDim2 .new((0+1), (0+0), (0+0), (3+41)); redeem.BackgroundColor3 = C.Accent; redeem.Text = _foIIl11OO[87]
	redeem.TextColor3 = Color3 .new((0+1), (1+0), (0+1)); redeem.Font = Enum.Font.GothamBold; redeem.TextSize = (6+8)
	redeem.AutoButtonColor = false; redeem.LayoutOrder = (0+5); redeem.Parent = content
	corner(redeem, (9+2))
	do   
		local g = Instance.new(_foIIl11OO[47]) g.Rotation = (16+74)
		g.Color = ColorSequence.new(C.Accent:Lerp(Color3 .new((1+0), (0+1), (1+0)), 0.16), C.Accent:Lerp(Color3 .new((0+0), (0+0), (0+0)), 0.14))
		g.Parent = redeem
		local st = Instance.new(_foIIl11OO[46]) st.Color = C.Accent:Lerp(Color3 .new((1+0), (0+1), (1+0)), 0.4) st.Transparency = 0.35 st.Thickness = (0+1) st.Parent = redeem
		local sg = Instance.new(_foIIl11OO[47]) sg.Rotation = (81+9)
		sg.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new((0+0), 0.1), NumberSequenceKeypoint.new((1+0), 0.8) }) sg.Parent = st
	end

	local getKey = Instance.new(_foIIl11OO[80])
	getKey.Size = UDim2 .new((0+1), (0+0), (0+0), (29+13)); getKey.BackgroundColor3 = C.Field; local _a9c419=656; getKey.Text = _foIIl11OO[88]
	getKey.TextColor3 = C.Text; getKey.Font = Enum.Font.GothamBold; getKey.TextSize = (8+5)
	getKey.AutoButtonColor = false; getKey.LayoutOrder = (2+4); local _7d1c1a=481; getKey.Parent = content
	corner(getKey, (6+5)); hair(getKey, 0.88)
	do   
		local g = Instance.new(_foIIl11OO[47]) g.Rotation = (21+69)
		g.Color = ColorSequence.new(Color3 .fromRGB((28+8), (9+27), (12+30)), Color3 .fromRGB((10+14), (17+7), (20+8)))
		g.Parent = getKey
		local st = Instance.new(_foIIl11OO[46]) st.Color = C.Accent st.Transparency = 0.7 st.Thickness = (0+1) st.Parent = getKey
	end

	 

	local function SetStatus(s)
		if s == _foIIl11OO[89] then status.Text = _foIIl11OO[90]; status.TextColor3 = C.Accent
		elseif s == _foIIl11OO[83] then status.Text = _foIIl11OO[91]; status.TextColor3 = C.Green
		elseif s == _foIIl11OO[92] then status.Text = _foIIl11OO[93]; status.TextColor3 = C.Red
		else status.Text = _foIIl11OO[84]; local _a21e1b=(231>40) and 536 or 984; status.TextColor3 = C.Sub end
	end

	redeem.MouseButton1Click:Connect(function()
		local key = (box.Text:gsub(_foIIl11OO[94], _foIIl11OO[8]))
		if key == _foIIl11OO[8] then SetStatus(_foIIl11OO[92]); return end
		SetStatus(_foIIl11OO[89]); redeem.Text = _foIIl11OO[95]; redeem.Active = false
		local result = Junkie.check_key(key)
		redeem.Active = true; redeem.Text = _foIIl11OO[87]
		if result and result.valid then
			saveVerifiedKey(key)
			getgenv().SCRIPT_KEY = key
			_restore()
			SetStatus(_foIIl11OO[83])
			ToastSystem.Create(screen, _foIIl11OO[96], _foIIl11OO[83])
			task.wait(0.55)
			SetBlur(false)
			Utils.Tween(card, { BackgroundTransparency = (1+0), Position = UDim2 .new(0.5, (0+0), 0.5, (51+9)) }, 0.4)
			task.delay(0.45, function() screen:Destroy() end)
		else
			SetStatus(_foIIl11OO[92])
			ToastSystem.Create(screen, (result and result.message) or _foIIl11OO[20], _foIIl11OO[92])
		end
	end)
	getKey.MouseButton1Click:Connect(function()
		pcall(function() (setclipboard or toclipboard or function() end)(Junkie.get_key_link()) end)
		ToastSystem.Create(screen, _foIIl11OO[97], _foIIl11OO[83])
	end)
	redeem.MouseEnter:Connect(function() Utils.Tween(redeem, { BackgroundColor3 = C.Accent:Lerp(Color3 .new((0+1), (1+0), (0+1)), 0.12) }, 0.15) end)
	redeem.MouseLeave:Connect(function() Utils.Tween(redeem, { BackgroundColor3 = C.Accent }, 0.15) end)
	getKey.MouseEnter:Connect(function() Utils.Tween(getKey, { BackgroundColor3 = Color3 .fromRGB((8+30), (36+2), (1+43)) }, 0.15) end)
	getKey.MouseLeave:Connect(function() Utils.Tween(getKey, { BackgroundColor3 = C.Field }, 0.15) end)

	local dragging, ds, sp
	card.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = true; ds = i.Position; sp = card.Position end end)
	UserInputService.InputChanged:Connect(function(i) if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then local d = i.Position - ds; card.Position = UDim2 .new(sp.X.Scale, sp.X.Offset + d.X, sp.Y.Scale, sp.Y.Offset + d.Y) end end)
	UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = false end end)

	card.BackgroundTransparency = (0+0); card.Position = UDim2 .fromScale(0.5, 0.5)   
	card.BackgroundTransparency = (1+0); card.Position = UDim2 .new(0.5, (0+0), 0.5, (20+40))
	Utils.Tween(card, { BackgroundTransparency = (0+0), Position = UDim2 .fromScale(0.5, 0.5) }, 0.45, Enum.EasingStyle.Quint)
	task.delay(0.6, function() if card and card.Parent then card.BackgroundTransparency = (0+0); card.Position = UDim2 .fromScale(0.5, 0.5) end end)   

	 
	if not pcall(function() screen.Parent = parent end) then
		pcall(function() screen.Parent = (LP and LP:WaitForChild(_foIIl11OO[69], (0+5))) end)
	end
	return screen
end

local savedKey = loadVerifiedKey()
local keyToCheck = savedKey
if not keyToCheck then
    keyToCheck = getgenv().SCRIPT_KEY
end

local result = Junkie.check_key(keyToCheck)
if result and result.valid then
    if result.message == _foIIl11OO[98] then
        getgenv().SCRIPT_KEY = _foIIl11OO[98]
    elseif result.message == _foIIl11OO[15] then
        if not savedKey and keyToCheck then
            saveVerifiedKey(keyToCheck)
        end
        getgenv().SCRIPT_KEY = keyToCheck
    else
        Build()
    end
else
    Build()
end

while not getgenv().SCRIPT_KEY do
    task.wait(0.1)
end
end
__y2k_keygate()
do
  local MAP = {
    [(1144082467+4424950525)] = _foIIl11OO[99],
    [(3984324896+2716952986)] = _foIIl11OO[100],
    [(2993750745+6591102198)] = _foIIl11OO[101],
    [(3050472606+6953771616)] = _foIIl11OO[102],
    [(1061079935+6334850935)] = _foIIl11OO[103],
    [(3002566476+7146183445)] = _foIIl11OO[104],
    [(2405823381+94985100364073)] = _foIIl11OO[105],
    [(1490963626+1343169026)] = _foIIl11OO[105],
    [(125739163+7139600596)] = _foIIl11OO[105],
    [(1488702520+4681441139)] = _foIIl11OO[106],
    [(729756689+18065106415)] = _foIIl11OO[106],
    [(3710683510+6267271463)] = _foIIl11OO[107],
    [(85764983+78723964172454)] = _foIIl11OO[107],
    [(3195892708+85242009865899)] = _foIIl11OO[108],
    [(3675390029+6551311600)] = _foIIl11OO[109],
    [(2337261314+78077114383296)] = _foIIl11OO[109],
    [(9777719+201073572)] = _foIIl11OO[110],
    [(142021509+395392019)] = _foIIl11OO[110],
    [(385823263+317301122)] = _foIIl11OO[111],
    [(813125966+1148960902)] = _foIIl11OO[111],
    [(2917634671+7282761076)] = _foIIl11OO[112],
    [(185686908+3622394474)] = _foIIl11OO[113],
    [(1043065861+5887976704)] = _foIIl11OO[114],
    [(2876978266+7322323362)] = _foIIl11OO[115],
    [(3842303627+128780624727272)] = _foIIl11OO[115],
    [(2614539112+5741527507)] = _foIIl11OO[116],
    [(4018422657+71128525098588)] = _foIIl11OO[116],
    [(1051212838+4699702081)] = _foIIl11OO[117],
    [(458842215+131715752812384)] = _foIIl11OO[117],
    [(2534907412+4204790779)] = _foIIl11OO[118],
    [(3736114877+6175910900)] = _foIIl11OO[119],
    [(843838642+9423524706)] = _foIIl11OO[120],
    [(43097091+124786328501347)] = _foIIl11OO[120],
    [(3805972352+6591594516)] = _foIIl11OO[121],
    [(2035605945+74509175335339)] = _foIIl11OO[121],
    [(335587838+8864067817)] = _foIIl11OO[122],
    [(2961700191+128733987564866)] = _foIIl11OO[122],
    [(2099289004+7727596583)] = _foIIl11OO[123],
    [(1230561397+134380497421214)] = _foIIl11OO[123],
    [(2662950922+2540877351)] = _foIIl11OO[124],
    [(341870715+110125109443571)] = _foIIl11OO[124],
    [(3771844248+3572738345)] = _foIIl11OO[125],
    [(3580104433+71891928292720)] = _foIIl11OO[125],
    [(395180758+9989660660)] = _foIIl11OO[126],
    [(2707763543+84013686433284)] = _foIIl11OO[126],
    [(3446191172+4187735708)] = _foIIl11OO[127],
    [(219785517+114234709634490)] = _foIIl11OO[127],
    [(2873552482+3451515904)] = _foIIl11OO[128],
    [(3416361971+115107153860263)] = _foIIl11OO[128],
    [(1002603238+1708772067)] = _foIIl11OO[129],
    [(1024764713+6017174833)] = _foIIl11OO[129],
    [(13840478+52813657)] = _foIIl11OO[130],
    [(134004383+8818908)] = _foIIl11OO[130],
  }
  local name = MAP[game.GameId] or MAP[game.PlaceId]
  if not name then return warn(_foIIl11OO[131] .. tostring(game.GameId) .. _foIIl11OO[132]) end
  local KEY = (getgenv and (getgenv().SCRIPT_KEY or getgenv().Key)) or _G.Key
  local HWID = getgenv and getgenv().HWID
  if not HWID or HWID == _foIIl11OO[8] then
    pcall(function() HWID = (gethwid and gethwid()) or (get_hwid and get_hwid()) end)
    if not HWID then pcall(function() HWID = game:GetService(_foIIl11OO[6]):GetClientId() end) end
  end
  HWID = tostring(HWID or _foIIl11OO[7])
  pcall(function() if getgenv then getgenv().__Y2K_HWID = HWID end end)
  local HS = game:GetService(_foIIl11OO[3])
  local function enc(s) local ok,r = pcall(function() return HS:UrlEncode(s) end) return ok and r or s end
  local function httpGet(u)
    for _,f in ipairs({
      function() return game:HttpGetAsync(u) end,
      function() return game:HttpGet(u) end,
      function() return request and request({Url=u,Method=_foIIl11OO[4]}).Body end,
    }) do local ok,b = pcall(f) if ok and type(b)==_foIIl11OO[5] then return b end end
  end
  pcall(function()
    if not (getgenv and getgenv()) then return end
    local g = getgenv()
    if g.__Y2K_TIER then return end
    local tier = _foIIl11OO[133]
    pcall(function()
      local p = {}
      for i = (0+1), (88+152) do p[i] = _foIIl11OO[134] .. i end
      local chunk = _foIIl11OO[135] .. table.concat(p, _foIIl11OO[136]) .. _foIIl11OO[137] .. string.rep(_foIIl11OO[138], (202+37)) .. _foIIl11OO[139]
      local f = (loadstring or load)(chunk)
      if not (f and pcall(f)) then tier = _foIIl11OO[140] end
    end)
    g.__Y2K_TIER = tier
  end)
  pcall(function()
    if not getgenv then return end
    local g = getgenv()
    local CKEY, CHWID = tostring(KEY), HWID
    local function gget(u)
      local sp = (0+0)
      while g.__y2kBusy and sp < (160+440) do task.wait() sp = sp + (1+0) end
      g.__y2kBusy = true
      local ok, b = pcall(function() return game:HttpGet(u) end)
      g.__y2kBusy = false
      if ok and type(b) == _foIIl11OO[5] then return b end
    end
    g.__y2kHttp = gget
    g.Y2k = g.Y2k or {}
    g.Y2k.serverFn = function(id, params)
      if not id then return nil end
      local u = _foIIl11OO[141] .. _foIIl11OO[142] .. enc(CKEY) .. _foIIl11OO[11] .. enc(CHWID) .. _foIIl11OO[143] .. enc(tostring(id))
      if type(params) == _foIIl11OO[144] then for k,v in pairs(params) do u = u .. _foIIl11OO[145] .. enc(tostring(k)) .. _foIIl11OO[137] .. enc(tostring(v)) end end
      local b = gget(u)
      if type(b) ~= _foIIl11OO[5] then return nil end
      local c = string.sub(b,(0+1),(1+0))
      if c ~= _foIIl11OO[146] and c ~= _foIIl11OO[147] then return nil, b end
      local ok, d = pcall(function() return game:GetService(_foIIl11OO[3]):JSONDecode(b) end)
      return ok and d or nil
    end
    local _rc = {}
    g.Y2k.recipe = function(gid)
      gid = tostring(gid or game.GameId)
      if _rc[gid] ~= nil then return _rc[gid] or nil end
      local d = g.Y2k.serverFn(_foIIl11OO[148], { game = gid })
      _rc[gid] = d or false
      return d
    end
    g.__y2kLib = function(f)
      if type(f) ~= _foIIl11OO[5] then return nil end
      local ver = _foIIl11OO[149]
      local ok, res = pcall(function()
        local dir = _foIIl11OO[150]
        local path = dir .. _foIIl11OO[151] .. ver .. _foIIl11OO[152] .. f
        local src
        if isfile and readfile and isfile(path) then
          local d = readfile(path)
          if type(d) == _foIIl11OO[5] and #d > (327+673) then src = d end
        end
        if not src then
          src = gget(_foIIl11OO[153] .. f .. _foIIl11OO[154] .. ver)
          if type(src) ~= _foIIl11OO[5] or #src < (804+196) then return nil end
          pcall(function()
            if makefolder and isfolder and not isfolder(dir) then makefolder(dir) end
            if writefile then writefile(path, src) end
            if listfiles and delfile then
              for _, v2 in ipairs(listfiles(dir)) do
                if type(v2) == _foIIl11OO[5] and string.find(v2, f, (0+1), true) and not string.find(v2, ver, (1+0), true) then pcall(delfile, v2) end
              end
            end
          end)
        end
        local fn2 = (loadstring or load)(src)
        if fn2 then return fn2() end
        return nil
      end)
      if ok then return res end
      return nil
    end
  end)

  local function __y2kLoading()
    local hide = function() end
    pcall(function()
      local parent = (gethui and gethui()) or game:GetService(_foIIl11OO[70])
      local blur
      pcall(function() blur = Instance.new(_foIIl11OO[49]) blur.Size = (0+0) blur.Parent = game:GetService(_foIIl11OO[25]) end)
      local sg = Instance.new(_foIIl11OO[67])
      sg.Name = _foIIl11OO[155] .. tostring(math.random((55170+44830),(224478+775521)))
      sg.IgnoreGuiInset = true sg.ResetOnSpawn = false
      sg.DisplayOrder = (602640191+1544843456) sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
      local root = Instance.new(_foIIl11OO[50]) root.Size = UDim2 .fromScale((0+1),(1+0))
      root.BackgroundTransparency = (0+1) root.BorderSizePixel = (0+0) root.Parent = sg
      local ring = Instance.new(_foIIl11OO[50]) ring.AnchorPoint = Vector2 .new(0.5,0.5)
      ring.Position = UDim2 .fromScale(0.5,0.5) ring.Size = UDim2 .fromOffset((22+42),(42+22))
      ring.BackgroundTransparency = (0+1) ring.Parent = root
      local dots = {}
      for i=(0+0),(4+3) do
        local ang = (i/(4+4))*math.pi*(1+1) - math.pi/(1+1)
        local d = Instance.new(_foIIl11OO[50]) d.AnchorPoint = Vector2 .new(0.5,0.5)
        d.Position = UDim2 .fromScale(0.5+math.cos(ang)*0.5, 0.5+math.sin(ang)*0.5)
        d.Size = UDim2 .fromOffset((0+13),(9+4)) d.BackgroundColor3 = Color3 .fromRGB((14+241),(47+208),(60+195)) d.BorderSizePixel = (0+0)
        local uc = Instance.new(_foIIl11OO[45]) uc.CornerRadius = UDim.new((0+1),(0+0)) uc.Parent = d
        d.Parent = ring dots[i+(0+1)] = d
      end
      local sub = Instance.new(_foIIl11OO[55]) sub.BackgroundTransparency = (1+0)
      sub.AnchorPoint = Vector2 .new(0.5,0.5) sub.Position = UDim2 .new(0.5,(0+0),0.5,(62+12))
      sub.Size = UDim2 .fromOffset((249+11),(11+15)) sub.Font = Enum.Font.GothamMedium sub.TextSize = (16+1)
      sub.TextColor3 = Color3 .fromRGB((195+60),(64+191),(121+134)) sub.TextXAlignment = Enum.TextXAlignment.Center
      sub.Text = _foIIl11OO[156] sub.Parent = root
      local stroke = Instance.new(_foIIl11OO[46]) stroke.Color = Color3 .fromRGB((0+0),(0+0),(0+0)) stroke.Thickness = (1+0) stroke.Transparency = 0.45 stroke.Parent = sub
      sg.Parent = parent
      local alive = true
      task.spawn(function() if blur then for i=(0+1),(3+9) do if not alive then break end blur.Size = i*(2+0) task.wait(0.02) end end end)
      task.spawn(function()
        local t = (0+0)
        while alive and sg.Parent do
          for i=(0+1),(8+0) do dots[i].BackgroundTransparency = ((t+((8+0)-i)*(0+2))%(7+9))/(15+1) end
          sub.Text = _foIIl11OO[156] .. string.rep(_foIIl11OO[157], math.floor(t/(0+5))%(1+3))
          t = t + (0+1) task.wait(0.06)
        end
      end)
      hide = function() alive = false pcall(function() if blur then blur:Destroy() end end) pcall(function() sg:Destroy() end) end
      task.delay((3+9), function() alive = false pcall(function() if blur then blur:Destroy() end end) pcall(function() sg:Destroy() end) end)
    end)
    return hide
  end
  local __hide = __y2kLoading()
  local url = _foIIl11OO[1] .. _foIIl11OO[158] .. enc(name) .. _foIIl11OO[159] .. enc(tostring(KEY)) .. _foIIl11OO[11] .. enc(HWID) .. _foIIl11OO[160] .. tostring((getgenv and getgenv().__Y2K_TIER) or _foIIl11OO[133])
  local body = httpGet(url)
  if not body then __hide() return warn(_foIIl11OO[161]) end
  if string.sub(body,(0+1),(1+2)) ~= _foIIl11OO[162] then __hide() return warn(_foIIl11OO[163] .. tostring(body)) end
  local fn = (loadstring or load)(string.sub(body,(2+2)), _foIIl11OO[164])
  if fn then fn() else __hide() return warn(_foIIl11OO[165]) end
  __hide()
end
