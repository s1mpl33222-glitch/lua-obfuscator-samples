--!strict
--[[
	platform/loader/loader.lua - the Corny loader. Players run one line,
		loadstring(game:HttpGet("https://<project>.web.app/loader"))()
	which downloads this file from our site and runs it. Deployed as /loader on the "site"
	Hosting site by platform/tools/deploy-site.ts (a copy in public/, never edited by hand).

	What it does (platform/PLAN.md section 4): shows a small card in the middle of the screen,
	asks our API which game this is (POST /api/v1/load, PLAN 3.3), downloads that game's full
	Corny script from our cdn site and runs it. In a game we do not support yet it shows the
	invite to our Discord in the Discord app and copies the link.

	Its rules (PLAN 4.3): everything visible is Drawing; it writes no files; it runs no code but
	the script our cdn site serves; its only web requests are our API, our cdn site and, in a game
	we do not support, the Discord app on this computer (127.0.0.1 only). The user approved all of
	them on 2026-10-16 (docs/FEATURE_GUIDE.md section 12, "No remote code").

	Before deploying: put the Firebase addresses in CORNY_SITE and CORNY_CDN (just below).
	The Shared.DiscordInvite region is an exact copy of shared/DiscordInvite.luau's region: copy
	it again when that component changes, never edit it here. It needs Core's try and
	HttpService, defined above it. The invite code always comes from the API's reply, never from
	DiscordInviteConfig.CODE (the old server).

	getgenv keys (shared/REGISTRY.md): CornyLoader (this loader's state for the server: busy,
	relaunched, the card on screen) and CornySession (the session for the usage reporter, only
	while the downloaded script starts). It reads CornyRelaunched (Shared.Relaunch's, never
	cleared here) and CornyMenu (the running menu's toggle key).

	Status: not run in game yet (it can only be tried once the website is deployed).
	Checks: bash lib/tools/check.sh platform/loader/loader.lua, plus a scan for file calls and
	every game's banned names (PLAN 4.3); a separate reviewer pass.
]]

-- ============ Where Corny lives (fill these in before deploying) ============
local CORNY_SITE = "https://corny-a4a48.web.app" -- the "site" Hosting site: pages, loader, API
local CORNY_CDN = "https://corny-a4a48-cdn.web.app" -- the "cdn" Hosting site: game scripts only

-- ============ Services ============
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

-- ============ Core basics (copied from shared/Core.luau; Shared.DiscordInvite needs try) ============
-- pcall with a fixed (ok, result) shape, also for functions that return nothing
local function try(fn: (...any) -> ...any, ...: any): (boolean, any)
	return pcall(fn, ...)
end

-- xpcall with a fixed (ok, result) shape and a traceback on error
local function tryTraced(fn: (...any) -> ...any, ...: any): (boolean, any)
	return xpcall(fn, debug.traceback, ...)
end

--#region Shared.DiscordInvite (keep identical in every feature file, source: shared/DiscordInvite.luau)
-- DiscordInvite: asks the Discord app on this computer to show the invite to a server, so the
-- player joins with Discord's own Join button (it never joins for them). The method: the Discord
-- desktop app answers RPC calls over HTTP on 127.0.0.1, on the first free port of 6463-6472, and
-- a POST to /rpc?v=1 with { cmd = "INVITE_BROWSER", args = { code }, nonce } and the Origin
-- Discord accepts (https://discord.com) brings up its invite window: the way Roblox scripts have
-- long done it, sent with Volt's request (docs/VOLT_API.md request). It tries the ports in turn
-- and stops at the first one where Discord answers; an answer that is not Discord's counts as no
-- Discord there. It sends nothing anywhere but this computer, keeps no state, and copies the
-- link only when asked (DiscordInvite.copy).
-- Needs: Core

local DiscordInviteConfig = table.freeze({
	CODE = "hgC7Z98HXf", -- the user's server (2026-10-09: "My invite is https://discord.gg/hgC7Z98HXf")
	HOST = "http://127.0.0.1", -- the Discord app's RPC server: this computer only
	FIRST_PORT = 6463, -- Discord takes the first free port of 6463-6472 (Discord's RPC docs)
	LAST_PORT = 6472,
	PATH = "/rpc?v=1",
	ORIGIN = "https://discord.com", -- the Origin Discord's RPC server accepts from a browser
	BODY_LOG = 300, -- characters of each answer kept for F9
})

-- What one port gave back (F9 and the Test submenu)
type DiscordInviteTry = {
	port: number,
	answered: boolean, -- the request came back (false: nothing listens there, or it failed)
	status: number?, -- its HTTP status
	body: string?, -- the start of what came back
	problem: string?, -- why the request failed
}

-- One invite: whether Discord brought up its invite window, where, and every port tried
type DiscordInviteResult = {
	opened: boolean,
	port: number?, -- where Discord answered
	problem: string?, -- why it did not open, for F9
	tries: { DiscordInviteTry },
}

-- What a port's answer was: Discord opened the invite, Discord said no, or no Discord there
type DiscordInviteAnswer = "opened" | "refused" | "none"

local DiscordInvite = {}

-- The invite link of a code (the user's server when none is given)
function DiscordInvite.link(code: string?): string
	return `https://discord.gg/{code or DiscordInviteConfig.CODE}`
end

-- The link as players write it (no https://)
function DiscordInvite.shortLink(code: string?): string
	return `discord.gg/{code or DiscordInviteConfig.CODE}`
end

-- Whether this executor can ask Discord (request) and copy text (setclipboard)
function DiscordInvite.supported(): (boolean, boolean)
	return type(request) == "function", type(setclipboard) == "function"
end

-- Sends the invite to one port: what came back, and what it means
function DiscordInvite._ask(
	port: number,
	code: string
): (DiscordInviteTry, DiscordInviteAnswer, string?)
	local seen: DiscordInviteTry = { port = port, answered = false }
	local encoded, body = try(HttpService.JSONEncode, HttpService, {
		cmd = "INVITE_BROWSER",
		args = { code = code },
		nonce = HttpService:GenerateGUID(false),
	})
	if not encoded then
		seen.problem = `the message could not be written: {body}`
		return seen, "none", seen.problem
	end
	local url = `{DiscordInviteConfig.HOST}:{port}{DiscordInviteConfig.PATH}`
	local ok, response = try(function(): any
		return request({ -- allow-web: the Discord invite prompt on this computer, the user's request (2026-10-09)
			Url = url,
			Method = "POST",
			Headers = {
				["Content-Type"] = "application/json",
				Origin = DiscordInviteConfig.ORIGIN,
			},
			Body = body,
		})
	end)
	if not ok or type(response) ~= "table" then
		seen.problem = tostring(response)
		return seen, "none", seen.problem
	end
	seen.answered = true
	seen.status = tonumber(response.StatusCode)
	local text = if type(response.Body) == "string" then response.Body else ""
	seen.body = string.sub(text, 1, DiscordInviteConfig.BODY_LOG)
	local decoded, data = try(HttpService.JSONDecode, HttpService, text)
	if not decoded or type(data) ~= "table" or data.cmd ~= "INVITE_BROWSER" then
		return seen, "none", `HTTP {tostring(seen.status)}, not Discord's answer`
	end
	if data.evt == "ERROR" then
		local detail = if type(data.data) == "table" then data.data.message else nil
		return seen, "refused", tostring(detail or "no reason given")
	end
	return seen, "opened", nil
end

-- Asks the Discord app to show the invite (the user's server when no code is given). Yields
-- until Discord answers or every port was tried: call it on its own thread
function DiscordInvite.open(code: string?): DiscordInviteResult
	local invite = code or DiscordInviteConfig.CODE
	local result: DiscordInviteResult = { opened = false, tries = {} }
	if type(request) ~= "function" then
		result.problem = "this executor has no request function"
		return result
	end
	for port = DiscordInviteConfig.FIRST_PORT, DiscordInviteConfig.LAST_PORT do
		local seen, answer, why = DiscordInvite._ask(port, invite)
		table.insert(result.tries, seen)
		if answer == "opened" then
			result.opened = true
			result.port = port
			return result
		elseif answer == "refused" then
			result.port = port
			result.problem = `Discord said no: {why}`
			return result
		end
	end
	result.problem =
		`no Discord app answered on ports {DiscordInviteConfig.FIRST_PORT}-{DiscordInviteConfig.LAST_PORT}`
	return result
end

-- Copies the invite link to the clipboard; false and why when it could not
function DiscordInvite.copy(code: string?): (boolean, string?)
	if type(setclipboard) ~= "function" then
		return false, "this executor has no setclipboard function"
	end
	local ok, err = try(setclipboard, DiscordInvite.link(code))
	if not ok then
		return false, tostring(err)
	end
	return true, nil
end

-- One line per port tried, for F9
function DiscordInvite.describe(result: DiscordInviteResult): string
	local lines = {
		if result.opened
			then `Discord opened the invite (port {result.port})`
			else `the invite did not open: {result.problem or "unknown"}`,
	}
	for _, seen in result.tries do
		if seen.answered then
			table.insert(
				lines,
				`  port {seen.port}: HTTP {tostring(seen.status)} {seen.body or ""}`
			)
		else
			table.insert(lines, `  port {seen.port}: no answer ({seen.problem or "unknown"})`)
		end
	end
	return table.concat(lines, "\n")
end
--#endregion Shared.DiscordInvite

-- ============ Loader config ============
local LoaderConfig = table.freeze({
	VERSION = 1, -- this loader's version, sent as "v" (the API counts loader versions)
	PLACEHOLDER = "YOUR-PROJECT", -- in CORNY_SITE / CORNY_CDN until they are filled in
	LOG_PREFIX = "[Corny]", -- F9 lines (the usage reporter treats "[Corny]" warnings as errors)
	STATE_KEY = "CornyLoader", -- getgenv: this loader's state for the server (LoaderState)
	SESSION_KEY = "CornySession", -- getgenv: the reporter's session, only while the script starts
	RELAUNCHED_KEY = "CornyRelaunched", -- getgenv: Shared.Relaunch's queued code ran (read only)
	MENU_KEY = "CornyMenu", -- getgenv: the running menu ({ version, menu }, lib/cornymenu.md)
	BUSY_FOR = 120, -- seconds a run counts as going (one that died without clearing it frees itself)
	BEAT = 900, -- heartbeat seconds when the reply has none (PLAN 3.3)
	BEAT_MIN = 60, -- a reply's heartbeat is held to this range
	BEAT_MAX = 86400,
	KEY_PATTERN = "^[A-Z][A-Za-z0-9]*$", -- a game key (PLAN 4.2 step 6)
	KEY_MAX = 32,
	FILE_PATTERN = "^[%w%-_%.]+%.lua$", -- a script's file name on the cdn site (KEY.hash.lua)
	SESSION_PATTERN = "^[%w%-_%.]+$", -- the session token: base64url(payload).signature
	SESSION_MAX = 4096,
	INVITE_PATTERN = "^[%w%-]+$", -- a Discord invite code
	INVITE_MAX = 40,
	TEXT_MAX = 120, -- characters of a text from the server that the card shows
	SHOW_READY = 6, -- seconds the Ready card stays (it also goes when the menu key is pressed)
	SHOW_BACK = 2, -- seconds the quiet card stays after a teleport relaunch (PLAN 4.2 step 9)
	SHOW_PROBLEM = 10, -- seconds a card that says something went wrong, or not supported, stays
	-- the card (PLAN 4.4, look B; sizes and colors are CornyMenu's: lib/cornymenu.lua, PLAN 9)
	WIDTH = 220, -- the card's width (it grows to fit its text, up to MAX_WIDTH)
	MAX_WIDTH = 400,
	PAD = 14, -- space inside the card's edge
	TITLE_SIZE = 17, -- "Corny" (CornyMenu's TITLE)
	TEXT_SIZE = 13, -- every other line (CornyMenu's SMALL)
	BAR = 4, -- the progress bar's height
	GAP = 16, -- space between the footer's two sides
	FADE = 0.2, -- seconds a fade in or out takes
	EASE = 8, -- how fast the bar follows its target (per second)
	Z = 1000, -- ZIndex of the card's drawings (above the menu's)
})

-- The card's colors (PLAN 9: CornyMenu's palette)
local LoaderColor = table.freeze({
	panel = Color3.fromRGB(19, 19, 26), -- #13131A
	border = Color3.fromRGB(58, 58, 70), -- #3A3A46
	track = Color3.fromRGB(30, 30, 37), -- the bar's empty part (CornyMenu's field)
	text = Color3.fromRGB(236, 236, 240), -- #ECECF0
	subtext = Color3.fromRGB(160, 162, 172), -- #A0A2AC
	dim = Color3.fromRGB(98, 100, 110), -- CornyMenu's dim
	accent = Color3.fromRGB(0, 190, 255), -- #00BEFF, the menu's default accent
	good = Color3.fromRGB(90, 210, 120), -- #5AD278
	warn = Color3.fromRGB(240, 185, 60), -- #F0B93C
})

-- ============ Loader types ============
-- What the card shows. show() takes the whole view every time.
type LoaderView = {
	line: string?, -- under "Corny": the game's name, or what happened
	lineColor: Color3?,
	message: string?, -- below it, up to two lines: a notice, or what to do
	messageColor: Color3?,
	step: string?, -- footer, left: the step, or what was done
	stepColor: Color3?,
	side: string?, -- footer, right, dim: the version, or the short invite link
	progress: number?, -- 0 to 1: the progress bar (nil: no bar)
}

type LoaderCard = {
	show: (view: LoaderView) -> (),
	closeAfter: (seconds: number) -> (), -- fades out that many seconds from now
	closeOnKeys: (keys: { string }) -> (), -- fades out when one of these keys is pressed
	destroy: () -> (), -- gone at once (the next run's card replaces it)
}

-- The drawings of one card
type LoaderDrawings = {
	panel: DrawingSquare,
	border: DrawingSquare,
	track: DrawingSquare,
	fill: DrawingSquare,
	title: DrawingText,
	line: DrawingText,
	message: DrawingText,
	more: DrawingText, -- the message's second line
	step: DrawingText,
	side: DrawingText,
}

-- getgenv().CornyLoader: this loader's state for the server
type LoaderState = {
	busy: number?, -- os.clock() when the running loader started; nil when none runs
	relaunched: boolean?, -- this server's teleport relaunch was counted (Relaunch's flag stays)
	card: LoaderCard?, -- the card on screen (the next run removes it)
}

-- What POST /api/v1/load gets (PLAN 3.3)
type LoaderPayload = {
	v: number,
	place: number,
	universe: number,
	user: number,
	exec: { name: string, version: string },
	caps: { drawing: boolean, request: boolean, queue: boolean, files: boolean, clipboard: boolean },
	relaunch: boolean,
	device: string,
	locale: string,
	country: string?, -- left out when Roblox does not say
}

-- A supported game's reply, checked
type LoaderGame = {
	key: string,
	name: string,
	url: string,
	version: string,
	size: number?,
	session: string,
	beat: number,
	notice: string?,
}

-- Any other reply, checked
type LoaderRefusal = {
	reason: string,
	title: string,
	message: string,
	invite: string?, -- a valid invite code, or nil
}

-- getgenv().CornySession: what the usage reporter (templates/Usage.lua) reads
type LoaderSession = {
	token: string,
	site: string,
	beat: number,
	game: string,
	version: string,
	started: number, -- os.clock() when this loader started (the reporter's load time)
	relaunch: boolean,
}

-- ============ Loader: basics ============
local Loader = {}

function Loader.log(message: string): ()
	print(`{LoaderConfig.LOG_PREFIX} {message}`)
end

function Loader.logWarn(message: string): ()
	warn(`{LoaderConfig.LOG_PREFIX} {message}`)
end

-- A web request yields, and a thread that yielded can lose the executor's identity
-- (docs/LEARNINGS.md, thread identity; lib/cornymenu_loader.lua does the same)
function Loader.restoreIdentity(): ()
	local set: any = setthreadidentity
	if type(set) == "function" then
		pcall(set, 8)
	end
end

-- A text from the server made safe for the card: no control characters, at most `limit`
-- characters (cut on a whole character); nil when empty or not a string
function Loader.cleanText(value: any, limit: number): string?
	if type(value) ~= "string" then
		return nil
	end
	local text = string.gsub(value, "%c", " ")
	if utf8.len(text) == nil then
		text = string.gsub(text, "[\128-\255]", "?") -- not valid UTF-8: keep it plain
	end
	text = string.match(text, "^%s*(.-)%s*$") or ""
	if text == "" then
		return nil
	end
	local count = utf8.len(text) or #text
	if count > limit then
		local cut = utf8.offset(text, limit + 1)
		if cut ~= nil then
			text = string.sub(text, 1, cut - 1)
		end
	end
	return text
end

-- ============ Loader: the card ============
-- A centered card (PLAN 4.4, look B): "Corny" in white, the game's name dim under it, a thin
-- progress bar in the accent color, and a footer with the step on the left and the version on
-- the right, dim. Square corners like the menu; a short fade in and out; no glow, no logo. Drawn
-- with Drawing only; its RenderStepped connection runs only while the card is on screen. When
-- this executor has no Drawing, the card shows nothing and the loader still works (F9 says why).
function Loader.newCard(): LoaderCard
	local drawings: LoaderDrawings? = nil
	local objects: { any } = {} -- every drawing made (any: Squares and Texts, both have Remove)
	local view: LoaderView = {}
	local alive = true
	local closing = false
	local closeAt: number? = nil
	local alpha = 0 -- the card's opacity (Drawing's Transparency is opacity: 1 is solid)
	local shown = 0 -- the bar's drawn fill, following view.progress
	local dirty = true
	local viewport = Vector2.zero
	local barX = 0
	local barY = 0
	local barWidth = 0
	local paintedAlpha = -1 -- what paint() last wrote
	local paintedFill = -1
	local render: RBXScriptConnection? = nil
	local keyWatch: RBXScriptConnection? = nil

	local function finish(): ()
		alive = false
		drawings = nil
		if render ~= nil then
			render:Disconnect()
			render = nil
		end
		if keyWatch ~= nil then
			keyWatch:Disconnect()
			keyWatch = nil
		end
		for _, object in objects do
			pcall(function()
				object:Remove()
			end)
		end
		table.clear(objects)
	end

	-- The width of `text` at `size` (TextBounds when this executor reports it, else a guess)
	local function measure(label: DrawingText, text: string, size: number): number
		label.Text = text
		if text == "" then
			return 0
		end
		local ok, bounds = try(function(): Vector2
			return label.TextBounds
		end)
		if ok and typeof(bounds) == "Vector2" and bounds.X > 0 then
			return bounds.X
		end
		return #text * size * 0.52
	end

	-- `text` in at most two lines of `limit` pixels (words stay whole)
	local function wrap(label: DrawingText, text: string, limit: number): (string, string)
		local size = LoaderConfig.TEXT_SIZE
		if measure(label, text, size) <= limit then
			return text, ""
		end
		local first = ""
		local rest: { string } = {}
		for word in string.gmatch(text, "%S+") do
			if #rest == 0 then
				local candidate = if first == "" then word else `{first} {word}`
				if first == "" or measure(label, candidate, size) <= limit then
					first = candidate
					continue
				end
			end
			table.insert(rest, word)
		end
		return first, table.concat(rest, " ")
	end

	local function layout(parts: LoaderDrawings): ()
		local camera: Camera? = workspace.CurrentCamera
		local screen = if camera then camera.ViewportSize else Vector2.new(1280, 720)
		viewport = screen
		local pad = LoaderConfig.PAD
		local small = LoaderConfig.TEXT_SIZE
		local line = view.line or ""
		local step = view.step or ""
		local side = view.side or ""
		local first, second = wrap(parts.more, view.message or "", LoaderConfig.MAX_WIDTH - 2 * pad)
		local footer = measure(parts.step, step, small)
		if side ~= "" then
			footer += measure(parts.side, side, small) + LoaderConfig.GAP
		end
		local inner = math.max(
			measure(parts.title, "Corny", LoaderConfig.TITLE_SIZE),
			measure(parts.line, line, small),
			measure(parts.message, first, small),
			measure(parts.more, second, small),
			footer
		)
		local width =
			math.clamp(math.ceil(inner) + 2 * pad, LoaderConfig.WIDTH, LoaderConfig.MAX_WIDTH)
		-- top to bottom, from the card's top edge
		local rows: { { label: DrawingText, y: number } } = {}
		local cursor = pad
		table.insert(rows, { label = parts.title, y = cursor })
		cursor += LoaderConfig.TITLE_SIZE + 4
		local lines: { { label: DrawingText, text: string } } = {
			{ label = parts.line, text = line },
			{ label = parts.message, text = first },
			{ label = parts.more, text = second },
		}
		for _, row in lines do
			if row.text ~= "" then
				table.insert(rows, { label = row.label, y = cursor })
				cursor += small + 3
			end
		end
		local hasBar = view.progress ~= nil
		local barTop = cursor + 7
		if hasBar then
			cursor = barTop + LoaderConfig.BAR
		end
		local hasFooter = step ~= "" or side ~= ""
		local footerTop = cursor + 10
		if hasFooter then
			cursor = footerTop + small
		end
		local height = cursor + pad
		local left = math.floor((screen.X - width) / 2)
		local top = math.floor((screen.Y - height) / 2)
		parts.panel.Position = Vector2.new(left, top)
		parts.panel.Size = Vector2.new(width, height)
		parts.border.Position = Vector2.new(left, top)
		parts.border.Size = Vector2.new(width, height)
		for _, label in { parts.line, parts.message, parts.more, parts.step, parts.side } do
			label.Visible = false
		end
		for _, row in rows do
			row.label.Position = Vector2.new(left + pad, top + row.y)
			row.label.Visible = true
		end
		parts.title.Visible = true
		parts.line.Color = view.lineColor or LoaderColor.subtext
		parts.message.Color = view.messageColor or LoaderColor.subtext
		parts.more.Color = view.messageColor or LoaderColor.subtext
		parts.step.Color = view.stepColor or LoaderColor.subtext
		if hasFooter then
			parts.step.Position = Vector2.new(left + pad, top + footerTop)
			parts.step.Visible = step ~= ""
			local sideWidth = measure(parts.side, side, small)
			parts.side.Position = Vector2.new(left + width - pad - sideWidth, top + footerTop)
			parts.side.Visible = side ~= ""
		end
		barX = left + pad
		barY = top + barTop
		barWidth = width - 2 * pad
		parts.track.Position = Vector2.new(barX, barY)
		parts.track.Size = Vector2.new(barWidth, LoaderConfig.BAR)
		parts.track.Visible = hasBar
		parts.fill.Visible = hasBar
		parts.panel.Visible = true
		parts.border.Visible = true
	end

	-- Writes only what changed since the last frame
	local function paint(parts: LoaderDrawings, moved: boolean): ()
		if alpha ~= paintedAlpha then
			paintedAlpha = alpha
			for _, object in objects do
				object.Transparency = alpha
			end
		end
		local fill = math.max(0, math.floor(barWidth * shown))
		if moved or fill ~= paintedFill then
			paintedFill = fill
			parts.fill.Position = Vector2.new(barX, barY)
			parts.fill.Size = Vector2.new(fill, LoaderConfig.BAR)
		end
	end

	local function frame(delta: number): ()
		local parts = drawings
		if parts == nil or not alive then
			return
		end
		local due = closeAt
		if due ~= nil and os.clock() >= due then
			closing = true
			closeAt = nil
		end
		local step = delta / LoaderConfig.FADE
		alpha = if closing then math.max(0, alpha - step) else math.min(1, alpha + step)
		if closing and alpha <= 0 then
			finish()
			return
		end
		local camera: Camera? = workspace.CurrentCamera
		local moved = dirty or (camera ~= nil and camera.ViewportSize ~= viewport)
		if moved then
			dirty = false
			layout(parts)
		end
		local goal = math.clamp(view.progress or 0, 0, 1)
		shown += (goal - shown) * math.min(1, delta * LoaderConfig.EASE)
		paint(parts, moved)
	end

	-- Makes the drawings, all hidden; nil (and F9 says why) when Drawing is missing or fails
	local function create(): LoaderDrawings?
		local ok, made = try(function(): LoaderDrawings
			local function square(filled: boolean, color: Color3, z: number): DrawingSquare
				local item = Drawing.new("Square")
				table.insert(objects, item)
				item.Visible = false
				item.Transparency = 0
				item.Filled = filled
				item.Thickness = 1
				item.Color = color
				item.ZIndex = LoaderConfig.Z + z
				return item
			end
			local function label(size: number, color: Color3): DrawingText
				local item = Drawing.new("Text")
				table.insert(objects, item)
				item.Visible = false
				item.Transparency = 0
				item.Text = ""
				item.Size = size
				item.Color = color
				item.Center = false
				item.Outline = false
				item.ZIndex = LoaderConfig.Z + 4
				-- the menu's default font; an executor without it keeps its own
				pcall(function()
					item.Font = Drawing.Fonts.Plex
				end)
				return item
			end
			return {
				panel = square(true, LoaderColor.panel, 0),
				border = square(false, LoaderColor.border, 1),
				track = square(true, LoaderColor.track, 2),
				fill = square(true, LoaderColor.accent, 3),
				title = label(LoaderConfig.TITLE_SIZE, LoaderColor.text),
				line = label(LoaderConfig.TEXT_SIZE, LoaderColor.subtext),
				message = label(LoaderConfig.TEXT_SIZE, LoaderColor.subtext),
				more = label(LoaderConfig.TEXT_SIZE, LoaderColor.subtext),
				step = label(LoaderConfig.TEXT_SIZE, LoaderColor.subtext),
				side = label(LoaderConfig.TEXT_SIZE, LoaderColor.dim),
			}
		end)
		if ok then
			made.title.Text = "Corny"
			return made
		end
		Loader.log(`the loading card cannot be drawn here (no Drawing): {made}`)
		finish()
		return nil
	end

	local card: LoaderCard = {
		show = function(nextView: LoaderView): ()
			if not alive then
				return
			end
			view = nextView
			dirty = true
			if drawings == nil then
				drawings = create()
				if drawings == nil then
					return
				end
				render = RunService.RenderStepped:Connect(frame)
			end
		end,
		closeAfter = function(seconds: number): ()
			closeAt = os.clock() + seconds
		end,
		closeOnKeys = function(keys: { string }): ()
			if not alive or #keys == 0 or keyWatch ~= nil then
				return
			end
			keyWatch = UserInputService.InputBegan:Connect(function(input: InputObject): ()
				if table.find(keys, input.KeyCode.Name) then
					closing = true
				end
			end)
		end,
		destroy = finish,
	}
	return card
end

-- ============ Loader: this game and executor ============
-- What this executor can do (PLAN 4.2 step 3); `get` says whether game:HttpGet exists
function Loader.capabilities(): ({
	drawing: boolean,
	request: boolean,
	queue: boolean,
	files: boolean,
	clipboard: boolean,
}, boolean)
	local hasGet, getter = try(function(): any
		return (game :: any).HttpGet -- any: reading a method that some executors leave out
	end)
	return {
		drawing = type(Drawing) == "table",
		request = type(request) == "function",
		queue = type(queueonteleport) == "function",
		files = type(writefile) == "function", -- only whether it exists: the loader writes no file
		clipboard = type(setclipboard) == "function",
	},
		hasGet and type(getter) == "function"
end

-- The executor's name and version (identifyexecutor, PLAN 3.4 step 1)
function Loader.executor(): (string, string)
	local ok, name, version = pcall(identifyexecutor)
	local cleanName = if ok then Loader.cleanText(tostring(name), 64) else nil
	local cleanVersion = if ok and version ~= nil
		then Loader.cleanText(tostring(version), 64)
		else nil
	return cleanName or "Unknown", cleanVersion or ""
end

-- The country Roblox gives this player (it may yield); nil when it does not say
function Loader.country(player: Player): string?
	local ok, region = try(function(): string
		return game:GetService("LocalizationService"):GetCountryRegionForPlayerAsync(player)
	end)
	Loader.restoreIdentity()
	if ok and type(region) == "string" and string.match(region, "^%a%a$") then
		return string.upper(region)
	end
	return nil
end

function Loader.payload(player: Player, relaunch: boolean): LoaderPayload
	local caps = Loader.capabilities()
	local name, version = Loader.executor()
	local okLocale, locale = try(function(): string
		return game:GetService("LocalizationService").RobloxLocaleId
	end)
	local mobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
	return {
		v = LoaderConfig.VERSION,
		place = game.PlaceId,
		universe = game.GameId,
		user = player.UserId, -- only in the POST body; the API hashes it on arrival (PLAN 3.3)
		exec = { name = name, version = version },
		caps = caps,
		relaunch = relaunch,
		device = if mobile then "mobile" else "pc",
		locale = if okLocale and type(locale) == "string" then string.lower(locale) else "",
		country = Loader.country(player),
	}
end

-- ============ Loader: web requests ============
-- Asks the API about this game: the decoded reply, or nil and why (F9). POST with request() (it
-- adds the executor's own headers); without it, or when it fails, GET with the short query,
-- which never carries the user id (PLAN 3.3)
function Loader.ask(payload: LoaderPayload, canGet: boolean): (any, string?)
	local problems: { string } = {}
	if payload.caps.request then
		local encoded, body = try(HttpService.JSONEncode, HttpService, payload)
		if encoded then
			local ok, response = try(function(): any
				return request({ -- allow-web: our API, the loader the user approved (2026-10-16)
					Url = `{CORNY_SITE}/api/v1/load`,
					Method = "POST",
					Headers = { ["Content-Type"] = "application/json" },
					Body = body,
				})
			end)
			Loader.restoreIdentity()
			if ok and type(response) == "table" then
				local text = if type(response.Body) == "string" then response.Body else ""
				local decoded, data = try(HttpService.JSONDecode, HttpService, text)
				if decoded and type(data) == "table" then
					return data, nil
				end
				return nil,
					`the API answered HTTP {tostring(response.StatusCode)}: {string.sub(
						text,
						1,
						200
					)}`
			end
			table.insert(problems, `request failed: {tostring(response)}`)
		else
			table.insert(problems, `the request could not be written: {tostring(body)}`)
		end
	end
	if not canGet then
		table.insert(problems, "no game:HttpGet to fall back on")
		return nil, table.concat(problems, "; ")
	end
	local function encode(text: string): string
		local ok, encoded = try(HttpService.UrlEncode, HttpService, text)
		return if ok and type(encoded) == "string" then encoded else ""
	end
	local url = `{CORNY_SITE}/api/v1/load?place={payload.place}&universe={payload.universe}`
		.. `&exec={encode(payload.exec.name)}&execv={encode(payload.exec.version)}`
		.. `&v={payload.v}`
	local ok, text = try(function(): string
		return game:HttpGet(url, true) -- allow-web: our API, the loader the user approved (2026-10-16)
	end)
	Loader.restoreIdentity()
	if not ok or type(text) ~= "string" then
		table.insert(problems, `the API did not answer: {tostring(text)}`)
		return nil, table.concat(problems, "; ")
	end
	local decoded, data = try(HttpService.JSONDecode, HttpService, text)
	if decoded and type(data) == "table" then
		return data, nil
	end
	table.insert(problems, `the API's answer is not JSON: {string.sub(text, 1, 200)}`)
	return nil, table.concat(problems, "; ")
end

-- Downloads the game's script from our cdn site: its text, or nil and why (F9)
function Loader.download(url: string, canGet: boolean): (string?, string?)
	local ok, result = try(function(): any
		if canGet then
			return game:HttpGet(url, true) -- allow-web: the game's script on our cdn site (2026-10-16)
		end
		local response = request({ -- allow-web: the game's script on our cdn site (2026-10-16)
			Url = url,
			Method = "GET",
		})
		if not response.Success then
			error(`HTTP {response.StatusCode} {response.StatusMessage}`, 0)
		end
		return response.Body
	end)
	Loader.restoreIdentity()
	if not ok or type(result) ~= "string" then
		return nil, `the script did not download: {tostring(result)}`
	end
	local source: string = result
	if string.sub(source, 1, 3) == "\239\187\191" then
		source = string.sub(source, 4) -- a UTF-8 byte order mark does not compile
	end
	if source == "" then
		return nil, "the script downloaded empty"
	end
	return source, nil
end

-- ============ Loader: the reply ============
-- Checks the API's reply (PLAN 4.2 step 6): a supported game, or a refusal; nil for both (and
-- why) when it is anything else, which the card treats as "Can't reach Corny right now"
function Loader.read(data: any): (LoaderGame?, LoaderRefusal?, string?)
	if type(data) ~= "table" then
		return nil, nil, "the reply is not an object"
	end
	if data.ok == true then
		local info = data.game
		local release = data.script
		if type(info) ~= "table" or type(release) ~= "table" then
			return nil, nil, "the reply has no game or script"
		end
		local key = info.key
		if
			type(key) ~= "string"
			or #key > LoaderConfig.KEY_MAX
			or not string.match(key, LoaderConfig.KEY_PATTERN)
		then
			return nil, nil, `the game key {tostring(key)} is not one of ours`
		end
		local url = release.url
		local prefix = `{CORNY_CDN}/s/`
		if
			type(url) ~= "string"
			or string.sub(url, 1, #prefix) ~= prefix
			or not string.match(string.sub(url, #prefix + 1), LoaderConfig.FILE_PATTERN)
		then
			return nil, nil, `the script address {tostring(url)} is not on our cdn site`
		end
		local session = data.session
		if
			type(session) ~= "string"
			or #session > LoaderConfig.SESSION_MAX
			or not string.match(session, LoaderConfig.SESSION_PATTERN)
		then
			return nil, nil, "the reply has no usable session"
		end
		local beat = data.beat
		if type(beat) ~= "number" or beat ~= beat then
			beat = LoaderConfig.BEAT
		end
		return {
			key = key,
			name = Loader.cleanText(info.name, 60) or key,
			url = url,
			version = Loader.cleanText(release.version, 40) or "",
			size = if type(release.size) == "number" then release.size else nil,
			session = session,
			beat = math.clamp(beat, LoaderConfig.BEAT_MIN, LoaderConfig.BEAT_MAX),
			notice = Loader.cleanText(data.notice, LoaderConfig.TEXT_MAX),
		},
			nil,
			nil
	end
	if data.ok == false and type(data.reason) == "string" then
		local reason = data.reason
		-- the server's texts first; these only when it sent none
		local defaults: { [string]: { string } } = {
			unsupported = {
				"This game isn't supported yet",
				"Join our Discord to see what's coming next.",
			},
			maintenance = { "Corny is being updated", "Try again in a few minutes." },
			disabled = {
				"Corny is off in this game for now",
				"Join our Discord to hear when it's back.",
			},
			blocked = { "Corny can't run on this account", "" },
			executor = { "Your executor can't run Corny", "" },
			busy = { "Too many tries", "Wait a minute, then try again." },
		}
		local fallback = defaults[reason]
			or { "Can't reach Corny right now", "Try again in a minute." }
		local invite = data.invite
		local valid = type(invite) == "string"
			and #invite <= LoaderConfig.INVITE_MAX
			and string.match(invite, LoaderConfig.INVITE_PATTERN) ~= nil
		return nil,
			{
				reason = reason,
				title = Loader.cleanText(data.title, LoaderConfig.TEXT_MAX) or fallback[1],
				message = Loader.cleanText(data.message, LoaderConfig.TEXT_MAX) or fallback[2],
				invite = if valid then invite else nil,
			},
			nil
	end
	return nil, nil, "the reply is neither ok nor a refusal"
end

-- The running menu's toggle keys (what the bootstrap's F9 line says), {} when none
function Loader.toggleKeys(): { string }
	local running = getgenv()[LoaderConfig.MENU_KEY]
	if type(running) ~= "table" or type(running.menu) ~= "table" then
		return {}
	end
	local ok, keys = try(function(): any
		return running.menu:getKeys("toggle")
	end)
	local names: { string } = {}
	if ok and type(keys) == "table" then
		for _, key in keys do
			if type(key) == "string" then
				table.insert(names, key)
			end
		end
	end
	return names
end

-- ============ Loader: the run ============
-- "Can't reach Corny right now" (offline, a bad reply, a broken download); the detail goes to F9
function Loader.unreachable(card: LoaderCard, why: string): ()
	Loader.logWarn(`could not load Corny: {why}`)
	card.show({
		line = "Can't reach Corny right now",
		lineColor = LoaderColor.text,
		message = "Try again in a minute.",
	})
	card.closeAfter(LoaderConfig.SHOW_PROBLEM)
end

-- Not supported (or another refusal): the server's title and message; for "unsupported" (and only
-- then) the invite shows in the Discord app and the link is copied, on its own thread so the card
-- never waits (PLAN 4.2 step 7). The footer says what happened.
function Loader.refused(card: LoaderCard, refusal: LoaderRefusal): ()
	Loader.log(`this game is not available: {refusal.reason} (place {game.PlaceId})`)
	local invite = refusal.invite
	local view: LoaderView = {
		line = refusal.title,
		lineColor = LoaderColor.text,
		message = if refusal.message ~= "" then refusal.message else nil,
		side = if invite ~= nil then DiscordInvite.shortLink(invite) else nil,
	}
	card.show(view)
	card.closeAfter(LoaderConfig.SHOW_PROBLEM)
	if refusal.reason ~= "unsupported" or invite == nil then
		return
	end
	local code: string = invite
	task.spawn(function(): ()
		Loader.restoreIdentity()
		local copied, copyProblem = DiscordInvite.copy(code)
		if copied then
			view.step = "Invite copied"
			view.stepColor = LoaderColor.good
			card.show(view)
		else
			Loader.log(`the invite was not copied: {copyProblem}`)
		end
		local ok, result = try(DiscordInvite.open, code)
		Loader.restoreIdentity()
		local opened = ok and type(result) == "table" and result.opened == true
		if ok and type(result) == "table" then
			Loader.log(DiscordInvite.describe(result))
		else
			Loader.log(`the invite did not open: {tostring(result)}`)
		end
		if opened then
			view.step = if copied then "Opened in Discord, invite copied" else "Opened in Discord"
			view.stepColor = LoaderColor.good
			card.show(view)
		end
	end)
end

function Loader.load(state: LoaderState): ()
	local genv = getgenv()
	local started = os.clock()
	-- a relaunch after a teleport counts once per server (Shared.Relaunch's flag is never cleared)
	local relaunch = genv[LoaderConfig.RELAUNCHED_KEY] == true and state.relaunched ~= true
	if relaunch then
		state.relaunched = true
	end
	local card = Loader.newCard()
	state.card = card
	if not relaunch then
		card.show({ step = "Checking this game", progress = 0.12 })
	end
	if not game:IsLoaded() then
		game.Loaded:Wait()
		Loader.restoreIdentity()
	end
	local player: Player? = Players.LocalPlayer
	while player == nil do
		Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
		player = Players.LocalPlayer
	end
	assert(player ~= nil)
	Loader.restoreIdentity()
	if
		string.find(CORNY_SITE, LoaderConfig.PLACEHOLDER, 1, true)
		or string.find(CORNY_CDN, LoaderConfig.PLACEHOLDER, 1, true)
	then
		Loader.unreachable(
			card,
			"CORNY_SITE / CORNY_CDN at the top of the loader are not filled in"
		)
		return
	end
	local payload = Loader.payload(player, relaunch)
	local _, canGet = Loader.capabilities()
	if not payload.caps.request and not canGet then
		Loader.logWarn("this executor cannot make web requests (no request, no game:HttpGet)")
		card.show({ line = "Your executor can't run Corny", lineColor = LoaderColor.text })
		card.closeAfter(LoaderConfig.SHOW_PROBLEM)
		return
	end
	Loader.log(
		`checking this game (place {payload.place}, {payload.exec.name} {payload.exec.version})`
	)
	local data, problem = Loader.ask(payload, canGet)
	if data == nil then
		Loader.unreachable(card, problem or "no reply")
		return
	end
	local info, refusal, wrong = Loader.read(data)
	if refusal ~= nil then
		Loader.refused(card, refusal)
		return
	end
	if info == nil then
		Loader.unreachable(card, wrong or "a bad reply")
		return
	end
	local notice = info.notice
	local view: LoaderView = {
		line = info.name,
		message = notice,
		messageColor = LoaderColor.warn,
		step = "Loading script",
		side = info.version,
		progress = 0.45,
	}
	if not relaunch then
		card.show(view)
	end
	Loader.log(`loading {info.name} {info.version}`)
	local source, failed = Loader.download(info.url, canGet)
	if source == nil then
		Loader.unreachable(card, failed or "no script")
		return
	end
	local size = info.size
	if size ~= nil and size ~= #source then
		Loader.log(`the script is {#source} bytes, the release says {size}`)
	end
	local run, compileError = loadstring(source, "=Corny") -- allow-web: runs our cdn site's script, as the user approved (2026-10-16)
	if run == nil then
		Loader.unreachable(card, `the script does not compile: {compileError}`)
		return
	end
	view.step = "Starting"
	view.progress = 0.8
	if not relaunch then
		card.show(view)
	end
	-- the usage reporter in the script's bootstrap takes this session (templates/Usage.lua)
	local session: LoaderSession = {
		token = info.session,
		site = CORNY_SITE,
		beat = info.beat,
		game = info.key,
		version = info.version,
		started = started,
		relaunch = relaunch,
	}
	genv[LoaderConfig.SESSION_KEY] = session
	local ok, err = tryTraced(run)
	Loader.restoreIdentity()
	if rawequal(genv[LoaderConfig.SESSION_KEY], session) then
		genv[LoaderConfig.SESSION_KEY] = nil -- one start only: a later run without the loader is not counted
	end
	if not ok then
		Loader.logWarn(`Corny stopped while starting: {err}`)
		card.show({
			line = info.name,
			message = "Something went wrong while starting. Try again in a minute.",
			messageColor = LoaderColor.text,
			side = info.version,
		})
		card.closeAfter(LoaderConfig.SHOW_PROBLEM)
		return
	end
	local keys = Loader.toggleKeys()
	if relaunch then
		card.show({ line = info.name, step = "Corny is back", side = info.version })
		card.closeAfter(LoaderConfig.SHOW_BACK)
		Loader.log(`{info.name} is back after the teleport`)
		return
	end
	local how = if #keys > 0
		then `Press {table.concat(keys, " or ")} to open Corny`
		else "Click the Corny watermark to open it"
	view.step = `Ready. {how}`
	view.stepColor = LoaderColor.text
	view.progress = 1
	card.show(view)
	card.closeAfter(LoaderConfig.SHOW_READY)
	card.closeOnKeys(keys)
	Loader.log(`{info.name} {info.version} is running`)
end

-- ============ Start ============
-- One loader at a time per server (getgenv().CornyLoader.busy), cleared when the run ends or
-- fails, so executing again (how players reload Corny) always works
function Loader.start(): ()
	local genv = getgenv()
	local raw = genv[LoaderConfig.STATE_KEY]
	local state: LoaderState = if type(raw) == "table" then raw else {}
	genv[LoaderConfig.STATE_KEY] = state
	local busy = state.busy
	if type(busy) == "number" and os.clock() - busy < LoaderConfig.BUSY_FOR then
		Loader.log("Corny is already loading")
		return
	end
	local old: any = state.card -- any: a card from another loader version may differ
	if type(old) == "table" and type(old.destroy) == "function" then
		try(old.destroy)
	end
	state.card = nil
	state.busy = os.clock()
	local ok, err = tryTraced(Loader.load, state)
	state.busy = nil
	if not ok then
		Loader.logWarn(`the loader stopped: {err}`)
		local card = state.card
		if card ~= nil then
			card.show({
				line = "Can't reach Corny right now",
				lineColor = LoaderColor.text,
				message = "Try again in a minute.",
			})
			card.closeAfter(LoaderConfig.SHOW_PROBLEM)
		end
	end
end

Loader.start()
