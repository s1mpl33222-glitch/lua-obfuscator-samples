-- opus client
-- LocalScript. Куда положить: StarterPlayer > StarterPlayerScripts
-- Открыть/скрыть меню: RightControl.
-- Заменяет предыдущие версии меню (не держите две версии одновременно).

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")

--------------------------------------------------------------------
-- Синхронизация визуалов между пользователями меню.
-- Эффекты (шляпа, аура, спина, платформа, питомец, «Я бульба») устроены как «фабрики» RENDERERS:
-- фабрике дают игрока-владельца и его настройки, и она рисует эффект на ЕГО персонаже.
-- syncContext подменяет для фабрики «localPlayer» на владельца и запоминает все её подписки,
-- чтобы при выходе игрока всё можно было аккуратно отключить и убрать.
--------------------------------------------------------------------
local RENDERERS = {}
local realRunService = RunService

local function syncContext(owner, connections)
	local function track(signal)
		return {
			Connect = function(_, callback)
				local connection = signal:Connect(callback)
				table.insert(connections, connection)
				return connection
			end,
		}
	end
	local runProxy = {
		RenderStepped = track(realRunService.RenderStepped),
		Heartbeat = track(realRunService.Heartbeat),
		Stepped = track(realRunService.Stepped),
	}
	local playerProxy = setmetatable({}, {
		__index = function(_, key)
			if key == "CharacterAdded" or key == "CharacterRemoving" then
				return track(owner[key])
			end
			return owner[key]
		end,
	})
	return playerProxy, runProxy
end

local CONFIG = {
	MenuKey = Enum.KeyCode.RightControl,

	-- переключатели (меняются из меню)
	Enabled = true,
	ShowHighlight = true,
	ShowLabel = true,
	ShowNames = true,
	ShowDistance = true,
	ShowHealth = true,
	ShowTeammates = true,
	ShowBoxes = false,          -- 2D-рамка вокруг игрока на экране
	BoxFill = false,            -- полупрозрачная заливка рамки
	BoxThickness = 1.5,
	ShowTracers = false,        -- линия от края экрана к игроку
	TracerOrigin = "Снизу",     -- "Снизу", "Центр" или "Курсор"
	TracerThickness = 1.5,

	-- числовые/цветовые настройки
	MaxDistance = 1000,
	FillTransparency = 0.7,
	OutlineColor = Color3.fromRGB(255, 255, 255),
	EnemyColor = Color3.fromRGB(255, 60, 60),
	TeamColor = Color3.fromRGB(60, 255, 60),
}

--------------------------------------------------------------------
-- ESP
--------------------------------------------------------------------
-- Roblox одновременно рисует не больше 31 Highlight на весь клиент.
-- Самые близкие игроки получают Highlight, остальным рисуется рамка (у неё лимита нет).
local HIGHLIGHT_LIMIT = 30

-- Все объекты ESP лежат в своей папке, а не внутри персонажей:
-- так их не удаляют скрипты игры и не ломает перезагрузка персонажа.
local espFolder = Instance.new("Folder")
espFolder.Name = "ESP_Local"
espFolder.Parent = workspace

-- 2D-элементы (боксы и трейсеры) рисуются в отдельном ScreenGui поверх мира, но под меню
local espScreen = Instance.new("ScreenGui")
espScreen.Name = "OpusClient_ESP2D"
espScreen.IgnoreGuiInset = true -- координаты совпадают с камерой (WorldToViewportPoint)
espScreen.ResetOnSpawn = false
espScreen.DisplayOrder = 5
espScreen.Parent = playerGui

local tracked = {} -- [Player] = { character, head, humanoid, root, highlight, box, gui, label, barBg, barFill, box2d, tracer }

local function isTeammate(player)
	return player.Team ~= nil and player.Team == localPlayer.Team
end

local function clear(player)
	local data = tracked[player]
	if not data then
		return
	end
	data.highlight:Destroy()
	data.box:Destroy()
	data.gui:Destroy()
	data.box2d:Destroy()
	data.tracer:Destroy()
	tracked[player] = nil
end

-- Не ждёт частей персонажа: если чего-то ещё нет (например, персонаж ещё не догрузился),
-- просто выходит, и периодическая проверка попробует снова.
local function build(player, character)
	clear(player)

	local head = character:FindFirstChild("Head")
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	local root = character:FindFirstChild("HumanoidRootPart")
	if not head or not humanoid or not root then
		return
	end

	local highlight = Instance.new("Highlight")
	highlight.Name = player.Name .. "_Highlight"
	highlight.Adornee = character
	highlight.FillTransparency = CONFIG.FillTransparency
	highlight.OutlineColor = CONFIG.OutlineColor
	highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	highlight.Enabled = false
	highlight.Parent = espFolder

	local box = Instance.new("BoxHandleAdornment")
	box.Name = player.Name .. "_Box"
	box.Adornee = root
	box.Size = Vector3.new(4, 5.5, 2.5)
	box.CFrame = CFrame.new(0, -0.3, 0)
	box.AlwaysOnTop = true
	box.ZIndex = 5
	box.Transparency = 0.65
	box.Visible = false
	box.Parent = espFolder

	local gui = Instance.new("BillboardGui")
	gui.Name = player.Name .. "_Label"
	gui.Adornee = head
	gui.Size = UDim2.fromOffset(200, 50)
	gui.StudsOffset = Vector3.new(0, 2.5, 0)
	gui.AlwaysOnTop = true
	gui.Enabled = false
	gui.Parent = espFolder

	local label = Instance.new("TextLabel")
	label.BackgroundTransparency = 1
	label.Size = UDim2.new(1, 0, 0, 22)
	label.Font = Enum.Font.GothamBold
	label.TextSize = 14
	label.TextStrokeTransparency = 0.4
	label.Text = ""
	label.Parent = gui

	local barBg = Instance.new("Frame")
	barBg.AnchorPoint = Vector2.new(0.5, 0)
	barBg.Position = UDim2.new(0.5, 0, 0, 26)
	barBg.Size = UDim2.fromOffset(80, 6)
	barBg.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	barBg.BorderSizePixel = 0
	barBg.Parent = gui

	local barFill = Instance.new("Frame")
	barFill.Size = UDim2.fromScale(1, 1)
	barFill.BackgroundColor3 = Color3.fromRGB(60, 255, 60)
	barFill.BorderSizePixel = 0
	barFill.Parent = barBg

	local box2d = Instance.new("Frame")
	box2d.Name = player.Name .. "_Box2D"
	box2d.AnchorPoint = Vector2.new(0.5, 0.5)
	box2d.BackgroundTransparency = 1
	box2d.BorderSizePixel = 0
	box2d.Visible = false
	box2d.Parent = espScreen

	local boxStroke = Instance.new("UIStroke")
	boxStroke.Thickness = CONFIG.BoxThickness
	boxStroke.Parent = box2d

	-- тёмная подложка под рамкой, чтобы она была видна на любом фоне
	local boxOutline = Instance.new("Frame")
	boxOutline.AnchorPoint = Vector2.new(0.5, 0.5)
	boxOutline.Position = UDim2.fromScale(0.5, 0.5)
	boxOutline.Size = UDim2.new(1, 2, 1, 2)
	boxOutline.BackgroundTransparency = 1
	boxOutline.ZIndex = 0
	boxOutline.Parent = box2d
	local outlineStroke = Instance.new("UIStroke")
	outlineStroke.Color = Color3.fromRGB(0, 0, 0)
	outlineStroke.Transparency = 0.4
	outlineStroke.Thickness = 1
	outlineStroke.Parent = boxOutline

	local tracer = Instance.new("Frame")
	tracer.Name = player.Name .. "_Tracer"
	tracer.AnchorPoint = Vector2.new(0.5, 0.5)
	tracer.BorderSizePixel = 0
	tracer.Visible = false
	tracer.Parent = espScreen

	tracked[player] = {
		character = character,
		head = head,
		humanoid = humanoid,
		root = root,
		highlight = highlight,
		box = box,
		gui = gui,
		label = label,
		barBg = barBg,
		barFill = barFill,
		box2d = box2d,
		boxStroke = boxStroke,
		tracer = tracer,
		distance = 0,
	}
end

-- Всё ли у игрока на месте: тот же персонаж, части не удалены, объекты ESP не удалены
local function isValid(data, character)
	return data.character == character
		and data.head.Parent == character
		and data.humanoid.Parent == character
		and data.root.Parent == character
		and data.highlight.Parent == espFolder
		and data.box.Parent == espFolder
		and data.gui.Parent == espFolder
		and data.box2d.Parent == espScreen
		and data.tracer.Parent == espScreen
end

local function refreshPlayer(player)
	if player == localPlayer then
		return
	end

	local character = player.Character
	if not character or not character.Parent then
		clear(player)
		return
	end

	local data = tracked[player]
	if not data or not isValid(data, character) then
		build(player, character)
	end
end

local function hook(player)
	if player == localPlayer then
		return
	end
	player.CharacterAdded:Connect(function()
		task.defer(refreshPlayer, player)
	end)
	player.CharacterRemoving:Connect(function()
		clear(player)
	end)
	refreshPlayer(player)
end

for _, player in ipairs(Players:GetPlayers()) do
	hook(player)
end
Players.PlayerAdded:Connect(hook)
Players.PlayerRemoving:Connect(clear)

-- Каждые полсекунды проверяем всех игроков и чиним тех, у кого ESP пропал или не создался
local checkTimer = 0
RunService.Heartbeat:Connect(function(dt)
	checkTimer += dt
	if checkTimer < 0.5 then
		return
	end
	checkTimer = 0

	for _, player in ipairs(Players:GetPlayers()) do
		refreshPlayer(player)
	end
	for player in pairs(tracked) do
		if player.Parent ~= Players then
			clear(player)
		end
	end
end)

local highlightCandidates = {}

RunService.RenderStepped:Connect(function()
	local myCharacter = localPlayer.Character
	local myRoot = myCharacter and myCharacter:FindFirstChild("HumanoidRootPart")
	local camera = workspace.CurrentCamera
	-- если вы мертвы или персонаж ещё не появился, считаем расстояние от камеры
	local origin = (myRoot and myRoot.Position) or (camera and camera.CFrame.Position)

	table.clear(highlightCandidates)

	for player, data in pairs(tracked) do
		local visible = CONFIG.Enabled and origin ~= nil and data.head.Parent ~= nil
		local distance = 0

		if visible then
			distance = (data.root.Position - origin).Magnitude
			visible = distance <= CONFIG.MaxDistance and data.humanoid.Health > 0
		end

		local teammate = isTeammate(player)
		if visible and teammate and not CONFIG.ShowTeammates then
			visible = false
		end

		local color = teammate and CONFIG.TeamColor or CONFIG.EnemyColor
		data.distance = distance
		data.color = color
		data.wantHighlight = false
		data.wantBox = false

		if visible and CONFIG.ShowHighlight then
			table.insert(highlightCandidates, data)
		end

		data.gui.Enabled = visible and (CONFIG.ShowLabel or CONFIG.ShowHealth)
		data.label.Visible = CONFIG.ShowLabel
		data.barBg.Visible = CONFIG.ShowHealth

		if visible then
			data.label.TextColor3 = color

			local parts = {}
			if CONFIG.ShowNames then
				table.insert(parts, player.DisplayName)
			end
			if CONFIG.ShowDistance then
				table.insert(parts, string.format("[%d]", math.floor(distance)))
			end

			local health = data.humanoid.Health
			local maxHealth = math.max(data.humanoid.MaxHealth, 1)
			local ratio = math.clamp(health / maxHealth, 0, 1)

			if CONFIG.ShowHealth then
				table.insert(parts, string.format("%d HP", math.ceil(health)))
				data.barFill.Size = UDim2.fromScale(ratio, 1)
				data.barFill.BackgroundColor3 = Color3.fromRGB(255, 60, 60):Lerp(Color3.fromRGB(60, 255, 60), ratio)
			end

			data.label.Text = table.concat(parts, " ")
		end

		-- боксы и трейсеры
		local showBox = visible and CONFIG.ShowBoxes and camera ~= nil
		local showTracer = visible and CONFIG.ShowTracers and camera ~= nil
		local boxShown, tracerShown = false, false

		if showBox or showTracer then
			local rootPosition = data.root.Position
			local top = camera:WorldToViewportPoint(rootPosition + Vector3.new(0, 3, 0))
			local bottom = camera:WorldToViewportPoint(rootPosition - Vector3.new(0, 3.5, 0))
			local inFront = top.Z > 0 and bottom.Z > 0

			if showBox and inFront then
				local height = math.abs(bottom.Y - top.Y)
				local width = height * 0.6
				data.box2d.Position = UDim2.fromOffset((top.X + bottom.X) / 2, (top.Y + bottom.Y) / 2)
				data.box2d.Size = UDim2.fromOffset(width, height)
				data.boxStroke.Color = color
				data.boxStroke.Thickness = CONFIG.BoxThickness
				data.box2d.BackgroundColor3 = color
				data.box2d.BackgroundTransparency = CONFIG.BoxFill and 0.85 or 1
				boxShown = true
			end

			if showTracer and inFront then
				local viewport = camera.ViewportSize
				local from
				if CONFIG.TracerOrigin == "Центр" then
					from = viewport / 2
				elseif CONFIG.TracerOrigin == "Курсор" then
					from = UserInputService:GetMouseLocation()
				else
					from = Vector2.new(viewport.X / 2, viewport.Y)
				end
				local to = Vector2.new(bottom.X, bottom.Y)
				local delta = to - from
				local length = delta.Magnitude
				if length > 1 then
					local middle = from + delta / 2
					data.tracer.Position = UDim2.fromOffset(middle.X, middle.Y)
					data.tracer.Size = UDim2.fromOffset(length, CONFIG.TracerThickness)
					data.tracer.Rotation = math.deg(math.atan2(delta.Y, delta.X))
					data.tracer.BackgroundColor3 = color
					tracerShown = true
				end
			end
		end

		data.box2d.Visible = boxShown
		data.tracer.Visible = tracerShown
	end

	-- ближайшие получают Highlight, остальные — рамку
	table.sort(highlightCandidates, function(a, b)
		return a.distance < b.distance
	end)
	for index, data in ipairs(highlightCandidates) do
		if index <= HIGHLIGHT_LIMIT then
			data.wantHighlight = true
		else
			data.wantBox = true
		end
	end

	for _, data in pairs(tracked) do
		data.highlight.Enabled = data.wantHighlight
		data.box.Visible = data.wantBox
		if data.wantHighlight then
			data.highlight.FillColor = data.color
		end
		if data.wantBox then
			data.box.Color3 = data.color
		end
	end
end)

--------------------------------------------------------------------
-- Виртуальная китайская шляпа (конус над головой вашего персонажа)
-- Собирается из стопки тонких дисков, поэтому острие всегда смотрит вверх.
--------------------------------------------------------------------
local HAT = {
	Enabled = false,
	Rainbow = false,
	Color = Color3.fromRGB(255, 90, 90),
	Radius = 1.4,
	Height = 0.9,
	Transparency = 0.35,
	Glow = false,         -- свечение: неоновый материал + свет вокруг
	GlowStrength = 2,     -- сила свечения (0-5)
	Gap = 0.3,       -- зазор между макушкой и краем шляпы (в studs)
	Style = "Конус", -- "Конус", "Китайская", "Купол", "Цилиндр", "Нимб" или "Рога"
	FirstPersonDistance = 1.5, -- ближе этого расстояния камеры до головы считается видом от первого лица
}

local HAT_STYLES = { "Конус", "Китайская", "Купол", "Цилиндр", "Нимб", "Рога" }
local HAT_SEGMENTS = 24     -- из скольких треугольников собирается конус (больше — глаже)
local HAT_THICKNESS = 0.05  -- толщина стенки шляпы

-- Рисует треугольник a-b-c из двух клиньев (WedgePart). Возвращает обе детали.
local function makeTriangle(a, b, c)
	local ab, ac, bc = b - a, c - a, c - b
	local abd, acd, bcd = ab:Dot(ab), ac:Dot(ac), bc:Dot(bc)
	if abd > acd and abd > bcd then
		c, a = a, c
	elseif acd > bcd and acd > abd then
		a, b = b, a
	end
	ab, ac, bc = b - a, c - a, c - b

	local right = ac:Cross(ab).Unit
	local up = bc:Cross(right).Unit
	local back = bc.Unit
	local height = math.abs(ab:Dot(up))

	local w1 = Instance.new("WedgePart")
	w1.Size = Vector3.new(HAT_THICKNESS, height, math.abs(ab:Dot(back)))
	w1.CFrame = CFrame.fromMatrix((a + b) / 2, right, up, back)

	local w2 = Instance.new("WedgePart")
	w2.Size = Vector3.new(HAT_THICKNESS, height, math.abs(ac:Dot(back)))
	w2.CFrame = CFrame.fromMatrix((a + c) / 2, -right, up, -back)

	return w1, w2
end

-- «Фабрика»: рисует этот эффект для любого игрока (owner) по его настройкам (HAT).
-- Для вас она вызывается с вашими настройками, для других игроков — с присланными через синхронизацию.
RENDERERS.Hat = function(owner, HAT)
	local connections = {}
	local localPlayer, RunService = syncContext(owner, connections)
	local hat = nil -- { folder, parts, head, radius, height }

	local function destroyHat()
		if hat then
			if hat.lightAttachment then
				hat.lightAttachment:Destroy()
			end
			hat.folder:Destroy()
			hat = nil
		end
	end

	local function addHatPart(folder, parts, head, part)
		part.Material = Enum.Material.SmoothPlastic
		part.CastShadow = false
		part.CanCollide = false
		part.CanQuery = false
		part.CanTouch = false
		part.Massless = true
		part.Transparency = 1
		part.Parent = folder

		local weld = Instance.new("WeldConstraint")
		weld.Part0 = head
		weld.Part1 = part
		weld.Parent = part

		parts[#parts + 1] = part
	end

	-- деталь, приваренная к вращающейся ступице (а не к голове)
	local function addSpinPart(folder, parts, hub, part)
		part.Material = Enum.Material.SmoothPlastic
		part.CastShadow = false
		part.CanCollide = false
		part.CanQuery = false
		part.CanTouch = false
		part.Massless = true
		part.Transparency = 1
		part.Parent = folder
		local weld = Instance.new("WeldConstraint")
		weld.Part0 = hub
		weld.Part1 = part
		weld.Parent = part
		parts[#parts + 1] = part
	end

	-- ступица на шарнире: rel — положение относительно головы, speed — скорость вращения (рад/с)
	local function makeHub(folder, head, rel, speed, spinners)
		local hub = Instance.new("Part")
		hub.Name = "Hub"
		hub.Size = Vector3.new(0.05, 0.05, 0.05)
		hub.Transparency = 1
		hub.CanCollide = false
		hub.CanQuery = false
		hub.CanTouch = false
		hub.Massless = true
		hub.CFrame = head.CFrame * rel
		hub.Parent = folder
		local motor = Instance.new("Motor6D")
		motor.Part0 = head
		motor.Part1 = hub
		motor.C0 = rel
		motor.Parent = hub
		table.insert(spinners, { motor = motor, base = rel, speed = speed })
		return hub
	end

	-- кольцо (или дуги) из коротких сегментов вокруг ступицы, в её горизонтальной плоскости
	local function hubRing(folder, parts, hub, radius, thickness, segments, arcs, arcFill)
		arcs = arcs or 1
		arcFill = arcFill or 1
		local perArc = math.floor(segments / arcs)
		local arcSpan = (math.pi * 2 / arcs) * arcFill
		for a = 0, arcs - 1 do
			local start = a * math.pi * 2 / arcs
			local length = radius * arcSpan / perArc * 1.08
			for i = 0, perArc - 1 do
				local angle = start + (i + 0.5) / perArc * arcSpan
				local part = Instance.new("Part")
				part.Name = "Halo"
				part.Size = Vector3.new(thickness, thickness, length)
				part.CFrame = hub.CFrame * CFrame.Angles(0, angle, 0) * CFrame.new(radius, 0, 0)
				addSpinPart(folder, parts, hub, part)
			end
		end
	end

	local function buildHat(character)
		destroyHat()

		local head = character:WaitForChild("Head", 5)
		if not head then
			return
		end

		local folder = Instance.new("Folder")
		folder.Name = "ChinaHat"
		folder.Parent = character

		local parts = {}
		local spinners = {} -- вращающиеся слои (нимб, световые дуги)
		local baseY = head.Size.Y / 2

		if HAT.Style == "Купол" then
			-- половина сферы (нижняя половина спрятана в голове)
			local diameter = HAT.Radius * 2
			local dome = Instance.new("Part")
			dome.Name = "Dome"
			dome.Shape = Enum.PartType.Ball
			dome.Size = Vector3.new(diameter, diameter, diameter)
			dome.CFrame = head.CFrame * CFrame.new(0, baseY + diameter * 0.3, 0)
			addHatPart(folder, parts, head, dome)

		elseif HAT.Style == "Рога" then
			-- Каждый рог — одна цельная гладкая поверхность (сужающаяся «труба» из треугольников, как полый конус шляпы):
			-- без отдельных сегментов, стыков и шарика на конце. Растёт из макушки вверх, загибается наружу
			-- и назад и сходится в острый кончик.
			-- «Радиус» — толщина рогов, «Высота» — длина, «Зазор» — насколько они выше головы.
			local length = 0.8 + HAT.Height * 0.9
			local baseRadius = math.max(0.06, HAT.Radius * 0.1)
			local stations = 8 -- колец вдоль рога
			local sides = 6    -- граней по кругу
			local headCFrame = head.CFrame

			for _, side in ipairs({ -1, 1 }) do
				local base = Vector3.new(side * head.Size.X * 0.28, baseY - 0.08 + HAT.Gap, -0.05)
				local function point(t)
					return base + Vector3.new(
						side * (0.35 * t + 0.25 * t * t) * length,
						(0.95 * t - 0.15 * t * t * t) * length,
						0.3 * t * t * length
					)
				end

				-- кольца точек вокруг осевой линии рога; последнее «кольцо» — одна точка острия
				local rings = {}
				for i = 0, stations - 1 do
					local t = i / stations
					local center = point(t)
					local tangent = (point(math.min(t + 0.01, 1)) - point(math.max(t - 0.01, 0))).Unit
					local normal = tangent:Cross(Vector3.zAxis)
					if normal.Magnitude < 0.01 then
						normal = tangent:Cross(Vector3.xAxis)
					end
					normal = normal.Unit
					local binormal = tangent:Cross(normal).Unit
					local radius = baseRadius * (1 - t * 0.92)
					local ring = {}
					for j = 0, sides - 1 do
						local angle = j / sides * math.pi * 2
						local localPoint = center + (normal * math.cos(angle) + binormal * math.sin(angle)) * radius
						ring[j + 1] = (headCFrame * CFrame.new(localPoint)).Position
					end
					rings[i + 1] = ring
				end
				local tip = (headCFrame * CFrame.new(point(1))).Position

				local function addTriangle(a, b, c)
					local w1, w2 = makeTriangle(a, b, c)
					w1.Name, w2.Name = "Horn", "Horn"
					addHatPart(folder, parts, head, w1)
					addHatPart(folder, parts, head, w2)
				end

				-- боковая поверхность между соседними кольцами
				for i = 1, #rings - 1 do
					local ringA, ringB = rings[i], rings[i + 1]
					for j = 1, sides do
						local k = j % sides + 1
						addTriangle(ringA[j], ringA[k], ringB[j])
						addTriangle(ringA[k], ringB[k], ringB[j])
					end
				end
				-- последнее кольцо сходится в острие
				local last = rings[#rings]
				for j = 1, sides do
					addTriangle(last[j], last[j % sides + 1], tip)
				end
			end

		elseif HAT.Style == "Нимб" then
			-- Нимб — «магический круг» над головой: внешнее кольцо из разорванных дуг, среднее кольцо
			-- с насечками, маленькое внутреннее кольцо, перекрестие лучей и точки-«руны».
			-- Слои вращаются с разной скоростью в разные стороны, весь круг слегка наклонён.
			local R = HAT.Radius * 0.62
			local center = CFrame.new(0, baseY + HAT.Gap + 0.45, 0) * CFrame.Angles(math.rad(10), 0, 0)

			local outer = makeHub(folder, head, center, 0.7, spinners)
			hubRing(folder, parts, outer, R, 0.05, 32, 4, 0.62)              -- разорванные дуги
			for i = 0, 3 do                                                    -- «руны» на внешнем кольце
				local angle = (i + 0.81) * math.pi / 2
				local dot = Instance.new("Part")
				dot.Shape = Enum.PartType.Ball
				dot.Size = Vector3.one * 0.09
				dot.CFrame = outer.CFrame * CFrame.Angles(0, angle, 0) * CFrame.new(R, 0, 0)
				addSpinPart(folder, parts, outer, dot)
			end

			local middle = makeHub(folder, head, center, -1.0, spinners)
			hubRing(folder, parts, middle, R * 0.72, 0.03, 36)                -- сплошное кольцо
			for i = 0, 11 do                                                   -- насечки по кругу
				local angle = i / 12 * math.pi * 2
				local tick = Instance.new("Part")
				tick.Size = Vector3.new(0.13, 0.025, 0.025)
				tick.CFrame = middle.CFrame * CFrame.Angles(0, angle, 0) * CFrame.new(R * 0.72 + 0.07, 0, 0)
				addSpinPart(folder, parts, middle, tick)
			end

			local inner = makeHub(folder, head, center, 1.8, spinners)
			hubRing(folder, parts, inner, R * 0.36, 0.04, 20, 2, 0.75)        -- маленькие дуги

			local cross = makeHub(folder, head, center, 0.2, spinners)
			for i = 0, 3 do                                                    -- перекрестие лучей
				local angle = i * math.pi / 2
				local ray = Instance.new("Part")
				ray.Size = Vector3.new(R * 1.05, 0.02, 0.02)
				ray.CFrame = cross.CFrame * CFrame.Angles(0, angle, 0) * CFrame.new(R * 0.2 + R * 0.525, 0, 0)
				addSpinPart(folder, parts, cross, ray)
			end

		elseif HAT.Style == "Китайская" then
			-- Классическая китайская шляпа: широкий плоский гладкий конус, плотный (не прозрачный),
			-- со светлой кромкой по краю; вокруг неё по наклонным орбитам летают две световые дуги.
			local headCF = head.CFrame
			local radius = HAT.Radius * 1.2
			local rimY = baseY + HAT.Gap * 0.3
			local tip = (headCF * CFrame.new(0, rimY + HAT.Height * 0.55, 0)).Position
			local segments = 36
			for i = 0, segments - 1 do
				local a1 = (i / segments) * math.pi * 2
				local a2 = ((i + 1) / segments) * math.pi * 2
				local p1 = (headCF * CFrame.new(math.cos(a1) * radius, rimY, math.sin(a1) * radius)).Position
				local p2 = (headCF * CFrame.new(math.cos(a2) * radius, rimY, math.sin(a2) * radius)).Position
				local w1, w2 = makeTriangle(tip, p1, p2)
				addHatPart(folder, parts, head, w1)
				addHatPart(folder, parts, head, w2)
			end

			-- две световые дуги-«кометы» на наклонных орбитах вокруг шляпы
			for k, tilt in ipairs({ math.rad(14), math.rad(-22) }) do
				local orbit = makeHub(folder, head, CFrame.new(0, rimY + 0.05, 0) * CFrame.Angles(tilt, 0, math.rad(8 * k)), 3.2 + k * 0.6, spinners)
				local count = 10
				for i = 0, count - 1 do
					local f = i / count
					local angle = f * math.rad(110)
					local thickness = 0.02 + 0.05 * f -- тонкий хвост, яркая голова
					local part = Instance.new("Part")
					part.Name = "Streak"
					part.Size = Vector3.new(thickness, thickness, radius * 1.15 * math.rad(110) / count * 1.1)
					part.CFrame = orbit.CFrame * CFrame.Angles(0, angle + k * math.pi, 0) * CFrame.new(radius * 1.15, 0, 0)
					addSpinPart(folder, parts, orbit, part)
					part:SetAttribute("Streak", true)
				end
			end

		elseif HAT.Style == "Цилиндр" then
			-- тулья
			local top = Instance.new("Part")
			top.Name = "Top"
			top.Shape = Enum.PartType.Cylinder
			top.Size = Vector3.new(HAT.Height, HAT.Radius * 1.3, HAT.Radius * 1.3)
			top.CFrame = head.CFrame * CFrame.new(0, baseY + HAT.Height / 2, 0) * CFrame.Angles(0, 0, math.pi / 2)
			addHatPart(folder, parts, head, top)

			-- поля (брим)
			local brim = Instance.new("Part")
			brim.Name = "Brim"
			brim.Shape = Enum.PartType.Cylinder
			brim.Size = Vector3.new(0.08, HAT.Radius * 2.6, HAT.Radius * 2.6)
			brim.CFrame = head.CFrame * CFrame.new(0, baseY + 0.04, 0) * CFrame.Angles(0, 0, math.pi / 2)
			addHatPart(folder, parts, head, brim)

		else -- "Конус" — полая тонкая стенка из треугольников, приподнята над головой
			local headCF = head.CFrame
			local rimY = baseY + HAT.Gap
			local tip = (headCF * CFrame.new(0, rimY + HAT.Height, 0)).Position

			for i = 0, HAT_SEGMENTS - 1 do
				local angle1 = (i / HAT_SEGMENTS) * math.pi * 2
				local angle2 = ((i + 1) / HAT_SEGMENTS) * math.pi * 2
				local p1 = (headCF * CFrame.new(math.cos(angle1) * HAT.Radius, rimY, math.sin(angle1) * HAT.Radius)).Position
				local p2 = (headCF * CFrame.new(math.cos(angle2) * HAT.Radius, rimY, math.sin(angle2) * HAT.Radius)).Position

				local w1, w2 = makeTriangle(tip, p1, p2)
				addHatPart(folder, parts, head, w1)
				addHatPart(folder, parts, head, w2)
			end
		end

		-- источник света над головой для свечения
		local lightAttachment = Instance.new("Attachment")
		lightAttachment.Name = "ChinaHatLight"
		lightAttachment.Position = Vector3.new(0, baseY + HAT.Gap + HAT.Height / 2, 0)
		lightAttachment.Parent = head

		local light = Instance.new("PointLight")
		light.Shadows = false
		light.Enabled = false
		light.Parent = lightAttachment

		hat = {
			folder = folder,
			parts = parts,
			head = head,
			lightAttachment = lightAttachment,
			light = light,
			radius = HAT.Radius,
			height = HAT.Height,
			style = HAT.Style,
			gap = HAT.Gap,
			spinners = spinners,
			solid = HAT.Style == "Китайская", -- китайская шляпа всегда плотная
		}
	end

	localPlayer.CharacterAdded:Connect(buildHat)
	localPlayer.CharacterRemoving:Connect(destroyHat)
	if localPlayer.Character then
		task.spawn(buildHat, localPlayer.Character)
	end

	RunService.RenderStepped:Connect(function()
		if not hat or not hat.folder.Parent then
			return
		end

		-- если в меню изменили радиус, высоту или форму, собираем шляпу заново
		if hat.radius ~= HAT.Radius or hat.height ~= HAT.Height or hat.style ~= HAT.Style or hat.gap ~= HAT.Gap then
			local character = localPlayer.Character
			if character then
				buildHat(character)
			end
			if not hat then
				return
			end
		end

		local camera = workspace.CurrentCamera
		local firstPerson = camera ~= nil
			and (camera.CFrame.Position - hat.head.Position).Magnitude < HAT.FirstPersonDistance
		local visible = HAT.Enabled and not firstPerson

		local transparency = visible and (hat.solid and 0 or HAT.Transparency) or 1
		local color = HAT.Rainbow and Color3.fromHSV((os.clock() * 0.3) % 1, 0.8, 1) or HAT.Color

		local material = HAT.Glow and Enum.Material.Neon or Enum.Material.SmoothPlastic
		for _, part in ipairs(hat.parts) do
			if part:GetAttribute("Streak") then
				-- световые дуги всегда светятся и чуть прозрачнее
				part.Transparency = visible and 0.25 or 1
				part.Color = color:Lerp(Color3.new(1, 1, 1), 0.5)
				part.Material = Enum.Material.Neon
			else
				part.Transparency = transparency
				if visible then
					part.Color = color
					part.Material = material
				end
			end
		end

		-- вращение слоёв нимба и световых дуг
		local now = os.clock()
		for _, spinner in ipairs(hat.spinners or {}) do
			spinner.motor.C0 = spinner.base * CFrame.Angles(0, now * spinner.speed, 0)
		end

		hat.light.Enabled = visible and HAT.Glow and HAT.GlowStrength > 0
		hat.light.Color = color
		hat.light.Brightness = HAT.GlowStrength
		hat.light.Range = 4 + HAT.GlowStrength * 2
	end)
	return function()
		for _, connection in ipairs(connections) do
			connection:Disconnect()
		end
		destroyHat()
	end
end
RENDERERS.Hat(localPlayer, HAT)

--------------------------------------------------------------------
-- Полоса за персонажем при ходьбе (Trail)
--------------------------------------------------------------------
local TRAIL = {
	Enabled = false,
	Rainbow = false,
	Color = Color3.fromRGB(90, 170, 255),
	Lifetime = 1.5,      -- сколько секунд полоса остаётся за вами
	Height = 3,          -- высота полосы в studs
	Transparency = 0.2,  -- прозрачность у персонажа; к хвосту полоса плавно исчезает
	Glow = true,         -- свечение (без него полоса освещается как обычный предмет)
	GlowStrength = 1.5,  -- яркость свечения (0-5)
	Style = "Лента", -- "Лента", "Крылья", "Линия" или "Комета"
	FirstPersonDistance = 1.5, -- ближе этого расстояния камеры до головы считается видом от первого лица
}

local TRAIL_STYLES = { "Лента", "Крылья", "Линия", "Комета" }

-- Чем отличаются модели полосы:
--   Horizontal — лента идёт слева направо (иначе сверху вниз)
--   FaceCamera — лента всегда повёрнута к камере (у горизонтальной выключено, иначе она выглядит как вертикальная)
--   WidthScale — ширина от персонажа (0) к хвосту (1)
--   WidthFactor — доля от «Высоты полосы»
local TRAIL_STYLE_SETTINGS = {
	["Лента"] = {
		Horizontal = false,
		FaceCamera = true,
		WidthFactor = 1,
		WidthScale = NumberSequence.new(1),
	},
	["Крылья"] = {
		Horizontal = true,
		FaceCamera = false,
		WidthFactor = 1.4,
		WidthScale = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 1),
			NumberSequenceKeypoint.new(1, 0.1),
		}),
	},
	["Линия"] = {
		Horizontal = false,
		FaceCamera = true,
		WidthFactor = 0.12,
		WidthScale = NumberSequence.new(1),
	},
	["Комета"] = {
		Horizontal = false,
		FaceCamera = true,
		WidthFactor = 0.6,
		WidthScale = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 1),
			NumberSequenceKeypoint.new(1, 0),
		}),
	},
}
local trailData = nil -- { trail, a0, a1, wings }

local function destroyTrail()
	if trailData then
		trailData.trail:Destroy()
		trailData.a0:Destroy()
		trailData.a1:Destroy()
		trailData = nil
	end
end

local function buildTrail(character)
	destroyTrail()

	local root = character:WaitForChild("HumanoidRootPart", 5)
	if not root then
		return
	end

	local a0 = Instance.new("Attachment")
	a0.Name = "TrailA"
	a0.Parent = root

	local a1 = Instance.new("Attachment")
	a1.Name = "TrailB"
	a1.Parent = root

	local trail = Instance.new("Trail")
	trail.Name = "MovementTrail"
	trail.Attachment0 = a0
	trail.Attachment1 = a1
	trail.LightEmission = 1
	trail.FaceCamera = true
	trail.Enabled = TRAIL.Enabled
	trail.Parent = root

	trailData = {
		trail = trail,
		a0 = a0,
		a1 = a1,
		head = character:FindFirstChild("Head") or root,
		style = TRAIL.Style,
	}
end

local function rainbowSequence(offset)
	local keypoints = {}
	for i = 0, 6 do
		keypoints[#keypoints + 1] = ColorSequenceKeypoint.new(i / 6, Color3.fromHSV((offset + i / 6) % 1, 0.8, 1))
	end
	return ColorSequence.new(keypoints)
end

localPlayer.CharacterAdded:Connect(buildTrail)
localPlayer.CharacterRemoving:Connect(destroyTrail)
if localPlayer.Character then
	task.spawn(buildTrail, localPlayer.Character)
end

RunService.RenderStepped:Connect(function()
	local data = trailData
	-- если в меню сменили стиль полосы, собираем её заново
	if data and data.style ~= TRAIL.Style then
		local character = localPlayer.Character
		if character then
			buildTrail(character)
		end
		data = trailData
	end
	if not data or not data.trail.Parent then
		return
	end

	local trail = data.trail

	local camera = workspace.CurrentCamera
	local firstPerson = camera ~= nil
		and (camera.CFrame.Position - data.head.Position).Magnitude < TRAIL.FirstPersonDistance

	trail.Enabled = TRAIL.Enabled and not firstPerson
	if not TRAIL.Enabled then
		return
	end

	local style = TRAIL_STYLE_SETTINGS[TRAIL.Style] or TRAIL_STYLE_SETTINGS["Лента"]
	local half = TRAIL.Height * style.WidthFactor / 2
	if style.Horizontal then
		data.a0.Position = Vector3.new(-half, 0, 0)
		data.a1.Position = Vector3.new(half, 0, 0)
	else
		data.a0.Position = Vector3.new(0, half, 0)
		data.a1.Position = Vector3.new(0, -half, 0)
	end
	trail.FaceCamera = style.FaceCamera
	trail.WidthScale = style.WidthScale

	trail.Lifetime = TRAIL.Lifetime
	-- в первом лице прячем и уже нарисованные участки полосы
	trail.Transparency = firstPerson and NumberSequence.new(1) or NumberSequence.new({
		NumberSequenceKeypoint.new(0, TRAIL.Transparency),
		NumberSequenceKeypoint.new(1, 1),
	})
	trail.Color = TRAIL.Rainbow and rainbowSequence(os.clock() * 0.3) or ColorSequence.new(TRAIL.Color)
	trail.LightEmission = TRAIL.Glow and 1 or 0
	trail.LightInfluence = TRAIL.Glow and 0 or 1
	trail.Brightness = TRAIL.Glow and math.max(TRAIL.GlowStrength, 0.1) or 1
end)

--------------------------------------------------------------------
-- Летающие частицы в мире вокруг камеры (видны только вам)
--------------------------------------------------------------------
local PARTICLES = {
	Enabled = false,
	Rainbow = false,
	Color = Color3.fromRGB(255, 255, 255),
	Rate = 60,   -- сколько частиц появляется в секунду
	Size = 0.35, -- размер одной частицы
	Range = 60,  -- размер области вокруг вас (в studs)
	Style = "Искры", -- "Искры", "Снег", "Огоньки", "Дым", "Дождь", "Доллары" или "Двоичный код"
	Glow = true,         -- свечение частиц
	GlowStrength = 1.5,  -- яркость свечения (0-5)
}

local PARTICLE_STYLES = { "Искры", "Снег", "Огоньки", "Дым", "Дождь", "Доллары", "Двоичный код" }

-- Невидимая деталь-излучатель, которая следует за камерой.
-- Появившиеся частицы остаются в мире, поэтому при движении вы пролетаете сквозь них.
local particlePart = Instance.new("Part")
particlePart.Name = "WorldParticles"
particlePart.Anchored = true
particlePart.CanCollide = false
particlePart.CanQuery = false
particlePart.CanTouch = false
particlePart.CastShadow = false
particlePart.Transparency = 1
particlePart.Size = Vector3.new(PARTICLES.Range, PARTICLES.Range / 2, PARTICLES.Range)
particlePart.Parent = workspace

local particleEmitter = Instance.new("ParticleEmitter")
particleEmitter.Shape = Enum.ParticleEmitterShape.Box
particleEmitter.ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume
particleEmitter.Lifetime = NumberRange.new(4, 7)
particleEmitter.Speed = NumberRange.new(0.5, 2)
particleEmitter.SpreadAngle = Vector2.new(180, 180)
particleEmitter.Drag = 0.5
particleEmitter.Rotation = NumberRange.new(0, 360)
particleEmitter.RotSpeed = NumberRange.new(-30, 30)
particleEmitter.LightEmission = 1
particleEmitter.LightInfluence = 0
particleEmitter.Transparency = NumberSequence.new({
	NumberSequenceKeypoint.new(0, 1),
	NumberSequenceKeypoint.new(0.15, 0.2),
	NumberSequenceKeypoint.new(0.85, 0.2),
	NumberSequenceKeypoint.new(1, 1),
})
particleEmitter.Size = NumberSequence.new(PARTICLES.Size)
particleEmitter.Rate = PARTICLES.Rate
particleEmitter.Enabled = false
particleEmitter.Parent = particlePart

local PARTICLE_STYLE_SETTINGS = {
	-- Texture — картинка частицы. Встроенные текстуры Roblox; можно заменить на свою "rbxassetid://...".
	["Искры"] = {
		Texture = "rbxasset://textures/particles/sparkles_main.dds",
		Acceleration = Vector3.new(0, 0, 0),
		Speed = NumberRange.new(0.5, 2),
		SpreadAngle = Vector2.new(180, 180),
		Lifetime = NumberRange.new(2, 4),
		RotSpeed = NumberRange.new(-90, 90),
		LightEmission = 1,
		SizeScale = 1,
		MinTransparency = 0.05,
	},
	["Снег"] = {
		Texture = "rbxasset://textures/particles/smoke_main.dds",
		Acceleration = Vector3.new(0, -4, 0),
		Speed = NumberRange.new(0.2, 0.8),
		SpreadAngle = Vector2.new(25, 25),
		Lifetime = NumberRange.new(5, 9),
		RotSpeed = NumberRange.new(-25, 25),
		LightEmission = 0.2,
		SizeScale = 1.2,
		MinTransparency = 0.1,
	},
	["Огоньки"] = {
		Texture = "rbxasset://textures/particles/fire_main.dds",
		Acceleration = Vector3.new(0, 3, 0),
		Speed = NumberRange.new(0.3, 1),
		SpreadAngle = Vector2.new(30, 30),
		Lifetime = NumberRange.new(3, 6),
		RotSpeed = NumberRange.new(-40, 40),
		LightEmission = 1,
		SizeScale = 1.6,
		MinTransparency = 0.15,
	},
	["Дым"] = {
		Texture = "rbxasset://textures/particles/smoke_main.dds",
		Acceleration = Vector3.new(0, 0.5, 0),
		Speed = NumberRange.new(0.1, 0.4),
		SpreadAngle = Vector2.new(180, 180),
		Lifetime = NumberRange.new(6, 10),
		RotSpeed = NumberRange.new(-10, 10),
		LightEmission = 0,
		SizeScale = 6,
		MinTransparency = 0.7,
	},
}

local lastParticleSize = nil -- пересчитывается при первом кадре
local lastParticleStyle = nil -- какой вид сейчас настроен у излучателя
local lastParticleGlow = nil

RunService.RenderStepped:Connect(function()
	local usesEmitter = PARTICLES.Enabled and PARTICLES.Style ~= "Дождь" and PARTICLES.Style ~= "Доллары"
		and PARTICLES.Style ~= "Двоичный код"

	-- Баг был здесь: при выключении частиц или смене вида уже вылетевшие частицы продолжали висеть
	-- ещё до 10 секунд, а при смене вида они на лету получали новую картинку и размер
	-- (например, дым превращался в огромные искры). Теперь старые частицы сразу убираются.
	local styleNow = usesEmitter and PARTICLES.Style or nil
	if styleNow ~= lastParticleStyle then
		particleEmitter:Clear()
		lastParticleStyle = styleNow
		lastParticleSize = nil
		lastParticleGlow = nil
	end

	particleEmitter.Enabled = usesEmitter
	if not usesEmitter then
		return
	end

	local camera = workspace.CurrentCamera
	if camera then
		particlePart.CFrame = CFrame.new(camera.CFrame.Position)
	end

	local range = PARTICLES.Range
	particlePart.Size = Vector3.new(range, range / 2, range)
	particleEmitter.Rate = PARTICLES.Rate

	local settings = PARTICLE_STYLE_SETTINGS[PARTICLES.Style] or PARTICLE_STYLE_SETTINGS["Искры"]

	local targetSize = PARTICLES.Size * settings.SizeScale
	if targetSize ~= lastParticleSize then
		lastParticleSize = targetSize
		particleEmitter.Size = NumberSequence.new(targetSize)
	end

	local glowKey = tostring(PARTICLES.Glow) .. "/" .. PARTICLES.GlowStrength
	if lastParticleGlow ~= glowKey then
		lastParticleGlow = glowKey
		particleEmitter.Texture = settings.Texture
		particleEmitter.Acceleration = settings.Acceleration
		particleEmitter.Speed = settings.Speed
		particleEmitter.SpreadAngle = settings.SpreadAngle
		particleEmitter.Lifetime = settings.Lifetime
		particleEmitter.RotSpeed = settings.RotSpeed
		-- со свечением частицы светятся сами, без него — освещаются как обычные предметы
		particleEmitter.LightEmission = PARTICLES.Glow and math.max(settings.LightEmission, 0.7) or 0
		particleEmitter.LightInfluence = PARTICLES.Glow and 0 or 1
		particleEmitter.Brightness = PARTICLES.Glow and math.max(PARTICLES.GlowStrength, 0.1) or 1
		particleEmitter.Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 1),
			NumberSequenceKeypoint.new(0.15, settings.MinTransparency),
			NumberSequenceKeypoint.new(0.85, settings.MinTransparency),
			NumberSequenceKeypoint.new(1, 1),
		})
	end

	particleEmitter.Color = PARTICLES.Rainbow and rainbowSequence(os.clock() * 0.3)
		or ColorSequence.new(PARTICLES.Color)
end)

-- Дождь: вытянутые капли-штрихи падают вокруг камеры и разбиваются о землю брызгами.
-- Обычный излучатель частиц не умеет надёжно рисовать вытянутые капли, поэтому они сделаны деталями.
do
	local rainFolder = Instance.new("Folder")
	rainFolder.Name = "Rain_Local"
	rainFolder.Parent = workspace

	local splashPart = Instance.new("Part")
	splashPart.Anchored = true
	splashPart.CanCollide = false
	splashPart.CanQuery = false
	splashPart.CanTouch = false
	splashPart.Transparency = 1
	splashPart.Size = Vector3.new(0.2, 0.2, 0.2)
	splashPart.Parent = rainFolder

	local splash = Instance.new("ParticleEmitter")
	splash.Enabled = false
	splash.Lifetime = NumberRange.new(0.15, 0.3)
	splash.Speed = NumberRange.new(3, 6)
	splash.SpreadAngle = Vector2.new(60, 60)
	splash.EmissionDirection = Enum.NormalId.Top
	splash.Acceleration = Vector3.new(0, -40, 0)
	splash.Size = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.12),
		NumberSequenceKeypoint.new(1, 0),
	})
	splash.Transparency = NumberSequence.new(0.3, 1)
	splash.Parent = splashPart

	local WIND = Vector3.new(6, 0, 3)
	local drops = {}
	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Exclude

	local function clearRain()
		for _, drop in ipairs(drops) do
			drop.part:Destroy()
		end
		table.clear(drops)
	end

	-- ставит каплю в случайную точку над камерой и заранее находит землю под ней
	local function resetDrop(drop, cameraPosition, fromTop)
		local range = PARTICLES.Range
		local x = cameraPosition.X + (math.random() - 0.5) * range
		local z = cameraPosition.Z + (math.random() - 0.5) * range
		local top = cameraPosition.Y + 30
		local y = fromTop and (top - math.random() * 6) or (cameraPosition.Y - 20 + math.random() * 50)

		params.FilterDescendantsInstances = { rainFolder, localPlayer.Character }
		local hit = workspace:Raycast(Vector3.new(x, top + 5, z), Vector3.new(0, -90, 0), params)
		drop.groundY = hit and hit.Position.Y or (cameraPosition.Y - 25)
		drop.position = Vector3.new(x, math.max(y, drop.groundY + 1), z)
		drop.speed = 60 + math.random() * 25
	end

	RunService.RenderStepped:Connect(function(dt)
		local camera = workspace.CurrentCamera
		if not (PARTICLES.Enabled and PARTICLES.Style == "Дождь") or not camera then
			if #drops > 0 then
				clearRain()
			end
			return
		end

		local cameraPosition = camera.CFrame.Position
		local count = math.clamp(math.floor(PARTICLES.Rate * 2), 20, 400)

		-- подгоняем число капель под настройку «Кол-во частиц»
		while #drops < count do
			local part = Instance.new("Part")
			part.Anchored = true
			part.CanCollide = false
			part.CanQuery = false
			part.CanTouch = false
			part.CastShadow = false
			part.Parent = rainFolder
			local drop = { part = part }
			resetDrop(drop, cameraPosition, false)
			table.insert(drops, drop)
		end
		while #drops > count do
			table.remove(drops).part:Destroy()
		end

		local color = PARTICLES.Rainbow and Color3.fromHSV((os.clock() * 0.3) % 1, 0.6, 1) or PARTICLES.Color
		local material = PARTICLES.Glow and Enum.Material.Neon or Enum.Material.SmoothPlastic
		local length = 0.8 + PARTICLES.Size * 4
		local thickness = 0.04 + PARTICLES.Size * 0.08
		local halfRange = PARTICLES.Range * 0.6
		splash.Color = ColorSequence.new(color)

		for _, drop in ipairs(drops) do
			local velocity = Vector3.new(WIND.X, -drop.speed, WIND.Z)
			drop.position += velocity * dt

			local offset = drop.position - cameraPosition
			if drop.position.Y <= drop.groundY then
				-- капля долетела до земли: брызги и новая капля сверху
				splashPart.CFrame = CFrame.new(drop.position.X, drop.groundY + 0.05, drop.position.Z)
				splash:Emit(2)
				resetDrop(drop, cameraPosition, true)
			elseif math.abs(offset.X) > halfRange or math.abs(offset.Z) > halfRange or offset.Y < -30 then
				-- вы ушли далеко от капли — переносим её к себе
				resetDrop(drop, cameraPosition, true)
			end

			local part = drop.part
			part.Size = Vector3.new(thickness, thickness, length)
			part.CFrame = CFrame.lookAt(drop.position, drop.position + velocity, Vector3.xAxis)
			part.Color = color
			part.Material = material
			part.Transparency = 0.35
		end
	end)
end

-- Доллары: купюры со знаком «$» парят вокруг камеры с той же «физикой», что и искры:
-- разлетаются в случайные стороны, медленно тормозят, кружатся, появляются и тают.
-- Картинки купюры среди встроенных текстур Roblox нет, поэтому купюры сделаны деталями с надписью «$».
do
	local MONEY_GREEN = Color3.fromRGB(96, 178, 104)
	local INK_GREEN = Color3.fromRGB(28, 92, 44)

	local dollarFolder = Instance.new("Folder")
	dollarFolder.Name = "Dollars_Local"
	dollarFolder.Parent = workspace

	local bills = {}

	local function clearBills()
		for _, bill in ipairs(bills) do
			bill.part:Destroy()
		end
		table.clear(bills)
	end

	local function makeBill()
		local part = Instance.new("Part")
		part.Anchored = true
		part.CanCollide = false
		part.CanQuery = false
		part.CanTouch = false
		part.CastShadow = false
		part.Material = Enum.Material.SmoothPlastic
		part.Parent = dollarFolder

		local labels = {}
		for _, face in ipairs({ Enum.NormalId.Front, Enum.NormalId.Back }) do
			local gui = Instance.new("SurfaceGui")
			gui.Face = face
			gui.CanvasSize = Vector2.new(100, 46)
			gui.LightInfluence = 1
			gui.Parent = part

			local label = Instance.new("TextLabel")
			label.Size = UDim2.fromScale(1, 1)
			label.BackgroundTransparency = 1
			label.Font = Enum.Font.GothamBlack
			label.TextScaled = true
			label.TextColor3 = INK_GREEN
			label.Text = "$"
			label.Parent = gui

			-- рамка купюры
			local border = Instance.new("UIStroke")
			border.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
			border.Color = INK_GREEN
			border.Thickness = 3
			border.Transparency = 0.3
			border.Parent = label

			table.insert(labels, { label = label, border = border })
		end
		return { part = part, labels = labels }
	end

	-- новая купюра: случайная точка в области вокруг камеры, случайное направление и вращение
	local function resetBill(bill, cameraPosition)
		local range = PARTICLES.Range
		bill.position = cameraPosition + Vector3.new(
			(math.random() - 0.5) * range,
			(math.random() - 0.5) * range * 0.5,
			(math.random() - 0.5) * range
		)
		local direction = Vector3.new(math.random() - 0.5, math.random() - 0.5, math.random() - 0.5)
		direction = direction.Magnitude > 0.01 and direction.Unit or Vector3.yAxis
		bill.velocity = direction * (0.5 + math.random() * 1.5)
		bill.rotation = CFrame.Angles(math.random() * math.pi * 2, math.random() * math.pi * 2, math.random() * math.pi * 2)
		bill.spin = Vector3.new(math.random() - 0.5, math.random() - 0.5, math.random() - 0.5) * 3
		bill.age = 0
		bill.lifetime = 2 + math.random() * 2
	end

	RunService.RenderStepped:Connect(function(dt)
		local camera = workspace.CurrentCamera
		if not (PARTICLES.Enabled and PARTICLES.Style == "Доллары") or not camera then
			if #bills > 0 then
				clearBills()
			end
			return
		end

		local cameraPosition = camera.CFrame.Position
		local count = math.clamp(math.floor(PARTICLES.Rate), 5, 150)
		while #bills < count do
			local bill = makeBill()
			resetBill(bill, cameraPosition)
			bill.age = math.random() * bill.lifetime -- чтобы купюры не появились все разом
			table.insert(bills, bill)
		end
		while #bills > count do
			table.remove(bills).part:Destroy()
		end

		local scale = 0.5 + PARTICLES.Size * 2
		local size = Vector3.new(1 * scale, 0.46 * scale, 0.02)
		local color = PARTICLES.Rainbow and Color3.fromHSV((os.clock() * 0.3) % 1, 0.6, 1) or MONEY_GREEN
		local material = PARTICLES.Glow and Enum.Material.Neon or Enum.Material.SmoothPlastic
		local drag = math.exp(-0.5 * dt) -- плавное торможение, как у искр

		for _, bill in ipairs(bills) do
			bill.age += dt
			if bill.age >= bill.lifetime then
				resetBill(bill, cameraPosition)
			end

			bill.velocity *= drag
			bill.position += bill.velocity * dt
			bill.rotation *= CFrame.Angles(bill.spin.X * dt, bill.spin.Y * dt, bill.spin.Z * dt)

			-- появляется и тает, как искра
			local t = bill.age / bill.lifetime
			local fade = 1
			if t < 0.15 then
				fade = t / 0.15
			elseif t > 0.85 then
				fade = (1 - t) / 0.15
			end
			local transparency = 1 - fade * 0.95

			local part = bill.part
			part.Size = size
			part.CFrame = CFrame.new(bill.position) * bill.rotation
			part.Color = color
			part.Material = material
			part.Transparency = transparency
			for _, face in ipairs(bill.labels) do
				face.label.TextTransparency = transparency
				face.border.Transparency = math.max(transparency, 0.3)
			end
		end
	end)
end

-- Двоичный код: вокруг вас сверху вниз «стекают» столбцы из нулей и единиц, как в «Матрице».
-- Каждая цифра раз в секунду меняется 0 ↔ 1 (у каждой — свой момент смены, поэтому код «живой»).
-- Верхняя цифра столбца — самая яркая, к хвосту столбец тает. Цифры — это надписи в мире
-- (BillboardGui на точках крепления одной невидимой детали), поэтому всегда повёрнуты к вам.
do
	local DIGITS_PER_COLUMN = 9

	local codeFolder = Instance.new("Folder")
	codeFolder.Name = "BinaryCode_Local"
	codeFolder.Parent = workspace

	local holder = Instance.new("Part")
	holder.Anchored = true
	holder.CanCollide = false
	holder.CanQuery = false
	holder.CanTouch = false
	holder.Transparency = 1
	holder.Size = Vector3.new(0.1, 0.1, 0.1)
	holder.CFrame = CFrame.new()
	holder.Parent = codeFolder

	local columns = {}

	local function destroyColumn(column)
		for _, digit in ipairs(column.digits) do
			digit.attachment:Destroy()
		end
	end

	local function resetColumn(column, cameraPosition, fromTop)
		local range = PARTICLES.Range
		column.x = cameraPosition.X + (math.random() - 0.5) * range
		column.z = cameraPosition.Z + (math.random() - 0.5) * range
		column.y = fromTop and (cameraPosition.Y + 18 + math.random() * 10)
			or (cameraPosition.Y - 10 + math.random() * 35)
		column.speed = 5 + math.random() * 7
	end

	local function newColumn(cameraPosition)
		local column = { digits = {} }
		for i = 1, DIGITS_PER_COLUMN do
			local attachment = Instance.new("Attachment")
			attachment.Parent = holder
			local billboard = Instance.new("BillboardGui")
			billboard.Adornee = attachment
			billboard.LightInfluence = 0
			billboard.MaxDistance = 300
			billboard.Parent = attachment
			local label = Instance.new("TextLabel")
			label.Size = UDim2.fromScale(1, 1)
			label.BackgroundTransparency = 1
			label.Font = Enum.Font.Arcade -- пиксельный шрифт
			label.TextScaled = true
			label.TextStrokeColor3 = Color3.new(0, 0, 0) -- чёрная обводка
			label.Text = math.random() < 0.5 and "0" or "1"
			label.Parent = billboard
			table.insert(column.digits, {
				attachment = attachment,
				billboard = billboard,
				label = label,
				phase = math.random(), -- своя секунда смены цифры
			})
		end
		resetColumn(column, cameraPosition, false)
		return column
	end

	RunService.RenderStepped:Connect(function(dt)
		local camera = workspace.CurrentCamera
		if not (PARTICLES.Enabled and PARTICLES.Style == "Двоичный код") or not camera then
			if #columns > 0 then
				for _, column in ipairs(columns) do
					destroyColumn(column)
				end
				table.clear(columns)
			end
			return
		end

		local cameraPosition = camera.CFrame.Position
		local count = math.clamp(math.floor(PARTICLES.Rate / 3), 6, 40)
		while #columns < count do
			table.insert(columns, newColumn(cameraPosition))
		end
		while #columns > count do
			destroyColumn(table.remove(columns))
		end

		local now = os.clock()
		local color = PARTICLES.Rainbow and Color3.fromHSV((now * 0.3) % 1, 0.7, 1) or PARTICLES.Color
		local digitSize = 0.5 + PARTICLES.Size * 1.6 -- размер цифры в studs
		local spacing = digitSize * 1.15
		local halfRange = PARTICLES.Range * 0.6

		for _, column in ipairs(columns) do
			column.y -= column.speed * dt
			local offset = Vector3.new(column.x - cameraPosition.X, 0, column.z - cameraPosition.Z)
			-- упал ниже камеры или вы ушли далеко — столбец начинается заново сверху
			if column.y < cameraPosition.Y - 25 or math.abs(offset.X) > halfRange or math.abs(offset.Z) > halfRange then
				resetColumn(column, cameraPosition, true)
			end

			for i, digit in ipairs(column.digits) do
				-- первая цифра — «голова» столбца (внизу, самая яркая), остальные тянутся хвостом вверх
				local position = Vector3.new(column.x, column.y + (i - 1) * spacing, column.z)
				digit.attachment.WorldPosition = position
				digit.billboard.Size = UDim2.new(digitSize * 0.7, 0, digitSize, 0)

				-- раз в секунду цифра меняется 0 ↔ 1
				local tick = math.floor(now + digit.phase)
				if tick ~= digit.lastTick then
					digit.lastTick = tick
					digit.label.Text = (digit.label.Text == "0") and "1" or "0"
				end

				local fade = (i - 1) / DIGITS_PER_COLUMN
				digit.label.TextColor3 = i == 1 and color:Lerp(Color3.new(1, 1, 1), 0.6) or color
				local transparency = math.clamp(0.05 + fade * 0.85, 0, 1)
				digit.label.TextTransparency = transparency
				-- чёрная обводка тает вместе с цифрой (чуть плотнее самой цифры, чтобы контур читался)
				digit.label.TextStrokeTransparency = math.clamp(transparency * 0.9, 0, 1)
			end
		end
	end)
end

local CONSTELLATIONS = {
	Enabled = false,
	Count = 30,                                   -- сколько созвездий по всему небу
	Size = 0.35,                                  -- размер фигур и звёзд
	Speed = 1,                                    -- как быстро плывут по небу
	Color = Color3.fromRGB(150, 185, 255),        -- небесный, как на видео
	Rainbow = false,
	Glow = true,
}

-- Созвездия: в небе вокруг вас появляются созвездия. Звёзды загораются одна за другой,
-- между ними «прочерчиваются» линии, звёзды мерцают, фигура медленно поворачивается,
-- потом гаснет — и в другом месте неба появляется новое созвездие.
-- Чтобы они были частью неба, а не «наклейкой» на экране:
--   • они очень далеко (за горами и домами) — всё в мире закрывает их, как настоящее небо;
--   • у каждой звезды мягкий ореол, линии тонкие и полупрозрачные;
--   • небо медленно «вращается»: созвездия плывут по кругу, как звёзды за ночь;
--   • у горизонта они тают в дымке, а днём еле заметны и проступают к ночи.
do
	local Lighting = game:GetService("Lighting") -- нужен для времени суток (объявлен в файле ниже)
	local PATTERNS = {
		-- Большой Ковш
		{ stars = { { -1, 0.3 }, { -0.6, 0.36 }, { -0.25, 0.2 }, { 0.1, 0.1 }, { 0.2, -0.3 }, { 0.75, -0.35 }, { 0.8, 0.05 } },
			lines = { { 1, 2 }, { 2, 3 }, { 3, 4 }, { 4, 5 }, { 5, 6 }, { 6, 7 }, { 7, 4 } } },
		-- Кассиопея
		{ stars = { { -1, 0.2 }, { -0.5, -0.3 }, { 0, 0.1 }, { 0.45, -0.35 }, { 1, 0.15 } },
			lines = { { 1, 2 }, { 2, 3 }, { 3, 4 }, { 4, 5 } } },
		-- Орион
		{ stars = { { -0.5, 0.9 }, { 0.55, 0.8 }, { -0.14, 0.05 }, { 0, 0 }, { 0.14, -0.05 }, { -0.55, -0.85 }, { 0.6, -0.8 } },
			lines = { { 1, 3 }, { 2, 5 }, { 3, 4 }, { 4, 5 }, { 3, 6 }, { 5, 7 } } },
		-- Лебедь
		{ stars = { { 0, 1 }, { 0, 0.3 }, { 0, -0.3 }, { 0, -1 }, { -0.8, 0.35 }, { 0.8, 0.25 } },
			lines = { { 1, 2 }, { 2, 3 }, { 3, 4 }, { 5, 2 }, { 2, 6 } } },
		-- Лира
		{ stars = { { 0, 0.9 }, { -0.25, 0.35 }, { 0.25, 0.4 }, { -0.35, -0.5 }, { 0.2, -0.45 } },
			lines = { { 1, 2 }, { 1, 3 }, { 2, 3 }, { 2, 4 }, { 3, 5 }, { 4, 5 } } },
		-- Скорпион
		{ stars = { { -0.9, 0.8 }, { -0.6, 0.5 }, { -0.4, 0.15 }, { -0.1, -0.2 }, { 0.2, -0.5 }, { 0.55, -0.6 }, { 0.8, -0.4 }, { 0.85, -0.1 } },
			lines = { { 1, 2 }, { 2, 3 }, { 3, 4 }, { 4, 5 }, { 5, 6 }, { 6, 7 }, { 7, 8 } } },
		-- Треугольник
		{ stars = { { -0.9, 0.7 }, { 0.6, -0.4 }, { -0.3, -0.45 } },
			lines = { { 1, 2 }, { 2, 3 }, { 3, 1 } } },
		-- Лев
		{ stars = { { -0.9, -0.3 }, { -0.4, -0.1 }, { -0.1, 0.4 }, { 0.2, 0.7 }, { 0.55, 0.5 }, { 0.4, 0.0 }, { 0.9, -0.35 } },
			lines = { { 1, 2 }, { 2, 3 }, { 3, 4 }, { 4, 5 }, { 3, 6 }, { 2, 6 }, { 6, 7 } } },
	}

	local SKY_DISTANCE = 900
	local K = SKY_DISTANCE / 70 -- размеры растут вместе с расстоянием, чтобы на экране фигуры были прежней величины
	local SKY_ROTATION = 0.035  -- радиан в секунду: вращение неба (созвездия плывут по кругу)

	local starFolder = Instance.new("Folder")
	starFolder.Name = "Constellations_Local"
	starFolder.Parent = workspace

	local constellations = {}

	local function newPart(shape)
		local part = Instance.new("Part")
		part.Shape = shape
		part.Anchored = true
		part.CanCollide = false
		part.CanQuery = false
		part.CanTouch = false
		part.CastShadow = false
		part.Material = Enum.Material.Neon
		part.Transparency = 1
		part.Parent = starFolder
		return part
	end

	local function destroyConstellation(c)
		for _, star in ipairs(c.stars) do
			star.part:Destroy()
			star.halo:Destroy()
		end
		for _, line in ipairs(c.lines) do
			line.part:Destroy()
		end
	end

	local function spawnConstellation(stagger)
		local pattern = PATTERNS[math.random(1, #PATTERNS)]
		-- случайное место на небе: любой азимут, над горизонтом
		local azimuth = math.random() * math.pi * 2
		local elevation = math.rad(1.5 + math.random() ^ 1.4 * 40) -- чаще ниже, у горизонта
		local direction = Vector3.new(
			math.cos(elevation) * math.cos(azimuth),
			math.sin(elevation),
			math.cos(elevation) * math.sin(azimuth)
		)
		local scale = (1.8 + math.random() * 1.4) * (0.6 + CONSTELLATIONS.Size * 1.2) * K
		local c = {
			azimuth = azimuth,
			elevation = elevation,
			direction = direction,
			scale = scale,
			rotation = math.random() * math.pi * 2,
			spin = (math.random() - 0.5) * 0.16,
			azimuthSpeed = SKY_ROTATION * (0.6 + math.random() * 0.9),
			elevationSpeed = (math.random() - 0.5) * 0.012,
			start = os.clock() - (stagger or 0),
			life = 10 + math.random() * 4,
			stars = {},
			lines = {},
		}
		for i, point in ipairs(pattern.stars) do
			table.insert(c.stars, {
				part = newPart(Enum.PartType.Ball),
				halo = newPart(Enum.PartType.Ball),
				x = point[1],
				y = point[2],
				size = 0.2 + math.random() * 0.14,
				twinkle = math.random() * math.pi * 2,
				appear = 0.2 * (i - 1), -- звёзды загораются по очереди
			})
		end
		for j, pair in ipairs(pattern.lines) do
			table.insert(c.lines, {
				part = newPart(Enum.PartType.Block),
				from = pair[1],
				to = pair[2],
				draw = 1.2 + 0.3 * (j - 1), -- линии прочерчиваются по очереди после звёзд
			})
		end
		table.insert(constellations, c)
	end

	RunService.RenderStepped:Connect(function()
		local camera = workspace.CurrentCamera
		if not CONSTELLATIONS.Enabled or not camera then
			if #constellations > 0 then
				for _, c in ipairs(constellations) do
					destroyConstellation(c)
				end
				table.clear(constellations)
			end
			return
		end

		local now = os.clock()
		local count = math.clamp(math.floor(CONSTELLATIONS.Count), 1, 40)
		while #constellations < count do
			-- первые созвездия стартуют вразнобой, чтобы не загорались одновременно
			spawnConstellation(#constellations * 0.35)
		end
		while #constellations > count do
			destroyConstellation(table.remove(constellations))
		end

		local cameraPosition = camera.CFrame.Position
		local color = CONSTELLATIONS.Rainbow and Color3.fromHSV((now * 0.15) % 1, 0.5, 1) or CONSTELLATIONS.Color

		-- днём звёзды еле видны, к сумеркам проступают, ночью — в полную силу
		local clock = Lighting.ClockTime
		local night
		if clock < 5 or clock > 19.5 then
			night = 1
		elseif clock < 7 then
			night = 1 - (clock - 5) / 2 * 0.75
		elseif clock > 17.5 then
			night = 0.25 + (clock - 17.5) / 2 * 0.75
		else
			night = 0.25
		end
		local material = CONSTELLATIONS.Glow and Enum.Material.Neon or Enum.Material.SmoothPlastic
		local lineColor = color:Lerp(Color3.fromRGB(110, 150, 255), 0.45)

		for index = #constellations, 1, -1 do
			local c = constellations[index]
			local t = now - c.start
			if t >= c.life then
				destroyConstellation(c)
				table.remove(constellations, index)
				spawnConstellation(0)
			else
				-- небо медленно вращается: созвездие плывёт по кругу на своей высоте
				local azimuth = c.azimuth + (t * c.azimuthSpeed + now * SKY_ROTATION * 0.3) * CONSTELLATIONS.Speed
				local elevation = math.clamp(c.elevation + t * c.elevationSpeed, math.rad(1), math.rad(50))
				local direction = Vector3.new(
					math.cos(elevation) * math.cos(azimuth),
					math.sin(elevation),
					math.cos(elevation) * math.sin(azimuth)
				)
				-- плавное появление/исчезновение, дымка у горизонта и время суток
				local horizon = math.clamp((math.deg(elevation) - 0.5) / 3, 0, 1)
				local fade = math.clamp((c.life - t) / 1.6, 0, 1) * horizon * night
				local center = cameraPosition + direction * SKY_DISTANCE
				local plane = CFrame.lookAt(center, cameraPosition) * CFrame.Angles(0, 0, c.rotation + c.spin * t * CONSTELLATIONS.Speed)

				local positions = {}
				for i, star in ipairs(c.stars) do
					local position = (plane * CFrame.new(star.x * c.scale, star.y * c.scale, 0)).Position
					positions[i] = position
					local shown = math.clamp((t - star.appear) / 0.4, 0, 1) * fade
					local twinkle = 0.75 + 0.25 * math.sin(now * 3 + star.twinkle)
					local size = star.size * (0.6 + CONSTELLATIONS.Size) * (0.85 + 0.3 * twinkle) * K
					star.part.Size = Vector3.one * size
					star.part.CFrame = CFrame.new(position)
					star.part.Color = color
					star.part.Material = material
					star.part.Transparency = 1 - shown * twinkle
					-- мягкий ореол вокруг звезды: больше и намного прозрачнее ядра
					star.halo.Size = Vector3.one * size * 3.2
					star.halo.CFrame = CFrame.new(position)
					star.halo.Color = color:Lerp(Color3.fromRGB(150, 175, 255), 0.5)
					star.halo.Material = Enum.Material.Neon
					star.halo.Transparency = 1 - shown * twinkle * 0.12
				end

				for _, line in ipairs(c.lines) do
					local progress = math.clamp((t - line.draw) / 0.5, 0, 1)
					local a, b = positions[line.from], positions[line.to]
					local tip = a + (b - a) * progress -- линия «прорисовывается» от звезды к звезде
					local length = (tip - a).Magnitude
					if progress > 0 and length > 0.01 then
						local middle = (a + tip) / 2
						local thickness = 0.09 * (0.6 + CONSTELLATIONS.Size) * K
						line.part.Size = Vector3.new(thickness, thickness, length)
						line.part.CFrame = CFrame.lookAt(middle, tip)
						line.part.Color = lineColor
						line.part.Material = material
						line.part.Transparency = 1 - 0.45 * fade -- линии тоньше и прозрачнее звёзд
					else
						line.part.Transparency = 1
					end
				end
			end
		end
	end)
end

--------------------------------------------------------------------
-- Туман (меняется только у вас на экране)
--------------------------------------------------------------------
local Lighting = game:GetService("Lighting")

local FOG = {
	Enabled = false,
	Rainbow = false,
	Start = 0,    -- с какого расстояния начинается туман
	End = 200,    -- на каком расстоянии туман полностью скрывает мир
	Color = Color3.fromRGB(180, 190, 210), -- цвет тумана (выбирается в меню)
	Glow = false,       -- свечение всей картинки (Bloom), пока туман включён
	GlowStrength = 2,   -- сила свечения (0-5)
}

local fogOriginal = nil -- сохранённые настройки игры, чтобы вернуть их при выключении

-- локальный Bloom: светлые и неоновые объекты начинают «светиться ореолом»
local fogBloom = Instance.new("BloomEffect")
fogBloom.Name = "JustVisualsBloom"
fogBloom.Size = 30
fogBloom.Threshold = 0.85
fogBloom.Enabled = false
fogBloom.Parent = Lighting

RunService.RenderStepped:Connect(function()
	if FOG.Enabled then
		if not fogOriginal then
			fogOriginal = {
				start = Lighting.FogStart,
				finish = Lighting.FogEnd,
				color = Lighting.FogColor,
				atmosphere = Lighting:FindFirstChildOfClass("Atmosphere"),
			}
			-- Atmosphere перекрывает обычный туман Lighting, поэтому на время убираем её (только у вас)
			if fogOriginal.atmosphere then
				fogOriginal.atmosphere.Parent = nil
			end
		end

		Lighting.FogStart = FOG.Start
		Lighting.FogEnd = math.max(FOG.End, FOG.Start + 1)
		Lighting.FogColor = FOG.Rainbow and Color3.fromHSV((os.clock() * 0.1) % 1, 0.5, 1)
			or FOG.Color

		fogBloom.Enabled = FOG.Glow and FOG.GlowStrength > 0
		fogBloom.Intensity = FOG.GlowStrength * 0.3
		return
	end

	fogBloom.Enabled = false
	if fogOriginal then
		Lighting.FogStart = fogOriginal.start
		Lighting.FogEnd = fogOriginal.finish
		Lighting.FogColor = fogOriginal.color
		if fogOriginal.atmosphere then
			if fogOriginal.atmosphere:GetAttribute("JustVisualsActive") ~= false then
				fogOriginal.atmosphere.Parent = Lighting
			end
		end
		fogOriginal = nil
	end
end)

--------------------------------------------------------------------
-- Jump Circle: эффект на земле при прыжке / приземлении (виден только вам)
--------------------------------------------------------------------
local JUMP_CIRCLE, JUMP_CIRCLE_TRIGGERS, JUMP_CIRCLE_STYLES
do
	JUMP_CIRCLE = {
		Enabled = false,
		Style = "Кольцо",  -- см. JUMP_CIRCLE_STYLES
		Rainbow = false,
		Color = Color3.fromRGB(255, 255, 255),
		Trigger = "Приземление", -- "Приземление", "Прыжок" или "Оба"
		Radius = 4,        -- до какого радиуса расходится эффект (studs)
		Duration = 0.6,    -- сколько секунд живёт эффект
		Thickness = 0.2,   -- толщина линий
		Glow = true,       -- свечение: неон + вспышка света
		GlowStrength = 2,  -- сила свечения (0-5)
	}

	JUMP_CIRCLE_TRIGGERS = { "Приземление", "Прыжок", "Оба" }
	JUMP_CIRCLE_STYLES = { "Кольцо", "Двойное", "Пунктир", "Шестиугольник", "Лучи", "Волна", "Искры" }

	local RING_SEGMENTS = 32

	local circlesFolder = Instance.new("Folder")
	circlesFolder.Name = "JumpCircles"
	circlesFolder.Parent = workspace

	local activeCircles = {}

	local function newPart(circle, shape)
		local part = Instance.new("Part")
		part.Anchored = true
		part.CanCollide = false
		part.CanQuery = false
		part.CanTouch = false
		part.CastShadow = false
		part.Material = JUMP_CIRCLE.Glow and Enum.Material.Neon or Enum.Material.SmoothPlastic
		part.Color = JUMP_CIRCLE.Color
		part.Size = Vector3.new(0.1, 0.05, 0.1)
		part.CFrame = CFrame.new(circle.center)
		if shape then
			part.Shape = shape
		end
		part.Parent = circlesFolder
		table.insert(circle.all, part)
		return part
	end

	local function newGroup(circle, count)
		local group = {}
		for i = 1, count do
			group[i] = newPart(circle)
		end
		return group
	end

	-- кладёт группу деталей по окружности: fill < 1 даёт промежутки (пунктир)
	local function layRing(group, center, radius, thickness, transparency, rotation, fill)
		local count = #group
		local length = 2 * math.pi * radius / count * (fill or 1.1)
		for i, part in ipairs(group) do
			local angle = (i - 1) / count * math.pi * 2 + (rotation or 0)
			part.Size = Vector3.new(thickness, 0.05, math.max(length, 0.05))
			part.CFrame = CFrame.new(center) * CFrame.Angles(0, angle, 0) * CFrame.new(radius, 0, 0)
			part.Transparency = transparency
		end
	end

	local function spawnJumpCircle(character)
		local root = character:FindFirstChild("HumanoidRootPart")
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		if not root or not humanoid then
			return
		end

		-- ищем землю под ногами
		local params = RaycastParams.new()
		params.FilterType = Enum.RaycastFilterType.Exclude
		params.FilterDescendantsInstances = { character, circlesFolder }
		local result = workspace:Raycast(root.Position, Vector3.new(0, -12, 0), params)
		local groundY = result and result.Position.Y
			or (root.Position.Y - humanoid.HipHeight - root.Size.Y / 2)

		local circle = {
			style = JUMP_CIRCLE.Style,
			center = Vector3.new(root.Position.X, groundY + 0.05, root.Position.Z),
			start = os.clock(),
			radius = JUMP_CIRCLE.Radius,
			duration = JUMP_CIRCLE.Duration,
			thickness = JUMP_CIRCLE.Thickness,
			rainbow = JUMP_CIRCLE.Rainbow,
			glowStrength = JUMP_CIRCLE.GlowStrength,
			spin = (math.random() < 0.5 and -1 or 1),
			all = {},
		}

		local style = circle.style
		if style == "Двойное" then
			circle.ringA = newGroup(circle, RING_SEGMENTS)
			circle.ringB = newGroup(circle, RING_SEGMENTS)
		elseif style == "Пунктир" then
			circle.ringA = newGroup(circle, 16)
		elseif style == "Шестиугольник" then
			circle.ringA = newGroup(circle, 6)
			circle.ringB = newGroup(circle, 6)
		elseif style == "Лучи" then
			circle.rays = newGroup(circle, 12)
		elseif style == "Волна" then
			-- плоский диск, который расширяется и тает, и тонкий край
			circle.disk = newPart(circle, Enum.PartType.Cylinder)
			circle.ringA = newGroup(circle, RING_SEGMENTS)
		else -- "Кольцо" и "Искры"
			circle.ringA = newGroup(circle, RING_SEGMENTS)
		end

		if style == "Искры" then
			local holder = newPart(circle)
			holder.Transparency = 1
			holder.CFrame = CFrame.new(circle.center + Vector3.new(0, 0.2, 0))
			local emitter = Instance.new("ParticleEmitter")
			emitter.Texture = "rbxasset://textures/particles/sparkles_main.dds"
			emitter.Enabled = false
			emitter.Color = ColorSequence.new(JUMP_CIRCLE.Color)
			emitter.LightEmission = 1
			emitter.LightInfluence = 0
			emitter.Lifetime = NumberRange.new(0.35, 0.6)
			emitter.Speed = NumberRange.new(10, 18)
			emitter.SpreadAngle = Vector2.new(70, 70)
			emitter.EmissionDirection = Enum.NormalId.Top
			emitter.Acceleration = Vector3.new(0, -25, 0)
			emitter.Drag = 2
			emitter.Size = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 0.35),
				NumberSequenceKeypoint.new(1, 0),
			})
			emitter.Parent = holder
			emitter:Emit(26)
		end

		-- вспышка света в центре (гаснет вместе с эффектом)
		if JUMP_CIRCLE.Glow and JUMP_CIRCLE.GlowStrength > 0 then
			local lightPart = newPart(circle)
			lightPart.Transparency = 1
			lightPart.CFrame = CFrame.new(circle.center + Vector3.new(0, 0.5, 0))
			local light = Instance.new("PointLight")
			light.Shadows = false
			light.Color = JUMP_CIRCLE.Color
			light.Parent = lightPart
			circle.light = light
		end

		table.insert(activeCircles, circle)
	end

	local lastJumpCircle = 0

	local function hookJumpCircle(character)
		local humanoid = character:WaitForChild("Humanoid", 5)
		if not humanoid then
			return
		end

		humanoid.StateChanged:Connect(function(_, newState)
			if not JUMP_CIRCLE.Enabled then
				return
			end

			local trigger = JUMP_CIRCLE.Trigger
			local onLand = newState == Enum.HumanoidStateType.Landed and trigger ~= "Прыжок"
			local onJump = newState == Enum.HumanoidStateType.Jumping and trigger ~= "Приземление"
			if not (onLand or onJump) then
				return
			end

			-- защита от двойного срабатывания за один кадр
			if os.clock() - lastJumpCircle < 0.1 then
				return
			end
			lastJumpCircle = os.clock()

			spawnJumpCircle(character)
		end)
	end

	localPlayer.CharacterAdded:Connect(hookJumpCircle)
	if localPlayer.Character then
		task.spawn(hookJumpCircle, localPlayer.Character)
	end

	RunService.RenderStepped:Connect(function()
		local now = os.clock()

		for index = #activeCircles, 1, -1 do
			local circle = activeCircles[index]
			local t = (now - circle.start) / circle.duration

			if t >= 1 then
				for _, part in ipairs(circle.all) do
					part:Destroy()
				end
				table.remove(activeCircles, index)
			else
				local eased = 1 - (1 - t) ^ 3 -- быстро расходится, плавно замедляется
				local radius = 0.3 + (circle.radius - 0.3) * eased
				local center = circle.center
				local thickness = circle.thickness
				local style = circle.style

				if style == "Двойное" then
					-- второе кольцо стартует с задержкой и отстаёт от первого
					local t2 = math.clamp((t - 0.2) / 0.8, 0, 1)
					local radius2 = 0.3 + (circle.radius * 0.7 - 0.3) * (1 - (1 - t2) ^ 3)
					layRing(circle.ringA, center, radius, thickness, t)
					layRing(circle.ringB, center, radius2, thickness * 0.7, t2 > 0 and (0.2 + 0.8 * t2) or 1)

				elseif style == "Пунктир" then
					-- штрихи с промежутками, кольцо вращается
					layRing(circle.ringA, center, radius, thickness, t, circle.spin * t * math.pi, 0.55)

				elseif style == "Шестиугольник" then
					-- два вложенных шестиугольника, вращаются в разные стороны
					local innerRadius = radius * 0.62
					for g, group in ipairs({ circle.ringA, circle.ringB }) do
						local r = g == 1 and radius or innerRadius
						local rotation = (g == 1 and 1 or -1) * circle.spin * t * 0.9
						local edge = 2 * r * math.sin(math.pi / 6) + thickness
						local apothem = r * math.cos(math.pi / 6)
						for i, part in ipairs(group) do
							local angle = (i - 0.5) / 6 * math.pi * 2 + rotation
							part.Size = Vector3.new(thickness * (g == 1 and 1 or 0.7), 0.05, edge)
							part.CFrame = CFrame.new(center) * CFrame.Angles(0, angle, 0) * CFrame.new(apothem, 0, 0)
							part.Transparency = g == 1 and t or (0.25 + 0.75 * t)
						end
					end

				elseif style == "Лучи" then
					-- короткие штрихи вылетают из центра во все стороны
					local outer = radius
					local inner = radius * 0.55
					for i, part in ipairs(circle.rays) do
						local angle = (i - 1) / #circle.rays * math.pi * 2
						local middle = (outer + inner) / 2
						part.Size = Vector3.new(thickness, 0.05, math.max(outer - inner, 0.05))
						part.CFrame = CFrame.new(center) * CFrame.Angles(0, angle, 0)
							* CFrame.new(middle, 0, 0) * CFrame.Angles(0, math.pi / 2, 0)
						part.Transparency = t
					end

				elseif style == "Волна" then
					circle.disk.Size = Vector3.new(0.04, radius * 2, radius * 2)
					circle.disk.CFrame = CFrame.new(center - Vector3.new(0, 0.01, 0)) * CFrame.Angles(0, 0, math.pi / 2)
					circle.disk.Transparency = 0.55 + 0.45 * t
					layRing(circle.ringA, center, radius, thickness, t)

				else -- "Кольцо" и "Искры"
					layRing(circle.ringA, center, radius, thickness, t)
				end

				local color = circle.rainbow and Color3.fromHSV((now * 0.5) % 1, 0.8, 1) or nil
				if color then
					for _, part in ipairs(circle.all) do
						part.Color = color
					end
				end
				if circle.light then
					circle.light.Brightness = circle.glowStrength * (1 - t)
					circle.light.Range = 2 + radius * 1.5
					if color then
						circle.light.Color = color
					end
				end
			end
		end
	end)
end

--------------------------------------------------------------------
-- Custom Sky: свой вид неба и освещения (раздел Visuals, меняется только у вас)
--------------------------------------------------------------------
local SKY, SKY_PRESET_ORDER, SKY_LIGHTING_MODES
do
	SKY = {
		Enabled = false,
		Preset = "Закат",
		Clouds = true,       -- облака
		MovingSun = false,   -- солнце/луна движутся по небу
		SunSpeed = 2,        -- сколько игровых часов проходит за минуту

		-- Освещение: по умолчанию меняется только небо, а свет остаётся как в игре.
		-- "Игры" — не трогать освещение, "Как у неба" — освещение из варианта неба, "Своё" — значения ниже
		LightingMode = "Игры",
		WorldHaze = false, -- дымка/туман варианта неба на самом мире (по умолчанию выкл — меняется только небо)
		ClockTime = 14,                              -- время суток, 0-24
		Brightness = 2,                              -- яркость солнца
		LightColor = Color3.fromRGB(180, 190, 210),  -- цвет общего освещения (тени, помещения)
		SunColor = Color3.fromRGB(255, 255, 255),    -- цвет солнечного света
		Exposure = 0,                                -- экспозиция: светлее/темнее вся картинка
		Shadows = true,                              -- тени от солнца
	}

	SKY_LIGHTING_MODES = { "Игры", "Как у неба", "Своё" }
	SKY_PRESET_ORDER = { "День", "Рассвет", "Закат", "Ночь", "Космос", "Фэнтези", "Шторм" }

	local rgb = Color3.fromRGB
	local PRESETS = {
		["День"] = {
			Lighting = { ClockTime = 13, Brightness = 3, Ambient = rgb(120, 125, 140), OutdoorAmbient = rgb(140, 145, 160), ColorShift_Top = rgb(255, 255, 255) },
			Atmosphere = { Density = 0.3, Offset = 0.25, Color = rgb(199, 215, 255), Decay = rgb(106, 112, 125), Glare = 0, Haze = 1 },
			Sky = { StarCount = 0, SunAngularSize = 21, MoonAngularSize = 11 },
			Clouds = { Cover = 0.5, Density = 0.6, Color = rgb(255, 255, 255) },
		},
		["Рассвет"] = {
			Lighting = { ClockTime = 6.4, Brightness = 2, Ambient = rgb(110, 90, 110), OutdoorAmbient = rgb(160, 120, 120), ColorShift_Top = rgb(255, 190, 150) },
			Atmosphere = { Density = 0.35, Offset = 0.4, Color = rgb(255, 190, 170), Decay = rgb(130, 90, 120), Glare = 0.4, Haze = 1.8 },
			Sky = { StarCount = 300, SunAngularSize = 26, MoonAngularSize = 11 },
			Clouds = { Cover = 0.55, Density = 0.6, Color = rgb(255, 200, 190) },
		},
		["Закат"] = {
			Lighting = { ClockTime = 18.2, Brightness = 2, Ambient = rgb(90, 70, 90), OutdoorAmbient = rgb(150, 100, 90), ColorShift_Top = rgb(255, 170, 100) },
			Atmosphere = { Density = 0.4, Offset = 0.5, Color = rgb(255, 170, 120), Decay = rgb(120, 60, 80), Glare = 0.6, Haze = 2.2 },
			Sky = { StarCount = 800, SunAngularSize = 30, MoonAngularSize = 11 },
			Clouds = { Cover = 0.6, Density = 0.7, Color = rgb(255, 170, 130) },
		},
		["Ночь"] = {
			Lighting = { ClockTime = 0, Brightness = 0.5, Ambient = rgb(25, 30, 55), OutdoorAmbient = rgb(35, 45, 80), ColorShift_Top = rgb(60, 80, 160) },
			Atmosphere = { Density = 0.25, Offset = 0, Color = rgb(20, 25, 60), Decay = rgb(10, 10, 30), Glare = 0, Haze = 0.5 },
			Sky = { StarCount = 5000, SunAngularSize = 21, MoonAngularSize = 20 },
			Clouds = { Cover = 0.3, Density = 0.4, Color = rgb(60, 70, 110) },
		},
		["Космос"] = {
			Lighting = { ClockTime = 0, Brightness = 0.3, Ambient = rgb(40, 30, 70), OutdoorAmbient = rgb(50, 40, 90), ColorShift_Top = rgb(120, 90, 255) },
			Atmosphere = { Density = 0.05, Offset = 0, Color = rgb(10, 5, 30), Decay = rgb(40, 20, 90), Glare = 0, Haze = 0 },
			Sky = { StarCount = 10000, SunAngularSize = 21, MoonAngularSize = 40 },
			Clouds = { Cover = 0, Density = 0, Color = rgb(255, 255, 255) },
		},
		["Фэнтези"] = {
			Lighting = { ClockTime = 20, Brightness = 1.5, Ambient = rgb(80, 60, 120), OutdoorAmbient = rgb(120, 80, 170), ColorShift_Top = rgb(200, 120, 255) },
			Atmosphere = { Density = 0.5, Offset = 0.3, Color = rgb(190, 120, 255), Decay = rgb(60, 200, 220), Glare = 0.3, Haze = 2.8 },
			Sky = { StarCount = 3000, SunAngularSize = 15, MoonAngularSize = 35 },
			Clouds = { Cover = 0.7, Density = 0.8, Color = rgb(220, 160, 255) },
		},
		["Шторм"] = {
			Lighting = { ClockTime = 14, Brightness = 1, Ambient = rgb(80, 85, 95), OutdoorAmbient = rgb(90, 95, 105), ColorShift_Top = rgb(160, 170, 190) },
			Atmosphere = { Density = 0.55, Offset = 0.1, Color = rgb(120, 125, 135), Decay = rgb(70, 72, 80), Glare = 0, Haze = 3 },
			Sky = { StarCount = 0, SunAngularSize = 21, MoonAngularSize = 11 },
			Clouds = { Cover = 0.9, Density = 0.95, Color = rgb(110, 112, 120) },
		},
	}

	local LIGHTING_PROPS = { "ClockTime", "Brightness", "Ambient", "OutdoorAmbient", "ColorShift_Top", "ExposureCompensation", "GlobalShadows" }
	local CLOUD_PROPS = { "Cover", "Density", "Color" }

	local original = nil          -- небо, атмосфера и облака игры, чтобы вернуть их при выключении
	local lightingOriginal = nil  -- освещение игры; запоминается, только когда мы начинаем его менять
	local mySky, myAtmosphere, myClouds = nil, nil, nil
	local timeOffset = 0
	local lastPreset = nil

	local function startLighting()
		lightingOriginal = {}
		for _, property in ipairs(LIGHTING_PROPS) do
			lightingOriginal[property] = Lighting[property]
		end
		timeOffset = 0
	end

	local function stopLighting()
		for property, value in pairs(lightingOriginal) do
			Lighting[property] = value
		end
		lightingOriginal = nil
	end

	local function enableSky()
		original = { clouds = nil }

		-- свой Sky и Atmosphere; игровые временно убираем (только у вас)
		original.sky = Lighting:FindFirstChildOfClass("Sky")
		if original.sky then
			original.sky.Parent = nil
		end
		original.atmosphere = Lighting:FindFirstChildOfClass("Atmosphere")
		original.atmosphereDensity = original.atmosphere and original.atmosphere.Density or 0
		if original.atmosphere then
			original.atmosphere.Parent = nil
		end

		mySky = Instance.new("Sky")
		mySky.Name = "JustVisualsSky"
		mySky.CelestialBodiesShown = true
		mySky.Parent = Lighting

		myAtmosphere = Instance.new("Atmosphere")
		myAtmosphere.Name = "JustVisualsAtmosphere"
		myAtmosphere:SetAttribute("JustVisualsActive", true)
		myAtmosphere.Parent = Lighting

		local terrainClouds = workspace.Terrain:FindFirstChildOfClass("Clouds")
		if terrainClouds then
			original.clouds = { object = terrainClouds, enabled = terrainClouds.Enabled }
			for _, property in ipairs(CLOUD_PROPS) do
				original.clouds[property] = terrainClouds[property]
			end
			myClouds = terrainClouds
		else
			myClouds = Instance.new("Clouds")
			myClouds.Name = "JustVisualsClouds"
			myClouds.Parent = workspace.Terrain
		end

		timeOffset = 0
	end

	local function disableSky()
		if lightingOriginal then
			stopLighting()
		end

		mySky:Destroy()
		mySky = nil
		if original.sky then
			original.sky.Parent = Lighting
		end

		-- туман мог временно спрятать нашу атмосферу — помечаем её неактивной, чтобы он её не вернул
		myAtmosphere:SetAttribute("JustVisualsActive", false)
		myAtmosphere.Parent = nil
		myAtmosphere = nil
		if original.atmosphere then
			original.atmosphere.Parent = Lighting
		end

		if original.clouds then
			local clouds = original.clouds.object
			clouds.Enabled = original.clouds.enabled
			for _, property in ipairs(CLOUD_PROPS) do
				clouds[property] = original.clouds[property]
			end
		elseif myClouds then
			myClouds:Destroy()
		end
		myClouds = nil
		original = nil
	end

	RunService.RenderStepped:Connect(function(dt)
		if not SKY.Enabled then
			if original then
				disableSky()
			end
			return
		end
		if not original then
			enableSky()
		end

		local preset = PRESETS[SKY.Preset] or PRESETS["Закат"]
		if SKY.Preset ~= lastPreset then
			lastPreset = SKY.Preset
			timeOffset = 0
		end

		-- освещение трогаем, только если его включили (или если солнце должно двигаться)
		local mode = SKY.LightingMode
		local changesLighting = mode ~= "Игры" or SKY.MovingSun
		if changesLighting and not lightingOriginal then
			startLighting()
		elseif not changesLighting and lightingOriginal then
			stopLighting() -- вернули «как в игре» — освещение игры восстанавливается
		end

		if lightingOriginal then
			local baseTime = lightingOriginal.ClockTime
			if mode == "Как у неба" then
				for property, value in pairs(preset.Lighting) do
					Lighting[property] = value
				end
				baseTime = preset.Lighting.ClockTime
			elseif mode == "Своё" then
				local black = Color3.new(0, 0, 0)
				baseTime = SKY.ClockTime
				Lighting.ClockTime = SKY.ClockTime
				Lighting.Brightness = SKY.Brightness
				Lighting.Ambient = SKY.LightColor:Lerp(black, 0.55)
				Lighting.OutdoorAmbient = SKY.LightColor:Lerp(black, 0.3)
				Lighting.ColorShift_Top = SKY.SunColor
				Lighting.ExposureCompensation = SKY.Exposure
				Lighting.GlobalShadows = SKY.Shadows
			end

			if SKY.MovingSun then
				timeOffset += dt * SKY.SunSpeed / 60
				Lighting.ClockTime = (baseTime + timeOffset) % 24
			elseif mode ~= "Как у неба" and mode ~= "Своё" then
				Lighting.ClockTime = baseTime
			end
		end

		for property, value in pairs(preset.Atmosphere) do
			myAtmosphere[property] = value
		end
		-- Плотность атмосферы — это туман на предметах мира. Цвет неба и дымка у горизонта от неё
		-- не зависят, поэтому по умолчанию оставляем туман таким, каким он был в игре (без атмосферы — без тумана).
		if not SKY.WorldHaze then
			myAtmosphere.Density = original.atmosphereDensity
		end
		for property, value in pairs(preset.Sky) do
			mySky[property] = value
		end


		myClouds.Enabled = SKY.Clouds and preset.Clouds.Cover > 0
		for property, value in pairs(preset.Clouds) do
			myClouds[property] = value
		end
	end)
end

--------------------------------------------------------------------
-- Auras: аура вокруг вашего персонажа (раздел Visuals, видна только вам)
--------------------------------------------------------------------
local AURA, AURA_STYLES
do
	AURA = {
		Enabled = false,
		Style = "Орбиты",  -- "Орбиты", "Спираль", "Энергия", "Сияние" или "Кольца"
		Rainbow = false,
		Color = Color3.fromRGB(255, 90, 90),
		Glow = true,       -- неоновое свечение и свет вокруг персонажа
		Size = 1,          -- размер ауры
		Speed = 1,         -- скорость движения
		FirstPersonDistance = 1.5,
	}
	AURA_STYLES = { "Орбиты", "Спираль", "Энергия", "Сияние", "Кольца" }
	-- «Фабрика»: рисует этот эффект для любого игрока (owner) по его настройкам (AURA).
	-- Для вас она вызывается с вашими настройками, для других игроков — с присланными через синхронизацию.
	RENDERERS.Aura = function(owner, AURA)
		local connections = {}
		local localPlayer, RunService = syncContext(owner, connections)

		local RING_TILTS = {
			CFrame.Angles(0, 0, 0),
			CFrame.Angles(math.rad(65), 0, 0),
			CFrame.Angles(math.rad(-65), 0, math.rad(40)),
		}
		local RING_SEGMENTS = 24
		local SMOOTH_SEGMENTS = 36 -- для тонких «интерфейсных» колец (сканер, пульс, нимб)
		local ORBIT_TILTS = {
			CFrame.Angles(math.rad(20), 0, 0),
			CFrame.Angles(math.rad(-35), 0, math.rad(25)),
			CFrame.Angles(math.rad(70), 0, math.rad(-15)),
			CFrame.Angles(math.rad(-60), 0, math.rad(-50)),
		}
		local HELIX_SEGMENTS = 34 -- звеньев в каждой нити спирали (больше — глаже)
		local HELIX_RUNGS = 9     -- «перемычек» между нитями, как в ДНК
		local HELIX_SPARKS = 4    -- светящихся бусин, бегущих вверх по каждой нити

		local auraFolder = Instance.new("Folder")
		auraFolder.Name = "Aura_Local"
		auraFolder.Parent = workspace

		local aura = nil -- { style, size, character, parts, light, ... }

		local function destroyAura()
			if aura then
				for _, part in ipairs(aura.parts) do
					part:Destroy()
				end
				aura = nil
			end
		end

		local function effectPart(data, shape)
			local part = Instance.new("Part")
			part.Anchored = true
			part.CanCollide = false
			part.CanQuery = false
			part.CanTouch = false
			part.CastShadow = false
			part.Material = Enum.Material.Neon
			if shape then
				part.Shape = shape
			end
			part.Parent = auraFolder
			table.insert(data.parts, part)
			return part
		end

		local function makeRing(data, count)
			local ring = {}
			for i = 1, count do
				ring[i] = effectPart(data)
			end
			return ring
		end

		-- раскладывает сегменты кольца по окружности
		local function placeRing(ring, cframe, radius, thickness, transparency, color, material)
			local count = #ring
			local segment = 2 * math.pi * radius / count * 1.08
			for i, part in ipairs(ring) do
				local angle = (i - 1) / count * math.pi * 2
				part.Size = Vector3.new(thickness, thickness, segment)
				part.CFrame = cframe * CFrame.Angles(0, angle, 0) * CFrame.new(radius, 0, 0)
				part.Transparency = transparency
				part.Color = color
				part.Material = material
			end
		end

		local function buildAura(character)
			destroyAura()
			local s = AURA.Size
			local data = { style = AURA.Style, size = s, character = character, parts = {} }

			-- невидимая опора для света
			local holder = effectPart(data)
			holder.Transparency = 1
			holder.Size = Vector3.new(0.2, 0.2, 0.2)
			local light = Instance.new("PointLight")
			light.Shadows = false
			light.Parent = holder
			data.holder = holder
			data.light = light

			if data.style == "Орбиты" then
				-- светящиеся шарики со «шлейфом», летающие по разным орбитам
				data.orbs = {}
				for i = 1, #ORBIT_TILTS do
					local orb = effectPart(data, Enum.PartType.Ball)
					orb.Size = Vector3.one * 0.32 * s

					local a0 = Instance.new("Attachment")
					a0.Position = Vector3.new(0, 0.1 * s, 0)
					a0.Parent = orb
					local a1 = Instance.new("Attachment")
					a1.Position = Vector3.new(0, -0.1 * s, 0)
					a1.Parent = orb

					local trail = Instance.new("Trail")
					trail.Attachment0 = a0
					trail.Attachment1 = a1
					trail.Lifetime = 0.35
					trail.FaceCamera = true
					trail.LightInfluence = 0
					trail.WidthScale = NumberSequence.new({
						NumberSequenceKeypoint.new(0, 1),
						NumberSequenceKeypoint.new(1, 0),
					})
					trail.Transparency = NumberSequence.new({
						NumberSequenceKeypoint.new(0, 0.1),
						NumberSequenceKeypoint.new(1, 1),
					})
					trail.Parent = orb

					data.orbs[i] = { part = orb, trail = trail }
				end

			elseif data.style == "Спираль" then
				-- двойная спираль (как ДНК): две сплошные светящиеся нити, между ними перемычки,
				-- по нитям вверх бегут яркие бусины со шлейфом
				data.helix = { strands = {}, rungs = {}, sparks = {} }
				for strand = 1, 2 do
					local segments = {}
					for i = 1, HELIX_SEGMENTS do
						segments[i] = effectPart(data)
					end
					data.helix.strands[strand] = segments
					for i = 1, HELIX_SPARKS do
						local spark = effectPart(data, Enum.PartType.Ball)
						local a0 = Instance.new("Attachment")
						a0.Position = Vector3.new(0, 0.06, 0)
						a0.Parent = spark
						local a1 = Instance.new("Attachment")
						a1.Position = Vector3.new(0, -0.06, 0)
						a1.Parent = spark
						local trail = Instance.new("Trail")
						trail.Attachment0 = a0
						trail.Attachment1 = a1
						trail.Lifetime = 0.3
						trail.FaceCamera = true
						trail.LightInfluence = 0
						trail.WidthScale = NumberSequence.new(1, 0)
						trail.Transparency = NumberSequence.new(0.2, 1)
						trail.Parent = spark
						table.insert(data.helix.sparks, { part = spark, trail = trail, strand = strand, index = i })
					end
				end
				for i = 1, HELIX_RUNGS do
					data.helix.rungs[i] = effectPart(data)
				end

			elseif data.style == "Сияние" then
				-- Сияние, как в видео: персонаж окутан мягким светом (облако светящихся частиц вокруг тела),
				-- вокруг по спирали снизу вверх проносятся световые «вихри» со шлейфами,
				-- а у ног клубятся светлые дымки.
				data.radiance = { streaks = {} }

				local glowBox = effectPart(data)
				glowBox.Transparency = 1
				glowBox.Size = Vector3.new(2.6, 4.2, 2.2) * AURA.Size
				local glow = Instance.new("ParticleEmitter")
				glow.Texture = "rbxasset://textures/particles/smoke_main.dds"
				glow.Shape = Enum.ParticleEmitterShape.Box
				glow.ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume
				glow.Rate = 30
				glow.Lifetime = NumberRange.new(0.5, 0.9)
				glow.Speed = NumberRange.new(0, 0.4)
				glow.Rotation = NumberRange.new(0, 360)
				glow.RotSpeed = NumberRange.new(-25, 25)
				glow.Size = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 1.6 * AURA.Size),
					NumberSequenceKeypoint.new(1, 2.6 * AURA.Size),
				})
				glow.Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 1),
					NumberSequenceKeypoint.new(0.3, 0.6),
					NumberSequenceKeypoint.new(1, 1),
				})
				glow.LightInfluence = 0
				glow.Parent = glowBox
				data.radiance.glowBox = glowBox
				data.radiance.glow = glow

				local feet = effectPart(data)
				feet.Transparency = 1
				feet.Size = Vector3.new(1.8, 0.2, 1.8) * AURA.Size
				local wisps = Instance.new("ParticleEmitter")
				wisps.Texture = "rbxasset://textures/particles/smoke_main.dds"
				wisps.Shape = Enum.ParticleEmitterShape.Box
				wisps.ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume
				wisps.EmissionDirection = Enum.NormalId.Top
				wisps.Rate = 10
				wisps.Lifetime = NumberRange.new(0.8, 1.3)
				wisps.Speed = NumberRange.new(0.5, 1.2)
				wisps.RotSpeed = NumberRange.new(-60, 60)
				wisps.Size = NumberSequence.new(0.5 * AURA.Size, 1.3 * AURA.Size)
				wisps.Transparency = NumberSequence.new(0.6, 1)
				wisps.LightInfluence = 0
				wisps.Parent = feet
				data.radiance.feet = feet
				data.radiance.wisps = wisps

				-- три световые точки со шлейфами — летят по спирали вокруг тела
				for i = 1, 3 do
					local orb = effectPart(data, Enum.PartType.Ball)
					orb.Size = Vector3.one * 0.18 * AURA.Size
					local a0 = Instance.new("Attachment")
					a0.Position = Vector3.new(0, 0.08, 0)
					a0.Parent = orb
					local a1 = Instance.new("Attachment")
					a1.Position = Vector3.new(0, -0.08, 0)
					a1.Parent = orb
					local trail = Instance.new("Trail")
					trail.Attachment0 = a0
					trail.Attachment1 = a1
					trail.Lifetime = 0.45
					trail.FaceCamera = true
					trail.LightInfluence = 0
					trail.WidthScale = NumberSequence.new(1, 0)
					trail.Transparency = NumberSequence.new(0.1, 1)
					trail.Parent = orb
					data.radiance.streaks[i] = { part = orb, trail = trail }
				end

			elseif data.style == "Энергия" then
				-- Аура «силы», как в аниме-играх: всё тело окутано мягким светящимся пламенем.
				-- Из каждой части тела поднимаются языки энергии и мелкие искры, вокруг силуэта — светящийся контур,
				-- за спиной — мягкое круглое сияние.
				data.energy = { flames = {}, sparks = {}, rates = {} }

				local highlight = Instance.new("Highlight")
				highlight.Adornee = character
				highlight.DepthMode = Enum.HighlightDepthMode.Occluded
				highlight.Parent = auraFolder
				table.insert(data.parts, highlight)
				data.energy.highlight = highlight

				for _, part in ipairs(character:GetChildren()) do
					if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" and part.Transparency < 1 then
						local volume = part.Size.X * part.Size.Y * part.Size.Z

						local flame = Instance.new("ParticleEmitter")
						flame.Name = "OpusAuraFlame"
						flame.Texture = "rbxasset://textures/particles/fire_main.dds"
						flame.EmissionDirection = Enum.NormalId.Top
						flame.SpreadAngle = Vector2.new(25, 25)
						flame.Speed = NumberRange.new(1.5, 3)
						flame.Acceleration = Vector3.new(0, 6, 0)
						flame.Lifetime = NumberRange.new(0.35, 0.6)
						flame.Rotation = NumberRange.new(0, 360)
						flame.RotSpeed = NumberRange.new(-90, 90)
						flame.Size = NumberSequence.new({
							NumberSequenceKeypoint.new(0, 0),
							NumberSequenceKeypoint.new(0.25, 0.85 * AURA.Size),
							NumberSequenceKeypoint.new(1, 0),
						})
						flame.Transparency = NumberSequence.new({
							NumberSequenceKeypoint.new(0, 0.4),
							NumberSequenceKeypoint.new(0.3, 0.25),
							NumberSequenceKeypoint.new(1, 1),
						})
						flame.LightInfluence = 0
						flame.ZOffset = 0.5
						flame.Parent = part
						table.insert(data.parts, flame)
						table.insert(data.energy.flames, flame)
						data.energy.rates[flame] = math.clamp(volume * 6, 5, 26)

						local sparks = Instance.new("ParticleEmitter")
						sparks.Name = "OpusAuraSparks"
						sparks.Texture = "rbxasset://textures/particles/sparkles_main.dds"
						sparks.Speed = NumberRange.new(0.5, 2)
						sparks.SpreadAngle = Vector2.new(180, 180)
						sparks.Acceleration = Vector3.new(0, 2, 0)
						sparks.Lifetime = NumberRange.new(0.5, 1)
						sparks.Size = NumberSequence.new(0.18 * AURA.Size, 0)
						sparks.LightInfluence = 0
						sparks.ZOffset = 0.6
						sparks.Parent = part
						table.insert(data.parts, sparks)
						table.insert(data.energy.sparks, sparks)
						data.energy.rates[sparks] = math.clamp(volume * 2.5, 2, 10)
					end
				end

				-- мягкое круглое сияние за спиной
				local torso = character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso")
				if torso then
					local halo = Instance.new("ParticleEmitter")
					halo.Name = "OpusAuraHalo"
					halo.Texture = "rbxasset://textures/particles/smoke_main.dds"
					halo.Rate = 6
					halo.Speed = NumberRange.new(0)
					halo.Lifetime = NumberRange.new(0.8, 1.2)
					halo.Rotation = NumberRange.new(0, 360)
					halo.RotSpeed = NumberRange.new(-30, 30)
					halo.Size = NumberSequence.new({
						NumberSequenceKeypoint.new(0, 5 * AURA.Size),
						NumberSequenceKeypoint.new(1, 6.5 * AURA.Size),
					})
					halo.Transparency = NumberSequence.new({
						NumberSequenceKeypoint.new(0, 1),
						NumberSequenceKeypoint.new(0.4, 0.75),
						NumberSequenceKeypoint.new(1, 1),
					})
					halo.LightInfluence = 0
					halo.ZOffset = -1 -- позади персонажа
					halo.Parent = torso
					table.insert(data.parts, halo)
					data.energy.halo = halo
				end

			else -- "Кольца"
				data.rings = {}
				for r = 1, #RING_TILTS do
					data.rings[r] = makeRing(data, RING_SEGMENTS)
				end
			end

			aura = data
		end

		RunService.RenderStepped:Connect(function()
			local character = localPlayer.Character
			local root = character and character:FindFirstChild("HumanoidRootPart")
			local humanoid = character and character:FindFirstChildOfClass("Humanoid")

			if not AURA.Enabled or not root or not humanoid or humanoid.Health <= 0 then
				destroyAura()
				return
			end

			if not aura or aura.style ~= AURA.Style or aura.size ~= AURA.Size or aura.character ~= character then
				buildAura(character)
			end

			local now = os.clock()
			local speed = AURA.Speed
			local color = AURA.Rainbow and Color3.fromHSV((now * 0.3) % 1, 0.8, 1) or AURA.Color
			local material = AURA.Glow and Enum.Material.Neon or Enum.Material.SmoothPlastic
			local center = root.Position
			local s = aura.size

			-- в первом лице аура не закрывает обзор
			local head = character:FindFirstChild("Head")
			local camera = workspace.CurrentCamera
			local firstPerson = head and camera
				and (camera.CFrame.Position - head.Position).Magnitude < AURA.FirstPersonDistance
			local shown = not firstPerson
			local hidden = shown and 0 or 1

			aura.holder.CFrame = CFrame.new(center)
			aura.light.Enabled = shown and AURA.Glow
			aura.light.Color = color
			aura.light.Brightness = 1.2
			aura.light.Range = 9 * s

			local feetY
			if humanoid.RigType == Enum.HumanoidRigType.R6 then
				feetY = center.Y - 3
			else
				feetY = center.Y - (humanoid.HipHeight + root.Size.Y / 2)
			end

			if aura.orbs then
				for i, orb in ipairs(aura.orbs) do
					local radius = (2 + (i % 2) * 0.5) * s
					local angle = now * speed * (1.6 + i * 0.35) + i * 1.7
					orb.part.CFrame = CFrame.new(center) * ORBIT_TILTS[i] * CFrame.new(math.cos(angle) * radius, 0, math.sin(angle) * radius)
					orb.part.Color = color
					orb.part.Material = material
					orb.part.Transparency = hidden
					orb.trail.Color = ColorSequence.new(color)
					orb.trail.Enabled = shown
					orb.trail.LightEmission = AURA.Glow and 1 or 0
				end

			elseif aura.helix then
				-- Форма спирали неподвижна по высоте, а сама она плавно вращается — поэтому нити кажутся
				-- бесконечно «текущими» вверх, без рывков и внезапных исчезновений. Концы нитей мягко тают.
				local height = 4.4 * s
				local turns = 2.2
				local phase = now * speed * 1.4
				local breathe = 1 + math.sin(now * speed * 1.8) * 0.05
				local radius = 1.6 * s * breathe

				local function helixPoint(h, strand)
					local angle = h * turns * math.pi * 2 - phase + (strand - 1) * math.pi
					return Vector3.new(center.X + math.cos(angle) * radius, feetY + 0.1 + h * height, center.Z + math.sin(angle) * radius)
				end
				-- мягкое затухание к концам: 0 у ног и у макушки, 1 в середине
				local function edgeFade(h)
					return math.sin(math.clamp(h, 0, 1) * math.pi) ^ 0.7
				end

				for strand, segments in ipairs(aura.helix.strands) do
					local count = #segments
					for i, part in ipairs(segments) do
						local h0, h1 = (i - 1) / count, i / count
						local a, b = helixPoint(h0, strand), helixPoint(h1, strand)
						local fade = edgeFade((h0 + h1) / 2)
						local thickness = (0.05 + 0.07 * fade) * s
						local middle = (a + b) / 2
						part.Size = Vector3.new(thickness, thickness, (b - a).Magnitude + thickness * 0.6)
						part.CFrame = CFrame.lookAt(middle, b)
						part.Color = color
						part.Material = material
						part.Transparency = shown and (1 - 0.9 * fade) or 1
					end
				end

				-- перемычки между нитями (тоньше и прозрачнее)
				for i, rung in ipairs(aura.helix.rungs) do
					local h = (i - 0.5) / #aura.helix.rungs
					local a, b = helixPoint(h, 1), helixPoint(h, 2)
					local fade = edgeFade(h)
					local middle = (a + b) / 2
					rung.Size = Vector3.new(0.035 * s, 0.035 * s, (b - a).Magnitude)
					rung.CFrame = CFrame.lookAt(middle, b)
					rung.Color = color
					rung.Material = material
					rung.Transparency = shown and (1 - 0.45 * fade) or 1
				end

				-- яркие бусины бегут вверх по нитям и тают у макушки, внизу появляются новые
				for _, spark in ipairs(aura.helix.sparks) do
					local h = (now * 0.22 * speed + (spark.index - 1) / HELIX_SPARKS + (spark.strand - 1) * 0.125) % 1
					local fade = edgeFade(h)
					spark.part.Size = Vector3.one * (0.12 + 0.1 * fade) * s
					spark.part.CFrame = CFrame.new(helixPoint(h, spark.strand))
					spark.part.Color = color
					spark.part.Material = Enum.Material.Neon
					spark.part.Transparency = shown and (1 - fade) or 1
					spark.trail.Color = ColorSequence.new(color)
					spark.trail.Enabled = shown and fade > 0.05
					spark.trail.LightEmission = AURA.Glow and 1 or 0.3
				end

			elseif aura.radiance then
				local radiance = aura.radiance
				local soft = color:Lerp(Color3.new(1, 1, 1), 0.35)
				radiance.glowBox.CFrame = CFrame.new(center + Vector3.new(0, 0.3 * s, 0))
				radiance.glow.Enabled = shown
				radiance.glow.Color = ColorSequence.new(soft)
				radiance.glow.LightEmission = AURA.Glow and 1 or 0.5
				radiance.glow.Rate = 30 * speed
				radiance.feet.CFrame = CFrame.new(center.X, feetY + 0.1, center.Z)
				radiance.wisps.Enabled = shown
				radiance.wisps.Color = ColorSequence.new(soft)
				radiance.wisps.LightEmission = AURA.Glow and 1 or 0.4

				local height = 4.6 * s
				for i, streak in ipairs(radiance.streaks) do
					-- спираль снизу вверх; у концов точка гаснет, шлейф выключается, чтобы не было «прыжка» вниз
					local h = (now * 0.32 * speed + (i - 1) / #radiance.streaks) % 1
					local angle = now * speed * 2.6 + i * 2.1
					local radius = (1.25 + 0.35 * math.sin(h * math.pi)) * s
					local fade = math.sin(h * math.pi)
					streak.part.CFrame = CFrame.new(center.X + math.cos(angle) * radius, feetY + 0.2 + h * height, center.Z + math.sin(angle) * radius)
					streak.part.Color = color:Lerp(Color3.new(1, 1, 1), 0.6)
					streak.part.Material = Enum.Material.Neon
					streak.part.Transparency = shown and (1 - fade) or 1
					streak.trail.Enabled = shown and fade > 0.08
					streak.trail.Color = ColorSequence.new(soft)
					streak.trail.LightEmission = 1
				end

				aura.light.Brightness = 1.5 + math.sin(now * 2) * 0.3
				aura.light.Range = 12 * s

			elseif aura.energy then
				local energy = aura.energy
				local pulse = math.sin(now * 4 * speed) * 0.5 + 0.5
				local emission = AURA.Glow and 1 or 0.4

				energy.highlight.Enabled = shown
				energy.highlight.FillColor = color
				energy.highlight.OutlineColor = color
				energy.highlight.FillTransparency = 0.72 + 0.12 * pulse -- контур и заливка мягко «дышат»
				energy.highlight.OutlineTransparency = 0.05 + 0.25 * pulse

				local sequence = ColorSequence.new(color:Lerp(Color3.new(1, 1, 1), 0.35), color)
				for _, flame in ipairs(energy.flames) do
					flame.Enabled = shown
					flame.Rate = energy.rates[flame] * speed
					flame.Color = sequence
					flame.LightEmission = emission
				end
				for _, sparks in ipairs(energy.sparks) do
					sparks.Enabled = shown
					sparks.Rate = energy.rates[sparks] * speed
					sparks.Color = ColorSequence.new(color:Lerp(Color3.new(1, 1, 1), 0.5))
					sparks.LightEmission = emission
				end
				if energy.halo then
					energy.halo.Enabled = shown
					energy.halo.Color = ColorSequence.new(color)
					energy.halo.LightEmission = emission
				end

				aura.light.Brightness = 1 + pulse * 0.8
				aura.light.Range = 10 * s

			elseif aura.rings then
				for r, ring in ipairs(aura.rings) do
					local radius = (2.4 + r * 0.25) * s
					local segment = 2 * math.pi * radius / RING_SEGMENTS * 0.7
					local spin = now * speed * (r % 2 == 0 and -1.5 or 1.5)
					local ringCFrame = CFrame.new(center) * RING_TILTS[r] * CFrame.Angles(0, spin, 0)
					for i, part in ipairs(ring) do
						local angle = (i - 1) / RING_SEGMENTS * math.pi * 2
						part.Size = Vector3.new(0.12 * s, 0.12 * s, segment)
						part.CFrame = ringCFrame * CFrame.Angles(0, angle, 0) * CFrame.new(radius, 0, 0)
						part.Color = color
						part.Transparency = shown and (0.1 + 0.4 * (i % 3 == 0 and 1 or 0)) or 1
						part.Material = material
					end
				end
			end
		end)
		return function()
			for _, connection in ipairs(connections) do
				connection:Disconnect()
			end
			destroyAura()
			auraFolder:Destroy()
		end
	end
	RENDERERS.Aura(localPlayer, AURA)
end

--------------------------------------------------------------------
-- Back: «виртуальные» аксессуары на спине (раздел Visuals, видны только вам)
-- Как China Hat: полупрозрачные детали, приваренные к персонажу, со светящимися контурами.
--------------------------------------------------------------------
local BACK, BACK_STYLES
do
	BACK = {
		Enabled = false,
		Style = "Крылья ангела", -- "Крылья ангела", "Крылья света", "Крылья демона", "Крылья бабочки", "Рюкзак" или "Джетпак"
		Rainbow = false,
		Color = Color3.fromRGB(255, 255, 255),
		Transparency = 0.35,
		Glow = false,      -- неоновые «плоскости» (контуры светятся всегда)
		Size = 1,
		Animation = true,  -- взмахи крыльев, пламя джетпака
		Speed = 1,
		FirstPersonDistance = 1.5,
	}
	BACK_STYLES = { "Крылья ангела", "Крылья света", "Крылья демона", "Крылья бабочки", "Рюкзак", "Джетпак" }
	-- «Фабрика»: рисует этот эффект для любого игрока (owner) по его настройкам (BACK).
	-- Для вас она вызывается с вашими настройками, для других игроков — с присланными через синхронизацию.
	RENDERERS.Back = function(owner, BACK)
		local connections = {}
		local localPlayer, RunService = syncContext(owner, connections)

		local DARK = Color3.fromRGB(38, 38, 44)
		local METAL = Color3.fromRGB(96, 100, 110)
		local VERTICAL = CFrame.Angles(0, 0, math.pi / 2)

		-- Контур крыла в его собственной плоскости (x — наружу от спины, y — вверх), в studs при размере 1.
		-- Сверху плавная дуга, снизу — «зубцы» маховых перьев.
		local WING_TOP = { { 0.25, 0.35 }, { 0.9, 1.05 }, { 1.75, 1.42 }, { 2.55, 1.38 }, { 3.05, 0.95 } }
		local WING_TIPS = { { 2.95, 0.12 }, { 2.55, -0.58 }, { 2.05, -1.08 }, { 1.45, -1.38 }, { 0.88, -1.28 }, { 0.42, -0.78 } }

		local backFolder = Instance.new("Folder")
		backFolder.Name = "BackAccessory_Local"
		backFolder.Parent = workspace

		local back = nil -- { style, size, character, torso, all, items, wings, flames }

		local function destroyBack()
			if back then
				for _, object in ipairs(back.all) do
					object:Destroy()
				end
				back = nil
			end
		end

		-- общая настройка «виртуальной» детали: не мешает физике и не ловит клики/лучи
		local function prepare(data, part, kind)
			part.Anchored = false
			part.Massless = true
			part.CanCollide = false
			part.CanQuery = false
			part.CanTouch = false
			part.CastShadow = false
			part.Material = Enum.Material.SmoothPlastic
			part.Parent = backFolder
			table.insert(data.all, part)
			if kind then
				table.insert(data.items, { part = part, kind = kind })
			end
			return part
		end

		local function weld(anchor, part)
			local constraint = Instance.new("WeldConstraint")
			constraint.Part0 = anchor
			constraint.Part1 = part
			constraint.Parent = part
		end

		local function block(data, anchor, cframe, size, kind, shape)
			local part = Instance.new("Part")
			if shape then
				part.Shape = shape
			end
			part.Size = size
			part.CFrame = cframe
			prepare(data, part, kind)
			weld(anchor, part)
			return part
		end

		-- светящаяся линия между двумя точками (в координатах base)
		local function line(data, anchor, base, a, b, thickness, kind)
			local length = (b - a).Magnitude
			if length < 0.01 then
				return
			end
			local middle = (a + b) / 2
			-- для вертикальных линий вектор «вверх» берём другой, иначе поворот не определён
			local direction = (b - a).Unit
			local up = math.abs(direction.Y) > 0.99 and Vector3.zAxis or Vector3.yAxis
			return block(data, anchor, base * CFrame.lookAt(middle, b, up), Vector3.new(thickness, thickness, length), kind or "neon")
		end

		-- 12 светящихся рёбер коробки — «голографический каркас»
		local function wireBox(data, anchor, cframe, size, thickness)
			local h = size / 2
			for _, y in ipairs({ -h.Y, h.Y }) do
				for _, z in ipairs({ -h.Z, h.Z }) do
					line(data, anchor, cframe, Vector3.new(-h.X, y, z), Vector3.new(h.X, y, z), thickness)
				end
			end
			for _, x in ipairs({ -h.X, h.X }) do
				for _, z in ipairs({ -h.Z, h.Z }) do
					line(data, anchor, cframe, Vector3.new(x, -h.Y, z), Vector3.new(x, h.Y, z), thickness)
				end
				for _, y in ipairs({ -h.Y, h.Y }) do
					line(data, anchor, cframe, Vector3.new(x, y, -h.Z), Vector3.new(x, y, h.Z), thickness)
				end
			end
		end

		-- треугольник из двух клиньев (та же функция, что у полой China Hat)
		local function triangle(data, anchor, a, b, c, kind)
			local w1, w2 = makeTriangle(a, b, c)
			for _, wedge in ipairs({ w1, w2 }) do
				prepare(data, wedge, kind)
				weld(anchor, wedge)
			end
		end

		local function buildWing(data, torso, side)
			local s = data.size
			local backZ = torso.Size.Z / 2

			-- невидимая «кость» крыла на шарнире: её поворачивает анимация взмаха
			local bone = Instance.new("Part")
			bone.Size = Vector3.new(0.1, 0.1, 0.1)
			bone.Transparency = 1
			prepare(data, bone)

			local baseC0 = CFrame.new(side * torso.Size.X * 0.18, torso.Size.Y * 0.28, backZ + 0.08)
			local motor = Instance.new("Motor6D")
			motor.Part0 = torso
			motor.Part1 = bone
			motor.C0 = baseC0
			motor.Parent = bone
			table.insert(data.all, motor)
			bone.CFrame = torso.CFrame * baseC0

			local function point(p, depth)
				return (bone.CFrame * CFrame.new(side * p[1] * s, p[2] * s, depth or 0)).Position
			end

			-- контур: верхняя дуга, затем зубцы перьев с выемками между ними
			local contour = {}
			for _, p in ipairs(WING_TOP) do
				table.insert(contour, p)
			end
			for i, tip in ipairs(WING_TIPS) do
				table.insert(contour, tip)
				local nextTip = WING_TIPS[i + 1]
				if nextTip then
					table.insert(contour, { (tip[1] + nextTip[1]) / 2 * 0.8, (tip[2] + nextTip[2]) / 2 * 0.8 })
				end
			end
			table.insert(contour, { 0.12, -0.25 })

			local root = point({ 0, 0 })
			-- основная полупрозрачная плоскость крыла (веер треугольников от плеча)
			for i = 1, #contour - 1 do
				triangle(data, bone, root, point(contour[i]), point(contour[i + 1]), "main")
			end
			-- второй слой коротких перьев: меньше, светлее, чуть позади
			local inner = {}
			for i = 1, #WING_TOP do
				inner[#inner + 1] = { WING_TOP[i][1] * 0.6, WING_TOP[i][2] * 0.75 }
			end
			for i = 1, #WING_TIPS, 2 do
				inner[#inner + 1] = { WING_TIPS[i][1] * 0.55, WING_TIPS[i][2] * 0.55 }
			end
			local innerRoot = point({ 0, 0 }, 0.06 * s)
			for i = 1, #inner - 1 do
				triangle(data, bone, innerRoot, point(inner[i], 0.06 * s), point(inner[i + 1], 0.06 * s), "soft")
			end

			-- светящиеся «стержни» перьев и передний край крыла
			local thickness = 0.05 * s
			local boneCFrame = bone.CFrame
			local function localPoint(p, depth)
				return Vector3.new(side * p[1] * s, p[2] * s, depth or -0.03)
			end
			for _, tip in ipairs(WING_TIPS) do
				line(data, bone, boneCFrame, localPoint({ 0, 0 }), localPoint(tip), thickness)
			end
			for i = 1, #WING_TOP - 1 do
				line(data, bone, boneCFrame, localPoint(WING_TOP[i]), localPoint(WING_TOP[i + 1]), thickness * 1.4)
			end
			line(data, bone, boneCFrame, localPoint(WING_TOP[#WING_TOP]), localPoint(WING_TIPS[1]), thickness * 1.4)

			table.insert(data.wings, { motor = motor, baseC0 = baseC0, side = side })
		end


		-- Крылья ангела: высокая дуга от плеча вверх и наружу, с неё свисают ряды перьев —
		-- длинные маховые сзади, короче и светлее — кроющие спереди, у края дуги светящийся контур.
		local ANGEL_ROWS = {
			-- количество, длина у плеча, прибавка к концу крыла, ширина, глубина (к зрителю сзади), вид, сдвиг от дуги, доля дуги
			{ count = 11, length = 1.1, grow = 1.9, width = 0.55, depth = 0.0, kind = "main", lift = 0.0, span = 1.0 },
			{ count = 9, length = 0.7, grow = 0.95, width = 0.5, depth = 0.05, kind = "soft", lift = -0.12, span = 0.92 },
			{ count = 7, length = 0.4, grow = 0.45, width = 0.45, depth = 0.09, kind = "soft", lift = -0.22, span = 0.82 },
		}
		local ARC_START, ARC_CONTROL, ARC_END = Vector2.new(0.15, 0.2), Vector2.new(1.0, 1.75), Vector2.new(2.7, 1.35)

		local function arcPoint(t)
			local u = 1 - t
			return ARC_START * (u * u) + ARC_CONTROL * (2 * u * t) + ARC_END * (t * t)
		end

		-- Для «Крыльев света»: невидимая коробка по площади крыла, из объёма которой идут мягкие
		-- светящиеся частицы — получается сияющий ореол вокруг перьев, как в видео.
		local function addWingGlow(data, bone, side)
			local s = data.size
			local box = Instance.new("Part")
			box.Size = Vector3.new(2.4 * s, 2.2 * s, 0.3 * s)
			box.Transparency = 1
			box.CFrame = bone.CFrame * CFrame.new(side * 1.35 * s, 0.35 * s, 0.05 * s)
			prepare(data, box)
			local weld = Instance.new("WeldConstraint")
			weld.Part0 = bone
			weld.Part1 = box
			weld.Parent = box

			local glow = Instance.new("ParticleEmitter")
			glow.Texture = "rbxasset://textures/particles/smoke_main.dds"
			glow.Shape = Enum.ParticleEmitterShape.Box
			glow.ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume
			glow.Rate = 26
			glow.Lifetime = NumberRange.new(0.45, 0.8)
			glow.Speed = NumberRange.new(0, 0.3)
			glow.Rotation = NumberRange.new(0, 360)
			glow.RotSpeed = NumberRange.new(-30, 30)
			glow.Size = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 0.9 * s),
				NumberSequenceKeypoint.new(1, 1.6 * s),
			})
			glow.Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 1),
				NumberSequenceKeypoint.new(0.3, 0.55),
				NumberSequenceKeypoint.new(1, 1),
			})
			glow.LightEmission = 1
			glow.LightInfluence = 0
			glow.LockedToPart = true -- сияние двигается вместе с крылом
			glow.Parent = box
			table.insert(data.glows, glow)
		end

		local function buildAngelWing(data, torso, side)
			local s = data.size
			local backZ = torso.Size.Z / 2

			local bone = Instance.new("Part")
			bone.Size = Vector3.new(0.1, 0.1, 0.1)
			bone.Transparency = 1
			prepare(data, bone)

			local baseC0 = CFrame.new(side * torso.Size.X * 0.15, torso.Size.Y * 0.32, backZ + 0.1)
			data.lastBone = bone
			local motor = Instance.new("Motor6D")
			motor.Part0 = torso
			motor.Part1 = bone
			motor.C0 = baseC0
			motor.Parent = bone
			table.insert(data.all, motor)
			bone.CFrame = torso.CFrame * baseC0

			local boneCFrame = bone.CFrame
			local function world(p, depth)
				return (boneCFrame * CFrame.new(side * p.X * s, p.Y * s, depth * s)).Position
			end

			-- ряды перьев: каждое перо — вытянутый треугольник от дуги вниз-наружу
			for _, row in ipairs(ANGEL_ROWS) do
				for i = 1, row.count do
					local t = 0.05 + (i - 1) / math.max(row.count - 1, 1) * (row.span - 0.05)
					local angle = math.rad(-100 + 75 * t) -- у плеча перья висят вниз, к концу крыла — наружу
					local direction = Vector2.new(math.cos(angle), math.sin(angle))
					local across = Vector2.new(-direction.Y, direction.X)
					local base = arcPoint(t) + Vector2.new(0, row.lift)
					local length = row.length + row.grow * t
					local left = base + across * (row.width / 2)
					local right = base - across * (row.width / 2)
					local tip = base + direction * length
					triangle(data, bone, world(left, row.depth), world(right, row.depth), world(tip, row.depth), row.kind)
				end
			end

			-- плотная полоса вдоль дуги (закрывает основания перьев) и светящаяся передняя кромка
			local segments = 8
			for i = 1, segments do
				local a, b = arcPoint((i - 1) / segments), arcPoint(i / segments)
				local aLow, bLow = a - Vector2.new(0, 0.3), b - Vector2.new(0, 0.3)
				triangle(data, bone, world(a, 0.11), world(b, 0.11), world(aLow, 0.11), "main")
				triangle(data, bone, world(b, 0.11), world(bLow, 0.11), world(aLow, 0.11), "main")
				line(data, bone, boneCFrame,
					Vector3.new(side * a.X * s, a.Y * s, 0.13 * s),
					Vector3.new(side * b.X * s, b.Y * s, 0.13 * s),
					0.06 * s)
			end

			table.insert(data.wings, { motor = motor, baseC0 = baseC0, side = side })
		end

		-- Крылья демона (как у летучей мыши): от плеча вверх идёт «рука» с когтем на сгибе,
		-- из сгиба веером расходятся длинные «пальцы», между ними натянута перепонка
		-- с вогнутыми вырезами по нижнему краю. Кости светятся, перепонка полупрозрачная.
		local DEMON_SHOULDER = Vector2.new(0, 0)
		local DEMON_WRIST = Vector2.new(1.3, 1.25)
		local DEMON_CLAW = Vector2.new(1.22, 1.6)
		local DEMON_FINGERS = { Vector2.new(3.0, 1.1), Vector2.new(2.9, 0.1), Vector2.new(2.3, -0.75), Vector2.new(1.45, -1.3) }
		local DEMON_BODY = Vector2.new(0.15, -0.9) -- нижний край перепонки крепится к спине

		local function buildDemonWing(data, torso, side)
			local s = data.size
			local backZ = torso.Size.Z / 2

			local bone = Instance.new("Part")
			bone.Size = Vector3.new(0.1, 0.1, 0.1)
			bone.Transparency = 1
			prepare(data, bone)

			local baseC0 = CFrame.new(side * torso.Size.X * 0.15, torso.Size.Y * 0.3, backZ + 0.1)
			local motor = Instance.new("Motor6D")
			motor.Part0 = torso
			motor.Part1 = bone
			motor.C0 = baseC0
			motor.Parent = bone
			table.insert(data.all, motor)
			bone.CFrame = torso.CFrame * baseC0

			local boneCFrame = bone.CFrame
			local function world(p, depth)
				return (boneCFrame * CFrame.new(side * p.X * s, p.Y * s, (depth or 0) * s)).Position
			end
			local function boneLocal(p, depth)
				return Vector3.new(side * p.X * s, p.Y * s, (depth or -0.03) * s)
			end

			-- нижний край перепонки: кончик пальца — вырез — кончик — ... — крепление к спине
			local edge = {}
			local previous = nil
			for _, tip in ipairs(DEMON_FINGERS) do
				if previous then
					local middle = (previous + tip) / 2
					table.insert(edge, middle + (DEMON_WRIST - middle) * 0.3) -- вогнутый вырез
				end
				table.insert(edge, tip)
				previous = tip
			end
			local lastMiddle = (previous + DEMON_BODY) / 2
			table.insert(edge, lastMiddle + (DEMON_WRIST - lastMiddle) * 0.25)
			table.insert(edge, DEMON_BODY)

			-- перепонка: веер треугольников из сгиба крыла + участок у спины
			local wrist = world(DEMON_WRIST)
			for i = 1, #edge - 1 do
				triangle(data, bone, wrist, world(edge[i]), world(edge[i + 1]), "main")
			end
			triangle(data, bone, world(DEMON_SHOULDER), wrist, world(DEMON_BODY), "main")

			-- кости: «рука», коготь на сгибе и пальцы
			line(data, bone, boneCFrame, boneLocal(DEMON_SHOULDER), boneLocal(DEMON_WRIST), 0.1 * s)
			line(data, bone, boneCFrame, boneLocal(DEMON_WRIST), boneLocal(DEMON_CLAW), 0.08 * s)
			for _, tip in ipairs(DEMON_FINGERS) do
				line(data, bone, boneCFrame, boneLocal(DEMON_WRIST), boneLocal(tip), 0.065 * s)
			end

			table.insert(data.wings, { motor = motor, baseC0 = baseC0, side = side })
		end

		local function buildBack(character, torso)
			destroyBack()
			local s = BACK.Size
			local data = { style = BACK.Style, size = s, character = character, torso = torso, all = {}, items = {}, wings = {}, flames = {}, glows = {} }
			local backZ = torso.Size.Z / 2
			local halfX, halfY = torso.Size.X / 2, torso.Size.Y / 2
			local torsoCFrame = torso.CFrame
			local thin = 0.05 * s

			if data.style == "Крылья света" then
				-- сияющие крылья: перья светятся неоном, вокруг них мягкий ореол
				data.forceGlow = true
				for _, side in ipairs({ -1, 1 }) do
					buildAngelWing(data, torso, side)
					addWingGlow(data, data.lastBone, side)
				end

			elseif data.style == "Крылья ангела" then
				buildAngelWing(data, torso, -1)
				buildAngelWing(data, torso, 1)

			elseif data.style == "Крылья демона" then
				buildDemonWing(data, torso, -1)
				buildDemonWing(data, torso, 1)

			elseif data.style == "Крылья бабочки" then
				buildWing(data, torso, -1)
				buildWing(data, torso, 1)

			elseif data.style == "Рюкзак" then
				-- голографический рюкзак: полупрозрачный корпус, светящийся каркас, округлый верх
				local bodySize = Vector3.new(1.45, 1.5, 0.62) * s
				local bodyCFrame = torsoCFrame * CFrame.new(0, -0.08 * s, backZ + 0.33 * s)
				block(data, torso, bodyCFrame, bodySize, "main")
				wireBox(data, torso, bodyCFrame, bodySize, thin)

				local topCFrame = torsoCFrame * CFrame.new(0, 0.67 * s, backZ + 0.33 * s)
				block(data, torso, topCFrame, Vector3.new(1.45 * s, 0.62 * s, 0.62 * s), "soft", Enum.PartType.Cylinder)

				local pocketSize = Vector3.new(1.0, 0.62, 0.2) * s
				local pocketCFrame = torsoCFrame * CFrame.new(0, -0.38 * s, backZ + 0.74 * s)
				block(data, torso, pocketCFrame, pocketSize, "soft")
				wireBox(data, torso, pocketCFrame, pocketSize, thin * 0.8)

				-- светящийся ромб-эмблема на кармане
				block(data, torso, pocketCFrame * CFrame.new(0, 0, pocketSize.Z / 2 + 0.01) * CFrame.Angles(0, 0, math.rad(45)),
					Vector3.new(0.2, 0.2, 0.03) * s, "neon")

				-- боковые карманы
				for _, side in ipairs({ -1, 1 }) do
					local sideSize = Vector3.new(0.18, 0.7, 0.45) * s
					local sideCFrame = torsoCFrame * CFrame.new(side * (bodySize.X / 2 + sideSize.X / 2), -0.25 * s, backZ + 0.33 * s)
					block(data, torso, sideCFrame, sideSize, "soft")
					wireBox(data, torso, sideCFrame, sideSize, thin * 0.7)

					-- лямки — светящиеся линии: через плечо и вниз по груди
					local x = side * halfX * 0.55
					local backTop = Vector3.new(x, halfY * 0.6, backZ + 0.05)
					local shoulderBack = Vector3.new(x, halfY + 0.06, backZ * 0.6)
					local shoulderFront = Vector3.new(x, halfY + 0.06, -backZ * 0.6)
					local chestBottom = Vector3.new(x, -halfY * 0.7, -(backZ + 0.05))
					line(data, torso, torsoCFrame, backTop, shoulderBack, thin * 1.6)
					line(data, torso, torsoCFrame, shoulderBack, shoulderFront, thin * 1.6)
					line(data, torso, torsoCFrame, shoulderFront, chestBottom, thin * 1.6)
				end

			else -- "Джетпак"
				local plateCFrame = torsoCFrame * CFrame.new(0, 0.05 * s, backZ + 0.24 * s)
				local plateSize = Vector3.new(1.1, 1.3, 0.45) * s
				block(data, torso, plateCFrame, plateSize, "dark")
				wireBox(data, torso, plateCFrame, plateSize, thin * 0.8)
				for _, y in ipairs({ 0.42, -0.3 }) do
					block(data, torso, torsoCFrame * CFrame.new(0, y * s, backZ + 0.48 * s), Vector3.new(0.9, 0.1, 0.05) * s, "neon")
				end
				for _, side in ipairs({ -1, 1 }) do
					local x = side * 0.4 * s
					local z = backZ + 0.58 * s
					block(data, torso, torsoCFrame * CFrame.new(x, 0.05 * s, z) * VERTICAL, Vector3.new(1.5 * s, 0.56 * s, 0.56 * s), "main", Enum.PartType.Cylinder)
					block(data, torso, torsoCFrame * CFrame.new(x, 0.8 * s, z), Vector3.one * 0.56 * s, "main", Enum.PartType.Ball)
					block(data, torso, torsoCFrame * CFrame.new(x, -0.87 * s, z) * VERTICAL, Vector3.new(0.35 * s, 0.42 * s, 0.42 * s), "metal", Enum.PartType.Cylinder)

					local flamePart = block(data, torso, torsoCFrame * CFrame.new(x, -1.12 * s, z), Vector3.new(0.3, 0.1, 0.3) * s, nil)
					flamePart.Transparency = 1
					local emitter = Instance.new("ParticleEmitter")
					emitter.Texture = "rbxasset://textures/particles/fire_main.dds"
					emitter.EmissionDirection = Enum.NormalId.Bottom
					emitter.Speed = NumberRange.new(6, 9)
					emitter.SpreadAngle = Vector2.new(8, 8)
					emitter.Lifetime = NumberRange.new(0.12, 0.25)
					emitter.LightEmission = 1
					emitter.LightInfluence = 0
					emitter.Size = NumberSequence.new({
						NumberSequenceKeypoint.new(0, 0.45 * s),
						NumberSequenceKeypoint.new(1, 0),
					})
					emitter.Parent = flamePart
					table.insert(data.flames, emitter)
				end
			end

			back = data
		end

		RunService.RenderStepped:Connect(function()
			local character = localPlayer.Character
			local torso = character and (character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso"))
			local humanoid = character and character:FindFirstChildOfClass("Humanoid")

			if not BACK.Enabled or not torso or not humanoid or humanoid.Health <= 0 then
				destroyBack()
				return
			end

			if not back or back.style ~= BACK.Style or back.size ~= BACK.Size
				or back.character ~= character or back.torso ~= torso then
				buildBack(character, torso)
			end

			local now = os.clock()
			local color = BACK.Rainbow and Color3.fromHSV((now * 0.3) % 1, 0.7, 1) or BACK.Color
			local soft = color:Lerp(Color3.new(1, 1, 1), 0.35)
			local material = BACK.Glow and Enum.Material.Neon or Enum.Material.SmoothPlastic

			local head = character:FindFirstChild("Head")
			local camera = workspace.CurrentCamera
			local firstPerson = head and camera
				and (camera.CFrame.Position - head.Position).Magnitude < BACK.FirstPersonDistance

			local base = BACK.Transparency
			for _, item in ipairs(back.items) do
				local part = item.part
				if firstPerson then
					part.Transparency = 1
				elseif item.kind == "main" then
					part.Transparency = base
					part.Color = color
					part.Material = back.forceGlow and Enum.Material.Neon or material
				elseif item.kind == "soft" then
					part.Transparency = base + (1 - base) * 0.35
					part.Color = soft
					part.Material = back.forceGlow and Enum.Material.Neon or material
				elseif item.kind == "neon" then
					part.Transparency = base * 0.4
					part.Color = color
					part.Material = Enum.Material.Neon
				elseif item.kind == "metal" then
					part.Transparency = base * 0.5
					part.Color = METAL
					part.Material = Enum.Material.Metal
				else -- "dark"
					part.Transparency = base
					part.Color = DARK
					part.Material = Enum.Material.SmoothPlastic
				end
			end

			for _, glow in ipairs(back.glows or {}) do
				glow.Enabled = not firstPerson
				glow.Color = ColorSequence.new(color:Lerp(Color3.new(1, 1, 1), 0.3))
			end

			-- взмахи крыльев: крылья отведены назад и плавно машут
			local flap = BACK.Animation and math.sin(now * 2.2 * BACK.Speed) * math.rad(14) or 0
			for _, wing in ipairs(back.wings) do
				wing.motor.C0 = wing.baseC0 * CFrame.Angles(0, -wing.side * (math.rad(24) + flap), 0)
			end

			-- пламя джетпака: сильнее в прыжке и в падении, слабее на месте
			if #back.flames > 0 then
				local state = humanoid:GetState()
				local airborne = state == Enum.HumanoidStateType.Jumping or state == Enum.HumanoidStateType.Freefall
				local moving = humanoid.MoveDirection.Magnitude > 0.1
				local rate = airborne and 90 or (moving and 35 or 12)
				for _, emitter in ipairs(back.flames) do
					emitter.Enabled = BACK.Animation and not firstPerson
					emitter.Rate = rate * BACK.Speed
					emitter.Color = BACK.Rainbow and ColorSequence.new(color)
						or ColorSequence.new(Color3.fromRGB(255, 230, 140), Color3.fromRGB(255, 90, 40))
				end
			end
		end)
		return function()
			for _, connection in ipairs(connections) do
				connection:Disconnect()
			end
			destroyBack()
			backFolder:Destroy()
		end
	end
	RENDERERS.Back(localPlayer, BACK)
end

--------------------------------------------------------------------
-- Shaders: постобработка картинки, чтобы мир выглядел реалистичнее (раздел Visuals, только у вас)
--   цветокоррекция, мягкое свечение ярких мест, солнечные лучи, размытие дальнего плана,
--   виньетка по краям экрана и более «живые» отражения окружения и мягкие тени.
--------------------------------------------------------------------
local SHADERS, SHADER_PRESETS
do
	SHADERS = {
		Enabled = false,
		Preset = "Реализм",  -- см. SHADER_PRESETS
		Intensity = 1,       -- сила эффекта: 0..1.5
		SunRays = true,      -- лучи от солнца
		DepthOfField = true, -- лёгкое размытие дальнего плана
		Vignette = true,     -- затемнение по краям экрана
	}
	SHADER_PRESETS = { "Реализм", "Кино", "Яркий", "Мягкий", "Нуар" }

	local rgb = Color3.fromRGB
	local PRESETS = {
		["Реализм"] = {
			Brightness = 0.02, Contrast = 0.12, Saturation = 0.08, Tint = rgb(255, 250, 244),
			Bloom = 0.6, BloomSize = 24, BloomThreshold = 1.6,
			Rays = 0.06, RaysSpread = 0.8,
			Far = 0.15, Focus = 30, Radius = 40,
			Vignette = 0.35,
		},
		["Кино"] = {
			Brightness = 0, Contrast = 0.22, Saturation = -0.05, Tint = rgb(255, 236, 214),
			Bloom = 0.9, BloomSize = 32, BloomThreshold = 1.3,
			Rays = 0.1, RaysSpread = 0.9,
			Far = 0.25, Focus = 25, Radius = 30,
			Vignette = 0.55,
		},
		["Яркий"] = {
			Brightness = 0.03, Contrast = 0.15, Saturation = 0.3, Tint = rgb(255, 255, 255),
			Bloom = 1.0, BloomSize = 28, BloomThreshold = 1.2,
			Rays = 0.12, RaysSpread = 0.85,
			Far = 0.08, Focus = 40, Radius = 50,
			Vignette = 0.2,
		},
		["Мягкий"] = {
			Brightness = 0.05, Contrast = -0.05, Saturation = 0.05, Tint = rgb(255, 246, 250),
			Bloom = 1.2, BloomSize = 40, BloomThreshold = 1.0,
			Rays = 0.08, RaysSpread = 1,
			Far = 0.2, Focus = 30, Radius = 35,
			Vignette = 0.3,
		},
		["Нуар"] = {
			Brightness = -0.02, Contrast = 0.35, Saturation = -1, Tint = rgb(255, 255, 255),
			Bloom = 0.4, BloomSize = 20, BloomThreshold = 1.5,
			Rays = 0.05, RaysSpread = 0.7,
			Far = 0.2, Focus = 25, Radius = 30,
			Vignette = 0.7,
		},
	}

	local POST_CLASSES = { "BloomEffect", "ColorCorrectionEffect", "SunRaysEffect", "DepthOfFieldEffect" }
	local LIGHTING_PROPS = { "EnvironmentDiffuseScale", "EnvironmentSpecularScale", "ShadowSoftness", "GlobalShadows" }

	local effects = nil       -- наши эффекты, пока шейдеры включены
	local disabledGame = {}   -- эффекты игры, которые мы временно выключили, чтобы не накладывались
	local lightingOriginal = nil

	-- виньетка: четыре полосы по краям экрана, плавно темнеющие к краю
	local vignetteGui = Instance.new("ScreenGui")
	vignetteGui.Name = "OpusClient_Vignette"
	vignetteGui.IgnoreGuiInset = true
	vignetteGui.ResetOnSpawn = false
	vignetteGui.DisplayOrder = -10 -- под всем интерфейсом
	vignetteGui.Enabled = false
	vignetteGui.Parent = playerGui

	local vignetteGradients = {}
	for _, spec in ipairs({
		{ UDim2.fromScale(0, 0), UDim2.fromScale(1, 0.22), 90 },     -- верх: тёмный сверху
		{ UDim2.fromScale(0, 0.78), UDim2.fromScale(1, 0.22), -90 }, -- низ
		{ UDim2.fromScale(0, 0), UDim2.fromScale(0.16, 1), 0 },      -- лево
		{ UDim2.fromScale(0.84, 0), UDim2.fromScale(0.16, 1), 180 }, -- право
	}) do
		local strip = Instance.new("Frame")
		strip.Position = spec[1]
		strip.Size = spec[2]
		strip.BackgroundColor3 = Color3.new(0, 0, 0)
		strip.BorderSizePixel = 0
		strip.Parent = vignetteGui
		local gradient = Instance.new("UIGradient")
		gradient.Rotation = spec[3]
		gradient.Parent = strip
		table.insert(vignetteGradients, gradient)
	end

	local function enableShaders()
		-- эффекты игры того же типа выключаем, чтобы они не складывались с нашими
		local camera = workspace.CurrentCamera
		for _, container in ipairs({ Lighting, camera }) do
			if container then
				for _, child in ipairs(container:GetChildren()) do
					for _, className in ipairs(POST_CLASSES) do
						if child:IsA(className) and child.Enabled and not child.Name:find("^JustVisuals") then
							child.Enabled = false
							table.insert(disabledGame, child)
						end
					end
				end
			end
		end

		lightingOriginal = {}
		for _, property in ipairs(LIGHTING_PROPS) do
			lightingOriginal[property] = Lighting[property]
		end

		effects = {
			grade = Instance.new("ColorCorrectionEffect"),
			bloom = Instance.new("BloomEffect"),
			rays = Instance.new("SunRaysEffect"),
			dof = Instance.new("DepthOfFieldEffect"),
		}
		for name, effect in pairs(effects) do
			effect.Name = "OpusShader_" .. name
			effect.Parent = Lighting
		end
	end

	local function disableShaders()
		for _, effect in pairs(effects) do
			effect:Destroy()
		end
		effects = nil
		for _, effect in ipairs(disabledGame) do
			if effect.Parent then
				effect.Enabled = true
			end
		end
		table.clear(disabledGame)
		for property, value in pairs(lightingOriginal) do
			Lighting[property] = value
		end
		lightingOriginal = nil
		vignetteGui.Enabled = false
	end

	RunService.RenderStepped:Connect(function()
		if not SHADERS.Enabled then
			if effects then
				disableShaders()
			end
			return
		end
		if not effects then
			enableShaders()
		end

		local p = PRESETS[SHADERS.Preset] or PRESETS["Реализм"]
		local k = math.clamp(SHADERS.Intensity, 0, 1.5)

		local grade = effects.grade
		grade.Brightness = p.Brightness * k
		grade.Contrast = p.Contrast * k
		grade.Saturation = p.Saturation * k
		grade.TintColor = Color3.new(1, 1, 1):Lerp(p.Tint, math.min(k, 1))

		local bloom = effects.bloom
		bloom.Intensity = p.Bloom * k
		bloom.Size = p.BloomSize
		bloom.Threshold = p.BloomThreshold

		local rays = effects.rays
		rays.Enabled = SHADERS.SunRays
		rays.Intensity = p.Rays * k
		rays.Spread = p.RaysSpread

		local dof = effects.dof
		dof.Enabled = SHADERS.DepthOfField
		dof.FarIntensity = p.Far * k
		dof.NearIntensity = 0
		dof.FocusDistance = p.Focus
		dof.InFocusRadius = p.Radius

		-- более «живые» отражения окружения и мягкие тени
		Lighting.EnvironmentDiffuseScale = math.max(lightingOriginal.EnvironmentDiffuseScale, math.min(1, 0.6 * k + 0.2))
		Lighting.EnvironmentSpecularScale = math.max(lightingOriginal.EnvironmentSpecularScale, math.min(1, 0.7 * k + 0.2))
		Lighting.ShadowSoftness = math.clamp(0.1 + 0.1 * k, 0, 1)
		Lighting.GlobalShadows = true

		vignetteGui.Enabled = SHADERS.Vignette
		local edge = 1 - math.clamp(p.Vignette * k, 0, 0.9)
		for _, gradient in ipairs(vignetteGradients) do
			gradient.Transparency = NumberSequence.new(edge, 1)
		end
	end)
end

--------------------------------------------------------------------
-- Bottom: светящаяся платформа под вами (раздел Visuals, видна только вам).
-- Платформа следует за вами: плавно догоняет, слегка наклоняется в сторону движения,
-- может держаться у ног (и в прыжке тоже) или лежать на земле под вами. Это только визуал —
-- стоять на ней нельзя, она ни с чем не сталкивается.
--------------------------------------------------------------------
local BOTTOM, BOTTOM_STYLES, BOTTOM_MODES
do
	BOTTOM = {
		Enabled = false,
		Style = "Диск",          -- см. BOTTOM_STYLES
		Mode = "На земле",       -- "На земле" — лежит на земле под вами; "Под ногами" — всегда у ног, даже в прыжке
		Rainbow = false,
		Color = Color3.fromRGB(150, 185, 255),
		Glow = true,
		Size = 1,
		Transparency = 0.35,
		Tilt = false,            -- наклон в сторону движения (по умолчанию выключен)
		Delay = 0,               -- задержка при ходьбе: 0 — платформа точно под вами, 1 — заметно отстаёт
	}
	BOTTOM_STYLES = { "Диск", "Шестиугольник", "Магический круг", "Печать", "Облако" }
	BOTTOM_MODES = { "Под ногами", "На земле" }
	-- «Фабрика»: рисует этот эффект для любого игрока (owner) по его настройкам (BOTTOM).
	-- Для вас она вызывается с вашими настройками, для других игроков — с присланными через синхронизацию.
	RENDERERS.Bottom = function(owner, BOTTOM)
		local connections = {}
		local localPlayer, RunService = syncContext(owner, connections)

		local folder = Instance.new("Folder")
		folder.Name = "Bottom_Local"
		folder.Parent = workspace

		local platform = nil -- { style, size, parts = { {part, offset, spin, kind} }, position, tilt, light }

		local function destroyPlatform()
			if platform then
				for _, entry in ipairs(platform.parts) do
					entry.part:Destroy()
				end
				for _, hub in ipairs(platform.hubs or {}) do
					hub.part:Destroy()
				end
				platform = nil
			end
		end

		-- kind: "fill" — заливка (прозрачнее), "line" — светящиеся линии, "soft" — облачко
		local function addPart(data, shape, size, offset, kind, spin)
			local part = Instance.new("Part")
			part.Shape = shape or Enum.PartType.Block
			part.Size = size
			part.Anchored = true
			part.CanCollide = false
			part.CanQuery = false
			part.CanTouch = false
			part.CastShadow = false
			part.Parent = folder
			table.insert(data.parts, { part = part, offset = offset, kind = kind, spin = spin or 0 })
			return part
		end

		-- кольцо из коротких сегментов в горизонтальной плоскости
		local function ring(data, radius, thickness, segments, kind, spin, arcs, fill, y)
			arcs = arcs or 1
			fill = fill or 1
			local perArc = math.floor(segments / arcs)
			local span = math.pi * 2 / arcs * fill
			for a = 0, arcs - 1 do
				local start = a * math.pi * 2 / arcs
				local length = radius * span / perArc * 1.1
				for i = 0, perArc - 1 do
					local angle = start + (i + 0.5) / perArc * span
					addPart(data, nil, Vector3.new(thickness, thickness * 0.5, length),
						CFrame.new(0, y or 0, 0) * CFrame.Angles(0, angle, 0) * CFrame.new(radius, 0, 0), kind, spin)
				end
			end
		end

		local function buildPlatform()
			destroyPlatform()
			local s = BOTTOM.Size
			local data = { style = BOTTOM.Style, size = s, parts = {}, position = nil, tilt = CFrame.new() }

			if data.style == "Шестиугольник" then
				-- шестиугольная плитка: заливка из шести треугольников, яркая кромка и внутренний контур
				local R = 2 * s
				local corners = {}
				for i = 0, 5 do
					local angle = i / 6 * math.pi * 2
					corners[i + 1] = Vector3.new(math.cos(angle) * R, 0, math.sin(angle) * R)
				end
				for i = 1, 6 do
					local w1, w2 = makeTriangle(Vector3.zero, corners[i], corners[i % 6 + 1])
					for _, wedge in ipairs({ w1, w2 }) do
						wedge.Anchored = true
						wedge.CanCollide = false
						wedge.CanQuery = false
						wedge.CanTouch = false
						wedge.CastShadow = false
						wedge.Parent = folder
						-- запоминаем положение клина относительно центра (треугольник построен вокруг нуля)
						table.insert(data.parts, { part = wedge, offset = wedge.CFrame, kind = "fill", spin = 0 })
					end
				end
				for _, scale in ipairs({ 1, 0.62 }) do
					for i = 1, 6 do
						local a, b = corners[i] * scale, corners[i % 6 + 1] * scale
						local middle = (a + b) / 2
						local thickness = (scale == 1 and 0.12 or 0.06) * s
						addPart(data, nil, Vector3.new(thickness, thickness * 0.5, (b - a).Magnitude + thickness),
							CFrame.lookAt(middle, b) + Vector3.new(0, 0.03, 0), "line", scale == 1 and 0 or 0.6)
					end
				end

			elseif data.style == "Магический круг" then
				-- рунный круг на земле: кольца крутятся в разные стороны, лучи и насечки
				local R = 2.2 * s
				ring(data, R, 0.1 * s, 40, "line", 0.5, 4, 0.7)
				ring(data, R * 0.78, 0.06 * s, 36, "line", -0.8)
				for i = 0, 11 do
					local angle = i / 12 * math.pi * 2
					addPart(data, nil, Vector3.new(0.22 * s, 0.03 * s, 0.04 * s),
						CFrame.Angles(0, angle, 0) * CFrame.new(R * 0.78 + 0.13 * s, 0, 0), "line", -0.8)
				end
				ring(data, R * 0.42, 0.07 * s, 24, "line", 1.4, 3, 0.7)
				for i = 0, 5 do
					local angle = i / 6 * math.pi * 2
					addPart(data, nil, Vector3.new(R * 0.95, 0.02 * s, 0.035 * s),
						CFrame.Angles(0, angle, 0) * CFrame.new(R * 0.5, 0, 0), "line", 0.25)
				end
				-- полупрозрачная заливка круга
				addPart(data, Enum.PartType.Cylinder, Vector3.new(0.03, R * 2, R * 2),
					CFrame.new(0, -0.02, 0) * CFrame.Angles(0, 0, math.pi / 2), "fill", 0)

			elseif data.style == "Облако" then
				-- пушистое облачко из мягких шариков, слегка «дышит»
				for i = 1, 9 do
					local angle = (i - 1) / 9 * math.pi * 2
					local radius = (i == 1) and 0 or (0.9 + math.random() * 0.5) * s
					local size = (i == 1 and 2.2 or 1.3 + math.random() * 0.6) * s
					addPart(data, Enum.PartType.Ball, Vector3.one * size,
						CFrame.new(math.cos(angle) * radius, -size * 0.25, math.sin(angle) * radius), "soft", 0)
				end

			elseif data.style == "Печать" then
				-- «Печать» — магический круг призыва, как на скриншоте (от края к центру):
				--   двойное внешнее кольцо и между ними «меандр» (квадратная волна);
				--   пояс рун-символов, кольцо с насечками и разорванные толстые дуги;
				--   звезда-октаграмма из прямых линий с лучами к центру; маленькое кольцо и круг в центре.
				-- Слои вращаются в разные стороны. Каждый слой — набор деталей, приваренных к своей «ступице»:
				-- каждый кадр двигаются только ступицы, поэтому сотни линий не нагружают игру.
				local R = 3 * s
				data.hubs = {}
				local function layer(spin)
					local hub = Instance.new("Part")
					hub.Anchored = true
					hub.CanCollide = false
					hub.CanQuery = false
					hub.CanTouch = false
					hub.Transparency = 1
					hub.Size = Vector3.new(0.1, 0.1, 0.1)
					hub.CFrame = CFrame.new()
					hub.Parent = folder
					table.insert(data.hubs, { part = hub, spin = spin })
					return hub
				end
				local function weldTo(hub, part, kind)
					part.Anchored = false
					part.Massless = true
					part.CanCollide = false
					part.CanQuery = false
					part.CanTouch = false
					part.CastShadow = false
					part.Parent = folder
					local weld = Instance.new("WeldConstraint")
					weld.Part0 = hub
					weld.Part1 = part
					weld.Parent = part
					table.insert(data.parts, { part = part, kind = kind, welded = true })
				end
				local function stick(hub, a, b, thickness)
					local length = (b - a).Magnitude
					if length < 0.01 then
						return
					end
					local part = Instance.new("Part")
					part.Size = Vector3.new(thickness, thickness * 0.4, length + thickness * 0.8)
					part.CFrame = CFrame.lookAt((a + b) / 2, b)
					weldTo(hub, part, "line")
				end
				local function polar(radius, angle)
					return Vector3.new(math.cos(angle) * radius, 0.03, math.sin(angle) * radius)
				end
				local function circle(hub, radius, thickness, segments, arcs, fill)
					arcs, fill = arcs or 1, fill or 1
					local perArc = math.max(2, math.floor(segments / arcs))
					for a = 0, arcs - 1 do
						local start = a * math.pi * 2 / arcs
						local span = math.pi * 2 / arcs * fill
						for i = 0, perArc - 1 do
							stick(hub, polar(radius, start + i / perArc * span), polar(radius, start + (i + 1) / perArc * span), thickness)
						end
					end
				end

				-- слой 1: двойное внешнее кольцо и меандр между линиями
				local outer = layer(0.12)
				circle(outer, R, 0.07 * s, 72)
				circle(outer, R * 0.965, 0.04 * s, 72)
				local steps = 56
				local high, low = R * 0.93, R * 0.86
				for i = 0, steps - 1 do
					local a0 = i / steps * math.pi * 2
					local a1 = (i + 0.5) / steps * math.pi * 2
					local a2 = (i + 1) / steps * math.pi * 2
					-- «зубец»: по внешнему краю, вниз, по внутреннему краю, вверх
					stick(outer, polar(high, a0), polar(high, a1), 0.045 * s)
					stick(outer, polar(high, a1), polar(low, a1), 0.045 * s)
					stick(outer, polar(low, a1), polar(low, a2), 0.045 * s)
					stick(outer, polar(low, a2), polar(high, a2), 0.045 * s)
				end
				circle(outer, R * 0.83, 0.05 * s, 64)

				-- слой 2: руны, кольцо с насечками и толстые разорванные дуги
				local runes = layer(-0.2)
				local seed = 7 -- руны всегда одни и те же
				local function random()
					seed = (seed * 1103515245 + 12345) % 2147483648
					return seed / 2147483648
				end
				local glyphCount = 14
				local glyphSize = R * 0.085
				for g = 0, glyphCount - 1 do
					local angle = (g + 0.5) / glyphCount * math.pi * 2
					local center = polar(R * 0.755, angle)
					local tangent = Vector3.new(-math.sin(angle), 0, math.cos(angle))
					local radial = Vector3.new(math.cos(angle), 0, math.sin(angle))
					-- каждая руна: 2–3 штриха-ломаные из 2–3 точек
					for _ = 1, 2 + math.floor(random() * 2) do
						local points = {}
						for k = 1, 2 + math.floor(random() * 2) do
							points[k] = center + tangent * (random() - 0.5) * glyphSize + radial * (random() - 0.5) * glyphSize
						end
						for k = 1, #points - 1 do
							stick(runes, points[k], points[k + 1], 0.04 * s)
						end
					end
				end
				circle(runes, R * 0.68, 0.06 * s, 60)
				for i = 0, 59 do
					local angle = i / 60 * math.pi * 2
					local long = i % 5 == 0
					stick(runes, polar(R * 0.68, angle), polar(R * (long and 0.715 or 0.695), angle), 0.03 * s)
				end
				circle(runes, R * 0.645, 0.15 * s, 36, 6, 0.55)

				-- слой 3: звезда-октаграмма {8/3}, лучи к центру и среднее кольцо
				local star = layer(0.3)
				for i = 0, 7 do
					local a = i / 8 * math.pi * 2
					local b = ((i + 3) % 8) / 8 * math.pi * 2
					stick(star, polar(R * 0.61, a), polar(R * 0.61, b), 0.06 * s)
					stick(star, polar(R * 0.61, a), polar(R * 0.2, a), 0.035 * s)
				end
				circle(star, R * 0.32, 0.05 * s, 36)

				-- слой 4: маленькое кольцо и светящийся круг в центре
				local core = layer(-0.5)
				circle(core, R * 0.18, 0.05 * s, 28)
				local disc = Instance.new("Part")
				disc.Shape = Enum.PartType.Cylinder
				disc.Size = Vector3.new(0.03, R * 0.24, R * 0.24)
				disc.CFrame = CFrame.new(0, 0.02, 0) * CFrame.Angles(0, 0, math.pi / 2)
				weldTo(core, disc, "fill")

			else -- «Диск»
				local R = 2 * s
				addPart(data, Enum.PartType.Cylinder, Vector3.new(0.06, R * 2, R * 2),
					CFrame.Angles(0, 0, math.pi / 2), "fill", 0)
				ring(data, R, 0.12 * s, 40, "line", 0, 1, 1, 0.04)
				ring(data, R * 0.7, 0.05 * s, 32, "line", 0.7, 3, 0.8, 0.04)
			end

			-- свет снизу
			local lightPart = addPart(data, nil, Vector3.new(0.1, 0.1, 0.1), CFrame.new(0, 0.3, 0), "hidden", 0)
			local light = Instance.new("PointLight")
			light.Shadows = false
			light.Parent = lightPart
			data.light = light

			platform = data
		end

		local params = RaycastParams.new()
		params.FilterType = Enum.RaycastFilterType.Exclude

		RunService.RenderStepped:Connect(function(dt)
			local character = localPlayer.Character
			local root = character and character:FindFirstChild("HumanoidRootPart")
			local humanoid = character and character:FindFirstChildOfClass("Humanoid")
			if not BOTTOM.Enabled or not root or not humanoid or humanoid.Health <= 0 then
				destroyPlatform()
				return
			end
			if not platform or platform.style ~= BOTTOM.Style or platform.size ~= BOTTOM.Size then
				buildPlatform()
			end

			-- уровень ног (у R6 HipHeight = 0, поэтому считаем отдельно)
			local feetY = humanoid.RigType == Enum.HumanoidRigType.R6 and (root.Position.Y - 3)
				or (root.Position.Y - humanoid.HipHeight - root.Size.Y / 2)
			local y = feetY
			if BOTTOM.Mode == "На земле" then
				params.FilterDescendantsInstances = { character, folder }
				local hit = workspace:Raycast(root.Position, Vector3.new(0, -60, 0), params)
				y = hit and hit.Position.Y or feetY
			end
			local target = Vector3.new(root.Position.X, y + 0.06, root.Position.Z)

			-- без задержки платформа стоит точно под вами; с задержкой — плавно догоняет
			local delay = math.clamp(BOTTOM.Delay, 0, 1)
			if delay <= 0.001 or not platform.position or (platform.position - target).Magnitude > 30 then
				platform.position = target
			else
				local followSpeed = 2 + (1 - delay) * 28 -- чем больше задержка, тем медленнее догоняет
				platform.position = platform.position:Lerp(target, 1 - math.exp(-followSpeed * dt))
			end

			-- наклон в сторону движения, как у доски для серфинга
			local velocity = root.AssemblyLinearVelocity
			local wantTilt = CFrame.new()
			if BOTTOM.Tilt then
				local pitch = math.clamp(velocity.Z * 0.008, -0.14, 0.14)
				local roll = math.clamp(-velocity.X * 0.008, -0.14, 0.14)
				wantTilt = CFrame.Angles(pitch, 0, roll)
			end
			platform.tilt = platform.tilt:Lerp(wantTilt, 1 - math.exp(-8 * dt))

			local look = root.CFrame.LookVector
			local yaw = math.atan2(-look.X, -look.Z)
			local now = os.clock()
			local base = CFrame.new(platform.position) * platform.tilt * CFrame.Angles(0, yaw, 0)

			local color = BOTTOM.Rainbow and Color3.fromHSV((now * 0.3) % 1, 0.7, 1) or BOTTOM.Color
			local light = color:Lerp(Color3.new(1, 1, 1), 0.4)
			local transparency = math.clamp(BOTTOM.Transparency, 0, 0.95)
			local pulse = 0.5 + 0.5 * math.sin(now * 2.2)
			local breathe = 1 + math.sin(now * 1.6) * 0.04

			-- ступицы «Печати»: двигаем только их, приваренные к ним линии едут следом
			for _, hub in ipairs(platform.hubs or {}) do
				hub.part.CFrame = base * CFrame.Angles(0, now * hub.spin, 0)
			end

			-- у приваренных линий «Печати» цвет обновляем только когда он реально изменился:
			-- их сотни, и перекрашивать их каждый кадр незачем
			local appearanceKey = tostring(color) .. "/" .. transparency .. "/" .. tostring(BOTTOM.Glow)
			local refreshWelded = appearanceKey ~= platform.appearanceKey
			platform.appearanceKey = appearanceKey

			for _, entry in ipairs(platform.parts) do
				if entry.welded and not refreshWelded then
					continue
				end
				local offset = entry.offset or CFrame.new()
				if entry.welded then
					-- положение задаёт ступица; ниже меняются только цвет и прозрачность
				elseif (entry.spin or 0) ~= 0 then
					offset = CFrame.Angles(0, now * entry.spin, 0) * offset
				end
				if entry.kind == "soft" then
					local p = offset.Position
					offset = CFrame.new(p.X * breathe, p.Y, p.Z * breathe)
				end
				local part = entry.part
				if not entry.welded then
					part.CFrame = base * offset
				end
				if entry.kind == "hidden" then
					part.Transparency = 1
				elseif entry.kind == "fill" then
					part.Color = color
					part.Material = BOTTOM.Glow and Enum.Material.Neon or Enum.Material.SmoothPlastic
					part.Transparency = math.clamp(transparency + 0.4 + (entry.welded and 0 or 0.08 * pulse), 0, 0.97)
				elseif entry.kind == "soft" then
					part.Color = light
					part.Material = Enum.Material.SmoothPlastic
					part.Transparency = math.clamp(transparency * 0.6, 0, 0.9)
				else
					part.Color = light
					part.Material = BOTTOM.Glow and Enum.Material.Neon or Enum.Material.SmoothPlastic
					local flicker = entry.welded and 0 or 0.1 * pulse
					part.Transparency = math.clamp(transparency * 0.5 - flicker, 0, 0.9)
				end
			end

			platform.light.Enabled = BOTTOM.Glow
			platform.light.Color = color
			platform.light.Brightness = 1 + pulse * 0.6
			platform.light.Range = 8 * platform.size
		end)
		return function()
			for _, connection in ipairs(connections) do
				connection:Disconnect()
			end
			destroyPlatform()
			folder:Destroy()
		end
	end
	RENDERERS.Bottom(localPlayer, BOTTOM)
end

--------------------------------------------------------------------
-- Меню
--------------------------------------------------------------------
-- Оформление в стиле «стеклянной» тёмно-бордовой панели:
-- сверху логотип, поиск и профиль; слева дерево разделов; справа сетка карточек-модулей в две колонки.
-- Клик по карточке включает/выключает функцию, «⋮» открывает её настройки.

local C = {
	bgTop = Color3.fromRGB(92, 32, 44),
	bgBottom = Color3.fromRGB(38, 14, 20),
	panel = Color3.fromRGB(30, 11, 16),
	card = Color3.fromRGB(80, 30, 40),
	cardHover = Color3.fromRGB(98, 38, 50),
	inner = Color3.fromRGB(52, 19, 27),
	accent = Color3.fromRGB(250, 90, 106),
	accentDim = Color3.fromRGB(140, 56, 70),
	off = Color3.fromRGB(104, 76, 82),
	text = Color3.fromRGB(255, 250, 251),
	sub = Color3.fromRGB(226, 204, 209),
	line = Color3.fromRGB(160, 88, 100),
}

-- Внешний вид меню (раздел Themes), сохраняется в конфиги
local MENU_STYLE = {
	Theme = "Бордовый",
	Blur = true,   -- размытие мира за открытым меню
	Toasts = true, -- всплывающие уведомления при включении/выключении функций
	MenuKey = "RightControl", -- клавиша открытия/закрытия меню (название клавиши Enum.KeyCode)
	Preview = true, -- окно справа от меню: ваш аватар с включёнными визуалами
	-- «PNG картинка»: картинка-украшение рядом с меню (как девочка-стикер у меню из примера)
	Decor = false,
	DecorPosition = "Сверху справа", -- см. DECOR_POSITIONS
	DecorSize = 170,                 -- высота картинки в пикселях (при масштабе меню 1)
	DecorTransparency = 0,
	DecorLayer = "На меню",          -- «На меню» — поверх окна, «За меню» — позади окна
	Glass = true,      -- «стеклянное» меню: сквозь окно видно размытый мир
	GlassLevel = 0.45, -- насколько прозрачное стекло (0 — матовое, 0.8 — почти прозрачное)
}

-- где стоит «PNG картинка» относительно окна меню
local DECOR_POSITIONS = { "Сверху справа", "Сверху слева", "Слева от меню", "Снизу справа" }
local DECOR_LAYERS = { "На меню", "За меню" }

-- Клавиши, назначенные функциям: ["Hat"] = "H". Сохраняются в конфиги.
local KEYBINDS = {}

local function new(className, props)
	local obj = Instance.new(className)
	for key, value in pairs(props) do
		if key ~= "Parent" then
			obj[key] = value
		end
	end
	if props.Parent then
		obj.Parent = props.Parent
	end
	return obj
end

local function round(obj, radius)
	return new("UICorner", { CornerRadius = UDim.new(0, radius), Parent = obj })
end

local function outline(obj, color, transparency)
	return new("UIStroke", {
		Color = color,
		Transparency = transparency,
		Thickness = 1,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Parent = obj,
	})
end

-- Иконки из простых фигур (без картинок). Возвращает функцию, которая перекрашивает иконку.
local function drawIcon(parent, kind, size)
	local holder = new("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(size, size),
		BackgroundTransparency = 1,
		Parent = parent,
	})
	local fills, strokes = {}, {}
	local full = UDim.new(1, 0)
	local s = size
	local thin = math.max(2, math.floor(s * 0.16 + 0.5))

	local function fill(dx, dy, w, h, radius, rotation)
		local part = new("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, dx, 0.5, dy),
			Size = UDim2.fromOffset(w, h),
			BorderSizePixel = 0,
			Rotation = rotation or 0,
			Parent = holder,
		})
		if radius then
			new("UICorner", { CornerRadius = radius, Parent = part })
		end
		table.insert(fills, part)
	end

	local function ring(w)
		local part = new("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromOffset(w, w),
			BackgroundTransparency = 1,
			Parent = holder,
		})
		new("UICorner", { CornerRadius = full, Parent = part })
		table.insert(strokes, new("UIStroke", { Thickness = math.max(1, thin - 1), Parent = part }))
	end

	if kind == "eye" then
		ring(s * 0.85)
		fill(0, 0, s * 0.34, s * 0.34, full)
	elseif kind == "ring" then
		ring(s * 0.8)
	elseif kind == "diamond" then
		fill(0, 0, s * 0.62, s * 0.62, UDim.new(0, 2), 45)
	elseif kind == "dots" then
		for _, d in ipairs({ { -1, -1 }, { 1, -1 }, { -1, 1 }, { 1, 1 } }) do
			fill(d[1] * s * 0.22, d[2] * s * 0.22, s * 0.32, s * 0.32, full)
		end
	elseif kind == "bars" then
		for i = -1, 1 do
			fill(0, i * s * 0.3, s * 0.85, thin, full)
		end
	elseif kind == "plus" then
		fill(0, 0, s * 0.85, thin, full)
		fill(0, 0, thin, s * 0.85, full)
	elseif kind == "x" then
		fill(0, 0, s * 0.85, thin, full, 45)
		fill(0, 0, s * 0.85, thin, full, -45)
	elseif kind == "kebab" then -- три точки вертикально (меню карточки)
		for i = -1, 1 do
			fill(0, i * s * 0.32, thin + 1, thin + 1, full)
		end
	elseif kind == "search" then -- лупа
		local lens = new("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, -s * 0.1, 0.5, -s * 0.1),
			Size = UDim2.fromOffset(s * 0.58, s * 0.58),
			BackgroundTransparency = 1,
			Parent = holder,
		})
		new("UICorner", { CornerRadius = full, Parent = lens })
		table.insert(strokes, new("UIStroke", { Thickness = math.max(1, thin - 1), Parent = lens }))
		fill(s * 0.25, s * 0.25, s * 0.34, thin, full, 45)
	elseif kind == "chevron" then -- «v»; поворачивайте holder, чтобы получить < или >
		fill(-s * 0.16, 0, s * 0.5, thin, full, 45)
		fill(s * 0.16, 0, s * 0.5, thin, full, -45)
	elseif kind == "square" then -- пустой квадрат (бокс)
		local square = new("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromOffset(s * 0.62, s * 0.8),
			BackgroundTransparency = 1,
			Parent = holder,
		})
		table.insert(strokes, new("UIStroke", { Thickness = math.max(1, thin - 1), Parent = square }))
	elseif kind == "tracer" then -- линия снизу к точке
		fill(0, s * 0.05, s * 0.75, thin, full, -60)
		fill(s * 0.2, -s * 0.3, thin + 2, thin + 2, full)
	elseif kind == "palette" then
		fill(0, -s * 0.22, s * 0.36, s * 0.36, full)
		fill(-s * 0.22, s * 0.16, s * 0.36, s * 0.36, full)
		fill(s * 0.22, s * 0.16, s * 0.36, s * 0.36, full)
	else -- "dot"
		fill(0, 0, s * 0.5, s * 0.5, full)
	end

	return function(color)
		for _, part in ipairs(fills) do
			part.BackgroundColor3 = color
		end
		for _, stroke in ipairs(strokes) do
			stroke.Color = color
		end
	end
end

-- Логотип: наш прежний знак — ромб, разрезанный крестом на 4 части, — в стиле образца:
-- чёрный фон, фиолетовые кристаллические части со светлой гранёной кромкой и переливом,
-- у крупного логотипа рядом россыпь мелких кристаллов.
local LOGO_BG = Color3.fromRGB(8, 6, 12)
local CRYSTAL_RIM = Color3.fromRGB(226, 216, 255)
local CRYSTAL_TOP = Color3.fromRGB(176, 156, 248)
local CRYSTAL_BOTTOM = Color3.fromRGB(112, 90, 204)

local function drawLogoMark(square, size)
	local markSize = math.floor(size * 0.52 + 0.5)
	local rim = math.max(1, math.floor(size * 0.025 + 0.5))
	-- кромка рисуется снаружи каждой части, поэтому щель шире двух кромок — иначе части сольются
	local gap = rim * 2 + math.max(1, math.floor(size * 0.025 + 0.5))
	local tile = (markSize - gap) / 2

	-- ромб = квадрат, повёрнутый на 45°
	local mark = new("Frame", {
		Name = "LogoMark",
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(markSize, markSize),
		Rotation = 45,
		BackgroundTransparency = 1,
		Parent = square,
	})
	mark:SetAttribute("KeepColor", true)

	for row = 0, 1 do
		for column = 0, 1 do
			-- Стеклянная часть: полупрозрачная тонированная заливка (сквозь неё видно фон),
			-- яркая тонкая кромка и глянцевый блик на верхней половине.
			local corner = math.max(1, math.floor(size * 0.03))
			local piece = new("Frame", {
				Position = UDim2.fromOffset(column * (tile + gap), row * (tile + gap)),
				Size = UDim2.fromOffset(tile, tile),
				BackgroundColor3 = Color3.new(1, 1, 1),
				BackgroundTransparency = 0.25,
				BorderSizePixel = 0,
				Parent = mark,
			})
			round(piece, corner)
			piece:SetAttribute("KeepColor", true)

			-- цвет: сверху светлее, снизу насыщеннее; прозрачность: сверху плотнее, снизу как стекло
			-- (поворот 45° компенсирует наклон ромба, чтобы градиент шёл сверху вниз по экрану)
			new("UIGradient", {
				Rotation = 45,
				Color = ColorSequence.new(CRYSTAL_TOP, CRYSTAL_BOTTOM),
				Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 0.1),
					NumberSequenceKeypoint.new(0.5, 0.45),
					NumberSequenceKeypoint.new(1, 0.6),
				}),
				Parent = piece,
			})

			-- яркая кромка, как у грани стекла
			local stroke = new("UIStroke", {
				Color = CRYSTAL_RIM,
				Thickness = rim,
				Transparency = 0.1,
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Parent = piece,
			})
			stroke:SetAttribute("KeepColor", true)

			-- глянцевый блик: светлая «плёнка» на верхней половине, тающая книзу
			local gloss = new("Frame", {
				Size = UDim2.fromScale(1, 1),
				BackgroundColor3 = Color3.new(1, 1, 1),
				BackgroundTransparency = 0.45,
				BorderSizePixel = 0,
				Parent = piece,
			})
			round(gloss, corner)
			gloss:SetAttribute("KeepColor", true)
			new("UIGradient", {
				Rotation = 45,
				Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 0.2),
					NumberSequenceKeypoint.new(0.42, 0.75),
					NumberSequenceKeypoint.new(0.45, 1),
					NumberSequenceKeypoint.new(1, 1),
				}),
				Parent = gloss,
			})
		end
	end

	-- россыпь мелких кристаллов (только у крупного логотипа)
	if size >= 48 then
		for _, gem in ipairs({
			{ 0.17, 0.22, 0.05 }, { 0.24, 0.16, 0.06 }, { 0.2, 0.3, 0.04 }, { 0.28, 0.27, 0.035 },
			{ 0.8, 0.7, 0.05 }, { 0.85, 0.79, 0.06 }, { 0.75, 0.83, 0.035 },
		}) do
			local d = math.max(2, math.floor(gem[3] * size))
			local dot = new("Frame", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(gem[1], gem[2]),
				Size = UDim2.fromOffset(d, d),
				BackgroundColor3 = CRYSTAL_TOP,
				BackgroundTransparency = 0.45,
				BorderSizePixel = 0,
				Parent = square,
			})
			round(dot, d)
			local dotStroke = new("UIStroke", { Color = CRYSTAL_RIM, Thickness = 1, Transparency = 0.05, Parent = dot })
			dot:SetAttribute("KeepColor", true)
			dotStroke:SetAttribute("KeepColor", true)
		end
	end

	return mark
end

--------------------------------------------------------------------
-- Каркас окна
--------------------------------------------------------------------
local screenGui = new("ScreenGui", {
	Name = "ESP_Menu",
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling, -- содержимое окна всегда поверх самого окна
	ResetOnSpawn = false,
	DisplayOrder = 100,
	-- Меню скрыто, пока строится и пока идёт заставка. Раньше оно было видно с первой секунды:
	-- скрипт ждёт серверную часть конфигов (до 3 секунд), и всё это время на экране висело меню.
	Enabled = false,
	Parent = playerGui,
})

local frame = new("Frame", {
	Name = "Window",
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.fromScale(0.5, 0.5), -- по центру экрана
	Size = UDim2.fromOffset(600, 400),
	BackgroundTransparency = 1, -- сам контейнер прозрачный, фон — отдельным слоем ниже
	BorderSizePixel = 0,
	ClipsDescendants = true,
	Parent = screenGui,
})
round(frame, 12)
outline(frame, C.line, 0.35)

-- Фон окна — отдельный слой в самом низу, под всем содержимым.
-- Окно — обычный Frame: цвет фона никак не влияет на текст, карточки и иконки.
local windowBackground = new("Frame", {
	Name = "Background",
	Size = UDim2.fromScale(1, 1),
	BackgroundColor3 = Color3.fromRGB(255, 255, 255),
	BackgroundTransparency = 0.04,
	BorderSizePixel = 0,
	ZIndex = 0,
	Parent = frame,
})
round(windowBackground, 12)

-- тонкий светлый блик по верхнему краю и мягкое осветление сверху — эффект стекла
new("Frame", {
	Position = UDim2.fromOffset(14, 0),
	Size = UDim2.new(1, -28, 0, 1),
	BackgroundColor3 = Color3.fromRGB(255, 255, 255),
	BackgroundTransparency = 0.82,
	BorderSizePixel = 0,
	ZIndex = 0,
	Parent = frame,
})
local sheen = new("Frame", {
	Size = UDim2.new(1, 0, 0.45, 0),
	BackgroundColor3 = Color3.fromRGB(255, 255, 255),
	BackgroundTransparency = 0.94,
	BorderSizePixel = 0,
	ZIndex = 0,
	Parent = frame,
})
round(sheen, 12)
new("UIGradient", {
	Rotation = 90,
	Transparency = NumberSequence.new(0, 1),
	Parent = sheen,
})
new("UIGradient", {
	Color = ColorSequence.new(C.bgTop, C.bgBottom),
	Rotation = 55,
	Parent = windowBackground,
})

-- Верхняя панель: логотип, поиск, профиль
local topBar = new("Frame", {
	Size = UDim2.new(1, 0, 0, 48),
	BackgroundTransparency = 1,
	Parent = frame,
})

new("Frame", { -- разделитель под верхней панелью
	Position = UDim2.new(0, 0, 1, -1),
	Size = UDim2.new(1, 0, 0, 1),
	BackgroundColor3 = C.line,
	BackgroundTransparency = 0.6,
	BorderSizePixel = 0,
	Parent = topBar,
})

local logo = new("Frame", {
	Position = UDim2.fromOffset(14, 11),
	Size = UDim2.fromOffset(26, 26),
	BackgroundColor3 = LOGO_BG,
	BorderSizePixel = 0,
	Parent = topBar,
})
round(logo, 6)
outline(logo, C.line, 0.5)
drawLogoMark(logo, 26)

local brand = new("Frame", {
	Position = UDim2.fromOffset(48, 0),
	Size = UDim2.fromOffset(144, 48),
	BackgroundTransparency = 1,
	Parent = topBar,
})
new("UIListLayout", {
	FillDirection = Enum.FillDirection.Horizontal,
	VerticalAlignment = Enum.VerticalAlignment.Center,
	Padding = UDim.new(0, 5),
	SortOrder = Enum.SortOrder.LayoutOrder,
	Parent = brand,
})
new("TextLabel", {
	LayoutOrder = 1,
	AutomaticSize = Enum.AutomaticSize.X,
	Size = UDim2.fromOffset(0, 20),
	BackgroundTransparency = 1,
	Font = Enum.Font.GothamBlack,
	TextSize = 16,
	TextColor3 = C.text,
	Text = "OPUS",
	Parent = brand,
})
new("TextLabel", {
	LayoutOrder = 2,
	AutomaticSize = Enum.AutomaticSize.X,
	Size = UDim2.fromOffset(0, 20),
	BackgroundTransparency = 1,
	Font = Enum.Font.Gotham,
	TextSize = 14,
	TextColor3 = C.sub,
	Text = "client",
	Parent = brand,
})
-- версия клиента рядом с названием: «OPUS client v1.5»
local CLIENT_VERSION = "v1.5"
new("TextLabel", {
	LayoutOrder = 3,
	AutomaticSize = Enum.AutomaticSize.X,
	Size = UDim2.fromOffset(0, 20),
	BackgroundTransparency = 1,
	Font = Enum.Font.GothamBold,
	TextSize = 12,
	TextColor3 = C.accent,
	Text = CLIENT_VERSION,
	Parent = brand,
})

local searchBox = new("Frame", {
	Position = UDim2.fromOffset(198, 9),
	Size = UDim2.new(1, -198 - 176, 0, 30),
	BackgroundColor3 = C.panel,
	BackgroundTransparency = 0.3,
	BorderSizePixel = 0,
	Parent = topBar,
})
round(searchBox, 8)
outline(searchBox, C.line, 0.6)

local searchIcon = new("Frame", {
	Position = UDim2.fromOffset(8, 7),
	Size = UDim2.fromOffset(16, 16),
	BackgroundTransparency = 1,
	Parent = searchBox,
})
drawIcon(searchIcon, "search", 14)(C.sub)

local search = new("TextBox", {
	Position = UDim2.fromOffset(28, 0),
	Size = UDim2.new(1, -36, 1, 0),
	BackgroundTransparency = 1,
	Font = Enum.Font.Gotham,
	TextSize = 13,
	TextXAlignment = Enum.TextXAlignment.Left,
	TextColor3 = C.text,
	PlaceholderText = "Поиск...",
	PlaceholderColor3 = C.sub,
	ClearTextOnFocus = false,
	Text = "",
	Parent = searchBox,
})

new("TextLabel", {
	Position = UDim2.new(1, -170, 0, 8),
	Size = UDim2.fromOffset(120, 18),
	BackgroundTransparency = 1,
	Font = Enum.Font.GothamBold,
	TextSize = 13,
	TextXAlignment = Enum.TextXAlignment.Right,
	TextColor3 = C.text,
	TextTruncate = Enum.TextTruncate.AtEnd,
	Text = localPlayer.DisplayName,
	Parent = topBar,
})

new("TextLabel", {
	Position = UDim2.new(1, -170, 0, 25),
	Size = UDim2.fromOffset(120, 14),
	BackgroundTransparency = 1,
	Font = Enum.Font.Gotham,
	TextSize = 11,
	TextXAlignment = Enum.TextXAlignment.Right,
	TextColor3 = C.sub,
	TextTruncate = Enum.TextTruncate.AtEnd,
	Text = "@" .. localPlayer.Name,
	Parent = topBar,
})

local avatar = new("ImageLabel", {
	Position = UDim2.new(1, -44, 0, 8),
	Size = UDim2.fromOffset(32, 32),
	BackgroundColor3 = C.card,
	BorderSizePixel = 0,
	Parent = topBar,
})
round(avatar, 16)
outline(avatar, C.accent, 0.3)

task.spawn(function()
	local ok, image = pcall(function()
		return Players:GetUserThumbnailAsync(localPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
	end)
	if ok then
		avatar.Image = image
	end
end)

-- Перетаскивание окна за верхнюю панель
local dragging, dragStart, startPos
topBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = frame.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging
		and (input.UserInputType == Enum.UserInputType.MouseMovement
			or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - dragStart
		frame.Position = UDim2.new(
			startPos.X.Scale, startPos.X.Offset + delta.X,
			startPos.Y.Scale, startPos.Y.Offset + delta.Y
		)
	end
end)

--------------------------------------------------------------------
-- Боковая панель (дерево разделов)
--------------------------------------------------------------------
local sidebar = new("Frame", {
	Position = UDim2.fromOffset(0, 48),
	Size = UDim2.new(0, 150, 1, -48),
	BackgroundColor3 = C.panel,
	BackgroundTransparency = 0.45,
	BorderSizePixel = 0,
	Parent = frame,
})
round(sidebar, 12)

new("Frame", { -- разделитель справа от боковой панели
	Position = UDim2.new(1, -1, 0, 0),
	Size = UDim2.new(0, 1, 1, 0),
	BackgroundColor3 = C.line,
	BackgroundTransparency = 0.6,
	BorderSizePixel = 0,
	Parent = sidebar,
})

local sidebarList = new("Frame", {
	Size = UDim2.new(1, 0, 1, -30),
	BackgroundTransparency = 1,
	Parent = sidebar,
})
new("UIPadding", {
	PaddingTop = UDim.new(0, 10),
	PaddingLeft = UDim.new(0, 8),
	PaddingRight = UDim.new(0, 9),
	Parent = sidebarList,
})
new("UIListLayout", {
	Padding = UDim.new(0, 2),
	SortOrder = Enum.SortOrder.LayoutOrder,
	Parent = sidebarList,
})

local menuHint = new("TextLabel", {
	Position = UDim2.new(0, 8, 1, -50),
	Size = UDim2.new(1, -16, 0, 44),
	BackgroundTransparency = 1,
	Font = Enum.Font.Gotham,
	TextSize = 11,
	TextWrapped = true,
	TextColor3 = C.sub,
	Text = "RightControl — меню\nПКМ по карточке — клавиша\ntgk: opus_client_rbx",
	Parent = sidebar,
})

-- Группы разделов (как «Modules» и «Server» в примере): заголовок + вложенные пункты с линией дерева
local groups = {}
local groupOrder = 0

local function createGroup(name, iconKind)
	groupOrder += 1

	local header = new("TextButton", {
		LayoutOrder = groupOrder * 2 - 1,
		Size = UDim2.new(1, 0, 0, 32),
		BackgroundColor3 = C.accentDim,
		BackgroundTransparency = 1,
		AutoButtonColor = false,
		Text = "",
		Parent = sidebarList,
	})
	round(header, 7)

	local iconHolder = new("Frame", {
		Position = UDim2.new(0, 8, 0.5, -9),
		Size = UDim2.fromOffset(18, 18),
		BackgroundTransparency = 1,
		Parent = header,
	})
	local setIcon = drawIcon(iconHolder, iconKind, 14)

	local label = new("TextLabel", {
		Position = UDim2.fromOffset(32, 0),
		Size = UDim2.new(1, -52, 1, 0),
		BackgroundTransparency = 1,
		Font = Enum.Font.GothamBold,
		TextSize = 14,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextColor3 = C.sub,
		Text = name,
		Parent = header,
	})

	local arrow = new("Frame", {
		Position = UDim2.new(1, -22, 0.5, -7),
		Size = UDim2.fromOffset(14, 14),
		BackgroundTransparency = 1,
		Parent = header,
	})
	drawIcon(arrow, "chevron", 10)(C.sub)

	local list = new("Frame", {
		LayoutOrder = groupOrder * 2,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		Parent = sidebarList,
	})
	new("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Parent = list })
	new("UIPadding", { PaddingBottom = UDim.new(0, 8), Parent = list })

	header.MouseButton1Click:Connect(function()
		list.Visible = not list.Visible
		arrow.Rotation = list.Visible and 0 or -90
	end)
	header.MouseEnter:Connect(function()
		label.TextColor3 = C.text
	end)
	header.MouseLeave:Connect(function()
		label.TextColor3 = groups[name].active and C.text or C.sub
	end)

	groups[name] = { header = header, label = label, setIcon = setIcon, list = list, sections = {}, active = false }
	return groups[name]
end

createGroup("Modules", "diamond")
createGroup("Settings", "plus")

--------------------------------------------------------------------
-- Правая часть: хлебные крошки, сетка карточек и страницы настроек
--------------------------------------------------------------------
local content = new("Frame", {
	Position = UDim2.fromOffset(162, 48),
	Size = UDim2.new(1, -174, 1, -58),
	BackgroundTransparency = 1,
	Parent = frame,
})

local backButton = new("TextButton", {
	Position = UDim2.fromOffset(0, 6),
	Size = UDim2.fromOffset(22, 22),
	BackgroundColor3 = C.card,
	BackgroundTransparency = 0.2,
	AutoButtonColor = true,
	Text = "",
	Visible = false,
	Parent = content,
})
round(backButton, 6)
local backIcon = new("Frame", {
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.fromScale(0.5, 0.5),
	Size = UDim2.fromOffset(12, 12),
	Rotation = 90, -- «v», повёрнутая на 90°, становится «<»
	BackgroundTransparency = 1,
	Parent = backButton,
})
drawIcon(backIcon, "chevron", 10)(C.text)

local breadcrumb = new("TextLabel", {
	Position = UDim2.fromOffset(2, 6),
	Size = UDim2.new(1, -2, 0, 22),
	BackgroundTransparency = 1,
	Font = Enum.Font.Gotham,
	TextSize = 14,
	TextXAlignment = Enum.TextXAlignment.Left,
	TextColor3 = C.sub,
	RichText = true,
	Text = "",
	Parent = content,
})

local counterLabel = new("TextLabel", {
	AnchorPoint = Vector2.new(1, 0),
	Position = UDim2.new(1, -6, 0, 6),
	Size = UDim2.fromOffset(170, 22),
	BackgroundTransparency = 1,
	Font = Enum.Font.Gotham,
	TextSize = 12,
	TextXAlignment = Enum.TextXAlignment.Right,
	TextColor3 = C.sub,
	RichText = true,
	Text = "",
	Parent = content,
})

local function makeScroller(name)
	local scroller = new("ScrollingFrame", {
		Name = name,
		Position = UDim2.fromOffset(0, 36),
		Size = UDim2.new(1, 0, 1, -36),
		CanvasSize = UDim2.new(),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ScrollingDirection = Enum.ScrollingDirection.Y,
		ScrollBarThickness = 3,
		ScrollBarImageColor3 = C.accent,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Visible = false,
		Parent = content,
	})
	new("UIPadding", {
		PaddingTop = UDim.new(0, 1),
		PaddingLeft = UDim.new(0, 1),
		PaddingRight = UDim.new(0, 7),
		PaddingBottom = UDim.new(0, 2),
		Parent = scroller,
	})
	return scroller
end

local sections = {}      -- [название] = { grid, cards, nav }
local uiRefreshers = {}  -- функции, которые перерисовывают элементы меню по текущим значениям
local sectionOrder = 0
local currentSection = nil
local currentModule = nil -- открытая страница настроек

local function updateCounter()
	local section = sections[currentSection]
	if currentModule or not section or #section.modules == 0 then
		counterLabel.Text = ""
		return
	end
	local on = 0
	for _, def in ipairs(section.modules) do
		if def.source[def.key] then
			on += 1
		end
	end
	counterLabel.Text = string.format('<font color="#FFFAFB"><b>%d</b></font> из %d включено', on, #section.modules)
end

local function crumbs(...)
	local section = sections[currentSection]
	local parts = { section and section.group or "Modules" }
	for _, part in ipairs({ ... }) do
		table.insert(parts, part)
	end
	local last = table.remove(parts)
	local text = table.concat(parts, "  /  ")
	return text .. '  /  <font color="#FFFAFB"><b>' .. last .. "</b></font>"
end

-- Плавное появление страницы: она чуть «всплывает» снизу
local function slideIn(page)
	page.Position = UDim2.fromOffset(0, 48)
	TweenService:Create(page, TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
		Position = UDim2.fromOffset(0, 36),
	}):Play()
end

-- Поиск по всем разделам сразу (результаты собираются на отдельной странице)
local searchGrid = nil
local searchQuery = ""
local searchFound = 0

local function showGrid()
	if currentModule then
		currentModule.page.Visible = false
		currentModule = nil
	end
	local searching = searchGrid ~= nil and searchQuery ~= ""
	for name, section in pairs(sections) do
		local visible = not searching and name == currentSection
		if visible and not section.grid.Visible then
			slideIn(section.grid)
		end
		section.grid.Visible = visible
	end
	if searchGrid then
		searchGrid.Visible = searching
	end
	backButton.Visible = false
	breadcrumb.Position = UDim2.fromOffset(2, 6)
	if searching then
		local safeQuery = searchQuery:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")
		breadcrumb.Text = 'Поиск  /  <font color="#FFFAFB"><b>' .. safeQuery .. "</b></font>"
		counterLabel.Text = searchFound > 0 and string.format("найдено: %d", searchFound) or "ничего не найдено"
	else
		breadcrumb.Text = crumbs(currentSection)
		updateCounter()
	end
end

local function selectSection(name)
	if search.Text ~= "" then
		search.Text = "" -- выбор раздела сбрасывает поиск
	end
	currentSection = name
	for sectionName, section in pairs(sections) do
		local active = sectionName == name
		section.nav.setIcon(active and C.accent or C.sub)
		section.nav.label.TextColor3 = active and C.text or C.sub
		section.nav.label.Font = active and Enum.Font.GothamBold or Enum.Font.Gotham
		section.nav.pill.Visible = active
	end
	for _, group in pairs(groups) do
		group.active = group.sections[name] == true
		group.header.BackgroundTransparency = group.active and 0.35 or 1
		group.label.TextColor3 = group.active and C.text or C.sub
		group.setIcon(group.active and C.accent or C.sub)
	end
	showGrid()
end

local function openSettings(module)
	for _, section in pairs(sections) do
		section.grid.Visible = false
	end
	if searchGrid then
		searchGrid.Visible = false
	end
	if currentModule then
		currentModule.page.Visible = false
	end
	currentModule = module
	module.page.Visible = true
	slideIn(module.page)
	backButton.Visible = true
	breadcrumb.Position = UDim2.fromOffset(30, 6)
	breadcrumb.Text = crumbs(currentSection, module.name)
	updateCounter()
end

backButton.MouseButton1Click:Connect(showGrid)

-- Поиск: ищет по названию и описанию во ВСЕХ разделах и показывает результаты одной сеткой
searchGrid = makeScroller("SearchResults")
new("UIGridLayout", {
	CellSize = UDim2.new(0.5, -5, 0, 66),
	CellPadding = UDim2.fromOffset(10, 10),
	SortOrder = Enum.SortOrder.LayoutOrder,
	Parent = searchGrid,
})

local function restoreSearchCards()
	for _, section in pairs(sections) do
		for _, entry in ipairs(section.cards) do
			if entry.frame.Parent == searchGrid then
				entry.frame.Parent = section.grid
				entry.frame.LayoutOrder = entry.homeOrder or entry.frame.LayoutOrder
			end
		end
	end
end

search:GetPropertyChangedSignal("Text"):Connect(function()
	restoreSearchCards()
	searchQuery = search.Text:gsub("^%s+", ""):gsub("%s+$", "")
	searchFound = 0

	if searchQuery ~= "" then
		local query = searchQuery:lower()
		local ordered = {}
		for _, section in pairs(sections) do
			table.insert(ordered, section)
		end
		table.sort(ordered, function(a, b)
			return a.order < b.order
		end)
		for _, section in ipairs(ordered) do
			for _, entry in ipairs(section.cards) do
				local haystack = (entry.name .. " " .. entry.desc):lower()
				if entry.frame.Parent and haystack:find(query, 1, true) then
					searchFound += 1
					entry.homeOrder = entry.homeOrder or entry.frame.LayoutOrder
					entry.frame.Parent = searchGrid
					entry.frame.LayoutOrder = searchFound
				end
			end
		end
	end

	if currentModule then
		currentModule.page.Visible = false
		currentModule = nil
	end
	showGrid()
end)

local SECTION_ICONS = {
	ESP = "eye",
	Visuals = "diamond",
	Misc = "dots",
	["Образы"] = "eye",
	Config = "bars",
	Themes = "palette",
}

local function createSection(name, groupName)
	sectionOrder += 1
	groupName = groupName or "Modules"
	local group = groups[groupName]
	group.sections[name] = true

	local nav = new("TextButton", {
		LayoutOrder = sectionOrder,
		Size = UDim2.new(1, 0, 0, 28),
		BackgroundTransparency = 1,
		AutoButtonColor = false,
		Text = "",
		Parent = group.list,
	})

	-- мягкая подложка под активным пунктом
	local pill = new("Frame", {
		Position = UDim2.fromOffset(24, 3),
		Size = UDim2.new(1, -24, 1, -6),
		BackgroundColor3 = C.accentDim,
		BackgroundTransparency = 0.6,
		BorderSizePixel = 0,
		Visible = false,
		Parent = nav,
	})
	round(pill, 6)

	new("Frame", { -- вертикальная линия дерева
		Position = UDim2.fromOffset(16, 0),
		Size = UDim2.new(0, 1, 1, 0),
		BackgroundColor3 = C.line,
		BackgroundTransparency = 0.3,
		BorderSizePixel = 0,
		Parent = nav,
	})

	new("Frame", { -- горизонтальная ветка дерева
		Position = UDim2.new(0, 16, 0.5, 0),
		Size = UDim2.fromOffset(8, 1),
		BackgroundColor3 = C.line,
		BackgroundTransparency = 0.3,
		BorderSizePixel = 0,
		Parent = nav,
	})

	local iconHolder = new("Frame", {
		Position = UDim2.new(0, 28, 0.5, -7),
		Size = UDim2.fromOffset(14, 14),
		BackgroundTransparency = 1,
		Parent = nav,
	})
	local setIcon = drawIcon(iconHolder, SECTION_ICONS[name] or "dot", 11)
	setIcon(C.sub)

	local label = new("TextLabel", {
		Position = UDim2.fromOffset(48, 0),
		Size = UDim2.new(1, -48, 1, 0),
		BackgroundTransparency = 1,
		Font = Enum.Font.Gotham,
		TextSize = 14,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextColor3 = C.sub,
		Text = name,
		Parent = nav,
	})

	local grid = makeScroller(name .. "_Grid")
	new("UIGridLayout", {
		CellSize = UDim2.new(0.5, -5, 0, 66),
		CellPadding = UDim2.fromOffset(10, 10),
		SortOrder = Enum.SortOrder.LayoutOrder,
		Parent = grid,
	})

	sections[name] = {
		grid = grid,
		cards = {},
		modules = {},
		group = groupName,
		order = sectionOrder,
		nav = { setIcon = setIcon, label = label, pill = pill },
	}

	nav.MouseEnter:Connect(function()
		if currentSection ~= name then
			label.TextColor3 = C.text
		end
	end)
	nav.MouseLeave:Connect(function()
		if currentSection ~= name then
			label.TextColor3 = C.sub
		end
	end)

	nav.MouseButton1Click:Connect(function()
		selectSection(name)
	end)

	return sections[name]
end

--------------------------------------------------------------------
-- Строки страницы настроек
--------------------------------------------------------------------
-- Звуки при включении/выключении функций (раздел Misc)
local SoundService = game:GetService("SoundService")

local SOUNDS = {
	Enabled = true,
	Style = "Пинг",  -- "Пинг", "Клик" или "Кнопка"
	Volume = 0.5,
	OnPitch = 1.25,  -- высота звука при включении
	OffPitch = 0.85, -- высота звука при выключении
}

local SOUND_STYLES = { "Пинг", "Клик", "Кнопка" }

-- Встроенные звуки Roblox. Можно заменить на свои "rbxassetid://...".
local SOUND_IDS = {
	["Пинг"] = "rbxasset://sounds/electronicpingshort.wav",
	["Клик"] = "rbxasset://sounds/clickfast.wav",
	["Кнопка"] = "rbxasset://sounds/button.wav",
}

local toggleSound = Instance.new("Sound")
toggleSound.Name = "MenuToggleSound"
toggleSound.Parent = SoundService

local function playToggleSound(on)
	if not SOUNDS.Enabled then
		return
	end
	toggleSound.SoundId = SOUND_IDS[SOUNDS.Style] or SOUND_IDS["Пинг"]
	toggleSound.Volume = SOUNDS.Volume
	toggleSound.PlaybackSpeed = on and SOUNDS.OnPitch or SOUNDS.OffPitch
	toggleSound.TimePosition = 0
	toggleSound:Play()
end

local COLOR_PRESETS = {
	Color3.fromRGB(255, 90, 90),    -- красный
	Color3.fromRGB(255, 160, 60),   -- оранжевый
	Color3.fromRGB(255, 230, 90),   -- жёлтый
	Color3.fromRGB(90, 220, 120),   -- зелёный
	Color3.fromRGB(90, 230, 230),   -- голубой
	Color3.fromRGB(90, 170, 255),   -- голубовато-синий
	Color3.fromRGB(150, 185, 255),  -- небесный (как линии созвездий)
	Color3.fromRGB(50, 90, 255),    -- синий
	Color3.fromRGB(30, 50, 170),    -- тёмно-синий
	Color3.fromRGB(170, 110, 255),  -- фиолетовый
	Color3.fromRGB(255, 120, 200),  -- розовый
	Color3.fromRGB(255, 255, 255),  -- белый
	Color3.fromRGB(180, 190, 210),  -- серо-голубой
	Color3.fromRGB(60, 60, 70),     -- тёмно-серый
	Color3.fromRGB(15, 15, 15),     -- чёрный
}

local glassRows = {}

local function settingRow(page, labelText, height)
	local row = new("Frame", {
		LayoutOrder = #page:GetChildren(),
		Size = UDim2.new(1, 0, 0, height),
		BackgroundColor3 = C.card,
		BackgroundTransparency = 0.2,
		BorderSizePixel = 0,
		Parent = page,
	})
	round(row, 8)
	outline(row, C.line, 0.7)
	table.insert(glassRows, row)
	new("UIGradient", {
		Rotation = 90,
		Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(215, 215, 215)),
		Parent = row,
	})

	new("TextLabel", {
		Position = UDim2.fromOffset(12, 0),
		Size = UDim2.new(1, -140, 0, 38),
		BackgroundTransparency = 1,
		Font = Enum.Font.GothamBold,
		TextSize = 14,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextColor3 = C.text,
		Text = labelText,
		Parent = row,
	})

	return row
end

local function toggleSetting(page, labelText, key, source)
	local row = settingRow(page, labelText, 38)

	local pill = new("Frame", {
		Position = UDim2.new(1, -50, 0.5, -9),
		Size = UDim2.fromOffset(36, 18),
		BackgroundColor3 = C.off,
		BorderSizePixel = 0,
		Parent = row,
	})
	round(pill, 9)

	local knob = new("Frame", {
		Size = UDim2.fromOffset(14, 14),
		BackgroundColor3 = C.text,
		BorderSizePixel = 0,
		Parent = pill,
	})
	round(knob, 7)

	local button = new("TextButton", {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		Text = "",
		Parent = row,
	})

	local function refresh()
		local on = source[key]
		pill.BackgroundColor3 = on and C.accent or C.off
		knob.Position = on and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
	end

	button.MouseButton1Click:Connect(function()
		source[key] = not source[key]
		refresh()
		playToggleSound(source[key])
	end)
	refresh()
	table.insert(uiRefreshers, refresh)
end

-- Строка с текстовым полем (например, имя питомца)
local function textSetting(page, labelText, key, maxLength, source)
	local row = settingRow(page, labelText, 38)

	local box = new("TextBox", {
		Position = UDim2.new(1, -142, 0.5, -12),
		Size = UDim2.fromOffset(130, 24),
		BackgroundColor3 = C.inner,
		BorderSizePixel = 0,
		Font = Enum.Font.Gotham,
		TextSize = 12,
		TextColor3 = C.text,
		PlaceholderText = "пусто",
		PlaceholderColor3 = C.sub,
		ClearTextOnFocus = false,
		Text = tostring(source[key]),
		Parent = row,
	})
	round(box, 6)
	outline(box, C.line, 0.6)

	box.FocusLost:Connect(function()
		source[key] = string.sub(box.Text, 1, maxLength)
		box.Text = source[key]
	end)

	table.insert(uiRefreshers, function()
		box.Text = tostring(source[key])
	end)
end

-- Строка с кнопкой-действием (например, «Проверить звук»)
local function actionSetting(page, labelText, buttonText, callback)
	local row = settingRow(page, labelText, 38)

	local button = new("TextButton", {
		Position = UDim2.new(1, -122, 0.5, -12),
		Size = UDim2.fromOffset(110, 24),
		BackgroundColor3 = C.accent,
		BorderSizePixel = 0,
		AutoButtonColor = true,
		Font = Enum.Font.GothamBold,
		TextSize = 12,
		TextColor3 = C.text,
		Text = buttonText,
		Parent = row,
	})
	round(button, 6)

	button.MouseButton1Click:Connect(callback)
end

-- Ползунок: тяните мышью или впишите точное значение в окошко справа
local activeSlider = nil -- функция, которая двигает ползунок за курсором

UserInputService.InputChanged:Connect(function(input)
	if activeSlider and (input.UserInputType == Enum.UserInputType.MouseMovement
		or input.UserInputType == Enum.UserInputType.Touch) then
		activeSlider(input.Position.X)
	end
end)
UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		activeSlider = nil
	end
end)

local function numberSetting(page, labelText, key, minValue, maxValue, source)
	local row = settingRow(page, labelText, 56)
	local range = maxValue - minValue
	local step = range <= 5 and 0.05 or (range <= 50 and 0.5 or 1)

	local function format(value)
		if step >= 1 then
			return tostring(math.floor(value + 0.5))
		end
		return (string.format("%.2f", value):gsub("0+$", ""):gsub("%.$", ""))
	end

	local box = new("TextBox", {
		Position = UDim2.new(1, -70, 0, 8),
		Size = UDim2.fromOffset(58, 22),
		BackgroundColor3 = C.inner,
		BorderSizePixel = 0,
		Font = Enum.Font.GothamBold,
		TextSize = 12,
		TextColor3 = C.text,
		ClearTextOnFocus = false,
		Text = format(source[key]),
		Parent = row,
	})
	round(box, 6)
	outline(box, C.line, 0.6)

	local track = new("TextButton", {
		Position = UDim2.new(0, 12, 0, 40),
		Size = UDim2.new(1, -24, 0, 6),
		BackgroundColor3 = C.inner,
		BorderSizePixel = 0,
		AutoButtonColor = false,
		Text = "",
		Parent = row,
	})
	round(track, 3)

	local fill = new("Frame", {
		Size = UDim2.fromScale(0, 1),
		BackgroundColor3 = C.accent,
		BorderSizePixel = 0,
		Parent = track,
	})
	round(fill, 3)

	local knob = new("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0, 0.5),
		Size = UDim2.fromOffset(14, 14),
		BackgroundColor3 = C.text,
		BorderSizePixel = 0,
		ZIndex = 2,
		Parent = track,
	})
	round(knob, 7)
	local knobStroke = new("UIStroke", { Color = C.accent, Thickness = 2, Parent = knob })
	local knobScale = new("UIScale", { Parent = knob })

	local function refresh()
		local value = math.clamp(source[key], minValue, maxValue)
		local alpha = range > 0 and (value - minValue) / range or 0
		fill.Size = UDim2.fromScale(alpha, 1)
		knob.Position = UDim2.fromScale(alpha, 0.5)
		knobStroke.Color = C.accent
		if not box:IsFocused() then
			box.Text = format(source[key])
		end
	end

	local function setFromX(x)
		local alpha = math.clamp((x - track.AbsolutePosition.X) / math.max(track.AbsoluteSize.X, 1), 0, 1)
		local value = minValue + alpha * range
		value = math.floor(value / step + 0.5) * step
		source[key] = math.clamp(value, minValue, maxValue)
		refresh()
	end

	track.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			activeSlider = setFromX
			setFromX(input.Position.X)
		end
	end)
	track.MouseEnter:Connect(function()
		TweenService:Create(knobScale, TweenInfo.new(0.1), { Scale = 1.2 }):Play()
	end)
	track.MouseLeave:Connect(function()
		TweenService:Create(knobScale, TweenInfo.new(0.1), { Scale = 1 }):Play()
	end)

	box.FocusLost:Connect(function()
		local value = tonumber(box.Text)
		if value then
			source[key] = math.clamp(value, minValue, maxValue)
		end
		refresh()
	end)

	refresh()
	table.insert(uiRefreshers, refresh)
end

-- Выбор варианта: все варианты видны сразу кнопками-«чипами», нужный выбирается одним кликом
-- (раньше приходилось щёлкать по одной кнопке и перебирать варианты по кругу).
local function choiceSetting(page, labelText, key, options, source)
	local columns = math.min(#options, 3)
	local rows = math.ceil(#options / columns)
	local chipHeight, gap = 28, 6
	local row = settingRow(page, labelText, 38 + rows * (chipHeight + gap) + 4)

	local grid = new("Frame", {
		Position = UDim2.fromOffset(12, 36),
		Size = UDim2.new(1, -24, 0, rows * (chipHeight + gap)),
		BackgroundTransparency = 1,
		Parent = row,
	})
	new("UIGridLayout", {
		CellSize = UDim2.new(1 / columns, -gap, 0, chipHeight),
		CellPadding = UDim2.fromOffset(gap, gap),
		SortOrder = Enum.SortOrder.LayoutOrder,
		Parent = grid,
	})

	local chips = {}

	local function refresh()
		for option, chip in pairs(chips) do
			local selected = source[key] == option
			chip.button.BackgroundColor3 = selected and C.accent or C.inner
			chip.button.TextColor3 = selected and C.text or C.sub
			chip.button.Font = selected and Enum.Font.GothamBold or Enum.Font.Gotham
			chip.stroke.Color = selected and C.accent or C.line
			chip.stroke.Transparency = selected and 0.2 or 0.6
		end
	end

	for index, option in ipairs(options) do
		local button = new("TextButton", {
			LayoutOrder = index,
			BackgroundColor3 = C.inner,
			BorderSizePixel = 0,
			AutoButtonColor = false,
			Font = Enum.Font.Gotham,
			TextSize = 12,
			TextColor3 = C.sub,
			TextTruncate = Enum.TextTruncate.AtEnd,
			Text = tostring(option),
			Parent = grid,
		})
		round(button, 6)
		local stroke = outline(button, C.line, 0.6)
		chips[option] = { button = button, stroke = stroke }

		button.MouseButton1Click:Connect(function()
			if source[key] ~= option then
				source[key] = option
				refresh()
				playToggleSound(true)
			end
		end)
		button.MouseEnter:Connect(function()
			if source[key] ~= option then
				button.TextColor3 = C.text
				stroke.Transparency = 0.3
			end
		end)
		button.MouseLeave:Connect(function()
			refresh()
		end)
	end

	refresh()
	table.insert(uiRefreshers, refresh)
end

local function colorSetting(page, labelText, key, source)
	local row = settingRow(page, labelText, 94)

	local grid = new("Frame", {
		Position = UDim2.fromOffset(12, 36),
		Size = UDim2.new(1, -24, 0, 52),
		BackgroundTransparency = 1,
		Parent = row,
	})
	new("UIGridLayout", {
		CellSize = UDim2.fromOffset(28, 22),
		CellPadding = UDim2.fromOffset(6, 6),
		SortOrder = Enum.SortOrder.LayoutOrder,
		Parent = grid,
	})

	-- цвета сравниваем по округлённым RGB: после загрузки конфига Color3 может отличаться на тысячные
	local function sameColor(a, b)
		if typeof(a) ~= "Color3" or typeof(b) ~= "Color3" then
			return false
		end
		return math.abs(a.R - b.R) < 0.004 and math.abs(a.G - b.G) < 0.004 and math.abs(a.B - b.B) < 0.004
	end

	local swatches = {}
	local function refresh()
		for _, swatch in ipairs(swatches) do
			local selected = sameColor(source[key], swatch.color)
			swatch.ring.Visible = selected
			swatch.ringStroke.Color = C.accent
			swatch.scale.Scale = selected and 1.08 or 1
		end
	end

	for index, color in ipairs(COLOR_PRESETS) do
		local swatch = new("TextButton", {
			LayoutOrder = index,
			AutoButtonColor = false,
			BackgroundColor3 = color,
			BorderSizePixel = 0,
			Text = "",
			Parent = grid,
		})
		round(swatch, 5)
		-- тонкая тёмная кромка, чтобы светлые цвета не сливались с фоном
		new("UIStroke", {
			Color = Color3.fromRGB(0, 0, 0),
			Transparency = 0.6,
			Thickness = 1,
			Parent = swatch,
		})
		local scale = new("UIScale", { Parent = swatch })

		-- рамка выбранного цвета: цветная обводка вокруг образца с отступом
		local ring = new("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.new(1, 7, 1, 7),
			BackgroundTransparency = 1,
			Visible = false,
			Parent = swatch,
		})
		round(ring, 8)
		local ringStroke = new("UIStroke", {
			Color = C.accent,
			Thickness = 2,
			Parent = ring,
		})

		-- образцы палитры не перекрашиваем при смене темы
		swatch:SetAttribute("KeepColor", true)

		swatches[index] = { color = color, ring = ring, ringStroke = ringStroke, scale = scale }

		swatch.MouseButton1Click:Connect(function()
			source[key] = color
			refresh()
			playToggleSound(true)
		end)
		swatch.MouseEnter:Connect(function()
			if not sameColor(source[key], color) then
				scale.Scale = 1.05
			end
		end)
		swatch.MouseLeave:Connect(function()
			refresh()
		end)
	end
	refresh()
	table.insert(uiRefreshers, refresh)
end

--------------------------------------------------------------------
-- Карточка-модуль
--------------------------------------------------------------------

local MODULE_ICONS = {
	["ESP"] = "eye",
	["Подсветка"] = "diamond",
	["Текст над головой"] = "bars",
	["Имена"] = "bars",
	["Дистанция"] = "ring",
	["Здоровье"] = "plus",
	["Союзники"] = "dots",
	["Боксы"] = "square",
	["Трейсеры"] = "tracer",
	["Hat"] = "diamond",
	["Trail"] = "bars",
	["Jump Circle"] = "ring",
	["Particles"] = "dots",
	["Constellations"] = "plus",
	["Fog"] = "bars",
	["Custom Sky"] = "ring",
	["Shaders"] = "diamond",
	["Auras"] = "eye",
	["Back"] = "square",
	["Bottom"] = "ring",
	["Watermark"] = "bars",
	["Custom Cursor"] = "plus",
	["Target ESP"] = "eye",
	["Custom Pet"] = "dot",
	["Hit Effect"] = "x",
	["Toggle Sounds"] = "dots",
	["ArrayList"] = "bars",
	["Я бульба"] = "dot",
	["Hitbox"] = "square",
	["Растяжение экрана"] = "bars",
	["Размытие фона"] = "ring",
	["Уведомления"] = "bars",
	["Предпросмотр"] = "eye",
	["PNG картинка"] = "square",
	["Стекло"] = "diamond",
}

--------------------------------------------------------------------
-- Уведомления в правом нижнем углу: «Hat — включено»
--------------------------------------------------------------------
local showToast
do
	local toastGui = new("ScreenGui", {
		Name = "OpusClient_Toasts",
		ResetOnSpawn = false,
		DisplayOrder = 300,
		Parent = playerGui,
	})
	local toastHolder = new("Frame", {
		AnchorPoint = Vector2.new(1, 1),
		Position = UDim2.new(1, -16, 1, -16),
		Size = UDim2.fromOffset(240, 260),
		BackgroundTransparency = 1,
		Parent = toastGui,
	})
	new("UIListLayout", {
		VerticalAlignment = Enum.VerticalAlignment.Bottom,
		HorizontalAlignment = Enum.HorizontalAlignment.Right,
		Padding = UDim.new(0, 8),
		SortOrder = Enum.SortOrder.LayoutOrder,
		Parent = toastHolder,
	})
	local toastCount = 0

	function showToast(title, on)
		if not MENU_STYLE.Toasts then
			return
		end
		toastCount += 1

		-- не больше четырёх уведомлений одновременно: старые сразу убираем
		local slots = {}
		for _, child in ipairs(toastHolder:GetChildren()) do
			if child:IsA("Frame") then
				table.insert(slots, child)
			end
		end
		table.sort(slots, function(a, b)
			return a.LayoutOrder < b.LayoutOrder
		end)
		for i = 1, #slots - 3 do
			slots[i]:Destroy()
		end

		local slot = new("Frame", {
			LayoutOrder = toastCount,
			Size = UDim2.fromOffset(230, 46),
			BackgroundTransparency = 1,
			Parent = toastHolder,
		})
		local toast = new("Frame", {
			Position = UDim2.fromOffset(260, 0),
			Size = UDim2.fromScale(1, 1),
			BackgroundColor3 = C.bgBottom,
			BackgroundTransparency = 0.04,
			BorderSizePixel = 0,
			Parent = slot,
		})
		round(toast, 8)
		outline(toast, on and C.accent or C.line, 0.3)

		new("Frame", {
			Position = UDim2.fromOffset(8, 9),
			Size = UDim2.new(0, 3, 1, -18),
			BackgroundColor3 = on and C.accent or C.off,
			BorderSizePixel = 0,
			Parent = toast,
		})
		new("TextLabel", {
			Position = UDim2.fromOffset(20, 6),
			Size = UDim2.new(1, -28, 0, 18),
			BackgroundTransparency = 1,
			Font = Enum.Font.GothamBold,
			TextSize = 13,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextTruncate = Enum.TextTruncate.AtEnd,
			TextColor3 = C.text,
			Text = title,
			Parent = toast,
		})
		new("TextLabel", {
			Position = UDim2.fromOffset(20, 24),
			Size = UDim2.new(1, -28, 0, 16),
			BackgroundTransparency = 1,
			Font = Enum.Font.Gotham,
			TextSize = 12,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextColor3 = on and C.accent or C.sub,
			Text = on and "включено" or "выключено",
			Parent = toast,
		})

		TweenService:Create(toast, TweenInfo.new(0.28, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
			Position = UDim2.fromOffset(0, 0),
		}):Play()
		task.delay(1.9, function()
			if not slot.Parent then
				return
			end
			local hide = TweenService:Create(toast, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
				Position = UDim2.fromOffset(260, 0),
			})
			hide:Play()
			hide.Completed:Wait()
			slot:Destroy()
		end)
	end
end

--------------------------------------------------------------------
-- Клавиши для функций: ПКМ по карточке -> нажмите клавишу (Esc/Backspace — убрать)
--------------------------------------------------------------------
local moduleRegistry = {} -- [название] = { toggle = функция }
local bindingTarget = nil -- карточка, которой сейчас назначают клавишу

local function finishBinding()
	if bindingTarget then
		bindingTarget.stop()
		bindingTarget = nil
	end
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if bindingTarget then
		if input.UserInputType == Enum.UserInputType.Keyboard then
			local name = bindingTarget.name
			if input.KeyCode == Enum.KeyCode.Escape or input.KeyCode == Enum.KeyCode.Backspace then
				KEYBINDS[name] = nil
			elseif input.KeyCode ~= CONFIG.MenuKey then
				-- одна клавиша — одна функция
				for otherName, key in pairs(KEYBINDS) do
					if key == input.KeyCode.Name then
						KEYBINDS[otherName] = nil
					end
				end
				KEYBINDS[name] = input.KeyCode.Name
			end
			finishBinding()
			for _, refresh in ipairs(uiRefreshers) do
				refresh()
			end
		elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
			finishBinding() -- клик мимо — отмена
		end
		return
	end

	if gameProcessed or input.UserInputType ~= Enum.UserInputType.Keyboard then
		return
	end
	for name, key in pairs(KEYBINDS) do
		if key == input.KeyCode.Name and moduleRegistry[name] then
			moduleRegistry[name].toggle()
		end
	end
end)

local function addModule(section, def)
	-- def = { name, desc, source, key, settings = function(page) ... end }
	local card = new("TextButton", {
		LayoutOrder = #section.cards + 1,
		BackgroundColor3 = C.card,
		BackgroundTransparency = 0.05,
		BorderSizePixel = 0,
		AutoButtonColor = false,
		Text = "",
		Parent = section.grid,
	})
	round(card, 8)
	local cardStroke = outline(card, C.line, 0.65)
	local cardScale = new("UIScale", { Parent = card })
	-- лёгкий объём: сверху карточка чуть светлее, снизу темнее
	new("UIGradient", {
		Rotation = 90,
		Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(205, 205, 205)),
		Parent = card,
	})

	-- переключатель в правом верхнем углу карточки
	local switch = new("Frame", {
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, -10, 0, 11),
		Size = UDim2.fromOffset(30, 16),
		BackgroundColor3 = C.off,
		BorderSizePixel = 0,
		Parent = card,
	})
	round(switch, 8)
	local switchKnob = new("Frame", {
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, 2, 0.5, 0),
		Size = UDim2.fromOffset(12, 12),
		BackgroundColor3 = C.text,
		BorderSizePixel = 0,
		Parent = switch,
	})
	round(switchKnob, 6)

	-- плашка с иконкой, как в примере
	local icon = new("Frame", {
		Position = UDim2.fromOffset(10, 8),
		Size = UDim2.fromOffset(22, 22),
		BackgroundColor3 = C.accentDim,
		BorderSizePixel = 0,
		Parent = card,
	})
	round(icon, 6)
	local setIcon = drawIcon(icon, def.icon or MODULE_ICONS[def.name] or "dot", 12)

	local title = new("TextLabel", {
		Position = UDim2.fromOffset(40, 8),
		Size = UDim2.new(1, def.settings and -112 or -88, 0, 22),
		BackgroundTransparency = 1,
		Font = Enum.Font.GothamBold,
		TextSize = 14,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd,
		TextColor3 = C.text,
		Text = def.name,
		Parent = card,
	})

	local descLabel = new("TextLabel", {
		Position = UDim2.fromOffset(12, 32),
		Size = UDim2.new(1, -24, 0, 28),
		BackgroundTransparency = 1,
		Font = Enum.Font.Gotham,
		TextSize = 12,
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
		TextColor3 = C.sub,
		Text = def.desc,
		Parent = card,
	})

	local iconScale = new("UIScale", { Parent = icon })

	-- бейдж с назначенной клавишей
	local badge = new("TextLabel", {
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, def.settings and -70 or -46, 0, 10),
		Size = UDim2.fromOffset(0, 18),
		AutomaticSize = Enum.AutomaticSize.X,
		BackgroundColor3 = C.inner,
		BorderSizePixel = 0,
		Font = Enum.Font.GothamBold,
		TextSize = 11,
		TextColor3 = C.text,
		Text = "",
		Visible = false,
		Parent = card,
	})
	round(badge, 5)
	new("UIPadding", { PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6), Parent = badge })
	outline(badge, C.line, 0.5)

	local module = { name = def.name, page = nil }

	if def.settings then
		local dots = new("TextButton", {
			Position = UDim2.new(1, -64, 0, 8),
			Size = UDim2.fromOffset(22, 22),
			BackgroundTransparency = 1,
			Text = "",
			ZIndex = 2,
			Parent = card,
		})
		drawIcon(dots, "kebab", 14)(C.sub)

		local page = makeScroller(def.name .. "_Settings")
		new("UIListLayout", {
			Padding = UDim.new(0, 6),
			SortOrder = Enum.SortOrder.LayoutOrder,
			Parent = page,
		})
		def.settings(page)
		module.page = page

		dots.MouseButton1Click:Connect(function()
			openSettings(module)
		end)
	end

	local function refresh()
		local on = def.source[def.key]
		icon.BackgroundColor3 = on and C.accent or C.accentDim
		icon.BackgroundTransparency = on and 0 or 0.25
		setIcon(on and C.text or C.sub)
		title.TextColor3 = C.text
		cardStroke.Color = on and C.accent or C.line
		cardStroke.Transparency = on and 0.3 or 0.65

		switch.BackgroundColor3 = on and C.accent or C.off
		TweenService:Create(switchKnob, TweenInfo.new(0.16, Enum.EasingStyle.Quad), {
			Position = on and UDim2.new(1, -14, 0.5, 0) or UDim2.new(0, 2, 0.5, 0),
		}):Play()

		local key = KEYBINDS[def.name]
		badge.Visible = key ~= nil
		badge.Text = key or ""
		if bindingTarget == nil or bindingTarget.name ~= def.name then
			descLabel.Text = def.desc
			descLabel.TextColor3 = C.sub
		end
	end

	local function toggle()
		def.source[def.key] = not def.source[def.key]
		refresh()
		updateCounter()
		local on = def.source[def.key]
		playToggleSound(on)
		showToast(def.name, on)
		-- иконка «подпрыгивает»
		iconScale.Scale = 1.3
		TweenService:Create(iconScale, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 }):Play()
		if def.onToggle then
			def.onToggle(on)
		end
	end
	moduleRegistry[def.name] = { toggle = toggle, def = def, group = section.group }

	card.MouseButton1Click:Connect(toggle)

	-- ПКМ: назначить клавишу
	card.MouseButton2Click:Connect(function()
		finishBinding()
		descLabel.Text = "Нажмите клавишу… (Esc — убрать)"
		descLabel.TextColor3 = C.accent
		bindingTarget = {
			name = def.name,
			stop = function()
				descLabel.Text = def.desc
				descLabel.TextColor3 = C.sub
			end,
		}
	end)

	local hoverInfo = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	card.MouseEnter:Connect(function()
		TweenService:Create(card, hoverInfo, { BackgroundColor3 = C.cardHover }):Play()
		TweenService:Create(cardScale, hoverInfo, { Scale = 1.025 }):Play()
	end)
	card.MouseLeave:Connect(function()
		TweenService:Create(card, hoverInfo, { BackgroundColor3 = C.card }):Play()
		TweenService:Create(cardScale, hoverInfo, { Scale = 1 }):Play()
	end)

	refresh()
	table.insert(uiRefreshers, refresh)
	table.insert(uiRefreshers, updateCounter)
	table.insert(section.modules, def)
	table.insert(section.cards, { frame = card, name = def.name, desc = def.desc })
end

--------------------------------------------------------------------
-- Раздел ESP
--------------------------------------------------------------------
local espSection = createSection("ESP")

addModule(espSection, {
	name = "ESP",
	desc = "Показывает игроков сквозь стены.",
	source = CONFIG,
	key = "Enabled",
	settings = function(page)
		numberSetting(page, "Макс. дистанция", "MaxDistance", 50, 5000, CONFIG)
	end,
})
addModule(espSection, {
	name = "Подсветка",
	desc = "Подсвечивает силуэты игроков.",
	source = CONFIG,
	key = "ShowHighlight",
})
addModule(espSection, {
	name = "Текст над головой",
	desc = "Подпись с информацией над игроком.",
	source = CONFIG,
	key = "ShowLabel",
})
addModule(espSection, {
	name = "Имена",
	desc = "Отображаемое имя игрока в подписи.",
	source = CONFIG,
	key = "ShowNames",
})
addModule(espSection, {
	name = "Дистанция",
	desc = "Расстояние до игрока в studs.",
	source = CONFIG,
	key = "ShowDistance",
})
addModule(espSection, {
	name = "Здоровье",
	desc = "Полоска и число HP над игроком.",
	source = CONFIG,
	key = "ShowHealth",
})
addModule(espSection, {
	name = "Боксы",
	desc = "Рамка вокруг каждого игрока на экране.",
	source = CONFIG,
	key = "ShowBoxes",
	settings = function(page)
		toggleSetting(page, "Заливка", "BoxFill", CONFIG)
		numberSetting(page, "Толщина", "BoxThickness", 1, 5, CONFIG)
	end,
})
addModule(espSection, {
	name = "Трейсеры",
	desc = "Линии от края экрана к игрокам.",
	source = CONFIG,
	key = "ShowTracers",
	settings = function(page)
		choiceSetting(page, "Откуда линии", "TracerOrigin", { "Снизу", "Центр", "Курсор" }, CONFIG)
		numberSetting(page, "Толщина", "TracerThickness", 1, 5, CONFIG)
	end,
})
addModule(espSection, {
	name = "Союзники",
	desc = "Показывать игроков своей команды.",
	source = CONFIG,
	key = "ShowTeammates",
})

--------------------------------------------------------------------
-- Раздел Visuals
--------------------------------------------------------------------
local visualsSection = createSection("Visuals")

addModule(visualsSection, {
	name = "Hat",
	desc = "Шляпа, нимб или рога на голове.",
	source = HAT,
	key = "Enabled",
	settings = function(page)
		choiceSetting(page, "Форма", "Style", HAT_STYLES, HAT)
		toggleSetting(page, "Радужная", "Rainbow", HAT)
		colorSetting(page, "Цвет", "Color", HAT)
		toggleSetting(page, "Glow", "Glow", HAT)
		numberSetting(page, "Сила свечения", "GlowStrength", 0, 5, HAT)
		numberSetting(page, "Радиус", "Radius", 0.5, 4, HAT)
		numberSetting(page, "Высота", "Height", 0.3, 3, HAT)
		numberSetting(page, "Зазор", "Gap", 0, 2, HAT)
		numberSetting(page, "Прозрачность", "Transparency", 0, 1, HAT)
	end,
})
addModule(visualsSection, {
	name = "Trail",
	desc = "Светящийся след за персонажем.",
	source = TRAIL,
	key = "Enabled",
	settings = function(page)
		choiceSetting(page, "Тип", "Style", TRAIL_STYLES, TRAIL)
		toggleSetting(page, "Радужная", "Rainbow", TRAIL)
		colorSetting(page, "Цвет", "Color", TRAIL)
		toggleSetting(page, "Glow", "Glow", TRAIL)
		numberSetting(page, "Сила свечения", "GlowStrength", 0, 5, TRAIL)
		numberSetting(page, "Время жизни, с", "Lifetime", 0.2, 5, TRAIL)
		numberSetting(page, "Высота", "Height", 0.5, 4, TRAIL)
		numberSetting(page, "Прозрачность", "Transparency", 0, 1, TRAIL)
	end,
})
addModule(visualsSection, {
	name = "Jump Circle",
	desc = "Кольцо на земле при прыжке.",
	source = JUMP_CIRCLE,
	key = "Enabled",
	settings = function(page)
		choiceSetting(page, "Вид", "Style", JUMP_CIRCLE_STYLES, JUMP_CIRCLE)
		choiceSetting(page, "Когда появляется", "Trigger", JUMP_CIRCLE_TRIGGERS, JUMP_CIRCLE)
		toggleSetting(page, "Радужный", "Rainbow", JUMP_CIRCLE)
		colorSetting(page, "Цвет", "Color", JUMP_CIRCLE)
		toggleSetting(page, "Glow", "Glow", JUMP_CIRCLE)
		numberSetting(page, "Сила свечения", "GlowStrength", 0, 5, JUMP_CIRCLE)
		numberSetting(page, "Радиус", "Radius", 1, 15, JUMP_CIRCLE)
		numberSetting(page, "Время, с", "Duration", 0.2, 3, JUMP_CIRCLE)
		numberSetting(page, "Толщина", "Thickness", 0.05, 1, JUMP_CIRCLE)
	end,
})
addModule(visualsSection, {
	name = "Particles",
	desc = "Летающие частицы вокруг вас.",
	source = PARTICLES,
	key = "Enabled",
	settings = function(page)
		choiceSetting(page, "Тип", "Style", PARTICLE_STYLES, PARTICLES)
		toggleSetting(page, "Радужные", "Rainbow", PARTICLES)
		colorSetting(page, "Цвет", "Color", PARTICLES)
		toggleSetting(page, "Glow", "Glow", PARTICLES)
		numberSetting(page, "Сила свечения", "GlowStrength", 0, 5, PARTICLES)
		numberSetting(page, "Количество", "Rate", 5, 500, PARTICLES)
		numberSetting(page, "Размер", "Size", 0.1, 2, PARTICLES)
		numberSetting(page, "Область", "Range", 20, 200, PARTICLES)
	end,
})

addModule(visualsSection, {
	name = "Constellations",
	desc = "Созвездия плывут по ночному небу.",
	source = CONSTELLATIONS,
	key = "Enabled",
	settings = function(page)
		numberSetting(page, "Количество", "Count", 1, 40, CONSTELLATIONS)
		numberSetting(page, "Размер", "Size", 0.1, 2, CONSTELLATIONS)
		numberSetting(page, "Скорость", "Speed", 0, 3, CONSTELLATIONS)
		toggleSetting(page, "Радужные", "Rainbow", CONSTELLATIONS)
		colorSetting(page, "Цвет", "Color", CONSTELLATIONS)
		toggleSetting(page, "Glow", "Glow", CONSTELLATIONS)
	end,
})
addModule(visualsSection, {
	name = "Fog",
	desc = "Свой туман и его цвет.",
	source = FOG,
	key = "Enabled",
	settings = function(page)
		toggleSetting(page, "Радужный", "Rainbow", FOG)
		colorSetting(page, "Цвет", "Color", FOG)
		toggleSetting(page, "Glow (Bloom)", "Glow", FOG)
		numberSetting(page, "Сила свечения", "GlowStrength", 0, 5, FOG)
		numberSetting(page, "Начало", "Start", 0, 2000, FOG)
		numberSetting(page, "Конец", "End", 10, 5000, FOG)
	end,
})

addModule(visualsSection, {
	name = "Custom Sky",
	desc = "Свой вид неба и освещения.",
	source = SKY,
	key = "Enabled",
	settings = function(page)
		choiceSetting(page, "Небо", "Preset", SKY_PRESET_ORDER, SKY)
		toggleSetting(page, "Облака", "Clouds", SKY)
		toggleSetting(page, "Движение солнца", "MovingSun", SKY)
		numberSetting(page, "Скорость (часов в минуту)", "SunSpeed", 0.1, 60, SKY)
		toggleSetting(page, "Дымка на мире", "WorldHaze", SKY)
		choiceSetting(page, "Освещение", "LightingMode", SKY_LIGHTING_MODES, SKY)
		numberSetting(page, "Время суток (0-24)", "ClockTime", 0, 24, SKY)
		numberSetting(page, "Яркость солнца", "Brightness", 0, 6, SKY)
		colorSetting(page, "Цвет освещения", "LightColor", SKY)
		colorSetting(page, "Цвет солнечного света", "SunColor", SKY)
		numberSetting(page, "Экспозиция", "Exposure", -3, 3, SKY)
		toggleSetting(page, "Тени", "Shadows", SKY)
	end,
})

addModule(visualsSection, {
	name = "Shaders",
	desc = "Реалистичная картинка: цвет, свечение, лучи.",
	source = SHADERS,
	key = "Enabled",
	settings = function(page)
		choiceSetting(page, "Стиль", "Preset", SHADER_PRESETS, SHADERS)
		numberSetting(page, "Сила эффекта", "Intensity", 0, 1.5, SHADERS)
		toggleSetting(page, "Солнечные лучи", "SunRays", SHADERS)
		toggleSetting(page, "Размытие дальнего плана", "DepthOfField", SHADERS)
		toggleSetting(page, "Виньетка", "Vignette", SHADERS)
	end,
})

addModule(visualsSection, {
	name = "Auras",
	desc = "Аура вокруг вашего персонажа.",
	source = AURA,
	key = "Enabled",
	settings = function(page)
		choiceSetting(page, "Аура", "Style", AURA_STYLES, AURA)
		toggleSetting(page, "Радужная", "Rainbow", AURA)
		colorSetting(page, "Цвет", "Color", AURA)
		toggleSetting(page, "Glow", "Glow", AURA)
		numberSetting(page, "Размер", "Size", 0.5, 2.5, AURA)
		numberSetting(page, "Скорость", "Speed", 0.2, 4, AURA)
	end,
})

addModule(visualsSection, {
	name = "Back",
	desc = "Аксессуары на спине: крылья, рюкзак, джетпак.",
	source = BACK,
	key = "Enabled",
	settings = function(page)
		choiceSetting(page, "Аксессуар", "Style", BACK_STYLES, BACK)
		toggleSetting(page, "Радужный", "Rainbow", BACK)
		colorSetting(page, "Цвет", "Color", BACK)
		toggleSetting(page, "Glow", "Glow", BACK)
		numberSetting(page, "Прозрачность", "Transparency", 0, 0.9, BACK)
		numberSetting(page, "Размер", "Size", 0.6, 2, BACK)
		toggleSetting(page, "Анимация", "Animation", BACK)
		numberSetting(page, "Скорость анимации", "Speed", 0.2, 3, BACK)
	end,
})

addModule(visualsSection, {
	name = "Bottom",
	desc = "Светящаяся платформа под вами.",
	source = BOTTOM,
	key = "Enabled",
	settings = function(page)
		choiceSetting(page, "Платформа", "Style", BOTTOM_STYLES, BOTTOM)
		choiceSetting(page, "Положение", "Mode", BOTTOM_MODES, BOTTOM)
		toggleSetting(page, "Радужная", "Rainbow", BOTTOM)
		colorSetting(page, "Цвет", "Color", BOTTOM)
		toggleSetting(page, "Glow", "Glow", BOTTOM)
		numberSetting(page, "Размер", "Size", 0.5, 3, BOTTOM)
		numberSetting(page, "Прозрачность", "Transparency", 0, 0.9, BOTTOM)
		numberSetting(page, "Задержка при ходьбе", "Delay", 0, 1, BOTTOM)
		toggleSetting(page, "Наклон при движении", "Tilt", BOTTOM)
	end,
})

--------------------------------------------------------------------
-- Watermark: логотип, FPS, пинг и время на экране (раздел Misc)
--------------------------------------------------------------------
local WATERMARK, WATERMARK_POSITIONS
local watermarkClicked = Instance.new("BindableEvent")
do
	WATERMARK = {
		Enabled = true,
		ShowLogo = true,
		ShowFPS = true,
		ShowPing = true,
		ShowTime = true,
		ShowSeconds = false,
		Position = "Слева сверху",
	}

	WATERMARK_POSITIONS = { "Слева сверху", "Справа сверху", "Слева снизу", "Справа снизу" }
	local WATERMARK_ANCHORS = {
		["Слева сверху"] = { Vector2.new(0, 0), UDim2.new(0, 12, 0, 12) },
		["Справа сверху"] = { Vector2.new(1, 0), UDim2.new(1, -12, 0, 12) },
		["Слева снизу"] = { Vector2.new(0, 1), UDim2.new(0, 12, 1, -12) },
		["Справа снизу"] = { Vector2.new(1, 1), UDim2.new(1, -12, 1, -12) },
	}

	local watermarkGui = new("ScreenGui", {
		Name = "JustVisuals_Watermark",
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		ResetOnSpawn = false,
		DisplayOrder = 90,
		Parent = playerGui,
	})

	local watermarkBar = new("TextButton", {
		AutomaticSize = Enum.AutomaticSize.X,
		Size = UDim2.fromOffset(0, 28),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 0.08,
		BorderSizePixel = 0,
		AutoButtonColor = false,
		Text = "",
		Parent = watermarkGui,
	})
	round(watermarkBar, 8)
	local watermarkStroke = outline(watermarkBar, C.line, 0.35)

	-- клик по watermark открывает/закрывает меню; при наведении рамка подсвечивается
	watermarkBar.MouseButton1Click:Connect(function()
		watermarkClicked:Fire()
	end)
	watermarkBar.MouseEnter:Connect(function()
		watermarkStroke.Color = C.accent
		watermarkStroke.Transparency = 0.1
	end)
	watermarkBar.MouseLeave:Connect(function()
		watermarkStroke.Color = C.line
		watermarkStroke.Transparency = 0.35
	end)
	new("UIGradient", {
		Color = ColorSequence.new(C.bgTop, C.bgBottom),
		Rotation = 20,
		Parent = watermarkBar,
	})
	new("UIPadding", {
		PaddingLeft = UDim.new(0, 8),
		PaddingRight = UDim.new(0, 10),
		Parent = watermarkBar,
	})
	new("UIListLayout", {
		FillDirection = Enum.FillDirection.Horizontal,
		VerticalAlignment = Enum.VerticalAlignment.Center,
		Padding = UDim.new(0, 8),
		SortOrder = Enum.SortOrder.LayoutOrder,
		Parent = watermarkBar,
	})

	-- Один элемент полоски: разделитель слева, значение и подпись
	local function watermarkItem(order)
		local holder = new("Frame", {
			LayoutOrder = order,
			AutomaticSize = Enum.AutomaticSize.X,
			Size = UDim2.new(0, 0, 1, 0),
			BackgroundTransparency = 1,
			Parent = watermarkBar,
		})
		new("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, 8),
			SortOrder = Enum.SortOrder.LayoutOrder,
			Parent = holder,
		})

		local divider = new("Frame", {
			LayoutOrder = 0,
			Size = UDim2.fromOffset(1, 14),
			BackgroundColor3 = C.line,
			BackgroundTransparency = 0.2,
			BorderSizePixel = 0,
			Parent = holder,
		})

		local value = new("TextLabel", {
			LayoutOrder = 1,
			AutomaticSize = Enum.AutomaticSize.X,
			Size = UDim2.new(0, 0, 1, 0),
			BackgroundTransparency = 1,
			Font = Enum.Font.GothamBold,
			TextSize = 12,
			TextColor3 = C.text,
			RichText = true,
			Text = "",
			Parent = holder,
		})

		return { holder = holder, divider = divider, value = value }
	end

	-- логотип
	local logoItem = watermarkItem(1)
	logoItem.divider:Destroy()
	logoItem.divider = nil
	local logoSquare = new("Frame", {
		LayoutOrder = 0,
		Size = UDim2.fromOffset(18, 18),
		BackgroundColor3 = LOGO_BG,
		BorderSizePixel = 0,
		Parent = logoItem.holder,
	})
	round(logoSquare, 4)
	drawLogoMark(logoSquare, 18)
	logoItem.value.Font = Enum.Font.GothamBlack
	logoItem.value.Text = "opus client"

	local fpsItem = watermarkItem(2)
	local pingItem = watermarkItem(3)
	local timeItem = watermarkItem(4)

	local watermarkItems = {
		{ item = logoItem, key = "ShowLogo" },
		{ item = fpsItem, key = "ShowFPS" },
		{ item = pingItem, key = "ShowPing" },
		{ item = timeItem, key = "ShowTime" },
	}

	local function subText(text)
		return '<font color="#E2CCD1" size="11">' .. text .. "</font>"
	end

	local function speedColor(good, value, okLimit, badLimit, higherIsBetter)
		local isGood = higherIsBetter and value >= okLimit or (not higherIsBetter and value <= okLimit)
		local isBad = higherIsBetter and value < badLimit or (not higherIsBetter and value > badLimit)
		if isGood then
			return "#7EE2A0"
		elseif isBad then
			return "#FF6B7A"
		end
		return "#FFD27A"
	end

	local frameCount = 0
	local fpsTimer = 0
	local currentFps = 0

	RunService.RenderStepped:Connect(function(dt)
		frameCount += 1
		fpsTimer += dt
		if fpsTimer < 0.5 then
			return
		end
		currentFps = math.floor(frameCount / fpsTimer + 0.5)
		frameCount = 0
		fpsTimer = 0

		watermarkGui.Enabled = WATERMARK.Enabled
		if not WATERMARK.Enabled then
			return
		end

		-- положение на экране
		local anchor = WATERMARK_ANCHORS[WATERMARK.Position] or WATERMARK_ANCHORS["Слева сверху"]
		watermarkBar.AnchorPoint = anchor[1]
		watermarkBar.Position = anchor[2]

		-- видимость элементов и разделителей (у первого видимого разделителя нет)
		local firstVisible = true
		for _, entry in ipairs(watermarkItems) do
			local shown = WATERMARK[entry.key]
			entry.item.holder.Visible = shown
			if shown then
				if entry.item.divider then
					entry.item.divider.Visible = not firstVisible
				end
				firstVisible = false
			end
		end

		-- FPS
		fpsItem.value.Text = string.format('<font color="%s">%d</font> %s',
			speedColor(nil, currentFps, 50, 30, true), currentFps, subText("fps"))

		-- пинг (время туда и обратно до сервера)
		local ok, ping = pcall(function()
			return localPlayer:GetNetworkPing()
		end)
		local pingMs = ok and math.floor(ping * 1000 + 0.5) or 0
		pingItem.value.Text = string.format('<font color="%s">%d</font> %s',
			speedColor(nil, pingMs, 80, 180, false), pingMs, subText("ms"))

		-- время
		timeItem.value.Text = os.date(WATERMARK.ShowSeconds and "%H:%M:%S" or "%H:%M")
	end)
end

--------------------------------------------------------------------
-- Кастомный курсор (раздел Misc)
--------------------------------------------------------------------
local CURSOR, CURSOR_STYLES
do
	CURSOR = {
		Enabled = false,
		Style = "Крестик", -- "Точка", "Крестик", "Круг" или "Ромб"
		Rainbow = false,
		Color = Color3.fromRGB(255, 90, 90),
		Size = 18,          -- размер курсора в пикселях
		Thickness = 2,      -- толщина линий
		Outline = true,     -- тёмная обводка, чтобы курсор был виден на любом фоне
		Spin = false,       -- медленное вращение
		Transparency = 0,
	}

	CURSOR_STYLES = { "Точка", "Крестик", "Круг", "Ромб" }

	local cursorGui = new("ScreenGui", {
		Name = "JustVisuals_Cursor",
		IgnoreGuiInset = true,
		ResetOnSpawn = false,
		DisplayOrder = 500, -- поверх меню и заставки
		Enabled = false,
		Parent = playerGui,
	})

	local cursorRoot = new("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
		Parent = cursorGui,
	})

	local cursorShapes = {} -- { object, stroke (для контурных фигур) }
	local cursorBuiltFor = nil
	local cursorHidDefault = false

	local function cursorFill(position, size, circle)
		local part = new("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = position,
			Size = size,
			BorderSizePixel = 0,
			Parent = cursorRoot,
		})
		if circle then
			new("UICorner", { CornerRadius = UDim.new(1, 0), Parent = part })
		end
		if CURSOR.Outline then
			new("UIStroke", {
				Color = Color3.fromRGB(0, 0, 0),
				Transparency = 0.35,
				Thickness = 1,
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Parent = part,
			})
		end
		table.insert(cursorShapes, { object = part })
		return part
	end

	local function cursorOutlineShape(size, circle, rotation)
		-- тёмная подложка под контуром
		if CURSOR.Outline then
			local back = new("Frame", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromOffset(size, size),
				BackgroundTransparency = 1,
				Rotation = rotation or 0,
				Parent = cursorRoot,
			})
			if circle then
				new("UICorner", { CornerRadius = UDim.new(1, 0), Parent = back })
			end
			new("UIStroke", {
				Color = Color3.fromRGB(0, 0, 0),
				Transparency = 0.35,
				Thickness = CURSOR.Thickness + 2,
				Parent = back,
			})
		end

		local shape = new("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromOffset(size, size),
			BackgroundTransparency = 1,
			Rotation = rotation or 0,
			Parent = cursorRoot,
		})
		if circle then
			new("UICorner", { CornerRadius = UDim.new(1, 0), Parent = shape })
		end
		local stroke = new("UIStroke", {
			Thickness = CURSOR.Thickness,
			Parent = shape,
		})
		table.insert(cursorShapes, { object = shape, stroke = stroke })
	end

	local function buildCursor()
		for _, child in ipairs(cursorRoot:GetChildren()) do
			child:Destroy()
		end
		table.clear(cursorShapes)

		local size = CURSOR.Size
		local thickness = CURSOR.Thickness
		cursorRoot.Size = UDim2.fromOffset(size, size)

		if CURSOR.Style == "Точка" then
			local dot = math.max(thickness * 2, math.floor(size / 3))
			cursorFill(UDim2.fromScale(0.5, 0.5), UDim2.fromOffset(dot, dot), true)

		elseif CURSOR.Style == "Круг" then
			cursorOutlineShape(size, true)
			local dot = thickness + 2
			cursorFill(UDim2.fromScale(0.5, 0.5), UDim2.fromOffset(dot, dot), true)

		elseif CURSOR.Style == "Ромб" then
			cursorOutlineShape(math.floor(size * 0.7), false, 45)

		else -- "Крестик": четыре линии с промежутком в центре
			local gap = math.max(2, math.floor(size * 0.18))
			local length = math.max(2, math.floor(size / 2 - gap))
			local offset = gap + length / 2
			cursorFill(UDim2.new(0.5, 0, 0.5, -offset), UDim2.fromOffset(thickness, length))
			cursorFill(UDim2.new(0.5, 0, 0.5, offset), UDim2.fromOffset(thickness, length))
			cursorFill(UDim2.new(0.5, -offset, 0.5, 0), UDim2.fromOffset(length, thickness))
			cursorFill(UDim2.new(0.5, offset, 0.5, 0), UDim2.fromOffset(length, thickness))
		end

		cursorBuiltFor = table.concat({ CURSOR.Style, size, thickness, tostring(CURSOR.Outline) }, "|")
	end

	RunService.RenderStepped:Connect(function()
		local enabled = CURSOR.Enabled and UserInputService.MouseEnabled
		cursorGui.Enabled = enabled

		if not enabled then
			-- возвращаем обычный курсор Roblox
			if cursorHidDefault then
				UserInputService.MouseIconEnabled = true
				cursorHidDefault = false
			end
			return
		end

		UserInputService.MouseIconEnabled = false
		cursorHidDefault = true

		local key = table.concat({ CURSOR.Style, CURSOR.Size, CURSOR.Thickness, tostring(CURSOR.Outline) }, "|")
		if key ~= cursorBuiltFor then
			buildCursor()
		end

		local mouse = UserInputService:GetMouseLocation()
		cursorRoot.Position = UDim2.fromOffset(mouse.X, mouse.Y)
		cursorRoot.Rotation = CURSOR.Spin and (os.clock() * 120) % 360 or 0

		local color = CURSOR.Rainbow and Color3.fromHSV((os.clock() * 0.3) % 1, 0.8, 1) or CURSOR.Color
		for _, shape in ipairs(cursorShapes) do
			if shape.stroke then
				shape.stroke.Color = color
				shape.stroke.Transparency = CURSOR.Transparency
			else
				shape.object.BackgroundColor3 = color
				shape.object.BackgroundTransparency = CURSOR.Transparency
			end
		end
	end)
end

--------------------------------------------------------------------
-- Target ESP: частицы вокруг игроков в заданном радиусе от вас (раздел Misc, видно только вам)
--------------------------------------------------------------------
local TARGET_ESP, TARGET_MODES, TARGET_STYLES
do
	TARGET_ESP = {
		Enabled = false,
		Mode = "Все в радиусе", -- "Все в радиусе" или "Ближайший"
		Style = "Орбиты",       -- "Орбиты", "Спираль", "Искры" или "Огоньки"
		Radius = 30,             -- в каком радиусе от вас (studs) игроки получают эффект
		Rainbow = false,
		Color = Color3.fromRGB(255, 90, 90),
		Count = 6,               -- сколько шариков в «Орбитах» и «Спирали»
		Size = 0.35,             -- размер частиц
		Speed = 2,               -- скорость вращения
		Glow = true,
		ShowTeammates = true,
	}

	TARGET_MODES = { "Все в радиусе", "Ближайший" }
	TARGET_STYLES = { "Орбиты", "Спираль", "Искры", "Огоньки" }
	local TARGET_TEXTURES = {
		["Искры"] = "rbxasset://textures/particles/sparkles_main.dds",
		["Огоньки"] = "rbxasset://textures/particles/fire_main.dds",
	}

	local targetFolder = Instance.new("Folder")
	targetFolder.Name = "TargetESP_Local"
	targetFolder.Parent = workspace

	local targets = {} -- [Player] = { style, count, size, orbs = {Part}, holder, emitter }

	local function destroyTarget(player)
		local data = targets[player]
		if not data then
			return
		end
		for _, orb in ipairs(data.orbs) do
			orb:Destroy()
		end
		if data.holder then
			data.holder:Destroy()
		end
		targets[player] = nil
	end

	local function buildTarget(player)
		destroyTarget(player)

		local data = {
			style = TARGET_ESP.Style,
			count = TARGET_ESP.Count,
			size = TARGET_ESP.Size,
			orbs = {},
		}

		if data.style == "Орбиты" or data.style == "Спираль" then
			for i = 1, data.count do
				local orb = Instance.new("Part")
				orb.Shape = Enum.PartType.Ball
				orb.Size = Vector3.new(data.size, data.size, data.size)
				orb.Anchored = true
				orb.CanCollide = false
				orb.CanQuery = false
				orb.CanTouch = false
				orb.CastShadow = false
				orb.Parent = targetFolder
				data.orbs[i] = orb
			end
		else
			-- невидимая деталь вокруг игрока, из объёма которой вылетают частицы
			local holder = Instance.new("Part")
			holder.Anchored = true
			holder.CanCollide = false
			holder.CanQuery = false
			holder.CanTouch = false
			holder.Transparency = 1
			holder.Size = Vector3.new(3, 5, 3)
			holder.Parent = targetFolder

			local emitter = Instance.new("ParticleEmitter")
			emitter.Texture = TARGET_TEXTURES[data.style]
			emitter.Shape = Enum.ParticleEmitterShape.Box
			emitter.ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume
			emitter.Rate = 25
			emitter.Lifetime = NumberRange.new(0.8, 1.4)
			emitter.Speed = NumberRange.new(0.3, 1.2)
			emitter.SpreadAngle = Vector2.new(180, 180)
			emitter.Rotation = NumberRange.new(0, 360)
			emitter.RotSpeed = NumberRange.new(-60, 60)
			emitter.Acceleration = data.style == "Огоньки" and Vector3.new(0, 4, 0) or Vector3.zero
			emitter.Size = NumberSequence.new({
				NumberSequenceKeypoint.new(0, data.size * 3),
				NumberSequenceKeypoint.new(1, 0),
			})
			emitter.Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 0.1),
				NumberSequenceKeypoint.new(1, 1),
			})
			emitter.Parent = holder

			data.holder = holder
			data.emitter = emitter
		end

		targets[player] = data
	end

	local targetWanted = {}

	RunService.RenderStepped:Connect(function()
		table.clear(targetWanted)

		if TARGET_ESP.Enabled then
			local myCharacter = localPlayer.Character
			local myRoot = myCharacter and myCharacter:FindFirstChild("HumanoidRootPart")
			local camera = workspace.CurrentCamera
			local origin = (myRoot and myRoot.Position) or (camera and camera.CFrame.Position)

			local nearestPlayer, nearestDistance = nil, math.huge
			if origin then
				for _, player in ipairs(Players:GetPlayers()) do
					local character = player.Character
					local root = character and character:FindFirstChild("HumanoidRootPart")
					local humanoid = character and character:FindFirstChildOfClass("Humanoid")
					local allowed = TARGET_ESP.ShowTeammates or not isTeammate(player)

					if player ~= localPlayer and root and humanoid and humanoid.Health > 0 and allowed then
						local distance = (root.Position - origin).Magnitude
						if distance <= TARGET_ESP.Radius then
							if TARGET_ESP.Mode == "Ближайший" then
								if distance < nearestDistance then
									nearestPlayer, nearestDistance = player, distance
								end
							else
								targetWanted[player] = root
							end
						end
					end
				end
			end

			if nearestPlayer then
				targetWanted[nearestPlayer] = nearestPlayer.Character.HumanoidRootPart
			end
		end

		-- убираем эффект у тех, кто вышел из радиуса
		for player in pairs(targets) do
			if not targetWanted[player] then
				destroyTarget(player)
			end
		end

		local now = os.clock()
		local color = TARGET_ESP.Rainbow and Color3.fromHSV((now * 0.3) % 1, 0.8, 1) or TARGET_ESP.Color
		local material = TARGET_ESP.Glow and Enum.Material.Neon or Enum.Material.SmoothPlastic

		for player, root in pairs(targetWanted) do
			local data = targets[player]
			if not data or data.style ~= TARGET_ESP.Style or data.count ~= TARGET_ESP.Count or data.size ~= TARGET_ESP.Size then
				buildTarget(player)
				data = targets[player]
			end

			local center = root.Position
			if data.holder then
				data.holder.CFrame = CFrame.new(center)
				data.emitter.Color = ColorSequence.new(color)
				data.emitter.LightEmission = TARGET_ESP.Glow and 1 or 0
				data.emitter.LightInfluence = TARGET_ESP.Glow and 0 or 1
			else
				local count = #data.orbs
				for i, orb in ipairs(data.orbs) do
					local phase = (i - 1) / count
					local angle = now * TARGET_ESP.Speed + phase * math.pi * 2
					local height
					if data.style == "Спираль" then
						-- шарики поднимаются по спирали снизу вверх и начинают заново
						height = ((now * TARGET_ESP.Speed * 0.25 + phase) % 1) * 6 - 3
					else
						-- орбиты слегка покачиваются вверх-вниз
						height = math.sin(now * TARGET_ESP.Speed + phase * math.pi * 2) * 1.2
					end
					orb.CFrame = CFrame.new(center + Vector3.new(math.cos(angle) * 2.5, height, math.sin(angle) * 2.5))
					orb.Color = color
					orb.Material = material
				end
			end
		end
	end)

	Players.PlayerRemoving:Connect(destroyTarget)
end

--------------------------------------------------------------------
-- Custom Pet: виртуальный питомец, который летает рядом с вами (раздел Misc, виден только вам)
--------------------------------------------------------------------
local PET, PET_STYLES, PET_SIDES
do
	PET = {
		Enabled = false,
		Style = "Шарик",      -- "Шарик", "Кубик", "Дрон" или "Кролик"
		Name = "Pet",         -- имя над питомцем (пусто — без имени)
		Rainbow = false,
		Color = Color3.fromRGB(255, 90, 90),
		Glow = false,
		Size = 1.2,           -- размер питомца
		Side = "Справа",      -- "Справа", "Слева" или "Сзади"
		FollowSpeed = 6,      -- как быстро догоняет (больше — резвее)
		Bobbing = true,       -- покачивание в воздухе
		Virtual = true,       -- «виртуальный» вид, как у Hat: полупрозрачный, со светящимся контуром
		Transparency = 0.3,   -- прозрачность питомца в виртуальном виде
	}

	PET_STYLES = { "Шарик", "Кубик", "Дрон", "Кролик" }
	PET_SIDES = { "Справа", "Слева", "Сзади" }
	-- «Фабрика»: рисует этот эффект для любого игрока (owner) по его настройкам (PET).
	-- Для вас она вызывается с вашими настройками, для других игроков — с присланными через синхронизацию.
	RENDERERS.Pet = function(owner, PET)
		local connections = {}
		local localPlayer, RunService = syncContext(owner, connections)
		local PET_OFFSETS = {
			["Справа"] = Vector3.new(3, 1.2, 1),
			["Слева"] = Vector3.new(-3, 1.2, 1),
			["Сзади"] = Vector3.new(0, 1.8, 3.5),
		}

		local petFolder = Instance.new("Folder")
		petFolder.Name = "CustomPet_Local"
		petFolder.Parent = workspace

		local pet = nil -- { parts = { {part, offset, colored, spin} }, label, position, style, size }
		local currentModel = nil -- модель, в которую собираются детали питомца (для светящегося контура)

		local function destroyPet()
			if pet then
				for _, entry in ipairs(pet.parts) do
					entry.part:Destroy()
				end
				pet.anchorPart:Destroy()
				if pet.model then
					pet.model:Destroy()
				end
				for _, extra in ipairs(pet.extras or {}) do
					extra:Destroy()
				end
				pet = nil
			end
		end

		-- «Виртуальный» вид: прозрачность деталей и светящийся контур вокруг всего питомца
		local function applyVirtual(color)
			local virtual = PET.Virtual
			pet.outline.Enabled = virtual
			pet.outline.OutlineColor = color
			pet.outline.OutlineTransparency = 0.15
			return virtual and math.clamp(PET.Transparency, 0, 0.9) or 0
		end

		local function petPart(parts, shape, size, offset, colored, spin, ellipsoid, tag)
			local part = Instance.new("Part")
			part.Shape = shape
			part.Size = size
			if ellipsoid then
				-- сфера, растянутая по размеру детали — получается гладкий эллипсоид
				local mesh = Instance.new("SpecialMesh")
				mesh.MeshType = Enum.MeshType.Sphere
				mesh.Parent = part
			end
			part.Anchored = true
			part.CanCollide = false
			part.CanQuery = false
			part.CanTouch = false
			part.CastShadow = false
			part.Material = Enum.Material.SmoothPlastic
			part.Color = colored and PET.Color or Color3.fromRGB(20, 20, 24)
			part.Parent = currentModel or petFolder
			table.insert(parts, { part = part, offset = offset, colored = colored, spin = spin, tag = tag, size = size })
			return part
		end

		local function buildPet(startPosition)
			destroyPet()

			currentModel = Instance.new("Model")
			currentModel.Name = "Pet"
			currentModel.Parent = petFolder
			local outline = Instance.new("Highlight")
			outline.FillTransparency = 1
			outline.DepthMode = Enum.HighlightDepthMode.Occluded
			outline.Adornee = currentModel
			outline.Parent = currentModel

			local s = PET.Size
			local parts = {}
			local extras = {}
			local Ball, Block, Cylinder = Enum.PartType.Ball, Enum.PartType.Block, Enum.PartType.Cylinder
			local up = CFrame.Angles(0, 0, math.pi / 2) -- поворачивает ось цилиндра вертикально

			if PET.Style == "Кубик" then
				petPart(parts, Block, Vector3.new(s, s, s), CFrame.new(), true)
				petPart(parts, Ball, Vector3.one * 0.2 * s, CFrame.new(-0.22 * s, 0.12 * s, -0.5 * s), false)
				petPart(parts, Ball, Vector3.one * 0.2 * s, CFrame.new(0.22 * s, 0.12 * s, -0.5 * s), false)
				petPart(parts, Block, Vector3.new(0.3 * s, 0.06 * s, 0.05 * s), CFrame.new(0, -0.15 * s, -0.5 * s), false)

			elseif PET.Style == "Дрон" then
				petPart(parts, Block, Vector3.new(0.9 * s, 0.45 * s, 0.9 * s), CFrame.new(), true)
				petPart(parts, Block, Vector3.new(0.55 * s, 0.14 * s, 0.06 * s), CFrame.new(0, 0.04 * s, -0.46 * s), false)
				petPart(parts, Cylinder, Vector3.new(0.25 * s, 0.08 * s, 0.08 * s), CFrame.new(0, 0.34 * s, 0) * up, false)
				-- винт вращается
				petPart(parts, Block, Vector3.new(1.3 * s, 0.04 * s, 0.14 * s), CFrame.new(0, 0.48 * s, 0), true, true)

			elseif PET.Style == "Кролик" then
				-- Модель кролика. tag — к какой группе относится часть:
				--   body — туловище (сжимается/растягивается в прыжке), head — всё, что на голове (поворачивается
				--   вместе с ней), eye — глаза (моргают), nose, earL/earR — уши (качаются на «пружине»),
				--   front/hind — лапы, tail — хвост.
				-- role — цвет: main, light (мордочка, пузико, хвост), pink, dark (глаза), white (блики), glow (усы).
				local function bunny(size, offset, role, tag)
					return petPart(parts, Block, size * s, offset, role, nil, true, tag)
				end
				local function at(x, y, z)
					return CFrame.new(x * s, y * s, z * s)
				end

				bunny(Vector3.new(0.88, 0.74, 0.84), at(0, 0.41, 0.17), "main", "body")      -- круп
				bunny(Vector3.new(0.66, 0.62, 0.66), at(0, 0.47, -0.17), "main", "body")     -- грудка
				bunny(Vector3.new(0.56, 0.5, 0.5), at(0, 0.56, 0.0), "main", "body")         -- спинка (сглаживает переход)
				bunny(Vector3.new(0.42, 0.36, 0.34), at(0, 0.36, -0.36), "light", "body")    -- светлая грудь
				bunny(Vector3.new(0.34, 0.26, 0.3), at(0, 0.66, -0.36), "main", "head")      -- шея
				bunny(Vector3.new(0.54, 0.5, 0.58), at(0, 0.83, -0.45), "main", "head")      -- голова
				bunny(Vector3.new(0.32, 0.23, 0.24), at(0, 0.74, -0.7), "light", "head")     -- мордочка
				bunny(Vector3.new(0.07, 0.055, 0.05), at(0, 0.8, -0.815), "pink", "nose")    -- нос
				for _, side in ipairs({ -1, 1 }) do
					bunny(Vector3.new(0.21, 0.19, 0.21), at(side * 0.13, 0.75, -0.62), "light", "head") -- щёчки
					bunny(Vector3.new(0.1, 0.11, 0.08), at(side * 0.18, 0.89, -0.63), "dark", "eye")     -- глаз
					bunny(Vector3.new(0.035, 0.035, 0.03), at(side * 0.19, 0.915, -0.672), "white", "eye") -- блик

					-- ухо с розовой внутренней стороной
					local earTag = side == -1 and "earL" or "earR"
					local earCFrame = at(side * 0.11, 1.29, -0.38) * CFrame.Angles(-0.2, 0, side * -0.15)
					bunny(Vector3.new(0.16, 0.64, 0.08), earCFrame, "main", earTag)
					bunny(Vector3.new(0.09, 0.5, 0.05), earCFrame * CFrame.new(0, -0.02 * s, -0.035 * s), "pink", earTag)

					-- усы
					for i = 1, 2 do
						local whisker = CFrame.new(side * 0.2 * s, (0.76 - (i - 1) * 0.04) * s, -0.71 * s)
							* CFrame.Angles((i - 1.5) * 0.25, side * -1.1, 0)
						petPart(parts, Block, Vector3.new(0.015, 0.015, 0.34) * s, whisker, "glow", nil, false, "head")
					end

					bunny(Vector3.new(0.28, 0.42, 0.46), at(side * 0.3, 0.3, 0.2), "main", "body")      -- бедро
					bunny(Vector3.new(0.18, 0.12, 0.54), at(side * 0.25, 0.06, 0.2), "light", "hind")   -- задняя лапа
					bunny(Vector3.new(0.12, 0.32, 0.12), at(side * 0.14, 0.17, -0.32), "main", "front") -- передняя лапа
					bunny(Vector3.new(0.13, 0.07, 0.16), at(side * 0.14, 0.035, -0.37), "light", "front") -- кисть
				end
				bunny(Vector3.new(0.34, 0.31, 0.3), at(0, 0.5, 0.6), "light", "tail")       -- хвостик

				-- мягкая тень под кроликом (сжимается, когда он в прыжке) и пыль из-под лап при приземлении
				local shadow = Instance.new("Part")
				shadow.Shape = Enum.PartType.Cylinder
				shadow.Anchored = true
				shadow.CanCollide = false
				shadow.CanQuery = false
				shadow.CanTouch = false
				shadow.CastShadow = false
				shadow.Material = Enum.Material.SmoothPlastic
				shadow.Color = Color3.new(0, 0, 0)
				shadow.Parent = petFolder
				table.insert(extras, shadow)

				local dustPart = Instance.new("Part")
				dustPart.Anchored = true
				dustPart.CanCollide = false
				dustPart.CanQuery = false
				dustPart.CanTouch = false
				dustPart.Transparency = 1
				dustPart.Size = Vector3.new(0.6, 0.1, 0.6) * s
				dustPart.Parent = petFolder
				table.insert(extras, dustPart)
				local dust = Instance.new("ParticleEmitter")
				dust.Texture = "rbxasset://textures/particles/smoke_main.dds"
				dust.Enabled = false
				dust.Color = ColorSequence.new(Color3.fromRGB(200, 195, 185))
				dust.Lifetime = NumberRange.new(0.35, 0.6)
				dust.Speed = NumberRange.new(1, 2.2)
				dust.SpreadAngle = Vector2.new(80, 80)
				dust.EmissionDirection = Enum.NormalId.Top
				dust.Acceleration = Vector3.new(0, 1, 0)
				dust.Size = NumberSequence.new(0.35 * s, 0.9 * s)
				dust.Transparency = NumberSequence.new(0.55, 1)
				dust.Parent = dustPart

			else -- "Шарик"
				petPart(parts, Ball, Vector3.one * s, CFrame.new(), true)
				petPart(parts, Ball, Vector3.one * 0.2 * s, CFrame.new(-0.2 * s, 0.12 * s, -0.42 * s), false)
				petPart(parts, Ball, Vector3.one * 0.2 * s, CFrame.new(0.2 * s, 0.12 * s, -0.42 * s), false)
				petPart(parts, Cylinder, Vector3.new(0.35 * s, 0.06 * s, 0.06 * s), CFrame.new(0, 0.62 * s, 0) * up, false)
				petPart(parts, Ball, Vector3.one * 0.16 * s, CFrame.new(0, 0.82 * s, 0), true)
			end

			-- невидимая точка над питомцем для имени
			local anchorPart = Instance.new("Part")
			anchorPart.Anchored = true
			anchorPart.CanCollide = false
			anchorPart.CanQuery = false
			anchorPart.CanTouch = false
			anchorPart.Transparency = 1
			anchorPart.Size = Vector3.new(0.1, 0.1, 0.1)
			anchorPart.Parent = petFolder

			local billboard = Instance.new("BillboardGui")
			billboard.Size = UDim2.fromOffset(140, 22)
			billboard.StudsOffset = Vector3.new(0, (PET.Style == "Кролик" and 1.8 or 0.9) * s + 0.6, 0)
			billboard.Adornee = anchorPart
			billboard.Parent = anchorPart

			local label = Instance.new("TextLabel")
			label.Size = UDim2.fromScale(1, 1)
			label.BackgroundTransparency = 1
			label.Font = Enum.Font.GothamBold
			label.TextSize = 13
			label.TextStrokeTransparency = 0.4
			label.TextColor3 = C.text
			label.Parent = billboard

			pet = {
				parts = parts,
				anchorPart = anchorPart,
				label = label,
				position = startPosition,
				style = PET.Style,
				size = PET.Size,
				ground = PET.Style == "Кролик", -- бегает по земле, а не летает
				model = currentModel,
				outline = outline,
				facing = Vector3.new(0, 0, -1),
				hopPhase = 0,
				idleTime = 0,
				wanderTarget = nil,
				wanderPause = 0,
				extras = extras,
				-- состояние «живости» кролика
				earAngle = { earL = 0, earR = 0 },
				earVelocity = { earL = 0, earR = 0 },
				action = nil, actionStart = 0, actionLength = 0,
				nextAction = os.clock() + 2,
				nextBlink = os.clock() + 2,
				blinkStart = -10,
				landImpact = 0,
				lean = 0,
				stand = 0,
				flop = 0,
				binkyStart = -10,
				wasIdleLong = false,
				headYaw = 0,
			}
		end

		--------------------------------------------------------------------
		-- Кролик: прыгает по земле следом за вами. Если вы стоите на месте дольше 5 секунд,
		-- он начинает сам бегать неподалёку: выбирает точку рядом, допрыгивает, осматривается
		-- и бежит к следующей. Стоит вам двинуться — снова бежит за вами.
		--------------------------------------------------------------------
		local IDLE_BEFORE_WANDER = 5
		local groundParams = RaycastParams.new()
		groundParams.FilterType = Enum.RaycastFilterType.Exclude

		local function groundAt(position, character)
			groundParams.FilterDescendantsInstances = { petFolder, character }
			local hit = workspace:Raycast(position + Vector3.new(0, 6, 0), Vector3.new(0, -40, 0), groundParams)
			return hit and hit.Position.Y or nil
		end

		-- случайные занятия, пока кролик сидит: умывается, нюхает землю, встаёт столбиком,
		-- чешется, разглядывает вас. [название] = длительность (сек)
		local IDLE_ACTIONS = { { "groom", 2.6 }, { "sniff", 2.0 }, { "stand", 2.6 }, { "scratch", 1.6 }, { "look", 2.4 } }
		local FLOP_AFTER = 25 -- если вы долго стоите, кролик ложится на бок отдохнуть

		local function smooth(current, target, speed, dt)
			return current + (target - current) * (1 - math.exp(-speed * dt))
		end

		local function updateRabbit(dt, root, character)
			local s = pet.size
			local now = os.clock()
			local velocity = root.AssemblyLinearVelocity
			local playerMoving = Vector3.new(velocity.X, 0, velocity.Z).Magnitude > 1

			------------------------------------------------------------------
			-- куда бежать
			------------------------------------------------------------------
			if playerMoving then
				-- вы долго стояли и пошли — кролик радостно подпрыгивает («бинки»)
				if pet.wasIdleLong then
					pet.binkyStart = now
					pet.wasIdleLong = false
				end
				pet.idleTime = 0
				pet.wanderTarget = nil
			else
				pet.idleTime += dt
				if pet.idleTime >= IDLE_BEFORE_WANDER then
					pet.wasIdleLong = true
				end
			end

			local target
			local hopSpeed
			local flopping = pet.idleTime >= FLOP_AFTER
			if pet.idleTime >= IDLE_BEFORE_WANDER and not flopping then
				if not pet.wanderTarget and not pet.action then
					pet.wanderPause -= dt
					if pet.wanderPause <= 0 then
						local angle = math.random() * math.pi * 2
						local distance = 3 + math.random() * 6
						pet.wanderTarget = root.Position + Vector3.new(math.cos(angle) * distance, 0, math.sin(angle) * distance)
					end
				end
				target = pet.wanderTarget or pet.position
				hopSpeed = 6 * s
			elseif flopping then
				target = pet.position
				hopSpeed = 0
			else
				local offset = PET_OFFSETS[PET.Side] or PET_OFFSETS["Справа"]
				target = root.CFrame:PointToWorldSpace(Vector3.new(offset.X, 0, offset.Z))
				local behind = (Vector3.new(target.X, 0, target.Z) - Vector3.new(pet.position.X, 0, pet.position.Z)).Magnitude
				hopSpeed = math.clamp(behind * PET.FollowSpeed * 0.6, 4, 40) * s
			end

			if (target - pet.position).Magnitude > 60 then
				pet.position = target
			end

			local flat = Vector3.new(target.X - pet.position.X, 0, target.Z - pet.position.Z)
			local distance = flat.Magnitude
			local moving = distance > 0.4 and pet.flop < 0.2
			local previousFacing = pet.facing
			if moving then
				pet.position += flat.Unit * math.min(distance, hopSpeed * dt)
				pet.facing = pet.facing:Lerp(flat.Unit, 1 - math.exp(-10 * dt))
				pet.action = nil
			elseif pet.wanderTarget then
				pet.wanderTarget = nil
				pet.wanderPause = 0.8 + math.random() * 1.6
			elseif not playerMoving and pet.idleTime < IDLE_BEFORE_WANDER then
				local look = root.CFrame.LookVector * Vector3.new(1, 0, 1)
				if look.Magnitude > 0.01 then
					pet.facing = pet.facing:Lerp(look.Unit, 1 - math.exp(-4 * dt))
				end
			end

			-- наклон в поворотах
			local turn = 0
			if previousFacing.Magnitude > 0.01 and pet.facing.Magnitude > 0.01 then
				local a, b = previousFacing.Unit, pet.facing.Unit
				turn = math.atan2(a.X * b.Z - a.Z * b.X, a:Dot(b)) / math.max(dt, 1e-3)
			end
			pet.lean = smooth(pet.lean, math.clamp(-turn * 0.06, -0.3, 0.3), 8, dt)

			------------------------------------------------------------------
			-- прыжки, приземление, «бинки»
			------------------------------------------------------------------
			local binky = math.clamp((now - pet.binkyStart) / 0.6, 0, 1)
			local inBinky = binky < 1
			local before = pet.hopPhase
			if moving or inBinky or pet.hopPhase % 1 > 0.02 then
				pet.hopPhase += dt * (inBinky and 2.2 or 3.2)
				if not moving and not inBinky and pet.hopPhase % 1 < 0.06 then
					pet.hopPhase = math.floor(pet.hopPhase + 0.5)
				end
			end
			-- пересекли целое значение фазы — это приземление: пыль и «приседание»
			if math.floor(pet.hopPhase) > math.floor(before) then
				pet.landImpact = 1
				local dust = pet.extras[2] and pet.extras[2]:FindFirstChildOfClass("ParticleEmitter")
				if dust then
					pet.extras[2].CFrame = CFrame.new(pet.position)
					dust:Emit(inBinky and 6 or 3)
				end
			end
			pet.landImpact = smooth(pet.landImpact, 0, 12, dt)

			local hop = math.abs(math.sin(pet.hopPhase * math.pi))
			local hopHeight = hop * (inBinky and 1.4 or 0.6) * s
			local tilt = math.cos(pet.hopPhase * math.pi) * 0.25 * hop
			local twist = inBinky and math.sin(binky * math.pi) * 0.9 or 0 -- в «бинки» кролик изворачивается в воздухе

			-- сжатие/растяжение: вытягивается в толчке, «приседает» при приземлении
			local squash = 1 + 0.1 * hop - 0.17 * pet.landImpact

			------------------------------------------------------------------
			-- занятия в покое
			------------------------------------------------------------------
			local resting = not moving and hop < 0.05 and not inBinky
			if not resting then
				pet.action = nil
			elseif not flopping and not pet.action and now >= pet.nextAction and not pet.wanderTarget then
				local pick = IDLE_ACTIONS[math.random(1, #IDLE_ACTIONS)]
				pet.action, pet.actionLength, pet.actionStart = pick[1], pick[2], now
			end
			local progress, envelope = 0, 0
			if pet.action then
				progress = (now - pet.actionStart) / pet.actionLength
				if progress >= 1 then
					pet.action = nil
					pet.nextAction = now + 2 + math.random() * 4
					progress = 0
				else
					envelope = math.sin(progress * math.pi) ^ 0.6 -- плавно начать и плавно закончить
				end
			end
			local action = pet.action

			pet.stand = smooth(pet.stand, action == "stand" and envelope or 0, 10, dt)
			pet.flop = smooth(pet.flop, (flopping and resting) and 1 or 0, 3, dt)

			-- поза головы
			local headPitch, headYaw, headRoll = 0, 0, 0
			local frontRaise, rub = 0, 0
			if action == "groom" then
				headPitch = 0.35 * envelope
				frontRaise = envelope
				rub = math.sin(now * 14) * 0.05 * envelope
			elseif action == "sniff" then
				headPitch = 0.55 * envelope + math.sin(now * 9) * 0.04 * envelope
			elseif action == "stand" then
				headPitch = -0.75 * pet.stand
				frontRaise = 0.45 * pet.stand
			elseif action == "scratch" then
				headRoll = 0.35 * envelope
			end
			-- в покое и при «разглядывании» кролик следит за вами головой
			local wantYaw = 0
			if (action == "look" or action == "stand" or (resting and not action)) and character:FindFirstChild("Head") then
				local base = CFrame.lookAt(pet.position, pet.position + (pet.facing.Magnitude > 0.01 and pet.facing.Unit or Vector3.new(0, 0, -1)))
				local rel = base:PointToObjectSpace(character.Head.Position)
				wantYaw = math.clamp(math.atan2(-rel.X, -rel.Z), -0.9, 0.9)
			end
			pet.headYaw = smooth(pet.headYaw, wantYaw, 5, dt)
			headYaw = pet.headYaw
			if pet.flop > 0.5 then
				headPitch = -0.2
			end
			if resting and not action then
				headPitch += math.sin(now * 1.7) * 0.04
			end

			-- уши на «пружине»: отстают при беге и поворотах, прижимаются в прыжке, торчат когда кролик насторожен
			local speedFactor = moving and math.clamp(hopSpeed / (20 * s), 0, 1) or 0
			for _, ear in ipairs({ "earL", "earR" }) do
				local sideSign = ear == "earL" and -1 or 1
				local targetAngle = -(speedFactor * 0.5 + hop * 0.3)
					+ (action == "look" and 0.15 or 0)
					+ turn * 0.05 * sideSign
					- (action == "scratch" and ear == "earL" and math.abs(math.sin(now * 20)) * 0.5 or 0)
					- pet.flop * 0.6
				local velocityNow = pet.earVelocity[ear] + ((targetAngle - pet.earAngle[ear]) * 70 - pet.earVelocity[ear] * 9) * dt
				pet.earVelocity[ear] = velocityNow
				pet.earAngle[ear] += velocityNow * dt
			end

			-- моргание
			if now >= pet.nextBlink then
				pet.blinkStart = now
				pet.nextBlink = now + 2 + math.random() * 4
			end
			local blink = (now - pet.blinkStart) < 0.13
			local sleepy = pet.flop > 0.6
			local eyeOpen = blink and 0.12 or (sleepy and 0.35 or 1)

			local noseTwitch = resting and math.max(0, math.sin(now * (action == "sniff" and 30 or 14))) * 0.012 * s or 0
			local breathe = resting and math.sin(now * (sleepy and 1.6 or 3)) * 0.015 * s or 0
			local tailWag = math.sin(now * (inBinky and 20 or 6)) * (inBinky and 0.04 or 0.01) * s

			------------------------------------------------------------------
			-- итоговая поза всего тела
			------------------------------------------------------------------
			local groundY = groundAt(pet.position, character) or (root.Position.Y - 3)
			pet.position = Vector3.new(pet.position.X, groundY, pet.position.Z)
			local facing = pet.facing.Magnitude > 0.01 and pet.facing.Unit or Vector3.new(0, 0, -1)
			local basePosition = Vector3.new(pet.position.X, groundY + hopHeight, pet.position.Z)

			local rabbitCFrame = CFrame.lookAt(basePosition, basePosition + facing)
				* CFrame.Angles(tilt, twist, pet.lean)
			-- встаёт «столбиком»: поворот вокруг задних лап
			local hindPivot = CFrame.new(0, 0.08 * s, 0.4 * s)
			rabbitCFrame = rabbitCFrame * hindPivot * CFrame.Angles(1.0 * pet.stand, 0, 0) * hindPivot:Inverse()
			-- ложится на бок отдохнуть
			rabbitCFrame = rabbitCFrame * CFrame.new(0.3 * s * pet.flop, -0.12 * s * pet.flop, 0) * CFrame.Angles(0, 0, 1.25 * pet.flop)
			rabbitCFrame = rabbitCFrame * CFrame.new(0, breathe, 0)

			local neck = Vector3.new(0, 0.7 * s * squash, -0.32 * s)
			local headTurn = CFrame.new(neck) * CFrame.Angles(headPitch, headYaw, headRoll) * CFrame.new(-neck)

			local color = PET.Rainbow and Color3.fromHSV((now * 0.3) % 1, 0.8, 1) or PET.Color
			local material = PET.Glow and Enum.Material.Neon or Enum.Material.SmoothPlastic
			applyVirtual(color)
			if PET.Virtual then
				pet.outline.DepthMode = Enum.HighlightDepthMode.Occluded
				pet.outline.FillColor = color
				pet.outline.FillTransparency = 0.45 + math.clamp(PET.Transparency, 0, 0.9) * 0.5
				pet.outline.OutlineColor = color:Lerp(Color3.new(1, 1, 1), 0.35)
				pet.outline.OutlineTransparency = 0
			end
			local roleColors = {
				main = color,
				light = color:Lerp(Color3.new(1, 1, 1), 0.45),
				pink = color:Lerp(Color3.fromRGB(255, 160, 185), 0.65),
				dark = Color3.fromRGB(18, 16, 22),
				white = Color3.new(1, 1, 1),
				glow = color:Lerp(Color3.new(1, 1, 1), 0.6),
			}

			for _, entry in ipairs(pet.parts) do
				local part = entry.part
				local tag = entry.tag
				local offset = entry.offset
				-- сжатие по высоте сдвигает все части пропорционально
				local p = offset.Position
				offset = CFrame.new(p.X, p.Y * squash, p.Z) * (offset - p)
				local size = entry.size

				if tag == "body" then
					local k = squash
					size = Vector3.new(size.X / math.sqrt(k), size.Y * k, size.Z / math.sqrt(k))
					offset = offset
				elseif tag == "head" or tag == "nose" or tag == "eye" or tag == "earL" or tag == "earR" then
					offset = headTurn * offset
					if tag == "nose" then
						offset = offset * CFrame.new(0, noseTwitch, 0)
					elseif tag == "eye" then
						size = Vector3.new(size.X, size.Y * eyeOpen, size.Z)
					else
						if tag == "earL" or tag == "earR" then
							-- поворот вокруг основания уха, а не середины
							local half = (entry.size and entry.size.Y or 0.6 * s) / 2
							local wiggle = resting and math.sin(now * 5 + (tag == "earL" and 0 or 1.7)) * 0.05 or 0
							offset = offset * CFrame.new(0, -half, 0) * CFrame.Angles(pet.earAngle[tag] + wiggle, 0, 0) * CFrame.new(0, half, 0)
						end
					end
				elseif tag == "front" then
					offset = CFrame.new(0, (0.05 * hop + 0.33 * frontRaise + rub) * s, (-0.16 * hop - 0.18 * frontRaise) * s)
						* offset * CFrame.Angles(0.6 * hop - 1.1 * frontRaise, 0, 0)
				elseif tag == "hind" then
					offset = CFrame.new(0, -0.04 * s * hop, 0.22 * s * hop) * offset * CFrame.Angles(-0.5 * hop, 0, 0)
				elseif tag == "tail" then
					offset = offset * CFrame.new(tailWag, 0, 0)
				end

				part.Size = size
				part.CFrame = rabbitCFrame * offset

				local role = entry.colored
				if role == true then
					role = "main"
				elseif role == false then
					role = "dark"
				end
				part.Color = roleColors[role] or color
				if role == "glow" then
					part.Material = Enum.Material.Neon
					part.Transparency = 0
				elseif role == "white" then
					part.Material = Enum.Material.SmoothPlastic
					part.Transparency = (blink or sleepy) and 1 or 0 -- блик пропадает, когда глаза закрыты
				elseif role == "dark" then
					part.Material = Enum.Material.SmoothPlastic
					part.Transparency = 0
				else
					part.Material = material
					part.Transparency = 0
				end
			end

			-- тень под кроликом: меньше и бледнее, когда он высоко в прыжке
			local shadow = pet.extras[1]
			if shadow then
				local diameter = (1.15 - hop * 0.45) * s
				shadow.Size = Vector3.new(0.04, diameter, diameter * 1.15)
				shadow.CFrame = CFrame.lookAt(Vector3.new(pet.position.X, groundY + 0.03, pet.position.Z),
					Vector3.new(pet.position.X, groundY + 0.03, pet.position.Z) + facing) * CFrame.Angles(0, 0, math.pi / 2)
				shadow.Transparency = 0.6 + hop * 0.3
			end

			pet.anchorPart.CFrame = CFrame.new(basePosition)
			pet.label.Text = PET.Name
			pet.label.Visible = PET.Name ~= ""
		end

		RunService.RenderStepped:Connect(function(dt)
			local character = localPlayer.Character
			local root = character and character:FindFirstChild("HumanoidRootPart")

			if not PET.Enabled or not root then
				destroyPet()
				return
			end

			local offset = PET_OFFSETS[PET.Side] or PET_OFFSETS["Справа"]
			local targetPosition = root.CFrame:PointToWorldSpace(offset)

			if not pet or pet.style ~= PET.Style or pet.size ~= PET.Size then
				buildPet(targetPosition)
			end

			if pet.ground then
				updateRabbit(dt, root, character)
				return
			end

			-- плавно догоняем; если игрок телепортировался — прыгаем сразу
			if (targetPosition - pet.position).Magnitude > 60 then
				pet.position = targetPosition
			else
				local alpha = 1 - math.exp(-PET.FollowSpeed * dt)
				pet.position = pet.position:Lerp(targetPosition, alpha)
			end

			local now = os.clock()
			local bob = PET.Bobbing and math.sin(now * 2.5) * 0.25 or 0
			local look = root.CFrame.LookVector * Vector3.new(1, 0, 1)
			if look.Magnitude < 0.01 then
				look = Vector3.new(0, 0, -1)
			end
			local center = pet.position + Vector3.new(0, bob, 0)
			local petCFrame = CFrame.lookAt(center, center + look.Unit)

			local color = PET.Rainbow and Color3.fromHSV((now * 0.3) % 1, 0.8, 1) or PET.Color
			local material = PET.Glow and Enum.Material.Neon or Enum.Material.SmoothPlastic

			local baseTransparency = applyVirtual(color)
			for _, entry in ipairs(pet.parts) do
				local cf = petCFrame * entry.offset
				if entry.spin then
					cf = cf * CFrame.Angles(0, now * 18, 0)
				end
				entry.part.CFrame = cf
				entry.part.Transparency = entry.colored and baseTransparency or baseTransparency * 0.5
				if entry.colored then
					entry.part.Color = color
					entry.part.Material = material
				end
			end

			pet.anchorPart.CFrame = CFrame.new(center)
			pet.label.Text = PET.Name
			pet.label.Visible = PET.Name ~= ""
		end)
		return function()
			for _, connection in ipairs(connections) do
				connection:Disconnect()
			end
			destroyPet()
			petFolder:Destroy()
		end
	end
	RENDERERS.Pet(localPlayer, PET)
end

--------------------------------------------------------------------
-- Hit Effect: эффект, когда вы наносите урон игроку (раздел Misc, видно только вам)
--
-- Как скрипт узнаёт, что урон нанесли именно вы:
--   1) если в ReplicatedStorage есть RemoteEvent "JustVisualsHit" и сервер вызывает
--      JustVisualsHit:FireClient(атакующий, персонажЖертвы, урон) — это самый точный способ;
--   2) иначе — по стандартной метке Roblox "creator" (ObjectValue в Humanoid жертвы),
--      которую ставит большинство классических оружий.
-- Режим «Любой урон» показывает эффект при любой потере здоровья у других игроков.
--------------------------------------------------------------------
local HIT_EFFECT, HIT_MODES, HIT_STYLES, playHitEffect
do
	local Debris = game:GetService("Debris")
	local TweenService = game:GetService("TweenService")
	local ReplicatedStorage = game:GetService("ReplicatedStorage")

	HIT_EFFECT = {
		Enabled = false,
		Mode = "Мои удары",           -- "Мои удары" или "Любой урон"
		Style = "Вспышка + искры",    -- "Вспышка", "Искры", "Вспышка + искры" или "Без эффекта"
		Rainbow = false,
		Color = Color3.fromRGB(255, 90, 90),
		ShowDamage = true,            -- всплывающие числа урона
		Hitmarker = true,             -- крестик-хитмаркер у курсора
		Sound = true,
		Volume = 0.6,
	}

	HIT_MODES = { "Мои удары", "Любой урон" }
	HIT_STYLES = { "Вспышка", "Искры", "Вспышка + искры", "Без эффекта" }

	local hitFolder = Instance.new("Folder")
	hitFolder.Name = "HitEffects_Local"
	hitFolder.Parent = workspace

	local hitSound = Instance.new("Sound")
	hitSound.Name = "HitSound"
	hitSound.SoundId = "rbxasset://sounds/electronicpingshort.wav"
	hitSound.Parent = SoundService

	local function hitColor()
		return HIT_EFFECT.Rainbow and Color3.fromHSV((os.clock() * 0.3) % 1, 0.8, 1) or HIT_EFFECT.Color
	end

	local function flashCharacter(character, color)
		local highlight = Instance.new("Highlight")
		highlight.Adornee = character
		highlight.FillColor = color
		highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
		highlight.FillTransparency = 0.25
		highlight.OutlineTransparency = 0
		highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
		highlight.Parent = hitFolder

		TweenService:Create(highlight, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			FillTransparency = 1,
			OutlineTransparency = 1,
		}):Play()
		Debris:AddItem(highlight, 0.35)
	end

	local function sparkBurst(position, color)
		local part = Instance.new("Part")
		part.Anchored = true
		part.CanCollide = false
		part.CanQuery = false
		part.CanTouch = false
		part.Transparency = 1
		part.Size = Vector3.new(0.5, 0.5, 0.5)
		part.CFrame = CFrame.new(position)
		part.Parent = hitFolder

		local emitter = Instance.new("ParticleEmitter")
		emitter.Texture = "rbxasset://textures/particles/sparkles_main.dds"
		emitter.Enabled = false
		emitter.Color = ColorSequence.new(color)
		emitter.LightEmission = 1
		emitter.LightInfluence = 0
		emitter.Lifetime = NumberRange.new(0.25, 0.45)
		emitter.Speed = NumberRange.new(8, 16)
		emitter.SpreadAngle = Vector2.new(180, 180)
		emitter.Drag = 6
		emitter.Size = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0.5),
			NumberSequenceKeypoint.new(1, 0),
		})
		emitter.Parent = part
		emitter:Emit(20)

		Debris:AddItem(part, 1)
	end

	local function damageNumber(position, damage, color)
		local part = Instance.new("Part")
		part.Anchored = true
		part.CanCollide = false
		part.CanQuery = false
		part.CanTouch = false
		part.Transparency = 1
		part.Size = Vector3.new(0.1, 0.1, 0.1)
		part.CFrame = CFrame.new(position + Vector3.new((math.random() - 0.5) * 2, 0, (math.random() - 0.5) * 2))
		part.Parent = hitFolder

		local billboard = Instance.new("BillboardGui")
		billboard.Size = UDim2.fromOffset(100, 30)
		billboard.StudsOffset = Vector3.new(0, 1, 0)
		billboard.AlwaysOnTop = true
		billboard.Adornee = part
		billboard.Parent = part

		local label = Instance.new("TextLabel")
		label.Size = UDim2.fromScale(1, 1)
		label.BackgroundTransparency = 1
		label.Font = Enum.Font.GothamBlack
		label.TextSize = 20
		label.TextColor3 = color
		label.TextStrokeTransparency = 0.3
		label.Text = "-" .. tostring(math.max(1, math.floor(damage + 0.5)))
		label.Parent = billboard

		local info = TweenInfo.new(0.75, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		TweenService:Create(billboard, info, { StudsOffset = Vector3.new(0, 3.2, 0) }):Play()
		TweenService:Create(label, info, { TextTransparency = 1, TextStrokeTransparency = 1 }):Play()
		Debris:AddItem(part, 0.8)
	end

	local function showHitmarker(root, color)
		local billboard = Instance.new("BillboardGui")
		billboard.Size = UDim2.fromOffset(34, 34)
		billboard.AlwaysOnTop = true
		billboard.Adornee = root
		billboard.Parent = hitFolder

		local marker = new("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromOffset(22, 22),
			BackgroundTransparency = 1,
			Rotation = 45,
			Parent = billboard,
		})
		local scale = new("UIScale", { Scale = 1.4, Parent = marker })

		-- четыре коротких штриха крестом с пустым центром
		local bars = {}
		for _, spec in ipairs({
			{ UDim2.new(0.5, 0, 0, 3), UDim2.fromOffset(2, 7) },
			{ UDim2.new(0.5, 0, 1, -3), UDim2.fromOffset(2, 7) },
			{ UDim2.new(0, 3, 0.5, 0), UDim2.fromOffset(7, 2) },
			{ UDim2.new(1, -3, 0.5, 0), UDim2.fromOffset(7, 2) },
		}) do
			local bar = new("Frame", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = spec[1],
				Size = spec[2],
				BackgroundColor3 = color,
				BorderSizePixel = 0,
				Parent = marker,
			})
			new("UIStroke", { Color = Color3.fromRGB(0, 0, 0), Transparency = 0.4, Parent = bar })
			table.insert(bars, bar)
		end

		TweenService:Create(scale, TweenInfo.new(0.12, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 }):Play()
		task.delay(0.15, function()
			for _, bar in ipairs(bars) do
				TweenService:Create(bar, TweenInfo.new(0.2), { BackgroundTransparency = 1 }):Play()
			end
		end)
		Debris:AddItem(billboard, 0.4)
	end

	function playHitEffect(character, damage)
		if not HIT_EFFECT.Enabled or not character then
			return
		end
		local root = character:FindFirstChild("HumanoidRootPart")
		local head = character:FindFirstChild("Head")
		if not root then
			return
		end

		local color = hitColor()
		local style = HIT_EFFECT.Style

		if style == "Вспышка" or style == "Вспышка + искры" then
			flashCharacter(character, color)
		end
		if style == "Искры" or style == "Вспышка + искры" then
			sparkBurst(root.Position, color)
		end
		if HIT_EFFECT.ShowDamage then
			damageNumber((head or root).Position, damage or 0, color)
		end
		if HIT_EFFECT.Hitmarker then
			showHitmarker(root, color)
		end
		if HIT_EFFECT.Sound then
			hitSound.Volume = HIT_EFFECT.Volume
			hitSound.PlaybackSpeed = 1.5 + math.random() * 0.2
			hitSound.TimePosition = 0
			hitSound:Play()
		end
	end

	-- Способ 1: сигнал от сервера
	local hitRemote = nil
	task.spawn(function()
		hitRemote = ReplicatedStorage:WaitForChild("JustVisualsHit", 5)
		if hitRemote and hitRemote:IsA("RemoteEvent") then
			hitRemote.OnClientEvent:Connect(function(character, damage)
				if HIT_EFFECT.Mode == "Мои удары" then
					playHitEffect(character, tonumber(damage) or 0)
				end
			end)
		else
			hitRemote = nil
		end
	end)

	-- Способ 2: следим за здоровьем других игроков.
	-- Метка creator часто висит на игроке ещё пару секунд после удара, и если в это время его
	-- ранит кто-то другой (или он упадёт), раньше эффект срабатывал «случайно».
	-- Теперь удар засчитывается, только если метка поставлена только что
	-- ИЛИ вы сами атаковали (клик / использование инструмента) меньше секунды назад.
	local lastAttackTime = -math.huge

	-- цель рядом с вами (ближний бой) или под прицелом мыши/центра экрана (стрельба)
	local function aimedAt(character)
		local targetRoot = character:FindFirstChild("HumanoidRootPart")
		local myCharacter = localPlayer.Character
		local myRoot = myCharacter and myCharacter:FindFirstChild("HumanoidRootPart")
		if not targetRoot or not myRoot then
			return false
		end
		if (targetRoot.Position - myRoot.Position).Magnitude <= 14 then
			return true
		end
		local camera = workspace.CurrentCamera
		if not camera then
			return false
		end
		local mouse = UserInputService:GetMouseLocation()
		local ray = camera:ViewportPointToRay(mouse.X, mouse.Y)
		local toTarget = (targetRoot.Position - ray.Origin).Unit
		return toTarget:Dot(ray.Direction.Unit) > math.cos(math.rad(10))
	end

	UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then
			return
		end
		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then
			lastAttackTime = os.clock()
		end
	end)

	local function hookTool(tool)
		if tool:IsA("Tool") then
			tool.Activated:Connect(function()
				lastAttackTime = os.clock()
			end)
		end
	end
	local function hookToolContainer(container)
		for _, child in ipairs(container:GetChildren()) do
			hookTool(child)
		end
		container.ChildAdded:Connect(hookTool)
	end
	task.spawn(function()
		hookToolContainer(localPlayer:WaitForChild("Backpack"))
	end)
	localPlayer.ChildAdded:Connect(function(child)
		if child:IsA("Backpack") then
			hookToolContainer(child)
		end
	end)
	localPlayer.CharacterAdded:Connect(hookToolContainer)
	if localPlayer.Character then
		hookToolContainer(localPlayer.Character)
	end

	local hitConnections = {} -- [Player] = { соединения }

	local function unwatch(player)
		local list = hitConnections[player]
		if list then
			for _, connection in ipairs(list) do
				connection:Disconnect()
			end
			hitConnections[player] = nil
		end
	end

	local function watchCharacter(player, character)
		unwatch(player)

		local humanoid = character:WaitForChild("Humanoid", 10)
		if not humanoid or player.Character ~= character then
			return
		end

		local list = {}
		hitConnections[player] = list
		local lastTagTime = -math.huge

		local function checkTag(tag)
			if tag.Name == "creator" and tag:IsA("ObjectValue") and tag.Value == localPlayer then
				lastTagTime = os.clock()
			end
		end

		table.insert(list, humanoid.ChildAdded:Connect(function(child)
			checkTag(child)
			if child:IsA("ObjectValue") then
				table.insert(list, child.Changed:Connect(function()
					checkTag(child)
				end))
			end
		end))

		local lastHealth = humanoid.Health
		table.insert(list, humanoid.HealthChanged:Connect(function(health)
			local damage = lastHealth - health
			lastHealth = health
			if damage <= 0 or not HIT_EFFECT.Enabled then
				return
			end

			if HIT_EFFECT.Mode == "Любой урон" then
				playHitEffect(character, damage)
			elseif not hitRemote then
				local now = os.clock()
				local creator = humanoid:FindFirstChild("creator")
				local tagOwner = creator and creator:IsA("ObjectValue") and creator.Value or nil
				local freshTag = now - lastTagTime < 0.4
				local justAttacked = now - lastAttackTime < 1
				if tagOwner == localPlayer then
					-- оружие честно пометило, что ударили вы
					if freshTag or justAttacked then
						playHitEffect(character, damage)
					end
				elseif tagOwner == nil and now - lastAttackTime < 0.6 and aimedAt(character) then
					-- Многие оружия вообще не ставят метку creator — раньше в таких играх «Мои удары»
					-- не срабатывали никогда. Теперь удар засчитывается, если вы только что атаковали
					-- и цель рядом (ближний бой) или прямо под прицелом (стрельба).
					playHitEffect(character, damage)
				end
			end
		end))
	end

	local function watchPlayer(player)
		if player == localPlayer then
			return
		end
		player.CharacterAdded:Connect(function(character)
			watchCharacter(player, character)
		end)
		if player.Character then
			task.spawn(watchCharacter, player, player.Character)
		end
	end

	for _, player in ipairs(Players:GetPlayers()) do
		watchPlayer(player)
	end
	Players.PlayerAdded:Connect(watchPlayer)
	Players.PlayerRemoving:Connect(unwatch)
end

--------------------------------------------------------------------
-- «Я бульба»: превращает вашего персонажа в картошку (раздел Misc, видите только вы).
-- Сам персонаж прячется, а на его месте — картофелина с глазками, улыбкой, «глазками» на кожуре
-- и ростком на макушке. Она прикреплена к персонажу: ходит, прыгает и поворачивается вместе с вами,
-- при ходьбе забавно переваливается с боку на бок. Выключили — всё возвращается как было.
--------------------------------------------------------------------
local BULBA
do
	BULBA = {
		Enabled = false,
		Size = 1,
	}
	-- «Фабрика»: рисует этот эффект для любого игрока (owner) по его настройкам (BULBA).
	-- Для вас она вызывается с вашими настройками, для других игроков — с присланными через синхронизацию.
	RENDERERS.Bulba = function(owner, BULBA)
		local connections = {}
		local localPlayer, RunService = syncContext(owner, connections)

		local SKIN = Color3.fromRGB(176, 128, 72)
		local SKIN_DARK = Color3.fromRGB(122, 84, 44)

		local bulbaFolder = Instance.new("Folder")
		bulbaFolder.Name = "Bulba_Local" -- окно предпросмотра тоже показывает картошку
		bulbaFolder.Parent = workspace

		local potato = nil -- { character, parts, hidden, motor, base, connection, size }

		local function restore()
			if not potato then
				return
			end
			if potato.connection then
				potato.connection:Disconnect()
			end
			-- возвращаем персонажу прежнюю прозрачность
			for object, transparency in pairs(potato.hidden) do
				if object.Parent then
					object.Transparency = transparency
				end
			end
			for _, part in ipairs(potato.parts) do
				part:Destroy()
			end
			potato = nil
		end

		local function hide(object)
			if potato.hidden[object] ~= nil then
				return
			end
			if (object:IsA("BasePart") and object.Name ~= "HumanoidRootPart") or object:IsA("Decal") then
				potato.hidden[object] = object.Transparency
				object.Transparency = 1
			end
		end

		local function build(character, root, humanoid)
			restore()
			local s = BULBA.Size
			potato = { character = character, parts = {}, hidden = {}, size = s }

			for _, object in ipairs(character:GetDescendants()) do
				hide(object)
			end
			-- то, что появится позже (инструмент в руках, новые аксессуары), тоже прячем
			potato.connection = character.DescendantAdded:Connect(function(object)
				if potato and potato.character == character then
					hide(object)
				end
			end)

			-- «ось» картошки на шарнире от корня персонажа: через неё картошка переваливается при ходьбе
			local feet = humanoid.RigType == Enum.HumanoidRigType.R6 and -3 or -(humanoid.HipHeight + root.Size.Y / 2)
			local base = CFrame.new(0, feet + 1.55 * s, 0)
			local hub = Instance.new("Part")
			hub.Size = Vector3.new(0.1, 0.1, 0.1)
			hub.Transparency = 1
			hub.CanCollide = false
			hub.CanQuery = false
			hub.CanTouch = false
			hub.Massless = true
			hub.CFrame = root.CFrame * base
			hub.Parent = bulbaFolder
			table.insert(potato.parts, hub)
			local motor = Instance.new("Motor6D")
			motor.Part0 = root
			motor.Part1 = hub
			motor.C0 = base
			motor.Parent = hub
			potato.motor = motor
			potato.base = base

			local function piece(size, offset, color, shape, material)
				local part = Instance.new("Part")
				part.Shape = shape or Enum.PartType.Block
				part.Size = size * s
				part.CFrame = hub.CFrame * CFrame.new(offset.Position * s) * offset.Rotation
				part.Color = color
				part.Material = material or Enum.Material.SmoothPlastic
				part.CanCollide = false
				part.CanQuery = false
				part.CanTouch = false
				part.Massless = true
				part.CastShadow = true
				if not shape then
					local mesh = Instance.new("SpecialMesh")
					mesh.MeshType = Enum.MeshType.Sphere -- гладкий эллипсоид
					mesh.Parent = part
				end
				part.Parent = bulbaFolder
				local weld = Instance.new("WeldConstraint")
				weld.Part0 = hub
				weld.Part1 = part
				weld.Parent = part
				table.insert(potato.parts, part)
				return part
			end

			-- сама картофелина: чуть кривая, из двух «половинок»
			piece(Vector3.new(2.3, 2.9, 2.0), CFrame.new(0, 0, 0), SKIN)
			piece(Vector3.new(2.0, 2.2, 1.8), CFrame.new(0.15, 0.55, 0.05) * CFrame.Angles(0, 0, 0.15), SKIN)
			-- «глазки» на кожуре (тёмные пятнышки)
			for _, spot in ipairs({
				{ -0.9, 0.6, 0.45 }, { 0.95, -0.4, 0.4 }, { -0.6, -0.9, -0.6 }, { 0.5, 1.0, -0.7 },
				{ -1.0, -0.2, -0.3 }, { 0.8, 0.5, 0.55 }, { 0.2, -1.2, 0.55 },
			}) do
				piece(Vector3.new(0.22, 0.16, 0.22), CFrame.new(spot[1], spot[2], spot[3]), SKIN_DARK)
			end

			-- мордочка (смотрит вперёд, туда же, куда персонаж: -Z)
			for _, side in ipairs({ -1, 1 }) do
				piece(Vector3.new(0.5, 0.6, 0.25), CFrame.new(side * 0.42, 0.45, -0.9), Color3.new(1, 1, 1))
				piece(Vector3.new(0.25, 0.32, 0.12), CFrame.new(side * 0.42, 0.42, -1.02), Color3.fromRGB(20, 18, 16))
				piece(Vector3.new(0.08, 0.08, 0.05), CFrame.new(side * 0.36, 0.5, -1.08), Color3.new(1, 1, 1)) -- блик
				-- румяные щёчки
				piece(Vector3.new(0.32, 0.18, 0.1), CFrame.new(side * 0.72, 0.05, -0.85), Color3.fromRGB(225, 120, 110))
			end
			-- улыбка из трёх маленьких дуг-кусочков
			for i, x in ipairs({ -0.25, 0, 0.25 }) do
				local y = (i == 2) and -0.12 or -0.04
				-- края улыбки приподняты: у левого кусочка (x < 0) наружный конец выше — наклон отрицательный
				piece(Vector3.new(0.28, 0.07, 0.07), CFrame.new(x, y, -1.0) * CFrame.Angles(0, 0, (i - 2) * 0.45),
					Color3.fromRGB(60, 30, 20), Enum.PartType.Block)
			end

			-- росток на макушке
			piece(Vector3.new(0.12, 0.5, 0.12), CFrame.new(0.1, 1.6, 0), Color3.fromRGB(110, 170, 70), Enum.PartType.Block)
			piece(Vector3.new(0.45, 0.08, 0.25), CFrame.new(0.32, 1.85, 0) * CFrame.Angles(0, 0, 0.5), Color3.fromRGB(120, 190, 80))
			piece(Vector3.new(0.4, 0.08, 0.22), CFrame.new(-0.12, 1.8, 0) * CFrame.Angles(0, 0, -0.5), Color3.fromRGB(120, 190, 80))
		end

		RunService.RenderStepped:Connect(function()
			local character = localPlayer.Character
			local root = character and character:FindFirstChild("HumanoidRootPart")
			local humanoid = character and character:FindFirstChildOfClass("Humanoid")
			if not BULBA.Enabled or not root or not humanoid or humanoid.Health <= 0 then
				restore()
				return
			end
			if not potato or potato.character ~= character or potato.size ~= BULBA.Size or not potato.motor.Parent then
				build(character, root, humanoid)
			end

			-- переваливается с боку на бок и чуть подпрыгивает при ходьбе
			local now = os.clock()
			local velocity = root.AssemblyLinearVelocity
			local walking = math.clamp(Vector3.new(velocity.X, 0, velocity.Z).Magnitude / 16, 0, 1)
			local waddle = math.sin(now * 11) * 0.16 * walking
			local bounce = math.abs(math.sin(now * 11)) * 0.18 * walking * potato.size
			local breathe = (1 - walking) * math.sin(now * 2) * 0.03 * potato.size
			potato.motor.C0 = potato.base * CFrame.new(0, bounce + breathe, 0) * CFrame.Angles(0, 0, waddle)

			-- в первом лице картошку не видно изнутри
			local camera = workspace.CurrentCamera
			local head = character:FindFirstChild("Head")
			local firstPerson = camera and head and (camera.CFrame.Position - head.Position).Magnitude < 1.5
			for i, part in ipairs(potato.parts) do
				if i > 1 then
					part.LocalTransparencyModifier = firstPerson and 1 or 0
				end
			end
		end)
		return function()
			for _, connection in ipairs(connections) do
				connection:Disconnect()
			end
			restore()
			bulbaFolder:Destroy()
		end
	end
	RENDERERS.Bulba(localPlayer, BULBA)
end

--------------------------------------------------------------------
-- ArrayList: список включённых функций сбоку экрана (раздел Misc)
--------------------------------------------------------------------
local ARRAYLIST, ARRAYLIST_POSITIONS
do
	local TextService = game:GetService("TextService")

	ARRAYLIST = {
		Enabled = true,
		Position = "Справа сверху", -- см. ARRAYLIST_POSITIONS
		Suffix = true,               -- подпись режима: «Trail  Лента», «Custom Sky  Закат»
		Background = true,           -- подложка под строками
		Rainbow = false,             -- полоска и текст переливаются волной
	}
	ARRAYLIST_POSITIONS = { "Справа сверху", "Слева сверху", "Справа снизу", "Слева снизу" }

	local ROW_HEIGHT = 20
	local FONT = Enum.Font.GothamBold
	local TEXT_SIZE = 13

	local listGui = new("ScreenGui", {
		Name = "OpusClient_ArrayList",
		ResetOnSpawn = false,
		DisplayOrder = 80,
		Parent = playerGui,
	})
	local holder = new("Frame", {
		Size = UDim2.fromOffset(260, 600),
		BackgroundTransparency = 1,
		Parent = listGui,
	})

	local rows = {} -- [название] = { frame, bar, label, width, index, removing }
	local lastCheck = 0

	local function toHex(color)
		return string.format("#%02X%02X%02X",
			math.floor(color.R * 255 + 0.5), math.floor(color.G * 255 + 0.5), math.floor(color.B * 255 + 0.5))
	end

	-- текст строки и подпись режима
	local function rowText(name, def)
		local suffix = nil
		if ARRAYLIST.Suffix then
			local mode = def.source.Style or def.source.Preset
			if type(mode) == "string" and def.key == "Enabled" then
				suffix = mode
			end
		end
		local plain = suffix and (name .. "  " .. suffix) or name
		local rich = suffix and (name .. '  <font color="' .. toHex(C.sub) .. '">' .. suffix .. "</font>") or name
		return plain, rich
	end

	local function layout()
		local right = ARRAYLIST.Position:find("Справа") ~= nil
		local bottom = ARRAYLIST.Position:find("снизу") ~= nil
		holder.AnchorPoint = Vector2.new(right and 1 or 0, bottom and 1 or 0)
		local topOffset = 12
		-- в левом верхнем углу обычно стоит Watermark — опускаемся под него
		if not right and not bottom and WATERMARK and WATERMARK.Enabled and WATERMARK.Position == "Слева сверху" then
			topOffset = 50
		end
		holder.Position = UDim2.new(right and 1 or 0, right and -10 or 10, bottom and 1 or 0, bottom and -10 or topOffset)
		return right, bottom
	end

	local function removeRow(name)
		local row = rows[name]
		if not row or row.removing then
			return
		end
		row.removing = true
		local right = holder.AnchorPoint.X > 0.5
		local tween = TweenService:Create(row.frame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
			Position = row.frame.Position + UDim2.fromOffset(right and 40 or -40, 0),
			BackgroundTransparency = 1,
		})
		TweenService:Create(row.label, TweenInfo.new(0.2), { TextTransparency = 1 }):Play()
		TweenService:Create(row.bar, TweenInfo.new(0.2), { BackgroundTransparency = 1 }):Play()
		tween:Play()
		tween.Completed:Connect(function()
			row.frame:Destroy()
			if rows[name] == row then
				rows[name] = nil
			end
		end)
	end

	local function update()
		listGui.Enabled = ARRAYLIST.Enabled
		if not ARRAYLIST.Enabled then
			for name in pairs(rows) do
				removeRow(name)
			end
			return
		end
		local right, bottom = layout()

		-- какие функции сейчас включены (настройки самого меню не показываем)
		local active = {}
		for name, entry in pairs(moduleRegistry) do
			local def = entry.def
			if def and entry.group ~= "Settings" and def.source ~= ARRAYLIST and name ~= "Синхронизация"
				and def.source[def.key] then
				local plain, rich = rowText(name, def)
				local width = TextService:GetTextSize(plain, TEXT_SIZE, FONT, Vector2.new(1000, 100)).X + 18
				table.insert(active, { name = name, rich = rich, width = width })
			end
		end
		-- длинные сверху, короткие снизу — «лесенка», как в клиентах
		table.sort(active, function(a, b)
			if a.width ~= b.width then
				return a.width > b.width
			end
			return a.name < b.name
		end)

		local wanted = {}
		for index, item in ipairs(active) do
			wanted[item.name] = true
			local row = rows[item.name]
			local targetY = bottom and (-(index - 1) * ROW_HEIGHT) or ((index - 1) * ROW_HEIGHT)
			local anchor = Vector2.new(right and 1 or 0, bottom and 1 or 0)
			local targetPosition = UDim2.new(right and 1 or 0, 0, bottom and 1 or 0, targetY)

			if not row or row.removing then
				if row then
					row.frame:Destroy()
				end
				local frame = new("Frame", {
					AnchorPoint = anchor,
					Position = targetPosition + UDim2.fromOffset(right and 40 or -40, 0),
					Size = UDim2.fromOffset(item.width, ROW_HEIGHT),
					BackgroundColor3 = C.bgBottom,
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Parent = holder,
				})
				local bar = new("Frame", {
					AnchorPoint = Vector2.new(right and 1 or 0, 0),
					Position = UDim2.new(right and 1 or 0, 0, 0, 0),
					Size = UDim2.new(0, 2, 1, 0),
					BackgroundColor3 = C.accent,
					BorderSizePixel = 0,
					Parent = frame,
				})
				local label = new("TextLabel", {
					Position = UDim2.fromOffset(right and 6 or 10, 0),
					Size = UDim2.new(1, -16, 1, 0),
					BackgroundTransparency = 1,
					Font = FONT,
					TextSize = TEXT_SIZE,
					RichText = true,
					TextXAlignment = right and Enum.TextXAlignment.Right or Enum.TextXAlignment.Left,
					TextColor3 = C.text,
					TextStrokeTransparency = 0.6,
					TextTransparency = 1,
					Text = item.rich,
					Parent = frame,
				})
				row = { frame = frame, bar = bar, label = label }
				rows[item.name] = row

				-- новая строка выезжает из-за края экрана
				TweenService:Create(frame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
					Position = targetPosition,
					BackgroundTransparency = ARRAYLIST.Background and 0.3 or 1,
				}):Play()
				TweenService:Create(label, TweenInfo.new(0.25), { TextTransparency = 0 }):Play()
			else
				row.frame.AnchorPoint = anchor
				row.label.Text = item.rich
				row.label.TextXAlignment = right and Enum.TextXAlignment.Right or Enum.TextXAlignment.Left
				row.label.Position = UDim2.fromOffset(right and 6 or 10, 0)
				row.bar.AnchorPoint = Vector2.new(right and 1 or 0, 0)
				row.bar.Position = UDim2.new(right and 1 or 0, 0, 0, 0)
				row.frame.BackgroundTransparency = ARRAYLIST.Background and 0.3 or 1
				-- остальные строки плавно сдвигаются на новые места
				if row.frame.Position ~= targetPosition then
					TweenService:Create(row.frame, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
						Position = targetPosition,
					}):Play()
				end
				row.frame.Size = UDim2.fromOffset(item.width, ROW_HEIGHT)
			end
			row.index = index
		end

		for name in pairs(rows) do
			if not wanted[name] then
				removeRow(name)
			end
		end
	end

	RunService.RenderStepped:Connect(function()
		local now = os.clock()
		if now - lastCheck > 0.15 then
			lastCheck = now
			update()
		end

		-- цвета каждый кадр (для радужной волны)
		for _, row in pairs(rows) do
			if not row.removing then
				local color = ARRAYLIST.Rainbow
					and Color3.fromHSV((now * 0.25 + (row.index or 0) * 0.06) % 1, 0.7, 1)
					or C.accent
				row.bar.BackgroundColor3 = color
				row.frame.BackgroundColor3 = C.bgBottom
				row.label.TextColor3 = ARRAYLIST.Rainbow and color or C.text
			end
		end
	end)
end

--------------------------------------------------------------------
-- Hitbox: показывает хитбоксы игроков (раздел Misc, видите только вы).
--   «Корпус» — коробка HumanoidRootPart (по ней во многих играх считаются попадания) с яркими рёбрами;
--   «Части тела» — полупрозрачная коробка на каждой части тела.
-- Рисовать «через стены» или только то, что видно; можно показывать и свой хитбокс.
-- Коробки — это адорнменты, закреплённые на деталях: они двигаются сами, без пересчёта каждый кадр.
--------------------------------------------------------------------
local HITBOX, HITBOX_MODES, HITBOX_DEPTH
do
	HITBOX = {
		Enabled = false,
		Mode = "Корпус",            -- см. HITBOX_MODES
		Depth = "Через стены",      -- см. HITBOX_DEPTH
		Self = false,               -- показывать и свой хитбокс
		Rainbow = false,
		Color = Color3.fromRGB(255, 90, 90),
		Transparency = 0.75,        -- прозрачность заливки
		MaxDistance = 500,
	}
	HITBOX_MODES = { "Корпус", "Части тела" }
	HITBOX_DEPTH = { "Через стены", "Только видимые" }

	local hitboxFolder = Instance.new("Folder")
	hitboxFolder.Name = "Hitbox_Local"
	hitboxFolder.Parent = workspace

	local drawn = {} -- [деталь] = { fill, edges = {} }
	local lastScan = 0

	local function clearPart(part)
		local entry = drawn[part]
		if entry then
			entry.fill:Destroy()
			for _, edge in ipairs(entry.edges) do
				edge:Destroy()
			end
			drawn[part] = nil
		end
	end

	local function clearAll()
		for part in pairs(drawn) do
			clearPart(part)
		end
	end

	local function newBox(part)
		local box = Instance.new("BoxHandleAdornment")
		box.Adornee = part
		box.ZIndex = 5
		box.Parent = hitboxFolder
		return box
	end

	-- коробка на детали; withEdges — ещё 12 тонких рёбер, чтобы контур читался издалека
	local function drawPart(part, withEdges)
		local entry = { fill = newBox(part), edges = {}, withEdges = withEdges }
		if withEdges then
			for _ = 1, 12 do
				table.insert(entry.edges, newBox(part))
			end
		end
		drawn[part] = entry
		return entry
	end

	local function layoutEdges(entry, size)
		local h = size / 2
		local t = math.clamp(math.min(size.X, size.Y, size.Z) * 0.04, 0.03, 0.08)
		local index = 0
		local function edge(center, edgeSize)
			index += 1
			local box = entry.edges[index]
			box.CFrame = CFrame.new(center)
			box.Size = edgeSize
		end
		for _, y in ipairs({ -h.Y, h.Y }) do
			for _, z in ipairs({ -h.Z, h.Z }) do
				edge(Vector3.new(0, y, z), Vector3.new(size.X + t, t, t))
			end
		end
		for _, x in ipairs({ -h.X, h.X }) do
			for _, z in ipairs({ -h.Z, h.Z }) do
				edge(Vector3.new(x, 0, z), Vector3.new(t, size.Y + t, t))
			end
			for _, y in ipairs({ -h.Y, h.Y }) do
				edge(Vector3.new(x, y, 0), Vector3.new(t, t, size.Z + t))
			end
		end
	end

	-- какие детали нужно обвести у этого персонажа
	local function targetParts(character)
		local parts = {}
		if HITBOX.Mode == "Корпус" then
			local root = character:FindFirstChild("HumanoidRootPart")
			if root then
				table.insert(parts, root)
			end
		else
			for _, child in ipairs(character:GetChildren()) do
				if child:IsA("BasePart") and child.Name ~= "HumanoidRootPart" then
					table.insert(parts, child)
				end
			end
		end
		return parts
	end

	local lastMode = nil
	RunService.RenderStepped:Connect(function()
		if not HITBOX.Enabled then
			if next(drawn) then
				clearAll()
			end
			return
		end
		if lastMode ~= HITBOX.Mode then
			lastMode = HITBOX.Mode
			clearAll()
			lastScan = 0
		end

		local now = os.clock()
		local camera = workspace.CurrentCamera

		-- раз в 0.4 с: кого рисовать (живые игроки в пределах дистанции; себя — по настройке)
		if now - lastScan > 0.4 then
			lastScan = now
			local keep = {}
			for _, player in ipairs(Players:GetPlayers()) do
				local character = player.Character
				local humanoid = character and character:FindFirstChildOfClass("Humanoid")
				local root = character and character:FindFirstChild("HumanoidRootPart")
				local allowed = character and humanoid and root and humanoid.Health > 0
					and (player ~= localPlayer or HITBOX.Self)
					and (not camera or (root.Position - camera.CFrame.Position).Magnitude <= HITBOX.MaxDistance)
				if allowed then
					for _, part in ipairs(targetParts(character)) do
						keep[part] = true
						if not drawn[part] then
							drawPart(part, HITBOX.Mode == "Корпус")
						end
					end
				end
			end
			for part in pairs(drawn) do
				if not keep[part] or not part.Parent then
					clearPart(part)
				end
			end
		end

		-- вид: цвет, прозрачность, «через стены»
		local color = HITBOX.Rainbow and Color3.fromHSV((now * 0.3) % 1, 0.8, 1) or HITBOX.Color
		local onTop = HITBOX.Depth == "Через стены"
		for part, entry in pairs(drawn) do
			-- коробка чуть больше детали: иначе в режиме «Только видимые» её грани мерцали бы,
			-- совпадая с поверхностью детали
			local size = part.Size + Vector3.new(0.06, 0.06, 0.06)
			entry.fill.Size = size
			entry.fill.Color3 = color
			entry.fill.Transparency = math.clamp(HITBOX.Transparency, 0, 1)
			entry.fill.AlwaysOnTop = onTop
			if entry.withEdges then
				layoutEdges(entry, size)
				for _, edge in ipairs(entry.edges) do
					edge.Color3 = color:Lerp(Color3.new(1, 1, 1), 0.25)
					edge.Transparency = 0
					edge.AlwaysOnTop = onTop
				end
			end
		end
	end)
end

--------------------------------------------------------------------
-- Растяжение экрана (stretched resolution, как «4:3 растянутый» в шутерах): картинка растягивается
-- по горизонтали, модели и прицел кажутся шире. Работает только у вас и ничего не меняет в игре —
-- это та же камера, просто её изображение «сжато» по вертикали.
-- Каждый кадр, сразу после того как камера Roblox обновилась, к её положению добавляется масштаб по Y.
--------------------------------------------------------------------
local STRETCH, STRETCH_PRESETS
do
	STRETCH = {
		Enabled = false,
		Preset = "4:3",  -- см. STRETCH_PRESETS
		Amount = 0.75,   -- для «Своё»: 1 — без растяжения, меньше — сильнее растянуто
	}
	STRETCH_PRESETS = { "4:3", "5:4", "16:10", "Своё" }
	-- насколько «сжать» вертикаль, чтобы картинка формата X выглядела растянутой на широком экране 16:9
	local FACTORS = { ["4:3"] = (4 / 3) / (16 / 9), ["5:4"] = (5 / 4) / (16 / 9), ["16:10"] = (16 / 10) / (16 / 9) }

	RunService:BindToRenderStep("OpusStretch", Enum.RenderPriority.Camera.Value + 1, function()
		if not STRETCH.Enabled then
			return
		end
		local camera = workspace.CurrentCamera
		if not camera then
			return
		end
		local factor = FACTORS[STRETCH.Preset] or math.clamp(STRETCH.Amount, 0.4, 1)
		if factor >= 0.999 then
			return
		end
		camera.CFrame = camera.CFrame * CFrame.new(0, 0, 0, 1, 0, 0, 0, factor, 0, 0, 0, 1)
	end)
end

--------------------------------------------------------------------
-- Синхронизация: вы видите шляпу, ауру, спину, платформу, питомца и «Я бульба» других игроков,
-- у которых тоже запущено это меню, а они — ваши. Нужен серверный скрипт JustVisualsConfigs.
-- Раз в полсекунды меню смотрит, изменились ли ваши настройки этих эффектов, и если да — отправляет
-- их на сервер (не чаще раза в секунду). Сервер пересылает их остальным, а их меню рисует эффекты
-- на вашем персонаже теми же «фабриками», что и у вас.
--------------------------------------------------------------------
local SYNC = { Enabled = true } -- синхронизация всегда включена (карточки в меню нет)
do
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local HttpService = game:GetService("HttpService")
	local GROUPS = { Hat = HAT, Aura = AURA, Back = BACK, Bottom = BOTTOM, Bulba = BULBA, Pet = PET }

	local function encode(value)
		if typeof(value) == "Color3" then
			return { __color = true, r = value.R, g = value.G, b = value.B }
		end
		return value
	end
	local function decode(value)
		if type(value) == "table" and value.__color then
			return Color3.new(tonumber(value.r) or 0, tonumber(value.g) or 0, tonumber(value.b) or 0)
		end
		return value
	end

	local function snapshot()
		local data = {}
		for name, source in pairs(GROUPS) do
			local group = {}
			for key, value in pairs(source) do
				local kind = typeof(value)
				if kind == "boolean" or kind == "number" or kind == "string" or kind == "Color3" then
					group[key] = encode(value)
				end
			end
			data[name] = group
		end
		return data
	end

	local remotes = {} -- [игрок] = { configs = { [эффект] = настройки }, stops = { [эффект] = функция выключения } }

	local function stopPlayer(player)
		local entry = remotes[player]
		if not entry then
			return
		end
		for _, stop in pairs(entry.stops) do
			pcall(stop)
		end
		remotes[player] = nil
	end

	local function applyRemote(player, data)
		if player == localPlayer then
			return
		end
		if not SYNC.Enabled or type(data) ~= "table" then
			stopPlayer(player)
			return
		end
		local entry = remotes[player] or { configs = {}, stops = {} }
		remotes[player] = entry
		for name, defaults in pairs(GROUPS) do
			local incoming = data[name]
			if type(incoming) == "table" then
				local config = entry.configs[name]
				if not config then
					-- копия ваших настроек как основа (чтобы были все нужные поля), затем — присланные значения
					config = {}
					for key, value in pairs(defaults) do
						config[key] = value
					end
					config.Enabled = false
					entry.configs[name] = config
				end
				for key, value in pairs(incoming) do
					local decoded = decode(value)
					if defaults[key] ~= nil and typeof(decoded) == typeof(defaults[key]) then
						config[key] = decoded
					end
				end
				-- эффект у другого игрока начинаем рисовать, только когда он его впервые включил
				if not entry.stops[name] and config.Enabled and RENDERERS[name] then
					local ok, stop = pcall(RENDERERS[name], player, config)
					if ok then
						entry.stops[name] = stop
					end
				end
			end
		end
	end

	Players.PlayerRemoving:Connect(stopPlayer)

	task.spawn(function()
		local remote = ReplicatedStorage:WaitForChild("OpusVisualsSync", 10)
		if not remote then
			return -- серверной части нет: синхронизация просто не работает, остальное меню — работает
		end
		remote.OnClientEvent:Connect(function(player, data)
			if typeof(player) == "Instance" and player:IsA("Player") then
				applyRemote(player, data)
			end
		end)
		remote:FireServer("request") -- получить эффекты тех, кто уже в игре

		local lastJson, lastSend, lastEnabled = nil, 0, SYNC.Enabled
		while true do
			task.wait(0.5)
			if SYNC.Enabled ~= lastEnabled then
				lastEnabled = SYNC.Enabled
				lastJson = nil
				if SYNC.Enabled then
					remote:FireServer("request")
				else
					remote:FireServer("off") -- другие перестают видеть ваши эффекты
					for player in pairs(remotes) do
						stopPlayer(player)
					end
				end
			end
			if SYNC.Enabled then
				local data = snapshot()
				local ok, json = pcall(HttpService.JSONEncode, HttpService, data)
				if ok and json ~= lastJson and os.clock() - lastSend >= 1 then
					lastJson = json
					lastSend = os.clock()
					remote:FireServer(data)
				end
			end
		end
	end)
end

--------------------------------------------------------------------
-- Раздел Misc
--------------------------------------------------------------------
local miscSection = createSection("Misc")

addModule(miscSection, {
	name = "ArrayList",
	desc = "Список включённых функций сбоку экрана.",
	source = ARRAYLIST,
	key = "Enabled",
	settings = function(page)
		choiceSetting(page, "Положение", "Position", ARRAYLIST_POSITIONS, ARRAYLIST)
		toggleSetting(page, "Подписи режимов", "Suffix", ARRAYLIST)
		toggleSetting(page, "Подложка", "Background", ARRAYLIST)
		toggleSetting(page, "Радужная волна", "Rainbow", ARRAYLIST)
	end,
})

addModule(miscSection, {
	name = "Я бульба",
	desc = "Превращает вас в картошку.",
	source = BULBA,
	key = "Enabled",
	settings = function(page)
		numberSetting(page, "Размер картошки", "Size", 0.5, 2, BULBA)
	end,
})

addModule(miscSection, {
	name = "Hitbox",
	desc = "Показывает хитбоксы игроков.",
	source = HITBOX,
	key = "Enabled",
	settings = function(page)
		choiceSetting(page, "Что обводить", "Mode", HITBOX_MODES, HITBOX)
		choiceSetting(page, "Отображение", "Depth", HITBOX_DEPTH, HITBOX)
		toggleSetting(page, "Применять на себе", "Self", HITBOX)
		toggleSetting(page, "Радужный", "Rainbow", HITBOX)
		colorSetting(page, "Цвет", "Color", HITBOX)
		numberSetting(page, "Прозрачность заливки", "Transparency", 0, 1, HITBOX)
		numberSetting(page, "Дистанция", "MaxDistance", 50, 2000, HITBOX)
	end,
})

addModule(miscSection, {
	name = "Растяжение экрана",
	desc = "Растянутая картинка, как 4:3 в шутерах.",
	source = STRETCH,
	key = "Enabled",
	settings = function(page)
		choiceSetting(page, "Формат", "Preset", STRETCH_PRESETS, STRETCH)
		numberSetting(page, "Своё растяжение (1 — нет)", "Amount", 0.4, 1, STRETCH)
	end,
})

addModule(miscSection, {
	name = "Watermark",
	desc = "Логотип, FPS, пинг и время на экране.",
	source = WATERMARK,
	key = "Enabled",
	settings = function(page)
		toggleSetting(page, "Логотип", "ShowLogo", WATERMARK)
		toggleSetting(page, "FPS", "ShowFPS", WATERMARK)
		toggleSetting(page, "Пинг", "ShowPing", WATERMARK)
		toggleSetting(page, "Время", "ShowTime", WATERMARK)
		toggleSetting(page, "Секунды во времени", "ShowSeconds", WATERMARK)
		choiceSetting(page, "Положение", "Position", WATERMARK_POSITIONS, WATERMARK)
	end,
})

addModule(miscSection, {
	name = "Custom Cursor",
	desc = "Свой курсор вместо стандартного.",
	source = CURSOR,
	key = "Enabled",
	settings = function(page)
		choiceSetting(page, "Форма", "Style", CURSOR_STYLES, CURSOR)
		toggleSetting(page, "Радужный", "Rainbow", CURSOR)
		colorSetting(page, "Цвет", "Color", CURSOR)
		numberSetting(page, "Размер", "Size", 6, 48, CURSOR)
		numberSetting(page, "Толщина", "Thickness", 1, 6, CURSOR)
		toggleSetting(page, "Обводка", "Outline", CURSOR)
		toggleSetting(page, "Вращение", "Spin", CURSOR)
		numberSetting(page, "Прозрачность", "Transparency", 0, 0.9, CURSOR)
	end,
})

addModule(miscSection, {
	name = "Target ESP",
	desc = "Частицы вокруг игроков рядом с вами.",
	source = TARGET_ESP,
	key = "Enabled",
	settings = function(page)
		choiceSetting(page, "Кому показывать", "Mode", TARGET_MODES, TARGET_ESP)
		choiceSetting(page, "Частицы", "Style", TARGET_STYLES, TARGET_ESP)
		numberSetting(page, "Радиус", "Radius", 5, 300, TARGET_ESP)
		toggleSetting(page, "Радужные", "Rainbow", TARGET_ESP)
		colorSetting(page, "Цвет", "Color", TARGET_ESP)
		toggleSetting(page, "Glow", "Glow", TARGET_ESP)
		numberSetting(page, "Количество шариков", "Count", 1, 16, TARGET_ESP)
		numberSetting(page, "Размер", "Size", 0.1, 1.5, TARGET_ESP)
		numberSetting(page, "Скорость", "Speed", 0.2, 8, TARGET_ESP)
		toggleSetting(page, "Союзники", "ShowTeammates", TARGET_ESP)
	end,
})

addModule(miscSection, {
	name = "Custom Pet",
	desc = "Виртуальный питомец, который следует за вами.",
	source = PET,
	key = "Enabled",
	settings = function(page)
		choiceSetting(page, "Питомец", "Style", PET_STYLES, PET)
		textSetting(page, "Имя", "Name", 20, PET)
		toggleSetting(page, "Радужный", "Rainbow", PET)
		colorSetting(page, "Цвет", "Color", PET)
		toggleSetting(page, "Glow", "Glow", PET)
		numberSetting(page, "Размер", "Size", 0.5, 3, PET)
		choiceSetting(page, "Где летает", "Side", PET_SIDES, PET)
		numberSetting(page, "Скорость следования", "FollowSpeed", 1, 20, PET)
		toggleSetting(page, "Покачивание", "Bobbing", PET)
		toggleSetting(page, "Виртуальный вид", "Virtual", PET)
		numberSetting(page, "Прозрачность", "Transparency", 0, 0.9, PET)
	end,
})

addModule(miscSection, {
	name = "Hit Effect",
	desc = "Эффект, когда вы наносите урон игроку.",
	source = HIT_EFFECT,
	key = "Enabled",
	settings = function(page)
		choiceSetting(page, "Когда срабатывает", "Mode", HIT_MODES, HIT_EFFECT)
		choiceSetting(page, "Эффект", "Style", HIT_STYLES, HIT_EFFECT)
		toggleSetting(page, "Радужный", "Rainbow", HIT_EFFECT)
		colorSetting(page, "Цвет", "Color", HIT_EFFECT)
		toggleSetting(page, "Числа урона", "ShowDamage", HIT_EFFECT)
		toggleSetting(page, "Хитмаркер", "Hitmarker", HIT_EFFECT)
		toggleSetting(page, "Звук попадания", "Sound", HIT_EFFECT)
		numberSetting(page, "Громкость", "Volume", 0, 3, HIT_EFFECT)
		actionSetting(page, "Проверить эффект", "На себе", function()
			local enabledBefore = HIT_EFFECT.Enabled
			HIT_EFFECT.Enabled = true
			playHitEffect(localPlayer.Character, 25)
			HIT_EFFECT.Enabled = enabledBefore
		end)
	end,
})

addModule(miscSection, {
	name = "Toggle Sounds",
	desc = "Звук при включении и выключении функций.",
	source = SOUNDS,
	key = "Enabled",
	settings = function(page)
		choiceSetting(page, "Звук", "Style", SOUND_STYLES, SOUNDS)
		numberSetting(page, "Громкость", "Volume", 0, 3, SOUNDS)
		numberSetting(page, "Тон включения", "OnPitch", 0.5, 2, SOUNDS)
		numberSetting(page, "Тон выключения", "OffPitch", 0.5, 2, SOUNDS)
		actionSetting(page, "Проверить звук", "Включение", function()
			playToggleSound(true)
		end)
		actionSetting(page, "Проверить звук", "Выключение", function()
			playToggleSound(false)
		end)
	end,
})


--------------------------------------------------------------------
-- Раздел «Образы»: готовые сочетания визуалов в один клик (шляпа, спина, аура, частицы, небо, шейдеры).
-- После применения всё можно донастроить вручную — это просто быстрый старт.
--------------------------------------------------------------------
do
	local white = Color3.fromRGB(255, 255, 255)
	local blue = Color3.fromRGB(90, 170, 255)
	local cyan = Color3.fromRGB(90, 230, 230)
	local red = Color3.fromRGB(255, 90, 90)
	local yellow = Color3.fromRGB(255, 230, 90)
	local violet = Color3.fromRGB(170, 110, 255)

	local PRESETS = {
		{
			name = "Небесный", desc = "Нимб, крылья света, сияние и созвездия — как в видео.",
			icon = "eye",
			apply = {
				[HAT] = { Enabled = true, Style = "Нимб", Color = white, Glow = true, Rainbow = false },
				[BACK] = { Enabled = true, Style = "Крылья света", Color = blue, Glow = true, Rainbow = false },
				[AURA] = { Enabled = true, Style = "Сияние", Color = blue, Glow = true, Rainbow = false },
				[PARTICLES] = { Enabled = false },
				[CONSTELLATIONS] = { Enabled = true, Color = Color3.fromRGB(150, 185, 255), Glow = true, Rainbow = false },
				[SKY] = { Enabled = true, Preset = "Ночь", LightingMode = "Как у неба" },
				[SHADERS] = { Enabled = true, Preset = "Кино" },
				[TARGET_ESP] = { Enabled = true, Style = "Орбиты", Color = blue, Glow = true, Rainbow = false },
				[HIT_EFFECT] = { Enabled = true, Style = "Вспышка + искры", Color = blue, Rainbow = false },
			},
		},
		{
			name = "Странник", desc = "Китайская шляпа, крылья света и сияние под ночным небом.",
			icon = "diamond",
			apply = {
				[HAT] = { Enabled = true, Style = "Китайская", Color = white, Glow = false, Rainbow = false },
				[BACK] = { Enabled = true, Style = "Крылья света", Color = cyan, Glow = true, Rainbow = false },
				[AURA] = { Enabled = true, Style = "Сияние", Color = cyan, Glow = true, Rainbow = false },
				[PARTICLES] = { Enabled = false },
				[CONSTELLATIONS] = { Enabled = false },
				-- небо меняется без освещения: свет в мире остаётся как в игре
				[SKY] = { Enabled = true, Preset = "Ночь", LightingMode = "Игры" },
				-- шейдеры без виньетки (края экрана не затемняются)
				[SHADERS] = { Enabled = true, Preset = "Реализм", Vignette = false },
				[TARGET_ESP] = { Enabled = true, Style = "Орбиты", Color = cyan, Glow = true, Rainbow = false },
				[HIT_EFFECT] = { Enabled = true, Style = "Вспышка", Color = cyan, Rainbow = false },
			},
		},
		{
			name = "Ангел", desc = "Золотой нимб, белые крылья, орбиты и мягкий свет дня.",
			icon = "ring",
			apply = {
				[HAT] = { Enabled = true, Style = "Нимб", Color = yellow, Glow = true, Rainbow = false },
				[BACK] = { Enabled = true, Style = "Крылья ангела", Color = white, Glow = true, Rainbow = false },
				[AURA] = { Enabled = true, Style = "Орбиты", Color = yellow, Glow = true, Rainbow = false },
				[PARTICLES] = { Enabled = true, Style = "Искры", Color = white, Glow = true, Rainbow = false },
				[CONSTELLATIONS] = { Enabled = false },
				[SKY] = { Enabled = true, Preset = "День", LightingMode = "Игры" },
				[SHADERS] = { Enabled = true, Preset = "Мягкий" },
				[TARGET_ESP] = { Enabled = true, Style = "Орбиты", Color = yellow, Glow = true, Rainbow = false },
				[HIT_EFFECT] = { Enabled = true, Style = "Вспышка + искры", Color = yellow, Rainbow = false },
			},
		},
		{
			name = "Демон", desc = "Рога, крылья демона, энергия и огненный закат.",
			icon = "x",
			apply = {
				[HAT] = { Enabled = true, Style = "Рога", Color = red, Glow = true, Rainbow = false },
				[BACK] = { Enabled = true, Style = "Крылья демона", Color = red, Glow = true, Rainbow = false },
				[AURA] = { Enabled = true, Style = "Энергия", Color = red, Glow = true, Rainbow = false },
				[PARTICLES] = { Enabled = true, Style = "Огоньки", Color = red, Glow = true, Rainbow = false },
				[CONSTELLATIONS] = { Enabled = false },
				[SKY] = { Enabled = true, Preset = "Закат", LightingMode = "Как у неба" },
				[SHADERS] = { Enabled = true, Preset = "Кино" },
				[TARGET_ESP] = { Enabled = true, Style = "Орбиты", Color = red, Glow = true, Rainbow = false },
				[HIT_EFFECT] = { Enabled = true, Style = "Искры", Color = red, Rainbow = false },
			},
		},
		{
			name = "Космос", desc = "Спираль, созвездия и космическое небо.",
			icon = "palette",
			apply = {
				[HAT] = { Enabled = false },
				[BACK] = { Enabled = false },
				[AURA] = { Enabled = true, Style = "Спираль", Color = violet, Glow = true, Rainbow = false },
				[PARTICLES] = { Enabled = false },
				[CONSTELLATIONS] = { Enabled = true, Color = Color3.fromRGB(150, 185, 255), Glow = true, Rainbow = false },
				[SKY] = { Enabled = true, Preset = "Космос", LightingMode = "Как у неба" },
				[SHADERS] = { Enabled = true, Preset = "Яркий" },
				[TARGET_ESP] = { Enabled = true, Style = "Орбиты", Color = violet, Glow = true, Rainbow = false },
				[HIT_EFFECT] = { Enabled = true, Style = "Вспышка + искры", Color = violet, Rainbow = false },
			},
		},
		{
			name = "Выключить всё", desc = "Снять все визуалы: шляпу, спину, ауру, частицы, небо, шейдеры, Target ESP и удары.",
			icon = "x",
			apply = {
				[HAT] = { Enabled = false }, [BACK] = { Enabled = false }, [AURA] = { Enabled = false },
				[PARTICLES] = { Enabled = false }, [SKY] = { Enabled = false }, [SHADERS] = { Enabled = false },
				[CONSTELLATIONS] = { Enabled = false },
				[TARGET_ESP] = { Enabled = false },
				[HIT_EFFECT] = { Enabled = false },
			},
		},
	}

	local presetsSection = createSection("Образы")

	for index, preset in ipairs(PRESETS) do
		local card = new("TextButton", {
			LayoutOrder = index,
			BackgroundColor3 = C.card,
			BackgroundTransparency = 0.05,
			BorderSizePixel = 0,
			AutoButtonColor = false,
			Text = "",
			Parent = presetsSection.grid,
		})
		round(card, 8)
		local stroke = outline(card, C.line, 0.65)
		local cardScale = new("UIScale", { Parent = card })

		local icon = new("Frame", {
			Position = UDim2.fromOffset(10, 8),
			Size = UDim2.fromOffset(22, 22),
			BackgroundColor3 = C.accent,
			BorderSizePixel = 0,
			Parent = card,
		})
		round(icon, 6)
		drawIcon(icon, preset.icon, 12)(C.text)

		new("TextLabel", {
			Position = UDim2.fromOffset(40, 8),
			Size = UDim2.new(1, -50, 0, 22),
			BackgroundTransparency = 1,
			Font = Enum.Font.GothamBold,
			TextSize = 14,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextColor3 = C.text,
			Text = preset.name,
			Parent = card,
		})
		local descLabel = new("TextLabel", {
			Position = UDim2.fromOffset(12, 32),
			Size = UDim2.new(1, -24, 0, 28),
			BackgroundTransparency = 1,
			Font = Enum.Font.Gotham,
			TextSize = 12,
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
			TextColor3 = C.sub,
			Text = preset.desc,
			Parent = card,
		})

		card.MouseButton1Click:Connect(function()
			for source, values in pairs(preset.apply) do
				for key, value in pairs(values) do
					source[key] = value
				end
			end
			for _, refresh in ipairs(uiRefreshers) do
				refresh()
			end
			playToggleSound(true)
			showToast("Образ «" .. preset.name .. "»", preset.name ~= "Выключить всё")
			descLabel.Text = "Применено"
			descLabel.TextColor3 = C.accent
			task.delay(1.4, function()
				descLabel.Text = preset.desc
				descLabel.TextColor3 = C.sub
			end)
		end)

		local hover = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		card.MouseEnter:Connect(function()
			TweenService:Create(card, hover, { BackgroundColor3 = C.cardHover }):Play()
			TweenService:Create(cardScale, hover, { Scale = 1.025 }):Play()
			stroke.Color = C.accent
			stroke.Transparency = 0.3
		end)
		card.MouseLeave:Connect(function()
			TweenService:Create(card, hover, { BackgroundColor3 = C.card }):Play()
			TweenService:Create(cardScale, hover, { Scale = 1 }):Play()
			stroke.Color = C.line
			stroke.Transparency = 0.65
		end)

		table.insert(presetsSection.cards, { frame = card, name = preset.name, desc = preset.desc })
	end
end

--------------------------------------------------------------------
-- Раздел Config: свои конфиги с названиями
-- Конфиги хранятся на сервере (DataStore), если в игре есть скрипт JustVisualsConfigs.server.lua.
-- Без него они работают, но живут только до выхода из игры.
--------------------------------------------------------------------
do
	local ReplicatedStorage = game:GetService("ReplicatedStorage")

	local CONFIG_TABLES = {
		ESP = CONFIG,
		Hat = HAT,
		Trail = TRAIL,
		JumpCircle = JUMP_CIRCLE,
		Particles = PARTICLES,
		Constellations = CONSTELLATIONS,
		Fog = FOG,
		Sounds = SOUNDS,
		Watermark = WATERMARK,
		Cursor = CURSOR,
		TargetESP = TARGET_ESP,
		ArrayList = ARRAYLIST,
		Bulba = BULBA,
		Hitbox = HITBOX,
		Stretch = STRETCH,
		Pet = PET,
		HitEffect = HIT_EFFECT,
		Menu = MENU_STYLE,
		Binds = KEYBINDS,
		Sky = SKY,
		Shaders = SHADERS,
		Aura = AURA,
		Back = BACK,
		Bottom = BOTTOM,
	}
	local MAX_CONFIGS = 20
	local MAX_NAME_LENGTH = 30

	-- Настройки -> обычная таблица (Color3 превращаем в {r, g, b}, клавиши и прочее не сохраняем)
	local function serializeSettings()
		local data = {}
		for groupName, source in pairs(CONFIG_TABLES) do
			local group = {}
			for key, value in pairs(source) do
				local valueType = typeof(value)
				if valueType == "boolean" or valueType == "number" or valueType == "string" then
					group[key] = value
				elseif valueType == "Color3" then
					group[key] = {
						__color = true,
						r = math.floor(value.R * 255 + 0.5),
						g = math.floor(value.G * 255 + 0.5),
						b = math.floor(value.B * 255 + 0.5),
					}
				end
			end
			data[groupName] = group
		end
		return data
	end

	local function applySettings(data)
		-- клавиши — особый случай: набор названий заранее неизвестен, поэтому берём список целиком
		if type(data.Binds) == "table" then
			table.clear(KEYBINDS)
			for name, key in pairs(data.Binds) do
				if type(name) == "string" and type(key) == "string" then
					if name == "China Hat" then
						name = "Hat" -- функция переименована
					end
					KEYBINDS[name] = key
				end
			end
		end
		for groupName, group in pairs(data) do
			local source = groupName ~= "Binds" and CONFIG_TABLES[groupName]
			if source and type(group) == "table" then
				for key, value in pairs(group) do
					local current = source[key]
					if current ~= nil then
						if typeof(current) == "Color3" and type(value) == "table" and value.__color then
							source[key] = Color3.fromRGB(value.r, value.g, value.b)
						elseif typeof(current) == typeof(value) then
							source[key] = value
						end
					end
				end
			end
		end
		for _, refresh in ipairs(uiRefreshers) do
			refresh()
		end
	end

	local savedConfigs = {} -- [название] = { data, savedAt }
	local autoloadName = nil
	local configRemote = ReplicatedStorage:WaitForChild("JustVisualsConfigs", 3)

	local function persistConfigs()
		if not configRemote then
			return
		end
		task.spawn(function()
			local ok, result = pcall(function()
				return configRemote:InvokeServer("set", { configs = savedConfigs, autoload = autoloadName })
			end)
			if not ok or result == false then
				warn("opus client: не удалось сохранить конфиги на сервере", result)
			end
		end)
	end

	local configSection = createSection("Config", "Settings")
	local configCards = {} -- { card, page }
	local rebuildConfigCards

	-- Карточка «Новый конфиг»: поле для названия и кнопка сохранения
	local createCard = new("Frame", {
		LayoutOrder = 0,
		BackgroundColor3 = C.card,
		BackgroundTransparency = 0.15,
		BorderSizePixel = 0,
		Parent = configSection.grid,
	})
	round(createCard, 8)
	outline(createCard, C.accent, 0.55)

	local createTitle = new("TextLabel", {
		Position = UDim2.fromOffset(12, 6),
		Size = UDim2.new(1, -24, 0, 20),
		BackgroundTransparency = 1,
		Font = Enum.Font.GothamBold,
		TextSize = 13,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextColor3 = C.text,
		Text = "Новый конфиг",
		Parent = createCard,
	})

	local nameBox = new("TextBox", {
		Position = UDim2.fromOffset(12, 32),
		Size = UDim2.new(1, -58, 0, 24),
		BackgroundColor3 = C.inner,
		BorderSizePixel = 0,
		Font = Enum.Font.Gotham,
		TextSize = 12,
		TextColor3 = C.text,
		TextXAlignment = Enum.TextXAlignment.Left,
		PlaceholderText = "Название...",
		PlaceholderColor3 = C.sub,
		ClearTextOnFocus = false,
		Text = "",
		Parent = createCard,
	})
	round(nameBox, 6)
	new("UIPadding", { PaddingLeft = UDim.new(0, 8), Parent = nameBox })

	local saveButton = new("TextButton", {
		Position = UDim2.new(1, -40, 0, 32),
		Size = UDim2.fromOffset(28, 24),
		BackgroundColor3 = C.accent,
		BorderSizePixel = 0,
		AutoButtonColor = true,
		Font = Enum.Font.GothamBold,
		TextSize = 16,
		TextColor3 = C.text,
		Text = "+",
		Parent = createCard,
	})
	round(saveButton, 6)

	local flashId = 0
	local function flashTitle(text, color)
		flashId += 1
		local myId = flashId
		createTitle.Text = text
		createTitle.TextColor3 = color or C.text
		task.delay(1.6, function()
			if flashId == myId then
				createTitle.Text = "Новый конфиг"
				createTitle.TextColor3 = C.text
			end
		end)
	end

	local function countConfigs()
		local count = 0
		for _ in pairs(savedConfigs) do
			count += 1
		end
		return count
	end

	local function saveNewConfig()
		local name = nameBox.Text:gsub("^%s+", ""):gsub("%s+$", "")
		if name == "" then
			flashTitle("Введите название", C.accent)
			return
		end
		if #name > MAX_NAME_LENGTH then
			flashTitle("Слишком длинное название", C.accent)
			return
		end
		if not savedConfigs[name] and countConfigs() >= MAX_CONFIGS then
			flashTitle("Максимум " .. MAX_CONFIGS .. " конфигов", C.accent)
			return
		end

		local existed = savedConfigs[name] ~= nil
		savedConfigs[name] = { data = serializeSettings(), savedAt = os.time() }
		nameBox.Text = ""
		persistConfigs()
		rebuildConfigCards()
		playToggleSound(true)
		flashTitle(existed and "Перезаписан" or "Сохранён")
	end

	saveButton.MouseButton1Click:Connect(saveNewConfig)
	nameBox.FocusLost:Connect(function(enterPressed)
		if enterPressed then
			saveNewConfig()
		end
	end)

	local function removeConfigCardsFromSearch()
		for index = #configSection.cards, 1, -1 do
			if configSection.cards[index].isConfig then
				table.remove(configSection.cards, index)
			end
		end
	end

	rebuildConfigCards = function()
		-- если открыта страница удаляемой карточки — возвращаемся к сетке
		if currentModule and currentModule.isConfig then
			showGrid()
		end

		for _, entry in ipairs(configCards) do
			entry.card:Destroy()
			entry.page:Destroy()
		end
		table.clear(configCards)
		removeConfigCardsFromSearch()

		local names = {}
		for name in pairs(savedConfigs) do
			table.insert(names, name)
		end
		table.sort(names, function(a, b)
			return a:lower() < b:lower()
		end)

		for index, name in ipairs(names) do
			local entry = savedConfigs[name]
			local isAutoload = autoloadName == name
			local descText = "Сохранён " .. os.date("%d.%m %H:%M", entry.savedAt or os.time())
				.. (isAutoload and "  ·  авто" or "")

			local card = new("TextButton", {
				LayoutOrder = index,
				BackgroundColor3 = C.card,
				BackgroundTransparency = 0.15,
				BorderSizePixel = 0,
				AutoButtonColor = false,
				Text = "",
				Parent = configSection.grid,
			})
			round(card, 8)

			local icon = new("Frame", {
				Position = UDim2.fromOffset(12, 13),
				Size = UDim2.fromOffset(12, 12),
				BackgroundColor3 = isAutoload and C.accent or C.accentDim,
				BorderSizePixel = 0,
				Parent = card,
			})
			round(icon, 3)

			new("TextLabel", {
				Position = UDim2.fromOffset(32, 8),
				Size = UDim2.new(1, -62, 0, 22),
				BackgroundTransparency = 1,
				Font = Enum.Font.GothamBold,
				TextSize = 13,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextTruncate = Enum.TextTruncate.AtEnd,
				TextColor3 = C.text,
				Text = name,
				Parent = card,
			})

			local desc = new("TextLabel", {
				Position = UDim2.fromOffset(12, 32),
				Size = UDim2.new(1, -24, 0, 28),
				BackgroundTransparency = 1,
				Font = Enum.Font.Gotham,
				TextSize = 11,
				TextWrapped = true,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top,
				TextColor3 = C.sub,
				Text = descText,
				Parent = card,
			})

			local dots = new("TextButton", {
				Position = UDim2.new(1, -28, 0, 6),
				Size = UDim2.fromOffset(22, 22),
				BackgroundTransparency = 1,
				Text = "",
				ZIndex = 2,
				Parent = card,
			})
			drawIcon(dots, "kebab", 14)(C.sub)

			local function loadThis()
				applySettings(entry.data)
				playToggleSound(true)
				desc.Text = "Загружен"
				desc.TextColor3 = C.accent
				task.delay(1.6, function()
					if desc.Parent then
						desc.Text = descText
						desc.TextColor3 = C.sub
					end
				end)
			end

			-- страница действий с конфигом
			local page = makeScroller(name .. "_Config")
			new("UIListLayout", {
				Padding = UDim.new(0, 6),
				SortOrder = Enum.SortOrder.LayoutOrder,
				Parent = page,
			})
			actionSetting(page, "Загрузить настройки", "Загрузить", function()
				loadThis()
			end)
			actionSetting(page, "Сохранить текущие сюда", "Перезаписать", function()
				savedConfigs[name] = { data = serializeSettings(), savedAt = os.time() }
				persistConfigs()
				playToggleSound(true)
				rebuildConfigCards()
			end)
			actionSetting(page, "Загружать при запуске", isAutoload and "Выключить" or "Включить", function()
				autoloadName = (autoloadName == name) and nil or name
				persistConfigs()
				playToggleSound(autoloadName == name)
				rebuildConfigCards()
			end)
			actionSetting(page, "Удалить конфиг", "Удалить", function()
				savedConfigs[name] = nil
				if autoloadName == name then
					autoloadName = nil
				end
				persistConfigs()
				playToggleSound(false)
				rebuildConfigCards()
			end)

			local module = { name = name, page = page, isConfig = true }
			dots.MouseButton1Click:Connect(function()
				openSettings(module)
			end)

			card.MouseButton1Click:Connect(loadThis)
			card.MouseEnter:Connect(function()
				card.BackgroundColor3 = C.cardHover
			end)
			card.MouseLeave:Connect(function()
				card.BackgroundColor3 = C.card
			end)

			table.insert(configCards, { card = card, page = page })
			table.insert(configSection.cards, { frame = card, name = name, desc = descText, isConfig = true })
		end
	end

	-- Загружаем сохранённые конфиги с сервера и применяем автозагрузку
	task.spawn(function()
		if configRemote then
			local ok, result = pcall(function()
				return configRemote:InvokeServer("get")
			end)
			if ok and type(result) == "table" then
				savedConfigs = type(result.configs) == "table" and result.configs or {}
				autoloadName = result.autoload
			else
				warn("opus client: не удалось получить конфиги с сервера", result)
			end
		end

		rebuildConfigCards()

		if autoloadName and savedConfigs[autoloadName] then
			applySettings(savedConfigs[autoloadName].data)
		end
	end)
end

--------------------------------------------------------------------
-- Раздел Themes: цветовые темы меню и размытие фона
--------------------------------------------------------------------
local updateMenuBlur -- задаётся ниже, в блоке анимации меню

do
	local THEMES = {
		["Бордовый"] = {
			bgTop = Color3.fromRGB(92, 32, 44), bgBottom = Color3.fromRGB(38, 14, 20),
			panel = Color3.fromRGB(30, 11, 16), card = Color3.fromRGB(80, 30, 40),
			cardHover = Color3.fromRGB(98, 38, 50), inner = Color3.fromRGB(52, 19, 27),
			accent = Color3.fromRGB(250, 90, 106), accentDim = Color3.fromRGB(140, 56, 70),
			off = Color3.fromRGB(104, 76, 82), sub = Color3.fromRGB(226, 204, 209),
			line = Color3.fromRGB(160, 88, 100),
		},
		["Полночь"] = {
			bgTop = Color3.fromRGB(36, 50, 104), bgBottom = Color3.fromRGB(14, 18, 42),
			panel = Color3.fromRGB(12, 16, 36), card = Color3.fromRGB(38, 50, 100),
			cardHover = Color3.fromRGB(48, 62, 120), inner = Color3.fromRGB(22, 28, 58),
			accent = Color3.fromRGB(118, 162, 255), accentDim = Color3.fromRGB(62, 86, 160),
			off = Color3.fromRGB(74, 82, 112), sub = Color3.fromRGB(206, 214, 240),
			line = Color3.fromRGB(88, 110, 184),
		},
		["Аметист"] = {
			bgTop = Color3.fromRGB(80, 38, 116), bgBottom = Color3.fromRGB(30, 15, 46),
			panel = Color3.fromRGB(24, 12, 38), card = Color3.fromRGB(72, 36, 104),
			cardHover = Color3.fromRGB(88, 46, 126), inner = Color3.fromRGB(44, 22, 66),
			accent = Color3.fromRGB(198, 134, 255), accentDim = Color3.fromRGB(110, 70, 160),
			off = Color3.fromRGB(96, 78, 114), sub = Color3.fromRGB(222, 206, 240),
			line = Color3.fromRGB(134, 92, 186),
		},
		["Изумруд"] = {
			bgTop = Color3.fromRGB(26, 88, 72), bgBottom = Color3.fromRGB(10, 32, 27),
			panel = Color3.fromRGB(9, 26, 22), card = Color3.fromRGB(30, 78, 65),
			cardHover = Color3.fromRGB(38, 96, 80), inner = Color3.fromRGB(17, 46, 38),
			accent = Color3.fromRGB(88, 232, 170), accentDim = Color3.fromRGB(44, 128, 96),
			off = Color3.fromRGB(72, 98, 90), sub = Color3.fromRGB(204, 234, 222),
			line = Color3.fromRGB(70, 142, 116),
		},
		["Графит"] = {
			bgTop = Color3.fromRGB(66, 66, 74), bgBottom = Color3.fromRGB(26, 26, 30),
			panel = Color3.fromRGB(20, 20, 24), card = Color3.fromRGB(58, 58, 66),
			cardHover = Color3.fromRGB(72, 72, 82), inner = Color3.fromRGB(36, 36, 42),
			accent = Color3.fromRGB(255, 176, 90), accentDim = Color3.fromRGB(130, 96, 64),
			off = Color3.fromRGB(90, 90, 98), sub = Color3.fromRGB(220, 220, 226),
			line = Color3.fromRGB(118, 118, 130),
		},
		["Неон"] = {
			bgTop = Color3.fromRGB(40, 22, 78), bgBottom = Color3.fromRGB(17, 9, 33),
			panel = Color3.fromRGB(13, 7, 26), card = Color3.fromRGB(35, 19, 68),
			cardHover = Color3.fromRGB(43, 24, 84), inner = Color3.fromRGB(23, 13, 44),
			accent = Color3.fromRGB(255, 70, 200), accentDim = Color3.fromRGB(118, 37, 111),
			off = Color3.fromRGB(83, 76, 102), sub = Color3.fromRGB(238, 216, 235),
			line = Color3.fromRGB(144, 46, 140),
		},
		["Океан"] = {
			bgTop = Color3.fromRGB(18, 64, 92), bgBottom = Color3.fromRGB(8, 27, 39),
			panel = Color3.fromRGB(6, 21, 30), card = Color3.fromRGB(16, 56, 80),
			cardHover = Color3.fromRGB(19, 69, 99), inner = Color3.fromRGB(10, 36, 52),
			accent = Color3.fromRGB(60, 205, 255), accentDim = Color3.fromRGB(31, 107, 139),
			off = Color3.fromRGB(74, 93, 108), sub = Color3.fromRGB(215, 232, 242),
			line = Color3.fromRGB(39, 133, 173),
		},
		["Закат"] = {
			bgTop = Color3.fromRGB(96, 44, 36), bgBottom = Color3.fromRGB(40, 18, 15),
			panel = Color3.fromRGB(32, 15, 12), card = Color3.fromRGB(84, 38, 31),
			cardHover = Color3.fromRGB(104, 48, 39), inner = Color3.fromRGB(55, 25, 21),
			accent = Color3.fromRGB(255, 140, 70), accentDim = Color3.fromRGB(141, 74, 42),
			off = Color3.fromRGB(106, 85, 85), sub = Color3.fromRGB(238, 224, 220),
			line = Color3.fromRGB(176, 91, 54),
		},
		["Сакура"] = {
			bgTop = Color3.fromRGB(92, 46, 72), bgBottom = Color3.fromRGB(39, 19, 30),
			panel = Color3.fromRGB(30, 15, 24), card = Color3.fromRGB(80, 40, 63),
			cardHover = Color3.fromRGB(99, 50, 78), inner = Color3.fromRGB(52, 26, 41),
			accent = Color3.fromRGB(255, 150, 200), accentDim = Color3.fromRGB(139, 78, 109),
			off = Color3.fromRGB(104, 86, 100), sub = Color3.fromRGB(238, 226, 235),
			line = Color3.fromRGB(173, 98, 136),
		},
		["Лава"] = {
			bgTop = Color3.fromRGB(70, 22, 12), bgBottom = Color3.fromRGB(29, 9, 5),
			panel = Color3.fromRGB(23, 7, 4), card = Color3.fromRGB(61, 19, 10),
			cardHover = Color3.fromRGB(76, 24, 13), inner = Color3.fromRGB(40, 13, 7),
			accent = Color3.fromRGB(255, 96, 30), accentDim = Color3.fromRGB(130, 47, 17),
			off = Color3.fromRGB(95, 76, 76), sub = Color3.fromRGB(238, 219, 215),
			line = Color3.fromRGB(161, 58, 21),
		},
		["Лёд"] = {
			bgTop = Color3.fromRGB(44, 70, 92), bgBottom = Color3.fromRGB(18, 29, 39),
			panel = Color3.fromRGB(15, 23, 30), card = Color3.fromRGB(38, 61, 80),
			cardHover = Color3.fromRGB(48, 76, 99), inner = Color3.fromRGB(25, 40, 52),
			accent = Color3.fromRGB(160, 225, 255), accentDim = Color3.fromRGB(82, 118, 139),
			off = Color3.fromRGB(85, 95, 108), sub = Color3.fromRGB(227, 235, 242),
			line = Color3.fromRGB(101, 147, 173),
		},
		["Токсик"] = {
			bgTop = Color3.fromRGB(26, 46, 20), bgBottom = Color3.fromRGB(11, 19, 8),
			panel = Color3.fromRGB(9, 15, 7), card = Color3.fromRGB(23, 40, 17),
			cardHover = Color3.fromRGB(28, 50, 22), inner = Color3.fromRGB(15, 26, 11),
			accent = Color3.fromRGB(150, 255, 60), accentDim = Color3.fromRGB(70, 120, 32),
			off = Color3.fromRGB(78, 86, 79), sub = Color3.fromRGB(226, 238, 218),
			line = Color3.fromRGB(86, 147, 40),
		},
		["Золото"] = {
			bgTop = Color3.fromRGB(58, 46, 22), bgBottom = Color3.fromRGB(24, 19, 9),
			panel = Color3.fromRGB(19, 15, 7), card = Color3.fromRGB(50, 40, 19),
			cardHover = Color3.fromRGB(63, 50, 24), inner = Color3.fromRGB(33, 26, 13),
			accent = Color3.fromRGB(245, 196, 72), accentDim = Color3.fromRGB(122, 97, 38),
			off = Color3.fromRGB(90, 86, 80), sub = Color3.fromRGB(237, 231, 220),
			line = Color3.fromRGB(149, 120, 46),
		},
		["Лаванда"] = {
			bgTop = Color3.fromRGB(66, 54, 100), bgBottom = Color3.fromRGB(28, 23, 42),
			panel = Color3.fromRGB(22, 18, 33), card = Color3.fromRGB(57, 47, 87),
			cardHover = Color3.fromRGB(71, 58, 108), inner = Color3.fromRGB(38, 31, 57),
			accent = Color3.fromRGB(190, 160, 255), accentDim = Color3.fromRGB(102, 86, 142),
			off = Color3.fromRGB(94, 89, 111), sub = Color3.fromRGB(230, 227, 242),
			line = Color3.fromRGB(128, 107, 178),
		},
		["Мята"] = {
			bgTop = Color3.fromRGB(24, 74, 66), bgBottom = Color3.fromRGB(10, 31, 28),
			panel = Color3.fromRGB(8, 24, 22), card = Color3.fromRGB(21, 64, 57),
			cardHover = Color3.fromRGB(26, 80, 71), inner = Color3.fromRGB(14, 42, 38),
			accent = Color3.fromRGB(110, 240, 200), accentDim = Color3.fromRGB(54, 126, 106),
			off = Color3.fromRGB(77, 97, 97), sub = Color3.fromRGB(221, 236, 235),
			line = Color3.fromRGB(66, 156, 132),
		},
		["Кровь"] = {
			bgTop = Color3.fromRGB(60, 8, 12), bgBottom = Color3.fromRGB(25, 3, 5),
			panel = Color3.fromRGB(20, 3, 4), card = Color3.fromRGB(52, 7, 10),
			cardHover = Color3.fromRGB(65, 9, 13), inner = Color3.fromRGB(34, 5, 7),
			accent = Color3.fromRGB(225, 30, 45), accentDim = Color3.fromRGB(114, 15, 22),
			off = Color3.fromRGB(91, 70, 76), sub = Color3.fromRGB(235, 211, 217),
			line = Color3.fromRGB(141, 19, 28),
		},
		["Кофе"] = {
			bgTop = Color3.fromRGB(70, 48, 36), bgBottom = Color3.fromRGB(29, 20, 15),
			panel = Color3.fromRGB(23, 16, 12), card = Color3.fromRGB(61, 42, 31),
			cardHover = Color3.fromRGB(76, 52, 39), inner = Color3.fromRGB(40, 27, 21),
			accent = Color3.fromRGB(225, 170, 120), accentDim = Color3.fromRGB(118, 87, 62),
			off = Color3.fromRGB(95, 86, 85), sub = Color3.fromRGB(235, 228, 226),
			line = Color3.fromRGB(147, 108, 78),
		},
	}
	-- нейтральное стекло без оттенка: серо-белые тона, серебристый акцент
	THEMES["Прозрачный"] = {
		bgTop = Color3.fromRGB(175, 175, 180), bgBottom = Color3.fromRGB(125, 125, 130),
		panel = Color3.fromRGB(95, 95, 100), card = Color3.fromRGB(155, 155, 160),
		cardHover = Color3.fromRGB(180, 180, 186), inner = Color3.fromRGB(115, 115, 120),
		accent = Color3.fromRGB(190, 190, 197), accentDim = Color3.fromRGB(120, 120, 126),
		off = Color3.fromRGB(78, 78, 84), sub = Color3.fromRGB(232, 232, 236),
		line = Color3.fromRGB(236, 236, 240),
	}
	local THEME_ORDER = { "Прозрачный", "Бордовый", "Полночь", "Аметист", "Изумруд", "Графит", "Неон", "Океан", "Закат", "Сакура", "Лава", "Лёд", "Токсик", "Золото", "Лаванда", "Мята", "Кровь", "Кофе" }
	local THEME_KEYS = { "bgTop", "bgBottom", "panel", "card", "cardHover", "inner", "accent", "accentDim", "off", "sub", "line" }
	local appliedTheme = "Бордовый"
	local themeCards = {}

	local function colorKey(color)
		return string.format("%d,%d,%d",
			math.floor(color.R * 255 + 0.5), math.floor(color.G * 255 + 0.5), math.floor(color.B * 255 + 0.5))
	end

	local function recolor(root, map)
		for _, obj in ipairs(root:GetDescendants()) do
			if obj:IsA("GuiObject") and obj:GetAttribute("KeepColor") then
				continue
			end
			if obj:IsA("GuiObject") then
				local background = map[colorKey(obj.BackgroundColor3)]
				if background then
					obj.BackgroundColor3 = background
				end
				if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
					local textColor = map[colorKey(obj.TextColor3)]
					if textColor then
						obj.TextColor3 = textColor
					end
					if obj:IsA("TextBox") then
						local placeholder = map[colorKey(obj.PlaceholderColor3)]
						if placeholder then
							obj.PlaceholderColor3 = placeholder
						end
					end
				end
				if obj:IsA("ScrollingFrame") then
					local bar = map[colorKey(obj.ScrollBarImageColor3)]
					if bar then
						obj.ScrollBarImageColor3 = bar
					end
				end
			elseif obj:IsA("UIStroke") then
				local strokeColor = map[colorKey(obj.Color)]
				if strokeColor then
					obj.Color = strokeColor
				end
			elseif obj:IsA("UIGradient") then
				local changed, keypoints = false, {}
				for _, keypoint in ipairs(obj.Color.Keypoints) do
					local mapped = map[colorKey(keypoint.Value)]
					changed = changed or mapped ~= nil
					table.insert(keypoints, ColorSequenceKeypoint.new(keypoint.Time, mapped or keypoint.Value))
				end
				if changed then
					obj.Color = ColorSequence.new(keypoints)
				end
			end
		end
	end

	local function refreshThemeCards()
		for name, entry in pairs(themeCards) do
			local active = name == appliedTheme
			entry.stroke.Color = active and C.accent or C.line
			entry.stroke.Transparency = active and 0.2 or 0.65
			entry.badge.Visible = active
			entry.badge.TextColor3 = C.accent
		end
	end

	-- Тема «Прозрачный»: все подложки (окно, панель, карточки, поля, кнопки) становятся почти
	-- невидимым стеклом; обводки и текст остаются чёткими, у текста появляется тонкая тень для читаемости.
	local CLEAR_THEME = "Прозрачный"
	local clearLevels = nil      -- [цвет] = прозрачность для подложек этого цвета
	local clearConnection = nil

	local function clearObject(obj)
		if obj:GetAttribute("KeepColor") then
			return
		end
		if obj:IsA("GuiObject") then
			local level = clearLevels[colorKey(obj.BackgroundColor3)]
			if level and obj.BackgroundTransparency < 1 and obj:GetAttribute("OpusClearBg") == nil then
				obj:SetAttribute("OpusClearBg", obj.BackgroundTransparency)
				obj.BackgroundTransparency = math.max(obj.BackgroundTransparency, level)
			end
			if (obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox"))
				and obj:GetAttribute("OpusClearText") == nil then
				obj:SetAttribute("OpusClearText", obj.TextStrokeTransparency)
				obj.TextStrokeTransparency = math.min(obj.TextStrokeTransparency, 0.7)
			end
		elseif obj:IsA("UIStroke") and obj:GetAttribute("OpusClearStroke") == nil and obj.Transparency < 1 then
			-- обводки делаем заметнее — на стекле именно они держат форму
			obj:SetAttribute("OpusClearStroke", obj.Transparency)
			obj.Transparency = obj.Transparency * 0.55
		end
	end

	local function restoreObject(obj)
		local bg = obj:GetAttribute("OpusClearBg")
		if bg ~= nil then
			obj.BackgroundTransparency = bg
			obj:SetAttribute("OpusClearBg", nil)
		end
		local text = obj:GetAttribute("OpusClearText")
		if text ~= nil then
			obj.TextStrokeTransparency = text
			obj:SetAttribute("OpusClearText", nil)
		end
		local stroke = obj:GetAttribute("OpusClearStroke")
		if stroke ~= nil then
			obj.Transparency = stroke
			obj:SetAttribute("OpusClearStroke", nil)
		end
	end

	local function setClearMode(on)
		if on then
			local theme = THEMES[CLEAR_THEME]
			clearLevels = {
				[colorKey(theme.bgTop)] = 0.9, [colorKey(theme.bgBottom)] = 0.88,
				[colorKey(theme.panel)] = 0.9, [colorKey(theme.card)] = 0.86,
				[colorKey(theme.cardHover)] = 0.82, [colorKey(theme.inner)] = 0.85,
				[colorKey(theme.off)] = 0.65, [colorKey(theme.accentDim)] = 0.55,
			}
			for _, obj in ipairs(screenGui:GetDescendants()) do
				clearObject(obj)
			end
			if not clearConnection then
				-- новые элементы (карточки конфигов, страницы, бейджи) тоже сразу стеклянные
				clearConnection = screenGui.DescendantAdded:Connect(function(obj)
					task.defer(function()
						if obj.Parent and clearLevels then
							clearObject(obj)
						end
					end)
				end)
			end
		else
			if clearConnection then
				clearConnection:Disconnect()
				clearConnection = nil
			end
			if clearLevels then
				clearLevels = nil
				for _, obj in ipairs(screenGui:GetDescendants()) do
					restoreObject(obj)
				end
			end
		end
	end

	local function applyTheme(name)
		local theme = THEMES[name]
		if not theme then
			return
		end
		if name ~= appliedTheme then
			local map = {}
			for _, key in ipairs(THEME_KEYS) do
				map[colorKey(C[key])] = theme[key]
			end
			recolor(screenGui, map)
			local watermark = playerGui:FindFirstChild("JustVisuals_Watermark")
			if watermark then
				recolor(watermark, map)
			end
			for _, key in ipairs(THEME_KEYS) do
				C[key] = theme[key]
			end
			appliedTheme = name
		end
		MENU_STYLE.Theme = name
		setClearMode(name == CLEAR_THEME)
		for _, refresh in ipairs(uiRefreshers) do
			refresh()
		end
		refreshThemeCards()
		if currentSection and not currentModule then
			selectSection(currentSection)
		end
	end

	local themesSection = createSection("Themes", "Settings")

	for index, name in ipairs(THEME_ORDER) do
		local theme = THEMES[name]
		local card = new("TextButton", {
			LayoutOrder = index,
			BackgroundColor3 = C.card,
			BackgroundTransparency = 0.15,
			BorderSizePixel = 0,
			AutoButtonColor = false,
			Text = "",
			Parent = themesSection.grid,
		})
		round(card, 8)
		local stroke = outline(card, C.line, 0.65)

		new("TextLabel", {
			Position = UDim2.fromOffset(12, 8),
			Size = UDim2.new(1, -80, 0, 20),
			BackgroundTransparency = 1,
			Font = Enum.Font.GothamBold,
			TextSize = 13,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextColor3 = C.text,
			Text = name,
			Parent = card,
		})

		local badge = new("TextLabel", {
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.new(1, -10, 0, 8),
			Size = UDim2.fromOffset(70, 20),
			BackgroundTransparency = 1,
			Font = Enum.Font.GothamBold,
			TextSize = 11,
			TextXAlignment = Enum.TextXAlignment.Right,
			TextColor3 = C.accent,
			Text = "активна",
			Visible = false,
			Parent = card,
		})

		-- образцы цветов темы
		for i, key in ipairs({ "bgTop", "card", "accentDim", "accent" }) do
			local swatch = new("Frame", {
				Position = UDim2.fromOffset(12 + (i - 1) * 24, 36),
				Size = UDim2.fromOffset(18, 18),
				BackgroundColor3 = theme[key],
				BorderSizePixel = 0,
				Parent = card,
			})
			round(swatch, 9)
			new("UIStroke", { Color = Color3.fromRGB(255, 255, 255), Transparency = 0.8, Parent = swatch })
			-- образцы не должны перекрашиваться при смене темы
			swatch:SetAttribute("KeepColor", true)
		end

		card.MouseButton1Click:Connect(function()
			applyTheme(name)
			playToggleSound(true)
		end)
		card.MouseEnter:Connect(function()
			card.BackgroundColor3 = C.cardHover
		end)
		card.MouseLeave:Connect(function()
			card.BackgroundColor3 = C.card
		end)

		themeCards[name] = { stroke = stroke, badge = badge }
		table.insert(themesSection.cards, { frame = card, name = name, desc = "тема" })
	end

	addModule(themesSection, {
		name = "Стекло",
		desc = "Полупрозрачное меню с размытым миром за ним.",
		source = MENU_STYLE,
		key = "Glass",
		settings = function(page)
			numberSetting(page, "Прозрачность стекла", "GlassLevel", 0, 0.8, MENU_STYLE)
		end,
	})

	addModule(themesSection, {
		name = "PNG картинка",
		desc = "Картинка-украшение рядом с меню.",
		source = MENU_STYLE,
		key = "Decor",
		settings = function(page)
			choiceSetting(page, "Где", "DecorPosition", DECOR_POSITIONS, MENU_STYLE)
			choiceSetting(page, "Слой", "DecorLayer", DECOR_LAYERS, MENU_STYLE)
			numberSetting(page, "Размер", "DecorSize", 40, 600, MENU_STYLE)
			numberSetting(page, "Прозрачность", "DecorTransparency", 0, 0.95, MENU_STYLE)
		end,
	})

	addModule(themesSection, {
		name = "Предпросмотр",
		desc = "Окно справа: ваш аватар с включёнными визуалами.",
		source = MENU_STYLE,
		key = "Preview",
	})

	addModule(themesSection, {
		name = "Уведомления",
		desc = "Всплывающие уведомления при включении функций.",
		source = MENU_STYLE,
		key = "Toasts",
	})

	addModule(themesSection, {
		name = "Размытие фона",
		desc = "Мир за открытым меню размывается.",
		source = MENU_STYLE,
		key = "Blur",
		onToggle = function()
			if updateMenuBlur then
				updateMenuBlur()
			end
		end,
	})


	-- Клавиша меню: клик по карточке → нажмите любую клавишу. Esc — отмена.
	do
		local function applyMenuKey()
			local key = Enum.KeyCode[MENU_STYLE.MenuKey]
			if not key or key == Enum.KeyCode.Unknown then
				key = Enum.KeyCode.RightControl
				MENU_STYLE.MenuKey = key.Name
			end
			CONFIG.MenuKey = key
			menuHint.Text = key.Name .. " — меню\nПКМ по карточке — клавиша\ntgk: opus_client_rbx"
			return key
		end

		local card = new("TextButton", {
			LayoutOrder = 1000,
			BackgroundColor3 = C.card,
			BackgroundTransparency = 0.05,
			BorderSizePixel = 0,
			AutoButtonColor = false,
			Text = "",
			Parent = themesSection.grid,
		})
		round(card, 8)
		local stroke = outline(card, C.line, 0.65)
		local icon = new("Frame", {
			Position = UDim2.fromOffset(10, 8),
			Size = UDim2.fromOffset(22, 22),
			BackgroundColor3 = C.accent,
			BorderSizePixel = 0,
			Parent = card,
		})
		round(icon, 6)
		drawIcon(icon, "square", 12)(C.text)
		new("TextLabel", {
			Position = UDim2.fromOffset(40, 8),
			Size = UDim2.new(1, -50, 0, 22),
			BackgroundTransparency = 1,
			Font = Enum.Font.GothamBold,
			TextSize = 14,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextColor3 = C.text,
			Text = "Клавиша меню",
			Parent = card,
		})
		local desc = new("TextLabel", {
			Position = UDim2.fromOffset(12, 32),
			Size = UDim2.new(1, -24, 0, 28),
			BackgroundTransparency = 1,
			Font = Enum.Font.Gotham,
			TextSize = 12,
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
			TextColor3 = C.sub,
			Text = "",
			Parent = card,
		})

		local capturing = false
		local function refresh()
			local key = applyMenuKey()
			if not capturing then
				desc.Text = "Сейчас: " .. key.Name .. ". Нажмите, чтобы сменить."
				desc.TextColor3 = C.sub
			end
		end

		card.MouseButton1Click:Connect(function()
			capturing = true
			desc.Text = "Нажмите новую клавишу… (Esc — отмена)"
			desc.TextColor3 = C.accent
			stroke.Color = C.accent
			stroke.Transparency = 0.3
		end)

		UserInputService.InputBegan:Connect(function(input)
			if not capturing or input.UserInputType ~= Enum.UserInputType.Keyboard then
				return
			end
			capturing = false
			stroke.Color = C.line
			stroke.Transparency = 0.65
			local key = input.KeyCode
			if key ~= Enum.KeyCode.Escape and key ~= Enum.KeyCode.Unknown then
				-- новую клавишу применяем в следующем кадре, чтобы это же нажатие сразу не закрыло меню
				task.defer(function()
					-- если эта клавиша была назначена какой-то функции — снимаем, чтобы не конфликтовали
					for name, bound in pairs(KEYBINDS) do
						if bound == key.Name then
							KEYBINDS[name] = nil
						end
					end
					MENU_STYLE.MenuKey = key.Name
					for _, refresher in ipairs(uiRefreshers) do
						refresher()
					end
					playToggleSound(true)
					showToast("Клавиша меню: " .. key.Name, true)
				end)
			else
				refresh()
			end
		end)

		refresh()
		table.insert(uiRefreshers, refresh) -- после загрузки конфига — клавиша из конфига
		table.insert(themesSection.cards, { frame = card, name = "Клавиша меню", desc = "открытие закрытие меню" })
	end

	refreshThemeCards()

	-- после загрузки конфига применяем сохранённую в нём тему и размытие
	table.insert(uiRefreshers, function()
		if MENU_STYLE.Theme ~= appliedTheme and THEMES[MENU_STYLE.Theme] then
			applyTheme(MENU_STYLE.Theme)
		end
		if updateMenuBlur then
			updateMenuBlur()
		end
	end)
end

selectSection("Visuals")

--------------------------------------------------------------------
-- Анимация появления и скрытия меню
--------------------------------------------------------------------

local windowScale = new("UIScale", { Scale = 1, Parent = frame })

-- Мягкое свечение цветом темы вокруг окна (как красный ореол в примере).
-- Отдельный слой под меню, ровно по центру окна — не смещается и не лежит поверх содержимого.
do
	local glowGui = new("ScreenGui", {
		Name = "OpusClient_MenuGlow",
		ResetOnSpawn = false,
		DisplayOrder = screenGui.DisplayOrder - 1,
		Enabled = false,
		Parent = playerGui,
	})
	local layers = {}
	for _, spec in ipairs({ { 2, 2, 0.55 }, { 8, 4, 0.82 }, { 18, 6, 0.92 } }) do
		local glow = new("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Parent = glowGui,
		})
		round(glow, 12 + spec[1] / 2)
		local stroke = new("UIStroke", { Thickness = spec[2], Parent = glow })
		table.insert(layers, {
			frame = glow,
			stroke = stroke,
			scale = new("UIScale", { Parent = glow }),
			grow = spec[1],
			transparency = spec[3],
		})
	end

	-- светлая «стеклянная» кромка по краю окна
	local glassEdge = new("UIStroke", {
		Color = Color3.fromRGB(255, 255, 255),
		Transparency = 0.82,
		Thickness = 1,
		Parent = windowBackground,
	})

	-- применяет прозрачность стекла ко всем слоям меню
	local appliedGlass = nil
	local function applyGlass()
		local level = MENU_STYLE.Glass and math.clamp(MENU_STYLE.GlassLevel, 0, 0.8) or 0
		-- в ключ входит и число карточек: новые карточки конфигов тоже станут стеклянными
		local cardCount = 0
		for _, section in pairs(sections) do
			cardCount += #section.cards
		end
		local clear = MENU_STYLE.Theme == "Прозрачный"
		local key = tostring(MENU_STYLE.Glass) .. level .. "/" .. cardCount .. "/" .. tostring(clear)
		if key == appliedGlass then
			return
		end
		appliedGlass = key

		windowBackground.BackgroundTransparency = clear and 0.9 or (0.04 + level * 0.75)
		sidebar.BackgroundTransparency = clear and 0.92 or math.min(0.45 + level * 0.5, 0.92)
		glassEdge.Transparency = clear and 0.25 or (MENU_STYLE.Glass and 0.7 or 0.9)

		local cardTransparency = clear and 0.86 or (0.05 + level * 0.55)
		for _, section in pairs(sections) do
			for _, entry in ipairs(section.cards) do
				if entry.frame.Parent then
					entry.frame.BackgroundTransparency = cardTransparency
				end
			end
		end
		for _, row in ipairs(glassRows) do
			row.BackgroundTransparency = clear and 0.88 or (0.2 + level * 0.45)
		end
		if updateMenuBlur then
			updateMenuBlur()
		end
	end
	table.insert(uiRefreshers, function()
		appliedGlass = nil -- после смены темы или загрузки конфига применить заново
		applyGlass()
	end)
	applyGlass()

	RunService.RenderStepped:Connect(function()
		glowGui.Enabled = screenGui.Enabled and frame.Visible
		if not glowGui.Enabled then
			return
		end
		applyGlass() -- срабатывает только если настройку стекла меняли
		for _, layer in ipairs(layers) do
			layer.frame.Position = frame.Position
			layer.frame.Size = frame.Size + UDim2.fromOffset(layer.grow, layer.grow)
			layer.scale.Scale = windowScale.Scale
			layer.stroke.Color = C.accent
			layer.stroke.Transparency = layer.transparency
		end
	end)
end

-- Размытие мира за открытым меню
local menuBlur = new("BlurEffect", { Name = "JustVisualsMenuBlur", Size = 0, Parent = game:GetService("Lighting") })
local menuIsOpen = false

updateMenuBlur = function()
	local glass = MENU_STYLE.Glass and math.clamp(MENU_STYLE.GlassLevel, 0, 0.8) or 0
	local target = (menuIsOpen and MENU_STYLE.Blur) and (10 + glass * 18) or 0
	TweenService:Create(menuBlur, TweenInfo.new(0.3, Enum.EasingStyle.Quad), { Size = target }):Play()
end

local menuOpen = false
local animationId = 0 -- чтобы быстрое повторное нажатие не ломало анимацию

-- Масштаб, при котором окно целиком помещается на экран с отступами
local WINDOW_SIZE = Vector2.new(600, 400)
local SCREEN_MARGIN = 24

-- окно предпросмотра справа от меню (ширина + отступ); учитывается при подгонке под экран
local PREVIEW_WIDTH = 210
local PREVIEW_GAP = 12

local function previewExtra()
	return MENU_STYLE.Preview and (PREVIEW_WIDTH + PREVIEW_GAP) or 0
end

local function getFitScale()
	local available = screenGui.AbsoluteSize
	if available.X < 1 or available.Y < 1 then
		return 1
	end
	local scale = math.min(
		(available.X - SCREEN_MARGIN * 2) / (WINDOW_SIZE.X + previewExtra()),
		(available.Y - SCREEN_MARGIN * 2) / WINDOW_SIZE.Y
	)
	return math.clamp(scale, 0.45, 1)
end

-- Не даёт окну (вместе с панелью предпросмотра) уехать за край экрана
local function clampWindow()
	local available = screenGui.AbsoluteSize
	local scale = getFitScale()
	local half = WINDOW_SIZE * scale / 2
	local extra = previewExtra() * scale
	local minX = math.min(0, -(available.X / 2 - half.X - SCREEN_MARGIN))
	local maxX = available.X / 2 - half.X - extra - SCREEN_MARGIN
	if maxX < minX then
		maxX = minX
	end
	local maxY = math.max(0, available.Y / 2 - half.Y - SCREEN_MARGIN)
	frame.Position = UDim2.new(
		0.5, math.clamp(frame.Position.X.Offset, minX, maxX),
		0.5, math.clamp(frame.Position.Y.Offset, -maxY, maxY)
	)
end

screenGui:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
	if menuOpen then
		windowScale.Scale = getFitScale()
		clampWindow()
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if menuOpen and (input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch) then
		clampWindow()
	end
end)

--------------------------------------------------------------------
-- Анимация «разбитого стекла», как в примере:
-- закрытие — по окну расходятся трещины (светятся цветом темы), затем осколки с настоящим
-- содержимым меню разлетаются, улетают вглубь (уменьшаются), крутятся и гаснут;
-- открытие — то же самое задом наперёд: осколки прилетают издалека и собираются в окно.
--------------------------------------------------------------------

--------------------------------------------------------------------
-- Предпросмотр: окно справа от меню с вашим аватаром. На нём видны включённые визуалы —
-- шляпа, крылья/рюкзак на спине, ауры, питомец рядом. Аватар медленно вращается,
-- его можно крутить мышью. Частицы, следы и подсветка в таком окне Roblox не рисуются.
--------------------------------------------------------------------
do
	local EFFECT_FOLDERS = { "BackAccessory_Local", "Aura_Local", "CustomPet_Local", "Bulba_Local", "Bottom_Local" }
	local KEEP_CHILDREN = {
		SpecialMesh = true, BlockMesh = true, CylinderMesh = true,
		Decal = true, Texture = true, SurfaceAppearance = true,
	}

	-- фон панели устроен так же, как фон окна: белый слой с градиентом темы,
	-- прозрачность каждый кадр берётся с окна — поэтому «Стекло» и тема «Прозрачный» действуют и здесь
	local panel = new("Frame", {
		Name = "Preview",
		AnchorPoint = Vector2.new(0, 0.5),
		Size = UDim2.fromOffset(PREVIEW_WIDTH, WINDOW_SIZE.Y),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = windowBackground.BackgroundTransparency,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Visible = false,
		Parent = screenGui,
	})
	round(panel, 12)
	outline(panel, C.line, 0.35)
	new("UIGradient", { Rotation = 55, Color = ColorSequence.new(C.bgTop, C.bgBottom), Parent = panel })
	-- светлая стеклянная кромка и блик сверху, как у окна меню
	local panelEdge = new("Frame", {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		Parent = panel,
	})
	round(panelEdge, 12)
	local panelEdgeStroke = new("UIStroke", {
		Color = Color3.fromRGB(255, 255, 255),
		Transparency = 0.82,
		Thickness = 1,
		Parent = panelEdge,
	})
	panelEdgeStroke:SetAttribute("KeepColor", true)
	local panelSheen = new("Frame", {
		Size = UDim2.new(1, 0, 0.45, 0),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 0.94,
		BorderSizePixel = 0,
		Parent = panel,
	})
	round(panelSheen, 12)
	new("UIGradient", { Rotation = 90, Transparency = NumberSequence.new(0, 1), Parent = panelSheen })
	local panelScale = new("UIScale", { Parent = panel })

	new("TextLabel", {
		Position = UDim2.fromOffset(14, 10),
		Size = UDim2.new(1, -28, 0, 20),
		BackgroundTransparency = 1,
		Font = Enum.Font.GothamBold,
		TextSize = 14,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextColor3 = C.text,
		Text = "Предпросмотр",
		Parent = panel,
	})
	local subtitle = new("TextLabel", {
		Position = UDim2.fromOffset(14, 30),
		Size = UDim2.new(1, -28, 0, 16),
		BackgroundTransparency = 1,
		Font = Enum.Font.Gotham,
		TextSize = 11,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextColor3 = C.sub,
		Text = "",
		Parent = panel,
	})

	local viewport = new("ViewportFrame", {
		Position = UDim2.fromOffset(8, 54),
		Size = UDim2.new(1, -16, 1, -88),
		BackgroundColor3 = C.inner,
		BackgroundTransparency = 0.4,
		BorderSizePixel = 0,
		Ambient = Color3.fromRGB(150, 150, 160),
		LightColor = Color3.fromRGB(235, 235, 240),
		LightDirection = Vector3.new(-0.4, -1, -0.6),
		Parent = panel,
	})
	round(viewport, 10)
	local viewCamera = Instance.new("Camera")
	viewCamera.FieldOfView = 38
	viewCamera.Parent = viewport
	viewport.CurrentCamera = viewCamera

	new("TextLabel", {
		Position = UDim2.new(0, 14, 1, -30),
		Size = UDim2.new(1, -28, 0, 20),
		BackgroundTransparency = 1,
		Font = Enum.Font.Gotham,
		TextSize = 11,
		TextColor3 = C.sub,
		Text = "Тяните мышью, чтобы повернуть",
		Parent = panel,
	})

	-- поворот персонажа в окне: только вручную, мышью (или пальцем); стартовый вид — спереди, чуть сбоку
	local yaw = math.rad(200)
	local dragging = false
	local lastX = 0
	local lastDrag = 0
	viewport.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			lastX = input.Position.X
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			yaw -= (input.Position.X - lastX) * 0.012
			lastX = input.Position.X
			lastDrag = os.clock()
		end
	end)
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)

	-- копия персонажа (с одеждой и аксессуарами) и копии деталей эффектов
	local characterCopy = nil
	local characterPairs = {} -- { source, copy }
	local characterSignature = nil
	local copiedCharacter = nil
	local effectCopies = {}   -- [деталь эффекта] = её копия
	local lastScan = 0

	local function stripCopy(copy)
		for _, child in ipairs(copy:GetChildren()) do
			if not KEEP_CHILDREN[child.ClassName] then
				child:Destroy()
			end
		end
		copy.Anchored = true
		copy.CastShadow = false
	end

	local function rebuildCharacter(character)
		if characterCopy then
			characterCopy:Destroy()
			characterCopy = nil
		end
		table.clear(characterPairs)
		if not character then
			return
		end

		-- Каждой детали персонажа заранее даём номер-метку: метки копируются вместе с деталями,
		-- и по ним копия точно находит свой оригинал. Раньше детали сопоставлялись «по порядку»,
		-- а Clone пропускает часть объектов (с Archivable = false) — порядок сбивался, и в окне
		-- оказывалась лишь часть тела, а остальные детали стояли не на своих местах.
		local sourcesById = {}
		local nextId = 0
		for _, object in ipairs(character:GetDescendants()) do
			if object:IsA("BasePart") then
				nextId += 1
				object:SetAttribute("OpusPreviewId", nextId)
				sourcesById[nextId] = object
			end
		end

		-- Clone копирует только объекты с Archivable = true: временно включаем его у всего персонажа
		local restore = {}
		local function allowCopy(object)
			if not object.Archivable then
				object.Archivable = true
				table.insert(restore, object)
			end
		end
		allowCopy(character)
		for _, object in ipairs(character:GetDescendants()) do
			allowCopy(object)
		end
		local ok, copy = pcall(character.Clone, character)
		for _, object in ipairs(restore) do
			if object.Parent or object == character then
				object.Archivable = false
			end
		end
		if not ok or not copy then
			return
		end

		-- скрипты, звуки, эффекты и физика в копии не нужны
		for _, object in ipairs(copy:GetDescendants()) do
			if object:IsA("BaseScript") or object:IsA("Sound") or object:IsA("ParticleEmitter")
				or object:IsA("Trail") or object:IsA("Beam") or object:IsA("Highlight") or object:IsA("Light")
				or object:IsA("JointInstance") or object:IsA("WeldConstraint") or object:IsA("Motor6D") then
				object:Destroy()
			elseif object:IsA("BasePart") then
				object.Anchored = true
				object.CastShadow = false
				local source = sourcesById[object:GetAttribute("OpusPreviewId")]
				if source then
					table.insert(characterPairs, { source = source, copy = object })
				else
					object:Destroy()
				end
			end
		end
		local humanoid = copy:FindFirstChildOfClass("Humanoid")
		if humanoid then
			humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
		end
		copy.Parent = viewport
		characterCopy = copy
	end

	local function partCount(character)
		local count = 0
		for _, object in ipairs(character:GetDescendants()) do
			if object:IsA("BasePart") then
				count += 1
			end
		end
		return count
	end

	local function scan(character, root)
		-- персонаж поменялся (респавн, шляпа, одежда) — пересобираем копию
		local signature = character and partCount(character) or nil
		if character ~= copiedCharacter or signature ~= characterSignature then
			copiedCharacter = character
			characterSignature = signature
			rebuildCharacter(character)
		end

		-- детали эффектов рядом с персонажем
		local keep = {}
		for _, folderName in ipairs(EFFECT_FOLDERS) do
			for _, folder in ipairs(workspace:GetChildren()) do
				if folder.Name ~= folderName or not root then
					continue
				end
				for _, part in ipairs(folder:GetDescendants()) do
					if part:IsA("BasePart") and (part.Position - root.Position).Magnitude < 12 then
						keep[part] = true
						if not effectCopies[part] then
							local ok, copy = pcall(part.Clone, part)
							if ok and copy then
								stripCopy(copy)
								copy.Parent = viewport
								effectCopies[part] = copy
							end
						end
					end
				end
			end
		end
		for part, copy in pairs(effectCopies) do
			if not keep[part] or not part.Parent then
				copy:Destroy()
				effectCopies[part] = nil
			end
		end
	end

	-- какие визуалы сейчас видны на аватаре — короткая подпись под заголовком
	local function activeVisuals()
		local names = {}
		for _, item in ipairs({ { HAT, "Hat" }, { BACK, "Back" }, { AURA, "Aura" }, { PET, "Pet" } }) do
			if item[1].Enabled then
				table.insert(names, item[2])
			end
		end
		return #names > 0 and table.concat(names, " · ") or "визуалы не включены"
	end

	RunService.RenderStepped:Connect(function(dt)
		local visible = MENU_STYLE.Preview and screenGui.Enabled and frame.Visible
		panel.Visible = visible
		if not visible then
			return
		end

		-- прозрачность — как у окна меню (стекло, тема «Прозрачный»)
		local glass = windowBackground.BackgroundTransparency
		panel.BackgroundTransparency = glass
		viewport.BackgroundTransparency = math.clamp(glass + 0.35, 0.4, 0.97)
		panelEdgeStroke.Transparency = glass > 0.5 and 0.4 or 0.82

		-- панель «прилипает» к правому краю окна и масштабируется вместе с ним
		local scale = windowScale.Scale
		panelScale.Scale = scale
		panel.Position = frame.Position + UDim2.fromOffset((WINDOW_SIZE.X / 2 + PREVIEW_GAP) * scale, 0)

		local character = localPlayer.Character
		local root = character and character:FindFirstChild("HumanoidRootPart")
		local now = os.clock()
		if now - lastScan > 0.5 then
			lastScan = now
			scan(character, root)
			subtitle.Text = activeVisuals()
		end
		if not root then
			return
		end

		-- всё ставим относительно персонажа (по горизонтальному повороту), чтобы он стоял ровно в центре
		local look = root.CFrame.LookVector
		local reference = CFrame.new(root.Position) * CFrame.Angles(0, math.atan2(-look.X, -look.Z), 0)
		for _, pair in ipairs(characterPairs) do
			local source, copy = pair.source, pair.copy
			if source.Parent then
				copy.CFrame = reference:ToObjectSpace(source.CFrame)
				-- цвет и материал копируем каждый кадр: шляпа и другие детали на персонаже
				-- меняют их на лету (палитра, радуга, Glow), и копия должна сразу это показывать
				copy.Transparency = source.Transparency
				copy.Color = source.Color
				copy.Material = source.Material
				copy.Reflectance = source.Reflectance
			end
		end
		for part, copy in pairs(effectCopies) do
			if part.Parent then
				copy.CFrame = reference:ToObjectSpace(part.CFrame)
				copy.Transparency = part.Transparency
				copy.Color = part.Color
				copy.Material = part.Material
				copy.Reflectance = part.Reflectance
			end
		end

		-- сам по себе персонаж не вращается: поворот меняется только когда вы тянете его мышью
		viewCamera.CFrame = CFrame.Angles(0, yaw, 0) * CFrame.new(0, 0.6, 11.5)
		viewCamera.CFrame = CFrame.lookAt(viewCamera.CFrame.Position, Vector3.new(0, 0.4, 0))
	end)
end

--------------------------------------------------------------------
-- «PNG картинка»: картинка-украшение, которая «сидит» на окне меню или стоит рядом с ним.
-- Никаких ID и загрузок: картинка нарисована в самом интерфейсе полосками с плавными градиентами.
-- Полоски создаются один раз, когда карточку впервые включают.
--------------------------------------------------------------------
do
	-- Картинка нарисована прямо в коде, без загрузки в Roblox. Девочка уменьшена до 181×220 точек;
	-- каждая строка — одна или несколько полосок с плавным градиентом (до 20 опорных цветов на полоску),
	-- поэтому картинка гладкая, а не «пиксельная». Формат: x, y, длина, число опорных цветов,
	-- затем для каждого опорного цвета: номер точки в полоске, R, G, B.
	local DECOR_W, DECOR_H = 181, 220
	local DECOR_ROWS = [[
60,0,24,2,0,0,0,0,23,2,0,2,57,1,33,2,0,1,1,1,32,0,0,0,52,2,40,2,0,0,0,0,39,2,1,2,49,3,46,2,0,1,10,12,45,0,0,0,48,4,48,2,0,4,1,2,47,2,5,6,46,5,52,2,0,1,1,1,51,1,1,1,44,6,56,2,0,3,1,3,55,2,1,2,42,7,60,
2,0,3,1,3,59,2,0,2,40,8,63,2,0,1,1,3,62,3,1,3,39,9,65,2,0,1,0,2,64,2,1,2,37,10,69,2,0,1,0,3,68,0,0,0,35,11,72,2,0,0,11,11,71,1,1,1,34,12,74,3,0,0,9,9,31,15,15,15,73,0,0,1,33,13,76,3,0,3,1,3,22,15,15,
15,75,1,0,1,31,14,80,3,0,2,2,2,77,3,0,1,79,0,26,26,30,15,81,2,0,1,0,1,80,0,12,12,29,16,82,2,0,1,1,1,81,2,0,1,28,17,84,3,0,1,1,1,54,15,15,15,83,2,0,2,26,18,86,3,0,0,0,0,45,18,18,18,85,2,1,2,25,19,88,4,
0,0,29,29,1,2,1,2,47,19,19,19,87,1,1,1,25,20,89,3,0,2,6,8,58,19,19,19,88,1,1,1,24,21,90,3,0,2,1,2,48,22,22,22,89,2,1,3,23,22,92,3,0,2,1,2,50,24,24,24,91,1,0,1,22,23,93,3,0,2,0,1,52,22,22,22,92,2,1,2,
21,24,94,4,0,0,20,20,1,2,0,1,54,22,22,22,93,3,2,3,20,25,96,3,0,0,0,1,57,22,22,22,95,1,1,1,19,26,97,3,0,0,3,3,58,24,24,24,96,2,2,2,19,27,98,3,0,2,7,7,59,23,23,23,97,1,1,2,19,28,98,3,0,2,5,6,60,22,22,
22,97,2,1,3,18,29,100,3,0,1,5,7,50,23,23,23,99,1,1,2,18,30,100,3,0,2,2,2,63,20,20,20,99,3,2,3,17,31,102,3,0,2,2,2,50,19,19,19,101,1,1,1,16,32,103,3,0,2,1,2,51,21,21,21,102,1,1,1,15,33,104,3,0,0,0,2,
52,19,19,19,103,2,2,2,15,34,105,3,0,1,1,1,53,20,20,20,104,1,0,1,14,35,106,3,0,1,1,1,51,17,17,17,105,2,1,2,14,36,106,3,0,2,1,2,57,18,18,18,105,3,1,3,13,37,108,3,0,1,1,1,58,18,18,18,107,0,0,1,13,38,108,
3,0,2,1,2,52,16,16,16,107,1,1,2,12,39,109,3,0,0,0,1,86,19,19,19,108,2,1,2,12,40,109,5,0,1,1,1,67,7,5,7,68,22,18,23,69,6,5,7,108,2,1,2,11,41,111,8,0,2,2,2,53,18,18,18,68,3,2,3,69,57,47,57,70,45,37,47,
71,2,0,4,81,16,16,16,110,1,1,1,11,42,111,7,0,1,1,1,68,10,10,10,69,13,8,14,70,86,76,86,72,4,3,4,82,19,19,19,110,1,1,1,11,43,111,8,0,1,1,1,68,11,12,11,69,15,9,16,70,80,70,80,71,80,70,80,72,20,14,22,73,
5,4,5,110,2,2,2,10,44,113,7,0,0,0,0,70,6,5,7,72,87,78,86,73,66,58,67,74,10,3,12,75,7,7,7,112,1,1,3,9,45,114,11,0,0,0,0,20,16,16,16,60,9,3,11,68,20,20,20,71,3,3,3,73,82,73,82,74,83,74,82,75,67,58,67,
76,9,4,11,86,21,21,21,113,1,1,1,8,46,116,9,0,0,0,0,69,20,20,20,73,9,5,10,74,73,64,74,76,83,75,83,77,67,57,67,78,11,5,12,88,21,21,21,115,0,0,0,7,47,118,10,0,0,3,3,62,6,2,7,73,18,19,18,74,6,2,7,75,78,
70,79,78,85,76,84,79,62,53,62,80,7,4,8,88,22,22,22,117,0,0,0,7,48,119,11,0,0,2,2,60,7,7,7,62,37,28,38,63,7,5,6,69,19,19,19,74,3,2,3,76,93,84,93,79,84,75,84,81,1,0,2,91,20,20,20,118,0,1,1,7,49,119,15,
0,0,2,2,23,17,17,17,60,6,6,6,62,62,53,63,63,1,1,2,64,20,20,19,74,8,8,8,75,24,18,26,76,95,86,95,80,81,72,81,81,30,22,32,82,2,0,3,83,17,18,17,90,19,19,19,118,0,2,2,7,50,119,13,0,0,2,2,60,6,5,7,62,58,49,
59,63,0,0,0,64,21,21,21,75,8,5,8,76,71,62,72,77,97,86,97,81,82,73,82,82,29,22,31,83,6,3,7,90,22,22,22,118,0,2,2,7,51,119,14,0,0,2,2,22,16,16,16,59,14,15,14,60,0,0,2,61,76,67,77,62,100,89,100,63,13,8,
14,75,3,1,3,77,97,87,96,82,82,73,82,83,30,22,32,84,9,7,9,93,20,20,20,118,0,2,2,7,52,119,18,0,0,2,2,51,7,7,7,53,52,43,54,54,3,2,3,59,11,11,11,60,17,12,19,61,87,76,88,62,113,101,113,63,19,13,20,64,10,
11,10,75,7,7,7,76,22,15,23,77,92,82,92,79,93,83,93,83,81,71,81,84,12,6,13,85,8,8,9,118,0,2,2,7,53,119,18,0,0,2,2,51,5,4,5,52,56,47,57,54,7,6,7,59,6,4,7,60,32,23,34,61,116,104,115,62,107,96,107,63,29,
21,31,64,9,7,10,67,22,22,22,76,13,10,14,77,79,70,79,78,94,84,94,83,81,73,82,85,5,0,6,87,19,19,19,118,0,2,2,7,54,119,16,0,0,2,2,43,19,19,19,51,5,2,7,52,66,56,67,53,15,9,16,59,10,6,11,61,112,100,111,62,
125,112,125,64,6,4,7,67,21,21,21,76,2,2,3,78,102,91,102,84,85,76,85,86,4,0,6,88,18,18,18,118,0,2,4,7,55,119,20,0,0,2,2,33,18,18,18,50,4,4,4,51,29,24,30,52,97,85,97,53,10,6,11,59,7,0,9,60,94,83,94,62,
138,124,137,64,2,2,3,65,22,23,22,76,9,9,10,79,94,83,94,80,93,83,93,81,43,38,43,83,91,81,91,85,85,76,85,87,7,3,8,90,17,17,17,118,1,2,4,7,56,119,18,0,0,2,2,32,18,18,18,50,0,0,0,51,80,71,80,52,95,84,95,
53,9,6,10,58,6,5,6,60,105,94,105,62,139,124,139,63,89,79,90,64,10,7,11,77,6,3,7,78,75,66,76,81,98,88,98,86,87,78,87,88,0,0,1,91,18,18,18,118,1,2,4,7,57,59,9,0,0,4,4,29,6,6,6,32,22,22,22,49,8,7,9,50,
37,29,39,51,109,98,109,52,100,87,100,53,14,10,15,58,5,1,7,66,57,60,13,0,58,48,58,1,118,106,117,3,132,118,132,4,128,114,128,5,39,31,41,6,9,9,9,18,12,11,12,20,96,86,96,28,76,67,76,29,20,14,22,30,5,3,5,
32,22,21,22,59,0,2,4,7,58,59,9,0,0,4,4,31,23,23,23,48,9,9,9,49,12,6,13,50,105,93,104,51,113,102,113,52,92,80,93,53,11,7,12,58,17,11,18,66,58,60,16,0,99,89,99,2,134,120,134,4,133,118,133,5,34,27,35,6,
10,10,10,13,7,5,7,14,49,40,50,15,13,10,14,18,6,7,6,19,30,23,31,20,98,88,98,29,77,68,77,30,20,12,21,31,4,3,4,33,18,17,18,59,1,2,4,7,59,59,10,0,0,4,4,23,20,20,20,48,10,7,11,49,72,61,72,51,134,120,133,
52,53,43,55,53,0,0,1,54,19,20,19,57,5,4,6,58,63,53,64,66,59,60,14,0,110,99,110,4,130,116,130,5,85,74,85,6,11,8,12,13,9,8,10,14,50,42,51,16,9,9,9,19,14,11,15,20,77,66,76,21,97,86,96,30,78,68,78,31,18,
14,20,32,12,12,12,59,1,4,4,7,60,59,11,0,0,5,5,47,10,8,10,48,38,29,40,49,114,103,114,50,109,97,109,51,142,128,142,52,49,40,51,53,5,5,5,54,19,19,19,57,5,3,6,58,79,69,80,66,60,60,15,0,112,101,112,4,137,
123,137,5,106,94,107,6,9,6,10,12,9,8,9,15,49,39,50,16,5,2,7,19,8,6,8,20,35,27,36,21,94,84,93,26,101,89,100,30,83,74,82,31,63,55,64,32,0,0,2,59,1,4,4,7,61,59,10,0,0,5,5,46,17,18,17,47,3,0,4,48,87,76,
87,51,144,129,143,52,50,42,51,53,9,9,9,56,5,5,5,57,32,25,33,58,107,96,107,66,61,60,18,0,115,103,115,4,137,122,136,5,104,91,104,6,11,8,12,14,18,13,19,15,78,68,78,16,18,13,19,19,9,9,9,20,18,13,20,21,94,
84,95,22,99,86,97,25,55,55,62,29,44,42,46,30,14,15,17,32,24,20,25,33,2,0,3,36,15,15,15,59,1,4,4,7,62,59,10,0,0,5,5,45,20,20,19,46,6,4,9,48,114,106,118,49,111,102,115,51,147,130,144,52,52,43,53,53,10,
10,10,56,5,4,6,58,110,99,110,66,62,30,17,0,119,107,119,5,133,119,132,6,53,44,53,7,7,6,7,14,14,9,15,15,85,75,85,17,6,5,7,20,12,9,12,21,56,46,56,22,51,55,62,23,26,18,21,24,58,20,21,25,48,20,22,26,121,
25,27,27,134,9,8,28,72,3,3,29,60,0,0,96,62,30,6,0,69,14,15,1,70,64,71,2,89,80,90,4,0,0,0,13,16,16,16,29,1,4,4,7,63,59,10,0,0,5,5,46,11,3,4,47,50,36,39,49,55,35,39,51,123,122,136,52,42,36,45,53,14,15,
15,56,5,3,6,57,97,86,98,58,110,99,110,66,63,60,19,0,132,118,132,5,138,124,138,7,7,6,7,14,15,10,17,15,79,70,79,16,80,71,80,17,16,13,17,21,5,5,7,22,95,39,39,23,135,17,17,24,177,25,24,27,177,24,24,28,
103,12,12,30,90,7,7,32,93,87,98,33,97,86,95,34,37,29,37,35,3,3,4,59,1,3,3,7,64,59,12,0,0,5,5,32,19,19,19,38,4,4,4,44,22,19,18,45,0,2,10,46,109,13,17,47,167,15,14,48,151,50,49,49,163,23,22,52,18,4,5,
56,0,0,0,58,119,107,119,66,64,30,16,0,132,118,132,5,137,123,137,6,56,47,57,7,4,3,4,8,19,19,19,14,16,10,17,15,82,73,82,18,9,7,9,21,14,9,13,22,165,32,34,23,180,106,105,24,165,101,101,25,166,26,26,27,
169,23,23,28,93,10,10,29,83,10,10,96,64,30,6,0,82,4,3,1,65,26,28,2,93,87,97,4,82,73,83,5,12,8,14,29,1,1,1,7,65,60,15,0,0,5,5,31,18,18,18,37,4,4,4,43,22,20,19,44,5,9,14,45,52,7,14,46,168,22,22,49,169,
55,56,50,180,105,105,51,165,76,77,52,30,1,6,53,6,10,10,55,2,2,2,57,103,92,103,59,134,120,134,67,65,30,17,0,132,118,132,4,135,120,134,5,110,97,110,6,20,15,21,8,11,11,11,13,12,8,12,14,70,62,71,16,53,46,
53,17,0,0,0,20,9,3,6,21,123,44,47,22,172,137,137,23,167,112,112,24,167,28,28,26,161,21,21,27,90,9,10,29,81,5,4,97,65,30,7,0,30,24,26,1,97,88,99,3,98,88,98,4,68,60,69,5,2,0,3,14,16,16,16,29,0,0,0,7,66,
60,16,0,0,5,5,31,19,19,19,36,1,1,1,43,14,16,18,44,23,3,10,46,177,24,23,48,167,9,9,50,173,137,137,51,132,84,85,52,11,0,6,53,17,19,19,55,4,4,4,56,17,15,17,57,92,83,92,58,131,117,131,59,132,118,132,67,
66,30,16,0,132,118,132,5,121,108,121,6,18,13,19,7,12,13,12,13,5,4,5,14,19,14,20,15,80,71,80,18,9,9,10,20,2,12,12,21,56,14,20,22,184,59,59,23,163,38,38,25,172,23,23,26,105,11,11,27,79,8,8,29,75,3,2,97,
66,30,7,0,62,48,53,1,95,86,97,4,97,86,97,5,33,27,34,6,0,0,1,14,19,19,19,29,0,0,0,7,67,60,14,0,0,5,5,43,9,7,14,44,64,7,10,46,118,15,15,47,173,23,23,49,171,36,36,50,182,69,68,51,130,21,24,52,0,2,11,53,
20,18,18,55,5,4,5,56,17,13,17,58,132,118,132,59,132,118,132,67,67,60,20,0,132,118,132,5,128,115,128,6,45,37,46,7,8,8,8,13,2,1,2,14,47,39,48,15,51,45,50,20,7,11,11,21,32,7,11,22,155,13,14,23,176,24,24,
24,160,22,22,26,83,9,9,28,90,4,3,29,62,20,22,30,86,81,92,33,97,87,97,34,93,83,93,36,9,7,9,59,0,0,0,7,68,60,17,0,0,5,5,29,17,17,17,37,2,2,2,41,20,20,19,42,3,7,10,44,96,10,9,46,81,8,8,48,141,19,19,50,
156,13,13,51,111,13,16,52,2,4,13,53,22,20,20,54,6,7,6,55,13,9,14,56,101,89,101,57,135,121,135,59,132,118,132,67,68,60,19,0,132,118,132,5,140,125,140,7,8,6,8,13,2,2,3,15,87,78,87,16,83,74,83,18,6,3,8,
21,0,10,13,22,101,13,16,23,120,16,16,24,92,12,12,28,63,11,12,30,99,89,100,32,103,91,103,34,5,5,5,35,28,25,28,37,8,3,9,44,17,17,17,59,1,0,1,7,69,60,16,0,0,5,5,31,15,15,15,38,0,0,0,40,19,20,19,41,11,9,
11,42,35,28,39,43,108,79,89,44,72,8,8,45,89,7,7,50,84,11,10,51,61,6,10,52,6,5,13,54,10,10,9,55,17,11,18,56,107,95,107,59,132,118,132,67,69,60,18,0,132,118,132,5,138,124,138,7,5,3,5,13,3,2,3,15,102,92,
102,17,83,75,83,19,5,3,5,21,6,7,9,23,68,1,0,26,79,6,6,27,46,22,24,28,88,86,97,29,101,91,102,33,23,21,23,34,66,59,66,35,78,69,78,36,10,10,10,59,1,1,1,7,70,60,15,0,0,5,5,35,18,18,18,41,3,0,5,42,112,98,
112,43,157,144,160,44,97,86,97,45,35,4,4,47,83,3,2,50,95,10,8,51,64,2,4,52,5,8,12,55,14,7,15,56,115,103,115,57,135,120,135,59,132,118,132,67,70,30,16,0,132,118,132,5,133,119,133,6,106,95,106,7,29,22,
30,8,12,12,12,13,3,3,4,15,100,90,100,18,85,75,84,19,25,19,26,20,4,4,4,22,7,7,10,23,43,36,41,25,40,36,40,27,96,88,99,28,59,51,58,29,53,47,52,97,70,30,8,0,19,17,19,1,27,24,27,3,96,86,96,4,100,89,100,5,
77,68,77,6,10,10,10,7,5,6,5,29,1,1,1,7,71,60,15,0,0,5,5,30,16,16,16,40,0,0,0,41,15,12,15,44,146,130,146,46,112,98,110,47,51,35,39,48,89,36,39,49,97,34,37,50,74,13,13,51,69,24,28,52,4,5,6,54,7,6,8,56,
127,114,127,59,132,118,132,67,71,60,20,0,132,118,132,6,131,117,131,7,38,30,39,8,8,8,8,13,6,6,6,14,38,31,39,15,95,85,95,18,81,73,81,20,7,4,8,22,6,4,6,24,47,44,49,26,61,20,20,27,66,58,65,30,56,50,56,31,
95,85,95,32,99,88,99,35,79,70,79,36,10,10,10,37,5,5,5,59,1,1,1,7,72,60,15,0,0,5,5,39,8,7,8,41,96,85,96,43,38,34,38,45,57,49,55,46,110,84,93,47,130,118,131,49,140,127,142,50,65,62,68,51,34,33,39,52,10,
8,10,53,18,19,18,54,1,1,2,56,140,125,139,59,132,118,132,67,72,60,19,0,132,118,132,6,132,118,132,7,44,36,45,8,6,5,6,14,3,0,4,15,81,71,81,16,96,86,96,19,74,64,74,20,15,11,16,22,7,7,7,23,19,13,21,24,89,
80,91,26,117,63,69,27,74,62,70,34,94,84,94,35,79,70,79,36,10,10,10,37,5,5,5,59,1,1,1,7,73,60,17,0,0,4,4,38,11,11,11,39,15,10,17,40,93,83,94,42,141,126,141,44,80,72,81,45,105,92,102,46,127,65,71,47,95,
80,90,48,136,122,137,50,141,126,140,51,94,81,94,52,2,0,3,53,23,23,22,54,0,0,2,56,139,124,138,59,132,118,132,67,73,60,20,0,132,118,132,6,127,114,127,7,93,82,93,8,11,8,12,14,7,4,8,15,82,72,83,16,94,84,
94,19,83,74,83,21,5,2,6,23,6,2,7,24,81,71,82,26,93,92,103,27,65,55,62,28,0,0,0,31,94,84,94,34,94,84,94,35,79,70,79,36,10,10,10,37,5,5,5,59,1,1,1,7,74,60,12,0,0,5,5,32,16,16,16,38,3,0,5,39,80,70,80,40,
128,115,127,46,133,127,142,50,139,125,139,51,102,88,103,52,1,0,2,54,30,24,31,55,122,109,122,59,132,118,132,67,74,60,19,0,132,118,132,6,136,122,135,7,101,89,102,8,6,3,7,14,9,6,10,15,82,71,82,16,95,85,
95,20,76,67,76,21,20,14,22,23,7,5,7,24,40,32,42,25,98,88,98,29,65,55,62,30,102,92,104,34,94,84,94,35,79,70,79,36,10,9,10,37,6,6,6,59,1,1,1,7,75,60,12,0,0,5,5,33,17,17,17,37,2,1,2,38,40,31,42,39,112,
100,112,40,130,116,130,50,139,125,139,51,100,87,100,52,4,3,5,54,28,21,30,55,131,117,130,59,133,118,132,67,75,60,19,0,133,118,132,6,137,121,136,7,111,98,111,8,25,18,27,9,9,7,8,14,9,6,10,15,82,71,83,16,
95,85,95,20,83,74,82,22,9,6,10,23,8,9,8,24,29,23,30,25,95,84,94,28,96,86,96,34,94,84,94,35,79,70,79,36,10,9,10,37,6,6,6,59,1,1,1,7,76,60,12,0,0,4,4,34,19,19,19,36,5,6,6,37,42,35,43,38,115,103,115,39,
132,119,132,50,139,125,139,51,101,87,100,52,6,4,6,53,9,6,9,55,134,119,133,59,133,118,132,67,76,60,16,0,133,118,132,7,123,109,122,9,3,2,3,14,10,6,11,15,82,71,83,16,96,85,96,21,82,73,82,22,28,21,29,24,
6,4,6,25,71,61,71,26,97,87,97,34,94,84,94,35,79,70,79,36,10,9,10,37,6,6,6,59,1,1,1,7,77,60,12,0,0,4,4,34,16,17,16,35,2,2,3,36,22,16,23,37,108,97,109,39,133,119,133,50,139,124,138,52,6,5,7,53,12,9,13,
54,104,91,104,55,139,124,138,59,133,119,132,67,77,60,18,0,133,119,132,7,137,123,136,8,56,47,57,9,0,0,0,10,17,17,17,14,10,7,11,15,82,71,83,16,96,85,96,21,84,74,84,22,65,56,66,23,8,5,9,24,9,7,9,26,97,
87,97,34,94,84,94,35,79,70,79,36,10,9,10,37,6,6,6,59,1,1,1,7,78,60,10,0,0,2,2,33,22,21,22,35,7,1,8,37,124,111,123,50,139,124,138,52,5,4,6,53,10,5,11,54,99,88,99,55,138,124,137,59,133,119,132,67,78,60,
17,0,133,119,132,7,133,119,132,8,93,82,93,9,17,12,18,10,9,10,9,14,11,9,12,15,82,72,82,16,96,86,96,22,82,72,82,24,5,5,5,25,18,12,19,26,88,76,88,34,94,84,94,35,79,70,79,36,10,9,10,37,6,6,6,59,1,1,1,7,
79,60,10,0,0,2,2,34,6,3,7,36,119,108,119,37,133,119,133,50,139,125,138,52,4,2,6,53,7,2,9,54,115,102,115,55,138,123,136,59,133,119,132,67,79,60,19,0,133,119,132,7,129,115,128,8,111,99,111,9,19,14,20,
10,5,7,5,14,12,9,13,15,83,72,83,16,96,86,96,22,85,76,85,23,64,55,65,24,9,7,10,25,5,3,7,27,101,90,101,34,94,84,94,35,79,70,79,36,10,9,10,37,6,6,6,42,19,19,19,59,1,1,1,7,80,60,11,0,0,2,2,31,17,16,17,33,
0,0,1,34,30,21,31,35,112,101,112,36,126,113,126,50,139,125,138,52,0,0,1,53,49,42,50,54,134,120,134,59,133,119,132,67,80,60,16,0,133,119,132,7,134,120,133,8,121,108,120,9,35,28,36,10,7,7,8,14,7,5,7,15,
39,31,39,16,99,89,99,23,83,74,83,25,1,0,1,27,94,84,94,34,94,84,94,35,80,71,80,36,16,16,16,37,5,5,5,59,1,1,1,7,81,60,9,0,0,2,2,32,1,1,2,33,28,21,29,34,105,94,104,35,129,115,129,50,139,125,138,52,0,0,0,
54,138,124,137,59,133,119,132,67,81,60,18,0,133,119,132,8,126,113,125,9,80,70,81,10,4,2,5,11,16,16,16,14,1,0,1,15,31,24,32,16,99,89,99,23,87,78,87,24,64,55,65,25,8,6,9,26,7,3,8,27,86,76,87,34,95,84,
95,35,81,73,81,36,16,16,16,37,11,11,11,59,1,1,1,7,82,60,11,0,0,2,2,30,18,18,18,31,3,4,3,32,24,18,25,33,99,88,99,34,131,118,131,50,139,125,138,52,0,0,0,53,55,47,56,54,137,123,136,59,133,119,132,67,82,
60,13,0,133,119,132,8,133,119,132,10,0,0,0,11,16,16,15,14,5,5,5,15,34,28,36,16,98,88,98,24,85,75,84,26,0,0,0,28,98,88,98,34,96,84,96,36,9,9,9,59,1,1,1,7,83,60,10,0,0,2,2,31,1,0,3,33,131,119,132,34,
108,94,106,35,129,114,127,41,144,130,144,50,138,124,137,52,0,0,0,54,143,129,142,59,134,119,133,67,83,60,17,0,134,119,133,8,137,122,136,9,103,91,103,10,22,16,24,11,11,11,11,14,9,9,9,15,35,29,37,16,99,
88,98,23,94,84,94,25,72,62,72,26,14,11,14,27,20,16,21,28,92,82,93,34,94,84,94,35,33,29,33,36,7,7,7,59,1,1,1,7,84,60,16,0,0,2,2,30,6,5,8,31,59,49,60,32,54,43,48,33,81,66,75,34,80,65,73,35,126,111,125,
36,141,126,141,40,126,112,124,41,33,24,26,42,107,94,104,43,137,123,136,50,139,125,138,52,1,0,1,54,144,128,142,59,134,119,133,67,84,60,15,0,134,119,133,8,132,117,131,9,120,107,120,10,40,32,41,11,5,5,6,
14,8,8,8,15,36,29,37,16,100,88,99,25,89,80,89,27,0,0,1,29,98,88,98,34,94,84,94,36,7,7,7,40,21,12,12,59,1,1,1,7,85,60,17,0,0,4,4,29,4,3,5,30,34,24,30,31,34,20,22,32,4,0,0,33,25,10,12,34,128,114,127,36,
103,88,97,38,136,122,136,40,128,115,127,41,64,53,59,43,137,123,136,50,140,125,139,52,9,2,11,53,118,104,117,54,137,122,136,59,134,119,133,67,85,30,12,0,134,119,133,8,133,118,132,9,118,106,117,10,37,30,
38,11,4,4,4,14,10,10,10,15,35,28,37,16,100,89,99,26,81,71,81,27,19,13,21,28,16,12,18,29,94,83,94,97,85,30,10,0,93,83,93,3,96,85,96,4,77,68,77,5,20,19,20,6,9,9,9,10,12,7,8,11,50,30,30,12,22,19,19,15,7,
7,7,29,1,1,1,7,86,60,16,0,0,4,4,29,6,3,7,31,36,20,23,32,10,1,1,33,39,25,28,34,128,114,126,35,50,37,40,36,10,2,2,37,45,31,34,38,137,123,136,41,145,131,145,50,140,125,139,52,9,2,11,53,118,105,118,54,
137,122,136,59,134,119,133,67,86,60,16,0,134,119,133,9,128,114,127,10,88,78,89,11,12,9,13,14,10,10,10,15,35,28,36,16,100,89,100,25,93,82,93,27,65,56,65,28,6,4,7,30,100,90,100,33,94,84,94,35,5,6,5,41,
32,17,18,43,12,13,14,59,1,1,1,7,87,60,13,0,0,4,4,29,5,4,5,31,35,24,27,32,7,0,0,33,60,45,50,34,145,130,145,36,94,85,94,38,135,121,135,50,140,125,139,52,10,4,12,53,119,106,118,54,136,122,136,59,134,119,
134,67,87,60,19,0,134,119,134,9,130,115,130,10,96,85,97,11,9,5,10,14,10,10,10,15,35,28,37,16,100,89,100,27,87,77,86,28,34,28,36,29,17,12,18,30,93,83,93,32,93,83,93,33,87,77,87,34,32,28,32,35,7,8,7,40,
18,2,2,42,43,35,36,43,14,11,11,59,1,1,1,7,88,60,9,0,0,5,5,32,14,4,4,34,117,104,116,36,142,127,141,50,140,125,139,52,7,0,9,53,120,106,120,54,137,121,137,59,134,119,134,67,88,60,19,0,134,119,134,9,127,
114,127,10,98,87,98,11,21,13,22,12,13,12,13,14,10,9,10,15,36,28,37,16,100,89,100,27,87,78,87,28,72,63,72,29,3,0,5,31,100,88,99,33,64,57,64,34,11,11,11,38,19,18,18,39,0,5,5,41,80,6,3,42,9,6,6,59,1,0,1,
7,89,60,13,0,0,5,5,32,9,10,10,34,72,59,66,35,50,38,42,36,108,96,106,37,101,87,96,38,25,17,19,39,124,110,122,40,138,123,137,50,141,125,140,52,29,20,30,53,122,110,122,59,134,120,134,67,89,60,15,0,134,
120,134,9,128,115,128,10,116,104,116,12,9,7,9,14,8,7,8,15,35,28,36,16,100,89,100,27,91,81,92,28,85,76,85,30,16,9,17,31,95,84,95,32,87,77,87,34,3,4,3,39,27,7,7,59,1,0,1,7,90,60,10,0,0,5,5,34,11,4,5,38,
46,37,42,39,119,105,117,40,135,120,133,50,140,124,139,51,69,57,69,52,70,61,71,53,129,116,128,59,135,120,134,67,90,60,18,0,135,120,134,10,126,113,126,12,3,2,3,13,18,18,18,14,6,5,6,15,34,27,35,16,100,
90,100,20,103,92,103,29,79,71,79,30,15,9,17,31,59,49,59,32,73,65,73,33,8,8,8,38,2,15,16,39,68,8,6,40,64,1,0,41,12,10,10,59,1,1,2,7,91,60,10,0,0,5,5,34,5,5,5,38,63,50,56,40,136,121,135,49,126,112,126,
50,152,136,151,51,72,61,72,52,66,56,67,53,129,114,128,59,135,120,134,67,91,30,13,0,135,120,134,9,137,121,136,11,85,73,85,12,17,14,19,14,6,5,6,15,37,30,38,16,102,91,102,18,105,92,105,19,88,78,88,20,41,
36,40,21,57,47,53,22,96,85,96,29,85,77,85,97,91,30,10,0,60,52,61,1,10,4,12,3,6,6,6,8,2,14,14,9,67,8,6,10,82,2,0,11,2,3,3,14,41,29,28,15,7,5,4,29,1,1,2,7,92,60,15,0,0,5,5,24,17,16,17,38,2,0,0,39,70,61,
68,40,65,54,59,41,128,113,127,42,136,121,136,47,142,128,143,48,78,66,73,49,46,39,43,50,94,84,94,52,65,57,67,53,130,117,130,54,143,126,141,59,136,120,135,67,92,60,16,0,136,120,135,9,135,120,134,11,110,
97,110,12,27,19,28,14,10,8,10,15,25,19,26,16,99,87,99,21,34,24,27,22,82,71,80,23,98,87,99,29,86,77,86,32,5,2,6,38,7,14,14,41,55,5,4,43,12,2,2,59,1,1,1,7,93,60,18,0,0,5,5,24,20,19,20,36,2,2,2,37,57,48,
54,38,53,42,46,39,12,4,4,40,107,93,104,41,136,120,136,47,129,115,128,48,26,13,15,49,42,28,32,50,90,80,90,51,75,52,68,52,79,64,77,53,122,105,120,54,110,101,111,55,141,125,140,59,138,122,137,67,93,60,
16,0,139,123,138,10,144,128,143,11,119,106,119,12,33,27,35,13,10,9,10,17,34,29,34,19,95,84,95,20,102,91,103,28,93,82,93,31,8,6,8,38,5,13,14,40,66,2,0,41,155,9,6,42,75,50,49,43,22,16,16,59,1,0,1,150,
93,5,2,0,111,109,109,4,113,108,106,7,94,60,17,0,0,7,7,24,19,19,19,36,6,6,6,37,14,15,15,38,61,54,61,39,77,65,73,40,130,114,130,46,137,122,136,48,86,72,81,49,9,3,3,50,120,103,116,52,74,53,69,54,87,58,
76,55,132,109,127,56,72,61,70,57,136,119,134,59,130,117,130,67,94,60,20,0,123,112,124,7,143,124,141,8,94,80,92,9,77,66,76,11,60,50,58,12,84,62,79,13,15,12,16,15,11,8,11,17,100,88,100,18,102,90,102,25,
97,86,98,27,44,32,36,28,90,87,97,30,6,3,3,38,7,12,12,40,52,3,1,41,131,0,0,42,53,27,26,44,13,2,2,59,0,0,2,150,94,5,3,0,104,99,99,3,159,158,158,4,116,115,115,7,95,60,17,0,0,7,7,24,18,18,18,38,0,0,0,39,
34,30,35,40,113,101,113,41,135,120,134,47,140,124,140,48,94,80,90,49,125,111,125,50,133,116,130,52,60,53,62,53,129,114,128,54,78,64,76,55,116,89,108,57,96,63,84,58,162,110,144,59,109,74,97,67,95,30,
15,0,62,41,54,4,64,43,56,6,160,112,143,8,72,45,62,9,67,41,56,11,123,91,113,12,45,32,43,13,12,10,13,15,9,6,10,17,100,89,100,25,92,81,92,26,38,28,32,27,34,24,27,28,51,48,52,29,14,19,19,97,95,30,8,0,8,7,
7,9,3,9,10,10,44,0,0,12,57,44,44,13,9,0,0,15,35,26,26,17,7,7,7,29,0,0,0,150,95,5,3,0,96,85,85,3,154,152,152,4,88,87,87,7,96,60,17,0,0,7,7,19,16,15,16,39,0,0,0,40,23,22,23,41,110,99,110,42,143,127,142,
46,145,128,144,47,127,111,125,50,148,132,147,51,90,76,89,52,70,59,69,53,131,117,131,54,140,126,141,55,143,129,143,57,103,90,102,58,144,118,138,59,143,118,137,67,96,30,13,0,159,131,153,6,142,120,138,8,
96,87,96,11,133,120,133,12,102,91,102,13,27,21,29,14,13,12,13,16,17,12,18,17,95,85,95,24,98,86,98,27,63,57,64,28,22,20,22,29,14,11,12,97,96,30,10,0,10,9,10,9,7,13,14,10,108,2,1,11,78,49,48,12,64,67,
67,13,24,11,11,14,21,7,7,15,67,58,58,17,2,1,1,29,0,0,0,150,96,5,4,0,96,83,83,2,149,146,146,3,146,145,145,4,93,88,86,7,97,60,14,0,0,7,7,40,10,10,10,41,30,27,30,43,135,120,135,44,144,127,143,45,119,104,
117,46,42,34,39,47,61,48,54,48,144,128,144,50,144,129,144,51,92,78,91,52,68,58,69,53,130,117,130,59,138,124,138,67,97,60,20,0,72,62,69,2,139,126,140,8,147,129,146,12,116,103,116,13,42,34,43,14,12,11,
12,16,25,19,27,17,100,89,100,23,98,87,98,25,75,66,75,27,11,10,11,39,1,11,11,40,84,8,6,41,92,3,0,42,67,44,44,43,95,89,89,45,64,54,54,46,82,82,82,47,5,5,5,59,0,0,2,150,97,5,4,0,96,83,83,1,122,120,120,3,
143,141,141,4,90,88,88,7,98,60,11,0,0,7,7,42,5,5,5,44,116,104,116,45,121,106,118,46,46,35,39,48,142,127,142,50,146,129,144,51,89,76,89,52,66,56,67,53,131,117,131,59,139,122,138,67,98,60,19,0,120,104,
118,2,140,123,138,10,139,123,138,12,116,102,116,14,10,8,11,16,20,14,20,17,82,72,82,18,99,88,99,23,93,82,93,27,12,12,12,39,3,10,11,41,75,4,2,42,1,0,0,43,112,105,106,44,51,39,39,45,27,14,14,46,67,58,58,
47,9,10,10,59,0,0,2,150,98,5,4,0,85,83,83,1,123,120,120,3,139,136,136,4,86,86,86,7,99,60,11,0,0,7,7,41,21,19,21,43,6,7,6,44,18,16,18,45,98,87,98,46,145,129,145,50,144,128,142,52,76,66,77,53,129,115,
128,54,139,122,138,59,138,122,137,67,99,60,19,0,143,126,142,11,139,123,138,13,104,91,104,14,13,8,14,16,9,7,9,18,105,94,105,22,94,84,94,25,9,9,9,39,6,11,11,40,42,19,18,41,140,6,1,42,14,4,3,43,34,30,30,
44,3,0,0,45,18,4,4,46,58,45,45,47,45,44,44,48,1,1,1,59,0,0,2,150,99,5,5,0,83,83,83,1,124,121,121,2,135,133,133,3,135,132,132,4,88,88,88,7,100,59,10,0,0,5,5,41,22,21,22,45,5,6,5,46,47,42,47,47,130,116,
130,48,142,125,141,51,142,125,140,52,120,106,119,54,141,124,140,58,138,122,138,66,100,60,18,0,138,122,138,12,138,122,138,14,98,86,99,15,18,13,18,17,13,11,13,19,104,92,104,22,87,77,87,25,15,14,15,40,
12,12,13,41,20,18,19,42,126,8,4,43,69,1,0,44,23,6,6,45,90,80,81,46,99,94,95,47,141,138,139,49,1,1,1,59,2,2,3,150,100,5,4,0,83,83,83,1,124,121,121,3,134,131,131,4,90,88,88,7,101,119,20,0,0,5,5,25,20,
19,20,46,10,10,10,49,137,121,137,71,140,124,139,73,117,104,117,75,8,6,9,77,14,8,15,78,91,79,92,79,98,86,98,82,18,16,18,83,12,11,12,97,10,7,11,101,22,11,12,102,104,0,0,103,111,25,20,104,143,137,137,
107,106,104,104,108,10,11,11,118,2,5,5,150,101,5,4,0,81,81,81,1,124,121,121,3,134,131,131,4,90,88,88,7,102,59,6,0,0,5,5,25,21,21,21,47,5,5,5,48,12,10,12,51,141,125,140,58,139,123,138,66,102,60,19,0,
139,123,138,12,141,125,140,14,119,106,119,16,7,4,8,18,14,9,15,19,52,44,52,20,61,53,60,21,20,17,20,22,13,12,13,40,11,12,13,42,32,11,10,43,16,10,10,44,127,4,4,45,140,78,76,46,124,133,134,48,124,122,122,
49,37,36,36,50,6,6,6,59,1,5,7,150,102,5,4,0,89,87,87,1,123,120,120,3,134,131,131,4,90,88,88,7,103,119,17,0,0,5,5,25,22,22,22,49,13,9,13,50,22,18,22,52,130,115,130,53,141,125,140,71,142,125,141,74,99,
86,100,75,25,17,27,79,9,9,9,102,10,12,13,103,119,0,0,104,133,55,53,105,117,125,126,107,137,134,135,109,3,3,3,118,2,7,7,151,103,4,3,0,109,106,106,2,133,130,130,3,90,88,88,7,104,119,19,0,0,5,5,25,21,21,
21,51,14,11,14,52,32,27,32,54,128,114,128,56,145,123,139,72,141,124,141,74,126,110,126,75,52,42,54,78,11,6,13,102,12,12,13,103,60,5,5,104,49,4,2,105,97,96,97,106,134,131,131,108,125,122,123,109,33,33,
33,110,7,7,7,118,4,7,8,151,104,4,3,0,106,104,104,2,129,126,126,3,109,107,107,7,105,59,6,0,0,5,5,20,20,20,20,53,13,10,14,54,34,29,35,56,112,117,130,58,142,120,137,66,105,60,16,0,141,124,141,12,141,125,
141,14,99,87,99,15,40,34,40,16,15,9,16,32,23,21,23,42,18,14,14,43,2,13,14,44,135,9,5,45,95,3,1,46,20,30,31,47,112,106,106,49,135,131,132,50,86,83,85,51,4,3,4,59,4,7,9,151,105,4,3,0,107,106,106,2,135,
132,132,3,94,92,92,7,106,119,20,0,0,4,4,46,22,21,22,55,19,6,11,56,9,50,53,58,129,120,134,60,150,132,149,68,147,129,145,70,118,104,118,72,17,13,17,91,24,22,24,102,0,13,14,103,74,10,8,104,86,4,2,105,66,
30,30,106,132,126,126,108,132,129,129,109,124,121,122,110,34,33,33,111,4,4,4,118,4,8,9,151,106,4,3,0,106,104,104,2,135,131,131,3,87,85,85,7,107,59,9,0,0,4,4,20,20,18,20,48,14,13,14,50,17,13,17,52,68,
59,68,55,20,8,13,56,17,52,55,57,17,25,29,58,15,60,63,66,107,60,20,0,42,43,49,2,120,105,120,5,148,131,147,7,141,124,140,10,48,41,48,12,35,30,35,14,73,63,73,16,11,8,12,39,11,10,11,42,19,13,14,43,46,10,
9,44,19,9,10,45,105,8,5,46,59,4,3,47,112,99,100,48,131,130,131,50,137,135,135,51,86,83,83,52,4,3,4,59,4,8,11,151,107,3,3,0,114,112,112,1,62,55,55,2,101,96,96,7,108,59,8,0,0,2,2,28,23,23,23,48,15,13,
15,50,25,20,25,51,69,59,69,53,77,66,77,56,63,50,59,58,30,19,24,66,108,30,11,0,25,20,24,2,34,29,34,4,107,93,106,5,110,97,110,7,48,41,48,8,41,34,41,12,78,69,78,14,70,62,70,16,19,17,19,17,15,8,16,29,13,
11,13,96,108,30,13,0,11,9,11,12,18,14,15,13,38,12,11,14,8,13,13,15,42,11,10,16,39,2,2,17,42,27,29,18,125,120,121,19,129,127,127,21,123,121,121,22,31,30,30,23,3,3,3,29,4,9,11,151,108,4,4,0,107,105,105,
1,104,100,100,2,127,124,124,3,94,94,94,7,109,119,18,0,0,2,2,28,25,24,25,49,14,10,14,51,76,66,76,60,78,68,78,64,47,40,47,68,78,68,78,73,73,63,73,76,15,11,16,104,6,11,13,105,15,10,9,106,59,0,0,108,142,
137,138,109,147,144,145,110,147,145,144,111,109,108,108,112,12,12,12,118,4,8,12,150,109,5,5,0,22,22,22,1,110,108,108,2,132,129,129,3,146,144,144,4,87,86,86,7,110,112,16,0,0,2,2,35,28,27,28,49,16,13,
16,51,75,65,75,63,80,69,80,69,76,65,76,71,57,47,54,73,76,65,76,75,17,14,17,91,25,24,25,104,6,11,12,107,69,5,3,108,127,113,114,109,148,147,148,110,148,145,145,111,53,44,44,120,110,6,3,0,21,18,20,1,5,4,
4,5,4,8,14,150,110,5,4,0,39,39,39,1,117,114,114,3,154,152,152,4,95,92,92,7,111,119,18,0,0,2,2,26,26,26,26,49,18,15,18,50,67,58,67,51,73,64,73,73,78,67,78,75,17,13,17,102,13,12,13,106,29,8,9,107,91,2,
0,108,72,73,75,109,141,137,138,110,62,52,53,111,70,62,62,112,104,98,100,113,77,74,74,114,0,0,0,118,4,9,14,150,111,5,4,0,54,52,52,2,155,152,152,3,163,159,159,4,77,73,73,7,112,109,17,0,0,2,2,34,14,13,
14,35,29,28,29,37,12,9,12,49,18,15,18,50,68,58,68,51,73,63,73,62,76,66,77,63,50,40,47,65,78,67,77,73,77,66,77,76,19,16,19,103,14,14,15,105,43,8,8,106,28,10,11,107,90,4,4,108,40,15,15,117,112,9,5,0,51,
43,45,1,126,120,121,3,130,126,126,5,0,0,0,8,4,9,14,150,112,5,4,0,69,67,67,2,147,144,144,3,126,124,124,4,4,3,3,7,113,109,12,0,0,2,2,35,26,25,26,49,16,14,16,51,76,66,76,74,74,63,74,76,20,17,20,83,15,13,
15,89,14,7,15,91,26,24,26,105,5,11,14,107,12,11,11,108,40,10,9,118,113,8,5,0,93,84,85,1,132,128,128,3,114,110,111,4,15,14,14,7,2,11,12,150,113,4,4,0,76,74,74,1,126,123,123,2,145,142,142,3,113,110,110,
7,114,109,10,0,0,2,2,19,7,6,7,20,21,21,21,49,17,14,17,51,66,56,65,53,75,65,75,74,78,67,78,75,33,29,33,76,19,16,19,108,21,12,12,118,114,8,6,0,57,46,46,1,133,130,130,3,126,122,122,4,105,101,102,5,0,0,0,
7,2,11,12,150,114,4,4,0,34,32,32,1,118,115,115,2,142,138,138,3,112,109,109,7,115,119,20,0,0,2,2,24,23,22,23,32,11,9,11,35,29,27,29,49,18,15,18,50,41,34,41,51,23,15,19,53,78,68,79,73,77,65,77,76,29,24,
29,79,20,11,21,91,27,24,27,109,7,7,8,110,84,79,81,111,128,125,126,113,132,129,129,115,128,123,124,116,51,49,49,117,6,4,5,118,5,12,15,150,115,4,3,0,85,83,83,1,130,126,126,3,114,110,110,7,116,119,18,0,
0,2,2,32,11,10,11,36,30,29,30,49,17,14,17,50,38,33,38,52,36,27,33,53,77,67,77,73,81,70,81,78,15,9,16,91,27,25,26,106,9,11,13,107,34,9,9,110,8,5,5,111,83,80,81,112,127,122,123,116,134,129,130,117,15,
11,12,118,0,5,7,150,116,4,3,0,81,80,80,1,126,122,122,3,117,114,114,7,117,119,20,0,0,2,2,34,17,15,17,36,35,33,35,38,16,14,16,49,21,17,21,50,57,48,57,51,25,16,21,54,78,67,78,72,80,69,80,74,50,39,47,77,
60,51,60,79,22,12,24,82,15,11,15,111,10,9,10,112,97,94,95,113,128,124,124,114,130,126,126,116,123,119,119,117,92,86,88,118,10,11,11,150,117,4,3,0,90,88,88,2,136,132,132,3,65,63,63,7,118,59,8,0,0,2,2,
36,29,27,29,46,19,16,19,50,71,61,71,51,36,27,32,52,31,20,26,53,75,64,75,58,78,66,78,66,118,60,17,0,78,67,78,13,82,70,83,15,12,1,5,16,17,8,12,17,70,59,70,18,80,68,80,19,80,69,79,20,30,19,31,22,47,39,
46,26,14,12,14,32,28,25,28,52,14,12,12,53,44,42,43,54,122,117,118,57,121,118,118,58,144,135,136,59,44,61,61,150,118,4,4,0,42,35,35,1,127,123,123,2,132,128,128,3,55,53,53,7,119,60,7,0,1,2,2,27,24,23,
24,46,16,14,16,48,65,56,65,50,45,36,43,51,74,64,74,59,78,67,78,67,119,60,16,0,78,67,78,13,80,69,80,15,42,33,39,18,80,68,80,20,19,10,21,21,73,61,72,27,13,11,13,44,25,23,24,51,21,19,19,52,4,2,3,53,47,
43,45,54,122,117,117,55,130,125,125,56,100,96,97,58,125,134,135,59,27,59,59,150,119,4,3,0,41,34,34,2,133,130,130,3,75,73,73,7,120,60,8,0,1,2,2,36,28,26,28,44,15,13,15,48,76,66,76,51,63,53,62,52,41,30,
37,53,77,65,76,59,78,67,78,67,120,61,15,0,78,67,78,14,82,71,82,16,54,45,54,18,80,68,80,19,73,61,72,20,19,8,21,21,69,58,69,22,80,69,80,29,24,27,34,53,4,3,3,54,95,90,92,55,123,118,118,56,21,18,18,58,
144,136,136,60,0,0,0,149,120,5,5,0,6,6,6,1,90,84,84,2,125,118,118,3,123,118,118,4,55,53,53,7,121,116,19,0,1,2,2,36,30,28,30,42,16,10,18,44,24,20,24,46,97,84,97,47,99,87,99,50,82,70,82,51,56,45,54,53,
83,71,83,79,78,66,77,80,40,29,41,82,78,67,78,86,78,66,78,88,67,62,71,90,21,16,19,111,26,23,24,113,11,8,9,114,15,12,12,115,108,104,104,124,121,5,4,0,15,13,14,1,109,105,106,2,135,131,131,4,5,5,5,149,
121,5,5,0,26,23,23,1,120,116,116,2,142,137,137,3,98,94,94,4,0,0,0,7,122,116,15,0,1,2,2,30,12,10,11,37,31,29,31,42,14,9,14,45,113,98,113,46,118,104,118,48,115,100,115,50,74,63,74,79,84,72,83,80,49,38,
50,81,51,39,51,82,80,69,80,88,82,71,81,90,23,19,23,115,23,20,21,125,122,4,3,0,74,68,69,2,142,137,137,3,35,32,32,149,122,5,5,0,27,23,23,1,119,114,114,2,155,151,151,3,99,96,96,4,0,0,0,7,123,117,18,0,1,
2,2,37,29,26,29,42,15,10,15,43,43,31,43,44,35,25,30,45,101,87,100,46,115,100,115,49,115,100,115,53,75,65,75,79,80,70,80,81,38,28,40,82,80,69,80,86,75,65,75,87,46,36,43,88,74,63,73,90,20,16,19,114,13,
10,10,116,44,42,42,125,123,5,5,0,16,48,48,1,79,120,121,2,139,125,125,3,108,103,103,4,17,16,16,149,123,5,5,0,20,17,17,1,125,119,119,2,145,139,139,3,96,92,92,4,0,0,0,7,124,118,15,0,1,2,2,42,20,15,20,43,
24,13,26,44,51,41,47,45,111,97,111,51,118,103,118,55,79,67,79,79,79,68,79,81,46,35,47,82,82,70,82,86,78,67,78,88,73,61,70,90,21,17,21,116,12,8,8,117,41,30,34,126,124,5,3,0,67,80,81,2,136,131,131,4,0,
0,0,149,124,4,4,0,66,62,62,1,129,123,123,2,125,120,120,3,81,78,78,7,125,118,13,0,1,2,2,42,19,16,20,43,26,19,28,44,117,102,117,53,118,102,118,57,78,67,78,80,78,68,80,81,52,41,52,83,80,68,79,88,82,71,
81,90,23,18,23,111,27,23,24,117,5,0,4,126,125,5,5,0,119,105,105,1,93,89,89,2,131,123,123,3,129,122,122,4,52,47,47,149,125,4,4,0,90,85,85,1,136,129,129,2,126,121,121,3,29,27,27,7,126,125,19,0,1,2,2,42,
20,17,20,43,30,23,31,44,114,99,114,55,120,104,120,59,80,68,80,80,84,66,78,82,54,43,55,83,83,72,83,88,80,69,79,90,25,20,24,91,23,20,23,111,28,23,24,117,10,2,6,118,19,19,21,119,113,119,119,121,147,140,
139,123,104,97,97,124,6,5,5,149,126,4,4,0,87,80,80,1,135,128,128,2,135,128,128,3,36,32,32,7,127,63,8,0,1,2,2,42,21,18,21,43,25,17,26,44,100,85,101,45,119,105,119,58,122,106,122,60,85,72,85,62,80,67,
80,70,127,63,16,0,82,68,82,15,81,72,83,16,91,47,54,18,73,62,74,25,81,69,80,27,26,21,26,28,22,18,21,48,28,23,24,54,13,0,3,55,2,18,18,56,25,70,71,57,106,91,91,58,144,139,139,59,146,140,140,61,91,84,84,
62,0,0,0,148,127,5,5,0,4,4,4,1,90,83,83,2,141,134,134,3,92,86,86,4,12,10,10,7,128,63,7,0,1,2,2,35,28,25,27,43,15,8,15,45,123,107,122,46,106,91,106,60,122,105,122,62,101,86,101,70,128,63,16,0,97,82,97,
1,82,69,82,14,79,73,87,15,113,38,43,17,79,71,85,25,81,70,81,27,26,21,26,28,22,19,21,48,23,19,19,54,11,0,0,56,0,45,45,57,44,27,27,58,129,123,123,60,142,133,133,61,126,117,117,62,35,28,28,148,128,4,4,0,
45,38,38,1,126,119,119,2,141,133,133,3,72,65,65,7,129,127,19,0,1,2,2,42,28,24,28,43,13,8,13,45,118,102,117,62,126,109,126,69,82,68,82,76,78,73,87,77,124,39,45,78,87,37,43,79,71,69,81,88,77,66,76,91,
23,19,22,117,11,0,0,119,9,55,55,120,6,4,4,122,129,121,121,123,140,130,130,125,115,107,107,126,10,5,5,148,129,4,4,0,51,45,45,1,132,123,123,2,141,133,133,3,83,76,76,7,130,64,5,0,1,1,1,38,27,23,26,43,14,
10,14,45,120,104,120,63,123,105,123,71,130,64,19,0,124,106,124,3,126,109,126,6,88,74,88,11,79,77,92,12,124,43,50,13,121,21,23,14,75,72,84,20,81,69,80,24,112,98,111,26,26,20,25,51,24,19,19,53,13,0,1,
55,9,53,53,56,7,0,0,57,2,0,0,59,135,126,126,61,126,117,117,62,67,59,59,63,8,31,31,148,130,4,4,0,46,39,39,1,134,125,125,2,124,116,116,3,34,28,28,7,131,64,5,0,2,1,1,43,22,17,21,44,44,32,46,45,108,92,
107,63,123,106,123,71,131,64,17,0,123,106,123,10,120,109,126,11,130,85,98,12,118,25,28,13,103,88,103,14,127,110,127,24,131,114,130,26,24,19,24,50,27,20,20,52,10,7,7,53,30,0,2,55,4,51,51,56,10,0,0,58,
1,0,0,60,137,128,128,62,139,128,128,63,35,59,59,148,131,4,4,0,64,56,56,1,137,128,128,2,116,108,108,3,6,1,1,7,132,64,7,0,2,1,1,40,28,23,27,44,18,8,19,45,104,88,103,46,123,107,122,48,107,93,107,63,124,
107,124,71,132,65,16,0,125,107,125,10,117,99,115,11,109,33,39,12,101,82,95,13,130,115,134,24,127,110,126,26,24,19,23,51,27,19,19,52,9,5,6,54,66,10,10,56,15,1,1,59,2,0,0,61,138,127,127,62,139,126,126,
63,105,99,99,64,14,9,10,147,132,5,5,0,9,5,5,1,110,101,101,2,139,130,130,3,123,113,113,4,18,11,11,7,133,130,19,0,2,1,1,44,20,12,20,45,106,90,106,46,125,109,124,52,107,93,107,74,127,109,127,75,107,91,
106,76,125,108,125,88,128,111,127,90,21,16,21,114,27,19,19,117,16,3,8,119,65,5,6,122,11,1,1,124,2,0,0,126,134,123,123,127,145,131,132,128,99,87,89,129,17,10,10,147,133,5,4,0,0,0,0,1,109,99,99,2,143,
132,132,4,7,3,3,7,134,131,13,0,2,1,2,44,20,12,20,45,108,92,108,46,125,109,124,75,131,113,131,88,128,110,127,90,22,16,21,116,14,6,7,119,60,6,6,125,4,0,0,126,112,101,101,128,143,129,130,130,0,0,0,147,
134,4,4,0,46,37,37,1,119,108,108,2,142,131,131,3,54,45,45,7,135,132,16,0,4,2,2,41,27,22,25,44,17,8,16,46,126,110,126,56,128,111,128,88,129,111,128,90,22,16,20,115,29,18,19,116,10,5,6,118,68,8,7,125,
25,2,2,126,56,35,35,127,121,109,109,129,136,122,123,130,49,39,39,131,0,0,0,147,135,4,4,0,80,69,69,1,139,127,127,2,142,130,130,3,62,53,53,6,136,134,19,0,4,9,9,45,20,13,19,46,45,33,46,47,128,111,127,75,
128,110,128,88,123,106,121,89,114,97,113,90,39,25,38,92,21,16,19,116,26,15,16,117,11,3,5,119,67,7,7,127,28,0,0,128,57,33,33,129,126,112,114,130,143,129,129,131,138,124,124,132,52,38,38,133,2,0,0,147,
136,4,4,0,72,62,62,1,140,128,128,2,139,127,127,3,52,44,44,6,137,134,16,0,4,9,9,45,22,14,22,46,48,36,49,47,128,111,127,88,124,107,123,89,107,91,105,90,20,7,20,93,33,27,31,117,11,4,5,119,68,7,7,128,25,
0,0,129,57,33,34,130,126,111,112,131,138,124,124,132,128,113,113,133,56,42,42,147,137,4,4,0,73,62,62,1,148,134,134,2,105,92,92,3,1,0,0,6,138,134,17,0,4,9,9,45,22,14,21,46,48,36,48,47,128,111,127,59,
129,112,129,88,123,106,122,89,114,97,112,90,35,23,35,91,28,21,25,116,27,15,16,117,11,3,5,119,69,7,7,129,20,0,0,130,68,47,47,131,140,126,126,132,138,122,122,133,33,9,9,147,138,4,4,0,80,67,67,1,151,137,
137,2,103,90,90,3,0,0,0,6,139,136,18,0,4,11,11,45,22,15,20,46,48,36,48,47,128,111,127,72,130,111,130,89,123,105,121,90,57,43,56,91,23,15,20,93,36,30,33,101,21,5,17,103,29,21,23,117,13,4,6,119,69,7,7,
130,33,10,10,131,98,80,80,132,131,115,115,134,93,77,77,135,13,1,1,146,139,5,5,0,33,20,20,1,123,109,109,2,147,133,133,3,105,91,91,4,0,0,0,6,140,137,15,0,6,11,11,45,23,17,21,46,48,35,48,47,128,110,126,
72,130,111,130,89,129,111,127,91,14,7,12,93,36,30,33,117,14,5,7,119,69,7,7,130,24,0,0,131,42,19,18,132,136,120,120,134,158,143,143,136,12,12,12,146,140,5,5,0,38,24,24,1,131,116,116,2,145,131,131,3,
104,90,90,4,2,0,0,6,141,137,17,0,6,11,11,45,19,12,17,46,50,37,49,47,128,111,126,89,129,111,127,91,15,7,12,93,36,29,32,99,19,12,13,101,72,56,65,102,18,6,12,105,31,21,23,117,16,4,7,119,70,7,7,131,26,4,
3,133,128,111,111,135,154,138,138,136,94,81,81,146,141,4,4,0,31,18,18,1,131,115,115,2,140,124,124,3,45,31,31,6,142,137,17,0,6,13,13,45,21,14,18,46,51,38,50,47,129,110,126,67,132,112,131,89,129,111,
127,91,14,7,11,93,35,28,31,99,21,11,16,101,77,59,69,102,20,7,14,117,17,4,8,119,72,8,7,132,22,0,0,133,131,110,110,135,156,141,141,136,120,106,106,146,142,4,4,0,49,34,34,1,134,118,118,2,139,123,123,3,
40,26,26,6,143,69,8,0,6,13,13,5,8,0,1,9,41,3,3,14,11,5,5,45,22,15,19,46,53,38,50,47,129,110,126,68,130,111,130,75,143,69,15,0,130,111,130,20,130,111,127,22,15,8,11,24,33,26,30,30,25,13,19,32,73,56,65,
33,20,4,13,48,17,4,8,50,74,8,7,63,28,2,2,64,47,24,24,65,128,109,109,66,128,110,110,67,61,51,51,68,25,9,9,146,143,4,4,0,100,84,84,1,146,129,129,2,144,127,127,3,45,32,32,6,144,69,7,0,15,15,15,12,51,5,6,
15,14,6,7,45,22,15,19,46,53,38,50,47,129,110,126,68,130,111,129,75,144,69,16,0,130,111,129,20,130,111,126,22,15,7,11,24,32,25,28,30,27,13,20,31,76,57,67,32,76,59,68,33,31,15,26,34,22,11,13,48,18,4,8,
50,74,7,7,64,18,0,0,65,100,76,76,66,145,126,126,67,133,113,113,68,76,58,58,146,144,4,4,0,98,80,80,1,150,131,131,2,126,108,108,3,39,24,24,6,145,72,8,0,11,15,15,14,69,7,7,16,19,4,8,17,15,5,8,45,21,14,
18,46,53,38,50,47,129,109,125,71,128,110,127,78,145,72,17,0,128,109,127,17,130,111,127,19,16,8,13,26,32,23,24,27,20,5,13,28,71,55,65,29,85,71,80,31,19,8,11,45,19,4,8,47,76,7,7,62,21,1,1,63,117,96,96,
64,149,130,130,65,121,103,103,66,27,10,10,69,154,135,135,71,0,0,0,6,146,71,9,0,9,15,15,15,73,7,7,16,72,7,8,18,16,6,8,23,32,21,22,45,24,16,20,46,52,37,49,47,129,109,125,70,128,109,127,77,146,72,17,0,
128,109,126,18,130,111,126,20,17,9,13,27,29,18,21,29,74,54,62,30,75,28,32,32,20,13,16,46,22,3,7,48,75,7,7,63,24,0,0,64,54,34,34,65,147,126,126,67,97,79,79,68,26,10,10,69,114,95,95,70,153,133,133,71,
90,73,73,6,147,71,10,0,11,15,15,2,17,0,0,16,79,7,8,17,74,7,10,18,16,5,8,23,33,22,23,46,22,8,19,47,94,75,91,48,129,110,126,70,127,109,126,77,147,72,17,0,127,109,126,18,130,111,126,20,16,7,12,27,24,14,
18,28,59,30,40,29,92,20,23,30,85,6,6,32,18,8,14,46,25,4,8,47,77,7,8,63,32,3,3,64,2,0,0,66,158,134,134,67,137,116,116,68,39,21,21,70,147,127,127,71,88,70,70,6,148,71,9,0,11,18,18,2,24,0,0,17,83,9,9,19,
19,6,8,42,32,22,25,46,16,2,13,47,90,71,87,48,130,110,126,70,127,109,126,77,148,72,17,0,127,109,126,18,131,111,125,20,16,3,13,26,38,26,28,27,19,14,20,29,111,14,15,32,19,6,15,46,25,4,8,47,75,7,8,48,79,
6,7,64,19,4,4,65,24,19,19,66,119,96,96,67,146,124,124,68,121,100,100,70,141,120,120,71,79,59,59,6,149,71,10,0,11,17,17,2,30,0,0,18,91,9,9,19,32,5,10,20,18,9,10,44,30,21,26,46,19,5,15,47,91,72,88,48,
131,110,126,70,126,108,125,77,149,72,16,0,126,108,125,18,129,110,123,20,18,5,14,26,35,25,27,27,28,11,20,29,106,14,16,32,25,7,14,46,25,4,7,47,78,7,8,48,80,7,7,65,12,7,7,66,37,15,15,67,159,135,135,68,
135,113,113,70,150,127,127,71,78,59,59,7,150,71,9,0,21,6,6,17,88,9,9,18,79,7,10,19,29,7,11,20,23,11,12,45,21,9,17,46,90,71,86,47,130,110,126,70,126,107,125,78,150,71,18,0,126,107,124,17,130,111,125,
18,102,83,98,19,26,13,22,25,28,20,22,26,38,12,20,27,104,13,16,29,100,13,15,31,31,7,13,32,26,15,16,45,26,4,7,46,79,7,8,47,82,7,7,65,15,2,2,67,146,122,122,68,128,106,106,69,140,117,117,70,29,1,1,7,151,
72,7,0,24,6,6,18,100,10,9,20,22,8,13,45,23,12,18,46,94,77,91,47,131,111,127,71,126,107,124,79,151,36,12,0,126,107,123,14,127,111,127,15,114,90,102,16,115,92,106,17,93,58,68,18,27,8,16,25,36,10,19,26,
102,13,16,27,103,13,15,29,74,10,12,30,28,6,15,35,32,17,18,115,151,37,14,0,33,17,18,8,27,4,7,9,80,6,8,10,83,7,7,25,37,0,0,27,22,15,15,29,18,0,0,30,131,108,108,31,145,123,123,32,117,91,91,33,60,35,35,
34,107,86,86,35,116,94,94,36,29,13,13,7,152,73,9,0,29,5,5,18,96,10,10,19,92,8,10,20,29,10,16,21,24,11,11,45,27,17,22,46,71,43,53,47,123,103,118,72,125,106,123,80,152,36,14,0,125,106,123,10,123,104,
120,12,88,49,57,13,93,54,62,14,72,15,18,15,82,11,14,16,87,11,15,17,30,10,18,23,26,15,21,24,37,7,17,25,104,13,15,27,102,13,15,30,24,10,15,35,27,11,12,116,152,37,13,0,35,18,19,7,28,3,8,8,82,7,8,9,85,7,
7,26,25,16,16,27,24,0,0,28,27,6,6,29,130,106,106,30,151,127,127,32,137,115,115,33,164,141,141,34,163,141,141,36,0,0,0,7,153,73,13,0,32,7,7,18,97,9,10,19,97,9,10,20,43,6,13,21,24,11,13,45,28,21,27,46,
60,9,15,47,89,21,25,49,74,25,30,50,104,72,84,51,102,69,81,53,129,113,129,72,124,104,120,80,153,36,12,0,124,103,120,6,127,113,130,9,79,36,43,12,74,6,9,16,105,17,20,17,33,11,19,23,26,16,21,25,106,14,15,
27,105,13,15,28,94,12,12,30,23,9,14,35,32,16,17,116,153,37,11,0,37,18,20,7,30,3,9,8,83,7,8,9,86,7,7,28,24,2,2,29,131,106,106,30,157,132,132,32,136,114,114,34,163,140,140,35,152,130,130,36,72,55,55,7,
154,73,11,0,30,7,7,19,107,11,10,21,22,11,15,45,26,19,26,47,110,17,18,51,69,5,8,53,84,36,44,54,107,81,94,57,114,88,102,59,131,114,132,72,129,112,130,80,154,36,16,0,130,115,132,2,111,87,100,3,115,95,
109,5,82,31,37,6,90,39,47,8,86,7,10,11,106,16,20,16,101,16,18,17,32,11,18,23,23,14,19,24,82,11,16,25,107,14,15,27,104,13,14,28,93,12,12,30,21,6,14,35,34,16,17,116,154,37,12,0,30,12,14,7,30,2,9,8,85,7,
8,9,88,7,8,26,31,16,16,27,24,0,0,28,55,30,30,29,137,111,111,30,157,132,132,33,139,115,115,35,157,135,135,36,91,66,66,7,155,74,19,0,29,7,7,19,103,10,11,20,89,9,11,21,35,8,14,22,26,11,12,28,35,20,21,30,
19,5,15,31,69,9,15,33,33,22,23,38,21,13,17,40,60,12,20,41,24,19,22,45,25,18,25,46,81,14,21,47,108,18,20,52,104,15,19,57,69,9,12,59,97,57,67,73,96,58,67,81,155,37,11,0,80,33,40,1,76,9,13,7,106,21,24,
15,102,15,18,16,32,11,18,22,20,10,15,23,81,11,16,24,108,13,14,27,91,12,12,29,32,5,13,36,39,20,20,118,155,37,13,0,33,13,13,5,31,2,9,6,87,7,8,7,91,7,8,16,49,2,2,23,43,5,5,25,20,0,0,27,156,129,129,28,
160,135,135,32,134,111,111,33,147,125,125,35,118,90,90,36,63,45,45,7,156,74,16,0,19,7,7,2,51,3,3,20,108,11,10,21,43,9,15,22,25,9,11,30,30,5,13,31,82,11,15,32,30,8,15,38,21,12,17,39,52,11,19,40,54,9,
18,41,25,16,23,45,26,18,24,47,107,17,20,66,78,10,13,73,96,11,14,81,156,37,9,0,98,15,19,15,102,15,18,16,33,11,18,22,20,9,16,23,82,11,16,24,108,13,14,27,101,12,14,30,29,16,18,36,40,20,21,118,156,38,14,
0,32,12,12,4,26,9,10,6,99,7,8,15,55,2,3,24,42,10,10,25,22,0,0,27,167,139,139,28,170,145,145,29,143,117,117,30,67,43,43,31,151,127,127,32,136,112,112,35,148,126,126,37,78,59,59,7,157,78,15,0,23,7,7,2,
55,3,3,20,108,11,11,22,28,10,15,29,28,16,18,30,47,7,14,31,113,14,14,32,50,7,15,33,32,20,23,38,21,10,16,40,91,12,17,41,25,11,20,46,30,9,21,47,103,16,20,77,102,18,22,85,157,39,11,0,103,18,22,11,102,15,
18,12,34,10,18,18,24,8,18,19,84,11,15,20,107,13,14,23,103,12,14,26,25,10,14,32,41,21,21,37,27,9,10,38,69,5,10,124,157,39,18,0,101,8,9,8,58,2,4,18,43,6,6,19,48,19,19,20,131,103,103,22,172,147,147,23,
151,125,125,24,22,0,0,25,113,88,88,26,162,138,138,27,135,111,111,30,158,135,135,31,120,99,99,32,136,114,114,34,88,70,70,35,103,86,86,36,39,24,24,38,0,0,0,7,158,79,17,0,38,16,16,1,48,1,1,20,111,10,11,
21,92,9,11,22,29,8,15,29,31,17,18,30,45,7,14,31,116,13,14,33,30,20,24,38,25,12,19,39,47,7,17,40,113,15,16,41,47,8,18,44,24,13,14,46,34,10,20,47,103,16,19,78,103,17,21,86,158,40,12,0,103,17,20,10,103,
15,18,11,33,8,18,16,24,15,17,17,46,10,17,18,104,13,14,22,104,12,13,25,26,8,13,31,42,22,22,36,28,8,10,38,103,9,9,39,94,8,8,126,158,40,15,0,92,7,7,16,44,4,4,17,58,24,24,18,159,129,129,20,172,149,149,21,
150,123,123,22,40,15,15,23,25,10,10,24,132,108,108,25,157,132,132,26,134,110,110,33,152,132,132,35,128,110,110,38,8,3,3,39,6,0,0,5,159,72,17,0,18,9,9,3,57,1,1,23,111,10,11,24,55,7,13,25,28,13,15,31,
31,17,18,32,46,8,14,33,115,13,13,35,27,12,20,40,28,15,22,41,43,7,17,42,114,15,16,44,32,14,21,47,25,14,18,48,34,9,19,49,103,16,19,71,104,18,22,77,159,72,16,0,103,18,22,19,102,14,17,20,35,9,18,25,19,11,
14,27,110,13,14,32,97,11,12,34,28,8,13,45,28,8,10,47,104,9,8,53,67,4,4,65,44,3,3,66,86,52,52,67,157,127,127,69,171,147,147,70,150,123,123,71,44,18,18,150,159,18,6,0,72,49,49,1,164,138,138,6,137,115,
115,12,168,154,154,14,127,113,113,17,15,5,5,5,160,72,18,0,14,17,17,2,57,3,3,23,113,11,11,25,28,8,13,31,31,17,17,32,48,8,14,33,111,12,13,34,101,11,13,35,43,11,19,36,32,19,20,40,30,15,21,41,82,10,16,43,
109,14,17,44,37,9,17,47,25,14,16,48,34,11,19,49,104,15,18,71,104,18,22,77,160,72,17,0,104,18,22,19,102,14,17,20,30,7,18,25,20,12,14,26,49,8,14,27,109,14,14,32,99,11,12,34,25,6,12,45,28,7,10,47,106,9,
8,51,74,5,5,65,40,0,0,66,132,98,98,67,164,133,133,69,173,147,147,70,152,124,124,71,40,15,15,150,160,22,14,0,7,0,0,2,145,120,120,3,115,92,92,4,141,119,119,6,140,118,118,8,98,85,85,9,134,114,114,12,122,
103,103,14,152,137,137,16,145,130,130,18,94,84,84,19,36,20,20,20,33,60,60,21,0,63,63,5,161,72,19,0,17,17,17,2,60,4,4,20,108,9,10,24,101,9,11,25,33,9,14,31,32,16,18,32,49,8,14,33,111,12,13,34,108,11,
13,35,40,9,16,38,32,16,18,40,32,15,21,41,94,11,15,43,107,15,16,45,32,20,25,47,26,14,16,48,36,13,21,49,103,14,18,71,105,17,21,77,161,72,18,0,103,17,21,19,105,15,16,21,26,15,20,25,23,12,17,26,48,7,15,
27,109,14,14,32,98,10,12,35,29,12,14,45,29,7,10,47,107,9,8,50,75,6,6,64,51,6,6,65,51,8,8,66,129,94,94,67,166,136,136,69,169,141,141,70,142,112,112,71,42,14,14,152,161,9,9,0,43,20,20,1,2,0,0,2,89,67,
67,3,145,123,123,4,149,127,127,5,122,101,101,6,17,7,7,7,32,20,20,8,94,75,75,162,161,14,9,0,68,46,46,1,143,126,126,5,146,132,132,8,122,127,127,9,74,85,85,10,94,102,102,11,34,45,45,12,20,13,13,13,22,17,
17,5,162,72,19,0,19,19,19,2,65,5,5,19,108,9,10,24,107,10,11,25,46,4,12,26,33,13,15,31,32,16,17,32,49,8,14,33,111,12,13,34,109,12,13,36,32,15,20,40,32,15,21,41,92,11,15,43,109,15,16,44,88,12,16,45,24,
12,19,48,35,12,20,49,102,14,18,71,105,17,21,77,162,72,18,0,103,17,20,19,108,15,16,20,82,11,17,21,24,14,19,25,24,11,18,27,108,14,14,32,105,11,13,35,27,12,14,45,29,7,10,47,107,9,8,48,84,6,6,64,43,0,0,
65,79,40,40,66,164,132,132,68,170,142,142,69,160,130,130,70,68,30,30,71,26,3,3,154,162,6,5,0,38,21,21,1,130,107,107,3,153,131,131,4,123,102,102,5,23,10,10,162,162,15,7,0,36,25,25,3,133,118,118,9,153,
138,138,11,128,116,116,12,138,128,128,13,84,79,79,14,3,0,0,5,163,72,20,0,37,27,27,1,66,2,2,8,73,4,5,10,96,7,7,24,116,11,11,26,29,11,15,31,31,15,16,32,50,9,15,33,110,11,13,35,91,9,13,36,31,15,21,40,32,
15,21,41,93,10,14,42,108,14,15,44,106,14,16,45,48,10,18,47,29,15,17,48,36,11,18,49,107,14,17,71,104,17,20,77,163,72,16,0,103,16,20,19,108,15,16,20,80,11,16,21,21,12,17,25,29,12,18,26,92,11,14,27,106,
13,13,32,106,11,13,35,32,10,15,45,29,7,9,47,100,8,7,64,48,3,3,66,141,105,105,69,170,139,139,70,140,108,108,71,33,8,8,155,163,6,5,0,45,26,26,1,132,109,109,3,148,129,129,4,117,97,97,5,29,15,15,164,163,
15,8,0,8,0,0,5,143,131,131,6,118,106,106,9,152,143,143,11,126,120,121,12,99,79,79,13,127,31,25,14,94,5,0,5,164,72,19,0,56,12,12,9,78,5,5,11,101,7,8,24,113,10,11,25,91,8,11,26,35,5,12,31,32,15,16,32,
52,9,15,33,111,10,13,35,88,10,14,36,27,7,16,40,34,15,21,41,93,10,13,44,112,14,15,46,29,17,23,48,27,9,17,49,82,12,18,50,108,15,17,71,104,16,20,77,164,72,17,0,103,16,20,19,107,13,15,20,78,11,16,21,18,8,
13,25,30,13,19,26,95,11,14,27,105,12,13,33,98,10,11,35,32,7,13,45,30,7,9,47,98,7,7,63,53,2,2,66,61,19,19,67,168,135,135,69,168,136,136,70,150,120,120,71,43,17,17,156,164,6,5,0,63,50,50,1,141,121,121,
3,146,126,126,4,114,95,95,5,31,18,18,167,164,13,8,0,0,0,0,1,39,29,29,3,71,61,61,4,133,126,126,8,158,150,150,10,131,126,126,11,102,51,49,12,16,0,0,5,165,72,20,0,66,3,3,10,79,5,5,12,106,8,9,25,115,10,
11,26,46,7,13,31,33,15,16,32,52,9,15,33,111,11,12,35,108,11,13,36,49,6,14,37,34,19,20,39,31,13,13,40,33,14,20,41,94,11,14,42,110,14,14,45,95,11,16,46,30,12,19,48,19,10,15,50,113,15,17,71,104,16,19,77,
165,72,18,0,103,16,19,19,102,13,15,20,35,8,17,21,21,8,13,25,26,8,14,26,95,11,13,27,105,12,13,33,103,11,12,35,33,5,11,37,30,8,9,45,31,7,9,47,99,7,7,63,55,2,2,64,59,11,11,65,108,70,70,67,164,131,131,70,
168,137,137,71,102,74,74,156,165,7,6,0,16,25,25,1,96,79,79,2,144,123,123,4,150,130,130,5,101,83,83,6,0,0,0,170,165,10,7,0,20,61,61,1,52,94,94,2,103,83,83,3,137,127,127,5,149,141,141,8,128,125,125,9,
53,48,48,4,166,72,20,0,51,3,3,1,72,5,5,12,86,6,6,14,111,8,9,26,115,10,11,28,33,12,14,32,32,14,15,33,52,9,15,34,112,11,12,36,115,11,13,37,59,8,14,38,34,19,21,41,33,14,20,42,94,11,14,43,110,14,14,46,
103,13,15,47,39,8,16,49,24,12,16,51,109,15,16,71,104,16,18,76,166,73,19,0,104,16,18,20,106,14,14,22,19,9,13,26,26,8,14,27,95,11,13,28,106,12,13,34,101,11,11,36,40,4,11,37,34,13,17,46,30,7,9,48,99,7,7,
65,48,0,0,66,144,109,109,67,170,134,134,68,150,116,116,69,97,66,66,70,164,132,132,71,174,142,142,72,108,80,80,157,166,7,6,0,14,3,3,1,101,79,79,2,145,125,125,4,143,124,124,5,61,46,46,6,0,0,0,172,166,9,
5,0,12,57,57,2,105,90,90,4,142,134,134,7,122,116,116,8,64,53,53,4,167,72,20,0,61,4,4,13,92,7,6,15,114,9,9,26,116,11,10,27,94,7,11,28,30,9,14,32,32,12,14,33,52,7,14,34,113,11,12,36,114,11,13,37,58,7,
13,38,33,18,19,41,31,11,17,42,95,11,14,46,113,14,14,48,26,15,20,50,26,8,15,51,95,13,17,52,108,14,16,71,103,15,18,76,167,73,19,0,104,15,18,20,108,14,14,21,82,11,15,22,18,9,13,26,27,7,15,27,96,11,13,28,
106,11,13,34,105,11,11,37,29,10,13,46,29,7,9,48,106,9,8,64,49,1,1,65,85,42,42,66,154,117,117,67,173,137,137,69,68,37,37,70,171,138,138,71,174,142,142,72,109,79,79,158,167,6,5,0,11,1,1,1,101,82,82,2,
141,122,122,4,148,129,129,5,64,48,48,174,167,7,4,0,2,0,0,2,127,119,119,4,140,132,132,6,111,97,95,4,168,36,10,0,74,4,4,14,94,6,7,16,118,9,9,26,115,11,10,27,102,9,11,28,41,7,11,32,34,11,14,33,54,7,13,
34,113,11,11,35,107,11,12,40,168,36,13,0,115,11,12,1,58,7,13,2,34,18,20,5,26,6,12,6,96,11,14,7,110,13,14,10,110,14,14,11,86,11,15,12,30,10,18,14,26,9,15,15,97,12,17,16,108,14,16,35,104,15,18,76,168,
36,8,0,104,15,18,20,108,14,14,21,80,11,15,22,20,9,14,26,34,6,16,27,97,11,13,28,106,11,13,35,97,10,9,112,168,37,13,0,61,5,9,1,26,7,12,7,43,19,19,10,29,7,9,12,109,8,8,28,49,3,3,30,170,134,134,31,157,
122,122,32,52,22,22,33,72,40,40,34,171,140,140,35,175,144,144,36,110,82,82,159,168,5,4,0,32,16,16,1,128,108,108,3,163,146,146,4,143,125,126,175,168,6,5,0,3,0,0,1,25,22,22,2,109,102,102,3,136,128,128,
5,128,121,121,3,169,73,18,0,64,4,4,16,98,6,7,18,120,9,9,28,120,11,10,30,36,16,17,33,32,9,13,34,53,5,13,35,114,11,11,37,115,12,12,39,29,13,15,42,27,6,13,43,95,11,14,44,110,12,13,48,112,13,14,49,52,8,
15,51,27,11,16,53,109,13,15,72,104,14,17,76,169,36,7,0,104,14,17,20,108,14,14,21,80,10,15,22,19,8,13,25,26,16,18,27,107,11,13,35,93,8,9,112,169,37,15,0,66,5,8,1,33,6,13,7,45,20,20,10,29,7,8,12,108,8,
8,27,52,0,0,28,63,13,13,29,149,111,111,30,170,133,133,31,138,103,103,32,16,0,0,33,90,59,59,34,174,148,148,35,174,148,148,36,109,81,81,159,169,5,5,0,6,0,0,1,55,40,40,2,142,123,123,3,146,127,129,4,113,
92,98,177,169,4,3,0,56,50,50,1,128,121,121,3,127,122,122,2,170,74,20,0,54,3,3,1,78,5,5,9,97,7,7,29,116,10,9,30,58,3,9,31,35,14,16,34,29,7,12,35,52,5,13,36,115,12,11,38,116,12,12,39,58,6,12,40,29,13,
14,43,32,6,15,44,97,11,13,49,112,14,14,50,86,10,14,51,27,12,18,53,47,7,14,54,113,14,15,73,104,14,17,76,170,37,9,0,104,14,16,20,107,13,13,21,80,10,14,22,18,7,12,23,34,18,19,25,19,10,12,27,109,12,12,34,
106,10,11,36,85,7,8,113,170,37,12,0,45,6,11,9,28,6,8,11,108,9,8,26,48,0,0,28,160,124,124,29,172,135,135,31,24,2,2,32,58,26,26,33,148,123,123,34,179,162,162,35,116,87,87,36,21,3,3,177,170,4,3,0,9,4,4,
1,105,98,98,3,134,127,127,2,171,35,7,0,64,4,4,10,102,7,7,20,98,7,7,22,120,9,9,29,113,9,9,31,35,11,11,34,30,6,11,37,171,36,15,0,50,4,13,1,115,12,11,3,115,12,11,4,58,6,12,5,30,12,14,7,32,15,18,9,113,12,
13,14,110,13,14,15,97,12,14,16,40,8,16,17,30,17,19,18,41,8,16,19,100,12,14,20,106,13,14,35,105,14,16,73,171,71,17,0,104,14,16,23,108,12,13,24,80,10,14,25,18,6,11,26,34,18,19,28,18,8,11,30,110,12,12,
38,106,10,11,41,28,9,11,46,42,17,17,49,27,5,7,51,109,8,9,66,49,0,0,67,131,92,92,68,168,132,132,69,140,102,102,70,45,14,14,145,171,5,5,0,18,0,0,1,121,92,92,2,177,157,157,3,164,138,138,4,60,34,34,164,
171,5,4,0,113,93,96,1,106,86,89,2,139,123,123,4,111,89,100,178,171,2,2,0,48,43,43,1,132,124,124,2,172,70,19,0,62,4,4,12,108,8,8,21,98,6,6,23,116,9,9,30,107,9,10,31,36,5,9,34,30,5,11,36,115,11,11,38,
116,12,11,39,58,6,11,40,30,13,14,41,45,22,22,42,31,14,16,44,115,11,13,50,116,13,13,51,54,7,14,53,25,11,15,55,112,14,14,69,105,14,16,72,172,71,16,0,105,14,16,24,108,13,13,25,80,10,14,26,18,6,10,27,33,
16,18,29,21,11,13,31,109,12,12,39,105,10,11,42,29,8,13,50,26,5,7,52,108,8,9,66,53,1,1,67,76,28,28,68,151,114,114,69,170,135,135,70,113,75,75,146,172,4,4,0,121,92,92,1,173,145,145,2,161,132,132,3,62,
35,35,164,172,5,4,0,103,88,88,1,154,138,138,3,142,127,127,4,106,89,95,2,173,70,18,0,61,3,3,13,113,8,8,22,97,7,7,29,110,9,9,30,104,8,10,31,40,6,10,34,32,6,11,35,102,9,12,38,117,12,11,39,59,5,12,40,31,
11,15,42,31,14,16,44,115,11,12,50,110,12,13,52,33,11,17,53,31,16,19,55,112,14,14,69,105,13,15,72,173,71,16,0,105,13,15,24,108,12,13,25,80,9,13,26,19,7,12,27,34,18,19,29,21,10,13,31,104,11,11,39,106,
10,10,41,73,5,7,42,33,9,13,50,26,4,6,52,108,8,8,66,51,0,0,68,151,115,115,69,162,126,126,70,77,36,36,146,173,4,4,0,121,92,92,1,166,135,135,2,159,128,128,3,60,35,35,164,173,5,5,0,11,4,4,1,93,79,79,2,
141,126,128,3,150,137,136,4,81,64,64,2,174,70,19,0,61,3,3,14,116,8,8,24,99,7,7,30,115,9,9,32,34,12,14,34,37,10,15,35,99,8,11,36,114,11,11,38,116,12,11,39,60,5,12,40,33,10,17,42,30,12,15,44,115,11,12,
51,103,11,13,52,31,6,14,53,31,14,17,54,41,6,14,55,106,13,14,69,105,13,15,72,174,71,17,0,105,13,15,24,108,11,13,25,80,9,13,26,20,6,13,29,22,7,15,31,104,11,11,39,102,9,9,40,99,9,9,42,30,6,13,45,42,20,
20,50,26,4,6,52,107,8,8,65,53,0,0,67,125,86,86,68,140,104,104,69,137,102,102,70,42,0,0,146,174,3,2,0,122,95,95,2,139,109,109,165,174,4,3,0,49,37,37,2,150,136,136,3,83,64,66,177,174,3,3,0,74,70,70,1,
72,66,66,2,115,108,108,2,175,69,18,0,64,4,4,15,119,8,8,30,115,10,9,32,32,9,11,34,36,10,14,35,98,8,10,36,114,11,11,38,117,11,11,39,60,5,12,40,32,11,17,41,44,19,19,42,25,6,12,44,115,12,12,51,111,12,13,
53,22,12,14,54,42,11,17,55,108,11,12,68,105,13,14,71,175,70,15,0,105,13,14,25,108,11,13,26,81,9,13,27,21,5,14,30,26,8,15,32,103,11,11,40,101,9,9,42,73,7,6,43,35,4,10,51,26,4,6,53,103,8,7,66,53,4,4,67,
120,80,80,68,162,128,128,69,147,112,112,166,175,5,4,0,58,45,47,1,127,114,113,2,108,92,96,4,112,94,94,177,175,4,3,0,50,42,42,1,136,129,129,3,130,126,126,2,176,69,20,0,50,3,3,1,71,5,5,7,97,7,7,17,120,8,
8,30,110,9,9,31,104,8,9,32,47,7,12,34,37,8,13,35,99,8,10,38,116,11,11,40,35,12,18,42,33,4,10,43,94,10,12,44,111,11,11,51,110,11,13,52,97,10,13,53,37,9,14,54,30,9,15,56,111,13,13,68,105,13,14,71,176,
70,15,0,105,13,14,25,108,12,12,26,78,9,13,27,19,5,14,30,35,7,13,31,96,9,11,40,100,9,9,42,88,8,7,44,27,9,10,51,26,4,6,53,101,7,7,65,55,0,0,66,84,35,35,67,151,118,118,69,134,99,99,168,176,4,4,0,125,113,
113,1,144,133,132,2,111,91,91,3,111,93,93,176,176,5,4,0,70,63,64,2,153,146,146,3,150,144,144,4,107,102,102,2,177,69,16,0,52,2,2,5,88,6,6,17,121,8,8,31,113,9,9,32,48,4,10,34,38,9,14,35,100,7,10,38,116,
11,11,40,38,12,18,42,41,7,12,43,111,11,12,52,112,11,13,53,43,6,13,54,24,13,16,56,114,12,13,68,105,13,14,71,177,70,16,0,105,13,14,25,106,12,12,26,92,9,12,27,33,6,13,29,26,13,13,30,35,5,11,31,100,10,10,
41,101,9,9,42,91,8,7,44,26,7,10,51,25,4,6,53,101,7,7,65,50,0,0,66,133,95,95,67,154,123,123,69,116,81,81,168,177,5,3,0,114,96,102,2,139,129,128,4,135,124,124,175,177,5,2,0,111,102,104,4,131,125,125,1,
178,70,17,0,36,0,0,1,62,3,3,16,120,8,8,32,112,9,9,34,37,13,14,35,37,9,14,36,100,7,10,37,115,10,10,39,114,11,10,40,93,7,10,41,40,11,17,43,42,9,15,44,106,10,11,53,111,11,12,55,20,6,14,57,109,11,13,69,
105,12,13,71,178,70,15,0,105,12,13,26,113,11,11,27,54,8,13,29,25,11,11,30,34,5,11,31,99,9,10,41,100,9,9,44,28,5,10,51,25,4,6,53,100,7,7,64,54,1,1,65,91,45,45,66,156,124,124,68,144,112,112,69,78,38,38,
168,178,5,3,0,115,92,105,3,128,115,118,4,107,91,100,176,178,3,3,0,114,98,112,1,70,53,60,2,77,63,69,1,179,70,19,0,48,1,1,18,120,8,8,32,113,10,9,33,92,7,9,34,33,9,12,35,36,8,11,36,100,7,10,39,113,10,10,
40,103,8,10,41,38,11,16,43,57,9,15,44,105,8,10,53,109,11,12,54,106,10,12,55,47,7,14,56,26,9,15,57,97,9,12,58,110,11,13,69,106,12,13,71,179,70,17,0,106,12,13,25,106,12,11,26,89,9,11,27,31,7,14,29,25,
12,12,30,34,4,11,31,99,9,10,41,100,9,9,43,81,6,7,44,36,6,10,45,26,7,7,51,24,4,6,53,100,7,7,64,53,0,0,66,154,124,124,68,153,122,122,69,70,30,30,1,180,70,17,0,54,2,2,20,119,8,8,32,111,9,9,33,101,8,10,
34,45,8,9,35,32,8,11,36,98,7,10,37,116,9,10,40,104,8,10,41,40,10,15,43,40,3,13,44,108,10,11,54,115,12,11,56,24,5,13,57,89,9,13,58,110,11,12,69,106,12,13,71,180,70,15,0,106,12,13,25,108,12,11,27,20,5,
14,30,34,4,11,31,99,9,10,41,100,9,9,43,78,7,7,44,32,4,11,51,27,6,8,53,94,7,7,64,63,7,7,65,142,109,109,67,158,129,129,68,112,77,77,69,34,0,0,173,180,1,2,0,81,65,73,0,81,65,73,0,181,70,17,0,41,2,2,16,
114,7,7,34,117,9,9,35,61,7,10,36,59,10,11,37,113,9,9,41,104,7,10,42,40,10,15,43,30,8,10,44,50,4,11,45,111,10,11,55,110,11,11,56,94,9,11,57,24,3,14,58,54,6,13,59,113,11,12,69,107,11,13,70,181,70,15,0,
106,11,13,26,108,11,11,28,20,5,15,31,34,4,11,32,99,9,9,43,96,9,9,46,25,4,8,49,38,17,17,53,28,1,8,54,86,7,7,55,93,7,7,65,59,3,3,67,155,126,126,68,159,131,131,69,97,61,61,172,181,3,2,0,101,83,93,2,115,
97,109,0,182,70,16,0,51,2,2,19,117,8,8,34,116,9,9,35,53,5,10,36,60,8,10,37,113,9,9,40,113,9,9,41,104,7,9,42,42,11,16,43,29,9,12,45,115,11,10,56,112,12,11,57,55,6,12,58,43,5,13,59,110,11,11,69,107,11,
12,70,182,70,19,0,107,11,12,26,104,10,11,27,95,8,10,28,39,7,14,30,27,10,13,31,35,3,12,32,98,9,9,42,99,9,9,45,66,5,9,46,23,5,8,53,31,1,8,54,87,7,7,55,92,7,7,64,67,8,8,65,69,17,17,66,141,111,111,67,160,
132,132,68,150,122,122,69,55,10,10,171,182,4,3,0,102,83,93,2,122,103,116,3,111,95,105,0,183,70,15,0,51,2,2,17,113,8,8,34,113,9,9,36,30,5,9,37,95,8,10,40,113,9,9,41,104,7,8,42,43,12,17,43,29,10,12,45,
115,10,10,56,115,12,11,58,19,3,13,59,86,9,12,60,113,11,11,69,108,11,12,70,183,70,17,0,107,11,12,27,104,9,8,28,50,7,13,30,27,10,13,31,45,3,11,32,99,9,9,43,100,9,9,44,92,8,8,46,24,3,10,53,29,1,9,54,87,
7,7,55,92,7,7,64,61,3,3,66,158,132,132,67,159,132,132,68,121,89,89,69,53,12,12,148,183,3,3,0,89,61,61,1,143,118,118,2,45,25,25,171,183,4,2,0,120,102,114,3,100,85,96,0,184,69,15,0,51,2,2,18,114,8,8,34,
110,9,9,35,106,9,9,36,34,3,11,37,94,8,9,40,113,9,9,41,104,7,8,42,41,11,15,43,27,9,10,45,115,10,10,57,106,10,11,58,31,4,13,60,114,12,11,68,107,11,11,69,184,70,17,0,107,11,11,28,101,9,8,29,48,7,13,31,
26,10,14,33,101,9,9,44,100,8,9,46,78,6,6,48,23,5,6,50,39,19,19,54,28,2,7,55,86,7,7,56,92,7,7,64,69,9,9,65,75,20,20,66,142,114,114,68,168,144,144,69,92,55,55,147,184,4,3,0,131,104,105,2,145,123,123,3,
76,55,55,171,184,3,2,0,109,91,103,2,89,76,85,0,185,69,16,0,51,2,2,15,108,7,7,24,113,8,8,34,109,8,9,35,102,9,9,36,39,3,11,37,94,8,9,40,113,9,9,41,104,7,9,42,41,10,14,43,28,7,11,45,115,10,9,57,114,10,
11,59,41,4,13,60,109,10,11,68,109,11,11,69,185,70,17,0,108,11,11,28,102,9,8,29,48,7,13,31,26,11,14,32,78,7,9,33,101,10,9,44,99,7,8,46,80,6,6,48,22,6,6,54,27,3,7,55,86,7,8,56,92,7,7,64,70,11,11,66,98,
56,56,67,161,135,135,68,149,123,123,69,78,35,35,147,185,4,4,0,77,46,48,1,135,112,112,2,123,101,101,3,30,18,18,0,186,69,15,0,51,2,2,19,113,8,8,35,113,8,9,36,71,6,10,38,110,9,9,40,112,9,9,41,104,7,9,42,
41,10,14,43,29,6,13,45,115,10,9,57,114,10,11,58,90,8,12,59,33,3,13,60,109,10,11,68,109,11,11,69,186,70,17,0,109,11,11,28,102,9,8,29,48,7,13,30,25,13,13,31,26,11,14,33,101,10,9,44,96,7,7,46,81,6,6,48,
23,4,8,54,27,3,7,55,86,6,8,56,91,7,7,64,71,11,11,65,71,29,29,67,168,149,149,68,139,118,118,69,77,35,35,147,186,4,4,0,56,27,27,1,113,91,91,2,117,97,97,3,0,0,0,0,187,69,14,0,51,2,2,18,111,8,8,35,112,9,
9,37,82,6,10,38,109,9,9,40,111,9,9,41,106,9,9,42,32,4,11,43,49,4,11,44,111,9,9,58,111,11,10,59,45,5,12,61,116,11,10,68,109,10,11,69,187,70,18,0,109,10,11,28,102,9,9,29,46,5,10,30,20,8,8,31,27,12,15,
33,102,10,9,45,96,7,7,47,66,5,7,48,24,4,8,54,26,3,7,55,86,6,8,56,91,7,7,64,71,9,9,65,77,38,38,66,143,121,121,67,168,147,147,68,129,103,103,69,39,0,0,147,187,4,4,0,101,73,73,1,162,141,142,2,116,98,98,
3,39,28,33,0,188,69,14,0,48,2,2,18,111,8,8,36,107,8,9,37,62,4,10,38,106,8,9,40,109,9,9,41,107,9,9,42,31,3,11,43,53,4,11,44,115,9,9,58,114,10,10,60,64,6,11,61,115,11,10,68,109,10,11,69,188,70,17,0,109,
10,11,28,102,9,9,29,46,5,10,30,20,8,8,31,27,13,16,33,102,10,9,45,95,7,7,47,70,5,7,48,24,3,9,50,39,21,21,54,26,3,8,55,85,6,8,64,64,7,7,66,144,120,120,67,158,135,135,68,137,113,113,69,57,15,15,147,188,
3,3,0,136,113,113,1,157,138,138,2,117,93,99,156,188,4,3,0,116,92,101,2,110,89,98,3,90,66,73,0,189,69,16,0,48,2,2,18,110,8,8,35,106,8,8,36,102,8,8,37,62,4,10,38,109,8,9,41,103,9,9,42,31,3,11,43,51,4,
11,44,114,9,9,58,111,9,10,59,104,8,10,60,39,4,12,61,101,9,10,62,111,10,10,68,109,10,10,69,189,69,18,0,109,10,11,28,102,9,9,29,46,5,10,30,21,8,8,31,27,13,16,33,101,10,9,45,95,7,7,47,68,5,7,48,24,3,10,
49,23,4,6,54,25,3,8,55,84,6,8,56,88,7,7,64,60,7,7,65,67,36,36,66,128,99,99,67,153,132,132,68,108,81,81,143,189,3,3,0,112,82,92,1,122,100,106,2,97,68,70,147,189,3,2,0,116,95,95,2,119,93,103,155,189,12,
5,0,116,91,103,3,124,101,113,4,93,70,77,6,120,99,110,11,112,93,103,0,190,69,14,0,48,2,2,18,109,8,8,36,105,8,8,37,68,5,10,38,97,7,9,40,106,8,9,41,102,8,9,42,36,3,11,43,51,4,11,44,114,9,9,59,114,10,10,
60,64,5,11,62,114,9,10,68,110,10,10,69,190,69,16,0,110,10,10,28,103,10,9,29,45,4,10,30,23,9,10,31,23,5,12,33,101,9,9,45,94,7,7,47,78,6,6,49,17,4,6,54,26,3,8,55,85,6,8,64,66,6,6,65,73,24,24,66,132,110,
110,67,157,137,137,68,125,102,102,139,190,7,5,0,137,117,117,2,64,33,33,3,107,84,89,4,130,110,112,6,138,117,117,154,190,14,2,0,119,93,104,13,114,95,107,0,191,69,14,0,48,2,2,18,107,8,8,36,111,8,8,38,71,
6,9,39,111,9,8,41,105,8,9,42,46,2,11,43,43,3,11,44,113,9,9,59,116,10,9,60,77,6,11,61,67,6,11,62,114,10,10,68,111,9,10,69,191,69,14,0,111,9,10,28,103,10,9,29,46,4,10,31,21,4,12,33,100,8,9,45,95,7,7,47,
78,6,5,49,31,4,6,52,24,7,8,54,25,4,7,55,84,6,7,56,88,7,7,65,52,0,0,68,98,74,74,139,191,7,3,0,115,89,89,1,158,138,138,6,140,121,121,154,191,15,2,0,116,94,104,14,117,97,110,0,192,68,10,0,48,2,2,17,106,
8,8,36,109,8,8,38,83,6,8,39,109,9,8,41,107,8,8,42,57,4,10,43,66,5,11,44,108,8,9,67,111,9,9,68,192,69,15,0,111,9,10,29,102,10,9,30,46,3,10,31,26,11,16,32,34,7,12,33,85,6,9,34,99,8,9,46,95,7,7,49,62,5,
8,50,25,2,8,52,36,20,20,55,24,4,8,56,81,6,7,57,86,7,7,68,43,0,0,139,192,7,4,0,123,104,104,1,141,121,121,5,128,109,109,6,78,54,54,154,192,14,2,0,115,92,104,13,114,97,107,0,193,137,19,0,48,2,2,17,105,8,
8,38,91,7,8,41,108,8,8,42,66,5,9,44,107,8,9,69,112,9,9,97,102,10,9,98,46,3,10,99,22,10,16,101,102,8,8,114,94,7,7,117,77,6,7,118,28,4,8,119,21,7,7,123,23,4,8,124,80,6,8,125,84,6,6,136,49,6,6,139,193,7,
3,0,54,18,18,5,47,18,18,6,19,0,0,157,193,11,2,0,114,93,104,10,109,94,103,0,194,68,9,0,48,2,2,17,105,8,8,37,108,8,8,38,57,5,10,39,95,7,8,41,108,9,8,42,73,5,9,44,107,8,8,67,112,9,9,68,194,69,13,0,112,9,
9,29,102,9,9,30,47,3,10,31,21,9,14,33,101,8,7,46,94,7,7,49,73,6,6,50,26,3,10,51,20,5,6,55,22,4,8,56,79,6,8,57,83,7,7,68,47,3,3,157,194,9,2,0,114,93,104,8,111,94,105,0,195,137,17,0,48,2,2,17,104,8,8,
37,105,8,8,38,80,6,9,40,104,8,8,70,114,9,9,97,102,9,9,98,44,3,10,99,19,7,13,101,101,8,8,114,93,7,7,117,76,6,6,119,18,4,7,123,22,3,8,124,78,6,8,125,82,7,7,136,47,4,4,158,195,7,2,0,112,94,104,6,112,94,
105,0,196,136,13,0,48,2,2,18,103,8,8,69,114,9,9,97,100,9,8,99,19,7,12,101,101,8,8,115,88,7,7,118,60,5,8,119,16,4,7,123,21,4,8,124,77,6,8,125,81,7,7,135,49,2,2,159,196,5,3,0,112,93,104,1,127,105,118,4,
111,94,105,0,197,135,14,0,47,2,2,18,102,8,8,69,115,9,9,97,98,8,8,98,91,7,8,99,21,7,12,101,101,8,8,115,93,7,7,117,74,6,6,119,15,2,9,123,20,4,7,124,75,6,8,125,79,7,7,134,50,2,2,160,197,3,2,0,117,98,109,
2,109,93,104,1,198,133,15,0,50,4,4,18,101,8,8,70,116,9,9,96,98,8,8,97,87,7,8,98,19,4,11,100,101,8,8,114,91,7,7,117,64,6,7,118,25,2,9,119,18,7,7,122,20,3,7,123,72,5,7,124,77,5,5,132,50,4,4,2,199,131,
14,0,53,4,4,17,99,8,8,72,117,9,9,95,98,8,8,96,88,7,8,97,18,2,11,99,100,8,8,113,89,7,7,116,74,6,6,118,15,6,6,121,19,4,7,122,69,5,7,123,74,5,5,130,52,4,4,3,200,129,13,0,56,4,4,18,98,8,8,68,116,9,9,94,
98,8,8,95,88,7,8,96,19,2,11,98,99,8,8,112,87,7,7,115,69,5,5,117,15,4,7,120,18,3,7,121,70,5,6,128,52,4,4,4,201,127,14,0,57,4,4,16,95,7,7,69,113,8,8,93,98,8,8,94,87,7,8,95,22,2,11,96,82,7,8,97,97,8,8,
111,86,7,7,115,68,5,7,116,17,4,7,119,14,3,6,121,70,5,5,126,51,2,2,5,202,125,14,0,57,4,4,22,99,8,8,68,113,8,8,92,98,8,8,93,87,7,8,94,23,2,11,95,89,7,8,96,96,8,8,110,83,7,7,114,65,6,7,115,15,3,7,118,11,
3,6,120,69,5,5,124,52,4,4,6,203,123,13,0,57,4,4,22,98,8,8,66,113,8,8,91,98,8,8,92,86,7,8,93,22,2,11,94,87,7,8,95,96,8,8,113,66,5,6,114,20,2,9,117,11,2,6,119,67,5,5,122,55,4,4,7,204,121,13,0,59,4,4,24,
98,8,8,67,111,8,8,90,98,8,8,91,86,7,8,92,23,2,11,93,86,7,8,94,96,8,8,112,68,6,5,114,11,5,7,116,10,2,5,118,63,5,5,120,55,4,4,8,205,119,13,0,59,5,5,23,97,8,8,65,111,8,8,89,98,8,8,90,84,7,8,91,18,2,11,
92,86,7,8,93,96,8,8,111,61,6,5,113,10,5,7,115,10,2,5,117,60,5,4,118,52,4,5,9,206,117,11,0,58,4,4,21,95,8,8,62,110,8,8,89,95,8,8,90,54,5,10,92,96,8,8,106,74,6,6,111,58,4,5,112,16,2,7,114,10,3,5,116,57,
4,2,10,207,115,8,0,56,4,4,20,92,7,7,66,108,8,8,105,72,6,6,108,51,5,5,110,62,5,5,111,17,2,5,114,22,2,5,11,208,114,7,0,56,4,4,23,94,7,7,65,107,8,8,105,68,5,5,109,57,5,5,110,14,2,6,113,19,1,4,12,209,113,
8,0,54,4,4,23,93,7,7,65,106,8,8,90,90,7,7,106,46,4,4,108,58,5,5,110,9,4,6,112,17,1,3,13,210,111,7,0,52,4,4,23,91,7,7,63,106,8,8,96,77,6,6,107,53,4,4,109,7,3,5,110,10,4,3,14,211,109,6,0,51,4,4,23,89,7,
7,63,105,8,8,97,71,6,6,106,46,4,3,108,6,2,4,147,211,3,3,0,39,32,36,1,107,92,102,2,124,109,124,15,212,107,5,0,50,4,4,22,87,7,7,60,104,8,8,86,89,7,7,106,37,3,3,146,212,5,5,0,51,44,49,1,72,61,69,2,131,
114,128,3,109,95,107,4,43,17,19,16,213,105,5,0,47,4,4,22,85,7,7,62,103,8,8,84,90,7,7,104,38,3,3,145,213,6,5,0,75,64,72,1,112,97,108,3,126,110,124,4,96,86,96,5,33,0,0,17,214,103,5,0,47,4,4,23,84,7,7,
57,103,8,8,82,89,7,7,102,33,3,3,144,214,7,5,0,74,63,71,1,115,101,113,4,125,111,124,5,104,86,97,6,47,21,21,18,215,101,5,0,46,2,2,39,98,8,8,61,101,8,8,84,82,7,7,100,35,3,3,144,215,6,3,0,113,99,111,4,
123,112,125,5,103,73,81,19,216,99,5,0,43,2,2,31,89,7,7,57,101,8,8,80,85,7,7,98,41,3,3,143,216,7,3,0,107,95,105,5,127,109,122,6,85,56,64,20,217,97,4,0,42,4,4,49,100,8,8,67,97,8,8,96,42,3,3,143,217,7,5,
0,119,104,117,3,122,115,130,4,102,75,84,5,119,30,30,6,31,24,27,21,218,95,4,0,40,3,3,42,99,7,7,64,98,7,7,94,43,3,3,143,218,5,4,0,122,108,121,2,115,105,117,3,137,83,92,4,83,24,26,143,219,4,3,0,79,70,79,
2,68,52,59,3,90,8,6,
]]

	local decor = new("Frame", {
		Name = "Decor",
		BackgroundTransparency = 1,
		ZIndex = 50,
		Visible = false,
		Parent = screenGui,
	})
	decor:SetAttribute("KeepColor", true)
	local decorScale = new("UIScale", { Parent = decor })
	local pixels = nil -- создаются при первом включении
	local appliedTransparency = nil

	local function buildPixels()
		pixels = {}
		local numbers = {}
		for value in DECOR_ROWS:gmatch("%d+") do
			numbers[#numbers + 1] = tonumber(value)
		end
		local i = 1
		while i <= #numbers - 3 do
			local x, y, length, count = numbers[i], numbers[i + 1], numbers[i + 2], numbers[i + 3]
			i += 4
			-- опорные цвета полоски → плавный градиент слева направо
			local keypoints = {}
			for k = 1, count do
				local index, r, g, b = numbers[i], numbers[i + 1], numbers[i + 2], numbers[i + 3]
				i += 4
				local time = length > 1 and index / (length - 1) or (k - 1)
				keypoints[k] = ColorSequenceKeypoint.new(math.clamp(time, 0, 1), Color3.fromRGB(r, g, b))
			end
			if #keypoints == 1 then
				keypoints[2] = ColorSequenceKeypoint.new(1, keypoints[1].Value)
			end
			keypoints[1] = ColorSequenceKeypoint.new(0, keypoints[1].Value)
			keypoints[#keypoints] = ColorSequenceKeypoint.new(1, keypoints[#keypoints].Value)

			-- положение и размер в долях картинки: при изменении размера всё масштабируется само;
			-- +1 пиксель перекрытия по высоте, чтобы между строками не было щелей
			local strip = Instance.new("Frame")
			strip.Position = UDim2.fromScale(x / DECOR_W, y / DECOR_H)
			strip.Size = UDim2.new(length / DECOR_W, 0, 1 / DECOR_H, 1)
			strip.BackgroundColor3 = Color3.new(1, 1, 1)
			strip.BorderSizePixel = 0
			strip.ZIndex = 50
			strip:SetAttribute("KeepColor", true)
			local gradient = Instance.new("UIGradient")
			gradient.Color = ColorSequence.new(keypoints)
			gradient.Parent = strip
			strip.Parent = decor
			pixels[#pixels + 1] = strip
		end
	end

	RunService.RenderStepped:Connect(function()
		local visible = MENU_STYLE.Decor and screenGui.Enabled and frame.Visible
		decor.Visible = visible
		if not visible then
			return
		end
		if not pixels then
			buildPixels()
		end

		-- слой: поверх окна меню или позади него (окно и картинка — соседи в одном ScreenGui)
		decor.ZIndex = MENU_STYLE.DecorLayer == "За меню" and 0 or 50

		local transparency = math.clamp(MENU_STYLE.DecorTransparency, 0, 0.95)
		if transparency ~= appliedTransparency then
			appliedTransparency = transparency
			for _, pixel in ipairs(pixels) do
				pixel.BackgroundTransparency = transparency
			end
		end

		local scale = windowScale.Scale
		decorScale.Scale = scale
		local height = math.clamp(MENU_STYLE.DecorSize, 40, 600)
		decor.Size = UDim2.fromOffset(height * DECOR_W / DECOR_H, height)

		-- положение относительно окна меню (центр окна — frame.Position)
		local half = WINDOW_SIZE * scale / 2
		local size = height * scale
		local position = MENU_STYLE.DecorPosition
		local offset
		if position == "Сверху слева" then
			decor.AnchorPoint = Vector2.new(0, 1)
			offset = Vector2.new(-half.X + 10 * scale, -half.Y + size * 0.25)
		elseif position == "Слева от меню" then
			decor.AnchorPoint = Vector2.new(1, 0.5)
			offset = Vector2.new(-half.X - 8 * scale, 0)
		elseif position == "Снизу справа" then
			decor.AnchorPoint = Vector2.new(1, 0)
			offset = Vector2.new(half.X - 10 * scale, half.Y - size * 0.25)
		else -- «Сверху справа»: картинка выглядывает из-за верхнего правого угла окна
			decor.AnchorPoint = Vector2.new(1, 1)
			offset = Vector2.new(half.X - 10 * scale, -half.Y + size * 0.25)
		end
		decor.Position = frame.Position + UDim2.fromOffset(offset.X, offset.Y)
	end)
end

local openMenu, closeMenu
do
	local SHARD_COLUMNS = 2 -- окно раскалывается на две половины: левую и правую
	local SHARD_ROWS = 1
	local CRACK_TIME = 0.12     -- сколько длится «трескание» перед разлётом
	local CRACK_GAP = 5         -- ширина трещин, пикселей
	local FLY_TIME = 0.6        -- сколько осколки летят
	local MAX_DELAY = 0.07      -- осколки срываются не одновременно
	local SHARD_GRAVITY = 900
	local OPEN_TIME = 0.6
	local TOTAL_TIME = MAX_DELAY + CRACK_TIME + FLY_TIME

	-- слой для осколков: стоит ровно там же, где окно, и масштабируется так же
	local shardLayer = new("Frame", {
		Name = "ShardLayer",
		AnchorPoint = Vector2.new(0.5, 0.5),
		Size = UDim2.fromOffset(WINDOW_SIZE.X, WINDOW_SIZE.Y),
		BackgroundTransparency = 1,
		Visible = false,
		ZIndex = 5,
		Parent = screenGui,
	})
	local shardScale = new("UIScale", { Parent = shardLayer })

	local shardPieces = {}
	local shardConnection = nil

	local function clearShards()
		if shardConnection then
			shardConnection:Disconnect()
			shardConnection = nil
		end
		for _, piece in ipairs(shardPieces) do
			piece.shard:Destroy()
		end
		table.clear(shardPieces)
		shardLayer.Visible = false
	end

	-- «Снимок» окна: копия того, что сейчас видно (скрытые страницы выкидываем, чтобы было легко)
	local function makeSnapshot()
		local snapshot = Instance.new("Frame")
		snapshot.Size = UDim2.fromOffset(WINDOW_SIZE.X, WINDOW_SIZE.Y)
		snapshot.BackgroundTransparency = 1
		snapshot.BorderSizePixel = 0

		for _, child in ipairs(frame:GetChildren()) do
			if not child:IsA("UIScale") then
				local ok, copy = pcall(function()
					return child:Clone()
				end)
				if ok and copy then
					copy.Parent = snapshot
				end
			end
		end

		for _, descendant in ipairs(snapshot:GetDescendants()) do
			if descendant.Parent and descendant:IsA("GuiObject") and not descendant.Visible then
				descendant:Destroy()
			end
		end
		return snapshot
	end

	local function randomCuts(count, jitter)
		local cuts = { 0 }
		for i = 1, count - 1 do
			table.insert(cuts, (i + (math.random() - 0.5) * jitter) / count)
		end
		table.insert(cuts, 1)
		return cuts
	end

	-- Режем снимок на осколки. У каждого ряда свои разрезы (как кирпичная кладка),
	-- поэтому трещины идут неровно, а не ровной сеткой.
	local function createShards()
		clearShards()
		shardLayer.Position = frame.Position
		shardScale.Scale = windowScale.Scale
		shardLayer.Visible = true

		local snapshot = makeSnapshot()
		local center = WINDOW_SIZE / 2
		local yCuts = randomCuts(SHARD_ROWS, 0.35)
		local total = SHARD_COLUMNS * SHARD_ROWS

		for row = 1, SHARD_ROWS do
			local xCuts = randomCuts(SHARD_COLUMNS, 0.25)
			for column = 1, SHARD_COLUMNS do
				local x0 = math.floor(xCuts[column] * WINDOW_SIZE.X)
				local x1 = math.floor(xCuts[column + 1] * WINDOW_SIZE.X)
				local y0 = math.floor(yCuts[row] * WINDOW_SIZE.Y)
				local y1 = math.floor(yCuts[row + 1] * WINDOW_SIZE.Y)
				local pieceSize = Vector2.new(x1 - x0, y1 - y0)
				local home = Vector2.new(x0, y0) + pieceSize / 2

				local shard = Instance.new("CanvasGroup")
				shard.AnchorPoint = Vector2.new(0.5, 0.5)
				shard.Position = UDim2.fromOffset(home.X, home.Y)
				shard.Size = UDim2.fromOffset(pieceSize.X, pieceSize.Y)
				shard.BackgroundTransparency = 1
				shard.Parent = shardLayer

				local copy = (#shardPieces == total - 1) and snapshot or snapshot:Clone()
				copy.Position = UDim2.fromOffset(-x0, -y0)
				copy.Parent = shard

				-- светящийся край осколка (как красные края трещин в примере)
				local edge = Instance.new("UIStroke")
				edge.Color = C.accent
				edge.Thickness = 1.5
				edge.Transparency = 1
				edge.Parent = shard

				local depth = Instance.new("UIScale")
				depth.Parent = shard

				local direction = home - center
				direction = direction.Magnitude > 1 and direction.Unit or Vector2.new(0, -1)

				table.insert(shardPieces, {
					shard = shard,
					edge = edge,
					depth = depth,
					home = home,
					direction = direction,
					crackRotation = (math.random() - 0.5) * 5,
					velocity = direction * (260 + math.random() * 80)
						+ Vector2.new(0, -40 - math.random() * 60),
					spin = (direction.X < 0 and -1 or 1) * (25 + math.random() * 20), -- каждая половина заваливается наружу
					farScale = 0.3 + math.random() * 0.25, -- насколько «вглубь» улетает осколок
					delay = math.random() * MAX_DELAY,
				})
			end
		end
	end

	-- Положение осколка через tau секунд после начала разрушения
	local function applyShard(piece, tau)
		local t = math.max(0, tau - piece.delay)
		local crack = math.clamp(t / CRACK_TIME, 0, 1)
		local fly = math.max(0, t - CRACK_TIME)
		local flyProgress = math.clamp(fly / FLY_TIME, 0, 1)

		local offset = piece.direction * CRACK_GAP * crack
			+ piece.velocity * fly
			+ Vector2.new(0, 0.5 * SHARD_GRAVITY * fly * fly)
		local position = piece.home + offset

		piece.shard.Position = UDim2.fromOffset(position.X, position.Y)
		piece.shard.Rotation = piece.crackRotation * crack + piece.spin * fly
		piece.depth.Scale = 1 - (1 - piece.farScale) * flyProgress
		piece.edge.Transparency = 1 - 0.75 * crack
		piece.shard.GroupTransparency = math.clamp((flyProgress - 0.35) / 0.65, 0, 1)
	end

	function openMenu()
		animationId += 1
		local myId = animationId
		menuOpen = true
		menuIsOpen = true
		updateMenuBlur()

		windowScale.Scale = getFitScale()
		clampWindow()
		frame.Visible = false
		screenGui.Enabled = true

		createShards()
		for _, piece in ipairs(shardPieces) do
			applyShard(piece, TOTAL_TIME) -- осколки стартуют разлетевшимися
		end

		local started = os.clock()
		shardConnection = RunService.RenderStepped:Connect(function()
			local u = math.clamp((os.clock() - started) / OPEN_TIME, 0, 1)
			local tau = TOTAL_TIME * (1 - u) ^ 2 -- прилетают быстро и мягко «встают» на место
			for _, piece in ipairs(shardPieces) do
				applyShard(piece, tau)
			end
			if u >= 1 then
				clearShards()
				if animationId == myId then
					frame.Visible = true
				end
			end
		end)
	end

	function closeMenu()
		animationId += 1
		local myId = animationId
		menuOpen = false
		menuIsOpen = false
		updateMenuBlur()

		createShards()
		frame.Visible = false -- настоящее окно прячем в тот же кадр, осколки выглядят точно так же

		local started = os.clock()
		shardConnection = RunService.RenderStepped:Connect(function()
			local tau = os.clock() - started
			for _, piece in ipairs(shardPieces) do
				applyShard(piece, tau)
			end
			if tau >= TOTAL_TIME then
				clearShards()
				if animationId == myId then
					screenGui.Enabled = false
					frame.Visible = true
				end
			end
		end)
	end
end

--------------------------------------------------------------------
-- Заставка при запуске скрипта: размытие, логотип, название, полоса загрузки
--------------------------------------------------------------------
local introPlaying = false

local function tween(object, time, props, style, direction)
	local t = TweenService:Create(
		object,
		TweenInfo.new(time, style or Enum.EasingStyle.Quad, direction or Enum.EasingDirection.Out),
		props
	)
	t:Play()
	return t
end

local function playIntro()
	introPlaying = true

	local introGui = new("ScreenGui", {
		Name = "JustVisuals_Intro",
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling, -- знак логотипа всегда поверх своего квадрата
		IgnoreGuiInset = true,
		ResetOnSpawn = false,
		DisplayOrder = 200,
		Parent = playerGui,
	})

	local holder = new("CanvasGroup", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(320, 100),
		BackgroundTransparency = 1,
		Parent = introGui,
	})

	local LOGO_SHIFT = -86 -- насколько логотип отъезжает влево, освобождая место названию
	local ROW_Y = 50       -- строка «логотип + название» ровно по центру экрана

	local logo = new("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0, ROW_Y),
		Size = UDim2.fromOffset(64, 64),
		BackgroundColor3 = LOGO_BG,
		BorderSizePixel = 0,
		Rotation = -90,
		ZIndex = 2, -- поверх названия: при уходе текст прячется за логотип
		Parent = holder,
	})
	round(logo, 14)
	new("UIStroke", { Color = C.accent, Transparency = 0.4, Thickness = 2, Parent = logo })
	local logoScale = new("UIScale", { Scale = 0, Parent = logo })
	drawLogoMark(logo, 64)

	-- название в стиле шапки меню: жирное OPUS и тонкое client; стоит справа от будущего места логотипа
	local subHex = string.format("#%02X%02X%02X",
		math.floor(C.sub.R * 255 + 0.5), math.floor(C.sub.G * 255 + 0.5), math.floor(C.sub.B * 255 + 0.5))
	local TITLE_X = LOGO_SHIFT + 32 + 16 -- правый край логотипа + отступ
	local title = new("TextLabel", {
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0.5, TITLE_X - 26, 0, ROW_Y), -- стартует чуть левее и «выезжает» на место
		Size = UDim2.fromOffset(200, 40),
		BackgroundTransparency = 1,
		Font = Enum.Font.GothamBlack,
		TextSize = 30,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextColor3 = C.text,
		TextTransparency = 1,
		RichText = true,
		Text = 'OPUS <font face="Gotham" weight="Regular" size="24" color="' .. subHex .. '">client</font>',
		Parent = holder,
	})
	-- проявление слева направо: мягкая «шторка» прозрачности едет по тексту
	local titleReveal = new("UIGradient", {
		Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0),
			NumberSequenceKeypoint.new(0.45, 0),
			NumberSequenceKeypoint.new(0.55, 1),
			NumberSequenceKeypoint.new(1, 1),
		}),
		Offset = Vector2.new(-1, 0),
		Parent = title,
	})

	-- 1. логотип выпрыгивает с поворотом
	tween(logoScale, 0.55, { Scale = 1 }, Enum.EasingStyle.Back)
	tween(logo, 0.55, { Rotation = 0 }, Enum.EasingStyle.Back)
	task.wait(0.45)

	-- 2. логотип отъезжает влево, а справа проявляется и «выезжает» название
	task.wait(0.15)
	tween(logo, 0.6, { Position = UDim2.new(0.5, LOGO_SHIFT, 0, ROW_Y) }, Enum.EasingStyle.Quint)
	title.TextTransparency = 0
	tween(title, 0.6, { Position = UDim2.new(0.5, TITLE_X, 0, ROW_Y) }, Enum.EasingStyle.Quint)
	tween(titleReveal, 0.65, { Offset = Vector2.new(1, 0) }, Enum.EasingStyle.Quad)
	task.wait(0.7)

	-- 3. короткая пауза со звуком
	playToggleSound(true)
	task.wait(0.55)

	-- 4. название «уезжает» обратно за логотип (тает справа налево), логотип возвращается в центр
	local retract = TweenInfo.new(0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
	TweenService:Create(title, retract, { Position = UDim2.new(0.5, LOGO_SHIFT - 20, 0, ROW_Y) }):Play()
	TweenService:Create(titleReveal, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
		Offset = Vector2.new(-1, 0),
	}):Play()
	tween(logo, 0.5, { Position = UDim2.new(0.5, 0, 0, ROW_Y) }, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut)
	task.wait(0.5)

	-- 5. логотип сжимается и исчезает — и только после этого появляется меню
	local shrink = tween(logoScale, 0.3, { Scale = 0 }, Enum.EasingStyle.Back, Enum.EasingDirection.In)
	tween(logo, 0.3, { Rotation = 90 }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
	shrink.Completed:Wait()

	introGui:Destroy()
	introPlaying = false
	openMenu()
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed or introPlaying then
		return
	end
	if input.KeyCode == CONFIG.MenuKey then
		if menuOpen then
			closeMenu()
		else
			openMenu()
		end
	end
end)

-- то же самое по клику на watermark
watermarkClicked.Event:Connect(function()
	if introPlaying then
		return
	end
	if menuOpen then
		closeMenu()
	else
		openMenu()
	end
end)

-- заставка при запуске скрипта, после неё появляется меню
screenGui.Enabled = false
task.spawn(playIntro)