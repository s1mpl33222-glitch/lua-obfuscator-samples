-- modules/tab_adapter.lua
-- declarative layout and tab constructor for the MDuiLib window

local TabAdapter = {}

TabAdapter.tabDefinitions = {
    { id = "Main",       title = "Main",       order = 1,  icon = "home" },
    { id = "Autofarm",   title = "Autofarm",   order = 3,  icon = "coins" },
    { id = "Player",     title = "Player",     order = 5,  icon = "user" },
    { id = "Murderer",   title = "Murderer",   order = 7,  icon = "skull" },
    { id = "Sheriff",    title = "Sheriff",    order = 9,  icon = "shield" },
    { id = "Sounds",     title = "Sounds",     order = 11, icon = "volume-2" },
    { id = "Visuals",    title = "Visuals",    order = 13, icon = "eye" },
    { id = "Animations", title = "Animations", order = 15, icon = "activity" },
    { id = "World",      title = "World",      order = 17, icon = "globe" },
    { id = "Camera",     title = "Camera",     order = 19, icon = "camera" },
    { id = "Webhook",    title = "Webhook",    order = 21, icon = "send" },
}

TabAdapter.dividerLayout = {
    big = { 2, 12 },
    small = { 4, 6, 8, 10, 14, 16, 18, 20 },
}

function TabAdapter.createTabs(window)
    local tabs = {}
    for _, def in ipairs(TabAdapter.tabDefinitions) do
        tabs[def.id] = window:CreateTab(def.title, def.order, def.icon)
    end

    if window.GetSettingsTab then
        tabs.Settings = window:GetSettingsTab()
    elseif window.SettingsTab then
        tabs.Settings = window.SettingsTab
    else
        tabs.Settings = window:CreateTab("Settings", 999, "settings")
    end

    for _, order in ipairs(TabAdapter.dividerLayout.big) do
        if window.AddSidebarBigDivider then
            window:AddSidebarBigDivider(order)
        end
    end

    for _, order in ipairs(TabAdapter.dividerLayout.small) do
        if window.AddSidebarSmallDivider then
            window:AddSidebarSmallDivider(order)
        end
    end

    return tabs
end

return TabAdapter
