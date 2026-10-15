local FOV_Size = 100
local HEAD_CHANCE = 60
local MISS_CHANCE = 35
local MISS_OFFSET = 2.5
local TOGGLE_KEY = Enum.KeyCode.E

local TEAM_GUARDS = "Guards"
local TEAM_INMATES = "Inmates"
local TEAM_CRIMINALS = "Criminals"

local COLOR_GUARDS = Color3.fromRGB(0, 150, 255)
local COLOR_INMATES = Color3.fromRGB(150, 75, 0)
local COLOR_CRIMINALS = Color3.fromRGB(255, 0, 0)

local current_target_team = TEAM_GUARDS
local head_locked = false

local R6_BODY_PARTS = {
    ["Head"] = "Head",
    ["Torso"] = "Torso",
    ["LeftArm"] = "Left Arm",
    ["RightArm"] = "Right Arm",
    ["LeftLeg"] = "Left Leg",
    ["RightLeg"] = "Right Leg"
}

local players = game:GetService("Players")
local run_service = game:GetService("RunService")
local user_input_service = game:GetService("UserInputService")

local local_player = players.LocalPlayer

local fov_circle = Drawing.new("Circle")
fov_circle.Position = user_input_service:GetMouseLocation()
fov_circle.Visible = true
fov_circle.Color = COLOR_GUARDS
fov_circle.Radius = FOV_Size
fov_circle.Transparency = 1
fov_circle.Filled = false
fov_circle.NumSides = 64

local function update_highlights()
    for _, player in players:GetPlayers() do
        if player == local_player then
            continue
        end

        local character = player.Character
        if not character then
            continue
        end

        local highlight = character:FindFirstChild("ESPHighlight")
        local player_team = player.Team and player.Team.Name

        if player_team == current_target_team then
            if not highlight then
                highlight = Instance.new("Highlight")
                highlight.Name = "ESPHighlight"
                highlight.FillTransparency = 1
                highlight.OutlineTransparency = 0
                highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                highlight.Parent = character
            end

            if player_team == TEAM_GUARDS then
                highlight.OutlineColor = COLOR_GUARDS
            elseif player_team == TEAM_INMATES then
                highlight.OutlineColor = COLOR_INMATES
            elseif player_team == TEAM_CRIMINALS then
                highlight.OutlineColor = COLOR_CRIMINALS
            end
        else
            if highlight then
                highlight:Destroy()
            end
        end
    end
end

run_service.PreRender:Connect(function()
    fov_circle.Position = user_input_service:GetMouseLocation()
    update_highlights()
end)

user_input_service.InputBegan:Connect(function(input, game_processed)
    if game_processed then return end
    if input.KeyCode == TOGGLE_KEY then
        if current_target_team == TEAM_GUARDS then
            current_target_team = TEAM_INMATES
            fov_circle.Color = COLOR_INMATES
        elseif current_target_team == TEAM_INMATES then
            current_target_team = TEAM_CRIMINALS
            fov_circle.Color = COLOR_CRIMINALS
        else
            current_target_team = TEAM_GUARDS
            fov_circle.Color = COLOR_GUARDS
        end
    end
end)

local function get_random_category()
    local other_categories = {"Torso", "LeftArm", "RightArm", "LeftLeg", "RightLeg"}
    if not head_locked and math.random(1, 100) <= HEAD_CHANCE then
        return "Head"
    else
        return other_categories[math.random(1, #other_categories)]
    end
end

local function get_closest_player(fov)
    fov = fov or math.huge
    local closest_player = nil
    local closest_part = nil
    local closest_position = nil
    local closest_distance = fov
    local selected_category = nil

    local camera = workspace.CurrentCamera
    local raycast_params = RaycastParams.new()
    raycast_params.FilterType = Enum.RaycastFilterType.Exclude

    for _, player in players:GetPlayers() do
        if player == local_player then
            continue
        end
        
        if not player.Team or player.Team.Name ~= current_target_team then
            continue
        end
        
        local character = player.Character
        if not character then
            continue
        end
        
        local category = get_random_category()
        local part_name = R6_BODY_PARTS[category]
        local part = character:FindFirstChild(part_name)

        if not part then
            continue
        end
        
        local screen_position = camera:WorldToViewportPoint(part.Position)
        if screen_position.Z <= 0 then
            continue
        end

        local ignore_list = {camera}
        if local_player.Character then
            table.insert(ignore_list, local_player.Character)
        end
        raycast_params.FilterDescendantsInstances = ignore_list

        local raycast_result = workspace:Raycast(camera.CFrame.Position, part.Position - camera.CFrame.Position, raycast_params)
        if raycast_result and not raycast_result.Instance:IsDescendantOf(character) then
            continue
        end
        
        local screen_center = user_input_service:GetMouseLocation()
        local screen_distance = (Vector2.new(screen_position.X, screen_position.Y) - screen_center).Magnitude
        
        if screen_distance < closest_distance then
            closest_player = player
            closest_part = part
            closest_position = part.Position
            closest_distance = screen_distance
            selected_category = category
        end
    end

    if closest_player and selected_category then
        if selected_category == "Head" then
            head_locked = true
        elseif selected_category == "LeftArm" or selected_category == "RightArm" then
            head_locked = false
        end

        if math.random(1, 100) <= MISS_CHANCE then
            local offset_x = (math.random() - 0.5) * MISS_OFFSET * 2
            local offset_y = (math.random() - 0.5) * MISS_OFFSET * 2
            local offset_z = (math.random() - 0.5) * MISS_OFFSET * 2
            closest_position = closest_position + Vector3.new(offset_x, offset_y, offset_z)
        end
    end

    return closest_player, closest_part, closest_position
end

LPH_NO_UPVALUES = function(Function)
    return function(...)
        return Function(...)
    end
end

local castRay = filtergc("function", {Name = "castRay"}, true)
local old; old = hookfunction(castRay, LPH_NO_UPVALUES(function(...)
    local closest_player, closest_part, closest_position = get_closest_player(FOV_Size)
    if closest_player and closest_part and closest_position then
        return closest_part, closest_position
    end
    return old(...)
end))