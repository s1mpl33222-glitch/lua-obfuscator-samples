-- MXZY HUB local key gate
repeat task.wait() until game:IsLoaded()
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()
local VALID_KEYS = { ["MXZY-HUB-FREE"] = true }
local KEY_FILE = "MXZY_key.txt"
local KEY_LINKS = {
    "https://sub2boost.site/unlock/get-key",
}
local SCRIPTS = {
    [132929771812494] = "https://vampauth.com/api/projects/12bbe2bf-ad89-47dc-8c61-233016ed8ff6/scripts/cmtdk",
    [114068177100380] = "https://vampauth.com/api/projects/12bbe2bf-ad89-47dc-8c61-233016ed8ff6/scripts/cmtdk",
    [99703116573266] = "https://vampauth.com/api/projects/12bbe2bf-ad89-47dc-8c61-233016ed8ff6/scripts/atdk",
    [117654154793149] = "https://vampauth.com/api/projects/12bbe2bf-ad89-47dc-8c61-233016ed8ff6/scripts/atdk",
}
local function fileApi() return type(isfile)=="function" and type(readfile)=="function" and type(writefile)=="function" end
local function readKey()
    if not fileApi() then return nil end
    local ok,v=pcall(function() if isfile(KEY_FILE) then return readfile(KEY_FILE) end end)
    return ok and type(v)=="string" and v:gsub("^%s*(.-)%s*$","%1") or nil
end
local function clearKey() if type(delfile)=="function" then pcall(delfile,KEY_FILE) end end
local function normalizeKey(k)
    if type(k) ~= "string" then return "" end
    return k:gsub("%s+", ""):upper()
end
local function valid(k) return VALID_KEYS[normalizeKey(k)] == true end
local function inputText(value)
    if type(value) == "table" then
        value = value.Text or value.Value or value.text or value.value
    end
    return type(value) == "string" and value or tostring(value or "")
end
local function runPayload()
    local url=SCRIPTS[game.PlaceId]
    if not url then return false,"Unsupported game: "..tostring(game.PlaceId) end
    local ok,src=pcall(function() return game:HttpGet(url) end)
    if not ok then return false,src end
    local chunk,err=loadstring(src)
    if not chunk then return false,err end
    return pcall(chunk)
end
local cached=readKey()
if valid(cached) then
    local ok,err=runPayload()
    if ok then return end
    warn("[MXZY] Load failed: "..tostring(err))
elseif cached then clearKey() end
local Window=WindUI:CreateWindow({Title="MXZY HUB",Icon="key-round",Author="Key System",Folder="CamTDKey",Size=UDim2.fromOffset(520,340),MinSize=Vector2.new(320,280),Theme="Dark",Transparent=true,ToggleKey=Enum.KeyCode.RightShift})
local Tab=Window:Tab({Title="Key System",Icon="shield-check"})
Tab:Select()
local entered=""
Tab:Input({Title="Enter Key",Desc="Enter your access key",Placeholder="MXZY-HUB-FREE",InputIcon="key",Type="Input",Callback=function(v) entered=inputText(v) end})
local checking = false
Tab:Button({Title="Verify Key",Icon="check",Callback=function()
    local callbackOk, callbackError = xpcall(function()
    if checking then
        WindUI:Notify({Title="Please Wait",Content="A check is already running.",Duration=3})
        return
    end
    checking = true
    local key = normalizeKey(inputText(entered))
    if key == "" then
        checking = false
        WindUI:Notify({Title="Key Required",Content="Enter a key first.",Duration=4})
        return
    end
    if not valid(key) then
        clearKey()
        checking = false
        WindUI:Notify({Title="Invalid Key",Content="Check the key and try again.",Duration=4})
        return
    end

    WindUI:Notify({Title="Key Valid",Content="Loading script...",Duration=3})
    task.spawn(function()
        local callOk, runOk, payloadError = xpcall(runPayload, debug.traceback)
        if callOk and runOk then
            if fileApi() then pcall(writefile,KEY_FILE,key) end
            pcall(function() Window:Destroy() end)
        else
            clearKey()
            local message = tostring(payloadError or runOk)
            if message:find("Unsupported game",1,true) then
                WindUI:Notify({Title="Unsupported Game",Content=message,Duration=6})
            elseif message:lower():find("http",1,true) or message:lower():find("connect",1,true) then
                WindUI:Notify({Title="Connection Failed",Content="Could not fetch the script. Check your connection and retry.",Duration=6})
            else
                WindUI:Notify({Title="Script Error",Content=message,Duration=6})
            end
        end
        checking = false
    end)
    end, debug.traceback)
    if not callbackOk then
        checking = false
        warn("[MXZY] Key verification error: " .. tostring(callbackError))
        pcall(function() WindUI:Notify({Title="Key System Error",Content="Verification failed: " .. tostring(callbackError),Duration=6}) end)
    end
end})
Tab:Button({Title="Get Key",Icon="external-link",Callback=function()
    local link=KEY_LINKS[math.random(1,#KEY_LINKS)]
    local ok = type(setclipboard)=="function" and pcall(setclipboard,link)
    if ok then
        WindUI:Notify({Title="Link Copied",Content="Open the copied link to get a key.",Duration=4})
    else
        WindUI:Notify({Title="Get Key",Content=link,Duration=8})
    end
end})
Tab:Paragraph({Title="Status",Desc="Valid keys are saved after the script loads."})

