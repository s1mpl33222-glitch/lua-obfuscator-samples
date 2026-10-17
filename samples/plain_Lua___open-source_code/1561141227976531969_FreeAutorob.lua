

-- This file was protected using Vortex Obfuscator [ClydeProtection]

queue_on_teleport('loadstring(game:HttpGet("https://api.getvortex.vip/scripts/FreeAutorob"))()')
script_key = "BEANZZ-XXXX-XXXX-XXXX";
local old = request
hookfunction(request, function(...)
    local args = {...}
    local req = args[1]

    if req and req.Url == "https://api.beanzz.wtf/api/vip/verify" then
        return {
            StatusMessage = "OK",
            Success = true,
            StatusCode = 200,

            Body = {
                ok = true
            },

            Cookies = {},

            Headers = {
                ["x-content-type-options"] = "nosniff",
                ["Content-Type"] = "application/json",
                ["Server"] = "cloudflare",
                ["Date"] = "Tue, 22 Sep 2026 15:16:35 GMT",
                ["Content-Encoding"] = "gzip",
                ["Connection"] = "keep-alive",
                ["Transfer-Encoding"] = "chunked",
                ["vary"] = "rsc, next-router-state-tree, next-router-prefetch, next-router-segment-prefetch",
                ["cf-cache-status"] = "DYNAMIC",
                ["alt-svc"] = 'h3=":443"; ma=86400',
                ["x-frame-options"] = "SAMEORIGIN"
            }
        }
    end
    if req and req.Url == "https://api.beanzz.wtf/AutorobEvents.lua" then
    return {
        StatusMessage = "OK",
        Success = true,
        StatusCode = 200,
        Body = [[
            return {
                    BuyItem      = "caacca82-e406-4820-aff7-90585f0b581a",
                    Detonate     = "1a1cd96d-877f-4110-9f71-972ab87622ed",
                    ItemCode     = "2yV",
                    SellItem     = "4a345613-3c02-4b5a-a1c4-ac75b488202f",
                    EquipItem    = "3bf9112a-1192-43b8-9b36-0cc8c4fa7d74",
                    MoneyCode    = "mae",
                    PlaceBomb    = "1ee5be8b-e77f-4b30-a0aa-29945e9a1458",
                    VehicleLock  = "0169086b-3944-412c-9e93-f2bdb5259be0",
                    Interactable = "2f9e8fea-9f29-4210-bb07-ac30b3933d49",
                    RemoteFolder = "plk",
                }
        ]]
    }
    end
    return old(...)
end)
local oldhttp
oldhttp = hookfunction(game.HttpGetAsync, newcclosure(function(self, ...)
    local args = table.pack(...)
    local Url = args[1]
    if Url == "https://beanzz.wtf/AutorobLib.lua" then
        args[1] = "https://api.getvortex.vip/scripts/BeanzOrion"
    end
    return oldhttp(self, table.unpack(args, 1, args.n))
end))
loadstring(game:HttpGet("https://api.getvortex.vip/scripts/BeanzAR"))()

