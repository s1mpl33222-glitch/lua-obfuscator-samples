-- SERENITY HUB // CANONICAL PUBLIC LOADER
-- Keep this root file tiny and stable. It always pulls the newest router
-- with cache-busting so existing public loadstrings never need to change.

if not game:IsLoaded() then
    game.Loaded:Wait()
end

local BASE="https://raw.githubusercontent.com/MUshihara/Serenity-hub/main/"
local isStealASeed=game.PlaceId==122216176958450 or game.GameId==10764328008
local isLiftACube=game.PlaceId==109530157755211 or game.GameId==10759860151
local isStealAnAnimeEgg=game.PlaceId==76377501906469 or game.GameId==10747748563
local isBreakAndStealAnEgg=game.PlaceId==114326934417838 or game.GameId==10765288803
local isRideAPet=game.PlaceId==124216119978534 or game.GameId==10035204815
local isStrengthGrowArm=game.PlaceId==86259628805375 or game.GameId==10310999762
local isAnimeDice=game.PlaceId==113290951185459 or game.GameId==10708913337
local isLootToForge=game.PlaceId==118805555015549 or game.GameId==10684750879
local isLiftRockForEggs=game.PlaceId==76731343328034 or game.GameId==10768316438

if isStealASeed or isLiftACube or isStealAnAnimeEgg or isBreakAndStealAnEgg or isRideAPet or isStrengthGrowArm or isAnimeDice or isLootToForge or isLiftRockForEggs then
    local env=(type(getgenv)=="function" and getgenv()) or _G
    env.__SERENITY_PAYLOAD_AUTHORIZED=true
    _G.__SERENITY_PAYLOAD_AUTHORIZED=true
end

local target
local chunkName

if isStealASeed then
    target="dist/runtime/games/stealaseed.lua"
    chunkName="@SerenityHub/Game-StealASeed"
elseif isLiftACube then
    target="dist/runtime/games/liftacube.lua"
    chunkName="@SerenityHub/Game-LiftACube"
elseif isStealAnAnimeEgg then
    target="dist/runtime/games/StealAnAnimeEgg.lua"
    chunkName="@SerenityHub/Game-StealAnAnimeEgg"
elseif isBreakAndStealAnEgg then
    target="dist/runtime/games/breakandstealegg.lua"
    chunkName="@SerenityHub/Game-BreakAndStealAnEgg"
elseif isRideAPet then
    target="dist/runtime/games/rideapet.lua"
    chunkName="@SerenityHub/Game-RideAPet"
elseif isStrengthGrowArm then
    target="dist/runtime/games/+1strengthgrowarm.lua"
    chunkName="@SerenityHub/Game-StrengthGrowArm"
elseif isAnimeDice then
    target="dist/runtime/games/animedice.lua"
    chunkName="@SerenityHub/Game-AnimeDice"
elseif isLootToForge then
    target="dist/runtime/games/loottoforge.lua"
    chunkName="@SerenityHub/Game-LootToForge"
elseif isLiftRockForEggs then
    target="dist/runtime/games/LiftRockForEggs.lua"
    chunkName="@SerenityHub/Game-LiftRockForEggs"
else
    target="dist/loader.lua"
    chunkName="@SerenityHub/CurrentLoader"
end

local url=BASE..target.."?cb="..tostring(os.time())..tostring(math.random(100000,999999))

local ok,source=pcall(function()
    return game:HttpGet(url,true)
end)

if not ok or type(source)~="string" or source=="" then
    error("[SERENITY HUB] Current loader is unavailable. Try again in a moment.",0)
end

local fn,err=loadstring(source,chunkName)
source=nil

if not fn then
    error("[SERENITY HUB] Loader compile failed: "..tostring(err),0)
end

-- Run the selected Serenity payload first.
local results=table.pack(fn())

-- ============================================================
-- SHARED ANTI-AFK
--
-- Ride A Pet compatibility rule:
--   NEVER acquire VirtualUser in Ride A Pet.
-- Live isolation proved that merely acquiring VirtualUser can cause
-- stolen eggs to be returned.
--
-- Ride A Pet:
--   shared anti-AFK disabled; previous workers are stopped.
--
-- Other games:
--   legacy VirtualUser Idled handler.
--
-- Re-execution:
--   one runtime owner; old worker/connection is stopped first.
-- ============================================================
pcall(function()
    local env=(type(getgenv)=="function" and getgenv()) or _G

    -- Stop the new shared runtime from a previous execution.
    local oldRuntime=env.__SERENITY_IDLE_RUNTIME
    if type(oldRuntime)=="table" then
        oldRuntime.Alive=false

        if oldRuntime.Connection then
            pcall(function()
                oldRuntime.Connection:Disconnect()
            end)
        end
    end

    -- Backward compatibility: disconnect the old loader's legacy connection.
    local oldLegacy=env.__SERENITY_IDLE_CONNECTION
    if oldLegacy then
        pcall(function()
            oldLegacy:Disconnect()
        end)
    end
    env.__SERENITY_IDLE_CONNECTION=nil

    local runtime={
        Alive=true,
        Connection=nil,
        Mode=nil,
    }
    env.__SERENITY_IDLE_RUNTIME=runtime

    local player=game:GetService("Players").LocalPlayer
    if not player then
        runtime.Alive=false
        return
    end

    if isRideAPet then
        -- Shared anti-AFK is disabled for Ride A Pet.
        -- Stop any previous worker above; do not acquire VirtualUser.
        runtime.Alive=false
        runtime.Mode="disabled"
        return
    end

    -- Existing universal behavior for games that have not shown a conflict.
    local virtualUser=game:GetService("VirtualUser")
    runtime.Mode="VirtualUser"

    runtime.Connection=
        player.Idled:Connect(function()
            if not runtime.Alive
                or env.__SERENITY_IDLE_RUNTIME~=runtime then
                return
            end

            pcall(function()
                virtualUser:CaptureController()
                virtualUser:ClickButton2(Vector2.new(0,0))
            end)
        end)

    -- Keep legacy key populated for compatibility with anything that inspects it.
    env.__SERENITY_IDLE_CONNECTION=runtime.Connection
end)

-- Copy the community invite at most once every 24 hours.
-- This shares the same timestamp marker as the V3 UI, so one execution cannot copy twice.
pcall(function()
    local invite="https://discord.gg/pWPs7428wE"
    local env=(type(getgenv)=="function" and getgenv()) or _G
    local now=os.time()
    local cooldown=24*60*60
    local marker="SerenityHub/discord-notice-at.txt"
    local last=tonumber(env.__SERENITY_DISCORD_NOTICE_AT) or 0

    if type(readfile)=="function" then
        local ok,value=pcall(readfile,marker)
        if ok then
            last=math.max(last,tonumber(value) or 0)
        end
    end

    if last>now then last=now end
    if now-last<cooldown then return end

    local copy=type(setclipboard)=="function" and setclipboard
        or type(toclipboard)=="function" and toclipboard
        or (type(syn)=="table" and type(syn.write_clipboard)=="function" and syn.write_clipboard)

    if not copy then return end

    local ok,result=pcall(copy,invite)
    if not ok or result==false then return end

    env.__SERENITY_DISCORD_COPIED=true
    env.__SERENITY_DISCORD_NOTICE_AT=now

    if type(writefile)=="function" then
        if type(makefolder)=="function" then pcall(makefolder,"SerenityHub") end
        pcall(writefile,marker,tostring(now))
    end
end)

return table.unpack(results,1,results.n)
