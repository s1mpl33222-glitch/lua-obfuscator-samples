if already_loaded then
    return
end

getgenv()['already_loaded'] = true

script_key = tostring(goodnight['Script Key'][1])

if not script_key or script_key == '' or script_key:find('YOUR_KEY_HERE') then
    game['Players']['LocalPlayer']:Kick("You forgot to put the key inside of ['Script Key'] = {}")
    return
end

loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/951bab16ab308a3e64626aa0a29b0609.lua"))()
