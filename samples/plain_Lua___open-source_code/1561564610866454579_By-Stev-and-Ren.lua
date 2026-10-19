-- deobfucador por papi ren
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local MarketplaceService = game:GetService("MarketplaceService")
local HttpService = game:GetService("HttpService")
local workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")
local SoundService = game:GetService("SoundService")
local LocalPlayer = Players.LocalPlayer

-- Copiar invitación de Discord al portapapeles al ejecutar
pcall(function()
    if setclipboard then
        setclipboard("https://discord.gg/eNv3TVMxP3")
    end
end)
while not LocalPlayer do
task.wait()
LocalPlayer = Players.LocalPlayer
end
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()
local _0xf7de2a = false
local _0x6a47b7 = 120
local _0x94448f = false
local _0x75a1de = false
local _0x7b80fa = false
local _0xdbaa3a = false
local TargetPart = "Cabeza"
local _0x7cab60 = true
local _0xd33699 = false
local _0xd9b476 = Color3.fromRGB(255, 255, 255)
local _0x8607ac = { Glow = true }
local _0xa6311d = false
local _0x7f7318 = false
local _0x0bf5a7 = false
local _0xf0b050 = false
local _0x0d5e57 = 3.5
local _0xcbf13d = Color3.fromRGB(255, 0, 0)
local _0xad3c4e = 2.2
local _0x893535 = 2.8
local _0x26be35 = 1.8
local _0x96c97d = nil
local _0xfe084f = nil
local _0x5f9fd6 = {}
local _0x0cd7ab = {}
local _0x1eaab4 = {}
local _0x957a62 = false
local Keybinds = {
ToggleUI = "RightControl",
}
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NexvyrHub_Overlays"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 999
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
local ESPFolder = Instance.new("Folder")
ESPFolder.Name = "NexvyrESPFolder"
ESPFolder.Parent = ScreenGui
local function _0x9659b1(_0x77bc10, _0x9a05a4, _0xffad7f)
local _0xad1116, _0xd3ad2c, _0x46e012, _0xdc1fe7, _0xfe8b69 = false, nil, nil, nil, false
local function _0x67759b(_0xa62cbd)
return _0xa62cbd.UserInputType == Enum.UserInputType.MouseButton1 or _0xa62cbd.UserInputType == Enum.UserInputType.Touch
end
_0x77bc10.InputBegan:Connect(function(_0xa62cbd)
if not _0x67759b(_0xa62cbd) then return end
_0xad1116 = true; _0xfe8b69 = false; _0x46e012 = _0xa62cbd.Position; _0xdc1fe7 = _0x9a05a4.Position
end)
_0x77bc10.InputChanged:Connect(function(_0xa62cbd)
if _0xa62cbd.UserInputType == Enum.UserInputType.MouseMovement or _0xa62cbd.UserInputType == Enum.UserInputType.Touch then _0xd3ad2c = _0xa62cbd end
end)
UserInputService.InputChanged:Connect(function(_0xa62cbd)
if _0xa62cbd ~= _0xd3ad2c or not _0xad1116 then return end
local _0xe69174 = _0xa62cbd.Position - _0x46e012
if _0xe69174.Magnitude > 6 then _0xfe8b69 = true end
if _0xfe8b69 then
_0x9a05a4.Position = UDim2.new(_0xdc1fe7.X.Scale, _0xdc1fe7.X.Offset + _0xe69174.X, _0xdc1fe7.Y.Scale, _0xdc1fe7.Y.Offset + _0xe69174.Y)
end
end)
UserInputService.InputEnded:Connect(function(_0xa62cbd)
if not _0x67759b(_0xa62cbd) or not _0xad1116 then return end
_0xad1116 = false
if not _0xfe8b69 and _0xffad7f then _0xffad7f() end
end)
end
local _0x918d1a = Instance.new("Frame")
_0x918d1a.Name = "NexvyrMinimalNotifs"
_0x918d1a.Size = UDim2.new(0, 300, 0.5, 0)
_0x918d1a.AnchorPoint = Vector2.new(1, 1)
_0x918d1a.Position = UDim2.new(1, -20, 1, -20)
_0x918d1a.BackgroundTransparency = 1
_0x918d1a.Parent = ScreenGui
local _0x137e14 = Instance.new("UIListLayout", _0x918d1a)
_0x137e14.VerticalAlignment = Enum.VerticalAlignment.Bottom
_0x137e14.HorizontalAlignment = Enum.HorizontalAlignment.Right
_0x137e14.SortOrder = Enum.SortOrder.LayoutOrder
_0x137e14.Padding = UDim.new(0, 8)
local function _0xfd368d(_0xdf9ec2)
if not _0x957a62 then return end
end
local _0x801a2b
local _0xb4d4ff = "1.6.66"
local _0xea7fc4 = "WindUI_Cache_v" .. _0xb4d4ff .. ".txt"
local _0xa025f7 = "WindUI_Cache_v" .. _0xb4d4ff .. "_Time.txt"
local _0x565115, _0xb4721d = pcall(function()
local _0x548c1f = false
if isfile and isfile(_0xa025f7) and readfile then
local _0xff132f = tonumber(readfile(_0xa025f7))
if _0xff132f and (os.time() - _0xff132f) < 86400 then _0x548c1f = true end
end
if _0x548c1f and isfile and isfile(_0xea7fc4) then
return loadstring(readfile(_0xea7fc4))()
else
local _0x0e1dd3 = game:HttpGet("https://github.com/Footagesus/WindUI/releases/download/" .. _0xb4d4ff .. "/main.lua")
if writefile then
writefile(_0xea7fc4, _0x0e1dd3)
writefile(_0xa025f7, tostring(os.time()))
end
return loadstring(_0x0e1dd3)()
end
end)
if _0x565115 and _0xb4721d then _0x801a2b = _0xb4721d else warn("Error al cargar WindUI: " .. tostring(_0xb4721d)); return end
local _0x15aaf5 = {
English = {
tab_home="Home",tab_aim="Aimbot",tab_vis="Visuals",tab_farm="AutoFarm",tab_killall="Kill All",tab_racha="Streak Farm",
tab_gfx="Graphics",tab_anim="Animations",tab_music="Music",tab_bg="Backgrounds",tab_emotes="Emotes",tab_items="Items",
tab_com="Community",tab_owners="Owners",tab_warn="Warnings",tab_update="Update",
sec_main="Main Functions",sec_extra="Configs & Extra",sec_owners="Owners",sec_profile="Player Profile",
sec_settings="Settings",sec_server="Server Information",sec_games="Supported Games",sec_autoshoot="Auto Shoot",
sec_silentaim="Silent Aim + Fov",sec_killall="Kill All",sec_hitbox="Hitbox Expander",sec_autotp="Auto Teleport Main/Alt",
sec_esp_cfg="ESP Configuration",sec_esp_filters="ESP Filters",sec_farm_event="Event Farming",sec_visuals="Visual Modes",
sec_night="Night Mode",sec_perf="Performance",sec_anim_bundles="Full Bundles",sec_anim_mixer="Animation Mixer",
sec_now_playing="Now Playing",sec_controls="Controls",sec_music_pick="Select Music",sec_music_prefs="Playback Preferences",
sec_music_ids="Music IDs",sec_theme="Interface Theme",sec_emotes_list="Available Emotes",sec_emotes_ids="Emote IDs",
sec_items="Items",sec_com="Community",sec_warning="Warning",sec_team="Nexvyr's Team",sec_updates="Updates",
sec_changes="Changes",sec_warn_update="Warning",sec_keybinds="Keybinds",
profile_user="User",profile_id="ID",profile_age="Account age",profile_days="days",profile_system="System",
profile_exec="Current executor",profile_community="Community",profile_actives="Actives",profile_game="Current Game",
profile_placeid="Place ID",
game_mm2="Murder Mystery 2",game_duels="Murderers VS Sheriffs (Duels)",game_mmv="Murder Mystery V (MMV)",
aim_autoshoot="Auto Shoot (Normal - Head/Torso)",aim_autoshoot_desc="Automatically shoots at torso or head without missing.",
aim_agresivo="Auto Shoot (Aggressive - Full Hitbox)",aim_agresivo_desc="Shoots any visible pixel of the enemy's body.",
aim_silent="Silent Aim",aim_silent_desc="Redirects bullets to the enemy.",aim_target="Target: Body part",
aim_silent_fov="Silent Aim (With FOV)",aim_silent_fov_desc="Same as Silent Aim, but only affects enemies inside the circle.",
aim_show_fov="Show FOV Circle",aim_show_fov_desc="Draws a circle on screen.",aim_fov_size="FOV Size",
ka_title="Kill All Enemies",ka_desc="Patched :'v",ka_always="Keep Kill All Always On",
ka_always_desc="Forces Kill All to stay on and locks its toggle.",ka_bubble="Kill All Bubble",
ka_bubble_desc="Shows a floating 'KA' button on screen.",
hit_activate="Activate Hitbox",hit_activate_desc="Adds a rectangular hitbox to enemies.",
hit_invisible="Invisible Hitbox",hit_invisible_desc="Makes the hitbox completely transparent.",
hit_size="Hitbox Size",hit_color="Hitbox Color",
atp_main="Auto Teleport (Main)",atp_main_desc="Teleports you to the Main platform. Disables if you enable Alt.",
atp_alt="Auto Teleport (Alt)",atp_alt_desc="Teleports you to the Alt platform. Disables if you enable Main.",
atp_type="Duel Type",atp_row="Platform Row",
rs_break="Break Streak",rs_break_desc="Breaks the streak of players that exceed the target.",
rs_target="Break Streak Target",rs_lower="Lower KD",rs_lower_desc="Lowers your KD by killing players with few kills.",
rs_kd="KD Target Kills",
esp_toggle="Player ESP",esp_color="ESP Color",esp_glow="Show Glow",esp_lines="Show Lines",
farm_event="Auto Farm Event",
gfx_sunset="Sunset",gfx_sunset_int="Sunset Intensity",gfx_sunset_int_desc="How much the sun and its rays shine",
gfx_sunset_clar="Sunset Clarity",gfx_sunset_clar_desc="If it looks too dark, raise it",
gfx_night="Cloudy Night + Glow",gfx_night_desc="Night sky, but the map is lit like full moon",
gfx_night_glow="Glow Intensity",gfx_night_glow_desc="How much lights shine",
gfx_night_clar="Map Clarity",gfx_night_clar_desc="If you see it dark, raise it",
gfx_fps="FPS Boost (Removes textures)",
anim_bundle="Choose Bundle",anim_apply="Apply Full Bundle",anim_restore="Restore Default",
anim_idle="Idle",anim_walk="Walk",anim_run="Run",anim_jump="Jump",anim_fall="Fall",anim_climb="Climb",
anim_combine="Combine and Apply",anim_none="None",
music_now_none="No song selected",music_now_desc="Press Play to start",
music_prev="Previous",music_prev_desc="Go back to the previous song",
music_next="Next",music_next_desc="Skip to the next song",
music_play="Play",music_play_desc="Start or resume current song",
music_pause="Pause",music_pause_desc="Pause playback without losing progress",
music_stop="Stop",music_stop_desc="Cuts music completely",
music_song="Song",music_song_desc="Pick a song from the list to play it",
music_shuffle="Shuffle Playback",music_shuffle_desc="Picks a random song each time it advances",
music_repeat="Repeat Song",music_repeat_desc="Replays the same song when it ends",
music_vol="Volume",music_vol_desc="Adjusts how loud the music plays",
music_name="Song Name",music_name_ph="E.g.: My song",
music_id="Roblox ID (rbxassetid)",music_id_ph="E.g.: 1234567890",
music_add="Add Song",music_add_desc="Saves the name and ID above to the list",
music_playing="Playing",music_paused="Paused",
bg_select="Select Background",bg_apply="Apply",bg_theme="Select Theme",bg_theme_desc="Changes the color theme of WindUI",
emote_pick="Emote",emote_pick_desc="Pick an emote for your character (requires R15 avatar)",
emote_play="Play Emote",emote_play_desc="Plays the selected emote on your character",
emote_stop="Stop Emote",emote_stop_desc="Stops the current emote",
emote_name="Emote Name",emote_name_ph="E.g.: My emote",
emote_id="Roblox ID (rbxassetid)",emote_id_ph="E.g.: 1234567890",
emote_loop="Loop",emote_loop_desc="Enable only if the emote is a dance made to loop",
emote_add="Add Emote",emote_add_desc="Saves the name, ID and loop type to the list",
items_korblox="Apply Korblox",items_korblox_desc="Applies or removes Korblox legs",
com_whatsapp="WhatsApp Group",com_link_copied="Link Copied!",
com_link_text="Open WhatsApp and paste the link to join the group.",
com_discord_title="Join our Discord",
com_discord_desc="Click the button below to copy the invite link.",
com_discord_button="Copy Discord Invite",
ui_keybind="Toggle UI Keybind",
ui_keybind_reset="Reset Toggle UI Keybind",
ui_keybind_reset_desc="Reset this keybind to its default value.",
warn_staff="NexvyrHub staff is not responsible if you get banned from the game.",warn_updates="Updates every week",
owner_title="NEXVYR",owner_desc="[Owner] 7.dui\n\nMain creator and programmer responsible.",
admin_title="SAMXHQQ",admin_desc="[Admin] samxh\n\nGraphic designer and idea creator.",
helper_title="XIN",helper_desc="[Helper] AminVega\n\nScript testing assistant.",
support_title="ANTOX",support_desc="[Support] Antox\n\nAdministration keeping everything in order.",
thanks_title="Thanks for using Nexvyr-Hub",
thanks_desc="Your support motivates us to keep improving.\n\nFollow us for more updates!",
upd_next="Next update",upd_date="Date: 1/10/2026",upd_changes1="+ 3 improvements to tabs.",
upd_changes2="+ AutoShoot fixed",upd_changes3="+ 4 new backgrounds",
upd_warn1="Kill All is temporarily locked.",
upd_warn2="Report any errors or bugs in the WhatsApp group to fix them as quickly as possible.",
language="Language",lang_changed="Language changed to %s.",
},
Espanol = {
tab_home="Inicio",tab_aim="Aimbot",tab_vis="Visuales",tab_farm="AutoFarm",tab_killall="Kill All",tab_racha="Racha Farm",
tab_gfx="GrÃ¡ficos",tab_anim="Animaciones",tab_music="MÃºsica",tab_bg="Fondos",tab_emotes="Emotes",tab_items="Items",
tab_com="Comunidad",tab_owners="Owners",tab_warn="Avisos",tab_update="Update",
sec_main="Funciones Principales",sec_extra="Configs & Extra",sec_owners="Owners",sec_profile="Perfil del Jugador",
sec_settings="Ajustes",sec_server="InformaciÃ³n del Servidor",sec_games="Juegos Soportados",sec_autoshoot="Auto Shoot",
sec_silentaim="Silent Aim + Fov",sec_killall="Kill All",sec_hitbox="Hitbox Expander",sec_autotp="Auto Teleport Main/Alt",
sec_esp_cfg="ConfiguraciÃ³n de ESP",sec_esp_filters="Filtros de ESP",sec_farm_event="Farmeo de Evento",
sec_visuals="Modos Visuales",sec_night="Modo Noche",sec_perf="Rendimiento",
sec_anim_bundles="Paquetes Completos",sec_anim_mixer="Mezclador de Animaciones",
sec_now_playing="Ahora suena",sec_controls="Controles",sec_music_pick="Seleccionar mÃºsica",
sec_music_prefs="Preferencias de reproducciÃ³n",sec_music_ids="IDs de mÃºsica",
sec_theme="Tema de la Interfaz",sec_emotes_list="Emotes disponibles",sec_emotes_ids="IDs de emotes",
sec_items="Items",sec_com="Comunidad",sec_warning="Aviso",sec_team="Equipo Nexvyr's",
sec_updates="Actualizaciones",sec_changes="Cambios",sec_warn_update="Aviso",sec_keybinds="Teclas",
profile_user="Usuario",profile_id="ID",profile_age="Edad de la cuenta",profile_days="dÃ­as",profile_system="Sistema",
profile_exec="Ejecutor actual",profile_community="Comunidad",profile_actives="Activos",profile_game="Juego Actual",
profile_placeid="Place ID",
game_mm2="Murder Mystery 2",game_duels="Murderers VS Sheriffs (Duels)",game_mmv="Murder Mystery V (MMV)",
aim_autoshoot="Auto Shoot (Normal - Cabeza/Torso)",aim_autoshoot_desc="Dispara automÃ¡ticamente al torso o cabeza sin fallar.",
aim_agresivo="Auto Shoot (Agresivo - Hitbox Completa)",aim_agresivo_desc="Dispara a cualquier pÃ­xel visible del cuerpo del enemigo.",
aim_silent="Silent Aim",aim_silent_desc="Redirige las balas al enemigo.",aim_target="Target: Parte del cuerpo",
aim_silent_fov="Silent Aim (Con FOV)",aim_silent_fov_desc="Igual que el Silent Aim, pero solo afecta a los enemigos dentro del cÃ­rculo.",
aim_show_fov="Mostrar CÃ­rculo FOV",aim_show_fov_desc="Dibuja un cÃ­rculo en pantalla.",aim_fov_size="TamaÃ±o del FOV",
ka_title="Kill All Enemies",ka_desc="Parchado :'v",ka_always="Keep Kill All Always On",
ka_always_desc="Fuerza que Kill All permanezca encendido y bloquea su toggle.",ka_bubble="Kill All Bubble",
ka_bubble_desc="Muestra un botÃ³n flotante 'KA' en pantalla.",
hit_activate="Activar Hitbox",hit_activate_desc="AÃ±ade una hitbox rectangular a los enemigos.",
hit_invisible="Hitbox Invisible",hit_invisible_desc="Hace la hitbox completamente transparente.",
hit_size="TamaÃ±o de la Hitbox",hit_color="Color de la Hitbox",
atp_main="Auto Teleport (Main)",atp_main_desc="Te teletransporta a la plataforma Main. Se desactiva si activÃ¡s Alt.",
atp_alt="Auto Teleport (Alt)",atp_alt_desc="Te teletransporta a la plataforma Alt. Se desactiva si activÃ¡s Main.",
atp_type="Tipo de Duelo",atp_row="Fila de Plataformas",
rs_break="Break Streak",rs_break_desc="Rompe la racha de jugadores que superen el objetivo.",
rs_target="Break Streak Target",rs_lower="Lower KD",rs_lower_desc="Baja tu KD matando jugadores que tengan pocas kills.",
rs_kd="KD Target Kills",
esp_toggle="ESP Jugadores",esp_color="Color del ESP",esp_glow="Mostrar Resplandor",esp_lines="Mostrar LÃ­neas",
farm_event="Auto Farmear Evento",
gfx_sunset="Atardecer",gfx_sunset_int="Intensidad del Atardecer",gfx_sunset_int_desc="Cuanto brillan el sol y sus rayos",
gfx_sunset_clar="Claridad del Atardecer",gfx_sunset_clar_desc="Si se ve muy oscuro, subilo",
gfx_night="Noche Nublada + Glow",gfx_night_desc="Cielo de noche, pero el mapa queda iluminado como luna llena",
gfx_night_glow="Intensidad del Glow",gfx_night_glow_desc="Cuanto brillan las luces",
gfx_night_clar="Claridad del Mapa",gfx_night_clar_desc="Si lo ves oscuro subelo",
gfx_fps="FPS Boost (Elimina texturas)",
anim_bundle="Elegir Paquete",anim_apply="Aplicar Paquete Completo",anim_restore="Restaurar Default",
anim_idle="Reposo",anim_walk="Caminar",anim_run="Correr",anim_jump="Saltar",anim_fall="Caer",anim_climb="Escalar",
anim_combine="Combinar y Aplicar",anim_none="Ninguno",
music_now_none="Sin canciÃ³n seleccionada",music_now_desc="Presiona Reproducir para comenzar",
music_prev="Anterior",music_prev_desc="Retrocede a la canciÃ³n previa",
music_next="Siguiente",music_next_desc="Avanza a la siguiente canciÃ³n",
music_play="Reproducir",music_play_desc="Inicia o reanuda la canciÃ³n actual",
music_pause="Pausar",music_pause_desc="Pausa la reproducciÃ³n sin perder el avance",
music_stop="Detener",music_stop_desc="Corta la mÃºsica por completo",
music_song="CanciÃ³n",music_song_desc="Elige una canciÃ³n de la lista para reproducirla",
music_shuffle="ReproducciÃ³n aleatoria",music_shuffle_desc="Elige una canciÃ³n al azar cada vez que avanza",
music_repeat="Repetir canciÃ³n",music_repeat_desc="Vuelve a reproducir la misma canciÃ³n al terminar",
music_vol="Volumen",music_vol_desc="Ajusta quÃ© tan fuerte suena la mÃºsica",
music_name="Nombre de la canciÃ³n",music_name_ph="Ej: Mi canciÃ³n",
music_id="ID de Roblox (rbxassetid)",music_id_ph="Ej: 1234567890",
music_add="AÃ±adir canciÃ³n",music_add_desc="Guarda el nombre e ID escritos arriba en la lista",
music_playing="Reproduciendo",music_paused="Pausado",
bg_select="Seleccionar fondo",bg_apply="Aplicar",bg_theme="Seleccionar Tema",bg_theme_desc="Cambia el tema de color de la WindUI",
emote_pick="Emote",emote_pick_desc="Elige un emote para tu personaje (requiere avatar R15)",
emote_play="Reproducir emote",emote_play_desc="Reproduce el emote seleccionado en tu personaje",
emote_stop="Detener emote",emote_stop_desc="Detiene el emote actual",
emote_name="Nombre del emote",emote_name_ph="Ej: Mi emote",
emote_id="ID de Roblox (rbxassetid)",emote_id_ph="Ej: 1234567890",
emote_loop="Repetir en bucle",emote_loop_desc="ActÃ­valo solo si el emote es un baile hecho para loopearse",
emote_add="AÃ±adir emote",emote_add_desc="Guarda el nombre, ID y tipo de bucle en la lista",
items_korblox="Aplicar Korblox",items_korblox_desc="Aplica o quita las piernas Korblox",
com_whatsapp="Grupo de WhatsApp",com_link_copied="Link Copiado!",
com_link_text="Abre WhatsApp y pega el enlace para unirte al grupo.",
com_discord_title="Ãnete a nuestro Discord",
com_discord_desc="Haz clic en el botÃ³n de abajo para copiar el link de invitaciÃ³n.",
com_discord_button="Copiar invitaciÃ³n de Discord",
ui_keybind="Tecla para abrir UI",
ui_keybind_reset="Resetear Tecla UI",
ui_keybind_reset_desc="Restablece esta tecla a su valor predeterminado.",
warn_staff="El staff de NexvyrHub no se hace responsable si resultas baneado del juego.",warn_updates="Actualizaciones cada semana",
owner_title="NEXVYR",owner_desc="[Owner] 7.dui\n\nCreador principal y responsable del programador.",
admin_title="SAMXHQQ",admin_desc="[Admin] samxh\n\nDiseÃ±ador grÃ¡fico y creador de ideas.",
helper_title="XIN",helper_desc="[Helper] AminVega\n\nAyudante de probar los scritps.",
support_title="ANTOX",support_desc="[Soporte] Antox\n\nAdministraciÃ³n de mantener todo en orden.",
thanks_title="Gracias por usar Nexvyr-Hub",
thanks_desc="Tu apoyo nos motiva a seguir mejorando.\n\nSÃ­guenos para mÃ¡s actualizaciones!",
upd_next="Siguiente actualizaciÃ³n",upd_date="Fecha: 1/10/2026",upd_changes1="+ 3 mejoras en las pestaÃ±as.",
upd_changes2="+ AutoShoot arreglado",upd_changes3="+ 4 nuevos fondos",
upd_warn1="El kill all esta temporalmente bloqueado.",
upd_warn2="Cualquier error o bug reportenlo en el grupo de WhatsApp para arreglarlo lo mÃ¡s rÃ¡pido posible.",
language="Idioma",lang_changed="Idioma cambiado a %s.",
},
}
_0x801a2b:Localization({
Enabled = true,
Prefix = "loc:",
DefaultLanguage = "Espanol",
Translations = { ["English"] = _0x15aaf5.English, ["Espanol"] = _0x15aaf5.Espanol },
})
local _0x977be4 = { Language = "Espanol" }
local function _0x452952(_0x5456c5)
_0x5456c5 = tostring(_0x5456c5 or _0xb872a2({}))
if _0x5456c5 == "en" or _0x5456c5 == "English" or _0x5456c5 == "Ingles" then return "English" end
return "Espanol"
end
local function _0x51daee() return _0x452952(_0x977be4.Language) end
local function _0xe3a2ee(_0x5456c5)
_0x977be4.Language = _0x452952(_0x5456c5)
pcall(function() _0x801a2b:SetLanguage(_0x977be4.Language) end)
return _0x977be4.Language
end
local function _0xedd99f(_0xfcff1e, ...)
local _0x974ee9 = _0x51daee()
local _0x9511ee = _0x15aaf5[_0x974ee9] or _0x15aaf5.Espanol
local _0xdf9ec2 = _0x9511ee[_0xfcff1e] or _0x15aaf5.Espanol[_0xfcff1e] or _0xfcff1e
if select("#", ...) > 0 then return string.format(_0xdf9ec2, ...) end
return _0xdf9ec2
end
local _0x8f5fb6 = _0x801a2b:CreateWindow({
Title = "NEXVYRHUB | DUELS <font color='#FFD700'>[v2.5]</font>",
Author = "By 7.duið²ð½",
Folder = "Nexvyr_WindUI",
Acrylic = false,
Transparent = false,
NewElements = true,
HideSearchBar = false,
Background = "rbxthumb://type=Asset&id=12687580616&w=420&h=420",
BackgroundImageTransparency = 0.35,
OpenButton = {
Title = "Open HUB",
Icon = "rbxthumb://type=Asset&id=118232139384203&w=420&h=420",
IconSize = 9,
CornerRadius = UDim.new(1),
StrokeThickness = 2,
Enabled = true,
Draggable = true,
Scale = 0.9,
Color = ColorSequence.new(Color3.fromHex("#110070"), Color3.fromHex("#300364"))
},
Topbar = { Height = 44, ButtonsType = "Default" }
})
local _0x48c2e0 = _0x8f5fb6:Section({ Title = "loc:sec_main", Opened = true })
local _0xa35170 = _0x8f5fb6:Section({ Title = "loc:sec_extra", Opened = true })
local _0x36ced9 = _0x8f5fb6:Section({ Title = "loc:sec_owners", Opened = true })
local _0xa9f1eb = {
Inicio = _0x48c2e0:Tab({ Title = "loc:tab_home", Icon = "solar:home-bold" }),
Aim = _0x48c2e0:Tab({ Title = "loc:tab_aim", Icon = "solar:target-bold" }),
Vis = _0x48c2e0:Tab({ Title = "loc:tab_vis", Icon = "solar:eye-bold" }),
Farm = _0x48c2e0:Tab({ Title = "loc:tab_farm", Icon = "solar:dollar-bold" }),
KillAll = _0x48c2e0:Tab({ Title = "loc:tab_killall", Icon = "solar:danger-triangle-bold" }),
RachaFarm = _0x48c2e0:Tab({ Title = "loc:tab_racha", Icon = "solar:flame-bold" }),
Graficos = _0x48c2e0:Tab({ Title = "loc:tab_gfx", Icon = "solar:palette-bold" }),
Animaciones = _0x48c2e0:Tab({ Title = "loc:tab_anim", Icon = "solar:smile-circle-bold" }),
Music = _0xa35170:Tab({ Title = "loc:tab_music", Icon = "solar:music-note-2-bold" }),
Fondos = _0xa35170:Tab({ Title = "loc:tab_bg", Icon = "solar:gallery-bold" }),
Emotes = _0xa35170:Tab({ Title = "loc:tab_emotes", Icon = "solar:emoji-funny-circle-bold" }),
Items = _0xa35170:Tab({ Title = "loc:tab_items", Icon = "solar:crown-star-bold" }),
Com = _0xa35170:Tab({ Title = "loc:tab_com", Icon = "solar:chat-line-bold" }),
Owners = _0x36ced9:Tab({ Title = "loc:tab_owners", Icon = "solar:crown-bold" }),
Avisos = _0x36ced9:Tab({ Title = "loc:tab_warn", Icon = "solar:shield-warning-bold" }),
Update = _0x36ced9:Tab({ Title = "loc:tab_update", Icon = "solar:cloud-download-bold" })
}
local function _0x62a786() _0x5f9fd6 = {} end
local function _0x72becd(_0x63fce4) _0x5f9fd6[_0x63fce4] = nil end
LocalPlayer:GetPropertyChangedSignal("Team"):Connect(_0x62a786)
LocalPlayer:GetPropertyChangedSignal("TeamColor"):Connect(_0x62a786)
LocalPlayer:GetAttributeChangedSignal("Team"):Connect(_0x62a786)
local function _0x7d3ad2(_0x63fce4)
_0x63fce4:GetPropertyChangedSignal("Team"):Connect(function() _0x72becd(_0x63fce4) end)
_0x63fce4:GetPropertyChangedSignal("TeamColor"):Connect(function() _0x72becd(_0x63fce4) end)
_0x63fce4:GetAttributeChangedSignal("Team"):Connect(function() _0x72becd(_0x63fce4) end)
end
for _0x9b1916, _0x63fce4 in ipairs(Players:GetPlayers()) do
if _0x63fce4 ~= LocalPlayer then _0x7d3ad2(_0x63fce4) end
end
Players.PlayerAdded:Connect(function(_0x63fce4) _0x7d3ad2(_0x63fce4) end)
Players.PlayerRemoving:Connect(function(_0x63fce4) _0x72becd(_0x63fce4) end)
local function _0x5b9cc4(_0x461e30)
if not _0x7cab60 then return true end
if _0x461e30 == LocalPlayer then return false end
if _0x5f9fd6[_0x461e30] ~= nil then return _0x5f9fd6[_0x461e30] end
local _0x68d529 = true
if LocalPlayer.Team ~= nil and _0x461e30.Team ~= nil then
_0x68d529 = (LocalPlayer.Team ~= _0x461e30.Team)
else
local _0x15665b = LocalPlayer:GetAttribute("Team") or LocalPlayer:GetAttribute("team")
local _0x68f0cb = _0x461e30:GetAttribute("Team") or _0x461e30:GetAttribute("team")
if _0x15665b ~= nil and _0x68f0cb ~= nil then
_0x68d529 = (_0x15665b ~= _0x68f0cb)
elseif LocalPlayer.TeamColor.Name ~= "White" and LocalPlayer.TeamColor.Name ~= "Medium stone grey" then
_0x68d529 = (LocalPlayer.TeamColor ~= _0x461e30.TeamColor)
end
end
_0x5f9fd6[_0x461e30] = _0x68d529
return _0x68d529
end
local function _0x244a52()
local _0x78a699 = LocalPlayer.Character
if not _0x78a699 then return true end
if _0x78a699:FindFirstChildOfClass("ForceField") then return true end
if LocalPlayer.Team then
local _0xf2283a = string.lower(LocalPlayer.Team.Name)
if string.find(_0xf2283a, "lobby") or string.find(_0xf2283a, "spectat")
or string.find(_0xf2283a, "espectador") or string.find(_0xf2283a, "menu")
or string.find(_0xf2283a, "dead") then return true end
end
return false
end
local function _0xcc0320(_0x461e30)
if not _0x461e30 or _0x461e30 == LocalPlayer then return false end
if not _0x5b9cc4(_0x461e30) then return false end
local _0x78a699 = _0x461e30.Character
if not _0x78a699 then return false end
local _0x84e7d7 = _0x78a699:FindFirstChildOfClass("Humanoid")
if not _0x84e7d7 or _0x84e7d7.Health <= 0 then return false end
if _0x78a699:FindFirstChildOfClass("ForceField") then return false end
if _0x461e30.Team then
local _0xf2283a = string.lower(_0x461e30.Team.Name)
if string.find(_0xf2283a, "lobby") or string.find(_0xf2283a, "spectat")
or string.find(_0xf2283a, "espectador") or string.find(_0xf2283a, "menu")
or string.find(_0xf2283a, "dead") then return false end
end
return true
end
local _0xdb4bdc = {}
_0xdb4bdc.__index = _0xdb4bdc
function _0xdb4bdc.new() return setmetatable({ Items = {} }, _0xdb4bdc) end
function _0xdb4bdc:Add(task) self.Items[#self.Items + 1] = task; return task end
function _0xdb4bdc:Cleanup()
for _0xc4d087 = #self.Items, 1, -1 do
local _0x8c0a41 = self.Items[_0xc4d087]
self.Items[_0xc4d087] = nil
local _0x6394ce = typeof(_0x8c0a41)
if _0x6394ce == "RBXScriptConnection" then pcall(function() _0x8c0a41:Disconnect() end)
elseif _0x6394ce == "Instance" then pcall(function() _0x8c0a41:Destroy() end)
elseif _0x6394ce == "function" then pcall(_0x8c0a41) end
end
end
local function _0x64acf6()
for _0x9b1916, _0x461e30 in ipairs(Players:GetPlayers()) do
local _0xcfdc4e = _0x461e30.Character
if _0xcfdc4e then
local _0x216bb5 = _0xcfdc4e:FindFirstChild("GhostHitbox")
if _0x216bb5 then _0x216bb5:Destroy() end
end
end
end
RunService.Heartbeat:Connect(function()
if not _0x0bf5a7 then return end
for _0x9b1916, _0x461e30 in ipairs(Players:GetPlayers()) do
if _0x461e30 ~= LocalPlayer and _0x5b9cc4(_0x461e30) then
local _0xcfdc4e = _0x461e30.Character
if _0xcfdc4e then
local _0x6553f7 = _0xcfdc4e:FindFirstChild("HumanoidRootPart")
local _0x6f60b1 = _0xcfdc4e:FindFirstChild("Humanoid")
if _0x6553f7 and _0x6f60b1 and _0x6f60b1.Health > 0 then
local _0x216bb5 = _0xcfdc4e:FindFirstChild("GhostHitbox")
if not _0x216bb5 then
_0x216bb5 = Instance.new("Part")
_0x216bb5.Name = "GhostHitbox"
_0x216bb5.Size = Vector3.new(_0x0d5e57 * _0xad3c4e, _0x0d5e57 * _0x893535, _0x0d5e57 * _0x26be35)
_0x216bb5.Transparency = _0xf0b050 and 1 or 0.6
_0x216bb5.Color = _0xcbf13d
_0x216bb5.CanCollide = false
_0x216bb5.Massless = true
_0x216bb5.CanQuery = true
_0x216bb5.CFrame = _0x6553f7.CFrame
_0x216bb5.Parent = _0xcfdc4e
local _0x750149 = Instance.new("WeldConstraint")
_0x750149.Part0 = _0x6553f7
_0x750149.Part1 = _0x216bb5
_0x750149.Parent = _0x216bb5
else
_0x216bb5.Size = Vector3.new(_0x0d5e57 * _0xad3c4e, _0x0d5e57 * _0x893535, _0x0d5e57 * _0x26be35)
_0x216bb5.Transparency = _0xf0b050 and 1 or 0.6
_0x216bb5.Color = _0xcbf13d
_0x216bb5.CanQuery = true
end
else
local _0x216bb5 = _0xcfdc4e:FindFirstChild("GhostHitbox")
if _0x216bb5 then _0x216bb5:Destroy() end
end
end
end
end
end)
local _0x208292 = {
["Right Platforms"] = {
["1v1"] = { ZoneName = "PadZone1", MainPad = "Pad1", AltPad = "Pad2" },
["2v2"] = { ZoneName = "PadZone2", MainPad = "Pad1", AltPad = "Pad2" },
["3v3"] = { ZoneName = "PadZone3", MainPad = "Pad1", AltPad = "Pad2" },
["4v4"] = { ZoneName = "PadZone4", MainPad = "Pad1", AltPad = "Pad2" }
},
["Left Platforms"] = {
["1v1"] = { ZoneName = "PadZone5", MainPad = "Pad1", AltPad = "Pad2" },
["2v2"] = { ZoneName = "PadZone6", MainPad = "Pad1", AltPad = "Pad2" },
["3v3"] = { ZoneName = "PadZone7", MainPad = "Pad1", AltPad = "Pad2" },
["4v4"] = { ZoneName = "PadZone8", MainPad = "Pad1", AltPad = "Pad2" }
}
}
AutoTeleportMainAlt = {}
AutoTeleportMainAlt.__index = AutoTeleportMainAlt
function AutoTeleportMainAlt.new()
return setmetatable({
Running = false, Connections = _0xdb4bdc.new(), Acc = 0, TickInterval = 0.5,
ActiveRole = nil, DuelType = "1v1", PlatformRow = "Right Platforms",
LastTeleport = 0, LastVote = 0, LastCancel = 0, TeleportCooldown = 0.5,
VoteCooldown = 1, CancelCooldown = 1, VotedMap = nil,
HighlightedPad = nil, PadColors = {}, ManualHold = false,
}, AutoTeleportMainAlt)
end
function AutoTeleportMainAlt:GetActiveRole()
if self.ActiveRole == "Main" then return "Main" end
if self.ActiveRole == "Alt" then return "Alt" end
return nil
end
function AutoTeleportMainAlt:GetRoot()
local _0x78a699 = LocalPlayer.Character
if not _0x78a699 then return nil end
local _0xb17d1f = _0x78a699:FindFirstChild("HumanoidRootPart")
if _0xb17d1f and _0xb17d1f:IsA("BasePart") then return _0xb17d1f end
return nil
end
function AutoTeleportMainAlt:GetHumanoid()
local _0x78a699 = LocalPlayer.Character
return _0x78a699 and _0x78a699:FindFirstChildOfClass("Humanoid") or nil
end
function AutoTeleportMainAlt:Attr(_0x6f342d)
local _0x5456c5 = LocalPlayer:GetAttribute(_0x6f342d)
if typeof(_0x5456c5) == "string" and _0x5456c5 ~= _0xb872a2({}) then return _0x5456c5 end
return nil
end
function AutoTeleportMainAlt:Snapshot()
local _0x112e3c = self:Attr("Game")
local _0x0bdf19 = self:Attr("Map")
local _0x78a699 = LocalPlayer.Character
local _0x84e7d7 = _0x78a699 and _0x78a699:FindFirstChildOfClass("Humanoid")
local _0xb17d1f = _0x78a699 and _0x78a699:FindFirstChild("HumanoidRootPart")
local _0x669992 = _0x84e7d7 ~= nil and _0x84e7d7.Health > 0 and _0xb17d1f ~= nil
return { Game = _0x112e3c, Map = _0x0bdf19, InGame = _0x112e3c ~= nil,
InMap = _0x112e3c ~= nil and _0x0bdf19 ~= nil, Alive = _0x669992 }
end
function AutoTeleportMainAlt:IsOnMatch()
local _0x5d245a = self:Snapshot()
return _0x5d245a and _0x5d245a.InGame == true and _0x5d245a.InMap ~= true and _0x5d245a.Alive
end
function AutoTeleportMainAlt:IsQueued() return self:Snapshot().InGame == true end
function AutoTeleportMainAlt:ResolvePad(_0x410d90)
local _0x537416 = _0x208292[self.PlatformRow] or _0x208292["Right Platforms"]
local _0x6aa74e = _0x537416[self.DuelType] or _0x537416["1v1"]
local _0xac01d0 = workspace:FindFirstChild("PadZones")
if not _0xac01d0 then return nil end
local _0x9decf0 = _0xac01d0:FindFirstChild(_0x6aa74e.ZoneName)
if not _0x9decf0 then return nil end
local _0xf0032c = (_0x410d90 == "Alt") and _0x6aa74e.AltPad or _0x6aa74e.MainPad
local _0xecf9e8 = _0x9decf0:FindFirstChild(_0xf0032c)
if not _0xecf9e8 then return nil end
local _0x03a6d0 = _0xecf9e8:FindFirstChild("Pad")
if _0x03a6d0 and _0x03a6d0:IsA("BasePart") then return _0x03a6d0 end
return nil
end
function AutoTeleportMainAlt:IsOnPad(_0x03a6d0)
if not _0x03a6d0 then return false end
local _0xb17d1f = self:GetRoot()
if not _0xb17d1f then return false end
local _0xdcc127 = _0x03a6d0.CFrame:PointToObjectSpace(_0xb17d1f.Position)
local _0x1ebaf9 = _0x03a6d0.Size / 2
return math.abs(_0xdcc127.X) <= _0x1ebaf9.X + 0.5 and math.abs(_0xdcc127.Z) <= _0x1ebaf9.Z + 0.5
and _0xdcc127.Y >= -(_0x1ebaf9.Y + 6) and _0xdcc127.Y <= _0x1ebaf9.Y + 14
end
function AutoTeleportMainAlt:MarkPad(_0x03a6d0, _0x60a780)
if not _0x03a6d0 then self:UnmarkPad(); return end
if self.HighlightedPad == _0x03a6d0 then return end
self:UnmarkPad()
self.HighlightedPad = _0x03a6d0
self.PadColors[_0x03a6d0] = { Color = _0x03a6d0.Color, Transparency = _0x03a6d0.Transparency }
pcall(function()
_0x03a6d0.Color = _0x60a780 and Color3.fromRGB(255, 70, 70) or Color3.fromRGB(70, 145, 255)
_0x03a6d0.Transparency = 0.5
end)
end
function AutoTeleportMainAlt:UnmarkPad()
if self.HighlightedPad and self.PadColors[self.HighlightedPad] then
local _0x03a6d0 = self.HighlightedPad
local _0xbe3190 = self.PadColors[_0x03a6d0]
pcall(function()
if _0x03a6d0.Parent then
_0x03a6d0.Color = _0xbe3190.Color
_0x03a6d0.Transparency = _0xbe3190.Transparency
end
end)
end
self.HighlightedPad = nil
end
function AutoTeleportMainAlt:FindVoteRemote()
local _0x3c03c0 = ReplicatedStorage:FindFirstChild("Packages")
local _0x0ce545 = _0x3c03c0 and _0x3c03c0:FindFirstChild("Networking")
local _0x235a4c = _0x0ce545 and _0x0ce545:FindFirstChild("RF/Voting/Vote")
if _0x235a4c and _0x235a4c:IsA("RemoteFunction") then return _0x235a4c end
return nil
end
function AutoTeleportMainAlt:FindVisibleMapVote()
local _0xf61b28 = LocalPlayer:FindFirstChild("PlayerGui")
local _0x7a464e = _0xf61b28 and _0xf61b28:FindFirstChild("Main")
local _0x3b0069 = _0x7a464e and _0x7a464e:FindFirstChild("MapVoting")
local _0xecf9e8 = _0x3b0069 and _0x3b0069:FindFirstChild("VotingHolder")
if not _0xecf9e8 then return nil end
for _0x9b1916, _0x951f39 in ipairs(_0xecf9e8:GetChildren()) do
if _0x951f39:IsA("ImageButton") and _0x951f39.Visible and _0x951f39.Name ~= _0xb872a2({}) then return _0x951f39.Name end
end
return nil
end
function AutoTeleportMainAlt:VoteMap()
local _0x5d245a = self:Snapshot()
if not self:IsOnMatch() then return end
if self.VotedMap == _0x5d245a.Game then return end
local _0xc59f24 = os.clock()
if _0xc59f24 - (self.LastVote or 0) < self.VoteCooldown then return end
self.LastVote = _0xc59f24
local _0x0fb13b = self:FindVisibleMapVote()
local _0xdbdf47 = self:FindVoteRemote()
if not (_0x0fb13b and _0xdbdf47) then return end
self.VotedMap = _0x5d245a.Game
pcall(function() _0xdbdf47:InvokeServer(_0x0fb13b) end)
end
function AutoTeleportMainAlt:FindSetStateRemote()
local _0x3c03c0 = ReplicatedStorage:FindFirstChild("Packages")
local _0x0ce545 = _0x3c03c0 and _0x3c03c0:FindFirstChild("Networking")
local _0x235a4c = _0x0ce545 and _0x0ce545:FindFirstChild("RE/Match/SetStatePlr")
if _0x235a4c and _0x235a4c:IsA("RemoteEvent") then return _0x235a4c end
return nil
end
function AutoTeleportMainAlt:CancelQueue()
local _0xc59f24 = os.clock()
if _0xc59f24 - (self.LastCancel or 0) < self.CancelCooldown then return end
local _0x2d61bb = self:FindSetStateRemote()
if not _0x2d61bb then return end
self.LastCancel = _0xc59f24
pcall(function() _0x2d61bb:FireServer("REMOVE") end)
end
function AutoTeleportMainAlt:HideGameFrame()
local _0xf61b28 = LocalPlayer:FindFirstChild("PlayerGui")
local _0x7a464e = _0xf61b28 and _0xf61b28:FindFirstChild("Main")
local _0x400dcf = _0x7a464e and _0x7a464e:FindFirstChild("MainGameFrame")
if _0x400dcf and _0x400dcf:IsA("GuiObject") then pcall(function() _0x400dcf.Visible = false end) end
end
function AutoTeleportMainAlt:HoldCenter()
local _0x84e7d7 = self:GetHumanoid()
local _0xb17d1f = self:GetRoot()
if _0x84e7d7 and _0xb17d1f then pcall(function() _0x84e7d7:MoveTo(_0xb17d1f.Position) end) end
end
function AutoTeleportMainAlt:Teleport(_0x03a6d0)
if not _0x03a6d0 then return end
local _0xb17d1f = self:GetRoot()
local _0x84e7d7 = self:GetHumanoid()
if not (_0xb17d1f and _0x84e7d7) then return end
pcall(function()
_0xb17d1f.AssemblyAngularVelocity = Vector3.zero
_0xb17d1f.AssemblyLinearVelocity = Vector3.zero
self:CancelQueue()
self:HideGameFrame()
_0x84e7d7:MoveTo(_0x03a6d0.Position)
end)
end
function AutoTeleportMainAlt:Process()
if not self.Running then return end
local _0x5d245a = self:Snapshot()
if _0x5d245a.InGame then
self:UnmarkPad()
self:HoldCenter()
self:VoteMap()
return
end
local _0x410d90 = self:GetActiveRole()
if not _0x410d90 then self:UnmarkPad(); return end
local _0x03a6d0 = self:ResolvePad(_0x410d90)
self:MarkPad(_0x03a6d0, _0x410d90 == "Alt")
if not _0x03a6d0 then return end
if self:IsOnPad(_0x03a6d0) then return end
local _0xc59f24 = os.clock()
if not self.ManualHold and _0xc59f24 - (self.LastTeleport or 0) < self.TeleportCooldown then return end
self.LastTeleport = _0xc59f24
self:Teleport(_0x03a6d0)
end
function AutoTeleportMainAlt:Kick()
if not self.Running then return end
self:Process()
end
function AutoTeleportMainAlt:Start()
if self.Running then return end
self.Running = true
self.Acc = 0
self.LastTeleport = 0
self.LastVote = 0
self.LastCancel = 0
self.Connections:Add(LocalPlayer:GetAttributeChangedSignal("Game"):Connect(function()
task.defer(function() if self.Running then self:Process() end end)
end))
self.Connections:Add(LocalPlayer:GetAttributeChangedSignal("Map"):Connect(function()
task.defer(function() if self.Running then self:Process() end end)
end))
self.Connections:Add(LocalPlayer:GetAttributeChangedSignal("Team"):Connect(function()
task.defer(function() if self.Running then self:Process() end end)
end))
self.Connections:Add(RunService.Heartbeat:Connect(function(_0x78e148)
if not self.Running then return end
self.Acc = self.Acc + _0x78e148
if self.Acc >= self.TickInterval then
self.Acc = 0
self:Process()
end
end))
self:Process()
end
function AutoTeleportMainAlt:Stop()
if not self.Running then return end
self.Running = false
self.Connections:Cleanup()
self.Connections = _0xdb4bdc.new()
self:UnmarkPad()
self.VotedMap = nil
end
AutoTeleportMainAltInstance = AutoTeleportMainAlt.new()
local _0xabd4d0 = 1
local _0xf2481f = 90
local _0x1a6866 = 0.5
KillAll = {}
KillAll.__index = KillAll
function KillAll.new()
return setmetatable({
running = false, connections = _0xdb4bdc.new(), savedCollisions = {},
swingAccumulator = 0, targetFloor = nil, lastTarget = nil, repositioned = false,
activeRole = nil, AlwaysOn = false, EnforceToken = 0
}, KillAll)
end
function KillAll:DisableCollisions()
local _0x78a699 = LocalPlayer.Character
if not _0x78a699 then return end
for _0x9b1916, _0xd2e5af in ipairs(_0x78a699:GetDescendants()) do
if _0xd2e5af:IsA("BasePart") and _0xd2e5af.CanCollide then
if self.savedCollisions[_0xd2e5af] == nil then
self.savedCollisions[_0xd2e5af] = _0xd2e5af.CanCollide
end
_0xd2e5af.CanCollide = false
end
end
end
function KillAll:RestoreCollisions()
for _0xd2e5af, _0x19ee65 in pairs(self.savedCollisions) do
if _0xd2e5af.Parent then pcall(function() _0xd2e5af.CanCollide = _0x19ee65 end) end
end
table.clear(self.savedCollisions)
end
function KillAll:GetRoot(_0x63fce4)
local _0x78a699 = _0x63fce4 and _0x63fce4.Character
if not _0x78a699 then return nil end
local _0xb17d1f = _0x78a699:FindFirstChild("HumanoidRootPart")
if _0xb17d1f and _0xb17d1f:IsA("BasePart") then return _0xb17d1f end
return nil
end
function KillAll:GetHumanoid(_0x63fce4)
local _0x78a699 = _0x63fce4 and _0x63fce4.Character
return _0x78a699 and _0x78a699:FindFirstChildOfClass("Humanoid") or nil
end
function KillAll:GetClosestEnemy()
local _0x6ca4f8 = self:GetRoot(LocalPlayer)
if not _0x6ca4f8 then return nil end
local _0xb08ab6 = nil
local _0x467e00 = nil
for _0x9b1916, _0x68d461 in ipairs(Players:GetPlayers()) do
if _0x68d461 ~= LocalPlayer and _0xcc0320(_0x68d461) then
local _0x84e7d7 = self:GetHumanoid(_0x68d461)
local _0xb17d1f = self:GetRoot(_0x68d461)
if _0xb17d1f and _0x84e7d7 and _0x84e7d7.Health > 0 then
local _0x0c758b = (_0xb17d1f.Position - _0x6ca4f8.Position).Magnitude
if not _0x467e00 or _0x0c758b < _0x467e00 then
_0xb08ab6 = _0xb17d1f
_0x467e00 = _0x0c758b
end
end
end
end
return _0xb08ab6
end
function KillAll:GetFloorY(_0xd6f70e)
local _0x84e7d7 = _0xd6f70e.Parent and _0xd6f70e.Parent:FindFirstChildOfClass("Humanoid")
local _0x2d8608 = _0x84e7d7 and tonumber(_0x84e7d7.HipHeight) or 2
return _0xd6f70e.Position.Y - _0x2d8608 - _0xd6f70e.Size.Y / 2
end
function KillAll:IsInMatch()
local _0xc83c01 = LocalPlayer:FindFirstChild("PlayerGui")
if not _0xc83c01 then return false end
local _0x7a464e = _0xc83c01:FindFirstChild("Main") or _0xc83c01
local _0xfe2471 = _0x7a464e:FindFirstChild("MainGameFrame")
local _0x72fe88 = _0xfe2471 and _0xfe2471:FindFirstChild("IngameScore")
local _0x4ce037 = _0x72fe88 and _0x72fe88:FindFirstChild("Timer")
if not _0x4ce037 then return false end
if not (_0x4ce037:IsA("TextLabel") or _0x4ce037:IsA("TextButton") or _0x4ce037:IsA("TextBox")) then return false end
return tostring(_0x4ce037.Text or _0xb872a2({})):match("^%s*%d+:%d%d%s*$") ~= nil
end
function KillAll:IsSameMatch(_0x2e098a)
local _0x7e30c8 = LocalPlayer:GetAttribute("Map")
local _0x969300 = LocalPlayer:GetAttribute("Game")
if _0x7e30c8 == nil or _0x969300 == nil then return true end
local _0x6335fc = _0x2e098a:GetAttribute("Map")
local _0x2007fb = _0x2e098a:GetAttribute("Game")
if _0x6335fc == nil or _0x2007fb == nil then return true end
return _0x6335fc == _0x7e30c8 and _0x2007fb == _0x969300
end
function KillAll:ResetState()
self.targetFloor = nil
self.lastTarget = nil
self.repositioned = false
self:RestoreCollisions()
local _0x84e7d7 = self:GetHumanoid(LocalPlayer)
if _0x84e7d7 and _0x84e7d7.PlatformStand then
pcall(function() _0x84e7d7.PlatformStand = false end)
end
end
function KillAll:IsKnife(_0x6551ce)
if not (_0x6551ce and _0x6551ce:IsA("Tool")) then return false end
if _0x6551ce:FindFirstChild("fire") or _0x6551ce:FindFirstChild("showBeam") then return false end
return _0x6551ce:FindFirstChild("Slash") ~= nil or _0x6551ce:FindFirstChild("SlashStart") ~= nil
end
function KillAll:FindKnife()
local _0x78a699 = LocalPlayer.Character
if _0x78a699 then
for _0x9b1916, _0xf31175 in ipairs(_0x78a699:GetChildren()) do
if self:IsKnife(_0xf31175) then return _0xf31175, true end
end
end
local _0x0acf6e = LocalPlayer:FindFirstChildOfClass("Backpack")
if _0x0acf6e then
for _0x9b1916, _0xf31175 in ipairs(_0x0acf6e:GetChildren()) do
if self:IsKnife(_0xf31175) then return _0xf31175, false end
end
end
return nil, false
end
function KillAll:SwingKnife(_0x78e148)
self.swingAccumulator = self.swingAccumulator + _0x78e148
if self.swingAccumulator < _0x1a6866 then return end
self.swingAccumulator = 0
local _0x6551ce, _0x549c5e = self:FindKnife()
if not _0x6551ce then return end
if not _0x549c5e then
local _0x84e7d7 = self:GetHumanoid(LocalPlayer)
if not _0x84e7d7 then return end
pcall(function() _0x84e7d7:EquipTool(_0x6551ce) end)
if _0x6551ce.Parent ~= LocalPlayer.Character then return end
end
pcall(function() _0x6551ce:Activate() end)
end
function KillAll:GetRole()
if self.activeRole == "Main" then return "Main" end
if self.activeRole == "Alt" then return "Alt" end
return nil
end
function KillAll:ParseNumber(_0x68c862)
if _0x68c862 == nil then return nil end
local _0xdf9ec2 = tostring(_0x68c862)
return tonumber(_0xdf9ec2) or tonumber(string.match(_0xdf9ec2, "%d+") or _0xb872a2({}))
end
function KillAll:GetTeamScores()
local _0x89c744 = LocalPlayer:FindFirstChild("PlayerGui")
local _0x83c450 = _0x89c744 and _0x89c744:FindFirstChild("Main")
local _0xfe2471 = _0x83c450 and _0x83c450:FindFirstChild("MainGameFrame")
local _0xc42bc2 = _0xfe2471 and _0xfe2471:FindFirstChild("PlayersFrame")
if not _0xc42bc2 then return nil, nil end
local _0x81ba47 = _0xc42bc2:FindFirstChild("TeamBlueScoreFrame")
local _0x7e8cb3 = _0xc42bc2:FindFirstChild("TeamRedScoreFrame")
local _0xbb41df = _0x81ba47 and _0x81ba47:FindFirstChild("ScoreText")
local _0x398c39 = _0x7e8cb3 and _0x7e8cb3:FindFirstChild("ScoreText")
if not (_0xbb41df and _0x398c39) then return nil, nil end
local _0x951f39 = self:ParseNumber(_0xbb41df.Text)
local _0x235a4c = self:ParseNumber(_0x398c39.Text)
if LocalPlayer:GetAttribute("Team") == "Red" then return _0x235a4c, _0x951f39 end
return _0x951f39, _0x235a4c
end
function KillAll:GetRoundKills(_0x461e30)
if not _0x461e30 then return nil end
local _0x5678b1 = tonumber(_0x461e30:GetAttribute("RoundKills"))
if _0x5678b1 then return _0x5678b1 end
local _0x5db824 = _0x461e30:FindFirstChild("RoundKills")
if _0x5db824 and (_0x5db824:IsA("IntValue") or _0x5db824:IsA("NumberValue")) then
return tonumber(_0x5db824.Value) or 0
end
local _0xa9b9f0 = _0x461e30:FindFirstChild("leaderstats")
local _0x2a38eb = _0xa9b9f0 and _0xa9b9f0:FindFirstChild("RoundKills")
if _0x2a38eb and (_0x2a38eb:IsA("IntValue") or _0x2a38eb:IsA("NumberValue")) then
return tonumber(_0x2a38eb.Value) or 0
end
return nil
end
function KillAll:GetStreak(_0x461e30)
local _0x3f77ef = _0x461e30 and _0x461e30:FindFirstChild("Streak")
if _0x3f77ef and (_0x3f77ef:IsA("IntValue") or _0x3f77ef:IsA("NumberValue")) then
return tonumber(_0x3f77ef.Value)
end
local _0xb17d1f = _0x461e30 and self:GetRoot(_0x461e30)
local _0xbef298 = _0xb17d1f and _0xb17d1f:FindFirstChild("HeadTag")
local _0xbbe235 = _0xbef298 and _0xbef298:FindFirstChild("Streak")
local _0xc55d1c = _0xbbe235 and _0xbbe235:FindFirstChild("TextLabel")
if not _0xc55d1c then return nil end
return tonumber(tostring(_0xc55d1c.Text or _0xb872a2({})):gsub("[^%d%-]", _0xb872a2({})))
end
function KillAll:ReadMyLeaderboardStreak()
local _0xe38020 = workspace:FindFirstChild("Leaderboards")
local _0x83d614 = _0xe38020 and _0xe38020:FindFirstChild("streak")
local _0xf9f516 = _0x83d614 and _0x83d614:FindFirstChild("ScreenPart")
local _0x833721 = _0xf9f516 and _0xf9f516:FindFirstChild("SurfaceGui")
local _0x475042 = _0x833721 and _0x833721:FindFirstChild("Frame")
if not _0x475042 then return nil end
for _0x9b1916, _0xf31175 in ipairs(_0x475042:GetChildren()) do
if _0xf31175:IsA("Frame") and _0xf31175.LayoutOrder == 50 then
local _0xf2f833 = _0xf31175:FindFirstChild("Wins")
if _0xf2f833 then
if _0xf2f833:IsA("IntValue") or _0xf2f833:IsA("NumberValue") then
return tonumber(_0xf2f833.Value)
elseif _0xf2f833:IsA("TextLabel") or _0xf2f833:IsA("TextButton") or _0xf2f833:IsA("TextBox") then
local _0x5db824 = tonumber(tostring(_0xf2f833.Text or _0xb872a2({})))
if _0x5db824 then return _0x5db824 end
local _0x4481a9 = string.match(tostring(_0xf2f833.Text or _0xb872a2({})), "%d+")
return _0x4481a9 and tonumber(_0x4481a9) or nil
end
end
end
end
return nil
end
function KillAll:ShouldBreakStreak()
if not a8_breakStreakEnabled then return true end
local _0x0fb13b = math.floor(a8_breakStreakTarget or 0)
if _0x0fb13b <= 0 then
local _0x41836b = self:ReadMyLeaderboardStreak()
if not _0x41836b then return false end
_0x0fb13b = math.max(0, _0x41836b - 1)
end
for _0x9b1916, _0x68d461 in ipairs(Players:GetPlayers()) do
if _0x68d461 ~= LocalPlayer and _0x5b9cc4(_0x68d461) then
local _0x3f77ef = self:GetStreak(_0x68d461)
if _0x3f77ef and _0x3f77ef >= _0x0fb13b then return true end
end
end
return false
end
function KillAll:ShouldLowerKD(_0x410d90)
if not a8_lowerKDEnabled then return true end
local _0x0fb13b = math.clamp(math.floor(a8_kdTargetKills or 4), 0, 4)
local _0x49ab22, _0x20c2fa = self:GetTeamScores()
if _0x410d90 == "Alt" then
local _0x41836b = self:GetRoundKills(LocalPlayer)
return (_0x41836b or _0x49ab22 or 0) < _0x0fb13b
end
if _0x20c2fa then return _0x20c2fa >= _0x0fb13b end
for _0x9b1916, _0x68d461 in ipairs(Players:GetPlayers()) do
local _0xec343a = _0x5b9cc4(_0x68d461) and self:GetRoundKills(_0x68d461) or nil
if _0xec343a and _0xec343a >= _0x0fb13b then return true end
end
return false
end
function KillAll:ShouldRun()
local _0x410d90 = self:GetRole()
if not _0x410d90 then return true end
return self:ShouldBreakStreak() and self:ShouldLowerKD(_0x410d90)
end
function KillAll:Update(_0x78e148)
if not self:IsInMatch() then self:ResetState(); return end
if not self:ShouldRun() then self:ResetState(); return end
local _0x6ca4f8 = self:GetRoot(LocalPlayer)
local _0x0fb13b = _0x6ca4f8 and self:GetClosestEnemy()
if not _0x0fb13b then self:ResetState(); return end
self:DisableCollisions()
self:SwingKnife(_0x78e148 or 0)
local _0x84e7d7 = self:GetHumanoid(LocalPlayer)
if _0x84e7d7 and not _0x84e7d7.PlatformStand then
pcall(function() _0x84e7d7.PlatformStand = true end)
end
local _0xb82f46 = _0x0fb13b.Position
local _0x89e3f9 = _0x0fb13b.Parent and _0x0fb13b.Parent:FindFirstChildOfClass("Humanoid")
local _0x689f72 = _0x89e3f9 and _0x89e3f9.FloorMaterial ~= Enum.Material.Air
if _0x0fb13b ~= self.lastTarget then
self.lastTarget = _0x0fb13b
self.targetFloor = nil
self.repositioned = false
end
if _0x689f72 or not self.targetFloor then
self.targetFloor = self:GetFloorY(_0x0fb13b)
end
local _0x1284c5 = self.targetFloor - _0xabd4d0
local _0x3b1d2e = _0x6ca4f8.Position
local _0xa08f68 = _0xb82f46.X
local _0x270849 = _0xb82f46.Z
if not self.repositioned then
if math.abs(_0x3b1d2e.Y - _0x1284c5) > 1 then
_0xa08f68 = _0x3b1d2e.X
_0x270849 = _0x3b1d2e.Z
else
self.repositioned = true
end
end
pcall(function()
_0x6ca4f8.CFrame = CFrame.new(_0xa08f68, _0x1284c5, _0x270849) * CFrame.Angles(math.rad(_0xf2481f), 0, 0)
_0x6ca4f8.AssemblyLinearVelocity = Vector3.zero
_0x6ca4f8.AssemblyAngularVelocity = Vector3.zero
end)
end
function KillAll:Start()
if self.running then return end
self.running = true
self.swingAccumulator = 0
self.connections:Add(RunService.Heartbeat:Connect(function(_0x78e148)
if not self.running then return end
self:Update(_0x78e148)
end))
self.connections:Add(LocalPlayer.CharacterAdded:Connect(function()
table.clear(self.savedCollisions)
end))
end
function KillAll:Stop()
if not self.running then return end
self.running = false
self.connections:Cleanup()
self:ResetState()
end
KillAllInstance = KillAll.new()
a8_breakStreakEnabled = false
a8_breakStreakTarget = 1
a8_lowerKDEnabled = false
a8_kdTargetKills = 4
local _0x330157 = false
local _0x80dc4e = nil
local _0xbca103 = nil
local function _0xdb12dc()
if not _0xbca103 then return end
_0xbca103.Text = "KA"
if KillAllInstance.running then
_0xbca103.BackgroundColor3 = Color3.fromRGB(30, 156, 88)
_0xbca103.TextColor3 = Color3.fromRGB(255, 255, 255)
else
_0xbca103.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
_0xbca103.TextColor3 = Color3.fromRGB(235, 235, 235)
end
end
local function _0xf55343() return end
local function _0x01c292()
if not _0x330157 then
if _0x80dc4e then
pcall(function() _0x80dc4e:Destroy() end)
_0x80dc4e = nil
_0xbca103 = nil
end
return
end
local _0xc83c01 = LocalPlayer:FindFirstChildOfClass("PlayerGui")
if not _0xc83c01 then return end
local _0x646fa2 = _0xc83c01:FindFirstChild("NexvyrKillAllBubble")
if _0x646fa2 then pcall(function() _0x646fa2:Destroy() end) end
local _0x8cffb8 = Instance.new("ScreenGui")
_0x8cffb8.Name = "NexvyrKillAllBubble"
_0x8cffb8.ResetOnSpawn = false
_0x8cffb8.IgnoreGuiInset = true
_0x8cffb8.DisplayOrder = 2147483646
_0x8cffb8.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
_0x8cffb8.Parent = _0xc83c01
local _0xc54fff = Instance.new("TextButton")
_0xc54fff.Name = "Button"
_0xc54fff.AnchorPoint = Vector2.new(1, 1)
_0xc54fff.Position = UDim2.new(1, -12, 1, -188)
_0xc54fff.Size = UDim2.new(0, 48, 0, 48)
_0xc54fff.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
_0xc54fff.BorderSizePixel = 0
_0xc54fff.AutoButtonColor = true
_0xc54fff.Font = Enum.Font.GothamBold
_0xc54fff.TextSize = 12
_0xc54fff.TextWrapped = true
_0xc54fff.Text = "KA"
_0xc54fff.TextColor3 = Color3.fromRGB(235, 235, 235)
_0xc54fff.Parent = _0x8cffb8
local _0xc1aac4 = Instance.new("UICorner")
_0xc1aac4.CornerRadius = UDim.new(1, 0)
_0xc1aac4.Parent = _0xc54fff
local _0x900ea8 = Instance.new("UIStroke")
_0x900ea8.Thickness = 1
_0x900ea8.Color = Color3.fromRGB(115, 115, 115)
_0x900ea8.Parent = _0xc54fff
_0x9659b1(_0xc54fff, _0xc54fff, _0xf55343)
_0x80dc4e = _0x8cffb8
_0xbca103 = _0xc54fff
_0xdb12dc()
end
local function _0x065b73()
KillAllInstance.EnforceToken = (KillAllInstance.EnforceToken or 0) + 1
local _0xc9a3d4 = KillAllInstance.EnforceToken
task.spawn(function()
while KillAllInstance.AlwaysOn and _0xc9a3d4 == KillAllInstance.EnforceToken do
if not _0x7f7318 or not KillAllInstance.running then
_0x7f7318 = true
pcall(function() KillAllInstance:Start() end)
end
task.wait(1)
end
end)
end
_0xa9f1eb.Inicio:Section({ Title = "loc:sec_profile" })
local _0x38832a = "Desconocido"
pcall(function()
_0x38832a = identifyexecutor and identifyexecutor() or "Desconocido"
end)
_0xa9f1eb.Inicio:Paragraph({
Title = _0xedd99f("profile_user") .. ": " .. LocalPlayer.DisplayName,
Desc = _0xedd99f("profile_user") .. ": @" .. LocalPlayer.Name
.. "\n" .. _0xedd99f("profile_id") .. ": " .. LocalPlayer.UserId
.. "\n" .. _0xedd99f("profile_age") .. ": " .. LocalPlayer.AccountAge .. " " .. _0xedd99f("profile_days"),
Image = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=420&h=420",
ImageSize = 48
})
_0xa9f1eb.Inicio:Paragraph({
Title = _0xedd99f("profile_system"),
Desc = _0xedd99f("profile_exec") .. ": " .. _0x38832a
})
_0xa9f1eb.Inicio:Paragraph({
Title = _0xedd99f("profile_community"),
Desc = _0xedd99f("profile_actives") .. ": 85",
Image = "rbxthumb://type=Asset&id=118232139384203&w=420&h=420",
ImageSize = 32
})
_0xa9f1eb.Inicio:Section({ Title = "loc:sec_settings" })
_0xa9f1eb.Inicio:Dropdown({
Title = "loc:language",
Values = { "English", "Espanol" },
Value = _0x51daee(),
Callback = function(_0xcb52d0)
local _0x8d53d2 = _0xe3a2ee(_0xcb52d0)
pcall(function()
_0x801a2b:Notify({
Title = _0xedd99f("language"),
Content = _0xedd99f("lang_changed", _0x8d53d2),
Duration = 3,
Icon = "languages"
})
end)
end
})
_0xa9f1eb.Inicio:Section({ Title = "loc:sec_server" })
local _0x00ad8b = "Desconocido"
pcall(function()
_0x00ad8b = MarketplaceService:GetProductInfo(game.PlaceId).Name
end)
_0xa9f1eb.Inicio:Paragraph({
Title = _0xedd99f("profile_game"),
Desc = _0x00ad8b .. "\n" .. _0xedd99f("profile_placeid") .. ": " .. game.PlaceId,
Image = "rbxthumb://type=GameIcon&id=" .. game.GameId .. "&w=150&h=150",
ImageSize = 48
})
_0xa9f1eb.Inicio:Section({ Title = "loc:sec_games" })
local function _0xd75b92(_0xfb6ee7, _0xdedbd5)
if game.PlaceId == _0xfb6ee7 then return end
pcall(function()
if setclipboard then setclipboard("https://www.roblox.com/games/" .. tostring(_0xfb6ee7)) end
end)
task.wait(0.5)
pcall(function() TeleportService:Teleport(_0xfb6ee7, LocalPlayer) end)
end
_0xa9f1eb.Inicio:Button({
Title = "loc:game_mm2",
Callback = function() _0xd75b92(142823291, "MM2") end
})
_0xa9f1eb.Inicio:Button({
Title = "loc:game_duels",
Callback = function() _0xd75b92(135856908115931, "Duels") end
})
_0xa9f1eb.Inicio:Button({
Title = "loc:game_mmv",
Callback = function() _0xd75b92(117973911105557, "MMV") end
})
task.wait()
_0xa9f1eb.Aim:Section({ Title = "loc:sec_autoshoot" })
_0x0cd7ab.TogAutoShoot = _0xa9f1eb.Aim:Toggle({
Title = "loc:aim_autoshoot",
Desc = "loc:aim_autoshoot_desc",
Callback = function(_0xcb52d0)
_0x94448f = _0xcb52d0
if not _0xcb52d0 and not _0x75a1de then
getgenv().NexvyrTargetPart = nil
end
end
})
_0x0cd7ab.TogAutoShootAgr = _0xa9f1eb.Aim:Toggle({
Title = "loc:aim_agresivo",
Desc = "loc:aim_agresivo_desc",
Callback = function(_0xcb52d0)
_0x75a1de = _0xcb52d0
if not _0xcb52d0 and not _0x94448f then
getgenv().NexvyrTargetPart = nil
end
end
})
_0xa9f1eb.Aim:Space()
_0xa9f1eb.Aim:Divider()
_0xa9f1eb.Aim:Space()
_0xa9f1eb.Aim:Section({ Title = "loc:sec_silentaim" })
_0x0cd7ab.TogSilentAimManual = _0xa9f1eb.Aim:Toggle({
Title = "loc:aim_silent",
Desc = "loc:aim_silent_desc",
Callback = function(_0xcb52d0)
_0x7b80fa = _0xcb52d0
if not _0xcb52d0 and not _0x94448f and not _0x75a1de then
getgenv().NexvyrTargetPart = nil
end
end
})
_0x0cd7ab.DropSilentAimPart = _0xa9f1eb.Aim:Dropdown({
Title = "loc:aim_target",
Values = { "Cabeza", "Torso", "Cuerpo Completo" },
Value = "Cabeza",
Callback = function(_0xcb52d0)
TargetPart = _0xcb52d0
end
})
_0x0cd7ab.TogSilentAimFOV = _0xa9f1eb.Aim:Toggle({
Title = "loc:aim_silent_fov",
Desc = "loc:aim_silent_fov_desc",
Callback = function(_0xcb52d0)
_0xdbaa3a = _0xcb52d0
if not _0xcb52d0 and not _0x7b80fa and not _0x94448f and not _0x75a1de then
getgenv().NexvyrTargetPart = nil
end
end
})
_0x0cd7ab.TogShowFOV = _0xa9f1eb.Aim:Toggle({
Title = "loc:aim_show_fov",
Desc = "loc:aim_show_fov_desc",
Callback = function(_0xcb52d0)
_0xf7de2a = _0xcb52d0
end
})
_0x0cd7ab.SliFOVSize = _0xa9f1eb.Aim:Slider({
Title = "loc:aim_fov_size",
Step = 1,
Value = { Min = 10, Max = 800, Default = 120 },
Callback = function(_0x5456c5)
_0x6a47b7 = _0x5456c5
end
})
getgenv().NexvyrTargetPart = nil
local _0x2d01c9
if hookmetamethod and getnamecallmethod and checkcaller then
_0x2d01c9 = hookmetamethod(game, "__namecall", function(self, ...)
local _0xd4bbaf = getnamecallmethod()
if not checkcaller() and getgenv().NexvyrTargetPart then
local _0x0fb13b = getgenv().NexvyrTargetPart
if _0x0fb13b and _0x0fb13b.Parent then
if _0xd4bbaf == "Raycast" and self == workspace then
local _0xc15153, _0xbc1c7e, _0x34ef70 = ...
if typeof(_0xbc1c7e) == "Vector3" and _0xbc1c7e.Magnitude > 20 then
local _0x4bc3e3 = (_0x0fb13b.Position - _0xc15153).Unit * 5000
return _0x2d01c9(self, _0xc15153, _0x4bc3e3, _0x34ef70)
end
elseif string.find(_0xd4bbaf, "FindPartOnRay") and self == workspace then
local _0xbabc78, _0x306df7, _0x34ef70, _0xf92b6d = ...
if typeof(_0xbabc78) == "Ray" and _0xbabc78.Direction.Magnitude > 20 then
local _0x8df99d = Ray.new(_0xbabc78.Origin, (_0x0fb13b.Position - _0xbabc78.Origin).Unit * 5000)
return _0x2d01c9(self, _0x8df99d, _0x306df7, _0x34ef70, _0xf92b6d)
end
end
else
getgenv().NexvyrTargetPart = nil
end
end
return _0x2d01c9(self, ...)
end)
else
warn("Hook de raycast no disponible en este entorno.")
end
task.spawn(function()
local _0x61d8b5 = RaycastParams.new()
_0x61d8b5.FilterType = Enum.RaycastFilterType.Exclude
while task.wait(0.1) do
if _0x94448f or _0x75a1de then
local _0x78a699 = LocalPlayer.Character
if not _0x78a699 or not _0x78a699:FindFirstChild("HumanoidRootPart") then continue end
local _0x12bebd = _0x78a699:FindFirstChildOfClass("Tool")
if not _0x12bebd or not _0x12bebd:FindFirstChild("Handle") then
getgenv().NexvyrTargetPart = nil
continue
end
local _0x234b62 = nil
local _0xedf2b2 = math.huge
local _0x3b1d2e = _0x78a699.HumanoidRootPart.Position
local _0x5f751a = _0x78a699:FindFirstChild("Head") and _0x78a699.Head.Position or _0x3b1d2e
for _0x9b1916, _0x63fce4 in pairs(Players:GetPlayers()) do
if _0x63fce4 ~= LocalPlayer and _0x5b9cc4(_0x63fce4) and _0x63fce4.Character then
local _0xb4bd37 = _0x63fce4.Character:FindFirstChild("Humanoid")
if _0xb4bd37 and _0xb4bd37.Health > 0 then
_0x61d8b5.FilterDescendantsInstances = { _0x78a699, _0x63fce4.Character }
local function _0x193e5a(_0xd2e5af)
local _0x0c758b = (_0xd2e5af.Position - _0x3b1d2e).Magnitude
if _0x0c758b < _0xedf2b2 then
local _0x8ab36c = _0xd2e5af.Size
local _0x4a198a = {
Vector3.new(0, 0, 0),
Vector3.new(_0x8ab36c.X / 2.1, 0, 0),
Vector3.new(-_0x8ab36c.X / 2.1, 0, 0),
Vector3.new(0, _0x8ab36c.Y / 2.1, 0),
Vector3.new(0, -_0x8ab36c.Y / 2.1, 0)
}
local _0x2c0cdd = false
for _0x9b1916, _0x9f99c9 in ipairs(_0x4a198a) do
if not workspace:Raycast(_0x5f751a, (_0xd2e5af.CFrame * _0x9f99c9) - _0x5f751a, _0x61d8b5) then
_0x2c0cdd = true
break
end
end
if _0x2c0cdd then
_0xedf2b2 = _0x0c758b
_0x234b62 = _0xd2e5af
end
end
end
if _0x75a1de then
for _0x9b1916, _0xd2e5af in ipairs(_0x63fce4.Character:GetChildren()) do
if _0xd2e5af:IsA("BasePart") and _0xd2e5af.Name ~= "HumanoidRootPart" then
_0x193e5a(_0xd2e5af)
end
end
else
local _0xf51cd4 = { "Head", "HumanoidRootPart", "UpperTorso", "Torso" }
for _0x9b1916, _0xc54ede in ipairs(_0xf51cd4) do
local _0xd2e5af = _0x63fce4.Character:FindFirstChild(_0xc54ede)
if _0xd2e5af and _0xd2e5af:IsA("BasePart") then _0x193e5a(_0xd2e5af) end
end
end
end
end
end
if _0x234b62 then
getgenv().NexvyrTargetPart = _0x234b62
pcall(function()
_0x12bebd:Activate()
task.delay(0.05, function()
if _0x12bebd.Parent == _0x78a699 then _0x12bebd:Deactivate() end
end)
end)
task.wait(0.2)
else
getgenv().NexvyrTargetPart = nil
end
end
end
end)
task.spawn(function()
local _0x61d8b5 = RaycastParams.new()
_0x61d8b5.FilterType = Enum.RaycastFilterType.Exclude
while task.wait(0.1) do
if _0x7b80fa or _0xdbaa3a then
local _0x78a699 = LocalPlayer.Character
if not _0x78a699 or not _0x78a699:FindFirstChild("HumanoidRootPart") then continue end
local _0x234b62 = nil
local _0x72f51c = math.huge
local _0xa46705 = math.huge
local _0x3b1d2e = _0x78a699.HumanoidRootPart.Position
local _0x5f751a = _0x78a699:FindFirstChild("Head") and _0x78a699.Head.Position or _0x3b1d2e
for _0x9b1916, _0x63fce4 in pairs(Players:GetPlayers()) do
if _0x63fce4 ~= LocalPlayer and _0x5b9cc4(_0x63fce4) and _0x63fce4.Character then
local _0xb4bd37 = _0x63fce4.Character:FindFirstChild("Humanoid")
if _0xb4bd37 and _0xb4bd37.Health > 0 then
local _0x1ad37b = {}
if TargetPart == "Cabeza" then
local _0x3a972a = _0x63fce4.Character:FindFirstChild("Head")
if _0x3a972a then table.insert(_0x1ad37b, _0x3a972a) end
elseif TargetPart == "Torso" then
local _0xf51cd4 = { "UpperTorso", "Torso", "HumanoidRootPart" }
for _0x9b1916, _0xc54ede in ipairs(_0xf51cd4) do
local _0xd2e5af = _0x63fce4.Character:FindFirstChild(_0xc54ede)
if _0xd2e5af and _0xd2e5af:IsA("BasePart") then table.insert(_0x1ad37b, _0xd2e5af) end
end
elseif TargetPart == "Cuerpo Completo" then
for _0x9b1916, _0xd2e5af in ipairs(_0x63fce4.Character:GetChildren()) do
if _0xd2e5af:IsA("BasePart") and _0xd2e5af.Name ~= "HumanoidRootPart" then
table.insert(_0x1ad37b, _0xd2e5af)
end
end
end
_0x61d8b5.FilterDescendantsInstances = { _0x78a699, _0x63fce4.Character }
for _0x9b1916, _0xd2e5af in ipairs(_0x1ad37b) do
local _0x775688 = (_0xd2e5af.Position - _0x3b1d2e).Magnitude
local _0xc88442, _0x69f34d = Camera:WorldToViewportPoint(_0xd2e5af.Position)
local _0x5a7fa9 = (Vector2.new(_0xc88442.X, _0xc88442.Y) - Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)).Magnitude
local _0x2e9c44 = false
if _0xdbaa3a then
if _0x69f34d and _0x5a7fa9 <= _0x6a47b7 and _0x5a7fa9 < _0x72f51c then
_0x2e9c44 = true
end
elseif _0x7b80fa then
if _0x775688 < _0xa46705 then _0x2e9c44 = true end
end
if _0x2e9c44 then
local _0x03393c = workspace:Raycast(_0x5f751a, _0xd2e5af.Position - _0x5f751a, _0x61d8b5)
if not _0x03393c then
if _0xdbaa3a then
_0x72f51c = _0x5a7fa9
_0x234b62 = _0xd2e5af
else
_0xa46705 = _0x775688
_0x234b62 = _0xd2e5af
end
end
end
end
end
end
end
if _0x234b62 then
getgenv().NexvyrTargetPart = _0x234b62
else
if not _0x94448f and not _0x75a1de then
getgenv().NexvyrTargetPart = nil
end
end
end
end
end)
_0xa9f1eb.KillAll:Section({ Title = "loc:sec_killall" })
_0x0cd7ab.TogKillAll = _0xa9f1eb.KillAll:Toggle({
Title = "loc:ka_title",
Desc = "loc:ka_desc",
Value = false,
Callback = function(_0xcb52d0)
_0x7f7318 = false
pcall(function() KillAllInstance:Stop() end)
_0xdb12dc()
end
})
pcall(function()
if _0x0cd7ab.TogKillAll.Lock then _0x0cd7ab.TogKillAll:Lock() end
_0x0cd7ab.TogKillAll.LockedTitle = "Parchado :'v"
end)
_0x0cd7ab.TogKillAllAlwaysOn = _0xa9f1eb.KillAll:Toggle({
Title = "loc:ka_always",
Desc = "loc:ka_always_desc",
Value = false,
Callback = function(_0xcb52d0)
KillAllInstance.AlwaysOn = false
_0x7f7318 = false
pcall(function() KillAllInstance:Stop() end)
_0xdb12dc()
end
})
pcall(function()
if _0x0cd7ab.TogKillAllAlwaysOn.Lock then _0x0cd7ab.TogKillAllAlwaysOn:Lock() end
_0x0cd7ab.TogKillAllAlwaysOn.LockedTitle = "Parchado :'v"
end)
_0xa9f1eb.KillAll:Toggle({
Title = "loc:ka_bubble",
Desc = "loc:ka_bubble_desc",
Value = false,
Callback = function(_0xcb52d0)
_0x330157 = _0xcb52d0
_0x01c292()
end
})
_0xa9f1eb.KillAll:Space()
_0xa9f1eb.KillAll:Section({ Title = "loc:sec_hitbox" })
_0xa9f1eb.KillAll:Toggle({
Title = "loc:hit_activate",
Desc = "loc:hit_activate_desc",
Value = false,
Callback = function(_0xcb52d0)
_0x0bf5a7 = _0xcb52d0
if not _0xcb52d0 then _0x64acf6() end
end
})
_0xa9f1eb.KillAll:Toggle({
Title = "loc:hit_invisible",
Desc = "loc:hit_invisible_desc",
Value = false,
Callback = function(_0xcb52d0) _0xf0b050 = _0xcb52d0 end
})
_0xa9f1eb.KillAll:Slider({
Title = "loc:hit_size",
Step = 0.5,
Value = { Min = 1.0, Max = 50.0, Default = 3.5 },
Callback = function(_0x5456c5) _0x0d5e57 = _0x5456c5 end
})
_0xa9f1eb.KillAll:Colorpicker({
Title = "loc:hit_color",
Default = Color3.fromRGB(255, 0, 0),
Callback = function(_0x09a309) _0xcbf13d = _0x09a309 end
})
_0xa9f1eb.RachaFarm:Section({ Title = "loc:sec_autotp" })
local _0x69b81a
local _0x1aad40
_0x69b81a = _0xa9f1eb.RachaFarm:Toggle({
Title = "loc:atp_main",
Desc = "loc:atp_main_desc",
Value = false,
Callback = function(_0x19ee65)
if _0x19ee65 then
AutoTeleportMainAltInstance.ActiveRole = "Main"
KillAllInstance.activeRole = "Main"
if _0x1aad40 then pcall(function() _0x1aad40:Set(false) end) end
AutoTeleportMainAltInstance:Stop()
AutoTeleportMainAltInstance:Start()
else
if AutoTeleportMainAltInstance.ActiveRole == "Main" then
AutoTeleportMainAltInstance.ActiveRole = nil
KillAllInstance.activeRole = nil
AutoTeleportMainAltInstance:Stop()
end
end
end
})
_0x1aad40 = _0xa9f1eb.RachaFarm:Toggle({
Title = "loc:atp_alt",
Desc = "loc:atp_alt_desc",
Value = false,
Callback = function(_0x19ee65)
if _0x19ee65 then
AutoTeleportMainAltInstance.ActiveRole = "Alt"
KillAllInstance.activeRole = "Alt"
if _0x69b81a then pcall(function() _0x69b81a:Set(false) end) end
AutoTeleportMainAltInstance:Stop()
AutoTeleportMainAltInstance:Start()
else
if AutoTeleportMainAltInstance.ActiveRole == "Alt" then
AutoTeleportMainAltInstance.ActiveRole = nil
KillAllInstance.activeRole = nil
AutoTeleportMainAltInstance:Stop()
end
end
end
})
_0xa9f1eb.RachaFarm:Dropdown({
Title = "loc:atp_type",
Values = { "1v1", "2v2", "3v3", "4v4" },
Value = "1v1",
Callback = function(_0x19ee65)
if _0x208292["Right Platforms"][_0x19ee65] then
AutoTeleportMainAltInstance.DuelType = _0x19ee65
else
AutoTeleportMainAltInstance.DuelType = "1v1"
end
AutoTeleportMainAltInstance:Kick()
end
})
_0xa9f1eb.RachaFarm:Dropdown({
Title = "loc:atp_row",
Values = { "Right Platforms", "Left Platforms" },
Value = "Right Platforms",
Callback = function(_0x19ee65)
if _0x208292[_0x19ee65] then
AutoTeleportMainAltInstance.PlatformRow = _0x19ee65
else
AutoTeleportMainAltInstance.PlatformRow = "Right Platforms"
end
AutoTeleportMainAltInstance:Kick()
end
})
_0xa9f1eb.RachaFarm:Space()
_0xa9f1eb.RachaFarm:Divider()
_0xa9f1eb.RachaFarm:Space()
_0xa9f1eb.RachaFarm:Toggle({
Title = "loc:rs_break",
Desc = "loc:rs_break_desc",
Value = false,
Callback = function(_0x19ee65) a8_breakStreakEnabled = _0x19ee65 end
})
_0xa9f1eb.RachaFarm:Slider({
Title = "loc:rs_target",
Step = 1,
Value = { Min = 0, Max = 500, Default = 1 },
Callback = function(_0x19ee65) a8_breakStreakTarget = _0x19ee65 end
})
_0xa9f1eb.RachaFarm:Space()
_0xa9f1eb.RachaFarm:Toggle({
Title = "loc:rs_lower",
Desc = "loc:rs_lower_desc",
Value = false,
Callback = function(_0x19ee65) a8_lowerKDEnabled = _0x19ee65 end
})
_0xa9f1eb.RachaFarm:Slider({
Title = "loc:rs_kd",
Step = 1,
Value = { Min = 0, Max = 4, Default = 4 },
Callback = function(_0x19ee65) a8_kdTargetKills = _0x19ee65 end
})
_0xa9f1eb.Vis:Section({ Title = "loc:sec_esp_cfg" })
_0x0cd7ab.TogEsp = _0xa9f1eb.Vis:Toggle({
Title = "loc:esp_toggle",
Callback = function(_0x5d245a) _0xd33699 = _0x5d245a end
})
_0x0cd7ab.ColEsp = _0xa9f1eb.Vis:Colorpicker({
Title = "loc:esp_color",
Default = Color3.fromRGB(255, 255, 255),
Callback = function(_0x09a309) _0xd9b476 = _0x09a309 end
})
_0xa9f1eb.Vis:Section({ Title = "loc:sec_esp_filters" })
_0x0cd7ab.TogEspGl = _0xa9f1eb.Vis:Toggle({
Title = "loc:esp_glow",
Callback = function(_0x5d245a) _0x8607ac.Glow = _0x5d245a end
})
_0x0cd7ab.TogEspLines = _0xa9f1eb.Vis:Toggle({
Title = "loc:esp_lines",
Callback = function(_0x5d245a) _0xa6311d = _0x5d245a end
})
local _0xa94295 = {}
local _0x46d359 = 1500
local _0xdce451 = {}
local function _0xf2f2f1(_0x461e30)
if _0xa94295[_0x461e30] then
if _0xa94295[_0x461e30].Highlight then
_0xa94295[_0x461e30].Highlight:Destroy()
end
_0xa94295[_0x461e30] = nil
end
end
task.spawn(function()
while task.wait(0.2) do
if _0xd33699 then
local _0xac7c17 = LocalPlayer.Character
local _0xfd725c = _0xac7c17 and _0xac7c17:FindFirstChild("Head")
local _0x3b1d2e = _0xfd725c and _0xfd725c.Position
for _0x9b1916, _0x63fce4 in pairs(Players:GetPlayers()) do
if _0x63fce4 ~= LocalPlayer then
local _0x78a699 = _0x63fce4.Character
if _0x78a699 and _0x78a699:FindFirstChild("Humanoid") and _0x78a699.Humanoid.Health > 0
and _0x78a699:FindFirstChild("Head") and _0x5b9cc4(_0x63fce4) then
local _0x5f3de3 = _0x78a699.Head
local _0x0c758b = _0x3b1d2e and (_0x5f3de3.Position - _0x3b1d2e).Magnitude or 0
if _0x0c758b <= _0x46d359 then
if _0xa94295[_0x63fce4] and _0xa94295[_0x63fce4].Char ~= _0x78a699 then _0xf2f2f1(_0x63fce4) end
if not _0xa94295[_0x63fce4] then
local _0x5ba83f = Instance.new("Highlight")
_0x5ba83f.Name = _0x63fce4.Name .. "_Glow"
_0x5ba83f.FillTransparency = 1
_0x5ba83f.OutlineTransparency = 0
_0x5ba83f.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
_0x5ba83f.Adornee = _0x78a699
_0x5ba83f.Parent = ESPFolder
_0xa94295[_0x63fce4] = { Highlight = _0x5ba83f, Char = _0x78a699 }
end
local _0x5c376c = _0xa94295[_0x63fce4]
if _0x5c376c.Highlight.Enabled ~= _0x8607ac.Glow then
_0x5c376c.Highlight.Enabled = _0x8607ac.Glow
end
if _0x5c376c.Highlight.OutlineColor ~= _0xd9b476 then
_0x5c376c.Highlight.OutlineColor = _0xd9b476
end
else
_0xf2f2f1(_0x63fce4)
end
else
_0xf2f2f1(_0x63fce4)
end
end
end
else
for _0x9b1916, _0x63fce4 in pairs(Players:GetPlayers()) do _0xf2f2f1(_0x63fce4) end
end
end
end)
local _0xa720b8 = nil
if Drawing then
_0xa720b8 = Drawing.new("Circle")
_0xa720b8.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
_0xa720b8.Radius = _0x6a47b7
_0xa720b8.Filled = false
_0xa720b8.Color = Color3.fromRGB(255, 255, 255)
_0xa720b8.Visible = false
_0xa720b8.Thickness = 1
end
RunService.RenderStepped:Connect(function()
if _0xf7de2a and _0xa720b8 then
_0xa720b8.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
_0xa720b8.Radius = _0x6a47b7
_0xa720b8.Visible = true
if _0xdbaa3a and getgenv().NexvyrTargetPart then
_0xa720b8.Color = Color3.fromRGB(0, 255, 0)
else
_0xa720b8.Color = Color3.fromRGB(255, 255, 255)
end
elseif _0xa720b8 then
_0xa720b8.Visible = false
end
if not _0xd33699 or not _0xa6311d then
for _0x9b1916, _0x1e1f81 in pairs(_0xdce451) do
if _0x1e1f81.Visible then _0x1e1f81.Visible = false end
end
return
end
local _0xac7c17 = LocalPlayer.Character
local _0x3b1d2e = (_0xac7c17 and _0xac7c17.PrimaryPart) and _0xac7c17.PrimaryPart.Position or Camera.CFrame.Position
local _0x6e1936 = Camera.ViewportSize.X / 2
for _0x9b1916, _0x63fce4 in pairs(Players:GetPlayers()) do
if _0x63fce4 ~= LocalPlayer then
local _0x1e1f81 = _0xdce451[_0x63fce4]
if not _0x1e1f81 then
if Drawing then
_0x1e1f81 = Drawing.new("Line")
_0x1e1f81.Thickness = 1.5
_0x1e1f81.Transparency = 1
_0x1e1f81.Visible = false
_0xdce451[_0x63fce4] = _0x1e1f81
else
break
end
end
local _0x78a699 = _0x63fce4.Character
local _0x25b0aa = _0x78a699 and _0x78a699.PrimaryPart
if _0x25b0aa and _0x5b9cc4(_0x63fce4) then
local _0x84e7d7 = _0x78a699:FindFirstChild("Humanoid")
if _0x84e7d7 and _0x84e7d7.Health > 0 then
local _0x32d919, _0x69f34d = Camera:WorldToViewportPoint(_0x25b0aa.Position)
if _0x69f34d then
local _0x0c758b = (_0x3b1d2e - _0x25b0aa.Position).Magnitude
if _0x0c758b <= _0x46d359 then
if _0x1e1f81.From.X ~= _0x6e1936 then
_0x1e1f81.From = Vector2.new(_0x6e1936, 0)
end
_0x1e1f81.To = Vector2.new(_0x32d919.X, _0x32d919.Y)
if _0x1e1f81.Color ~= _0xd9b476 then _0x1e1f81.Color = _0xd9b476 end
if not _0x1e1f81.Visible then _0x1e1f81.Visible = true end
continue
end
end
end
end
if _0x1e1f81 and _0x1e1f81.Visible then _0x1e1f81.Visible = false end
end
end
end)
Players.PlayerRemoving:Connect(function(_0x63fce4)
if _0xdce451[_0x63fce4] then
_0xdce451[_0x63fce4]:Remove()
_0xdce451[_0x63fce4] = nil
end
_0xf2f2f1(_0x63fce4)
end)
_0xa9f1eb.Farm:Section({ Title = "loc:sec_farm_event" })
getgenv().AutoEventFarm = false
local _0x7aab10 = ReplicatedStorage:FindFirstChild("Packages") and ReplicatedStorage.Packages:FindFirstChild("Networking")
local _0x619d2f = _0x7aab10 and _0x7aab10:FindFirstChild("RE/Events/CollectEventSpawnable")
_0xa9f1eb.Farm:Toggle({
Title = "loc:farm_event",
Callback = function(_0x5d245a)
getgenv().AutoEventFarm = _0x5d245a
if _0x5d245a then
task.spawn(function()
while getgenv().AutoEventFarm do
pcall(function()
if _0x619d2f then
_0x619d2f:FireServer()
else
_0x7aab10 = ReplicatedStorage:FindFirstChild("Packages") and ReplicatedStorage.Packages:FindFirstChild("Networking")
_0x619d2f = _0x7aab10 and _0x7aab10:FindFirstChild("RE/Events/CollectEventSpawnable")
end
end)
task.wait(0.05)
end
end)
end
end
})
_0xa9f1eb.Graficos:Section({ Title = "loc:sec_visuals" })
local _0x4d78fc = {}
local _0xfa176c = false
local _0x60e6a3 = 1
local _0x5afc51 = 34
local function _0x054cf6()
if _0x4d78fc.saved then return end
_0x4d78fc.Brightness = Lighting.Brightness
_0x4d78fc.ColorShift_Bottom = Lighting.ColorShift_Bottom
_0x4d78fc.ColorShift_Top = Lighting.ColorShift_Top
_0x4d78fc.OutdoorAmbient = Lighting.OutdoorAmbient
_0x4d78fc.ClockTime = Lighting.ClockTime
_0x4d78fc.FogColor = Lighting.FogColor
_0x4d78fc.FogEnd = Lighting.FogEnd
_0x4d78fc.ExposureCompensation = Lighting.ExposureCompensation
_0x4d78fc.ShadowSoftness = Lighting.ShadowSoftness
_0x4d78fc.Ambient = Lighting.Ambient
_0x4d78fc.saved = true
end
local function _0x5f9b40()
for _0x9b1916, _0x5456c5 in ipairs(_0x1eaab4) do
pcall(function() _0x5456c5:Destroy() end)
end
table.clear(_0x1eaab4)
end
local function _0xeffb70()
_0x054cf6()
_0x5f9b40()
local _0xc2cbd3 = Instance.new("BloomEffect")
_0xc2cbd3.Name = "Atardecer_Bloom"
_0xc2cbd3.Intensity = 0.1 * _0x60e6a3
_0xc2cbd3.Threshold = 0
_0xc2cbd3.Size = 100
_0xc2cbd3.Parent = Lighting
table.insert(_0x1eaab4, _0xc2cbd3)
local _0xc4608b = Instance.new("Sky")
_0xc4608b.SkyboxUp = "http://www.roblox.com/asset/?id=196263782"
_0xc4608b.SkyboxLf = "http://www.roblox.com/asset/?id=196263721"
_0xc4608b.SkyboxBk = "http://www.roblox.com/asset/?id=196263721"
_0xc4608b.SkyboxFt = "http://www.roblox.com/asset/?id=196263721"
_0xc4608b.CelestialBodiesShown = false
_0xc4608b.SkyboxDn = "http://www.roblox.com/asset/?id=196263643"
_0xc4608b.SkyboxRt = "http://www.roblox.com/asset/?id=196263721"
_0xc4608b.Parent = Lighting
table.insert(_0x1eaab4, _0xc4608b)
local _0x7f3578 = Instance.new("BlurEffect")
_0x7f3578.Size = 2
_0x7f3578.Parent = Lighting
table.insert(_0x1eaab4, _0x7f3578)
local _0x042c5f = Instance.new("ColorCorrectionEffect")
_0x042c5f.Saturation = 0.05
_0x042c5f.TintColor = Color3.fromRGB(255, 224, 219)
_0x042c5f.Parent = Lighting
table.insert(_0x1eaab4, _0x042c5f)
local _0xaa9b82 = Instance.new("SunRaysEffect")
_0xaa9b82.Name = "Atardecer_SunRays"
_0xaa9b82.Intensity = 0.05 * _0x60e6a3
_0xaa9b82.Parent = Lighting
table.insert(_0x1eaab4, _0xaa9b82)
Lighting.Brightness = 2.14 * _0x60e6a3
Lighting.ColorShift_Bottom = Color3.fromRGB(11, 0, 20)
Lighting.ColorShift_Top = Color3.fromRGB(240, 127, 14)
Lighting.OutdoorAmbient = Color3.fromRGB(_0x5afc51, 0, _0x5afc51 + 15)
Lighting.ClockTime = 6.7
Lighting.FogColor = Color3.fromRGB(94, 76, 106)
Lighting.FogEnd = 1000
Lighting.ExposureCompensation = 0.24
Lighting.ShadowSoftness = 0
Lighting.Ambient = Color3.fromRGB(59, 33, 27)
end
local function _0x58229f()
if not _0x4d78fc.saved then return end
Lighting.Brightness = _0x4d78fc.Brightness
Lighting.ColorShift_Bottom = _0x4d78fc.ColorShift_Bottom
Lighting.ColorShift_Top = _0x4d78fc.ColorShift_Top
Lighting.OutdoorAmbient = _0x4d78fc.OutdoorAmbient
Lighting.ClockTime = _0x4d78fc.ClockTime
Lighting.FogColor = _0x4d78fc.FogColor
Lighting.FogEnd = _0x4d78fc.FogEnd
Lighting.ExposureCompensation = _0x4d78fc.ExposureCompensation
Lighting.ShadowSoftness = _0x4d78fc.ShadowSoftness
Lighting.Ambient = _0x4d78fc.Ambient
_0x5f9b40()
end
_0x0cd7ab.TogTokyowami = _0xa9f1eb.Graficos:Toggle({
Title = "loc:gfx_sunset",
Callback = function(_0xcb52d0)
_0xfa176c = _0xcb52d0
if _0xcb52d0 then _0xeffb70() else _0x58229f() end
end
})
_0xa9f1eb.Graficos:Slider({
Title = "loc:gfx_sunset_int",
Desc = "loc:gfx_sunset_int_desc",
Step = 0.1,
Value = { Min = 0, Max = 2, Default = 1 },
Callback = function(_0x5456c5)
_0x60e6a3 = _0x5456c5
if _0xfa176c then
for _0x9b1916, _0x336a26 in ipairs(_0x1eaab4) do
if _0x336a26.Name == "Atardecer_Bloom" then
_0x336a26.Intensity = 0.1 * _0x5456c5
elseif _0x336a26.Name == "Atardecer_SunRays" then
_0x336a26.Intensity = 0.05 * _0x5456c5
end
end
Lighting.Brightness = 2.14 * _0x5456c5
end
end
})
_0xa9f1eb.Graficos:Slider({
Title = "loc:gfx_sunset_clar",
Desc = "loc:gfx_sunset_clar_desc",
Step = 1,
Value = { Min = 10, Max = 100, Default = 34 },
Callback = function(_0x5456c5)
_0x5afc51 = _0x5456c5
if _0xfa176c then
Lighting.OutdoorAmbient = Color3.fromRGB(_0x5456c5, 0, _0x5456c5 + 15)
end
end
})
local _0x41ea3f = {}
local _0xb0bc96 = {}
local _0x2996d3 = false
local function _0x9df8e9()
if _0x41ea3f.saved then return end
_0x41ea3f.Brightness = Lighting.Brightness
_0x41ea3f.ClockTime = Lighting.ClockTime
_0x41ea3f.FogColor = Lighting.FogColor
_0x41ea3f.FogEnd = Lighting.FogEnd
_0x41ea3f.FogStart = Lighting.FogStart
_0x41ea3f.Ambient = Lighting.Ambient
_0x41ea3f.OutdoorAmbient = Lighting.OutdoorAmbient
_0x41ea3f.ExposureCompensation = Lighting.ExposureCompensation
_0x41ea3f.ShadowSoftness = Lighting.ShadowSoftness
_0x41ea3f.EnvironmentDiffuseScale = Lighting.EnvironmentDiffuseScale
_0x41ea3f.EnvironmentSpecularScale = Lighting.EnvironmentSpecularScale
_0x41ea3f.saved = true
end
local function _0x6b16f0()
for _0x9b1916, _0x5456c5 in ipairs(_0xb0bc96) do
pcall(function() _0x5456c5:Destroy() end)
end
table.clear(_0xb0bc96)
end
local function _0xd74cdd()
_0x9df8e9()
_0x6b16f0()
Lighting.ClockTime = 2.5
Lighting.Brightness = 3
Lighting.Ambient = Color3.fromRGB(140, 140, 150)
Lighting.OutdoorAmbient = Color3.fromRGB(130, 130, 145)
Lighting.FogColor = Color3.fromRGB(80, 85, 105)
Lighting.FogStart = 50
Lighting.FogEnd = 800
Lighting.ExposureCompensation = 0.15
Lighting.ShadowSoftness = 0.15
Lighting.EnvironmentDiffuseScale = 0.6
Lighting.EnvironmentSpecularScale = 0.6
local _0xdf59e7 = workspace.Terrain:FindFirstChildOfClass("Clouds")
if not _0xdf59e7 then
_0xdf59e7 = Instance.new("Clouds")
_0xdf59e7.Parent = workspace.Terrain
end
if not _0xdf59e7:GetAttribute("OrigDensity") then
_0xdf59e7:SetAttribute("OrigDensity", _0xdf59e7.Density)
_0xdf59e7:SetAttribute("OrigCover", _0xdf59e7.Cover)
end
_0xdf59e7.Density = 0.4
_0xdf59e7.Cover = 0.5
local _0x4f8585 = Instance.new("Sky")
_0x4f8585.MoonTextureId = "rbxasset://sky/moon.jpg"
_0x4f8585.MoonAngularSize = 25
_0x4f8585.StarCount = 3000
_0x4f8585.SunTextureId = _0xb872a2({})
_0x4f8585.SunAngularSize = 0
_0x4f8585.CelestialBodiesShown = true
_0x4f8585.Parent = Lighting
table.insert(_0xb0bc96, _0x4f8585)
local _0x730491 = Instance.new("BloomEffect")
_0x730491.Name = "Nexvyr_Bloom"
_0x730491.Intensity = 0.35
_0x730491.Size = 24
_0x730491.Threshold = 1.2
_0x730491.Parent = Lighting
table.insert(_0xb0bc96, _0x730491)
local _0xd58652 = Instance.new("SunRaysEffect")
_0xd58652.Name = "Nexvyr_Rays"
_0xd58652.Intensity = 0.05
_0xd58652.Spread = 1
_0xd58652.Parent = Lighting
table.insert(_0xb0bc96, _0xd58652)
local _0xa619ad = Instance.new("ColorCorrectionEffect")
_0xa619ad.Name = "Nexvyr_Color"
_0xa619ad.TintColor = Color3.fromRGB(210, 215, 255)
_0xa619ad.Brightness = 0.02
_0xa619ad.Contrast = 0.05
_0xa619ad.Saturation = -0.05
_0xa619ad.Parent = Lighting
table.insert(_0xb0bc96, _0xa619ad)
local _0x0f521a = Instance.new("Atmosphere")
_0x0f521a.Name = "Nexvyr_Atmo"
_0x0f521a.Density = 0.2
_0x0f521a.Offset = 0.3
_0x0f521a.Color = Color3.fromRGB(180, 185, 195)
_0x0f521a.Decay = Color3.fromRGB(90, 95, 110)
_0x0f521a.Glare = 0.15
_0x0f521a.Haze = 1
_0x0f521a.Parent = Lighting
table.insert(_0xb0bc96, _0x0f521a)
for _0x9b1916, _0x5456c5 in ipairs(workspace:GetDescendants()) do
if _0x5456c5:IsA("PointLight") or _0x5456c5:IsA("SpotLight") or _0x5456c5:IsA("SurfaceLight") then
if not _0x5456c5:GetAttribute("OrigBrightness") then
_0x5456c5:SetAttribute("OrigBrightness", _0x5456c5.Brightness)
end
_0x5456c5.Brightness = _0x5456c5:GetAttribute("OrigBrightness") * 1.5
end
if _0x5456c5:IsA("BasePart") and _0x5456c5.Material == Enum.Material.Neon then
if not _0x5456c5:FindFirstChild("Nexvyr_Glow") then
local _0x2e8854 = Instance.new("PointLight")
_0x2e8854.Name = "Nexvyr_Glow"
_0x2e8854.Color = _0x5456c5.Color
_0x2e8854.Brightness = 1
_0x2e8854.Range = 8
_0x2e8854.Shadows = false
_0x2e8854.Parent = _0x5456c5
end
end
end
end
local function _0x07b573()
if not _0x41ea3f.saved then return end
Lighting.Brightness = _0x41ea3f.Brightness
Lighting.ClockTime = _0x41ea3f.ClockTime
Lighting.FogColor = _0x41ea3f.FogColor
Lighting.FogEnd = _0x41ea3f.FogEnd
Lighting.FogStart = _0x41ea3f.FogStart
Lighting.Ambient = _0x41ea3f.Ambient
Lighting.OutdoorAmbient = _0x41ea3f.OutdoorAmbient
Lighting.ExposureCompensation = _0x41ea3f.ExposureCompensation
Lighting.ShadowSoftness = _0x41ea3f.ShadowSoftness
Lighting.EnvironmentDiffuseScale = _0x41ea3f.EnvironmentDiffuseScale
Lighting.EnvironmentSpecularScale = _0x41ea3f.EnvironmentSpecularScale
_0x6b16f0()
local _0xdf59e7 = workspace.Terrain:FindFirstChildOfClass("Clouds")
if _0xdf59e7 and _0xdf59e7:GetAttribute("OrigDensity") then
_0xdf59e7.Density = _0xdf59e7:GetAttribute("OrigDensity")
_0xdf59e7.Cover = _0xdf59e7:GetAttribute("OrigCover")
end
for _0x9b1916, _0x5456c5 in ipairs(workspace:GetDescendants()) do
if _0x5456c5:IsA("PointLight") or _0x5456c5:IsA("SpotLight") or _0x5456c5:IsA("SurfaceLight") then
if _0x5456c5:GetAttribute("OrigBrightness") then
_0x5456c5.Brightness = _0x5456c5:GetAttribute("OrigBrightness")
end
end
if _0x5456c5:FindFirstChild("Nexvyr_Glow") then
_0x5456c5:FindFirstChild("Nexvyr_Glow"):Destroy()
end
end
end
_0xa9f1eb.Graficos:Section({ Title = "loc:sec_night" })
_0xa9f1eb.Graficos:Toggle({
Title = "loc:gfx_night",
Desc = "loc:gfx_night_desc",
Value = false,
Callback = function(_0x737f2e)
_0x2996d3 = _0x737f2e
if _0x737f2e then _0xd74cdd() else _0x07b573() end
end
})
_0xa9f1eb.Graficos:Slider({
Title = "loc:gfx_night_glow",
Desc = "loc:gfx_night_glow_desc",
Step = 0.1,
Value = { Min = 0, Max = 2, Default = 0.35 },
Callback = function(_0x5456c5)
for _0x9b1916, _0x336a26 in ipairs(_0xb0bc96) do
if _0x336a26.Name == "Nexvyr_Bloom" then
_0x336a26.Intensity = _0x5456c5
end
end
end
})
_0xa9f1eb.Graficos:Slider({
Title = "loc:gfx_night_clar",
Desc = "loc:gfx_night_clar_desc",
Step = 1,
Value = { Min = 100, Max = 200, Default = 130 },
Callback = function(_0x5456c5)
if _0x2996d3 then
Lighting.OutdoorAmbient = Color3.fromRGB(_0x5456c5, _0x5456c5, _0x5456c5 + 10)
Lighting.Ambient = Color3.fromRGB(_0x5456c5 + 10, _0x5456c5 + 10, _0x5456c5 + 15)
end
end
})
_0xa9f1eb.Graficos:Section({ Title = "loc:sec_perf" })
local _0x25a779 = false
local _0xf3e4b2 = nil
local _0x2be271 = true
local _0x92e62a = 100000
local _0x378226 = 1
_0x0cd7ab.ToggleFPS = _0xa9f1eb.Graficos:Toggle({
Title = "loc:gfx_fps",
Value = false,
Callback = function(_0x737f2e)
_0x25a779 = _0x737f2e
local Lighting = game:GetService("Lighting")
local _0x8eb9b1 = workspace:FindFirstChildOfClass("Terrain")
local _0x2359cf = Lighting:FindFirstChild("NexvyrPBRCache")
if not _0x2359cf then
_0x2359cf = Instance.new("Folder")
_0x2359cf.Name = "NexvyrPBRCache"
_0x2359cf.Parent = Lighting
end
if _0x737f2e then
_0x2be271 = Lighting.GlobalShadows
_0x92e62a = Lighting.FogEnd
_0x378226 = Lighting.ShadowSoftness
Lighting.GlobalShadows = false
Lighting.FogEnd = 9e9
Lighting.ShadowSoftness = 0
if _0x8eb9b1 then
pcall(function()
if not _0x8eb9b1:GetAttribute("OrigWaveSize") then
_0x8eb9b1:SetAttribute("OrigWaveSize", _0x8eb9b1.WaterWaveSize)
_0x8eb9b1:SetAttribute("OrigDeco", _0x8eb9b1.Decoration)
end
_0x8eb9b1.WaterWaveSize = 0
_0x8eb9b1.WaterWaveSpeed = 0
_0x8eb9b1.WaterReflectance = 0
_0x8eb9b1.WaterTransparency = 1
_0x8eb9b1.Decoration = false
end)
end
local function _0x5a9f04(_0x5456c5)
if not _0x5456c5:IsA("BasePart") and not _0x5456c5:IsA("Decal") and not _0x5456c5:IsA("Texture")
and not _0x5456c5:IsA("SpecialMesh") and not _0x5456c5:IsA("Light") and not _0x5456c5:IsA("PostEffect") then
return
end
pcall(function()
if _0x5456c5:IsA("ScreenGui") then return end
if _0x5456c5.Parent and _0x5456c5.Parent:FindFirstChild("Humanoid") then return end
if _0x5456c5:IsA("BasePart") and not _0x5456c5:IsA("Terrain") then
if not _0x5456c5:GetAttribute("OrigMat") then
_0x5456c5:SetAttribute("OrigMat", _0x5456c5.Material.Name)
_0x5456c5:SetAttribute("OrigCast", _0x5456c5.CastShadow)
end
_0x5456c5.Material = Enum.Material.SmoothPlastic
_0x5456c5.Reflectance = 0
_0x5456c5.CastShadow = false
if _0x5456c5:IsA("MeshPart") then
if not _0x5456c5:GetAttribute("OrigTex") then
_0x5456c5:SetAttribute("OrigTex", _0x5456c5.TextureID)
end
_0x5456c5.TextureID = _0xb872a2({})
end
elseif _0x5456c5:IsA("SpecialMesh") then
if not _0x5456c5:GetAttribute("OrigTex") then
_0x5456c5:SetAttribute("OrigTex", _0x5456c5.TextureId)
end
_0x5456c5.TextureId = _0xb872a2({})
elseif _0x5456c5:IsA("Decal") or _0x5456c5:IsA("Texture") then
if not _0x5456c5:GetAttribute("OrigTrans") then
_0x5456c5:SetAttribute("OrigTrans", _0x5456c5.Transparency)
end
_0x5456c5.Transparency = 1
elseif _0x5456c5:IsA("Light") or _0x5456c5:IsA("PostEffect") then
if _0x5456c5:GetAttribute("OrigEnabled") == nil then
_0x5456c5:SetAttribute("OrigEnabled", _0x5456c5.Enabled)
end
_0x5456c5.Enabled = false
end
end)
end
task.spawn(function()
local _0x34bf1e = 0
for _0x9b1916, _0x5456c5 in pairs(workspace:GetDescendants()) do
_0x5a9f04(_0x5456c5)
_0x34bf1e = _0x34bf1e + 1
if _0x34bf1e % 300 == 0 then task.wait() end
end
end)
if not _0xf3e4b2 then
_0xf3e4b2 = workspace.DescendantAdded:Connect(function(_0x5456c5)
if _0x25a779 then _0x5a9f04(_0x5456c5) end
end)
end
else
Lighting.GlobalShadows = _0x2be271
Lighting.FogEnd = _0x92e62a
Lighting.ShadowSoftness = _0x378226
if _0x8eb9b1 and _0x8eb9b1:GetAttribute("OrigWaveSize") then
pcall(function()
_0x8eb9b1.WaterWaveSize = _0x8eb9b1:GetAttribute("OrigWaveSize")
_0x8eb9b1.Decoration = _0x8eb9b1:GetAttribute("OrigDeco")
end)
end
task.spawn(function()
local _0x34bf1e = 0
for _0x9b1916, _0x5456c5 in pairs(workspace:GetDescendants()) do
pcall(function()
if _0x5456c5:IsA("BasePart") and _0x5456c5:GetAttribute("OrigMat") then
local _0x2b4774 = _0x5456c5:GetAttribute("OrigMat")
if Enum.Material[_0x2b4774] then _0x5456c5.Material = Enum.Material[_0x2b4774] end
_0x5456c5.CastShadow = _0x5456c5:GetAttribute("OrigCast")
if _0x5456c5:IsA("MeshPart") and _0x5456c5:GetAttribute("OrigTex") then
_0x5456c5.TextureID = _0x5456c5:GetAttribute("OrigTex")
end
elseif _0x5456c5:IsA("SpecialMesh") and _0x5456c5:GetAttribute("OrigTex") then
_0x5456c5.TextureId = _0x5456c5:GetAttribute("OrigTex")
elseif (_0x5456c5:IsA("Decal") or _0x5456c5:IsA("Texture")) and _0x5456c5:GetAttribute("OrigTrans") then
_0x5456c5.Transparency = _0x5456c5:GetAttribute("OrigTrans")
elseif (_0x5456c5:IsA("Light") or _0x5456c5:IsA("PostEffect")) and _0x5456c5:GetAttribute("OrigEnabled") ~= nil then
_0x5456c5.Enabled = _0x5456c5:GetAttribute("OrigEnabled")
end
end)
_0x34bf1e = _0x34bf1e + 1
if _0x34bf1e % 300 == 0 then task.wait() end
end
for _0x9b1916, _0x5456c5 in pairs(_0x2359cf:GetChildren()) do
pcall(function()
if _0x5456c5:GetAttribute("OrigParent") then _0x5456c5.Parent = _0x5456c5:GetAttribute("OrigParent") end
end)
end
end)
if _0xf3e4b2 then
_0xf3e4b2:Disconnect()
_0xf3e4b2 = nil
end
end
end
})
local _0x31093e = {
["Old School"] = { Walk = 10921244891, Run = 10921240218, Jump = 10921242013, Fall = 10921241244, SwimIdle = 10921244018, Swim = 10921243048, Idle = 10921230744, Idle2 = 10921232093, Climb = 10921229866 },
["Adidas Sports"] = { Walk = 18537392113, Run = 18537384940, Jump = 18537380791, Fall = 18537367238, SwimIdle = 18537387180, Swim = 18537389531, Idle = 18537376492, Idle2 = 18537371272, Climb = 18537363391 },
["Adidas Community"] = { Walk = 122150855457006, Run = 82598234841035, Jump = 75290611992385, Fall = 98600215928904, SwimIdle = 109346520324160, Swim = 133308483266208, Idle = 122257458498464, Idle2 = 102357151005774, Climb = 88763136693023 },
["Adidas Aura"] = { Walk = 83842218823011, Run = 118320322718866, Jump = 109996626521204, Fall = 95603166884636, SwimIdle = 94922130551805, Swim = 134530128383903, Idle = 110211186840347, Idle2 = 114191137265065, Climb = 97824616490448 },
["Wicked Popular"] = { Walk = 92072849924640, Run = 72301599441680, Jump = 104325245285198, Fall = 121152442762481, Idle = 118832222982049, Idle2 = 76049494037641, SwimIdle = 113199415118199, Swim = 99384245425157, Climb = 131326830509784 },
["Elder"] = { Walk = 10921111375, Run = 10921104374, Jump = 10921107367, Fall = 10921105765, SwimIdle = 10921110146, Swim = 10921108971, Idle = 10921101664, Idle2 = 10921102574, Climb = 10921100400 },
["Zombie"] = { Walk = 10921355261, Run = 616163682, Jump = 10921351278, Fall = 10921350320, SwimIdle = 10921353442, Swim = 10921352344, Idle = 10921344533, Idle2 = 10921345304, Climb = 10921343576 },
["Mage"] = { Walk = 10921152678, Run = 10921148209, Jump = 10921149743, Fall = 10921148939, SwimIdle = 10921151661, Swim = 10921150788, Idle = 10921144709, Idle2 = 10921145797, Climb = 10921143404 },
["Catwalk Glam"] = { Walk = 109168724482748, Run = 81024476153754, Jump = 116936326516985, Fall = 92294537340807, SwimIdle = 98854111361360, Swim = 134591743181628, Idle = 133806214992291, Idle2 = 94970088341563, Climb = 119377220967554 },
["Astronaut"] = { Walk = 10921046031, Run = 10921039308, Jump = 10921042494, Fall = 10921040576, SwimIdle = 10921045006, Swim = 10921044000, Idle = 10921034824, Idle2 = 10921036806, Climb = 10921032124 },
["Wicked \"Dancing Through Life\""] = { Walk = 73718308412641, Run = 135515454877967, Jump = 78508480717326, Fall = 78147885297412, SwimIdle = 129183123083281, Swim = 110657013921774, Idle = 92849173543269, Idle2 = 132238900951109, Climb = 129447497744818 },
["Werewolf"] = { Walk = 10921342074, Run = 10921336997, Fall = 10921337907, SwimIdle = 10921341319, Swim = 10921340419, Idle = 10921330408, Idle2 = 10921333667, Climb = 10921329322 },
["Superhero"] = { Walk = 10921298616, Run = 10921291831, Jump = 10921294559, Fall = 10921293373, SwimIdle = 10921297391, Swim = 10921295495, Idle = 10921288909, Idle2 = 10921290167, Climb = 10921286911 },
["Toy"] = { Walk = 10921312010, Run = 10921306285, Jump = 10921308158, Fall = 10921307241, SwimIdle = 10921310341, Swim = 10921309319, Idle = 10921301576, Climb = 10921300839 },
["No Boundaries"] = { Walk = 18747074203, Run = 18747070484, Jump = 18747069148, Fall = 18747062535, SwimIdle = 18747071682, Swim = 18747073181, Idle = 18747067405, Idle2 = 18747063918, Climb = 18747060903 },
["NFL"] = { Walk = 110358958299415, Run = 117333533048078, Jump = 119846112151352, Fall = 129773241321032, SwimIdle = 79090109939093, Swim = 132697394189921, Idle = 92080889861410, Idle2 = 74451233229259, Climb = 134630013742019 },
["Amazon Unboxed"] = { Walk = 90478085024465, Run = 134824450619865, Jump = 121454505477205, Fall = 94788218468396, SwimIdle = 129126268464847, Swim = 105962919001086, Idle = 98281136301627, Climb = 121145883950231 },
["Vampire"] = { Walk = 10921326949, Run = 10921320299, Jump = 10921322186, Fall = 10921321317, SwimIdle = 10921325443, Swim = 10921324408, Idle = 10921315373, Climb = 10921314188 },
["Ninja"] = { Walk = 656121766, Run = 656118852, Jump = 656117878, Fall = 656115606, SwimIdle = 656121397, Swim = 656119721, Idle = 656117400, Idle2 = 656118341, Climb = 656114359 },
["Robot"] = { Walk = 616095330, Run = 616091570, Jump = 616090535, Fall = 616087089, SwimIdle = 616094091, Swim = 616092998, Idle = 616088211, Idle2 = 616089559, Climb = 616086039 },
["Levitation"] = { Walk = 616013216, Run = 616010382, Jump = 616008936, Fall = 616005863, SwimIdle = 616012453, Swim = 616011509, Idle = 616006778, Idle2 = 616008087, Climb = 616003713 },
["Stylish"] = { Walk = 616146177, Run = 616140816, Jump = 616139451, Fall = 616134815, SwimIdle = 616144772, Swim = 616143378, Idle = 616136790, Idle2 = 616138447, Climb = 616133594 },
["Bubbly"] = { Walk = 910034870, Run = 910025107, Jump = 910016857, Fall = 910001910, SwimIdle = 910030921, Swim = 910028158, Idle = 910004836, Idle2 = 910009958, Climb = 909997997 },
["Cartoon"] = { Walk = 742640026, Run = 742638842, Jump = 742637942, Fall = 742637151, SwimIdle = 742639812, Swim = 742639220, Idle = 742637544, Idle2 = 742638445, Climb = 742636889 }
}
local function _0x797401()
local _0x78a699 = LocalPlayer.Character
if not _0x78a699 then return end
local _0x84e7d7 = _0x78a699:FindFirstChildOfClass("Humanoid")
if not _0x84e7d7 then return end
for _0x9b1916, _0x2221f3 in pairs(_0x84e7d7:GetPlayingAnimationTracks()) do
_0x2221f3:Stop(0)
_0x2221f3:Destroy()
end
local _0x30b796 = _0x84e7d7:FindFirstChildOfClass("Animator")
if _0x30b796 then
for _0x9b1916, _0x2221f3 in pairs(_0x30b796:GetPlayingAnimationTracks()) do
_0x2221f3:Stop(0)
_0x2221f3:Destroy()
end
end
task.wait(0.1)
end
local function _0xd2e061(_0xe05641)
if not _0xe05641 then return end
local _0x78a699 = LocalPlayer.Character
if not _0x78a699 then return end
_0x797401()
local _0xb921e6 = _0x78a699:FindFirstChild("Animate")
if not _0xb921e6 then return end
if not _0xfe084f then
local function _0x08ceb4(_0x0946c5, _0x47dabc)
local _0x558c67 = _0xb921e6:FindFirstChild(_0x0946c5)
if _0x558c67 then
local _0x69d5c4 = _0x558c67:FindFirstChild(_0x47dabc)
if _0x69d5c4 and _0x69d5c4:IsA("Animation") then
local _0x5fdbc4 = _0x69d5c4.AnimationId:match("%d+")
if _0x5fdbc4 then return tonumber(_0x5fdbc4) end
end
end
return nil
end
_0xfe084f = {
Idle = _0x08ceb4("idle", "Animation1") or 507766666,
Idle2 = _0x08ceb4("idle", "Animation2") or 507766951,
Walk = _0x08ceb4("walk", "WalkAnim") or 507777826,
Run = _0x08ceb4("run", "RunAnim") or 507767714,
Jump = _0x08ceb4("jump", "JumpAnim") or 507765000,
Climb = _0x08ceb4("climb", "ClimbAnim") or 507765644,
Fall = _0x08ceb4("fall", "FallAnim") or 507767968,
Swim = _0x08ceb4("swim", "Swim") or 507784897,
SwimIdle = _0x08ceb4("swimidle", "SwimIdle") or 507785072
}
end
_0xb921e6.Disabled = true
task.wait(0.1)
local function _0xdfbd46(_0x0946c5, _0x47dabc, _0x02ce61)
if not _0x02ce61 then return end
local _0x558c67 = _0xb921e6:FindFirstChild(_0x0946c5)
if _0x558c67 then
local _0x69d5c4 = _0x558c67:FindFirstChild(_0x47dabc)
if _0x69d5c4 and _0x69d5c4:IsA("Animation") then
_0x69d5c4.AnimationId = "rbxassetid://" .. tostring(_0x02ce61)
end
end
end
_0xdfbd46("idle", "Animation1", _0xe05641.Idle)
_0xdfbd46("idle", "Animation2", _0xe05641.Idle2 or _0xe05641.Idle)
_0xdfbd46("walk", "WalkAnim", _0xe05641.Walk)
_0xdfbd46("run", "RunAnim", _0xe05641.Run)
_0xdfbd46("jump", "JumpAnim", _0xe05641.Jump)
_0xdfbd46("climb", "ClimbAnim", _0xe05641.Climb)
_0xdfbd46("fall", "FallAnim", _0xe05641.Fall)
_0xdfbd46("swim", "Swim", _0xe05641.Swim)
_0xdfbd46("swimidle", "SwimIdle", _0xe05641.SwimIdle or _0xe05641.Swim)
task.wait(0.1)
_0xb921e6.Disabled = false
local _0x84e7d7 = _0x78a699:FindFirstChildOfClass("Humanoid")
if _0x84e7d7 then
_0x84e7d7:ChangeState(Enum.HumanoidStateType.Landed)
task.wait(0.05)
_0x84e7d7:ChangeState(Enum.HumanoidStateType.Running)
end
end
task.spawn(function()
while task.wait(1) do
if _0x96c97d then
local _0x78a699 = LocalPlayer.Character
if _0x78a699 then
local _0xb921e6 = _0x78a699:FindFirstChild("Animate")
if _0xb921e6 then
local _0xcaeb73 = _0xb921e6:FindFirstChild("idle")
if _0xcaeb73 then
local _0xb8852a = _0xcaeb73:FindFirstChild("Animation1")
if _0xb8852a then
local _0xd7b23a = _0xb8852a.AnimationId:match("%d+")
if _0xd7b23a ~= tostring(_0x96c97d.Idle) then
_0xd2e061(_0x96c97d)
end
end
end
end
end
end
end
end)
local _0x2d1320 = {_0xedd99f("anim_none")}
for _0x6f342d, _0x9b1916 in pairs(_0x31093e) do
table.insert(_0x2d1320, _0x6f342d)
end
table.sort(_0x2d1320)
_0xa9f1eb.Animaciones:Section({Title = "loc:sec_anim_bundles"})
local _0x4537fd = _0xedd99f("anim_none")
_0xa9f1eb.Animaciones:Dropdown({
Title = "loc:anim_bundle",
Values = _0x2d1320,
Value = _0xedd99f("anim_none"),
Callback = function(_0xcb52d0)
_0x4537fd = _0xcb52d0
end
})
_0xa9f1eb.Animaciones:Button({
Title = "loc:anim_apply",
Callback = function()
if _0x4537fd == _0xedd99f("anim_none") then return end
task.spawn(function()
_0x96c97d = _0x31093e[_0x4537fd]
_0xd2e061(_0x96c97d)
end)
end
})
_0xa9f1eb.Animaciones:Button({
Title = "loc:anim_restore",
Callback = function()
task.spawn(function()
local _0x44f274 = _0xfe084f or {
Idle = 507766666, Idle2 = 507766951, Walk = 507777826, Run = 507767714,
Jump = 507765000, Climb = 507765644, Fall = 507767968, Swim = 507784897, SwimIdle = 507785072
}
_0x96c97d = nil
_0xd2e061(_0x44f274)
end)
end
})
_0xa9f1eb.Animaciones:Section({Title = "loc:sec_anim_mixer"})
local _0x2481b4 = {
Idle = _0xedd99f("anim_none"), Walk = _0xedd99f("anim_none"), Run = _0xedd99f("anim_none"),
Jump = _0xedd99f("anim_none"), Fall = _0xedd99f("anim_none"), Climb = _0xedd99f("anim_none")
}
_0xa9f1eb.Animaciones:Dropdown({Title = "loc:anim_idle", Values = _0x2d1320, Value = _0xedd99f("anim_none"), Callback = function(_0xcb52d0) _0x2481b4.Idle = _0xcb52d0 end})
_0xa9f1eb.Animaciones:Dropdown({Title = "loc:anim_walk", Values = _0x2d1320, Value = _0xedd99f("anim_none"), Callback = function(_0xcb52d0) _0x2481b4.Walk = _0xcb52d0 end})
_0xa9f1eb.Animaciones:Dropdown({Title = "loc:anim_run", Values = _0x2d1320, Value = _0xedd99f("anim_none"), Callback = function(_0xcb52d0) _0x2481b4.Run = _0xcb52d0 end})
_0xa9f1eb.Animaciones:Dropdown({Title = "loc:anim_jump", Values = _0x2d1320, Value = _0xedd99f("anim_none"), Callback = function(_0xcb52d0) _0x2481b4.Jump = _0xcb52d0 end})
_0xa9f1eb.Animaciones:Dropdown({Title = "loc:anim_fall", Values = _0x2d1320, Value = _0xedd99f("anim_none"), Callback = function(_0xcb52d0) _0x2481b4.Fall = _0xcb52d0 end})
_0xa9f1eb.Animaciones:Dropdown({Title = "loc:anim_climb", Values = _0x2d1320, Value = _0xedd99f("anim_none"), Callback = function(_0xcb52d0) _0x2481b4.Climb = _0xcb52d0 end})
_0xa9f1eb.Animaciones:Button({
Title = "loc:anim_combine",
Callback = function()
task.spawn(function()
local _0x5582ee = {}
if _0x2481b4.Idle ~= _0xedd99f("anim_none") then
_0x5582ee.Idle = _0x31093e[_0x2481b4.Idle].Idle
_0x5582ee.Idle2 = _0x31093e[_0x2481b4.Idle].Idle2
end
if _0x2481b4.Walk ~= _0xedd99f("anim_none") then _0x5582ee.Walk = _0x31093e[_0x2481b4.Walk].Walk end
if _0x2481b4.Run ~= _0xedd99f("anim_none") then _0x5582ee.Run = _0x31093e[_0x2481b4.Run].Run end
if _0x2481b4.Jump ~= _0xedd99f("anim_none") then _0x5582ee.Jump = _0x31093e[_0x2481b4.Jump].Jump end
if _0x2481b4.Fall ~= _0xedd99f("anim_none") then _0x5582ee.Fall = _0x31093e[_0x2481b4.Fall].Fall end
if _0x2481b4.Climb ~= _0xedd99f("anim_none") then _0x5582ee.Climb = _0x31093e[_0x2481b4.Climb].Climb end
local _0x91e3f1 = false
for _0x9b1916, _0x5456c5 in pairs(_0x5582ee) do
if _0x5456c5 then
_0x91e3f1 = true
break
end
end
if _0x91e3f1 then
_0x96c97d = _0x5582ee
_0xd2e061(_0x96c97d)
end
end)
end
})
local _0x459a20 = Instance.new("Sound")
_0x459a20.Name = "WindUI_MusicPlayer"
_0x459a20.Looped = false
_0x459a20.Volume = 0.5
_0x459a20.Parent = SoundService
local _0xa6b84a = {
{ Name = "CanciÃ³n 1", Id = "84944985070181" },
{ Name = "CanciÃ³n 2", Id = "87570666848900" },
{ Name = "CanciÃ³n 3", Id = "82746224492420" },
{ Name = "CanciÃ³n 4", Id = "71393805905055" },
{ Name = "CanciÃ³n 5", Id = "75688616622595" },
{ Name = "CanciÃ³n 6", Id = "135609653444873" },
{ Name = "CanciÃ³n 7", Id = "93699644879957" },
{ Name = "CanciÃ³n 8", Id = "110398343528156" },
{ Name = "CanciÃ³n 9", Id = "138863509657081" },
{ Name = "CanciÃ³n 10", Id = "115440201770223" },
{ Name = "CanciÃ³n 11", Id = "128048502331483" },
{ Name = "CanciÃ³n 12", Id = "135321902579514" },
{ Name = "CanciÃ³n 13", Id = "131465489873214" },
}
local _0xe353a7 = 1
local _0xf15dfc = false
local _0x3cac38
local function _0x8f6e60(_0x2e4fed)
return _0x2e4fed.Name .. " (" .. _0x2e4fed.Id .. ")"
end
local function _0xcda13c()
local _0x2e4fed = _0xa6b84a[_0xe353a7]
if _0x2e4fed and _0x3cac38 then
_0x3cac38:SetDesc(
("%s  â¢  ID: %s  â¢  %s"):format(
_0x2e4fed.Name, _0x2e4fed.Id, _0x459a20.Playing and _0xedd99f("music_playing") or _0xedd99f("music_paused")
)
)
end
end
local function _0x9db8da(_0xbfa80d)
if not _0xa6b84a[_0xbfa80d] then return end
_0xe353a7 = _0xbfa80d
_0x459a20:Stop()
_0x459a20.SoundId = "rbxassetid://" .. _0xa6b84a[_0xbfa80d].Id
_0x459a20:Play()
_0xcda13c()
end
local function _0xce8d7f()
if _0x459a20.SoundId == _0xb872a2({}) then
_0x9db8da(_0xe353a7)
elseif not _0x459a20.Playing then
_0x459a20:Resume()
end
_0xcda13c()
end
local function _0x32dbf6()
if _0x459a20.Playing then _0x459a20:Pause() end
_0xcda13c()
end
local function _0xf72a91()
_0x459a20:Stop()
_0x459a20.SoundId = _0xb872a2({})
_0xcda13c()
end
local function _0xe09717()
local _0x74c20c
if _0xf15dfc then
_0x74c20c = math.random(1, #_0xa6b84a)
else
_0x74c20c = _0xe353a7 + 1
if _0x74c20c > #_0xa6b84a then _0x74c20c = 1 end
end
_0x9db8da(_0x74c20c)
end
local function _0xacfdf6()
local _0xe1b4da
if _0xf15dfc then
_0xe1b4da = math.random(1, #_0xa6b84a)
else
_0xe1b4da = _0xe353a7 - 1
if _0xe1b4da < 1 then _0xe1b4da = #_0xa6b84a end
end
_0x9db8da(_0xe1b4da)
end
_0x459a20.Ended:Connect(function()
_0xe09717()
end)
_0xa9f1eb.Music:Section({ Title = "loc:sec_now_playing", Icon = "solar:music-note-bold" })
_0x3cac38 = _0xa9f1eb.Music:Paragraph({
Title = "loc:music_now_none",
Desc = "loc:music_now_desc",
Icon = "solar:music-note-2-bold",
})
_0xa9f1eb.Music:Section({ Title = "loc:sec_controls", Icon = "solar:tuning-2-bold" })
_0xa9f1eb.Music:Button({
Title = "loc:music_prev",
Desc = "loc:music_prev_desc",
Icon = "solar:skip-previous-bold",
Variant = "Secondary",
Callback = function() _0xacfdf6() end,
})
_0xa9f1eb.Music:Button({
Title = "loc:music_next",
Desc = "loc:music_next_desc",
Icon = "solar:skip-next-bold",
Variant = "Secondary",
Callback = function() _0xe09717() end,
})
_0xa9f1eb.Music:Button({
Title = "loc:music_play",
Desc = "loc:music_play_desc",
Icon = "solar:play-circle-bold",
Variant = "Primary",
Callback = function() _0xce8d7f() end,
})
_0xa9f1eb.Music:Button({
Title = "loc:music_pause",
Desc = "loc:music_pause_desc",
Icon = "solar:pause-circle-bold",
Variant = "Secondary",
Callback = function() _0x32dbf6() end,
})
_0xa9f1eb.Music:Button({
Title = "loc:music_stop",
Desc = "loc:music_stop_desc",
Icon = "solar:close-circle-bold",
Variant = "Danger",
Callback = function() _0xf72a91() end,
})
_0xa9f1eb.Music:Section({ Title = "loc:sec_music_pick", Icon = "solar:playlist-bold" })
local _0x5c8d4b
_0x5c8d4b = _0xa9f1eb.Music:Dropdown({
Title = "loc:music_song",
Desc = "loc:music_song_desc",
Icon = "solar:music-note-bold",
Values = (function()
local _0xe2d827 = {}
for _0x9b1916, _0x2e4fed in ipairs(_0xa6b84a) do
table.insert(_0xe2d827, _0x8f6e60(_0x2e4fed))
end
return _0xe2d827
end)(),
Callback = function(_0x500bc4)
for _0xc4d087, _0x2e4fed in ipairs(_0xa6b84a) do
if _0x500bc4 == _0x8f6e60(_0x2e4fed) then
_0x9db8da(_0xc4d087)
break
end
end
end,
})
_0xa9f1eb.Music:Section({ Title = "loc:sec_music_prefs", Icon = "solar:settings-bold" })
_0xa9f1eb.Music:Toggle({
Title = "loc:music_shuffle",
Desc = "loc:music_shuffle_desc",
Icon = "solar:shuffle-bold",
Value = false,
Callback = function(_0x737f2e) _0xf15dfc = _0x737f2e end,
})
_0xa9f1eb.Music:Toggle({
Title = "loc:music_repeat",
Desc = "loc:music_repeat_desc",
Icon = "solar:repeat-one-bold",
Value = false,
Callback = function(_0x737f2e) _0x459a20.Looped = _0x737f2e end,
})
_0xa9f1eb.Music:Slider({
Title = "loc:music_vol",
Desc = "loc:music_vol_desc",
Icon = "solar:volume-loud-bold",
Value = { Min = 0, Max = 100, Default = 50 },
Callback = function(_0x19ee65)
_0x459a20.Volume = _0x19ee65 / 100
end,
})
_0xa9f1eb.Music:Section({ Title = "loc:sec_music_ids", Icon = "solar:playlist-bold" })
local _0x0b8807, _0x268199 = _0xb872a2({}), _0xb872a2({})
_0xa9f1eb.Music:Input({
Title = "loc:music_name",
Icon = "solar:text-field-bold",
Placeholder = "loc:music_name_ph",
Callback = function(_0x19ee65) _0x0b8807 = _0x19ee65 end,
})
_0xa9f1eb.Music:Input({
Title = "loc:music_id",
Icon = "solar:hashtag-bold",
Placeholder = "loc:music_id_ph",
Callback = function(_0x19ee65) _0x268199 = _0x19ee65 end,
})
local function _0x818657()
local _0xe2d827 = {}
for _0x9b1916, _0x2e4fed in ipairs(_0xa6b84a) do
table.insert(_0xe2d827, _0x8f6e60(_0x2e4fed))
end
if _0x5c8d4b and _0x5c8d4b.Refresh then
_0x5c8d4b:Refresh(_0xe2d827)
end
end
_0xa9f1eb.Music:Button({
Title = "loc:music_add",
Desc = "loc:music_add_desc",
Icon = "solar:add-circle-bold",
Variant = "Primary",
Callback = function()
if _0x0b8807 ~= _0xb872a2({}) and _0x268199 ~= _0xb872a2({}) then
for _0x9b1916, _0x2e4fed in ipairs(_0xa6b84a) do
if _0x2e4fed.Id == _0x268199 then return end
end
table.insert(_0xa6b84a, { Name = _0x0b8807, Id = _0x268199 })
_0x818657()
end
end,
})
local _0x7da19c = {
{ Name = "Fondo 1", ID = "12687580616", Reference = "rbxthumb://type=Asset&id=12687580616&w=420&h=420" },
{ Name = "Fondo 2", ID = "17104722", Reference = "rbxthumb://type=Asset&id=17104722&w=420&h=420" },
{ Name = "Fondo 3", ID = "1941010929", Reference = "rbxthumb://type=Asset&id=1941010929&w=420&h=420" },
{ Name = "Fondo 4", ID = "134245569", Reference = "rbxthumb://type=Asset&id=134245569&w=420&h=420" }
}
local _0xe49ca0 = _0x7da19c[1]
local _0x8fa9e5 = {}
for _0x9b1916, _0xb39129 in ipairs(_0x7da19c) do
table.insert(_0x8fa9e5, _0xb39129.Name)
end
_0xa9f1eb.Fondos:Dropdown({
Title = "loc:bg_select",
Values = _0x8fa9e5,
Value = _0xe49ca0.Name,
Callback = function(_0xcb52d0)
for _0x9b1916, _0xb39129 in ipairs(_0x7da19c) do
if _0xb39129.Name == _0xcb52d0 then
_0xe49ca0 = _0xb39129
break
end
end
end
})
local function _0x4a1788()
local _0x5134ea = {
game:GetService("CoreGui"),
game:GetService("Players").LocalPlayer:FindFirstChildOfClass("PlayerGui")
}
for _0x9b1916, _0xb17d1f in ipairs(_0x5134ea) do
if _0xb17d1f then
for _0x9b1916, _0x65431d in ipairs(_0xb17d1f:GetDescendants()) do
if _0x65431d:IsA("ImageLabel") then
local _0x672d71 = _0x65431d.Image
if _0x672d71 and (_0x672d71:find("12687580616") or _0x672d71:find("17104722")
or _0x672d71:find("1941010929") or _0x672d71:find("134245569")) then
return _0x65431d
end
end
end
end
end
return nil
end
local function _0xe816c7(_0xaf9467)
_0xaf9467.ZIndex = 0
_0xaf9467.Active = false
local _0x12c8e0 = _0xaf9467.Parent
if _0x12c8e0 then
for _0x9b1916, _0x65431d in ipairs(_0x12c8e0:GetDescendants()) do
if _0x65431d:IsA("GuiObject") and _0x65431d ~= _0xaf9467 then
if _0x65431d.ZIndex <= _0xaf9467.ZIndex then
_0x65431d.ZIndex = _0xaf9467.ZIndex + 1
end
end
end
end
end
_0xa9f1eb.Fondos:Button({
Title = "loc:bg_apply",
Callback = function()
local _0xaf9467 = _0x4a1788()
if _0xaf9467 then
_0xaf9467.Image = _0xe49ca0.Reference
_0xe816c7(_0xaf9467)
else
warn("No se encontrÃ³ el fondo de WindUI.")
end
end
})
_0xa9f1eb.Fondos:Section({ Title = "loc:sec_theme", Icon = "solar:palette-bold" })
_0xa9f1eb.Fondos:Dropdown({
Title = "loc:bg_theme",
Desc = "loc:bg_theme_desc",
Icon = "solar:palette-bold",
Values = { "Midnight", "Dark", "Red", "Indigo" },
Value = "Dark",
Callback = function(_0xcb52d0)
pcall(function() _0x801a2b:SetTheme(_0xcb52d0) end)
end
})
local _0x163476 = {
{ Name = "Wave", Id = "507770239", Loop = false },
{ Name = "Point", Id = "507770453", Loop = false },
{ Name = "Cheer", Id = "507770677", Loop = false },
{ Name = "Laugh", Id = "507770818", Loop = false },
{ Name = "Dance 1", Id = "507771019", Loop = true },
{ Name = "Dance 1 (B)", Id = "507771955", Loop = true },
{ Name = "Dance 1 (C)", Id = "507772104", Loop = true },
{ Name = "Dance 2", Id = "507776043", Loop = true },
{ Name = "Dance 2 (B)", Id = "507776720", Loop = true },
{ Name = "Dance 2 (C)", Id = "507776879", Loop = true },
{ Name = "Dance 3", Id = "507777268", Loop = true },
{ Name = "Dance 3 (B)", Id = "507777451", Loop = true },
{ Name = "Dance 3 (C)", Id = "507777623", Loop = true },
{ Name = "Hype Dance", Id = "3695333486", Loop = true },
{ Name = "Monkey", Id = "3333499508", Loop = true },
{ Name = "Around Town", Id = "3303391864", Loop = true },
{ Name = "Dorky", Id = "4212455378", Loop = true },
{ Name = "Line Dance", Id = "4049037604", Loop = true },
{ Name = "Side to Side", Id = "3333136415", Loop = true },
{ Name = "Baby Dance", Id = "4265725525", Loop = true },
{ Name = "Robot Dance", Id = "3338025566", Loop = true },
{ Name = "Celebrate", Id = "3994127840", Loop = true },
}
local _0x02c01a = (Enum.AnimationPriority.Action4 and Enum.AnimationPriority.Action4)
or Enum.AnimationPriority.Action
local _0x3efcda
local _0x84d4e4
local _0x13607d = true
local _0x3f4e87 = {}
local function _0x7d79a7()
local _0x6f60b1 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
local _0x30b796 = _0x6f60b1 and _0x6f60b1:FindFirstChildOfClass("Animator")
if _0x30b796 then
for _0x9b1916, _0x2221f3 in ipairs(_0x30b796:GetPlayingAnimationTracks()) do
if _0x2221f3.Animation and _0x2221f3.Animation.AnimationId ~= _0xb872a2({}) then
_0x2221f3:Stop(0)
end
end
end
_0x3efcda = nil
end
local function _0x09538f()
for _0x9b1916, _0xf56089 in ipairs(_0x3f4e87) do
_0xf56089:Disconnect()
end
_0x3f4e87 = {}
end
local function _0x6619d3(_0x6f60b1)
_0x09538f()
table.insert(_0x3f4e87, _0x6f60b1.Running:Connect(function(_0x6594f4)
if _0x6594f4 > 0.1 and _0x3efcda then _0x7d79a7() end
end))
table.insert(_0x3f4e87, _0x6f60b1.Jumping:Connect(function()
if _0x3efcda then _0x7d79a7() end
end))
table.insert(_0x3f4e87, _0x6f60b1.StateChanged:Connect(function(_0x9b1916, _0x9e7574)
if not _0x3efcda then return end
if _0x9e7574 == Enum.HumanoidStateType.Freefall
or _0x9e7574 == Enum.HumanoidStateType.Jumping
or _0x9e7574 == Enum.HumanoidStateType.Swimming
or _0x9e7574 == Enum.HumanoidStateType.Climbing then
_0x7d79a7()
end
end))
end
local function _0xec9d02()
local _0xcfdc4e = LocalPlayer.Character
if not _0xcfdc4e then return nil end
return _0xcfdc4e:FindFirstChildOfClass("Humanoid")
end
local function _0xc391ab(_0xcfdc4e)
_0x3efcda = nil
local _0x6f60b1 = _0xcfdc4e:WaitForChild("Humanoid", 5)
if _0x6f60b1 then
_0x6619d3(_0x6f60b1)
end
end
if LocalPlayer.Character then
_0xc391ab(LocalPlayer.Character)
end
LocalPlayer.CharacterAdded:Connect(_0xc391ab)
local function _0x0cbdd1(_0x9c649a, _0x037cff)
local _0x6f60b1 = _0xec9d02()
if not _0x6f60b1 then return end
if _0x6f60b1.RigType ~= Enum.HumanoidRigType.R15 then return end
_0x7d79a7()
local _0x30b796 = _0x6f60b1:FindFirstChildOfClass("Animator")
if not _0x30b796 then
_0x30b796 = Instance.new("Animator")
_0x30b796.Parent = _0x6f60b1
end
local _0xdbde71 = Instance.new("Animation")
_0xdbde71.AnimationId = "rbxassetid://" .. _0x9c649a
local _0x565115, _0x2221f3 = pcall(function()
return _0x30b796:LoadAnimation(_0xdbde71)
end)
if _0x565115 and _0x2221f3 then
_0x2221f3.Priority = _0x02c01a
_0x2221f3.Looped = _0x037cff
_0x3efcda = _0x2221f3
_0x2221f3:Play(0, 1, 1)
end
end
local function _0x5998e9(_0xc6c128)
return _0xc6c128.Name .. " (" .. _0xc6c128.Id .. ")"
end
_0xa9f1eb.Emotes:Section({ Title = "loc:sec_emotes_list", Icon = "solar:emoji-funny-circle-bold" })
local _0x69be8e
_0x69be8e = _0xa9f1eb.Emotes:Dropdown({
Title = "loc:emote_pick",
Desc = "loc:emote_pick_desc",
Icon = "solar:playlist-bold",
Values = (function()
local _0xe2d827 = {}
for _0x9b1916, _0xc6c128 in ipairs(_0x163476) do
table.insert(_0xe2d827, _0x5998e9(_0xc6c128))
end
return _0xe2d827
end)(),
Callback = function(_0x500bc4)
for _0x9b1916, _0xc6c128 in ipairs(_0x163476) do
if _0x500bc4 == _0x5998e9(_0xc6c128) then
_0x84d4e4 = _0xc6c128.Id
_0x13607d = _0xc6c128.Loop
break
end
end
end,
})
_0xa9f1eb.Emotes:Section({ Title = "loc:sec_controls", Icon = "solar:tuning-2-bold" })
_0xa9f1eb.Emotes:Button({
Title = "loc:emote_play",
Desc = "loc:emote_play_desc",
Icon = "solar:play-circle-bold",
Variant = "Primary",
Callback = function()
if _0x84d4e4 then
_0x0cbdd1(_0x84d4e4, _0x13607d)
end
end,
})
_0xa9f1eb.Emotes:Button({
Title = "loc:emote_stop",
Desc = "loc:emote_stop_desc",
Icon = "solar:close-circle-bold",
Variant = "Danger",
Callback = function() _0x7d79a7() end,
})
_0xa9f1eb.Emotes:Section({ Title = "loc:sec_emotes_ids", Icon = "solar:playlist-bold" })
local _0x7dbecf, _0x9b10a2 = _0xb872a2({}), _0xb872a2({})
local _0x0ea72b = true
_0xa9f1eb.Emotes:Input({
Title = "loc:emote_name",
Icon = "solar:text-field-bold",
Placeholder = "loc:emote_name_ph",
Callback = function(_0x19ee65) _0x7dbecf = _0x19ee65 end,
})
_0xa9f1eb.Emotes:Input({
Title = "loc:emote_id",
Icon = "solar:hashtag-bold",
Placeholder = "loc:emote_id_ph",
Callback = function(_0x19ee65) _0x9b10a2 = _0x19ee65 end,
})
_0xa9f1eb.Emotes:Toggle({
Title = "loc:emote_loop",
Desc = "loc:emote_loop_desc",
Icon = "solar:repeat-one-bold",
Value = true,
Callback = function(_0x737f2e) _0x0ea72b = _0x737f2e end,
})
local function _0x283431()
local _0xe2d827 = {}
for _0x9b1916, _0xc6c128 in ipairs(_0x163476) do
table.insert(_0xe2d827, _0x5998e9(_0xc6c128))
end
if _0x69be8e and _0x69be8e.Refresh then
_0x69be8e:Refresh(_0xe2d827)
end
end
_0xa9f1eb.Emotes:Button({
Title = "loc:emote_add",
Desc = "loc:emote_add_desc",
Icon = "solar:add-circle-bold",
Variant = "Primary",
Callback = function()
if _0x7dbecf ~= _0xb872a2({}) and _0x9b10a2 ~= _0xb872a2({}) then
for _0x9b1916, _0xc6c128 in ipairs(_0x163476) do
if _0xc6c128.Id == _0x9b10a2 then return end
end
table.insert(_0x163476, { Name = _0x7dbecf, Id = _0x9b10a2, Loop = _0x0ea72b })
_0x283431()
end
end,
})
local _0x23ecff = {
["Left Leg"] = {
id = "rbxassetid://139607673",
targetBodyPart = "LeftUpperLeg",
partsToHide = {"LeftUpperLeg", "LeftLowerLeg", "LeftFoot"},
scale = Vector3.new(1.0, 1.0, 1.0),
audio = "rbxassetid://87998522263554",
offset = CFrame.new(0, 0, 0) * CFrame.Angles(0, 0, 0),
},
["Right Leg"] = {
id = "rbxassetid://139607718",
targetBodyPart = "RightUpperLeg",
partsToHide = {"RightUpperLeg", "RightLowerLeg", "RightFoot"},
scale = Vector3.new(1.0, 1.0, 1.0),
audio = "rbxassetid://135315310485417",
offset = CFrame.new(0, 0, 0) * CFrame.Angles(0, 0, 0),
}
}
local _0xb0200e = false
local _0x000caf = {}
local function _0xf63b8b(_0x230367, _0xa1c72c)
local _0xcfdc4e = LocalPlayer.Character
if not _0xcfdc4e then return false, "No character" end
local _0xeabdf3 = _0xcfdc4e:FindFirstChild(_0xa1c72c.targetBodyPart)
if not _0xeabdf3 then
for _0xc4d087 = 1, 50 do
task.wait(0.1)
_0xeabdf3 = _0xcfdc4e:FindFirstChild(_0xa1c72c.targetBodyPart)
if _0xeabdf3 then break end
end
if not _0xeabdf3 then return false, "Target part missing" end
end
local _0xc837f5 = _0xcfdc4e:FindFirstChild("Korblox_" .. _0x230367:gsub("%s+", _0xb872a2({})))
if _0xc837f5 then
_0xc837f5:Destroy()
end
for _0x9b1916, _0xc54ede in ipairs(_0xa1c72c.partsToHide) do
local _0x65f358 = _0xcfdc4e:FindFirstChild(_0xc54ede)
if _0x65f358 and _0x65f358:IsA("BasePart") then
if _0x000caf[_0xc54ede] == nil then
_0x000caf[_0xc54ede] = _0x65f358.Transparency
end
_0x65f358.Transparency = 1
end
end
local _0xfc8e4b, _0x757e85 = pcall(function()
return game:GetObjects(_0xa1c72c.id)
end)
if not _0xfc8e4b or not _0x757e85 or #_0x757e85 == 0 then
return false, "Asset fetch failed"
end
local _0x190013 = _0x757e85[1]
_0x190013.Name = "Korblox_" .. _0x230367:gsub("%s+", _0xb872a2({}))
local _0xc50510 = _0x190013:IsA("BasePart") and _0x190013 or _0x190013:FindFirstChildWhichIsA("BasePart", true)
if not _0xc50510 then
return false, "No MeshPart in asset"
end
_0xc50510.Size = _0xc50510.Size * _0xa1c72c.scale
_0xc50510.CanCollide = false
_0xc50510.CFrame = _0xeabdf3.CFrame * _0xa1c72c.offset
local _0x750149 = Instance.new("WeldConstraint")
_0x750149.Part0 = _0xeabdf3
_0x750149.Part1 = _0xc50510
_0x750149.Parent = _0xc50510
_0x190013.Parent = _0xcfdc4e
if _0xa1c72c.audio then
local _0x634871 = Instance.new("Sound")
_0x634871.SoundId = _0xa1c72c.audio
_0x634871.Volume = 0.5
_0x634871.Parent = _0xc50510
_0x634871:Play()
game:GetService("Debris"):AddItem(_0x634871, 3)
end
return true
end
local function _0x8e0b9f()
task.spawn(function()
for _0x9b1916, _0x6f342d in ipairs({"Left Leg", "Right Leg"}) do
local _0xa1c72c = _0x23ecff[_0x6f342d]
local _0x565115, _0x2a5314 = _0xf63b8b(_0x6f342d, _0xa1c72c)
if not _0x565115 then
task.wait(1)
_0xf63b8b(_0x6f342d, _0xa1c72c)
end
end
end)
end
local function _0x436ea5()
local _0xcfdc4e = LocalPlayer.Character
if not _0xcfdc4e then return end
for _0x9b1916, _0x6f342d in ipairs({"Left Leg", "Right Leg"}) do
local _0xc03960 = "Korblox_" .. _0x6f342d:gsub("%s+", _0xb872a2({}))
local _0x6ec928 = _0xcfdc4e:FindFirstChild(_0xc03960)
if _0x6ec928 then
pcall(function() _0x6ec928:Destroy() end)
end
end
for _0xc54ede, _0x2acae1 in pairs(_0x000caf) do
local _0x65f358 = _0xcfdc4e:FindFirstChild(_0xc54ede)
if _0x65f358 and _0x65f358:IsA("BasePart") then
pcall(function() _0x65f358.Transparency = _0x2acae1 end)
end
end
_0x000caf = {}
end
LocalPlayer.CharacterAdded:Connect(function(_0xcfdc4e)
task.wait(2)
if _0xb0200e then
_0x8e0b9f()
end
end)
_0xa9f1eb.Items:Section({ Title = "loc:sec_items", Icon = "solar:crown-star-bold" })
_0xa9f1eb.Items:Toggle({
Title = "loc:items_korblox",
Desc = "loc:items_korblox_desc",
Icon = "solar:star-bold",
Value = false,
Callback = function(_0x5456c5)
_0xb0200e = _0x5456c5
if _0x5456c5 then
_0x8e0b9f()
else
_0x436ea5()
end
end
})
_0xa9f1eb.Com:Section({ Title = "loc:sec_com" })
_0xa9f1eb.Com:Button({
Title = "loc:com_whatsapp",
Callback = function()
pcall(function()
if setclipboard then
setclipboard("https://chat.whatsapp.com/CZsrpvaCrCO5oOzeBX5wCM?s=cl&p=a&mlu=4&ilr=4")
game:GetService("StarterGui"):SetCore("SendNotification", {
Title = _0xedd99f("com_link_copied"),
Text = _0xedd99f("com_link_text"),
Duration = 4
})
end
end)
end
})
_0xa9f1eb.Com:Paragraph({
Title = "loc:com_discord_title",
Desc = "loc:com_discord_desc",
Thumbnail = "rbxthumb://type=Asset&id=98223561754963&w=420&h=420",
ThumbnailSize = 128,
Buttons = {
{
Title = "loc:com_discord_button",
Callback = function()
pcall(function()
if setclipboard then
setclipboard("https://chat.whatsapp.com/CZsrpvaCrCO5oOzeBX5wCM?s=cl&p=a&mlu=4&ilr=4")
game:GetService("StarterGui"):SetCore("SendNotification", {
Title = _0xedd99f("com_link_copied"),
Text = _0xedd99f("com_link_text"),
Duration = 4
})
end
end)
end,
},
},
})
_0xa9f1eb.Avisos:Section({ Title = "loc:sec_warning" })
_0xa9f1eb.Avisos:Paragraph({
Title = "loc:warn_staff",
Desc = _0xb872a2({})
})
_0xa9f1eb.Avisos:Section({ Title = "loc:sec_keybinds" })
_0xa9f1eb.Avisos:Keybind({
Title = "loc:ui_keybind",
Value = Keybinds.ToggleUI,
Callback = function(_0x7818b2)
Keybinds.ToggleUI = _0x7818b2
pcall(function() _0x8f5fb6:SetToggleKey(Enum.KeyCode[_0x7818b2]) end)
end
})
_0xa9f1eb.Avisos:Button({
Title = "loc:ui_keybind_reset",
Desc = "loc:ui_keybind_reset_desc",
Callback = function()
Keybinds.ToggleUI = "RightControl"
pcall(function() _0x8f5fb6:SetToggleKey(Enum.KeyCode.RightControl) end)
end
})
_0xa9f1eb.Owners:Section({ Title = "loc:sec_team" })
_0xa9f1eb.Owners:Paragraph({
Title = "<font color='#FFD700'><b>" .. _0xedd99f("owner_title") .. "</b></font>",
Desc = "<font color='#FFD700'>" .. _0xedd99f("owner_desc") .. "</font>",
Image = "rbxthumb://type=Asset&id=118426087958469&w=420&h=420",
ImageSize = 32
})
_0xa9f1eb.Owners:Paragraph({
Title = "<font color='#4FC3F7'>" .. _0xedd99f("admin_title") .. "</font>",
Desc = "<font color='#4FC3F7'>" .. _0xedd99f("admin_desc") .. "</font>",
Image = "rbxthumb://type=Asset&id=75024819064363&w=420&h=420",
ImageSize = 32
})
_0xa9f1eb.Owners:Paragraph({
Title = "<font color='#81C784'>" .. _0xedd99f("helper_title") .. "</font>",
Desc = "<font color='#81C784'>" .. _0xedd99f("helper_desc") .. "</font>",
Image = "rbxthumb://type=Asset&id=75024819064363&w=420&h=420",
ImageSize = 32
})
_0xa9f1eb.Owners:Paragraph({
Title = "<font color='#FF7043'>" .. _0xedd99f("support_title") .. "</font>",
Desc = "<font color='#FF7043'>" .. _0xedd99f("support_desc") .. "</font>",
Image = "rbxthumb://type=Asset&id=121917093943240&w=420&h=420",
ImageSize = 32
})
_0xa9f1eb.Owners:Paragraph({
Title = _0xedd99f("thanks_title"),
Desc = _0xedd99f("thanks_desc")
})
_0xa9f1eb.Update:Section({ Title = "loc:sec_updates", Icon = "solar:cloud-download-bold" })
_0xa9f1eb.Update:Paragraph({
Title = "<font color='#FFD700'><b>" .. _0xedd99f("upd_next") .. "</b></font>",
Desc = "<font color='#FFD700'>" .. _0xedd99f("upd_date") .. "</font>",
Icon = "solar:tag-bold"
})
_0xa9f1eb.Update:Section({ Title = "loc:sec_changes", Icon = "solar:list-check-bold" })
_0xa9f1eb.Update:Paragraph({
Title = "<font color='#00FF00'>" .. _0xedd99f("upd_changes1") .. "</font>",
Icon = "solar:check-circle-bold"
})
_0xa9f1eb.Update:Paragraph({
Title = "<font color='#00FF00'>" .. _0xedd99f("upd_changes2") .. "</font>",
Icon = "solar:check-circle-bold"
})
_0xa9f1eb.Update:Paragraph({
Title = "<font color='#00FF00'>" .. _0xedd99f("upd_changes3") .. "</font>",
Icon = "solar:check-circle-bold"
})
_0xa9f1eb.Update:Section({ Title = "loc:sec_warn_update", Icon = "solar:danger-triangle-bold" })
_0xa9f1eb.Update:Paragraph({
Title = "<font color='#FF0000'>" .. _0xedd99f("upd_warn1") .. "</font>",
Icon = "solar:danger-triangle-bold"
})
_0xa9f1eb.Update:Paragraph({
Title = _0xedd99f("upd_warn2"),
Icon = "solar:danger-triangle-bold"
})
