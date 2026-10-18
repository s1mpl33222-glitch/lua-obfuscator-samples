local _PARRY_PATCH = {
    keyTable = nil,
    transformFn = nil,
    netModule = nil,
    remoteId = nil,
    parryHash = nil,
    parryRemote = nil,
    ready = false,
}

do
    local ok_hook = pcall(function()
        local old_dinfo
        old_dinfo = hookfunction(getrenv().debug.info, function(f, t)
            if type(f) == "function" then
                return "[C]"
            elseif f == 4 and t == "s" then
                return "ReplicatedStorage.Controllers.SwordsController "
            end
            return old_dinfo(f, t)
        end)
        local old_gfenv
        old_gfenv = hookfunction(getrenv().getfenv, function(l)
            if l ~= nil and type(l) == "number" then
                if l >= 1 and l <= 10 then return old_gfenv(10) end
            end
            return old_gfenv(l)
        end)
    end)
    if not ok_hook then
        warn("[PARRY PATCH] bypass hooks failed to install")
    end
end

task.spawn(function()
    local ok, err = pcall(function()
        local RS = game:GetService("ReplicatedStorage")
        local Controllers = RS:WaitForChild("Controllers", 15)
        if not Controllers then return end

        local SC
        for _, child in ipairs(Controllers:GetChildren()) do
            if child.Name:sub(1, 16) == "SwordsController" then
                SC = child
                break
            end
        end
        if not SC then
            warn("[PARRY PATCH] SwordsController not found")
            return
        end

        local PRY = SC:WaitForChild("PRY", 15)
        if not PRY then
            warn("[PARRY PATCH] PRY module not found")
            return
        end

        local Parry_Function = require(PRY)
        local getupvals = debug.getupvalues or getupvalues
        if not getupvals then
            warn("[PARRY PATCH] executor missing getupvalues")
            return
        end

        local ups = getupvals(Parry_Function)
        if not ups or #ups < 8 then
            warn("[PARRY PATCH] unexpected upvalue count")
            return
        end

        _PARRY_PATCH.keyTable    = ups[3]
        _PARRY_PATCH.transformFn = ups[4]
        _PARRY_PATCH.netModule   = ups[6]
        _PARRY_PATCH.remoteId    = ups[7]
        _PARRY_PATCH.parryHash   = ups[8]

        local rok = pcall(function()
            _PARRY_PATCH.parryRemote = _PARRY_PATCH.netModule:RemoteEvent(_PARRY_PATCH.remoteId)
        end)
        if not rok or not _PARRY_PATCH.parryRemote then
            warn("[PARRY PATCH] remote resolution failed")
            return
        end

        _PARRY_PATCH.ready = true
    end)
    if not ok then warn("[PARRY PATCH] init error:", tostring(err)) end
end)

function _PARRY_PATCH.fire(curveCFrame, screenPositions, mouseLocation)
    if not _PARRY_PATCH.ready then return false end
    local kt = _PARRY_PATCH.keyTable
    if not kt then return false end
    local keyIndex = kt[3]
    local currentKey = kt[1] and kt[1][keyIndex]
    if not currentKey then return false end

    local tok, transformed = pcall(_PARRY_PATCH.transformFn, currentKey, "TIME")
    if not tok or not transformed then
        tok, transformed = pcall(_PARRY_PATCH.transformFn, currentKey)
        if not tok or not transformed then return false end
    end

    local serverTime = workspace:GetServerTimeNow() * 100
    local timeStr = tostring(math.floor(serverTime))
    local tc = {}
    for i = 1, #timeStr do
        local ki = (i - 1) % #transformed + 1
        local kb = string.byte(transformed, ki)
        local tb = (string.byte(timeStr, i) + i) % 256
        tc[i] = string.char(bit32.bxor(tb, kb))
    end
    local token = table.concat(tc)

    local fok = pcall(function()
        _PARRY_PATCH.parryRemote:FireServer(
            _PARRY_PATCH.parryHash,
            currentKey,
            token,
            0.5,
            curveCFrame,
            screenPositions,
            mouseLocation,
            false
        )
    end)
    return fok
end

getgenv().GG = {
    Language = {
        CheckboxEnabled = "Enabled",
        CheckboxDisabled = "Disabled",
        SliderValue = "Value",
        DropdownSelect = "Select",
        DropdownNone = "None",
        DropdownSelected = "Selected",
        ButtonClick = "Click",
        TextboxEnter = "Enter",
        ModuleEnabled = "Enabled",
        ModuleDisabled = "Disabled",
        TabGeneral = "General",
        TabSettings = "Settings",
        Loading = "Loading...",
        Error = "Error",
        Success = "Success"
    }
}

local SelectedLanguage = GG.Language

function convertStringToTable(inputString)
    local result = {}
    for value in string.gmatch(inputString, "([^,]+)") do
        local trimmedValue = value:match("^%s*(.-)%s*$")
        table.insert(result, trimmedValue)
    end

    return result
end

function convertTableToString(inputTable)
    return table.concat(inputTable, ", ")
end

local UserInputService = cloneref(game:GetService('UserInputService'))
local ContentProvider = cloneref(game:GetService('ContentProvider'))
local TweenService = cloneref(game:GetService('TweenService'))
local HttpService = cloneref(game:GetService('HttpService'))
local TextService = cloneref(game:GetService('TextService'))
local RunService = cloneref(game:GetService('RunService'))
local Lighting = cloneref(game:GetService('Lighting'))
local Players = cloneref(game:GetService('Players'))
local CoreGui = cloneref(game:GetService('CoreGui'))
local Debris = cloneref(game:GetService('Debris'))


local Connections = setmetatable({
    disconnect = function(self, connection)
        if not self[connection] then
            return
        end
    
        self[connection]:Disconnect()
        self[connection] = nil
    end,
    disconnect_all = function(self)
        for _, value in self do
            if typeof(value) == 'function' then
                continue
            end
    
            value:Disconnect()
        end
    end
}, Connections)

local Util = setmetatable({
    map = function(self: any, value: number, in_minimum: number, in_maximum: number, out_minimum: number, out_maximum: number)
        return (value - in_minimum) * (out_maximum - out_minimum) / (in_maximum - in_minimum) + out_minimum
    end,
    viewport_point_to_world = function(self: any, location: any, distance: number)
        local unit_ray = workspace.CurrentCamera:ScreenPointToRay(location.X, location.Y)

        return unit_ray.Origin + unit_ray.Direction * distance
    end,
    get_offset = function(self: any)
        local viewport_size_Y = workspace.CurrentCamera.ViewportSize.Y

        return self:map(viewport_size_Y, 0, 2560, 8, 56)
    end
}, Util)


local AcrylicBlur = {}
AcrylicBlur.__index = AcrylicBlur


function AcrylicBlur.new(object: GuiObject)
    local self = setmetatable({
        _object = object,
        _folder = nil,
        _frame = nil,
        _root = nil
    }, AcrylicBlur)

    self:setup()

    return self
end


function AcrylicBlur:create_folder()
    local old_folder = workspace.CurrentCamera:FindFirstChild('AcrylicBlur')

    if old_folder then
        Debris:AddItem(old_folder, 0)
    end

    local folder = Instance.new('Folder')
    folder.Name = 'AcrylicBlur'
    folder.Parent = workspace.CurrentCamera

    self._folder = folder
end


function AcrylicBlur:create_depth_of_fields()
    local depth_of_fields = Lighting:FindFirstChild('AcrylicBlur') or Instance.new('DepthOfFieldEffect')
    depth_of_fields.FarIntensity = 0
    depth_of_fields.FocusDistance = 0.05
    depth_of_fields.InFocusRadius = 0.1
    depth_of_fields.NearIntensity = 1
    depth_of_fields.Name = 'AcrylicBlur'
    depth_of_fields.Parent = Lighting

    for _, object in Lighting:GetChildren() do
        if not object:IsA('DepthOfFieldEffect') then
            continue
        end

        if object == depth_of_fields then
            continue
        end

        Connections[object] = object:GetPropertyChangedSignal('FarIntensity'):Connect(function()
            object.FarIntensity = 0
        end)

        object.FarIntensity = 0
    end
end


function AcrylicBlur:create_frame()
    local frame = Instance.new('Frame')
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.Position = UDim2.new(0.5, 0, 0.5, 0)
    frame.AnchorPoint = Vector2.new(0.5, 0.5)
    frame.BackgroundTransparency = 1
    frame.Parent = self._object

    self._frame = frame
end


function AcrylicBlur:create_root()
    local part = Instance.new('Part')
    part.Name = 'Root'
    part.Color = Color3.new(0, 0, 0)
    part.Material = Enum.Material.Glass
    part.Size = Vector3.new(1, 1, 0)  
    part.Anchored = true
    part.CanCollide = false
    part.CanQuery = false
    part.Locked = true
    part.CastShadow = false
    part.Transparency = 0.98
    part.Parent = self._folder

    
    local specialMesh = Instance.new('SpecialMesh')
    specialMesh.MeshType = Enum.MeshType.Brick  
    specialMesh.Offset = Vector3.new(0, 0, -0.000001)  
    specialMesh.Parent = part

    self._root = part  
end


function AcrylicBlur:setup()
    self:create_depth_of_fields()
    self:create_folder()
    self:create_root()
    
    self:create_frame()
    self:render(0.001)

    self:check_quality_level()
end


function AcrylicBlur:render(distance: number)
    local positions = {
        top_left = Vector2.new(),
        top_right = Vector2.new(),
        bottom_right = Vector2.new(),
    }

    local function update_positions(size: any, position: any)
        positions.top_left = position
        positions.top_right = position + Vector2.new(size.X, 0)
        positions.bottom_right = position + size
    end

    local function update()
        local top_left = positions.top_left
        local top_right = positions.top_right
        local bottom_right = positions.bottom_right

        local top_left3D = Util:viewport_point_to_world(top_left, distance)
        local top_right3D = Util:viewport_point_to_world(top_right, distance)
        local bottom_right3D = Util:viewport_point_to_world(bottom_right, distance)

        local width = (top_right3D - top_left3D).Magnitude
        local height = (top_right3D - bottom_right3D).Magnitude

        if not self._root then
            return
        end

        self._root.CFrame = CFrame.fromMatrix((top_left3D + bottom_right3D) / 2, workspace.CurrentCamera.CFrame.XVector, workspace.CurrentCamera.CFrame.YVector, workspace.CurrentCamera.CFrame.ZVector)
        self._root.Mesh.Scale = Vector3.new(width, height, 0)
    end

    local function on_change()
        local offset = Util:get_offset()
        local size = self._frame.AbsoluteSize - Vector2.new(offset, offset)
        local position = self._frame.AbsolutePosition + Vector2.new(offset / 2, offset / 2)

        update_positions(size, position)
        task.spawn(update)
    end

    Connections['cframe_update'] = workspace.CurrentCamera:GetPropertyChangedSignal('CFrame'):Connect(update)
    Connections['viewport_size_update'] = workspace.CurrentCamera:GetPropertyChangedSignal('ViewportSize'):Connect(update)
    Connections['field_of_view_update'] = workspace.CurrentCamera:GetPropertyChangedSignal('FieldOfView'):Connect(update)

    Connections['frame_absolute_position'] = self._frame:GetPropertyChangedSignal('AbsolutePosition'):Connect(on_change)
    Connections['frame_absolute_size'] = self._frame:GetPropertyChangedSignal('AbsoluteSize'):Connect(on_change)
    
    task.spawn(update)
end


function AcrylicBlur:check_quality_level()
    local game_settings = UserSettings().GameSettings
    local quality_level = game_settings.SavedQualityLevel.Value

    if quality_level < 8 then
        self:change_visiblity(false)
    end

    Connections['quality_level'] = game_settings:GetPropertyChangedSignal('SavedQualityLevel'):Connect(function()
        local game_settings = UserSettings().GameSettings
        local quality_level = game_settings.SavedQualityLevel.Value

        self:change_visiblity(quality_level >= 8)
    end)
end


function AcrylicBlur:change_visiblity(state: boolean)
    self._root.Transparency = state and 0.98 or 1
end


local Config = setmetatable({
    save = function(self: any, file_name: any, config: any)
        local success_save, result = pcall(function()
            local flags = HttpService:JSONEncode(config)
            writefile('Azure/'..file_name..'.json', flags)
        end)
    
        if not success_save then
            warn('failed to save config', result)
        end
    end,
    load = function(self: any, file_name: any, config: any)
        local success_load, result = pcall(function()
            if not isfile('Azure/'..file_name..'.json') then
                self:save(file_name, config)
        
                return
            end
        
            local flags = readfile('Azure/'..file_name..'.json')
        
            if not flags then
                self:save(file_name, config)
        
                return
            end

            return HttpService:JSONDecode(flags)
        end)
    
        if not success_load then
            warn('failed to load config', result)
        end
    
        if not result then
            result = {
                _flags = {},
                _keybinds = {},
                _library = {}
            }
        end
    
        return result
    end
}, Config)


local Library = {
    _config = Config:load(game.GameId),

    _choosing_keybind = false,
    _device = nil,

    _ui_open = true,
    _ui_scale = 1,
    _ui_loaded = false,
    _ui = nil,

    _dragging = false,
    _drag_start = nil,
    _container_position = nil
}
Library.__index = Library


function Library:create_notification_root()
    if self._notification_root then
        return self._notification_root
    end

    local function corner(parent, radius)
        local ui_corner = Instance.new('UICorner')
        ui_corner.CornerRadius = radius or UDim.new(0, 12)
        ui_corner.Parent = parent

        return ui_corner
    end

    local function stroke(parent, color, transparency, thickness)
        local ui_stroke = Instance.new('UIStroke')
        ui_stroke.Color = color or Color3.fromRGB(52, 55, 66)
        ui_stroke.Transparency = transparency or 0.4
        ui_stroke.Thickness = thickness or 1
        ui_stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        ui_stroke.Parent = parent

        return ui_stroke
    end

    local function tween(object, duration, properties, style, direction)
        return TweenService:Create(object, TweenInfo.new(duration, style or Enum.EasingStyle.Quint, direction or Enum.EasingDirection.Out), properties)
    end

    local root = CoreGui:FindFirstChild('AzureNotificationRoot')

    if root then
        root:Destroy()
    end

    local notification_root = Instance.new('ScreenGui')
    notification_root.Name = 'AzureNotificationRoot'
    notification_root.ResetOnSpawn = false
    notification_root.IgnoreGuiInset = true
    notification_root.Parent = CoreGui

    local holder = Instance.new('Frame')
    holder.Name = 'ToastHolder'
    holder.AnchorPoint = Vector2.new(0.5, 0)
    holder.Position = UDim2.new(0.5, 0, 0, 14)
    holder.Size = UDim2.new(0.82, 0, 1, -28)
    holder.BackgroundTransparency = 1
    holder.Parent = notification_root

    local size_constraint = Instance.new('UISizeConstraint', holder)
    size_constraint.MaxSize = Vector2.new(390, math.huge)

    local list_layout = Instance.new('UIListLayout', holder)
    list_layout.FillDirection = Enum.FillDirection.Vertical
    list_layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    list_layout.VerticalAlignment = Enum.VerticalAlignment.Top
    list_layout.Padding = UDim.new(0, 8)
    list_layout.SortOrder = Enum.SortOrder.LayoutOrder

    self._notification_root = notification_root
    self._notification_holder = holder
    self._notification_active = {}
    self._notification_helpers = {
        corner = corner,
        stroke = stroke,
        tween = tween,
        theme = {
            bg = Color3.fromRGB(17, 18, 23),
            bgSoft = Color3.fromRGB(26, 28, 35),
            stroke = Color3.fromRGB(52, 55, 66),
            strokeLit = Color3.fromRGB(78, 82, 98),
            text = Color3.fromRGB(238, 240, 246),
            textDim = Color3.fromRGB(152, 157, 170),
            textFaint = Color3.fromRGB(104, 109, 124),
            success = Color3.fromRGB(88, 198, 140),
            info = Color3.fromRGB(98, 160, 226),
            warning = Color3.fromRGB(226, 178, 90),
            error = Color3.fromRGB(224, 104, 112),
            accent = Color3.fromRGB(98, 160, 226),
            font = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.Regular, Enum.FontStyle.Normal),
            fontMed = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.Medium, Enum.FontStyle.Normal),
            fontBold = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.SemiBold, Enum.FontStyle.Normal),
            radius = UDim.new(0, 12)
        },
        icons = {
            success = 'rbxassetid://7733715400',
            info = 'rbxassetid://7734053495',
            warning = 'rbxassetid://7734019099',
            error = 'rbxassetid://7733658133'
        }
    }

    return notification_root
end


function Library:notify(settings)
    settings = settings or {}
    local root = self:create_notification_root()
    local helper = self._notification_helpers

    if not root or not helper then
        return
    end

    local theme = helper.theme
    local icons = helper.icons
    local card_bg = Color3.fromRGB(18, 20, 28)
    local card_bg_alt = Color3.fromRGB(24, 27, 36)
    local function variant_color(variant)
        if variant == 'success' then
            return theme.success
        elseif variant == 'warning' then
            return theme.warning
        elseif variant == 'error' then
            return theme.error
        end

        return theme.info
    end

    local function detect_variant(data)
        local text = string.lower(tostring(data.title or '') .. ' ' .. tostring(data.text or ''))

        if text:find('error') or text:find('fail') or text:find('crash') then
            return 'error'
        elseif text:find('warn') or text:find('ping') or text:find('lag') or text:find('slow') then
            return 'warning'
        elseif text:find('off') or text:find('disable') or text:find('deactivat') then
            return 'info'
        elseif text:find('on') or text:find('enable') or text:find('activat') or text:find('success') then
            return 'success'
        end

        return 'info'
    end

    local variant = settings.type and string.lower(settings.type) or detect_variant(settings)
    local color = variant_color(variant)
    local duration = tonumber(settings.duration) or 2.5
    local title = settings.title and tostring(settings.title) or nil
    local body = settings.text and tostring(settings.text) ~= '' and tostring(settings.text) or nil
    local one_line = not (title and body)
    local label = one_line and (body or title or 'Notification') or nil

    if #self._notification_active >= 3 and self._notification_active[1] then
        self._notification_active[1].dismiss()
    end

    local card = Instance.new('Frame')
    card.Name = 'Toast'
    card.Size = UDim2.new(1, 0, 0, one_line and 44 or 58)
    card.BackgroundColor3 = card_bg
    card.BackgroundTransparency = 0.02
    card.BorderSizePixel = 0
    card.Position = UDim2.new(0, 0, 0, -10)
    card.Parent = self._notification_holder
    helper.corner(card)
    local stroke = helper.stroke(card, Color3.fromRGB(70, 75, 90), 0.25)

    local chip = Instance.new('Frame', card)
    chip.Size = UDim2.new(0, 26, 0, 26)
    chip.Position = UDim2.new(0, 18, 0.5, -13)
    if not one_line then
        chip.Position = UDim2.new(0, 18, 0, 12)
    end
    chip.BackgroundColor3 = color
    chip.BackgroundTransparency = 0.88
    chip.BorderSizePixel = 0
    helper.corner(chip, UDim.new(1, 0))

    local icon = Instance.new('ImageLabel', chip)
    icon.BackgroundTransparency = 1
    icon.AnchorPoint = Vector2.new(0.5, 0.5)
    icon.Position = UDim2.fromScale(0.5, 0.5)
    icon.Size = UDim2.new(0, 15, 0, 15)
    icon.Image = icons[variant] or icons.info
    icon.ImageColor3 = color

    if one_line then
        local message = Instance.new('TextLabel', card)
        message.BackgroundTransparency = 1
        message.Position = UDim2.new(0, 54, 0, 0)
        message.Size = UDim2.new(1, -72, 1, -2)
        message.Text = label
        message.TextColor3 = theme.text
        message.FontFace = theme.fontMed
        message.TextSize = 13
        message.TextXAlignment = Enum.TextXAlignment.Left
        message.TextYAlignment = Enum.TextYAlignment.Center
        message.TextTruncate = Enum.TextTruncate.AtEnd
    else
        local title_label = Instance.new('TextLabel', card)
        title_label.BackgroundTransparency = 1
        title_label.Position = UDim2.new(0, 54, 0, 10)
        title_label.Size = UDim2.new(1, -72, 0, 16)
        title_label.Text = title
        title_label.TextColor3 = theme.text
        title_label.FontFace = theme.fontBold
        title_label.TextSize = 13
        title_label.TextXAlignment = Enum.TextXAlignment.Left
        title_label.TextTruncate = Enum.TextTruncate.AtEnd

        local body_label = Instance.new('TextLabel', card)
        body_label.BackgroundTransparency = 1
        body_label.Position = UDim2.new(0, 54, 0, 29)
        body_label.Size = UDim2.new(1, -68, 0, 15)
        body_label.Text = body
        body_label.TextColor3 = theme.textDim
        body_label.FontFace = theme.font
        body_label.TextSize = 11
        body_label.TextXAlignment = Enum.TextXAlignment.Left
        body_label.TextTruncate = Enum.TextTruncate.AtEnd
    end

    local progress_bg = Instance.new('Frame', card)
    progress_bg.AnchorPoint = Vector2.new(0, 1)
    progress_bg.Position = UDim2.new(0, 14, 1, -5)
    progress_bg.Size = UDim2.new(1, -28, 0, 2)
    progress_bg.BackgroundColor3 = Color3.fromRGB(38, 42, 52)
    progress_bg.BackgroundTransparency = 0.35
    progress_bg.BorderSizePixel = 0
    helper.corner(progress_bg, UDim.new(1, 0))

    local progress = Instance.new('Frame', progress_bg)
    progress.Size = UDim2.fromScale(1, 1)
    progress.BackgroundColor3 = color
    progress.BorderSizePixel = 0
    helper.corner(progress, UDim.new(1, 0))

    card.BackgroundTransparency = 1
    helper.tween(card, 0.32, { BackgroundTransparency = 0.02 }):Play()
    helper.tween(progress, duration, { Size = UDim2.new(0, 0, 1, 0) }, Enum.EasingStyle.Linear):Play()

    local entry = {}
    entry.dismissed = false

    function entry.dismiss()
        if entry.dismissed then
            return
        end

        entry.dismissed = true

        for index, current in ipairs(self._notification_active) do
            if current == entry then
                table.remove(self._notification_active, index)
                break
            end
        end

        local tween_info = TweenInfo.new(0.26, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
        TweenService:Create(card, tween_info, { BackgroundTransparency = 1, Position = UDim2.new(0, 0, 0, -10) }):Play()

        for _, object in ipairs(card:GetDescendants()) do
            if object:IsA('TextLabel') then
                TweenService:Create(object, tween_info, { TextTransparency = 1 }):Play()
            elseif object:IsA('ImageLabel') then
                TweenService:Create(object, tween_info, { ImageTransparency = 1 }):Play()
            elseif object:IsA('Frame') then
                TweenService:Create(object, tween_info, { BackgroundTransparency = 1 }):Play()
            elseif object:IsA('UIStroke') then
                TweenService:Create(object, tween_info, { Transparency = 1 }):Play()
            end
        end

        task.delay(0.3, function()
            if card then
                pcall(function()
                    card:Destroy()
                end)
            end
        end)
    end

    card.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            entry.dismiss()
        end
    end)

    table.insert(self._notification_active, entry)
    task.delay(duration, function()
        entry.dismiss()
    end)
end


function Library.SendNotification(settings)
    if _G.PremiumUI_Notify then
        return _G.PremiumUI_Notify(settings)
    end

    if Library and Library.notify then
        return Library:notify(settings)
    end
end


function Library.new()
    local self = setmetatable({
        _loaded = false,
        _tab = 0,
    }, Library)
    
    self:create_notification_root()
    self:create_ui()

    return self
end

function Library:get_screen_scale()
    local viewport_size_x = workspace.CurrentCamera.ViewportSize.X

    self._ui_scale = viewport_size_x / 1400
end


function Library:get_device()
    local device = 'Unknown'

    if not UserInputService.TouchEnabled and UserInputService.KeyboardEnabled and UserInputService.MouseEnabled then
        device = 'PC'
    elseif UserInputService.TouchEnabled then
        device = 'Mobile'
    elseif UserInputService.GamepadEnabled then
        device = 'Console'
    end

    self._device = device
end


function Library:removed(action: any)
    self._ui.AncestryChanged:Once(action)
end


function Library:flag_type(flag: any, flag_type: any)
    if not Library._config._flags[flag] then
        return
    end

    return typeof(Library._config._flags[flag]) == flag_type
end


function Library:remove_table_value(__table: any, table_value: string)
    for index, value in __table do
        if value ~= table_value then
            continue
        end

        table.remove(__table, index)
    end
end

function Library:create_ui()
    local old_Azure = CoreGui:FindFirstChild('Azure')

    if old_Azure then
        Debris:AddItem(old_Azure, 0)
    end

    local AzureUI = Instance.new('ScreenGui')
    AzureUI.ResetOnSpawn = false
    AzureUI.Name = 'Azure'
    AzureUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    AzureUI.Parent = CoreGui
    
    local Container = Instance.new('Frame')
    Container.ClipsDescendants = true
    Container.BorderColor3 = Color3.fromRGB(255, 255, 255)
    Container.AnchorPoint = Vector2.new(0.5, 0.5)
    Container.Name = 'Container'
    Container.BackgroundTransparency = 0
    Container.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    Container.Position = UDim2.new(0.5, 0, 0.5, 0)
    Container.Size = UDim2.new(0, 0, 0, 0)
    Container.Active = true
    Container.BorderSizePixel = 0
    Container.ZIndex = 2
    Container.Parent = AzureUI


    local function set_gui_visibility(state: boolean)
        AzureUI.Enabled = state
        Container.Visible = state
    end

    
    local ContainerGradient = Instance.new("UIGradient")
    ContainerGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(0.10, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(0.12, Color3.fromRGB(0, 0, 0)),
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(0, 0, 0))
    }
    ContainerGradient.Rotation = 90
    ContainerGradient.Parent = Container

    
    local SideBar = Instance.new("Frame")
    SideBar.Name = "GradientSide"
    SideBar.Parent = Container
    SideBar.Size = UDim2.new(0, 10, 1, 0)
    SideBar.Position = UDim2.new(0, 0, 0, 0)
    SideBar.BackgroundTransparency = 1

    
    local SideGradient = Instance.new("UIGradient")
    SideGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(30, 30, 34)),
        ColorSequenceKeypoint.new(0.50, Color3.fromRGB(55, 110, 190)),
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(110, 80, 200))
    }
    SideGradient.Rotation = 90
    SideGradient.Parent = SideBar

    local UICorner = Instance.new('UICorner')
    UICorner.CornerRadius = UDim.new(0, 12)
    UICorner.Parent = Container
    
    local UIStroke = Instance.new('UIStroke')
    UIStroke.Color = Color3.fromRGB(78, 92, 122)
    UIStroke.Thickness = 1
    UIStroke.Transparency = 0.28
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke.Parent = Container
    
    local Handler = Instance.new('Frame')
    Handler.BackgroundTransparency = 1
    Handler.Name = 'Handler'
    Handler.BorderColor3 = Color3.fromRGB(35, 55, 85)
    Handler.Size = UDim2.new(0, 750, 0, 530)
    Handler.BorderSizePixel = 0
    Handler.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Handler.Parent = Container
    
    local Tabs = Instance.new('ScrollingFrame')
    Tabs.ScrollBarImageTransparency = 1
    Tabs.ScrollBarThickness = 0
    Tabs.Name = 'Tabs'
    Tabs.Size = UDim2.new(0, 140, 0, 445)
    Tabs.Selectable = false
    Tabs.AutomaticCanvasSize = Enum.AutomaticSize.XY
    Tabs.BackgroundTransparency = 1
    Tabs.Position = UDim2.new(0.026097271591424942, 0, 0.1111111119389534, 10)
    Tabs.BorderColor3 = Color3.fromRGB(40, 65, 95)
    Tabs.BackgroundColor3 = Color3.fromRGB(30, 45, 70)
    Tabs.BorderSizePixel = 0
    Tabs.CanvasSize = UDim2.new(0, 0, 0.5, 0)
    Tabs.Parent = Handler
    
    local UIListLayout = Instance.new('UIListLayout')
    UIListLayout.Padding = UDim.new(0, 4)
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Parent = Tabs
    
    local AzureIcon = Instance.new('ImageLabel')
    AzureIcon.Name = 'AzureIcon'
    AzureIcon.BackgroundTransparency = 1
    AzureIcon.Position = UDim2.new(0.02, 0, 0.049, 0)
    AzureIcon.Size = UDim2.new(0, 25, 0, 25)
    AzureIcon.AnchorPoint = Vector2.new(0, 0.5)
    AzureIcon.Image = 'rbxassetid://86155014390461'
    AzureIcon.ScaleType = Enum.ScaleType.Fit
    AzureIcon.Parent = Handler

    local ClientName = Instance.new('TextLabel')
    ClientName.Font = Enum.Font.GothamBold
    ClientName.TextColor3 = Color3.fromRGB(255, 255, 255)
    ClientName.TextTransparency = 0
    ClientName.Text = 'Zure'
    ClientName.Name = 'ClientName'
    ClientName.Size = UDim2.new(0, 31, 0, 13)
    ClientName.AnchorPoint = Vector2.new(0, 0.5)
    ClientName.Position = UDim2.new(0.060, 0, 0.049, 1.5)
    ClientName.BackgroundTransparency = 1
    ClientName.TextXAlignment = Enum.TextXAlignment.Left
    ClientName.BorderSizePixel = 0
    ClientName.BorderColor3 = Color3.fromRGB(0, 0, 0)
    ClientName.TextSize = 16
    ClientName.BackgroundTransparency = 1
    ClientName.Parent = Handler

    local Divider = Instance.new('Frame')
    Divider.Name = 'Divider'
    Divider.BackgroundTransparency = 0.5
    Divider.Position = UDim2.new(0.225, 0, 0, 68)
    Divider.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Divider.Size = UDim2.new(0, 1, 0, 440)
    Divider.BorderSizePixel = 0
    Divider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Divider.Parent = Handler

    local DividerGradient = Instance.new('UIGradient')
    DividerGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
    }
    DividerGradient.Transparency = NumberSequence.new{
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.12, 0.4),
        NumberSequenceKeypoint.new(0.88, 0.4),
        NumberSequenceKeypoint.new(1, 1)
    }
    DividerGradient.Rotation = 90
    DividerGradient.Parent = Divider
    
    local Sections = Instance.new('Folder')
    Sections.Name = 'Sections'
    Sections.Parent = Handler

    local Minimize = Instance.new('TextButton')
    Minimize.FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.Regular, Enum.FontStyle.Normal)
    Minimize.TextColor3 = Color3.fromRGB(255, 255, 255)
    Minimize.BorderColor3 = Color3.fromRGB(255, 255, 255)
    Minimize.Text = ''
    Minimize.AutoButtonColor = false
    Minimize.Name = 'Minimize'
    Minimize.BackgroundTransparency = 1
    Minimize.Position = UDim2.new(0.020057305693626404, 0, 0.02922755666077137, 0)
    Minimize.Size = UDim2.new(0, 24, 0, 24)
    Minimize.BorderSizePixel = 0
    Minimize.TextSize = 14
    Minimize.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    Minimize.Parent = Handler

    local SearchButton = Instance.new('ImageButton')
    SearchButton.Name = 'SearchButton'
    SearchButton.BackgroundTransparency = 1
    SearchButton.Size = UDim2.new(0, 24, 0, 24)
    SearchButton.AnchorPoint = Vector2.new(1, 0.5)
    SearchButton.Position = UDim2.new(1, -13, 0.029, 14)
    SearchButton.Image = 'rbxassetid://119657619195563'
    SearchButton.ImageColor3 = Color3.fromRGB(255, 255, 255)
    SearchButton.ScaleType = Enum.ScaleType.Fit
    SearchButton.ImageTransparency = 0
    SearchButton.BorderSizePixel = 0
    SearchButton.AutoButtonColor = false
    SearchButton.Parent = Handler
    
    local UIScale = Instance.new('UIScale')
    UIScale.Parent = Container    
    
    self._ui = AzureUI

    local function on_drag(input: InputObject, process: boolean)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then 
            self._dragging = true
            self._drag_start = input.Position
            self._container_position = Container.Position

            Connections['container_input_ended'] = input.Changed:Connect(function()
                if input.UserInputState ~= Enum.UserInputState.End then
                    return
                end

                Connections:disconnect('container_input_ended')
                self._dragging = false
            end)
        end
    end

    local function update_drag(input: any)
        local delta = input.Position - self._drag_start
        local position = UDim2.new(self._container_position.X.Scale, self._container_position.X.Offset + delta.X, self._container_position.Y.Scale, self._container_position.Y.Offset + delta.Y)

        TweenService:Create(Container, TweenInfo.new(0.2), {
            Position = position
        }):Play()
    end

    local function drag(input: InputObject, process: boolean)
        if not self._dragging then
            return
        end

        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            update_drag(input)
        end
    end

    Connections['container_input_began'] = Container.InputBegan:Connect(on_drag)
    Connections['input_changed'] = UserInputService.InputChanged:Connect(drag)

    self:removed(function()
        self._ui = nil
        Connections:disconnect_all()
    end)

    function self:Update1Run(a)
        if a == "nil" then
            Container.BackgroundTransparency = 0.05000000074505806;
        else
            pcall(function()
                Container.BackgroundTransparency = tonumber(a);
            end);
        end;
    end;

    function self:UIVisiblity()
        AzureUI.Enabled = not AzureUI.Enabled;
    end;

    function self:change_visiblity(state: boolean)
        if state then
            TweenService:Create(Container, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Size = UDim2.fromOffset(750, 530)
            }):Play()
        else
            TweenService:Create(Container, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Size = UDim2.fromOffset(104.5, 52)
            }):Play()
        end
    end
    

    function self:load()
        local content = {}
    
        for _, object in AzureUI:GetDescendants() do
            if not object:IsA('ImageLabel') then
                continue
            end
    
            table.insert(content, object)
        end
    
        ContentProvider:PreloadAsync(content)
        self:get_device()

        if self._device == 'Mobile' or self._device == 'Unknown' then
            self:get_screen_scale()
            UIScale.Scale = self._ui_scale
    
            Connections['ui_scale'] = workspace.CurrentCamera:GetPropertyChangedSignal('ViewportSize'):Connect(function()
                self:get_screen_scale()
                UIScale.Scale = self._ui_scale
            end)
        end
    
        TweenService:Create(Container, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            Size = UDim2.fromOffset(750, 530)
        }):Play()

        AcrylicBlur.new(Container)
        self._ui_loaded = true

    end

    function self:update_tabs(tab: TextButton)
        for index, object in Tabs:GetChildren() do
            if object.Name ~= 'Tab' then
                continue
            end

            if object == tab then
                if object.BackgroundTransparency ~= 0.85 then
                    local offset = object.LayoutOrder * (0.113 / 1.3)

                    TweenService:Create(object, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                        BackgroundTransparency = 0.85,
                        BackgroundColor3 = Color3.fromRGB(220, 220, 220)
                    }):Play()

                    TweenService:Create(object.TextLabel, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                        TextTransparency = 0.3,
                        TextColor3 = Color3.fromRGB(255, 255, 255)
                    }):Play()

                    TweenService:Create(object.TextLabel.UIGradient, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                        Offset = Vector2.new(1, 0)
                    }):Play()

                    object.TextLabel.UIGradient.Color = ColorSequence.new{
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
                    }

                    if not object:FindFirstChild('ActiveIndicator') then
                        local ActiveIndicator = Instance.new('Frame')
                        ActiveIndicator.Name = 'ActiveIndicator'
                        ActiveIndicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                        ActiveIndicator.BackgroundTransparency = 0.5
                        ActiveIndicator.BorderSizePixel = 0
                        ActiveIndicator.Size = UDim2.new(0, 2, 0, 0)
                        ActiveIndicator.Position = UDim2.new(0, 0, 0.2, 0)
                        ActiveIndicator.Parent = object

                        TweenService:Create(ActiveIndicator, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                            Size = UDim2.new(0, 2, 0.6, 0)
                        }):Play()
                    end

                    local icon = object:FindFirstChild('Icon')
                    if icon then
                        TweenService:Create(icon, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                            ImageTransparency = 0,
                            ImageColor3 = Color3.fromRGB(255, 255, 255)
                        }):Play()
                    end
                end

                continue
            end

            if object.BackgroundTransparency ~= 1 then
                TweenService:Create(object, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                    BackgroundTransparency = 1
                }):Play()

                TweenService:Create(object.TextLabel, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                    TextTransparency = 0.6,
                    TextColor3 = Color3.fromRGB(255, 255, 255)
                }):Play()

                TweenService:Create(object.TextLabel.UIGradient, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                    Offset = Vector2.new(0, 0)
                }):Play()

                object.TextLabel.UIGradient.Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
                }

                local icon = object:FindFirstChild('Icon')
                if icon then
                    TweenService:Create(icon, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                        ImageTransparency = 0,
                        ImageColor3 = Color3.fromRGB(255, 255, 255)
                    }):Play()
                end

                local ActiveIndicator = object:FindFirstChild('ActiveIndicator')
                if ActiveIndicator then
                    TweenService:Create(ActiveIndicator, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                        Size = UDim2.new(0, 2, 0, 0)
                    }):Play()

                    game:GetService('Debris'):AddItem(ActiveIndicator, 0.5)
                end
            end
        end
    end

    function self:update_sections(left_section: ScrollingFrame, right_section: ScrollingFrame)
        for _, object in Sections:GetChildren() do
            if object == left_section or object == right_section then
                object.Visible = true

                continue
            end

            object.Visible = false
        end
    end

    function self:create_tab(title: string)
        local TabManager = {}

        local LayoutOrder = 0;

        local font_params = Instance.new('GetTextBoundsParams')
        font_params.Text = title
        font_params.Font = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
        font_params.Size = 13
        font_params.Width = 10000

        local font_size = TextService:GetTextBoundsAsync(font_params)
        local first_tab = not Tabs:FindFirstChild('Tab')

        local Tab = Instance.new('TextButton')
        Tab.FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.Bold, Enum.FontStyle.Normal)
        Tab.TextColor3 = Color3.fromRGB(255, 255, 255)
        Tab.BorderColor3 = Color3.fromRGB(0, 0, 0)
        Tab.Text = ''
        Tab.AutoButtonColor = false
        Tab.BackgroundTransparency = 1
        Tab.Name = 'Tab'
        Tab.Size = UDim2.new(0, 129, 0, 38)
        Tab.BorderSizePixel = 0
        Tab.TextSize = 14
        Tab.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
        Tab.Parent = Tabs
        Tab.LayoutOrder = self._tab
        
        local UICorner = Instance.new('UICorner')
        UICorner.CornerRadius = UDim.new(0, 8)
        UICorner.Parent = Tab
        
        local TextLabel = Instance.new('TextLabel')
        TextLabel.FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.Bold, Enum.FontStyle.Normal)
        TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        TextLabel.TextTransparency = 0.7
        TextLabel.Text = title
        TextLabel.Size = UDim2.new(0, font_size.X, 0, 16)
        TextLabel.AnchorPoint = Vector2.new(0, 0.5)
        TextLabel.Position = UDim2.new(0.2400001734495163, 0, 0.5, 0)
        TextLabel.BackgroundTransparency = 1
        TextLabel.TextXAlignment = Enum.TextXAlignment.Left
        TextLabel.BorderSizePixel = 0
        TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
        TextLabel.TextSize = 13
        TextLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        TextLabel.Parent = Tab
        
        local UIGradient = Instance.new('UIGradient')
        UIGradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
        }
        UIGradient.Parent = TextLabel

        local LeftSection = Instance.new('ScrollingFrame')
        LeftSection.Name = 'LeftSection'
        LeftSection.AutomaticCanvasSize = Enum.AutomaticSize.XY
        LeftSection.ScrollBarThickness = 0
        LeftSection.Size = UDim2.new(0, 243, 0, 445)
        LeftSection.Selectable = false
        LeftSection.AnchorPoint = Vector2.new(0, 0.5)
        LeftSection.ScrollBarImageTransparency = 1
        LeftSection.BackgroundTransparency = 1
        LeftSection.Position = UDim2.new(0.2594326436519623, 0, 0.5, 25)
        LeftSection.BorderColor3 = Color3.fromRGB(0, 0, 0)
        LeftSection.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
        LeftSection.BorderSizePixel = 0
        LeftSection.CanvasSize = UDim2.new(0, 0, 0.5, 0)
        LeftSection.Visible = false
        LeftSection.Parent = Sections
        
        local UIListLayout = Instance.new('UIListLayout')
        UIListLayout.Padding = UDim.new(0, 18)
        UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        UIListLayout.Parent = LeftSection
        
        local UIPadding = Instance.new('UIPadding')
        UIPadding.PaddingTop = UDim.new(0, 1)
        UIPadding.Parent = LeftSection

        local RightSection = Instance.new('ScrollingFrame')
        RightSection.Name = 'RightSection'
        RightSection.AutomaticCanvasSize = Enum.AutomaticSize.XY
        RightSection.ScrollBarThickness = 0
        RightSection.Size = UDim2.new(0, 243, 0, 445)
        RightSection.Selectable = false
        RightSection.AnchorPoint = Vector2.new(0, 0.5)
        RightSection.ScrollBarImageTransparency = 1
        RightSection.BackgroundTransparency = 1
        RightSection.Position = UDim2.new(0.6290000081062317, 0, 0.5, 25)
        RightSection.BorderColor3 = Color3.fromRGB(0, 0, 0)
        RightSection.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
        RightSection.BorderSizePixel = 0
        RightSection.CanvasSize = UDim2.new(0, 0, 0.5, 0)
        RightSection.Visible = false
        RightSection.Parent = Sections
        
        local UIListLayout = Instance.new('UIListLayout')
        UIListLayout.Padding = UDim.new(0, 18)
        UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        UIListLayout.Parent = RightSection
        
        local UIPadding = Instance.new('UIPadding')
        UIPadding.PaddingTop = UDim.new(0, 1)
        UIPadding.Parent = RightSection

        self._tab += 1

        if first_tab then
            self:update_tabs(Tab, LeftSection, RightSection)
            self:update_sections(LeftSection, RightSection)
        end

        Tab.MouseButton1Click:Connect(function()
            self:update_tabs(Tab, LeftSection, RightSection)
            self:update_sections(LeftSection, RightSection)
        end)

function TabManager:moduleparagraph(settings: any)

    local LayoutOrderModule = 0;

    local ModuleManager = {
        _size = 0,
        _multiplier = 0
    }

    if settings.section == 'right' then
        settings.section = RightSection
    else
        settings.section = LeftSection
    end

    local Module = Instance.new('Frame')
    Module.ClipsDescendants = true
    Module.BorderColor3 = Color3.fromRGB(255, 255, 255)
    Module.BackgroundTransparency = 0.15
    Module.Position = UDim2.new(0.004115226212888956, 0, 0, -5)
    Module.Name = 'ModuleParagraph'
    Module.Size = UDim2.new(0, 241, 0, 70)
    Module.BorderSizePixel = 0
    Module.BackgroundColor3 = Color3.fromRGB(16, 17, 22)
    Module.Parent = settings.section

    local UIListLayout = Instance.new('UIListLayout')
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Parent = Module
    
    local UICorner = Instance.new('UICorner')
    UICorner.CornerRadius = UDim.new(0, 5)
    UICorner.Parent = Module
    
    local UIStroke = Instance.new('UIStroke')
    UIStroke.Color = Color3.fromRGB(255, 255, 255)
    UIStroke.Transparency = 0.72
    UIStroke.Thickness = 1
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke.Parent = Module
    
    local Header = Instance.new('Frame')
    Header.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Header.Name = 'Header'
    Header.Size = UDim2.new(0, 241, 0, 70)
    Header.BorderSizePixel = 0
    Header.BackgroundTransparency = 1
    Header.Parent = Module

    local ModuleName = Instance.new('TextLabel')
    ModuleName.FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
    ModuleName.TextColor3 = Color3.fromRGB(255, 255, 255)
    ModuleName.TextTransparency = 0.20000000298023224
    if not settings.rich then
        ModuleName.Text = settings.title or "Paragraph Title"
    else
        ModuleName.RichText = true
        ModuleName.Text = settings.richtext or "<font color='rgb(255,0,0)'>Azure</font> Info"
    end
    ModuleName.Name = 'ModuleName'
    ModuleName.Size = UDim2.new(0, 205, 0, 13)
    ModuleName.AnchorPoint = Vector2.new(0, 0.5)
    ModuleName.Position = UDim2.new(0.0729999989271164, 0, 0.23999999463558197, 0)
    ModuleName.BackgroundTransparency = 1
    ModuleName.TextXAlignment = Enum.TextXAlignment.Left
    ModuleName.BorderSizePixel = 0
    ModuleName.BorderColor3 = Color3.fromRGB(0, 0, 0)
    ModuleName.TextSize = 13
    ModuleName.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    ModuleName.Parent = Header
    
    local Description = Instance.new('TextLabel')
    Description.FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
    Description.TextColor3 = Color3.fromRGB(220, 220, 220)
    Description.TextTransparency = 0.699999988079071
    Description.Text = settings.description or "This is a description paragraph."
    Description.Name = 'Description'
    Description.Size = UDim2.new(0, 205, 0, 28)
    Description.AnchorPoint = Vector2.new(0, 0.5)
    Description.Position = UDim2.new(0.0729999989271164, 0, 0.55, 0)
    Description.BackgroundTransparency = 1
    Description.TextXAlignment = Enum.TextXAlignment.Left
    Description.TextYAlignment = Enum.TextYAlignment.Top
    Description.TextWrapped = true
    Description.BorderSizePixel = 0
    Description.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Description.TextSize = 10
    Description.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    Description.Parent = Header

    return ModuleManager
end

function TabManager:create_image(settings: any)

    if settings.section == 'right' then
        settings.section = RightSection
    else
        settings.section = LeftSection
    end

    local Module = Instance.new('Frame')
    Module.ClipsDescendants = true
    Module.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Module.BackgroundTransparency = 0.1
    Module.Position = UDim2.new(0.004, 0, 0, 0)
    Module.Name = 'ImageModule'
    Module.Size = UDim2.new(0, 241, 0, 140) 
    Module.BorderSizePixel = 0
    Module.BackgroundColor3 = Color3.fromRGB(16, 17, 22)
    Module.Parent = settings.section

    local UICorner = Instance.new('UICorner')
    UICorner.CornerRadius = UDim.new(0, 5)
    UICorner.Parent = Module
    
    local UIStroke = Instance.new('UIStroke')
    UIStroke.Color = Color3.fromRGB(255, 255, 255)
    UIStroke.Transparency = 0.72
    UIStroke.Thickness = 1
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke.Parent = Module
    
    local Image = Instance.new("ImageLabel")
    Image.Name = "GameImage"
    Image.Parent = Module
    Image.AnchorPoint = Vector2.new(0.5, 0.5) 
    Image.Position = UDim2.new(0.5, 0, 0.5, 0) 
    Image.Size = UDim2.new(0, 215, 0, 120)  
    Image.BackgroundTransparency = 1
    Image.Image = settings.image or "rbxassetid://123456789"

    local ImageCorner = Instance.new("UICorner")
    ImageCorner.CornerRadius = UDim.new(0, 7)  
    ImageCorner.Parent = Image
end

function TabManager:create_playerinfo(settings: any)
    if settings.section == 'right' then
        settings.section = RightSection
    else
        settings.section = LeftSection
    end

    local LocalPlayer = Players.LocalPlayer

    local Module = Instance.new('Frame')
    Module.ClipsDescendants = true
    Module.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Module.BackgroundTransparency = 0.5
    Module.Position = UDim2.new(0.004, 0, 0, 0)
    Module.Name = 'PlayerInfo'
    Module.Size = UDim2.new(0, 241, 0, 80)
    Module.BorderSizePixel = 0
    Module.BackgroundColor3 = Color3.fromRGB(16, 17, 22)
    Module.Parent = settings.section

    local UICorner = Instance.new('UICorner')
    UICorner.CornerRadius = UDim.new(0, 7)
    UICorner.Parent = Module

    local UIStroke = Instance.new('UIStroke')
    UIStroke.Color = Color3.fromRGB(255, 255, 255)
    UIStroke.Transparency = 0.72
    UIStroke.Thickness = 1
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke.Parent = Module

    
    local AvatarClip = Instance.new('Frame')
    AvatarClip.Name = 'AvatarClip'
    AvatarClip.BackgroundColor3 = Color3.fromRGB(30, 36, 50)
    AvatarClip.BackgroundTransparency = 0
    AvatarClip.Position = UDim2.new(0, 10, 0.5, -25)
    AvatarClip.Size = UDim2.new(0, 50, 0, 50)
    AvatarClip.BorderSizePixel = 0
    AvatarClip.ClipsDescendants = true
    AvatarClip.Parent = Module

    local AvatarClipCorner = Instance.new('UICorner')
    AvatarClipCorner.CornerRadius = UDim.new(1, 0)
    AvatarClipCorner.Parent = AvatarClip

    local Avatar = Instance.new('ImageLabel')
    Avatar.Name = 'Avatar'
    Avatar.Size = UDim2.new(1, 0, 1, 0)
    Avatar.BackgroundTransparency = 1
    Avatar.ScaleType = Enum.ScaleType.Fit
    Avatar.Image = ''
    Avatar.Parent = AvatarClip

    
    local NameLabel = Instance.new('TextLabel')
    NameLabel.Name = 'NameLabel'
    NameLabel.FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    NameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    NameLabel.TextTransparency = 0.1
    NameLabel.Text = LocalPlayer.DisplayName
    NameLabel.Size = UDim2.new(0, 160, 0, 16)
    NameLabel.Position = UDim2.new(0, 70, 0, 12)
    NameLabel.BackgroundTransparency = 1
    NameLabel.TextXAlignment = Enum.TextXAlignment.Left
    NameLabel.TextSize = 13
    NameLabel.TextTruncate = Enum.TextTruncate.AtEnd
    NameLabel.Parent = Module

    
    local UsernameLabel = Instance.new('TextLabel')
    UsernameLabel.Name = 'UsernameLabel'
    UsernameLabel.FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.Regular, Enum.FontStyle.Normal)
    UsernameLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    UsernameLabel.TextTransparency = 0.4
    UsernameLabel.Text = '@' .. LocalPlayer.Name
    UsernameLabel.Size = UDim2.new(0, 160, 0, 13)
    UsernameLabel.Position = UDim2.new(0, 70, 0, 31)
    UsernameLabel.BackgroundTransparency = 1
    UsernameLabel.TextXAlignment = Enum.TextXAlignment.Left
    UsernameLabel.TextSize = 11
    UsernameLabel.TextTruncate = Enum.TextTruncate.AtEnd
    UsernameLabel.Parent = Module

    
    local UserIdLabel = Instance.new('TextLabel')
    UserIdLabel.Name = 'UserIdLabel'
    UserIdLabel.FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.Regular, Enum.FontStyle.Normal)
    UserIdLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    UserIdLabel.TextTransparency = 0.55
    UserIdLabel.Text = 'ID: ' .. tostring(LocalPlayer.UserId)
    UserIdLabel.Size = UDim2.new(0, 160, 0, 12)
    UserIdLabel.Position = UDim2.new(0, 70, 0, 50)
    UserIdLabel.BackgroundTransparency = 1
    UserIdLabel.TextXAlignment = Enum.TextXAlignment.Left
    UserIdLabel.TextSize = 10
    UserIdLabel.Parent = Module

    
    task.spawn(function()
        local success, thumbnail = pcall(function()
            return Players:GetUserThumbnailAsync(
                LocalPlayer.UserId,
                Enum.ThumbnailType.HeadShot,
                Enum.ThumbnailSize.Size60x60
            )
        end)
        if success and thumbnail then
            Avatar.Image = thumbnail
        end
    end)
end

        function TabManager:create_module(settings: any)

            local LayoutOrderModule = 0;

            local ModuleManager = {
                _state = false,
                _size = 0,
                _multiplier = 0
            }

            if settings.section == 'right' then
                settings.section = RightSection
            else
                settings.section = LeftSection
            end

            local Module = Instance.new('Frame')
            Module.ClipsDescendants = true
            Module.BorderColor3 = Color3.fromRGB(0, 0, 0)
            Module.BackgroundTransparency = 0.02
            Module.Position = UDim2.new(0.004115226212888956, 0, 0, -5)
            Module.Name = 'Module'
            Module.Size = UDim2.new(0, 241, 0, 93)
            Module.BorderSizePixel = 0
            Module.BackgroundColor3 = Color3.fromRGB(16, 17, 22)
            Module.Parent = settings.section

            local UIListLayout = Instance.new('UIListLayout')
            UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            UIListLayout.Parent = Module
            
            local UICorner = Instance.new('UICorner')
            UICorner.CornerRadius = UDim.new(0, 8)
            UICorner.Parent = Module
            
            local moduleStrokeColor = Color3.fromRGB(255, 255, 255)

            local UIStroke = Instance.new('UIStroke')
            UIStroke.Color = moduleStrokeColor
            UIStroke.Transparency = 0.72
            UIStroke.Thickness = 1
            UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            UIStroke.Parent = Module
            
            local Header = Instance.new('TextButton')
            Header.FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.Regular, Enum.FontStyle.Normal)
            Header.TextColor3 = Color3.fromRGB(255, 255, 255)
            Header.BorderColor3 = Color3.fromRGB(0, 0, 0)
            Header.Text = ''
            Header.AutoButtonColor = false
            Header.BackgroundTransparency = 1
            Header.Name = 'Header'
            Header.Size = UDim2.new(0, 241, 0, 93)
            Header.BorderSizePixel = 0
            Header.TextSize = 14
            Header.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Header.Parent = Module
            
            local module_icon = settings.icon or 'rbxassetid://79095934438045'

            local Icon = Instance.new('ImageLabel')
            Icon.ImageColor3 = Color3.fromRGB(255, 255, 255)
            Icon.ScaleType = Enum.ScaleType.Fit
            Icon.ImageTransparency = 0
            Icon.BorderColor3 = Color3.fromRGB(0, 0, 0)
            Icon.AnchorPoint = Vector2.new(0, 0.5)
            Icon.Image = module_icon
            Icon.BackgroundTransparency = 1
            Icon.Position = UDim2.new(0.07100000232458115, 0, 0.8199999928474426, 0)
            Icon.Name = 'Icon'
            Icon.Size = UDim2.new(0, 15, 0, 15)
            Icon.BorderSizePixel = 0
            Icon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Icon.Parent = Header
            
            local ModuleName = Instance.new('TextLabel')
            ModuleName.FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
            ModuleName.TextColor3 = Color3.fromRGB(255, 255, 255)
            ModuleName.TextTransparency = 0.20000000298023224
            if not settings.rich then
                ModuleName.Text = settings.title or "Skibidi"
            else
                ModuleName.RichText = true
                ModuleName.Text = settings.richtext or "<font color='rgb(255,0,0)'>Azure</font> user"
            end;
            ModuleName.Name = 'ModuleName'
            ModuleName.Size = UDim2.new(0, 205, 0, 13)
            ModuleName.AnchorPoint = Vector2.new(0, 0.5)
            ModuleName.Position = UDim2.new(0.0729999989271164, 0, 0.23999999463558197, 0)
            ModuleName.BackgroundTransparency = 1
            ModuleName.TextXAlignment = Enum.TextXAlignment.Left
            ModuleName.BorderSizePixel = 0
            ModuleName.BorderColor3 = Color3.fromRGB(0, 0, 0)
            ModuleName.TextSize = 13
            ModuleName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ModuleName.Parent = Header
            
            local Description = Instance.new('TextLabel')
            Description.FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
            Description.TextColor3 = Color3.fromRGB(255, 255, 255)
            Description.TextTransparency = 0.699999988079071
            Description.Text = settings.description
            Description.Name = 'Description'
            Description.Size = UDim2.new(0, 205, 0, 13)
            Description.AnchorPoint = Vector2.new(0, 0.5)
            Description.Position = UDim2.new(0.0729999989271164, 0, 0.41999998688697815, 0)
            Description.BackgroundTransparency = 1
            Description.TextXAlignment = Enum.TextXAlignment.Left
            Description.BorderSizePixel = 0
            Description.BorderColor3 = Color3.fromRGB(0, 0, 0)
            Description.TextSize = 10
            Description.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Description.Parent = Header
            
            local Toggle = Instance.new('Frame')
            Toggle.Name = 'Toggle'
            Toggle.BackgroundTransparency = 0.699999988079071
            Toggle.Position = UDim2.new(0.8199999928474426, 0, 0.7570000290870667, 0)
            Toggle.BorderColor3 = Color3.fromRGB(0, 0, 0)
            Toggle.Size = UDim2.new(0, 25, 0, 12)
            Toggle.BorderSizePixel = 0
            Toggle.BackgroundColor3 = Color3.fromRGB(44, 44, 52)
            Toggle.Parent = Header
            
            local UICorner = Instance.new('UICorner')
            UICorner.CornerRadius = UDim.new(1, 0)
            UICorner.Parent = Toggle
            
            local Circle = Instance.new('Frame')
            Circle.BorderColor3 = Color3.fromRGB(0, 0, 0)
            Circle.AnchorPoint = Vector2.new(0, 0.5)
            Circle.BackgroundTransparency = 0.20000000298023224
            Circle.Position = UDim2.new(0, 0, 0.5, 0)
            Circle.Name = 'Circle'
            Circle.Size = UDim2.new(0, 12, 0, 12)
            Circle.BorderSizePixel = 0
            Circle.BackgroundColor3 = Color3.fromRGB(120, 120, 132)
            Circle.Parent = Toggle
            
            local UICorner = Instance.new('UICorner')
            UICorner.CornerRadius = UDim.new(1, 0)
            UICorner.Parent = Circle
            
            local Keybind = Instance.new('Frame')
            Keybind.Name = 'Keybind'
            Keybind.BackgroundTransparency = 0.699999988079071
            Keybind.Position = UDim2.new(0.15000000596046448, 0, 0.7350000143051147, 0)
            Keybind.BorderColor3 = Color3.fromRGB(0, 0, 0)
            Keybind.Size = UDim2.new(0, 33, 0, 15)
            Keybind.BorderSizePixel = 0
            Keybind.BackgroundColor3 = Color3.fromRGB(26, 26, 32)
            Keybind.Parent = Header
            
            local UICorner = Instance.new('UICorner')
            UICorner.CornerRadius = UDim.new(0, 3)
            UICorner.Parent = Keybind
            
            local TextLabel = Instance.new('TextLabel')
            TextLabel.FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
            TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
            TextLabel.Text = 'None'
            TextLabel.AnchorPoint = Vector2.new(0.5, 0.5)
            TextLabel.Size = UDim2.new(0, 25, 0, 13)
            TextLabel.BackgroundTransparency = 1
            TextLabel.TextXAlignment = Enum.TextXAlignment.Left
            TextLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
            TextLabel.BorderSizePixel = 0
            TextLabel.TextSize = 10
            TextLabel.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
            TextLabel.Parent = Keybind
            
            local Divider = Instance.new('Frame')
            Divider.BorderColor3 = Color3.fromRGB(0, 0, 0)
            Divider.AnchorPoint = Vector2.new(0.5, 0)
            Divider.BackgroundTransparency = 0.7
            Divider.Position = UDim2.new(0.5, 0, 0.6200000047683716, 0)
            Divider.Name = 'Divider'
            Divider.Size = UDim2.new(0, 241, 0, 1)
            Divider.BorderSizePixel = 0
            Divider.BackgroundColor3 = moduleStrokeColor
            Divider.Parent = Header
            
            local Divider = Instance.new('Frame')
            Divider.BorderColor3 = Color3.fromRGB(0, 0, 0)
            Divider.AnchorPoint = Vector2.new(0.5, 0)
            Divider.BackgroundTransparency = 0.78
            Divider.Position = UDim2.new(0.5, 0, 1, 0)
            Divider.Name = 'Divider'
            Divider.Size = UDim2.new(0, 241, 0, 1)
            Divider.BorderSizePixel = 0
            Divider.BackgroundColor3 = moduleStrokeColor
            Divider.Parent = Header
            
            local Options = Instance.new('Frame')
            Options.Name = 'Options'
            Options.BackgroundTransparency = 1
            Options.Position = UDim2.new(0, 0, 1, 0)
            Options.BorderColor3 = Color3.fromRGB(0, 0, 0)
            Options.Size = UDim2.new(0, 241, 0, 8)
            Options.BorderSizePixel = 0
            Options.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Options.Parent = Module

            local UIPadding = Instance.new('UIPadding')
            UIPadding.PaddingTop = UDim.new(0, 8)
            UIPadding.Parent = Options

            local OptionsStroke = Instance.new('UIStroke')
            OptionsStroke.Color = moduleStrokeColor
            OptionsStroke.Transparency = 0.82
            OptionsStroke.Thickness = 0.5
            OptionsStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            OptionsStroke.Parent = Options

            local UIListLayout = Instance.new('UIListLayout')
            UIListLayout.Padding = UDim.new(0, 5)
            UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
            UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            UIListLayout.Parent = Options

            function ModuleManager:change_state(state: boolean)
                self._state = state

                if self._state then
                    TweenService:Create(Module, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                        Size = UDim2.fromOffset(241, 93 + self._size + self._multiplier)
                    }):Play()

                    TweenService:Create(Toggle, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                        BackgroundColor3 = Color3.fromRGB(205, 205, 220)
                    }):Play()

                    TweenService:Create(Circle, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                        BackgroundColor3 = Color3.fromRGB(245, 245, 250),
                        Position = UDim2.fromScale(0.53, 0.5)
                    }):Play()
                else
                    TweenService:Create(Module, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                        Size = UDim2.fromOffset(241, 93)
                    }):Play()

                    TweenService:Create(Toggle, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                        BackgroundColor3 = Color3.fromRGB(44, 44, 52)
                    }):Play()

                    TweenService:Create(Circle, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                        BackgroundColor3 = Color3.fromRGB(120, 120, 132),
                        Position = UDim2.fromScale(0, 0.5)
                    }):Play()
                end

                Library._config._flags[settings.flag] = self._state
                Config:save(game.GameId, Library._config)

                settings.callback(self._state)
            end
            
            function ModuleManager:connect_keybind()
                if not Library._config._keybinds[settings.flag] then
                    return
                end

                Connections[settings.flag..'_keybind'] = UserInputService.InputBegan:Connect(function(input: InputObject, process: boolean)
                    if process then
                        return
                    end
                    
                    if tostring(input.KeyCode) ~= Library._config._keybinds[settings.flag] then
                        return
                    end
                    
                    self:change_state(not self._state)
                end)
            end

            function ModuleManager:scale_keybind(empty: boolean)
                if Library._config._keybinds[settings.flag] and not empty then
                    local keybind_string = string.gsub(tostring(Library._config._keybinds[settings.flag]), 'Enum.KeyCode.', '')

                    local font_params = Instance.new('GetTextBoundsParams')
                    font_params.Text = keybind_string
                    font_params.Font = Font.new('rbxasset://fonts/families/Montserrat.json', Enum.FontWeight.Bold)
                    font_params.Size = 10
                    font_params.Width = 10000
            
                    local font_size = TextService:GetTextBoundsAsync(font_params)
                    
                    Keybind.Size = UDim2.fromOffset(font_size.X + 6, 15)
                    TextLabel.Size = UDim2.fromOffset(font_size.X, 13)
                else
                    Keybind.Size = UDim2.fromOffset(31, 15)
                    TextLabel.Size = UDim2.fromOffset(25, 13)
                end
            end

            if Library:flag_type(settings.flag, 'boolean') then
                ModuleManager._state = true
                pcall(function()
                    settings.callback(ModuleManager._state)
                end)

                Toggle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Circle.Position = UDim2.fromScale(0.53, 0.5)
            end

            if Library._config._keybinds[settings.flag] then
                local keybind_string = string.gsub(tostring(Library._config._keybinds[settings.flag]), 'Enum.KeyCode.', '')
                TextLabel.Text = keybind_string

                ModuleManager:connect_keybind()
                ModuleManager:scale_keybind()
            end

            Connections[settings.flag..'_input_began'] = Header.InputBegan:Connect(function(input: InputObject)
                if Library._choosing_keybind then
                    return
                end

                if input.UserInputType ~= Enum.UserInputType.MouseButton3 then
                    return
                end
                
                Library._choosing_keybind = true
                
                Connections['keybind_choose_start'] = UserInputService.InputBegan:Connect(function(input: InputObject, process: boolean)
                    if process then
                        return
                    end
                    
                    if input == Enum.UserInputState or input == Enum.UserInputType then
                        return
                    end

                    if input.KeyCode == Enum.KeyCode.Unknown then
                        return
                    end

                    if input.KeyCode == Enum.KeyCode.Backspace then
                        ModuleManager:scale_keybind(true)

                        Library._config._keybinds[settings.flag] = nil
                        Config:save(game.GameId, Library._config)

                        TextLabel.Text = 'None'
                        
                        if Connections[settings.flag..'_keybind'] then
                            Connections[settings.flag..'_keybind']:Disconnect()
                            Connections[settings.flag..'_keybind'] = nil
                        end

                        Connections['keybind_choose_start']:Disconnect()
                        Connections['keybind_choose_start'] = nil

                        Library._choosing_keybind = false

                        return
                    end
                    
                    Connections['keybind_choose_start']:Disconnect()
                    Connections['keybind_choose_start'] = nil
                    
                    Library._config._keybinds[settings.flag] = tostring(input.KeyCode)
                    Config:save(game.GameId, Library._config)

                    if Connections[settings.flag..'_keybind'] then
                        Connections[settings.flag..'_keybind']:Disconnect()
                        Connections[settings.flag..'_keybind'] = nil
                    end

                    ModuleManager:connect_keybind()
                    ModuleManager:scale_keybind()
                    
                    Library._choosing_keybind = false

                    local keybind_string = string.gsub(tostring(Library._config._keybinds[settings.flag]), 'Enum.KeyCode.', '')
                    TextLabel.Text = keybind_string
                end)
            end)

            Header.MouseButton1Click:Connect(function()
                ModuleManager:change_state(not ModuleManager._state)
            end)

            function ModuleManager:create_paragraph(settings: any)
                LayoutOrderModule = LayoutOrderModule + 1;

                local ParagraphManager = {}
                
                if self._size == 0 then
                    self._size = 11
                end
            
                self._size += settings.customScale or 70
            
                if ModuleManager._state then
                    Module.Size = UDim2.fromOffset(241, 93 + self._size)
                end
            
                Options.Size = UDim2.fromOffset(241, self._size)
            
                local Paragraph = Instance.new('Frame')
                Paragraph.BackgroundColor3 = Color3.fromRGB(22, 22, 27)
                Paragraph.BackgroundTransparency = 0.15
                Paragraph.Size = UDim2.new(0, 207, 0, 30) 
                Paragraph.BorderSizePixel = 0
                Paragraph.Name = "Paragraph"
                Paragraph.AutomaticSize = Enum.AutomaticSize.Y 
                Paragraph.Parent = Options
                Paragraph.LayoutOrder = LayoutOrderModule;
            
                local UICorner = Instance.new('UICorner')
                UICorner.CornerRadius = UDim.new(0, 7)
                UICorner.Parent = Paragraph
            

                local Title = Instance.new('TextLabel')
                Title.FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
                Title.TextColor3 = Color3.fromRGB(255, 255, 255)
                Title.Text = settings.title or "Title"
                Title.Size = UDim2.new(1, -10, 0, 20)
                Title.Position = UDim2.new(0, 5, 0, 5)
                Title.BackgroundTransparency = 1
                Title.TextXAlignment = Enum.TextXAlignment.Left
                Title.TextYAlignment = Enum.TextYAlignment.Center
                Title.TextSize = 12
                Title.AutomaticSize = Enum.AutomaticSize.XY
                Title.Parent = Paragraph
            
                local Body = Instance.new('TextLabel')
                Body.FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.Regular, Enum.FontStyle.Normal)
                Body.TextColor3 = Color3.fromRGB(255, 255, 255)
                
                if not settings.rich then
                    Body.Text = settings.text or "Skibidi"
                else
                    Body.RichText = true
                    Body.Text = settings.richtext or "<font color='rgb(255,0,0)'>Azure</font> user"
                end
                
                Body.Size = UDim2.new(1, -10, 0, 20)
                Body.Position = UDim2.new(0, 5, 0, 30)
                Body.BackgroundTransparency = 1
                Body.TextXAlignment = Enum.TextXAlignment.Left
                Body.TextYAlignment = Enum.TextYAlignment.Top
                Body.TextSize = 11
                Body.TextWrapped = true
                Body.AutomaticSize = Enum.AutomaticSize.XY
                Body.Parent = Paragraph
            
                Paragraph.MouseEnter:Connect(function()
                    TweenService:Create(Paragraph, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                        BackgroundColor3 = Color3.fromRGB(34, 34, 42)
                    }):Play()
                end)
            
                Paragraph.MouseLeave:Connect(function()
                    TweenService:Create(Paragraph, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                        BackgroundColor3 = Color3.fromRGB(24, 24, 30)
                    }):Play()
                end)

                return ParagraphManager
            end

            function ModuleManager:create_text(settings: any)
                LayoutOrderModule = LayoutOrderModule + 1
            
                local TextManager = {}
            
                if self._size == 0 then
                    self._size = 11
                end
            
                self._size += settings.customScale or 50 
            
                if ModuleManager._state then
                    Module.Size = UDim2.fromOffset(241, 93 + self._size)
                end
            
                Options.Size = UDim2.fromOffset(241, self._size)
            
                local TextFrame = Instance.new('Frame')
                TextFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 27)
                TextFrame.BackgroundTransparency = 0.15
                TextFrame.Size = UDim2.new(0, 207, 0, settings.CustomYSize) 
                TextFrame.BorderSizePixel = 0
                TextFrame.Name = "Text"
                TextFrame.AutomaticSize = Enum.AutomaticSize.Y 
                TextFrame.Parent = Options
                TextFrame.LayoutOrder = LayoutOrderModule
            
                local UICorner = Instance.new('UICorner')
                UICorner.CornerRadius = UDim.new(0, 7)
                UICorner.Parent = TextFrame
            
                local Body = Instance.new('TextLabel')
                Body.FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.Regular, Enum.FontStyle.Normal)
                Body.TextColor3 = Color3.fromRGB(255, 255, 255)
            
                if not settings.rich then
                    Body.Text = settings.text or "Skibidi" 
                else
                    Body.RichText = true
                    Body.Text = settings.richtext or "<font color='rgb(255,0,0)'>Azure</font> user" 
                end
            
                Body.Size = UDim2.new(1, -10, 1, 0)
                Body.Position = UDim2.new(0, 5, 0, 5)
                Body.BackgroundTransparency = 1
                Body.TextXAlignment = Enum.TextXAlignment.Left
                Body.TextYAlignment = Enum.TextYAlignment.Top
                Body.TextSize = 10
                Body.TextWrapped = true
                Body.AutomaticSize = Enum.AutomaticSize.XY
                Body.Parent = TextFrame
            
                TextFrame.MouseEnter:Connect(function()
                    TweenService:Create(TextFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                        BackgroundColor3 = Color3.fromRGB(34, 34, 42)
                    }):Play()
                end)
            
                TextFrame.MouseLeave:Connect(function()
                    TweenService:Create(TextFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                        BackgroundColor3 = Color3.fromRGB(24, 24, 30)
                    }):Play()
                end)

                function TextManager:Set(new_settings)
                    if not new_settings.rich then
                        Body.Text = new_settings.text or "Skibidi" 
                    else
                        Body.RichText = true
                        Body.Text = new_settings.richtext or "<font color='rgb(255,0,0)'>Azure</font> user"
                    end
                end;
            
                return TextManager
            end
            function ModuleManager:create_textbox(settings: any)
                LayoutOrderModule = LayoutOrderModule + 1
            
                local TextboxManager = {
                    _text = ""
                }
            
                if self._size == 0 then
                    self._size = 11
                end
            
                self._size += 32
            
                if ModuleManager._state then
                    Module.Size = UDim2.fromOffset(241, 93 + self._size)
                end
            
                Options.Size = UDim2.fromOffset(241, self._size)
            
                local Label = Instance.new('TextLabel')
                Label.FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
                Label.TextColor3 = Color3.fromRGB(255, 255, 255)
                Label.TextTransparency = 0.2
                Label.Text = settings.title or "Enter text"
                Label.Size = UDim2.new(0, 207, 0, 13)
                Label.AnchorPoint = Vector2.new(0, 0)
                Label.Position = UDim2.new(0, 0, 0, 0)
                Label.BackgroundTransparency = 1
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.BorderSizePixel = 0
                Label.Parent = Options
                Label.TextSize = 10;
                Label.LayoutOrder = LayoutOrderModule
            
                local Textbox = Instance.new('TextBox')
                Textbox.FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.Regular, Enum.FontStyle.Normal)
                Textbox.TextColor3 = Color3.fromRGB(255, 255, 255)
                Textbox.BorderColor3 = Color3.fromRGB(0, 0, 0)
                Textbox.PlaceholderText = settings.placeholder or "Enter text..."
                Textbox.Text = Library._config._flags[settings.flag] or ""
                Textbox.Name = 'Textbox'
                Textbox.Size = UDim2.new(0, 207, 0, 15)
                Textbox.BorderSizePixel = 0
                Textbox.TextSize = 10
                Textbox.BackgroundColor3 = Color3.fromRGB(26, 26, 32)
                Textbox.BackgroundTransparency = 0.85
                Textbox.ClearTextOnFocus = false
                Textbox.Parent = Options
                Textbox.LayoutOrder = LayoutOrderModule
            
                local UICorner = Instance.new('UICorner')
                UICorner.CornerRadius = UDim.new(0, 7)
                UICorner.Parent = Textbox
            
                function TextboxManager:update_text(text: string)
                    self._text = text
                    Library._config._flags[settings.flag] = self._text
                    Config:save(game.GameId, Library._config)
                    settings.callback(self._text)
                end
            
                if Library:flag_type(settings.flag, 'string') then
                    TextboxManager:update_text(Library._config._flags[settings.flag])
                end
            
                Textbox.FocusLost:Connect(function()
                    TextboxManager:update_text(Textbox.Text)
                end)
            
                return TextboxManager
            end   

            function ModuleManager:create_checkbox(settings: any)
                LayoutOrderModule = LayoutOrderModule + 1
                local CheckboxManager = { _state = false }
            
                if self._size == 0 then
                    self._size = 11
                end
                self._size += 20
            
                if ModuleManager._state then
                    Module.Size = UDim2.fromOffset(241, 93 + self._size)
                end
                Options.Size = UDim2.fromOffset(241, self._size)
            
                local Checkbox = Instance.new("TextButton")
                Checkbox.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
                Checkbox.TextColor3 = Color3.fromRGB(255, 255, 255)
                Checkbox.BorderColor3 = Color3.fromRGB(0, 0, 0)
                Checkbox.Text = ""
                Checkbox.AutoButtonColor = false
                Checkbox.BackgroundTransparency = 1
                Checkbox.Name = "Checkbox"
                Checkbox.Size = UDim2.new(0, 207, 0, 15)
                Checkbox.BorderSizePixel = 0
                Checkbox.TextSize = 14
                Checkbox.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                Checkbox.Parent = Options
                Checkbox.LayoutOrder = LayoutOrderModule
            
                local TitleLabel = Instance.new("TextLabel")
                TitleLabel.Name = "TitleLabel"
                if SelectedLanguage == "th" then
                    TitleLabel.FontFace = Font.new("rbxasset://fonts/families/NotoSansThai.json", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
                    TitleLabel.TextSize = 13
                else
                    TitleLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
                    TitleLabel.TextSize = 11
                end
                TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                TitleLabel.TextTransparency = 0.2
                TitleLabel.Text = settings.title or "Skibidi"
                TitleLabel.Size = UDim2.new(0, 142, 0, 13)
                TitleLabel.AnchorPoint = Vector2.new(0, 0.5)
                TitleLabel.Position = UDim2.new(0, 0, 0.5, 0)
                TitleLabel.BackgroundTransparency = 1
                TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
                TitleLabel.Parent = Checkbox

                local KeybindBox = Instance.new("Frame")
                KeybindBox.Name = "KeybindBox"
                KeybindBox.Size = UDim2.fromOffset(14, 14)
                KeybindBox.Position = UDim2.new(1, -35, 0.5, 0)
                KeybindBox.AnchorPoint = Vector2.new(0, 0.5)
                KeybindBox.BackgroundColor3 = Color3.fromRGB(245, 245, 250)
                KeybindBox.BorderSizePixel = 0
                KeybindBox.Parent = Checkbox
            
                local KeybindCorner = Instance.new("UICorner")
                KeybindCorner.CornerRadius = UDim.new(0, 7)
                KeybindCorner.Parent = KeybindBox
            
                local KeybindLabel = Instance.new("TextLabel")
                KeybindLabel.Name = "KeybindLabel"
                KeybindLabel.Size = UDim2.new(1, 0, 1, 0)
                KeybindLabel.BackgroundTransparency = 1
                KeybindLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                KeybindLabel.TextScaled = false
                KeybindLabel.TextSize = 10
                KeybindLabel.Font = Enum.Font.SourceSans
                KeybindLabel.Text = Library._config._keybinds[settings.flag] 
                    and string.gsub(tostring(Library._config._keybinds[settings.flag]), "Enum.KeyCode.", "") 
                    or "..."
                KeybindLabel.Parent = KeybindBox
            
                local Box = Instance.new("Frame")
                Box.BorderColor3 = Color3.fromRGB(0, 0, 0)
                Box.AnchorPoint = Vector2.new(1, 0.5)
                Box.BackgroundTransparency = 0.9
                Box.Position = UDim2.new(1, 0, 0.5, 0)
                Box.Name = "Box"
                Box.Size = UDim2.new(0, 15, 0, 15)
                Box.BorderSizePixel = 0
                Box.BackgroundColor3 = Color3.fromRGB(245, 245, 250)
                Box.Parent = Checkbox
            
                local BoxCorner = Instance.new("UICorner")
                BoxCorner.CornerRadius = UDim.new(0, 7)
                BoxCorner.Parent = Box
            
                local Fill = Instance.new("Frame")
                Fill.AnchorPoint = Vector2.new(0.5, 0.5)
                Fill.BackgroundTransparency = 0.2
                Fill.Position = UDim2.new(0.5, 0, 0.5, 0)
                Fill.BorderColor3 = Color3.fromRGB(0, 0, 0)
                Fill.Name = "Fill"
                Fill.BorderSizePixel = 0
                Fill.BackgroundColor3 = Color3.fromRGB(245, 245, 250)
                Fill.Size = UDim2.fromOffset(0, 0)
                Fill.Parent = Box
            
                local FillCorner = Instance.new("UICorner")
                FillCorner.CornerRadius = UDim.new(0, 6)
                FillCorner.Parent = Fill
            
                function CheckboxManager:change_state(state: boolean)
                    self._state = state
                    if self._state then
                        TweenService:Create(Box, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                            BackgroundTransparency = 0.7
                        }):Play()
                        TweenService:Create(Fill, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                            Size = UDim2.fromOffset(9, 9)
                        }):Play()
                    else
                        TweenService:Create(Box, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                            BackgroundTransparency = 0.9
                        }):Play()
                        TweenService:Create(Fill, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                            Size = UDim2.fromOffset(0, 0)
                        }):Play()
                    end
                    Library._config._flags[settings.flag] = self._state
                    Config:save(game.GameId, Library._config)
                    settings.callback(self._state)
                end
            
                if Library:flag_type(settings.flag, "boolean") then
                    CheckboxManager:change_state(Library._config._flags[settings.flag])
                end
            
                Checkbox.MouseButton1Click:Connect(function()
                    CheckboxManager:change_state(not CheckboxManager._state)
                end)
            
                Checkbox.InputBegan:Connect(function(input, gameProcessed)
                    if gameProcessed then return end
                    if input.UserInputType ~= Enum.UserInputType.MouseButton3 then return end
                    if Library._choosing_keybind then return end
            
                    Library._choosing_keybind = true
                    local chooseConnection
                    chooseConnection = UserInputService.InputBegan:Connect(function(keyInput, processed)
                        if processed then return end
                        if keyInput.UserInputType ~= Enum.UserInputType.Keyboard then return end
                        if keyInput.KeyCode == Enum.KeyCode.Unknown then return end
            
                        if keyInput.KeyCode == Enum.KeyCode.Backspace then
                            ModuleManager:scale_keybind(true)
                            Library._config._keybinds[settings.flag] = nil
                            Config:save(game.GameId, Library._config)
                            KeybindLabel.Text = "..."
                            if Connections[settings.flag .. "_keybind"] then
                                Connections[settings.flag .. "_keybind"]:Disconnect()
                                Connections[settings.flag .. "_keybind"] = nil
                            end
                            chooseConnection:Disconnect()
                            Library._choosing_keybind = false
                            return
                        end
            
                        chooseConnection:Disconnect()
                        Library._config._keybinds[settings.flag] = tostring(keyInput.KeyCode)
                        Config:save(game.GameId, Library._config)
                        if Connections[settings.flag .. "_keybind"] then
                            Connections[settings.flag .. "_keybind"]:Disconnect()
                            Connections[settings.flag .. "_keybind"] = nil
                        end
                        ModuleManager:connect_keybind()
                        ModuleManager:scale_keybind()
                        Library._choosing_keybind = false
            
                        local keybind_string = string.gsub(tostring(Library._config._keybinds[settings.flag]), "Enum.KeyCode.", "")
                        KeybindLabel.Text = keybind_string
                    end)
                end)
            
                local keyPressConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
                    if gameProcessed then return end
                    if input.UserInputType == Enum.UserInputType.Keyboard then
                        local storedKey = Library._config._keybinds[settings.flag]
                        if storedKey and tostring(input.KeyCode) == storedKey then
                            CheckboxManager:change_state(not CheckboxManager._state)
                        end
                    end
                end)
                Connections[settings.flag .. "_keypress"] = keyPressConnection
            
                return CheckboxManager
            end

function ModuleManager:create_button(settings: any)
    LayoutOrderModule = LayoutOrderModule + 1
    
    if self._size == 0 then
        self._size = 11
    end
    self._size += 20

    if ModuleManager._state then
        Module.Size = UDim2.fromOffset(241, 93 + self._size)
    end
    Options.Size = UDim2.fromOffset(241, self._size)

    local Button = Instance.new("TextButton")
    Button.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextTransparency = 0.2
    Button.Text = settings.title or "Button"
    Button.AutoButtonColor = true
    Button.BackgroundTransparency = 0.2
    Button.BackgroundColor3 = Color3.fromRGB(22, 22, 27)
    Button.Name = "Button"
    Button.Size = UDim2.new(0, 207, 0, 20)
    Button.BorderSizePixel = 0
    Button.TextSize = 11
    Button.Parent = Options
    Button.LayoutOrder = LayoutOrderModule

    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 4)
    ButtonCorner.Parent = Button

    Button.MouseButton1Click:Connect(function()
        if settings.callback then
            settings.callback()
        end
    end)

    return Button
end

function ModuleManager:create_divider(settings: any)
    LayoutOrderModule = LayoutOrderModule + 1

    if self._size == 0 then
        self._size = 11
    end

    self._size += 27

    if ModuleManager._state then
        Module.Size = UDim2.fromOffset(241, 93 + self._size)
    end

    local dividerHeight = 1
    local dividerWidth = 207

    local OuterFrame = Instance.new('Frame')
    OuterFrame.Size = UDim2.new(0, dividerWidth, 0, 20)
    OuterFrame.BackgroundTransparency = 1
    OuterFrame.Name = 'OuterFrame'
    OuterFrame.Parent = Options
    OuterFrame.LayoutOrder = LayoutOrderModule

    if settings and settings.showtopic then
        local TextLabel = Instance.new('TextLabel')
        TextLabel.FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
        TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        TextLabel.TextTransparency = 0
        TextLabel.Text = settings.title
        TextLabel.Size = UDim2.new(0, 153, 0, 13)
        TextLabel.Position = UDim2.new(0.5, 0, 0.501, 0)
        TextLabel.BackgroundTransparency = 1
        TextLabel.TextXAlignment = Enum.TextXAlignment.Center
        TextLabel.BorderSizePixel = 0
        TextLabel.AnchorPoint = Vector2.new(0.5, 0.5)
        TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
        TextLabel.TextSize = 11
        TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        TextLabel.ZIndex = 3
        TextLabel.TextStrokeTransparency = 0
        TextLabel.Parent = OuterFrame
    end

    if not settings or (settings and not settings.disableline) then
        local Divider = Instance.new('Frame')
        Divider.Size = UDim2.new(1, 0, 0, dividerHeight)
        Divider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Divider.BorderSizePixel = 0
        Divider.Name = 'Divider'
        Divider.Parent = OuterFrame
        Divider.ZIndex = 2
        Divider.Position = UDim2.new(0, 0, 0.5, -dividerHeight / 2)

        local Gradient = Instance.new('UIGradient')
        Gradient.Parent = Divider
        Gradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
        })
        Gradient.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.5, 0),
            NumberSequenceKeypoint.new(1, 1)
        })
        Gradient.Rotation = 0

        local UICorner = Instance.new('UICorner')
        UICorner.CornerRadius = UDim.new(0, 2)
        UICorner.Parent = Divider
    end

    return true
end

function ModuleManager:create_slider(settings: any)
    LayoutOrderModule = LayoutOrderModule + 1

    local SliderManager = {}

    if self._size == 0 then
        self._size = 11
    end

    self._size += 27

    if ModuleManager._state then
        Module.Size = UDim2.fromOffset(241, 93 + self._size)
    end

    Options.Size = UDim2.fromOffset(241, self._size)

    local Slider = Instance.new('TextButton')
    Slider.FontFace = Font.new('rbxasset://fonts/families/SourceSansPro.json', Enum.FontWeight.Regular, Enum.FontStyle.Normal)
    Slider.TextSize = 14
    Slider.TextColor3 = Color3.fromRGB(255, 255, 255)
    Slider.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Slider.Text = ''
    Slider.AutoButtonColor = false
    Slider.BackgroundTransparency = 1
    Slider.Name = 'Slider'
    Slider.Size = UDim2.new(0, 207, 0, 22)
    Slider.BorderSizePixel = 0
    Slider.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Slider.Parent = Options
    Slider.LayoutOrder = LayoutOrderModule

    local TextLabel = Instance.new('TextLabel')
    if GG.SelectedLanguage == "th" then
        TextLabel.FontFace = Font.new("rbxasset://fonts/families/NotoSansThai.json", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
        TextLabel.TextSize = 13
    else
        TextLabel.FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
        TextLabel.TextSize = 11
    end
    TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextLabel.TextTransparency = 0.2
    TextLabel.Text = settings.title
    TextLabel.Size = UDim2.new(0, 153, 0, 13)
    TextLabel.Position = UDim2.new(0, 0, 0.05, 0)
    TextLabel.BackgroundTransparency = 1
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel.BorderSizePixel = 0
    TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
    TextLabel.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    TextLabel.Parent = Slider

    local Drag = Instance.new('Frame')
    Drag.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Drag.AnchorPoint = Vector2.new(0.5, 1)
    Drag.BackgroundTransparency = 0.7
    Drag.Position = UDim2.new(0.5, 0, 0.95, 0)
    Drag.Name = 'Drag'
    Drag.Size = UDim2.new(0, 207, 0, 4)
    Drag.BorderSizePixel = 0
    Drag.BackgroundColor3 = Color3.fromRGB(34, 34, 40)
    Drag.Parent = Slider

    local UICorner = Instance.new('UICorner')
    UICorner.CornerRadius = UDim.new(1, 0)
    UICorner.Parent = Drag

    local Fill = Instance.new('Frame')
    Fill.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Fill.AnchorPoint = Vector2.new(0, 0.5)
    Fill.BackgroundTransparency = 0.15
    Fill.Position = UDim2.new(0, 0, 0.5, 0)
    Fill.Name = 'Fill'
    Fill.Size = UDim2.new(0, 103, 0, 4)
    Fill.BorderSizePixel = 0
    Fill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Fill.Parent = Drag

    local UICorner = Instance.new('UICorner')
    UICorner.CornerRadius = UDim.new(0, 3)
    UICorner.Parent = Fill

    local UIGradient = Instance.new('UIGradient')
    UIGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(190, 190, 220))
    }
    UIGradient.Parent = Fill

    local Circle = Instance.new('Frame')
    Circle.AnchorPoint = Vector2.new(1, 0.5)
    Circle.Name = 'Circle'
    Circle.Position = UDim2.new(1, 0, 0.5, 0)
    Circle.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Circle.Size = UDim2.new(0, 6, 0, 6)
    Circle.BorderSizePixel = 0
    Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Circle.Parent = Fill

    local UICorner = Instance.new('UICorner')
    UICorner.CornerRadius = UDim.new(1, 0)
    UICorner.Parent = Circle

    local Value = Instance.new('TextLabel')
    Value.FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
    Value.TextColor3 = Color3.fromRGB(255, 255, 255)
    Value.TextTransparency = 0.2
    Value.Text = '50'
    Value.Name = 'Value'
    Value.Size = UDim2.new(0, 42, 0, 13)
    Value.AnchorPoint = Vector2.new(1, 0)
    Value.Position = UDim2.new(1, 0, 0, 0)
    Value.BackgroundTransparency = 1
    Value.TextXAlignment = Enum.TextXAlignment.Right
    Value.BorderSizePixel = 0
    Value.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Value.TextSize = 10
    Value.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Value.Parent = Slider

    function SliderManager:set_percentage(percentage: number)
        local rounded_number = 0

        if settings.round_number then
            rounded_number = math.floor(percentage)
        else
            rounded_number = math.floor(percentage * 10) / 10
        end

        percentage = (percentage - settings.minimum_value) / (settings.maximum_value - settings.minimum_value)

        local slider_size = math.clamp(percentage, 0.02, 1) * (Drag.AbsoluteSize.X ~= 0 and Drag.AbsoluteSize.X or Drag.Size.X.Offset)
        local number_threshold = math.clamp(rounded_number, settings.minimum_value, settings.maximum_value)

        Library._config._flags[settings.flag] = number_threshold
        Value.Text = number_threshold

        TweenService:Create(Fill, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            Size = UDim2.fromOffset(slider_size, (Drag.AbsoluteSize.Y ~= 0 and Drag.AbsoluteSize.Y or Drag.Size.Y.Offset))
        }):Play()

        settings.callback(number_threshold)
    end

    function SliderManager:update()
        local success, mouse_location = pcall(function() return UserInputService:GetMouseLocation() end)
        local mouse_x = (success and mouse_location and mouse_location.X) or (Mouse and Mouse.X) or 0
        local drag_width = (Drag.AbsoluteSize and Drag.AbsoluteSize.X) or Drag.Size.X.Offset
        if drag_width == 0 then drag_width = Drag.Size.X.Offset end
        local mouse_position = (mouse_x - Drag.AbsolutePosition.X) / drag_width
        local percentage = settings.minimum_value + (settings.maximum_value - settings.minimum_value) * mouse_position

        self:set_percentage(percentage)
    end

    function SliderManager:input()
        SliderManager:update()

        Connections['slider_drag_'..settings.flag] = UserInputService.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                SliderManager:update()
            end
        end)

        Connections['slider_input_'..settings.flag] = UserInputService.InputEnded:Connect(function(input: InputObject, process: boolean)
            if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then
                return
            end

            Connections:disconnect('slider_drag_'..settings.flag)
            Connections:disconnect('slider_input_'..settings.flag)

            if not settings.ignoresaved then
                Config:save(game.GameId, Library._config)
            end
        end)
    end

    if Library:flag_type(settings.flag, 'number') then
        if not settings.ignoresaved then
            SliderManager:set_percentage(Library._config._flags[settings.flag])
        else
            SliderManager:set_percentage(settings.value)
        end
    else
        SliderManager:set_percentage(settings.value)
    end

    Slider.MouseButton1Down:Connect(function()
        SliderManager:input()
    end)

    return SliderManager
end

function ModuleManager:create_range_slider(settings: any)
    LayoutOrderModule = LayoutOrderModule + 1

    local SliderManager = {}

    if self._size == 0 then
        self._size = 11
    end

    self._size += 27

    if ModuleManager._state then
        Module.Size = UDim2.fromOffset(241, 93 + self._size)
    end

    Options.Size = UDim2.fromOffset(241, self._size)

    local Slider = Instance.new('TextButton')
    Slider.FontFace = Font.new('rbxasset://fonts/families/SourceSansPro.json', Enum.FontWeight.Regular, Enum.FontStyle.Normal)
    Slider.TextSize = 14
    Slider.TextColor3 = Color3.fromRGB(255, 255, 255)
    Slider.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Slider.Text = ''
    Slider.AutoButtonColor = false
    Slider.BackgroundTransparency = 1
    Slider.Name = 'Slider'
    Slider.Size = UDim2.new(0, 207, 0, 22)
    Slider.BorderSizePixel = 0
    Slider.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Slider.Parent = Options
    Slider.LayoutOrder = LayoutOrderModule

    local TextLabel = Instance.new('TextLabel')
    if GG.SelectedLanguage == 'th' then
        TextLabel.FontFace = Font.new('rbxasset://fonts/families/NotoSansThai.json', Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
        TextLabel.TextSize = 13
    else
        TextLabel.FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
        TextLabel.TextSize = 11
    end
    TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextLabel.TextTransparency = 0.2
    TextLabel.Text = settings.title
    TextLabel.Size = UDim2.new(0, 153, 0, 13)
    TextLabel.Position = UDim2.new(0, 0, 0.05, 0)
    TextLabel.BackgroundTransparency = 1
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel.BorderSizePixel = 0
    TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
    TextLabel.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    TextLabel.Parent = Slider

    local Drag = Instance.new('Frame')
    Drag.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Drag.AnchorPoint = Vector2.new(0.5, 1)
    Drag.BackgroundTransparency = 0.7
    Drag.Position = UDim2.new(0.5, 0, 0.95, 0)
    Drag.Name = 'Drag'
    Drag.Size = UDim2.new(0, 207, 0, 4)
    Drag.BorderSizePixel = 0
    Drag.BackgroundColor3 = Color3.fromRGB(34, 34, 40)
    Drag.Parent = Slider

    local DragCorner = Instance.new('UICorner')
    DragCorner.CornerRadius = UDim.new(1, 0)
    DragCorner.Parent = Drag

    local RangeFill = Instance.new('Frame')
    RangeFill.BorderColor3 = Color3.fromRGB(0, 0, 0)
    RangeFill.AnchorPoint = Vector2.new(0, 0.5)
    RangeFill.BackgroundTransparency = 0.15
    RangeFill.Position = UDim2.new(0, 0, 0.5, 0)
    RangeFill.Name = 'RangeFill'
    RangeFill.Size = UDim2.new(0, 0, 1, 0)
    RangeFill.BorderSizePixel = 0
    RangeFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    RangeFill.Parent = Drag

    local RangeCorner = Instance.new('UICorner')
    RangeCorner.CornerRadius = UDim.new(1, 0)
    RangeCorner.Parent = RangeFill

    local MinHandle = Instance.new('Frame')
    MinHandle.AnchorPoint = Vector2.new(0.5, 0.5)
    MinHandle.Name = 'MinHandle'
    MinHandle.Size = UDim2.new(0, 6, 0, 6)
    MinHandle.BorderColor3 = Color3.fromRGB(0, 0, 0)
    MinHandle.BorderSizePixel = 0
    MinHandle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    MinHandle.Parent = Drag

    local MinHandleCorner = Instance.new('UICorner')
    MinHandleCorner.CornerRadius = UDim.new(1, 0)
    MinHandleCorner.Parent = MinHandle

    local MaxHandle = Instance.new('Frame')
    MaxHandle.AnchorPoint = Vector2.new(0.5, 0.5)
    MaxHandle.Name = 'MaxHandle'
    MaxHandle.Size = UDim2.new(0, 6, 0, 6)
    MaxHandle.BorderColor3 = Color3.fromRGB(0, 0, 0)
    MaxHandle.BorderSizePixel = 0
    MaxHandle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    MaxHandle.Parent = Drag

    local MaxHandleCorner = Instance.new('UICorner')
    MaxHandleCorner.CornerRadius = UDim.new(1, 0)
    MaxHandleCorner.Parent = MaxHandle

    local Value = Instance.new('TextLabel')
    Value.FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
    Value.TextColor3 = Color3.fromRGB(255, 255, 255)
    Value.TextTransparency = 0.2
    Value.Text = '1 - 50'
    Value.Name = 'Value'
    Value.Size = UDim2.new(0, 70, 0, 13)
    Value.AnchorPoint = Vector2.new(1, 0)
    Value.Position = UDim2.new(1, 0, 0, 0)
    Value.BackgroundTransparency = 1
    Value.TextXAlignment = Enum.TextXAlignment.Right
    Value.BorderSizePixel = 0
    Value.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Value.TextSize = 10
    Value.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Value.Parent = Slider

    function SliderManager:set_values(min_value, max_value)
        if settings.round_number then
            min_value = math.floor(min_value)
            max_value = math.floor(max_value)
        end

        local min_value = math.clamp(min_value, settings.minimum_value, settings.maximum_value)
        local max_value = math.clamp(max_value, settings.minimum_value, settings.maximum_value)

        if min_value > max_value then
            min_value, max_value = max_value, min_value
        end

        self._min_value = min_value
        self._max_value = max_value

        local range = settings.maximum_value - settings.minimum_value
        local min_percentage = range > 0 and (min_value - settings.minimum_value) / range or 0
        local max_percentage = range > 0 and (max_value - settings.minimum_value) / range or 1
        local selected_width = math.clamp(max_percentage - min_percentage, 0, 1)

        RangeFill.Position = UDim2.new(min_percentage, 0, 0.5, 0)
        RangeFill.Size = UDim2.new(selected_width, 0, 1, 0)
        MinHandle.Position = UDim2.new(min_percentage, 0, 0.5, 0)
        MaxHandle.Position = UDim2.new(max_percentage, 0, 0.5, 0)
        Value.Text = tostring(min_value) .. ' - ' .. tostring(max_value)

        Library._config._flags[settings.flag] = {min = min_value, max = max_value}
        if settings.callback then
            settings.callback(min_value, max_value)
        end
    end

    function SliderManager:update(active_handle)
        local success, mouse_location = pcall(function() return UserInputService:GetMouseLocation() end)
        local mouse_x = (success and mouse_location and mouse_location.X) or (Mouse and Mouse.X) or 0
        local drag_width = (Drag.AbsoluteSize and Drag.AbsoluteSize.X) or Drag.Size.X.Offset
        if drag_width == 0 then drag_width = Drag.Size.X.Offset end
        local click_position = (mouse_x - Drag.AbsolutePosition.X) / drag_width
        local percentage = settings.minimum_value + (settings.maximum_value - settings.minimum_value) * click_position

        if active_handle == 'min' then
            self:set_values(percentage, self._max_value)
        else
            self:set_values(self._min_value, percentage)
        end
    end

    function SliderManager:input()
        local success, mouse_location = pcall(function() return UserInputService:GetMouseLocation() end)
        local mouse_x = (success and mouse_location and mouse_location.X) or (Mouse and Mouse.X) or 0
        local drag_width = (Drag.AbsoluteSize and Drag.AbsoluteSize.X) or Drag.Size.X.Offset
        if drag_width == 0 then drag_width = Drag.Size.X.Offset end
        local click_position = (mouse_x - Drag.AbsolutePosition.X) / drag_width
        local middle = (self._min_value + self._max_value) / 2
        local min_percentage = (self._min_value - settings.minimum_value) / (settings.maximum_value - settings.minimum_value)
        local max_percentage = (self._max_value - settings.minimum_value) / (settings.maximum_value - settings.minimum_value)
        local click_to_min = math.abs(click_position - min_percentage)
        local click_to_max = math.abs(click_position - max_percentage)
        self._active_handle = click_to_min < click_to_max and 'min' or 'max'

        Connections['slider_drag_'..settings.flag] = UserInputService.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                SliderManager:update(self._active_handle)
            end
        end)

        Connections['slider_input_'..settings.flag] = UserInputService.InputEnded:Connect(function(input: InputObject, process: boolean)
            if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then
                return
            end

            Connections:disconnect('slider_drag_'..settings.flag)
            Connections:disconnect('slider_input_'..settings.flag)

            if not settings.ignoresaved then
                Config:save(game.GameId, Library._config)
            end
        end)
    end

    local saved = Library._config._flags[settings.flag]
    if type(saved) == 'table' and saved.min and saved.max then
        SliderManager:set_values(saved.min, saved.max)
    else
        SliderManager:set_values(settings.value.min, settings.value.max)
    end

    Slider.MouseButton1Down:Connect(function()
        SliderManager:input()
    end)

    return SliderManager
end

function ModuleManager:create_dropdown(settings: any)
    if not settings.Order then
        LayoutOrderModule = LayoutOrderModule + 1
    end

    local DropdownManager = {
        _state = false,
        _size = 0
    }

    if not settings.Order then
        if self._size == 0 then
            self._size = 11
        end

        self._size += 44
    end

    if not settings.Order then
        if ModuleManager._state then
            Module.Size = UDim2.fromOffset(241, 93 + self._size)
        end
        Options.Size = UDim2.fromOffset(241, self._size)
    end

    local Dropdown = Instance.new('TextButton')
    Dropdown.FontFace = Font.new('rbxasset://fonts/families/SourceSansPro.json', Enum.FontWeight.Regular, Enum.FontStyle.Normal)
    Dropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
    Dropdown.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Dropdown.Text = ''
    Dropdown.AutoButtonColor = false
    Dropdown.BackgroundTransparency = 1
    Dropdown.Name = 'Dropdown'
    Dropdown.Size = UDim2.new(0, 207, 0, 39)
    Dropdown.BorderSizePixel = 0
    Dropdown.TextSize = 14
    Dropdown.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Dropdown.Parent = Options

    if not settings.Order then
        Dropdown.LayoutOrder = LayoutOrderModule
    else
        Dropdown.LayoutOrder = settings.OrderValue
    end

    if not Library._config._flags[settings.flag] then
        Library._config._flags[settings.flag] = {}
    end

    local TextLabel = Instance.new('TextLabel')
    if GG.SelectedLanguage == "th" then
        TextLabel.FontFace = Font.new("rbxasset://fonts/families/NotoSansThai.json", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
        TextLabel.TextSize = 13
    else
        TextLabel.FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
        TextLabel.TextSize = 11
    end
    TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextLabel.TextTransparency = 0.2
    TextLabel.Text = settings.title
    TextLabel.Size = UDim2.new(0, 207, 0, 13)
    TextLabel.BackgroundTransparency = 1
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel.BorderSizePixel = 0
    TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
    TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TextLabel.Parent = Dropdown

    local Box = Instance.new('Frame')
    Box.ClipsDescendants = true
    Box.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Box.AnchorPoint = Vector2.new(0.5, 0)
    Box.BackgroundTransparency = 0.9
    Box.Position = UDim2.new(0.5, 0, 1.2, 0)
    Box.Name = 'Box'
    Box.Size = UDim2.new(0, 207, 0, 22)
    Box.BorderSizePixel = 0
    Box.BackgroundColor3 = Color3.fromRGB(245, 245, 250)
    Box.Parent = TextLabel

    local UICorner = Instance.new('UICorner')
    UICorner.CornerRadius = UDim.new(0, 4)
    UICorner.Parent = Box

    local Header = Instance.new('Frame')
    Header.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Header.AnchorPoint = Vector2.new(0.5, 0)
    Header.BackgroundTransparency = 1
    Header.Position = UDim2.new(0.5, 0, 0, 0)
    Header.Name = 'Header'
    Header.Size = UDim2.new(0, 207, 0, 22)
    Header.BorderSizePixel = 0
    Header.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Header.Parent = Box

    local CurrentOption = Instance.new('TextLabel')
    CurrentOption.FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
    CurrentOption.TextColor3 = Color3.fromRGB(255, 255, 255)
    CurrentOption.TextTransparency = 0.2
    CurrentOption.Name = 'CurrentOption'
    CurrentOption.Size = UDim2.new(0, 161, 0, 13)
    CurrentOption.AnchorPoint = Vector2.new(0, 0.5)
    CurrentOption.Position = UDim2.new(0.05, 0, 0.5, 0)
    CurrentOption.BackgroundTransparency = 1
    CurrentOption.TextXAlignment = Enum.TextXAlignment.Left
    CurrentOption.BorderSizePixel = 0
    CurrentOption.BorderColor3 = Color3.fromRGB(0, 0, 0)
    CurrentOption.TextSize = 10
    CurrentOption.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    CurrentOption.Parent = Header

    local UIGradient = Instance.new('UIGradient')
    UIGradient.Transparency = NumberSequence.new{
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(0.704, 0),
        NumberSequenceKeypoint.new(0.872, 0.3625),
        NumberSequenceKeypoint.new(1, 1)
    }
    UIGradient.Parent = CurrentOption

    local Arrow = Instance.new('ImageLabel')
    Arrow.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Arrow.AnchorPoint = Vector2.new(0, 0.5)
    Arrow.Image = 'rbxassetid://84232453189324'
    Arrow.BackgroundTransparency = 1
    Arrow.Position = UDim2.new(0.91, 0, 0.5, 0)
    Arrow.Name = 'Arrow'
    Arrow.Size = UDim2.new(0, 8, 0, 8)
    Arrow.BorderSizePixel = 0
    Arrow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Arrow.ImageColor3 = Color3.fromRGB(255, 255, 255)
    Arrow.Parent = Header

    local Options = Instance.new('ScrollingFrame')
    Options.ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0)
    Options.Active = true
    Options.ScrollBarImageTransparency = 1
    Options.AutomaticCanvasSize = Enum.AutomaticSize.XY
    Options.ScrollBarThickness = 0
    Options.Name = 'Options'
    Options.Size = UDim2.new(0, 207, 0, 0)
    Options.BackgroundTransparency = 1
    Options.Position = UDim2.new(0, 0, 1, 0)
    Options.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Options.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Options.BorderSizePixel = 0
    Options.CanvasSize = UDim2.new(0, 0, 0.5, 0)
    Options.Parent = Box

    local UIListLayout = Instance.new('UIListLayout')
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Parent = Options

    local UIPadding = Instance.new('UIPadding')
    UIPadding.PaddingTop = UDim.new(0, -1)
    UIPadding.PaddingLeft = UDim.new(0, 10)
    UIPadding.Parent = Options

    local UIListLayout = Instance.new('UIListLayout')
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Parent = Box

    function DropdownManager:update(option: string)
        if settings.multi_dropdown then
            if not Library._config._flags[settings.flag] then
                Library._config._flags[settings.flag] = {}
            end

            local CurrentTargetValue = nil

            if #Library._config._flags[settings.flag] > 0 then
                CurrentTargetValue = convertTableToString(Library._config._flags[settings.flag])
            end

            local selected = {}

            if CurrentTargetValue then
                for value in string.gmatch(CurrentTargetValue, "([^,]+)") do
                    local trimmedValue = value:match("^%s*(.-)%s*$")
                    if trimmedValue ~= "Label" then
                        table.insert(selected, trimmedValue)
                    end
                end
            else
                for value in string.gmatch(CurrentOption.Text, "([^,]+)") do
                    local trimmedValue = value:match("^%s*(.-)%s*$")
                    if trimmedValue ~= "Label" then
                        table.insert(selected, trimmedValue)
                    end
                end
            end

            local CurrentTextGet = convertStringToTable(CurrentOption.Text)

            local optionSkibidi = typeof(option) ~= 'string' and option.Name or option

            for i, v in pairs(CurrentTextGet) do
                if v == optionSkibidi then
                    table.remove(CurrentTextGet, i)
                    break
                end
            end

            CurrentOption.Text = table.concat(selected, ", ")
            local OptionsChild = {}

            for _, object in Options:GetChildren() do
                if object.Name == "Option" then
                    table.insert(OptionsChild, object.Text)
                    if table.find(selected, object.Text) then
                        object.TextTransparency = 0.2
                    else
                        object.TextTransparency = 0.6
                    end
                end
            end

            CurrentTargetValue = convertStringToTable(CurrentOption.Text)

            for _, v in CurrentTargetValue do
                if not table.find(OptionsChild, v) and table.find(selected, v) then
                    table.remove(selected, _)
                end
            end

            CurrentOption.Text = table.concat(selected, ", ")
            Library._config._flags[settings.flag] = convertStringToTable(CurrentOption.Text)
        else
            CurrentOption.Text = (typeof(option) == "string" and option) or option.Name
            for _, object in Options:GetChildren() do
                if object.Name == "Option" then
                    if object.Text == CurrentOption.Text then
                        object.TextTransparency = 0.2
                    else
                        object.TextTransparency = 0.6
                    end
                end
            end
            Library._config._flags[settings.flag] = option
        end

        Config:save(game.GameId, Library._config)
        settings.callback(option)
    end

    local CurrentDropSizeState = 0

    function DropdownManager:unfold_settings()
        self._state = not self._state

        if self._state then
            ModuleManager._multiplier += self._size
            CurrentDropSizeState = self._size

            TweenService:Create(Module, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Size = UDim2.fromOffset(241, 93 + ModuleManager._size + ModuleManager._multiplier)
            }):Play()

            TweenService:Create(Module.Options, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Size = UDim2.fromOffset(241, ModuleManager._size + ModuleManager._multiplier)
            }):Play()

            TweenService:Create(Dropdown, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Size = UDim2.fromOffset(207, 39 + self._size)
            }):Play()

            TweenService:Create(Box, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Size = UDim2.fromOffset(207, 22 + self._size)
            }):Play()

            TweenService:Create(Arrow, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Rotation = 180
            }):Play()
        else
            ModuleManager._multiplier -= self._size
            CurrentDropSizeState = 0

            TweenService:Create(Module, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Size = UDim2.fromOffset(241, 93 + ModuleManager._size + ModuleManager._multiplier)
            }):Play()

            TweenService:Create(Module.Options, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Size = UDim2.fromOffset(241, ModuleManager._size + ModuleManager._multiplier)
            }):Play()

            TweenService:Create(Dropdown, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Size = UDim2.fromOffset(207, 39)
            }):Play()

            TweenService:Create(Box, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Size = UDim2.fromOffset(207, 22)
            }):Play()

            TweenService:Create(Arrow, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Rotation = 0
            }):Play()
        end
    end

    if #settings.options > 0 then
        DropdownManager._size = 3

        for index, value in settings.options do
            local Option = Instance.new('TextButton')
            Option.FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
            Option.Active = false
            Option.TextTransparency = 0.6
            Option.AnchorPoint = Vector2.new(0, 0.5)
            Option.TextSize = 10
            Option.Size = UDim2.new(0, 186, 0, 16)
            Option.TextColor3 = Color3.fromRGB(255, 255, 255)
            Option.BorderColor3 = Color3.fromRGB(0, 0, 0)
            Option.Text = (typeof(value) == "string" and value) or value.Name
            Option.AutoButtonColor = false
            Option.Name = 'Option'
            Option.BackgroundTransparency = 1
            Option.TextXAlignment = Enum.TextXAlignment.Left
            Option.Selectable = false
            Option.Position = UDim2.new(0.05, 0, 0.3421, 0)
            Option.BorderSizePixel = 0
            Option.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
            Option.Parent = Options

            local UIGradient = Instance.new('UIGradient')
            UIGradient.Transparency = NumberSequence.new{
                NumberSequenceKeypoint.new(0, 0),
                NumberSequenceKeypoint.new(0.704, 0),
                NumberSequenceKeypoint.new(0.872, 0.3625),
                NumberSequenceKeypoint.new(1, 1)
            }
            UIGradient.Parent = Option

            Option.MouseButton1Click:Connect(function()
                if not Library._config._flags[settings.flag] then
                    Library._config._flags[settings.flag] = {}
                end

                if settings.multi_dropdown then
                    if table.find(Library._config._flags[settings.flag], value) then
                        Library:remove_table_value(Library._config._flags[settings.flag], value)
                    else
                        table.insert(Library._config._flags[settings.flag], value)
                    end
                end

                DropdownManager:update(value)
            end)

            if index > settings.maximum_options then
                continue
            end

            DropdownManager._size += 16
            Options.Size = UDim2.fromOffset(207, DropdownManager._size)
        end
    end

    function DropdownManager:New(value)
        Dropdown:Destroy(true)
        value.OrderValue = Dropdown.LayoutOrder
        ModuleManager._multiplier -= CurrentDropSizeState
        return ModuleManager:create_dropdown(value)
    end

    if Library:flag_type(settings.flag, 'string') then
        DropdownManager:update(Library._config._flags[settings.flag])
    else
        DropdownManager:update(settings.options[1])
    end

    Dropdown.MouseButton1Click:Connect(function()
        DropdownManager:unfold_settings()
    end)

    return DropdownManager
end

function ModuleManager:create_feature(settings)
    local checked = false

    LayoutOrderModule = LayoutOrderModule + 1

    if self._size == 0 then
        self._size = 11
    end

    self._size += 20

    if ModuleManager._state then
        Module.Size = UDim2.fromOffset(241, 93 + self._size)
    end

    Options.Size = UDim2.fromOffset(241, self._size)

    local FeatureContainer = Instance.new("Frame")
    FeatureContainer.Size = UDim2.new(0, 207, 0, 16)
    FeatureContainer.BackgroundTransparency = 1
    FeatureContainer.Parent = Options
    FeatureContainer.LayoutOrder = LayoutOrderModule

    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.FillDirection = Enum.FillDirection.Horizontal
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Parent = FeatureContainer

    local FeatureButton = Instance.new("TextButton")
    FeatureButton.FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
    FeatureButton.TextSize = 11
    FeatureButton.Size = UDim2.new(1, -35, 0, 16)
    FeatureButton.BackgroundColor3 = Color3.fromRGB(32, 38, 51)
    FeatureButton.TextColor3 = Color3.fromRGB(210, 210, 210)
    FeatureButton.Text = "    " .. settings.title or "    " .. "Feature"
    FeatureButton.AutoButtonColor = false
    FeatureButton.TextXAlignment = Enum.TextXAlignment.Left
    FeatureButton.TextTransparency = 0.2
    FeatureButton.Parent = FeatureContainer

    local RightContainer = Instance.new("Frame")
    RightContainer.Size = UDim2.new(0, 45, 0, 16)
    RightContainer.BackgroundTransparency = 1
    RightContainer.Parent = FeatureContainer

    local RightLayout = Instance.new("UIListLayout")
    RightLayout.Padding = UDim.new(0.1, 0)
    RightLayout.FillDirection = Enum.FillDirection.Horizontal
    RightLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    RightLayout.SortOrder = Enum.SortOrder.LayoutOrder
    RightLayout.Parent = RightContainer

    local KeybindBox = Instance.new("TextLabel")
    KeybindBox.FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
    KeybindBox.Size = UDim2.new(0, 15, 0, 15)
    KeybindBox.BackgroundColor3 = Color3.fromRGB(152, 181, 255)
    KeybindBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    KeybindBox.TextSize = 11
    KeybindBox.BackgroundTransparency = 1
    KeybindBox.LayoutOrder = 2
    KeybindBox.Parent = RightContainer

    local KeybindButton = Instance.new("TextButton")
    KeybindButton.Size = UDim2.new(1, 0, 1, 0)
    KeybindButton.BackgroundTransparency = 1
    KeybindButton.TextTransparency = 1
    KeybindButton.Parent = KeybindBox

    local CheckboxCorner = Instance.new("UICorner", KeybindBox)
    CheckboxCorner.CornerRadius = UDim.new(0, 3)

    local UIStroke = Instance.new("UIStroke", KeybindBox)
    UIStroke.Color = Color3.fromRGB(55, 55, 55)
    UIStroke.Thickness = 1
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    if not Library._config._flags then
        Library._config._flags = {}
    end

    if not Library._config._flags[settings.flag] then
        Library._config._flags[settings.flag] = {
            checked = false,
            BIND = settings.default or "Unknown"
        }
    end

    checked = Library._config._flags[settings.flag].checked
    KeybindBox.Text = Library._config._flags[settings.flag].BIND

    if KeybindBox.Text == "Unknown" then
        KeybindBox.Text = "..."
    end

    local UseF_Var = nil

    if not settings.disablecheck then
        local Checkbox = Instance.new("TextButton")
        Checkbox.Size = UDim2.new(0, 15, 0, 15)
        Checkbox.BackgroundColor3 = checked and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(30, 30, 30)
        Checkbox.Text = ""
        Checkbox.Parent = RightContainer
        Checkbox.LayoutOrder = 1

        local UIStroke = Instance.new("UIStroke", Checkbox)
        UIStroke.Color = Color3.fromRGB(55, 55, 55)
        UIStroke.Thickness = 1
        UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

        local CheckboxCorner = Instance.new("UICorner")
        CheckboxCorner.CornerRadius = UDim.new(0, 3)
        CheckboxCorner.Parent = Checkbox

        local function toggleState()
            checked = not checked
            Checkbox.BackgroundColor3 = checked and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(30, 30, 30)
            Library._config._flags[settings.flag].checked = checked
            Config:save(game.GameId, Library._config)
            if settings.callback then
                settings.callback(checked)
            end
        end

        UseF_Var = toggleState

        Checkbox.MouseButton1Click:Connect(toggleState)
    else
        UseF_Var = function()
            settings.button_callback()
        end
    end

    KeybindButton.MouseButton1Click:Connect(function()
        KeybindBox.Text = "..."
        local inputConnection
        inputConnection = game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed then return end
            if input.UserInputType == Enum.UserInputType.Keyboard then
                local newKey = input.KeyCode.Name
                Library._config._flags[settings.flag].BIND = newKey
                if newKey ~= "Unknown" then
                    KeybindBox.Text = newKey
                end
                Config:save(game.GameId, Library._config)
                inputConnection:Disconnect()
            elseif input.UserInputType == Enum.UserInputType.MouseButton3 then
                Library._config._flags[settings.flag].BIND = "Unknown"
                KeybindBox.Text = "..."
                Config:save(game.GameId, Library._config)
                inputConnection:Disconnect()
            end
        end)
        Connections["keybind_input_" .. settings.flag] = inputConnection
    end)

    local keyPressConnection
    keyPressConnection = game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.UserInputType == Enum.UserInputType.Keyboard then
            if input.KeyCode.Name == Library._config._flags[settings.flag].BIND then
                UseF_Var()
            end
        end
    end)
    Connections["keybind_press_" .. settings.flag] = keyPressConnection

    FeatureButton.MouseButton1Click:Connect(function()
        if settings.button_callback then
            settings.button_callback()
        end
    end)

    if not settings.disablecheck then
        settings.callback(checked)
    end

    return FeatureContainer
end

return ModuleManager
end
        return TabManager
    end

    Connections['library_visiblity'] = UserInputService.InputBegan:Connect(function(input: InputObject, process: boolean)
        if input.KeyCode ~= Enum.KeyCode.LeftControl then
                return
            end

        self._ui_open = not self._ui_open
        if getgenv().guilibraryVisible then
            set_gui_visibility(self._ui_open)
        end

        self:change_visiblity(self._ui_open)
    end)

    self._ui.Container.Handler.Minimize.MouseButton1Click:Connect(function()
        self._ui_open = not self._ui_open

        if getgenv().guilibraryVisible then
            set_gui_visibility(self._ui_open)
        end

        self:change_visiblity(self._ui_open)
    end)

    return self
end

local library = Library.new()
library:load()


local AutoparryTab = library:create_tab("Main")
local BlatantTab = library:create_tab("Blatant")
local SpamTab = library:create_tab("Spam")
local DetectionTab = library:create_tab("Detection")
local PlayerTab = library:create_tab("Player")
local VisualsTab = library:create_tab("Visual")
local MiscTab = library:create_tab("Misc")
local WorldTab = library:create_tab("World")
local GuiTab = library:create_tab("GUI")
local UnlockTab = library:create_tab("Unlock")

local __unlockAllInit = false
local __unlockAllEnable = nil

local function __initUnlockAllBackend()
    if __unlockAllInit then return true end
    local ok, err = pcall(function()
        repeat task.wait() until game:IsLoaded()
        
        local getgenv = getgenv
        local task = task
        local RunService = game:GetService("RunService")
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer
        local UserInputService = game:GetService("UserInputService")
        local TweenService = game:GetService("TweenService")
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local HttpService = game:GetService("HttpService")
        
        local function getExecutorGlobal(name)
            if getgenv and getgenv()[name] ~= nil then return getgenv()[name] end
            if _G and _G[name] ~= nil then return _G[name] end
            if shared and shared[name] ~= nil then return shared[name] end
            if getrenv and getrenv()[name] ~= nil then return getrenv()[name] end
        
            local value = nil
            pcall(function()
                if gethui then
                    local hui = gethui()
                    if hui and hui[name] ~= nil then value = hui[name] end
                end
            end)
            if value ~= nil then return value end
        
            pcall(function()
                if getfenv then
                    local environment = getfenv(0)
                    if environment and environment[name] ~= nil then value = environment[name] end
                end
            end)
            if value ~= nil then return value end
        
            return nil
        end
        
            local SKIN_LAST_EQUIPPED_CONFIG_KEY = "Skin.LastEquippedSword"
            local EXPLOSION_LAST_EQUIPPED_CONFIG_KEY = "Skin.LastEquippedExplosion"
            local AUTO_CONFIG_FILE = "Azure/auto_config.json"
        
            local function readAzureAutoConfig()
                local data = {}
                pcall(function()
                    if isfile and isfile(AUTO_CONFIG_FILE) then
                        local decoded = HttpService:JSONDecode(readfile(AUTO_CONFIG_FILE))
                        if type(decoded) == "table" then
                            data = decoded
                        end
                    end
                end)
                return data
            end
        
            local function writeAzureAutoConfig(data)
                pcall(function()
                    if isfolder and makefolder and not isfolder("Azure") then
                        makefolder("Azure")
                    end
                    if writefile then
                        writefile(AUTO_CONFIG_FILE, HttpService:JSONEncode(data or {}))
                    end
                end)
            end
        
            local function loadLastEquippedSword()
                local data = readAzureAutoConfig()
                local saved = data[SKIN_LAST_EQUIPPED_CONFIG_KEY]
                return type(saved) == "string" and saved or ""
            end
        
            local function loadLastEquippedExplosion()
                local data = readAzureAutoConfig()
                local saved = data[EXPLOSION_LAST_EQUIPPED_CONFIG_KEY]
                return type(saved) == "string" and saved or ""
            end
        
            getgenv().saveLastEquippedSword = function(swordName)
                if type(swordName) ~= "string" or swordName == "" then return end
        
                local autoConfig = getgenv()._azAutoConfig
                local data = autoConfig and autoConfig.Data
                if type(data) ~= "table" then
                    data = readAzureAutoConfig()
                end
        
                data[SKIN_LAST_EQUIPPED_CONFIG_KEY] = swordName
                if autoConfig and type(autoConfig.Data) == "table" then
                    autoConfig.Data[SKIN_LAST_EQUIPPED_CONFIG_KEY] = swordName
                end
                writeAzureAutoConfig(data)
            end
        
            getgenv().saveLastEquippedExplosion = function(explosionName)
                if type(explosionName) ~= "string" or explosionName == "" then return end
        
                local autoConfig = getgenv()._azAutoConfig
                local data = autoConfig and autoConfig.Data
                if type(data) ~= "table" then
                    data = readAzureAutoConfig()
                end
        
                data[EXPLOSION_LAST_EQUIPPED_CONFIG_KEY] = explosionName
                if autoConfig and type(autoConfig.Data) == "table" then
                    autoConfig.Data[EXPLOSION_LAST_EQUIPPED_CONFIG_KEY] = explosionName
                end
                writeAzureAutoConfig(data)
            end
        
            do
                local savedLastSword = loadLastEquippedSword()
                local savedLastExplosion = loadLastEquippedExplosion()
                getgenv().skinChanger = getgenv().skinChanger or savedLastSword ~= ""
                getgenv().swordModel = type(getgenv().swordModel) == "string" and getgenv().swordModel ~= "" and getgenv().swordModel or savedLastSword
                getgenv().swordAnimations = type(getgenv().swordAnimations) == "string" and getgenv().swordAnimations ~= "" and getgenv().swordAnimations or savedLastSword
                getgenv().swordFX = type(getgenv().swordFX) == "string" and getgenv().swordFX ~= "" and getgenv().swordFX or savedLastSword
                getgenv().explosionChanger = getgenv().explosionChanger or savedLastExplosion ~= ""
                getgenv().explosionFX = type(getgenv().explosionFX) == "string" and getgenv().explosionFX ~= "" and getgenv().explosionFX or savedLastExplosion
            end
        
            task.spawn(function()
                local rs = game:GetService("ReplicatedStorage")
                local swordInstancesInstance = rs:WaitForChild("Shared", 9e9):WaitForChild("ReplicatedInstances", 9e9):WaitForChild("Swords", 9e9)
                local swordInstances = require(swordInstancesInstance)
        
                local swordsController
                task.spawn(function()
                    while task.wait(0.25) and not swordsController do
                        local ok, conns = pcall(getconnections, rs.Remotes.FireSwordInfo.OnClientEvent)
                        if ok and conns then
                            for _, v in ipairs(conns) do
                                if v.Function and islclosure and islclosure(v.Function) then
                                    local ok2, up = pcall(getupvalues, v.Function)
                                    if ok2 and #up == 1 and type(up[1]) == "table" then
                                        swordsController = up[1]
                                        break
                                    end
                                end
                            end
                        end
                    end
                end)
        
                local function getSlashName(swordName)
                    local ok, sln = pcall(function() return swordInstances:GetSword(swordName) end)
                    return (ok and sln and sln.SlashName) or "SlashEffect"
                end
        
                local function refreshSlashName()
                    local fxName = getgenv().swordFX ~= "" and getgenv().swordFX or getgenv().swordModel
                    if fxName ~= "" then
                        getgenv().slashName = getSlashName(fxName)
                    else
                        getgenv().slashName = "SlashEffect"
                    end
                end
                refreshSlashName()
        
                local function setSword()
                    if not getgenv().skinChanger then return end
                    if not LocalPlayer.Character then return end
                    pcall(function()
                        local f = rawget(swordInstances, "EquipSwordTo")
                        if type(f) == "function" then
                            local ups = getupvalues(f)
                            for i = 1, #ups do
                                if type(ups[i]) == "boolean" then
                                    setupvalue(f, i, false)
                                    break
                                end
                            end
                        end
                    end)
                    pcall(function()
                        swordInstances:EquipSwordTo(LocalPlayer.Character, getgenv().swordModel)
                    end)
                    task.spawn(function()
                        local attempts = 0
                        while not swordsController and attempts < 20 do
                            task.wait(0.5); attempts = attempts + 1
                        end
                        if not swordsController then return end
                        pcall(function()
                            if swordsController.SetSword then
                                swordsController:SetSword(getgenv().swordAnimations ~= "" and getgenv().swordAnimations or getgenv().swordModel)
                            end
                        end)
                        pcall(function()
                            local targetSword = getgenv().swordFX ~= "" and getgenv().swordFX or getgenv().swordModel
                            if rs.Remotes:FindFirstChild("FireSwordInfo") then
                                rs.Remotes.FireSwordInfo:FireServer(targetSword)
                            end
                            if swordsController.currentSword ~= nil then
                                pcall(function() swordsController.currentSword = targetSword end)
                            end
                            if swordsController.SwordFX ~= nil then
                                pcall(function() swordsController.SwordFX = targetSword end)
                            end
                        end)
                    end)
                end
        
                
                local hookedFuncs = {}
                task.spawn(function()
                    local remotesToHook = {"ParrySuccessAll", "ParryAttempt", "ParrySuccess", "PlaySound", "PlayVisuals"}
                    while task.wait(1) do
                        for _, remoteName in ipairs(remotesToHook) do
                            local remote = rs.Remotes:FindFirstChild(remoteName)
                            if remote and remote:IsA("RemoteEvent") then
                                local ok, conns = pcall(getconnections, remote.OnClientEvent)
                                if ok and type(conns) == "table" then
                                    for _, v in ipairs(conns) do
                                        local func = v.Function
                                        if func and not hookedFuncs[func] then
                                            
                                            hookedFuncs[func] = true
                                            v:Disable()
                                            local targetFunc = func
                                            local ourFunc
                                            ourFunc = function(...)
                                                local args = { ... }
        
                                                local isLocal = false
                                                for _, arg in ipairs(args) do
                                                    if tostring(arg) == LocalPlayer.Name or (typeof(arg) == "Instance" and (arg == LocalPlayer.Character or arg == LocalPlayer)) then
                                                        isLocal = true
                                                        break
                                                    end
                                                end
        
                                                if isLocal and getgenv().skinChanger then
                                                    local fxSword = getgenv().swordFX ~= "" and getgenv().swordFX or getgenv().swordModel
                                                    refreshSlashName()
        
                                                    local swordFound = false
                                                    local slashFound = false
        
                                                    for i, arg in ipairs(args) do
                                                        if type(arg) == "string" then
                                                            if fxSword ~= "" and not slashFound and (arg:match("Slash") or arg == "Default" or arg:match("Effect")) then
                                                                args[i] = getgenv().slashName
                                                                slashFound = true
                                                            elseif fxSword ~= "" and not swordFound then
                                                                local isSword = false
                                                                pcall(function()
                                                                    if rs.Shared.ReplicatedInstances.Swords:FindFirstChild(arg) then
                                                                        isSword = true
                                                                    end
                                                                end)
                                                                if isSword or arg == LocalPlayer:GetAttribute("CurrentlyEquippedSword") then
                                                                    args[i] = fxSword
                                                                    swordFound = true
                                                                end
                                                            end
                                                        end
                                                    end
        
                                                    
                                                    if fxSword ~= "" and not slashFound and type(args[1]) == "string" then
                                                        args[1] = getgenv().slashName
                                                    end
                                                    if fxSword ~= "" and not swordFound and type(args[3]) == "string" then
                                                        args[3] = fxSword
                                                    end
                                                end
                                                if setthreadidentity then pcall(setthreadidentity, 2) end
                                                pcall(targetFunc, unpack(args))
                                            end
                                            hookedFuncs[ourFunc] = true
                                            remote.OnClientEvent:Connect(ourFunc)
                                        end
                                    end
                                end
                            end
                        end
                    end
                end)
        
                getgenv().updateSword = function()
                    refreshSlashName()
                    if getgenv().skinChanger and getgenv().swordModel ~= "" and getgenv().saveLastEquippedSword then
                        getgenv().saveLastEquippedSword(getgenv().swordModel)
                    end
                    setSword()
                end
        
                
                task.spawn(function()
                    while task.wait(1) do
                        if getgenv().skinChanger and getgenv().swordModel ~= "" then
                            local char = LocalPlayer.Character
                            if char then
                                if LocalPlayer:GetAttribute("CurrentlyEquippedSword") ~= getgenv().swordModel then
                                    setSword()
                                end
                                if not char:FindFirstChild(getgenv().swordModel) then
                                    setSword()
                                end
                                for _, v in pairs(char:GetChildren()) do
                                    if v:IsA("Model") and v.Name ~= getgenv().swordModel then
                                        v:Destroy()
                                    end
                                    task.wait()
                                end
                            end
                        end
                    end
                end)
        
                LocalPlayer.CharacterAdded:Connect(function()
                    if getgenv().skinChanger then
                        getgenv().skinChanger = false
                        if getgenv().setSkinChangerToggleUI then getgenv().setSkinChangerToggleUI(false) end
                        task.wait(2)
                        getgenv().skinChanger = true
                        if getgenv().setSkinChangerToggleUI then getgenv().setSkinChangerToggleUI(true) end
                        task.wait(0.5)
                        pcall(function() getgenv().updateSword() end)
                    end
                end)
            end)
        
            
        
            task.spawn(function()
                local rs = game:GetService("ReplicatedStorage")
                local explosionHookedFuncs = {}
                
        
                local explosionDirectHooked = {}
                local deadFolderHooked = false
                local explosionModule = nil
                local bindableInvokeHooked = false
                local nativeExplosionSuppressorHooked = {}
                local pendingKillExplosionPosition = nil
                local pendingKillExplosionAt = 0
                local lastLocalKillAt = 0
                local lastLocalKillStatTotal = nil
                local killStatWatcherStarted = false
                local lastLocalExplosionPlayedAt = 0
                local lastLocalExplosionPlayedPosition = nil
        
                local function normalizeExplosionName(value)
                    return tostring(value or ""):lower():gsub("[^%w]", "")
                end
        
                local function getNetFolder()
                    local packages = rs:FindFirstChild("Packages")
                    local index = packages and packages:FindFirstChild("_Index")
                    local sleitnick = index and index:FindFirstChild("sleitnick_net@0.1.0")
                    return sleitnick and sleitnick:FindFirstChild("net")
                end
        
                local function getExplosionInstances()
                    local shared = rs:FindFirstChild("Shared")
                    local replicatedInstances = shared and shared:FindFirstChild("ReplicatedInstances")
                    return replicatedInstances and replicatedInstances:FindFirstChild("Explosions")
                end
        
                local function getExplosionDataFolder()
                    local misc = rs:FindFirstChild("Misc")
                    return misc and misc:FindFirstChild("DataExplosions")
                end
        
                local function getExplosionEffectsFolder()
                    return rs:FindFirstChild("ExplosionEffects")
                end
        
                local function getExplosionModule()
                    if explosionModule ~= nil then return explosionModule end
                    local instance = getExplosionInstances()
                    if instance and instance:IsA("ModuleScript") then
                        local ok, result = pcall(function()
                            return require(instance)
                        end)
                        explosionModule = ok and result or false
                    end
                    return explosionModule
                end
        
                local function findExplosionInstanceByName(value)
                    if type(value) ~= "string" or value == "" then return nil end
                    local wanted = normalizeExplosionName(value)
                    for _, root in ipairs({getExplosionDataFolder(), getExplosionEffectsFolder(), getExplosionInstances()}) do
                        if root then
                            local exact = root:FindFirstChild(value, true)
                            if exact then return exact end
                            for _, child in ipairs(root:GetDescendants()) do
                                if normalizeExplosionName(child.Name) == wanted then
                                    return child
                                end
                            end
                        end
                    end
                    return nil
                end
        
                local function findExplosionDataConfig(value)
                    if type(value) ~= "string" or value == "" then return nil end
                    local dataFolder = getExplosionDataFolder()
                    if not dataFolder then return nil end
        
                    local wanted = normalizeExplosionName(value)
                    local exact = dataFolder:FindFirstChild(value, true)
                    if exact then return exact end
        
                    for _, child in ipairs(dataFolder:GetDescendants()) do
                        if normalizeExplosionName(child.Name) == wanted then
                            return child
                        end
                        for _, attributeValue in pairs(child:GetAttributes()) do
                            if type(attributeValue) == "string"
                                and normalizeExplosionName(attributeValue) == wanted then
                                return child
                            end
                        end
                    end
                    return nil
                end
        
                local function getExplosionAliases(value)
                    local aliases = {}
                    local seen = {}
                    local function add(alias)
                        if type(alias) ~= "string" or alias == "" then return end
                        local key = normalizeExplosionName(alias)
                        if key == "" or seen[key] then return end
                        seen[key] = true
                        aliases[#aliases + 1] = alias
                    end
        
                    add(value)
                    local config = findExplosionDataConfig(value)
                    if config then
                        add(config.Name)
                        for _, attributeName in ipairs({
                            "Title",
                            "TitleText",
                            "DisplayName",
                            "ExplosionName",
                            "EffectName",
                            "FXName",
                            "VFXName",
                            "ItemName",
                        }) do
                            local ok, attributeValue = pcall(function()
                                return config:GetAttribute(attributeName)
                            end)
                            if ok then add(attributeValue) end
                        end
        
                        local scanned = 0
                        for _, object in ipairs(config:GetDescendants()) do
                            if object:IsA("StringValue") then
                                add(object.Value)
                                scanned = scanned + 1
                                if scanned >= 20 then break end
                            end
                        end
                    end
                    return aliases
                end
        
                local function isPlayableExplosionTemplate(instance)
                    if typeof(instance) ~= "Instance" then return false end
                    if instance:IsA("Configuration")
                        or instance:IsA("ModuleScript")
                        or instance:IsA("Script")
                        or instance:IsA("LocalScript")
                        or instance:IsA("BindableFunction")
                        or instance:IsA("BindableEvent")
                        or instance:IsA("ObjectValue") then
                        return false
                    end
                    return instance:IsA("Folder")
                        or instance:IsA("Model")
                        or instance:IsA("BasePart")
                        or instance:IsA("Attachment")
                        or instance:IsA("Accessory")
                        or instance:IsA("Tool")
                        or instance:FindFirstChildWhichIsA("BasePart", true) ~= nil
                        or instance:FindFirstChildWhichIsA("ParticleEmitter", true) ~= nil
                        or instance:FindFirstChildWhichIsA("Beam", true) ~= nil
                        or instance:FindFirstChildWhichIsA("Trail", true) ~= nil
                end
        
                local function firstPlayableExplosionValue(value, depth, seen)
                    if value == nil or depth > 4 then return nil end
                    if typeof(value) == "Instance" then
                        return isPlayableExplosionTemplate(value) and value or nil
                    end
                    if type(value) ~= "table" then return nil end
        
                    seen = seen or {}
                    if seen[value] then return nil end
                    seen[value] = true
        
                    for _, key in ipairs({"VFX", "Effect", "Effects", "Instance", "Model", "Folder", "Explosion", "Object", "Template"}) do
                        local candidate = firstPlayableExplosionValue(value[key], depth + 1, seen)
                        if candidate then return candidate end
                    end
                    for _, child in pairs(value) do
                        local candidate = firstPlayableExplosionValue(child, depth + 1, seen)
                        if candidate then return candidate end
                    end
                    return nil
                end
        
                local function getReplicatedExplosionTemplate(value)
                    local instances = getExplosionInstances()
                    if not instances then return nil end
        
                    for _, alias in ipairs(getExplosionAliases(value)) do
                        local direct = instances:FindFirstChild(alias, true)
                        if isPlayableExplosionTemplate(direct) then
                            getgenv().lastExplosionTemplateSource = "ReplicatedInstances"
                            return direct
                        end
                    end
        
                    local bindable = instances:FindFirstChild("GetInstance")
                    if bindable and bindable:IsA("BindableFunction") then
                        for _, alias in ipairs(getExplosionAliases(value)) do
                            local ok, result = pcall(function()
                                return bindable:Invoke(alias)
                            end)
                            local template = ok and firstPlayableExplosionValue(result, 0, {}) or nil
                            if template then
                                getgenv().lastExplosionTemplateSource = "ReplicatedInstances.GetInstance"
                                return template
                            end
                        end
                    end
        
                    local module = getExplosionModule()
                    if type(module) == "table" then
                        for _, alias in ipairs(getExplosionAliases(value)) do
                            local directValue = module[alias] or module[normalizeExplosionName(alias)]
                            local directTemplate = firstPlayableExplosionValue(directValue, 0, {})
                            if directTemplate then
                                getgenv().lastExplosionTemplateSource = "ReplicatedInstances.Module"
                                return directTemplate
                            end
        
                            for _, methodName in ipairs({"GetInstance", "GetExplosion", "GetExplosionVFX", "GetEffect", "Get"}) do
                                local method = module[methodName]
                                if type(method) == "function" then
                                    for _, callWithSelf in ipairs({true, false}) do
                                        local ok, result = pcall(function()
                                            if callWithSelf then
                                                return method(module, alias)
                                            end
                                            return method(alias)
                                        end)
                                        local template = ok and firstPlayableExplosionValue(result, 0, {}) or nil
                                        if template then
                                            getgenv().lastExplosionTemplateSource = "ReplicatedInstances." .. methodName
                                            return template
                                        end
                                    end
                                end
                            end
                        end
                    end
        
                    return nil
                end
        
                local function findExplosionEffectTemplate(value)
                    if type(value) ~= "string" or value == "" then return nil end
                    local replicatedTemplate = getReplicatedExplosionTemplate(value)
                    if replicatedTemplate then return replicatedTemplate end
        
                    local effectsFolder = getExplosionEffectsFolder()
                    if not effectsFolder then return nil end
        
                    for _, alias in ipairs(getExplosionAliases(value)) do
                        local exact = effectsFolder:FindFirstChild(alias, true)
                        if exact and isPlayableExplosionTemplate(exact) then
                            getgenv().lastExplosionTemplateSource = "ExplosionEffects"
                            return exact
                        end
                    end
        
                    for _, alias in ipairs(getExplosionAliases(value)) do
                        local wanted = normalizeExplosionName(alias)
                        for _, child in ipairs(effectsFolder:GetDescendants()) do
                            if isPlayableExplosionTemplate(child) and normalizeExplosionName(child.Name) == wanted then
                                getgenv().lastExplosionTemplateSource = "ExplosionEffects"
                                return child
                            end
                        end
                    end
        
                    local best = nil
                    local bestScore = 0
                    for _, child in ipairs(effectsFolder:GetDescendants()) do
                        if isPlayableExplosionTemplate(child) then
                            local key = normalizeExplosionName(child.Name)
                            local score = 0
                            for _, alias in ipairs(getExplosionAliases(value)) do
                                local wanted = normalizeExplosionName(alias)
                                if wanted:find(key, 1, true) or key:find(wanted, 1, true) then
                                    score = math.max(score, math.min(#key, #wanted))
                                else
                                    for word in pairs(tostring(alias):gmatch("[%w]+")) do
                                        local wordKey = normalizeExplosionName(word)
                                        if #wordKey >= 4 and key:find(wordKey, 1, true) then
                                            score = score + #wordKey
                                        end
                                    end
                                end
                            end
                            if score > bestScore then
                                best = child
                                bestScore = score
                            end
                        end
                    end
        
                    if best then
                        getgenv().lastExplosionTemplateSource = "ExplosionEffects.Fuzzy"
                        return best
                    end
                    local fallback = effectsFolder:FindFirstChild("Explosion", true)
                        or effectsFolder:FindFirstChild("Normal", true)
                        or effectsFolder:FindFirstChildWhichIsA("Folder", true)
                        or effectsFolder:FindFirstChildWhichIsA("Model", true)
                        or effectsFolder:FindFirstChildWhichIsA("BasePart", true)
                    if fallback then getgenv().lastExplosionTemplateSource = "ExplosionEffects.Fallback" end
                    return fallback
                end
        
                local function getSelectedExplosionName()
                    local selected = getgenv().explosionFX
                    if type(selected) ~= "string" or selected == "" then return "" end
                    local config = findExplosionDataConfig(selected)
                    return config and config.Name or selected
                end
        
                local function isPlayerString(value)
                    if type(value) ~= "string" then return false end
                    for _, player in ipairs(Players:GetPlayers()) do
                        if value == player.Name or value == player.DisplayName then
                            return true
                        end
                    end
                    return false
                end
        
                local function isKnownExplosionName(value)
                    if type(value) ~= "string" or value == "" then return false end
                    if findExplosionInstanceByName(value) then return true end
                    local instances = getExplosionInstances()
                    if instances then
                        local bindable = instances:FindFirstChild("GetInstance")
                        if bindable and bindable:IsA("BindableFunction") then
                            local ok, result = pcall(function()
                                return bindable:Invoke(value)
                            end)
                            if ok and result then return true end
                        end
                        if instances:FindFirstChild(value, true) then return true end
                    end
        
                    local module = getExplosionModule()
                    if type(module) == "table" then
                        if module[value] ~= nil then return true end
                        for _, methodName in ipairs({"GetExplosion", "GetInstance", "Get"}) do
                            if type(module[methodName]) == "function" then
                                local ok, result = pcall(function()
                                    return module[methodName](module, value)
                                end)
                                if ok and result then return true end
                            end
                        end
                    end
                    return false
                end
        
                local function argsMentionLocal(args)
                    for _, arg in ipairs(args) do
                        if arg == LocalPlayer or arg == LocalPlayer.Character or arg == LocalPlayer.Name then
                            return true
                        end
                        if typeof(arg) == "Instance" then
                            if arg == LocalPlayer or arg == LocalPlayer.Character then return true end
                            if LocalPlayer.Character and arg:IsDescendantOf(LocalPlayer.Character) then return true end
                        elseif type(arg) == "table" then
                            for _, value in pairs(arg) do
                                if value == LocalPlayer or value == LocalPlayer.Character or value == LocalPlayer.Name then
                                    return true
                                end
                            end
                        end
                    end
                    return false
                end
        
                local function valueMentionsLocal(value, depth)
                    if depth > 4 or value == nil then return false end
                    if value == LocalPlayer or value == LocalPlayer.Character or value == LocalPlayer.Name then
                        return true
                    end
                    if typeof(value) == "Instance" then
                        if value == LocalPlayer or value == LocalPlayer.Character then return true end
                        if value:IsA("Player") then
                            return value == LocalPlayer
                                or value.Name == LocalPlayer.Name
                                or value.DisplayName == LocalPlayer.DisplayName
                        end
                        return LocalPlayer.Character and value:IsDescendantOf(LocalPlayer.Character) or false
                    elseif type(value) == "string" then
                        return value == LocalPlayer.Name or value == LocalPlayer.DisplayName
                    elseif type(value) == "table" then
                        for _, child in pairs(value) do
                            if valueMentionsLocal(child, depth + 1) then return true end
                        end
                    end
                    return false
                end
        
                local function tableIndicatesLocalKill(tbl, depth)
                    if type(tbl) ~= "table" or depth > 4 then return false end
                    for key, value in pairs(tbl) do
                        local keyText = tostring(key):lower()
                        local killerKey = keyText:find("killer", 1, true)
                            or keyText:find("attacker", 1, true)
                            or keyText:find("creator", 1, true)
                            or keyText:find("source", 1, true)
                            or keyText:find("from", 1, true)
                            or keyText:find("dealer", 1, true)
                            or keyText:find("owner", 1, true)
                        local victimKey = keyText:find("victim", 1, true)
                            or keyText:find("dead", 1, true)
                            or keyText:find("killed", 1, true)
                            or keyText:find("target", 1, true)
                        if killerKey and valueMentionsLocal(value, 0) then return true end
                        if victimKey and valueMentionsLocal(value, 0) then return false end
                    end
                    for _, value in pairs(tbl) do
                        if tableIndicatesLocalKill(value, depth + 1) then return true end
                    end
                    return false
                end
        
                local function tableIndicatesLocalDeath(tbl, depth)
                    if type(tbl) ~= "table" or depth > 4 then return false end
                    for key, value in pairs(tbl) do
                        local keyText = tostring(key):lower()
                        local victimKey = keyText:find("victim", 1, true)
                            or keyText:find("dead", 1, true)
                            or keyText:find("killed", 1, true)
                            or keyText:find("target", 1, true)
                        if victimKey and valueMentionsLocal(value, 0) then return true end
                    end
                    for _, value in pairs(tbl) do
                        if tableIndicatesLocalDeath(value, depth + 1) then return true end
                    end
                    return false
                end
        
                local function argsIndicateLocalDeath(args)
                    for _, arg in ipairs(args) do
                        if tableIndicatesLocalDeath(arg, 0) then return true end
                    end
                    return false
                end
        
                local function argsIndicateLocalKill(args, remoteName)
                    for _, arg in ipairs(args) do
                        if tableIndicatesLocalKill(arg, 0) then return true end
                    end
                    local first = args[1]
                    local second = args[2]
                    local third = args[3]
                    if valueMentionsLocal(second, 0) and not valueMentionsLocal(first, 0) then return true end
                    if valueMentionsLocal(third, 0) and not valueMentionsLocal(first, 0) then return true end
                    if valueMentionsLocal(first, 0) and not valueMentionsLocal(second, 0) then return true end
        
                    local remoteKey = tostring(remoteName or ""):lower()
                    local killRemote = remoteKey:find("kill", 1, true)
                        or remoteKey:find("death", 1, true)
                        or remoteKey:find("dead", 1, true)
                    return killRemote and argsMentionLocal(args) and not argsIndicateLocalDeath(args)
                end
        
                local function getPositionFromExplosionValue(value, depth)
                    if depth > 3 or value == nil then return nil end
                    if typeof(value) == "Vector3" then return value end
                    if typeof(value) == "CFrame" then return value.Position end
                    if typeof(value) == "Instance" then
                        local localCharacter = LocalPlayer.Character
                        if value == LocalPlayer or value == localCharacter then return nil end
                        if localCharacter and value:IsDescendantOf(localCharacter) then return nil end
        
                        if value:IsA("BasePart") then return value.Position end
                        if value:IsA("Player") then
                            local character = value.Character
                            local root = character and (character:FindFirstChild("HumanoidRootPart") or character.PrimaryPart)
                            return root and root.Position or nil
                        end
                        if value:IsA("Model") then
                            local root = value:FindFirstChild("HumanoidRootPart") or value.PrimaryPart
                            if root then return root.Position end
                            local ok, pivot = pcall(function() return value:GetPivot() end)
                            if ok and pivot then return pivot.Position end
                        end
                    elseif type(value) == "table" then
                        for _, child in pairs(value) do
                            local position = getPositionFromExplosionValue(child, depth + 1)
                            if position then return position end
                        end
                    end
                    return nil
                end
        
                local function isLocalExplosionPosition(position)
                    if typeof(position) ~= "Vector3" then return false end
                    local character = LocalPlayer.Character
                    local root = character and (character:FindFirstChild("HumanoidRootPart") or character.PrimaryPart)
                    return root and (position - root.Position).Magnitude <= 4 or false
                end
        
                local function getExplosionPositionFromArgs(args)
                    for _, arg in ipairs(args) do
                        local position = getPositionFromExplosionValue(arg, 0)
                        if position and not isLocalExplosionPosition(position) then return position end
                    end
                    return nil
                end
        
                local function parseVector3Attribute(value)
                    if typeof(value) == "Vector3" then return value end
                    if type(value) ~= "string" then return nil end
                    local numbers = {}
                    for numberText in value:gmatch("[-+]?%d+%.?%d*") do
                        numbers[#numbers + 1] = tonumber(numberText)
                        if #numbers >= 3 then break end
                    end
                    if #numbers >= 3 then
                        return Vector3.new(numbers[1], numbers[2], numbers[3])
                    end
                    return nil
                end
        
                local function getNumberAttribute(object, names)
                    for _, name in ipairs(names) do
                        local value = tonumber(object:GetAttribute(name))
                        if value then return value end
                    end
                    return nil
                end
        
                local function delayedTween(object, delayTime, duration, properties)
                    if not next(properties) then return end
                    task.delay(delayTime or 0, function()
                        if object and object.Parent then
                            pcall(function()
                                TweenService:Create(
                                    object,
                                    TweenInfo.new(math.max(duration or 0.05, 0.05), Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                                    properties
                                ):Play()
                            end)
                        end
                    end)
                end
        
                local function activateLocalExplosionObject(root)
                    local objects = {root}
                    for _, object in ipairs(root:GetDescendants()) do
                        objects[#objects + 1] = object
                    end
        
                    for _, object in ipairs(objects) do
                        local emitDelay = tonumber(object:GetAttribute("EmitDelay")) or tonumber(object:GetAttribute("Delay")) or 0
                        local duration = tonumber(object:GetAttribute("Duration")) or tonumber(object:GetAttribute("Time")) or 0.35
                        if object:IsA("BasePart") then
                            object.Anchored = true
                            object.CanCollide = false
                            object.CanTouch = false
                            object.CanQuery = false
        
                            local properties = {}
                            local sizeTarget = parseVector3Attribute(object:GetAttribute("Size_Target"))
                                or parseVector3Attribute(object:GetAttribute("Size"))
                            local transparencyTarget = tonumber(object:GetAttribute("Transparency_Target"))
                                or tonumber(object:GetAttribute("Transparency"))
                            if sizeTarget then properties.Size = sizeTarget end
                            if transparencyTarget then properties.Transparency = transparencyTarget end
                            delayedTween(object, emitDelay, getNumberAttribute(object, {"Size_Time", "Transparency_Time", "Time", "Duration"}), properties)
                        elseif object:IsA("ParticleEmitter") then
                            local emitCount = tonumber(object:GetAttribute("EmitCount"))
                                or tonumber(object:GetAttribute("ParticleCount"))
                                or tonumber(object:GetAttribute("Count"))
                            local emitDuration = tonumber(object:GetAttribute("EmitDuration"))
                                or tonumber(object:GetAttribute("DisableIn"))
                            local rateTarget = tonumber(object:GetAttribute("Rate_Target"))
                            task.delay(emitDelay, function()
                                if object and object.Parent then
                                    if emitCount and emitCount > 0 then
                                        pcall(function() object:Emit(emitCount) end)
                                    else
                                        pcall(function() object.Enabled = true end)
                                        if emitDuration and emitDuration > 0 then
                                            task.delay(emitDuration, function()
                                                if object and object.Parent then object.Enabled = false end
                                            end)
                                        end
                                    end
                                    if rateTarget then
                                        delayedTween(object, 0, duration, {Rate = rateTarget})
                                    end
                                end
                            end)
                        elseif object:IsA("Beam") then
                            task.delay(emitDelay, function()
                                if object and object.Parent then object.Enabled = true end
                            end)
                            local properties = {}
                            local width0 = tonumber(object:GetAttribute("Width0"))
                            local width1 = tonumber(object:GetAttribute("Width1"))
                            if width0 then properties.Width0 = width0 end
                            if width1 then properties.Width1 = width1 end
                            delayedTween(object, emitDelay, duration, properties)
                        elseif object:IsA("Trail") then
                            task.delay(emitDelay, function()
                                if object and object.Parent then object.Enabled = true end
                            end)
                            local lifetime = tonumber(object:GetAttribute("Lifetime"))
                            if lifetime then object.Lifetime = lifetime end
                        elseif object:IsA("Light") then
                            task.delay(emitDelay, function()
                                if object and object.Parent then object.Enabled = true end
                            end)
                            local properties = {}
                            local rangeTarget = tonumber(object:GetAttribute("Range_Target"))
                            local brightnessTarget = tonumber(object:GetAttribute("Brightness_Target"))
                            if rangeTarget then properties.Range = rangeTarget end
                            if brightnessTarget then properties.Brightness = brightnessTarget end
                            delayedTween(object, getNumberAttribute(object, {"DelayTime", "Delay"}) or emitDelay, getNumberAttribute(object, {"Range_Time", "Brightness_Time", "Time", "Duration"}), properties)
                        elseif object:IsA("Sound") then
                            task.delay(tonumber(object:GetAttribute("Delay")) or emitDelay, function()
                                if object and object.Parent then
                                    pcall(function() object:Play() end)
                                    local volumeTarget = tonumber(object:GetAttribute("Volume_Target"))
                                    if volumeTarget then
                                        delayedTween(object, 0, duration, {Volume = volumeTarget})
                                    end
                                end
                            end)
                        end
                    end
                end
        
                local function playSyntheticExplosion(position)
                    getgenv().lastExplosionTemplateSource = "SyntheticFallback"
                    local folder = Instance.new("Folder")
                    folder.Name = "AzureExplosion_LocalFallback"
                    folder.Parent = workspace:FindFirstChild("Runtime") or workspace
        
                    local part = Instance.new("Part")
                    part.Name = "Burst"
                    part.Anchored = true
                    part.CanCollide = false
                    part.CanTouch = false
                    part.CanQuery = false
                    part.Material = Enum.Material.Neon
                    part.Shape = Enum.PartType.Ball
                    part.Size = Vector3.new(1, 1, 1)
                    part.Color = Color3.fromRGB(120, 180, 255)
                    part.Transparency = 1
                    pcall(function() part.LocalTransparencyModifier = 1 end)
                    part.CFrame = CFrame.new(position or Vector3.zero)
                    part.Parent = folder
        
                    local attachment = Instance.new("Attachment")
                    attachment.Parent = part
        
                    local emitter = Instance.new("ParticleEmitter")
                    emitter.Texture = "rbxasset://textures/particles/sparkles_main.dds"
                    emitter.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(90, 130, 255))
                    emitter.LightEmission = 1
                    emitter.Lifetime = NumberRange.new(0.35, 0.9)
                    emitter.Speed = NumberRange.new(28, 58)
                    emitter.SpreadAngle = Vector2.new(180, 180)
                    emitter.Drag = 4
                    emitter.Rate = 0
                    emitter.Size = NumberSequence.new({
                        NumberSequenceKeypoint.new(0, 0.8),
                        NumberSequenceKeypoint.new(1, 0),
                    })
                    emitter.Parent = attachment
                    emitter:Emit(90)
        
                    local light = Instance.new("PointLight")
                    light.Color = part.Color
                    light.Brightness = 5
                    light.Range = 18
                    light.Parent = part
        
                    TweenService:Create(part, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        Size = Vector3.new(9, 9, 9),
                        Transparency = 1,
                    }):Play()
                    TweenService:Create(light, TweenInfo.new(0.45), {Brightness = 0, Range = 0}):Play()
        
                    task.delay(2, function()
                        if folder and folder.Parent then folder:Destroy() end
                    end)
                    return true
                end
        
        
        
                local function playLocalExplosion(position)
                    if not getgenv().explosionChanger then return false end
                    local selectedExplosion = getSelectedExplosionName()
                    if selectedExplosion == "" then return false end
                    local template = findExplosionEffectTemplate(selectedExplosion)
                    if not template then return playSyntheticExplosion(position) end
        
                    local clone = template:Clone()
                    clone.Name = "AzureExplosion_" .. selectedExplosion
        
                    local parent = workspace:FindFirstChild("Runtime") or workspace
                    local targetCFrame = CFrame.new(position or Vector3.zero)
        
                    if clone:IsA("Attachment") then
                        local folder = Instance.new("Folder")
                        folder.Name = "AzureExplosion_" .. selectedExplosion
                        folder.Parent = parent
        
                        local anchor = Instance.new("Part")
                        anchor.Name = "AzureExplosionAnchor"
                        anchor.Anchored = true
                        anchor.CanCollide = false
                        anchor.CanTouch = false
                        anchor.CanQuery = false
                        anchor.Transparency = 1
                        anchor.Size = Vector3.new(1, 1, 1)
                        anchor.CFrame = targetCFrame
                        anchor.Parent = folder
        
                        clone.Parent = anchor
                        clone = folder
                    else
                        clone.Parent = parent
                    end
        
                    if clone:IsA("Model") then
                        pcall(function() clone:PivotTo(targetCFrame) end)
                    elseif clone:IsA("BasePart") then
                        clone.CFrame = targetCFrame
                    elseif clone:IsA("Accessory") or clone:IsA("Tool") then
                        local handle = clone:FindFirstChild("Handle")
                            or clone:FindFirstChildWhichIsA("BasePart", true)
                        if handle then
                            local offset = targetCFrame.Position - handle.Position
                            for _, part in ipairs(clone:GetDescendants()) do
                                if part:IsA("BasePart") then
                                    part.CFrame = part.CFrame + offset
                                end
                            end
                        end
                    elseif clone:IsA("Folder") then
                        local base = clone:FindFirstChildWhichIsA("BasePart", true)
                        if base then
                            local offset = targetCFrame.Position - base.Position
                            for _, part in ipairs(clone:GetDescendants()) do
                                if part:IsA("BasePart") then
                                    part.CFrame = part.CFrame + offset
                                end
                            end
                        else
                            local anchor = Instance.new("Part")
                            anchor.Name = "AzureExplosionAnchor"
                            anchor.Anchored = true
                            anchor.CanCollide = false
                            anchor.CanTouch = false
                            anchor.CanQuery = false
                            anchor.Transparency = 1
                            anchor.Size = Vector3.new(1, 1, 1)
                            anchor.CFrame = targetCFrame
                            anchor.Parent = clone
                            for _, child in ipairs(clone:GetDescendants()) do
                                if child:IsA("Attachment") and not child.Parent:IsA("BasePart") then
                                    child.Parent = anchor
                                end
                            end
                        end
                    end
        
                    activateLocalExplosionObject(clone)
                    task.delay(8, function()
                        if clone and clone.Parent then clone:Destroy() end
                    end)
                    return true
                end
        
                local function isAzureExplosionObject(object)
                    local current = object
                    while current and current ~= workspace do
                        if type(current.Name) == "string"
                            and current.Name:find("AzureExplosion", 1, true) then
                            return true
                        end
                        current = current.Parent
                    end
                    return false
                end
        
                local function hideNativeExplosionVisual(object)
                    if not object or isAzureExplosionObject(object) then return end
                    local objects = { object }
                    for _, descendant in ipairs(object:GetDescendants()) do
                        objects[#objects + 1] = descendant
                    end
        
                    for _, item in ipairs(objects) do
                        pcall(function()
                            if item:IsA("BasePart") then
                                item.Transparency = 1
                                item.LocalTransparencyModifier = 1
                                item.CanCollide = false
                                item.CanTouch = false
                                item.CanQuery = false
                            elseif item:IsA("ParticleEmitter") then
                                item.Enabled = false
                                item.Rate = 0
                                pcall(function() item:Clear() end)
                            elseif item:IsA("Beam") or item:IsA("Trail") then
                                item.Enabled = false
                            elseif item:IsA("Light") then
                                item.Enabled = false
                                item.Brightness = 0
                                item.Range = 0
                            elseif item:IsA("Sound") then
                                item.Volume = 0
                                pcall(function() item:Stop() end)
                            end
                        end)
                    end
                end
        
                local function shouldHideNativeExplosionObject(object)
                    if not getgenv().explosionChanger then return false end
                    if (getgenv()._azExplosionLocalKillUntil or 0) <= os.clock() then return false end
                    if isAzureExplosionObject(object) then return false end
        
                    local key = normalizeExplosionName(object and object.Name or "")
                    if key:find("explosion", 1, true)
                        or key:find("explode", 1, true)
                        or key:find("effect", 1, true)
                        or key:find("vfx", 1, true)
                        or key:find("burst", 1, true)
                        or key:find("kill", 1, true) then
                        return true
                    end
        
                    local parent = object and object.Parent
                    local parentKey = normalizeExplosionName(parent and parent.Name or "")
                    return parentKey == "runtime" and (
                        object:IsA("Folder")
                        or object:IsA("Model")
                        or object:IsA("BasePart")
                        or object:IsA("Attachment")
                    )
                end
        
                local function maybeHideNativeExplosionObject(object)
                    if not shouldHideNativeExplosionObject(object) then return end
                    hideNativeExplosionVisual(object)
                    task.delay(0.03, function() hideNativeExplosionVisual(object) end)
                    task.delay(0.12, function() hideNativeExplosionVisual(object) end)
                    task.delay(0.3, function() hideNativeExplosionVisual(object) end)
                end
        
                local function hookNativeExplosionSuppressor(container)
                    if not container or nativeExplosionSuppressorHooked[container] then return end
                    nativeExplosionSuppressorHooked[container] = true
                    container.ChildAdded:Connect(maybeHideNativeExplosionObject)
                end
        
                local function suppressNativeExplosionsNow()
                    for _, container in ipairs({ workspace:FindFirstChild("Runtime"), workspace }) do
                        if container then
                            for _, child in ipairs(container:GetChildren()) do
                                maybeHideNativeExplosionObject(child)
                            end
                        end
                    end
                end
        
                local function isLocalKillStatName(name)
                    local key = tostring(name or ""):lower()
                    return key == "elims"
                        or key == "elim"
                        or key == "eliminations"
                        or key == "kills"
                        or key == "kill"
                        or key == "kos"
                        or key == "knockouts"
                end
        
                local function numericStatValue(value)
                    if type(value) == "number" then return value end
                    if type(value) == "string" then return tonumber(value) end
                    if typeof(value) == "Instance" then
                        if value:IsA("IntValue")
                            or value:IsA("NumberValue")
                            or value:IsA("StringValue") then
                            return tonumber(value.Value)
                        end
                    end
                    return nil
                end
        
                local function getLocalKillStatTotal()
                    local total = 0
                    local found = false
                    local leaderstats = LocalPlayer:FindFirstChild("leaderstats")
                    if leaderstats then
                        for _, stat in ipairs(leaderstats:GetChildren()) do
                            if isLocalKillStatName(stat.Name) then
                                local value = numericStatValue(stat)
                                if value then
                                    total = total + value
                                    found = true
                                end
                            end
                        end
                    end
                    for _, attributeName in ipairs({"PlayerElims", "Elims", "Eliminations", "Kills", "KillCount", "Knockouts"}) do
                        local attributeValue = LocalPlayer:GetAttribute(attributeName)
                        local value = numericStatValue(attributeValue)
                        if value then
                            total = total + value
                            found = true
                        end
                    end
                    return found and total or nil
                end
        
                local function playPendingKillExplosion()
                    if not getgenv().explosionChanger and (not getgenv().finisherModel or getgenv().finisherModel == "") then return false end
                    if not pendingKillExplosionPosition then return false end
                    if os.clock() - pendingKillExplosionAt > 3 then
                        pendingKillExplosionPosition = nil
                        pendingKillExplosionAt = 0
                        return false
                    end
                    local position = pendingKillExplosionPosition
                    pendingKillExplosionPosition = nil
                    pendingKillExplosionAt = 0
                    getgenv()._azExplosionLocalKillUntil = os.clock() + 1.25
                    if lastLocalExplosionPlayedPosition
                        and os.clock() - lastLocalExplosionPlayedAt < 0.25
                        and (lastLocalExplosionPlayedPosition - position).Magnitude < 8 then
                        return false
                    end
                    lastLocalExplosionPlayedAt = os.clock()
                    lastLocalExplosionPlayedPosition = position
                    return playLocalExplosion(position)
                end
        
                local function queueKillExplosion(position)
                    pendingKillExplosionPosition = position
                    pendingKillExplosionAt = os.clock()
                    if os.clock() - lastLocalKillAt <= 2.5 then
                        playPendingKillExplosion()
                    end
                end
        
                local function markLocalKill(position)
                    lastLocalKillAt = os.clock()
                    getgenv()._azExplosionLocalKillUntil = os.clock() + 1.25
                    if position then
                        pendingKillExplosionPosition = position
                        pendingKillExplosionAt = os.clock()
                    end
                    suppressNativeExplosionsNow()
                    return playPendingKillExplosion()
                end
        
                local function startLocalKillStatWatcher()
                    if killStatWatcherStarted then return end
                    killStatWatcherStarted = true
                    task.spawn(function()
                        while task.wait(0.6) do
                            local total = getLocalKillStatTotal()
                            if total then
                                if lastLocalKillStatTotal == nil then
                                    lastLocalKillStatTotal = total
                                elseif total > lastLocalKillStatTotal then
                                    lastLocalKillStatTotal = total
                                    markLocalKill()
                                elseif total < lastLocalKillStatTotal then
                                    lastLocalKillStatTotal = total
                                end
                            end
                        end
                    end)
                end
        
                local function patchExplosionTable(tbl, remoteKey, selectedExplosion, depth)
                    if type(tbl) ~= "table" or depth > 2 then return false end
                    local changed = false
                    for key, value in pairs(tbl) do
                        local keyText = tostring(key):lower()
                        if type(value) == "string" then
                            local keyLooksRight = keyText:find("explosion", 1, true)
                                or keyText:find("effect", 1, true)
                                or keyText:find("fx", 1, true)
                            if keyLooksRight or isKnownExplosionName(value) then
                                tbl[key] = selectedExplosion
                                changed = true
                            end
                        elseif type(value) == "table" then
                            changed = patchExplosionTable(value, remoteKey, selectedExplosion, depth + 1) or changed
                        end
                    end
                    return changed
                end
        
                local function patchExplosionArgs(remoteName, args, isOurKill)
                    if not getgenv().explosionChanger then return args end
                    local selectedExplosion = getSelectedExplosionName()
                    if type(selectedExplosion) ~= "string" or selectedExplosion == "" then return args end
                    if not isOurKill then return args end
        
                    local remoteKey = tostring(remoteName):lower()
                    local isExplosionRemote = remoteKey:find("explosion", 1, true) ~= nil
                    local localRelated = argsMentionLocal(args)
        
                    local changed = false
        
                    for index, arg in ipairs(args) do
                        if type(arg) == "string" and not isPlayerString(arg) then
                            local valueKey = arg:lower()
                            local shouldPatch = isKnownExplosionName(arg)
                                or isExplosionRemote
                                or (localRelated and (
                                    valueKey:find("explosion", 1, true)
                                    or valueKey:find("effect", 1, true)
                                    or valueKey:find("fx", 1, true)
                                ))
                            if shouldPatch then
                                args[index] = selectedExplosion
                                changed = true
                            end
                        elseif type(arg) == "table" then
                            changed = patchExplosionTable(arg, remoteKey, selectedExplosion, 0) or changed
                        end
                    end
        
                    if isExplosionRemote and not changed then
                        for index, arg in ipairs(args) do
                            if type(arg) == "string" and not isPlayerString(arg) then
                                args[index] = selectedExplosion
                                break
                            end
                        end
                    end
        
                    return args
                end
        
                local function invokeExplosionRemote(remote, explosionName)
                    if not remote or type(explosionName) ~= "string" or explosionName == "" then return false end
                    local fired = false
                    for _, args in ipairs({
                        {explosionName},
                        {"Explosion", explosionName},
                        {"ExplosionFX", explosionName},
                        {"KillEffect", explosionName},
                        {explosionName, "Explosion"},
                        {explosionName, "ExplosionFX"},
                    }) do
                        local ok = pcall(function()
                            if remote:IsA("RemoteFunction") then
                                remote:InvokeServer(unpack(args))
                            elseif remote:IsA("RemoteEvent") then
                                remote:FireServer(unpack(args))
                            end
                        end)
                        fired = ok or fired
                    end
                    return fired
                end
        
                local function isExplosionBindable(instance)
                    if typeof(instance) ~= "Instance" or not instance:IsA("BindableFunction") then return false end
                    local nameKey = normalizeExplosionName(instance.Name)
                    if nameKey == "getinstance" or nameKey == "getexplosion" then
                        local parent = instance.Parent
                        while parent and parent ~= rs do
                            if normalizeExplosionName(parent.Name):find("explosion", 1, true) then
                                return true
                            end
                            parent = parent.Parent
                        end
                    end
                    local ok, fullName = pcall(function() return instance:GetFullName() end)
                    if not ok then return false end
                    local pathKey = normalizeExplosionName(fullName)
                    return pathKey:find("replicatedinstancesexplosions", 1, true) ~= nil
                        or pathKey:find("miscexplosions", 1, true) ~= nil
                        or pathKey:find("miscdataexplosions", 1, true) ~= nil
                end
        
                local function installExplosionBindableHook()
                    if bindableInvokeHooked then return end
                    local hookFunction = getExecutorGlobal("hookfunction") or getExecutorGlobal("hookfunc")
                    local makeClosure = getExecutorGlobal("newcclosure") or function(callback) return callback end
                    if type(hookFunction) ~= "function" then return end
        
                    local dummyBindable = Instance.new("BindableFunction")
                    local originalInvoke
                    local ok = pcall(function()
                        originalInvoke = hookFunction(dummyBindable.Invoke, makeClosure(function(self, ...)
                            local args = { ... }
                            local localKillWindow = (getgenv()._azExplosionLocalKillUntil or 0) > os.clock()
                            if getgenv().explosionChanger and localKillWindow and isExplosionBindable(self) then
                                local selectedExplosion = getSelectedExplosionName()
                                if selectedExplosion ~= "" then
                                    for index, value in ipairs(args) do
                                        if type(value) == "string" and not isPlayerString(value) then
                                            args[index] = selectedExplosion
                                            break
                                        end
                                    end
                                    if #args == 0 then
                                        args[1] = selectedExplosion
                                    end
                                end
                            end
                            return originalInvoke(self, unpack(args))
                        end))
                    end)
                    dummyBindable:Destroy()
                    bindableInvokeHooked = ok == true
                end
        
                local function findExplosionEquipRemotes()
                    local remotes = {}
                    local store = rs:FindFirstChild("Remotes") and rs.Remotes:FindFirstChild("Store")
                    local net = getNetFolder()
                    local function addRemote(remote)
                        if not remote then return end
                        for _, existing in ipairs(remotes) do
                            if existing == remote then return end
                        end
                        table.insert(remotes, remote)
                    end
        
                    if store then
                        for _, remoteName in ipairs({
                            "RequestEquipExplosionFX",
                            "RequestEquipExplosion",
                            "RequestEquipExplosionEffect",
                            "RequestEquipExplosionSkin",
                            "RequestEquipKillEffect",
                            "RequestEquipKillExplosion",
                        }) do
                            local remote = store:FindFirstChild(remoteName)
                            addRemote(remote)
                        end
                    end
        
                    local netRemote = net and (
                        net:FindFirstChild("RF/RequestEquipExplosion")
                        or net:FindFirstChild("RE/RequestEquipExplosion")
                        or net:FindFirstChild("RF/RequestEquipExplosionFX")
                        or net:FindFirstChild("RE/RequestEquipExplosionFX")
                    )
                    addRemote(netRemote)
        
                    if #remotes == 0 then
                        for _, obj in ipairs(rs:GetDescendants()) do
                            if obj:IsA("RemoteFunction") or obj:IsA("RemoteEvent") then
                                local key = obj.Name:lower()
                                if key:find("requestequip", 1, true) and key:find("explosion", 1, true) then
                                    addRemote(obj)
                                end
                            end
                        end
                    end
        
                    return remotes
                end
        
                getgenv().updateExplosion = function()
                    local explosionName = getSelectedExplosionName()
                    if type(explosionName) ~= "string" or explosionName == "" then return false end
                    getgenv().explosionFX = explosionName
        
                    pcall(function() LocalPlayer:SetAttribute("CurrentlyEquippedExplosion", explosionName) end)
                    pcall(function() LocalPlayer:SetAttribute("CurrentlyEquippedExplosionFX", explosionName) end)
                    pcall(function() LocalPlayer:SetAttribute("EquippedExplosion", explosionName) end)
                    pcall(function() LocalPlayer:SetAttribute("EquippedExplosionFX", explosionName) end)
                    pcall(function() LocalPlayer:SetAttribute("SelectedExplosion", explosionName) end)
                    pcall(function() LocalPlayer:SetAttribute("SelectedExplosionFX", explosionName) end)
                    pcall(function() LocalPlayer:SetAttribute("CurrentExplosion", explosionName) end)
                    pcall(function() LocalPlayer:SetAttribute("CurrentExplosionFX", explosionName) end)
                    pcall(function() LocalPlayer:SetAttribute("KillEffect", explosionName) end)
                    pcall(function() LocalPlayer:SetAttribute("EquippedKillEffect", explosionName) end)
                    if LocalPlayer.Character then
                        pcall(function() LocalPlayer.Character:SetAttribute("CurrentlyEquippedExplosion", explosionName) end)
                        pcall(function() LocalPlayer.Character:SetAttribute("CurrentlyEquippedExplosionFX", explosionName) end)
                        pcall(function() LocalPlayer.Character:SetAttribute("EquippedExplosion", explosionName) end)
                        pcall(function() LocalPlayer.Character:SetAttribute("EquippedExplosionFX", explosionName) end)
                        pcall(function() LocalPlayer.Character:SetAttribute("SelectedExplosion", explosionName) end)
                        pcall(function() LocalPlayer.Character:SetAttribute("SelectedExplosionFX", explosionName) end)
                        pcall(function() LocalPlayer.Character:SetAttribute("CurrentExplosion", explosionName) end)
                        pcall(function() LocalPlayer.Character:SetAttribute("CurrentExplosionFX", explosionName) end)
                        pcall(function() LocalPlayer.Character:SetAttribute("KillEffect", explosionName) end)
                        pcall(function() LocalPlayer.Character:SetAttribute("EquippedKillEffect", explosionName) end)
                    end
        
                    if getgenv().saveLastEquippedExplosion then
                        getgenv().saveLastEquippedExplosion(explosionName)
                    end
        
                    installExplosionBindableHook()
                    local fired = false
                    for _, remote in ipairs(findExplosionEquipRemotes()) do
                        fired = invokeExplosionRemote(remote, explosionName) or fired
                    end
                    return fired
                end
        
                getgenv().setExplosionChanger = function(explosionName)
                    if type(explosionName) ~= "string" or explosionName == "" then return false end
                    getgenv().explosionFX = explosionName
                    getgenv().explosionChanger = true
                    if getgenv().setExplosionChangerToggleUI then getgenv().setExplosionChangerToggleUI(true) end
                    if getgenv().setExplosionInputUI then getgenv().setExplosionInputUI(explosionName) end
                    return getgenv().updateExplosion()
                end
        
                getgenv().testExplosion = function()
                    local character = LocalPlayer.Character
                    local root = character and (character:FindFirstChild("HumanoidRootPart") or character.PrimaryPart)
                    local camera = workspace.CurrentCamera
                    local position = root and (root.Position + root.CFrame.LookVector * 7)
                        or camera and (camera.CFrame.Position + camera.CFrame.LookVector * 12)
                        or Vector3.zero
                    return playLocalExplosion(position)
                end
        
                installExplosionBindableHook()
                startLocalKillStatWatcher()
                hookNativeExplosionSuppressor(workspace:FindFirstChild("Runtime"))
                hookNativeExplosionSuppressor(workspace)
                workspace.ChildAdded:Connect(function(child)
                    if child.Name == "Runtime" then
                        hookNativeExplosionSuppressor(child)
                    end
                    maybeHideNativeExplosionObject(child)
                end)
        
                local function hookDeadFolder()
                    if deadFolderHooked then return end
                    local deadFolder = workspace:FindFirstChild("Dead")
                    if not deadFolder then return end
                    deadFolderHooked = true
                    deadFolder.ChildAdded:Connect(function(character)
                        if not getgenv().explosionChanger and (not getgenv().finisherModel or getgenv().finisherModel == "") then return end
                        task.wait(0.05)
                        if character == LocalPlayer.Character then return end
        
                        local root = character and (character:FindFirstChild("HumanoidRootPart") or character.PrimaryPart)
                        if root then
                            local creator = character:FindFirstChild("creator", true) or character:FindFirstChild("Creator", true)
                            local characterPlayer = Players:GetPlayerFromCharacter(character)
                                or Players:FindFirstChild(tostring(character and character.Name or ""))
                            
                            local isLocalKill = false
                            if creator and (creator.Value == LocalPlayer or creator.Value == LocalPlayer.Name) then
                                isLocalKill = true
                                markLocalKill(root.Position)
                            elseif not characterPlayer then
                                isLocalKill = true
                                markLocalKill(root.Position)
                            else
                                queueKillExplosion(root.Position)
                            end
                            
                            if isLocalKill and getgenv().finisherModel and getgenv().finisherModel ~= "" and getgenv()._azFCModule then
                                if not characterPlayer then
                                    task.spawn(function()
                                        local s = pcall(function()
                                            getgenv()._azFCModule:Play(getgenv().finisherModel, character)
                                        end)
                                        if not s then
                                            pcall(function()
                                                getgenv()._azFCModule:Play(character, getgenv().finisherModel)
                                            end)
                                        end
                                    end)
                                end
                            end
                        end
                    end)
                end
        
                hookDeadFolder()
                workspace.ChildAdded:Connect(function(child)
                    if child.Name == "Dead" then
                        deadFolderHooked = false
                        task.defer(hookDeadFolder)
                    end
                end)
        
                LocalPlayer.CharacterAdded:Connect(function(character)
                    task.wait(0.75)
                    if getgenv().explosionChanger and getgenv().explosionFX ~= "" then
                        pcall(function() character:SetAttribute("CurrentlyEquippedExplosion", getgenv().explosionFX) end)
                        pcall(getgenv().updateExplosion)
                    end
                end)
        
                local remotesToHook = {"PlayExplosionEffect", "Killed", "OnPlayerKilled", "OnDeath"}
                while task.wait(1) do
                    local remotesFolder = rs:FindFirstChild("Remotes")
                    if remotesFolder then
                        for _, remoteName in ipairs(remotesToHook) do
                            local remote = remotesFolder:FindFirstChild(remoteName)
                            if remote and remote:IsA("RemoteEvent") then
                                if not explosionDirectHooked[remote] then
                                    explosionDirectHooked[remote] = true
                                    remote.OnClientEvent:Connect(function(...)
                                        if not getgenv().explosionChanger then return end
                                        local rawArgs = { ... }
                                        local position = getExplosionPositionFromArgs(rawArgs)
                                        local isOurKill = argsIndicateLocalKill(rawArgs, remoteName)
        
                                        if isOurKill then
                                            markLocalKill(position)
                                        elseif remoteName ~= "PlayExplosionEffect" then
                                            queueKillExplosion(position)
                                        end
                                    end)
                                end
                                local ok, connections = pcall(getconnections, remote.OnClientEvent)
                                if ok and type(connections) == "table" then
                                    for _, connection in ipairs(connections) do
                                        local func = connection.Function
                                        if func and not explosionHookedFuncs[func] then
                                            if isourclosure and isourclosure(func) then
                                                explosionHookedFuncs[func] = true
                                                continue
                                            end
                                            explosionHookedFuncs[func] = true
                                            connection:Disable()
                                            local targetFunc = func
                                            local ourFunc
                                            ourFunc = function(...)
                                                local rawArgs = { ... }
                                                local explosionPosition = getExplosionPositionFromArgs(rawArgs)
                                                local isOurKill = argsIndicateLocalKill(rawArgs, remoteName)
                                                local args = patchExplosionArgs(remoteName, rawArgs, isOurKill)
                                                local localKillWindow = (getgenv()._azExplosionLocalKillUntil or 0) > os.clock()
        
                                                if getgenv().explosionChanger then
                                                    if isOurKill then
                                                        markLocalKill(explosionPosition)
                                                    elseif remoteName ~= "PlayExplosionEffect" then
                                                        queueKillExplosion(explosionPosition)
                                                    end
                                                    if remoteName == "PlayExplosionEffect" and (isOurKill or localKillWindow) then
                                                        return
                                                    end
                                                end
                                                if setthreadidentity then pcall(setthreadidentity, 2) end
                                                pcall(targetFunc, unpack(args))
                                            end
                                            explosionHookedFuncs[ourFunc] = true
                                            remote.OnClientEvent:Connect(ourFunc)
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end)
        
        
            getgenv().selectedEmote = getgenv().selectedEmote or ""
            getgenv().emoteVFXEnabled = false  
            getgenv().emoteLooped = false  
            
            getgenv()._azEmoteSlotStore = getgenv()._azEmoteSlotStore or {}
            do
                local EMOTE_SLOTS_FILE = "Azure/emote_slots.json"
                pcall(function()
                    if isfile and isfile(EMOTE_SLOTS_FILE) then
                        local decoded = HttpService:JSONDecode(readfile(EMOTE_SLOTS_FILE))
                        if type(decoded) == "table" then getgenv()._azEmoteSlotStore = decoded end
                    end
                end)
                getgenv()._azSaveEmoteSlots = function()
                    pcall(function()
                        if isfolder and makefolder and not isfolder("Azure") then makefolder("Azure") end
                        if not writefile then return end
                        writefile(EMOTE_SLOTS_FILE, HttpService:JSONEncode(getgenv()._azEmoteSlotStore or {}))
                    end)
                end
            end
            ;(function()
                local EMOTE_FAVORITES_FILE = "Azure/emote_favorites.json"
                local function loadEmoteFavorites()
                    local favorites = {}
                    pcall(function()
                        if isfile and isfile(EMOTE_FAVORITES_FILE) then
                            local decoded = HttpService:JSONDecode(readfile(EMOTE_FAVORITES_FILE))
                            if type(decoded) == "table" then
                                for _, name in ipairs(decoded) do
                                    if type(name) == "string" and name ~= "" then
                                        favorites[name] = true
                                    end
                                end
                            end
                        end
                    end)
                    return favorites
                end
        
                local function saveEmoteFavorites(favorites)
                    pcall(function()
                        if isfolder and makefolder and not isfolder("Azure") then
                            makefolder("Azure")
                        end
                        if not writefile then return end
        
                        local names = {}
                        for name in pairs(favorites or {}) do
                            names[#names + 1] = name
                        end
                        table.sort(names)
                        writefile(EMOTE_FAVORITES_FILE, HttpService:JSONEncode(names))
                    end)
                end
        
                local previousState = getgenv()._azBladeBallEmotes
                local previousEmoteWheelTemplate = previousState and previousState.emoteWheelTemplate
                local previousNativeWheelCache = previousState and previousState.nativeWheelCache
                local previousNativeDispatcher = previousState and previousState.nativeDispatcher
                if previousState and type(previousState.Destroy) == "function" then
                    pcall(previousState.Destroy)
                end
        
                local state = {
                    catalog = {},
                    byName = {},
                    activeTrack = nil,
                    activeSounds = {},
                    activeVFX = {},
                    markerConnections = {},
                    playedSoundKeys = {},
                    observerExports = {},
                    observersInitialized = false,
                    activeOriginal = nil,
                    activeSelected = nil,
                    capturedVFXPayload = nil,
                    overrideUntil = 0,
                    playToken = 0,
                    mediaStartedAt = 0,
                    mediaCueToken = 0,
                    firedMediaCues = {},
                    boundCueTrack = nil,
                    boundCueToken = 0,
                    diedConnection = nil,
                    characterConnection = nil,
                    wheelConnection = nil,
                    emoteWheelTemplate = previousEmoteWheelTemplate,
                    nativeWheelCache = previousNativeWheelCache,
                    nativeDispatcher = previousNativeDispatcher,
                    applyingEmoteWheel = false,
                    emoteWheelEnabled = false,  
                    destroyed = false,
                    favorites = getgenv()._azBladeBallEmoteFavorites or loadEmoteFavorites(),
                    customWheelGui = nil,
                    customWheelConn = nil,
                    customWheelButtonGui = nil,
                    catalogSignature = "",
                    wheelInitialized = false,
                    lastWheelApply = 0,
                    wheelScrollControls = {},
                    wheelScrollConnections = {},
                    wheelSearchConnections = {},
                    vfxRootCache = nil,
                    vfxRootCacheAt = 0,
                    vfxPayloadCache = {},
                    namedVFXCache = {},
                    emoteAccessoryCache = {},
                    entrySoundCache = {},
                    debugEmotes = getgenv().AzureEmoteDebug == true,
                }
                getgenv()._azBladeBallEmotes = state
                getgenv()._azBladeBallEmoteFavorites = state.favorites
        
                local function emoteDebugWarn(...)
                    if state.debugEmotes then warn(...) end
                end
        
                local hooks = getgenv()._azBladeBallEmoteHooks or {}
                if hooks.version ~= 2 then
                    hooks.version = 2
                    hooks.bindableFunction = false
                    hooks.bindableEvent = false
                    hooks.remoteEvent = false
                    hooks.remoteFunction = false
                    hooks.animator = false
                    hooks.humanoid = false
                end
                if hooks.clone == nil then hooks.clone = false end
                hooks.activeState = state
                getgenv()._azBladeBallEmoteHooks = hooks
        
                local function normalize(value)
                    return tostring(value or ""):lower():gsub("[^%w]", "")
                end
        
                local function assetId(value)
                    return tostring(value or ""):match("%d+")
                end
        
                local soundIndexByName = {}
                local soundIndexByID = {}
                local soundIndexLastUpdate = 0
        
                local function rebuildSoundIndex()
                    table.clear(soundIndexByName)
                    table.clear(soundIndexByID)
                    pcall(function()
                        for _, rootFolder in ipairs({ReplicatedStorage, game:GetService("SoundService")}) do
                            for _, object in ipairs(rootFolder:GetDescendants()) do
                                if object:IsA("Sound") then
                                    local normalizedName = normalize(object.Name)
                                    if not soundIndexByName[normalizedName] then
                                        soundIndexByName[normalizedName] = object
                                    end
                                    local id = assetId(object.SoundId)
                                    if id and not soundIndexByID[id] then
                                        soundIndexByID[id] = object
                                    end
                                end
                            end
                        end
                    end)
                    soundIndexLastUpdate = os.clock()
                end
        
                local function getSoundByName(name)
                    if os.clock() - soundIndexLastUpdate > 15 or not next(soundIndexByName) then
                        rebuildSoundIndex()
                    end
                    return soundIndexByName[normalize(name)]
                end
        
                local function getInstanceAttribute(instance, names)
                    if typeof(instance) ~= "Instance" then return nil end
                    for _, name in ipairs(names) do
                        local ok, value = pcall(function()
                            return instance:GetAttribute(name)
                        end)
                        if ok and value ~= nil and tostring(value) ~= "" then
                            return value
                        end
                    end
                    return nil
                end
        
                local function getEntryAttribute(entry, names)
                    if entry and entry.Attributes then
                        for _, name in ipairs(names) do
                            local value = entry.Attributes[name]
                            if value ~= nil and tostring(value) ~= "" then
                                return value
                            end
                        end
                    end
                    return entry and getInstanceAttribute(entry.Animation, names) or nil
                end
        
                local function findCharacterObject(character, name, className)
                    local wanted = normalize(name)
                    if not character or wanted == "" then return nil end
                    for _, object in ipairs(character:GetDescendants()) do
                        if (not className or object:IsA(className))
                            and normalize(object.Name) == wanted then
                            return object
                        end
                    end
                    return nil
                end
        
                local function findCharacterPart(character, names)
                    if not character then return nil end
                    for _, name in ipairs(names) do
                        local part = character:FindFirstChild(name)
                        if part and part:IsA("BasePart") then return part end
                    end
                    for _, name in ipairs(names) do
                        local wanted = normalize(name)
                        for _, object in ipairs(character:GetDescendants()) do
                            if object:IsA("BasePart") and normalize(object.Name) == wanted then
                                return object
                            end
                        end
                    end
                    return nil
                end
        
                local function resolveRigAnchorFromHint(character, hint)
                    local key = normalize(hint)
                    if key == "" then return nil end
        
                    local exactAttachment = findCharacterObject(character, hint, "Attachment")
                    if exactAttachment then return exactAttachment end
                    local exactPart = findCharacterObject(character, hint, "BasePart")
                    if exactPart then return exactPart end
        
                    local function has(text)
                        return key:find(text, 1, true) ~= nil
                    end
        
                    if has("righthand") or (has("right") and (has("hand") or has("palm") or has("grip"))) then
                        return findCharacterPart(character, {"RightHand", "Right Arm", "RightLowerArm", "RightUpperArm"})
                    end
                    if has("lefthand") or (has("left") and (has("hand") or has("palm") or has("grip"))) then
                        return findCharacterPart(character, {"LeftHand", "Left Arm", "LeftLowerArm", "LeftUpperArm"})
                    end
                    if has("rightarm") or (has("right") and has("arm")) then
                        return findCharacterPart(character, {"RightLowerArm", "RightUpperArm", "Right Arm", "RightHand"})
                    end
                    if has("leftarm") or (has("left") and has("arm")) then
                        return findCharacterPart(character, {"LeftLowerArm", "LeftUpperArm", "Left Arm", "LeftHand"})
                    end
                    if has("rightfoot") or (has("right") and (has("foot") or has("leg"))) then
                        return findCharacterPart(character, {"RightFoot", "Right Leg", "RightLowerLeg", "RightUpperLeg"})
                    end
                    if has("leftfoot") or (has("left") and (has("foot") or has("leg"))) then
                        return findCharacterPart(character, {"LeftFoot", "Left Leg", "LeftLowerLeg", "LeftUpperLeg"})
                    end
                    if has("head") or has("face") then
                        return findCharacterPart(character, {"Head"})
                    end
                    if has("torso") or has("chest") or has("body") then
                        return findCharacterPart(character, {"UpperTorso", "Torso", "LowerTorso", "HumanoidRootPart"})
                    end
                    if has("root") or has("hrp") or has("waist") then
                        return findCharacterPart(character, {"HumanoidRootPart", "LowerTorso", "Torso"})
                    end
                    return nil
                end
        
                local function collectAnchorHints(source, entry)
                    local hints = {}
                    local function add(value)
                        if value ~= nil and tostring(value) ~= "" then
                            hints[#hints + 1] = tostring(value)
                        end
                    end
        
                    add(getEntryAttribute(entry, {
                        "AzureAttachTo",
                        "AzureBindTo",
                        "AzureVFXAttach",
                        "VFXAttachTo",
                        "AttachTo",
                        "TargetPart",
                        "TargetAttachment",
                        "AttachmentName",
                    }))
        
                    if typeof(source) == "Instance" then
                        add(getInstanceAttribute(source, {
                            "AzureAttachTo",
                            "AzureBindTo",
                            "AttachTo",
                            "TargetPart",
                            "TargetAttachment",
                            "AttachmentName",
                        }))
                        add(source.Name)
                        local scanned = 0
                        for _, object in ipairs(source:GetDescendants()) do
                            if object:IsA("Attachment") or object:IsA("BasePart") or object:IsA("Bone") then
                                add(object.Name)
                                scanned = scanned + 1
                                if scanned >= 24 then break end
                            end
                        end
                    end
        
                    return hints
                end
        
                local function resolveRigAnchor(character, source, entry, fallback)
                    for _, hint in ipairs(collectAnchorHints(source, entry)) do
                        local anchor = resolveRigAnchorFromHint(character, hint)
                        if anchor then return anchor end
                    end
                    return fallback
                end
        
                local function getAnchorPart(anchor, fallback)
                    if typeof(anchor) == "Instance" then
                        if anchor:IsA("BasePart") then return anchor end
                        if anchor:IsA("Attachment") and anchor.Parent and anchor.Parent:IsA("BasePart") then
                            return anchor.Parent
                        end
                    end
                    return fallback
                end
        
                local function getAnchorCFrame(anchor, fallback)
                    if typeof(anchor) == "Instance" then
                        if anchor:IsA("BasePart") then return anchor.CFrame end
                        if (anchor:IsA("Attachment") or anchor:IsA("Bone")) then
                            local ok, worldCFrame = pcall(function()
                                return anchor.WorldCFrame
                            end)
                            if ok and worldCFrame then return worldCFrame end
                        end
                    end
                    return fallback and fallback.CFrame or CFrame.new()
                end
        
                local function getEmotesFolder()
                    local folders = {}
                    
                    
                    local misc = ReplicatedStorage:FindFirstChild("Misc")
                    local emotes = misc and misc:FindFirstChild("Emotes")
                    if emotes then table.insert(folders, emotes) end
        
                    
                    local shared = ReplicatedStorage:FindFirstChild("Shared")
                    local replicatedInstances = ReplicatedStorage:FindFirstChild("ReplicatedInstances") or (shared and shared:FindFirstChild("ReplicatedInstances"))
                    if replicatedInstances then
                        emotes = replicatedInstances:FindFirstChild("Emotes")
                        if emotes and not table.find(folders, emotes) then
                            table.insert(folders, emotes)
                        end
                    end
                    
                    
                    for _, child in ipairs(ReplicatedStorage:GetDescendants()) do
                        if child:IsA("Folder") and child.Name == "Emotes" and not table.find(folders, child) then
                            table.insert(folders, child)
                        end
                    end
                    
                    return folders
                end
        
                local isEmoteVFXCache = {}
                local function isEmoteVFXRequest(instance)
                    if typeof(instance) ~= "Instance" then return false end
                    local cached = isEmoteVFXCache[instance]
                    if cached ~= nil then return cached end
        
                    local function compute()
                        local nameKey = normalize(instance.Name)
                        if nameKey == "getemotevfx" or nameKey == "getemoteeffect" then return true end
                        local ok, fullName = pcall(function() return instance:GetFullName() end)
                        if not ok then return false end
                        local pathKey = normalize(fullName)
                        if pathKey:find("replicatedinstancesemotevfx", 1, true) then return true end
                        if pathKey:find("replicatedinstancesemotes", 1, true)
                            or pathKey:find("miscemotes", 1, true) then
                            return true
                        end
                        if pathKey:find("emote", 1, true) then
                            return true
                        end
                        return nameKey:find("emote", 1, true) ~= nil
                    end
                    
                    local result = compute()
                    isEmoteVFXCache[instance] = result
                    return result
                end
        
                local function rewriteValue(value, fromEntry, toEntry, depth, seen)
                    if not fromEntry or not toEntry or depth > 5 then return value end
        
                    if type(value) == "string" then
                        local key = normalize(value)
                        if key == normalize(fromEntry.Name) then return toEntry.Name end
                        if key == normalize(fromEntry.Id) then return toEntry.Id end
                        if key == normalize(fromEntry.Animation.AnimationId) then
                            return toEntry.Animation.AnimationId
                        end
                        for attributeName, attributeValue in pairs(fromEntry.Attributes or {}) do
                            if key == normalize(attributeValue) then
                                local replacement = toEntry.Attributes
                                    and toEntry.Attributes[attributeName]
                                if replacement ~= nil then return replacement end
                            end
                        end
                        return value
                    end
        
                    if type(value) == "number" then
                        if tonumber(fromEntry.Id) and value == tonumber(fromEntry.Id) then
                            return tonumber(toEntry.Id) or value
                        end
                        local selectedAnimationId = tonumber(assetId(toEntry.Animation.AnimationId))
                        if value == tonumber(assetId(fromEntry.Animation.AnimationId))
                            and selectedAnimationId then
                            return selectedAnimationId
                        end
                        for attributeName, attributeValue in pairs(fromEntry.Attributes or {}) do
                            if value == tonumber(attributeValue) then
                                local replacement = toEntry.Attributes
                                    and tonumber(toEntry.Attributes[attributeName])
                                if replacement then return replacement end
                            end
                        end
                        return value
                    end
        
                    if typeof(value) == "Instance" and value:IsA("Animation") then
                        if value == fromEntry.Animation
                            or normalize(value.Name) == normalize(fromEntry.Id)
                            or normalize(value.AnimationId) == normalize(fromEntry.Animation.AnimationId) then
                            return toEntry.Animation
                        end
                        return value
                    end
        
                    if type(value) ~= "table" then return value end
                    seen = seen or {}
                    if seen[value] then return seen[value] end
        
                    local copy = {}
                    seen[value] = copy
                    for key, fieldValue in pairs(value) do
                        local rewrittenKey = rewriteValue(
                            key,
                            fromEntry,
                            toEntry,
                            depth + 1,
                            seen
                        )
                        copy[rewrittenKey] = rewriteValue(
                            fieldValue,
                            fromEntry,
                            toEntry,
                            depth + 1,
                            seen
                        )
                    end
                    return copy
                end
        
                local function getActiveOverride()
                    local active = hooks.activeState
                    if not active
                        or active.destroyed
                        or not active.activeOriginal
                        or not active.activeSelected
                        or os.clock() > active.overrideUntil then
                        return nil
                    end
                    return active
                end
        
                local function installHooks()
                    if hooks.animator
                        or hooks.humanoid
                        or hooks.clone
                        or hooks.bindableFunction
                        or hooks.bindableEvent
                        or hooks.remoteEvent
                        or hooks.remoteFunction then
                        return true
                    end
                    local hookFunction = getExecutorGlobal("hookfunction")
                    local makeClosure = getExecutorGlobal("newcclosure") or function(callback)
                        return callback
                    end
                    if type(hookFunction) ~= "function" then return false end
        
                    local function rewriteActiveArguments(...)
                        local args = {...}
                        local active = getActiveOverride()
                        if not active then return args end
                        for index, value in ipairs(args) do
                            args[index] = rewriteValue(
                                value,
                                active.activeOriginal,
                                active.activeSelected,
                                0,
                                {}
                            )
                        end
                        return args
                    end
        
                    local dummyBindableFunction = Instance.new("BindableFunction")
                    local dummyBindableEvent = Instance.new("BindableEvent")
                    local dummyRemoteEvent = Instance.new("RemoteEvent")
                    local dummyRemoteFunction = Instance.new("RemoteFunction")
                    local dummyAnimator = Instance.new("Animator")
                    local dummyHumanoid = Instance.new("Humanoid")
                    local dummyInstance = Instance.new("Folder")
        
                    if false and not hooks.bindableFunction then 
                        local bindableFunctionOriginal
                        hooks.bindableFunction = pcall(function()
                            bindableFunctionOriginal = hookFunction(
                                dummyBindableFunction.Invoke,
                                makeClosure(function(self, ...)
                                    if not getgenv().emoteVFXEnabled then return bindableFunctionOriginal(self, ...) end
                                    local active = hooks.activeState
                                    if active and not active.destroyed and active.activeOriginal and active.activeSelected and os.clock() <= active.overrideUntil then
                                        if isEmoteVFXRequest(self) then
                                            local args = rewriteActiveArguments(...)
                                            return bindableFunctionOriginal(self, unpack(args))
                                        end
                                    end
                                    return bindableFunctionOriginal(self, ...)
                                end)
                            )
                        end)
                    end
        
                    if false and not hooks.bindableEvent then 
                        local bindableEventOriginal
                        hooks.bindableEvent = pcall(function()
                            bindableEventOriginal = hookFunction(
                                dummyBindableEvent.Fire,
                                makeClosure(function(self, ...)
                                    if not getgenv().emoteVFXEnabled then return bindableEventOriginal(self, ...) end
                                    local active = hooks.activeState
                                    if active and not active.destroyed and active.activeOriginal and active.activeSelected and os.clock() <= active.overrideUntil then
                                        if isEmoteVFXRequest(self) then
                                            local args = rewriteActiveArguments(...)
                                            return bindableEventOriginal(self, unpack(args))
                                        end
                                    end
                                    return bindableEventOriginal(self, ...)
                                end)
                            )
                        end)
                    end
        
                    if false and not hooks.remoteEvent then 
                        local remoteEventOriginal
                        hooks.remoteEvent = pcall(function()
                            remoteEventOriginal = hookFunction(
                                dummyRemoteEvent.FireServer,
                                makeClosure(function(self, ...)
                                    if not getgenv().emoteVFXEnabled then return remoteEventOriginal(self, ...) end
                                    local active = hooks.activeState
                                    if active and not active.destroyed and active.activeOriginal and active.activeSelected and os.clock() <= active.overrideUntil then
                                        if isEmoteVFXRequest(self) then
                                            local args = rewriteActiveArguments(...)
                                            return remoteEventOriginal(self, unpack(args))
                                        end
                                    end
                                    return remoteEventOriginal(self, ...)
                                end)
                            )
                        end)
                    end
        
                    if false and not hooks.remoteFunction then 
                        local remoteFunctionOriginal
                        hooks.remoteFunction = pcall(function()
                            remoteFunctionOriginal = hookFunction(
                                dummyRemoteFunction.InvokeServer,
                                makeClosure(function(self, ...)
                                    if not getgenv().emoteVFXEnabled then return remoteFunctionOriginal(self, ...) end
                                    local active = hooks.activeState
                                    if active and not active.destroyed and active.activeOriginal and active.activeSelected and os.clock() <= active.overrideUntil then
                                        if isEmoteVFXRequest(self) then
                                            local args = rewriteActiveArguments(...)
                                            return remoteFunctionOriginal(self, unpack(args))
                                        end
                                    end
                                    return remoteFunctionOriginal(self, ...)
                                end)
                            )
                        end)
                    end
        
                    local function resolveAnimation(owner, animation)
                        local active = hooks.activeState
                        if not active or active.destroyed or not active.activeOriginal or not active.activeSelected or os.clock() > active.overrideUntil
                            or typeof(animation) ~= "Instance"
                            or not animation:IsA("Animation") then
                            return animation
                        end
        
                        local character = LocalPlayer.Character
                        if not character
                            or typeof(owner) ~= "Instance"
                            or not owner:IsDescendantOf(character) then
                            return animation
                        end
        
                        local original = active.activeOriginal
                        if animation == original.Animation
                            or normalize(animation.Name) == normalize(original.Id)
                            or normalize(animation.AnimationId) == normalize(original.Animation.AnimationId) then
                            return active.activeSelected.Animation
                        end
                        return animation
                    end
        
                    local function resolveVFXCloneSource(source)
                        local active = hooks.activeState
                        if not active or active.destroyed or not active.activeOriginal or not active.activeSelected or os.clock() > active.overrideUntil
                            or typeof(source) ~= "Instance"
                            or type(state.findNamedVFX) ~= "function"
                            or not isEmoteVFXRequest(source) then
                            return source
                        end
        
                        local originalAliases = {
                            [normalize(active.activeOriginal.Name)] = true,
                            [normalize(active.activeOriginal.Id)] = true,
                            [normalize(active.activeOriginal.Animation.AnimationId)] = true,
                        }
                        for _, value in pairs(active.activeOriginal.Attributes or {}) do
                            originalAliases[normalize(tostring(value))] = true
                        end
        
                        local cursor = source
                        local matchesOriginal = false
                        while cursor and cursor ~= ReplicatedStorage do
                            if originalAliases[normalize(cursor.Name)] then
                                matchesOriginal = true
                                break
                            end
                            cursor = cursor.Parent
                        end
                        if not matchesOriginal then return source end
        
                        local matches = state.findNamedVFX(active.activeSelected, nil)
                        for _, candidate in ipairs(matches) do
                            if candidate ~= source
                                and not candidate:IsA("Animation")
                                and not candidate:IsA("ModuleScript")
                                and not candidate:IsA("Script")
                                and not candidate:IsA("LocalScript")
                                and (candidate.ClassName == source.ClassName or candidate:IsA(source.ClassName)) then
                                return candidate
                            end
                        end
                        return source
                    end
        
                    if not hooks.animator then
                        local animatorOriginal
                        hooks.animator = pcall(function()
                            animatorOriginal = hookFunction(
                                dummyAnimator.LoadAnimation,
                                makeClosure(function(self, animation, ...)
                                    return animatorOriginal(self, resolveAnimation(self, animation), ...)
                                end)
                            )
                        end)
                    end
        
                    if not hooks.humanoid then
                        local humanoidOriginal
                        hooks.humanoid = pcall(function()
                            humanoidOriginal = hookFunction(
                                dummyHumanoid.LoadAnimation,
                                makeClosure(function(self, animation, ...)
                                    return humanoidOriginal(self, resolveAnimation(self, animation), ...)
                                end)
                            )
                        end)
                    end
        
                    if false and not hooks.clone then 
                        local cloneOriginal
                        hooks.clone = pcall(function()
                            cloneOriginal = hookFunction(
                                dummyInstance.Clone,
                                makeClosure(function(self, ...)
                                    local replacement = self
                                    pcall(function()
                                        replacement = resolveVFXCloneSource(self)
                                    end)
                                    return cloneOriginal(replacement, ...)
                                end)
                            )
                        end)
                    end
        
                    dummyBindableFunction:Destroy()
                    dummyBindableEvent:Destroy()
                    dummyRemoteEvent:Destroy()
                    dummyRemoteFunction:Destroy()
                    dummyAnimator:Destroy()
                    dummyHumanoid:Destroy()
                    dummyInstance:Destroy()
                    return hooks.animator
                        or hooks.humanoid
                        or hooks.clone
                        or hooks.bindableFunction
                        or hooks.bindableEvent
                        or hooks.remoteEvent
                        or hooks.remoteFunction
                end
        
                local catalogRefreshInProgress = false
                local lastCatalogRefresh = 0
                local function refreshCatalog()
                    
                    local now = tick()
                    if catalogRefreshInProgress or now - lastCatalogRefresh < 10 then
                        return state.catalogSignature and true or false
                    end
                    catalogRefreshInProgress = true
                    lastCatalogRefresh = now
                    
                    table.clear(state.catalog)
                    table.clear(state.byName)
                    table.clear(state.namedVFXCache)
                    table.clear(state.emoteAccessoryCache)
                    table.clear(state.entrySoundCache)
                    table.clear(state.vfxPayloadCache)
                    state.vfxRootCache = nil
                    state.vfxRootCacheAt = 0
        
                    task.wait(0.15)
        
                    local folders = getEmotesFolder()
                    if folders and #folders > 0 then
                        for _, folder in ipairs(folders) do
                            local descendants = folder:GetDescendants()
                            
                            for i, object in ipairs(descendants) do
                                
                                if i % 25 == 0 then task.wait() end
                                
                                if object:IsA("Animation") then
                                    local name = object:GetAttribute("EmoteName") or object.Name
                                    if type(name) == "string" and name ~= "" and not state.byName[name] then
                                        local entry = {
                                            Name = name,
                                            Id = object.Name,
                                            Animation = object,
                                            Attributes = object:GetAttributes(),
                                        }
                                        state.catalog[#state.catalog + 1] = entry
                                        state.byName[name] = entry
                                    end
                                end
                            end
                        end
                    end
        
                    table.sort(state.catalog, function(left, right)
                        return left.Name:lower() < right.Name:lower()
                    end)
        
                    local names = {}
                    for _, entry in ipairs(state.catalog) do
                        names[#names + 1] = entry.Name
                    end
                    getgenv().emoteNames = names
                    state.catalogSignature = table.concat(names, "|")
        
                    if #names > 0 and not state.byName[getgenv().selectedEmote] then
                        getgenv().selectedEmote = names[1]
                    end
                    
                    catalogRefreshInProgress = false
                    
                    if state.emoteWheelEnabled and state.applyEmoteWheelList then 
                        task.defer(state.applyEmoteWheelList) 
                    end
                    return names
                end
        
                local function resolveEntry(value)
                    if not value then return nil end
                    if state.byName[value] then return state.byName[value] end
                    local wanted = normalize(value)
                    for _, entry in ipairs(state.catalog) do
                        if normalize(entry.Name) == wanted
                            or normalize(entry.Id) == wanted
                            or normalize(entry.Animation.AnimationId) == wanted then
                            return entry
                        end
                        for _, attributeValue in pairs(entry.Attributes or {}) do
                            if normalize(attributeValue) == wanted then return entry end
                        end
                    end
                    return nil
                end
        
                local function sameEntry(left, right)
                    if not left or not right then return false end
                    if left == right then return true end
                    return normalize(left.Name) == normalize(right.Name)
                        or normalize(left.Id) == normalize(right.Id)
                        or assetId(left.Animation and left.Animation.AnimationId) == assetId(right.Animation and right.Animation.AnimationId)
                end
        
                local cachedContents = nil
                local lastContentCheck = 0
                local function getAllWheelContents()
                    
                    local now = tick()
                    if cachedContents and now - lastContentCheck < 5 then
                        local valid = true
                        for _, c in ipairs(cachedContents) do
                            if not c or not c.Parent then valid = false; break end
                        end
                        if valid and #cachedContents > 0 then return cachedContents end
                    end
                    lastContentCheck = now
                    
                    local contents = {}
                    local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
                    if playerGui then
                        
                        local wheel = playerGui:FindFirstChild("EmoteWheel", true)
                        if wheel then
                            local list = wheel:FindFirstChild("List", true)
                            local content = list and list:FindFirstChild("Content", true)
                            if content then
                                contents[1] = content
                            end
                        end
                    end
                    cachedContents = contents
                    return contents
                end
        
                local function getButton(item)
                    if item:IsA("GuiButton") then return item end
                    return item:FindFirstChildWhichIsA("GuiButton", true)
                end
        
                do
                local function createUICorner(parent, radius)
                    local corner = Instance.new("UICorner")
                    corner.CornerRadius = UDim.new(0, radius)
                    corner.Parent = parent
                    return corner
                end
        
                local function createUIStroke(parent, color, thickness, transparency)
                    local stroke = Instance.new("UIStroke")
                    stroke.Color = color
                    stroke.Thickness = thickness or 1
                    stroke.Transparency = transparency or 0
                    stroke.Parent = parent
                    return stroke
                end
        
                local function getEntryImage(entry)
                    local image = getEntryAttribute(entry, {
                        "Icon",
                        "Image",
                        "ImageId",
                        "Thumbnail",
                        "ThumbnailId",
                        "EmoteIcon",
                        "EmoteImage",
                    })
                    if not image then return nil end
                    local text = tostring(image)
                    if text:find("rbxassetid://", 1, true) then return text end
                    local id = assetId(text)
                    return id and ("rbxassetid://" .. id) or nil
                end
        
                local function fitText(label, minSize, maxSize)
                    label.TextScaled = true
                    local limit = Instance.new("UITextSizeConstraint")
                    limit.MinTextSize = minSize or 9
                    limit.MaxTextSize = maxSize or 18
                    limit.Parent = label
                end
        
                local function addBlockyPreview(card, entry, order)
                    local preview = Instance.new("Frame")
                    preview.BackgroundTransparency = 1
                    preview.Position = UDim2.fromScale(0.08, 0.06)
                    preview.Size = UDim2.fromScale(0.84, 0.62)
                    preview.ClipsDescendants = false
                    preview.Parent = card
        
                    local image = getEntryImage(entry)
                    if image then
                        local imageLabel = Instance.new("ImageLabel")
                        imageLabel.BackgroundTransparency = 1
                        imageLabel.Image = image
                        imageLabel.ScaleType = Enum.ScaleType.Fit
                        imageLabel.Size = UDim2.fromScale(1, 1)
                        imageLabel.Parent = preview
                        return
                    end
        
                    
                end
        
                local function connectEmoteCard(card, entry)
                    local button = getButton(card)
                    if not button then
                        button = Instance.new("TextButton")
                        button.Name = "AzureEmoteHitbox"
                        button.BackgroundTransparency = 1
                        button.Text = ""
                        button.Size = UDim2.fromScale(1, 1)
                        button.ZIndex = 100
                        button.Parent = card
                    end
                    button.Activated:Connect(function()
                        getgenv().selectedEmote = entry.Name
        
                        
                        local slot = state.selectedNativeSlot
                        local gsf = getgenv().getNativeSelectedSlot
                        if gsf then
                            local ns = gsf()
                            if ns then slot = ns end
                        end
        
                        
                        
                        if slot then
                            state.nativeSlotEmotes = state.nativeSlotEmotes or {}
                            state.nativeSlotEmotes[slot] = entry.Name
                            
                            pcall(function()
                                getgenv()._azEmoteSlotStore = getgenv()._azEmoteSlotStore or {}
                                getgenv()._azEmoteSlotStore[tostring(slot)] = { Name = entry.Name, Id = entry.Id or entry.Name }
                                if getgenv()._azSaveEmoteSlots then getgenv()._azSaveEmoteSlots() end
                            end)
                            task.spawn(function()
                                local f = getgenv().equipEmoteToSlot
                                if f then f(slot, entry.Id or entry.Name) end
                            end)
                            pcall(function()
                                if state.slotOverlays and state.slotOverlays[slot] then
                                    local ov = state.slotOverlays[slot]
                                    local icon = getEntryImage(entry)
                                    if icon and icon ~= "" then ov.Image = icon end
                                    ov.BackgroundTransparency = 1
                                end
                            end)
                        else
                            task.defer(function()
                                if type(getgenv().playEmote) == "function" then
                                    getgenv().playEmote(entry.Name)
                                end
                            end)
                        end
                    end)
                end
        
                
                
                
                
                do
                    local RS = game:GetService("ReplicatedStorage")
                    local ctrl = nil
                    pcall(function()
                        ctrl = require(RS.Controllers.EmoteWheelController)
                    end)
        
                    local function usHasFn(t, key)
                        local ok, v = pcall(function() return t[key] end)
                        if ok and type(v) == "function" then return v end
                        return nil
                    end
        
                    local function usFindEmoteReplion()
                        if getgenv().__usEmoteReplion and getgenv().__usGetEquippedList then
                            return getgenv().__usEmoteReplion, getgenv().__usGetEquippedList
                        end
                        if not ctrl then return nil, nil end
        
                        local candidates = {}
                        for _, name in ipairs({"UpdateHolderEmotes", "handleWheelLoadout", "populateEmoteList", "UpdateMenuContentEmotes"}) do
                            local f = ctrl[name]
                            if type(f) == "function" and debug and debug.getupvalues then
                                local ok, ups = pcall(debug.getupvalues, f)
                                if ok then
                                    for _, u in pairs(ups) do
                                        if type(u) == "table" then
                                            candidates[#candidates + 1] = u
                                        end
                                    end
                                end
                            end
                        end
        
                        for _, t in ipairs(candidates) do
                            local gel = usHasFn(t, "GetEquippedList")
                            if gel then
                                getgenv().__usEmoteReplion = t
                                getgenv().__usGetEquippedList = gel
                                return t, gel
                            end
                            for _, sub in ipairs({"Data", "Client"}) do
                                local ok, s = pcall(function() return t[sub] end)
                                if ok and type(s) == "table" then
                                    local gel2 = usHasFn(s, "GetEquippedList")
                                    if gel2 then
                                        getgenv().__usEmoteReplion = s
                                        getgenv().__usGetEquippedList = gel2
                                        return s, gel2
                                    end
                                end
                            end
                        end
                        return nil, nil
                    end
        
                    getgenv().equipEmoteToSlot = function(slot, emoteId)
                        slot = tonumber(slot)
                        if not slot or not emoteId then return false end
        
                        local replion, getEquippedList = usFindEmoteReplion()
                        if not replion or not getEquippedList then
                            warn("[US] Emote replion/GetEquippedList bulunamadi")
                            return false
                        end
        
                        local okList, list = pcall(function()
                            return getEquippedList(replion, "Emote")
                        end)
                        if not okList or type(list) ~= "table" then
                            warn("[US] Emote listesi okunamadi")
                            return false
                        end
        
                        local page = 1
                        pcall(function()
                            page = tonumber(ctrl and ctrl.page) or 1
                        end)
                        local index = ((page - 1) * 8) + slot
                        local item = list[index] or list[slot]
                        if not item then
                            warn("[US] Slot entry bulunamadi:", slot, "index:", index)
                            return false
                        end
        
                        pcall(function()
                            item.Name = tostring(emoteId)
                        end)
        
                        pcall(function() if ctrl and ctrl.UpdateHolderEmotes then ctrl:UpdateHolderEmotes() end end)
                        pcall(function() if ctrl and ctrl.UpdateMenuContentEmotes then ctrl:UpdateMenuContentEmotes() end end)
        
                        print("[US] slot", slot, "index", index, "->", tostring(emoteId))
                        return true
                    end
        
                    getgenv().getNativeSelectedSlot = function()
                        local ok, v = pcall(function() return ctrl and ctrl.selected end)
                        if ok and type(v) == "number" then return v end
                        return nil
                    end
        
                    getgenv().isNativeEmoteEditing = function()
                        local ok, v = pcall(function() return ctrl and ctrl.editing end)
                        if ok then return v == true end
                        return false
                    end
        
                    
                    if ctrl and not getgenv().__usCloseHooked then
                        getgenv().__usCloseHooked = true
                        local origClose = ctrl.close
                        if type(origClose) == "function" then
                            ctrl.close = function(self, ...)
                                local sel, ed
                                pcall(function()
                                    sel = ctrl.selected
                                    ed = ctrl.editing
                                end)
                                local result = origClose(self, ...)
                                if ed ~= true and sel then
                                    local nm = state.nativeSlotEmotes and state.nativeSlotEmotes[sel]
                                    if nm and type(getgenv().playEmote) == "function" then
                                        task.defer(function()
                                            pcall(function() getgenv().playEmote(nm) end)
                                        end)
                                    end
                                end
                                return result
                            end
                        end
                    end
        
                    task.defer(usFindEmoteReplion)
                end
        
                
                task.spawn(function()
                    local Players = game:GetService("Players")
                    local lp = Players.LocalPlayer
                    local pg = lp:WaitForChild("PlayerGui")
                    local function hookWheel(ew)
                        if not ew then return end
                        if ew:GetAttribute("AzureSlotHooked") then return end
                        local wheel = ew:WaitForChild("Wheel", 10)
                        if not wheel then return end
                        ew:SetAttribute("AzureSlotHooked", true)
                        state.nativeSlotEmotes = state.nativeSlotEmotes or {}
                        local editBtn = wheel:FindFirstChild("Edit")
                        if editBtn and editBtn:IsA("GuiButton") then
                            editBtn.Activated:Connect(function()
                                state.wheelEditMode = not state.wheelEditMode
                            end)
                        end
                        
                        
                    end
                    local existing = pg:FindFirstChild("EmoteWheel")
                    if existing then pcall(hookWheel, existing) end
                    pg.ChildAdded:Connect(function(c)
                        if c.Name == "EmoteWheel" then
                            task.wait(0.5)
                            pcall(hookWheel, c)
                        end
                    end)
                end)
        
                
                local cardTemplate = nil
                local function getCardTemplate()
                    if cardTemplate then return cardTemplate end
                    
                    local template = Instance.new("TextButton")
                    template.Name = "EmoteCardTemplate"
                    template.AutoButtonColor = false
                    template.Text = ""
                    template.BackgroundColor3 = Color3.fromRGB(16, 24, 55)
                    template.BackgroundTransparency = 0
                    template.BorderSizePixel = 0
                    template.ClipsDescendants = true
                    
                    
                    local corner = Instance.new("UICorner")
                    corner.CornerRadius = UDim.new(0, 12)
                    corner.Parent = template
                    
                    cardTemplate = template
                    return template
                end
        
                
                local function captureNativeCardTemplate(root)
                    if root and not state.nativeGridProps then
                        pcall(function()
                            local nativeGrid = nil
                            for _, obj in ipairs(root:GetDescendants()) do
                                if obj:IsA("UIGridLayout") then nativeGrid = obj break end
                            end
                            if not nativeGrid and root:IsA("UIGridLayout") then nativeGrid = root end
                            if nativeGrid then
                                state.nativeGridProps = {
                                    CellSize = nativeGrid.CellSize,
                                    CellPadding = nativeGrid.CellPadding,
                                    FillDirection = nativeGrid.FillDirection,
                                    FillDirectionMaxCells = nativeGrid.FillDirectionMaxCells,
                                    StartCorner = nativeGrid.StartCorner,
                                    HorizontalAlignment = nativeGrid.HorizontalAlignment,
                                    VerticalAlignment = nativeGrid.VerticalAlignment,
                                    SortOrder = nativeGrid.SortOrder,
                                }
                            end
                        end)
                    end
                    if root and not state.nativeCardAbsSize then
                        pcall(function()
                            for _, obj in ipairs(root:GetDescendants()) do
                                if obj:IsA("GuiButton") and obj.Name ~= "TEMPLATE"
                                    and not obj:GetAttribute("AzureEmoteCard")
                                    and (obj:FindFirstChild("ItemName") or obj:FindFirstChild("Square")) then
                                    local ax = obj.AbsoluteSize.X
                                    local ay = obj.AbsoluteSize.Y
                                    if ax > 20 and ay > 20 then
                                        state.nativeCardAbsSize = UDim2.fromOffset(math.floor(ax), math.floor(ay))
                                        break
                                    end
                                end
                            end
                        end)
                    end
                    if state.nativeCardTemplate then return state.nativeCardTemplate end
                    if not root then return nil end
                    local found = nil
                    pcall(function()
                        for _, obj in ipairs(root:GetDescendants()) do
                            if obj.Name == "TEMPLATE" and obj:IsA("GuiButton")
                                and (obj:FindFirstChild("ItemName") or obj:FindFirstChild("Square")) then
                                found = obj
                                break
                            end
                        end
                        for _, obj in ipairs(root:GetDescendants()) do
                            if not found and obj:IsA("GuiButton") and not obj:GetAttribute("AzureEmoteCard") then
                                if obj:FindFirstChild("ItemName") or obj:FindFirstChild("Square") then
                                    found = obj
                                    break
                                end
                            end
                        end
                        if not found and root:IsA("GuiButton") and not root:GetAttribute("AzureEmoteCard")
                            and (root:FindFirstChild("ItemName") or root:FindFirstChild("Square")) then
                            found = root
                        end
                    end)
                    if found then
                        pcall(function()
                            local clone = found:Clone()
                            clone:SetAttribute("EmoteName", nil)
                            clone:SetAttribute("AnimationId", nil)
                            local scale = clone:FindFirstChild("_SCALE")
                            if scale and scale:IsA("UIScale") then scale.Scale = 1 end
                            state.nativeCardTemplate = clone
                        end)
                    end
                    return state.nativeCardTemplate
                end
        
                
                
                local function showDeleteConfirmation(emoteName)
                    local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
                    if not playerGui then return end
                    local prev = playerGui:FindFirstChild("AzureDeleteConfirm")
                    if prev then prev:Destroy() end
        
                    
                    local function usScore(node)
                        local nm = tostring(node.Name):lower()
                        if nm:find("delete") then return 4 end
                        if nm:find("confirm") then return 3 end
                        if nm:find("warn") then return 2 end
                        if nm:find("dialog") or nm:find("prompt") then return 2 end
                        return 1
                    end
                    local function usFindGamePrompt()
                        local best, bestScore = nil, 0
                        for _, yes in ipairs(playerGui:GetDescendants()) do
                            if yes.Name == "Yes" and yes:IsA("GuiButton") then
                                local node = yes.Parent
                                local depth = 0
                                while node and node ~= playerGui and depth < 6 do
                                    if node:FindFirstChild("No", true) and node:FindFirstChild("Title", true) then
                                        local sc = usScore(node)
                                        if sc > bestScore then best, bestScore = node, sc end
                                        break
                                    end
                                    node = node.Parent
                                    depth = depth + 1
                                end
                            end
                        end
                        return best
                    end
        
                    local gamePanel = usFindGamePrompt()
                    if gamePanel then
                        local ok = pcall(function()
                            local g = Instance.new("ScreenGui")
                            g.Name = "AzureDeleteConfirm"
                            g.ResetOnSpawn = false
                            g.IgnoreGuiInset = true
                            g.DisplayOrder = 99999
                            g.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
                            g.Parent = playerGui
        
                            local ov = Instance.new("TextButton")
                            ov.Name = "Black"
                            ov.Text = ""
                            ov.AutoButtonColor = false
                            ov.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                            ov.BackgroundTransparency = 0.35
                            ov.BorderSizePixel = 0
                            ov.Size = UDim2.fromScale(1, 1)
                            ov.ZIndex = 1
                            ov.Parent = g
        
                            local panel = gamePanel:Clone()
                            for _, d in ipairs(panel:GetDescendants()) do
                                if d:IsA("LocalScript") or d:IsA("Script") or d:IsA("ModuleScript") then
                                    pcall(function() d:Destroy() end)
                                end
                            end
                            panel.Visible = true
                            pcall(function() panel.AnchorPoint = Vector2.new(0.5, 0.5) end)
                            pcall(function() panel.Position = UDim2.fromScale(0.5, 0.5) end)
                            pcall(function() panel.ZIndex = 2 end)
                            panel.Parent = g
        
                            local title = panel:FindFirstChild("Title", true)
                            if title and title:IsA("TextLabel") then title.Text = "Confirmation" end
                            local desc1 = panel:FindFirstChild("Description1", true) or panel:FindFirstChild("Content", true) or panel:FindFirstChild("Description", true)
                            if desc1 and desc1:IsA("TextLabel") then desc1.Text = "Are you sure you want to delete x1 " .. tostring(emoteName) .. "?" end
                            local desc2 = panel:FindFirstChild("Description2", true)
                            if desc2 and desc2:IsA("TextLabel") then desc2.Text = "This cannot be undone." end
                            for _, hideNm in ipairs({"Amount", "Token"}) do
                                local h = panel:FindFirstChild(hideNm, true)
                                if h then pcall(function() h.Visible = false end) end
                            end
        
                            local function closeDialog() pcall(function() g:Destroy() end) end
                            for _, bn in ipairs({"Yes", "No", "Close"}) do
                                local b = panel:FindFirstChild(bn, true)
                                if b and b:IsA("GuiButton") then
                                    pcall(function() b.Active = true end)
                                    b.MouseButton1Click:Connect(closeDialog)
                                end
                            end
                            ov.MouseButton1Click:Connect(closeDialog)
                        end)
                        if ok then return end
                        local junk = playerGui:FindFirstChild("AzureDeleteConfirm")
                        if junk then junk:Destroy() end
                    end
        
                    local gui = Instance.new("ScreenGui")
                    gui.Name = "AzureDeleteConfirm"
                    gui.ResetOnSpawn = false
                    gui.IgnoreGuiInset = true
                    gui.DisplayOrder = 99999
                    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
                    gui.Parent = playerGui
        
                    local overlay = Instance.new("TextButton")
                    overlay.Name = "Black"
                    overlay.Text = ""
                    overlay.AutoButtonColor = false
                    overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                    overlay.BackgroundTransparency = 0.35
                    overlay.BorderSizePixel = 0
                    overlay.Size = UDim2.fromScale(1, 1)
                    overlay.ZIndex = 1
                    overlay.Parent = gui
        
                    local frame = Instance.new("Frame")
                    frame.Name = "Dialog"
                    frame.AnchorPoint = Vector2.new(0.5, 0.5)
                    frame.Position = UDim2.fromScale(0.5, 0.5)
                    frame.Size = UDim2.fromOffset(560, 300)
                    frame.BackgroundColor3 = Color3.fromRGB(31, 86, 175)
                    frame.BorderSizePixel = 0
                    frame.ZIndex = 2
                    frame.Parent = gui
                    createUICorner(frame, 14)
                    createUIStroke(frame, Color3.fromRGB(120, 180, 255), 3, 0)
                    local grad = Instance.new("UIGradient")
                    grad.Color = ColorSequence.new(Color3.fromRGB(44, 104, 200), Color3.fromRGB(22, 62, 145))
                    grad.Rotation = 90
                    grad.Parent = frame
        
                    local title = Instance.new("TextLabel")
                    title.Name = "Title"
                    title.BackgroundTransparency = 1
                    title.Position = UDim2.fromOffset(26, 14)
                    title.Size = UDim2.new(1, -80, 0, 46)
                    title.Font = Enum.Font.FredokaOne
                    title.Text = "Confirmation"
                    title.TextColor3 = Color3.fromRGB(255, 255, 255)
                    title.TextSize = 40
                    title.TextXAlignment = Enum.TextXAlignment.Left
                    title.ZIndex = 3
                    title.Parent = frame
                    createUIStroke(title, Color3.fromRGB(18, 42, 96), 3, 0)
        
                    local closeBtn = Instance.new("TextButton")
                    closeBtn.Name = "Close"
                    closeBtn.AnchorPoint = Vector2.new(1, 0)
                    closeBtn.Position = UDim2.new(1, -14, 0, 14)
                    closeBtn.Size = UDim2.fromOffset(42, 42)
                    closeBtn.BackgroundColor3 = Color3.fromRGB(214, 55, 55)
                    closeBtn.Font = Enum.Font.FredokaOne
                    closeBtn.Text = "X"
                    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                    closeBtn.TextSize = 26
                    closeBtn.ZIndex = 4
                    closeBtn.Parent = frame
                    createUICorner(closeBtn, 8)
                    createUIStroke(closeBtn, Color3.fromRGB(120, 20, 20), 2, 0)
        
                    local body = Instance.new("TextLabel")
                    body.Name = "Content"
                    body.BackgroundTransparency = 1
                    body.Position = UDim2.fromScale(0.08, 0.26)
                    body.Size = UDim2.fromScale(0.84, 0.36)
                    body.Font = Enum.Font.FredokaOne
                    body.Text = "Are you sure you want to delete x1 " .. tostring(emoteName) .. "? This cannot be undone."
                    body.TextColor3 = Color3.fromRGB(255, 255, 255)
                    body.TextWrapped = true
                    body.TextSize = 24
                    body.ZIndex = 3
                    body.Parent = frame
                    createUIStroke(body, Color3.fromRGB(18, 42, 96), 2, 0.15)
        
                    local function makeBtn(nm, txt, col, strokeCol, px)
                        local b = Instance.new("TextButton")
                        b.Name = nm
                        b.AnchorPoint = Vector2.new(0.5, 1)
                        b.Position = UDim2.new(px, 0, 1, -24)
                        b.Size = UDim2.fromOffset(210, 64)
                        b.BackgroundColor3 = col
                        b.Font = Enum.Font.FredokaOne
                        b.Text = txt
                        b.TextColor3 = Color3.fromRGB(255, 255, 255)
                        b.TextSize = 32
                        b.ZIndex = 4
                        b.Parent = frame
                        createUICorner(b, 10)
                        createUIStroke(b, strokeCol, 2, 0)
                        return b
                    end
                    local yesBtn = makeBtn("Yes", "Yes", Color3.fromRGB(70, 200, 75), Color3.fromRGB(30, 110, 35), 0.30)
                    local noBtn = makeBtn("No", "No", Color3.fromRGB(216, 55, 55), Color3.fromRGB(120, 20, 20), 0.70)
        
                    local function closeDialog() pcall(function() gui:Destroy() end) end
                    closeBtn.MouseButton1Click:Connect(closeDialog)
                    noBtn.MouseButton1Click:Connect(closeDialog)
                    yesBtn.MouseButton1Click:Connect(closeDialog)
                    overlay.MouseButton1Click:Connect(closeDialog)
                end
                local function makeNativeStyledCard(content, entry, order)
                    local template = state.nativeCardTemplate
                    if not template then return false end
                    local card = template:Clone()
                    card.Name = "AzureEmote_" .. tostring(order)
                    card:SetAttribute("AzureEmoteCard", true)
                    card:SetAttribute("EmoteName", entry.Name)
                    if entry.Animation then
                        card:SetAttribute("AnimationId", entry.Animation.AnimationId)
                    end
                    card.LayoutOrder = order
                    card.Visible = true
                    pcall(function() card.Active = true end)
        
                    local nameLabel = card:FindFirstChild("ItemName", true)
                    if nameLabel and nameLabel:IsA("TextLabel") then
                        nameLabel.Text = entry.Name
                    end
        
                    for _, hideName in ipairs({"Lock", "Stack"}) do
                        local hideObj = card:FindFirstChild(hideName)
                        if hideObj then pcall(function() hideObj.Visible = false end) end
                    end
        
                    
                    pcall(function()
                        local icon = getEntryImage(entry)
                        if icon then
                            local square = card:FindFirstChild("Square")
                            local holder = square or card
                            if square then pcall(function() square.ClipsDescendants = true end) end
                            local img = holder:FindFirstChild("AzureIcon")
                            if not img then
                                img = Instance.new("ImageLabel")
                                img.Name = "AzureIcon"
                                img.BackgroundTransparency = 1
                                img.BorderSizePixel = 0
                                img.Size = UDim2.fromScale(1, 1)
                                img.Position = UDim2.fromScale(0, 0)
                                img.ScaleType = Enum.ScaleType.Crop
                                img.ZIndex = 3
                                img.Parent = holder
                            end
                            img.Image = icon
                            img.Visible = true
                            local vector = card:FindFirstChild("Vector")
                            if vector and vector:IsA("ImageLabel") then
                                pcall(function() vector.Image = icon end)
                            end
                        end
                    end)
        
                    local favBtn = card:FindFirstChild("Favorite")
                    if favBtn and favBtn:IsA("GuiObject") then
                        pcall(function() favBtn.Active = true end)
                        local function updateFav()
                            pcall(function()
                                favBtn.ImageTransparency = state.favorites[entry.Name] and 0 or 0.55
                            end)
                        end
                        updateFav()
                        if favBtn:IsA("GuiButton") then
                            favBtn.MouseButton1Click:Connect(function()
                                if state.favorites[entry.Name] then
                                    state.favorites[entry.Name] = nil
                                else
                                    local count = 0
                                    for _ in pairs(state.favorites) do count = count + 1 end
                                    if count < 8 then
                                        state.favorites[entry.Name] = true
                                    elseif WindUI and WindUI.Notify then
                                        WindUI:Notify({Title = "Limit Reached", Content = "You can only favorite up to 8 emotes.", Duration = 2})
                                    end
                                end
                                updateFav()
                                saveEmoteFavorites(state.favorites)
                                if state.updateCustomWheel then state.updateCustomWheel() end
                            end)
                        end
                    end
        
                    
                    if favBtn and favBtn:IsA("GuiObject") then pcall(function() favBtn.ZIndex = 160 end) end
        
                    
                    local delBtn = card:FindFirstChild("Delete")
                    if delBtn and delBtn:IsA("GuiObject") then
                        delBtn.Visible = true
                        pcall(function() delBtn.Active = true end)
                        pcall(function() delBtn.AutoButtonColor = true end)
                        pcall(function() delBtn.ZIndex = 200 end)
                        local lastDelFire = 0
                        local function onDeletePressed()
                            local now = os.clock()
                            if now - lastDelFire < 0.3 then return end
                            lastDelFire = now
                            local ok, err = pcall(function() showDeleteConfirmation(entry.Name) end)
                            if not ok then warn("[US] showDeleteConfirmation HATA:", tostring(err)) end
                        end
                        if delBtn:IsA("GuiButton") then
                            delBtn.MouseButton1Click:Connect(onDeletePressed)
                            delBtn.Activated:Connect(onDeletePressed)
                        end
                        delBtn.InputBegan:Connect(function(input)
                            if input.UserInputType == Enum.UserInputType.MouseButton1
                                or input.UserInputType == Enum.UserInputType.Touch then
                                onDeletePressed()
                            end
                        end)
                    end
        
                    card.Parent = content
                    connectEmoteCard(card, entry)
                    return true
                end
        
                local function makeEmoteWheelCard(content, entry, order)
                    
                    if state.nativeCardTemplate then
                        local built = false
                        pcall(function() built = makeNativeStyledCard(content, entry, order) end)
                        if built then return end
                    end
        
                    
                    local template = getCardTemplate()
                    local card = template:Clone()
                    
                    card.Name = "AzureEmote_" .. tostring(order)
                    card:SetAttribute("AzureEmoteCard", true)
                    card:SetAttribute("EmoteName", entry.Name)
                    card:SetAttribute("AnimationId", entry.Animation.AnimationId)
                    card.LayoutOrder = order
                    card.Parent = content
        
                    addBlockyPreview(card, entry, order)
        
                    local nameLabel = Instance.new("TextLabel")
                    nameLabel.BackgroundTransparency = 1
                    nameLabel.Position = UDim2.fromScale(0.04, 0.64)
                    nameLabel.Size = UDim2.fromScale(0.92, 0.33)
                    nameLabel.Font = Enum.Font.FredokaOne
                    nameLabel.Text = entry.Name
                    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                    nameLabel.TextStrokeTransparency = 1
                    nameLabel.TextWrapped = true
                    nameLabel.ZIndex = 5
                    nameLabel.Parent = card
                    fitText(nameLabel, 10, 18)
        
                    
                    if not getgenv().AzureLowGFX then
                        local textStroke = Instance.new("UIStroke")
                        textStroke.Color = Color3.fromRGB(12, 18, 40)
                        textStroke.Thickness = 3
                        textStroke.Transparency = 0
                        textStroke.Parent = nameLabel
                    end
        
                    local starBtn = Instance.new("TextButton")
                    starBtn.Name = "FavoriteStar"
                    starBtn.BackgroundTransparency = 1
                    starBtn.Position = UDim2.new(1, -28, 0, 4)
                    starBtn.Size = UDim2.new(0, 24, 0, 24)
                    starBtn.Font = Enum.Font.GothamBold
                    starBtn.TextSize = 22
                    starBtn.TextStrokeTransparency = 0
                    starBtn.ZIndex = 10
                    starBtn.Parent = card
        
                    local function updateStar()
                        if state.favorites[entry.Name] then
                            starBtn.Text = "?"
                            starBtn.TextColor3 = Color3.fromRGB(255, 215, 0)
                        else
                            starBtn.Text = "?"
                            starBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
                        end
                    end
                    updateStar()
        
                    starBtn.MouseButton1Click:Connect(function()
                        if state.favorites[entry.Name] then
                            state.favorites[entry.Name] = nil
                        else
                            local count = 0
                            for k in pairs(state.favorites) do count = count + 1 end
                            if count < 8 then
                                state.favorites[entry.Name] = true
                            else
                                if WindUI and WindUI.Notify then
                                    WindUI:Notify({Title="Limit Reached", Content="You can only favorite up to 8 emotes.", Duration=2})
                                end
                            end
                        end
                        updateStar()
                        saveEmoteFavorites(state.favorites)
                        if state.updateCustomWheel then state.updateCustomWheel() end
                    end)
        
                    
                    local hoverActive = false
                    card.MouseEnter:Connect(function()
                        hoverActive = true
                        card.BackgroundColor3 = Color3.fromRGB(26, 38, 85)
                    end)
                    card.MouseLeave:Connect(function()
                        hoverActive = false
                        card.BackgroundColor3 = Color3.fromRGB(16, 24, 55)
                    end)
                    
                    connectEmoteCard(card, entry)
                end
        
                local function entryFromWheelItem(item)
                    
                    local emoteName = item:GetAttribute("EmoteName")
                    if emoteName then
                        local entry = resolveEntry(emoteName)
                        if entry then return entry end
                    end
                    
                    local animId = item:GetAttribute("AnimationId")
                    if animId then
                        local entry = resolveEntry(animId)
                        if entry then return entry end
                    end
                    
                    
                    local entry = resolveEntry(item.Name)
                    if entry then return entry end
                    
                    
                    local candidates = {}
                    for _, object in ipairs(item:GetChildren()) do
                        if object:IsA("TextLabel") or object:IsA("TextButton") then
                            candidates[#candidates + 1] = object.Text
                        elseif object:IsA("Animation") then
                            candidates[#candidates + 1] = object.Name
                            candidates[#candidates + 1] = object.AnimationId
                        end
                    end
                    
                    for _, candidate in ipairs(candidates) do
                        entry = resolveEntry(candidate)
                        if entry then return entry end
                    end
                    
                    return nil
                end
        
                local function captureNativeDispatcherFromContent(content)
                    local getConnections = getExecutorGlobal("getconnections")
                    if not content or type(getConnections) ~= "function" then return nil end
        
                    local scanLimit = 0
                    for _, item in ipairs(content:GetChildren()) do
                        if item:IsA("GuiObject") and not item:GetAttribute("AzureEmoteCard") then
                            scanLimit = scanLimit + 1
                            if scanLimit > 6 then break end
        
                            local button = getButton(item)
                            if button then
                                for _, signal in ipairs({button.Activated, button.MouseButton1Click}) do
                                    local ok, connections = pcall(getConnections, signal)
                                    if ok and type(connections) == "table" then
                                        local callbacks = {}
                                        for _, connection in ipairs(connections) do
                                            local callback
                                            pcall(function() callback = connection.Function end)
                                            if type(callback) == "function"
                                                and not (isourclosure and isourclosure(callback)) then
                                                callbacks[#callbacks + 1] = callback
                                            end
                                        end
                                        if #callbacks > 0 then
                                            local original = entryFromWheelItem(item)
                                            if original then
                                                state.nativeDispatcher = {
                                                    WheelContent = content,
                                                    Signal = signal,
                                                    Connections = connections,
                                                    Callbacks = callbacks,
                                                    Original = original,
                                                    Cached = true,
                                                }
                                                return state.nativeDispatcher
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                    return nil
                end
        
                local function preserveNativeWheelItems(content)
                    state.contentAddedConns = state.contentAddedConns or {}
                    local function checkAndDestroy(child)
                        if child:IsA("UIComponent") then return end
                        if child:GetAttribute("AzureEmoteCard") then return end
                        if not state.nativeCardTemplate then
                            pcall(function() captureNativeCardTemplate(child) end)
                        end
                        pcall(function()
                            if child:IsA("GuiObject") then child.Visible = false end
                            child:Destroy()
                        end)
                    end
        
                    for _, child in ipairs(content:GetChildren()) do
                        checkAndDestroy(child)
                    end
                    if state.nativeWheelCache then
                        pcall(function() state.nativeWheelCache:Destroy() end)
                        state.nativeWheelCache = nil
                    end
                    if state.contentAddedConns[content] then
                        pcall(function() state.contentAddedConns[content]:Disconnect() end)
                        state.contentAddedConns[content] = nil
                    end
                    pcall(function()
                        state.contentAddedConns[content] = content.ChildAdded:Connect(function(child)
                            task.defer(checkAndDestroy, child)
                        end)
                    end)
        
                    pcall(function()
                        local list = content.Parent
                        if list then
                            for _, child in ipairs(list:GetChildren()) do
                                if child ~= content and child:IsA("GuiObject") then
                                    local isCard = child:GetAttribute("EmoteName")
                                                or child:GetAttribute("AnimationId")
                                                or child.Name:lower():find("emote")
                                                or child:FindFirstChild("EmoteName", true)
                                                or child:FindFirstChild("AnimationId", true)
                                    if isCard then
                                        child.Visible = false
                                        child:Destroy()
                                    end
                                end
                            end
                        end
                    end)
                end
        
                local function disconnectWheelScrollTarget(target)
                    local controls = state.wheelScrollControls and state.wheelScrollControls[target]
                    if controls then
                        for _, control in ipairs(controls) do
                            if control and control.Parent then
                                pcall(function() control:Destroy() end)
                            end
                        end
                        state.wheelScrollControls[target] = nil
                    end
        
                    local connections = state.wheelScrollConnections and state.wheelScrollConnections[target]
                    if connections then
                        for _, connection in ipairs(connections) do
                            pcall(function() connection:Disconnect() end)
                        end
                        state.wheelScrollConnections[target] = nil
                    end
                end
        
                local function getWheelScrollFrame(content)
                    if not content then return nil end
                    if content:IsA("ScrollingFrame") then return content end
        
                    local current = content.Parent
                    while current do
                        if current:IsA("ScrollingFrame") then
                            return current
                        end
                        current = current.Parent
                    end
                    return nil
                end
        
                local function installWheelScrollBar(content)
                    local scrollFrame = getWheelScrollFrame(content)
                    if not scrollFrame then return end
        
                    local existing = state.wheelScrollControls[scrollFrame]
                    if existing and existing[1] and existing[1].Parent then return end
        
                    disconnectWheelScrollTarget(scrollFrame)
        
                    local host = scrollFrame.Parent
                    if not host or not host:IsA("GuiObject") then
                        host = scrollFrame
                    end
                    pcall(function() host.ClipsDescendants = false end)
        
                    local hitbox = Instance.new("TextButton")
                    hitbox.Name = "AzureWheelScrollBar"
                    hitbox.AnchorPoint = Vector2.new(1, 0.5)
                    hitbox.Position = UDim2.new(1, -4, 0.5, 0)
                    hitbox.Size = UDim2.new(0, 24, 1, -22)
                    hitbox.BackgroundTransparency = 1
                    hitbox.BorderSizePixel = 0
                    hitbox.AutoButtonColor = false
                    hitbox.Text = ""
                    hitbox.ZIndex = 260
                    hitbox.Parent = host
        
                    local thumb = Instance.new("Frame")
                    thumb.Name = "Thumb"
                    thumb.AnchorPoint = Vector2.new(0.5, 0)
                    thumb.Position = UDim2.new(0.5, 0, 0, 0)
                    thumb.Size = UDim2.fromOffset(8, 76)
                    thumb.BackgroundColor3 = Color3.fromRGB(36, 38, 48)
                    thumb.BackgroundTransparency = 0
                    thumb.BorderSizePixel = 0
                    thumb.ZIndex = 261
                    thumb.Parent = hitbox
                    createUICorner(thumb, 8)
                    createUIStroke(thumb, Color3.fromRGB(245, 246, 255), 1, 0.72)
        
                    local dragging = false
        
                    local function getMetrics()
                        local canvas = scrollFrame.AbsoluteCanvasSize
                        local window = scrollFrame.AbsoluteWindowSize
                        local maxX = math.max(canvas.X - window.X, 0)
                        local maxY = math.max(canvas.Y - window.Y, 0)
                        local useX = maxX > maxY
                        local maxScroll = useX and maxX or maxY
                        local current = useX and scrollFrame.CanvasPosition.X or scrollFrame.CanvasPosition.Y
                        return useX, maxScroll, current
                    end
        
                    local function setScroll(value)
                        local useX, maxScroll = getMetrics()
                        local pos = scrollFrame.CanvasPosition
                        value = math.clamp(value, 0, maxScroll)
                        if useX then
                            scrollFrame.CanvasPosition = Vector2.new(value, pos.Y)
                        else
                            scrollFrame.CanvasPosition = Vector2.new(pos.X, value)
                        end
                    end
        
                    local function updateThumb()
                        local _, maxScroll, current = getMetrics()
                        local trackHeight = math.max(hitbox.AbsoluteSize.Y, 1)
                        local visibleRatio = 1
                        pcall(function()
                            local canvas = scrollFrame.AbsoluteCanvasSize
                            local window = scrollFrame.AbsoluteWindowSize
                            visibleRatio = math.clamp(window.Y / math.max(canvas.Y, 1), 0.16, 1)
                        end)
        
                        local thumbHeight = math.clamp(trackHeight * visibleRatio, 42, trackHeight)
                        local travel = math.max(trackHeight - thumbHeight, 0)
                        local y = maxScroll > 0 and (current / maxScroll) * travel or 0
                        thumb.Size = UDim2.fromOffset(8, thumbHeight)
                        thumb.Position = UDim2.new(0.5, 0, 0, y)
                        thumb.Visible = maxScroll > 1
                    end
        
                    local function scrollToInput(input)
                        local _, maxScroll = getMetrics()
                        local trackTop = hitbox.AbsolutePosition.Y
                        local trackHeight = math.max(hitbox.AbsoluteSize.Y, 1)
                        local thumbHeight = thumb.AbsoluteSize.Y
                        local travel = math.max(trackHeight - thumbHeight, 1)
                        local relativeY = math.clamp(input.Position.Y - trackTop - (thumbHeight * 0.5), 0, travel)
                        setScroll((relativeY / travel) * maxScroll)
                        updateThumb()
                    end
        
                    local connections = {}
                    connections[#connections + 1] = hitbox.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1
                            or input.UserInputType == Enum.UserInputType.Touch then
                            dragging = true
                            thumb.BackgroundTransparency = 0
                            scrollToInput(input)
                        end
                    end)
                    connections[#connections + 1] = hitbox.InputEnded:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1
                            or input.UserInputType == Enum.UserInputType.Touch then
                            dragging = false
                            thumb.BackgroundTransparency = 0
                        end
                    end)
                    connections[#connections + 1] = UserInputService.InputChanged:Connect(function(input)
                        if not dragging then return end
                        if input.UserInputType == Enum.UserInputType.MouseMovement
                            or input.UserInputType == Enum.UserInputType.Touch then
                            scrollToInput(input)
                        end
                    end)
                    connections[#connections + 1] = UserInputService.InputEnded:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1
                            or input.UserInputType == Enum.UserInputType.Touch then
                            dragging = false
                            thumb.BackgroundTransparency = 0
                        end
                    end)
                    connections[#connections + 1] = scrollFrame:GetPropertyChangedSignal("CanvasPosition"):Connect(updateThumb)
                    connections[#connections + 1] = scrollFrame:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(updateThumb)
                    connections[#connections + 1] = scrollFrame:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(updateThumb)
                    connections[#connections + 1] = hitbox:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateThumb)
                    connections[#connections + 1] = scrollFrame.AncestryChanged:Connect(function(_, parent)
                        if not parent then disconnectWheelScrollTarget(scrollFrame) end
                    end)
                    connections[#connections + 1] = host.AncestryChanged:Connect(function(_, parent)
                        if not parent then disconnectWheelScrollTarget(scrollFrame) end
                    end)
        
                    task.defer(updateThumb)
        
                    state.wheelScrollControls[scrollFrame] = {hitbox}
                    state.wheelScrollConnections[scrollFrame] = connections
                end
        
                local function clearWheelScrollButtons()
                    local targets = {}
                    for target in pairs(state.wheelScrollControls or {}) do
                        targets[#targets + 1] = target
                    end
                    for _, target in ipairs(targets) do
                        disconnectWheelScrollTarget(target)
                    end
                end
        
                local function disconnectWheelSearchTarget(target)
                    local connections = state.wheelSearchConnections and state.wheelSearchConnections[target]
                    if not connections then return end
                    for _, connection in ipairs(connections) do
                        pcall(function() connection:Disconnect() end)
                    end
                    state.wheelSearchConnections[target] = nil
                end
        
                local function clearWheelSearchBindings()
                    local targets = {}
                    for target in pairs(state.wheelSearchConnections or {}) do
                        targets[#targets + 1] = target
                    end
                    for _, target in ipairs(targets) do
                        disconnectWheelSearchTarget(target)
                    end
                end
        
                local function getWheelSearchRoot(content)
                    local current = content
                    while current do
                        if current.Name == "EmoteWheel" then
                            return current
                        end
                        current = current.Parent
                    end
                    local parent = content and content.Parent
                    return parent and parent.Parent or parent or content
                end
        
                local function findWheelSearchBox(content)
                    local root = getWheelSearchRoot(content)
                    if not root then return nil end
        
                    local fallback = nil
                    for _, object in ipairs(root:GetDescendants()) do
                        if object:IsA("TextBox") then
                            local key = normalize((object.Name or "") .. " " .. (object.PlaceholderText or ""))
                            if key:find("search", 1, true) or key:find("ara", 1, true) then
                                return object
                            end
                            fallback = fallback or object
                        end
                    end
                    return fallback
                end
        
                local function customEmoteCardMatches(card, query)
                    if query == "" then return true end
        
                    
                    local cacheKey = "_searchCache"
                    local cached = card:GetAttribute(cacheKey)
                    
                    if not cached then
                        local candidates = {
                            card:GetAttribute("EmoteName") or "",
                            card:GetAttribute("AnimationId") or "",
                            card.Name or "",
                        }
                        
                        
                        local emoteName = card:GetAttribute("EmoteName")
                        if emoteName then
                            local entry = resolveEntry(emoteName)
                            if entry then
                                candidates[#candidates + 1] = entry.Name or ""
                                candidates[#candidates + 1] = entry.DisplayName or ""
                                if entry.Animation then
                                    candidates[#candidates + 1] = entry.Animation.AnimationId or ""
                                end
                            end
                        end
        
                        
                        for _, object in ipairs(card:GetChildren()) do
                            if object:IsA("TextLabel") then
                                candidates[#candidates + 1] = object.Text or ""
                            end
                        end
        
                        
                        local combined = table.concat(candidates, " "):lower():gsub("[^%w]", "")
                        card:SetAttribute(cacheKey, combined)
                        cached = combined
                    end
        
                    return cached:find(query, 1, true) ~= nil
                end
        
                local function applyCustomWheelSearch(content, searchText)
                    local query = (searchText or ""):lower():gsub("[^%w]", "")
                    
                    
                    local updates = {}
                    for _, child in ipairs(content:GetChildren()) do
                        if child:IsA("GuiObject") and child:GetAttribute("AzureEmoteCard") then
                            local visible = customEmoteCardMatches(child, query)
                            if child.Visible ~= visible then
                                updates[child] = visible
                            end
                        end
                    end
                    
                    
                    for child, visible in pairs(updates) do
                        child.Visible = visible
                    end
                end
        
                local function bindCustomWheelSearch(content)
                    if not content then return end
                    disconnectWheelSearchTarget(content)
        
                    local searchBox = findWheelSearchBox(content)
                    local connections = {}
                    
                    
                    local lastRefreshTime = 0
                    local pendingRefresh = false
                    
                    local function refresh()
                        local now = tick()
                        if now - lastRefreshTime < 0.15 then 
                            if not pendingRefresh then
                                pendingRefresh = true
                                task.delay(0.15, function()
                                    pendingRefresh = false
                                    refresh()
                                end)
                            end
                            return
                        end
                        
                        lastRefreshTime = now
                        if not content.Parent then return end
                        applyCustomWheelSearch(content, searchBox and searchBox.Text or "")
                    end
        
                    if searchBox then
                        connections[#connections + 1] = searchBox:GetPropertyChangedSignal("Text"):Connect(refresh)
                        connections[#connections + 1] = searchBox.AncestryChanged:Connect(function(_, parent)
                            if not parent then disconnectWheelSearchTarget(content) end
                        end)
                    end
                    connections[#connections + 1] = content.ChildAdded:Connect(function(child)
                        if child:IsA("GuiObject") and child:GetAttribute("AzureEmoteCard") then
                            task.defer(refresh)
                        end
                    end)
                    connections[#connections + 1] = content.AncestryChanged:Connect(function(_, parent)
                        if not parent then disconnectWheelSearchTarget(content) end
                    end)
        
                    state.wheelSearchConnections[content] = connections
                    task.defer(refresh)
                end
        
                state.applyEmoteWheelList = function()
                    if state.destroyed or state.applyingEmoteWheel then return false end
                    local contents = getAllWheelContents()
                    if #contents == 0 then return false end
        
                    state.applyingEmoteWheel = true
                    local ok, err = pcall(function()
                        for _, content in ipairs(contents) do
                            
                            bindCustomWheelSearch(content)
                            local alreadyCurrent = false
                            pcall(function()
                                if content:GetAttribute("AzureCatalogSignature") == state.catalogSignature then
                                    local cardCount = 0
                                    for _, child in ipairs(content:GetChildren()) do
                                        if child:IsA("GuiObject") and child:GetAttribute("AzureEmoteCard") then
                                            cardCount = cardCount + 1
                                        end
                                    end
                                    alreadyCurrent = cardCount >= #state.catalog and (state.nativeCardTemplate == nil or content:GetAttribute("AzureNativeStyled") == true)
                                end
                            end)
                            if alreadyCurrent then continue end
        
                            if not state.nativeDispatcher then
                                captureNativeDispatcherFromContent(content)
                            end
        
                            captureNativeCardTemplate(content)
        
                            preserveNativeWheelItems(content)
        
                            
                            local toDestroy = {}
                            for _, child in ipairs(content:GetChildren()) do
                                if child:IsA("GuiObject") and child:GetAttribute("AzureEmoteCard") then
                                    toDestroy[#toDestroy + 1] = child
                                end
                            end
                            for _, child in ipairs(toDestroy) do
                                pcall(function() child:Destroy() end)
                            end
        
                            local grid = content:FindFirstChildOfClass("UIGridLayout")
                            if not grid then
                                grid = Instance.new("UIGridLayout")
                                grid.Parent = content
                            end
                            if state.nativeGridProps then
                                
                                local gp = state.nativeGridProps
                                pcall(function()
                                    if gp.CellSize then grid.CellSize = gp.CellSize end
                                    if gp.CellPadding then grid.CellPadding = gp.CellPadding end
                                    if gp.FillDirection then grid.FillDirection = gp.FillDirection end
                                    if gp.FillDirectionMaxCells then grid.FillDirectionMaxCells = gp.FillDirectionMaxCells end
                                    if gp.StartCorner then grid.StartCorner = gp.StartCorner end
                                    if gp.HorizontalAlignment then grid.HorizontalAlignment = gp.HorizontalAlignment end
                                    if gp.VerticalAlignment then grid.VerticalAlignment = gp.VerticalAlignment end
                                    grid.SortOrder = gp.SortOrder or Enum.SortOrder.LayoutOrder
                                end)
                            else
                                grid.CellSize = UDim2.fromOffset(118, 118)
                                grid.CellPadding = UDim2.fromOffset(8, 8)
                                grid.SortOrder = Enum.SortOrder.LayoutOrder
                                grid.FillDirection = Enum.FillDirection.Horizontal
                                grid.HorizontalAlignment = Enum.HorizontalAlignment.Center
                            end
                            
                            pcall(function()
                                grid.FillDirection = Enum.FillDirection.Horizontal
                                grid.FillDirectionMaxCells = 2
                            end)
        
                            local padding = content:FindFirstChildOfClass("UIPadding")
                            if not padding then
                                padding = Instance.new("UIPadding")
                                padding.Parent = content
                            end
                            padding.PaddingTop = UDim.new(0, 8)
                            padding.PaddingBottom = UDim.new(0, 8)
                            padding.PaddingLeft = UDim.new(0, 8)
                            padding.PaddingRight = UDim.new(0, 8)
        
                            
                            pcall(function()
                                local function sizeGridCells()
                                    if state.nativeCardAbsSize then
                                        grid.CellSize = state.nativeCardAbsSize
                                        return
                                    end
                                    local w = content.AbsoluteSize.X
                                    if not w or w <= 0 then return end
                                    
                                    local cellW = math.floor(w * 0.42)
                                    if cellW > 40 then
                                        grid.CellSize = UDim2.fromOffset(cellW, cellW)
                                        grid.CellPadding = UDim2.fromOffset(math.floor(w * 0.03), math.floor(w * 0.03))
                                        grid.HorizontalAlignment = Enum.HorizontalAlignment.Center
                                    end
                                end
                                sizeGridCells()
                                if state.gridSizeConn then state.gridSizeConn:Disconnect() end
                                state.gridSizeConn = content:GetPropertyChangedSignal("AbsoluteSize"):Connect(sizeGridCells)
                            end)
        
                            pcall(function()
                                content.BackgroundColor3 = Color3.fromRGB(37, 68, 155)
                                content.BackgroundTransparency = 1
                                content.BorderSizePixel = 0
                            end)
        
                            if content:IsA("ScrollingFrame") then
                                content.AutomaticCanvasSize = Enum.AutomaticSize.Y
                                content.CanvasSize = UDim2.fromScale(0, 0)
                                
                                content.ScrollBarThickness = 6
                                content.ScrollBarImageColor3 = Color3.fromRGB(150, 180, 235)
                                content.ScrollBarImageTransparency = 0.1
                            end
        
                            
                            
                            local batchSize = 12 
                            for index, entry in ipairs(state.catalog) do
                                makeEmoteWheelCard(content, entry, index)
                                
                                
                                if index % batchSize == 0 then 
                                    task.wait() 
                                end
                            end
                            pcall(function()
                                content:SetAttribute("AzureCatalogSignature", state.catalogSignature)
                                content:SetAttribute("AzureNativeStyled", state.nativeCardTemplate ~= nil)
                            end)
                        end
                    end)
                    state.applyingEmoteWheel = false
                    if not ok then
                        warn("Azure EmoteWheel install failed:", err)
                        return false
                    end
                    return true
                end
        
                state.initializeEmoteWheelList = function()
                    state.emoteWheelEnabled = true
                    local function tryApply()
                        if state.destroyed or not state.emoteWheelEnabled then return end
                        if #state.catalog == 0 then refreshCatalog() end
                        local now = os.clock()
                        if now - (state.lastWheelApply or 0) < 0.35 then return end
                        state.lastWheelApply = now
                        state.applyEmoteWheelList()
                    end
        
                    task.defer(tryApply)
                    if state.wheelInitialized then return end
                    state.wheelInitialized = true
                    
                    for i = 1, 3 do 
                        task.delay(i * 0.8, function()
                            if not state.destroyed and state.emoteWheelEnabled then tryApply() end
                        end)
                    end
        
                    if state.wheelConnection then
                        pcall(function() state.wheelConnection:Disconnect() end)
                        state.wheelConnection = nil
                    end
                    
                    
                    local runningThread
                    runningThread = task.spawn(function()
                        while not state.destroyed and state.emoteWheelEnabled do
                            task.wait(3) 
                            local pGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
                            if pGui then
                                
                                local hasWheel = pGui:FindFirstChild("EmoteWheel") ~= nil
                                if hasWheel then
                                    tryApply()
                                end
                            end
                        end
                    end)
                    
                    state.wheelConnection = {
                        Disconnect = function()
                            pcall(task.cancel, runningThread)
                        end
                    }
                end
        
                local function entryFromObject(item)
                    local candidates = {
                        item:GetAttribute("EmoteName"),
                        item:GetAttribute("AnimationId"),
                        item.Name,
                    }
                    
                    
                    for _, object in ipairs(item:GetChildren()) do
                        if object:IsA("TextLabel") or object:IsA("TextButton") then
                            candidates[#candidates + 1] = object.Text
                        elseif object:IsA("Animation") then
                            candidates[#candidates + 1] = object.Name
                            candidates[#candidates + 1] = object.AnimationId
                        end
                        
                    end
                    
                    
                    for _, candidate in ipairs(candidates) do
                        if candidate then
                            local entry = resolveEntry(candidate)
                            if entry then return entry end
                        end
                    end
                    return nil
                end
        
                local function entryFromCallback(callback)
                    local getUpvalues = getExecutorGlobal("getupvalues")
                    if type(callback) ~= "function" or type(getUpvalues) ~= "function" then
                        return nil
                    end
        
                    local ok, upvalues = pcall(getUpvalues, callback)
                    if not ok or type(upvalues) ~= "table" then return nil end
                    
                    
                    local maxCheck = 20 
                    local checked = 0
                    
                    for _, value in pairs(upvalues) do
                        checked = checked + 1
                        if checked > maxCheck then break end
                        
                        local entry = resolveEntry(value)
                        if entry then return entry end
                        
                        if typeof(value) == "Instance" and value:IsA("Animation") then
                            entry = resolveEntry(value.AnimationId) or resolveEntry(value.Name)
                            if entry then return entry end
                        end
                        
                    end
                    return nil
                end
        
                local function findNativeDispatcher(wantedEntry)
                    
                    if state.nativeDispatcher then
                        if type(state.nativeDispatcher.Callbacks) == "table"
                            and #state.nativeDispatcher.Callbacks > 0
                            and (not wantedEntry or sameEntry(state.nativeDispatcher.Original, wantedEntry)) then
                            return state.nativeDispatcher
                        end
                        if wantedEntry then
                            state.nativeDispatcher = nil
                        end
                    end
        
                    local contents = getAllWheelContents()
                    local getConnections = getExecutorGlobal("getconnections")
                    if #contents == 0 or type(getConnections) ~= "function" then
                        return nil
                    end
        
                    
                    local content = contents[1]
                    if not content then return nil end
                    
                    local children = content:GetChildren()
                    local maxCheck = math.min(#children, 10) 
                    
                    for i = 1, maxCheck do
                        local item = children[i]
                        if item:IsA("GuiObject") and not item:GetAttribute("AzureEmoteCard") then
                            local button = getButton(item)
                            if button then
                                
                                local ok, connections = pcall(getConnections, button.Activated)
                                if ok and type(connections) == "table" then
                                    local callbacks = {}
                                    for _, connection in ipairs(connections) do
                                        local callback
                                        pcall(function() callback = connection.Function end)
                                        if type(callback) == "function"
                                            and not (isourclosure and isourclosure(callback)) then
                                            callbacks[#callbacks + 1] = callback
                                            if #callbacks >= 3 then break end 
                                        end
                                    end
                                    if #callbacks > 0 then
                                        local original = entryFromObject(item)
                                        if original and (not wantedEntry or sameEntry(original, wantedEntry)) then
                                            state.nativeDispatcher = {
                                                WheelContent = content,
                                                Signal = button.Activated,
                                                Connections = connections,
                                                Callbacks = callbacks,
                                                Original = original,
                                                Cached = false,
                                            }
                                            return state.nativeDispatcher
                                        end
                                    end
                                end
                            end
                        end
                    end
                    return nil
                end
        
                local function trackSound(sound)
                    if not sound or not sound:IsA("Sound") then return end
                    state.activeSounds[#state.activeSounds + 1] = sound
                    pcall(function()
                        if sound.Volume <= 0 then
                            sound.Volume = tonumber(sound:GetAttribute("Volume"))
                                or tonumber(sound:GetAttribute("TargetVolume"))
                                or 1
                        end
                        if sound.RollOffMaxDistance < 40 then
                            sound.RollOffMaxDistance = 80
                        end
                        if not sound.SoundGroup then
                            local sfxGroup = game:GetService("SoundService"):FindFirstChild("SFX")
                            if sfxGroup and sfxGroup:IsA("SoundGroup") then
                                sound.SoundGroup = sfxGroup
                            end
                        end
                        sound.TimePosition = 0
                        sound:Play()
                    end)
                    task.delay(0.25, function()
                        if state.destroyed or not sound or not sound.Parent then return end
                        pcall(function()
                            if not sound.IsPlaying and sound.SoundId ~= "" then
                                sound.TimePosition = 0
                                sound:Play()
                            end
                        end)
                    end)
                end
        
                local function getSoundKey(sound, fallback)
                    if typeof(sound) ~= "Instance" or not sound:IsA("Sound") then
                        return tostring(fallback or "")
                    end
        
                    local fullName = sound.Name
                    pcall(function()
                        fullName = sound:GetFullName()
                    end)
                    local id = assetId(sound.SoundId)
                    return table.concat({
                        "template",
                        fullName or sound.Name,
                        id or normalize(sound.SoundId),
                        fallback or "",
                    }, ":")
                end
        
                local function playSoundTemplate(template, parent, allowReplay, customKey)
                    if typeof(template) ~= "Instance" or not template:IsA("Sound") then return false end
                    local key = customKey or getSoundKey(template)
                    if not allowReplay and state.playedSoundKeys[key] then return false end
        
                    local ok, sound = pcall(function()
                        return template:Clone()
                    end)
                    if not ok or not sound then return false end
        
                    if not allowReplay then state.playedSoundKeys[key] = true end
                    sound.Parent = parent
                    trackSound(sound)
                    return true
                end
        
                local function playSoundValue(value, parent, allowReplay, customKey)
                    if typeof(value) == "Instance" and value:IsA("Sound") then
                        return playSoundTemplate(value, parent, allowReplay, customKey)
                    end
        
                    local text = tostring(value or "")
                    if text == "" then return false end
        
                    local id = assetId(text)
                local key = customKey or (id and ("id:" .. id) or ("name:" .. normalize(text)))
                if not allowReplay and state.playedSoundKeys[key] then return false end
        
                local template
                if not id then
                    template = getSoundByName(text)
                end
        
                local sound
                if template then
                    return playSoundTemplate(template, parent, allowReplay, key)
                elseif id then
                    sound = Instance.new("Sound")
                    sound.SoundId = "rbxassetid://" .. id
                    sound.Volume = 1
                end
                if not sound then return false end
        
                if not allowReplay then state.playedSoundKeys[key] = true end
                sound.Parent = parent
                trackSound(sound)
                return true
            end
        
            state.collectNativeSoundCues = state.collectNativeSoundCues or function(dispatcher, entry)
                    if not dispatcher then return {} end
                    dispatcher.SoundCuesCache = dispatcher.SoundCuesCache or {}
                    local cacheKey = tostring(entry.Name)
                    if dispatcher.SoundCuesCache[cacheKey] then
                        return dispatcher.SoundCuesCache[cacheKey]
                    end
        
                    local getUpvalues = getExecutorGlobal("getupvalues")
                    if type(getUpvalues) ~= "function" then return {} end
        
                    local aliases = {
                        [normalize(entry.Name)] = true,
                        [normalize(entry.Id)] = true,
                        [normalize(entry.Animation.AnimationId)] = true,
                    }
                    for _, value in pairs(entry.Attributes or {}) do
                        aliases[normalize(tostring(value))] = true
                    end
        
                    local cues = {}
                    local seenCue = {}
                    local seenTable = {}
                    local seenInstance = {}
                    local scanCount = 0
        
                    local function isAlias(value)
                        local key = normalize(value)
                        return key ~= "" and aliases[key] == true
                    end
        
                    local function soundKey(value)
                        local key = normalize(value)
                        return key:find("sound", 1, true)
                            or key:find("audio", 1, true)
                            or key:find("music", 1, true)
                            or key:find("sfx", 1, true)
                            or key:find("song", 1, true)
                            or key:find("track", 1, true)
                    end
        
                    local function timeKey(value)
                        local key = normalize(value)
                        return key == "time"
                            or key == "delay"
                            or key == "start"
                            or key == "starttime"
                            or key == "soundtime"
                            or key == "timestamp"
                    end
        
                    local function addCue(value, delay)
                        local text = tostring(value or "")
                        if text == "" then return false end
        
                        local isSoundInstance = typeof(value) == "Instance" and value:IsA("Sound")
                        if isSoundInstance then
                            text = tostring(value.SoundId or value.Name or "")
                        end
        
                        local id = assetId(text)
                        local cueValue = text
                        if isSoundInstance then
                            cueValue = value
                        elseif id and #id >= 5 then
                            cueValue = "rbxassetid://" .. id
                        elseif type(value) == "number" and value >= 10000 then
                            cueValue = "rbxassetid://" .. tostring(math.floor(value + 0.5))
                        elseif type(value) ~= "string" and typeof(value) ~= "Instance" then
                            return false
                        end
        
                        delay = tonumber(delay)
                        if delay then
                            delay = math.clamp(delay, 0, 30)
                        else
                            delay = 0.45 + (#cues * 0.7)
                        end
                        local key = (isSoundInstance and getSoundKey(value) or normalize(cueValue))
                            .. ":"
                            .. tostring(math.floor(delay * 100 + 0.5))
                        if seenCue[key] then return false end
                        seenCue[key] = true
                        cues[#cues + 1] = {
                            Value = cueValue,
                            Delay = delay,
                        }
                        return true
                    end
        
                    local function scan(value, depth, inSoundBranch, delayHint, matchedBranch)
                        if depth > 4 or scanCount > 400 then return end
                        scanCount = scanCount + 1
        
                        local valueType = typeof(value)
                        if valueType == "Instance" then
                            if seenInstance[value] then return end
                            seenInstance[value] = true
        
                            local nameMatches = isAlias(value.Name)
                            if value:IsA("Sound") then
                                if inSoundBranch or matchedBranch or nameMatches or soundKey(value.Name) then
                                    addCue(value, delayHint)
                                end
                                return
                            end
        
                            local attrs = {}
                            pcall(function()
                                attrs = value:GetAttributes()
                            end)
                            local nextMatched = matchedBranch or nameMatches
                            for attrName, attrValue in pairs(attrs) do
                                local nextSoundBranch = inSoundBranch or soundKey(attrName)
                                local nextDelay = delayHint
                                if timeKey(attrName) then nextDelay = tonumber(attrValue) or delayHint end
                                if nextSoundBranch or nextMatched then
                                    scan(attrValue, depth + 1, nextSoundBranch, nextDelay, nextMatched)
                                end
                            end
        
                            if nextMatched or soundKey(value.Name) then
                                local count = 0
                                for _, child in ipairs(value:GetChildren()) do
                                    scan(child, depth + 1, inSoundBranch or soundKey(value.Name), delayHint, nextMatched)
                                    count = count + 1
                                    if count >= 80 then break end
                                end
                            end
                            return
                        end
        
                        if type(value) == "table" then
                            if seenTable[value] then return end
                            seenTable[value] = true
        
                            local tableMatched = matchedBranch
                            local tableSoundBranch = inSoundBranch
                            local tableDelay = delayHint
        
                            local tCount = 0
                            for key, fieldValue in pairs(value) do
                                tCount = tCount + 1
                                if tCount > 150 then break end
                                if isAlias(key) or isAlias(fieldValue) then
                                    tableMatched = true
                                end
                                if soundKey(key) then
                                    tableSoundBranch = true
                                end
                                if timeKey(key) then
                                    tableDelay = tonumber(fieldValue) or tableDelay
                                elseif type(key) == "number" and key >= 0 and key <= 30 then
                                    tableDelay = key
                                end
                            end
        
                            tCount = 0
                            for key, fieldValue in pairs(value) do
                                tCount = tCount + 1
                                if tCount > 150 then break end
                                local nextSoundBranch = tableSoundBranch or soundKey(key)
                                local nextMatched = tableMatched or isAlias(key) or isAlias(fieldValue)
                                local nextDelay = tableDelay
                                if timeKey(key) then
                                    nextDelay = tonumber(fieldValue) or nextDelay
                                elseif type(key) == "number" and key >= 0 and key <= 30 then
                                    nextDelay = key
                                end
        
                                if nextSoundBranch or nextMatched then
                                    if not addCue(fieldValue, nextDelay) then
                                        scan(fieldValue, depth + 1, nextSoundBranch, nextDelay, nextMatched)
                                    end
                                elseif type(fieldValue) == "table" or typeof(fieldValue) == "Instance" then
                                    scan(fieldValue, depth + 1, false, nextDelay, false)
                                end
                            end
                            return
                        end
        
                        if inSoundBranch or matchedBranch then
                            addCue(value, delayHint)
                        end
                    end
        
                    for _, callback in ipairs(dispatcher.Callbacks or {}) do
                        local ok, upvalues = pcall(getUpvalues, callback)
                        if ok and type(upvalues) == "table" then
                            for _, upvalue in pairs(upvalues) do
                                scan(upvalue, 0, false, nil, false)
                            end
                        end
                    end
        
                    table.sort(cues, function(left, right)
                        return (left.Delay or 0) < (right.Delay or 0)
                    end)
                    dispatcher.SoundCuesCache[cacheKey] = cues
                    return cues
                end
        
                state.scheduleNativeSoundCues = state.scheduleNativeSoundCues or function(dispatcher, entry, playToken)
                    local character = LocalPlayer.Character
                    local root = character and character:FindFirstChild("HumanoidRootPart")
                    if not root then return 0 end
        
                    local cues = state.collectNativeSoundCues(dispatcher, entry)
                    if #cues == 0 then return 0 end
        
                    local maxCues = math.min(#cues, 18)
                    for index = 1, maxCues do
                        local cue = cues[index]
                        local delayTime = tonumber(cue.Delay) or (0.45 + (index - 1) * 0.7)
                        if delayTime < 0.18 then delayTime = 0.18 end
                        task.delay(delayTime, function()
                            if state.destroyed or state.playToken ~= playToken then return end
                            local valueKey = typeof(cue.Value) == "Instance"
                                and getSoundKey(cue.Value)
                                or tostring(cue.Value)
                            playSoundValue(cue.Value, root, false, valueKey .. ":" .. tostring(math.floor(delayTime * 1000 + 0.5)))
                        end)
                    end
                    return maxCues
                end
        
                local function initializeEmoteObservers()
                    if state.observersInitialized then return end
                    state.observersInitialized = true
        
                    local roots = {}
                    local replicatedObservers = ReplicatedStorage:FindFirstChild("Observers")
                    local replicatedEmotes = replicatedObservers and replicatedObservers:FindFirstChild("Emotes")
                    if replicatedEmotes then roots[#roots + 1] = replicatedEmotes end
        
                    local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
                    local guiObservers = playerGui and playerGui:FindFirstChild("Observers", true)
                    local guiEmotes = guiObservers and guiObservers:FindFirstChild("Emotes")
                    if guiEmotes and guiEmotes ~= replicatedEmotes then roots[#roots + 1] = guiEmotes end
        
                    local loadedNames = {}
                    for _, emoteObservers in ipairs(roots) do
                        for _, moduleScript in ipairs(emoteObservers:GetDescendants()) do
                            if moduleScript:IsA("ModuleScript") and not loadedNames[moduleScript.Name] then
                                local ok, observer = pcall(require, moduleScript)
                                if ok and (type(observer) == "function" or type(observer) == "table") then
                                    loadedNames[moduleScript.Name] = true
                                    state.observerExports[#state.observerExports + 1] = {
                                        Name = moduleScript.Name,
                                        Export = observer,
                                    }
                                end
                            end
                        end
                    end
                end
        
                local function dispatchEmoteObservers(root)
                    initializeEmoteObservers()
                    local character = LocalPlayer.Character
                    if not character or typeof(root) ~= "Instance" then return end
                    local collectionService = game:GetService("CollectionService")
                    local targets = {root}
                    for _, object in ipairs(root:GetDescendants()) do
                        targets[#targets + 1] = object
                    end
        
                    for _, record in ipairs(state.observerExports) do
                        local observer = record.Export or record
                        local observerName = record.Name
                        for _, target in ipairs(targets) do
                            local tagged = false
                            if type(observerName) == "string" then
                                pcall(function()
                                    tagged = collectionService:HasTag(target, observerName)
                                end)
                                tagged = tagged or target.Name == observerName
                            end
                            if tagged then
                                if type(observer) == "function" then
                                    local ok = pcall(observer, target)
                                    if not ok then ok = pcall(observer, target, character) end
                                    if not ok then pcall(observer, character, target) end
                                elseif type(observer) == "table" then
                                    for _, methodName in ipairs({
                                        "Observe",
                                        "Apply",
                                        "Start",
                                        "Create",
                                        "OnAdded",
                                        }) do
                                        local method = observer[methodName]
                                        if type(method) == "function" then
                                            local ok = pcall(method, observer, target)
                                            if not ok then
                                                ok = pcall(method, target)
                                            end
                                            if not ok then ok = pcall(method, observer, target, character) end
                                            if not ok then pcall(method, target, character) end
                                            break
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
        
                local function collectVFXObjects(root)
                    local objects = {root}
                    if typeof(root) == "Instance" then
                        for _, object in ipairs(root:GetDescendants()) do
                            objects[#objects + 1] = object
                        end
                    end
                    return objects
                end
        
                local function emoteTween(object, delayTime, duration, properties)
                    if not object or not next(properties) then return end
                    task.delay(math.max(tonumber(delayTime) or 0, 0), function()
                        if not object or not object.Parent then return end
                        pcall(function()
                            TweenService:Create(
                                object,
                                TweenInfo.new(math.max(tonumber(duration) or 0.18, 0.05), Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                                properties
                            ):Play()
                        end)
                    end)
                end
        
                local function fadeOutEmoteVFX(root)
                    if typeof(root) ~= "Instance" then return end
        
                    local fadeTime = 0.28
                    for _, object in ipairs(collectVFXObjects(root)) do
                        if object and object.Parent then
                            if object:IsA("ParticleEmitter") or object:IsA("Beam") or object:IsA("Trail") then
                                pcall(function() object.Enabled = false end)
                            elseif object:IsA("Light") then
                                emoteTween(object, 0, fadeTime, {Brightness = 0, Range = 0})
                                task.delay(fadeTime, function()
                                    if object and object.Parent then object.Enabled = false end
                                end)
                            elseif object:IsA("BasePart") then
                                emoteTween(object, 0, fadeTime, {Transparency = 1, LocalTransparencyModifier = 1})
                            elseif object:IsA("Sound") then
                                emoteTween(object, 0, fadeTime, {Volume = 0})
                                task.delay(fadeTime, function()
                                    if object and object.Parent then pcall(function() object:Stop() end) end
                                end)
                            end
                        end
                    end
        
                    task.delay(fadeTime + 0.12, function()
                        if root and root.Parent then
                            pcall(function() root:Destroy() end)
                        end
                    end)
                end
        
                local function parseEmoteNumber(value)
                    if value == nil then return nil end
                    if type(value) == "string" then
                        value = value:gsub(",", ".")
                    end
                    return tonumber(value)
                end
        
                local function getEmoteAttribute(object, names)
                    local cursor = object
                    local depth = 0
                    while cursor and depth < 6 do
                        for _, name in ipairs(names) do
                            local ok, value = pcall(function()
                                return cursor:GetAttribute(name)
                            end)
                            if ok and value ~= nil then
                                return value, cursor
                            end
                        end
                        cursor = cursor.Parent
                        depth = depth + 1
                    end
                    return nil
                end
        
                local function getVFXNodeMode(object, root)
                    local cursor = object
                    local fallbackMode = nil
                    local fallbackController = nil
                    while cursor and cursor ~= root.Parent do
                        local name = tostring(cursor.Name or ""):lower()
                        local attributes = cursor:GetAttributes()
                        local hasEmitFrame = false
                        local hasEnableFrame = false
                        for attributeName in pairs(attributes) do
                            if tostring(attributeName):match('^EmitFrame%d*$') then
                                hasEmitFrame = true
                            elseif attributeName == 'EnableFrame' or attributeName == 'DisableFrame' then
                                hasEnableFrame = true
                            end
                        end
                        if hasEmitFrame and hasEnableFrame then return 'Mixed', cursor end
                        if hasEmitFrame then return 'Emit', cursor end
                        if hasEnableFrame then return 'Enable', cursor end
        
                        if cursor:IsA('Folder') then
                            if name:find('emit', 1, true) then
                                return 'Emit', cursor
                            elseif name:find('enable', 1, true) or name:find('loop', 1, true) then
                                return 'Enable', cursor
                            end
                        elseif not fallbackMode then
                            if name:find('emit', 1, true) then
                                fallbackMode, fallbackController = 'Emit', cursor
                            elseif name:find('enable', 1, true) or name:find('loop', 1, true) then
                                fallbackMode, fallbackController = 'Enable', cursor
                            end
                        end
                        cursor = cursor.Parent
                    end
                    return fallbackMode, fallbackController
                end
        
                local function getVFXFrameSchedule(object, root)
                    local mode, controller = getVFXNodeMode(object, root)
                    local emitTimes = {}
                    local disableTime = nil
                    if not controller then return mode, emitTimes, disableTime end
        
                    local seen = {}
                    for name, value in pairs(controller:GetAttributes()) do
                        local frame = parseEmoteNumber(value)
                        if frame then
                            if tostring(name):match('^EmitFrame%d*$') then
                                local time = math.max(frame / 60, 0)
                                if not seen[time] then
                                    seen[time] = true
                                    emitTimes[#emitTimes + 1] = time
                                end
                            elseif name == 'DisableFrame' then
                                disableTime = math.max(frame / 60, 0)
                            end
                        end
                    end
                    table.sort(emitTimes)
                    return mode, emitTimes, disableTime
                end
        
                local function getVFXDelay(object, entry)
                    local cueSpec = state.getVFXObjectCueSpec(object, entry)
                    local delayTime = cueSpec.Time
                    if delayTime == nil then
                        local enableFrame = parseEmoteNumber((getEmoteAttribute(object, {
                            "AzureEnableFrame",
                            "EnableFrame",
                            "Frame",
                            "StartFrame",
                        })))
                        if enableFrame then
                            delayTime = math.max(enableFrame / 60, 0)
                        end
                    end
                    local elapsed = math.max(os.clock() - (state.mediaStartedAt or os.clock()), 0)
                    return math.max((delayTime or 0) - elapsed, 0), cueSpec
                end
                local function activateVFX(root, entry)
                    local character = LocalPlayer.Character
                    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
                    if not root or not rootPart then return end
                    local playToken = state.playToken
        
                    dispatchEmoteObservers(root)
        
                    local objects = {root}
                    for _, object in ipairs(root:GetDescendants()) do
                        objects[#objects + 1] = object
                    end
        
                    local function applyObject(object)
                        if state.destroyed or state.playToken ~= playToken then return end
                        if not object or not object.Parent then return end
                        if object:IsA("Sound") then
                            if not object:GetAttribute("AzurePlayed") then
                                object:SetAttribute("AzurePlayed", true)
                                trackSound(object)
                            end
                        elseif object:IsA("ParticleEmitter") then
                            local mode = getVFXNodeMode(object, root)
                            local emitCount = parseEmoteNumber(object:GetAttribute("EmitCount"))
                                or parseEmoteNumber(object:GetAttribute("ParticleCount"))
                                or parseEmoteNumber(object:GetAttribute("Count"))
                            local emitDelay = parseEmoteNumber(object:GetAttribute("EmitDelay"))
                                or parseEmoteNumber(object:GetAttribute("Delay"))
                                or 0
        
                            if mode == "Emit" or mode == "Mixed" then
                                object.Enabled = false
                                task.delay(math.max(emitDelay, 0), function()
                                    if object and object.Parent and state.playToken == playToken and not state.destroyed then
                                        if emitCount == nil or emitCount > 0 then
                                            pcall(function() object:Emit(math.max(math.floor(emitCount or 1), 1)) end)
                                        elseif mode == "Mixed" then
                                            pcall(function() object.Enabled = true end)
                                        end
                                    end
                                end)
                            elseif mode == "Enable" then
                                task.delay(math.max(emitDelay, 0), function()
                                    if object and object.Parent and state.playToken == playToken and not state.destroyed then
                                        if emitCount and emitCount > 0 then
                                            object.Enabled = false
                                            pcall(function() object:Emit(math.max(math.floor(emitCount), 1)) end)
                                        else
                                            pcall(function() object.Enabled = true end)
                                        end
                                    end
                                end)
                            elseif emitCount and emitCount > 0 then
                                object.Enabled = false
                                task.delay(math.max(emitDelay, 0), function()
                                    if object and object.Parent and state.playToken == playToken and not state.destroyed then
                                        pcall(function() object:Emit(math.max(math.floor(emitCount), 1)) end)
                                    end
                                end)
                            else
                                task.delay(math.max(emitDelay, 0), function()
                                    if object and object.Parent and state.playToken == playToken and not state.destroyed then
                                        pcall(function() object.Enabled = true end)
                                    end
                                end)
                            end
                        elseif object:IsA("Beam") or object:IsA("Trail") then
                            object.Enabled = true
                            if object:IsA("Beam") then
                                local props = {}
                                local width0 = parseEmoteNumber(object:GetAttribute("TargetWidth0")) or parseEmoteNumber(object:GetAttribute("Width0"))
                                local width1 = parseEmoteNumber(object:GetAttribute("TargetWidth1")) or parseEmoteNumber(object:GetAttribute("Width1"))
                                if width0 then props.Width0 = width0 end
                                if width1 then props.Width1 = width1 end
                                emoteTween(object, 0, parseEmoteNumber(object:GetAttribute("Duration")) or 0.25, props)
                            end
                        elseif object:IsA("Light") then
                            object.Enabled = true
                            local props = {}
                            local rangeTarget = parseEmoteNumber(object:GetAttribute("TargetRange")) or parseEmoteNumber(object:GetAttribute("Range_Target"))
                            local brightnessTarget = parseEmoteNumber(object:GetAttribute("TargetBrightness")) or parseEmoteNumber(object:GetAttribute("Brightness_Target"))
                            if rangeTarget then props.Range = rangeTarget end
                            if brightnessTarget then props.Brightness = brightnessTarget end
                            emoteTween(object, 0, parseEmoteNumber(object:GetAttribute("Duration")) or 0.25, props)
                        elseif object:IsA("BasePart") then
                            object.CanCollide = false
                            object.CanTouch = false
                            object.CanQuery = false
                            object.Massless = true
                            local props = {}
                            local transparencyTarget = parseEmoteNumber(object:GetAttribute("Transparency_Target"))
                                or parseEmoteNumber(object:GetAttribute("TargetTransparency"))
                            if transparencyTarget then props.Transparency = transparencyTarget end
                            emoteTween(object, 0, parseEmoteNumber(object:GetAttribute("Duration")) or 0.25, props)
                        end
                    end
        
                    local function cleanupObject(object)
                        if state.destroyed or state.playToken ~= playToken then return end
                        if not object or not object.Parent then return end
                        if object:IsA("Sound") then
                            pcall(function() object:Stop() end)
                        elseif object:IsA("ParticleEmitter")
                            or object:IsA("Beam")
                            or object:IsA("Trail") then
                            pcall(function() object.Enabled = false end)
                        elseif object:IsA("Light") then
                            pcall(function() object.Enabled = false end)
                        end
                    end
        
                    for _, object in ipairs(objects) do
                        local delayTime, cueSpec = getVFXDelay(object, entry)
                        local mode, emitTimes, disableTime = getVFXFrameSchedule(object, root)
                        local elapsed = math.max(os.clock() - (state.mediaStartedAt or os.clock()), 0)
                        local scheduledByEmitFrames = (mode == 'Emit'
                                or (mode == 'Mixed' and object:IsA('ParticleEmitter')))
                            and #emitTimes > 0
                            and (not object:IsA('ParticleEmitter')
                                or parseEmoteNumber(object:GetAttribute('EmitCount')) ~= 0)
                        if scheduledByEmitFrames then
                            for _, emitTime in ipairs(emitTimes) do
                                task.delay(math.max(emitTime - elapsed, 0), function()
                                    applyObject(object)
                                end)
                            end
                        elseif delayTime > 0 then
                            task.delay(delayTime, function()
                                applyObject(object)
                            end)
                        else
                            applyObject(object)
                        end
        
                        if disableTime then
                            task.delay(math.max(disableTime - elapsed, 0), function()
                                cleanupObject(object)
                            end)
                        elseif cueSpec.CleanupTime then
                            local cleanupDelay = math.max(delayTime + cueSpec.CleanupTime, 0)
                            task.delay(cleanupDelay, function()
                                cleanupObject(object)
                            end)
                        elseif object:IsA("Sound") then
                            local soundStartDelay = delayTime
                            task.delay(soundStartDelay, function()
                                if state.destroyed
                                    or state.playToken ~= playToken
                                    or not object.Parent
                                    or object.Looped then
                                    return
                                end
        
                                pcall(function()
                                    if not object.IsLoaded then
                                        object.Loaded:Wait()
                                    end
                                end)
        
                                local length = tonumber(object.TimeLength) or 0
                                if length <= 0 then return end
                                task.wait(length + 0.5)
                                if state.destroyed
                                    or state.playToken ~= playToken
                                    or not object.Parent
                                    or object.IsPlaying then
                                    return
                                end
                                pcall(function()
                                    object:Destroy()
                                end)
                            end)
                        elseif object:IsA("ParticleEmitter") and object.Rate <= 0 and mode ~= 'Enable' then
                            task.delay(math.max(delayTime + 2.5, 0), function()
                                cleanupObject(object)
                            end)
                        end
                    end
                end
        
        
                local function collectPayloadInstances(value, output, seenTables, seenInstances)
                    if typeof(value) == "Instance" then
                        if value:IsA("Animation")
                            or value:IsA("ModuleScript")
                            or value:IsA("Script")
                            or value:IsA("LocalScript")
                            or value:IsA("BindableFunction")
                            or value:IsA("BindableEvent")
                            or value:IsA("RemoteEvent")
                            or value:IsA("RemoteFunction") then
                            return
                        end
                        if not seenInstances[value] then
                            seenInstances[value] = true
                            output[#output + 1] = value
                        end
                        return
                    end
                    if type(value) ~= "table" or seenTables[value] then return end
                    seenTables[value] = true
                    for _, fieldValue in pairs(value) do
                        collectPayloadInstances(fieldValue, output, seenTables, seenInstances)
                    end
                end
        
        
        
        
                local function getEmoteVFXRoots()
                    local now = os.clock()
                    if state.vfxRootCache and now - (state.vfxRootCacheAt or 0) < 5 then
                        local valid = {}
                        for _, root in ipairs(state.vfxRootCache) do
                            if typeof(root) == "Instance" and root.Parent then
                                valid[#valid + 1] = root
                            end
                        end
                        if #valid > 0 then return valid end
                    end
        
                    local roots = {}
                    local seen = {}
                    local function addRoot(obj)
                        if obj and not seen[obj] then seen[obj] = true; roots[#roots + 1] = obj end
                    end
        
                    
                    local shared = ReplicatedStorage:FindFirstChild("Shared")
                    local replicatedInstances = ReplicatedStorage:FindFirstChild("ReplicatedInstances") or (shared and shared:FindFirstChild("ReplicatedInstances"))
                    addRoot(ReplicatedStorage:FindFirstChild('DeserializedInstances'))
                    if replicatedInstances then
                        addRoot(replicatedInstances:FindFirstChild("EmoteVFX"))
                        addRoot(replicatedInstances:FindFirstChild("Emotes"))
                        addRoot(replicatedInstances:FindFirstChild("Effects"))
                        addRoot(replicatedInstances:FindFirstChild("EmoteAccessory"))
                    end
                    if shared then
                        addRoot(shared:FindFirstChild("EmoteVFX", true))
                    end
        
                    
                    local misc = ReplicatedStorage:FindFirstChild("Misc")
                    local emotesFolder = misc and misc:FindFirstChild("Emotes")
                    if emotesFolder then
                        addRoot(emotesFolder:FindFirstChild("VFX"))
                        addRoot(emotesFolder:FindFirstChild("Effects"))
                        addRoot(emotesFolder)
                    end
        
                    
                    local scanned = 0
                    for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do
                        scanned = scanned + 1
                        if scanned > 2500 or #roots >= 12 then break end
                        if obj:IsA("Folder") or obj:IsA("Model") then
                            local lname = obj.Name:lower()
                            if lname:find("emotevfx", 1, true) or lname:find("emote_vfx", 1, true) then
                                addRoot(obj)
                            end
                        end
                    end
        
                    
                    local workspaceScanned = 0
                    for _, obj in ipairs(workspace:GetDescendants()) do
                        workspaceScanned = workspaceScanned + 1
                        if workspaceScanned > 3500 or #roots >= 18 then break end
                        if obj:IsA("Folder") or obj:IsA("Model") then
                            local lname = obj.Name:lower()
                            if lname:find("emotevfx", 1, true)
                                or lname:find("emote_vfx", 1, true)
                                or lname == "emotevfx_storage" then
                                addRoot(obj)
                            end
                        end
                    end
        
                    
                    local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
                    if playerGui then
                        local playerInstances = playerGui:FindFirstChild("ReplicatedInstances", true)
                        if playerInstances then
                            addRoot(playerInstances:FindFirstChild("EmoteVFX"))
                            addRoot(playerInstances:FindFirstChild("Emotes"))
                        end
                        local playerVFX = playerGui:FindFirstChild("EmoteVFX", true)
                        addRoot(playerVFX)
                    end
        
                    state.vfxRootCache = roots
                    state.vfxRootCacheAt = now
                    return roots
                end
        
                local function getDirectDeserializedEmotePayload(entry)
                    if not entry then return nil end
                    local deserialized = ReplicatedStorage:FindFirstChild("DeserializedInstances")
                    if not deserialized then return nil end
        
                    local candidates = {
                        entry.Id,
                        entry.Animation and entry.Animation.Name,
                        entry.Name,
                    }
                    for attributeName, attributeValue in pairs(entry.Attributes or {}) do
                        local lowered = normalize(attributeName)
                        if lowered:find("emote", 1, true)
                            or lowered:find("vfx", 1, true)
                            or lowered:find("effect", 1, true)
                            or lowered == "id"
                            or lowered == "name" then
                            candidates[#candidates + 1] = attributeValue
                        end
                    end
        
                    for _, candidate in ipairs(candidates) do
                        if candidate ~= nil and tostring(candidate) ~= "" then
                            local exact = deserialized:FindFirstChild(tostring(candidate))
                            if exact and not exact:IsA("Animation") then
                                return exact
                            end
                        end
                    end
        
                    local wanted = normalize(entry.Id)
                    if wanted ~= "" then
                        for _, child in ipairs(deserialized:GetChildren()) do
                            if normalize(child.Name) == wanted then
                                return child
                            end
                        end
                    end
                    return nil
                end
        
                state.getEmoteAccessoryPayload = state.getEmoteAccessoryPayload or function(entry)
                    state.emoteAccessoryCache = state.emoteAccessoryCache or {}
                    local cacheKey = tostring(entry and (entry.Animation and entry.Animation.AnimationId or entry.Id or entry.Name) or "")
                    if state.emoteAccessoryCache[cacheKey] ~= nil then
                        local cached = state.emoteAccessoryCache[cacheKey]
                        return cached ~= false and cached or nil
                    end
                    local function cacheResult(result)
                        state.emoteAccessoryCache[cacheKey] = result
                        return result
                    end
        
                    local shared = ReplicatedStorage:FindFirstChild("Shared")
                    local repInst = ReplicatedStorage:FindFirstChild("ReplicatedInstances") or (shared and shared:FindFirstChild("ReplicatedInstances"))
                    if not repInst then return cacheResult(nil) end
        
                    local emoteAccFolder = repInst:FindFirstChild("EmoteAccessories")
                    if not emoteAccFolder then return cacheResult(nil) end
        
                    local values = {
                        entry.Id,
                        entry.Name,
                        entry.Animation,
                        entry.Animation and entry.Animation.AnimationId,
                        tostring(entry.Id),
                        tostring(entry.Name),
                    }
                    for attributeName, attributeValue in pairs(entry.Attributes or {}) do
                        local lowered = normalize(attributeName)
                        if lowered:find("emote", 1, true)
                            or lowered:find("accessory", 1, true)
                            or lowered:find("prop", 1, true)
                            or lowered:find("animation", 1, true)
                            or lowered == "id"
                            or lowered == "name" then
                            values[#values + 1] = attributeValue
                        end
                    end
        
                    local function isMatch(name)
                        if not name then return false end
                        local n = string.lower(string.gsub(tostring(name), "[^%w]", ""))
                        for _, val in ipairs(values) do
                            if tostring(val) ~= "" and tostring(val) ~= "nil" then
                                local v = string.lower(string.gsub(tostring(val), "[^%w]", ""))
                                if n == v or string.find(n, v, 1, true) or string.find(v, n, 1, true) then
                                    return true
                                end
                            end
                        end
                        return false
                    end
        
                    emoteDebugWarn("Azure Debug -> Searching EmoteAccessories for:", entry.Name)
        
                    local function collectAccessoryReturns(results)
                        if type(results) ~= "table" or not results[1] then return nil end
                        local payloads = {}
                        for index = 2, results.n or #results do
                            local value = results[index]
                            if value ~= nil
                                and (typeof(value) == "Instance" or type(value) == "table") then
                                payloads[#payloads + 1] = value
                            end
                        end
                        if #payloads == 1 then return payloads[1] end
                        if #payloads > 1 then return payloads end
                        return nil
                    end
        
                    
                    for _, bf in ipairs(emoteAccFolder:GetDescendants()) do
                        if bf:IsA("BindableFunction") then
                            emoteDebugWarn("Azure Debug -> Found BindableFunction:", bf.Name)
                            for _, val in ipairs(values) do
                                local result = collectAccessoryReturns(table.pack(pcall(function()
                                    return bf:Invoke(val)
                                end)))
                                if result then
                                    emoteDebugWarn("Azure Debug -> BindableFunction RETURNED SUCCESS:", tostring(result))
                                    return cacheResult(result)
                                end
                            end
                        end
                    end
        
                    local accessoryModules = {}
                    if emoteAccFolder:IsA("ModuleScript") then
                        accessoryModules[#accessoryModules + 1] = emoteAccFolder
                    end
                    for _, ms in ipairs(emoteAccFolder:GetDescendants()) do
                        if ms:IsA("ModuleScript") then
                            accessoryModules[#accessoryModules + 1] = ms
                        end
                    end
                    for _, ms in ipairs(accessoryModules) do
                        if ms:IsA("ModuleScript") then
                            emoteDebugWarn("Azure Debug -> Found ModuleScript:", ms.Name, ms.ClassName)
                            local ok, module = pcall(require, ms)
                            if not ok then
                                emoteDebugWarn("Azure Debug -> Require FAILED for", ms.Name, ":", tostring(module))
                                continue
                            end
        
                            if type(module) == "function" then
                                for _, val in ipairs(values) do
                                    local called, result = pcall(module, val)
                                    if called and result
                                        and (typeof(result) == "Instance" or type(result) == "table") then
                                        return cacheResult(result)
                                    end
                                end
                            elseif type(module) == "table" then
                                for k, result in pairs(module) do
                                    if (typeof(result) == "Instance" or type(result) == "table") and isMatch(k) then
                                        emoteDebugWarn("Azure Debug -> Module matched key:", k)
                                        return cacheResult(result)
                                    end
                                end
                                for _, methodName in ipairs({"GetInstance", "GetEmoteAccessory", "Get", "Find", "Resolve"}) do
                                    local method = module[methodName]
                                    if type(method) == "function" then
                                        for _, val in ipairs(values) do
                                            local called, result = pcall(method, module, val)
                                            if not called then called, result = pcall(method, val) end
                                            if called and result
                                                and (typeof(result) == "Instance" or type(result) == "table") then
                                                return cacheResult(result)
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
        
                    
                    for _, inst in ipairs(emoteAccFolder:GetChildren()) do
                        if inst:IsA("Model") or inst:IsA("Folder") or inst:IsA("Accessory") then
                            if isMatch(inst.Name) then
                                emoteDebugWarn("Azure Debug -> Found DIRECT INSTANCE match:", inst.Name)
                                return cacheResult(inst)
                            end
                        end
                    end
        
                    emoteDebugWarn("Azure Debug -> getEmoteAccessoryPayload NOTHING FOUND")
                    return cacheResult(nil)
                end
        
                state.invokeGetEmoteVFX = state.invokeGetEmoteVFX or function(entry)
                    local character = LocalPlayer.Character
                    local values = {
                        entry.Id,
                        entry.Name,
                        entry.Animation,
                        entry.Animation.AnimationId,
                    }
                    for attributeName, attributeValue in pairs(entry.Attributes or {}) do
                        local lowered = normalize(attributeName)
                        if lowered:find("emote", 1, true)
                            or lowered:find("vfx", 1, true)
                            or lowered:find("effect", 1, true)
                            or lowered:find("animation", 1, true)
                            or lowered == "id"
                            or lowered == "name" then
                            values[#values + 1] = attributeValue
                        end
                    end
                    local contexts = {
                        character,
                        LocalPlayer,
                    }
        
                    local getConnections = getExecutorGlobal("getconnections")
                    local getUpvalues    = getExecutorGlobal("getupvalues")
        
                    local function collectSuccessfulReturns(results)
                        if type(results) ~= "table" or not results[1] then return nil end
                        local payloads = {}
                        for index = 2, results.n or #results do
                            if results[index] ~= nil then
                                payloads[#payloads + 1] = results[index]
                            end
                        end
                        if #payloads == 1 then return payloads[1] end
                        if #payloads > 1 then return payloads end
                        return nil
                    end
        
                    
                    
                    
                    local function callBindableViaConnections(bf, ...)
                        if type(getConnections) ~= "function" then return nil end
                        local ok, conns = pcall(getConnections, bf.OnInvoke)
                        if not ok or type(conns) ~= "table" then return nil end
                        for _, conn in ipairs(conns) do
                            local callback
                            pcall(function() callback = conn.Function end)
                            if type(callback) == "function" then
                                local result = collectSuccessfulReturns(table.pack(pcall(callback, ...)))
                                if result ~= nil then return result end
                            end
                        end
                        return nil
                    end
        
                    for _, root in ipairs(getEmoteVFXRoots()) do
        
                        
                        local getInstance = root:FindFirstChild("GetInstance", true)
                        if getInstance and getInstance:IsA("BindableFunction") then
                            for _, value in ipairs(values) do
                                local argumentSets = {{value}}
                                for _, context in ipairs(contexts) do
                                    if context then
                                        argumentSets[#argumentSets + 1] = {value, context}
                                        argumentSets[#argumentSets + 1] = {context, value}
                                    end
                                end
                                for _, args in ipairs(argumentSets) do
                                    local payload = collectSuccessfulReturns(table.pack(pcall(function()
                                        return getInstance:Invoke(unpack(args))
                                    end)))
                                    if payload ~= nil then return payload end
                                    
                                    local directResult = callBindableViaConnections(getInstance, unpack(args))
                                    if directResult ~= nil then return directResult end
                                end
                            end
                        end
        
                        
                        local getter = root:FindFirstChild("GetEmoteVFX", true)
                        if getter and getter:IsA("BindableFunction") then
                            for _, value in ipairs(values) do
                                local argumentSets = {{value}}
                                for _, context in ipairs(contexts) do
                                    if context then
                                        argumentSets[#argumentSets + 1] = {value, context}
                                        argumentSets[#argumentSets + 1] = {context, value}
                                    end
                                end
                                for _, args in ipairs(argumentSets) do
                                    
                                    local payload = collectSuccessfulReturns(table.pack(pcall(function()
                                        return getter:Invoke(unpack(args))
                                    end)))
                                    if payload ~= nil then return payload end
                                    
                                    local directResult = callBindableViaConnections(getter, unpack(args))
                                    if directResult ~= nil then return directResult end
                                end
                            end
                        end
        
                        
                        local emoteVFXScript = root:IsA("ModuleScript") and root
                            or root:FindFirstChild("EmoteVFX", true)
                        if emoteVFXScript then
                            if emoteVFXScript:IsA("ModuleScript") then
                                local ok, module = pcall(require, emoteVFXScript)
                                if ok then
                                    if type(module) == "function" then
                                        for _, value in ipairs(values) do
                                            local argumentSets = {{value}}
                                            for _, context in ipairs(contexts) do
                                                if context then
                                                    argumentSets[#argumentSets + 1] = {value, context}
                                                    argumentSets[#argumentSets + 1] = {context, value}
                                                end
                                            end
                                            for _, args in ipairs(argumentSets) do
                                                local payload = collectSuccessfulReturns(table.pack(pcall(module, unpack(args))))
                                                if payload ~= nil then return payload end
                                            end
                                        end
                                    elseif type(module) == "table" then
                                        
                                        if type(getUpvalues) == "function" then
                                            for _, maybeFunction in pairs(module) do
                                                if type(maybeFunction) == "function" then
                                                    local okUvs, uvs = pcall(getUpvalues, maybeFunction)
                                                    if okUvs and type(uvs) == "table" then
                                                        for _, uv in ipairs(uvs) do
                                                            if type(uv) == "table" and type(uv.VFX) == "table" then
                                                                for _, value in ipairs(values) do
                                                                    local direct = uv.VFX[value] or uv.VFX[normalize(tostring(value))]
                                                                    if direct ~= nil then return direct end
                                                                end
                                                            end
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                        for _, value in ipairs(values) do
                                            local direct = module[value]
                                            if direct ~= nil then return direct end
                                            direct = module[normalize(tostring(value))]
                                            if direct ~= nil then return direct end
                                        end
                                        for _, methodName in ipairs({
                                            "GetEmoteVFX", "GetVFX", "Get", "Find", "Resolve",
                                        }) do
                                            local method = module[methodName]
                                            if type(method) == "function" then
                                                for _, value in ipairs(values) do
                                                    local argumentSets = {
                                                        {module, value},
                                                        {value},
                                                    }
                                                    for _, context in ipairs(contexts) do
                                                        if context then
                                                            argumentSets[#argumentSets + 1] = {module, value, context}
                                                            argumentSets[#argumentSets + 1] = {module, context, value}
                                                            argumentSets[#argumentSets + 1] = {value, context}
                                                            argumentSets[#argumentSets + 1] = {context, value}
                                                        end
                                                    end
                                                    for _, args in ipairs(argumentSets) do
                                                        local payload = collectSuccessfulReturns(table.pack(pcall(method, unpack(args))))
                                                        if payload ~= nil then return payload end
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            elseif emoteVFXScript:IsA("Script") or emoteVFXScript:IsA("LocalScript") then
                                
                                for _, bf in ipairs(root:GetDescendants()) do
                                    if bf:IsA("BindableFunction") then
                                        for _, value in ipairs(values) do
                                            local directResult = callBindableViaConnections(bf, value)
                                            if directResult ~= nil then return directResult end
                                            for _, context in ipairs(contexts) do
                                                if context then
                                                    directResult = callBindableViaConnections(bf, value, context)
                                                    if directResult ~= nil then return directResult end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
        
                        
                        for _, ms in ipairs(root:GetDescendants()) do
                            if ms:IsA("ModuleScript") and ms ~= emoteVFXScript then
                                local ok, module = pcall(require, ms)
                                if ok and type(module) == "table" then
                                    for _, value in ipairs(values) do
                                        local direct = module[value]
                                        if direct ~= nil then return direct end
                                    end
                                end
                            end
                        end
                    end
                    return nil
                end
        
                state.collectPayloadAliases = state.collectPayloadAliases or function(value, aliases, seen)
                    if type(value) == "string" then
                        local key = normalize(value)
                        if key ~= "" then aliases[key] = true end
                        return
                    end
                    if type(value) ~= "table" then return end
                    seen = seen or {}
                    if seen[value] then return end
                    seen[value] = true
                    for key, fieldValue in pairs(value) do
                        state.collectPayloadAliases(key, aliases, seen)
                        state.collectPayloadAliases(fieldValue, aliases, seen)
                    end
                end
        
                state.findNamedVFX = state.findNamedVFX or function(entry, payload)
                    state.namedVFXCache = state.namedVFXCache or {}
                    local cacheKey = tostring(entry and (entry.Animation and entry.Animation.AnimationId or entry.Id or entry.Name) or "")
                        .. ":"
                        .. tostring(payload)
                    if state.namedVFXCache[cacheKey] then
                        return state.namedVFXCache[cacheKey]
                    end
        
                    local aliases = {
                        [normalize(entry.Name)] = true,
                        [normalize(entry.Id)] = true,
                    }
                    for attributeName, attributeValue in pairs(entry.Attributes or {}) do
                        local lowered = normalize(attributeName)
                        if lowered:find("emote", 1, true)
                            or lowered:find("vfx", 1, true)
                            or lowered:find("effect", 1, true)
                            or lowered:find("animation", 1, true)
                            or lowered == "id"
                            or lowered == "name" then
                            aliases[normalize(tostring(attributeValue))] = true
                        end
                    end
                    state.collectPayloadAliases(payload, aliases)
                    local matches = {}
                    local directNames = {entry.Id, entry.Name}
                    for attributeName, attributeValue in pairs(entry.Attributes or {}) do
                        local lowered = normalize(attributeName)
                        if lowered:find('emote', 1, true)
                            or lowered:find('vfx', 1, true)
                            or lowered:find('effect', 1, true)
                            or lowered == 'id'
                            or lowered == 'name' then
                            directNames[#directNames + 1] = attributeValue
                        end
                    end
        
                    local directSeen = {}
                    for _, root in ipairs(getEmoteVFXRoots()) do
                        for _, directName in ipairs(directNames) do
                            if directName ~= nil and tostring(directName) ~= '' then
                                local direct = root:FindFirstChild(tostring(directName), true)
                                if direct
                                    and not directSeen[direct]
                                    and not direct:IsA('Animation')
                                    and not direct:IsA('ModuleScript')
                                    and not direct:IsA('Script')
                                    and not direct:IsA('LocalScript') then
                                    directSeen[direct] = true
                                    matches[#matches + 1] = direct
                                end
                            end
                        end
                    end
                    if #matches > 0 then
                        state.namedVFXCache[cacheKey] = matches
                        return matches
                    end
        
                    for _, root in ipairs(getEmoteVFXRoots()) do
                        for _, object in ipairs(root:GetDescendants()) do
                            if not object:IsA("Animation")
                                and not object:IsA("ModuleScript")
                                and not object:IsA("Script")
                                and not object:IsA("LocalScript") then
                                
                                if aliases[normalize(object.Name)] then
                                    matches[#matches + 1] = object
                                    continue
                                end
                                
                                local ok, attrs = pcall(function() return object:GetAttributes() end)
                                if ok and attrs then
                                    for attrKey, attrVal in pairs(attrs) do
                                        local lk = normalize(attrKey)
                                        if lk:find("emote", 1, true) or lk:find("id", 1, true) or lk:find("name", 1, true) then
                                            if aliases[normalize(tostring(attrVal))] then
                                                matches[#matches + 1] = object
                                                break
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                    if #matches > 0 then
                        state.namedVFXCache[cacheKey] = matches
                    end
                    return matches
                end
        
                state.runVFXModule = state.runVFXModule or function(entry, payload)
                    local character = LocalPlayer.Character
                    if not character then return false end
        
                    for _, root in ipairs(getEmoteVFXRoots()) do
                        local moduleScript = root:IsA("ModuleScript") and root
                            or root:FindFirstChild("EmoteVFX", true)
                        if moduleScript and moduleScript:IsA("ModuleScript") then
                            local loaded, module = pcall(require, moduleScript)
                            if loaded and type(module) == "table" then
                                for _, methodName in ipairs({
                                    "Play",
                                    "Create",
                                    "Spawn",
                                    "Start",
                                    "Apply",
                                    "Emit",
                                    "PlayEmoteVFX",
                                    "CreateEmoteVFX",
                                }) do
                                    local method = module[methodName]
                                    if type(method) == "function" then
                                        local argumentSets = {}
                                        if payload then
                                            argumentSets[#argumentSets + 1] = {module, character, payload}
                                            argumentSets[#argumentSets + 1] = {module, payload, character}
                                            argumentSets[#argumentSets + 1] = {character, payload}
                                            argumentSets[#argumentSets + 1] = {payload, character}
                                        end
                                        argumentSets[#argumentSets + 1] = {module, character, entry.Id}
                                        argumentSets[#argumentSets + 1] = {module, entry.Id, character}
                                        argumentSets[#argumentSets + 1] = {module, character, entry.Name}
                                        argumentSets[#argumentSets + 1] = {module, entry.Name, character}
                                        argumentSets[#argumentSets + 1] = {character, entry.Id}
                                        argumentSets[#argumentSets + 1] = {entry.Id, character}
        
                                        for _, args in ipairs(argumentSets) do
                                            local ok, result = pcall(method, unpack(args))
                                            if ok then return true end
                                        end
                                    end
                                end
                            end
                        end
                    end
                    return false
                end
        
                state.materializeVFXPayload = state.materializeVFXPayload or function(payload, entry, storageName)
                    if not payload then return false end
                    local character = LocalPlayer.Character
                    if not character then return false end
        
                    local ok, clone = pcall(function() return payload:Clone() end)
                    if not ok or not clone then return false end
        
                    clone:SetAttribute("AzureEmoteVFX", true)
        
                    local function remapRigPartName(name)
                        if name == "Torso" and character:FindFirstChild("UpperTorso") then
                            return "UpperTorso", true
                        elseif name == "Left Arm" and character:FindFirstChild("LeftUpperArm") then
                            return "LeftUpperArm", true
                        elseif name == "Right Arm" and character:FindFirstChild("RightUpperArm") then
                            return "RightUpperArm", true
                        elseif name == "Left Leg" and character:FindFirstChild("LeftUpperLeg") then
                            return "LeftUpperLeg", true
                        elseif name == "Right Leg" and character:FindFirstChild("RightUpperLeg") then
                            return "RightUpperLeg", true
                        end
        
                        local direct = character:FindFirstChild(name)
                        return name, direct and direct:IsA("BasePart")
                    end
        
                    local function hideRigAnchor(part)
                        part.Transparency = 1
                        part.LocalTransparencyModifier = 1
                        part.CanCollide = false
                        part.CanTouch = false
                        part.CanQuery = false
                        part.Massless = true
                        part.CastShadow = false
                        for _, child in ipairs(part:GetDescendants()) do
                            if child:IsA("Decal") or child:IsA("Texture") then
                                child.Transparency = 1
                            elseif child:IsA("SpecialMesh") then
                                child.VertexColor = Vector3.new(0, 0, 0)
                            end
                        end
                    end
        
                    local function attachToCharacter(vfxRoot)
                        
                        for _, joint in ipairs(vfxRoot:GetDescendants()) do
                            if joint:IsA("Weld") or joint:IsA("Motor6D") or joint:IsA("WeldConstraint") then
                                local p = joint.Parent
                                if p and p:IsA("BasePart") then
                                    local target = remapRigPartName(p.Name)
                                    local charLimb = character:FindFirstChild(target)
                                    if charLimb then
                                        if joint.Part0 == nil or joint.Part0 == p then joint.Part0 = charLimb end
                                        if joint.Part1 == p then joint.Part1 = charLimb end
                                    end
                                end
                            end
                        end
        
                        
                        for _, descendant in ipairs(vfxRoot:GetDescendants()) do
                            
                            if descendant:FindFirstAncestorWhichIsA("Accessory") or descendant:IsA("Accessory") then
                                continue
                            end
        
                            if descendant:IsA("BasePart") then
                                descendant.CanCollide = false
                                descendant.CanTouch = false
                                descendant.CanQuery = false
                                descendant.Massless = true
                                descendant.CastShadow = false
        
                                local limbName, isRigPart = remapRigPartName(descendant.Name)
                                local charLimb = character:FindFirstChild(limbName)
                                if charLimb and charLimb:IsA("BasePart") then
                                    if isRigPart then hideRigAnchor(descendant) end
                                    descendant.CFrame = charLimb.CFrame
                                    local weld = Instance.new("WeldConstraint")
                                    weld.Part0 = charLimb
                                    weld.Part1 = descendant
                                    weld.Parent = descendant
                                else
                                    local hrp = character:FindFirstChild("HumanoidRootPart")
                                    if hrp then
                                        local hasJoint = false
                                        for _, j in ipairs(vfxRoot:GetDescendants()) do
                                            if (j:IsA("Weld") or j:IsA("Motor6D") or j:IsA("WeldConstraint")) and (j.Part0 == descendant or j.Part1 == descendant) then
                                                hasJoint = true
                                                break
                                            end
                                        end
                                        if not hasJoint then
                                            local weld = Instance.new("WeldConstraint")
                                            weld.Part0 = hrp
                                            weld.Part1 = descendant
                                            weld.Parent = descendant
                                        end
                                    end
                                end
        
                                descendant.Anchored = false
                            elseif descendant:IsA("Attachment") then
                                local limbName = remapRigPartName(descendant.Name)
                                local charLimb = character:FindFirstChild(limbName)
                                if charLimb and charLimb:IsA("BasePart") and not descendant.Parent:IsA("BasePart") then
                                    descendant.Parent = charLimb
                                end
                            end
                        end
                    end
        
                    attachToCharacter(clone)
        
                    local humanoid = character:FindFirstChildOfClass("Humanoid")
        
                    
                    for _, desc in ipairs(clone:GetDescendants()) do
                        if desc:IsA("Script") or desc:IsA("LocalScript") then
                            pcall(function() desc:Destroy() end)
                        end
                        if desc:IsA("BasePart") then
                            desc.CanCollide = false
                            desc.CanTouch = false
                            desc.CanQuery = false
                            desc.Massless = true
                            desc.CastShadow = false
                        end
                    end
        
                    local function manualWeldAccessory(acc)
                        local handle = acc:FindFirstChild("Handle")
                        if not handle then return end
        
                        local targetAttachmentName = nil
                        local handleAttachment = nil
                        for _, child in ipairs(handle:GetChildren()) do
                            if child:IsA("Attachment") then
                                targetAttachmentName = child.Name
                                handleAttachment = child
                                break
                            end
                        end
        
                        if targetAttachmentName then
                            
                            local charAttachment = nil
                            for _, desc in ipairs(character:GetDescendants()) do
                                if desc:IsA("Attachment") and desc.Name == targetAttachmentName and desc.Parent:IsA("BasePart") then
                                    charAttachment = desc
                                    break
                                end
                            end
        
                            if charAttachment then
                                handle.CFrame = charAttachment.Parent.CFrame * charAttachment.CFrame * handleAttachment.CFrame:Inverse()
                                local weld = Instance.new("WeldConstraint")
                                weld.Part0 = charAttachment.Parent
                                weld.Part1 = handle
                                weld.Parent = handle
                                handle.Anchored = false
                            end
                        end
                    end
        
                    if clone:IsA("Accessory") then
                        manualWeldAccessory(clone)
                    else
                        for _, child in ipairs(clone:GetChildren()) do
                            if child:IsA("Accessory") then
                                manualWeldAccessory(child)
                            end
                        end
                    end
        
                    
                    
                    storageName = storageName == "Emote_Storage" and "Emote_Storage" or "EmoteVFX_Storage"
                    local localFolder = character:FindFirstChild(storageName)
                    if not localFolder or not localFolder:IsA("Folder") then
                        localFolder = Instance.new("Folder")
                        localFolder.Name = storageName
                        localFolder.Parent = character
                    end
                    clone.Parent = localFolder
        
                    
                    clone.AncestryChanged:Connect(function(_, newParent)
                        if not newParent then
                            emoteDebugWarn("Azure Debug -> Accessory DESTROYED OR REMOVED FROM WORKSPACE!")
                        end
                    end)
        
                    state.activeVFX[#state.activeVFX + 1] = clone
                    activateVFX(clone, entry)
                    return true
                end
        
                state.startDirectVFX = state.startDirectVFX or function(entry)
                    if not getgenv().emoteVFXEnabled then return false end
                    local payload = nil
                    state.vfxPayloadCache = state.vfxPayloadCache or {}
                    local payloadCacheKey = tostring(entry and (entry.Animation and entry.Animation.AnimationId or entry.Id or entry.Name) or "")
                    if state.vfxPayloadCache[payloadCacheKey] ~= nil
                        and state.vfxPayloadCache[payloadCacheKey] ~= false then
                        local cached = state.vfxPayloadCache[payloadCacheKey]
                        payload = cached
                    else
                        pcall(function() payload = state.invokeGetEmoteVFX(entry) end)
                        state.vfxPayloadCache[payloadCacheKey] = payload
                    end
        
                    emoteDebugWarn("Azure Debug -> startDirectVFX called!")
                    emoteDebugWarn("   entry.Name:", tostring(entry.Name))
                    emoteDebugWarn("   entry.Id:", tostring(entry.Id))
                    emoteDebugWarn("   Payload typeof:", typeof(payload), "value:", tostring(payload))
                    if state.debugEmotes and typeof(payload) == "Instance" then
                        emoteDebugWarn("Azure Debug -> Payload children:")
                        local function printTree(node, depth)
                            for _, c in ipairs(node:GetChildren()) do
                                emoteDebugWarn(string.rep("  ", depth) .. "- " .. c.Name .. " (" .. c.ClassName .. ")")
                                printTree(c, depth + 1)
                            end
                        end
                        printTree(payload, 1)
                    end
        
                    local success = false
                    local materializedSources = {}
                    local payloadInstances = {}
                    collectPayloadInstances(payload, payloadInstances, {}, {})
                    for _, candidate in ipairs(payloadInstances) do
                        local nested = false
                        for _, possibleParent in ipairs(payloadInstances) do
                            if candidate ~= possibleParent and candidate:IsDescendantOf(possibleParent) then
                                nested = true
                                break
                            end
                        end
                        if not nested and not materializedSources[candidate]
                            and state.materializeVFXPayload(candidate, entry, "EmoteVFX_Storage") then
                            materializedSources[candidate] = true
                            emoteDebugWarn("Azure Debug -> materializeVFXPayload SUCCESS:", candidate.Name)
                            success = true
                        end
                    end
        
                    local accPayload = state.getEmoteAccessoryPayload(entry)
                    if accPayload then
                        emoteDebugWarn("Azure Debug -> getEmoteAccessoryPayload FOUND:", tostring(accPayload))
                        local accessoryInstances = {}
                        collectPayloadInstances(accPayload, accessoryInstances, {}, {})
                        for _, candidate in ipairs(accessoryInstances) do
                            local nested = false
                            for _, possibleParent in ipairs(accessoryInstances) do
                                if candidate ~= possibleParent and candidate:IsDescendantOf(possibleParent) then
                                    nested = true
                                    break
                                end
                            end
                            if not nested and not materializedSources[candidate]
                                and state.materializeVFXPayload(candidate, entry, "Emote_Storage") then
                                materializedSources[candidate] = true
                                success = true
                            end
                        end
                    end
        
                    local namedPayloads = state.findNamedVFX(entry, payload)
        
                    
                    if state.debugEmotes then pcall(function()
                        if not _G.DumpedEmoteAcc then
                            _G.DumpedEmoteAcc = true
                            local found = false
                            for _, obj in ipairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
                                if obj.Name == "EmoteAccessory" or obj.Name == "EmoteAccessories" then
                                    emoteDebugWarn("Azure Debug -> FOUND EmoteAccessory AT:", obj:GetFullName())
                                    found = true
                                    local count = 0
                                    for _, acc in ipairs(obj:GetChildren()) do
                                        if count < 15 then
                                            emoteDebugWarn("   ", acc.Name, acc.ClassName)
                                            count = count + 1
                                        end
                                    end
                                    break
                                end
                            end
                            if not found then
                                emoteDebugWarn("Azure Debug -> EmoteAccessory NOT FOUND IN ReplicatedStorage!")
                            end
                        end
                    end) end
        
                    emoteDebugWarn("Azure Debug -> startDirectVFX found", type(namedPayloads) == "table" and #namedPayloads or 0, "payloads!")
                    if state.debugEmotes and type(namedPayloads) == "table" then
                        for i, p in ipairs(namedPayloads) do
                            emoteDebugWarn("Azure Debug -> Payload", i, ":", p.Name, p.ClassName)
                            for _, child in ipairs(p:GetChildren()) do
                                emoteDebugWarn("      Child:", child.Name, child.ClassName)
                            end
                        end
                    end
        
                    if type(namedPayloads) == "table" then
                        for _, p in ipairs(namedPayloads) do
                            local payloadName = tostring(p.Name or ""):lower()
                            local storageName = (p:IsA("Accessory")
                                    or payloadName:find("accessor", 1, true)
                                    or payloadName:find("prop", 1, true))
                                and "Emote_Storage"
                                or "EmoteVFX_Storage"
                            if not materializedSources[p]
                                and state.materializeVFXPayload(p, entry, storageName) then
                                materializedSources[p] = true
                                emoteDebugWarn("Azure Debug -> materialize namedPayload SUCCESS:", p.Name)
                                success = true
                            end
                        end
                    end
                    if success then return true end
        
                    local runVFX = state.runVFXModule(entry, payload)
                    emoteDebugWarn("Azure Debug -> runVFXModule result:", runVFX)
                    if runVFX then return true end
        
                    emoteDebugWarn("Azure Debug -> EVERYTHING FAILED")
                    return false
                end
                state.clearVFXStorage = state.clearVFXStorage or function()
                    local objects = {}
                    for _, object in ipairs(state.activeVFX) do
                        objects[#objects + 1] = object
                    end
                    table.clear(state.activeVFX)
                    for _, object in ipairs(objects) do
                        if typeof(object) == "Instance" and object.Parent then
                            fadeOutEmoteVFX(object)
                        end
                    end
                end
        
                state.stopEmote = state.stopEmote or function()
                    state.playToken = state.playToken + 1
        
                    
                    local prevRunningConn = state.runningConnection
                    state.runningConnection = nil
                    local prevActiveTrack = state.activeTrack
                    state.activeTrack = nil
                    local prevMarkerConns = {}
                    for i, c in ipairs(state.markerConnections) do prevMarkerConns[i] = c end
                    table.clear(state.markerConnections)
                    local prevSounds = {}
                    for i, s in ipairs(state.activeSounds) do prevSounds[i] = s end
                    table.clear(state.activeSounds)
                    table.clear(state.firedMediaCues)
                    table.clear(state.playedSoundKeys)
                    local prevSelected = state.activeSelected
                    local prevOriginal = state.activeOriginal
                    state.activeOriginal = nil
                    state.activeSelected = nil
                    state.capturedVFXPayload = nil
                    state.overrideUntil = 0
                    state.boundCueTrack = nil
                    state.boundCueToken = 0
        
                    
                    task.defer(function()
                        if prevRunningConn then
                            pcall(function() prevRunningConn:Disconnect() end)
                        end
        
                        for _, connection in ipairs(prevMarkerConns) do
                            pcall(function() connection:Disconnect() end)
                        end
        
                        
                        if prevActiveTrack then
                            pcall(function()
                                prevActiveTrack.Looped = false
                                prevActiveTrack:AdjustWeight(0, 0)
                                prevActiveTrack:Stop(0)
                            end)
                        end
        
                        
                        pcall(function()
                            local character = LocalPlayer.Character
                            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
                            local animator = humanoid and humanoid:FindFirstChildOfClass("Animator")
                            if animator then
                                local activeIds = {}
                                if prevSelected and prevSelected.Animation then
                                    local id = assetId(prevSelected.Animation.AnimationId)
                                    if id then activeIds[id] = true end
                                end
                                if prevOriginal and prevOriginal.Animation then
                                    local id = assetId(prevOriginal.Animation.AnimationId)
                                    if id then activeIds[id] = true end
                                end
                                if prevActiveTrack and prevActiveTrack.Animation then
                                    local id = assetId(prevActiveTrack.Animation.AnimationId)
                                    if id then activeIds[id] = true end
                                end
        
                                for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
                                    local trackId = assetId(track.Animation and track.Animation.AnimationId)
                                    local trackName = normalize(track.Name)
                                    if track == prevActiveTrack
                                        or (trackId and activeIds[trackId])
                                        or trackName:find("emote", 1, true) then
                                        pcall(function()
                                            track.Looped = false
                                            track:AdjustWeight(0, 0)
                                            track:Stop(0)
                                        end)
                                    end
                                end
                            end
                        end)
        
                        
                        for _, sound in ipairs(prevSounds) do
                            pcall(function()
                                sound:Stop()
                                sound:Destroy()
                            end)
                        end
        
                        
                        state.clearVFXStorage()
                    end)
                end
        
                state.playAssociatedSounds = state.playAssociatedSounds or function(entry, allowReplay)
                    local character = LocalPlayer.Character
                    local root = character and character:FindFirstChild("HumanoidRootPart")
                    if not root then return end
        
                    local playToken = state.playToken
                    local played = false
                    local aliases = {
                        [normalize(entry.Name)] = true,
                        [normalize(entry.Id)] = true,
                        [normalize(entry.Animation.AnimationId)] = true,
                    }
                    for _, value in pairs(entry.Attributes or {}) do
                        aliases[normalize(tostring(value))] = true
                    end
        
                    local function hasEntryAlias(object)
                        local cursor = object
                        local depth = 0
                        while cursor and cursor ~= ReplicatedStorage and depth < 8 do
                            if aliases[normalize(cursor.Name)] then return true end
                            local ok, attrs = pcall(function()
                                return cursor:GetAttributes()
                            end)
                            if ok and attrs then
                                for key, value in pairs(attrs) do
                                    local lowered = normalize(key)
                                    if (lowered:find("emote", 1, true)
                                        or lowered:find("animation", 1, true)
                                        or lowered:find("id", 1, true)
                                        or lowered:find("name", 1, true))
                                        and aliases[normalize(tostring(value))] then
                                        return true
                                    end
                                end
                            end
                            cursor = cursor.Parent
                            depth = depth + 1
                        end
                        return false
                    end
        
                    local function getSoundDelay(sound)
                        local names = {
                            "AzureSoundTime",
                            "AzureSoundDelay",
                            "SoundTime",
                            "SoundDelay",
                            "SFXTime",
                            "AudioTime",
                            "MusicTime",
                            "StartTime",
                            "Delay",
                            "Time",
                            "CueTime",
                        }
                        local cursor = sound
                        local depth = 0
                        while cursor and cursor ~= ReplicatedStorage and depth < 5 do
                            local value = getInstanceAttribute(cursor, names)
                            if value ~= nil then
                                if type(value) == "string" then
                                    value = tonumber(value:gsub(",", "."))
                                else
                                    value = tonumber(value)
                                end
                                if value then return math.max(value, 0) end
                            end
                            cursor = cursor.Parent
                            depth = depth + 1
                        end
                        return 0
                    end
        
                    local seen = {}
                    local function queueSound(template, source)
                        local key = getSoundKey(template, source)
                        if seen[key] then return false end
                        seen[key] = true
        
                        local delayTime = getSoundDelay(template)
                        if delayTime > 0 then
                            task.delay(delayTime, function()
                                if state.destroyed or state.playToken ~= playToken then return end
                                playSoundTemplate(template, root, allowReplay, key)
                            end)
                            return true
                        end
                        return playSoundTemplate(template, root, allowReplay, key)
                    end
        
                    for _, object in ipairs(entry.Animation:GetDescendants()) do
                        if object:IsA("Sound") then
                            played = queueSound(object, "animation") or played
                        end
                    end
        
                    for key, value in pairs(entry.Animation:GetAttributes()) do
                        local lowered = tostring(key):lower()
                        if lowered:find("sound", 1, true)
                            or lowered:find("audio", 1, true)
                            or lowered:find("music", 1, true)
                            or lowered:find("sfx", 1, true) then
                            played = playSoundValue(value, root, allowReplay) or played
                        end
                    end
        
                    state.entrySoundCache = state.entrySoundCache or {}
                    local soundCacheKey = tostring(entry.Animation and entry.Animation.AnimationId or entry.Id or entry.Name)
                    local cachedSounds = state.entrySoundCache[soundCacheKey]
                    if not cachedSounds then
                        cachedSounds = {}
                        if os.clock() - soundIndexLastUpdate > 15 or not next(soundIndexByName) then
                            rebuildSoundIndex()
                        end
                        for _, sound in pairs(soundIndexByName) do
                            if hasEntryAlias(sound) then
                                cachedSounds[#cachedSounds + 1] = sound
                            end
                        end
                        state.entrySoundCache[soundCacheKey] = cachedSounds
                    end
                    for _, object in ipairs(cachedSounds) do
                        if typeof(object) == "Instance" and object.Parent then
                            played = queueSound(object, "replicated") or played
                        end
                    end
                    return played
                end
        
                state.getMediaCueSpec = state.getMediaCueSpec or function(entry, kind)
                    local timeNames
                    local markerNames
                    if kind == "VFX" then
                        timeNames = {
                            "AzureVFXTime",
                            "AzureVFXDelay",
                            "VFXTime",
                            "VFXDelay",
                            "EffectTime",
                            "EffectDelay",
                            "AzureCueTime",
                            "CueTime",
                        }
                        markerNames = {
                            "AzureVFXMarker",
                            "VFXMarker",
                            "EffectMarker",
                            "PlayVFXMarker",
                            "AzureCueMarker",
                            "CueMarker",
                        }
                    else
                        timeNames = {
                            "AzureSoundTime",
                            "AzureSoundDelay",
                            "SoundTime",
                            "SoundDelay",
                            "SFXTime",
                            "AudioTime",
                            "AzureCueTime",
                            "CueTime",
                        }
                        markerNames = {
                            "AzureSoundMarker",
                            "SoundMarker",
                            "SFXMarker",
                            "AudioMarker",
                            "PlaySoundMarker",
                            "AzureCueMarker",
                            "CueMarker",
                        }
                    end
        
                    local cueTime = getEntryAttribute(entry, timeNames)
                    if type(cueTime) == "string" then
                        cueTime = tonumber(cueTime:gsub(",", "."))
                    else
                        cueTime = tonumber(cueTime)
                    end
        
                    local marker = getEntryAttribute(entry, markerNames)
                    if marker ~= nil then marker = tostring(marker) end
        
                    return {
                        Time = cueTime and math.max(cueTime, 0) or nil,
                        Marker = marker and marker ~= "" and marker or nil,
                    }
                end
        
                state.getVFXObjectCueSpec = state.getVFXObjectCueSpec or function(object, entry)
                    local names = {
                        "AzureVFXTime",
                        "VFXTime",
                        "EffectTime",
                        "StartTime",
                        "CueTime",
                        "VFXDelay",
                        "EffectDelay",
                    }
                    local cleanupNames = {
                        "AzureVFXDuration",
                        "VFXDuration",
                        "EffectDuration",
                        "Duration",
                        "Lifetime",
                        "LifeTime",
                        "DestroyAfter",
                        "RemoveAfter",
                        "CleanupTime",
                    }
                    local markerNames = {
                        "AzureVFXMarker",
                        "VFXMarker",
                        "EffectMarker",
                        "CueMarker",
                    }
        
                    local rawTime = getInstanceAttribute(object, names)
                    local cleanupTime = getInstanceAttribute(object, cleanupNames)
                    local marker = getInstanceAttribute(object, markerNames)
        
                    if type(rawTime) == "string" then
                        rawTime = tonumber(rawTime:gsub(",", "."))
                    else
                        rawTime = tonumber(rawTime)
                    end
        
                    if type(cleanupTime) == "string" then
                        cleanupTime = tonumber(cleanupTime:gsub(",", "."))
                    else
                        cleanupTime = tonumber(cleanupTime)
                    end
        
                    if marker ~= nil then marker = tostring(marker) end
        
                    return {
                        Time = rawTime and math.max(rawTime, 0) or nil,
                        CleanupTime = cleanupTime and math.max(cleanupTime, 0) or nil,
                        Marker = marker and marker ~= "" and marker or nil,
                    }
                end
        
                state.resetMediaCues = state.resetMediaCues or function(playToken)
                    state.mediaCueToken = playToken
                    table.clear(state.firedMediaCues)
                    state.lastVFXCueKey = nil
                end
        
                state.mediaCueFired = state.mediaCueFired or function(playToken, key)
                    return state.mediaCueToken == playToken
                        and state.firedMediaCues
                        and key ~= nil
                        and state.firedMediaCues[key] == true
                end
        
                state.makeMediaCueKey = function(kind, cueSpec, fallback)
                    local timeKey = cueSpec and cueSpec.Time ~= nil and tostring(math.floor(cueSpec.Time * 1000 + 0.5)) or "na"
                    local markerKey = cueSpec and cueSpec.Marker or "na"
                    return table.concat({kind, timeKey, markerKey, fallback or ""}, ":")
                end
        
                state.fireMediaCue = function(kind, entry, playToken, cueKey)
                    if state.destroyed or state.playToken ~= playToken then return false end
                    if state.mediaCueToken ~= playToken then state.resetMediaCues(playToken) end
                    if cueKey and state.mediaCueFired(playToken, cueKey) then return true end
        
                    if kind == "VFX" then
                        if not getgenv().emoteVFXEnabled then return false end
                        if cueKey and state.lastVFXCueKey and state.lastVFXCueKey ~= cueKey then
                            state.clearVFXStorage()
                        end
                        local ok = state.startDirectVFX(entry)
                        if ok then
                            state.firedMediaCues[cueKey or state.makeMediaCueKey(kind, nil, "direct")] = true
                            state.lastVFXCueKey = cueKey or state.lastVFXCueKey
                            getgenv().emoteVFXStatus = "VFX active: synced cue"
                        end
                        return ok
                    end
        
                    if cueKey then
                        state.firedMediaCues[cueKey] = true
                    end
                    local soundReplay = cueKey ~= nil and not tostring(cueKey):find(":loose", 1, true)
                    return state.playAssociatedSounds(entry, soundReplay)
                end
        
                state.cueNameMatches = function(kind, cueSpec, name)
                    local key = normalize(name)
                    if key == "" then return false end
                    if cueSpec.Marker and normalize(cueSpec.Marker) == key then return true end
                    if kind == "VFX" then
                        return key:find("vfx", 1, true)
                            or key:find("effect", 1, true)
                            or key:find("particle", 1, true)
                            or key:find("trail", 1, true)
                    end
                    return key:find("sound", 1, true)
                        or key:find("sfx", 1, true)
                        or key:find("audio", 1, true)
                        or key:find("music", 1, true)
                end
        
                state.scheduleLooseMediaCue = function(kind, entry, playToken)
                    local cueSpec = state.getMediaCueSpec(entry, kind)
                    local cueKey = state.makeMediaCueKey(kind, cueSpec, "loose")
                    if cueSpec.Marker and not cueSpec.Time then return end
                    local elapsed = math.max(os.clock() - (state.mediaStartedAt or os.clock()), 0)
                    local delayTime
                    if cueSpec.Time then
                        delayTime = math.max(cueSpec.Time - elapsed, 0)
                    else
                        local deadline = os.clock() + 0.2
                        while state.playToken == playToken
                            and not state.destroyed
                            and not state.activeTrack
                            and os.clock() < deadline do
                            RunService.Heartbeat:Wait()
                        end
                        local track = state.activeTrack
                        local ratio = 0.24
                        if kind == 'VFX' then
                            delayTime = math.max(0.15 - elapsed, 0)
                        elseif track and tonumber(track.Length) and track.Length > 0 then
                            delayTime = math.max((track.Length * ratio) - elapsed, 0)
                        else
                            delayTime = 0.22
                        end
                    end
        
                    task.delay(delayTime, function()
                        state.fireMediaCue(kind, entry, playToken, cueKey)
                    end)
                end
        
                state.getAnimationMarkerSpecs = state.getAnimationMarkerSpecs or function(entry)
                    state.animationMarkerCache = state.animationMarkerCache or {}
                    local id = entry and entry.Animation and assetId(entry.Animation.AnimationId)
                    if not id then return {} end
                    if state.animationMarkerCache[id] then return state.animationMarkerCache[id] end
        
                    local specs = {}
                    local fetchDone = false
                    local sequence = nil
                    task.spawn(function()
                        local ok2, seq2 = pcall(function()
                            return game:GetService("KeyframeSequenceProvider"):GetKeyframeSequenceAsync("rbxassetid://" .. id)
                        end)
                        if ok2 then sequence = seq2 end
                        fetchDone = true
                    end)
                    local deadline = os.clock() + 1.0
                    while not fetchDone and os.clock() < deadline do
                        RunService.Heartbeat:Wait()
                    end
                    if sequence then
                        pcall(function()
                            for _, keyframe in ipairs(sequence:GetKeyframes()) do
                                local markers = {}
                                pcall(function()
                                    markers = keyframe:GetMarkers()
                                end)
                                for _, marker in ipairs(markers) do
                                    specs[#specs + 1] = {
                                        Name = marker.Name,
                                        Value = marker.Value,
                                        Time = keyframe.Time,
                                    }
                                end
                            end
                        end)
                        pcall(function() sequence:Destroy() end)
                    end
        
                    table.sort(specs, function(left, right)
                        return (left.Time or 0) < (right.Time or 0)
                    end)
                    state.animationMarkerCache[id] = specs
                    return specs
                end
        
                state.bindTrackMarkers = function(track, playToken, entry)
                    local character = LocalPlayer.Character
                    local root = character and character:FindFirstChild("HumanoidRootPart")
                    if not root then return end
        
                    if state.boundCueTrack == track and state.boundCueToken == playToken then
                        return
                    end
                    state.boundCueTrack = track
                    state.boundCueToken = playToken
        
                    local stoppedConnection = track.Stopped:Connect(function()
                        
                    end)
                    state.markerConnections[#state.markerConnections + 1] = stoppedConnection
        
        
        
                    local vfxCue = state.getMediaCueSpec(entry, "VFX")
                    local soundCue = state.getMediaCueSpec(entry, "Sound")
        
                    local function bindTimedCue(kind, cueSpec)
                        if not cueSpec.Time then return end
                        local cueKey = state.makeMediaCueKey(kind, cueSpec, "time")
                        task.spawn(function()
                            while state.playToken == playToken and not state.destroyed and track do
                                if track.TimePosition >= cueSpec.Time then break end
                                if not track.IsPlaying and track.TimePosition > 0 then return end
                                RunService.Heartbeat:Wait()
                            end
                            if state.playToken == playToken and not state.destroyed then
                                state.fireMediaCue(kind, entry, playToken, cueKey)
                            end
                        end)
                    end
        
                    bindTimedCue("VFX", vfxCue)
                    bindTimedCue("Sound", soundCue)
        
                    local keyframeConnection = track.KeyframeReached:Connect(function(keyframeName)
                        if state.playToken ~= playToken then return end
                        if state.cueNameMatches("VFX", vfxCue, keyframeName) then
                            state.fireMediaCue("VFX", entry, playToken, state.makeMediaCueKey("VFX", vfxCue, keyframeName))
                        end
                        if state.cueNameMatches("Sound", soundCue, keyframeName) then
                            state.fireMediaCue("Sound", entry, playToken, state.makeMediaCueKey("Sound", soundCue, keyframeName))
                        end
                    end)
                    state.markerConnections[#state.markerConnections + 1] = keyframeConnection
        
                    for _, markerName in ipairs({
                        "Sound",
                        "SFX",
                        "Audio",
                        "Music",
                        "PlaySound",
                        "VFX",
                        "Effect",
                        "PlayVFX",
                    }) do
                        local connection = track:GetMarkerReachedSignal(markerName):Connect(function(value)
                            if state.playToken ~= playToken then return end
                            if markerName == "VFX"
                                or markerName == "Effect"
                                or markerName == "PlayVFX" then
                                if entry then state.fireMediaCue("VFX", entry, playToken, state.makeMediaCueKey("VFX", vfxCue, markerName)) end
                            else
                                if value ~= nil and tostring(value) ~= "" then
                                    playSoundValue(value, root, true)
                                    if state.mediaCueToken ~= playToken then state.resetMediaCues(playToken) end
                                    state.firedMediaCues[state.makeMediaCueKey("Sound", soundCue, markerName .. ":" .. tostring(value))] = true
                                else
                                    state.fireMediaCue("Sound", entry, playToken, state.makeMediaCueKey("Sound", soundCue, markerName))
                                end
                            end
                        end)
                        state.markerConnections[#state.markerConnections + 1] = connection
                    end
        
                    for _, markerSpec in ipairs(state.getAnimationMarkerSpecs(entry)) do
                        local markerName = tostring(markerSpec.Name or "")
                        if markerName ~= "" then
                            local cueKey = state.makeMediaCueKey("Sound", soundCue, "anim:" .. markerName .. ":" .. tostring(markerSpec.Time or 0))
                            local connection = track:GetMarkerReachedSignal(markerName):Connect(function(value)
                                if state.playToken ~= playToken then return end
                                local payload = value
                                if payload == nil or tostring(payload) == "" then
                                    payload = markerSpec.Value
                                end
                                local played = false
                                if payload ~= nil and tostring(payload) ~= "" then
                                    played = playSoundValue(payload, root, true)
                                end
                                if not played then
                                    played = playSoundValue(markerName, root, true)
                                end
                                if played then
                                    if state.mediaCueToken ~= playToken then state.resetMediaCues(playToken) end
                                    state.firedMediaCues[cueKey] = true
                                elseif state.cueNameMatches("Sound", soundCue, markerName) then
                                    state.fireMediaCue("Sound", entry, playToken, cueKey)
                                end
                            end)
                            state.markerConnections[#state.markerConnections + 1] = connection
        
                            if markerSpec.Time and markerSpec.Time > 0 then
                                task.spawn(function()
                                    while state.playToken == playToken and not state.destroyed and track do
                                        if track.TimePosition >= markerSpec.Time then break end
                                        if not track.IsPlaying and track.TimePosition > 0 then return end
                                        RunService.Heartbeat:Wait()
                                    end
                                    if state.playToken ~= playToken
                                        or state.destroyed
                                        or state.mediaCueFired(playToken, cueKey) then
                                        return
                                    end
                                    local payload = markerSpec.Value
                                    local played = false
                                    if payload ~= nil and tostring(payload) ~= "" then
                                        played = playSoundValue(payload, root, true)
                                    end
                                    if not played then
                                        played = playSoundValue(markerName, root, true)
                                    end
                                    if played then
                                        if state.mediaCueToken ~= playToken then state.resetMediaCues(playToken) end
                                        state.firedMediaCues[cueKey] = true
                                    elseif state.cueNameMatches("Sound", soundCue, markerName) then
                                        state.fireMediaCue("Sound", entry, playToken, cueKey)
                                    end
                                end)
                            end
                        end
                    end
        
                    if vfxCue.Marker then
                        local connection = track:GetMarkerReachedSignal(vfxCue.Marker):Connect(function()
                            state.fireMediaCue("VFX", entry, playToken, state.makeMediaCueKey("VFX", vfxCue, "explicit"))
                        end)
                        state.markerConnections[#state.markerConnections + 1] = connection
                    end
                    if soundCue.Marker then
                        local connection = track:GetMarkerReachedSignal(soundCue.Marker):Connect(function(value)
                            if value ~= nil and tostring(value) ~= "" then
                                playSoundValue(value, root, true)
                                if state.mediaCueToken ~= playToken then state.resetMediaCues(playToken) end
                                state.firedMediaCues[state.makeMediaCueKey("Sound", soundCue, "explicit:" .. tostring(value))] = true
                            else
                                state.fireMediaCue("Sound", entry, playToken, state.makeMediaCueKey("Sound", soundCue, "explicit"))
                            end
                        end)
                        state.markerConnections[#state.markerConnections + 1] = connection
                    end
                end
        
                state.startSmoothEmoteLoop = state.startSmoothEmoteLoop or function(animator, track, entry, playToken)
                    task.spawn(function()
                        local currentTrack = track
                        while state.playToken == playToken and not state.destroyed and currentTrack and currentTrack.Length <= 0 do
                            task.wait(0.1)
                        end
                        if state.playToken ~= playToken
                            or state.destroyed
                            or not currentTrack
                            or currentTrack.Length <= 0 then
                            return
                        end
        
                        local loopStart = math.max(currentTrack.Length - 2.5, currentTrack.Length * 0.5)
                        local blendTime = math.clamp(currentTrack.Length * 0.16, 0.32, 0.6)
                        local transitionLead = math.clamp(currentTrack.Length * 0.22, blendTime + 0.08, 0.85)
        
                        while state.playToken == playToken and not state.destroyed and currentTrack and currentTrack.IsPlaying do
                            if currentTrack.Length <= 0 then
                                task.wait(0.1)
                            elseif not getgenv().emoteLooped and currentTrack.TimePosition >= currentTrack.Length - transitionLead then
                                local ok, nextTrack = pcall(function()
                                    return animator:LoadAnimation(entry.Animation)
                                end)
        
                                if ok and nextTrack then
                                    nextTrack.Priority = currentTrack.Priority
                                    nextTrack.Looped = true
                                    nextTrack:Play(0, 0.001, 1)
                                    nextTrack.TimePosition = loopStart
                                    nextTrack:AdjustWeight(1, blendTime)
        
                                    local oldTrack = currentTrack
                                    state.activeTrack = nextTrack
                                    currentTrack = nextTrack
        
                                    pcall(function()
                                        oldTrack.Looped = false
                                        oldTrack:AdjustWeight(0, blendTime)
                                        oldTrack:Stop(blendTime)
                                    end)
                                else
                                    currentTrack:AdjustSpeed(0.35)
                                    task.wait(0.08)
                                    currentTrack.TimePosition = loopStart
                                    currentTrack:AdjustSpeed(1)
                                end
        
                                task.wait(blendTime)
                            else
                                RunService.Heartbeat:Wait()
                            end
                        end
                    end)
                end
                state.captureTrack = function(entry, playToken)
                    task.spawn(function()
                        local deadline = os.clock() + 1.5
                        while not state.destroyed and state.playToken == playToken and os.clock() <= deadline do
                            local character = LocalPlayer.Character
                            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
                            local animator = humanoid and humanoid:FindFirstChildOfClass("Animator")
                            if animator then
                                local wantedId = assetId(entry.Animation.AnimationId)
                                for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
                                    local trackId = assetId(track.Animation and track.Animation.AnimationId)
                                    if wantedId and trackId == wantedId then
                                        state.activeTrack = track
                                        track.Looped = true
                                        state.bindTrackMarkers(track, playToken, entry)
                                        state.startSmoothEmoteLoop(animator, track, entry, playToken)
        
                                        return
                                    end
                                end
                            end
                            RunService.Heartbeat:Wait()
                        end
                    end)
                end
        
                state.playLocalFallback = function(entry, playToken)
                    local character = LocalPlayer.Character
                    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
                    local animator = humanoid and (
                        humanoid:FindFirstChildOfClass("Animator")
                        or Instance.new("Animator", humanoid)
                    )
                    if not animator then return false end
        
                    local wantedId = assetId(entry.Animation and entry.Animation.AnimationId)
                    local originalId = state.activeOriginal and state.activeOriginal.Animation and assetId(state.activeOriginal.Animation.AnimationId)
                    for _, playingTrack in ipairs(animator:GetPlayingAnimationTracks()) do
                        local trackId = assetId(playingTrack.Animation and playingTrack.Animation.AnimationId)
                        local trackName = normalize(playingTrack.Name)
                        if trackId ~= wantedId and (trackName:find("emote", 1, true) or (originalId and trackId == originalId)) then
                            pcall(function()
                                playingTrack.Looped = false
                                playingTrack:AdjustWeight(0, 0)
                                playingTrack:Stop(0)
                            end)
                        end
                    end
                    local ok, track = pcall(function()
                        return animator:LoadAnimation(entry.Animation)
                    end)
                    if not ok or not track then return false end
        
                    state.activeTrack = track
                    track.Priority = Enum.AnimationPriority.Action4
                    track.Looped = true
                    track:Play(0.15)
                    state.bindTrackMarkers(track, playToken, entry)
                    state.startSmoothEmoteLoop(animator, track, entry, playToken)
        
        
                    return true
                end
        
                state.fireNative = function(dispatcher)
                    
                    for _, callback in ipairs(dispatcher.Callbacks) do
                        if pcall(callback) then return true end
                    end
                    
                    for _, connection in ipairs(dispatcher.Connections) do
                        local ok = pcall(function()
                            if type(connection.Fire) == "function" then
                                connection:Fire()
                            end
                        end)
                        if ok then return true end
                    end
                    
                    local fireSignal = getExecutorGlobal("firesignal")
                    if type(fireSignal) == "function" and pcall(fireSignal, dispatcher.Signal) then
                        return true
                    end
                    return false
                end
                state.playEmote = function(name)
                    state.stopEmote()
                    if #state.catalog == 0 then refreshCatalog() end
        
                    local entry = resolveEntry(name)
                    if not entry then return false, "Emote not found" end
                    local character = LocalPlayer.Character
                    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
                    if not humanoid or humanoid.Health <= 0 then
                        return false, "Character is not ready"
                    end
        
                    state.playToken = state.playToken + 1
                    local playToken = state.playToken
                    state.activeSelected = entry
                    state.capturedVFXPayload = nil
                    state.mediaStartedAt = os.clock()
                    state.resetMediaCues(playToken)
        
                    
                    if state.runningConnection then pcall(function() state.runningConnection:Disconnect() end) end
                    state.runningConnection = humanoid.Running:Connect(function(speed)
                        if speed > 0.1 then
                            state.stopEmote()
                        end
                    end)
        
                    
                    task.defer(function()
                        if state.destroyed or state.playToken ~= playToken then return end
        
                        
                        pcall(initializeEmoteObservers)
        
                        
                        local hooksReady = hooks.animator
                            or hooks.humanoid
                            or hooks.clone
                            or hooks.bindableFunction
                            or hooks.bindableEvent
                            or hooks.remoteEvent
                            or hooks.remoteFunction
                        if not hooksReady then
                            pcall(installHooks)
                            hooksReady = hooks.animator
                                or hooks.humanoid
                                or hooks.clone
                                or hooks.bindableFunction
                                or hooks.bindableEvent
                                or hooks.remoteEvent
                                or hooks.remoteFunction
                        end
                        local nativeAnimationHooksReady = hooks.animator or hooks.humanoid
        
                        if state.destroyed or state.playToken ~= playToken then return end
        
                        
                        local dispatcher = state.nativeDispatcher
                        if dispatcher then
                            local valid = false
                            pcall(function()
                                valid = dispatcher.WheelContent and dispatcher.WheelContent.Parent ~= nil
                            end)
                            if not (valid and type(dispatcher.Callbacks) == "table" and #dispatcher.Callbacks > 0 and sameEntry(dispatcher.Original, entry)) then
                                dispatcher = nil
                            end
                        end
        
                        
                        if not dispatcher then
                            dispatcher = findNativeDispatcher(entry)
                        end
        
                        if state.destroyed or state.playToken ~= playToken then return end
        
                        local nativeStarted = false
                        getgenv().emoteVFXStatus = "Waiting for native VFX"
        
                        if dispatcher and nativeAnimationHooksReady then
                            state.activeOriginal = dispatcher.Original
                            state.overrideUntil = os.clock() + 8
        
                            
                            task.defer(function()
                                if state.destroyed or state.playToken ~= playToken then return end
                                state.scheduleNativeSoundCues(dispatcher, entry, playToken)
                            end)
        
                            nativeStarted = state.fireNative(dispatcher)
                            state.captureTrack(entry, playToken)
                        elseif not dispatcher then
                            getgenv().emoteVFXStatus = "Native emote dispatcher not found ? direct VFX mode"
                            state.scheduleLooseMediaCue("Sound", entry, playToken)
                        else
                            getgenv().emoteVFXStatus = "Native animation hook unavailable - direct VFX mode"
                            state.scheduleLooseMediaCue("Sound", entry, playToken)
                        end
        
                        
                        if not nativeStarted and getgenv().emoteVFXEnabled then
                            state.scheduleLooseMediaCue("VFX", entry, playToken)
                        end
        
                        task.delay(0.18, function()
                            if state.destroyed or state.playToken ~= playToken then return end
                            state.playAssociatedSounds(entry, false)
                        end)
        
                        local nativeProbeDelay = nativeStarted and 0.55 or 0.22
                        task.delay(nativeProbeDelay, function()
                            if state.destroyed
                                or state.playToken ~= playToken
                                or not getgenv().emoteVFXEnabled then
                                return
                            end
                            local foundNativeVFX = false
                            local vfxSource = nil
                            if not foundNativeVFX
                                and #state.activeVFX == 0
                                and not state.mediaCueFired(playToken, state.makeMediaCueKey("VFX", state.getMediaCueSpec(entry, "VFX"), "loose")) then
                                if nativeStarted and state.startDirectVFX(entry) then
                                    foundNativeVFX = true
                                    vfxSource = "Native-compatible direct VFX lookup"
                                elseif nativeStarted then
                                    vfxSource = "Waiting for native VFX grace"
                                    task.delay(0.65, function()
                                        if state.destroyed
                                            or state.playToken ~= playToken
                                            or #state.activeVFX > 0
                                            or state.mediaCueFired(playToken, state.makeMediaCueKey("VFX", state.getMediaCueSpec(entry, "VFX"), "loose")) then
                                            return
                                        end
                                        state.scheduleLooseMediaCue("VFX", entry, playToken)
                                    end)
                                else
                                    state.scheduleLooseMediaCue("VFX", entry, playToken)
                                    vfxSource = "Direct GetEmoteVFX lookup (synced fallback)"
                                end
                            end
                            if foundNativeVFX then
                                state.lastVFXCueKey = state.lastVFXCueKey or state.makeMediaCueKey("VFX", state.getMediaCueSpec(entry, "VFX"), "native")
                                getgenv().emoteVFXStatus = "VFX active: " .. tostring(vfxSource)
                            elseif vfxSource then
                                getgenv().emoteVFXStatus = "Waiting for synced VFX cue: " .. tostring(vfxSource)
                            else
                                getgenv().emoteVFXStatus = "VFX not found | roots=" .. tostring(#getEmoteVFXRoots())
                                    .. " BF=" .. tostring(hooks.bindableFunction)
                                    .. " BE=" .. tostring(hooks.bindableEvent)
                                    .. " RE=" .. tostring(hooks.remoteEvent)
                                    .. " RF=" .. tostring(hooks.remoteFunction)
                            end
                        end)
        
                        task.delay(8, function()
                            if state.destroyed or state.playToken ~= playToken then return end
                            state.activeOriginal = nil
                            state.overrideUntil = 0
                        end)
        
                        
                        task.delay(nativeStarted and 0.35 or 0.15, function()
                            if state.destroyed or state.playToken ~= playToken then return end
                            if not state.activeTrack then state.playLocalFallback(entry, playToken) end
                        end)
                    end)
        
                    return true, "Starting emote"
                end
        
                getgenv().refreshBladeBallEmotes = refreshCatalog
                getgenv().playEmote = state.playEmote
                getgenv().stopEmote = state.stopEmote
                getgenv().setBladeBallEmoteUnlock = function(enabled)
                    local wasEnabled = state.emoteWheelEnabled == true
                    getgenv().emoteVFXEnabled = enabled == true
                    state.emoteWheelEnabled = enabled == true
        
                    if state.emoteWheelEnabled then
                        
                        getgenv()._azSlotRestoreTries = 0
                        getgenv()._azRestoreSlots = function()
                            if getgenv().emoteVFXEnabled ~= true then return end
                            local store = getgenv()._azEmoteSlotStore
                            if type(store) ~= "table" then return end
                            local anyPending = false
                            for k, v in pairs(store) do
                                local slot = tonumber(k)
                                if slot and type(v) == "table" then
                                    if v.Name then
                                        state.nativeSlotEmotes = state.nativeSlotEmotes or {}
                                        state.nativeSlotEmotes[slot] = v.Name
                                    end
                                    local eid = v.Id or v.Name
                                    if eid and getgenv().equipEmoteToSlot then
                                        local ok = false
                                        pcall(function() ok = getgenv().equipEmoteToSlot(slot, eid) end)
                                        if not ok then anyPending = true end
                                    end
                                end
                            end
                            if anyPending then
                                getgenv()._azSlotRestoreTries = (getgenv()._azSlotRestoreTries or 0) + 1
                                if getgenv()._azSlotRestoreTries < 60 then
                                    task.delay(1, getgenv()._azRestoreSlots)
                                end
                            end
                        end
                        task.delay(1.5, getgenv()._azRestoreSlots)
        
                        if #state.catalog == 0 then refreshCatalog() end
                        
                        task.defer(function()
                            pcall(installHooks)
                        end)
                        task.defer(function()
                            pcall(initializeEmoteObservers)
                        end)
                        task.defer(function()
                            pcall(findNativeDispatcher)
                        end)
                        if wasEnabled then
                            if state.updateCustomWheel then state.updateCustomWheel() end
                            task.defer(state.applyEmoteWheelList)
                        else
                            state.initializeEmoteWheelList()
                        end
                    else
                        state.stopEmote()
                        state.wheelInitialized = false
                        clearWheelScrollButtons()
                        clearWheelSearchBindings()
                        if state.customWheelConn then
                            pcall(function() state.customWheelConn:Disconnect() end)
                            state.customWheelConn = nil
                        end
                        if state.customWheelGui then
                            pcall(function() state.customWheelGui:Destroy() end)
                            state.customWheelGui = nil
                        end
                        if state.customWheelButtonGui then
                            pcall(function() state.customWheelButtonGui:Destroy() end)
                            state.customWheelButtonGui = nil
                        end
                        if state.wheelConnection then
                            pcall(function() state.wheelConnection:Disconnect() end)
                            state.wheelConnection = nil
                        end
                    end
                end
                getgenv().installBladeBallEmoteWheel = function()
                    getgenv().setBladeBallEmoteUnlock(true)
                    return state.applyEmoteWheelList()
                end
        
                state.Destroy = function()
                    state.destroyed = true
                    state.stopEmote()
                    if state.diedConnection then state.diedConnection:Disconnect() end
                    if state.characterConnection then state.characterConnection:Disconnect() end
                    if state.runningConnection then pcall(function() state.runningConnection:Disconnect() end) end
                    if state.wheelConnection then pcall(function() state.wheelConnection:Disconnect() end) end
                    if state.customWheelConn then pcall(function() state.customWheelConn:Disconnect() end) end
                    if state.customWheelGui then pcall(function() state.customWheelGui:Destroy() end) end
                    if state.customWheelButtonGui then pcall(function() state.customWheelButtonGui:Destroy() end) end
                    clearWheelScrollButtons()
                    clearWheelSearchBindings()
                    if hooks.activeState == state then hooks.activeState = nil end
                end
        
                state.bindCharacter = function(character)
                    if state.diedConnection then state.diedConnection:Disconnect() end
                    local humanoid = character:WaitForChild("Humanoid", 10)
                    if humanoid then state.diedConnection = humanoid.Died:Connect(state.stopEmote) end
                end
        
                state.characterConnection = LocalPlayer.CharacterAdded:Connect(function(character)
                    state.stopEmote()
                    task.defer(state.bindCharacter, character)
                end)
                if LocalPlayer.Character then task.defer(state.bindCharacter, LocalPlayer.Character) end
                end 
            end)()
        
        local function setShopButtonText(button, text)
            if not button then return end
            for _, object in ipairs(button:GetDescendants()) do
                if object:IsA("TextLabel") or object:IsA("TextButton") or object:IsA("TextBox") then
                    object.Text = text
                end
            end
            if button:IsA("TextButton") then button.Text = text end
        end
        
        local function getShopItemName(shop)
            local name = ""
            pcall(function()
                local info = shop.Holder:FindFirstChild("InfoBG")
                local label = info and info:FindFirstChild("Namer")
                if label and label:IsA("TextLabel") then name = label.Text end
            end)
            if name == "" then name = getgenv()._azCurrentInfoItem or "" end
            return name
        end
        
        local function getShopItemKind(name)
            local ok, isSword = pcall(function()
                local swords = require(ReplicatedStorage.Shared.ReplicatedInstances.Swords)
                return swords:GetSword(name) ~= nil
            end)
            return ok and isSword and "Sword" or "Explosion"
        end
        
        local function equipShopItem(shop, button)
            local itemName = getShopItemName(shop)
            if itemName == "" or itemName == "Title" then return end
        
            local kind = getShopItemKind(itemName)
            setShopButtonText(button, "Equipped")
        
            if kind == "Explosion" then
                getgenv().explosionFX = itemName
                getgenv().explosionChanger = true
                if getgenv().updateExplosion then task.spawn(getgenv().updateExplosion) end
            else
                getgenv().swordModel = itemName
                getgenv().swordAnimations = itemName
                getgenv().swordFX = itemName
                getgenv().skinChanger = true
                if getgenv().updateSword then task.spawn(getgenv().updateSword) end
            end
        
            task.spawn(function()
                local untilTime = os.clock() + 2.5
                while button.Parent and os.clock() < untilTime do
                    setShopButtonText(button, "Equipped")
                    task.wait(0.05)
                end
            end)
        end
        
        local function unlockShopCards(shop)
            if getgenv()._azStandaloneUnlockLoop then return end
            getgenv()._azStandaloneUnlockLoop = true
            getgenv().skinChanger = true
            getgenv().explosionChanger = true
        
            task.spawn(function()
                while shop.Parent do
                    local holder = shop:FindFirstChild("Holder")
                    local pages = holder and holder:FindFirstChild("Pages")
        
                    for _, pageName in ipairs({"Sword", "Explosion"}) do
                        local page = pages and pages:FindFirstChild(pageName)
                        if page then
                            local header = page:FindFirstChild("HeaderTitle")
                            if header then header.Visible = false end
        
                            for _, child in ipairs(page:GetDescendants()) do
                                if child.Name == "Lock" and child:IsA("GuiObject") then
                                    child.Visible = false
                                    local card = child.Parent
                                    if card and card:IsA("GuiObject") then
                                        card.LayoutOrder = 0
                                        if card.Parent and card.Parent.Name == "Unowned" then
                                            local owned = page:FindFirstChild("Owned", true)
                                            if owned and owned:IsA("GuiObject") then card.Parent = owned end
                                        end
        
                                        if not card:FindFirstChild("AzureStandaloneItemHook") then
                                            local tag = Instance.new("BoolValue")
                                            tag.Name = "AzureStandaloneItemHook"
                                            tag.Parent = card
        
                                            local itemName = card.Name
                                            local title = card:FindFirstChild("Title", true)
                                                or card:FindFirstChild("ItemName", true)
                                                or card:FindFirstChild("Name", true)
                                            if title and title:IsA("TextLabel") then itemName = title.Text end
        
                                            card.InputEnded:Connect(function(input)
                                                if input.UserInputType == Enum.UserInputType.MouseButton1
                                                    or input.UserInputType == Enum.UserInputType.Touch then
                                                    getgenv()._azCurrentInfoItem = itemName
                                                end
                                            end)
                                        end
                                    end
                                end
                            end
                        end
                    end
        
                    local info = holder and holder:FindFirstChild("InfoBG")
                    local button = info and (info:FindFirstChild("BuyButton") or info:FindFirstChild("EquipButton"))
                    if not button and info then
                        for _, child in ipairs(info:GetChildren()) do
                            if (child:IsA("TextButton") or child:IsA("ImageButton"))
                                and not child.Name:lower():find("close", 1, true) then
                                button = child
                                break
                            end
                        end
                    end
        
                    if button then
                        button.Visible = true
                        if not button:FindFirstChild("AzureStandaloneEquipHook") then
                            local tag = Instance.new("BoolValue")
                            tag.Name = "AzureStandaloneEquipHook"
                            tag.Parent = button
                            button.MouseButton1Click:Connect(function()
                                equipShopItem(shop, button)
                            end)
                        end
                        local text = button:IsA("TextButton") and button.Text or ""
                        if text ~= "Equipped" then setShopButtonText(button, "Equip") end
                    end
        
                    task.wait(0.15)
                end
                getgenv()._azStandaloneUnlockLoop = false
            end)
        end
        
        local function enableEverything(statusLabel)
            local shop = LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("Shop")
            if shop then
                unlockShopCards(shop)
            else
                task.spawn(function()
                    local found = LocalPlayer.PlayerGui:WaitForChild("Shop", 15)
                    if found then unlockShopCards(found) end
                end)
            end
        
            if getgenv().setBladeBallEmoteUnlock then
                getgenv().setBladeBallEmoteUnlock(true)
            else
                getgenv().emoteVFXEnabled = true
            end
        
            task.spawn(function()
                task.wait(0.2)
                local names = getgenv().refreshBladeBallEmotes and getgenv().refreshBladeBallEmotes() or {}
                if type(names) ~= "table" then names = getgenv().emoteNames or {} end
                task.wait(0.3)
                local refreshed = getgenv().refreshBladeBallEmotes and getgenv().refreshBladeBallEmotes() or names
                if type(refreshed) == "table" then names = refreshed end
                if getgenv().installBladeBallEmoteWheel then
                    getgenv().installBladeBallEmoteWheel()
                end
                if statusLabel and statusLabel.Parent then
                    statusLabel.Text = "ACTIVE | " .. tostring(#names) .. " EMOTES"
                    statusLabel.TextColor3 = Color3.fromRGB(120, 255, 170)
                end
            end)
        end
        
        __unlockAllEnable = enableEverything
    end)
    if ok then
        __unlockAllInit = true
        return true
    else
        warn("[UnlockAll] backend init failed:", err)
        return false
    end
end

local function runUnlockAll()
    if not __initUnlockAllBackend() then return end
    if type(__unlockAllEnable) == "function" then
        pcall(__unlockAllEnable, nil)
    end
end

getgenv().__runUnlockAll = runUnlockAll

local ThemeState = {
    AccentHue = 215,
    Transparency = 0,
    CornerRadius = 12
}

local function getThemeColor()
    return Color3.fromHSV((ThemeState.AccentHue % 360) / 360, 0.62, 0.92)
end

local function applyTheme()
    local root = library._ui
    if not root then return end

    local accent = getThemeColor()
    local transparency = math.clamp(ThemeState.Transparency / 100, 0, 0.9)
    local radius = math.clamp(ThemeState.CornerRadius, 0, 24)

    local container = root:FindFirstChild('Container')
    if container then
        container.BackgroundTransparency = transparency
        local containerCorner = container:FindFirstChildOfClass('UICorner')
        if containerCorner then
            containerCorner.CornerRadius = UDim.new(0, radius)
        end
        local containerStroke = container:FindFirstChildOfClass('UIStroke')
        if containerStroke then
            containerStroke.Color = accent
        end
        local side = container:FindFirstChild('GradientSide', true)
        if side then
            local gradient = side:FindFirstChildOfClass('UIGradient')
            if gradient then
                gradient.Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 34)),
                    ColorSequenceKeypoint.new(0.5, accent),
                    ColorSequenceKeypoint.new(1, accent:Lerp(Color3.fromRGB(170, 90, 255), 0.45))
                }
            end
        end
    end

    for _, object in ipairs(root:GetDescendants()) do
        if object:IsA('UICorner') then
            local parent = object.Parent
            if parent and parent.Name ~= 'Circle' and parent.Name ~= 'Toggle' and parent.Name ~= 'Dot' and parent.Name ~= 'AvatarClip' then
                object.CornerRadius = UDim.new(0, radius)
            end
        elseif object:IsA('TextLabel') or object:IsA('TextButton') or object:IsA('TextBox') then
            local baseSize = object:GetAttribute('ThemeBaseTextSize')
            if not baseSize then
                baseSize = object.TextSize
                object:SetAttribute('ThemeBaseTextSize', baseSize)
            end
            object.TextSize = baseSize
        elseif object:IsA('Frame') and (object.Name == 'Fill' or object.Name == 'RangeFill' or object.Name == 'ActiveIndicator') then
            object.BackgroundColor3 = accent
        end
    end

    if library._notification_helpers and library._notification_helpers.theme then
        library._notification_helpers.theme.accent = accent
        library._notification_helpers.theme.info = accent
        library._notification_helpers.theme.radius = UDim.new(0, radius)
    end
end

local function resetThemeDefaults()
    ThemeState.AccentHue = 215
    ThemeState.Transparency = 0
    ThemeState.CornerRadius = 12

    if Library._config and Library._config._flags then
        Library._config._flags.ThemeAccentHue = ThemeState.AccentHue
        Library._config._flags.ThemeTransparency = ThemeState.Transparency
        Library._config._flags.ThemeCornerRadius = ThemeState.CornerRadius
        Config:save(game.GameId, Library._config)
    end

    applyTheme()
end

local theme_editor_module = GuiTab:create_module({
    title = 'Theme Editor',
    description = 'Customize the interface theme',
    flag = 'ThemeEditor',
    section = 'right',
    callback = function(state)
        if state then
            applyTheme()
        else
            resetThemeDefaults()
        end
    end
})

theme_editor_module:create_slider({
    title = 'Accent',
    flag = 'ThemeAccentHue',
    minimum_value = 0,
    maximum_value = 360,
    value = 215,
    round_number = true,
    callback = function(value)
        ThemeState.AccentHue = value
        applyTheme()
    end
})

theme_editor_module:create_slider({
    title = 'Transparency',
    flag = 'ThemeTransparency',
    minimum_value = 0,
    maximum_value = 90,
    value = 0,
    round_number = true,
    callback = function(value)
        ThemeState.Transparency = value
        applyTheme()
    end
})

theme_editor_module:create_slider({
    title = 'Corner Radius',
    flag = 'ThemeCornerRadius',
    minimum_value = 0,
    maximum_value = 24,
    value = 12,
    round_number = true,
    callback = function(value)
        ThemeState.CornerRadius = value
        applyTheme()
    end
})

theme_editor_module:create_button({
    title = 'Reset Theme',
    callback = function()
        ThemeState.AccentHue = 215
        ThemeState.Transparency = 0
        ThemeState.CornerRadius = 12
        applyTheme()
    end
})

task.defer(applyTheme)

local unlock_all_module = UnlockTab:create_module({
    title = "Unlock All",
    description = "Unlock all Swords, Explosions and Emotes",
    flag = "UnlockAll",
    section = "left",
    callback = function(state)
        getgenv().unlockAllEnabled = state
        if state and getgenv().__runUnlockAll then
            task.spawn(getgenv().__runUnlockAll)
        end
    end
})

local guilib_module = GuiTab:create_module({
    title = "GUI Visible",
    description = "Visibility of GUI Library",
    flag = "guilibraryvisible",
    section = "left",
    callback = function(state)
        getgenv().guilibraryVisible = state
    end
})

local stats_overlay_module = VisualsTab:create_module({
    title = "FPS and Ping",
    description = "Show your FPS and Ping",
    flag = "StatsOverlayModule",
    section = "right",
    callback = function(state)
        if state then
            
            System = System or {}
            System.__properties = System.__properties or {}
            System.__properties.__connections = System.__properties.__connections or {}

            if not System.__properties.__stats_overlay then
                local OverlayGui = Instance.new('ScreenGui')
                OverlayGui.Name = 'AzureStatsOverlay'
                OverlayGui.ResetOnSpawn = false
                OverlayGui.IgnoreGuiInset = true
                OverlayGui.DisplayOrder = 99
                OverlayGui.Parent = CoreGui

                local Panel = Instance.new('Frame')
                Panel.Name = 'Panel'
                Panel.Size = UDim2.new(0, 178, 0, 86)
                Panel.Position = UDim2.new(0, 20, 0.5, -43)
                Panel.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
                Panel.BorderSizePixel = 0
                Panel.Active = true
                Panel.Parent = OverlayGui
                Instance.new('UICorner', Panel).CornerRadius = UDim.new(0, 12)
                local PanelStroke = Instance.new('UIStroke', Panel)
                PanelStroke.Color = Color3.fromRGB(70, 70, 70)
                PanelStroke.Thickness = 1

                local TitleLabel = Instance.new('TextLabel')
                TitleLabel.BackgroundTransparency = 1
                TitleLabel.Size = UDim2.new(1, 0, 0, 18)
                TitleLabel.Position = UDim2.new(0, 0, 0, 6)
                TitleLabel.FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.Bold, Enum.FontStyle.Normal)
                TitleLabel.Text = 'FPS & PING'
                TitleLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
                TitleLabel.TextSize = 10
                TitleLabel.TextXAlignment = Enum.TextXAlignment.Center
                TitleLabel.Parent = Panel

                local ChipHolder = Instance.new('Frame')
                ChipHolder.BackgroundTransparency = 1
                ChipHolder.Position = UDim2.new(0, 10, 0, 26)
                ChipHolder.Size = UDim2.new(1, -20, 0, 44)
                ChipHolder.Parent = Panel
                local ChipLayout = Instance.new('UIListLayout', ChipHolder)
                ChipLayout.FillDirection = Enum.FillDirection.Horizontal
                ChipLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
                ChipLayout.VerticalAlignment = Enum.VerticalAlignment.Center
                ChipLayout.Padding = UDim.new(0, 6)

                local function makeChip(tag)
                    local Chip = Instance.new('Frame')
                    Chip.Size = UDim2.new(0, 70, 0, 36)
                    Chip.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
                    Chip.BorderSizePixel = 0
                    Chip.Parent = ChipHolder
                    Instance.new('UICorner', Chip).CornerRadius = UDim.new(0, 10)
                    local CS = Instance.new('UIStroke', Chip)
                    CS.Color = Color3.fromRGB(60, 60, 60)
                    CS.Thickness = 1

                    local Dot = Instance.new('Frame')
                    Dot.Name = 'Dot'
                    Dot.Size = UDim2.new(0, 4, 0, 4)
                    Dot.Position = UDim2.new(0, 6, 0, 5)
                    Dot.BackgroundColor3 = Color3.fromRGB(100, 220, 130)
                    Dot.BorderSizePixel = 0
                    Dot.Parent = Chip
                    Instance.new('UICorner', Dot).CornerRadius = UDim.new(1, 0)

                    local Tag = Instance.new('TextLabel')
                    Tag.BackgroundTransparency = 1
                    Tag.Size = UDim2.new(1, -8, 0, 9)
                    Tag.Position = UDim2.new(0, 4, 0, 3)
                    Tag.FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
                    Tag.Text = tag
                    Tag.TextColor3 = Color3.fromRGB(180, 180, 180)
                    Tag.TextSize = 8
                    Tag.TextXAlignment = Enum.TextXAlignment.Center
                    Tag.Parent = Chip

                    local Val = Instance.new('TextLabel')
                    Val.Name = 'Val'
                    Val.BackgroundTransparency = 1
                    Val.Size = UDim2.new(1, 0, 0, 16)
                    Val.Position = UDim2.new(0, 0, 0, 16)
                    Val.FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.Bold, Enum.FontStyle.Normal)
                    Val.Text = '--'
                    Val.TextColor3 = Color3.fromRGB(240, 240, 240)
                    Val.TextSize = 13
                    Val.TextXAlignment = Enum.TextXAlignment.Center
                    Val.Parent = Chip

                    return Val, Dot
                end

                local FpsVal, FpsDot   = makeChip('FPS')
                local PingVal, PingDot = makeChip('PING')

                Panel.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        local dragStart = input.Position
                        local startPos  = Panel.Position
                        local moving    = true
                        input.Changed:Connect(function()
                            if input.UserInputState == Enum.UserInputState.End then moving = false end
                        end)
                        local conn
                        conn = UserInputService.InputChanged:Connect(function(inp)
                            if not moving then conn:Disconnect() return end
                            if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then
                                local delta = inp.Position - dragStart
                                Panel.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
                            end
                        end)
                    end
                end)

                System.__properties.__stats_overlay = {
                    gui = OverlayGui,
                    fpsVal = FpsVal, fpsDot = FpsDot,
                    pingVal = PingVal, pingDot = PingDot,
                }
            end

            System.__properties.__stats_overlay.gui.Enabled = true

            if not System.__properties.__connections.__stats_overlay then
                local frameCount = 0
                local elapsed    = 0
                local smoothFps  = 0

                local fpsConn = RunService.RenderStepped:Connect(function(dt)
                    frameCount += 1
                    elapsed    += dt
                    if elapsed >= 0.5 then
                        smoothFps  = math.round(frameCount / elapsed)
                        frameCount = 0
                        elapsed    = 0
                    end
                end)
                System.__properties.__connections.__stats_overlay_fps = fpsConn

                System.__properties.__connections.__stats_overlay = task.spawn(function()
                    while System.__properties.__stats_overlay do
                        local o = System.__properties.__stats_overlay
                        pcall(function()
                            local fps = smoothFps
                            local fpsColor = fps >= 55 and Color3.fromRGB(100,220,130) or fps >= 30 and Color3.fromRGB(230,200,80) or Color3.fromRGB(220,80,80)
                            o.fpsVal.Text = tostring(fps)
                            o.fpsVal.TextColor3 = fpsColor
                            o.fpsDot.BackgroundColor3 = fpsColor

                            local ping = math.round(Players.LocalPlayer:GetNetworkPing() * 1000)
                            local pingColor = ping <= 80 and Color3.fromRGB(100,220,130) or ping <= 150 and Color3.fromRGB(230,200,80) or Color3.fromRGB(220,80,80)
                            o.pingVal.Text = tostring(ping)
                            o.pingVal.TextColor3 = pingColor
                            o.pingDot.BackgroundColor3 = pingColor
                        end)
                        task.wait(0.5)
                    end
                end)
            end

        else
            if System.__properties.__connections.__stats_overlay then
                System.__properties.__connections.__stats_overlay = nil
            end
            if System.__properties.__connections.__stats_overlay_fps then
                pcall(function() System.__properties.__connections.__stats_overlay_fps:Disconnect() end)
                System.__properties.__connections.__stats_overlay_fps = nil
            end
            if System.__properties.__stats_overlay then
                pcall(function() System.__properties.__stats_overlay.gui:Destroy() end)
                System.__properties.__stats_overlay = nil
            end
        end
    end
})

    local blatant_exploits_module = BlatantTab:create_module({
        title = "Infinite Jump",
        description = "Character Infinite Jump",
        flag = "infinitejump",
        section = "left",
        callback = function(state)
            if state then
                if not getgenv().InfiniteJumpConnection then
                    getgenv().InfiniteJumpConnection = UserInputService.JumpRequest:Connect(function()
                        if Library._config._flags["infinitejump"] then
                            local char = Players.LocalPlayer and Players.LocalPlayer.Character
                            if char and char:FindFirstChild("Humanoid") then
                                char.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                            end
                        end
                    end)
                end
            else
                if getgenv().InfiniteJumpConnection then
                    getgenv().InfiniteJumpConnection:Disconnect()
                    getgenv().InfiniteJumpConnection = nil
                end
            end
        end,
    })

    local original_fog_end = Lighting.FogEnd
local original_fog_start = Lighting.FogStart
local postprocessing_backup = {}
local decals_backup = {}
local scene_backup = {}
local sound_backup = nil
local lighting_backup = nil
local fog_backup = nil
local sound_service = cloneref(game:GetService('SoundService'))
local fps_boost_loop = nil
local fps_boost_enabled = false

local function apply_disable_fog(state)
    if state then
        Lighting.FogEnd = math.huge
        Lighting.FogStart = math.huge
    else
        Lighting.FogEnd = original_fog_end
        Lighting.FogStart = original_fog_start
    end
end

local function apply_disable_postprocessing(state)
    if state then
        for _, v in pairs(Lighting:GetDescendants()) do
            pcall(function()
                if v.Enabled ~= nil then
                    postprocessing_backup[v] = v.Enabled
                    v.Enabled = false
                end
            end)
        end

        fog_backup = {
            FogEnd = Lighting.FogEnd,
            FogStart = Lighting.FogStart,
            FogColor = Lighting.FogColor
        }

        pcall(function()
            Lighting.FogEnd = math.huge
            Lighting.FogStart = math.huge
            Lighting.FogColor = Color3.new(0, 0, 0)
        end)
    else
        for v, enabled in pairs(postprocessing_backup) do
            pcall(function()
                if v and v.Parent and v.Enabled ~= nil then
                    v.Enabled = enabled
                end
            end)
        end
        postprocessing_backup = {}

        if fog_backup then
            pcall(function()
                Lighting.FogEnd = fog_backup.FogEnd
                Lighting.FogStart = fog_backup.FogStart
                Lighting.FogColor = fog_backup.FogColor
            end)
            fog_backup = nil
        end
    end
end

local function apply_remove_decals(state)
    if state then
        for _, v in pairs(workspace:GetDescendants()) do
            pcall(function()
                if v:IsA("Decal") or v:IsA("Texture") then
                    decals_backup[v] = {Texture = v.Texture, Transparency = v.Transparency}
                    pcall(function() v.Texture = "" end)
                    pcall(function() v.Transparency = 1 end)
                end
            end)
        end
    else
        for v, data in pairs(decals_backup) do
            pcall(function()
                if v and v.Parent then
                    if data.Texture ~= nil then pcall(function() v.Texture = data.Texture end) end
                    if data.Transparency ~= nil then pcall(function() v.Transparency = data.Transparency end) end
                end
            end)
        end
        decals_backup = {}
    end
end

local function is_character_object(obj)
    if not obj then
        return false
    end

    local local_character = Players.LocalPlayer and Players.LocalPlayer.Character
    if local_character and obj:IsDescendantOf(local_character) then
        return true
    end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= Players.LocalPlayer and player.Character and obj:IsDescendantOf(player.Character) then
            return true
        end
    end

    return false
end

local function apply_fps_boost(state)
    fps_boost_enabled = state

    if fps_boost_loop then
        fps_boost_loop:Disconnect()
        fps_boost_loop = nil
    end

    if not state then
        apply_disable_fog(false)
        apply_disable_postprocessing(false)
        apply_remove_decals(false)

        if lighting_backup then
            Lighting.Technology = lighting_backup.Technology
            Lighting.Brightness = lighting_backup.Brightness
            Lighting.ExposureCompensation = lighting_backup.ExposureCompensation
            Lighting.GlobalShadows = lighting_backup.GlobalShadows
            Lighting.OutdoorAmbient = lighting_backup.OutdoorAmbient
            Lighting.Ambient = lighting_backup.Ambient
            Lighting.ColorShift_Bottom = lighting_backup.ColorShift_Bottom
            Lighting.ColorShift_Top = lighting_backup.ColorShift_Top
            Lighting.ClockTime = lighting_backup.ClockTime
            Lighting.ShadowSoftness = lighting_backup.ShadowSoftness
            lighting_backup = nil
        end

        for obj, values in pairs(scene_backup) do
            pcall(function()
                if obj and obj.Parent then
                    if values.Enabled ~= nil then
                        obj.Enabled = values.Enabled
                    end
                    if values.CastShadow ~= nil then
                        obj.CastShadow = values.CastShadow
                    end
                    if values.Material ~= nil then
                        obj.Material = values.Material
                    end
                end
            end)
        end
        scene_backup = {}

        if sound_service and sound_backup ~= nil then
            sound_service.Volume = sound_backup
            sound_backup = nil
        end

        return
    end

    apply_disable_fog(true)
    apply_disable_postprocessing(true)
    apply_remove_decals(true)

    lighting_backup = {
        Technology = Lighting.Technology,
        Brightness = Lighting.Brightness,
        ExposureCompensation = Lighting.ExposureCompensation,
        GlobalShadows = Lighting.GlobalShadows,
        OutdoorAmbient = Lighting.OutdoorAmbient,
        Ambient = Lighting.Ambient,
        ColorShift_Bottom = Lighting.ColorShift_Bottom,
        ColorShift_Top = Lighting.ColorShift_Top,
        ClockTime = Lighting.ClockTime,
        ShadowSoftness = Lighting.ShadowSoftness
    }

    Lighting.Technology = Enum.Technology.Compatibility
    Lighting.Brightness = 0.18
    Lighting.ExposureCompensation = -1.2
    Lighting.GlobalShadows = false
    Lighting.OutdoorAmbient = Color3.fromRGB(35, 35, 35)
    Lighting.Ambient = Color3.fromRGB(35, 35, 35)
    Lighting.ColorShift_Bottom = Color3.new(0, 0, 0)
    Lighting.ColorShift_Top = Color3.new(0, 0, 0)
    Lighting.ClockTime = 14
    Lighting.ShadowSoftness = 0

    if sound_service and sound_backup == nil then
        sound_backup = sound_service.Volume
        sound_service.Volume = 0.03
    end

    fps_boost_loop = RunService.Heartbeat:Connect(function()
        if not fps_boost_enabled then
            return
        end

        for _, obj in pairs(workspace:GetDescendants()) do
            pcall(function()
                if is_character_object(obj) then
                    return
                end

                if obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Highlight") or obj:IsA("SurfaceGui") or obj:IsA("BillboardGui") or obj:IsA("ParticleEmitter") or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") or obj:IsA("Explosion") or obj:IsA("Weld") or obj:IsA("UIStroke") or obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("ImageLabel") then
                    local stored = scene_backup[obj]
                    if not stored then
                        scene_backup[obj] = {Enabled = obj.Enabled}
                    end
                    obj.Enabled = false
                elseif obj:IsA("Part") then
                    local stored = scene_backup[obj]
                    if not stored then
                        scene_backup[obj] = {CastShadow = obj.CastShadow, Material = obj.Material}
                    end
                    obj.CastShadow = false
                    obj.Material = Enum.Material.SmoothPlastic
                elseif obj:IsA("Atmosphere") then
                    obj.Density = 0
                end
            end)
        end
    end)
end

MiscTab:create_module({
    title = "FPS Booster",
    description = "Lower your Graphics to improve FPS",
    flag = "FPSBooster",
    section = "right",
    callback = function(state)
        apply_fps_boost(state)
    end
})

local low_graphics_original_quality = nil
MiscTab:create_module({
    title = "Low Graphics",
    description = "Reduce Rendering quality and shadows",
    flag = "LowGraphics",
    section = "right",
    callback = function(state)
        if state then
            pcall(function()
                low_graphics_original_quality = settings().Rendering.QualityLevel
                settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
            end)
            pcall(function()
                local lighting = game:GetService("Lighting")
                lighting.GlobalShadows = false
                lighting.FogEnd = 9e9
            end)
        else
            pcall(function()
                if low_graphics_original_quality then
                    settings().Rendering.QualityLevel = low_graphics_original_quality
                end
            end)
            pcall(function()
                local lighting = game:GetService("Lighting")
                lighting.GlobalShadows = true
            end)
        end
    end
})

local GROUP_ID = 12836673
local MIN_RANK = 10
local modActionMode = "Notification"
local modDetectionEnabled = false
local detectedMods = {}
local modMonitorConnection = nil

local function getPlayerRank(player)
    local success, rank = pcall(function()
        return player:GetRankInGroup(GROUP_ID)
    end)

    return success and rank or 0
end

local function showModNotification(player)
    local notif = Instance.new("ScreenGui")
    notif.Name = "ModNotification"
    notif.ResetOnSpawn = false
    notif.Parent = CoreGui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 350, 0, 60)
    frame.Position = UDim2.new(0.5, -175, 0.2, 0)
    frame.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    frame.BackgroundTransparency = 0.15
    frame.BorderSizePixel = 0
    frame.Parent = notif

    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(1, 0, 1, 0)
    text.BackgroundTransparency = 1
    text.Text = "! Staff Joined! " .. player.Name .. " (Support+)"
    text.TextColor3 = Color3.fromRGB(255, 255, 255)
    text.TextSize = 18
    text.Font = Enum.Font.GothamBold
    text.Parent = frame

    task.delay(5, function()
        if notif and notif.Parent then
            notif:Destroy()
        end
    end)
end

local function kickSelf()
    Player:Kick("The mod has joined the server! Kicked to avoid ban.")
end

local function checkModPlayers()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= Player and not detectedMods[plr.UserId] then
            local rank = getPlayerRank(plr)
            if rank >= MIN_RANK then
                detectedMods[plr.UserId] = true
                if modActionMode == "Notification" then
                    showModNotification(plr)
                elseif modActionMode == "Kick" then
                    kickSelf()
                end
            end
        end
    end
end

local ReplicatedStorage = cloneref(game:GetService('ReplicatedStorage'))
local Stats = cloneref(game:GetService('Stats'))

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer and LocalPlayer:GetMouse()

if not LocalPlayer or not LocalPlayer.Character then
    if LocalPlayer then LocalPlayer.CharacterAdded:Wait() end
end

local Connections_Manager = getgenv().Connections_Manager or {}
getgenv().Connections_Manager = Connections_Manager

local Player = Players.LocalPlayer

local function get_real_ball()
    local balls = workspace:FindFirstChild('Balls')
    if not balls then
        return nil
    end

    for _, ball in pairs(balls:GetChildren()) do
        if ball:GetAttribute('realBall') then
            ball.CanCollide = false
            return ball
        end
    end

    return nil
end

local AutoPlayState = {
    connection = nil,
    character_connection = nil,
    elapsed = 0,
    control_point = nil,
    last_generation = 0,
    double_jumped = false,
    ball = nil,
    enabled = false
}

local function auto_play_percentage_check(limit)
    if tick() - AutoPlayState.last_generation < (getgenv().AutoPlayGenerationThreshold or 0.25) then
        return false
    end

    AutoPlayState.last_generation = tick()
    return math.random(100) <= limit
end

local function auto_play_get_floor()
    local floor = workspace:FindFirstChild('FLOOR')
    if floor then
        return floor
    end

    for _, part in ipairs(workspace:GetDescendants()) do
        if part:IsA('BasePart') and part.Size.X > 50 and part.Size.Z > 50 and part.Position.Y < 5 then
            return part
        end
    end

    return nil
end

local function auto_play_get_curve(startPosition, finishPosition, delta)
    AutoPlayState.elapsed = AutoPlayState.elapsed + delta
    local timeElapsed = math.clamp(AutoPlayState.elapsed / (getgenv().AutoPlayMovementDuration or 0.8), 0, 1)

    if timeElapsed >= 1 then
        AutoPlayState.elapsed = 0
        AutoPlayState.control_point = nil
        return finishPosition
    end

    if not AutoPlayState.control_point then
        local middle = (startPosition + finishPosition) * 0.5
        local difference = startPosition - finishPosition
        if difference.Magnitude < 5 then
            return finishPosition
        end

        local theta = math.atan2(difference.Z, difference.X)
        local offsetLength = difference.Magnitude * (getgenv().AutoPlayOffsetFactor or 0.7)
        local firstCandidate = middle + Vector3.new(math.cos(theta + math.pi / 2), 0, math.sin(theta + math.pi / 2)) * offsetLength
        local secondCandidate = middle + Vector3.new(math.cos(theta - math.pi / 2), 0, math.sin(theta - math.pi / 2)) * offsetLength
        local dotValue = startPosition - middle
        AutoPlayState.control_point = ((firstCandidate - middle):Dot(dotValue) < 0 and firstCandidate) or secondCandidate
    end

    local firstLerp = startPosition + (AutoPlayState.control_point - startPosition) * timeElapsed
    local secondLerp = AutoPlayState.control_point + (finishPosition - AutoPlayState.control_point) * timeElapsed
    return firstLerp + (secondLerp - firstLerp) * timeElapsed
end

local function auto_play_get_target_position()
    local floor = auto_play_get_floor()
    local ball = get_real_ball() or AutoPlayState.ball
    local character = Player.Character
    local hrp = character and character:FindFirstChild('HumanoidRootPart')

    if not floor or not ball or not hrp then
        return nil
    end

    AutoPlayState.ball = ball
    local direction = (hrp.Position - ball.Position).Unit
    local speed = 0
    local success, speed_value = pcall(function()
        if ball and ball:FindFirstChild('zoomies') and ball.zoomies and ball.zoomies.VectorVelocity then
            return ball.zoomies.VectorVelocity.Magnitude
        end
        return 0
    end)
    if success then
        speed = speed_value or 0
    end
    local speedThreshold = math.min(speed / 10, getgenv().AutoPlayMultiplierThreshold or 70)
    local distance = (getgenv().AutoPlayDistance or 30) + speedThreshold
    local offset = direction * distance * (getgenv().AutoPlayDirection or 1)
    local currentTime = os.time() / 1.2
    local sine = math.sin(currentTime) * (getgenv().AutoPlayTransversing or 25)
    local cosine = math.cos(currentTime) * (getgenv().AutoPlayTransversing or 25)
    local traversing = Vector3.new(sine, 0, cosine)

    return floor.Position + offset + traversing
end

local function auto_play_step()
    if not AutoPlayState.enabled then
        return
    end

    local character = Player.Character
    local humanoid = character and character:FindFirstChildOfClass('Humanoid')
    local hrp = character and character:FindFirstChild('HumanoidRootPart')

    if not humanoid or not hrp or humanoid.Health <= 0 then
        return
    end

    if humanoid.FloorMaterial ~= Enum.Material.Air then
        AutoPlayState.double_jumped = false
    end

    local targetPosition = auto_play_get_target_position()
    if targetPosition then
        local path = auto_play_get_curve(hrp.Position, targetPosition, 0.016)
        humanoid:MoveTo(path)
    end

    if getgenv().AutoPlayJumpingEnabled and auto_play_percentage_check(getgenv().AutoPlayJumpPercentage or 50) then
        if humanoid.FloorMaterial ~= Enum.Material.Air then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        elseif not AutoPlayState.double_jumped and auto_play_percentage_check(getgenv().AutoPlayDoubleJumpPercentage or 50) then
            local bodyVelocity = Instance.new('BodyVelocity')
            bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
            bodyVelocity.Velocity = Vector3.new(0, 80, 0)
            bodyVelocity.Parent = hrp
            Debris:AddItem(bodyVelocity, 0.1)
            AutoPlayState.double_jumped = true
        end
    end
end

local function auto_play_set_enabled(state)
    AutoPlayState.enabled = state
    getgenv().AutoPlay = state

    if AutoPlayState.connection then
        AutoPlayState.connection:Disconnect()
        AutoPlayState.connection = nil
    end

    if AutoPlayState.character_connection then
        AutoPlayState.character_connection:Disconnect()
        AutoPlayState.character_connection = nil
    end

    if state then
        AutoPlayState.connection = RunService.RenderStepped:Connect(auto_play_step)
        AutoPlayState.character_connection = Player.CharacterAdded:Connect(function()
            AutoPlayState.double_jumped = false
            AutoPlayState.ball = nil
            AutoPlayState.control_point = nil
            AutoPlayState.elapsed = 0
        end)
    end
end

local AutoPlay = PlayerTab:create_module({
    title = 'Auto Play',
    flag = 'AutoPlay',
    description = 'Automatically Plays Game',
    section = 'right',
    callback = function(value: boolean)
        auto_play_set_enabled(value)
    end
})

AutoPlay:create_checkbox({
    title = 'Anti AFK',
    flag = 'AutoPlayAntiAFK',
    callback = function(value: boolean)
        getgenv().AutoPlayAntiAFK = value

        if value then
            if not Connections_Manager['AutoPlayAntiAFK'] then
                Connections_Manager['AutoPlayAntiAFK'] = Players.LocalPlayer.Idled:Connect(function()
                    local virtualUser = cloneref(game:GetService('VirtualUser'))
                    virtualUser:CaptureController()
                    virtualUser:ClickButton2(Vector2.new())
                end)
            end
        else
            if Connections_Manager['AutoPlayAntiAFK'] then
                Connections_Manager['AutoPlayAntiAFK']:Disconnect()
                Connections_Manager['AutoPlayAntiAFK'] = nil
            end
        end
    end
})

AutoPlay:create_checkbox({
    title = 'Enable Jumping',
    flag = 'AutoPlayJumpingEnabled',
    callback = function(value: boolean)
        getgenv().AutoPlayJumpingEnabled = value
    end
})

AutoPlay:create_checkbox({
    title = 'Auto Vote',
    flag = 'AutoVote',
    callback = function(value: boolean)
        getgenv().AutoVote = value
    end
})

AutoPlay:create_divider({})

AutoPlay:create_slider({
    title = 'Distance From Ball',
    flag = 'default_distance',
    maximum_value = 100,
    minimum_value = 5,
    value = 18,
    round_number = true,
    callback = function(value: number)
        getgenv().AutoPlayDistance = value
    end
})

AutoPlay:create_slider({
    title = 'Speed Multiplier',
    flag = 'multiplier_threshold',
    maximum_value = 200,
    minimum_value = 10,
    value = 45,
    round_number = true,
    callback = function(value: number)
        getgenv().AutoPlayMultiplierThreshold = value
    end
})

AutoPlay:create_slider({
    title = 'Transversing',
    flag = 'traversing',
    maximum_value = 100,
    minimum_value = 0,
    value = 8,
    round_number = true,
    callback = function(value: number)
        getgenv().AutoPlayTransversing = value
    end
})

AutoPlay:create_slider({
    title = 'Direction',
    flag = 'Direction',
    maximum_value = 1,
    minimum_value = -1,
    value = 1,
    round_number = false,
    callback = function(value: number)
        getgenv().AutoPlayDirection = value
    end
})

AutoPlay:create_slider({
    title = 'Offset Factor',
    flag = 'OffsetFactor',
    maximum_value = 1,
    minimum_value = 0.1,
    value = 0.4,
    round_number = false,
    callback = function(value: number)
        getgenv().AutoPlayOffsetFactor = value
    end
})

AutoPlay:create_slider({
    title = 'Movement Duration',
    flag = 'MovementDuration',
    maximum_value = 1,
    minimum_value = 0.1,
    value = 0.75,
    round_number = false,
    callback = function(value: number)
        getgenv().AutoPlayMovementDuration = value
    end
})

AutoPlay:create_slider({
    title = 'Generation Threshold',
    flag = 'GenerationThreshold',
    maximum_value = 0.5,
    minimum_value = 0.1,
    value = 0.25,
    round_number = false,
    callback = function(value: number)
        getgenv().AutoPlayGenerationThreshold = value
    end
})

AutoPlay:create_slider({
    title = 'Jump Chance',
    flag = 'jump_percentage',
    maximum_value = 100,
    minimum_value = 0,
    value = 20,
    round_number = true,
    callback = function(value: number)
        getgenv().AutoPlayJumpPercentage = value
    end
})

AutoPlay:create_slider({
    title = 'Double Jump Chance',
    flag = 'double_jump_percentage',
    maximum_value = 100,
    minimum_value = 0,
    value = 10,
    round_number = true,
    callback = function(value: number)
        getgenv().AutoPlayDoubleJumpPercentage = value
    end
})

local Alive = workspace:FindFirstChild("Alive") or workspace:WaitForChild("Alive")
local Runtime = workspace.Runtime

local ballTrailState = {}
local rainbowHue = 0

local function clear_ball_trail(ball)
    if not ball then
        return
    end

    local existingTrail = ball:FindFirstChild('Trail')
    if existingTrail then
        existingTrail:Destroy()
    end

    local existingEmitter = ball:FindFirstChild('ParticleEmitter')
    if existingEmitter then
        existingEmitter:Destroy()
    end

    local existingGlow = ball:FindFirstChild('BallGlow')
    if existingGlow then
        existingGlow:Destroy()
    end

    local attachment0 = ball:FindFirstChild('Attachment0')
    if attachment0 then
        attachment0:Destroy()
    end

    local attachment1 = ball:FindFirstChild('Attachment1')
    if attachment1 then
        attachment1:Destroy()
    end

    ballTrailState[ball] = nil
end

local function apply_ball_trail(ball)
    if not ball then
        return
    end

    if not getgenv().BallTrailEnabled then
        clear_ball_trail(ball)
        return
    end

    if ballTrailState[ball] then
        local trail = ball:FindFirstChild('Trail')
        if trail then
            if getgenv().BallTrailRainbowEnabled then
                local color = Color3.fromHSV(rainbowHue / 360, 1, 1)
                trail.Color = ColorSequence.new(color)
                getgenv().BallTrailColor = color
            else
                trail.Color = ColorSequence.new(getgenv().BallTrailColor or Color3.new(1, 1, 1))
            end
        end
        return
    end

    ballTrailState[ball] = true

    local trail = Instance.new('Trail')
    trail.Name = 'Trail'

    local attachment0 = Instance.new('Attachment')
    attachment0.Name = 'Attachment0'
    attachment0.Position = Vector3.new(0, ball.Size.Y / 2, 0)
    attachment0.Parent = ball

    local attachment1 = Instance.new('Attachment')
    attachment1.Name = 'Attachment1'
    attachment1.Position = Vector3.new(0, -ball.Size.Y / 2, 0)
    attachment1.Parent = ball

    trail.Attachment0 = attachment0
    trail.Attachment1 = attachment1
    trail.Lifetime = 0.4
    trail.WidthScale = NumberSequence.new(0.5)
    trail.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(1, 1)
    })
    trail.Color = ColorSequence.new(getgenv().BallTrailColor or Color3.new(1, 1, 1))
    trail.Parent = ball

    if getgenv().BallTrailParticleEnabled then
        local emitter = Instance.new('ParticleEmitter')
        emitter.Name = 'ParticleEmitter'
        emitter.Rate = 100
        emitter.Lifetime = NumberRange.new(0.5, 1)
        emitter.Speed = NumberRange.new(0, 1)
        emitter.Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.5),
            NumberSequenceKeypoint.new(1, 0)
        })
        emitter.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(1, 1)
        })
        emitter.Parent = ball
    end

    if getgenv().BallTrailGlowEnabled then
        local glow = Instance.new('PointLight')
        glow.Name = 'BallGlow'
        glow.Range = 15
        glow.Brightness = 2
        glow.Parent = ball
    end
end

RunService.Heartbeat:Connect(function()
    rainbowHue = (rainbowHue + 1) % 360
    local ball = get_real_ball()
    if ball then
        apply_ball_trail(ball)
    else
        for _, existing_ball in ipairs(workspace:FindFirstChild('Balls') and workspace.Balls:GetChildren() or {}) do
            apply_ball_trail(existing_ball)
        end
    end
end)

local ball_trail_module = VisualsTab:create_module({
    title = 'Ball Trail',
    flag = 'Ball_Trail',
    description = 'Toggles ball trail effects',
    section = 'left',
    callback = function(value: boolean)
        getgenv().BallTrailEnabled = value
    end
})

ball_trail_module:create_slider({
    title = 'Ball Trail Hue',
    flag = 'Ball_Trail_Hue',
    minimum_value = 0,
    maximum_value = 360,
    value = 0,
    round_number = true,
    callback = function(value: number)
        if not getgenv().BallTrailRainbowEnabled then
            getgenv().BallTrailColor = Color3.fromHSV(value / 360, 1, 1)
        end
        getgenv().BallTrailHue = value
    end
})

ball_trail_module:create_checkbox({
    title = 'Rainbow Trail',
    flag = 'Ball_Trail_Rainbow',
    callback = function(value: boolean)
        getgenv().BallTrailRainbowEnabled = value
    end
})

ball_trail_module:create_checkbox({
    title = 'Particle Emitter',
    flag = 'Ball_Trail_Particle',
    callback = function(value: boolean)
        getgenv().BallTrailParticleEnabled = value
    end
})

ball_trail_module:create_checkbox({
    title = 'Glow Effect',
    flag = 'Ball_Trail_Glow',
    callback = function(value: boolean)
        getgenv().BallTrailGlowEnabled = value
    end
})

local function ensure_color_correction()
    local colorCorrection = Lighting:FindFirstChild('ColorCorrection')
    if not colorCorrection then
        colorCorrection = Instance.new('ColorCorrectionEffect')
        colorCorrection.Name = 'ColorCorrection'
        colorCorrection.Parent = Lighting
    end
    return colorCorrection
end

local function reset_filter_effects()
    local customAtmosphere = Lighting:FindFirstChild('CustomAtmosphere')
    if customAtmosphere then
        customAtmosphere:Destroy()
    end

    local colorCorrection = ensure_color_correction()
    colorCorrection.TintColor = Color3.new(1, 1, 1)
    colorCorrection.Saturation = 0
end

local function apply_filter_state()
    if not getgenv().FilterEnabled then
        reset_filter_effects()
        return
    end

    if getgenv().AtmosphereEnabled then
        local atmosphere = Lighting:FindFirstChild('CustomAtmosphere')
        if not atmosphere then
            atmosphere = Instance.new('Atmosphere')
            atmosphere.Name = 'CustomAtmosphere'
            atmosphere.Parent = Lighting
        end
        atmosphere.Density = getgenv().AtmosphereDensity or 0.5
    else
        local atmosphere = Lighting:FindFirstChild('CustomAtmosphere')
        if atmosphere then
            atmosphere:Destroy()
        end
    end

    local colorCorrection = ensure_color_correction()
    if getgenv().SaturationEnabled then
        colorCorrection.Saturation = getgenv().SaturationLevel or 0
    else
        colorCorrection.Saturation = 0
    end

    if getgenv().HueEnabled then
        colorCorrection.TintColor = Color3.fromHSV(getgenv().HueShift or 0, 1, 1)
    else
        colorCorrection.TintColor = Color3.new(1, 1, 1)
    end
end

local filter_module = WorldTab:create_module({
    title = 'Filter',
    flag = 'Filter',
    description = 'Toggles custom world filter effects',
    section = 'left',
    callback = function(value: boolean)
        getgenv().FilterEnabled = value
        apply_filter_state()
    end
})

filter_module:create_checkbox({
    title = 'Enable Atmosphere',
    flag = 'World_Filter_Atmosphere',
    callback = function(value: boolean)
        getgenv().AtmosphereEnabled = value
        apply_filter_state()
    end
})

filter_module:create_slider({
    title = 'Atmosphere Density',
    flag = 'World_Filter_Atmosphere_Slider',
    minimum_value = 0,
    maximum_value = 1,
    value = 0.5,
    callback = function(value: number)
        getgenv().AtmosphereDensity = value
        if getgenv().FilterEnabled then
            apply_filter_state()
        end
    end
})

filter_module:create_checkbox({
    title = 'Enable Saturation',
    flag = 'World_Filter_Saturation',
    callback = function(value: boolean)
        getgenv().SaturationEnabled = value
        apply_filter_state()
    end
})

filter_module:create_slider({
    title = 'Saturation Level',
    flag = 'World_Filter_Saturation_Slider',
    minimum_value = -1,
    maximum_value = 1,
    value = 0,
    callback = function(value: number)
        getgenv().SaturationLevel = value
        if getgenv().FilterEnabled then
            apply_filter_state()
        end
    end
})

filter_module:create_checkbox({
    title = 'Enable Hue',
    flag = 'World_Filter_Hue',
    callback = function(value: boolean)
        getgenv().HueEnabled = value
        apply_filter_state()
    end
})

filter_module:create_slider({
    title = 'Hue Shift',
    flag = 'World_Filter_Hue_Slider',
    minimum_value = -1,
    maximum_value = 1,
    value = 0,
    callback = function(value: number)
        getgenv().HueShift = value
        if getgenv().FilterEnabled then
            apply_filter_state()
        end
    end
})

local soundOptions = {
    Eeyuh = 'rbxassetid://16190782181',
    ['Sour Grapes'] = 'rbxassetid://117820392172291',
    Erwachen = 'rbxassetid://124853612881772',
    ['Grasp the Light'] = 'rbxassetid://89549155689397',
    ['Beyond the Shadows'] = 'rbxassetid://120729792529978',
    ['Rise to the Horizon'] = 'rbxassetid://72573266268313',
    ['Lo-fi Chill A'] = 'rbxassetid://9043887091',
    ['Lo-fi Ambient'] = 'rbxassetid://129775776987523',
    ['Tears in the Rain'] = 'rbxassetid://129710845038263'
}

local soundOptionNames = {
    'Eeyuh',
    'Sour Grapes',
    'Erwachen',
    'Grasp the Light',
    'Beyond the Shadows',
    'Rise to the Horizon',
    'Lo-fi Chill A',
    'Lo-fi Ambient',
    'Tears in the Rain'
}

getgenv().sound_controller = getgenv().sound_controller or false
getgenv().LoopSong = getgenv().LoopSong or false
getgenv().SoundControllerVolume = getgenv().SoundControllerVolume or 3
getgenv().SelectedSound = getgenv().SelectedSound or soundOptionNames[1]

local currentSound = Instance.new('Sound')
currentSound.Volume = getgenv().SoundControllerVolume or 3
currentSound.Looped = getgenv().LoopSong or false
currentSound.Parent = game:GetService('SoundService')

local selectedSound = getgenv().SelectedSound or soundOptionNames[1]

local function get_sound_id(optionName)
    if typeof(optionName) ~= 'string' then
        return soundOptions[selectedSound] or soundOptions.Eeyuh
    end

    local soundId = soundOptions[optionName]
    if soundId then
        return soundId
    end

    return soundOptions[selectedSound] or soundOptions.Eeyuh
end

local function play_sound_by_id(soundId)
    if not soundId then
        return
    end

    currentSound:Stop()
    currentSound.SoundId = soundId
    currentSound:Play()
end

local sound_controller_module = VisualsTab:create_module({
    title = 'Sound Controller',
    flag = 'sound_controller',
    description = 'Control background music and sounds',
    section = 'left',
    callback = function(value: boolean)
        getgenv().sound_controller = value
        if value then
            play_sound_by_id(get_sound_id(selectedSound))
        else
            currentSound:Stop()
        end
    end
})

sound_controller_module:create_checkbox({
    title = 'Loop Song',
    flag = 'LoopSong',
    callback = function(value: boolean)
        getgenv().LoopSong = value
        currentSound.Looped = value
    end
})

sound_controller_module:create_slider({
    title = 'Volume',
    flag = 'HitSoundVolume',
    minimum_value = 1,
    maximum_value = 10,
    value = getgenv().SoundControllerVolume or 3,
    callback = function(value: number)
        getgenv().SoundControllerVolume = value
        currentSound.Volume = value
    end
})

sound_controller_module:create_divider({})

sound_controller_module:create_dropdown({
    title = 'Select Sound',
    flag = 'sound_selection',
    options = soundOptionNames,
    multi_dropdown = false,
    maximum_options = #soundOptionNames,
    callback = function(value)
        getgenv().SelectedSound = value
        selectedSound = value
        if getgenv().sound_controller then
            play_sound_by_id(get_sound_id(value))
        end
    end
})

local ping_spoofer_connection = nil

local ping_spoofer_module = VisualsTab:create_module({
    title = 'Ping Spoofer',
    flag = 'ping_spoofer',
    description = 'Locks your Ping Display to a Fake Number',
    section = 'right',
    callback = function(state)
        if state then
            if not ping_spoofer_connection then
                ping_spoofer_connection = RunService.RenderStepped:Connect(function()
                    local fake_ping = tonumber(Library._config._flags.ping_text) or 999
                    fake_ping = tostring(math.floor(fake_ping))
                    local robloxGui = CoreGui:FindFirstChild('RobloxGui')
                    if not robloxGui then
                        return
                    end
                    local perfStats = robloxGui:FindFirstChild('PerformanceStats')
                    if perfStats then
                        for _, descendant in ipairs(perfStats:GetDescendants()) do
                            if descendant:IsA('TextLabel') and descendant.Text:match('%d+ ms') then
                                descendant.Text = fake_ping .. ' ms'
                            end
                        end
                    end
                end)
            end
        else
            if ping_spoofer_connection then
                ping_spoofer_connection:Disconnect()
                ping_spoofer_connection = nil
            end
            local robloxGui = CoreGui:FindFirstChild('RobloxGui')
            if robloxGui and robloxGui:FindFirstChild('FakePingLabel') then
                robloxGui.FakePingLabel:Destroy()
            end
        end
    end
})

ping_spoofer_module:create_textbox({
    title = 'Ping Value',
    placeholder = 'Enter Fake Ping Number',
    flag = 'ping_text',
    callback = function(value)
        local fake_ping = tonumber(value)
        if fake_ping and fake_ping >= 0 then
            Library._config._flags.ping_text = tostring(math.floor(fake_ping))
        end
    end
})

local System = {
    __properties = {
        __autoparry_enabled = false,
        __triggerbot_enabled = false,
        __manual_spam_enabled = false,
        __auto_spam_enabled = false,
        __curve_mode = 1,
        __accuracy = 1,
        __divisor_multiplier = 1.1,
        __parried = false,
        __training_parried = false,
        __spam_threshold = 1.5,
        __parries = 0,
        __parry_key = nil,
        __grab_animation = nil,
        __tornado_time = tick(),
        __first_parry_done = false,
        __connections = {},
        __reverted_remotes = {},
        __spam_accumulator = 0,
        __spam_rate = 1000,
        __infinity_active = false,
        __deathslash_active = false,
        __timehole_active = false,
        __slashesoffury_active = false,
        __slashesoffury_count = 0,
        __humanizer_enabled = false,
        __humanizer_min_accuracy = 1,
        __humanizer_max_accuracy = 50,
        __humanizer_last_update = 0,
        __humanizer_next_change = 0.8,
        __is_mobile = UserInputService.TouchEnabled and not UserInputService.MouseEnabled,
        __mobile_guis = {}
    },
    __config = {
        __curve_names = {'Camera', 'Random', 'Accelerated', 'Backwards', 'Slow', 'High', 'Left', 'Right'},
        __detections = {
            __infinity = false,
            __deathslash = false,
            __timehole = false,
            __slashesoffury = false,
            __phantom = false
        }
    },
    __triggerbot = {
        __enabled = false,
        __is_parrying = false,
        __parries = 0,
        __max_parries = 10000,
        __parry_delay = 0.5
    }
}

local revertedRemotes = {}
local Parry_Key = nil
local PF = nil
local SC = nil


local remote, f_raw = nil, nil
local c = {nil, nil, nil, nil, nil, nil, nil}
local remoteHooked = false
local function isValidRemoteArgs_wh(a)
    return #a >= 4 and typeof(a[4]) == "CFrame"
end
pcall(function()
    local hookfn = hookfunction or (getgenv and getgenv().hookfunction) or (getgenv and getgenv().hookfunc)
    local newcc = newcclosure or (getgenv and getgenv().newcclosure) or function(f) return f end
    if hookfn and newcc then
        pcall(function()
            local dE = Instance.new("RemoteEvent")
            local dF = Instance.new("RemoteFunction")
            local origFS
            origFS = hookfn(dE.FireServer, newcc(function(self, ...)
                local args = {...}
                if isValidRemoteArgs_wh(args) then
                    if not remoteHooked then
                        remoteHooked = true
                        remote = self
                        f_raw = origFS
                        for i = 1, 7 do c[i] = args[i] end
                    else
                        for i = 1, 7 do c[i] = args[i] end
                    end
                end
                local curveCF = System and System.curve and System.curve.get_cframe and System.curve.get_cframe()
                if curveCF then args[4] = curveCF end
                return origFS(self, unpack(args))
            end))
            local origIS
            origIS = hookfn(dF.InvokeServer, newcc(function(self, ...)
                local args = {...}
                if isValidRemoteArgs_wh(args) then
                    if not remoteHooked then
                        remoteHooked = true
                        remote = self
                        f_raw = origIS
                        for i = 1, 7 do c[i] = args[i] end
                    else
                        for i = 1, 7 do c[i] = args[i] end
                    end
                end
                local curveCF = System and System.curve and System.curve.get_cframe and System.curve.get_cframe()
                if curveCF then args[4] = curveCF end
                return origIS(self, unpack(args))
            end))
            getgenv()._hookUsedStr = "HookFunction (Deep Bypass)"
            
        end)
    end
end)

pcall(function()
    local mt = getrawmetatable(game)
    local old = mt.__index
    setreadonly(mt, false)
    mt.__index = function(self, key)
        if key == "FireServer" or key == "InvokeServer" then
            return function(instance, ...)
                local args = {...}
                if isValidRemoteArgs_wh(args) then
                    if not remoteHooked then
                        remoteHooked = true
                        remote = instance
                        f_raw = old(instance, "FireServer")
                        for i = 1, 7 do c[i] = args[i] end
                    else
                        for i = 1, 7 do c[i] = args[i] end
                    end
                end
                return old(self, key)(instance, ...)
            end
        end
        return old(self, key)
    end
    setreadonly(mt, true)
end)

local function fireParry_wh()
    if not _PARRY_PATCH or not _PARRY_PATCH.ready then return end
    local cam = workspace.CurrentCamera
    local char = LocalPlayer.Character
    if not char then return end
    local curveCF = (System.curve and System.curve.get_cframe and System.curve.get_cframe()) or cam.CFrame

    local screenPositions = {}
    if Alive then
        for _, entity in pairs(Alive:GetChildren()) do
            if entity.PrimaryPart then
                local ok, sp = pcall(function() return cam:WorldToScreenPoint(entity.PrimaryPart.Position) end)
                if ok then screenPositions[entity.Name] = sp end
            end
        end
    end

    local mouseLocation
    local success_mouse, mouse = pcall(function()
        return UserInputService:GetMouseLocation()
    end)
    if success_mouse and mouse then
        mouseLocation = {mouse.X, mouse.Y}
    else
        local vp = cam.ViewportSize
        mouseLocation = {vp.X/2, vp.Y/2}
    end

    _PARRY_PATCH.fire(curveCF, screenPositions, mouseLocation)
end

if ReplicatedStorage:FindFirstChild("Controllers") then
    for _, child in ipairs(ReplicatedStorage.Controllers:GetChildren()) do
        if child.Name:sub(1, 16) == "SwordsController" then
            SC = child
            break
        end
    end
end

local function update_divisor()
    
    System.__properties.__divisor_multiplier = 0.7 + (System.__properties.__accuracy - 1) * 0.0035353535353535
end

local function update_randomized_accuracy()
    if not System.__properties.__humanizer_enabled then return end

    local props = System.__properties
    local now = os.clock()

    if now < props.__humanizer_last_update + props.__humanizer_next_change then
        return
    end

    props.__humanizer_last_update = now

    local ping_str = Stats.Network.ServerStatsItem["Data Ping"]:GetValueString()
    local ping = tonumber(ping_str:match("%d+")) or 0

    local min_humanizer = math.clamp(props.__humanizer_min_accuracy, 1, 50)
    local max_humanizer = math.clamp(props.__humanizer_max_accuracy, 1, 50)
    if min_humanizer > max_humanizer then
        min_humanizer, max_humanizer = max_humanizer, min_humanizer
    end

    local current_accuracy = math.clamp(props.__accuracy, min_humanizer, max_humanizer)
    local range_span = math.max(1, max_humanizer - min_humanizer)
    local ping_factor = ping >= 90 and 0.75 or (ping <= 50 and 1.25 or 1)

    local weighted_roll = math.random(1, 100)
    local new_accuracy

    if ping >= 90 then
        new_accuracy = math.clamp(current_accuracy + math.random(-1, 1), min_humanizer, max_humanizer)
    elseif weighted_roll <= 45 then
        new_accuracy = math.clamp(current_accuracy + math.random(-2, 2), min_humanizer, max_humanizer)
    elseif weighted_roll <= 80 then
        local drift = math.random(2, math.max(3, math.floor(range_span * 0.2)))
        local direction = math.random() < 0.5 and -drift or drift
        new_accuracy = math.clamp(current_accuracy + direction, min_humanizer, max_humanizer)
    else
        new_accuracy = math.random(min_humanizer, max_humanizer)
    end

    if new_accuracy then
        props.__accuracy = new_accuracy
        props.__humanizer_next_change = math.random(0.7, 1.4) / ping_factor
        update_divisor()
    end
end

task.spawn(function()
    while task.wait(0.1) do
        if System.__properties.__humanizer_enabled then
            pcall(update_randomized_accuracy)
        end
    end
end)

local DualBypassSystem = {
    __properties = {
        __captured_data = nil,
        __first_parry_done = false,
        __test_bypass_enabled = true,
        __use_virtual_input_once = true,
        __virtual_input_used = false,
        __original_metatables = {},
        __active_hooks = {}
    }
}

function DualBypassSystem.isValidRemoteArgs(args)
    return #args == 7 and
        type(args[2]) == "string" and
        type(args[3]) == "number" and
        typeof(args[4]) == "CFrame" and
        type(args[5]) == "table" and
        type(args[6]) == "table" and
        type(args[7]) == "boolean"
end

function DualBypassSystem.hookRemote(remote)
    if not DualBypassSystem.__properties.__original_metatables[getrawmetatable(remote)] then
        DualBypassSystem.__properties.__original_metatables[getrawmetatable(remote)] = true
        local meta = getrawmetatable(remote)
        setreadonly(meta, false)

        local oldIndex = meta.__index
        meta.__index = function(self, key)
            if (key == "FireServer" and self:IsA("RemoteEvent")) or
               (key == "InvokeServer" and self:IsA("RemoteFunction")) then
                return function(obj, ...)
                    local args = {...}
                    if DualBypassSystem.isValidRemoteArgs(args) and not DualBypassSystem.__properties.__captured_data then
                        DualBypassSystem.__properties.__captured_data = {
                            remote = obj,
                            args = args
                        }
                    end
                    if DualBypassSystem.isValidRemoteArgs(args) and not revertedRemotes[obj] then
                        revertedRemotes[obj] = args
                        Parry_Key = args[2]
                    end
                    return oldIndex(self, key)(obj, unpack(args))
                end
            end
            return oldIndex(self, key)
        end
        setreadonly(meta, true)
    end
end

for _, remote in pairs(ReplicatedStorage:GetChildren()) do
    if remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction") then
        DualBypassSystem.hookRemote(remote)
    end
end

ReplicatedStorage.ChildAdded:Connect(function(child)
    if child:IsA("RemoteEvent") or child:IsA("RemoteFunction") then
        DualBypassSystem.hookRemote(child)
    end
end)

function DualBypassSystem.execute_test_bypass()
    if not DualBypassSystem.__properties.__captured_data or not DualBypassSystem.__properties.__test_bypass_enabled then
        return
    end
    local captured = DualBypassSystem.__properties.__captured_data
    local remote = captured.remote
    local original_args = captured.args
    local camera = workspace.CurrentCamera
    local event_data = {}
    if Alive then
        for _, entity in pairs(Alive:GetChildren()) do
            if entity.PrimaryPart then
                local success, screen_point = pcall(function()
                    return camera:WorldToScreenPoint(entity.PrimaryPart.Position)
                end)
                if success then
                    event_data[entity.Name] = screen_point
                end
            end
        end
    end
    local is_mobile = UserInputService.TouchEnabled and not UserInputService.MouseEnabled
    local final_aim_target
    if is_mobile then
        local viewport = camera.ViewportSize
        final_aim_target = {viewport.X / 2, viewport.Y / 2}
    else
        local success, mouse = pcall(function()
            return UserInputService:GetMouseLocation()
        end)
        if success then
            final_aim_target = {mouse.X, mouse.Y}
        else
            final_aim_target = {0, 0}
        end
    end
    local modified_args = {
        original_args[1],
        original_args[2],
        original_args[3],
        camera.CFrame,
        event_data,
        final_aim_target,
        original_args[7]
    }
    pcall(function()
        if remote:IsA('RemoteEvent') then
            remote:FireServer(unpack(modified_args))
        elseif remote:IsA('RemoteFunction') then
            remote:InvokeServer(unpack(modified_args))
        end
    end)
end

System.animation = {}

function System.animation.play_grab_parry()
    
    return
end

System.ball = {}

function System.ball.get()
    local balls = workspace:FindFirstChild('Balls')
    if not balls then return nil end
    for _, ball in pairs(balls:GetChildren()) do
        if ball:GetAttribute('realBall') then
            ball.CanCollide = false
            return ball
        end
    end
    return nil
end

function System.ball.get_all()
    local balls_table = {}
    local balls = workspace:FindFirstChild('Balls')
    if not balls then return balls_table end
    for _, ball in pairs(balls:GetChildren()) do
        if ball:GetAttribute('realBall') then
            ball.CanCollide = false
            table.insert(balls_table, ball)
        end
    end
    return balls_table
end

System.player = {}

local Closest_Entity = nil

function System.player.get_closest()
    local max_distance = math.huge
    local closest_entity = nil
    if not Alive then return nil end
    for _, entity in pairs(Alive:GetChildren()) do
        if entity ~= LocalPlayer.Character then
            if entity.PrimaryPart then
                local distance = LocalPlayer:DistanceFromCharacter(entity.PrimaryPart.Position)
                if distance < max_distance then
                    max_distance = distance
                    closest_entity = entity
                end
            end
        end
    end
    Closest_Entity = closest_entity
    return closest_entity
end

function System.player.get_closest_to_cursor()
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild('HumanoidRootPart') then
        return nil
    end
    local closest_player = nil
    local minimal_dot = -math.huge
    local camera = workspace.CurrentCamera
    if not Alive then return nil end
    local success, mouse_location = pcall(function()
        return UserInputService:GetMouseLocation()
    end)
    if not success then return nil end
    local ray = camera:ScreenPointToRay(mouse_location.X, mouse_location.Y)
    local pointer = CFrame.lookAt(ray.Origin, ray.Origin + ray.Direction)
    for _, player in pairs(Alive:GetChildren()) do
        if player == LocalPlayer.Character then continue end
        if not player:FindFirstChild('HumanoidRootPart') then continue end
        local direction = (player.HumanoidRootPart.Position - camera.CFrame.Position).Unit
        local dot = pointer.LookVector:Dot(direction)
        if dot > minimal_dot then
            minimal_dot = dot
            closest_player = player
        end
    end
    return closest_player
end

System.curve = {}

function System.curve.get_cframe()
    local camera = workspace.CurrentCamera
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild('HumanoidRootPart')
    if not root then return camera.CFrame end
    local targetPart
    local closest = System.player.get_closest_to_cursor()
    if closest and closest:FindFirstChild('HumanoidRootPart') then
        targetPart = closest.HumanoidRootPart
    end
    local target_pos = targetPart and targetPart.Position or (root.Position + camera.CFrame.LookVector * 100)
    local curve_functions = {
        function() return camera.CFrame end,
        function()
            local direction = (target_pos - root.Position).Unit
            local random_offset
            local attempts = 0
            repeat
                random_offset = Vector3.new(
                    math.random(-4000, 4000),
                    math.random(-4000, 4000),
                    math.random(-4000, 4000)
                )
                local curve_direction = (target_pos + random_offset - root.Position).Unit
                local dot = direction:Dot(curve_direction)
                attempts = attempts + 1
            until dot < 0.95 or attempts > 10
            return CFrame.new(root.Position, target_pos + random_offset)
        end,
        function()
            return CFrame.new(root.Position, target_pos + Vector3.new(0, 5, 0))
        end,
        function()
            local direction = (root.Position - target_pos).Unit
            local backwards_pos = root.Position + direction * 10000 + Vector3.new(0, 1000, 0)
            return CFrame.new(camera.CFrame.Position, backwards_pos)
        end,
        function()
            return CFrame.new(root.Position, target_pos + Vector3.new(0, -9e18, 0))
        end,
        function()
            return CFrame.new(root.Position, target_pos + Vector3.new(0, 9e18, 0))
        end,
        
        function()
            local left_vec = -camera.CFrame.RightVector * 10000
            return CFrame.new(root.Position, root.Position + left_vec)
        end,
        
        function()
            local right_vec = camera.CFrame.RightVector * 10000
            return CFrame.new(root.Position, root.Position + right_vec)
        end
    }
    return curve_functions[System.__properties.__curve_mode]()
end

System.parry = {}

function System.parry.execute()
    if System.__properties.__parries > 10000 or not LocalPlayer.Character then
        return
    end
    if not _PARRY_PATCH or not _PARRY_PATCH.ready then
        return
    end
    local camera = workspace.CurrentCamera
    local success, mouse = pcall(function()
        return UserInputService:GetMouseLocation()
    end)
    if not success then return end
    local is_mobile = System.__properties.__is_mobile
    local screenPositions = {}
    if Alive then
        for _, entity in pairs(Alive:GetChildren()) do
            if entity.PrimaryPart then
                local ok2, sp = pcall(function()
                    return camera:WorldToScreenPoint(entity.PrimaryPart.Position)
                end)
                if ok2 then
                    screenPositions[entity.Name] = sp
                end
            end
        end
    end
    local curveCF = (System.curve and System.curve.get_cframe and System.curve.get_cframe()) or camera.CFrame
    local mouseLocation
    if is_mobile then
        local vp = camera.ViewportSize
        mouseLocation = {vp.X / 2, vp.Y / 2}
    else
        mouseLocation = {mouse.X, mouse.Y}
    end

    _PARRY_PATCH.fire(curveCF, screenPositions, mouseLocation)

    if System.__properties.__parries > 10000 then return end
    System.__properties.__parries = System.__properties.__parries + 1
    task.delay(0.5, function()
        if System.__properties.__parries > 0 then
            System.__properties.__parries = System.__properties.__parries - 1
        end
    end)
end

function System.parry.keypress()
    if System.__properties.__parries > 10000 or not LocalPlayer.Character then
        return
    end
    if PF then pcall(PF) end
    if System.__properties.__parries > 10000 then return end
    System.__properties.__parries = System.__properties.__parries + 1
    task.delay(0.5, function()
        if System.__properties.__parries > 0 then
            System.__properties.__parries = System.__properties.__parries - 1
        end
    end)
end

function System.parry.execute_action()
    System.animation.play_grab_parry()
    System.parry.execute()
end

local function linear_predict(a, b, time_volume)
    return a + (b - a) * time_volume
end

System.detection = {
    __ball_properties = {
        __aerodynamic_time = tick(),
        __last_warping = tick(),
        __lerp_radians = 0,
        __curving = tick()
    }
}

function System.detection.is_curved()
    local ball_properties = System.detection.__ball_properties
    local ball = System.ball.get()
    if not ball then return false end
    if not LocalPlayer.Character or not LocalPlayer.Character.PrimaryPart then return false end
    local zoomies = ball:FindFirstChild('zoomies')
    if not zoomies then return false end
    local velocity = zoomies.VectorVelocity or Vector3.new()
    local speed = velocity.Magnitude
    if speed == 0 then return false end
    local ball_direction = velocity.Unit
    local direction_vector = LocalPlayer.Character.PrimaryPart.Position - ball.Position
    if direction_vector.Magnitude == 0 then return false end
    local direction = direction_vector.Unit
    local dot = direction:Dot(ball_direction)
    local speed_threshold = math.min(speed / 100, 40)
    local direction_difference = ball_direction - velocity
    local direction_similarity = 0
    if direction_difference.Magnitude > 0 then
        direction_similarity = direction:Dot(direction_difference.Unit)
    end
    local dot_difference = dot - direction_similarity
    local distance = (LocalPlayer.Character.PrimaryPart.Position - ball.Position).Magnitude
    local ping = Stats.Network.ServerStatsItem['Data Ping']:GetValue()
    local dot_threshold = 0.5 - (ping / 1000)
    local reach_time = distance / speed - (ping / 1000)
    local ball_distance_threshold = 15 - math.min(distance / 1000, 15) + speed_threshold
    local clamped_dot = math.clamp(dot, -1, 1)
    local radians = math.rad(math.asin(clamped_dot))
    ball_properties.__lerp_radians = linear_predict(ball_properties.__lerp_radians, radians, 0.8)
    if speed > 0 and reach_time > ping / 10 then
        ball_distance_threshold = math.max(ball_distance_threshold - 15, 15)
    end
    if distance < ball_distance_threshold then return false end
    if dot_difference < dot_threshold then return true end
    if ball_properties.__lerp_radians < 0.018 then
        ball_properties.__last_warping = tick()
    end
    if (tick() - ball_properties.__last_warping) < (reach_time / 1.5) then
        return true
    end
    if (tick() - ball_properties.__curving) < (reach_time / 1.5) then
        return true
    end
    return dot < dot_threshold
end

ReplicatedStorage.Remotes.DeathBall.OnClientEvent:Connect(function(c, d)
    System.__properties.__deathslash_active = d or false
end)

ReplicatedStorage.Remotes.InfinityBall.OnClientEvent:Connect(function(a, b)
    System.__properties.__infinity_active = b or false
end)

ReplicatedStorage.Packages._Index["sleitnick_net@0.1.0"].net["RE/TimeHoleActivate"].OnClientEvent:Connect(function(...)
    local args = {...}
    local player = args[1]
    if player == LocalPlayer or player == LocalPlayer.Name or (player and player.Name == LocalPlayer.Name) then
        System.__properties.__timehole_active = true
    end
end)

ReplicatedStorage.Packages._Index["sleitnick_net@0.1.0"].net["RE/TimeHoleDeactivate"].OnClientEvent:Connect(function()
    System.__properties.__timehole_active = false
end)

ReplicatedStorage.Packages._Index["sleitnick_net@0.1.0"].net["RE/SlashesOfFuryActivate"].OnClientEvent:Connect(function(...)
    local args = {...}
    local player = args[1]
    if player == LocalPlayer or player == LocalPlayer.Name or (player and player.Name == LocalPlayer.Name) then
        System.__properties.__slashesoffury_active = true
        System.__properties.__slashesoffury_count = 0
    end
end)

ReplicatedStorage.Packages._Index["sleitnick_net@0.1.0"].net["RE/SlashesOfFuryEnd"].OnClientEvent:Connect(function()
    System.__properties.__slashesoffury_active = false
    System.__properties.__slashesoffury_count = 0
end)

ReplicatedStorage.Packages._Index["sleitnick_net@0.1.0"].net["RE/SlashesOfFuryParry"].OnClientEvent:Connect(function()
    System.__properties.__slashesoffury_count = System.__properties.__slashesoffury_count + 1
end)

ReplicatedStorage.Packages._Index["sleitnick_net@0.1.0"].net["RE/SlashesOfFuryCatch"].OnClientEvent:Connect(function()
    spawn(function()
        while System.__properties.__slashesoffury_active and System.__properties.__slashesoffury_count < maxParryCount do
            if System.__config.__detections.__slashesoffury then
                System.parry.execute()
                task.wait(parryDelay)
            else
                break
            end
        end
    end)
end)

Runtime.ChildAdded:Connect(function(Object)
    if System.__config.__detections.__phantom then
        if Object.Name == "maxTransmission" or Object.Name == "transmissionpart" then
            local Weld = Object:FindFirstChildWhichIsA("WeldConstraint")
            if Weld then
                local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                if Character and Weld.Part1 == Character.HumanoidRootPart then
                    local CurrentBall = System.ball.get()
                    Weld:Destroy()
                    if CurrentBall then
                        local FocusConnection
                        FocusConnection = RunService.RenderStepped:Connect(function()
                            local Highlighted = CurrentBall:GetAttribute("highlighted")
                            if Highlighted == true then
                                ReplicatedStorage.Remotes.AbilityButtonPress:Fire()
                                System.__properties.__parried = true
                                task.delay(1, function()
                                    System.__properties.__parried = false
                                end)
                            elseif Highlighted == false then
                                FocusConnection:Disconnect()
                            end
                        end)
                        task.delay(3, function()
                            if FocusConnection and FocusConnection.Connected then
                                FocusConnection:Disconnect()
                            end
                        end)
                    end
                end
            end
        end
    end
end)

ReplicatedStorage.Remotes.ParrySuccessAll.OnClientEvent:Connect(function(_, root)
    if root.Parent and root.Parent ~= LocalPlayer.Character then
        if not Alive or root.Parent.Parent ~= Alive then
            return
        end
    end
    if not LocalPlayer.Character or not LocalPlayer.Character.PrimaryPart then
        return
    end
    local closest = System.player.get_closest()
    local ball = System.ball.get()
    if not ball or not closest or not closest.PrimaryPart then return end
    local target_distance = (LocalPlayer.Character.PrimaryPart.Position - closest.PrimaryPart.Position).Magnitude
    local direction_vector = LocalPlayer.Character.PrimaryPart.Position - ball.Position
    if direction_vector.Magnitude == 0 then return end
    local distance = direction_vector.Magnitude
    local direction = direction_vector.Unit
    local ball_velocity = ball.AssemblyLinearVelocity or Vector3.new()
    if ball_velocity.Magnitude == 0 then return end
    local dot = direction:Dot(ball_velocity.Unit)
    local curve_detected = System.detection.is_curved()
    if target_distance < 15 and distance < 15 and dot > -0.25 then
        if curve_detected then
            System.parry.execute_action()
        end
    end
    if System.__properties.__grab_animation then
        System.__properties.__grab_animation:Stop()
    end
end)




task.spawn(function()
    while task.wait(0.5) do
        local enabled = false
        if System and System.__config and System.__config.__detections then
            enabled = System.__config.__detections.__dribble or getgenv().DribbleDetection
        else
            enabled = getgenv().DribbleDetection
        end
        if not enabled then
            if System and System.__properties then System.__properties.__dribble_active = false end
            continue
        end

        local found = false
        local balls = workspace:FindFirstChild('Balls')
        if balls then
            for _, ball in pairs(balls:GetChildren()) do
                if not ball then continue end
                
                local ok = false
                pcall(function()
                    if ball:GetAttribute (ball:GetAttribute('dribble') or ball:GetAttribute('Dribble')) then
                        ok = true
                    end
                end)
                if not ok then
                    if ball.Name and string.find(ball.Name:lower(), 'dribble') then ok = true end
                end
                if not ok then
                    if ball:FindFirstChild('Dribble') or ball:FindFirstChild('Dribbling') then ok = true end
                end
                if ok then
                    found = true
                    break
                end
            end
        end
        if System and System.__properties then
            System.__properties.__dribble_active = found
        end
    end
end)


getgenv().AutoParryMode = getgenv().AutoParryMode or "Remote"
getgenv().AutoParryNotify = getgenv().AutoParryNotify or false
getgenv().CooldownProtection = getgenv().CooldownProtection or false
getgenv().AutoAbility = getgenv().AutoAbility or false
getgenv().TriggerbotNotify = getgenv().TriggerbotNotify or false
getgenv().InfinityNotify = getgenv().InfinityNotify or false
getgenv().ManualSpamNotify = getgenv().ManualSpamNotify or false
getgenv().ManualSpamAnimationFix = getgenv().ManualSpamAnimationFix or false
getgenv().ManualSpamCPSEnabled = getgenv().ManualSpamCPSEnabled or false
getgenv().ManualSpamCPS = getgenv().ManualSpamCPS or 1
getgenv().AutoSpamNotify = getgenv().AutoSpamNotify or false
getgenv().AutoSpamMode = getgenv().AutoSpamMode or "Remote"
getgenv().AutoSpamAnimationFix = getgenv().AutoSpamAnimationFix or false
getgenv().AutoStop = getgenv().AutoStop or false
getgenv().CameraEnabled = getgenv().CameraEnabled or false
getgenv().CameraFOV = getgenv().CameraFOV or 70
getgenv().AutoVote = getgenv().AutoVote or false
getgenv().DribbleDetection = getgenv().DribbleDetection or false


local maxParryCount = 36
local parryDelay = 0.05
 
System.triggerbot = {}

function System.triggerbot.trigger(ball)
    if System.__triggerbot.__is_parrying or System.__triggerbot.__parries > System.__triggerbot.__max_parries then
        return
    end
    if LocalPlayer.Character and LocalPlayer.Character.PrimaryPart and 
       LocalPlayer.Character.PrimaryPart:FindFirstChild('SingularityCape') then
        return
    end
    System.__triggerbot.__is_parrying = true
    System.__triggerbot.__parries = System.__triggerbot.__parries + 1
    System.animation.play_grab_parry()
    System.parry.execute()
    task.delay(System.__triggerbot.__parry_delay, function()
        if System.__triggerbot.__parries > 0 then
            System.__triggerbot.__parries = System.__triggerbot.__parries - 1
        end
    end)
    local connection
    connection = ball:GetAttributeChangedSignal('target'):Once(function()
        System.__triggerbot.__is_parrying = false
        if connection then
            connection:Disconnect()
        end
    end)
    task.spawn(function()
        local start_time = tick()
        repeat
            RunService.Heartbeat:Wait()
        until (tick() - start_time >= 1 or not System.__triggerbot.__is_parrying)
        System.__triggerbot.__is_parrying = false
    end)
end

function System.triggerbot.loop()
    if not System.__triggerbot.__enabled then return end
    if LocalPlayer.Character and LocalPlayer.Character.PrimaryPart and 
       LocalPlayer.Character.PrimaryPart:FindFirstChild('SingularityCape') then
        return
    end
    local balls = workspace:FindFirstChild('Balls')
    if not balls then return end
    for _, ball in pairs(balls:GetChildren()) do
        if ball:IsA('BasePart') and ball:GetAttribute('target') == LocalPlayer.Name then
            System.triggerbot.trigger(ball)
            break
        end
    end
end

function System.triggerbot.enable(enabled)
    System.__triggerbot.__enabled = enabled
    if enabled then
        if not System.__properties.__connections.__triggerbot then
            System.__properties.__connections.__triggerbot = RunService.Heartbeat:Connect(System.triggerbot.loop)
        end
    else
        if System.__properties.__connections.__triggerbot then
            System.__properties.__connections.__triggerbot:Disconnect()
            System.__properties.__connections.__triggerbot = nil
        end
        System.__triggerbot.__is_parrying = false
        System.__triggerbot.__parries = 0
    end
end

local function get_manual_spam_interval()
    local cps = math.clamp(getgenv().ManualSpamCPS or 200, 1, 2000)
    if System and System.__properties and System.__properties.__is_mobile then
        cps = math.clamp(cps, 5, 60)
    end
    return 1 / cps
end

System.manual_spam = {}

function System.manual_spam.loop(delta)
    if not System.__properties.__manual_spam_enabled then return end
    if not LocalPlayer.Character or LocalPlayer.Character.Parent ~= Alive then return end
    if getgenv().spamui then return end

    System.__properties.__spam_accumulator = (System.__properties.__spam_accumulator or 0) + delta
    local interval
    if getgenv().ManualSpamCPSEnabled then
        interval = get_manual_spam_interval()
    else
        interval = 1 / math.max(1, System.__properties.__spam_rate or 100)
    end
    if (System.__properties.__spam_accumulator or 0) < interval then
        return
    end

    System.__properties.__spam_accumulator = 0
    System.parry.execute()
    if getgenv().ManualSpamAnimationFix and PF then
        PF()
    end
end

function System.manual_spam.start()
    if System.__properties.__connections.__manual_spam then
        System.__properties.__connections.__manual_spam:Disconnect()
    end
    System.__properties.__manual_spam_enabled = true
    System.__properties.__connections.__manual_spam = RunService.Heartbeat:Connect(System.manual_spam.loop)
end

function System.manual_spam.stop()
    System.__properties.__manual_spam_enabled = false
    if System.__properties.__connections.__manual_spam then
        System.__properties.__connections.__manual_spam:Disconnect()
        System.__properties.__connections.__manual_spam = nil
    end
end

System.auto_spam = {}

function System.auto_spam:get_entity_properties()
    System.player.get_closest()
    if not Closest_Entity or not Closest_Entity.PrimaryPart then return false end
    if not LocalPlayer.Character or not LocalPlayer.Character.PrimaryPart then return false end
    local entity_velocity = Closest_Entity.PrimaryPart.Velocity
    local entity_direction = (LocalPlayer.Character.PrimaryPart.Position - Closest_Entity.PrimaryPart.Position).Unit
    local entity_distance = (LocalPlayer.Character.PrimaryPart.Position - Closest_Entity.PrimaryPart.Position).Magnitude
    return {
        Velocity = entity_velocity,
        Direction = entity_direction,
        Distance = entity_distance
    }
end

function System.auto_spam:get_ball_properties()
    local ball = System.ball.get()
    if not ball then return false end
    if not LocalPlayer.Character or not LocalPlayer.Character.PrimaryPart then return false end
    local ball_velocity = ball.AssemblyLinearVelocity or Vector3.new()
    local ball_origin = ball
    local ball_direction_vector = LocalPlayer.Character.PrimaryPart.Position - ball_origin.Position
    local ball_distance = ball_direction_vector.Magnitude
    local ball_direction = Vector3.new()
    local ball_dot = 0
    if ball_distance > 0 then
        ball_direction = ball_direction_vector.Unit
        if ball_velocity.Magnitude > 0 then
            ball_dot = ball_direction:Dot(ball_velocity.Unit)
        end
    end
    return {
        Velocity = ball_velocity,
        Direction = ball_direction,
        Distance = ball_distance,
        Dot = ball_dot
    }
end

function System.auto_spam.spam_service(self)
    
    local ball = System.ball.get()
    local entity = System.player.get_closest()
    if not ball or not entity or not entity.PrimaryPart then
        return false
    end
    if not LocalPlayer.Character or not LocalPlayer.Character.PrimaryPart then
        return false
    end

    
    local D = 5

    local velocity = ball.AssemblyLinearVelocity or Vector3.new()
    local n = velocity.Magnitude
    if n == 0 then
        return D
    end

    local to_ball = (LocalPlayer.Character.PrimaryPart.Position - ball.Position)
    if to_ball.Magnitude == 0 then
        return D
    end

    local r = to_ball.Unit
    local t = 0
    if n > 0 and velocity.Magnitude > 0 then
        t = r:Dot(velocity.Unit)
    end

    local target_pos = entity.PrimaryPart.Position
    local X = LocalPlayer:DistanceFromCharacter(target_pos)

    local E = 1
    local Fmove = Vector3.new()
    local success, humanoid = pcall(function()
        return LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass('Humanoid')
    end)
    if success and humanoid and humanoid.MoveDirection then
        Fmove = humanoid.MoveDirection
    end

    local N = (target_pos - LocalPlayer.Character.PrimaryPart.Position)
    if N.Magnitude > 0 then N = N.Unit else N = Vector3.new() end
    local lmove = Vector3.new()
    if entity then
        local ehum = entity:FindFirstChildOfClass('Humanoid')
        if ehum and ehum.MoveDirection then lmove = ehum.MoveDirection end
    end

    
    _G.Last_Close_Contact = _G.Last_Close_Contact or 0
    _G.In_Close_Contact = _G.In_Close_Contact or false
    local now = tick()
    if X <= 3 then
        _G.In_Close_Contact = true
    end
    if _G.In_Close_Contact and X > 3.3 then
        _G.In_Close_Contact = false
        _G.Last_Close_Contact = now
    end
    local u = (not _G.In_Close_Contact) and (now - (_G.Last_Close_Contact or 0) >= 1.5)
    if u and (Fmove.Magnitude > 0.2 and Fmove:Dot(N) < -0.4) then
        E = 10
    end
    if u and (lmove.Magnitude > 0.2 and lmove:Dot(-N) < -0.4) then
        E = 10
    end

    
    local B = (self.Ping or 50) * 0.7 + math.min(n / (E * 1.2), 80)

    
    if (self.Entity_Properties and self.Entity_Properties.Distance or math.huge) > B then
        return D
    end
    if (self.Ball_Properties and self.Ball_Properties.Distance or math.huge) > B then
        return D
    end
    if X > B then
        return D
    end

    local U = math.clamp(-t, 0, 1)
    local q = math.clamp(U * (n / 40), 0, 4)
    D = B - q
    return D
end

function System.auto_spam.start()
    if System.__properties.__connections.__auto_spam then
        System.__properties.__connections.__auto_spam:Disconnect()
    end
    System.__properties.__auto_spam_enabled = true
    System.__properties.__connections.__auto_spam = RunService.PreSimulation:Connect(function()
        local ball = System.ball.get()
        if not ball then return end
        if System.__properties.__slashesoffury_active then return end
        local zoomies = ball:FindFirstChild('zoomies')
        if not zoomies then return end
        System.player.get_closest()
        local ping = Stats.Network.ServerStatsItem['Data Ping']:GetValue()
        local ping_threshold = math.clamp(ping / 10, 1, 16)
        local ball_target = ball:GetAttribute('target')
        local ball_properties = System.auto_spam:get_ball_properties()
        local entity_properties = System.auto_spam:get_entity_properties()
        if not ball_properties or not entity_properties then return end
        local spam_accuracy = System.auto_spam.spam_service({
            Ball_Properties = ball_properties,
            Entity_Properties = entity_properties,
            Ping = ping_threshold
        })
        local target_position = Closest_Entity.PrimaryPart.Position
        local target_distance = LocalPlayer:DistanceFromCharacter(target_position)
        if zoomies.VectorVelocity.Magnitude == 0 then return end
        local direction = (LocalPlayer.Character.PrimaryPart.Position - ball.Position).Unit
        local ball_direction = zoomies.VectorVelocity.Unit
        local dot = direction:Dot(ball_direction)
        local distance = LocalPlayer:DistanceFromCharacter(ball.Position)
        if not ball_target then return end
        if target_distance > spam_accuracy or distance > spam_accuracy then return end
        local pulsed = LocalPlayer.Character:GetAttribute('Pulsed')
        if pulsed then return end
        if ball_target == LocalPlayer.Name and target_distance > 30 and distance > 30 then return end
        if distance <= spam_accuracy and System.__properties.__parries > System.__properties.__spam_threshold then
            if getgenv().AutoSpamMode == "Keypress" then
                if PF then PF() end
            else
                System.parry.execute()
                if getgenv().AutoSpamAnimationFix and PF then
                    PF()
                end
            end
        end
    end)
end

function System.auto_spam.stop()
    System.__properties.__auto_spam_enabled = false
    if System.__properties.__connections.__auto_spam then
        System.__properties.__connections.__auto_spam:Disconnect()
        System.__properties.__connections.__auto_spam = nil
    end
end

System.autoparry = {}

function System.autoparry.start()
    if System.__properties.__connections.__autoparry then
        System.__properties.__connections.__autoparry:Disconnect()
    end
    System.__properties.__connections.__autoparry = RunService.PreSimulation:Connect(function()
        if not System.__properties.__autoparry_enabled or not LocalPlayer.Character or 
           not LocalPlayer.Character.PrimaryPart then
            return
        end
        local balls = System.ball.get_all()
        local one_ball = System.ball.get()
        local training_ball = nil
        if workspace:FindFirstChild("TrainingBalls") then
            for _, Instance in pairs(workspace.TrainingBalls:GetChildren()) do
                if Instance:GetAttribute("realBall") then
                    training_ball = Instance
                    break
                end
            end
        end
        for _, ball in pairs(balls) do
            if System.__triggerbot.__enabled then return end
            if getgenv().BallVelocityAbove800 then return end
            if not ball then continue end
            local zoomies = ball:FindFirstChild('zoomies')
            if not zoomies then continue end
            ball:GetAttributeChangedSignal('target'):Once(function()
                System.__properties.__parried = false
            end)
            if System.__properties.__parried then continue end
            local ball_target = ball:GetAttribute('target')
            local velocity = zoomies.VectorVelocity
            local distance = (LocalPlayer.Character.PrimaryPart.Position - ball.Position).Magnitude
            local ping = Stats.Network.ServerStatsItem['Data Ping']:GetValue() / 10
            local ping_threshold = math.clamp(ping / 10, 5, 17)
            local speed = velocity.Magnitude
            local capped_speed_diff = math.min(math.max(speed - 9.5, 0), 650)
            local speed_divisor = (2.4 + capped_speed_diff * 0.002) * System.__properties.__divisor_multiplier
            local parry_accuracy = ping_threshold + math.max(speed / speed_divisor, 9.5)
            local curved = System.detection.is_curved()
            if ball:FindFirstChild('AeroDynamicSlashVFX') then
                ball.AeroDynamicSlashVFX:Destroy()
                System.__properties.__tornado_time = tick()
            end
            if Runtime:FindFirstChild('Tornado') then
                if (tick() - System.__properties.__tornado_time) < 
                   (Runtime.Tornado:GetAttribute('TornadoTime') or 1) + 0.314159 then
                    continue
                end
            end
            if one_ball and one_ball:GetAttribute('target') == LocalPlayer.Name and curved then
                continue
            end
            if ball:FindFirstChild('ComboCounter') then continue end
            if LocalPlayer.Character.PrimaryPart:FindFirstChild('SingularityCape') then continue end
            if System.__config.__detections.__infinity and System.__properties.__infinity_active then continue end
            if System.__config.__detections.__deathslash and System.__properties.__deathslash_active then continue end
            if System.__config.__detections.__timehole and System.__properties.__timehole_active then continue end
            if System.__config.__detections.__slashesoffury and System.__properties.__slashesoffury_active then continue end
            if ball_target == LocalPlayer.Name and distance <= parry_accuracy then
                if getgenv().CooldownProtection then
                    local ParryCD = LocalPlayer.PlayerGui.Hotbar.Block.UIGradient
                    if ParryCD.Offset.Y < 0.4 then
                        ReplicatedStorage.Remotes.AbilityButtonPress:Fire()
                        continue
                    end
                end
                if getgenv().AutoAbility then
                    local AbilityCD = LocalPlayer.PlayerGui.Hotbar.Ability.UIGradient
                    if AbilityCD.Offset.Y == 0.5 then
                        if LocalPlayer.Character.Abilities:FindFirstChild("Raging Deflection") and LocalPlayer.Character.Abilities["Raging Deflection"].Enabled or
                           LocalPlayer.Character.Abilities:FindFirstChild("Rapture") and LocalPlayer.Character.Abilities["Rapture"].Enabled or
                           LocalPlayer.Character.Abilities:FindFirstChild("Calming Deflection") and LocalPlayer.Character.Abilities["Calming Deflection"].Enabled or
                           LocalPlayer.Character.Abilities:FindFirstChild("Aerodynamic Slash") and LocalPlayer.Character.Abilities["Aerodynamic Slash"].Enabled or
                           LocalPlayer.Character.Abilities:FindFirstChild("Fracture") and LocalPlayer.Character.Abilities["Fracture"].Enabled or
                           LocalPlayer.Character.Abilities:FindFirstChild("Death Slash") and LocalPlayer.Character.Abilities["Death Slash"].Enabled then
                            System.__properties.__parried = true
                            ReplicatedStorage.Remotes.AbilityButtonPress:Fire()
                            task.wait(2.432)
                            ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("DeathSlashShootActivation"):FireServer(true)
                            continue
                        end
                    end
                end
            end
            if ball_target == LocalPlayer.Name and distance <= parry_accuracy then
                if getgenv().AutoParryMode == "Keypress" then
                    System.parry.keypress()
                else
                    System.parry.execute_action()
                end
                System.__properties.__parried = true
            end
            local last_parrys = tick()
            repeat
                RunService.Stepped:Wait()
            until (tick() - last_parrys) >= 1 or not System.__properties.__parried
            System.__properties.__parried = false
        end
        if training_ball then
            local zoomies = training_ball:FindFirstChild('zoomies')
            if zoomies then
                training_ball:GetAttributeChangedSignal('target'):Once(function()
                    System.__properties.__training_parried = false
                end)
                if not System.__properties.__training_parried then
                    local ball_target = training_ball:GetAttribute('target')
                    local velocity = zoomies.VectorVelocity
                    local distance = LocalPlayer:DistanceFromCharacter(training_ball.Position)
                    local speed = velocity.Magnitude
                    local ping = Stats.Network.ServerStatsItem['Data Ping']:GetValue() / 10
                    local ping_threshold = math.clamp(ping / 10, 5, 17)
                    local capped_speed_diff = math.min(math.max(speed - 9.5, 0), 650)
                    local speed_divisor = (2.4 + capped_speed_diff * 0.002) * System.__properties.__divisor_multiplier
                    local parry_accuracy = ping_threshold + math.max(speed / speed_divisor, 9.5)
                    if ball_target == LocalPlayer.Name and distance <= parry_accuracy then
                        if getgenv().AutoParryMode == "Keypress" then
                            System.parry.keypress()
                        else
                            System.parry.execute_action()
                        end
                        System.__properties.__training_parried = true
                        local last_parrys = tick()
                        repeat
                            RunService.Stepped:Wait()
                        until (tick() - last_parrys) >= 1 or not System.__properties.__training_parried
                        System.__properties.__training_parried = false
                    end
                end
            end
        end
    end)
end

function System.autoparry.stop()
    if System.__properties.__connections.__autoparry then
        System.__properties.__connections.__autoparry:Disconnect()
        System.__properties.__connections.__autoparry = nil
    end
end


local function send_notification(title, text, duration)
    pcall(function()
        if Library and Library.SendNotification then
            Library.SendNotification({
                title = title,
                text = text,
                duration = duration or 2
            })
        end
    end)
end

local manual_spam_warning_confirmed = false
local manual_spam_warning_active = false
local manual_spam_cps_slider = nil

local function destroy_manual_spam_warning_gui(gui)
    if not (gui and gui.Parent) then
        manual_spam_warning_active = false
        return
    end

    local background = gui:FindFirstChildWhichIsA('Frame')
    local card = background and background:FindFirstChildWhichIsA('Frame')
    local tweenInfo = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

    if background then
        TweenService:Create(background, tweenInfo, {BackgroundTransparency = 1}):Play()
    end
    if card then
        TweenService:Create(card, tweenInfo, {BackgroundTransparency = 1, Position = UDim2.new(0.5, 0, 0.45, 0)}):Play()
    end

    delay(0.18, function()
        if gui and gui.Parent then
            gui:Destroy()
        end
        manual_spam_warning_active = false
    end)
end

local function show_manual_spam_warning_modal()
    if manual_spam_warning_active then
        return
    end

    manual_spam_warning_active = true

    local gui = Instance.new('ScreenGui')
    gui.Name = 'AzureManualSpamWarning'
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.DisplayOrder = 50
    gui.Parent = CoreGui

    local background = Instance.new('Frame')
    background.Size = UDim2.new(1, 0, 1, 0)
    background.Position = UDim2.new(0, 0, 0, 0)
    background.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    background.BackgroundTransparency = 1
    background.BorderSizePixel = 0
    background.Parent = gui

    local card = Instance.new('Frame')
    card.Size = UDim2.new(0, 320, 0, 180)
    card.Position = UDim2.new(0.5, 0, 0.45, 0)
    card.AnchorPoint = Vector2.new(0.5, 0.5)
    card.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    card.BackgroundTransparency = 1
    card.BorderSizePixel = 0
    card.Parent = background

    local modalTweenInfo = TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    TweenService:Create(background, modalTweenInfo, {BackgroundTransparency = 0.8}):Play()
    TweenService:Create(card, modalTweenInfo, {BackgroundTransparency = 0, Position = UDim2.new(0.5, 0, 0.47, 0)}):Play()

    local cardCorner = Instance.new('UICorner')
    cardCorner.CornerRadius = UDim.new(0, 20)
    cardCorner.Parent = card

    local cardStroke = Instance.new('UIStroke')
    cardStroke.Color = Color3.fromRGB(70, 70, 80)
    cardStroke.Transparency = 0.75
    cardStroke.Thickness = 1
    cardStroke.Parent = card

    local title = Instance.new('TextLabel')
    title.Size = UDim2.new(1, -32, 0, 24)
    title.Position = UDim2.new(0, 16, 0, 20)
    title.BackgroundTransparency = 1
    title.Text = 'WARNING FOR MOBILE USER!'
    title.Font = Enum.Font.GothamBold
    title.TextSize = 18
    title.TextColor3 = Color3.fromRGB(245, 245, 245)
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = card

    local message = Instance.new('TextLabel')
    message.Size = UDim2.new(1, -32, 0, 78)
    message.Position = UDim2.new(0, 16, 0, 64)
    message.BackgroundTransparency = 1
    message.Text = 'YOUR MANUAL SPAM CPS IS ABOVE 300. THIS MAY CAUSE LAG ON DEVICE PERFORMANCE. CONTINUE OR GO BACK TO 300 CPS.'
    message.Font = Enum.Font.GothamSemibold
    message.TextSize = 13
    message.TextColor3 = Color3.fromRGB(220, 220, 220)
    message.TextWrapped = true
    message.TextXAlignment = Enum.TextXAlignment.Left
    message.TextYAlignment = Enum.TextYAlignment.Top
    message.Parent = card

    local buttonFrame = Instance.new('Frame')
    buttonFrame.Size = UDim2.new(1, -32, 0, 40)
    buttonFrame.Position = UDim2.new(0, 16, 1, -54)
    buttonFrame.BackgroundTransparency = 1
    buttonFrame.Parent = card

    local backButton = Instance.new('TextButton')
    backButton.Size = UDim2.new(0.47, 0, 1, 0)
    backButton.Position = UDim2.new(0, 0, 0, 0)
    backButton.BackgroundColor3 = Color3.fromRGB(42, 42, 46)
    backButton.Text = 'GO BACK'
    backButton.Font = Enum.Font.GothamBold
    backButton.TextSize = 14
    backButton.TextColor3 = Color3.fromRGB(235, 235, 235)
    backButton.BorderSizePixel = 0
    backButton.Parent = buttonFrame

    local continueButton = Instance.new('TextButton')
    continueButton.Size = UDim2.new(0.47, 0, 1, 0)
    continueButton.Position = UDim2.new(0.53, 0, 0, 0)
    continueButton.BackgroundColor3 = Color3.fromRGB(75, 75, 82)
    continueButton.Text = 'CONTINUE'
    continueButton.Font = Enum.Font.GothamBold
    continueButton.TextSize = 14
    continueButton.TextColor3 = Color3.fromRGB(240, 240, 240)
    continueButton.BorderSizePixel = 0
    continueButton.Parent = buttonFrame

    local backCorner = Instance.new('UICorner')
    backCorner.CornerRadius = UDim.new(0, 12)
    backCorner.Parent = backButton

    local continueCorner = Instance.new('UICorner')
    continueCorner.CornerRadius = UDim.new(0, 12)
    continueCorner.Parent = continueButton

    backButton.MouseEnter:Connect(function()
        backButton.BackgroundColor3 = Color3.fromRGB(62, 62, 68)
    end)
    backButton.MouseLeave:Connect(function()
        backButton.BackgroundColor3 = Color3.fromRGB(42, 42, 46)
    end)
    continueButton.MouseEnter:Connect(function()
        continueButton.BackgroundColor3 = Color3.fromRGB(95, 95, 102)
    end)
    continueButton.MouseLeave:Connect(function()
        continueButton.BackgroundColor3 = Color3.fromRGB(75, 75, 82)
    end)

    backButton.MouseButton1Click:Connect(function()
        getgenv().ManualSpamCPS = 300
        if Library and Library._config and Library._config._flags then
            Library._config._flags['Manual_Spam_CPS'] = 300
        end
        if manual_spam_cps_slider then
            pcall(function()
                manual_spam_cps_slider:set_percentage(300)
            end)
        end
        destroy_manual_spam_warning_gui(gui)
    end)

    continueButton.MouseButton1Click:Connect(function()
        manual_spam_warning_confirmed = true
        destroy_manual_spam_warning_gui(gui)
    end)
end

local function warn_manual_spam_cps(value)
    if value <= 300 then
        manual_spam_warning_confirmed = false
        return
    end

    if not manual_spam_warning_confirmed then
        show_manual_spam_warning_modal()
    end
end

local autoparry_module = AutoparryTab:create_module({
    title = "Auto Parry",
    description = "Auto Parry Settings",
    flag = "AutoParryModule",
    section = "left",
    callback = function(state)
        if System then
            System.__properties.__autoparry_enabled = state
            if state then
                if System.autoparry and System.autoparry.start then pcall(System.autoparry.start) end
                if getgenv().AutoParryNotify then
                    send_notification("Auto Parry", "ON", 2)
                end
                
                if System.__properties.__is_mobile and not System.__properties.__mobile_guis.autoparry then
                    local success, autoparry_mobile = pcall(function()
                        return create_mobile_button('AutoParry', 0.6, Color3.fromRGB(255, 255, 255))
                    end)
                    if success and autoparry_mobile then
                        System.__properties.__mobile_guis.autoparry = autoparry_mobile

                        local touch_start = 0
                        local was_dragged = false

                        autoparry_mobile.button.InputBegan:Connect(function(input)
                            if input.UserInputType == Enum.UserInputType.Touch then
                                touch_start = tick()
                                was_dragged = false
                            end
                        end)

                        autoparry_mobile.button.InputChanged:Connect(function(input)
                            if input.UserInputType == Enum.UserInputType.Touch then
                                if (tick() - touch_start) > 0.1 then
                                    was_dragged = true
                                end
                            end
                        end)

                        autoparry_mobile.button.InputEnded:Connect(function(input)
                            if input.UserInputType == Enum.UserInputType.Touch and not was_dragged then
                                if System then
                                    System.__properties.__autoparry_enabled = not System.__properties.__autoparry_enabled
                                    if System.autoparry and System.autoparry.start and System.autoparry.stop then
                                        if System.__properties.__autoparry_enabled then
                                            pcall(System.autoparry.start)
                                        else
                                            pcall(System.autoparry.stop)
                                        end
                                    end
                                end

                                if System and System.__properties and System.__properties.__autoparry_enabled then
                                    autoparry_mobile.text.Text = "ON"
                                    autoparry_mobile.text.TextColor3 = Color3.fromRGB(160, 160, 160)
                                else
                                    autoparry_mobile.text.Text = "AutoParry"
                                    autoparry_mobile.text.TextColor3 = Color3.fromRGB(255, 255, 255)
                                end

                                if getgenv().AutoParryNotify then
                                    send_notification("Auto Parry", System.__properties.__autoparry_enabled and "ON" or "OFF", 2)
                                end
                            end
                        end)
                    end
                end
            else
                if System.autoparry and System.autoparry.stop then pcall(System.autoparry.stop) end
                if getgenv().AutoParryNotify then
                    send_notification("Auto Parry", "OFF", 2)
                end
                
                if System.__properties.__mobile_guis.autoparry then
                    destroy_mobile_gui(System.__properties.__mobile_guis.autoparry)
                    System.__properties.__mobile_guis.autoparry = nil
                end
            end
        end
    end
})


local mode_curve_dropdown = nil

local hotkeys_module = AutoparryTab:create_module({
    title = "PC Curve Hotkey",
    description = "Press 1 - 9 to change Curve Mode",
    flag = "HotkeysModule",
    section = "left",
    callback = function(state)
        
        getgenv().HotkeyParryType = state
        if getgenv().HotkeyParryTypeNotify then
            send_notification("Curve Hotkey", state and "ON" or "OFF", 2)
        end
        if state then
            
            if System.__properties.__connections.__hotkey_parry_type then
                System.__properties.__connections.__hotkey_parry_type:Disconnect()
                System.__properties.__connections.__hotkey_parry_type = nil
            end
            System.__properties.__connections.__hotkey_parry_type = UserInputService.InputBegan:Connect(function(input, process)
                if process then return end
                if not getgenv().HotkeyParryType then return end
                local key_map = {
                    [Enum.KeyCode.One] = 1,
                    [Enum.KeyCode.Two] = 2,
                    [Enum.KeyCode.Three] = 3,
                    [Enum.KeyCode.Four] = 4,
                    [Enum.KeyCode.Five] = 5,
                    [Enum.KeyCode.Six] = 6,
                    [Enum.KeyCode.Seven] = 7,
                    [Enum.KeyCode.Eight] = 8,
                    [Enum.KeyCode.Nine] = 9,
                }
                local idx = key_map[input.KeyCode]
                if not idx then return end
                if System and System.__config and System.__config.__curve_names and idx <= #System.__config.__curve_names then
                    System.__properties.__curve_mode = idx
                    local name = System.__config.__curve_names[idx] or tostring(idx)
                    
                    if mode_curve_dropdown then
                        pcall(function()
                            mode_curve_dropdown:update(name)
                        end)
                    end
                    if getgenv().HotkeyParryTypeNotify then
                        send_notification("Curve Hotkey", "Curve: " .. name, 1.5)
                    end
                else
                    if getgenv().HotkeyParryTypeNotify then
                        send_notification("Curve Hotkey", "No mapping for key", 1.5)
                    end
                end
            end)
        else
            
            if System.__properties.__connections.__hotkey_parry_type then
                System.__properties.__connections.__hotkey_parry_type:Disconnect()
                System.__properties.__connections.__hotkey_parry_type = nil
            end
            
            if System.__properties.__mobile_guis.mode_button then
                destroy_mobile_gui(System.__properties.__mobile_guis.mode_button)
                System.__properties.__mobile_guis.mode_button = nil
            end
        end
    end
})
hotkeys_module:create_checkbox({
    title = "Notify",
    flag = "HotkeyParryTypeNotify",
    callback = function(value)
        getgenv().HotkeyParryTypeNotify = value
    end
})


if System and System.__properties and System.__properties.__is_mobile then
    if not System.__properties.__mobile_guis.mode_button then
        local success, mode_mobile = pcall(function()
            return create_mobile_button('Mode', 0.85, Color3.fromRGB(255, 255, 255))
        end)
        if success and mode_mobile then
            System.__properties.__mobile_guis.mode_button = mode_mobile
            mode_mobile.text.Text = (System and System.__config and System.__config.__curve_names and System.__config.__curve_names[System.__properties.__curve_mode]) or 'Mode'

            local touch_start = 0
            local was_dragged = false

            mode_mobile.button.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch then
                    touch_start = tick()
                    was_dragged = false
                end
            end)

            mode_mobile.button.InputChanged:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch then
                    if (tick() - touch_start) > 0.1 then
                        was_dragged = true
                    end
                end
            end)

            mode_mobile.button.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch and not was_dragged then
                    if System and System.__config and System.__config.__curve_names then
                        System.__properties.__curve_mode = (System.__properties.__curve_mode % #System.__config.__curve_names) + 1
                        local name = System.__config.__curve_names[System.__properties.__curve_mode]
                        mode_mobile.text.Text = name
                        if mode_curve_dropdown then pcall(function() mode_curve_dropdown:update(name) end) end
                        if getgenv().HotkeyParryTypeNotify then
                        end
                    end
                end
            end)
        end
    end
end

autoparry_module:create_dropdown({
    title = "Parry Mode",
    flag = "ParryMode",
    options = {"Remote", "Keypress"},
    maximum_options = 10,
    callback = function(value)
        getgenv().AutoParryMode = value
    end
})

mode_curve_dropdown = autoparry_module:create_dropdown({
    title = "Mode curve",
    flag = "ModeCurve",
    options = (System and System.__config and System.__config.__curve_names) or {"Camera", "Random", "Accelerated", "Backwards", "Slow", "High"},
    maximum_options = 10,
    callback = function(value)
        if System and System.__config and System.__config.__curve_names then
            for i, name in ipairs(System.__config.__curve_names) do
                if name == value then
                    System.__properties.__curve_mode = i
                    break
                end
            end
        end
    end
})

local curve_selector_module = nil
local curve_selector_overlay = nil
local curve_selector_buttons = {}
local curve_selector_title = nil

local function destroy_curve_selector_overlay()
    if curve_selector_overlay then
        pcall(function()
            curve_selector_overlay:Destroy()
        end)
    end

    curve_selector_overlay = nil
    curve_selector_buttons = {}
    curve_selector_title = nil
end

local function create_curve_selector_overlay()
    if curve_selector_overlay then
        return curve_selector_overlay
    end

    if not System or not System.__properties or not System.__properties.__is_mobile then
        return nil
    end

    local THEME = {
        bg = Color3.fromRGB(0, 0, 0),
        bgSoft = Color3.fromRGB(8, 8, 8),
        stroke = Color3.fromRGB(30, 30, 30),
        strokeLit = Color3.fromRGB(70, 70, 70),
        text = Color3.fromRGB(255, 255, 255),
        textDim = Color3.fromRGB(235, 235, 235),
        textFaint = Color3.fromRGB(200, 200, 200),
        accent = Color3.fromRGB(160, 160, 160),
        fontBold = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal),
        fontMed = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
    }

    local function corner(ui, radius)
        local cr = Instance.new("UICorner")
        cr.CornerRadius = radius or UDim.new(0, 12)
        cr.Parent = ui
    end

    local function stroke(ui, color, transparency)
        local st = Instance.new("UIStroke")
        st.Color = color or THEME.stroke
        st.Transparency = transparency or 0.35
        st.Thickness = 1
        st.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        st.Parent = ui
    end

    local function tween(ui, duration, properties)
        return TweenService:Create(ui, TweenInfo.new(duration, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), properties)
    end

    local overlay = Instance.new("ScreenGui")
    overlay.Name = "CurveModeUI"
    overlay.ResetOnSpawn = false
    overlay.IgnoreGuiInset = true
    overlay.DisplayOrder = 100
    overlay.Parent = CoreGui

    local Root = overlay

    local Scrim = Instance.new("TextButton")
    Scrim.Size = UDim2.fromScale(1, 1)
    Scrim.BackgroundColor3 = Color3.new(0, 0, 0)
    Scrim.BackgroundTransparency = 1
    Scrim.Text = ""
    Scrim.AutoButtonColor = false
    Scrim.Visible = false
    Scrim.Parent = Root

    local Sheet = Instance.new("Frame")
    Sheet.Name = "CurveSheet"
    Sheet.AnchorPoint = Vector2.new(0.5, 1)
    Sheet.Position = UDim2.new(0.5, 0, 1, 260)
    Sheet.Size = UDim2.new(0.9, 0, 0, 210)
    Sheet.BackgroundColor3 = THEME.bg
    Sheet.BackgroundTransparency = 0.04
    Sheet.BorderSizePixel = 0
    Sheet.Visible = false
    Sheet.Parent = Root
    corner(Sheet, UDim.new(0, 16))
    stroke(Sheet, THEME.strokeLit, 0.35)

    local smax = Instance.new("UISizeConstraint", Sheet)
    smax.MaxSize = Vector2.new(440, 240)

    local Grab = Instance.new("Frame", Sheet)
    Grab.AnchorPoint = Vector2.new(0.5, 0)
    Grab.Position = UDim2.new(0.5, 0, 0, 8)
    Grab.Size = UDim2.new(0, 36, 0, 4)
    Grab.BackgroundColor3 = THEME.strokeLit
    Grab.BorderSizePixel = 0
    corner(Grab, UDim.new(1, 0))

    local SheetTitle = Instance.new("TextLabel", Sheet)
    SheetTitle.BackgroundTransparency = 1
    SheetTitle.Position = UDim2.new(0, 16, 0, 18)
    SheetTitle.Size = UDim2.new(1, -32, 0, 16)
    SheetTitle.Text = "CURVE MODE"
    SheetTitle.TextColor3 = THEME.textFaint
    SheetTitle.FontFace = THEME.fontBold
    SheetTitle.TextSize = 10
    SheetTitle.TextXAlignment = Enum.TextXAlignment.Left

    local gridHost = Instance.new("Frame", Sheet)
    gridHost.BackgroundTransparency = 1
    gridHost.Position = UDim2.new(0, 14, 0, 42)
    gridHost.Size = UDim2.new(1, -28, 1, -56)

    local grid = Instance.new("UIGridLayout", gridHost)
    grid.CellSize = UDim2.new(0.333, -8, 0, 44)
    grid.CellPadding = UDim2.new(0, 8, 0, 8)
    grid.SortOrder = Enum.SortOrder.LayoutOrder

    local MODES = (System and System.__config and System.__config.__curve_names) or {"Camera", "Random", "Accelerated", "Backwards", "Slow", "High", "Left", "Right"}
    local current = (System and System.__properties and System.__properties.__curve_mode and System.__config and System.__config.__curve_names and System.__config.__curve_names[System.__properties.__curve_mode]) or getgenv().CurveMode or "Camera"

    local CurveCard = Instance.new("TextButton")
    CurveCard.Name = "CurveCard"
    CurveCard.AnchorPoint = Vector2.new(0.5, 1)
    CurveCard.Position = UDim2.new(0.5, 0, 1, -22)
    CurveCard.Size = UDim2.new(0, 158, 0, 46)
    CurveCard.BackgroundColor3 = THEME.bg
    CurveCard.BackgroundTransparency = 0.1
    CurveCard.AutoButtonColor = false
    CurveCard.Text = ""
    CurveCard.Parent = Root
    corner(CurveCard)
    stroke(CurveCard, THEME.stroke, 0.4)

    local ccDot = Instance.new("Frame", CurveCard)
    ccDot.Size = UDim2.new(0, 8, 0, 8)
    ccDot.Position = UDim2.new(0, 14, 0.5, -4)
    ccDot.BackgroundColor3 = THEME.accent
    ccDot.BorderSizePixel = 0
    corner(ccDot, UDim.new(1, 0))

    local ccLabel = Instance.new("TextLabel", CurveCard)
    ccLabel.BackgroundTransparency = 1
    ccLabel.Position = UDim2.new(0, 30, 0, 0)
    ccLabel.Size = UDim2.new(1, -44, 1, 0)
    ccLabel.Text = current
    ccLabel.TextColor3 = THEME.text
    ccLabel.FontFace = THEME.fontBold
    ccLabel.TextSize = 14
    ccLabel.TextXAlignment = Enum.TextXAlignment.Left

    local ccSub = Instance.new("TextLabel", CurveCard)
    ccSub.BackgroundTransparency = 1
    ccSub.Position = UDim2.new(0, 30, 0, 4)
    ccSub.Size = UDim2.new(1, -44, 0, 12)
    ccSub.Visible = false
    ccSub.FontFace = THEME.fontBold

    local pills = {}

    local function refreshPills()
        for mode, pill in pairs(pills) do
            local on = (mode == current)
            tween(pill, 0.15, { BackgroundColor3 = on and THEME.accent or THEME.bgSoft }):Play()
            pill.TextColor3 = on and Color3.fromRGB(255, 255, 255) or THEME.textDim
            pill.FontFace = THEME.fontBold
        end
    end

    local function closeSheet()
        tween(Sheet, 0.3, { Position = UDim2.new(0.5, 0, 1, 260) }):Play()
        tween(Scrim, 0.25, { BackgroundTransparency = 1 }):Play()
        task.delay(0.3, function()
            Sheet.Visible = false
            Scrim.Visible = false
        end)
    end

    local function openSheet()
        Sheet.Visible = true
        Scrim.Visible = true
        tween(Sheet, 0.36, { Position = UDim2.new(0.5, 0, 1, -78) }):Play()
        tween(Scrim, 0.25, { BackgroundTransparency = 0.45 }):Play()
        refreshPills()
    end

    for i, mode in ipairs(MODES) do
        local pill = Instance.new("TextButton", gridHost)
        pill.LayoutOrder = i
        pill.AutoButtonColor = false
        pill.BackgroundColor3 = THEME.bgSoft
        pill.Text = mode
        pill.TextColor3 = THEME.textDim
        pill.FontFace = THEME.fontBold
        pill.TextSize = 12
        corner(pill, UDim.new(0, 10))
        stroke(pill, THEME.stroke, 0.6)

        pill.MouseButton1Click:Connect(function()
            current = mode
            getgenv().CurveMode = mode
            if ccLabel then
                ccLabel.Text = mode
            end

            if System and System.__config and System.__config.__curve_names then
                for idx, name in ipairs(System.__config.__curve_names) do
                    if name == mode then
                        System.__properties.__curve_mode = idx
                        break
                    end
                end
            end

            if mode_curve_dropdown then
                pcall(function()
                    mode_curve_dropdown:update(mode)
                end)
            end

            refreshPills()
            if Library and Library.SendNotification then
                Library.SendNotification({ title = "Curve Mode", text = mode, duration = 1.5 })
            end
            closeSheet()
        end)

        pills[mode] = pill
    end

    CurveCard.MouseButton1Click:Connect(openSheet)
    Scrim.MouseButton1Click:Connect(closeSheet)

    curve_selector_overlay = overlay
    refreshPills()

    return overlay
end

curve_selector_module = AutoparryTab:create_module({
    title = "Mobile Curve Selector",
    description = "Curve Mode Selector in Mobile",
    flag = "SetCurveModule",
    section = "right",
    callback = function(state)
        if not System or not System.__properties or not System.__properties.__is_mobile then
            return
        end

        if state then
            create_curve_selector_overlay()
        else
            destroy_curve_selector_overlay()
        end
    end
})

autoparry_module:create_slider({
    title = "Parry Accuracy",
    flag = "ParryAccuracy",
    maximum_value = 50,
    minimum_value = 1,
    value = 50,
    round_number = true,
    callback = function(value)
        if System and not System.__properties.__humanizer_enabled then
            System.__properties.__accuracy = value
            if update_divisor then pcall(update_divisor) end
        end
    end
})

local humanizer_module = AutoparryTab:create_module({
    title = "Humanizer",
    description = "Choose a random parry accuracy range.",
    flag = "HumanizerModule",
    section = "right",
    callback = function(state)
        if System then
            System.__properties.__humanizer_enabled = state
            if state and update_randomized_accuracy then pcall(update_randomized_accuracy) end
        end
    end
})

humanizer_module:create_range_slider({
    title = "Humanizer Accuracy",
    flag = "HumanizerAccuracyRange",
    maximum_value = 50,
    minimum_value = 1,
    value = {min = 1, max = 50},
    round_number = true,
    callback = function(min_value, max_value)
        if System then
            System.__properties.__humanizer_min_accuracy = min_value
            System.__properties.__humanizer_max_accuracy = max_value
        end
    end
})

autoparry_module:create_checkbox({
    title = "Cooldown Protection",
    flag = "CooldownProtection",
    callback = function(value)
        getgenv().CooldownProtection = value
    end
})

autoparry_module:create_checkbox({
    title = "Auto Ability",
    flag = "AutoAbility",
    callback = function(value)
        getgenv().AutoAbility = value
    end
})

autoparry_module:create_checkbox({
    title = "Notify",
    flag = "AutoParryNotify",
    callback = function(value)
        getgenv().AutoParryNotify = value
    end
})


local function create_mobile_button(name, position_y, color)
    local gui = Instance.new('ScreenGui')
    gui.Name = 'Sigma' .. name .. 'Mobile'
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local button = Instance.new('TextButton')
    button.Size = UDim2.new(0, 128, 0, 40)
    button.Position = UDim2.new(0.5, -64, position_y, 0)
    button.BackgroundTransparency = 1
    button.AnchorPoint = Vector2.new(0.5, 0)
    button.Draggable = true
    button.AutoButtonColor = false
    button.ZIndex = 2

    local bg = Instance.new('Frame')
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
    bg.BorderSizePixel = 0
    bg.Parent = button
    local bgCorner = Instance.new('UICorner')
    bgCorner.CornerRadius = UDim.new(0, 12)
    bgCorner.Parent = bg

    local stroke = Instance.new('UIStroke')
    stroke.Color = Color3.fromRGB(38, 38, 38)
    stroke.Thickness = 1
    stroke.Transparency = 0.25
    stroke.Parent = bg

    local text = Instance.new('TextLabel')
    text.Size = UDim2.new(1, 0, 1, 0)
    text.BackgroundTransparency = 1
    text.Text = name
    text.Font = Enum.Font.GothamBold
    text.TextSize = 13
    text.TextColor3 = Color3.fromRGB(255, 255, 255)
    text.ZIndex = 3
    text.Parent = button

    button.Parent = gui
    gui.Parent = CoreGui

    return {gui = gui, button = button, text = text, bg = bg}
end


local function destroy_mobile_gui(gui_data)
    if gui_data and gui_data.gui then
        gui_data.gui:Destroy()
    end
end

local function create_triggerbot_panel()
    if System.__properties.__triggerbot_ui then
        return System.__properties.__triggerbot_ui
    end

    local ScreenGui = Instance.new('ScreenGui')
    ScreenGui.Name = 'TriggerbotPanel'
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = CoreGui

    local Frame = Instance.new('Frame')
    Frame.Name = 'TriggerbotFrame'
    Frame.Size = UDim2.new(0, 140, 0, 70)
    Frame.Position = UDim2.new(0.4, 0, 0.5, -35)
    Frame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
    Frame.BorderSizePixel = 1
    Frame.BorderColor3 = Color3.fromRGB(38, 38, 38)
    Frame.Parent = ScreenGui

    local FrameStroke = Instance.new('UIStroke', Frame)
    FrameStroke.Color = Color3.fromRGB(38, 38, 38)
    FrameStroke.Thickness = 1

    local Title = Instance.new('TextLabel')
    Title.Name = 'Title'
    Title.BackgroundTransparency = 1
    Title.Size = UDim2.new(1, 0, 0, 16)
    Title.Position = UDim2.new(0, 0, 0, 6)
    Title.Font = Enum.Font.GothamBold
    Title.Text = '6xTB'
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 13
    Title.TextXAlignment = Enum.TextXAlignment.Center
    Title.Parent = Frame

    local ToggleBtn = Instance.new('TextButton')
    ToggleBtn.Name = 'Toggle'
    ToggleBtn.Size = UDim2.new(0, 110, 0, 28)
    ToggleBtn.Position = UDim2.new(0.5, -55, 0, 36)
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
    ToggleBtn.BorderSizePixel = 1
    ToggleBtn.BorderColor3 = Color3.fromRGB(38, 38, 38)
    ToggleBtn.Font = Enum.Font.GothamBold
    ToggleBtn.Text = 'OFF'
    ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleBtn.TextSize = 13
    ToggleBtn.Parent = Frame
    local ToggleStroke = Instance.new('UIStroke', ToggleBtn)
    ToggleStroke.Color = Color3.fromRGB(38, 38, 38)
    ToggleStroke.Thickness = 1

    local dragging = false
    local dragStart
    local startPos

    Title.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = Frame.Position
        end
    end)

    Title.InputChanged:Connect(function(input)
        if not dragging then
            return
        end

        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            local delta = input.Position - dragStart
            Frame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    local function update_button(active)
        if active then
            ToggleBtn.Text = 'ON'
            ToggleBtn.TextColor3 = Color3.fromRGB(18, 18, 18)
            ToggleBtn.BackgroundColor3 = Color3.fromRGB(100, 220, 130)
            ToggleStroke.Color = Color3.fromRGB(100, 220, 130)
        else
            ToggleBtn.Text = 'OFF'
            ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            ToggleBtn.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
            ToggleStroke.Color = Color3.fromRGB(38, 38, 38)
        end
    end

    ToggleBtn.MouseButton1Click:Connect(function()
        if System then
            local newState = not System.__properties.__triggerbot_enabled
            System.__properties.__triggerbot_enabled = newState
            if System.triggerbot and System.triggerbot.enable then
                pcall(System.triggerbot.enable, newState)
            end

            update_button(newState)

            if getgenv().TriggerbotNotify then
                send_notification('Triggerbot', newState and 'ON' or 'OFF', 2)
            end
        end
    end)

    System.__properties.__triggerbot_ui = {
        gui = ScreenGui,
        frame = Frame,
        button = ToggleBtn,
        title = Title,
        update = update_button
    }

    return System.__properties.__triggerbot_ui
end

local triggerbot_module = AutoparryTab:create_module({
    title = "Triggerbot",
    description = "Triggerbot Settings",
    flag = "TriggerbotModule",
    section = "right",
    callback = function(state)
        if System then
            System.__properties.__triggerbot_enabled = state
            if state then
                if System.triggerbot and System.triggerbot.enable then pcall(System.triggerbot.enable, true) end
                if getgenv().TriggerbotNotify then
                    send_notification("Triggerbot", "ON", 2)
                end

                if System and System.__properties and System.__properties.__is_mobile then
                    if not System.__properties.__triggerbot_ui then
                        create_triggerbot_panel()
                    end

                    if System.__properties.__triggerbot_ui and System.__properties.__triggerbot_ui.update then
                        System.__properties.__triggerbot_ui.update(true)
                    end
                end

            else
                if System.triggerbot and System.triggerbot.enable then pcall(System.triggerbot.enable, false) end
                if getgenv().TriggerbotNotify then
                    send_notification("Triggerbot", "OFF", 2)
                end
                if System.__properties.__triggerbot_ui and System.__properties.__triggerbot_ui.gui then
                    pcall(function()
                        System.__properties.__triggerbot_ui.gui:Destroy()
                    end)
                    System.__properties.__triggerbot_ui = nil
                end
                if System.__properties.__mobile_guis.triggerbot then
                    destroy_mobile_gui(System.__properties.__mobile_guis.triggerbot)
                    System.__properties.__mobile_guis.triggerbot = nil
                end
            end
        end
    end
})

triggerbot_module:create_checkbox({
    title = "Notify",
    flag = "TriggerbotNotify",
    callback = function(value)
        getgenv().TriggerbotNotify = value
    end
})

local staff_detection_module = DetectionTab:create_module({
    title = 'Staff Detection',
    description = 'Detect Bladeball Mod in the server',
    flag = 'ModDetectionModule',
    section = 'left',
    callback = function(state)
        getgenv().ModDetection = state
        if state then
            if modMonitorConnection then
                modMonitorConnection:Disconnect()
                modMonitorConnection = nil
            end

            checkModPlayers()
            modMonitorConnection = RunService.Heartbeat:Connect(checkModPlayers)
        else
            if modMonitorConnection then
                modMonitorConnection:Disconnect()
                modMonitorConnection = nil
            end

            detectedMods = {}
        end
    end
})

staff_detection_module:create_dropdown({
    title = 'Action Mode',
    flag = 'ModActionMode',
    options = {'Notification', 'Kick'},
    multi_dropdown = false,
    maximum_options = 2,
    callback = function(value)
        modActionMode = value
    end
})

local infinity_module = DetectionTab:create_module({
    title = "Infinity Detection",
    description = "Detect infinity balls",
    flag = "InfinityModule",
    section = "left",
    callback = function(state)
        if System and System.__config then
            System.__config.__detections.__infinity = state
            if getgenv().InfinityNotify then
                send_notification("Infinity Detection", state and "ON" or "OFF", 2)
            end
        end
    end
})
infinity_module:create_checkbox({
    title = "Notify",
    flag = "InfinityNotify",
    callback = function(value)
        getgenv().InfinityNotify = value
    end
})

local deathslash_module = DetectionTab:create_module({
    title = "Death Slash Detection",
    description = "Detect death slash",
    flag = "DeathSlashModule",
    section = "right",
    callback = function(state)
        if System and System.__config then
            System.__config.__detections.__deathslash = state
        end
    end
})

local timehole_module = DetectionTab:create_module({
    title = "Time Hole Detection",
    description = "Detect time hole",
    flag = "TimeHoleModule",
    section = "left",
    callback = function(state)
        if System and System.__config then
            System.__config.__detections.__timehole = state
        end
    end
})

local slashes_module = DetectionTab:create_module({
    title = "Slashes Of Fury Detection",
    description = "Detect slashes of fury",
    flag = "SlashesModule",
    section = "right",
    callback = function(state)
        if System and System.__config then
            System.__config.__detections.__slashesoffury = state
        end
    end
})
slashes_module:create_slider({
    title = "Parry Delay",
    flag = "ParryDelay",
    maximum_value = 0.250,
    minimum_value = 0.05,
    value = 0.05,
    round_number = false,
    callback = function(value)
        parryDelay = value
    end
})
slashes_module:create_slider({
    title = "Max Parry Count",
    flag = "MaxParryCount",
    maximum_value = 36,
    minimum_value = 1,
    value = 36,
    round_number = true,
    callback = function(value)
        maxParryCount = value
    end
})

local dribble_module = DetectionTab:create_module({
    title = "Dribble Detection",
    flag = "DribbleDetectionModule",
    description = "Toggle Dribble Ball detection",
    section = "right",
    callback = function(state)
        getgenv().DribbleDetection = state
        if System and System.__config then
            System.__config.__detections.__dribble = state
        end
        if getgenv().DribbleNotify then
            send_notification("Dribble Detection", state and "ON" or "OFF", 2)
        end
    end
})
dribble_module:create_checkbox({
    title = "Notify",
    flag = "DribbleNotify",
    callback = function(value)
        getgenv().DribbleNotify = value
    end
})

local phantom_module = DetectionTab:create_module({
    title = "Anti-Phantom",
    description = "Anti-phantom detection",
    flag = "PhantomModule",
    section = "left",
    callback = function(state)
        if System and System.__config then
            System.__config.__detections.__phantom = state
        end
    end
})

local Connections_Manager = getgenv().Connections_Manager or {}
getgenv().Connections_Manager = Connections_Manager

local manual_spam_module = SpamTab:create_module({
    title = "Manual Spam",
    flag = "Manual_Spam_Parry",
    description = "Manually Spams Parry",
    section = "left",
    callback = function(state)
        if getgenv().ManualSpamNotify then
            if state then
                pcall(function()
                    Library.SendNotification({
                        title = "Manual Spam",
                        text = "ON",
                        duration = 2
                    })
                end)
            else
                pcall(function()
                    Library.SendNotification({
                        title = "Manual Spam",
                        text = "OFF",
                        duration = 2
                    })
                end)
            end
        end

        if state then
            if System and System.manual_spam and System.manual_spam.start then
                pcall(System.manual_spam.start)
            end

            if System and System.__properties and System.__properties.__is_mobile and not System.__properties.__manual_spam_ui_created then
                local ScreenGui = Instance.new("ScreenGui", CoreGui)
                ScreenGui.Name = "ManualSpamPanel"
                ScreenGui.ResetOnSpawn = false
                ScreenGui.IgnoreGuiInset = true
                ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

                local SpamFrame = Instance.new("Frame", ScreenGui)
                SpamFrame.Name = "SpamFrame"
                SpamFrame.Size = UDim2.new(0, 140, 0, 70)
                SpamFrame.Position = UDim2.new(0.4, 0, 0.5, -35)
                SpamFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
                SpamFrame.BorderSizePixel = 1
                SpamFrame.BorderColor3 = Color3.fromRGB(38, 38, 38)
                SpamFrame.Visible = true

                local SpamStroke = Instance.new("UIStroke", SpamFrame)
                SpamStroke.Color = Color3.fromRGB(38, 38, 38)
                SpamStroke.Thickness = 1

                local SpamTitleLbl = Instance.new("TextLabel", SpamFrame)
                SpamTitleLbl.Size = UDim2.new(1, 0, 0, 16)
                SpamTitleLbl.Position = UDim2.new(0, 0, 0, 6)
                SpamTitleLbl.Text = "6xMS"
                SpamTitleLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
                SpamTitleLbl.BackgroundTransparency = 1
                SpamTitleLbl.Font = Enum.Font.GothamBold
                SpamTitleLbl.TextSize = 13
                SpamTitleLbl.TextXAlignment = Enum.TextXAlignment.Center

                local SpamToggleBtn = Instance.new("TextButton", SpamFrame)
                SpamToggleBtn.Size = UDim2.new(0, 110, 0, 28)
                SpamToggleBtn.Position = UDim2.new(0.5, -55, 0, 34)
                SpamToggleBtn.Text = "OFF"
                SpamToggleBtn.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
                SpamToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                SpamToggleBtn.BorderSizePixel = 1
                SpamToggleBtn.BorderColor3 = Color3.fromRGB(38, 38, 38)
                SpamToggleBtn.Font = Enum.Font.GothamBold
                SpamToggleBtn.TextSize = 13
                local SpamToggleStroke = Instance.new("UIStroke", SpamToggleBtn)
                SpamToggleStroke.Color = Color3.fromRGB(38, 38, 38)
                SpamToggleStroke.Thickness = 1

                local dragging = false
                local dragStart = nil
                local startPos = nil

                SpamTitleLbl.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = true
                        dragStart = input.Position
                        startPos = SpamFrame.Position
                    end
                end)

                SpamTitleLbl.InputChanged:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                        if dragging and dragStart then
                            local delta = input.Position - dragStart
                            SpamFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
                        end
                    end
                end)

                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = false
                    end
                end)

                local SpamActive = false

                local function UpdateSpamColors(active)
                        if active then
                        SpamFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
                        SpamStroke.Color = Color3.fromRGB(38, 38, 38)
                        SpamTitleLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
                        SpamToggleBtn.TextColor3 = Color3.fromRGB(18, 18, 18)
                        SpamToggleBtn.BackgroundColor3 = Color3.fromRGB(100, 220, 130)
                        SpamToggleStroke.Color = Color3.fromRGB(100, 220, 130)
                    else
                        SpamFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
                        SpamStroke.Color = Color3.fromRGB(38, 38, 38)
                        SpamTitleLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
                        SpamToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                        SpamToggleBtn.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
                        SpamToggleStroke.Color = Color3.fromRGB(38, 38, 38)
                    end
                end

                SpamToggleBtn.MouseButton1Click:Connect(function()
                    SpamActive = not SpamActive
                    SpamToggleBtn.Text = SpamActive and "ON" or "OFF"
                    UpdateSpamColors(SpamActive)
                    if SpamActive then
                        if System and System.manual_spam and System.manual_spam.start then pcall(System.manual_spam.start) end
                    else
                        if System and System.manual_spam and System.manual_spam.stop then pcall(System.manual_spam.stop) end
                    end
                end)

                System.__properties.__manual_spam_ui = {
                    gui = ScreenGui,
                    frame = SpamFrame,
                    button = SpamToggleBtn,
                    title = SpamTitleLbl,
                    active = true,
                    update = UpdateSpamColors
                }
                System.__properties.__manual_spam_ui_created = true

                SpamActive = true
                UpdateSpamColors(true)
            end
        else
            if System and System.manual_spam and System.manual_spam.stop then
                pcall(System.manual_spam.stop)
            end

            if System.__properties.__manual_spam_ui and System.__properties.__manual_spam_ui.gui then
                pcall(function()
                    System.__properties.__manual_spam_ui.gui:Destroy()
                end)
                System.__properties.__manual_spam_ui = nil
                System.__properties.__manual_spam_ui_created = false
            end
        end
    end
})

manual_spam_module:change_state(false)

if isMobile then
    manual_spam_module:create_checkbox({
        title = "UI",
        flag = "Manual_Spam_UI",
        callback = function(value)
            getgenv().spamui = value

            if value then
                local gui = Instance.new("ScreenGui")
                gui.Name = "ManualSpamUI"
                gui.ResetOnSpawn = false
                gui.Parent = game.CoreGui

                local frame = Instance.new("Frame")
                frame.Name = "MainFrame"
                frame.Position = UDim2.new(0, 20, 0, 20)
                frame.Size = UDim2.new(0, 200, 0, 100)
                frame.BackgroundColor3 = Color3.fromRGB(10, 10, 50)
                frame.BackgroundTransparency = 0.3
                frame.BorderSizePixel = 0
                frame.Active = true
                frame.Draggable = true
                frame.Parent = gui

                local uiCorner = Instance.new("UICorner")
                uiCorner.CornerRadius = UDim.new(0, 12)
                uiCorner.Parent = frame

                local uiStroke = Instance.new("UIStroke")
                uiStroke.Thickness = 2
                uiStroke.Color = Color3.new(0, 0, 0)
                uiStroke.Parent = frame

                local button = Instance.new("TextButton")
                button.Name = "ClashModeButton"
                button.Text = "Clash Mode"
                button.Size = UDim2.new(0, 160, 0, 40)
                button.Position = UDim2.new(0.5, -80, 0.5, -20)
                button.BackgroundTransparency = 1
                button.BorderSizePixel = 0
                button.Font = Enum.Font.GothamSemibold
                button.TextColor3 = Color3.new(1, 1, 1)
                button.TextSize = 22
                button.Parent = frame

                local activated = false

                local function toggle()
                    activated = not activated
                    button.Text = activated and "Stop" or "Clash Mode"
                    if activated then
                        local spam_accumulator = 0
                        Connections_Manager['Manual Spam UI'] = game:GetService("RunService").Heartbeat:Connect(function(delta)
                            spam_accumulator = spam_accumulator + (delta or 0)
                            local interval = get_manual_spam_interval()
                            if spam_accumulator < interval then
                                return
                            end
                            spam_accumulator = spam_accumulator - interval
                            System.parry.execute()
                        end)
                    else
                        if Connections_Manager['Manual Spam UI'] then
                            Connections_Manager['Manual Spam UI']:Disconnect()
                            Connections_Manager['Manual Spam UI'] = nil
                        end
                    end
                end

                button.MouseButton1Click:Connect(toggle)
            else
                if game.CoreGui:FindFirstChild("ManualSpamUI") then
                    game.CoreGui:FindFirstChild("ManualSpamUI"):Destroy()
                end

                if Connections_Manager['Manual Spam UI'] then
                    Connections_Manager['Manual Spam UI']:Disconnect()
                    Connections_Manager['Manual Spam UI'] = nil
                end
            end
        end
    })
end

manual_spam_module:create_checkbox({
    title = "Enable CPS",
    flag = "Manual_Spam_CPS_Enabled",
    callback = function(value)
        getgenv().ManualSpamCPSEnabled = value
    end
})

manual_spam_cps_slider = manual_spam_module:create_slider({
    title = "CPS",
    flag = "Manual_Spam_CPS",
    minimum_value = 1,
    maximum_value = 2000,
    value = System and System.__properties and System.__properties.__is_mobile and 20 or 1,
    round_number = true,
    callback = function(value)
        getgenv().ManualSpamCPS = value
        warn_manual_spam_cps(value)
    end
})

manual_spam_module:create_checkbox({
    title = "Notify",
    flag = "Manual_Spam_Parry_Notify",
    callback = function(value)
        getgenv().ManualSpamNotify = value
    end
})

local auto_spam_module = SpamTab:create_module({
    title = "Auto Spam",
    description = "Automatically spam parries ball",
    flag = "AutoSpamModule",
    section = "right",
    callback = function(state)
        if System and System.auto_spam then
            System.__properties.__auto_spam_enabled = state
            if state then
                if System.auto_spam and System.auto_spam.start then pcall(System.auto_spam.start) end
                if getgenv().AutoSpamNotify then
                    send_notification("Auto Spam", "ON", 2)
                end
            else
                if System.auto_spam and System.auto_spam.stop then pcall(System.auto_spam.stop) end
                if getgenv().AutoSpamNotify then
                    send_notification("Auto Spam", "OFF", 2)
                end
            end
        end
    end
})

auto_spam_module:create_checkbox({
    title = "Notify",
    flag = "AutoSpamNotify",
    callback = function(value)
        getgenv().AutoSpamNotify = value
    end
})
auto_spam_module:create_dropdown({
    title = "Mode",
    flag = "AutoSpamMode",
    options = {"Remote", "Keypress"},
    maximum_options = 10,
    callback = function(Value)
        getgenv().AutoSpamMode = Value
    end
})
auto_spam_module:create_checkbox({
    title = "Animation Fix",
    flag = "AutoSpamAnimationFix",
    callback = function(value)
        getgenv().AutoSpamAnimationFix = value
    end
})
auto_spam_module:create_slider({
    title = "Parry Threshold",
    flag = "ParryThreshold",
    maximum_value = 3,
    minimum_value = 1,
    value = 1,
    round_number = true,
    callback = function(value)
        if System then System.__properties.__spam_threshold = value end
    end
})
auto_spam_module:create_slider({
    title = "Distance Multiplier",
    flag = "DistanceMultiplier",
    maximum_value = 3.0,
    minimum_value = 0.3,
    value = 0.3,
    round_number = true,
    callback = function(value)
        if System then System.__properties.__auto_spam_distance_multiplier = value end
    end
})


local __flags = {}
local __players = cloneref(game:GetService('Players'))
local __localplayer = __players.LocalPlayer

local SkinChanger = {
    enabled = false,
    originalSword = nil,
    swordModule = nil,
    swordInfo = nil,
    respawnConnection = nil,
    loopConnection = nil,
    customParryConnection = nil,
    originalParryConnection = nil,
}

getgenv().swordModel = getgenv().swordModel or ""
getgenv().swordAnimations = getgenv().swordAnimations or ""
getgenv().swordFX = getgenv().swordFX or ""
getgenv().slashName = getgenv().slashName or "SlashEffect"

local function getSwordModule()
    if SkinChanger.swordModule then
        return SkinChanger.swordModule
    end

    local ok, mod = pcall(function()
        local shared = ReplicatedStorage:WaitForChild("Shared", 10)
        local instances = shared and shared:WaitForChild("ReplicatedInstances", 10)
        local swords = instances and instances:WaitForChild("Swords", 10)
        return swords and require(swords)
    end)

    if ok and mod then
        SkinChanger.swordModule = mod
    end

    return SkinChanger.swordModule
end

local function getSwordInfo()
    if SkinChanger.swordInfo then
        return SkinChanger.swordInfo
    end

    pcall(function()
        if not getconnections or not ReplicatedStorage.Remotes or not ReplicatedStorage.Remotes.FireSwordInfo then
            return
        end

        for _, conn in ipairs(getconnections(ReplicatedStorage.Remotes.FireSwordInfo.OnClientEvent)) do
            if conn.Function and islclosure and islclosure(conn.Function) then
                local ok, ups = pcall(getupvalues, conn.Function)
                if ok and ups and #ups == 1 and type(ups[1]) == "table" then
                    SkinChanger.swordInfo = ups[1]
                    break
                end
            end
        end
    end)

    return SkinChanger.swordInfo
end

local function getSlashName(name)
    local mod = getSwordModule()
    if not mod or not name or name == "" then
        return "SlashEffect"
    end

    local ok, sword = pcall(function()
        return mod:GetSword(name)
    end)

    return ok and sword and sword.SlashName or "SlashEffect"
end

local function setSword()
    if not SkinChanger.enabled or not __localplayer.Character then
        return
    end

    local mod = getSwordModule()
    if not mod then
        return
    end

    pcall(function()
        setupvalue(rawget(mod, "EquipSwordTo"), 3, false)
    end)

    pcall(function()
        mod:EquipSwordTo(__localplayer.Character, getgenv().swordModel)
    end)

    local info = getSwordInfo()
    if info then
        pcall(function() info:SetSword(getgenv().swordAnimations) end)
    end
end

local function updateSword()
    if not SkinChanger.enabled then
        return
    end

    getgenv().slashName = getSlashName(getgenv().swordFX)
    setSword()
end

local function captureParryHandler()
    pcall(function()
        if not getconnections or not ReplicatedStorage.Remotes or not ReplicatedStorage.Remotes.ParrySuccessAll then
            return
        end

        for _, conn in ipairs(getconnections(ReplicatedStorage.Remotes.ParrySuccessAll.OnClientEvent)) do
            if conn.Function then
                local ok, info = pcall(getinfo, conn.Function)
                if ok and info and info.name == "parrySuccessAll" then
                    SkinChanger.originalParryConnection = conn
                    SkinChanger.customParryConnection = conn.Function
                    if conn.Disable then
                        conn:Disable()
                    end
                    break
                end
            end
        end
    end)
end

local function onParrySuccess(...)
    if not SkinChanger.enabled then
        return
    end

    local args = {...}
    if tostring(args[4]) == __localplayer.Name then
        args[1] = getgenv().slashName
        args[3] = getgenv().swordFX
    end

    if SkinChanger.customParryConnection then
        pcall(SkinChanger.customParryConnection, unpack(args))
    end
end

local fov_module = PlayerTab:create_module({
    title = "FOV",
    description = "Changes Camera POV",
    flag = "FOVModule",
    section = "left",
    callback = function(state)
        getgenv().CameraEnabled = state
        local Camera = workspace.CurrentCamera

        if state then
            getgenv().CameraFOV = getgenv().CameraFOV or 70
            Camera.FieldOfView = getgenv().CameraFOV

            if not getgenv().FOVLoop then
                getgenv().FOVLoop = RunService.RenderStepped:Connect(function()
                    if getgenv().CameraEnabled then
                        Camera.FieldOfView = getgenv().CameraFOV
                    end
                end)
            end
        else
            Camera.FieldOfView = 70

            if getgenv().FOVLoop then
                getgenv().FOVLoop:Disconnect()
                getgenv().FOVLoop = nil
            end
        end
    end
})
fov_module:create_slider({
    title = "Camera FOV",
    flag = "CameraFOV",
    maximum_value = 120,
    minimum_value = 50,
    value = 70,
    round_number = true,
    callback = function(Value)
        getgenv().CameraFOV = Value
        if getgenv().CameraEnabled then
            workspace.CurrentCamera.FieldOfView = Value
        end
    end
})

getgenv().PlayerFollowEnabled = getgenv().PlayerFollowEnabled or false
getgenv().FollowNotifyEnabled = getgenv().FollowNotifyEnabled or false
getgenv().PlayerFollowMode = getgenv().PlayerFollowMode or 'Walk'
getgenv().PlayerFollowTPDistance = getgenv().PlayerFollowTPDistance or 4
getgenv().PlayerFollowTPInterval = getgenv().PlayerFollowTPInterval or 0.15
getgenv().PlayerFollowWalkDistance = getgenv().PlayerFollowWalkDistance or 6

local localPlayer = Players.LocalPlayer
local SelectedPlayerFollow = nil
local followDropdown

local player_cosmetics_module = PlayerTab:create_module({
    title = 'Player Cosmetics',
    flag = 'Player_Cosmetics',
    description = 'Apply Headless and Korblox',
    section = 'left',
    callback = function(value: boolean)
        local lp = localPlayer
        getgenv().HeadlessKorbloxEnabled = value

        local function applyKorblox(character)
            if not character then
                return
            end

            local leg = character:FindFirstChild('Right Leg') or character:FindFirstChild('RightLeg')
            if not leg then
                return
            end

            if leg:FindFirstChild('KorbloxMesh') then
                return
            end

            for _, child in ipairs(leg:GetChildren()) do
                if child:IsA('SpecialMesh') then
                    child:Destroy()
                end
            end

            local mesh = Instance.new('SpecialMesh')
            mesh.Name = 'KorbloxMesh'
            mesh.MeshId = 'rbxassetid://902942096'
            mesh.TextureId = 'rbxassetid://902843398'
            mesh.Offset = Vector3.new(0, 0.7, 0)
            mesh.Parent = leg
        end

        local function restoreKorblox(character)
            if not character then
                return
            end

            local leg = character:FindFirstChild('Right Leg') or character:FindFirstChild('RightLeg')
            if not leg then
                return
            end

            for _, child in ipairs(leg:GetChildren()) do
                if child:IsA('SpecialMesh') then
                    child:Destroy()
                end
            end
        end

        local function applyHeadless(character)
            if not character then
                return
            end

            local head = character:FindFirstChild('Head')
            if not head then
                return
            end

            if _G.PlayerCosmeticsCleanup.headTransparency == nil then
                _G.PlayerCosmeticsCleanup.headTransparency = head.Transparency
            end

            local face = head:FindFirstChildOfClass('Decal')
            if face then
                _G.PlayerCosmeticsCleanup.faceDecalId = face.Texture
                _G.PlayerCosmeticsCleanup.faceDecalName = face.Name
            end

            head.Transparency = 1
            for _, child in ipairs(head:GetChildren()) do
                if child:IsA('Decal') or child.Name == 'face' then
                    child.Transparency = 1
                elseif child:IsA('SpecialMesh') or child:IsA('DataModelMesh') then
                    if not child:GetAttribute('OriginalScale') then
                        child:SetAttribute('OriginalScale', child.Scale)
                        child.Scale = Vector3.new(0, 0, 0)
                    end
                end
            end
        end

        local function restoreHeadless(character)
            if not character then
                return
            end

            local head = character:FindFirstChild('Head')
            if not head then
                return
            end

            if _G.PlayerCosmeticsCleanup.headTransparency ~= nil then
                head.Transparency = _G.PlayerCosmeticsCleanup.headTransparency
            end

            if _G.PlayerCosmeticsCleanup.faceDecalId then
                local newDecal = head:FindFirstChildOfClass('Decal') or Instance.new('Decal', head)
                newDecal.Name = _G.PlayerCosmeticsCleanup.faceDecalName or 'face'
                newDecal.Texture = _G.PlayerCosmeticsCleanup.faceDecalId
                newDecal.Face = Enum.NormalId.Front
            end

            for _, child in ipairs(head:GetChildren()) do
                if child:IsA('Decal') or child.Name == 'face' then
                    child.Transparency = 0
                elseif child:IsA('SpecialMesh') or child:IsA('DataModelMesh') then
                    local orig = child:GetAttribute('OriginalScale')
                    if orig then
                        child.Scale = orig
                        child:SetAttribute('OriginalScale', nil)
                    end
                end
            end
        end

        local function applyCosmetics(character)
            if not character then
                return
            end

            applyKorblox(character)
            applyHeadless(character)
        end

        if value then
            _G.PlayerCosmeticsCleanup = _G.PlayerCosmeticsCleanup or {}
            if lp.Character then
                applyCosmetics(lp.Character)
            end

            if _G.PlayerCosmeticsCleanup.characterAddedConn then
                _G.PlayerCosmeticsCleanup.characterAddedConn:Disconnect()
            end

            _G.PlayerCosmeticsCleanup.characterAddedConn = lp.CharacterAdded:Connect(function(char)
                task.wait(0.5)
                applyCosmetics(char)
            end)
        else
            if _G.PlayerCosmeticsCleanup.characterAddedConn then
                _G.PlayerCosmeticsCleanup.characterAddedConn:Disconnect()
                _G.PlayerCosmeticsCleanup.characterAddedConn = nil
            end

            if lp.Character then
                restoreHeadless(lp.Character)
                restoreKorblox(lp.Character)
            end

            _G.PlayerCosmeticsCleanup = {}
        end
    end
})

    local fly_module = BlatantTab:create_module({
        title = 'Fly',
        flag = 'Fly',
        description = 'Allows the Player to Fly',
        section = 'right',
        callback = function(value: boolean)
            if value then
                getgenv().FlyEnabled = true
                local char = localPlayer.Character or localPlayer.CharacterAdded:Wait()
                local hrp = char:WaitForChild('HumanoidRootPart')
                local humanoid = char:WaitForChild('Humanoid')

                getgenv().OriginalStateType = humanoid:GetState()

                getgenv().RagdollHandler = humanoid.StateChanged:Connect(function(_, newState)
                    if getgenv().FlyEnabled and (newState == Enum.HumanoidStateType.Physics or newState == Enum.HumanoidStateType.Ragdoll) then
                        task.defer(function()
                            humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
                            humanoid:ChangeState(Enum.HumanoidStateType.Running)
                        end)
                    end
                end)

                local bodyGyro = Instance.new('BodyGyro')
                bodyGyro.P = 90000
                bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
                bodyGyro.Parent = hrp

                local bodyVelocity = Instance.new('BodyVelocity')
                bodyVelocity.Velocity = Vector3.new(0, 0, 0)
                bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
                bodyVelocity.Parent = hrp

                humanoid.PlatformStand = true

                getgenv().ResetterConnection = RunService.Heartbeat:Connect(function()
                    if not getgenv().FlyEnabled then
                        return
                    end
                    if bodyGyro and bodyGyro.Parent then
                        bodyGyro.P = 90000
                        bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
                    end
                    if bodyVelocity and bodyVelocity.Parent then
                        bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
                    end
                    humanoid.PlatformStand = true
                end)

                getgenv().FlyConnection = RunService.RenderStepped:Connect(function()
                    if not getgenv().FlyEnabled then
                        return
                    end
                    local camCF = workspace.CurrentCamera.CFrame
                    local moveDir = Vector3.new(0, 0, 0)

                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        moveDir = moveDir + camCF.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        moveDir = moveDir - camCF.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        moveDir = moveDir - camCF.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        moveDir = moveDir + camCF.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.E) then
                        moveDir = moveDir + Vector3.new(0, 1, 0)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Q) then
                        moveDir = moveDir - Vector3.new(0, 1, 0)
                    end

                    if moveDir.Magnitude > 0 then
                        moveDir = moveDir.Unit
                    end
                    bodyVelocity.Velocity = moveDir * (getgenv().FlySpeed or 50)
                    bodyGyro.CFrame = camCF
                end)
            else
                getgenv().FlyEnabled = false
                if getgenv().FlyConnection then
                    getgenv().FlyConnection:Disconnect()
                    getgenv().FlyConnection = nil
                end
                if getgenv().RagdollHandler then
                    getgenv().RagdollHandler:Disconnect()
                    getgenv().RagdollHandler = nil
                end
                if getgenv().ResetterConnection then
                    getgenv().ResetterConnection:Disconnect()
                    getgenv().ResetterConnection = nil
                end

                local char = localPlayer.Character
                if char then
                    local hrp = char:FindFirstChild('HumanoidRootPart')
                    local humanoid = char:FindFirstChild('Humanoid')
                    if humanoid then
                        humanoid.PlatformStand = false
                        if getgenv().OriginalStateType then
                            humanoid:ChangeState(getgenv().OriginalStateType)
                        end
                    end
                    if hrp then
                        for _, v in ipairs(hrp:GetChildren()) do
                            if v:IsA('BodyGyro') or v:IsA('BodyVelocity') then
                                v:Destroy()
                            end
                        end
                    end
                end
            end
        end
    })

    fly_module:create_slider({
        title = 'Fly Speed',
        flag = 'Fly_Speed',
        minimum_value = 10,
        maximum_value = 200,
        value = 50,
        round_number = true,
        callback = function(value: number)
            getgenv().FlySpeed = value
        end
    })


local function getPlayerNames()
    local names = {}
    for _, pl in ipairs(Players:GetPlayers()) do
        if pl ~= localPlayer then
            table.insert(names, pl.Name)
        end
    end
    return names
end

local function updateFollowTarget()
    local availablePlayers = getPlayerNames()
    if #availablePlayers > 0 then
        SelectedPlayerFollow = availablePlayers[1]
        if followDropdown then
            followDropdown:update(SelectedPlayerFollow)
        end
    else
        SelectedPlayerFollow = nil
    end
end

local player_follow_module = BlatantTab:create_module({
    title = 'Player Follow',
    flag = 'Player_Follow',
    description = 'Follows the selected player',
    section = 'left',
    callback = function(value: boolean)
        if value then
            getgenv().PlayerFollowEnabled = true

            if getgenv().PlayerFollowConnection then
                getgenv().PlayerFollowConnection:Disconnect()
                getgenv().PlayerFollowConnection = nil
            end

            local teleportAccumulator = 0

            getgenv().PlayerFollowConnection = RunService.Heartbeat:Connect(function(deltaTime)
                if not getgenv().PlayerFollowEnabled or not SelectedPlayerFollow then
                    return
                end

                local targetPlayer = Players:FindFirstChild(SelectedPlayerFollow)
                local targetCharacter = targetPlayer and targetPlayer.Character
                local targetRoot = targetCharacter and (targetCharacter:FindFirstChild('HumanoidRootPart') or targetCharacter.PrimaryPart)
                local character = localPlayer.Character
                local localRoot = character and (character:FindFirstChild('HumanoidRootPart') or character.PrimaryPart)
                local humanoid = character and character:FindFirstChildOfClass('Humanoid')

                if not targetRoot or not character or not localRoot then
                    return
                end

                if getgenv().PlayerFollowMode == 'Teleport' then
                    teleportAccumulator += deltaTime

                    local interval = math.clamp(tonumber(getgenv().PlayerFollowTPInterval) or 0.15, 0.05, 1)
                    if teleportAccumulator < interval then
                        return
                    end
                    teleportAccumulator = 0

                    local followDistance = math.clamp(tonumber(getgenv().PlayerFollowTPDistance) or 4, 2, 15)
                    local destination = targetRoot.CFrame * CFrame.new(0, 0, followDistance)

                    if humanoid then
                        humanoid:Move(Vector3.zero, false)
                    end

                    pcall(function()
                        character:PivotTo(destination)
                    end)
                else
                    teleportAccumulator = 0

                    if humanoid then
                        local walkDistance = math.clamp(tonumber(getgenv().PlayerFollowWalkDistance) or 6, 2, 25)
                        local currentDistance = (localRoot.Position - targetRoot.Position).Magnitude
                        local walkDestination = (targetRoot.CFrame * CFrame.new(0, 0, walkDistance)).Position

                        if currentDistance > walkDistance + 1 then
                            humanoid:MoveTo(walkDestination)
                        else
                            humanoid:Move(Vector3.zero, false)
                        end
                    end
                end
            end)
        else
            getgenv().PlayerFollowEnabled = false
            if getgenv().PlayerFollowConnection then
                getgenv().PlayerFollowConnection:Disconnect()
                getgenv().PlayerFollowConnection = nil
            end
        end
    end
})

player_follow_module:create_dropdown({
    title = 'Follow Mode',
    flag = 'Follow_Mode',
    options = {'Walk', 'Teleport'},
    multi_dropdown = false,
    maximum_options = 2,
    callback = function(value)
        if value == 'Walk' or value == 'Teleport' then
            getgenv().PlayerFollowMode = value

            if getgenv().FollowNotifyEnabled then
                pcall(function()
                    Library.SendNotification({
                        title = 'Player Follow',
                        text = 'Mode: ' .. value,
                        duration = 2
                    })
                end)
            end
        end
    end
})

player_follow_module:create_slider({
    title = 'Walk Distance',
    flag = 'Follow_Walk_Distance',
    minimum_value = 2,
    maximum_value = 25,
    value = 6,
    round_number = true,
    callback = function(value)
        getgenv().PlayerFollowWalkDistance = math.clamp(tonumber(value) or 6, 2, 25)
    end
})

player_follow_module:create_slider({
    title = 'Teleport Distance',
    flag = 'Follow_TP_Distance',
    minimum_value = 2,
    maximum_value = 15,
    value = 4,
    round_number = true,
    callback = function(value)
        getgenv().PlayerFollowTPDistance = math.clamp(tonumber(value) or 4, 2, 15)
    end
})

player_follow_module:create_slider({
    title = 'Teleport Interval',
    flag = 'Follow_TP_Interval',
    minimum_value = 0.05,
    maximum_value = 1,
    value = 0.15,
    round_number = false,
    callback = function(value)
        getgenv().PlayerFollowTPInterval = math.clamp(tonumber(value) or 0.15, 0.05, 1)
    end
})

local initialOptions = getPlayerNames()
if #initialOptions > 0 then
    followDropdown = player_follow_module:create_dropdown({
        title = 'Follow Target',
        flag = 'Follow_Target',
        options = initialOptions,
        multi_dropdown = false,
        maximum_options = #initialOptions,
        callback = function(value)
            if value then
                SelectedPlayerFollow = value
                if getgenv().FollowNotifyEnabled then
                    Library.SendNotification({
                        title = 'Player Follow',
                        text = 'Now following: ' .. value,
                        duration = 3
                    })
                end
            end
        end
    })
    SelectedPlayerFollow = initialOptions[1]
    if followDropdown then
        followDropdown:update(SelectedPlayerFollow)
    end
else
    SelectedPlayerFollow = nil
end

local lastOptionsString = table.concat(initialOptions, ',')
local updateTimer = 0

RunService.Heartbeat:Connect(function(dt)
    updateTimer = updateTimer + dt
    if updateTimer >= 10 then
        local newOptions = getPlayerNames()
        table.sort(newOptions)
        local newOptionsString = table.concat(newOptions, ',')

        if newOptionsString ~= lastOptionsString then
            if followDropdown then
                if #newOptions > 0 then
                    if followDropdown.set_options then
                        followDropdown:set_options(newOptions)
                    else
                        followDropdown.maximum_options = #newOptions
                    end
                    if not table.find(newOptions, SelectedPlayerFollow) then
                        SelectedPlayerFollow = newOptions[1]
                        followDropdown:update(SelectedPlayerFollow)
                    end
                else
                    SelectedPlayerFollow = nil
                end
            end
            lastOptionsString = newOptionsString
        end
        updateTimer = 0
    end
end)

player_follow_module:create_checkbox({
    title = 'Notify',
    flag = 'Follow_Notify',
    default = false,
    callback = function(value: boolean)
        getgenv().FollowNotifyEnabled = value
    end
})


local StrafeModule = BlatantTab:create_module({
    title = 'Character Speed',
    flag = 'Strafe',
    description = 'Changes Character Speed',
    section = 'left',
    callback = function(value: boolean)
        if value then
            getgenv().StrafeConnection = RunService.PreSimulation:Connect(function()
                local character = Players.LocalPlayer.Character
                if character and character:FindFirstChild('Humanoid') then
                    character.Humanoid.WalkSpeed = getgenv().StrafeSpeed or 36
                end
            end)
        else
            local character = Players.LocalPlayer.Character
            if character and character:FindFirstChild('Humanoid') then
                character.Humanoid.WalkSpeed = 36
            end

            if getgenv().StrafeConnection then
                getgenv().StrafeConnection:Disconnect()
                getgenv().StrafeConnection = nil
            end
        end
    end
})

getgenv().StrafeSpeed = getgenv().StrafeSpeed or 36

StrafeModule:create_slider({
    title = 'Speed Value',
    flag = 'Strafe_Speed',
    minimum_value = 36,
    maximum_value = 200,
    value = getgenv().StrafeSpeed,
    round_number = true,
    callback = function(value: number)
        getgenv().StrafeSpeed = value
    end
})

local BallStatsState = {
    gui = nil,
    frame = nil,
    vlog = nil,
    plog = nil,
    connection = nil,
    peak_velocity = 0
}

local function get_real_ball()
    local balls = workspace:FindFirstChild('Balls')
    if not balls then
        return nil
    end

    for _, ball in pairs(balls:GetChildren()) do
        if ball:GetAttribute('realBall') then
            ball.CanCollide = false
            return ball
        end
    end

    return nil
end

local function destroy_ball_stats()
    if BallStatsState.connection then
        BallStatsState.connection:Disconnect()
        BallStatsState.connection = nil
    end

    if BallStatsState.gui then
        pcall(function()
            BallStatsState.gui:Destroy()
        end)
    end

    BallStatsState.gui = nil
    BallStatsState.frame = nil
    BallStatsState.vlog = nil
    BallStatsState.plog = nil
    BallStatsState.peak_velocity = 0
end

local function create_ball_stats_gui()
    if BallStatsState.gui then
        return
    end

    local OverlayGui = Instance.new('ScreenGui')
    OverlayGui.Name = 'BallStatsGui'
    OverlayGui.ResetOnSpawn = false
    OverlayGui.IgnoreGuiInset = true
    OverlayGui.DisplayOrder = 99
    OverlayGui.Parent = CoreGui

    local Panel = Instance.new('Frame')
    Panel.Name = 'Panel'
    Panel.Size = UDim2.new(0, 190, 0, 94)
    Panel.Position = UDim2.new(0, 20, 0.5, -47)
    Panel.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
    Panel.BorderSizePixel = 0
    Panel.Active = true
    Panel.Parent = OverlayGui
    Instance.new('UICorner', Panel).CornerRadius = UDim.new(0, 12)
    local PanelStroke = Instance.new('UIStroke', Panel)
    PanelStroke.Color = Color3.fromRGB(38, 38, 38)
    PanelStroke.Thickness = 1

    local TitleLabel = Instance.new('TextLabel')
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Size = UDim2.new(1, 0, 0, 20)
    TitleLabel.Position = UDim2.new(0, 0, 0, 6)
    TitleLabel.FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    TitleLabel.Text = 'BALL STATS'
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextSize = 12
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Center
    TitleLabel.Parent = Panel

    local ChipHolder = Instance.new('Frame')
    ChipHolder.BackgroundTransparency = 1
    ChipHolder.Position = UDim2.new(0, 10, 0, 32)
    ChipHolder.Size = UDim2.new(1, -20, 0, 56)
    ChipHolder.Parent = Panel
    local ChipLayout = Instance.new('UIListLayout', ChipHolder)
    ChipLayout.FillDirection = Enum.FillDirection.Horizontal
    ChipLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    ChipLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    ChipLayout.Padding = UDim.new(0, 8)

    local function makeChip(tag)
        local Chip = Instance.new('Frame')
        Chip.Size = UDim2.new(0, 82, 0, 44)
        Chip.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        Chip.BorderSizePixel = 0
        Chip.Parent = ChipHolder
        Instance.new('UICorner', Chip).CornerRadius = UDim.new(0, 10)
        local CS = Instance.new('UIStroke', Chip)
        CS.Color = Color3.fromRGB(35, 35, 35)
        CS.Thickness = 1

        local Tag = Instance.new('TextLabel')
        Tag.BackgroundTransparency = 1
        Tag.Size = UDim2.new(1, -6, 0, 11)
        Tag.Position = UDim2.new(0, 4, 0, 5)
        Tag.FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.Bold, Enum.FontStyle.Normal)
        Tag.Text = tag
        Tag.TextColor3 = Color3.fromRGB(255, 255, 255)
        Tag.TextSize = 9
        Tag.TextXAlignment = Enum.TextXAlignment.Center
        Tag.Parent = Chip

        local Val = Instance.new('TextLabel')
        Val.Name = 'Val'
        Val.BackgroundTransparency = 1
        Val.Size = UDim2.new(1, 0, 0, 20)
        Val.Position = UDim2.new(0, 0, 0, 20)
        Val.FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.Bold, Enum.FontStyle.Normal)
        Val.Text = '--'
        Val.TextColor3 = Color3.fromRGB(255, 255, 255)
        Val.TextSize = 16
        Val.TextXAlignment = Enum.TextXAlignment.Center
        Val.Parent = Chip

        return Val
    end

    local SpeedVal = makeChip('SPEED')
    local PeakVal = makeChip('PEAK')
    PeakVal.TextColor3 = Color3.fromRGB(100, 220, 130)

    Panel.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            local dragStart = input.Position
            local startPos  = Panel.Position
            local moving    = true
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then moving = false end
            end)
            local conn
            conn = UserInputService.InputChanged:Connect(function(inp)
                if not moving then conn:Disconnect() return end
                if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then
                    local delta = inp.Position - dragStart
                    Panel.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
                end
            end)
        end
    end)

    BallStatsState.gui = OverlayGui
    BallStatsState.frame = Panel
    BallStatsState.vlog = SpeedVal
    BallStatsState.plog = PeakVal
end

local function enable_ball_stats()
    create_ball_stats_gui()

    if BallStatsState.connection then
        BallStatsState.connection:Disconnect()
        BallStatsState.connection = nil
    end

    BallStatsState.connection = RunService.RenderStepped:Connect(function()
        if not BallStatsState.frame or not BallStatsState.vlog or not BallStatsState.plog then
            return
        end

        local ball = get_real_ball()
        local speed = 0

        if ball then
            local velocity = ball.AssemblyLinearVelocity or Vector3.new()
            if typeof(velocity) == 'Vector3' then
                speed = velocity.Magnitude
            end
        end

        BallStatsState.vlog.Text = string.format('%.1f', speed)

        if speed > BallStatsState.peak_velocity then
            BallStatsState.peak_velocity = speed
            BallStatsState.plog.Text = string.format('%.1f', BallStatsState.peak_velocity)
        end
    end)
end

local function disable_ball_stats()
    destroy_ball_stats()
end

local ball_stats_module = VisualsTab:create_module({
    title = 'Ball Stats',
    flag = 'Ball_Stats',
    description = 'Toggle ball speed stats display',
    section = 'left',
    callback = function(state)
        getgenv().BallStats = state
        if state then
            enable_ball_stats()
        else
            disable_ball_stats()
        end
    end
})

local visualiser_model = nil
local visualiser_edges = {}

local Visualiser = VisualsTab:create_module({
    title = 'Visualiser',
    flag = 'Visualiser',
    description = 'Parry Range Visualiser',
    section = 'right',
    callback = function(value: boolean)
        getgenv().Visualiser = value

        if value then
            if not visualiser_model then
                visualiser_model = Instance.new('Model')
                visualiser_model.Name = 'VisualiserModel'
                visualiser_model.Parent = workspace

                local segmentCount = 128
                for i = 1, segmentCount do
                    local edge = Instance.new('Part')
                    edge.Name = 'VisualiserEdge' .. i
                    edge.Anchored = true
                    edge.CanCollide = false
                    edge.CastShadow = false
                    edge.Material = Enum.Material.Neon
                    edge.Color = Color3.fromRGB(255, 255, 255)
                    edge.Transparency = 0.25
                    edge.Reflectance = 0.25
                    edge.Size = Vector3.new(0.08, 0.08, 0.18)
                    edge.Parent = visualiser_model
                    visualiser_edges[i] = edge
                end
            end

            Connections_Manager['Visualiser'] = RunService.RenderStepped:Connect(function()
                local character = Player.Character
                local hrp = character and character:FindFirstChild('HumanoidRootPart')

                if getgenv().VisualiserRainbow then
                    local hue = (tick() % 5) / 5
                    for _, edge in pairs(visualiser_edges) do
                        if edge then
                            edge.Color = Color3.fromHSV(hue, 1, 1)
                        end
                    end
                else
                    local hueVal = getgenv().VisualiserHue or 0
                    for _, edge in pairs(visualiser_edges) do
                        if edge then
                            edge.Color = Color3.fromHSV(hueVal / 360, 1, 1)
                        end
                    end
                end

                local speed = 0
                local maxSpeed = 350
                local ballsFolder = workspace:FindFirstChild('Balls')

                if ballsFolder then
                    for _, ball in pairs(ballsFolder:GetChildren()) do
                        if ball and ball:FindFirstChild('zoomies') then
                            local velocity = ball.AssemblyLinearVelocity
                            speed = math.min(velocity.Magnitude, maxSpeed) / 6.5
                            break
                        end
                    end
                end

                local size = math.max(speed, 6.5)
                local radius = size * 0.5
                local segmentCount = #visualiser_edges
                local segmentLength = math.max(0.25, (2 * math.pi * radius) / segmentCount)

                for index, edge in ipairs(visualiser_edges) do
                    if edge and hrp then
                        local angle = (index - 1) * (2 * math.pi / segmentCount)
                        edge.Size = Vector3.new(0.05, 0.05, segmentLength)
                        edge.CFrame = hrp.CFrame
                            * CFrame.new(math.cos(angle) * radius, -3.0, math.sin(angle) * radius)
                            * CFrame.Angles(0, angle + math.pi / 2, 0)
                    end
                end
            end)
        else
            if Connections_Manager['Visualiser'] then
                Connections_Manager['Visualiser']:Disconnect()
                Connections_Manager['Visualiser'] = nil
            end

            if visualiser_model then
                visualiser_model:Destroy()
                visualiser_model = nil
                visualiser_edges = {}
            end
        end
    end
})

Visualiser:create_checkbox({
    title = 'Rainbow',
    flag = 'VisualiserRainbow',
    callback = function(value: boolean)
        getgenv().VisualiserRainbow = value
    end
})

Visualiser:create_slider({
    title = 'Color Hue',
    flag = 'VisualiserHue',
    maximum_value = 360,
    minimum_value = 0,
    value = 0,
    round_number = true,
    callback = function(value: number)
        getgenv().VisualiserHue = value
    end
})

local custom_announcer_module = VisualsTab:create_module({
    title = 'Custom Announcer',
    flag = 'Custom_Announcer',
    description = 'Customize the Game Announcements',
    section = 'left',
    callback = function(value: boolean)
        getgenv().CustomAnnouncer = value

        if value then
            local announcerGui = Player:FindFirstChild('PlayerGui') and Player.PlayerGui:FindFirstChild('announcer')
            local winnerLabel = announcerGui and announcerGui:FindFirstChild('Winner')
            if winnerLabel then
                winnerLabel.Text = getgenv().AnnouncerText or 'discord.gg/Azure'
            end

            if not Connections_Manager['CustomAnnouncer'] then
                Connections_Manager['CustomAnnouncer'] = announcerGui and announcerGui.ChildAdded:Connect(function(child)
                    if child.Name == 'Winner' then
                        child.Changed:Connect(function(property)
                            if property == 'Text' and getgenv().CustomAnnouncer then
                                child.Text = getgenv().AnnouncerText or 'discord.gg/Azure'
                            end
                        end)

                        if getgenv().CustomAnnouncer then
                            child.Text = getgenv().AnnouncerText or 'discord.gg/Azure'
                        end
                    end
                end)
            end
        else
            if Connections_Manager['CustomAnnouncer'] then
                Connections_Manager['CustomAnnouncer']:Disconnect()
                Connections_Manager['CustomAnnouncer'] = nil
            end
        end
    end
})

custom_announcer_module:create_textbox({
    title = 'Custom Announcement Text',
    placeholder = 'Enter Custom Announcement... ',
    flag = 'announcer_text',
    callback = function(text)
        getgenv().AnnouncerText = text

        if getgenv().CustomAnnouncer then
            local announcerGui = Player:FindFirstChild('PlayerGui') and Player.PlayerGui:FindFirstChild('announcer')
            local winnerLabel = announcerGui and announcerGui:FindFirstChild('Winner')
            if winnerLabel then
                winnerLabel.Text = text
            end
        end
    end
})

local function setup_late_feature_modules()
local abilityEspBillboards = {}
local abilityEspConnections = {}
local abilityEspPlayerAddedConnection = nil

local function create_ability_esp_for_player(player)
    task.spawn(function()
        local character = player.Character
        while not character or not character.Parent do
            task.wait()
            character = player.Character
        end

        local head = character:WaitForChild('Head', 10)
        if not head or not getgenv().AbilityESP then
            return
        end

        local existing = head:FindFirstChild('AbilityESPGui')
        if existing then
            existing:Destroy()
        end

        local billboard = Instance.new('BillboardGui')
        billboard.Name = 'AbilityESPGui'
        billboard.Adornee = head
        billboard.Size = UDim2.new(0, 220, 0, 60)
        billboard.StudsOffset = Vector3.new(0, 3.5, 0)
        billboard.AlwaysOnTop = true
        billboard.Parent = head

        local label = Instance.new('TextLabel')
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.TextSize = 14
        label.TextStrokeTransparency = 0
        label.Font = Enum.Font.Roboto
        label.RichText = true
        label.TextXAlignment = Enum.TextXAlignment.Center
        label.TextYAlignment = Enum.TextYAlignment.Center
        label.Parent = billboard
        label.Visible = false

        abilityEspBillboards[player] = label

        local humanoid = character:FindFirstChild('Humanoid')
        if humanoid then
            humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
        end

        local heartbeatConnection
        heartbeatConnection = RunService.Heartbeat:Connect(function()
            if not (character and character.Parent) then
                if heartbeatConnection then
                    heartbeatConnection:Disconnect()
                end
                pcall(function()
                    billboard:Destroy()
                end)
                abilityEspBillboards[player] = nil
                return
            end

            if getgenv().AbilityESP then
                label.Visible = true
                local ability = player:GetAttribute('EquippedAbility')
                if ability then
                    label.Text = '<b>' .. player.DisplayName .. ' [' .. ability .. ']' .. '</b>'
                else
                    label.Text = '<b>' .. player.DisplayName .. '</b>'
                end
            else
                label.Visible = false
            end
        end)

        abilityEspConnections[player] = heartbeatConnection
    end)
end

local function add_ability_esp_player(player)
    if player == Player then
        return
    end

    if abilityEspConnections[player] then
        pcall(function()
            abilityEspConnections[player]:Disconnect()
        end)
        abilityEspConnections[player] = nil
    end

    player.CharacterAdded:Connect(function()
        create_ability_esp_for_player(player)
    end)

    if player.Character then
        task.spawn(function()
            create_ability_esp_for_player(player)
        end)
    end
end

local function start_ability_esp()
    if abilityEspPlayerAddedConnection and next(abilityEspConnections) then
        return
    end

    getgenv().AbilityESP = true

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= Player then
            add_ability_esp_player(player)
        end
    end

    if not abilityEspPlayerAddedConnection then
        abilityEspPlayerAddedConnection = Players.PlayerAdded:Connect(function(player)
            if getgenv().AbilityESP then
                add_ability_esp_player(player)
            end
        end)
    end
end

local function stop_ability_esp()
    if not getgenv().AbilityESP then
        return
    end

    getgenv().AbilityESP = false

    if abilityEspPlayerAddedConnection then
        pcall(function()
            abilityEspPlayerAddedConnection:Disconnect()
        end)
        abilityEspPlayerAddedConnection = nil
    end

    for _, connection in pairs(abilityEspConnections) do
        pcall(function()
            connection:Disconnect()
        end)
    end
    abilityEspConnections = {}

    for _, label in pairs(abilityEspBillboards) do
        pcall(function()
            if label and label.Parent then
                label.Parent:Destroy()
            end
        end)
    end
    abilityEspBillboards = {}
end

local hit_Sound_Enabled = false
local hit_Sound_Folder = Instance.new('Folder')
hit_Sound_Folder.Name = 'Useful Utility'
hit_Sound_Folder.Parent = workspace

local hit_Sound = Instance.new('Sound', hit_Sound_Folder)
hit_Sound.Volume = 6

local hitSoundOptions = {
    'Medal',
    'Fatality',
    'Skeet',
    'Switches',
    'Rust Headshot',
    'Neverlose Sound',
    'Bubble',
    'Laser',
    'Steve',
    'Call of Duty',
    'Bat',
    'TF2 Critical',
    'Saber',
    'Bameware'
}

local hitSoundIds = {
    Medal = 'rbxassetid://6607336718',
    Fatality = 'rbxassetid://6607113255',
    Skeet = 'rbxassetid://6607204501',
    Switches = 'rbxassetid://6607173363',
    ['Rust Headshot'] = 'rbxassetid://138750331387064',
    ['Neverlose Sound'] = 'rbxassetid://110168723447153',
    Bubble = 'rbxassetid://6534947588',
    Laser = 'rbxassetid://7837461331',
    Steve = 'rbxassetid://4965083997',
    ['Call of Duty'] = 'rbxassetid://5952120301',
    Bat = 'rbxassetid://3333907347',
    ['TF2 Critical'] = 'rbxassetid://296102734',
    Saber = 'rbxassetid://8415678813',
    Bameware = 'rbxassetid://3124331820'
}

local hit_sounds_module = PlayerTab:create_module({
    title = 'Hit Sounds',
    flag = 'Hit_Sounds',
    description = 'Toggles hit sounds',
    section = 'right',
    callback = function(value: boolean)
        hit_Sound_Enabled = value
    end
})

hit_sounds_module:create_slider({
    title = 'Volume',
    flag = 'HitSoundVolume',
    minimum_value = 1,
    maximum_value = 10,
    value = 5,
    round_number = true,
    callback = function(value)
        hit_Sound.Volume = value
    end
})

hit_sounds_module:create_dropdown({
    title = 'Hit Sound Type',
    flag = 'hit_sound_type',
    options = hitSoundOptions,
    maximum_options = #hitSoundOptions,
    multi_dropdown = false,
    callback = function(selectedOption)
        if hitSoundIds[selectedOption] then
            hit_Sound.SoundId = hitSoundIds[selectedOption]
        else
            warn('Invalid hit sound selection: ' .. tostring(selectedOption))
        end
    end
})

ReplicatedStorage.Remotes.ParrySuccess.OnClientEvent:Connect(function()
    if hit_Sound_Enabled then
        hit_Sound:Play()
    end
end)

local ability_esp_module = VisualsTab:create_module({
    title = "Ability ESP",
    description = "Displays equipped abilities above players",
    flag = "AbilityESPModule",
    section = "right",
    callback = function(state)
        if state then
            start_ability_esp()
        else
            stop_ability_esp()
        end

    end
})

local thunder_dash_exploit_connection = nil

local function apply_thunder_dash_exploit()
    if not getgenv().AbilityExploit or not getgenv().ThunderDashNoCooldown then
        return
    end

    local shared = ReplicatedStorage:FindFirstChild('Shared')
    local abilities = shared and shared:FindFirstChild('Abilities')
    local thunderDashModule = abilities and abilities:FindFirstChild('Thunder Dash')
    if not thunderDashModule then
        return
    end

    local ok, mod = pcall(require, thunderDashModule)
    if ok and mod then
        pcall(function()
            mod.cooldown = 0
            mod.cooldownReductionPerUpgrade = 0
        end)
    end
end

local function start_thunder_dash_exploit()
    if thunder_dash_exploit_connection then
        return
    end

    thunder_dash_exploit_connection = RunService.Heartbeat:Connect(function()
        if getgenv().AbilityExploit and getgenv().ThunderDashNoCooldown then
            apply_thunder_dash_exploit()
        end
    end)
end

local function stop_thunder_dash_exploit()
    if thunder_dash_exploit_connection then
        thunder_dash_exploit_connection:Disconnect()
        thunder_dash_exploit_connection = nil
    end
end

local ability_exploit_module = BlatantTab:create_module({
    title = 'Ability Exploit',
    flag = 'AbilityExploit',
    description = 'Ability Exploit',
    section = 'right',
    callback = function(value: boolean)
        getgenv().AbilityExploit = value
        if value and getgenv().ThunderDashNoCooldown then
            apply_thunder_dash_exploit()
            start_thunder_dash_exploit()
        else
            stop_thunder_dash_exploit()
        end
    end
})

ability_exploit_module:create_checkbox({
    title = 'Thunder Dash No Cooldown',
    flag = 'ThunderDashNoCooldown',
    callback = function(value: boolean)
        getgenv().ThunderDashNoCooldown = value
        if value and getgenv().AbilityExploit then
            apply_thunder_dash_exploit()
            start_thunder_dash_exploit()
        else
            stop_thunder_dash_exploit()
        end
    end
})

end

setup_late_feature_modules()

local no_render_module = MiscTab:create_module({
    title = 'No Render',
    flag = 'No_Render',
    description = 'Disables Rendering of Effects',
    section = 'left',
    callback = function(state: boolean)
        getgenv().No_Render = state

        local playerScripts = Players.LocalPlayer:FindFirstChild('PlayerScripts')
        local effectScripts = playerScripts and playerScripts:FindFirstChild('EffectScripts')
        local clientFX = effectScripts and effectScripts:FindFirstChild('ClientFX')

        if clientFX then
            clientFX.Disabled = state
        end

        if state then
            if not Connections_Manager['No Render'] then
                local runtime = workspace:FindFirstChild('Runtime')
                if runtime then
                    Connections_Manager['No Render'] = runtime.ChildAdded:Connect(function(value)
                        Debris:AddItem(value, 0)
                    end)
                end
            end
        else
            if Connections_Manager['No Render'] then
                Connections_Manager['No Render']:Disconnect()
                Connections_Manager['No Render'] = nil
            end
        end
    end
})


if System and System.__properties then
    System.__properties.__reverted_remotes = revertedRemotes
end

return Library