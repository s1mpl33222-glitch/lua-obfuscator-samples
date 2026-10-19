
local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/scripter-sm/EliteZone/main/Dependencies/libraries/gui_library.lua'))();

local Window = Library:CreateWindow({
	Title = 'Elite Zone - v3.9';
	Game = 'Rivals'; 
	Center = true;
	AutoShow = true;
});

local Tab = Window:AddTab('main');

Library.SaveManager:IgnoreThemeSettings();

Library.ThemeManager:ApplyToWindow(Window);
Library.SaveManager:BuildConfigTab(Window);
Library.SaveManager:LoadAutoloadConfig();
