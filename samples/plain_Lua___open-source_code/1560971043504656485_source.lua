local global_env = getgenv() or shared or _G or {}

local cloneref = (cloneref or clonereference or function(instance) return instance end)

local RunService = cloneref(game:GetService("RunService"))
local LogService = cloneref(game:GetService("LogService"))
local CoreGui = cloneref(game:GetService("CoreGui"))

if not global_env._console_message_counter then
    global_env._console_message_counter = 3000
end

local module = {}

function _internal_get_guid()
    global_env._console_message_counter = global_env._console_message_counter + 1
    return tostring(global_env._console_message_counter) .. tostring(tick())
end

function _internal_get_message_index(UMID)
    local message_index = -1
    
    repeat task.wait(.05)
        for idx, data in LogService:GetLogHistory() do
            if tostring(data.message) ~= tostring(UMID) then continue end
            
            message_index = idx + 1
            break
        end
    until message_index ~= -1

    return message_index
end

function _internal_is_console_open()
    local console_master = CoreGui:FindFirstChild("DevConsoleMaster")
        
    if not console_master then
        return false
    end

    local window = console_master:FindFirstChild("DevConsoleWindow")

    if not window then
        return false
    end

    local dev_console_ui = window:FindFirstChild("DevConsoleUI")

    if not dev_console_ui then
        return false
    end

    return (dev_console_ui:FindFirstChild("MainView") and dev_console_ui.MainView:FindFirstChild("ClientLog"))
end

function module.custom_print(...)
    local message = ""
    local image = ""
    local color = Color3.fromRGB(255, 255, 255)
    local timestamp = os.date("%H:%M:%S")

    if typeof(select(1, ...)) == "table" then
        local data = select(1, ...)

        if typeof(data.message) == "string" then
            message = data.message
        end

        if typeof(data.image) == "string" then
            image = data.image
        end

        if typeof(data.color) == "Color3" then
            color = data.color
        end

    else
        local msg = select(1, ...)
        local img = select(2, ...)
        local clr = select(3, ...)

        if typeof(msg) == "string" then
            message = msg
        end

        if typeof(img) == "string" then
            image = img
        end
        
        if typeof(clr) == "Color3" then
            color = clr
        end
    end
    
    local UMID = _internal_get_guid()
    print(UMID)
    
    local message_index = _internal_get_message_index(UMID)
    
    local ConsoleUI
    local conn
    conn = RunService.RenderStepped:Connect(function()
        if _internal_is_console_open() then
            if not ConsoleUI or not ConsoleUI.Parent or not ConsoleUI:IsDescendantOf(CoreGui) then
                ConsoleUI = CoreGui.DevConsoleMaster.DevConsoleWindow.DevConsoleUI
            end
            
            local log = ConsoleUI.MainView.ClientLog:FindFirstChild(tostring(message_index))
            
            if not log then
                return
            end

            local msg = log:FindFirstChild("msg")
            local img = log:FindFirstChild("image")

            if not msg or not img then
                return
            end

            msg.Text = timestamp .. " -- " .. message
            msg.TextColor3 = color
            msg.TextWrapped = true

            img.Image = image
            img.ImageColor3 = color
        end
    end)

    local log_module = {}

    function log_module.update_message(...)
        local update_timestamp = true
        if typeof(select(1, ...)) == "table" then
            local data = select(1, ...)

            if typeof(data.message) == "string" then
                message = data.message
            end

            if typeof(data.image) == "string" then
                image = data.image
            end

            if typeof(data.color) == "Color3" then
                color = data.color
            end

            if typeof(data.update_timestamp) == "boolean" then
                update_timestamp = data.update_timestamp
            end
        else
            local msg = select(1, ...)
            local img = select(2, ...)
            local clr = select(3, ...)
            local update = select(4, ...)

            if typeof(msg) == "string" then
                message = msg
            end

            if typeof(img) == "string" then
                image = img
            end
            
            if typeof(clr) == "Color3" then
                color = clr
            end

            if typeof(update) == "boolean" then
                update_timestamp = update
            end
        end

        if update_timestamp then
            timestamp = os.date("%H:%M:%S")
        end
    end

    function log_module.cleanup()
        conn:Disconnect()
    end

    return log_module
end

local script_name = global_env.script_name or "Script"
local bar_length = 20
local start_time = os.clock()

local messages = {}
local message_ranges = {}

for i = 1, 100 do
    local msg_key = "message_" .. i
    local range_key = "message_" .. i .. "_range"
    
    if global_env[msg_key] then
        messages[i] = global_env[msg_key]
        
        if global_env[range_key] then
            local range = global_env[range_key]
            if typeof(range) == "table" and #range == 2 then
                message_ranges[i] = {range[1], range[2]}
            end
        end
    end
end

if #messages == 0 then
    messages = {
        "Loading client...",
        "Connecting to server..",
        "Finalizing.."
    }
    message_ranges = {
        {14, 32},
        {32, 41},
        {41, 100}
    }
end

for i = #messages, 1, -1 do
    if not message_ranges[i] then
        if i == 1 then
            message_ranges[i] = {0, message_ranges[i + 1] and message_ranges[i + 1][1] or 33}
        elseif i == #messages then
            message_ranges[i] = {message_ranges[i - 1] and message_ranges[i - 1][2] or 41, 100}
        else
            local prev_end = message_ranges[i - 1] and message_ranges[i - 1][2] or 0
            local next_start = message_ranges[i + 1] and message_ranges[i + 1][1] or 100
            message_ranges[i] = {prev_end, next_start}
        end
    end
end

local done_image = global_env.done_image or "84271476582826"
if typeof(done_image) == "number" then
    done_image = "rbxassetid://" .. done_image
end

local console_msg = module.custom_print(
    string.format("[%s]: [%s] (0%%) - %s", script_name, string.rep(" ", bar_length), messages[1]),
    "",
    Color3.fromRGB(255, 255, 255)
)

local current_progress = 0
local current_message = messages[1]

task.spawn(function()
    while current_progress < 100 do
        local increment = math.random(1, 5)
        current_progress = math.min(current_progress + increment, 100)
        
        for i, msg in messages do
            local range = message_ranges[i]
            if current_progress >= range[1] and current_progress < range[2] then
                current_message = msg
                break
            end
        end
        
        local filled = math.floor((current_progress / 100) * bar_length)
        local bar = string.rep("#", filled) .. string.rep(" ", bar_length - filled)
        
        console_msg.update_message(
            string.format("[%s]: [%s] (%d%%) - %s", script_name, bar, current_progress, current_message),
            "",
            Color3.fromRGB(255, 255, 255),
            false
        )
        
        local delay = math.random(5, 30) / 100
        if math.random(1, 100) <= 20 then
            delay = math.random(30, 80) / 100
        end
        
        task.wait(delay)
        
        if current_progress >= 69 then
            break
        end
    end
    
    task.wait(0.2)
    
    local elapsed = os.clock() - start_time
    
    console_msg.update_message(
        string.format("[%s]: [   SUCCESS   ] - Authenticated in %.10f", script_name, elapsed),
        done_image,
        Color3.fromRGB(51, 255, 85),
        false
    )
end)
return module
