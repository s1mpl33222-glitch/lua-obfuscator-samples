-- CHINOINFIERNO V3 | SAFE FRIEND | SELECTOR + HIGHLIGHT VERDE + ETIQUETA
-- Base: CELESTIAL_26_FIX_ARRANQUE; resto de funciones conservado.
-- CHINOINFIERNO V3 - BUY PREMIUM + ICONOS DE TABS + PURPLE SKY
-- Base: CHINOINFIERNO_V3_AUTO_REPAIR_30HP_DINERO_ITEMGUID.lua
-- Retirado Auto Repair completamente.
-- Buy: dropdowns reales para Ammo, Gun Crate y Car Crate.
-- Logo Sky: seis caras usando rbxassetid://105275560374583 (logo del HUB).
-- Nota: cambios del cielo son LOCALES, no se sincronizan con otros jugadores.
-- ============================================================
-- CHINOINFIERNO V3 | GAMA BAJA CRISTAL + BLUR SUAVE (SIN CAMBIOS EXTRA)
-- Base: PANEL_ARRANQUE_RESTAURADO. Solo ajustes de Gama Baja.
-- CHINOINFIERNO V3 | ARRANQUE RESTAURADO / GAMA BAJA ORIGINAL
-- Recuperación: eliminado CanvasGroup que interrumpía la creación de la GUI.
-- Todas las opciones previas del HUB se conservan.

-- CHINOINFIERNO V3 | AUTO SHOOT SELECTOR ARMAS + HOLD JUMP + CAR JUMP UI
-- AUTO SHOOT: selector igual al Vehicle (avatar/rareza/armas en tiempo real),
-- espera objetivo visible, armado, fuera de zona segura, dentro de 90 m.
-- PLAYER: salto sostenido mientras se mantiene pulsado; cae al soltar.
-- CAR: boton SALTO 42x42, transparente, comportamiento anterior intacto.
-- El funcionamiento real depende de la replicación y el servidor de BlockSpin.

-- CHINOINFIERNO • FARM V3 / AUTOWIN2 / SKIP CAJAS / TARGET SUPER STICKY+ARMAS / FPS / NORMAL SIN RESPAWN
-- MOD CHINO: AntiKill superficie + Car Ghost ligado a Wallhack + Anti Lock continuo.
-- RECOVERY: regreso a la última versión que sí ejecutaba y mostraba el panel.
--// CHINOINFIERNOHUBv3 - PROJECTILE PREDICTION NO-PING TEST + STAMINA FIX + MOVE CAR + INM + BULLET + ESP REFRESH
--// LocalScript
--// StarterPlayer > StarterPlayerScripts

-- Dump Car debe ser lo primero que se prepara.
if not game:IsLoaded() then
	repeat
		task.wait()
	until game:IsLoaded()
end

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

--========================================================--
-- CHINOINFIERNO CELESTIAL ID | AUTO ON | 26% | ESTABLE
-- Se monta en HumanoidRootPart. No crea botones, sliders ni ScreenGui.
-- Solo efecto local del nombre propio; reanuda tras CharacterAdded.
--========================================================--
task.defer(function()
    local ok, err = pcall(function()
        local Players = game:GetService("Players")
        local RunService = game:GetService("RunService")
        local UserInputService = game:GetService("UserInputService")
        local Player = Players.LocalPlayer
        if not Player then return end
        local PlayerGui = Player:WaitForChild("PlayerGui")

        -- Avoid stacking copies when executed again.
        local sharedState = _G
        pcall(function()
            if type(getgenv) == "function" then sharedState = getgenv() end
        end)
        if type(sharedState.CHINO_CELESTIAL_NAME_CLEANUP) == "function" then
            pcall(sharedState.CHINO_CELESTIAL_NAME_CLEANUP)
        end
        local oldController = PlayerGui:FindFirstChild("CHINO_CELESTIAL_NAME_CONTROLLER")
        if oldController then oldController:Destroy() end
        local oldCharacter = Player.Character
        if oldCharacter then
            local oldTag = oldCharacter:FindFirstChild("CHINO_CELESTIAL_OVERHEAD", true)
            if oldTag then oldTag:Destroy() end
        end

        local COLOR = {
            Night = Color3.fromRGB(14, 9, 31),
            DarkViolet = Color3.fromRGB(35, 13, 58),
            Purple = Color3.fromRGB(161, 64, 255),
            Pink = Color3.fromRGB(248, 63, 220),
            Cyan = Color3.fromRGB(85, 229, 255),
            Ice = Color3.fromRGB(219, 245, 255),
            White = Color3.fromRGB(251, 246, 255),
            Dim = Color3.fromRGB(169, 167, 201)
        }

        local alive = true
        local enabled = true -- Siempre ON mientras CHINOINFIERNO esté ejecutándose.

        -- Size applies to the WHOLE overhead effect, including text, glass card,
        -- neon strips, rotating diamonds, sparks and their glow. 100% = original.
        -- Keep this variable alive through respawns; UI drag never rebuilds the tag.
        local MIN_PERCENT, MAX_PERCENT = 20, 150
        local sizePercent = 26 -- fijo: 26%, sin slider ni toggle
        local overheadUIScale = nil
        local function overheadHeight()
            -- The reduced card should also sit a bit closer to the head.
            return 1.95 + 1.20 * (sizePercent / 100)
        end

        local currentTag = nil
        local currentHumanoid = nil
        local lastNameDistance = setmetatable({}, {__mode = "k"})
        local visualConnection = nil
        local globalConnections = {}

        local function track(connection)
            globalConnections[#globalConnections + 1] = connection
            return connection
        end

        local function make(className, parent, props)
            local obj = Instance.new(className)
            for property, value in pairs(props or {}) do
                obj[property] = value
            end
            obj.Parent = parent
            return obj
        end

        local function rounded(parent, radius)
            return make("UICorner", parent, {CornerRadius = UDim.new(0, radius)})
        end

        local function stroke(parent, color, thickness, alpha)
            return make("UIStroke", parent, {
                Color = color,
                Thickness = thickness,
                Transparency = alpha,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            })
        end

        local function circle(parent, size, color, transparency)
            local part = make("Frame", parent, {
                Size = UDim2.fromOffset(size, size),
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundColor3 = color,
                BackgroundTransparency = transparency or 0,
                BorderSizePixel = 0
            })
            make("UICorner", part, {CornerRadius = UDim.new(1, 0)})
            return part
        end

        local function restoreName(humanoid)
            if not humanoid then return end
            local previous = lastNameDistance[humanoid]
            if previous ~= nil then
                pcall(function() humanoid.NameDisplayDistance = previous end)
                lastNameDistance[humanoid] = nil
            end
        end

        local function hideName(humanoid)
            if not humanoid then return end
            if lastNameDistance[humanoid] == nil then
                lastNameDistance[humanoid] = humanoid.NameDisplayDistance
            end
            -- Keep HP bar untouched; hide only default overhead name.
            pcall(function() humanoid.NameDisplayDistance = 0 end)
        end

        local function removeVisual()
            if visualConnection then
                visualConnection:Disconnect()
                visualConnection = nil
            end
            if currentTag then
                currentTag:Destroy()
                currentTag = nil
            end
            overheadUIScale = nil
            if currentHumanoid then
                restoreName(currentHumanoid)
                currentHumanoid = nil
            end
        end

        local function makeLabel(parent, text, size, font, color, position, dimensions, z)
            return make("TextLabel", parent, {
                Name = "Label",
                Text = text,
                Font = font,
                TextColor3 = color,
                TextSize = size,
                TextScaled = false,
                TextWrapped = false,
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Center,
                TextYAlignment = Enum.TextYAlignment.Center,
                Position = position,
                Size = dimensions,
                ZIndex = z or 1
            })
        end

        local function createOverhead(rootPart, head)
            -- HumanoidRootPart no sigue la animación de la cabeza al correr.
            -- Desplazamiento medido solo una vez al crear el personaje.
            local headRise = math.clamp(head.Position.Y - rootPart.Position.Y, 1.3, 3.4)
            local fixedHeight = headRise + overheadHeight()
            local tag = make("BillboardGui", rootPart, {
                Name = "CHINO_CELESTIAL_OVERHEAD",
                Adornee = rootPart,
                AlwaysOnTop = true,
                LightInfluence = 0,
                MaxDistance = 185,
                ResetOnSpawn = false,
                StudsOffsetWorldSpace = Vector3.new(0, fixedHeight, 0),
                Size = UDim2.fromOffset(410, 145)
            })
            -- One centered canvas + UIScale, NOT just resizing the text or outer frame.
            -- Every effect is inside this root, so the whole animated emblem shrinks
            -- together and its original 410x145 coordinate system stays consistent.
            local root = make("Frame", tag, {
                Name = "EffectCanvas",
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(0.5, 0.5),
                BackgroundTransparency = 1,
                Size = UDim2.fromOffset(410, 145),
                ClipsDescendants = false
            })
            local canvasScale = make("UIScale", root, {
                Scale = sizePercent / 100
            })
            overheadUIScale = canvasScale

            -- Soft aura, layered like frosted purple glass.
            local haze = make("Frame", root, {
                Position = UDim2.fromOffset(18, 38),
                Size = UDim2.fromOffset(374, 83),
                BackgroundColor3 = COLOR.Purple,
                BackgroundTransparency = 0.94,
                BorderSizePixel = 0,
                ZIndex = 1
            })
            rounded(haze, 20)

            local halo = make("Frame", root, {
                Position = UDim2.fromOffset(26, 43),
                Size = UDim2.fromOffset(358, 72),
                BackgroundColor3 = COLOR.Pink,
                BackgroundTransparency = 0.95,
                BorderSizePixel = 0,
                ZIndex = 2
            })
            rounded(halo, 17)

            local plate = make("Frame", root, {
                Position = UDim2.fromOffset(29, 46),
                Size = UDim2.fromOffset(352, 66),
                BackgroundColor3 = COLOR.Night,
                BackgroundTransparency = 0.56,
                BorderSizePixel = 0,
                ZIndex = 3
            })
            rounded(plate, 16)
            local edge = stroke(plate, COLOR.Purple, 1.8, 0.33)
            local edgeGradient = make("UIGradient", edge, {
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, COLOR.Cyan),
                    ColorSequenceKeypoint.new(0.31, COLOR.Purple),
                    ColorSequenceKeypoint.new(0.64, COLOR.Pink),
                    ColorSequenceKeypoint.new(1, COLOR.Cyan)
                }),
                Rotation = 0
            })

            -- Neon top and bottom light strips.
            local topLight = make("Frame", root, {
                Position = UDim2.fromOffset(83, 44),
                Size = UDim2.fromOffset(244, 2),
                BackgroundColor3 = COLOR.Cyan,
                BackgroundTransparency = 0.65,
                BorderSizePixel = 0,
                ZIndex = 6
            })
            rounded(topLight, 2)
            local lowLight = make("Frame", root, {
                Position = UDim2.fromOffset(136, 112),
                Size = UDim2.fromOffset(138, 2),
                BackgroundColor3 = COLOR.Pink,
                BackgroundTransparency = 0.68,
                BorderSizePixel = 0,
                ZIndex = 6
            })
            rounded(lowLight, 2)

            -- Upper insignia: floating metallic badge.
            local crestBase = make("Frame", root, {
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromOffset(205, 25),
                Size = UDim2.fromOffset(148, 23),
                BackgroundColor3 = COLOR.DarkViolet,
                BackgroundTransparency = 0.52,
                BorderSizePixel = 0,
                ZIndex = 8
            })
            rounded(crestBase, 9)
            stroke(crestBase, COLOR.Cyan, 1.25, 0.32)
            makeLabel(crestBase, "C H I N O   //   V I P", 11, Enum.Font.GothamBold, COLOR.Ice,
                UDim2.fromScale(0, 0), UDim2.fromScale(1, 1), 9)

            -- RGB shadow/refraction: glitch accents behind the central text.
            local textArea = UDim2.fromOffset(352, 40)
            local shadowA = makeLabel(root, "CHINOINFIERNO", 30, Enum.Font.GothamBlack,
                COLOR.Pink, UDim2.fromOffset(31, 60), textArea, 7)
            shadowA.TextTransparency = 0.86
            local shadowB = makeLabel(root, "CHINOINFIERNO", 30, Enum.Font.GothamBlack,
                COLOR.Cyan, UDim2.fromOffset(27, 58), textArea, 7)
            shadowB.TextTransparency = 0.89

            local mainText = makeLabel(root, "CHINOINFIERNO", 30, Enum.Font.GothamBlack,
                COLOR.White, UDim2.fromOffset(29, 59), textArea, 10)
            mainText.TextTransparency = 0.15
            mainText.TextStrokeColor3 = COLOR.DarkViolet
            mainText.TextStrokeTransparency = 0.62
            local textGradient = make("UIGradient", mainText, {
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, COLOR.Purple),
                    ColorSequenceKeypoint.new(0.25, COLOR.Ice),
                    ColorSequenceKeypoint.new(0.5, COLOR.White),
                    ColorSequenceKeypoint.new(0.72, COLOR.Pink),
                    ColorSequenceKeypoint.new(1, COLOR.Cyan)
                }),
                Rotation = 5
            })

            -- Energy scanner across the letters, clipped inside the glowing card.
            local scannerMask = make("Frame", plate, {
                Position = UDim2.fromOffset(12, 3),
                Size = UDim2.fromOffset(328, 60),
                BackgroundTransparency = 1,
                ClipsDescendants = true,
                ZIndex = 11
            })
            local scanner = make("Frame", scannerMask, {
                Position = UDim2.fromOffset(-40, 0),
                Size = UDim2.fromOffset(26, 60),
                BackgroundColor3 = COLOR.White,
                BackgroundTransparency = 0.94,
                Rotation = 14,
                BorderSizePixel = 0,
                ZIndex = 11
            })
            make("UIGradient", scanner, {
                Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 1),
                    NumberSequenceKeypoint.new(0.48, 0.28),
                    NumberSequenceKeypoint.new(1, 1)
                })
            })

            -- Magnetic diamonds and drifting sparks (built entirely with Roblox UI).
            local diamonds = {}
            for i = 1, 4 do
                local diamond = make("Frame", root, {
                    Size = UDim2.fromOffset(9, 9),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    BackgroundColor3 = i % 2 == 0 and COLOR.Cyan or COLOR.Pink,
                    BackgroundTransparency = 0.44,
                    BorderSizePixel = 0,
                    Rotation = 45,
                    ZIndex = 8
                })
                stroke(diamond, COLOR.White, 0.6, 0.53)
                diamonds[#diamonds + 1] = diamond
            end

            local particles = {}
            for i = 1, 14 do
                local particle = circle(root, (i % 3) + 2,
                    i % 3 == 0 and COLOR.Cyan or (i % 2 == 0 and COLOR.Pink or COLOR.Purple),
                    0.51)
                particle.ZIndex = 8
                particles[#particles + 1] = particle
            end

            local orbitCenter = Vector2.new(205, 79)
            local startingTime = os.clock()
            local acc = 0
            local animation
            animation = RunService.Heartbeat:Connect(function(dt)
                if not alive or not enabled or not tag.Parent then
                    if animation then animation:Disconnect() end
                    return
                end
                acc = acc + dt
                if acc < (1 / 30) then return end
                acc = 0

                local t = os.clock() - startingTime
                -- Altura fija durante toda la animación: sin vibración al correr.
                edgeGradient.Rotation = (t * 27) % 360
                textGradient.Offset = Vector2.new(math.sin(t * 0.78) * 0.3, 0)
                edge.Transparency = 0.35 + 0.21 * (0.5 + 0.5 * math.sin(t * 2.0))
                haze.BackgroundTransparency = 0.93 + 0.05 * (0.5 + 0.5 * math.sin(t * 2.2))
                halo.BackgroundTransparency = 0.94 + 0.05 * (0.5 + 0.5 * math.sin(t * 1.7))
                topLight.BackgroundTransparency = 0.65 + 0.20 * (0.5 + 0.5 * math.sin(t * 2.4))
                lowLight.BackgroundTransparency = 0.66 + 0.20 * (0.5 + 0.5 * math.sin(t * 3.1))
                scanner.Position = UDim2.fromOffset(-40 + (t * 84) % 408, 0)

                -- Texto y sombras permanecen inmóviles; solo se animan las luces.
                for i, diamond in ipairs(diamonds) do
                    local a = t * 0.76 + (i - 1) * math.pi / 2
                    local rx = 190 * math.cos(a)
                    local ry = 51 * math.sin(a)
                    diamond.Position = UDim2.fromOffset(orbitCenter.X + rx, orbitCenter.Y + ry)
                    diamond.Rotation = 45 + (t * 92) % 360
                    diamond.BackgroundTransparency = 0.43 + 0.35 * (0.5 + 0.5 * math.sin(t * 3 + i))
                end
                for i, particle in ipairs(particles) do
                    local speed = 0.34 + (i % 4) * 0.14
                    local a = t * speed + (i * 2.39996)
                    local rx = (180 + (i % 3) * 13) * math.cos(a)
                    local ry = (39 + (i % 5) * 8) * math.sin(a * 1.37)
                    particle.Position = UDim2.fromOffset(orbitCenter.X + rx,
                        orbitCenter.Y + ry - math.sin(t * 1.1 + i) * 9)
                    particle.BackgroundTransparency = 0.55 + 0.40 *
                        (0.5 + 0.5 * math.sin(t * 2.9 + i * 1.65))
                end
            end)
            visualConnection = animation
            return tag
        end

        local nameWatch = nil
        local function installOnCharacter(character)
            if not alive or character ~= Player.Character then return end
            local head = character:FindFirstChild("Head") or character:WaitForChild("Head", 12)
            local rootPart = character:FindFirstChild("HumanoidRootPart")
                or character:WaitForChild("HumanoidRootPart", 12)
            local hum = character:FindFirstChildOfClass("Humanoid") or character:WaitForChild("Humanoid", 12)
            if not alive or character ~= Player.Character then return end
            if not head or not hum or not rootPart then return end
            -- Rebind on respawn; disconnect any old observer before updating the humanoid.
            if nameWatch then nameWatch:Disconnect(); nameWatch = nil end
            removeVisual()
            currentHumanoid = hum
            hideName(hum)
            nameWatch = hum:GetPropertyChangedSignal("NameDisplayDistance"):Connect(function()
                if alive and currentHumanoid == hum and hum.NameDisplayDistance ~= 0 then
                    hideName(hum)
                end
            end)
            currentTag = createOverhead(rootPart, head)
        end


        local function cleanup()
            if not alive then return end
            alive = false
            enabled = false
            if nameWatch then nameWatch:Disconnect(); nameWatch = nil end
            removeVisual()
            for _, connection in ipairs(globalConnections) do
                pcall(function() connection:Disconnect() end)
            end
            if sharedState.CHINO_CELESTIAL_NAME_CLEANUP == cleanup then
                sharedState.CHINO_CELESTIAL_NAME_CLEANUP = nil
            end
        end
        sharedState.CHINO_CELESTIAL_NAME_CLEANUP = cleanup
        track(Player.CharacterAdded:Connect(function(character)
            task.spawn(installOnCharacter, character)
        end))
        if Player.Character then
            task.spawn(installOnCharacter, Player.Character)
        end
    end)
    if not ok then
        warn("[CHINO CELESTIAL 26%] No se pudo instalar:", err)
    end
end)
--========================================================--
local Camera = workspace.CurrentCamera

--========================================================--
-- DUMP CAR - BOOTSTRAP PRIORITARIO
-- Se inicializa ANTES que toda la lógica/UI del HUB.
-- NO crea botón flotante ni ScreenGui propio.
-- Arranca activado por defecto.
--========================================================--

local DumpCarRuntime = {
	Enabled = true,
	Ready = false,
	Supported = (
		game.PlaceId == 104715542330896
		or game.PlaceId == 97556409405464
	),
	Generation = 0,
	Running = false,
	Net = nil,
	VehicleModule = nil,
	CharModule = nil,
	Client = Player,
}

function DumpCarRuntime.Init()
	-- Mismo bypass inicial del módulo proporcionado.
	pcall(function()
		if getgenv then
			getgenv().identifyexecutor = nil
		end

		if getfenv then
			local env = getfenv()
			env.identifyexecutor = nil
		end
	end)

	if not DumpCarRuntime.Supported then
		DumpCarRuntime.Ready = false
		return false
	end

	local ok, err = pcall(function()
		local modules =
			ReplicatedStorage:WaitForChild("Modules")

		local core =
			modules:WaitForChild("Core")

		DumpCarRuntime.Net =
			require(core:WaitForChild("Net"))

		DumpCarRuntime.VehicleModule =
			require(
				modules
					:WaitForChild("Game")
					:WaitForChild("VehicleSystem")
					:WaitForChild("Vehicle")
			)

		DumpCarRuntime.CharModule =
			require(core:WaitForChild("Char"))
	end)

	if not ok then
		DumpCarRuntime.Ready = false
		warn("[CHINO] Dump Car no pudo iniciar:", err)
		return false
	end

	DumpCarRuntime.Ready = true
	return true
end

function DumpCarRuntime.GetDistanceFromRootPart(targetRoot)
	local char =
		DumpCarRuntime.Client
		and DumpCarRuntime.Client.Character

	local root =
		char
		and char:FindFirstChild("HumanoidRootPart")

	if not root or not targetRoot then
		return math.huge
	end

	return (root.Position - targetRoot.Position).Magnitude
end

-- Bump Aura original de ZEION: obtener carro, enumerar personajes,
-- comprobar distancia y enviar run_over con la velocidad del DriverSeat.
-- Dump Car restaurado: intervalo 0.07 s, alcance 100 studs, impulso Vector3.new(115,115,115).
function DumpCarRuntime.StartLoop()
	if not DumpCarRuntime.Ready
		or not DumpCarRuntime.Enabled
		or DumpCarRuntime.Running then
		return
	end

	DumpCarRuntime.Generation += 1
	local generation = DumpCarRuntime.Generation
	DumpCarRuntime.Running = true

	task.spawn(function()
		while DumpCarRuntime.Enabled
			and DumpCarRuntime.Ready
			and DumpCarRuntime.Generation == generation do

			task.wait(0.07)

			-- CHINOINFIERNO original: 0.07 s / 100 studs / impulso 115.
			pcall(function()
				local car = DumpCarRuntime.VehicleModule.get_car_player_is_in()
				if not car then
					return
				end

				local driverSeat = car:FindFirstChild("DriverSeat", true)
				if not driverSeat or not driverSeat:IsA("BasePart") then
					return
				end

				for _, target in DumpCarRuntime.CharModule.get_all() do
					if target and target ~= DumpCarRuntime.Client.Character then
						local hrp = target:FindFirstChild("HumanoidRootPart")
						if hrp and DumpCarRuntime.GetDistanceFromRootPart(hrp) < 100 then
							local assembly = driverSeat.AssemblyLinearVelocity
								+ Vector3.new(115, 115, 115)
							DumpCarRuntime.Net.send("run_over", car, target, assembly)
						end
					end
				end
			end)
		end

		if DumpCarRuntime.Generation == generation then
			DumpCarRuntime.Running = false
		end
	end)
end

function DumpCarRuntime.SetEnabled(value)
	DumpCarRuntime.Enabled =
		value == true

	-- Compatibilidad con el nombre del módulo original.
	_G.BumpAura =
		DumpCarRuntime.Enabled

	if DumpCarRuntime.Enabled then
		DumpCarRuntime.StartLoop()
	else
		-- Invalida inmediatamente el loop activo.
		DumpCarRuntime.Generation += 1
		DumpCarRuntime.Running = false
	end
end

-- Se ejecuta primero que el resto del HUB.
-- Si el lugar no es compatible, el HUB continúa normalmente.
DumpCarRuntime.Init()
DumpCarRuntime.SetEnabled(true)

--========================================================--
-- LÓGICA Y VARIABLES DE ESTADO
--========================================================--

local SilentAimEnabled = false

-- Silent Aim exacto: HEAD sigue siendo el default para conservar
-- exactamente el comportamiento actual hasta que se seleccione otro punto.
local SilentAimHitPart = "Head"

local TargetHitPart = "Neck"
local CurrentLockedTarget = nil
local CurrentTarget = nil
local WallbangEnabled = false

-- Variables Soft Aim (Mobile & PC)
local SoftAimMobileEnabled = false
local SoftAimMobilePart = "Neck"
local SoftAimMobileFOV = false
local SoftAimMobileFOVRadius = 95

local SoftAimPCEnabled = false
local SoftAimPCPart = "Neck"
local SoftAimPCFOV = false
local SoftAimPCFOVRadius = 95
local SoftAimPCKey = Enum.KeyCode.E
local SoftAimPCHolding = false

local InfiniteJumpEnabled = false
local JumpPowerBypassValue = 50
local InfStaminaEnabled = false
local OriginalSprintUpdate = nil
local AutoSprintLoop = nil

local SpeedHackEnabled = false
local SpeedValue = 4

local SkipCratesEnabled = false
local PotatoBoostEnabled = false
local AntiKillEnabled = false
local TouchPanelEnabled = false
local TouchPanelValue = 20

local PlayerESP_Box = false
local PlayerESP_Name = false
local PlayerESP_Health = false
local PlayerESP_Dist = false
local PlayerESP_Highlight = false
local WeaponESPEnabled = false
local ItemESPEnabled = false

local SettingsVisual = {
	Box = false,
	PlayerESP_Lines = false,
	FOV = false,
	TargetLine = true,
	FOVRadius = 120,

	--====================================================--
	-- CALIBRACION VISUAL FINAL CHINO
	-- Valores confirmados manualmente en el calibrador.
	-- SOLO afectan visuales; Silent Aim / impactos no cambian.
	--====================================================--
	TargetLineStartXOffset = 61,
	TargetLineStartYOffset = 10,
	TargetLineEndXOffset = 64,

	BoxOffsetX = 61,
	BoxOffsetY = 0,

	LinesOffsetX = 60,
	LinesOffsetY = 0,

	HealthOffsetX = 0,
	HealthOffsetY = 0,

	TargetLineThickness = 1,
	SoftAimMobileWallcheck = false,
	SoftAimPCWallcheck = false,
	-- Soft Aim caminando queda exactamente como estaba.
	-- Estos offsets SOLO se aplican al ir sentado en un vehículo.
	-- X e Y son independientes: mover uno no modifica el otro.
	VehicleAimOffsetX = -30,
	VehicleAimOffsetY = -30
}

-- Registro interno de controles para Guardar/Cargar/Reset Config.
-- Se guarda en SettingsVisual para no aumentar los locales principales del chunk.
SettingsVisual.ConfigControls = {}
SettingsVisual.ConfigKeyCounts = {}
SettingsVisual.ConfigFolder = "CHINOINFIERNOHUBv3"
SettingsVisual.ConfigFile = "CHINOINFIERNOHUBv3_config.json"
SettingsVisual.ConfigLoaded = false

-- Funciones traídas de ROBADO.txt sin aumentar los locales principales.
SettingsVisual.ShotMultiplier = 1
SettingsVisual.SelectedAmmoType = "Pistol"
SettingsVisual.AmmoTypes = {"Pistol", "Rifle", "Shotgun", "Random"}

--========================================================--
-- CHINOINFIERNO V3 | SAFE FRIEND (por UserId, un amigo)
-- Exclusion de target, disparo asistido y Target Line; sin tocar el servidor.
--========================================================--
SettingsVisual.SafeFriendUserId = nil
SettingsVisual.SafeFriendMarkedCharacter = nil
SettingsVisual.IsSafeFriend = function(other)
    return other ~= nil
        and SettingsVisual.SafeFriendUserId ~= nil
        and other.UserId == SettingsVisual.SafeFriendUserId
end
SettingsVisual.GetSafeFriendPlayer = function()
    local id = SettingsVisual.SafeFriendUserId
    if id == nil then return nil end
    for _, other in ipairs(Players:GetPlayers()) do
        if other.UserId == id then return other end
    end
    return nil
end
SettingsVisual.SetSafeFriend = function(other)
    if other == Player then other = nil end
    SettingsVisual.SafeFriendUserId = other and other.UserId or nil

    -- Soltar INMEDIATAMENTE el target antiguo para que el aim/line no
    -- siga usando una seleccion cacheada cuando se protege al amigo.
    SettingsVisual.SourceSilentTarget = nil
    SettingsVisual.AutoShootSendOverride = nil
    SettingsVisual.AutoShootLockedTarget = nil
    SettingsVisual.AutoShootScanNext = 0
    if other and SettingsVisual.AutoShootSelectedPlayer == other then
        SettingsVisual.AutoShootSelectedPlayer = nil
    end
    if other and SettingsVisual.SelectedVehiclePlayer == other then
        SettingsVisual.SelectedVehiclePlayer = nil
    end
    if other and SettingsVisual.SoftAimLockedTarget == other then
        SettingsVisual.SoftAimLockedTarget = nil
    end
    if other and SettingsVisual.StrongAimbotTarget == other then
        SettingsVisual.StrongAimbotTarget = nil
    end
    if SettingsVisual.TargetSticky then
        SettingsVisual.TargetSticky.Locked = nil
        SettingsVisual.TargetSticky.LockForward = nil
        SettingsVisual.TargetSticky.CacheAt = 0
        SettingsVisual.TargetSticky.CacheValue = nil
    end
    CurrentTarget = nil
    CurrentLockedTarget = nil
    SettingsVisual.DirectVisualLockedTarget = nil
    if SettingsVisual.HideNewTargetVisuals then
        pcall(SettingsVisual.HideNewTargetVisuals)
    end
end

SettingsVisual.UpdateSafeFriendMarker = function()
    local selected = SettingsVisual.GetSafeFriendPlayer()
    local character = selected and selected.Character
    local head = character and character:FindFirstChild("Head")
    local old = SettingsVisual.SafeFriendMarkedCharacter

    -- Quitar resaltado y nombre al cambiar / quitar Safe Friend.
    if old and (old ~= character or not head or not old.Parent) then
        local oldHighlight = old:FindFirstChild("CHINO_SafeFriendHighlight")
        if oldHighlight then oldHighlight:Destroy() end
        local oldGui = old:FindFirstChild("CHINO_SafeFriendTag", true)
        if oldGui then oldGui:Destroy() end
        SettingsVisual.SafeFriendMarkedCharacter = nil
    end
    if not character or not head then return end

    -- Highlight independiente: sigue verde aunque ESP Highlight este OFF.
    local hl = character:FindFirstChild("CHINO_SafeFriendHighlight")
    if not hl then
        hl = Instance.new("Highlight")
        hl.Name = "CHINO_SafeFriendHighlight"
        hl.Parent = character
    end
    hl.Adornee = character
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.FillColor = Color3.fromRGB(46, 245, 109)
    hl.FillTransparency = 0.59
    hl.OutlineColor = Color3.fromRGB(132, 255, 151)
    hl.OutlineTransparency = 0
    hl.Enabled = true

    -- Etiqueta PEQUENA encima de su cabeza, fija al Head (respawn seguro).
    local tag = head:FindFirstChild("CHINO_SafeFriendTag")
    if not tag then
        tag = Instance.new("BillboardGui")
        tag.Name = "CHINO_SafeFriendTag"
        tag.Size = UDim2.fromOffset(112, 19)
        tag.StudsOffsetWorldSpace = Vector3.new(0, 1.65, 0)
        tag.AlwaysOnTop = true
        tag.MaxDistance = 1400
        tag.Parent = head
        local plate = Instance.new("TextLabel")
        plate.Name = "Label"
        plate.Size = UDim2.fromScale(1, 1)
        plate.BackgroundColor3 = Color3.fromRGB(13, 32, 24)
        plate.BackgroundTransparency = 0.19
        plate.BorderSizePixel = 0
        plate.Text = "MY DOG🐕"
        plate.Font = Enum.Font.GothamBold
        plate.TextSize = 10
        plate.TextColor3 = Color3.fromRGB(163, 255, 187)
        plate.TextStrokeTransparency = 0.76
        plate.Parent = tag
        Instance.new("UICorner", plate).CornerRadius = UDim.new(0, 6)
        local stroke = Instance.new("UIStroke", plate)
        stroke.Color = Color3.fromRGB(75, 235, 118)
        stroke.Thickness = 0.8
        stroke.Transparency = 0.26
    end
    local friendLabel = tag:FindFirstChild("Label")
    if friendLabel and friendLabel:IsA("TextLabel") then
        friendLabel.Text = "MY DOG🐕"
    end
    tag.Adornee = head
    tag.Enabled = true
    SettingsVisual.SafeFriendMarkedCharacter = character
end
-- Cajas de armas y vehículos: categorías originales del script BlockSpin/DeepSeek.
-- Requieren dinero en mano, estar cerca del mostrador y aprobación del servidor.
SettingsVisual.GunCrateTypes = {"Basic", "Advanced", "Superior", "Elite", "Legendary", "Omega"}
SettingsVisual.CarCrateTypes = {"Basic", "Rare", "Elite", "Omega"}
SettingsVisual.SelectedGunCrate = "Basic"
SettingsVisual.SelectedCarCrate = "Basic"

-- Compatibilidad / nuevas funciones. Se guardan en SettingsVisual para no sumar locals.
SettingsVisual.INMEnabled = false
SettingsVisual.BulletEnabled = false
SettingsVisual.BulletRadius = 8

-- Silent Aim del script CODIGOS DE(3): motor independiente del aim viejo.
SettingsVisual.SilentAimNoWallcheck = true
SettingsVisual.SourceSilentTarget = nil
SettingsVisual.SourceSilentVelocityHistory = {}
SettingsVisual.SourceSilentVelocitySamples = 6
SettingsVisual.SourceSilentVelocityMultiplier = 1.2
SettingsVisual.SourceSilentVerticalThreshold = 150

-- CHINO: opciones independientes para no sustituir el Silent Aim ni los mods existentes.
-- Se inician apagadas; al activarlas usan el algoritmo de CHINO.
SettingsVisual.ChinoSmartPredictEnabled = false
SettingsVisual.ChinoVelocityThreshold = 250
SettingsVisual.ChinoPredictHistory = {}
SettingsVisual.ChinoPredictSpikes = {}
-- Gun Aura: dispara SOLO al objetivo que selecciona Silent Aim.
SettingsVisual.GunAuraEnabled = false
SettingsVisual.GunAuraInterval = 0.18
SettingsVisual.GunAuraLastShot = 0
-- Nuevas funciones: conectadas al motor de disparos existente, sin otro hook.
SettingsVisual.AutoShootEnabled = false
SettingsVisual.AutoShoot360Enabled = false  -- casilla CENTRAL del Panel Táctil
-- Roblox: 1 stud ~= 0.28 m. El radio del Auto Shoot es 90 metros.
SettingsVisual.AutoShootRangeStuds = 90 / 0.28 -- 90 metros ~= 321 studs
SettingsVisual.AutoShootInterval = 1.0 -- multiplicador de cadencia NORMAL del arma
SettingsVisual.AutoShootTPGap = 0.20 -- disparo rapido durante TP derecho (respeta cadencia si existe)
SettingsVisual.AutoShootTPFirstHold = 0.58 -- primer TPx3: menos de 1 segundo, pero visible
SettingsVisual.AutoShootTPOtherHold = 0.36 -- TP segundo/tercero
SettingsVisual.AutoShootScanNext = 0
-- AutoShoot usa el ritmo y la munición de cada arma, sin ráfagas aceleradas.
SettingsVisual.AutoShootLockedTarget = nil
SettingsVisual.AutoShootMagazineState = setmetatable({}, {__mode="k"})
SettingsVisual.AutoShootSafeZones = { Parts={}, RefreshAt=0 }
SettingsVisual.AutoShootLastGun = nil
SettingsVisual.AutoShootSendOverride = nil

-- ANTI AUTO SIT
-- Se guarda en SettingsVisual para no sumar locals al chunk principal.
SettingsVisual.AntiAutoSitEnabled = false

-- ESP: render estable en móvil/tablet.
SettingsVisual.ESPMaxRenderDistance = 1000000

SettingsVisual.VehicleSlidersEnabled = false
SettingsVisual.ExecutorGuiParent = nil
SettingsVisual.SoftAimMobileHolding = false
SettingsVisual.SoftAimTriggerLocked = false
SettingsVisual.SoftAimTriggerHidden = false
SettingsVisual.SoftAimHiddenTriggerInput = nil
SettingsVisual.SoftAimLockedTarget = nil
SettingsVisual.SoftAimControlKey = Enum.KeyCode.ButtonL2
SettingsVisual.SelectingSoftAimControlKey = false

-- Aimbot fuerte: queda amarrado al target y solo cambia con un movimiento
-- intencional/fuerte de cámara hacia otro jugador dentro del FOV.
SettingsVisual.StrongAimbotEnabled = false
SettingsVisual.StrongAimbotTarget = nil
SettingsVisual.StrongAimbotBreakAngle = 22
SettingsVisual.StrongAimbotKeepRadiusScale = 1.35
SettingsVisual.StrongAimbotSwitchRadiusScale = 0.48
SettingsVisual.TouchPanelKey = Enum.KeyCode.E
SettingsVisual.GhostKey = Enum.KeyCode.Q
SettingsVisual.TouchLeftBoxKey = Enum.KeyCode.Z
SettingsVisual.TouchRightBoxKey = Enum.KeyCode.X
SettingsVisual.SelectingTouchPanelKey = false
SettingsVisual.SelectingGhostKey = false
SettingsVisual.SelectingTouchLeftBoxKey = false
SettingsVisual.SelectingTouchRightBoxKey = false
SettingsVisual.TouchPanelUpMode = false
SettingsVisual.TouchPanelSavedValue = nil
SettingsVisual.FlingTPPanelEnabled = false
SettingsVisual.PanelIsOpen = false
SettingsVisual.ThemeColor = nil
SettingsVisual.ThemeBright = nil
SettingsVisual.ExecutorName = "Unknown"
SettingsVisual.IsXeno = false
pcall(function()
	if identifyexecutor then
		SettingsVisual.ExecutorName = tostring(identifyexecutor())
	elseif getexecutorname then
		SettingsVisual.ExecutorName = tostring(getexecutorname())
	end
	SettingsVisual.IsXeno = string.find(string.lower(SettingsVisual.ExecutorName), "xeno", 1, true) ~= nil
end)

-- Nieve decorativa ligera para el panel principal y los dos paneles flotantes.
SettingsVisual.AddSnowEffect = function(parent, count, zIndex)
	if not parent then return end
	for i = 1, count do
		local flake = Instance.new("TextLabel")
		flake.Name = "SnowFlake"
		flake.Size = UDim2.fromOffset(math.random(5, 10), math.random(5, 10))
		flake.BackgroundTransparency = 1
		flake.Text = (i % 4 == 0) and "✦" or "•"
		flake.TextColor3 = (i % 3 == 0) and Color3.fromRGB(175, 190, 255) or Color3.fromRGB(205, 230, 255)
		flake.TextTransparency = math.random(15, 50) / 100
		flake.TextScaled = true
		flake.Font = Enum.Font.GothamBold
		flake.ZIndex = zIndex or 2
		flake.Parent = parent

		task.spawn(function()
			task.wait(math.random() * 2.5)
			while flake.Parent and parent.Parent do
				local startX = math.random()
				local drift = (math.random(-18, 18) / 100)
				flake.Position = UDim2.fromScale(startX, -0.08)
				flake.Rotation = math.random(-25, 25)
				flake.TextTransparency = math.random(10, 42) / 100
				local tween = TweenService:Create(
					flake,
					TweenInfo.new(math.random(30, 60) / 10, Enum.EasingStyle.Linear),
					{
						Position = UDim2.fromScale(math.clamp(startX + drift, 0, 1), 1.08),
						Rotation = flake.Rotation + math.random(-55, 55),
						TextTransparency = 0.65
					}
				)
				tween:Play()
				tween.Completed:Wait()
			end
		end)
	end
end


local MeleeAuraEnabled = false
local AutoAttackEnabled = false
local AutoPickupEnabled = false -- Desactivado por defecto como pediste
local AutoPickupRadius = 85
local HideNameEnabled = false

local HighlightCache = {}
local PlayerBillboards = {}
local VisualPlayerObjects = {}
local WeaponBillboardCache = {}
local WeaponCacheTokens = {}
-- Limpia restos de paneles ESP Armas de ejecuciones anteriores.
-- Ejecutar SOLO un script por sesion para evitar que un bucle viejo los recree.
task.defer(function()
    for _,guiObject in ipairs(PlayerGui:GetChildren()) do
        if guiObject:IsA("BillboardGui") and guiObject.Name:match("^WeaponESP_") then
            pcall(function() guiObject:Destroy() end)
        end
    end
end)
local ItemDrawingsCache = {}
local RegisteredWeaponDB = {}
local VelocityHistory = {}

-- Variables para el Autopickup avanzado del segundo script
local ak = false -- Sincronizado con AutoPickupEnabled
local al = {}

-- Optimización de red/rendimiento: evita ráfagas repetidas que pueden sentirse como ping alto.
SettingsVisual.NetworkPickupCooldown = 0.25
SettingsVisual.NetworkPickupBatch = 6
SettingsVisual.NetworkAutoAttackInterval = 0.40 -- NGU4 Auto Attack (solo melee equipada)
SettingsVisual.NetworkKillAuraInterval = 0.08
SettingsVisual.NetworkMobileVisualHz = 24
SettingsVisual.NetworkPCVisualHz = 30
SettingsVisual.AutoAttackNextSend = 0 -- Conservado para compatibilidad de config; no usado por NGU4.

local function ChinoNormalizarIcono(value)
    if value == nil then return nil end
    local id=tostring(value):gsub("^%s+", ""):gsub("%s+$", "")
    if id=="" or id=="nil" or id=="0" then return nil end
    if id:match("^%d+$") then id="rbxassetid://"..id end
    -- Estos no son iconos de armas: son placeholders de UI (X/blanco).
    if id=="rbxassetid://7072725737" or id=="rbxassetid://0"
       or id=="rbxassetid://" then return nil end
    if id:match("^rbxassetid://%d+$")
        or id:match("^rbxthumb://")
        or id:match("^rbxasset://")
        or id:match("^rbxgameasset://")
        or id:match("^https?://") then
        return id
    end
    return nil
end

local RarityColors = {
	Common = Color3.fromRGB(255, 255, 255),
	Uncommon = Color3.fromRGB(99, 255, 52),
	Rare = Color3.fromRGB(51, 170, 255),
	Epic = Color3.fromRGB(237, 44, 255),
	Legendary = Color3.fromRGB(255, 150, 0),
	Omega = Color3.fromRGB(255, 20, 51)
}

local ItemsFolder = ReplicatedStorage:WaitForChild("Items", 10)
local DroppedItems = workspace:WaitForChild("DroppedItems", 10)

local function registerFolderItems(folder)
	if not folder then return end
	for _, item in ipairs(folder:GetChildren()) do
		if item:IsA("Tool") then
			local handle = item:FindFirstChild("Handle")
			local dName = item:GetAttribute("DisplayName") or item.Name
			local iId = item:GetAttribute("ItemId") or item:GetAttribute("Id") or item.Name
			local rarity = item:GetAttribute("RarityName") or "Common"
			local img = item:GetAttribute("ImageId") or ""
			local key
			if handle then
				local mesh = handle:FindFirstChildOfClass("SpecialMesh")
				if mesh and mesh.MeshId ~= "" then
					key = mesh.MeshId .. (mesh.TextureId or "") .. "_RARITY_" .. rarity
				elseif handle:IsA("MeshPart") and handle.MeshId ~= "" then
					key = handle.MeshId .. (handle.TextureID or "") .. "_RARITY_" .. rarity
				end
			end
			if not key and iId ~= "" and iId ~= item.Name then key = "ITEMID_" .. iId .. "_RARITY_" .. rarity end
			if not key then key = "NAME_" .. dName .. "_" .. item.Name .. "_RARITY_" .. rarity end
			RegisteredWeaponDB[key] = {Name = dName, Rarity = rarity, ImageId = img, ToolName = item.Name}
		end
	end
end
if ItemsFolder then
	for _, sub in ipairs({"gun", "melee", "throwable", "consumable", "farming", "misc", "rod", "fish"}) do
		registerFolderItems(ItemsFolder:FindFirstChild(sub))
	end
end

local function getWeaponData(tool)
	if not tool or not tool:IsA("Tool") then return nil end
	local handle = tool:FindFirstChild("Handle")
	local dName = tool:GetAttribute("DisplayName") or tool.Name
	local iId = tool:GetAttribute("ItemId") or tool:GetAttribute("Id") or tool.Name
	local rarity = tool:GetAttribute("RarityName") or "Common"
	local key
	if handle then
		local mesh = handle:FindFirstChildOfClass("SpecialMesh")
		if mesh and mesh.MeshId ~= "" then key = mesh.MeshId .. (mesh.TextureId or "") .. "_RARITY_" .. rarity
		elseif handle:IsA("MeshPart") and handle.MeshId ~= "" then key = handle.MeshId .. (handle.TextureID or "") .. "_RARITY_" .. rarity end
	end
	if not key and iId ~= "" and iId ~= tool.Name then key = "ITEMID_" .. iId .. "_RARITY_" .. rarity end
	if not key then key = "NAME_" .. dName .. "_" .. tool.Name .. "_RARITY_" .. rarity end
	return RegisteredWeaponDB[key]
end

local RemotesFolder = ReplicatedStorage:WaitForChild("Remotes", 10)
local SendRemote = RemotesFolder and (RemotesFolder:FindFirstChild("Send") or RemotesFolder:FindFirstChild("FireServer"))
local GetRemote = ReplicatedStorage and ReplicatedStorage:FindFirstChild("Get")

local RemoteCounter
pcall(function()
	if getgc then
		for _, obj in ipairs(getgc(true)) do
			if typeof(obj) == "table" and rawget(obj, "event") and rawget(obj, "func") then
				RemoteCounter = obj
				break
			end
		end
	end
end)

local function FireServerHook(...)
	if not SendRemote then return false end
	local args = {...}
	if RemoteCounter and type(RemoteCounter.event) == "number" then
		RemoteCounter.event = RemoteCounter.event + 1
		local ok = pcall(function()
			SendRemote:FireServer(RemoteCounter.event, unpack(args))
		end)
		return ok
	else
		local ok = pcall(function()
			SendRemote:FireServer(unpack(args))
		end)
		return ok
	end
end

local function InvokeServerHook(...)
	if not GetRemote then return end
	local args = {...}
	if RemoteCounter and type(RemoteCounter.func) == "number" then
		RemoteCounter.func = RemoteCounter.func + 1
		local ok, res = pcall(function() return GetRemote:InvokeServer(RemoteCounter.func, unpack(args)) end)
		return res
	else
		local ok, res = pcall(function() return GetRemote:InvokeServer(unpack(args)) end)
		return res
	end
end

-- NetGet específico del segundo script para recoger ítems correctamente
local function NetGet(...)
	if not RemoteCounter or not RemoteCounter.func then return end
	local args = {...}
	for i, v in ipairs(args) do
		if typeof(v) == "Instance" then
			if v:IsA("Model") and #v:GetChildren() == 0 then
				local droppedFolder = workspace:FindFirstChild("DroppedItems")
				if droppedFolder then
					local firstModel = droppedFolder:FindFirstChildWhichIsA("Model")
					if firstModel then
						args[i] = firstModel
					else
						return
					end
				else
					return
				end
			end
		end
	end
	RemoteCounter.func = (RemoteCounter.func or 0) + 1
	local ok, res = pcall(function()
		local getRem = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Get")
		return getRem:InvokeServer(RemoteCounter.func, unpack(args))
	end)
	return res
end

local function CreateVisualPlayerObjects(player)
	if player == Player then return end
	local data = {}

	local box = Instance.new("SelectionBox")
	box.Name = "ESPBox"
	box.LineThickness = 0.022
	box.Color3 = Color3.fromRGB(0, 0, 0)
	box.SurfaceTransparency = 1
	box.Visible = false
	box.Parent = workspace.CurrentCamera or workspace
	data.Box = box

	VisualPlayerObjects[player] = data
end

local function RemoveVisualPlayerObjects(player)
	if SettingsVisual and SettingsVisual.RemoveModernESP then
		SettingsVisual.RemoveModernESP(player)
	end
	local data = VisualPlayerObjects[player]
	if data and data.Box then data.Box:Destroy() end
	VisualPlayerObjects[player] = nil
	if PlayerBillboards[player] then
		if PlayerBillboards[player].Billboard then PlayerBillboards[player].Billboard:Destroy() end
		PlayerBillboards[player] = nil
	end
	if WeaponBillboardCache[player] then
		pcall(function() WeaponBillboardCache[player]:Destroy() end)
		WeaponBillboardCache[player] = nil
	end
	if HighlightCache[player] then
		HighlightCache[player]:Destroy()
		HighlightCache[player] = nil
	end
end

for _, pl in ipairs(Players:GetPlayers()) do CreateVisualPlayerObjects(pl) end
Players.PlayerAdded:Connect(CreateVisualPlayerObjects)
Players.PlayerRemoving:Connect(RemoveVisualPlayerObjects)

for _, guiName in ipairs({
	"ChinoNeonBackground",
	"ChinoIntro",
	"ChinoIntroFinal",
	"CHINOINFIERNOHUB",
	"CHINOHUB_ModernUI",
	"FloatingSnapGui",
	"AstralProjectionGui",
	"GhostFloatingSwitchGui",
	"TouchPanelGui",
    "ChinoLanguageSelector",
    "CHINO_RareWeaponAlerts",
    "CHINO_MoveCar360"
}) do
	local old = PlayerGui:FindFirstChild(guiName) or CoreGui:FindFirstChild(guiName)
	if not old and gethui then
		pcall(function() old = gethui():FindFirstChild(guiName) end)
	end
	if old then old:Destroy() end
end

local oldBlur = Lighting:FindFirstChild("CHINO_BlurEffect")
if oldBlur then oldBlur:Destroy() end

local GameBlur = Instance.new("BlurEffect")
GameBlur.Name = "CHINO_BlurEffect"
GameBlur.Size = 0
GameBlur.Parent = Lighting

local COLORS = {
	Blue = Color3.fromRGB(45, 155, 255),
	BlueBright = Color3.fromRGB(100, 205, 255),
	BlueDark = Color3.fromRGB(12, 35, 62),
	White = Color3.fromRGB(235, 245, 255),
	Text = Color3.fromRGB(175, 202, 230),
	Muted = Color3.fromRGB(90, 125, 155),
	Glass = Color3.fromRGB(7, 18, 32),
	Glass2 = Color3.fromRGB(10, 25, 43)
}

local ALPHA = {
	Main = 0.74,
	Sidebar = 0.74,
	Content = 0.76,
	Buttons = 0.70,
	Glow = 0.88
}

local DYNAMIC_CYCLE = {
	Color3.fromRGB(145, 110, 175),
	Color3.fromRGB(110, 140, 190),
	Color3.fromRGB(115, 170, 185),
	Color3.fromRGB(175, 120, 155)
}

-- Paleta distinta en cada ejecución: solo orbes/FOV usan esta combinación.
SettingsVisual.ExecutionOrbPalettes = {
	{
		Color3.fromRGB(255, 32, 72), Color3.fromRGB(255, 105, 20),
		Color3.fromRGB(255, 0, 170), Color3.fromRGB(120, 20, 255),
		Color3.fromRGB(255, 190, 35), Color3.fromRGB(155, 0, 80)
	},
	{
		Color3.fromRGB(0, 185, 255), Color3.fromRGB(0, 255, 235),
		Color3.fromRGB(95, 40, 255), Color3.fromRGB(255, 35, 215),
		Color3.fromRGB(25, 70, 255), Color3.fromRGB(0, 255, 155)
	},
	{
		Color3.fromRGB(45, 255, 75), Color3.fromRGB(180, 255, 0),
		Color3.fromRGB(0, 255, 185), Color3.fromRGB(0, 165, 95),
		Color3.fromRGB(235, 255, 35), Color3.fromRGB(0, 220, 255)
	},
	{
		Color3.fromRGB(170, 35, 255), Color3.fromRGB(70, 80, 255),
		Color3.fromRGB(255, 30, 190), Color3.fromRGB(25, 210, 255),
		Color3.fromRGB(95, 0, 210), Color3.fromRGB(255, 100, 225)
	},
	{
		Color3.fromRGB(255, 75, 0), Color3.fromRGB(255, 35, 110),
		Color3.fromRGB(255, 185, 25), Color3.fromRGB(190, 35, 255),
		Color3.fromRGB(255, 0, 55), Color3.fromRGB(95, 45, 255)
	},
	{
		Color3.fromRGB(0, 235, 255), Color3.fromRGB(25, 115, 255),
		Color3.fromRGB(130, 245, 255), Color3.fromRGB(125, 55, 255),
		Color3.fromRGB(0, 120, 210), Color3.fromRGB(65, 255, 205)
	}
}
do
	local paletteRandom = Random.new()
	local chosenPalette = SettingsVisual.ExecutionOrbPalettes[
		paletteRandom:NextInteger(1, #SettingsVisual.ExecutionOrbPalettes)
	]
	SettingsVisual.ExecutionOrbPalette = chosenPalette
	SettingsVisual.ActiveOrbPalette = chosenPalette
end

local TABS = {
	{Name = "Silent Aim"},
	{Name = "Soft Aim"},
	{Name = "ESP"},
	{Name = "Player"},
	{Name = "Vehicle"},
	{Name = "Misc"},
	{Name = "Farm"},
	{Name = "Buy"},
	{Name = "Config"}
}

local Gui = Instance.new("ScreenGui")
Gui.Name = "CHINOINFIERNOHUB"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
Gui.DisplayOrder = 105
Gui.Enabled = true
pcall(function()
	Gui.SafeAreaCompatibility = Enum.SafeAreaCompatibility.None
	Gui.ScreenInsets = Enum.ScreenInsets.None
end)
-- Parent compatible con ejecutores: gethui cuando existe, PlayerGui como fallback.
SettingsVisual.ExecutorGuiParent = PlayerGui
pcall(function()
	if gethui then
		local candidate = gethui()
		if typeof(candidate) == "Instance" then
			SettingsVisual.ExecutorGuiParent = candidate
		end
	end
end)
pcall(function()
	if syn and syn.protect_gui then syn.protect_gui(Gui) end
end)
pcall(function()
	Gui.Parent = SettingsVisual.ExecutorGuiParent
end)
if not Gui.Parent then
	Gui.Parent = PlayerGui
	SettingsVisual.ExecutorGuiParent = PlayerGui
end

local FOVCircle = Instance.new("Frame", Gui)
FOVCircle.Name = "FOVCircle"
FOVCircle.AnchorPoint = Vector2.new(0.5, 0.5)
FOVCircle.Position = UDim2.fromScale(0.5, 0.5)
FOVCircle.Size = UDim2.fromOffset(300, 300)
FOVCircle.BackgroundTransparency = 1
FOVCircle.Visible = false
FOVCircle.ZIndex = 1
Instance.new("UICorner", FOVCircle).CornerRadius = UDim.new(1, 0)
local FOVStroke = Instance.new("UIStroke", FOVCircle)
FOVStroke.Thickness = 0.65
FOVStroke.Transparency = 0.22
FOVStroke.Color = Color3.fromRGB(0, 0, 0)

-- FOV fijo negro.

SettingsVisual.TargetVisibleColor = Color3.fromRGB(0, 255, 0)
SettingsVisual.TargetHiddenColor = Color3.fromRGB(255, 0, 0)
SettingsVisual.TargetLineThickness = 1

local TargetLine = Instance.new("Frame", Gui)
TargetLine.Name = "TargetLine"
TargetLine.AnchorPoint = Vector2.new(0.5, 0.5)
TargetLine.BackgroundColor3 = SettingsVisual.TargetHiddenColor
TargetLine.BackgroundTransparency = 0
TargetLine.BorderSizePixel = 0
TargetLine.Size = UDim2.fromOffset(0, SettingsVisual.TargetLineThickness)
TargetLine.Visible = false
TargetLine.ZIndex = 20
Instance.new("UICorner", TargetLine).CornerRadius = UDim.new(1, 0)

-- Octagono pequeño; solo borde, sin bolita final.
SettingsVisual.TargetOctagon = Instance.new("Frame", Gui)
SettingsVisual.TargetOctagon.Name = "TargetOctagon"
SettingsVisual.TargetOctagon.Size = UDim2.fromOffset(12, 12)
SettingsVisual.TargetOctagon.AnchorPoint = Vector2.new(0.5, 0.5)
SettingsVisual.TargetOctagon.BackgroundTransparency = 1
SettingsVisual.TargetOctagon.Visible = false
SettingsVisual.TargetOctagon.ZIndex = 30

SettingsVisual.TargetOctagonSegments = {}
SettingsVisual.TargetFXTime = 0

SettingsVisual.CreateTargetOctagonSegment = function(size, x, y, rotation, dirX, dirY)
	local segment = Instance.new("Frame", SettingsVisual.TargetOctagon)
	segment.AnchorPoint = Vector2.new(0.5, 0.5)
	segment.BackgroundColor3 = SettingsVisual.TargetHiddenColor
	segment.BorderSizePixel = 0
	segment.Size = size
	segment.Position = UDim2.fromOffset(x, y)
	segment.Rotation = rotation or 0
	segment.ZIndex = 30
	table.insert(SettingsVisual.TargetOctagonSegments, {
		Frame = segment,
		BasePosition = Vector2.new(x, y),
		Dir = Vector2.new(dirX, dirY)
	})
end

SettingsVisual.CreateTargetOctagonSegment(UDim2.fromOffset(5, 1), 6, 1, 0, 0, -1)
SettingsVisual.CreateTargetOctagonSegment(UDim2.fromOffset(5, 1), 6, 11, 0, 0, 1)
SettingsVisual.CreateTargetOctagonSegment(UDim2.fromOffset(1, 5), 1, 6, 0, -1, 0)
SettingsVisual.CreateTargetOctagonSegment(UDim2.fromOffset(1, 5), 11, 6, 0, 1, 0)
SettingsVisual.CreateTargetOctagonSegment(UDim2.fromOffset(3, 1), 2.5, 2.5, 45, -0.707, -0.707)
SettingsVisual.CreateTargetOctagonSegment(UDim2.fromOffset(3, 1), 9.5, 2.5, -45, 0.707, -0.707)
SettingsVisual.CreateTargetOctagonSegment(UDim2.fromOffset(3, 1), 2.5, 9.5, -45, -0.707, 0.707)
SettingsVisual.CreateTargetOctagonSegment(UDim2.fromOffset(3, 1), 9.5, 9.5, 45, 0.707, 0.707)

-- Limpia una flecha vieja si el script se vuelve a ejecutar.
pcall(function()
	local oldArrow = PlayerGui:FindFirstChild("CHINO_TargetArrow3D")
	if oldArrow then oldArrow:Destroy() end
end)

SettingsVisual.TargetArrow = Instance.new("BillboardGui")
SettingsVisual.TargetArrow.Name = "CHINO_TargetArrow3D"
SettingsVisual.TargetArrow.Size = UDim2.fromOffset(38, 38)
SettingsVisual.TargetArrow.StudsOffset = Vector3.new(0, 3.2, 0)
SettingsVisual.TargetArrow.AlwaysOnTop = true
SettingsVisual.TargetArrow.LightInfluence = 0
SettingsVisual.TargetArrow.MaxDistance = SettingsVisual.ESPMaxRenderDistance or 1000000
SettingsVisual.TargetArrow.Enabled = false
SettingsVisual.TargetArrow.Parent = PlayerGui

SettingsVisual.TargetArrowText = Instance.new("TextLabel", SettingsVisual.TargetArrow)
SettingsVisual.TargetArrowText.BackgroundTransparency = 1
SettingsVisual.TargetArrowText.Size = UDim2.fromScale(1, 1)
SettingsVisual.TargetArrowText.Font = Enum.Font.GothamBlack
SettingsVisual.TargetArrowText.Text = "▼"
SettingsVisual.TargetArrowText.TextColor3 = SettingsVisual.TargetHiddenColor
SettingsVisual.TargetArrowText.TextSize = 28
SettingsVisual.TargetArrowText.TextStrokeTransparency = 1

SettingsVisual.HideNewTargetVisuals = function()
	TargetLine.Visible = false
	SettingsVisual.TargetOctagon.Visible = false
	SettingsVisual.TargetArrow.Enabled = false
	SettingsVisual.TargetArrow.Adornee = nil
	SettingsVisual.TargetArrow.StudsOffset = Vector3.new(0, 3.2, 0)
	for _, info in ipairs(SettingsVisual.TargetOctagonSegments) do
		if info.Frame then
			info.Frame.Position = UDim2.fromOffset(info.BasePosition.X, info.BasePosition.Y)
		end
	end
end

SettingsVisual.SetNewTargetColor = function(isVisible)
	local color = isVisible and SettingsVisual.TargetVisibleColor or SettingsVisual.TargetHiddenColor
	TargetLine.BackgroundColor3 = color
	SettingsVisual.TargetArrowText.TextColor3 = color
	for _, info in ipairs(SettingsVisual.TargetOctagonSegments) do
		if info.Frame then info.Frame.BackgroundColor3 = color end
	end
	return color
end

SettingsVisual.AnimateNewTargetFX = function(dt)
	SettingsVisual.TargetFXTime = (SettingsVisual.TargetFXTime or 0) + (dt or 0)
	if SettingsVisual.TargetFXTime > 10000 then SettingsVisual.TargetFXTime = 0 end
	local t = SettingsVisual.TargetFXTime
	local openPulse = (math.sin(t * 8.5) + 1) * 0.5
	local spread = 0.18 + (openPulse * 1.12)
	for _, info in ipairs(SettingsVisual.TargetOctagonSegments) do
		if info.Frame then
			info.Frame.Position = UDim2.fromOffset(
				info.BasePosition.X + (info.Dir.X * spread),
				info.BasePosition.Y + (info.Dir.Y * spread)
			)
		end
	end
	SettingsVisual.TargetArrow.StudsOffset = Vector3.new(0, 3.15 + math.sin(t * 6.5) * 0.26, 0)
end

local VelocityHistory = {}

local function getPing()
	local pGui = Player:FindFirstChild("PlayerGui")
	if pGui and pGui:FindFirstChild("NetworkStats") and pGui.NetworkStats:FindFirstChild("PingLabel") then
		local ms = tonumber(pGui.NetworkStats.PingLabel.Text:match("%d+"))
		if ms then return math.clamp(ms / 1000, 0.04, 1.2) end
	end
	return 0.08
end

local function isCurrentShotgun()
	local char = Player.Character
	if not char then return false end
	for _, item in ipairs(char:GetChildren()) do
		if item:IsA("Tool") then
			local ammo = item:GetAttribute("AmmoType")
			if ammo == "shotgun" or ammo == "shootgun" then
				return true
			end
		end
	end
	return false
end

SettingsVisual.PerfVelocityTimer = 0
RunService.Heartbeat:Connect(function(dt)
	-- Rendimiento: el historial de velocidad solo hace falta cuando algun sistema de aim/bullet lo usa.
	-- Se muestrea a 20 Hz; la fisica real (AssemblyLinearVelocity) sigue disponible entre muestras.
	local needsVelocityHistory = SilentAimEnabled
		or SoftAimMobileEnabled
		or SoftAimPCEnabled
		or SettingsVisual.BulletEnabled

	if needsVelocityHistory then
		SettingsVisual.PerfVelocityTimer = (SettingsVisual.PerfVelocityTimer or 0) + (dt or 0)
		if SettingsVisual.PerfVelocityTimer >= 0.05 then
			SettingsVisual.PerfVelocityTimer = 0
			for _, pl in ipairs(Players:GetPlayers()) do
				if pl ~= Player and pl.Character then
					local root = pl.Character:FindFirstChild("HumanoidRootPart")
					local hum = pl.Character:FindFirstChildOfClass("Humanoid")
					if root and hum and hum.Health > 0 then
						VelocityHistory[pl] = VelocityHistory[pl] or {}
						table.insert(VelocityHistory[pl], {time = os.clock(), pos = root.Position})
						if #VelocityHistory[pl] > 8 then
							table.remove(VelocityHistory[pl], 1)
						end
					else
						VelocityHistory[pl] = nil
					end
				end
			end
		end
	else
		SettingsVisual.PerfVelocityTimer = 0
		if next(VelocityHistory) ~= nil then
			table.clear(VelocityHistory)
		end
	end


	pcall(function()
		local char = Player.Character
		local root = char and char:FindFirstChild("HumanoidRootPart")
		local bb = root and root:FindFirstChild("CharacterBillboardGui")
		if bb and bb:FindFirstChild("PlayerName") then
			bb.PlayerName.Visible = not HideNameEnabled
		end
	end)
end)




local function getCalculatedVelocity(pl, rootPart)
	if rootPart and rootPart.AssemblyLinearVelocity.Magnitude > 22 then
		return rootPart.AssemblyLinearVelocity
	end
	local data = VelocityHistory[pl]
	if not data or #data < 2 then return Vector3.zero end
	local vel = Vector3.zero
	local count = 0
	for i = 2, #data do
		local dt = data[i].time - data[i - 1].time
		if dt > 0 then
			vel = vel + (data[i].pos - data[i - 1].pos) / dt
			count = count + 1
		end
	end
	return count > 0 and (vel / count) or Vector3.zero
end

--========================================================--
-- ANTI AUTO SIT
-- Evita sillas normales, pero respeta asientos de vehículos.
--========================================================--

SettingsVisual.IsVehicleSeat = function(seat)
	if not seat then return false end
	if seat:IsA("VehicleSeat") then return true end

	local vf = workspace:FindFirstChild("Vehicles")
	if vf and seat:IsDescendantOf(vf) then
		return true
	end

	local model = seat:FindFirstAncestorOfClass("Model")
	if model and (
		model:FindFirstChildOfClass("VehicleSeat")
		or model:FindFirstChild("DriverSeat", true)
		or model:FindFirstChild("DriveSeat", true)
		or model:GetAttribute("IsVehicle")
	) then
		return true
	end

	return false
end

SettingsVisual.SetNormalSeatsDisabled = function(state)
	for _, obj in ipairs(workspace:GetDescendants()) do
		if obj:IsA("Seat") and not SettingsVisual.IsVehicleSeat(obj) then
			obj.Disabled = state == true
		end
	end
end

SettingsVisual.SetupAntiAutoSitCharacter = function(char)
	if not char then return end

	local hum =
		char:FindFirstChildOfClass("Humanoid")
		or char:WaitForChild("Humanoid", 5)

	if not hum then return end

	hum.Seated:Connect(function(isSeated, seat)
		if isSeated
			and SettingsVisual.AntiAutoSitEnabled
			and seat
			and not SettingsVisual.IsVehicleSeat(seat) then
			hum.Sit = false
			hum:ChangeState(Enum.HumanoidStateType.GettingUp)
		end
	end)
end

workspace.DescendantAdded:Connect(function(obj)
	if SettingsVisual.AntiAutoSitEnabled
		and obj:IsA("Seat")
		and not SettingsVisual.IsVehicleSeat(obj) then
		obj.Disabled = true
	end
end)

if Player.Character then
	SettingsVisual.SetupAntiAutoSitCharacter(Player.Character)
end

Player.CharacterAdded:Connect(function(char)
	SettingsVisual.SetupAntiAutoSitCharacter(char)
end)

local function isTargetVisibleOrInCar(targetPart, targetLineMode)
	local char = Player.Character
	local targetChar = targetPart and targetPart.Parent
	local head = char and char:FindFirstChild("Head")
	if not head or not targetPart or not targetChar then return false end

	local targetHum = targetChar:FindFirstChildOfClass("Humanoid")
	local inVehicle = targetHum and targetHum.SeatPart ~= nil
	local vehicleRoot = nil

	if inVehicle and targetHum.SeatPart then
		vehicleRoot = targetHum.SeatPart:FindFirstAncestorOfClass("Model")
	else
		local parent = targetChar.Parent
		while parent and parent ~= workspace do
			local pName = parent.Name:lower()
			if pName:find("vehicle") or pName:find("car") or pName:find("auto") or pName:find("moto") then
				inVehicle = true
				vehicleRoot = parent:IsA("Model") and parent or parent:FindFirstAncestorOfClass("Model")
				break
			end
			parent = parent.Parent
		end
	end

	-- Comportamiento original para el aim: estar en vehículo cuenta como visible.
	if not targetLineMode and inVehicle then
		return true
	end

	-- Target Line normal: si Silent Aim está apagado, cualquier objetivo en carro se marca rojo.
	if targetLineMode and inVehicle and not SilentAimEnabled then
		return false
	end

	local origin = head.Position
	local targetPos = targetPart.Position
	local direction = targetPos - origin
	if direction.Magnitude <= 0.001 then return true end

	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Exclude
	params.IgnoreWater = true

	local filterList = {char, targetChar}

	-- Silent Aim ON + objetivo en carro: ignoramos SOLO el vehículo.
	-- Una pared real todavía bloquea la línea y la deja roja.
	if targetLineMode and SilentAimEnabled and inVehicle and vehicleRoot then
		local topVehicle = vehicleRoot
		while topVehicle.Parent and topVehicle.Parent ~= workspace and topVehicle.Parent:IsA("Model") do
			topVehicle = topVehicle.Parent
		end
		table.insert(filterList, topVehicle)
	end

	params.FilterDescendantsInstances = filterList

	local result = workspace:Raycast(origin, direction, params)
	if not result then return true end

	local hitPart = result.Instance
	if hitPart and (hitPart:IsDescendantOf(char) or hitPart.Name:lower():find("laser") or hitPart.Name:lower():find("bullet")) then
		return true
	end

	if hitPart then
		local mat = hitPart.Material
		local name = hitPart.Name:lower()
		if mat == Enum.Material.Glass or name:find("glass") or name:find("window") or name:find("cristal") or name:find("vidrio") then
			table.insert(filterList, hitPart)
			params.FilterDescendantsInstances = filterList
			local secondResult = workspace:Raycast(
				result.Position + direction.Unit * 0.5,
				targetPos - (result.Position + direction.Unit * 0.5),
				params
			)
			return not secondResult
		end
	end

	return false
end

-- Target lock con histéresis:
-- se queda pegado al objetivo actual, pero permite cambiar cuando
-- otro jugador queda claramente más centrado en la cámara.
SettingsVisual.TargetSwitchRatio = 0.60
SettingsVisual.TargetSwitchMinAdvantage = 30
SettingsVisual.TargetLockKeepScale = 1.38

local function GetBestVisualTarget(fovRadius, bypassWallcheck)
	Camera = workspace.CurrentCamera
	if not Camera then
		CurrentLockedTarget = nil
		return nil
	end

	local radius = tonumber(fovRadius) or 150
	local center = Vector2.new(
		Camera.ViewportSize.X / 2,
		Camera.ViewportSize.Y / 2
	)

	local currentValid = false
	local currentDistance = math.huge

	-- El target actual puede quedarse un poco fuera del FOV normal,
	-- para que no se despegue por movimientos pequeños de cámara.
	if CurrentLockedTarget
		and not SettingsVisual.IsSafeFriend(CurrentLockedTarget)
		and CurrentLockedTarget.Character then

		local char = CurrentLockedTarget.Character
		local hum = char:FindFirstChildOfClass("Humanoid")
		local aimPart =
			char:FindFirstChild("Head")
			or char:FindFirstChild("UpperTorso")

		if hum
			and hum.Health > 0
			and aimPart then

			local pos, onScreen =
				Camera:WorldToViewportPoint(aimPart.Position)

			if onScreen and pos.Z > 0 then
				currentDistance =
					(
						Vector2.new(pos.X, pos.Y)
						- center
					).Magnitude

				local keepRadius =
					radius
					* (tonumber(SettingsVisual.TargetLockKeepScale) or 1.15)

				if currentDistance <= keepRadius
					and (
						bypassWallcheck
						or isTargetVisibleOrInCar(aimPart)
					) then

					currentValid = true
				end
			end
		end
	end

	-- Busca el jugador más cerca del centro dentro del FOV normal.
	local bestPlayer = nil
	local bestDistance = radius
    local ownRoot = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")

	for _, pl in ipairs(Players:GetPlayers()) do
		if pl ~= Player and not SettingsVisual.IsSafeFriend(pl) and pl.Character then
			local char = pl.Character
			local hum = char:FindFirstChildOfClass("Humanoid")
			local root = char:FindFirstChild("HumanoidRootPart")
			local aimPart =
				char:FindFirstChild("Head")
				or char:FindFirstChild("UpperTorso")

			if aimPart
				and root
				and hum
				and hum.Health > 0 then

				local pos, onScreen =
					Camera:WorldToViewportPoint(aimPart.Position)

				if onScreen and pos.Z > 0 then
					local distance =
						(
							Vector2.new(pos.X, pos.Y)
							- center
						).Magnitude

					if distance <= radius
						and distance < bestDistance
						and (
							bypassWallcheck
							or isTargetVisibleOrInCar(aimPart)
						) then

						bestDistance = distance
						bestPlayer = pl
					end
				end
			end
		end
	end

	-- Si el target actual sigue válido, NO cambia por una diferencia pequeña.
	-- Solo cambia cuando el nuevo está claramente más centrado.
	if currentValid then
		if not bestPlayer
			or bestPlayer == CurrentLockedTarget then
			return CurrentLockedTarget
		end


	end

	if currentValid
		and bestPlayer
		and bestPlayer ~= CurrentLockedTarget then

		local ratio =
			math.clamp(
				tonumber(SettingsVisual.TargetSwitchRatio) or 0.72,
				0.20,
				0.95
			)

		local minimumAdvantage =
			math.max(
				0,
				tonumber(SettingsVisual.TargetSwitchMinAdvantage) or 18
			)

		local advantage =
			currentDistance - bestDistance

		local clearlyBetter =
			bestDistance <= (currentDistance * ratio)
			and advantage >= minimumAdvantage

		if not clearlyBetter then
			return CurrentLockedTarget
		end
	end

	CurrentLockedTarget = bestPlayer
	return bestPlayer
end

-- Target independiente para el Aimbot fuerte.
-- No modifica CurrentLockedTarget ni CurrentTarget del Silent Aim.
SettingsVisual.GetStrongAimbotTarget = function(fovRadius, bypassWallcheck, excludedPlayer)
	local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
	local bestPlayer = nil
	local bestDistance = tonumber(fovRadius) or 95

	for _, pl in ipairs(Players:GetPlayers()) do
		if pl ~= Player and pl ~= excludedPlayer and not SettingsVisual.IsSafeFriend(pl) and pl.Character then
			local char = pl.Character
			local hum = char:FindFirstChildOfClass("Humanoid")
			local root = char:FindFirstChild("HumanoidRootPart")
			local aimPart = char:FindFirstChild("Head") or char:FindFirstChild("UpperTorso") or root

			if hum and hum.Health > 0 and root and aimPart then
				local pos, onScreen = Camera:WorldToViewportPoint(aimPart.Position)
				if onScreen and pos.Z > 0 then
					local dist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
					if dist <= bestDistance
						and (bypassWallcheck or isTargetVisibleOrInCar(aimPart)) then
						bestDistance = dist
						bestPlayer = pl
					end
				end
			end
		end
	end

	return bestPlayer
end

SettingsVisual.IsStrongAimbotTargetValid = function(pl, fovRadius, bypassWallcheck)
	if not pl or SettingsVisual.IsSafeFriend(pl) or not pl.Character then return false end

	local char = pl.Character
	local hum = char:FindFirstChildOfClass("Humanoid")
	local root = char:FindFirstChild("HumanoidRootPart")
	local aimPart = char:FindFirstChild("Head") or char:FindFirstChild("UpperTorso") or root

	if not hum or hum.Health <= 0 or not root or not aimPart then
		return false
	end

	local pos, onScreen = Camera:WorldToViewportPoint(aimPart.Position)
	if not onScreen or pos.Z <= 0 then
		return false
	end

	local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
	local keepRadius = (tonumber(fovRadius) or 95)
		* (tonumber(SettingsVisual.StrongAimbotKeepRadiusScale) or 1.35)

	if (Vector2.new(pos.X, pos.Y) - center).Magnitude > keepRadius then
		return false
	end

	return bypassWallcheck or isTargetVisibleOrInCar(aimPart)
end

--========================================================--
-- TARGET LINE NUEVA
-- El selector visual viejo fue retirado. Cuando Silent Aim está ON,
-- Target Line comparte CurrentLockedTarget. Cuando está OFF usa el selector
-- visual directo definido más abajo.
--========================================================--

local function getBypassedTargetPart(character, partName)
	if not character then return nil, Vector3.zero end
	local head = character:FindFirstChild("Head")
	local upperTorso = character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso")

	if partName == "Head" then
		-- Head: punto de cabeza, igual que antes.
		if head then return head, Vector3.new(0, 0.15, 0) end
		return upperTorso, Vector3.zero
	elseif partName == "Neck" then
		-- Neck: usa EXACTAMENTE el punto que antes daba el resultado correcto de cuello en Chest.
		-- Se conserva ese punto porque ya fue validado visualmente en este juego.
		if upperTorso then
			local neckY = upperTorso.Size.Y * 0.08
			return upperTorso, Vector3.new(0, neckY, 0)
		end
		if head then
			return head, Vector3.new(0, -(head.Size.Y * 1.15), 0)
		end
		return nil, Vector3.zero
	elseif partName == "Chest" then
		-- Chest: más abajo que el punto de Neck para caer en el centro/bajo del pecho.
		if upperTorso then
			local chestY = -(upperTorso.Size.Y * 0.30)
			return upperTorso, Vector3.new(0, chestY, 0)
		end
		if head then
			return head, Vector3.new(0, -(head.Size.Y * 1.65), 0)
		end
		return nil, Vector3.zero
	else
		return head or upperTorso, Vector3.zero
	end
end

-- Predictor anterior conservado SOLO como fallback para Soft Aim/Bullet.
-- El Silent Aim nuevo NO usa esta ruta de ping.
--========================================================--
-- ESP / TARGET VISUAL NUEVO
-- Visible = verde / detrás de pared = rojo.
-- Se mantiene separado del render pesado del HUB para que sea fluido.
--========================================================--

SettingsVisual.IsDirectVisualTargetVisible = function(targetCharacter, targetPart)
	Camera = workspace.CurrentCamera
	if not Camera or not targetCharacter or not targetPart then return false end

	local origin = Camera.CFrame.Position
	local direction = targetPart.Position - origin
	if direction.Magnitude <= 0.001 then return true end

	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Exclude
	params.IgnoreWater = true
	params.FilterDescendantsInstances = {Player.Character}

	local result = workspace:Raycast(origin, direction, params)
	if not result then return true end
	return result.Instance and result.Instance:IsDescendantOf(targetCharacter) or false
end

--========================================================--
-- CHINOINFIERNO • TARGET STICKY V3
-- Un solo selector para Target Line + Silent Aim:
--   * no cambia de enemigo por pequenos movimientos de camara
--   * cambio deliberado: giro considerable + nuevo blanco bien centrado
--   * ventaja moderada para armas visibles (Epic/Legendary/Omega)
--   * enemigos cercanos frente a la camara antes que lejanos
--   * objetivos lejanos detrás de paredes: se permiten, Target Line rojo
-- No altera el FOV de dibujo ni el punto Head/Neck/Chest del disparo.
--========================================================--
SettingsVisual.TargetSticky = SettingsVisual.TargetSticky or {
    Locked=nil, LockForward=nil, CacheAt=0, CacheValue=nil,
    WeaponCache=setmetatable({}, {__mode="k"}),
}
SettingsVisual.StickyTurnDegrees = 16.0 -- más giro de cámara para cambiar de enemigo
SettingsVisual.StickySwitchMinPixels = 100 -- el blanco actual debe salir más del centro
SettingsVisual.StickySwitchRatio = 0.50 -- nuevo objetivo claramente mejor centrado
SettingsVisual.StickyKeepFOVMultiplier = 3.20 -- conserva el blanco mientras siga en pantalla
SettingsVisual.StickyScanInterval = 0.055
SettingsVisual.StickySwitchScoreAdvantage = 30 -- evita saltos por prioridad de armas

-- Un arma en la mano pesa mas que una guardada en el Backpack (si este
-- es visible para el cliente). Las rarezas se obtienen de atributos/DB.
SettingsVisual.GetTargetWeaponPriority = function(pl)
    local state=SettingsVisual.TargetSticky
    local cached=state.WeaponCache[pl]
    local now=os.clock()
    if cached and now-cached.At < 0.45 then return cached.Bonus end

    local bonus=0
    local char=pl and pl.Character
    local gunItems=ItemsFolder and ItemsFolder:FindFirstChild("gun")

    local function checkTool(tool, equipped)
        if not tool:IsA("Tool") or tool.Name=="Fists" then return end
        local template=gunItems and gunItems:FindFirstChild(tool.Name, true)
        local itemType=tostring(tool:GetAttribute("ItemType") or tool:GetAttribute("Type") or ""):lower()
        local name=tool.Name:lower()
        local weapon=(template~=nil)
            or itemType=="gun" or itemType=="weapon" or itemType=="firearm"
            or tool:GetAttribute("AmmoType")~=nil
            or tool:GetAttribute("current_ammo")~=nil
            or name:match("gun") or name:match("rifle") or name:match("pistol")
            or name:match("shotgun") or name:match("revolver")
            or name:match("smg") or name:match("sniper") or name:match("rpg")
        if not weapon then return end
        local db=getWeaponData(tool)
        local rarity=tostring(tool:GetAttribute("RarityName")
            or tool:GetAttribute("Rarity") or (db and db.Rarity)
            or (template and template:GetAttribute("RarityName")) or ""):lower()
        local rarityBonus=15
        if rarity:find("omega", 1, true) then rarityBonus=37
        elseif rarity:find("legendary", 1, true) or rarity:find("legendaria", 1, true) then rarityBonus=34
        elseif rarity:find("epic", 1, true) or rarity:find("epica", 1, true) or rarity:find("épica", 1, true) then rarityBonus=28
        end
        if equipped then rarityBonus += 5 end
        bonus=math.max(bonus,rarityBonus)
    end

    if char then
        for _,tool in ipairs(char:GetChildren()) do checkTool(tool,true) end
    end
    local backpack=pl and pl:FindFirstChild("Backpack")
    if backpack then
        for _,tool in ipairs(backpack:GetChildren()) do checkTool(tool,false) end
    end
    state.WeaponCache[pl]={At=now,Bonus=bonus}
    return bonus
end

SettingsVisual.GetChinoStickyTarget = function(fovRadius)
    Camera=workspace.CurrentCamera
    local state=SettingsVisual.TargetSticky
    if not Camera then
        state.Locked=nil; state.CacheValue=nil
        return nil
    end

    local now=os.clock()
    if now-(state.CacheAt or 0) < (SettingsVisual.StickyScanInterval or 0.055) then
        return state.CacheValue
    end
    state.CacheAt=now

    local radius=math.max(35,tonumber(fovRadius) or tonumber(SettingsVisual.FOVRadius) or 120)
    local center=Camera.ViewportSize/2
    local center2=Vector2.new(center.X,center.Y)
    local ownChar=Player.Character
    local ownRoot=ownChar and ownChar:FindFirstChild("HumanoidRootPart")
    local origin=ownRoot and ownRoot.Position or Camera.CFrame.Position
    local forward=Camera.CFrame.LookVector

    local function evaluate(pl)
        if not pl or pl==Player or SettingsVisual.IsSafeFriend(pl) or not pl.Character then return nil end
        local char=pl.Character
        local hum=char:FindFirstChildOfClass("Humanoid")
        local root=char:FindFirstChild("HumanoidRootPart")
        local head=char:FindFirstChild("Head") or char:FindFirstChild("UpperTorso") or root
        if not hum or hum.Health<=0 or not root or not head then return nil end
        local projected,onScreen=Camera:WorldToViewportPoint(head.Position)
        if not onScreen or projected.Z<=0 then return nil end

        local screenDistance=(Vector2.new(projected.X,projected.Y)-center2).Magnitude
        local worldDistance=(root.Position-origin).Magnitude
        -- No filtrar por muro ni por distancia: el objetivo puede estar lejos
        -- y detrás de barreras. El color visual seguirá indicando oclusión.
        local visible=SettingsVisual.IsDirectVisualTargetVisible(char,head)

        local armedBonus=SettingsVisual.GetTargetWeaponPriority(pl)
        -- Distancia real pesa lo suficiente para no cambiar a un objetivo
        -- lejano que quede justo detras del que tenemos enfrente.
        local score=screenDistance + math.min(worldDistance,300)*0.26
        if worldDistance>120 then score+=(worldDistance-120)*0.16 end
        if visible then score-=8 end
        score-=armedBonus
        return {Player=pl,Screen=screenDistance,Score=score,Distance=worldDistance}
    end

    local locked=state.Locked
    local lockedInfo=evaluate(locked)
    local keepRadius=radius*(SettingsVisual.StickyKeepFOVMultiplier or 3.20)
    if lockedInfo and lockedInfo.Screen>keepRadius then lockedInfo=nil end

    local bestInfo=nil
    for _,pl in ipairs(Players:GetPlayers()) do
        if pl~=Player then
            local info=evaluate(pl)
            if info and info.Screen<=radius
                and (not bestInfo or info.Score<bestInfo.Score) then
                bestInfo=info
            end
        end
    end

    local chosen=lockedInfo and locked or nil
    if not lockedInfo then
        chosen=bestInfo and bestInfo.Player or nil
    elseif bestInfo and bestInfo.Player~=locked then
        -- Primero mirar deliberadamente hacia un costado; pequenas
        -- sacudidas de la camara ya NO deben soltar el objetivo.
        local initial=state.LockForward or forward
        local angle=math.deg(math.acos(math.clamp(initial:Dot(forward),-1,1)))
        local changedEnough=angle >= (SettingsVisual.StickyTurnDegrees or 16)
            and lockedInfo.Screen >= (SettingsVisual.StickySwitchMinPixels or 100)
        local clearlyBetter=bestInfo.Screen <= lockedInfo.Screen*(SettingsVisual.StickySwitchRatio or 0.50)
            and bestInfo.Score <= lockedInfo.Score-(SettingsVisual.StickySwitchScoreAdvantage or 30)
        if changedEnough and clearlyBetter then
            chosen=bestInfo.Player
        end
    end

    if chosen~=state.Locked then
        state.LockForward=chosen and forward or nil
        state.Locked=chosen
    end
    state.CacheValue=chosen
    SettingsVisual.DirectVisualLockedTarget=chosen
    return chosen
end

-- Ambos accesos comparten el MISMO target fijado.
SettingsVisual.GetDirectVisualTarget=function(fovRadius)
    return SettingsVisual.GetChinoStickyTarget(fovRadius)
end

SettingsVisual.ModernESPObjects = SettingsVisual.ModernESPObjects or {}

SettingsVisual.EnsureModernESP = function(pl)
	if not pl or pl == Player then return nil end
	local existing = SettingsVisual.ModernESPObjects[pl]
	if existing and existing.Root and existing.Root.Parent then return existing end
	if existing and existing.Root then pcall(function() existing.Root:Destroy() end) end

	local rootGui = Instance.new("Frame", Gui)
	rootGui.Name = "ModernESP_" .. pl.Name
	rootGui.Size = UDim2.fromScale(1, 1)
	rootGui.Position = UDim2.fromOffset(0, 0)
	rootGui.BackgroundTransparency = 1
	rootGui.BorderSizePixel = 0
	rootGui.ClipsDescendants = false
	rootGui.Active = false
	rootGui.ZIndex = 25

	local box = Instance.new("Frame", rootGui)
	box.Name = "BoxESP"
	box.BackgroundTransparency = 1
	box.BorderSizePixel = 0
	box.Visible = false
	box.ZIndex = 25
	local boxStroke = Instance.new("UIStroke", box)
	boxStroke.Thickness = 1
	boxStroke.Transparency = 0
	boxStroke.Color = SettingsVisual.TargetHiddenColor
	boxStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

	local tracer = Instance.new("Frame", rootGui)
	tracer.Name = "ESPLine"
	tracer.AnchorPoint = Vector2.new(0.5, 0.5)
	tracer.BackgroundColor3 = SettingsVisual.TargetHiddenColor
	tracer.BorderSizePixel = 0
	tracer.Visible = false
	tracer.ZIndex = 24
	Instance.new("UICorner", tracer).CornerRadius = UDim.new(1, 0)

	local healthOutline = Instance.new("Frame", rootGui)
	healthOutline.Name = "HealthOutline"
	healthOutline.BackgroundColor3 = Color3.fromRGB(15, 17, 22)
	healthOutline.BackgroundTransparency = 0.10
	healthOutline.BorderSizePixel = 0
	healthOutline.Visible = false
	healthOutline.ZIndex = 26
	Instance.new("UICorner", healthOutline).CornerRadius = UDim.new(0, 2)

	local healthBar = Instance.new("Frame", rootGui)
	healthBar.Name = "HealthBar"
	healthBar.BorderSizePixel = 0
	healthBar.Visible = false
	healthBar.ZIndex = 27
	Instance.new("UICorner", healthBar).CornerRadius = UDim.new(0, 2)

	local healthText = Instance.new("TextLabel", rootGui)
	healthText.Name = "HealthText"
	healthText.BackgroundTransparency = 1
	healthText.AnchorPoint = Vector2.new(0.5, 0.5)
	healthText.Size = UDim2.fromOffset(70, 16)
	healthText.Font = Enum.Font.GothamBold
	healthText.TextSize = 10
	healthText.TextColor3 = Color3.new(1, 1, 1)
	healthText.TextStrokeTransparency = 0.35
	healthText.Visible = false
	healthText.ZIndex = 28

	local data = {
		Root = rootGui,
		Box = box,
		BoxStroke = boxStroke,
		Tracer = tracer,
		HealthOutline = healthOutline,
		HealthBar = healthBar,
		HealthText = healthText
	}
	SettingsVisual.ModernESPObjects[pl] = data
	return data
end

SettingsVisual.HideModernESP = function(data)
	if not data then return end
	if data.Box then data.Box.Visible = false end
	if data.Tracer then data.Tracer.Visible = false end
	if data.HealthOutline then data.HealthOutline.Visible = false end
	if data.HealthBar then data.HealthBar.Visible = false end
	if data.HealthText then data.HealthText.Visible = false end
end

SettingsVisual.RemoveModernESP = function(pl)
	local data = SettingsVisual.ModernESPObjects[pl]
	if data and data.Root then pcall(function() data.Root:Destroy() end) end
	SettingsVisual.ModernESPObjects[pl] = nil
end

-- Calcula el rectángulo REAL del personaje proyectando su bounding box 3D.
-- Esto evita que el ESP quede debajo cuando el jugador está lejos.
-- No altera ninguno de los offsets calibrados por CHINO.
SettingsVisual.GetProjectedCharacterBounds = function(char)
	Camera = workspace.CurrentCamera
	if not Camera or not char then return nil end

	local root =
		char:FindFirstChild("HumanoidRootPart")
		or char:FindFirstChild("UpperTorso")
		or char:FindFirstChild("Torso")

	local function projectBox(boxCF, boxSize)
		local hx = boxSize.X * 0.5
		local hy = boxSize.Y * 0.5
		local hz = boxSize.Z * 0.5

		local minX, minY = math.huge, math.huge
		local maxX, maxY = -math.huge, -math.huge
		local visiblePoints = 0

		for _, sx in ipairs({-1, 1}) do
			for _, sy in ipairs({-1, 1}) do
				for _, sz in ipairs({-1, 1}) do
					local worldPoint =
						boxCF:PointToWorldSpace(
							Vector3.new(hx * sx, hy * sy, hz * sz)
						)

					local screenPoint =
						Camera:WorldToViewportPoint(worldPoint)

					if screenPoint.Z > 0 then
						visiblePoints += 1
						minX = math.min(minX, screenPoint.X)
						maxX = math.max(maxX, screenPoint.X)
						minY = math.min(minY, screenPoint.Y)
						maxY = math.max(maxY, screenPoint.Y)
					end
				end
			end
		end

		if visiblePoints == 0
			or minX == math.huge
			or minY == math.huge then
			return nil
		end

		return {
			Left = minX,
			Right = maxX,
			Top = minY,
			Bottom = maxY,
			Width = math.max(8, maxX - minX),
			Height = math.max(12, maxY - minY),
			Center = Vector2.new(
				(minX + maxX) * 0.5,
				(minY + maxY) * 0.5
			)
		}
	end

	-- Primero intenta el mismo bounding box que ya estaba funcionando bien.
	local ok, boxCF, boxSize = pcall(function()
		local cf, size = char:GetBoundingBox()
		return cf, size
	end)

	if ok and boxCF and boxSize then
		local centerOffset =
			root and (boxCF.Position - root.Position).Magnitude or 0

		local anomalous =
			boxSize.X > 12
			or boxSize.Y > 14
			or boxSize.Z > 12
			or centerOffset > 7

		-- Jugador normal: NO cambia nada respecto a la versión anterior.
		if not anomalous then
			return projectBox(boxCF, boxSize)
		end
	end

	-- Fallback sanitizado para autofarm/exploits con piezas gigantes,
	-- carros/objetos weldados o partes falsas dentro del Character.
	local validBodyParts = {
		Head = true,
		HumanoidRootPart = true,

		Torso = true,
		UpperTorso = true,
		LowerTorso = true,

		["Left Arm"] = true,
		["Right Arm"] = true,
		["Left Leg"] = true,
		["Right Leg"] = true,

		LeftUpperArm = true,
		LeftLowerArm = true,
		LeftHand = true,

		RightUpperArm = true,
		RightLowerArm = true,
		RightHand = true,

		LeftUpperLeg = true,
		LeftLowerLeg = true,
		LeftFoot = true,

		RightUpperLeg = true,
		RightLowerLeg = true,
		RightFoot = true,
	}

	local minX, minY = math.huge, math.huge
	local maxX, maxY = -math.huge, -math.huge
	local visiblePoints = 0

	for _, part in ipairs(char:GetChildren()) do
		if part:IsA("BasePart")
			and validBodyParts[part.Name]
			and (
				not root
				or (part.Position - root.Position).Magnitude <= 8
			) then

			-- Limita tamaños absurdos aunque el exploit haya redimensionado
			-- una parte real del avatar.
			local safeSize =
				Vector3.new(
					math.min(part.Size.X, 4.5),
					math.min(part.Size.Y, 4.5),
					math.min(part.Size.Z, 4.5)
				)

			local hx = safeSize.X * 0.5
			local hy = safeSize.Y * 0.5
			local hz = safeSize.Z * 0.5

			for _, sx in ipairs({-1, 1}) do
				for _, sy in ipairs({-1, 1}) do
					for _, sz in ipairs({-1, 1}) do
						local worldPoint =
							part.CFrame:PointToWorldSpace(
								Vector3.new(hx * sx, hy * sy, hz * sz)
							)

						local screenPoint =
							Camera:WorldToViewportPoint(worldPoint)

						if screenPoint.Z > 0 then
							visiblePoints += 1
							minX = math.min(minX, screenPoint.X)
							maxX = math.max(maxX, screenPoint.X)
							minY = math.min(minY, screenPoint.Y)
							maxY = math.max(maxY, screenPoint.Y)
						end
					end
				end
			end
		end
	end

	if visiblePoints > 0
		and minX ~= math.huge
		and minY ~= math.huge then

		return {
			Left = minX,
			Right = maxX,
			Top = minY,
			Bottom = maxY,
			Width = math.max(8, maxX - minX),
			Height = math.max(12, maxY - minY),
			Center = Vector2.new(
				(minX + maxX) * 0.5,
				(minY + maxY) * 0.5
			)
		}
	end

	-- Último fallback estable si el Character viene muy roto.
	if root then
		return projectBox(
			root.CFrame,
			Vector3.new(4, 6.5, 3)
		)
	end

	return nil
end

for _, pl in ipairs(Players:GetPlayers()) do
	if pl ~= Player then SettingsVisual.EnsureModernESP(pl) end
end
Players.PlayerAdded:Connect(function(pl)
	if pl ~= Player then SettingsVisual.EnsureModernESP(pl) end
end)
Players.PlayerRemoving:Connect(function(pl)
	SettingsVisual.RemoveModernESP(pl)
end)

local function predictTargetPos(targetPart, rootPart)
	if not targetPart then return Vector3.zero end
	local char = targetPart.Parent
	local pl = char and Players:GetPlayerFromCharacter(char)
	if not pl then return targetPart.Position end
	local vel = getCalculatedVelocity(pl, rootPart)
	local ping = getPing()
	return targetPart.Position + (vel * (ping + 0.15) * 1.5)
end

--========================================================--

--========================================================--
-- SILENT AIM LASER VISUAL
-- SOLO VISUAL. NO MODIFICA EL SILENT AIM.
--========================================================--

--========================================================--
-- GAMA / PERFORMANCE MODE
-- Alta = visuales actuales completos.
-- Baja = solo reduce carga visual; NO toca funciones del HUB.
--========================================================--
SettingsVisual.PerformanceMode = SettingsVisual.PerformanceMode or "High"

SettingsVisual.IsLowPerformance = function()
	return SettingsVisual.PerformanceMode == "Low"
end

SettingsVisual.LowGraphicsSaved = SettingsVisual.LowGraphicsSaved or nil
SettingsVisual.LowGraphicsEffects = SettingsVisual.LowGraphicsEffects or setmetatable({}, {__mode = "k"})
SettingsVisual.LowGraphicsSkies = SettingsVisual.LowGraphicsSkies or {}

-- ============================================================
-- CHINO SKY: cielo con el icono morado YA usado por el logo del HUB.
-- Un solo Sky local (solo lo ve el jugador que ejecuta el HUB).
-- Los originales quedan guardados para poder apagar el efecto.
-- ============================================================
SettingsVisual.PurpleSky = {
    Enabled = true,
    Texture = "rbxassetid://105275560374583",
    OriginalSkies = {},
}
SettingsVisual.ApplyPurpleSky = function(enabled)
    local sk = SettingsVisual.PurpleSky
    sk.Enabled = enabled == true
    if sk.Enabled then
        for _, original in ipairs(Lighting:GetChildren()) do
            if original:IsA("Sky") and original.Name ~= "CHINO_PurpleSky" then
                if original.Name == "CHINO_LowBlackSky" then
                    original:Destroy()  -- La opt. Gama Baja puede recrearlo.
                else
                    if not table.find(sk.OriginalSkies, original) then
                        table.insert(sk.OriginalSkies, original)
                    end
                    original.Parent = nil
                end
            end
        end
        local customSky = Lighting:FindFirstChild("CHINO_PurpleSky")
        if not customSky then
            customSky = Instance.new("Sky")
            customSky.Name = "CHINO_PurpleSky"
        end
        -- Se repite en las seis caras, llenando el horizonte completo.
        customSky.SkyboxBk = sk.Texture
        customSky.SkyboxDn = sk.Texture
        customSky.SkyboxFt = sk.Texture
        customSky.SkyboxLf = sk.Texture
        customSky.SkyboxRt = sk.Texture
        customSky.SkyboxUp = sk.Texture
        customSky.CelestialBodiesShown = false
        customSky.StarCount = 0
        customSky.SunAngularSize = 0
        customSky.MoonAngularSize = 0
        customSky.Parent = Lighting
    else
        local customSky = Lighting:FindFirstChild("CHINO_PurpleSky")
        if customSky then customSky:Destroy() end
        if SettingsVisual.PerformanceMode == "Low" then
            -- Al apagar en Baja conserva el cielo negro de optimización.
            local blackSky = Lighting:FindFirstChild("CHINO_LowBlackSky")
            if not blackSky then
                blackSky = Instance.new("Sky")
                blackSky.Name = "CHINO_LowBlackSky"
                blackSky.CelestialBodiesShown = false
                blackSky.StarCount = 0
                blackSky.Parent = Lighting
            end
        else
            -- Vuelve al cielo que tenía el juego originalmente.
            for _, original in ipairs(sk.OriginalSkies) do
                if original and not original.Parent then
                    pcall(function() original.Parent = Lighting end)
                end
            end
            -- Otros cielos preservados por el selector Gama Baja.
            for _, original in ipairs(SettingsVisual.LowGraphicsSkies or {}) do
                if original and not original.Parent and original.Name ~= "CHINO_PurpleSky" then
                    pcall(function() original.Parent = Lighting end)
                end
            end
        end
    end
end

--============================================================--
-- CHINO CIELO MORADO: RESTAURACION DISCRETA EN MUERTE/RESPAWN.
-- Se conserva EXACTAMENTE el ApplyPurpleSky ORIGINAL (misma foto, seis caras).
-- No toca el cielo cuando ya esta correcto. Sin loops ni listeners de Lighting.
--============================================================--
do
    local skyConfig = SettingsVisual.PurpleSky
    local skyFaces = {"SkyboxBk", "SkyboxDn", "SkyboxFt", "SkyboxLf", "SkyboxRt", "SkyboxUp"}

    local function skyWasRemovedOrChanged()
        if not skyConfig.Enabled then return false end
        local customSky = Lighting:FindFirstChild("CHINO_PurpleSky")
        if not customSky or not customSky:IsA("Sky") then return true end
        for _, face in ipairs(skyFaces) do
            if customSky[face] ~= skyConfig.Texture then return true end
        end
        -- En algunos respawns, el juego repone su cielo predeterminado.
        for _, child in ipairs(Lighting:GetChildren()) do
            if child:IsA("Sky") and child ~= customSky then return true end
        end
        return false
    end

    local function restoreOnlyIfNeeded()
        if skyConfig.Enabled and skyWasRemovedOrChanged() then
            pcall(function() SettingsVisual.ApplyPurpleSky(true) end)
        end
    end

    local function bindCharacter(character)
        task.defer(restoreOnlyIfNeeded)
        task.delay(1.0, restoreOnlyIfNeeded)
        task.delay(3.0, restoreOnlyIfNeeded)
        task.delay(6.0, restoreOnlyIfNeeded)
        local humanoid = character:FindFirstChildOfClass("Humanoid")
            or character:WaitForChild("Humanoid", 8)
        if humanoid then
            humanoid.Died:Connect(function()
                -- Revisar en la muerte sin forzar reiniciar el Sky que sigue bien.
                task.defer(restoreOnlyIfNeeded)
                task.delay(0.8, restoreOnlyIfNeeded)
            end)
        end
    end

    Player.CharacterAdded:Connect(bindCharacter)
    if Player.Character then task.defer(bindCharacter, Player.Character) end
end

SettingsVisual.RefreshFarESP = function()
	-- Los ESP siguen con distancia enorme aun en Gama Baja.
	SettingsVisual.ESPMaxRenderDistance = 1000000

	for _, obj in ipairs(game:GetDescendants()) do
		if obj:IsA("BillboardGui") then
			local n = obj.Name
			if n:find("ESP")
				or n:find("Modern")
				or n:find("Weapon")
				or n:find("Item") then

				pcall(function()
					obj.MaxDistance = 1000000
					obj.AlwaysOnTop = true
				end)
			end
		end
	end
end

SettingsVisual.ApplyPerformanceMode = function(mode)
	mode = (mode == "Low") and "Low" or "High"
	SettingsVisual.PerformanceMode = mode
    if mode == "Low" then SettingsVisual.HighFluidityScanFactor = 1 end

	local low = (mode == "Low")

	-- =====================================================
	-- VISUALES DEL HUB
	-- =====================================================

	-- El rayo de disparo permanece visible incluso en Gama Baja.
	-- Su trazado es independiente de sombras/texturas de optimizacion.
	SettingsVisual.SilentLaserEnabled = true

	-- Gama Baja: TODOS los orbes desaparecen.
	for _, holder in ipairs(SettingsVisual.ThemeOrbHolders or {}) do
		if holder and holder.Parent then
			holder.Visible = not low
		end
	end

	-- Niebla/frost decorativos del panel.
	if SettingsVisual.ThemeFog1 then
		SettingsVisual.ThemeFog1.Visible = not low
	end

	if SettingsVisual.ThemeFog2 then
		SettingsVisual.ThemeFog2.Visible = not low
	end

	-- GAMA BAJA: efecto cristal; el mundo 3D sigue viendose detras.
	-- Solo se cambian transparencias del fondo, no los controles del HUB.
	if SettingsVisual.ThemeBackplate and SettingsVisual.ThemeBackplate.Parent then
		SettingsVisual.ThemeBackplate.BackgroundTransparency = low and 1 or 0
	end
	if SettingsVisual.ThemeAmbient and SettingsVisual.ThemeAmbient.Parent then
		SettingsVisual.ThemeAmbient.BackgroundTransparency = low and 1 or 0.35
	end
	if SettingsVisual.ThemeFrost and SettingsVisual.ThemeFrost.Parent then
		SettingsVisual.ThemeFrost.BackgroundTransparency = low and 1 or 0.58
	end

	-- =====================================================
	-- GRÁFICOS DEL CLIENTE
	-- =====================================================

	if low then
		if not SettingsVisual.LowGraphicsSaved then
			local saved = {}

			pcall(function()
				saved.QualityLevel =
					settings().Rendering.QualityLevel
			end)

			saved.GlobalShadows = Lighting.GlobalShadows
			saved.Brightness = Lighting.Brightness
			saved.ClockTime = Lighting.ClockTime
			saved.EnvironmentDiffuseScale = Lighting.EnvironmentDiffuseScale
			saved.EnvironmentSpecularScale = Lighting.EnvironmentSpecularScale
			saved.ShadowSoftness = Lighting.ShadowSoftness
			saved.Ambient = Lighting.Ambient
			saved.OutdoorAmbient = Lighting.OutdoorAmbient
			saved.ExposureCompensation = Lighting.ExposureCompensation

			SettingsVisual.LowGraphicsSaved = saved
		end

		-- Calidad de render mínima.
		pcall(function()
			settings().Rendering.QualityLevel =
				Enum.QualityLevel.Level01
		end)

		pcall(function()
			Lighting.GlobalShadows = false
			Lighting.EnvironmentDiffuseScale = 0
			Lighting.EnvironmentSpecularScale = 0
			Lighting.ShadowSoftness = 0
			-- Iluminacion sencilla pero diurna, sin convertir el mapa en negro.
			Lighting.Brightness = 1.8
			Lighting.ClockTime = 12
			Lighting.Ambient = Color3.fromRGB(120, 125, 145)
			Lighting.OutdoorAmbient = Color3.fromRGB(135, 140, 155)
			Lighting.ExposureCompensation = 0
		end)

		-- Mantener Bloom para el brillo del laser. Desactivar efectos pesados restantes.
		for _, obj in ipairs(Lighting:GetChildren()) do
			if obj:IsA("SunRaysEffect")
				or obj:IsA("DepthOfFieldEffect")
				or obj:IsA("ColorCorrectionEffect") then

				if SettingsVisual.LowGraphicsEffects[obj] == nil then
					SettingsVisual.LowGraphicsEffects[obj] =
						obj.Enabled
				end

				pcall(function()
					obj.Enabled = false
				end)
			end
		end

		-- Guardar y retirar skies actuales.
		for _, obj in ipairs(Lighting:GetChildren()) do
			if obj:IsA("Sky")
				and obj.Name ~= "CHINO_LowBlackSky"
                and obj.Name ~= "CHINO_PurpleSky" then

				if not table.find(SettingsVisual.LowGraphicsSkies, obj) then
					table.insert(SettingsVisual.LowGraphicsSkies, obj)
				end

				pcall(function()
					obj.Parent = nil
				end)
			end
		end

		-- Sky negro/simple de muy bajo costo.
		local blackSky =
			Lighting:FindFirstChild("CHINO_LowBlackSky")

		if not blackSky then
			blackSky = Instance.new("Sky")
			blackSky.Name = "CHINO_LowBlackSky"
			blackSky.SkyboxBk = ""
			blackSky.SkyboxDn = ""
			blackSky.SkyboxFt = ""
			blackSky.SkyboxLf = ""
			blackSky.SkyboxRt = ""
			blackSky.SkyboxUp = ""
			blackSky.CelestialBodiesShown = false
			blackSky.StarCount = 0
			blackSky.SunAngularSize = 0
			blackSky.MoonAngularSize = 0
			blackSky.Parent = Lighting
		end

		-- Clouds fuera en Baja.
		local clouds =
			workspace.Terrain
			and workspace.Terrain:FindFirstChildOfClass("Clouds")

		if clouds then
			if clouds:GetAttribute("CHINO_OLD_COVER") == nil then
				clouds:SetAttribute("CHINO_OLD_COVER", clouds.Cover)
				clouds:SetAttribute("CHINO_OLD_DENSITY", clouds.Density)
			end

			pcall(function()
				clouds.Cover = 0
				clouds.Density = 0
			end)
		end

		-- Blur suave del mundo, solo cuando el panel esta abierto.
		-- Al minimizar se elimina para jugar con vision nitida.
		if GameBlur then
			pcall(function()
				GameBlur.Size = SettingsVisual.PanelIsOpen and 10 or 0
			end)
		end

		-- Mantener el ESP lejano.
		if SettingsVisual.RefreshFarESP then
			task.defer(SettingsVisual.RefreshFarESP)
		end

	else
		-- =================================================
		-- GAMA ALTA: RESTAURAR TODO COMO ESTABA
		-- =================================================

		local saved =
			SettingsVisual.LowGraphicsSaved

		if saved then
			pcall(function()
				if saved.QualityLevel ~= nil then
					settings().Rendering.QualityLevel =
						saved.QualityLevel
				end
			end)

			pcall(function()
				Lighting.GlobalShadows = saved.GlobalShadows
				Lighting.Brightness = saved.Brightness
				Lighting.ClockTime = saved.ClockTime
				Lighting.EnvironmentDiffuseScale =
					saved.EnvironmentDiffuseScale
				Lighting.EnvironmentSpecularScale =
					saved.EnvironmentSpecularScale
				Lighting.ShadowSoftness = saved.ShadowSoftness
				Lighting.Ambient = saved.Ambient
				Lighting.OutdoorAmbient = saved.OutdoorAmbient
				Lighting.ExposureCompensation =
					saved.ExposureCompensation
			end)
		end

		for effect, enabled in pairs(SettingsVisual.LowGraphicsEffects) do
			if effect and effect.Parent then
				pcall(function()
					effect.Enabled = enabled
				end)
			end
		end

		local blackSky =
			Lighting:FindFirstChild("CHINO_LowBlackSky")

		if blackSky then
			blackSky:Destroy()
		end

		for _, sky in ipairs(SettingsVisual.LowGraphicsSkies) do
			if sky and not sky.Parent then
				pcall(function()
					sky.Parent = Lighting
				end)
			end
		end

		local clouds =
			workspace.Terrain
			and workspace.Terrain:FindFirstChildOfClass("Clouds")

		if clouds then
			local oldCover =
				clouds:GetAttribute("CHINO_OLD_COVER")

			local oldDensity =
				clouds:GetAttribute("CHINO_OLD_DENSITY")

			if oldCover ~= nil then
				pcall(function()
					clouds.Cover = oldCover
				end)
			end

			if oldDensity ~= nil then
				pcall(function()
					clouds.Density = oldDensity
				end)
			end
		end
	end
    -- Si la persona eligió cielo morado, prevalece sobre skies de modo Baja/Alta.
    if SettingsVisual.PurpleSky and SettingsVisual.PurpleSky.Enabled then
        pcall(function() SettingsVisual.ApplyPurpleSky(true) end)
    end
end

--============================================================--
-- CHINOINFIERNO | HUD FPS / PING (GAMA ALTA Y BAJA, PC Y MOVIL)
-- Barra estrecha en esquina superior izquierda dentro del area segura.
-- Muestra FPS REALES del RenderStepped y ping aproximado del cliente.
-- Ningun efecto del juego se apaga para hacer funcionar este HUD.
--============================================================--
do
    task.defer(function()
        local ok, err = pcall(function()
            local old = PlayerGui:FindFirstChild("CHINO_FPS_PING_MINI")
            if old then old:Destroy() end
            local ui = Instance.new("ScreenGui")
            ui.Name = "CHINO_FPS_PING_MINI"
            ui.ResetOnSpawn = false
            ui.IgnoreGuiInset = false
            ui.DisplayOrder = 90  -- Bajo la intro original (100).
            ui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            pcall(function()
                ui.ScreenInsets = Enum.ScreenInsets.CoreUISafeInsets
            end)
            ui.Parent = PlayerGui

            local card = Instance.new("Frame")
            card.Name = "FPS_Ping_Glass"
            card.Size = UDim2.fromOffset(162, 25)
            card.Position = UDim2.fromOffset(8, 6)
            card.BackgroundColor3 = Color3.fromRGB(13, 11, 28)
            card.BackgroundTransparency = 0.48
            card.BorderSizePixel = 0
            card.ZIndex = 2
            card.Parent = ui
            Instance.new("UICorner",card).CornerRadius = UDim.new(0, 7)
            local outline = Instance.new("UIStroke", card)
            outline.Color = Color3.fromRGB(158, 110, 243)
            outline.Transparency = 0.62
            outline.Thickness = 0.75

            local dot = Instance.new("Frame")
            dot.Name = "PerformanceIndicator"
            dot.Size = UDim2.fromOffset(5, 5)
            dot.Position = UDim2.fromOffset(7, 10)
            dot.BackgroundColor3 = Color3.fromRGB(95, 255, 198)
            dot.BackgroundTransparency = 0.05
            dot.BorderSizePixel = 0
            dot.ZIndex = 3
            dot.Parent = card
            Instance.new("UICorner",dot).CornerRadius = UDim.new(1,0)

            local fps = Instance.new("TextLabel")
            fps.Name = "FPS"
            fps.Size = UDim2.fromOffset(67, 22)
            fps.Position = UDim2.fromOffset(17, 1)
            fps.BackgroundTransparency = 1
            fps.Font = Enum.Font.GothamMedium
            fps.TextSize = 10
            fps.TextXAlignment = Enum.TextXAlignment.Left
            fps.TextColor3 = Color3.fromRGB(242, 237, 255)
            fps.Text = "FPS --"
            fps.ZIndex = 3
            fps.Parent = card

            local separator = Instance.new("Frame")
            separator.Size = UDim2.fromOffset(1, 12)
            separator.Position = UDim2.fromOffset(81, 6)
            separator.BackgroundColor3 = Color3.fromRGB(195, 159, 255)
            separator.BackgroundTransparency = 0.65
            separator.BorderSizePixel = 0
            separator.Parent = card

            local ping = Instance.new("TextLabel")
            ping.Name = "Ping"
            ping.Size = UDim2.fromOffset(74, 22)
            ping.Position = UDim2.fromOffset(87, 1)
            ping.BackgroundTransparency = 1
            ping.Font = Enum.Font.GothamMedium
            ping.TextSize = 10
            ping.TextXAlignment = Enum.TextXAlignment.Left
            ping.TextColor3 = Color3.fromRGB(197, 224, 255)
            ping.Text = "PING --"
            ping.ZIndex = 3
            ping.Parent = card

            -- Filete inferior luminoso, sin efectos caros o Tweens permanentes.
            local line = Instance.new("Frame")
            line.Size = UDim2.new(1, -16, 0, 1)
            line.Position = UDim2.new(0, 8, 1, -2)
            line.BackgroundColor3 = Color3.fromRGB(148, 80, 242)
            line.BackgroundTransparency = 0.25
            line.BorderSizePixel = 0
            line.Parent = card

            local elapsed, frames = 0, 0
            local smoothedFPS = nil
            local updateConnection
            local function readPingMillis()
                -- GetNetworkPing devuelve una latencia de una direccion en segundos.
                -- x2000 aprox. ida+y-vuelta. Si no existe, mostrar '--'.
                local okPing, seconds = pcall(function() return Player:GetNetworkPing() end)
                if okPing and type(seconds) == "number" and seconds >= 0 then
                    return math.floor(math.clamp(seconds * 2000, 0, 9999) + 0.5)
                end
                local success, value = pcall(function()
                    local stats = game:GetService("Stats")
                    local network = stats.Network
                    local item = network and network.ServerStatsItem["Data Ping"]
                    local raw = item and item:GetValueString()
                    return tonumber(tostring(raw):match("[%d%.]+"))
                end)
                if success and type(value) == "number" then return math.floor(value + 0.5) end
                return nil
            end
            updateConnection = RunService.RenderStepped:Connect(function(dt)
                if not ui.Parent then
                    updateConnection:Disconnect()
                    return
                end
                frames += 1
                elapsed += dt
                if elapsed < 0.65 then return end
                local observed = frames / math.max(elapsed, 0.01)
                -- Suavizado evita que el numero vibre cada actualizacion.
                smoothedFPS = smoothedFPS and (smoothedFPS * 0.56 + observed * 0.44) or observed
                local shownFPS = math.floor(smoothedFPS + 0.5)
                SettingsVisual.HighFluidityCurrentFPS = smoothedFPS
                fps.Text = "FPS " .. shownFPS
                local latency = readPingMillis()
                ping.Text = latency and ("PING " .. latency .. "ms") or "PING --"
                if shownFPS >= 55 then
                    dot.BackgroundColor3 = Color3.fromRGB(107, 255, 190)
                elseif shownFPS >= 36 then
                    dot.BackgroundColor3 = Color3.fromRGB(255, 209, 118)
                else
                    dot.BackgroundColor3 = Color3.fromRGB(255, 120, 148)
                end
                -- Histeresis: no cambiar el trabajo en cada bajon aislado.
                if SettingsVisual.PerformanceMode == "High" then
                    if smoothedFPS < 39 then
                        SettingsVisual.HighFluidityScanFactor = 0.75
                    elseif smoothedFPS > 49 then
                        SettingsVisual.HighFluidityScanFactor = 1
                    end
                else
                    SettingsVisual.HighFluidityScanFactor = 1
                end
                frames, elapsed = 0, 0
            end)
        end)
        if not ok then warn("[CHINO] Mini HUD FPS/PING:", err) end
    end)
end

SettingsVisual.SilentLaserEnabled = true
SettingsVisual.SilentLaserHoldTime = 1.0
SettingsVisual.SilentLaserFadeTime = 0.55
SettingsVisual.SilentLaserBrightness = 8

SettingsVisual.CreateSilentLaser = function(fromPos, toPos)
	if not SettingsVisual.SilentLaserEnabled then return end
	if typeof(fromPos) ~= "Vector3" or typeof(toPos) ~= "Vector3" then return end

	local distance = (toPos - fromPos).Magnitude
	if distance <= 0.05 then return end

	local hue = (os.clock() * 0.35) % 1
	local mainColor = Color3.fromHSV(hue, 0.95, 1)
	local glowColor = Color3.fromHSV((hue + 0.08) % 1, 0.85, 1)

	local laserCF =
		CFrame.new(fromPos, toPos)
		* CFrame.new(0, 0, -(distance * 0.5))

	local core = Instance.new("Part")
	core.Name = "CHINO_SilentLaserCore"
	core.Anchored = true
	core.CanCollide = false
	core.CanTouch = false
	core.CanQuery = false
	core.CastShadow = false
	core.Material = Enum.Material.Neon
	core.Color = mainColor
	core.Transparency = 0
	core.Size = Vector3.new(0.09, 0.09, distance)
	core.CFrame = laserCF
	core.Parent = workspace

	local glow = Instance.new("Part")
	glow.Name = "CHINO_SilentLaserGlow"
	glow.Anchored = true
	glow.CanCollide = false
	glow.CanTouch = false
	glow.CanQuery = false
	glow.CastShadow = false
	glow.Material = Enum.Material.Neon
	glow.Color = glowColor
	glow.Transparency = 0.46
	glow.Size = Vector3.new(0.27, 0.27, distance)
	glow.CFrame = laserCF
	glow.Parent = workspace

	local outerGlow = Instance.new("Part")
	outerGlow.Name = "CHINO_SilentLaserOuterGlow"
	outerGlow.Anchored = true
	outerGlow.CanCollide = false
	outerGlow.CanTouch = false
	outerGlow.CanQuery = false
	outerGlow.CastShadow = false
	outerGlow.Material = Enum.Material.Neon
	outerGlow.Color = mainColor
	outerGlow.Transparency = 0.79
	outerGlow.Size = Vector3.new(0.45, 0.45, distance)
	outerGlow.CFrame = laserCF
	outerGlow.Parent = workspace

	local laserLight = Instance.new("PointLight")
	laserLight.Color = mainColor
	laserLight.Brightness = tonumber(SettingsVisual.SilentLaserBrightness) or 8
	laserLight.Range = 18
	laserLight.Shadows = false
	laserLight.Parent = core

	local impactAnchor = Instance.new("Part")
	impactAnchor.Name = "CHINO_SilentLaserImpactLight"
	impactAnchor.Anchored = true
	impactAnchor.CanCollide = false
	impactAnchor.CanTouch = false
	impactAnchor.CanQuery = false
	impactAnchor.CastShadow = false
	impactAnchor.Transparency = 1
	impactAnchor.Size = Vector3.new(0.15, 0.15, 0.15)
	impactAnchor.CFrame = CFrame.new(toPos)
	impactAnchor.Parent = workspace

	local impactLight = Instance.new("PointLight")
	impactLight.Color = glowColor
	impactLight.Brightness = 10
	impactLight.Range = 20
	impactLight.Shadows = false
	impactLight.Parent = impactAnchor

	local groundGlow = nil
	local groundLight = nil

	pcall(function()
		local params = RaycastParams.new()
		params.FilterType = Enum.RaycastFilterType.Exclude
		params.IgnoreWater = true

		local filter = {
			core,
			glow,
			outerGlow,
			impactAnchor
		}

		if Player.Character then
			table.insert(filter, Player.Character)
		end

		params.FilterDescendantsInstances = filter

		local result =
			workspace:Raycast(
				toPos + Vector3.new(0, 3, 0),
				Vector3.new(0, -14, 0),
				params
			)

		if result then
			groundGlow = Instance.new("Part")
			groundGlow.Name = "CHINO_SilentLaserGroundGlow"
			groundGlow.Anchored = true
			groundGlow.CanCollide = false
			groundGlow.CanTouch = false
			groundGlow.CanQuery = false
			groundGlow.CastShadow = false
			groundGlow.Material = Enum.Material.Neon
			groundGlow.Color = mainColor
			groundGlow.Transparency = 0.42
			groundGlow.Shape = Enum.PartType.Cylinder
			groundGlow.Size = Vector3.new(0.055, 3.2, 3.2)
			groundGlow.CFrame =
				CFrame.new(result.Position + result.Normal * 0.045)
				* CFrame.Angles(0, 0, math.rad(90))
			groundGlow.Parent = workspace

			groundLight = Instance.new("PointLight")
			groundLight.Color = mainColor
			groundLight.Brightness = 7
			groundLight.Range = 12
			groundLight.Shadows = false
			groundLight.Parent = groundGlow
		end
	end)

	local holdTime = tonumber(SettingsVisual.SilentLaserHoldTime) or 1.0
	local fadeTime = tonumber(SettingsVisual.SilentLaserFadeTime) or 0.55

	task.delay(holdTime, function()
		local info =
			TweenInfo.new(
				fadeTime,
				Enum.EasingStyle.Quad,
				Enum.EasingDirection.Out
			)

		local function fadePart(part)
			if part and part.Parent then
				pcall(function()
					TweenService:Create(part, info, {Transparency = 1}):Play()
				end)
			end
		end

		local function fadeLight(light)
			if light and light.Parent then
				pcall(function()
					TweenService:Create(
						light,
						info,
						{Brightness = 0, Range = 0}
					):Play()
				end)
			end
		end

		fadePart(core)
		fadePart(glow)
		fadePart(outerGlow)
		fadePart(groundGlow)

		fadeLight(laserLight)
		fadeLight(impactLight)
		fadeLight(groundLight)

		task.delay(fadeTime + 0.08, function()
			for _, obj in ipairs({
				core,
				glow,
				outerGlow,
				impactAnchor
			}) do
				if obj then
					pcall(function()
						obj:Destroy()
					end)
				end
			end

			if groundGlow then
				pcall(function()
					groundGlow:Destroy()
				end)
			end
		end)
	end)
end

-- SILENT AIM EXACTO - comportamiento de CODIGOS DE(3)
--========================================================--

-- Ping igual al script fuente: lee NetworkStats/PingLabel y usa 0.2 de fallback.
SettingsVisual.SourceSilentGetPing = function()
	local pGui = Player:FindFirstChild("PlayerGui")
	if not pGui then return 0.2 end

	local statsGui = pGui:FindFirstChild("NetworkStats")
	if not statsGui then return 0.2 end

	local pingLabel = statsGui:FindFirstChild("PingLabel")
	if not pingLabel then return 0.2 end

	local pingText = pingLabel.Text
	if typeof(pingText) ~= "string" then return 0.2 end

	local pingMs = tonumber(pingText:match("%d+"))
	if not pingMs then return 0.2 end

	local ping = pingMs / 1000
	if ping < 0 or ping > 2 then
		ping = 0.2
	end

	return ping
end

-- Silent Aim y Target Line comparten el mismo selector con histéresis,
-- prioridad de armas y detección a larga distancia, incluso tras muros.
SettingsVisual.GetSourceSilentTarget = function()
    return SettingsVisual.GetChinoStickyTarget(SettingsVisual.FOVRadius)
end

-- Igual al original: el target se recalcula cada RenderStepped.
RunService.RenderStepped:Connect(function()
	if SilentAimEnabled then
		SettingsVisual.SourceSilentTarget = SettingsVisual.GetSourceSilentTarget()
	else
		SettingsVisual.SourceSilentTarget = nil
	end
end)

-- CHINO Smart Predict / Anti-Lock Resolver: conserva por separado las
-- muestras originales del Silent Aim y las que CHINO necesita.
SettingsVisual.ChinoRecordVelocity = function(pl, root)
	if not SettingsVisual.ChinoSmartPredictEnabled or not SilentAimEnabled or not root then return end
	local history = SettingsVisual.ChinoPredictHistory[pl]
	if not history then
		history = {}
		SettingsVisual.ChinoPredictHistory[pl] = history
	end
	local now = os.clock()
	local head = root.Parent and root.Parent:FindFirstChild("Head")
	local sample = {
		pos = head and head.Position or root.Position,
		vel = root.AssemblyLinearVelocity,
		time = now,
	}
	local previous = history[#history]
	table.insert(history, sample)
	if #history > 8 then table.remove(history, 1) end
	local spikes = SettingsVisual.ChinoPredictSpikes[pl]
	if not spikes then
		spikes = {count = 0, lastSpike = 0, isAntiLock = false}
		SettingsVisual.ChinoPredictSpikes[pl] = spikes
	end
	if previous and (sample.vel - previous.vel).Magnitude > (tonumber(SettingsVisual.ChinoVelocityThreshold) or 250) then
		-- Misma idea de CHINO: 3 cambios bruscos en una ventana de 2 s.
		if now - spikes.lastSpike > 2 then spikes.count = 0 end
		spikes.count += 1
		spikes.lastSpike = now
		if spikes.count >= 3 then spikes.isAntiLock = true end
	end
	if now - spikes.lastSpike > 3 then
		spikes.count = 0
		spikes.isAntiLock = false
	end
end

SettingsVisual.ChinoGetAverageVelocity = function(pl)
	local history = SettingsVisual.ChinoPredictHistory[pl]
	if not history or #history < 2 then return nil end
	local spikes = SettingsVisual.ChinoPredictSpikes[pl]
	local velocities = {}
	for i = 2, #history do
		local dt = history[i].time - history[i-1].time
		if dt > 0 then
			table.insert(velocities, (history[i].pos - history[i-1].pos) / dt)
		end
	end
	if #velocities == 0 then return nil end
	if spikes and spikes.isAntiLock then
		-- CHINO: magnitud mediana para filtrar los saltos de velocidad.
		table.sort(velocities, function(a,b) return a.Magnitude < b.Magnitude end)
		return velocities[math.ceil(#velocities/2)], true
	end
	local total = Vector3.zero
	for _,v in ipairs(velocities) do total += v end
	return total / #velocities, false
end

SettingsVisual.ChinoSmartPredictPosition = function(pl, partPosition, ping)
	local velocity, antiLock = SettingsVisual.ChinoGetAverageVelocity(pl)
	if not velocity then
		local char = pl and pl.Character
		local root = char and char:FindFirstChild("HumanoidRootPart")
		velocity = root and root.AssemblyLinearVelocity or Vector3.zero
		return partPosition + velocity * ping * 1.15
	end
	return partPosition + velocity * ping * (antiLock and 0.6 or 1.3)
end

-- Igual al original: guarda hasta 6 posiciones recientes por jugador
-- EN CADA Heartbeat, sin filtro adicional para vehículos.
RunService.Heartbeat:Connect(function()
	for _, pl in ipairs(Players:GetPlayers()) do
		if pl ~= Player and pl.Character then
			local root = pl.Character:FindFirstChild("HumanoidRootPart")
			local hum = pl.Character:FindFirstChild("Humanoid")

			if root and hum and hum.Health > 0 then
				local history = SettingsVisual.SourceSilentVelocityHistory[pl]
				if not history then
					history = {}
					SettingsVisual.SourceSilentVelocityHistory[pl] = history
				end

				table.insert(history, {
					time = os.clock(),
					pos = root.Position
				})

				local maxSamples = tonumber(SettingsVisual.SourceSilentVelocitySamples) or 6
				if #history > maxSamples then
					table.remove(history, 1)
				end
				SettingsVisual.ChinoRecordVelocity(pl, root)
			else
				SettingsVisual.SourceSilentVelocityHistory[pl] = nil
			end
		end
	end
end)

Players.PlayerRemoving:Connect(function(pl)
	SettingsVisual.SourceSilentVelocityHistory[pl] = nil
	SettingsVisual.ChinoPredictHistory[pl] = nil
	SettingsVisual.ChinoPredictSpikes[pl] = nil
	if SettingsVisual.SourceSilentTarget == pl then
		SettingsVisual.SourceSilentTarget = nil
	end
    if SettingsVisual.TargetSticky and SettingsVisual.TargetSticky.Locked==pl then
        SettingsVisual.TargetSticky.Locked=nil
        SettingsVisual.TargetSticky.LockForward=nil
        SettingsVisual.TargetSticky.CacheAt=0
        SettingsVisual.TargetSticky.CacheValue=nil
    end
    if SettingsVisual.TargetSticky then
        SettingsVisual.TargetSticky.WeaponCache[pl]=nil
    end
end)

SettingsVisual.SourceSilentCalculateVelocity = function(pl)
	local history = SettingsVisual.SourceSilentVelocityHistory[pl]
	if not history or #history < 2 then
		return Vector3.new()
	end

	local sum = Vector3.new()
	local count = 0

	for i = 2, #history do
		local dt = history[i].time - history[i - 1].time
		if dt > 0 then
			sum = sum + (history[i].pos - history[i - 1].pos) / dt
			count += 1
		end
	end

	if count == 0 then
		return Vector3.new()
	end

	local velocity = sum / count
	local verticalThreshold = tonumber(SettingsVisual.SourceSilentVerticalThreshold) or 150

	if velocity.Y > verticalThreshold then
		return Vector3.new(
			velocity.X * 1.15,
			math.clamp(velocity.Y * 0.85, 0, 400),
			velocity.Z * 1.15
		)
	end

	return velocity
end

SettingsVisual.SourceSilentPredictPosition = function(hitPart, offset)
	if not hitPart then return Vector3.zero end

	offset = offset or Vector3.zero

	local char = hitPart.Parent
	local pl = char and Players:GetPlayerFromCharacter(char)

	local basePosition =
		hitPart.Position + offset

	if not pl then
		return basePosition
	end

	local velocity =
		SettingsVisual.SourceSilentCalculateVelocity(pl)
		or Vector3.zero

	local ping =
		SettingsVisual.SourceSilentGetPing()

	if ping < 0 then
		ping = 0.1
	end

	-- Se conecta al Silent Aim YA EXISTENTE; con CHINO OFF la ruta
	-- de predicción original permanece exactamente igual.
	if SettingsVisual.ChinoSmartPredictEnabled then
		return SettingsVisual.ChinoSmartPredictPosition(pl, basePosition, ping)
	end

	return basePosition
		+ (
			velocity
			* ping
			* (
				tonumber(
					SettingsVisual.SourceSilentVelocityMultiplier
				)
				or 1.2
			)
		)
end

-- Conserva EXACTAMENTE el formato del disparo del script fuente.
-- Solo el punto físico puede ser Head / Neck / Chest; shotgun = 6 pellets.
SettingsVisual.ApplySourceSilentAim = function(args)
	if type(args) ~= "table"
		or not SilentAimEnabled
		or args[2] ~= "shoot_gun" then
		return args, nil
	end

	-- El Auto Shoot 360 puede elegir un enemigo detrás de la cámara.
	-- Esta preferencia SOLO existe durante su propio disparo y no cambia
	-- el objetivo permanente de Target Line ni el selector Sticky.
	local target = SettingsVisual.AutoShootSendOverride or SettingsVisual.SourceSilentTarget
    if SettingsVisual.IsSafeFriend(target) then
        target = nil
        SettingsVisual.SourceSilentTarget = nil
    end
	if not target then
		target = SettingsVisual.GetSourceSilentTarget()
		SettingsVisual.SourceSilentTarget = target
	end

	if not target or SettingsVisual.IsSafeFriend(target) or not target.Character then
		return args, nil
	end

	local targetHead =
		target.Character:FindFirstChild("Head")

	local targetRoot =
		target.Character:FindFirstChild("HumanoidRootPart")

	local targetHum =
		target.Character:FindFirstChild("Humanoid")

	if not targetHead or not targetRoot or not targetHum then
		return args, nil
	end

	-- SOLO cambia el punto de impacto; el selector de jugador,
	-- predictor, hook y formato del disparo siguen siendo los mismos.
	local selectedPart =
		SilentAimHitPart or "Head"

	local targetPart, targetOffset =
		getBypassedTargetPart(
			target.Character,
			selectedPart
		)

	-- Fallback obligatorio a Head: nunca rompe un disparo
	-- si un rig no tiene torso compatible.
	if not targetPart then
		targetPart = targetHead
		targetOffset = Vector3.zero
	end

	local predicted =
		SettingsVisual.SourceSilentPredictPosition(
			targetPart,
			targetOffset
		)

	local myHead = Player.Character and Player.Character:FindFirstChild("Head")
	local origin = myHead and myHead.Position or nil
	if not origin then
		return args, nil
	end


	if isCurrentShotgun() then
		args[4] = CFrame.new(origin, predicted)
		local pellets = {}

		for _ = 1, 6 do
			local spread = Vector3.new(
				math.random(-2, 2) * 0.03,
				math.random(-2, 2) * 0.03,
				math.random(-2, 2) * 0.03
			)

			table.insert(pellets, {
				[1] = {
					Instance = targetPart,
					Normal = Vector3.new(0, 1, 0),
					Position = predicted + spread
				}
			})
		end

		args[5] = pellets
	else
		args[4] = CFrame.new(origin, predicted)
		args[5] = {
			[1] = {
				[1] = {
					Instance = targetPart,
					Normal = Vector3.new(0, 1, 0),
					Position = predicted
				}
			}
		}
	end

	
					-- Visual únicamente; no cambia target ni hit data.
					SettingsVisual.CreateSilentLaser(
						origin,
						predicted
					)

return args, target
end

local function CreateBulletBeam(fromPos, toPos)
	-- Cada disparo toma un color distinto, intenso y brillante.
	local shotColor = Color3.fromHSV(math.random(), 1, 1)
	local dist = (toPos - fromPos).Magnitude
	if dist <= 0.05 then return end

	-- Núcleo brillante del rastro.
	local beamPart = Instance.new("Part")
	beamPart.Name = "LaserTracer"
	beamPart.Anchored = true
	beamPart.CanCollide = false
	beamPart.CanTouch = false
	beamPart.CanQuery = false
	beamPart.Material = Enum.Material.Neon
	beamPart.Color = shotColor
	beamPart.Transparency = 0
	beamPart.CastShadow = false
	beamPart.Size = Vector3.new(0.14, 0.14, dist)
	beamPart.CFrame = CFrame.new(fromPos, toPos) * CFrame.new(0, 0, -dist / 2)
	beamPart.Parent = workspace

	-- Halo exterior para que el color se vea más intenso.
	local glowPart = Instance.new("Part")
	glowPart.Name = "LaserTracerGlow"
	glowPart.Anchored = true
	glowPart.CanCollide = false
	glowPart.CanTouch = false
	glowPart.CanQuery = false
	glowPart.Material = Enum.Material.Neon
	glowPart.Color = shotColor
	glowPart.Transparency = 0.58
	glowPart.CastShadow = false
	glowPart.Size = Vector3.new(0.34, 0.34, dist)
	glowPart.CFrame = beamPart.CFrame
	glowPart.Parent = workspace

	local light = Instance.new("PointLight")
	light.Color = shotColor
	light.Brightness = 4
	light.Range = 9
	light.Parent = beamPart

	-- Destello pequeño en el objetivo.
	local impact = Instance.new("Part")
	impact.Name = "LaserImpact"
	impact.Shape = Enum.PartType.Ball
	impact.Anchored = true
	impact.CanCollide = false
	impact.CanTouch = false
	impact.CanQuery = false
	impact.Material = Enum.Material.Neon
	impact.Color = shotColor
	impact.Transparency = 0.05
	impact.Size = Vector3.new(0.34, 0.34, 0.34)
	impact.Position = toPos
	impact.Parent = workspace

	local tw = TweenService:Create(beamPart, TweenInfo.new(1.00, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Transparency = 1,
		Size = Vector3.new(0.035, 0.035, dist)
	})
	local glowTw = TweenService:Create(glowPart, TweenInfo.new(1.05, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Transparency = 1,
		Size = Vector3.new(0.07, 0.07, dist)
	})
	local impactTw = TweenService:Create(impact, TweenInfo.new(0.70, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Transparency = 1,
		Size = Vector3.new(0.05, 0.05, 0.05)
	})

	tw:Play()
	glowTw:Play()
	impactTw:Play()
	tw.Completed:Connect(function()
		beamPart:Destroy()
		if glowPart.Parent then glowPart:Destroy() end
		if impact.Parent then impact:Destroy() end
	end)
end

RunService.RenderStepped:Connect(function()
	local activeAimTarget = nil
	local activePartName = "Neck"

	if SettingsVisual.StrongAimbotEnabled then
		local bypassWallcheck = not SettingsVisual.SoftAimMobileWallcheck
		local target = SettingsVisual.StrongAimbotTarget

		-- Si murió, salió demasiado del FOV o dejó de ser válido, toma otro.
		if not SettingsVisual.IsStrongAimbotTargetValid(
			target,
			SoftAimMobileFOVRadius,
			bypassWallcheck
		) then
			target = SettingsVisual.GetStrongAimbotTarget(
				SoftAimMobileFOVRadius,
				bypassWallcheck
			)
			SettingsVisual.StrongAimbotTarget = target
		end

		-- Mientras el target siga válido, queda amarrado.
		-- Solo un giro fuerte de cámara permite buscar otro target
		-- que haya quedado cerca del centro de la mira.
		if target and target.Character then
			local targetPart = getBypassedTargetPart(target.Character, SoftAimMobilePart)
			if targetPart then
				local delta = targetPart.Position - Camera.CFrame.Position
				if delta.Magnitude > 0.001 then
					local dot = math.clamp(Camera.CFrame.LookVector:Dot(delta.Unit), -1, 1)
					local angle = math.deg(math.acos(dot))

					if angle >= (tonumber(SettingsVisual.StrongAimbotBreakAngle) or 22) then
						local switchRadius = (tonumber(SoftAimMobileFOVRadius) or 95)
							* (tonumber(SettingsVisual.StrongAimbotSwitchRadiusScale) or 0.48)

						local candidate = SettingsVisual.GetStrongAimbotTarget(
							switchRadius,
							bypassWallcheck,
							target
						)

						if candidate then
							target = candidate
							SettingsVisual.StrongAimbotTarget = candidate
						end
					end
				end
			end
		end

		activeAimTarget = target
		activePartName = SoftAimMobilePart

	elseif SoftAimMobileEnabled and SettingsVisual.SoftAimMobileHolding then
		-- Aimbot táctil: mientras mantienes presionado, NO cambia de jugador.
		activeAimTarget = SettingsVisual.SoftAimLockedTarget
		activePartName = SoftAimMobilePart
	elseif SoftAimPCEnabled and SoftAimPCHolding then
		activeAimTarget = SettingsVisual.SoftAimLockedTarget
		activePartName = SoftAimPCPart
	end

	if activeAimTarget and activeAimTarget.Character then
		local tChar = activeAimTarget.Character
		local hitPart, offsetPos = getBypassedTargetPart(tChar, activePartName)
		if hitPart then
			local finalPos = hitPart.Position + offsetPos
			local myHum = Player.Character and Player.Character:FindFirstChildOfClass("Humanoid")
			if myHum and myHum.SeatPart then
				finalPos = finalPos
					+ Camera.CFrame.RightVector * (SettingsVisual.VehicleAimOffsetX / 10)
					+ Vector3.new(0, SettingsVisual.VehicleAimOffsetY / 10, 0)
			end

			-- Lock fuerte: la cámara vuelve al target cada frame.
			Camera.CFrame = CFrame.new(Camera.CFrame.Position, finalPos)
		end
	end
end)

--========================================================--
-- SONIDO AL ELIMINAR A OTRO JUGADOR
-- Solo se arma después de un disparo/golpe enviado por este cliente y
-- exige una bajada de vida inmediata antes de Humanoid.Died.
--========================================================--
SettingsVisual.KillWatchData = setmetatable({}, {__mode = "k"})
SettingsVisual.KillWatchConnections = setmetatable({}, {__mode = "k"})

SettingsVisual.PlayKillNotificationSound = function(volumeOverride)
	task.spawn(function()
		pcall(function()
			local url = "https://files.catbox.moe/55g1x4.mp3"
			local fileName = "greengiant_audio.mp3"
			local usableAsset = nil

			if isfile and writefile then
				if not isfile(fileName) then
					local ok, audioData = pcall(function()
						return game:HttpGet(url)
					end)
					if ok and audioData then
						pcall(function() writefile(fileName, audioData) end)
					end
				end

				if getcustomasset and isfile(fileName) then
					pcall(function()
						usableAsset = getcustomasset(fileName)
					end)
				end
			end

			local sound = Instance.new("Sound")
			sound.Name = "CHINO_KillNotification"
			sound.Parent = workspace.CurrentCamera or workspace
			sound.SoundId = usableAsset or url
			sound.Volume = tonumber(volumeOverride) or 3
			sound.PlaybackSpeed = 1.15

			local pitchCorrection = Instance.new("PitchShiftSoundEffect")
			pitchCorrection.Octave = 0.87
			pitchCorrection.Parent = sound

			local reverb = Instance.new("ReverbSoundEffect")
			reverb.DecayTime = 1.8
			reverb.Density = 0.8
			reverb.Diffusion = 0.85
			reverb.DryLevel = 0
			-- WetLevel de Roblox se limita a 0 dB; 0 conserva el efecto fuerte sin error.
			reverb.WetLevel = 0
			reverb.Parent = sound

			sound:Play()
			sound.Ended:Connect(function()
				task.wait(1)
				if sound then sound:Destroy() end
			end)
		end)
	end)
end

-- Sonido corto al activar/desactivar opciones del panel.
SettingsVisual.PlayToggleSound = function()
	task.spawn(function()
		pcall(function()
			local url = "https://files.catbox.moe/1qxv4b.mp3"
			local fileName = "chinohub_toggle_audio.mp3"
			local usableAsset = nil

			if isfile and writefile then
				if not isfile(fileName) then
					local ok, audioData = pcall(function()
						return game:HttpGet(url)
					end)
					if ok and audioData then
						pcall(function() writefile(fileName, audioData) end)
					end
				end

				if getcustomasset and isfile(fileName) then
					pcall(function()
						usableAsset = getcustomasset(fileName)
					end)
				end
			end

			local sound = Instance.new("Sound")
			sound.Name = "CHINO_ToggleSound"
			sound.Parent = workspace.CurrentCamera or workspace
			sound.SoundId = usableAsset or url
			sound.Volume = 1.35
			sound:Play()
			sound.Ended:Connect(function()
				if sound then sound:Destroy() end
			end)
		end)
	end)
end

-- Sonido de entrada: se reproduce al salir "Hello"; slowed + reverb sombría.
-- No se cambia el archivo fuente, solo su procesamiento al reproducir.
SettingsVisual.PlayStartupSound = function()
	task.spawn(function()
		pcall(function()
			local url = "https://files.catbox.moe/55g1x4.mp3"
			local fileName = "greengiant_audio.mp3"
			local usableAsset = nil

			if isfile and writefile then
				if not isfile(fileName) then
					local ok, audioData = pcall(function()
						return game:HttpGet(url)
					end)
					if ok and audioData then
						pcall(function() writefile(fileName, audioData) end)
					end
				end
				if getcustomasset and isfile(fileName) then
					pcall(function() usableAsset = getcustomasset(fileName) end)
				end
			end

			local sound = Instance.new("Sound")
            sound.Name = "CHINO_IntroSlowed"
            sound.Parent = workspace.CurrentCamera or workspace
            sound.SoundId = usableAsset or url
            sound.Volume = 1.85
            sound.PlaybackSpeed = 0.70
            local reverb=Instance.new("ReverbSoundEffect",sound)
            reverb.DecayTime=2.8
            reverb.Density=0.9
            reverb.Diffusion=0.78
            reverb.DryLevel=-1
            reverb.WetLevel=-9
            local equalizer=Instance.new("EqualizerSoundEffect",sound)
            equalizer.LowGain=3.5
            equalizer.MidGain=-2.8
            equalizer.HighGain=-5.5
            local echo=Instance.new("EchoSoundEffect",sound)
            echo.Delay=0.24
            echo.Feedback=0.21
            echo.DryLevel=0
            echo.WetLevel=-19
            sound:Play()
			sound.Ended:Connect(function()
				task.wait(0.5)
				if sound then sound:Destroy() end
			end)
		end)
	end)
end

-- ========================================================--
-- IDIOMAS DEL PANEL
-- Español/English son locales e instantáneos. Los demás idiomas del selector
-- usan traducción en línea cuando el executor permite game:HttpGet; si falla,
-- se conserva la versión inglesa para no romper ninguna función.
-- ========================================================--
SettingsVisual.I18NEnglish = {
	["Silent Aim"] = "Silent Aim", ["Soft Aim"] = "Soft Aim", ["ESP"] = "ESP",
	["Player"] = "Player", ["Vehicle"] = "Vehicle", ["Misc"] = "Misc", ["Farm"] = "Farm", ["Ammo"] = "Ammo", ["Buy"] = "Buy",
	["Armas"] = "Weapons", ["TP Items"] = "TP Items", ["Config"] = "Config",
	["AUTOWIN2"] = "AUTOWIN2", ["Skip Cajas"] = "Skip Cajas", ["Gun Mods"] = "Gun Mods", ["Automatic"] = "Automatic",
	["Melee Aura"] = "Melee Aura", ["Kill Aura"] = "Kill Aura", ["Auto Attack"] = "Auto Attack", ["Auto Pickup (85 Studs)"] = "Auto Pickup (85 Studs)",
	["Fire Rate"] = "Fire Rate", ["Rapid Fire (No Limit)"] = "Rapid Fire (No Limit)", ["Multiplier Shot"] = "Multiplier Shot", ["Accuracy"] = "Accuracy", ["Reload Time"] = "Reload Time",
	["Abrir Ammo Crate"] = "Open Ammo Crate", ["Buy Ammo"] = "Buy Ammo", ["Buy Guns"] = "Buy Guns", ["Buy Cars"] = "Buy Cars", ["Gun Crate"] = "Gun Crate", ["Car Crate"] = "Car Crate", ["Limpieza de Puertas"] = "Door Cleanup", ["Ammo Type"] = "Ammo Type", ["Bank"] = "Bank", ["Money"] = "Money",
	["Radio Pickup"] = "Pickup Radius", ["Recoil Mod"] = "Recoil Mod", ["Target Line"] = "Target Line",
	["Mostrar FOV"] = "Show FOV", ["Radio FOV"] = "FOV Radius", ["Auto Attack Target"] = "Auto Attack Target",
	["Aimbot Táctil"] = "Touch Aimbot", ["Aimbot"] = "Aimbot", ["Aimbot Tecla"] = "Key Aimbot", ["Wallcheck"] = "Wall Check", ["Bloquear botón AIM"] = "Lock AIM Button", ["Ocultar botón AIM"] = "Hide AIM Button",
	["Radio FOV Mobile"] = "Mobile FOV Radius", ["Radio FOV PC"] = "PC FOV Radius",
	["ESP Box"] = "ESP Box", ["ESP Highlight"] = "ESP Highlight", ["ESP Nombres"] = "ESP Names",
	["ESP Salud"] = "ESP Health", ["ESP Distancia"] = "ESP Distance", ["ESP Armas"] = "ESP Weapons", ["ESP Ítems"] = "ESP Items",
	["Actualizar ESP"] = "Refresh ESP", ["Salto Infinito"] = "Infinite Jump", ["Potencia Salto"] = "Jump Power",
	["Stamina Infinita"] = "Infinite Stamina", ["Ocultar Nombre"] = "Hide Name", ["Anti Lock"] = "Anti Lock",
	["Anti Ragdoll"] = "Anti Ragdoll", ["Speed Hack"] = "Speed Hack", ["Velocidad"] = "Speed",
	["Anti-kill"] = "Anti-Kill", ["Panel Táctil"] = "Touch Panel", ["Ghost Mode"] = "Ghost Mode", ["Invisible"] = "Invisible",
	["Move Car"] = "Move Car", ["Kill Aura Kill"] = "Kill Aura Kill",
	["Acceleration"] = "Acceleration", ["Braking"] = "Braking", ["Deceleration"] = "Deceleration",
	["Forward Max Speed"] = "Forward Max Speed", ["Reverse Max Speed"] = "Reverse Max Speed", ["Suspension"] = "Suspension",
	["Pull Car Owner"] = "Pull Owned Car", ["AutoLock Vehicle"] = "AutoLock Vehicle", ["Bring"] = "Bring", ["Test"] = "Test",
	["Auto Shoot"] = "Auto Shoot", ["Auto Shoot Speed"] = "Auto Shoot Speed", ["Durability"] = "Durability", ["Durability Power"] = "Durability Power", ["Infinite Hotbar"] = "Infinite Hotbar", ["WideFists"] = "WideFists",
	["Claim All Quest"] = "Claim All Quests", ["Auto Finnish"] = "Auto Finish", ["Auto Respawn"] = "Auto Respawn",
	["Optimizar FPS"] = "Optimize FPS", ["Bullet"] = "Bullet",
	["Guardar Config"] = "Save Config", ["Reset Config"] = "Reset Config", ["Color Panel"] = "Panel Color", ["Wallhack"] = "Wallhack", ["Fling TP"] = "Fling TP",
	["Head"] = "Head", ["Neck"] = "Neck", ["Chest"] = "Chest", ["RUN"] = "RUN"
}
SettingsVisual.I18NSpanish = {
	["Silent Aim"] = "Aim Silencioso", ["Soft Aim"] = "Aim Suave", ["Player"] = "Jugador", ["Vehicle"] = "Vehículo",
	["Misc"] = "Varios", ["Farm"] = "Farm", ["Ammo"] = "Munición", ["Buy"] = "Buy", ["Armas"] = "Armas", ["TP Items"] = "TP Items", ["Config"] = "Config", ["AUTOWIN2"] = "AUTOWIN2", ["Skip Cajas"] = "Skip Cajas",
	["Gun Mods"] = "Mods de Armas", ["Automatic"] = "Automático", ["Melee Aura"] = "Aura Cuerpo a Cuerpo", ["Kill Aura"] = "Kill Aura",
	["Auto Attack"] = "Ataque Automático", ["Auto Pickup (85 Studs)"] = "Recogida Automática (85 Studs)",
	["Fire Rate"] = "Cadencia", ["Rapid Fire (No Limit)"] = "Disparo Rápido (Sin Límite)", ["Multiplier Shot"] = "Multiplicador de Disparo", ["Accuracy"] = "Precisión", ["Reload Time"] = "Tiempo de Recarga",
	["Abrir Ammo Crate"] = "Abrir Ammo Crate", ["Buy Ammo"] = "Buy Ammo", ["Buy Guns"] = "Buy Guns", ["Buy Cars"] = "Buy Cars", ["Gun Crate"] = "Gun Crate", ["Car Crate"] = "Car Crate", ["Limpieza de Puertas"] = "Limpieza de Puertas", ["Ammo Type"] = "Tipo de Munición", ["Bank"] = "Bank", ["Money"] = "Dinero",
	["Radio Pickup"] = "Radio de Recogida", ["Recoil Mod"] = "Mod de Retroceso", ["Target Line"] = "Línea de Objetivo",
	["Mostrar FOV"] = "Mostrar FOV", ["Radio FOV"] = "Radio FOV", ["Auto Attack Target"] = "Auto Atacar Objetivo",
	["Aimbot Táctil"] = "Aimbot Táctil", ["Aimbot"] = "Aimbot", ["Aimbot Tecla"] = "Aimbot Tecla", ["Wallcheck"] = "Comprobar Pared", ["Bloquear botón AIM"] = "Bloquear Botón AIM", ["Ocultar botón AIM"] = "Ocultar Botón AIM",
	["Radio FOV Mobile"] = "Radio FOV Móvil", ["Radio FOV PC"] = "Radio FOV PC",
	["ESP Box"] = "ESP Caja", ["ESP Highlight"] = "ESP Resaltado", ["ESP Nombres"] = "ESP Nombres",
	["ESP Salud"] = "ESP Salud", ["ESP Distancia"] = "ESP Distancia", ["ESP Armas"] = "ESP Armas", ["ESP Ítems"] = "ESP Ítems",
	["Actualizar ESP"] = "Actualizar ESP", ["Salto Infinito"] = "Salto Infinito", ["Potencia Salto"] = "Potencia de Salto",
	["Stamina Infinita"] = "Estamina Infinita", ["Ocultar Nombre"] = "Ocultar Nombre", ["Anti Lock"] = "Anti Lock",
	["Anti Ragdoll"] = "Anti Ragdoll", ["Speed Hack"] = "Velocidad", ["Velocidad"] = "Velocidad",
	["Anti-kill"] = "Anti-Kill", ["Panel Táctil"] = "Panel Táctil", ["Ghost Mode"] = "Modo Fantasma", ["Invisible"] = "Invisible",
	["Move Car"] = "Mover Carro", ["Kill Aura Kill"] = "Kill Aura Kill",
	["Acceleration"] = "Acceleration", ["Braking"] = "Braking", ["Deceleration"] = "Deceleration",
	["Forward Max Speed"] = "Forward Max Speed", ["Reverse Max Speed"] = "Reverse Max Speed", ["Suspension"] = "Suspension",
	["Pull Car Owner"] = "Traer Mi Carro", ["AutoLock Vehicle"] = "AutoLock Vehicle", ["Bring"] = "Bring", ["Test"] = "Test",
	["Auto Shoot"] = "Auto Shoot", ["Auto Shoot Speed"] = "Auto Shoot Speed", ["Durability"] = "Durability", ["Durability Power"] = "Durability Power", ["Infinite Hotbar"] = "Infinite Hotbar", ["WideFists"] = "WideFists",
	["Claim All Quest"] = "Reclamar Misiones", ["Auto Finnish"] = "Finalizar Automático", ["Auto Respawn"] = "Respawn Automático",
	["Optimizar FPS"] = "Optimizar FPS", ["Bullet"] = "Bala",
	["Guardar Config"] = "Guardar Config", ["Reset Config"] = "Restablecer Config", ["Color Panel"] = "Color del Panel", ["Wallhack"] = "Wallhack", ["Fling TP"] = "Fling TP",
	["Head"] = "Cabeza", ["Neck"] = "Cuello", ["Chest"] = "Pecho", ["RUN"] = "EJECUTAR"
}
SettingsVisual.LanguageChoices = {
	{"Español", "es"}, {"English", "en"}, {"Português", "pt"}, {"Français", "fr"}, {"Deutsch", "de"},
	{"Italiano", "it"}, {"Русский", "ru"}, {"中文", "zh-CN"}, {"日本語", "ja"}, {"한국어", "ko"},
	{"العربية", "ar"}, {"हिन्दी", "hi"}, {"Türkçe", "tr"}, {"Polski", "pl"}, {"Nederlands", "nl"},
	{"Svenska", "sv"}, {"Norsk", "no"}, {"Dansk", "da"}, {"Suomi", "fi"}, {"Čeština", "cs"},
	{"Slovenčina", "sk"}, {"Magyar", "hu"}, {"Română", "ro"}, {"Български", "bg"}, {"Українська", "uk"},
	{"Ελληνικά", "el"}, {"עברית", "he"}, {"Bahasa Indonesia", "id"}, {"Bahasa Melayu", "ms"}, {"ไทย", "th"},
	{"Tiếng Việt", "vi"}, {"Filipino", "fil"}, {"Kiswahili", "sw"}, {"Afrikaans", "af"}, {"Català", "ca"},
	{"Euskara", "eu"}, {"Galego", "gl"}, {"Hrvatski", "hr"}, {"Српски", "sr"}, {"Slovenščina", "sl"},
	{"Eesti", "et"}, {"Latviešu", "lv"}, {"Lietuvių", "lt"}, {"Íslenska", "is"}, {"Gaeilge", "ga"},
	{"Malti", "mt"}, {"فارسی", "fa"}, {"اردو", "ur"}, {"বাংলা", "bn"}, {"தமிழ்", "ta"},
	{"తెలుగు", "te"}, {"मराठी", "mr"}, {"ગુજરાતી", "gu"}, {"ಕನ್ನಡ", "kn"}, {"മലയാളം", "ml"},
	{"नेपाली", "ne"}, {"සිංහල", "si"}, {"ខ្មែរ", "km"}, {"ລາວ", "lo"}, {"မြန်မာ", "my"},
	{"Монгол", "mn"}, {"ქართული", "ka"}, {"Հայերեն", "hy"}, {"Azərbaycanca", "az"}, {"Қазақша", "kk"},
	{"O‘zbek", "uz"}, {"پښتو", "ps"}, {"አማርኛ", "am"}, {"isiZulu", "zu"}, {"isiXhosa", "xh"},
	{"Yorùbá", "yo"}, {"Igbo", "ig"}, {"Hausa", "ha"}
}
SettingsVisual.TranslationCache = {}
SettingsVisual.TranslateUIString = function(source, targetCode)
	local english = SettingsVisual.I18NEnglish[source] or source
	if targetCode == "en" then return english end
	if targetCode == "es" then return SettingsVisual.I18NSpanish[source] or source end
	SettingsVisual.TranslationCache[targetCode] = SettingsVisual.TranslationCache[targetCode] or {}
	if SettingsVisual.TranslationCache[targetCode][english] then return SettingsVisual.TranslationCache[targetCode][english] end
	local translated = english
	pcall(function()
		local http = game:GetService("HttpService")
		local endpoint = "https://translate.googleapis.com/translate_a/single?client=gtx&sl=en&tl="
			.. http:UrlEncode(targetCode) .. "&dt=t&q=" .. http:UrlEncode(english)
		local raw = game:HttpGet(endpoint)
		local decoded = http:JSONDecode(raw)
		local pieces = {}
		if type(decoded) == "table" and type(decoded[1]) == "table" then
			for _, segment in ipairs(decoded[1]) do
				if type(segment) == "table" and type(segment[1]) == "string" then
					table.insert(pieces, segment[1])
				end
			end
		end
		if #pieces > 0 then translated = table.concat(pieces) end
	end)
	SettingsVisual.TranslationCache[targetCode][english] = translated
	return translated
end
SettingsVisual.ApplyLanguage = function(targetCode)
	SettingsVisual.CurrentLanguageCode = targetCode
	for _, obj in ipairs(Main:GetDescendants()) do
		if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
			local source = obj:GetAttribute("CHINO_I18N_SOURCE")
			if not source and SettingsVisual.I18NEnglish[obj.Text] then
				source = obj.Text
				pcall(function() obj:SetAttribute("CHINO_I18N_SOURCE", source) end)
			end
			if source and SettingsVisual.I18NEnglish[source] then
				if targetCode == "es" or targetCode == "en" then
					obj.Text = SettingsVisual.TranslateUIString(source, targetCode)
				else
					-- Los idiomas que dependen de traducción web se resuelven en segundo plano
					-- para que el botón OK nunca congele la apertura del panel.
					task.spawn(function()
						local ok, translated = pcall(SettingsVisual.TranslateUIString, source, targetCode)
						if ok and translated and obj and obj.Parent and SettingsVisual.CurrentLanguageCode == targetCode then
							obj.Text = translated
						end
					end)
				end
			end
		end
	end
end

--========================================================--
-- CHINOINFIERNO V3 | COMBAT DAMAGE FX - VISUAL, AUTO ON
-- Numeros anime compactos, sin cartel + HIT COMBO + daño acumulado + KO.
-- Solo reacciona a bajadas de vida observadas tras un ataque local.
-- No modifica salud, daño, balas, remotes ni cadencia del arma.
--========================================================--
do
    local previous = PlayerGui:FindFirstChild("CHINO_CombatDamageFX")
    if previous then previous:Destroy() end

    local hud = Instance.new("ScreenGui")
    hud.Name = "CHINO_CombatDamageFX"
    hud.IgnoreGuiInset = true
    hud.ResetOnSpawn = false
    hud.DisplayOrder = 60
    hud.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    hud.Parent = PlayerGui

    local C = {
        purple = Color3.fromRGB(171, 91, 255),
        purpleDark = Color3.fromRGB(37, 18, 67),
        cyan = Color3.fromRGB(91, 244, 255),
        pink = Color3.fromRGB(255, 104, 209),
        gold = Color3.fromRGB(255, 216, 115),
        white = Color3.fromRGB(244, 242, 255),
        low = Color3.fromRGB(186, 177, 211)
    }
    local function corner(parent, radius)
        local x = Instance.new("UICorner")
        x.CornerRadius = UDim.new(0, radius)
        x.Parent = parent
    end
    local function mkText(parent, name, txt, size, color, pos, dim, z)
        local o = Instance.new("TextLabel")
        o.Name = name
        o.BackgroundTransparency = 1
        o.BorderSizePixel = 0
        o.Text = txt
        o.Font = Enum.Font.GothamBold
        o.TextSize = size
        o.TextColor3 = color
        o.TextStrokeColor3 = Color3.fromRGB(15, 8, 35)
        o.TextStrokeTransparency = 0.55
        o.TextXAlignment = Enum.TextXAlignment.Center
        o.TextYAlignment = Enum.TextYAlignment.Center
        o.Position = pos
        o.Size = dim
        o.ZIndex = z or 3
        o.Parent = parent
        return o
    end
    local function fmt(n)
        local v = math.floor((tonumber(n) or 0) * 10 + 0.5) / 10
        if v == math.floor(v) then return tostring(math.floor(v)) end
        return string.format("%.1f", v)
    end
    local panel = Instance.new("Frame")
    panel.Name = "ComboGlass"
    panel.AnchorPoint = Vector2.new(0.5, 0)
    panel.Position = UDim2.fromScale(0.5, 0.125)
    panel.Size = UDim2.fromOffset(196, 65)
    panel.BackgroundColor3 = C.purpleDark
    panel.BackgroundTransparency = 1
    panel.BorderSizePixel = 0
    panel.Visible = false
    panel.Parent = hud
    -- Sin tarjeta oscura, borde ni cartel: SOLO letras flotantes estilo anime.
    local damageLabel = mkText(panel,"LastDamage","-0 DMG",20,C.white,
        UDim2.fromOffset(4,4),UDim2.new(1,-8,0,30),4)
    damageLabel.Font = Enum.Font.GothamBlack
    damageLabel.TextStrokeColor3 = C.purpleDark
    damageLabel.TextStrokeTransparency = 0.12
    local comboLabel = mkText(panel,"HitCombo","1 HIT",12,C.cyan,
        UDim2.fromOffset(4,35),UDim2.new(0.55,-4,0,18),4)
    comboLabel.Font = Enum.Font.GothamBlack
    local totalLabel = mkText(panel,"TotalDamage","TOTAL 0",10,C.low,
        UDim2.new(0.55,0,0,35),UDim2.new(0.45,-4,0,18),4)
    local panelScale = Instance.new("UIScale")
    panelScale.Scale = 1
    panelScale.Parent = panel

    -- Marcador discreto de cuatro lineas alrededor de la mira.
    local marker = Instance.new("Frame")
    marker.Name = "HitConfirm"
    marker.AnchorPoint = Vector2.new(0.5,0.5)
    marker.Position = UDim2.fromScale(0.5,0.5)
    marker.Size = UDim2.fromOffset(42,42)
    marker.BackgroundTransparency = 1
    marker.Visible = false
    marker.Parent = hud
    local strokes = {}
    for i = 1,4 do
        local bar = Instance.new("Frame")
        bar.Name = "HitBar" .. i
        bar.AnchorPoint = Vector2.new(0.5,0.5)
        bar.Size = UDim2.fromOffset(13,3)
        bar.Rotation = (i % 2 == 0) and -45 or 45
        bar.Position = ({
            UDim2.fromOffset(10,10), UDim2.fromOffset(32,10),
            UDim2.fromOffset(10,32), UDim2.fromOffset(32,32)
        })[i]
        bar.BackgroundColor3 = C.cyan
        bar.BorderSizePixel = 0
        bar.BackgroundTransparency = 0
        bar.Parent = marker
        corner(bar,2)
        strokes[i] = bar
    end

    local combo, sum, lastHit, sequence, markerSeq, popups = 0, 0, 0, 0, 0, {}
    local activeFades = {}
    local viewportConnection
    local function updateScale()
        local camera = workspace.CurrentCamera
        local view = camera and camera.ViewportSize or Vector2.new(1000,700)
        panelScale.Scale = (view.X < 520) and 0.78 or ((view.X < 850) and 0.9 or 1)
    end
    updateScale()
    if workspace.CurrentCamera then
        viewportConnection = workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateScale)
    end
    hud.Destroying:Connect(function()
        if viewportConnection then viewportConnection:Disconnect(); viewportConnection = nil end
    end)

    local function flashMarker()
        markerSeq += 1
        local serial = markerSeq
        marker.Visible = true
        for _,bar in ipairs(strokes) do
            bar.BackgroundTransparency = 0
            bar.BackgroundColor3 = C.cyan
        end
        task.delay(0.12,function()
            if serial ~= markerSeq or not marker.Parent then return end
            for _,bar in ipairs(strokes) do
                TweenService:Create(bar,TweenInfo.new(0.24),{BackgroundTransparency=1}):Play()
            end
            task.delay(0.26,function()
                if marker.Parent and serial == markerSeq then marker.Visible = false end
            end)
        end)
    end

    local function floatNumber(targetPlayer, damage, count)
        local camera = workspace.CurrentCamera
        if not camera then return end
        local view = camera.ViewportSize
        local x,y = view.X*0.5,view.Y*0.51
        local character = targetPlayer and targetPlayer.Character
        local part = character and (character:FindFirstChild("Head") or character:FindFirstChild("HumanoidRootPart"))
        if part then
            local projected, visible = camera:WorldToViewportPoint(part.Position + Vector3.new(0,1.4,0))
            if visible and projected.Z > 0 then
                x = math.clamp(projected.X,70,math.max(70,view.X-70))
                y = math.clamp(projected.Y,95,math.max(95,view.Y-85))
            end
        end
        -- Dispersion ligera para que los numeros consecutivos no se tapen.
        x += math.random(-20,20)
        y += math.random(-10,10)
        local popup = Instance.new("Frame")
        popup.Name = "DamagePopup"
        popup.AnchorPoint = Vector2.new(0.5,0.5)
        popup.Size = UDim2.fromOffset(106,49)
        popup.Position = UDim2.fromOffset(x,y)
        popup.BackgroundTransparency = 1
        popup.Parent = hud

        -- Tinta de manga: numero compacto inclinado + contorno marcado.
        local shadow = mkText(popup,"Shadow","-"..fmt(damage),23,C.pink,
            UDim2.fromOffset(2,1),UDim2.fromScale(1,0.70),8)
        shadow.Font = Enum.Font.GothamBlack
        shadow.Rotation = -8
        shadow.TextTransparency = 0.4
        shadow.TextStrokeTransparency = 0.65
        local number = mkText(popup,"Damage","-"..fmt(damage),22,
            (count >= 5) and C.gold or C.white,
            UDim2.fromOffset(0,0),UDim2.fromScale(1,0.70),9)
        number.Font = Enum.Font.GothamBlack
        number.Rotation = -8
        number.TextStrokeColor3 = C.purpleDark
        number.TextStrokeTransparency = 0.08
        local small = mkText(popup,"TinyHit",(count>1 and ("✦ HIT x"..count) or "✦ HIT"),9,
            count >= 5 and C.gold or C.cyan,
            UDim2.fromScale(0,0.70),UDim2.fromScale(1,0.26),9)
        small.Font = Enum.Font.GothamBlack
        small.Rotation = -5
        small.TextStrokeTransparency = 0.25
        -- Lineas de impacto anime: pequeñas, sin fondo ni placa.
        local rays = {}
        for i = 1,4 do
            local ray = Instance.new("Frame")
            ray.Name = "AnimeImpactLine"..i
            ray.BorderSizePixel = 0
            ray.BackgroundColor3 = (i % 2 == 0) and C.pink or C.cyan
            ray.BackgroundTransparency = 0.12
            ray.Size = UDim2.fromOffset((i % 2 == 0) and 13 or 9,2)
            ray.AnchorPoint = Vector2.new(0.5,0.5)
            ray.Position = ({
                UDim2.fromScale(0.13,0.12), UDim2.fromScale(0.89,0.18),
                UDim2.fromScale(0.09,0.65), UDim2.fromScale(0.88,0.69)
            })[i]
            ray.Rotation = ({-35,25,22,-30})[i]
            ray.ZIndex = 7
            ray.Parent = popup
            rays[#rays+1] = ray
        end
        local popScale = Instance.new("UIScale")
        popScale.Scale = 0.72
        popScale.Parent = popup
        TweenService:Create(popScale,TweenInfo.new(0.17,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{
            Scale = 1
        }):Play()
        table.insert(popups,popup)
        for i = #popups,1,-1 do
            if not popups[i].Parent then table.remove(popups,i) end
        end
        while #popups > 8 do
            local oldest = table.remove(popups,1)
            if oldest and oldest.Parent then oldest:Destroy() end
        end
        TweenService:Create(popup,TweenInfo.new(0.75,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{
            Position = UDim2.fromOffset(x+math.random(-24,24),y-57)
        }):Play()
        for _,label in ipairs({shadow,number,small}) do
            TweenService:Create(label,TweenInfo.new(0.68,Enum.EasingStyle.Quad,Enum.EasingDirection.In,0,false,0.16),{
                TextTransparency=1,TextStrokeTransparency=1
            }):Play()
        end
        for _,ray in ipairs(rays) do
            TweenService:Create(ray,TweenInfo.new(0.31,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{
                BackgroundTransparency=1
            }):Play()
        end
        Debris:AddItem(popup,0.94)
    end

    SettingsVisual.CombatDamageFXEnabled = true
    SettingsVisual.ShowCombatDamage = function(targetPlayer, damage)
        if not SettingsVisual.CombatDamageFXEnabled or not hud.Parent then return end
        damage = tonumber(damage)
        if not damage or damage <= 0 or damage ~= damage then return end
        damage = math.min(damage,100000)
        local now = os.clock()
        if now-lastHit > 1.7 then combo, sum = 0, 0 end
        combo = combo+1
        sum = sum+damage
        lastHit = now
        sequence += 1
        local serial = sequence
        for _,tween in ipairs(activeFades) do
            pcall(function() tween:Cancel() end)
        end
        table.clear(activeFades)

        damageLabel.Text = "-"..fmt(damage).." DMG"
        comboLabel.Text = combo == 1 and "1 HIT" or (combo.." HIT COMBO")
        comboLabel.TextColor3 = combo >= 5 and C.gold or (combo >= 3 and C.pink or C.cyan)
        totalLabel.Text = "TOTAL "..fmt(sum)
        panel.Visible = true
        panel.BackgroundTransparency = 1
        panelScale.Scale = (workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize.X < 520) and 0.81 or 1
        damageLabel.TextTransparency = 0
        comboLabel.TextTransparency = 0
        totalLabel.TextTransparency = 0
        TweenService:Create(panelScale,TweenInfo.new(0.21,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{
            Scale=(workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize.X < 520) and 0.78 or 0.9
        }):Play()
        flashMarker()
        floatNumber(targetPlayer,damage,combo)

        task.delay(1.28,function()
            if serial ~= sequence or not panel.Parent then return end
            local function fade(obj,props)
                local t = TweenService:Create(obj,TweenInfo.new(0.35),props)
                table.insert(activeFades,t)
                t:Play()
            end
            for _,label in ipairs({damageLabel,comboLabel,totalLabel}) do
                fade(label,{TextTransparency=1,TextStrokeTransparency=1})
            end
            task.delay(0.38,function()
                if serial == sequence and panel.Parent then panel.Visible=false end
            end)
        end)
    end

    SettingsVisual.ShowCombatKO = function()
        if not SettingsVisual.CombatDamageFXEnabled or not hud.Parent then return end
        local ko = Instance.new("TextLabel")
        ko.Name = "CombatKO"
        ko.AnchorPoint = Vector2.new(0.5,0.5)
        ko.Position = UDim2.fromScale(0.5,0.32)
        ko.Size = UDim2.fromOffset(265,62)
        ko.BackgroundTransparency = 1
        ko.Text = "✦ K.O. ✦"
        ko.TextColor3 = C.gold
        ko.TextStrokeColor3 = C.purpleDark
        ko.TextStrokeTransparency = 0.15
        ko.TextSize = 40
        ko.Font = Enum.Font.GothamBlack
        ko.ZIndex = 22
        ko.Parent = hud
        TweenService:Create(ko,TweenInfo.new(0.75,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{
            Position=UDim2.fromScale(0.5,0.26),TextTransparency=1,TextStrokeTransparency=1
        }):Play()
        Debris:AddItem(ko,0.82)
    end

    SettingsVisual.DamageFXCleanup = function()
        SettingsVisual.CombatDamageFXEnabled = false
        if hud.Parent then hud:Destroy() end
    end
end

-- Detecta el objetivo reportado por un disparo normal. El hit SOLO se
-- muestra si tambien baja la vida observada de ese jugador.
SettingsVisual.MarkShotDamageCandidate = function(args)
    if not args or args[2] ~= "shoot_gun" then return end
    local found = nil
    local function fromPart(part)
        if typeof(part) ~= "Instance" then return nil end
        local model = part
        for _ = 1,6 do
            if not model then break end
            if model:IsA("Model") and model:FindFirstChildOfClass("Humanoid") then
                local pl = Players:GetPlayerFromCharacter(model)
                if pl and pl ~= Player then return pl end
            end
            model = model.Parent
        end
        return nil
    end
    local packet = args[5]
    if type(packet) == "table" then
        local visited = {}
        local count = 0
        local function walk(t,level)
            if found or level > 4 or visited[t] then return end
            visited[t] = true
            for k,v in pairs(t) do
                count += 1
                if count > 28 then return end
                if typeof(v) == "Instance" then
                    found = fromPart(v)
                elseif type(v) == "table" then
                    walk(v,level+1)
                end
                if found then return end
            end
        end
        walk(packet,1)
    end
    if not found and typeof(args[4]) == "CFrame" then
        pcall(function()
            local params = RaycastParams.new()
            params.FilterType = Enum.RaycastFilterType.Exclude
            params.IgnoreWater = true
            params.FilterDescendantsInstances = Player.Character and {Player.Character} or {}
            local ray = workspace:Raycast(args[4].Position,args[4].LookVector*2500,params)
            if ray then found = fromPart(ray.Instance) end
        end)
    end
    if found and not (SettingsVisual.IsSafeFriend and SettingsVisual.IsSafeFriend(found)) then
        SettingsVisual.MarkCombatTarget(found)
    end
end

SettingsVisual.MarkCombatTarget = function(targetPlayer)
	if not targetPlayer or targetPlayer == Player then return end
	local char = targetPlayer.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if not hum or hum.Health <= 0 then return end

	SettingsVisual.KillWatchData[targetPlayer] = {
		AttackStamp = os.clock(),
		Health = hum.Health,
		LastDamageStamp = nil
	}
end

SettingsVisual.AttachKillWatch = function(targetPlayer, char)
	if not targetPlayer or targetPlayer == Player or not char then return end
	local old = SettingsVisual.KillWatchConnections[targetPlayer]
	if old then
		pcall(function() if old.Health then old.Health:Disconnect() end end)
		pcall(function() if old.Died then old.Died:Disconnect() end end)
	end

	local hum = char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid", 5)
	if not hum then return end

	local healthConnection = hum.HealthChanged:Connect(function(newHealth)
		local info = SettingsVisual.KillWatchData[targetPlayer]
		if info then
			local previousHP = tonumber(info.Health) or newHealth
			local lostHP = previousHP - newHealth
			local now = os.clock()
			if lostHP > 0 then
				info.LastDamageStamp = now
				-- Registrar un HIT solo con perdida real de HP despues de
				-- un ataque reciente, nunca por el simple hecho de disparar.
				if now - (info.AttackStamp or 0) <= 1.65
					and SettingsVisual.ShowCombatDamage then
					pcall(SettingsVisual.ShowCombatDamage, targetPlayer, lostHP)
				end
			end
			info.Health = newHealth
		end
	end)

	local diedConnection = hum.Died:Connect(function()
		local info = SettingsVisual.KillWatchData[targetPlayer]
		if not info then return end
		local now = os.clock()
		-- Ventana corta: evita sonar por muertes/reinicios normales mucho después del golpe.
		if info.LastDamageStamp
			and (now - info.AttackStamp) <= 2.5
			and (now - info.LastDamageStamp) <= 0.85 then
			SettingsVisual.KillWatchData[targetPlayer] = nil
			SettingsVisual.PlayKillNotificationSound()
			if SettingsVisual.ShowCombatKO then
				pcall(SettingsVisual.ShowCombatKO)
			end
		end
	end)

	SettingsVisual.KillWatchConnections[targetPlayer] = {
		Health = healthConnection,
		Died = diedConnection
	}
end

task.spawn(function()
	for _, killWatchPlayer in ipairs(Players:GetPlayers()) do
		if killWatchPlayer ~= Player then
			if killWatchPlayer.Character then
				SettingsVisual.AttachKillWatch(killWatchPlayer, killWatchPlayer.Character)
			end
			killWatchPlayer.CharacterAdded:Connect(function(char)
				task.wait(0.15)
				SettingsVisual.AttachKillWatch(killWatchPlayer, char)
			end)
		end
	end

	Players.PlayerAdded:Connect(function(killWatchPlayer)
		if killWatchPlayer == Player then return end
		killWatchPlayer.CharacterAdded:Connect(function(char)
			task.wait(0.15)
			SettingsVisual.AttachKillWatch(killWatchPlayer, char)
		end)
	end)
end)

-- Bullet: amplía de forma moderada la tolerancia alrededor de la trayectoria real del disparo.
SettingsVisual.GetBulletAssistTarget = function(args)
	if not SettingsVisual.BulletEnabled or not args or args[2] ~= "shoot_gun" then return nil end
	local myChar = Player.Character
	local myHead = myChar and myChar:FindFirstChild("Head")
	if not myHead then return nil end

	local shotCF = args[4]
	local origin = myHead.Position
	local direction = Camera and Camera.CFrame.LookVector or myHead.CFrame.LookVector
	if typeof(shotCF) == "CFrame" then
		origin = shotCF.Position
		direction = shotCF.LookVector
	end
	if direction.Magnitude <= 0.001 then return nil end
	direction = direction.Unit

	local bestPlayer = nil
	local bestMiss = SettingsVisual.BulletRadius or 8
	for _, pl in ipairs(Players:GetPlayers()) do
		if pl ~= Player and not SettingsVisual.IsSafeFriend(pl) and pl.Character then
			local hum = pl.Character:FindFirstChildOfClass("Humanoid")
			local aimPart = pl.Character:FindFirstChild("Head") or pl.Character:FindFirstChild("UpperTorso") or pl.Character:FindFirstChild("HumanoidRootPart")
			if hum and hum.Health > 0 and aimPart then
				local offset = aimPart.Position - origin
				local forward = offset:Dot(direction)
				if forward > 0 and forward <= 2500 then
					local nearestPoint = origin + direction * forward
					local miss = (aimPart.Position - nearestPoint).Magnitude
					if miss <= bestMiss then
						bestMiss = miss
						bestPlayer = pl
					end
				end
			end
		end
	end
	return bestPlayer
end

SettingsVisual.SilentAimHookReady = false
SettingsVisual.SilentAimHookMode = "NONE"

-- Un solo procesador para hookfunction y para el fallback de __namecall.
SettingsVisual.ProcessSendArgs = function(args)
	if type(args) ~= "table" then return args end

	-- IMPORTANTE: Silent Aim NO entra aquí. Su disparo se procesa aparte,
	-- directamente en el hook, igual que CODIGOS DE(3).
	local targetToUse = nil
	local partToUse = TargetHitPart
	local isSoftAimShot = false

	if SettingsVisual.StrongAimbotEnabled
		and SettingsVisual.StrongAimbotTarget
		and args[2] == "shoot_gun" then
		targetToUse = SettingsVisual.StrongAimbotTarget
		partToUse = SoftAimMobilePart
		isSoftAimShot = true
	elseif SoftAimMobileEnabled
		and SettingsVisual.SoftAimMobileHolding
		and args[2] == "shoot_gun" then
		targetToUse = SettingsVisual.SoftAimLockedTarget
		partToUse = SoftAimMobilePart
		isSoftAimShot = true
	elseif SoftAimPCEnabled
		and SoftAimPCHolding
		and args[2] == "shoot_gun" then
		targetToUse = SettingsVisual.SoftAimLockedTarget
		partToUse = SoftAimPCPart
		isSoftAimShot = true
	end

	if not targetToUse
		and SettingsVisual.BulletEnabled
		and args[2] == "shoot_gun" then
		targetToUse = SettingsVisual.GetBulletAssistTarget(args)
		partToUse = "Head"
	end

	if targetToUse and SettingsVisual.IsSafeFriend(targetToUse) then
        targetToUse = nil
    end
	if targetToUse then
		local targetChar = targetToUse.Character
		local hitPart, offsetPos = getBypassedTargetPart(targetChar, partToUse)
		local root = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
		local myHead = Player.Character and Player.Character:FindFirstChild("Head")

		if hitPart and root and myHead then
			local startOrigin = myHead.Position
			local predPos = predictTargetPos(hitPart, root) + offsetPos
			local targetHum = targetChar and targetChar:FindFirstChildOfClass("Humanoid")
			local targetSeat = targetHum and targetHum.SeatPart

			if targetSeat then
				local vehicleAssembly = targetSeat.AssemblyRootPart or targetSeat
				local vehicleVelocity = vehicleAssembly.AssemblyLinearVelocity
				pcall(function()
					vehicleVelocity = vehicleAssembly:GetVelocityAtPosition(hitPart.Position)
				end)
				local vehicleSpeed = vehicleVelocity.Magnitude
				if vehicleSpeed > 1 then
					local speedLead = math.clamp(vehicleSpeed / 900, 0, 0.22)
					local vehicleLead = math.clamp(getPing() + 0.10 + speedLead, 0.10, 0.52)
					predPos = hitPart.Position + offsetPos + (vehicleVelocity * vehicleLead)
				else
					predPos = hitPart.Position + offsetPos
				end
			end

			local myHum = Player.Character and Player.Character:FindFirstChildOfClass("Humanoid")
			if isSoftAimShot and myHum and myHum.SeatPart then
				predPos = predPos
					+ Camera.CFrame.RightVector * (SettingsVisual.VehicleAimOffsetX / 10)
					+ Vector3.new(0, SettingsVisual.VehicleAimOffsetY / 10, 0)
			end

			CreateBulletBeam(startOrigin, predPos)
			args[4] = CFrame.new(startOrigin, predPos)
			args[5] = {
				[1] = {
					[1] = {
						Instance = hitPart,
						Normal = Vector3.new(0, 1, 0),
						Position = predPos
					}
				}
			}
		end
	end

	pcall(function()
		if args[2] == "melee_attack" and typeof(args[4]) == "table" then
			for _, combatTarget in pairs(args[4]) do
				if typeof(combatTarget) == "Instance" and combatTarget:IsA("Player") then
					SettingsVisual.MarkCombatTarget(combatTarget)
				end
			end
		elseif args[2] == "shoot_gun" then
			if targetToUse then SettingsVisual.MarkCombatTarget(targetToUse) end
			if SettingsVisual.MarkShotDamageCandidate then
				SettingsVisual.MarkShotDamageCandidate(args)
			end
		end
	end)

	return args
end

-- Multiplier Shot del script ROBADO, adaptado al contador real del RemoteEvent.
-- Cada disparo extra recibe un contador nuevo para evitar repetir el mismo event id.
SettingsVisual.SendProcessedWithMultiplier = function(originalSend, self, args)
	local result = originalSend(self, unpack(args))
	if args[2] == "shoot_gun" then
		local multiplier = math.clamp(math.floor(tonumber(SettingsVisual.ShotMultiplier) or 1), 1, 5)
		for extraIndex = 2, multiplier do
			local extraArgs = {}
			for i, value in ipairs(args) do extraArgs[i] = value end

			if RemoteCounter and type(RemoteCounter.event) == "number" and type(extraArgs[1]) == "number" then
				RemoteCounter.event = RemoteCounter.event + 1
				extraArgs[1] = RemoteCounter.event
			elseif type(extraArgs[1]) == "number" then
				extraArgs[1] = extraArgs[1] + (extraIndex - 1)
			end

			pcall(function() originalSend(self, unpack(extraArgs)) end)
		end
	end
	return result
end

-- Método 1: hookfunction (rápido cuando el executor lo soporta bien).
if SendRemote and type(hookfunction) == "function" then
	pcall(function()
		local oldFireServer
		oldFireServer = hookfunction(SendRemote.FireServer, function(self, ...)
			if self ~= SendRemote then
				return oldFireServer(self, ...)
			end

			local args = {...}

			if SilentAimEnabled and args[2] == "shoot_gun" then
				local target
				args, target = SettingsVisual.ApplySourceSilentAim(args)
				if target then
					pcall(function() SettingsVisual.MarkCombatTarget(target) end)
				end
				return oldFireServer(self, unpack(args))
			end

			args = SettingsVisual.ProcessSendArgs(args)
			return SettingsVisual.SendProcessedWithMultiplier(oldFireServer, self, args)
		end)

		if oldFireServer then
			SettingsVisual.SilentAimHookReady = true
			SettingsVisual.SilentAimHookMode = "hookfunction"
		end
	end)
end

-- Método 2: Xeno / executors donde hookfunction(RemoteEvent.FireServer)
-- no intercepta correctamente. Solo se instala si el primer método falló.
if SendRemote
	and not SettingsVisual.SilentAimHookReady
	and type(hookmetamethod) == "function"
	and type(getnamecallmethod) == "function" then

	pcall(function()
		local oldNamecall
		local callback = function(self, ...)
			local method = getnamecallmethod()

			if self == SendRemote and method == "FireServer" then
				local args = {...}

				if SilentAimEnabled and args[2] == "shoot_gun" then
					local target
					args, target = SettingsVisual.ApplySourceSilentAim(args)
					if target then
						pcall(function() SettingsVisual.MarkCombatTarget(target) end)
					end
					return oldNamecall(self, unpack(args))
				end

				args = SettingsVisual.ProcessSendArgs(args)
				return SettingsVisual.SendProcessedWithMultiplier(oldNamecall, self, args)
			end

			return oldNamecall(self, ...)
		end

		if type(newcclosure) == "function" then
			callback = newcclosure(callback)
		end

		oldNamecall = hookmetamethod(game, "__namecall", callback)

		if oldNamecall then
			SettingsVisual.SilentAimHookReady = true
			SettingsVisual.SilentAimHookMode = "hookmetamethod"
		end
	end)
end

-- Método 3: fallback clásico si el executor expone metatable cruda.
if SendRemote
	and not SettingsVisual.SilentAimHookReady
	and type(getrawmetatable) == "function"
	and type(getnamecallmethod) == "function" then

	pcall(function()
		local mt = getrawmetatable(game)
		if not mt then return end

		local oldNamecall = mt.__namecall
		if type(oldNamecall) ~= "function" then return end

		if type(setreadonly) == "function" then
			pcall(function() setreadonly(mt, false) end)
		elseif type(make_writeable) == "function" then
			pcall(function() make_writeable(mt) end)
		end

		local callback = function(self, ...)
			local method = getnamecallmethod()

			if self == SendRemote and method == "FireServer" then
				local args = {...}

				if SilentAimEnabled and args[2] == "shoot_gun" then
					local target
					args, target = SettingsVisual.ApplySourceSilentAim(args)
					if target then
						pcall(function() SettingsVisual.MarkCombatTarget(target) end)
					end
					return oldNamecall(self, unpack(args))
				end

				args = SettingsVisual.ProcessSendArgs(args)
				return SettingsVisual.SendProcessedWithMultiplier(oldNamecall, self, args)
			end

			return oldNamecall(self, ...)
		end

		if type(newcclosure) == "function" then
			callback = newcclosure(callback)
		end

		mt.__namecall = callback

		if type(setreadonly) == "function" then
			pcall(function() setreadonly(mt, true) end)
		end

		SettingsVisual.SilentAimHookReady = true
		SettingsVisual.SilentAimHookMode = "rawmetatable"
	end)
end

-- CHINO SPEED CONTINUO V2: no hay que apagar/prender el toggle
-- al restaurar el juego WalkSpeed o aplicar límites de movimiento.
-- Mantiene Inf Jump, Ghost, vehículos y velocidad vertical intactos.
SettingsVisual.ChinoSpeedOriginals = setmetatable({}, {__mode = "k"})
SettingsVisual.ChinoSpeedTarget = 30
SettingsVisual.ChinoSpeedAttributeAt = 0
SettingsVisual.ChinoSpeedRecovery = setmetatable({}, {__mode = "k"})

RunService.Heartbeat:Connect(function(dt)
    local char = Player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    local records = SettingsVisual.ChinoSpeedOriginals
    local recovery = SettingsVisual.ChinoSpeedRecovery

    if not SpeedHackEnabled then
        if records[hum] then
            local previous = records[hum]
            pcall(function()
                hum.WalkSpeed = previous.Speed
                hum:SetAttribute("TargetWalkSpeed", previous.Target)
            end)
            records[hum] = nil
        end
        recovery[hum] = nil
        return
    end

    if hum.Health <= 0 or hum.SeatPart or hum.Sit then
        recovery[hum] = nil
        return
    end
    if not records[hum] then
        records[hum] = {
            Speed = hum.WalkSpeed,
            Target = hum:GetAttribute("TargetWalkSpeed")
        }
    end
    local slider = math.clamp(tonumber(SpeedValue) or 4, 1, 20)
    local desired = math.clamp(22 + (slider - 1) * 2.8, 22, 76)
    SettingsVisual.ChinoSpeedTarget = desired

    -- La restauración ocurre continuamente, incluso después de saltar,
    -- volver de Snap Car o cambiar el estado del sprint del juego.
    if math.abs(hum.WalkSpeed - desired) > 0.12 then
        pcall(function() hum.WalkSpeed = desired end)
    end
    local now = os.clock()
    if now >= (SettingsVisual.ChinoSpeedAttributeAt or 0) then
        SettingsVisual.ChinoSpeedAttributeAt = now + 0.16
        if hum:GetAttribute("TargetWalkSpeed") ~= desired then
            pcall(function() hum:SetAttribute("TargetWalkSpeed", desired) end)
        end
    end

    -- Algunos controladores propios del juego limitan el desplazamiento
    -- incluso con WalkSpeed correcto. Detectar lentitud PERSISTENTE al
    -- correr por suelo despejado y recuperar el avance horizontal suavemente.
    -- Nunca alterar Y (Inf Jump), ni mover al jugador sentado, ni empujar
    -- contra una pared. No se ejecuta en cada frame.
    local rootPart = char:FindFirstChild("HumanoidRootPart")
    local dir = hum.MoveDirection
    local canRecover = rootPart and not rootPart.Anchored
        and dir.Magnitude > 0.60
        and hum.FloorMaterial ~= Enum.Material.Air
        and hum:GetState() ~= Enum.HumanoidStateType.Swimming
        and hum:GetState() ~= Enum.HumanoidStateType.Climbing
        and hum:GetState() ~= Enum.HumanoidStateType.Seated
        and hum:GetState() ~= Enum.HumanoidStateType.PlatformStanding
    if not canRecover then
        recovery[hum] = nil
        return
    end

    local st = recovery[hum]
    if not st then
        st = {SlowFor = 0, NextAssist = 0}
        recovery[hum] = st
    end
    local forward = Vector3.new(dir.X, 0, dir.Z)
    if forward.Magnitude < 0.3 then
        st.SlowFor = 0
        return
    end
    forward = forward.Unit
    local velocity = rootPart.AssemblyLinearVelocity
    local horizontal = Vector3.new(velocity.X, 0, velocity.Z)
    local along = horizontal:Dot(forward)
    if along < desired * 0.55 then
        st.SlowFor = math.min(2, st.SlowFor + math.clamp(dt, 0, 0.10))
    else
        st.SlowFor = math.max(0, st.SlowFor - math.clamp(dt, 0, 0.10) * 2)
    end

    if st.SlowFor >= 0.43 and now >= st.NextAssist then
        st.NextAssist = now + 0.14
        -- Si hay pared, vehículo u objeto delante, no forzar velocidad.
        local params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Exclude
        params.FilterDescendantsInstances = {char}
        params.IgnoreWater = true
        local ahead = workspace:Raycast(
            rootPart.Position + Vector3.new(0, 1.3, 0),
            forward * 3.5, params
        )
        if not (ahead and ahead.Instance and ahead.Instance.CanCollide) then
            pcall(function()
                local newHorizontal = horizontal:Lerp(forward * desired * 0.90, 0.42)
                local maxHorizontal = desired * 1.05
                if newHorizontal.Magnitude > maxHorizontal then
                    newHorizontal = newHorizontal.Unit * maxHorizontal
                end
                rootPart.AssemblyLinearVelocity = Vector3.new(
                    newHorizontal.X, velocity.Y, newHorizontal.Z
                )
            end)
        end
    end
end)

local function ensurePlayerESP(pl)
	if pl == Player then return end
	local char = pl.Character
	if not char then return end
	local head = char:FindFirstChild("Head") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") or char:FindFirstChildWhichIsA("BasePart")
	local root = char:FindFirstChild("HumanoidRootPart") or char.PrimaryPart or head or char:FindFirstChildWhichIsA("BasePart")
	local hum = char:FindFirstChildOfClass("Humanoid")
	if not root or not hum then return end
	head = head or root

	if not PlayerBillboards[pl] or not PlayerBillboards[pl].Billboard or not PlayerBillboards[pl].Billboard.Parent or not PlayerBillboards[pl].Name or not PlayerBillboards[pl].Health or not PlayerBillboards[pl].HealthFill or not PlayerBillboards[pl].Dist then
		if PlayerBillboards[pl] and PlayerBillboards[pl].Billboard then
			pcall(function() PlayerBillboards[pl].Billboard:Destroy() end)
		end
		local bb = Instance.new("BillboardGui", PlayerGui)
		bb.Name = "ESP_Scan_" .. pl.Name
		bb.Adornee = root
		bb.Size = UDim2.new(0, 160, 0, 45)
		bb.StudsOffset = Vector3.new(0, 3.2, 0)
		bb.AlwaysOnTop = true
		bb.MaxDistance = SettingsVisual.ESPMaxRenderDistance or 1000000
		bb.LightInfluence = 0

		local container = Instance.new("Frame", bb)
		container.Size = UDim2.new(1, 0, 1, 0)
		container.BackgroundTransparency = 1

		local nLbl = Instance.new("TextLabel", container)
		nLbl.Size = UDim2.new(1, 0, 0, 12)
		nLbl.BackgroundTransparency = 1
		nLbl.Text = pl.Name
		nLbl.TextColor3 = Color3.fromRGB(0, 0, 0)
		nLbl.TextSize = 10
		nLbl.Font = Enum.Font.GothamMedium

		-- ESP Vida en barra (sin texto).
		local hLbl = Instance.new("Frame", container)
		hLbl.Name = "HealthBarBack"
		hLbl.Size = UDim2.new(0, 62, 0, 5)
		hLbl.Position = UDim2.new(0.5, -31, 0, 15)
		hLbl.BackgroundColor3 = Color3.fromRGB(12, 14, 20)
		hLbl.BackgroundTransparency = 0.10
		hLbl.BorderSizePixel = 0
		Instance.new("UICorner", hLbl).CornerRadius = UDim.new(1, 0)
		local healthStroke = Instance.new("UIStroke", hLbl)
		healthStroke.Color = Color3.fromRGB(0, 0, 0)
		healthStroke.Transparency = 0.08
		healthStroke.Thickness = 1.15
		healthStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

		local hFill = Instance.new("Frame", hLbl)
		hFill.Name = "Fill"
		hFill.Size = UDim2.new(1, 0, 1, 0)
		hFill.BackgroundColor3 = Color3.fromRGB(58, 205, 102)
		hFill.BorderSizePixel = 0
		Instance.new("UICorner", hFill).CornerRadius = UDim.new(1, 0)

		-- Acabado 3D: parte superior brillante y base mas profunda.
		local hGradient = Instance.new("UIGradient", hFill)
		hGradient.Rotation = 90
		hGradient.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(145, 255, 175)),
			ColorSequenceKeypoint.new(0.42, Color3.fromRGB(70, 225, 115)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(24, 120, 62))
		})
		local hInnerStroke = Instance.new("UIStroke", hFill)
		hInnerStroke.Color = Color3.fromRGB(0, 0, 0)
		hInnerStroke.Transparency = 0.35
		hInnerStroke.Thickness = 0.65

		local dLbl = Instance.new("TextLabel", container)
		dLbl.Size = UDim2.new(1, 0, 0, 12)
		dLbl.Position = UDim2.new(0, 0, 0, 25)
		dLbl.BackgroundTransparency = 1
		dLbl.TextColor3 = Color3.fromRGB(240, 240, 245)
		dLbl.TextSize = 9
		dLbl.Font = Enum.Font.GothamMedium

		PlayerBillboards[pl] = {Billboard = bb, Name = nLbl, Health = hLbl, HealthFill = hFill, HealthGradient = hGradient, Dist = dLbl}
	end
end

-- ESP ARMAS clásico: imágenes originales de las armas, no iconos de reserva,
-- no paneles de memoria «V», ni consumibles/objetos del ESP Ítems.
-- La exploración de Backpack ocurre cuando los Tools se replican públicamente.
task.spawn(function()
    while true do
        task.wait(0.12)
        if WeaponESPEnabled and type(SettingsVisual.GetChinoPublicWeaponScan)=="function" then
            for _, pl in ipairs(Players:GetPlayers()) do
                if pl~=Player and pl.Character then
                    local char=pl.Character
                    local root=char:FindFirstChild("HumanoidRootPart") or char.PrimaryPart
                        or char:FindFirstChildWhichIsA("BasePart")
                    if root then
                        local display={}
                        local fingerprint={}
                        -- El escáner solo muestra armas verdaderas presentes,
                        -- sin accesorios, puños, baúl no replicado ni cosas «vistas».
                        for _, info in ipairs(SettingsVisual.GetChinoPublicWeaponScan(pl)) do
                            if info.IsGun and info.Current then
                                local image=ChinoNormalizarIcono(info.ImageId)
                                if image then
                                    table.insert(display, {Icon=image, Rarity=info.Rarity})
                                    table.insert(fingerprint, image..":"..tostring(info.Rarity))
                                end
                            end
                        end
                        local token=table.concat(fingerprint,"|")
                        local bg=WeaponBillboardCache[pl]
                        if not bg or not bg.Parent or bg.Adornee~=root then
                            if bg then pcall(function() bg:Destroy() end) end
                            bg=Instance.new("BillboardGui", PlayerGui)
                            bg.Name="WeaponESP_"..pl.Name
                            bg.Adornee=root
                            bg.Size=UDim2.new(0,140,0,18)
                            bg.StudsOffset=Vector3.new(0,8,0)
                            bg.AlwaysOnTop=true
                            bg.MaxDistance=SettingsVisual.ESPMaxRenderDistance or 1000000
                            bg.LightInfluence=0
                            WeaponBillboardCache[pl]=bg
                            WeaponCacheTokens[pl]=nil
                        end
                        if WeaponCacheTokens[pl]~=token then
                            WeaponCacheTokens[pl]=token
                            bg:ClearAllChildren()
                            local layout=Instance.new("UIListLayout",bg)
                            layout.FillDirection=Enum.FillDirection.Horizontal
                            layout.HorizontalAlignment=Enum.HorizontalAlignment.Center
                            layout.Padding=UDim.new(0,4)
                            for i=1,math.min(#display,8) do
                                local item=display[i]
                                local icon=Instance.new("ImageLabel",bg)
                                icon.Size=UDim2.fromOffset(16,16)
                                icon.BackgroundTransparency=1
                                icon.Image=item.Icon
                                icon.ScaleType=Enum.ScaleType.Fit
                                Instance.new("UICorner",icon).CornerRadius=UDim.new(0,6)
                                local border=Instance.new("UIStroke",icon)
                                border.Color=RarityColors[item.Rarity] or Color3.fromRGB(255,255,255)
                                border.Thickness=1.5
                            end
                        end
                    end
                end
            end
        else
            for _,bb in pairs(WeaponBillboardCache) do
                pcall(function() bb:Destroy() end)
            end
            WeaponBillboardCache={}
            WeaponCacheTokens={}
        end
    end
end)

-- INTEGRACIÓN DE AUTO PICKUP USANDO EL SISTEMA DEL SEGUNDO SCRIPT (NetGet)
local function CheckAndPickupFromSecondScript()
	if not ak then return end
	local myRoot = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
	if not DroppedItems or not myRoot then return end
	
	local currentTime = tick()
	local itemsToPickup = {}
	
	for _, itemModel in ipairs(DroppedItems:GetChildren()) do
		if itemModel:IsA("Model") then
			local zone = itemModel:FindFirstChildWhichIsA("BasePart") or itemModel:FindFirstChild("PickUpZone")
			if zone then
				local dist = (myRoot.Position - zone.Position).Magnitude
				if dist <= AutoPickupRadius and (currentTime - (al[itemModel] or 0)) >= (SettingsVisual.NetworkPickupCooldown or 0.25) then
					table.insert(itemsToPickup, itemModel)
					al[itemModel] = currentTime
					if #itemsToPickup >= (SettingsVisual.NetworkPickupBatch or 6) then break end
				end
			end
		end
	end
	
	if #itemsToPickup > 0 then
		for _, itemModel in ipairs(itemsToPickup) do
			task.spawn(function()
				NetGet("pickup_dropped_item", itemModel)
			end)
		end
	end
end

--============================================================--
-- CHINOINFIERNO V3 | MELEE AURA + AUTO ATTACK ADAPTADOS DE NGU4
-- Reutiliza los toggles existentes de MISC. No crea otra interfaz.
-- NGU4 Melee Aura: atributos alfabeticos 6 y 7 -> 360 / 20.
-- NGU4 Auto Attack: arma melee equipada, 20 studs, cada 0.40 s,
--    protocolo melee_attack con CFrame predictivo y argumento 0.75.
-- Emplea FireServerHook ya presente, sin contador remoto duplicado.
--============================================================--
do
    local ng4 = {
        AuraEnabled = false,
        AutoEnabled = false,
        OriginalAttributes = setmetatable({}, {__mode = "k"}),
    }
    SettingsVisual.NGU4Melee = ng4

    local function isMeleeTool(tool)
        if not tool or not tool:IsA("Tool") then return false end
        if tool.Name == "Fists" then return true end
        local items = ReplicatedStorage:FindFirstChild("Items")
        local meleeFolder = items and items:FindFirstChild("melee")
        return meleeFolder ~= nil and meleeFolder:FindFirstChild(tool.Name) ~= nil
    end

    local function modifyTool(tool)
        if not ng4.AuraEnabled or not isMeleeTool(tool) then return end
        local record = ng4.OriginalAttributes[tool]
        if not record then
            local attributeNames = {}
            for name in pairs(tool:GetAttributes()) do
                table.insert(attributeNames, name)
            end
            table.sort(attributeNames)
            if #attributeNames < 7 then return end
            local key6, key7 = attributeNames[6], attributeNames[7]
            if type(tool:GetAttribute(key6)) ~= "number"
                or type(tool:GetAttribute(key7)) ~= "number" then
                return -- Evita convertir atributos no numericos.
            end
            record = {
                Name6 = key6, Name7 = key7,
                Original6 = tool:GetAttribute(key6),
                Original7 = tool:GetAttribute(key7),
            }
            ng4.OriginalAttributes[tool] = record
        end
        pcall(function()
            tool:SetAttribute(record.Name6, 360)
            tool:SetAttribute(record.Name7, 20)
        end)
    end

    local function forEachMelee(callback)
        local backpack = Player:FindFirstChildOfClass("Backpack")
        for _, container in ipairs({Player.Character, backpack}) do
            if container then
                for _, child in ipairs(container:GetChildren()) do
                    if isMeleeTool(child) then callback(child) end
                end
            end
        end
    end

    local function restoreAura()
        for tool, data in pairs(ng4.OriginalAttributes) do
            if tool and tool.Parent then
                pcall(function()
                    if tool:GetAttribute(data.Name6) == 360 then
                        tool:SetAttribute(data.Name6, data.Original6)
                    end
                    if tool:GetAttribute(data.Name7) == 20 then
                        tool:SetAttribute(data.Name7, data.Original7)
                    end
                end)
            end
            ng4.OriginalAttributes[tool] = nil
        end
    end

    function ng4.SetAura(enabled)
        ng4.AuraEnabled = enabled == true
        MeleeAuraEnabled = ng4.AuraEnabled
        if ng4.AuraEnabled then
            forEachMelee(modifyTool)
        else
            restoreAura()
        end
    end

    function ng4.SetAuto(enabled)
        ng4.AutoEnabled = enabled == true
        AutoAttackEnabled = ng4.AutoEnabled
    end

    local function attackNearby()
        if not ng4.AutoEnabled or not SendRemote then return end
        local character = Player.Character
        local root = character and character:FindFirstChild("HumanoidRootPart")
        if not root then return end
        local equipped
        for _, child in ipairs(character:GetChildren()) do
            if isMeleeTool(child) then
                equipped = child
                break
            end
        end
        if not equipped then return end

        local targets = {}
        local aimPosition
        local ping = math.clamp(getPing(), 0, 2)
        for _, targetPlayer in ipairs(Players:GetPlayers()) do
            if targetPlayer ~= Player and targetPlayer.Character then
                local targetChar = targetPlayer.Character
                local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
                local targetHead = targetChar:FindFirstChild("Head")
                local targetHum = targetChar:FindFirstChildOfClass("Humanoid")
                if targetRoot and targetHead and targetHum and targetHum.Health > 0
                    and (root.Position - targetRoot.Position).Magnitude <= 20 then
                    table.insert(targets, targetPlayer)
                    if not aimPosition then
                        aimPosition = targetHead.Position
                            + targetRoot.AssemblyLinearVelocity * ping
                    end
                end
            end
        end
        if #targets == 0 or not aimPosition then return end
        if (aimPosition - root.Position).Magnitude < 0.001 then
            aimPosition = root.Position + root.CFrame.LookVector
        end
        FireServerHook("melee_attack", equipped, targets,
            CFrame.lookAt(root.Position, aimPosition), 0.75)
    end

    task.spawn(function()
        while Gui and Gui.Parent do
            task.wait(0.35)
            if ng4.AuraEnabled then
                pcall(function() forEachMelee(modifyTool) end)
            end
        end
        restoreAura()
    end)
    task.spawn(function()
        while Gui and Gui.Parent do
            task.wait(0.40)
            if ng4.AutoEnabled then pcall(attackNearby) end
        end
    end)
end

SettingsVisual.PerfMainFrameTimer = 0
RunService.RenderStepped:Connect(function(dt)
	-- Rendimiento movil: este bloque contiene busquedas de jugadores, ESP, items y raycasts.
	-- Frecuencia adaptativa: 24 Hz en touch/móvil y 30 Hz en PC para bajar carga sin perder respuesta.
	SettingsVisual.PerfMainFrameTimer = (SettingsVisual.PerfMainFrameTimer or 0) + dt
	local targetVisualHz = UserInputService.TouchEnabled
		and (SettingsVisual.NetworkMobileVisualHz or 20)
		or (SettingsVisual.NetworkPCVisualHz or 30)
    -- Priorizar la suavidad del render solo si cae el FPS medido en Gama Alta.
    -- Los visuales modernos (BOX/LINE/HP/Target Line) siguen cada frame.
    if SettingsVisual.PerformanceMode == "High" then
        targetVisualHz = targetVisualHz * (SettingsVisual.HighFluidityScanFactor or 1)
    end
	if SettingsVisual.PerfMainFrameTimer < (1 / math.max(10, targetVisualHz)) then return end
	dt = SettingsVisual.PerfMainFrameTimer
	SettingsVisual.PerfMainFrameTimer = 0

	if SilentAimEnabled then
		CurrentLockedTarget = SettingsVisual.SourceSilentTarget
			or SettingsVisual.GetSourceSilentTarget()
	else
		CurrentLockedTarget = nil
	end

	-- Target compartido:
	-- Silent Aim ON  -> línea usa EXACTAMENTE CurrentLockedTarget.
	-- Silent Aim OFF -> línea conserva selector visual propio, sin offsets/calibrador.
	if SettingsVisual.TargetLine then
		CurrentTarget = SilentAimEnabled
			and CurrentLockedTarget
			or SettingsVisual.GetDirectVisualTarget(SettingsVisual.FOVRadius)
	else
		CurrentTarget = nil
	end
    if SettingsVisual.IsSafeFriend(CurrentTarget) then CurrentTarget = nil end

	local activeFOV = false
	local activeFOVRadius = 150
	if SettingsVisual.FOV then
		activeFOV = true
		activeFOVRadius = SettingsVisual.FOVRadius
	elseif SoftAimMobileFOV and SoftAimMobileEnabled then
		activeFOV = true
		activeFOVRadius = SoftAimMobileFOVRadius
	elseif SoftAimPCFOV and SoftAimPCEnabled then
		activeFOV = true
		activeFOVRadius = SoftAimPCFOVRadius
	end

	if activeFOV and not SettingsVisual.PanelIsOpen then
		FOVCircle.Visible = true
		FOVCircle.Size = UDim2.fromOffset(activeFOVRadius * 2, activeFOVRadius * 2)
	else
		FOVCircle.Visible = false
	end

	-- Target Line / octagono / flecha se dibujan en un RenderStepped visual ligero
	-- más abajo. Así no dependen del límite 24/30 Hz del bloque pesado.

    -- La velocidad se controla en Heartbeat independiente (más abajo).
    -- No recalcular aquí: RenderStepped visual tiene límite de FPS móvil.

	pcall(CheckAndPickupFromSecondScript)

	-- Skip Cajas V2 trabaja con su propio controlador (Farm), no en este loop por frame.

	local myRoot = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
	if ItemESPEnabled and DroppedItems and myRoot then
		local closestPerName = {}
		for _, model in ipairs(DroppedItems:GetChildren()) do
			if model:IsA("Model") and model:FindFirstChild("PickUpZone") then
				local zone = model.PickUpZone
				local dist = (zone.Position - myRoot.Position).Magnitude
				local itemName = model.Name
				if not closestPerName[itemName] or dist < closestPerName[itemName].dist then
					closestPerName[itemName] = {model = model, dist = dist, zone = zone}
				end
			end
		end

		for _, data in pairs(ItemDrawingsCache) do
			if data.Billboard then data.Billboard.Enabled = false end
			if data.Highlight then data.Highlight.Enabled = false end
		end

		for name, info in pairs(closestPerName) do
			local model = info.model
			local zone = info.zone
			local dist = info.dist
			local itemData = ItemDrawingsCache[model]
			if not itemData then
				local bb = Instance.new("BillboardGui", PlayerGui)
				bb.Name = "ItemESP_" .. name
				bb.Adornee = zone
				bb.Size = UDim2.new(0, 120, 0, 35)
				bb.StudsOffset = Vector3.new(0, 1.5, 0)
				bb.AlwaysOnTop = true
				bb.MaxDistance = SettingsVisual.ESPMaxRenderDistance or 1000000
				bb.LightInfluence = 0

				local label = Instance.new("TextLabel", bb)
				label.Size = UDim2.new(1, 0, 0, 18)
				label.BackgroundTransparency = 1
				label.Text = name
				label.TextColor3 = RarityColors[model:GetAttribute("RarityName")] or Color3.fromRGB(255, 255, 255)
				label.TextStrokeTransparency = 0.2
				label.TextSize = 12
				label.Font = Enum.Font.GothamBold

				local distLbl = Instance.new("TextLabel", bb)
				distLbl.Name = "DistLbl"
				distLbl.Size = UDim2.new(1, 0, 0, 16)
				distLbl.Position = UDim2.new(0, 0, 0, 16)
				distLbl.BackgroundTransparency = 1
				distLbl.TextColor3 = Color3.fromRGB(230, 230, 240)
				distLbl.TextSize = 11
				distLbl.Font = Enum.Font.Gotham

				local hl = Instance.new("Highlight")
				hl.Adornee = model
				hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
				hl.Parent = model
				hl.FillTransparency = 0.6
				hl.OutlineTransparency = 0.2
				hl.FillColor = label.TextColor3
				
				itemData = {Billboard = bb, DistLabel = distLbl, Highlight = hl}
				ItemDrawingsCache[model] = itemData
			end
			if dist <= (SettingsVisual.ESPMaxRenderDistance or 1000000) then
				itemData.Billboard.Enabled = true
				itemData.Highlight.Enabled = true
				if itemData.DistLabel then
					itemData.DistLabel.Text = string.format("%.0f m", dist * 0.28)
				end
			end
		end
	else
		for _, v in pairs(ItemDrawingsCache) do
			if v.Billboard then v.Billboard.Enabled = false end
			if v.Highlight then v.Highlight.Enabled = false end
		end
	end

	-- Melee Aura y Auto Attack NGU4 se ejecutan en sus bucles dedicados.
	-- RenderStepped se reserva para visuales; evita spam de melee_attack.

	local anyPlayerESPEnabled = PlayerESP_Name
		or PlayerESP_Dist
		or PlayerESP_Highlight

	if anyPlayerESPEnabled then
		SettingsVisual.PerfPlayerESPWasActive = true
	for _, pl in ipairs(Players:GetPlayers()) do
			if pl ~= Player then
			ensurePlayerESP(pl)
			local targetChar = pl.Character
			local root = targetChar and (targetChar:FindFirstChild("HumanoidRootPart") or targetChar.PrimaryPart or targetChar:FindFirstChildWhichIsA("BasePart"))
			local head = targetChar and (targetChar:FindFirstChild("Head") or targetChar:FindFirstChild("UpperTorso") or targetChar:FindFirstChild("Torso")) or root
			local hum = targetChar and targetChar:FindFirstChildOfClass("Humanoid")
			local vObj = VisualPlayerObjects[pl]
			if not vObj or not vObj.Box or not vObj.Box.Parent then
				CreateVisualPlayerObjects(pl)
				vObj = VisualPlayerObjects[pl]
			end

			if targetChar and root and hum then
				-- SelectionBox viejo desactivado: el Box nuevo es 2D y se renderiza por frame.
				if vObj and vObj.Box then
					vObj.Box.Visible = false
				end

				local data = PlayerBillboards[pl]
				local dist = myRoot and (root.Position - myRoot.Position).Magnitude or 0
				if data and data.Billboard then
					data.Billboard.Adornee = root
					data.Billboard.MaxDistance = SettingsVisual.ESPMaxRenderDistance or 1000000
					data.Billboard.AlwaysOnTop = true
					data.Billboard.Enabled = true
					data.Name.Visible = PlayerESP_Name
					-- La vida horizontal vieja queda apagada; usamos la barra vertical nueva.
					data.Health.Visible = false
					data.Dist.Visible = PlayerESP_Dist

					if false and data.HealthFill then
						local healthRatio = hum.MaxHealth > 0 and math.clamp(hum.Health / hum.MaxHealth, 0, 1) or 0
						data.HealthFill.Size = UDim2.new(healthRatio, 0, 1, 0)
						if healthRatio > 0.60 then
							data.HealthFill.BackgroundColor3 = Color3.fromRGB(58, 205, 102)
							if data.HealthGradient then
								data.HealthGradient.Color = ColorSequence.new({
									ColorSequenceKeypoint.new(0, Color3.fromRGB(145, 255, 175)),
									ColorSequenceKeypoint.new(0.42, Color3.fromRGB(70, 225, 115)),
									ColorSequenceKeypoint.new(1, Color3.fromRGB(24, 120, 62))
								})
							end
						elseif healthRatio > 0.30 then
							data.HealthFill.BackgroundColor3 = Color3.fromRGB(235, 169, 38)
							if data.HealthGradient then
								data.HealthGradient.Color = ColorSequence.new({
									ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 235, 125)),
									ColorSequenceKeypoint.new(0.42, Color3.fromRGB(255, 195, 55)),
									ColorSequenceKeypoint.new(1, Color3.fromRGB(165, 96, 18))
								})
							end
						else
							data.HealthFill.BackgroundColor3 = Color3.fromRGB(220, 48, 48)
							if data.HealthGradient then
								data.HealthGradient.Color = ColorSequence.new({
									ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 150, 150)),
									ColorSequenceKeypoint.new(0.42, Color3.fromRGB(255, 70, 70)),
									ColorSequenceKeypoint.new(1, Color3.fromRGB(125, 20, 20))
								})
							end
						end
					end
					if PlayerESP_Dist then
						data.Dist.Text = string.format("%.0f m", dist * 0.28)
					end
				end

				local hl = HighlightCache[pl]
				if PlayerESP_Highlight and not SettingsVisual.IsSafeFriend(pl) then
					if not hl or not hl.Parent then
						hl = Instance.new("Highlight")
						hl.Name = "CHINO_ESP_Highlight"
						hl.Adornee = targetChar
						hl.FillColor = Color3.fromRGB(135, 150, 255)
						hl.FillTransparency = 0.5
						hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
						hl.Parent = targetChar
						HighlightCache[pl] = hl
					end
					hl.Enabled = true
					hl.Adornee = targetChar
				else
					if hl then hl.Enabled = false end
				end
			else
				if vObj and vObj.Box then vObj.Box.Visible = false end
				if PlayerBillboards[pl] and PlayerBillboards[pl].Billboard then PlayerBillboards[pl].Billboard.Enabled = false end
				if HighlightCache[pl] then HighlightCache[pl].Enabled = false end
			end
		end
	end
	elseif SettingsVisual.PerfPlayerESPWasActive ~= false then
		-- Al quedar todo el ESP de jugadores apagado, ocultamos una sola vez y dejamos de escanearlos.
		for pl, vObj in pairs(VisualPlayerObjects) do
			if vObj and vObj.Box then vObj.Box.Visible = false end
			local data = PlayerBillboards[pl]
			if data and data.Billboard then data.Billboard.Enabled = false end
			local hl = HighlightCache[pl]
			if hl then hl.Enabled = false end
		end
		SettingsVisual.PerfPlayerESPWasActive = false
	end
end)

--========================================================--
-- GAMA ALTA FLUIDA: listado cacheado de jugadores (actualizado al entrar/salir).
-- Evita crear una tabla nueva de todos los jugadores en cada fotograma.
-- No oculta jugadores ni altera qué ESP se dibuja.
--========================================================--
do
    SettingsVisual.HighFluidityPlayers = Players:GetPlayers()
    Players.PlayerAdded:Connect(function(pl)
        local list = SettingsVisual.HighFluidityPlayers
        if not table.find(list, pl) then
            list[#list + 1] = pl
        end
    end)
    Players.PlayerRemoving:Connect(function(pl)
        local list = SettingsVisual.HighFluidityPlayers
        local i = table.find(list, pl)
        if i then table.remove(list, i) end
    end)
end

--========================================================--
-- VISUAL PASS FULL-FRAME
-- Box / Lines / Health + Target Line / Octagono / Flecha.
-- No hace lógica pesada de armas, items, vehículos ni red.
--========================================================--
RunService.RenderStepped:Connect(function(dt)
	Camera = workspace.CurrentCamera
	if not Camera then
		SettingsVisual.HideNewTargetVisuals()
		for _, data in pairs(SettingsVisual.ModernESPObjects) do
			SettingsVisual.HideModernESP(data)
		end
		return
	end

	local viewport = Camera.ViewportSize
	local tracerFrom = Vector2.new(viewport.X / 2, viewport.Y - 2)
	local anyModernESP = PlayerESP_Box or SettingsVisual.PlayerESP_Lines or PlayerESP_Health

    -- Sin ESP moderno habilitado, ocultar una sola vez. Target Line sigue vivo.
    if anyModernESP then
        SettingsVisual.HighFluidityModernESPWasActive = true
        local renderPlayers = (SettingsVisual.PerformanceMode == "High"
            and SettingsVisual.HighFluidityPlayers) or Players:GetPlayers()
	for _, pl in ipairs(renderPlayers) do
		if pl ~= Player then
			local data = SettingsVisual.EnsureModernESP(pl)
			local char = pl.Character
			local hum = char and char:FindFirstChildOfClass("Humanoid")
			local root = char and (char:FindFirstChild("HumanoidRootPart") or char.PrimaryPart or char:FindFirstChildWhichIsA("BasePart"))

			if anyModernESP and data and char and hum and hum.Health > 0 and root then
				local rootScreen, onScreen = Camera:WorldToViewportPoint(root.Position)
				local projectedBounds = SettingsVisual.GetProjectedCharacterBounds(char)

				if onScreen and rootScreen.Z > 0 and projectedBounds then
					local height = projectedBounds.Height
					local width = projectedBounds.Width
					local centerX = projectedBounds.Center.X
					local topY = projectedBounds.Top
					local visualPart = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") or root
					local visible = SettingsVisual.IsDirectVisualTargetVisible(char, visualPart)
					local visualColor = visible and SettingsVisual.TargetVisibleColor or SettingsVisual.TargetHiddenColor

					if PlayerESP_Box and data.Box and data.BoxStroke then
						data.Box.Position = UDim2.fromOffset(
							centerX - (width / 2) + (SettingsVisual.BoxOffsetX or 0),
							topY + (SettingsVisual.BoxOffsetY or 0)
						)
						data.Box.Size = UDim2.fromOffset(width, height)
						data.BoxStroke.Color = visualColor
						data.Box.Visible = true
					elseif data.Box then
						data.Box.Visible = false
					end

					if SettingsVisual.PlayerESP_Lines and data.Tracer then
						local toPoint = Vector2.new(
							projectedBounds.Center.X + (SettingsVisual.LinesOffsetX or 0),
							projectedBounds.Center.Y + (SettingsVisual.LinesOffsetY or 0)
						)
						local delta = toPoint - tracerFrom
						local lineDistance = delta.Magnitude
						local lineMid = (tracerFrom + toPoint) / 2
						data.Tracer.Position = UDim2.fromOffset(lineMid.X, lineMid.Y)
						data.Tracer.Size = UDim2.fromOffset(lineDistance, 1)
						data.Tracer.Rotation = math.deg(math.atan2(delta.Y, delta.X))
						data.Tracer.BackgroundColor3 = visualColor
						data.Tracer.Visible = true
					elseif data.Tracer then
						data.Tracer.Visible = false
					end

					if PlayerESP_Health and data.HealthOutline and data.HealthBar and data.HealthText then
						local barHeight = math.clamp(height * 0.72, 20, 65)
						local barWidth = 4
						local barX =
							centerX
							- (width / 2)
							- 10
							+ (SettingsVisual.BoxOffsetX or 0)
							+ (SettingsVisual.HealthOffsetX or 0)
						local barY =
							topY
							+ (SettingsVisual.BoxOffsetY or 0)
							+ (SettingsVisual.HealthOffsetY or 0)
						local maxHealth = hum.MaxHealth > 0 and hum.MaxHealth or 100
						local hpPercent = math.clamp(hum.Health / maxHealth, 0, 1)
						local fillHeight = math.max(2, barHeight * hpPercent)

						data.HealthOutline.Position = UDim2.fromOffset(barX - 1, barY - 1)
						data.HealthOutline.Size = UDim2.fromOffset(barWidth + 2, barHeight + 2)
						data.HealthOutline.Visible = true

						data.HealthBar.Position = UDim2.fromOffset(barX, barY + (barHeight - fillHeight))
						data.HealthBar.Size = UDim2.fromOffset(barWidth, fillHeight)
						data.HealthBar.BackgroundColor3 = Color3.fromHSV(hpPercent * 0.33, 1, 1)
						data.HealthBar.Visible = true

						data.HealthText.Text = tostring(math.floor(hum.Health))
						data.HealthText.Position = UDim2.fromOffset(barX + (barWidth / 2), barY + barHeight + 10)
						data.HealthText.Visible = true
					else
						if data.HealthOutline then data.HealthOutline.Visible = false end
						if data.HealthBar then data.HealthBar.Visible = false end
						if data.HealthText then data.HealthText.Visible = false end
					end
				else
					SettingsVisual.HideModernESP(data)
				end
			else
				SettingsVisual.HideModernESP(data)
			end
		end
	end
    elseif SettingsVisual.HighFluidityModernESPWasActive ~= false then
        SettingsVisual.HighFluidityModernESPWasActive = false
        for _, data in pairs(SettingsVisual.ModernESPObjects) do
            SettingsVisual.HideModernESP(data)
        end
    end

	-- Un solo objetivo por fotograma: TARGET LINE y SILENT AIM coinciden.
	local visualTarget = SettingsVisual.TargetLine and CurrentTarget or nil
    if SettingsVisual.IsSafeFriend(visualTarget) then visualTarget = nil end

    -- Los objetivos lejanos no se ocultan por estar detrás de paredes.
    -- La línea es VERDE si hay visión y ROJA si está detrás de barreras.
	if Gui.Enabled and SettingsVisual.TargetLine and visualTarget and visualTarget.Character and Player.Character then
		local myHead = Player.Character:FindFirstChild("Head") or Player.Character:FindFirstChild("HumanoidRootPart")
		local targetChar = visualTarget.Character
		local targetPart, targetOffset = getBypassedTargetPart(targetChar, TargetHitPart)
		if not targetPart then
			targetPart = targetChar:FindFirstChild("UpperTorso") or targetChar:FindFirstChild("Torso") or targetChar:FindFirstChild("HumanoidRootPart") or targetChar:FindFirstChild("Head")
			targetOffset = Vector3.zero
		end

		if myHead and targetPart then
			local from3, fromOnScreen = Camera:WorldToViewportPoint(myHead.Position)
			local to3, toOnScreen = Camera:WorldToViewportPoint(targetPart.Position + targetOffset)
			local targetBounds = SettingsVisual.GetProjectedCharacterBounds(targetChar)

			if toOnScreen and to3.Z > 0 and targetBounds then
				local from = (fromOnScreen and from3.Z > 0)
					and Vector2.new(
						from3.X + (SettingsVisual.TargetLineStartXOffset or 0),
						from3.Y + (SettingsVisual.TargetLineStartYOffset or 0)
					)
					or Vector2.new(
						(viewport.X / 2) + (SettingsVisual.TargetLineStartXOffset or 0),
						(viewport.Y / 2) + (SettingsVisual.TargetLineStartYOffset or 0)
					)

				-- Punto FINAL visual: centro exacto del Box (zona pecho/torso).
				-- Usa los mismos offsets del Box para que ambos coincidan siempre,
				-- incluso cuando el enemigo está lejos o cambia de distancia.
				local to = Vector2.new(
					targetBounds.Center.X + (SettingsVisual.BoxOffsetX or 0),
					targetBounds.Center.Y + (SettingsVisual.BoxOffsetY or 0)
				)

				local diff = to - from
				local len = diff.Magnitude
				if len > 0.001 then
					TargetLine.Position = UDim2.fromOffset((from.X + to.X) / 2, (from.Y + to.Y) / 2)
					TargetLine.Size = UDim2.fromOffset(len, SettingsVisual.TargetLineThickness)
					TargetLine.Rotation = math.deg(math.atan2(diff.Y, diff.X))
					TargetLine.Visible = true
				else
					TargetLine.Visible = false
				end

				SettingsVisual.TargetOctagon.Position = UDim2.fromOffset(to.X, to.Y)
				SettingsVisual.TargetOctagon.Visible = true
				SettingsVisual.TargetArrow.Adornee = targetChar:FindFirstChild("Head") or targetPart
				SettingsVisual.TargetArrow.Enabled = SettingsVisual.TargetArrow.Adornee ~= nil

				local targetVisible = SettingsVisual.IsDirectVisualTargetVisible(targetChar, targetPart)
				SettingsVisual.SetNewTargetColor(targetVisible)
				SettingsVisual.AnimateNewTargetFX(dt)
			else
				SettingsVisual.HideNewTargetVisuals()
			end
		else
			SettingsVisual.HideNewTargetVisuals()
		end
	else
		SettingsVisual.HideNewTargetVisuals()
	end
end)

-- CHINO HOLD JUMP (Player): un salto inicial alto y ascenso sostenido
-- ÚNICAMENTE mientras se mantiene pulsado el botón de salto.
-- Al soltar, se corta el empuje vertical y la gravedad lo hace caer.
-- Compatible con barra espaciadora, mando y JumpButton móvil.
SettingsVisual.HoldJumpState = {
    HeldKeyboard=false, HeldGamepad=false, HeldTouch=nil,
    LastRequest=0, Active=false, JumpButton=nil, NextFind=0,
    AscendVelocity=36, InitialImpulse=48, InitialHoldSeconds=0.20,
    BeganAt=0, Ascending=false,
}

SettingsVisual.GetMobileJumpButton = function()
    local st=SettingsVisual.HoldJumpState
    local now=os.clock()
    if st.JumpButton and st.JumpButton.Parent then return st.JumpButton end
    if now<(st.NextFind or 0) then return nil end
    st.NextFind=now+1.0
    local gui=PlayerGui and PlayerGui:FindFirstChild("TouchGui",true)
    local button=gui and gui:FindFirstChild("JumpButton",true)
    if button and button:IsA("GuiButton") then st.JumpButton=button end
    return st.JumpButton
end

SettingsVisual.HoldJumpRelease = function()
    local st=SettingsVisual.HoldJumpState
    if not st.Active then return end
    st.Active=false
    local wasAscending=st.Ascending
    st.Ascending=false
    st.BeganAt=0
    -- Si fue un toque corto, dejar terminar el salto normal.
    if not wasAscending then return end
    local char=Player.Character
    local hum=char and char:FindFirstChildOfClass("Humanoid")
    local root=char and char:FindFirstChild("HumanoidRootPart")
    if not hum or not root or hum.SeatPart then return end
    if root.AssemblyLinearVelocity.Y>0 then
        local v=root.AssemblyLinearVelocity
        -- Elimina solo el impulso de ascenso artificial, conserva X/Z.
        root.AssemblyLinearVelocity=Vector3.new(v.X,0,v.Z)
    end
end

UserInputService.JumpRequest:Connect(function()
    SettingsVisual.HoldJumpState.LastRequest=os.clock()
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode==Enum.KeyCode.Space then
        SettingsVisual.HoldJumpState.HeldKeyboard=true
    elseif input.KeyCode==Enum.KeyCode.ButtonA then
        SettingsVisual.HoldJumpState.HeldGamepad=true
    end
end)
UserInputService.InputEnded:Connect(function(input)
    local st=SettingsVisual.HoldJumpState
    if input.KeyCode==Enum.KeyCode.Space then
        st.HeldKeyboard=false
        st.LastRequest=0
    elseif input.KeyCode==Enum.KeyCode.ButtonA then
        st.HeldGamepad=false
        st.LastRequest=0
    end
end)

UserInputService.TouchStarted:Connect(function(input)
    if not InfiniteJumpEnabled then return end
    local button=SettingsVisual.GetMobileJumpButton()
    if not button or not button.Visible then return end
    local pos=input.Position
    local p=button.AbsolutePosition
    local size=button.AbsoluteSize
    if pos.X>=p.X and pos.X<=p.X+size.X
        and pos.Y>=p.Y and pos.Y<=p.Y+size.Y then
        SettingsVisual.HoldJumpState.HeldTouch=input
    end
end)
UserInputService.TouchEnded:Connect(function(input)
    local st=SettingsVisual.HoldJumpState
    if st.HeldTouch==input then
        st.HeldTouch=nil
        st.LastRequest=0
    end
end)

RunService.Heartbeat:Connect(function()
    local st=SettingsVisual.HoldJumpState
    if not InfiniteJumpEnabled then
        SettingsVisual.HoldJumpRelease()
        return
    end
    local char=Player.Character
    local hum=char and char:FindFirstChildOfClass("Humanoid")
    local root=char and char:FindFirstChild("HumanoidRootPart")
    if not hum or not root or hum.Health<=0 or hum.SeatPart then
        st.Active=false
        return
    end
    local held=st.HeldKeyboard or st.HeldGamepad or st.HeldTouch~=nil
        or (os.clock()-(st.LastRequest or 0)<0.19)
    if not held then
        SettingsVisual.HoldJumpRelease()
        return
    end
    local v=root.AssemblyLinearVelocity
    if not st.Active then
        -- Primer toque conserva el salto ligeramente alto de CHINO.
        st.Active=true
        st.Ascending=false
        st.BeganAt=os.clock()
        pcall(function() hum:ChangeState(Enum.HumanoidStateType.Jumping) end)
        root.AssemblyLinearVelocity=Vector3.new(v.X,
            math.max(v.Y,st.InitialImpulse),v.Z)
    elseif os.clock()-st.BeganAt>=st.InitialHoldSeconds then
        -- Después del primer salto: subir mientras CONTINÚE presionado.
        st.Ascending=true
        local current=root.AssemblyLinearVelocity
        -- Conservar X y Z para que Speed Hack y el salto no se cancelen.
        root.AssemblyLinearVelocity=Vector3.new(current.X,st.AscendVelocity,current.Z)
    end
end)

local function toggleStamina(enable)
	InfStaminaEnabled = enable and true or false

	local function applyStaminaCompatFallback()
		if not InfStaminaEnabled then return end

		for _, rootObj in ipairs({Player, Player.Character}) do
			if rootObj then
				pcall(function()
					for attrName, attrValue in pairs(rootObj:GetAttributes()) do
						local key = tostring(attrName):lower()
						if key:find("stamina", 1, true) and type(attrValue) == "number" then
							rootObj:SetAttribute(attrName, attrValue <= 1.5 and 1 or math.max(attrValue, 100))
						end
					end
				end)

				for _, obj in ipairs(rootObj:GetDescendants()) do
					if obj:IsA("NumberValue") or obj:IsA("IntValue") then
						local key = tostring(obj.Name):lower()
						if key:find("stamina", 1, true) then
							pcall(function()
								obj.Value = obj.Value <= 1.5 and 1 or math.max(obj.Value, 100)
							end)
						end
					end
				end
			end
		end

		pcall(function()
			local sprintModule = require(ReplicatedStorage.Modules.Game.Sprint)
			if type(sprintModule) == "table" then
				for key, value in pairs(sprintModule) do
					local name = tostring(key):lower()
					if name:find("stamina", 1, true) then
						if type(value) == "number" then
							sprintModule[key] = value <= 1.5 and 1 or math.max(value, 100)
						elseif type(value) == "table" and type(value.set) == "function" then
							pcall(function() value.set(1) end)
						end
					end
				end
			end
		end)
	end

	-- Cancela cualquier loop anterior antes de crear otro.
	if AutoSprintLoop then
		pcall(function() task.cancel(AutoSprintLoop) end)
		AutoSprintLoop = nil
	end

	pcall(function()
		local okSprint, sprintModule = pcall(function()
			return require(ReplicatedStorage.Modules.Game.Sprint)
		end)

		local sprintBar = nil
		if okSprint and sprintModule and sprintModule.consume_stamina then
			local consumeFunc = sprintModule.consume_stamina

			-- El script fuente usa getupvalue(consume_stamina, 2).sprint_bar.
			-- Aqui soportamos getupvalue, debug.getupvalue y getupvalues.
			local getter = getupvalue or (debug and debug.getupvalue)
			if getter then
				pcall(function()
					local a, b = getter(consumeFunc, 2)
					local up = (type(a) == "string" and b ~= nil) and b or a
					if type(up) == "table" and rawget(up, "sprint_bar") then
						sprintBar = up.sprint_bar
					end
				end)
			end

			if not sprintBar and getupvalues then
				pcall(function()
					local ups = getupvalues(consumeFunc)
					for _, up in pairs(ups or {}) do
						if type(up) == "table" and rawget(up, "sprint_bar") then
							sprintBar = up.sprint_bar
							break
						end
					end
				end)
			end
		end

		if InfStaminaEnabled then
			if sprintBar and type(sprintBar.update) == "function" then
				if not OriginalSprintUpdate then
					OriginalSprintUpdate = sprintBar.update
				end
				local originalUpdate = OriginalSprintUpdate
				sprintBar.update = function(...)
					return originalUpdate(function() return 1 end)
				end
				SettingsVisual.InfStaminaSprintBar = sprintBar
			end

			-- Misma pulsacion de sprint del otro script, usando el contador/remoto del HUB.
			AutoSprintLoop = task.spawn(function()
				while InfStaminaEnabled do
					pcall(applyStaminaCompatFallback)
					pcall(function()
						FireServerHook("set_sprinting_1", true)
						task.wait(0.5)
						FireServerHook("set_sprinting_1", false)
					end)
					task.wait(0.1)
				end
				pcall(function() FireServerHook("set_sprinting_1", false) end)
			end)
		else
			pcall(function() FireServerHook("set_sprinting_1", false) end)
			if OriginalSprintUpdate and SettingsVisual.InfStaminaSprintBar then
				pcall(function()
					SettingsVisual.InfStaminaSprintBar.update = OriginalSprintUpdate
				end)
			end
			OriginalSprintUpdate = nil
			SettingsVisual.InfStaminaSprintBar = nil
		end
	end)
end

--========================================================--
-- PANEL PRINCIPAL
--========================================================--

local PANEL_SIZE = UDim2.new(0, 520, 0, 330)
local GLOW_SIZE = UDim2.new(0, 550, 0, 360)

local Glow = Instance.new("Frame")
Glow.Name = "Glow"
Glow.AnchorPoint = Vector2.new(.5, .5)
Glow.Position = UDim2.fromScale(.5, .5)
Glow.Size = GLOW_SIZE
Glow.BackgroundColor3 = COLORS.Blue
Glow.BackgroundTransparency = 1
Glow.BorderSizePixel = 0
Glow.ZIndex = 1
Glow.Parent = Gui

local GlowCorner = Instance.new("UICorner")
GlowCorner.CornerRadius = UDim.new(0, 32)
GlowCorner.Parent = Glow

local Main = Instance.new("Frame")
Main.Name = "MainPanel"
Main.AnchorPoint = Vector2.new(.5, .5)
Main.Position = UDim2.fromScale(.5, .5)
Main.Size = PANEL_SIZE
Main.BackgroundColor3 = COLORS.Glass
Main.BackgroundTransparency = ALPHA.Main
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.ZIndex = 2
Main.Parent = Gui
Main.Visible = false

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 28)
MainCorner.Parent = Main

-- Nieve suave dentro del panel principal, por debajo de los controles.
SettingsVisual.AddSnowEffect(Main, 26, 2)

local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Position = UDim2.new(0, 0, 0, 0)
Header.Size = UDim2.new(1, 0, 0, 75)
Header.BackgroundTransparency = 1
Header.ZIndex = 3
Header.Parent = Main

local Sancho = Instance.new("Frame")
Sancho.Name = "Sancho"
Sancho.Position = UDim2.new(0, 18, 0, 14)
Sancho.Size = UDim2.new(0, 46, 0, 46)
Sancho.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Sancho.BackgroundTransparency = 0.2
Sancho.BorderSizePixel = 0
Sancho.ClipsDescendants = true
Sancho.ZIndex = 4
Sancho.Parent = Header

local SanchoCorner = Instance.new("UICorner")
SanchoCorner.CornerRadius = UDim.new(1, 0)
SanchoCorner.Parent = Sancho

local Sanchito = Instance.new("UIStroke")
Sanchito.Name = "Sanchito"
Sanchito.Color = Color3.fromRGB(255, 255, 255)
Sanchito.Thickness = 1.45 -- Aro blanco mas fino alrededor del avatar
Sanchito.Transparency = 0.04
Sanchito.Parent = Sancho

-- CHINO: aro del avatar SIEMPRE blanco, no animado.
-- Se elimina el ciclo RGB para conservar exactamente el mismo color.


local CircleTexture = Instance.new("ImageLabel")
CircleTexture.Name = "CircleTexture"
CircleTexture.AnchorPoint = Vector2.new(0.5, 0.5)
CircleTexture.Position = UDim2.fromScale(0.5, 0.5)
CircleTexture.Size = UDim2.fromScale(1.02, 1.02)
CircleTexture.BackgroundTransparency = 1
CircleTexture.BorderSizePixel = 0
CircleTexture.Image = "rbxassetid://105275560374583"
CircleTexture.ImageTransparency = 0.1
CircleTexture.ScaleType = Enum.ScaleType.Crop
CircleTexture.ZIndex = 5
CircleTexture.Parent = Sancho

local CircleTextureCorner = Instance.new("UICorner")
CircleTextureCorner.CornerRadius = UDim.new(1, 0)
CircleTextureCorner.Parent = CircleTexture

local Title = Instance.new("TextLabel")
Title.AnchorPoint = Vector2.new(0.5, 0)
Title.Position = UDim2.new(0.5, 0, 0, 6)
Title.Size = UDim2.new(0, 310, 0, 25)
Title.BackgroundTransparency = 1
Title.Text = "CHINOINFIERNO  V3"
Title.TextColor3 = COLORS.White
Title.TextSize = 19
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Center
Title.ZIndex = 5
Title.Parent = Header

local SubTitle = Instance.new("TextButton")
SubTitle.Name = "SubTitleDiscord"
SubTitle.AnchorPoint = Vector2.new(0.5, 0)
SubTitle.Position = UDim2.new(0.5, 0, 0, 52)
SubTitle.Size = UDim2.new(0, 250, 0, 15)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "discord.gg/yNsdDsxeT"
SubTitle.TextColor3 = COLORS.Muted
SubTitle.TextSize = 10
SubTitle.Font = Enum.Font.GothamMedium
SubTitle.TextXAlignment = Enum.TextXAlignment.Center
SubTitle.AutoButtonColor = false
SubTitle.ZIndex = 5
SubTitle.Parent = Header

-- Identidad premium compacta y centrada.
do
	local buildTag = Instance.new("TextLabel", Header)
	buildTag.Name = "PremiumBuildTag"
	buildTag.AnchorPoint = Vector2.new(0.5, 0)
	buildTag.Position = UDim2.new(0.5, 0, 0, 31)
	buildTag.Size = UDim2.fromOffset(172, 17)
	buildTag.BackgroundColor3 = Color3.fromRGB(15, 20, 32)
	buildTag.BackgroundTransparency = 0.42
	buildTag.BorderSizePixel = 0
	buildTag.Text = "FREE ACCESS  |  NO KEY"
	buildTag.TextColor3 = Color3.fromRGB(220, 232, 248)
	buildTag.TextSize = 8
	buildTag.Font = Enum.Font.GothamBold
	buildTag.TextXAlignment = Enum.TextXAlignment.Center
	buildTag.ZIndex = 5
	Instance.new("UICorner", buildTag).CornerRadius = UDim.new(1, 0)

	local buildStroke = Instance.new("UIStroke", buildTag)
	buildStroke.Color = COLORS.Blue
	buildStroke.Transparency = 0.70
	buildStroke.Thickness = 1
end

SubTitle.MouseButton1Click:Connect(function()
	pcall(function()
		setclipboard("By Ren")
	end)
	local oldText = SubTitle.Text
	SubTitle.Text = "Copiado!"
	SubTitle.TextColor3 = COLORS.BlueBright
	task.wait(1.5)
	SubTitle.Text = oldText
	SubTitle.TextColor3 = COLORS.Muted
end)

local WindowButtons = Instance.new("Frame")
SettingsVisual.PCPanelSizingEnabled = true
WindowButtons.Position = UDim2.new(1, SettingsVisual.PCPanelSizingEnabled and -132 or -100, 0, 18)
WindowButtons.Size = UDim2.new(0, SettingsVisual.PCPanelSizingEnabled and 112 or 80, 0, 32)
WindowButtons.BackgroundColor3 = COLORS.Glass2
WindowButtons.BackgroundTransparency = ALPHA.Buttons
WindowButtons.BorderSizePixel = 0
WindowButtons.ZIndex = 4
WindowButtons.Parent = Header

local WBCorner = Instance.new("UICorner")
WBCorner.CornerRadius = UDim.new(1, 0)
WBCorner.Parent = WindowButtons

local WBStroke = Instance.new("UIStroke")
WBStroke.Color = COLORS.Blue
WBStroke.Transparency = 0.65
WBStroke.Thickness = 1
WBStroke.Parent = WindowButtons

local Minimize = Instance.new("TextButton")
Minimize.Size = SettingsVisual.PCPanelSizingEnabled and UDim2.new(1/3, 0, 1, 0) or UDim2.new(.5, 0, 1, 0)
Minimize.BackgroundTransparency = 1
Minimize.Text = "−"
Minimize.TextColor3 = COLORS.White
Minimize.TextSize = 20
Minimize.Font = Enum.Font.Gotham
Minimize.AutoButtonColor = false
Minimize.ZIndex = 5
Minimize.Parent = WindowButtons

SettingsVisual.PCExpandButton = Instance.new("TextButton")
SettingsVisual.PCExpandButton.Name = "PCExpandButton"
SettingsVisual.PCExpandButton.Position = UDim2.new(1/3, 0, 0, 0)
SettingsVisual.PCExpandButton.Size = UDim2.new(1/3, 0, 1, 0)
SettingsVisual.PCExpandButton.BackgroundTransparency = 1
SettingsVisual.PCExpandButton.Text = "▢"
SettingsVisual.PCExpandButton.TextColor3 = COLORS.White
SettingsVisual.PCExpandButton.TextSize = 15
SettingsVisual.PCExpandButton.Font = Enum.Font.GothamMedium
SettingsVisual.PCExpandButton.AutoButtonColor = false
SettingsVisual.PCExpandButton.Visible = SettingsVisual.PCPanelSizingEnabled
SettingsVisual.PCExpandButton.ZIndex = 5
SettingsVisual.PCExpandButton.Parent = WindowButtons

local Close = Instance.new("TextButton")
Close.Position = SettingsVisual.PCPanelSizingEnabled and UDim2.new(2/3, 0, 0, 0) or UDim2.new(.5, 0, 0, 0)
Close.Size = SettingsVisual.PCPanelSizingEnabled and UDim2.new(1/3, 0, 1, 0) or UDim2.new(.5, 0, 1, 0)
Close.BackgroundTransparency = 1
Close.Text = "×"
Close.TextColor3 = COLORS.White
Close.TextSize = 20
Close.Font = Enum.Font.Gotham
Close.AutoButtonColor = false
Close.ZIndex = 5
Close.Parent = WindowButtons

SettingsVisual.PanelExpanded = false
SettingsVisual.PanelExpandedSize = UDim2.new(0, 720, 0, 450)
SettingsVisual.GetPanelTargetSize = function()
	return SettingsVisual.PanelExpanded and SettingsVisual.PanelExpandedSize or PANEL_SIZE
end

SettingsVisual.PCExpandButton.MouseButton1Click:Connect(function()
	if not SettingsVisual.PCPanelSizingEnabled or not Main.Visible then return end
	SettingsVisual.PanelExpanded = not SettingsVisual.PanelExpanded
	SettingsVisual.PCExpandButton.Text = SettingsVisual.PanelExpanded and "↙" or "▢"
	TweenService:Create(
		Main,
		TweenInfo.new(0.34, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
		{Size = SettingsVisual.GetPanelTargetSize()}
	):Play()
end)

local HeaderLine = Instance.new("Frame")
HeaderLine.Position = UDim2.new(0, 16, 0, 72)
HeaderLine.Size = UDim2.new(1, -32, 0, 1)
HeaderLine.BackgroundColor3 = COLORS.Blue
HeaderLine.BackgroundTransparency = 0.80
HeaderLine.BorderSizePixel = 0
HeaderLine.ZIndex = 4
HeaderLine.Parent = Main

local Sidebar = Instance.new("ScrollingFrame")
Sidebar.Name = "Sidebar"
Sidebar.Position = UDim2.new(0, 16, 0, 84)
Sidebar.Size = UDim2.new(0, 145, 1, -94)
Sidebar.BackgroundColor3 = COLORS.Glass2
Sidebar.BackgroundTransparency = ALPHA.Sidebar
Sidebar.BorderSizePixel = 0
Sidebar.ScrollBarThickness = 3
Sidebar.ScrollBarImageColor3 = COLORS.Blue
Sidebar.ZIndex = 3
Sidebar.Parent = Main

local SidebarCorner = Instance.new("UICorner")
SidebarCorner.CornerRadius = UDim.new(0, 16)
SidebarCorner.Parent = Sidebar

local SidebarStroke = Instance.new("UIStroke")
SidebarStroke.Color = COLORS.Blue
SidebarStroke.Transparency = 0.75
SidebarStroke.Thickness = 1
SidebarStroke.Parent = Sidebar

local SidebarPadding = Instance.new("UIPadding")
SidebarPadding.PaddingTop = UDim.new(0, 6)
SidebarPadding.PaddingBottom = UDim.new(0, 6)
SidebarPadding.PaddingLeft = UDim.new(0, 6)
SidebarPadding.PaddingRight = UDim.new(0, 6)
SidebarPadding.Parent = Sidebar

local SidebarLayout = Instance.new("UIListLayout")
SidebarLayout.Padding = UDim.new(0, 4)
SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
SidebarLayout.Parent = Sidebar

SidebarLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	Sidebar.CanvasSize = UDim2.new(0, 0, 0, SidebarLayout.AbsoluteContentSize.Y + 16)
end)

local Content = Instance.new("Frame")
Content.Name = "Content"
Content.Position = UDim2.new(0, 170, 0, 84)
Content.Size = UDim2.new(1, -186, 1, -94)
Content.BackgroundTransparency = 1
Content.BorderSizePixel = 0
Content.ZIndex = 3
Content.Parent = Main

local TabContainers = {}

local function CreateTabScroll(name)
	local frame = Instance.new("ScrollingFrame")
	frame.Name = name .. "Scroll"
	frame.Position = UDim2.new(0, 0, 0, 0)
	frame.Size = UDim2.new(1, 0, 1, 0)
	frame.BackgroundTransparency = 1
	frame.BorderSizePixel = 0
	frame.ScrollBarThickness = 3
	frame.ScrollBarImageColor3 = COLORS.Blue
	frame.Visible = false
	frame.ZIndex = 5
	frame.Parent = Content

	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0, 6)
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Parent = frame

	local pad = Instance.new("UIPadding")
	pad.PaddingTop = UDim.new(0, 4)
	pad.PaddingBottom = UDim.new(0, 8)
	pad.PaddingLeft = UDim.new(0, 4)
	pad.PaddingRight = UDim.new(0, 4)
	pad.Parent = frame

	layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		frame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 16)
	end)

	TabContainers[name] = frame
	return frame
end

local SilentScroll = CreateTabScroll("Silent Aim")
local SoftAimScroll = CreateTabScroll("Soft Aim")
local ESPScroll = CreateTabScroll("ESP")
local PlayerScroll = CreateTabScroll("Player")
local VehicleScroll = CreateTabScroll("Vehicle")
local MiscScroll = CreateTabScroll("Misc")
SettingsVisual.FarmScroll = CreateTabScroll("Farm")
SettingsVisual.AmmoScroll = CreateTabScroll("Buy")
local ArmasScroll = CreateTabScroll("TP Items")
local ConfigScroll = CreateTabScroll("Config")

local function CreatePhotoStyleTab(parentScroll)
	local container = Instance.new("Frame")
	container.Size = UDim2.new(1, 0, 0, 220)
	container.BackgroundTransparency = 1
	container.ZIndex = 5
	container.Parent = parentScroll

	local function createSideBox(titleText, posX, sizeX)
		local boxFrame = Instance.new("Frame")
		boxFrame.Size = UDim2.new(sizeX, -4, 1, 0)
		boxFrame.Position = UDim2.new(posX, 0, 0, 0)
		boxFrame.BackgroundColor3 = Color3.fromRGB(15, 18, 28)
		boxFrame.BackgroundTransparency = 0.92
		boxFrame.ZIndex = 6
		boxFrame.Parent = container
		Instance.new("UICorner", boxFrame).CornerRadius = UDim.new(0, 10)
		
		local stroke = Instance.new("UIStroke", boxFrame)
		stroke.Color = Color3.fromRGB(35, 55, 90)
		stroke.Transparency = 0.6
		stroke.Thickness = 1

		local titleLbl = Instance.new("TextLabel", boxFrame)
		titleLbl.Size = UDim2.new(1, -20, 0, 22)
		titleLbl.Position = UDim2.new(0, 10, 0, 4)
		titleLbl.BackgroundTransparency = 1
		titleLbl.Text = titleText
		titleLbl.TextColor3 = Color3.fromRGB(160, 180, 210)
		titleLbl.TextSize = 12
		titleLbl.Font = Enum.Font.GothamBold
		titleLbl.TextXAlignment = Enum.TextXAlignment.Left
		titleLbl.ZIndex = 9

		local scroll = Instance.new("ScrollingFrame", boxFrame)
		scroll.Size = UDim2.new(1, -4, 1, -26)
		scroll.Position = UDim2.new(0, 2, 0, 26)
		scroll.BackgroundTransparency = 1
		scroll.BorderSizePixel = 0
		scroll.ScrollBarThickness = 3
		scroll.ScrollBarImageColor3 = COLORS.Blue
		scroll.ZIndex = 7

		local listLayout = Instance.new("UIListLayout", scroll)
		listLayout.Padding = UDim.new(0, 4)
		listLayout.SortOrder = Enum.SortOrder.LayoutOrder
		
		local pad = Instance.new("UIPadding", scroll)
		pad.PaddingTop = UDim.new(0, 2)
		pad.PaddingBottom = UDim.new(0, 8)
		pad.PaddingLeft = UDim.new(0, 4)
		pad.PaddingRight = UDim.new(0, 4)

		listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			scroll.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 16)
		end)

		return scroll
	end

	local leftBox = createSideBox("Miscellaneous", 0, 0.5)
	local rightBox = createSideBox("others", 0.5, 0.5)

	return leftBox, rightBox
end

local function MakeToggle(parent, titleText, defaultVal, callback)
	local row = Instance.new("Frame")
	row.Size = UDim2.new(1, 0, 0, 30)
	row.BackgroundColor3 = Color3.fromRGB(20, 24, 38)
	row.BackgroundTransparency = 0.6
	row.ZIndex = 8
	row.Parent = parent
	Instance.new("UICorner", row).CornerRadius = UDim.new(0, 6)

	local label = Instance.new("TextLabel", row)
	label.Size = UDim2.new(1, -45, 1, 0)
	label.Position = UDim2.new(0, 8, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = titleText
	label.TextColor3 = COLORS.White
	label.TextSize = 11
	label.Font = Enum.Font.Gotham
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.ZIndex = 8

	local toggle = Instance.new("TextButton", row)
	toggle.Size = UDim2.new(0, 28, 0, 16)
	toggle.Position = UDim2.new(1, -34, 0.5, -8)
	toggle.BackgroundColor3 = defaultVal and COLORS.Blue or Color3.fromRGB(35, 32, 45)
	toggle.Text = ""
	toggle.ZIndex = 8
	Instance.new("UICorner", toggle).CornerRadius = UDim.new(1, 0)

	local circle = Instance.new("Frame", toggle)
	circle.Size = UDim2.new(0, 10, 0, 10)
	circle.Position = defaultVal and UDim2.new(1, -13, 0.5, -5) or UDim2.new(0, 3, 0.5, -5)
	circle.BackgroundColor3 = COLORS.White
	circle.BorderSizePixel = 0
	circle.ZIndex = 9
	Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)

	local current = defaultVal and true or false

	local function setToggleValue(value, fireCallback, fromUserTap)
		current = value and true or false
		TweenService:Create(toggle, TweenInfo.new(0.18), {BackgroundColor3 = current and COLORS.Blue or Color3.fromRGB(35, 32, 45)}):Play()
		TweenService:Create(circle, TweenInfo.new(0.18), {Position = current and UDim2.new(1, -13, 0.5, -5) or UDim2.new(0, 3, 0.5, -5)}):Play()
		if fireCallback and callback then callback(current, fromUserTap == true) end
	end

	toggle.MouseButton1Click:Connect(function()
		local nextValue = not current
		if nextValue and SettingsVisual.PlayToggleSound then SettingsVisual.PlayToggleSound() end
		setToggleValue(nextValue, true, true)
	end)

	-- Claves repetidas (por ejemplo Mostrar FOV) reciben #1, #2, etc.
	-- El orden de creacion es determinista, asi la config vuelve a cargar igual.
	if titleText ~= "Guardar Config" and titleText ~= "Reset Config" then
		SettingsVisual.ConfigKeyCounts[titleText] = (SettingsVisual.ConfigKeyCounts[titleText] or 0) + 1
		local configKey = titleText .. "#" .. tostring(SettingsVisual.ConfigKeyCounts[titleText])
		SettingsVisual.ConfigControls[configKey] = {
			Type = "Toggle",
			Default = current,
			Get = function() return current end,
			Set = function(value) setToggleValue(value, true, false) end
		}
	end

	return function(value)
		value = value and true or false
		if current == value then return end
		setToggleValue(value, true, false)
	end
end

local function MakeSlider(parent, name, defaultVal, minVal, maxVal, callback)
	local row = Instance.new("Frame")
	row.Size = UDim2.new(1, 0, 0, 38)
	row.BackgroundColor3 = Color3.fromRGB(20, 24, 38)
	row.BackgroundTransparency = 0.6
	row.ZIndex = 8
	row.Parent = parent
	Instance.new("UICorner", row).CornerRadius = UDim.new(0, 6)

	local label = Instance.new("TextLabel", row)
	label.Size = UDim2.new(1, -76, 0, 16)
	label.Position = UDim2.new(0, 8, 0, 3)
	label.BackgroundTransparency = 1
	label.Text = name
	label.TextColor3 = COLORS.White
	label.TextSize = 10
	label.Font = Enum.Font.Gotham
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.ZIndex = 8

	-- El numero ahora es editable: al tocarlo abre teclado movil/PC.
	local valueBox = Instance.new("TextBox", row)
	valueBox.Size = UDim2.new(0, 58, 0, 18)
	valueBox.Position = UDim2.new(1, -64, 0, 2)
	valueBox.BackgroundColor3 = Color3.fromRGB(20, 24, 38)
	valueBox.BackgroundTransparency = 0.72
	valueBox.BorderSizePixel = 0
	valueBox.ClearTextOnFocus = false
	valueBox.Text = tostring(defaultVal)
	valueBox.TextColor3 = Color3.fromRGB(225, 235, 250)
	valueBox.TextSize = 9
	valueBox.Font = Enum.Font.GothamBold
	valueBox.TextXAlignment = Enum.TextXAlignment.Center
	valueBox.ZIndex = 10
	Instance.new("UICorner", valueBox).CornerRadius = UDim.new(0, 5)
	do
		local valueStroke = Instance.new("UIStroke", valueBox)
		valueStroke.Color = Color3.fromRGB(95, 135, 185)
		valueStroke.Thickness = 1
		valueStroke.Transparency = 0.82
	end
	pcall(function() valueBox.TextInputType = Enum.TextInputType.Number end)

	local bar = Instance.new("Frame", row)
	bar.Size = UDim2.new(1, -16, 0, 4)
	bar.Position = UDim2.new(0, 8, 0, 27)
	bar.BackgroundColor3 = Color3.fromRGB(35, 32, 45)
	bar.ZIndex = 8
	Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)

	local fill = Instance.new("Frame", bar)
	fill.Size = UDim2.new(math.clamp((defaultVal - minVal) / (maxVal - minVal), 0, 1), 0, 1, 0)
	fill.BackgroundColor3 = COLORS.Blue
	fill.ZIndex = 8
	Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

	local dot = Instance.new("Frame", fill)
	dot.Size = UDim2.new(0, 10, 0, 10)
	dot.Position = UDim2.new(1, -5, 0.5, -5)
	dot.BackgroundColor3 = COLORS.White
	dot.BorderSizePixel = 0
	dot.ZIndex = 9
	Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

	local current = defaultVal
	local dragging = false

	local function setSliderValue(value, fireCallback)
		value = tonumber(value) or current or defaultVal
		value = math.clamp(value, minVal, maxVal)
		value = math.floor(value * 10 + 0.5) / 10
		current = value
		local pos = math.clamp((value - minVal) / (maxVal - minVal), 0, 1)
		fill.Size = UDim2.new(pos, 0, 1, 0)
		valueBox.Text = tostring(value)
		if fireCallback and callback then callback(value) end
	end

	local function applySlider(input)
		local pos = math.clamp((input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
		setSliderValue(minVal + ((maxVal - minVal) * pos), true)
	end

	valueBox.Focused:Connect(function()
		dragging = false
	end)
	valueBox.FocusLost:Connect(function()
		local n = tonumber(valueBox.Text)
		if n then
			setSliderValue(n, true)
		else
			valueBox.Text = tostring(current)
		end
	end)

	bar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			applySlider(input)
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			applySlider(input)
		end
	end)

	SettingsVisual.ConfigKeyCounts[name] = (SettingsVisual.ConfigKeyCounts[name] or 0) + 1
	local configKey = name .. "#" .. tostring(SettingsVisual.ConfigKeyCounts[name])
	SettingsVisual.ConfigControls[configKey] = {
		Type = "Slider",
		Default = defaultVal,
		Get = function() return current end,
		Set = function(value) setSliderValue(value, true) end
	}

	return function(value) setSliderValue(value, true) end
end

-- Botón de acción de una sola ejecución, con el mismo estilo visual del HUB.
-- Se guarda en SettingsVisual para no añadir otro local principal al chunk.
SettingsVisual.MakeActionButton = function(parent, titleText, callback, buttonText, buttonTransparency)
	local row = Instance.new("Frame")
	row.Size = UDim2.new(1, 0, 0, 30)
	row.BackgroundColor3 = Color3.fromRGB(20, 24, 38)
	row.BackgroundTransparency = 0.6
	row.ZIndex = 8
	row.Parent = parent
	Instance.new("UICorner", row).CornerRadius = UDim.new(0, 6)

	local label = Instance.new("TextLabel", row)
	label.Size = UDim2.new(1, -70, 1, 0)
	label.Position = UDim2.new(0, 8, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = titleText
	label.TextColor3 = COLORS.White
	label.TextSize = 11
	label.Font = Enum.Font.Gotham
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.ZIndex = 8

	local button = Instance.new("TextButton", row)
	button.Size = UDim2.new(0, 54, 0, 18)
	button.Position = UDim2.new(1, -60, 0.5, -9)
	button.BackgroundColor3 = COLORS.Blue
	button.BackgroundTransparency = tonumber(buttonTransparency) or 0.18
	button.BorderSizePixel = 0
	button.Text = buttonText or "RUN"
	button.TextColor3 = COLORS.White
	button.TextSize = 9
	button.Font = Enum.Font.GothamBold
	button.AutoButtonColor = true
	button.ZIndex = 9
	Instance.new("UICorner", button).CornerRadius = UDim.new(0, 5)

	button.MouseButton1Click:Connect(function()
		button.Text = "..."
		button.Active = false
		task.spawn(function()
			pcall(callback)
			task.wait(0.25)
			if button and button.Parent then
				button.Text = buttonText or "RUN"
				button.Active = true
			end
		end)
	end)
end


-- Fila de monitoreo de valor para Bank/Hand Balance.
SettingsVisual.MakeValueRow = function(parent, titleText, initialValue)
	local row = Instance.new("Frame")
	row.Size = UDim2.new(1, 0, 0, 30)
	row.BackgroundColor3 = Color3.fromRGB(20, 24, 38)
	row.BackgroundTransparency = 0.6
	row.ZIndex = 8
	row.Parent = parent
	Instance.new("UICorner", row).CornerRadius = UDim.new(0, 6)

	local label = Instance.new("TextLabel", row)
	label.Size = UDim2.new(0.58, -8, 1, 0)
	label.Position = UDim2.new(0, 8, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = titleText
	label.TextColor3 = COLORS.White
	label.TextSize = 10
	label.Font = Enum.Font.Gotham
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.ZIndex = 8

	local value = Instance.new("TextLabel", row)
	value.Size = UDim2.new(0.42, -10, 1, 0)
	value.Position = UDim2.new(0.58, 0, 0, 0)
	value.BackgroundTransparency = 1
	value.Text = initialValue or "$0"
	value.TextColor3 = Color3.fromRGB(125, 220, 155)
	value.TextSize = 10
	value.Font = Enum.Font.GothamBold
	value.TextXAlignment = Enum.TextXAlignment.Right
	value.ZIndex = 8

	return function(newValue)
		if value and value.Parent then value.Text = tostring(newValue) end
	end
end

-- Abre Ammo Crate usando el mismo remote y la misma ruta de ROBADO.txt.
SettingsVisual.OpenAmmoCrate = function()
	local map = workspace:FindFirstChild("Map")
	local tiles = map and map:FindFirstChild("Tiles")
	local gunShopTile = tiles and tiles:FindFirstChild("GunShopTile")
	local patriotWeapons = gunShopTile and gunShopTile:FindFirstChild("PatriotWeapons")
	local interior = patriotWeapons and patriotWeapons:FindFirstChild("Interior")
	local crates = interior and interior:FindFirstChild("Crates")
	local ammoCrate = crates and crates:FindFirstChild("Ammo Crate")
	local crateOptions = ammoCrate and ammoCrate:FindFirstChild("CrateOptions")
	if not crateOptions then
		warn("[CHINO] No se encontró Ammo Crate / CrateOptions")
		return false
	end

	local bulletType = SettingsVisual.SelectedAmmoType or "Pistol"
	if bulletType == "Random" then
		local choices = {"Pistol", "Rifle", "Shotgun"}
		bulletType = choices[math.random(1, #choices)]
	end

	local targetItem = crateOptions:FindFirstChild(bulletType)
	if not targetItem then
		warn("[CHINO] No existe tipo de ammo en crate:", bulletType)
		return false
	end

	local result = NetGet("open_crate", targetItem, "money")
	if result then
		print("[CHINO] Ammo Crate abierto:", bulletType)
	else
		warn("[CHINO] El servidor no confirmó open_crate:", bulletType)
	end
	return result and true or false
end

-- Comprar cajas desde las tiendas oficiales de BlockSpin.
-- Extraído de la lógica Guns/Car de DeepSeek-BlockSpin, usando el NetGet
-- con el que ya se compran las balas de este mismo CHINOINFIERNO.
-- NO crea armas/autos gratuitamente ni modifica el balance: el servidor valida.
SettingsVisual.ResolveShopCrateOptions = function(shop)
    local map = workspace:FindFirstChild("Map")
    local tiles = map and map:FindFirstChild("Tiles")
    local store
    local crateName
    if shop == "Gun" then
        local tile = tiles and tiles:FindFirstChild("GunShopTile")
        store = tile and tile:FindFirstChild("PatriotWeapons")
        crateName = "Weapon Crate"
        -- Esta alternativa solo busca la MISMA tienda por nombre si cambia el mapa.
        if not store then store = workspace:FindFirstChild("PatriotWeapons", true) end
    elseif shop == "Car" then
        local tile = tiles and tiles:FindFirstChild("PrestigeDealerAndHousing")
        store = tile and tile:FindFirstChild("PrestigeCarDealer")
        crateName = "Car Crate"
        if not store then store = workspace:FindFirstChild("PrestigeCarDealer", true) end
    else
        return nil
    end
    local interior = store and store:FindFirstChild("Interior")
    local crates = interior and interior:FindFirstChild("Crates")
    local crate = crates and crates:FindFirstChild(crateName)
    return crate and crate:FindFirstChild("CrateOptions") or nil
end

SettingsVisual.OpenGunCrate = function()
    local crateOptions = SettingsVisual.ResolveShopCrateOptions("Gun")
    if not crateOptions then
        warn("[CHINO][Guns] Acércate a PatriotWeapons; no se encontró Weapon Crate/CrateOptions.")
        return false
    end
    local selected = SettingsVisual.SelectedGunCrate or "Basic"
    local option = crateOptions:FindFirstChild(selected)
    if not option then
        warn("[CHINO][Guns] Esa caja no está disponible en la tienda:", selected)
        return false
    end
    -- 'money' indica pagar con el efectivo que llevas, igual que Ammo Crate.
    local response = NetGet("open_crate", option, "money")
    if response then
        print("[CHINO][Guns] Servidor respondió al comprar caja:", selected)
    else
        warn("[CHINO][Guns] El servidor no confirmó la compra:", selected)
    end
    return response and true or false
end

SettingsVisual.OpenCarCrate = function()
    local crateOptions = SettingsVisual.ResolveShopCrateOptions("Car")
    if not crateOptions then
        warn("[CHINO][Car] Acércate a PrestigeCarDealer; no se encontró Car Crate/CrateOptions.")
        return false
    end
    local selected = SettingsVisual.SelectedCarCrate or "Basic"
    local option = crateOptions:FindFirstChild(selected)
    if not option then
        warn("[CHINO][Car] Esa caja no está disponible en la tienda:", selected)
        return false
    end
    local response = NetGet("open_crate", option, "money")
    if response then
        print("[CHINO][Car] Servidor respondió al comprar caja:", selected)
    else
        warn("[CHINO][Car] El servidor no confirmó la compra:", selected)
    end
    return response and true or false
end

-- Limpieza de puertas del script ROBADO, convertida en botón manual para no borrar nada al iniciar.
SettingsVisual.CleanDoors = function()
	local collectionService = game:GetService("CollectionService")
	local removed = 0

	for _, tag in pairs(collectionService:GetAllTags()) do
		if tostring(tag):lower():find("door", 1, true) then
			for _, obj in pairs(collectionService:GetTagged(tag)) do
				if obj and obj.Parent then
					pcall(function() obj:Destroy() end)
					removed = removed + 1
				end
			end
		end
	end

	for _, obj in pairs(workspace:GetDescendants()) do
		if obj and obj.Parent and tostring(obj.Name):lower():find("door", 1, true) then
			pcall(function() obj:Destroy() end)
			removed = removed + 1
		end
	end

	print("[CHINO] Limpieza de puertas terminada. Objetos:", removed)
	return removed
end

-- Puertas quitadas POR DEFECTO desde que arranca el HUB.
-- También elimina puertas que aparezcan después, para no depender de
-- apagar/encender otra opción (por ejemplo GPS Boat) para refrescarlas.
SettingsVisual.DoorCleanupEnabled = true
SettingsVisual.DoorCleanupConnections = SettingsVisual.DoorCleanupConnections or {}

SettingsVisual.StartDoorCleanup = function()
	if SettingsVisual.DoorCleanupStarted then return end
	SettingsVisual.DoorCleanupStarted = true

	local collectionService = game:GetService("CollectionService")

	local function looksLikeDoor(obj)
		if not obj then return false end
		if tostring(obj.Name):lower():find("door", 1, true) then
			return true
		end

		local ok, tags = pcall(function()
			return collectionService:GetTags(obj)
		end)
		if ok then
			for _, tag in ipairs(tags or {}) do
				if tostring(tag):lower():find("door", 1, true) then
					return true
				end
			end
		end

		return false
	end

	local function removeIfDoor(obj)
		if not SettingsVisual.DoorCleanupEnabled or not obj or not obj.Parent then return end
		if looksLikeDoor(obj) then
			pcall(function() obj:Destroy() end)
		end
	end

	-- Limpieza inicial automática.
	task.defer(function()
		pcall(function() SettingsVisual.CleanDoors() end)
	end)

	-- Cubre puertas/modelos que el juego agregue después.
	SettingsVisual.DoorCleanupConnections.DescendantAdded = workspace.DescendantAdded:Connect(function(obj)
		task.defer(function()
			removeIfDoor(obj)
		end)
	end)

	-- Cubre instancias que reciban posteriormente un tag de puerta ya existente.
	for _, tag in ipairs(collectionService:GetAllTags()) do
		if tostring(tag):lower():find("door", 1, true) then
			local key = "Tag_" .. tostring(tag)
			if not SettingsVisual.DoorCleanupConnections[key] then
				SettingsVisual.DoorCleanupConnections[key] = collectionService:GetInstanceAddedSignal(tag):Connect(function(obj)
					task.defer(function() removeIfDoor(obj) end)
				end)
			end
		end
	end
end

SettingsVisual.StartDoorCleanup()

local miscLeft, miscRight = CreatePhotoStyleTab(MiscScroll)
local silentLeft, silentRight = CreatePhotoStyleTab(SilentScroll)
local softAimLeft, softAimRight = CreatePhotoStyleTab(SoftAimScroll)
local espLeft, espRight = CreatePhotoStyleTab(ESPScroll)
local playerLeft, playerRight = CreatePhotoStyleTab(PlayerScroll)
local vehicleLeft, vehicleRight = CreatePhotoStyleTab(VehicleScroll)
local configLeft, configRight = CreatePhotoStyleTab(ConfigScroll)
SettingsVisual.FarmLeft, SettingsVisual.FarmRight = CreatePhotoStyleTab(SettingsVisual.FarmScroll)

--====================================================================--
-- CONFIG • OPTIMIZADOR FPS V2 (VISIBLE PRIMERO Y REVERSIBLE)
-- No borra puertas, no altera físicas/colisiones; restaura al apagar.
--====================================================================--
do
    local optimizer={ Enabled=false, Changed=setmetatable({}, {__mode="k"}),
                      Connection=nil, PriorShadows=nil, PriorCap=nil, Ticket=0 }
    local function preserveShotVisual(obj)
        if not obj then return false end
        -- El FPS no debe apagar rayos, destellos, particulas ni luces de disparo.
        local cur=obj
        for _=1,5 do
            if not cur or cur==workspace then break end
            local n=tostring(cur.Name):lower()
            if n=="lasertracer" or n=="lasertracerglow" or n=="laserimpact"
                or n:find("chino_silentlaser",1,true)
                or n:find("muzzle",1,true)
                or n:find("gunflash",1,true)
                or n:find("bulletbeam",1,true)
                or n:find("bullettracer",1,true) then
                return true
            end
            cur=cur.Parent
        end
        -- Mantener las superficies Neon del juego en lugar de volverlas plastico.
        if obj:IsA("BasePart") and obj.Material==Enum.Material.Neon then return true end
        -- Bloom es lo que aporta el halo al rayo luminoso.
        if obj:IsA("BloomEffect") then return true end
        return false
    end
    local function optimize(obj)
        if not optimizer.Enabled or not obj or not obj.Parent then return end
        if optimizer.Changed[obj] then return end
        if preserveShotVisual(obj) then return end
        if obj:IsA("BasePart") then
            optimizer.Changed[obj]={kind="part",material=obj.Material,shadow=obj.CastShadow}
            pcall(function()
                obj.Material=Enum.Material.SmoothPlastic
                obj.CastShadow=false
            end)
        elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam")
            or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles")
            or obj:IsA("PostEffect") then
            local ok,enabled=pcall(function() return obj.Enabled end)
            if ok then
                optimizer.Changed[obj]={kind="fx",enabled=enabled}
                pcall(function() obj.Enabled=false end)
            end
        end
    end
    local function disable()
        optimizer.Enabled=false
        optimizer.Ticket+=1
        if optimizer.Connection then optimizer.Connection:Disconnect(); optimizer.Connection=nil end
        pcall(function()
            if optimizer.PriorShadows~=nil then Lighting.GlobalShadows=optimizer.PriorShadows end
        end)
        if type(setfpscap)=="function" and optimizer.PriorCap then
            pcall(function() setfpscap(optimizer.PriorCap) end)
        end
        for obj,old in pairs(optimizer.Changed) do
            if obj and obj.Parent then
                if old.kind=="part" then
                    pcall(function() obj.Material=old.material; obj.CastShadow=old.shadow end)
                elseif old.kind=="fx" then
                    pcall(function() obj.Enabled=old.enabled end)
                end
            end
        end
        optimizer.Changed=setmetatable({}, {__mode="k"})
    end
    local function enable()
        if optimizer.Enabled then return end
        optimizer.Enabled=true
        optimizer.Ticket+=1
        local ticket=optimizer.Ticket
        optimizer.PriorShadows=Lighting.GlobalShadows
        pcall(function() Lighting.GlobalShadows=false end)
        if type(getfpscap)=="function" then
            pcall(function() optimizer.PriorCap=getfpscap() end)
        end
        if type(setfpscap)=="function" then
            pcall(function() setfpscap(120) end)
        end
        optimizer.Connection=workspace.DescendantAdded:Connect(function(obj)
            task.defer(function() optimize(obj) end)
        end)
        local things=workspace:GetDescendants()
        local lightingThings=Lighting:GetDescendants()
        task.spawn(function()
            for i,obj in ipairs(things) do
                if not optimizer.Enabled or optimizer.Ticket~=ticket then return end
                optimize(obj)
                if i%175==0 then task.wait() end
            end
            for i,obj in ipairs(lightingThings) do
                if not optimizer.Enabled or optimizer.Ticket~=ticket then return end
                optimize(obj)
                if i%175==0 then task.wait() end
            end
        end)
    end
    SettingsVisual.FPSOptimizer={SetEnabled=function(v) if v then enable() else disable() end end,
        IsEnabled=function() return optimizer.Enabled end}
    -- A primera vista al abrir Config, sin buscar al final de la lista.
    MakeToggle(configRight, "Optimizar FPS", false, function(v)
        SettingsVisual.FPSOptimizer.SetEnabled(v)
    end)
end

-- Se puede desactivar para restaurar el cielo normal (útil si se quiere mejorar FPS).
MakeToggle(configRight, "Purple Sky", true, function(value)
    SettingsVisual.ApplyPurpleSky(value)
end)

SettingsVisual.AmmoLeft, SettingsVisual.AmmoRight = CreatePhotoStyleTab(SettingsVisual.AmmoScroll)

--====================================================================--
-- FARM • AUTO SKIP CRATE (SZKHUB EXTRAIDO PREVIAMENTE)
--====================================================================--
do
--============================================================--
-- CHINO | AUTO SKIP CRATE | extraído de SZKHUB (BlockSpin)
-- Solo incluye la función Auto Skip Crate.
-- No incluye WindUI ni las otras funciones del HUB.
--
-- USO INDEPENDIENTE:
--   Ejecuta el script: queda ACTIVADO.
--
-- PARA INTEGRARLO DESPUES EN OTRO HUB:
--   local crateSkip = (getgenv and getgenv() or _G).CHINO_AutoSkipCrate
--   crateSkip.SetEnabled(true)  -- ON
--   crateSkip.SetEnabled(false) -- OFF
--   crateSkip.Destroy()         -- limpieza total
--
-- Adaptado de las secciones Auto Skip Crate del SZKHUB:
--   detener animaciones, acortar tween y saltar estado de caja.
-- No garantiza que el servidor confirme la apertura.
--============================================================--

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local ENV = _G
if type(getgenv) == "function" then
    local ok, env = pcall(getgenv)
    if ok and type(env) == "table" then ENV = env end
end

-- Evita duplicar conexiones si se ejecuta otra vez.
if ENV.CHINO_AutoSkipCrate and type(ENV.CHINO_AutoSkipCrate.Destroy) == "function" then
    pcall(ENV.CHINO_AutoSkipCrate.Destroy)
end

local State = {
    Enabled = false,
    Running = true,
    CrateController = nil,
    OriginalTween = nil,
    WrappedTween = nil,
    UtilModule = nil,
    StepConnection = nil,
}

local function getModule(...)
    local names = {...}
    local current = ReplicatedStorage
    for _, name in ipairs(names) do
        current = current:FindFirstChild(name)
        if not current then return nil end
    end
    if not current:IsA("ModuleScript") then return nil end
    local ok, module = pcall(require, current)
    if ok and type(module) == "table" then return module end
    return nil
end

local function stopCrateAnimations()
    local character = LocalPlayer.Character
    if not character then return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local animator = humanoid and humanoid:FindFirstChildOfClass("Animator")
    if not animator then return end
    for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
        local name = tostring(track.Name):lower()
        -- SZKHUB detenía también ammo/blood/heal; aquí solo las
        -- animaciones relacionadas con abrir/usar cajas.
        if name:find("crate", 1, true) or name:find("use", 1, true) then
            pcall(function() track:Stop(0) end)
        end
    end
end

State.CrateController = getModule("Modules", "Game", "CrateSystem", "Crate")
State.UtilModule = getModule("Modules", "Core", "Util")

-- La función original reemplaza Util.tween para acortar los tweens
-- de NumberValue con propiedad Value = 1 mientras la opción está activa.
if State.UtilModule and type(State.UtilModule.tween) == "function" then
    State.OriginalTween = State.UtilModule.tween
    State.WrappedTween = function(instance, tweenInfo, properties, ...)
        if State.Enabled
            and instance
            and instance:IsA("NumberValue")
            and typeof(tweenInfo) == "TweenInfo"
            and type(properties) == "table"
            and properties.Value == 1
            and tweenInfo.Time > 0 then
            tweenInfo = TweenInfo.new(0, tweenInfo.EasingStyle, tweenInfo.EasingDirection)
        end
        return State.OriginalTween(instance, tweenInfo, properties, ...)
    end
    State.UtilModule.tween = State.WrappedTween
end

State.StepConnection = RunService.Stepped:Connect(function()
    if State.Running and State.Enabled then
        pcall(stopCrateAnimations)
    end
end)

task.spawn(function()
    while State.Running do
        task.wait(0.1)
        if State.Enabled and State.CrateController then
            pcall(function()
                local controller = State.CrateController
                local objects = controller.class and controller.class.objects
                if type(objects) == "table" then
                    for _, crate in pairs(objects) do
                        local open = crate.states and crate.states.open
                        if open and type(open.set) == "function" then
                            open.set(true)
                        end
                    end
                end
                local skipping = controller.skipping
                if skipping and type(skipping.set) == "function" then
                    skipping.set(true)
                end
            end)
        end
    end
end)

local API = {}

function API.SetEnabled(on)
    if not State.Running then return false end
    State.Enabled = (on == true)
    print("[CHINO Auto Skip Crate] " .. (State.Enabled and "ON" or "OFF"))
    return State.Enabled
end

function API.IsEnabled()
    return State.Enabled
end

function API.GetStatus()
    return {
        enabled = State.Enabled,
        crateModuleFound = State.CrateController ~= nil,
        tweenModuleFound = State.UtilModule ~= nil,
        tweenHooked = State.WrappedTween ~= nil,
    }
end

function API.Destroy()
    State.Enabled = false
    State.Running = false
    if State.StepConnection then
        State.StepConnection:Disconnect()
        State.StepConnection = nil
    end
    if State.UtilModule and State.UtilModule.tween == State.WrappedTween then
        State.UtilModule.tween = State.OriginalTween
    end
    if ENV.CHINO_AutoSkipCrate == API then
        ENV.CHINO_AutoSkipCrate = nil
    end
end

ENV.CHINO_AutoSkipCrate = API
API.SetEnabled(false) -- OFF por defecto, lo controla el toggle de Farm

if not State.CrateController then
    warn("[CHINO Auto Skip Crate] No se encontró Modules.Game.CrateSystem.Crate")
end

-- API integrada en el HUB (sin return del chunk principal).

end

--====================================================================--
-- FARM • AUTOWIN2 (ATM / PESCA) | CURSOR OCULTO AUTOMATICAMENTE
-- Adaptación de CHINOINFIERNO ATM/FISHING V5 y clicker V12.
-- Click izquierdo VIRTUAL normal cuando aguja y objetivo se superponen.
-- El cursor visual se oculta SOLO durante el minijuego (si se puede).
-- No fuerza el éxito ni modifica comunicaciones con el servidor.
--====================================================================--
do
    local st = {
        Enabled=false, MouseWasHidden=false,
        MouseIconBefore=true, Slider=nil, Needle=nil, Target=nil,
        TargetX=nil, Clicked=false, LastClick=0, LastOutside=0,
        Total=0, LastStatusAt=0, StatusLabel=nil,
        Status="En espera", VIM=nil,
    }
    pcall(function() st.VIM = game:GetService("VirtualInputManager") end)

    local function setMouseHidden(shouldHide)
        if shouldHide then
            if not st.MouseWasHidden then
                local ok, wasEnabled = pcall(function() return UserInputService.MouseIconEnabled end)
                if ok then st.MouseIconBefore=wasEnabled end
                st.MouseWasHidden=true
            end
            pcall(function() UserInputService.MouseIconEnabled=false end)
        elseif st.MouseWasHidden then
            st.MouseWasHidden=false
            pcall(function() UserInputService.MouseIconEnabled=st.MouseIconBefore end)
        end
    end

    local function status(message)
        st.Status=message
        if st.StatusLabel and os.clock()-st.LastStatusAt>0.22 then
            st.StatusLabel.Text="ESTADO: "..message
            st.LastStatusAt=os.clock()
        end
    end

    local function visible(guiObject)
        local p=guiObject
        while p and p~=PlayerGui do
            if p:IsA("GuiObject") and not p.Visible then return false end
            if p:IsA("ScreenGui") and not p.Enabled then return false end
            p=p.Parent
        end
        return true
    end

    local function findTargets(slider)
        local needles, targets={},{}
        for _,obj in ipairs(slider:GetDescendants()) do
            if obj:IsA("Frame") and visible(obj) then
                local sz=obj.AbsoluteSize
                if sz.X>=1 and sz.X<=8 and sz.Y>=15 and sz.Y<=75 then
                    needles[#needles+1]=obj
                elseif sz.X>=15 and sz.X<=260 and sz.Y>=15 and sz.Y<=75 then
                    targets[#targets+1]=obj
                end
            end
        end
        local selectedNeedle, selectedTarget, bestScore
        for _,needle in ipairs(needles) do
            local y=needle.AbsolutePosition.Y+needle.AbsoluteSize.Y/2
            for _,target in ipairs(targets) do
                local targetY=target.AbsolutePosition.Y+target.AbsoluteSize.Y/2
                local delta=math.abs(targetY-y)
                if delta <= (needle.AbsoluteSize.Y+target.AbsoluteSize.Y)/2+6 then
                    local score=delta + (target.AbsoluteSize.X>80 and 0.3 or 0)
                    if not bestScore or score<bestScore then
                        bestScore=score
                        selectedNeedle=needle
                        selectedTarget=target
                    end
                end
            end
        end
        return selectedTarget,selectedNeedle
    end

    local function normalClick()
        local camera=workspace.CurrentCamera
        if not camera then return false end
        local size=camera.ViewportSize
        local x,y=math.floor(size.X/2), math.floor(size.Y/2)
        if st.VIM then
            local ok=pcall(function()
                st.VIM:SendMouseButtonEvent(x,y,0,true,game,0)
                st.VIM:SendMouseButtonEvent(x,y,0,false,game,0)
            end)
            if ok then return true end
        end
        if type(mouse1click)=="function" then
            return pcall(mouse1click)
        elseif type(mouse1press)=="function" and type(mouse1release)=="function" then
            return pcall(function() mouse1press(); mouse1release() end)
        end
        return false
    end

    local function resetTarget()
        st.Slider=nil; st.Needle=nil; st.Target=nil
        st.TargetX=nil; st.Clicked=false; st.LastOutside=0
    end

    SettingsVisual.FarmAutoClick = {
        SetEnabled=function(value)
            st.Enabled=value==true
            if not st.Enabled then
                resetTarget(); setMouseHidden(false)
                status("Desactivado")
            else
                status("Esperando SliderMinigame")
            end
        end,
        GetState=function() return st end,
        Stop=function() st.Enabled=false; resetTarget(); setMouseHidden(false) end,
    }

    -- Un solo render loop, sin inyectar eventos cuando no hay minijuego.
    RunService.RenderStepped:Connect(function()
        if not st.Enabled then return end
        local slider=PlayerGui:FindFirstChild("SliderMinigame")
        if not slider or not visible(slider) then
            if st.Slider then resetTarget(); status("Esperando minijuego") end
            setMouseHidden(false)
            return
        end

        setMouseHidden(true)
        local target,needle=findTargets(slider)
        if not target or not needle then
            resetTarget()
            st.Slider=slider
            status("Minijuego detectado; buscando aguja/zona verde")
            return
        end

        if st.Slider~=slider or st.Target~=target or st.Needle~=needle then
            resetTarget()
            st.Slider=slider; st.Target=target; st.Needle=needle
        end
        local x1=target.AbsolutePosition.X
        local x2=x1+target.AbsoluteSize.X
        local needleX=needle.AbsolutePosition.X+needle.AbsoluteSize.X/2
        local currentX=math.floor(x1+0.5)
        if st.TargetX==nil or math.abs(currentX-st.TargetX)>3 then
            st.TargetX=currentX
            st.Clicked=false
        end
        local now=os.clock()
        local aligned=needleX>=x1 and needleX<=x2
        if not aligned then
            st.LastOutside=now
            status("Aguja fuera del objetivo")
            return
        end
        if st.Clicked or now-st.LastClick<0.15 then
            status("Esperando siguiente objetivo")
            return
        end
        st.LastClick=now
        if normalClick() then
            st.Clicked=true
            st.Total+=1
            status("Clic normal enviado")
        else
            status("Entrada de mouse no disponible en este ejecutor")
        end
    end)

    -- Controles dentro del mismo panel Farm, con guardado de Config habitual.
    MakeToggle(SettingsVisual.FarmLeft, "AUTOWIN2", false, function(v)
        SettingsVisual.FarmAutoClick.SetEnabled(v)
    end)
    local label=Instance.new("TextLabel")
    label.Size=UDim2.new(1,0,0,28)
    label.BackgroundTransparency=1
    label.TextColor3=Color3.fromRGB(172,194,230)
    label.Font=Enum.Font.Gotham
    label.TextSize=10
    label.TextWrapped=true
    label.TextXAlignment=Enum.TextXAlignment.Left
    label.TextYAlignment=Enum.TextYAlignment.Top
    label.ZIndex=9
    label.Text="ESTADO: En espera"
    label.Parent=SettingsVisual.FarmLeft
    st.StatusLabel=label
end

-- Auto Skip Crate V2, reemplaza el viejo Skip Cajas de Misc.
MakeToggle(SettingsVisual.FarmRight, "Skip Cajas", false, function(v)
    SkipCratesEnabled=v and true or false
    local env=(type(getgenv)=="function" and getgenv() or _G)
    local api=env.CHINO_AutoSkipCrate
    if api and type(api.SetEnabled)=="function" then api.SetEnabled(v) end
end)


--========================================================--
-- CHINO GUN AURA / CHINO INFINITE HOTBAR / INFINITE RANGE /
-- INFINITE FIRE RATE / AUTOMATIC MODE
-- Funciones encapsuladas; no reemplazan el motor CHINO actual.
--========================================================--

-- GUN AURA: sustituto de Hit Aura de puños.
-- Funciona exclusivamente con arma equipada y el mismo objetivo del Silent Aim.
 -- Se usa el mismo evento shoot_gun y su hook existente para no sustituir
 -- predicción, Head/Neck/Chest ni Target Line del HUB.
--========================================================--
-- CHINOINFIERNO V3: AUTO SHOOT MANUAL 360 / 90 METROS / SOLO ARMADOS
-- Ambas casillas (menu + panel tactil) habilitan la misma busqueda:
-- * 90 metros alrededor, incluso detras de la CAMARA (no tras paredes).
-- * Enemigos vivos CON ARMA DE FUEGO visible en inventario/equipada.
-- * Nunca dispara si detecta ForceField, atributo o zona segura reconocible.
-- * Cadencia normal del arma / ajustes actuales de Misc, SIN auto-burst turbo.
-- * Un intento por cadencia, hasta agotarse el cargador; no recarga falsa.
-- * A pie: solo objetivos con armas Epic/Legendary confirmadas por el escáner.
-- * En carro: conserva la detección actual de cualquier arma de fuego.
-- * La casilla DERECHA TPx3 conserva sus visitas y disparos dedicados.
-- La verificacion de zona segura depende de los datos que el juego replique.
--========================================================--
SettingsVisual.AutoShootHasLineOfSight = function(ownHead, ownChar, enemyChar, enemyPart)
    if not ownHead or not enemyChar or not enemyPart then return false end
    local delta = enemyPart.Position - ownHead.Position
    if delta.Magnitude < 0.01 then return true end
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.IgnoreWater = true
    local ignore = {ownChar}
    -- El propio chasis no debe obstruir un disparo desde el asiento.
    local ownHum = ownChar and ownChar:FindFirstChildOfClass("Humanoid")
    local seat = ownHum and ownHum.SeatPart
    if seat then
        local folder = workspace:FindFirstChild("Vehicles")
        local current = seat
        while current and folder and current.Parent ~= folder and current ~= workspace do
            current = current.Parent
        end
        if current and folder and current.Parent == folder then
            table.insert(ignore, current)
        elseif seat:FindFirstAncestorOfClass("Model") then
            table.insert(ignore, seat:FindFirstAncestorOfClass("Model"))
        end
    end
    params.FilterDescendantsInstances = ignore
    pcall(function() params.RespectCanCollide = true end)
    local hit = workspace:Raycast(ownHead.Position, delta, params)
    return hit == nil or (hit.Instance and hit.Instance:IsDescendantOf(enemyChar)) or false
end

-- El ESP Armas ya lee ItemsFolder.gun, getWeaponData y el Backpack observable.
-- Reutilizamos exactamente esas fuentes, pero excluimos puños, melee y consumibles.
-- ESCANER COMPARTIDO DEL ESP ARMAS Y AUTO SHOOT:
-- Observa Tool en Character, Backpack y carpetas de inventario que Roblox
-- realmente replique a este cliente. No obtiene datos privados del servidor.
-- «VISTO» = se observó antes, NO confirma que siga en su mochila.
-- ESP ICONOS RESTAURADOS: priorizar la imagen REAL del catalogo Items.
-- El scan anterior elegia ImageId del Tool antes de getWeaponData, y
-- pasaba un icono marcador o un asset inexistente (X) al ImageLabel.
-- No se modifica aqui la deteccion ni el disparo de Auto Shoot.


local function ChinoIconoDePlantilla(obj)
    if not obj then return nil end
    -- ImageId y TextureId son dos campos diferentes usados en tools.
    for _,att in ipairs({"ImageId", "IconId", "IconImage", "Image", "Icon"}) do
        local icon=ChinoNormalizarIcono(obj:GetAttribute(att))
        if icon then return icon end
    end
    if obj:IsA("Tool") then
        local icon=ChinoNormalizarIcono(obj.TextureId)
        if icon then return icon end
    end
    -- Algunos templates muestran su icono mediante un ImageLabel interno.
    local ui=obj:FindFirstChildWhichIsA("ImageLabel", true)
    if ui then
        local icon=ChinoNormalizarIcono(ui.Image)
        if icon then return icon end
    end
    return nil
end

local ChinoIndiceIconosItems={}
local ChinoIndiceIconosDirty=true
if ItemsFolder then
    ItemsFolder.DescendantAdded:Connect(function(obj)
        if obj:IsA("Tool") then ChinoIndiceIconosDirty=true end
    end)
    ItemsFolder.DescendantRemoving:Connect(function(obj)
        if obj:IsA("Tool") then ChinoIndiceIconosDirty=true end
    end)
    -- Some folders/tools receive ImageId after being parented.
    for _,obj in ipairs(ItemsFolder:GetDescendants()) do
        if obj:IsA("Tool") then
            obj:GetAttributeChangedSignal("ImageId"):Connect(function()
                ChinoIndiceIconosDirty=true
            end)
        end
    end
    ItemsFolder.DescendantAdded:Connect(function(obj)
        if obj:IsA("Tool") then
            obj:GetAttributeChangedSignal("ImageId"):Connect(function()
                ChinoIndiceIconosDirty=true
            end)
        end
    end)
end
local function ChinoBuscarIconoCatalogo(tool)
    if not ItemsFolder or not tool then return nil end
    if ChinoIndiceIconosDirty then
        ChinoIndiceIconosDirty=false
        ChinoIndiceIconosItems={}
        for _,sample in ipairs(ItemsFolder:GetDescendants()) do
            if sample:IsA("Tool") then
                local image=ChinoIconoDePlantilla(sample)
                if image then
                    local name=sample.Name:lower()
                    local rarity=tostring(sample:GetAttribute("RarityName") or ""):lower()
                    local byName=ChinoIndiceIconosItems[name]
                    if not byName then
                        byName={}
                        ChinoIndiceIconosItems[name]=byName
                    end
                    byName[rarity]=image
                    if not byName["_"] then byName["_"]=image end
                end
            end
        end
    end
    local group=ChinoIndiceIconosItems[tool.Name:lower()]
    if not group then return nil end
    local rarity=tostring(tool:GetAttribute("RarityName") or ""):lower()
    return group[rarity] or group["_"]
end

local function ChinoObtenerImagenOriginal(tool,db,template)
    -- Antes de la ampliacion del Backpack se usaba esta base y SI daba
    -- los iconos correctos para la mayoria de armas y objetos.
    -- Primero la misma DB por mesh/rareza que usaba el ESP original.
    local icon=ChinoNormalizarIcono(db and db.ImageId)
    if icon then return icon end
    -- Segundo el catalogo original de BlockSpin, por nombre + rareza.
    icon=ChinoIconoDePlantilla(template)
    if icon then return icon end
    icon=ChinoBuscarIconoCatalogo(tool)
    if icon then return icon end
    -- El item puede tener una textura original aunque no exista plantilla.
    icon=ChinoIconoDePlantilla(tool)
    if icon then return icon end
    return "" -- nunca crear X: usar etiqueta con el nombre.
end

SettingsVisual.ChinoPublicWeaponCache = setmetatable({}, {__mode="k"})
SettingsVisual.ChinoPreviouslySeenTools = setmetatable({}, {__mode="k"})
SettingsVisual.ChinoWeaponObservedSeconds = 80

SettingsVisual.GetChinoPublicWeaponScan = function(other)
    if not other or other == Player then return {} end
    local cache=SettingsVisual.ChinoPublicWeaponCache
    local now=os.clock()
    local prior=cache[other]
    if prior and now-(prior.At or 0)<0.22 then return prior.Tools end

    local gunFolder=ItemsFolder and ItemsFolder:FindFirstChild("gun")
    local known={
        glock=true,mp5=true,draco=true,ak47=true,anaconda=true,
        p226=true,m24=true,uzi=true,g3=true,c9=true,sawnoff=true,
        remington=true,["double barrel"]=true,["hunting rifle"]=true,
        rpg=true,["desert eagle"]=true,m4=true,m16=true,scar=true
    }
    local results,seen={},{}
    local function addTool(tool,source)
        if not tool:IsA("Tool") or tool.Name=="Fists" then return end
        if seen[tool] then return end
        seen[tool]=true
        local ok,meta=pcall(getWeaponData,tool)
        local db=ok and meta or nil
        local template=gunFolder and gunFolder:FindFirstChild(tool.Name,true)
        local name=tool.Name:lower()
        local typ=tostring(tool:GetAttribute("ItemType") or tool:GetAttribute("Type") or ""):lower()
        local isGun=template~=nil or known[name] or typ=="gun" or typ=="firearm"
            or tool:GetAttribute("AmmoType")~=nil or tool:GetAttribute("current_ammo")~=nil
            or name:find("pistol",1,true) or name:find("rifle",1,true)
            or name:find("shotgun",1,true) or name:find("revolver",1,true)
            or name:find("smg",1,true) or name:find("sniper",1,true)

        -- La rareza debe proceder del objeto real o de una coincidencia de
        -- getWeaponData. No atribuir una legendaria por compartir nombre.
        local rarity=tostring(tool:GetAttribute("RarityName")
            or tool:GetAttribute("Rarity")
            or (db and db.Rarity) or "Unknown")
        local r=rarity:lower()
        local rank=0
        if r:find("omega",1,true) then rank=3
        elseif r:find("legendary",1,true) or r:find("legendaria",1,true) then rank=2
        elseif r:find("epic",1,true) or r:find("épica",1,true)
            or r:find("epica",1,true) or r:find("morada",1,true)
            or r:find("purple",1,true) then rank=1 end

        -- Solo arma real; imagen del catálogo original de ARMAS.
        -- Mantener el icono de getWeaponData antes de probar campos no verificados.
        local img=""
        if isGun then
            img=ChinoNormalizarIcono(db and db.ImageId)
                or ChinoIconoDePlantilla(template)
                or ChinoBuscarIconoCatalogo(tool)
                or ""
        end
        table.insert(results,{Tool=tool,Name=tool.Name,Rarity=rarity,Rank=rank,
            ImageId=img,IsGun=isGun,Source=source,Current=true})
    end

    local char=other.Character
    if char then
        for _,tool in ipairs(char:GetChildren()) do addTool(tool,"Equipped") end
    end
    local bag=other:FindFirstChild("Backpack")
    if bag then
        for _,tool in ipairs(bag:GetChildren()) do addTool(tool,"Backpack") end
    end
    -- Si el juego publica un inventario transportado bajo Player/Character,
    -- mostrarlo antes de que se equipe. Puede no existir en BlockSpin.
    for _,owner in ipairs({other,char}) do
        if owner then
            for _,folderName in ipairs({"CarriedItems","CarriedInventory",
                "Hotbar","InventoryItems","Inventory","Tools"}) do
                local container=owner:FindFirstChild(folderName)
                if container and (container:IsA("Folder") or container:IsA("Model")) then
                    local checked=0
                    for _,obj in ipairs(container:GetDescendants()) do
                        checked+=1
                        if checked>220 then break end
                        if obj:IsA("Tool") then addTool(obj,"Inventory") end
                    end
                end
            end
        end
    end
    -- Mantener solo lo que se ha visto de verdad; sin inventar lo que hay
    -- dentro de un baúl privado o Backpack ajeno no replicado.
    local last=SettingsVisual.ChinoPreviouslySeenTools[other]
    if not last then
        last={}
        SettingsVisual.ChinoPreviouslySeenTools[other]=last
    end
    for _,info in ipairs(results) do
        if info.Source=="Equipped" or info.Source=="Backpack" or info.Source=="Inventory" then
            local id=info.Name..":"..info.Rarity
            -- Mantener imagen valida observada antes de equipar/guardar.
            local prev=last[id]
            local img=ChinoNormalizarIcono(info.ImageId) or ""
            if img=="" and prev then img=ChinoNormalizarIcono(prev.ImageId) or "" end
            last[id]={At=now,Name=info.Name,ImageId=img or "",
                Rarity=info.Rarity,Rank=info.Rank,IsGun=info.IsGun}
        end
    end
    cache[other]={At=now,Tools=results}
    return results
end

-- Lista para ESP y selector: herramientas REALES primero, y memoria visual
-- reciente después, señalada como «Visto» para no confundirla con mochila.
-- ESP y selectores: solo armas confirmadas ACTUALMENTE en Character,
-- Backpack accesible o inventario público replicado. Sin memoria «Visto».
SettingsVisual.GetChinoWeaponVisuals = function(other)
    local current={}
    for _,info in ipairs(SettingsVisual.GetChinoPublicWeaponScan(other)) do
        if info.IsGun and info.Current then table.insert(current,info) end
    end
    table.sort(current,function(x,y)
        if x.Rank~=y.Rank then return x.Rank>y.Rank end
        if x.Source~=y.Source then return x.Source=="Equipped" end
        return x.Name<y.Name
    end)
    return current
end

--========================================================--
-- ESP ARMAS | ALERTAS LEGENDARY / OMEGA
-- Detecta únicamente Tools reales expuestos por el juego. El arma debe
-- llevar rareza explícita Legendary/Omega: no se adivina por llamarse RPG.
-- Reutiliza la voz slowed de arranque y no reproduce un sonido cada frame.
--========================================================--
do
    local alertsGui = Instance.new("ScreenGui")
    alertsGui.Name = "CHINO_RareWeaponAlerts"
    alertsGui.ResetOnSpawn = false
    alertsGui.IgnoreGuiInset = true
    alertsGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    alertsGui.DisplayOrder = 110
    alertsGui.Parent = SettingsVisual.ExecutorGuiParent or PlayerGui

    local seenTools = setmetatable({}, {__mode="k"})
    local recentlyPlayed = {}
    local lastVoice = -1000
    local activeNotice = nil
    local serial = 0

    local function flashLegendary(other, info)
        if not alertsGui or not alertsGui.Parent then return end
        serial += 1
        local thisNotice = serial
        if activeNotice then
            activeNotice:Destroy()
            activeNotice = nil
        end
        local omega = info.Rank == 3
        local mainColor = omega and Color3.fromRGB(244, 54, 124)
            or Color3.fromRGB(255, 189, 76)
        local secondColor = omega and Color3.fromRGB(146, 79, 255)
            or Color3.fromRGB(132, 80, 255)

        local frame = Instance.new("Frame")
        frame.Name = "RareWeaponToast"
        frame.AnchorPoint = Vector2.new(0.5, 0)
        frame.Position = UDim2.new(0.5, 0, 0.11, -24)
        frame.Size = UDim2.fromOffset(300, 58)
        frame.BackgroundColor3 = Color3.fromRGB(15, 11, 36)
        frame.BackgroundTransparency = 1
        frame.BorderSizePixel = 0
        frame.ClipsDescendants = false
        frame.Parent = alertsGui
        activeNotice = frame
        Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)
        local scale = Instance.new("UIScale", frame)
        scale.Scale = 0.84
        local outline = Instance.new("UIStroke", frame)
        outline.Color = mainColor
        outline.Thickness = 1.8
        outline.Transparency = 1
        local gradient = Instance.new("UIGradient", frame)
        gradient.Color = ColorSequence.new(Color3.fromRGB(15, 10, 35), secondColor)
        gradient.Rotation = 12
        local label = Instance.new("TextLabel", frame)
        label.BackgroundTransparency = 1
        label.Size = UDim2.new(1, -26, 0, 25)
        label.Position = UDim2.fromOffset(13, 6)
        label.Text = (omega and "OMEGA" or "LEGENDARY") .. "  •  " .. tostring(info.Name)
        label.TextTruncate = Enum.TextTruncate.AtEnd
        label.Font = Enum.Font.GothamBlack
        label.TextSize = 16
        label.TextColor3 = mainColor
        label.TextXAlignment = Enum.TextXAlignment.Center
        local sub = Instance.new("TextLabel", frame)
        sub.BackgroundTransparency = 1
        sub.Position = UDim2.fromOffset(13, 33)
        sub.Size = UDim2.new(1, -26, 0, 16)
        sub.Font = Enum.Font.GothamMedium
        sub.TextSize = 11
        sub.TextColor3 = Color3.fromRGB(220, 210, 248)
        sub.TextTruncate = Enum.TextTruncate.AtEnd
        sub.Text = "DETECTED  //  " .. tostring(other.Name)
        local line = Instance.new("Frame", frame)
        line.BorderSizePixel = 0
        line.Size = UDim2.new(0.7, 0, 0, 2)
        line.Position = UDim2.new(0.15, 0, 1, -3)
        line.BackgroundColor3 = mainColor
        local lineGradient = Instance.new("UIGradient", line)
        lineGradient.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.5, 0),
            NumberSequenceKeypoint.new(1, 1)
        })
        TweenService:Create(frame, TweenInfo.new(0.34, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
            {Position=UDim2.new(0.5,0,0.11,0), BackgroundTransparency=0.25}):Play()
        TweenService:Create(outline, TweenInfo.new(0.38), {Transparency=0.08}):Play()
        TweenService:Create(scale, TweenInfo.new(0.42, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
            {Scale=1}):Play()

        for i=1,11 do
            local particle = Instance.new("Frame")
            particle.Name = "AuraSpark"
            particle.AnchorPoint = Vector2.new(0.5,0.5)
            particle.Position = UDim2.new(0.5,0,0.5,0)
            particle.Size = UDim2.fromOffset(i%3+3,i%3+3)
            particle.BackgroundColor3 = i%2==0 and mainColor or secondColor
            particle.BackgroundTransparency = 0.15
            particle.BorderSizePixel = 0
            particle.Rotation = 45
            particle.Parent = frame
            Instance.new("UICorner", particle).CornerRadius = UDim.new(0,2)
            local a = i * (math.pi*2/11)
            TweenService:Create(particle, TweenInfo.new(0.95 + (i%3)*0.17,
                Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Position=UDim2.new(0.5,math.cos(a)*186,0.5,math.sin(a)*46),
                BackgroundTransparency=1,
                Rotation=225
            }):Play()
        end
        task.delay(3.2, function()
            if thisNotice~=serial or not frame.Parent then return end
            TweenService:Create(frame,TweenInfo.new(0.36), {
                Position=UDim2.new(0.5,0,0.11,-16),BackgroundTransparency=1
            }):Play()
            TweenService:Create(outline,TweenInfo.new(0.30), {Transparency=1}):Play()
            task.wait(0.42)
            if frame then frame:Destroy() end
            if activeNotice==frame then activeNotice=nil end
        end)
    end

    -- Funciona aunque el usuario tenga ESP Armas apagado, porque el escáner
    -- de armas del HUB sirve también a los selectores de jugadores.
    task.spawn(function()
        while Gui and Gui.Parent and alertsGui and alertsGui.Parent do
            task.wait(1.1)
            local now = os.clock()
            for _, other in ipairs(Players:GetPlayers()) do
                if other ~= Player then
                    local ok, infos=pcall(SettingsVisual.GetChinoPublicWeaponScan, other)
                    if ok and type(infos)=="table" then
                        for _, info in ipairs(infos) do
                            if info.IsGun and info.Current and (info.Rank==2 or info.Rank==3)
                                and info.Tool and info.Tool.Parent then
                                -- La misma instancia del arma no dispara de nuevo
                                -- al pasar de Backpack a Character.
                                local old = seenTools[info.Tool]
                                if old ~= info.Rank then
                                    seenTools[info.Tool] = info.Rank
                                    local key = tostring(other.UserId)..":"
                                        ..tostring(info.Name)..":"..tostring(info.Rarity)
                                    if now-(recentlyPlayed[key] or -1000) > 22 then
                                        recentlyPlayed[key] = now
                                        if now-lastVoice > 8 then
                                            lastVoice = now
                                            pcall(SettingsVisual.PlayStartupSound)
                                        end
                                        task.spawn(function()
                                            pcall(flashLegendary,other,info)
                                        end)
                                    end
                                end
                            end
                        end
                    end
                end
            end
            -- Evita guardar claves de usuarios indefinidamente.
            if math.floor(now)%90==0 then
                for k,t in pairs(recentlyPlayed) do
                    if now-t>100 then recentlyPlayed[k]=nil end
                end
            end
        end
        if alertsGui then alertsGui:Destroy() end
    end)
end

-- La selección de tiro NO utiliza observaciones antiguas (Visto).
-- A pie requiere arma ÉPICA (morada) o LEGENDARIA comprobada.
-- En coche mantiene la selección anterior de cualquier arma de fuego.
SettingsVisual.AutoShootArmedInfo = function(other,requireEpicLegendary)
    local best=nil
    for _,info in ipairs(SettingsVisual.GetChinoPublicWeaponScan(other)) do
        if info.IsGun and (not requireEpicLegendary or info.Rank==1 or info.Rank==2) then
            if not best or info.Rank>best.Rank
                or (info.Rank==best.Rank and info.Source=="Equipped") then
                best=info
            end
        end
    end
    return best
end

-- Protecciones observables: servidor puede tener nombres distintos.
SettingsVisual.AutoShootIsSafe = function(other, char, enemyRoot)
    if not other or not char or not enemyRoot then return true end
    if char:FindFirstChildOfClass("ForceField") then return true end
    local flags={
        "SafeZone", "InSafeZone", "IsInSafeZone", "InSafeArea", "IsSafe",
        "Protected", "IsProtected", "Invulnerable", "SpawnProtected",
        "SpawnProtection", "SafeZoneActive", "SafeArea", "InProtectionZone",
        "SpawnShield", "InSafezone", "Safe", "Shielded"
    }
    local hum=char:FindFirstChildOfClass("Humanoid")
    local function truthy(v)
        return v==true or v==1 or v=="true" or v=="True" or v=="1"
    end
    for _,obj in ipairs({other,char,hum,enemyRoot}) do
        if obj then
            for _,key in ipairs(flags) do
                if truthy(obj:GetAttribute(key)) then return true end
                local flag=obj:FindFirstChild(key)
                if flag and (flag:IsA("BoolValue") or flag:IsA("IntValue")
                    or flag:IsA("NumberValue") or flag:IsA("StringValue"))
                    and truthy(flag.Value) then return true end
            end
        end
    end
    for _,key in ipairs({"SafeZoneShield","SpawnProtection","SafeShield","ProtectionField"}) do
        local marker=char:FindFirstChild(key,true)
        if marker then
            if marker:IsA("BoolValue") or marker:IsA("IntValue") or marker:IsA("NumberValue")
                or marker:IsA("StringValue") then
                if truthy(marker.Value) then return true end
            elseif marker:IsA("BillboardGui") or marker:IsA("Highlight") then
                if marker.Enabled then return true end
            else
                return true
            end
        end
    end

    -- Zonas de seguridad que estén representadas por Parts o tags públicos.
    local state=SettingsVisual.AutoShootSafeZones
    if os.clock() >= state.RefreshAt then
        state.RefreshAt=os.clock()+3
        state.Parts={}
        local seen={}
        local function collect(node)
            if not node or seen[node] then return end
            seen[node]=true
            if node:IsA("BasePart") then
                if node.Size.X>=6 and node.Size.Z>=6 then
                    table.insert(state.Parts,node)
                end
            elseif node:IsA("Model") or node:IsA("Folder") then
                for _,child in ipairs(node:GetDescendants()) do
                    if child:IsA("BasePart") and not seen[child]
                        and child.Size.X>=6 and child.Size.Z>=6 then
                        seen[child]=true
                        table.insert(state.Parts,child)
                    end
                end
            end
        end
        for _,name in ipairs({"SafeZone","SafeZones","SafeArea","SafeAreas","ProtectionZone"}) do
            collect(workspace:FindFirstChild(name))
        end
        local zones=workspace:FindFirstChild("Zones")
        if zones then
            for _,obj in ipairs(zones:GetChildren()) do
                if obj.Name:lower():find("safe",1,true)
                    or obj.Name:lower():find("protect",1,true) then collect(obj) end
            end
        end
        local ok,service=pcall(function() return game:GetService("CollectionService") end)
        if ok then
            for _,tag in ipairs({"SafeZone","SafeArea","ProtectionZone"}) do
                for _,obj in ipairs(service:GetTagged(tag)) do collect(obj) end
            end
        end
    end
    for _,part in ipairs(state.Parts) do
        if part and part.Parent then
            local pos=part.CFrame:PointToObjectSpace(enemyRoot.Position)
            local x,z=part.Size.X/2,part.Size.Z/2
            -- Acepta pisos finos delimitadores (personaje elevado de la base).
            local yLower=-math.max(part.Size.Y/2,6)
            local yUpper=math.max(part.Size.Y/2,24)
            if math.abs(pos.X)<=x and math.abs(pos.Z)<=z
                and pos.Y>=yLower and pos.Y<=yUpper then return true end
        end
    end
    return false
end

-- 360 grados, solamente enemigos visibles/armados/fuera de zona segura.
SettingsVisual.AutoShootIsValidTarget = function(other, ownChar, ownRoot, ownHead, range)
    if not other or other==Player or SettingsVisual.IsSafeFriend(other)
        or other:GetAttribute("SilentAimIgnore") then return nil end
    local char=other.Character
    local hum=char and char:FindFirstChildOfClass("Humanoid")
    local root=char and char:FindFirstChild("HumanoidRootPart")
    local head=char and char:FindFirstChild("Head")
    if not hum or hum.Health<=0 or not root or not head then return nil end
    local distance=(root.Position-ownRoot.Position).Magnitude
    if distance>range then return nil end
    -- A pie: solo enemigos con armas Epic/Legendary observables.
    -- Dentro del vehículo: conserva la selección previa de cualquier arma.
    local ownHum=ownChar and ownChar:FindFirstChildOfClass("Humanoid")
    local seated=ownHum and ownHum.SeatPart
    local onFoot=not (seated and seated:IsA("VehicleSeat"))
    -- Reset del selector = AUTO: cualquier arma real, NO consumibles.
    -- Con selección manual a pie se conserva el filtro previo Epic/Legendary.
    local requireRare=onFoot and SettingsVisual.AutoShootSelectedPlayer~=nil
    local gun=SettingsVisual.AutoShootArmedInfo(other,requireRare)
    if not gun then return nil end
    if SettingsVisual.AutoShootIsSafe(other,char,root) then return nil end
    if not SettingsVisual.AutoShootHasLineOfSight(ownHead,ownChar,char,head) then return nil end
    return {Player=other,Head=head,Distance=distance,Gun=gun}
end

SettingsVisual.FindAutoShootTarget = function()
    local ownChar=Player.Character
    local ownRoot=ownChar and ownChar:FindFirstChild("HumanoidRootPart")
    local ownHead=ownChar and ownChar:FindFirstChild("Head")
    if not ownRoot or not ownHead then return nil end
    local radius=tonumber(SettingsVisual.AutoShootRangeStuds) or (90/0.28)
    -- Modo MANUAL: solo al seleccionado, aun si desaparece tras una pared.
    -- Si no está visible / no tiene arma / está en zona segura, ESPERAR.
    -- Mantener el rango configurado: 90 metros (~321 studs).
    local selected=SettingsVisual.AutoShootSelectedPlayer
    if selected then
        if selected.Parent~=Players then
            SettingsVisual.AutoShootSelectedPlayer=nil
            SettingsVisual.AutoShootLockedTarget=nil
            return nil
        end
        local valid=SettingsVisual.AutoShootIsValidTarget(
            selected,ownChar,ownRoot,ownHead,radius)
        SettingsVisual.AutoShootLockedTarget=valid and selected or nil
        return valid and selected or nil
    end
    -- Modo AUTO: conserva al objetivo válido y evita cambios constantes.
    local locked=SettingsVisual.AutoShootLockedTarget
    if locked and SettingsVisual.AutoShootIsValidTarget(
        locked,ownChar,ownRoot,ownHead,radius) then return locked end
    SettingsVisual.AutoShootLockedTarget=nil
    local closest,score=nil,math.huge
    for _,other in ipairs(Players:GetPlayers()) do
        local candidate=SettingsVisual.AutoShootIsValidTarget(
            other,ownChar,ownRoot,ownHead,radius)
        if candidate then
            -- Cercanía primero; pequeña preferencia para épicas/legendarias.
            local n=candidate.Distance-(candidate.Gun.Rank or 0)*2
            if n<score then closest,score=other,n end
        end
    end
    SettingsVisual.AutoShootLockedTarget=closest
    return closest
end

SettingsVisual.AutoShootReadAmmo = function(gun)
    if not gun then return nil,nil end
    for _,key in ipairs({"current_ammo","CurrentAmmo","ammo","Ammo",
        "clip_ammo","ClipAmmo","magazine_ammo"}) do
        local n=gun:GetAttribute(key)
        if type(n)=="number" and n==n and n>=0 and n<100000 then
            return math.floor(n), key
        end
    end
    return nil,nil
end

SettingsVisual.AutoShootReadMagSize = function(gun)
    for _,key in ipairs({"max_ammo","MaxAmmo","magazine_size","MagazineSize",
        "mag_size","MagSize","clip_size","ClipSize","AmmoCapacity"}) do
        local n=gun:GetAttribute(key)
        if type(n)=="number" and n>0 and n<=200 then
            return math.floor(n)
        end
    end
    -- No inventar un cargador infinito si la munición no es visible.
    return 25
end

SettingsVisual.AutoShootCanUseAmmo = function(gun)
    local ammo,key=SettingsVisual.AutoShootReadAmmo(gun)
    local stores=SettingsVisual.AutoShootMagazineState
    local state=stores[gun]
    if not state then
        state={Remaining=ammo or SettingsVisual.AutoShootReadMagSize(gun),
            Observed=ammo,Attr=key,Shots=0}
        stores[gun]=state
    else
        if ammo~=nil then
            if state.Observed==nil or ammo>state.Observed then
                -- Recarga confirmada por atributo replicado.
                state.Remaining=ammo
            elseif ammo<state.Observed then
                -- El arma bajó munición mientras disparábamos.
                state.Remaining=math.min(state.Remaining,ammo)
            end
            state.Observed=ammo
            state.Attr=key
        end
    end
    if ammo~=nil and ammo<=0 then return false end
    return (state.Remaining or 0)>0
end

-- Cuando el juego NO muestra su munición, permitir un cargador nuevo
-- al activar manualmente Auto Shoot (sin tocar atributos del arma).
SettingsVisual.AutoShootResetManualBudget = function()
    for gun,state in pairs(SettingsVisual.AutoShootMagazineState) do
        if gun and gun.Parent and state.Observed==nil then
            state.Remaining=SettingsVisual.AutoShootReadMagSize(gun)
            state.Shots=0
        end
    end
end

SettingsVisual.AutoShootShotInterval = function(gun)
    -- Atributo REAL del arma, incluyendo modificación de Misc si está ON.
    local fire=gun and gun:GetAttribute("fire_rate")
    if type(fire)~="number" or fire~=fire or fire<=0 then
        local mod=SettingsVisual.QualityXGunMod
        local name=mod and mod.FindFireRateAttribute and mod:FindFireRateAttribute(gun)
        fire=name and gun:GetAttribute(name)
    end
    local sec=0.22
    if type(fire)=="number" and fire==fire and fire>0 then
        if fire<=1 then sec=fire                 -- segundos entre disparos
        elseif fire<=35 then sec=1/fire         -- disparos por segundo
        else sec=60/fire end                    -- disparos por minuto
    end
    -- «Auto Shoot Speed» es un multiplicador suave, NO un modo turbo.
    local multiplier=tonumber(SettingsVisual.AutoShootInterval) or 1
    return math.clamp(sec*math.clamp(multiplier,0.8,1.5),0.12,0.75)
end

-- Un único envío por cadencia, sin suprimir animaciones ni recarga.
SettingsVisual.GunAuraFire = function(forcedRightTPTarget)
    local tpShot=forcedRightTPTarget~=nil
    local autoActive=SettingsVisual.AutoShootEnabled or SettingsVisual.AutoShoot360Enabled
    if not autoActive and not SettingsVisual.GunAuraEnabled then return false end
    if tpShot and not autoActive then return false end
    if not autoActive and not SilentAimEnabled then return false end
    if not SendRemote then return false end

    local char=Player.Character
    local hum=char and char:FindFirstChildOfClass("Humanoid")
    local head=char and char:FindFirstChild("Head")
    local root=char and char:FindFirstChild("HumanoidRootPart")
    if not hum or hum.Health<=0 or not head or not root then return false end
    -- Auto Shoot disponible A PIE y EN VEHÍCULO. El filtro Premium
    -- se aplica por objetivo solamente cuando el jugador va a pie.
    local gun=char:FindFirstChildOfClass("Tool")
    if not gun or gun.Name=="Fists" then return false end
    local folder=ItemsFolder and ItemsFolder:FindFirstChild("gun")
    local template=folder and folder:FindFirstChild(gun.Name,true)
    local mod=SettingsVisual.QualityXGunMod
    if not (template or gun:GetAttribute("AmmoType")~=nil
        or gun:GetAttribute("current_ammo")~=nil
        or (mod and mod:IsGun(gun))) then return false end
    if autoActive and not SettingsVisual.AutoShootCanUseAmmo(gun) then return false end

    local target=forcedRightTPTarget or (autoActive and SettingsVisual.FindAutoShootTarget())
        or SettingsVisual.GetSourceSilentTarget()
    if not target or SettingsVisual.IsSafeFriend(target) or not target.Character then return false end
    local targetChar=target.Character
    local enemyRoot=targetChar:FindFirstChild("HumanoidRootPart")
    local enemyHead=targetChar:FindFirstChild("Head")
    local enemyHum=targetChar:FindFirstChildOfClass("Humanoid")
    if not enemyRoot or not enemyHead or not enemyHum or enemyHum.Health<=0 then return false end

    if autoActive then
        -- También valida el objetivo FORZADO del TP derecho para no atacar
        -- a alguien protegido o si se ocultó tras un muro.
        local limit=tpShot and math.max(85,SettingsVisual.AutoShootRangeStuds)
            or SettingsVisual.AutoShootRangeStuds
        if not SettingsVisual.AutoShootIsValidTarget(
            target,char,root,head,limit) then return false end
    elseif (head.Position-enemyRoot.Position).Magnitude>200 then
        return false -- lógica Gun Aura previa
    end

    local origin=head.Position
    SettingsVisual.AutoShootSendOverride=autoActive and target or nil
    local ok,sent=pcall(function()
        return FireServerHook("shoot_gun",gun,CFrame.new(origin,enemyHead.Position),{
            [1]={{Instance=enemyHead,Normal=Vector3.new(0,1,0),Position=enemyHead.Position}}
        })
    end)
    SettingsVisual.AutoShootSendOverride=nil
    if not ok then
        warn("[CHINO Auto Shoot]",sent)
        return false
    end
    if sent and autoActive then
        local state=SettingsVisual.AutoShootMagazineState[gun]
        if state then
            state.Remaining=math.max(0,(state.Remaining or 0)-1)
            state.Shots=(state.Shots or 0)+1
        end
    end
    return sent==true
end

SettingsVisual.GunAuraHeartbeat = RunService.Heartbeat:Connect(function()
    local autoActive=SettingsVisual.AutoShootEnabled or SettingsVisual.AutoShoot360Enabled
    if not autoActive and not SettingsVisual.GunAuraEnabled then return end
    if SettingsVisual.TouchCarOneShotBusy then return end
    local char=Player.Character
    local hum=char and char:FindFirstChildOfClass("Humanoid")
    -- No bloquear el disparo a pie: se sigue validando salud,
    -- munición, visibilidad, distancia y protección en GunAuraFire.
    if autoActive and (not hum or hum.Health<=0) then return end

    local now=os.clock()
    local gun=char and char:FindFirstChildOfClass("Tool")
    local interval=autoActive and SettingsVisual.AutoShootShotInterval(gun)
        or math.max(0.18,tonumber(SettingsVisual.GunAuraInterval) or 0.18)
    if now<(SettingsVisual.GunAuraLastShot or 0)+interval then return end
    if now<(SettingsVisual.AutoShootScanNext or 0) then return end
    SettingsVisual.AutoShootScanNext=now+0.08
    local ok,sent=pcall(SettingsVisual.GunAuraFire)
    if ok and sent then
        SettingsVisual.GunAuraLastShot=now
    elseif not ok then
        warn("[CHINO Auto Shoot]",sent)
        SettingsVisual.GunAuraLastShot=now
    end
end)

-- TP derecho: mantiene su propia ventana corta. Nunca duplica Heartbeat.
SettingsVisual.TryAutoShootDuringRightTP = function(target,state,maxShots)
    if not (SettingsVisual.AutoShootEnabled or SettingsVisual.AutoShoot360Enabled) then return false end
    if not target or not state then return false end
    maxShots=math.clamp(tonumber(maxShots) or 1,1,2)
    if (state.shots or 0)>=maxShots or (state.attempts or 0)>=maxShots+2 then
        return false
    end
    local now=os.clock()
    if now<(state.nextAt or 0) then return false end
    state.attempts=(state.attempts or 0)+1
    local sent=SettingsVisual.GunAuraFire(target)
    if sent then state.shots=(state.shots or 0)+1 end
    local char=Player.Character
    local gun=char and char:FindFirstChildOfClass("Tool")
    state.nextAt=now+SettingsVisual.AutoShootShotInterval(gun)
    return sent
end

-- No se intercepta get_max_items: interferia con el sistema del inventario.
-- El resto de las opciones sigue separado del flujo de equipar/guardar objetos.

--========================================================--
-- QUALITY X / CHINO V3: MODIFICADOR DE ARMAS SIN CONFLICTOS
-- Arreglo de cambio entre DOS o MAS armas:
--   * Cada arma conserva sus propios atributos originales.
--   * Solo actua sobre el arma EQUIPADA (no reescribe el Backpack).
--   * Restaura el arma anterior al guardarla, y prepara la siguiente.
--   * Cadencia extrema 9999/0.001, sin math.huge ni reload_time=0.
--   * No fuerza atributos cada 0.15 s mientras estas disparando.
--   * No inventa atributos que el arma no tenga: respeta cada chasis.
--   * Cada toggle desactivado restaura SOLO su propia modificacion.
-- Limitacion: el servidor y el controlador del arma validan los disparos.
--========================================================--
do
    local mod = {
        Enabled = false,
        Flags = {Accuracy=true, Range=true, Recoil=true,
                 FireRate=true, Reload=true, Automatic=true},
        -- Llave = instancia Tool; valor = registros especificos de esa arma.
        Originals = setmetatable({}, {__mode="k"}),
        Connections = {},
        CharacterConnections = {},
        Session = 0,
    }
    SettingsVisual.QualityXGunMod = mod

    local function finite(value)
        return type(value)=="number"
            and value==value
            and value~=math.huge and value~=-math.huge
            and math.abs(value)<1000000000
    end

    function mod:FindFireRateAttribute(gun)
        if not gun or not gun:IsA("Tool") then return nil end
        if gun:GetAttribute("fire_rate")~=nil then return "fire_rate" end
        for name in pairs(gun:GetAttributes()) do
            if type(name)=="string" and name:sub(-3)=="486" then return name end
        end
        return nil
    end

    function mod:FindAutomaticAttribute(gun)
        if not gun or not gun:IsA("Tool") then return nil end
        if gun:GetAttribute("automatic")~=nil then return "automatic" end
        for name in pairs(gun:GetAttributes()) do
            if type(name)=="string" and name:sub(-3)=="492" then return name end
        end
        return nil
    end

    function mod:GetAttributeForFeature(gun,feature)
        if feature=="FireRate" then return self:FindFireRateAttribute(gun) end
        if feature=="Automatic" then return self:FindAutomaticAttribute(gun) end
        local names = {
            Accuracy={"accuracy","Accuracy"},
            Range={"range","Range"},
            Recoil={"Recoil","recoil"},
            Reload={"reload_time","ReloadTime"},
        }
        for _,name in ipairs(names[feature] or {}) do
            if gun:GetAttribute(name)~=nil then return name end
        end
        return nil
    end

    function mod:IsGun(tool)
        if not tool or not tool:IsA("Tool") or tool.Name=="Fists" then return false end
        if tool:GetAttribute("AmmoType")~=nil then return true end
        for _,feature in ipairs({"Accuracy","Range","Recoil","FireRate","Reload","Automatic"}) do
            if self:GetAttributeForFeature(tool,feature) then return true end
        end
        return false
    end

    -- Transformaciones moderadas basadas en el atributo ORIGINAL de CADA arma,
    -- sin escribir numeros infinitos que pueden bloquear los disparos.
    function mod:TargetValue(feature, original)
        if feature=="Automatic" then
            if type(original)=="boolean" then return true end
            return nil
        end
        if not finite(original) then return nil end
        if feature=="Accuracy" then
            if original<0 then return nil end
            if original<=1 then return math.max(original,0.95) end
            return math.max(original, math.min(original*1.12,100))
        elseif feature=="Range" then
            if original<=0 then return nil end
            return math.max(original, math.min(original*2,1200))
        elseif feature=="Recoil" then
            if original<0 then return nil end
            return 0
        elseif feature=="FireRate" then
            if original<=0 then return nil end
            -- MODO ANTIGUO ULTRA-RAPIDO. Los controladores que almacenan
            -- segundos entre tiros (<1) usan un retardo minimo positivo;
            -- si almacenan tiros/segundo (>=1), se pide la cadencia 9999.
            -- Sin math.huge, para no crear NaN/cooldowns imposibles.
            -- NO multiplica remotes: gasta solo las balas que acepte el juego.
            if original<1 then
                return 0.001
            end
            return 9999
        elseif feature=="Reload" then
            if original<=0 then return nil end
            return math.min(original,math.max(0.18,original*0.70))
        end
        return nil
    end

    function mod:ApplyFeature(gun, feature)
        if not self.Enabled or not self.Flags[feature]
           or not gun or not gun:IsA("Tool") then return end
        local attribute=self:GetAttributeForFeature(gun, feature)
        if not attribute then return end
        local byFeature=self.Originals[gun]
        if not byFeature then
            byFeature={}
            self.Originals[gun]=byFeature
        end
        local stored=byFeature[feature]
        -- La primera vez, se guarda lo ORIGINAL, no un valor genérico.
        local baseline=gun:GetAttribute(attribute)
        if stored then baseline=stored.Original end
        if baseline==nil then return end
        if stored and stored.Attribute~=attribute then
            self:RestoreFeature(gun, feature)
            -- RestoreFeature puede eliminar el ultimo registro del arma.
            -- Volvemos a ligar la tabla al Tool antes de guardar el nuevo.
            byFeature=self.Originals[gun] or {}
            self.Originals[gun]=byFeature
            stored=nil
            baseline=gun:GetAttribute(attribute)
        end
        local desired=self:TargetValue(feature,baseline)
        if desired==nil or desired==baseline then return end
        if not stored then
            stored={Attribute=attribute,Original=baseline,Applied=desired}
            byFeature[feature]=stored
        end
        -- Si el servidor reescribe el atributo durante la descarga/disparo,
        -- no perseguirlo constantemente: solo se aplica al EQUIPAR.
        local current=gun:GetAttribute(attribute)
        if current~=desired then
            local ok=pcall(function() gun:SetAttribute(attribute,desired) end)
            if not ok then byFeature[feature]=nil end
        end
    end

    function mod:RestoreFeature(gun, feature)
        local byFeature=gun and self.Originals[gun]
        local saved=byFeature and byFeature[feature]
        if not saved then return end
        -- Restaurar solo si sigue siendo el valor que pusimos nosotros:
        -- asi no machacamos actualizaciones legitimas del arma.
        pcall(function()
            if gun:GetAttribute(saved.Attribute)==saved.Applied then
                gun:SetAttribute(saved.Attribute,saved.Original)
            end
        end)
        byFeature[feature]=nil
        if not next(byFeature) then self.Originals[gun]=nil end
    end

    function mod:RestoreGun(gun)
        local byFeature=self.Originals[gun]
        if not byFeature then return end
        local features={}
        for feature in pairs(byFeature) do table.insert(features,feature) end
        for _,feature in ipairs(features) do self:RestoreFeature(gun,feature) end
    end

    function mod:RestoreAll()
        local guns={}
        for gun in pairs(self.Originals) do table.insert(guns,gun) end
        for _,gun in ipairs(guns) do self:RestoreGun(gun) end
    end

    function mod:ApplyGun(gun)
        if not self.Enabled or not self:IsGun(gun) then return end
        -- Evita modificar herramientas que NO están equipadas.
        if not Player.Character or gun.Parent~=Player.Character then return end
        for _,feature in ipairs({"Accuracy","Range","Recoil","FireRate","Reload","Automatic"}) do
            if self.Flags[feature] then self:ApplyFeature(gun,feature) end
        end
    end

    function mod:ApplyEquipped()
        local char=Player.Character
        if not char then return end
        for _,tool in ipairs(char:GetChildren()) do
            if tool:IsA("Tool") then self:ApplyGun(tool) end
        end
    end

    function mod:DisconnectAll()
        for _,con in ipairs(self.CharacterConnections) do
            pcall(function() con:Disconnect() end)
        end
        table.clear(self.CharacterConnections)
        for _,con in ipairs(self.Connections) do
            pcall(function() con:Disconnect() end)
        end
        table.clear(self.Connections)
    end

    function mod:BindCharacter(char)
        for _,con in ipairs(self.CharacterConnections) do
            pcall(function() con:Disconnect() end)
        end
        table.clear(self.CharacterConnections)
        if not self.Enabled or not char then return end
        local session=self.Session
        -- Cambiar de arma dispara ChildRemoved (guardar) y ChildAdded (sacar).
        table.insert(self.CharacterConnections,char.ChildRemoved:Connect(function(child)
            if child:IsA("Tool") then self:RestoreGun(child) end
        end))
        table.insert(self.CharacterConnections,char.ChildAdded:Connect(function(child)
            if not child:IsA("Tool") then return end
            task.delay(0.08,function()
                if self.Enabled and self.Session==session
                   and Player.Character==char and child.Parent==char then
                    self:ApplyGun(child)
                end
            end)
        end))
        self:ApplyEquipped()
    end

    function mod:SetEnabled(value)
        value=(value==true)
        if value==self.Enabled then return end
        self.Session+=1
        self.Enabled=value
        if value then
            self:BindCharacter(Player.Character)
            table.insert(self.Connections,Player.CharacterAdded:Connect(function(char)
                self:BindCharacter(char)
            end))
        else
            self:DisconnectAll()
            self:RestoreAll()
        end
    end

    function mod:SetFeature(feature,value)
        if self.Flags[feature]==nil then return end
        value=(value==true)
        if self.Flags[feature]==value then return end
        self.Flags[feature]=value
        if not value then
            -- Al apagar una opcion no cambia las OTRAS cinco.
            local guns={}
            for gun in pairs(self.Originals) do table.insert(guns,gun) end
            for _,gun in ipairs(guns) do self:RestoreFeature(gun,feature) end
        elseif self.Enabled then
            self:ApplyEquipped()
        end
    end

-- DURABILITY (BlockSpin Test): opción principal de Misc.
-- Independiente de Quality X; solo modifica el arma equipada y guarda valores
-- originales de cada instancia. No obliga a escribir atributos inexistentes.
do
    local state = {Enabled=false, Value=1000, Originals=setmetatable({}, {__mode="k"}),
                   CharacterConnections={}, GlobalConnection=nil}
    SettingsVisual.DurabilityMod = state
    local function findAttr(tool)
        if not tool or not tool:IsA("Tool") then return nil end
        if tool:GetAttribute("Durability")~=nil then return "Durability" end
        if tool:GetAttribute("durability")~=nil then return "durability" end
        return nil
    end
    local function restore(tool)
        local old=state.Originals[tool]
        if not old then return end
        pcall(function()
            if tool and tool:GetAttribute(old.Key)==old.Applied then
                tool:SetAttribute(old.Key, old.Original)
            end
        end)
        state.Originals[tool]=nil
    end
    local function apply(tool)
        if not state.Enabled or not Player.Character or tool.Parent~=Player.Character then return end
        if not SettingsVisual.QualityXGunMod:IsGun(tool) then return end
        local key=findAttr(tool)
        if not key then return end
        local old=state.Originals[tool]
        if not old then
            old={Key=key,Original=tool:GetAttribute(key)}
            state.Originals[tool]=old
        end
        old.Applied=math.clamp(tonumber(state.Value) or 1000,100,5000)
        pcall(function() tool:SetAttribute(key,old.Applied) end)
    end
    local function disconnectChar()
        for _,con in ipairs(state.CharacterConnections) do pcall(function() con:Disconnect() end) end
        table.clear(state.CharacterConnections)
    end
    local function bind(char)
        disconnectChar()
        if not state.Enabled or not char then return end
        table.insert(state.CharacterConnections,char.ChildAdded:Connect(function(tool)
            if tool:IsA("Tool") then task.defer(function() if state.Enabled and tool.Parent==char then apply(tool) end end) end
        end))
        table.insert(state.CharacterConnections,char.ChildRemoved:Connect(function(tool)
            if tool:IsA("Tool") then restore(tool) end
        end))
        for _,tool in ipairs(char:GetChildren()) do
            if tool:IsA("Tool") then apply(tool) end
        end
    end
    MakeToggle(miscLeft,"Durability",false,function(on)
        state.Enabled=on and true or false
        if state.Enabled then
            bind(Player.Character)
            if state.GlobalConnection then state.GlobalConnection:Disconnect() end
            state.GlobalConnection=Player.CharacterAdded:Connect(bind)
        else
            disconnectChar()
            if state.GlobalConnection then state.GlobalConnection:Disconnect(); state.GlobalConnection=nil end
            for tool in pairs(state.Originals) do restore(tool) end
        end
    end)
    MakeSlider(miscLeft,"Durability Power",1000,100,5000,function(value)
        state.Value=math.clamp(tonumber(value) or 1000,100,5000)
        if state.Enabled then
            for tool in pairs(state.Originals) do restore(tool) end
            if Player.Character then
                for _,tool in ipairs(Player.Character:GetChildren()) do
                    if tool:IsA("Tool") then apply(tool) end
                end
            end
        end
    end)
end

    MakeToggle(miscLeft,"Enable Gun Mod",false,function(v) mod:SetEnabled(v) end)
    MakeToggle(miscLeft,"Inf Accuracy",true,function(v) mod:SetFeature("Accuracy",v) end)
    MakeToggle(miscLeft,"Inf Range",true,function(v) mod:SetFeature("Range",v) end)
    MakeToggle(miscLeft,"No Recoil",true,function(v) mod:SetFeature("Recoil",v) end)
    MakeToggle(miscLeft,"Inf Fire Rate",true,function(v) mod:SetFeature("FireRate",v) end)
    MakeToggle(miscLeft,"Min Reload Time",true,function(v) mod:SetFeature("Reload",v) end)
    MakeToggle(miscLeft,"Automatic Mode",true,function(v) mod:SetFeature("Automatic",v) end)
end

-- Se mantiene Multiplier Shot del HUB original, sin cambios de lógica.
MakeSlider(miscLeft, "Multiplier Shot", 1, 1, 5, function(v)
    SettingsVisual.ShotMultiplier = math.clamp(math.floor((tonumber(v) or 1) + 0.5), 1, 5)
end)

-- Resto de MISC INTACTO: no alterar ataques, pickup ni misiones.
MakeToggle(miscRight, "Melee Aura", false, function(v) SettingsVisual.NGU4Melee.SetAura(v) end)
MakeToggle(miscRight, "Kill Aura", false, function(v)
    SettingsVisual.KillAuraEnabled = v and true or false
end)
MakeToggle(miscRight, "Auto Attack", false, function(v) SettingsVisual.NGU4Melee.SetAuto(v) end)
-- WIDEFISTS importado de MERCY: 360 de alcance / 20 en segundo atributo.
-- Sólo puños / melee. No modifica armas de fuego ni hace hooks extra.
do
    local state={Enabled=false,Originals=setmetatable({}, {__mode="k"}),Connections={},Global=nil}
    SettingsVisual.WideFists = state
    local function isMelee(tool)
        if not tool or not tool:IsA("Tool") then return false end
        if tool.Name=="Fists" then return true end
        local items=ReplicatedStorage:FindFirstChild("Items")
        local folder=items and items:FindFirstChild("melee")
        return folder and folder:FindFirstChild(tool.Name)~=nil or false
    end
    local function names(tool)
        local attrs=tool:GetAttributes()
        for _,key in ipairs({"range","Range","attack_range","AttackRange","reach","Reach","HitRange"}) do
            if type(attrs[key])=="number" then
                for _,damage in ipairs({"damage","Damage","attack_damage","AttackDamage"}) do
                    if type(attrs[damage])=="number" then return key,damage end
                end
                return key,nil
            end
        end
        -- Compatibilidad con la estructura original de MERCY para Fists:
        -- allí se usan los atributos numéricos 6 y 7 tras ordenarlos.
        if tool.Name=="Fists" then
            local keys={}
            for key in pairs(attrs) do table.insert(keys,key) end
            table.sort(keys)
            if #keys>=7 and type(attrs[keys[6]])=="number"
              and type(attrs[keys[7]])=="number" then
                return keys[6],keys[7]
            end
        end
        return nil,nil
    end
    local function restore(tool)
        local records=state.Originals[tool]
        if not records then return end
        for key,old in pairs(records) do
            pcall(function()
                if tool and tool:GetAttribute(key)==old.Applied then
                    tool:SetAttribute(key,old.Value)
                end
            end)
        end
        state.Originals[tool]=nil
    end
    local function apply(tool)
        if not state.Enabled or not tool or not isMelee(tool) then return end
        if not Player.Character or tool.Parent~=Player.Character then return end
        local range,damage=names(tool)
        if not range then return end
        local records=state.Originals[tool] or {}
        state.Originals[tool]=records
        for _,pair in ipairs({{range,360},{damage,20}}) do
            local key,value=pair[1],pair[2]
            if key and type(tool:GetAttribute(key))=="number" then
                if not records[key] then records[key]={Value=tool:GetAttribute(key),Applied=value} end
                pcall(function() tool:SetAttribute(key,value) end)
            end
        end
    end
    local function disconnectChar()
        for _,conn in ipairs(state.Connections) do pcall(function() conn:Disconnect() end) end
        table.clear(state.Connections)
    end
    local function bind(char)
        disconnectChar()
        if not state.Enabled or not char then return end
        table.insert(state.Connections,char.ChildAdded:Connect(function(tool)
            if tool:IsA("Tool") then task.defer(function() if state.Enabled and tool.Parent==char then apply(tool) end end) end
        end))
        table.insert(state.Connections,char.ChildRemoved:Connect(function(tool)
            if tool:IsA("Tool") then restore(tool) end
        end))
        for _,tool in ipairs(char:GetChildren()) do
            if tool:IsA("Tool") then apply(tool) end
        end
    end
    MakeToggle(miscRight,"WideFists",false,function(on)
        state.Enabled=on and true or false
        if on then
            bind(Player.Character)
            if state.Global then state.Global:Disconnect() end
            state.Global=Player.CharacterAdded:Connect(bind)
        else
            disconnectChar()
            if state.Global then state.Global:Disconnect();state.Global=nil end
            for tool in pairs(state.Originals) do restore(tool) end
        end
    end)
end

MakeToggle(miscRight, "Auto Pickup (85 Studs)", false, function(v)
    AutoPickupEnabled = v
    ak = v -- Vinculado al state del segundo script.
end)
MakeSlider(miscRight, "Radio Pickup", 85, 20, 500, function(v) AutoPickupRadius = v end)

-- ================================================================
-- BUY PREMIUM: Dropdowns con popup flotante (sin cortar por los scrolls).
-- Se reutilizan SelectedAmmoType, SelectedGunCrate, SelectedCarCrate;
-- SOLO cambia el selector visual: toda la logica de compra sigue igual.
-- ================================================================
SettingsVisual.CloseBuyDropdown = function()
    local active = SettingsVisual.BuyDropdownActive
    SettingsVisual.BuyDropdownActive = nil
    if active then
        if active.ResetChevron then active.ResetChevron() end
        if active.Popup and active.Popup.Parent then active.Popup:Destroy() end
        if active.Outside and active.Outside.Parent then active.Outside:Destroy() end
    end
end

SettingsVisual.MakePremiumBuyDropdown = function(parent, titleText, choices, settingKey)
    local row = Instance.new("Frame")
    row.Name = "CHINO_Buy_" .. settingKey
    row.Size = UDim2.new(1, 0, 0, 36)
    row.BackgroundColor3 = Color3.fromRGB(16, 23, 40)
    row.BackgroundTransparency = 0.82
    row.BorderSizePixel = 0
    row.ZIndex = 8
    row.Parent = parent
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 9)
    local rowStroke = Instance.new("UIStroke", row)
    rowStroke.Color = Color3.fromRGB(101, 135, 200)
    rowStroke.Transparency = 0.68
    rowStroke.Thickness = 1

    local label = Instance.new("TextLabel", row)
    label.Name = "FieldLabel"
    label.Position = UDim2.fromOffset(10, 0)
    label.Size = UDim2.new(0.45, -8, 1, 0)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 11
    label.Text = titleText
    label.TextColor3 = Color3.fromRGB(225, 232, 250)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextTruncate = Enum.TextTruncate.AtEnd
    label.ZIndex = 9

    local trigger = Instance.new("TextButton", row)
    trigger.Name = "OpenOptions"
    trigger.Size = UDim2.new(0.53, -7, 0, 27)
    trigger.Position = UDim2.new(0.47, 0, 0.5, -13)
    trigger.BackgroundColor3 = Color3.fromRGB(42, 58, 94)
    trigger.BackgroundTransparency = 0.18
    trigger.BorderSizePixel = 0
    trigger.AutoButtonColor = false
    trigger.Text = ""
    trigger.ZIndex = 9
    Instance.new("UICorner", trigger).CornerRadius = UDim.new(0, 9)
    local glass = Instance.new("UIGradient", trigger)
    glass.Rotation = 20
    glass.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(64, 76, 127)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(39, 45, 86))
    })
    local tstroke = Instance.new("UIStroke", trigger)
    tstroke.Color = Color3.fromRGB(124, 169, 235)
    tstroke.Thickness = 1
    tstroke.Transparency = 0.39

    local selected = Instance.new("TextLabel", trigger)
    selected.Name = "SelectedValue"
    selected.BackgroundTransparency = 1
    selected.Position = UDim2.fromOffset(10, 0)
    selected.Size = UDim2.new(1, -44, 1, 0)
    selected.TextSize = 10
    selected.Font = Enum.Font.GothamSemibold
    selected.TextColor3 = Color3.fromRGB(248, 250, 255)
    selected.TextTruncate = Enum.TextTruncate.AtEnd
    selected.TextXAlignment = Enum.TextXAlignment.Left
    selected.ZIndex = 10

    -- Separador + flecha vectorial (2 barras): funciona en iOS/Android/PC.
    -- Evita el símbolo Unicode ▾, que en algunas fuentes sale como cuadrito.
    local divider = Instance.new("Frame", trigger)
    divider.Name = "ArrowDivider"
    divider.AnchorPoint = Vector2.new(0, 0.5)
    divider.Position = UDim2.new(1, -34, 0.5, 0)
    divider.Size = UDim2.fromOffset(1, 14)
    divider.BackgroundColor3 = Color3.fromRGB(139, 170, 227)
    divider.BackgroundTransparency = 0.50
    divider.BorderSizePixel = 0
    divider.ZIndex = 10

    local chevron = Instance.new("Frame", trigger)
    chevron.Name = "ChevronDown"
    chevron.Size = UDim2.fromOffset(19, 19)
    chevron.AnchorPoint = Vector2.new(0.5, 0.5)
    chevron.Position = UDim2.new(1, -19, 0.5, 0)
    chevron.BackgroundTransparency = 1
    chevron.BorderSizePixel = 0
    chevron.ZIndex = 10
    for _, arm in ipairs({{6.3, 8.7, 45}, {12.3, 8.7, -45}}) do
        local line = Instance.new("Frame", chevron)
        line.Name = "ChevronStroke"
        line.AnchorPoint = Vector2.new(0.5, 0.5)
        line.Position = UDim2.fromOffset(arm[1], arm[2])
        line.Size = UDim2.fromOffset(9, 2.4)
        line.Rotation = arm[3]
        line.BackgroundColor3 = Color3.fromRGB(166, 220, 255)
        line.BorderSizePixel = 0
        line.ZIndex = 11
        Instance.new("UICorner", line).CornerRadius = UDim.new(1, 0)
    end
    local function setChevronOpen(isOpen)
        TweenService:Create(chevron, TweenInfo.new(0.17, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Rotation = isOpen and 180 or 0
        }):Play()
    end

    local function updateSelected()
        local current = tostring(SettingsVisual[settingKey] or choices[1] or "")
        selected.Text = current
        return current
    end
    updateSelected()

    trigger.Activated:Connect(function()
        -- Segundo toque cierra el mismo selector.
        local active = SettingsVisual.BuyDropdownActive
        if active and active.Key == settingKey then
            SettingsVisual.CloseBuyDropdown()
            return
        end
        SettingsVisual.CloseBuyDropdown()

        local camera = workspace.CurrentCamera
        local viewSize = (camera and camera.ViewportSize) or Vector2.new(900, 550)
        local buttonPos = trigger.AbsolutePosition
        local buttonSize = trigger.AbsoluteSize
        local listHeight = math.min(#choices * 30 + 12, 195)
        local listWidth = math.clamp(math.max(buttonSize.X + 40, 139), 139, math.max(139, viewSize.X - 20))
        local x = math.clamp(buttonPos.X + buttonSize.X - listWidth, 6, math.max(6, viewSize.X - listWidth - 6))
        local y = buttonPos.Y + buttonSize.Y + 5
        if y + listHeight > viewSize.Y - 8 then
            y = buttonPos.Y - listHeight - 5
        end
        y = math.clamp(y, 5, math.max(5, viewSize.Y - listHeight - 5))

        -- Fuera del scroll original: el menú flota por encima de todo el HUB.
        local outside = Instance.new("TextButton")
        outside.Name = "CHINO_BuyDropdownBackdrop"
        outside.Size = UDim2.fromScale(1, 1)
        outside.BackgroundTransparency = 1
        outside.BorderSizePixel = 0
        outside.Text = ""
        outside.AutoButtonColor = false
        outside.ZIndex = 195
        outside.Parent = Gui

        local popup = Instance.new("Frame")
        popup.Name = "CHINO_BuyDropdownPopup"
        popup.Size = UDim2.fromOffset(listWidth, listHeight)
        popup.Position = UDim2.fromOffset(x, y)
        popup.BackgroundColor3 = Color3.fromRGB(20, 28, 49)
        popup.BackgroundTransparency = 0.12
        popup.BorderSizePixel = 0
        popup.ZIndex = 200
        popup.ClipsDescendants = true
        popup.Parent = Gui
        Instance.new("UICorner", popup).CornerRadius = UDim.new(0, 12)
        local ps = Instance.new("UIStroke", popup)
        ps.Color = Color3.fromRGB(99, 155, 232)
        ps.Transparency = 0.28
        ps.Thickness = 1

        local scroll = Instance.new("ScrollingFrame", popup)
        scroll.Name = "Options"
        scroll.Size = UDim2.new(1, -8, 1, -8)
        scroll.Position = UDim2.fromOffset(4, 4)
        scroll.BackgroundTransparency = 1
        scroll.BorderSizePixel = 0
        scroll.ScrollBarThickness = 2
        scroll.ScrollBarImageColor3 = Color3.fromRGB(110, 178, 255)
        scroll.ZIndex = 201
        local layout = Instance.new("UIListLayout", scroll)
        layout.Padding = UDim.new(0, 2)
        layout.SortOrder = Enum.SortOrder.LayoutOrder

        SettingsVisual.BuyDropdownActive = {
            Key = settingKey, Popup = popup, Outside = outside,
            ResetChevron = function() setChevronOpen(false) end,
        }
        setChevronOpen(true)
        outside.Activated:Connect(SettingsVisual.CloseBuyDropdown)

        for i, option in ipairs(choices) do
            local item = Instance.new("TextButton", scroll)
            item.Name = "Option_" .. tostring(i)
            item.Size = UDim2.new(1, -2, 0, 28)
            item.LayoutOrder = i
            item.BackgroundColor3 = option == SettingsVisual[settingKey]
                and Color3.fromRGB(55, 97, 150)
                or Color3.fromRGB(34, 45, 69)
            item.BackgroundTransparency = option == SettingsVisual[settingKey] and 0.25 or 0.53
            item.BorderSizePixel = 0
            item.Text = option
            item.TextColor3 = Color3.fromRGB(241, 246, 255)
            item.TextSize = 11
            item.Font = Enum.Font.GothamMedium
            item.AutoButtonColor = true
            item.ZIndex = 203
            Instance.new("UICorner", item).CornerRadius = UDim.new(0, 7)
            item.Activated:Connect(function()
                SettingsVisual[settingKey] = option
                updateSelected()
                SettingsVisual.CloseBuyDropdown()
            end)
        end
        scroll.CanvasSize = UDim2.fromOffset(0, #choices * 30)
    end)
    return row
end

SettingsVisual.MakePremiumBuyDropdown(SettingsVisual.AmmoLeft, "Ammo", SettingsVisual.AmmoTypes, "SelectedAmmoType")
SettingsVisual.MakeActionButton(SettingsVisual.AmmoLeft, "Buy Ammo", SettingsVisual.OpenAmmoCrate, "BUY", 0.62)
SettingsVisual.MakePremiumBuyDropdown(SettingsVisual.AmmoLeft, "Gun Crate", SettingsVisual.GunCrateTypes, "SelectedGunCrate")
SettingsVisual.MakeActionButton(SettingsVisual.AmmoLeft, "Buy Guns", SettingsVisual.OpenGunCrate, "BUY", 0.62)
SettingsVisual.MakePremiumBuyDropdown(SettingsVisual.AmmoRight, "Car Crate", SettingsVisual.CarCrateTypes, "SelectedCarCrate")
SettingsVisual.MakeActionButton(SettingsVisual.AmmoRight, "Buy Cars", SettingsVisual.OpenCarCrate, "BUY", 0.62)

-- BANK + MONEY: detección robusta del dinero guardado y del dinero que lleva el jugador.
do
	local setBank = SettingsVisual.MakeValueRow(SettingsVisual.AmmoRight, "Bank", "...")
	local setMoney = SettingsVisual.MakeValueRow(SettingsVisual.AmmoRight, "Money", "...")

	SettingsVisual.LastBankBalance = SettingsVisual.LastBankBalance
	SettingsVisual.LastCarriedMoney = SettingsVisual.LastCarriedMoney

	local function normalizeKey(value)
		return tostring(value or ""):lower():gsub("[^%w]", "")
	end

	local function parseMoney(value)
		if type(value) == "number" then
			return math.floor(value + 0.5)
		end

		local str = tostring(value or "")
			:gsub(",", "")
			:gsub("%s+", "")

		local numberText, suffix = str:match("([%-]?%d+%.?%d*)([kKmMbB]?)")
		local number = tonumber(numberText)
		if not number then return nil end

		suffix = tostring(suffix or ""):lower()
		if suffix == "k" then
			number = number * 1000
		elseif suffix == "m" then
			number = number * 1000000
		elseif suffix == "b" then
			number = number * 1000000000
		end

		return math.floor(number + 0.5)
	end

	local function formatMoney(value)
		if value == nil then return "..." end

		local str = tostring(math.floor(tonumber(value) or 0))
		while true do
			local changed
			str, changed = str:gsub("^(-?%d+)(%d%d%d)", "%1,%2")
			if changed == 0 then break end
		end
		return "$" .. str
	end

	local function isBadMoneyKey(key)
		return key:find("multiplier", 1, true)
			or key:find("rate", 1, true)
			or key:find("price", 1, true)
			or key:find("cost", 1, true)
			or key:find("reward", 1, true)
	end

	local function readNamedData(mode)
		local roots = {Player}
		if Player.Character then
			table.insert(roots, Player.Character)
		end

		local function keyMatches(key)
			if mode == "bank" then
				return key == "bankbalance"
					or key == "bankmoney"
					or key == "bankcash"
					or key == "atmbalance"
					or key == "atmmoney"
					or key == "bankamount"
					or key == "bankfunds"
					or key == "balancebank"
			else
				return key == "money"
					or key == "cash"
					or key == "wallet"
					or key == "carriedmoney"
					or key == "handbalance"
			end
		end

		for _, root in ipairs(roots) do
			for attrName, attrValue in pairs(root:GetAttributes()) do
				local key = normalizeKey(attrName)
				if keyMatches(key) then
					local parsed = parseMoney(attrValue)
					if parsed ~= nil then return parsed end
				end
			end
		end

		for _, obj in ipairs(Player:GetDescendants()) do
			if obj:IsA("IntValue")
				or obj:IsA("NumberValue")
				or obj:IsA("StringValue") then

				local key = normalizeKey(obj.Name)
				if keyMatches(key) then
					local parsed = parseMoney(obj.Value)
					if parsed ~= nil then return parsed end
				end
			end
		end

		return nil
	end

	local function readMoneyFromHUD(playerGui)
		local topRight = playerGui:FindFirstChild("TopRightHud")
		local holder = topRight and topRight:FindFirstChild("Holder")
		local frame = holder and holder:FindFirstChild("Frame")
		local moneyLabel = frame and frame:FindFirstChild("MoneyTextLabel")

		if moneyLabel and moneyLabel:IsA("TextLabel") then
			local value = parseMoney(moneyLabel.Text)
			if value ~= nil then return value end
		end

		if topRight then
			for _, obj in ipairs(topRight:GetDescendants()) do
				if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
					local clue = normalizeKey(obj.Name .. " " .. tostring(obj.Text or ""))
					if (clue:find("money", 1, true)
						or clue:find("cash", 1, true)
						or clue:find("wallet", 1, true))
						and not clue:find("bank", 1, true)
						and not clue:find("atm", 1, true) then

						local value = parseMoney(obj.Text)
						if value ~= nil then return value end
					end
				end
			end
		end

		return nil
	end

	local function readBankFromGUI(playerGui)
		local function scanRoot(root)
			if not root then return nil end

			for _, obj in ipairs(root:GetDescendants()) do
				if (obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox"))
					and not obj:IsDescendantOf(Gui) then

					local textValue = tostring(obj.Text or "")
					local nameValue = tostring(obj.Name or "")
					local clue = normalizeKey(nameValue .. " " .. textValue)

					if clue:find("bankbalance", 1, true)
						or clue:find("atmbalance", 1, true)
						or clue:find("bankmoney", 1, true)
						or clue:find("bankfunds", 1, true) then

						local value = parseMoney(textValue)
						if value ~= nil then
							return value
						end

						local parent = obj.Parent
						if parent then
							for _, sibling in ipairs(parent:GetDescendants()) do
								if sibling ~= obj
									and (sibling:IsA("TextLabel")
										or sibling:IsA("TextButton")
										or sibling:IsA("TextBox")) then

									local siblingText = tostring(sibling.Text or "")
									if siblingText:find("$", 1, true)
										or siblingText:match("[%d,]+") then
										value = parseMoney(siblingText)
										if value ~= nil then
											return value
										end
									end
								end
							end
						end
					end
				end
			end

			return nil
		end

		local value = scanRoot(playerGui)
		if value ~= nil then return value end

		value = scanRoot(CoreGui)
		if value ~= nil then return value end

		if gethui then
			local ok, hui = pcall(gethui)
			if ok and hui then
				value = scanRoot(hui)
				if value ~= nil then return value end
			end
		end

		return nil
	end

	local function readBankFromClientTables()
		if not getgc then return nil end

		local strongKeys = {
			bankbalance = true,
			bankmoney = true,
			bankcash = true,
			atmbalance = true,
			atmmoney = true,
			bankamount = true,
			bankfunds = true,
			balancebank = true
		}

		local ok, objects = pcall(function()
			return getgc(true)
		end)
		if not ok or type(objects) ~= "table" then return nil end

		for _, item in ipairs(objects) do
			if typeof(item) == "table" then
				local okTable, result = pcall(function()
					for key, value in pairs(item) do
						if strongKeys[normalizeKey(key)] then
							local parsed = parseMoney(value)
							if parsed ~= nil then
								return parsed
							end
						end
					end
				end)

				if okTable and result ~= nil then
					return result
				end
			end
		end

		return nil
	end

	task.spawn(function()
		while Gui and Gui.Parent do
			task.wait(0.2)

			pcall(function()
				local playerGui = Player:FindFirstChild("PlayerGui")
				if not playerGui then return end

				-- DINERO QUE LLEVA EL JUGADOR:
				-- primero el HUD real TopRightHud, después datos/atributos.
				local carriedMoney = readMoneyFromHUD(playerGui)
					or readNamedData("money")

				-- BANK:
				-- primero datos/atributos persistentes y luego cualquier
				-- Bank Balance/ATM visible u oculto dentro de PlayerGui.
				local bankMoney = readBankFromGUI(playerGui)
					or readNamedData("bank")
					or readBankFromClientTables()

				if carriedMoney ~= nil then
					SettingsVisual.LastCarriedMoney = carriedMoney
				end
				if bankMoney ~= nil then
					SettingsVisual.LastBankBalance = bankMoney
				end

				setMoney(formatMoney(SettingsVisual.LastCarriedMoney))
				setBank(formatMoney(SettingsVisual.LastBankBalance))
			end)
		end
	end)
end

-- Transparencia premium exclusiva de la pestaña Ammo.
for _, ammoColumn in ipairs({SettingsVisual.AmmoLeft, SettingsVisual.AmmoRight}) do
	if ammoColumn then
		for _, obj in ipairs(ammoColumn:GetDescendants()) do
			if obj:IsA("TextButton") then
				obj.BackgroundTransparency = math.max(obj.BackgroundTransparency, 0.62)
			elseif obj:IsA("Frame") and obj.BackgroundTransparency < 1 then
				obj.BackgroundTransparency = math.max(obj.BackgroundTransparency, 0.76)
			end
		end
	end
end

-- Kill Aura: comportamiento del script GODZILLA que mandaste.
-- Mantiene rango 18 y melee_attack 0.75; cadencia acelerada a 0.05s.
SettingsVisual.KillAuraEnabled = false

task.spawn(function()
	while Gui and Gui.Parent do
		task.wait(SettingsVisual.NetworkKillAuraInterval or 0.08)

		if SettingsVisual.KillAuraEnabled then
			pcall(function()
				local character = Player.Character
				if not character or not character.PrimaryPart then
					return
				end

				local equippedTool = character:FindFirstChildOfClass("Tool")
				if not equippedTool then
					return
				end

				local origin = character.PrimaryPart.Position

				for _, targetPlayer in ipairs(Players:GetPlayers()) do
					if targetPlayer ~= Player
						and targetPlayer.Character
						and targetPlayer.Character.PrimaryPart then

						local targetHum =
							targetPlayer.Character:FindFirstChildOfClass("Humanoid")

						if targetHum and targetHum.Health > 0 then
							local targetPos =
								targetPlayer.Character.PrimaryPart.Position

							if (targetPos - origin).Magnitude <= 18 then
								FireServerHook(
									"melee_attack",
									equippedTool,
									{targetPlayer},
									CFrame.lookAt(origin, targetPos),
									0.75
								)
							end
						end
					end
				end
			end)
		end
	end
end)

-- Del script que mandaste: reclama todas las quests visibles usando el mismo NetGet del HUB.
SettingsVisual.MakeActionButton(miscRight, "Claim All Quest", function()
	local quests = PlayerGui:FindFirstChild("Quests")
	local holder = quests and quests:FindFirstChild("QuestsHolder")
	local scrolling = holder and holder:FindFirstChild("QuestsScrollingFrame")
	if not scrolling then
		warn("⚠️ Claim All Quest: no se encontró QuestsScrollingFrame")
		return
	end

	for _, questRow in ipairs(scrolling:GetChildren()) do
		if questRow:IsA("Frame") or questRow:IsA("TextButton") or questRow:IsA("ImageButton") then
			pcall(function()
				NetGet("claim_quest", questRow.Name)
			end)
			task.wait(0.2)
		end
	end
	print("✅ Claim All Quest completado")
end)

-- SILENT AIM
MakeToggle(silentLeft, "Silent Aim", false, function(v) SilentAimEnabled = v end)
MakeToggle(silentLeft, "Target Line", true, function(v) SettingsVisual.TargetLine = v end)

-- SAFE FRIEND · selector desplegable de cristal, nicks completos y avatar.
-- El popup vive fuera del Scroll para evitar cortes y superposiciones.
do
    local row = Instance.new("Frame", silentLeft)
    row.Name = "CHINO_SafeFriendSelector"
    row.Size = UDim2.new(1, 0, 0, 65)
    row.BackgroundColor3 = Color3.fromRGB(20, 24, 38)
    row.BackgroundTransparency = 0.60
    row.BorderSizePixel = 0
    row.ZIndex = 9
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 7)
    local border = Instance.new("UIStroke", row)
    border.Color = Color3.fromRGB(92, 141, 168)
    border.Transparency = 0.7
    border.Thickness = 1

    local caption = Instance.new("TextLabel", row)
    caption.Name = "SafeFriendTitle"
    caption.Position = UDim2.fromOffset(9, 2)
    caption.Size = UDim2.new(1, -71, 0, 22)
    caption.BackgroundTransparency = 1
    caption.Text = "SAFE FRIEND"
    caption.TextColor3 = Color3.fromRGB(155, 255, 190)
    caption.Font = Enum.Font.GothamBold
    caption.TextSize = 11
    caption.TextXAlignment = Enum.TextXAlignment.Left
    caption.ZIndex = 10

    local reset = Instance.new("TextButton", row)
    reset.Name = "SafeFriendReset"
    reset.Size = UDim2.fromOffset(52, 20)
    reset.Position = UDim2.new(1, -58, 0, 4)
    reset.BackgroundColor3 = Color3.fromRGB(27, 43, 54)
    reset.BackgroundTransparency = 0.30
    reset.BorderSizePixel = 0
    reset.Text = "RESET"
    reset.TextColor3 = Color3.fromRGB(195, 233, 212)
    reset.TextSize = 9
    reset.Font = Enum.Font.GothamBold
    reset.ZIndex = 10
    Instance.new("UICorner", reset).CornerRadius = UDim.new(0, 5)

    local open = Instance.new("TextButton", row)
    open.Name = "SafeFriendOpen"
    open.Position = UDim2.fromOffset(6, 28)
    open.Size = UDim2.new(1, -12, 0, 31)
    open.BackgroundColor3 = Color3.fromRGB(22, 43, 53)
    open.BackgroundTransparency = 0.43
    open.BorderSizePixel = 0
    open.Text = ""
    open.ZIndex = 10
    Instance.new("UICorner", open).CornerRadius = UDim.new(0, 6)
    local openStroke = Instance.new("UIStroke", open)
    openStroke.Color = Color3.fromRGB(92, 170, 145)
    openStroke.Transparency = 0.66
    openStroke.Thickness = 1

    local displayName = Instance.new("TextLabel", open)
    displayName.Name = "SelectedFullName"
    displayName.Size = UDim2.new(1, -43, 1, 0)
    displayName.Position = UDim2.fromOffset(9, 0)
    displayName.BackgroundTransparency = 1
    displayName.Text = "SELECT FRIEND"
    displayName.TextColor3 = Color3.fromRGB(225, 239, 237)
    displayName.Font = Enum.Font.GothamBold
    displayName.TextXAlignment = Enum.TextXAlignment.Left
    displayName.TextScaled = true
    displayName.TextTruncate = Enum.TextTruncate.None
    displayName.ZIndex = 11
    local textConstraint = Instance.new("UITextSizeConstraint", displayName)
    textConstraint.MinTextSize = 7
    textConstraint.MaxTextSize = 11

    -- Flecha dibujada con dos trazos; sin caracteres Unicode cuadrados.
    local arrow = Instance.new("Frame", open)
    arrow.Name = "DownChevron"
    arrow.Size = UDim2.fromOffset(27, 24)
    arrow.Position = UDim2.new(1, -31, 0.5, -12)
    arrow.BackgroundColor3 = Color3.fromRGB(39, 67, 73)
    arrow.BackgroundTransparency = 0.37
    arrow.BorderSizePixel = 0
    arrow.ZIndex = 11
    Instance.new("UICorner", arrow).CornerRadius = UDim.new(0, 5)
    for _, degree in ipairs({45, -45}) do
        local half = Instance.new("Frame", arrow)
        half.Size = UDim2.fromOffset(2, 10)
        half.AnchorPoint = Vector2.new(0.5, 0.5)
        half.Position = degree == 45 and UDim2.fromOffset(11, 12)
            or UDim2.fromOffset(17, 12)
        half.Rotation = degree
        half.BackgroundColor3 = Color3.fromRGB(184, 255, 206)
        half.BorderSizePixel = 0
        half.ZIndex = 12
        Instance.new("UICorner", half).CornerRadius = UDim.new(1, 0)
    end

    local popup = Instance.new("Frame", Gui)
    popup.Name = "CHINO_SafeFriendDropdown"
    popup.Size = UDim2.fromOffset(240, 212)
    popup.BackgroundColor3 = Color3.fromRGB(20, 27, 39)
    popup.BackgroundTransparency = 0.02
    popup.BorderSizePixel = 0
    popup.Visible = false
    popup.ZIndex = 300
    Instance.new("UICorner", popup).CornerRadius = UDim.new(0, 8)
    local popupBorder = Instance.new("UIStroke", popup)
    popupBorder.Color = Color3.fromRGB(84, 172, 131)
    popupBorder.Transparency = 0.24
    popupBorder.Thickness = 1

    local list = Instance.new("ScrollingFrame", popup)
    list.Size = UDim2.new(1, -8, 1, -8)
    list.Position = UDim2.fromOffset(4, 4)
    list.BackgroundTransparency = 1
    list.ScrollBarThickness = 3
    list.ScrollingDirection = Enum.ScrollingDirection.Y
    list.AutomaticCanvasSize = Enum.AutomaticSize.Y
    list.CanvasSize = UDim2.fromOffset(0, 0)
    list.ZIndex = 301
    local order = Instance.new("UIListLayout", list)
    order.Padding = UDim.new(0, 4)
    order.SortOrder = Enum.SortOrder.LayoutOrder

    local function positionPopup()
        local cam = workspace.CurrentCamera
        local view = cam and cam.ViewportSize or Vector2.new(800, 600)
        local width = math.max(158, open.AbsoluteSize.X)
        local height = math.min(216, math.max(120, view.Y - 20))
        local pos = open.AbsolutePosition
        local x = math.clamp(pos.X, 4, math.max(4, view.X - width - 4))
        local belowY = pos.Y + open.AbsoluteSize.Y + 5
        local aboveY = pos.Y - height - 5
        local y = belowY + height <= view.Y - 6 and belowY or math.max(5, aboveY)
        popup.Size = UDim2.fromOffset(width, height)
        popup.Position = UDim2.fromOffset(x, y)
    end

    local function refreshLabel()
        local friend = SettingsVisual.GetSafeFriendPlayer()
        displayName.Text = friend and ("@" .. friend.Name) or "SELECT FRIEND"
        displayName.TextColor3 = friend
            and Color3.fromRGB(149, 255, 181)
            or Color3.fromRGB(225, 239, 237)
    end

    local function choose(other)
        SettingsVisual.SetSafeFriend(other)
        SettingsVisual.UpdateSafeFriendMarker()
        popup.Visible = false
        refreshLabel()
    end

    local function makeEntry(player, index)
        local entry = Instance.new("TextButton", list)
        entry.Name = player and ("Friend_" .. player.UserId) or "Friend_None"
        entry.Size = UDim2.new(1, -5, 0, 36)
        entry.BackgroundColor3 = player and Color3.fromRGB(25, 51, 45)
            or Color3.fromRGB(31, 37, 51)
        entry.BackgroundTransparency = 0.15
        entry.BorderSizePixel = 0
        entry.Text = ""
        entry.ZIndex = 302
        entry.LayoutOrder = index
        Instance.new("UICorner", entry).CornerRadius = UDim.new(0, 6)
        local selected = player and SettingsVisual.IsSafeFriend(player)
        if selected then
            local stroke = Instance.new("UIStroke", entry)
            stroke.Color = Color3.fromRGB(120, 255, 160)
            stroke.Thickness = 1
        end

        local x = 8
        if player then
            local avatar = Instance.new("ImageLabel", entry)
            avatar.Position = UDim2.fromOffset(5, 5)
            avatar.Size = UDim2.fromOffset(26, 26)
            avatar.BackgroundTransparency = 1
            avatar.ZIndex = 303
            Instance.new("UICorner", avatar).CornerRadius = UDim.new(1, 0)
            x = 37
            task.spawn(function()
                local ok, imageId = pcall(function()
                    return Players:GetUserThumbnailAsync(player.UserId,
                        Enum.ThumbnailType.HeadShot,
                        Enum.ThumbnailSize.Size100x100)
                end)
                if ok and avatar.Parent then avatar.Image = imageId end
            end)
        end

        local username = Instance.new("TextLabel", entry)
        username.Name = "FullUsername"
        username.Position = UDim2.fromOffset(x, 0)
        username.Size = UDim2.new(1, -(x + 8), 1, 0)
        username.BackgroundTransparency = 1
        username.Text = player and ("@" .. player.Name) or "NONE / REMOVE FRIEND"
        username.TextColor3 = selected and Color3.fromRGB(159, 255, 185)
            or Color3.fromRGB(231, 242, 237)
        username.Font = Enum.Font.GothamBold
        username.TextScaled = true
        username.TextTruncate = Enum.TextTruncate.None
        username.TextXAlignment = Enum.TextXAlignment.Left
        username.ZIndex = 303
        local limit = Instance.new("UITextSizeConstraint", username)
        limit.MinTextSize = 7
        limit.MaxTextSize = 11
        entry.Activated:Connect(function() choose(player) end)
    end

    local function refreshOptions()
        refreshLabel()
        for _, child in ipairs(list:GetChildren()) do
            if child ~= order then child:Destroy() end
        end
        makeEntry(nil, 0)
        local others = {}
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= Player then table.insert(others, player) end
        end
        table.sort(others, function(a, b)
            return a.Name:lower() < b.Name:lower()
        end)
        for i, player in ipairs(others) do makeEntry(player, i) end
        positionPopup()
    end

    open.Activated:Connect(function()
        popup.Visible = not popup.Visible
        if popup.Visible then refreshOptions() end
    end)
    reset.Activated:Connect(function() choose(nil) end)
    Players.PlayerAdded:Connect(function()
        if popup.Visible then task.defer(refreshOptions) end
    end)
    Players.PlayerRemoving:Connect(function(leaving)
        if SettingsVisual.IsSafeFriend(leaving) then choose(nil) end
        if popup.Visible then task.defer(refreshOptions) end
    end)

    RunService.RenderStepped:Connect(function()
        if not popup.Visible then return end
        if not Gui.Enabled then popup.Visible = false; return end
        -- Al cambiar de pestaña / minimizar HUB, ocultar la lista global.
        local current = row
        while current and current ~= Gui do
            if current:IsA("GuiObject") and not current.Visible then
                popup.Visible = false
                return
            end
            current = current.Parent
        end
        positionPopup()
    end)
    -- La marca verde es independiente de los FPS del ESP y se restaura
    -- automaticamente si el amigo muere y reaparece.
    task.spawn(function()
        while Gui and Gui.Parent do
            pcall(SettingsVisual.UpdateSafeFriendMarker)
            task.wait(0.55)
        end
        choose(nil)
        if popup then popup:Destroy() end
    end)
    refreshLabel()
end
MakeToggle(silentLeft, "Mostrar FOV", false, function(v) SettingsVisual.FOV = v end)
MakeSlider(silentLeft, "Radio FOV", 120, 20, 800, function(v) SettingsVisual.FOVRadius = v end)

local function MakeHitPartButtons(parent, isSoftAim, isPC)
	local row = Instance.new("Frame")
	row.Size = UDim2.new(1, 0, 0, 36)
	row.BackgroundColor3 = Color3.fromRGB(20, 24, 38)
	row.BackgroundTransparency = 0.6
	row.ZIndex = 8
	row.Parent = parent
	Instance.new("UICorner", row).CornerRadius = UDim.new(0, 6)

	local parts = {"Head", "Neck", "Chest"}
	local btnButtons = {}

	local function applyPartSelection(pName)
		if not btnButtons[pName] then return end
		if not isSoftAim then
			TargetHitPart = pName
		elseif isPC then
			SoftAimPCPart = pName
		else
			SoftAimMobilePart = pName
		end

		for name, btn in pairs(btnButtons) do
			local selected = name == pName
			btn.BackgroundColor3 = selected and COLORS.Blue or Color3.fromRGB(35, 32, 45)
			-- Azul más cristal/transparente como pediste.
			btn.BackgroundTransparency = selected and 0.48 or 0.66
		end
	end

	for i, pName in ipairs(parts) do
		local pBtn = Instance.new("TextButton", row)
		pBtn.Size = UDim2.new(0, 40, 0, 22)
		pBtn.Position = UDim2.new(1, -135 + ((i - 1) * 44), 0.5, -11)

		local currentSelected = TargetHitPart
		if isSoftAim then
			currentSelected = isPC and SoftAimPCPart or SoftAimMobilePart
		end

		pBtn.BackgroundColor3 = (pName == currentSelected) and COLORS.Blue or Color3.fromRGB(35, 32, 45)
		pBtn.BackgroundTransparency = (pName == currentSelected) and 0.48 or 0.66
		pBtn.Text = pName
		pBtn.TextColor3 = COLORS.White
		pBtn.TextSize = 9
		pBtn.Font = Enum.Font.GothamBold
		pBtn.ZIndex = 9
		Instance.new("UICorner", pBtn).CornerRadius = UDim.new(0, 4)

		btnButtons[pName] = pBtn
		pBtn.MouseButton1Click:Connect(function()
			applyPartSelection(pName)
		end)
	end

	if not isSoftAim then
		SettingsVisual.SetTargetHitPart = applyPartSelection
	elseif isPC then
		SettingsVisual.SetSoftAimPCPart = applyPartSelection
	else
		SettingsVisual.SetSoftAimMobilePart = applyPartSelection
	end

	return applyPartSelection
end

--========================================================--
-- SILENT AIM EXACTO - SELECTOR HEAD / NECK / CHEST
-- Head es default para conservar el comportamiento ya aprobado.
--========================================================--

local function MakeSilentAimHitPartButtons(parent)
	local row = Instance.new("Frame")
	row.Size = UDim2.new(1, 0, 0, 36)
	row.BackgroundColor3 = Color3.fromRGB(20, 24, 38)
	row.BackgroundTransparency = 0.6
	row.ZIndex = 8
	row.Parent = parent

	Instance.new("UICorner", row).CornerRadius =
		UDim.new(0, 6)

	local parts = {"Head", "Neck", "Chest"}
	local buttons = {}

	local function applySelection(partName)
		if not buttons[partName] then
			return
		end

		if partName ~= "Head"
			and partName ~= "Neck"
			and partName ~= "Chest" then
			partName = "Head"
		end

		SilentAimHitPart = partName

		for name, button in pairs(buttons) do
			local selected = name == partName

			button.BackgroundColor3 =
				selected
				and COLORS.Blue
				or Color3.fromRGB(35, 32, 45)

			button.BackgroundTransparency =
				selected and 0.48 or 0.66
		end
	end

	for index, partName in ipairs(parts) do
		local button = Instance.new("TextButton")
		button.Size = UDim2.new(0, 40, 0, 22)
		button.Position =
			UDim2.new(
				1,
				-135 + ((index - 1) * 44),
				0.5,
				-11
			)

		button.BackgroundColor3 =
			(partName == SilentAimHitPart)
				and COLORS.Blue
				or Color3.fromRGB(35, 32, 45)

		button.BackgroundTransparency =
			(partName == SilentAimHitPart)
				and 0.48
				or 0.66

		button.Text = partName
		button.TextColor3 = COLORS.White
		button.TextSize = 9
		button.Font = Enum.Font.GothamBold
		button.ZIndex = 9
		button.Parent = row

		Instance.new("UICorner", button).CornerRadius =
			UDim.new(0, 4)

		buttons[partName] = button

		button.MouseButton1Click:Connect(function()
			applySelection(partName)
		end)
	end

	SettingsVisual.SetSilentAimHitPart =
		applySelection

	return applySelection
end

MakeSilentAimHitPartButtons(silentLeft)

-- Selector REUTILIZABLE: misma UI con avatar, armas y rarezas de ESP Armas.
-- Se instancian dos controles independientes: Vehicle y Silent Aim/Auto Shoot.
SettingsVisual.CreateWeaponPlayerSelector = function(parent, kind)
    local isAuto = kind == "AutoShoot"
    local selectionKey = isAuto and "AutoShootSelectedPlayer" or "SelectedVehiclePlayer"
    local row = Instance.new("Frame", parent)
    row.Name = isAuto and "AutoShootPlayerSelector" or "VehiclePlayerSelector"
    row.Size = UDim2.new(1, 0, 0, 84)
    -- Mismo cristal discreto de las filas MakeToggle/MakeSlider del HUB.
    row.BackgroundColor3 = Color3.fromRGB(20, 24, 38)
    row.BackgroundTransparency = 0.60
    row.BorderSizePixel = 0
    row.ZIndex = 35
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 7)
    local rowGradient=Instance.new("UIGradient", row)
    rowGradient.Color=ColorSequence.new({
        ColorSequenceKeypoint.new(0,Color3.fromRGB(28,45,82)),
        ColorSequenceKeypoint.new(0.55,Color3.fromRGB(15,24,44)),
        ColorSequenceKeypoint.new(1,Color3.fromRGB(32,22,69))
    })
    local rowBorder=Instance.new("UIStroke",row)
    rowBorder.Color=Color3.fromRGB(104,176,255)
    rowBorder.Thickness=1.7
    rowBorder.Transparency=0.08
    local gradientStroke=Instance.new("UIGradient",rowBorder)
    gradientStroke.Color=ColorSequence.new({
        ColorSequenceKeypoint.new(0,Color3.fromRGB(27,222,255)),
        ColorSequenceKeypoint.new(0.55,Color3.fromRGB(123,75,255)),
        ColorSequenceKeypoint.new(1,Color3.fromRGB(255,85,219))
    })

    local avatar = Instance.new("ImageLabel", row)
    avatar.Size = UDim2.fromOffset(38, 38)
    avatar.Position = UDim2.fromOffset(8, 6)
    avatar.BackgroundTransparency = 1
    avatar.ZIndex = 36
    Instance.new("UICorner", avatar).CornerRadius = UDim.new(1, 0)
    local avatarBorder=Instance.new("UIStroke",avatar)
    avatarBorder.Color=Color3.fromRGB(105,224,255)
    avatarBorder.Thickness=2

    local weaponPreview = Instance.new("Frame", row)
    weaponPreview.Size = UDim2.fromOffset(28, 28)
    weaponPreview.Position = UDim2.fromOffset(51, 11)
    weaponPreview.BackgroundTransparency = 1
    weaponPreview.ZIndex = 36

    local button = Instance.new("TextButton", row)
    -- Area tactil ANCHA en toda la fila: antes se encogia en moviles.
    button.Name = "OpenEnemySelector"
    button.Size = UDim2.new(1, -12, 0, 30)
    button.Position = UDim2.fromOffset(6, 49)
    button.BackgroundColor3 = Color3.fromRGB(32, 57, 95)
    button.BackgroundTransparency = 0.22
    button.TextColor3 = COLORS.White
    button.TextSize = 11
    button.Font = Enum.Font.GothamBold
    button.TextTruncate = Enum.TextTruncate.AtEnd
    button.TextXAlignment = Enum.TextXAlignment.Left
    button.ZIndex = 36
    Instance.new("UICorner", button).CornerRadius = UDim.new(0, 7)
    local buttonGradient=Instance.new("UIGradient", button)
    buttonGradient.Color=ColorSequence.new(Color3.fromRGB(42,92,160),Color3.fromRGB(70,41,115))
    buttonGradient.Rotation=18
    local selectBorder=Instance.new("UIStroke",button)
    selectBorder.Color=Color3.fromRGB(126,211,255)
    selectBorder.Thickness=2.0
    selectBorder.Transparency=0.08

    local openArrow = Instance.new("TextLabel", button)
    openArrow.Name = "ExpandArrow"
    openArrow.AnchorPoint = Vector2.new(1, 0.5)
    openArrow.Position = UDim2.new(1, -4, 0.5, 0)
    openArrow.Size = UDim2.fromOffset(27, 23)
    openArrow.BackgroundColor3 = Color3.fromRGB(45, 97, 170)
    openArrow.BackgroundTransparency = 0.12
    openArrow.Text = "▼"
    openArrow.TextSize = 15
    openArrow.Font = Enum.Font.GothamBold
    openArrow.TextColor3 = Color3.fromRGB(255, 255, 255)
    openArrow.ZIndex = 38
    Instance.new("UICorner", openArrow).CornerRadius = UDim.new(0, 6)
    local arrowStroke=Instance.new("UIStroke",openArrow)
    arrowStroke.Color=Color3.fromRGB(166,225,255)
    arrowStroke.Thickness=1.2
    arrowStroke.Transparency=0.15

    local selectorCaption=Instance.new("TextLabel",row)
    selectorCaption.Name="SelectorCaption"
    selectorCaption.Position=UDim2.fromOffset(85, 5)
    selectorCaption.Size=UDim2.new(1,-161,0,38)
    selectorCaption.BackgroundTransparency=1
    selectorCaption.Text="" -- Retirado: texto duplicado detras de ambos selectores.
    selectorCaption.Visible=false
    selectorCaption.TextColor3=Color3.fromRGB(218,234,255)
    selectorCaption.TextSize=10
    selectorCaption.Font=Enum.Font.GothamBold
    selectorCaption.TextXAlignment=Enum.TextXAlignment.Left
    selectorCaption.TextYAlignment=Enum.TextYAlignment.Center
    selectorCaption.ZIndex=36

    local resetButton=Instance.new("TextButton",row)
    resetButton.Name="ResetSelection"
    resetButton.Size=UDim2.fromOffset(64,32)
    resetButton.Position=UDim2.new(1,-70,0,9)
    resetButton.BackgroundColor3=Color3.fromRGB(26,47,77)
    resetButton.BackgroundTransparency=0.22
    resetButton.BorderSizePixel=0
    resetButton.Text="RESET"
    resetButton.TextSize=9
    resetButton.TextColor3=Color3.fromRGB(224,240,255)
    resetButton.Font=Enum.Font.GothamBold
    resetButton.ZIndex=38
    Instance.new("UICorner",resetButton).CornerRadius=UDim.new(0,6)
    local resetGradient=Instance.new("UIGradient",resetButton)
    resetGradient.Color=ColorSequence.new(Color3.fromRGB(40,71,116),Color3.fromRGB(43,31,86))
    local resetBorder=Instance.new("UIStroke",resetButton)
    resetBorder.Color=Color3.fromRGB(90,177,255)
    resetBorder.Thickness=1

    -- Lista fuera del recorte de la fila, para poder desplazarla en móvil.
    local popup = Instance.new("Frame", row)
    popup.Name = "PlayerDropdown"
    popup.Position = UDim2.new(0, 0, 1, 4)
    popup.Size = UDim2.new(1, 0, 0, 196)
    popup.BackgroundColor3 = Color3.fromRGB(18, 28, 48)
    popup.BackgroundTransparency = 0.06
    popup.BorderSizePixel = 0
    popup.Visible = false
    popup.ZIndex = 70
    Instance.new("UICorner", popup).CornerRadius = UDim.new(0, 8)
    local popupStroke = Instance.new("UIStroke", popup)
    popupStroke.Color = Color3.fromRGB(112,188,255)
    popupStroke.Thickness = 1.6
    local popupStrokeGradient=Instance.new("UIGradient",popupStroke)
    popupStrokeGradient.Color=ColorSequence.new(Color3.fromRGB(27,225,255),Color3.fromRGB(170,91,255))

    local scroll = Instance.new("ScrollingFrame", popup)
    scroll.Name = "PlayerList"
    scroll.Size = UDim2.new(1, -8, 1, -8)
    scroll.Position = UDim2.fromOffset(4, 4)
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 4
    scroll.ScrollingDirection = Enum.ScrollingDirection.Y
    scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    scroll.ZIndex = 71
    local layout = Instance.new("UIListLayout", scroll)
    layout.Padding = UDim.new(0, 4)
    layout.SortOrder = Enum.SortOrder.LayoutOrder

    -- CHINO: ambos selectores con la MISMA apariencia que el HUD:
    -- fondos gris azulados transparentes, bordes discretos, SIN neón RGB.
    -- No se modifica lista, click, RESET, avatares, armas ni prioridades.
    -- El dropdown mantiene fondo sólido: evita textos de opciones situadas
    -- por detrás (un bug que ya habíamos corregido anteriormente).
    local currentSelectorLow = nil
    local function applySelectorTheme()
        local low = SettingsVisual.IsLowPerformance and SettingsVisual.IsLowPerformance() or false
        if currentSelectorLow == low then return end
        currentSelectorLow = low

        -- Mismo fondo que MakeToggle: RGB(20,24,38), transparencia 0.60.
        row.BackgroundColor3 = Color3.fromRGB(20,24,38)
        row.BackgroundTransparency = 0.60
        rowGradient.Enabled = false
        rowBorder.Color = Color3.fromRGB(96,130,165)
        rowBorder.Thickness = 0.9
        rowBorder.Transparency = low and 0.86 or 0.79
        gradientStroke.Enabled = false

        -- Barra para abrir la lista: táctil, ancho original, cristal suave.
        button.BackgroundColor3 = Color3.fromRGB(20,24,38)
        button.BackgroundTransparency = low and 0.58 or 0.52
        buttonGradient.Enabled = false
        selectBorder.Color = Color3.fromRGB(98,145,185)
        selectBorder.Thickness = 1
        selectBorder.Transparency = low and 0.77 or 0.70
        button.TextColor3 = COLORS.White

        -- Flecha distinguible, pero sin recuadro brillante diferente al HUB.
        openArrow.BackgroundColor3 = Color3.fromRGB(39,65,90)
        openArrow.BackgroundTransparency = low and 0.48 or 0.44
        openArrow.TextColor3 = COLORS.White
        arrowStroke.Color = Color3.fromRGB(128,171,208)
        arrowStroke.Thickness = 0.9
        arrowStroke.Transparency = 0.65

        resetButton.BackgroundColor3 = Color3.fromRGB(20,24,38)
        resetButton.BackgroundTransparency = low and 0.61 or 0.56
        resetGradient.Enabled = false
        resetBorder.Color = Color3.fromRGB(103,144,180)
        resetBorder.Thickness = 0.9
        resetBorder.Transparency = 0.78
        resetButton.TextColor3 = COLORS.White
        avatarBorder.Color = Color3.fromRGB(190,217,235)
        avatarBorder.Thickness = 1.1

        -- Dropdown sobrio del mismo color que las filas.
        -- OPAQUE evita que se lea texto viejo desde detrás del selector.
        popup.BackgroundColor3 = Color3.fromRGB(20,24,38)
        popup.BackgroundTransparency = 0
        popupStroke.Color = Color3.fromRGB(97,135,171)
        popupStroke.Thickness = 1
        popupStroke.Transparency = low and 0.64 or 0.55
        popupStrokeGradient.Enabled = false
    end
    applySelectorTheme()

    local thumbCache = {}
    local function getAvatar(pl, label)
        if not pl then return end
        if thumbCache[pl.UserId] then
            label.Image = thumbCache[pl.UserId]
            return
        end
        task.spawn(function()
            local ok, img = pcall(function()
                return Players:GetUserThumbnailAsync(pl.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
            end)
            if ok and label.Parent then
                thumbCache[pl.UserId] = img
                label.Image = img
            end
        end)
    end

    -- ESP Armas y los dos selectores usan el MISMO escáner actualizado.
    -- Fuente real: Character / Backpack / inventario visible; "V" = visto antes.
    local function getWeaponInfos(pl)
        return pl and SettingsVisual.GetChinoWeaponVisuals(pl) or {}
    end

    local function fillWeapons(parent, pl, iconSize, maxIcons)
        for _,child in ipairs(parent:GetChildren()) do child:Destroy() end
        local infos=getWeaponInfos(pl)
        for i=1,math.min(#infos,maxIcons or 3) do
            local info=infos[i]
            local icon=Instance.new("ImageLabel",parent)
            icon.Size=UDim2.fromOffset(iconSize,iconSize)
            icon.Position=UDim2.fromOffset((i-1)*(iconSize+2),0)
            icon.BackgroundTransparency=info.Current and 1 or 0.54
            icon.BackgroundColor3=Color3.fromRGB(37,40,53)
            icon.ScaleType=Enum.ScaleType.Fit
            local realImage=ChinoNormalizarIcono(info.ImageId)
            icon.Image=realImage or ""
            icon.ImageTransparency=info.Current and 0 or 0.45
            icon.ZIndex=parent.ZIndex+1
            local stroke=Instance.new("UIStroke",icon)
            stroke.Color=RarityColors[info.Rarity] or Color3.fromRGB(255,255,255)
            stroke.Thickness=info.Current and 1.5 or 0.8
            -- No dibujar una X ni un icono de relleno si el arma
            -- no expone un asset real: oculta el hueco del selector.
            icon.Visible=realImage~=nil
            Instance.new("UICorner",icon).CornerRadius=UDim.new(1,0)
            if info.Source=="Seen" then
                local seen=Instance.new("TextLabel",icon)
                seen.Size=UDim2.fromOffset(10,10)
                seen.Position=UDim2.new(1,-10,1,-10)
                seen.BackgroundColor3=Color3.fromRGB(20,20,30)
                seen.BackgroundTransparency=0.1
                seen.Text="V"
                seen.TextColor3=Color3.fromRGB(230,230,230)
                seen.TextSize=9
                seen.Font=Enum.Font.GothamBold
                seen.ZIndex=icon.ZIndex+2
            end
        end
    end

    local function getChoices()
        local players = {}
        for _, pl in ipairs(Players:GetPlayers()) do
            if pl ~= Player then table.insert(players, pl) end
        end
        table.sort(players, function(x, y) return x.Name:lower() < y.Name:lower() end)
        return players
    end

    local function choose(pl)
        SettingsVisual[selectionKey] = pl
        if isAuto then
            -- Objetivo MANUAL exclusivo: aguarda a que esté visible, armado,
            -- dentro de 90 m y fuera de zona segura; nunca cambia por otro.
            SettingsVisual.AutoShootLockedTarget = nil
            SettingsVisual.AutoShootScanNext = 0
        else
            SettingsVisual.VehicleRarityTarget = nil
            SettingsVisual.VehicleRarityTargetInfo = nil
            SettingsVisual.VehicleRarityArrived = false
        end
        popup.Visible = false
    end

    local function refresh()
        local choices = getChoices()
        local selected = SettingsVisual[selectionKey]
        if selected and not table.find(choices, selected) then
            selected = nil
            SettingsVisual[selectionKey] = nil
        end
        -- El boton ancho nunca se reduce a una rayita en pantallas moviles.
        -- El icono de flecha es independiente del texto y siempre visible.
        applySelectorTheme()
        button.Text = selected and ("  "..selected.DisplayName)
            or (isAuto and "  AUTO  /  ELEGIR ENEMIGO" or "  ELEGIR ENEMIGO")
        openArrow.Text = popup.Visible and "▲" or "▼"
        avatar.Image = ""
        if selected then getAvatar(selected, avatar) end
        fillWeapons(weaponPreview, selected, 26, 1)

        if not popup.Visible then return end
        for _, child in ipairs(scroll:GetChildren()) do
            if child ~= layout then child:Destroy() end
        end
        if isAuto then
            local autoEntry = Instance.new("TextButton", scroll)
            autoEntry.Name = "AutoTarget"
            autoEntry.Size = UDim2.new(1, -6, 0, 34)
            autoEntry.BackgroundColor3 = not selected and Color3.fromRGB(35,67,98)
                or Color3.fromRGB(27,34,49)
            autoEntry.BackgroundTransparency = currentSelectorLow and 0.25 or 0.20
            autoEntry.Text = "AUTO  ·  Objetivo cercano"
            autoEntry.TextColor3 = COLORS.White
            autoEntry.TextSize = 10
            autoEntry.Font = Enum.Font.GothamBold
            autoEntry.ZIndex = 72
            autoEntry.LayoutOrder = 0
            Instance.new("UICorner", autoEntry).CornerRadius = UDim.new(0, 5)
            autoEntry.MouseButton1Click:Connect(function() choose(nil); refresh() end)
        end
        for i, pl in ipairs(choices) do
            local entry = Instance.new("TextButton", scroll)
            entry.Name = "Player_" .. pl.Name
            entry.Size = UDim2.new(1, -6, 0, 43)
            entry.BackgroundColor3 = pl == selected and Color3.fromRGB(35,67,98)
                or Color3.fromRGB(27,34,49)
            entry.BackgroundTransparency = currentSelectorLow and 0.25 or 0.20
            entry.Text = ""
            entry.BorderSizePixel = 0
            entry.LayoutOrder = i
            entry.ZIndex = 72
            Instance.new("UICorner", entry).CornerRadius = UDim.new(0, 7)
            local entryBorder=Instance.new("UIStroke",entry)
            entryBorder.Color=pl==selected and Color3.fromRGB(99,166,205)
                or Color3.fromRGB(89,123,154)
            entryBorder.Thickness=pl==selected and 1.2 or 0.8
            entryBorder.Transparency=pl==selected and 0.40 or 0.80
            local face = Instance.new("ImageLabel", entry)
            face.Size = UDim2.fromOffset(33, 33)
            face.Position = UDim2.fromOffset(5, 5)
            face.BackgroundTransparency = 1
            face.ZIndex = 73
            Instance.new("UICorner", face).CornerRadius = UDim.new(1, 0)
            local faceBorder=Instance.new("UIStroke",face)
            faceBorder.Color=Color3.fromRGB(181,205,228)
            faceBorder.Thickness=1
            getAvatar(pl, face)
            local name = Instance.new("TextLabel", entry)
            name.Position = UDim2.fromOffset(43, 4)
            name.Size = UDim2.new(1, -114, 0, 34)
            name.BackgroundTransparency = 1
            name.Text = pl.DisplayName
            name.TextTruncate = Enum.TextTruncate.AtEnd
            name.TextColor3 = COLORS.White
            name.TextSize = 10
            name.Font = Enum.Font.GothamBold
            name.TextXAlignment = Enum.TextXAlignment.Left
            name.ZIndex = 73
            local icons = Instance.new("Frame", entry)
            icons.Position = UDim2.new(1, -66, 0, 11)
            icons.Size = UDim2.fromOffset(63, 22)
            icons.BackgroundTransparency = 1
            icons.ZIndex = 73
            fillWeapons(icons, pl, 19, 3)
            entry.MouseButton1Click:Connect(function() choose(pl); refresh() end)
        end
    end

    resetButton.Activated:Connect(function()
        choose(nil)
        if isAuto then
            -- Reset vuelve al modo AUTO con 90 m y solo armas.
            SettingsVisual.AutoShootSelectedPlayer=nil
            SettingsVisual.AutoShootLockedTarget=nil
            SettingsVisual.AutoShootScanNext=0
        else
            SettingsVisual.SelectedVehiclePlayer=nil
            SettingsVisual.VehicleRarityTarget=nil
        end
        refresh()
    end)
    button.MouseButton1Click:Connect(function()
        popup.Visible = not popup.Visible
        refresh()
    end)
    Players.PlayerAdded:Connect(refresh)
    Players.PlayerRemoving:Connect(function(pl)
        if SettingsVisual[selectionKey] == pl then
            SettingsVisual[selectionKey] = nil
            if isAuto then SettingsVisual.AutoShootLockedTarget = nil end
        end
        task.defer(refresh)
    end)
    task.spawn(function()
        while row.Parent do
            refresh()
            task.wait(popup.Visible and 1 or 2)
        end
    end)
    refresh()
end


-- Menú: Auto Shoot a pie y en carro. Sigue en 90m y con línea de visión.
-- A pie solo escanea armas moradas/legendarias, nunca recuerdos "Visto".
MakeToggle(silentRight,"Auto Shoot",false,function(v)
    SettingsVisual.AutoShootEnabled = v and true or false
    SettingsVisual.AutoShootScanNext = 0
    SettingsVisual.AutoShootLockedTarget = nil
    if v then SettingsVisual.AutoShootResetManualBudget() end
end)
-- Igual que el selector de Vehicle: avatar, inventario y rarezas en vivo.
-- El jugador elegido tiene PRIORIDAD EXCLUSIVA sobre la búsqueda automática.
SettingsVisual.AutoShootSelectedPlayer = nil
SettingsVisual.CreateWeaponPlayerSelector(silentRight, "AutoShoot")
MakeSlider(silentRight,"Auto Shoot Speed",1.0,0.8,1.5,function(v)
    SettingsVisual.AutoShootInterval = math.clamp(tonumber(v) or 1.0,0.8,1.5)
end)

MakeToggle(silentRight, "Auto Attack Target", false, function(v)
	-- Control adicional existente: utiliza ahora el mismo Auto Attack NGU4.
	SettingsVisual.NGU4Melee.SetAuto(v)
end)

-- CHINO: el otro lado del Silent Aim está vacío; añadir aquí sin alterar
-- Silent Aim, Target Line, Head/Neck/Chest ni Auto Attack Target.
MakeToggle(silentRight, "Smart Predict", false, function(v)
	SettingsVisual.ChinoSmartPredictEnabled = v and true or false
	SettingsVisual.ChinoPredictHistory = {}
	SettingsVisual.ChinoPredictSpikes = {}
end)
MakeSlider(silentRight, "Velocity Threshold", 250, 100, 500, function(v)
	SettingsVisual.ChinoVelocityThreshold = tonumber(v) or 250
end)
-- Se eliminó el toggle "Gun Aura (Silent Aim)" que estaba al final.
-- Auto Shoot permanece independiente en esta página.
SettingsVisual.GunAuraEnabled = false

-- SOFT AIM

-- Aimbot fuerte: se fija automáticamente al mejor objetivo dentro del FOV.
SettingsVisual.SetStrongAimbotEnabled = MakeToggle(softAimLeft, "Aimbot", false, function(v)
	SettingsVisual.StrongAimbotEnabled = v and true or false

	if not v then
		SettingsVisual.StrongAimbotTarget = nil
	else
		-- Evita que dos sistemas de cámara peleen entre sí.
		if SettingsVisual.SetSoftAimMobileEnabled then
			SettingsVisual.SetSoftAimMobileEnabled(false)
		end
		if SettingsVisual.SetSoftAimPCEnabled then
			SettingsVisual.SetSoftAimPCEnabled(false)
		end

		SettingsVisual.StrongAimbotTarget = SettingsVisual.GetStrongAimbotTarget(
			SoftAimMobileFOVRadius,
			not SettingsVisual.SoftAimMobileWallcheck
		)
	end
end)

-- Aimbot táctil: muestra la bolita AIM y solo apunta al mantenerla/tocarla.
SettingsVisual.SetSoftAimMobileEnabled = MakeToggle(softAimLeft, "Aimbot Táctil", false, function(v)
	SoftAimMobileEnabled = v
	if not v then
		SettingsVisual.SoftAimMobileHolding = false
		SettingsVisual.SoftAimLockedTarget = nil
	end
	if SettingsVisual.SoftAimTriggerGui then
		SettingsVisual.SoftAimTriggerGui.Enabled = v and true or false
	end
	if v and SettingsVisual.SetSoftAimPCEnabled then
		SettingsVisual.SetSoftAimPCEnabled(false)
	end
	if v and SettingsVisual.SetStrongAimbotEnabled then
		SettingsVisual.SetStrongAimbotEnabled(false)
	end
end)

-- Botón pequeño al lado de Aimbot Táctil para elegir tecla/gatillo del control.
do
	local aimRow = nil
	for _, child in ipairs(softAimLeft:GetChildren()) do
		if child:IsA("Frame") then
			for _, sub in ipairs(child:GetChildren()) do
				if sub:IsA("TextLabel") and sub.Text == "Aimbot Táctil" then
					aimRow = child
					sub.Size = UDim2.new(1, -88, 1, 0)
					break
				end
			end
		end
		if aimRow then break end
	end

	if aimRow then
		local controlBtn = Instance.new("TextButton")
		controlBtn.Name = "SoftAimControlKey"
		controlBtn.Size = UDim2.fromOffset(38, 18)
		controlBtn.Position = UDim2.new(1, -78, 0.5, -9)
		controlBtn.BackgroundColor3 = Color3.fromRGB(28, 34, 48)
		controlBtn.BackgroundTransparency = 0.38
		controlBtn.BorderSizePixel = 0
		controlBtn.Text = "L2"
		controlBtn.TextColor3 = COLORS.BlueBright
		controlBtn.TextSize = 9
		controlBtn.Font = Enum.Font.GothamBold
		controlBtn.AutoButtonColor = false
		controlBtn.ZIndex = 10
		controlBtn.Parent = aimRow
		Instance.new("UICorner", controlBtn).CornerRadius = UDim.new(0, 5)

		local function keyText(key)
			if not key then return "L2" end
			local name = key.Name or tostring(key)
			return name:gsub("^Button", "")
		end

		SettingsVisual.SetSoftAimControlKey = function(value)
			local key = value
			if typeof(value) ~= "EnumItem" then
				key = Enum.KeyCode[tostring(value)]
			end
			if key then
				SettingsVisual.SoftAimControlKey = key
				controlBtn.Text = keyText(key)
			end
		end

		controlBtn.MouseButton1Click:Connect(function()
			SettingsVisual.SelectingSoftAimControlKey = true
			controlBtn.Text = "..."
		end)

		UserInputService.InputBegan:Connect(function(input)
			if SettingsVisual.SelectingSoftAimControlKey then
				local inputName = input.UserInputType.Name
				local isGamepad = inputName:find("Gamepad") ~= nil
				local isKeyboard = input.UserInputType == Enum.UserInputType.Keyboard
				if isGamepad or isKeyboard then
					if input.KeyCode ~= Enum.KeyCode.Unknown then
						SettingsVisual.SetSoftAimControlKey(input.KeyCode)
						SettingsVisual.SelectingSoftAimControlKey = false
					end
				end
				return
			end

			if SoftAimMobileEnabled and input.KeyCode == SettingsVisual.SoftAimControlKey then
				SettingsVisual.SoftAimMobileHolding = true
				SettingsVisual.SoftAimLockedTarget = GetBestVisualTarget(
					SoftAimMobileFOVRadius,
					not SettingsVisual.SoftAimMobileWallcheck
				)
			end
		end)

		UserInputService.InputEnded:Connect(function(input)
			if input.KeyCode == SettingsVisual.SoftAimControlKey then
				SettingsVisual.SoftAimMobileHolding = false
				SettingsVisual.SoftAimLockedTarget = nil
			end
		end)

		SettingsVisual.SetSoftAimControlKey(SettingsVisual.SoftAimControlKey)
	end
end

SettingsVisual.SetSoftAimMobileWallcheck = MakeToggle(softAimLeft, "Wallcheck", false, function(v)
	SettingsVisual.SoftAimMobileWallcheck = v
	if v and SettingsVisual.SetSoftAimPCWallcheck then
		SettingsVisual.SetSoftAimPCWallcheck(false)
	end
end)
MakeHitPartButtons(softAimLeft, true, false)
MakeToggle(softAimLeft, "Mostrar FOV", false, function(v) SoftAimMobileFOV = v end)
MakeSlider(softAimLeft, "Radio FOV Mobile", 95, 20, 800, function(v) SoftAimMobileFOVRadius = v end)
MakeToggle(softAimLeft, "Bloquear botón AIM", false, function(v)
	SettingsVisual.SoftAimTriggerLocked = v and true or false
end)

SettingsVisual.SetSoftAimTriggerHidden = MakeToggle(softAimLeft, "Ocultar botón AIM", false, function(v)
	SettingsVisual.SoftAimTriggerHidden = v and true or false
	SettingsVisual.SoftAimMobileHolding = false
	SettingsVisual.SoftAimHiddenTriggerInput = nil
	if SettingsVisual.SoftAimTriggerButton then
		SettingsVisual.SoftAimTriggerButton.Visible = not SettingsVisual.SoftAimTriggerHidden
		SettingsVisual.SoftAimTriggerButton.Active = not SettingsVisual.SoftAimTriggerHidden
	end
end)

-- Ajustador vertical SOLO PARA VEHÍCULO.
-- El ajuste horizontal queda fijo en -14 y ya no se muestra.
-- Esta barra pequeña sin nombre corrige arriba/abajo; el número aparece al moverla.
do
	local row = Instance.new("Frame")
	row.Size = UDim2.new(1, 0, 0, 25)
	row.BackgroundTransparency = 1
	row.BorderSizePixel = 0
	row.ZIndex = 8
	row.Parent = softAimLeft

	local bar = Instance.new("Frame")
	bar.Size = UDim2.new(1, -22, 0, 4)
	bar.Position = UDim2.new(0, 11, 0.5, -2)
	bar.BackgroundColor3 = Color3.fromRGB(35, 40, 52)
	bar.BackgroundTransparency = 0.34
	bar.BorderSizePixel = 0
	bar.Active = true
	bar.ZIndex = 8
	bar.Parent = row
	Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)

	local fill = Instance.new("Frame")
	fill.BackgroundColor3 = COLORS.Blue
	fill.BackgroundTransparency = 0.12
	fill.BorderSizePixel = 0
	fill.ZIndex = 9
	fill.Parent = bar
	Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

	local dot = Instance.new("Frame")
	dot.Size = UDim2.fromOffset(11, 11)
	dot.AnchorPoint = Vector2.new(0.5, 0.5)
	dot.Position = UDim2.new(1, 0, 0.5, 0)
	dot.BackgroundColor3 = COLORS.White
	dot.BackgroundTransparency = 0.04
	dot.BorderSizePixel = 0
	dot.Active = true
	dot.ZIndex = 10
	dot.Parent = fill
	Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

	local valueText = Instance.new("TextLabel")
	valueText.Size = UDim2.fromOffset(42, 15)
	valueText.AnchorPoint = Vector2.new(0.5, 1)
	valueText.Position = UDim2.new(0.5, 0, 0.5, -5)
	valueText.BackgroundColor3 = Color3.fromRGB(8, 12, 20)
	valueText.BackgroundTransparency = 0.35
	valueText.BorderSizePixel = 0
	valueText.Text = ""
	valueText.TextColor3 = COLORS.White
	valueText.TextSize = 9
	valueText.Font = Enum.Font.GothamMedium
	valueText.Visible = false
	valueText.ZIndex = 11
	valueText.Parent = row
	Instance.new("UICorner", valueText).CornerRadius = UDim.new(0, 5)

	local minValue, maxValue = -30, 30
	local dragging = false
	local hideToken = 0

	local function setValue(value, showNumber)
		value = math.clamp(math.floor((tonumber(value) or 0) + 0.5), minValue, maxValue)
		SettingsVisual.VehicleAimOffsetY = value
		local alpha = (value - minValue) / (maxValue - minValue)
		fill.Size = UDim2.new(alpha, 0, 1, 0)

		if showNumber then
			hideToken = hideToken + 1
			local myToken = hideToken
			valueText.Text = (value > 0 and "+" or "") .. tostring(value)
			valueText.Visible = true
			task.delay(0.75, function()
				if myToken == hideToken and not dragging then
					valueText.Visible = false
				end
			end)
		end
	end

	SettingsVisual.SetVehicleAimOffsetY = function(value)
		setValue(value, false)
	end

	local function applyInput(input)
		if bar.AbsoluteSize.X <= 0 then return end
		local alpha = math.clamp((input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
		setValue(minValue + ((maxValue - minValue) * alpha), true)
	end

	bar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			applyInput(input)
		end
	end)

	dot.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			applyInput(input)
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
			applyInput(input)
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
			hideToken = hideToken + 1
			local myToken = hideToken
			task.delay(0.55, function()
				if myToken == hideToken and not dragging then
					valueText.Visible = false
				end
			end)
		end
	end)

	setValue(-30, false)
end

-- Ajustador horizontal SOLO PARA VEHÍCULO.
-- Independiente del vertical: no toca VehicleAimOffsetY.
-- Sin nombre y muestra el número únicamente mientras lo mueves.
do
	local row = Instance.new("Frame")
	row.Size = UDim2.new(1, 0, 0, 25)
	row.BackgroundTransparency = 1
	row.BorderSizePixel = 0
	row.ZIndex = 8
	row.Parent = softAimLeft

	local bar = Instance.new("Frame")
	bar.Size = UDim2.new(1, -22, 0, 4)
	bar.Position = UDim2.new(0, 11, 0.5, -2)
	bar.BackgroundColor3 = Color3.fromRGB(35, 40, 52)
	bar.BackgroundTransparency = 0.34
	bar.BorderSizePixel = 0
	bar.Active = true
	bar.ZIndex = 8
	bar.Parent = row
	Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)

	local fill = Instance.new("Frame")
	fill.BackgroundColor3 = COLORS.Blue
	fill.BackgroundTransparency = 0.12
	fill.BorderSizePixel = 0
	fill.ZIndex = 9
	fill.Parent = bar
	Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

	local dot = Instance.new("Frame")
	dot.Size = UDim2.fromOffset(11, 11)
	dot.AnchorPoint = Vector2.new(0.5, 0.5)
	dot.Position = UDim2.new(1, 0, 0.5, 0)
	dot.BackgroundColor3 = COLORS.White
	dot.BackgroundTransparency = 0.04
	dot.BorderSizePixel = 0
	dot.Active = true
	dot.ZIndex = 10
	dot.Parent = fill
	Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

	local valueText = Instance.new("TextLabel")
	valueText.Size = UDim2.fromOffset(42, 15)
	valueText.AnchorPoint = Vector2.new(0.5, 1)
	valueText.Position = UDim2.new(0.5, 0, 0.5, -5)
	valueText.BackgroundColor3 = Color3.fromRGB(8, 12, 20)
	valueText.BackgroundTransparency = 0.35
	valueText.BorderSizePixel = 0
	valueText.Text = ""
	valueText.TextColor3 = COLORS.White
	valueText.TextSize = 9
	valueText.Font = Enum.Font.GothamMedium
	valueText.Visible = false
	valueText.ZIndex = 11
	valueText.Parent = row
	Instance.new("UICorner", valueText).CornerRadius = UDim.new(0, 5)

	local minValue, maxValue = -30, 30
	local dragging = false
	local hideToken = 0

	local function setValue(value, showNumber)
		value = math.clamp(math.floor((tonumber(value) or -14) + 0.5), minValue, maxValue)
		SettingsVisual.VehicleAimOffsetX = value
		local alpha = (value - minValue) / (maxValue - minValue)
		fill.Size = UDim2.new(alpha, 0, 1, 0)

		if showNumber then
			hideToken = hideToken + 1
			local myToken = hideToken
			valueText.Text = (value > 0 and "+" or "") .. tostring(value)
			valueText.Visible = true
			task.delay(0.75, function()
				if myToken == hideToken and not dragging then
					valueText.Visible = false
				end
			end)
		end
	end

	SettingsVisual.SetVehicleAimOffsetX = function(value)
		setValue(value, false)
	end

	local function applyInput(input)
		if bar.AbsoluteSize.X <= 0 then return end
		local alpha = math.clamp(
			(input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X,
			0,
			1
		)
		setValue(minValue + ((maxValue - minValue) * alpha), true)
	end

	bar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Touch
			or input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			applyInput(input)
		end
	end)

	dot.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Touch
			or input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			applyInput(input)
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if dragging and (
			input.UserInputType == Enum.UserInputType.Touch
			or input.UserInputType == Enum.UserInputType.MouseMovement
		) then
			applyInput(input)
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Touch
			or input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
			hideToken = hideToken + 1
			local myToken = hideToken
			task.delay(0.55, function()
				if myToken == hideToken and not dragging then
					valueText.Visible = false
				end
			end)
		end
	end)

	setValue(-30, false)
end


do
	local row = Instance.new("Frame")
	row.Size = UDim2.new(1, 0, 0, 30)
	row.BackgroundColor3 = Color3.fromRGB(20, 24, 38)
	row.BackgroundTransparency = 0.6
	row.ZIndex = 8
	row.Parent = softAimRight
	Instance.new("UICorner", row).CornerRadius = UDim.new(0, 6)

	local label = Instance.new("TextLabel", row)
	label.Size = UDim2.new(1, -75, 1, 0)
	label.Position = UDim2.new(0, 8, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = "Aimbot Tecla"
	label.TextColor3 = COLORS.White
	label.TextSize = 11
	label.Font = Enum.Font.Gotham
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.ZIndex = 8

	local keyBtn = Instance.new("TextButton", row)
	keyBtn.Size = UDim2.new(0, 35, 0, 18)
	keyBtn.Position = UDim2.new(1, -74, 0.5, -9)
	keyBtn.BackgroundColor3 = Color3.fromRGB(35, 32, 45)
	keyBtn.Text = tostring(SoftAimPCKey.Name)
	keyBtn.TextColor3 = COLORS.BlueBright
	keyBtn.TextSize = 9
	keyBtn.Font = Enum.Font.GothamBold
	keyBtn.ZIndex = 9
	Instance.new("UICorner", keyBtn).CornerRadius = UDim.new(0, 4)

	local toggle = Instance.new("TextButton", row)
	toggle.Size = UDim2.new(0, 28, 0, 16)
	toggle.Position = UDim2.new(1, -34, 0.5, -8)
	toggle.BackgroundColor3 = SoftAimPCEnabled and COLORS.Blue or Color3.fromRGB(35, 32, 45)
	toggle.Text = ""
	toggle.ZIndex = 8
	Instance.new("UICorner", toggle).CornerRadius = UDim.new(1, 0)

	local circle = Instance.new("Frame", toggle)
	circle.Size = UDim2.new(0, 10, 0, 10)
	circle.Position = SoftAimPCEnabled and UDim2.new(1, -13, 0.5, -5) or UDim2.new(0, 3, 0.5, -5)
	circle.BackgroundColor3 = COLORS.White
	circle.BorderSizePixel = 0
	circle.ZIndex = 9
	Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)

	SettingsVisual.SetSoftAimPCEnabled = function(v)
		SoftAimPCEnabled = v and true or false
		if not SoftAimPCEnabled then
			SoftAimPCHolding = false
			SettingsVisual.SoftAimLockedTarget = nil
		end
		if SoftAimPCEnabled and SettingsVisual.SetSoftAimMobileEnabled then
			SettingsVisual.SetSoftAimMobileEnabled(false)
		end
		if SoftAimPCEnabled and SettingsVisual.SetStrongAimbotEnabled then
			SettingsVisual.SetStrongAimbotEnabled(false)
		end
		TweenService:Create(toggle, TweenInfo.new(0.18), {BackgroundColor3 = SoftAimPCEnabled and COLORS.Blue or Color3.fromRGB(35, 32, 45)}):Play()
		TweenService:Create(circle, TweenInfo.new(0.18), {Position = SoftAimPCEnabled and UDim2.new(1, -13, 0.5, -5) or UDim2.new(0, 3, 0.5, -5)}):Play()
	end

	toggle.MouseButton1Click:Connect(function()
		local nextValue = not SoftAimPCEnabled
		if nextValue and SettingsVisual.PlayToggleSound then SettingsVisual.PlayToggleSound() end
		SettingsVisual.SetSoftAimPCEnabled(nextValue)
	end)

	SettingsVisual.SetSoftAimPCKey = function(value)
		local key = value
		if typeof(value) ~= "EnumItem" then
			key = Enum.KeyCode[tostring(value)]
		end
		if key then
			SoftAimPCKey = key
			keyBtn.Text = tostring(key.Name)
		end
	end

	local selectingKey = false
	keyBtn.MouseButton1Click:Connect(function()
		selectingKey = true
		keyBtn.Text = "..."
	end)

	UserInputService.InputBegan:Connect(function(input, gp)
		if selectingKey and input.UserInputType == Enum.UserInputType.Keyboard then
			SettingsVisual.SetSoftAimPCKey(input.KeyCode)
			selectingKey = false
		elseif not gp and SoftAimPCEnabled and input.KeyCode == SoftAimPCKey then
			SoftAimPCHolding = true
			SettingsVisual.SoftAimLockedTarget = GetBestVisualTarget(
				SoftAimPCFOVRadius,
				not SettingsVisual.SoftAimPCWallcheck
			)
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.KeyCode == SoftAimPCKey then
			SoftAimPCHolding = false
			SettingsVisual.SoftAimLockedTarget = nil
		end
	end)
end

MakeHitPartButtons(softAimRight, true, true)
SettingsVisual.SetSoftAimPCWallcheck = MakeToggle(softAimRight, "Wallcheck", false, function(v)
	SettingsVisual.SoftAimPCWallcheck = v
	if v and SettingsVisual.SetSoftAimMobileWallcheck then
		SettingsVisual.SetSoftAimMobileWallcheck(false)
	end
end)
MakeToggle(softAimRight, "Mostrar FOV", false, function(v) SoftAimPCFOV = v end)
MakeSlider(softAimRight, "Radio FOV PC", 95, 20, 800, function(v) SoftAimPCFOVRadius = v end)

-- Botón flotante para Soft Aim móvil: mantener presionado = apuntar, soltar = liberar.
do
	local triggerGui = Instance.new("ScreenGui")
	triggerGui.Name = "SoftAimMobileTriggerGui"
	triggerGui.ResetOnSpawn = false
	triggerGui.IgnoreGuiInset = true
	triggerGui.DisplayOrder = 999998
	triggerGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	triggerGui.Enabled = SoftAimMobileEnabled
	triggerGui.Parent = SettingsVisual.ExecutorGuiParent or CoreGui

	local trigger = Instance.new("TextButton")
	trigger.Name = "AimTrigger"
	trigger.AnchorPoint = Vector2.new(0.5, 0.5)
	trigger.Position = UDim2.fromScale(0.82, 0.62)
	trigger.Size = UDim2.fromOffset(52, 52)
	trigger.BackgroundColor3 = Color3.fromRGB(20, 26, 40)
	trigger.BackgroundTransparency = 0.58
	trigger.BorderSizePixel = 0
	trigger.Text = "AIM"
	trigger.TextColor3 = Color3.fromRGB(225, 238, 255)
	trigger.TextTransparency = 0.10
	trigger.TextSize = 10
	trigger.Font = Enum.Font.GothamMedium
	trigger.AutoButtonColor = false
	trigger.Active = not SettingsVisual.SoftAimTriggerHidden
	trigger.Visible = not SettingsVisual.SoftAimTriggerHidden
	trigger.ZIndex = 20
	trigger.Parent = triggerGui
	Instance.new("UICorner", trigger).CornerRadius = UDim.new(1, 0)

	local stroke = Instance.new("UIStroke", trigger)
	stroke.Color = Color3.fromRGB(115, 170, 235)
	stroke.Thickness = 1
	stroke.Transparency = 0.45

	SettingsVisual.SoftAimTriggerGui = triggerGui
	SettingsVisual.SoftAimTriggerButton = trigger
	SettingsVisual.SoftAimTriggerInput = nil
	SettingsVisual.SoftAimTriggerUsingMouse = false
	SettingsVisual.SoftAimTriggerDragStart = nil
	SettingsVisual.SoftAimTriggerStartPos = nil

	local function beginTrigger(input)
		if not SoftAimMobileEnabled then return end
		if input.UserInputType ~= Enum.UserInputType.Touch and input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end

		SettingsVisual.SoftAimMobileHolding = true
		SettingsVisual.SoftAimLockedTarget = GetBestVisualTarget(
			SoftAimMobileFOVRadius,
			not SettingsVisual.SoftAimMobileWallcheck
		)
		SettingsVisual.SoftAimTriggerInput = input
		SettingsVisual.SoftAimTriggerUsingMouse = input.UserInputType == Enum.UserInputType.MouseButton1
		SettingsVisual.SoftAimTriggerDragStart = Vector2.new(input.Position.X, input.Position.Y)
		SettingsVisual.SoftAimTriggerStartPos = trigger.Position

		TweenService:Create(trigger, TweenInfo.new(0.12), {
			BackgroundTransparency = 0.38,
			Size = UDim2.fromOffset(55, 55)
		}):Play()
	end

	trigger.InputBegan:Connect(beginTrigger)

	UserInputService.InputChanged:Connect(function(input)
		if not SettingsVisual.SoftAimMobileHolding or SettingsVisual.SoftAimTriggerLocked then return end
		if not SettingsVisual.SoftAimTriggerDragStart or not SettingsVisual.SoftAimTriggerStartPos then return end

		local valid = false
		if SettingsVisual.SoftAimTriggerUsingMouse then
			valid = input.UserInputType == Enum.UserInputType.MouseMovement
		else
			valid = input == SettingsVisual.SoftAimTriggerInput
		end
		if not valid then return end

		local current = Vector2.new(input.Position.X, input.Position.Y)
		local delta = current - SettingsVisual.SoftAimTriggerDragStart
		local start = SettingsVisual.SoftAimTriggerStartPos
		trigger.Position = UDim2.new(
			start.X.Scale, start.X.Offset + delta.X,
			start.Y.Scale, start.Y.Offset + delta.Y
		)
	end)

	-- Con el botón oculto no bloqueamos el botón/interfaz que esté detrás.
	-- Observamos globalmente la misma zona donde quedó colocado el AIM.
	local function isInsideHiddenTrigger(input)
		if not trigger or not trigger.Parent then return false end
		local p = Vector2.new(input.Position.X, input.Position.Y)
		local ap = trigger.AbsolutePosition
		local as = trigger.AbsoluteSize
		return p.X >= ap.X and p.X <= (ap.X + as.X)
			and p.Y >= ap.Y and p.Y <= (ap.Y + as.Y)
	end

	UserInputService.InputBegan:Connect(function(input)
		if not SoftAimMobileEnabled or not SettingsVisual.SoftAimTriggerHidden then return end
		if input.UserInputType ~= Enum.UserInputType.Touch and input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
		if not isInsideHiddenTrigger(input) then return end

		SettingsVisual.SoftAimMobileHolding = true
		SettingsVisual.SoftAimLockedTarget = GetBestVisualTarget(
			SoftAimMobileFOVRadius,
			not SettingsVisual.SoftAimMobileWallcheck
		)
		SettingsVisual.SoftAimHiddenTriggerInput = input
	end)

	UserInputService.InputEnded:Connect(function(input)
		if SettingsVisual.SoftAimTriggerHidden and input == SettingsVisual.SoftAimHiddenTriggerInput then
			SettingsVisual.SoftAimMobileHolding = false
			SettingsVisual.SoftAimLockedTarget = nil
			SettingsVisual.SoftAimHiddenTriggerInput = nil
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		local ended = false
		if SettingsVisual.SoftAimTriggerUsingMouse then
			ended = input.UserInputType == Enum.UserInputType.MouseButton1
		else
			ended = input == SettingsVisual.SoftAimTriggerInput
		end
		if not ended then return end

		SettingsVisual.SoftAimMobileHolding = false
		SettingsVisual.SoftAimLockedTarget = nil
		SettingsVisual.SoftAimTriggerInput = nil
		SettingsVisual.SoftAimTriggerUsingMouse = false
		SettingsVisual.SoftAimTriggerDragStart = nil
		SettingsVisual.SoftAimTriggerStartPos = nil

		TweenService:Create(trigger, TweenInfo.new(0.12), {
			BackgroundTransparency = 0.58,
			Size = UDim2.fromOffset(52, 52)
		}):Play()
	end)
end

-- ESP
MakeToggle(espLeft, "ESP Box", false, function(v) PlayerESP_Box = v end)
MakeToggle(espLeft, "ESP Lines", false, function(v) SettingsVisual.PlayerESP_Lines = v end)
MakeToggle(espLeft, "ESP Highlight", false, function(v) PlayerESP_Highlight = v end)
MakeToggle(espLeft, "ESP Nombres", false, function(v) PlayerESP_Name = v end)

MakeToggle(espRight, "ESP Salud", false, function(v) PlayerESP_Health = v end)
MakeToggle(espRight, "ESP Distancia", false, function(v) PlayerESP_Dist = v end)
MakeToggle(espRight, "ESP Armas", false, function(v) WeaponESPEnabled = v end)
MakeToggle(espRight, "ESP Ítems", false, function(v) ItemESPEnabled = v end)
SettingsVisual.MakeActionButton(espRight, "Actualizar ESP", function()
	for _, pl in ipairs(Players:GetPlayers()) do
		if pl ~= Player then
			pcall(function()
				if PlayerBillboards[pl] and PlayerBillboards[pl].Billboard then PlayerBillboards[pl].Billboard:Destroy() end
				PlayerBillboards[pl] = nil
				if VisualPlayerObjects[pl] and VisualPlayerObjects[pl].Box then VisualPlayerObjects[pl].Box:Destroy() end
				VisualPlayerObjects[pl] = nil
				if HighlightCache[pl] then HighlightCache[pl]:Destroy() end
				HighlightCache[pl] = nil
				if WeaponBillboardCache[pl] then WeaponBillboardCache[pl]:Destroy() end
				WeaponBillboardCache[pl] = nil
				WeaponCacheTokens[pl] = nil
			end)
			SettingsVisual.RemoveModernESP(pl)
			CreateVisualPlayerObjects(pl)
			ensurePlayerESP(pl)
			SettingsVisual.EnsureModernESP(pl)
		end
	end
end, "", 0.72)

-- PLAYER
-- INFINITE HOTBAR (ZEION): busca get_max_items UNA VEZ y lo engancha con
-- una bandera reversible. OFF delega al método original del juego.
SettingsVisual.InfiniteHotbarEnabled = false
SettingsVisual.InfiniteHotbarHooked = false
SettingsVisual.TryInfiniteHotbarHook = function()
    if SettingsVisual.InfiniteHotbarHooked then return true end
    if type(getgc)~="function" or type(hookfunction)~="function" then
        warn("[CHINO Infinite Hotbar] executor sin getgc/hookfunction")
        return false
    end
    local ok,objects=pcall(function() return getgc(true) end)
    if not ok or type(objects)~="table" then return false end
    for _,fn in pairs(objects) do
        if type(fn)=="function" then
            local name=nil
            pcall(function()
                if debug and type(debug.getinfo)=="function" then
                    local info=debug.getinfo(fn)
                    name=info and info.name
                end
                if not name and debug and type(debug.info)=="function" then
                    name=debug.info(fn,"n")
                end
            end)
            if name=="get_max_items" then
                local original=nil
                local success=pcall(function()
                    original=hookfunction(fn,function(...)
                        if SettingsVisual.InfiniteHotbarEnabled then return 999 end
                        return original(...)
                    end)
                end)
                if success and type(original)=="function" then
                    SettingsVisual.InfiniteHotbarHooked=true
                    return true
                end
            end
        end
    end
    warn("[CHINO Infinite Hotbar] get_max_items no localizado")
    return false
end
MakeToggle(playerLeft,"Infinite Hotbar",false,function(v)
    SettingsVisual.InfiniteHotbarEnabled=v and true or false
    if v then SettingsVisual.TryInfiniteHotbarHook() end
end)

MakeToggle(playerLeft, "Inf Jump", false, function(v)
    InfiniteJumpEnabled=v and true or false
    if not v then
        local st=SettingsVisual.HoldJumpState
        st.HeldKeyboard=false; st.HeldGamepad=false; st.HeldTouch=nil
        st.LastRequest=0
        SettingsVisual.HoldJumpRelease()
    end
end)
MakeToggle(playerLeft, "Stamina Infinita", false, function(v) toggleStamina(v) end)
MakeToggle(playerLeft, "Ocultar Nombre", false, function(v) HideNameEnabled = v end)

-- Ocultar SIEMPRE el título/nombre del carro propio.
-- Conserva "Conducir"; solo elimina "Coche de <nombre>".
SettingsVisual.HideOwnCarPromptName = true
SettingsVisual.HiddenCarPromptOriginal = setmetatable({}, {__mode = "k"})

SettingsVisual.IsOwnCarPrompt = function(prompt)
	if not prompt or not prompt:IsA("ProximityPrompt") then
		return false
	end

	local objectText = tostring(prompt.ObjectText or "")
	local lowText = string.lower(objectText)
	local playerName = string.lower(tostring(Player.Name or ""))
	local displayName = string.lower(tostring(Player.DisplayName or ""))

	if playerName ~= "" and string.find(lowText, playerName, 1, true) then
		return true
	end

	if displayName ~= "" and string.find(lowText, displayName, 1, true) then
		return true
	end

	local node = prompt
	for _ = 1, 8 do
		node = node and node.Parent
		if not node then break end

		local owner =
			node:GetAttribute("OwnerUserId")
			or node:GetAttribute("OwnerId")
			or node:GetAttribute("ownerUserId")
			or node:GetAttribute("Owner")
			or node:GetAttribute("OwnedBy")

		if tonumber(owner) and tonumber(owner) == Player.UserId then
			return true
		end

		if typeof(owner) == "string" then
			local lowOwner = string.lower(owner)
			if lowOwner == playerName or lowOwner == displayName then
				return true
			end
		end
	end

	return false
end

SettingsVisual.HideOwnCarPrompt = function(prompt)
	if not SettingsVisual.HideOwnCarPromptName then return end
	if not SettingsVisual.IsOwnCarPrompt(prompt) then return end

	if SettingsVisual.HiddenCarPromptOriginal[prompt] == nil then
		SettingsVisual.HiddenCarPromptOriginal[prompt] = prompt.ObjectText
	end

	pcall(function()
		prompt.ObjectText = ""
	end)
end

pcall(function()
	game:GetService("ProximityPromptService").PromptShown:Connect(function(prompt)
		SettingsVisual.HideOwnCarPrompt(prompt)
	end)
end)

workspace.DescendantAdded:Connect(function(obj)
	if obj:IsA("ProximityPrompt") then
		task.defer(function()
			SettingsVisual.HideOwnCarPrompt(obj)
		end)
	end
end)

task.spawn(function()
	for _, obj in ipairs(workspace:GetDescendants()) do
		if obj:IsA("ProximityPrompt") then
			SettingsVisual.HideOwnCarPrompt(obj)
		end
	end

	-- Respaldo por si el juego dibuja ese nombre con su propia GUI.
	while Gui and Gui.Parent do
		pcall(function()
			local playerName = string.lower(tostring(Player.Name or ""))
			local displayName = string.lower(tostring(Player.DisplayName or ""))

			for _, obj in ipairs(PlayerGui:GetDescendants()) do
				if obj:IsA("TextLabel") or obj:IsA("TextButton") then
					local low = string.lower(tostring(obj.Text or ""))

					local ownCarText =
						string.find(low, "coche de ", 1, true)
						and (
							(playerName ~= "" and string.find(low, playerName, 1, true))
							or
							(displayName ~= "" and string.find(low, displayName, 1, true))
						)

					if ownCarText then
						obj.Text = ""
					end
				end
			end
		end)

		task.wait(0.20)
	end
end)

SettingsVisual.AntiLockEnabled = false
SettingsVisual.AntiRagdollEnabled = false

--========================================================--
-- CHINO ANTI SYSTEM
-- Reemplaza Anti-kill + Anti Ragdoll anteriores.
--========================================================--

SettingsVisual.ChinoAntiKillDown = false
SettingsVisual.ChinoAntiKillRunning = false
SettingsVisual.ChinoAntiKillEverDown = false
SettingsVisual.ChinoAntiKillWasAntiLock = false
SettingsVisual.ChinoAntiRagdollRunning = false

-- Mantiene los módulos que siguen usando Anti Ragdoll/Auto Respawn
-- en otras partes del HUB.
local ChinoNet = DumpCarRuntime and DumpCarRuntime.Net or nil
local ChinoCharModule = DumpCarRuntime and DumpCarRuntime.CharModule or nil
local ChinoRagdollModule = nil

pcall(function()
	if not ChinoNet then
		ChinoNet = require(
			ReplicatedStorage
				:WaitForChild("Modules")
				:WaitForChild("Core")
				:WaitForChild("Net")
		)
	end
end)

pcall(function()
	if not ChinoCharModule then
		ChinoCharModule = require(
			ReplicatedStorage
				:WaitForChild("Modules")
				:WaitForChild("Core")
				:WaitForChild("Char")
		)
	end
end)

pcall(function()
	ChinoRagdollModule = require(
		ReplicatedStorage
			:WaitForChild("Modules")
			:WaitForChild("Game")
			:WaitForChild("Ragdoll")
	)
end)

--========================================================--
-- ANTI-KILL NUEVO
-- Reemplaza el Chino viejo que dependía de DeathScreen/respawn.
--
-- Flujo:
--   * <= 30 HP mientras IsInCombat = true -> entra Anti-Kill.
--   * Cuando entra Anti-Kill activa el TP normal del Panel Táctil.
--   * Debajo hace vaivén de +/-2 studs EN CADA Heartbeat.
--   * Mantiene la cámara congelada arriba.
--   * Cuando IsInCombat pasa a false -> ejecuta la recuperación interna
--     anterior, independiente del nuevo toggle de postura Invisible.
--========================================================--

SettingsVisual.ChinoAntiKillDepth = 25
SettingsVisual.ChinoAntiKillSideDistance = 2
SettingsVisual.ChinoAntiKillSideSign = 1
SettingsVisual.ChinoAntiKillUsedTouchTP = false
SettingsVisual.ChinoAntiKillSurfaceHeight = 10

SettingsVisual.ChinoAntiKillOrigin = nil
SettingsVisual.ChinoAntiKillSavedY = nil
SettingsVisual.ChinoAntiKillTargetY = nil
SettingsVisual.ChinoAntiKillFrozenCamera = nil
SettingsVisual.ChinoAntiKillSawCombat = false
SettingsVisual.ChinoAntiKillExitDone = false

SettingsVisual.RestoreChinoAntiLock = function()
	if SettingsVisual.ChinoAntiKillWasAntiLock then
		SettingsVisual.AntiLockEnabled = true
		SettingsVisual.ChinoAntiKillWasAntiLock = false
	end
end

SettingsVisual.ClearChinoAntiKillState = function()
	SettingsVisual.ChinoAntiKillDown = false
	SettingsVisual.ChinoAntiKillEverDown = false
	SettingsVisual.ChinoAntiKillOrigin = nil
	SettingsVisual.ChinoAntiKillSavedY = nil
	SettingsVisual.ChinoAntiKillTargetY = nil
	SettingsVisual.ChinoAntiKillFrozenCamera = nil
	SettingsVisual.ChinoAntiKillSawCombat = false
	SettingsVisual.ChinoAntiKillSideSign = 1
	SettingsVisual.ChinoAntiKillUsedTouchTP = false
end

SettingsVisual.FindChinoAntiKillSurface = function(character)
	local origin = SettingsVisual.ChinoAntiKillOrigin
	if not origin then return nil end

	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Exclude
	params.IgnoreWater = false

	local ignore = {}
	if character then
		table.insert(ignore, character)
	end

	pcall(function()
		if DumpCarRuntime
			and DumpCarRuntime.VehicleModule
			and DumpCarRuntime.VehicleModule.get_car_player_is_in then

			local vehicle =
				DumpCarRuntime.VehicleModule.get_car_player_is_in()

			if vehicle then
				table.insert(ignore, vehicle)
			end
		end
	end)

	params.FilterDescendantsInstances = ignore

	local rayOrigin =
		Vector3.new(
			origin.X,
			origin.Y + 150,
			origin.Z
		)

	local result =
		workspace:Raycast(
			rayOrigin,
			Vector3.new(0, -400, 0),
			params
		)

	if result then
		return result.Position
			+ Vector3.new(
				0,
				tonumber(SettingsVisual.ChinoAntiKillSurfaceHeight) or 10,
				0
			)
	end

	return origin
		+ Vector3.new(
			0,
			tonumber(SettingsVisual.ChinoAntiKillSurfaceHeight) or 10,
			0
		)
end

SettingsVisual.GoChinoAntiKillToSurface = function()
	local character = Player.Character
	local root =
		character
		and character:FindFirstChild("HumanoidRootPart")

	if not root then
		SettingsVisual.ClearChinoAntiKillState()
		SettingsVisual.RestoreChinoAntiLock()
		return
	end

	local surfacePosition =
		SettingsVisual.FindChinoAntiKillSurface(character)

	if surfacePosition then
		pcall(function()
			root.AssemblyLinearVelocity = Vector3.zero
			root.AssemblyAngularVelocity = Vector3.zero
			root.CFrame = CFrame.new(surfacePosition)
		end)
	end

	SettingsVisual.ChinoAntiKillExitDone = true
	SettingsVisual.ClearChinoAntiKillState()
	SettingsVisual.RestoreChinoAntiLock()
end

SettingsVisual.StartChinoAntiKill = function()
	if SettingsVisual.ChinoAntiKillRunning then
		return
	end

	SettingsVisual.ChinoAntiKillRunning = true
	SettingsVisual.ChinoAntiKillExitDone = false

	task.spawn(function()
		while AntiKillEnabled
			and Gui
			and Gui.Parent do

			RunService.Heartbeat:Wait()

			local character = Player.Character
			local humanoid =
				character
				and character:FindFirstChildOfClass("Humanoid")

			local root =
				character
				and character:FindFirstChild("HumanoidRootPart")

			if humanoid and root then
				local inCombat =
					Player:GetAttribute("IsInCombat") == true

				local isDead =
					humanoid.Health <= 0
					or humanoid:GetAttribute("IsDead") == true

				if isDead then
					SettingsVisual.ClearChinoAntiKillState()
					SettingsVisual.RestoreChinoAntiLock()
				else
					-- Permite un ciclo nuevo después de recuperarse.
					if humanoid.Health >= 40
						and not SettingsVisual.ChinoAntiKillDown then

						SettingsVisual.ChinoAntiKillExitDone = false
					end

					-- Activación del Anti-Kill nuevo.
					if humanoid.Health <= 30
						and inCombat
						and not SettingsVisual.ChinoAntiKillDown
						and not SettingsVisual.ChinoAntiKillExitDone then

						SettingsVisual.ChinoAntiKillDown = true
						SettingsVisual.ChinoAntiKillEverDown = true
						SettingsVisual.ChinoAntiKillSawCombat = true

						SettingsVisual.ChinoAntiKillSavedY =
							root.Position.Y

						SettingsVisual.ChinoAntiKillTargetY =
							root.Position.Y
							- (tonumber(SettingsVisual.ChinoAntiKillDepth) or 25)

						SettingsVisual.ChinoAntiKillOrigin =
							root.Position

						SettingsVisual.ChinoAntiKillFrozenCamera =
							Camera.CFrame

						SettingsVisual.ChinoAntiKillSideSign = 1
						SettingsVisual.ChinoAntiKillUsedTouchTP = false

						-- Usa EXACTAMENTE el TP normal del Panel Táctil.
						-- El helper se define en la sección del Panel Táctil
						-- y fuerza el estado DOWN sin tocar Snap Car.
						pcall(function()
							if SettingsVisual.SetTouchNormalSnapState then
								SettingsVisual.SetTouchNormalSnapState(true)
								SettingsVisual.ChinoAntiKillUsedTouchTP = true

								-- Adoptamos la Y real a la que llevó el Panel Táctil.
								SettingsVisual.ChinoAntiKillTargetY = root.Position.Y
							end
						end)

						-- Respaldo: si por orden de ejecución el helper no existiera,
						-- conserva el descenso original de 25 studs.
						if not SettingsVisual.ChinoAntiKillUsedTouchTP then
							pcall(function()
								root.Anchored = false
								root.AssemblyLinearVelocity = Vector3.zero
								root.AssemblyAngularVelocity = Vector3.zero
								root.CFrame = CFrame.new(
									SettingsVisual.ChinoAntiKillOrigin.X,
									SettingsVisual.ChinoAntiKillTargetY,
									SettingsVisual.ChinoAntiKillOrigin.Z
								)
							end)
						end

						-- Anti Lock conserva su estado ON/OFF del panel.
						-- Su loop se pausa automaticamente mientras Anti-Kill esta abajo
						-- para que ambos movimientos no se peleen, y vuelve a actuar
						-- inmediatamente al regresar a superficie.
					end

					if SettingsVisual.ChinoAntiKillDown
						and SettingsVisual.ChinoAntiKillOrigin
						and SettingsVisual.ChinoAntiKillTargetY then

						if inCombat then
							SettingsVisual.ChinoAntiKillSawCombat = true
						end

						-- Sale de combate DESPUÉS de que Anti-Kill sí entró:
						-- termina Anti-Kill y ejecuta la recuperación independiente
						-- (no manipula el nuevo interruptor Invisible de postura).
						if SettingsVisual.ChinoAntiKillSawCombat
							and not inCombat
							and not SettingsVisual.ChinoAntiKillExitDone then

							-- Bloquea esta salida para que no se dispare varias veces.
							SettingsVisual.ChinoAntiKillExitDone = true

							-- Suelta primero el mismo TP normal del Panel Táctil
							-- que usó AntiKill para bajar.
							if SettingsVisual.ChinoAntiKillUsedTouchTP
								and SettingsVisual.SetTouchNormalSnapState then

								pcall(function()
									SettingsVisual.SetTouchNormalSnapState(false)
								end)
							end

							-- Corta el estado subterráneo/cámara del Anti-Kill.
							SettingsVisual.ClearChinoAntiKillState()
							SettingsVisual.RestoreChinoAntiLock()

							-- La salida del Anti-Kill conserva su acción interna de
							-- recuperación. El botón Invisible ahora controla SOLO
							-- la postura del avatar dentro del vehículo.
							task.defer(function()
								if SettingsVisual.PerformAntiKillExitRespawn then
									SettingsVisual.PerformAntiKillExitRespawn()
								end
							end)
						else
							-- MÁXIMO práctico del loop:
							-- cambia de lado en CADA Heartbeat.
							SettingsVisual.ChinoAntiKillSideSign =
								-(SettingsVisual.ChinoAntiKillSideSign or 1)

							local origin =
								SettingsVisual.ChinoAntiKillOrigin

							local targetY =
								SettingsVisual.ChinoAntiKillTargetY

							local sideDistance =
								tonumber(SettingsVisual.ChinoAntiKillSideDistance) or 2

							local sideOffset =
								sideDistance
								* (SettingsVisual.ChinoAntiKillSideSign or 1)

							pcall(function()
								root.Anchored = false

								-- +/-2 studs, cada frame de física.
								root.CFrame = CFrame.new(
									origin.X + sideOffset,
									targetY,
									origin.Z
								)

								root.AssemblyLinearVelocity = Vector3.zero
								root.AssemblyAngularVelocity = Vector3.zero
							end)

							if SettingsVisual.ChinoAntiKillFrozenCamera then
								Camera.CFrame =
									SettingsVisual.ChinoAntiKillFrozenCamera
							end
						end
					end
				end
			end
		end

		if SettingsVisual.ChinoAntiKillDown then
			SettingsVisual.GoChinoAntiKillToSurface()
		else
			SettingsVisual.ClearChinoAntiKillState()
			SettingsVisual.RestoreChinoAntiLock()
		end

		SettingsVisual.ChinoAntiKillRunning = false
	end)
end

-- Mantiene la cámara realmente congelada después del update normal
-- de la cámara de Roblox.
pcall(function()
	RunService:UnbindFromRenderStep(
		"CHINO_ChinoAntiKillCameraLock"
	)

	RunService:BindToRenderStep(
		"CHINO_ChinoAntiKillCameraLock",
		Enum.RenderPriority.Camera.Value + 50,
		function()
			if AntiKillEnabled
				and SettingsVisual.ChinoAntiKillDown
				and SettingsVisual.ChinoAntiKillFrozenCamera then

				Camera.CFrame =
					SettingsVisual.ChinoAntiKillFrozenCamera
			end
		end
	)
end)

Player.CharacterAdded:Connect(function()
	SettingsVisual.ChinoAntiKillExitDone = false
	SettingsVisual.ClearChinoAntiKillState()
	SettingsVisual.RestoreChinoAntiLock()
end)

SettingsVisual.StartChinoAntiRagdoll = function()
	if SettingsVisual.ChinoAntiRagdollRunning then
		return
	end

	SettingsVisual.ChinoAntiRagdollRunning = true

	task.spawn(function()
		while SettingsVisual.AntiRagdollEnabled
			and Gui
			and Gui.Parent do

			task.wait(0.1)

			pcall(function()
				local isRagdolled = false

				if ChinoRagdollModule
					and ChinoRagdollModule.is_ragdolling
					and ChinoRagdollModule.is_ragdolling.get then

					isRagdolled =
						ChinoRagdollModule.is_ragdolling.get()
				end

				if isRagdolled then
					if ChinoRagdollModule
						and ChinoRagdollModule.is_ragdolling
						and ChinoRagdollModule.is_ragdolling.set then

						ChinoRagdollModule.is_ragdolling.set(false)
					end

					if ChinoNet then
						pcall(function()
							ChinoNet.send("end_ragdoll_early")
						end)
						pcall(function()
							ChinoNet.send("clear_ragdoll")
						end)
						pcall(function()
							ChinoNet.get("end_ragdoll_early")
						end)
						pcall(function()
							ChinoNet.get("clear_ragdoll")
						end)
					end
				end
			end)
		end

		SettingsVisual.ChinoAntiRagdollRunning = false
	end)
end
MakeToggle(playerLeft, "Anti Lock", false, function(v)
	-- Mismo estado del HUB, pero la función real ahora es la del otro script.
	SettingsVisual.AntiLockEnabled = v and true or false
	if v and SettingsVisual.TouchCarApplySeatPose then
		task.defer(SettingsVisual.TouchCarApplySeatPose)
	end
end)
MakeToggle(playerLeft, "Anti Ragdoll", false, function(v)
	SettingsVisual.AntiRagdollEnabled = v and true or false
	if SettingsVisual.AntiRagdollEnabled then
		SettingsVisual.StartChinoAntiRagdoll()
	end
end)
MakeToggle(playerLeft, "Anti Auto Sit", false, function(v)
	SettingsVisual.AntiAutoSitEnabled = v and true or false
	SettingsVisual.SetNormalSeatsDisabled(SettingsVisual.AntiAutoSitEnabled)
end)

MakeToggle(playerRight, "Speed Hack", false, function(v)
	SpeedHackEnabled = v and true or false
    -- Restauración de la velocidad original en el siguiente Heartbeat.
    if not SpeedHackEnabled then
        SettingsVisual.ChinoSpeedAttributeAt=0
    end
end)
MakeSlider(playerRight, "Velocidad", 4, 1, 20, function(v) SpeedValue = v end)
MakeToggle(playerRight, "Anti-kill", false, function(v)
	AntiKillEnabled = v and true or false

	if AntiKillEnabled then
		SettingsVisual.ChinoAntiKillExitDone = false
		SettingsVisual.StartChinoAntiKill()
	else
		-- Si se apaga mientras está abajo, suelta primero el TP normal
		-- del Panel Táctil para que su Heartbeat no lo siga fijando abajo.
		if SettingsVisual.ChinoAntiKillUsedTouchTP
			and SettingsVisual.SetTouchNormalSnapState then

			pcall(function()
				SettingsVisual.SetTouchNormalSnapState(false)
			end)
		end

		-- Después aplica la salida normal del AntiKill.
		if SettingsVisual.ChinoAntiKillDown then
			SettingsVisual.GoChinoAntiKillToSurface()
		else
			SettingsVisual.ClearChinoAntiKillState()
			SettingsVisual.RestoreChinoAntiLock()
		end
	end
end)
MakeToggle(playerRight, "Panel Táctil", false, function(v)
	TouchPanelEnabled = v
	local tpGui = (SettingsVisual.ExecutorGuiParent and SettingsVisual.ExecutorGuiParent:FindFirstChild("TouchPanelGui")) or CoreGui:FindFirstChild("TouchPanelGui") or PlayerGui:FindFirstChild("TouchPanelGui")
    if tpGui then tpGui.Enabled = v and not SettingsVisual.PanelIsOpen end
    if SettingsVisual.RefreshFloatingMenus then SettingsVisual.RefreshFloatingMenus(false) end
end)
MakeToggle(playerRight, "Ghost Mode", false, function(v)
    SettingsVisual.GhostPanelWanted = v and true or false
    local ghostGui = (SettingsVisual.ExecutorGuiParent and SettingsVisual.ExecutorGuiParent:FindFirstChild("GhostFloatingSwitchGui")) or CoreGui:FindFirstChild("GhostFloatingSwitchGui") or PlayerGui:FindFirstChild("GhostFloatingSwitchGui")
    if ghostGui then ghostGui.Enabled = v and not SettingsVisual.PanelIsOpen end
    if SettingsVisual.RefreshFloatingMenus then SettingsVisual.RefreshFloatingMenus(false) end
	-- Si se cierra el panel Ghost desde el HUB, apagamos tambien
	-- el movimiento Ghost para no dejar el personaje anclado.
	if not v and SettingsVisual.SetGhostState then
		SettingsVisual.SetGhostState(false)
	end
end)

-- VEHICLE
-- Ajustes compartidos por:
--   1) Snap Car del Panel Táctil cuando está abajo.
--   2) Vehicle Sliders cuando está arriba.
-- Los sliders aplican al instante al carro/motor activo.
SettingsVisual.VehicleForwardMaxSpeed = 90
SettingsVisual.VehicleReverseMaxSpeed = 90
SettingsVisual.VehicleAcceleration = 200
SettingsVisual.VehicleBraking = 200
SettingsVisual.VehicleDirectionRate = 200
SettingsVisual.VehicleSteerPower = 200

--========================================================--
-- CAR GHOST / NO-IMPACT - SOLO CON WALLHACK
--
-- Este módulo YA NO toca CanCollide de carros ajenos: eso lo hace
-- WorldPhase en un solo sitio para evitar restauraciones cruzadas.
-- Aquí únicamente apagamos CanTouch del vehículo propio mientras
-- Wallhack está activo. CanCollide del carro propio se conserva para
-- que las llantas sigan apoyándose en el pavimento.
--========================================================--

SettingsVisual.VehicleGhostProtectionEnabled = false
SettingsVisual.VehicleGhostProtectionRunning = false
SettingsVisual.VehicleOwnTouchOriginal = setmetatable({}, {__mode = "k"})

SettingsVisual.StartVehicleGhostProtection = function()
    if SettingsVisual.VehicleGhostProtectionRunning then
        return
    end

    SettingsVisual.VehicleGhostProtectionRunning = true

    task.spawn(function()
        local function getCurrentVehicle()
            local vehicle = nil

            pcall(function()
                if DumpCarRuntime
                    and DumpCarRuntime.VehicleModule
                    and DumpCarRuntime.VehicleModule.get_car_player_is_in then
                    vehicle = DumpCarRuntime.VehicleModule.get_car_player_is_in()
                end
            end)

            if vehicle then
                return vehicle
            end

            local char = Player.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            local seat = hum and hum.SeatPart

            if seat then
                return seat:FindFirstAncestorOfClass("Model")
            end

            return nil
        end

        local function restoreOwnTouches()
            for part, oldTouch in pairs(SettingsVisual.VehicleOwnTouchOriginal) do
                if part and part.Parent then
                    pcall(function()
                        part.CanTouch = oldTouch
                    end)
                end
                SettingsVisual.VehicleOwnTouchOriginal[part] = nil
            end
        end

        while Gui
            and Gui.Parent
            and SettingsVisual.VehicleGhostProtectionEnabled do

            task.wait(0.055)

            local vehicle = getCurrentVehicle()
            if not vehicle then
                restoreOwnTouches()
                continue
            end

            local ownSet = {}

            for _, obj in ipairs(vehicle:GetDescendants()) do
                if obj:IsA("BasePart") then
                    ownSet[obj] = true

                    if SettingsVisual.VehicleOwnTouchOriginal[obj] == nil then
                        SettingsVisual.VehicleOwnTouchOriginal[obj] = obj.CanTouch
                    end

                    pcall(function()
                        obj.CanTouch = false
                    end)
                end
            end

            -- Si cambiaste de carro, restaura piezas del anterior.
            for part, oldTouch in pairs(SettingsVisual.VehicleOwnTouchOriginal) do
                if not ownSet[part] then
                    if part and part.Parent then
                        pcall(function()
                            part.CanTouch = oldTouch
                        end)
                    end
                    SettingsVisual.VehicleOwnTouchOriginal[part] = nil
                end
            end
        end

        restoreOwnTouches()
        SettingsVisual.VehicleGhostProtectionRunning = false
    end)
end

SettingsVisual.SetVehicleGhostProtection = function(enabled)
    SettingsVisual.VehicleGhostProtectionEnabled = enabled == true

    if SettingsVisual.VehicleGhostProtectionEnabled then
        SettingsVisual.StartVehicleGhostProtection()
    end
end

-- Sincroniza los sliders con el motor Underground si ya fue creado.
SettingsVisual.SyncVehicleDriveToSnap = function()
	local S = SettingsVisual.TouchSnapCarState
	if not S then return end

	S.Speed = math.clamp(tonumber(SettingsVisual.VehicleForwardMaxSpeed) or 90, 1, 200)
	S.ReverseSpeed = math.clamp(tonumber(SettingsVisual.VehicleReverseMaxSpeed) or 90, 1, 200)
	S.AccelRate = math.clamp(tonumber(SettingsVisual.VehicleAcceleration) or 200, 0, 200)
	S.StopRate = math.clamp(tonumber(SettingsVisual.VehicleBraking) or 200, 0, 200)
	S.DirectionRate = math.clamp(tonumber(SettingsVisual.VehicleDirectionRate) or 200, 0, 200)
	S.SteerPower = math.clamp(tonumber(SettingsVisual.VehicleSteerPower) or 200, 0, 200)
end

--========================================================--
-- VEHICLE RARITY MODE
-- Selecciona un jugador por rareza usando el MISMO getWeaponData()
-- del ESP Armas. Mode controla TP Car + seguimiento automático.
--========================================================--

SettingsVisual.VehicleRarityChoices = {
	"Common",
	"Uncommon",
	"Rare",
	"Epic",
	"Legendary",
	"Omega"
}

SettingsVisual.SelectedVehicleRarity =
	SettingsVisual.SelectedVehicleRarity or "Legendary"

SettingsVisual.VehicleRarityModeEnabled = false
SettingsVisual.VehicleRarityTarget = nil
SettingsVisual.VehicleRarityTargetInfo = nil
SettingsVisual.VehicleRarityModeOwnsSnap = false
SettingsVisual.VehicleRarityStopDistance = 18
SettingsVisual.VehicleRarityResumeDistance = 28

-- Al llegar NO frena en seco: entra en seguimiento lento.
SettingsVisual.VehicleRarityCreepThrottle = 0.10
SettingsVisual.VehicleRarityCreepSpeed = 7

SettingsVisual.VehicleRarityArrived = false

SettingsVisual.VehicleRarityAvoidSide = 0
SettingsVisual.VehicleRarityAvoidUntil = 0
SettingsVisual.VehicleRarityObstacleDistance = 22
SettingsVisual.VehicleRarityAvoidAngle = 58

SettingsVisual.PlayerHasSelectedRarity = function(pl, rarity)
	if not pl or pl == Player or not rarity then
		return false, nil
	end

	local char = pl.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")

	if not char or not hum or hum.Health <= 0 then
		return false, nil
	end

	local function scanContainer(container)
		if not container then return nil end

		for _, tool in ipairs(container:GetChildren()) do
			if tool:IsA("Tool") and tool.Name ~= "Fists" then
				local info = getWeaponData(tool)

				if info
					and tostring(info.Rarity) == tostring(rarity) then

					return info
				end
			end
		end

		return nil
	end

	local equippedInfo = scanContainer(char)
	if equippedInfo then
		return true, equippedInfo
	end

	local backpackInfo =
		scanContainer(pl:FindFirstChild("Backpack"))

	if backpackInfo then
		return true, backpackInfo
	end

	return false, nil
end

SettingsVisual.FindVehicleRarityTarget = function()
    local pl = SettingsVisual.SelectedVehiclePlayer
    if not pl or pl == Player or pl.Parent ~= Players then return nil, nil end
    local char = pl.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not hum or hum.Health <= 0 or not root then return nil, nil end
    return pl, nil
end

SettingsVisual.VehicleModeRotateLook = function(look, degrees)
	local flat =
		Vector3.new(
			look.X,
			0,
			look.Z
		)

	if flat.Magnitude <= 0.001 then
		flat = Vector3.new(0, 0, -1)
	else
		flat = flat.Unit
	end

	local rotated =
		(
			CFrame.lookAt(
				Vector3.zero,
				flat,
				Vector3.yAxis
			)
			* CFrame.Angles(
				0,
				math.rad(degrees),
				0
			)
		).LookVector

	return Vector3.new(
		rotated.X,
		0,
		rotated.Z
	).Unit
end

SettingsVisual.VehicleModeWallDistance = function(vehicle, root, direction, targetChar)
	if not root or not direction or direction.Magnitude <= 0.001 then
		return math.huge
	end

	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Exclude
	params.IgnoreWater = true

	local ignore = {}

	if vehicle then
		table.insert(ignore, vehicle)
	end

	if Player.Character then
		table.insert(ignore, Player.Character)
	end

	if targetChar then
		table.insert(ignore, targetChar)
	end

	params.FilterDescendantsInstances = ignore

	local maxDistance =
		tonumber(SettingsVisual.VehicleRarityObstacleDistance) or 22

	local right =
		Vector3.new(
			root.CFrame.RightVector.X,
			0,
			root.CFrame.RightVector.Z
		)

	if right.Magnitude <= 0.001 then
		right = Vector3.new(1, 0, 0)
	else
		right = right.Unit
	end

	-- Tres rayos horizontales para cubrir el ancho del carro.
	local origins = {
		root.Position + Vector3.new(0, 0.8, 0),
		root.Position + right * 2.2 + Vector3.new(0, 0.8, 0),
		root.Position - right * 2.2 + Vector3.new(0, 0.8, 0),
	}

	local nearest = math.huge

	for _, origin in ipairs(origins) do
		local result =
			workspace:Raycast(
				origin,
				direction.Unit * maxDistance,
				params
			)

		if result then
			local hit = result.Instance

			-- Solo considera obstáculo real del mapa:
			-- Anchored/Terrain. Ignora carros, jugadores y objetos móviles.
			local realWall =
				hit == workspace.Terrain
				or (
					hit
					and hit:IsA("BasePart")
					and hit.Anchored
				)

			if realWall then
				local distance =
					(result.Position - origin).Magnitude

				nearest = math.min(nearest, distance)
			end
		end
	end

	return nearest
end

SettingsVisual.VehicleModeGetAvoidanceDirection =
	function(vehicle, root, targetChar)

		if not vehicle or not root then
			return nil, 1
		end

		local currentForward =
			SettingsVisual.TouchSnapCarFlatLook(root.CFrame)

		local forwardDistance =
			SettingsVisual.VehicleModeWallDistance(
				vehicle,
				root,
				currentForward,
				targetChar
			)

		local now = os.clock()

		if forwardDistance
			<= (tonumber(SettingsVisual.VehicleRarityObstacleDistance) or 22) then

			local avoidAngle =
				tonumber(SettingsVisual.VehicleRarityAvoidAngle) or 58

			local leftDir =
				SettingsVisual.VehicleModeRotateLook(
					currentForward,
					avoidAngle
				)

			local rightDir =
				SettingsVisual.VehicleModeRotateLook(
					currentForward,
					-avoidAngle
				)

			local leftDistance =
				SettingsVisual.VehicleModeWallDistance(
					vehicle,
					root,
					leftDir,
					targetChar
				)

			local rightDistance =
				SettingsVisual.VehicleModeWallDistance(
					vehicle,
					root,
					rightDir,
					targetChar
				)

			if leftDistance >= rightDistance then
				SettingsVisual.VehicleRarityAvoidSide = 1
			else
				SettingsVisual.VehicleRarityAvoidSide = -1
			end

			-- Mantiene el mismo lado un momento para no oscilar
			-- izquierda/derecha frente a la pared.
			SettingsVisual.VehicleRarityAvoidUntil =
				now + 0.75
		end

		local side =
			tonumber(SettingsVisual.VehicleRarityAvoidSide) or 0

		if side ~= 0
			and now
			< (tonumber(SettingsVisual.VehicleRarityAvoidUntil) or 0) then

			local avoidAngle =
				(tonumber(SettingsVisual.VehicleRarityAvoidAngle) or 58)
				* side

			return
				SettingsVisual.VehicleModeRotateLook(
					currentForward,
					avoidAngle
				),
				0.55
		end

		if now
			>= (tonumber(SettingsVisual.VehicleRarityAvoidUntil) or 0) then

			SettingsVisual.VehicleRarityAvoidSide = 0
		end

		return nil, 1
	end

SettingsVisual.SetVehicleRarityMode =
	MakeToggle(vehicleLeft, "Mode", false, function(v)

		SettingsVisual.VehicleRarityModeEnabled =
			v and true or false

		if not SettingsVisual.VehicleRarityModeEnabled then
			SettingsVisual.VehicleRarityTarget = nil
			SettingsVisual.VehicleRarityTargetInfo = nil
			SettingsVisual.VehicleRarityArrived = false
			SettingsVisual.VehicleRarityAvoidSide = 0
			SettingsVisual.VehicleRarityAvoidUntil = 0

			-- Al apagar Mode NO toca TP Car.
			-- Si el carro está abajo, se queda abajo.
			-- Mode únicamente deja de buscar/seguir objetivos.
		end
	end)

-- Selector original de Vehicle (no se cambia su comportamiento).
SettingsVisual.CreateWeaponPlayerSelector(vehicleLeft, "Vehicle")

-- Activador REAL de los sliders para manejo ARRIBA DEL PISO.
-- Abajo del piso Snap Car usa estos mismos valores automáticamente.
SettingsVisual.SetVehicleSlidersEnabled = MakeToggle(vehicleLeft, "Vehicle Sliders", false, function(v)
	SettingsVisual.VehicleSlidersEnabled = v and true or false
	if SettingsVisual.SetVehicleSliderDriveState then
		SettingsVisual.SetVehicleSliderDriveState(SettingsVisual.VehicleSlidersEnabled)
	end
end)

-- Dump Car: lógica basada en ZEION; 0.10 s / 90 de impulso / 100 studs.
SettingsVisual.SetDumpCarEnabled = MakeToggle(vehicleRight, "Dump Car", true, function(v)
	DumpCarRuntime.SetEnabled(v)
end)

-- Casilla derecha: cuando está activo, visita el drop asociado al último objetivo de Target Line.
SettingsVisual.TouchRightDroppedItemsEnabled = false
SettingsVisual.SetTouchRightDroppedItemsEnabled = MakeToggle(vehicleRight, "TP Items Target", false, function(v)
	SettingsVisual.TouchRightDroppedItemsEnabled = v and true or false
	-- El switch flotante solo existe mientras TP Items Target está activo.
	-- Al apagar la opción se detiene cualquier nuevo TP de items.
	if not SettingsVisual.TouchRightDroppedItemsEnabled
		and SettingsVisual.SetVehicleItemTPSwitch then
		SettingsVisual.SetVehicleItemTPSwitch(false)
	end
end)

-- Sliders REALES del motor. Rango máximo 200.
SettingsVisual.SetVehicleForwardMaxSpeed = MakeSlider(vehicleLeft, "Forward Max", 90, 1, 200, function(v)
	SettingsVisual.VehicleForwardMaxSpeed = math.clamp(tonumber(v) or 90, 1, 200)
	SettingsVisual.SyncVehicleDriveToSnap()
end)

SettingsVisual.SetVehicleReverseMaxSpeed = MakeSlider(vehicleRight, "Reverse Max", 90, 1, 200, function(v)
	SettingsVisual.VehicleReverseMaxSpeed = math.clamp(tonumber(v) or 90, 1, 200)
	SettingsVisual.SyncVehicleDriveToSnap()
end)

SettingsVisual.SetVehicleAcceleration = MakeSlider(vehicleLeft, "Acceleration", 200, 0, 200, function(v)
	SettingsVisual.VehicleAcceleration = math.clamp(tonumber(v) or 200, 0, 200)
	SettingsVisual.SyncVehicleDriveToSnap()
end)

SettingsVisual.SetVehicleBraking = MakeSlider(vehicleRight, "Brake", 200, 0, 200, function(v)
	SettingsVisual.VehicleBraking = math.clamp(tonumber(v) or 200, 0, 200)
	SettingsVisual.SyncVehicleDriveToSnap()
end)

SettingsVisual.SetVehicleDirectionRate = MakeSlider(vehicleLeft, "Direction Change", 200, 0, 200, function(v)
	SettingsVisual.VehicleDirectionRate = math.clamp(tonumber(v) or 200, 0, 200)
	SettingsVisual.SyncVehicleDriveToSnap()
end)

SettingsVisual.SetVehicleSteerPower = MakeSlider(vehicleRight, "Steer Power", 200, 0, 200, function(v)
	SettingsVisual.VehicleSteerPower = math.clamp(tonumber(v) or 200, 0, 200)
	SettingsVisual.SyncVehicleDriveToSnap()
end)

--========================================================--
-- ACCIONES VEHÍCULO IMPORTADAS DEL OTRO SCRIPT
--========================================================--
SettingsVisual.VehicleActionIsMine = function(vehicle)
	if not vehicle or not vehicle:IsA("Model") then return false end
	local ownerId =
		vehicle:GetAttribute("OwnerUserId")
		or vehicle:GetAttribute("Owner")

	return ownerId ~= nil
		and (
			ownerId == Player.UserId
			or ownerId == Player.Name
			or tostring(ownerId) == tostring(Player.UserId)
		)
end

SettingsVisual.VehicleActionFromSeat = function(seat)
	local vehicles = workspace:FindFirstChild("Vehicles")
	if not vehicles or not seat then return nil end

	local current = seat
	while current and current ~= workspace do
		if current:IsA("Model") and current.Parent == vehicles then
			return current
		end
		current = current.Parent
	end

	return seat:FindFirstAncestorOfClass("Model")
end

SettingsVisual.GetVehicleForAction = function(ownedOnly)
	local vehicle = nil

	pcall(function()
		if DumpCarRuntime
			and DumpCarRuntime.VehicleModule
			and DumpCarRuntime.VehicleModule.get_car_player_is_in then
			vehicle = DumpCarRuntime.VehicleModule.get_car_player_is_in()
		end
	end)

	if vehicle then
		local vehicles = workspace:FindFirstChild("Vehicles")
		if vehicles and vehicle.Parent ~= vehicles then
			local current = vehicle
			while current and current ~= workspace do
				if current:IsA("Model") and current.Parent == vehicles then
					vehicle = current
					break
				end
				current = current.Parent
			end
		end

		if not ownedOnly or SettingsVisual.VehicleActionIsMine(vehicle) then
			return vehicle
		end
	end

	local char = Player.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	local seat = hum and hum.SeatPart
	if seat then
		vehicle = SettingsVisual.VehicleActionFromSeat(seat)
		if vehicle and (not ownedOnly or SettingsVisual.VehicleActionIsMine(vehicle)) then
			return vehicle
		end
	end

	local vehicles = workspace:FindFirstChild("Vehicles")
	if vehicles then
		for _, candidate in ipairs(vehicles:GetChildren()) do
			if candidate:IsA("Model")
				and SettingsVisual.VehicleActionIsMine(candidate) then
				return candidate
			end
		end
	end

	return nil
end

-- CHINO: AutoLock / Block Car eliminados a petición. 
-- Se conserva VehicleActionIsMine, que usan otras acciones de vehículo.
-- Validación de propiedad: comprobar cada atributo sin ipairs (los nil intermedios
-- del script anterior cortaban la iteración).
SettingsVisual.VehicleActionIsMine = function(vehicle)
    if not vehicle or not vehicle:IsA("Model") then return false end
    for _,key in ipairs({"OwnerUserId","Owner","OwnerId","OwnerID","owner_id",
                         "UserId","PlayerUserId","OwnerName","PlayerName"}) do
        local ownerId=vehicle:GetAttribute(key)
        if ownerId~=nil and (ownerId==Player.UserId or ownerId==Player.Name
          or tostring(ownerId)==tostring(Player.UserId)
          or tostring(ownerId)==tostring(Player.Name)) then
            return true
        end
    end
    return false
end

SettingsVisual.BlockVehicleEnabled = false
SettingsVisual.ApplyBlockVehicle = function() return false end

-- Nombre conservado EXACTAMENTE como estaba; función reemplazada por Traer mi vehículo.
-- Misma lógica Pull Car Owner desde el botón Vehicle y casilla derecha a pie.
-- Busca por propietario; nunca usa un JobId o GUID fijo.
SettingsVisual.PullOwnedCar = function()
    local vehiclesFolder = workspace:FindFirstChild("Vehicles")
    local myChar = Player.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not vehiclesFolder or not myRoot then return false end

    for _, vehicle in ipairs(vehiclesFolder:GetChildren()) do
        if vehicle:IsA("Model") then
            local ownerId = vehicle:GetAttribute("OwnerUserId")
                or vehicle:GetAttribute("Owner")
            if ownerId and (
                ownerId == Player.UserId
                or ownerId == Player.Name
                or tostring(ownerId) == tostring(Player.UserId)
            ) then
                vehicle:PivotTo(
                    myRoot.CFrame
                    * CFrame.new(0, 5, -13)
                    * CFrame.Angles(0, math.rad(90), 0)
                )
                return true
            end
        end
    end
    return false
end
SettingsVisual.MakeActionButton(vehicleRight, "Pull Car Owner", function()
    SettingsVisual.PullOwnedCar()
end, "RUN", 0.72)

-- BRING y TEST retirados: solo "Pull Car Owner" para traer tu vehiculo.

SettingsVisual.MakeActionButton(vehicleRight, "Dañar Vehículo", function()
	local car = SettingsVisual.GetVehicleForAction(false)
	local net = DumpCarRuntime and DumpCarRuntime.Net

	if not car or not net then return end

	for _ = 1, 15 do
		pcall(function()
			net.send("crashed_car", car, 150)
		end)
		task.wait(0.02)
	end
end, "RUN", 0.72)

--========================================================--
-- VEHICLE SLIDERS DRIVE - MISMO FEEL DEL SNAP CAR, PERO ARRIBA
-- Usa controles nativos + las MISMAS zonas táctiles del Snap Car.
-- Forward/Reverse/Accel/Brake/Direction/Steer vienen de los sliders.
--========================================================--
SettingsVisual.SetupVehicleSliderDriveSystem = function()
	if SettingsVisual.VehicleSliderDriveState then return end

	local S = {
		Enabled = false,
		CurrentDriveSpeed = 0,
		Vehicle = nil,
		Root = nil,
		Seat = nil,
		WheelVehicle = nil,
		WheelAngle = 0,
		WheelMotors = setmetatable({}, {__mode = "k"}),
        NativeSafeMax = nil,
        AdaptiveMax = nil,
        LastObservedPosition = nil,
        LastAppliedDirection = nil,
        LastExpectedSpeed = 0,
        StabilityStrikes = 0,
	}
	SettingsVisual.VehicleSliderDriveState = S

	local function getVehicle()
		local char = Player.Character
		local hum = char and char:FindFirstChildOfClass("Humanoid")
		local seat = hum and hum.SeatPart

		if not seat or not seat:IsA("VehicleSeat") then
			return nil, nil, nil
		end

		local vehicle = seat:FindFirstAncestorOfClass("Model")
		if not vehicle then return nil, nil, nil end

		local root =
			vehicle.PrimaryPart
			or seat.AssemblyRootPart
			or seat
			or vehicle:FindFirstChildWhichIsA("BasePart", true)

		if root then root = root.AssemblyRootPart or root end
		return vehicle, root, seat
	end

	local function flatLook(cf)
		local look = Vector3.new(cf.LookVector.X, 0, cf.LookVector.Z)
		if look.Magnitude < 0.001 then
			return Vector3.new(0, 0, -1)
		end
		return look.Unit
	end

	local function uprightAt(position, look)
		return CFrame.lookAt(position, position + look, Vector3.yAxis)
	end

	local function moveTowards(current, target, maxDelta)
		if current < target then
			return math.min(current + maxDelta, target)
		elseif current > target then
			return math.max(current - maxDelta, target)
		end
		return target
	end

	-- Visual de llantas para Vehicle Sliders. No mueve el carro por sí solo.
	local function restoreWheelVisuals()
		for motor, original in pairs(S.WheelMotors) do
			if motor and motor.Parent and original then
				pcall(function()
					motor.Transform = original
				end)
			end
			S.WheelMotors[motor] = nil
		end
		S.WheelVehicle = nil
		S.WheelAngle = 0
	end

	local function scanWheelMotors(vehicle)
		if S.WheelVehicle == vehicle then return end
		restoreWheelVisuals()
		S.WheelVehicle = vehicle

		for _, obj in ipairs(vehicle:GetDescendants()) do
			if obj:IsA("Motor6D") then
				local n0 = obj.Name:lower()
				local n1 = obj.Part0 and obj.Part0.Name:lower() or ""
				local n2 = obj.Part1 and obj.Part1.Name:lower() or ""

				local function wheelName(n)
					return n:find("wheel", 1, true)
						or n:find("tire", 1, true)
						or n:find("tyre", 1, true)
						or n:find("rim", 1, true)
				end

				if wheelName(n0) or wheelName(n1) or wheelName(n2) then
					S.WheelMotors[obj] = obj.Transform
				end
			end
		end
	end

	local function updateWheelVisuals(vehicle, dt, driveSpeed, throttle)
		scanWheelMotors(vehicle)
		if next(S.WheelMotors) == nil then return end

		local visualSpeed = math.abs(tonumber(driveSpeed) or 0)
		if math.abs(tonumber(throttle) or 0) <= 0.05 and visualSpeed < 1 then
			visualSpeed = 8
		else
			visualSpeed = math.max(visualSpeed, 12)
		end

		S.WheelAngle =
			(S.WheelAngle + visualSpeed * math.max(dt, 1 / 240) * 0.16)
			% (math.pi * 2)

		for motor, original in pairs(S.WheelMotors) do
			if motor and motor.Parent and original then
				pcall(function()
					motor.Transform =
						original * CFrame.Angles(S.WheelAngle, 0, 0)
				end)
			else
				S.WheelMotors[motor] = nil
			end
		end
	end

	S.UpdateWheelVisuals = updateWheelVisuals
	S.RestoreWheelVisuals = restoreWheelVisuals

    -- Detecta la potencia de cada carro (no todos toleran slider en 200).
    -- Primero atributos propios del vehículo; después MaxSpeed del asiento.
    local function getSafeVehicleMax(vehicle, seat)
        local native = nil
        for _, owner in ipairs({vehicle, seat}) do
            for _, name in ipairs({"TopSpeed", "MaxSpeed", "max_speed", "maxSpeed", "VehicleSpeed"}) do
                local value = tonumber(owner:GetAttribute(name))
                if value and value >= 8 and value <= 350 then
                    native = math.max(native or 0, value)
                end
            end
        end
        if not native then
            pcall(function()
                local value = tonumber(seat.MaxSpeed)
                -- 25 suele ser el valor predeterminado de VehicleSeat.
                -- No usarlo como límite de coches con conducción personalizada.
                if value and value >= 8 and value <= 350
                    and math.abs(value - 25) > 0.5 then native = value end
            end)
        end
        -- Margen moderado sobre capacidad del chasis, sin exigir que
        -- todos los modelos soporten velocidad 200 de golpe.
        return native and math.clamp(native * 1.8, 40, 200) or 140
    end
    SettingsVisual.VehicleGetSafeMaxSpeed = getSafeVehicleMax

	local function clearState(restoreWheels)
        S.NativeSafeMax = nil
        S.AdaptiveMax = nil
        S.LastObservedPosition = nil
        S.LastAppliedDirection = nil
        S.LastExpectedSpeed = 0
        S.StabilityStrikes = 0
		S.CurrentDriveSpeed = 0
		S.Vehicle = nil
		S.Root = nil
		S.Seat = nil
		if restoreWheels then
			restoreWheelVisuals()
		end
	end

	S.Heartbeat = RunService.Heartbeat:Connect(function(dt)
		if not S.Enabled then return end

		-- Durante una transición suave de la casilla derecha,
		-- ese motor tiene prioridad para que no haya tirones.
		-- Abajo manda SOLO Snap Car para no duplicar el motor.
		if SettingsVisual.TouchCarOneShotBusy
            or (SettingsVisual.TouchSnapCarState
                and (SettingsVisual.TouchSnapCarState.Enabled
                    or SettingsVisual.TouchSnapCarState.Exiting
                    or SettingsVisual.TouchSnapCarState.OneShotBusy)) then
			-- No aplicar throttle, steering ni PivotTo al mismo carro durante el TP.
			S.CurrentDriveSpeed = 0
			return
		end

		local vehicle, root, seat = getVehicle()
		if not vehicle or not root or not seat then
			clearState(true)
			return
		end

        if S.Vehicle ~= vehicle then
            -- Reiniciar adaptación al cambiar de automóvil: un coche
            -- pequeño no hereda la velocidad enorme del coche anterior.
            S.CurrentDriveSpeed = 0
            S.NativeSafeMax = getSafeVehicleMax(vehicle, seat)
            S.AdaptiveMax = S.NativeSafeMax
            S.LastObservedPosition = nil
            S.StabilityStrikes = 0
        end
		S.Vehicle = vehicle
		S.Root = root
		S.Seat = seat

        -- Detectar correcciones del servidor / rebotes de velocidad:
        -- si esperábamos avanzar y el coche se queda casi inmóvil o
        -- retrocede, reducir automáticamente su tope efectivo.
        local currentPos = root.Position
        local elapsed = math.clamp(dt, 1/240, 0.10)
        local hoverNow = SettingsVisual.ChinoCarHover
        local hoverDriving = hoverNow and hoverNow.Active and hoverNow.Vehicle == vehicle
        if not hoverDriving and S.LastObservedPosition and S.LastAppliedDirection
            and (S.LastExpectedSpeed or 0) > 25 then
            local traveled = currentPos - S.LastObservedPosition
            local actualForward = traveled:Dot(S.LastAppliedDirection)
            local expectedForward = (S.LastExpectedSpeed or 0) * elapsed
            if actualForward < -math.max(2, expectedForward * 1.2) then
                -- Una corrección brusca hacia atrás = posible rollback.
                -- Bajar la velocidad de inmediato antes de otro intento.
                S.AdaptiveMax = math.max(28, (S.AdaptiveMax or 140) * 0.72)
                S.CurrentDriveSpeed = math.clamp(
                    S.CurrentDriveSpeed or 0, -S.AdaptiveMax * 0.65, S.AdaptiveMax
                )
                S.StabilityStrikes = 0
            elseif actualForward < math.max(0.10, expectedForward * 0.24) then
                S.StabilityStrikes = (S.StabilityStrikes or 0) + 1
            else
                S.StabilityStrikes = math.max(0, (S.StabilityStrikes or 0) - 1)
            end
            if S.StabilityStrikes >= 5 then
                S.AdaptiveMax = math.max(28, (S.AdaptiveMax or 140) * 0.78)
                S.StabilityStrikes = 0
            end
        end
        -- La limitación anterior no se recuperaba nunca: los sliders seguían
        -- indicando 90/200, pero el tope interno acababa en 28.
        -- Recuperación gradual, no golpe brusco de velocidad tras un rollback.
        local wantedMax = tonumber(S.NativeSafeMax) or getSafeVehicleMax(vehicle,seat)
        local adaptive = tonumber(S.AdaptiveMax) or wantedMax
        S.AdaptiveMax = math.min(wantedMax, adaptive + (hoverDriving and 40 or 9)*math.clamp(dt,0,0.1))
        if hoverDriving then S.StabilityStrikes = 0 end
        S.LastObservedPosition = currentPos

		local nativeThrottle = 0
		local nativeSteer = 0

		pcall(function()
			local tf = tonumber(seat.ThrottleFloat) or 0
			local ti = tonumber(seat.Throttle) or 0
			local sf = tonumber(seat.SteerFloat) or 0
			local si = tonumber(seat.Steer) or 0
			nativeThrottle = math.abs(tf) >= math.abs(ti) and tf or ti
			nativeSteer = math.abs(sf) >= math.abs(si) and sf or si
		end)

		if math.abs(nativeThrottle) < 0.05 then nativeThrottle = 0 end
		if math.abs(nativeSteer) < 0.05 then nativeSteer = 0 end

		-- IMPORTANTE:
		-- En móvil algunos VehicleSeat no reflejan bien Throttle/Steer.
		-- Reutilizamos exactamente el mismo estado táctil del Snap Car.
		local touchState = SettingsVisual.TouchSnapCarState
		if touchState then
			if touchState.NativeForwardHeld and not touchState.NativeReverseHeld then
				nativeThrottle = 1
			elseif touchState.NativeReverseHeld and not touchState.NativeForwardHeld then
				nativeThrottle = -1
			elseif touchState.NativeForwardHeld and touchState.NativeReverseHeld then
				nativeThrottle = 0
			end

			if touchState.NativeSteerTouch then
				nativeSteer = touchState.NativeSteerAxis
			end
		end

		if nativeThrottle == 0 and nativeSteer == 0 then
			pcall(function()
				local char = Player.Character
				local hum = char and char:FindFirstChildOfClass("Humanoid")
				if hum and hum.MoveDirection.Magnitude > 0.05 then
					local forward = flatLook(root.CFrame)
					local right = Vector3.new(root.CFrame.RightVector.X, 0, root.CFrame.RightVector.Z)
					if right.Magnitude > 0.001 then right = right.Unit end
					nativeThrottle = math.clamp(hum.MoveDirection:Dot(forward), -1, 1)
					nativeSteer = math.clamp(hum.MoveDirection:Dot(right), -1, 1)
				end
			end)
		end

        local safeMax = math.clamp(tonumber(S.AdaptiveMax) or 140, 25, 200)
        local forwardMax = math.min(math.clamp(tonumber(SettingsVisual.VehicleForwardMaxSpeed) or 90, 1, 200), safeMax)
        local reverseMax = math.min(math.clamp(tonumber(SettingsVisual.VehicleReverseMaxSpeed) or 90, 1, 200), safeMax * 0.65)
        -- En coches débiles hay que llegar al máximo gradualmente,
        -- aunque el usuario arrastre Acceleration hasta 200.
        local safeAccel = math.max(24, safeMax * 1.15)
        local accelRate = math.min(math.clamp(tonumber(SettingsVisual.VehicleAcceleration) or 200, 0, 200), safeAccel)
        local brakeRate = math.min(math.clamp(tonumber(SettingsVisual.VehicleBraking) or 200, 0, 200), safeAccel * 1.35)
        local directionRate = math.min(math.clamp(tonumber(SettingsVisual.VehicleDirectionRate) or 200, 0, 200), safeAccel)
        local steerPower = math.clamp(tonumber(SettingsVisual.VehicleSteerPower) or 200, 0, 200)

		local throttleMagnitude = math.clamp(math.abs(nativeThrottle), 0, 1)
		local targetSignedSpeed = 0
		if throttleMagnitude > 0 then
			if nativeThrottle < 0 then
				targetSignedSpeed = -reverseMax * throttleMagnitude
			else
				targetSignedSpeed = forwardMax * throttleMagnitude
			end
		end

		local currentSpeed = tonumber(S.CurrentDriveSpeed) or 0
		local changingDirection =
			currentSpeed ~= 0
			and targetSignedSpeed ~= 0
			and ((currentSpeed > 0 and targetSignedSpeed < 0)
				or (currentSpeed < 0 and targetSignedSpeed > 0))

		local rate
		if targetSignedSpeed == 0 then
			rate = brakeRate
		elseif changingDirection then
			rate = directionRate
		else
			rate = accelRate
		end

		S.CurrentDriveSpeed = moveTowards(
			currentSpeed,
			targetSignedSpeed,
			rate * math.max(dt, 1 / 240)
		)

		local flat = flatLook(root.CFrame)
		local upright = uprightAt(root.Position, flat)
		local steerMultiplier = steerPower / 100
		local turnRadians =
			-nativeSteer
			* 2.8
			* steerMultiplier
			* math.max(throttleMagnitude, 0.42)
			* dt

        -- Carros lentos: no forzar PivotTo en cada frame (causaba
        -- correcciones de posición del servidor y carros voladores).
        local lowPower = safeMax < 72
        local safeTurn = lowPower and math.clamp(turnRadians, -0.030, 0.030)
            or math.clamp(turnRadians, -0.055, 0.055)
        local rotatedRoot = upright * CFrame.Angles(0, safeTurn, 0)
        -- En modo levitación NO forzar PivotTo en cada frame.
        -- Ese teletransporte repetido provoca rollback a alta velocidad.
        if not lowPower and not hoverDriving then
            local rootToPivot = root.CFrame:ToObjectSpace(vehicle:GetPivot())
            pcall(function() vehicle:PivotTo(rotatedRoot * rootToPivot) end)
        end

        local direction = (lowPower or hoverDriving) and flat or rotatedRoot.LookVector
        local driveVector = direction * S.CurrentDriveSpeed
        local currentY = root.AssemblyLinearVelocity.Y
        -- Vehículos débiles: limitar impulsos verticales accidentales.
        if lowPower then currentY = math.clamp(currentY, -45, 26) end
        root.AssemblyLinearVelocity = Vector3.new(driveVector.X, currentY, driveVector.Z)
        local av = root.AssemblyAngularVelocity
        if lowPower or hoverDriving then
            -- No ahogar el giro natural al conducir con el vehículo suspendido.
            root.AssemblyAngularVelocity = Vector3.new(av.X, math.clamp(av.Y,-3,3), av.Z)
        else
            root.AssemblyAngularVelocity = Vector3.new(0, av.Y * 0.10, 0)
        end
        S.LastAppliedDirection = direction * (S.CurrentDriveSpeed >= 0 and 1 or -1)
        S.LastExpectedSpeed = math.abs(S.CurrentDriveSpeed) * math.abs(nativeThrottle)

        updateWheelVisuals(vehicle, dt, S.CurrentDriveSpeed, nativeThrottle)
	end)

	SettingsVisual.SetVehicleSliderDriveState = function(enabled)
		S.Enabled = enabled and true or false
		SettingsVisual.VehicleSlidersEnabled = S.Enabled
		clearState(not S.Enabled)

		-- Limpiar controles táctiles si se apaga arriba.
		if not S.Enabled and SettingsVisual.TouchSnapCarState
			and not SettingsVisual.TouchSnapCarState.Enabled then
			local T = SettingsVisual.TouchSnapCarState
			T.NativeForwardHeld = false
			T.NativeReverseHeld = false
			T.NativeForwardTouch = nil
			T.NativeReverseTouch = nil
			T.NativeSteerTouch = nil
			T.NativeSteerAxis = 0
		end
	end
end

SettingsVisual.SetupVehicleSliderDriveSystem()

-- Si por orden de construcción el toggle se activó antes de crear el motor,
-- sincronizarlo ahora.
if SettingsVisual.VehicleSlidersEnabled
	and SettingsVisual.SetVehicleSliderDriveState then
	SettingsVisual.SetVehicleSliderDriveState(true)
end

-- Estados de las nuevas opciones persistentes.
SettingsVisual.AutoFinishEnabled = false
SettingsVisual.AutoRespawnEnabled = false
SettingsVisual.AutoRespawnBusy = false
SettingsVisual.AutoRespawnItemsEnabled = false
SettingsVisual.AutoRespawnItemsBusy = false
SettingsVisual.AutoFinishBusy = setmetatable({}, {__mode = "k"})
SettingsVisual.AutoFinishHoldTime = 1

-- Anti Lock: pausa automática al acercarse al carro y reanudación al alejarse.
-- El toggle se mantiene activado; solo se suspenden los pulsos de desync.
SettingsVisual.AntiLockCarPauseRadius = 9  -- studs: al acercarse, pausa
SettingsVisual.AntiLockCarResumeRadius = 12 -- studs: al alejarse, reanuda
SettingsVisual.AntiLockPausedForCar = false
SettingsVisual.AntiLockLastSeatedCar = nil
SettingsVisual.AntiLockNextCarCheck = 0

SettingsVisual.AntiLockCarIsMine = function(vehicle)
    if not vehicle or not vehicle:IsA("Model") then return false end
    if SettingsVisual.VehicleActionIsMine(vehicle) then return true end
    -- Respaldo: ipairs sobre atributos que pueden ser nil no los revisa todos.
    for _, name in ipairs({
        "OwnerUserId", "Owner", "OwnerId", "OwnerID", "owner_id",
        "UserId", "PlayerUserId", "OwnerName", "PlayerName"
    }) do
        local value = vehicle:GetAttribute(name)
        if value ~= nil and (
            tostring(value) == tostring(Player.UserId)
            or tostring(value) == tostring(Player.Name)
        ) then
            return true
        end
    end
    return false
end

SettingsVisual.AntiLockNearOwnedCar = function(position, radius)
    if not position then return false end
    local folder = workspace:FindFirstChild("Vehicles")
    if not folder then return false end

    local function closeTo(vehicle)
        if not vehicle or not vehicle.Parent then return false end
        local seat = vehicle:FindFirstChild("DriverSeat", true)
            or vehicle:FindFirstChildWhichIsA("VehicleSeat", true)
            or vehicle:FindFirstChildWhichIsA("Seat", true)
        local anchor = seat or vehicle.PrimaryPart or vehicle:FindFirstChildWhichIsA("BasePart", true)
        return anchor ~= nil and (anchor.Position - position).Magnitude <= radius
    end

    -- Se recuerda el coche al bajarse, aunque el atributo Owner aún no cargue.
    local lastCar = SettingsVisual.AntiLockLastSeatedCar
    if lastCar and lastCar:IsDescendantOf(folder) and closeTo(lastCar) then
        return true
    end
    for _, vehicle in ipairs(folder:GetChildren()) do
        if vehicle:IsA("Model") and SettingsVisual.AntiLockCarIsMine(vehicle)
            and closeTo(vehicle) then
            return true
        end
    end
    return false
end

SettingsVisual.RefreshAntiLockCarPause = function(root, humanoid)
    -- Si está montado, Anti Lock siempre queda en pausa para no mover el auto.
    local seat = humanoid and humanoid.SeatPart
    if seat then
        local car = SettingsVisual.VehicleActionFromSeat(seat)
        if car then SettingsVisual.AntiLockLastSeatedCar = car end
        SettingsVisual.AntiLockPausedForCar = true
        return
    end
    if not root then
        SettingsVisual.AntiLockPausedForCar = false
        return
    end

    -- Histéresis: 9 studs para pausar, 12 para reactivar.
    local radius = SettingsVisual.AntiLockPausedForCar
        and SettingsVisual.AntiLockCarResumeRadius
        or SettingsVisual.AntiLockCarPauseRadius
    SettingsVisual.AntiLockPausedForCar =
        SettingsVisual.AntiLockNearOwnedCar(root.Position, radius)
end

--========================================================--
-- ANTI LOCK ROBADO (opcion Anti Lock original de CHINO)
-- Fuente: ROBADO(2).txt: startAntiLock / stopAntiLock, 1091-1129.
--    * gira a 1600 grados/s, magnitud 1600 (leve aumento), Y = 280..480
--    * cambia root.Velocity y recupera el valor original
--      al siguiente RenderStepped (como el original ROBADO).
-- CHINO conserva: deteccion de caminar, pausa cerca de carro,
-- guardas al hacer TP / Anti-Kill, sin duplicar Heartbeat.
-- No es el Anti-Kill de ROBADO: NO altera ese otro toggle.
--========================================================--
SettingsVisual.RobadoAntiLockSpeed = 1600
SettingsVisual.RobadoAntiLockDegreesPerSecond = 1600
SettingsVisual.RobadoAntiLockVerticalMin = 280
SettingsVisual.RobadoAntiLockVerticalMax = 480
SettingsVisual.RobadoAntiLockSnapshot = nil
SettingsVisual.RobadoAntiLockPulseRunning = false
SettingsVisual.RobadoAntiLockGeneration = 0
SettingsVisual.RobadoAntiLockPulseCount = 0
SettingsVisual.AntiLockDesyncLastMove = 0
SettingsVisual.AntiLockDesyncMoveGrace = 0.09
SettingsVisual.AntiLockControls = nil
SettingsVisual.AntiLockDesyncLastPos = nil
SettingsVisual.AntiLockDesyncLastPosTime = 0

SettingsVisual.AntiLockIsMoving = function(hum, root)
    if not hum or not root then return false end
    local now = os.clock()
    local moving = hum.MoveDirection.Magnitude > 0.04

    -- Deteccion real del joystick en iPhone / Delta.
    if not moving then
        if not SettingsVisual.AntiLockControls then
            pcall(function()
                local scripts = Player:FindFirstChild("PlayerScripts")
                local module = scripts and scripts:FindFirstChild("PlayerModule")
                if module then
                    SettingsVisual.AntiLockControls = require(module):GetControls()
                end
            end)
        end
        local controls = SettingsVisual.AntiLockControls
        if controls then
            local ok, dir = pcall(function() return controls:GetMoveVector() end)
            moving = ok and typeof(dir) == "Vector3"
                and Vector2.new(dir.X, dir.Z).Magnitude > 0.04
        end
    end

    -- Movimiento real como respaldo (ignora teleports grandes).
    if not SettingsVisual.RobadoAntiLockPulseRunning then
        local previous = SettingsVisual.AntiLockDesyncLastPos
        local previousTime = SettingsVisual.AntiLockDesyncLastPosTime or 0
        local current = root.Position
        if not moving and previous and now - previousTime >= 0.05 then
            local delta = Vector3.new(current.X - previous.X, 0, current.Z - previous.Z)
            if delta.Magnitude > 0.24 and delta.Magnitude < 2.5 then
                moving = true
            end
        end
        SettingsVisual.AntiLockDesyncLastPos = current
        SettingsVisual.AntiLockDesyncLastPosTime = now
    end

    if moving then SettingsVisual.AntiLockDesyncLastMove = now end
    return moving or
        (now - (SettingsVisual.AntiLockDesyncLastMove or 0)) <
        (SettingsVisual.AntiLockDesyncMoveGrace or 0.09)
end

SettingsVisual.RobadoAntiLockStopPulse = function()
    local snapshot = SettingsVisual.RobadoAntiLockSnapshot
    SettingsVisual.RobadoAntiLockSnapshot = nil
    SettingsVisual.RobadoAntiLockPulseRunning = false
    SettingsVisual.RobadoAntiLockGeneration += 1
    if snapshot and snapshot.Root and snapshot.Root.Parent
        and snapshot.Character == Player.Character then
        -- ROBADO restituye solo Velocity, sin alterar AngularVelocity.
        pcall(function() snapshot.Root.Velocity = snapshot.Velocity end)
    end
end

SettingsVisual.RobadoAntiLockCanPulse = function(hum, root)
    return SettingsVisual.AntiLockEnabled
        and not SettingsVisual.AntiLockPausedForCar
        and not SettingsVisual.ChinoAntiKillDown
        and hum.SeatPart == nil
        and not hum.Sit
        and not hum:GetAttribute("HasBeenDowned")
        and not hum:GetAttribute("IsDead")
        and not SettingsVisual.TouchCarOneShotBusy
        and not SettingsVisual.TouchCarSmoothJumpBusy
        and SettingsVisual.AntiLockIsMoving(hum, root)
end

-- La misma conexion Heartbeat sigue activa; el toggle solo cambia Enabled.
RunService.Heartbeat:Connect(function()
    if not SettingsVisual.AntiLockEnabled then
        if SettingsVisual.RobadoAntiLockPulseRunning then
            SettingsVisual.RobadoAntiLockStopPulse()
        end
        SettingsVisual.AntiLockPausedForCar = false
        SettingsVisual.AntiLockNextCarCheck = 0
        SettingsVisual.AntiLockDesyncLastMove = 0
        SettingsVisual.AntiLockDesyncLastPos = nil
        return
    end

    local char = Player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not (hum and root and hum.Health > 0) then
        if SettingsVisual.RobadoAntiLockPulseRunning then
            SettingsVisual.RobadoAntiLockStopPulse()
        end
        return
    end

    local now = os.clock()
    if now >= (SettingsVisual.AntiLockNextCarCheck or 0) then
        SettingsVisual.AntiLockNextCarCheck = now + 0.08
        pcall(SettingsVisual.RefreshAntiLockCarPause, root, hum)
    end

    if SettingsVisual.RobadoAntiLockPulseRunning then return end
    if not SettingsVisual.RobadoAntiLockCanPulse(hum, root) then return end

    local snapshot = {
        Root = root,
        Character = char,
        Velocity = root.Velocity,
    }
    SettingsVisual.RobadoAntiLockSnapshot = snapshot
    SettingsVisual.RobadoAntiLockPulseRunning = true
    SettingsVisual.RobadoAntiLockGeneration += 1
    local generation = SettingsVisual.RobadoAntiLockGeneration

    -- Logica ORIGINAL ROBADO: angulo basado en tick(), velocidad
    -- horizontal giratoria de 1600 y altura aleatoria 280..480.
    local angle = math.rad(tick() * SettingsVisual.RobadoAntiLockDegreesPerSecond % 360)
    local amount = SettingsVisual.RobadoAntiLockSpeed
    local velocity = Vector3.new(
        math.cos(angle) * amount,
        math.random(SettingsVisual.RobadoAntiLockVerticalMin, SettingsVisual.RobadoAntiLockVerticalMax),
        math.sin(angle) * amount
    )
    local ok = pcall(function() root.Velocity = velocity end)
    if not ok then
        SettingsVisual.RobadoAntiLockStopPulse()
        return
    end
    SettingsVisual.RobadoAntiLockPulseCount += 1

    task.spawn(function()
        RunService.RenderStepped:Wait()
        if SettingsVisual.RobadoAntiLockGeneration == generation
            and SettingsVisual.RobadoAntiLockSnapshot == snapshot then
            SettingsVisual.RobadoAntiLockStopPulse()
        end
    end)
end)

Player.CharacterAdded:Connect(function()
    SettingsVisual.RobadoAntiLockStopPulse()
    SettingsVisual.AntiLockNextCarCheck = 0
    SettingsVisual.AntiLockPausedForCar = false
    SettingsVisual.AntiLockControls = nil
    SettingsVisual.AntiLockDesyncLastPos = nil
    SettingsVisual.AntiLockDesyncLastMove = 0
end)

-- Auto Finish/Finnish: busca FinishPrompt de otros jugadores y completa el hold.
task.spawn(function()
	while Gui and Gui.Parent do
		if SettingsVisual.AutoFinishEnabled then
			for _, plr in ipairs(Players:GetPlayers()) do
				if plr ~= Player and plr.Character then
					local root = plr.Character:FindFirstChild("HumanoidRootPart")
					local prompt = root and root:FindFirstChild("FinishPrompt")
					if prompt and prompt:IsA("ProximityPrompt") then
						pcall(function()
							prompt.HoldDuration = SettingsVisual.AutoFinishHoldTime
							prompt.MaxActivationDistance = 20
						end)
						if not SettingsVisual.AutoFinishBusy[prompt] then
							SettingsVisual.AutoFinishBusy[prompt] = true
							task.spawn(function()
								pcall(function() prompt:InputHoldBegin() end)
								task.wait(SettingsVisual.AutoFinishHoldTime)
								pcall(function() prompt:InputHoldEnd() end)
								SettingsVisual.AutoFinishBusy[prompt] = nil
							end)
						end
					end
				end
			end
		end
		task.wait(0.4)
	end
end)

-- Auto Respawn del script fuente, conectado al Remote Send/counter actual.
task.spawn(function()
	while Gui and Gui.Parent do
		if SettingsVisual.AutoRespawnEnabled and not SettingsVisual.AutoRespawnItemsEnabled and not SettingsVisual.AutoRespawnBusy then
			local char = Player.Character
			local hum = char and char:FindFirstChildOfClass("Humanoid")
			if hum and hum.Health <= 0 then
				SettingsVisual.AutoRespawnBusy = true
				task.spawn(function()
					task.wait(6)
					if SettingsVisual.AutoRespawnEnabled then
						FireServerHook("death_screen_request_respawn")
					end
					task.wait(1)
					SettingsVisual.AutoRespawnBusy = false
				end)
			end
		end
		task.wait(0.5)
	end
end)

-- Auto Respawn invisible -> reaparece y coloca al jugador junto al ítem tirado más cercano.
task.spawn(function()
	while Gui and Gui.Parent do
		if SettingsVisual.AutoRespawnItemsEnabled and not SettingsVisual.AutoRespawnItemsBusy then
			local char = Player.Character
			local hum = char and char:FindFirstChildOfClass("Humanoid")

			if hum and hum.Health <= 0 then
				SettingsVisual.AutoRespawnItemsBusy = true

				task.spawn(function()
					task.wait(6)

					if SettingsVisual.AutoRespawnItemsEnabled then
						FireServerHook("death_screen_request_respawn")
					end

					local deadline = os.clock() + 8
					local liveChar, liveHum, liveRoot

					repeat
						liveChar = Player.Character
						liveHum = liveChar and liveChar:FindFirstChildOfClass("Humanoid")
						liveRoot = liveChar and liveChar:FindFirstChild("HumanoidRootPart")

						if liveHum and liveRoot and liveHum.Health > 0 then
							break
						end

						task.wait(0.15)
					until os.clock() >= deadline or not SettingsVisual.AutoRespawnItemsEnabled

					if SettingsVisual.AutoRespawnItemsEnabled and liveChar and liveRoot and liveHum and liveHum.Health > 0 then
						local folder = workspace:FindFirstChild("DroppedItems")
							or workspace:FindFirstChild("DroppedItem")
							or DroppedItems

						local bestPart, bestDist = nil, math.huge

						if folder then
							for _, item in ipairs(folder:GetChildren()) do
								if item:IsA("Model") then
									local pickup = item:FindFirstChild("PickUpZone", true)
									local part = nil

									if pickup and pickup:IsA("BasePart") then
										part = pickup
									elseif pickup and pickup:IsA("Attachment") and pickup.Parent and pickup.Parent:IsA("BasePart") then
										part = pickup.Parent
									end

									part = part
										or item.PrimaryPart
										or item:FindFirstChildWhichIsA("BasePart", true)

									if part then
										local dist = (part.Position - liveRoot.Position).Magnitude
										if dist < bestDist then
											bestDist = dist
											bestPart = part
										end
									end
								end
							end
						end

						if bestPart and bestPart.Parent then
							local rotationOnly = liveChar:GetPivot() - liveChar:GetPivot().Position
							local destination = CFrame.new(bestPart.Position + Vector3.new(0, 1.15, 0)) * rotationOnly
							local holdUntil = os.clock() + 0.85

							repeat
								if not liveChar.Parent or not liveRoot.Parent or not bestPart.Parent then break end
								liveChar:PivotTo(destination)
								liveRoot.AssemblyLinearVelocity = Vector3.zero
								liveRoot.AssemblyAngularVelocity = Vector3.zero
								RunService.Heartbeat:Wait()
							until os.clock() >= holdUntil
						end
					end

					SettingsVisual.AutoRespawnItemsBusy = false
				end)
			end
		end

		task.wait(0.5)
	end
end)

-- CONFIG
SettingsVisual.SaveConfig = function()
	if not writefile then return false end
	local ok = pcall(function()
		if makefolder and (not isfolder or not isfolder(SettingsVisual.ConfigFolder)) then
			pcall(function() makefolder(SettingsVisual.ConfigFolder) end)
		end

		local payload = {Version = 2, Controls = {}, Manual = {}}
		for key, control in pairs(SettingsVisual.ConfigControls) do
			if control.Get then
				payload.Controls[key] = control.Get()
			end
		end

		payload.Manual.TargetHitPart = TargetHitPart
		payload.Manual.SilentAimHitPart = SilentAimHitPart
		payload.Manual.SoftAimMobilePart = SoftAimMobilePart
		payload.Manual.SoftAimPCPart = SoftAimPCPart
		payload.Manual.SoftAimPCEnabled = SoftAimPCEnabled
		payload.Manual.SoftAimPCKey = SoftAimPCKey.Name
		payload.Manual.SoftAimControlKey = SettingsVisual.SoftAimControlKey and SettingsVisual.SoftAimControlKey.Name or "ButtonL2"
		payload.Manual.TouchPanelValue = SettingsVisual.TouchPanelUpMode and (SettingsVisual.TouchPanelSavedValue or 20) or TouchPanelValue
		payload.Manual.VehicleAimOffsetX = SettingsVisual.VehicleAimOffsetX or -30
		payload.Manual.VehicleAimOffsetY = SettingsVisual.VehicleAimOffsetY or -30
		payload.Manual.GhostActive = SettingsVisual.GetGhostState and SettingsVisual.GetGhostState() or false

		writefile(SettingsVisual.ConfigFile, game:GetService("HttpService"):JSONEncode(payload))
	end)
	return ok
end

SettingsVisual.LoadConfig = function()
	if not readfile or not isfile or not isfile(SettingsVisual.ConfigFile) then return false end
	local ok = pcall(function()
		local payload = game:GetService("HttpService"):JSONDecode(readfile(SettingsVisual.ConfigFile))
		if type(payload) ~= "table" then return end

		if type(payload.Controls) == "table" then
			for key, value in pairs(payload.Controls) do
				-- Conserva las configs anteriores al cambio del nombre visual
				-- "(CHINO)" y vuelve a activar los nuevos toggles guardados.
				-- No cambia el nombre de ninguna otra opción del HUB.
				local configKey = key
				if type(configKey) == "string" then
					configKey = configKey:gsub(" %(CHINO%)#", "#")
				end
				if configKey == "Modo God#1" and SettingsVisual.EntryMode then
					value = SettingsVisual.EntryMode == "God"
				end
				local control = SettingsVisual.ConfigControls[configKey]
				if control and control.Set then
					pcall(function() control.Set(value) end)
				end
			end
		end

		local manual = type(payload.Manual) == "table" and payload.Manual or {}
		if manual.TargetHitPart then
			if SettingsVisual.SetTargetHitPart then
				SettingsVisual.SetTargetHitPart(manual.TargetHitPart)
			else
				TargetHitPart = manual.TargetHitPart
			end
		end

		if manual.SilentAimHitPart then
			if SettingsVisual.SetSilentAimHitPart then
				SettingsVisual.SetSilentAimHitPart(
					manual.SilentAimHitPart
				)
			else
				SilentAimHitPart =
					manual.SilentAimHitPart
			end
		end

		if manual.SoftAimMobilePart then
			if SettingsVisual.SetSoftAimMobilePart then SettingsVisual.SetSoftAimMobilePart(manual.SoftAimMobilePart) else SoftAimMobilePart = manual.SoftAimMobilePart end
		end
		if manual.SoftAimPCPart then
			if SettingsVisual.SetSoftAimPCPart then SettingsVisual.SetSoftAimPCPart(manual.SoftAimPCPart) else SoftAimPCPart = manual.SoftAimPCPart end
		end
		if manual.SoftAimPCKey then
			if SettingsVisual.SetSoftAimPCKey then SettingsVisual.SetSoftAimPCKey(manual.SoftAimPCKey)
			elseif Enum.KeyCode[manual.SoftAimPCKey] then SoftAimPCKey = Enum.KeyCode[manual.SoftAimPCKey] end
		end
		if manual.SoftAimControlKey then
			if SettingsVisual.SetSoftAimControlKey then
				SettingsVisual.SetSoftAimControlKey(manual.SoftAimControlKey)
			elseif Enum.KeyCode[manual.SoftAimControlKey] then
				SettingsVisual.SoftAimControlKey = Enum.KeyCode[manual.SoftAimControlKey]
			end
		end
		if manual.SoftAimPCEnabled ~= nil and SettingsVisual.SetSoftAimPCEnabled then
			SettingsVisual.SetSoftAimPCEnabled(manual.SoftAimPCEnabled == true)
		end
		if tonumber(manual.TouchPanelValue) then
			TouchPanelValue = math.clamp(tonumber(manual.TouchPanelValue), 5, 100)
			if SettingsVisual.RefreshTouchDepthText then SettingsVisual.RefreshTouchDepthText() end
		end
		-- Los dos sliders sin nombre de Soft Aim/vehículo arrancan al mínimo.
		if SettingsVisual.SetVehicleAimOffsetX then
			SettingsVisual.SetVehicleAimOffsetX(-30)
		else
			SettingsVisual.VehicleAimOffsetX = -30
		end
		if SettingsVisual.SetVehicleAimOffsetY then
			SettingsVisual.SetVehicleAimOffsetY(-30)
		else
			SettingsVisual.VehicleAimOffsetY = -30
		end
		if manual.GhostActive ~= nil and SettingsVisual.SetGhostState then
			SettingsVisual.SetGhostState(manual.GhostActive == true)
		end

		-- Xeno: Speed Hack/Ghost viejos siguen arrancando apagados.
		-- Anti Lock vuelve a respetar su estado y funciona normalmente.
		if SettingsVisual.IsXeno then
			SpeedHackEnabled = false

			if SettingsVisual.ConfigControls["Speed Hack"]
				and SettingsVisual.ConfigControls["Speed Hack"].Set then
				pcall(function()
					SettingsVisual.ConfigControls["Speed Hack"].Set(false)
				end)
			end

			if SettingsVisual.SetGhostState then
				pcall(function() SettingsVisual.SetGhostState(false) end)
			end
		end

		SettingsVisual.ConfigLoaded = true
	end)
	return ok
end

SettingsVisual.ResetConfig = function()
	-- Todos los toggles OFF; sliders vuelven a su valor inicial.
	for _, control in pairs(SettingsVisual.ConfigControls) do
		if control and control.Set then
			if control.Type == "Toggle" then
				pcall(function() control.Set(false) end)
			elseif control.Type == "Slider" then
				pcall(function() control.Set(control.Default) end)
			end
		end
	end

	if SettingsVisual.SetTargetHitPart then SettingsVisual.SetTargetHitPart("Neck") else TargetHitPart = "Neck" end

	if SettingsVisual.SetSilentAimHitPart then
		SettingsVisual.SetSilentAimHitPart("Head")
	else
		SilentAimHitPart = "Head"
	end

	if SettingsVisual.SetSoftAimMobilePart then SettingsVisual.SetSoftAimMobilePart("Neck") else SoftAimMobilePart = "Neck" end
	if SettingsVisual.SetSoftAimPCPart then SettingsVisual.SetSoftAimPCPart("Neck") else SoftAimPCPart = "Neck" end
	if SettingsVisual.SetSoftAimPCKey then SettingsVisual.SetSoftAimPCKey("E") else SoftAimPCKey = Enum.KeyCode.E end
	if SettingsVisual.SetSoftAimControlKey then SettingsVisual.SetSoftAimControlKey("ButtonL2") else SettingsVisual.SoftAimControlKey = Enum.KeyCode.ButtonL2 end
	if SettingsVisual.SetSoftAimPCEnabled then SettingsVisual.SetSoftAimPCEnabled(false) end
	if SettingsVisual.SetStrongAimbotEnabled then SettingsVisual.SetStrongAimbotEnabled(false) end
	if SettingsVisual.SetVehicleAimOffsetX then SettingsVisual.SetVehicleAimOffsetX(-30) else SettingsVisual.VehicleAimOffsetX = -30 end
	if SettingsVisual.SetVehicleAimOffsetY then SettingsVisual.SetVehicleAimOffsetY(-30) else SettingsVisual.VehicleAimOffsetY = -30 end
	if SettingsVisual.SetGhostState then SettingsVisual.SetGhostState(false) end
	if SettingsVisual.SetTouchSnapState then SettingsVisual.SetTouchSnapState(false) end
	SettingsVisual.TouchPanelUpMode = false
	SettingsVisual.TouchPanelSavedValue = nil
	TouchPanelValue = 20
	if SettingsVisual.TouchUpCheck then
		SettingsVisual.TouchUpCheck.Text = ""
		SettingsVisual.TouchUpCheck.BackgroundColor3 = Color3.fromRGB(28, 31, 42)
	end
	if SettingsVisual.RefreshTouchDepthText then SettingsVisual.RefreshTouchDepthText() end

	-- Guardamos el estado reseteado para que la siguiente ejecucion tambien arranque limpio.
	task.defer(function()
		if SettingsVisual.SaveConfig then SettingsVisual.SaveConfig() end
	end)
end

MakeToggle(configLeft, "Auto Finnish", false, function(v)
	SettingsVisual.AutoFinishEnabled = v
end)
MakeToggle(configLeft, "Auto Respawn", false, function(v)
	SettingsVisual.AutoRespawnEnabled = v
	if not v then
		SettingsVisual.AutoRespawnBusy = false
	end
end)

-- MODO GOD: controlador compartido entre el selector inicial y Config.
-- El selector de entrada conserva su secuencia original de inicio.
-- Cada pulsacion MANUAL de Modo God en Config solicita tambien reaparecer.
-- La carga de configuraciones y los cambios programaticos NO provocan respawn.
SettingsVisual.GodModeRuntime = {
	Enabled = false,
	HookReady = false,
	HookOriginal = nil,
	HookNet = nil,
	ConstantsPatched = false,
	ConstantFunction = nil,
	OriginalConstant3 = nil,
	OriginalConstant4 = nil,
}

function SettingsVisual.GodModeGetNet()
	if DumpCarRuntime and DumpCarRuntime.Net then
		return DumpCarRuntime.Net
	end
	local ok, net = pcall(function()
		local modules = ReplicatedStorage:FindFirstChild("Modules")
		if not modules then return nil end
		local core = modules:FindFirstChild("Core")
		if not core then return nil end
		local netModule = core:FindFirstChild("Net")
		if not netModule then return nil end
		return require(netModule)
	end)
	return ok and net or nil
end

function SettingsVisual.SetGodModeActive(value)
	local state = SettingsVisual.GodModeRuntime
	local enabled = value == true
	if not enabled then
		-- Una intercepcion ya instalada queda PASIVA al apagarla:
		-- todas las llamadas originales a Net.send vuelven a pasar.
		state.Enabled = false
		_G.Bypass = false
		if state.ConstantsPatched and state.ConstantFunction then
			local setter = setconstant or (debug and debug.setconstant)
			if setter then
				local ok3 = pcall(setter, state.ConstantFunction, 3, state.OriginalConstant3)
				local ok4 = pcall(setter, state.ConstantFunction, 4, state.OriginalConstant4)
				if ok3 and ok4 then
					state.ConstantsPatched = false
					state.ConstantFunction = nil
					state.OriginalConstant3 = nil
					state.OriginalConstant4 = nil
				else
					warn("[CHINO] Modo God: no fue posible restaurar todas las constantes.")
				end
			end
		end
		return true
	end

	state.Enabled = true
	_G.Bypass = true
	local net = SettingsVisual.GodModeGetNet()
	if not net then
		warn("[CHINO] Modo God: no se encontro el modulo Net del juego.")
		return false
	end

	-- El hook se instala UNA sola vez; usa state.Enabled para poder apagarlo.
	if not state.HookReady then
		local hooker = hookfunction
		if type(hooker) == "function" and type(net.send) == "function" then
			local original
			local ok, previous = pcall(function()
				return hooker(net.send, function(...)
					local eventName = select(1, ...)
					if state.Enabled and
						(eventName == "leave_character_creator" or eventName == "player_created_outfit") then
						return nil
					end
					if original then
						return original(...)
					end
				end)
			end)
			if ok and type(previous) == "function" then
				original = previous
				state.HookOriginal = previous
				state.HookNet = net
				state.HookReady = true
			else
				warn("[CHINO] Modo God: no se pudo instalar el hook reversible.")
			end
		else
			warn("[CHINO] Modo God: ejecutor sin hookfunction.")
		end
	end

	-- Nunca escribir constantes sin capturar sus valores originales,
	-- porque el interruptor OFF debe poder restaurarlas.
	if not state.ConstantsPatched then
		local getterUpvalue = getupvalue or (debug and debug.getupvalue)
		local getterConstant = getconstant or (debug and debug.getconstant)
		local setterConstant = setconstant or (debug and debug.setconstant)
		if type(getterUpvalue) == "function" and
			type(getterConstant) == "function" and
			type(setterConstant) == "function" and type(net.get) == "function" then
			local okFn, func = pcall(getterUpvalue, net.get, 2)
			if okFn and type(func) == "function" then
				local ok3, old3 = pcall(getterConstant, func, 3)
				local ok4, old4 = pcall(getterConstant, func, 4)
				if ok3 and ok4 and old3 ~= nil and old4 ~= nil then
					local set3 = pcall(setterConstant, func, 3, "KUYIENGOKUYIENGO")
					local set4 = pcall(setterConstant, func, 4, "KUYIENGOKUYIENGO")
					if set3 and set4 then
						state.ConstantFunction = func
						state.OriginalConstant3 = old3
						state.OriginalConstant4 = old4
						state.ConstantsPatched = true
					else
						if set3 then pcall(setterConstant, func, 3, old3) end
						if set4 then pcall(setterConstant, func, 4, old4) end
					end
				end
			end
		else
			warn("[CHINO] Modo God: falta API para editar/restaurar constantes; esa parte no se aplica.")
		end
	end
	return true
end

-- Reaparicion al cambiar Modo God manualmente en Config (ON y OFF).
-- Ejecuta la misma secuencia de Kill + solicitud de respawn que ya usa
-- el selector inicial. No asume que el servidor deba aceptar la solicitud.
-- Las pulsaciones mientras hay una reaparicion en curso se agrupan en
-- una sola repeticion pendiente para evitar solicitudes superpuestas.
SettingsVisual.GodModeConfigRespawnBusy = false
SettingsVisual.GodModeConfigRespawnPending = false
function SettingsVisual.RequestGodModeConfigRespawn()
	if SettingsVisual.GodModeConfigRespawnBusy then
		SettingsVisual.GodModeConfigRespawnPending = true
		return
	end
	SettingsVisual.GodModeConfigRespawnBusy = true
	task.spawn(function()
		repeat
			SettingsVisual.GodModeConfigRespawnPending = false
			-- Deja terminar la actualizacion del toggle antes de solicitar respawn.
			task.wait(0.2)
			local requestedKill = false
			if type(replicatesignal) == "function" then
				requestedKill = pcall(function()
					replicatesignal(Player.Kill)
				end)
			end
			if not requestedKill then
				-- Alternativa local cuando el ejecutor no dispone de replicatesignal.
				-- El servidor puede ignorar la muerte local.
				pcall(function()
					local char = Player.Character
					local hum = char and char:FindFirstChildOfClass("Humanoid")
					if hum and hum.Health > 0 then hum.Health = 0 end
				end)
			end
			-- Respeta el retraso del selector para que aparezca la pantalla
			-- de reaparicion antes de enviar la solicitud de continuar.
			task.wait(7)
			local ok = pcall(function()
				local net = SettingsVisual.GodModeGetNet()
				if not net or type(net.send) ~= "function" then
					error("modulo Net.send no disponible")
				end
				net.send("death_screen_request_respawn")
			end)
			if not ok then
				warn("[CHINO] Modo God: no fue posible solicitar respawn al servidor.")
			end
			task.wait(0.5)
		until not SettingsVisual.GodModeConfigRespawnPending
		SettingsVisual.GodModeConfigRespawnBusy = false
	end)
end

SettingsVisual.SetGodModeEnabled = MakeToggle(configLeft, "Modo God", false, function(enabled, fromUserTap)
	SettingsVisual.SetGodModeActive(enabled)
	-- Unicamente los toques REALES en el switch de Config activan esta
	-- reaparicion. Elegir Modo God al iniciar ya tiene su propio respawn.
	if fromUserTap then
		SettingsVisual.RequestGodModeConfigRespawn()
	end
end)

-- La antigua acción de respawn ya NO pertenece a la opción "Invisible".
-- Se conserva exclusivamente para el flujo independiente de salida de Anti-Kill,
-- sin encender, apagar ni modificar el interruptor de postura.
SettingsVisual.PerformAntiKillExitRespawn = function()
	task.spawn(function()
		pcall(function()
			if ChinoNet and ChinoNet.send then
				ChinoNet.send("request_respawn")
			end
		end)

		task.wait(6.1)

		pcall(function()
			if ChinoNet and ChinoNet.get then
				ChinoNet.get("death_screen_request_respawn")
			end
		end)

		pcall(function()
			if setfflag then
				setfflag("NextGenReplicatorEnabledWrite4", "true")
			end
		end)
	end)
end

-- CONTROLES DE POSTURA EN LA MISMA FILA (CONFIG):
-- Invisible = activar inclinación del avatar SOLO sentado en vehículo.
-- Giro = ángulo frontal/trasero, editable en móvil con slider o teclado.
-- Se registran en el SaveConfig/LoadConfig original del HUB.
SettingsVisual.TouchCarSeatPoseEnabled = false
SettingsVisual.TouchCarSeatPoseAngle = -101

do
	local poseRow = Instance.new("Frame", configLeft)
	poseRow.Name = "VehicleSeatPoseControls"
	poseRow.Size = UDim2.new(1, 0, 0, 42)
	poseRow.BackgroundTransparency = 1
	poseRow.BorderSizePixel = 0
	poseRow.ZIndex = 8

	local switchSide = Instance.new("Frame", poseRow)
	switchSide.Name = "InvisibleSwitchSide"
	switchSide.Size = UDim2.new(0.43, -2, 1, 0)
	switchSide.BackgroundTransparency = 1
	switchSide.BorderSizePixel = 0
	switchSide.ZIndex = 8

	local sliderSide = Instance.new("Frame", poseRow)
	sliderSide.Name = "AngleSliderSide"
	sliderSide.Position = UDim2.new(0.43, 2, 0, 0)
	sliderSide.Size = UDim2.new(0.57, -2, 1, 0)
	sliderSide.BackgroundTransparency = 1
	sliderSide.BorderSizePixel = 0
	sliderSide.ZIndex = 8

	SettingsVisual.SetInvisibleOption = MakeToggle(switchSide, "Invisible", false, function(enabled)
		SettingsVisual.TouchCarSeatPoseEnabled = enabled == true
		if SettingsVisual.TouchCarSeatPoseEnabled then
			if SettingsVisual.TouchCarApplySeatPose then
				task.defer(SettingsVisual.TouchCarApplySeatPose)
			end
		elseif SettingsVisual.TouchCarRestoreSeatPose then
			SettingsVisual.TouchCarRestoreSeatPose()
		end
	end)

	SettingsVisual.SetTouchCarPoseAngle = MakeSlider(sliderSide, "Giro", -101, -120, 120, function(angle)
		SettingsVisual.TouchCarSeatPoseAngle = math.clamp(tonumber(angle) or -101, -120, 120)
		if SettingsVisual.TouchCarSeatPoseEnabled and SettingsVisual.TouchCarApplySeatPose then
			SettingsVisual.TouchCarApplySeatPose()
		end
	end)
end

-- Toggle sin título: Auto Respawn directo al ítem tirado más cercano (sin cambios).
MakeToggle(configLeft, "", false, function(v)
	SettingsVisual.AutoRespawnItemsEnabled = v and true or false
	if not v then
		SettingsVisual.AutoRespawnItemsBusy = false
	end
end)

-- Optimizar FPS visible al inicio de Config (columna derecha).


-- NPC PHASE PARA VEHÍCULO:
-- Wallhack puede atravesar NPCs sin volverlos noclip contra el piso.
-- Se usan NoCollisionConstraint SOLO entre tu carro y NPCs cercanos.
SettingsVisual.VehicleNPCPhaseEnabled = false
SettingsVisual.VehicleNPCPhaseRunning = false
SettingsVisual.VehicleNPCConstraintMap = setmetatable({}, {__mode = "k"})
SettingsVisual.VehicleNPCPhaseRadius = 48

SettingsVisual.StartVehicleNPCPhase = function()
	if SettingsVisual.VehicleNPCPhaseRunning then return end
	SettingsVisual.VehicleNPCPhaseRunning = true

	task.spawn(function()
		local function getOwnVehicle()
			local char = Player.Character
			local hum = char and char:FindFirstChildOfClass("Humanoid")
			local seat = hum and hum.SeatPart
			if not seat then return nil, nil end

			local vehicle = seat:FindFirstAncestorOfClass("Model")
			if not vehicle then return nil, nil end

			local root = vehicle.PrimaryPart or seat.AssemblyRootPart or seat
			if root and root:IsA("BasePart") then
				root = root.AssemblyRootPart or root
			end
			return vehicle, root
		end

		local function isNPCModel(model)
			if not model or not model:IsA("Model") then return false end
			local hum = model:FindFirstChildOfClass("Humanoid")
			if not hum then return false end
			if Players:GetPlayerFromCharacter(model) then return false end
			return true
		end

		local function cleanupAll()
			for carPart, npcMap in pairs(SettingsVisual.VehicleNPCConstraintMap) do
				for npcPart, constraint in pairs(npcMap) do
					if constraint then pcall(function() constraint:Destroy() end) end
					npcMap[npcPart] = nil
				end
				SettingsVisual.VehicleNPCConstraintMap[carPart] = nil
			end
		end

		while SettingsVisual.VehicleNPCPhaseEnabled do
			local vehicle, root = getOwnVehicle()
			if not vehicle or not root then
				cleanupAll()
				task.wait(0.15)
				continue
			end

			local carParts = {}
			for _, obj in ipairs(vehicle:GetDescendants()) do
				if obj:IsA("BasePart") and obj.CanCollide then
					table.insert(carParts, obj)
				end
			end

			local params = OverlapParams.new()
			params.FilterType = Enum.RaycastFilterType.Exclude
			params.FilterDescendantsInstances = {vehicle, Player.Character}
			params.MaxParts = 500

			local nearby = {}
			pcall(function()
				nearby = workspace:GetPartBoundsInRadius(
					root.Position,
					tonumber(SettingsVisual.VehicleNPCPhaseRadius) or 48,
					params
				)
			end)

			local npcModels = {}
			for _, part in ipairs(nearby) do
				local model = part:FindFirstAncestorOfClass("Model")
				if isNPCModel(model) then
					npcModels[model] = true
				end
			end

			local seen = {}
			for npcModel in pairs(npcModels) do
				for _, npcPart in ipairs(npcModel:GetDescendants()) do
					if npcPart:IsA("BasePart") and npcPart.CanCollide then
						for _, carPart in ipairs(carParts) do
							seen[carPart] = seen[carPart] or setmetatable({}, {__mode = "k"})
							seen[carPart][npcPart] = true

							local npcMap = SettingsVisual.VehicleNPCConstraintMap[carPart]
							if not npcMap then
								npcMap = setmetatable({}, {__mode = "k"})
								SettingsVisual.VehicleNPCConstraintMap[carPart] = npcMap
							end

							local constraint = npcMap[npcPart]
							if not constraint or not constraint.Parent then
								constraint = Instance.new("NoCollisionConstraint")
								constraint.Name = "CHINO_NPC_Phase"
								constraint.Part0 = carPart
								constraint.Part1 = npcPart
								constraint.Parent = vehicle
								npcMap[npcPart] = constraint
							end
						end
					end
				end
			end

			for carPart, npcMap in pairs(SettingsVisual.VehicleNPCConstraintMap) do
				for npcPart, constraint in pairs(npcMap) do
					if not seen[carPart] or not seen[carPart][npcPart]
						or not carPart.Parent or not npcPart.Parent then
						if constraint then pcall(function() constraint:Destroy() end) end
						npcMap[npcPart] = nil
					end
				end
			end

			task.wait(0.12)
		end

		cleanupAll()
		SettingsVisual.VehicleNPCPhaseRunning = false
	end)
end

SettingsVisual.SetVehicleNPCPhase = function(enabled)
	SettingsVisual.VehicleNPCPhaseEnabled = enabled == true
	if SettingsVisual.VehicleNPCPhaseEnabled then
		SettingsVisual.StartVehicleNPCPhase()
	end
end

-- WALLHACK local: cambia colisión/query de geometría estática.
-- Al apagarlo restaura varias veces el snapshot original para evitar
-- que alguna pared se quede sin colisión después del toggle.
do
	SettingsVisual.WorldPhaseEnabled = false
	SettingsVisual.WorldPhaseOriginal = {}
	SettingsVisual.WorldPhaseGeneration = 0

	local function isInsideCharacterOrVehicle(part)
		for _, plr in ipairs(Players:GetPlayers()) do
			local char = plr.Character
			if char and part:IsDescendantOf(char) then
				return true
			end
		end

		local model = part:FindFirstAncestorOfClass("Model")
		if model then
			if model:FindFirstChildOfClass("Humanoid") then
				return true
			end
			if model:FindFirstChildWhichIsA("VehicleSeat", true) then
				return true
			end
		end

		return false
	end

	local function isProtectedGround(part)
		local n = string.lower(part.Name or "")

		if n:find("ground")
			or n:find("floor")
			or n:find("road")
			or n:find("street")
			or n:find("baseplate")
			or n:find("asphalt")
			or n:find("terrain") then
			return true
		end

		if part.Size.Y <= 2
			and part.Size.X >= 35
			and part.Size.Z >= 35 then
			return true
		end

		return false
	end

	local function canPhasePart(part)
		if not part:IsA("BasePart") then
			return false
		end
		if not part.Anchored then
			return false
		end
		if isInsideCharacterOrVehicle(part) or isProtectedGround(part) then
			return false
		end

		local dropped = workspace:FindFirstChild("DroppedItems")
			or workspace:FindFirstChild("DroppedItem")

		if dropped and part:IsDescendantOf(dropped) then
			return false
		end

		return true
	end

	local function applyPhaseToPart(part)
		if not SettingsVisual.WorldPhaseEnabled or not canPhasePart(part) then
			return
		end

		if not SettingsVisual.WorldPhaseOriginal[part] then
			SettingsVisual.WorldPhaseOriginal[part] = {
				CanCollide = part.CanCollide,
				CanTouch = part.CanTouch,
				CanQuery = part.CanQuery,
			}
		end

		pcall(function()
			part.CanCollide = false
			part.CanTouch = false
			part.CanQuery = false
		end)
	end

	local function restoreWorldPhase(clearAfter)
		for part, original in pairs(SettingsVisual.WorldPhaseOriginal) do
			if part and part.Parent and original then
				pcall(function()
					part.CanCollide = original.CanCollide
					part.CanTouch = original.CanTouch
					part.CanQuery = original.CanQuery
				end)
			end

			if clearAfter then
				SettingsVisual.WorldPhaseOriginal[part] = nil
			end
		end
	end

	local function setWorldPhase(enabled)
		SettingsVisual.WorldPhaseGeneration += 1
		local generation = SettingsVisual.WorldPhaseGeneration
		SettingsVisual.WorldPhaseEnabled = enabled and true or false

		if SettingsVisual.WorldPhaseEnabled then
			for _, obj in ipairs(workspace:GetDescendants()) do
				applyPhaseToPart(obj)
			end
		else
			-- Restauración inmediata + dos repasos de física.
			restoreWorldPhase(false)

			task.defer(function()
				if generation == SettingsVisual.WorldPhaseGeneration
					and not SettingsVisual.WorldPhaseEnabled then
					restoreWorldPhase(false)
				end
			end)

			task.delay(0.20, function()
				if generation == SettingsVisual.WorldPhaseGeneration
					and not SettingsVisual.WorldPhaseEnabled then
					restoreWorldPhase(true)
				end
			end)
		end
	end

	SettingsVisual.SetWorldPhase = setWorldPhase

	if not SettingsVisual.WorldPhaseDescendantConnection then
		SettingsVisual.WorldPhaseDescendantConnection =
			workspace.DescendantAdded:Connect(function(obj)
				if SettingsVisual.WorldPhaseEnabled then
					task.defer(function()
						applyPhaseToPart(obj)
					end)
				end
			end)
	end

	-- Aviso premium de seguridad de uso: el PRIMER toque no activa Wallhack.
	-- Después de pulsar OK, el siguiente toque ya puede activarlo normalmente.
	SettingsVisual.WallhackWarningAcknowledged = false
	SettingsVisual.ShowWallhackWarning = function()
		if SettingsVisual.WallhackWarningOverlay and SettingsVisual.WallhackWarningOverlay.Parent then
			SettingsVisual.WallhackWarningOverlay.Visible = true
			return
		end

		local overlay = Instance.new("Frame")
		overlay.Name = "WallhackWarningOverlay"
		overlay.Size = UDim2.fromScale(1, 1)
		overlay.Position = UDim2.fromScale(0, 0)
		overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		overlay.BackgroundTransparency = 0.38
		overlay.BorderSizePixel = 0
		overlay.ZIndex = 10000
		overlay.Parent = Gui
		SettingsVisual.WallhackWarningOverlay = overlay

		local box = Instance.new("Frame")
		box.AnchorPoint = Vector2.new(0.5, 0.5)
		box.Position = UDim2.fromScale(0.5, 0.5)
		box.Size = UDim2.fromOffset(300, 154)
		box.BackgroundColor3 = Color3.fromRGB(8, 14, 24)
		box.BackgroundTransparency = 0.10
		box.BorderSizePixel = 0
		box.ZIndex = 10001
		box.Parent = overlay
		Instance.new("UICorner", box).CornerRadius = UDim.new(0, 18)

		local stroke = Instance.new("UIStroke")
		stroke.Color = COLORS.Blue
		stroke.Transparency = 0.20
		stroke.Thickness = 1.35
		stroke.Parent = box

		local title = Instance.new("TextLabel")
		title.Size = UDim2.new(1, -28, 0, 28)
		title.Position = UDim2.new(0, 14, 0, 13)
		title.BackgroundTransparency = 1
		title.Text = "⚠  WALLHACK • AVISO"
		title.TextColor3 = COLORS.White
		title.TextSize = 15
		title.Font = Enum.Font.GothamBold
		title.TextXAlignment = Enum.TextXAlignment.Center
		title.ZIndex = 10002
		title.Parent = box

		local message = Instance.new("TextLabel")
		message.Size = UDim2.new(1, -34, 0, 52)
		message.Position = UDim2.new(0, 17, 0, 48)
		message.BackgroundTransparency = 1
		message.Text = "Antes de activar Wallhack, súbete primero a tu vehículo.\nDespués pulsa OK y vuelve a activar la opción."
		message.TextColor3 = Color3.fromRGB(195, 214, 238)
		message.TextSize = 11
		message.Font = Enum.Font.GothamMedium
		message.TextWrapped = true
		message.TextXAlignment = Enum.TextXAlignment.Center
		message.TextYAlignment = Enum.TextYAlignment.Center
		message.ZIndex = 10002
		message.Parent = box

		local okButton = Instance.new("TextButton")
		okButton.AnchorPoint = Vector2.new(0.5, 1)
		okButton.Position = UDim2.new(0.5, 0, 1, -14)
		okButton.Size = UDim2.fromOffset(104, 30)
		okButton.BackgroundColor3 = COLORS.Blue
		okButton.BackgroundTransparency = 0.16
		okButton.BorderSizePixel = 0
		okButton.Text = "OK"
		okButton.TextColor3 = COLORS.White
		okButton.TextSize = 12
		okButton.Font = Enum.Font.GothamBold
		okButton.AutoButtonColor = true
		okButton.ZIndex = 10002
		okButton.Parent = box
		Instance.new("UICorner", okButton).CornerRadius = UDim.new(0, 9)

		okButton.Activated:Connect(function()
			SettingsVisual.WallhackWarningAcknowledged = true
			overlay.Visible = false
		end)
	end

	SettingsVisual.SetWallhackToggle = MakeToggle(configLeft, "Wallhack", false, function(v)
		if v and not SettingsVisual.WallhackWarningAcknowledged then
			-- Primer toque: NO se activa. El toggle vuelve a OFF y solo aparece el aviso.
			setWorldPhase(false)
			if SettingsVisual.SetVehicleNPCPhase then
				SettingsVisual.SetVehicleNPCPhase(false)
			end

			task.defer(function()
				if SettingsVisual.SetWallhackToggle then
					SettingsVisual.SetWallhackToggle(false)
				end
			end)

			SettingsVisual.ShowWallhackWarning()
			return
		end

		setWorldPhase(v)
		if SettingsVisual.SetVehicleNPCPhase then
			SettingsVisual.SetVehicleNPCPhase(v)
		end
	end)
end

MakeToggle(configLeft, "Bullet", false, function(v)
	SettingsVisual.BulletEnabled = v and true or false
end)

-- Theme premium: recolorea acentos, fondos transparentes y orbes.
SettingsVisual.ThemeBaseBackgrounds = SettingsVisual.ThemeBaseBackgrounds or setmetatable({}, {__mode = "k"})
SettingsVisual.ThemeOrbHolders = SettingsVisual.ThemeOrbHolders or {}

SettingsVisual.ApplyThemeColor = function(newColor)
	if typeof(newColor) ~= "Color3" then return end

	local oldColor = COLORS.Blue
	local oldBright = COLORS.BlueBright
	local newBright = newColor:Lerp(Color3.new(1, 1, 1), 0.24)
	local h = select(1, newColor:ToHSV())

	-- Contraste fuerte: azul produce rojo/negro; otros tonos obtienen
	-- una pareja opuesta y un negro tintado.
	local contrast = Color3.fromHSV((h + 0.45) % 1, 1, 1)
	local adjacent = Color3.fromHSV((h + 0.10) % 1, 1, 1)
	local darkTint = newColor:Lerp(Color3.new(0, 0, 0), 0.88)

	COLORS.Blue = newColor
	COLORS.BlueBright = newBright
	SettingsVisual.ThemeColor = newColor
	SettingsVisual.ThemeBright = newBright

	DYNAMIC_CYCLE[1] = newBright
	DYNAMIC_CYCLE[2] = newColor
	DYNAMIC_CYCLE[3] = contrast
	DYNAMIC_CYCLE[4] = darkTint

	for _, obj in ipairs(Main:GetDescendants()) do
		pcall(function()
			if obj:IsA("GuiObject") then
				local wasAccent = obj.BackgroundColor3 == oldColor
					or obj.BackgroundColor3 == oldBright

				if wasAccent then
					obj.BackgroundColor3 = obj.BackgroundColor3 == oldBright and newBright or newColor
				elseif obj.BackgroundTransparency < 0.98 then
					local base = SettingsVisual.ThemeBaseBackgrounds[obj]
					if not base then
						base = obj.BackgroundColor3
						SettingsVisual.ThemeBaseBackgrounds[obj] = base
					end

					-- Solo vidrio/controles oscuros; evita teñir blancos e imágenes.
					if (base.R + base.G + base.B) <= 1.20 then
						local strength = math.clamp(0.18 + obj.BackgroundTransparency * 0.20, 0.18, 0.36)
						obj.BackgroundColor3 = base:Lerp(newColor, strength)
					end
				end
			end

			if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
				if obj.TextColor3 == oldColor then
					obj.TextColor3 = newColor
				elseif obj.TextColor3 == oldBright then
					obj.TextColor3 = newBright
				end
			end

			if obj:IsA("UIStroke") then
				if obj.Color == oldColor or obj.Color == oldBright then
					obj.Color = newColor
				end
			elseif obj:IsA("ScrollingFrame") then
				if obj.ScrollBarImageColor3 == oldColor or obj.ScrollBarImageColor3 == oldBright then
					obj.ScrollBarImageColor3 = newColor
				end
			end
		end)
	end

	-- Orbes: cada uno toma un color distinto de una combinación coherente.
	local orbPalette = {newBright, contrast, darkTint, newColor, darkTint, adjacent, contrast, newColor}
	SettingsVisual.ActiveOrbPalette = orbPalette
	for i, holder in ipairs(SettingsVisual.ThemeOrbHolders or {}) do
		if holder and holder.Parent then
			local orbColor = orbPalette[((i - 1) % #orbPalette) + 1]
			for _, desc in ipairs(holder:GetDescendants()) do
				if desc:IsA("Frame") and desc.BackgroundTransparency < 1 then
					desc.BackgroundColor3 = orbColor
				end
			end
		end
	end

	if SettingsVisual.ThemeAmbient and SettingsVisual.ThemeAmbient.Parent then
		SettingsVisual.ThemeAmbient.BackgroundColor3 = darkTint:Lerp(newColor, 0.18)
	end
	if SettingsVisual.ThemeFrost and SettingsVisual.ThemeFrost.Parent then
		SettingsVisual.ThemeFrost.BackgroundColor3 = darkTint:Lerp(newColor, 0.12)
	end
	if SettingsVisual.ThemeFog1 and SettingsVisual.ThemeFog1.Parent then
		SettingsVisual.ThemeFog1.ImageColor3 = contrast
	end
	if SettingsVisual.ThemeFog2 and SettingsVisual.ThemeFog2.Parent then
		SettingsVisual.ThemeFog2.ImageColor3 = newColor
	end

	pcall(function() Sanchito.Color = Color3.fromRGB(255, 255, 255) end)
end
SettingsVisual.ThemeColor = COLORS.Blue
SettingsVisual.ThemeBright = COLORS.BlueBright

do
	local row = Instance.new("Frame", configRight)
	row.Size = UDim2.new(1, 0, 0, 44)
	row.BackgroundColor3 = Color3.fromRGB(20, 24, 38)
	row.BackgroundTransparency = 0.68
	row.BorderSizePixel = 0
	row.ZIndex = 8
	Instance.new("UICorner", row).CornerRadius = UDim.new(0, 7)

	local label = Instance.new("TextLabel", row)
	label.Size = UDim2.new(0, 82, 0, 16)
	label.Position = UDim2.new(0, 8, 0, 3)
	label.BackgroundTransparency = 1
	label.Text = "Color Panel"
	label.TextColor3 = COLORS.White
	label.TextSize = 10
	label.Font = Enum.Font.Gotham
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.ZIndex = 9

	local bar = Instance.new("Frame", row)
	bar.Size = UDim2.new(1, -16, 0, 12)
	bar.Position = UDim2.new(0, 8, 0, 24)
	bar.BackgroundColor3 = Color3.new(1, 1, 1)
	bar.BorderSizePixel = 0
	bar.Active = true
	bar.ZIndex = 9
	Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)

	SettingsVisual.NeonThemeColors = {
		Color3.fromRGB(255, 20, 75),
		Color3.fromRGB(255, 95, 0),
		Color3.fromRGB(225, 255, 0),
		Color3.fromRGB(0, 255, 90),
		Color3.fromRGB(0, 255, 245),
		Color3.fromRGB(25, 95, 255),
		Color3.fromRGB(155, 25, 255),
		Color3.fromRGB(255, 0, 180)
	}

	local gradient = Instance.new("UIGradient", bar)
	gradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0.00, SettingsVisual.NeonThemeColors[1]),
		ColorSequenceKeypoint.new(0.14, SettingsVisual.NeonThemeColors[2]),
		ColorSequenceKeypoint.new(0.28, SettingsVisual.NeonThemeColors[3]),
		ColorSequenceKeypoint.new(0.42, SettingsVisual.NeonThemeColors[4]),
		ColorSequenceKeypoint.new(0.56, SettingsVisual.NeonThemeColors[5]),
		ColorSequenceKeypoint.new(0.70, SettingsVisual.NeonThemeColors[6]),
		ColorSequenceKeypoint.new(0.84, SettingsVisual.NeonThemeColors[7]),
		ColorSequenceKeypoint.new(1.00, SettingsVisual.NeonThemeColors[8])
	})

	local marker = Instance.new("Frame", bar)
	marker.Size = UDim2.fromOffset(10, 18)
	marker.AnchorPoint = Vector2.new(0.5, 0.5)
	marker.Position = UDim2.fromScale(0.58, 0.5)
	marker.BackgroundColor3 = COLORS.White
	marker.BackgroundTransparency = 0.08
	marker.BorderSizePixel = 0
	marker.ZIndex = 10
	Instance.new("UICorner", marker).CornerRadius = UDim.new(1, 0)

	local dragging = false
	local dragInput = nil
	local function setFromX(x)
		local pos = math.clamp((x - bar.AbsolutePosition.X) / math.max(bar.AbsoluteSize.X, 1), 0, 1)
		marker.Position = UDim2.fromScale(pos, 0.5)

		local colors = SettingsVisual.NeonThemeColors
		local scaled = pos * (#colors - 1)
		local index = math.floor(scaled) + 1
		local alpha = scaled - math.floor(scaled)
		local a = colors[math.clamp(index, 1, #colors)]
		local b = colors[math.clamp(index + 1, 1, #colors)]
		SettingsVisual.ApplyThemeColor(a:Lerp(b, alpha))
	end

	bar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragInput = input
			setFromX(input.Position.X)
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if not dragging then return end
		if dragInput and dragInput.UserInputType == Enum.UserInputType.Touch then
			if input == dragInput then setFromX(input.Position.X) end
		elseif input.UserInputType == Enum.UserInputType.MouseMovement then
			setFromX(input.Position.X)
		end
	end)
	UserInputService.InputEnded:Connect(function(input)
		if input == dragInput or input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
			dragInput = nil
		end
	end)
end

SettingsVisual.SaveConfigToggle = MakeToggle(configRight, "Guardar Config", false, function(v)
	if v then
		local saved = SettingsVisual.SaveConfig and SettingsVisual.SaveConfig()
		task.delay(0.15, function()
			if SettingsVisual.SaveConfigToggle then SettingsVisual.SaveConfigToggle(false) end
		end)
		if saved then print("✅ Config guardada") else warn("⚠️ No se pudo guardar la config") end
	end
end)

SettingsVisual.ResetConfigToggle = MakeToggle(configRight, "Reset Config", false, function(v)
	if v then
		if SettingsVisual.ResetConfig then SettingsVisual.ResetConfig() end
		task.delay(0.15, function()
			if SettingsVisual.ResetConfigToggle then SettingsVisual.ResetConfigToggle(false) end
		end)
	end
end)

-- TP ITEMS
do
	local controlRow = Instance.new("Frame", ArmasScroll)
	controlRow.Name = "FlingTPControl"
	controlRow.Size = UDim2.new(1, -8, 0, 30)
	controlRow.Position = UDim2.new(0, 4, 0, 2)
	controlRow.BackgroundColor3 = Color3.fromRGB(20, 24, 38)
	controlRow.BackgroundTransparency = 0.72
	controlRow.BorderSizePixel = 0
	controlRow.ZIndex = 12
	Instance.new("UICorner", controlRow).CornerRadius = UDim.new(0, 7)

	local label = Instance.new("TextLabel", controlRow)
	label.Size = UDim2.new(1, -42, 1, 0)
	label.Position = UDim2.new(0, 8, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = "Fling TP"
	label.TextColor3 = COLORS.White
	label.TextSize = 10
	label.Font = Enum.Font.Gotham
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.ZIndex = 13

	local check = Instance.new("TextButton", controlRow)
	check.Size = UDim2.fromOffset(18, 18)
	check.Position = UDim2.new(1, -26, 0.5, -9)
	check.BackgroundColor3 = Color3.fromRGB(28, 31, 42)
	check.BackgroundTransparency = 0.35
	check.BorderSizePixel = 0
	check.Text = ""
	check.TextColor3 = COLORS.White
	check.TextSize = 13
	check.Font = Enum.Font.GothamBold
	check.ZIndex = 13
	Instance.new("UICorner", check).CornerRadius = UDim.new(0, 4)

	local flingGui = Instance.new("ScreenGui")
	flingGui.Name = "CHINO_FlingTPSwitch"
	flingGui.ResetOnSpawn = false
	flingGui.IgnoreGuiInset = true
	flingGui.DisplayOrder = 999997
	flingGui.Enabled = false
	flingGui.Parent = SettingsVisual.ExecutorGuiParent or PlayerGui

	local switchBg = Instance.new("Frame", flingGui)
	switchBg.Size = UDim2.fromOffset(44, 24)
	switchBg.Position = UDim2.new(0.04, 0, 0.72, 0)
	switchBg.BackgroundColor3 = Color3.fromRGB(32, 35, 45)
	switchBg.BackgroundTransparency = 0.22
	switchBg.BorderSizePixel = 0
	switchBg.Active = true
	switchBg.Draggable = true
	switchBg.ZIndex = 100
	Instance.new("UICorner", switchBg).CornerRadius = UDim.new(1, 0)

	local knob = Instance.new("Frame", switchBg)
	knob.Size = UDim2.fromOffset(18, 18)
	knob.Position = UDim2.new(0, 3, 0.5, -9)
	knob.BackgroundColor3 = Color3.fromRGB(245, 247, 255)
	knob.BorderSizePixel = 0
	knob.ZIndex = 101
	Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

	local hit = Instance.new("TextButton", switchBg)
	hit.Size = UDim2.fromScale(1, 1)
	hit.BackgroundTransparency = 1
	hit.Text = ""
	hit.ZIndex = 102

	check.Activated:Connect(function()
		SettingsVisual.FlingTPPanelEnabled = not SettingsVisual.FlingTPPanelEnabled
		check.Text = SettingsVisual.FlingTPPanelEnabled and "×" or ""
		check.BackgroundColor3 = SettingsVisual.FlingTPPanelEnabled and COLORS.Blue or Color3.fromRGB(28, 31, 42)
		flingGui.Enabled = SettingsVisual.FlingTPPanelEnabled
	end)

	hit.Activated:Connect(function()
		if not SettingsVisual.FlingTPPanelEnabled or not DroppedItems then return end
		TweenService:Create(switchBg, TweenInfo.new(0.16), {BackgroundColor3 = COLORS.Blue}):Play()
		TweenService:Create(knob, TweenInfo.new(0.16), {Position = UDim2.new(1, -21, 0.5, -9)}):Play()

		local char = Player.Character
		local root = char and char:FindFirstChild("HumanoidRootPart")
		if root then
			local bestPart, bestDist = nil, math.huge
			for _, item in ipairs(DroppedItems:GetChildren()) do
				if item:IsA("Model") then
					local part = item:FindFirstChild("PickUpZone", true)
					if part and not part:IsA("BasePart") then part = nil end
					part = part or item.PrimaryPart or item:FindFirstChildWhichIsA("BasePart", true)
					if part then
						local dist = (part.Position - root.Position).Magnitude
						if dist < bestDist then bestPart, bestDist = part, dist end
					end
				end
			end
			if bestPart then
				local delta = bestPart.Position - root.Position
				if delta.Magnitude > 0.1 then
					local power = math.clamp(bestDist * 2.1, 105, 225)
					root.AssemblyLinearVelocity = delta.Unit * power + Vector3.new(0, 48, 0)
					root.AssemblyAngularVelocity = Vector3.new(5, 0, 4)
				end
			end
		end

		task.delay(0.42, function()
			if switchBg and switchBg.Parent then
				TweenService:Create(switchBg, TweenInfo.new(0.16), {BackgroundColor3 = Color3.fromRGB(32, 35, 45)}):Play()
				TweenService:Create(knob, TweenInfo.new(0.16), {Position = UDim2.new(0, 3, 0.5, -9)}):Play()
			end
		end)
	end)
end

local LiveArmasContainer = Instance.new("ScrollingFrame", ArmasScroll)
LiveArmasContainer.Position = UDim2.new(0, 0, 0, 36)
LiveArmasContainer.Size = UDim2.new(1, 0, 1, -36)
LiveArmasContainer.BackgroundTransparency = 1
LiveArmasContainer.BorderSizePixel = 0
LiveArmasContainer.ScrollBarThickness = 3
LiveArmasContainer.ScrollBarImageColor3 = COLORS.Blue

local LiveArmasLayout = Instance.new("UIListLayout", LiveArmasContainer)
LiveArmasLayout.Padding = UDim.new(0, 6)
LiveArmasLayout.SortOrder = Enum.SortOrder.LayoutOrder

LiveArmasLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	LiveArmasContainer.CanvasSize = UDim2.new(0, 0, 0, LiveArmasLayout.AbsoluteContentSize.Y + 16)
end)

task.spawn(function()
	-- Cache local de filas: evita destruir el botón mientras el dedo lo está tocando.
	local rowCache = {}

	while Gui and Gui.Parent do
		task.wait(0.35)

		if DroppedItems then
			-- Elimina únicamente filas cuyos ítems ya desaparecieron.
			for itemObj, row in pairs(rowCache) do
				if not itemObj or itemObj.Parent ~= DroppedItems then
					if row and row.Parent then row:Destroy() end
					rowCache[itemObj] = nil
				end
			end

			for _, itemObj in ipairs(DroppedItems:GetChildren()) do
				if itemObj:IsA("Model") and not rowCache[itemObj] then
					local itemName = itemObj.Name
					local rarity = itemObj:GetAttribute("RarityName") or "Common"
					local rarityColor = RarityColors[rarity] or Color3.fromRGB(255, 255, 255)

                    local iconId = ""
					pcall(function()
						for _, desc in ipairs(itemObj:GetDescendants()) do
							if desc:IsA("Tool") then
								local wData = getWeaponData(desc)
								if wData and wData.ImageId then
									iconId = wData.ImageId
									break
								end
							end
						end
					end)

					local row = Instance.new("Frame", LiveArmasContainer)
					row.Size = UDim2.new(1, 0, 0, 42)
					row.BackgroundColor3 = Color3.fromRGB(20, 24, 38)
					row.BackgroundTransparency = 0.5
					Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)

					local itemImg = Instance.new("ImageLabel", row)
					itemImg.Size = UDim2.new(0, 32, 0, 32)
					itemImg.Position = UDim2.new(0, 6, 0.5, -16)
					itemImg.BackgroundColor3 = Color3.fromRGB(15, 18, 25)
					itemImg.BackgroundTransparency = 0.3
					itemImg.Image = iconId
					Instance.new("UICorner", itemImg).CornerRadius = UDim.new(0, 6)

					local imgStroke = Instance.new("UIStroke", itemImg)
					imgStroke.Color = rarityColor
					imgStroke.Thickness = 1.5

					local nameLbl = Instance.new("TextLabel", row)
					nameLbl.Size = UDim2.new(0, 130, 0, 18)
					nameLbl.Position = UDim2.new(0, 46, 0, 4)
					nameLbl.BackgroundTransparency = 1
					nameLbl.Text = itemName
					nameLbl.TextColor3 = COLORS.White
					nameLbl.TextSize = 11
					nameLbl.Font = Enum.Font.GothamBold
					nameLbl.TextXAlignment = Enum.TextXAlignment.Left

					local rarityLbl = Instance.new("TextLabel", row)
					rarityLbl.Size = UDim2.new(0, 130, 0, 14)
					rarityLbl.Position = UDim2.new(0, 46, 0, 22)
					rarityLbl.BackgroundTransparency = 1
					rarityLbl.Text = "Rareza: " .. rarity
					rarityLbl.TextColor3 = rarityColor
					rarityLbl.TextSize = 9
					rarityLbl.Font = Enum.Font.GothamMedium
					rarityLbl.TextXAlignment = Enum.TextXAlignment.Left

					local tpBtn = Instance.new("TextButton", row)
					tpBtn.Size = UDim2.new(0, 55, 0, 26)
					tpBtn.Position = UDim2.new(1, -62, 0.5, -13)
					tpBtn.BackgroundColor3 = COLORS.Blue
					tpBtn.BackgroundTransparency = 0.56
					tpBtn.Text = "TP Ítem"
					tpBtn.TextColor3 = COLORS.White
					tpBtn.TextSize = 10
					tpBtn.Font = Enum.Font.GothamBold
					tpBtn.AutoButtonColor = true
					Instance.new("UICorner", tpBtn).CornerRadius = UDim.new(0, 6)

					-- TP robusto para touch/mouse y distintos tipos de PickUpZone.
					tpBtn.ZIndex = 6
					tpBtn.Active = true
					tpBtn.Selectable = true
					tpBtn.Activated:Connect(function()
						local char = Player.Character
						local root = char and char:FindFirstChild("HumanoidRootPart")
						local pickup = itemObj:FindFirstChild("PickUpZone", true)
						local targetPos = nil

						if pickup then
							if pickup:IsA("BasePart") then
								targetPos = pickup.Position
							elseif pickup:IsA("Attachment") then
								targetPos = pickup.WorldPosition
							end
						end

						if not targetPos and itemObj.PrimaryPart then
							targetPos = itemObj.PrimaryPart.Position
						end

						if not targetPos then
							local anyPart = itemObj:FindFirstChildWhichIsA("BasePart", true)
							if anyPart then targetPos = anyPart.Position end
						end

						if not targetPos then
							pcall(function() targetPos = itemObj:GetPivot().Position end)
						end

						if char and root and targetPos and itemObj:IsDescendantOf(DroppedItems) then
							task.spawn(function()
								local oldPivot = char:GetPivot()
								local rotationOnly = oldPivot - oldPivot.Position
								local destination = CFrame.new(targetPos + Vector3.new(0, 0.9, 0)) * rotationOnly
								local started = os.clock()
								local lastPickupTry = 0

								-- Durante un segundo mantenemos el personaje pegado al item.
								-- Ademas usamos el mismo RemoteFunction real del Auto Pickup para
								-- para solicitar la recogida mientras permaneces dentro de la zona del item.
								while os.clock() - started < 1.8 and itemObj and itemObj.Parent == DroppedItems do
									if not char.Parent or not root.Parent then break end
									char:PivotTo(destination)
									root.AssemblyLinearVelocity = Vector3.zero
									root.AssemblyAngularVelocity = Vector3.zero

									if os.clock() - lastPickupTry >= 0.10 and itemObj and itemObj.Parent == DroppedItems then
										lastPickupTry = os.clock()
										pcall(function() NetGet("pickup_dropped_item", itemObj) end)
									end

									RunService.Heartbeat:Wait()
								end

								-- Regresa exactamente al lugar desde donde hiciste TP.
								if char.Parent and root.Parent then
									for _ = 1, 2 do
										char:PivotTo(oldPivot)
										root.AssemblyLinearVelocity = Vector3.zero
										root.AssemblyAngularVelocity = Vector3.zero
										RunService.Heartbeat:Wait()
									end
								end
							end)
						end
					end)

					rowCache[itemObj] = row
				end
			end
		end
	end
end)

-- ========================================================--
-- PANEL TÁCTIL Y GHOST
-- ========================================================--
local TouchPanelGui = Instance.new("ScreenGui", SettingsVisual.ExecutorGuiParent or CoreGui)
TouchPanelGui.Name = "TouchPanelGui"
TouchPanelGui.Enabled = false

local TouchCard = Instance.new("Frame", TouchPanelGui)
TouchCard.Size = UDim2.new(0, 150, 0, 143)
TouchCard.Position = UDim2.new(0.04, 0, 0.42, 0)
TouchCard.BackgroundColor3 = COLORS.Glass
TouchCard.BackgroundTransparency = 0.35
TouchCard.BorderSizePixel = 0
TouchCard.Active = true
TouchCard.Draggable = true
Instance.new("UICorner", TouchCard).CornerRadius = UDim.new(0, 14)
TouchCard.ClipsDescendants = true

-- Misma foto del botón principal, usada como fondo del panel táctil.
SettingsVisual.TouchPanelPhoto = Instance.new("ImageLabel", TouchCard)
SettingsVisual.TouchPanelPhoto.Name = "PanelPhoto"
SettingsVisual.TouchPanelPhoto.Size = UDim2.new(1, 0, 1, 0)
SettingsVisual.TouchPanelPhoto.Position = UDim2.new(0, 0, 0, 0)
SettingsVisual.TouchPanelPhoto.BackgroundTransparency = 1
SettingsVisual.TouchPanelPhoto.Image = "rbxassetid://105275560374583"
SettingsVisual.TouchPanelPhoto.ImageTransparency = 0.68
SettingsVisual.TouchPanelPhoto.ScaleType = Enum.ScaleType.Crop
SettingsVisual.TouchPanelPhoto.ZIndex = 1
Instance.new("UICorner", SettingsVisual.TouchPanelPhoto).CornerRadius = UDim.new(0, 14)
SettingsVisual.AddSnowEffect(TouchCard, 10, 2)

local btnTP = Instance.new("TextButton", TouchCard)
btnTP.Size = UDim2.new(0, 95, 0, 28)
btnTP.Position = UDim2.new(0, 8, 0, 8)
btnTP.BackgroundColor3 = COLORS.Blue
btnTP.BackgroundTransparency = 0.65
btnTP.BorderSizePixel = 0
btnTP.Text = "TP"
btnTP.TextColor3 = Color3.fromRGB(255, 255, 255)
btnTP.TextSize = 12
btnTP.Font = Enum.Font.GothamBold
btnTP.ZIndex = 3
Instance.new("UICorner", btnTP).CornerRadius = UDim.new(0, 8)

local isSnappedDown = false
local savedSurfaceY = nil
local targetDepth = TouchPanelValue or 20

-- ========================================================--
-- SNAP CAR DEL PANEL TÁCTIL
-- Solo toma el botón TP cuando el Panel Táctil está visible
-- y el jugador está sentado en un VehicleSeat.
-- Al bajarse, el botón y su función normal vuelven solos.
-- ========================================================--
do
	SettingsVisual.TouchSnapCarState = {
		Enabled = false,
		AboveMode = false, -- modo superior controlado desde el botón CENTRAL
        AboveHeightStuds = 19, -- mas bajito que antes (25 -> 19 studs)
        AboveMoveSpeed = 24, -- movimiento progresivo, sin salto instantaneo
        AboveLowerSpeed = 20, -- bajada progresiva hasta tocar superficie
        AboveLowering = false,
        AboveLandingReady = false,
		Vehicle = nil,
		Root = nil,
		Seat = nil,
		DesiredRootY = nil,
		RootToBottom = nil,
		Depth = 13,
		BaseDepth = 13,
		DepthMoveSpeed = 32,
		DepthMoveActive = false,
        -- Botón vertical continuo: BAJAR -> PARAR -> SUBIR -> PARAR -> BAJAR...
        -- Totalmente manual: no consulta Target Line ni requiere enemigos.
        VerticalChaseMode = "ready",
        VerticalChaseEnabled = false,
        VerticalChaseDescending = false,
        VerticalChaseTarget = nil,
        VerticalChaseHomeY = nil,
        VerticalChaseAnchorXZ = nil,
        VerticalChaseStart = 0,
        VerticalChaseSpeed = 72, -- bajada de flecha: 72 studs/s (ajustador normal sigue en 32)
        VerticalChaseRiseSpeed = 56, -- subida de flecha: 56 studs/s
		Exiting = false,
		SnapGroundY = nil,
		Speed = 90,
		ReverseSpeed = 90,
		AccelRate = 200,
		StopRate = 200,
		DirectionRate = 200,
		SteerPower = 200,
		CurrentDriveSpeed = 0,
		NativeForwardHeld = false,
		NativeReverseHeld = false,
		NativeForwardTouch = nil,
		NativeReverseTouch = nil,
		NativeSteerTouch = nil,
		NativeSteerAxis = 0,
		OriginalProps = setmetatable({}, {__mode = "k"}),

		-- Auto TP hacia UN solo DroppedItem mientras Snap Car ya está abajo.
		ItemTarget = nil,
		ItemTargetPart = nil,
		ItemReturnPivot = nil,
		ItemNextAcquireTime = 0,

		-- Pulso vertical hacia DroppedItems sin frenar el carro.
		ItemPulseBusy = false,
		ItemPulseTargetRootY = nil,
		ItemPulseLastItem = nil,
		ItemPulseGeneration = 0,
		ItemPulseHoldTime = 1.00,
		ItemPulseBelowOffset = 4,

		-- Salto manual del botón pequeño del Panel Táctil.
		ManualJumpBusy = false,
		ManualJumpTargetY = nil,
		ManualJumpGeneration = 0,

		-- Acciones nuevas de las dos casillas cuando estás en carro.
		OneShotBusy = false,

		-- Casilla derecha en carro: auto TP + regreso cuando llevas 1s parado.
		AutoEnemySnapEnabled = false,
		AutoEnemySnapStillSince = nil,
		AutoEnemySnapLastTrigger = 0,
		AutoEnemySnapStopSeconds = 1.00,
		AutoEnemySnapSpeedThreshold = 1.35,
		AutoEnemySnapCooldown = 0.60,

		-- Pose inclinada del personaje mientras está sentado en VehicleSeat.
		SeatPoseMotor = nil,
		SeatPoseOriginalC0 = nil,
		SeatPoseApplied = false,

		-- Pisos abiertos temporalmente por la casilla izquierda.
		-- Se mantienen atravesables mientras Snap Car siga abajo y
		-- se restauran justo al presionar Snap Car para subir/salir.
		OneShotPersistentFloors = setmetatable({}, {__mode = "k"}),

		-- Solo actúa cuando ya estás prácticamente encima del item.
		ItemTriggerDistance = 5,
		ItemVerticalDrop = 4,

		-- Avatar visual pegado debajo del carro cuando Snap está activo.
		AvatarDisc = nil,
		AvatarDiscWeld = nil,
		AvatarImage = nil,

		--====================================================--
		-- PROTECCIÓN DE VEHÍCULO - DEFAULT ON
		--====================================================--
		ImpactProtectionEnabled = true,
		ObstacleProtectionEnabled = true,

		-- Obstáculos:
		ObstacleProbeDistance = 8,
		ObstacleLowLift = 3.2,
		ObstacleWallLift = 1.35,
		ObstacleLiftOffset = 0,
		ObstacleLiftUntil = 0,
		ObstacleCooldownUntil = 0,

		-- Salida de Snap:
		ExitRiseSteps = 14,
		ExitGhostHold = 0.35,
		ExitClearanceStep = 0.55,
		ExitClearanceChecks = 10,
	}

	-- Toma inmediatamente los valores actuales de la pestaña Vehicle.
	if SettingsVisual.SyncVehicleDriveToSnap then
		SettingsVisual.SyncVehicleDriveToSnap()
	end

	SettingsVisual.TouchSnapCarGetVehicle = function()
		local char = Player.Character
		local hum = char and char:FindFirstChildOfClass("Humanoid")
		local seat = hum and hum.SeatPart

		if not seat or not seat:IsA("VehicleSeat") then
			return nil, nil, nil
		end

		local vehicle = seat:FindFirstAncestorOfClass("Model")
		if not vehicle then
			return nil, nil, nil
		end

		local root =
			vehicle.PrimaryPart
			or seat.AssemblyRootPart
			or seat
			or vehicle:FindFirstChildWhichIsA("BasePart", true)

		if root then
			root = root.AssemblyRootPart or root
		end

		return vehicle, root, seat
	end

	SettingsVisual.TouchSnapCarFlatLook = function(cf)
		local look = Vector3.new(
			cf.LookVector.X,
			0,
			cf.LookVector.Z
		)

		if look.Magnitude <= 0.001 then
			return Vector3.new(0, 0, -1)
		end

		return look.Unit
	end

	SettingsVisual.TouchSnapCarUpright = function(position, lookVector)
		local flat = Vector3.new(
			lookVector.X,
			0,
			lookVector.Z
		)

		if flat.Magnitude <= 0.001 then
			flat = Vector3.new(0, 0, -1)
		else
			flat = flat.Unit
		end

		return CFrame.lookAt(
			position,
			position + flat,
			Vector3.yAxis
		)
	end

	SettingsVisual.TouchSnapCarMoveTowards = function(current, target, maxDelta)
		if current < target then
			return math.min(current + maxDelta, target)
		elseif current > target then
			return math.max(current - maxDelta, target)
		end

		return target
	end

	SettingsVisual.TouchSnapCarSavePart = function(part, allowTouch)
		local S = SettingsVisual.TouchSnapCarState
		if not part or not part:IsA("BasePart") then return end

		if S.OriginalProps[part] == nil then
			S.OriginalProps[part] = {
				CanCollide = part.CanCollide,
				CanTouch = part.CanTouch,
				CanQuery = part.CanQuery,
			}
		end

		pcall(function()
			part.CanCollide = false
			part.CanTouch = allowTouch == true
			part.CanQuery = false
		end)
	end

	SettingsVisual.TouchSnapCarPhase = function(vehicle)
		if vehicle then
			for _, obj in ipairs(vehicle:GetDescendants()) do
				if obj:IsA("BasePart") then
					SettingsVisual.TouchSnapCarSavePart(obj, true)
				end
			end
		end

		local char = Player.Character
		if char then
			for _, obj in ipairs(char:GetDescendants()) do
				if obj:IsA("BasePart") then
					SettingsVisual.TouchSnapCarSavePart(obj, false)
				end
			end
		end
	end

	SettingsVisual.TouchCarKeepFloorPassThrough = function(part)
		local S = SettingsVisual.TouchSnapCarState
		if not S or not part or not part:IsA("BasePart") then
			return false
		end

		-- Si Wallhack había tocado este piso, primero lo devuelve a su estado
		-- real. Desde aquí la casilla queda como única dueña temporal del piso.
		if SettingsVisual.WorldPhaseReleasePart then
			SettingsVisual.WorldPhaseReleasePart(part)
		end

		S.OneShotPersistentFloors =
			S.OneShotPersistentFloors
			or setmetatable({}, {__mode = "k"})

		if S.OneShotPersistentFloors[part] == nil then
			S.OneShotPersistentFloors[part] = {
				CanCollide = part.CanCollide,
				CanTouch = part.CanTouch,
				CanQuery = part.CanQuery,
			}
		end

		pcall(function()
			part.CanCollide = false
			part.CanTouch = false
			-- CanQuery se conserva para que raycasts y detección sigan funcionando.
			part.CanQuery = S.OneShotPersistentFloors[part].CanQuery
		end)

		return true
	end

	SettingsVisual.TouchCarRestorePersistentFloors = function()
		local S = SettingsVisual.TouchSnapCarState
		if not S or not S.OneShotPersistentFloors then return end

		for part, props in pairs(S.OneShotPersistentFloors) do
			if part and part.Parent and props then
				pcall(function()
					part.CanCollide = props.CanCollide
					part.CanTouch = props.CanTouch
					part.CanQuery = props.CanQuery
				end)
			end

			S.OneShotPersistentFloors[part] = nil
		end
	end

	SettingsVisual.TouchSnapCarRestore = function()
		local S = SettingsVisual.TouchSnapCarState

		-- Limpieza de seguridad: si Snap termina por cualquier ruta,
		-- no dejamos ningún piso abierto por la casilla izquierda.
		if SettingsVisual.TouchCarRestorePersistentFloors then
			SettingsVisual.TouchCarRestorePersistentFloors()
		end

		for part, props in pairs(S.OriginalProps) do
			if part and part.Parent and props then
				pcall(function()
					part.CanCollide = props.CanCollide
					part.CanTouch = props.CanTouch
					part.CanQuery = props.CanQuery
				end)
			end

			S.OriginalProps[part] = nil
		end
	end

	--========================================================--
	-- VEHICLE PROTECTION HELPERS
	--========================================================--

	SettingsVisual.TouchSnapCarZeroMotion = function(vehicle, root)
		if root and root.Parent then
			pcall(function()
				root.AssemblyLinearVelocity = Vector3.zero
				root.AssemblyAngularVelocity = Vector3.zero
			end)
		end

		if vehicle then
			for _, obj in ipairs(vehicle:GetDescendants()) do
				if obj:IsA("BasePart") then
					pcall(function()
						obj.AssemblyLinearVelocity = Vector3.zero
						obj.AssemblyAngularVelocity = Vector3.zero
					end)
				end
			end
		end
	end

	SettingsVisual.TouchSnapCarFullGhost = function(vehicle)
		if not vehicle then return end

		for _, obj in ipairs(vehicle:GetDescendants()) do
			if obj:IsA("BasePart") then
				-- Guarda los valores originales si todavía no estaban guardados.
				SettingsVisual.TouchSnapCarSavePart(obj, false)

				pcall(function()
					obj.CanCollide = false
					obj.CanTouch = false
					obj.CanQuery = false
				end)
			end
		end

		local char = Player.Character
		if char then
			for _, obj in ipairs(char:GetDescendants()) do
				if obj:IsA("BasePart") then
					SettingsVisual.TouchSnapCarSavePart(obj, false)

					pcall(function()
						obj.CanCollide = false
						obj.CanTouch = false
						obj.CanQuery = false
					end)
				end
			end
		end
	end

	SettingsVisual.TouchSnapCarHasAnchoredOverlap = function(vehicle)
		if not vehicle then return false end

		local boxCF, boxSize = vehicle:GetBoundingBox()

		local params = OverlapParams.new()
		params.FilterType = Enum.RaycastFilterType.Exclude

		local filter = {vehicle}
		if Player.Character then
			table.insert(filter, Player.Character)
		end

		params.FilterDescendantsInstances = filter
		params.MaxParts = 40

		local safeSize =
			Vector3.new(
				math.max(0.5, boxSize.X * 0.88),
				math.max(0.5, boxSize.Y * 0.82),
				math.max(0.5, boxSize.Z * 0.88)
			)

		local ok, parts =
			pcall(function()
				return workspace:GetPartBoundsInBox(
					boxCF,
					safeSize,
					params
				)
			end)

		if not ok or not parts then
			return false
		end

		for _, part in ipairs(parts) do
			if part
				and part:IsA("BasePart")
				and part.Anchored then
				return true
			end
		end

		return false
	end

	SettingsVisual.TouchSnapCarObstacleProbe = function(vehicle, root, moveDirection)
		local S = SettingsVisual.TouchSnapCarState

		if not S.ObstacleProtectionEnabled
			or not vehicle
			or not root
			or not moveDirection
			or moveDirection.Magnitude <= 0.001 then
			return nil, math.huge
		end

		local direction =
			Vector3.new(
				moveDirection.X,
				0,
				moveDirection.Z
			)

		if direction.Magnitude <= 0.001 then
			return nil, math.huge
		end

		direction = direction.Unit

		local params = RaycastParams.new()
		params.FilterType = Enum.RaycastFilterType.Exclude
		params.IgnoreWater = true

		local filter = {vehicle}
		if Player.Character then
			table.insert(filter, Player.Character)
		end

		params.FilterDescendantsInstances = filter

		local boxCF, boxSize = vehicle:GetBoundingBox()
		local bottomY =
			boxCF.Position.Y - (boxSize.Y * 0.5)

		local right =
			Vector3.new(
				root.CFrame.RightVector.X,
				0,
				root.CFrame.RightVector.Z
			)

		if right.Magnitude <= 0.001 then
			right = Vector3.xAxis
		else
			right = right.Unit
		end

		local halfWidth =
			math.clamp(
				boxSize.X * 0.28,
				1.25,
				3.4
			)

		local speed =
			math.abs(
				tonumber(S.CurrentDriveSpeed)
				or root.AssemblyLinearVelocity.Magnitude
				or 0
			)

		local distance =
			math.clamp(
				(tonumber(S.ObstacleProbeDistance) or 8)
				+ speed * 0.025,
				6,
				11
			)

		local lowY =
			bottomY + math.min(1.15, boxSize.Y * 0.30)

		local highY =
			bottomY
			+ math.clamp(
				boxSize.Y * 0.72,
				2.8,
				5.2
			)

		local sideOffsets = {
			0,
			halfWidth,
			-halfWidth
		}

		local nearestLow = math.huge
		local nearestHigh = math.huge

		local function realObstacle(result)
			if not result then return false end

			local hit = result.Instance
			return
				hit == workspace.Terrain
				or (
					hit
					and hit:IsA("BasePart")
					and hit.Anchored
				)
		end

		for _, side in ipairs(sideOffsets) do
			local horizontal =
				Vector3.new(
					boxCF.Position.X,
					0,
					boxCF.Position.Z
				)
				+ right * side

			local lowOrigin =
				Vector3.new(
					horizontal.X,
					lowY,
					horizontal.Z
				)

			local highOrigin =
				Vector3.new(
					horizontal.X,
					highY,
					horizontal.Z
				)

			local lowResult =
				workspace:Raycast(
					lowOrigin,
					direction * distance,
					params
				)

			if realObstacle(lowResult) then
				nearestLow =
					math.min(
						nearestLow,
						(lowResult.Position - lowOrigin).Magnitude
					)
			end

			local highResult =
				workspace:Raycast(
					highOrigin,
					direction * distance,
					params
				)

			if realObstacle(highResult) then
				nearestHigh =
					math.min(
						nearestHigh,
						(highResult.Position - highOrigin).Magnitude
					)
			end
		end

		-- Obstáculo bajo: golpea abajo pero hay espacio arriba.
		if nearestLow < math.huge
			and nearestHigh == math.huge then
			return "low", nearestLow
		end

		-- Pared/superficie alta: ambos rayos detectan.
		if nearestLow < math.huge
			and nearestHigh < math.huge then
			return "wall", math.min(nearestLow, nearestHigh)
		end

		-- Si solo pega el rayo alto, también lo tratamos como pared/techo frontal.
		if nearestHigh < math.huge then
			return "wall", nearestHigh
		end

		return nil, math.huge
	end

	SettingsVisual.TouchSnapCarGroundY = function(vehicle, root)
		if not root then return nil end

		local params = RaycastParams.new()
		params.FilterType = Enum.RaycastFilterType.Exclude
		params.IgnoreWater = true

		local ignore = {vehicle}
		if Player.Character then
			table.insert(ignore, Player.Character)
		end

		params.FilterDescendantsInstances = ignore

		local result = workspace:Raycast(
			root.Position + Vector3.new(0, 8, 0),
			Vector3.new(0, -300, 0),
			params
		)

		return result and result.Position.Y or (root.Position.Y - 3)
	end

	SettingsVisual.TouchSnapCarSurfaceY = function(vehicle, root)
		if not root then return nil, nil end

		local params = RaycastParams.new()
		params.FilterType = Enum.RaycastFilterType.Exclude
		params.IgnoreWater = true

		local ignore = {vehicle}
		if Player.Character then
			table.insert(ignore, Player.Character)
		end

		-- No usar otro carro como superficie de salida.
		local vehicles = workspace:FindFirstChild("Vehicles")
		if vehicles then
			table.insert(ignore, vehicles)
		end

		params.FilterDescendantsInstances = ignore

		-- Guardar la superficie donde se inició Snap Car para poder
		-- recuperar desde 200m / void aunque falte el rayo o haya rollback.
		local S = SettingsVisual.TouchSnapCarState
		local safeGround = S and tonumber(S.SnapGroundY) or nil
		local result = workspace:Raycast(
			root.Position + Vector3.new(0, 0.20, 0),
			Vector3.new(0, 340, 0),
			params
		)

		if not result then
			return safeGround or (root.Position.Y + 13), nil
		end

		local part = result.Instance
		local surfaceY = result.Position.Y

		-- El rayo ascendente toca normalmente la CARA INFERIOR del piso.
		-- Calculamos el punto más alto real de esa pieza para colocar las
		-- llantas arriba del piso, no dentro de él.
		if part and part:IsA("BasePart") then
			local cf = part.CFrame
			local size = part.Size
			local halfY =
				math.abs(cf.RightVector.Y) * size.X * 0.5
				+ math.abs(cf.UpVector.Y) * size.Y * 0.5
				+ math.abs(cf.LookVector.Y) * size.Z * 0.5

			surfaceY = cf.Position.Y + halfY
		end

		if safeGround and math.abs(surfaceY - safeGround) > 60 then
			return safeGround, nil
		end
		return surfaceY, part
	end

	SettingsVisual.TouchSnapCarDestroyAvatar = function()
		local S = SettingsVisual.TouchSnapCarState

		if S.AvatarDisc then
			pcall(function()
				S.AvatarDisc:Destroy()
			end)
		end

		S.AvatarDisc = nil
		S.AvatarDiscWeld = nil
		S.AvatarImage = nil
	end

	SettingsVisual.TouchSnapCarCreateAvatar = function(vehicle, root)
		local S = SettingsVisual.TouchSnapCarState

		SettingsVisual.TouchSnapCarDestroyAvatar()

		if not vehicle or not root then
			return
		end

		-- Misma imagen moradita que usa el panel/botón principal.
		local image = "rbxassetid://105275560374583"

		local disc = Instance.new("Part")
		disc.Name = "CHINO_SnapCarPurpleDisc"
		-- Grande debajo del carro, estilo plataforma visual.
		-- 24 studs de diámetro para que se note bastante sin ocupar media ciudad.
		disc.Size = Vector3.new(24, 0.06, 24)
		disc.Transparency = 1
		disc.Anchored = false
		disc.Massless = true
		disc.CanCollide = false
		disc.CanTouch = false
		disc.CanQuery = false
		disc.CastShadow = false

		local offsetY =
			(S.RootToBottom or 2.5) + 0.22

		disc.CFrame =
			root.CFrame
			* CFrame.new(0, -offsetY, 0)

		disc.Parent = workspace

		local weld = Instance.new("WeldConstraint")
		weld.Name = "CHINO_SnapCarAvatarWeld"
		weld.Part0 = root
		weld.Part1 = disc
		weld.Parent = disc

		local gui = Instance.new("SurfaceGui")
		gui.Name = "CHINO_SnapCarPurpleGui"
		gui.Face = Enum.NormalId.Top

		-- IMPORTANTE:
		-- respeta profundidad 3D para que NO se vea atravesando el carro.
		gui.AlwaysOnTop = false
		gui.LightInfluence = 0
		gui.PixelsPerStud = 55
		gui.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
		gui.Parent = disc

		local holder = Instance.new("Frame")
		holder.Size = UDim2.fromScale(1, 1)
		holder.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		holder.BackgroundTransparency = 1
		holder.BorderSizePixel = 0
		holder.ClipsDescendants = true
		holder.Parent = gui

		local holderCorner = Instance.new("UICorner")
		holderCorner.CornerRadius = UDim.new(1, 0)
		holderCorner.Parent = holder

		local imageLabel = Instance.new("ImageLabel")
		imageLabel.Name = "PurplePanelImage"
		imageLabel.Size = UDim2.fromScale(1, 1)
		imageLabel.Position = UDim2.fromScale(0, 0)
		imageLabel.BackgroundTransparency = 1
		imageLabel.Image = image
		imageLabel.ScaleType = Enum.ScaleType.Crop
		imageLabel.Parent = holder

		local imageCorner = Instance.new("UICorner")
		imageCorner.CornerRadius = UDim.new(1, 0)
		imageCorner.Parent = imageLabel

		local stroke = Instance.new("UIStroke")
		stroke.Thickness = 3
		stroke.Transparency = 0.12
		stroke.Color =
			SettingsVisual.ThemeBright
			or Color3.fromRGB(255, 255, 255)
		stroke.Parent = holder

		-- Glow circular adicional, sin Parts físicas.
		local glowStroke = Instance.new("UIStroke")
		glowStroke.Thickness = 8
		glowStroke.Transparency = 0.62
		glowStroke.Color =
			SettingsVisual.ThemeColor
			or COLORS.Blue
		glowStroke.Parent = imageLabel

		S.AvatarDisc = disc
		S.AvatarDiscWeld = weld
		S.AvatarImage = imageLabel
	end

	SettingsVisual.TouchSnapCarSet = function(state)
		local S = SettingsVisual.TouchSnapCarState
		state = state == true

        -- Exclusión MUTUA: si una salida protegida sigue ejecutándose,
        -- no se puede volver a activar Snap/arriba en mitad de un PivotTo.
        -- Se ignora ese toque rápido; al acabar, vuelve a funcionar.
        if S.Exiting then return false end

		if state then
            -- Si la activación viene del botón CENTRAL, no detenerla antes
            -- de arrancar. Snap subterráneo sí apaga el anterior modo elevado.
            if not S.AboveMode and SettingsVisual.ChinoCarHoverStop then
                SettingsVisual.ChinoCarHoverStop()
            end
			if S.Enabled then return true end

			if SettingsVisual.SyncVehicleDriveToSnap then
				SettingsVisual.SyncVehicleDriveToSnap()
			end

			local vehicle, root, seat =
				SettingsVisual.TouchSnapCarGetVehicle()

			if not vehicle or not root or not seat then
				return false
			end

			-- Si estaba usando el TP normal, primero vuelve a su posición normal.
			if isSnappedDown and SettingsVisual.TouchNormalSnapToggle then
				SettingsVisual.TouchNormalSnapToggle()
			end

			if SettingsVisual.TouchTargetFollowEnabled
				and SettingsVisual.SetTouchTargetFollow then
				SettingsVisual.SetTouchTargetFollow(false)
			end

			local groundY =
				SettingsVisual.TouchSnapCarGroundY(vehicle, root)

			if not groundY then
				return false
			end

			-- Guarda la superficie original de esta bajada.
			-- Si editas los metros mientras Snap Car ya está abajo,
			-- usamos ESTA misma referencia y no otro piso underground.
            S.SnapGroundY = groundY
            S.SafeStartXZ = Vector3.new(root.Position.X, groundY, root.Position.Z)

			local boxCF, boxSize = vehicle:GetBoundingBox()
			local bottomY =
				boxCF.Position.Y - (boxSize.Y * 0.5)

			S.RootToBottom =
				root.Position.Y - bottomY

            -- Arriba: guardar altura FINAL, pero NO moverla ahora.
            -- El motor Heartbeat interpolara Y (manteniendo X/Z y la velocidad).
            S.DesiredRootY = S.AboveMode
                and (groundY + (S.AboveHeightStuds or 19) + (S.RootToBottom or 2.5) + 0.35)
                or (groundY - (S.Depth or 13) + (S.RootToBottom or 2.5) + 0.35)
            S.AboveLowering = false
            S.AboveLandingReady = false

			S.Vehicle = vehicle
			S.DepthMoveActive = false
			S.Root = root
			S.Seat = seat
            S.SnapVehicleSafeMax = SettingsVisual.VehicleGetSafeMaxSpeed
                and SettingsVisual.VehicleGetSafeMaxSpeed(vehicle, seat) or 140
            -- Si se activa a toda velocidad, no arrancar desde cero.
            local planarVelocity = root.AssemblyLinearVelocity
            local look = SettingsVisual.TouchSnapCarFlatLook(root.CFrame)
            local initialSignedSpeed = Vector3.new(planarVelocity.X, 0, planarVelocity.Z):Dot(look)
            if S.AboveMode then
                S.SnapVehicleSafeMax = math.max(S.SnapVehicleSafeMax, math.abs(initialSignedSpeed) * 1.08)
                S.CurrentDriveSpeed = initialSignedSpeed
            else
                S.CurrentDriveSpeed = 0
            end

			S.ItemTarget = nil
			S.ItemTargetPart = nil
			S.ItemReturnPivot = nil
			S.ItemNextAcquireTime = 0
			S.ItemPulseBusy = false
			S.ItemPulseTargetRootY = nil
			S.ItemPulseLastItem = nil
			S.ItemPulseGeneration = (S.ItemPulseGeneration or 0) + 1

            SettingsVisual.TouchSnapCarPhase(vehicle)

            -- Snap Car subterráneo conserva su comportamiento anterior.
            -- El botón central no hace PivotTo ni frena el vehículo al tocarlo.
            if not S.AboveMode then
                local upright = SettingsVisual.TouchSnapCarUpright(
                    Vector3.new(root.Position.X, S.DesiredRootY, root.Position.Z),
                    SettingsVisual.TouchSnapCarFlatLook(root.CFrame))
                local rootToPivot = root.CFrame:ToObjectSpace(vehicle:GetPivot())
                pcall(function()
                    vehicle:PivotTo(upright * rootToPivot)
                    root.AssemblyLinearVelocity = Vector3.zero
                    root.AssemblyAngularVelocity = Vector3.zero
                end)
            end

			S.Enabled = true

			-- Avatar circular grande pegado debajo del carro.
			if SettingsVisual.TouchSnapCarCreateAvatar then
				SettingsVisual.TouchSnapCarCreateAvatar(
					vehicle,
					root
				)
			end

			btnTP.Text = "Snap Car"
			btnTP.BackgroundColor3 = Color3.fromRGB(180, 35, 60)
			return true
		end

		if not S.Enabled then
			return true
		end
		if S.Exiting then return false end
		S.Exiting = true
		S.DepthMoveActive = false
        -- No dejar vivo el ciclo vertical al apagar Snap Car.
        S.VerticalChaseMode = "ready"
        S.VerticalChaseEnabled = false
        S.VerticalChaseDescending = false
        S.VerticalChaseTarget = nil
        S.VerticalChaseHomeY = nil
        S.VerticalChaseAnchorXZ = nil

        -- Si el botón P provocó una expulsión, rescatar al PERSONAJE
        -- antes de subir el vehículo o limpiar la sesión Snap.
        if SettingsVisual.TouchCarPRescueIfEjected then
            pcall(SettingsVisual.TouchCarPRescueIfEjected)
        end

        -- Al apagar Snap Car se cancela el pulso P sin volver al origen.
        -- La rutina normal de salida rescata el carro donde quedó.
        if SettingsVisual.TouchCarCancelPTeleport then
			SettingsVisual.TouchCarCancelPTeleport()
		end
        -- Si el usuario sube voluntariamente estando aún sentado,
        -- ya no corresponde rescatarlo cuando baje en la superficie.
        if S.PRescuePending and S.PRescueHumanoid
            and S.PRescueHumanoid.SeatPart then
            S.PRescuePending = false
        end

		-- Al presionar Snap Car para SUBIR, el piso abierto por la
		-- casilla izquierda vuelve a su colisión normal INMEDIATAMENTE.
		if SettingsVisual.TouchCarRestorePersistentFloors then
			SettingsVisual.TouchCarRestorePersistentFloors()
		end

		S.Enabled = false

		if SettingsVisual.TouchSnapCarDestroyAvatar then
			SettingsVisual.TouchSnapCarDestroyAvatar()
		end

		-- Si tú apagas Snap Car manualmente, dejamos de seguir el item.
		-- No hacemos retorno automático porque ya pediste salir del Snap.
		S.ItemTarget = nil
		S.ItemTargetPart = nil
		S.ItemReturnPivot = nil
		S.ItemNextAcquireTime = 0
		S.ItemPulseBusy = false
		S.ItemPulseTargetRootY = nil
		S.ItemPulseLastItem = nil
		S.ItemPulseGeneration = (S.ItemPulseGeneration or 0) + 1

		S.NativeForwardHeld = false
		S.NativeReverseHeld = false
		S.NativeForwardTouch = nil
		S.NativeReverseTouch = nil
		S.NativeSteerTouch = nil
		S.NativeSteerAxis = 0
		S.CurrentDriveSpeed = 0

		local vehicle = S.Vehicle
		local root = S.Root

		if vehicle
			and vehicle.Parent
			and root
			and root.Parent then

			--====================================================--
			-- SALIDA PROTEGIDA DE SNAP
			--
			-- Ghost completo + velocidad cero + búsqueda de espacio libre.
			--====================================================--

			local S2 = SettingsVisual.TouchSnapCarState

			S2.ObstacleLiftOffset = 0
			S2.ObstacleLiftUntil = 0
			S2.ObstacleCooldownUntil = 0

			SettingsVisual.TouchSnapCarFullGhost(vehicle)
			SettingsVisual.TouchSnapCarZeroMotion(vehicle, root)

            local surfaceY
            local targetXZ = root.Position
            local cachedY = tonumber(S.SnapGroundY)
            local safeXZ = S.SafeStartXZ
            if S.AboveMode then
                -- Buscar la calle desde ENCIMA del nivel guardado: incluso
                -- si el vehículo ya se cayó bajo el mapa.
                local params = RaycastParams.new()
                params.FilterType = Enum.RaycastFilterType.Exclude
                params.IgnoreWater = true
                local ignored = {vehicle}
                if Player.Character then table.insert(ignored, Player.Character) end
                local otherVehicles = workspace:FindFirstChild("Vehicles")
                if otherVehicles then table.insert(ignored, otherVehicles) end
                params.FilterDescendantsInstances = ignored
                local fromY = math.max(root.Position.Y + 12, (cachedY or root.Position.Y) + 70)
                local floorHit = workspace:Raycast(
                    Vector3.new(root.Position.X, fromY, root.Position.Z),
                    Vector3.new(0, -210, 0), params)
                if floorHit and (not cachedY or math.abs(floorHit.Position.Y-cachedY)<=42) then
                    surfaceY = floorHit.Position.Y
                else
                    -- No hay calzada fiable aquí: volver a X/Z donde sí
                    -- había superficie al iniciar Snap, y NO al vacío.
                    surfaceY = cachedY
                    if safeXZ then targetXZ = safeXZ end
                end
            else
                surfaceY = SettingsVisual.TouchSnapCarSurfaceY(vehicle, root)
                if not surfaceY and cachedY then
                    surfaceY = cachedY
                    if safeXZ then targetXZ = safeXZ end
                end
            end

			local boxCF, boxSize =
				vehicle:GetBoundingBox()

			local bottomY =
				boxCF.Position.Y
				- (boxSize.Y * 0.5)

			local rootToBottom =
				root.Position.Y - bottomY

			-- Termina apenas por encima de la superficie,
			-- sin lanzarlo alto ni dejarlo caer.
			local targetRootY =
				(surfaceY or root.Position.Y)
				+ 1.65 -- extra de salida para que el carro no quede hundido
				+ rootToBottom

			local flatLook =
				SettingsVisual.TouchSnapCarFlatLook(
					root.CFrame
				)

            local startRoot =
                SettingsVisual.TouchSnapCarUpright(
                    root.Position,
                    flatLook
                )
            -- Si la última X/Z está al vacío, interpolar también X/Z a
            -- una zona segura (el inicio tenía suelo comprobado).
            local startXZ = root.Position
            local endXZ = targetXZ

			local rootToPivot =
				root.CFrame:ToObjectSpace(
					vehicle:GetPivot()
				)

			local riseSteps =
				math.max(
					10,
					tonumber(S2.ExitRiseSteps) or 14
				)

			-- Subida progresiva con toda la física anulada.
			for i = 1, riseSteps do
                if not vehicle.Parent or not root.Parent then break end
				local linear = i / riseSteps

				-- Smoothstep para no dar un tirón al empezar/terminar.
				local alpha =
					linear * linear * (3 - 2 * linear)

				local y =
					startRoot.Position.Y
					+ (
						targetRootY
						- startRoot.Position.Y
					) * alpha

				local stepRoot =
					SettingsVisual.TouchSnapCarUpright(
                        Vector3.new(
                            startXZ.X + (endXZ.X - startXZ.X)*alpha,
                            y,
                            startXZ.Z + (endXZ.Z - startXZ.Z)*alpha
                        ),
						flatLook
					)

				pcall(function()
					vehicle:PivotTo(
						stepRoot * rootToPivot
					)
				end)

				SettingsVisual.TouchSnapCarZeroMotion(
					vehicle,
					root
				)

				RunService.Heartbeat:Wait()
			end

			-- NO buscamos "espacio libre" subiendo más.
			-- Dentro de una casa esa rutina confundía paredes/techo con bloqueo
			-- y terminaba levantando el carro hasta arriba del edificio.
			-- La salida queda exactamente sobre el primer piso encima del Snap.

			-- Mantiene ghost un momento después de cruzar el piso,
			-- para que no haya un touch/impact justo al restaurar.
			local holdSeconds =
				math.max(
					0.18,
					tonumber(S2.ExitGhostHold) or 0.35
				)

			local holdStart = os.clock()

			while os.clock() - holdStart < holdSeconds do
                if not vehicle.Parent or not root.Parent then break end
				SettingsVisual.TouchSnapCarFullGhost(vehicle)
				SettingsVisual.TouchSnapCarZeroMotion(vehicle, root)
				RunService.Heartbeat:Wait()
			end
		end

		SettingsVisual.TouchSnapCarRestore()

		-- Al subir con Snap Car, el panel vuelve a su valor normal de 20m
		-- y la próxima bajada conserva la profundidad original del Snap.
        S.AboveMode = false
        S.SafeStartXZ = nil
        if SettingsVisual.ChinoCarHover then
            SettingsVisual.ChinoCarHover.Active = false
            SettingsVisual.ChinoCarHover.Vehicle = nil
            SettingsVisual.ChinoCarHover.Root = nil
        end
		S.Depth = tonumber(S.BaseDepth) or 13
		S.SnapGroundY = nil
		S.Exiting = false
		TouchPanelValue = 20
		targetDepth = 20
		SettingsVisual.TouchItemDistanceManualLocked = false
		SettingsVisual.TouchItemDistanceManualValue = nil
		SettingsVisual.TouchItemDistanceTarget = nil
		SettingsVisual.TouchItemDistanceSavedValue = nil
		if SettingsVisual.RefreshTouchDepthText then
			SettingsVisual.RefreshTouchDepthText()
		end

		S.Vehicle = nil
		S.Root = nil
		S.Seat = nil
		S.DesiredRootY = nil
		S.RootToBottom = nil

		local _, _, seatNow =
			SettingsVisual.TouchSnapCarGetVehicle()

		if TouchPanelGui.Enabled and seatNow then
			btnTP.Text = "Snap Car"
		else
			btnTP.Text = isSnappedDown
				and (SettingsVisual.TouchPanelUpMode and "BAJAR" or "SUBIR")
				or "TP"
		end

		btnTP.BackgroundColor3 =
			isSnappedDown
			and Color3.fromRGB(180, 35, 60)
			or COLORS.Blue

		return true
	end

	-- Cambia la profundidad EN VIVO mientras Snap Car ya está abajo.
	-- No altera el arranque normal del Snap: solo entra cuando tú editas
	-- manualmente el número del Panel Táctil con Snap activo.
	SettingsVisual.TouchSnapCarApplyManualDepth = function(depthValue)
		local S = SettingsVisual.TouchSnapCarState
		if not S or not S.Enabled or S.AboveMode then return false end

		local vehicle = S.Vehicle
		local root = S.Root
		if not vehicle or not vehicle.Parent or not root or not root.Parent then
			return false
		end

		local depth = math.clamp(tonumber(depthValue) or 20, 5, 2000)
		local groundY = tonumber(S.SnapGroundY)
		if not groundY then
			return false
		end

        -- Cambiar el número manual cancela el ciclo BAJAR / PARAR / SUBIR.
        S.VerticalChaseMode = "ready"
        S.VerticalChaseEnabled = false
        S.VerticalChaseDescending = false
        S.VerticalChaseTarget = nil
        S.VerticalChaseHomeY = nil
        S.VerticalChaseAnchorXZ = nil
		S.Depth = depth
		S.DesiredRootY =
			groundY
			- depth
			+ (tonumber(S.RootToBottom) or 2.5)
			+ 0.35

		-- La profundidad manual queda como BASE, pero el pulso temporal de
		-- DroppedItems sigue disponible y después vuelve a esta profundidad.
		S.ItemTarget = nil
		S.ItemTargetPart = nil
		S.ItemReturnPivot = nil
		S.ItemPulseBusy = false
		S.ItemPulseTargetRootY = nil
		S.ItemPulseGeneration = (S.ItemPulseGeneration or 0) + 1
		S.ItemNextAcquireTime = os.clock() + 0.15
		S.ObstacleLiftOffset = 0
		S.ObstacleLiftUntil = 0
		S.ObstacleCooldownUntil = 0

		-- Conserva la bajada gradual a 32 studs/seg., incluso hasta 2000 en el selector;
		-- no cambia a TP brusco cuando la profundidad es grande.
		S.DepthMoveSpeed = 32
		S.DepthMoveActive = true
		S.CurrentDriveSpeed = 0
		SettingsVisual.TouchSnapCarFullGhost(vehicle)
		SettingsVisual.TouchSnapCarZeroMotion(vehicle, root)
		return true
	end

    -- Flecha manual continua (4 toques, repetible):
    -- BAJAR (72) -> PARAR -> SUBIR (56) -> PARAR -> BAJAR ...
    -- Nunca requiere enemigos ni Target Line; solo mueve el coche en vertical.
    SettingsVisual.TouchVerticalChaseStep = function()
        local S = SettingsVisual.TouchSnapCarState
        if not S or not S.Enabled or S.AboveMode or S.Exiting then
            return false
        end
        local car, root, seat = SettingsVisual.TouchSnapCarGetVehicle()
        if not car or not root or not seat or car ~= S.Vehicle
            or not S.SnapGroundY or root.Position.Y >= S.SnapGroundY - 1 then
            return false
        end

        local phase = S.VerticalChaseMode or "ready"

        if phase == "down" then
            -- Toque 2/6/...: pausa inmediatamente el movimiento hacia abajo.
            S.VerticalChaseMode = "stop_down"
            S.VerticalChaseDescending = false
            S.VerticalChaseEnabled = true
            S.VerticalChaseAnchorXZ = nil
            S.DesiredRootY = root.Position.Y
            S.DepthMoveActive = false
            S.DepthMoveSpeed = 32
            S.CurrentDriveSpeed = 0
            SettingsVisual.TouchSnapCarZeroMotion(car, root)
            return true
        end

        if phase == "stop_down" then
            -- Toque 3/7/...: el techo de regreso está a 20m bajo el piso
            -- original de Snap, no en la altura (posiblemente profunda)
            -- del último comienzo de BAJAR. Si comenzó más arriba de 20m,
            -- respetamos ese punto inicial para que nunca tenga que descender
            -- cuando pulsas SUBIR.
            local ceilingY = (tonumber(S.SnapGroundY) or root.Position.Y)
                - 20 + (tonumber(S.RootToBottom) or 2.5) + 0.35
            local home = math.max(tonumber(S.VerticalChaseHomeY) or ceilingY, ceilingY)
            S.VerticalChaseHomeY = home
            S.VerticalChaseMode = "up"
            S.VerticalChaseDescending = false
            S.VerticalChaseEnabled = true
            S.VerticalChaseAnchorXZ = Vector2.new(root.Position.X, root.Position.Z)
            S.DesiredRootY = home
            S.ObstacleLiftOffset = 0 -- sin compensación vertical al subir
            S.ObstacleLiftUntil = 0
            S.DepthMoveSpeed = S.VerticalChaseRiseSpeed or 56
            S.DepthMoveActive = true
            S.CurrentDriveSpeed = 0
            SettingsVisual.TouchSnapCarZeroMotion(car, root)
            return true
        end

        if phase == "up" then
            -- Toque 4/8/...: también detiene la subida en el punto actual.
            S.VerticalChaseMode = "stop_up"
            S.VerticalChaseDescending = false
            S.VerticalChaseEnabled = true
            S.VerticalChaseAnchorXZ = nil
            S.DesiredRootY = root.Position.Y
            S.DepthMoveActive = false
            S.DepthMoveSpeed = 32
            S.VerticalChaseHomeY = nil
            S.CurrentDriveSpeed = 0
            SettingsVisual.TouchSnapCarZeroMotion(car, root)
            return true
        end

        -- 'stop_up' o 'ready' -> toque 1/5/9/...: comenzar nueva bajada.
        -- Desde stop_up el coche baja desde donde lo detuviste al subir.
        if S.OneShotBusy or S.ItemPulseBusy or S.ManualJumpBusy
            or S.PTeleportBusy then return false end

        S.VerticalChaseMode = "down"
        S.VerticalChaseEnabled = true
        S.VerticalChaseDescending = true
        S.VerticalChaseHomeY = root.Position.Y
        S.VerticalChaseAnchorXZ = Vector2.new(root.Position.X, root.Position.Z)
        S.VerticalChaseStart = os.clock()
        S.CurrentDriveSpeed = 0
        S.DepthMoveActive = false
        S.DepthMoveSpeed = 32
        S.ObstacleLiftOffset = 0
        S.ObstacleLiftUntil = 0
        SettingsVisual.TouchSnapCarZeroMotion(car, root)
        return true
    end

    SettingsVisual.TouchSnapCarShouldUse = function()
		if not TouchPanelGui.Enabled then
			return false
		end

		local _, _, seat =
			SettingsVisual.TouchSnapCarGetVehicle()

		return seat ~= nil
	end

	-- Controles móviles reales: volante izquierda + flechas derecha.
	UserInputService.InputBegan:Connect(function(input)
		local S = SettingsVisual.TouchSnapCarState

		local surfaceSliderDrive =
			SettingsVisual.VehicleSliderDriveState
			and SettingsVisual.VehicleSliderDriveState.Enabled

		if (not S.Enabled and not surfaceSliderDrive)
			or input.UserInputType ~= Enum.UserInputType.Touch then
			return
		end

		local cam = workspace.CurrentCamera
		local vp =
			cam and cam.ViewportSize
			or Vector2.new(1920, 1080)

		local pos = input.Position

		local forward =
			pos.Y >= vp.Y * 0.62
			and pos.Y <= vp.Y * 0.82
			and pos.X >= vp.X * 0.845
			and pos.X <= vp.X * 0.935

		local reverse =
			pos.Y >= vp.Y * 0.62
			and pos.Y <= vp.Y * 0.82
			and pos.X >= vp.X * 0.755
			and pos.X < vp.X * 0.845

		local steer =
			pos.Y >= vp.Y * 0.60
			and pos.X >= vp.X * 0.04
			and pos.X <= vp.X * 0.36

		if forward then
			S.NativeForwardTouch = input
			S.NativeForwardHeld = true
		elseif reverse then
			S.NativeReverseTouch = input
			S.NativeReverseHeld = true
		elseif steer then
			S.NativeSteerTouch = input

			local centerX = vp.X * 0.20
			local radiusX = math.max(vp.X * 0.115, 1)

			S.NativeSteerAxis =
				math.clamp(
					(pos.X - centerX) / radiusX,
					-1,
					1
				)
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		local S = SettingsVisual.TouchSnapCarState

		local surfaceSliderDrive =
			SettingsVisual.VehicleSliderDriveState
			and SettingsVisual.VehicleSliderDriveState.Enabled

		if (not S.Enabled and not surfaceSliderDrive)
			or not S.NativeSteerTouch
			or input ~= S.NativeSteerTouch then
			return
		end

		local cam = workspace.CurrentCamera
		local vp =
			cam and cam.ViewportSize
			or Vector2.new(1920, 1080)

		local centerX = vp.X * 0.20
		local radiusX = math.max(vp.X * 0.115, 1)

		S.NativeSteerAxis =
			math.clamp(
				(input.Position.X - centerX) / radiusX,
				-1,
				1
			)
	end)

	UserInputService.InputEnded:Connect(function(input)
		local S = SettingsVisual.TouchSnapCarState

		if S.NativeForwardTouch and input == S.NativeForwardTouch then
			S.NativeForwardTouch = nil
			S.NativeForwardHeld = false
		end

		if S.NativeReverseTouch and input == S.NativeReverseTouch then
			S.NativeReverseTouch = nil
			S.NativeReverseHeld = false
		end

		if S.NativeSteerTouch and input == S.NativeSteerTouch then
			S.NativeSteerTouch = nil
			S.NativeSteerAxis = 0
		end
	end)

	-- Detección automática: sentado = Snap Car / bajado = TP normal.
	task.spawn(function()
		while TouchPanelGui and TouchPanelGui.Parent do
			task.wait(0.10)

			local S = SettingsVisual.TouchSnapCarState
			local _, _, seat =
				SettingsVisual.TouchSnapCarGetVehicle()

			if not TouchPanelGui.Enabled then
				if S.Enabled then
					SettingsVisual.TouchSnapCarSet(false)
				end
			elseif seat then
				if SettingsVisual.TouchTargetFollowEnabled
					and SettingsVisual.SetTouchTargetFollow then
					SettingsVisual.SetTouchTargetFollow(false)
				end

				if isSnappedDown
					and SettingsVisual.TouchNormalSnapToggle then
					SettingsVisual.TouchNormalSnapToggle()
				end

				btnTP.Text = "Snap Car"
				btnTP.BackgroundColor3 =
					S.Enabled
					and Color3.fromRGB(180, 35, 60)
					or COLORS.Blue
			else
				-- FAILSAFE: si te bajas/bugueas mientras Snap Car estaba abajo,
				-- TouchSnapCarGetVehicle() ya no puede ver el VehicleSeat.
				-- TouchSnapCarSet(false) usa S.Vehicle/S.Root guardados y rescata
				-- ese mismo carro hacia la primera superficie encima antes de limpiar Snap.
				if S.Enabled then
					SettingsVisual.TouchSnapCarSet(false)
				end

				btnTP.Text =
					isSnappedDown
					and (SettingsVisual.TouchPanelUpMode and "BAJAR" or "SUBIR")
					or "TP"

				btnTP.BackgroundColor3 =
					isSnappedDown
					and Color3.fromRGB(180, 35, 60)
					or COLORS.Blue
			end
		end
	end)

	-- Motor Underground. Mantiene altura fija, carro recto,
	-- atraviesa paredes y conserva velocidad física real.
	RunService.Heartbeat:Connect(function(dt)
		local S = SettingsVisual.TouchSnapCarState
		if not S.Enabled then return end

		local vehicle, root, seat =
			SettingsVisual.TouchSnapCarGetVehicle()

		if not vehicle
			or not root
			or not seat
			or vehicle ~= S.Vehicle then

			-- RESCATE INMEDIATO: no esperar otro ciclo si se perdió el asiento.
			-- La salida protegida trabaja con el vehículo/root que Snap guardó
			-- al activarse, por lo que también funciona después de bajarte.
			if S.Enabled then
				SettingsVisual.TouchSnapCarSet(false)
			end

			return
		end

		S.Root = root
		S.Seat = seat

		-- El TP de cámara toma el control del vehículo durante unas décimas.
		if S.OneShotBusy then
			SettingsVisual.TouchSnapCarPhase(vehicle)
			return
		end

		SettingsVisual.TouchSnapCarPhase(vehicle)

		--====================================================--
		-- SNAP CAR -> DROPPED ITEM VERTICAL PULSE
		--
		-- NO frena el carro y NO fija X/Z.
		-- Al entrar a <= 5 studs horizontales de un item, cambia SOLO la
		-- altura del Snap durante ~1s para quedar debajo del item.
		-- Si el item está arriba, sube; si está abajo, baja. Después vuelve
		-- automáticamente a la profundidad de Snap que ya tenías.
		--====================================================--

		do
			local now = os.clock()
			local triggerDistance = tonumber(S.ItemTriggerDistance) or 5

			local newItem, newPart, horizontalDistance = nil, nil, math.huge
			if SettingsVisual.FindNearestDroppedItem then
				newItem, newPart, horizontalDistance =
					SettingsVisual.FindNearestDroppedItem(
						root.Position,
						triggerDistance + 2,
						true
					)
			end

			-- El mismo item se rearma solo después de salir de su zona.
			if S.ItemPulseLastItem then
				if not newItem
					or newItem ~= S.ItemPulseLastItem
					or horizontalDistance > (triggerDistance + 1.25) then
					S.ItemPulseLastItem = nil
				end
			end

            if not S.AboveMode and not S.ItemPulseBusy
                and not S.VerticalChaseEnabled
                and now >= (tonumber(S.ItemNextAcquireTime) or 0)
				and newItem
				and newPart
				and horizontalDistance <= triggerDistance
				and newItem ~= S.ItemPulseLastItem then

				S.ItemPulseLastItem = newItem
				S.ItemPulseBusy = true
				S.ItemPulseGeneration = (S.ItemPulseGeneration or 0) + 1
				local generation = S.ItemPulseGeneration

				local rootToBottom = tonumber(S.RootToBottom) or 2.5
				local belowOffset = tonumber(S.ItemPulseBelowOffset) or 4

				-- Coloca el punto más bajo del vehículo debajo del item.
				-- La diferencia de Y decide automáticamente si sube o baja.
				S.ItemPulseTargetRootY =
					newPart.Position.Y - belowOffset + rootToBottom

				task.spawn(function()
					local holdUntil =
						os.clock() + (tonumber(S.ItemPulseHoldTime) or 1.00)

					while S.Enabled
						and S.ItemPulseGeneration == generation
						and os.clock() < holdUntil do

						if newPart and newPart.Parent then
							S.ItemPulseTargetRootY =
								newPart.Position.Y - belowOffset + rootToBottom
						end

						task.wait(0.03)
					end

					if S.ItemPulseGeneration == generation then
						S.ItemPulseBusy = false
						S.ItemPulseTargetRootY = nil
						S.ItemNextAcquireTime = os.clock() + 0.20
					end
				end)
			end
		end

		local nativeThrottle = 0
		local nativeSteer = 0

		pcall(function()
			local throttleFloat = tonumber(seat.ThrottleFloat) or 0
			local throttleInt = tonumber(seat.Throttle) or 0
			local steerFloat = tonumber(seat.SteerFloat) or 0
			local steerInt = tonumber(seat.Steer) or 0

			nativeThrottle =
				math.abs(throttleFloat) >= math.abs(throttleInt)
				and throttleFloat
				or throttleInt

			nativeSteer =
				math.abs(steerFloat) >= math.abs(steerInt)
				and steerFloat
				or steerInt
		end)

		if math.abs(nativeThrottle) < 0.05 then
			nativeThrottle = 0
		end

		if math.abs(nativeSteer) < 0.05 then
			nativeSteer = 0
		end

		if S.NativeForwardHeld and not S.NativeReverseHeld then
			nativeThrottle = 1
		elseif S.NativeReverseHeld and not S.NativeForwardHeld then
			nativeThrottle = -1
		elseif S.NativeForwardHeld and S.NativeReverseHeld then
			nativeThrottle = 0
		end

		if S.NativeSteerTouch then
			nativeSteer = S.NativeSteerAxis
		end

		if nativeThrottle == 0 and nativeSteer == 0 then
			pcall(function()
				local char = Player.Character
				local hum =
					char and char:FindFirstChildOfClass("Humanoid")

				if hum and hum.MoveDirection.Magnitude > 0.05 then
					local carForward =
						SettingsVisual.TouchSnapCarFlatLook(root.CFrame)

					local carRight =
						Vector3.new(
							root.CFrame.RightVector.X,
							0,
							root.CFrame.RightVector.Z
						)

					if carRight.Magnitude > 0.001 then
						carRight = carRight.Unit
					end

					nativeThrottle =
						math.clamp(
							hum.MoveDirection:Dot(carForward),
							-1,
							1
						)

					nativeSteer =
						math.clamp(
							hum.MoveDirection:Dot(carRight),
							-1,
							1
						)
				end
			end)
		end

		-- Vehicle Mode toma el control del volante/acelerador
		-- mientras exista un objetivo válido con la rareza seleccionada.
		if SettingsVisual.VehicleRarityModeEnabled
			and SettingsVisual.VehicleRarityTarget then

			local targetPl =
				SettingsVisual.VehicleRarityTarget

			local targetChar =
				targetPl and targetPl.Character

			local targetHum =
				targetChar and targetChar:FindFirstChildOfClass("Humanoid")

			local targetRoot =
				targetChar and targetChar:FindFirstChild("HumanoidRootPart")

			if targetRoot and targetHum and targetHum.Health > 0 then
				local flatDelta =
					Vector3.new(
						targetRoot.Position.X - root.Position.X,
						0,
						targetRoot.Position.Z - root.Position.Z
					)

				local distance =
					flatDelta.Magnitude

				local stopDistance =
					tonumber(SettingsVisual.VehicleRarityStopDistance) or 7

				local resumeDistance =
					tonumber(SettingsVisual.VehicleRarityResumeDistance) or 10

				-- Zona de espera: sin acelerar ni girar mientras el objetivo siga cerca.
                if SettingsVisual.VehicleRarityArrived then
                    if distance > resumeDistance then
                        SettingsVisual.VehicleRarityArrived = false
                    else
                        nativeThrottle = 0
                        nativeSteer = 0
                        -- Desaceleración progresiva, nunca cortar la velocidad en seco.
                    end
                end

                if not SettingsVisual.VehicleRarityArrived and distance <= stopDistance then
                    SettingsVisual.VehicleRarityArrived = true
                    nativeThrottle = 0
                    nativeSteer = 0
                    -- La rampa de frenado física se aplica más abajo.
                end

				if not SettingsVisual.VehicleRarityArrived
					and distance > 0.01 then

					local desired =
						flatDelta.Unit

					-- Si hay una pared real debajo del mapa, deja de ir
					-- directo contra ella y toma un lado hasta rodearla.
					local avoidDirection, throttleScale =
						SettingsVisual.VehicleModeGetAvoidanceDirection(
							vehicle,
							root,
							targetChar
						)

					if avoidDirection then
						desired = avoidDirection
					end

					local currentForward =
						SettingsVisual.TouchSnapCarFlatLook(root.CFrame)

					local dot =
						math.clamp(
							currentForward:Dot(desired),
							-1,
							1
						)

					local cross =
						(currentForward.X * desired.Z)
						- (currentForward.Z * desired.X)

					local angle =
						math.atan2(cross, dot)

					nativeSteer =
						math.clamp(
							angle / math.rad(62),
							-1,
							1
						)

					-- Frenado anticipado: reducir aceleración antes de llegar.
                    local approach = math.clamp((distance - stopDistance) / 65, 0, 1)
                    nativeThrottle = math.clamp((tonumber(throttleScale) or 1) * approach, 0, 1)
				end
			end
		end

		--====================================================--
		-- PROTECCIÓN DE OBSTÁCULOS - DEFAULT ON
		--
		-- Barra/obstáculo bajo: sube lo suficiente para pasar.
		-- Pared/superficie dura: lift pequeño + reduce velocidad.
		--====================================================--

		local nowObstacle = os.clock()

        -- En vuelo el carro ya va sin colision: no aplicar freno de
        -- choque al acercarse a una pared mientras sube a toda velocidad.
		if S.ObstacleProtectionEnabled
            and not (S.VerticalChaseEnabled and S.VerticalChaseDescending)
            and not S.AboveMode
			and math.abs(nativeThrottle) > 0.05 then

			local currentForward =
				SettingsVisual.TouchSnapCarFlatLook(
					root.CFrame
				)

			local moveDirection =
				nativeThrottle < 0
				and -currentForward
				or currentForward

			if nowObstacle
				>= (tonumber(S.ObstacleCooldownUntil) or 0) then

				local obstacleKind, obstacleDistance =
					SettingsVisual.TouchSnapCarObstacleProbe(
						vehicle,
						root,
						moveDirection
					)

				if obstacleKind == "low"
					and obstacleDistance <= 7 then

					S.ObstacleLiftOffset =
						math.max(
							tonumber(S.ObstacleLiftOffset) or 0,
							tonumber(S.ObstacleLowLift) or 3.2
						)

					S.ObstacleLiftUntil =
						nowObstacle + 0.42

					S.ObstacleCooldownUntil =
						nowObstacle + 0.18

					-- Mantiene bastante avance para pasar la barra.
					nativeThrottle =
						nativeThrottle * 0.82

				elseif obstacleKind == "wall"
					and obstacleDistance <= 6.5 then

					S.ObstacleLiftOffset =
						math.max(
							tonumber(S.ObstacleLiftOffset) or 0,
							tonumber(S.ObstacleWallLift) or 1.35
						)

					S.ObstacleLiftUntil =
						nowObstacle + 0.25

					S.ObstacleCooldownUntil =
						nowObstacle + 0.15

					-- Reduce el golpe antes de llegar a la pared.
					nativeThrottle =
						nativeThrottle * 0.24

					local current =
						tonumber(S.CurrentDriveSpeed) or 0

					if current > 18 then
						S.CurrentDriveSpeed = 18
					elseif current < -18 then
						S.CurrentDriveSpeed = -18
					end
				end
			end
		end

		-- El lift baja suavemente otra vez después de superar el obstáculo.
		if nowObstacle
			> (tonumber(S.ObstacleLiftUntil) or 0) then

			S.ObstacleLiftOffset =
				SettingsVisual.TouchSnapCarMoveTowards(
					tonumber(S.ObstacleLiftOffset) or 0,
					0,
					9 * math.max(dt, 1 / 240)
				)
		end

		local flatLook =
			SettingsVisual.TouchSnapCarFlatLook(root.CFrame)

		local desiredRootY =
			(S.ManualJumpBusy and tonumber(S.ManualJumpTargetY))
			or (S.ItemPulseBusy and tonumber(S.ItemPulseTargetRootY))
			or (S.DesiredRootY or root.Position.Y)
        -- El botón CENTRAL asciende/desciende progresivamente mientras
        -- el carro sigue conduciendo. Nunca corta el avance horizontal.
        local activeRootY = (S.VerticalChaseMode == "down")
            and root.Position.Y or desiredRootY
        if S.VerticalChaseMode == "down" and not S.AboveMode then
            -- Durante la bajada, desplazamiento vertical solamente.
            nativeThrottle = 0
            nativeSteer = 0
            S.CurrentDriveSpeed = 0
            local lowestY = (tonumber(S.SnapGroundY) or root.Position.Y)
                - 2000 + (tonumber(S.RootToBottom) or 2.5) + 0.35
            activeRootY = math.max(lowestY,
                root.Position.Y - (S.VerticalChaseSpeed or 72)
                    * math.clamp(dt, 1 / 240, 0.05))
            if activeRootY <= lowestY + 0.1 then
                -- Tope de seguridad: no sobrepasar la profundidad 2000.
                S.VerticalChaseMode = "stop_down"
                S.VerticalChaseDescending = false
                S.VerticalChaseAnchorXZ = nil
                S.DesiredRootY = activeRootY
                S.DepthMoveActive = false
            end
        elseif S.AboveMode and not S.ManualJumpBusy and not S.ItemPulseBusy then
            local rate = S.AboveLowering and (S.AboveLowerSpeed or 20)
                or (S.AboveMoveSpeed or 24)
            activeRootY = SettingsVisual.TouchSnapCarMoveTowards(
                root.Position.Y, desiredRootY,
                rate * math.clamp(dt, 1 / 240, 0.05))
            if S.AboveLowering and math.abs(activeRootY - desiredRootY) <= 0.22 then
                S.AboveLandingReady = true
            end
        -- Snap Car bajo suelo conserva la transicion de profundidad original.
		elseif S.DepthMoveActive and not S.ManualJumpBusy and not S.ItemPulseBusy then
			local distanceY = math.abs(root.Position.Y - desiredRootY)
			if distanceY > 0.20 then
				activeRootY = SettingsVisual.TouchSnapCarMoveTowards(
					root.Position.Y, desiredRootY,
					(S.VerticalChaseMode == "up"
						and (tonumber(S.VerticalChaseRiseSpeed) or 56)
						or (tonumber(S.DepthMoveSpeed) or 32))
						* math.clamp(dt, 1 / 240, 0.05)
				)
				-- Durante la subida/bajada no acelerar el vehículo en X/Z.
				nativeThrottle = 0
				S.CurrentDriveSpeed = 0
            else
                -- Terminar en la ALTURA OBJETIVO, no en el último fotograma
                -- ligeramente por debajo. El motor mantiene X/Z intactos.
                activeRootY = desiredRootY
                S.DepthMoveActive = false
                S.ItemNextAcquireTime = os.clock() + 0.40
                -- Si llega al techo de 20m (o al inicio si era más alto),
                -- queda en pausa; el siguiente toque comienza otra bajada.
                if S.VerticalChaseMode == "up" then
                    S.VerticalChaseMode = "stop_up"
                    S.VerticalChaseEnabled = true
                    S.VerticalChaseDescending = false
                    S.VerticalChaseHomeY = nil
                    S.VerticalChaseTarget = nil
                    S.VerticalChaseAnchorXZ = nil
                    S.DepthMoveSpeed = 32
                    S.DesiredRootY = desiredRootY
                end
			end
		end

        local chaseXZ = (S.VerticalChaseMode == "down"
            or S.VerticalChaseMode == "up")
            and S.VerticalChaseAnchorXZ
        local uprightRoot =
            SettingsVisual.TouchSnapCarUpright(
                Vector3.new(
                    chaseXZ and chaseXZ.X or root.Position.X,
                    activeRootY
                        + (tonumber(S.ObstacleLiftOffset) or 0),
                    chaseXZ and chaseXZ.Y or root.Position.Z
                ),
				flatLook
			)

		local throttleMagnitude =
			math.clamp(math.abs(nativeThrottle), 0, 1)

		local targetSignedSpeed = 0

		if throttleMagnitude > 0 then
			if nativeThrottle < 0 then
				targetSignedSpeed = -(S.ReverseSpeed or 90) * throttleMagnitude
			else
				targetSignedSpeed = (S.Speed or 90) * throttleMagnitude
			end
		end
        -- Velocidad tope adaptada a este coche sin modificar el slider.
        local snapSafeMax = math.clamp(tonumber(S.SnapVehicleSafeMax) or 140, 28, 200)
        targetSignedSpeed = math.clamp(targetSignedSpeed, -snapSafeMax * 0.65, snapSafeMax)

		local currentSpeed =
			tonumber(S.CurrentDriveSpeed) or 0

		local changingDirection =
			currentSpeed ~= 0
			and targetSignedSpeed ~= 0
			and (
				(currentSpeed > 0 and targetSignedSpeed < 0)
				or
				(currentSpeed < 0 and targetSignedSpeed > 0)
			)

		local rate =
			targetSignedSpeed == 0
				and (S.StopRate or 200)
				or (changingDirection and (S.DirectionRate or 200) or (S.AccelRate or 200))
        -- Frenar y acelerar sin dar un pico físico a los coches lentos.
        rate = math.min(rate, math.max(25, snapSafeMax * 1.15))
        if SettingsVisual.VehicleRarityModeEnabled and SettingsVisual.VehicleRarityArrived then
            rate = math.min(rate, 24) -- amortigua el frenado y evita golpe brusco
        end

		S.CurrentDriveSpeed =
			SettingsVisual.TouchSnapCarMoveTowards(
				currentSpeed,
				targetSignedSpeed,
				rate * math.max(dt, 1 / 240)
			)

		local steerMultiplier =
			math.clamp((tonumber(S.SteerPower) or 200) / 100, 0, 2)

		local turnRadians =
			-nativeSteer
			* 2.8
			* steerMultiplier
			* math.max(throttleMagnitude, 0.42)
			* dt

		local rotatedRoot =
			uprightRoot
			* CFrame.Angles(0, turnRadians, 0)

		local rootToPivot =
			root.CFrame:ToObjectSpace(vehicle:GetPivot())

		pcall(function()
			vehicle:PivotTo(rotatedRoot * rootToPivot)
		end)

		local driveVector =
			rotatedRoot.LookVector
			* S.CurrentDriveSpeed

		root.AssemblyLinearVelocity =
			Vector3.new(
				driveVector.X,
				0,
				driveVector.Z
			)

		root.AssemblyAngularVelocity = Vector3.zero

        -- Ya cerca de la calle, liberar el motor aéreo SIN la rutina
        -- de salida antigua que hacía 14 teleports, paraba el auto y
        -- dejaba 0.35s de ghost. Restaurar la física en plena marcha.
        if S.AboveMode and S.AboveLowering and S.AboveLandingReady then
            S.AboveLandingReady = false
            if SettingsVisual.TouchSnapCarDestroyAvatar then
                SettingsVisual.TouchSnapCarDestroyAvatar()
            end
            SettingsVisual.TouchSnapCarRestore()
            S.Enabled = false
            S.AboveMode = false
            S.AboveLowering = false
            S.SafeStartXZ = nil
            S.SnapGroundY = nil
            S.DesiredRootY = nil
            S.RootToBottom = nil
            S.Vehicle = nil
            S.Root = nil
            S.Seat = nil
            S.Depth = tonumber(S.BaseDepth) or 13
            S.ObstacleLiftOffset = 0
            S.ObstacleLiftUntil = 0
            S.ObstacleCooldownUntil = 0
            if SettingsVisual.ChinoCarHover then
                local hover = SettingsVisual.ChinoCarHover
                hover.Active = false
                hover.Vehicle = nil
                hover.Root = nil
                hover.GroundY = nil
                hover.LastSafeXZ = nil
            end
            btnTP.Text = "Snap Car"
            btnTP.BackgroundColor3 = COLORS.Blue
            -- No tocar AssemblyLinearVelocity: mantiene la inercia al aterrizar.
        end

		-- Si Vehicle Sliders está activo, conserva la animación visual de llantas
		-- también mientras Snap Car es quien controla el movimiento.
		do
			local driveVisual = SettingsVisual.VehicleSliderDriveState
			if driveVisual
				and driveVisual.Enabled
				and driveVisual.UpdateWheelVisuals then
				driveVisual.UpdateWheelVisuals(
					vehicle,
					dt,
					S.CurrentDriveSpeed,
					nativeThrottle
				)
			end
		end

		pcall(function()
			local char = Player.Character
			local hum =
				char and char:FindFirstChildOfClass("Humanoid")

			if hum then
				hum.PlatformStand = false
				hum.Sit = true
			end
		end)
	end)
end

--========================================================--
-- VEHICLE RARITY MODE CONTROLLER
-- Busca objetivo, activa TP Car, lo sigue y sube cuando ya
-- no queda ningún jugador válido con la rareza seleccionada.
--========================================================--

task.spawn(function()
	while Gui and Gui.Parent do
		task.wait(0.12)

		if not SettingsVisual.VehicleRarityModeEnabled then
			continue
		end

		local current = SettingsVisual.VehicleRarityTarget
        local currentValid = false
        local currentInfo = nil
        if current and current == SettingsVisual.SelectedVehiclePlayer and current.Character then
            local hum = current.Character:FindFirstChildOfClass("Humanoid")
            local root = current.Character:FindFirstChild("HumanoidRootPart")
            currentValid = hum ~= nil and hum.Health > 0 and root ~= nil
        end

		if not currentValid then
			local newTarget, newInfo =
				SettingsVisual.FindVehicleRarityTarget()

			if newTarget ~= current then
				SettingsVisual.VehicleRarityArrived = false
				SettingsVisual.VehicleRarityAvoidSide = 0
				SettingsVisual.VehicleRarityAvoidUntil = 0
			end

			SettingsVisual.VehicleRarityTarget =
				newTarget

			SettingsVisual.VehicleRarityTargetInfo =
				newInfo
		else
			SettingsVisual.VehicleRarityTargetInfo =
				currentInfo
		end

		local target =
			SettingsVisual.VehicleRarityTarget

		if target then
			-- Si ya estamos sentados, Mode baja el carro automáticamente.
			if SettingsVisual.TouchSnapCarSet
				and SettingsVisual.TouchSnapCarState
				and not SettingsVisual.TouchSnapCarState.Enabled then

				local success =
					SettingsVisual.TouchSnapCarSet(true)

				if success then
					SettingsVisual.VehicleRarityModeOwnsSnap = true
				end
			end
		else
			SettingsVisual.VehicleRarityArrived = false
			SettingsVisual.VehicleRarityAvoidSide = 0
			SettingsVisual.VehicleRarityAvoidUntil = 0

			-- Ya no existe ningún objetivo con esa rareza:
			-- si Mode fue quien bajó el carro, lo sube automáticamente.
			if SettingsVisual.VehicleRarityModeOwnsSnap
				and SettingsVisual.TouchSnapCarSet
				and SettingsVisual.TouchSnapCarState
				and SettingsVisual.TouchSnapCarState.Enabled then

				SettingsVisual.TouchSnapCarSet(false)
			end

			SettingsVisual.VehicleRarityModeOwnsSnap = false
		end
	end
end)

--========================================================--
-- VEHICLE IMPACT / LOW-OBSTACLE PROTECTION
-- DEFAULT ON
--
-- Fuera de Snap también hace una corrección MUY pequeña:
-- obstáculos bajos = lift corto; pared = lift mínimo + reduce impacto.
--========================================================--

SettingsVisual.VehicleProtectionLastAction = 0

RunService.Heartbeat:Connect(function()
	local S = SettingsVisual.TouchSnapCarState

	if not S
		or not S.ImpactProtectionEnabled
		or not S.ObstacleProtectionEnabled
        or S.Exiting
		or S.Enabled then
		return
	end

	local vehicle, root, seat =
		SettingsVisual.TouchSnapCarGetVehicle()

	if not vehicle or not root or not seat then
		return
	end

	local speedVector =
		Vector3.new(
			root.AssemblyLinearVelocity.X,
			0,
			root.AssemblyLinearVelocity.Z
		)

	if speedVector.Magnitude < 8 then
		return
	end

	local now = os.clock()
	if now - (SettingsVisual.VehicleProtectionLastAction or 0) < 0.18 then
		return
	end

	local direction = speedVector.Unit

	local kind, distance =
		SettingsVisual.TouchSnapCarObstacleProbe(
			vehicle,
			root,
			direction
		)

	if not kind then
		return
	end

	if kind == "low" and distance <= 5.5 then
		SettingsVisual.VehicleProtectionLastAction = now

		pcall(function()
			vehicle:PivotTo(
				vehicle:GetPivot()
				+ Vector3.new(0, 2.2, 0)
			)
		end)

	elseif kind == "wall" and distance <= 4.8 then
		SettingsVisual.VehicleProtectionLastAction = now

		-- Lift muy pequeño y reducción del vector frontal.
		pcall(function()
			vehicle:PivotTo(
				vehicle:GetPivot()
				+ Vector3.new(0, 0.85, 0)
			)

			local v = root.AssemblyLinearVelocity
			root.AssemblyLinearVelocity =
				Vector3.new(
					v.X * 0.38,
					math.max(v.Y, 0),
					v.Z * 0.38
				)

			root.AssemblyAngularVelocity =
				root.AssemblyAngularVelocity * 0.30
		end)
	end
end)

SettingsVisual.TouchNormalSnapToggle = function()
	if SettingsVisual.TouchTargetFollowEnabled and SettingsVisual.SetTouchTargetFollow then
		SettingsVisual.SetTouchTargetFollow(false)
	end

	local char = Player.Character
	if not char then return end
	local root = char:FindFirstChild("HumanoidRootPart")
	if not root then return end

	if not isSnappedDown then
		savedSurfaceY = root.Position.Y
		targetDepth = TouchPanelValue or 20
		local targetY = SettingsVisual.TouchPanelUpMode
			and (savedSurfaceY + targetDepth)
			or (savedSurfaceY - targetDepth)

		isSnappedDown = true
		root.CFrame = CFrame.new(root.Position.X, targetY, root.Position.Z)
		btnTP.Text = SettingsVisual.TouchPanelUpMode and "BAJAR" or "SUBIR"
		btnTP.BackgroundColor3 = Color3.fromRGB(180, 35, 60)
	else
		isSnappedDown = false
		if savedSurfaceY then
			root.CFrame = CFrame.new(root.Position.X, savedSurfaceY + 1.5, root.Position.Z)
		end
		savedSurfaceY = nil
		btnTP.Text = "TP"
		btnTP.BackgroundColor3 = COLORS.Blue
	end
end

local function toggleSnapDown()
	if SettingsVisual.TouchSnapCarShouldUse
		and SettingsVisual.TouchSnapCarShouldUse() then

        -- SNAP APAGADO + caída accidental muy profunda: este toque
        -- RESCATA el coche a la calle; NO lo baja aún más al vacío.
        -- Con Snap activo conserva la salida normal ya existente.
        local snap = SettingsVisual.TouchSnapCarState
        if snap and not snap.Enabled
            and SettingsVisual.TouchCarRescueVoidOnSnapPress
            and SettingsVisual.TouchCarRescueVoidOnSnapPress() then
            return
        end
		SettingsVisual.TouchSnapCarSet(
			not SettingsVisual.TouchSnapCarState.Enabled
		)
		return
	end

	SettingsVisual.TouchNormalSnapToggle()

end

SettingsVisual.SetTouchSnapState = function(state)
	state = state == true
	if state ~= isSnappedDown then
		toggleSnapDown()
	end
end

-- Fuerza únicamente el TP NORMAL del Panel Táctil.
-- No usa la rama de Snap Car aunque el jugador esté cerca/en un vehículo.
SettingsVisual.SetTouchNormalSnapState = function(state)
	state = state == true

	if state == isSnappedDown then
		return
	end

	SettingsVisual.TouchNormalSnapToggle()
end

RunService.Heartbeat:Connect(function(dt)
	if isSnappedDown and savedSurfaceY then
		local char = Player.Character
		local root = char and char:FindFirstChild("HumanoidRootPart")
		local hum = char and char:FindFirstChildOfClass("Humanoid")
		if root and (not hum or not hum.SeatPart) then
			local targetY = SettingsVisual.TouchPanelUpMode
				and (savedSurfaceY + targetDepth)
				or (savedSurfaceY - targetDepth)
			-- Extra moderado de desplazamiento horizontal, solo Snap a pie.
			-- La velocidad queda limitada a 7 studs/s adicionales.
			local extra = Vector3.zero
			if hum and hum.MoveDirection.Magnitude > 0.05 then
				local move = hum.MoveDirection
				local flat = Vector3.new(move.X, 0, move.Z)
				if flat.Magnitude > 0 then
					extra = flat.Unit * (7 * math.clamp(dt, 0, 0.05))
				end
			end
			local p = root.Position + extra
			root.CFrame = CFrame.new(p.X, targetY, p.Z)
			root.Velocity = Vector3.zero
			root.AssemblyLinearVelocity = Vector3.zero
		end
	end
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if SettingsVisual.SelectingGhostKey then return end
	if SettingsVisual.SelectingTouchPanelKey and input.UserInputType == Enum.UserInputType.Keyboard then
		if input.KeyCode ~= Enum.KeyCode.Unknown then
			SettingsVisual.TouchPanelKey = input.KeyCode
			SettingsVisual.SelectingTouchPanelKey = false
			if SettingsVisual.TouchKeyLabel then
				SettingsVisual.TouchKeyLabel.Text = "Key: " .. input.KeyCode.Name
			end
		end
		return
	end
	if not gameProcessed and input.KeyCode == SettingsVisual.TouchPanelKey then
		toggleSnapDown()
	end
end)

btnTP.MouseButton1Click:Connect(toggleSnapDown)

local btnLock = Instance.new("TextButton", TouchCard)
btnLock.Size = UDim2.new(0, 28, 0, 28)
btnLock.Position = UDim2.new(1, -36, 0, 8)
btnLock.BackgroundColor3 = Color3.fromRGB(20, 24, 38)
btnLock.BackgroundTransparency = 0.5
btnLock.BorderSizePixel = 0
btnLock.Text = "🔓"
btnLock.TextColor3 = Color3.fromRGB(255, 255, 255)
btnLock.TextSize = 12
btnLock.ZIndex = 3
Instance.new("UICorner", btnLock).CornerRadius = UDim.new(0, 8)

local isPanelLocked = false
btnLock.MouseButton1Click:Connect(function()
	isPanelLocked = not isPanelLocked
	TouchCard.Draggable = not isPanelLocked
	btnLock.Text = isPanelLocked and "🔒" or "🔓"
end)

local fsInput = Instance.new("TextBox", TouchCard)
fsInput.Size = UDim2.new(1, -16, 0, 24)
fsInput.Position = UDim2.new(0, 8, 0, 42)
fsInput.BackgroundColor3 = Color3.fromRGB(20, 24, 38)
fsInput.BackgroundTransparency = 0.5
fsInput.Text = tostring(TouchPanelValue) .. "m"
fsInput.TextColor3 = Color3.fromRGB(230, 240, 255)
fsInput.TextSize = 11
fsInput.Font = Enum.Font.GothamMedium
fsInput.ZIndex = 3
Instance.new("UICorner", fsInput).CornerRadius = UDim.new(0, 6)

-- Botón de salto circular y semitransparente.
-- IMPORTANTE: no añade variables local nuevas al bloque principal.
local touchCarJumpButton = Instance.new("TextButton", TouchCard)
touchCarJumpButton.Name = "TouchCarJumpButton"
-- Un poco menor para hacer lugar a la flecha vertical de abajo.
touchCarJumpButton.Size = UDim2.fromOffset(34, 34)
touchCarJumpButton.Position = UDim2.new(0.5, -17, 0, 70)
touchCarJumpButton.BackgroundColor3 = Color3.fromRGB(28, 32, 44)
touchCarJumpButton.BackgroundTransparency = 0.75
touchCarJumpButton.BorderSizePixel = 0
touchCarJumpButton.Text = ""
touchCarJumpButton.TextColor3 = Color3.fromRGB(240, 245, 255)
touchCarJumpButton.TextTransparency = 0.22
touchCarJumpButton.TextSize = 9
touchCarJumpButton.Font = Enum.Font.GothamBold
touchCarJumpButton.Visible = false
touchCarJumpButton.Active = true
touchCarJumpButton.AutoButtonColor = true
touchCarJumpButton.ZIndex = 6
Instance.new("UICorner", touchCarJumpButton).CornerRadius = UDim.new(1, 0)
SettingsVisual.TouchCarJumpButton = touchCarJumpButton

-- Botón vertical independiente debajo de P, dentro del mismo panel táctil.
-- PROTEGIDO: crear la flecha dentro de una función diferida. 
-- Así no añadimos registros `local` al gran bloque principal del HUB,
-- lo cual puede impedir que Luau compile y no mostrar ni la intro.
-- Si ocurre un fallo visual en la flecha, debe iniciar el HUB igualmente.
task.defer(function()
    local built, buildError = pcall(function()
        local verticalChaseBtn = Instance.new("TextButton", TouchCard)
verticalChaseBtn.Name = "TouchVerticalChaseArrow"
verticalChaseBtn.Size = UDim2.fromOffset(32, 20)
verticalChaseBtn.Position = UDim2.new(0.5, -16, 0, 110)
verticalChaseBtn.BackgroundColor3 = Color3.fromRGB(34, 28, 54)
verticalChaseBtn.BackgroundTransparency = 0.40
verticalChaseBtn.BorderSizePixel = 0
verticalChaseBtn.Text = ""
verticalChaseBtn.ZIndex = 9
verticalChaseBtn.Visible = false
verticalChaseBtn.AutoButtonColor = true
Instance.new("UICorner", verticalChaseBtn).CornerRadius = UDim.new(0, 6)
local verticalChaseStroke = Instance.new("UIStroke", verticalChaseBtn)
verticalChaseStroke.Thickness = 1
verticalChaseStroke.Transparency = 0.35
verticalChaseStroke.Color = Color3.fromRGB(170, 120, 255)
local arrowHolder = Instance.new("Frame", verticalChaseBtn)
arrowHolder.Name = "ArrowArt"
arrowHolder.Size = UDim2.fromOffset(16, 16)
arrowHolder.AnchorPoint = Vector2.new(0.5, 0.5)
arrowHolder.Position = UDim2.fromScale(0.5, 0.5)
arrowHolder.BackgroundTransparency = 1
arrowHolder.ZIndex = 10
local function arrowPiece(x, y, w, h, deg)
    local piece = Instance.new("Frame", arrowHolder)
    piece.AnchorPoint = Vector2.new(0.5, 0.5)
    piece.Position = UDim2.fromOffset(x, y)
    piece.Size = UDim2.fromOffset(w, h)
    piece.Rotation = deg
    piece.BackgroundColor3 = Color3.fromRGB(237, 218, 255)
    piece.BorderSizePixel = 0
    piece.ZIndex = 11
    Instance.new("UICorner", piece).CornerRadius = UDim.new(1, 0)
    return piece
end
arrowPiece(8, 7, 2, 10, 0)
arrowPiece(5, 11, 2, 8, -45)
arrowPiece(11, 11, 2, 8, 45)
SettingsVisual.TouchVerticalChaseButton = verticalChaseBtn
SettingsVisual.TouchVerticalChaseArrowHolder = arrowHolder
SettingsVisual.TouchVerticalChaseStroke = verticalChaseStroke

verticalChaseBtn.Activated:Connect(function()
    local worked = SettingsVisual.TouchVerticalChaseStep
        and SettingsVisual.TouchVerticalChaseStep()
    if not worked then
        -- Rojo breve si Snap no está debajo del suelo, hay otra acción
        -- simultánea o todavía sigue subiendo; no rompe el GUI si falla.
        verticalChaseBtn.BackgroundColor3 = Color3.fromRGB(150, 45, 62)
        task.delay(0.25, function()
            if verticalChaseBtn and verticalChaseBtn.Parent then
                verticalChaseBtn.BackgroundColor3 = Color3.fromRGB(34, 28, 54)
            end
        end)
    end
end)
    end)
    if not built then
        warn("[CHINOINFIERNO] Error al crear flecha Snap: " .. tostring(buildError))
    end
end)

SettingsVisual.TouchCarSmoothJumpBusy = false
SettingsVisual.TouchCarSmoothJumpLast = 0

--========================================================--
-- BOTÓN CENTRAL CON SNAP CAR SUBTERRÁNEO (P):
-- TP INSTANTÁNEO AL PUNTO DEL ENEMIGO EN ESE ÚNICO INSTANTE.
-- SIN FOLLOW Y SIN RETORNO AUTOMÁTICO: el carro se queda allí.
-- El motor de Snap Car retoma la conducción tras el salto.
--========================================================--
SettingsVisual.TouchCarPTeleportBusy = false
SettingsVisual.TouchCarPTeleportReturnPivot = nil
SettingsVisual.TouchCarPTeleportVehicle = nil
-- Seguro de emergencia exclusivo del botón P. Guarda el punto de salida
-- en la SUPERFICIE antes de mover el carro lejos por debajo del mapa.
-- Si el asiento expulsa al personaje durante el TP o justo al regresar,
-- rescata SOLO el avatar (no deja la cámara en el vacío).
SettingsVisual.TouchCarPRescueIfEjected = function()
    local S = SettingsVisual.TouchSnapCarState
    if not S or not S.PRescuePending then return false end
    local char = S.PRescueCharacter
    local hum = S.PRescueHumanoid
    local savedSeat = S.PRescueSeat
    if not char or not char.Parent or char ~= Player.Character
        or not hum or hum.Health <= 0 then
        S.PRescuePending = false
        return false
    end
    -- SeatPart del Humanoid es el estado más fiable de la montura.
    -- Evita rescates falsos durante un cambio de Occupant de 1 fotograma.
    if hum.SeatPart == savedSeat and savedSeat then
        return false
    end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return false end

    -- El raycast parte apenas arriba del suelo original: evita tomar
    -- por accidente el piso muy lejano o el carro bajo tierra.
    local safeXZ = S.PRescueSafeXZ or root.Position
    local surfaceY = tonumber(S.PRescueSurfaceY) or 0
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = {char, S.PRescueVehicle}
    params.IgnoreWater = true
    local hit = workspace:Raycast(
        Vector3.new(safeXZ.X, surfaceY + 15, safeXZ.Z),
        Vector3.new(0, -34, 0),
        params
    )
    -- Si al costado hay vacío, volver a buscar piso justo en el
    -- origen original, que sí tenía una superficie al activar Snap.
    if (not hit or not hit.Instance.CanCollide) and S.PRescueOriginXZ then
        local original = S.PRescueOriginXZ
        local fallbackHit = workspace:Raycast(
            Vector3.new(original.X, surfaceY + 15, original.Z),
            Vector3.new(0, -34, 0), params
        )
        if fallbackHit and fallbackHit.Instance and fallbackHit.Instance.CanCollide then
            hit = fallbackHit
            safeXZ = original
        end
    end
    if hit and hit.Instance and hit.Instance.CanCollide then
        surfaceY = math.max(surfaceY, hit.Position.Y)
    end

    local destination = Vector3.new(safeXZ.X, surfaceY + 4, safeXZ.Z)
    local rotation = root.CFrame.Rotation
    S.PRescuePending = false  -- exactamente un rescate por sesión P
    local success = pcall(function()
        hum.Sit = false
        char:PivotTo(CFrame.new(destination) * rotation)
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
        hum:ChangeState(Enum.HumanoidStateType.GettingUp)
        -- Durante unos fotogramas impedir que un impulso anterior vuelva
        -- a hundir el avatar antes de que la física detecte el suelo.
        task.spawn(function()
            local untilTime = os.clock() + 0.38
            while os.clock() < untilTime and char.Parent and root.Parent
                and hum.Health > 0 and not hum.SeatPart do
                if root.Position.Y < surfaceY + 2 then
                    char:PivotTo(CFrame.new(destination) * rotation)
                    root.AssemblyLinearVelocity = Vector3.zero
                end
                RunService.Heartbeat:Wait()
            end
        end)
    end)
    if not success then
        warn("[CHINO] Botón P: no se pudo rescatar el personaje a la superficie")
    end
    return success
end

SettingsVisual.TouchCarCancelPTeleport = function()
    local S = SettingsVisual.TouchSnapCarState
    if not S then return end
    -- Al salir de Snap Car no hay TP de regreso: este modo es de punto fijo.
    -- Invalidar cualquier pulso pendiente antes del rescate estándar.
    S.PTeleportGeneration = (S.PTeleportGeneration or 0) + 1
    S.PTeleportReturnPivot = nil
    S.PTeleportVehicle = nil
    S.PTeleportBusy = false
    S.OneShotBusy = false
    SettingsVisual.TouchCarOneShotBusy = false
    SettingsVisual.TouchCarPTeleportBusy = false
end

SettingsVisual.TouchCarPTeleportBelowEnemy = function()
    local S = SettingsVisual.TouchSnapCarState
    if not S or not S.Enabled or S.AboveMode or S.Exiting
        or S.PTeleportBusy or S.OneShotBusy
        or S.ItemPulseBusy or S.ManualJumpBusy
        or SettingsVisual.TouchCarOneShotBusy then
        return false
    end

    local vehicle, root, seat = SettingsVisual.TouchSnapCarGetVehicle()
    if not vehicle or not root or not seat or S.Vehicle ~= vehicle then
        return false
    end
    -- Disponible sólo si el vehículo está por debajo del suelo.
    if not S.SnapGroundY or root.Position.Y >= S.SnapGroundY - 1 then
        return false
    end

    local targetRoot = SettingsVisual.TouchCarGetEnemyAbove
        and select(1, SettingsVisual.TouchCarGetEnemyAbove(vehicle, root, math.huge))
    if not targetRoot or not targetRoot.Parent then return false end

    -- Captura ÚNICA: aunque el objetivo conduzca o corra, nunca se
    -- vuelve a consultar su posición durante este teletransporte.
    local point = targetRoot.Position
    local savedY = root.Position.Y
    local savedLook = SettingsVisual.TouchSnapCarFlatLook(root.CFrame)
    local rootToPivot = root.CFrame:ToObjectSpace(vehicle:GetPivot())
    local playerChar = Player.Character
    local playerHum = playerChar and playerChar:FindFirstChildOfClass("Humanoid")
    if not playerHum or playerHum.SeatPart ~= seat then return false end
    local _, bboxSize = vehicle:GetBoundingBox()
    local right = Vector3.new(root.CFrame.RightVector.X, 0, root.CFrame.RightVector.Z)
    if right.Magnitude < 0.01 then right = Vector3.xAxis end
    local rescueXZ = root.Position + right.Unit * (bboxSize.X * 0.5 + 5)
    local generation = (S.PTeleportGeneration or 0) + 1
    S.PTeleportGeneration = generation
    -- Conservar el seguro de expulsión del conductor que ya existía.
    S.PRescuePending = true
    S.PRescueGeneration = generation
    S.PRescueCharacter = playerChar
    S.PRescueHumanoid = playerHum
    S.PRescueSeat = seat
    S.PRescueVehicle = vehicle
    S.PRescueSafeXZ = rescueXZ
    S.PRescueOriginXZ = root.Position
    S.PRescueSurfaceY = S.SnapGroundY
    S.PRescueExpiresAt = os.clock() + 2.5

    S.PTeleportBusy = true
    S.PTeleportVehicle = vehicle
    S.PTeleportReturnPivot = nil -- NUNCA regresar al origen automáticamente
    S.OneShotBusy = true
    SettingsVisual.TouchCarOneShotBusy = true
    SettingsVisual.TouchCarPTeleportBusy = true

    task.spawn(function()
        while S.PRescuePending and S.PRescueGeneration == generation
            and Player.Character == playerChar
            and os.clock() < (S.PRescueExpiresAt or 0) do
            if SettingsVisual.TouchCarPRescueIfEjected() then break end
            task.wait(0.04)
        end
        if S.PRescueGeneration == generation then
            S.PRescuePending = false
            S.PRescueCharacter = nil
            S.PRescueHumanoid = nil
            S.PRescueSeat = nil
            S.PRescueVehicle = nil
            S.PRescueSafeXZ = nil
            S.PRescueOriginXZ = nil
            S.PRescueSurfaceY = nil
        end
    end)

    -- Un solo PivotTo al punto congelado. Sin bucle de seguimiento,
    -- sin actualizar el objetivo y sin segundo PivotTo al punto anterior.
    local ok, err = pcall(function()
        SettingsVisual.TouchSnapCarPhase(vehicle)
        local atPoint = SettingsVisual.TouchSnapCarUpright(
            Vector3.new(point.X, savedY, point.Z), savedLook
        )
        vehicle:PivotTo(atPoint * rootToPivot)
        SettingsVisual.TouchSnapCarZeroMotion(vehicle, root)
    end)
    if not ok then
        warn("[CHINO] TP único de Snap Car: " .. tostring(err))
    end

    -- Liberar el motor estándar después de unos fotogramas, permaneciendo
    -- en la posición del enemigo al momento del toque.
    task.delay(0.12, function()
        if S.PTeleportGeneration ~= generation then return end
        if not ok then
            pcall(SettingsVisual.TouchCarPRescueIfEjected)
        end
        S.PTeleportReturnPivot = nil
        S.PTeleportVehicle = nil
        S.PTeleportBusy = false
        S.OneShotBusy = false
        S.CurrentDriveSpeed = 0
        SettingsVisual.TouchCarOneShotBusy = false
        SettingsVisual.TouchCarPTeleportBusy = false
    end)
    return ok
end

--========================================================--
-- CHINO - ELEVACION CENTRAL SUAVE (19 STUDS SOBRE SUELO)
-- Misma conducción de Snap Car, pero ascenso gradual desde altura ACTUAL.
-- Mantiene la velocidad horizontal; sin teletransporte inicial.
-- Al desactivar, desciende progresivamente y restaura colisiones al tocar suelo.
--========================================================--
do
    local hover = {Active = false, Vehicle = nil, Root = nil}
    SettingsVisual.ChinoCarHover = hover

    local function disconnect(con)
        if con then pcall(function() con:Disconnect() end) end
    end

    local function findFloor(vehicle, position)
        local params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Exclude
        params.IgnoreWater = true
        local ignore = {vehicle}
        if Player.Character then table.insert(ignore, Player.Character) end
        local others = workspace:FindFirstChild("Vehicles")
        if others then table.insert(ignore, others) end
        params.FilterDescendantsInstances = ignore
        local hit = workspace:Raycast(position + Vector3.new(0,8,0),
            Vector3.new(0,-320,0),params)
        return hit and hit.Position.Y or nil
    end
    SettingsVisual.ChinoCarHoverFindFloor = findFloor

    local function stopHover()
        local S = SettingsVisual.TouchSnapCarState
        if S and S.AboveMode and S.Enabled and not S.Exiting then
            -- Solo programar el aterrizaje. El Heartbeat conduce y baja Y
            -- gradualmente, sin teletransporte ni frenar el carro de golpe.
            local ground = nil
            if S.Vehicle and S.Root then
                ground = findFloor(S.Vehicle, S.Root.Position)
            end
            ground = ground or S.SnapGroundY
            if not ground then return false end
            S.DesiredRootY = ground + (tonumber(S.RootToBottom) or 2.5) + 1.65
            S.AboveLowering = true
            S.AboveLandingReady = false
            return true
        end
        hover.Active = false
        hover.Vehicle = nil
        hover.Root = nil
        hover.GroundY = nil
        hover.LastSafeXZ = nil
        return true
    end
    SettingsVisual.ChinoCarHoverStop = stopHover

    local function toggleHover()
        local S = SettingsVisual.TouchSnapCarState
        if not S or S.Exiting or S.OneShotBusy then return false end
        if S.AboveMode and S.Enabled then
            if S.AboveLowering then
                -- Re-activar en plena bajada: subir suave desde Y ACTUAL.
                S.AboveLowering = false
                S.AboveLandingReady = false
                S.DesiredRootY = (S.SnapGroundY or (S.Root and S.Root.Position.Y) or 0)
                    + (S.AboveHeightStuds or 19)
                    + (tonumber(S.RootToBottom) or 2.5) + 0.35
                return true
            end
            return stopHover()
        end
        -- Snap Car profundo conserva exclusivamente el botón P.
        if S.Enabled then return false end

        local vehicle, root, seat = SettingsVisual.TouchSnapCarGetVehicle()
        local char = Player.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not vehicle or not root or not seat or not hum
            or hum.SeatPart ~= seat then return false end
        if not findFloor(vehicle,root.Position) then
            warn("[CHINO] Elevar: no se encontró un piso debajo del auto")
            return false
        end

        S.AboveMode = true
        S.AboveHeightStuds = 19 -- Algo mas bajito que antes; unos 5 metros.
        local ok, success = pcall(SettingsVisual.TouchSnapCarSet, true)
        if not ok or not success then
            S.AboveMode = false
            hover.Active = false
            warn("[CHINO] No pudo iniciarse elevación: " .. tostring(success))
            return false
        end
        hover.Active = true
        hover.Vehicle = vehicle
        hover.Root = root
        hover.GroundY = S.SnapGroundY
        hover.LastSafeXZ = S.SafeStartXZ
        return true
    end
    SettingsVisual.ChinoCarHoverToggle = toggleHover

    -- Rescate sanitario: con 20 HP o menos, salir del asiento.
    -- Se guarda primero la referencia de suelo (especialmente con Snap).
    -- No actúa en personajes que están a pie.
    local healthCon
    local function bindCritical(char)
        disconnect(healthCon)
        healthCon=nil
        local hum=char and (char:FindFirstChildOfClass("Humanoid")
            or char:WaitForChild("Humanoid",5))
        if not hum then return end
        local running=false
        healthCon=hum.HealthChanged:Connect(function(hp)
            if hp>20 or hp<=0 or running then return end
            local seat=hum.SeatPart
            if not seat or not seat:IsA("VehicleSeat") then return end
            local vehicle=seat:FindFirstAncestorOfClass("Model")
            if not vehicle then return end
            local root=vehicle.PrimaryPart or seat.AssemblyRootPart or seat
            root=root and (root.AssemblyRootPart or root)
            if not root then return end
            running=true
            task.spawn(function()
                local snap=SettingsVisual.TouchSnapCarState
                local recovery=SettingsVisual.TouchCarVoidRecovery
                local ground=(snap and snap.Enabled and snap.SnapGroundY)
                    or (hover.Active and hover.Vehicle==vehicle and hover.GroundY)
                    or (recovery and recovery.SurfaceY)
                    or findFloor(vehicle,root.Position,95)
                local safeXZ=(recovery and recovery.SafeXZ) or hover.LastSafeXZ or root.Position
                -- Si el auto está en Snap, subimos ANTES de desasentar, pues
                -- TouchSnapCarSet ya tiene su propia salida/collisions protegidas.
                if snap and snap.Enabled and SettingsVisual.TouchSnapCarSet then
                    pcall(function() SettingsVisual.TouchSnapCarSet(false) end)
                end
                if hover.Active and hover.Vehicle==vehicle then stopHover() end
                pcall(function()
                    hum.Sit=false
                    hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                end)
                task.wait(0.12)
                if hum.SeatPart==seat then
                    pcall(function()
                        hum.Sit=false
                        hum.Jump=true
                        hum:ChangeState(Enum.HumanoidStateType.Jumping)
                    end)
                end
                if not vehicle.Parent or not root.Parent then running=false;return end
                -- Para la salida de emergencia recolocar SOBRE piso, no
                -- mantener un coche flotando/atravesado por el suelo.
                local surface=findFloor(vehicle,root.Position,110)
                if not surface and safeXZ and ground then
                    surface=findFloor(vehicle,Vector3.new(safeXZ.X,ground+15,safeXZ.Z),80)
                end
                surface=surface or ground
                if surface then
                    local bbox,bbsize=vehicle:GetBoundingBox()
                    local rootBottom=root.Position.Y-(bbox.Position.Y-bbsize.Y*0.5)
                    local where=root.Position
                    if not findFloor(vehicle,where,110) and safeXZ then where=safeXZ end
                    local destination=Vector3.new(where.X,surface+math.max(rootBottom,0.4)+2,where.Z)
                    local pivotOffset=root.CFrame:ToObjectSpace(vehicle:GetPivot())
                    local saved={}
                    pcall(function()
                        for _,part in ipairs(vehicle:GetDescendants()) do
                            if part:IsA("BasePart") then
                                saved[part]={part.CanCollide,part.CanTouch}
                                part.CanCollide=false;part.CanTouch=false
                            end
                        end
                        vehicle:PivotTo(SettingsVisual.TouchSnapCarUpright(
                            destination,SettingsVisual.TouchSnapCarFlatLook(root.CFrame)) * pivotOffset)
                        root.AssemblyLinearVelocity=Vector3.zero
                        root.AssemblyAngularVelocity=Vector3.zero
                    end)
                    task.wait(0.16)
                    for part,old in pairs(saved) do
                        if part.Parent then
                            pcall(function() part.CanCollide=old[1];part.CanTouch=old[2] end)
                        end
                    end
                end
                running=false
            end)
        end)
    end
    bindCritical(Player.Character)
    Player.CharacterAdded:Connect(bindCritical)
end

touchCarJumpButton.Activated:Connect(function()
    -- Cuando Snap Car esté bajo piso conserva el botón P del TP especial.
    local S=SettingsVisual.TouchSnapCarState
    if S and S.Enabled and not S.AboveMode then
        SettingsVisual.TouchCarPTeleportBelowEnemy()
        return
    end
    if SettingsVisual.ChinoCarHoverToggle then
        SettingsVisual.ChinoCarHoverToggle()
    end
end)

--========================================================--
-- DROPPED ITEM DISTANCE TRACKER - PANEL TÁCTIL
--
-- SOLO cambia el número del panel.
-- NO ejecuta TP automáticamente.
-- Se queda con el mismo objeto hasta que desaparece.
--========================================================--

SettingsVisual.TouchItemDistanceTarget = nil
SettingsVisual.TouchItemDistanceSavedValue = nil
SettingsVisual.TouchItemDistanceMaxAcquire = 50

-- Si el usuario escribe manualmente una distancia en el panel táctil,
-- el escáner automático queda congelado en ese valor hasta el próximo respawn.
SettingsVisual.TouchItemDistanceManualLocked = false
SettingsVisual.TouchItemDistanceManualValue = nil

SettingsVisual.GetDroppedItemsFolder = function()
	return workspace:FindFirstChild("DroppedItems")
		or workspace:FindFirstChild("DroppedItem")
		or DroppedItems
end

SettingsVisual.GetDroppedItemAnchor = function(item)
	if not item or not item.Parent then
		return nil
	end

	if item:IsA("BasePart") then
		return item
	end

	if not item:IsA("Model") then
		return nil
	end

	local pickup =
		item:FindFirstChild("PickUpZone", true)

	if pickup and not pickup:IsA("BasePart") then
		pickup = nil
	end

	return pickup
		or item.PrimaryPart
		or item:FindFirstChildWhichIsA("BasePart", true)
end

SettingsVisual.IsDroppedItemUnderground = function(item, part)
	if not item or not part or not part.Parent then
		return false
	end

	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Exclude
	params.IgnoreWater = true

	local exclude = {
		item
	}

	if Player.Character then
		table.insert(exclude, Player.Character)
	end

	params.FilterDescendantsInstances = exclude

	-- Buscamos una superficie REAL arriba del item.
	-- Si hay piso/terreno anclado varios studs arriba, lo consideramos underground.
	local result =
		workspace:Raycast(
			part.Position + Vector3.new(0, 0.5, 0),
			Vector3.new(0, 60, 0),
			params
		)

	if not result then
		return false
	end

	local hit = result.Instance
	local realSurface =
		hit == workspace.Terrain
		or (
			hit
			and hit:IsA("BasePart")
			and hit.Anchored
		)

	if not realSurface then
		return false
	end

	local verticalGap =
		result.Position.Y - part.Position.Y

	-- Evita detectar objetos normales apoyados justo sobre el piso.
	return verticalGap >= 2
end

SettingsVisual.FindNearestDroppedItem = function(origin, maxDistance, horizontalOnly)
	if typeof(origin) ~= "Vector3" then
		return nil, nil, math.huge
	end

	local folder =
		SettingsVisual.GetDroppedItemsFolder()

	if not folder then
		return nil, nil, math.huge
	end

	local bestItem = nil
	local bestPart = nil
	local bestDistance = math.huge

	for _, item in ipairs(folder:GetChildren()) do
		local part =
			SettingsVisual.GetDroppedItemAnchor(item)

		if part then
			local delta =
				part.Position - origin

			local distance

			if horizontalOnly then
				distance =
					Vector3.new(
						delta.X,
						0,
						delta.Z
					).Magnitude
			else
				distance = delta.Magnitude
			end

			if distance < bestDistance
				and (
					not maxDistance
					or distance <= maxDistance
				) then

				bestItem = item
				bestPart = part
				bestDistance = distance
			end
		end
	end

	return bestItem, bestPart, bestDistance
end

SettingsVisual.RestoreTouchItemManualValue = function()
	if SettingsVisual.TouchItemDistanceSavedValue ~= nil then
		TouchPanelValue =
			tonumber(
				SettingsVisual.TouchItemDistanceSavedValue
			)
			or TouchPanelValue

		SettingsVisual.TouchItemDistanceSavedValue = nil

		if fsInput and fsInput.Parent then
			fsInput.Text =
				tostring(
					math.floor(
						TouchPanelValue + 0.5
					)
				)
				.. "m"
		end
	end

	SettingsVisual.TouchItemDistanceTarget = nil
end

task.spawn(function()
	while TouchPanelGui and TouchPanelGui.Parent do
		task.wait(0.08)

		-- Panel apagado: vuelve al valor manual anterior.
		if not TouchPanelGui.Enabled then
			SettingsVisual.RestoreTouchItemManualValue()
			continue
		end

		local snapTrackerActive =
			SettingsVisual.TouchSnapCarState
			and SettingsVisual.TouchSnapCarState.Enabled

		-- Fuera de Snap conservamos el bloqueo manual viejo. Dentro de Snap,
		-- la profundidad queda guardada en S.Depth y el cuadro puede seguir
		-- mostrando la distancia al item sin cambiar esa profundidad.
		if SettingsVisual.TouchItemDistanceManualLocked and not snapTrackerActive then
			local manualValue = tonumber(SettingsVisual.TouchItemDistanceManualValue)
			if manualValue then
				TouchPanelValue = math.clamp(manualValue, 5, 100)
				if fsInput and fsInput.Parent and UserInputService:GetFocusedTextBox() ~= fsInput then
					fsInput.Text = tostring(TouchPanelValue) .. "m"
				end
			end
			continue
		end

		-- En modo TP hacia arriba no interferimos con su valor 50.
		if SettingsVisual.TouchPanelUpMode then
			continue
		end

		-- Mientras YA estás abajo, congelamos el valor con el que bajaste.
		-- Así nunca te mueve automáticamente al acercarte/alejarte.
		if isSnappedDown then
			continue
		end

		-- Bajo Snap Car el campo muestra SIEMPRE la profundidad configurada.
		-- No sobrescribir la profundidad manual (hasta 2000) con distancias a DroppedItems.
		if SettingsVisual.TouchSnapCarState
			and SettingsVisual.TouchSnapCarState.Enabled then
			if UserInputService:GetFocusedTextBox() ~= fsInput then
				local S = SettingsVisual.TouchSnapCarState
				fsInput.Text = tostring(math.clamp(math.floor((tonumber(S.Depth) or TouchPanelValue or 20) + 0.5), 5, 2000)) .. "m"
			end
			continue
		end

		-- No sobrescribe el número mientras lo estás editando con el teclado.
		if UserInputService:GetFocusedTextBox() == fsInput then
			continue
		end

		local char = Player.Character
		local root =
			char and char:FindFirstChild("HumanoidRootPart")

		if not root then
			continue
		end

		local folder =
			SettingsVisual.GetDroppedItemsFolder()

		local target =
			SettingsVisual.TouchItemDistanceTarget

		local targetValid =
			target
			and folder
			and target.Parent == folder

		local targetPart =
			targetValid
			and SettingsVisual.GetDroppedItemAnchor(target)
			or nil

		if targetPart
			and not SettingsVisual.IsDroppedItemUnderground(
				target,
				targetPart
			) then

			targetPart = nil
			SettingsVisual.TouchItemDistanceTarget = nil
		end

		-- SOLO busca otro cuando el anterior ya desapareció.
		if not targetPart then
			local newTarget, newPart =
				SettingsVisual.FindNearestDroppedItem(
					root.Position,
					tonumber(
						SettingsVisual.TouchItemDistanceMaxAcquire
					) or 40,
					false
				)

			if newTarget
				and newPart
				and SettingsVisual.IsDroppedItemUnderground(
					newTarget,
					newPart
				) then
				if SettingsVisual.TouchItemDistanceSavedValue == nil then
					SettingsVisual.TouchItemDistanceSavedValue =
						TouchPanelValue
				end

				SettingsVisual.TouchItemDistanceTarget =
					newTarget

				target = newTarget
				targetPart = newPart
			else
				SettingsVisual.RestoreTouchItemManualValue()
				continue
			end
		end

		-- Cambia únicamente el valor visible/que usará el próximo TP.
		local distance =
			(targetPart.Position - root.Position).Magnitude

		local displayDistance =
			math.clamp(
				math.floor(distance + 0.5),
				1,
				100
			)

		TouchPanelValue = displayDistance

		if fsInput and fsInput.Parent then
			fsInput.Text =
				tostring(displayDistance) .. "m"
		end

		-- IMPORTANTE:
		-- NO tocamos targetDepth aquí.
		-- targetDepth se captura únicamente cuando tú presionas TP.
	end
end)

local keyLabelTP = Instance.new("TextButton", TouchCard)
keyLabelTP.Size = UDim2.new(1, -72, 0, 22)
keyLabelTP.Position = UDim2.new(0, 34, 0, 82)
keyLabelTP.BackgroundTransparency = 1
keyLabelTP.Text = "Key: " .. SettingsVisual.TouchPanelKey.Name
keyLabelTP.TextColor3 = COLORS.Muted
keyLabelTP.AutoButtonColor = false
keyLabelTP.TextSize = 11
keyLabelTP.Font = Enum.Font.Gotham
keyLabelTP.TextXAlignment = Enum.TextXAlignment.Center
keyLabelTP.ZIndex = 3
SettingsVisual.TouchKeyLabel = keyLabelTP

SettingsVisual.TouchTargetFollowEnabled = false
SettingsVisual.TouchTargetFollowPlayer = nil
SettingsVisual.TouchTargetFollowDistance = 5

--========================================================--
-- CASILLA IZQUIERDA EN CARRO:
-- FAST SNAP AL ENEMIGO DE ARRIBA + REGRESO
--
-- FIX DE SUPERFICIE:
--   * Sube EXACTAMENTE al X/Z del jugador de arriba (sin +4 al frente).
--   * Mientras cruza el piso, carro + personaje quedan full ghost.
--   * Busca la superficie real bajo el objetivo.
--   * Calcula RootToBottom del vehículo para dejar el punto más bajo apenas
--     sobre el pavimento y endereza el carro antes de devolver colisión.
--   * Mientras está arriba, ese piso se marca como soporte forzado para que
--     Wallhack no lo vuelva noclip debajo de las llantas.
--========================================================--

SettingsVisual.TouchCarOneShotBusy = false
SettingsVisual.TouchCarOneShotMaxHorizontal = 125
SettingsVisual.TouchCarOneShotHoldTime = 0.35 -- izquierda, sin cambios
SettingsVisual.TouchCarOneShotUpSpeed = 210
SettingsVisual.TouchCarOneShotReturnSpeed = 280
SettingsVisual.TouchCarOneShotSurfaceClearance = 0.18

SettingsVisual.TouchCarGetEnemyAbove = function(vehicle, root, maxHorizontal)
    if not vehicle or not root then
        return nil, nil
    end

    local function valid(pl)
        if not pl or pl == Player or not pl.Character then
            return nil, nil
        end

        local hum = pl.Character:FindFirstChildOfClass("Humanoid")
        local targetRoot = pl.Character:FindFirstChild("HumanoidRootPart")

        if not hum or hum.Health <= 0 or not targetRoot then
            return nil, nil
        end

        if targetRoot.Position.Y <= root.Position.Y + 7 then
            return nil, nil
        end

        local horizontal = Vector3.new(
            targetRoot.Position.X - root.Position.X,
            0,
            targetRoot.Position.Z - root.Position.Z
        ).Magnitude

        if horizontal > (tonumber(maxHorizontal) or tonumber(SettingsVisual.TouchCarOneShotMaxHorizontal) or 125) then
            return nil, nil
        end

        return targetRoot, horizontal
    end

    -- Prioridad al objetivo que ya está marcando Target Line.
    for _, preferred in ipairs({CurrentLockedTarget, SettingsVisual.DirectVisualLockedTarget, CurrentTarget}) do
        local targetRoot = select(1, valid(preferred))
        if targetRoot then
            return targetRoot, preferred
        end
    end

    local bestRoot = nil
    local bestPlayer = nil
    local bestHorizontal = math.huge

    for _, pl in ipairs(Players:GetPlayers()) do
        local targetRoot, horizontal = valid(pl)
        if targetRoot and horizontal < bestHorizontal then
            bestHorizontal = horizontal
            bestRoot = targetRoot
            bestPlayer = pl
        end
    end

    return bestRoot, bestPlayer
end

SettingsVisual.TouchCarGetLandingSurface = function(vehicle, targetRoot)
    if not vehicle or not targetRoot then
        return nil, nil
    end

    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.IgnoreWater = true

    local ignore = {vehicle}
    if Player.Character then
        table.insert(ignore, Player.Character)
    end
    if targetRoot.Parent then
        table.insert(ignore, targetRoot.Parent)
    end

    -- Si el enemigo está sobre otro carro, queremos el pavimento/floor real
    -- debajo, no aterrizar encima del vehículo ajeno.
    local vehicles = workspace:FindFirstChild("Vehicles")
    if vehicles then
        table.insert(ignore, vehicles)
    end

    params.FilterDescendantsInstances = ignore

    -- Empieza apenas arriba del jugador objetivo. Si está dentro de una casa,
    -- el primer impacto hacia abajo será el piso de ESA habitación, no el techo.
    local origin = targetRoot.Position + Vector3.new(0, 2.5, 0)
    local result = workspace:Raycast(
        origin,
        Vector3.new(0, -120, 0),
        params
    )

    if result then
        return result.Position.Y, result.Instance
    end

    -- Fallback: aproximación desde los pies del objetivo.
    return targetRoot.Position.Y - 3.15, nil
end

SettingsVisual.TouchCarRestoreVehicleSurfaceCollision = function(vehicle)
    local S = SettingsVisual.TouchSnapCarState
    if not vehicle or not S then return end

    local function restoreParts(parent)
        if not parent then return end
        for _, obj in ipairs(parent:GetDescendants()) do
            if obj:IsA("BasePart") then
                local props = S.OriginalProps and S.OriginalProps[obj]
                if props then
                    pcall(function()
                        obj.CanCollide = props.CanCollide
                        obj.CanTouch = props.CanTouch
                        obj.CanQuery = props.CanQuery
                    end)
                    S.OriginalProps[obj] = nil
                end
            end
        end
    end

    restoreParts(vehicle)
    -- FullGhost afecta tambien al conductor: restaurar sus partes al finalizar.
    if not S.Enabled then restoreParts(Player.Character) end
end

SettingsVisual.TouchCarFastMove = function(
    vehicle,
    root,
    targetPosition,
    maxSpeed,
    timeout
)
    if not vehicle or not root or typeof(targetPosition) ~= "Vector3" then
        return false
    end

    local started = os.clock()

    while vehicle.Parent
        and root.Parent
        and os.clock() - started < timeout do

        -- Snap Car ya mantiene el vehículo en su estado normal de phase.
        -- La casilla izquierda NO cambia aquí la colisión del carro: solo del piso.
        local delta = targetPosition - root.Position
        local distance = delta.Magnitude

        if distance <= 0.65 then
            return true
        end

        local direction = distance > 0.001 and delta.Unit or Vector3.zero
        local speed = math.clamp(distance * 11, 60, maxSpeed)

        pcall(function()
            root.AssemblyLinearVelocity = direction * speed
            root.AssemblyAngularVelocity = Vector3.zero
        end)

        RunService.Heartbeat:Wait()
    end

    return false
end

-- Memoria de la casilla derecha: conserva el último objetivo válido de Target Line.
SettingsVisual.TouchCarLastRightTarget = nil
SettingsVisual.TouchCarLastRightTargetPosition = nil
SettingsVisual.TouchCarDropSearchRadius = 42

SettingsVisual.TouchCarRememberRightTarget = function()
    local candidate = CurrentLockedTarget or SettingsVisual.DirectVisualLockedTarget or CurrentTarget
    local char = candidate and candidate.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if candidate and hum and hum.Health > 0 and hrp then
        SettingsVisual.TouchCarLastRightTarget = candidate
        SettingsVisual.TouchCarLastRightTargetPosition = hrp.Position
        return candidate, hrp
    end

    local remembered = SettingsVisual.TouchCarLastRightTarget
    local rememberedChar = remembered and remembered.Character
    local rememberedRoot = rememberedChar and rememberedChar:FindFirstChild("HumanoidRootPart")
    if rememberedRoot then
        SettingsVisual.TouchCarLastRightTargetPosition = rememberedRoot.Position
        return remembered, rememberedRoot
    end
    return remembered, nil
end

SettingsVisual.TouchCarGetTargetDropPart = function()
    local anchor = SettingsVisual.TouchCarLastRightTargetPosition
    if not anchor then return nil end
    local folder = workspace:FindFirstChild("DroppedItems") or workspace:FindFirstChild("DroppedItem") or DroppedItems
    if not folder then return nil end

    local bestPart, bestDist = nil, math.huge
    local radius = tonumber(SettingsVisual.TouchCarDropSearchRadius) or 42
    for _, item in ipairs(folder:GetChildren()) do
        if item:IsA("Model") then
            local pickup = item:FindFirstChild("PickUpZone", true)
            local part = nil
            if pickup and pickup:IsA("BasePart") then
                part = pickup
            elseif pickup and pickup:IsA("Attachment") and pickup.Parent and pickup.Parent:IsA("BasePart") then
                part = pickup.Parent
            end
            part = part or item.PrimaryPart or item:FindFirstChildWhichIsA("BasePart", true)
            if part then
                local dist = (part.Position - anchor).Magnitude
                if dist <= radius and dist < bestDist then
                    bestPart, bestDist = part, dist
                end
            end
        end
    end
    return bestPart
end

-- Casilla derecha desde superficie: distingue interiores por techo y busca
-- espacio libre para el volumen completo del vehículo antes de moverlo.
SettingsVisual.TouchCarFindClearRightPosition = function(vehicle, targetRoot, boxSize, boxCenterOffset, rootToBottom)
    local ignore = {vehicle}
    if Player.Character then table.insert(ignore, Player.Character) end
    if targetRoot.Parent then table.insert(ignore, targetRoot.Parent) end
    -- No excluir otros vehículos: sus carrocerías son obstáculos reales.
    -- Esto evita colocar nuestro coche dentro del coche del objetivo.

    local ray = RaycastParams.new()
    ray.FilterType = Enum.RaycastFilterType.Exclude
    ray.FilterDescendantsInstances = ignore
    ray.IgnoreWater = true
    local roofHit = workspace:Raycast(targetRoot.Position + Vector3.new(0, 2, 0), Vector3.new(0, 28, 0), ray)
    local indoors = roofHit ~= nil and roofHit.Instance.CanCollide

    local overlap = OverlapParams.new()
    overlap.FilterType = Enum.RaycastFilterType.Exclude
    overlap.FilterDescendantsInstances = ignore
    overlap.MaxParts = 80

    -- Dentro: base del carro 5 studs debajo del piso de la habitación.
    -- Fuera: base del carro 5 studs encima del objetivo.
    local floorY = select(1, SettingsVisual.TouchCarGetLandingSurface(vehicle, targetRoot))
    if not floorY then return nil end
    local baseY = indoors and (floorY - 5) or (targetRoot.Position.Y + 5)
    local halfHeight = boxSize.Y * 0.5
    -- Margen de seguridad para paredes, vehículos en movimiento y esquinas.
    local footprint = Vector3.new(math.max(boxSize.X + 2, 1), math.max(boxSize.Y + 1, 1), math.max(boxSize.Z + 2, 1))
    local offsets = {Vector2.new(0, 0)}
    for _, r in ipairs({4, 8, 12, 17, 23, 30}) do
        for i = 0, 11 do
            local a = i * math.pi / 6
            table.insert(offsets, Vector2.new(math.cos(a) * r, math.sin(a) * r))
        end
    end

    -- Pequeña anticipación del vehículo enemigo; no perseguir su velocidad
    -- durante el TP, porque los cambios bruscos provocan choques.
    local vel = targetRoot.AssemblyLinearVelocity
    local lead = Vector3.new(
        math.clamp(vel.X * 0.08, -2, 2), 0,
        math.clamp(vel.Z * 0.08, -2, 2)
    )
    for _, off in ipairs(offsets) do
        local x, z = targetRoot.Position.X + lead.X + off.X, targetRoot.Position.Z + lead.Z + off.Y
        local boxPos = Vector3.new(x, baseY + halfHeight, z)
        local hits = workspace:GetPartBoundsInBox(CFrame.new(boxPos), footprint, overlap)
        local blocked = false
        for _, hit in ipairs(hits) do
            if hit:IsA("BasePart") and hit.CanCollide then
                blocked = true
                break
            end
        end
        if not blocked then
            -- Revisión de último momento: otro coche puede entrar en la zona.
            local again = workspace:GetPartBoundsInBox(CFrame.new(boxPos), footprint, overlap)
            for _, hit in ipairs(again) do
                if hit:IsA("BasePart") and hit.CanCollide then blocked = true break end
            end
            if not blocked then
                return Vector3.new(x - boxCenterOffset.X, baseY + rootToBottom, z), indoors
            end
        end
    end
    return nil, indoors -- Sin espacio comprobado: no meter el coche en una pared.
end

SettingsVisual.TouchCarOneShotTeleport = function(allowSurface, overrideTargetPart, pulseCount)
    if SettingsVisual.TouchCarOneShotBusy then
        return false
    end

    local S = SettingsVisual.TouchSnapCarState

    -- Izquierda exige Snap Car; derecha puede reutilizar la rutina desde superficie.
    local surfaceMode = allowSurface == true and S and not S.Enabled
    if not S or (not S.Enabled and not surfaceMode) then
        return false
    end

    local vehicle, root, seat = SettingsVisual.TouchSnapCarGetVehicle()
    if not vehicle or not root or not seat then
        return false
    end

    local targetRoot = nil
    local rightTPPlayer = nil
    local isRightTripleTP = tonumber(pulseCount) == 3
    if overrideTargetPart and overrideTargetPart:IsA("BasePart") and overrideTargetPart.Parent then
        targetRoot = overrideTargetPart
    elseif surfaceMode then
        local preferred, rememberedRoot = SettingsVisual.TouchCarRememberRightTarget()
        local targetChar = preferred and preferred.Character
        local targetHum = targetChar and targetChar:FindFirstChildOfClass("Humanoid")
        targetRoot = rememberedRoot
        -- Si no hay selección nueva, se permite reutilizar el último objetivo recordado.
        if not targetRoot then return false end
        if targetHum and targetHum.Health > 0 then
            SettingsVisual.TouchCarLastRightTargetPosition = targetRoot.Position
        end
    else
        targetRoot, rightTPPlayer = SettingsVisual.TouchCarGetEnemyAbove(vehicle, root)
        if not targetRoot then return false end
    end

    SettingsVisual.TouchCarOneShotBusy = true
    S.OneShotBusy = true

    -- Guarda EXACTAMENTE dónde estaba el carro underground.
    local savedPivot = vehicle:GetPivot()
    local savedDesiredY = tonumber(S.DesiredRootY) or root.Position.Y
    local rootToPivot = root.CFrame:ToObjectSpace(savedPivot)
    local savedLook = SettingsVisual.TouchSnapCarFlatLook(root.CFrame)

    -- Conserva la misma altura útil del carro sobre una superficie.
    local boxCF, boxSize = vehicle:GetBoundingBox()
    local bottomY = boxCF.Position.Y - (boxSize.Y * 0.5)
    local rootToBottom = root.Position.Y - bottomY

    if rootToBottom <= 0 or rootToBottom > 20 then
        rootToBottom = tonumber(S.RootToBottom) or 2.5
    end

    local surfaceY = select(
        1,
        SettingsVisual.TouchCarGetLandingSurface(vehicle, targetRoot)
    )

    local clearance =
        tonumber(SettingsVisual.TouchCarOneShotSurfaceClearance)
        or 0.18

    -- Centra el BoundingBox real del carro sobre el X/Z del objetivo.
    local boxCenterOffset = Vector3.new(
        boxCF.Position.X - root.Position.X,
        0,
        boxCF.Position.Z - root.Position.Z
    )
    -- Ajustes de altura separados:
    -- Superficie + derecha: queda solo 1 stud extra (2 studs más abajo que el +3 anterior).
    -- Snap Car abajo: izquierda y derecha quedan 2 studs más abajo respecto a la colocación anterior.
    -- TP Items conserva su altura normal.
    local targetDistance = (targetRoot.Position - root.Position).Magnitude
    -- Los TP largos son especialmente sensibles a colisiones y correcciones de red.
    local longSurfaceTeleport = surfaceMode and not overrideTargetPart and targetDistance > 80
    -- En superficie: cerca (<=30 studs) al centro; lejos, sobre la cabeza.
    local rightSurfaceExtraY = (surfaceMode and not overrideTargetPart)
        and ((targetDistance > 30) and 4 or 0) or 0
    local undergroundEnemyOffsetY = 0
    -- Con Snap Car encendido, ambas casillas usan esta misma rutina.
    -- Baja 3 studs adicionales respecto a la altura anterior.
    local headY = targetRoot.Position.Y + 2.1 - 3
    if not surfaceMode and not overrideTargetPart then
        undergroundEnemyOffsetY = headY - (surfaceY + clearance)
    end
    local visitPosition = Vector3.new(
        targetRoot.Position.X - boxCenterOffset.X,
        surfaceY + rootToBottom + clearance + rightSurfaceExtraY + undergroundEnemyOffsetY,
        targetRoot.Position.Z - boxCenterOffset.Z
    )
    -- Casilla derecha en superficie: llegada por arriba del objetivo,
    -- sin buscar una posición debajo del piso de las casas.
    -- Los TP de Snap Car y TP Items mantienen su lógica original.
    -- Variables compartidas con destinationClear() dentro del recorrido.
    -- Antes eran locales a un if y quedaban NIL durante el TP: no funcionaba.
    local overlap = nil
    local footprint = nil
    if surfaceMode and not overrideTargetPart then
        overlap = OverlapParams.new()
        overlap.FilterType = Enum.RaycastFilterType.Exclude
        overlap.FilterDescendantsInstances = {vehicle, Player.Character}
        overlap.MaxParts = 120
        footprint = Vector3.new(math.max(boxSize.X + 5, 1), math.max(boxSize.Y + 4, 1), math.max(boxSize.Z + 5, 1))
        local offsets = {Vector2.new(0, 0)}
        for _, distance in ipairs({5, 10, 16, 24, 32}) do
            for i = 0, 11 do
                local angle = i * math.pi / 6
                table.insert(offsets, Vector2.new(math.cos(angle) * distance, math.sin(angle) * distance))
            end
        end
        local found = nil
        -- Hover: evita dejar el chasis pegado a la cabeza / carro enemigo.
        -- El margen adicional reduce impulsos cuando el objetivo se mueve.
        local landingBottomY = targetRoot.Position.Y + math.max(10, boxSize.Y + 4)
        for _, offset in ipairs(offsets) do
            local candidate = Vector3.new(
                targetRoot.Position.X + offset.X - boxCenterOffset.X,
                landingBottomY + rootToBottom,
                targetRoot.Position.Z + offset.Y - boxCenterOffset.Z
            )
            local center = candidate + boxCenterOffset + Vector3.new(0, boxSize.Y * 0.5 - rootToBottom, 0)
            local blocked = false
            for _, hit in ipairs(workspace:GetPartBoundsInBox(CFrame.new(center), footprint, overlap)) do
                if hit:IsA("BasePart") and hit.CanCollide then blocked = true break end
            end
            if not blocked then found = candidate break end
        end
        if not found then
            S.OneShotBusy = false
            SettingsVisual.TouchCarOneShotBusy = false
            return false
        end
        visitPosition = found
    end

    local visitRootCF =
        SettingsVisual.TouchSnapCarUpright(
            visitPosition,
            savedLook
        )

    -- Impide que dos TP de superficie se encadenen durante una corrección física.
    if longSurfaceTeleport and os.clock() - (SettingsVisual.TouchCarLastLongTP or -100) < 2.5 then
        S.OneShotBusy = false
        SettingsVisual.TouchCarOneShotBusy = false
        return false
    end
    if longSurfaceTeleport then SettingsVisual.TouchCarLastLongTP = os.clock() end

    local ok = pcall(function()
        -- TP DIRECTO: sin velocidad ni recorrido intermedio.
        -- Ghost temporal solo para el vehículo: NO alteramos las casas ni el mapa.
        -- Desactivar colisiones del mapa localmente no las desactiva en el servidor.
        SettingsVisual.TouchSnapCarFullGhost(vehicle)

        -- En distancias largas solo se hace un pulso, sin repetición de saltos.
        local pulses = longSurfaceTeleport and 1 or math.clamp(tonumber(pulseCount) or 1, 1, 3)
        for pulse = 1, pulses do
            if not vehicle.Parent or not root.Parent then break end
            if surfaceMode and not overrideTargetPart then
                -- Ruta por arriba (origen -> cielo -> cielo del objetivo -> hover).
                -- Ningun motor de sliders mueve el vehiculo mientras OneShotBusy.
                local highY = math.max(root.Position.Y, visitPosition.Y, targetRoot.Position.Y)
                    + math.max(95, boxSize.Y + 45)
                local originHigh = SettingsVisual.TouchSnapCarUpright(
                    Vector3.new(root.Position.X, highY, root.Position.Z), savedLook
                )
                local targetHigh = SettingsVisual.TouchSnapCarUpright(
                    Vector3.new(visitPosition.X, highY, visitPosition.Z), savedLook
                )
                local function stepTo(cf)
                    SettingsVisual.TouchSnapCarFullGhost(vehicle)
                    SettingsVisual.TouchSnapCarZeroMotion(vehicle, root)
                    vehicle:PivotTo(cf * rootToPivot)
                    SettingsVisual.TouchSnapCarZeroMotion(vehicle, root)
                    RunService.Heartbeat:Wait()
                end

                -- Antes de entrar, revisa nuevamente el volumen de llegada.
                -- Si otro auto invadio el hueco, aborta sin meternos dentro.
                local function destinationClear()
                    local center = visitPosition + boxCenterOffset
                        + Vector3.new(0, boxSize.Y * 0.5 - rootToBottom, 0)
                    for _, part in ipairs(workspace:GetPartBoundsInBox(
                        CFrame.new(center), footprint, overlap
                    )) do
                        if part:IsA("BasePart") and part.CanCollide then
                            return false
                        end
                    end
                    return true
                end

                if destinationClear() then
                    stepTo(originHigh)
                    stepTo(targetHigh)
                    -- Chequeo extra justo antes de bajar.
                    if destinationClear() then
                        stepTo(visitRootCF)
                        local holdUntil = os.clock() + 0.90
                        while vehicle.Parent and root.Parent
                            and os.clock() < holdUntil do
                            -- Si alguien se mueve al lugar, salir inmediatamente.
                            if not destinationClear() then break end
                            SettingsVisual.TouchSnapCarFullGhost(vehicle)
                            vehicle:PivotTo(visitRootCF * rootToPivot)
                            SettingsVisual.TouchSnapCarZeroMotion(vehicle, root)
                            RunService.Heartbeat:Wait()
                        end
                    end
                    stepTo(targetHigh)
                    stepTo(originHigh)
                end
                -- Siempre volver donde estaba el carro, incluso si se aborto.
                SettingsVisual.TouchSnapCarFullGhost(vehicle)
                vehicle:PivotTo(savedPivot)
                SettingsVisual.TouchSnapCarZeroMotion(vehicle, root)
            else
                -- DERECHA x3: pausa lo suficiente para visualizar al enemigo,
                -- disparo inmediato al LLEGAR (no durante viaje ni en origen).
                -- IZQUIERDA y TP Items mantienen sus tiempos previos.
                vehicle:PivotTo(visitRootCF * rootToPivot)
                SettingsVisual.TouchSnapCarZeroMotion(vehicle, root)
                local rightVisit = isRightTripleTP and rightTPPlayer ~= nil
                -- Sólo casilla IZQUIERDA + Snap subterráneo: visita más
                -- breve (0.20s vs 0.35s); regresa al pivot original de
                -- inmediato. TP directo ya es instantáneo, sin ruta extra.
                local leftSnapVisit = S.Enabled and not surfaceMode
                    and not overrideTargetPart and not isRightTripleTP
                local holdSeconds = rightVisit
                    and ((pulse == 1)
                        and (tonumber(SettingsVisual.AutoShootTPFirstHold) or 0.58)
                        or (tonumber(SettingsVisual.AutoShootTPOtherHold) or 0.36))
                    or (leftSnapVisit and 0.20
                        or (tonumber(SettingsVisual.TouchCarOneShotHoldTime) or 0.35))
                local shotState = {shots = 0, attempts = 0, nextAt = 0}
                local holdUntil = os.clock() + holdSeconds
                while vehicle.Parent and root.Parent and os.clock() < holdUntil do
                    vehicle:PivotTo(visitRootCF * rootToPivot)
                    SettingsVisual.TouchSnapCarZeroMotion(vehicle, root)
                    if rightVisit then
                        SettingsVisual.TryAutoShootDuringRightTP(
                            rightTPPlayer, shotState, (pulse == 1) and 2 or 1)
                    end
                    RunService.Heartbeat:Wait()
                end
                SettingsVisual.TouchSnapCarFullGhost(vehicle)
                vehicle:PivotTo(savedPivot)
                SettingsVisual.TouchSnapCarZeroMotion(vehicle, root)
            end
            if longSurfaceTeleport then
                RunService.Heartbeat:Wait()
                SettingsVisual.TouchSnapCarZeroMotion(vehicle, root)
            end
            if pulse < pulses then task.wait(0.035) end
        end
    end)

    S.DesiredRootY = savedDesiredY
    S.CurrentDriveSpeed = 0
    if surfaceMode then
        -- Restauracion a prueba de error: no quedarse en casa/carro enemigo
        -- si falla un paso intermedio. Mantener ghost mientras se estabiliza.
        if vehicle.Parent and root.Parent then
            pcall(function()
                SettingsVisual.TouchSnapCarFullGhost(vehicle)
                vehicle:PivotTo(savedPivot)
                for _ = 1, 3 do
                    SettingsVisual.TouchSnapCarZeroMotion(vehicle, root)
                    RunService.Heartbeat:Wait()
                end
            end)
        end
        SettingsVisual.TouchCarRestoreVehicleSurfaceCollision(vehicle)
        SettingsVisual.TouchSnapCarZeroMotion(vehicle, root)
    end
    S.OneShotBusy = false
    SettingsVisual.TouchCarOneShotBusy = false

    return ok
end


--========================================================--
-- CASILLA DERECHA / CARRO SOBRE LA SUPERFICIE / SNAP CAR OFF
-- LÓGICA DEL SCRIPT DE REFERENCIA ENVIADO POR EL USUARIO:
-- TP DIRECTO A X/Z DEL ENEMIGO -> MANTENER 0.35 s -> REGRESO DIRECTO.
-- NO HAY RUTA POR EL CIELO NI BÚSQUEDA DE HOVER A 10+ STUDS.
-- Solo afecta esta casilla sobre superficie; Snap Car bajo piso intacto.
--========================================================--
SettingsVisual.TouchCarRightSurfaceOriginalTP = function()
    if SettingsVisual.TouchCarOneShotBusy then
        return false
    end

    local S = SettingsVisual.TouchSnapCarState
    if not S or S.Enabled or S.Exiting then
        return false
    end

    local vehicle, root, seat = SettingsVisual.TouchSnapCarGetVehicle()
    if not vehicle or not root or not seat then
        return false
    end

    -- Mismo objetivo/memoria del selector Target Line del script original.
    local preferred, rememberedRoot = SettingsVisual.TouchCarRememberRightTarget()
    local targetChar = preferred and preferred.Character
    local targetHum = targetChar and targetChar:FindFirstChildOfClass("Humanoid")
    local targetRoot = rememberedRoot
    if not targetRoot or not targetRoot.Parent then
        return false
    end
    if targetHum and targetHum.Health > 0 then
        SettingsVisual.TouchCarLastRightTargetPosition = targetRoot.Position
    end

    SettingsVisual.TouchCarOneShotBusy = true
    S.OneShotBusy = true

    local savedPivot = vehicle:GetPivot()
    local savedDesiredY = tonumber(S.DesiredRootY) or root.Position.Y
    local rootToPivot = root.CFrame:ToObjectSpace(savedPivot)
    local savedLook = SettingsVisual.TouchSnapCarFlatLook(root.CFrame)

    local boxCF, boxSize = vehicle:GetBoundingBox()
    local bottomY = boxCF.Position.Y - (boxSize.Y * 0.5)
    local rootToBottom = root.Position.Y - bottomY
    if rootToBottom <= 0 or rootToBottom > 20 then
        rootToBottom = tonumber(S.RootToBottom) or 2.5
    end

    local surfaceY = select(1,
        SettingsVisual.TouchCarGetLandingSurface(vehicle, targetRoot)
    )
    if not surfaceY then
        S.OneShotBusy = false
        SettingsVisual.TouchCarOneShotBusy = false
        return false
    end

    local clearance = tonumber(SettingsVisual.TouchCarOneShotSurfaceClearance) or 0.18
    local boxCenterOffset = Vector3.new(
        boxCF.Position.X - root.Position.X,
        0,
        boxCF.Position.Z - root.Position.Z
    )

    -- EXACTAMENTE la colocación del otro script: X/Z centrados en enemigo,
    -- misma superficie bajo él, y 1 stud adicional en modo superficie.
    local visitPosition = Vector3.new(
        targetRoot.Position.X - boxCenterOffset.X,
        surfaceY + rootToBottom + clearance + 1,
        targetRoot.Position.Z - boxCenterOffset.Z
    )
    local visitRootCF = SettingsVisual.TouchSnapCarUpright(visitPosition, savedLook)

    -- En el script de referencia no hay ascenso intermedio, descenso en fases
    -- ni vuelo horizontal. Es un PivotTo único y un retorno directo.
    local ok, err = pcall(function()
        SettingsVisual.TouchSnapCarFullGhost(vehicle)
        vehicle:PivotTo(visitRootCF * rootToPivot)
        SettingsVisual.TouchSnapCarZeroMotion(vehicle, root)

        local shotState = {shots = 0, attempts = 0, nextAt = 0}
        local holdUntil = os.clock() + 0.58
        while vehicle.Parent and root.Parent and os.clock() < holdUntil do
            vehicle:PivotTo(visitRootCF * rootToPivot)
            SettingsVisual.TouchSnapCarZeroMotion(vehicle, root)
            -- Superficie: misma casilla derecha, mismo enemigo del Target Line.
            if preferred and targetHum and targetHum.Health > 0 then
                SettingsVisual.TryAutoShootDuringRightTP(preferred, shotState, 2)
            end
            RunService.Heartbeat:Wait()
        end

        SettingsVisual.TouchSnapCarFullGhost(vehicle)
        vehicle:PivotTo(savedPivot)
        SettingsVisual.TouchSnapCarZeroMotion(vehicle, root)
    end)

    S.DesiredRootY = savedDesiredY
    S.CurrentDriveSpeed = 0
    -- Mismo restore que hacía TouchCarOneShotTeleport en la referencia.
    pcall(function() SettingsVisual.TouchCarRestoreVehicleSurfaceCollision(vehicle) end)
    S.OneShotBusy = false
    SettingsVisual.TouchCarOneShotBusy = false

    if not ok then
        warn("[CHINO] TP derecho directo falló: " .. tostring(err))
    end
    return ok
end

--========================================================--
-- TP ITEMS TARGET: SWITCH EXTERNO ESTILO iPHONE 6
-- El switch aparece SOLO cuando TP Items Target esta activo Y hay
-- un VehicleSeat ocupado por nosotros. Al encenderlo, el vehiculo
-- va DIRECTAMENTE a cada objeto tirado y se queda alli (sin retorno).
-- Priorizamos los drops alrededor de Target Line; si no hay, elegimos
-- el drop mas cercano. Cada objeto visitado se marca para no hacer
-- TP infinito al mismo sitio. No toca la casilla derecha existente.
--========================================================--
do
    local switchParent = SettingsVisual.ExecutorGuiParent or PlayerGui
    local oldSwitch = switchParent:FindFirstChild("CHINO_ItemTargetCarSwitchGui")
    if oldSwitch then oldSwitch:Destroy() end

    local switchGui = Instance.new("ScreenGui")
    switchGui.Name = "CHINO_ItemTargetCarSwitchGui"
    switchGui.ResetOnSpawn = false
    switchGui.IgnoreGuiInset = true
    switchGui.DisplayOrder = 850
    switchGui.Enabled = true
    switchGui.Parent = switchParent

    local switchFrame = Instance.new("Frame")
    switchFrame.Name = "iPhone6Switch"
    switchFrame.Size = UDim2.fromOffset(112, 45)
    switchFrame.Position = UDim2.new(1, -126, 0.57, 0)
    switchFrame.BackgroundColor3 = Color3.fromRGB(19, 23, 33)
    switchFrame.BackgroundTransparency = 0.20
    switchFrame.BorderSizePixel = 0
    switchFrame.Active = true
    switchFrame.Draggable = true
    switchFrame.Visible = false
    switchFrame.Parent = switchGui
    Instance.new("UICorner", switchFrame).CornerRadius = UDim.new(0, 12)

    local outerStroke = Instance.new("UIStroke")
    outerStroke.Thickness = 1.4
    outerStroke.Transparency = 0.25
    outerStroke.Color = Color3.fromRGB(117, 130, 156)
    outerStroke.Parent = switchFrame

    local label = Instance.new("TextLabel")
    label.Name = "ItemLabel"
    label.Size = UDim2.fromOffset(48, 38)
    label.Position = UDim2.fromOffset(5, 4)
    label.BackgroundTransparency = 1
    label.Text = "ITEMS\nTP"
    label.Font = Enum.Font.GothamBold
    label.TextSize = 10
    label.TextColor3 = Color3.fromRGB(240, 244, 255)
    label.Parent = switchFrame

    local switchButton = Instance.new("TextButton")
    switchButton.Name = "Switch"
    switchButton.Position = UDim2.fromOffset(54, 9)
    switchButton.Size = UDim2.fromOffset(52, 27)
    switchButton.BackgroundColor3 = Color3.fromRGB(97, 103, 116)
    switchButton.BorderSizePixel = 0
    switchButton.Text = ""
    switchButton.AutoButtonColor = false
    switchButton.Parent = switchFrame
    Instance.new("UICorner", switchButton).CornerRadius = UDim.new(1, 0)

    local trackStroke = Instance.new("UIStroke")
    trackStroke.Thickness = 1
    trackStroke.Color = Color3.fromRGB(218, 224, 233)
    trackStroke.Transparency = 0.40
    trackStroke.Parent = switchButton

    local thumb = Instance.new("Frame")
    thumb.Name = "Thumb"
    thumb.Size = UDim2.fromOffset(23, 23)
    thumb.Position = UDim2.fromOffset(2, 2)
    thumb.BackgroundColor3 = Color3.fromRGB(253, 253, 253)
    thumb.BorderSizePixel = 0
    thumb.Parent = switchButton
    Instance.new("UICorner", thumb).CornerRadius = UDim.new(1, 0)
    local thumbStroke = Instance.new("UIStroke")
    thumbStroke.Thickness = 0.7
    thumbStroke.Transparency = 0.65
    thumbStroke.Color = Color3.fromRGB(74, 83, 96)
    thumbStroke.Parent = thumb

    SettingsVisual.VehicleItemTPSwitchEnabled = false
    SettingsVisual.VehicleItemTPSwitchVisited = setmetatable({}, {__mode = "k"})
    SettingsVisual.VehicleItemTPSwitchFailedUntil = setmetatable({}, {__mode = "k"})
    SettingsVisual.VehicleItemTPSwitchNextTP = 0
    SettingsVisual.VehicleItemTPSwitchGui = switchGui

    SettingsVisual.SetVehicleItemTPSwitch = function(enabled)
        enabled = enabled == true
        if enabled then
            local _, _, seat = SettingsVisual.TouchSnapCarGetVehicle()
            if not SettingsVisual.TouchRightDroppedItemsEnabled or not seat then
                enabled = false
            end
        end
        local old = SettingsVisual.VehicleItemTPSwitchEnabled
        SettingsVisual.VehicleItemTPSwitchEnabled = enabled
        label.Text = enabled and "TP\nON" or "ITEMS\nTP"
        if enabled and not old then
            SettingsVisual.VehicleItemTPSwitchVisited = setmetatable({}, {__mode = "k"})
            SettingsVisual.VehicleItemTPSwitchFailedUntil = setmetatable({}, {__mode = "k"})
            SettingsVisual.VehicleItemTPSwitchNextTP = 0
        end
        if not enabled then
            SettingsVisual.VehicleItemTPSwitchNextTP = 0
        end
        TweenService:Create(switchButton, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {
            BackgroundColor3 = enabled and Color3.fromRGB(75, 205, 100)
                or Color3.fromRGB(97, 103, 116),
        }):Play()
        TweenService:Create(thumb, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {
            Position = enabled and UDim2.fromOffset(27, 2)
                or UDim2.fromOffset(2, 2),
        }):Play()
    end

    switchButton.Activated:Connect(function()
        SettingsVisual.SetVehicleItemTPSwitch(
            not SettingsVisual.VehicleItemTPSwitchEnabled
        )
    end)

    -- Da preferencia a los items que esten cerca del objetivo de Target Line.
    -- Si el objetivo no tiene drops cerca, funciona con cualquier drop real.
    -- Devuelve el siguiente drop real. Antes solo consideraba Model;
    -- cuando el juego dejaba BaseParts individuales, el switch no veia nada.
    SettingsVisual.VehicleItemTPFindNext = function(vehicle, root)
        local folder = SettingsVisual.GetDroppedItemsFolder()
        if not folder or not root then return nil, nil end

        SettingsVisual.TouchCarRememberRightTarget()
        local anchor = SettingsVisual.TouchCarLastRightTargetPosition
        local radius = tonumber(SettingsVisual.TouchCarDropSearchRadius) or 42
        local visited = SettingsVisual.VehicleItemTPSwitchVisited
        local failedUntil = SettingsVisual.VehicleItemTPSwitchFailedUntil
        local bestItem, bestPart, bestScore = nil, nil, math.huge
        local now = os.clock()

        for _, item in ipairs(folder:GetChildren()) do
            if (item:IsA("Model") or item:IsA("BasePart"))
                and not visited[item]
                and now >= (failedUntil[item] or 0) then
                local part = SettingsVisual.GetDroppedItemAnchor(item)
                if part and part.Parent then
                    local distance = (part.Position - root.Position).Magnitude
                    local inTargetArea = anchor
                        and (part.Position - anchor).Magnitude <= radius
                    local score = distance + (inTargetArea and 0 or 100000)
                    if score < bestScore then
                        bestScore = score
                        bestItem, bestPart = item, part
                    end
                end
            end
        end
        return bestItem, bestPart
    end

    -- TP directo a objetos tirados: primero busca una superficie y un espacio
    -- cercano donde quepa el carro. Nunca elimina silenciosamente un drop
    -- fallido: solo lo pospone para intentar otro sitio u otro item.
    SettingsVisual.VehicleItemTPGoDirect = function(itemModel, itemPart)
        local S = SettingsVisual.TouchSnapCarState
        if not S or SettingsVisual.TouchCarOneShotBusy or S.OneShotBusy then
            return false, "ocupado"
        end
        if not itemPart or not itemPart.Parent then
            return false, "objeto desaparecio"
        end
        local vehicle, root, seat = SettingsVisual.TouchSnapCarGetVehicle()
        if not vehicle or not root or not seat then
            return false, "no estas sentado en VehicleSeat"
        end

        local boxCF, boxSize = vehicle:GetBoundingBox()
        local rootToBottom = root.Position.Y - (boxCF.Position.Y - boxSize.Y * 0.5)
        if rootToBottom <= 0 or rootToBottom > 20 then
            rootToBottom = tonumber(S.RootToBottom) or math.max(1.5, boxSize.Y * 0.5)
        end
        local centerOffset = Vector3.new(
            boxCF.Position.X - root.Position.X, 0,
            boxCF.Position.Z - root.Position.Z
        )

        local rayParams = RaycastParams.new()
        rayParams.FilterType = Enum.RaycastFilterType.Exclude
        rayParams.IgnoreWater = true
        local exclusions = { vehicle, itemModel }
        if Player.Character then table.insert(exclusions, Player.Character) end
        local vehicleFolder = workspace:FindFirstChild("Vehicles")
        if vehicleFolder then table.insert(exclusions, vehicleFolder) end
        rayParams.FilterDescendantsInstances = exclusions

        local overlap = OverlapParams.new()
        overlap.FilterType = Enum.RaycastFilterType.Exclude
        local overlapIgnore = { vehicle, itemModel }
        if Player.Character then table.insert(overlapIgnore, Player.Character) end
        overlap.FilterDescendantsInstances = overlapIgnore
        overlap.MaxParts = 100
        local footprint = Vector3.new(
            math.max(1.8, boxSize.X - 0.45),
            math.max(1.8, boxSize.Y - 0.6),
            math.max(1.8, boxSize.Z - 0.45)
        )

        -- Los objetos en tiendas/casas no siempre tienen espacio justo encima.
        -- Probar el centro y posiciones cercanas, cada una con su propio suelo.
        local offsets = { Vector2.new(0, 0) }
        for _, radius in ipairs({3, 6, 9, 12, 16, 20}) do
            for n = 0, 7 do
                local angle = n * math.pi / 4
                offsets[#offsets + 1] = Vector2.new(
                    math.cos(angle) * radius, math.sin(angle) * radius
                )
            end
        end

        local destination = nil
        local surfaceCount = 0
        for _, offset in ipairs(offsets) do
            local x = itemPart.Position.X + offset.X
            local z = itemPart.Position.Z + offset.Y
            -- El origen bajo evita confundir el techo de una tienda con el piso.
            local hit = workspace:Raycast(
                Vector3.new(x, itemPart.Position.Y + 5, z),
                Vector3.new(0, -160, 0), rayParams
            )
            if not hit then
                -- Segundo intento para drops elevados o dentro de un edificio.
                hit = workspace:Raycast(
                    Vector3.new(x, itemPart.Position.Y + 35, z),
                    Vector3.new(0, -195, 0), rayParams
                )
            end
            if hit and hit.Normal.Y >= 0.45 then
                surfaceCount += 1
                local proposedRoot = Vector3.new(
                    x - centerOffset.X,
                    hit.Position.Y + rootToBottom + 0.75,
                    z - centerOffset.Z
                )
                local proposedBox = proposedRoot + centerOffset
                    + Vector3.new(0, boxSize.Y * 0.5 - rootToBottom, 0)
                local blocked = false
                for _, obj in ipairs(workspace:GetPartBoundsInBox(
                    CFrame.new(proposedBox), footprint, overlap
                )) do
                    if obj:IsA("BasePart") and obj.CanCollide then
                        blocked = true
                        break
                    end
                end
                if not blocked then
                    destination = proposedRoot
                    break
                end
            end
        end
        if not destination then
            return false, surfaceCount == 0 and "no hay piso cargado" or "lugar ocupado"
        end

        -- Desactivar Snap SOLO despues de encontrar una llegada segura.
        if S.Enabled then
            local snapOK = SettingsVisual.TouchSnapCarSet(false)
            if not snapOK then return false, "no se pudo salir de Snap Car" end
            vehicle, root, seat = SettingsVisual.TouchSnapCarGetVehicle()
            if not vehicle or not root or not seat then
                return false, "se perdio el asiento al salir de Snap Car"
            end
        end
        if SettingsVisual.TouchCarOneShotBusy or S.OneShotBusy then
            return false, "otro TP en curso"
        end

        SettingsVisual.TouchCarOneShotBusy = true
        S.OneShotBusy = true
        local ok, err = pcall(function()
            local originalPivot = vehicle:GetPivot()
            local rootToPivot = root.CFrame:ToObjectSpace(originalPivot)
            local look = SettingsVisual.TouchSnapCarFlatLook(root.CFrame)
            local goalCF = SettingsVisual.TouchSnapCarUpright(destination, look)
            SettingsVisual.TouchSnapCarFullGhost(vehicle)
            local holdUntil = os.clock() + 0.27
            repeat
                vehicle:PivotTo(goalCF * rootToPivot)
                SettingsVisual.TouchSnapCarZeroMotion(vehicle, root)
                RunService.Heartbeat:Wait()
            until os.clock() >= holdUntil or not vehicle.Parent or not root.Parent
            if vehicle.Parent and root.Parent then
                vehicle:PivotTo(goalCF * rootToPivot)
                SettingsVisual.TouchSnapCarZeroMotion(vehicle, root)
            end
        end)
        pcall(function()
            SettingsVisual.TouchCarRestoreVehicleSurfaceCollision(vehicle)
        end)
        S.OneShotBusy = false
        SettingsVisual.TouchCarOneShotBusy = false
        if not ok then return false, tostring(err) end
        return true
    end

    -- El switch persiste aunque cierres el panel; desaparece al salir del auto
    -- o al apagar TP Items Target, y se apaga para no hacer TPs caminando.
    task.spawn(function()
        local lastSeat = nil
        while switchGui and switchGui.Parent do
            task.wait(0.12)
            local vehicle, root, seat = SettingsVisual.TouchSnapCarGetVehicle()
            local showing = SettingsVisual.TouchRightDroppedItemsEnabled
                and vehicle ~= nil and root ~= nil and seat ~= nil
            switchFrame.Visible = showing
            if not showing then
                if SettingsVisual.VehicleItemTPSwitchEnabled then
                    SettingsVisual.SetVehicleItemTPSwitch(false)
                end
                lastSeat = nil
                continue
            end
            if lastSeat and lastSeat ~= seat then
                SettingsVisual.SetVehicleItemTPSwitch(false)
            end
            lastSeat = seat
            if SettingsVisual.VehicleItemTPSwitchEnabled
                and os.clock() >= (SettingsVisual.VehicleItemTPSwitchNextTP or 0)
                and not SettingsVisual.TouchCarOneShotBusy
                and not (SettingsVisual.TouchSnapCarState
                    and SettingsVisual.TouchSnapCarState.OneShotBusy) then
                local model, part = SettingsVisual.VehicleItemTPFindNext(vehicle, root)
                if model and part then
                    SettingsVisual.VehicleItemTPSwitchNextTP = os.clock() + 1.50
                    local callOK, moved, reason = pcall(
                        SettingsVisual.VehicleItemTPGoDirect, model, part
                    )
                    if callOK and moved then
                        SettingsVisual.VehicleItemTPSwitchVisited[model] = true
                        label.Text = "TP\nOK"
                    else
                        -- Antes se marcaba Visitado aun cuando el TP fallaba:
                        -- por eso el switch se quedaba sin hacer nada.
                        SettingsVisual.VehicleItemTPSwitchFailedUntil[model] = os.clock() + 3
                        label.Text = "TP\nFAIL"
                        warn("[CHINO][TP Items] No se pudo ir al drop:",
                            callOK and tostring(reason) or tostring(moved))
                    end
                else
                    -- No hay drops cargados, o los disponibles estan en espera.
                    label.Text = "SIN\nITEMS"
                    SettingsVisual.VehicleItemTPSwitchNextTP = os.clock() + 0.45
                end
            end
        end
    end)
end

do
	local followCheck = Instance.new("TextButton", TouchCard)
	followCheck.Name = "TouchTargetFollowCheck"
	followCheck.Size = UDim2.fromOffset(18, 18)
	followCheck.Position = UDim2.new(0, 8, 1, -27)
	followCheck.BackgroundColor3 = Color3.fromRGB(28, 31, 42)
	followCheck.BackgroundTransparency = 0.35
	followCheck.BorderSizePixel = 0
	followCheck.Text = ""
	followCheck.TextColor3 = COLORS.White
	followCheck.TextSize = 13
	followCheck.Font = Enum.Font.GothamBold
	followCheck.ZIndex = 5
	Instance.new("UICorner", followCheck).CornerRadius = UDim.new(0, 4)

	SettingsVisual.TouchTargetFollowCheck = followCheck

	SettingsVisual.SetTouchTargetFollow = function(state)
		state = state == true

		if state then
			local target = CurrentTarget
			local targetChar = target and target.Character
			local targetHum = targetChar and targetChar:FindFirstChildOfClass("Humanoid")
			local targetRoot = targetChar and targetChar:FindFirstChild("HumanoidRootPart")

			if not target or not targetRoot or not targetHum or targetHum.Health <= 0 then
				SettingsVisual.TouchTargetFollowEnabled = false
				SettingsVisual.TouchTargetFollowPlayer = nil
				followCheck.Text = ""
				followCheck.BackgroundColor3 = Color3.fromRGB(28, 31, 42)
				return
			end

			if isSnappedDown then
				toggleSnapDown()
			end

			SettingsVisual.TouchTargetFollowPlayer = target
			SettingsVisual.TouchTargetFollowEnabled = true
		else
			SettingsVisual.TouchTargetFollowEnabled = false
			SettingsVisual.TouchTargetFollowPlayer = nil
		end

		followCheck.Text = SettingsVisual.TouchTargetFollowEnabled and "×" or ""
		followCheck.BackgroundColor3 = SettingsVisual.TouchTargetFollowEnabled
			and COLORS.Blue
			or Color3.fromRGB(28, 31, 42)
	end

	-- Espectador de la casilla izquierda cuando vas en carro sobre la superficie.
	-- No mueve ni el carro ni el personaje: solamente controla la cámara.
	SettingsVisual.TouchCarSpectateEnabled = false
	SettingsVisual.TouchCarSpectateStartedInCar = false
	SettingsVisual.TouchCarSpectatePlayer = nil
	SettingsVisual.TouchCarSpectateConnection = nil
	SettingsVisual.TouchCarSpectateHeight = 8
	SettingsVisual.TouchCarSpectateBack = 11

	SettingsVisual.SetTouchCarSpectate = function(state)
		state = state == true

		if SettingsVisual.TouchCarSpectateConnection then
			SettingsVisual.TouchCarSpectateConnection:Disconnect()
			SettingsVisual.TouchCarSpectateConnection = nil
		end

		if not state then
			SettingsVisual.TouchCarSpectateEnabled = false
			SettingsVisual.TouchCarSpectatePlayer = nil
			followCheck.Text = ""
			followCheck.BackgroundColor3 = Color3.fromRGB(28, 31, 42)

			local char = Player.Character
			local hum = char and char:FindFirstChildOfClass("Humanoid")
			local ownSeat = hum and hum.SeatPart
			pcall(function()
				-- Salida completa del espectador: devolver el control a la cámara normal.
				Camera.CameraType = Enum.CameraType.Custom
				Camera.CameraSubject = (ownSeat and ownSeat.Parent and ownSeat) or hum
			end)
			task.defer(function()
				local currentChar = Player.Character
				local currentHum = currentChar and currentChar:FindFirstChildOfClass("Humanoid")
				if currentHum then
					pcall(function()
						Camera.CameraType = Enum.CameraType.Custom
						Camera.CameraSubject = (currentHum.SeatPart and currentHum.SeatPart.Parent and currentHum.SeatPart) or currentHum
					end)
				end
			end)
			return
		end

		-- Usa exactamente la selección que alimenta Target Line.
		local target = CurrentLockedTarget or SettingsVisual.DirectVisualLockedTarget or CurrentTarget
		local targetChar = target and target.Character
		local targetHum = targetChar and targetChar:FindFirstChildOfClass("Humanoid")
		local targetRoot = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
		if not target or not targetHum or targetHum.Health <= 0 or not targetRoot then
			return
		end

		SettingsVisual.TouchCarSpectateEnabled = true
		local myHum = Player.Character and Player.Character:FindFirstChildOfClass("Humanoid")
		SettingsVisual.TouchCarSpectateStartedInCar = myHum and myHum.SeatPart ~= nil or false
		SettingsVisual.TouchCarSpectatePlayer = target
		followCheck.Text = "ESP"
		followCheck.BackgroundColor3 = COLORS.Blue

		pcall(function() Camera.CameraType = Enum.CameraType.Scriptable end)

		SettingsVisual.TouchCarSpectateConnection = RunService.RenderStepped:Connect(function()
			if not SettingsVisual.TouchCarSpectateEnabled then return end

			-- Si el jugador se baja del carro mientras espectea, cortar todo
			-- inmediatamente y devolver la cámara normal a su personaje.
			local ownChar = Player.Character
			local ownHum = ownChar and ownChar:FindFirstChildOfClass("Humanoid")
			local ownSeat = ownHum and ownHum.SeatPart
			if SettingsVisual.TouchCarSpectateStartedInCar and (not ownSeat or not ownSeat:IsA("VehicleSeat")) then
				SettingsVisual.SetTouchCarSpectate(false)
				return
			end

			local pl = SettingsVisual.TouchCarSpectatePlayer
			local ch = pl and pl.Character
			local hum = ch and ch:FindFirstChildOfClass("Humanoid")
			local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
			if not hum or hum.Health <= 0 or not hrp then
				SettingsVisual.SetTouchCarSpectate(false)
				return
			end

			local height = tonumber(SettingsVisual.TouchCarSpectateHeight) or 8
			local back = tonumber(SettingsVisual.TouchCarSpectateBack) or 11
			local focus = hrp.Position + Vector3.new(0, 2.2, 0)
			local cameraPos = focus - (hrp.CFrame.LookVector * back) + Vector3.new(0, height, 0)
			pcall(function() Camera.CFrame = CFrame.lookAt(cameraPos, focus) end)
		end)
	end

	-- Freecam táctil a pie, basada en Cámara hack.txt; no mueve al personaje.
	local freecamEnabled = false
	local freecamPart, freecamConn, freecamJoyInput, freecamLookInput
	local freecamDir = Vector2.zero
	local freecamYaw, freecamPitch = 0, 0
	local freecamGui = Instance.new("Frame")
	freecamGui.Name = "TouchLeftFreecamJoystick"
	freecamGui.Size = UDim2.fromOffset(130, 130)
	freecamGui.Position = UDim2.new(0.08, 0, 0.55, 0)
	freecamGui.BackgroundColor3 = Color3.new(0, 0, 0)
	freecamGui.BackgroundTransparency = 0.65
	freecamGui.Visible = false
	freecamGui.Parent = TouchPanelGui
	Instance.new("UICorner", freecamGui).CornerRadius = UDim.new(1, 0)
	local freecamKnob = Instance.new("Frame")
	freecamKnob.Size = UDim2.fromOffset(55, 55)
	freecamKnob.Position = UDim2.new(0.5, -27.5, 0.5, -27.5)
	freecamKnob.BackgroundColor3 = Color3.new(1, 1, 1)
	freecamKnob.BackgroundTransparency = 0.3
	freecamKnob.Parent = freecamGui
	Instance.new("UICorner", freecamKnob).CornerRadius = UDim.new(1, 0)

	SettingsVisual.SetTouchLeftFreecam = function(enabled)
		if enabled == freecamEnabled then return end
		freecamEnabled = enabled
		freecamGui.Visible = enabled
		if enabled then
			local cam = workspace.CurrentCamera
			local pitch, yaw = cam.CFrame:ToOrientation()
			freecamPitch, freecamYaw = math.deg(pitch), math.deg(yaw)
			freecamPart = Instance.new("Part")
			freecamPart.Name = "TouchLeftFreecamAnchor"
			freecamPart.Anchored = true
			freecamPart.CanCollide = false
			freecamPart.Transparency = 1
			freecamPart.CFrame = cam.CFrame * CFrame.new(0, 15, 0)
			freecamPart.Parent = workspace
			cam.CameraType = Enum.CameraType.Scriptable
			freecamConn = RunService.RenderStepped:Connect(function(dt)
				if not freecamEnabled or not freecamPart.Parent then return end
				local rot = CFrame.Angles(0, math.rad(freecamYaw), 0) * CFrame.Angles(math.rad(freecamPitch), 0, 0)
				if freecamDir.Magnitude > 0 then
					local power = math.min(freecamDir.Magnitude, 1)
					local speed = 300 * power * (power > 0.9 and 1.8 or 1)
					local direction = rot.LookVector * -freecamDir.Y + rot.RightVector * freecamDir.X
					freecamPart.CFrame = freecamPart.CFrame + direction * speed * dt
				end
				cam.CFrame = CFrame.new(freecamPart.Position) * rot
			end)
		else
			if freecamConn then freecamConn:Disconnect(); freecamConn = nil end
			if freecamPart then freecamPart:Destroy(); freecamPart = nil end
			freecamDir, freecamJoyInput, freecamLookInput = Vector2.zero, nil, nil
			freecamKnob.Position = UDim2.new(0.5, -27.5, 0.5, -27.5)
			local cam = workspace.CurrentCamera
			cam.CameraType = Enum.CameraType.Custom
			local char = Player.Character
			local hum = char and char:FindFirstChildOfClass("Humanoid")
			if hum then cam.CameraSubject = hum end
		end
	end
	freecamGui.InputBegan:Connect(function(input)
		if freecamEnabled and input.UserInputType == Enum.UserInputType.Touch then freecamJoyInput = input end
	end)
	UserInputService.InputBegan:Connect(function(input, processed)
		if not freecamEnabled or processed or input.UserInputType ~= Enum.UserInputType.Touch then return end
		if input.Position.X > workspace.CurrentCamera.ViewportSize.X / 2 then freecamLookInput = input end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if not freecamEnabled then return end
		if input == freecamJoyInput then
			local center = freecamGui.AbsolutePosition + freecamGui.AbsoluteSize / 2
			local offset = Vector2.new(input.Position.X, input.Position.Y) - center
			local distance = math.min(offset.Magnitude, freecamGui.AbsoluteSize.X / 2)
			local direction = offset.Magnitude > 0 and offset.Unit or Vector2.zero
			freecamDir = direction * (distance / (freecamGui.AbsoluteSize.X / 2))
			freecamKnob.Position = UDim2.fromOffset(65 + direction.X * distance - 27.5, 65 + direction.Y * distance - 27.5)
		elseif input == freecamLookInput then
			freecamYaw = freecamYaw - input.Delta.X * 0.4
			freecamPitch = math.clamp(freecamPitch - input.Delta.Y * 0.4, -80, 80)
		end
	end)
	UserInputService.InputEnded:Connect(function(input)
		if input == freecamJoyInput then
			freecamJoyInput = nil
			freecamDir = Vector2.zero
			freecamKnob.Position = UDim2.new(0.5, -27.5, 0.5, -27.5)
		elseif input == freecamLookInput then freecamLookInput = nil end
	end)

	SettingsVisual.TouchLeftBoxAction = function()
		local _, _, seat = SettingsVisual.TouchSnapCarGetVehicle()

		if seat then
			if freecamEnabled then SettingsVisual.SetTouchLeftFreecam(false) end
			local S = SettingsVisual.TouchSnapCarState

			-- CARRO + SUPERFICIE: la izquierda es espectador del Target Line.
			if S and not S.Enabled then
				SettingsVisual.SetTouchCarSpectate(not SettingsVisual.TouchCarSpectateEnabled)
				return
			end

			-- CARRO + SNAP CAR ABAJO: conserva el TP centrado anterior.
			if SettingsVisual.TouchCarOneShotBusy then return end
			followCheck.Text = "TP"
			followCheck.BackgroundColor3 = COLORS.Blue

			task.spawn(function()
				SettingsVisual.TouchCarOneShotTeleport()
				task.wait(0.05)
				if followCheck and followCheck.Parent then
					followCheck.Text = "TP"
					followCheck.BackgroundColor3 = Color3.fromRGB(28, 31, 42)
				end
			end)
			return
		end

		SettingsVisual.SetTouchLeftFreecam(not freecamEnabled)
	end

	followCheck.Activated:Connect(SettingsVisual.TouchLeftBoxAction)

	RunService.Heartbeat:Connect(function()
		if not SettingsVisual.TouchTargetFollowEnabled then return end

		local target = SettingsVisual.TouchTargetFollowPlayer
		local targetChar = target and target.Character
		local targetHum = targetChar and targetChar:FindFirstChildOfClass("Humanoid")
		local targetRoot = targetChar and targetChar:FindFirstChild("HumanoidRootPart")

		local char = Player.Character
		local hum = char and char:FindFirstChildOfClass("Humanoid")
		local root = char and char:FindFirstChild("HumanoidRootPart")

		if not targetRoot or not targetHum or targetHum.Health <= 0 or not root or not hum or hum.Health <= 0 then
			SettingsVisual.SetTouchTargetFollow(false)
			return
		end

		local distance = tonumber(SettingsVisual.TouchTargetFollowDistance) or 5
		local frontPos = targetRoot.Position + (targetRoot.CFrame.LookVector * distance)
		local desired = CFrame.lookAt(frontPos, targetRoot.Position)

		pcall(function()
			char:PivotTo(desired)
			root.AssemblyLinearVelocity = Vector3.zero
			root.AssemblyAngularVelocity = Vector3.zero
		end)
	end)
end

-- Casilla derecha:
-- EN CARRO: toggle automático. Cuando Snap Car está abajo, detecta primero
-- el CurrentTarget de Target Line (si está arriba) y, si no, al enemigo
-- válido más cercano que esté encima. Solo dispara después de 1 segundo
-- prácticamente parado, hace TP + regreso y vuelve a quedar esperando.
-- A PIE conserva exactamente el modo TP hacia arriba original.
do
	local upCheck = Instance.new("TextButton", TouchCard)
	upCheck.Name = "TouchUpCheck"
	upCheck.Size = UDim2.fromOffset(18, 18)
	upCheck.Position = UDim2.new(1, -26, 1, -27)
	upCheck.BackgroundColor3 = Color3.fromRGB(28, 31, 42)
	upCheck.BackgroundTransparency = 0.35
	upCheck.BorderSizePixel = 0
	upCheck.Text = ""
	upCheck.TextColor3 = COLORS.White
	upCheck.TextSize = 13
	upCheck.Font = Enum.Font.GothamBold
	upCheck.ZIndex = 5
	Instance.new("UICorner", upCheck).CornerRadius = UDim.new(0, 4)

    SettingsVisual.TouchUpCheck = upCheck

    local carTPLabel = Instance.new("TextLabel", TouchCard)
    carTPLabel.Name = "CHINO_CarTPLabel"
    carTPLabel.Size = UDim2.fromOffset(52, 13)
    carTPLabel.Position = UDim2.new(1, -17, 1, -48)
    carTPLabel.AnchorPoint = Vector2.new(0.5, 0)
    carTPLabel.BackgroundTransparency = 1
    carTPLabel.Text = "Car tp"
    carTPLabel.TextColor3 = Color3.fromRGB(177, 224, 255)
    carTPLabel.TextStrokeTransparency = 0.65
    carTPLabel.TextSize = 9
    carTPLabel.Font = Enum.Font.GothamBold
    carTPLabel.TextXAlignment = Enum.TextXAlignment.Center
    carTPLabel.TextTruncate = Enum.TextTruncate.AtEnd
    carTPLabel.ZIndex = 7
    carTPLabel.Visible = true
    SettingsVisual.TouchCarTPLabel = carTPLabel

    SettingsVisual.TouchRightBoxAction = function()
		local _, _, seat = SettingsVisual.TouchSnapCarGetVehicle()

		if seat then
			local S = SettingsVisual.TouchSnapCarState

			-- Superficie + Snap Car OFF: TP centrado inmediato al Target Line.
			if S and not S.Enabled then
				if SettingsVisual.TouchCarOneShotBusy then return end
				upCheck.Text = "TP"
				upCheck.BackgroundColor3 = COLORS.Blue
				task.spawn(function()
					-- Primero refresca/recuerda el Target Line. Si el modo de items está
					-- activo, usa el drop más cercano a la última posición de ese objetivo.
					SettingsVisual.TouchCarRememberRightTarget()
					local itemPart = nil
					if SettingsVisual.TouchRightDroppedItemsEnabled then
						itemPart = SettingsVisual.TouchCarGetTargetDropPart()
					end
					if itemPart then
						-- TP Items conserva su ruta sin cambios.
						SettingsVisual.TouchCarOneShotTeleport(true, itemPart)
					else
						-- Superficie + Snap Car OFF: ruta original CHINO corregido.
						SettingsVisual.TouchCarRightSurfaceOriginalTP()
					end
					task.wait(0.05)
					if upCheck and upCheck.Parent then
						upCheck.Text = ""
						upCheck.BackgroundColor3 = Color3.fromRGB(28, 31, 42)
					end
				end)
				return
			end

			if S then
				S.AutoEnemySnapEnabled = not S.AutoEnemySnapEnabled
				S.AutoEnemySnapStillSince = nil
			end

			upCheck.Text = "TPx3"
			upCheck.BackgroundColor3 =
				(S and S.AutoEnemySnapEnabled)
				and COLORS.Blue
				or Color3.fromRGB(28, 31, 42)
			return
		end

        -- A PIE: la casilla derecha ahora invoca exactamente Pull Car Owner.
        -- No modifica la profundidad, el número ni Snap Car.
        local didPull = false
        if SettingsVisual.PullOwnedCar then
            local ok, result = pcall(SettingsVisual.PullOwnedCar)
            didPull = ok and result == true
        end
        SettingsVisual.TouchCarTPFeedbackUntil = os.clock() + 0.28
        upCheck.BackgroundColor3 = didPull and COLORS.Blue
            or Color3.fromRGB(45, 55, 70)
        upCheck.Text = ""
        return
	end

	upCheck.Activated:Connect(SettingsVisual.TouchRightBoxAction)
end

-- CHINO: retirada casilla 360 del panel tactil (a peticion del usuario).
-- Auto Shoot se controla solo desde Silent Aim; TP izquierdo/derecho intactos.
SettingsVisual.AutoShoot360Enabled = false
SettingsVisual.TouchAutoShoot360Check = nil
SettingsVisual.RefreshAutoShoot360Check = function() end

-- ========================================================--
-- CHINO VEHICLE VOID RESCUE: si se desasienta y su coche propio
-- esta bajo la superficie registrada, recoloca el coche sobre un piso.
-- Complementa el rescate Snap Car ya existente; NO mueve coches ajenos.
-- No actuamos mientras se conduce normalmente cerca del suelo.
-- ========================================================--
do
    local recovery = { Vehicle=nil, Seat=nil, SurfaceY=nil, SafeXZ=nil,
                       Root=nil, LastUpdate=0, Busy=false, Connection=nil }
    SettingsVisual.TouchCarVoidRecovery = recovery

    local function vehicleIsMine(vehicle)
        if not vehicle or not vehicle:IsA("Model") then return false end
        if SettingsVisual.VehicleActionIsMine then
            return SettingsVisual.VehicleActionIsMine(vehicle)
        end
        for _,name in ipairs({"OwnerUserId","OwnerId","Owner","UserId"}) do
            local value=vehicle:GetAttribute(name)
            if value~=nil and tostring(value)==tostring(Player.UserId) then return true end
        end
        return false
    end

    local function floorAt(vehicle, sample, originY, offsetUp)
        if not vehicle or not vehicle.Parent or not sample then return nil end
        local params=RaycastParams.new()
        params.FilterType=Enum.RaycastFilterType.Exclude
        local ignore={vehicle}
        if Player.Character then table.insert(ignore,Player.Character) end
        local vehicles=workspace:FindFirstChild("Vehicles")
        if vehicles then table.insert(ignore,vehicles) end
        params.FilterDescendantsInstances=ignore
        params.IgnoreWater=true
        local begin=Vector3.new(sample.X,originY+(offsetUp or 65),sample.Z)
        local hit=workspace:Raycast(begin,Vector3.new(0,-150,0),params)
        if hit and hit.Instance and (hit.Instance==workspace.Terrain or hit.Instance.CanCollide) then
            return hit.Position.Y
        end
        return nil
    end

    local function locateRoot(vehicle,seat)
        if not vehicle or not vehicle.Parent then return nil end
        return vehicle.PrimaryPart
            or (seat and seat.AssemblyRootPart)
            or (seat and seat:IsA("BasePart") and seat)
            or vehicle:FindFirstChildWhichIsA("BasePart",true)
    end

    local function rescueVehicle(vehicle,seat,surfaceY,safeXZ,forceFalling)
        if recovery.Busy or not vehicle or not vehicle.Parent or not vehicleIsMine(vehicle) then return false end
        local S = SettingsVisual.TouchSnapCarState
        -- Nunca competir con el motor que está subiendo el coche.
        if S and S.Exiting and S.Vehicle == vehicle then return false end
        local root=locateRoot(vehicle,seat)
        if not root then return false end
        surfaceY=tonumber(surfaceY)
        if not surfaceY then return false end
        local yVel = root.AssemblyLinearVelocity.Y
        -- En una caída se rescata aunque aún no haya cruzado la calle.
        -- Si una salida protegida ya lo dejó estable sobre el piso,
        -- no hacer un segundo teleport innecesario.
        if forceFalling then
            if root.Position.Y >= surfaceY-4
                and root.Position.Y <= surfaceY+12
                and yVel >= -5 then return true end
        elseif root.Position.Y >= surfaceY-9 then
            return false
        end
        recovery.Busy=true
        local pieces={}
        local success,err=pcall(function()
            local location=root.Position
            local ground=floorAt(vehicle,location,surfaceY)
            local position=location
            if not ground and safeXZ then
                ground=floorAt(vehicle,safeXZ,surfaceY)
                if ground then position=safeXZ end
            end
            ground=ground or surfaceY
            local boxCF,boxSize=vehicle:GetBoundingBox()
            local rootBottom=root.Position.Y-(boxCF.Position.Y-boxSize.Y*.5)
            local flat=SettingsVisual.TouchSnapCarFlatLook(root.CFrame)
            local goal=SettingsVisual.TouchSnapCarUpright(
                Vector3.new(position.X,ground+math.max(0,rootBottom)+2,position.Z),flat)
            local transform=root.CFrame:ToObjectSpace(vehicle:GetPivot())
            for _,part in ipairs(vehicle:GetDescendants()) do
                if part:IsA("BasePart") then
                    pieces[part]={part.CanCollide,part.CanTouch,part.CanQuery}
                    part.CanCollide=false;part.CanTouch=false
                end
            end
            vehicle:PivotTo(goal*transform)
            if SettingsVisual.TouchSnapCarZeroMotion then
                SettingsVisual.TouchSnapCarZeroMotion(vehicle,root)
            end
            task.wait(0.12)
        end)
        -- Restauración SIEMPRE, incluso si el teleporte falla.
        for part,props in pairs(pieces) do
            if part.Parent then
                pcall(function()
                    part.CanCollide=props[1];part.CanTouch=props[2];part.CanQuery=props[3]
                end)
            end
        end
        recovery.Busy=false
        if not success then warn("[CHINO Vehicle Void Rescue]",err) end
        return success
    end
    SettingsVisual.TouchCarRescueAfterExit=rescueVehicle

    -- Botón Snap Car cuando está APAGADO: si el auto propio cayó al
    -- vacío MUCHO más abajo del suelo guardado, el primer toque lo rescata
    -- arriba de la calle. No hay TP por una bajada normal o cuando Snap
    -- está encendido, y no se usa un Y fijo para todos los mapas.
    SettingsVisual.TouchCarRescueVoidOnSnapPress = function()
        local S = SettingsVisual.TouchSnapCarState
        if not S or S.Enabled or S.Exiting then return false end
        local vehicle, root, seat = SettingsVisual.TouchSnapCarGetVehicle()
        if not vehicle or not root or not seat or not vehicleIsMine(vehicle) then
            return false
        end
        if recovery.Vehicle ~= vehicle then return false end
        local originalGroundY = tonumber(recovery.SurfaceY)
        if not originalGroundY then return false end
        -- Umbral de emergencia: >38 studs bajo el último piso validado.
        if originalGroundY - root.Position.Y < 38 then return false end

        -- Evita confundir una carretera inferior real con el vacío:
        -- revisar si el vehículo tiene suelo cercano bajo sus ruedas.
        local boxCF, boxSize = vehicle:GetBoundingBox()
        local lowest = boxCF.Position.Y - boxSize.Y * 0.5
        local params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Exclude
        params.IgnoreWater = true
        local ignored = {vehicle}
        if Player.Character then table.insert(ignored, Player.Character) end
        local vehicles = workspace:FindFirstChild("Vehicles")
        if vehicles then table.insert(ignored, vehicles) end
        params.FilterDescendantsInstances = ignored
        local nearbyGround = workspace:Raycast(
            Vector3.new(root.Position.X, lowest + 3, root.Position.Z),
            Vector3.new(0, -14, 0), params
        )
        if nearbyGround and nearbyGround.Instance
            and (nearbyGround.Instance == workspace.Terrain
                 or nearbyGround.Instance.CanCollide) then
            return false
        end

        -- Consumir este toque incluso si falla el rescate, para no activar
        -- de forma accidental una nueva BAJADA cuando ya se cayó al vacío.
        if recovery.Busy then return true end
        local ok, rescued = pcall(rescueVehicle,
            vehicle, seat, originalGroundY, recovery.SafeXZ, true)
        if not ok or not rescued then
            warn("[CHINO] Snap Car: rescate de vacío no confirmado", rescued)
        end
        return true
    end

    local function bindChar(char)
        if recovery.Connection then recovery.Connection:Disconnect();recovery.Connection=nil end
        recovery.Vehicle=nil; recovery.SurfaceY=nil; recovery.SafeXZ=nil
        task.spawn(function()
            local hum=char and char:WaitForChild("Humanoid",5)
            if not hum then return end
            recovery.Connection=hum.Seated:Connect(function(seated,seat)
                if seated and seat and seat:IsA("VehicleSeat") then
                    recovery.Seat=seat
                    recovery.Vehicle=seat:FindFirstAncestorOfClass("Model")
                    local S=SettingsVisual.TouchSnapCarState
                    if S and S.Enabled and S.SnapGroundY then
                        recovery.SurfaceY=S.SnapGroundY
                        recovery.SafeXZ=S.SafeStartXZ
                    else
                        local vr=locateRoot(recovery.Vehicle,seat)
                        if vr and recovery.Vehicle then
                            local y=floorAt(recovery.Vehicle,vr.Position,vr.Position.Y,6)
                            if y then
                                recovery.SurfaceY=y
                                recovery.SafeXZ=Vector3.new(vr.Position.X,y,vr.Position.Z)
                            end
                        end
                    end
                    return
                end
                if seated then return end
                local vehicle=recovery.Vehicle
                local lastSeat=recovery.Seat
                local cachedY=recovery.SurfaceY
                local safeXZ=recovery.SafeXZ
                local S=SettingsVisual.TouchSnapCarState
                if S and S.Vehicle==vehicle and S.SnapGroundY then
                    cachedY=S.SnapGroundY
                end
                local root = locateRoot(vehicle,lastSeat)
                local snapWasActive = S and S.Vehicle == vehicle
                    and (S.Enabled or S.Exiting)
                local descending = root and root.AssemblyLinearVelocity.Y < -8
                local unexpectedlyHigh = root and cachedY
                    and root.Position.Y > cachedY + 14
                -- El rescate se arma AL BAJAR del coche, aunque en ese
                -- preciso instante aún esté arriba de la calle.
                local mustRescue = snapWasActive or descending or unexpectedlyHigh
                local safeGround = tonumber(cachedY)
                local goodXZ = safeXZ
                    or (S and S.Vehicle == vehicle and S.SafeStartXZ)
                if not safeGround and goodXZ and root then
                    safeGround = floorAt(vehicle,goodXZ,goodXZ.Y)
                end
                task.spawn(function()
                    if hum.SeatPart then return end
                    -- Primero terminar la salida normal de Snap; nunca
                    -- hacer 2 PivotTo concurrentes sobre el mismo coche.
                    if S and S.Vehicle == vehicle and S.Enabled
                        and not S.Exiting and SettingsVisual.TouchSnapCarSet then
                        pcall(function() SettingsVisual.TouchSnapCarSet(false) end)
                    end
                    local waitUntil = os.clock()+2
                    while S and S.Exiting and os.clock() < waitUntil do
                        task.wait(0.05)
                    end
                    if hum.SeatPart or not vehicle or not vehicle.Parent then return end
                    rescueVehicle(vehicle,lastSeat,safeGround,goodXZ,mustRescue)
                end)
                -- Segunda comprobación por si el servidor vuelve a mandar
                -- el coche debajo del mapa justo después de la salida.
                task.delay(1.05,function()
                    if hum.SeatPart or not vehicle or not vehicle.Parent then return end
                    rescueVehicle(vehicle,lastSeat,safeGround,goodXZ,false)
                end)
                recovery.Vehicle=nil;recovery.Seat=nil
            end)
        end)
    end
    bindChar(Player.Character)
    Player.CharacterAdded:Connect(bindChar)

    -- Mientras conduce encima del piso, registrar el ultimo suelo seguro.
    -- Bajo Snap conservar la altura ANTERIOR del suelo, no -200m.
    RunService.Heartbeat:Connect(function()
        local now=os.clock()
        if now-recovery.LastUpdate<0.32 then return end
        recovery.LastUpdate=now
        local vehicle,root,seat=SettingsVisual.TouchSnapCarGetVehicle()
        if not vehicle or not root or not seat then return end
        if not vehicleIsMine(vehicle) then return end
        recovery.Vehicle=vehicle;recovery.Seat=seat
        local S=SettingsVisual.TouchSnapCarState
        if S and S.Enabled and S.Vehicle==vehicle then
            if S.SnapGroundY then recovery.SurfaceY=S.SnapGroundY end
            if S.SafeStartXZ and not recovery.SafeXZ then recovery.SafeXZ=S.SafeStartXZ end
        else
            local hitY=floorAt(vehicle,root.Position,root.Position.Y)
            if hitY and root.Position.Y-hitY<16 and root.Position.Y-hitY>=-3 then
                recovery.SurfaceY=hitY
                recovery.SafeXZ=Vector3.new(root.Position.X,hitY,root.Position.Z)
            end
        end
    end)
end

-- Keybinds pequeños para las dos casillas. Solo visibles en carro.
local touchLeftKeyLabel = Instance.new("TextButton", TouchCard)
touchLeftKeyLabel.Name = "TouchLeftKeyLabel"
touchLeftKeyLabel.Size = UDim2.fromOffset(44, 14)
touchLeftKeyLabel.Position = UDim2.new(0, 2, 0, 68)
touchLeftKeyLabel.BackgroundTransparency = 1
touchLeftKeyLabel.Text = "K:" .. SettingsVisual.TouchLeftBoxKey.Name
touchLeftKeyLabel.TextColor3 = COLORS.Muted
touchLeftKeyLabel.TextSize = 7
touchLeftKeyLabel.Font = Enum.Font.Gotham
touchLeftKeyLabel.Visible = false
touchLeftKeyLabel.ZIndex = 7
SettingsVisual.TouchLeftKeyLabel = touchLeftKeyLabel

local touchRightKeyLabel = Instance.new("TextButton", TouchCard)
touchRightKeyLabel.Name = "TouchRightKeyLabel"
touchRightKeyLabel.Size = UDim2.fromOffset(44, 14)
touchRightKeyLabel.Position = UDim2.new(1, -46, 0, 68)
touchRightKeyLabel.BackgroundTransparency = 1
touchRightKeyLabel.Text = "K:" .. SettingsVisual.TouchRightBoxKey.Name
touchRightKeyLabel.TextColor3 = COLORS.Muted
touchRightKeyLabel.TextSize = 7
touchRightKeyLabel.Font = Enum.Font.Gotham
touchRightKeyLabel.Visible = false
touchRightKeyLabel.ZIndex = 7
SettingsVisual.TouchRightKeyLabel = touchRightKeyLabel

touchLeftKeyLabel.Activated:Connect(function()
	SettingsVisual.SelectingTouchLeftBoxKey = true
	SettingsVisual.SelectingTouchRightBoxKey = false
	SettingsVisual.SelectingTouchPanelKey = false
	SettingsVisual.SelectingGhostKey = false
	touchLeftKeyLabel.Text = "K:..."
end)

touchRightKeyLabel.Activated:Connect(function()
	SettingsVisual.SelectingTouchRightBoxKey = true
	SettingsVisual.SelectingTouchLeftBoxKey = false
	SettingsVisual.SelectingTouchPanelKey = false
	SettingsVisual.SelectingGhostKey = false
	touchRightKeyLabel.Text = "K:..."
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if input.UserInputType ~= Enum.UserInputType.Keyboard then return end

	if SettingsVisual.SelectingTouchLeftBoxKey then
		if input.KeyCode ~= Enum.KeyCode.Unknown then
			SettingsVisual.TouchLeftBoxKey = input.KeyCode
			SettingsVisual.SelectingTouchLeftBoxKey = false
			touchLeftKeyLabel.Text = "K:" .. input.KeyCode.Name
		end
		return
	end

	if SettingsVisual.SelectingTouchRightBoxKey then
		if input.KeyCode ~= Enum.KeyCode.Unknown then
			SettingsVisual.TouchRightBoxKey = input.KeyCode
			SettingsVisual.SelectingTouchRightBoxKey = false
			touchRightKeyLabel.Text = "K:" .. input.KeyCode.Name
		end
		return
	end

	if gameProcessed or not TouchPanelGui.Enabled then return end
	local _, _, seat = SettingsVisual.TouchSnapCarGetVehicle()
	if not seat then return end

	if input.KeyCode == SettingsVisual.TouchLeftBoxKey then
		if SettingsVisual.TouchLeftBoxAction then
			SettingsVisual.TouchLeftBoxAction()
		end
	elseif input.KeyCode == SettingsVisual.TouchRightBoxKey then
		if SettingsVisual.TouchRightBoxAction then
			SettingsVisual.TouchRightBoxAction()
		end
	end
end)

-- Mantiene fresca la última posición del objetivo de Target Line para la casilla derecha.
task.spawn(function()
    while TouchPanelGui and TouchPanelGui.Parent do
        task.wait(0.12)
        local candidate = CurrentLockedTarget or SettingsVisual.DirectVisualLockedTarget or CurrentTarget
        local ch = candidate and candidate.Character
        local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
        if candidate and hrp then
            SettingsVisual.TouchCarLastRightTarget = candidate
            SettingsVisual.TouchCarLastRightTargetPosition = hrp.Position
        end
    end
end)

--========================================================--
-- CASILLA DERECHA EN CARRO: AUTO TP DESPUÉS DE 1s PARADO
--========================================================--
task.spawn(function()
	while TouchPanelGui and TouchPanelGui.Parent do
		RunService.Heartbeat:Wait()

		local S = SettingsVisual.TouchSnapCarState
		local vehicle, root, seat = SettingsVisual.TouchSnapCarGetVehicle()

		if not S
			or not S.AutoEnemySnapEnabled
			or not S.Enabled
			or not vehicle
			or not root
			or not seat then

			if S then
				S.AutoEnemySnapStillSince = nil
			end
			continue
		end

		-- Solo usamos velocidad horizontal para que pequeñas correcciones Y del
		-- modo underground no rompan el contador de 1 segundo.
		local velocity = root.AssemblyLinearVelocity
		local horizontalSpeed = Vector3.new(velocity.X, 0, velocity.Z).Magnitude
		local threshold = tonumber(S.AutoEnemySnapSpeedThreshold) or 1.35

		local targetRoot = select(
			1,
			SettingsVisual.TouchCarGetEnemyAbove(vehicle, root)
		)

		if targetRoot
			and horizontalSpeed <= threshold
			and not SettingsVisual.TouchCarOneShotBusy
			and not S.OneShotBusy then

			local now = os.clock()
			if not S.AutoEnemySnapStillSince then
				S.AutoEnemySnapStillSince = now
			end

			local stopSeconds = tonumber(S.AutoEnemySnapStopSeconds) or 1.00
			local cooldown = tonumber(S.AutoEnemySnapCooldown) or 0.60
			local lastTrigger = tonumber(S.AutoEnemySnapLastTrigger) or 0

			if now - S.AutoEnemySnapStillSince >= stopSeconds
				and now - lastTrigger >= cooldown then

				S.AutoEnemySnapStillSince = nil
				S.AutoEnemySnapLastTrigger = now

				task.spawn(function()
					SettingsVisual.TouchCarOneShotTeleport(false, nil, 3)
				end)
			end
		else
			-- Si te mueves, se pierde el segundo acumulado y tiene que volver a
			-- estar quieto 1 segundo completo antes del siguiente TP.
			S.AutoEnemySnapStillSince = nil
		end
	end
end)

--========================================================--
-- POSE INCLINADA DEL PERSONAJE EN VEHÍCULO
-- Mantiene el HumanoidRootPart/vehículo normal y dobla el cuerpo desde el
-- motor raíz para no meter el personaje debajo del carro. Al bajarte restaura
-- el C0 original inmediatamente.
--========================================================--
SettingsVisual.TouchCarRestoreSeatPose = function()
	local S = SettingsVisual.TouchSnapCarState
	if not S then return end

	local motor = S.SeatPoseMotor
	local originalC0 = S.SeatPoseOriginalC0

	if motor and motor.Parent and originalC0 then
		pcall(function()
			motor.C0 = originalC0
		end)
	end

	if S.SeatPoseNeck and S.SeatPoseNeck.Parent and S.SeatPoseNeckC0 then
		pcall(function() S.SeatPoseNeck.C0 = S.SeatPoseNeckC0 end)
	end
	S.SeatPoseNeck = nil
	S.SeatPoseNeckC0 = nil
	S.SeatPoseMotor = nil
	S.SeatPoseOriginalC0 = nil
	S.SeatPoseApplied = false
end

SettingsVisual.TouchCarFindRootMotor = function(char)
	if not char then return nil end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return nil end

	for _, obj in ipairs(char:GetDescendants()) do
		if obj:IsA("Motor6D") and (obj.Part0 == hrp or obj.Part1 == hrp) then
			return obj
		end
	end

	return nil
end

SettingsVisual.TouchCarApplySeatPose = function()
	local S = SettingsVisual.TouchSnapCarState
	if not S then return end

	local char = Player.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	local seat = hum and hum.SeatPart

	-- Solo inclina al estar activado "Invisible" Y sentado en vehículo.
	-- Si se baja, muere o apaga la opción, restaura C0 originales.
	if not SettingsVisual.TouchCarSeatPoseEnabled
		or not seat
		or not SettingsVisual.IsVehicleSeat(seat) then
		SettingsVisual.TouchCarRestoreSeatPose()
		return
	end

	local motor = SettingsVisual.TouchCarFindRootMotor(char)
	if not motor then
		SettingsVisual.TouchCarRestoreSeatPose()
		return
	end

	if S.SeatPoseMotor ~= motor then
		SettingsVisual.TouchCarRestoreSeatPose()
		S.SeatPoseMotor = motor
		S.SeatPoseOriginalC0 = motor.C0
		local head = char:FindFirstChild("Head")
		for _, joint in ipairs(char:GetDescendants()) do
			if joint:IsA("Motor6D") and (joint.Name == "Neck" or (head and joint.Part1 == head)) then
				S.SeatPoseNeck = joint
				S.SeatPoseNeckC0 = joint.C0
				break
			end
		end
	end

	local base = S.SeatPoseOriginalC0
	if not base then return end

	-- POSE EXORCISTA EN VEHICULO, INDEPENDIENTE DE LA CAMARA.
	-- "Invisible" habilita la pose; "Giro" conserva inclinacion y fuerza.
	-- Valor 0 = postura original. -101 (predeterminado) = torsion casi 180º.
	-- Solo alteramos los Motor6D del avatar. El HumanoidRootPart, el SeatWeld,
	-- el chasis, los controles de conduccion y Camera.CFrame no se tocan.
	local angle = math.clamp(tonumber(SettingsVisual.TouchCarSeatPoseAngle) or -101, -120, 120)
	local scaled = -angle / 101
	local amount = math.clamp(math.abs(angle) / 101, 0, 1)
	local rotationBack = math.rad(180 * amount)
	local sideTwist = math.rad(17 * amount)
	pcall(function()
		motor.C0 =
			base
			* CFrame.new(0, -0.24 * amount, -1.38 * scaled)
			* CFrame.Angles(math.rad(angle), 0, 0)
			* CFrame.Angles(0, rotationBack, sideTwist)
		-- Cabeza recogida, con una torsion adicional para la postura.
		-- Como no movemos el RootPart, la camara puede mirar al frente.
		if S.SeatPoseNeck and S.SeatPoseNeck.Parent and S.SeatPoseNeckC0 then
			S.SeatPoseNeck.C0 = S.SeatPoseNeckC0
				* CFrame.new(0, -0.28 * amount, -0.34 * scaled)
				* CFrame.Angles(math.rad(-42 * scaled), math.rad(12 * amount), -sideTwist)
		end
	end)

	S.SeatPoseApplied = true
end

-- POSE AUTOMATICA EN UN SOLO SCRIPT (DELTA / CLIENTE)
-- No requiere RemoteEvent ni complemento de servidor.
-- La pose es local: su visibilidad en otros clientes no está garantizada.
SettingsVisual.TouchCarPoseCharacterConnection = nil
SettingsVisual.TouchCarPoseSeatConnection = nil
SettingsVisual.TouchCarPoseGeneration = 0

SettingsVisual.TouchCarBindPoseCharacter = function(char)
    SettingsVisual.TouchCarPoseGeneration += 1
    local generation = SettingsVisual.TouchCarPoseGeneration
    if SettingsVisual.TouchCarPoseSeatConnection then
        SettingsVisual.TouchCarPoseSeatConnection:Disconnect()
        SettingsVisual.TouchCarPoseSeatConnection = nil
    end
    SettingsVisual.TouchCarRestoreSeatPose()
    if not char then return end
    task.spawn(function()
        local hum = char:WaitForChild("Humanoid", 12)
        if not hum or generation ~= SettingsVisual.TouchCarPoseGeneration then return end
        SettingsVisual.TouchCarPoseSeatConnection = hum.Seated:Connect(function()
            task.defer(function()
                if generation == SettingsVisual.TouchCarPoseGeneration then
                    SettingsVisual.TouchCarApplySeatPose()
                end
            end)
        end)
        -- En algunos vehículos SeatPart se actualiza un poco después de Seated.
        for _ = 1, 12 do
            if generation ~= SettingsVisual.TouchCarPoseGeneration then return end
            SettingsVisual.TouchCarApplySeatPose()
            task.wait(0.15)
        end
    end)
end

SettingsVisual.TouchCarSeatPoseConnection = RunService.RenderStepped:Connect(function()
    SettingsVisual.TouchCarApplySeatPose()
end)
SettingsVisual.TouchCarPoseCharacterConnection = Player.CharacterAdded:Connect(function(char)
    SettingsVisual.TouchCarBindPoseCharacter(char)
end)
Player.CharacterRemoving:Connect(function()
    SettingsVisual.TouchCarPoseGeneration += 1
    if SettingsVisual.TouchCarPoseSeatConnection then
        SettingsVisual.TouchCarPoseSeatConnection:Disconnect()
        SettingsVisual.TouchCarPoseSeatConnection = nil
    end
    SettingsVisual.TouchCarRestoreSeatPose()
end)
SettingsVisual.TouchCarBindPoseCharacter(Player.Character)

-- RESCATE SOLO AL BAJARSE DEL VEHICULO CON SNAP CAR BAJO EL SUELO.
-- No hay rescate automatico mientras se conduce ni cuando Snap Car esta apagado.
SettingsVisual.TouchCarExitSnapVehicle = nil
SettingsVisual.TouchCarExitSnapRoot = nil
SettingsVisual.TouchCarExitSnapWasBelow = false
SettingsVisual.TouchCarExitFindSurface = function(vehicle, root)
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.IgnoreWater = true
    local filter = {vehicle}
    if Player.Character then table.insert(filter, Player.Character) end
    params.FilterDescendantsInstances = filter
    local origin = root.Position + Vector3.new(0, 160, 0)
    local hit = workspace:Raycast(origin, Vector3.new(0, -220, 0), params)
    if hit and hit.Normal.Y > 0.55 then return hit end
    return nil
end
SettingsVisual.TouchCarExitRaise = function(vehicle, root)
    if not vehicle or not vehicle.Parent or not root or not root.Parent then return end
    local hit = SettingsVisual.TouchCarExitFindSurface(vehicle, root)
    if not hit then return end
    local boxCF, boxSize = vehicle:GetBoundingBox()
    local bottomY = boxCF.Position.Y - boxSize.Y * 0.5
    if bottomY >= hit.Position.Y + 0.25 then return end
    local rootToBottom = root.Position.Y - bottomY
    local destination = Vector3.new(root.Position.X, hit.Position.Y + rootToBottom + 1.5, root.Position.Z)
    local rootToPivot = root.CFrame:ToObjectSpace(vehicle:GetPivot())
    local look = SettingsVisual.TouchSnapCarFlatLook(root.CFrame)
    pcall(function()
        vehicle:PivotTo(SettingsVisual.TouchSnapCarUpright(destination, look) * rootToPivot)
        SettingsVisual.TouchSnapCarZeroMotion(vehicle, root)
    end)
end

task.spawn(function()
    local previousVehicle = nil
    local previousRoot = nil
    local previousSnapBelow = false
    while TouchPanelGui and TouchPanelGui.Parent do
        task.wait(0.10)
        local vehicle, root, seat = SettingsVisual.TouchSnapCarGetVehicle()
        if seat and vehicle and root then
            previousVehicle = vehicle
            previousRoot = root
            local S = SettingsVisual.TouchSnapCarState
            previousSnapBelow = S and S.Enabled == true and S.Vehicle == vehicle
                and (S.DesiredRootY ~= nil)
                and (root.Position.Y <= (S.SnapGroundY or math.huge) - 1)
        elseif previousVehicle then
            local oldVehicle, oldRoot, wasSnapBelow = previousVehicle, previousRoot, previousSnapBelow
            previousVehicle, previousRoot, previousSnapBelow = nil, nil, false
            if wasSnapBelow then
                task.defer(function()
                    -- Solo se ejecuta al salir del asiento con Snap Car debajo del suelo.
                    task.wait(0.10)
                    SettingsVisual.TouchCarExitRaise(oldVehicle, oldRoot)
                end)
            end
        end
    end
end)

-- Actualiza el aspecto de las dos casillas según estés a pie o en carro.
task.spawn(function()
	while TouchPanelGui and TouchPanelGui.Parent do
		task.wait(0.10)

		local _, _, seat = SettingsVisual.TouchSnapCarGetVehicle()
		local left = SettingsVisual.TouchTargetFollowCheck
		local right = SettingsVisual.TouchUpCheck

		if seat then
			if left then
				left.Size = UDim2.fromOffset(34, 18)
				left.Position = UDim2.new(0, 8, 1, -27)
				left.Text = "TP"
				left.TextSize = 8
				left.BackgroundColor3 =
					SettingsVisual.TouchCarOneShotBusy
					and COLORS.Blue
					or Color3.fromRGB(28, 31, 42)
			end

			if right then
				local S = SettingsVisual.TouchSnapCarState
				right.Size = UDim2.fromOffset(38, 18)
				right.Position = UDim2.new(1, -46, 1, -27)
				right.Text = "TPx3"
				right.TextSize = 7
				right.BackgroundColor3 =
					(S and S.AutoEnemySnapEnabled)
					and COLORS.Blue
					or Color3.fromRGB(28, 31, 42)
			end

			if SettingsVisual.TouchLeftKeyLabel then
				SettingsVisual.TouchLeftKeyLabel.Visible = true
			end
            if SettingsVisual.TouchRightKeyLabel then
                SettingsVisual.TouchRightKeyLabel.Visible = true
            end
            if SettingsVisual.TouchCarTPLabel then
                SettingsVisual.TouchCarTPLabel.Visible = false
            end
			if SettingsVisual.TouchCarJumpButton then
				local S = SettingsVisual.TouchSnapCarState
				local vehicle, root = SettingsVisual.TouchSnapCarGetVehicle()
				local below = S and S.Enabled and not S.AboveMode and vehicle and root
                    and S.SnapGroundY and root.Position.Y < S.SnapGroundY - 1
				local hover=SettingsVisual.ChinoCarHover
				local flying=hover and hover.Active
				SettingsVisual.TouchCarJumpButton.Text = below and "P" or ""
				SettingsVisual.TouchCarJumpButton.TextSize = below and 17 or 9
                SettingsVisual.TouchCarJumpButton.BackgroundTransparency = 0.76
				SettingsVisual.TouchCarJumpButton.BackgroundColor3 =
					(below or flying) and COLORS.Blue or Color3.fromRGB(28, 32, 44)
				SettingsVisual.TouchCarJumpButton.Visible = true
			end
            -- Flecha visible exclusivamente al ir en carro bajo Snap Car.
            if SettingsVisual.TouchVerticalChaseButton then
                local S = SettingsVisual.TouchSnapCarState
                local car, root = SettingsVisual.TouchSnapCarGetVehicle()
                local below = S and S.Enabled and not S.AboveMode and car and root
                    and S.SnapGroundY and root.Position.Y < S.SnapGroundY - 1
                local b = SettingsVisual.TouchVerticalChaseButton
                b.Visible = below and true or false
                local phase = S and S.VerticalChaseMode or "ready"
                -- STOP visible al subir o bajar; flecha señala el PROXIMO sentido.
                b.BackgroundColor3 = (phase == "down" or phase == "up")
                    and Color3.fromRGB(100, 45, 140)
                    or ((phase == "stop_down" or phase == "stop_up")
                        and Color3.fromRGB(40, 90, 95)
                        or Color3.fromRGB(34, 28, 54))
                SettingsVisual.TouchVerticalChaseStroke.Color = (phase ~= "ready")
                    and Color3.fromRGB(140, 255, 205) or Color3.fromRGB(170, 120, 255)
                SettingsVisual.TouchVerticalChaseArrowHolder.Rotation =
                    (phase == "stop_down") and 180 or 0
                b.Text = (phase == "down" or phase == "up") and "STOP" or ""
                b.TextSize = 9
                b.Font = Enum.Font.GothamBold
                b.TextColor3 = Color3.fromRGB(246, 237, 255)
                SettingsVisual.TouchVerticalChaseArrowHolder.Visible =
                    (phase ~= "down" and phase ~= "up")
            end
            if SettingsVisual.TouchKeyLabel then
                SettingsVisual.TouchKeyLabel.Visible = false
            end
        else
			if left then
				left.Size = UDim2.fromOffset(18, 18)
				left.Position = UDim2.new(0, 8, 1, -27)
				left.TextSize = 13
				left.Text = SettingsVisual.TouchTargetFollowEnabled and "×" or ""
				left.BackgroundColor3 =
					SettingsVisual.TouchTargetFollowEnabled
					and COLORS.Blue
					or Color3.fromRGB(28, 31, 42)
			end

			if right then
				right.Size = UDim2.fromOffset(18, 18)
				right.Position = UDim2.new(1, -26, 1, -27)
				right.TextSize = 13
                right.Text = ""
                right.BackgroundColor3 =
                    os.clock() < (SettingsVisual.TouchCarTPFeedbackUntil or 0)
                    and COLORS.Blue
                    or Color3.fromRGB(28, 31, 42)
			end

			if SettingsVisual.TouchLeftKeyLabel then
				SettingsVisual.TouchLeftKeyLabel.Visible = false
			end
            if SettingsVisual.TouchRightKeyLabel then
                SettingsVisual.TouchRightKeyLabel.Visible = false
            end
            if SettingsVisual.TouchCarTPLabel then
                SettingsVisual.TouchCarTPLabel.Visible = true
            end
            if SettingsVisual.TouchCarJumpButton then
                SettingsVisual.TouchCarJumpButton.Visible = false
            end
            if SettingsVisual.TouchVerticalChaseButton then
                SettingsVisual.TouchVerticalChaseButton.Visible = false
            end
			if SettingsVisual.TouchKeyLabel then
				SettingsVisual.TouchKeyLabel.Visible = true
			end
		end
	end
end)

keyLabelTP.MouseButton1Click:Connect(function()
	SettingsVisual.SelectingTouchPanelKey = true
	SettingsVisual.SelectingGhostKey = false
	keyLabelTP.Text = "Key: ..."
end)

SettingsVisual.RefreshTouchDepthText = function()
	if fsInput and fsInput.Parent then
		fsInput.Text = tostring(TouchPanelValue) .. "m"
		targetDepth = TouchPanelValue
	end
end

fsInput.FocusLost:Connect(function()
	local num = tonumber(fsInput.Text:match("%d+"))
	if num then
		local snapActive =
			SettingsVisual.TouchSnapCarState
			and SettingsVisual.TouchSnapCarState.Enabled

		TouchPanelValue = math.clamp(num, 5, snapActive and 2000 or 100)
		targetDepth = TouchPanelValue
		fsInput.Text = tostring(TouchPanelValue) .. "m"

		-- EDICIÓN MANUAL: congela este valor y detiene el escaneo automático
		-- hasta que el personaje se reinicie / reaparezca.
		SettingsVisual.TouchItemDistanceManualLocked = not snapActive
		SettingsVisual.TouchItemDistanceManualValue = TouchPanelValue
		SettingsVisual.TouchItemDistanceTarget = nil
		SettingsVisual.TouchItemDistanceSavedValue = nil

		-- NUEVO: si Snap Car YA está abajo, el número se vuelve
		-- profundidad real del carro inmediatamente (30m, 40m, etc.).
		if SettingsVisual.TouchSnapCarState
			and SettingsVisual.TouchSnapCarState.Enabled
			and SettingsVisual.TouchSnapCarApplyManualDepth then
			SettingsVisual.TouchSnapCarApplyManualDepth(TouchPanelValue)
		end
	else
		fsInput.Text = tostring(TouchPanelValue) .. "m"
	end
end)

-- Al reaparecer el personaje se libera cualquier valor manual y el tracker
-- vuelve a hacer el escaneo normal desde cero. El número manual actual queda
-- como valor base hasta que encuentre un nuevo ítem válido.
SettingsVisual.TouchItemDistanceRespawnConnection =
	Player.CharacterAdded:Connect(function()
		SettingsVisual.TouchItemDistanceManualLocked = false
		SettingsVisual.TouchItemDistanceManualValue = nil
		SettingsVisual.TouchItemDistanceTarget = nil
		SettingsVisual.TouchItemDistanceSavedValue = nil

		task.defer(function()
			task.wait(0.15)
			if fsInput and fsInput.Parent then
				fsInput.Text = tostring(TouchPanelValue) .. "m"
			end
		end)
	end)

local GhostFloatingSwitchGui = Instance.new("ScreenGui", SettingsVisual.ExecutorGuiParent or CoreGui)
GhostFloatingSwitchGui.Name = "GhostFloatingSwitchGui"
GhostFloatingSwitchGui.Enabled = false

local GhostCard = Instance.new("Frame", GhostFloatingSwitchGui)
GhostCard.Size = UDim2.new(0, 130, 0, 75)
GhostCard.Position = UDim2.new(0.04, 0, 0.58, 0)
GhostCard.BackgroundColor3 = COLORS.Glass
GhostCard.BackgroundTransparency = 0.35
GhostCard.BorderSizePixel = 0
GhostCard.Active = true
GhostCard.Draggable = true
Instance.new("UICorner", GhostCard).CornerRadius = UDim.new(0, 14)
GhostCard.ClipsDescendants = true

-- Misma foto chida como fondo del panel Ghost.
SettingsVisual.GhostPanelPhoto = Instance.new("ImageLabel", GhostCard)
SettingsVisual.GhostPanelPhoto.Name = "PanelPhoto"
SettingsVisual.GhostPanelPhoto.Size = UDim2.new(1, 0, 1, 0)
SettingsVisual.GhostPanelPhoto.Position = UDim2.new(0, 0, 0, 0)
SettingsVisual.GhostPanelPhoto.BackgroundTransparency = 1
SettingsVisual.GhostPanelPhoto.Image = "rbxassetid://105275560374583"
SettingsVisual.GhostPanelPhoto.ImageTransparency = 0.68
SettingsVisual.GhostPanelPhoto.ScaleType = Enum.ScaleType.Crop
SettingsVisual.GhostPanelPhoto.ZIndex = 1
Instance.new("UICorner", SettingsVisual.GhostPanelPhoto).CornerRadius = UDim.new(0, 14)
SettingsVisual.AddSnowEffect(GhostCard, 8, 2)

local GhostLabel = Instance.new("TextLabel", GhostCard)
GhostLabel.Size = UDim2.new(0, 60, 0, 28)
GhostLabel.Position = UDim2.new(0, 10, 0, 6)
GhostLabel.BackgroundTransparency = 1
GhostLabel.Text = "Ghost"
GhostLabel.TextColor3 = Color3.fromRGB(240, 240, 255)
GhostLabel.TextSize = 12
GhostLabel.Font = Enum.Font.GothamBold
GhostLabel.TextXAlignment = Enum.TextXAlignment.Left
GhostLabel.ZIndex = 3

local IOSSwitchBg = Instance.new("Frame", GhostCard)
IOSSwitchBg.Size = UDim2.new(0, 36, 0, 20)
IOSSwitchBg.Position = UDim2.new(1, -44, 0, 10)
IOSSwitchBg.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
IOSSwitchBg.BorderSizePixel = 0
IOSSwitchBg.ZIndex = 3
Instance.new("UICorner", IOSSwitchBg).CornerRadius = UDim.new(1, 0)

local IOSSwitchThumb = Instance.new("Frame", IOSSwitchBg)
IOSSwitchThumb.Size = UDim2.new(0, 16, 0, 16)
IOSSwitchThumb.Position = UDim2.new(0, 2, 0.5, -8)
IOSSwitchThumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
IOSSwitchThumb.BorderSizePixel = 0
IOSSwitchThumb.ZIndex = 4
Instance.new("UICorner", IOSSwitchThumb).CornerRadius = UDim.new(1, 0)

local IOSSwitchBtn = Instance.new("TextButton", IOSSwitchBg)
IOSSwitchBtn.Size = UDim2.new(1, 0, 1, 0)
IOSSwitchBtn.BackgroundTransparency = 1
IOSSwitchBtn.Text = ""
IOSSwitchBtn.ZIndex = 5

local keyLabelGhost = Instance.new("TextButton", GhostCard)
keyLabelGhost.Size = UDim2.new(1, -16, 0, 22)
keyLabelGhost.Position = UDim2.new(0, 8, 0, 42)
keyLabelGhost.BackgroundTransparency = 1
keyLabelGhost.Text = "Key: " .. SettingsVisual.GhostKey.Name
keyLabelGhost.TextColor3 = COLORS.Muted
keyLabelGhost.AutoButtonColor = false
keyLabelGhost.TextSize = 11
keyLabelGhost.Font = Enum.Font.Gotham
keyLabelGhost.TextXAlignment = Enum.TextXAlignment.Center
keyLabelGhost.ZIndex = 3
SettingsVisual.GhostKeyLabel = keyLabelGhost
keyLabelGhost.MouseButton1Click:Connect(function()
	SettingsVisual.SelectingGhostKey = true
	SettingsVisual.SelectingTouchPanelKey = false
	keyLabelGhost.Text = "Key: ..."
end)

-- Casilla pequeña para buscar automáticamente borde/salida de una pared
-- cuando el usuario encienda Ghost. No depende de Snap.
SettingsVisual.GhostEdgeAssistEnabled = false
SettingsVisual.GhostEdgeAssistGeneration = 0

do
    -- Conservar tamaño original (130x75) y no cubrir el switch de Ghost.
    keyLabelGhost.Size = UDim2.fromOffset(58, 22)
    keyLabelGhost.TextXAlignment = Enum.TextXAlignment.Left

    local autoLabel = Instance.new("TextLabel", GhostCard)
    autoLabel.Name = "GhostEdgeAssistLabel"
    autoLabel.Size = UDim2.fromOffset(31, 20)
    autoLabel.Position = UDim2.fromOffset(69, 44)
    autoLabel.BackgroundTransparency = 1
    autoLabel.Text = "EDGE"
    autoLabel.TextSize = 9
    autoLabel.Font = Enum.Font.GothamBold
    autoLabel.TextColor3 = Color3.fromRGB(195, 174, 242)
    autoLabel.ZIndex = 7

    local autoCheck = Instance.new("TextButton", GhostCard)
    autoCheck.Name = "GhostEdgeAssistCheck"
    autoCheck.Size = UDim2.fromOffset(21, 21)
    autoCheck.Position = UDim2.new(1, -27, 1, -28)
    autoCheck.BorderSizePixel = 0
    autoCheck.BackgroundColor3 = Color3.fromRGB(31, 23, 49)
    autoCheck.BackgroundTransparency = 0.20
    autoCheck.Text = ""
    autoCheck.TextSize = 14
    autoCheck.Font = Enum.Font.GothamBlack
    autoCheck.TextColor3 = Color3.fromRGB(248, 239, 255)
    autoCheck.ZIndex = 8
    Instance.new("UICorner", autoCheck).CornerRadius = UDim.new(0, 5)
    local outline = Instance.new("UIStroke", autoCheck)
    outline.Color = Color3.fromRGB(155, 100, 223)
    outline.Thickness = 1
    outline.Transparency = 0.20

    local function refresh()
        local on = SettingsVisual.GhostEdgeAssistEnabled == true
        autoCheck.Text = on and "✓" or ""
        autoCheck.BackgroundColor3 = on
            and Color3.fromRGB(136, 63, 229)
            or Color3.fromRGB(31, 23, 49)
        autoLabel.TextColor3 = on
            and Color3.fromRGB(255, 225, 255)
            or Color3.fromRGB(195, 174, 242)
    end
    autoCheck.Activated:Connect(function()
        SettingsVisual.GhostEdgeAssistEnabled = not SettingsVisual.GhostEdgeAssistEnabled
        SettingsVisual.GhostEdgeAssistGeneration += 1
        refresh()
        -- También permite buscar al encender la casilla si Ghost ya estaba ON.
        if SettingsVisual.GhostEdgeAssistEnabled
            and SettingsVisual.GetGhostState and SettingsVisual.GetGhostState()
            and SettingsVisual.TriggerGhostEdgeAssist then
            task.defer(SettingsVisual.TriggerGhostEdgeAssist)
        end
    end)
    refresh()
end

local ghostActive = false

-- Ghost 360: movimiento propio con un poco mas de velocidad.
-- Usa el joystick/teclas normales aunque el HumanoidRootPart este anclado.
-- Al moverte hacia adelante, sigue tambien la inclinacion de la camara,
-- asi puedes bajar/subir para entrar en huecos, tuneles o agujeros.
SettingsVisual.GhostMoveSpeed = 24
SettingsVisual.GhostCollisionState = {}
SettingsVisual.GhostControls = nil
SettingsVisual.GhostWasAnchored = false

SettingsVisual.SetGhostState = function(state)
	state = state == true
	if state == ghostActive then return end
	if not state then
		-- Invalida cualquier escaneo diferido al apagar Ghost.
		SettingsVisual.GhostEdgeAssistGeneration += 1
	end
	ghostActive = state

	TweenService:Create(IOSSwitchBg, TweenInfo.new(0.2), {
		BackgroundColor3 = ghostActive and Color3.fromRGB(52, 199, 89) or Color3.fromRGB(50, 50, 60)
	}):Play()
	TweenService:Create(IOSSwitchThumb, TweenInfo.new(0.2), {
		Position = ghostActive and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
	}):Play()

	local char = Player.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")

	if ghostActive then
		if root then
			SettingsVisual.GhostWasAnchored = root.Anchored
			root.Anchored = true
		end

		-- Leemos directamente el vector del control de Roblox.
		-- Esto mantiene funcionando el joystick movil aun con el root anclado.
		if not SettingsVisual.GhostControls then
			pcall(function()
				SettingsVisual.GhostControls = require(
					Player:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule")
				):GetControls()
			end)
		end

		if char then
			for _, part in ipairs(char:GetDescendants()) do
				if part:IsA("BasePart") then
					if SettingsVisual.GhostCollisionState[part] == nil then
						SettingsVisual.GhostCollisionState[part] = part.CanCollide
					end
					part.CanCollide = false
				end
			end
		end
	else
		if root then
			root.Anchored = SettingsVisual.GhostWasAnchored == true
		end

		for part, oldCanCollide in pairs(SettingsVisual.GhostCollisionState) do
			if part and part.Parent then
				pcall(function() part.CanCollide = oldCanCollide end)
			end
		end
		SettingsVisual.GhostCollisionState = {}
	end

	-- La casilla EDGE solo actúa al activar Ghost. No altera el toggle normal.
	if state and SettingsVisual.GhostEdgeAssistEnabled
		and SettingsVisual.TriggerGhostEdgeAssist then
		task.defer(SettingsVisual.TriggerGhostEdgeAssist)
	end
end

SettingsVisual.ToggleGhost = function()
	SettingsVisual.SetGhostState(not ghostActive)
end

SettingsVisual.GetGhostState = function()
	return ghostActive
end

--========================================================--
-- GHOST EDGE: 1 TELETRANSPORTE AL ENCENDER GHOST + CASILLA EDGE
-- Prioridad: buscar el borde lateral mas cercano de la pared.
-- Si la pared continua, encontrar su coronacion y quedar ENCIMA.
-- NUNCA atraviesa la pared al buscar la salida: se queda del mismo lado.
-- No toca Snap, la camara ni el motor de movimiento Ghost.
--========================================================--
do
    -- Solo se usan raycasts de colisiones reales; el avatar se excluye.
    local function findWall(root, character, castParams)
        local origin = root.Position + Vector3.new(0, 0.8, 0)
        local camera = workspace.CurrentCamera
        local desired = camera and camera.CFrame.LookVector or root.CFrame.LookVector
        local forward = Vector3.new(desired.X, 0, desired.Z)
        if forward.Magnitude <= 0.001 then
            local rv = root.CFrame.LookVector
            forward = Vector3.new(rv.X, 0, rv.Z)
        end
        if forward.Magnitude <= 0.001 then forward = Vector3.new(0, 0, -1) end
        forward = forward.Unit

        -- Dar prioridad a la pared delante de la camara, pero detectar
        -- tambien pared a los costados o detras si es la mas cercana.
        local best, bestScore
        for i = 0, 15 do
            local angle = (i / 16) * math.pi * 2
            local direction = CFrame.fromAxisAngle(Vector3.yAxis, angle):VectorToWorldSpace(forward)
            local result = workspace:Raycast(origin, direction * 14, castParams)
            if result and result.Instance and result.Instance.CanCollide
                and math.abs(result.Normal.Y) < 0.38 then
                local distance = (result.Position - origin).Magnitude
                local score = distance + (1 - direction:Dot(forward)) * 2.25
                if not bestScore or score < bestScore then
                    bestScore = score
                    best = result
                end
            end
        end
        return best
    end

    local function sameSideTarget(origin, nearWall, castParams, direction, distance)
        -- Se desplaza PARALELO al muro. Nunca cruza hacia el lado opuesto.
        local candidate = origin + direction * distance
        local normal = Vector3.new(nearWall.Normal.X, 0, nearWall.Normal.Z)
        if normal.Magnitude < 0.01 then return nil end
        normal = normal.Unit
        local toward = -normal
        local wallDist = math.max(3.0, (nearWall.Position - origin).Magnitude + 1.8)

        -- Si aun choca el rayo contra esa fachada, no estamos al borde.
        for _, up in ipairs({-1.25, 0.65, 2.0}) do
            if workspace:Raycast(candidate + Vector3.new(0, up, 0), toward * wallDist, castParams) then
                return nil
            end
        end
        -- No pisar un hueco sin suelo ni subir/bajar bruscamente a otra planta.
        local floor = workspace:Raycast(candidate + Vector3.new(0, 3, 0),
            Vector3.new(0, -11, 0), castParams)
        if not floor or floor.Normal.Y < 0.55 then return nil end
        local floorDelta = floor.Position.Y - (origin.Y - 2.8)
        if math.abs(floorDelta) > 4.25 then return nil end
        local newPos = Vector3.new(candidate.X, floor.Position.Y + 2.9, candidate.Z)

        -- Comprobar espacio libre para el cuerpo completo (sin colisionar).
        local check = OverlapParams.new()
        check.FilterType = Enum.RaycastFilterType.Exclude
        check.FilterDescendantsInstances = {Player.Character}
        check.MaxParts = 18
        check.RespectCanCollide = true
        for _, part in ipairs(workspace:GetPartBoundsInBox(
            CFrame.new(newPos), Vector3.new(3.2, 4.5, 3.2), check)) do
            if part.CanCollide and part ~= floor.Instance then
                return nil
            end
        end
        return newPos
    end

    local function aboveWallTarget(origin, nearWall, castParams)
        local wallNormal = Vector3.new(nearWall.Normal.X, 0, nearWall.Normal.Z)
        if wallNormal.Magnitude < 0.01 then return nil end
        wallNormal = wallNormal.Unit
        local toward = -wallNormal
        local wallDist = math.max(3, (nearWall.Position - origin).Magnitude + 2.5)
        -- Hasta 90 studs para muros altos; no mover si no hay parte alta libre.
        for height = 5, 90, 2.5 do
            local point = origin + Vector3.new(0, height, 0)
            -- Los pies tienen que estar por encima del borde (root - 2.7).
            local footClear = workspace:Raycast(point - Vector3.new(0, 2.7, 0),
                toward * wallDist, castParams)
            local torsoClear = workspace:Raycast(point + Vector3.new(0, 0.7, 0),
                toward * wallDist, castParams)
            if not footClear and not torsoClear then
                local check = OverlapParams.new()
                check.FilterType = Enum.RaycastFilterType.Exclude
                check.FilterDescendantsInstances = {Player.Character}
                check.MaxParts = 18
                check.RespectCanCollide = true
                if #workspace:GetPartBoundsInBox(CFrame.new(point),
                    Vector3.new(3.2, 4.5, 3.2), check) == 0 then
                    return point
                end
            end
        end
        return nil
    end

    SettingsVisual.TriggerGhostEdgeAssist = function()
        if not SettingsVisual.GhostEdgeAssistEnabled
            or not SettingsVisual.GetGhostState
            or not SettingsVisual.GetGhostState() then return end
        local generation = SettingsVisual.GhostEdgeAssistGeneration + 1
        SettingsVisual.GhostEdgeAssistGeneration = generation
        local character = Player.Character
        local root = character and character:FindFirstChild("HumanoidRootPart")
        local hum = character and character:FindFirstChildOfClass("Humanoid")
        if not root or not hum or hum.SeatPart then return end

        -- No iniciar si el Snap normal esta gestionando un TP activo.
        if isSnappedDown then return end

        local params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Exclude
        params.FilterDescendantsInstances = {character}
        params.IgnoreWater = true
        params.RespectCanCollide = true

        local wall = findWall(root, character, params)
        if not wall then return end
        local origin = root.Position
        local normal = Vector3.new(wall.Normal.X, 0, wall.Normal.Z)
        if normal.Magnitude < 0.01 then return end
        normal = normal.Unit
        local tangent = Vector3.new(-normal.Z, 0, normal.X)
        local chosen, method

        -- Buscar primero extremo lateral, en ambas direcciones.
        -- Distancias crecientes = primera salida util, no lejania maxima.
        for distance = 3.5, 38, 2.5 do
            for _, sign in ipairs({1, -1}) do
                local candidate = sameSideTarget(origin, wall, params, tangent * sign, distance)
                if candidate then
                    chosen = candidate
                    method = "lateral"
                    break
                end
            end
            if chosen then break end
        end
        if not chosen then
            chosen = aboveWallTarget(origin, wall, params)
            method = "arriba"
        end
        if not chosen or generation ~= SettingsVisual.GhostEdgeAssistGeneration
            or not SettingsVisual.GhostEdgeAssistEnabled
            or not SettingsVisual.GetGhostState()
            or Player.Character ~= character or not root.Parent then return end

        -- Ghost ya esta ON y mantiene el HRP anclado: se mueve el avatar,
        -- sin mover ni desactivar la camara ni atravesar la pared objetivo.
        local rotation = root.CFrame.Rotation
        root.CFrame = CFrame.new(chosen) * rotation
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
        SettingsVisual.GhostEdgeAssistLastMethod = method
    end
end

IOSSwitchBtn.MouseButton1Click:Connect(SettingsVisual.ToggleGhost)

-- La tecla Q del panel ahora tambien funciona.
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if SettingsVisual.SelectingTouchPanelKey then return end
	if SettingsVisual.SelectingGhostKey and input.UserInputType == Enum.UserInputType.Keyboard then
		if input.KeyCode ~= Enum.KeyCode.Unknown then
			SettingsVisual.GhostKey = input.KeyCode
			SettingsVisual.SelectingGhostKey = false
			if SettingsVisual.GhostKeyLabel then
				SettingsVisual.GhostKeyLabel.Text = "Key: " .. input.KeyCode.Name
			end
		end
		return
	end
	if not gameProcessed
		and GhostFloatingSwitchGui.Enabled
		and input.KeyCode == SettingsVisual.GhostKey then
		SettingsVisual.ToggleGhost()
	end
end)

-- Movimiento Ghost independiente: atraviesa paredes y permite movimiento
-- 3D segun la camara para entrar en huecos/agujeros.
SettingsVisual.GhostMoveConnection = RunService.RenderStepped:Connect(function(dt)
	if not ghostActive then return end

	local char = Player.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if not char or not root or not hum then return end

	root.Anchored = true

	-- Noclip completo del personaje mientras Ghost este activo.
	for _, part in ipairs(char:GetDescendants()) do
		if part:IsA("BasePart") then
			if SettingsVisual.GhostCollisionState[part] == nil then
				SettingsVisual.GhostCollisionState[part] = part.CanCollide
			end
			part.CanCollide = false
		end
	end

	local camera = workspace.CurrentCamera
	if not camera then return end

	local movement = Vector3.zero
	local amount = 0

	-- Primera opcion: leer el control bruto. Es la mas estable en movil.
	if SettingsVisual.GhostControls then
		local ok, rawMove = pcall(function()
			return SettingsVisual.GhostControls:GetMoveVector()
		end)
		if ok and typeof(rawMove) == "Vector3" then
			amount = math.clamp(Vector2.new(rawMove.X, rawMove.Z).Magnitude, 0, 1)
			if amount > 0.01 then
				-- Forward sigue la inclinacion de la camara: si miras hacia abajo
				-- y avanzas, Ghost baja y puede entrar en agujeros/tuneles.
				movement = camera.CFrame.RightVector * rawMove.X
					+ camera.CFrame.LookVector * (-rawMove.Z)
			end
		end
	end

	-- Respaldo por si un juego reemplazo PlayerModule.
	if movement.Magnitude <= 0.01 and hum.MoveDirection.Magnitude > 0.01 then
		local flatForward = Vector3.new(camera.CFrame.LookVector.X, 0, camera.CFrame.LookVector.Z)
		local forwardAmount = 0
		if flatForward.Magnitude > 0.001 then
			forwardAmount = hum.MoveDirection.Unit:Dot(flatForward.Unit)
		end
		movement = Vector3.new(
			hum.MoveDirection.X,
			camera.CFrame.LookVector.Y * forwardAmount,
			hum.MoveDirection.Z
		)
		amount = math.clamp(hum.MoveDirection.Magnitude, 0, 1)
	end

	if movement.Magnitude > 0.01 then
		root.CFrame = root.CFrame
			+ movement.Unit * SettingsVisual.GhostMoveSpeed * math.max(amount, 0.15) * dt
	end
end)

-- Iconos vectoriales premium para cada tab (funcionan tambien en movil
-- aunque el cliente no soporte una fuente de emojis o assets externos).
SettingsVisual.MakeSidebarVectorIcon = function(button, tabName)
    local icon = Instance.new("Frame", button)
    icon.Name = "TabIcon"
    icon.Size = UDim2.fromOffset(19, 19)
    icon.Position = UDim2.new(0, 10, 0.5, -9)
    icon.BackgroundTransparency = 1
    icon.ZIndex = 8
    local ink = Color3.fromRGB(178, 219, 255)
    local function shape(x, y, w, h, roundness, angle)
        local f = Instance.new("Frame", icon)
        f.Position = UDim2.fromOffset(x, y)
        f.Size = UDim2.fromOffset(w, h)
        f.BackgroundColor3 = ink
        f.BackgroundTransparency = 0.09
        f.BorderSizePixel = 0
        f.Rotation = angle or 0
        f.ZIndex = 9
        if roundness then
            Instance.new("UICorner", f).CornerRadius = UDim.new(1, 0)
        end
        return f
    end
    local function outline(x, y, w, h, thickness, ellipse)
        local f = Instance.new("Frame", icon)
        f.Position = UDim2.fromOffset(x, y)
        f.Size = UDim2.fromOffset(w, h)
        f.BackgroundTransparency = 1
        f.ZIndex = 9
        local round = Instance.new("UICorner", f)
        round.CornerRadius = UDim.new(ellipse and 1 or 0, ellipse and 0 or 4)
        local stroke = Instance.new("UIStroke", f)
        stroke.Color = ink
        stroke.Thickness = thickness or 1.5
        stroke.Transparency = 0.08
        return f
    end
    if tabName == "Player" then
        -- monito: cabeza, hombros, torso y piernas
        shape(7, 1, 6, 6, true)
        shape(4, 9, 12, 7, true)
        shape(5, 14, 4, 5, true)
        shape(11, 14, 4, 5, true)
    elseif tabName == "Vehicle" then
        outline(2, 6, 15, 9, 1.5, false)
        shape(5, 3, 9, 4, true)
        shape(4, 13, 4, 5, true)
        shape(12, 13, 4, 5, true)
    elseif tabName == "Silent Aim" then
        outline(2, 2, 15, 15, 1.5, true)
        outline(6, 6, 7, 7, 1.2, true)
        shape(9, 9, 2, 2, true)
    elseif tabName == "Soft Aim" then
        shape(9, 1, 2, 6, true)
        shape(9, 13, 2, 6, true)
        shape(1, 9, 6, 2, true)
        shape(13, 9, 6, 2, true)
        outline(7, 7, 6, 6, 1, true)
    elseif tabName == "ESP" then
        shape(2, 9, 9, 2, true, -27)
        shape(9, 5, 9, 2, true, 27)
        shape(2, 11, 9, 2, true, 27)
        shape(9, 14, 9, 2, true, -27)
        shape(8, 8, 5, 5, true)
    elseif tabName == "Misc" then
        for i=0,2 do
            shape(2, 3 + i*6, 16, 2, true)
        end
        shape(6, 1, 4, 6, true)
        shape(12, 7, 4, 6, true)
        shape(4, 13, 4, 6, true)
    elseif tabName == "Farm" then
        shape(9, 7, 2, 11, true)
        shape(3, 4, 8, 5, true, 35)
        shape(9, 4, 8, 5, true, -35)
        shape(4, 17, 12, 2, true)
    elseif tabName == "Buy" then
        outline(3, 6, 14, 12, 1.5, false)
        outline(7, 2, 6, 8, 1.4, true)
        shape(4, 9, 12, 2, true)
    elseif tabName == "Config" then
        -- engrane pequeño centrado, sin sprites externos.
        shape(8, 1, 4, 5, true)
        shape(8, 14, 4, 5, true)
        shape(1, 8, 5, 4, true)
        shape(14, 8, 5, 4, true)
        outline(5, 5, 10, 10, 1.7, true)
        shape(8, 8, 4, 4, true)
    end
    return icon
end

local TabObjects = {}
local CurrentTab = "Silent Aim"

local function SelectTab(name)
	if SettingsVisual.CloseBuyDropdown then SettingsVisual.CloseBuyDropdown() end
	CurrentTab = name

	for tabName, data in pairs(TabObjects) do
		local button = data.Button
		local accent = data.Accent
		local text = data.Text

		if tabName == name then
			TweenService:Create(button, TweenInfo.new(.22, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
				BackgroundColor3 = COLORS.Blue,
				BackgroundTransparency = 0.85
			}):Play()
			TweenService:Create(button, TweenInfo.new(.22), { Size = UDim2.new(1, 3, 0, 34) }):Play()
			TweenService:Create(accent, TweenInfo.new(.22), { BackgroundTransparency = 0 }):Play()
			TweenService:Create(text, TweenInfo.new(.22), { TextColor3 = COLORS.White }):Play()
		else
			TweenService:Create(button, TweenInfo.new(.22), {
				BackgroundColor3 = COLORS.Glass2,
				BackgroundTransparency = ALPHA.Buttons
			}):Play()
			TweenService:Create(button, TweenInfo.new(.22), { Size = UDim2.new(1, 0, 0, 32) }):Play()
			TweenService:Create(accent, TweenInfo.new(.22), { BackgroundTransparency = 1 }):Play()
			TweenService:Create(text, TweenInfo.new(.22), { TextColor3 = COLORS.Text }):Play()
		end
	end

	for tName, scroll in pairs(TabContainers) do
		scroll.Visible = (tName == name)
	end
end

for index, tab in ipairs(TABS) do
	local Button = Instance.new("TextButton")
	Button.Name = tab.Name:gsub("%s+", "")
	Button.Size = UDim2.new(1, 0, 0, 32)
	Button.BackgroundColor3 = COLORS.Glass2
	Button.BackgroundTransparency = ALPHA.Buttons
	Button.BorderSizePixel = 0
	Button.AutoButtonColor = false
	Button.Text = ""
	Button.LayoutOrder = index
	Button.ZIndex = 5
	Button.Parent = Sidebar

	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0, 16)
	Corner.Parent = Button

	local Stroke = Instance.new("UIStroke")
	Stroke.Color = COLORS.Blue
	Stroke.Transparency = 0.78
	Stroke.Thickness = 1
	Stroke.Parent = Button

	local Accent = Instance.new("Frame")
	Accent.Position = UDim2.new(0, 0, .5, -7)
	Accent.Size = UDim2.new(0, 3, 0, 14)
	Accent.BackgroundColor3 = COLORS.BlueBright
	Accent.BackgroundTransparency = tab.Name == CurrentTab and 0 or 1
	Accent.BorderSizePixel = 0
	Accent.ZIndex = 7
	Accent.Parent = Button

	local AccentCorner = Instance.new("UICorner")
	AccentCorner.CornerRadius = UDim.new(1, 0)
	AccentCorner.Parent = Accent

	local Text = Instance.new("TextLabel")
	Text.Position = UDim2.new(0, 36, 0, 0)
	Text.Size = UDim2.new(1, -40, 1, 0)
	Text.BackgroundTransparency = 1
	Text.Text = tab.Name
	Text.TextColor3 = tab.Name == CurrentTab and COLORS.White or COLORS.Text
	Text.TextSize = 12
	Text.Font = Enum.Font.Gotham
	Text.TextXAlignment = Enum.TextXAlignment.Left
	Text.ZIndex = 7
	Text.Parent = Button

	local icon = SettingsVisual.MakeSidebarVectorIcon(Button, tab.Name)
	TabObjects[tab.Name] = {Button = Button, Accent = Accent, Text = Text, Stroke = Stroke, Icon = icon}

	Button.MouseButton1Click:Connect(function()
		SelectTab(tab.Name)
	end)
end

SelectTab("Silent Aim")

--========================================================--
-- CHINO: VISIBILIDAD TACTIL SEGURA.
-- Corrección de arranque: NO crear CanvasGroup y NO reparentar
-- TouchCard / GhostCard. En algunos clientes eso detenía el script
-- antes de mostrar incluso el selector de modo y el panel.
-- Sólo alternamos Enabled del ScreenGui ya existente.
--========================================================--
do
    SettingsVisual.RefreshFloatingMenus = function(animated)
        -- PROTEGIDO: un problema de los controles extra no debe impedir
        -- que CHINOINFIERNO muestre el panel principal.
        pcall(function()
            local open = SettingsVisual.PanelIsOpen == true
            if not open and SettingsVisual.CloseBuyDropdown then SettingsVisual.CloseBuyDropdown() end
            if TouchPanelGui and TouchPanelGui.Parent then
                TouchPanelGui.Enabled = (not open) and TouchPanelEnabled == true
            end
            if GhostFloatingSwitchGui and GhostFloatingSwitchGui.Parent then
                GhostFloatingSwitchGui.Enabled = (not open)
                    and SettingsVisual.GhostPanelWanted == true
            end
        end)
    end
end

--========================================================--
--========================================================--
-- INTRO COSMICA ORIGINAL
-- Orbes + niebla + textos desvanecidos -> panel actual intacto.
-- Todo vive dentro de este task para no aumentar los locals principales.
--========================================================--
task.spawn(function()
	-- Durante la intro ocultamos SOLO la interfaz principal actual.
	-- No se toca ninguna opcion, estado, callback ni logica del HUB.
	Gui.Enabled = false
	Main.Visible = false
	Glow.Visible = false
	pcall(function() GameBlur.Size = 0 end)

	-- Limpieza por si se re-ejecuta el script.
	pcall(function()
		local oldBg = PlayerGui:FindFirstChild("ChinoNeonBackground") or CoreGui:FindFirstChild("ChinoNeonBackground")
		if oldBg then oldBg:Destroy() end
		local oldIntro = PlayerGui:FindFirstChild("ChinoIntro") or CoreGui:FindFirstChild("ChinoIntro")
		if oldIntro then oldIntro:Destroy() end
	end)

	-- Fondo cosmico del otro script.
	local backgroundGui = Instance.new("ScreenGui")
	backgroundGui.Name = "ChinoNeonBackground"
	backgroundGui.IgnoreGuiInset = true
	backgroundGui.ResetOnSpawn = false
	backgroundGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
	backgroundGui.DisplayOrder = 1
	-- FULLSCREEN: en iPhone la zona segura estaba recortando los dos lados.
	-- Cada propiedad se aplica de forma independiente, por compatibilidad.
	pcall(function() backgroundGui.ScreenInsets = Enum.ScreenInsets.None end)
	pcall(function() backgroundGui.ClipToDeviceSafeArea = false end)
	pcall(function()
		backgroundGui.SafeAreaCompatibility = Enum.SafeAreaCompatibility.FullscreenExtension
	end)
	backgroundGui.Parent = PlayerGui

	local background = Instance.new("Frame")
	background.Name = "Background"
	background.BorderSizePixel = 0
	background.BackgroundColor3 = Color3.fromRGB(3, 2, 14)
	background.ZIndex = 1
	background.ClipsDescendants = false
	background.AnchorPoint = Vector2.new(0.5, 0.5)
	background.Position = UDim2.fromScale(0.5, 0.5)
	background.Size = UDim2.new(4, 0, 4, 0)
	background.Parent = backgroundGui

	local ambient = Instance.new("Frame")
	ambient.Name = "Ambient"
	ambient.Size = UDim2.fromScale(1, 1)
	ambient.Position = UDim2.fromScale(0, 0)
	ambient.BackgroundColor3 = Color3.fromRGB(15, 6, 35)
	ambient.BackgroundTransparency = 0.35
	ambient.BorderSizePixel = 0
	ambient.ZIndex = 2
	ambient.Parent = background
	SettingsVisual.ThemeAmbient = ambient
	-- El fondo cosmico se reutiliza: en Gama Baja no tapa el juego.
	SettingsVisual.ThemeBackplate = background

	local blackCurtain = Instance.new("Frame")
	blackCurtain.Name = "BlackCurtain"
	blackCurtain.AnchorPoint = Vector2.new(0.5, 0.5)
	blackCurtain.Position = UDim2.fromScale(0.5, 0.5)
	blackCurtain.Size = UDim2.fromScale(1.5, 1.5)
	blackCurtain.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	blackCurtain.BackgroundTransparency = 0
	blackCurtain.BorderSizePixel = 0
	blackCurtain.ZIndex = 90
	blackCurtain.Parent = background

	local activePalette = SettingsVisual.ExecutionOrbPalette or {
		Color3.fromRGB(0, 110, 255),
		Color3.fromRGB(140, 25, 255),
		Color3.fromRGB(0, 220, 255),
		Color3.fromRGB(255, 45, 175),
		Color3.fromRGB(90, 15, 215),
		Color3.fromRGB(180, 30, 255)
	}
	SettingsVisual.ActiveOrbPalette = activePalette

	local orbColors = {
		Blue = activePalette[1],
		Purple = activePalette[2],
		Cyan = activePalette[3],
		Pink = activePalette[4],
		DeepPurple = activePalette[5],
		Magenta = activePalette[6]
	}

	local shapes = {}
	local introRandom = Random.new()

	local function createExpandingGlow(name, targetSize, position, color)
		local holder = Instance.new("Frame")
		holder.Name = name
		holder.AnchorPoint = Vector2.new(0.5, 0.5)
		holder.Position = position
		holder.Size = UDim2.fromOffset(20, 20)
		holder.BackgroundTransparency = 1
		holder.BorderSizePixel = 0
		holder.ZIndex = 3
		holder.Parent = background
		SettingsVisual.ThemeOrbHolders = SettingsVisual.ThemeOrbHolders or {}
		table.insert(SettingsVisual.ThemeOrbHolders, holder)

		local core = Instance.new("Frame")
		core.Name = "Core"
		core.AnchorPoint = Vector2.new(0.5, 0.5)
		core.Size = UDim2.fromScale(0.40, 0.40)
		core.Position = UDim2.fromScale(0.5, 0.5)
		core.BackgroundColor3 = color
		core.BackgroundTransparency = 0.65
		core.BorderSizePixel = 0
		core.ZIndex = 4
		core.Parent = holder
		Instance.new("UICorner", core).CornerRadius = UDim.new(1, 0)

		for i = 1, 12 do
			local halo = Instance.new("Frame")
			halo.Name = "Halo_" .. i
			halo.AnchorPoint = Vector2.new(0.5, 0.5)
			halo.Size = UDim2.fromScale(0.40 + (i * 0.16), 0.40 + (i * 0.16))
			halo.Position = UDim2.fromScale(0.5, 0.5)
			halo.BackgroundColor3 = color
			halo.BackgroundTransparency = 0.82 + (i * 0.014)
			halo.BorderSizePixel = 0
			halo.ZIndex = 3
			halo.Parent = holder
			Instance.new("UICorner", halo).CornerRadius = UDim.new(1, 0)
		end

		table.insert(shapes, {
			Object = holder,
			TargetSize = targetSize,
			Original = position,
			Phase = introRandom:NextNumber(0, math.pi * 2),
			Speed = introRandom:NextNumber(0.06, 0.12),
			Distance = introRandom:NextNumber(0.06, 0.14)
		})
	end

	createExpandingGlow("VioletGlow", UDim2.fromOffset(680, 420), UDim2.fromScale(0.30, 0.68), orbColors.Purple)
	createExpandingGlow("ElectricBlueGlow", UDim2.fromOffset(600, 380), UDim2.fromScale(0.70, 0.35), orbColors.Blue)
	createExpandingGlow("CyanIceGlow", UDim2.fromOffset(540, 340), UDim2.fromScale(0.60, 0.42), orbColors.Cyan)
	createExpandingGlow("DeepPurpleGlow", UDim2.fromOffset(620, 390), UDim2.fromScale(0.72, 0.78), orbColors.DeepPurple)
	createExpandingGlow("ExtraPurpleGlow", UDim2.fromOffset(640, 390), UDim2.fromScale(0.35, 0.82), orbColors.Purple)
	createExpandingGlow("NeonPinkGlow", UDim2.fromOffset(580, 360), UDim2.fromScale(0.40, 0.25), orbColors.Pink)
	createExpandingGlow("StarMagenta_Outer", UDim2.fromOffset(620, 370), UDim2.fromScale(0.20, 0.34), orbColors.Magenta)
	createExpandingGlow("CobaltBlue_Outer", UDim2.fromOffset(580, 350), UDim2.fromScale(0.50, 0.18), orbColors.Blue)
	createExpandingGlow("TopCyan_Outer", UDim2.fromOffset(540, 360), UDim2.fromScale(0.80, 0.22), orbColors.Cyan)

	local frostCover = Instance.new("Frame")
	frostCover.Name = "UltraFrostCover"
	frostCover.AnchorPoint = Vector2.new(0.5, 0.5)
	frostCover.Size = UDim2.fromScale(1.1, 1.1)
	frostCover.Position = UDim2.fromScale(0.5, 0.5)
	frostCover.BackgroundColor3 = Color3.fromRGB(12, 18, 48)
	frostCover.BackgroundTransparency = 0.58
	frostCover.BorderSizePixel = 0
	frostCover.ZIndex = 20
	frostCover.Parent = background
	SettingsVisual.ThemeFrost = frostCover

	local frostGrad = Instance.new("UIGradient")
	frostGrad.Rotation = 45
	frostGrad.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.45),
		NumberSequenceKeypoint.new(0.5, 0.60),
		NumberSequenceKeypoint.new(1, 0.50)
	})
	frostGrad.Parent = frostCover

	local fog1 = Instance.new("ImageLabel")
	fog1.Name = "HeavyFog1"
	fog1.Size = UDim2.fromScale(1, 1)
	fog1.BackgroundTransparency = 1
	fog1.Image = "rbxassetid://9968344589"
	fog1.ImageColor3 = Color3.fromRGB(50, 100, 230)
	fog1.ImageTransparency = 0.60
	fog1.ScaleType = Enum.ScaleType.Tile
	fog1.TileSize = UDim2.new(0, 480, 0, 480)
	fog1.ZIndex = 21
	fog1.Parent = frostCover

	local fog2 = Instance.new("ImageLabel")
	fog2.Name = "HeavyFog2"
	fog2.Size = UDim2.fromScale(1, 1)
	fog2.BackgroundTransparency = 1
	fog2.Image = "rbxassetid://9968344589"
	fog2.ImageColor3 = Color3.fromRGB(120, 30, 210)
	fog2.ImageTransparency = 0.68
	fog2.Rotation = 180
	fog2.ScaleType = Enum.ScaleType.Tile
	fog2.TileSize = UDim2.new(0, 360, 0, 360)
	fog2.ZIndex = 22
	fog2.Parent = frostCover
	SettingsVisual.ThemeFog1 = fog1
	SettingsVisual.ThemeFog2 = fog2

	-- Movimiento lento de los orbes. Se quedan de fondo despues de la intro.
	task.spawn(function()
		local elapsed = 0
		local visualTimer = 0
		while backgroundGui and backgroundGui.Parent do
			local dt = RunService.RenderStepped:Wait()
			elapsed += dt
			visualTimer += dt
			local lowPerformance =
				SettingsVisual.IsLowPerformance
				and SettingsVisual.IsLowPerformance()

			local visualInterval =
                lowPerformance and 0.20 or
                ((SettingsVisual.HighFluidityCurrentFPS or 60) < 42 and (1 / 24) or (1 / 30))

			if visualTimer >= visualInterval then
				visualTimer = 0

				for index, data in ipairs(shapes) do
					if data.Object and data.Object.Parent then
						if lowPerformance then
							-- Gama Baja: ningún orbe se mueve ni se renderiza.
							continue
						end

						local x =
							math.sin(
								elapsed * data.Speed + data.Phase
							) * data.Distance

						local y =
							math.cos(
								elapsed * data.Speed * 0.8 + data.Phase
							) * data.Distance * 0.65

						data.Object.Position =
							UDim2.new(
								data.Original.X.Scale + x,
								0,
								data.Original.Y.Scale + y,
								0
							)
					end
				end
			end
		end
	end)

	-- Textos exactos del inicio que me pasaste.
	local introGui = Instance.new("ScreenGui")
	introGui.Name = "ChinoIntro"
	introGui.IgnoreGuiInset = true
	introGui.ResetOnSpawn = false
	introGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	introGui.DisplayOrder = 100
	introGui.Parent = PlayerGui

	local container = Instance.new("Frame")
	container.Size = UDim2.fromScale(1, 1)
	container.BackgroundTransparency = 1
	container.ZIndex = 100
	container.Parent = introGui

	local hello = Instance.new("TextLabel")
	hello.AnchorPoint = Vector2.new(0.5, 0.5)
	hello.Position = UDim2.fromScale(0.5, 0.5)
	hello.Size = UDim2.new(0.6, 0, 0, 40)
	hello.BackgroundTransparency = 1
	hello.Text = "Hello"
	hello.TextColor3 = Color3.fromRGB(255, 255, 255)
	hello.TextTransparency = 1
	hello.TextSize = 26
	hello.Font = Enum.Font.Gotham
	hello.ZIndex = 101
	hello.Parent = container

	local hubTitle = Instance.new("TextLabel")
	hubTitle.AnchorPoint = Vector2.new(0.5, 0.5)
	hubTitle.Position = UDim2.fromScale(0.5, 0.5)
	hubTitle.Size = UDim2.new(0.8, 0, 0, 40)
	hubTitle.BackgroundTransparency = 1
	hubTitle.Text = "CHINOINFIERNOHUBv3"
	hubTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
	hubTitle.TextTransparency = 1
	hubTitle.TextSize = 19
	hubTitle.Font = Enum.Font.Gotham
	hubTitle.ZIndex = 101
	hubTitle.Parent = container

	local function fadeIn(label)
		local tw = TweenService:Create(label, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0})
		tw:Play()
		tw.Completed:Wait()
	end

	local function fadeOut(label)
		local tw = TweenService:Create(label, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {TextTransparency = 1})
		tw:Play()
		tw.Completed:Wait()
	end

	-- Secuencia del script de referencia.
	task.wait(0.5)
	TweenService:Create(
		blackCurtain,
		TweenInfo.new(1.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		{BackgroundTransparency = 1}
	):Play()

	for _, data in ipairs(shapes) do
		TweenService:Create(
			data.Object,
			TweenInfo.new(introRandom:NextNumber(2.4, 3.2), Enum.EasingStyle.Cubic, Enum.EasingDirection.Out),
			{Size = data.TargetSize}
		):Play()
	end

	task.wait(0.8)
	if SettingsVisual.PlayStartupSound then SettingsVisual.PlayStartupSound() end
	fadeIn(hello)
	task.wait(0.9)
	fadeOut(hello)
	task.wait(0.2)
	fadeIn(hubTitle)
	task.wait(1.5)
	fadeOut(hubTitle)

	-- Selector de rendimiento: reemplaza por completo el selector de idioma.
	-- Alta conserva exactamente todos los visuales actuales.
	-- Baja únicamente reduce carga cosmética.
	local performanceConfirmed = false
	local performanceLocked = false
	local selectedPerformance = "High"
	local performanceButtons = {}

	local performanceCard = Instance.new("Frame")
	performanceCard.Name = "PerformanceSelector"
	performanceCard.AnchorPoint = Vector2.new(0.5, 0.5)
	performanceCard.Position = UDim2.fromScale(0.5, 0.5)
	performanceCard.Size = UDim2.fromOffset(202, 142)
	performanceCard.BackgroundColor3 = Color3.fromRGB(8, 12, 24)
	performanceCard.BackgroundTransparency = 0.86
	performanceCard.BorderSizePixel = 0
	performanceCard.ZIndex = 110
	performanceCard.Parent = container
	Instance.new("UICorner", performanceCard).CornerRadius = UDim.new(0, 12)

	local performanceTitle = Instance.new("TextLabel", performanceCard)
	performanceTitle.Size = UDim2.new(1, -20, 0, 22)
	performanceTitle.Position = UDim2.new(0, 10, 0, 7)
	performanceTitle.BackgroundTransparency = 1
	performanceTitle.Text = "Gama del dispositivo"
	performanceTitle.TextColor3 = Color3.fromRGB(240, 245, 255)
	performanceTitle.TextTransparency = 0.06
	performanceTitle.TextSize = 11
	performanceTitle.Font = Enum.Font.GothamMedium
	performanceTitle.ZIndex = 111

	local performanceHint = Instance.new("TextLabel", performanceCard)
	performanceHint.Size = UDim2.new(1, -20, 0, 16)
	performanceHint.Position = UDim2.new(0, 10, 0, 29)
	performanceHint.BackgroundTransparency = 1
	performanceHint.Text = "Gama Alta • visuales completos"
	performanceHint.TextColor3 = Color3.fromRGB(170, 190, 218)
	performanceHint.TextTransparency = 0.10
	performanceHint.TextSize = 8
	performanceHint.Font = Enum.Font.Gotham
	performanceHint.ZIndex = 111

	local optionsHolder = Instance.new("Frame", performanceCard)
	optionsHolder.Position = UDim2.new(0, 9, 0, 52)
	optionsHolder.Size = UDim2.new(1, -18, 0, 31)
	optionsHolder.BackgroundTransparency = 1
	optionsHolder.ZIndex = 111

	local optionsLayout = Instance.new("UIListLayout", optionsHolder)
	optionsLayout.FillDirection = Enum.FillDirection.Horizontal
	optionsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	optionsLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	optionsLayout.Padding = UDim.new(0, 7)

	local function refreshPerformanceSelection()
		for mode, button in pairs(performanceButtons) do
			local selected = mode == selectedPerformance
			button.BackgroundTransparency = selected and 0.62 or 0.91
			button.TextTransparency = selected and 0 or 0.10
			button.TextColor3 =
				selected
				and Color3.fromRGB(255, 255, 255)
				or Color3.fromRGB(190, 205, 225)
		end

		if selectedPerformance == "Low" then
			performanceHint.Text =
				"Gama Baja • menos animaciones / sin láser"
		else
			performanceHint.Text =
				"Gama Alta • visuales completos"
		end
	end

	local function createPerformanceButton(mode, label)
		local button = Instance.new("TextButton", optionsHolder)
		button.Name = "Performance_" .. mode
		button.Size = UDim2.fromOffset(84, 29)
		button.BackgroundColor3 = Color3.fromRGB(32, 45, 68)
		button.BackgroundTransparency = 0.91
		button.BorderSizePixel = 0
		button.Text = label
		button.TextColor3 = Color3.fromRGB(190, 205, 225)
		button.TextTransparency = 0.10
		button.TextSize = 9
		button.Font = Enum.Font.GothamMedium
		button.AutoButtonColor = false
		button.ZIndex = 112
		Instance.new("UICorner", button).CornerRadius = UDim.new(0, 7)

		performanceButtons[mode] = button

		button.Activated:Connect(function()
			if performanceLocked then return end
			selectedPerformance = mode
			refreshPerformanceSelection()
		end)
	end

	createPerformanceButton("High", "Gama Alta")
	createPerformanceButton("Low", "Gama Baja")
	refreshPerformanceSelection()

	local performanceOK = Instance.new("TextButton", performanceCard)
	performanceOK.Name = "PerformanceOK"
	performanceOK.AnchorPoint = Vector2.new(0.5, 1)
	performanceOK.Position = UDim2.new(0.5, 0, 1, -8)
	performanceOK.Size = UDim2.fromOffset(62, 23)
	performanceOK.BackgroundColor3 = Color3.fromRGB(36, 55, 82)
	performanceOK.BackgroundTransparency = 0.82
	performanceOK.BorderSizePixel = 0
	performanceOK.Text = "OK"
	performanceOK.TextColor3 = Color3.fromRGB(240, 246, 255)
	performanceOK.TextTransparency = 0.02
	performanceOK.TextSize = 10
	performanceOK.Font = Enum.Font.GothamMedium
	performanceOK.AutoButtonColor = false
	performanceOK.ZIndex = 113
	Instance.new("UICorner", performanceOK).CornerRadius = UDim.new(1, 0)

	local function confirmPerformance()
		if performanceLocked then return end
		performanceLocked = true

		-- El selector de idioma ya no existe: dejamos Español fijo.
		pcall(function()
			SettingsVisual.ApplyLanguage("es")
		end)

		if SettingsVisual.ApplyPerformanceMode then
			SettingsVisual.ApplyPerformanceMode(selectedPerformance)
		end

		performanceHint.Text =
			selectedPerformance == "Low"
			and "OK • Gama Baja"
			or "OK • Gama Alta"

		local low =
			selectedPerformance == "Low"

		if low then
			-- En Baja no gastamos varios Tweens solo para cerrar este selector.
			performanceCard.Visible = false
			performanceConfirmed = true
			return
		end

		-- Alta conserva el fade bonito que tenía el selector anterior.
		TweenService:Create(
			performanceOK,
			TweenInfo.new(0.14),
			{BackgroundTransparency = 0.64}
		):Play()

		task.spawn(function()
			local fadePerformance =
				TweenInfo.new(
					0.30,
					Enum.EasingStyle.Sine,
					Enum.EasingDirection.InOut
				)

			for _, obj in ipairs(performanceCard:GetDescendants()) do
				if obj:IsA("TextLabel") or obj:IsA("TextButton") then
					TweenService:Create(
						obj,
						fadePerformance,
						{
							TextTransparency = 1,
							BackgroundTransparency = 1
						}
					):Play()
				end
			end

			TweenService:Create(
				performanceCard,
				fadePerformance,
				{BackgroundTransparency = 1}
			):Play()

			task.wait(0.32)
			performanceConfirmed = true
		end)
	end

	performanceOK.MouseButton1Click:Connect(confirmPerformance)
	performanceOK.Activated:Connect(confirmPerformance)

	while not performanceConfirmed do
		task.wait(0.03)
	end

	if performanceCard then
		performanceCard:Destroy()
	end

	-- MODO DE ENTRADA: mismo estilo minimalista del selector Gama Alta/Baja.
	-- Ambos botones conservan su secuencia de entrada; el selector sigue
	-- apareciendo despues de Gama y antes de que se muestre CHINO.
	do
		local modeGui = Instance.new("ScreenGui")
		local previous = PlayerGui:FindFirstChild("zhXUI")
		if previous then previous:Destroy() end
		modeGui.Name = "zhXUI"
		modeGui.ResetOnSpawn = false
		modeGui.IgnoreGuiInset = true
		modeGui.DisplayOrder = 120
		modeGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		modeGui.Parent = PlayerGui

		local card = Instance.new("Frame", modeGui)
		card.Name = "EntryModeSelector"
		card.AnchorPoint = Vector2.new(0.5, 0.5)
		card.Position = UDim2.fromScale(0.5, 0.5)
		card.Size = UDim2.fromOffset(202, 142)
		card.BackgroundColor3 = Color3.fromRGB(8, 12, 24)
		card.BackgroundTransparency = 0.86
		card.BorderSizePixel = 0
		card.ZIndex = 110
		Instance.new("UICorner", card).CornerRadius = UDim.new(0, 12)

		local title = Instance.new("TextLabel", card)
		title.Position = UDim2.new(0, 10, 0, 7)
		title.Size = UDim2.new(1, -20, 0, 22)
		title.BackgroundTransparency = 1
		title.Text = "Modo de entrada"
		title.TextColor3 = Color3.fromRGB(240, 245, 255)
		title.TextTransparency = 0.06
		title.TextSize = 11
		title.Font = Enum.Font.GothamMedium
		title.ZIndex = 111

		local hint = Instance.new("TextLabel", card)
		hint.Position = UDim2.new(0, 10, 0, 29)
		hint.Size = UDim2.new(1, -20, 0, 16)
		hint.BackgroundTransparency = 1
		hint.Text = "Elige como iniciar el juego"
		hint.TextColor3 = Color3.fromRGB(170, 190, 218)
		hint.TextTransparency = 0.10
		hint.TextSize = 8
		hint.Font = Enum.Font.Gotham
		hint.ZIndex = 111

		local options = Instance.new("Frame", card)
		options.Position = UDim2.new(0, 9, 0, 52)
		options.Size = UDim2.new(1, -18, 0, 31)
		options.BackgroundTransparency = 1
		options.ZIndex = 111
		local layout = Instance.new("UIListLayout", options)
		layout.FillDirection = Enum.FillDirection.Horizontal
		layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		layout.VerticalAlignment = Enum.VerticalAlignment.Center
		layout.Padding = UDim.new(0, 7)

		local function createModeButton(name, label)
			local button = Instance.new("TextButton", options)
			button.Name = name
			button.Size = UDim2.fromOffset(84, 29)
			button.BackgroundColor3 = Color3.fromRGB(32, 45, 68)
			button.BackgroundTransparency = 0.91
			button.BorderSizePixel = 0
			button.Text = label
			button.TextColor3 = Color3.fromRGB(190, 205, 225)
			button.TextTransparency = 0.10
			button.TextSize = 9
			button.Font = Enum.Font.GothamMedium
			button.AutoButtonColor = false
			button.ZIndex = 112
			Instance.new("UICorner", button).CornerRadius = UDim.new(0, 7)
			return button
		end

		local normalBtn = createModeButton("Normal", "Modo Normal")
		local godBtn = createModeButton("God", "Modo God")

		local footer = Instance.new("TextLabel", card)
		footer.AnchorPoint = Vector2.new(0.5, 1)
		footer.Position = UDim2.new(0.5, 0, 1, -12)
		footer.Size = UDim2.new(1, -20, 0, 23)
		footer.BackgroundTransparency = 1
		footer.Text = "CHINOINFIERNOHUBv3"
		footer.TextColor3 = Color3.fromRGB(135, 158, 192)
		footer.TextTransparency = 0.24
		footer.TextSize = 8
		footer.Font = Enum.Font.GothamMedium
		footer.ZIndex = 111

		local done = false
		local clicked = false
		local function closeSelector(button)
			if clicked then return false end
			clicked = true
			button.BackgroundTransparency = 0.62
			button.TextColor3 = Color3.fromRGB(255, 255, 255)
			if SettingsVisual.IsLowPerformance and SettingsVisual.IsLowPerformance() then
				modeGui:Destroy()
			else
				local t = TweenInfo.new(0.22, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
				for _, obj in ipairs(card:GetDescendants()) do
					if obj:IsA("TextLabel") or obj:IsA("TextButton") then
						TweenService:Create(obj, t, {TextTransparency = 1}):Play()
					end
				end
				local fade = TweenService:Create(card, t, {BackgroundTransparency = 1})
				fade:Play()
				fade.Completed:Wait()
				modeGui:Destroy()
			end
			return true
		end

		local function pressButton(guiObject)
			if not guiObject then return end
			pcall(function() firesignal(guiObject.MouseButton1Click) end)
			pcall(function() firesignal(guiObject.Activated) end)
		end

		normalBtn.Activated:Connect(function()
			if not closeSelector(normalBtn) then return end
			SettingsVisual.EntryMode = "Normal"
			-- Entrada INMEDIATA: no tocar SplashScreenGui, CharacterCreator,
			-- Player.Kill ni remotes de respawn. Conserva el personaje actual.
			if SettingsVisual.SetGodModeEnabled then SettingsVisual.SetGodModeEnabled(false) end
			done = true
		end)

		godBtn.Activated:Connect(function()
			if not closeSelector(godBtn) then return end
			SettingsVisual.EntryMode = "God"
			-- Se activa el MISMO controlador que maneja el switch en Config.
			if SettingsVisual.SetGodModeEnabled then
				SettingsVisual.SetGodModeEnabled(true)
			end
			task.spawn(function()
				task.wait(0.5)
				local splashGui = PlayerGui:FindFirstChild("SplashScreenGui")
				if splashGui then
					local frame = splashGui:FindFirstChild("Frame")
					pressButton(frame and frame:FindFirstChild("PlayButton"))
				end
				task.wait(0.5)
				local characterCreator = PlayerGui:FindFirstChild("CharacterCreator")
				if characterCreator then
					local menuFrame = characterCreator:FindFirstChild("MenuFrame")
					pressButton(menuFrame and menuFrame:FindFirstChild("AvatarMenuSkipButton"))
				end
				task.wait(2.5)
				pcall(function()
					replicatesignal(Player.Kill)
				end)
				task.wait(7)
				pcall(function()
					local net = SettingsVisual.GodModeGetNet()
					if net then net.send("death_screen_request_respawn") end
				end)
				done = true
			end)
		end)

		while not done do task.wait(0.03) end
	end

	if introGui then introGui:Destroy() end

-- Pantalla de enlaces previa al menu principal (solo UI; no altera la logica del HUB).
do
    local oldWelcome = PlayerGui:FindFirstChild("CHINO_LinkWelcome")
    if oldWelcome then oldWelcome:Destroy() end

    local welcomeGui = Instance.new("ScreenGui")
    welcomeGui.Name = "CHINO_LinkWelcome"
    welcomeGui.IgnoreGuiInset = true
    welcomeGui.ResetOnSpawn = false
    welcomeGui.DisplayOrder = 10000
    welcomeGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    welcomeGui.Parent = PlayerGui

    local bg = Instance.new("Frame")
    bg.Size = UDim2.fromScale(1, 1)
    bg.BackgroundColor3 = Color3.fromRGB(25, 7, 48)
    bg.BorderSizePixel = 0
    bg.Parent = welcomeGui
    local bgGradient = Instance.new("UIGradient")
    bgGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(45, 12, 83)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(20, 7, 38)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(67, 17, 105))
    })
    bgGradient.Rotation = 25
    bgGradient.Parent = bg

    local title = Instance.new("TextLabel")
    title.AnchorPoint = Vector2.new(0.5, 0)
    title.Position = UDim2.new(0.5, 0, 0.07, 0)
    title.Size = UDim2.new(0.9, 0, 0, 42)
    title.BackgroundTransparency = 1
    title.Text = "¡Únete!"
    title.Font = Enum.Font.GothamBlack
    title.TextSize = 24
    title.TextColor3 = Color3.fromRGB(245, 225, 255)
    title.TextScaled = false
    title.Parent = bg

    local subtitle = Instance.new("TextLabel")
    subtitle.AnchorPoint = Vector2.new(0.5, 0)
    subtitle.Position = UDim2.new(0.5, 0, 0.07, 38)
    subtitle.Size = UDim2.new(0.9, 0, 0, 25)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = "Únete a nuestras comunidades"
    subtitle.Font = Enum.Font.Gotham
    subtitle.TextSize = 14
    subtitle.TextColor3 = Color3.fromRGB(197, 165, 224)
    subtitle.Parent = bg

    local function makeLinkCard(name, imageId, labelText, inviteUrl, xScale)
        local card = Instance.new("Frame")
        card.Name = name .. "Card"
        card.AnchorPoint = Vector2.new(0.5, 0.5)
        card.Position = UDim2.new(xScale, 0, 0.43, 0)
        card.Size = UDim2.new(0.38, 0, 0, 210)
        card.BackgroundColor3 = Color3.fromRGB(39, 17, 59)
        card.BackgroundTransparency = 0.08
        card.BorderSizePixel = 0
        card.Parent = bg
        Instance.new("UICorner", card).CornerRadius = UDim.new(0, 16)
        local outline = Instance.new("UIStroke")
        outline.Color = Color3.fromRGB(177, 91, 255)
        outline.Thickness = 1.5
        outline.Transparency = 0.18
        outline.Parent = card

        local image = Instance.new("ImageLabel")
        image.Name = "CommunityImage"
        image.AnchorPoint = Vector2.new(0.5, 0)
        image.Position = UDim2.new(0.5, 0, 0, 16)
        image.Size = UDim2.new(0, 100, 0, 100)
        image.BackgroundColor3 = Color3.fromRGB(28, 10, 43)
        image.BorderSizePixel = 0
        -- Primero solicita la miniatura del asset; algunos IDs de imagen/decal
        -- se muestran mejor mediante rbxthumb. Si no carga, prueba rbxassetid.
        image.Image = "rbxthumb://type=Asset&id=" .. tostring(imageId) .. "&w=420&h=420"
        image.ScaleType = Enum.ScaleType.Crop
        image.Parent = card
        Instance.new("UICorner", image).CornerRadius = UDim.new(0, 14)

        task.spawn(function()
            task.wait(3)
            if image.Parent and not image.IsLoaded then
                image.Image = "rbxassetid://" .. tostring(imageId)
                task.wait(4)
                if image.Parent and not image.IsLoaded then
                    warn("[CHINO] No se pudo cargar la imagen del asset ID:", tostring(imageId),
                        "- revisa que sea una imagen/decal pública y utilizable.")
                end
            end
        end)

        local copyButton = Instance.new("TextButton")
        copyButton.Name = "CopyButton"
        copyButton.AnchorPoint = Vector2.new(0.5, 0)
        copyButton.Position = UDim2.new(0.5, 0, 0, 130)
        copyButton.Size = UDim2.new(0.82, 0, 0, 42)
        copyButton.BackgroundColor3 = Color3.fromRGB(139, 54, 210)
        copyButton.BorderSizePixel = 0
        copyButton.Text = labelText
        copyButton.Font = Enum.Font.GothamBold
        copyButton.TextSize = 15
        copyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        copyButton.AutoButtonColor = true
        copyButton.Parent = card
        Instance.new("UICorner", copyButton).CornerRadius = UDim.new(0, 10)

        local status = Instance.new("TextLabel")
        status.AnchorPoint = Vector2.new(0.5, 0)
        status.Position = UDim2.new(0.5, 0, 0, 175)
        status.Size = UDim2.new(0.9, 0, 0, 22)
        status.BackgroundTransparency = 1
        status.Text = "Toca para copiar el enlace"
        status.Font = Enum.Font.Gotham
        status.TextSize = 10
        status.TextColor3 = Color3.fromRGB(194, 170, 212)
        status.Parent = card

        copyButton.Activated:Connect(function()
            local copied = false
            if type(setclipboard) == "function" then
                copied = pcall(setclipboard, inviteUrl)
            elseif type(toclipboard) == "function" then
                copied = pcall(toclipboard, inviteUrl)
            elseif type(setrbxclipboard) == "function" then
                copied = pcall(setrbxclipboard, inviteUrl)
            elseif syn and type(syn.write_clipboard) == "function" then
                copied = pcall(syn.write_clipboard, inviteUrl)
            end
            status.Text = copied and "¡Enlace copiado!" or "Tu executor no permite copiar"
            status.TextColor3 = copied and Color3.fromRGB(177, 255, 194) or Color3.fromRGB(255, 175, 175)
        end)
    end

    -- REN Hub a la izquierda; XPLT a la derecha.
    makeLinkCard("RENHub", 105385731091280, "Copy REN Hub", "https://discord.gg/nzRZtFU9yu", 0.28)
    makeLinkCard("XPLT", 78828364019813, "Copy XPLT", "https://discord.gg/eJymScqzr", 0.72)

    local warning = Instance.new("TextLabel")
    warning.AnchorPoint = Vector2.new(0.5, 0.5)
    warning.Position = UDim2.new(0.5, 0, 0.70, 0)
    warning.Size = UDim2.new(0.9, 0, 0, 48)
    warning.BackgroundTransparency = 1
    warning.Text = "Este script es completamente gratis, si te lo vendieron te han estafado"
    warning.Font = Enum.Font.GothamBold
    warning.TextSize = 14
    warning.TextColor3 = Color3.fromRGB(255, 226, 255)
    warning.TextWrapped = true
    warning.Parent = bg

    -- Cuenta regresiva centrada en la parte inferior; la pantalla se cierra al terminar.
    local countdown = Instance.new("TextLabel")
    countdown.Name = "WelcomeCountdown"
    countdown.AnchorPoint = Vector2.new(0.5, 0.5)
    countdown.Position = UDim2.new(0.5, 0, 0.93, 0)
    countdown.Size = UDim2.new(0, 180, 0, 38)
    countdown.BackgroundTransparency = 1
    countdown.Text = "5..."
    countdown.Font = Enum.Font.GothamBlack
    countdown.TextSize = 24
    countdown.TextColor3 = Color3.fromRGB(245, 225, 255)
    countdown.TextStrokeTransparency = 0.65
    countdown.Parent = bg

    local countdownTexts = {"5...", "4..", "3.", "2..", "1..."}
    for _, countdownText in ipairs(countdownTexts) do
        if not welcomeGui.Parent then break end
        countdown.Text = countdownText
        task.wait(1)
    end
    if welcomeGui and welcomeGui.Parent then
        welcomeGui:Destroy()
    end
end


	-- AQUI vuelve exactamente el panel que ya teniamos; no se reconstruye.
	Gui.Enabled = true
	Main.Visible = true
    SettingsVisual.PanelIsOpen = true
    if SettingsVisual.RefreshFloatingMenus then SettingsVisual.RefreshFloatingMenus(false) end
    Glow.Visible = false

    if SettingsVisual.IsLowPerformance
		and SettingsVisual.IsLowPerformance() then

		Main.Size = PANEL_SIZE
		Main.BackgroundTransparency = ALPHA.Main
		pcall(function() GameBlur.Size = 10 end)
	else
		-- Gama Alta: EXACTAMENTE la animación actual.
		Main.Size = UDim2.new(0, PANEL_SIZE.X.Offset - 28, 0, PANEL_SIZE.Y.Offset - 20)
		Main.BackgroundTransparency = 1

		TweenService:Create(
			Main,
			TweenInfo.new(
				0.55,
				Enum.EasingStyle.Quint,
				Enum.EasingDirection.Out
			),
			{
				Size = PANEL_SIZE,
				BackgroundTransparency = ALPHA.Main
			}
		):Play()

		TweenService:Create(
			Glow,
			TweenInfo.new(
				0.65,
				Enum.EasingStyle.Quint,
				Enum.EasingDirection.Out
			),
			{BackgroundTransparency = ALPHA.Glow}
		):Play()
	end
end)

-- Carga automatica de la ultima config guardada al ejecutar.
task.defer(function()
	task.wait(0.25)
	pcall(function()
		print(
			"CHINOINFIERNO | Executor:",
			SettingsVisual.ExecutorName,
			"| SilentAim hook:",
			SettingsVisual.SilentAimHookMode
		)
	end)
	if SettingsVisual.LoadConfig then
		local loaded = SettingsVisual.LoadConfig()
		if loaded then print("✅ Config cargada automaticamente") end
	end
end)

local dragging = false
local dragStart
local startPosition
local dragInput

Header.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPosition = Main.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then dragging = false end
		end)
	end
end)

Header.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - dragStart
		Main.Position = UDim2.new(
			startPosition.X.Scale,
			startPosition.X.Offset + delta.X,
			startPosition.Y.Scale,
			startPosition.Y.Offset + delta.Y
		)
		Glow.Position = Main.Position
	end
end)

local OpenButton = Instance.new("TextButton")
OpenButton.Name = "OpenButton"
OpenButton.AnchorPoint = Vector2.new(0.5, 0)
OpenButton.Position = UDim2.new(0.5, 0, 0, 16)
OpenButton.Size = UDim2.new(0, 42, 0, 42)
OpenButton.BackgroundTransparency = 1
OpenButton.BorderSizePixel = 0
OpenButton.Text = ""
OpenButton.AutoButtonColor = false
OpenButton.Visible = false
OpenButton.ZIndex = 120
OpenButton.Parent = Gui

local OpenBg = Instance.new("Frame")
OpenBg.Name = "OpenBg"
OpenBg.Size = UDim2.fromScale(1, 1)
OpenBg.Position = UDim2.fromScale(0, 0)
OpenBg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
OpenBg.BackgroundTransparency = 0.2
OpenBg.BorderSizePixel = 0
OpenBg.ClipsDescendants = true
OpenBg.ZIndex = 120
OpenBg.Parent = OpenButton
Instance.new("UICorner", OpenBg).CornerRadius = UDim.new(0, 12)

-- PASO 1: misma foto del panel en el botón para volver a abrirlo
local OpenButtonImage = Instance.new("ImageLabel")
OpenButtonImage.Name = "OpenButtonImage"
OpenButtonImage.AnchorPoint = Vector2.new(0.5, 0.5)
OpenButtonImage.Position = UDim2.fromScale(0.5, 0.5)
OpenButtonImage.Size = UDim2.fromScale(1, 1)
OpenButtonImage.BackgroundTransparency = 1
OpenButtonImage.BorderSizePixel = 0
OpenButtonImage.Image = "rbxassetid://105275560374583"
OpenButtonImage.ImageTransparency = 0.1
OpenButtonImage.ScaleType = Enum.ScaleType.Crop
OpenButtonImage.ZIndex = 121
OpenButtonImage.Parent = OpenBg
Instance.new("UICorner", OpenButtonImage).CornerRadius = UDim.new(0, 12)

local isBusy = false

-- Fade seguro del panel completo.
-- IMPORTANTE: no modifica TextTransparency/ImageTransparency de cada opcion,
-- porque eso podia dejar letras invisibles al volver a abrir.
SettingsVisual.PanelFadeGroup = SettingsVisual.PanelFadeGroup or Instance.new("CanvasGroup")
SettingsVisual.PanelFadeGroup.Name = "PanelFadeGroup"
SettingsVisual.PanelFadeGroup.Size = UDim2.fromScale(1, 1)
SettingsVisual.PanelFadeGroup.Position = UDim2.fromScale(0, 0)
SettingsVisual.PanelFadeGroup.BackgroundTransparency = 1
SettingsVisual.PanelFadeGroup.GroupTransparency = 0
SettingsVisual.PanelFadeGroup.Parent = Gui

-- Main y Glow conservan exactamente su contenido/estados; solo cambia su contenedor visual.
Main.Parent = SettingsVisual.PanelFadeGroup
Glow.Parent = SettingsVisual.PanelFadeGroup

Minimize.MouseButton1Click:Connect(function()
	if isBusy then return end
	isBusy = true

	local low =
		SettingsVisual.IsLowPerformance
		and SettingsVisual.IsLowPerformance()

	if low then
		-- Gama Baja: cierre inmediato, sin blur ni decenas de Tweens.
		SettingsVisual.PanelFadeGroup.GroupTransparency = 1
		Main.Visible = false
        SettingsVisual.PanelIsOpen = false
        if SettingsVisual.RefreshFloatingMenus then SettingsVisual.RefreshFloatingMenus(true) end
        Glow.Visible = false
        OpenButton.Visible = true
		Main.Size = SettingsVisual.GetPanelTargetSize()
		GameBlur.Size = 0

		pcall(function()
			local bgGui =
				PlayerGui:FindFirstChild("ChinoNeonBackground")
				or CoreGui:FindFirstChild("ChinoNeonBackground")

			if bgGui then
				bgGui.Enabled = false
			end
		end)

		isBusy = false
		return
	end

	-- Gama Alta: comportamiento visual original intacto.
	local fadeInfo =
		TweenInfo.new(
			0.48,
			Enum.EasingStyle.Sine,
			Enum.EasingDirection.InOut
		)

	TweenService:Create(
		SettingsVisual.PanelFadeGroup,
		fadeInfo,
		{GroupTransparency = 1}
	):Play()

	TweenService:Create(
		Main,
		fadeInfo,
		{
			Size =
				UDim2.new(
					0,
					SettingsVisual.GetPanelTargetSize().X.Offset - 18,
					0,
					SettingsVisual.GetPanelTargetSize().Y.Offset - 14
				)
		}
	):Play()

	pcall(function()
		local bgGui =
			PlayerGui:FindFirstChild("ChinoNeonBackground")
			or CoreGui:FindFirstChild("ChinoNeonBackground")

		if bgGui then
			for _, obj in ipairs(bgGui:GetDescendants()) do
				if obj:IsA("GuiObject") then
					if obj:GetAttribute("CHINO_BG_ORIG_BG") == nil then
						obj:SetAttribute(
							"CHINO_BG_ORIG_BG",
							obj.BackgroundTransparency
						)
					end

					TweenService:Create(
						obj,
						fadeInfo,
						{BackgroundTransparency = 1}
					):Play()
				end

				if obj:IsA("ImageLabel") or obj:IsA("ImageButton") then
					if obj:GetAttribute("CHINO_BG_ORIG_IMG") == nil then
						obj:SetAttribute(
							"CHINO_BG_ORIG_IMG",
							obj.ImageTransparency
						)
					end

					TweenService:Create(
						obj,
						fadeInfo,
						{ImageTransparency = 1}
					):Play()
				end
			end

			task.delay(0.50, function()
				if bgGui and bgGui.Parent then
					bgGui.Enabled = false
				end
			end)
		end
	end)

	TweenService:Create(
		GameBlur,
		TweenInfo.new(
			0.30,
			Enum.EasingStyle.Sine,
			Enum.EasingDirection.Out
		),
		{Size = 38}
	):Play()

	task.wait(0.50)

    Main.Visible = false
    SettingsVisual.PanelIsOpen = false
    if SettingsVisual.RefreshFloatingMenus then SettingsVisual.RefreshFloatingMenus(true) end
    Glow.Visible = false
    OpenButton.Visible = true
	Main.Size = SettingsVisual.GetPanelTargetSize()

	task.wait(0.65)

	TweenService:Create(
		GameBlur,
		TweenInfo.new(
			0.80,
			Enum.EasingStyle.Sine,
			Enum.EasingDirection.InOut
		),
		{Size = 0}
	):Play()

	task.wait(0.22)
	isBusy = false
end)

OpenButton.MouseButton1Click:Connect(function()
	if isBusy then return end
	isBusy = true
	OpenButton.Visible = false

	local low =
		SettingsVisual.IsLowPerformance
		and SettingsVisual.IsLowPerformance()

	if low then
		-- Gama Baja: reapertura inmediata, sin blur/Tweens del fondo.
        Main.Visible = true
        SettingsVisual.PanelIsOpen = true
        if SettingsVisual.RefreshFloatingMenus then SettingsVisual.RefreshFloatingMenus(true) end
        Glow.Visible = false
		Main.Size = SettingsVisual.GetPanelTargetSize()
		SettingsVisual.PanelFadeGroup.GroupTransparency = 0
		GameBlur.Size = 10

		pcall(function()
			local bgGui =
				PlayerGui:FindFirstChild("ChinoNeonBackground")
				or CoreGui:FindFirstChild("ChinoNeonBackground")

			if bgGui then
				bgGui.Enabled = true
			end
		end)

		isBusy = false
		return
	end

	-- Gama Alta: comportamiento visual original intacto.
    Main.Visible = true
    SettingsVisual.PanelIsOpen = true
    if SettingsVisual.RefreshFloatingMenus then SettingsVisual.RefreshFloatingMenus(true) end
    Glow.Visible = false

    Main.Size =
		UDim2.new(
			0,
			SettingsVisual.GetPanelTargetSize().X.Offset - 18,
			0,
			SettingsVisual.GetPanelTargetSize().Y.Offset - 14
		)

	SettingsVisual.PanelFadeGroup.GroupTransparency = 1
	GameBlur.Size = 0

	local openInfo =
		TweenInfo.new(
			0.52,
			Enum.EasingStyle.Sine,
			Enum.EasingDirection.Out
		)

	pcall(function()
		local bgGui =
			PlayerGui:FindFirstChild("ChinoNeonBackground")
			or CoreGui:FindFirstChild("ChinoNeonBackground")

		if bgGui then
			bgGui.Enabled = true

			for _, obj in ipairs(bgGui:GetDescendants()) do
				if obj:IsA("GuiObject") then
					local oldBg =
						obj:GetAttribute("CHINO_BG_ORIG_BG")

					if oldBg ~= nil then
						TweenService:Create(
							obj,
							openInfo,
							{BackgroundTransparency = oldBg}
						):Play()
					end
				end

				if obj:IsA("ImageLabel") or obj:IsA("ImageButton") then
					local oldImg =
						obj:GetAttribute("CHINO_BG_ORIG_IMG")

					if oldImg ~= nil then
						TweenService:Create(
							obj,
							openInfo,
							{ImageTransparency = oldImg}
						):Play()
					end
				end
			end
		end
	end)

	TweenService:Create(
		SettingsVisual.PanelFadeGroup,
		openInfo,
		{GroupTransparency = 0}
	):Play()

	TweenService:Create(
		Main,
		openInfo,
		{Size = SettingsVisual.GetPanelTargetSize()}
	):Play()

	TweenService:Create(
		GameBlur,
		TweenInfo.new(
			0.52,
			Enum.EasingStyle.Sine,
			Enum.EasingDirection.Out
		),
		{Size = 24}
	):Play()

	task.wait(0.55)
	isBusy = false
end)

local AlertOverlay = Instance.new("Frame")
AlertOverlay.Name = "AlertOverlay"
AlertOverlay.Size = UDim2.fromScale(1, 1)
AlertOverlay.Position = UDim2.fromScale(0, 0)
AlertOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
AlertOverlay.BackgroundTransparency = 1
AlertOverlay.Visible = false
AlertOverlay.ZIndex = 200
AlertOverlay.Parent = Gui

local AlertBox = Instance.new("Frame")
AlertBox.Name = "AlertBox"
AlertBox.AnchorPoint = Vector2.new(0.5, 0.5)
AlertBox.Position = UDim2.fromScale(0.5, 0.5)
AlertBox.Size = UDim2.new(0, 310, 0, 160)
AlertBox.BackgroundColor3 = COLORS.Glass2
AlertBox.BackgroundTransparency = 0.25
AlertBox.ZIndex = 201
AlertBox.Parent = AlertOverlay
Instance.new("UICorner", AlertBox).CornerRadius = UDim.new(0, 18)

local AlertMessage = Instance.new("TextLabel", AlertBox)
AlertMessage.Position = UDim2.new(0, 20, 0, 48)
AlertMessage.Size = UDim2.new(1, -40, 0, 36)
AlertMessage.BackgroundTransparency = 1
AlertMessage.Text = "¿Seguro que quieres cerrar el panel?"
AlertMessage.TextColor3 = COLORS.Text
AlertMessage.TextSize = 13
AlertMessage.Font = Enum.Font.Gotham
AlertMessage.TextWrapped = true
AlertMessage.TextXAlignment = Enum.TextXAlignment.Center
AlertMessage.ZIndex = 202

local AlertBtnYes = Instance.new("TextButton", AlertBox)
AlertBtnYes.AnchorPoint = Vector2.new(0, 1)
AlertBtnYes.Position = UDim2.new(0, 24, 1, -18)
AlertBtnYes.Size = UDim2.new(0, 120, 0, 36)
AlertBtnYes.BackgroundColor3 = Color3.fromRGB(180, 35, 60)
AlertBtnYes.Text = "Yes"
AlertBtnYes.TextColor3 = COLORS.White
AlertBtnYes.TextSize = 14
AlertBtnYes.ZIndex = 203
Instance.new("UICorner", AlertBtnYes).CornerRadius = UDim.new(0, 10)

local AlertBtnNo = Instance.new("TextButton", AlertBox)
AlertBtnNo.AnchorPoint = Vector2.new(1, 1)
AlertBtnNo.Position = UDim2.new(1, -24, 1, -18)
AlertBtnNo.Size = UDim2.new(0, 120, 0, 36)
AlertBtnNo.BackgroundColor3 = Color3.fromRGB(30, 45, 75)
AlertBtnNo.Text = "No"
AlertBtnNo.TextColor3 = COLORS.White
AlertBtnNo.TextSize = 14
AlertBtnNo.ZIndex = 203
Instance.new("UICorner", AlertBtnNo).CornerRadius = UDim.new(0, 10)

Close.MouseButton1Click:Connect(function()
	if isBusy then return end
	AlertOverlay.Visible = true
end)

AlertBtnNo.MouseButton1Click:Connect(function()
	AlertOverlay.Visible = false
end)

AlertBtnYes.MouseButton1Click:Connect(function()
	if SettingsVisual.TouchCarRestoreSeatPose then
		SettingsVisual.TouchCarRestoreSeatPose()
	end
	if SettingsVisual.SetGhostState then
		SettingsVisual.SetGhostState(false)
	end
	if SettingsVisual.GhostMoveConnection then
		pcall(function() SettingsVisual.GhostMoveConnection:Disconnect() end)
		SettingsVisual.GhostMoveConnection = nil
	end
	if SettingsVisual.DamageFXCleanup then
		pcall(SettingsVisual.DamageFXCleanup)
	end
	GameBlur:Destroy()
	Gui:Destroy()
	GhostFloatingSwitchGui:Destroy()
	TouchPanelGui:Destroy()
end)
