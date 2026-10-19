local ffi = require "ffi"
local imgui = require 'imgui'
local encoding = require 'encoding'
local memory = require "memory"
encoding.default = 'CP1251'
u8 = encoding.UTF8
local inicfg = require "inicfg"

local directIni = "skin transparente.ini"
local ini = inicfg.load(inicfg.load({
    settings = {
        alphaskin = "255",
        alphaskinall = "255",
    },
}, directIni))
inicfg.save(ini, directIni)

function save()
    inicfg.save(ini, directIni)
end


local main_menu = imgui.ImBool(false)

local sw, sh = getScreenResolution()

local sliderskin = imgui.ImInt(ini.settings.alphaskin)
local sliderskinall = imgui.ImInt(ini.settings.alphaskinall)

function main()
    repeat wait(100) until isSampAvailable()
    sampRegisterChatCommand("tf", cmd_imgui)
    while true do
        wait(0)
        allcharhandle = getAllChars()
        allvehhandle = getAllVehicles()
    end
end

function cmd_imgui()
	main_menu.v = not main_menu.v
	imgui.Process = main_menu.v
end

function SetRwObjectAlpha(handle, alpha)
    lua_thread.create(function()
        wait(100)
        local pedEn = getCharPointer(handle)
        --local allpedEn = getCharPointer(handle)
        local carEn = getCarPointer(handle)
        if pedEn ~= 0 then
            ffi.cast("void (__thiscall *)(int, int)", 0x5332C0)(pedEn, alpha)
        --elseif allpedEn ~= 0 then
          --  ffi.cast("void (__thiscall *)(int, int)", 0x5332C0)(allpedEn, alpha)
        elseif carEn ~= 0 then
            ffi.cast("void (__thiscall *)(int, int)", 0x5332C0)(carEn, alpha)
        end
    end)
end

function imgui.OnDrawFrame()
	if not main_menu.v then
		imgui.Process = false
	end
	if main_menu.v then
		imgui.SetNextWindowSize(imgui.ImVec2(320, 190), imgui.Cond.FirstUseEver)
		imgui.SetNextWindowPos(imgui.ImVec2((sw / 2), sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.Begin(u8" AlphaMode: Gorskin Tradutor: Lk021", main_menu, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse, imgui.ImVec2(190, 25))
            imgui.Text(u8"nivel de opacidade do seu jogador")
            if imgui.SliderInt(u8"Player", sliderskin, 1, 255) then
                SetRwObjectAlpha(playerPed, sliderskin.v)
            end
            imgui.SameLine()
            imgui.TextQuestion(u8"define o nivel de opacidade do seu personagem")

            imgui.Text(u8"nivel de opacidade de todos os jogadores")
            if imgui.SliderInt(u8"All_Player", sliderskinall, 1, 255) then
                for _,v in ipairs(allcharhandle) do
                    if v ~= PLAYER_PED then
                        SetRwObjectAlpha(v, sliderskinall.v)
                    end
                end  
            end
            imgui.SameLine()
            imgui.TextQuestion(u8"define o nivel de opacidade para todos os jogadores na area de renderizacao")

            if imgui.Button(u8"proteger") then
                ini.settings.alphacarall = slidercarall.v
                ini.settings.alphaskinall = sliderskinall.v
                ini.settings.alphaskin = sliderskin.v
                save()
			end
		imgui.End()
	end
end

function imgui.TextQuestion(text)
    imgui.TextDisabled('(?)')
    if imgui.IsItemHovered() then
        imgui.BeginTooltip()
        imgui.PushTextWrapPos(450)
        imgui.TextUnformatted(text)
        imgui.PopTextWrapPos()
        imgui.EndTooltip()
    end
end