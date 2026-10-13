-- Servicios y Referencias Principales
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local GameData = ReplicatedStorage:FindFirstChild("GameData")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Búsqueda segura de la UI de modificadores e interfaz de Admin
local MainUI = PlayerGui:FindFirstChild("MainUI")
local Mods = MainUI and MainUI:FindFirstChild("TempMods")
local AdminPanel = PlayerGui:FindFirstChild("DoorsAdmin")

local Repo = "https://pastebin.com/raw/"
local Library = loadstring(game:HttpGet(Repo.."qR4uC8iC"))()

local SonidoNotificacion = Instance.new("Sound")
SonidoNotificacion.SoundId = "rbxassetid://4590662766"
SonidoNotificacion.Parent = game.SoundService

-- =============================================================================
-- LOGICA DE DETECCIÓN ORGANIZADA
-- =============================================================================

if game.PlaceId == 6516141723 then
    loadstring(game:HttpGet("https://pastebin.com/raw/mvxhuCx7"))()

elseif GameData and GameData:FindFirstChild("Floor") then
    local FloorValue = GameData.Floor.Value
    local DailyRunValue = GameData:FindFirstChild("DailyRun") and GameData.DailyRun.Value == true

    -- 1. Prioridad: Panel de Administrador
    if AdminPanel then
        Library:Notify("¿Para qué quieres usar scripts cuando ya tienes el Panel de Administrador?", 5)
        SonidoNotificacion:Play()

    -- 2. Prioridad: Si hay modificadores activos (Versión General)
    elseif Mods then
        loadstring(game:HttpGet("https://pastebin.com/raw/wM6dxQJ5"))()
        Library:Notify("En un futuro será totalmente compatible", 3)
        SonidoNotificacion:Play()

    -- 3. Detección por mapas (Solo cuando no hay Mods ni AdminPanel)
    elseif FloorValue == "Halloween25" then
        --print("Trick or treat normal")
        Library:Notify("Piso no soportado", 3)
        SonidoNotificacion:Play()

    elseif FloorValue == "Garden" then
        loadstring(game:HttpGet("https://pastebin.com/raw/LqPRau17"))()

    elseif FloorValue == "Mines" then
        loadstring(game:HttpGet("https://pastebin.com/raw/44AJHeB0"))()

    elseif FloorValue == "Backdoor" then
        loadstring(game:HttpGet("https://pastebin.com/raw/XXK8BSx3"))()

    elseif FloorValue == "Hotel" then
        loadstring(game:HttpGet("https://pastebin.com/raw/nycY5tam"))()

    elseif FloorValue == "Archives" then
        loadstring(game:HttpGet("https://pastebin.com/raw/RaZRkSCB"))()

    elseif FloorValue == "Endless" then
        --print("Modo Infinito")
        Library:Notify("Piso no soportado", 3)
        SonidoNotificacion:Play()

    elseif FloorValue == "Fools26" then
        --print("Rushing Mode")
        Library:Notify("Piso no soportado", 3)
        SonidoNotificacion:Play()

    elseif FloorValue == "Party" then
        --print("Battle Mode")
        Library:Notify("Piso no soportado", 3)
        SonidoNotificacion:Play()

    elseif FloorValue == "Fools" then
        --print("Super Hard Mode")
        Library:Notify("Piso no soportado", 3)
        SonidoNotificacion:Play()

    elseif FloorValue == "Retro" then
        --print("Retro Mode")
        Library:Notify("Piso no soportado", 3)
        SonidoNotificacion:Play()

    elseif FloorValue == "Ripple" then
        if DailyRunValue then
            loadstring(game:HttpGet("https://pastebin.com/raw/bwyxcEQa"))() -- Desafío Diario

        else
            loadstring(game:HttpGet("https://pastebin.com/raw/v5TjNaiE"))() -- Navidad 2025

        end

    else
        Library:Notify("Piso Desconocido", 3)
        SonidoNotificacion:Play()
    end

else
    Library:Notify("No estás en Doors", 3)
    SonidoNotificacion:Play()
end