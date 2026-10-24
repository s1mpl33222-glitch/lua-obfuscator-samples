-- OasisUI v1.7.0 | MIT License | https://github.com/Mold53/OasisUI
-- generated from src/ by build/bundle.mjs, do not edit
local __modules, __cache = {}, {}
local function import(name)
    local cached = __cache[name]
    if cached == nil then
        local loader = __modules[name]
        if not loader then error("[OasisUI] missing module " .. name, 2) end
        cached = loader(import)
        if cached == nil then cached = false end
        __cache[name] = cached
    end
    return cached
end

__modules["Addons/Settings"] = function(...)
local import = ...
local Theme = import("Core/Theme")
local Storage = import("Core/Storage")
local Config = import("Core/Config")
local Notification = import("Components/Notification")
local Tooltip = import("Components/Tooltip")

-- built-in settings tab, made with the library's own elements; nothing here lands in configs
return function(window)
    local library = window.Library
    local interface = window.Interface
    local tab = window:Tab({ Title = "Settings", Icon = "settings", Id = "Settings", Pinned = true, Draggable = true })

    local function notify(title, content, kind)
        library:Notify({ Title = title, Content = content, Type = kind or "Info", Duration = 3 })
    end
    local function clipboard(text)
        if type(setclipboard) ~= "function" then return false end
        return (pcall(setclipboard, text))
    end
    local function readClipboard()
        local get = type(getgenv) == "function" and (getgenv() :: any).getclipboard
        if type(get) == "function" then
            local ok, text = pcall(get)
            if ok then return text end
        end
        return nil
    end

    -- appearance --------------------------------------------------------------
    local look = tab:Section({ Title = "Appearance", Icon = "palette", Side = "Left", Id = "settings/appearance" })

    local palettes = {}
    for _, name in Theme.Presets.Order do table.insert(palettes, name) end
    local pickers = {}
    look:Dropdown({
        Title = "Preset",
        Values = palettes,
        Default = Theme.Palette,
        Callback = function(name) Theme.UsePalette(name) end,
    })

    local colors = look:Group({ Title = "Colours", Icon = "paintbrush", Opened = false })
    for _, entry in {
        { "Accent", "Accent" }, { "Accent 2", "AccentAlt" }, { "Background", "Background" }, { "Background 2", "BackgroundAlt" },
        { "Cards", "Surface" }, { "Fields", "Elevated" }, { "Outline", "Stroke" }, { "Text", "Text" }, { "Secondary text", "TextDim" },
    } do
        local token = entry[2]
        pickers[token] = colors:ColorPicker({
            Title = entry[1],
            Default = Theme.Current[token],
            Callback = function(color) Theme.Set({ [token] = color }) end,
        })
    end

    local percent = function(value) return math.floor(value * 100 + 0.5) end
    local sliders = {}
    sliders.WindowTransparency = look:Slider({ Title = "Window transparency", Min = 0, Max = 90, Suffix = "%", Default = percent(Theme.Current.WindowTransparency),
        Callback = function(value) Theme.Set({ WindowTransparency = value / 100 }) end })
    sliders.SurfaceTransparency = look:Slider({ Title = "Card transparency", Min = 0, Max = 95, Suffix = "%", Default = percent(Theme.Current.SurfaceTransparency),
        Callback = function(value) Theme.Set({ SurfaceTransparency = value / 100 }) end })
    sliders.ElevatedTransparency = look:Slider({ Title = "Field transparency", Min = 0, Max = 90, Suffix = "%", Default = percent(Theme.Current.ElevatedTransparency),
        Callback = function(value) Theme.Set({ ElevatedTransparency = value / 100 }) end })
    sliders.Radius = look:Slider({ Title = "Corner radius", Min = 0, Max = 20, Suffix = "px", Default = Theme.Current.Radius, Buttons = true,
        Callback = function(value) Theme.Set({ Radius = value, ElementRadius = math.max(math.floor(value * 0.66 + 0.5), 0) }) end })
    local fonts = {}
    for _, entry in Theme.Fonts do table.insert(fonts, { Title = entry[2], Value = entry[1] }) end
    local font = look:Dropdown({ Title = "Font", Values = fonts, Default = Theme.Current.Font, Callback = function(name) Theme.Set({ Font = name }) end })

    look:Toggle({
        Title = "Fit to screen",
        Tooltip = "Scales with the resolution and stays on screen.",
        Default = interface.FitScreen ~= false,
        Callback = function(on) window:SetFitScreen(on) end,
    })
    look:Slider({
        Title = "Interface scale",
        Min = 50, Max = 200, Suffix = "%", Step = 5,
        Default = math.floor((tonumber(interface.Scale) or 1) * 100 + 0.5),
        Live = false,
        Callback = function(value) window:SetScale(value / 100) end,
    })
    sliders.AnimSpeed = look:Slider({ Title = "Animation speed", Min = 0, Max = 300, Step = 10, Suffix = "%", Default = percent(Theme.Current.AnimSpeed),
        Tooltip = "0% turns animations off.", Callback = function(value) Theme.Set({ AnimSpeed = value / 100 }) end })

    local effects = look:Group({ Title = "Effects", Icon = "sparkles", Opened = false })
    local gradient = effects:Toggle({ Title = "Background gradient", Default = Theme.Current.Gradient, Callback = function(on) Theme.Set({ Gradient = on }) end })
    local rotation = effects:Slider({ Title = "Gradient angle", Min = 0, Max = 360, Step = 15, Suffix = "°", Default = Theme.Current.GradientRotation,
        Callback = function(value) Theme.Set({ GradientRotation = value }) end })
    rotation:DependsOn(gradient)
    local animated = effects:Toggle({ Title = "Animated title", Default = Theme.Current.AnimatedTitle, Callback = function(on) Theme.Set({ AnimatedTitle = on }) end })
    local blur = effects:Dropdown({
        Title = "Background blur",
        Values = {
            { Title = "Off", Value = "Off" },
            { Title = "Screen", Value = "Screen", Description = "Blurs the game while the menu is open" },
            { Title = "Window", Value = "Window", Description = "Glass behind the menu, graphics quality 8+" },
        },
        Default = interface.Blur,
        Callback = function(mode)
            window:SetBlur(mode)
            if window.Acrylic:Problem(mode) then
                notify("Window blur can't render here", "See the note under Background blur.", "Warning")
            end
        end,
    })
    local blurHint = effects:Label({ Text = "", Color = "Warning" })
    local function refreshBlurHint()
        local problem = window.Acrylic:Problem(blur:Get())
        blurHint:Set(problem or "")
        blurHint:SetVisible(problem ~= nil)
    end
    blur.Changed:Connect(refreshBlurHint)
    window.Maid:Give(UserSettings().GameSettings:GetPropertyChangedSignal("SavedQualityLevel"):Connect(refreshBlurHint))
    refreshBlurHint()
    effects:Slider({
        Title = "Blur strength",
        Min = 2, Max = 24, Default = interface.BlurStrength,
        Callback = function(value)
            window:SetInterface("BlurStrength", value)
            window.Acrylic:SetStrength(value)
        end,
    }):DependsOn(blur, function(mode) return mode == "Screen" end, "Hide")

    local layout = look:Group({ Title = "Layout", Icon = "layout-dashboard", Opened = false })
    layout:Toggle({ Title = "Expand modules when enabled", Default = interface.AutoExpand, Callback = function(on) window:SetInterface("AutoExpand", on) end })
    layout:Toggle({ Title = "Compact sidebar", Default = interface.Compact, Callback = function(on)
        window:SetCompact(on)
        window:SaveState()
    end })
    layout:Toggle({ Title = "Card descriptions", Default = interface.Descriptions ~= false, Callback = function(on)
        window:SetInterface("Descriptions", on)
        for _, module in window:Modules() do module.StateChanged:Fire("Description") end
    end })

    -- keep the controls in sync when a preset or an import changes the theme
    window.Maid:Give(Theme.Changed:Connect(function()
        for token, picker in pickers do picker:Set(Theme.Current[token], nil, true) end
        for token, slider in sliders do
            local value = Theme.Current[token]
            if token ~= "Radius" then value = percent(value) end
            slider:Set(value, true)
        end
        font:Set(Theme.Current.Font, true)
        gradient:Set(Theme.Current.Gradient, true)
        rotation:Set(Theme.Current.GradientRotation, true)
        animated:Set(Theme.Current.AnimatedTitle, true)
        window:SaveState()
    end))

    -- themes ------------------------------------------------------------------
    local themesDir = window.Folder .. "/themes"
    local themes = tab:Section({ Title = "Themes", Icon = "layers", Side = "Left", Id = "settings/themes" })
    local themeName = themes:Input({ Title = "Theme name", Placeholder = "my theme", Finished = false })
    local themeList
    local function refreshThemes()
        themeList:Refresh(Storage.List(themesDir, "json"))
    end
    themes:Buttons({
        { Title = "Save", Icon = "save", Callback = function()
            local ok, name = Config.ValidName(themeName:Get())
            if not ok then notify("Theme not saved", name, "Error"); return end
            if not Storage.WriteJSON(themesDir .. "/" .. name .. ".json", Theme.Export()) then
                notify("Theme not saved", "File access is not supported.", "Error"); return
            end
            refreshThemes()
            themeList:Set(name)
            notify("Theme saved", name, "Success")
        end },
        { Title = "Load", Icon = "download", Callback = function()
            local name = themeList:Get()
            local data = name and Storage.ReadJSON(themesDir .. "/" .. name .. ".json")
            if not data then notify("Theme not loaded", "Select a saved theme.", "Error"); return end
            Theme.Import(data)
            notify("Theme loaded", name, "Success")
        end },
    })
    themeList = themes:Dropdown({ Title = "Saved themes", Values = Storage.List(themesDir, "json"), AllowNone = true, Placeholder = "No saved themes",
        Callback = function(name) if name then themeName:Set(name) end end })
    themes:Buttons({
        { Title = "Delete", Icon = "trash-2", Style = "Danger", Confirm = "Confirm", Callback = function()
            local name = themeList:Get()
            if not name then notify("Nothing deleted", "Select a saved theme.", "Warning"); return end
            Storage.Delete(themesDir .. "/" .. name .. ".json")
            refreshThemes()
            notify("Theme deleted", name, "Success")
        end },
        { Title = "Export", Icon = "copy", Callback = function()
            local text = Storage.Encode(Theme.Export())
            if text and clipboard(text) then notify("Theme copied", "Paste it anywhere to share.", "Success") else notify("Export failed", "Clipboard is not supported.", "Error") end
        end },
        { Title = "Import", Icon = "clipboard-paste", Callback = function()
            local data = Storage.Decode(readClipboard() or "")
            if data and Theme.Import(data) then notify("Theme imported", nil, "Success") else notify("Import failed", "Clipboard does not hold a theme.", "Error") end
        end },
    })
    themes:Button({ Title = "Reset to preset", Icon = "rotate-ccw", Style = "Ghost", Callback = function()
        Theme.Set(table.clone(Theme.StyleDefaults))
        Theme.UsePalette(Theme.Palette)
    end })

    -- configs -----------------------------------------------------------------
    local configs = window.Config
    local section = tab:Section({ Title = "Configs", Icon = "folder-open", Side = "Right", Id = "settings/configs" })
    local configName = section:Input({ Title = "Config name", Placeholder = "default", Finished = false })
    local configList
    section:Buttons({
        { Title = "Save", Icon = "save", Style = "Primary", Callback = function()
            local name = configName:Get() ~= "" and configName:Get() or configList:Get()
            local ok, result = configs:Save(name)
            if ok then notify("Config saved", result, "Success") else notify("Config not saved", result, "Error") end
        end },
        { Title = "Load", Icon = "download", Callback = function()
            local ok, result = configs:Load(configList:Get() or configName:Get())
            if ok then notify("Config loaded", result, "Success") else notify("Config not loaded", result, "Error") end
        end },
    })
    configList = section:Dropdown({ Title = "Saved configs", Values = configs:List(), AllowNone = true, Placeholder = "No configs yet", Search = true,
        Callback = function(name) if name then configName:Set(name) end end })
    section:Buttons({
        { Title = "Rename", Icon = "pencil", Callback = function()
            local current = configList:Get()
            if not current then notify("Nothing to rename", "Select a config first.", "Warning"); return end
            window:Dialog({
                Title = "Rename config",
                Icon = "pencil",
                Input = { Default = current, Placeholder = "New name" },
                Buttons = {
                    { Title = "Cancel", Style = "Secondary" },
                    { Title = "Rename", Style = "Primary", Callback = function(text, dialog)
                        local ok, result = configs:Rename(current, text)
                        if not ok then
                            dialog:SetError(result)
                            return false
                        end
                        configList:Set(result)
                        notify("Config renamed", result, "Success")
                        return true
                    end },
                },
            })
        end },
        { Title = "Delete", Icon = "trash-2", Style = "Danger", Confirm = "Confirm", Callback = function()
            local current = configList:Get()
            if not current then notify("Nothing deleted", "Select a config first.", "Warning"); return end
            local ok, result = configs:Delete(current)
            if ok then notify("Config deleted", result, "Success") else notify("Config not deleted", result, "Error") end
        end },
    })
    local autoload = section:Label({ Text = "Autoload", Value = configs:GetAutoload() or "none" })
    section:Buttons({
        { Title = "Set autoload", Icon = "pin", Callback = function()
            local current = configList:Get()
            if not current then notify("No autoload set", "Select a config first.", "Warning"); return end
            configs:SetAutoload(current)
            notify("Autoload set", current, "Success")
        end },
        { Title = "Clear", Icon = "x", Callback = function() configs:SetAutoload(nil) end },
    })
    section:Toggle({
        Title = "Auto save",
        Tooltip = "Saves changes into the loaded config.",
        Default = interface.AutoSave == true,
        Callback = function(on)
            configs.AutoSave = on
            window:SetInterface("AutoSave", on)
        end,
    })
    configs.AutoSave = interface.AutoSave == true
    section:Buttons({
        { Title = "Export", Icon = "copy", Callback = function()
            local text = configs:Export()
            if text and clipboard(text) then notify("Config copied", "Share it as text.", "Success") else notify("Export failed", "Clipboard is not supported.", "Error") end
        end },
        { Title = "Import", Icon = "clipboard-paste", Callback = function()
            local ok, err = configs:Import(readClipboard() or "")
            if ok then notify("Config imported", nil, "Success") else notify("Import failed", err, "Error") end
        end },
    })
    window.Maid:Give(configs.Changed:Connect(function()
        configList:Refresh(configs:List())
        if configs.Current and configs:Exists(configs.Current) then configList:Set(configs.Current) end
        autoload:SetValue(configs:GetAutoload() or "none")
    end))

    -- menu --------------------------------------------------------------------
    local menu = tab:Section({ Title = "Menu", Icon = "sliders-horizontal", Side = "Right", Id = "settings/menu" })
    menu:Keybind({ Title = "Menu key", Binding = window.MenuBinding })
    -- scripts add their own rows here (window.NotifySettings), e.g. a toggle for their load message
    local alerts = menu:Group({ Title = "Notifications", Icon = "bell" })
    alerts:Dropdown({
        Title = "Position",
        Values = { "BottomRight", "TopRight", "BottomLeft", "TopLeft" },
        Default = interface.NotifyPosition,
        Callback = function(position)
            Notification.SetPosition(position)
            window:SetInterface("NotifyPosition", position)
        end,
        Action = { Icon = "bell", Tooltip = "Test notification", Callback = function()
            notify("Notification", "This is how messages look.", "Info")
        end },
    })
    alerts:Slider({ Title = "Duration", Min = 50, Max = 300, Step = 10, Suffix = "%", Default = interface.NotifyDuration,
        Callback = function(value)
            Notification.Scale = value / 100
            window:SetInterface("NotifyDuration", value)
        end })
    alerts:Slider({ Title = "On screen", Min = 1, Max = 8, Default = interface.NotifyMax,
        Callback = function(value)
            Notification.Max = value
            window:SetInterface("NotifyMax", value)
        end })
    alerts:Segmented({ Title = "Feature on / off", Values = { "Always", "Hidden", "Off" }, Default = interface.ToggleAlerts,
        Tooltip = "Cards with the bell on. Hidden: only while the menu is hidden.",
        Callback = function(value) window:SetInterface("ToggleAlerts", value) end })
    alerts:Toggle({ Title = "Config loaded", Default = interface.NotifyConfig ~= false,
        Callback = function(on) window:SetInterface("NotifyConfig", on) end })
    window.NotifySettings = alerts
    menu:Buttons({
        { Title = "Center", Icon = "move", Callback = function() window:Center() end },
        { Title = "Reset layout", Icon = "layout-grid", Confirm = "Confirm", Callback = function()
            for _, other in window.Tabs do other:ResetLayout() end
            window.Favorites:ResetLayout()
        end },
    })
    menu:Label({ Text = "OasisUI", Value = "v" .. tostring(library.Version) })
    menu:Button({ Title = "Clear favorites", Icon = "star-off", Style = "Ghost", Confirm = "Click again to clear", Callback = function() window:ClearFavorites() end })
    menu:Button({ Title = "Unload", Icon = "power", Style = "Danger", Confirm = "Click again to unload", Callback = function() library:Unload() end })

    -- overlays ----------------------------------------------------------------
    local overlays = window.Overlays
    local hud = tab:Section({ Title = "Overlays", Icon = "layout-list", Side = "Right", Id = "settings/overlays" })
    local style = interface.KeybindStyle
    local function bindStyle(key)
        return function(value) overlays:SetKeybindStyle(key, value) end
    end
    local list = hud:Toggle({ Title = "Keybind list", Default = interface.KeybindList, Callback = function(on)
        overlays:SetKeybindList(on)
        window:SaveState()
    end })
    local listOptions = hud:Group({ Title = "Keybind list options", Icon = "keyboard" })
    listOptions:Dropdown({ Title = "Show", Values = { "All", "Active" }, Default = style.Show, Callback = bindStyle("Show") })
    listOptions:Dropdown({ Title = "Sort by", Values = { "Added", "Name", "Key", "Mode", "Active first" }, Default = style.Sort, Callback = bindStyle("Sort") })
    listOptions:Toggle({ Title = "Group by mode", Default = style.Group, Callback = bindStyle("Group") })
    listOptions:Dropdown({ Title = "Layout", Values = overlays.Layouts, Default = style.Layout, Callback = bindStyle("Layout") })
    listOptions:Segmented({ Title = "Mode text", Values = { "Full", "Short", "Hidden" }, Default = style.ModeText, Callback = bindStyle("ModeText") })
    listOptions:Segmented({ Title = "Key style", Values = { "Pill", "Brackets", "Plain" }, Default = style.KeyStyle, Callback = bindStyle("KeyStyle") })
    listOptions:Slider({ Title = "Size", Min = 50, Max = 200, Step = 5, Suffix = "%", Default = style.Scale, Callback = bindStyle("Scale") })
    listOptions:Slider({ Title = "Width", Min = 150, Max = 400, Step = 5, Suffix = "px", Default = style.Width, Callback = bindStyle("Width") })
    listOptions:Slider({ Title = "Transparency", Min = 0, Max = 90, Suffix = "%", Default = style.Transparency, Callback = bindStyle("Transparency") })
    listOptions:Toggle({ Title = "Title bar", Default = style.Title, Callback = bindStyle("Title") })
    listOptions:Toggle({ Title = "Include menu key", Default = style.MenuKey, Callback = bindStyle("MenuKey") })
    listOptions:Toggle({ Title = "Hide while the menu is open", Default = style.HideWithMenu, Callback = bindStyle("HideWithMenu") })
    listOptions:Button({ Title = "Reset position", Icon = "rotate-ccw", Style = "Ghost", Callback = function() overlays:ResetPosition("Keybinds") end })
    listOptions:DependsOn(list, nil, "Hide")

    local marks = interface.WatermarkStyle
    local function markStyle(key)
        return function(value) overlays:SetWatermarkStyle(key, value) end
    end
    local watermark = hud:Toggle({ Title = "Watermark", Default = interface.Watermark, Callback = function(on)
        overlays:SetWatermark(on)
        window:SaveState()
    end })
    local markOptions = hud:Group({ Title = "Watermark options", Icon = "tag" })
    markOptions:Toggle({ Title = "Title", Default = marks.Title, Callback = markStyle("Title") })
    markOptions:Toggle({ Title = "Frame rate", Default = marks.Fps, Callback = markStyle("Fps") })
    markOptions:Toggle({ Title = "Ping", Default = marks.Ping, Callback = markStyle("Ping") })
    markOptions:Toggle({ Title = "Time", Default = marks.Time, Callback = markStyle("Time") })
    markOptions:Toggle({ Title = "Display name", Default = marks.User, Callback = markStyle("User") })
    markOptions:Input({ Title = "Custom text", Placeholder = "Shown after the title", Default = marks.Text, MaxLength = 40, Callback = markStyle("Text") })
    markOptions:Slider({ Title = "Size", Min = 50, Max = 200, Step = 5, Suffix = "%", Default = marks.Scale, Callback = markStyle("Scale") })
    markOptions:Button({ Title = "Reset position", Icon = "rotate-ccw", Style = "Ghost", Callback = function() overlays:ResetPosition("Watermark") end })
    markOptions:DependsOn(watermark, nil, "Hide")

    -- behaviour ---------------------------------------------------------------
    local behaviour = tab:Section({ Title = "Behaviour", Icon = "settings-2", Side = "Left", Id = "settings/behaviour" })
    local binding = behaviour:Group({ Title = "Binding keys", Icon = "keyboard", Opened = true })
    binding:Segmented({
        Title = "Click outside while binding",
        Values = { "Keep", "Clear" },
        Default = interface.BindClickOutside,
        Callback = function(value)
            window:SetInterface("BindClickOutside", value)
            window:ApplyBindOptions()
        end,
    })
    binding:Segmented({
        Title = "Escape while binding",
        Values = { "Keep", "Clear" },
        Default = interface.BindEscape,
        Callback = function(value)
            window:SetInterface("BindEscape", value)
            window:ApplyBindOptions()
        end,
    })
    binding:Toggle({
        Title = "Allow mouse buttons",
        Default = interface.BindMouse ~= false,
        Callback = function(on)
            window:SetInterface("BindMouse", on)
            window:ApplyBindOptions()
        end,
    })
    binding:Slider({
        Title = "Combo keys",
        Min = 1, Max = 4,
        Default = interface.BindComboKeys,
        Tooltip = "Keys per bind. 2 allows LCtrl + L.",
        Callback = function(value)
            window:SetInterface("BindComboKeys", value)
            window:ApplyBindOptions()
        end,
    })
    behaviour:Toggle({ Title = "Tooltips", Default = interface.Tooltips ~= false, Callback = function(on)
        window:SetInterface("Tooltips", on)
        Tooltip.Enabled = on
        if not on then Tooltip.Hide() end
    end })
    local profile = behaviour:Group({ Title = "Profile", Icon = "user-round", Opened = true })
    profile:Toggle({ Title = "Profile card", Default = interface.ShowUser ~= false, Callback = function(on)
        window:SetInterface("ShowUser", on)
        window:_layoutSidebar()
    end })
    profile:Toggle({ Title = "Hide avatar", Default = interface.HideAvatar, Callback = function(on)
        window:SetInterface("HideAvatar", on)
        if window.PaintUser then window.PaintUser() end
    end })
    profile:Toggle({ Title = "Streamer mode", Tooltip = "Hides your name.", Default = interface.HideUser, Callback = function(on)
        window:SetInterface("HideUser", on)
        if window.PaintUser then window.PaintUser() end
    end })

    window.SettingsTab = tab
    return tab
end
end

__modules["Components/Acrylic"] = function(...)
local import = ...
local Services = import("Core/Services")
local Util = import("Core/Util")
local Theme = import("Core/Theme")

-- background blur, off by default
--   "Screen": a BlurEffect in Lighting while the menu is open; works on every graphics level
--   "Window": a glass plate in front of the camera plus a DepthOfFieldEffect, blurring only what is behind
--             the window; Roblox draws glass from graphics quality 8 up (a bootstrapper quality FFlag
--             overrides the menu) and only one depth of field effect counts, so the game's own ones are
--             switched off while it runs and restored afterwards
local Acrylic = {}
Acrylic.__index = Acrylic
Acrylic.Modes = { "Off", "Screen", "Window" }

function Acrylic.new(frame, maid)
    local self = setmetatable({ Frame = frame, Mode = "Off", Shown = true, Strength = 12 }, Acrylic)
    maid:Give(function() self:SetMode("Off") end)
    return self
end

local function qualityLevel()
    local ok, level = pcall(function() return UserSettings().GameSettings.SavedQualityLevel.Value end)
    return ok and level or 0
end

-- bootstrapper FFlag that pins the real quality (1-21 scale) whatever the menu says
local function qualityOverride()
    local ok, level = pcall(game.GetFastInt, game, "DebugFRMQualityLevelOverride")
    return ok and tonumber(level) or 0
end

-- why a mode cannot render on this client, nil when it can
function Acrylic:Problem(mode)
    if (mode or self.Mode) ~= "Window" then return nil end
    -- glass and depth of field render from menu level 8, which is 16 on the engine's 1-21 scale
    local override = qualityOverride()
    if override > 0 then
        if override >= 16 then return nil end
        return ("A client FFlag (DFIntDebugFRMQualityLevelOverride = %d) caps graphics quality below what Window blur needs. Use Screen blur or remove the flag."):format(override)
    end
    -- 0 = automatic, the engine picks the level
    local level = qualityLevel()
    if level > 0 and level < 8 then
        return "Window blur needs graphics quality 8 or higher (Roblox menu → Settings → Graphics)."
    end
    return nil
end

function Acrylic:Supported()
    return self:Problem("Window") == nil
end

function Acrylic:_screen()
    local blur = Instance.new("BlurEffect")
    blur.Name = "OasisBlur"
    blur.Size = 0
    blur.Parent = Services.Lighting
    local function update()
        Util.Tween(blur, 0.3, { Size = self.Shown and self.Strength or 0 })
    end
    self._update = update
    self._stop = function() blur:Destroy() end
    update()
end

local function toWorld(point, distance)
    local ray = workspace.CurrentCamera:ViewportPointToRay(point.X, point.Y)
    return ray.Origin + ray.Direction * distance
end

function Acrylic:_window()
    local camera = workspace.CurrentCamera
    local connections = {}
    local depth

    -- other depth of field effects win over ours; keep them off and remember their state
    local muted = {}
    local function mute(effect)
        if effect == depth or not effect:IsA("DepthOfFieldEffect") or muted[effect] ~= nil then return end
        muted[effect] = effect.Enabled
        effect.Enabled = false
        table.insert(connections, effect:GetPropertyChangedSignal("Enabled"):Connect(function()
            if effect.Enabled and self.Mode == "Window" and self.Shown then
                muted[effect] = true
                effect.Enabled = false
            end
        end))
    end
    local function restore()
        for effect, enabled in muted do
            if effect.Parent then effect.Enabled = enabled end
        end
        table.clear(muted)
    end

    depth = Instance.new("DepthOfFieldEffect")
    depth.Name = "OasisAcrylic"
    depth.FarIntensity = 0
    depth.FocusDistance = 0.05
    depth.InFocusRadius = 0.1
    depth.NearIntensity = 1
    depth.Parent = Services.Lighting

    local part = Instance.new("Part")
    part.Name = "OasisAcrylic"
    part.Color = Color3.new(0, 0, 0)
    part.Material = Enum.Material.Glass
    part.Size = Vector3.new(1, 1, 0)
    part.Anchored, part.CanCollide, part.CanQuery, part.CanTouch, part.CastShadow = true, false, false, false, false
    part.Transparency = 0.98
    local mesh = Instance.new("SpecialMesh")
    mesh.MeshType = Enum.MeshType.Brick
    mesh.Offset = Vector3.new(0, 0, -0.000001)
    mesh.Parent = part
    part.Parent = camera

    -- keeps the plate over the window; runs on every camera move
    local function place()
        local frame = self.Frame
        local inset = 6
        -- AbsolutePosition sits below the topbar inset, viewport rays start above it
        local position = frame.AbsolutePosition + Vector2.new(inset, inset) + Services.GuiService:GetGuiInset()
        local size = frame.AbsoluteSize - Vector2.new(inset * 2, inset * 2)
        local topLeft = toWorld(position, 0.001)
        local topRight = toWorld(position + Vector2.new(size.X, 0), 0.001)
        local bottomRight = toWorld(position + size, 0.001)
        local cf = camera.CFrame
        part.CFrame = CFrame.fromMatrix((topLeft + bottomRight) / 2, cf.XVector, cf.YVector, cf.ZVector)
        mesh.Scale = Vector3.new((topRight - topLeft).Magnitude, (topRight - bottomRight).Magnitude, 0)
    end

    local lastVisible = nil
    local function update()
        place()
        local visible = self.Shown and self.Frame.Visible and self:Supported()
        -- only a change of visibility touches lighting and the theme
        if visible == lastVisible then return end
        lastVisible = visible
        part.Transparency = visible and 0.98 or 1
        depth.Enabled = visible
        if visible then
            for _, child in Services.Lighting:GetChildren() do mute(child) end
            for _, child in camera:GetChildren() do mute(child) end
        else
            restore()
        end
        Theme.Set({ _windowBlur = visible })
    end
    table.insert(connections, camera:GetPropertyChangedSignal("CFrame"):Connect(place))
    table.insert(connections, camera:GetPropertyChangedSignal("FieldOfView"):Connect(place))
    table.insert(connections, camera:GetPropertyChangedSignal("ViewportSize"):Connect(place))
    table.insert(connections, self.Frame:GetPropertyChangedSignal("AbsolutePosition"):Connect(place))
    table.insert(connections, self.Frame:GetPropertyChangedSignal("AbsoluteSize"):Connect(place))
    table.insert(connections, self.Frame:GetPropertyChangedSignal("Visible"):Connect(update))
    table.insert(connections, UserSettings().GameSettings:GetPropertyChangedSignal("SavedQualityLevel"):Connect(update))
    table.insert(connections, Services.Lighting.ChildAdded:Connect(function(child)
        if self.Shown and self:Supported() then mute(child) end
    end))
    update()
    self._update = update
    self._stop = function()
        for _, connection in connections do connection:Disconnect() end
        restore()
        part:Destroy()
        depth:Destroy()
        Theme.Set({ _windowBlur = false })
    end
end

function Acrylic:SetMode(mode)
    if not table.find(Acrylic.Modes, mode) then mode = "Off" end
    if mode == self.Mode then return end
    if self._stop then
        self._stop()
        self._stop, self._update = nil, nil
    end
    self.Mode = mode
    local start = if mode == "Screen" then self._screen elseif mode == "Window" then self._window else nil
    if start then
        local ok, err = pcall(start, self)
        if not ok then
            warn("[OasisUI] blur: " .. tostring(err))
            self.Mode = "Off"
        end
    end
end

function Acrylic:SetStrength(strength)
    self.Strength = strength
    if self.Mode == "Screen" and self._update then self._update() end
end

function Acrylic:SetVisible(visible)
    self.Shown = visible
    if self._update then self._update() end
end

return Acrylic
end

__modules["Components/Container"] = function(...)
local import = ...
local Maid = import("Core/Maid")

-- mixin for anything that holds elements (modules, groups); adds Toggle/AddToggle/... methods
local Container = {}

local KINDS = {
    Toggle = { "Toggle" },
    Checkbox = { "Toggle", { Style = "Checkbox" } },
    Button = { "Button" },
    Buttons = { "ButtonRow" },
    ButtonRow = { "ButtonRow" },
    Slider = { "Slider" },
    Range = { "RangeSlider" },
    RangeSlider = { "RangeSlider" },
    Dropdown = { "Dropdown" },
    Input = { "Input" },
    Textbox = { "Input" },
    TextBox = { "Input" },
    Keybind = { "Keybind" },
    ColorPicker = { "ColorPicker" },
    Colorpicker = { "ColorPicker" },
    Label = { "Label" },
    Paragraph = { "Paragraph" },
    Divider = { "Divider" },
    Spacer = { "Spacer" },
    Space = { "Spacer" },
    ProgressBar = { "ProgressBar" },
    Progress = { "ProgressBar" },
    Segmented = { "Segmented" },
    Group = { "Group" },
    Image = { "Image" },
    Code = { "Code" },
    Log = { "Log" },
}
Container.Kinds = KINDS

function Container.Setup(self)
    self.Children = {}
    self._views = {}
end

-- accepts (def), (flag, def) or (text) for labels / dividers
local function normalize(a, b)
    if type(a) == "string" then
        if type(b) == "table" then
            b.Flag = b.Flag or a
            return b
        end
        return { Title = a, Text = a }
    end
    return a or {}
end

function Container:_add(kind, a, b)
    local spec = KINDS[kind]
    local def = normalize(a, b)
    if spec[2] then
        for key, value in spec[2] do
            if def[key] == nil then def[key] = value end
        end
    end
    local class = import("Elements/" .. spec[1])
    local element = class.new(self, def)
    table.insert(self.Children, element)
    for _, view in self._views do
        element:Mount(view.Frame, view.Maid, #self.Children)
    end
    return element
end

for name in KINDS do
    Container[name] = function(self, a, b) return self:_add(name, a, b) end
    Container["Add" .. name] = Container[name]
end

-- renders every child into frame and keeps it in sync with later additions
function Container:_mountChildren(frame, maid)
    local view = { Frame = frame, Maid = maid }
    for index, child in self.Children do
        child:Mount(frame, maid, index)
    end
    table.insert(self._views, view)
    maid:Give(function()
        local index = table.find(self._views, view)
        if index then table.remove(self._views, index) end
    end)
    return view
end

function Container:_matchesChildren(query)
    for _, child in self.Children do
        if child:Matches(query) then return true end
    end
    return false
end

function Container:_eachElement(fn)
    for _, child in self.Children do
        fn(child)
        if child._eachElement then child:_eachElement(fn) end
    end
end

Container.Maid = Maid

function Container.Apply(target)
    for key, value in Container do
        if type(value) == "function" and key ~= "Apply" and key ~= "Setup" then
            target[key] = value
        end
    end
end

return Container
end

__modules["Components/Dialog"] = function(...)
local import = ...
local Services = import("Core/Services")
local Util = import("Core/Util")
local Theme = import("Core/Theme")
local Maid = import("Core/Maid")
local TextArea = import("Components/TextArea")

-- modal over a window; a button callback returning false keeps the dialog open
local Dialog = {}

local STYLES = {
    Primary   = { Bg = "Accent", Text = "OnAccent" },
    Secondary = { Bg = "ElevatedHover", Text = "Text" },
    Danger    = { Bg = "Danger", Text = "OnAccent" },
}

-- options: Title, Content, Icon, Width, OnClose,
--          Input = { Placeholder, Default, Multiline, Height, Monospace, ReadOnly },
--          Buttons = { { Title, Style, Callback(text, dialog) } }
function Dialog.Open(root, options)
    local maid = Maid.new()
    local handle = {}
    local closed = false

    local shade = maid:Give(Util.New("TextButton", {
        Name = "Shade",
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Color3.new(0, 0, 0),
        BackgroundTransparency = 1,
        ZIndex = 80,
        Parent = root,
    }))
    Util.Corner("Radius", shade)

    -- never wider or taller than the window it covers
    local inner = root.AbsoluteSize / math.max(Util.ScaleOf(root), 0.01)
    local card = Util.New("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(math.min(options.Width or 340, inner.X - 24), 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        ZIndex = 81,
        Theme = { BackgroundColor3 = "Elevated" },
        Parent = shade,
    })
    Util.Corner("Radius", card)
    Util.Stroke(card)
    Util.Padding(card, 16)
    Util.List(card, 10)
    local scale = Util.New("UIScale", { Scale = 0.94, Parent = card })

    local head = Util.New("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 20), LayoutOrder = 1, ZIndex = 82, Parent = card })
    local titleX = 0
    if options.Icon then
        Util.Icon(options.Icon, { Size = UDim2.fromOffset(18, 18), Position = UDim2.fromOffset(0, 1), Color = "Accent", ZIndex = 83, Parent = head })
        titleX = 26
    end
    Util.Label({
        Text = options.Title or "Dialog",
        TextSize = 15,
        Weight = Enum.FontWeight.SemiBold,
        Size = UDim2.new(1, -titleX, 1, 0),
        Position = UDim2.fromOffset(titleX, 0),
        ZIndex = 83,
        Parent = head,
    })

    if options.Content then
        Util.Label({
            Text = options.Content,
            TextSize = 12,
            Color = "TextDim",
            RichText = true,
            TextWrapped = true,
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            LayoutOrder = 2,
            ZIndex = 82,
            Parent = card,
        })
    end

    local box
    local input = options.Input
    if input then
        local multiline = input.Multiline == true
        local height = multiline and math.min(input.Height or 160, inner.Y - 170) or 30
        local field = Util.New("Frame", {
            Size = UDim2.new(1, 0, 0, height),
            LayoutOrder = 3,
            ZIndex = 82,
            Theme = { BackgroundColor3 = "Surface" },
            Parent = card,
        })
        Util.Corner("ElementRadius", field)
        local stroke = Util.Stroke(field)
        local font = input.Monospace and function() return Font.new("rbxasset://fonts/families/RobotoMono.json") end
            or Theme.Font(Enum.FontWeight.Medium)
        if multiline then
            -- long text scrolls inside the field and follows the caret
            local _
            _, box = TextArea.new({
                Size = UDim2.new(1, -4, 1, -4),
                Position = UDim2.fromOffset(2, 2),
                ZIndex = 83,
                Parent = field,
                Box = {
                    Text = input.Default or "",
                    PlaceholderText = input.Placeholder or "",
                    TextSize = 12,
                    TextEditable = input.ReadOnly ~= true,
                    ClearTextOnFocus = false,
                    Theme = { TextColor3 = input.ReadOnly and "TextDim" or "Text", PlaceholderColor3 = "TextMuted", FontFace = font },
                },
            })
        else
            box = Util.New("TextBox", {
                Size = UDim2.new(1, -20, 1, 0),
                Position = UDim2.fromOffset(10, 0),
                Text = input.Default or "",
                PlaceholderText = input.Placeholder or "",
                TextSize = 12,
                TextEditable = input.ReadOnly ~= true,
                TextYAlignment = Enum.TextYAlignment.Center,
                ZIndex = 84,
                Theme = { TextColor3 = input.ReadOnly and "TextDim" or "Text", PlaceholderColor3 = "TextMuted", FontFace = font },
                Parent = field,
            })
        end
        box.Focused:Connect(function() Theme.Bind(stroke, { Color = "Accent" }) end)
        box.FocusLost:Connect(function() Theme.Bind(stroke, { Color = "Stroke" }) end)
        handle.Input = box
    end

    local errorLabel = Util.Label({
        Text = "",
        TextSize = 11,
        Color = "Danger",
        Visible = false,
        Size = UDim2.new(1, 0, 0, 14),
        LayoutOrder = 4,
        ZIndex = 82,
        Parent = card,
    })

    local row = Util.New("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 30), LayoutOrder = 5, ZIndex = 82, Parent = card })
    Util.List(row, 8, Enum.FillDirection.Horizontal, Enum.HorizontalAlignment.Right)

    function handle:Close()
        if closed then return end
        closed = true
        Util.Tween(shade, 0.15, { BackgroundTransparency = 1 })
        Util.Tween(scale, 0.15, { Scale = 0.94 })
        task.delay(0.16 / math.max(Theme.Current.AnimSpeed or 1, 0.05), function() maid:Clean() end)
        Util.Safe(options.OnClose)
    end

    function handle:SetError(text)
        errorLabel.Text = text or ""
        errorLabel.Visible = text ~= nil and text ~= ""
    end

    local buttons = options.Buttons or { { Title = "OK", Style = "Primary" } }
    local submit
    for index, spec in buttons do
        local style = STYLES[spec.Style or (index == #buttons and "Primary" or "Secondary")] or STYLES.Secondary
        local state = { Hover = false }
        local button = Util.New("TextButton", {
            AutomaticSize = Enum.AutomaticSize.X,
            Size = UDim2.fromOffset(72, 30),
            Text = spec.Title or "OK",
            TextSize = 12,
            LayoutOrder = index,
            ZIndex = 83,
            Theme = {
                BackgroundColor3 = function(t) return state.Hover and t[style.Bg]:Lerp(t.Text, 0.1) or t[style.Bg] end,
                TextColor3 = style.Text,
                FontFace = Theme.Font(Enum.FontWeight.SemiBold),
            },
            Parent = row,
        })
        Util.Corner("ElementRadius", button)
        Util.Padding(button, 0, 14, 0, 14)
        Util.Feedback(button, state)
        local function press()
            if closed then return end
            local keep = false
            if spec.Callback then
                keep = Util.Safe(spec.Callback, box and box.Text or nil, handle) == false
            end
            if not keep then handle:Close() end
        end
        button.MouseButton1Click:Connect(press)
        if style == STYLES.Primary or style == STYLES.Danger then submit = press end
    end
    -- Enter in the text field presses the primary button
    if box then
        box.FocusLost:Connect(function(enter)
            if enter and submit then submit() end
        end)
    end

    maid:Give(Services.UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.Escape then handle:Close() end
    end))

    Util.Tween(shade, 0.18, { BackgroundTransparency = 0.45 })
    Util.Tween(scale, 0.2, { Scale = 1 }, Enum.EasingStyle.Back)
    -- touch: no keyboard popping up by itself, a tap on the field focuses it
    if box and not input.ReadOnly and not Util.Touch() then task.defer(function() box:CaptureFocus() end) end
    return handle
end

return Dialog
end

__modules["Components/Layer"] = function(...)
local import = ...
local Services = import("Core/Services")
local Util = import("Core/Util")

-- screen guis: Main (windows), Hud (watermark, keybind list), Overlay (popups, tooltips, toasts)
local Layer = { Scale = 1 } :: any

local function parent()
    if type(gethui) == "function" then
        local ok, hui = pcall(gethui)
        if ok and typeof(hui) == "Instance" then return hui end
    end
    local ok = pcall(function() return Services.CoreGui:FindFirstChild("RobloxGui") end)
    if ok then return Services.CoreGui end
    return Services.Players.LocalPlayer:WaitForChild("PlayerGui")
end

local function screen(name, order)
    local gui = Util.New("ScreenGui", {
        Name = name,
        ResetOnSpawn = false,
        IgnoreGuiInset = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder = order,
    })
    local protect = type(getgenv) == "function" and (getgenv() :: any).protectgui
    if type(protect) == "function" then pcall(protect, gui) end
    gui.Parent = Layer.Parent
    return gui
end

function Layer.Init(maid, name)
    Layer.Parent = parent()
    -- guis left by a run the unload registry could not reach (another environment, an error mid-load)
    for _, suffix in { "", "_Hud", "_Overlay" } do
        local old = Layer.Parent:FindFirstChild(name .. suffix)
        while old do
            old:Destroy()
            old = Layer.Parent:FindFirstChild(name .. suffix)
        end
    end
    Layer.Main = maid:Give(screen(name, 1000))
    Layer.Hud = maid:Give(screen(name .. "_Hud", 999))
    Layer.Overlay = maid:Give(screen(name .. "_Overlay", 1001))
    -- scaled root covering the screen; children use the same scale as the window
    Layer.Root = Util.New("Frame", {
        Name = "Root",
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
        Parent = Layer.Overlay,
    })
    Layer.RootScale = Util.New("UIScale", { Parent = Layer.Root })
end

function Layer.SetScale(scale)
    Layer.Scale = scale
    if Layer.Root then
        Layer.RootScale.Scale = scale
        Layer.Root.Size = UDim2.fromScale(1 / scale, 1 / scale)
    end
end

-- usable gui area (screen minus the topbar inset); AbsolutePosition and input positions share this space
function Layer.Bounds()
    if Layer.Main then return Layer.Main.AbsoluteSize end
    return workspace.CurrentCamera.ViewportSize
end

return Layer
end

__modules["Components/Menu"] = function(...)
local import = ...
local Util = import("Core/Util")
local Theme = import("Core/Theme")
local Popup = import("Components/Popup")

-- context menu; items: { Title, Icon, Callback, Checked, Danger, Disabled, Hint } or "-"
local Menu = {}

function Menu.Open(options)
    return Popup.Open({
        Anchor = options.Anchor,
        Point = options.Point,
        Width = options.Width or 184,
        Align = options.Align,
        Padding = 4,
        Build = function(frame, popup)
            Util.List(frame, 1)
            if options.Title then
                local title = Util.Label({
                    Text = options.Title,
                    TextSize = 11,
                    Color = "TextMuted",
                    Weight = Enum.FontWeight.SemiBold,
                    TextTruncate = Enum.TextTruncate.AtEnd,
                    Size = UDim2.new(1, 0, 0, 20),
                    LayoutOrder = 0,
                    Parent = frame,
                    ZIndex = 101,
                })
                Util.Padding(title, 0, 6, 0, 6)
            end
            for index, item in options.Items do
                if item == "-" then
                    local holder = Util.New("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 7), LayoutOrder = index, Parent = frame, ZIndex = 101 })
                    Util.New("Frame", {
                        Size = UDim2.new(1, -8, 0, 1),
                        Position = UDim2.new(0, 4, 0.5, 0),
                        Theme = { BackgroundColor3 = "Divider" },
                        Parent = holder,
                        ZIndex = 101,
                    })
                    continue
                end
                local color = item.Danger and "Danger" or "Text"
                local hover = false
                local button = Util.New("TextButton", {
                    Size = UDim2.new(1, 0, 0, 26),
                    LayoutOrder = index,
                    ZIndex = 101,
                    Theme = {
                        BackgroundColor3 = "ElevatedHover",
                        BackgroundTransparency = function() return hover and 0 or 1 end,
                    },
                    Parent = frame,
                })
                Util.Corner(5, button)
                local x = 8
                if item.Icon then
                    Util.Icon(item.Icon, {
                        Size = UDim2.fromOffset(14, 14),
                        Position = UDim2.new(0, 8, 0.5, -7),
                        Color = item.Danger and "Danger" or "TextDim",
                        ZIndex = 102,
                        Parent = button,
                    })
                    x = 30
                end
                Util.Label({
                    Text = item.Title,
                    TextSize = 12,
                    Color = color,
                    Weight = Enum.FontWeight.Medium,
                    Size = UDim2.new(1, -x - 28, 1, 0),
                    Position = UDim2.fromOffset(x, 0),
                    TextTransparency = item.Disabled and 0.6 or 0,
                    ZIndex = 102,
                    Parent = button,
                })
                if item.Checked ~= nil then
                    Util.Icon("check", {
                        Size = UDim2.fromOffset(13, 13),
                        Position = UDim2.new(1, -21, 0.5, -6),
                        Color = "Accent",
                        ImageTransparency = item.Checked and 0 or 1,
                        ZIndex = 102,
                        Parent = button,
                    })
                elseif item.Hint then
                    Util.Label({
                        Text = item.Hint,
                        TextSize = 11,
                        Color = "TextMuted",
                        TextXAlignment = Enum.TextXAlignment.Right,
                        Size = UDim2.new(0, 60, 1, 0),
                        Position = UDim2.new(1, -68, 0, 0),
                        ZIndex = 102,
                        Parent = button,
                    })
                end
                Util.Hover(button, function(on) hover = on; Theme.Refresh(button, 0.1) end)
                button.MouseButton1Click:Connect(function()
                    if item.Disabled then return end
                    popup:Close()
                    Util.Safe(item.Callback)
                end)
            end
        end,
    })
end

return Menu
end

__modules["Components/Module"] = function(...)
local import = ...
local Util = import("Core/Util")
local Theme = import("Core/Theme")
local Signal = import("Core/Signal")
local Binding = import("Core/Binding")
local Container = import("Components/Container")
local Widgets = import("Components/Widgets")
local Menu = import("Components/Menu")
local Tooltip = import("Components/Tooltip")

-- feature card: switch + key in the header, settings fold out below
-- def: Title, Description, Icon, Flag, Default, Toggle (false = section), Keybind (false | key | { Key, Mode }),
--      Color (a colour swatch next to the switch: ColorPicker options with their own Flag),
--      Notify (default of the card's bell: a notification on every on / off), Opened, Side ("Left" | "Right"),
--      Risky (red title), Locked, Visible, Callback(enabled)
local Module = {}
Module.__index = Module
Container.Apply(Module)

function Module.new(tab, def)
    local self = setmetatable({}, Module)
    Container.Setup(self)
    local window = tab.Window
    self.Kind = "Module"
    self.Tab = tab
    self.Window = window
    self.Module = self
    self.Def = def
    self.Title = def.Title or def.Name or "Module"
    self.Description = def.Description or def.Desc
    self.Icon = def.Icon
    self.Flag = def.Flag
    self.Id = def.Id or def.Flag or (tab.Id .. "/" .. self.Title)
    self.Toggleable = def.Toggle ~= false
    self.Enabled = self.Toggleable and def.Default == true
    self.Default = self.Enabled
    self.Locked = def.Locked == true
    self.Visible = def.Visible ~= false
    self.NoSave = def.Flag == nil
    self.Changed = Signal.new()
    self.StateChanged = Signal.new()
    self._listeners = {}
    self._mounts = {}
    if def.Opened ~= nil then
        self.Expanded = def.Opened == true
    else
        self.Expanded = not self.Toggleable or (self.Enabled and window.Interface.AutoExpand)
    end

    if self.Toggleable and def.Keybind ~= false then
        local spec = type(def.Keybind) == "table" and def.Keybind or { Key = def.Keybind ~= true and def.Keybind or def.Key }
        self.Binding = Binding.new({
            Key = spec.Key or spec.Default,
            Mode = spec.Mode,
            Modes = spec.Modes or { "Toggle", "Hold" },
            Capture = spec,
            Press = function(binding)
                if self.Locked then return end
                self:SetEnabled(binding.Mode == "Hold" or not self.Enabled)
            end,
            Release = function(binding)
                if binding.Mode == "Hold" and not self.Locked then self:SetEnabled(false) end
            end,
        })
        self.Binding.Changed:Connect(function() window:_touch(true) end)
        window:_trackBind(self)
    end
    if self.Flag then
        window.Config:Register(self.Flag, self)
        window.Library.Flags[self.Flag] = self
    end
    if self.Toggleable and def.Color then
        local spec = table.clone(def.Color)
        spec.Title = spec.Title or (self.Title .. " colour")
        self.Color = import("Elements/ColorPicker").new(self, spec)
    end
    self.Favorite = window.State.Favorites[self.Id] == true
    local notify = window.State.Notify[self.Id]
    if notify == nil then notify = def.Notify == true end
    self.Notify = self.Toggleable and notify
    return self
end

function Module:_add(kind, a, b)
    local element = Container._add(self, kind, a, b)
    self.StateChanged:Fire("Children")
    return element
end

-- state -----------------------------------------------------------------------

function Module:SetEnabled(enabled, silent)
    if not self.Toggleable then return end
    enabled = enabled and true or false
    if enabled == self.Enabled then return end
    self.Enabled = enabled
    self.Changed:Fire(enabled)
    if not silent then
        Util.Safe(self.Def.Callback, enabled)
        for _, fn in self._listeners do Util.Safe(fn, enabled) end
        if self.Notify then self.Window:_toggleNote(self, enabled) end
    end
    if self.Window.Interface.AutoExpand and #self.Children > 0 then self:SetExpanded(enabled) end
    self.Window:_touch(true)
end

function Module:ToggleEnabled()
    self:SetEnabled(not self.Enabled)
end

function Module:Get()
    return self.Enabled
end

function Module:Set(value, silent)
    self:SetEnabled(value, silent)
end

function Module:OnChanged(fn)
    table.insert(self._listeners, fn)
    return self
end

function Module:SetExpanded(expanded)
    expanded = expanded and true or false
    if expanded == self.Expanded then return end
    self.Expanded = expanded
    self.StateChanged:Fire("Expanded")
end

function Module:SetFavorite(favorite)
    self.Window:_setFavorite(self, favorite and true or false)
end

function Module:SetNotify(on)
    if self.Toggleable then self.Window:_setNotify(self, on and true or false) end
end

function Module:SetTitle(text)
    self.Title = text
    self.StateChanged:Fire("Title")
end

function Module:SetDescription(text)
    self.Description = text
    self.StateChanged:Fire("Description")
end

function Module:SetLocked(locked)
    self.Locked = locked and true or false
    self.StateChanged:Fire("Locked")
end

function Module:SetVisible(visible)
    self.Visible = visible and true or false
    self.StateChanged:Fire("Visible")
end

-- Settings > Layout can hide card descriptions for a calmer, smaller window
function Module:_showDescription()
    return self.Description ~= nil and self.Description ~= "" and self.Window.Interface.Descriptions ~= false
end

function Module:Matches(query)
    local text = (self.Title .. " " .. (self.Description or "")):lower()
    return text:find(query, 1, true) ~= nil or self:_matchesChildren(query)
end

function Module:Reset()
    self:SetEnabled(self.Default)
    if self.Color then self.Color:Reset() end
    self:_eachElement(function(element)
        if element.Reset then pcall(element.Reset, element) end
    end)
end

function Module:BindInfo()
    return self.Title, self.Enabled
end

function Module:Save()
    return { Enabled = self.Enabled, Bind = self.Binding and self.Binding:Save() or nil }
end

function Module:Load(data)
    if type(data) == "boolean" then
        self:SetEnabled(data)
    elseif type(data) == "table" then
        if self.Binding and data.Bind then self.Binding:Load(data.Bind) end
        if data.Enabled ~= nil then self:SetEnabled(data.Enabled) end
    end
end

function Module:Destroy()
    for _, mount in table.clone(self._mounts) do mount:Clean() end
    for _, child in table.clone(self.Children) do child:Destroy() end
    if self.Color then self.Color:Destroy() end
    if self.Binding then self.Binding:Destroy() end
    if self.Flag then self.Window.Config:Unregister(self.Flag, self) end
    self.Window:_removeModule(self)
end

-- view ------------------------------------------------------------------------

function Module:_menu(view, point)
    local window = self.Window
    local items: { any } = {}
    if self.Toggleable then
        table.insert(items, { Title = self.Enabled and "Disable" or "Enable", Icon = "power", Disabled = self.Locked, Callback = function() self:ToggleEnabled() end })
    end
    table.insert(items, { Title = self.Favorite and "Remove favorite" or "Add to favorites", Icon = "star", Callback = function() self:SetFavorite(not self.Favorite) end })
    if self.Toggleable then
        table.insert(items, { Title = self.Notify and "Mute on / off" or "Notify on / off", Icon = self.Notify and "bell-off" or "bell", Callback = function() self:SetNotify(not self.Notify) end })
    end
    if #self.Children > 0 then
        table.insert(items, { Title = self.Expanded and "Collapse" or "Expand", Icon = "chevrons-up-down", Callback = function() self:SetExpanded(not self.Expanded) end })
    end
    if self.Binding then
        table.insert(items, "-")
        table.insert(items, { Title = "Bind key", Icon = "keyboard", Hint = Util.KeyLabel(self.Binding.Key), Callback = function() self:_capture() end })
        for _, mode in self.Binding.Modes do
            table.insert(items, { Title = mode, Checked = self.Binding.Mode == mode, Callback = function() self.Binding:SetMode(mode) end })
        end
    end
    table.insert(items, "-")
    table.insert(items, { Title = self.Locked and "Unlock" or "Lock", Icon = self.Locked and "lock-open" or "lock", Callback = function() self:SetLocked(not self.Locked) end })
    if view.Page and view.Page.Draggable and #view.Page.Columns > 1 then
        table.insert(items, { Title = "Move to other column", Icon = "columns-2", Callback = function() view.Page:MoveToOther(view) end })
    end
    if view.Source then
        table.insert(items, { Title = "Open in " .. (self.Tab.Path or self.Tab.Title), Icon = "external-link", Callback = function() window:SelectTab(self.Tab, self) end })
    end
    table.insert(items, { Title = "Reset settings", Icon = "rotate-ccw", Danger = true, Callback = function() self:Reset() end })
    Menu.Open({ Point = point, Items = items, Title = self.Title, Width = 190 })
end

function Module:_capture()
    if self.Binding and not self.Locked then self.Binding:Capture() end
end

-- view: { Page, Source (show the tab tag), Maid }
function Module:Render(parent, maid, view)
    view = view or {}
    local window = self.Window
    local hover = false
    table.insert(self._mounts, maid)
    maid:Give(function()
        local index = table.find(self._mounts, maid)
        if index then table.remove(self._mounts, index) end
    end)

    local card = maid:Give(Util.New("Frame", {
        Name = "Module",
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        Visible = self.Visible,
        Theme = { BackgroundColor3 = "Surface", BackgroundTransparency = "SurfaceTransparency" },
        Parent = parent,
    }))
    Util.Corner("ElementRadius", card)
    local stroke = Util.Stroke(card, function(t) return self.Enabled and t.Accent or t.Stroke end, function(t)
        if self.Enabled then return math.clamp(t.StrokeTransparency + 0.1, 0.35, 0.75) end
        return hover and t.StrokeTransparency - 0.15 or t.StrokeTransparency
    end)
    Util.List(card, 0)

    -- header ------------------------------------------------------------------
    local header = Util.New("Frame", {
        Name = "Header",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        LayoutOrder = 1,
        Parent = card,
    })
    local hit = Util.New("TextButton", {
        Name = "Hit",
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
        ZIndex = 0,
        Parent = header,
    })
    local stack = Util.New("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        Parent = header,
    })
    Util.Padding(stack, 11, 12, 10, 12)
    Util.List(stack, 3)

    local line = Util.New("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 18), LayoutOrder = 1, Parent = stack })
    Util.List(line, 6, Enum.FillDirection.Horizontal, nil, Enum.VerticalAlignment.Center)
    local left = Util.New("Frame", { BackgroundTransparency = 1, Size = UDim2.new(0, 0, 1, 0), LayoutOrder = 1, Parent = line })
    Util.New("UIFlexItem", { FlexMode = Enum.UIFlexMode.Fill, Parent = left })
    Util.List(left, 6, Enum.FillDirection.Horizontal, nil, Enum.VerticalAlignment.Center)
    if self.Icon then
        Util.Icon(self.Icon, { Size = UDim2.fromOffset(15, 15), Color = "Accent", LayoutOrder = 1, Parent = left })
    end
    local title = Util.Label({
        Text = self.Title,
        TextSize = 13,
        Weight = Enum.FontWeight.SemiBold,
        AutomaticSize = Enum.AutomaticSize.X,
        Size = UDim2.fromScale(0, 1),
        TextTruncate = Enum.TextTruncate.AtEnd,
        LayoutOrder = 2,
        Theme = { TextColor3 = function(t)
            if self.Locked then return t.TextDim end
            return self.Def.Risky and t.Danger or t.Text
        end },
        Parent = left,
    })
    Util.New("UISizeConstraint", { MaxSize = Vector2.new(view.Source and 140 or 190, 18), Parent = title })
    if view.Source then
        local tag = Util.New("Frame", {
            AutomaticSize = Enum.AutomaticSize.X,
            Size = UDim2.fromOffset(0, 16),
            LayoutOrder = 3,
            Theme = { BackgroundColor3 = "Elevated", BackgroundTransparency = "ElevatedTransparency" },
            Parent = left,
        })
        Util.Corner(4, tag)
        Util.Padding(tag, 0, 6, 0, 6)
        Util.Label({ Text = self.Tab.Path or self.Tab.Title, TextSize = 10, Color = "TextMuted", Weight = Enum.FontWeight.Medium, AutomaticSize = Enum.AutomaticSize.X, Size = UDim2.fromScale(0, 1), Parent = tag })
    end
    local lockIcon = Util.Icon("lock", { Size = UDim2.fromOffset(12, 12), Color = "Danger", LayoutOrder = 4, Visible = self.Locked, Parent = left })

    local right = Util.New("Frame", { BackgroundTransparency = 1, AutomaticSize = Enum.AutomaticSize.X, Size = UDim2.fromScale(0, 1), LayoutOrder = 2, Parent = line })
    Util.List(right, 4, Enum.FillDirection.Horizontal, Enum.HorizontalAlignment.Right, Enum.VerticalAlignment.Center)
    local star = Util.New("ImageButton", {
        Size = UDim2.fromOffset(14, 14),
        Image = Util.IconId("star"),
        LayoutOrder = 1,
        Theme = {
            ImageColor3 = function(t) return self.Favorite and t.Warning or t.TextMuted end,
            -- touch has no hover: the star stays faintly visible
            ImageTransparency = function() return (self.Favorite and 0) or (hover and 0.25) or (Util.Touch() and 0.55) or 1 end,
        },
        Parent = right,
    })
    maid:Give(Tooltip.Attach(star, function() return self.Favorite and "Remove from favorites" or "Add to favorites" end))
    local bell
    if self.Toggleable then
        bell = Util.New("ImageButton", {
            Size = UDim2.fromOffset(14, 14),
            Image = Util.IconId(self.Notify and "bell-ring" or "bell"),
            LayoutOrder = 0,
            Theme = {
                ImageColor3 = function(t) return self.Notify and t.Accent or t.TextMuted end,
                ImageTransparency = function() return (self.Notify and 0) or (hover and 0.25) or (Util.Touch() and 0.55) or 1 end,
            },
            Parent = right,
        })
        maid:Give(Tooltip.Attach(bell, function() return self.Notify and "Mute on / off" or "Notify on / off" end))
        bell.MouseButton1Click:Connect(function() self:SetNotify(not self.Notify) end)
    end
    local grip
    if view.Page and view.Page.Draggable then
        grip = Util.New("ImageButton", {
            Size = UDim2.fromOffset(14, 14),
            Image = Util.IconId("grip-vertical"),
            LayoutOrder = 2,
            Theme = {
                ImageColor3 = "TextMuted",
                ImageTransparency = function() return (hover and 0.25) or (Util.Touch() and 0.55) or 1 end,
            },
            Parent = right,
        })
        maid:Give(Tooltip.Attach(grip, "Drag to rearrange"))
    end
    local headChevron
    if not self.Toggleable then
        headChevron = Util.Icon("chevron-down", { Size = UDim2.fromOffset(14, 14), Color = "TextMuted", LayoutOrder = 3, Parent = right })
    end

    local desc = Util.Label({
        Text = self.Description or "",
        TextSize = 11,
        Color = "TextMuted",
        TextWrapped = true,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        Visible = self:_showDescription(),
        LayoutOrder = 2,
        Parent = stack,
    })

    local switchPaint, chevron
    if self.Toggleable then
        local divider = Util.New("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 11), LayoutOrder = 3, Parent = stack })
        local rule = Util.New("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.new(1, 24, 0, 1),
            Theme = { BackgroundColor3 = "Divider" },
            Parent = divider,
        })
        Util.New("UIGradient", {
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.6),
                NumberSequenceKeypoint.new(0.5, 0),
                NumberSequenceKeypoint.new(1, 0.6),
            }),
            Parent = rule,
        })

        local bottom = Util.New("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 18), LayoutOrder = 4, Parent = stack })
        if self.Binding then
            local pill, connection = Widgets.KeyPill(bottom, self.Binding, { Position = UDim2.new(0, 0, 0.5, 0) })
            maid:Give(connection)
            pill.Name = "Key"
        end
        local controls = Util.New("Frame", {
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(1, 0),
            Position = UDim2.fromScale(1, 0),
            AutomaticSize = Enum.AutomaticSize.X,
            Size = UDim2.fromScale(0, 1),
            Parent = bottom,
        })
        Util.List(controls, 8, Enum.FillDirection.Horizontal, Enum.HorizontalAlignment.Right, Enum.VerticalAlignment.Center)
        if self.Color then self.Color:RenderInline(controls, maid, { LayoutOrder = 0, Width = 28, Height = 16 }) end
        chevron = Util.New("ImageButton", {
            Size = UDim2.fromOffset(16, 16),
            Image = Util.IconId("chevron-down"),
            LayoutOrder = 1,
            Visible = #self.Children > 0,
            Theme = { ImageColor3 = "TextMuted" },
            Parent = controls,
        })
        local switchHit = Util.New("TextButton", { BackgroundTransparency = 1, Size = UDim2.fromOffset(30, 16), LayoutOrder = 2, Parent = controls })
        local _, paint = Widgets.Switch(switchHit, { AnchorPoint = Vector2.zero, Position = UDim2.fromScale(0, 0) })
        switchPaint = paint
        switchPaint(self.Enabled, false)
        switchHit.MouseButton1Click:Connect(function() if not self.Locked then self:ToggleEnabled() end end)
        chevron.MouseButton1Click:Connect(function() self:SetExpanded(not self.Expanded) end)
    end

    -- body --------------------------------------------------------------------
    local body = Util.New("Frame", {
        Name = "Body",
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        Size = UDim2.new(1, 0, 0, 0),
        LayoutOrder = 2,
        Parent = card,
    })
    local options = Util.New("Frame", {
        Name = "Options",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        Parent = body,
    })
    -- 2 px on top: the body clips, a first control's outline would lose its top edge
    Util.Padding(options, 2, 12, 12, 12)
    Util.List(options, 9)
    self:_mountChildren(options, maid)

    local lockShade = Util.New("TextButton", {
        Name = "Lock",
        Size = UDim2.fromScale(1, 1),
        ZIndex = 30,
        Visible = self.Locked,
        Theme = { BackgroundColor3 = "Surface", BackgroundTransparency = function() return 0.45 end },
        Parent = body,
    })
    local function lockText()
        return Util.Touch() and "Locked. Hold the header to unlock." or "Locked. Right-click the header to unlock."
    end
    maid:Give(Tooltip.Attach(lockShade, lockText))
    lockShade.MouseButton1Click:Connect(function() Tooltip.Show(lockText()) end)

    local animating = 0
    local function height()
        return options.AbsoluteSize.Y / window:GetScale()
    end
    local function paintBody(animate)
        local open = self.Expanded and #self.Children > 0
        local goal = open and height() or 0
        if animate then
            animating += 1
            local mine = animating
            Util.Tween(body, 0.28, { Size = UDim2.new(1, 0, 0, goal) })
            task.delay(0.3 / math.max(Theme.Current.AnimSpeed or 1, 0.05), function()
                if mine ~= animating then return end
                animating = 0
                -- content that resized during the animation (wrapped text, late layouts) is caught up here
                if self.Expanded and #self.Children > 0 then body.Size = UDim2.new(1, 0, 0, height()) end
            end)
        else
            body.Size = UDim2.new(1, 0, 0, goal)
        end
        -- up while open: a click folds it; an image swap, Rotation does not render inside the clipping columns
        local arrow = Util.IconId(self.Expanded and "chevron-up" or "chevron-down")
        if chevron then
            chevron.Image = arrow
            chevron.Visible = #self.Children > 0
        end
        if headChevron then
            headChevron.Image = arrow
            headChevron.Visible = #self.Children > 0
        end
    end
    paintBody(false)
    maid:Give(options:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        -- no children: the padding alone would open an empty strip under the header
        if animating == 0 and self.Expanded and #self.Children > 0 then body.Size = UDim2.new(1, 0, 0, height()) end
    end))

    local function paint(what)
        if what == nil or what == "Title" then title.Text = self.Title end
        if what == nil or what == "Description" then
            desc.Text = self.Description or ""
            desc.Visible = self:_showDescription()
        end
        if what == nil or what == "Locked" then
            lockIcon.Visible = self.Locked
            lockShade.Visible = self.Locked
            Theme.Refresh(title, 0.15)
        end
        if what == "Visible" then card.Visible = self.Visible end
        if what == "Expanded" or what == "Children" then paintBody(what == "Expanded") end
        if what == "Favorite" then Theme.Refresh(star, 0.15) end
        if what == "Notify" and bell then
            bell.Image = Util.IconId(self.Notify and "bell-ring" or "bell")
            Theme.Refresh(bell, 0.15)
        end
    end
    maid:Give(self.StateChanged:Connect(paint))
    maid:Give(self.Changed:Connect(function(enabled)
        if switchPaint then switchPaint(enabled, true) end
        Theme.Refresh(stroke, 0.2)
    end))

    maid:Give(Util.Hover(card, function(on)
        hover = on
        Theme.Refresh(star, 0.12)
        if bell then Theme.Refresh(bell, 0.12) end
        if grip then Theme.Refresh(grip, 0.12) end
        Theme.Refresh(stroke, 0.12)
    end))

    star.MouseButton1Click:Connect(function() self:SetFavorite(not self.Favorite) end)
    if grip then
        grip.InputBegan:Connect(function(input)
            if Util.IsPress(input) then view.Page:BeginDrag(view, input) end
        end)
    end
    -- touch: a long press opens the menu that right-click opens with a mouse
    local press, consumed = Util.LongPress(hit, function(point) self:_menu(view, point) end)
    maid:Give(press)
    hit.MouseButton1Click:Connect(function()
        if consumed() then return end
        if self.Toggleable then
            if not self.Locked then self:ToggleEnabled() end
        else
            self:SetExpanded(not self.Expanded)
        end
    end)
    hit.MouseButton2Click:Connect(function()
        self:_menu(view, Util.Pointer())
    end)
    hit.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton3 then self:_capture() end
    end)

    view.Card = card
    return card
end

return Module
end

__modules["Components/Notification"] = function(...)
local import = ...
local Services = import("Core/Services")
local Util = import("Core/Util")
local Theme = import("Core/Theme")
local Layer = import("Components/Layer")

-- Scale multiplies every duration (Settings > Notifications); Max is how many show at once
local Notification = { Position = "BottomRight", Max = 5, Scale = 1 }
local holder, layout
local live = {}                                   -- Id -> handle while it is on screen

local KINDS = {
    Info    = { Color = "Accent", Icon = "info" },
    Success = { Color = "Success", Icon = "circle-check" },
    Warning = { Color = "Warning", Icon = "triangle-alert" },
    Error   = { Color = "Danger", Icon = "circle-x" },
}

local CORNERS = {
    BottomRight = { Vector2.new(1, 1), UDim2.new(1, -14, 1, -14), Enum.VerticalAlignment.Bottom, 1 },
    TopRight    = { Vector2.new(1, 0), UDim2.new(1, -14, 0, 14), Enum.VerticalAlignment.Top, 1 },
    BottomLeft  = { Vector2.new(0, 1), UDim2.new(0, 14, 1, -14), Enum.VerticalAlignment.Bottom, -1 },
    TopLeft     = { Vector2.new(0, 0), UDim2.new(0, 14, 0, 14), Enum.VerticalAlignment.Top, -1 },
}

local function ensure()
    if holder and holder.Parent then return end
    holder = Util.New("Frame", {
        Name = "Toasts",
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 300, 1, -28),
        ZIndex = 150,
        Parent = Layer.Root,
    })
    layout = Util.List(holder, 8)
    Notification.SetPosition(Notification.Position)
end

function Notification.SetPosition(name)
    local corner = CORNERS[name] or CORNERS.BottomRight
    Notification.Position = CORNERS[name] and name or "BottomRight"
    if not holder then return end
    holder.AnchorPoint = corner[1]
    holder.Position = corner[2]
    layout.VerticalAlignment = corner[3]
end

-- oldest first past Max
local function trim(keep)
    local toasts = {}
    for _, child in holder:GetChildren() do
        if child:IsA("Frame") and child ~= keep then table.insert(toasts, child) end
    end
    table.sort(toasts, function(a, b) return a.LayoutOrder < b.LayoutOrder end)
    for i = 1, #toasts - math.max(Notification.Max - 1, 0) do toasts[i]:Destroy() end
end

-- the look an update can change: kind (colour, icon) or explicit Color / Icon
local function look(options)
    local kind = KINDS[options.Type or "Info"] or KINDS.Info
    return options.Color or kind.Color, options.Icon or kind.Icon
end

-- options: Title, Content, Type (Info|Success|Warning|Error), Icon, Color (theme token or Color3), Duration,
--          Id (a toast with the same Id still on screen is updated in place: text, look and a fresh timer),
--          Buttons = { { Title, Callback } }
function Notification.Notify(options)
    ensure()
    options = type(options) == "string" and { Title = options } or options
    local current = options.Id ~= nil and live[options.Id]
    if current then
        current:Update(options)
        return current
    end
    trim()
    local side = CORNERS[Notification.Position][4]
    local state = {}
    state.Color, state.Icon = look(options)
    local function tint(t)
        return typeof(state.Color) == "Color3" and state.Color or t[state.Color] or t.Accent
    end

    local wrapper = Util.New("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        LayoutOrder = math.floor(os.clock() * 1000),
        ZIndex = 150,
        Parent = holder,
    })
    local card = Util.New("Frame", {
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        Position = UDim2.fromOffset(side * 330, 0),
        ZIndex = 151,
        Theme = {
            BackgroundColor3 = "Elevated",
            BackgroundTransparency = function(t) return math.min(t.ElevatedTransparency, 0.08) end,
        },
        Parent = wrapper,
    })
    Util.Corner("ElementRadius", card)
    Util.Stroke(card)

    local bar = Util.New("Frame", {
        Size = UDim2.new(0, 3, 1, -18),
        Position = UDim2.fromOffset(9, 9),
        ZIndex = 152,
        Theme = { BackgroundColor3 = tint },
        Parent = card,
    }, { Util.Corner(2) })
    local icon = Util.Icon(state.Icon, {
        Size = UDim2.fromOffset(16, 16),
        Position = UDim2.fromOffset(21, 12),
        Theme = { ImageColor3 = tint },
        ZIndex = 152,
        Parent = card,
    })

    local body = Util.New("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        ZIndex = 152,
        Parent = card,
    })
    Util.Padding(body, 11, 30, 13, 46)
    Util.List(body, 3)
    local title = Util.Label({
        Text = options.Title or "Notification",
        TextSize = 13,
        Weight = Enum.FontWeight.SemiBold,
        Size = UDim2.new(1, 0, 0, 18),
        TextTruncate = Enum.TextTruncate.AtEnd,
        LayoutOrder = 1,
        ZIndex = 153,
        Parent = body,
    })
    local content = Util.Label({
        Text = options.Content or "",
        TextSize = 12,
        Color = "TextDim",
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        TextWrapped = true,
        RichText = true,
        Visible = options.Content ~= nil and options.Content ~= "",
        LayoutOrder = 2,
        ZIndex = 153,
        Parent = body,
    })

    local progress = Util.New("Frame", {
        AnchorPoint = Vector2.new(0, 1),
        Position = UDim2.new(0, 10, 1, -3),
        Size = UDim2.new(1, -20, 0, 2),
        ZIndex = 153,
        Theme = { BackgroundColor3 = tint, BackgroundTransparency = function() return 0.35 end },
        Parent = card,
    }, { Util.Corner(1) })

    local closed = false
    local handle = { Id = options.Id }
    -- seconds left and the full span, restarted by Update
    local duration, left = 0, 0
    local function arm(seconds)
        seconds = seconds or 5
        duration = (seconds == math.huge or seconds <= 0) and seconds or seconds * Notification.Scale
        left = duration
        progress.Visible = duration ~= math.huge and duration > 0
        progress.Size = UDim2.new(1, -20, 0, 2)
    end
    arm(options.Duration)
    if options.Id ~= nil then live[options.Id] = handle end

    function handle:Close()
        if closed then return end
        closed = true
        if options.Id ~= nil and live[options.Id] == handle then live[options.Id] = nil end
        Util.Tween(card, 0.35, { Position = UDim2.fromOffset(side * 330, 0) }, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
        task.delay(0.36 / math.max(Theme.Current.AnimSpeed or 1, 0.05), function() wrapper:Destroy() end)
    end

    -- same toast, new text and look; the timer starts over
    function handle:Update(patch)
        if closed then return end
        if patch.Title then title.Text = patch.Title end
        if patch.Content ~= nil then
            content.Text = patch.Content
            content.Visible = patch.Content ~= ""
        end
        if patch.Type or patch.Color or patch.Icon then
            state.Color, state.Icon = look(patch)
            icon.Image = Util.IconId(state.Icon)
            Theme.Refresh(bar, 0.15)
            Theme.Refresh(icon, 0.15)
            Theme.Refresh(progress, 0.15)
        end
        arm(patch.Duration or options.Duration)
    end

    if options.Buttons and #options.Buttons > 0 then
        local row = Util.New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 24),
            LayoutOrder = 3,
            ZIndex = 153,
            Parent = body,
        })
        Util.List(row, 6, Enum.FillDirection.Horizontal)
        for index, spec in options.Buttons do
            local style = spec.Style or (index == 1 and "Primary" or "Secondary")
            local hover = { Hover = false }
            local button = Util.New("TextButton", {
                AutomaticSize = Enum.AutomaticSize.X,
                Size = UDim2.fromOffset(0, 22),
                LayoutOrder = index,
                ZIndex = 154,
                Theme = {
                    BackgroundColor3 = function(t)
                        local base = style == "Primary" and t.Accent or (style == "Danger" and t.Danger or t.ElevatedHover)
                        return hover.Hover and base:Lerp(t.Text, 0.12) or base
                    end,
                    TextColor3 = (style == "Primary" or style == "Danger") and "OnAccent" or "Text",
                    FontFace = Theme.Font(Enum.FontWeight.Medium),
                },
                Text = spec.Title,
                TextSize = 11,
                Parent = row,
            })
            Util.Corner(5, button)
            Util.Padding(button, 0, 10, 0, 10)
            Util.Feedback(button, hover)
            button.MouseButton1Click:Connect(function()
                Util.Safe(spec.Callback)
                if spec.KeepOpen ~= true then handle:Close() end
            end)
        end
    end

    local close = Util.New("ImageButton", {
        Size = UDim2.fromOffset(12, 12),
        Position = UDim2.new(1, -22, 0, 13),
        Image = Util.IconId("x"),
        ZIndex = 154,
        Theme = { ImageColor3 = "TextMuted" },
        Parent = card,
    })
    close.MouseButton1Click:Connect(function() handle:Close() end)

    Util.Tween(card, 0.45, { Position = UDim2.fromOffset(0, 0) })

    local hovered = false
    Util.Hover(card, function(on) hovered = on end)
    task.spawn(function()
        while not closed and wrapper.Parent do
            local dt = Services.RunService.Heartbeat:Wait()
            if not hovered and duration ~= math.huge and duration > 0 then
                left -= dt
                local share = math.max(left / duration, 0)
                progress.Size = UDim2.new(share, -20 * share, 0, 2)
                if left <= 0 then break end
            end
        end
        handle:Close()
    end)
    return handle
end

return Notification
end

__modules["Components/Overlays"] = function(...)
local import = ...
local Services = import("Core/Services")
local Util = import("Core/Util")
local Theme = import("Core/Theme")
local Drag = import("Core/Drag")
local Keybinds = import("Core/Keybinds")
local Layer = import("Components/Layer")

-- hud panels of a window: keybind list, watermark, mobile menu button
local Overlays = {}
Overlays.__index = Overlays

Overlays.KeybindDefaults = {
    Show = "All",                     -- "All" | "Active"
    Sort = "Added",                   -- "Added" | "Name" | "Key" | "Mode" | "Active first"
    Group = false,                    -- one caption per mode
    Layout = "Name · Key · Mode",     -- column order, see LAYOUTS
    ModeText = "Full",                -- "Full" | "Short" | "Hidden"
    KeyStyle = "Pill",                -- "Pill" | "Brackets" | "Plain"
    Title = true,
    MenuKey = false,
    HideWithMenu = false,
    Scale = 100,
    Width = 210,
    Transparency = 12,
}
Overlays.WatermarkDefaults = {
    Title = true,
    Fps = true,
    Ping = true,
    Time = true,
    User = false,
    Text = "",
    Scale = 100,
}
Overlays.Layouts = { "Name · Key · Mode", "Name · Mode · Key", "Mode · Name · Key", "Key · Name · Mode" }
Overlays.Sorts = { "Added", "Name", "Key", "Mode", "Active first" }
local LAYOUTS = {
    ["Name · Key · Mode"] = { "Name", "Key", "Mode" },
    ["Name · Mode · Key"] = { "Name", "Mode", "Key" },
    ["Mode · Name · Key"] = { "Mode", "Name", "Key" },
    ["Key · Name · Mode"] = { "Key", "Name", "Mode" },
}
local MODE_ORDER = { Toggle = 1, Hold = 2, Always = 3 }

local function defaults(target, source)
    for key, value in source do
        if target[key] == nil then target[key] = value end
    end
    return target
end

function Overlays.new(window)
    local interface = window.Interface
    interface.KeybindStyle = defaults(type(interface.KeybindStyle) == "table" and interface.KeybindStyle or {}, Overlays.KeybindDefaults)
    interface.WatermarkStyle = defaults(type(interface.WatermarkStyle) == "table" and interface.WatermarkStyle or {}, Overlays.WatermarkDefaults)
    local self = setmetatable({ Window = window, _queued = false }, Overlays)
    window.Maid:Give(Keybinds.Activity:Connect(function() self:RefreshBinds() end))
    return self
end

-- keeps a hud frame fully on screen (resolution changes, old saves)
local function clamp(frame)
    local bounds, size = Layer.Bounds(), frame.AbsoluteSize
    local position = frame.AbsolutePosition
    local x = math.clamp(position.X, 0, math.max(0, bounds.X - size.X))
    local y = math.clamp(position.Y, 0, math.max(0, bounds.Y - size.Y))
    frame.Position = UDim2.fromOffset(x, y)
end

-- positions are stored as absolute pixels, so a scale part can never get lost
local function savePosition(window, key, frame)
    clamp(frame)
    window.Interface[key] = { math.floor(frame.AbsolutePosition.X), math.floor(frame.AbsolutePosition.Y) }
    window:SaveState()
end

-- fallback(bounds) -> Vector2 for the first placement
local function restore(window, key, frame, fallback)
    local saved = window.Interface[key]
    local point = type(saved) == "table" and Vector2.new(tonumber(saved[1]) or 0, tonumber(saved[2]) or 0) or fallback(Layer.Bounds())
    frame.Position = UDim2.fromOffset(point.X, point.Y)
    task.defer(function() if frame.Parent then clamp(frame) end end)
    window.Maid:Give(workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
        task.defer(function() if frame.Parent then clamp(frame) end end)
    end))
end

local function keybindsHome(bounds) return Vector2.new(14, math.floor(bounds.Y * 0.4)) end
local function watermarkHome() return Vector2.new(14, 14) end
local function mobileHome(bounds) return Vector2.new(14, math.floor(bounds.Y * 0.5) - 23) end

-- keybind list ----------------------------------------------------------------

function Overlays:_buildBinds()
    local window = self.Window
    local style = window.Interface.KeybindStyle
    local frame = window.Maid:Give(Util.New("Frame", {
        Name = "Keybinds",
        Size = UDim2.fromOffset(style.Width, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        Active = true,
        Theme = {
            BackgroundColor3 = "Surface",
            BackgroundTransparency = function() return style.Transparency / 100 end,
        },
        Parent = Layer.Hud,
    }))
    Util.Corner(8, frame)
    Util.Stroke(frame)
    Util.Padding(frame, 8, 10, 9, 10)
    Util.List(frame, 4)
    local scale = Util.New("UIScale", { Scale = style.Scale / 100, Parent = frame })

    local head = Util.New("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 18), LayoutOrder = 0, Parent = frame })
    Util.Icon("keyboard", { Size = UDim2.fromOffset(13, 13), Position = UDim2.fromOffset(0, 2), Color = "Accent", Parent = head })
    Util.Label({ Text = "Keybinds", TextSize = 12, Weight = Enum.FontWeight.SemiBold, Position = UDim2.fromOffset(20, 0), Size = UDim2.new(1, -60, 1, 0), Parent = head })
    local counter = Util.Label({
        TextSize = 10,
        Color = "TextMuted",
        Weight = Enum.FontWeight.SemiBold,
        TextXAlignment = Enum.TextXAlignment.Right,
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.fromScale(1, 0),
        Size = UDim2.new(0, 40, 1, 0),
        Parent = head,
    })
    local rule = Util.New("Frame", { Size = UDim2.new(1, 0, 0, 1), LayoutOrder = 1, Theme = { BackgroundColor3 = "Divider" }, Parent = frame })
    Util.New("UIGradient", { Transparency = NumberSequence.new(0, 1), Parent = rule })

    restore(window, "KeybindListPos", frame, keybindsHome)
    window.Maid:Give(Drag.Attach(frame, frame, { OnEnd = function(moved) if moved then savePosition(window, "KeybindListPos", frame) end end }))
    self.Binds, self.BindScale, self.BindHead, self.BindRule, self.BindCounter = frame, scale, head, rule, counter
    self.BindRows = {}
end

function Overlays:SetKeybindList(on)
    local window = self.Window
    window.Interface.KeybindList = on and true or false
    if on and not self.Binds then self:_buildBinds() end
    self:UpdateVisibility()
    self:RefreshBinds()
end

function Overlays:SetKeybindStyle(key, value)
    local style = self.Window.Interface.KeybindStyle
    style[key] = value
    if self.Binds then
        self.Binds.Size = UDim2.fromOffset(style.Width, 0)
        self.BindScale.Scale = style.Scale / 100
        Theme.Refresh(self.Binds)
    end
    self:UpdateVisibility()
    self:RefreshBinds()
    self.Window:SaveState()
end

function Overlays:ResetPosition(which)
    local window = self.Window
    if which == "Keybinds" and self.Binds then
        window.Interface.KeybindListPos = nil
        local home = keybindsHome(Layer.Bounds())
        self.Binds.Position = UDim2.fromOffset(home.X, home.Y)
    elseif which == "Watermark" and self.Watermark then
        window.Interface.WatermarkPos = nil
        self.Watermark.Position = UDim2.fromOffset(14, 14)
    end
    window:SaveState()
end

function Overlays:UpdateVisibility()
    local window = self.Window
    if self.Binds then
        local style = window.Interface.KeybindStyle
        self.Binds.Visible = window.Interface.KeybindList and not (style.HideWithMenu and window.Visible)
    end
    if self.Watermark then self.Watermark.Visible = window.Interface.Watermark end
end

function Overlays:RefreshBinds()
    if not self.Binds or not self.Binds.Visible or self._queued then return end
    self._queued = true
    task.defer(function()
        self._queued = false
        self:_paintBinds()
    end)
end

-- every bound owner as { Title, Binding, Active, Order }
function Overlays:_entries()
    local window = self.Window
    local style = window.Interface.KeybindStyle
    local list = {}
    for order, owner in window._binds do
        local binding = owner.Binding
        if binding and binding.Key and owner.Visible ~= false then
            local title, active = owner:BindInfo()
            table.insert(list, { Title = title, Binding = binding, Active = active or binding.Held, Order = order })
        end
    end
    local menu = window.MenuBinding
    if style.MenuKey and menu and menu.Key then
        table.insert(list, { Title = "Menu", Binding = menu, Active = window.Visible, Order = 0 })
    end
    if style.Show == "Active" then
        for index = #list, 1, -1 do
            if not list[index].Active then table.remove(list, index) end
        end
    end
    local sort = style.Sort
    table.sort(list, function(a, b)
        if style.Group and a.Binding.Mode ~= b.Binding.Mode then
            return (MODE_ORDER[a.Binding.Mode] or 9) < (MODE_ORDER[b.Binding.Mode] or 9)
        end
        if sort == "Name" then return a.Title:lower() < b.Title:lower() end
        if sort == "Key" then return Util.KeyLabel(a.Binding.Key) < Util.KeyLabel(b.Binding.Key) end
        if sort == "Mode" and a.Binding.Mode ~= b.Binding.Mode then
            return (MODE_ORDER[a.Binding.Mode] or 9) < (MODE_ORDER[b.Binding.Mode] or 9)
        end
        if sort == "Active first" and a.Active ~= b.Active then return a.Active end
        return a.Order < b.Order
    end)
    return list
end

local function keyCell(parent, entry, style, order)
    local label = Util.KeyLabel(entry.Binding.Key)
    if style.KeyStyle == "Brackets" then label = "[" .. label .. "]" end
    local color = entry.Active and "Accent" or "TextMuted"
    if style.KeyStyle == "Pill" then
        local pill = Util.New("Frame", {
            AutomaticSize = Enum.AutomaticSize.X,
            Size = UDim2.fromOffset(0, 15),
            LayoutOrder = order,
            Theme = {
                BackgroundColor3 = entry.Active and "Accent" or "Elevated",
                BackgroundTransparency = function() return entry.Active and 0.75 or 0.2 end,
            },
            Parent = parent,
        })
        Util.Corner(4, pill)
        Util.Padding(pill, 0, 5, 0, 5)
        Util.Label({ Text = label, TextSize = 10, Weight = Enum.FontWeight.Bold, Color = color, AutomaticSize = Enum.AutomaticSize.X, Size = UDim2.fromScale(0, 1), Parent = pill })
        return pill
    end
    return Util.Label({ Text = label, TextSize = 10, Weight = Enum.FontWeight.Bold, Color = color, AutomaticSize = Enum.AutomaticSize.X, Size = UDim2.fromScale(0, 1), LayoutOrder = order, Parent = parent })
end

function Overlays:_paintBinds()
    local frame = self.Binds
    if not frame then return end
    local window = self.Window
    local style = window.Interface.KeybindStyle
    for _, row in self.BindRows do row:Destroy() end
    table.clear(self.BindRows)
    self.BindHead.Visible = style.Title
    self.BindRule.Visible = style.Title

    local entries = self:_entries()
    local active = 0
    for _, entry in entries do
        if entry.Active then active += 1 end
    end
    self.BindCounter.Text = active .. "/" .. #entries

    local columns = LAYOUTS[style.Layout] or LAYOUTS[Overlays.KeybindDefaults.Layout]
    local order, group = 2, nil
    for _, entry in entries do
        local mode = entry.Binding.Mode
        if style.Group and mode ~= group then
            group = mode
            local caption = Util.Label({
                Text = string.upper(mode),
                TextSize = 9,
                Weight = Enum.FontWeight.Bold,
                Color = "TextMuted",
                Size = UDim2.new(1, 0, 0, 14),
                LayoutOrder = order,
                Parent = frame,
            })
            table.insert(self.BindRows, caption)
            order += 1
        end
        local row = Util.New("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 17), LayoutOrder = order, Parent = frame })
        Util.List(row, 6, Enum.FillDirection.Horizontal, nil, Enum.VerticalAlignment.Center)
        for index, column in columns do
            if column == "Name" then
                local name = Util.Label({
                    Text = entry.Title,
                    TextSize = 11,
                    Weight = Enum.FontWeight.Medium,
                    Color = entry.Active and "Text" or "TextMuted",
                    TextTruncate = Enum.TextTruncate.AtEnd,
                    Size = UDim2.new(0, 0, 1, 0),
                    LayoutOrder = index,
                    Parent = row,
                })
                Util.New("UIFlexItem", { FlexMode = Enum.UIFlexMode.Fill, Parent = name })
            elseif column == "Key" then
                keyCell(row, entry, style, index)
            elseif column == "Mode" and style.ModeText ~= "Hidden" then
                Util.Label({
                    Text = style.ModeText == "Short" and mode:sub(1, 1) or mode,
                    TextSize = 10,
                    Color = "TextMuted",
                    AutomaticSize = Enum.AutomaticSize.X,
                    Size = UDim2.fromScale(0, 1),
                    LayoutOrder = index,
                    Parent = row,
                })
            end
        end
        table.insert(self.BindRows, row)
        order += 1
    end
    if #entries == 0 then
        table.insert(self.BindRows, Util.Label({
            Text = style.Show == "Active" and "Nothing active" or "No keys bound",
            TextSize = 11,
            Color = "TextMuted",
            Size = UDim2.new(1, 0, 0, 17),
            LayoutOrder = 2,
            Parent = frame,
        }))
    end
end

-- watermark -------------------------------------------------------------------

function Overlays:SetWatermark(on)
    local window = self.Window
    window.Interface.Watermark = on and true or false
    if on and not self.Watermark then
        local frame = window.Maid:Give(Util.New("Frame", {
            Name = "Watermark",
            AutomaticSize = Enum.AutomaticSize.X,
            Size = UDim2.fromOffset(0, 28),
            Active = true,
            Theme = { BackgroundColor3 = "Surface", BackgroundTransparency = function(t) return math.min(t.SurfaceTransparency, 0.12) end },
            Parent = Layer.Hud,
        }))
        Util.Corner(7, frame)
        Util.Stroke(frame)
        Util.Padding(frame, 0, 12, 0, 10)
        Util.List(frame, 8, Enum.FillDirection.Horizontal, nil, Enum.VerticalAlignment.Center)
        local logo = Util.Icon(window.Def.Icon or "sparkles", { Size = UDim2.fromOffset(14, 14), LayoutOrder = 1, Theme = { ImageColor3 = function() return Color3.new(1, 1, 1) end }, Parent = frame })
        Util.New("UIGradient", { Rotation = 45, Theme = { Color = function(t) return ColorSequence.new(t.Accent, t.AccentAlt) end }, Parent = logo })
        local text = Util.Label({ TextSize = 11, Weight = Enum.FontWeight.Medium, RichText = true, AutomaticSize = Enum.AutomaticSize.X, Size = UDim2.fromScale(0, 1), LayoutOrder = 2, Parent = frame })
        local scale = Util.New("UIScale", { Scale = window.Interface.WatermarkStyle.Scale / 100, Parent = frame })
        restore(window, "WatermarkPos", frame, watermarkHome)
        window.Maid:Give(Drag.Attach(frame, frame, { OnEnd = function(moved) if moved then savePosition(window, "WatermarkPos", frame) end end }))

        local frames, elapsed, fps = 0, 0, 0
        local function paint()
            local style = window.Interface.WatermarkStyle
            scale.Scale = style.Scale / 100
            local current = Theme.Current
            local accent = "#" .. current.Accent:ToHex()
            local muted = "#" .. current.TextMuted:ToHex()
            local parts = {}
            if style.Title then table.insert(parts, string.format('<font color="%s"><b>%s</b></font>', accent, window.TitleLabel.Text)) end
            local custom = self.WatermarkText
            if type(custom) == "function" then
                local ok, value = pcall(custom)
                custom = ok and value or nil
            end
            if custom and custom ~= "" then table.insert(parts, tostring(custom)) end
            if style.Text ~= "" then table.insert(parts, style.Text) end
            if style.User then table.insert(parts, Services.Players.LocalPlayer.DisplayName) end
            if style.Fps then table.insert(parts, fps .. " fps") end
            if style.Ping then
                local ping = 0
                pcall(function() ping = math.floor(Services.Players.LocalPlayer:GetNetworkPing() * 1000 + 0.5) end)
                table.insert(parts, ping .. " ms")
            end
            if style.Time then table.insert(parts, os.date("%H:%M")) end
            text.Text = table.concat(parts, string.format(' <font color="%s">|</font> ', muted))
        end
        window.Maid:Give(Services.RunService.RenderStepped:Connect(function(dt)
            frames += 1
            elapsed += dt
            if elapsed < 0.5 or not frame.Visible then return end
            fps = math.floor(frames / elapsed + 0.5)
            frames, elapsed = 0, 0
            paint()
        end))
        self.Watermark, self.PaintWatermark = frame, paint
        paint()
    end
    self:UpdateVisibility()
end

function Overlays:SetWatermarkStyle(key, value)
    self.Window.Interface.WatermarkStyle[key] = value
    if self.PaintWatermark then self.PaintWatermark() end
    self.Window:SaveState()
end

-- text or function shown after the title; set by scripts with Window:SetWatermark
function Overlays:SetWatermarkText(value)
    self.WatermarkText = value
    if self.PaintWatermark then self.PaintWatermark() end
end

-- mobile button ---------------------------------------------------------------

function Overlays:SetMobileButton(on)
    local window = self.Window
    if on and not self.Mobile then
        local button = window.Maid:Give(Util.New("ImageButton", {
            Name = "MenuButton",
            Size = UDim2.fromOffset(46, 46),
            Theme = { BackgroundColor3 = "Surface", BackgroundTransparency = function(t) return math.min(t.SurfaceTransparency, 0.1) end },
            Parent = Layer.Hud,
        }))
        Util.Corner(UDim.new(1, 0), button)
        Util.Stroke(button, "Accent", function() return 0.3 end, 1.5)
        local logo = Util.Icon(window.Def.Icon or "sparkles", {
            Size = UDim2.fromOffset(20, 20),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Theme = { ImageColor3 = function() return Color3.new(1, 1, 1) end },
            Parent = button,
        })
        Util.New("UIGradient", { Rotation = 45, Theme = { Color = function(t) return ColorSequence.new(t.Accent, t.AccentAlt) end }, Parent = logo })
        restore(window, "MobilePos", button, mobileHome)
        window.Maid:Give(Drag.Attach(button, button, {
            OnEnd = function(moved)
                if moved then
                    savePosition(window, "MobilePos", button)
                else
                    window:Toggle()
                end
            end,
        }))
        self.Mobile = button
    end
    if self.Mobile then self.Mobile.Visible = on and true or false end
end

return Overlays
end

__modules["Components/Page"] = function(...)
local import = ...
local Services = import("Core/Services")
local Util = import("Core/Util")
local Maid = import("Core/Maid")
local Drag = import("Core/Drag")

-- one or two scrolling columns of module cards; cards can be dragged between them
local Page = {}
Page.__index = Page

local GAP = 10

-- options: Id, Columns (1 | 2), Draggable, Source (cards show their tab), Empty (text), EmptyIcon, Parent
function Page.new(window, options)
    local self = setmetatable({
        Window = window,
        Id = options.Id,
        Draggable = options.Draggable == true,
        Source = options.Source == true,
        Views = {},
        Columns = {},
        _counter = 0,
    }, Page)

    self.Frame = Util.New("Frame", {
        Name = "Page",
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
        Visible = false,
        Parent = options.Parent or window.Content,
    })

    local count = math.clamp(options.Columns or 2, 1, 2)
    for index = 1, count do
        local column = Util.New("ScrollingFrame", {
            Name = "Column" .. index,
            Size = count == 1 and UDim2.fromScale(1, 1) or UDim2.new(0.5, -GAP / 2, 1, 0),
            Position = index == 1 and UDim2.new() or UDim2.new(0.5, GAP / 2, 0, 0),
            ScrollBarThickness = 2,
            ScrollingEnabled = true,
            Theme = { ScrollBarImageColor3 = "TextMuted" },
            Parent = self.Frame,
        })
        column.ScrollBarImageTransparency = 0.4
        local layout = Util.List(column, GAP)
        Util.Padding(column, 1, 6, 14, 1)
        Util.AutoCanvas(column, layout)
        self.Columns[index] = column
    end

    self.EmptyLabel = Util.Label({
        Text = options.Empty or "",
        TextSize = 12,
        Color = "TextMuted",
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Center,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.42),
        Size = UDim2.new(0.8, 0, 0, 40),
        Visible = false,
        Parent = self.Frame,
    })
    self.EmptyIcon = Util.Icon(options.EmptyIcon or "layers", {
        AnchorPoint = Vector2.new(0.5, 1),
        Position = UDim2.new(0.5, 0, 0.42, -24),
        Size = UDim2.fromOffset(28, 28),
        Color = "TextMuted",
        ImageTransparency = 0.4,
        Visible = false,
        Parent = self.Frame,
    })
    return self
end

function Page:_saved()
    return self.Window.State.Layout[self.Id]
end

function Page:SetEmpty(text)
    self.EmptyLabel.Text = text
end

function Page:UpdateEmpty()
    local empty = #self.Views == 0
    self.EmptyLabel.Visible = empty and self.EmptyLabel.Text ~= ""
    self.EmptyIcon.Visible = self.EmptyLabel.Visible
end

-- side: "Left" | "Right" | 1 | 2 | nil (fewest cards)
function Page:Add(module, side)
    local saved = self:_saved()
    local column, order
    if saved and self.Draggable then
        for index, ids in saved do
            local position = table.find(ids, module.Id)
            if position and self.Columns[index] then
                column, order = index, position
                break
            end
        end
    end
    if not column then
        if side == "Right" or side == 2 then
            column = 2
        elseif side == "Left" or side == 1 then
            column = 1
        else
            local counts = {}
            for index in self.Columns do counts[index] = 0 end
            for _, view in self.Views do counts[view.Column] = (counts[view.Column] or 0) + 1 end
            column = 1
            for index, count in counts do
                if count < counts[column] then column = index end
            end
        end
        column = math.min(column, #self.Columns)
        self._counter += 1
        order = 10000 + self._counter
    end

    local maid = Maid.new()
    local view = { Module = module, Page = self, Column = column, Maid = maid, Source = self.Source }
    local card = module:Render(self.Columns[column], maid, view)
    card.LayoutOrder = order
    view.Card = card
    table.insert(self.Views, view)
    self:UpdateEmpty()
    return view
end

function Page:Find(module)
    for index, view in self.Views do
        if view.Module == module then return view, index end
    end
    return nil
end

function Page:Remove(module)
    local view, index = self:Find(module)
    if not view then return end
    table.remove(self.Views, index)
    view.Maid:Clean()
    self:UpdateEmpty()
end

function Page:Clear()
    for _, view in self.Views do view.Maid:Clean() end
    table.clear(self.Views)
    self:UpdateEmpty()
end

local function sorted(page, column)
    local list = {}
    for _, view in page.Views do
        if view.Column == column then table.insert(list, view) end
    end
    table.sort(list, function(a, b) return a.Card.LayoutOrder < b.Card.LayoutOrder end)
    return list
end

function Page:SaveLayout()
    if not self.Draggable then return end
    local layout = {}
    for index in self.Columns do
        layout[index] = {}
        for position, view in sorted(self, index) do
            view.Card.LayoutOrder = position
            table.insert(layout[index], view.Module.Id)
        end
    end
    self.Window.State.Layout[self.Id] = layout
    self.Window:SaveState()
end

function Page:MoveToOther(view)
    local target = view.Column == 1 and 2 or 1
    if not self.Columns[target] then return end
    view.Column = target
    view.Card.Parent = self.Columns[target]
    view.Card.LayoutOrder = 1e6
    self:SaveLayout()
end

function Page:ResetLayout()
    self.Window.State.Layout[self.Id] = nil
    local modules = {}
    for _, view in self.Views do table.insert(modules, view.Module) end
    self:Clear()
    self._counter = 0
    for _, module in modules do self:Add(module, not self.Source and module.Def.Side or nil) end
    self.Window:SaveState()
end

-- drag a card by its grip; a placeholder marks where it lands
function Page:BeginDrag(view, input)
    if self.Dragging then return end
    local card = view.Card
    local window = self.Window
    local start = Util.Pointer(input)
    local last = start
    local started = false
    local placeholder, ghostOffset, autoscroll
    local target = view.Column

    local function columnAt(point)
        local best, distance = nil, math.huge
        for index, column in self.Columns do
            local left, width = column.AbsolutePosition.X, column.AbsoluteSize.X
            local d = point.X < left and left - point.X or (point.X > left + width and point.X - left - width or 0)
            if d < distance then best, distance = index, d end
        end
        return best
    end

    local function place(point)
        target = columnAt(point)
        local column = self.Columns[target]
        if placeholder.Parent ~= column then placeholder.Parent = column end
        -- even orders for the cards, the odd slot after the last card above the pointer
        local above = 0
        local position = 0
        for _, other in sorted(self, target) do
            if other ~= view then
                position += 1
                other.Card.LayoutOrder = position * 2
                local middle = other.Card.AbsolutePosition.Y + other.Card.AbsoluteSize.Y / 2
                if point.Y > middle then above = position end
            end
        end
        placeholder.LayoutOrder = above * 2 + 1
    end

    local function begin()
        started = true
        self.Dragging = true
        local scale = window:GetScale()
        placeholder = Util.New("Frame", {
            Name = "Placeholder",
            Size = UDim2.new(1, 0, 0, card.AbsoluteSize.Y / scale),
            LayoutOrder = card.LayoutOrder,
            Theme = { BackgroundColor3 = "Accent", BackgroundTransparency = function() return 0.88 end },
            Parent = card.Parent,
        })
        Util.Corner("ElementRadius", placeholder)
        Util.Stroke(placeholder, "Accent", function() return 0.45 end)
        ghostOffset = (start - card.AbsolutePosition) / scale
        local width = card.AbsoluteSize.X / scale
        card.Parent = window.DragLayer
        card.Size = UDim2.fromOffset(width, 0)
        autoscroll = Services.RunService.Heartbeat:Connect(function()
            -- the drag's own point: the mouse location is not the dragging finger on touch
            local point = last
            local column = self.Columns[target]
            if not column then return end
            local top, bottom = column.AbsolutePosition.Y, column.AbsolutePosition.Y + column.AbsoluteSize.Y
            if point.Y < top + 36 then
                column.CanvasPosition -= Vector2.new(0, 9)
            elseif point.Y > bottom - 36 then
                column.CanvasPosition += Vector2.new(0, 9)
            end
        end)
    end

    Drag.Follow(input, function(point)
        last = point
        if not started then
            if (point - start).Magnitude < 5 then return end
            begin()
        end
        local layer = window.DragLayer.AbsolutePosition
        local scale = window:GetScale()
        card.Position = UDim2.fromOffset((point.X - layer.X) / scale - ghostOffset.X, (point.Y - layer.Y) / scale - ghostOffset.Y)
        place(point)
    end, function()
        if not started then return end
        self.Dragging = false
        if autoscroll then autoscroll:Disconnect() end
        view.Column = target
        card.Parent = self.Columns[target]
        card.Position = UDim2.new()
        card.Size = UDim2.new(1, 0, 0, 0)
        card.LayoutOrder = placeholder.LayoutOrder
        placeholder:Destroy()
        self:SaveLayout()
    end, card)
end

return Page
end

__modules["Components/Panel"] = function(...)
local import = ...
local Util = import("Core/Util")
local Theme = import("Core/Theme")
local Maid = import("Core/Maid")
local Signal = import("Core/Signal")
local Drag = import("Core/Drag")
local Layer = import("Components/Layer")
local Container = import("Components/Container")
local Tooltip = import("Components/Tooltip")

-- small floating window that holds elements; Hud panels stay visible while the menu is hidden
-- def: Title, Icon, Id, Size (Vector2 | UDim2), Position (UDim2), Closable, Collapsible, Resizable, Hud, Visible,
--      AutoSize (height follows the content, no scrolling; default on for Hud panels), Scale (1 = 100 %),
--      Transparency (0-1, default from the theme), OnClose() (the user closed it)
local Panel = {}
Panel.__index = Panel
Container.Apply(Panel)

local HEAD = 34

function Panel.new(window, def)
    local self = setmetatable({
        Window = window,
        Def = def,
        Kind = "Panel",
        Title = def.Title or "Panel",
        Id = def.Id or def.Title or "Panel",
        Visible = def.Visible ~= false,
        Collapsed = false,
        AutoSize = def.AutoSize == true or (def.AutoSize == nil and def.Hud == true),
        ScaleFactor = def.Scale or 1,
        Transparency = def.Transparency,
        Closed = Signal.new(),
        Maid = Maid.new(),
    }, Panel)
    Container.Setup(self)
    self.Module = self
    window.Maid:Give(self.Maid)

    local size = def.Size or Vector2.new(260, 320)
    if typeof(size) == "Vector2" then size = UDim2.fromOffset(size.X, size.Y) end
    self.Size = size
    local frame = self.Maid:Give(Util.New("Frame", {
        Name = "Panel",
        Size = size,
        ClipsDescendants = true,
        Active = true,
        Visible = false,
        Theme = { BackgroundColor3 = "Background", BackgroundTransparency = function(t) return self.Transparency or math.min(t.WindowTransparency, 0.15) end },
        Parent = def.Hud and Layer.Hud or Layer.Main,
    }))
    self.Frame = frame
    Util.Corner("Radius", frame)
    Util.Stroke(frame)
    self.UIScale = Util.New("UIScale", { Parent = frame })
    self:_applyScale()

    local saved = window.Interface.Panels[self.Id]
    if type(saved) == "table" then
        frame.Position = UDim2.fromOffset(saved[1], saved[2])
    elseif def.Position then
        frame.Position = def.Position
    else
        -- next to the window: right side if it fits, else left, always on screen
        local root, bounds = window.Root, Layer.Bounds()
        local scale = self.UIScale.Scale
        local width, height = size.X.Offset * scale, size.Y.Offset * scale
        local x = root.AbsolutePosition.X + root.AbsoluteSize.X + 12
        if x + width > bounds.X - 8 then x = root.AbsolutePosition.X - width - 12 end
        x = math.clamp(x, 8, math.max(8, bounds.X - width - 8))
        local y = math.clamp(root.AbsolutePosition.Y, 8, math.max(8, bounds.Y - height - 8))
        frame.Position = UDim2.fromOffset(x, y)
    end

    local head = Util.New("Frame", { Name = "Head", BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, HEAD), Parent = frame })
    local x = 12
    if def.Icon then
        Util.Icon(def.Icon, { Size = UDim2.fromOffset(15, 15), Position = UDim2.new(0, 12, 0.5, -7), Color = "Accent", Parent = head })
        x = 34
    end
    self.TitleLabel = Util.Label({
        Text = self.Title,
        TextSize = 13,
        Weight = Enum.FontWeight.SemiBold,
        Position = UDim2.fromOffset(x, 0),
        Size = UDim2.new(1, -x - 60, 1, 0),
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = head,
    })
    local actions = Util.New("Frame", {
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -8, 0.5, 0),
        AutomaticSize = Enum.AutomaticSize.X,
        Size = UDim2.fromOffset(0, 22),
        Parent = head,
    })
    Util.List(actions, 2, Enum.FillDirection.Horizontal, Enum.HorizontalAlignment.Right, Enum.VerticalAlignment.Center)
    local function action(icon, order, tip, fn)
        local state = { Hover = false }
        local button = Util.New("ImageButton", {
            Size = UDim2.fromOffset(22, 22),
            LayoutOrder = order,
            Theme = { BackgroundColor3 = "ElevatedHover", BackgroundTransparency = function() return state.Hover and 0.3 or 1 end },
            Parent = actions,
        })
        Util.Corner(5, button)
        local image = Util.Icon(icon, { Size = UDim2.fromOffset(12, 12), Position = UDim2.fromOffset(5, 5), Color = "TextDim", Parent = button })
        Util.Feedback(button, state)
        if tip then self.Maid:Give(Tooltip.Attach(button, tip)) end
        button.MouseButton1Click:Connect(fn)
        return button, image
    end
    if def.Collapsible ~= false then
        local _, image
        _, image = action("chevron-up", 1, nil, function()
            self:SetCollapsed(not self.Collapsed)
            image.Image = Util.IconId(self.Collapsed and "chevron-down" or "chevron-up")
        end)
    end
    if def.Closable ~= false then
        action("x", 2, nil, function()
            self:SetVisible(false)
            Util.Safe(def.OnClose)
            self.Closed:Fire()
        end)
    end
    local rule = Util.New("Frame", { Position = UDim2.fromOffset(10, HEAD), Size = UDim2.new(1, -20, 0, 1), Theme = { BackgroundColor3 = "Divider" }, Parent = frame })
    Util.New("UIGradient", { Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.15, 0), NumberSequenceKeypoint.new(0.85, 0), NumberSequenceKeypoint.new(1, 1) }), Parent = rule })

    local body
    if self.AutoSize then
        -- a plain frame; the panel's height follows it
        body = Util.New("Frame", {
            Name = "Body",
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(0, HEAD + 1),
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            Parent = frame,
        })
        Util.Padding(body, 10, 12, 12, 12)
        local layout = Util.List(body, 9)
        local function fit()
            if not frame.Parent then return end
            local content = layout.AbsoluteContentSize.Y / math.max(Util.ScaleOf(body), 0.01)
            local height = HEAD + 1 + 10 + 12 + math.ceil(content)
            self.Size = UDim2.new(self.Size.X, UDim.new(0, height))
            if not self.Collapsed then frame.Size = self.Size end
        end
        self.Maid:Give(layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(fit))
        self._fit = fit
    else
        body = Util.New("ScrollingFrame", {
            Name = "Body",
            Position = UDim2.fromOffset(0, HEAD + 1),
            Size = UDim2.new(1, 0, 1, -HEAD - 1),
            ScrollBarThickness = 2,
            Theme = { ScrollBarImageColor3 = "TextMuted" },
            Parent = frame,
        })
        Util.Padding(body, 10, 12, 12, 12)
        Util.AutoCanvas(body, Util.List(body, 9))
    end
    self.Body = body
    self:_mountChildren(body, self.Maid)
    if self._fit then task.defer(self._fit) end

    self.Maid:Give(Drag.Attach(head, frame, {
        Enabled = function() return not Util.Contains(actions, Util.Pointer()) end,
        OnEnd = function(moved)
            if not moved then return end
            window.Interface.Panels[self.Id] = { math.floor(frame.AbsolutePosition.X), math.floor(frame.AbsolutePosition.Y) }
            frame.Position = UDim2.fromOffset(frame.AbsolutePosition.X, frame.AbsolutePosition.Y)
            window:SaveState()
        end,
    }))

    if def.Resizable then
        local grip = Util.Grip({ AnchorPoint = Vector2.new(1, 1), Position = UDim2.new(1, -2, 1, -2), Size = UDim2.fromOffset(14, 14), BackgroundTransparency = 1, ZIndex = 10, Parent = frame })
        grip.InputBegan:Connect(function(input)
            if not Util.IsPress(input) or self.Collapsed then return end
            local origin = frame.AbsoluteSize / self.UIScale.Scale
            Drag.Follow(input, function(_, delta)
                local scale = self.UIScale.Scale
                -- an auto-sized panel keeps its content height, only the width follows
                local height = self.AutoSize and self.Size.Y.Offset or math.max(origin.Y + delta.Y / scale, 120)
                frame.Size = UDim2.fromOffset(math.max(origin.X + delta.X / scale, 180), height)
            end, function()
                self.Size = frame.Size
            end)
        end)
    end

    self:SetVisible(self.Visible)
    return self
end

function Panel:_add(kind, a, b)
    return Container._add(self, kind, a, b)
end

function Panel:Matches(query)
    return self:_matchesChildren(query)
end

function Panel:_shown()
    return self.Visible and (self.Def.Hud or self.Window.Visible)
end

function Panel:SetVisible(visible)
    self.Visible = visible and true or false
    self.Frame.Visible = self:_shown()
end

function Panel:Show() self:SetVisible(true) end
function Panel:Hide() self:SetVisible(false) end
function Panel:ToggleVisible() self:SetVisible(not self.Visible) end

function Panel:SetCollapsed(collapsed)
    self.Collapsed = collapsed and true or false
    Util.Tween(self.Frame, 0.25, { Size = self.Collapsed and UDim2.new(self.Size.X, UDim.new(0, HEAD)) or self.Size })
end

-- multiplier (1 = 100 %); a Hud panel uses it alone, others on top of the window's scale
function Panel:SetScale(multiplier)
    self.ScaleFactor = math.max(tonumber(multiplier) or 1, 0.1)
    self:_applyScale()
end

function Panel:_applyScale()
    self.UIScale.Scale = self.ScaleFactor * (self.Def.Hud and 1 or self.Window:GetScale())
end

-- background transparency 0-1; nil goes back to the theme
function Panel:SetTransparency(value)
    self.Transparency = value
    Theme.Refresh(self.Frame)
end

function Panel:SetTitle(text)
    self.Title = text
    self.TitleLabel.Text = text
end

function Panel:Destroy()
    for _, child in table.clone(self.Children) do child:Destroy() end
    self.Closed:Destroy()
    local index = table.find(self.Window.Panels, self)
    if index then table.remove(self.Window.Panels, index) end
    self.Maid:Clean()
end

return Panel
end

__modules["Components/Popup"] = function(...)
local import = ...
local Services = import("Core/Services")
local Util = import("Core/Util")
local Maid = import("Core/Maid")
local Signal = import("Core/Signal")
local Layer = import("Components/Layer")
local Tooltip = import("Components/Tooltip")

-- one floating panel at a time, anchored to a gui object or a screen point
local UIS = Services.UserInputService
local Popup = { Current = nil }

local function scrollParent(gui)
    local node = gui.Parent
    while node do
        if node:IsA("ScrollingFrame") then return node end
        node = node.Parent
    end
    return nil
end

-- options: Anchor | Point, Width, Align ("Start" | "End"), Build(frame, popup), OnClose, Padding
function Popup.Open(options)
    if Popup.Current then Popup.Current:Close() end

    local maid = Maid.new()
    local popup = { Closed = Signal.new(), Maid = maid, Anchor = options.Anchor }
    local anchor = options.Anchor
    local scroller = anchor and scrollParent(anchor)
    local padding = options.Padding or 6

    local frame = maid:Give(Util.New("Frame", {
        Name = "Popup",
        AutomaticSize = Enum.AutomaticSize.Y,
        ZIndex = 100,
        Theme = { BackgroundColor3 = "Elevated" },
        Parent = Layer.Root,
    }))
    Util.Corner("ElementRadius", frame)
    Util.Stroke(frame, "Stroke", function(t) return math.max(t.StrokeTransparency - 0.15, 0) end)
    Util.Padding(frame, padding)
    local scale = Util.New("UIScale", { Scale = 0.96, Parent = frame })
    popup.Frame = frame

    local function width()
        if options.Width then return options.Width end
        if anchor then return math.max(anchor.AbsoluteSize.X / Layer.Scale, options.MinWidth or 150) end
        return 180
    end

    local function place()
        local w = width()
        frame.Size = UDim2.fromOffset(w, 0)
        local viewport = Layer.Bounds()
        local size = frame.AbsoluteSize
        local x, y
        if anchor then
            local position, anchorSize = anchor.AbsolutePosition, anchor.AbsoluteSize
            x = options.Align == "End" and position.X + anchorSize.X - size.X or position.X
            y = position.Y + anchorSize.Y + 4
            if y + size.Y > viewport.Y - 8 and position.Y - size.Y - 4 > 8 then
                y = position.Y - size.Y - 4
            end
        else
            x, y = options.Point.X, options.Point.Y
            if y + size.Y > viewport.Y - 8 then y = y - size.Y end
        end
        x = math.clamp(x, 8, math.max(8, viewport.X - size.X - 8))
        y = math.clamp(y, 8, math.max(8, viewport.Y - size.Y - 8))
        frame.Position = UDim2.fromOffset(x / Layer.Scale, y / Layer.Scale)
    end

    local closed = false
    function popup:Close()
        if closed then return end
        closed = true
        if Popup.Current == popup then Popup.Current = nil end
        if Tooltip.Owner == frame then Tooltip.Owner = nil end
        Tooltip.Hide()
        maid:Clean()
        Util.Safe(options.OnClose)
        popup.Closed:Fire()
        popup.Closed:Destroy()
    end

    -- tooltips of things under the popup would stick to the mouse
    Tooltip.Hide()
    Tooltip.Owner = frame
    if options.Build then options.Build(frame, popup) end
    place()
    Util.Tween(scale, 0.14, { Scale = 1 })

    maid:Give(Services.RunService.RenderStepped:Connect(function()
        if anchor then
            if not anchor:IsDescendantOf(game) or anchor.AbsoluteSize.X == 0 or not Util.Shown(anchor) then
                popup:Close()
                return
            end
            if scroller then
                local center = anchor.AbsolutePosition.Y + anchor.AbsoluteSize.Y / 2
                local top = scroller.AbsolutePosition.Y
                if center < top or center > top + scroller.AbsoluteSize.Y then
                    popup:Close()
                    return
                end
            end
        end
        place()
    end))

    -- the opening click is still being processed; ignore presses this frame
    local armed = false
    task.defer(function() armed = true end)
    maid:Give(UIS.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.Escape then
            popup:Close()
            return
        end
        if not armed then return end
        local kind = input.UserInputType
        if kind == Enum.UserInputType.MouseButton1 or kind == Enum.UserInputType.MouseButton2 or kind == Enum.UserInputType.Touch then
            local point = Util.Pointer(input)
            if Util.Contains(frame, point) then return end
            if anchor and Util.Contains(anchor, point) then return end
            popup:Close()
        end
    end))

    Popup.Current = popup
    return popup
end

function Popup.CloseAll()
    if Popup.Current then Popup.Current:Close() end
end

return Popup
end

__modules["Components/Row"] = function(...)
local import = ...
local Util = import("Core/Util")
local Theme = import("Core/Theme")
local Tooltip = import("Components/Tooltip")

-- standard element layout: title (+ description) left, widgets right, optional full-width area below
local Row = {}

-- options: Click (whole top line is a button), Below (create the below area), TopHeight
function Row.new(element, parent, maid, options)
    options = options or {}
    local row = {} :: any

    local frame = maid:Give(Util.New("Frame", {
        Name = element.Kind,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        Visible = element.Visible,
        Parent = parent,
    }))
    row.Frame = frame

    local content = Util.New("Frame", {
        Name = "Content",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        Parent = frame,
    })
    Util.List(content, 6)
    row.Content = content

    local top = Util.New("Frame", {
        Name = "Top",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, options.TopHeight or 20),
        AutomaticSize = Enum.AutomaticSize.Y,
        LayoutOrder = 1,
        Parent = content,
    })
    local topLayout = Util.List(top, 8, Enum.FillDirection.Horizontal)
    topLayout.VerticalAlignment = Enum.VerticalAlignment.Top
    row.Top = top

    local block = Util.New("Frame", {
        Name = "Text",
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 0, 0, options.TopHeight or 20),
        AutomaticSize = Enum.AutomaticSize.Y,
        LayoutOrder = 1,
        Parent = top,
    })
    Util.New("UIFlexItem", { FlexMode = Enum.UIFlexMode.Fill, Parent = block })
    Util.List(block, 1)

    local titleLine = Util.New("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, options.TopHeight or 20),
        LayoutOrder = 1,
        Parent = block,
    })
    Util.List(titleLine, 5, Enum.FillDirection.Horizontal, nil, Enum.VerticalAlignment.Center)
    local title = Util.Label({
        Text = element.Title,
        TextSize = 12,
        Weight = Enum.FontWeight.Medium,
        Size = UDim2.new(0, 0, 1, 0),
        AutomaticSize = Enum.AutomaticSize.X,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Theme = {
            TextColor3 = function(t)
                if element.Locked then return t.TextMuted end
                -- matches of the running search stand out
                local query = element.Window.Query
                if query and element:Matches(query) then return t.Accent end
                return element.Def.Risky and t.Danger or t.Text
            end,
        },
        LayoutOrder = 1,
        Parent = titleLine,
    })
    Util.New("UISizeConstraint", { MaxSize = Vector2.new(options.TitleMax or 220, math.huge), Parent = title })
    row.Title = title

    local lockIcon = Util.Icon("lock", {
        Size = UDim2.fromOffset(11, 11),
        Color = "TextMuted",
        LayoutOrder = 3,
        Visible = element.Locked,
        Parent = titleLine,
    })

    local info
    if element.Tooltip then
        -- a button: a tap shows the text on touch and does not reach the row's own click
        info = Util.New("ImageButton", {
            Size = UDim2.fromOffset(11, 11),
            Image = Util.IconId("info"),
            ScaleType = Enum.ScaleType.Fit,
            LayoutOrder = 2,
            Theme = { ImageColor3 = "TextMuted" },
            Parent = titleLine,
        })
        maid:Give(Tooltip.Attach(info, function() return element.Tooltip end))
        info.MouseButton1Click:Connect(function() Tooltip.Show(element.Tooltip) end)
    end

    local desc = Util.Label({
        Text = element.Description or "",
        TextSize = 11,
        Color = "TextMuted",
        TextWrapped = true,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        Visible = element.Description ~= nil and element.Description ~= "",
        LayoutOrder = 2,
        Parent = block,
    })
    row.Description = desc

    local right = Util.New("Frame", {
        Name = "Right",
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 0, 0, options.TopHeight or 20),
        AutomaticSize = Enum.AutomaticSize.X,
        LayoutOrder = 2,
        Parent = top,
    })
    Util.List(right, 6, Enum.FillDirection.Horizontal, Enum.HorizontalAlignment.Right, Enum.VerticalAlignment.Center)
    row.Right = right

    if options.Below then
        row.Below = Util.New("Frame", {
            Name = "Below",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            LayoutOrder = 2,
            Parent = content,
        })
    end

    if options.Click then
        -- sits under the content; labels and frames let presses through
        row.Button = Util.New("TextButton", {
            Name = "Hit",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            ZIndex = 0,
            Parent = frame,
        })
    end

    local overlay = Util.New("TextButton", {
        Name = "Lock",
        Size = UDim2.new(1, 8, 1, 6),
        Position = UDim2.fromOffset(-4, -3),
        ZIndex = 20,
        Visible = element.Locked,
        Theme = { BackgroundColor3 = "Surface", BackgroundTransparency = function() return 0.35 end },
        Parent = frame,
    })
    Util.Corner(6, overlay)
    maid:Give(Tooltip.Attach(overlay, function() return element.LockReason or "Locked" end))
    overlay.MouseButton1Click:Connect(function() Tooltip.Show(element.LockReason or "Locked") end)

    local function sync(what)
        if what == nil or what == "Title" then title.Text = element.Title end
        if what == nil or what == "Description" then
            desc.Text = element.Description or ""
            desc.Visible = element.Description ~= nil and element.Description ~= ""
        end
        if what == nil or what == "Locked" then
            overlay.Visible = element.Locked
            lockIcon.Visible = element.Locked
            Theme.Refresh(title, 0.15)
        end
        if what == nil or what == "Visible" then frame.Visible = element.Visible end
        if row.OnState then row.OnState(what) end
    end
    maid:Give(element.StateChanged:Connect(sync))

    return row
end

-- small rounded field used by inputs, dropdowns and value boxes
function Row.Field(parent, props)
    local hover = false
    local focused = false
    local field = Util.New(props.Button and "TextButton" or "Frame", {
        Name = props.Name or "Field",
        Size = props.Size or UDim2.new(1, 0, 0, 28),
        AnchorPoint = props.AnchorPoint,
        Position = props.Position,
        LayoutOrder = props.LayoutOrder or 0,
        AutomaticSize = props.AutomaticSize,
        Theme = {
            BackgroundColor3 = function(t) return hover and t.ElevatedHover or t.Elevated end,
            BackgroundTransparency = "ElevatedTransparency",
        },
        Parent = parent,
    })
    Util.Corner(props.Radius or 6, field)
    local stroke = Util.Stroke(field, function(t) return focused and t.Accent or t.Stroke end, function(t) return focused and 0.2 or t.StrokeTransparency + 0.1 end)
    Util.Hover(field, function(on) hover = on; Theme.Refresh(field, 0.12) end)
    local api = {}
    function api.SetFocused(on)
        focused = on
        Theme.Refresh(stroke, 0.15)
    end
    function api.SetStroke(token)
        Theme.Bind(stroke, { Color = function(t) return token and t[token] or (focused and t.Accent or t.Stroke) end })
    end
    return field, api
end

return Row
end

__modules["Components/ScreenButton"] = function(...)
local import = ...
local Services = import("Core/Services")
local Util = import("Core/Util")
local Theme = import("Core/Theme")
local Drag = import("Core/Drag")
local Layer = import("Components/Layer")

-- on-screen buttons for touch screens: a pill in the hud layer that stays while the menu is hidden;
-- menu hidden: a press runs Press, its end runs Release; menu open: dimmed, a drag moves it
-- def: Id (the saved position is keyed by this), Title, Icon, Active() -> bool (green while true),
--      Press(), Release(), Visible (default true), Position (UDim2, first placement)
local ScreenButton = {}
ScreenButton.__index = ScreenButton

local UIS = Services.UserInputService
local HEIGHT = 36

-- keeps the pill fully on screen (resolution changes, old saves)
local function clamp(frame)
    local bounds, size = Layer.Bounds(), frame.AbsoluteSize
    local position = frame.AbsolutePosition
    frame.Position = UDim2.fromOffset(
        math.clamp(position.X, 0, math.max(0, bounds.X - size.X)),
        math.clamp(position.Y, 0, math.max(0, bounds.Y - size.Y)))
end

function ScreenButton.new(window, def)
    local self = setmetatable({
        Window = window,
        Def = def,
        Id = def.Id or def.Title or "Button",
        Visible = def.Visible ~= false,
        Active = false,
        _held = nil,
    }, ScreenButton)
    local interface = window.Interface
    interface.Buttons = type(interface.Buttons) == "table" and interface.Buttons or {}

    local button = window.Maid:Give(Util.New("TextButton", {
        Name = "ScreenButton",
        Size = UDim2.fromOffset(0, HEIGHT),
        AutomaticSize = Enum.AutomaticSize.X,
        Visible = false,
        Theme = {
            BackgroundColor3 = "Surface",
            BackgroundTransparency = function()
                local base = (tonumber(interface.ButtonTransparency) or 15) / 100
                return window.Visible and math.max(base, 0.45) or base
            end,
        },
        Parent = Layer.Hud,
    }))
    Util.Corner(UDim.new(1, 0), button)
    Util.Padding(button, 0, 14, 0, def.Icon and 10 or 14)
    Util.List(button, 6, Enum.FillDirection.Horizontal, Enum.HorizontalAlignment.Center, Enum.VerticalAlignment.Center)
    self.Stroke = Util.Stroke(button, function(t) return self.Active and t.Success or t.Stroke end, function(t)
        return self.Active and 0.1 or t.StrokeTransparency
    end, 1.5)
    if def.Icon then
        self.IconLabel = Util.Icon(def.Icon, {
            Size = UDim2.fromOffset(15, 15),
            LayoutOrder = 1,
            Theme = { ImageColor3 = function(t) return self.Active and t.Success or t.TextDim end },
            Parent = button,
        })
    end
    self.Label = Util.Label({
        Text = def.Title or "",
        TextSize = 13,
        Weight = Enum.FontWeight.SemiBold,
        AutomaticSize = Enum.AutomaticSize.X,
        Size = UDim2.fromScale(0, 1),
        LayoutOrder = 2,
        Theme = {
            TextColor3 = function(t) return self.Active and t.Success or t.Text end,
            TextTransparency = function() return window.Visible and 0.4 or 0 end,
        },
        Parent = button,
    })
    self.Scale = Util.New("UIScale", { Parent = button })
    self.Frame = button

    local saved = interface.Buttons[self.Id]
    if type(saved) == "table" then
        button.Position = UDim2.fromOffset(tonumber(saved[1]) or 0, tonumber(saved[2]) or 0)
    else
        button.Position = def.Position or UDim2.new(1, -140, 0.25, #window.ScreenButtons * (HEIGHT + 8))
    end
    window.Maid:Give(workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
        task.defer(function() if button.Parent then clamp(button) end end)
    end))

    -- menu open: a drag moves it; menu hidden: a press presses
    window.Maid:Give(Drag.Attach(button, button, {
        Enabled = function() return window.Visible end,
        OnEnd = function(moved)
            if not moved then return end
            clamp(button)
            interface.Buttons[self.Id] = { math.floor(button.AbsolutePosition.X), math.floor(button.AbsolutePosition.Y) }
            button.Position = UDim2.fromOffset(button.AbsolutePosition.X, button.AbsolutePosition.Y)
            window:SaveState()
        end,
    }))
    window.Maid:Give(button.InputBegan:Connect(function(input)
        if window.Visible or self._held or not Util.IsPress(input) then return end
        self._held = input
        -- a cancelled touch fires no InputEnded
        local watch
        watch = input.Changed:Connect(function(property)
            if property ~= "UserInputState" then return end
            local state = input.UserInputState
            if state == Enum.UserInputState.End or state == Enum.UserInputState.Cancel then
                watch:Disconnect()
                if self._held == input then self:_release() end
            end
        end)
        Util.Safe(def.Press)
        self:Refresh()
    end))
    window.Maid:Give(UIS.InputEnded:Connect(function(input)
        if input == self._held then self:_release() end
    end))
    self:ApplyStyle()
    self:SetVisible(self.Visible)
    return self
end

function ScreenButton:_release()
    if not self._held then return end
    self._held = nil
    Util.Safe(self.Def.Release)
    self:Refresh()
end

-- repaints the active state; the window polls every shown button
function ScreenButton:Refresh()
    local active = false
    if self.Def.Active then
        local ok, value = pcall(self.Def.Active)
        active = ok and value and true or false
    end
    self.Active = active
    for _, inst in { self.Frame, self.Stroke, self.Label, self.IconLabel } do Theme.Refresh(inst, 0.12) end
end

function ScreenButton:ApplyStyle()
    self.Scale.Scale = (tonumber(self.Window.Interface.ButtonScale) or 100) / 100
    self:Refresh()
end

function ScreenButton:SetVisible(visible)
    self.Visible = visible and true or false
    if not self.Visible then self:_release() end
    self.Frame.Visible = self.Visible
    if self.Visible then
        self:Refresh()
        task.defer(function() if self.Frame.Parent then clamp(self.Frame) end end)
    end
end

function ScreenButton:SetTitle(text)
    self.Label.Text = text
end

function ScreenButton:Destroy()
    self:_release()
    self.Frame:Destroy()
    local list = self.Window.ScreenButtons
    local index = table.find(list, self)
    if index then table.remove(list, index) end
end

return ScreenButton
end

__modules["Components/Tab"] = function(...)
local import = ...
local Util = import("Core/Util")
local Theme = import("Core/Theme")
local Page = import("Components/Page")
local Module = import("Components/Module")

-- a sidebar entry with its own page of modules, optionally split into sub-tabs
-- def: Title, Icon, Columns (1 | 2), Id, Draggable, Empty
local Tab = {}
Tab.__index = Tab

local BAR = 30

function Tab.new(window, def, parent)
    local self = setmetatable({
        Window = window,
        Def = def,
        Title = def.Title or def.Name or "Tab",
        Icon = def.Icon,
        Modules = {},
        Parent = parent,
    }, Tab)
    self.Id = parent and (parent.Id .. "/" .. (def.Id or self.Title)) or (def.Id or self.Title)
    self.Path = parent and (parent.Title .. " › " .. self.Title) or self.Title
    self.Page = Page.new(window, {
        Id = "tab:" .. self.Id,
        Columns = def.Columns or 2,
        Draggable = def.Draggable ~= false,
        Empty = def.Empty or "Nothing here yet.",
        Parent = parent and parent.SubArea,
    })
    self.Frame = self.Page.Frame
    return self
end

-- def: see Components/Module
function Tab:Module(def)
    def = def or {}
    local module = Module.new(self, def)
    table.insert(self.Modules, module)
    self.Page:Add(module, def.Side)
    if module.Favorite then self.Window:_addFavoriteView(module) end
    return module
end
Tab.AddModule = Tab.Module
Tab.Feature = Tab.Module

-- a card without switch or key, open by default
function Tab:Section(def)
    if type(def) == "string" then def = { Title = def } end
    def = def or {}
    def.Toggle = false
    return self:Module(def)
end
Tab.AddSection = Tab.Section

function Tab:Select()
    self.Window:SelectTab(self)
end

function Tab:SetTitle(text)
    self.Title = text
    if self.Entry then self.Entry.Label.Text = text end
    if self.Chip then self.Chip.Label.Text = text end
end

-- hides the sidebar entry (or the sub-tab chip) without removing anything
function Tab:SetVisible(visible)
    self.Visible = visible ~= false
    local button = (self.Entry and self.Entry.Button) or (self.Chip and self.Chip.Button)
    if button then button.Visible = self.Visible end
end

function Tab:ResetLayout()
    self.Page:ResetLayout()
    for _, sub in self.SubTabs or {} do
        if sub ~= self.Shared then sub.Page:ResetLayout() end
    end
end

-- sub-tabs ----------------------------------------------------------------------

function Tab:_enableSubTabs()
    if self.SubTabs then return end
    local window = self.Window
    self.SubTabs = {}
    local holder = Util.New("Frame", {
        Name = "SubTabs",
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
        Visible = self.Page.Frame.Visible,
        Parent = window.Content,
    })
    local bar = Util.New("ScrollingFrame", {
        Name = "Bar",
        Size = UDim2.new(1, 0, 0, BAR),
        ScrollingDirection = Enum.ScrollingDirection.X,
        Parent = holder,
    })
    -- room for the selected chip's outline, a scrolling frame clips it otherwise
    Util.Padding(bar, 0, 2, 0, 2)
    Util.AutoCanvas(bar, Util.List(bar, 4, Enum.FillDirection.Horizontal, nil, Enum.VerticalAlignment.Center), true)
    self.SubArea = Util.New("Frame", {
        Name = "Area",
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(0, BAR + 8),
        Size = UDim2.new(1, 0, 1, -BAR - 8),
        Parent = holder,
    })
    self.SubBar, self.SubFrame = bar, holder
    self.Frame = holder

    -- modules added straight to the tab become its first sub-tab
    if #self.Modules > 0 then
        local shared = setmetatable({
            Window = window,
            Def = { Title = self.Def.MainTitle or "General" },
            Title = self.Def.MainTitle or "General",
            Modules = self.Modules,
            Parent = self,
            Page = self.Page,
            Frame = self.Page.Frame,
        }, Tab)
        shared.Id, shared.Path = self.Id, self.Title
        self.Page.Frame.Parent = self.SubArea
        self.Shared = shared
        self:_chip(shared)
    else
        -- the tab's own page goes unused; a tab shown before its first sub-tab (first or restored tab) left it
        -- visible on top of every page, where its empty columns swallowed the mouse wheel
        self.Page.Frame.Visible = false
    end
end

function Tab:_chip(sub)
    local state = { Selected = false, Hover = false }
    local button = Util.New("TextButton", {
        AutomaticSize = Enum.AutomaticSize.X,
        Size = UDim2.fromOffset(0, 26),
        LayoutOrder = #self.SubTabs + 1,
        Theme = {
            BackgroundColor3 = "Elevated",
            BackgroundTransparency = function(t)
                if state.Selected then return t.ElevatedTransparency end
                return state.Hover and math.min(t.ElevatedTransparency + 0.45, 0.85) or 1
            end,
        },
        Parent = self.SubBar,
    })
    Util.Corner(6, button)
    Util.Padding(button, 0, 11, 0, sub.Icon and 9 or 11)
    Util.List(button, 6, Enum.FillDirection.Horizontal, nil, Enum.VerticalAlignment.Center)
    local stroke = Util.Stroke(button, function(t) return state.Selected and t.Accent or t.Stroke end, function(t)
        return state.Selected and 0.55 or 1
    end)
    local icon
    if sub.Icon then
        icon = Util.Icon(sub.Icon, {
            Size = UDim2.fromOffset(13, 13),
            LayoutOrder = 1,
            Theme = { ImageColor3 = function(t) return state.Selected and t.Accent or t.TextMuted end },
            Parent = button,
        })
    end
    local label = Util.Label({
        Text = sub.Title,
        TextSize = 12,
        Weight = Enum.FontWeight.Medium,
        AutomaticSize = Enum.AutomaticSize.X,
        Size = UDim2.fromScale(0, 1),
        LayoutOrder = 2,
        Theme = { TextColor3 = function(t) return state.Selected and t.Text or (state.Hover and t.TextDim or t.TextMuted) end },
        Parent = button,
    })
    local function paint()
        for _, inst in { button, stroke, label, icon } do Theme.Refresh(inst, 0.15) end
    end
    sub.Chip = { Button = button, Label = label, State = state, Paint = paint }
    Util.Hover(button, function(on) state.Hover = on; paint() end)
    button.MouseButton1Click:Connect(function() self.Window:SelectTab(sub) end)
    table.insert(self.SubTabs, sub)
    if not self.ActiveSub then self:_showSub(sub, true) end
end

-- def: Title, Icon, Columns, Id, Draggable, Empty
function Tab:SubTab(def)
    if type(def) == "string" then def = { Title = def } end
    def = def or {}
    self:_enableSubTabs()
    local sub = Tab.new(self.Window, def, self)
    self:_chip(sub)
    local saved = self.Window.Interface.SubTabs[self.Id]
    if saved == sub.Id then self:_showSub(sub, true) end
    return sub
end
Tab.AddSubTab = Tab.SubTab

function Tab:_showSub(sub, silent)
    self.ActiveSub = sub
    for _, other in self.SubTabs do
        local selected = other == sub
        other.Page.Frame.Visible = selected
        if other.Chip.State.Selected ~= selected then
            other.Chip.State.Selected = selected
            other.Chip.Paint()
        end
    end
    if not silent then
        self.Window.Interface.SubTabs[self.Id] = sub.Id
        self.Window:SaveState()
    end
end

-- the page that holds a module of this tab
function Tab:PageOf(module)
    if self.Page:Find(module) then return self.Page end
    for _, sub in self.SubTabs or {} do
        if sub.Page:Find(module) then return sub.Page end
    end
    return nil
end

return Tab
end

__modules["Components/TextArea"] = function(...)
local import = ...
local Services = import("Core/Services")
local Util = import("Core/Util")

-- multiline text that scrolls. AutomaticSize cannot grow a box past the canvas of the scrolling frame
-- around it, so the box is sized from its measured text; while typing the view follows the caret
local TextArea = {}

local TextService = Services.TextService

-- props: Size, Position, LayoutOrder, ZIndex, Parent, Padding (inner, default 6), and Box = TextBox props
-- (Theme included); returns the scrolling frame, the box and refit() for a font or width change
function TextArea.new(props)
    local pad = props.Padding or 6
    local scroll = Util.New("ScrollingFrame", {
        Size = props.Size,
        Position = props.Position or UDim2.new(),
        LayoutOrder = props.LayoutOrder or 0,
        ZIndex = props.ZIndex or 1,
        ScrollBarThickness = 3,
        AutomaticCanvasSize = Enum.AutomaticSize.None,
        CanvasSize = UDim2.new(),
        ScrollingDirection = Enum.ScrollingDirection.Y,
        Theme = { ScrollBarImageColor3 = "TextMuted" },
        Parent = props.Parent,
    })
    local boxProps = table.clone(props.Box or {})
    boxProps.Size = UDim2.new(1, -pad * 2, 0, 0)
    boxProps.Position = UDim2.fromOffset(pad, pad)
    boxProps.MultiLine = true
    boxProps.TextWrapped = true
    boxProps.TextXAlignment = Enum.TextXAlignment.Left
    boxProps.TextYAlignment = Enum.TextYAlignment.Top
    boxProps.ZIndex = (props.ZIndex or 1) + 1
    boxProps.Parent = scroll
    local box = Util.New("TextBox", boxProps)

    local function scale() return math.max(Util.ScaleOf(scroll), 0.01) end

    -- text height at the box width in offset units; nil when it cannot be measured now
    local function measure(text)
        local width = box.AbsoluteSize.X / scale()
        if width < 4 then return nil end
        local params = Instance.new("GetTextBoundsParams")
        params.Text = text ~= "" and text or " "
        params.Font = box.FontFace
        params.Size = box.TextSize
        params.Width = width
        local ok, bounds = pcall(TextService.GetTextBoundsAsync, TextService, params)
        if not ok then return nil end
        -- a trailing newline starts a line the measure leaves out
        local height = bounds.Y
        if text:sub(-1) == "\n" then height += box.TextSize * box.LineHeight end
        return height
    end

    -- the caret line inside the view, nothing scrolled otherwise
    local function follow(textHeight)
        if not box:IsFocused() then return end
        local caret = box.CursorPosition
        if caret < 1 then return end
        local view = scroll.AbsoluteSize.Y / scale()
        local line = box.TextSize * box.LineHeight
        local bottom
        if caret > #box.Text then
            bottom = textHeight
        else
            bottom = measure(box.Text:sub(1, caret - 1)) or textHeight
        end
        local top = bottom - line
        local at = scroll.CanvasPosition.Y
        if bottom + pad > at + view then
            scroll.CanvasPosition = Vector2.new(0, bottom + pad - view)
        elseif top < at then
            scroll.CanvasPosition = Vector2.new(0, math.max(top - pad, 0))
        end
    end

    local token = 0
    local function refit(followCaret)
        token += 1
        local mine = token
        task.spawn(function()
            local height = measure(box.Text)
            if mine ~= token or not height or not box.Parent then return end
            local view = scroll.AbsoluteSize.Y / scale()
            local total = math.max(math.ceil(height) + pad * 2, view)
            box.Size = UDim2.new(1, -pad * 2, 0, total - pad * 2)
            box.Position = UDim2.fromOffset(pad, pad)
            scroll.CanvasSize = UDim2.fromOffset(0, total)
            if followCaret then follow(height) end
        end)
    end

    box:GetPropertyChangedSignal("Text"):Connect(function() refit(true) end)
    box:GetPropertyChangedSignal("CursorPosition"):Connect(function()
        if box:IsFocused() then refit(true) end
    end)
    box:GetPropertyChangedSignal("FontFace"):Connect(function() refit(false) end)
    scroll:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() refit(false) end)
    task.defer(refit, false)
    return scroll, box, refit
end

return TextArea
end

__modules["Components/Tooltip"] = function(...)
local import = ...
local Services = import("Core/Services")
local Util = import("Core/Util")
local Layer = import("Components/Layer")

-- one shared hover label; shows after a short delay and follows the mouse
-- touch: placed once at the finger, hidden after a moment or by the next touch
local Tooltip = {}
local TOUCH_TIME = 2.5
Tooltip.Delay = 0.5                                  -- hover time before a tooltip shows
Tooltip.Enabled = true
local frame, label, follow, touchHide
local token = 0
-- while a popup is open only its own controls show tooltips (set by Popup)
Tooltip.Owner = nil

local function ensure()
    if frame and frame.Parent then return end
    frame = Util.New("Frame", {
        Name = "Tooltip",
        AutomaticSize = Enum.AutomaticSize.XY,
        Visible = false,
        ZIndex = 200,
        Theme = { BackgroundColor3 = "Elevated" },
        Parent = Layer.Root,
    })
    Util.Corner(5, frame)
    Util.Stroke(frame)
    Util.Padding(frame, 5, 8, 5, 8)
    Util.New("UISizeConstraint", { MaxSize = Vector2.new(240, math.huge), Parent = frame })
    label = Util.Label({
        TextSize = 11,
        Color = "TextDim",
        AutomaticSize = Enum.AutomaticSize.XY,
        TextWrapped = true,
        ZIndex = 201,
        Parent = frame,
    })
end

local function hide()
    token += 1
    if follow then follow:Disconnect(); follow = nil end
    if touchHide then touchHide:Disconnect(); touchHide = nil end
    if frame then frame.Visible = false end
end

local function place()
    local mouse = Util.Pointer()
    local viewport = Layer.Bounds()
    local size = frame.AbsoluteSize
    local x = math.clamp(mouse.X + 14, 6, math.max(6, viewport.X - size.X - 6))
    local y = mouse.Y + 18
    if y + size.Y > viewport.Y - 6 then y = mouse.Y - size.Y - 8 end
    frame.Position = UDim2.fromOffset(x / Layer.Scale, y / Layer.Scale)
end

local function show(text)
    ensure()
    label.Text = text
    frame.Visible = true
    if follow then follow:Disconnect(); follow = nil end
    if touchHide then touchHide:Disconnect(); touchHide = nil end
    if Util.Touch() then
        place()
        task.defer(place)                            -- again once the label has its size
        local mine = token
        task.delay(TOUCH_TIME, function() if mine == token then hide() end end)
        touchHide = Services.UserInputService.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch then hide() end
        end)
    else
        follow = Services.RunService.RenderStepped:Connect(place)
    end
end

-- text may be a function evaluated on hover; returns connections for a maid
-- touch has no hover: taps on info icons and locks call Tooltip.Show instead
function Tooltip.Attach(gui, text)
    local enter = gui.MouseEnter:Connect(function()
        if Util.Touch() or not Tooltip.Enabled then return end
        token += 1
        local mine = token
        task.delay(Tooltip.Delay, function()
            if mine ~= token then return end
            local owner = Tooltip.Owner
            if owner and owner.Parent and not gui:IsDescendantOf(owner) then return end
            -- a function may return nil (no tooltip right now)
            local value = if type(text) == "function" then text() else text
            if type(value) == "string" and value ~= "" then show(value) end
        end)
    end)
    local leave = gui.MouseLeave:Connect(hide)
    local gone = gui.AncestryChanged:Connect(function(_, parent)
        if not parent then hide() end
    end)
    return {
        Disconnect = function()
            enter:Disconnect()
            leave:Disconnect()
            gone:Disconnect()
        end,
    }
end

Tooltip.Hide = hide

-- shows text right away, e.g. for a tap on an info icon
function Tooltip.Show(text)
    if not Tooltip.Enabled then return end
    token += 1
    if type(text) == "string" and text ~= "" then show(text) end
end

return Tooltip
end

__modules["Components/Widgets"] = function(...)
local import = ...
local Util = import("Core/Util")
local Theme = import("Core/Theme")
local Menu = import("Components/Menu")
local Tooltip = import("Components/Tooltip")

-- small controls shared by modules and elements
local Widgets = {}

-- returns frame, paint(on, animate)
function Widgets.Switch(parent, props)
    local state = { on = false }
    local track = Util.New("Frame", {
        Name = "Switch",
        Size = UDim2.fromOffset(30, 16),
        AnchorPoint = props and props.AnchorPoint or Vector2.new(1, 0.5),
        Position = props and props.Position or UDim2.new(1, 0, 0.5, 0),
        LayoutOrder = props and props.LayoutOrder or 0,
        Theme = { BackgroundColor3 = function(t) return state.on and t.Accent or t.Elevated end },
        Parent = parent,
    })
    Util.Corner(UDim.new(1, 0), track)
    Util.Stroke(track, function(t) return state.on and t.Accent or t.Stroke end, function(t) return state.on and 1 or t.StrokeTransparency end)
    local knob = Util.New("Frame", {
        Size = UDim2.fromOffset(10, 10),
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, 3, 0.5, 0),
        Theme = { BackgroundColor3 = function(t) return state.on and t.OnAccent or t.TextDim end },
        Parent = track,
    })
    Util.Corner(UDim.new(1, 0), knob)
    local function paint(on, animate)
        state.on = on
        local time = animate and 0.22 or 0
        Theme.Refresh(track, time)
        Theme.Refresh(track:FindFirstChildOfClass("UIStroke"), time)
        Theme.Refresh(knob, time)
        Util.Tween(knob, time, { Position = on and UDim2.new(1, -13, 0.5, 0) or UDim2.new(0, 3, 0.5, 0) })
    end
    return track, paint
end

function Widgets.Checkbox(parent, props)
    local state = { on = false }
    local box = Util.New("Frame", {
        Name = "Checkbox",
        Size = UDim2.fromOffset(16, 16),
        AnchorPoint = props and props.AnchorPoint or Vector2.new(1, 0.5),
        Position = props and props.Position or UDim2.new(1, 0, 0.5, 0),
        LayoutOrder = props and props.LayoutOrder or 0,
        Theme = {
            BackgroundColor3 = function(t) return state.on and t.Accent or t.Elevated end,
        },
        Parent = parent,
    })
    Util.Corner(4, box)
    Util.Stroke(box, function(t) return state.on and t.Accent or t.Stroke end)
    local check = Util.Icon("check", {
        Size = UDim2.fromOffset(12, 12),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Color = "OnAccent",
        ImageTransparency = 1,
        Parent = box,
    })
    local scale = Util.New("UIScale", { Scale = 0.6, Parent = check })
    local function paint(on, animate)
        state.on = on
        local time = animate and 0.18 or 0
        Theme.Refresh(box, time)
        Theme.Refresh(box:FindFirstChildOfClass("UIStroke"), time)
        Util.Tween(check, time, { ImageTransparency = on and 0 or 1 })
        Util.Tween(scale, time, { Scale = on and 1 or 0.6 }, Enum.EasingStyle.Back)
    end
    return box, paint
end

-- key pill for a Binding; click binds, right click opens modes
function Widgets.KeyPill(parent, binding, props)
    props = props or {}
    local hover = false
    local pill = Util.New("TextButton", {
        Name = "KeyPill",
        AutomaticSize = Enum.AutomaticSize.X,
        Size = UDim2.fromOffset(0, props.Height or 18),
        AnchorPoint = props.AnchorPoint or Vector2.new(0, 0.5),
        Position = props.Position or UDim2.new(0, 0, 0.5, 0),
        LayoutOrder = props.LayoutOrder or 0,
        Theme = {
            BackgroundColor3 = function(t) return hover and t.ElevatedHover or t.Elevated end,
            BackgroundTransparency = function(t) return math.min(t.ElevatedTransparency, 0.2) end,
        },
        Parent = parent,
    })
    Util.Corner(4, pill)
    Util.Padding(pill, 0, 7, 0, 7)
    Util.New("UISizeConstraint", { MinSize = Vector2.new(30, 0), Parent = pill })
    Util.List(pill, 4, Enum.FillDirection.Horizontal, Enum.HorizontalAlignment.Center, Enum.VerticalAlignment.Center)
    local stroke = Util.Stroke(pill, function(t) return binding.Capturing and t.Accent or t.Stroke end, function(t)
        return binding.Capturing and 0 or t.StrokeTransparency + 0.15
    end)
    local label = Util.Label({
        TextSize = 10,
        Weight = Enum.FontWeight.SemiBold,
        AutomaticSize = Enum.AutomaticSize.X,
        Size = UDim2.fromScale(0, 1),
        TextXAlignment = Enum.TextXAlignment.Center,
        LayoutOrder = 1,
        Theme = { TextColor3 = function(t) return (binding.Capturing or binding.Key) and t.Text or t.TextMuted end },
        Parent = pill,
    })
    local mode = Util.Label({
        TextSize = 9,
        Color = "Accent",
        Weight = Enum.FontWeight.Bold,
        AutomaticSize = Enum.AutomaticSize.X,
        Size = UDim2.fromScale(0, 1),
        LayoutOrder = 2,
        Parent = pill,
    })

    local function paint()
        label.Text = binding.Capturing and (binding.Pending and (Util.KeyLabel(binding.Pending) .. " + ...") or "...")
            or Util.KeyLabel(binding.Key)
        local showMode = not binding.Capturing and binding.Key and #binding.Modes > 1 and binding.Mode ~= binding.Modes[1]
        mode.Visible = showMode and true or false
        mode.Text = showMode and binding.Mode:sub(1, 1) or ""
        Theme.Refresh(label)
        Theme.Refresh(stroke, 0.15)
    end
    paint()

    local connections = {}
    table.insert(connections, binding.Changed:Connect(paint))
    table.insert(connections, Tooltip.Attach(pill, function()
        if binding.Capturing then return "Press a key · Esc cancels · Backspace clears" end
        if #binding.Modes < 2 then return nil end
        return Util.Touch() and "Hold for mode" or "Right-click for mode"
    end))

    table.insert(connections, Util.Hover(pill, function(on) hover = on; Theme.Refresh(pill, 0.12) end))
    local function menu()
        local items: { any } = {}
        if #binding.Modes > 1 then
            for _, name in binding.Modes do
                table.insert(items, {
                    Title = name,
                    Checked = binding.Mode == name,
                    Callback = function() binding:SetMode(name) end,
                })
            end
            table.insert(items, "-")
        end
        table.insert(items, { Title = "Change key", Icon = "keyboard", Callback = function() binding:Capture() end })
        if binding.CanUnbind then
            table.insert(items, { Title = "Clear key", Icon = "x", Danger = true, Disabled = binding.Key == nil, Callback = function() binding:SetKey(nil) end })
        end
        Menu.Open({ Anchor = pill, Items = items, Width = 150, Title = "Keybind" })
    end
    -- touch: a long press opens the menu that right-click opens with a mouse
    local press, consumed = Util.LongPress(pill, menu)
    table.insert(connections, press)
    pill.MouseButton1Click:Connect(function()
        if not consumed() then binding:Capture() end
    end)
    pill.MouseButton2Click:Connect(menu)

    return pill, {
        Disconnect = function()
            for _, connection in connections do connection:Disconnect() end
        end,
    }
end

return Widgets
end

__modules["Components/Window"] = function(...)
local import = ...
local Services = import("Core/Services")
local Util = import("Core/Util")
local Theme = import("Core/Theme")
local Maid = import("Core/Maid")
local Drag = import("Core/Drag")
local Storage = import("Core/Storage")
local Config = import("Core/Config")
local Binding = import("Core/Binding")
local Keybinds = import("Core/Keybinds")
local Layer = import("Components/Layer")
local Popup = import("Components/Popup")
local Tooltip = import("Components/Tooltip")
local Dialog = import("Components/Dialog")
local Notification = import("Components/Notification")
local Page = import("Components/Page")
local Tab = import("Components/Tab")
local Overlays = import("Components/Overlays")
local Acrylic = import("Components/Acrylic")
local Panel = import("Components/Panel")
local ScreenButton = import("Components/ScreenButton")
local Menu = import("Components/Menu")

local UIS = Services.UserInputService
local Window = {}
Window.__index = Window

local TOP = 50
local COMPACT = 56
local MIN_SIZE = Vector2.new(560, 380)

local INTERFACE = {
    Scale = 1,               -- user multiplier on top of the screen fit
    FitScreen = true,        -- scale with the resolution (1080p = 1)
    AutoExpand = true,
    Compact = false,
    ToggleKey = "RightShift",
    KeybindList = false,
    Watermark = false,
    Blur = "Off",            -- "Off" | "Screen" | "Window", see Components/Acrylic
    BlurStrength = 12,
    ShowUser = true,         -- profile card in the sidebar
    HideUser = false,        -- streamer mode: hide name
    HideAvatar = false,
    NotifyPosition = "BottomRight",
    NotifyDuration = 100,    -- percent of every notification's duration
    NotifyMax = 5,           -- notifications on screen at once
    ToggleAlerts = "Always", -- features with the bell on: "Always" | "Hidden" (menu hidden only) | "Off"
    NotifyConfig = true,     -- "Config loaded" after the autoload config
    BindClickOutside = "Keep",
    BindEscape = "Keep",
    BindMouse = true,
    BindComboKeys = 3,       -- keys per bind (def.ComboKeys sets the default)
    Tooltips = true,
    AutoSave = false,        -- configs: changes go into the loaded config (def.AutoSave sets the default)
    ButtonScale = 100,       -- on-screen buttons, percent
    ButtonTransparency = 15,
}

-- def: Title, Subtitle, Icon, Folder, Size, MinSize, Theme, ThemeOverrides, Tags, ToggleKey, Search, Settings,
--      AutoLoad, SidebarWidth, Resizable, Draggable, Minimizable, CloseAction ("Hide" | "Unload" | "Confirm"),
--      ComboKeys (default keys per bind, 1-4), SearchShortcut (false: no Ctrl+F),
--      AutoSave (default of Settings > Auto save), DefaultConfig (name: created and set as autoload on the first run),
--      User (false | { Name, Subtitle, Avatar (asset | false), Callback })
function Window.new(library, def)
    local self = setmetatable({
        Library = library,
        Def = def,
        Maid = Maid.new(),
        Tabs = {},
        Entries = {},
        Panels = {},
        ScreenButtons = {},
        _binds = {},
        Visible = true,
        Minimized = false,
    }, Window)
    self.Folder = def.Folder or (def.Title and def.Title:gsub("[^%w_%- ]", "")) or "OasisUI"
    self.SidebarWidth = def.SidebarWidth or 164
    self.Config = Config.new(self.Folder)
    self:_loadState()
    self.Config.AutoSave = self.Interface.AutoSave == true
    self:ApplyBindOptions()

    if self.State.Theme then
        Theme.Import(self.State.Theme)
    elseif def.Theme then
        Theme.UsePalette(def.Theme)
    end
    if def.ThemeOverrides then Theme.Set(def.ThemeOverrides) end
    self.Maid:Give(Theme.Changed:Connect(function() self:SaveState() end))
    Notification.SetPosition(self.Interface.NotifyPosition)
    Notification.Scale = (tonumber(self.Interface.NotifyDuration) or 100) / 100
    Notification.Max = tonumber(self.Interface.NotifyMax) or 5

    self:_build()
    self.Favorites = Page.new(self, {
        Id = "favorites",
        Draggable = true,
        Source = true,
        Empty = "No favorites yet.\nClick the star on any module to pin it here.",
        EmptyIcon = "star",
    })
    self.Favorites:UpdateEmpty()
    self.SearchPage = Page.new(self, { Id = "search", Source = true, EmptyIcon = "search" })

    self.MenuBinding = Binding.new({
        Key = self.Interface.ToggleKey,
        Mode = "Toggle",
        Modes = { "Toggle" },
        Press = function() self:Toggle() end,
    })
    self.MenuBinding.Changed:Connect(function()
        self.Interface.ToggleKey = self.MenuBinding.Key or false
        self:SaveState()
    end)
    self.Maid:Give(self.MenuBinding)

    self.Overlays = Overlays.new(self)
    self.Overlays:SetKeybindList(self.Interface.KeybindList)
    self.Overlays:SetWatermark(self.Interface.Watermark)
    if UIS.TouchEnabled then self.Overlays:SetMobileButton(true) end
    self.Acrylic = Acrylic.new(self.Root, self.Maid)
    self.Acrylic.Strength = tonumber(self.Interface.BlurStrength) or 12
    self.Acrylic:SetMode(self.Interface.Blur)

    if def.Settings ~= false then
        import("Addons/Settings")(self)
    end
    if self.Interface.Tab == "favorites" then
        self._restored = true
        self:SelectFavorites()
    end

    if def.AutoLoad ~= false then
        task.defer(function() self:LoadAutoload() end)
    end
    self:_open()
    return self
end

-- state -----------------------------------------------------------------------

function Window:_loadState()
    local state = Storage.ReadJSON(self.Folder .. "/ui.json")
    if type(state) ~= "table" then state = {} end
    state.Favorites = type(state.Favorites) == "table" and state.Favorites or {}
    state.Notify = type(state.Notify) == "table" and state.Notify or {}
    state.Layout = type(state.Layout) == "table" and state.Layout or {}
    state.Interface = type(state.Interface) == "table" and state.Interface or {}
    for _, key in { "SubTabs", "Panels" } do
        if type(state.Interface[key]) ~= "table" then state.Interface[key] = {} end
    end
    if type(state.Interface.Scale) ~= "number" then state.Interface.Scale = nil end
    local defaults = table.clone(INTERFACE)
    if self.Def.ToggleKey then defaults.ToggleKey = Binding.KeyName(self.Def.ToggleKey) end
    if self.Def.ComboKeys then defaults.BindComboKeys = self.Def.ComboKeys end
    if self.Def.AutoSave ~= nil then defaults.AutoSave = self.Def.AutoSave == true end
    for key, value in defaults do
        if state.Interface[key] == nil then state.Interface[key] = value end
    end
    self.State = state
    self.Interface = state.Interface
end

function Window:SaveState()
    if self._saveQueued then return end
    self._saveQueued = true
    task.delay(0.5, function()
        self._saveQueued = false
        if self.Destroyed then return end
        self.State.Theme = Theme.Export()
        Storage.WriteJSON(self.Folder .. "/ui.json", self.State)
    end)
end

-- element changed: config autosave, keybind list
function Window:_touch(binds)
    self.Config:Touch()
    if self.Overlays and (binds or self.Interface.KeybindList) then self.Overlays:RefreshBinds() end
end

-- Listed = false keeps a bind out of the keybind list (e.g. a key the game itself uses)
function Window:_trackBind(owner)
    if owner.Def and owner.Def.Listed == false then return end
    table.insert(self._binds, owner)
end

function Window:GetScale()
    return self.Scale or 1
end

-- keybind capture defaults from the interface settings
function Window:ApplyBindOptions()
    Keybinds.Options.ClickOutside = self.Interface.BindClickOutside
    Keybinds.Options.Escape = self.Interface.BindEscape
    Keybinds.Options.Mouse = self.Interface.BindMouse ~= false
    Keybinds.Options.ComboKeys = tonumber(self.Interface.BindComboKeys) or 3
    Tooltip.Enabled = self.Interface.Tooltips ~= false
end

-- build -----------------------------------------------------------------------

local function iconButton(parent, icon, order, tip)
    local hover = { Hover = false }
    local button = Util.New("ImageButton", {
        Size = UDim2.fromOffset(28, 28),
        LayoutOrder = order,
        Theme = {
            BackgroundColor3 = "ElevatedHover",
            BackgroundTransparency = function() return hover.Hover and 0.3 or 1 end,
        },
        Parent = parent,
    })
    Util.Corner(6, button)
    local image = Util.Icon(icon, {
        Size = UDim2.fromOffset(14, 14),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Theme = { ImageColor3 = function(t) return hover.Hover and t.Text or t.TextDim end },
        Parent = button,
    })
    Util.Feedback(button, hover, function()
        Theme.Refresh(button, 0.12)
        Theme.Refresh(image, 0.12)
    end)
    if tip then Tooltip.Attach(button, tip) end
    return button, image
end

function Window:_build()
    local def = self.Def
    local size = def.Size or UDim2.fromOffset(780, 520)
    self.DefaultSize = size
    if type(self.Interface.Size) == "table" then size = UDim2.fromOffset(self.Interface.Size[1], self.Interface.Size[2]) end
    self.MinSize = def.MinSize or MIN_SIZE

    local root = self.Maid:Give(Util.New("Frame", {
        Name = "Window",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = size,
        ClipsDescendants = true,
        Active = true,
        Theme = {
            BackgroundColor3 = function(t) return t.Gradient and Color3.new(1, 1, 1) or t.Background end,
            BackgroundTransparency = function(t)
                return t._windowBlur and math.max(t.WindowTransparency, 0.35) or t.WindowTransparency
            end,
        },
        Parent = Layer.Main,
    }))
    if type(self.Interface.Position) == "table" then
        root.Position = UDim2.new(0.5, self.Interface.Position[1], 0.5, self.Interface.Position[2])
    end
    self.Root = root
    Util.Corner("Radius", root)
    Util.Stroke(root)
    Util.New("UIGradient", {
        Theme = {
            Enabled = "Gradient",
            Rotation = "GradientRotation",
            Color = function(t)
                return ColorSequence.new({
                    ColorSequenceKeypoint.new(0, t.BackgroundAlt),
                    ColorSequenceKeypoint.new(0.55, t.Background),
                    ColorSequenceKeypoint.new(1, t.Background),
                })
            end,
        },
        Parent = root,
    })
    self.UIScale = Util.New("UIScale", { Parent = root })

    -- topbar ------------------------------------------------------------------
    local topbar = Util.New("Frame", { Name = "Topbar", BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, TOP), Parent = root })
    self.Topbar = topbar
    local logo = Util.Icon(def.Icon or "sparkles", {
        Size = UDim2.fromOffset(22, 22),
        Position = UDim2.fromOffset(16, 14),
        Theme = { ImageColor3 = function() return Color3.new(1, 1, 1) end },
        Parent = topbar,
    })
    Util.New("UIGradient", {
        Rotation = 45,
        Theme = { Color = function(t) return ColorSequence.new(t.Accent, t.AccentAlt) end },
        Parent = logo,
    })

    local heading = Util.New("Frame", { BackgroundTransparency = 1, Position = UDim2.fromOffset(48, 8), Size = UDim2.new(0, 0, 0, 18), AutomaticSize = Enum.AutomaticSize.X, Parent = topbar })
    Util.List(heading, 6, Enum.FillDirection.Horizontal, nil, Enum.VerticalAlignment.Center)
    local title = Util.Label({
        Text = def.Title or "OasisUI",
        TextSize = 15,
        Weight = Enum.FontWeight.Bold,
        AutomaticSize = Enum.AutomaticSize.X,
        Size = UDim2.fromScale(0, 1),
        LayoutOrder = 1,
        Theme = { TextColor3 = function(t) return t.AnimatedTitle and Color3.new(1, 1, 1) or t.Text end },
        Parent = heading,
    })
    self.TitleLabel = title
    local titleGradient = Util.New("UIGradient", {
        Theme = {
            Enabled = "AnimatedTitle",
            Color = function(t)
                return ColorSequence.new({
                    ColorSequenceKeypoint.new(0, t.Accent),
                    ColorSequenceKeypoint.new(0.5, t.AccentAlt),
                    ColorSequenceKeypoint.new(1, t.Accent),
                })
            end,
        },
        Parent = title,
    })
    self.Maid:Give(Services.RunService.Heartbeat:Connect(function()
        if Theme.Current.AnimatedTitle and root.Visible then
            titleGradient.Offset = Vector2.new(math.sin(os.clock() * 1.3) * 0.5, 0)
        end
    end))
    for index, tag in def.Tags or {} do
        tag = type(tag) == "string" and { Text = tag } or tag
        local chip = Util.New("Frame", {
            AutomaticSize = Enum.AutomaticSize.X,
            Size = UDim2.fromOffset(0, 16),
            LayoutOrder = 1 + index,
            Theme = if tag.Color then nil else { BackgroundColor3 = "Elevated" },
            BackgroundColor3 = tag.Color,
            Parent = heading,
        })
        Util.Corner(4, chip)
        Util.Padding(chip, 0, 6, 0, 6)
        Util.Label({
            Text = tag.Text or tag.Title or "",
            TextSize = 10,
            Weight = Enum.FontWeight.SemiBold,
            Color = tag.Color and "OnAccent" or "TextDim",
            AutomaticSize = Enum.AutomaticSize.X,
            Size = UDim2.fromScale(0, 1),
            Parent = chip,
        })
    end
    self.SubtitleLabel = Util.Label({
        Text = def.Subtitle or def.SubTitle or "",
        TextSize = 11,
        Color = "TextMuted",
        Position = UDim2.fromOffset(48, 27),
        Size = UDim2.new(0, 260, 0, 14),
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = topbar,
    })

    local actions = Util.New("Frame", {
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -12, 0.5, 0),
        AutomaticSize = Enum.AutomaticSize.X,
        Size = UDim2.fromOffset(0, 28),
        Parent = topbar,
    })
    Util.List(actions, 4, Enum.FillDirection.Horizontal, Enum.HorizontalAlignment.Right, Enum.VerticalAlignment.Center)
    self.Actions = actions

    -- search
    local searchFocused = false
    local search = Util.New("Frame", {
        Name = "Search",
        Size = UDim2.fromOffset(200, 28),
        LayoutOrder = 1,
        Visible = def.Search ~= false,
        Theme = { BackgroundColor3 = "Elevated", BackgroundTransparency = "ElevatedTransparency" },
        Parent = actions,
    })
    Util.Corner(7, search)
    local searchStroke = Util.Stroke(search, function(t) return searchFocused and t.Accent or t.Stroke end, function(t)
        return searchFocused and 0.3 or t.StrokeTransparency + 0.1
    end)
    Util.Icon("search", { Size = UDim2.fromOffset(13, 13), Position = UDim2.new(0, 9, 0.5, -6), Color = "TextMuted", Parent = search })
    local searchBox = Util.New("TextBox", {
        Size = UDim2.new(1, -60, 1, 0),
        Position = UDim2.fromOffset(28, 0),
        PlaceholderText = "Search features",
        Text = "",
        TextSize = 12,
        Theme = { TextColor3 = "Text", PlaceholderColor3 = "TextMuted", FontFace = Theme.Font(Enum.FontWeight.Medium) },
        Parent = search,
    })
    local clearSearch = Util.New("ImageButton", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -8, 0.5, 0),
        Size = UDim2.fromOffset(12, 12),
        Image = Util.IconId("x"),
        Visible = false,
        Theme = { ImageColor3 = "TextMuted" },
        Parent = search,
    })
    self.SearchBox = searchBox
    searchBox.Focused:Connect(function() searchFocused = true; Theme.Refresh(searchStroke, 0.15) end)
    searchBox.FocusLost:Connect(function() searchFocused = false; Theme.Refresh(searchStroke, 0.15) end)
    local searchToken = 0
    searchBox:GetPropertyChangedSignal("Text"):Connect(function()
        local text = searchBox.Text
        clearSearch.Visible = text ~= ""
        searchToken += 1
        local mine = searchToken
        task.delay(0.12, function()
            if mine == searchToken then self:_search(text) end
        end)
    end)
    clearSearch.MouseButton1Click:Connect(function() searchBox.Text = "" end)
    self.Maid:Give(UIS.InputBegan:Connect(function(input)
        -- SearchShortcut = false keeps the bar but frees Ctrl+F
        if def.Search == false or def.SearchShortcut == false then return end
        if input.KeyCode == Enum.KeyCode.F and root.Visible and not self.Minimized
            and (UIS:IsKeyDown(Enum.KeyCode.LeftControl) or UIS:IsKeyDown(Enum.KeyCode.RightControl)) then
            task.defer(function() searchBox:CaptureFocus() end)
        end
    end))

    local minimize, minimizeIcon = iconButton(actions, "minus", 2, "Minimize")
    minimize.Visible = def.Minimizable ~= false
    local closeAction = def.CloseAction or "Hide"
    local close = iconButton(actions, "x", 3, function()
        if closeAction ~= "Hide" then return "Close" end
        return "Hide (" .. Util.KeyLabel(self.MenuBinding and self.MenuBinding.Key) .. ")"
    end)
    self.MinimizeIcon = minimizeIcon
    minimize.MouseButton1Click:Connect(function() self:SetMinimized(not self.Minimized) end)
    close.MouseButton1Click:Connect(function()
        if closeAction == "Unload" then
            self.Library:Unload()
        elseif closeAction == "Confirm" then
            self:Dialog({
                Title = "Close " .. (def.Title or "menu") .. "?",
                Icon = "power",
                Content = "This unloads the script. Hide it with " .. Util.KeyLabel(self.MenuBinding and self.MenuBinding.Key) .. " instead.",
                Buttons = {
                    { Title = "Hide", Style = "Secondary", Callback = function() self:SetVisible(false) end },
                    { Title = "Unload", Style = "Danger", Callback = function() self.Library:Unload() end },
                },
            })
        else
            self:SetVisible(false)
            local key = self.MenuBinding and self.MenuBinding.Key
            self.Library:Notify({
                Title = "Menu hidden",
                Content = key and ("Press " .. Util.KeyLabel(key) .. " to open it again.") or "Use the menu button to open it again.",
                Duration = 4,
            })
        end
    end)

    local topDivider = Util.New("Frame", {
        Size = UDim2.new(1, -24, 0, 1),
        Position = UDim2.fromOffset(12, TOP),
        Theme = { BackgroundColor3 = "Divider" },
        Parent = root,
    })
    Util.New("UIGradient", {
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.15, 0),
            NumberSequenceKeypoint.new(0.85, 0),
            NumberSequenceKeypoint.new(1, 1),
        }),
        Parent = topDivider,
    })
    self.TopDivider = topDivider

    -- sidebar -----------------------------------------------------------------
    local sidebar = Util.New("Frame", {
        Name = "Sidebar",
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(0, TOP + 1),
        Size = UDim2.new(0, self.SidebarWidth, 1, -TOP - 1),
        Parent = root,
    })
    self.Sidebar = sidebar
    local list = Util.New("ScrollingFrame", {
        Name = "Tabs",
        Size = UDim2.new(1, 0, 1, -46),
        ScrollBarThickness = 2,
        ScrollBarImageTransparency = 0.5,
        Theme = { ScrollBarImageColor3 = "TextMuted" },
        Parent = sidebar,
    })
    Util.Padding(list, 10, 10, 10, 10)
    Util.AutoCanvas(list, Util.List(list, 3))
    self.TabList = list

    local bottom = Util.New("Frame", {
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0, 1),
        Position = UDim2.fromScale(0, 1),
        Size = UDim2.new(1, 0, 0, 46),
        Parent = sidebar,
    })
    Util.Padding(bottom, 6, 10, 10, 10)
    Util.List(bottom, 6)
    self.SidebarBottom = bottom

    if def.User ~= false then
        self:_userCard(bottom)
    end
    self:_layoutSidebar()

    local sideDivider = Util.New("Frame", {
        Position = UDim2.fromOffset(self.SidebarWidth, TOP + 12),
        Size = UDim2.new(0, 1, 1, -TOP - 24),
        Theme = { BackgroundColor3 = "Divider" },
        Parent = root,
    })
    Util.New("UIGradient", {
        Rotation = 90,
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.15, 0),
            NumberSequenceKeypoint.new(0.85, 0),
            NumberSequenceKeypoint.new(1, 1),
        }),
        Parent = sideDivider,
    })
    self.SideDivider = sideDivider

    -- content -----------------------------------------------------------------
    self.Content = Util.New("Frame", {
        Name = "Content",
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(self.SidebarWidth + 14, TOP + 12),
        Size = UDim2.new(1, -self.SidebarWidth - 26, 1, -TOP - 12),
        Parent = root,
    })
    self.DragLayer = Util.New("Frame", {
        Name = "DragLayer",
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
        ZIndex = 40,
        Parent = root,
    })

    -- favourites entry
    self.FavoritesEntry = self:_entry(list, "Favorites", "star", -100, function() self:SelectFavorites() end)
    self:_sidebarDivider(-99)

    -- resize grip
    local grip = Util.Grip({
        Name = "Resize",
        AnchorPoint = Vector2.new(1, 1),
        Position = UDim2.new(1, -3, 1, -3),
        Size = UDim2.fromOffset(16, 16),
        BackgroundTransparency = 1,
        ZIndex = 50,
        Parent = root,
    })
    self.Grip = grip
    grip.Visible = def.Resizable ~= false
    grip.InputBegan:Connect(function(input)
        if not Util.IsPress(input) or self.Minimized then return end
        local scale = self:GetScale()
        local origin = root.AbsoluteSize / scale
        local originPosition = root.Position
        Drag.Follow(input, function(_, delta)
            local viewport = Layer.Bounds() / scale
            local width = math.clamp(origin.X + delta.X / scale, self.MinSize.X, viewport.X - 20)
            local height = math.clamp(origin.Y + delta.Y / scale, self.MinSize.Y, viewport.Y - 20)
            root.Size = UDim2.fromOffset(width, height)
            -- the window is centre-anchored: shift it by half the growth so the top-left stays put
            -- and the grip stays under the pointer
            root.Position = originPosition + UDim2.fromOffset((width - origin.X) * scale / 2, (height - origin.Y) * scale / 2)
        end, function()
            self.Interface.Size = { math.floor(root.Size.X.Offset), math.floor(root.Size.Y.Offset) }
            local bounds = Layer.Bounds()
            local center = root.AbsolutePosition + root.AbsoluteSize / 2
            self.Interface.Position = { math.floor(center.X - bounds.X / 2), math.floor(center.Y - bounds.Y / 2) }
            self:SaveState()
        end)
    end)

    -- window drag by the topbar, not by its controls
    self.Maid:Give(Drag.Attach(topbar, root, {
        Enabled = function()
            if def.Draggable == false then return false end
            local point = Util.Pointer()
            return not Util.Contains(actions, point)
        end,
        OnEnd = function(moved)
            if not moved then return end
            local viewport = Layer.Bounds()
            local center = root.AbsolutePosition + root.AbsoluteSize / 2
            self.Interface.Position = { math.floor(center.X - viewport.X / 2), math.floor(center.Y - viewport.Y / 2) }
            self:SaveState()
        end,
    }))

    self:SetCompact(self.Interface.Compact, true)
    self:_fitScale()
    self.Maid:Give(workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
        self:_fitScale()
        task.defer(function() self:_clampRoot() end)
    end))
    task.defer(function() self:_clampRoot() end)
end

function Window:_userCard(parent)
    local player = Services.Players.LocalPlayer
    local state = { Hover = false }
    local card = Util.New("TextButton", {
        Name = "User",
        Size = UDim2.new(1, 0, 0, 42),
        LayoutOrder = 2,
        Theme = {
            BackgroundColor3 = "Elevated",
            BackgroundTransparency = function(t) return math.min(t.ElevatedTransparency + (state.Hover and 0.1 or 0.25), 0.95) end,
        },
        Parent = parent,
    })
    Util.Corner(8, card)
    local avatar = Util.New("ImageLabel", {
        Size = UDim2.fromOffset(28, 28),
        Position = UDim2.new(0, 7, 0.5, -14),
        BackgroundTransparency = 0,
        Theme = { BackgroundColor3 = "ElevatedHover" },
        Parent = card,
    })
    Util.Corner(UDim.new(1, 0), avatar)
    local placeholder = Util.Icon("user", { Size = UDim2.fromOffset(14, 14), Position = UDim2.fromOffset(7, 7), Color = "TextMuted", Parent = avatar })
    local name = Util.Label({ TextSize = 12, Weight = Enum.FontWeight.SemiBold, Position = UDim2.fromOffset(42, 7), Size = UDim2.new(1, -48, 0, 15), TextTruncate = Enum.TextTruncate.AtEnd, Parent = card })
    local handle = Util.Label({ TextSize = 10, Color = "TextMuted", Position = UDim2.fromOffset(42, 22), Size = UDim2.new(1, -48, 0, 12), TextTruncate = Enum.TextTruncate.AtEnd, Parent = card })
    local thumbnail
    task.spawn(function()
        local ok, result = pcall(Services.Players.GetUserThumbnailAsync, Services.Players, player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
        if ok then
            thumbnail = result
            if self.PaintUser then self.PaintUser() end
        end
    end)
    function self.PaintUser()
        local user = type(self.Def.User) == "table" and self.Def.User or {}
        local hidden = self.Interface.HideUser
        name.Text = hidden and "Hidden" or (user.Name or player.DisplayName)
        handle.Text = hidden and "@hidden" or (user.Subtitle or ("@" .. player.Name))
        local image = user.Avatar
        if image == nil then image = thumbnail end
        if hidden or self.Interface.HideAvatar or image == false then image = nil end
        avatar.Image = image and Util.IconId(image) or ""
        placeholder.Visible = avatar.Image == ""
    end
    self.PaintUser()
    Util.Feedback(card, state)
    card.MouseButton1Click:Connect(function()
        local user = self.Def.User
        if type(user) == "table" and user.Callback then Util.Safe(user.Callback) end
    end)
    self.UserCard = card
    self.UserLabels = { name, handle }
end

-- shows or hides the profile card and sizes the tab list around it
function Window:_layoutSidebar()
    local showUser = self.UserCard ~= nil and self.Interface.ShowUser ~= false
    if self.UserCard then self.UserCard.Visible = showUser end
    local height = showUser and 94 or 46
    self.SidebarBottom.Size = UDim2.new(1, 0, 0, height)
    self.TabList.Size = UDim2.new(1, 0, 1, -height)
end

-- def: Name, Subtitle, Avatar (asset | false), Callback; false hides the card
function Window:SetUser(user)
    self.Def.User = user
    if user == false then
        self.Interface.ShowUser = false
    elseif self.PaintUser then
        self.PaintUser()
    end
    self:_layoutSidebar()
end

function Window:_sidebarDivider(order)
    local holder = Util.New("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 9), LayoutOrder = order, Parent = self.TabList })
    Util.New("Frame", { Size = UDim2.new(1, -8, 0, 1), Position = UDim2.new(0, 4, 0.5, 0), Theme = { BackgroundColor3 = "Divider" }, Parent = holder })
    return holder
end

-- sidebar entry: icon + label + optional badge; returns entry table
function Window:_entry(parent, text, icon, order, onClick)
    local entry = { Selected = false, Hover = false }
    local button = Util.New("TextButton", {
        Name = text,
        Size = UDim2.new(1, 0, 0, 30),
        LayoutOrder = order,
        Theme = {
            BackgroundColor3 = "Elevated",
            BackgroundTransparency = function(t)
                if entry.Selected then return t.ElevatedTransparency end
                return entry.Hover and math.min(t.ElevatedTransparency + 0.45, 0.85) or 1
            end,
        },
        Parent = parent,
    })
    Util.Corner(7, button)
    local indicator = Util.New("Frame", {
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, 0, 0.5, 0),
        Size = UDim2.fromOffset(3, 0),
        Theme = { BackgroundColor3 = "Accent" },
        Parent = button,
    })
    Util.Corner(2, indicator)
    local image = Util.Icon(icon, {
        Size = UDim2.fromOffset(15, 15),
        Position = UDim2.new(0, 12, 0.5, -7),
        Theme = { ImageColor3 = function(t) return entry.Selected and t.Accent or (entry.Hover and t.TextDim or t.TextMuted) end },
        Parent = button,
    })
    local label = Util.Label({
        Text = text,
        TextSize = 13,
        Weight = Enum.FontWeight.Medium,
        Position = UDim2.fromOffset(36, 0),
        Size = UDim2.new(1, -44, 1, 0),
        TextTruncate = Enum.TextTruncate.AtEnd,
        Theme = { TextColor3 = function(t) return entry.Selected and t.Text or (entry.Hover and t.TextDim or t.TextMuted) end },
        Parent = button,
    })
    local badge = Util.New("Frame", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -8, 0.5, 0),
        AutomaticSize = Enum.AutomaticSize.X,
        Size = UDim2.fromOffset(0, 16),
        Visible = false,
        Theme = { BackgroundColor3 = "Elevated" },
        Parent = button,
    })
    Util.Corner(UDim.new(1, 0), badge)
    Util.Padding(badge, 0, 6, 0, 6)
    local badgeText = Util.Label({ TextSize = 10, Color = "TextDim", Weight = Enum.FontWeight.Bold, AutomaticSize = Enum.AutomaticSize.X, Size = UDim2.fromScale(0, 1), Parent = badge })

    local function paint(animate)
        local time = animate and 0.18 or 0
        Theme.Refresh(button, time)
        Theme.Refresh(image, time)
        Theme.Refresh(label, time)
        Util.Tween(indicator, time, { Size = UDim2.fromOffset(3, entry.Selected and 16 or 0) })
    end
    entry.Button, entry.Label, entry.Icon, entry.Badge = button, label, image, badge
    function entry.SetSelected(on)
        entry.Selected = on
        paint(true)
    end
    function entry.SetBadge(value)
        badge.Visible = value ~= nil and value ~= 0 and not self.Interface.Compact
        badgeText.Text = tostring(value or "")
        entry.BadgeValue = value
    end
    Util.Hover(button, function(on) entry.Hover = on; paint(true) end)
    button.MouseButton1Click:Connect(onClick)
    Tooltip.Attach(button, function() return self.Interface.Compact and text or nil end)
    paint(false)
    table.insert(self.Entries, entry)
    return entry
end

-- layout ----------------------------------------------------------------------

function Window:SetCompact(compact, instant)
    self.Interface.Compact = compact and true or false
    local width = compact and COMPACT or self.SidebarWidth
    local time = instant and 0 or 0.25
    Util.Tween(self.Sidebar, time, { Size = UDim2.new(0, width, 1, -TOP - 1) })
    Util.Tween(self.SideDivider, time, { Position = UDim2.fromOffset(width, TOP + 12) })
    Util.Tween(self.Content, time, { Position = UDim2.fromOffset(width + 14, TOP + 12), Size = UDim2.new(1, -width - 26, 1, -TOP - 12) })
    for _, entry in self.Entries do
        entry.Label.Visible = not compact
        if entry.Badge then entry.Badge.Visible = not compact and entry.BadgeValue ~= nil and entry.BadgeValue ~= 0 end
    end
    for _, header in self._headers or {} do header.Visible = not compact end
    if self.UserLabels then
        for _, label in self.UserLabels do label.Visible = not compact end
    end
end

-- final scale = (screen fit or 1) x user multiplier; with the fit on the window always stays on screen
function Window:_fitScale()
    local scale = math.clamp(tonumber(self.Interface.Scale) or 1, 0.25, 4)
    if self.Interface.FitScreen ~= false then
        local bounds = Layer.Bounds()
        local viewport = workspace.CurrentCamera.ViewportSize
        if Util.Touch() and not self.Minimized then
            -- phones: a 1080p-relative scale would shrink the text to a few pixels; the text stays readable
            -- and the window gives up size instead (down to MinSize), the chosen size is kept for bigger screens
            scale *= math.clamp(viewport.Y / 450, 0.75, 1.5)
            local want = type(self.Interface.Size) == "table" and Vector2.new(self.Interface.Size[1], self.Interface.Size[2])
                or Vector2.new(self.DefaultSize.X.Offset, self.DefaultSize.Y.Offset)
            local room = (bounds - Vector2.new(24, 24)) / scale
            local width = math.max(math.min(want.X, room.X), self.MinSize.X)
            local height = math.max(math.min(want.Y, room.Y), self.MinSize.Y)
            self.Root.Size = UDim2.fromOffset(width, height)
            scale = math.min(scale, (bounds.X - 24) / width, (bounds.Y - 24) / height)
        else
            local size = self.Minimized and self._restoreSize or self.Root.Size
            scale *= math.clamp(viewport.Y / 1080, 0.5, 2)
            scale = math.min(scale, (bounds.X - 24) / size.X.Offset, (bounds.Y - 24) / size.Y.Offset)
        end
    end
    self:_applyScale(math.clamp(scale, 0.35, 3))
end

function Window:_applyScale(scale)
    self.Scale = scale
    self.UIScale.Scale = scale
    Layer.SetScale(scale)
    for _, panel in self.Panels do
        panel:_applyScale()
    end
end

-- "Off" | "Screen" | "Window"
function Window:SetBlur(mode)
    self.Interface.Blur = mode
    self.Acrylic:SetMode(mode)
    self:SaveState()
end

-- multiplier on top of the screen fit (1 = 100 %)
function Window:SetScale(multiplier)
    self.Interface.Scale = multiplier
    self:SaveState()
    self:_fitScale()
end

function Window:SetFitScreen(on)
    self.Interface.FitScreen = on and true or false
    self:SaveState()
    self:_fitScale()
end

-- keeps at least part of the window on screen after a resolution change
function Window:_clampRoot()
    local root, bounds = self.Root, Layer.Bounds()
    local position, size = root.AbsolutePosition, root.AbsoluteSize
    local dx = math.clamp(position.X, 60 - size.X, bounds.X - 60) - position.X
    local dy = math.clamp(position.Y, 0, bounds.Y - 60) - position.Y
    if dx ~= 0 or dy ~= 0 then root.Position += UDim2.fromOffset(dx, dy) end
end

function Window:SetMinimized(minimized)
    self.Minimized = minimized and true or false
    Popup.CloseAll()
    local root = self.Root
    if self.Minimized then
        self._restoreSize = root.Size
        self.Sidebar.Visible, self.Content.Visible, self.SideDivider.Visible = false, false, false
        self.TopDivider.Visible, self.Grip.Visible = false, false
        self.Actions.Search.Visible = false
        self.SubtitleLabel.Visible = false
        local width = math.max(self.TitleLabel.Parent.AbsoluteSize.X / self:GetScale() + 48 + 90, 240)
        Util.Tween(root, 0.35, { Size = UDim2.fromOffset(width, TOP) })
        self.MinimizeIcon.Image = Util.IconId("maximize-2")
    else
        local tween = Util.Tween(root, 0.35, { Size = self._restoreSize or root.Size })
        local function show()
            self.Sidebar.Visible, self.Content.Visible, self.SideDivider.Visible = true, true, true
            self.TopDivider.Visible, self.Grip.Visible = true, self.Def.Resizable ~= false
            self.Actions.Search.Visible = self.Def.Search ~= false
            self.SubtitleLabel.Visible = true
        end
        if tween then tween.Completed:Once(show) else show() end
        self.MinimizeIcon.Image = Util.IconId("minus")
    end
end

function Window:_open()
    self.Root.Visible = true
    self.UIScale.Scale = self:GetScale() * 0.92
    Util.Tween(self.UIScale, 0.35, { Scale = self:GetScale() }, Enum.EasingStyle.Back)
end

function Window:SetVisible(visible)
    visible = visible and true or false
    if visible == self.Visible then return end
    self.Visible = visible
    Popup.CloseAll()
    Tooltip.Hide()
    if visible then
        self:_open()
    else
        local tween = Util.Tween(self.UIScale, 0.18, { Scale = self:GetScale() * 0.94 }, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
        local function hide() if not self.Visible then self.Root.Visible = false end end
        if tween then tween.Completed:Once(hide) else hide() end
    end
    self.Acrylic:SetVisible(visible)
    for _, panel in self.Panels do panel:SetVisible(panel.Visible) end
    for _, button in self.ScreenButtons do button:Refresh() end
    self.Overlays:UpdateVisibility()
    self.Overlays:RefreshBinds()
end

function Window:Toggle()
    self:SetVisible(not self.Visible)
end

function Window:SetTitle(text)
    self.TitleLabel.Text = text
end

function Window:SetSubtitle(text)
    self.SubtitleLabel.Text = text
end

-- tabs ------------------------------------------------------------------------

function Window:Tab(def)
    if type(def) == "string" then def = { Title = def } end
    def = def or {}
    local tab = Tab.new(self, def)
    self._order = (self._order or 0) + 1
    if def.Pinned then
        tab.Entry = self:_entry(self.SidebarBottom, tab.Title, tab.Icon or "settings", 1, function() self:SelectTab(tab) end)
    else
        tab.Entry = self:_entry(self.TabList, tab.Title, tab.Icon or "layout-grid", self._order, function() self:SelectTab(tab) end)
    end
    tab.Button = tab.Entry
    table.insert(self.Tabs, tab)
    if self.Interface.Tab == tab.Id and not self._restored then
        self._restored = true
        self:SelectTab(tab, nil, true)
    elseif not self.SelectedPage and not def.Pinned then
        self:SelectTab(tab, nil, true)
    end
    return tab
end
Window.AddTab = Window.Tab

-- sidebar caption between tab groups
function Window:TabSection(text)
    self._order = (self._order or 0) + 1
    local label = Util.Label({
        Text = string.upper(text),
        TextSize = 10,
        Color = "TextMuted",
        Weight = Enum.FontWeight.Bold,
        Size = UDim2.new(1, 0, 0, 22),
        LayoutOrder = self._order,
        Parent = self.TabList,
    })
    Util.Padding(label, 8, 0, 0, 6)
    self._headers = self._headers or {}
    table.insert(self._headers, label)
    label.Visible = not self.Interface.Compact
    return label
end

function Window:Divider()
    self._order = (self._order or 0) + 1
    return self:_sidebarDivider(self._order)
end

-- target: a tab (its Frame) or the favourites / search page
function Window:_showPage(target)
    Popup.CloseAll()
    local frame = target.Frame
    for _, other in { self.Favorites, self.SearchPage } do
        if other and other.Frame ~= frame then other.Frame.Visible = false end
    end
    for _, tab in self.Tabs do
        if tab.Frame ~= frame then tab.Frame.Visible = false end
    end
    if not frame.Visible then
        frame.Visible = true
        frame.Position = UDim2.fromOffset(0, 10)
        Util.Tween(frame, 0.3, { Position = UDim2.new() })
    end
end

function Window:_select(entry, page, id)
    for _, other in self.Entries do
        if other.Selected ~= (other == entry) then other.SetSelected(other == entry) end
    end
    self.SelectedPage = page
    if self._searching then
        self.SearchBox.Text = ""
        self._searching = false
        self.Query = nil
        self.SearchPage:Clear()
        task.defer(Theme.Apply)
    end
    self:_showPage(page)
    if id then
        self.Interface.Tab = id
        self:SaveState()
    end
end

-- tab: a tab, a sub-tab or an index; focus: optional module to scroll to
function Window:SelectTab(tab, focus, silent)
    if type(tab) == "number" then tab = self.Tabs[tab] end
    if type(tab) == "string" then
        local name = tab
        tab = nil
        for _, candidate in self.Tabs do
            if candidate.Title == name or candidate.Id == name then tab = candidate end
        end
    end
    if not tab then return end
    local top = tab.Parent or tab
    if tab.Parent then tab.Parent:_showSub(tab, silent) end
    self.Selected = top
    self:_select(top.Entry, top, not silent and top.Id or nil)
    if focus then
        task.defer(function()
            local page = top:PageOf(focus)
            local view = page and page:Find(focus)
            if not view then return end
            if top.SubTabs then
                for _, sub in top.SubTabs do
                    if sub.Page == page then top:_showSub(sub, true) end
                end
            end
            local column = page.Columns[view.Column]
            local offset = view.Card.AbsolutePosition.Y - column.AbsolutePosition.Y + column.CanvasPosition.Y - 8
            column.CanvasPosition = Vector2.new(0, math.max(offset / self:GetScale(), 0))
        end)
    end
end

-- every module of every tab and sub-tab
function Window:Modules()
    local list = {}
    for _, tab in self.Tabs do
        for _, module in tab.Modules do table.insert(list, module) end
        for _, sub in tab.SubTabs or {} do
            if sub ~= tab.Shared then
                for _, module in sub.Modules do table.insert(list, module) end
            end
        end
    end
    return list
end

function Window:SelectFavorites()
    self.Selected = nil
    self:_select(self.FavoritesEntry, self.Favorites, "favorites")
end

-- favourites / search ---------------------------------------------------------

function Window:_favoriteCount()
    local count = 0
    for _ in self.State.Favorites do count += 1 end
    return count
end

function Window:_addFavoriteView(module)
    if not self.Favorites:Find(module) then self.Favorites:Add(module) end
    self.FavoritesEntry.SetBadge(self:_favoriteCount())
end

function Window:_setFavorite(module, favorite)
    if module.Favorite == favorite then return end
    module.Favorite = favorite
    self.State.Favorites[module.Id] = favorite or nil
    if favorite then
        self:_addFavoriteView(module)
    else
        self.Favorites:Remove(module)
    end
    self.FavoritesEntry.SetBadge(self:_favoriteCount())
    module.StateChanged:Fire("Favorite")
    self:SaveState()
end

-- the bell on a card: its own on / off flips show a notification
function Window:_setNotify(module, on)
    if module.Notify == on then return end
    module.Notify = on
    self.State.Notify[module.Id] = on
    module.StateChanged:Fire("Notify")
    self:SaveState()
end

-- one notification per feature: a fast on / off / on updates it instead of stacking
function Window:_toggleNote(owner, enabled)
    local mode = self.Interface.ToggleAlerts
    if mode == "Off" or (mode == "Hidden" and self.Visible) or self.Config._loading then return end
    Notification.Notify({
        Id = owner,
        Title = owner.Title,
        Content = enabled and "On" or "Off",
        Color = enabled and "Success" or "Danger",
        Icon = enabled and "toggle-right" or "toggle-left",
        Duration = 2,
    })
end

function Window:ClearFavorites()
    for _, module in self:Modules() do
        if module.Favorite then self:_setFavorite(module, false) end
    end
    table.clear(self.State.Favorites)
    self:SaveState()
end

function Window:_removeModule(module)
    local owner = module.Tab
    local index = table.find(owner.Modules, module)
    if index then table.remove(owner.Modules, index) end
    owner.Page:Remove(module)
    self.Favorites:Remove(module)
    self.SearchPage:Remove(module)
    local bind = table.find(self._binds, module)
    if bind then table.remove(self._binds, bind) end
end

function Window:_search(text)
    local query = text:lower():match("^%s*(.-)%s*$")
    self.Query = query ~= "" and query or nil
    task.defer(Theme.Apply)
    if query == "" then
        if self._searching then
            self._searching = false
            self.SearchPage:Clear()
            if self.SelectedPage then self:_showPage(self.SelectedPage) end
        end
        return
    end
    self._searching = true
    self.SearchPage:Clear()
    local found = 0
    for _, module in self:Modules() do
        if module.Visible and module:Matches(query) then
            found += 1
            local direct = (module.Title .. " " .. (module.Description or "")):lower():find(query, 1, true)
            if not direct and #module.Children > 0 then module:SetExpanded(true) end
            self.SearchPage:Add(module)
        end
    end
    self.SearchPage:SetEmpty(found == 0 and ('No results for "' .. text .. '"') or "")
    self.SearchPage:UpdateEmpty()
    self:_showPage(self.SearchPage)
end

-- misc ------------------------------------------------------------------------

function Window:Dialog(options)
    return Dialog.Open(self.Root, options)
end

function Window:Notify(options)
    return self.Library:Notify(options)
end

-- floating window with elements; see Components/Panel
function Window:Panel(def)
    if type(def) == "string" then def = { Title = def } end
    local panel = Panel.new(self, def or {})
    table.insert(self.Panels, panel)
    return panel
end

-- on-screen button for touch screens; see Components/ScreenButton
function Window:ScreenButton(def)
    local button = ScreenButton.new(self, def or {})
    table.insert(self.ScreenButtons, button)
    if not self._buttonBeat then
        -- active states change outside the menu too (keys, the game)
        local last = 0
        self._buttonBeat = self.Maid:Give(Services.RunService.Heartbeat:Connect(function()
            local now = os.clock()
            if now - last < 0.1 then return end
            last = now
            for _, other in self.ScreenButtons do
                if other.Visible then other:Refresh() end
            end
        end))
    end
    return button
end

-- every on-screen button: scale and background transparency in percent
function Window:SetScreenButtonStyle(scale, transparency)
    if scale then self.Interface.ButtonScale = scale end
    if transparency then self.Interface.ButtonTransparency = transparency end
    for _, button in self.ScreenButtons do button:ApplyStyle() end
    self:SaveState()
end

-- context menu at the mouse (or options.Anchor); items: { Title, Icon, Callback, Checked, Danger, Disabled, Hint } or "-"
function Window:Menu(items, options)
    options = options or {}
    return Menu.Open({ Items = items, Title = options.Title, Anchor = options.Anchor, Point = options.Anchor == nil and Util.Pointer() or nil, Width = options.Width })
end

function Window:SetSize(size)
    if typeof(size) == "Vector2" then size = UDim2.fromOffset(size.X, size.Y) end
    self.Root.Size = size
    self.Interface.Size = { math.floor(size.X.Offset), math.floor(size.Y.Offset) }
    self:SaveState()
end

function Window:Center()
    self.Root.Position = UDim2.fromScale(0.5, 0.5)
    self.Interface.Position = nil
    self:SaveState()
end

-- extra watermark text after the title: a string or a function called twice a second
function Window:SetWatermark(text)
    self.Overlays:SetWatermarkText(text)
end

function Window:LoadAutoload()
    local name = self.Config:GetAutoload()
    local first = self.Def.DefaultConfig
    if not name and first and not self.Config:Exists(first) then
        -- first run: the defaults become a config that later changes are saved into
        local ok = self.Config:Save(first)
        if ok then self.Config:SetAutoload(first) end
        return ok
    end
    if not name then return false end
    local ok, err = self.Config:Load(name)
    if ok then
        if self.Interface.NotifyConfig ~= false then
            self.Library:Notify({ Title = "Config loaded", Content = name, Type = "Success", Duration = 3 })
        end
    else
        self.Library:Notify({ Title = "Autoload failed", Content = err, Type = "Error" })
    end
    return ok
end

function Window:SetInterface(key, value)
    self.Interface[key] = value
    self:SaveState()
end

function Window:Destroy()
    if self.Destroyed then return end
    self.Destroyed = true
    Popup.CloseAll()
    Tooltip.Hide()
    self.Maid:Clean()
end

return Window
end

__modules["Core/Binding"] = function(...)
local import = ...
local Signal = import("Core/Signal")
local Keybinds = import("Core/Keybinds")

-- key + activation mode owned by a module, toggle, button or keybind element
local Binding = {}
Binding.__index = Binding

local function keyName(value)
    if typeof(value) == "EnumItem" then return value.Name end
    if type(value) == "string" and value ~= "" and value ~= "None" then return value end
    return nil
end
Binding.KeyName = keyName

-- options: Key, Mode, Modes, Press(binding), Release(binding),
--          Capture = { Blacklist, AllowMouse, CanUnbind, ClickOutside, Escape } (see Keybinds.Capture)
function Binding.new(options)
    local capture = options.Capture or {}
    local self = setmetatable({
        Key = keyName(options.Key),
        Mode = options.Mode or "Toggle",
        Modes = options.Modes or { "Toggle", "Hold" },
        Changed = Signal.new(),
        Held = false,
        CanUnbind = capture.CanUnbind ~= false,
        CaptureOptions = {
            Blacklist = capture.Blacklist,
            AllowMouse = capture.AllowMouse,
            CanUnbind = capture.CanUnbind,
            ClickOutside = capture.ClickOutside,
            Escape = capture.Escape,
            ComboKeys = capture.ComboKeys,
        },
    }, Binding)
    if not table.find(self.Modes, self.Mode) then self.Mode = self.Modes[1] end
    self._entry = Keybinds.Add({
        Key = function() return self.Key end,
        Press = function()
            self.Held = true
            if options.Press then options.Press(self) end
        end,
        Release = function()
            if not self.Held then return end
            self.Held = false
            if options.Release then options.Release(self) end
        end,
    })
    return self
end

function Binding:SetKey(key)
    if keyName(key) == nil and not self.CanUnbind then return end
    self.Key = keyName(key)
    self.Held = false
    self.Changed:Fire()
end

-- waits for the next key; Backspace clears, Escape cancels
function Binding:Capture()
    if self.Capturing then return end
    self.Capturing = true
    self.Pending = nil
    self.Changed:Fire()
    local options = table.clone(self.CaptureOptions)
    -- the held part of a combo, shown while the next key is awaited
    options.Progress = function(text)
        self.Pending = text
        self.Changed:Fire()
    end
    Keybinds.Capture(function(result)
        self.Capturing = false
        self.Pending = nil
        if result == false then
            self.Key = nil
        elseif result then
            self.Key = result
        end
        self.Held = false
        self.Changed:Fire()
    end, options)
end

function Binding:SetMode(mode)
    if not table.find(self.Modes, mode) then return end
    self.Mode = mode
    self.Changed:Fire()
end

function Binding:Save()
    return { Key = self.Key or false, Mode = self.Mode }
end

function Binding:Load(data)
    if type(data) ~= "table" then return end
    local key = keyName(data.Key)
    if key or self.CanUnbind then self.Key = key end
    if data.Mode and table.find(self.Modes, data.Mode) then self.Mode = data.Mode end
    self.Changed:Fire()
end

function Binding:Destroy()
    self._entry:Disconnect()
    self.Changed:Destroy()
end

return Binding
end

__modules["Core/Config"] = function(...)
local import = ...
local Storage = import("Core/Storage")
local Signal = import("Core/Signal")

-- flag registry + named config files under <Folder>/configs
local Config = {}
Config.__index = Config

local INVALID = '[\\/:%*%?"<>|]'

function Config.new(folder)
    local self = setmetatable({
        Folder = folder,
        Dir = folder .. "/configs",
        Flags = {},
        Current = nil,
        AutoSave = false,
        Changed = Signal.new(),     -- list / current / autoload changed
        Loaded = Signal.new(),      -- a config was applied
        _loading = false,
        _saveQueued = false,
    }, Config)
    Storage.Ensure(self.Dir)
    return self
end

function Config.ValidName(name)
    if type(name) ~= "string" then return false, "Enter a name." end
    name = name:match("^%s*(.-)%s*$")
    if name == "" then return false, "Enter a name." end
    if #name > 48 then return false, "Name is too long." end
    if name:find(INVALID) then return false, "Name contains invalid characters." end
    return true, name
end

function Config:Register(flag, element)
    if self.Flags[flag] and self.Flags[flag] ~= element then
        warn("[OasisUI] duplicate flag '" .. flag .. "', the newer element wins")
    end
    self.Flags[flag] = element
end

function Config:Unregister(flag, element)
    if self.Flags[flag] == element then self.Flags[flag] = nil end
end

function Config:Snapshot()
    local flags = {}
    for flag, element in self.Flags do
        if not element.NoSave then
            local ok, value = pcall(element.Save, element)
            if ok and value ~= nil then
                flags[flag] = value
            elseif not ok then
                warn("[OasisUI] save " .. flag .. ": " .. tostring(value))
            end
        end
    end
    return { Version = 1, Flags = flags }
end

function Config:Apply(snapshot)
    if type(snapshot) ~= "table" or type(snapshot.Flags) ~= "table" then return false, "Invalid config data." end
    self._loading = true
    for flag, value in snapshot.Flags do
        local element = self.Flags[flag]
        if element and not element.NoSave then
            local ok, err = pcall(element.Load, element, value)
            if not ok then warn("[OasisUI] load " .. flag .. ": " .. tostring(err)) end
        end
    end
    self._loading = false
    self.Loaded:Fire()
    return true
end

function Config:Path(name)
    return self.Dir .. "/" .. name .. ".json"
end

function Config:List()
    return Storage.List(self.Dir, "json")
end

function Config:Exists(name)
    return Storage.Exists(self:Path(name))
end

function Config:Save(name)
    local ok, clean = Config.ValidName(name or self.Current)
    if not ok then return false, clean end
    if not Storage.Available then return false, "File access is not supported." end
    if not Storage.WriteJSON(self:Path(clean), self:Snapshot()) then return false, "Could not write the file." end
    self.Current = clean
    self.Changed:Fire()
    return true, clean
end

function Config:Load(name)
    local ok, clean = Config.ValidName(name)
    if not ok then return false, clean end
    local data = Storage.ReadJSON(self:Path(clean))
    if not data then return false, "Config not found." end
    local applied, err = self:Apply(data)
    if not applied then return false, err end
    self.Current = clean
    self.Changed:Fire()
    return true, clean
end

function Config:Delete(name)
    local ok, clean = Config.ValidName(name)
    if not ok then return false, clean end
    if not self:Exists(clean) then return false, "Config not found." end
    Storage.Delete(self:Path(clean))
    if self.Current == clean then self.Current = nil end
    if self:GetAutoload() == clean then self:SetAutoload(nil) end
    self.Changed:Fire()
    return true, clean
end

function Config:Rename(old, new)
    local okOld, from = Config.ValidName(old)
    if not okOld then return false, from end
    local okNew, to = Config.ValidName(new)
    if not okNew then return false, to end
    if from == to then return true, to end
    local content = Storage.Read(self:Path(from))
    if not content then return false, "Config not found." end
    if self:Exists(to) then return false, "A config with that name exists." end
    if not Storage.Write(self:Path(to), content) then return false, "Could not write the file." end
    Storage.Delete(self:Path(from))
    if self.Current == from then self.Current = to end
    if self:GetAutoload() == from then self:SetAutoload(to) end
    self.Changed:Fire()
    return true, to
end

function Config:GetAutoload()
    local name = Storage.Read(self.Dir .. "/autoload.txt")
    if name and name ~= "" and self:Exists(name) then return name end
    return nil
end

function Config:SetAutoload(name)
    if name then
        Storage.Write(self.Dir .. "/autoload.txt", name)
    else
        Storage.Delete(self.Dir .. "/autoload.txt")
    end
    self.Changed:Fire()
end

function Config:LoadAutoload()
    local name = self:GetAutoload()
    if name then return self:Load(name) end
    return false, "No autoload config."
end

function Config:Export()
    return Storage.Encode(self:Snapshot())
end

function Config:Import(text)
    local data = type(text) == "string" and Storage.Decode(text)
    if not data then return false, "Clipboard does not hold a config." end
    return self:Apply(data)
end

-- called by elements on every change; debounced save into the current config
function Config:Touch()
    if self._loading or not self.AutoSave or not self.Current or self._saveQueued then return end
    self._saveQueued = true
    task.delay(1, function()
        self._saveQueued = false
        if self.AutoSave and self.Current then self:Save(self.Current) end
    end)
end

return Config
end

__modules["Core/Drag"] = function(...)
local import = ...
local Services = import("Core/Services")
local Util = import("Core/Util")
local Layer = import("Components/Layer")

local UIS = Services.UserInputService
local Drag = {}

-- follows the press that started it (that touch, or the mouse) until it ends or is cancelled;
-- owner (optional): the dragged gui, its scrolling ancestors hold still while a touch drags it
function Drag.Follow(input, onMove, onEnd, owner)
    local touch = input.UserInputType == Enum.UserInputType.Touch
    local start = Util.Pointer(input)
    local moved = false
    local finished = false
    local connections = {}
    local locked = {}

    -- a scrolling frame would take the touch over and cancel it
    if touch and owner then
        local node = owner.Parent
        while node and not node:IsA("LayerCollector") do
            if node:IsA("ScrollingFrame") and node.ScrollingEnabled then
                node.ScrollingEnabled = false
                table.insert(locked, node)
            end
            node = node.Parent
        end
    end

    local function stop()
        for _, connection in connections do connection:Disconnect() end
        table.clear(connections)
        for _, frame in locked do frame.ScrollingEnabled = true end
        table.clear(locked)
    end

    local function finish()
        if finished then return end
        finished = true
        stop()
        if onEnd then onEnd(moved) end
    end

    table.insert(connections, UIS.InputChanged:Connect(function(change)
        local follows = touch and change == input or (not touch and change.UserInputType == Enum.UserInputType.MouseMovement)
        if not follows then return end
        local point = Util.Pointer(touch and change or nil)
        if not moved and (point - start).Magnitude > 3 then moved = true end
        onMove(point, point - start, moved)
    end))
    table.insert(connections, UIS.InputEnded:Connect(function(finishInput)
        local ends = touch and finishInput == input or (not touch and finishInput.UserInputType == Enum.UserInputType.MouseButton1)
        if ends then finish() end
    end))
    -- a cancelled touch fires no InputEnded; a drag left running would follow the next touch that reuses
    -- this input object and drag the element along like a magnet
    if touch then
        table.insert(connections, input.Changed:Connect(function(property)
            if property ~= "UserInputState" then return end
            local state = input.UserInputState
            if state == Enum.UserInputState.End or state == Enum.UserInputState.Cancel then finish() end
        end))
    end
    return function()
        finished = true
        stop()
    end
end

-- every attached handle -> the frame it moves; a press starts only the one drawn on top, so stacked
-- panels move one at a time
local handles = {}

-- the handle whose moved frame is drawn on top at point (AbsolutePosition space)
function Drag.Topmost(candidates, point)
    if #candidates < 2 then return candidates[1] end
    local root = candidates[1]:FindFirstAncestorWhichIsA("BasePlayerGui")
    if root then
        local inset = Services.GuiService:GetGuiInset()
        local ok, objects = pcall(root.GetGuiObjectsAtPosition, root, point.X + inset.X, point.Y + inset.Y)
        if ok then
            -- topmost first; any part of a moved frame (its background too) covers what lies below
            for _, object in objects do
                for _, candidate in candidates do
                    local target = handles[candidate] or candidate
                    if object == target or object:IsDescendantOf(target) then return candidate end
                end
            end
        end
    end
    return candidates[#candidates]
end

-- moves `target` (offset position) while `handle` is dragged; keeps `margin` px on screen
function Drag.Attach(handle, target, options)
    options = options or {}
    local margin = options.Margin or 48
    handles[handle] = target
    local connection = handle.InputBegan:Connect(function(input)
        if not Util.IsPress(input) then return end
        if options.Enabled and not options.Enabled() then return end
        local point = Util.Pointer(input)
        local here = {}
        for other in handles do
            if other.Parent and Util.Shown(other) and Util.Contains(other, point) then table.insert(here, other) end
        end
        if #here > 1 and Drag.Topmost(here, point) ~= handle then return end
        Drag._start(input, target, options, margin)
    end)
    local gone = handle.Destroying:Connect(function() handles[handle] = nil end)
    return {
        Disconnect = function()
            connection:Disconnect()
            gone:Disconnect()
            handles[handle] = nil
        end,
    }
end

function Drag._start(input, target, options, margin)
    local origin = target.Position
    Drag.Follow(input, function(_, delta)
        local scale = options.Scale and options.Scale() or 1
        local goal = UDim2.new(origin.X.Scale, origin.X.Offset + delta.X / scale, origin.Y.Scale, origin.Y.Offset + delta.Y / scale)
        target.Position = goal
        if options.Clamp ~= false then
            local viewport = Layer.Bounds()
            local position, size = target.AbsolutePosition, target.AbsoluteSize
            local dx = math.clamp(position.X, margin - size.X, viewport.X - margin) - position.X
            local dy = math.clamp(position.Y, 0, viewport.Y - margin) - position.Y
            if dx ~= 0 or dy ~= 0 then
                target.Position = goal + UDim2.fromOffset(dx / scale, dy / scale)
            end
        end
    end, function(moved)
        if options.OnEnd then options.OnEnd(moved) end
    end)
end

return Drag
end

__modules["Core/Icons"] = function(...)
-- lucide subset; regenerate with build/icons.mjs, extend at runtime with Library:AddIcons
return {
    ["activity"]               = "rbxassetid://94212016861936",
    ["alarm-clock"]            = "rbxassetid://126259032907535",
    ["arrow-down"]             = "rbxassetid://98764963621439",
    ["arrow-left"]             = "rbxassetid://102531941843733",
    ["arrow-right"]            = "rbxassetid://113692007244654",
    ["arrow-up"]               = "rbxassetid://89282378235317",
    ["arrow-up-down"]          = "rbxassetid://81019887641527",
    ["badge-check"]            = "rbxassetid://76078495178149",
    ["ban"]                    = "rbxassetid://90767043015246",
    ["battery"]                = "rbxassetid://70765800346189",
    ["bell"]                   = "rbxassetid://97392696311902",
    ["bell-off"]               = "rbxassetid://78560046118930",
    ["bell-ring"]              = "rbxassetid://94612128913941",
    ["blend"]                  = "rbxassetid://111679612185257",
    ["bolt"]                   = "rbxassetid://102881251417484",
    ["book"]                   = "rbxassetid://125383279695672",
    ["book-open"]              = "rbxassetid://129845326810392",
    ["bookmark"]               = "rbxassetid://121093149326239",
    ["bot"]                    = "rbxassetid://80451686744860",
    ["box"]                    = "rbxassetid://101768155599700",
    ["brush"]                  = "rbxassetid://127035535799640",
    ["bug"]                    = "rbxassetid://83626408925438",
    ["calendar"]               = "rbxassetid://114792700814035",
    ["camera"]                 = "rbxassetid://79950339943067",
    ["chart-bar"]              = "rbxassetid://105389816384108",
    ["chart-line"]             = "rbxassetid://101833156055618",
    ["chart-no-axes-combined"] = "rbxassetid://121424233161912",
    ["check"]                  = "rbxassetid://93898873302694",
    ["check-check"]            = "rbxassetid://95183312173858",
    ["chevron-down"]           = "rbxassetid://134243273101015",
    ["chevron-left"]           = "rbxassetid://73780377692148",
    ["chevron-right"]          = "rbxassetid://92473583511724",
    ["chevron-up"]             = "rbxassetid://122444883127455",
    ["chevrons-up-down"]       = "rbxassetid://131833120209646",
    ["circle"]                 = "rbxassetid://130359823580534",
    ["circle-alert"]           = "rbxassetid://83898160590116",
    ["circle-check"]           = "rbxassetid://85262178816537",
    ["circle-dot"]             = "rbxassetid://82947033619201",
    ["circle-question-mark"]   = "rbxassetid://97516698664325",
    ["circle-x"]               = "rbxassetid://76821953846248",
    ["clipboard"]              = "rbxassetid://89601995828423",
    ["clipboard-paste"]        = "rbxassetid://74382068849983",
    ["clock"]                  = "rbxassetid://121808839832144",
    ["cloud"]                  = "rbxassetid://121226497050352",
    ["code"]                   = "rbxassetid://107380207681249",
    ["cog"]                    = "rbxassetid://116544501716299",
    ["columns-2"]              = "rbxassetid://113004100221850",
    ["command"]                = "rbxassetid://93648221906330",
    ["compass"]                = "rbxassetid://115123411028382",
    ["contrast"]               = "rbxassetid://112796643981497",
    ["copy"]                   = "rbxassetid://78979572434545",
    ["cpu"]                    = "rbxassetid://77549309870247",
    ["crosshair"]              = "rbxassetid://134242818164054",
    ["crown"]                  = "rbxassetid://127843403295538",
    ["database"]               = "rbxassetid://126791525623846",
    ["diamond"]                = "rbxassetid://105846996304890",
    ["dot"]                    = "rbxassetid://137321056643916",
    ["download"]               = "rbxassetid://134814648082393",
    ["droplet"]                = "rbxassetid://100597455015098",
    ["ellipsis"]               = "rbxassetid://140019550645825",
    ["ellipsis-vertical"]      = "rbxassetid://117978708573781",
    ["expand"]                 = "rbxassetid://137492887754537",
    ["external-link"]          = "rbxassetid://129331830773832",
    ["eye"]                    = "rbxassetid://100033680381365",
    ["eye-off"]                = "rbxassetid://135928786788378",
    ["file"]                   = "rbxassetid://74748492079329",
    ["file-braces"]            = "rbxassetid://95314128621234",
    ["file-code"]              = "rbxassetid://130978036895504",
    ["file-plus"]              = "rbxassetid://78881710800060",
    ["file-text"]              = "rbxassetid://90496405707281",
    ["fingerprint"]            = "rbxassetid://112173305232811",
    ["flag"]                   = "rbxassetid://78183383236196",
    ["flame"]                  = "rbxassetid://98218034436456",
    ["flask-conical"]          = "rbxassetid://128406680901165",
    ["folder"]                 = "rbxassetid://80846616596607",
    ["folder-open"]            = "rbxassetid://76018996254888",
    ["funnel"]                 = "rbxassetid://108829540827529",
    ["gamepad-2"]              = "rbxassetid://92483947987410",
    ["gauge"]                  = "rbxassetid://110273524101447",
    ["gem"]                    = "rbxassetid://112904952151156",
    ["ghost"]                  = "rbxassetid://113822048130017",
    ["gift"]                   = "rbxassetid://109855212076373",
    ["git-branch"]             = "rbxassetid://90490195516649",
    ["globe"]                  = "rbxassetid://114238209622913",
    ["grip-vertical"]          = "rbxassetid://137183678565296",
    ["hammer"]                 = "rbxassetid://83545120140895",
    ["hand"]                   = "rbxassetid://130703864968637",
    ["hash"]                   = "rbxassetid://82890331678520",
    ["heart"]                  = "rbxassetid://116559368303288",
    ["history"]                = "rbxassetid://123980022019922",
    ["hourglass"]              = "rbxassetid://86160434939203",
    ["house"]                  = "rbxassetid://98755624629571",
    ["image"]                  = "rbxassetid://112751259236831",
    ["info"]                   = "rbxassetid://124560466474914",
    ["key"]                    = "rbxassetid://96510194465420",
    ["key-round"]              = "rbxassetid://83619031955390",
    ["keyboard"]               = "rbxassetid://121474456068237",
    ["languages"]              = "rbxassetid://90816903776498",
    ["layers"]                 = "rbxassetid://81973586053257",
    ["layout-dashboard"]       = "rbxassetid://139929981863901",
    ["layout-grid"]            = "rbxassetid://81344910161871",
    ["layout-list"]            = "rbxassetid://87462136296578",
    ["library"]                = "rbxassetid://114334671982047",
    ["link"]                   = "rbxassetid://131607023382430",
    ["list"]                   = "rbxassetid://113179976918783",
    ["list-filter"]            = "rbxassetid://103321376129527",
    ["loader"]                 = "rbxassetid://78408734580845",
    ["loader-circle"]          = "rbxassetid://116535712789945",
    ["lock"]                   = "rbxassetid://134724289526879",
    ["lock-open"]              = "rbxassetid://93597915325122",
    ["log-in"]                 = "rbxassetid://103768533135201",
    ["log-out"]                = "rbxassetid://84895399304975",
    ["magnet"]                 = "rbxassetid://135162361226972",
    ["map"]                    = "rbxassetid://95107167260947",
    ["maximize-2"]             = "rbxassetid://73085922906397",
    ["menu"]                   = "rbxassetid://77021539815611",
    ["message-square"]         = "rbxassetid://83881670383280",
    ["mic"]                    = "rbxassetid://89640799126523",
    ["minimize-2"]             = "rbxassetid://116269596042539",
    ["minus"]                  = "rbxassetid://118026365011536",
    ["monitor"]                = "rbxassetid://72664649203050",
    ["moon"]                   = "rbxassetid://83380517901735",
    ["mouse"]                  = "rbxassetid://73096068864710",
    ["mouse-pointer-click"]    = "rbxassetid://107150227368485",
    ["move"]                   = "rbxassetid://116138709011735",
    ["music"]                  = "rbxassetid://113343203848535",
    ["navigation"]             = "rbxassetid://79308213542922",
    ["orbit"]                  = "rbxassetid://108926136860562",
    ["package"]                = "rbxassetid://97261141732706",
    ["paintbrush"]             = "rbxassetid://125572663700289",
    ["palette"]                = "rbxassetid://86350350950064",
    ["panel-left"]             = "rbxassetid://97419752870313",
    ["paperclip"]              = "rbxassetid://92088291163453",
    ["pencil"]                 = "rbxassetid://137986121120732",
    ["pin"]                    = "rbxassetid://120978111007514",
    ["pipette"]                = "rbxassetid://133167932934404",
    ["play"]                   = "rbxassetid://135609604299893",
    ["plus"]                   = "rbxassetid://111774323017047",
    ["power"]                  = "rbxassetid://96479131758775",
    ["radar"]                  = "rbxassetid://138528222906635",
    ["radio"]                  = "rbxassetid://85611589536956",
    ["refresh-cw"]             = "rbxassetid://138133190015277",
    ["rocket"]                 = "rbxassetid://87412317685854",
    ["rotate-ccw"]             = "rbxassetid://110116685948665",
    ["ruler"]                  = "rbxassetid://81432445547423",
    ["save"]                   = "rbxassetid://126116963775616",
    ["scaling"]                = "rbxassetid://122360365318466",
    ["scan"]                   = "rbxassetid://123104789658180",
    ["search"]                 = "rbxassetid://121018724060431",
    ["send"]                   = "rbxassetid://127751956873796",
    ["server"]                 = "rbxassetid://92188766517878",
    ["settings"]               = "rbxassetid://80758916183665",
    ["settings-2"]             = "rbxassetid://135684703553372",
    ["shield"]                 = "rbxassetid://110987169760162",
    ["shield-check"]           = "rbxassetid://87354736164608",
    ["shrink"]                 = "rbxassetid://90953687918880",
    ["shuffle"]                = "rbxassetid://132382786975101",
    ["signal"]                 = "rbxassetid://78424889355261",
    ["skull"]                  = "rbxassetid://137726256442333",
    ["sliders-horizontal"]     = "rbxassetid://85538382643347",
    ["sliders-vertical"]       = "rbxassetid://101190569086853",
    ["smartphone"]             = "rbxassetid://96623008834511",
    ["sparkles"]               = "rbxassetid://138635884129147",
    ["square"]                 = "rbxassetid://86304921356806",
    ["star"]                   = "rbxassetid://136141469398409",
    ["star-off"]               = "rbxassetid://75742832732503",
    ["sun"]                    = "rbxassetid://110150589884127",
    ["sun-dim"]                = "rbxassetid://129141645592715",
    ["sword"]                  = "rbxassetid://124448418211665",
    ["swords"]                 = "rbxassetid://81872698913435",
    ["tag"]                    = "rbxassetid://129104970103940",
    ["target"]                 = "rbxassetid://87563802520297",
    ["terminal"]               = "rbxassetid://106783148545356",
    ["thumbs-up"]              = "rbxassetid://111137070767020",
    ["timer"]                  = "rbxassetid://85473888890506",
    ["toggle-left"]            = "rbxassetid://85887872573050",
    ["toggle-right"]           = "rbxassetid://90411952142550",
    ["trash-2"]                = "rbxassetid://109843431391323",
    ["trending-up"]            = "rbxassetid://81819858538839",
    ["triangle-alert"]         = "rbxassetid://125920361880643",
    ["trophy"]                 = "rbxassetid://131545003268773",
    ["type"]                   = "rbxassetid://133543553793564",
    ["undo-2"]                 = "rbxassetid://113885292059932",
    ["upload"]                 = "rbxassetid://138212042425501",
    ["user"]                   = "rbxassetid://81589895647169",
    ["user-round"]             = "rbxassetid://136485052187963",
    ["users"]                  = "rbxassetid://115398113982385",
    ["volume-2"]               = "rbxassetid://89344380902620",
    ["wand-sparkles"]          = "rbxassetid://82546429942392",
    ["wifi"]                   = "rbxassetid://104669375183960",
    ["wind"]                   = "rbxassetid://114551690399915",
    ["wrench"]                 = "rbxassetid://112148279212860",
    ["x"]                      = "rbxassetid://110786993356448",
    ["zap"]                    = "rbxassetid://130551565616516",
    ["zoom-in"]                = "rbxassetid://127956924984803",
}
end

__modules["Core/Keybinds"] = function(...)
local import = ...
local Services = import("Core/Services")
local Util = import("Core/Util")
local Signal = import("Core/Signal")

-- one InputBegan/InputEnded pair for every bind; keys are read through getters
local UIS = Services.UserInputService
local Keybinds = {
    Capturing = false,
    Activity = Signal.new(),    -- a bound key went down or up
    -- defaults for every capture; a binding can override each field
    Options = {
        ClickOutside = "Keep",  -- "Keep" | "Clear": clicking elsewhere while binding
        Escape = "Keep",        -- "Keep" | "Clear"
        Mouse = true,           -- mouse buttons 2 and 3 can be bound
        ComboKeys = 3,          -- keys per bind: 2 allows LCtrl + L, 1 turns combos off
    },
    _binds = {},
    _capture = nil,
}

-- held while binding, these wait for the next key; let go alone, they are the bind
Keybinds.Modifiers = {
    LeftControl = Enum.KeyCode.LeftControl, RightControl = Enum.KeyCode.RightControl,
    LeftShift = Enum.KeyCode.LeftShift, RightShift = Enum.KeyCode.RightShift,
    LeftAlt = Enum.KeyCode.LeftAlt, RightAlt = Enum.KeyCode.RightAlt,
}

-- "LeftControl+L" -> { "LeftControl" }, "L"
function Keybinds.Split(name)
    local parts = string.split(name, "+")
    local main = table.remove(parts)
    return parts, main
end

local MOUSE = {
    [Enum.UserInputType.MouseButton2] = "MouseButton2",
    [Enum.UserInputType.MouseButton3] = "MouseButton3",
}

function Keybinds.Name(input)
    local kind = input.UserInputType
    if kind == Enum.UserInputType.Keyboard or kind.Name:find("^Gamepad") then
        local name = input.KeyCode.Name
        return name ~= "Unknown" and name or nil
    end
    return MOUSE[kind]
end

-- entry: { Key = function() -> name?, Press = function, Release = function? }
function Keybinds.Add(entry)
    table.insert(Keybinds._binds, entry)
    return {
        Disconnect = function()
            local index = table.find(Keybinds._binds, entry)
            if index then table.remove(Keybinds._binds, index) end
        end,
    }
end

local function finish(result)
    local capture = Keybinds._capture
    if not capture then return end
    Keybinds._capture = nil
    capture.connection:Disconnect()
    if capture.release then capture.release:Disconnect() end
    -- the captured press must not reach the dispatcher in the same frame
    task.defer(function()
        if not Keybinds._capture then Keybinds.Capturing = false end
    end)
    Util.Safe(capture.done, result)
end

local function option(options, key, global)
    if options and options[key] ~= nil then return options[key] end
    return Keybinds.Options[global or key]
end

-- done(name) on a key, done(false) to clear, done(nil) to keep the old key
-- options: Blacklist = { names }, AllowMouse, CanUnbind, ClickOutside, Escape, ComboKeys,
--          Progress(text | nil) while modifiers are held
function Keybinds.Capture(done, options)
    if Keybinds._capture then finish(nil) end
    Keybinds.Capturing = true
    local canUnbind = not options or options.CanUnbind ~= false
    local blacklist = {}
    for _, key in options and options.Blacklist or {} do
        blacklist[typeof(key) == "EnumItem" and key.Name or tostring(key)] = true
    end
    local function clearOrKeep(setting)
        finish(if setting == "Clear" and canUnbind then false else nil)
    end

    -- combo: modifiers pressed so far, in order; the bind ends at the next key, on a release,
    -- or when the combo is full
    local maxKeys = math.max(1, math.floor(tonumber(option(options, "ComboKeys")) or 1))
    local held = {}
    local function progress()
        if options and options.Progress then Util.Safe(options.Progress, #held > 0 and table.concat(held, "+") or nil) end
    end
    local function combo(last)
        local keys = table.clone(held)
        if last then table.insert(keys, last) end
        return table.concat(keys, "+")
    end

    local capture = { done = done }
    capture.connection = UIS.InputBegan:Connect(function(input)
        local kind = input.UserInputType
        if kind == Enum.UserInputType.MouseButton1 or kind == Enum.UserInputType.Touch then
            clearOrKeep(option(options, "ClickOutside"))
        elseif kind == Enum.UserInputType.Keyboard then
            local key = input.KeyCode
            if key == Enum.KeyCode.Escape then
                clearOrKeep(option(options, "Escape"))
            elseif key == Enum.KeyCode.Backspace or key == Enum.KeyCode.Delete then
                finish(if canUnbind then false else nil)
            elseif key ~= Enum.KeyCode.Unknown and not blacklist[key.Name] then
                if Keybinds.Modifiers[key.Name] and #held + 1 < maxKeys and not table.find(held, key.Name) then
                    table.insert(held, key.Name)
                    progress()
                else
                    finish(combo(key.Name))
                end
            end
        elseif MOUSE[kind] then
            if option(options, "AllowMouse", "Mouse") ~= false and not blacklist[MOUSE[kind]] then
                finish(combo(MOUSE[kind]))
            end
        else
            local name = Keybinds.Name(input)
            if name and not blacklist[name] then finish(combo(name)) end
        end
    end)
    -- a held modifier let go before another key: the modifiers alone are the bind
    capture.release = UIS.InputEnded:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
        if table.find(held, input.KeyCode.Name) then finish(combo(nil)) end
    end)
    Keybinds._capture = capture
    task.delay(10, function()
        if Keybinds._capture == capture then finish(nil) end
    end)
end

function Keybinds.CancelCapture()
    finish(nil)
end

local function modifiersDown(keys)
    for _, key in keys do
        local code = Keybinds.Modifiers[key]
        if not (code and UIS:IsKeyDown(code)) then return false end
    end
    return true
end

-- a press fires the binds whose last key it is and whose modifiers are held; the most specific win,
-- so LCtrl + L does not also fire a plain L bind; a release of the last key releases them
local function dispatch(input, release)
    local name = Keybinds.Name(input)
    if not name then return end
    local hits, best = {}, -1
    for _, entry in table.clone(Keybinds._binds) do
        local key = entry.Key()
        if key then
            local modifiers, main = Keybinds.Split(key)
            if main == name then
                if release then
                    table.insert(hits, entry)
                elseif modifiersDown(modifiers) then
                    if #modifiers > best then
                        best, hits = #modifiers, { entry }
                    elseif #modifiers == best then
                        table.insert(hits, entry)
                    end
                end
            end
        end
    end
    for _, entry in hits do
        if release then
            if entry.Release then Util.Safe(entry.Release) end
        else
            Util.Safe(entry.Press)
        end
    end
    if #hits > 0 then Keybinds.Activity:Fire(name, not release) end
end

function Keybinds.Start(maid)
    maid:Give(UIS.InputBegan:Connect(function(input)
        if Keybinds.Capturing or UIS:GetFocusedTextBox() then return end
        dispatch(input, false)
    end))
    maid:Give(UIS.InputEnded:Connect(function(input)
        dispatch(input, true)
    end))
    maid:Give(function()
        finish(nil)
        table.clear(Keybinds._binds)
    end)
end

return Keybinds
end

__modules["Core/Maid"] = function(...)
local _ = ...

-- collects connections, instances, functions and objects; Clean releases them newest first
local Maid = {}
Maid.__index = Maid

function Maid.new()
    return setmetatable({ _tasks = {} }, Maid)
end

function Maid:Give(item)
    table.insert(self._tasks, item)
    return item
end

local function release(item)
    local kind = typeof(item)
    if kind == "RBXScriptConnection" then
        item:Disconnect()
    elseif kind == "Instance" then
        item:Destroy()
    elseif kind == "function" then
        item()
    elseif kind == "thread" then
        pcall(task.cancel, item)
    elseif kind == "table" then
        if item.Disconnect then
            item:Disconnect()
        elseif item.Clean then
            item:Clean()
        elseif item.Destroy then
            item:Destroy()
        end
    end
end

function Maid:Clean()
    local tasks = self._tasks
    self._tasks = {}
    for i = #tasks, 1, -1 do
        local ok, err = pcall(release, tasks[i])
        if not ok then warn("[OasisUI] cleanup: " .. tostring(err)) end
    end
end

Maid.Destroy = Maid.Clean

return Maid
end

__modules["Core/Services"] = function(...)
local _ = ...

local cloneref = cloneref or function(instance) return instance end

local function service(name)
    return cloneref(game:GetService(name))
end

return {
    Players          = service("Players"),
    UserInputService = service("UserInputService"),
    RunService       = service("RunService"),
    TweenService     = service("TweenService"),
    HttpService      = service("HttpService"),
    TextService      = service("TextService"),
    CoreGui          = service("CoreGui"),
    GuiService       = service("GuiService"),
    Lighting         = service("Lighting"),
    Stats            = service("Stats"),
}
end

__modules["Core/Signal"] = function(...)
local _ = ...

-- synchronous signal; handlers run in connect order
local Signal = {}
Signal.__index = Signal

function Signal.new()
    return setmetatable({ _handlers = {} }, Signal)
end

function Signal:Connect(fn)
    local handler = { fn = fn, live = true }
    table.insert(self._handlers, handler)
    local handlers = self._handlers
    local connection = { Connected = true }
    function connection:Disconnect()
        if not handler.live then return end
        handler.live = false
        self.Connected = false
        local index = table.find(handlers, handler)
        if index then table.remove(handlers, index) end
    end
    return connection
end

function Signal:Once(fn)
    local connection
    connection = self:Connect(function(...)
        connection:Disconnect()
        fn(...)
    end)
    return connection
end

function Signal:Fire(...)
    for _, handler in table.clone(self._handlers) do
        if handler.live then handler.fn(...) end
    end
end

function Signal:Destroy()
    for _, handler in self._handlers do handler.live = false end
    table.clear(self._handlers)
end

return Signal
end

__modules["Core/Storage"] = function(...)
local import = ...
local Services = import("Core/Services")

-- executor file api; everything degrades to no-ops when it is missing
local Storage = {}

Storage.Available = type(writefile) == "function" and type(readfile) == "function" and type(isfile) == "function"
    and type(makefolder) == "function" and type(isfolder) == "function"

function Storage.Ensure(path)
    if not Storage.Available then return false end
    local built = ""
    for part in path:gmatch("[^/]+") do
        built = built == "" and part or (built .. "/" .. part)
        if not isfolder(built) then pcall(makefolder, built) end
    end
    return true
end

function Storage.Read(path)
    if not Storage.Available then return nil end
    local ok, exists = pcall(isfile, path)
    if not ok or not exists then return nil end
    local read, content = pcall(readfile, path)
    return read and content or nil
end

function Storage.Write(path, content)
    if not Storage.Available then return false end
    local folder = path:match("^(.*)/[^/]+$")
    if folder then Storage.Ensure(folder) end
    local ok, err = pcall(writefile, path, content)
    if not ok then warn("[OasisUI] write " .. path .. ": " .. tostring(err)) end
    return ok
end

function Storage.Delete(path)
    if not Storage.Available or type(delfile) ~= "function" then return false end
    local ok = pcall(delfile, path)
    return ok
end

function Storage.Exists(path)
    if not Storage.Available then return false end
    local ok, exists = pcall(isfile, path)
    return ok and exists
end

-- file names in folder with extension, without the extension
function Storage.List(folder, extension)
    if not Storage.Available or type(listfiles) ~= "function" then return {} end
    local ok, files = pcall(listfiles, folder)
    if not ok or type(files) ~= "table" then return {} end
    local out = {}
    for _, file in files do
        local name = tostring(file):gsub("\\", "/"):match("([^/]+)%." .. extension .. "$")
        if name then table.insert(out, name) end
    end
    table.sort(out, function(a, b) return a:lower() < b:lower() end)
    return out
end

function Storage.ReadJSON(path)
    local content = Storage.Read(path)
    if not content then return nil end
    local ok, data = pcall(Services.HttpService.JSONDecode, Services.HttpService, content)
    if not ok then
        warn("[OasisUI] invalid json in " .. path)
        return nil
    end
    return data
end

function Storage.WriteJSON(path, data)
    local ok, content = pcall(Services.HttpService.JSONEncode, Services.HttpService, data)
    if not ok then
        warn("[OasisUI] could not encode " .. path .. ": " .. tostring(content))
        return false
    end
    return Storage.Write(path, content)
end

function Storage.Encode(data)
    local ok, content = pcall(Services.HttpService.JSONEncode, Services.HttpService, data)
    return ok and content or nil
end

function Storage.Decode(content)
    local ok, data = pcall(Services.HttpService.JSONDecode, Services.HttpService, content)
    return ok and data or nil
end

return Storage
end

__modules["Core/Theme"] = function(...)
local import = ...
local Signal = import("Core/Signal")
local Services = import("Core/Services")
local Presets = import("Themes/Presets")

-- tokens: colour palette (from a preset) + style values the user tunes on top
local Theme = {
    Presets = Presets,
    Changed = Signal.new(),
    Palette = "Sapphire",
    Current = {} :: { [string]: any },
}

Theme.PaletteKeys = {
    "Accent", "AccentAlt", "Background", "BackgroundAlt", "Surface", "SurfaceHover", "Elevated", "ElevatedHover",
    "Stroke", "Divider", "Text", "TextDim", "TextMuted", "OnAccent", "Success", "Warning", "Danger",
}

Theme.StyleDefaults = {
    WindowTransparency   = 0.06,
    SurfaceTransparency  = 0.3,
    ElevatedTransparency = 0.15,
    StrokeTransparency   = 0.55,
    Radius               = 12,
    ElementRadius        = 8,
    Font                 = "Ubuntu",             -- Montserrat sets letter pairs like "as" too tight at small sizes
    AnimSpeed            = 1,
    Gradient             = true,
    GradientRotation     = 45,
    AnimatedTitle        = true,
}

-- { family, display name }; only families that render differently (GothamSSm draws Montserrat, Arial draws Arimo)
Theme.Fonts = {
    { "Ubuntu", "Ubuntu" },
    { "Montserrat", "Montserrat" },
    { "BuilderSans", "Builder Sans" },
    { "Nunito", "Nunito" },
    { "Roboto", "Roboto" },
    { "SourceSansPro", "Source Sans" },
    { "Arimo", "Arimo" },
    { "JosefinSans", "Josefin Sans" },
    { "TitilliumWeb", "Titillium" },
    { "Oswald", "Oswald" },
    { "Jura", "Jura" },
    { "Zekton", "Zekton" },
    { "Michroma", "Michroma" },
    { "Merriweather", "Merriweather" },
    { "FredokaOne", "Fredoka" },
    { "RobotoMono", "Roboto Mono" },
}

-- strong keys: roblox recycles instance wrappers, so a weak table would lose live bindings;
-- unparented (destroyed) instances are dropped by Apply and Sweep
local registry = {}
local pending = false

local function resolve(token)
    if type(token) == "function" then return token(Theme.Current) end
    return Theme.Current[token]
end
Theme.Resolve = resolve

local function paint(inst, map)
    for prop, token in map do
        local ok, value = pcall(resolve, token)
        if ok and value ~= nil then
            pcall(function() inst[prop] = value end)
        end
    end
end

-- map: property -> token name or function(current) -> value
function Theme.Bind(inst, map)
    local bound = registry[inst]
    if not bound then
        bound = {}
        registry[inst] = bound
    end
    for prop, token in map do bound[prop] = token end
    paint(inst, map)
    return inst
end

function Theme.Unbind(inst, prop)
    local bound = registry[inst]
    if bound then
        if prop then bound[prop] = nil else registry[inst] = nil end
    end
end

-- re-resolves an instance after its state changed; tweens when time > 0
function Theme.Refresh(inst, time)
    local bound = registry[inst]
    if not bound then return end
    local speed = Theme.Current.AnimSpeed or 1
    if not time or time <= 0 or speed <= 0 then
        paint(inst, bound)
        return
    end
    local goal = {}
    for prop, token in bound do
        local ok, value = pcall(resolve, token)
        if ok and value ~= nil then
            local kind = typeof(value)
            if kind == "Color3" or kind == "number" or kind == "UDim" or kind == "UDim2" or kind == "Vector2" then
                goal[prop] = value
            else
                pcall(function() inst[prop] = value end)
            end
        end
    end
    Services.TweenService:Create(inst, TweenInfo.new(time / speed, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), goal):Play()
end

function Theme.Apply()
    for inst, map in registry do
        if inst.Parent == nil then
            registry[inst] = nil
        else
            paint(inst, map)
        end
    end
end

function Theme.Sweep()
    for inst in registry do
        if inst.Parent == nil then registry[inst] = nil end
    end
end

local function schedule()
    if pending then return end
    pending = true
    task.defer(function()
        pending = false
        Theme.Apply()
    end)
end

function Theme.Set(patch)
    for key, value in patch do Theme.Current[key] = value end
    schedule()
    Theme.Changed:Fire(patch)
end

function Theme.Get(key)
    return Theme.Current[key]
end

function Theme.UsePalette(name)
    local palette = Presets[name]
    if type(palette) ~= "table" or name == "Order" then return false end
    Theme.Palette = name
    Theme.Set(table.clone(palette))
    return true
end

function Theme.Font(weight, style)
    return function(current)
        return Font.new("rbxasset://fonts/families/" .. tostring(current.Font) .. ".json", weight or Enum.FontWeight.Regular, style or Enum.FontStyle.Normal)
    end
end

-- json-safe copy: colours as hex
function Theme.Export()
    local out = { Palette = Theme.Palette, Tokens = {} }
    for key, value in Theme.Current do
        -- "_" tokens are runtime state, not part of a theme
        if key:sub(1, 1) ~= "_" then
            out.Tokens[key] = typeof(value) == "Color3" and ("#" .. value:ToHex()) or value
        end
    end
    return out
end

function Theme.Import(data)
    if type(data) ~= "table" or type(data.Tokens) ~= "table" then return false end
    local patch = {}
    for key, value in data.Tokens do
        local current = Theme.Current[key]
        if typeof(current) == "Color3" and type(value) == "string" then
            local ok, color = pcall(Color3.fromHex, value)
            if ok then patch[key] = color end
        elseif current == nil or type(current) == type(value) then
            patch[key] = value
        end
    end
    if type(data.Palette) == "string" then Theme.Palette = data.Palette end
    Theme.Set(patch)
    return true
end

do
    for key, value in Presets.Sapphire do Theme.Current[key] = value end
    for key, value in Theme.StyleDefaults do Theme.Current[key] = value end
end

return Theme
end

__modules["Core/Util"] = function(...)
local import = ...
local Services = import("Core/Services")
local Theme = import("Core/Theme")
local Icons = import("Core/Icons")

local Util = {}

local DEFAULTS = {
    Frame          = { BorderSizePixel = 0 },
    ScrollingFrame = { BorderSizePixel = 0, BackgroundTransparency = 1, ScrollBarThickness = 0, CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollingDirection = Enum.ScrollingDirection.Y },
    TextLabel      = { BorderSizePixel = 0, BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left },
    TextButton     = { BorderSizePixel = 0, AutoButtonColor = false, Text = "" },
    TextBox        = { BorderSizePixel = 0, BackgroundTransparency = 1, ClearTextOnFocus = false, TextXAlignment = Enum.TextXAlignment.Left },
    ImageLabel     = { BorderSizePixel = 0, BackgroundTransparency = 1 },
    ImageButton    = { BorderSizePixel = 0, BackgroundTransparency = 1, AutoButtonColor = false },
}

-- props.Theme binds properties to tokens; props.Parent is set last
function Util.New(class, props, children)
    local inst = Instance.new(class)
    local defaults = DEFAULTS[class]
    if defaults then
        for key, value in defaults do inst[key] = value end
    end
    local theme, parent
    if props then
        for key, value in props do
            if key == "Theme" then
                theme = value
            elseif key == "Parent" then
                parent = value
            else
                inst[key] = value
            end
        end
    end
    if children then
        for _, child in children do child.Parent = inst end
    end
    if theme then Theme.Bind(inst, theme) end
    if parent then inst.Parent = parent end
    return inst
end

function Util.Tween(inst, time, goal, style, direction)
    local speed = Theme.Current.AnimSpeed or 1
    if speed <= 0 or time <= 0 then
        for key, value in goal do inst[key] = value end
        return nil
    end
    local tween = Services.TweenService:Create(inst, TweenInfo.new(time / speed, style or Enum.EasingStyle.Quint, direction or Enum.EasingDirection.Out), goal)
    tween:Play()
    return tween
end

-- radius: number or token name holding a number
function Util.Corner(radius, parent)
    local corner = Util.New("UICorner", { Parent = parent })
    if type(radius) == "string" then
        Theme.Bind(corner, { CornerRadius = function(t) return UDim.new(0, t[radius]) end })
    elseif typeof(radius) == "UDim" then
        corner.CornerRadius = radius
    else
        corner.CornerRadius = UDim.new(0, radius or 6)
    end
    return corner
end

function Util.Stroke(parent, colorToken, transparencyToken, thickness)
    return Util.New("UIStroke", {
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Thickness = thickness or 1,
        Theme = { Color = colorToken or "Stroke", Transparency = transparencyToken or "StrokeTransparency" },
        Parent = parent,
    })
end

function Util.Padding(parent, top, right, bottom, left)
    return Util.New("UIPadding", {
        PaddingTop = UDim.new(0, top or 0),
        PaddingRight = UDim.new(0, right or top or 0),
        PaddingBottom = UDim.new(0, bottom or top or 0),
        PaddingLeft = UDim.new(0, left or right or top or 0),
        Parent = parent,
    })
end

function Util.List(parent, padding, direction, horizontal, vertical)
    return Util.New("UIListLayout", {
        Padding = UDim.new(0, padding or 0),
        FillDirection = direction or Enum.FillDirection.Vertical,
        HorizontalAlignment = horizontal or Enum.HorizontalAlignment.Left,
        VerticalAlignment = vertical or Enum.VerticalAlignment.Top,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = parent,
    })
end

-- themed text; Color/Weight/Size are shortcuts
function Util.Label(props)
    local color = props.Color or "Text"
    local weight = props.Weight or Enum.FontWeight.Regular
    props.Color, props.Weight = nil, nil
    props.TextSize = props.TextSize or 13
    local theme = props.Theme or {}
    theme.TextColor3 = theme.TextColor3 or color
    theme.FontFace = theme.FontFace or Theme.Font(weight)
    props.Theme = theme
    return Util.New("TextLabel", props)
end

Util.Icons = Icons

function Util.IconId(icon)
    if icon == nil or icon == "" then return nil end
    if type(icon) == "number" then return "rbxassetid://" .. icon end
    if icon:find("^%a+://") then return icon end
    if icon:match("^%d+$") then return "rbxassetid://" .. icon end
    return Icons[icon]
end

function Util.Icon(icon, props)
    props = props or {}
    local color = props.Color or "TextDim"
    props.Color = nil
    props.Image = Util.IconId(icon) or ""
    props.ScaleType = props.ScaleType or Enum.ScaleType.Fit
    local theme = props.Theme or {}
    theme.ImageColor3 = theme.ImageColor3 or color
    props.Theme = theme
    return Util.New("ImageLabel", props)
end

-- product of every UIScale above gui (absolute sizes are scaled, offsets are not)
function Util.ScaleOf(gui)
    local scale = 1
    local node = gui
    while node and not node:IsA("LayerCollector") do
        local uiScale = node:FindFirstChildOfClass("UIScale")
        if uiScale then scale *= uiScale.Scale end
        node = node.Parent
    end
    return scale
end

-- sizes a ScrollingFrame's canvas from its list layout; AutomaticCanvasSize misreads UIScale and
-- frames that were filled while hidden
function Util.AutoCanvas(frame, layout, horizontal)
    frame.AutomaticCanvasSize = Enum.AutomaticSize.None
    local padding = frame:FindFirstChildOfClass("UIPadding")
    local function update()
        if not frame.Parent then return end
        local scale = Util.ScaleOf(frame)
        local content = layout.AbsoluteContentSize / math.max(scale, 0.01)
        if horizontal then
            local extra = padding and (padding.PaddingLeft.Offset + padding.PaddingRight.Offset) or 0
            frame.CanvasSize = UDim2.fromOffset(math.ceil(content.X + extra), 0)
        else
            local extra = padding and (padding.PaddingTop.Offset + padding.PaddingBottom.Offset) or 0
            frame.CanvasSize = UDim2.fromOffset(0, math.ceil(content.Y + extra))
        end
    end
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(update)
    frame:GetPropertyChangedSignal("AbsoluteSize"):Connect(update)
    update()
    return update
end

-- a touch screen is in use: a touch-only device, or the last input was a touch
function Util.Touch()
    local UIS = Services.UserInputService
    if UIS.TouchEnabled and not UIS.MouseEnabled then return true end
    return UIS:GetLastInputType() == Enum.UserInputType.Touch
end

-- fn(hovering) on enter and leave; a lifted touch counts as leaving, MouseLeave often never fires on touch
function Util.Hover(gui, fn)
    local hovering = false
    local function set(on)
        if hovering == on then return end
        hovering = on
        fn(on)
    end
    local enter = gui.MouseEnter:Connect(function() set(true) end)
    local leave = gui.MouseLeave:Connect(function() set(false) end)
    local lift = gui.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then set(false) end
    end)
    return {
        Disconnect = function()
            enter:Disconnect()
            leave:Disconnect()
            lift:Disconnect()
        end,
    }
end

-- touch only: holding still on gui for `time` s calls fn(point); returns the connection and consumed(),
-- which a click handler calls to skip the click that ends a long press
function Util.LongPress(gui, fn, time)
    local presses, fired = 0, false
    local connection = gui.InputBegan:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.Touch then return end
        presses += 1
        fired = false
        local mine, start = presses, input.Position
        task.delay(time or 0.5, function()
            if mine ~= presses or not gui.Parent then return end
            local state = input.UserInputState
            if state ~= Enum.UserInputState.Begin and state ~= Enum.UserInputState.Change then return end
            if (input.Position - start).Magnitude > 10 then return end
            fired = true
            fn(Vector2.new(input.Position.X, input.Position.Y))
        end)
    end)
    local function consumed()
        if not fired then return false end
        fired = false
        return true
    end
    return connection, consumed
end

-- resize grip: dots in a corner triangle; drawn without Rotation, which does not render inside clipping frames
function Util.Grip(props)
    local grip = Util.New("TextButton", props)
    local size = grip.Size.X.Offset
    local step = math.floor(size / 4)
    local first = size - step * 3 + 1
    for _, dot in { { 2, 0 }, { 1, 1 }, { 2, 1 }, { 0, 2 }, { 1, 2 }, { 2, 2 } } do
        Util.New("Frame", {
            Size = UDim2.fromOffset(2, 2),
            Position = UDim2.fromOffset(first + dot[1] * step, first + dot[2] * step),
            Theme = { BackgroundColor3 = "TextMuted" },
            Parent = grip,
        })
    end
    return grip
end

-- hover state + press scale for any button; state.Hover / state.Down feed its theme functions
function Util.Feedback(button, state, refresh)
    state = state or {}
    local scale = Util.New("UIScale", { Parent = button })
    local function paint()
        if refresh then refresh() else Theme.Refresh(button, 0.12) end
    end
    Util.Hover(button, function(on)
        state.Hover = on
        if not on then
            state.Down = false
            Util.Tween(scale, 0.1, { Scale = 1 })
        end
        paint()
    end)
    button.MouseButton1Down:Connect(function()
        state.Down = true
        Util.Tween(scale, 0.08, { Scale = 0.95 })
    end)
    button.MouseButton1Up:Connect(function()
        state.Down = false
        Util.Tween(scale, 0.14, { Scale = 1 }, Enum.EasingStyle.Back)
    end)
    return state
end

-- user code runs on a thread of its own: a callback that changes its thread's identity (game code can) never
-- costs the library's thread its access to the gui. Returns the callback's results if it finished without yielding
function Util.Safe(fn, ...)
    if type(fn) ~= "function" then return end
    local results
    task.spawn(function(...)
        local out = table.pack(xpcall(fn, debug.traceback, ...))
        if out[1] then
            results = out
        else
            warn("[OasisUI] callback error: " .. tostring(out[2]))
        end
    end, ...)
    if results then return table.unpack(results, 2, results.n) end
    return nil
end

function Util.Round(value, step)
    step = step or 1
    if step <= 0 then return value end
    local rounded = math.floor(value / step + 0.5) * step
    local decimals = Util.Decimals(step)
    return tonumber(string.format("%." .. decimals .. "f", rounded)) or rounded
end

function Util.Decimals(step)
    if not step or step >= 1 then return 0 end
    local text = tostring(step)
    local dot = text:find("%.")
    if text:find("e") then return math.clamp(math.ceil(-math.log10(step)), 0, 6) end
    return dot and math.clamp(#text - dot, 0, 6) or 0
end

function Util.Format(value, step)
    local decimals = Util.Decimals(step)
    return string.format("%." .. decimals .. "f", value)
end

-- 1.5k / 2m / 3b
-- 1500 -> 1.5k, 2000000 -> 2m: the suffixes ParseNumber reads back
function Util.Compact(number)
    local size = math.abs(number)
    for _, unit in { { 1e9, "b" }, { 1e6, "m" }, { 1e3, "k" } } do
        if size >= unit[1] then
            return (string.format("%.2f", number / unit[1]):gsub("%.?0+$", "")) .. unit[2]
        end
    end
    return tostring(number)
end

function Util.ParseNumber(text)
    if type(text) ~= "string" then return tonumber(text) end
    text = text:gsub("[%s,]", "")
    local number, suffix = text:match("^(-?[%d%.]+)(%a?)$")
    number = tonumber(number)
    if not number then return nil end
    local scale = ({ [""] = 1, k = 1e3, m = 1e6, b = 1e9 })[suffix:lower()]
    return scale and number * scale or nil
end

local KEY_LABELS = {
    LeftShift = "LShift", RightShift = "RShift", LeftControl = "LCtrl", RightControl = "RCtrl",
    LeftAlt = "LAlt", RightAlt = "RAlt", LeftSuper = "LWin", RightSuper = "RWin", Return = "Enter",
    Backquote = "`", Minus = "-", Equals = "=", LeftBracket = "[", RightBracket = "]", Semicolon = ";",
    Quote = "'", Comma = ",", Period = ".", Slash = "/", BackSlash = "\\", CapsLock = "Caps",
    PageUp = "PgUp", PageDown = "PgDn", Insert = "Ins", Delete = "Del", Backspace = "Bksp",
    MouseButton1 = "MB1", MouseButton2 = "MB2", MouseButton3 = "MB3", Space = "Space",
    Zero = "0", One = "1", Two = "2", Three = "3", Four = "4", Five = "5", Six = "6", Seven = "7", Eight = "8", Nine = "9",
}

function Util.KeyLabel(name)
    if not name then return "None" end
    if name:find("+", 1, true) then
        local parts = string.split(name, "+")
        for index, part in parts do parts[index] = Util.KeyLabel(part) end
        return table.concat(parts, " + ")
    end
    if KEY_LABELS[name] then return KEY_LABELS[name] end
    local pad = name:match("^Keypad(.+)$")
    if pad then return "Num" .. (KEY_LABELS[pad] or pad) end
    return name
end

function Util.IsPress(input)
    return input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch
end

-- pointer in AbsolutePosition space (below the topbar inset)
function Util.Pointer(input)
    if input then return Vector2.new(input.Position.X, input.Position.Y) end
    return Services.UserInputService:GetMouseLocation() - Services.GuiService:GetGuiInset()
end

function Util.Contains(gui, point)
    local position, size = gui.AbsolutePosition, gui.AbsoluteSize
    return point.X >= position.X and point.X <= position.X + size.X and point.Y >= position.Y and point.Y <= position.Y + size.Y
end

-- false when the object or any ancestor is hidden
function Util.Shown(gui)
    local node = gui
    while node do
        if node:IsA("GuiObject") then
            if not node.Visible then return false end
        elseif node:IsA("LayerCollector") then
            return node.Enabled
        end
        node = node.Parent
    end
    return false
end

function Util.Truncate(text, max)
    if #text <= max then return text end
    return text:sub(1, max - 1) .. "…"
end

function Util.Lerp(a, b, t)
    return a + (b - a) * t
end

return Util
end

__modules["Elements/Base"] = function(...)
local import = ...
local Signal = import("Core/Signal")
local Maid = import("Core/Maid")
local Util = import("Core/Util")

-- element model: holds the value; any number of views (tab, favorites, search) render it
local Base = {}
Base.__index = Base

function Base.Class(kind)
    local class = setmetatable({ Kind = kind }, { __index = Base })
    class.__index = class
    return class
end

function Base.Init(self, container, def)
    self.Def = def
    self.Container = container
    self.Window = container.Window
    self.Module = container.Module or container
    self.Title = def.Title or def.Name or def.Text or self.Kind
    self.Description = def.Description or def.Desc
    self.Tooltip = def.Tooltip
    self.Flag = def.Flag
    self.Changed = Signal.new()
    self.StateChanged = Signal.new()
    self.Locked = def.Locked == true
    self.LockReason = def.LockedReason or def.LockReason
    self.Visible = def.Visible ~= false
    self.NoSave = def.NoSave == true or def.Flag == nil
    self._listeners = {}
    self._mounts = {}
    if self.Flag then
        self.Window.Config:Register(self.Flag, self)
        self.Window.Library.Flags[self.Flag] = self
    end
    return self
end

-- stores the value, repaints views, runs callbacks unless silent
function Base:_commit(value, silent)
    self.Value = value
    self.Changed:Fire(value)
    if not silent then self:_notify() end
    self.Window:_touch()
end

-- callback arguments; kinds with several values override this
function Base:_args()
    return self.Value
end

function Base:_notify()
    Util.Safe(self.Def.Callback, self:_args())
    for _, fn in self._listeners do Util.Safe(fn, self:_args()) end
end

function Base:Get()
    return self.Value
end

function Base:Set(value, silent)
    self:_commit(value, silent)
end

function Base:Reset()
    if self.Default ~= nil then self:Set(self.Default) end
end

function Base:OnChanged(fn)
    table.insert(self._listeners, fn)
    return self
end

function Base:SetTitle(text)
    self.Title = text
    self.StateChanged:Fire("Title")
end

function Base:SetDescription(text)
    self.Description = text
    self.StateChanged:Fire("Description")
end

function Base:SetLocked(locked, reason)
    self.Locked = locked and true or false
    self.LockReason = reason or self.LockReason
    self.StateChanged:Fire("Locked")
end

function Base:Lock(reason) self:SetLocked(true, reason) end
function Base:Unlock() self:SetLocked(false) end

function Base:SetVisible(visible)
    self.Visible = visible and true or false
    self.StateChanged:Fire("Visible")
end

-- keeps this element locked (or hidden) while predicate(source value) is false
function Base:DependsOn(source, predicate, mode)
    predicate = predicate or function(value) return value and true or false end
    local function update()
        local ok = predicate(source:Get())
        if mode == "Hide" then
            self:SetVisible(ok)
        else
            self:SetLocked(not ok, self.Def.LockedReason or ("Requires " .. tostring(source.Title)))
        end
    end
    source.Changed:Connect(update)
    if source.StateChanged then source.StateChanged:Connect(update) end
    update()
    return self
end

function Base:Matches(query)
    local text = (tostring(self.Title) .. " " .. tostring(self.Description or "")):lower()
    return text:find(query, 1, true) ~= nil
end

function Base:Save()
    return self.Value
end

function Base:Load(value)
    self:Set(value)
end

-- called by containers for every view; Render is implemented per kind
function Base:Mount(parent, maid, order)
    local mount = Maid.new()
    maid:Give(mount)
    table.insert(self._mounts, mount)
    mount:Give(function()
        local index = table.find(self._mounts, mount)
        if index then table.remove(self._mounts, index) end
    end)
    local frame = self:Render(parent, mount)
    if frame then frame.LayoutOrder = order or 0 end
    return frame
end

function Base:Destroy()
    for _, mount in table.clone(self._mounts) do mount:Clean() end
    if self.Flag then
        self.Window.Config:Unregister(self.Flag, self)
        if self.Window.Library.Flags[self.Flag] == self then self.Window.Library.Flags[self.Flag] = nil end
    end
    if self.Binding then self.Binding:Destroy() end
    local children = self.Container.Children
    local index = table.find(children, self)
    if index then table.remove(children, index) end
    self.Changed:Destroy()
    self.StateChanged:Destroy()
end

return Base
end

__modules["Elements/Button"] = function(...)
local import = ...
local Base = import("Elements/Base")
local Util = import("Core/Util")
local Theme = import("Core/Theme")
local Binding = import("Core/Binding")
local Widgets = import("Components/Widgets")
local Tooltip = import("Components/Tooltip")

-- def: Title, Icon, Style ("Default" | "Primary" | "Danger" | "Ghost"), Confirm (true | text), Keybind, Callback()
local Button = Base.Class("Button")

local STYLES = {
    Default = { Bg = "Elevated", Hover = "ElevatedHover", Text = "Text", Icon = "TextDim" },
    Primary = { Bg = "Accent", Hover = "Accent", Text = "OnAccent", Icon = "OnAccent" },
    Danger  = { Bg = "Elevated", Hover = "ElevatedHover", Text = "Danger", Icon = "Danger" },
    Ghost   = { Bg = "Surface", Hover = "Elevated", Text = "TextDim", Icon = "TextMuted" },
}
Button.Styles = STYLES

function Button.new(container, def)
    local self = setmetatable({}, Button)
    Base.Init(self, container, def)
    self.NoSave = not def.Keybind
    self.Armed = false
    if def.Keybind then
        local spec = type(def.Keybind) == "table" and def.Keybind or { Key = def.Keybind ~= true and def.Keybind or nil }
        self.Binding = Binding.new({
            Key = spec.Key or spec.Default,
            Mode = "Always",
            Modes = { "Always" },
            Capture = spec,
            Press = function() self:Press(true) end,
        })
        self.Binding.Changed:Connect(function() self.Window:_touch(true) end)
    end
    return self
end

-- skipConfirm: keybinds fire straight away
function Button:Press(skipConfirm)
    if self.Locked then return end
    local confirm = self.Def.Confirm
    if confirm and not skipConfirm and not self.Armed then
        self.Armed = true
        self.StateChanged:Fire("Armed")
        task.delay(2.5, function()
            if self.Armed then
                self.Armed = false
                self.StateChanged:Fire("Armed")
            end
        end)
        return
    end
    if self.Armed then
        self.Armed = false
        self.StateChanged:Fire("Armed")
    end
    Util.Safe(self.Def.Callback)
end

function Button:Save()
    return self.Binding and self.Binding:Save() or nil
end

function Button:Load(data)
    if self.Binding then self.Binding:Load(data) end
end

-- shared by Button and ButtonRow
function Button.Draw(parent, spec, getState, onPress)
    local style = STYLES[spec.Style or "Default"] or STYLES.Default
    local hover = false
    local button = Util.New("TextButton", {
        Name = "Button",
        Size = UDim2.new(1, 0, 0, 30),
        Theme = {
            BackgroundColor3 = function(t)
                local state = getState()
                if state.Armed then return t.Danger end
                return hover and t[style.Hover] or t[style.Bg]
            end,
            BackgroundTransparency = function(t)
                if spec.Style == "Primary" or getState().Armed then return hover and 0 or 0.08 end
                return t.ElevatedTransparency
            end,
        },
        Parent = parent,
    })
    Util.Corner(6, button)
    Util.Stroke(button, function(t) return spec.Style == "Danger" and t.Danger or t.Stroke end, function(t)
        return spec.Style == "Danger" and 0.6 or t.StrokeTransparency + 0.1
    end)
    Util.List(button, 6, Enum.FillDirection.Horizontal, Enum.HorizontalAlignment.Center, Enum.VerticalAlignment.Center)
    local icon
    if spec.Icon then
        icon = Util.Icon(spec.Icon, {
            Size = UDim2.fromOffset(14, 14),
            LayoutOrder = 1,
            Theme = { ImageColor3 = function(t) return getState().Armed and t.OnAccent or t[style.Icon] end },
            Parent = button,
        })
    end
    local label = Util.Label({
        Text = spec.Title or "Button",
        TextSize = 12,
        Weight = Enum.FontWeight.SemiBold,
        AutomaticSize = Enum.AutomaticSize.X,
        Size = UDim2.fromScale(0, 1),
        LayoutOrder = 2,
        Theme = { TextColor3 = function(t) return getState().Armed and t.OnAccent or t[style.Text] end },
        Parent = button,
    })
    local scale = Util.New("UIScale", { Parent = button })
    Util.Hover(button, function(on) hover = on; Theme.Refresh(button, 0.12) end)
    button.MouseButton1Down:Connect(function() Util.Tween(scale, 0.08, { Scale = 0.97 }) end)
    button.MouseButton1Up:Connect(function() Util.Tween(scale, 0.12, { Scale = 1 }) end)
    button.MouseButton1Click:Connect(onPress)
    local function paint()
        local state = getState()
        label.Text = state.Armed and (type(spec.Confirm) == "string" and spec.Confirm or "Click again to confirm") or (state.Title or spec.Title or "Button")
        label.TextTransparency = state.Locked and 0.55 or 0
        if icon then icon.ImageTransparency = state.Locked and 0.55 or 0 end
        Theme.Refresh(button, 0.15)
        Theme.Refresh(label, 0.15)
        if icon then Theme.Refresh(icon, 0.15) end
    end
    return button, paint
end

function Button:Render(parent, maid)
    local holder = maid:Give(Util.New("Frame", {
        Name = "Button",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 30),
        Visible = self.Visible,
        Parent = parent,
    }))
    local spec = table.clone(self.Def)
    local button, paint = Button.Draw(holder, spec, function() return self end, function() self:Press() end)
    if self.Binding then
        button.Size = UDim2.new(1, -46, 0, 30)
        local _, connection = Widgets.KeyPill(holder, self.Binding, {
            AnchorPoint = Vector2.new(1, 0.5),
            Position = UDim2.new(1, 0, 0.5, 0),
            Height = 22,
        })
        maid:Give(connection)
    end
    if self.Tooltip then maid:Give(Tooltip.Attach(button, function() return self.Tooltip end)) end
    paint()
    maid:Give(self.StateChanged:Connect(function(what)
        if what == "Visible" then holder.Visible = self.Visible end
        paint()
    end))
    return holder
end

return Button
end

__modules["Elements/ButtonRow"] = function(...)
local import = ...
local Base = import("Elements/Base")
local Util = import("Core/Util")
local Button = import("Elements/Button")

-- several buttons sharing one line; def: { { Title, Icon, Style, Confirm, Callback }, ... } or { Buttons = {...} }
local ButtonRow = Base.Class("ButtonRow")

function ButtonRow.new(container, def)
    local self = setmetatable({}, ButtonRow)
    local specs = def.Buttons or def
    Base.Init(self, container, { Title = def.Title or "Buttons", Visible = def.Visible, Locked = def.Locked })
    self.NoSave = true
    self.Buttons = {}
    for index, spec in specs do
        if type(spec) == "table" then
            self.Buttons[index] = { Spec = spec, Armed = false, Title = spec.Title, Locked = false }
        end
    end
    return self
end

function ButtonRow:Matches(query)
    for _, entry in self.Buttons do
        if tostring(entry.Title):lower():find(query, 1, true) then return true end
    end
    return false
end

function ButtonRow:Press(index)
    local entry = self.Buttons[index]
    if not entry or self.Locked or entry.Locked then return end
    if entry.Spec.Confirm and not entry.Armed then
        entry.Armed = true
        self.StateChanged:Fire("Armed")
        task.delay(2.5, function()
            if entry.Armed then
                entry.Armed = false
                self.StateChanged:Fire("Armed")
            end
        end)
        return
    end
    entry.Armed = false
    self.StateChanged:Fire("Armed")
    Util.Safe(entry.Spec.Callback)
end

function ButtonRow:SetButtonTitle(index, title)
    local entry = self.Buttons[index]
    if entry then
        entry.Title = title
        self.StateChanged:Fire("Title")
    end
end

function ButtonRow:SetButtonLocked(index, locked)
    local entry = self.Buttons[index]
    if entry then
        entry.Locked = locked
        self.StateChanged:Fire("Locked")
    end
end

function ButtonRow:Render(parent, maid)
    local holder = maid:Give(Util.New("Frame", {
        Name = "ButtonRow",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 30),
        Visible = self.Visible,
        Parent = parent,
    }))
    Util.List(holder, 6, Enum.FillDirection.Horizontal)
    local painters = {}
    for index, entry in self.Buttons do
        local button, paint = Button.Draw(holder, entry.Spec, function()
            return { Armed = entry.Armed, Locked = self.Locked or entry.Locked, Title = entry.Title }
        end, function() self:Press(index) end)
        button.LayoutOrder = index
        button.Size = UDim2.new(0, 0, 0, 30)
        Util.New("UIFlexItem", { FlexMode = Enum.UIFlexMode.Fill, Parent = button })
        table.insert(painters, paint)
        paint()
    end
    maid:Give(self.StateChanged:Connect(function(what)
        if what == "Visible" then holder.Visible = self.Visible end
        for _, paint in painters do paint() end
    end))
    return holder
end

return ButtonRow
end

__modules["Elements/Code"] = function(...)
local import = ...
local Base = import("Elements/Base")
local Util = import("Core/Util")
local Theme = import("Core/Theme")
local Tooltip = import("Components/Tooltip")

-- monospace block: a short preview, a click opens the whole text in a scrolling dialog
-- def: Title, Code, Lines (preview lines, default 6), Editable, OnSave(text) -> ok, message, OnCopy()
local Code = Base.Class("Code")

local MONO = "rbxasset://fonts/families/RobotoMono.json"

function Code.new(container, def)
    local self = setmetatable({}, Code)
    Base.Init(self, container, def)
    self.Title = def.Title or ""
    self.Value = def.Code or def.Content or ""
    self.NoSave = true
    return self
end

function Code:Set(code)
    self.Value = tostring(code)
    self.Changed:Fire(self.Value)
end

local function copy(text)
    if type(setclipboard) ~= "function" then return false end
    return (pcall(setclipboard, text))
end

-- the whole text in a dialog; Editable: a Save button runs OnSave first, a false keeps the dialog open
function Code:Open()
    local editable = self.Def.Editable == true and not self.Locked
    local buttons = {
        { Title = "Copy", Style = "Secondary", Callback = function(text)
            copy(text)
            Util.Safe(self.Def.OnCopy)
            return false
        end },
    }
    if editable then
        table.insert(buttons, { Title = "Cancel", Style = "Secondary" })
        table.insert(buttons, { Title = "Save", Style = "Primary", Callback = function(text, dialog)
            if self.Def.OnSave then
                local ok, valid, message = pcall(self.Def.OnSave, text)
                if not ok then
                    dialog:SetError(tostring(valid))
                    return false
                end
                if valid == false then
                    dialog:SetError(message or "Not saved.")
                    return false
                end
            end
            self:Set(text)
            return true
        end })
    else
        table.insert(buttons, { Title = "Close", Style = "Primary" })
    end
    -- "<card> · <title>": the dialog covers the card it came from
    local owner = self.Module and self.Module.Title
    local title = self.Title ~= "" and self.Title or "Code"
    if owner and owner ~= "" and owner ~= title then title = owner .. " · " .. title end
    return self.Window:Dialog({
        Title = title,
        Icon = editable and "pencil" or "file-code",
        Width = 480,
        Input = { Default = self.Value, Multiline = true, Height = 300, Monospace = true, ReadOnly = not editable },
        Buttons = buttons,
    })
end

function Code:Render(parent, maid)
    local lines = self.Def.Lines or 6
    local box = maid:Give(Util.New("TextButton", {
        Name = "Code",
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        ClipsDescendants = true,
        Visible = self.Visible,
        Theme = { BackgroundColor3 = "Background", BackgroundTransparency = function() return 0.2 end },
        Parent = parent,
    }))
    Util.Corner(6, box)
    local stroke = Util.Stroke(box)
    Util.List(box, 2)
    Util.Padding(box, 0, 10, 10, 10)
    local head = Util.New("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 24), LayoutOrder = 1, Parent = box })
    Util.Label({
        Text = self.Title,
        TextSize = 11,
        Color = "TextMuted",
        Weight = Enum.FontWeight.SemiBold,
        Size = UDim2.new(1, -50, 1, 0),
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = head,
    })
    local actions = Util.New("Frame", {
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, 0, 0.5, 0),
        AutomaticSize = Enum.AutomaticSize.X,
        Size = UDim2.fromOffset(0, 14),
        Parent = head,
    })
    Util.List(actions, 8, Enum.FillDirection.Horizontal, Enum.HorizontalAlignment.Right, Enum.VerticalAlignment.Center)
    local function action(icon, order, tip)
        local button = Util.New("ImageButton", {
            Size = UDim2.fromOffset(13, 13),
            Image = Util.IconId(icon),
            LayoutOrder = order,
            Theme = { ImageColor3 = "TextMuted" },
            Parent = actions,
        })
        maid:Give(Tooltip.Attach(button, tip))
        return button
    end
    local open = action(self.Def.Editable and "pencil" or "maximize-2", 1, function()
        return self.Def.Editable and "Edit" or "View all"
    end)
    local copyButton = action("copy", 2, "Copy")

    -- the preview: whole lines only, cut at the right edge instead of wrapped
    local text = Util.New("TextLabel", {
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        TextSize = 11,
        TextWrapped = false,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        FontFace = Font.new(MONO),
        LayoutOrder = 2,
        Theme = { TextColor3 = "TextDim" },
        Parent = box,
    })
    local more = Util.Label({
        TextSize = 10,
        Color = "TextMuted",
        Weight = Enum.FontWeight.Medium,
        Size = UDim2.new(1, 0, 0, 16),
        TextYAlignment = Enum.TextYAlignment.Bottom,
        LayoutOrder = 3,
        Parent = box,
    })

    local function paint()
        local all = string.split(self.Value, "\n")
        local shown = math.min(#all, lines)
        text.Text = table.concat(all, "\n", 1, shown)
        local hidden = #all - shown
        more.Visible = hidden > 0
        more.Text = hidden > 0 and ("+ " .. hidden .. (hidden == 1 and " more line" or " more lines")) or ""
    end
    paint()
    maid:Give(self.Changed:Connect(paint))

    maid:Give(Util.Hover(box, function(on)
        Theme.Bind(stroke, { Color = on and "Accent" or "Stroke" })
    end))
    maid:Give(Tooltip.Attach(box, function() return self.Def.Editable and "Click to edit" or "Click to view all" end))
    box.MouseButton1Click:Connect(function() self:Open() end)
    open.MouseButton1Click:Connect(function() self:Open() end)
    copyButton.MouseButton1Click:Connect(function()
        copy(self.Value)
        copyButton.Image = Util.IconId("check")
        task.delay(1.2, function() if copyButton.Parent then copyButton.Image = Util.IconId("copy") end end)
        Util.Safe(self.Def.OnCopy)
    end)
    return box
end

return Code
end

__modules["Elements/ColorPicker"] = function(...)
local import = ...
local Base = import("Elements/Base")
local Util = import("Core/Util")
local Theme = import("Core/Theme")
local Drag = import("Core/Drag")
local Services = import("Core/Services")
local Row = import("Components/Row")
local Popup = import("Components/Popup")
local Tooltip = import("Components/Tooltip")

-- def: Title, Default (Color3), Transparency (0..1, enables the alpha bar), Rainbow, Callback(color, transparency)
local ColorPicker = Base.Class("ColorPicker")
ColorPicker.Clipboard = nil

local HUES = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromHSV(0, 1, 1)),
    ColorSequenceKeypoint.new(1 / 6, Color3.fromHSV(1 / 6, 1, 1)),
    ColorSequenceKeypoint.new(2 / 6, Color3.fromHSV(2 / 6, 1, 1)),
    ColorSequenceKeypoint.new(3 / 6, Color3.fromHSV(3 / 6, 1, 1)),
    ColorSequenceKeypoint.new(4 / 6, Color3.fromHSV(4 / 6, 1, 1)),
    ColorSequenceKeypoint.new(5 / 6, Color3.fromHSV(5 / 6, 1, 1)),
    ColorSequenceKeypoint.new(1, Color3.fromHSV(1, 1, 1)),
})

function ColorPicker.new(container, def)
    local self = setmetatable({}, ColorPicker)
    Base.Init(self, container, def)
    self.HasAlpha = def.Transparency ~= nil
    self.Value = { Color = def.Default or def.Value or Color3.new(1, 1, 1), Alpha = def.Transparency or 0 }
    self.Default = table.clone(self.Value)
    self.Rainbow = false
    if def.Rainbow then self:SetRainbow(true) end
    return self
end

function ColorPicker:_args()
    return self.Value.Color, self.Value.Alpha
end

-- Set(color, transparency) or Set({ Color, Alpha })
function ColorPicker:Set(color, alpha, silent)
    if type(color) == "table" then
        color, alpha, silent = color.Color, color.Alpha, alpha
    end
    if typeof(color) ~= "Color3" then return end
    alpha = math.clamp(alpha or self.Value.Alpha, 0, 1)
    if color == self.Value.Color and alpha == self.Value.Alpha then return end
    self:_commit({ Color = color, Alpha = alpha }, silent)
end
ColorPicker.SetValueRGB = ColorPicker.Set

function ColorPicker:Reset()
    self:SetRainbow(false)
    self:Set(self.Default.Color, self.Default.Alpha)
end

function ColorPicker:SetRainbow(on)
    on = on and true or false
    if on == self.Rainbow then return end
    self.Rainbow = on
    if self._rainbow then self._rainbow:Disconnect(); self._rainbow = nil end
    if on then
        self._rainbow = Services.RunService.Heartbeat:Connect(function()
            local _, s, v = self.Value.Color:ToHSV()
            self:Set(Color3.fromHSV((os.clock() * 0.15) % 1, math.max(s, 0.6), math.max(v, 0.8)), self.Value.Alpha)
        end)
        self.Window.Maid:Give(self._rainbow)
    end
    self.StateChanged:Fire("Rainbow")
end

function ColorPicker:Save()
    return { Hex = self.Value.Color:ToHex(), Alpha = self.Value.Alpha, Rainbow = self.Rainbow or nil }
end

function ColorPicker:Load(data)
    if type(data) ~= "table" then return end
    local ok, color = pcall(Color3.fromHex, data.Hex or "ffffff")
    if ok then self:Set(color, data.Alpha) end
    self:SetRainbow(data.Rainbow == true)
end

local function cursor(parent, size)
    local dot = Util.New("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = size,
        BackgroundColor3 = Color3.new(1, 1, 1),
        ZIndex = 106,
        Parent = parent,
    })
    Util.Corner(UDim.new(1, 0), dot)
    Util.New("UIStroke", { Color = Color3.new(0, 0, 0), Transparency = 0.35, Thickness = 1, Parent = dot })
    return dot
end

local function smallField(parent, width, order, placeholder)
    local field, api = Row.Field(parent, { Size = UDim2.new(0, width, 0, 24), LayoutOrder = order, Radius = 5 })
    field.ZIndex = 103
    local box = Util.New("TextBox", {
        Size = UDim2.new(1, -8, 1, 0),
        Position = UDim2.fromOffset(4, 0),
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Center,
        PlaceholderText = placeholder,
        ZIndex = 104,
        Theme = { TextColor3 = "Text", PlaceholderColor3 = "TextMuted", FontFace = Theme.Font(Enum.FontWeight.Medium) },
        Parent = field,
    })
    box.Focused:Connect(function() api.SetFocused(true) end)
    box.FocusLost:Connect(function() api.SetFocused(false) end)
    return field, box
end

function ColorPicker:_open(anchor)
    Popup.Open({
        Anchor = anchor,
        Width = 236,
        Align = "End",
        Padding = 8,
        Build = function(frame, popup)
            Util.List(frame, 8)
            local h, s, v = self.Value.Color:ToHSV()

            local sv = Util.New("TextButton", {
                Size = UDim2.new(1, 0, 0, 132),
                LayoutOrder = 1,
                ZIndex = 102,
                BackgroundColor3 = Color3.fromHSV(h, 1, 1),
                Parent = frame,
            })
            Util.Corner(5, sv)
            local white = Util.New("Frame", { Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.new(1, 1, 1), ZIndex = 103, Parent = sv })
            Util.Corner(5, white)
            Util.New("UIGradient", { Transparency = NumberSequence.new(0, 1), Parent = white })
            local black = Util.New("Frame", { Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.new(0, 0, 0), ZIndex = 104, Parent = sv })
            Util.Corner(5, black)
            Util.New("UIGradient", { Transparency = NumberSequence.new(1, 0), Rotation = 90, Parent = black })
            local svCursor = cursor(sv, UDim2.fromOffset(10, 10))

            local hue = Util.New("TextButton", { Size = UDim2.new(1, 0, 0, 10), LayoutOrder = 2, ZIndex = 102, BackgroundColor3 = Color3.new(1, 1, 1), Parent = frame })
            Util.Corner(UDim.new(1, 0), hue)
            Util.New("UIGradient", { Color = HUES, Parent = hue })
            local hueCursor = cursor(hue, UDim2.fromOffset(6, 14))
            hueCursor.Position = UDim2.fromScale(h, 0.5)

            local alphaBar, alphaFill, alphaCursor
            if self.HasAlpha then
                alphaBar = Util.New("TextButton", { Size = UDim2.new(1, 0, 0, 10), LayoutOrder = 3, ZIndex = 102, Theme = { BackgroundColor3 = "Surface" }, Parent = frame })
                Util.Corner(UDim.new(1, 0), alphaBar)
                alphaFill = Util.New("Frame", { Size = UDim2.fromScale(1, 1), ZIndex = 103, BackgroundColor3 = self.Value.Color, Parent = alphaBar })
                Util.Corner(UDim.new(1, 0), alphaFill)
                Util.New("UIGradient", { Transparency = NumberSequence.new(0, 1), Parent = alphaFill })
                alphaCursor = cursor(alphaBar, UDim2.fromOffset(6, 14))
            end

            local inputs = Util.New("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 24), LayoutOrder = 4, ZIndex = 102, Parent = frame })
            Util.List(inputs, 4, Enum.FillDirection.Horizontal)
            local hexField, hex = smallField(inputs, 0, 1, "#hex")
            Util.New("UIFlexItem", { FlexMode = Enum.UIFlexMode.Fill, Parent = hexField })
            local _, red = smallField(inputs, 34, 2, "R")
            local _, green = smallField(inputs, 34, 3, "G")
            local _, blue = smallField(inputs, 34, 4, "B")
            local alphaBox
            if self.HasAlpha then
                local _, box = smallField(inputs, 38, 5, "A%")
                alphaBox = box
            end

            local tools = Util.New("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 22), LayoutOrder = 5, ZIndex = 102, Parent = frame })
            Util.List(tools, 6, Enum.FillDirection.Horizontal, nil, Enum.VerticalAlignment.Center)
            local function tool(icon, order, tip)
                local button = Util.New("ImageButton", {
                    Size = UDim2.fromOffset(22, 22),
                    LayoutOrder = order,
                    ZIndex = 103,
                    Theme = { BackgroundColor3 = "ElevatedHover", BackgroundTransparency = function() return 0.4 end },
                    Parent = tools,
                })
                Util.Corner(5, button)
                Util.Icon(icon, { Size = UDim2.fromOffset(12, 12), Position = UDim2.fromOffset(5, 5), Color = "TextDim", ZIndex = 104, Parent = button })
                popup.Maid:Give(Tooltip.Attach(button, tip))
                return button
            end
            local rainbow = tool("sparkles", 1, "Rainbow")
            local copy = tool("copy", 2, "Copy colour")
            local paste = tool("clipboard-paste", 3, "Paste colour")
            local reset = tool("rotate-ccw", 4, "Reset")
            local preview = Util.New("Frame", { Size = UDim2.fromOffset(0, 22), LayoutOrder = 5, ZIndex = 103, Parent = tools })
            Util.New("UIFlexItem", { FlexMode = Enum.UIFlexMode.Fill, Parent = preview })
            Util.Corner(5, preview)
            Util.Stroke(preview)

            local function paint(fromHsv)
                local color = self.Value.Color
                if not fromHsv then
                    local nh, ns, nv = color:ToHSV()
                    if ns > 0.001 and nv > 0.001 then h = nh end
                    s, v = ns, nv
                end
                sv.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
                svCursor.Position = UDim2.fromScale(s, 1 - v)
                hueCursor.Position = UDim2.fromScale(h, 0.5)
                if alphaBar then
                    alphaFill.BackgroundColor3 = color
                    alphaCursor.Position = UDim2.fromScale(1 - self.Value.Alpha, 0.5)
                end
                preview.BackgroundColor3 = color
                preview.BackgroundTransparency = self.Value.Alpha
                if not hex:IsFocused() then hex.Text = "#" .. color:ToHex():upper() end
                if not red:IsFocused() then red.Text = tostring(math.round(color.R * 255)) end
                if not green:IsFocused() then green.Text = tostring(math.round(color.G * 255)) end
                if not blue:IsFocused() then blue.Text = tostring(math.round(color.B * 255)) end
                if alphaBox and not alphaBox:IsFocused() then alphaBox.Text = tostring(math.round((1 - self.Value.Alpha) * 100)) end
                rainbow.BackgroundTransparency = self.Rainbow and 0 or 0.4
                Theme.Bind(rainbow, { BackgroundColor3 = self.Rainbow and "Accent" or "ElevatedHover" })
            end
            paint(false)

            local function apply()
                self:SetRainbow(false)
                self:Set(Color3.fromHSV(h, s, v), self.Value.Alpha)
                paint(true)
            end
            local function track(button, onPoint)
                button.InputBegan:Connect(function(input)
                    if not Util.IsPress(input) or self.Locked then return end
                    onPoint(Util.Pointer(input))
                    Drag.Follow(input, function(point) onPoint(point) end, nil, button)
                end)
            end
            local function relative(gui, point)
                local position, size = gui.AbsolutePosition, gui.AbsoluteSize
                return math.clamp((point.X - position.X) / size.X, 0, 1), math.clamp((point.Y - position.Y) / size.Y, 0, 1)
            end
            track(sv, function(point)
                local x, y = relative(sv, point)
                s, v = x, 1 - y
                apply()
            end)
            track(hue, function(point)
                h = (relative(hue, point))
                apply()
            end)
            if alphaBar then
                track(alphaBar, function(point)
                    local x = relative(alphaBar, point)
                    self:Set(self.Value.Color, 1 - x)
                    paint(true)
                end)
            end

            hex.FocusLost:Connect(function()
                local ok, color = pcall(Color3.fromHex, (hex.Text:gsub("#", "")))
                if ok and not self.Locked then
                    self:SetRainbow(false)
                    self:Set(color, self.Value.Alpha)
                end
                paint(false)
            end)
            local function channel(box, index)
                box.FocusLost:Connect(function()
                    local number = tonumber(box.Text)
                    if number and not self.Locked then
                        local color = self.Value.Color
                        local parts = { color.R * 255, color.G * 255, color.B * 255 }
                        parts[index] = math.clamp(math.round(number), 0, 255)
                        self:SetRainbow(false)
                        self:Set(Color3.fromRGB(parts[1], parts[2], parts[3]), self.Value.Alpha)
                    end
                    paint(false)
                end)
            end
            channel(red, 1)
            channel(green, 2)
            channel(blue, 3)
            if alphaBox then
                alphaBox.FocusLost:Connect(function()
                    local number = tonumber((alphaBox.Text:gsub("%%", "")))
                    if number and not self.Locked then self:Set(self.Value.Color, 1 - math.clamp(number, 0, 100) / 100) end
                    paint(false)
                end)
            end

            rainbow.MouseButton1Click:Connect(function() if not self.Locked then self:SetRainbow(not self.Rainbow) end end)
            copy.MouseButton1Click:Connect(function()
                ColorPicker.Clipboard = table.clone(self.Value)
                if type(setclipboard) == "function" then pcall(setclipboard, "#" .. self.Value.Color:ToHex():upper()) end
            end)
            paste.MouseButton1Click:Connect(function()
                if ColorPicker.Clipboard and not self.Locked then
                    self:SetRainbow(false)
                    self:Set(ColorPicker.Clipboard.Color, self.HasAlpha and ColorPicker.Clipboard.Alpha or self.Value.Alpha)
                end
            end)
            reset.MouseButton1Click:Connect(function() if not self.Locked then self:Reset() end end)

            popup.Maid:Give(self.Changed:Connect(function() paint(false) end))
            popup.Maid:Give(self.StateChanged:Connect(function(what) if what == "Rainbow" then paint(false) end end))
        end,
    })
end

-- the swatch alone, for another element's row (Toggle and Module Color); a click opens the picker
function ColorPicker:RenderInline(parent, maid, props)
    props = props or {}
    local swatch = Util.New("TextButton", {
        Size = UDim2.fromOffset(props.Width or 32, props.Height or 18),
        LayoutOrder = props.LayoutOrder or 0,
        Theme = { BackgroundColor3 = "Elevated" },
        Parent = parent,
    })
    Util.Corner(5, swatch)
    Util.Stroke(swatch)
    local fill = Util.New("Frame", { Size = UDim2.fromScale(1, 1), Parent = swatch })
    Util.Corner(5, fill)
    local function paint()
        fill.BackgroundColor3 = self.Value.Color
        fill.BackgroundTransparency = self.Value.Alpha
    end
    paint()
    maid:Give(self.Changed:Connect(paint))
    swatch.MouseButton1Click:Connect(function()
        if self.Locked then return end
        if Popup.Current and Popup.Current.Anchor == swatch then
            Popup.Current:Close()
            return
        end
        self:_open(swatch)
    end)
    if self.Tooltip then maid:Give(Tooltip.Attach(swatch, self.Tooltip)) end
    return swatch
end

function ColorPicker:Render(parent, maid)
    local row = Row.new(self, parent, maid)
    self:RenderInline(row.Right, maid)
    return row.Frame
end

return ColorPicker
end

__modules["Elements/Divider"] = function(...)
local import = ...
local Base = import("Elements/Base")
local Util = import("Core/Util")

-- def: Text (optional caption between two fading lines)
local Divider = Base.Class("Divider")

function Divider.new(container, def)
    local self = setmetatable({}, Divider)
    Base.Init(self, container, def)
    self.Title = def.Text or def.Title
    self.NoSave = true
    return self
end

function Divider:Matches()
    return false
end

local function line(parent, flip, order)
    local frame = Util.New("Frame", {
        Size = UDim2.new(0, 0, 0, 1),
        LayoutOrder = order,
        Theme = { BackgroundColor3 = "Divider" },
        Parent = parent,
    })
    Util.New("UIFlexItem", { FlexMode = Enum.UIFlexMode.Fill, Parent = frame })
    Util.New("UIGradient", {
        Transparency = flip and NumberSequence.new(0, 1) or NumberSequence.new(1, 0),
        Parent = frame,
    })
    return frame
end

function Divider:Render(parent, maid)
    local frame = maid:Give(Util.New("Frame", {
        Name = "Divider",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, self.Title and 16 or 7),
        Visible = self.Visible,
        Parent = parent,
    }))
    Util.List(frame, 8, Enum.FillDirection.Horizontal, Enum.HorizontalAlignment.Center, Enum.VerticalAlignment.Center)
    if self.Title then
        line(frame, false, 1)
        Util.Label({
            Text = self.Title,
            TextSize = 10,
            Color = "TextMuted",
            Weight = Enum.FontWeight.SemiBold,
            AutomaticSize = Enum.AutomaticSize.X,
            Size = UDim2.fromScale(0, 1),
            LayoutOrder = 2,
            Parent = frame,
        })
        line(frame, true, 3)
    else
        local single = line(frame, false, 1)
        single:FindFirstChildOfClass("UIGradient").Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.5, 0),
            NumberSequenceKeypoint.new(1, 1),
        })
    end
    maid:Give(self.StateChanged:Connect(function() frame.Visible = self.Visible end))
    return frame
end

return Divider
end

__modules["Elements/Dropdown"] = function(...)
local import = ...
local Base = import("Elements/Base")
local Util = import("Core/Util")
local Theme = import("Core/Theme")
local Row = import("Components/Row")
local Popup = import("Components/Popup")
local Tooltip = import("Components/Tooltip")

-- def: Title, Values = { "A", { Title, Value, Description, Icon } }, Default, Multi, Search (true / false, auto above 8),
--      AllowNone, Placeholder, MaxVisible, Callback(value | list)
local Dropdown = Base.Class("Dropdown")

local function normalize(values)
    local out = {}
    for _, value in values or {} do
        if type(value) == "table" then
            local key = value.Value or value.Title or value.Name
            table.insert(out, { Value = tostring(key), Title = value.Title or value.Name or tostring(key), Description = value.Description or value.Desc, Icon = value.Icon })
        else
            table.insert(out, { Value = tostring(value), Title = tostring(value) })
        end
    end
    return out
end

function Dropdown.new(container, def)
    local self = setmetatable({}, Dropdown)
    Base.Init(self, container, def)
    self.Multi = def.Multi == true
    self.Options = normalize(def.Values or def.Options)
    local default = def.Default
    if default == nil then default = def.Value end
    if self.Multi then
        local list = {}
        if type(default) == "table" then
            -- accepts { "A", "B" } and { A = true }
            for key, value in default do
                if type(key) == "number" then table.insert(list, tostring(value)) elseif value == true then table.insert(list, tostring(key)) end
            end
        elseif default ~= nil then
            table.insert(list, tostring(default))
        end
        self.Value = self:_order(list)
    else
        if default == nil and not def.AllowNone and self.Options[1] then default = self.Options[1].Value end
        if type(default) == "number" and self.Options[default] then default = self.Options[default].Value end
        self.Value = default ~= nil and tostring(default) or nil
    end
    self.Default = self.Multi and table.clone(self.Value) or self.Value
    return self
end

function Dropdown:_find(value)
    for index, option in self.Options do
        if option.Value == value then return option, index end
    end
    return nil
end

-- multi selection follows option order
function Dropdown:_order(list)
    local set = {}
    for _, value in list do set[value] = true end
    local out = {}
    for _, option in self.Options do
        if set[option.Value] then
            table.insert(out, option.Value)
            set[option.Value] = nil
        end
    end
    for _, value in list do
        if set[value] then table.insert(out, value); set[value] = nil end
    end
    return out
end

function Dropdown:IsSelected(value)
    if self.Multi then return table.find(self.Value, value) ~= nil end
    return self.Value == value
end

function Dropdown:Set(value, silent)
    if self.Multi then
        local list = {}
        if type(value) == "table" then
            for key, entry in value do
                if type(key) == "number" then table.insert(list, tostring(entry)) elseif entry == true then table.insert(list, tostring(key)) end
            end
        elseif value ~= nil then
            table.insert(list, tostring(value))
        end
        list = self:_order(list)
        if table.concat(list, "\0") == table.concat(self.Value, "\0") then return end
        self:_commit(list, silent)
    else
        value = value ~= nil and tostring(value) or nil
        if value == self.Value then return end
        self:_commit(value, silent)
    end
end
Dropdown.Select = Dropdown.Set

function Dropdown:Toggle(value)
    if not self.Multi then
        self:Set(value)
        return
    end
    local list = table.clone(self.Value)
    local index = table.find(list, value)
    if index then table.remove(list, index) else table.insert(list, value) end
    self:Set(list)
end

-- replaces the options; keep = true keeps selected values that still exist
function Dropdown:Refresh(values, keep)
    self.Options = normalize(values)
    self.StateChanged:Fire("Options")
    if self.Multi then
        local list = {}
        if keep ~= false then
            for _, value in self.Value do
                if self:_find(value) then table.insert(list, value) end
            end
        end
        self:Set(list)
    elseif not (keep ~= false and self.Value and self:_find(self.Value)) then
        self:Set((not self.Def.AllowNone and self.Options[1]) and self.Options[1].Value or nil)
    end
end
Dropdown.SetValues = Dropdown.Refresh

function Dropdown:Add(value)
    local values = {}
    for _, option in self.Options do table.insert(values, option) end
    table.insert(values, value)
    self:Refresh(values)
end

function Dropdown:Remove(value)
    local values = {}
    for _, option in self.Options do
        if option.Value ~= tostring(value) then table.insert(values, option) end
    end
    self:Refresh(values)
end

function Dropdown:GetValues()
    local out = {}
    for _, option in self.Options do table.insert(out, option.Value) end
    return out
end

function Dropdown:Save()
    return self.Multi and table.clone(self.Value) or (self.Value or false)
end

function Dropdown:Load(data)
    if data == false then data = nil end
    self:Set(data)
end

function Dropdown:Matches(query)
    if Base.Matches(self, query) then return true end
    for _, option in self.Options do
        if option.Title:lower():find(query, 1, true) then return true end
    end
    return false
end

function Dropdown:DisplayText()
    if self.Multi then
        if #self.Value == 0 then return nil end
        local titles = {}
        for _, value in self.Value do
            local option = self:_find(value)
            table.insert(titles, option and option.Title or value)
        end
        return table.concat(titles, ", ")
    end
    if self.Value == nil then return nil end
    local option = self:_find(self.Value)
    return option and option.Title or self.Value
end

function Dropdown:_open(field, chevron)
    local search = self.Def.Search
    if search == nil then search = #self.Options > 8 end
    local maxVisible = self.Def.MaxVisible or 7
    chevron.Image = Util.IconId("chevron-up")

    Popup.Open({
        Anchor = field,
        MinWidth = 170,
        Padding = 5,
        OnClose = function() chevron.Image = Util.IconId("chevron-down") end,
        Build = function(frame, popup)
            Util.List(frame, 4)
            local query = ""
            local box
            if search then
                local holder, api = Row.Field(frame, { Size = UDim2.new(1, 0, 0, 26), LayoutOrder = 1, Radius = 5 })
                holder.ZIndex = 101
                Util.Icon("search", { Size = UDim2.fromOffset(12, 12), Position = UDim2.new(0, 8, 0.5, -6), Color = "TextMuted", ZIndex = 102, Parent = holder })
                box = Util.New("TextBox", {
                    Size = UDim2.new(1, -30, 1, 0),
                    Position = UDim2.fromOffset(26, 0),
                    PlaceholderText = "Search...",
                    Text = "",
                    TextSize = 12,
                    ZIndex = 102,
                    Theme = { TextColor3 = "Text", PlaceholderColor3 = "TextMuted", FontFace = Theme.Font(Enum.FontWeight.Medium) },
                    Parent = holder,
                })
                box.Focused:Connect(function() api.SetFocused(true) end)
                box.FocusLost:Connect(function() api.SetFocused(false) end)
            end

            if self.Multi then
                local actions = Util.New("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 18), LayoutOrder = 2, ZIndex = 101, Parent = frame })
                Util.List(actions, 10, Enum.FillDirection.Horizontal, nil, Enum.VerticalAlignment.Center)
                Util.Padding(actions, 0, 4, 0, 4)
                local function action(text, order, fn)
                    local button = Util.New("TextButton", {
                        AutomaticSize = Enum.AutomaticSize.X,
                        Size = UDim2.fromScale(0, 1),
                        BackgroundTransparency = 1,
                        Text = text,
                        TextSize = 11,
                        LayoutOrder = order,
                        ZIndex = 102,
                        Theme = { TextColor3 = "Accent", FontFace = Theme.Font(Enum.FontWeight.SemiBold) },
                        Parent = actions,
                    })
                    button.MouseButton1Click:Connect(fn)
                end
                action("Select all", 1, function()
                    local list = {}
                    for _, option in self.Options do
                        if query == "" or option.Title:lower():find(query, 1, true) then table.insert(list, option.Value) end
                    end
                    for _, value in self.Value do table.insert(list, value) end
                    self:Set(list)
                end)
                action("Clear", 2, function() self:Set({}) end)
            end

            local list = Util.New("ScrollingFrame", {
                Size = UDim2.new(1, 0, 0, 0),
                LayoutOrder = 3,
                ZIndex = 101,
                ScrollBarThickness = 2,
                Theme = { ScrollBarImageColor3 = "TextMuted" },
                Parent = frame,
            })
            Util.AutoCanvas(list, Util.List(list, 1))
            local empty = Util.Label({
                Text = "No results",
                TextSize = 11,
                Color = "TextMuted",
                TextXAlignment = Enum.TextXAlignment.Center,
                Size = UDim2.new(1, 0, 0, 24),
                Visible = false,
                LayoutOrder = 4,
                ZIndex = 101,
                Parent = frame,
            })

            local rows = {}
            local function paintRows()
                for _, entry in rows do
                    local selected = self:IsSelected(entry.Option.Value)
                    entry.Selected = selected
                    Theme.Refresh(entry.Title, 0.1)
                    Theme.Refresh(entry.Mark, 0.1)
                    Theme.Refresh(entry.Button, 0.1)
                end
            end

            local function layout()
                local visible, height = 0, 0
                for _, entry in rows do
                    local show = query == "" or entry.Option.Title:lower():find(query, 1, true) ~= nil
                        or (entry.Option.Description and entry.Option.Description:lower():find(query, 1, true) ~= nil)
                    entry.Button.Visible = show
                    if show then
                        visible += 1
                        if visible <= maxVisible then height += entry.Button.Size.Y.Offset + 1 end
                    end
                end
                list.Size = UDim2.new(1, 0, 0, height)
                empty.Visible = visible == 0
            end

            local function build()
                for _, entry in rows do entry.Button:Destroy() end
                table.clear(rows)
                for index, option in self.Options do
                    local entry = { Option = option, Selected = false, Hover = false }
                    local tall = option.Description ~= nil
                    local button = Util.New("TextButton", {
                        Size = UDim2.new(1, -4, 0, tall and 38 or 26),
                        LayoutOrder = index,
                        ZIndex = 102,
                        Theme = {
                            BackgroundColor3 = "ElevatedHover",
                            BackgroundTransparency = function() return entry.Hover and 0 or (entry.Selected and 0.55 or 1) end,
                        },
                        Parent = list,
                    })
                    Util.Corner(5, button)
                    entry.Button = button
                    local x = 26
                    entry.Mark = Util.Icon("check", {
                        Size = UDim2.fromOffset(12, 12),
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        Position = UDim2.new(0, 13, 0, tall and 13 or 13),
                        ZIndex = 103,
                        Theme = {
                            ImageColor3 = "Accent",
                            ImageTransparency = function() return entry.Selected and 0 or 1 end,
                        },
                        Parent = button,
                    })
                    if option.Icon then
                        Util.Icon(option.Icon, { Size = UDim2.fromOffset(14, 14), Position = UDim2.fromOffset(x, 6), Color = "TextDim", ZIndex = 103, Parent = button })
                        x += 20
                    end
                    entry.Title = Util.Label({
                        Text = option.Title,
                        TextSize = 12,
                        Weight = Enum.FontWeight.Medium,
                        TextTruncate = Enum.TextTruncate.AtEnd,
                        Size = UDim2.new(1, -x - 6, 0, 26),
                        Position = UDim2.fromOffset(x, 0),
                        ZIndex = 103,
                        Theme = { TextColor3 = function(t) return entry.Selected and t.Text or t.TextDim end },
                        Parent = button,
                    })
                    if tall then
                        Util.Label({
                            Text = option.Description,
                            TextSize = 10,
                            Color = "TextMuted",
                            TextTruncate = Enum.TextTruncate.AtEnd,
                            Size = UDim2.new(1, -x - 6, 0, 12),
                            Position = UDim2.fromOffset(x, 21),
                            ZIndex = 103,
                            Parent = button,
                        })
                    end
                    Util.Hover(button, function(on) entry.Hover = on; Theme.Refresh(button, 0.08) end)
                    button.MouseButton1Click:Connect(function()
                        if self.Locked then return end
                        if self.Multi then
                            self:Toggle(option.Value)
                        else
                            if self.Value == option.Value and self.Def.AllowNone then
                                self:Set(nil)
                            else
                                self:Set(option.Value)
                            end
                            popup:Close()
                        end
                    end)
                    table.insert(rows, entry)
                end
                paintRows()
                layout()
            end
            build()

            popup.Maid:Give(self.Changed:Connect(paintRows))
            popup.Maid:Give(self.StateChanged:Connect(function(what)
                if what == "Options" then build() end
            end))
            if box then
                box:GetPropertyChangedSignal("Text"):Connect(function()
                    query = box.Text:lower()
                    layout()
                end)
                box.FocusLost:Connect(function(enter)
                    if not enter or self.Multi then return end
                    for _, entry in rows do
                        if entry.Button.Visible then
                            self:Set(entry.Option.Value)
                            popup:Close()
                            return
                        end
                    end
                end)
                -- touch: no keyboard popping up on every open, a tap on the field focuses it
                if not Util.Touch() then task.defer(function() if box.Parent then box:CaptureFocus() end end) end
            end
        end,
    })
end

function Dropdown:Render(parent, maid)
    local row = Row.new(self, parent, maid, { Below = true })
    local action = self.Def.Action
    local field = Row.Field(row.Below, { Button = true, Size = UDim2.new(1, action and -34 or 0, 0, 28) })
    if action then
        -- Action = { Icon, Tooltip, Callback }: a square button after the field, e.g. a test or refresh
        local button = Row.Field(row.Below, { Button = true, Size = UDim2.fromOffset(28, 28), AnchorPoint = Vector2.new(1, 0), Position = UDim2.fromScale(1, 0) })
        Util.Icon(action.Icon or "play", { Size = UDim2.fromOffset(14, 14), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Color = "TextDim", Parent = button })
        if action.Tooltip then maid:Give(Tooltip.Attach(button, action.Tooltip)) end
        button.MouseButton1Click:Connect(function()
            if not self.Locked then Util.Safe(action.Callback, self.Value) end
        end)
    end
    local text = Util.Label({
        TextSize = 12,
        Weight = Enum.FontWeight.Medium,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Size = UDim2.new(1, -54, 1, 0),
        Position = UDim2.fromOffset(10, 0),
        Theme = { TextColor3 = function(t) return self:DisplayText() and t.Text or t.TextMuted end },
        Parent = field,
    })
    local badge = Util.New("Frame", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -28, 0.5, 0),
        Size = UDim2.fromOffset(0, 16),
        AutomaticSize = Enum.AutomaticSize.X,
        Visible = false,
        Theme = { BackgroundColor3 = "Accent" },
        Parent = field,
    })
    Util.Corner(UDim.new(1, 0), badge)
    Util.Padding(badge, 0, 5, 0, 5)
    local count = Util.Label({
        TextSize = 10,
        Color = "OnAccent",
        Weight = Enum.FontWeight.Bold,
        AutomaticSize = Enum.AutomaticSize.X,
        Size = UDim2.fromScale(0, 1),
        TextXAlignment = Enum.TextXAlignment.Center,
        Parent = badge,
    })
    Util.New("UISizeConstraint", { MinSize = Vector2.new(16, 16), Parent = badge })
    local chevron = Util.Icon("chevron-down", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -8, 0.5, 0),
        Size = UDim2.fromOffset(14, 14),
        Color = "TextMuted",
        Parent = field,
    })

    local function paint()
        text.Text = self:DisplayText() or (self.Def.Placeholder or (self.Multi and "None selected" or "Select..."))
        Theme.Refresh(text)
        local many = self.Multi and #self.Value > 0
        badge.Visible = many
        count.Text = many and tostring(#self.Value) or ""
        text.Size = UDim2.new(1, many and -76 or -54, 1, 0)
    end
    paint()
    maid:Give(self.Changed:Connect(paint))
    maid:Give(self.StateChanged:Connect(function(what) if what == "Options" then paint() end end))

    field.MouseButton1Click:Connect(function()
        if self.Locked then return end
        if Popup.Current and Popup.Current.Anchor == field then
            Popup.Current:Close()
            return
        end
        self:_open(field, chevron)
    end)
    return row.Frame
end

return Dropdown
end

__modules["Elements/Group"] = function(...)
local import = ...
local Base = import("Elements/Base")
local Util = import("Core/Util")
local Theme = import("Core/Theme")
local Container = import("Components/Container")

-- collapsible sub-list inside a module; holds elements like a module does
-- def: Title, Description, Icon, Opened (default false)
local Group = Base.Class("Group")
Container.Apply(Group)

function Group.new(container, def)
    local self = setmetatable({}, Group)
    Base.Init(self, container, def)
    Container.Setup(self)
    self.Module = container.Module or container
    self.Opened = def.Opened == true or def.Open == true
    self.NoSave = true
    return self
end

function Group:_add(kind, a, b)
    local element = Container._add(self, kind, a, b)
    self.StateChanged:Fire("Children")
    return element
end

function Group:SetOpened(opened)
    self.Opened = opened and true or false
    self.StateChanged:Fire("Opened")
end

function Group:Matches(query)
    return Base.Matches(self, query) or self:_matchesChildren(query)
end

function Group:Destroy()
    for _, child in table.clone(self.Children) do child:Destroy() end
    Base.Destroy(self)
end

function Group:Render(parent, maid)
    local frame = maid:Give(Util.New("Frame", {
        Name = "Group",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        Visible = self.Visible,
        Parent = parent,
    }))
    Util.List(frame, 6)

    local hover = false
    local head = Util.New("TextButton", {
        Size = UDim2.new(1, 0, 0, 22),
        LayoutOrder = 1,
        Theme = {
            BackgroundColor3 = "Elevated",
            BackgroundTransparency = function(t) return hover and t.ElevatedTransparency or 1 end,
        },
        Parent = frame,
    })
    Util.Corner(5, head)
    -- an image swap: Rotation does not render inside the clipping columns
    local chevron = Util.Icon(self.Opened and "chevron-down" or "chevron-right", {
        Size = UDim2.fromOffset(13, 13),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0, 9, 0.5, 0),
        Color = "TextMuted",
        Parent = head,
    })
    local x = 20
    if self.Def.Icon then
        Util.Icon(self.Def.Icon, { Size = UDim2.fromOffset(13, 13), Position = UDim2.new(0, 20, 0.5, -6), Color = "Accent", Parent = head })
        x = 39
    end
    local title = Util.Label({
        Text = self.Title,
        TextSize = 12,
        Weight = Enum.FontWeight.SemiBold,
        Color = "TextDim",
        Size = UDim2.new(1, -x - 30, 1, 0),
        Position = UDim2.fromOffset(x, 0),
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = head,
    })
    local count = Util.Label({
        TextSize = 10,
        Color = "TextMuted",
        TextXAlignment = Enum.TextXAlignment.Right,
        Size = UDim2.new(0, 30, 1, 0),
        Position = UDim2.new(1, -36, 0, 0),
        Parent = head,
    })

    local body = Util.New("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        Visible = self.Opened,
        LayoutOrder = 2,
        Parent = frame,
    })
    Util.New("Frame", {
        Size = UDim2.new(0, 1, 1, -4),
        Position = UDim2.fromOffset(8, 2),
        Theme = { BackgroundColor3 = "Divider" },
        Parent = body,
    })
    local list = Util.New("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -18, 0, 0),
        Position = UDim2.fromOffset(18, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        Parent = body,
    })
    Util.List(list, 8)
    Util.Padding(list, 2, 0, 4, 0)
    self:_mountChildren(list, maid)

    local function paint(animate)
        title.Text = self.Title
        body.Visible = self.Opened
        count.Text = tostring(#self.Children)
        count.Visible = not self.Opened
        chevron.Image = Util.IconId(self.Opened and "chevron-down" or "chevron-right")
        frame.Visible = self.Visible
    end
    paint(false)
    maid:Give(self.StateChanged:Connect(function() paint(true) end))
    Util.Hover(head, function(on) hover = on; Theme.Refresh(head, 0.1) end)
    head.MouseButton1Click:Connect(function() self:SetOpened(not self.Opened) end)
    return frame
end

return Group
end

__modules["Elements/Image"] = function(...)
local import = ...
local Base = import("Elements/Base")
local Util = import("Core/Util")

-- def: Image (asset id, url or icon name), Height (default 120) or AspectRatio (number | "16:9"), Radius, ScaleType
local Image = Base.Class("Image")

function Image.new(container, def)
    local self = setmetatable({}, Image)
    Base.Init(self, container, def)
    self.Value = def.Image or ""
    self.NoSave = true
    return self
end

function Image:Set(image)
    self.Value = image
    self.Changed:Fire(image)
end

function Image:Matches()
    return false
end

function Image:Render(parent, maid)
    local frame = maid:Give(Util.New("ImageLabel", {
        Name = "Image",
        Size = UDim2.new(1, 0, 0, self.Def.Height or 120),
        Image = Util.IconId(self.Value) or "",
        ScaleType = self.Def.ScaleType or Enum.ScaleType.Crop,
        BackgroundTransparency = 0,
        Visible = self.Visible,
        Theme = { BackgroundColor3 = "Elevated" },
        Parent = parent,
    }))
    Util.Corner(self.Def.Radius or 6, frame)
    local ratio = self.Def.AspectRatio
    if type(ratio) == "string" then
        local w, h = ratio:match("(%d+)%s*:%s*(%d+)")
        ratio = if w and h then (tonumber(w) or 1) / (tonumber(h) or 1) else nil
    end
    if ratio then
        Util.New("UIAspectRatioConstraint", { AspectRatio = ratio, DominantAxis = Enum.DominantAxis.Width, Parent = frame })
        frame.Size = UDim2.fromScale(1, 1)
    end
    maid:Give(self.Changed:Connect(function() frame.Image = Util.IconId(self.Value) or "" end))
    return frame
end

return Image
end

__modules["Elements/Input"] = function(...)
local import = ...
local Base = import("Elements/Base")
local Util = import("Core/Util")
local Theme = import("Core/Theme")
local Row = import("Components/Row")
local Tooltip = import("Components/Tooltip")
local TextArea = import("Components/TextArea")

-- def: Title, Default, Placeholder, Numeric, Min, Max, Step, MaxLength, Finished (default true: commit on enter / focus lost),
--      Validate(text) -> ok, message, Icon, Multiline, Height, ClearOnFocus, Callback(value)
local Input = Base.Class("Input")

function Input.new(container, def)
    local self = setmetatable({}, Input)
    Base.Init(self, container, def)
    self.Numeric = def.Numeric == true
    local default = def.Default
    if default == nil then default = def.Value end
    self.Value = self:_coerce(default == nil and (self.Numeric and (def.Min or 0) or "") or default)
    self.Default = self.Value
    self.Error = nil
    return self
end

function Input:_coerce(value)
    if self.Numeric then
        local number = tonumber(value) or Util.ParseNumber(tostring(value)) or 0
        if self.Def.Step then number = Util.Round(number, self.Def.Step) end
        if self.Def.Min then number = math.max(number, self.Def.Min) end
        if self.Def.Max then number = math.min(number, self.Def.Max) end
        return number
    end
    local text = tostring(value)
    if self.Def.MaxLength then text = text:sub(1, self.Def.MaxLength) end
    return text
end

function Input:Set(value, silent)
    value = self:_coerce(value)
    self.Error = nil
    if value == self.Value then
        self.StateChanged:Fire("Error")
        return
    end
    self:_commit(value, silent)
end

-- user text: parse + validate, keeps an error message instead of committing
function Input:Submit(text)
    if self.Numeric then
        local number = Util.ParseNumber(text)
        if not number then
            self.Error = "Enter a number."
            self.StateChanged:Fire("Error")
            return false
        end
        if (self.Def.Min and number < self.Def.Min) or (self.Def.Max and number > self.Def.Max) then
            local min, max = self.Def.Min, self.Def.Max
            self.Error = string.format("Allowed: %s – %s", min and Util.Compact(min) or "-∞", max and Util.Compact(max) or "∞")
            self.StateChanged:Fire("Error")
            return false
        end
        text = number
    end
    if self.Def.Validate then
        local ok, valid, message = pcall(self.Def.Validate, text)
        if not ok or valid == false or valid == nil then
            self.Error = ok and (message or "Invalid value.") or tostring(valid)
            self.StateChanged:Fire("Error")
            return false
        end
    end
    self:Set(text)
    return true
end

function Input:Text()
    if self.Numeric then return Util.Format(self.Value, self.Def.Step or (math.floor(self.Value) == self.Value and 1 or 0.01)) end
    return self.Value
end

-- a compact box inside another element's row (Toggle Field); a rejected entry flashes the message and
-- the last valid value comes back
function Input:RenderInline(parent, maid, props)
    props = props or {}
    local field, api = Row.Field(parent, { Size = UDim2.fromOffset(props.Width or 96, 22), LayoutOrder = props.LayoutOrder or 0, Radius = 5 })
    local box = Util.New("TextBox", {
        Size = UDim2.new(1, -12, 1, 0),
        Position = UDim2.fromOffset(6, 0),
        Text = self:Text(),
        PlaceholderText = self.Def.Placeholder or "",
        TextSize = 11,
        ClearTextOnFocus = self.Def.ClearOnFocus == true,
        ClipsDescendants = true,
        Theme = { TextColor3 = "Text", PlaceholderColor3 = "TextMuted", FontFace = Theme.Font(Enum.FontWeight.Medium) },
        Parent = field,
    })
    local function paint()
        if not box:IsFocused() then box.Text = self:Text() end
        api.SetStroke(self.Error and "Danger" or nil)
    end
    paint()
    maid:Give(self.Changed:Connect(paint))
    maid:Give(self.StateChanged:Connect(function(what) if what == "Error" or what == "Locked" then paint() end end))
    if self.Tooltip then maid:Give(Tooltip.Attach(field, function() return self.Error or self.Tooltip end)) end
    box.Focused:Connect(function() api.SetFocused(true) end)
    box.FocusLost:Connect(function()
        api.SetFocused(false)
        if self.Locked then box.Text = self:Text(); return end
        if not self:Submit(box.Text) then
            local message = self.Error
            Tooltip.Show(message)
            task.delay(2, function()
                if self.Error ~= message then return end
                self.Error = nil
                self.StateChanged:Fire("Error")
            end)
        end
        box.Text = self:Text()
        paint()
    end)
    return field
end

function Input:Render(parent, maid)
    local row = Row.new(self, parent, maid, { Below = true })
    Util.List(row.Below, 3)
    local height = self.Def.Multiline and (self.Def.Height or 72) or 28
    local field, api = Row.Field(row.Below, { Size = UDim2.new(1, 0, 0, height), LayoutOrder = 1 })
    local left = 10
    if self.Def.Icon then
        Util.Icon(self.Def.Icon, { Size = UDim2.fromOffset(13, 13), Position = UDim2.fromOffset(9, height == 28 and 7 or 8), Color = "TextMuted", Parent = field })
        left = 28
    end
    local box
    if self.Def.Multiline then
        -- long text scrolls inside the field and follows the caret
        local _
        _, box = TextArea.new({
            Size = UDim2.new(1, -left - 22, 1, -4),
            Position = UDim2.fromOffset(left - 6, 2),
            Parent = field,
            Box = {
                Text = self:Text(),
                PlaceholderText = self.Def.Placeholder or "",
                TextSize = 12,
                ClearTextOnFocus = self.Def.ClearOnFocus == true,
                Theme = { TextColor3 = "Text", PlaceholderColor3 = "TextMuted", FontFace = Theme.Font(Enum.FontWeight.Medium) },
            },
        })
    else
        box = Util.New("TextBox", {
            Size = UDim2.new(1, -left - 28, 1, 0),
            Position = UDim2.fromOffset(left, 0),
            Text = self:Text(),
            PlaceholderText = self.Def.Placeholder or "",
            TextSize = 12,
            TextYAlignment = Enum.TextYAlignment.Center,
            ClearTextOnFocus = self.Def.ClearOnFocus == true,
            ClipsDescendants = true,
            Theme = { TextColor3 = "Text", PlaceholderColor3 = "TextMuted", FontFace = Theme.Font(Enum.FontWeight.Medium) },
            Parent = field,
        })
    end
    local clear = Util.New("ImageButton", {
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -8, 0, height == 28 and 8 or 8),
        Size = UDim2.fromOffset(12, 12),
        Image = Util.IconId("x"),
        Theme = { ImageColor3 = "TextMuted" },
        Parent = field,
    })
    local errorLabel = Util.Label({
        TextSize = 10,
        Color = "Danger",
        Size = UDim2.new(1, 0, 0, 12),
        Visible = false,
        LayoutOrder = 2,
        Parent = row.Below,
    })

    local finished = self.Def.Finished ~= false
    local function paint()
        if not box:IsFocused() then box.Text = self:Text() end
        clear.Visible = box.Text ~= "" and not self.Locked and not self.Numeric
        errorLabel.Visible = self.Error ~= nil
        errorLabel.Text = self.Error or ""
        api.SetStroke(self.Error and "Danger" or nil)
    end
    paint()
    maid:Give(self.Changed:Connect(paint))
    maid:Give(self.StateChanged:Connect(function(what) if what == "Error" or what == "Locked" then paint() end end))

    box.Focused:Connect(function() api.SetFocused(true) end)
    box.FocusLost:Connect(function()
        api.SetFocused(false)
        if self.Locked then box.Text = self:Text(); return end
        if finished or self.Numeric then self:Submit(box.Text) end
        paint()
    end)
    box:GetPropertyChangedSignal("Text"):Connect(function()
        clear.Visible = box.Text ~= "" and not self.Locked and not self.Numeric
        if not finished and not self.Numeric and box:IsFocused() then self:Submit(box.Text) end
    end)
    clear.MouseButton1Click:Connect(function()
        if self.Locked then return end
        box.Text = ""
        self:Submit("")
    end)
    return row.Frame
end

return Input
end

__modules["Elements/Keybind"] = function(...)
local import = ...
local Base = import("Elements/Base")
local Util = import("Core/Util")
local Binding = import("Core/Binding")
local Row = import("Components/Row")
local Widgets = import("Components/Widgets")

-- def: Title, Default (KeyCode | name), Mode ("Toggle" | "Hold" | "Always"), Modes,
--      Callback(state) for Toggle / Hold, Pressed() on every press, ChangedCallback(key)
local Keybind = Base.Class("Keybind")

function Keybind.new(container, def)
    local self = setmetatable({}, Keybind)
    Base.Init(self, container, def)
    self.Value = false
    -- def.Binding: show an existing binding (owner handles presses)
    self.Binding = def.Binding or Binding.new({
        Key = def.Default or def.Key or def.Value,
        Mode = def.Mode or "Toggle",
        Modes = def.Modes or { "Toggle", "Hold", "Always" },
        Capture = def,
        Press = function(binding)
            if self.Locked then return end
            Util.Safe(def.Pressed)
            if binding.Mode == "Toggle" then
                self:_commit(not self.Value)
            elseif binding.Mode == "Hold" then
                self:_commit(true)
            else
                Util.Safe(def.Callback)
            end
        end,
        Release = function(binding)
            if binding.Mode == "Hold" and not self.Locked then self:_commit(false) end
        end,
    })
    self.Binding.Changed:Connect(function()
        if self.Binding.Mode == "Always" and self.Value then self:_commit(false, true) end
        Util.Safe(def.ChangedCallback, self.Binding.Key)
        self.Window:_touch(true)
    end)
    if not def.Binding then self.Window:_trackBind(self) end
    return self
end

function Keybind:Set(state, silent)
    state = state and true or false
    if state == self.Value then return end
    self:_commit(state, silent)
end

function Keybind:GetKey()
    return self.Binding.Key
end

function Keybind:SetKey(key)
    self.Binding:SetKey(key)
end

function Keybind:SetMode(mode)
    self.Binding:SetMode(mode)
end

function Keybind:IsDown()
    return self.Binding.Held
end

function Keybind:BindInfo()
    return self.Title, self.Value
end

function Keybind:Save()
    return self.Binding:Save()
end

function Keybind:Load(data)
    self.Binding:Load(data)
end

function Keybind:Render(parent, maid)
    local row = Row.new(self, parent, maid)
    local _, connection = Widgets.KeyPill(row.Right, self.Binding, { Height = 20 })
    maid:Give(connection)
    return row.Frame
end

return Keybind
end

__modules["Elements/Label"] = function(...)
local import = ...
local Base = import("Elements/Base")
local Util = import("Core/Util")
local Theme = import("Core/Theme")

-- def: Text, Value (right aligned text), Color (token), ValueColor (token | Color3), Size, RichText;
--      Set(text), SetValue(text), SetValueColor(token | Color3 | nil)
local Label = Base.Class("Label")

function Label.new(container, def)
    local self = setmetatable({}, Label)
    Base.Init(self, container, def)
    self.Title = def.Text or def.Title or ""
    self.Value = def.Value
    self.ValueColor = def.ValueColor
    self.NoSave = true
    return self
end

function Label:SetValueColor(color)
    if color == self.ValueColor then return end
    self.ValueColor = color
    self.StateChanged:Fire("ValueColor")
end

function Label:Set(text)
    self:SetTitle(tostring(text))
end

function Label:SetValue(text)
    self.Value = text ~= nil and tostring(text) or nil
    self.Changed:Fire(self.Value)
end

function Label:Render(parent, maid)
    local frame = maid:Give(Util.New("Frame", {
        Name = "Label",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        Visible = self.Visible,
        Parent = parent,
    }))
    local text = Util.Label({
        Text = self.Title,
        TextSize = self.Def.Size or 12,
        Color = self.Def.Color or "TextDim",
        RichText = self.Def.RichText ~= false,
        TextWrapped = true,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        Parent = frame,
    })
    local value = Util.Label({
        TextSize = self.Def.Size or 12,
        Theme = { TextColor3 = function(t)
            local color = self.ValueColor
            if typeof(color) == "Color3" then return color end
            return t[color or "Text"] or t.Text
        end },
        Weight = Enum.FontWeight.SemiBold,
        TextXAlignment = Enum.TextXAlignment.Right,
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.fromScale(1, 0),
        Size = UDim2.new(0, 0, 0, 16),
        AutomaticSize = Enum.AutomaticSize.X,
        Parent = frame,
    })
    local function paint()
        text.Text = self.Title
        value.Text = self.Value or ""
        value.Visible = self.Value ~= nil
        text.Size = UDim2.new(1, self.Value and -(value.AbsoluteSize.X + 10) or 0, 0, 0)
        frame.Visible = self.Visible
        Theme.Refresh(value)
    end
    paint()
    maid:Give(self.Changed:Connect(paint))
    maid:Give(self.StateChanged:Connect(paint))
    maid:Give(value:GetPropertyChangedSignal("AbsoluteSize"):Connect(paint))
    return frame
end

return Label
end

__modules["Elements/Log"] = function(...)
local import = ...
local Base = import("Elements/Base")
local Util = import("Core/Util")

-- scrolling list of lines with its own height; def: Title, Height (default 140), MaxLines (default 200),
-- Monospace, Timestamps, AutoScroll (default true); Add(text, colorToken?), Clear(), Set(lines)
local Log = Base.Class("Log")

function Log.new(container, def)
    local self = setmetatable({}, Log)
    Base.Init(self, container, def)
    self.Title = def.Title or ""
    self.Value = {}
    self.NoSave = true
    return self
end

function Log:Add(text, color)
    local line = { Text = tostring(text), Color = color }
    if self.Def.Timestamps then line.Text = os.date("%H:%M:%S") .. "  " .. line.Text end
    table.insert(self.Value, line)
    local max = self.Def.MaxLines or 200
    while #self.Value > max do table.remove(self.Value, 1) end
    self.Changed:Fire("Add", line)
end

function Log:Clear()
    table.clear(self.Value)
    self.Changed:Fire("Clear")
end

function Log:Set(lines)
    table.clear(self.Value)
    for _, text in lines do table.insert(self.Value, { Text = tostring(text) }) end
    self.Changed:Fire("Clear")
    for _, line in self.Value do self.Changed:Fire("Add", line) end
end

function Log:Matches(query)
    return self.Title ~= "" and Base.Matches(self, query)
end

function Log:Render(parent, maid)
    local frame = maid:Give(Util.New("Frame", {
        Name = "Log",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        Visible = self.Visible,
        Parent = parent,
    }))
    Util.List(frame, 6)
    if self.Title ~= "" then
        Util.Label({ Text = self.Title, TextSize = 12, Weight = Enum.FontWeight.Medium, Size = UDim2.new(1, 0, 0, 16), LayoutOrder = 1, Parent = frame })
    end
    local box = Util.New("ScrollingFrame", {
        Size = UDim2.new(1, 0, 0, self.Def.Height or 140),
        BackgroundTransparency = 0,
        ScrollBarThickness = 3,
        LayoutOrder = 2,
        Theme = {
            BackgroundColor3 = "Background",
            BackgroundTransparency = function() return 0.25 end,
            ScrollBarImageColor3 = "TextMuted",
        },
        Parent = frame,
    })
    Util.Corner(6, box)
    Util.Stroke(box)
    Util.Padding(box, 6, 8, 6, 8)
    Util.AutoCanvas(box, Util.List(box, 2))
    local font = self.Def.Monospace and Font.new("rbxasset://fonts/families/RobotoMono.json") or nil
    local count = 0
    local lines = {}
    local function add(line)
        count += 1
        local label = Util.Label({
            Text = line.Text,
            TextSize = 11,
            Color = line.Color or "TextDim",
            TextWrapped = true,
            RichText = true,
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            LayoutOrder = count,
            Theme = font and { FontFace = function() return font end } or nil,
            Parent = box,
        })
        table.insert(lines, label)
        while #lines > (self.Def.MaxLines or 200) do
            local oldest = table.remove(lines, 1)
            if oldest then oldest:Destroy() end
        end
        if self.Def.AutoScroll ~= false then
            task.defer(function()
                if box.Parent then box.CanvasPosition = Vector2.new(0, math.huge) end
            end)
        end
    end
    for _, line in self.Value do add(line) end
    maid:Give(self.Changed:Connect(function(what, line)
        if what == "Clear" then
            for _, label in lines do label:Destroy() end
            table.clear(lines)
        elseif what == "Add" then
            add(line)
        end
    end))
    maid:Give(self.StateChanged:Connect(function() frame.Visible = self.Visible end))
    return frame
end

return Log
end

__modules["Elements/Paragraph"] = function(...)
local import = ...
local Base = import("Elements/Base")
local Util = import("Core/Util")

-- def: Title, Content, Icon; Set({ Title, Content }) or SetContent(text)
local Paragraph = Base.Class("Paragraph")

function Paragraph.new(container, def)
    local self = setmetatable({}, Paragraph)
    Base.Init(self, container, def)
    self.Title = def.Title or ""
    self.Value = def.Content or def.Text or ""
    self.NoSave = true
    return self
end

function Paragraph:Set(data)
    if type(data) == "table" then
        if data.Title then self.Title = data.Title end
        self.Value = data.Content or self.Value
    else
        self.Value = tostring(data)
    end
    self.Changed:Fire(self.Value)
end

function Paragraph:SetContent(text)
    self:Set(tostring(text))
end

function Paragraph:Matches(query)
    return Base.Matches(self, query) or tostring(self.Value):lower():find(query, 1, true) ~= nil
end

function Paragraph:Render(parent, maid)
    local box = maid:Give(Util.New("Frame", {
        Name = "Paragraph",
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        Visible = self.Visible,
        Theme = { BackgroundColor3 = "Elevated", BackgroundTransparency = function(t) return math.min(t.ElevatedTransparency + 0.2, 0.9) end },
        Parent = parent,
    }))
    Util.Corner(6, box)
    if self.Def.Icon then
        Util.Icon(self.Def.Icon, { Size = UDim2.fromOffset(14, 14), Position = UDim2.fromOffset(11, 10), Color = "Accent", Parent = box })
    end
    local content = Util.New("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        Parent = box,
    })
    Util.Padding(content, 9, 10, 10, self.Def.Icon and 32 or 10)
    Util.List(content, 3)
    local title = Util.Label({
        Text = self.Title,
        TextSize = 12,
        Weight = Enum.FontWeight.SemiBold,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        TextWrapped = true,
        LayoutOrder = 1,
        Parent = content,
    })
    local body = Util.Label({
        Text = self.Value,
        TextSize = 11,
        Color = "TextDim",
        RichText = true,
        TextWrapped = true,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        LayoutOrder = 2,
        Parent = content,
    })
    local function paint()
        title.Text = self.Title
        title.Visible = self.Title ~= ""
        body.Text = self.Value
        body.Visible = self.Value ~= ""
        box.Visible = self.Visible
    end
    paint()
    maid:Give(self.Changed:Connect(paint))
    maid:Give(self.StateChanged:Connect(paint))
    return box
end

return Paragraph
end

__modules["Elements/ProgressBar"] = function(...)
local import = ...
local Base = import("Elements/Base")
local Util = import("Core/Util")
local Row = import("Components/Row")

-- def: Title, Value, Max (default 100), Suffix, Format(value, max) -> text, Color (token, default Accent)
local ProgressBar = Base.Class("ProgressBar")

function ProgressBar.new(container, def)
    local self = setmetatable({}, ProgressBar)
    Base.Init(self, container, def)
    self.Max = def.Max or 100
    self.Value = math.clamp(def.Value or def.Default or 0, 0, self.Max)
    self.NoSave = true
    return self
end

function ProgressBar:Set(value)
    value = math.clamp(tonumber(value) or 0, 0, self.Max)
    if value == self.Value then return end
    self.Value = value
    self.Changed:Fire(value)
end

function ProgressBar:SetMax(max)
    self.Max = math.max(max, 0.0001)
    self:Set(self.Value)
    self.Changed:Fire(self.Value)
end

function ProgressBar:Text()
    if self.Def.Format then
        local ok, text = pcall(self.Def.Format, self.Value, self.Max)
        if ok then return tostring(text) end
    end
    if self.Def.Suffix then return Util.Format(self.Value, 0.1):gsub("%.0$", "") .. self.Def.Suffix end
    return math.floor(self.Value / self.Max * 100 + 0.5) .. "%"
end

function ProgressBar:Render(parent, maid)
    local row = Row.new(self, parent, maid, { Below = true })
    local value = Util.Label({
        TextSize = 11,
        Color = "TextDim",
        Weight = Enum.FontWeight.SemiBold,
        AutomaticSize = Enum.AutomaticSize.X,
        Size = UDim2.fromScale(0, 1),
        Parent = row.Right,
    })
    local rail = Util.New("Frame", {
        Size = UDim2.new(1, 0, 0, 6),
        Theme = { BackgroundColor3 = "Elevated" },
        Parent = row.Below,
    })
    Util.Corner(UDim.new(1, 0), rail)
    local fill = Util.New("Frame", {
        Size = UDim2.fromScale(0, 1),
        Theme = { BackgroundColor3 = self.Def.Color or "Accent" },
        Parent = rail,
    })
    Util.Corner(UDim.new(1, 0), fill)
    local function paint(animate)
        value.Text = self:Text()
        Util.Tween(fill, animate and 0.25 or 0, { Size = UDim2.fromScale(self.Max > 0 and self.Value / self.Max or 0, 1) })
    end
    paint(false)
    maid:Give(self.Changed:Connect(function() paint(true) end))
    return row.Frame
end

return ProgressBar
end

__modules["Elements/RangeSlider"] = function(...)
local import = ...
local Base = import("Elements/Base")
local Util = import("Core/Util")
local Drag = import("Core/Drag")
local Row = import("Components/Row")
local Slider = import("Elements/Slider")

-- two handles on one track; def: Title, Min, Max, Default = { lo, hi } | { Min, Max }, Step, MinGap,
--      Prefix, Suffix, Format, Input, Buttons, Icons, ShowRange, Live, Callback(lo, hi)
local RangeSlider = Base.Class("RangeSlider")

function RangeSlider.new(container, def)
    local self = setmetatable({}, RangeSlider)
    Base.Init(self, container, def)
    self.Min = def.Min or 0
    self.Max = def.Max or 100
    self.Step = def.Step or (def.Rounding and 10 ^ -def.Rounding) or 1
    self.Gap = def.MinGap or 0
    local default = def.Default or def.Value or {}
    local lo = default.Min or default[1] or self.Min
    local hi = default.Max or default[2] or self.Max
    self.Value = self:_clamp(lo, hi)
    self.Default = table.clone(self.Value)
    return self
end

RangeSlider.Text = Slider.Text

function RangeSlider:_clamp(lo, hi, moving)
    lo = math.clamp(Util.Round(tonumber(lo) or self.Min, self.Step), self.Min, self.Max)
    hi = math.clamp(Util.Round(tonumber(hi) or self.Max, self.Step), self.Min, self.Max)
    if hi - lo < self.Gap then
        if moving == "Max" then
            lo = math.max(self.Min, hi - self.Gap)
            hi = lo + self.Gap
        else
            hi = math.min(self.Max, lo + self.Gap)
            lo = hi - self.Gap
        end
    end
    return { Min = lo, Max = hi }
end

function RangeSlider:_args()
    return self.Value.Min, self.Value.Max
end

-- Set(lo, hi) or Set({ lo, hi })
function RangeSlider:Set(lo, hi, silent, moving)
    if type(lo) == "table" then
        lo, hi, silent = lo.Min or lo[1], lo.Max or lo[2], hi
    end
    local value = self:_clamp(lo, hi, moving)
    if value.Min == self.Value.Min and value.Max == self.Value.Max then return end
    self:_commit(value, silent)
end

function RangeSlider:Reset()
    self:Set(self.Default.Min, self.Default.Max)
end

function RangeSlider:Save()
    return { self.Value.Min, self.Value.Max }
end

function RangeSlider:Load(data)
    if type(data) == "table" then self:Set(data[1] or data.Min, data[2] or data.Max) end
end

function RangeSlider:Render(parent, maid)
    local row = Row.new(self, parent, maid, { Below = true })
    local _, low = Slider.ValueBox(row.Right, self, 1, function() return self.Value.Min end, function(number)
        self:Set(number, self.Value.Max, false, "Min")
    end)
    Util.Label({ Text = "–", TextSize = 11, Color = "TextMuted", AutomaticSize = Enum.AutomaticSize.X, Size = UDim2.fromScale(0, 1), LayoutOrder = 2, Parent = row.Right })
    local _, high = Slider.ValueBox(row.Right, self, 3, function() return self.Value.Max end, function(number)
        self:Set(self.Value.Min, number, false, "Max")
    end)

    Util.List(row.Below, 3)
    local track = Slider.Track(row.Below, self, 1)
    local knobLow, scaleLow = Slider.Knob(track.Rail)
    local knobHigh, scaleHigh = Slider.Knob(track.Rail)
    local paintRange = self.Def.ShowRange and Slider.RangeLabels(row.Below, self, 2)

    local dragging = nil
    local function alpha(value)
        local span = self.Max - self.Min
        return span > 0 and (value - self.Min) / span or 0
    end
    local function paint(animate)
        local a, b = alpha(self.Value.Min), alpha(self.Value.Max)
        local time = animate and not dragging and 0.12 or 0
        Util.Tween(track.Fill, time, { Position = UDim2.fromScale(a, 0), Size = UDim2.fromScale(b - a, 1) })
        Util.Tween(knobLow, time, { Position = UDim2.fromScale(a, 0.5) })
        Util.Tween(knobHigh, time, { Position = UDim2.fromScale(b, 0.5) })
        if not low:IsA("TextBox") or not low:IsFocused() then low.Text = self:Text(self.Value.Min) end
        if not high:IsA("TextBox") or not high:IsFocused() then high.Text = self:Text(self.Value.Max) end
    end
    paint(false)
    maid:Give(self.Changed:Connect(function() paint(true) end))
    maid:Give(self.StateChanged:Connect(function(what)
        if what == "Range" then
            paint(false)
            if paintRange then paintRange() end
        end
    end))

    local live = self.Def.Live ~= false
    local function fromPoint(point)
        local bar = track.Bar
        local a = math.clamp((point.X - bar.AbsolutePosition.X) / math.max(bar.AbsoluteSize.X, 1), 0, 1)
        return self.Min + (self.Max - self.Min) * a
    end
    local function move(which, value, silent)
        if which == "Min" then
            self:Set(math.min(value, self.Value.Max), self.Value.Max, silent, "Min")
        else
            self:Set(self.Value.Min, math.max(value, self.Value.Min), silent, "Max")
        end
    end
    track.Bar.InputBegan:Connect(function(input)
        if self.Locked or not Util.IsPress(input) then return end
        local value = fromPoint(Util.Pointer(input))
        local which = math.abs(value - self.Value.Min) <= math.abs(value - self.Value.Max) and "Min" or "Max"
        if self.Value.Min == self.Value.Max then which = value < self.Value.Min and "Min" or "Max" end
        dragging = which
        local scale = which == "Min" and scaleLow or scaleHigh
        Util.Tween(scale, 0.1, { Scale = 1.15 })
        move(which, value, not live)
        Drag.Follow(input, function(point)
            move(which, fromPoint(point), not live)
        end, function()
            dragging = nil
            Util.Tween(scale, 0.12, { Scale = 0.85 })
            if not live then self:_notify() end
        end, track.Bar)
    end)
    if track.Minus then
        track.Minus.MouseButton1Click:Connect(function()
            if not self.Locked then self:Set(self.Value.Min - self.Step, self.Value.Max - self.Step) end
        end)
        track.Plus.MouseButton1Click:Connect(function()
            if not self.Locked then self:Set(self.Value.Min + self.Step, self.Value.Max + self.Step) end
        end)
    end
    return row.Frame
end

return RangeSlider
end

__modules["Elements/Segmented"] = function(...)
local import = ...
local Base = import("Elements/Base")
local Util = import("Core/Util")
local Theme = import("Core/Theme")
local Row = import("Components/Row")

-- one-of-n chips; def: Title, Values, Default, Callback(value)
local Segmented = Base.Class("Segmented")

function Segmented.new(container, def)
    local self = setmetatable({}, Segmented)
    Base.Init(self, container, def)
    self.Options = {}
    for _, value in def.Values or def.Options or {} do table.insert(self.Options, tostring(value)) end
    local default = def.Default or def.Value
    if type(default) == "number" then default = self.Options[default] end
    self.Value = default and tostring(default) or self.Options[1]
    self.Default = self.Value
    return self
end

function Segmented:Set(value, silent)
    value = tostring(value)
    if value == self.Value or not table.find(self.Options, value) then return end
    self:_commit(value, silent)
end

function Segmented:Matches(query)
    if Base.Matches(self, query) then return true end
    for _, option in self.Options do
        if option:lower():find(query, 1, true) then return true end
    end
    return false
end

function Segmented:Render(parent, maid)
    local row = Row.new(self, parent, maid, { Below = true })
    local track = Util.New("Frame", {
        Size = UDim2.new(1, 0, 0, 26),
        Theme = { BackgroundColor3 = "Elevated", BackgroundTransparency = "ElevatedTransparency" },
        Parent = row.Below,
    })
    Util.Corner(6, track)
    Util.Stroke(track)
    Util.Padding(track, 3)
    Util.List(track, 3, Enum.FillDirection.Horizontal)
    local chips = {}
    for index, option in self.Options do
        local chip = { hover = false }
        chip.Button = Util.New("TextButton", {
            Size = UDim2.new(0, 0, 1, 0),
            Text = option,
            TextSize = 11,
            LayoutOrder = index,
            Theme = {
                BackgroundColor3 = function(t) return self.Value == option and t.Accent or t.ElevatedHover end,
                BackgroundTransparency = function() return self.Value == option and 0 or (chip.hover and 0.3 or 1) end,
                TextColor3 = function(t) return self.Value == option and t.OnAccent or t.TextDim end,
                FontFace = Theme.Font(Enum.FontWeight.SemiBold),
            },
            Parent = track,
        })
        Util.Corner(4, chip.Button)
        Util.New("UIFlexItem", { FlexMode = Enum.UIFlexMode.Fill, Parent = chip.Button })
        Util.Hover(chip.Button, function(on) chip.hover = on; Theme.Refresh(chip.Button, 0.1) end)
        chip.Button.MouseButton1Click:Connect(function()
            if not self.Locked then self:Set(option) end
        end)
        table.insert(chips, chip)
    end
    maid:Give(self.Changed:Connect(function()
        for _, chip in chips do Theme.Refresh(chip.Button, 0.15) end
    end))
    return row.Frame
end

return Segmented
end

__modules["Elements/Slider"] = function(...)
local import = ...
local Base = import("Elements/Base")
local Util = import("Core/Util")
local Theme = import("Core/Theme")
local Drag = import("Core/Drag")
local Row = import("Components/Row")
local Menu = import("Components/Menu")

-- def: Title, Min, Max, Default, Step | Rounding, Prefix, Suffix, Format(value) -> text,
--      Input (editable value in the title line, default true), Buttons (- / + steppers),
--      Icons = { From, To } (symbols at both ends), ShowRange (min / max under the track), Live (default true)
local Slider = Base.Class("Slider")

function Slider.new(container, def)
    local self = setmetatable({}, Slider)
    Base.Init(self, container, def)
    self.Min = def.Min or 0
    self.Max = def.Max or 100
    if self.Max < self.Min then self.Min, self.Max = self.Max, self.Min end
    self.Step = def.Step or (def.Rounding and 10 ^ -def.Rounding) or 1
    self.Default = self:_clamp(def.Default or def.Value or self.Min)
    self.Value = self.Default
    return self
end

function Slider:_clamp(value)
    value = tonumber(value) or self.Min
    return math.clamp(Util.Round(value, self.Step), self.Min, self.Max)
end

function Slider:Set(value, silent)
    value = self:_clamp(value)
    if value == self.Value then return end
    self:_commit(value, silent)
end

function Slider:SetMin(min)
    self.Min = min
    self.StateChanged:Fire("Range")
    self:Set(self.Value)
end

function Slider:SetMax(max)
    self.Max = max
    self.StateChanged:Fire("Range")
    self:Set(self.Value)
end

function Slider:Text(value)
    if self.Def.Format then
        local ok, text = pcall(self.Def.Format, value)
        if ok and text then return tostring(text) end
    end
    return (self.Def.Prefix or "") .. Util.Format(value, self.Step) .. (self.Def.Suffix or "")
end

local function stepper(parent, icon, order)
    local button = Util.New("ImageButton", {
        Size = UDim2.fromOffset(16, 16),
        Image = Util.IconId(icon),
        LayoutOrder = order,
        Theme = { ImageColor3 = "TextMuted" },
        Parent = parent,
    })
    Util.Hover(button, function(on) Theme.Bind(button, { ImageColor3 = on and "Text" or "TextMuted" }) end)
    return button
end

-- the track used by Slider and RangeSlider: returns holder, bar, fill
function Slider.Track(parent, element, order)
    local def = element.Def
    local line = Util.New("Frame", {
        Name = "Track",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 16),
        LayoutOrder = order or 1,
        Parent = parent,
    })
    Util.List(line, 6, Enum.FillDirection.Horizontal, nil, Enum.VerticalAlignment.Center)
    local parts = {}
    if def.Buttons then parts.Minus = stepper(line, "minus", 1) end
    if def.Icons and def.Icons.From then
        Util.Icon(def.Icons.From, { Size = UDim2.fromOffset(14, 14), Color = "TextMuted", LayoutOrder = 2, Parent = line })
    end
    local bar = Util.New("TextButton", {
        Name = "Bar",
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 0, 1, 0),
        LayoutOrder = 3,
        Parent = line,
    })
    Util.New("UIFlexItem", { FlexMode = Enum.UIFlexMode.Fill, Parent = bar })
    local rail = Util.New("Frame", {
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.fromScale(0, 0.5),
        Size = UDim2.new(1, 0, 0, 4),
        Theme = { BackgroundColor3 = "Elevated", BackgroundTransparency = function(t) return math.min(t.ElevatedTransparency, 0.3) end },
        Parent = bar,
    })
    Util.Corner(UDim.new(1, 0), rail)
    local fill = Util.New("Frame", {
        Size = UDim2.fromScale(0, 1),
        Theme = { BackgroundColor3 = "Accent" },
        Parent = rail,
    })
    Util.Corner(UDim.new(1, 0), fill)
    Util.New("UIGradient", {
        Theme = { Color = function(t) return ColorSequence.new(t.Accent, t.AccentAlt) end },
        Parent = fill,
    })
    if def.Icons and def.Icons.To then
        Util.Icon(def.Icons.To, { Size = UDim2.fromOffset(14, 14), Color = "TextMuted", LayoutOrder = 4, Parent = line })
    end
    if def.Buttons then parts.Plus = stepper(line, "plus", 5) end
    parts.Line, parts.Bar, parts.Rail, parts.Fill = line, bar, rail, fill
    return parts
end

function Slider.Knob(rail)
    local knob = Util.New("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0, 0.5),
        Size = UDim2.fromOffset(12, 12),
        ZIndex = 2,
        Theme = { BackgroundColor3 = "Text" },
        Parent = rail,
    })
    Util.Corner(UDim.new(1, 0), knob)
    Util.Stroke(knob, "Accent", function() return 0 end, 2)
    local scale = Util.New("UIScale", { Scale = 0.85, Parent = knob })
    return knob, scale
end

function Slider.RangeLabels(parent, element, order)
    local labels = Util.New("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 10),
        LayoutOrder = order,
        Parent = parent,
    })
    local low = Util.Label({ TextSize = 10, Color = "TextMuted", Size = UDim2.fromScale(0.5, 1), Parent = labels })
    local high = Util.Label({ TextSize = 10, Color = "TextMuted", Size = UDim2.fromScale(0.5, 1), Position = UDim2.fromScale(0.5, 0), TextXAlignment = Enum.TextXAlignment.Right, Parent = labels })
    local function paint()
        low.Text = element:Text(element.Min)
        high.Text = element:Text(element.Max)
    end
    paint()
    return paint
end

-- value box in the title line; editable unless Input == false
function Slider.ValueBox(parent, element, order, getValue, onSubmit)
    local field, api = Row.Field(parent, {
        Size = UDim2.fromOffset(0, 20),
        AutomaticSize = Enum.AutomaticSize.X,
        LayoutOrder = order,
        Radius = 5,
    })
    Util.Padding(field, 0, 7, 0, 7)
    Util.New("UISizeConstraint", { MinSize = Vector2.new(34, 20), Parent = field })
    local editable = element.Def.Input ~= false
    local box = Util.New(editable and "TextBox" or "TextLabel", {
        AutomaticSize = Enum.AutomaticSize.X,
        Size = UDim2.fromScale(0, 1),
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Center,
        BackgroundTransparency = 1,
        Theme = { TextColor3 = "Text", FontFace = Theme.Font(Enum.FontWeight.SemiBold) },
        Parent = field,
    })
    if editable then
        box.ClearTextOnFocus = false
        box.Focused:Connect(function()
            api.SetFocused(true)
            box.Text = Util.Format(getValue(), element.Step)
            box.SelectionStart = 1
            box.CursorPosition = #box.Text + 1
        end)
        box.FocusLost:Connect(function()
            api.SetFocused(false)
            local number = Util.ParseNumber(box.Text)
            if number and not element.Locked then onSubmit(number) end
            box.Text = element:Text(getValue())
        end)
    end
    box.Text = element:Text(getValue())
    return field, box
end

function Slider:Render(parent, maid)
    local row = Row.new(self, parent, maid, { Below = true })
    local _, box = Slider.ValueBox(row.Right, self, 1, function() return self.Value end, function(number) self:Set(number) end)

    local below = row.Below
    Util.List(below, 3)
    local track = Slider.Track(below, self, 1)
    local knob, knobScale = Slider.Knob(track.Rail)
    local paintRange = self.Def.ShowRange and Slider.RangeLabels(below, self, 2)

    local dragging = false
    local function paint(animate)
        local span = self.Max - self.Min
        local alpha = span > 0 and (self.Value - self.Min) / span or 0
        local time = animate and not dragging and 0.12 or 0
        Util.Tween(track.Fill, time, { Size = UDim2.fromScale(alpha, 1) })
        Util.Tween(knob, time, { Position = UDim2.fromScale(alpha, 0.5) })
        if not box:IsA("TextBox") or not box:IsFocused() then box.Text = self:Text(self.Value) end
    end
    paint(false)
    maid:Give(self.Changed:Connect(function() paint(true) end))
    maid:Give(self.StateChanged:Connect(function(what)
        if what == "Range" then
            paint(false)
            if paintRange then paintRange() end
        end
    end))

    local live = self.Def.Live ~= false
    local function fromPoint(point)
        local bar = track.Bar
        local alpha = math.clamp((point.X - bar.AbsolutePosition.X) / math.max(bar.AbsoluteSize.X, 1), 0, 1)
        return self.Min + (self.Max - self.Min) * alpha
    end
    track.Bar.InputBegan:Connect(function(input)
        if self.Locked then return end
        if input.UserInputType == Enum.UserInputType.MouseButton2 then
            Menu.Open({
                Point = Util.Pointer(input),
                Width = 150,
                Items = {
                    { Title = "Reset to default", Icon = "rotate-ccw", Hint = self:Text(self.Default), Callback = function() self:Set(self.Default) end },
                    { Title = "Set to min", Icon = "chevron-left", Callback = function() self:Set(self.Min) end },
                    { Title = "Set to max", Icon = "chevron-right", Callback = function() self:Set(self.Max) end },
                },
            })
            return
        end
        if not Util.IsPress(input) then return end
        dragging = true
        Util.Tween(knobScale, 0.1, { Scale = 1.15 })
        self:Set(fromPoint(Util.Pointer(input)), not live)
        Drag.Follow(input, function(point)
            self:Set(fromPoint(point), not live)
        end, function()
            dragging = false
            Util.Tween(knobScale, 0.12, { Scale = 0.85 })
            if not live then self:_notify() end
        end, track.Bar)
    end)
    Util.Hover(track.Bar, function(on) if not dragging then Util.Tween(knobScale, 0.1, { Scale = on and 1 or 0.85 }) end end)
    if track.Minus then
        track.Minus.MouseButton1Click:Connect(function() if not self.Locked then self:Set(self.Value - self.Step) end end)
        track.Plus.MouseButton1Click:Connect(function() if not self.Locked then self:Set(self.Value + self.Step) end end)
    end
    return row.Frame
end

return Slider
end

__modules["Elements/Spacer"] = function(...)
local import = ...
local Base = import("Elements/Base")
local Util = import("Core/Util")

-- def: Height (px, default 6)
local Spacer = Base.Class("Spacer")

function Spacer.new(container, def)
    local self = setmetatable({}, Spacer)
    Base.Init(self, container, def)
    self.NoSave = true
    return self
end

function Spacer:Matches()
    return false
end

function Spacer:Render(parent, maid)
    return maid:Give(Util.New("Frame", {
        Name = "Spacer",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, self.Def.Height or 6),
        Parent = parent,
    }))
end

return Spacer
end

__modules["Elements/Toggle"] = function(...)
local import = ...
local Base = import("Elements/Base")
local Row = import("Components/Row")
local Widgets = import("Components/Widgets")
local Binding = import("Core/Binding")
local Input = import("Elements/Input")
local ColorPicker = import("Elements/ColorPicker")

-- def: Title, Description, Default, Style ("Switch" | "Checkbox"), Keybind (true | key | { Key, Mode }),
--      Field (a value box in the same row, set while off too: Input options plus Width),
--      Color (a colour swatch in the same row: ColorPicker options with their own Flag), Listed,
--      Notify (a notification on every on / off, replaced while it shows), Callback(value)
local Toggle = Base.Class("Toggle")

function Toggle.new(container, def)
    local self = setmetatable({}, Toggle)
    Base.Init(self, container, def)
    self.Default = (def.Default or def.Value) == true
    self.Value = self.Default
    self.Style = def.Style or "Switch"
    if def.Keybind then
        local spec = type(def.Keybind) == "table" and def.Keybind or { Key = def.Keybind ~= true and def.Keybind or nil }
        self.Binding = Binding.new({
            Key = spec.Key or spec.Default,
            Mode = spec.Mode,
            Modes = spec.Modes or { "Toggle", "Hold" },
            Capture = spec,
            Press = function(binding)
                if self.Locked then return end
                self:Set(binding.Mode == "Hold" or not self.Value)
            end,
            Release = function(binding)
                if binding.Mode == "Hold" and not self.Locked then self:Set(false) end
            end,
        })
        self.Binding.Changed:Connect(function() self.Window:_touch(true) end)
        self.Window:_trackBind(self)
    end
    if def.Field then
        -- its own element model: own Flag, callback, validation; toggle.Field:Get() reads it
        local spec = table.clone(def.Field)
        spec.Title = spec.Title or self.Title
        self.Field = Input.new(container, spec)
    end
    if def.Color then
        local spec = table.clone(def.Color)
        spec.Title = spec.Title or (self.Title .. " colour")
        self.Color = ColorPicker.new(container, spec)
    end
    return self
end

function Toggle:Reset()
    Base.Reset(self)
    if self.Field then self.Field:Reset() end
    if self.Color then self.Color:Reset() end
end

function Toggle:Destroy()
    if self.Field then self.Field:Destroy() end
    if self.Color then self.Color:Destroy() end
    Base.Destroy(self)
end

function Toggle:Set(value, silent)
    value = value and true or false
    if value == self.Value then return end
    self:_commit(value, silent)
    if self.Def.Notify and not silent then self.Window:_toggleNote(self, value) end
end

function Toggle:Save()
    if self.Binding then return { Value = self.Value, Bind = self.Binding:Save() } end
    return self.Value
end

function Toggle:Load(data)
    if type(data) == "table" then
        if self.Binding and data.Bind then self.Binding:Load(data.Bind) end
        self:Set(data.Value)
    else
        self:Set(data)
    end
end

function Toggle:BindInfo()
    return self.Title, self.Value
end

function Toggle:Render(parent, maid)
    local row = Row.new(self, parent, maid, { Click = true })
    if self.Field then
        self.Field:RenderInline(row.Right, maid, { Width = self.Def.Field.Width, LayoutOrder = 0 })
    end
    if self.Color then self.Color:RenderInline(row.Right, maid, { LayoutOrder = 1 }) end
    if self.Binding then
        local _, connection = Widgets.KeyPill(row.Right, self.Binding, { LayoutOrder = 2 })
        maid:Give(connection)
    end
    local _, paint = (self.Style == "Checkbox" and Widgets.Checkbox or Widgets.Switch)(row.Right, { LayoutOrder = 3 })
    paint(self.Value, false)
    maid:Give(self.Changed:Connect(function(value) paint(value, true) end))
    row.Button.MouseButton1Click:Connect(function()
        if not self.Locked then self:Set(not self.Value) end
    end)
    return row.Frame
end

return Toggle
end

__modules["Themes/Presets"] = function(...)
local _ = ...

-- palettes only hold colours; style tokens (radius, font, transparency, ...) live in Core/Theme
local rgb = Color3.fromRGB

local function palette(p)
    return {
        Accent        = p.Accent,
        AccentAlt     = p.AccentAlt,
        Background    = p.Background,
        BackgroundAlt = p.BackgroundAlt,
        Surface       = p.Surface,
        SurfaceHover  = p.SurfaceHover,
        Elevated      = p.Elevated,
        ElevatedHover = p.ElevatedHover,
        Stroke        = p.Stroke,
        Divider       = p.Divider,
        Text          = p.Text or rgb(232, 233, 240),
        TextDim       = p.TextDim or rgb(152, 154, 168),
        TextMuted     = p.TextMuted or rgb(98, 100, 114),
        OnAccent      = p.OnAccent or rgb(255, 255, 255),
        Success       = p.Success or rgb(74, 200, 122),
        Warning       = p.Warning or rgb(244, 182, 62),
        Danger        = p.Danger or rgb(236, 88, 88),
    }
end

return {
    Order = { "Sapphire", "Obsidian", "Midnight", "Ocean", "Emerald", "Amber", "Crimson", "Rose", "Paper" },

    Sapphire = palette({
        Accent = rgb(78, 132, 255), AccentAlt = rgb(140, 205, 255),
        Background = rgb(6, 6, 9), BackgroundAlt = rgb(36, 38, 46),
        Surface = rgb(12, 12, 16), SurfaceHover = rgb(20, 20, 26),
        Elevated = rgb(24, 25, 32), ElevatedHover = rgb(33, 34, 43),
        Stroke = rgb(88, 92, 110), Divider = rgb(52, 54, 66),
    }),

    -- greyscale
    Obsidian = palette({
        Accent = rgb(222, 222, 228), AccentAlt = rgb(120, 120, 130),
        Background = rgb(5, 5, 6), BackgroundAlt = rgb(48, 48, 52),
        Surface = rgb(11, 11, 12), SurfaceHover = rgb(20, 20, 22),
        Elevated = rgb(24, 24, 27), ElevatedHover = rgb(34, 34, 38),
        Stroke = rgb(92, 92, 100), Divider = rgb(55, 55, 60),
        OnAccent = rgb(12, 12, 14),
    }),

    Midnight = palette({
        Accent = rgb(146, 112, 255), AccentAlt = rgb(206, 172, 255),
        Background = rgb(8, 7, 14), BackgroundAlt = rgb(34, 26, 58),
        Surface = rgb(14, 12, 24), SurfaceHover = rgb(22, 19, 36),
        Elevated = rgb(27, 23, 44), ElevatedHover = rgb(37, 32, 58),
        Stroke = rgb(96, 84, 140), Divider = rgb(55, 48, 84),
        Text = rgb(236, 232, 248), TextDim = rgb(160, 152, 186), TextMuted = rgb(104, 97, 132),
    }),

    Ocean = palette({
        Accent = rgb(38, 192, 232), AccentAlt = rgb(132, 232, 255),
        Background = rgb(4, 8, 11), BackgroundAlt = rgb(16, 36, 48),
        Surface = rgb(9, 15, 20), SurfaceHover = rgb(15, 24, 31),
        Elevated = rgb(19, 30, 39), ElevatedHover = rgb(26, 40, 52),
        Stroke = rgb(70, 104, 124), Divider = rgb(40, 60, 74),
        OnAccent = rgb(4, 16, 22),
    }),

    Emerald = palette({
        Accent = rgb(62, 204, 134), AccentAlt = rgb(156, 242, 194),
        Background = rgb(5, 9, 8), BackgroundAlt = rgb(18, 40, 31),
        Surface = rgb(9, 15, 13), SurfaceHover = rgb(15, 24, 21),
        Elevated = rgb(19, 30, 26), ElevatedHover = rgb(26, 40, 35),
        Stroke = rgb(70, 112, 96), Divider = rgb(40, 64, 55),
        OnAccent = rgb(4, 20, 12),
    }),

    Amber = palette({
        Accent = rgb(246, 172, 52), AccentAlt = rgb(255, 222, 134),
        Background = rgb(10, 8, 5), BackgroundAlt = rgb(42, 31, 16),
        Surface = rgb(16, 13, 9), SurfaceHover = rgb(25, 21, 15),
        Elevated = rgb(31, 26, 19), ElevatedHover = rgb(42, 35, 25),
        Stroke = rgb(118, 98, 66), Divider = rgb(66, 55, 38),
        OnAccent = rgb(24, 16, 4),
    }),

    Crimson = palette({
        Accent = rgb(232, 62, 82), AccentAlt = rgb(255, 144, 122),
        Background = rgb(10, 6, 7), BackgroundAlt = rgb(44, 18, 23),
        Surface = rgb(16, 10, 12), SurfaceHover = rgb(26, 16, 19),
        Elevated = rgb(32, 20, 24), ElevatedHover = rgb(44, 28, 33),
        Stroke = rgb(122, 72, 82), Divider = rgb(70, 40, 46),
    }),

    Rose = palette({
        Accent = rgb(242, 112, 172), AccentAlt = rgb(255, 184, 216),
        Background = rgb(10, 6, 9), BackgroundAlt = rgb(44, 20, 36),
        Surface = rgb(16, 10, 15), SurfaceHover = rgb(26, 16, 24),
        Elevated = rgb(32, 20, 30), ElevatedHover = rgb(44, 28, 41),
        Stroke = rgb(122, 76, 108), Divider = rgb(70, 42, 62),
    }),

    Paper = palette({
        Accent = rgb(52, 104, 242), AccentAlt = rgb(116, 168, 255),
        Background = rgb(238, 240, 245), BackgroundAlt = rgb(255, 255, 255),
        Surface = rgb(255, 255, 255), SurfaceHover = rgb(246, 247, 251),
        Elevated = rgb(236, 238, 244), ElevatedHover = rgb(226, 229, 238),
        Stroke = rgb(176, 182, 198), Divider = rgb(214, 218, 228),
        Text = rgb(24, 26, 34), TextDim = rgb(92, 98, 116), TextMuted = rgb(146, 152, 168),
    }),
}
end

__modules["init"] = function(...)
local import = ...
local Maid = import("Core/Maid")
local Signal = import("Core/Signal")
local Theme = import("Core/Theme")
local Util = import("Core/Util")
local Keybinds = import("Core/Keybinds")
local Storage = import("Core/Storage")
local Layer = import("Components/Layer")
local Popup = import("Components/Popup")
local Tooltip = import("Components/Tooltip")
local Notification = import("Components/Notification")

local Library = {
    Version = "dev",
    Flags = {},
    Windows = {},
    Theme = Theme,
    Icons = Util.Icons,
    Storage = Storage,
    Util = Util,
    Unloaded = Signal.new(),
    Maid = Maid.new(),
}
Library.Options = Library.Flags

local function registry()
    local env = type(getgenv) == "function" and getgenv() or _G
    env.__OasisUI = env.__OasisUI or {}
    return env.__OasisUI
end

-- def: see Components/Window
function Library:CreateWindow(def)
    def = def or {}
    if not self._started then
        self._started = true
        local name = def.GuiName or "OasisUI"
        -- a previous run with the same gui name gets unloaded first
        local previous = registry()[name]
        if previous then pcall(previous) end
        registry()[name] = function() self:Unload() end
        self._name = name
        Layer.Init(self.Maid, name)
        Keybinds.Start(self.Maid)
        self.Maid:Give(task.spawn(function()
            while true do
                task.wait(20)
                Theme.Sweep()
            end
        end))
    end
    local window = import("Components/Window").new(self, def)
    table.insert(self.Windows, window)
    return window
end

-- options: Title, Content, Type (Info | Success | Warning | Error), Icon, Duration, Buttons
function Library:Notify(options)
    if not self._started then
        warn("[OasisUI] create a window before notifying")
        return nil
    end
    return Notification.Notify(options)
end

function Library:SetTheme(name)
    return Theme.UsePalette(name)
end

function Library:SetAccent(color)
    Theme.Set({ Accent = color })
end

function Library:SetThemeValues(patch)
    Theme.Set(patch)
end

function Library:AddIcons(map)
    for name, id in map do Util.Icons[name] = id end
end

function Library:GetFlag(flag)
    local element = self.Flags[flag]
    return element and element:Get()
end

function Library:SetFlag(flag, value)
    local element = self.Flags[flag]
    if element then element:Set(value) end
end

-- a bind is waiting for its key: keys pressed now belong to it
function Library:IsCapturing()
    return Keybinds.Capturing
end

function Library:Toggle()
    for _, window in self.Windows do window:Toggle() end
end

Library.Destroy = function(self) self:Unload() end

function Library:OnUnload(fn)
    return self.Unloaded:Connect(fn)
end

function Library:Unload()
    if self.IsUnloaded then return end
    self.IsUnloaded = true
    Popup.CloseAll()
    Tooltip.Hide()
    for _, window in self.Windows do window:Destroy() end
    table.clear(self.Windows)
    self.Maid:Clean()
    Theme.Sweep()
    if self._name and registry()[self._name] then registry()[self._name] = nil end
    self.Unloaded:Fire()
end

return Library
end

local Library = import("init")
Library.Version = "1.7.0"
return Library
