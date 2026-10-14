--KKT Rivals Hub - v1.21
local UIS = game:GetService("UserInputService")

local function getExecutor()
    local f = identifyexecutor or getexecutorname
    if type(f) == "function" then
        local ok, name = pcall(f)
        if ok and type(name) == "string" and name ~= "" then
            return name:lower()
        end
    end

    if type(identifyexecutor) == "function" then
        local ok, name = pcall(identifyexecutor)
        if ok and type(name) == "string" and name ~= "" then
            return name:lower()
        end
    end

    return ""
end

local exec = getExecutor()

local mobileExecs = {
    "delta",
    "arceus",
    "hydrogen",
    "codex",
    "fluxus android",
    "trigon android"
}

local pcExecs = {
    "real",
    "wave",
    "solara",
    "velocity",
    "synapse",
    "krnl",
    "xeno",
    "swift",
    "electron"
}

local function matches(list, name)
    for _, v in ipairs(list) do
        if name:find(v, 1, true) then
            return true
        end
    end
    return false
end

local mobile

if matches(mobileExecs, exec) then
    mobile = true
elseif matches(pcExecs, exec) then
    mobile = false
else
    mobile = UIS.TouchEnabled
        and UIS.PreferredInput == Enum.PreferredInput.Touch
        and not UIS.KeyboardEnabled
        and not UIS.MouseEnabled
end

local url = mobile
    and "https://raw.githubusercontent.com/KKT-Dev/KKT-Script-Files/refs/heads/main/files/KKT%20Rivals%20Hub%20(Mobile)"
    or "https://raw.githubusercontent.com/KKT-Dev/KKT-Script-Files/refs/heads/main/files/KKT%20Rivals%20Hub%20(PC)"

loadstring(game:HttpGet(url))()
