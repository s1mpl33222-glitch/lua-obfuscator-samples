-- This file was generated at discord.gg/syncrypt

local v171 = game:GetService("Players").LocalPlayer
local v174 = Instance.new("ScreenGui")
local v175 = Instance.new("Frame")
local up24 = v175
local v178 = Instance.new("TextLabel")
local v179 = Instance.new("TextButton")
local v177 = Instance.new("UICorner")
local v181 = Instance.new("TextBox")
local up25 = v181
local v183 = Instance.new("TextBox")
local up26 = v183
local v180 = Instance.new("TextBox")
local up27 = v180
local v182 = Instance.new("UICorner")
local v184 = Instance.new("UICorner")
local v191 = Instance.new("UICorner")
local v194 = Instance.new("TextButton")
local v192 = Instance.new("TextButton")
local v193 = Instance.new("UICorner")
local v195 = Instance.new("UICorner")
Instance.new("TextButton")
local v196 = Instance.new("UICorner")
Instance.new("UICorner")
local v199 = Instance.new("Frame")
v178.Name = "Title"
v178.Parent = up24
v178.Text = "LEGEND HUB"
v178.Position = UDim2.new(0.5, 0, .02, 0)
v178.AnchorPoint = Vector2.new(0.5, 0)
v178.Size = UDim2.new(1, 0, .1, 0)
v178.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
v178.BackgroundTransparency = 1
v178.TextColor3 = Color3.fromRGB(255, 255, 255)
v178.Font = Enum.Font.FredokaOne
v178.TextSize = 30
v178.TextScaled = true
v178.TextStrokeTransparency = .7
v178.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
v178.BorderColor3 = Color3.fromRGB(0, 0, 0)
v178.BorderSizePixel = 0
v174.Name = "Turtorial"
v174.Parent = v171:WaitForChild("PlayerGui")
v174.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
up24.Name = "main"
up24.Parent = v174
up24.BackgroundColor3 = Color3.fromRGB(39, 38, 39)
up24.AnchorPoint = Vector2.new(0.5, 0.5)
up24.Position = UDim2.new(0.5, 0, 0.5, 0)
up24.Size = UDim2.new(0.25, 0, .4, 0)
up24.Active = true
up24.Draggable = true
up24.BorderSizePixel = 0
v199.Name = "shadow"
v199.Parent = up24
v199.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
v199.BackgroundTransparency = .6
v199.Position = UDim2.new(0, 5, 0, 5)
v199.Size = UDim2.new(1, 0, 1, 0)
v199.ZIndex = 0
up25.Name = "imput"
up25.Parent = up24
up25.BackgroundColor3 = Color3.fromRGB(41, 41, 41)
up25.Position = UDim2.new(.1, 0, .13, 0)
up25.Size = UDim2.new(.8, 0, .14, 0)
up25.Font = Enum.Font.Gotham
up25.Text = "Enter Key"
up25.TextColor3 = Color3.fromRGB(131, 131, 128)
up25.TextSize = 20
up25.ClearTextOnFocus = false
up25.TextScaled = true
up25.BorderColor3 = Color3.fromRGB(100, 100, 100)
up25.BorderSizePixel = 2
v184.CornerRadius = UDim.new(0.25, 0)
v184.Parent = up25
v180 = up25.Focused
local v203 = function()
    local v78
    local v77 = up25.Text
    if (v77 == "Enter Key") then
        v78 = up25
        v78.Text = ""
    end
    return
