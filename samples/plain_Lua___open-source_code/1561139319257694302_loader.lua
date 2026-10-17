local ProjectId = "694a0ac109b5b1b43b4efef1"
local Scripts = {
    [3032132418] = "https://cdn.snc.dev/694a0ac109b5b1b43b4efef1/znagid3hh2g",
    [9908641400] = "https://cdn.snc.dev/694a0ac109b5b1b43b4efef1/mulzz75bph",
    [4931927012] = "https://cdn.snc.dev/694a0ac109b5b1b43b4efef1/kyaq5aemrh",
    [184199275] = "https://cdn.snc.dev/694a0ac109b5b1b43b4efef1/ea1k7vomg3",
    [7128251171] = "https://cdn.snc.dev/694a0ac109b5b1b43b4efef1/a772l64hfme",
    [9893475671] = "https://cdn.snc.dev/694a0ac109b5b1b43b4efef1/e2r7q5u5tob",
}
getgenv().key="FFAENABLED"
getfenv().key = getgenv().key

if game.GameId == 9893475671 then
    if identifyexecutor and identifyexecutor():lower():find("delta") then
        game:GetService('Players').LocalPlayer:Kick("[YUNA] sorry, Delta is not supported for OT7.")
        return
    end
end

if game.GameId == 9908641400 or getfenv().test then
    if identifyexecutor and identifyexecutor():lower():find("real") then
        game:GetService('Players').LocalPlayer:Kick("[YUNA] Everyone is saying Real is broken and bans (ITS ONLY REAL) so don't use it. Use potassium or volt or something..")
        return
    end

    if getconnections then
        for i,v in next, getconnections(game:GetService("ScriptContext").Error) do
            if v.Function then
                v:Disable()
            end
        end
    end

    if hookfunction then
        if true then--not getfenv().test then
            getgenv().CrashFuncFound = 0
    for _, v in getgc() do
        if typeof(v) == "function" and islclosure(v) then

            local info = debug.getinfo(v)

            if not info.source:find("PlayerScriptsLoader") then
                continue
            end

            local Upvalues = getupvalues(v)

            for x, y in Upvalues do
                if y == game:GetService("RunService").Heartbeat then
                    setupvalue(v, x, Instance.new('BindableEvent').Event)
                    getgenv().CrashFuncFound +=1
                    getgenv().ACScript = info.source
                end
                if y == game:GetService("RunService").Heartbeat.Connect then
                    setupvalue(v, x, Instance.new('BindableEvent').Event.Wait)
                    getgenv().CrashFuncFound +=1
                end
            end
        end
    end
        end

        local Old; Old = hookfunction(game:GetService("LogService").GetLogHistory, function(...)
            local Results = Old(...);

            if #Results > 3 then
                for i = 4, #Results do
                    if type(Results[i]) == "table" and Results[i].messageType == Enum.MessageType.MessageError then
                        table.remove(Results, i);
                    end
                end
            end

            return Results
        end)
    end

    if getfenv().test then
	loadstring(game:HttpGet("https://cdn.snc.dev/694a0ac109b5b1b43b4efef1/hsu7mo37ree"))()
	return
    end
end

if game.GameId == 3032132418 then
    for x, y in getconnections(game:GetService("LogService").MessageOut) do
        if y.Function == nil or typeof(getfenv(y.Function).script) == 'table' then
            continue
        end
        y:Disable()
    end
end


local Script = Scripts[game.GameId]
if Script then
    loadstring(game:HttpGet(Script))()
end
