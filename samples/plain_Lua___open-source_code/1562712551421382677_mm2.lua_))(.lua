local ACTIVE_KEY = (getgenv and getgenv().ACTIVE_KEY) or ""

if ACTIVE_KEY == "" then
    warn("Thiếu key! Hãy đặt getgenv().ACTIVE_KEY = \"your key\" trước khi chạy loader.")
    return
end

local res = http_request({
    Url = "https://api.luaw.dev/files/v2/loaders/99d1494b9d9489e4b51416b3b1675baf.lua",
    Method = "GET"
})

loadstring(res.Body)()