end
v180:Connect(v203)
up25.FocusLost:Connect(function()
    local v85
    local v84 = up25.Text
    if (v84 == "") then
        v85 = up25
        v85.Text = "Enter Key"
    end
    return
end)
v179.Name = "Submit"
v179.Parent = up24
v179.BackgroundColor3 = Color3.fromRGB(114, 137, 218)
v179.Position = UDim2.new(.3, 0, .3, 0)
v179.Size = UDim2.new(.4, 0, .1, 0)
v179.Font = Enum.Font.FredokaOne
v179.Text = "SUBMIT"
v179.TextColor3 = Color3.fromRGB(255, 255, 255)
v179.TextSize = 24
v179.TextWrapped = true
v179.TextStrokeTransparency = 1
v179.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
v179.TextScaled = true
v177.CornerRadius = UDim.new(0.25, 0)
v177.Parent = v179
up26.Name = "TextBoxDisplay"
up26.Parent = up24
up26.BackgroundColor3 = Color3.fromRGB(41, 41, 41)
up26.Position = UDim2.new(.1, 0, .44, 0)
up26.Size = UDim2.new(.8, 0, .12, 0)
up26.Font = Enum.Font.Gotham
up26.Text = "https://subnise.com/link/s50iT"
up26.TextColor3 = Color3.fromRGB(255, 255, 255)
up26.TextSize = 16
up26.ClearTextOnFocus = false
up26.TextEditable = false
up26.TextStrokeTransparency = .7
up26.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
up26.TextScaled = true
v191.CornerRadius = UDim.new(0.25, 0)
v191.Parent = up26
v194.Name = "CopyButton"
v194.Parent = up24
v194.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
v194.Position = UDim2.new(.1, 0, .57, 0)
v194.Size = UDim2.new(.8, 0, .09, 0)
v194.Font = Enum.Font.FredokaOne
v194.Text = "\240\159\148\145 COPY KEY LINK"
v194.TextColor3 = Color3.fromRGB(255, 255, 255)
v194.TextSize = 20
v194.TextStrokeTransparency = 1
v194.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
v194.TextScaled = true
v193.CornerRadius = UDim.new(0.25, 0)
v193.Parent = v194
local v198 = Instance.new("Frame")
v198.Name = "DividerLine"
v198.Parent = up24
v198.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
v198.BorderSizePixel = 0
v198.Position = UDim2.new(.1, 0, .69, 0)
v198.Size = UDim2.new(.8, 0, .005, 0)
up27.Name = "TextBoxDisplay1"
up27.Parent = up24
up27.BackgroundColor3 = Color3.fromRGB(41, 41, 41)
up27.Position = UDim2.new(.1, 0, .73, 0)
up27.Size = UDim2.new(.8, 0, .12, 0)
up27.Font = Enum.Font.Gotham
up27.Text = "https://www.roblox.com/games/109022566180313/Key"
up27.TextColor3 = Color3.fromRGB(255, 255, 255)
up27.TextSize = 16
up27.ClearTextOnFocus = false
up27.TextEditable = false
up27.TextStrokeTransparency = .7
up27.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
up27.TextScaled = true
v182.CornerRadius = UDim.new(0.25, 0)
v182.Parent = up27
v192.Name = "Paid"
v192.Parent = up24
v192.BackgroundColor3 = Color3.fromRGB(0, 170, 127)
v192.Position = UDim2.new(.1, 0, .86, 0)
v192.Size = UDim2.new(.8, 0, .09, 0)
v192.Font = Enum.Font.FredokaOne
v192.Text = "\226\136\158 Permanent Key \226\128\147 Join game. Buy the gamepass to auto-whitelist and get your key."
v192.TextColor3 = Color3.fromRGB(255, 255, 255)
v192.TextSize = 20
v192.TextStrokeTransparency = 1
v192.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
v192.TextScaled = true
v195.CornerRadius = UDim.new(0.25, 0)
v195.Parent = v192
v203 = game:GetService("TweenService")
local v205 = Instance.new("ImageButton")
v205.Name = "JoinButton"
v205.Parent = up24
v205.BackgroundColor3 = Color3.fromRGB(140, 158, 255)
v205.Position = UDim2.new(.93, 0, .92, 0)
v205.Size = UDim2.new(.06, 0, .06, 0)
v205.Image = "rbxassetid://10367063073"
v205.ImageColor3 = Color3.fromRGB(255, 255, 255)
v205.ScaleType = Enum.ScaleType.Stretch
v196.CornerRadius = UDim.new(0.5, 0)
v196.Parent = v205
local up28 = function()
    local v86, v87, v89
    v86, v89 = pcall(function()
        local v154 = game
        local v158 = "https://pastebin.com/raw/Dpx21pg5"
        return v154:HttpGet(v158)
    end)
    if v86 then
        return v89
    else
        warn(("Failed to fetch key: " .. (tostring(v89))))
        v87 = nil
        return v87
    end
