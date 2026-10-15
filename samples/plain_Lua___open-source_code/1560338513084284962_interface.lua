local __modules = {}
local __cache = {}

local function import(path)
	local cached = __cache[path]
	if cached ~= nil then
		return cached
	end
	local loader = __modules[path]
	if not loader then
		error("module not found: " .. tostring(path))
	end
	local value = loader()
	__cache[path] = value
	return value
end

__modules["components/nothing.com/yeahnothing"] = function()

end

__modules["components/window/dialog"] = function()
-- was been removed from ui and not working anymore, dont try to add back pls

local Dialog = {}

function Dialog.new(ctx, callbacks)
	callbacks = callbacks or {}

	local C = ctx.C
	local make, frame, text, round = ctx.make, ctx.frame, ctx.text, ctx.round
	local tween, prep, fade = ctx.tween, ctx.prep, ctx.fade
	local state, Images, FONT_BOLD = ctx.state, ctx.images, ctx.FONT_BOLD

	local popup = make("Frame", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ZIndex = 10,
		Visible = false,
	}, ctx.canvas)

	local dim = make("TextButton", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
		BackgroundTransparency = 0.4,
		BorderSizePixel = 0,
		AutoButtonColor = false,
		Text = "",
	}, popup)
	make("UICorner", { CornerRadius = UDim.new(0, 10) }, dim)

	local popupCard = make("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = UDim2.new(0, 270, 0, 132),
		BackgroundColor3 = "card",
		BorderSizePixel = 0,
	}, popup)
	round(popupCard, 12, "stroke")

	local badge = frame(popupCard, 22, 20, 32, 32, "input", 0)
	round(badge, 16, "stroke")
	make("ImageLabel", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = UDim2.new(0, 12, 0, 12),
		BackgroundTransparency = 1,
		Image = Images.CLOSE_ICON,
		ImageColor3 = ctx.tintIcons and "accent" or Color3.fromRGB(255, 255, 255),
	}, badge)

	local popupTitle = text(popupCard, "Close Key System?", 66, 19, 182, 16, 14, "text")
	popupTitle.FontFace = FONT_BOLD
	local popupDesc = text(popupCard, "Are you sure you want to close the Key System?", 66, 38, 182, 30, 12, "muted")
	popupDesc.TextWrapped = true
	popupDesc.TextYAlignment = Enum.TextYAlignment.Top

	local function popupButton(label, x, primary)
		local btn = make("TextButton", {
			Position = UDim2.new(0, x, 0, 86),
			Size = UDim2.new(0, 109, 0, 32),
			BackgroundColor3 = primary and "submitBg" or "btn2",
			BackgroundTransparency = primary and 0.12 or 0,
			BorderSizePixel = 0,
			AutoButtonColor = false,
			Text = label,
			TextSize = 13,
			TextColor3 = primary and "submitText" or "text",
			FontFace = ctx.FONT,
		}, popupCard)
		if primary then
			round(btn, 8)
		else
			round(btn, 8, "stroke")
		end
		return btn
	end

	local cancelBtn = popupButton("Cancel", 22, false)
	local confirmBtn = popupButton("Close", 139, true)

	cancelBtn.MouseEnter:Connect(function()
		if state.closing or not state.popupOpen then
			return
		end
		tween(cancelBtn, 0.15, { BackgroundColor3 = C.btn2Hover })
	end)
	cancelBtn.MouseLeave:Connect(function()
		if state.closing or not state.popupOpen then
			return
		end
		tween(cancelBtn, 0.15, { BackgroundColor3 = C.btn2 })
	end)
	confirmBtn.MouseEnter:Connect(function()
		if state.closing or not state.popupOpen then
			return
		end
		tween(confirmBtn, 0.15, { BackgroundTransparency = 0 })
	end)
	confirmBtn.MouseLeave:Connect(function()
		if state.closing or not state.popupOpen then
			return
		end
		tween(confirmBtn, 0.15, { BackgroundTransparency = 0.12 })
	end)

	local popupItems = prep(popup)
	fade(popupItems, 0)

	local function show()
		if not state.ready or state.popupOpen or state.closing then
			return
		end
		state.popupOpen = true
		popup.Visible = true
		popupCard.Position = UDim2.new(0.5, 0, 0.5, 8)
		if callbacks.onOpen then
			callbacks.onOpen()
		end
		fade(popupItems, 1, 0.22)
		tween(popupCard, 0.35, { Position = UDim2.new(0.5, 0, 0.5, 0) }, Enum.EasingStyle.Quint)
	end

	local function hide()
		if not state.popupOpen or state.closing then
			return
		end
		state.popupOpen = false
		fade(popupItems, 0, 0.18)
		task.delay(0.2, function()
			if not state.popupOpen then
				popup.Visible = false
			end
		end)
	end

	cancelBtn.MouseButton1Click:Connect(hide)
	confirmBtn.MouseButton1Click:Connect(function()
		if callbacks.onConfirm then
			callbacks.onConfirm()
		end
	end)

	return {
		popup = popup,
		items = popupItems,
		show = show,
		hide = hide,
	}
end

return Dialog
end

__modules["components/window/notification"] = function()
local Lighting = game:GetService("Lighting")

local Notification = {}

-- NotifStyle: "1" Stripe | "2" Pill | "3" Island | "4" Ring | "5" Solid (names work too)
local STYLE_BY_NAME = { stripe = "1", pill = "2", island = "3", ring = "4", solid = "5" }

