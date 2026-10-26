if not pcall(function()
    return loadstring(request({
        Url = "https://" .. "us-1" .. ".luaprot.net/api/v3/scripts/" .. "75831525325751328296" .. "?k=" .. (lp_key or "x")
    }).Body)()
end) then
    game:GetService("Players").LocalPlayer:Kick("LuaProt v3 loadstring failed.")
end