end
local up29 = {["18668065416"] = "https://pastefy.app/zrpUDblR/raw", ["115110570222234"] = "https://pastefy.app/zrpUDblR/raw", ["895964367038421"] = "https://pastefy.app/zrpUDblR/raw", ["92517437168342"] = "https://pastefy.app/zrpUDblR/raw", ["99999183035180"] = "https://pastefy.app/zrpUDblR/raw", ["90216279544722"] = "https://pastefy.app/zrpUDblR/raw", ["116495829188952"] = "https://pastefy.app/fp1rmJoL/raw", ["70876832253163"] = "https://pastefy.app/fp1rmJoL/raw", ["98018823628597"] = "https://pastefy.app/fp1rmJoL/raw", ["133377094302868"] = "https://pastefy.app/fp1rmJoL/raw", ["70985038475617"] = "https://pastefy.app/Az7YAelz/raw", ["72368345999613"] = "https://pastefy.app/Az7YAelz/raw", ["78984097674489"] = "https://pastefy.app/Az7YAelz/raw", ["85064132338453"] = "https://pastefy.app/Az7YAelz/raw", ["89413197677760"] = "https://pastefy.app/Az7YAelz/raw", ["91797414023830"] = "https://pastefy.app/Az7YAelz/raw", ["103068090859793"] = "https://pastefy.app/Az7YAelz/raw", ["118699858764346"] = "https://pastefy.app/Az7YAelz/raw", ["121743012604303"] = "https://pastefy.app/Az7YAelz/raw", ["130610295798465"] = "https://pastefy.app/Az7YAelz/raw", ["140050746237057"] = "https://pastefy.app/Az7YAelz/raw", ["104715542330896"] = "https://pastefy.app/d56pmOR3/raw", ["72992062125248"] = "https://pastefy.app/HZaeegJn/raw", ["126884695634066"] = "https://pastefy.app/g9zv9fcC/raw", ["72829404259339"] = "https://pastefy.app/FySE539d/raw", ["80100836118427"] = "https://pastefy.app/FySE539d/raw", ["142823291"] = "https://pastefy.app/OpKxMWOI/raw", ["636649648"] = "https://pastefy.app/OpKxMWOI/raw", ["335132309"] = "https://pastefy.app/OpKxMWOI/raw", ["73210641948512"] = "https://pastefy.app/OpKxMWOI/raw", ["122678592501168"] = "https://pastefy.app/6adKOtQl/raw", ["73708914208963"] = "https://pastefy.app/WEZMZ9Go/raw", ["98118902024430"] = "https://pastefy.app/WEZMZ9Go/raw", ["90346996348563"] = "https://pastefy.app/WEZMZ9Go/raw", ["129230994638464"] = "https://pastefy.app/WEZMZ9Go/raw", ["130739873848552"] = "https://pastefy.app/WEZMZ9Go/raw", ["107040934010858"] = "https://pastefy.app/2Qqrc52E/raw", ["7390824960"] = "https://pastefy.app/RBWPm37b/raw", ["13792161200"] = "https://pastefy.app/RBWPm37b/raw", ["14809057609"] = "https://pastefy.app/RBWPm37b/raw", ["14809130334"] = "https://pastefy.app/RBWPm37b/raw", ["15498121487"] = "https://pastefy.app/RBWPm37b/raw", ["98709994793876"] = "https://pastefy.app/RBWPm37b/raw", ["17850641257"] = "https://pastefy.app/6CQiAIb9/raw", ["17850769550"] = "https://pastefy.app/6CQiAIb9/raw", ["127162061109648"] = "https://pastefy.app/6CQiAIb9/raw", ["101949297449238"] = "https://pastefy.app/PR05YDps/raw", ["128762245270197"] = "https://pastefy.app/93yrfIwZ/raw", ["96342491571673"] = "https://pastefy.app/93yrfIwZ/raw", ["109983668079237"] = "https://pastefy.app/93yrfIwZ/raw", ["13796645198"] = "https://pastefy.app/oHiynpGc/raw", ["15762811640"] = "https://pastefy.app/oHiynpGc/raw", ["106584400953198"] = "https://pastefy.app/oHiynpGc/raw", ["72067667184387"] = "https://pastefy.app/ZE0vN9U1/raw", ["76518298655403"] = "https://pastefy.app/ZE0vN9U1/raw", ["78800282519204"] = "https://pastefy.app/ZE0vN9U1/raw", ["17323507436"] = "https://pastefy.app/t2SSJa9H/raw", ["18451517260"] = "https://pastefy.app/t2SSJa9H/raw", ["110778368901300"] = "https://pastefy.app/t2SSJa9H/raw", ["139598620873181"] = "https://pastefy.app/iS4VRUnS/raw", ["99567941238278"] = "https://pastefy.app/80eHRtEW/raw", ["121431824618615"] = "https://pastefy.app/80eHRtEW/raw", ["125009265613167"] = "https://pastefy.app/80eHRtEW/raw", ["126244816328678"] = "https://pastefy.app/ZAB0dlNx/raw", ["17687504411"] = "https://pastefy.app/yQURzjI6/raw", ["81239378558719"] = "https://pastefy.app/7eeTiXAs/raw", ["82807309372429"] = "https://pastefy.app/7eeTiXAs/raw", ["81072337989394"] = "https://pastefy.app/7wbW3vUl/raw", ["98881331868329"] = "https://pastefy.app/7wbW3vUl/raw", ["109533232275124"] = "https://pastefy.app/7wbW3vUl/raw", ["121269997456920"] = "https://pastefy.app/7wbW3vUl/raw", ["14067600077"] = "https://pastefy.app/pVrPM7MA/raw", ["14067606919"] = "https://pastefy.app/pVrPM7MA/raw", ["14069122388"] = "https://pastefy.app/pVrPM7MA/raw", ["14069678431"] = "https://pastefy.app/pVrPM7MA/raw", ["14069866342"] = "https://pastefy.app/pVrPM7MA/raw", ["14069956183"] = "https://pastefy.app/pVrPM7MA/raw", ["14070029709"] = "https://pastefy.app/pVrPM7MA/raw", ["14071822972"] = "https://pastefy.app/pVrPM7MA/raw", ["14282767684"] = "https://pastefy.app/pVrPM7MA/raw", ["14282768170"] = "https://pastefy.app/pVrPM7MA/raw", ["15126191380"] = "https://pastefy.app/pVrPM7MA/raw", ["16722271122"] = "https://pastefy.app/pVrPM7MA/raw", ["16787374647"] = "https://pastefy.app/pVrPM7MA/raw", ["16795663529"] = "https://pastefy.app/pVrPM7MA/raw", ["16845411199"] = "https://pastefy.app/pVrPM7MA/raw", ["16883972004"] = "https://pastefy.app/pVrPM7MA/raw", ["16883976493"] = "https://pastefy.app/pVrPM7MA/raw", ["16895606055"] = "https://pastefy.app/pVrPM7MA/raw", ["17047374266"] = "https://pastefy.app/pVrPM7MA/raw", ["17078737609"] = "https://pastefy.app/pVrPM7MA/raw", ["17128085292"] = "https://pastefy.app/pVrPM7MA/raw", ["17165937667"] = "https://pastefy.app/pVrPM7MA/raw", ["17206327946"] = "https://pastefy.app/pVrPM7MA/raw", ["17497925847"] = "https://pastefy.app/pVrPM7MA/raw", ["17870505248"] = "https://pastefy.app/pVrPM7MA/raw", ["18214402201"] = "https://pastefy.app/pVrPM7MA/raw", ["18301446679"] = "https://pastefy.app/pVrPM7MA/raw", ["118363155549"] = "https://pastefy.app/pVrPM7MA/raw", ["18413381799"] = "https://pastefy.app/pVrPM7MA/raw", ["18567652860"] = "https://pastefy.app/pVrPM7MA/raw", ["18917174184"] = "https://pastefy.app/pVrPM7MA/raw", ["74845003421880"] = "https://pastefy.app/pVrPM7MA/raw", ["74919509524142"] = "https://pastefy.app/pVrPM7MA/raw", ["79007765026427"] = "https://pastefy.app/pVrPM7MA/raw", ["81535625330190"] = "https://pastefy.app/pVrPM7MA/raw", ["85663041002311"] = "https://pastefy.app/pVrPM7MA/raw", ["88570549485653"] = "https://pastefy.app/pVrPM7MA/raw", ["91349401025981"] = "https://pastefy.app/pVrPM7MA/raw", ["97361360710328"] = "https://pastefy.app/pVrPM7MA/raw", ["99658992953850"] = "https://pastefy.app/pVrPM7MA/raw", ["104037350304891"] = "https://pastefy.app/pVrPM7MA/raw", ["106827243474698"] = "https://pastefy.app/pVrPM7MA/raw", ["108123877604820"] = "https://pastefy.app/pVrPM7MA/raw", ["112666253566696"] = "https://pastefy.app/pVrPM7MA/raw", ["115509275831248"] = "https://pastefy.app/pVrPM7MA/raw", ["116052447681870"] = "https://pastefy.app/pVrPM7MA/raw", ["116089004404557"] = "https://pastefy.app/pVrPM7MA/raw", ["117368893549457"] = "https://pastefy.app/pVrPM7MA/raw", ["17516596118"] = "https://pastefy.app/tlcayLsi/raw", ["131008473296170"] = "https://pastefy.app/tlcayLsi/raw", ["100040622766961"] = "https://pastefy.app/tlcayLsi/raw", ["108428559529058"] = "https://pastefy.app/tlcayLsi/raw", ["122181485177067"] = "https://pastefy.app/tlcayLsi/raw", ["104067066727140"] = "https://pastefy.app/GZtY47df/raw", ["83187482771397"] = "https://pastefy.app/sDuzriJ7/raw", ["108533757090220"] = "https://pastefy.app/sDuzriJ7/raw", ["123516946198836"] = "https://pastefy.app/sDuzriJ7/raw", ["86076978383613"] = "https://pastefy.app/yNbgkRFa/raw", ["93825215891304"] = "https://pastefy.app/yNbgkRFa/raw", ["95512431395349"] = "https://pastefy.app/yNbgkRFa/raw", ["103754275310547"] = "https://pastefy.app/yNbgkRFa/raw", ["90462358603255"] = "https://pastefy.app/hZF2JCz0/raw", ["72115712027203"] = "https://pastefy.app/1EJRjR9f/raw", ["82961470083571"] = "https://pastefy.app/1EJRjR9f/raw", ["107573139811370"] = "https://pastefy.app/1EJRjR9f/raw", ["78912788107663"] = "https://pastefy.app/nxrOgYfs/raw", ["90906407195271"] = "https://pastefy.app/nxrOgYfs/raw", ["134933804107672"] = "https://pastefy.app/nxrOgYfs/raw", ["122443384059979"] = "https://pastefy.app/nxrOgYfs/raw", ["127742093697776"] = "https://pastefy.app/mC2kRCQG/raw", ["142823291"] = "https://pastefy.app/qrWvVJgQ/raw", ["335132309"] = "https://pastefy.app/qrWvVJgQ/raw", ["636649648"] = "https://pastefy.app/qrWvVJgQ/raw", ["80469437126309"] = "https://pastefy.app/qrWvVJgQ/raw", ["18474291382"] = "https://pastefy.app/IS7dmj37/raw", ["18474347948"] = "https://pastefy.app/IS7dmj37/raw", ["18474349316"] = "https://pastefy.app/IS7dmj37/raw", ["18474350348"] = "https://pastefy.app/IS7dmj37/raw", ["18517963950"] = "https://pastefy.app/IS7dmj37/raw", ["18517967096"] = "https://pastefy.app/IS7dmj37/raw", ["106392426844067"] = "https://pastefy.app/IS7dmj37/raw", ["119734765127607"] = "https://pastefy.app/IS7dmj37/raw", ["94101948530988"] = "https://pastefy.app/VjWJH9CX/raw", ["10834586502"] = "https://pastefy.app/mrtiou09/raw", ["76558904092080"] = "https://pastefy.app/koTTlViy/raw", ["129009554587176"] = "https://pastefy.app/koTTlViy/raw", ["110483372589393"] = "https://pastefy.app/5KXQAS8P/raw", ["133410800847665"] = "https://pastefy.app/b6e0uxEa/raw", ["106402284955512"] = "https://pastefy.app/b6e0uxEa/raw", ["111316515138195"] = "https://pastefy.app/b6e0uxEa/raw", ["118614517739521"] = "https://pastefy.app/vpids1ga/raw", ["76370889196003"] = "https://pastefy.app/i4lH6A4G/raw", ["113880247399913"] = "https://pastefy.app/i4lH6A4G/raw", ["116991059923076"] = "https://pastefy.app/i4lH6A4G/raw", ["120217704230083"] = "https://pastefy.app/i4lH6A4G/raw", ["121902496311296"] = "https://pastefy.app/i4lH6A4G/raw", ["123911129955120"] = "https://pastefy.app/i4lH6A4G/raw", ["128603321183248"] = "https://pastefy.app/i4lH6A4G/raw", ["135291616956035"] = "https://pastefy.app/i4lH6A4G/raw", ["82084053899394"] = "https://pastefy.app/lvOnu2Yq/raw", ["134784668468620"] = "https://pastefy.app/hplBQlUJ/raw", ["71408935242594"] = "https://pastefy.app/5TVi3sJ4/raw", ["94375128055535"] = "https://pastefy.app/5TVi3sJ4/raw", ["128772531108376"] = "https://pastefy.app/5TVi3sJ4/raw", ["131079272918660"] = "https://pastefy.app/5TVi3sJ4/raw", ["136364146980997"] = "https://pastefy.app/5TVi3sJ4/raw", ["70619325627859"] = "https://pastefy.app/aymKfpqy/raw", ["128451689942376"] = "https://pastefy.app/aymKfpqy/raw", ["136713673573841"] = "https://pastefy.app/aymKfpqy/raw", ["131623223084840"] = "https://pastefy.app/RnletdH7/raw", ["136599248168660"] = "https://pastefy.app/btXmonEj/raw", ["132411164772755"] = "https://pastefy.app/btXmonEj/raw", ["76450789192466"] = "https://pastefy.app/btXmonEj/raw", ["76904201795239"] = "https://pastefy.app/btXmonEj/raw", ["106299794517450"] = "https://pastefy.app/btXmonEj/raw", ["108191272623628"] = "https://pastefy.app/btXmonEj/raw", ["136764190843219"] = "https://pastefy.app/kkY0CNh2/raw", ["133862653684768"] = "https://pastefy.app/kkY0CNh2/raw", ["127794225497302"] = "https://pastefy.app/oA17Chkb/raw", ["17662297954"] = "https://pastefy.app/QYQwSgTI/raw", ["73446113513609"] = "https://pastefy.app/QYQwSgTI/raw", ["116332986653377"] = "https://pastefy.app/QYQwSgTI/raw", ["119916675926168"] = "https://pastefy.app/QYQwSgTI/raw", ["77747658251236"] = "https://pastefy.app/vkq5qF1q/raw", ["101640913672688"] = "https://pastefy.app/um8FKeKZ/raw", ["130594398886540"] = "https://pastefy.app/ayBYPUIp/raw", ["77923379150463"] = "https://pastefy.app/pntwvXAw/raw", ["74747090658891"] = "https://pastefy.app/pntwvXAw/raw", ["14890802310"] = "https://pastefy.app/pntwvXAw/raw", ["90738171169572"] = "https://pastefy.app/zZ7TmjpR/raw", ["123657429151726"] = "https://pastefy.app/1qy0Op8N/raw", ["81310542478972"] = "https://pastefy.app/aFB89vaP/raw", ["82866880824588"] = "https://pastefy.app/aFB89vaP/raw", ["93201274415679"] = "https://pastefy.app/aFB89vaP/raw", ["140541044364039"] = "https://pastefy.app/aFB89vaP/raw", ["82771154557920"] = "https://pastefy.app/0kwVu2qD/raw", ["90148635862803"] = "https://pastefy.app/0kwVu2qD/raw", ["116139828947259"] = "https://pastefy.app/0kwVu2qD/raw", ["77393318863643"] = "https://pastefy.app/gmuyNhni/raw", ["80353351682367"] = "https://pastefy.app/I3EAXW1U/raw", ["126297188712308"] = "https://pastefy.app/I3EAXW1U/raw", ["70845479499574"] = "https://pastefy.app/3bHpqRYX/raw", ["99449877692519"] = "https://pastefy.app/DxRI3q02/raw", ["124473577469410"] = "https://pastefy.app/ZCFogY9N/raw", ["18680867089"] = "https://pastefy.app/vggx9PHt/raw", ["105626692504093"] = "https://pastefy.app/NRZCtusA/raw", ["113745337705295"] = "https://pastefy.app/Dt1ibbwW/raw", ["99046552174353"] = "https://pastefy.app/Y686osNd/raw", ["89469502395769"] = "https://pastefy.app/xetrkVa4/raw", ["17625359962"] = "https://pastefy.app/LhJ460qx/raw", ["18126510175"] = "https://pastefy.app/LhJ460qx/raw", ["71874690745115"] = "https://pastefy.app/LhJ460qx/raw", ["117398147513099"] = "https://pastefy.app/LhJ460qx/raw", ["129604661913557"] = "https://pastefy.app/LhJ460qx/raw", ["133215910299950"] = "https://pastefy.app/LhJ460qx/raw", ["112374853034490"] = "https://pastefy.app/16aveqpa/raw", ["126678335159530"] = "https://pastefy.app/16aveqpa/raw", ["13379208636"] = "https://pastefy.app/16aveqpa/raw", ["13379349730"] = "https://pastefy.app/16aveqpa/raw", ["13904207646"] = "https://pastefy.app/16aveqpa/raw", ["14012874501"] = "https://pastefy.app/16aveqpa/raw", ["14638336319"] = "https://pastefy.app/16aveqpa/raw", ["14916516914"] = "https://pastefy.app/16aveqpa/raw", ["14932214603"] = "https://pastefy.app/16aveqpa/raw", ["15030367419"] = "https://pastefy.app/16aveqpa/raw", ["15220308770"] = "https://pastefy.app/16aveqpa/raw", ["15374465998"] = "https://pastefy.app/16aveqpa/raw", ["15824912319"] = "https://pastefy.app/16aveqpa/raw", ["17688739434"] = "https://pastefy.app/16aveqpa/raw", ["98653711640137"] = "https://pastefy.app/wH6MlG4D/raw", ["76889882866148"] = "https://pastefy.app/wH6MlG4D/raw", ["98927955463992"] = "https://pastefy.app/wH6MlG4D/raw", ["114204398207377"] = "https://pastefy.app/wH6MlG4D/raw", ["119114794144012"] = "https://pastefy.app/W6zLoEAA/raw", ["140409475718339"] = "https://pastefy.app/W6zLoEAA/raw", ["116766451305209"] = "https://pastefy.app/uxzhRPLu/raw", ["82797688803922"] = "https://pastefy.app/oZtZWWH1/raw", ["95082159892680"] = "https://pastefy.app/uCelcqd2/raw", ["97387256206808"] = "https://pastefy.app/DlSpZCH5/raw", ["77085202503540"] = "https://pastefy.app/cyxQ3ndd/raw", ["97598239454123"] = "https://pastefy.app/cyxQ3ndd/raw", ["133438856880402"] = "https://pastefy.app/cyxQ3ndd/raw", ["106061778438309"] = "https://pastefy.app/zyXjCcgl/raw", ["98800969324557"] = "https://pastefy.app/l8D7LJr4/raw", ["84515722934860"] = "https://pastefy.app/eoYM65GG/raw", ["137228775845999"] = "https://pastefy.app/hwvs3yB5/raw", ["89373001680782"] = "https://pastefy.app/hwvs3yB5/raw", ["77649408247578"] = "https://pastefy.app/pOC4r6Ds/raw", ["85776757589518"] = "https://pastefy.app/pOC4r6Ds/raw", ["115445507767090"] = "https://pastefy.app/pOC4r6Ds/raw", ["107535308163741"] = "https://pastefy.app/7fjd8932/raw", ["85725785704440"] = "https://pastefy.app/vNxYT4uL/raw", ["114068177100380"] = "https://pastefy.app/vNxYT4uL/raw", ["121259443358356"] = "https://pastefy.app/vNxYT4uL/raw", ["132929771812494"] = "https://pastefy.app/vNxYT4uL/raw", ["72169370437173"] = "https://pastefy.app/Yboip5Ny/raw"}
local v209 = function()
    local v96, v98, v99, v101
    local v97 = (up28())
    local v95 = up25.Text
    v98, v99, v101 = v97, v95, v95
    if v97 then
        v98 = (v101 == v97)
    end
    v96, v95 = v98, v99
    if not (v98) then
        v99 = v95
        v98 = (v101 == "4F2D8A9B7C1E5D0F9A2C4B6D8") or (v101 == "34E4EAFE36D9D4AAB9C554A6CB9B8")
        v96, v95 = v98, v99
    end
    if v96 then
        v98 = up29[(tostring(game.PlaceId))]
        if v98 then
            v95 = up24
            v95.Visible = false
            loadstring(game:HttpGet(v98))()
            return
        else
            game:GetService("StarterGui"):SetCore("SendNotification", {["Title"] = "Incorrect Game ID", ["Text"] = "This key is not valid for the current game!", ["Duration"] = 5})
            return
        end
    else
        game:GetService("StarterGui"):SetCore("SendNotification", {["Title"] = "Invalid Key", ["Text"] = "Key is wrong \226\128\148 or you must own the required shirt for this key.", ["Duration"] = 5})
        return
    end
