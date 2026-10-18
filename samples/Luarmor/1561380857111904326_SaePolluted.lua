for _, detection in filtergc("function", {
    Constants = {"X-16"}
}) do
    for i, lphUpvalue in debug.getupvalues(detection) do
        setmetatable(lphUpvalue, {
            __newindex = function(_, _, value)
                warn(i, "detected for", value)
            end
        })
    end
end
loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/7f4c9b056ecd55df7bd4721a04b217ff.lua"))()
