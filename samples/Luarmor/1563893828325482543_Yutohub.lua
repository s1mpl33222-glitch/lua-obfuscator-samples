repeat wait() until game:IsLoaded()
-------------------------------------------------------
-- if not getgenv().Premium then
--     local function safeRequestInvite()
--         local success, err = pcall(function()
--             local http = request or http_request or (syn and syn.request)
--             if not http then
--                 warn("There No Access !")
--                 return
--             end

--             local body = game:GetService("HttpService"):JSONEncode({
--                 cmd = "INVITE_BROWSER",
--                 args = {code = "mC8Jdtqa7u"}, 
--                 nonce = game:GetService("HttpService"):GenerateGUID(false)
--             })

--             http({
--                 Url = "http://127.0.0.1:6463/rpc?v=1",
--                 Method = "POST",
--                 Headers = {
--                     ["Content-Type"] = "application/json",
--                     ["Origin"] = "https://discord.com"
--                 },
--                 Body = body
--             })

--             warn("[✅] Already Send Discord Invitation")
--         end)

--         if not success then
--             warn("[❌] Join Discord Faile : ", err)
--         end
--     end

--     local filename = "TimeChecking_Yutohub.txt"
--     local currentTick = tick()

--     if not isfile(filename) then
--         safeRequestInvite()
--         writefile(filename, tostring(currentTick))
--     end
-- end
-------------------------------------------------------


local Games = {
    -- ["afss"] = {6299805723,15278073804},
    ["Memesea"] = {10260193230},
    ["AA"] = {10611639},
    ["https://api.luarmor.net/files/v3/loaders/24f452a9bd205bc8c83ecad415874ce2.lua"] = {106198175232796,15009415,16819392,35812225,34644452,5292947,9213039,35821155,36029495,361078446,35757133,35119227,614697100,168519468,34783288,606480807,170628907},
    ["hecker)"] = {12229756,34873522},
}
if getgenv().Premium and script_key then
    Games = {
        ["https://api.luarmor.net/files/v3/loaders/24926e795a0abeb4f7656c3399be63c7.lua"] = {9213039},
        ["https://api.luarmor.net/files/v3/loaders/489c67c75e4afd9904bb0750f038f784.lua"] = {34783288},
        ["https://api.luarmor.net/files/v3/loaders/9f03489977cf44e926eb4bd4e2201c34.lua"] = {614697100,35812225,15009415,34644452,16819392,5292947,36029495,34873522,12229756,35757133,35119227,10611639,170628907,361078446},
        ["https://api.luarmor.net/files/v3/loaders/28ca3daf8632a9caf42555567d5e7123.lua"] = {102072869879193},
        ["https://api.luarmor.net/files/v3/loaders/ba82946fa150620fdb2bd38050edf572.lua"] = {606480807},
        ["https://api.luarmor.net/files/v3/loaders/cfbcf9ddaea290f75263ed38a1093da6.lua"] = {106198175232796},
    }
end
if getgenv().ExecuteYuto ~= nil then
    return
end
for i,v in pairs(Games) do
    for _,k in pairs(v) do
        if   k == game.PlaceId or k == game.CreatorId then
                getgenv().ExecuteYuto = true
                if string.find(i,"luarmor") then
                    pcall(function ()
                        repeat task.wait() 
                            if getgenv().Config == nil and getgenv().YutoHub == nil then
                                spawn(function()loadstring(game:HttpGet((i)))()end)
                            end
                            task.wait(20)
                        until getgenv().Config ~= nil or getgenv().YutoHub ~= nil
                    end)
                else
                    pcall(function ()
                        loadstring(game:HttpGet(("https://raw.githubusercontent.com/Binintrozza/yutv2e/main/"..tostring(i))))()	
                    end)
                end
            break
        end
    end
end