end
v179.MouseButton1Down :Connect(v209)
local v206 = v194.MouseButton1Down
v209 = function()
    setclipboard(up26.Text)
    game:GetService("StarterGui"):SetCore("SendNotification", {["Title"] = "Link Copied", ["Text"] = "Link has been copied to clipboard!", ["Duration"] = 5})
    return
end
v206:Connect(v209)
v206 = v192.MouseButton1Down
v209 = function()
    setclipboard(up27.Text)
    game:GetService("StarterGui"):SetCore("SendNotification", {["Title"] = "Link Copied", ["Text"] = "Link has been copied to clipboard!", ["Duration"] = 5})
    return
end
v206:Connect(v209)
v206 = v205.MouseButton1Down
v209 = function()
    setclipboard("https://discord.gg/dtQKPPCyfK")
    game:GetService("StarterGui"):SetCore("SendNotification", {["Title"] = "Discord", ["Text"] = "Copied Discord link to clipboard!", ["Duration"] = 5})
    return
end
v206:Connect(v209)
up24.Position = UDim2.new(0.5, 0, 1.2, 0)
local v208 = up24
local v210 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local v212 = UDim2.new
v206 = v203.Create
local v213 = v212(0.5, 0, 0.5, 0)
v206 = v206(v203, v208, v210, {["Position"] = v213})
v206:Play()
return
