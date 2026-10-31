local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "AntiPlex",
    LoadingTitle = "AntiPlex",
    LoadingSubtitle = "Made by Phoarynz",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "AntiPlexConfig",
        FileName = "AntiPlexSettings"
    },
    KeySystem = false
})

local MainTab = Window:CreateTab("Main", 4483362458)

local track_system
local old_track_system_new
local AutoHitEnabled = false

local function find_track_system()
    for _, module in next, getloadedmodules() do
        local success, module_value = pcall(require, module)
        if success and type(module_value) == "table" then
            local new_function = rawget(module_value, "new")
            if new_function then
                local ok, first_upvalue = pcall(function()
                    return debug.getupvalue(new_function, 1)
                end)
                if ok and type(first_upvalue) == "table" and rawget(first_upvalue, "twister") then
                    return module_value
                end
            end
        end
    end
    return nil
end

track_system = find_track_system()

if not track_system then
    warn("Could not find track_system module! Auto Hit toggle will not work.")
end

local function hook_auto_hit()
    if not track_system then return end

    old_track_system_new = track_system.new

    track_system.new = function(...)
        local track_functions = old_track_system_new(...)
        local player = game:GetService("Players").LocalPlayer

        local function get_track_action_functions(track_sys)
            local press_track, release_track
            for _, track_function in next, track_sys do
                if type(track_function) == "function" then
                    local constants = debug.getconstants(track_function)
                    if table.find(constants, "press") then
                        press_track = track_function
                        if release_track then break end
                    elseif table.find(constants, "release") then
                        release_track = track_function
                        if press_track then break end
                    end
                end
            end
            return press_track, release_track
        end

        local function get_local_track_system(session)
            local getupvalue = debug.getupvalue
            local local_slot_index = getupvalue(session.set_local_game_slot, 1)
            for _, session_function in next, session do
                if type(session_function) == "function" then
                    local object = getupvalue(session_function, 1)
                    if type(object) == "table" and rawget(object, "count") and object:count() <= 4 then
                        return object:get(local_slot_index)
                    end
                end
            end
        end

        for index, track_function in next, track_functions do
            local upvalues = debug.getupvalues(track_function)
            if type(upvalues[1]) == "table" and rawget(upvalues[1], "profilebegin") then
                local notes_table = upvalues[2]

                track_functions[index] = function(self, slot, session)
                    if not AutoHitEnabled then
                        return track_function(self, slot, session)
                    end

                    local local_track_system = get_local_track_system(session)
                    local press_track, release_track = get_track_action_functions(local_track_system)

                    local test_press_name = debug.getconstant(press_track, 10)
                    local test_release_name = debug.getconstant(release_track, 6)

                    for note_index = 1, notes_table:count() do
                        local note = notes_table:get(note_index)

                        if note then
                            local test_press, test_release = note[test_press_name], note[test_release_name]

                            local note_track_index = note:get_track_index(note_index)
                            local pressed, press_result, press_delay = test_press(note)

                            local note_time_target = 0 -- default timing threshold (adjust if needed)

                            if pressed and press_delay >= note_time_target then
                                press_track(local_track_system, session, note_track_index)

                                session:debug_any_press()

                                if rawget(note, "get_time_to_end") then
                                    delay(math.random(5, 18) / 100, function()
                                        release_track(local_track_system, session, note_track_index)
                                    end)
                                end
                            end

                            if test_release then
                                local released, release_result, release_delay = test_release(note)

                                if released and release_delay >= note_time_target then
                                    delay(math.random(2, 5) / 100, function()
                                        release_track(local_track_system, session, note_track_index)
                                    end)
                                end
                            end
                        end
                    end

                    return track_function(self, slot, session)
                end
            end
        end

        return track_functions
    end

    print("Auto Hit Hooked")
end

if track_system then
    hook_auto_hit()
end

MainTab:CreateToggle({
    Name = "Auto Hit",
    CurrentValue = false,
    Flag = "AutoHitToggle",
    Callback = function(state)
        if not track_system then
            warn("track_system not found. Auto Hit toggle cannot work.")
            return
        end
        AutoHitEnabled = state
        if state then
            print("Auto Hit Enabled")
        else
            print("Auto Hit Disabled")
        end
    end
})

Rayfield:LoadConfiguration()