function Notification.new(ctx)
	local C = ctx.C
	local make, frame, text, round = ctx.make, ctx.frame, ctx.text, ctx.round
	local tween, prep, fade = ctx.tween, ctx.prep, ctx.fade
	local root, cfg, Images = ctx.root, ctx.cfg, ctx.images
	local FONT, FONT_BOLD = ctx.FONT, ctx.FONT_BOLD
	local markBoldFont = ctx.markBoldFont

	local NOTIF_W = cfg.NOTIF_W
	local NOTIF_TRANSPARENCY = cfg.NOTIF_TRANSPARENCY
	local NOTIF_COLOR = cfg.NOTIF_COLOR
	local NOTIF_BLUR = cfg.NOTIF_BLUR

	local ISLAND_W = 260
	local RING_DOTS = 28
	local MAX_NOTIFS = 4

	local WHITE = Color3.fromRGB(255, 255, 255)
	local DARK = Color3.fromRGB(11, 11, 11)

	local ICONS = {
		key = { Images.KEY, 18 },
		submit = { Images.SUBMIT, 18 },
		link = { Images.LINK, 18 },
		discord = { Images.DISCORD, 18 },
		close = { Images.CLOSE_ICON, 14 },
		moon = { Images.MOON_ICON, 14 },
	}

	local function kindColor(kind)
		if kind == "success" then
			return C.success
		elseif kind == "warn" then
			return C.warn
		elseif kind == "error" then
			return C.error
		end
		return C.accent
	end

	-- Readable icon/text color on top of a filled color
	local function contrastOn(color)
		local luminance = 0.299 * color.R + 0.587 * color.G + 0.114 * color.B
		return luminance > 0.55 and DARK or WHITE
	end

	local function cardHover()
		return NOTIF_COLOR == "bg" and C.card or C.btn2
	end

	-- Bottom-right stack (Stripe, Pill, Ring, Solid)
	local cornerHolder = make("Frame", {
		AnchorPoint = Vector2.new(1, 1),
		Position = UDim2.new(1, -16, 1, -8),
		Size = UDim2.new(0, NOTIF_W, 1, -16),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ZIndex = 20,
	}, root)
	make("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		VerticalAlignment = Enum.VerticalAlignment.Bottom,
		HorizontalAlignment = Enum.HorizontalAlignment.Right,
	}, cornerHolder)

	-- Top-center stack (Island)
	local islandHolder = make("Frame", {
		AnchorPoint = Vector2.new(0.5, 0),
		Position = UDim2.new(0.5, 0, 0, 12),
		Size = UDim2.new(0, ISLAND_W, 1, -24),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ZIndex = 20,
	}, root)
	make("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		VerticalAlignment = Enum.VerticalAlignment.Top,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
	}, islandHolder)

	local notifCount = 0
	local activeNotifs = {}

	local Blur = { effect = nil, users = 0 }

	function Blur.to(size, time)
		if NOTIF_BLUR <= 0 then
			return
		end
		if not Blur.effect then
			local ok, effect = pcall(function()
				local e = Instance.new("BlurEffect")
				e.Name = "AirflowBlur"
				e.Size = 0
				e.Parent = Lighting
				return e
			end)
			if not ok then
				return
			end
			Blur.effect = effect
		end
		tween(Blur.effect, time, { Size = size })
	end

	function Blur.acquire()
		Blur.users += 1
		Blur.to(NOTIF_BLUR, 0.35)
	end

	function Blur.release()
		Blur.users = math.max(Blur.users - 1, 0)
		if Blur.users == 0 and Blur.effect then
			Blur.to(0, 0.5)
		end
	end

	root.Destroying:Connect(function()
		if Blur.effect then
			Blur.effect:Destroy()
			Blur.effect = nil
		end
	end)

	-- Shared builders

	local function newWrapper(holder, width, height)
		return make("Frame", {
			LayoutOrder = notifCount,
			Size = UDim2.new(0, width, 0, height + 8),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
		}, holder)
	end

	local function newToast(wrapper, props, radius, strokeColor)
		props.BorderSizePixel = 0
		props.AutoButtonColor = false
		props.ClipsDescendants = true
		props.Text = ""
		local toast = make("TextButton", props, wrapper)
		round(toast, radius, strokeColor)
		local stroke = toast:FindFirstChildOfClass("UIStroke")
		if stroke then
			stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
			stroke.Transparency = 0.35
		end
		return toast
	end

	local function label(parent, str, x, y, w, h, size, color, bold)
		local l = text(parent, str, x, y, w, h, size, color)
		if bold then
			-- Route through markBoldFont (not a raw FontFace assign) so this label
			-- is registered as bold in fontBindings; otherwise the next
			-- SetUIFont/SetTitleFont call flattens it back to the regular weight.
			markBoldFont(l)
		end
		l.TextTruncate = Enum.TextTruncate.AtEnd
		return l
	end

	local function iconImage(parent, spec, color, size)
		return make("ImageLabel", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Size = UDim2.new(0, size, 0, size),
			BackgroundTransparency = 1,
			Image = spec[1],
			ImageColor3 = color,
		}, parent)
	end

	-- 1 · Stripe: color bar on the left + countdown line at the bottom
	local function buildStripe(title, message, color)
		local W, H = NOTIF_W, 62
		local wrapper = newWrapper(cornerHolder, W, H)
		local toast = newToast(wrapper, {
			Position = UDim2.new(0, 40, 0, 0),
			Size = UDim2.new(0, W, 0, H),
			BackgroundColor3 = C[NOTIF_COLOR],
			BackgroundTransparency = NOTIF_TRANSPARENCY,
		}, 10, C.stroke)

		round(frame(toast, 8, 10, 3, H - 20, color, 0), 2)
		label(toast, title, 22, 11, W - 36, 18, 13, C.text, true)
		label(toast, message, 22, 30, W - 36, 16, 12, C.muted)

		local trackW = W - 44
		round(frame(toast, 22, H - 9, trackW, 2, color, 0.8), 1)
		local fill = frame(toast, 22, H - 9, trackW, 2, color, 0)
		round(fill, 1)

		return {
			wrapper = wrapper,
			toast = toast,
			startPos = UDim2.new(0, 40, 0, 0),
			restPos = UDim2.new(0, 0, 0, 0),
			baseColor = C[NOTIF_COLOR],
			hoverColor = cardHover(),
			progress = function(fraction)
				tween(
					fill,
					0.06,
					{ Size = UDim2.new(0, math.floor(trackW * fraction), 0, 2) },
					Enum.EasingStyle.Linear
				)
			end,
		}
	end

	-- 2 · Pill: compact capsule; long text wraps to more lines (never cut)
	local function escapeRich(str)
		return (str:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"))
	end

	local function buildPill(title, message, color, spec)
		local H = 36
		local wrapper = make("Frame", {
			LayoutOrder = notifCount,
			Size = UDim2.new(0, NOTIF_W, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
		}, cornerHolder)
		make("UIPadding", { PaddingBottom = UDim.new(0, 8) }, wrapper)

		local toast = newToast(wrapper, {
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.new(1, 40, 0, 0),
			Size = UDim2.new(0, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.XY,
			BackgroundColor3 = C[NOTIF_COLOR],
			BackgroundTransparency = NOTIF_TRANSPARENCY,
		}, H / 2, C.stroke)
		make("UISizeConstraint", { MinSize = Vector2.new(0, H) }, toast)
		make("UIPadding", {
			PaddingLeft = UDim.new(0, 6),
			PaddingRight = UDim.new(0, 14),
			PaddingTop = UDim.new(0, 6),
			PaddingBottom = UDim.new(0, 6),
		}, toast)
		make("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 8),
		}, toast)

		local badge = make("Frame", {
			LayoutOrder = 1,
			Size = UDim2.new(0, 24, 0, 24),
			BackgroundColor3 = color,
			BorderSizePixel = 0,
		}, toast)
		make("UICorner", { CornerRadius = UDim.new(1, 0) }, badge)
		iconImage(badge, spec, contrastOn(color), math.min(spec[2], 14))

		local rich = "<b>" .. escapeRich(title) .. "</b>"
		if message ~= "" then
			rich = rich .. '  <font color="#' .. C.muted:ToHex() .. '">' .. escapeRich(message) .. "</font>"
		end
		local body = make("TextLabel", {
			LayoutOrder = 2,
			Size = UDim2.new(0, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.XY,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			RichText = true,
			TextWrapped = true,
			Text = rich,
			TextSize = 13,
			TextColor3 = C.text,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Center,
			FontFace = FONT,
		}, toast)
		make("UISizeConstraint", { MaxSize = Vector2.new(NOTIF_W - 52, math.huge) }, body)

		return {
			wrapper = wrapper,
			toast = toast,
			startPos = UDim2.new(1, 40, 0, 0),
			restPos = UDim2.new(1, 0, 0, 0),
			baseColor = C[NOTIF_COLOR],
			hoverColor = cardHover(),
		}
	end

	-- 3 · Island: dark capsule at the top center that expands in
	local function buildIsland(title, message, color, spec)
		local W, H = ISLAND_W, 52
		local border = Color3.fromRGB(42, 42, 48)
		local wrapper = newWrapper(islandHolder, W, H)
		local toast = newToast(wrapper, {
			AnchorPoint = Vector2.new(0.5, 0),
			Position = UDim2.new(0.5, 0, 0, -70),
			Size = UDim2.new(0, H, 0, H),
			BackgroundColor3 = Color3.fromRGB(0, 0, 0),
			BackgroundTransparency = 0.06,
		}, H / 2, border)

		local badge = frame(toast, 10, 10, 32, 32, color, 0)
		make("UICorner", { CornerRadius = UDim.new(1, 0) }, badge)
		iconImage(badge, spec, contrastOn(color), spec[2])

		label(toast, title, 54, 9, W - 70, 16, 13, Color3.fromRGB(244, 244, 245), true)
		label(toast, message, 54, 27, W - 70, 14, 12, Color3.fromRGB(154, 154, 162))

		return {
			wrapper = wrapper,
			toast = toast,
			baseColor = Color3.fromRGB(0, 0, 0),
			hoverColor = Color3.fromRGB(22, 22, 26),
			enter = function(items)
				fade(items, 1, 0.25)
				tween(toast, 0.4, { Position = UDim2.new(0.5, 0, 0, 0) }, Enum.EasingStyle.Quint)
				task.delay(0.12, function()
					tween(toast, 0.5, { Size = UDim2.new(0, W, 0, H) }, Enum.EasingStyle.Quint)
				end)
			end,
			leave = function(items)
				fade(items, 0, 0.25)
				tween(
					toast,
					0.3,
					{ Size = UDim2.new(0, H, 0, H) },
					Enum.EasingStyle.Quint,
					Enum.EasingDirection.In
				)
				task.delay(0.15, function()
					tween(
						toast,
						0.3,
						{ Position = UDim2.new(0.5, 0, 0, -70) },
						Enum.EasingStyle.Quint,
						Enum.EasingDirection.In
					)
				end)
			end,
		}
	end

	-- 4 · Ring: icon inside a circular timer
	local function buildRing(title, message, color, spec)
		local W, H = NOTIF_W, 60
		local wrapper = newWrapper(cornerHolder, W, H)
		local toast = newToast(wrapper, {
			Position = UDim2.new(0, 40, 0, 0),
			Size = UDim2.new(0, W, 0, H),
			BackgroundColor3 = C[NOTIF_COLOR],
			BackgroundTransparency = NOTIF_TRANSPARENCY,
		}, 10, C.stroke)

		local ringBox = frame(toast, 10, 10, 40, 40)
		local dots = {}
		for i = 0, RING_DOTS - 1 do
			local angle = (i / RING_DOTS) * math.pi * 2 - math.pi / 2
			local dot = make("Frame", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(0.5 + math.cos(angle) * 0.425, 0, 0.5 + math.sin(angle) * 0.425, 0),
				Size = UDim2.new(0, 3, 0, 3),
				BackgroundColor3 = color,
				BorderSizePixel = 0,
			}, ringBox)
			make("UICorner", { CornerRadius = UDim.new(1, 0) }, dot)
			dots[#dots + 1] = dot
		end
		iconImage(ringBox, spec, ctx.tintIcons and color or WHITE, math.min(spec[2], 18))

		label(toast, title, 62, 11, W - 76, 18, 13, C.text, true)
		label(toast, message, 62, 31, W - 76, 16, 12, C.muted)

		local lastLit = RING_DOTS
		return {
			wrapper = wrapper,
			toast = toast,
			startPos = UDim2.new(0, 40, 0, 0),
			restPos = UDim2.new(0, 0, 0, 0),
			baseColor = C[NOTIF_COLOR],
			hoverColor = cardHover(),
			progress = function(fraction)
				local lit = math.ceil(fraction * RING_DOTS)
				if lit >= lastLit then
					return
				end
				for i = lit + 1, lastLit do
					tween(dots[i], 0.15, { BackgroundTransparency = 0.82 })
				end
				lastLit = lit
			end,
		}
	end

	-- 5 · Solid: filled with the status color
	local function buildSolid(title, message, color, spec)
		local W, H = NOTIF_W, 58
		local onColor = contrastOn(color)
		local wrapper = newWrapper(cornerHolder, W, H)
		local toast = newToast(wrapper, {
			Position = UDim2.new(0, 40, 0, 0),
			Size = UDim2.new(0, W, 0, H),
			BackgroundColor3 = color,
			BackgroundTransparency = 0.04,
		}, 10, nil)

		local iconBox = frame(toast, 14, (H - 22) / 2, 22, 22)
		iconImage(iconBox, spec, onColor, math.min(spec[2] + 4, 22))

		label(toast, title, 48, 10, W - 62, 18, 13, onColor, true)
		label(toast, message, 48, 30, W - 62, 16, 12, onColor:Lerp(color, 0.35))

		return {
			wrapper = wrapper,
			toast = toast,
			startPos = UDim2.new(0, 40, 0, 0),
			restPos = UDim2.new(0, 0, 0, 0),
			baseColor = color,
			hoverColor = color:Lerp(WHITE, 0.12),
		}
	end

	local STYLES = {
		["1"] = buildStripe,
		["2"] = buildPill,
		["3"] = buildIsland,
		["4"] = buildRing,
		["5"] = buildSolid,
	}

	local function resolveKey()
		local raw = ctx.getStyle and ctx.getStyle() or "1"
		local key = (tostring(raw):lower():gsub("%s+", ""))
		key = STYLE_BY_NAME[key] or key
		return STYLES[key] and key or "1"
	end

	local function resolveStyle()
		return STYLES[resolveKey()]
	end

	local function notify(title, message, kind, iconKey, duration)
		kind = kind or "info"
		duration = duration or 3.5
		title = tostring(title or "")
		message = tostring(message or "")
		local color = kindColor(kind)
		local spec = ICONS[iconKey] or (kind == "error" and ICONS.close or ICONS.key)

		notifCount += 1
		Blur.acquire()

		local n = resolveStyle()(title, message, color, spec)
		local wrapper, toast = n.wrapper, n.toast

		local items = prep(toast)
		fade(items, 0)

		local handle = {}
		local dismissed = false
		function handle.dismiss()
			if dismissed then
				return
			end
			dismissed = true
			Blur.release()
			local idx = table.find(activeNotifs, handle)
			if idx then
				table.remove(activeNotifs, idx)
			end
			if n.leave then
				n.leave(items)
			else
				fade(items, 0, 0.25)
				tween(toast, 0.3, { Position = n.startPos }, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
			end
			task.delay(0.28, function()
				local size = wrapper.Size
				local height = wrapper.AbsoluteSize.Y
				wrapper.AutomaticSize = Enum.AutomaticSize.None
				wrapper.Size = UDim2.new(size.X.Scale, size.X.Offset, 0, height)
				tween(wrapper, 0.2, { Size = UDim2.new(size.X.Scale, size.X.Offset, 0, 0) })
				task.delay(0.22, function()
					wrapper:Destroy()
				end)
			end)
		end

		toast.MouseButton1Click:Connect(handle.dismiss)

		if n.enter then
			n.enter(items)
		else
			fade(items, 1, 0.3)
			tween(toast, 0.45, { Position = n.restPos }, Enum.EasingStyle.Quint)
		end

		local hovering, hoverSince = false, 0
		toast.MouseEnter:Connect(function()
			if dismissed then
				return
			end
			hovering = true
			hoverSince = os.clock()
			tween(toast, 0.15, { BackgroundColor3 = n.hoverColor })
		end)
		toast.MouseLeave:Connect(function()
			if dismissed then
				return
			end
			hovering = false
			tween(toast, 0.15, { BackgroundColor3 = n.baseColor })
		end)

		task.spawn(function()
			local remaining = duration
			local started = os.clock()
			local last = started
			while not dismissed do
				task.wait(0.05)
				local now = os.clock()
				if not (hovering and now - hoverSince < 8) then
					remaining -= now - last
				end
				last = now
				if n.progress and now - started > 0.35 then
					n.progress(math.clamp(remaining / duration, 0, 1))
				end
				if remaining <= 0 then
					handle.dismiss()
					break
				end
			end
		end)

		table.insert(activeNotifs, handle)
		while #activeNotifs > MAX_NOTIFS do
			activeNotifs[1].dismiss()
		end

		return handle
	end

	local function dismissAll()
		for i = #activeNotifs, 1, -1 do
			activeNotifs[i].dismiss()
		end
	end

	return {
		notify = notify,
		dismissAll = dismissAll,
		styleKey = resolveKey,
		blur = Blur,
	}
end

return Notification
end

__modules["components/window/pages"] = function()
-- src/components/window/pages.lua
-- Page 2 of the window. It sits right below the Key System: a down arrow at the bottom
-- of the Key System slides the Key System up and brings this page in (a topbar, the Tabs
-- under it, and the content of the selected Tab: Sections and Paragraphs).
--
--   local OphynWindow = KeySystem.new({ ... })
--
--   local Tab = OphynWindow({ Title = "Main", Icon = "rbxassetid://..." })
--
--   Tab:Section({ Title = "Section", Icon = "rbxassetid://..." })
--
--   -- Tabs style: KeySystem:SetTabsStyle("1") = column on the left (default),
--   --             KeySystem:SetTabsStyle("2") = row right under the topbar.
--
--   -- Every Icon also accepts a Lucide icon name (https://lucide.dev/icons), loaded from
--   -- github.com/Footagesus/Icons the first time one is used:
--   local Tab = OphynWindow({ Title = "Main", Icon = "house" })
--   Tab:Section({ Title = "Section", Icon = "lucide:settings" })
--
--   Tab:Paragraph({
--       Title = "Paragraph",
--       Desc = "Test Paragraph",
--       Color = "Red", -- leave it blank to follow the theme
--       Buttons = { { Icon = "rbxassetid://...", Title = "Button 1", Callback = function() end } },
--   })

local Pages = {}

local NAMED_COLORS = {
	red = Color3.fromRGB(229, 57, 53),
	orange = Color3.fromRGB(245, 124, 0),
	yellow = Color3.fromRGB(250, 204, 21),
	green = Color3.fromRGB(34, 160, 80),
	teal = Color3.fromRGB(20, 160, 150),
	cyan = Color3.fromRGB(6, 182, 212),
	blue = Color3.fromRGB(59, 130, 246),
	indigo = Color3.fromRGB(99, 102, 241),
	purple = Color3.fromRGB(147, 51, 234),
	pink = Color3.fromRGB(236, 72, 153),
	grey = Color3.fromRGB(100, 100, 108),
	gray = Color3.fromRGB(100, 100, 108),
	white = Color3.fromRGB(245, 245, 245),
	black = Color3.fromRGB(16, 16, 16),
}

-- Accepts a Color3, a color name ("Red", "Blue", ...) or a hex string ("#RRGGBB").
-- Returns nil for anything else, which makes the Paragraph follow the theme.
local function parseColor(value)
	if value == nil or value == "" then
		return nil
	end
	if typeof(value) == "Color3" then
		return value
	end
	if type(value) == "string" then
		local named = NAMED_COLORS[value:lower()]
		if named then
			return named
		end
		local hex = value:match("^#?(%x%x%x%x%x%x)$")
		if hex then
			return Color3.fromHex(hex)
		end
	end
	return nil
end

function Pages.new(ctx)
	local C, make, round = ctx.C, ctx.make, ctx.round
	local tween, prep, fade = ctx.tween, ctx.prep, ctx.fade
	local setRole, icon, assetId = ctx.setRole, ctx.icon, ctx.assetId
	local contrastOn, iconRole, logoRole = ctx.contrastOn, ctx.iconRole, ctx.logoRole
	local FONT, FONT_BOLD, Images = ctx.FONT, ctx.FONT_BOLD, ctx.images
	local state, content, canvas = ctx.state, ctx.content, ctx.canvas
	local W, H = ctx.width, ctx.height

	local TOPBAR_H = 38
	local SIDE_W = 124
	local SLIDE_TIME = 0.55
	local Quint = Enum.EasingStyle.Quint

	-- Section title look: a bit bigger than before and slightly see-through
	local SECTION_TEXT_SIZE = 15
	local SECTION_TEXT_TRANSPARENCY = 0.35

	-- Switching Tabs: the content rises a few pixels while its elements fade in one after
	-- the other (the stagger is capped so a Tab with many elements doesn't feel slow)
	local TAB_SLIDE = 10
	local TAB_IN_TIME = 0.32
	local TAB_STAGGER = 0.045
	local TAB_STAGGER_MAX = 0.4

	-- Both arrows (down: show the Tabs / up: back to the Key System) reuse the Submit
	-- button's icon. If that icon points right, 90 turns it to point down and -90 up;
	-- change this if the arrows end up facing the wrong way.
	local NEXT_ARROW_ROTATION = 90
	local BACK_ARROW_ROTATION = -NEXT_ARROW_ROTATION

	-- Tabs style 2 (a row under the topbar)
	local TABS_BAR_H = 34
	local TAB_H_STYLE2 = 26

	-- false when "Change icons color" is off: icons stay white and are never recolored
	local tintIcons = type(iconRole("muted")) == "string"

	-- The arrows: the Submit button's icon in one single ImageLabel, rotated on the label
	-- itself (not on a parent frame) and placed with plain offsets, so it renders right
	-- from the first frame. `drop` pushes it down a few pixels inside its button.
	local function arrowIcon(parent, rotation, drop)
		local img = make("ImageLabel", {
			Name = "ArrowIcon",
			Position = UDim2.new(0.5, -8, 0.5, -8 + (drop or 0)),
			Size = UDim2.new(0, 16, 0, 16),
			BackgroundTransparency = 1,
			Image = Images.SUBMIT,
			ImageColor3 = iconRole("muted"),
			Rotation = rotation,
			ZIndex = 6,
		}, parent)
		task.spawn(function()
			pcall(function()
				game:GetService("ContentProvider"):PreloadAsync({ img })
			end)
		end)
		return img
	end

	local function tintArrow(img, color)
		if tintIcons then
			tween(img, 0.15, { ImageColor3 = color })
		end
	end

	local function line(parent, x, y, w, h)
		return make("Frame", {
			Position = UDim2.new(0, x, 0, y),
			Size = UDim2.new(0, w, 0, h),
			BackgroundColor3 = "stroke",
			BackgroundTransparency = 0,
			BorderSizePixel = 0,
		}, parent)
	end

	---------------------------------------------------------------------------
	-- The page itself: starts one window-height below, hidden
	---------------------------------------------------------------------------
	local page = make("Frame", {
		Name = "Page2",
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, H),
		Size = UDim2.new(0, W, 0, H),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Visible = false,
	}, canvas)

	-- Topbar: logo + title on the left, back arrow + close on the right
	local topbar = make("Frame", {
		Name = "Topbar",
		Size = UDim2.new(0, W, 0, TOPBAR_H),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
	}, page)

	make("ImageLabel", {
		Position = UDim2.new(0, 14, 0, 9),
		Size = UDim2.new(0, 24, 0, 20),
		BackgroundTransparency = 1,
		Image = ctx.logo,
		ImageColor3 = logoRole("accent"),
		ScaleType = Enum.ScaleType.Fit,
	}, topbar)

	local pageTitle = make("TextLabel", {
		Position = UDim2.new(0, 46, 0, 0),
		Size = UDim2.new(0, W - 46 - 84, 1, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Text = ctx.title,
		TextSize = 14,
		TextColor3 = "text",
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Center,
		TextTruncate = Enum.TextTruncate.AtEnd,
		FontFace = FONT_BOLD,
	}, topbar)
	ctx.markTitleFont(pageTitle)

	local function topButton(rightOffset)
		local btn = make("TextButton", {
			Name = "TopButton",
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.new(1, -rightOffset, 0, 6),
			Size = UDim2.new(0, 26, 0, 26),
			BackgroundColor3 = "card",
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			AutoButtonColor = false,
			Text = "",
			ZIndex = 5,
		}, topbar)
		make("UICorner", { CornerRadius = UDim.new(0, 7) }, btn)
		return btn
	end

	local closeBtn = topButton(12)
	local closeIcon = make("ImageLabel", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = UDim2.new(0, 12, 0, 12),
		BackgroundTransparency = 1,
		Image = Images.CLOSE_ICON,
		ImageColor3 = iconRole("muted"),
		ZIndex = 6,
	}, closeBtn)

	local backBtn = topButton(40)
	local backIcon = arrowIcon(backBtn, BACK_ARROW_ROTATION, 0)

	closeBtn.MouseEnter:Connect(function()
		tween(closeBtn, 0.15, { BackgroundTransparency = 0 })
		if tintIcons then
			tween(closeIcon, 0.15, { ImageColor3 = C.text })
		end
	end)
	closeBtn.MouseLeave:Connect(function()
		tween(closeBtn, 0.15, { BackgroundTransparency = 1 })
		if tintIcons then
			tween(closeIcon, 0.15, { ImageColor3 = C.muted })
		end
	end)
	backBtn.MouseEnter:Connect(function()
		tween(backBtn, 0.15, { BackgroundTransparency = 0 })
		tintArrow(backIcon, C.text)
	end)
	backBtn.MouseLeave:Connect(function()
		tween(backBtn, 0.15, { BackgroundTransparency = 1 })
		tintArrow(backIcon, C.muted)
	end)

	-- Tabs style: "1" = column on the left, "2" = row right under the topbar
	local tabsStyle = "1"
	local function normalizeStyle(value)
		value = tostring(value or "1"):lower()
		if value == "2" or value == "horizontal" or value == "row" then
			return "2"
		end
		return "1"
	end
	if ctx.getTabsStyle then
		tabsStyle = normalizeStyle(ctx.getTabsStyle())
	end

	-- Style 1 draws the line under the topbar; style 2 draws it under the row of Tabs
	local topLine = line(page, 14, TOPBAR_H, W - 28, 1)
	local tabsLine = line(page, 14, TOPBAR_H + TABS_BAR_H, W - 28, 1)
	local sideLine = line(page, SIDE_W, TOPBAR_H + 10, 1, H - TOPBAR_H - 20)

	-- Tabs (a column in style 1, a row in style 2)
	local sidebar = make("ScrollingFrame", {
		Name = "Tabs",
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		CanvasSize = UDim2.new(0, 0, 0, 0),
		ElasticBehavior = Enum.ElasticBehavior.Never,
		ScrollBarThickness = 0,
	}, page)
	local sideLayout = make("UIListLayout", {
		Padding = UDim.new(0, 4),
		SortOrder = Enum.SortOrder.LayoutOrder,
	}, sidebar)
	local sidePadding = make("UIPadding", {}, sidebar)

	-- Where the selected Tab's content shows up
	local holder = make("Frame", {
		Name = "TabContent",
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ClipsDescendants = true,
	}, page)

	-- mouse wheel scrolls the row sideways in style 2
	sidebar.InputChanged:Connect(function(input)
		if tabsStyle == "2" and input.UserInputType == Enum.UserInputType.MouseWheel then
			local maxX = math.max(0, sidebar.AbsoluteCanvasSize.X - sidebar.AbsoluteWindowSize.X)
			local x = sidebar.CanvasPosition.X - input.Position.Z * 30
			sidebar.CanvasPosition = Vector2.new(math.clamp(x, 0, maxX), 0)
		end
	end)

	local tabs = {}
	local current = nil

	local function applyTabsStyle()
		local row = tabsStyle == "2"

		topLine.Visible = not row
		sideLine.Visible = not row
		tabsLine.Visible = row

		sidebar.CanvasPosition = Vector2.new(0, 0)
		sidebar.AutomaticCanvasSize = Enum.AutomaticSize.None
		sidebar.CanvasSize = UDim2.new(0, 0, 0, 0)
		if row then
			sidebar.Position = UDim2.new(0, 0, 0, TOPBAR_H)
			sidebar.Size = UDim2.new(0, W, 0, TABS_BAR_H)
			sidebar.ScrollingDirection = Enum.ScrollingDirection.X
			sidebar.AutomaticCanvasSize = Enum.AutomaticSize.X
			sideLayout.FillDirection = Enum.FillDirection.Horizontal
			sideLayout.VerticalAlignment = Enum.VerticalAlignment.Center
			sidePadding.PaddingTop = UDim.new(0, 0)
			sidePadding.PaddingBottom = UDim.new(0, 0)
			sidePadding.PaddingLeft = UDim.new(0, 12)
			sidePadding.PaddingRight = UDim.new(0, 12)

			holder.Position = UDim2.new(0, 0, 0, TOPBAR_H + TABS_BAR_H + 1)
			holder.Size = UDim2.new(0, W, 0, H - TOPBAR_H - TABS_BAR_H - 1)
		else
			sidebar.Position = UDim2.new(0, 0, 0, TOPBAR_H + 1)
			sidebar.Size = UDim2.new(0, SIDE_W, 0, H - TOPBAR_H - 1)
			sidebar.ScrollingDirection = Enum.ScrollingDirection.Y
			sidebar.AutomaticCanvasSize = Enum.AutomaticSize.Y
			sideLayout.FillDirection = Enum.FillDirection.Vertical
			sideLayout.VerticalAlignment = Enum.VerticalAlignment.Top
			sidePadding.PaddingTop = UDim.new(0, 10)
			sidePadding.PaddingBottom = UDim.new(0, 10)
			sidePadding.PaddingLeft = UDim.new(0, 10)
			sidePadding.PaddingRight = UDim.new(0, 10)

			holder.Position = UDim2.new(0, SIDE_W + 1, 0, TOPBAR_H + 1)
			holder.Size = UDim2.new(0, W - SIDE_W - 1, 0, H - TOPBAR_H - 1)
		end

		for _, tab in ipairs(tabs) do
			tab.applyStyle()
		end
		if current then
			current.refresh()
		end
	end

	---------------------------------------------------------------------------
	-- Sliding between the Key System and this page
	---------------------------------------------------------------------------
	local opened, moving = false, false

	local function open()
		if opened or moving then
			return
		end
		opened, moving = true, true
		if ctx.onOpen then
			ctx.onOpen()
		end
		if current then
			current.refresh()
		end
		page.Visible = true
		tween(page, SLIDE_TIME, { Position = UDim2.new(0.5, 0, 0.5, 0) }, Quint)
		tween(content, SLIDE_TIME, { Position = UDim2.new(0.5, 0, 0.5, -H) }, Quint)
		task.delay(SLIDE_TIME + 0.05, function()
			moving = false
		end)
	end

	local function back()
		if not opened or moving then
			return
		end
		opened, moving = false, true
		tween(page, SLIDE_TIME, { Position = UDim2.new(0.5, 0, 0.5, H) }, Quint)
		tween(content, SLIDE_TIME, { Position = UDim2.new(0.5, 0, 0.5, 0) }, Quint)
		task.delay(SLIDE_TIME + 0.05, function()
			if not opened then
				page.Visible = false
			end
			moving = false
		end)
	end

	-- Used when the whole UI closes while this page is showing
	local function fadeOut(time)
		if not page.Visible then
			return
		end
		fade(prep(page), 0, time)
		task.delay(time, function()
			page.Visible = false
		end)
	end

	-- The down arrow, in the middle of the bottom of the Key System. It only shows up
	-- once there is at least one Tab, so a script that never creates one doesn't end up
	-- with an arrow that leads to an empty page.
	local nextBtn = make("TextButton", {
		Name = "NextPage",
		AnchorPoint = Vector2.new(0.5, 1),
		Position = UDim2.new(0, W / 2, 0, H - 2),
		Size = UDim2.new(0, 40, 0, 20),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		AutoButtonColor = false,
		Text = "",
		Visible = false,
		ZIndex = 5,
	}, content)
	-- Same icon as the Submit button (Images.SUBMIT), turned to point down
	local nextIcon = arrowIcon(nextBtn, NEXT_ARROW_ROTATION, 2)

	nextBtn.MouseEnter:Connect(function()
		tintArrow(nextIcon, C.text)
	end)
	nextBtn.MouseLeave:Connect(function()
		tintArrow(nextIcon, C.muted)
	end)
	nextBtn.MouseButton1Click:Connect(function()
		if not state.ready or state.closing then
			return
		end
		open()
	end)

	backBtn.MouseButton1Click:Connect(function()
		if not state.ready or state.closing then
			return
		end
		back()
	end)
	closeBtn.MouseButton1Click:Connect(function()
		ctx.requestClose()
	end)

	---------------------------------------------------------------------------
	-- Tabs
	---------------------------------------------------------------------------
	local function styleTab(tab, on)
		tween(tab.btn, 0.15, { BackgroundTransparency = on and 0 or 1 })
		setRole(tab.label, "TextColor3", on and "text" or "muted")
		if tab.iconImage then
			local role = iconRole(on and "accent" or "muted")
			if type(role) == "string" then
				setRole(tab.iconImage, "ImageColor3", role)
			end
		end
		tab.scroll.Visible = on
	end

	-- originals[inst][prop] = the resting transparency of that property, captured only once.
	-- Switching Tabs quickly (while an animation is still running) then never records a
	-- half-faded value as the "normal" one.
	local originals = setmetatable({}, { __mode = "k" })

	local function snapshot(child)
		local items = prep(child)
		for _, it in ipairs(items) do
			local saved = originals[it[1]]
			if not saved then
				saved = {}
				originals[it[1]] = saved
			end
			if saved[it[2]] == nil then
				saved[it[2]] = it[3]
			else
				it[3] = saved[it[2]]
			end
		end
		return items
	end

	-- Plays when a Tab becomes the selected one: the whole content rises a little and
	-- every element (Section / Paragraph) fades in, one after the other.
	local function animateIn(tab)
		tab.animId = (tab.animId or 0) + 1
		local id = tab.animId

		local children = {}
		for _, child in ipairs(tab.scroll:GetChildren()) do
			if child:IsA("GuiObject") then
				children[#children + 1] = child
			end
		end
		table.sort(children, function(a, b)
			return a.LayoutOrder < b.LayoutOrder
		end)
		if #children == 0 then
			return
		end

		local lists = {}
		for i, child in ipairs(children) do
			local items = snapshot(child)
			fade(items, 0) -- start fully transparent
			lists[i] = items
		end

		tab.scroll.Position = UDim2.new(0, 0, 0, TAB_SLIDE)
		tween(tab.scroll, TAB_IN_TIME + 0.08, { Position = UDim2.new(0, 0, 0, 0) }, Quint)

		local step = math.min(TAB_STAGGER, TAB_STAGGER_MAX / #children)
		for i, items in ipairs(lists) do
			task.delay((i - 1) * step, function()
				if tab.animId ~= id then
					return -- a newer animation took over this Tab
				end
				fade(items, 1, TAB_IN_TIME)
			end)
		end
	end

	local function selectTab(tab, animate)
		if current == tab then
			return
		end
		if current then
			styleTab(current, false)
		end
		current = tab
		styleTab(tab, true)
		tab.refresh()
		if animate ~= false and (opened or page.Visible) then
			animateIn(tab)
		end
	end

	-- OphynWindow({ Title = "...", Icon = "..." }) -> Tab
	local function createTab(props)
		if type(props) ~= "table" then
			props = { Title = props }
		end
		local title = props.Title ~= nil and tostring(props.Title) or "Tab"
		local image = assetId(props.Icon)

		local tab = {}

		-- Tab button: the icon comes first, then the text. The icon + text live in `inner`
		-- (it holds the layout and the side padding, so the button can size itself to the
		-- text in style 2).
		tab.btn = make("TextButton", {
			Name = "Tab",
			Size = UDim2.new(1, 0, 0, 30),
			BackgroundColor3 = "card",
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			AutoButtonColor = false,
			Text = "",
			LayoutOrder = #tabs + 1,
		}, sidebar)
		round(tab.btn, 7)

		tab.inner = make("Frame", {
			Name = "Inner",
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
		}, tab.btn)
		tab.pad = make("UIPadding", {}, tab.inner)
		make("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			Padding = UDim.new(0, 6),
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
		}, tab.inner)

		if image then
			local iconHolder = icon(tab.inner, 0, 0, "muted", image)
			iconHolder.LayoutOrder = 1
			tab.iconImage = iconHolder:FindFirstChild("iconimage")
		end

		tab.label = make("TextLabel", {
			Size = UDim2.new(1, image and -22 or 0, 1, 0),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Text = title,
			TextSize = 12,
			TextColor3 = "muted",
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Center,
			TextTruncate = Enum.TextTruncate.AtEnd,
			FontFace = FONT,
			LayoutOrder = 2,
		}, tab.inner)

		-- Lays the button out for the current Tabs style (also runs when the style changes)
		tab.applyStyle = function()
			if tabsStyle == "2" then
				tab.btn.Size = UDim2.new(0, 0, 0, TAB_H_STYLE2)
				tab.btn.AutomaticSize = Enum.AutomaticSize.X
				tab.inner.Size = UDim2.new(0, 0, 1, 0)
				tab.inner.AutomaticSize = Enum.AutomaticSize.X
				tab.pad.PaddingLeft = UDim.new(0, 10)
				tab.pad.PaddingRight = UDim.new(0, 12)
				tab.label.Size = UDim2.new(0, 0, 1, 0)
				tab.label.AutomaticSize = Enum.AutomaticSize.X
			else
				tab.btn.AutomaticSize = Enum.AutomaticSize.None
				tab.btn.Size = UDim2.new(1, 0, 0, 30)
				tab.inner.AutomaticSize = Enum.AutomaticSize.None
				tab.inner.Size = UDim2.new(1, 0, 1, 0)
				tab.pad.PaddingLeft = UDim.new(0, 12)
				tab.pad.PaddingRight = UDim.new(0, 8)
				tab.label.AutomaticSize = Enum.AutomaticSize.None
				tab.label.Size = UDim2.new(1, image and -22 or 0, 1, 0)
			end
		end
		tab.applyStyle()

		-- The content of this Tab
		tab.scroll = make("ScrollingFrame", {
			Name = "TabContent",
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			CanvasSize = UDim2.new(0, 0, 0, 0),
			ScrollingDirection = Enum.ScrollingDirection.Y,
			ElasticBehavior = Enum.ElasticBehavior.Never,
			VerticalScrollBarInset = Enum.ScrollBarInset.None,
			ScrollBarThickness = 2,
			ScrollBarImageTransparency = 0.45,
			Visible = false,
		}, holder)
		setRole(tab.scroll, "ScrollBarImageColor3", "muted")

		local layout = make("UIListLayout", {
			Padding = UDim.new(0, 8),
			SortOrder = Enum.SortOrder.LayoutOrder,
		}, tab.scroll)
		make("UIPadding", {
			PaddingTop = UDim.new(0, 12),
			PaddingBottom = UDim.new(0, 12),
			PaddingLeft = UDim.new(0, 12),
			PaddingRight = UDim.new(0, 14),
		}, tab.scroll)

		tab.refresh = function()
			tab.scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 24)
		end
		layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(tab.refresh)

		tab.btn.MouseEnter:Connect(function()
			if current ~= tab then
				tween(tab.btn, 0.12, { BackgroundTransparency = 0.5 })
			end
		end)
		tab.btn.MouseLeave:Connect(function()
			if current ~= tab then
				tween(tab.btn, 0.12, { BackgroundTransparency = 1 })
			end
		end)
		tab.btn.MouseButton1Click:Connect(function()
			if state.closing then
				return
			end
			selectTab(tab)
		end)

		tabs[#tabs + 1] = tab
		if not nextBtn.Visible then
			nextBtn.Visible = true
			-- first time the arrow shows up: make the engine request/draw its image again
			task.defer(function()
				nextIcon.Image = ""
				nextIcon.Image = Images.SUBMIT
			end)
		end
		if not current then
			selectTab(tab, false)
		end

		-- Tab:Section / Tab:Paragraph
		local order = 0
		local function nextOrder()
			order = order + 1
			return order
		end

		local obj = {}

		function obj:Select()
			selectTab(tab)
			return self
		end

		-- Tab:Section({ Title = "...", Icon = "..." }): the icon comes first, then the text
		function obj:Section(p)
			p = type(p) == "table" and p or {}
			local sectionImage = assetId(p.Icon)

			local row = make("Frame", {
				Name = "Section",
				Size = UDim2.new(1, 0, 0, 26),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				LayoutOrder = nextOrder(),
			}, tab.scroll)
			make("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				Padding = UDim.new(0, 7),
				VerticalAlignment = Enum.VerticalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
			}, row)

			if sectionImage then
				local iconHolder = icon(row, 0, 0, "accent", sectionImage)
				iconHolder.LayoutOrder = 1
			end

			local label = make("TextLabel", {
				Size = UDim2.new(1, sectionImage and -23 or 0, 1, 0),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Text = p.Title ~= nil and tostring(p.Title) or "Section",
				TextSize = SECTION_TEXT_SIZE,
				TextColor3 = "text",
				TextTransparency = SECTION_TEXT_TRANSPARENCY,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Center,
				TextTruncate = Enum.TextTruncate.AtEnd,
				FontFace = FONT_BOLD,
				LayoutOrder = 2,
			}, row)

			local section = { Frame = row }
			function section:SetTitle(str)
				label.Text = tostring(str)
				return self
			end
			function section:Destroy()
				row:Destroy()
			end
			return section
		end

		-- Tab:Paragraph({ Title, Desc, Color, Buttons = { { Icon, Title, Callback } } })
		function obj:Paragraph(p)
			p = type(p) == "table" and p or {}
			local color = parseColor(p.Color) -- nil: follows the theme
			local onColor = color and contrastOn(color) or nil

			local box = make("Frame", {
				Name = "Paragraph",
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundColor3 = color or "card",
				BackgroundTransparency = 0,
				BorderSizePixel = 0,
				LayoutOrder = nextOrder(),
			}, tab.scroll)
			round(box, 8, (not color) and "stroke" or nil)
			make("UIPadding", {
				PaddingTop = UDim.new(0, 10),
				PaddingBottom = UDim.new(0, 10),
				PaddingLeft = UDim.new(0, 12),
				PaddingRight = UDim.new(0, 12),
			}, box)
			make("UIListLayout", {
				Padding = UDim.new(0, 6),
				SortOrder = Enum.SortOrder.LayoutOrder,
			}, box)

			local function paragraphLabel(layoutOrder, size, font, textColor, str, transparency)
				return make("TextLabel", {
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Text = str,
					TextSize = size,
					TextColor3 = textColor,
					TextTransparency = transparency,
					TextWrapped = true,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Top,
					FontFace = font,
					LayoutOrder = layoutOrder,
					Visible = str ~= "",
				}, box)
			end

			local titleText = p.Title ~= nil and tostring(p.Title) or ""
			local descText = p.Desc ~= nil and tostring(p.Desc) or ""
			local titleLabel = paragraphLabel(1, 13, FONT_BOLD, onColor or "text", titleText, 0)
			local descLabel = paragraphLabel(2, 12, FONT, onColor or "muted", descText, onColor and 0.2 or 0)

			local buttons = type(p.Buttons) == "table" and p.Buttons or {}
			if #buttons > 0 then
				local row = make("Frame", {
					Name = "Buttons",
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					LayoutOrder = 3,
				}, box)
				make("UIListLayout", {
					FillDirection = Enum.FillDirection.Horizontal,
					Wraps = true,
					Padding = UDim.new(0, 6),
					SortOrder = Enum.SortOrder.LayoutOrder,
				}, row)

				for i, b in ipairs(buttons) do
					if type(b) == "table" then
						local btn = make("TextButton", {
							Name = "Button",
							Size = UDim2.new(0, 0, 0, 26),
							AutomaticSize = Enum.AutomaticSize.X,
							BackgroundColor3 = color and onColor or "btn2",
							BackgroundTransparency = color and 0.86 or 0,
							BorderSizePixel = 0,
							AutoButtonColor = false,
							Text = "",
							LayoutOrder = i,
						}, row)
						round(btn, 7, (not color) and "stroke" or nil)
						make("UIPadding", {
							PaddingLeft = UDim.new(0, 9),
							PaddingRight = UDim.new(0, 10),
						}, btn)
						make("UIListLayout", {
							FillDirection = Enum.FillDirection.Horizontal,
							Padding = UDim.new(0, 6),
							VerticalAlignment = Enum.VerticalAlignment.Center,
							SortOrder = Enum.SortOrder.LayoutOrder,
						}, btn)

						-- icon first, then the text
						local buttonImage = assetId(b.Icon)
						if buttonImage then
							local iconHolder = icon(btn, 0, 0, onColor or "text", buttonImage)
							iconHolder.LayoutOrder = 1
						end
						make("TextLabel", {
							Size = UDim2.new(0, 0, 1, 0),
							AutomaticSize = Enum.AutomaticSize.X,
							BackgroundTransparency = 1,
							BorderSizePixel = 0,
							Text = b.Title ~= nil and tostring(b.Title) or "Button",
							TextSize = 12,
							TextColor3 = onColor or "text",
							TextXAlignment = Enum.TextXAlignment.Left,
							TextYAlignment = Enum.TextYAlignment.Center,
							FontFace = FONT,
							LayoutOrder = 2,
						}, btn)

						btn.MouseEnter:Connect(function()
							if color then
								tween(btn, 0.12, { BackgroundTransparency = 0.72 })
							else
								tween(btn, 0.12, { BackgroundColor3 = C.btn2Hover })
							end
						end)
						btn.MouseLeave:Connect(function()
							if color then
								tween(btn, 0.12, { BackgroundTransparency = 0.86 })
							else
								tween(btn, 0.12, { BackgroundColor3 = C.btn2 })
							end
						end)
						btn.MouseButton1Click:Connect(function()
							if state.closing or type(b.Callback) ~= "function" then
								return
							end
							task.spawn(function()
								local ok, err = pcall(b.Callback)
								if not ok then
									warn("[Ophyn] Button callback error: " .. tostring(err))
								end
							end)
						end)
					end
				end
			end

			local paragraph = { Frame = box }
			function paragraph:SetTitle(str)
				titleLabel.Text = tostring(str)
				titleLabel.Visible = titleLabel.Text ~= ""
				return self
			end
			function paragraph:SetDesc(str)
				descLabel.Text = tostring(str)
				descLabel.Visible = descLabel.Text ~= ""
				return self
			end
			function paragraph:Destroy()
				box:Destroy()
			end
			return paragraph
		end

		return obj
	end

	applyTabsStyle()

	-- KeySystem:SetTabsStyle("1" / "2") works before or after the window exists: ui.lua
	-- calls this applier whenever the style changes. It returns false once the window is gone.
	if ctx.registerTabsStyle then
		ctx.registerTabsStyle(function()
			if not page.Parent then
				return false
			end
			local style = normalizeStyle(ctx.getTabsStyle and ctx.getTabsStyle())
			if style ~= tabsStyle then
				tabsStyle = style
				applyTabsStyle()
			end
			return true
		end)
	end

	return {
		createTab = createTab,
		open = open,
		back = back,
		fadeOut = fadeOut,
		isOpen = function()
			return opened
		end,
	}
end

return Pages
end

__modules["components/window/ui"] = function()
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local MarketplaceService = game:GetService("MarketplaceService")
local player = Players.LocalPlayer

local Images = import("images/images")
local Notification = import("components/window/notification")
local Variables = import("variables")
local Jnkie = import("utilities/jnkie")
local Platoboost = import("utilities/platoboost")
local Panda = import("utilities/panda")
local Pages = import("components/window/pages")
local Lucide = import("utilities/lucide")

local FONT = Font.new(Images.FONT, Enum.FontWeight.Regular, Enum.FontStyle.Normal)
local FONT_BOLD = Font.new(Images.FONT, Enum.FontWeight.Bold, Enum.FontStyle.Normal)
local GLOW = Images.GLOW
local CLOSE_ICON = Images.CLOSE_ICON
local MOON_ICON = Images.MOON_ICON

local FINAL_W, FINAL_H = 460, 260

local NOTIF_W, NOTIF_H = 300, 70
local NOTIF_TRANSPARENCY = 0.28
local NOTIF_COLOR = "bg"
local NOTIF_BLUR = 6

local CHECK_TIME = 1
local SAVED_CHECK_TIME = 0.15

local WHITE = Color3.fromRGB(255, 255, 255)
local settings = { tintIcons = true, tintLogo = true }

local function asBool(v, default)
	if v == nil then
		return default
	end
	if type(v) == "string" then
		return v:lower() == "true"
	end
	return v == true
end

local function assetId(v)
	if v == nil or v == "" then
		return nil
	end
	local str = tostring(v)
	if str:match("^%d+$") then
		return "rbxassetid://" .. str
	end
	return str
end

local function iconRole(role)
	return settings.tintIcons and role or WHITE
end
local function logoRole(role)
	return settings.tintLogo and role or WHITE
end

local THEME_ORDER = {
	"Carmim",
	"Plant",
	"Plant-Dark",
	"Dark",
	"Light",
	"Violet",
	"Midnight",
	"Amber",
	"Indigo",
	"Amethyst",
}

local THEMES = {
	Amethyst = {
		bg = Color3.fromRGB(20, 16, 20),
		input = Color3.fromRGB(24, 19, 24),
		card = Color3.fromRGB(28, 22, 28),
		stroke = Color3.fromRGB(40, 32, 41),
		btn2 = Color3.fromRGB(42, 36, 43),
		btn2Hover = Color3.fromRGB(54, 47, 55),
		text = Color3.fromRGB(233, 229, 234),
		muted = Color3.fromRGB(125, 115, 126),
		accent = Color3.fromRGB(235, 199, 246),
		warn = Color3.fromRGB(240, 176, 108),
		success = Color3.fromRGB(120, 210, 140),
		error = Color3.fromRGB(240, 120, 120),

		submitBg = Color3.fromRGB(235, 199, 246),
		submitText = Color3.fromRGB(24, 18, 26),

		glowBase = Color3.fromRGB(226, 218, 230),
		glowFrom = Color3.fromRGB(255, 255, 255),
		glowTo = Color3.fromRGB(235, 199, 246),

		confetti = {
			Color3.fromRGB(235, 199, 246),
			Color3.fromRGB(120, 210, 140),
			Color3.fromRGB(255, 255, 255),
			Color3.fromRGB(240, 176, 108),
			Color3.fromRGB(150, 190, 255),
		},
	},

	Carmim = {
		bg = Color3.fromRGB(10, 10, 10),
		input = Color3.fromRGB(16, 14, 14),
		card = Color3.fromRGB(20, 17, 17),
		stroke = Color3.fromRGB(38, 32, 32),
		btn2 = Color3.fromRGB(32, 28, 28),
		btn2Hover = Color3.fromRGB(46, 40, 40),
		text = Color3.fromRGB(240, 236, 236),
		muted = Color3.fromRGB(130, 122, 122),
		accent = Color3.fromRGB(230, 45, 55),
		warn = Color3.fromRGB(240, 176, 108),
		success = Color3.fromRGB(120, 210, 140),
		error = Color3.fromRGB(240, 120, 120),

		submitBg = Color3.fromRGB(139, 17, 27),
		submitText = Color3.fromRGB(255, 255, 255),

		glowBase = Color3.fromRGB(255, 120, 120),
		glowFrom = Color3.fromRGB(255, 90, 90),
		glowTo = Color3.fromRGB(200, 20, 35),

		confetti = {
			Color3.fromRGB(230, 45, 55),
			Color3.fromRGB(255, 120, 120),
			Color3.fromRGB(255, 255, 255),
			Color3.fromRGB(240, 176, 108),
			Color3.fromRGB(150, 20, 30),
		},
	},

	Plant = {
		bg = Color3.fromRGB(28, 94, 56),
		input = Color3.fromRGB(23, 78, 46),
		card = Color3.fromRGB(34, 108, 65),
		stroke = Color3.fromRGB(58, 140, 92),
		btn2 = Color3.fromRGB(44, 122, 74),
		btn2Hover = Color3.fromRGB(56, 140, 88),
		text = Color3.fromRGB(255, 255, 255),
		muted = Color3.fromRGB(188, 226, 202),
		accent = Color3.fromRGB(255, 255, 255),
		warn = Color3.fromRGB(255, 214, 140),
		success = Color3.fromRGB(200, 255, 210),
		error = Color3.fromRGB(255, 150, 150),

		submitBg = Color3.fromRGB(96, 205, 122),
		submitText = Color3.fromRGB(14, 66, 36),

		glowBase = Color3.fromRGB(255, 255, 255),
		glowFrom = Color3.fromRGB(255, 255, 255),
		glowTo = Color3.fromRGB(235, 255, 240),

		confetti = {
			Color3.fromRGB(255, 255, 255),
			Color3.fromRGB(150, 235, 170),
			Color3.fromRGB(96, 205, 122),
			Color3.fromRGB(255, 214, 140),
			Color3.fromRGB(210, 255, 220),
		},
	},

	["Plant-Dark"] = {
		bg = Color3.fromRGB(10, 10, 10),
		input = Color3.fromRGB(14, 16, 14),
		card = Color3.fromRGB(18, 22, 19),
		stroke = Color3.fromRGB(34, 42, 36),
		btn2 = Color3.fromRGB(28, 34, 29),
		btn2Hover = Color3.fromRGB(40, 48, 42),
		text = Color3.fromRGB(238, 242, 238),
		muted = Color3.fromRGB(122, 132, 124),
		accent = Color3.fromRGB(70, 214, 110),
		warn = Color3.fromRGB(240, 176, 108),
		success = Color3.fromRGB(120, 220, 150),
		error = Color3.fromRGB(240, 120, 120),

		submitBg = Color3.fromRGB(22, 101, 52),
		submitText = Color3.fromRGB(255, 255, 255),

		glowBase = Color3.fromRGB(110, 255, 150),
		glowFrom = Color3.fromRGB(90, 240, 130),
		glowTo = Color3.fromRGB(30, 170, 70),

		confetti = {
			Color3.fromRGB(70, 214, 110),
			Color3.fromRGB(150, 245, 175),
			Color3.fromRGB(255, 255, 255),
			Color3.fromRGB(240, 176, 108),
			Color3.fromRGB(22, 101, 52),
		},
	},

	Dark = {
		bg = Color3.fromRGB(10, 10, 10),
		input = Color3.fromRGB(18, 18, 18),
		card = Color3.fromRGB(23, 23, 23),
		stroke = Color3.fromRGB(46, 46, 46),
		btn2 = Color3.fromRGB(34, 34, 34),
		btn2Hover = Color3.fromRGB(48, 48, 48),
		text = Color3.fromRGB(255, 255, 255),
		muted = Color3.fromRGB(150, 150, 150),
		accent = Color3.fromRGB(255, 255, 255),
		warn = Color3.fromRGB(240, 176, 108),
		success = Color3.fromRGB(120, 210, 140),
		error = Color3.fromRGB(240, 120, 120),

		submitBg = Color3.fromRGB(66, 66, 66),
		submitText = Color3.fromRGB(255, 255, 255),

		glowBase = Color3.fromRGB(255, 255, 255),
		glowFrom = Color3.fromRGB(255, 255, 255),
		glowTo = Color3.fromRGB(210, 210, 210),

		confetti = {
			Color3.fromRGB(255, 255, 255),
			Color3.fromRGB(200, 200, 200),
			Color3.fromRGB(140, 140, 140),
			Color3.fromRGB(240, 176, 108),
			Color3.fromRGB(120, 210, 140),
		},
	},

	Light = {
		bg = Color3.fromRGB(255, 255, 255),
		input = Color3.fromRGB(240, 240, 240),
		card = Color3.fromRGB(245, 245, 245),
		stroke = Color3.fromRGB(216, 216, 216),
		btn2 = Color3.fromRGB(232, 232, 232),
		btn2Hover = Color3.fromRGB(218, 218, 218),
		text = Color3.fromRGB(10, 10, 10),
		muted = Color3.fromRGB(110, 110, 110),
		accent = Color3.fromRGB(10, 10, 10),
		warn = Color3.fromRGB(196, 116, 24),
		success = Color3.fromRGB(28, 150, 72),
		error = Color3.fromRGB(210, 58, 58),

		submitBg = Color3.fromRGB(20, 20, 20),
		submitText = Color3.fromRGB(255, 255, 255),

		glowBase = Color3.fromRGB(30, 30, 30),
		glowFrom = Color3.fromRGB(60, 60, 60),
		glowTo = Color3.fromRGB(0, 0, 0),

		confetti = {
			Color3.fromRGB(10, 10, 10),
			Color3.fromRGB(90, 90, 90),
			Color3.fromRGB(160, 160, 160),
			Color3.fromRGB(230, 150, 50),
			Color3.fromRGB(50, 170, 100),
		},
	},

	Violet = {
		bg = Color3.fromRGB(94, 64, 162),
		input = Color3.fromRGB(78, 52, 140),
		card = Color3.fromRGB(108, 78, 180),
		stroke = Color3.fromRGB(136, 108, 204),
		btn2 = Color3.fromRGB(120, 90, 192),
		btn2Hover = Color3.fromRGB(136, 106, 208),
		text = Color3.fromRGB(255, 255, 255),
		muted = Color3.fromRGB(214, 202, 242),
		accent = Color3.fromRGB(255, 255, 255),
		warn = Color3.fromRGB(255, 214, 140),
		success = Color3.fromRGB(200, 255, 210),
		error = Color3.fromRGB(255, 160, 170),

		submitBg = Color3.fromRGB(58, 32, 112),
		submitText = Color3.fromRGB(255, 255, 255),

		glowBase = Color3.fromRGB(255, 255, 255),
		glowFrom = Color3.fromRGB(255, 255, 255),
		glowTo = Color3.fromRGB(240, 232, 255),

		confetti = {
			Color3.fromRGB(255, 255, 255),
			Color3.fromRGB(214, 190, 255),
			Color3.fromRGB(170, 130, 255),
			Color3.fromRGB(255, 214, 140),
			Color3.fromRGB(58, 32, 112),
		},
	},

	Midnight = {
		bg = Color3.fromRGB(26, 44, 104),
		input = Color3.fromRGB(18, 32, 80),
		card = Color3.fromRGB(34, 56, 124),
		stroke = Color3.fromRGB(62, 88, 158),
		btn2 = Color3.fromRGB(44, 70, 142),
		btn2Hover = Color3.fromRGB(58, 86, 164),
		text = Color3.fromRGB(255, 255, 255),
		muted = Color3.fromRGB(190, 204, 240),
		accent = Color3.fromRGB(255, 255, 255),
		warn = Color3.fromRGB(255, 214, 140),
		success = Color3.fromRGB(190, 255, 215),
		error = Color3.fromRGB(255, 150, 160),

		submitBg = Color3.fromRGB(52, 92, 196),
		submitText = Color3.fromRGB(255, 255, 255),

		glowBase = Color3.fromRGB(255, 255, 255),
		glowFrom = Color3.fromRGB(255, 255, 255),
		glowTo = Color3.fromRGB(226, 236, 255),

		confetti = {
			Color3.fromRGB(255, 255, 255),
			Color3.fromRGB(170, 200, 255),
			Color3.fromRGB(100, 150, 255),
			Color3.fromRGB(255, 214, 140),
			Color3.fromRGB(52, 92, 196),
		},
	},

	Amber = {
		bg = Color3.fromRGB(160, 84, 16),
		input = Color3.fromRGB(132, 68, 10),
		card = Color3.fromRGB(176, 98, 28),
		stroke = Color3.fromRGB(206, 132, 62),
		btn2 = Color3.fromRGB(186, 108, 38),
		btn2Hover = Color3.fromRGB(200, 122, 52),
		text = Color3.fromRGB(255, 255, 255),
		muted = Color3.fromRGB(255, 228, 196),
		accent = Color3.fromRGB(255, 255, 255),
		warn = Color3.fromRGB(255, 240, 170),
		success = Color3.fromRGB(215, 255, 205),
		error = Color3.fromRGB(110, 18, 18),

		submitBg = Color3.fromRGB(110, 50, 6),
		submitText = Color3.fromRGB(255, 255, 255),

		glowBase = Color3.fromRGB(255, 255, 255),
		glowFrom = Color3.fromRGB(255, 255, 255),
		glowTo = Color3.fromRGB(255, 240, 220),

		confetti = {
			Color3.fromRGB(255, 255, 255),
			Color3.fromRGB(255, 220, 160),
			Color3.fromRGB(255, 180, 90),
			Color3.fromRGB(255, 240, 170),
			Color3.fromRGB(110, 50, 6),
		},
	},

	Indigo = {
		bg = Color3.fromRGB(20, 14, 58),
		input = Color3.fromRGB(15, 10, 46),
		card = Color3.fromRGB(28, 20, 76),
		stroke = Color3.fromRGB(50, 40, 112),
		btn2 = Color3.fromRGB(38, 29, 96),
		btn2Hover = Color3.fromRGB(52, 42, 122),
		text = Color3.fromRGB(240, 238, 255),
		muted = Color3.fromRGB(150, 142, 204),
		accent = Color3.fromRGB(150, 132, 255),
		warn = Color3.fromRGB(240, 190, 120),
		success = Color3.fromRGB(120, 220, 160),
		error = Color3.fromRGB(255, 120, 140),

		submitBg = Color3.fromRGB(84, 64, 210),
		submitText = Color3.fromRGB(255, 255, 255),

		glowBase = Color3.fromRGB(160, 140, 255),
		glowFrom = Color3.fromRGB(140, 120, 255),
		glowTo = Color3.fromRGB(90, 70, 230),

		confetti = {
			Color3.fromRGB(150, 132, 255),
			Color3.fromRGB(200, 190, 255),
			Color3.fromRGB(255, 255, 255),
			Color3.fromRGB(240, 190, 120),
			Color3.fromRGB(84, 64, 210),
		},
	},
}

local themeIndex = 1

local C = {}
local function loadTheme(theme)
	for k, v in pairs(theme) do
		C[k] = v
	end
end

local COLOR_PROPS = {
	BackgroundColor3 = true,
	TextColor3 = true,
	ImageColor3 = true,
	Color = true,
	PlaceholderColor3 = true,
}
local bindings = {}
local gradients = {}

-- UI/Title font (Ophyn:SetUIFont / Ophyn:SetTitleFont). Every label built through make()
-- with FontFace = FONT or FONT_BOLD is tracked here so both setters can restyle text that
-- already exists, not just text built afterwards.
local fontBindings = {}
local fontSettings = { ui = nil, title = nil }

local function fontFor(entryFont)
	if entryFont.title and fontSettings.title then
		local t = fontSettings.title
		if entryFont.bold then
			return Font.new(t.Family, Enum.FontWeight.Bold, t.Style)
		end
		return t
	end
	if fontSettings.ui then
		local u = fontSettings.ui
		if entryFont.bold then
			return Font.new(u.Family, Enum.FontWeight.Bold, u.Style)
		end
		return u
	end
	return entryFont.bold and FONT_BOLD or FONT
end

local function applyFontAll()
	for _, entryFont in ipairs(fontBindings) do
		if entryFont.inst.Parent then
			entryFont.inst.FontFace = fontFor(entryFont)
		end
	end
end

-- Marks an already-created label as the window title, so SetTitleFont targets only it
-- (SetUIFont still applies to it too, as a fallback, same as everything else).
local function markTitleFont(inst)
	for _, entryFont in ipairs(fontBindings) do
		if entryFont.inst == inst then
			entryFont.title = true
			inst.FontFace = fontFor(entryFont)
			return
		end
	end
end

-- Same idea for a bold label created via text() then switched to FONT_BOLD afterwards,
-- so SetUIFont/SetTitleFont don't flatten it back to the regular weight later.
local function markBoldFont(inst)
	for _, entryFont in ipairs(fontBindings) do
		if entryFont.inst == inst then
			entryFont.bold = true
			inst.FontFace = fontFor(entryFont)
			return
		end
	end
end

-- Accepts a Font instance, a Roblox Enum.Font name ("Gotham", "SourceSansBold", ...), a
-- custom font family asset ("rbxassetid://..." or a bare numeric id), or a table
-- { Family = ..., Weight = ..., Style = ... }.
local function resolveFont(input)
	if input == nil then
		return nil
	end
	if typeof(input) == "Font" then
		return input
	end
	if type(input) == "table" then
		return Font.new(input.Family or input.family, input.Weight or Enum.FontWeight.Regular, input.Style or Enum.FontStyle.Normal)
	end
	local name = tostring(input)
	local ok, enumFont = pcall(function()
		return Enum.Font[name]
	end)
	if ok and typeof(enumFont) == "EnumItem" then
		return Font.fromEnum(enumFont)
	end
	local family = name
	if family:match("^%d+$") then
		family = "rbxassetid://" .. family
	end
	return Font.new(family, Enum.FontWeight.Regular, Enum.FontStyle.Normal)
end

local function make(class, props, parent)
	local inst = Instance.new(class)
	for k, v in pairs(props) do
		if type(v) == "string" and COLOR_PROPS[k] then
			bindings[#bindings + 1] = { inst, k, v }
			inst[k] = C[v]
		elseif k == "FontFace" and (v == FONT or v == FONT_BOLD) then
			fontBindings[#fontBindings + 1] = { inst = inst, bold = (v == FONT_BOLD), title = false }
			inst[k] = v
		else
			inst[k] = v
		end
	end
	inst.Parent = parent
	return inst
end

local function unbind(inst, prop)
	for i = #bindings, 1, -1 do
		local b = bindings[i]
		if b[1] == inst and b[2] == prop then
			table.remove(bindings, i)
		end
	end
end

local function setRole(inst, prop, role)
	local found = false
	for _, b in ipairs(bindings) do
		if b[1] == inst and b[2] == prop then
			b[3] = role
			found = true
			break
		end
	end
	if not found then
		bindings[#bindings + 1] = { inst, prop, role }
	end
	inst[prop] = C[role]
end

local function frame(parent, x, y, w, h, color, transparency)
	return make("Frame", {
		Position = UDim2.new(0, x, 0, y),
		Size = UDim2.new(0, w, 0, h),
		BackgroundColor3 = color or C.bg,
		BackgroundTransparency = transparency or 1,
		BorderSizePixel = 0,
	}, parent)
end

local function text(parent, str, x, y, w, h, size, color, align)
	return make("TextLabel", {
		Position = UDim2.new(0, x, 0, y),
		Size = UDim2.new(0, w, 0, h),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Text = str,
		TextSize = size,
		TextColor3 = color,
		TextXAlignment = align or Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Center,
		FontFace = FONT,
	}, parent)
end

local function round(parent, radius, strokeColor)
	make("UICorner", { CornerRadius = UDim.new(0, radius) }, parent)
	if strokeColor then
		make("UIStroke", {
			Thickness = 1,
			ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
			Color = strokeColor,
		}, parent)
	end
end

local function icon(parent, x, y, color, image)
	local holder = frame(parent, x, y, 16, 16)
	make("ImageLabel", {
		Name = "iconglow",
		Size = UDim2.new(2, 0, 2, 0),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
		Image = GLOW,
		ImageColor3 = color,
		ImageTransparency = 0.9,
		ZIndex = 0,
	}, holder)
	local img = make("ImageLabel", {
		Name = "iconimage",
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		ImageColor3 = iconRole(color),
	}, holder)
	-- `image` can be an asset id or a Lucide icon name ("house" / "lucide:house")
	Lucide.apply(img, image)
	return holder
end

local function decor(parent, w, h, x, y, transparency, rotation)
	local img = make("ImageLabel", {
		Size = UDim2.new(0, w, 0, h),
		Position = UDim2.new(0, x, 0, y),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
		Image = GLOW,
		ImageColor3 = "glowBase",
		ImageTransparency = transparency,
		ScaleType = Enum.ScaleType.Stretch,
	}, parent)
	local grad = make("UIGradient", {
		Rotation = rotation,
		Color = ColorSequence.new(C.glowFrom, C.glowTo),
	}, img)
	gradients[#gradients + 1] = grad
	return img
end

local function centered(parent, w, h)
	return make("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = UDim2.new(0, w, 0, h),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
	}, parent)
end

local function tween(inst, time, props, style, dir)
	local t = TweenService:Create(
		inst,
		TweenInfo.new(time, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out),
		props
	)
	t:Play()
	return t
end

local function ring(parent, size, thickness, color, transparency)
	local f = make("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = UDim2.new(0, size, 0, size),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
	}, parent)
	make("UICorner", { CornerRadius = UDim.new(1, 0) }, f)
	local stroke = make("UIStroke", { Thickness = thickness, Color = color, Transparency = transparency }, f)
	return f, stroke
end

local function comet(stroke)
	make("UIGradient", {
		Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0),
			NumberSequenceKeypoint.new(0.35, 0),
			NumberSequenceKeypoint.new(0.7, 1),
			NumberSequenceKeypoint.new(1, 1),
		}),
	}, stroke)
end

local function prep(container)
	local items = {}
	local function add(inst)
		if inst:IsA("GuiObject") then
			items[#items + 1] = { inst, "BackgroundTransparency", inst.BackgroundTransparency }
			if inst:IsA("TextLabel") or inst:IsA("TextButton") or inst:IsA("TextBox") then
				items[#items + 1] = { inst, "TextTransparency", inst.TextTransparency }
			elseif inst:IsA("ImageLabel") or inst:IsA("ImageButton") then
				items[#items + 1] = { inst, "ImageTransparency", inst.ImageTransparency }
			elseif inst:IsA("ScrollingFrame") then
				items[#items + 1] = { inst, "ScrollBarImageTransparency", inst.ScrollBarImageTransparency }
			end
		elseif inst:IsA("UIStroke") then
			items[#items + 1] = { inst, "Transparency", inst.Transparency }
		end
	end
	add(container)
	for _, d in ipairs(container:GetDescendants()) do
		add(d)
	end
	return items
end

local function fade(items, alpha, time)
	for _, it in ipairs(items) do
		local inst, prop, orig = it[1], it[2], it[3]
		local target = 1 - (1 - orig) * alpha
		if time and time > 0 then
			tween(inst, time, { [prop] = target })
		else
			inst[prop] = target
		end
	end
end

local function tintTo(inst, color)
	if settings.tintIcons then
		tween(inst, 0.15, { ImageColor3 = color })
	end
end

local function applyTheme(name, time)
	local theme = THEMES[name]
	if not theme then
		return
	end

	local oldFrom, oldTo = C.glowFrom, C.glowTo
	loadTheme(theme)

	local style, dir = Enum.EasingStyle.Sine, Enum.EasingDirection.InOut
	for i = #bindings, 1, -1 do
		local b = bindings[i]
		local inst = b[1]
		if inst.Parent == nil then
			table.remove(bindings, i)
		else
			tween(inst, time, { [b[2]] = C[b[3]] }, style, dir)
		end
	end

	local newFrom, newTo = C.glowFrom, C.glowTo
	local driver = Instance.new("NumberValue")
	local conn = driver.Changed:Connect(function(a)
		local seq = ColorSequence.new(oldFrom:Lerp(newFrom, a), oldTo:Lerp(newTo, a))
		for _, g in ipairs(gradients) do
			g.Color = seq
		end
	end)
	local t = tween(driver, time, { Value = 1 }, style, dir)
	t.Completed:Connect(function()
		conn:Disconnect()
		driver:Destroy()
		for _, g in ipairs(gradients) do
			g.Color = ColorSequence.new(newFrom, newTo)
		end
	end)
end

local UI = {}
UI.Jnkie = Jnkie

-- Get key button customisation (KeySystem:SetGetkeyTitle / :SetGetkeyIcon).
-- Stored here so it works before or after KeySystem.new, and updates a UI that is already open.
local getkeySettings = { title = nil, icon = nil }
local getkeyAppliers = {}

local function applyGetkeyAll()
	for _, apply in ipairs(getkeyAppliers) do
		apply()
	end
end

-- Get key dropdown (KeySystem:GetMethod). Each call adds one option:
-- Ophyn:GetMethod({ Title = "...", Icon = "rbxassetid://...", URL = "..." })
-- or, for a dynamic link (matches a custom service's GetKeyLink(ctx)):
-- Ophyn:GetMethod({ Title = "...", Icon = "...", GetKeyLink = function(ctx) return url end })
-- Once 2+ methods are registered, the get key button grows an arrow that opens a dropdown
-- to pick between them; picking one only changes the button's text/icon (SetGetkeyTitle
-- keeps working as the fallback label when no method is selected yet).
local getMethods = {}
local selectedMethodIndex = nil

function UI.GetMethod(entry)
	entry = entry or {}
	local method = {
		title = entry.Title ~= nil and tostring(entry.Title) or nil,
		icon = entry.Icon,
		url = entry.URL,
		getKeyLink = entry.GetKeyLink or entry.getKeyLink,
		fields = entry, -- extra custom fields, passed back as ctx to GetKeyLink
	}
	table.insert(getMethods, method)
	if not selectedMethodIndex then
		selectedMethodIndex = 1
	end
	applyGetkeyAll()
	return #getMethods
end

-- Readable icon/text color on top of a filled color
local function contrastOn(color)
	local luminance = 0.299 * color.R + 0.587 * color.G + 0.114 * color.B
	return luminance > 0.55 and Color3.fromRGB(11, 11, 11) or Color3.fromRGB(255, 255, 255)
end

-- Notification style (NotifStyle / KeySystem:SetNotifStyle). Read every time a notification is shown.
local notifSettings = { style = nil }

function UI.SetNotifStyle(style)
	notifSettings.style = style ~= nil and tostring(style) or nil
end

-- Tabs style (TabsStyle / KeySystem:SetTabsStyle): "1" Tabs in a column on the left (default),
-- "2" Tabs in a row right under the topbar. Works before or after KeySystem.new: windows that
-- already exist re-layout themselves through the appliers they registered.
local tabsSettings = { style = nil }
local tabsAppliers = {}

function UI.SetTabsStyle(style)
	tabsSettings.style = style ~= nil and tostring(style) or nil
	for i = #tabsAppliers, 1, -1 do
		if tabsAppliers[i]() == false then
			table.remove(tabsAppliers, i)
		end
	end
end

function UI.SetUIFont(font)
	fontSettings.ui = resolveFont(font)
	applyFontAll()
end

function UI.SetTitleFont(font)
	fontSettings.title = resolveFont(font)
	applyFontAll()
end

function UI.SetGetkeyTitle(title)
	getkeySettings.title = title ~= nil and tostring(title) or nil
	applyGetkeyAll()
end

function UI.SetGetkeyIcon(icon)
	getkeySettings.icon = icon
	applyGetkeyAll()
end

function UI.new(options)
	local cfg = {}
	for k, v in pairs(Variables) do
		cfg[k] = v
	end
	for k, v in pairs(options or {}) do
		cfg[k] = v
	end

	local HUB_NAME = tostring(cfg.Title)
	local HUB_SUBTITLE = tostring(cfg.Description)
	local FOLDER = cfg.Folder
	local LOGO = assetId(cfg.Logo) or Images.LOGO

	-- Preloads every icon (+ the logo) as early as possible. The Key System content
	-- only becomes visible/interactive once this finishes (see `iconsPreloaded`
	-- below), so icons and images are guaranteed to be loaded before the Key
	-- System is shown to the user.
	local iconsPreloaded = false
	task.spawn(function()
		pcall(function()
			local list = {}
			for _, id in pairs(Images) do
				if type(id) == "string" then
					table.insert(list, id)
				end
			end
			table.insert(list, LOGO)
			game:GetService("ContentProvider"):PreloadAsync(list)
		end)
		iconsPreloaded = true
	end)

	local INTRO_SIZE = tonumber(cfg.startintro_size) or 80
	local LOADING_TIME = 3 -- fixed: icons/images preload during this time
	local SQUARE_TIME = tonumber(cfg.squareintro_time) or 1.2
	local SHOW_SQUARE_CONTORN = asBool(cfg.squarecontorn, true)

	settings.tintLogo = asBool(cfg.Changelogocolor, true)
	settings.tintIcons = asBool(cfg.Changeiconscolor, true)
	local SHOW_GETKEY = asBool(cfg.getkey, true)
	local SHOW_CHANGE_THEME = asBool(cfg.ChangeTheme, true)

	local themeName = cfg.Theme
	if not THEMES[themeName] then
		themeName = "Amethyst"
	end
	themeIndex = table.find(THEME_ORDER, themeName) or 1
	loadTheme(THEMES[themeName])

	local DISCORD_LINK = tostring(cfg.discord_link or "")
	local WEBSITE_LINK = tostring(cfg.website_link or "")
	local HAS_DISCORD = DISCORD_LINK ~= ""
	local HAS_WEBSITE = WEBSITE_LINK ~= ""

	-- card = whether each card shows up at all, separate from whether a link is set.
	-- Discord and Information default to shown; Website defaults to whatever HAS_WEBSITE
	-- is (most people don't have one, so it stays hidden unless a link is actually given).
	-- What the person passes to KeySystem.new wins over the defaults in variables.lua.
	-- Accepts Discord/Website (or lowercase) as true/false or "true"/"false".
	local function cardFlag(default, ...)
		for _, source in ipairs({ options or {}, Variables }) do
			for _, key in ipairs({ ... }) do
				if source[key] ~= nil then
					return asBool(source[key], default)
				end
			end
		end
		return default
	end

	local SHOW_DISCORD_CARD = cardFlag(true, "Discord", "discord")
	local SHOW_WEBSITE_CARD = cardFlag(HAS_WEBSITE, "Website", "website")
	local SHOW_INFO_CARD = cardFlag(true, "Informations", "Information", "informations", "information")
	-- Only Discord enabled (no Website card): it starts expanded to fill the free space
	local SHOW_INTRO = cardFlag(true, "Intro", "intro")

	-- Keyless mode: Keyless = { disabletextbox, disablegetkey, showcard, autoconfirm }.
	-- Passing the table turns it on (enabled = false keeps it off); Keyless = true/false also works.
	-- What the person passes to KeySystem.new wins over variables.lua.
	local KL = { disabletextbox = true, disablegetkey = true, showcard = true, autoconfirm = false }
	local KEYLESS = false
	do
		local raw
		for _, source in ipairs({ options or {}, Variables }) do
			local v = source.Keyless
			if v == nil then
				v = source.keyless
			end
			if v ~= nil then
				raw = v
				break
			end
		end
		if type(raw) == "table" then
			KEYLESS = asBool(raw.enabled, true)
			for k, default in pairs(KL) do
				KL[k] = asBool(raw[k], default)
			end
		elseif raw ~= nil then
			KEYLESS = asBool(raw, false)
		end
	end
	local SHOW_KEYLESS_CARD = KEYLESS and KL.showcard

	-- With the Keyless card on, Discord starts collapsed so both cards fit
	local DISCORD_STARTS_OPEN = SHOW_DISCORD_CARD and not SHOW_WEBSITE_CARD and HAS_DISCORD and not SHOW_KEYLESS_CARD

	-- Notification style: "1" Stripe, "2" Pill, "3" Island, "4" Ring, "5" Solid
	local NOTIF_STYLE = "1"
	for _, source in ipairs({ options or {}, Variables }) do
		local value = source.NotifStyle
		if value == nil then
			value = source.notifstyle
		end
		if value ~= nil then
			NOTIF_STYLE = tostring(value)
			break
		end
	end

	local INVITE_DISPLAY, INVITE_URL, INVITE_CODE = "Not Configured", "", ""
	if HAS_DISCORD then
		local invite = DISCORD_LINK
		if not invite:find("[/.]") then
			invite = "discord.gg/" .. invite
		end
		INVITE_DISPLAY = invite:gsub("^https?://", "")
		INVITE_URL = invite:match("^https?://") and invite or ("https://" .. invite)
		INVITE_CODE = (INVITE_DISPLAY:gsub("[?#].*$", "")):match("([^/]+)/*$") or INVITE_DISPLAY
	end

	local WEBSITE_DISPLAY, WEBSITE_URL = "Not Configured", ""
	if HAS_WEBSITE then
		WEBSITE_DISPLAY = WEBSITE_LINK:gsub("^https?://", "")
		WEBSITE_URL = WEBSITE_LINK:match("^https?://") and WEBSITE_LINK or ("https://" .. WEBSITE_LINK)
	end


	-- KeySystem = { Key = {"1234", "5678"} or function(key) -> valid, reason, URL = "...", SaveKey = false,
	--               API = { { Type = "platoboost" | "panda" | "jnkie", ... } } }
	local KEY_CFG = cfg.KeySystem or {}
	local KEY_LIST = KEY_CFG.Key

	-- Key services (KeySystem.API). Each entry is built by its Type.
	local SERVICE_BUILDERS = {
		platoboost = function(entry)
			return Platoboost.new(entry)
		end,
		-- { Type = "panda", ServiceId = "..." }
		panda = function(entry)
			return Panda.new(entry)
		end,
		-- { Type = "jnkie", Service = "...", Identifier = "...", Provider = "Mixed" }
		jnkie = function(entry)
			local instance = Jnkie.new(entry)
			return {
				CheckKey = function(_, key)
					local result = instance:CheckKey(key)
					local reason = result and (result.error or result.message)
					return result ~= nil and result.valid == true, reason
				end,
				GetKeyLink = function()
					return instance:GetKeyLink()
				end,
			}
		end,
	}

	-- Your own service:
	-- { Type = "custom", ServiceId = 1234, --[[ any fields you want ]]
	--   CheckKey = function(key, ctx) return valid, reason end,   -- required
	--   GetKeyLink = function(ctx) return url end }               -- optional ("Get a key" button)
	-- ctx = every field of the entry (ServiceId, Secret, ...) + ctx.Request
	-- (the executor's HTTP function, or nil). GetKeyLink can return nil, "reason" on failure.
	local function customRequestFunction()
		return request or http_request or (syn and syn.request) or (http and http.request)
	end

	SERVICE_BUILDERS.custom = function(entry)
		local checker = entry.CheckKey or entry.checkKey
		if type(checker) ~= "function" then
			error("KeySystem.API custom entry needs a CheckKey function")
		end
		local getLink = entry.GetKeyLink or entry.getKeyLink

		-- Built on every call, so the person's own fields can override Request.
		local function context()
			local ctx = { Request = customRequestFunction() }
			for k, v in pairs(entry) do
				ctx[k] = v
			end
			return ctx
		end

		return {
			CheckKey = function(_, key)
				local valid, why = checker(key, context())
				return valid == true, why
			end,
			GetKeyLink = (type(getLink) == "function") and function()
				return getLink(context())
			end or nil,
		}
	end

	SERVICE_BUILDERS.pandaauth = SERVICE_BUILDERS.panda -- alias

	local apiEntries = type(KEY_CFG.API) == "table" and KEY_CFG.API or {}
	if apiEntries.Type ~= nil or apiEntries.type ~= nil then
		apiEntries = { apiEntries } -- a single entry without the outer list
	end

	local API_SERVICES = {}
	for i, entry in ipairs(apiEntries) do
		local kind = type(entry) == "table" and tostring(entry.Type or entry.type or ""):lower() or ""
		local builder = SERVICE_BUILDERS[kind]
		if builder then
			local ok, instance = pcall(builder, entry)
			if ok and instance then
				table.insert(API_SERVICES, instance)
			else
				warn("[" .. HUB_NAME .. "] KeySystem.API[" .. i .. "] failed to load: " .. tostring(instance))
			end
		else
			warn("[" .. HUB_NAME .. "] KeySystem.API[" .. i .. "] has an unknown Type: '" .. kind .. "'")
		end
	end

	if KEY_LIST == nil and #API_SERVICES == 0 then
		KEY_LIST = { "key" }
	end
	local KEY_URL = tostring(KEY_CFG.URL or "")
	local KEY_SAVE = asBool(KEY_CFG.SaveKey, false)

	-- Links usados pelos botões (Get a key / Discord / Website)
	local LINKS = {
		getKey = KEY_URL,
		website = WEBSITE_URL,
		discord = INVITE_URL,
	}

	local function isCallable(v)
		if type(v) == "function" then
			return true
		end
		local mt = type(v) == "table" and getmetatable(v)
		return mt ~= nil and mt.__call ~= nil
	end

	-- Auto-detect a Jnkie.Validator() adapter so "Get a key" can call
	-- Jnkie:GetKeyLink() on its own, with no KeySystem.URL required.
	-- Also accepts a *raw* Jnkie instance (Key = jnkie instead of
	-- Key = jnkie:Validator()) and upgrades it automatically.
	if type(KEY_LIST) == "table" and KEY_LIST.__isJnkieInstance and not KEY_LIST.__isJnkie then
		KEY_LIST = KEY_LIST:Validator()
	end
	local KEY_JNKIE = type(KEY_LIST) == "table" and KEY_LIST.__isJnkie and KEY_LIST.__instance or nil

	-- Retorna valid (boolean) e reason (string quando inválida).
	-- Erros aqui são pegos pelo pcall do runKeyCheck ("Something went wrong").
	local function validateKey(key)
		local reason

		-- Key = { "a", "b" } | "a" | function(key) | Jnkie:Validator()
		if KEY_LIST ~= nil then
			if isCallable(KEY_LIST) then
				local valid, why = KEY_LIST(key)
				if valid then
					return true
				end
				reason = why
			elseif type(KEY_LIST) == "table" then
				for _, k in ipairs(KEY_LIST) do
					if tostring(k) == key then
						return true
					end
				end
			elseif tostring(KEY_LIST) == key then
				return true
			end
		end

		-- KeySystem.API (Platoboost / Panda / Jnkie)
		for _, service in ipairs(API_SERVICES) do
			local ok, valid, why = pcall(service.CheckKey, service, key)
			if ok and valid then
				return true
			end
			reason = (ok and why) or (not ok and tostring(valid)) or reason
		end

		return false, reason
	end

	local function safeIsFile(path)
		if not isfile then
			return false
		end
		local ok, res = pcall(isfile, path)
		return ok and res == true
	end

	local function safeReadFile(path)
		if not readfile then
			return nil
		end
		local ok, res = pcall(readfile, path)
		if ok and type(res) == "string" then
			return res
		end
		return nil
	end

	local function safeWriteFile(path, contents)
		if not writefile then
			return false
		end
		if FOLDER and FOLDER ~= "" and isfolder and makefolder then
			local ok, exists = pcall(isfolder, FOLDER)
			if ok and not exists then
				pcall(makefolder, FOLDER)
			end
		end
		return pcall(writefile, path, contents) == true
	end

	-- Nome do arquivo da key = hash gerada (determinística: mesmo Folder + Title = mesmo arquivo)
	local function hashName(seed)
		local bxor = bit32 and bit32.bxor
		local parts = {}
		for round = 1, 4 do
			local h = (2166136261 + round * 16777619) % 4294967296
			local input = seed .. "|" .. round
			for i = 1, #input do
				local b = input:byte(i)
				h = bxor and bxor(h, b) or ((h + b) % 4294967296)
				h = (h * 16777619) % 4294967296
			end
			parts[round] = string.format("%08x", h)
		end
		return table.concat(parts)
	end

	local KEY_HASH = hashName(tostring(FOLDER or "") .. "|" .. HUB_NAME)
	local KEY_FILE = (FOLDER and FOLDER ~= "" and (FOLDER .. "/" .. KEY_HASH)) or KEY_HASH

	local SAVED_KEY = nil
	if KEY_SAVE and safeIsFile(KEY_FILE) then
		local contents = safeReadFile(KEY_FILE)
		if contents then
			contents = contents:match("^%s*(.-)%s*$")
			if contents ~= "" then
				SAVED_KEY = contents
			end
		end
	end

	-- Information card stats: how many key checks were valid, how many came back
	-- expired, and when a key last passed. Stored locally per Folder + Title, same
	-- as the saved key, just under a different hashed file name.
	local STATS_HASH = hashName(tostring(FOLDER or "") .. "|" .. HUB_NAME .. "|stats")
	local STATS_FILE = (FOLDER and FOLDER ~= "" and (FOLDER .. "/" .. STATS_HASH)) or STATS_HASH

	local STATS = { valid = 0, expired = 0, last = 0 }
	do
		local contents = safeReadFile(STATS_FILE)
		if contents then
			local ok, data = pcall(function()
				return HttpService:JSONDecode(contents)
			end)
			if ok and type(data) == "table" then
				STATS.valid = tonumber(data.valid) or 0
				STATS.expired = tonumber(data.expired) or 0
				STATS.last = tonumber(data.last) or 0
			end
		end
	end

	local function saveStats()
		local ok, encoded = pcall(function()
			return HttpService:JSONEncode(STATS)
		end)
		if ok then
			safeWriteFile(STATS_FILE, encoded)
		end
	end

	local function formatAgo(ts)
		if not ts or ts <= 0 then
			return "Never"
		end
		local diff = os.time() - ts
		if diff < 60 then
			return "Just now"
		elseif diff < 3600 then
			return math.floor(diff / 60) .. " min ago"
		elseif diff < 86400 then
			return math.floor(diff / 3600) .. " h ago"
		else
			return math.floor(diff / 86400) .. " d ago"
		end
	end

	local state = { ready = false, closing = false }
	local snapLocked = false

	local root = Instance.new("ScreenGui")
	root.Name = "ophyn-ui-wow"
	root.Enabled = true
	root.DisplayOrder = 999
	root.IgnoreGuiInset = true
	root.ResetOnSpawn = false
	root.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	root.ClipToDeviceSafeArea = true

	local main = make("Frame", {
		Name = "Frame",
		Size = UDim2.new(0, INTRO_SIZE, 0, INTRO_SIZE),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
	}, root)

	local shadow = make("ImageLabel", {
		Size = UDim2.new(1, 50, 1, 50),
		Position = UDim2.new(0, -25, 0, -25),
		BackgroundTransparency = 1,
		Image = Images.SHADOW,
		ImageColor3 = Color3.fromRGB(0, 0, 0),
		ImageTransparency = 1,
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(49, 49, 450, 450),
	}, main)

	local canvas = make("Frame", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = "bg",
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ClipsDescendants = true,
	}, main)
	local canvasCorner = make("UICorner", { CornerRadius = UDim.new(0, 10) }, canvas)

	local borderStroke = make("UIStroke", {
		Thickness = 1,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Color = "accent",
		Transparency = 1,
	}, canvas)

	local decorGroup = make("CanvasGroup", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		GroupTransparency = 1,
	}, canvas)
	make("UICorner", { CornerRadius = UDim.new(0, 10) }, decorGroup)

	local bgFrame = centered(decorGroup, FINAL_W, FINAL_H)
	decor(bgFrame, 380, 140, 230, 266, 0.86, 270)
	decor(bgFrame, 100, 46, -8, 252, 0.75, 90)
	decor(bgFrame, 400, 184, 450, 8, 0.92, 90)
	decor(bgFrame, 70, 138, 5, -5, 0.78, 90)

	local ctx = {
		C = C,
		make = make,
		frame = frame,
		text = text,
		round = round,
		tween = tween,
		prep = prep,
		fade = fade,
		images = Images,
		FONT = FONT,
		FONT_BOLD = FONT_BOLD,
		markBoldFont = markBoldFont,
		root = root,
		canvas = canvas,
		state = state,
		tintIcons = settings.tintIcons,
		getStyle = function()
			return notifSettings.style or NOTIF_STYLE
		end,
		cfg = {
			NOTIF_W = NOTIF_W,
			NOTIF_H = NOTIF_H,
			NOTIF_TRANSPARENCY = NOTIF_TRANSPARENCY,
			NOTIF_COLOR = NOTIF_COLOR,
			NOTIF_BLUR = NOTIF_BLUR,
		},
	}

	local notifs = Notification.new(ctx)
	local notify = notifs.notify
	local Blur = notifs.blur

	local intro = centered(canvas, FINAL_W, FINAL_H)

	local introLogo = make("ImageLabel", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = UDim2.new(0, 64, 0, 58),
		BackgroundTransparency = 1,
		Image = LOGO,
		ImageColor3 = logoRole("accent"),
		ImageTransparency = 1,
		ScaleType = Enum.ScaleType.Fit,
	}, intro)

	local spinnerHolder = make("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 36),
		Size = UDim2.new(0, 36, 0, 36),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
	}, intro)

	local ringTrack = make("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = UDim2.new(0, 24, 0, 24),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
	}, spinnerHolder)
	make("UICorner", { CornerRadius = UDim.new(1, 0) }, ringTrack)
	make("UIStroke", { Thickness = 2.5, Color = "muted", Transparency = 0.75 }, ringTrack)

	local spinner = make("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = UDim2.new(0, 24, 0, 24),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
	}, spinnerHolder)
	make("UICorner", { CornerRadius = UDim.new(1, 0) }, spinner)
	local spinnerStroke = make("UIStroke", { Thickness = 2.5, Color = "accent" }, spinner)
	make("UIGradient", {
		Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0),
			NumberSequenceKeypoint.new(0.35, 0),
			NumberSequenceKeypoint.new(0.7, 1),
			NumberSequenceKeypoint.new(1, 1),
		}),
	}, spinnerStroke)

	local spin = TweenService:Create(
		spinner,
		TweenInfo.new(0.9, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, -1),
		{ Rotation = 360 }
	)

	local checkScreen = centered(canvas, FINAL_W, FINAL_H)
	checkScreen.Visible = false

	local ringHolder = centered(checkScreen, 64, 64)
	ringHolder.Position = UDim2.new(0.5, 0, 0.5, -12)
	local ringScale = make("UIScale", { Scale = 1 }, ringHolder)

	ring(ringHolder, 56, 3, "accent", 0)

	local P1, P2, P3 = Vector2.new(-12, 0), Vector2.new(-4, 9), Vector2.new(13, -9)
	local function makeBar(a, b)
		local d = b - a
		local bar = make("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, a.X, 0.5, a.Y),
			Size = UDim2.new(0, 0, 0, 3),
			Rotation = math.deg(math.atan2(d.Y, d.X)),
			BackgroundColor3 = "accent",
			BorderSizePixel = 0,
			Visible = false,
		}, ringHolder)
		make("UICorner", { CornerRadius = UDim.new(1, 0) }, bar)
		return { frame = bar, a = a, b = b, len = d.Magnitude }
	end
	local checkBar1 = makeBar(P1, P2)
	local checkBar2 = makeBar(P2, P3)

	local fxLayer = frame(checkScreen, 0, 0, FINAL_W, FINAL_H)
	fxLayer.ZIndex = 3

	local checkText = text(checkScreen, "Correct Key!", 0, 156, FINAL_W, 22, 16, "text", Enum.TextXAlignment.Center)
	markBoldFont(checkText)
	checkText.TextTransparency = 1

	local ringItems = prep(ringHolder)
	fade(ringItems, 0)

	local morph = centered(canvas, NOTIF_W, 62)
	morph.Visible = false

	-- "Loading Script.." card. It follows NotifStyle: the window shrinks into that notification's shape.
	local MORPH_TITLE, MORPH_HINT = "Loading Script..", "Can take 1-2s..."

	local function morphLoader(parent, size, thickness, arcColor, trackColor, trackTransparency)
		ring(parent, size, thickness, trackColor, trackTransparency)
		local arc, arcStroke = ring(parent, size, thickness, arcColor, 0)
		comet(arcStroke)
		return TweenService:Create(
			arc,
			TweenInfo.new(0.8, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, -1),
			{ Rotation = 360 }
		)
	end

	local function morphLabel(x, y, w, h, str, size, color, bold)
		local l = text(morph, str, x, y, w, h, size, color)
		if bold then
			markBoldFont(l)
		end
		return l
	end

	local function buildMorph(key)
		morph:ClearAllChildren()

		local w, h = NOTIF_W, 62
		local spec = {
			top = false,
			radius = 10,
			bg = C[NOTIF_COLOR],
			bgTransparency = NOTIF_TRANSPARENCY,
			border = C.stroke,
			borderTransparency = 0.35,
		}
		local spin

		if key == "2" then
			-- Pill
			w, h = 240, 36
			spec.radius = 18
			local box = frame(morph, 6, 6, 24, 24)
			spin = morphLoader(box, 20, 2, "accent", "muted", 0.75)
			make("TextLabel", {
				Position = UDim2.new(0, 38, 0, 0),
				Size = UDim2.new(0, w - 52, 0, h),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				RichText = true,
				Text = "<b>Loading script..</b>  <font color=\"#" .. C.muted:ToHex() .. "\">1-2s</font>",
				TextSize = 13,
				TextColor3 = "text",
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Center,
				FontFace = FONT,
			}, morph)
		elseif key == "3" then
			-- Island
			w, h = 260, 52
			spec.top = true
			spec.radius = 26
			spec.bg = Color3.fromRGB(0, 0, 0)
			spec.bgTransparency = 0.06
			spec.border = Color3.fromRGB(42, 42, 48)
			local badge = frame(morph, 10, 10, 32, 32, "accent", 0.86)
			round(badge, 16, "accent")
			badge.UIStroke.Transparency = 0.6
			spin = morphLoader(badge, 16, 2, "accent", "muted", 0.75)
			morphLabel(54, 9, w - 70, 16, MORPH_TITLE, 13, Color3.fromRGB(244, 244, 245), true)
			morphLabel(54, 27, w - 70, 14, MORPH_HINT, 12, Color3.fromRGB(154, 154, 162))
		elseif key == "4" then
			-- Ring
			h = 60
			local box = frame(morph, 10, 10, 40, 40)
			spin = morphLoader(box, 34, 3, "accent", "muted", 0.75)
			morphLabel(62, 11, w - 76, 18, MORPH_TITLE, 13, "text", true)
			morphLabel(62, 31, w - 76, 16, MORPH_HINT, 12, "muted")
		elseif key == "5" then
			-- Solid
			h = 58
			local accent = C.accent
			local onColor = contrastOn(accent)
			spec.bg = accent
			spec.bgTransparency = 0.04
			spec.borderTransparency = 1
			local box = frame(morph, 14, (h - 22) / 2, 22, 22)
			spin = morphLoader(box, 20, 3, onColor, onColor, 0.75)
			morphLabel(48, 10, w - 62, 18, MORPH_TITLE, 13, onColor, true)
			morphLabel(48, 30, w - 62, 16, MORPH_HINT, 12, onColor:Lerp(accent, 0.35))
		else
			-- Stripe
			round(frame(morph, 8, 10, 3, h - 20, "accent", 0), 2)
			morphLabel(22, 11, w - 36, 18, MORPH_TITLE, 13, "text", true)
			morphLabel(22, 30, w - 36, 16, MORPH_HINT, 12, "muted")
			local trackW = w - 44
			round(frame(morph, 22, h - 9, trackW, 2, "accent", 0.8), 1)
			local fill = frame(morph, 22, h - 9, 0, 2, "accent", 0)
			round(fill, 1)
			spin = TweenService:Create(
				fill,
				TweenInfo.new(2.2, Enum.EasingStyle.Linear),
				{ Size = UDim2.new(0, trackW, 0, 2) }
			)
		end

		morph.Size = UDim2.new(0, w, 0, h)
		local items = prep(morph)
		fade(items, 0)

		spec.w, spec.h, spec.spin, spec.items = w, h, spin, items
		return spec
	end

	local content = centered(canvas, FINAL_W, FINAL_H)
	content.Visible = false

	local left = frame(content, 0, 0, 272, 260)

	make("ImageLabel", {
		Position = UDim2.new(0, 22, 0, 20),
		Size = UDim2.new(0, 36, 0, 32),
		BackgroundTransparency = 1,
		Image = LOGO,
		ImageColor3 = logoRole("accent"),
		ScaleType = Enum.ScaleType.Fit,
	}, left)

	local hubTitle = text(left, HUB_NAME, 66, 20, 190, 22, 20, "text")
markTitleFont(hubTitle)
	hubTitle.TextTruncate = Enum.TextTruncate.AtEnd
	local hubSubtitle = text(left, HUB_SUBTITLE, 66, 42, 190, 14, 12, "muted")
	hubSubtitle.TextTruncate = Enum.TextTruncate.AtEnd

	local licenseLabel = text(left, "License key", 22, 78, 228, 14, 11, "muted")

	local inputBox = frame(left, 22, 96, 228, 36, "input", 0)
	inputBox.ClipsDescendants = true
	round(inputBox, 8, "stroke")
	icon(inputBox, 12, 10, "muted", Images.KEY)

	local KEY_MAX_LENGTH = 256

	local keyBox = make("TextBox", {
		Name = "TextBox",
		Position = UDim2.new(0, 38, 0, 0),
		Size = UDim2.new(1, -48, 1, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Text = "",
		TextSize = 13,
		TextColor3 = "text",
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd,
		PlaceholderText = "Paste your key here",
		PlaceholderColor3 = "muted",
		ClearTextOnFocus = false,
		MultiLine = false,
		FontFace = FONT,
	}, inputBox)

	keyBox:GetPropertyChangedSignal("Text"):Connect(function()
		if #keyBox.Text > KEY_MAX_LENGTH then
			keyBox.Text = keyBox.Text:sub(1, KEY_MAX_LENGTH)
		end
	end)

	local submit = make("TextButton", {
		Name = "TextButton",
		Position = UDim2.new(0, 22, 0, 142),
		Size = UDim2.new(0, 110, 0, 34),
		BackgroundColor3 = "submitBg",
		BackgroundTransparency = 0.12,
		BorderSizePixel = 0,
		AutoButtonColor = false,
		Text = "Submit",
		TextSize = 13,
		TextColor3 = "submitText",
		FontFace = FONT,
	}, left)
	round(submit, 8)
	make("UIPadding", { PaddingLeft = UDim.new(0, 24) }, submit)
	icon(submit, -12, 9, "submitText", Images.SUBMIT)

	local getKey = make("TextButton", {
		Name = "TextButton",
		Position = UDim2.new(0, 140, 0, 142),
		Size = UDim2.new(0, 110, 0, 34),
		BackgroundColor3 = "btn2",
		BorderSizePixel = 0,
		AutoButtonColor = false,
		Text = "Get a key",
		TextTruncate = Enum.TextTruncate.AtEnd,
		TextSize = 13,
		TextColor3 = "text",
		FontFace = FONT,
	}, left)
	round(getKey, 8, "stroke")
	local getKeyPadding = make("UIPadding", { PaddingLeft = UDim.new(0, 24) }, getKey)
	local getKeyIcon = icon(getKey, -12, 9, "text", Images.KEY)

	-- Dropdown arrow: a separate hit area over the button's right edge, only visible
	-- once there are 2+ methods (see Ophyn:GetMethod above). Being its own TextButton on
	-- top of "getKey" means clicking it never also fires getKey's own click below.
	local methodArrow = make("TextButton", {
		Name = "TextButton",
		Position = UDim2.new(1, -26, 0, 0),
		Size = UDim2.new(0, 26, 1, 0),
		BackgroundTransparency = 1,
		AutoButtonColor = false,
		Text = "\226\150\190", -- U+25BE, small down-pointing triangle
		TextSize = 11,
		TextColor3 = "text",
		FontFace = FONT,
		Visible = false,
	}, getKey)

	-- Dropdown list, parented to "main" (not "canvas") so it isn't clipped by the
	-- window's edges when it opens above/below the button.
	local methodDropdown = make("Frame", {
		Name = "GetKeyDropdown",
		BackgroundColor3 = "card",
		BorderSizePixel = 0,
		Visible = false,
		ZIndex = 50,
		ClipsDescendants = true,
	}, main)
	round(methodDropdown, 8, "stroke")

	local function closeMethodDropdown()
		methodDropdown.Visible = false
	end

	local function rebuildMethodDropdown()
		for _, child in ipairs(methodDropdown:GetChildren()) do
			if child:IsA("GuiObject") then
				child:Destroy()
			end
		end
		local rowH = 32
		for i, m in ipairs(getMethods) do
			local row = make("TextButton", {
				Name = "TextButton",
				Position = UDim2.new(0, 0, 0, (i - 1) * rowH),
				Size = UDim2.new(1, 0, 0, rowH),
				BackgroundTransparency = 1,
				AutoButtonColor = false,
				Text = "",
				ZIndex = 51,
			}, methodDropdown)
			icon(row, 10, 8, "text", assetId(m.icon) or Images.KEY)
			local label = text(row, m.title or ("Method " .. i), 34, 0, 96, rowH, 12, "text")
			label.ZIndex = 52
			row.MouseButton1Click:Connect(function()
				selectedMethodIndex = i
				applyGetkeyAll()
				closeMethodDropdown()
			end)
		end
		methodDropdown.Size = UDim2.new(0, 140, 0, rowH * math.max(#getMethods, 1))
	end

	methodArrow.MouseButton1Click:Connect(function()
		if not state.ready or state.closing or #getMethods < 2 or (KEYLESS and KL.disablegetkey) then
			return
		end
		if methodDropdown.Visible then
			closeMethodDropdown()
			return
		end
		rebuildMethodDropdown()
		local pos = getKey.AbsolutePosition - main.AbsolutePosition
		local h = methodDropdown.AbsoluteSize.Y
		methodDropdown.Position = UDim2.new(0, pos.X, 0, pos.Y - h - 6) -- opens upward
		methodDropdown.Visible = true
	end)

	local function applyGetkey()
		local method = getMethods[selectedMethodIndex or 0]
		local title = method and method.title
		local iconValue = method and method.icon
		if not title or title == "" then
			title = getkeySettings.title
		end
		getKey.Text = (title and title ~= "") and title or "Get a key"
		local image = getKeyIcon:FindFirstChild("iconimage")
		if image then
			Lucide.apply(image, assetId(iconValue) or assetId(getkeySettings.icon) or Images.KEY)
		end
		local showArrow = #getMethods > 1
		methodArrow.Visible = showArrow
		getKeyPadding.PaddingRight = showArrow and UDim.new(0, 20) or UDim.new(0, 0)
		if not showArrow then
			closeMethodDropdown()
		end
	end
	applyGetkey()
	table.insert(getkeyAppliers, applyGetkey)
	root.Destroying:Connect(function()
		local index = table.find(getkeyAppliers, applyGetkey)
		if index then
			table.remove(getkeyAppliers, index)
		end
	end)

	if not SHOW_GETKEY then
		getKey.Visible = false
		submit.Size = UDim2.new(0, 228, 0, 34)
	end


	-- Avatar + "Welcome Back / <nome>!"
	local avatar = make("ImageLabel", {
		Position = UDim2.new(0, 22, 0, 214),
		Size = UDim2.new(0, 32, 0, 32),
		BackgroundColor3 = "input",
		BorderSizePixel = 0,
		Image = player and ("rbxthumb://type=AvatarHeadShot&id=" .. player.UserId .. "&w=150&h=150") or "",
		ScaleType = Enum.ScaleType.Crop,
	}, left)
	round(avatar, 16, "stroke")

	text(left, "Welcome Back", 62, 215, 188, 14, 11, "muted")
	local welcomeName = text(left, ((player and player.DisplayName) or "User") .. "!", 62, 229, 188, 16, 14, "text")
	markBoldFont(welcomeName)
	welcomeName.TextTruncate = Enum.TextTruncate.AtEnd

	frame(content, 272, 20, 1, 220, "stroke", 0)

	local right = frame(content, 273, 0, 187, 260)

	text(right, "Detected game", 20, 24, 147, 14, 11, "muted")

	local gameCard = frame(right, 20, 42, 147, 52, "card", 0)
	round(gameCard, 8)

	local gameImg = make("ImageLabel", {
		Position = UDim2.new(0, 9, 0, 9),
		Size = UDim2.new(0, 34, 0, 34),
		BackgroundColor3 = "input",
		BorderSizePixel = 0,
		Image = Images.GAME_PLACEHOLDER,
		ScaleType = Enum.ScaleType.Stretch,
	}, gameCard)
	round(gameImg, 7, "stroke")

	local gameName = text(gameCard, "Loading...", 52, 10, 90, 14, 12, "text")
	gameName.TextTruncate = Enum.TextTruncate.AtEnd
	local gameStatus = text(gameCard, "Checking...", 52, 27, 90, 13, 11, "muted")

	local rows = frame(right, 0, 0, 187, 260)

	text(rows, "Executor", 20, 106, 60, 14, 11, "muted")
	local executorLabel = text(rows, "Detecting...", 80, 106, 87, 14, 11, "text", Enum.TextXAlignment.Right)
	executorLabel.TextTruncate = Enum.TextTruncate.AtEnd

	text(rows, "Status", 20, 126, 60, 14, 11, "muted")
	local statusValue = text(rows, "Key required", 80, 126, 87, 14, 11, "warn", Enum.TextXAlignment.Right)

	local rightDivider = frame(right, 20, 148, 147, 1, "stroke", 0)

	-- Scrollable card list. Cards are laid out inside it (see layoutCards); once they
	-- no longer fit it can be scrolled with the wheel, by touch, or by dragging.
	-- CARD_PAD leaves room for the 1px outer card strokes, which would be clipped otherwise.
	local CARD_PAD = 2
	local CARD_VIEW_BOTTOM = 256 -- bottom edge of the visible card area
	local cardScroll = make("ScrollingFrame", {
		Name = "Cards",
		Position = UDim2.new(0, 20 - CARD_PAD, 0, 158 - CARD_PAD),
		Size = UDim2.new(0, 147 + CARD_PAD + 5, 0, CARD_VIEW_BOTTOM - 158 + CARD_PAD),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		CanvasSize = UDim2.new(0, 0, 0, 0),
		ScrollingDirection = Enum.ScrollingDirection.Y,
		ElasticBehavior = Enum.ElasticBehavior.Never,
		VerticalScrollBarInset = Enum.ScrollBarInset.None,
		ScrollBarThickness = 2,
		ScrollBarImageTransparency = 0.45,
		ClipsDescendants = true,
	}, right)
	setRole(cardScroll, "ScrollBarImageColor3", "muted")

	local function linkButton(y, title, subtitle, image)
		local btn = make("TextButton", {
			Name = "TextButton",
			Position = UDim2.new(0, 20, 0, y),
			Size = UDim2.new(0, 147, 0, 40),
			BackgroundColor3 = "card",
			BorderSizePixel = 0,
			AutoButtonColor = false,
			Text = "",
		}, cardScroll)
		round(btn, 8, "stroke")
		local iconHolder = icon(btn, 11, 12, "accent", image)
		local titleLabel = text(btn, title, 36, 6, 106, 14, 12, "text")
		local subLabel = text(btn, subtitle, 36, 21, 106, 13, 11, "muted")
		subLabel.TextTruncate = Enum.TextTruncate.AtEnd
		return btn, iconHolder, titleLabel, subLabel
	end

	local discord, discordIcon, discordTitle, discordSub = linkButton(158, "Discord", INVITE_DISPLAY, Images.DISCORD)
	local website = linkButton(206, "Website", WEBSITE_DISPLAY, Images.LINK)
	discord.Visible = SHOW_DISCORD_CARD
	website.Visible = SHOW_WEBSITE_CARD
	discordTitle.TextTruncate = Enum.TextTruncate.AtEnd

	discord.ClipsDescendants = true

	local discordExtra = frame(discord, 0, 0, 147, 82)
	discordExtra.Visible = false

	local serverIcon = make("ImageLabel", {
		Position = UDim2.new(0, 9, 0, 7),
		Size = UDim2.new(0, 26, 0, 26),
		BackgroundColor3 = "input",
		BorderSizePixel = 0,
		Image = LOGO,
		ImageColor3 = logoRole("accent"),
		ScaleType = Enum.ScaleType.Fit,
	}, discordExtra)
	round(serverIcon, 8, "stroke")

	local linkHit = make("TextButton", {
		Position = UDim2.new(0, 40, 0, 19),
		Size = UDim2.new(0, 102, 0, 17),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		AutoButtonColor = false,
		Text = "",
	}, discordExtra)

	frame(discordExtra, 10, 41, 127, 1, "stroke", 0)

	local function statBlock(x, label, dotColor)
		local num = text(discordExtra, "...", x, 47, 62, 16, 13, "text")
		markBoldFont(num)
		local dot = frame(discordExtra, x, 66, 6, 6, dotColor, 0)
		make("UICorner", { CornerRadius = UDim.new(1, 0) }, dot)
		text(discordExtra, label, x + 10, 62, 50, 14, 10, "muted")
		return num
	end

	local onlineNum = statBlock(12, "Online", "success")
	local offlineNum = statBlock(80, "Offline", "muted")

	local extraItems = prep(discordExtra)
	local rowsItems = prep(rows)
	local discordIconItems = prep(discordIcon)

	-- Information card: local stats only (valid keys, expired keys, last used)
	local infoCard, infoIcon, infoTitle, infoSub = linkButton(254, "Information", "Tap to view", Images.KEY)
	infoCard.Visible = SHOW_INFO_CARD
	infoCard.ClipsDescendants = true
	infoTitle.TextTruncate = Enum.TextTruncate.AtEnd

	-- Expanded Information card: same look as the expanded Discord card
	local INFO_OPEN_H = 92
	-- Grouped in one table: UI.new is close to Lua's limit of 200 local variables.
	local infoUI = {}
	do
		local extra = frame(infoCard, 0, 0, 147, INFO_OPEN_H)
		extra.Visible = false
		infoUI.extra = extra

		local iconBox = frame(extra, 9, 7, 26, 26, "input", 0)
		round(iconBox, 8, "stroke")
		icon(iconBox, 5, 5, "accent", Images.KEY)

		frame(extra, 10, 41, 127, 1, "stroke", 0)

		local function stat(x, label, dotColor)
			local num = text(extra, "0", x, 46, 62, 16, 13, "text")
			markBoldFont(num)
			local dot = frame(extra, x, 66, 6, 6, dotColor, 0)
			make("UICorner", { CornerRadius = UDim.new(1, 0) }, dot)
			text(extra, label, x + 10, 62, 50, 14, 10, "muted")
			return num
		end
		infoUI.valid = stat(12, "Valid", "success")
		infoUI.expired = stat(80, "Expired", "warn")

		text(extra, "Last used", 12, 77, 56, 13, 10, "muted")
		local lastUsed = text(extra, "Never", 66, 77, 69, 13, 11, "text", Enum.TextXAlignment.Right)
		lastUsed.TextTruncate = Enum.TextTruncate.AtEnd
		infoUI.lastUsed = lastUsed
	end
	infoUI.extraItems = prep(infoUI.extra)
	infoUI.iconItems = prep(infoIcon)

	-- Keyless Mode card: informational only (no click)
	local keylessCard = linkButton(206, "Keyless Mode", "No key needed", Images.KEYLESS)
	keylessCard.Visible = SHOW_KEYLESS_CARD

	local closeBtn = make("TextButton", {
		Name = "CloseButton",
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, -12, 0, 12),
		Size = UDim2.new(0, 26, 0, 26),
		BackgroundColor3 = "card",
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		AutoButtonColor = false,
		Text = "",
		ZIndex = 5,
	}, content)
	make("UICorner", { CornerRadius = UDim.new(0, 7) }, closeBtn)

	local closeIcon = make("ImageLabel", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = UDim2.new(0, 12, 0, 12),
		BackgroundTransparency = 1,
		Image = CLOSE_ICON,
		ImageColor3 = iconRole("muted"),
		ZIndex = 6,
	}, closeBtn)

	local moonBtn = make("TextButton", {
		Name = "ThemeButton",
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, -38, 0, 12),
		Size = UDim2.new(0, 26, 0, 26),
		BackgroundColor3 = "card",
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		AutoButtonColor = false,
		Text = "",
		ZIndex = 5,
	}, content)
	make("UICorner", { CornerRadius = UDim.new(0, 7) }, moonBtn)

	local moonIcon = make("ImageLabel", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = UDim2.new(0, 10, 0, 10),
		BackgroundTransparency = 1,
		Image = MOON_ICON,
		ImageColor3 = iconRole("muted"),
		ZIndex = 6,
	}, moonBtn)
	moonBtn.Visible = SHOW_CHANGE_THEME

	local closeGui

	-- Page 2: a down arrow at the bottom of the Key System slides it up and brings in the
	-- topbar + Tabs (OphynWindow({ Title, Icon }), Tab:Section, Tab:Paragraph). Kept in ctx
	-- so it doesn't take another local in UI.new (already close to Lua's limit). It is built
	-- before prep(content) on purpose, so the arrow fades in and out with the Key System.
	ctx.pages = Pages.new({
		C = C,
		make = make,
		round = round,
		tween = tween,
		prep = prep,
		fade = fade,
		setRole = setRole,
		icon = icon,
		assetId = assetId,
		contrastOn = contrastOn,
		iconRole = iconRole,
		logoRole = logoRole,
		markTitleFont = markTitleFont,
		-- SetTabsStyle wins over TabsStyle from KeySystem.new({ ... }) / variables.lua
		getTabsStyle = function()
			if tabsSettings.style then
				return tabsSettings.style
			end
			for _, source in ipairs({ options or {}, Variables }) do
				local value = source.TabsStyle
				if value == nil then
					value = source.tabsstyle
				end
				if value ~= nil then
					return tostring(value)
				end
			end
			return "1"
		end,
		registerTabsStyle = function(apply)
			table.insert(tabsAppliers, apply)
		end,
		FONT = FONT,
		FONT_BOLD = FONT_BOLD,
		images = Images,
		canvas = canvas,
		content = content,
		state = state,
		width = FINAL_W,
		height = FINAL_H,
		title = HUB_NAME,
		logo = LOGO,
		onOpen = function()
			closeMethodDropdown()
		end,
		requestClose = function()
			if not state.ready or state.closing then
				return
			end
			task.spawn(closeGui)
		end,
	})

	-- Keyless mode: dim + lock the disabled parts. This runs BEFORE prep(content) on
	-- purpose, so the dimmed transparencies become the "original" values that
	-- fade() restores (a later fade-in would otherwise undo the dimming).
	if KEYLESS then
		local DIM = 0.5
		local function dim(container)
			local function apply(inst)
				if inst:IsA("GuiObject") then
					inst.BackgroundTransparency = 1 - (1 - inst.BackgroundTransparency) * DIM
					if inst:IsA("TextLabel") or inst:IsA("TextButton") or inst:IsA("TextBox") then
						inst.TextTransparency = 1 - (1 - inst.TextTransparency) * DIM
					elseif inst:IsA("ImageLabel") or inst:IsA("ImageButton") then
						inst.ImageTransparency = 1 - (1 - inst.ImageTransparency) * DIM
					end
				elseif inst:IsA("UIStroke") then
					inst.Transparency = 1 - (1 - inst.Transparency) * DIM
				end
			end
			apply(container)
			for _, d in ipairs(container:GetDescendants()) do
				apply(d)
			end
		end

		if KL.disabletextbox then
			dim(licenseLabel)
			dim(inputBox)
			pcall(function()
				keyBox.TextEditable = false
				keyBox.Active = false
				keyBox.Interactable = false
			end)
			keyBox.Focused:Connect(function()
				keyBox:ReleaseFocus()
			end)
		end

		if KL.disablegetkey then
			dim(getKey)
			pcall(function()
				getKey.Active = false
				getKey.Interactable = false
				methodArrow.Active = false
				methodArrow.Interactable = false
			end)
		end

		statusValue.Text = "Keyless"
		setRole(statusValue, "TextColor3", "accent")
	end

	local spinnerItems = prep(spinnerHolder)
	local contentItems = prep(content)
	fade(spinnerItems, 0)
	fade(contentItems, 0)

	local SUPPORTED_GAMES = {} -- [PlaceId] = true
	-- SupportedGames: { [PlaceId] = true, ... } or a plain list { PlaceId, PlaceId, ... }.
	-- What the person passes to KeySystem.new wins over the default in variables.lua.
	for _, source in ipairs({ options or {}, Variables }) do
		local value = source.SupportedGames
		if value == nil then
			value = source.supportedgames
		end
		if type(value) == "table" then
			for k, v in pairs(value) do
				if type(v) == "number" then
					SUPPORTED_GAMES[v] = true
				elseif v then
					SUPPORTED_GAMES[tonumber(k) or k] = true
				end
			end
			break
		end
	end

	task.spawn(function()
		local ok, info = pcall(function()
			return MarketplaceService:GetProductInfo(game.PlaceId)
		end)
		if state.closing then
			return
		end
		gameName.Text = (ok and type(info) == "table" and info.Name) or "Unknown game"

		if game.GameId ~= 0 then
			gameImg.Image = "rbxthumb://type=GameIcon&id=" .. game.GameId .. "&w=150&h=150"
		end

		if SUPPORTED_GAMES[game.PlaceId] then
			gameStatus.Text = "Supported"
			setRole(gameStatus, "TextColor3", "success")
		else
			gameStatus.Text = "Not in our list"
			setRole(gameStatus, "TextColor3", "muted")
		end
	end)

	local function detectExecutor()
		local ok, name = pcall(function()
			if identifyexecutor then
				return identifyexecutor()
			elseif getexecutorname then
				return getexecutorname()
			end
		end)
		if ok and name and tostring(name) ~= "" then
			return tostring(name)
		end
		return "Unknown"
	end

	executorLabel.Text = detectExecutor()

	local function copyLink(url, label, iconKey)
		if not state.ready or state.closing then
			return false
		end
		local fn = setclipboard or toclipboard
		local ok = fn and pcall(fn, url)
		if ok then
			notify(label .. " copied", "The link is in your clipboard.", "success", iconKey)
			return true
		end
		notify("Couldn't copy", url, "warn", iconKey, 5)
		return false
	end

	local fetchingKeyLink = false

	getKey.MouseButton1Click:Connect(function()
		if not state.ready or state.closing then
			return
		end
		if KEYLESS and KL.disablegetkey then
			return
		end

		if #getMethods > 0 then
			local method = getMethods[selectedMethodIndex or 1]
			if not method then
				return
			end
			if method.url and method.url ~= "" then
				copyLink(method.url, "Key link", "link")
				return
			end
			if type(method.getKeyLink) == "function" then
				if fetchingKeyLink then
					return
				end
				fetchingKeyLink = true
				task.spawn(function()
					local req = request or http_request or (syn and syn.request) or (http and http.request)
					local ctx = { Request = req }
					for k, v in pairs(method.fields or {}) do
						ctx[k] = v
					end
					local ok, link, err = pcall(method.getKeyLink, ctx)
					fetchingKeyLink = false
					if not state.ready or state.closing then
						return
					end
					if ok and link then
						copyLink(link, "Key link", "link")
					else
						notify("Couldn't get a key", tostring((not ok) and link or err or "Try again."), "warn", "link", 5)
					end
				end)
			end
			return
		end

		if LINKS.getKey ~= "" then
			copyLink(LINKS.getKey, "Key link", "link")
			return
		end

		-- Services that can generate a key link (KeySystem.API and Jnkie)
		local linkProviders = {}
		for _, service in ipairs(API_SERVICES) do
			if service.GetKeyLink then
				table.insert(linkProviders, function()
					return service:GetKeyLink()
				end)
			end
		end
		if KEY_JNKIE then
			table.insert(linkProviders, function()
				return KEY_JNKIE:GetKeyLink()
			end)
		end

		if #linkProviders > 0 then
			if fetchingKeyLink then
				return
			end
			fetchingKeyLink = true
			task.spawn(function()
				local link, err
				for _, getLink in ipairs(linkProviders) do
					local ok, res, res2 = pcall(getLink)
					if ok and res then
						link = res
						break
					end
					err = ok and res2 or (not ok and res) or err
				end
				fetchingKeyLink = false
				if not state.ready or state.closing then
					return
				end
				if link then
					copyLink(link, "Key link", "link")
				elseif err == "RATE_LIMITED" then
					notify("Slow down", "Wait 5 minutes before requesting another link.", "warn", "link", 5)
				else
					notify("Couldn't get a link", tostring(err or "Unknown error"), "warn", "link", 5)
				end
			end)
			return
		end

		if LINKS.website ~= "" then
			copyLink(LINKS.website, "Key link", "link")
			return
		end

		notify("No link set", "The key link isn't set.", "warn", "link")
	end)

	local httpRequest = request or http_request or (syn and syn.request) or (http and http.request)

	local discordInfo = { fetching = false, ok = false, iconLoaded = false, last = 0, online = 0, offline = 0 }

	local discordOpen = false
	local infoOpen = false

	local function anyCardOpen()
		return discordOpen or infoOpen
	end

	local function refreshDiscordTitle()
		local target = (discordOpen and discordInfo.name) or "Discord"
		if discordTitle.Text == target then
			return
		end
		if not state.ready then
			discordTitle.Text = target
			return
		end
		tween(discordTitle, 0.12, { TextTransparency = 1 })
		task.delay(0.12, function()
			if state.closing then
				return
			end
			discordTitle.Text = (discordOpen and discordInfo.name) or "Discord"
			tween(discordTitle, 0.15, { TextTransparency = 0 })
		end)
	end

	local function formatNumber(n)
		local reversed = tostring(math.floor(n)):reverse():gsub("(%d%d%d)", "%1,"):reverse()
		return (reversed:gsub("^,", ""))
	end

	local function applyDiscordInfo()
		if discordInfo.ok then
			onlineNum.Text = formatNumber(discordInfo.online)
			offlineNum.Text = formatNumber(discordInfo.offline)
		elseif discordInfo.fetching then
			onlineNum.Text = "..."
			offlineNum.Text = "..."
		else
			onlineNum.Text = "N/A"
			offlineNum.Text = "N/A"
		end
	end

	local function fetchDiscord()
		if discordInfo.fetching then
			return
		end
		discordInfo.fetching = true
		applyDiscordInfo()

		if httpRequest then
			local ok, res = pcall(httpRequest, {
				Url = "https://discord.com/api/v10/invites/" .. INVITE_CODE .. "?with_counts=true",
				Method = "GET",
			})
			if ok and res and res.StatusCode == 200 and res.Body then
				local okJson, data = pcall(function()
					return HttpService:JSONDecode(res.Body)
				end)
				if okJson and type(data) == "table" and data.approximate_member_count then
					local online = data.approximate_presence_count or 0
					discordInfo.online = online
					discordInfo.offline = math.max(data.approximate_member_count - online, 0)
					discordInfo.ok = true
					discordInfo.last = os.clock()
					if type(data.guild) == "table" and data.guild.name then
						discordInfo.name = data.guild.name
					end

					local guild = data.guild
					local getAsset = getcustomasset or getsynasset
					if guild and guild.icon and not discordInfo.iconLoaded and writefile and getAsset then
						local url = ("https://cdn.discordapp.com/icons/%s/%s.png?size=128"):format(guild.id, guild.icon)
						local okI, resI = pcall(httpRequest, { Url = url, Method = "GET" })
						if okI and resI and resI.StatusCode == 200 and resI.Body and #resI.Body > 0 then
							local okW, asset = pcall(function()
								local fileName = "discord_" .. INVITE_CODE .. ".png"
								if FOLDER and FOLDER ~= "" then
									if isfolder and makefolder and not isfolder(FOLDER) then
										makefolder(FOLDER)
									end
									fileName = FOLDER .. "/" .. fileName
								end
								writefile(fileName, resI.Body)
								return getAsset(fileName)
							end)
							if okW and asset then
								serverIcon.Image = asset
								unbind(serverIcon, "ImageColor3")
								serverIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
								serverIcon.ScaleType = Enum.ScaleType.Crop
								discordInfo.iconLoaded = true
							end
						end
					end
				end
			end
		end

		discordInfo.fetching = false
		applyDiscordInfo()
		refreshDiscordTitle()
	end

	if HAS_DISCORD then
		task.spawn(fetchDiscord)
	end

	-- Stacks whichever cards are enabled (Discord, Keyless, Website, Information, in
	-- that order) inside the scroll frame. Expanding a card (Discord / Information)
	-- pushes the cards below it down and moves the whole list up, hiding the
	-- Executor / Status rows. Anything that doesn't fit becomes scrollable.
	local CARD_GAP = 8
	local cardOrder = {}
	if SHOW_DISCORD_CARD then
		table.insert(cardOrder, discord)
	end
	if SHOW_KEYLESS_CARD then
		table.insert(cardOrder, keylessCard)
	end
	if SHOW_WEBSITE_CARD then
		table.insert(cardOrder, website)
	end
	if SHOW_INFO_CARD then
		table.insert(cardOrder, infoCard)
	end

	local function cardHeight(card)
		if card == discord and discordOpen then
			return 82
		end
		if card == infoCard and infoOpen then
			return INFO_OPEN_H
		end
		return 40
	end

	local layoutToken = 0

	-- focusCard: scrolled into view when the layout changes (used when a card expands)
	local function layoutCards(instant, focusCard)
		local Quint = Enum.EasingStyle.Quint
		local open = anyCardOpen()
		local divider = open and 106 or 148
		local top = open and 114 or 158

		local y = CARD_PAD
		local focusTop, focusBottom
		for _, card in ipairs(cardOrder) do
			local h = cardHeight(card)
			if card == focusCard then
				focusTop, focusBottom = y - CARD_PAD, y + h + CARD_PAD
			end
			if instant then
				card.Position = UDim2.new(0, CARD_PAD, 0, y)
				card.Size = UDim2.new(0, 147, 0, h)
			else
				tween(card, 0.55, {
					Position = UDim2.new(0, CARD_PAD, 0, y),
					Size = UDim2.new(0, 147, 0, h),
				}, Quint)
			end
			y = y + h + CARD_GAP
		end

		local canvasH = math.max(y - CARD_GAP + CARD_PAD, 0)
		local viewH = CARD_VIEW_BOTTOM - top + CARD_PAD
		local maxPos = math.max(canvasH - viewH, 0)
		local pos = cardScroll.CanvasPosition.Y
		local targetPos = math.clamp(pos, 0, maxPos)
		if focusTop then
			if focusBottom > targetPos + viewH then
				targetPos = focusBottom - viewH
			end
			if focusTop < targetPos then
				targetPos = focusTop
			end
			targetPos = math.clamp(targetPos, 0, maxPos)
		end

		local scrollPos = UDim2.new(0, 20 - CARD_PAD, 0, top - CARD_PAD)
		local scrollSize = UDim2.new(0, 147 + CARD_PAD + 5, 0, viewH)
		local canvasSize = UDim2.new(0, 0, 0, canvasH)

		layoutToken += 1
		local token = layoutToken

		if instant then
			rightDivider.Position = UDim2.new(0, 20, 0, divider)
			cardScroll.Position = scrollPos
			cardScroll.Size = scrollSize
			cardScroll.CanvasSize = canvasSize
			cardScroll.CanvasPosition = Vector2.new(0, targetPos)
			return
		end

		tween(rightDivider, 0.55, { Position = UDim2.new(0, 20, 0, divider) }, Quint)

		-- Grow the canvas right away (so the scroll target is reachable); shrink it only
		-- once the cards finished moving (so the position doesn't get clamped mid-tween).
		if canvasH >= cardScroll.CanvasSize.Y.Offset then
			cardScroll.CanvasSize = canvasSize
		else
			task.delay(0.58, function()
				if token == layoutToken then
					cardScroll.CanvasSize = canvasSize
				end
			end)
		end
		tween(cardScroll, 0.55, {
			Position = scrollPos,
			Size = scrollSize,
			CanvasPosition = Vector2.new(0, targetPos),
		}, Quint)
	end
	layoutCards(true)

	-- Dragging the card list with the mouse (the wheel and touch scroll natively).
	-- A drag never counts as a click on the card under the cursor.
	local suppressClick = false
	do
	local dragging, dragStartY, dragStartCanvas = false, 0, 0
	local function onPress(input)
		if input.UserInputType ~= Enum.UserInputType.MouseButton1 or dragging or not state.ready then
			return
		end
		if cardScroll.CanvasSize.Y.Offset <= cardScroll.AbsoluteSize.Y then
			return
		end
		dragging = true
		dragStartY = input.Position.Y
		dragStartCanvas = cardScroll.CanvasPosition.Y
	end
	cardScroll.InputBegan:Connect(onPress)
	for _, card in ipairs(cardOrder) do
		card.InputBegan:Connect(onPress)
	end
	local dragMove = UserInputService.InputChanged:Connect(function(input)
		if not dragging or input.UserInputType ~= Enum.UserInputType.MouseMovement then
			return
		end
		local delta = input.Position.Y - dragStartY
		if not suppressClick and math.abs(delta) < 5 then
			return
		end
		suppressClick = true
		local maxPos = math.max(cardScroll.CanvasSize.Y.Offset - cardScroll.AbsoluteSize.Y, 0)
		cardScroll.CanvasPosition = Vector2.new(0, math.clamp(dragStartCanvas - delta, 0, maxPos))
	end)
	local dragEnd = UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType ~= Enum.UserInputType.MouseButton1 or not dragging then
			return
		end
		dragging = false
		task.delay(0.1, function()
			suppressClick = false
		end)
	end)
	root.Destroying:Connect(function()
		dragMove:Disconnect()
		dragEnd:Disconnect()
	end)
	end

	local discordToken = 0

	local function setDiscord(open)
		discordOpen = open
		refreshDiscordTitle()
		discordToken += 1
		local token = discordToken
		local Quint = Enum.EasingStyle.Quint

		layoutCards(false, open and discord or nil)

		local textX = open and 40 or 36
		tween(discordTitle, 0.4, { Position = UDim2.new(0, textX, 0, 6) }, Quint)
		tween(discordSub, 0.4, {
			Position = UDim2.new(0, textX, 0, 21),
			Size = UDim2.new(0, open and 102 or 106, 0, 13),
		}, Quint)

		fade(rowsItems, anyCardOpen() and 0 or 1, 0.25)
		fade(discordIconItems, open and 0 or 1, 0.2)

		if open then
			discordExtra.Visible = true
			fade(extraItems, 0)
			task.delay(0.15, function()
				if token == discordToken then
					fade(extraItems, 1, 0.3)
				end
			end)
			if not discordInfo.fetching and (not discordInfo.ok or os.clock() - discordInfo.last > 60) then
				task.spawn(fetchDiscord)
			end
		else
			fade(extraItems, 0, 0.15)
			tween(discordSub, 0.15, { TextColor3 = C.muted })
			task.delay(0.17, function()
				if token == discordToken then
					discordExtra.Visible = false
				end
			end)
		end
	end

	-- Same end state as setDiscord(true), without animation (content is still hidden at launch)
	if DISCORD_STARTS_OPEN then
		discordOpen = true
		discordToken += 1
		layoutCards(true)
		discordTitle.Position = UDim2.new(0, 40, 0, 6)
		discordSub.Position = UDim2.new(0, 40, 0, 21)
		discordSub.Size = UDim2.new(0, 102, 0, 13)
		fade(rowsItems, 0)
		fade(discordIconItems, 0)
		discordExtra.Visible = true
	end

	discord.MouseButton1Click:Connect(function()
		if not state.ready or state.closing or suppressClick then
			return
		end
		if not HAS_DISCORD then
			notify("Not configured", "No Discord link has been set.", "warn", "discord")
			return
		end
		setDiscord(not discordOpen)
	end)

	linkHit.MouseButton1Click:Connect(function()
		if suppressClick then
			return
		end
		copyLink(LINKS.discord, "Discord invite", "discord")
	end)
	linkHit.MouseEnter:Connect(function()
		if discordOpen then
			tween(discordSub, 0.15, { TextColor3 = C.accent })
		end
	end)
	linkHit.MouseLeave:Connect(function()
		tween(discordSub, 0.15, { TextColor3 = C.muted })
	end)
	website.MouseButton1Click:Connect(function()
		if not state.ready or state.closing or suppressClick then
			return
		end
		if not HAS_WEBSITE then
			notify("Not configured", "No website link has been set.", "warn", "link")
			return
		end
		copyLink(LINKS.website, "Website link", "link")
	end)

	local function refreshInfo()
		infoUI.valid.Text = formatNumber(STATS.valid)
		infoUI.expired.Text = formatNumber(STATS.expired)
		infoUI.lastUsed.Text = formatAgo(STATS.last)
	end
	refreshInfo()

	do
	local function setLabelText(label, str)
		if label.Text == str then
			return
		end
		if not state.ready then
			label.Text = str
			return
		end
		tween(label, 0.12, { TextTransparency = 1 })
		task.delay(0.12, function()
			if state.closing then
				return
			end
			label.Text = str
			tween(label, 0.15, { TextTransparency = 0 })
		end)
	end

	local infoToken = 0

	local function setInfo(open)
		infoOpen = open
		infoToken += 1
		local token = infoToken
		local Quint = Enum.EasingStyle.Quint

		if open then
			refreshInfo()
		end
		setLabelText(infoSub, open and "Key history" or "Tap to view")

		layoutCards(false, open and infoCard or nil)

		local textX = open and 40 or 36
		tween(infoTitle, 0.4, { Position = UDim2.new(0, textX, 0, 6) }, Quint)
		tween(infoSub, 0.4, {
			Position = UDim2.new(0, textX, 0, 21),
			Size = UDim2.new(0, open and 102 or 106, 0, 13),
		}, Quint)

		fade(rowsItems, anyCardOpen() and 0 or 1, 0.25)
		fade(infoUI.iconItems, open and 0 or 1, 0.2)

		if open then
			infoUI.extra.Visible = true
			fade(infoUI.extraItems, 0)
			task.delay(0.15, function()
				if token == infoToken then
					fade(infoUI.extraItems, 1, 0.3)
				end
			end)
		else
			fade(infoUI.extraItems, 0, 0.15)
			task.delay(0.17, function()
				if token == infoToken then
					infoUI.extra.Visible = false
				end
			end)
		end
	end

	infoCard.MouseButton1Click:Connect(function()
		if not state.ready or state.closing or suppressClick then
			return
		end
		setInfo(not infoOpen)
	end)
	end

	local checkingKey = false

	-- While a card is expanded the Executor/Status rows stay hidden, and the small
	-- icon of the expanded card is replaced by its bigger one
	local fadeContent
	do
	local rowsHidden, discordIconHidden, infoIconHidden = {}, {}, {}
	for _, it in ipairs(rowsItems) do
		rowsHidden[it[1]] = true
	end
	for _, it in ipairs(discordIconItems) do
		discordIconHidden[it[1]] = true
	end
	for _, it in ipairs(infoUI.iconItems) do
		infoIconHidden[it[1]] = true
	end

	function fadeContent(alpha, time)
		if anyCardOpen() and alpha > 0 then
			local filtered = {}
			for _, it in ipairs(contentItems) do
				local inst = it[1]
				local hide = rowsHidden[inst] or (discordOpen and discordIconHidden[inst]) or (infoOpen and infoIconHidden[inst])
				if not hide then
					filtered[#filtered + 1] = it
				end
			end
			fade(filtered, alpha, time)
		else
			fade(contentItems, alpha, time)
		end
	end
	end

	local function resetCheckScreen()
		ringScale.Scale = 0.6
		for _, b in ipairs({ checkBar1, checkBar2 }) do
			b.frame.Visible = false
			b.frame.Size = UDim2.new(0, 0, 0, 3)
		end
		checkText.TextTransparency = 1
		checkText.Position = UDim2.new(0, 0, 0, 162)
		fade(ringItems, 0)
	end

	local function drawBar(bar, time)
		bar.frame.Size = UDim2.new(0, 0, 0, 3)
		bar.frame.Position = UDim2.new(0.5, bar.a.X, 0.5, bar.a.Y)
		bar.frame.Visible = true
		local mid = (bar.a + bar.b) / 2
		tween(bar.frame, time, {
			Size = UDim2.new(0, bar.len, 0, 3),
			Position = UDim2.new(0.5, mid.X, 0.5, mid.Y),
		})
	end

	local function confetti(count, withPulse)
		local colors = C.confetti
		for i = 1, count do
			local angle = (i / count) * math.pi * 2 + math.random() * 0.3
			local dist = 70 + math.random() * 45
			local piece = make("Frame", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(0.5, 0, 0.5, -12),
				Size = UDim2.new(0, math.random(4, 7), 0, math.random(3, 5)),
				BackgroundColor3 = colors[math.random(#colors)],
				BorderSizePixel = 0,
				Rotation = math.random(0, 360),
				ZIndex = 3,
			}, fxLayer)
			make("UICorner", { CornerRadius = UDim.new(0, 2) }, piece)

			local t = 0.55 + math.random() * 0.3
			tween(piece, t, {
				Position = UDim2.new(0.5, math.cos(angle) * dist, 0.5, -12 + math.sin(angle) * dist * 0.85 + 14),
				Rotation = piece.Rotation + math.random(-260, 260),
			}, Enum.EasingStyle.Quint)
			task.delay(t * 0.6, function()
				tween(piece, t * 0.8, { BackgroundTransparency = 1 })
			end)
			task.delay(t * 1.5 + 0.2, function()
				piece:Destroy()
			end)
		end

		if withPulse then
			local pulse, pulseStroke = ring(fxLayer, 56, 2, C.accent, 0.2)
			pulse.Position = UDim2.new(0.5, 0, 0.5, -12)
			tween(pulse, 0.7, { Size = UDim2.new(0, 150, 0, 150) }, Enum.EasingStyle.Quint)
			tween(pulseStroke, 0.7, { Transparency = 1 })
			task.delay(0.8, function()
				pulse:Destroy()
			end)
		end
	end

	local function runKeyCheck(key, isSavedKey)
		checkingKey = true
		state.ready = false
		notifs.dismissAll()

		local result
		task.spawn(function()
			if KEYLESS then
				result = { ok = true, valid = true }
				return
			end
			local ok, valid, reason = pcall(validateKey, key)
			result = { ok = ok, valid = valid, reason = reason }
		end)

		fadeContent(0, 0.25)
		task.wait(0.25)
		content.Visible = false
		spinnerHolder.Position = UDim2.new(0.5, 0, 0.5, 0)
		spin:Play()
		fade(spinnerItems, 1, 0.25)

		local minCheckTime = isSavedKey and SAVED_CHECK_TIME or CHECK_TIME
		local t0 = os.clock()
		repeat
			task.wait()
		until (result and os.clock() - t0 >= minCheckTime) or os.clock() - t0 > 15

		if not (result and result.ok and result.valid) then
			fade(spinnerItems, 0, 0.25)
			task.wait(0.25)
			spin:Cancel()
			content.Visible = true
			fadeContent(1, 0.35)
			if result and result.ok then
				local detail = result.reason and tostring(result.reason) or "That key isn't valid. Get a new one."
				if detail:lower():find("expir") then
					STATS.expired += 1
					saveStats()
					refreshInfo()
				end
				notify("Invalid key", detail, "error")
			else
				local detail = result and result.valid and tostring(result.valid) or "Couldn't check your key. Try again."
				notify("Something went wrong", detail, "error")
			end
			task.wait(0.35)
			state.ready = true
			checkingKey = false
			return
		end

		if KEYLESS then
			statusValue.Text = "Keyless"
			setRole(statusValue, "TextColor3", "accent")
			checkText.Text = "Keyless Access!"
		else
			statusValue.Text = "Key valid"
			setRole(statusValue, "TextColor3", "success")
			checkText.Text = isSavedKey and "Saved Key Found!" or "Correct Key!"

			if KEY_SAVE then
				safeWriteFile(KEY_FILE, key)
			end

			STATS.valid += 1
			STATS.last = os.time()
			saveStats()
		end

		fade(spinnerItems, 0, 0.25)
		task.wait(0.25)
		spin:Cancel()
		resetCheckScreen()
		checkScreen.Visible = true
		fade(ringItems, 1, 0.25)
		tween(ringScale, 0.45, { Scale = 1 }, Enum.EasingStyle.Back)
		task.wait(isSavedKey and 0.15 or 0.4)

		drawBar(checkBar1, 0.14)
		task.wait(0.14)
		drawBar(checkBar2, 0.22)
		task.wait(0.22)

		if isSavedKey then
			confetti(10, false)
		else
			confetti(22, true)
			task.delay(0.3, function()
				confetti(12, false)
			end)
		end

		task.wait(isSavedKey and 0.2 or 1)
		tween(checkText, 0.3, { TextTransparency = 0, Position = UDim2.new(0, 0, 0, 156) }, Enum.EasingStyle.Quint)
		task.wait(isSavedKey and 0.35 or 1)

		snapLocked = true
		fade(ringItems, 0, 0.2)
		tween(checkText, 0.2, { TextTransparency = 1 })
		task.wait(0.2)
		checkScreen.Visible = false
		local morphSpec = buildMorph(notifs.styleKey())
		morph.Visible = true
		morphSpec.spin:Play()
		Blur.acquire()

		local vp = root.AbsoluteSize
		local targetX, targetY
		if morphSpec.top then
			targetX = vp.X / 2
			targetY = 12 + morphSpec.h / 2
		else
			targetX = vp.X - 16 - morphSpec.w / 2
			targetY = vp.Y - 16 - morphSpec.h / 2
		end
		tween(main, 0.7, {
			Size = UDim2.new(0, morphSpec.w, 0, morphSpec.h),
			Position = UDim2.new(0, targetX, 0, targetY),
		}, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut)
		tween(canvas, 0.7, { BackgroundColor3 = morphSpec.bg, BackgroundTransparency = morphSpec.bgTransparency })
		tween(canvasCorner, 0.7, { CornerRadius = UDim.new(0, morphSpec.radius) })
		tween(decorGroup, 0.4, { GroupTransparency = 1 })
		tween(shadow, 0.5, { ImageTransparency = 1 })
		tween(borderStroke, 0.5, { Transparency = morphSpec.borderTransparency, Color = morphSpec.border })
		task.delay(0.35, function()
			fade(morphSpec.items, 1, 0.3)
		end)
		task.wait(0.75)

		task.wait(isSavedKey and 0.2 or 1)

		local runError
		task.spawn(function()
			local callback = cfg.Callback
			if type(callback) == "string" and callback ~= "" then
				if not loadstring then
					runError = "loadstring is not available"
					return
				end
				local fn, compileError = loadstring(callback)
				if not fn then
					runError = compileError
					return
				end
				callback = fn
			end
			if type(callback) == "function" then
				local ok, err = pcall(callback, key)
				if not ok then
					runError = err
				end
			end
		end)
		task.wait(0.3)

		morphSpec.spin:Cancel()
		Blur.release()
		fade(morphSpec.items, 0, 0.25)
		tween(canvas, 0.3, { BackgroundTransparency = 1 })
		tween(borderStroke, 0.3, { Transparency = 1 })
		task.wait(0.35)

		if runError then
			notify("Script error", tostring(runError):sub(1, 80), "error", nil, 5)
			task.wait(5.5)
		end
		root:Destroy()
	end

	submit.MouseButton1Click:Connect(function()
		if not state.ready or state.closing or checkingKey then
			return
		end

		if KEYLESS then
			runKeyCheck("") -- the Callback receives an empty key in keyless mode
			return
		end

		local key = keyBox.Text:match("^%s*(.-)%s*$")
		if key == "" then
			notify("Empty key", "Paste your key in the box first.", "warn", "key")
			return
		end

		runKeyCheck(key)
	end)

	-- Fechar a UI (o X fecha direto, sem popup de confirmação)
	closeGui = function()
		if state.closing then
			return
		end
		state.closing = true
		state.ready = false
		notifs.dismissAll()

		tintTo(closeIcon, C.muted)
		tween(closeBtn, 0.15, { BackgroundTransparency = 1 })

		if not SHOW_INTRO then
			-- No intro: plain fade-out
			fadeContent(0, 0.3)
			ctx.pages.fadeOut(0.3)
			tween(canvas, 0.35, { BackgroundTransparency = 1 })
			tween(decorGroup, 0.35, { GroupTransparency = 1 })
			tween(borderStroke, 0.35, { Transparency = 1 })
			tween(shadow, 0.35, { ImageTransparency = 1 })
			task.wait(0.4)
			root:Destroy()
			return
		end

		fadeContent(0, 0.2)
		ctx.pages.fadeOut(0.2)

		task.wait(0.2)
		content.Visible = false

		introLogo.Position = UDim2.new(0.5, 0, 0.5, 0)
		tween(introLogo, 0.4, { ImageTransparency = 0 })
		tween(borderStroke, 0.5, { Transparency = 0.55 })
		tween(main, 0.65, { Size = UDim2.new(0, INTRO_SIZE, 0, INTRO_SIZE) }, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut)
		task.wait(0.7)

		tween(canvas, 0.35, { BackgroundTransparency = 1 })
		tween(decorGroup, 0.35, { GroupTransparency = 1 })
		tween(introLogo, 0.35, { ImageTransparency = 1 })
		tween(borderStroke, 0.35, { Transparency = 1 })
		tween(shadow, 0.35, { ImageTransparency = 1 })
		task.wait(0.4)
		root:Destroy()
	end

	closeBtn.MouseButton1Click:Connect(function()
		if not state.ready or state.closing then
			return
		end
		task.spawn(closeGui)
	end)

	-- Hovers
	closeBtn.MouseEnter:Connect(function()
		if not state.ready or state.closing then
			return
		end
		tween(closeBtn, 0.15, { BackgroundTransparency = 0 })
		tintTo(closeIcon, C.text)
	end)
	closeBtn.MouseLeave:Connect(function()
		if not state.ready or state.closing then
			return
		end
		tween(closeBtn, 0.15, { BackgroundTransparency = 1 })
		tintTo(closeIcon, C.muted)
	end)
	moonBtn.MouseEnter:Connect(function()
		if not state.ready or state.closing then
			return
		end
		tween(moonBtn, 0.15, { BackgroundTransparency = 0 })
		tintTo(moonIcon, C.text)
	end)
	moonBtn.MouseLeave:Connect(function()
		tween(moonBtn, 0.15, { BackgroundTransparency = 1 })
		tintTo(moonIcon, C.muted)
	end)

	local THEME_ANIM_TIME = 1.6
	local switchingTheme = false

	local function switchTheme()
		if not state.ready or state.closing or checkingKey or switchingTheme then
			return
		end
		switchingTheme = true
		state.ready = false
		notifs.dismissAll()

		tintTo(moonIcon, C.muted)
		tween(moonBtn, 0.15, { BackgroundTransparency = 1 })
		fadeContent(0, 0.25)
		task.wait(0.25)
		content.Visible = false
		spinnerHolder.Position = UDim2.new(0.5, 0, 0.5, 0)
		spin:Play()
		fade(spinnerItems, 1, 0.25)
		task.wait(0.4)

		themeIndex = themeIndex % #THEME_ORDER + 1
		local name = THEME_ORDER[themeIndex]
		applyTheme(name, THEME_ANIM_TIME)
		task.wait(THEME_ANIM_TIME + 0.3)

		fade(spinnerItems, 0, 0.25)
		task.wait(0.25)
		spin:Cancel()
		content.Visible = true
		fadeContent(1, 0.35)
		notify("Theme: " .. name, "Theme applied.", "info", "moon")
		task.wait(0.35)

		state.ready = true
		switchingTheme = false
	end

	moonBtn.MouseButton1Click:Connect(function()
		task.spawn(switchTheme)
	end)

	root.Parent = game:GetService("CoreGui")

	local function snap()
		if snapLocked then
			return
		end
		local size = root.AbsoluteSize
		main.Position = UDim2.new(0, math.floor(size.X / 2), 0, math.floor(size.Y / 2))
	end
	snap()
	root:GetPropertyChangedSignal("AbsoluteSize"):Connect(snap)

	task.spawn(function()
		if SHOW_INTRO then
			main.Size = UDim2.new(0, INTRO_SIZE - 20, 0, INTRO_SIZE - 20)
			tween(main, 0.6, { Size = UDim2.new(0, INTRO_SIZE, 0, INTRO_SIZE) }, Enum.EasingStyle.Quint)
			tween(canvas, 0.5, { BackgroundTransparency = 0 })
			tween(decorGroup, 0.5, { GroupTransparency = 0 })
			tween(introLogo, 0.5, { ImageTransparency = 0 })
			if SHOW_SQUARE_CONTORN then
				tween(borderStroke, 0.5, { Transparency = 0.55 })
			end
			tween(shadow, 0.5, { ImageTransparency = 0.6 })
			task.wait(SQUARE_TIME)

			tween(borderStroke, 0.7, { Transparency = 1 })
			tween(main, 0.85, { Size = UDim2.new(0, FINAL_W, 0, FINAL_H) }, Enum.EasingStyle.Quint)
			tween(introLogo, 0.7, { Position = UDim2.new(0.5, 0, 0.5, -20) }, Enum.EasingStyle.Quint)
			task.wait(0.35)
			spin:Play()
			fade(spinnerItems, 1, 0.4)

			task.wait(LOADING_TIME)

			fade(spinnerItems, 0, 0.3)
			tween(introLogo, 0.3, { ImageTransparency = 1 })
			task.wait(0.2)
			spin:Cancel()
		else
			-- No intro animation: sit at final size, invisible, for LoadingTime (still
			-- needed to detect the game/executor and let icons finish preloading),
			-- then simply fade the whole window in.
			main.Size = UDim2.new(0, FINAL_W, 0, FINAL_H)
			task.wait(LOADING_TIME)

			tween(canvas, 0.5, { BackgroundTransparency = 0 })
			tween(decorGroup, 0.5, { GroupTransparency = 0 })
			tween(shadow, 0.5, { ImageTransparency = 0.6 })
			task.wait(0.25)
		end

		-- Make sure every icon/image finished preloading before the Key System
		-- content itself is loaded and shown.
		while not iconsPreloaded do
			task.wait()
		end

		content.Visible = true
		fadeContent(1, 0.45)
		task.wait(0.3)
		state.ready = true

		if KEYLESS then
			if KL.autoconfirm and not checkingKey then
				task.wait(0.15)
				runKeyCheck("") -- the Callback receives an empty key in keyless mode
			end
		elseif SAVED_KEY and not checkingKey then
			keyBox.Text = SAVED_KEY
			task.wait(0.15)
			runKeyCheck(SAVED_KEY, true)
		end
	end)

	-- KeySystem.new(...) returns this object: :SetGetkeyTitle / :SetGetkeyIcon, and everything else
	-- (Destroy, Enabled, Parent, ...) is forwarded to the ScreenGui.
	local api = {}
	function api:SetGetkeyTitle(title)
		UI.SetGetkeyTitle(title)
		return self
	end
	function api:SetGetkeyIcon(icon)
		UI.SetGetkeyIcon(icon)
		return self
	end
	function api:SetNotifStyle(style)
		UI.SetNotifStyle(style)
		return self
	end
	api.NotifStyle = api.SetNotifStyle
	function api:SetTabsStyle(style)
		UI.SetTabsStyle(style)
		return self
	end
	api.TabsStyle = api.SetTabsStyle
	function api:GetMethod(entry)
		UI.GetMethod(entry)
		return self
	end
	function api:SetUIFont(font)
		UI.SetUIFont(font)
		return self
	end
	function api:SetTitleFont(font)
		UI.SetTitleFont(font)
		return self
	end
	-- OphynWindow:Tab({ Title = "...", Icon = "..." }) -> Tab (same as OphynWindow({ ... }))
	function api:Tab(props)
		return ctx.pages.createTab(props)
	end
	api.Gui = root

	return setmetatable(api, {
		__call = function(_, props)
			return ctx.pages.createTab(props)
		end,
		__index = function(_, key)
			local value = root[key]
			if type(value) == "function" then
				return function(_, ...)
					return value(root, ...)
				end
			end
			return value
		end,
		__newindex = function(_, key, value)
			root[key] = value
		end,
	})
end

return UI
end

__modules["images/images"] = function()
-- src/images/images.lua
-- All Roblox asset IDs (images, icons, and font) used by the UI.

local Images = {
	FONT = "rbxassetid://12187365364",
	KEY = "rbxassetid://96510194465420",
	SUBMIT = "rbxassetid://113692007244654",
	LINK = "rbxassetid://114238209622913",
	DISCORD = "rbxassetid://127255077587058",
	GLOW = "rbxassetid://8992230677",
	LOGO = "rbxassetid://111673746737789",
	CLOSE_ICON = "rbxassetid://110786993356448",
	MOON_ICON = "rbxassetid://83380517901735",
	SHADOW = "rbxassetid://6014261993",
	GAME_PLACEHOLDER = "rbxassetid://74584987850498",
	KEYLESS = "rbxassetid://130551565616516",
}

return Images
end

__modules["utilities/jnkie"] = function()
local SDK_URL = "https://jnkie.com/sdk/library.lua"

local Jnkie = {}
Jnkie.__index = Jnkie

local function safeLoad(url)
	if not loadstring then
		return nil, "loadstring is not available"
	end
	local ok, result = pcall(function()
		return game:HttpGet(url)
	end)
	if not ok then
		return nil, tostring(result)
	end
	local fn, compileErr = loadstring(result)
	if not fn then
		return nil, tostring(compileErr)
	end
	local okRun, lib = pcall(fn)
	if not okRun then
		return nil, tostring(lib)
	end
	return lib
end

function Jnkie.new(config)
	config = config or {}
	local self = setmetatable({}, Jnkie)
	self.__isJnkieInstance = true
	self.service = config.Service or config.service
	self.identifier = config.Identifier or config.identifier
	self.provider = config.Provider or config.provider or "Mixed"
	self.client = nil
	self.loadError = nil

	if not self.service or self.service == "" then
		warn("[Jnkie] Service is missing — check your dashboard for the exact name")
	end
	if not self.identifier or self.identifier == "" then
		warn("[Jnkie] Identifier is missing — check your dashboard for your user ID")
	end

	return self
end

function Jnkie:_client()
	if self.client then
		return self.client
	end
	local lib, err = safeLoad(SDK_URL)
	if not lib then
		self.loadError = err
		warn("[Jnkie] failed to load SDK: " .. tostring(err))
		return nil
	end
	lib.service = self.service
	lib.identifier = self.identifier
	lib.provider = self.provider
	self.client = lib
	return lib
end

local function isSuccess(result)
	if type(result) ~= "table" then
		return false
	end
	if result.valid == true or result.success == true then
		return true
	end
	if result.message == "KEY_VALID" or result.message == "KEYLESS" then
		return true
	end
	return false
end

function Jnkie:CheckKey(key)
	local lib = self:_client()
	if not lib then
		return { valid = false, error = self.loadError or "SDK_LOAD_FAILED" }
	end
	local ok, result = pcall(lib.check_key, key)
	if not ok then
		return { valid = false, error = tostring(result) }
	end
	if type(result) ~= "table" then
		return { valid = false, error = "UNEXPECTED_RESPONSE: " .. tostring(result) }
	end
	result.valid = isSuccess(result)
	return result
end

function Jnkie:GetKeyLink()
	local lib = self:_client()
	if not lib then
		return nil, self.loadError or "SDK_LOAD_FAILED"
	end
	local ok, link, err = pcall(lib.get_key_link)
	if not ok then
		return nil, tostring(link)
	end
	return link, err
end

function Jnkie:Validator()
	local instance = self
	local adapter = setmetatable({
		__isJnkie = true,
		__instance = instance,
	}, {
		__call = function(_, key)
			local result = instance:CheckKey(key)
			local reason = result and (result.error or result.message)
			return result and result.valid == true, reason
		end,
	})
	return adapter
end

return Jnkie
end

__modules["utilities/lucide"] = function()
-- src/utilities/lucide.lua
-- Lucide icon support, backed by https://github.com/Footagesus/Icons (lucide/dist/Icons.lua).
--
-- Anywhere the UI takes an `Icon`, you can now pass a Lucide name instead of an asset id:
--
--   Tab:Section({ Title = "Main", Icon = "house" })
--   Tab:Section({ Title = "Main", Icon = "lucide:house" }) -- same thing, explicit prefix
--
-- Asset ids ("rbxassetid://...", a bare number, "rbxthumb://...") keep working exactly as before.
--
-- The icon pack is a spritesheet: every icon is a rect inside a bigger image, so a resolved
-- icon is { Image, RectSize, RectOffset } and not just one asset id. The pack is only
-- downloaded the first time a Lucide name is actually used (and cached after that), so
-- scripts that only use asset ids never pay for it.

local Lucide = {}

local PACK_URL = "https://raw.githubusercontent.com/Footagesus/Icons/refs/heads/main/lucide/dist/Icons.lua"
local PREFIX = "lucide:"

local pack = nil -- the loaded icon pack
local failed = false -- the download/parse failed, don't keep retrying
local loading = false
local preloaded = {} -- spritesheets that already went through ContentProvider
local warned = {} -- names that already printed a warning

local function fetch(url)
	local ok, body = pcall(function()
		return game:HttpGet(url)
	end)
	if ok and type(body) == "string" and body ~= "" then
		return body
	end
	ok, body = pcall(function()
		return game:HttpGetAsync(url)
	end)
	if ok and type(body) == "string" and body ~= "" then
		return body
	end
	return nil
end

local function loadPack()
	if pack or failed then
		return pack
	end
	if loading then
		-- another thread is already downloading it: wait for that one
		while loading do
			task.wait()
		end
		return pack
	end

	loading = true
	local ok, result = pcall(function()
		local body = fetch(PACK_URL)
		if not body then
			error("could not download the icon pack")
		end
		local chunk, err = loadstring(body)
		if not chunk then
			error(err)
		end
		return chunk()
	end)
	loading = false

	if ok and type(result) == "table" then
		pack = result
	else
		failed = true
		warn("[Ophyn] Lucide icons unavailable: " .. tostring(result))
	end
	return pack
end

-- "rbxassetid://123" / 123 / "123" -> "rbxassetid://123"; anything else string-like is kept
local function toAsset(value)
	if type(value) == "number" then
		return "rbxassetid://" .. tostring(math.floor(value))
	end
	if type(value) == "string" and value:match("^%d+$") then
		return "rbxassetid://" .. value
	end
	return value
end

-- true when `value` should be looked up in the Lucide pack (instead of used as an asset id)
function Lucide.isName(value)
	if type(value) ~= "string" or value == "" then
		return false
	end
	if value:match("^%d+$") then
		return false -- bare asset id
	end
	if value:match("^rbx%a*://") or value:match("^https?://") then
		return false -- rbxassetid:// / rbxthumb:// / rbxasset:// / urls
	end
	return true
end

local function stripPrefix(name)
	if name:sub(1, #PREFIX):lower() == PREFIX then
		return name:sub(#PREFIX + 1)
	end
	return name
end

local function preload(sheet)
	if preloaded[sheet] then
		return
	end
	preloaded[sheet] = true
	task.spawn(function()
		pcall(function()
			game:GetService("ContentProvider"):PreloadAsync({ sheet })
		end)
	end)
end

-- Returns { Image = "rbxassetid://...", RectSize = Vector2, RectOffset = Vector2 }
-- or nil when the name is unknown (or the pack could not be loaded).
function Lucide.resolve(value)
	if not Lucide.isName(value) then
		return nil
	end

	local name = stripPrefix(value):lower():gsub("_", "-")
	local loaded = loadPack()
	if not loaded then
		return nil
	end

	local icons = loaded.Icons or loaded
	local entry = type(icons) == "table" and icons[name] or nil
	if type(entry) ~= "table" then
		if not warned[name] then
			warned[name] = true
			warn('[Ophyn] unknown Lucide icon "' .. tostring(value) .. '"')
		end
		return nil
	end

	local sheet = entry.Image
	if type(loaded.Spritesheets) == "table" and loaded.Spritesheets[tostring(entry.Image)] ~= nil then
		sheet = loaded.Spritesheets[tostring(entry.Image)]
	end
	sheet = toAsset(sheet)
	if type(sheet) ~= "string" then
		return nil
	end

	preload(sheet)
	return {
		Image = sheet,
		RectSize = entry.ImageRectSize or Vector2.new(0, 0),
		RectOffset = entry.ImageRectPosition or entry.ImageRectOffset or Vector2.new(0, 0),
	}
end

-- Points an ImageLabel/ImageButton at `value`, which can be a Lucide name or an asset id.
-- Always resets the sprite rect, so an icon can be swapped between the two kinds safely.
function Lucide.apply(label, value)
	local sprite = Lucide.resolve(value)
	if sprite then
		label.Image = sprite.Image
		label.ImageRectSize = sprite.RectSize
		label.ImageRectOffset = sprite.RectOffset
		return true
	end

	label.ImageRectSize = Vector2.new(0, 0)
	label.ImageRectOffset = Vector2.new(0, 0)
	if Lucide.isName(value) then
		label.Image = "" -- a Lucide name that could not be resolved: draw nothing
		return false
	end
	label.Image = value or ""
	return value ~= nil
end

return Lucide
end

__modules["utilities/panda"] = function()
local LIB_URL = "https://secure.pandauth.com/pv4/lib"

local REASONS = {
	INVALID_KEY = "key is invalid or expired.",
	RATE_LIMITED = "you are being rate limited, please wait a moment and try again.",
	NETWORK = "network error, please try again.",
	NO_SERVICE = "Panda ServiceId is missing or invalid.",
	NO_KEY = "key is empty.",
	NO_HTTP = "your executor doesn't support HTTP requests.",
	IDENTITY = "couldn't verify the Panda server identity, please try again later.",
	PROTOCOL = "Panda protocol error, please try again later.",
}

local Panda = {}
Panda.__index = Panda

function Panda.new(config)
	config = config or {}
	local self = setmetatable({}, Panda)

	local serviceId = config.ServiceId or config.Service or config.serviceId
	self.serviceId = serviceId ~= nil and tostring(serviceId) or ""
	self.debug = config.Debug == true

	self.lib = nil
	self.loading = false

	if self.serviceId == "" then
		warn("[Panda] ServiceId is missing — check your Panda dashboard")
	end

	return self
end

function Panda:_load()
	while self.loading do
		task.wait(0.1)
	end
	if self.lib then
		return self.lib
	end
	if self.serviceId == "" then
		return nil, REASONS.NO_SERVICE
	end

	self.loading = true
	local lib, err

	local okFetch, src = pcall(function()
		return game:HttpGet(LIB_URL)
	end)
	if not okFetch or type(src) ~= "string" or src == "" then
		err = "couldn't download the Panda library."
	elseif not loadstring then
		err = "loadstring is not available."
	else
		local fn, compileError = loadstring(src)
		if not fn then
			err = "couldn't load the Panda library: " .. tostring(compileError)
		else
			local okRun, result = pcall(fn)
			if okRun and type(result) == "table" and type(result.configure) == "function" then
				local okConfig, configError = pcall(result.configure, {
					serviceId = self.serviceId,
					debug = self.debug,
					kickOnDetect = false,
				})
				if okConfig then
					lib = result
				else
					err = "couldn't configure the Panda library: " .. tostring(configError)
				end
			else
				err = "Panda library failed to initialize."
			end
		end
	end

	self.loading = false
	if lib then
		self.lib = lib
		return lib
	end
	return nil, err
end

function Panda:CheckKey(key)
	key = tostring(key or ""):match("^%s*(.-)%s*$")
	if key == "" then
		return false, REASONS.NO_KEY
	end

	local lib, err = self:_load()
	if not lib then
		return false, err
	end

	if type(lib.validateEx) == "function" then
		local ok, valid, reason = pcall(lib.validateEx, key)
		if not ok then
			return false, tostring(valid)
		end
		if valid == true then
			return true
		end
		return false, REASONS[reason] or ("Panda error: " .. tostring(reason))
	end

	local ok, result = pcall(lib.validate, key)
	if not ok then
		return false, tostring(result)
	end
	if type(result) == "table" and result.success == true then
		return true
	end
	local reason = type(result) == "table" and (result.reason or result.error) or nil
	return false, REASONS[reason] or tostring(reason or "key is invalid.")
end

function Panda:GetKeyLink()
	local lib, err = self:_load()
	if not lib then
		return nil, err
	end
	if type(lib.getKeyUrl) ~= "function" then
		return nil, "Panda library has no getKeyUrl."
	end
	local ok, url = pcall(lib.getKeyUrl)
	if ok and type(url) == "string" and url ~= "" then
		return url
	end
	return nil, "Failed to get link."
end

return Panda
end

__modules["utilities/platoboost"] = function()

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

-- SHA-256 (hex digest) from the official Platoboost library.
local sha256 = (function()
local a=2^32;local b=a-1;local function c(d,e)local f,g=0,1;while d~=0 or e~=0 do local h,i=d%2,e%2;local j=(h+i)%2;f=f+j*g;d=math.floor(d/2)e=math.floor(e/2)g=g*2 end;return f%a end;local function k(d,e,l,...)local m;if e then d=d%a;e=e%a;m=c(d,e)if l then m=k(m,l,...)end;return m elseif d then return d%a else return 0 end end;local function n(d,e,l,...)local m;if e then d=d%a;e=e%a;m=(d+e-c(d,e))/2;if l then m=n(m,l,...)end;return m elseif d then return d%a else return b end end;local function o(p)return b-p end;local function q(d,r)if r<0 then return lshift(d,-r)end;return math.floor(d%2^32/2^r)end;local function s(p,r)if r>31 or r<-31 then return 0 end;return q(p%a,r)end;local function lshift(d,r)if r<0 then return s(d,-r)end;return d*2^r%2^32 end;local function t(p,r)p=p%a;r=r%32;local u=n(p,2^r-1)return s(p,r)+lshift(u,32-r)end;local v={0x428a2f98,0x71374491,0xb5c0fbcf,0xe9b5dba5,0x3956c25b,0x59f111f1,0x923f82a4,0xab1c5ed5,0xd807aa98,0x12835b01,0x243185be,0x550c7dc3,0x72be5d74,0x80deb1fe,0x9bdc06a7,0xc19bf174,0xe49b69c1,0xefbe4786,0x0fc19dc6,0x240ca1cc,0x2de92c6f,0x4a7484aa,0x5cb0a9dc,0x76f988da,0x983e5152,0xa831c66d,0xb00327c8,0xbf597fc7,0xc6e00bf3,0xd5a79147,0x06ca6351,0x14292967,0x27b70a85,0x2e1b2138,0x4d2c6dfc,0x53380d13,0x650a7354,0x766a0abb,0x81c2c92e,0x92722c85,0xa2bfe8a1,0xa81a664b,0xc24b8b70,0xc76c51a3,0xd192e819,0xd6990624,0xf40e3585,0x106aa070,0x19a4c116,0x1e376c08,0x2748774c,0x34b0bcb5,0x391c0cb3,0x4ed8aa4a,0x5b9cca4f,0x682e6ff3,0x748f82ee,0x78a5636f,0x84c87814,0x8cc70208,0x90befffa,0xa4506ceb,0xbef9a3f7,0xc67178f2}local function w(x)return string.gsub(x,".",function(l)return string.format("%02x",string.byte(l))end)end;local function y(z,A)local x=""for B=1,A do local C=z%256;x=string.char(C)..x;z=(z-C)/256 end;return x end;local function D(x,B)local A=0;for B=B,B+3 do A=A*256+string.byte(x,B)end;return A end;local function E(F,G)local H=64-(G+9)%64;G=y(8*G,8)F=F.."\128"..string.rep("\0",H)..G;assert(#F%64==0)return F end;local function I(J)J[1]=0x6a09e667;J[2]=0xbb67ae85;J[3]=0x3c6ef372;J[4]=0xa54ff53a;J[5]=0x510e527f;J[6]=0x9b05688c;J[7]=0x1f83d9ab;J[8]=0x5be0cd19;return J end;local function K(F,B,J)local L={}for M=1,16 do L[M]=D(F,B+(M-1)*4)end;for M=17,64 do local N=L[M-15]local O=k(t(N,7),t(N,18),s(N,3))N=L[M-2]L[M]=(L[M-16]+O+L[M-7]+k(t(N,17),t(N,19),s(N,10)))%a end;local d,e,l,P,Q,R,S,T=J[1],J[2],J[3],J[4],J[5],J[6],J[7],J[8]for B=1,64 do local O=k(t(d,2),t(d,13),t(d,22))local U=k(n(d,e),n(d,l),n(e,l))local V=(O+U)%a;local W=k(t(Q,6),t(Q,11),t(Q,25))local X=k(n(Q,R),n(o(Q),S))local Y=(T+W+X+v[B]+L[B])%a;T=S;S=R;R=Q;Q=(P+Y)%a;P=l;l=e;e=d;d=(Y+V)%a end;J[1]=(J[1]+d)%a;J[2]=(J[2]+e)%a;J[3]=(J[3]+l)%a;J[4]=(J[4]+P)%a;J[5]=(J[5]+Q)%a;J[6]=(J[6]+R)%a;J[7]=(J[7]+S)%a;J[8]=(J[8]+T)%a end;local function Z(F)F=E(F,#F)local J=I({})for B=1,#F,64 do K(F,B,J)end;return w(y(J[1],4)..y(J[2],4)..y(J[3],4)..y(J[4],4)..y(J[5],4)..y(J[6],4)..y(J[7],4)..y(J[8],4))end;
	return Z
end)()

local Platoboost = {}
Platoboost.__index = Platoboost

-- Tried in this order; the first one that answers is used.
local HOSTS = { "https://api.platoboost.app", "https://api.platoboost.com", "https://api.platoboost.net" }
local LINK_CACHE_TIME = 10 * 60
local RATE_LIMIT_MESSAGE = "you are being rate limited, please wait 20 seconds and try again."
local BAD_STATUS_MESSAGE = "server returned an invalid status code, please try again later."
local JSON_HEADERS = { ["Content-Type"] = "application/json" }

local rng = Random.new()

local function getRequestFunction()
	return request or http_request or (syn and syn.request) or (http and http.request)
end

local function getHwid()
	if gethwid then
		local ok, hwid = pcall(gethwid)
		if ok and hwid ~= nil and tostring(hwid) ~= "" then
			return tostring(hwid)
		end
	end
	local lp = Players.LocalPlayer
	return tostring(lp and lp.UserId or 0)
end

local function generateNonce()
	local chars = table.create(16)
	for i = 1, 16 do
		chars[i] = string.char(rng:NextInteger(97, 122))
	end
	return table.concat(chars)
end

local function decode(body)
	local ok, result = pcall(HttpService.JSONDecode, HttpService, body)
	if ok and type(result) == "table" then
		return result
	end
	return nil
end

function Platoboost.new(config)
	config = config or {}
	local self = setmetatable({}, Platoboost)
	self.__isPlatoboostInstance = true

	local service = config.ServiceId or config.Service or config.service
	self.service = tonumber(service) or service
	self.secret = config.Secret or config.secret

	local useNonce = config.UseNonce
	if useNonce == nil then
		useNonce = config.useNonce
	end
	self.useNonce = useNonce ~= false

	-- Optional: force one API host, e.g. Host = "https://api.platoboost.app"
	local host = config.Host or config.host
	if type(host) == "string" and host ~= "" then
		host = host:gsub("/+$", "")
		if not host:match("^https?://") then
			host = "https://" .. host
		end
		self.host = host
	end
	self.identifier = nil
	self.requestSending = false
	self.cachedLink = nil
	self.cachedTime = 0

	if self.service == nil or self.service == "" then
		warn("[Platoboost] ServiceId is missing — check your Platoboost dashboard")
	end
	if self.useNonce and (type(self.secret) ~= "string" or self.secret == "") then
		warn("[Platoboost] Secret is missing — keys can't be verified without it")
	end

	return self
end

-- Picks the first host that answers /public/connectivity (200 or 429).
-- If none answers, the first one in HOSTS is used.
function Platoboost:_host()
	if self.host then
		return self.host
	end
	local req = getRequestFunction()
	if req then
		for _, host in ipairs(HOSTS) do
			local ok, res = pcall(req, { Url = host .. "/public/connectivity", Method = "GET" })
			if ok and type(res) == "table" and (res.StatusCode == 200 or res.StatusCode == 429) then
				self.host = host
				return self.host
			end
		end
	end
	self.host = HOSTS[1]
	return self.host
end

function Platoboost:_identifier()
	if not self.identifier then
		self.identifier = sha256(getHwid())
	end
	return self.identifier
end

function Platoboost:_send(options)
	local req = getRequestFunction()
	if not req then
		return nil, "your executor doesn't support HTTP requests."
	end
	local ok, res = pcall(req, options)
	if not ok then
		return nil, tostring(res)
	end
	if type(res) ~= "table" then
		return nil, "invalid response from server."
	end
	return res
end

-- Returns link, or nil + reason
function Platoboost:GetKeyLink()
	if self.cachedLink and self.cachedTime + LINK_CACHE_TIME > os.time() then
		return self.cachedLink
	end
	if self.service == nil or self.service == "" then
		return nil, "Platoboost ServiceId is missing."
	end

	local res, err = self:_send({
		Url = self:_host() .. "/public/start",
		Method = "POST",
		Body = HttpService:JSONEncode({
			service = self.service,
			identifier = self:_identifier(),
		}),
		Headers = JSON_HEADERS,
	})
	if not res then
		return nil, err
	end

	if res.StatusCode == 200 then
		local decoded = decode(res.Body)
		if decoded then
			if decoded.success == true and type(decoded.data) == "table" and decoded.data.url then
				self.cachedLink = decoded.data.url
				self.cachedTime = os.time()
				return self.cachedLink
			end
			return nil, tostring(decoded.message or "Failed to get link.")
		end
	elseif res.StatusCode == 429 then
		return nil, RATE_LIMIT_MESSAGE
	end
	return nil, "Failed to get link."
end

-- With UseNonce the server signs its answer with the secret; check it.
function Platoboost:_integrityOk(data, nonce)
	if not self.useNonce then
		return true
	end
	return data.hash == sha256("true" .. "-" .. nonce .. "-" .. tostring(self.secret))
end

function Platoboost:_redeem(key)
	local nonce = generateNonce()
	local body = {
		identifier = self:_identifier(),
		key = key,
	}
	if self.useNonce then
		body.nonce = nonce
	end

	local res, err = self:_send({
		Url = self:_host() .. "/public/redeem/" .. tostring(self.service),
		Method = "POST",
		Body = HttpService:JSONEncode(body),
		Headers = JSON_HEADERS,
	})
	if not res then
		return false, err
	end
	if res.StatusCode == 429 then
		return false, RATE_LIMIT_MESSAGE
	end
	if res.StatusCode ~= 200 then
		return false, BAD_STATUS_MESSAGE
	end

	local decoded = decode(res.Body)
	if not decoded then
		return false, "invalid response from server."
	end
	if decoded.success ~= true then
		local message = tostring(decoded.message or "request failed.")
		if message:sub(1, 27) == "unique constraint violation" then
			return false, "you already have an active key, please wait for it to expire before redeeming it."
		end
		return false, message
	end

	local data = type(decoded.data) == "table" and decoded.data or {}
	if data.valid ~= true then
		return false, "key is invalid."
	end
	if not self:_integrityOk(data, nonce) then
		return false, "failed to verify integrity."
	end
	return true
end

function Platoboost:_verify(key)
	local nonce = generateNonce()
	local url = self:_host()
		.. "/public/whitelist/"
		.. tostring(self.service)
		.. "?identifier="
		.. self:_identifier()
		.. "&key="
		.. HttpService:UrlEncode(key)
	if self.useNonce then
		url = url .. "&nonce=" .. nonce
	end

	local res, err = self:_send({ Url = url, Method = "GET" })
	if not res then
		return false, err
	end
	if res.StatusCode == 429 then
		return false, RATE_LIMIT_MESSAGE
	end
	if res.StatusCode ~= 200 then
		return false, BAD_STATUS_MESSAGE
	end

	local decoded = decode(res.Body)
	if not decoded then
		return false, "invalid response from server."
	end
	if decoded.success ~= true then
		return false, tostring(decoded.message or "request failed.")
	end

	local data = type(decoded.data) == "table" and decoded.data or {}
	if data.valid == true then
		if not self:_integrityOk(data, nonce) then
			return false, "failed to verify integrity."
		end
		return true
	end

	-- Keys from the Platoboost site start with KEY_ and must be redeemed first
	if key:sub(1, 4) == "KEY_" then
		return self:_redeem(key)
	end
	return false, "key is invalid."
end

-- Returns valid (boolean), reason (string when invalid)
function Platoboost:CheckKey(key)
	key = tostring(key or ""):match("^%s*(.-)%s*$")
	if key == "" then
		return false, "key is empty."
	end
	if self.service == nil or self.service == "" then
		return false, "Platoboost ServiceId is missing."
	end
	if self.useNonce and (type(self.secret) ~= "string" or self.secret == "") then
		return false, "Platoboost Secret is missing."
	end
	if self.requestSending then
		return false, "a request is already being sent, please slow down."
	end

	self.requestSending = true
	local ok, valid, reason = pcall(self._verify, self, key)
	self.requestSending = false

	if not ok then
		return false, tostring(valid)
	end
	return valid == true, reason
end

function Platoboost:Validator()
	local instance = self
	return setmetatable({
		__isPlatoboost = true,
		__instance = instance,
	}, {
		__call = function(_, key)
			return instance:CheckKey(key)
		end,
	})
end

return Platoboost
end

__modules["variables"] = function()
return {
	-- Window Config
	Title = "Ophyn",
	Description = "Key System",
	Logo = "rbxassetid://111673746737789", -- rbxassetid
	Theme = "Plant-Dark",
	Folder = "Ophyn-KSY",

	-- Buttons Config
	getkey = true,

	-- Intro Config
	Intro = "true", -- "false": fade-in on open, fade-out on close
	startintro_size = 80, -- initial square size
	squareintro_time = 1.2,
	squarecontorn = "true", -- "false": removes the outline around the intro square

	-- Themes Config
	Changelogocolor = true,
	Changeiconscolor = true,
	ChangeTheme = "true", -- "false": disable moon icon to change Theme

	-- Section Config
	discord_link = "",
	website_link = "",

	-- Cards ("true" / "false")
	Discord = "true",
	Website = "false",
	Informations = "true",

	-- Keyless mode: no key needed. Status becomes "Keyless" and Submit runs the Callback directly.
	Keyless = {
		enabled = false, -- true: turns keyless mode on
		disabletextbox = true, -- dims the key box and blocks typing
		disablegetkey = true, -- dims "Get a key" and blocks clicks
		showcard = true, -- shows the "Keyless Mode" card
		autoconfirm = false, -- true: runs the Callback automatically when the UI opens
	},

	-- Notification style
	NotifStyle = "1",

	-- Tabs style: "1" = Tabs in a column on the left, "2" = Tabs in a row under the topbar
	TabsStyle = "1",

	-- Games
	SupportedGames = {},

	-- Script Execution
	Callback = function(key)
		-- your script here
	end,
}
end

local KeySystem = {}

function KeySystem.new(options)
	return import("components/window/ui").new(options)
end

-- Works as KeySystem:SetGetkeyTitle("...") or KeySystem.SetGetkeyTitle("...")
local function firstArg(a, b)
	if a == KeySystem then
		return b
	end
	return a
end

function KeySystem.SetGetkeyTitle(a, b)
	import("components/window/ui").SetGetkeyTitle(firstArg(a, b))
	return KeySystem
end

function KeySystem.SetGetkeyIcon(a, b)
	import("components/window/ui").SetGetkeyIcon(firstArg(a, b))
	return KeySystem
end

-- Works as KeySystem:SetNotifStyle("3") / KeySystem:NotifStyle("3")
function KeySystem.SetNotifStyle(a, b)
	import("components/window/ui").SetNotifStyle(firstArg(a, b))
	return KeySystem
end

KeySystem.NotifStyle = KeySystem.SetNotifStyle

-- Works as KeySystem:SetTabsStyle("2") / KeySystem.SetTabsStyle("2") ("1": Tabs on the left,
-- "2": Tabs in a row under the topbar), before or after KeySystem.new(...).
function KeySystem.SetTabsStyle(a, b)
	import("components/window/ui").SetTabsStyle(firstArg(a, b))
	return KeySystem
end

KeySystem.TabsStyle = KeySystem.SetTabsStyle

-- Works as KeySystem:GetMethod({...}) / KeySystem.GetMethod({...}), same as the
-- other Set* helpers above: usable standalone, before KeySystem.new(...) exists.
function KeySystem.GetMethod(a, b)
	return import("components/window/ui").GetMethod(firstArg(a, b))
end

-- Works as KeySystem:SetUIFont("...") / KeySystem.SetUIFont("...")
function KeySystem.SetUIFont(a, b)
	import("components/window/ui").SetUIFont(firstArg(a, b))
	return KeySystem
end

-- Works as KeySystem:SetTitleFont("...") / KeySystem.SetTitleFont("...")
function KeySystem.SetTitleFont(a, b)
	import("components/window/ui").SetTitleFont(firstArg(a, b))
	return KeySystem
end

KeySystem.Jnkie = import("utilities/jnkie")

return KeySystem
