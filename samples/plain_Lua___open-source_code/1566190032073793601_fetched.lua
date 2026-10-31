--[[
	BobloUI v0.11.5-beta.1 - generated bundle, do not edit.
	Source: https://github.com/bobloscript/BobloUI/blob/main/dist/BobloUI.lua
	Modules: 73

THIRD-PARTY LICENSE NOTICES

Lucide Icons:
ISC License

Copyright (c) 2026 Lucide Icons and Contributors

Permission to use, copy, modify, and/or distribute this software for any
purpose with or without fee is hereby granted, provided that the above
copyright notice and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

---

The following Lucide icons are derived from the Feather project:

airplay, alert-circle, alert-octagon, alert-triangle, aperture, arrow-down-circle, arrow-down-left, arrow-down-right, arrow-down, arrow-left-circle, arrow-left, arrow-right-circle, arrow-right, arrow-up-circle, arrow-up-left, arrow-up-right, arrow-up, at-sign, calendar, cast, check, chevron-down, chevron-left, chevron-right, chevron-up, chevrons-down, chevrons-left, chevrons-right, chevrons-up, circle, clipboard, clock, code, columns, command, compass, corner-down-left, corner-down-right, corner-left-down, corner-left-up, corner-right-down, corner-right-up, corner-up-left, corner-up-right, crosshair, database, divide-circle, divide-square, dollar-sign, download, external-link, feather, frown, hash, headphones, help-circle, info, italic, key, layout, life-buoy, link-2, link, loader, lock, log-in, log-out, maximize, meh, minimize, minimize-2, minus-circle, minus-square, minus, monitor, moon, more-horizontal, more-vertical, move, music, navigation-2, navigation, octagon, pause-circle, percent, plus-circle, plus-square, plus, power, radio, rss, search, server, share, shopping-bag, sidebar, smartphone, smile, square, table-2, tablet, target, terminal, trash-2, trash, triangle, tv, type, upload, x-circle, x-octagon, x-square, x, zoom-in, zoom-out

The MIT License (MIT) (for the icons listed above)

Copyright (c) 2013-present Cole Bemis

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

---

lucide-roblox-direct:
MIT License

Copyright (c) 2025 deividcomsono

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
]]
local __modules = {}
local __cache = {}
local function __require(id)
	local cached = __cache[id]
	if cached then return cached[1] end
	local loader = __modules[id]
	if not loader then error("[BobloUI] missing bundled module: " .. id, 2) end
	local result = loader()
	__cache[id] = { result }
	return result
end

__modules["controls/Base"] = function()
local Create = __require("runtime/Create")
local Janitor = __require("runtime/Janitor")
local Signal = __require("runtime/Signal")
local Validate = __require("runtime/Validate")
local Icon = __require("primitives/Icon")
local Base = {}
Base.__index = Base
local function originSource(origin)
return type(origin) == "table" and origin.Source or nil
end
local function isSilent(origin)
return type(origin) == "table" and origin.Silent == true
end
function Base.init(self, section, typeName, options, config)
options = options or {}
config = config or {}
Validate.Control(typeName, options)
if options.Id then
if not string.match(options.Id, "^[A-Za-z0-9_.%-]+$") then
error(`[BobloUI] invalid Id "{options.Id}". Use A-Z, a-z, 0-9, _, ., - only.`, 3)
end
section._window.Registry:AssertAvailable(options.Id, 3)
end
self.Type = typeName
self.Id = options.Id
self.Title = options.Title or ""
self.Description = options.Description
self.Keywords = options.Keywords or {}
self.Callback = options.Callback
self.Icon = options.Icon
self.IconColor = options.IconColor
self._section = section
self._window = section._window
self._janitor = Janitor.new(`{typeName}[{self.Id or self.Title}]`)
self._destroyed = false
self._mounted = false
self._order = options.Order or 0
self._manualVisible = options.Visible ~= false
self._dependencyVisible = true
self._manualDisabled = (options.Disabled == true or type(options.Disabled) == "string")
self._dependencyEnabled = true
self._containerEnabled = true
self._disabled = self._manualDisabled
self._disabledReason = type(options.Disabled) == "string" and options.Disabled or nil
self._loading = false
self._tooltip = options.Tooltip
self._contextMenu = options.ContextMenu
self._stateful = config.Stateful == true
self._persist = config.Persist ~= false and self._stateful and options.IgnoreConfig ~= true
self._value = config.Default
self._default = config.Default
self._baseLayoutStyle = config.Layout or "Inline"
self._layoutStyle = self._baseLayoutStyle
self._adaptive = config.Adaptive == true or options.Adaptive == true
self.Changed = Signal.new(`{typeName}.Changed`)
section._janitor:Add(self, "Destroy", self)
if self.Id then
if self._stateful then
self._window.State:SetDefault(self.Id, config.Default)
end
self._window.Registry:Add(self, {
Id = self.Id,
Type = typeName,
Title = self:_resolve(self.Title),
Description = self:_resolve(self.Description or ""),
Keywords = self.Keywords,
Tab = section._tab.Id,
Section = section.Title,
Path = `{self:_resolve(section._tab.Title)} -> {self:_resolve(section.Title or "Default")}`,
Persist = self._persist,
})
else
self._window.Registry:Add(self, {
Type = typeName,
Title = self:_resolve(self.Title),
Description = self:_resolve(self.Description or ""),
Keywords = self.Keywords,
Tab = section._tab.Id,
Section = section.Title,
Path = `{self:_resolve(section._tab.Title)} -> {self:_resolve(section.Title or "Default")}`,
Persist = false,
})
end
if self.Id and self._stateful then
self._janitor:Add(self._window.State:Watch(self.Id, function(value, old, id, origin)
if self._destroyed then
return
end
self._value = value
if self._mounted then
self:_render(value)
end
if not isSilent(origin) then
if self.Callback then
local ok, err = xpcall(self.Callback, debug.traceback, value)
if not ok then
warn(`[BobloUI] {self.Type} "{self.Id}" callback failed:\n{err}`)
end
end
self.Changed:Fire(value, old, originSource(origin))
end
end, self))
end
self._janitor:Add(self._window.Theme.Changed:Connect(function()
if self._mounted then
self:_render(self:GetValue())
self:_applyDisabled()
self:_applyHoverVisual(false)
if self._controlIcon then
local c = self.IconColor
if typeof(c) == "Color3" then
Icon.setColor(self._controlIcon, c)
elseif type(c) == "string" then
Icon.setColor(self._controlIcon, self._window.Theme:Get(c))
else
Icon.setColor(self._controlIcon, self._window.Theme:Get("TextSecondary"))
end
end
end
end))
self._janitor:Add(self._window.Tokens.Changed:Connect(function()
if self._mounted then
self:_applyTokens()
end
end))
self:_bindDependency(options.VisibleWhen, "visible")
self:_bindDependency(options.EnabledWhen, "enabled")
end
function Base.finish(self)
self._section:_registerControl(self)
if self._section._mounted then
self:_mount()
end
return self
end
function Base:_bindDependency(spec, kind)
if spec == nil then
return
end
local slot = `dep_{kind}`
local function apply(result)
local enabled = result == true
if kind == "visible" then
if self._dependencyVisible == enabled then
return
end
self._dependencyVisible = enabled
self:_applyVisible()
else
if self._dependencyEnabled == enabled then
return
end
self._dependencyEnabled = enabled
self:_applyDisabled()
end
end
if type(spec) == "table" then
local ids = {}
local req = {}
for id, wanted in spec do
table.insert(ids, id)
table.insert(req, id .. " = " .. tostring(wanted))
end
self._dependencyIds = ids
self._window.Registry:Update(self, { DependencyIds = ids, Requirement = table.concat(req, ", ") })
local function eval()
for id, wanted in spec do
if self._window.State:Get(id) ~= wanted then
apply(false)
return
end
end
apply(true)
end
self._janitor:Add(self._window.State:WatchMany(ids, eval), nil, slot)
eval()
elseif type(spec) == "function" then
local function retrack()
self._janitor:Remove(slot)
local ids, result = self._window.State:Track(spec)
self._dependencyIds = ids
self._window.Registry:Update(
self,
{ DependencyIds = ids, Requirement = (#ids > 0 and table.concat(ids, ", ") or nil) }
)
if #ids == 0 then
warn(
`[BobloUI] {self.Type} "{self.Id or self.Title}" dependency tracked 0 State:Get calls. The predicate must read at least one value from this Store.`
)
end
local unsubs = {}
for _, id in ids do
table.insert(
unsubs,
self._window.State:Watch(id, function()
retrack()
end)
)
end
self._janitor:Add(function()
for _, u in unsubs do
u()
end
end, nil, slot)
apply(result == true)
end
retrack()
else
error(`[BobloUI] {kind} dependency must be a table or function.`, 3)
end
end
function Base:_effectiveLayout()
if self._baseLayoutStyle == "Stacked" then
return "Stacked"
end
if self._adaptive and self._section and self._section._controlLayout then
return self._section:_controlLayout()
end
return "Inline"
end
function Base:_measure()
local t = self._window.Tokens
local style = self._layoutStyle or self._baseLayoutStyle
if style == "Stacked" then
return t:Get("ControlHeight") + t:Get("FieldHeight") + 10 + (self.Description and 12 or 0)
end
return t:Get("ControlHeight") + (self.Description and 14 or 0)
end
function Base:_updateResponsiveLayout()
if not self._root then
return
end
local nextStyle = self:_effectiveLayout()
if nextStyle == self._layoutStyle then
return
end
self._layoutStyle = nextStyle
self:_applyTokens()
end
function Base:_mount()
if self._mounted or self._destroyed then
return
end
self._mounted = true
local w = self._window
local t = w.Tokens
local h = self:_measure()
local pad = t:Get("ControlPadding")
self._root = Create.New("Frame", {
Name = self.Type .. "_" .. (self.Id or "Anonymous"),
Size = UDim2.new(1, 0, 0, h),
BackgroundTransparency = 1,
BorderSizePixel = 0,
LayoutOrder = self._order or 0,
Parent = self._section:_controlParent(self),
})
if w._minimal then
self._root.BackgroundTransparency = 0.78
end
self._janitor:Add(self._root)
Create.New("UICorner", { CornerRadius = UDim.new(0, t:Get("ControlRadius")), Parent = self._root })
w:_bind(self._root, { BackgroundColor3 = "ControlHover" })
self._hoverRail = Create.New("Frame", {
Name = "HoverRail",
Size = UDim2.fromOffset(2, 18),
Position = UDim2.new(0, 0, 0.5, 0),
AnchorPoint = Vector2.new(0, 0.5),
BorderSizePixel = 0,
BackgroundTransparency = 1,
Parent = self._root,
})
Create.New("UICorner", { CornerRadius = UDim.new(1, 0), Parent = self._hoverRail })
w:_bind(self._hoverRail, { BackgroundColor3 = "Accent" })
self._separator = Create.New("Frame", {
Name = "Separator",
Size = UDim2.new(1, -pad * 2, 0, 1),
Position = UDim2.new(0, pad, 1, -1),
BorderSizePixel = 0,
BackgroundTransparency = 0.72,
Parent = self._root,
})
w:_bind(self._separator, { BackgroundColor3 = "BorderSubtle" })
local iconOffset = if self.Icon then 22 else 0
if self.Icon then
self._controlIcon = Icon.new(w, self.Icon, {
Size = UDim2.fromOffset(t:Get("IconSm"), t:Get("IconSm")),
Position = UDim2.fromOffset(pad, math.floor((t:Get("ControlHeight") - t:Get("IconSm")) / 2)),
Parent = self._root,
})
local c = self.IconColor
if typeof(c) == "Color3" then
Icon.setColor(self._controlIcon, c)
elseif type(c) == "string" then
Icon.setColor(self._controlIcon, w.Theme:Get(c))
else
Icon.setColor(self._controlIcon, w.Theme:Get("TextSecondary"))
end
end
local titleWidth = if self._layoutStyle == "Stacked"
then UDim2.new(1, -pad * 2 - 76 - iconOffset, 0, t:Get("ControlHeight"))
else UDim2.new(0.48, -pad - iconOffset, 0, t:Get("ControlHeight"))
self._titleLabel = Create.New("TextLabel", {
Size = titleWidth,
Position = UDim2.fromOffset(pad + iconOffset, 0),
BackgroundTransparency = 1,
Font = w.Fonts.Medium,
TextSize = t:Get("FontBody"),
TextXAlignment = Enum.TextXAlignment.Left,
TextTruncate = Enum.TextTruncate.AtEnd,
Text = self:_resolve(self.Title),
Parent = self._root,
})
w:_bind(self._titleLabel, { TextColor3 = "Text" })
if self.Description then
self._descLabel = Create.New("TextLabel", {
Size = UDim2.new(if self._layoutStyle == "Stacked" then 1 else 0.74, -pad * 2, 0, 15),
Position = UDim2.fromOffset(pad, t:Get("ControlHeight") - 10),
BackgroundTransparency = 1,
Font = w.Fonts.Regular,
TextSize = t:Get("FontSmall"),
TextXAlignment = Enum.TextXAlignment.Left,
TextTruncate = Enum.TextTruncate.AtEnd,
Text = self:_resolve(self.Description),
Parent = self._root,
})
w:_bind(self._descLabel, { TextColor3 = "TextTertiary" })
end
if self._layoutStyle == "Stacked" then
local y = t:Get("ControlHeight") + (self.Description and 11 or 0)
self._valueHost = Create.New("Frame", {
Size = UDim2.new(1, -pad * 2, 0, t:Get("FieldHeight")),
Position = UDim2.fromOffset(pad, y),
BackgroundTransparency = 1,
Parent = self._root,
})
else
self._valueHost = Create.New("Frame", {
Size = UDim2.new(0.52, -pad, 0, t:Get("ControlHeight")),
Position = UDim2.new(0.48, 0, 0, 0),
BackgroundTransparency = 1,
Parent = self._root,
})
end
if self._mountValue then
self:_mountValue(self._valueHost)
end
if self._applyValueTokens then
self:_applyValueTokens()
end
self._disabledOverlay = Create.New("Frame", {
Name = "DisabledOverlay",
Size = UDim2.fromScale(1, 1),
BackgroundTransparency = 0.58,
BorderSizePixel = 0,
Active = true,
Visible = false,
ZIndex = 50,
Parent = self._root,
})
Create.New("UICorner", { CornerRadius = UDim.new(0, t:Get("ControlRadius")), Parent = self._disabledOverlay })
w:_bind(self._disabledOverlay, { BackgroundColor3 = "Canvas" })
self._janitor:Add(self._root.MouseEnter:Connect(function()
self:_applyHoverVisual(true)
end))
self._janitor:Add(self._root.MouseLeave:Connect(function()
self:_applyHoverVisual(false)
end))
if w.Interactions and (self._tooltip or self._contextMenu or self.Id or self._disabledReason) then
self._janitor:Add(w.Interactions:Attach(self, self._root, function()
return self._tooltip or self._disabledReason
end, self._contextMenu))
end
self:_applyVisible()
self:_applyDisabled()
self:_render(self:GetValue())
self._section:_refreshSeparators()
end
function Base:_applyHoverVisual(hover)
if not self._root then
return
end
self._root.BackgroundColor3 = self._window.Theme:Get("ControlHover")
local active = hover and not self._disabled
self._window.Motion:Tween(self._root, "Fast", {
BackgroundTransparency = if active
then (if self._window._minimal then 0.54 else 0.74)
else (if self._window._minimal then 0.78 else 1),
})
if self._hoverRail then
self._window.Motion:Tween(self._hoverRail, "Fast", { BackgroundTransparency = if active then 0.16 else 1 })
end
end
function Base:_resolve(v)
return self._window.Locale and self._window.Locale:Resolve(v) or v
end
function Base:_refreshText()
local title = self:_resolve(self.Title)
local desc = self:_resolve(self.Description or "")
if self._titleLabel then
self._titleLabel.Text = title
end
if self._descLabel then
self._descLabel.Text = desc
end
self._window.Registry:Update(self, {
Title = title,
Description = desc,
Path = `{self:_resolve(self._section._tab.Title)} -> {self:_resolve(self._section.Title or "Default")}`,
})
end
function Base:_applyTokens()
if not self._root then
return
end
local t = self._window.Tokens
self._layoutStyle = self:_effectiveLayout()
local h = self:_measure()
local pad = t:Get("ControlPadding")
self._root.Size = UDim2.new(1, 0, 0, h)
local corner = self._root:FindFirstChildOfClass("UICorner")
if corner then
corner.CornerRadius = UDim.new(0, t:Get("ControlRadius"))
end
if self._disabledOverlay then
local disabledCorner = self._disabledOverlay:FindFirstChildOfClass("UICorner")
if disabledCorner then
disabledCorner.CornerRadius = UDim.new(0, t:Get("ControlRadius"))
end
end
local iconOffset = if self.Icon then 22 else 0
if self._controlIcon then
self._controlIcon.Size = UDim2.fromOffset(t:Get("IconSm"), t:Get("IconSm"))
self._controlIcon.Position = UDim2.fromOffset(pad, math.floor((t:Get("ControlHeight") - t:Get("IconSm")) / 2))
end
if self._titleLabel then
self._titleLabel.Position = UDim2.fromOffset(pad + iconOffset, 0)
self._titleLabel.TextSize = t:Get("FontBody")
self._titleLabel.Size = if self._layoutStyle == "Stacked"
then UDim2.new(1, -pad * 2 - 76 - iconOffset, 0, t:Get("ControlHeight"))
else UDim2.new(0.48, -pad - iconOffset, 0, t:Get("ControlHeight"))
end
if self._descLabel then
self._descLabel.Position = UDim2.fromOffset(pad, t:Get("ControlHeight") - 10)
self._descLabel.TextSize = t:Get("FontSmall")
end
if self._separator then
self._separator.Size = UDim2.new(1, -pad * 2, 0, 1)
self._separator.Position = UDim2.new(0, pad, 1, -1)
end
if self._valueHost then
if self._layoutStyle == "Stacked" then
self._valueHost.Size = UDim2.new(1, -pad * 2, 0, t:Get("FieldHeight"))
self._valueHost.Position = UDim2.fromOffset(pad, t:Get("ControlHeight") + (self.Description and 11 or 0))
else
self._valueHost.Size = UDim2.new(0.52, -pad, 0, t:Get("ControlHeight"))
self._valueHost.Position = UDim2.new(0.48, 0, 0, 0)
end
end
if self._applyValueTokens then
self:_applyValueTokens()
end
end
function Base:_render(value) end
function Base:GetValue()
if self.Id and self._stateful then
return self._window.State:Get(self.Id)
end
return self._value
end
function Base:_commitOwnState(old, silent)
local value = self._window.State:Get(self.Id)
self._value = value
if self._mounted then
self:_render(value)
end
if not silent then
if self.Callback then
local ok, err = xpcall(self.Callback, debug.traceback, value)
if not ok then
warn(`[BobloUI] {self.Type} "{self.Id}" callback failed:\n{err}`)
end
end
self.Changed:Fire(value, old, self)
end
end
function Base:SetValue(value, silent)
if not self._stateful then
self._value = value
if self._mounted then
self:_render(value)
end
if not silent then
self.Changed:Fire(value, nil, self)
end
return self
end
if self.Id then
local old = self._window.State:Get(self.Id)
local changed = self._window.State:Set(self.Id, value, { Source = self, Silent = silent == true })
if changed then
self:_commitOwnState(old, silent == true)
end
else
local old = self._value
self._value = value
if self._mounted then
self:_render(value)
end
if not silent then
if self.Callback then
self.Callback(value)
end
self.Changed:Fire(value, old, self)
end
end
return self
end
function Base:SetTitle(text)
self.Title = text
if self._titleLabel then
self._titleLabel.Text = self:_resolve(text)
end
self._window.Registry:Update(self, { Title = text })
return self
end
function Base:SetDescription(text)
self.Description = text
if self._descLabel then
self._descLabel.Text = self:_resolve(text or "")
end
self._window.Registry:Update(self, { Description = text or "" })
if self._mounted then
self:_applyTokens()
end
return self
end
function Base:SetKeywords(words)
self.Keywords = words or {}
self._window.Registry:Update(self, { Keywords = self.Keywords })
return self
end
function Base:SetIcon(icon, color)
self.Icon = icon
if color ~= nil then
self.IconColor = color
end
if self._controlIcon then
self._controlIcon:Destroy()
self._controlIcon = nil
end
if self._root and icon then
local t = self._window.Tokens
local pad = t:Get("ControlPadding")
self._controlIcon = Icon.new(self._window, icon, {
Size = UDim2.fromOffset(t:Get("IconSm"), t:Get("IconSm")),
Position = UDim2.fromOffset(pad, math.floor((t:Get("ControlHeight") - t:Get("IconSm")) / 2)),
Parent = self._root,
})
local c = self.IconColor
if typeof(c) == "Color3" then
Icon.setColor(self._controlIcon, c)
elseif type(c) == "string" then
Icon.setColor(self._controlIcon, self._window.Theme:Get(c))
else
Icon.setColor(self._controlIcon, self._window.Theme:Get("TextSecondary"))
end
self:_applyTokens()
end
return self
end
function Base:_applyVisible()
local visible = self._manualVisible and self._dependencyVisible
if self._root then
self._root.Visible = visible
end
self._window.Registry:Update(self, { Hidden = not visible })
if self._section and self._section._mounted then
self._section:_refreshSeparators()
end
end
function Base:SetVisible(v)
self._manualVisible = v == true
self:_applyVisible()
return self
end
function Base:IsVisible()
return self._manualVisible and self._dependencyVisible
end
function Base:_applyDisabled()
self._disabled = self._manualDisabled or not self._dependencyEnabled or not self._containerEnabled
if self._disabledOverlay then
self._disabledOverlay.Visible = self._disabled
end
if self._root then
self:_applyHoverVisual(false)
end
end
function Base:SetDisabled(v, reason)
self._manualDisabled = v == true
self._disabledReason = reason
self:_applyDisabled()
return self
end
function Base:IsDisabled()
return self._manualDisabled or not self._dependencyEnabled or not self._containerEnabled
end
function Base:_setContainerEnabled(enabled)
self._containerEnabled = enabled ~= false
self:_applyDisabled()
return self
end
function Base:SetLoading(v)
self._loading = v == true
if self._setLoadingVisual then
self:_setLoadingVisual(self._loading)
end
return self
end
function Base:SetBadge(text, style)
if self._badge then
self._badge:Destroy()
self._badge = nil
end
if text and self._root then
local Badge = __require("primitives/Badge")
self._badge = Badge.new(self._window, text, style or "Neutral", self._root)
self._badge.Position = UDim2.new(0.57, -6, 0, 13)
self._badge.AnchorPoint = Vector2.new(1, 0)
end
return self
end
function Base:Reset(silent)
if self.Id and self._stateful then
local old = self._window.State:Get(self.Id)
local changed = self._window.State:Reset(self.Id, { Source = self, Silent = silent == true })
if changed then
self:_commitOwnState(old, silent == true)
end
elseif self._stateful then
self:SetValue(self._default, silent)
end
return self
end
function Base:CopyValue()
local value = self:GetValue()
local text
if typeof(value) == "Color3" then
text = "#" .. value:ToHex()
elseif type(value) == "table" then
local parts = {}
for k, v in value do
table.insert(parts, tostring(k) .. "=" .. tostring(v))
end
text = table.concat(parts, ", ")
else
text = tostring(value)
end
local Env = __require("runtime/Env")
Env.SetClipboard(text)
return text
end
function Base:PasteValue()
if not self._stateful then
return false, "not stateful"
end
local Env = __require("runtime/Env")
local raw = Env.GetClipboard()
if raw == nil then
return false, "clipboard read unavailable"
end
local current = self:GetValue()
local value = raw
local kind = typeof(current)
if kind == "Color3" then
local hex = string.gsub(raw, "#", "")
local ok, c = pcall(Color3.fromHex, hex)
if not ok then
return false, "invalid color"
end
value = c
elseif type(current) == "number" then
value = tonumber(raw)
if value == nil then
return false, "invalid number"
end
elseif type(current) == "boolean" then
local v = string.lower(string.gsub(raw, "%s+", ""))
if v == "true" or v == "1" or v == "on" then
value = true
elseif v == "false" or v == "0" or v == "off" then
value = false
else
return false, "invalid boolean"
end
elseif type(current) == "string" or current == nil then
value = raw
else
return false, "value type is not pasteable"
end
self:SetValue(value)
return true
end
function Base:Highlight(duration)
if not self._root then
return self
end
local stroke = Create.New("UIStroke", { Thickness = 1.5, Transparency = 0.05, Parent = self._root })
self._window:_bind(stroke, { Color = "Accent" })
task.delay(duration or 0.9, function()
if stroke.Parent then
stroke:Destroy()
end
end)
return self
end
function Base:Reveal()
self._section._tab:Select()
self._section:SetCollapsed(false)
task.defer(function()
if self._root and self._root.Parent then
local page = self._section._tab._page
local top = self._root.AbsolutePosition.Y - page.AbsolutePosition.Y + page.CanvasPosition.Y
self._window.Motion:Tween(page, "Normal", { CanvasPosition = Vector2.new(0, math.max(0, top - 24)) })
self:Highlight()
end
end)
return self
end
function Base:OnChanged(fn)
return self.Changed:Connect(fn)
end
function Base:GetInstance()
return self._root
end
function Base:Destroy()
if self._destroyed then
return
end
self._destroyed = true
self._section._janitor:Release(self)
self._window.Registry:Remove(self)
self.Changed:Destroy()
self._janitor:Destroy()
self._section:_removeControl(self)
end
return Base
end

__modules["controls/Button"] = function()
local Create = __require("runtime/Create")
local Base = __require("controls/Base")
local Signal = __require("runtime/Signal")
local Spinner = __require("primitives/Spinner")
local Button = setmetatable({}, { __index = Base })
Button.__index = Button
function Button.new(section, options)
local self = setmetatable({}, Button)
Base.init(self, section, "Button", options, { Stateful = false, Persist = false, Adaptive = true })
self.Variant = options.Variant or "Default"
self.Text = options.Text or options.Title or "Run"
self.Confirm = options.Confirm or (options.Risky and "Confirm this action?")
self.DoubleClick = options.DoubleClick
self.DoubleClickWindow = tonumber(options.DoubleClickWindow) or 0.45
self.SubButtons = options.SubButtons or options.Actions or {}
self._lastClick = 0
self.Clicked = Signal.new("Button.Clicked")
self._janitor:Add(self.Clicked)
return Base.finish(self)
end
function Button:_tokens()
if self.Variant == "Primary" then
return "AccentButton", "TextOnAccentButton", "AccentButtonHover", "AccentButtonPressed"
end
if self.Variant == "Danger" then
return "Error", "TextOnError", "ErrorHover", "ErrorPressed"
end
if self.Variant == "Ghost" then
return "ControlInset", "TextSecondary", "ControlHover", "ControlPressed"
end
return "SurfaceSecondary", "Text", "ControlHover", "ControlPressed"
end
function Button:_refreshInteractive()
if not self._button then
return
end
local bg, _, hover, pressed = self:_tokens()
local token = if self._pressed then pressed elseif self._hovered then hover else bg
self._button.BackgroundColor3 = self._window.Theme:Get(token)
end
function Button:_mountValue(host)
local w = self._window
local bg, fg = self:_tokens()
local h = w.Tokens:Get("FieldHeight")
self._button = Create.New("TextButton", {
Size = UDim2.new(#self.SubButtons > 0 and 0.68 or 1, #self.SubButtons > 0 and -3 or 0, 0, h),
Position = UDim2.new(0, 0, 0.5, 0),
AnchorPoint = Vector2.new(0, 0.5),
BorderSizePixel = 0,
AutoButtonColor = false,
Text = self:_resolve(self.Text),
Font = w.Fonts.Medium,
TextSize = w.Tokens:Get("FontBody"),
Parent = host,
})
Create.New("UICorner", { CornerRadius = UDim.new(0, w.Tokens:Get("FieldRadius")), Parent = self._button })
self._buttonScale = Create.New("UIScale", { Scale = 1, Parent = self._button })
self._stroke = Create.New("UIStroke", { Thickness = 1, Transparency = 0.48, Parent = self._button })
w:_bind(self._stroke, { Color = if self.Variant == "Primary" then "AccentBorder" else "BorderSubtle" })
w:_bind(self._button, { BackgroundColor3 = bg, TextColor3 = fg })
self._janitor:Add(self._button.MouseEnter:Connect(function()
if not self._loading and not self:IsDisabled() then
self._hovered = true
self:_refreshInteractive()
w.Motion:Tween(self._stroke, "Fast", { Transparency = 0.2 })
end
end))
self._janitor:Add(self._button.MouseLeave:Connect(function()
self._hovered = false
self._pressed = false
self:_refreshInteractive()
w.Motion:Tween(self._stroke, "Fast", { Transparency = 0.48 })
w.Motion:Tween(self._buttonScale, "Fast", { Scale = 1 })
end))
self._janitor:Add(self._button.MouseButton1Down:Connect(function()
if not self:IsDisabled() and not self._loading then
self._pressed = true
self:_refreshInteractive()
w.Motion:Tween(self._buttonScale, "Fast", { Scale = 0.985 })
end
end))
self._janitor:Add(self._button.MouseButton1Up:Connect(function()
self._pressed = false
self:_refreshInteractive()
w.Motion:Tween(self._buttonScale, "Fast", { Scale = 1 })
end))
self._janitor:Add(w.Theme.Changed:Connect(function()
self:_refreshInteractive()
end))
self._janitor:Add(self._button.MouseButton1Click:Connect(function()
self:Click()
end))
self._actionButtons = {}
for _, action in self.SubButtons do
self:_mountAction(host, action)
end
end
function Button:_mountAction(host, action)
local w = self._window
local count = math.max(1, #self.SubButtons)
local index = #self._actionButtons + 1
local button = Create.New("TextButton", {
Size = UDim2.new(0.32 / count, -3, 0, w.Tokens:Get("FieldHeight")),
Position = UDim2.new(0.68 + ((index - 1) * 0.32 / count), 3, 0.5, 0),
AnchorPoint = Vector2.new(0, 0.5),
BackgroundTransparency = 0,
BorderSizePixel = 0,
AutoButtonColor = false,
Text = tostring(action.Text or action.Title or "…"),
Font = w.Fonts.Medium,
TextSize = w.Tokens:Get("FontSmall"),
Parent = host,
})
Create.New("UICorner", { CornerRadius = UDim.new(0, w.Tokens:Get("FieldRadius")), Parent = button })
local stroke = Create.New("UIStroke", {
Thickness = 1,
Transparency = 0.48,
LineJoinMode = Enum.LineJoinMode.Round,
Parent = button,
})
w:_bind(button, { BackgroundColor3 = "ControlInset", TextColor3 = "TextSecondary" })
w:_bind(stroke, { Color = "BorderSubtle" })
button.MouseButton1Click:Connect(function()
if not self:IsDisabled() and not self._loading and action.Callback then
local ok, err = xpcall(action.Callback, debug.traceback, self)
if not ok then
warn(err)
end
end
end)
table.insert(self._actionButtons, button)
return button
end
function Button:AddAction(action)
table.insert(self.SubButtons, action or {})
if self._button then
self._button.Size = UDim2.new(0.68, -3, 0, self._window.Tokens:Get("FieldHeight"))
for _, button in self._actionButtons or {} do
button:Destroy()
end
self._actionButtons = {}
for _, spec in self.SubButtons do
self:_mountAction(self._valueHost, spec)
end
end
return self
end
function Button:AddKeybind(options)
options = table.clone(options or {})
options.AttachTo = self
return __require("controls/Keybind").new(self._section, options)
end
function Button:Click()
if self:IsDisabled() or self._loading then
return self
end
if self._window.Sound then
self._window.Sound:Play("Click")
end
if self.DoubleClick then
local now = os.clock()
if now - self._lastClick > self.DoubleClickWindow then
self._lastClick = now
return self
end
self._lastClick = 0
end
local function run()
if self.Callback then
local ok, err = xpcall(self.Callback, debug.traceback)
if not ok then
warn(`[BobloUI] Button "{self.Title}" callback failed:\n{err}`)
end
end
self.Clicked:Fire()
end
if self.Confirm and self._window.Dialog then
task.spawn(function()
local ok = self._window.Dialog:Confirm({ Title = self.Title, Content = self.Confirm }):Await()
if ok then
run()
end
end)
else
run()
end
return self
end
function Button:_setLoadingVisual(v)
if not self._button then
return
end
self._button.Text = if v then "" else self:_resolve(self.Text)
if self._spinner then
self._spinner:Destroy()
self._spinner = nil
end
if v then
self._spinner = Spinner.new(self._window, self._button, 15)
self._spinner.Position = UDim2.fromScale(0.5, 0.5)
self._spinner.AnchorPoint = Vector2.new(0.5, 0.5)
end
end
function Button:_refreshText()
Base._refreshText(self)
if self._button and not self._loading then
self._button.Text = self:_resolve(self.Text)
end
end
function Button:_applyValueTokens()
if self._button then
self._button.Size = UDim2.new(
#self.SubButtons > 0 and 0.68 or 1,
#self.SubButtons > 0 and -3 or 0,
0,
self._window.Tokens:Get("FieldHeight")
)
self._button.TextSize = self._window.Tokens:Get("FontBody")
end
for _, button in self._actionButtons or {} do
button.Size = UDim2.new(0.32 / math.max(1, #self.SubButtons), -3, 0, self._window.Tokens:Get("FieldHeight"))
button.TextSize = self._window.Tokens:Get("FontSmall")
end
end
return Button
end

__modules["controls/Code"] = function()
local Create = __require("runtime/Create")
local Base = __require("controls/Base")
local Env = __require("runtime/Env")
local Code = setmetatable({}, { __index = Base })
Code.__index = Code
function Code.new(section, options)
options = options or {}
local self = setmetatable({}, Code)
self.Code = tostring(options.Code or options.Content or "")
self.Height = math.max(72, tonumber(options.Height) or 150)
self.Copy = options.Copy ~= false
self.Language = options.Language or "lua"
Base.init(self, section, "Code", options, { Stateful = false, Default = nil, Layout = "Stacked" })
return Base.finish(self)
end
function Code:_measure()
local t = self._window.Tokens
return t:Get("ControlHeight") + self.Height + 12 + (self.Description and 12 or 0)
end
function Code:_mountValue(host)
local w = self._window
local t = w.Tokens
self._box = Create.New("Frame", {
Size = UDim2.new(1, 0, 0, self.Height),
BackgroundTransparency = 0,
BorderSizePixel = 0,
ClipsDescendants = true,
Parent = host,
})
Create.New("UICorner", { CornerRadius = UDim.new(0, t:Get("FieldRadius")), Parent = self._box })
self._scroll = Create.New("ScrollingFrame", {
Size = UDim2.fromScale(1, 1),
BackgroundTransparency = 1,
BorderSizePixel = 0,
Active = true,
ScrollingEnabled = true,
ScrollingDirection = Enum.ScrollingDirection.Y,
AutomaticCanvasSize = Enum.AutomaticSize.Y,
CanvasSize = UDim2.fromOffset(0, 0),
ScrollBarThickness = 4,
ScrollBarImageTransparency = 0.2,
VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar,
Parent = self._box,
})
Create.New("UIPadding", {
PaddingTop = UDim.new(0, 10),
PaddingBottom = UDim.new(0, 10),
PaddingLeft = UDim.new(0, 10),
PaddingRight = UDim.new(0, 10),
Parent = self._scroll,
})
self._text = Create.New("TextLabel", {
Size = UDim2.new(1, 0, 0, 0),
AutomaticSize = Enum.AutomaticSize.Y,
BackgroundTransparency = 1,
BorderSizePixel = 0,
TextWrapped = false,
TextXAlignment = Enum.TextXAlignment.Left,
TextYAlignment = Enum.TextYAlignment.Top,
Font = Enum.Font.Code,
TextSize = 12,
Text = self.Code,
Parent = self._scroll,
})
local s = Create.New("UIStroke", { Thickness = 1, Transparency = 0.58, Parent = self._box })
w:_bind(s, { Color = "BorderSubtle" })
w:_bind(self._box, { BackgroundColor3 = "ControlInset" })
w:_bind(self._scroll, { ScrollBarImageColor3 = "BorderStrong" })
w:_bind(self._text, { TextColor3 = "TextSecondary" })
if self.Copy then
self._copy = Create.New("TextButton", {
Size = UDim2.fromOffset(48, 24),
Position = UDim2.new(1, -8, 0, 8),
AnchorPoint = Vector2.new(1, 0),
BackgroundTransparency = 0,
BorderSizePixel = 0,
Text = "Copy",
Font = w.Fonts.Medium,
TextSize = t:Get("FontCaption"),
ZIndex = 2,
Parent = self._box,
})
Create.New("UICorner", { CornerRadius = UDim.new(0, 6), Parent = self._copy })
local copyStroke = Create.New("UIStroke", {
Thickness = 1,
Transparency = 0.42,
LineJoinMode = Enum.LineJoinMode.Round,
Parent = self._copy,
})
w:_bind(self._copy, { BackgroundColor3 = "SurfaceRaised", TextColor3 = "TextSecondary" })
w:_bind(copyStroke, { Color = "Border" })
self._janitor:Add(self._copy.MouseButton1Click:Connect(function()
Env.SetClipboard(self.Code)
if w.Notify then
w.Notify:Push({ Title = "Code copied", Variant = "Success", Duration = 2 })
end
end))
end
end
function Code:_applyValueTokens()
if self._valueHost then
self._valueHost.Size = UDim2.new(1, -self._window.Tokens:Get("ControlPadding") * 2, 0, self.Height)
end
if self._box then
self._box.Size = UDim2.new(1, 0, 0, self.Height)
end
if self._scroll then
self._scroll.Size = UDim2.fromScale(1, 1)
end
end
function Code:SetCode(text)
self.Code = tostring(text or "")
if self._text then
self._text.Text = self.Code
end
if self._scroll then
self._scroll.CanvasPosition = Vector2.zero
end
return self
end
function Code:GetCode()
return self.Code
end
function Code:CopyCode()
Env.SetClipboard(self.Code)
return self.Code
end
return Code
end

__modules["controls/ColorPicker"] = function()
local Create = __require("runtime/Create")
local Base = __require("controls/Base")
local Popover = __require("primitives/Popover")
local Sheet = __require("primitives/Sheet")
local Util = __require("runtime/Util")
local ColorPicker = setmetatable({}, { __index = Base })
ColorPicker.__index = ColorPicker
local HUE = ColorSequence.new({
ColorSequenceKeypoint.new(0, Color3.fromHSV(0, 1, 1)),
ColorSequenceKeypoint.new(1 / 6, Color3.fromHSV(1 / 6, 1, 1)),
ColorSequenceKeypoint.new(2 / 6, Color3.fromHSV(2 / 6, 1, 1)),
ColorSequenceKeypoint.new(3 / 6, Color3.fromHSV(3 / 6, 1, 1)),
ColorSequenceKeypoint.new(4 / 6, Color3.fromHSV(4 / 6, 1, 1)),
ColorSequenceKeypoint.new(5 / 6, Color3.fromHSV(5 / 6, 1, 1)),
ColorSequenceKeypoint.new(1, Color3.fromHSV(1, 1, 1)),
})
function ColorPicker.new(section, options)
local self = setmetatable({}, ColorPicker)
self.Alpha = options.Alpha == true
self.Presets = options.Presets or {}
self._popup = nil
local d = options.Default or Color3.new(1, 1, 1)
if self.Alpha then
d = { Color = d, Alpha = math.clamp(options.DefaultAlpha or 1, 0, 1) }
end
Base.init(self, section, "ColorPicker", options, { Stateful = true, Default = d, Adaptive = true })
return Base.finish(self)
end
function ColorPicker:_colour(v)
return self.Alpha and (type(v) == "table" and v.Color or Color3.new(1, 1, 1)) or v
end
function ColorPicker:_mountValue(host)
local w = self._window
local t = w.Tokens
self._button = Create.New("TextButton", {
Size = UDim2.new(1, 0, 0, t:Get("FieldHeight")),
Position = UDim2.new(0, 0, 0.5, 0),
AnchorPoint = Vector2.new(0, 0.5),
BackgroundTransparency = 0,
BorderSizePixel = 0,
AutoButtonColor = false,
Text = "",
Parent = host,
})
Create.New("UICorner", { CornerRadius = UDim.new(0, t:Get("FieldRadius")), Parent = self._button })
self._triggerStroke = Create.New("UIStroke", { Thickness = 1, Transparency = 0.45, Parent = self._button })
w:_bind(self._triggerStroke, { Color = "BorderSubtle" })
w:_bind(self._button, { BackgroundColor3 = "ControlInset" })
self._hexLabel = Create.New("TextLabel", {
Size = UDim2.new(1, -44, 1, 0),
Position = UDim2.fromOffset(10, 0),
BackgroundTransparency = 1,
Font = w.Fonts.Medium,
TextSize = t:Get("FontSmall"),
TextXAlignment = Enum.TextXAlignment.Left,
Parent = self._button,
})
w:_bind(self._hexLabel, { TextColor3 = "TextSecondary" })
self._swatch = Create.New("Frame", {
Size = UDim2.fromOffset(24, 18),
Position = UDim2.new(1, -8, 0.5, 0),
AnchorPoint = Vector2.new(1, 0.5),
BorderSizePixel = 0,
Parent = self._button,
})
Create.New("UICorner", { CornerRadius = UDim.new(0, 6), Parent = self._swatch })
Create.New("UIStroke", { Thickness = 1, Color = Color3.new(1, 1, 1), Transparency = 0.76, Parent = self._swatch })
self._janitor:Add(self._button.MouseEnter:Connect(function()
if not self._popup then
self._button.BackgroundColor3 = w.Theme:Get("ControlHover")
end
end))
self._janitor:Add(self._button.MouseLeave:Connect(function()
if not self._popup then
self._button.BackgroundColor3 = w.Theme:Get("ControlInset")
end
end))
self._janitor:Add(self._button.MouseButton1Click:Connect(function()
if not self:IsDisabled() then
if self._popup then
self:Close()
else
self:Open()
end
end
end))
end
function ColorPicker:_render(v)
local c = self:_colour(v)
if typeof(c) ~= "Color3" then
c = Color3.new(1, 1, 1)
end
if self._swatch then
self._swatch.BackgroundColor3 = c
self._hexLabel.Text = Util.toHex(c)
end
self:_syncPopup(c)
end
function ColorPicker:_syncPopup(c)
if not self._sv then
return
end
local h, s, v = c:ToHSV()
self._h = h
self._s = s
self._v = v
self._sv.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
self._svCursor.Position = UDim2.fromScale(s, 1 - v)
self._hueCursor.Position = UDim2.fromScale(h, 0.5)
if self._hexBox and not self._hexBox:IsFocused() then
self._hexBox.Text = Util.toHex(c)
end
if self._rgbBoxes then
local vals = { math.round(c.R * 255), math.round(c.G * 255), math.round(c.B * 255) }
for i, b in self._rgbBoxes do
if not b:IsFocused() then
b.Text = tostring(vals[i])
end
end
end
if self._alphaBox and not self._alphaBox:IsFocused() then
self._alphaBox.Text = tostring(math.round(self:GetAlpha() * 100)) .. "%"
end
end
function ColorPicker:_fieldStroke(box)
local w = self._window
local s = Create.New("UIStroke", { Thickness = 1, Transparency = 0.55, Parent = box })
w:_bind(s, { Color = "BorderSubtle" })
box.Focused:Connect(function()
s.Transparency = 0.10
s.Color = w.Theme:Get("AccentBorder")
end)
box.FocusLost:Connect(function()
s.Transparency = 0.55
s.Color = w.Theme:Get("BorderSubtle")
end)
end
function ColorPicker:_buildPopup(frame)
local w = self._window
local c = self:_colour(self:GetValue())
local h, s, v = c:ToHSV()
self._h = h
self._s = s
self._v = v
local top = if w.Device.Layout == "Drawer" then 20 else 8
local sv = Create.New("Frame", {
Name = "SV",
Size = UDim2.new(1, -16, 0, 94),
Position = UDim2.fromOffset(8, top),
BackgroundColor3 = Color3.fromHSV(h, 1, 1),
BorderSizePixel = 0,
ClipsDescendants = true,
Parent = frame,
})
Create.New("UICorner", { CornerRadius = UDim.new(0, w.Tokens:Get("CornerSm")), Parent = sv })
self._sv = sv
local white = Create.New(
"Frame",
{ Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0, Parent = sv }
)
Create.New("UIGradient", {
Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1) }),
Parent = white,
})
local black = Create.New(
"Frame",
{ Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.new(0, 0, 0), BorderSizePixel = 0, Parent = sv }
)
Create.New("UIGradient", {
Rotation = 90,
Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0) }),
Parent = black,
})
self._svCursor = Create.New("Frame", {
Size = UDim2.fromOffset(11, 11),
Position = UDim2.fromScale(s, 1 - v),
AnchorPoint = Vector2.new(0.5, 0.5),
BackgroundTransparency = 1,
ZIndex = 4,
Parent = sv,
})
Create.New("UICorner", { CornerRadius = UDim.new(1, 0), Parent = self._svCursor })
Create.New("UIStroke", { Thickness = 2, Color = Color3.new(1, 1, 1), Parent = self._svCursor })
local svHit = Create.New(
"TextButton",
{ Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "", ZIndex = 5, Parent = sv }
)
local function setSV(pos)
local x = math.clamp((pos.X - sv.AbsolutePosition.X) / math.max(1, sv.AbsoluteSize.X), 0, 1)
local y = math.clamp((pos.Y - sv.AbsolutePosition.Y) / math.max(1, sv.AbsoluteSize.Y), 0, 1)
self._s = x
self._v = 1 - y
self:_setColour(Color3.fromHSV(self._h, self._s, self._v))
end
svHit.InputBegan:Connect(function(i)
if i.UserInputType ~= Enum.UserInputType.MouseButton1 and i.UserInputType ~= Enum.UserInputType.Touch then
return
end
setSV(i.Position)
w.Input:CapturePointer(self, i, function(move)
setSV(move.Position)
end, function() end)
end)
local hueY = top + 102
local hue = Create.New("Frame", {
Name = "Hue",
Size = UDim2.new(1, -16, 0, 12),
Position = UDim2.fromOffset(8, hueY),
BackgroundColor3 = Color3.new(1, 1, 1),
BorderSizePixel = 0,
ClipsDescendants = false,
Parent = frame,
})
Create.New("UICorner", { CornerRadius = UDim.new(1, 0), Parent = hue })
Create.New("UIGradient", { Color = HUE, Parent = hue })
self._hue = hue
self._hueCursor = Create.New("Frame", {
Size = UDim2.fromOffset(4, 18),
Position = UDim2.fromScale(h, 0.5),
AnchorPoint = Vector2.new(0.5, 0.5),
BackgroundColor3 = Color3.new(1, 1, 1),
BorderSizePixel = 0,
ZIndex = 4,
Parent = hue,
})
Create.New("UICorner", { CornerRadius = UDim.new(1, 0), Parent = self._hueCursor })
Create.New("UIStroke", { Thickness = 1, Color = Color3.new(0, 0, 0), Transparency = 0.5, Parent = self._hueCursor })
local hueHit = Create.New("TextButton", {
Size = UDim2.new(1, 0, 0, 26),
Position = UDim2.new(0, 0, 0.5, 0),
AnchorPoint = Vector2.new(0, 0.5),
BackgroundTransparency = 1,
Text = "",
ZIndex = 5,
Parent = hue,
})
local function setHue(pos)
self._h = math.clamp((pos.X - hue.AbsolutePosition.X) / math.max(1, hue.AbsoluteSize.X), 0, 1)
self:_setColour(Color3.fromHSV(self._h, self._s, self._v))
end
hueHit.InputBegan:Connect(function(i)
if i.UserInputType ~= Enum.UserInputType.MouseButton1 and i.UserInputType ~= Enum.UserInputType.Touch then
return
end
setHue(i.Position)
w.Input:CapturePointer(self, i, function(move)
setHue(move.Position)
end, function() end)
end)
local fieldsY = top + 126
self._hexBox = Create.New("TextBox", {
Size = UDim2.new(0.36, -5, 0, 28),
Position = UDim2.fromOffset(8, fieldsY),
BackgroundTransparency = 0,
BorderSizePixel = 0,
ClearTextOnFocus = false,
Text = Util.toHex(c),
Font = w.Fonts.Regular,
TextSize = w.Tokens:Get("FontSmall"),
Parent = frame,
})
Create.New("UICorner", { CornerRadius = UDim.new(0, w.Tokens:Get("CornerSm")), Parent = self._hexBox })
w:_bind(self._hexBox, { BackgroundColor3 = "ControlInset", TextColor3 = "Text" })
self:_fieldStroke(self._hexBox)
local boxes = {}
self._rgbBoxes = boxes
for i in { 1, 2, 3 } do
local box = Create.New("TextBox", {
Size = UDim2.new(0.213, -4, 0, 28),
Position = UDim2.new(0.36 + (i - 1) * 0.213, 4, 0, fieldsY),
BackgroundTransparency = 0,
BorderSizePixel = 0,
ClearTextOnFocus = false,
Text = tostring(math.round(({ c.R, c.G, c.B })[i] * 255)),
Font = w.Fonts.Regular,
TextSize = w.Tokens:Get("FontSmall"),
Parent = frame,
})
Create.New("UICorner", { CornerRadius = UDim.new(0, w.Tokens:Get("CornerSm")), Parent = box })
w:_bind(box, { BackgroundColor3 = "ControlInset", TextColor3 = "Text" })
self:_fieldStroke(box)
boxes[i] = box
end
local function commitBoxes()
local r = math.clamp(tonumber(boxes[1].Text) or 0, 0, 255)
local g = math.clamp(tonumber(boxes[2].Text) or 0, 0, 255)
local b = math.clamp(tonumber(boxes[3].Text) or 0, 0, 255)
self:_setColour(Color3.fromRGB(r, g, b))
end
for _, box in boxes do
box.FocusLost:Connect(commitBoxes)
end
self._hexBox.FocusLost:Connect(function()
local raw = string.gsub(self._hexBox.Text, "#", "")
local ok, new = pcall(Color3.fromHex, raw)
if ok then
self:_setColour(new)
else
self:_syncPopup(self:_colour(self:GetValue()))
end
end)
local nextY = fieldsY + 36
if self.Alpha then
local alphaLabel = Create.New("TextLabel", {
Size = UDim2.new(0.55, 0, 0, 28),
Position = UDim2.fromOffset(8, nextY),
BackgroundTransparency = 1,
Text = "Alpha",
Font = w.Fonts.Regular,
TextSize = w.Tokens:Get("FontSmall"),
TextXAlignment = Enum.TextXAlignment.Left,
Parent = frame,
})
w:_bind(alphaLabel, { TextColor3 = "TextSecondary" })
self._alphaBox = Create.New("TextBox", {
Size = UDim2.new(0.35, -8, 0, 28),
Position = UDim2.new(0.65, 0, 0, nextY),
BackgroundTransparency = 0,
BorderSizePixel = 0,
ClearTextOnFocus = false,
Text = tostring(math.round(self:GetAlpha() * 100)) .. "%",
Font = w.Fonts.Regular,
TextSize = w.Tokens:Get("FontSmall"),
Parent = frame,
})
Create.New("UICorner", { CornerRadius = UDim.new(0, w.Tokens:Get("CornerSm")), Parent = self._alphaBox })
w:_bind(self._alphaBox, { BackgroundColor3 = "ControlInset", TextColor3 = "Text" })
self:_fieldStroke(self._alphaBox)
self._alphaBox.FocusLost:Connect(function()
local n = tonumber(string.gsub(self._alphaBox.Text, "%%", ""))
if n then
self:SetAlpha(math.clamp(n / 100, 0, 1))
else
self:_syncPopup(self:_colour(self:GetValue()))
end
end)
nextY += 34
end
if #self.Presets > 0 then
local row = Create.New("Frame", {
Size = UDim2.new(1, -16, 0, 24),
Position = UDim2.fromOffset(8, nextY),
BackgroundTransparency = 1,
Parent = frame,
})
Create.List(6, Enum.FillDirection.Horizontal).Parent = row
for _, p in self.Presets do
if typeof(p) == "Color3" then
local b = Create.New("TextButton", {
Size = UDim2.fromOffset(24, 24),
BackgroundColor3 = p,
Text = "",
BorderSizePixel = 0,
Parent = row,
})
Create.New("UICorner", { CornerRadius = UDim.new(0, 6), Parent = b })
Create.New("UIStroke", { Thickness = 1, Color = Color3.new(1, 1, 1), Transparency = 0.78, Parent = b })
b.MouseButton1Click:Connect(function()
self:_setColour(p)
end)
end
end
end
self:_syncPopup(c)
end
function ColorPicker:_clearPopupRefs()
self._sv = nil
self._hue = nil
self._svCursor = nil
self._hueCursor = nil
self._hexBox = nil
self._rgbBoxes = nil
self._alphaBox = nil
end
function ColorPicker:_setColour(c)
if self.Alpha then
local v = table.clone(self:GetValue() or {})
v.Color = c
v.Alpha = v.Alpha or 1
self:SetValue(v)
else
self:SetValue(c)
end
end
function ColorPicker:_popupHeight()
local base = 178
if self.Alpha then
base += 34
end
if #self.Presets > 0 then
base += 32
end
if self._window.Device.Layout == "Drawer" then
base += 12
end
return base
end
function ColorPicker:Open()
if self._window.Sound then
self._window.Sound:Play("Open")
end
if self._popup then
return self
end
local height = self:_popupHeight()
local h
local function dismissed()
self._popup = nil
self:_clearPopupRefs()
self._window.Input:CancelCapture(self)
end
if self._window.Device.Layout == "Drawer" then
h = Sheet.open(self._window, height, { OnDismiss = dismissed })
else
h = Popover.open(self._window, self._button, Vector2.new(248, height), { OnDismiss = dismissed, Corner = 8 })
end
self._popup = h
self:_buildPopup(h.Frame)
return self
end
function ColorPicker:Close()
if self._popup then
local h = self._popup
self._popup = nil
self._window.Input:CancelCapture(self)
self:_clearPopupRefs()
h:Dismiss()
end
return self
end
function ColorPicker:SetAlpha(a)
if not self.Alpha then
return self
end
local v = table.clone(self:GetValue() or {})
v.Alpha = math.clamp(tonumber(a) or 1, 0, 1)
return self:SetValue(v)
end
function ColorPicker:GetAlpha()
local v = self:GetValue()
return self.Alpha and type(v) == "table" and tonumber(v.Alpha) or 1
end
function ColorPicker:Destroy()
self:Close()
Base.Destroy(self)
end
function ColorPicker:_applyValueTokens()
if self._button then
self._button.Size = UDim2.new(1, 0, 0, self._window.Tokens:Get("FieldHeight"))
self._hexLabel.TextSize = self._window.Tokens:Get("FontSmall")
end
end
return ColorPicker
end

__modules["controls/Divider"] = function()
local Create = __require("runtime/Create")
local Base = __require("controls/Base")
local Divider = setmetatable({}, { __index = Base })
Divider.__index = Divider
function Divider.new(section, options)
options = options or {}
if options.Title == nil and options.Text ~= nil then
options = table.clone(options)
options.Title = options.Text
end
local self = setmetatable({}, Divider)
local margin = math.max(0, tonumber(options.Margin) or 0)
self.MarginTop = math.max(0, tonumber(options.MarginTop) or margin)
self.MarginBottom = math.max(0, tonumber(options.MarginBottom) or margin)
Base.init(self, section, "Divider", options, { Stateful = false, Persist = false })
self._window.Registry:Update(self, { Title = self:_resolve(self.Title or "Divider") })
return Base.finish(self)
end
function Divider:_mount()
if self._mounted or self._destroyed then
return
end
self._mounted = true
local w = self._window
self._root = Create.New("Frame", {
Size = UDim2.new(1, 0, 0, 20 + self.MarginTop + self.MarginBottom),
BackgroundTransparency = 1,
LayoutOrder = self._order,
Parent = self._section._content,
})
self._janitor:Add(self._root)
self._line = Create.New("Frame", {
Size = UDim2.new(1, 0, 0, 1),
Position = UDim2.fromOffset(0, self.MarginTop + 10),
BorderSizePixel = 0,
Parent = self._root,
})
w:_bind(self._line, { BackgroundColor3 = "BorderSubtle" })
if self.Title and self.Title ~= "" then
self._titleLabel = Create.New("TextLabel", {
AutomaticSize = Enum.AutomaticSize.X,
Size = UDim2.new(0, 0, 0, 20),
Position = UDim2.new(0.5, 0, 0, self.MarginTop + 10),
AnchorPoint = Vector2.new(0.5, 0.5),
BackgroundTransparency = 0,
Font = w.Fonts.Regular,
TextSize = w.Tokens:Get("FontSmall"),
Text = "  " .. self:_resolve(self.Title) .. "  ",
Parent = self._root,
})
w:_bind(self._titleLabel, { BackgroundColor3 = "Surface", TextColor3 = "TextTertiary" })
end
if w.Interactions and (self._tooltip or self._contextMenu or self.Id) then
self._janitor:Add(w.Interactions:Attach(self, self._root, self._tooltip, self._contextMenu))
end
self:_applyVisible()
self:_applyDisabled()
end
function Divider:SetTitle(t)
self.Title = t
if self._titleLabel then
self._titleLabel.Text = "  " .. self:_resolve(t or "") .. "  "
end
self._window.Registry:Update(self, { Title = self:_resolve(t or "Divider") })
return self
end
function Divider:_applyTokens()
if self._titleLabel then
self._titleLabel.TextSize = self._window.Tokens:Get("FontSmall")
end
end
function Divider:SetMargins(top, bottom)
if type(top) ~= "number" or (bottom ~= nil and type(bottom) ~= "number") then
error("[BobloUI] Divider:SetMargins expects one or two numbers.", 2)
end
self.MarginTop = math.max(0, top)
self.MarginBottom = math.max(0, if bottom == nil then top else bottom)
if self._root then
self._root.Size = UDim2.new(1, 0, 0, 20 + self.MarginTop + self.MarginBottom)
self._line.Position = UDim2.fromOffset(0, self.MarginTop + 10)
if self._titleLabel then
self._titleLabel.Position = UDim2.new(0.5, 0, 0, self.MarginTop + 10)
end
end
return self
end
function Divider:_refreshText()
if self._titleLabel then
self._titleLabel.Text = "  " .. self:_resolve(self.Title or "") .. "  "
end
self._window.Registry:Update(self, {
Title = self:_resolve(self.Title or "Divider"),
Path = `{self:_resolve(self._section._tab.Title)} -> {self:_resolve(self._section.Title or "Default")}`,
})
end
return Divider
end

__modules["controls/Dropdown"] = function()
local Create = __require("runtime/Create")
local Base = __require("controls/Base")
local Popover = __require("primitives/Popover")
local Sheet = __require("primitives/Sheet")
local Scroller = __require("primitives/Scroller")
local Icon = __require("primitives/Icon")
local Dropdown = setmetatable({}, { __index = Base })
Dropdown.__index = Dropdown
local ROW_HEIGHT = 32
local RICH_ROW_HEIGHT = 48
local ROW_GAP = 2
local MAX_VISIBLE_ROWS = 7
local function normalizeOption(option, forcedValue)
if type(option) == "table" then
local value = if forcedValue ~= nil then forcedValue else option.Value
if value ~= nil then
return {
Value = value,
Label = tostring(option.Title or option.Label or option.Text or value),
Description = option.Description or option.Desc,
Icon = option.Icon,
Image = option.Image,
Locked = option.Locked == true,
LockedReason = option.LockedReason,
Callback = option.Callback,
}
end
end
local value = if forcedValue ~= nil then forcedValue else option
return { Value = value, Label = tostring(option) }
end
local function normalize(options)
local out = {}
if type(options) ~= "table" then
return out
end
if #options > 0 then
for _, option in options do
table.insert(out, normalizeOption(option))
end
return out
end
local keys = {}
for key in options do
table.insert(keys, key)
end
table.sort(keys, function(a, b)
return tostring(a) < tostring(b)
end)
for _, key in keys do
table.insert(out, normalizeOption(options[key], key))
end
return out
end
local function contains(list, value)
for _, v in list do
if v == value then
return true
end
end
return false
end
local function isDictionary(value)
return type(value) == "table" and #value == 0 and next(value) ~= nil
end
local function findOption(options, value)
for _, o in options do
if o.Value == value then
return o
end
end
end
local function rowHeight(o)
return o and (o.Description or o.Icon or o.Image or o.Locked) and RICH_ROW_HEIGHT or ROW_HEIGHT
end
function Dropdown.new(section, options)
local self = setmetatable({}, Dropdown)
local initialOptions = options.Options or options.Values or {}
self._options = normalize(initialOptions)
self.Multi = options.Multi == true
self.MultiValueMode = options.MultiValueMode
or if options.Map == true
or options.ReturnMap == true
or (self.Multi and isDictionary(options.Values))
then "Map"
else "Array"
if self.MultiValueMode ~= "Array" and self.MultiValueMode ~= "Map" then
error('[BobloUI] Dropdown MultiValueMode must be "Array" or "Map".', 3)
end
self.Style = options.Style or "Dropdown"
if self.Style == "Segmented" and self.Multi then
error("[BobloUI] segmented Dropdown does not support Multi=true.", 3)
end
self.Source = options.Source
self.Searchable = if options.Searchable == nil then #self._options > 8 or self.Source ~= nil else options.Searchable
self.AllowNone = options.AllowNone == true or options.AllowNull == true
self.Max = options.Max
self.MaxVisibleRows =
math.max(1, math.floor(tonumber(options.MaxVisibleRows or options.MaxVisibleDropdownItems) or MAX_VISIBLE_ROWS))
self.DragSelect = options.DragSelect == true
self.FormatDisplayValue = options.FormatDisplayValue or options.FormatValue
self.FormatListValue = options.FormatListValue or options.FormatOption
self.DisabledValues = options.DisabledValues or {}
self.ValueImages = options.ValueImages or options.Images or {}
self.Placeholder = options.Placeholder or "Select..."
self:_applyOptionMetadata()
self._popup = nil
local default = options.Default
if self.Multi and default == nil then
default = {}
elseif self.Multi and self.MultiValueMode == "Map" and type(default) == "table" and #default > 0 then
local mapped = {}
for _, value in default do
mapped[value] = true
end
default = mapped
end
Base.init(self, section, "Dropdown", options, { Stateful = true, Default = default, Adaptive = true })
self:_bindSource()
return Base.finish(self)
end
function Dropdown:_isSelected(selected, value)
if type(selected) ~= "table" then
return false
end
if self.MultiValueMode == "Map" then
return selected[value] == true
end
return contains(selected, value)
end
function Dropdown:_selectedList(selected)
if type(selected) ~= "table" then
return {}
end
if self.MultiValueMode == "Array" then
return table.clone(selected)
end
local out = {}
for _, option in self._options do
if selected[option.Value] == true then
table.insert(out, option.Value)
end
end
return out
end
function Dropdown:_selectionCount(selected)
return #self:_selectedList(selected)
end
function Dropdown:SetValue(value, silent)
if self.Multi and type(value) == "table" then
if self.MultiValueMode == "Map" and #value > 0 then
local mapped = {}
for _, selected in value do
mapped[selected] = true
end
value = mapped
elseif self.MultiValueMode == "Array" and isDictionary(value) then
local ordered = {}
for _, option in self._options do
if value[option.Value] == true then
table.insert(ordered, option.Value)
end
end
value = ordered
end
end
return Base.SetValue(self, value, silent)
end
function Dropdown:_applyOptionMetadata()
for _, option in self._options do
if contains(self.DisabledValues, option.Value) then
option.Locked = true
end
if self.ValueImages[option.Value] ~= nil then
option.Image = self.ValueImages[option.Value]
end
end
end
function Dropdown:_bindSource()
if self.Source == nil then
return
end
local source = self.Source
local signals = {}
if type(source) == "table" then
signals = source.Signals or source.RefreshOn or {}
end
for _, signal in signals do
if typeof(signal) == "RBXScriptSignal" then
self._janitor:Add(signal:Connect(function()
task.defer(function()
if not self._destroyed then
self:RefreshSource()
end
end)
end))
end
end
task.defer(function()
if not self._destroyed then
self:RefreshSource(true)
end
end)
end
function Dropdown:_sourceValues()
local source = self.Source
if type(source) == "function" then
local ok, result = pcall(source)
if ok then
return result
else
warn(`[BobloUI] Dropdown source failed: {result}`)
return {}
end
end
if type(source) == "table" then
local getter = source.Get or source.Fetch
if type(getter) == "function" then
local ok, result = pcall(getter, source)
if not ok then
ok, result = pcall(getter)
end
if ok then
return result
else
warn(`[BobloUI] Dropdown source failed: {result}`)
end
end
end
return {}
end
function Dropdown:RefreshSource(silent)
if self.Source == nil then
return self
end
local values = self:_sourceValues()
if type(values) ~= "table" then
values = {}
end
self:SetOptions(values, silent == true)
return self
end
function Dropdown:_mountValue(host)
if self.Style == "Segmented" then
return self:_mountSegmented(host)
end
local w = self._window
local t = w.Tokens
self._button = Create.New("TextButton", {
Size = UDim2.new(1, 0, 0, t:Get("FieldHeight")),
Position = UDim2.new(0, 0, 0.5, 0),
AnchorPoint = Vector2.new(0, 0.5),
BorderSizePixel = 0,
AutoButtonColor = false,
Text = "",
Parent = host,
})
Create.New("UICorner", { CornerRadius = UDim.new(0, t:Get("FieldRadius")), Parent = self._button })
self._stroke = Create.New("UIStroke", { Thickness = 1, Transparency = 0.45, Parent = self._button })
w:_bind(self._stroke, { Color = "BorderSubtle" })
w:_bind(self._button, { BackgroundColor3 = "ControlInset" })
self._valueLabel = Create.New("TextLabel", {
Size = UDim2.new(1, -32, 1, 0),
Position = UDim2.fromOffset(10, 0),
BackgroundTransparency = 1,
Font = w.Fonts.Regular,
TextSize = t:Get("FontBody"),
TextXAlignment = Enum.TextXAlignment.Left,
TextTruncate = Enum.TextTruncate.AtEnd,
Text = "",
Parent = self._button,
})
w:_bind(self._valueLabel, { TextColor3 = "Text" })
self._arrow = Icon.new(w, "chevron_down", {
Size = UDim2.fromOffset(15, 15),
Position = UDim2.new(1, -9, 0.5, 0),
AnchorPoint = Vector2.new(1, 0.5),
Parent = self._button,
})
self._janitor:Add(self._button.MouseEnter:Connect(function()
if not self._popup then
self._button.BackgroundColor3 = w.Theme:Get("ControlHover")
end
end))
self._janitor:Add(self._button.MouseLeave:Connect(function()
if not self._popup then
self._button.BackgroundColor3 = w.Theme:Get("ControlInset")
end
end))
self._janitor:Add(self._button.MouseButton1Click:Connect(function()
if not self:IsDisabled() then
if self._popup then
self:Close()
else
self:Open()
end
end
end))
end
function Dropdown:_mountSegmented(host)
local w = self._window
local t = w.Tokens
self._segmentHost = Create.New("Frame", {
Size = UDim2.new(1, 0, 0, t:Get("FieldHeight")),
Position = UDim2.new(0, 0, 0.5, 0),
AnchorPoint = Vector2.new(0, 0.5),
BackgroundTransparency = 0,
BorderSizePixel = 0,
Parent = host,
})
Create.New("UICorner", { CornerRadius = UDim.new(0, t:Get("FieldRadius")), Parent = self._segmentHost })
local stroke = Create.New("UIStroke", { Thickness = 1, Transparency = 0.45, Parent = self._segmentHost })
w:_bind(stroke, { Color = "BorderSubtle" })
w:_bind(self._segmentHost, { BackgroundColor3 = "ControlInset" })
Create.List(2, Enum.FillDirection.Horizontal).Parent = self._segmentHost
self._segments = {}
for _, o in self._options do
local b = Create.New("TextButton", {
Size = UDim2.new(1 / math.max(1, #self._options), -2, 1, -4),
BackgroundTransparency = 1,
BorderSizePixel = 0,
AutoButtonColor = false,
Text = o.Label,
Font = w.Fonts.Medium,
TextSize = t:Get("FontSmall"),
Parent = self._segmentHost,
})
Create.New("UICorner", { CornerRadius = UDim.new(0, math.max(4, t:Get("FieldRadius") - 2)), Parent = b })
w:_bind(b, { BackgroundColor3 = "AccentSoft", TextColor3 = "TextSecondary" })
self._segments[o.Value] = b
self._janitor:Add(b.MouseButton1Click:Connect(function()
if not self:IsDisabled() and not o.Locked then
self:SetValue(o.Value)
if o.Callback then
pcall(o.Callback, o.Value)
end
end
end))
end
end
function Dropdown:_renderSegments(v)
if not self._segments then
return
end
local w = self._window
for value, b in self._segments do
local on = value == v
b.BackgroundTransparency = if on then 0 else 1
b.TextColor3 = w.Theme:Get(if on then "Text" else "TextSecondary")
end
end
function Dropdown:_labelFor(value)
local o = findOption(self._options, value)
local label = o and o.Label or tostring(value)
if self.FormatDisplayValue then
local ok, formatted = pcall(self.FormatDisplayValue, value, label, o)
if ok and formatted ~= nil then
return tostring(formatted)
end
end
return label
end
function Dropdown:_listLabel(option)
if self.FormatListValue then
local ok, formatted = pcall(self.FormatListValue, option.Value, option.Label, option)
if ok and formatted ~= nil then
return tostring(formatted)
end
end
return option.Label
end
function Dropdown:_display(value)
if self.Multi then
local selected = self:_selectedList(value)
if #selected == 0 then
return self.Placeholder
end
local labels = {}
for _, v in selected do
table.insert(labels, self:_labelFor(v))
end
if #labels > 3 then
return `{#labels} selected`
end
return table.concat(labels, ", ")
end
if value == nil then
return self.Placeholder
end
return self:_labelFor(value)
end
function Dropdown:_render(v)
if self.Style == "Segmented" then
self:_renderSegments(v)
return
end
if self._valueLabel then
local empty = v == nil or (self.Multi and self:_selectionCount(v) == 0)
self._valueLabel.Text = self:_display(v)
self._valueLabel.TextColor3 = self._window.Theme:Get(empty and "TextTertiary" or "Text")
end
end
function Dropdown:_select(option)
local o = type(option) == "table" and option or findOption(self._options, option)
if not o then
return
end
if o.Locked then
if self._window.Notify then
self._window.Notify:Push({
Title = o.Label,
Content = o.LockedReason or "This option is locked",
Variant = "Warning",
Duration = 3,
})
end
return
end
local value = o.Value
if self._window.Sound then
self._window.Sound:Play("Select")
end
if self.Multi then
local current = table.clone(self:GetValue() or {})
local enabled
if self:_isSelected(current, value) then
if self.MultiValueMode == "Map" then
current[value] = nil
else
table.remove(current, table.find(current, value))
end
enabled = false
else
if self.Max and self:_selectionCount(current) >= self.Max then
return
end
if self.MultiValueMode == "Map" then
current[value] = true
else
table.insert(current, value)
end
enabled = true
end
self:SetValue(current)
if o.Callback then
pcall(o.Callback, value, enabled)
end
self:_rebuildPopup()
else
self:SetValue(value)
if o.Callback then
pcall(o.Callback, value, true)
end
self:Close()
end
end
function Dropdown:_matches(o, query)
if query == "" then
return true
end
local hay = string.lower(o.Label .. " " .. tostring(o.Description or ""))
return string.find(hay, query, 1, true) ~= nil
end
function Dropdown:_filteredOptions()
local query = (self._search and string.lower(self._search.Text)) or ""
local out = {}
for _, o in self._options do
if self:_matches(o, query) then
table.insert(out, o)
end
end
return out
end
function Dropdown:_popupMetrics(filtered)
filtered = filtered or self:_filteredOptions()
local drawer = self._window.Device.Layout == "Drawer"
local top = if drawer then 20 else 8
local searchBlock = if self.Searchable then 42 else 0
local listTop = top + searchBlock
local listHeight = 0
for i = 1, math.max(1, math.min(self.MaxVisibleRows, #filtered)) do
listHeight += rowHeight(filtered[i]) + ((i > 1) and ROW_GAP or 0)
end
local height = listTop + listHeight + 8
local triggerWidth = self._button and self._button.AbsoluteSize.X or 180
local minWidth = if self.Searchable then 240 else 176
local rich = false
for _, o in filtered do
if o.Description or o.Icon or o.Image then
rich = true
break
end
end
local width = math.min(math.max(triggerWidth, minWidth, rich and 280 or 0), 360)
return Vector2.new(width, height), listTop
end
function Dropdown:_resizePopup(filtered)
if not self._popup then
return
end
local size = self:_popupMetrics(filtered)
if self._window.Device.Layout == "Drawer" then
if self._popup.SetHeight then
self._popup:SetHeight(math.min(440, size.Y))
end
elseif self._popup.SetSize then
self._popup:SetSize(size)
end
end
function Dropdown:_buildPopup(frame)
local w = self._window
local t = w.Tokens
frame.ClipsDescendants = true
local filtered = self:_filteredOptions()
local size, listTop = self:_popupMetrics(filtered)
local top = if w.Device.Layout == "Drawer" then 20 else 8
if self.Searchable then
local field = Create.New("Frame", {
Size = UDim2.new(1, -16, 0, 34),
Position = UDim2.fromOffset(8, top),
BackgroundTransparency = 0,
BorderSizePixel = 0,
Parent = frame,
})
Create.New("UICorner", { CornerRadius = UDim.new(0, t:Get("FieldRadius")), Parent = field })
local s = Create.New("UIStroke", { Thickness = 1, Transparency = 0.46, Parent = field })
w:_bind(s, { Color = "BorderSubtle" })
w:_bind(field, { BackgroundColor3 = "ControlInset" })
local icon = Icon.new(
w,
"search",
{ Size = UDim2.fromOffset(14, 14), Position = UDim2.fromOffset(10, 10), Parent = field }
)
Icon.setColor(icon, w.Theme:Get("TextTertiary"))
self._search = Create.New("TextBox", {
Size = UDim2.new(1, -34, 1, 0),
Position = UDim2.fromOffset(30, 0),
BackgroundTransparency = 1,
BorderSizePixel = 0,
ClearTextOnFocus = false,
PlaceholderText = "Search...",
Text = "",
Font = w.Fonts.Regular,
TextSize = t:Get("FontBody"),
TextXAlignment = Enum.TextXAlignment.Left,
Parent = field,
})
w:_bind(self._search, { TextColor3 = "Text", PlaceholderColor3 = "TextTertiary" })
self._popupSearchConn = self._search:GetPropertyChangedSignal("Text"):Connect(function()
self:_rebuildPopup()
end)
end
self._list = Scroller.new(
w,
{ Size = UDim2.new(1, -12, 1, -listTop - 6), Position = UDim2.fromOffset(6, listTop), Parent = frame }
)
Create.New("UIPadding", { PaddingLeft = UDim.new(0, 2), PaddingRight = UDim.new(0, 2), Parent = self._list })
Create.List(ROW_GAP).Parent = self._list
self:_rebuildPopup()
end
function Dropdown:_rebuildPopup()
if not self._list then
return
end
for _, child in self._list:GetChildren() do
if child:IsA("GuiObject") then
child:Destroy()
end
end
local filtered = self:_filteredOptions()
local selected = self:GetValue()
local w = self._window
for _, o in filtered do
local isSelected = if self.Multi then self:_isSelected(selected, o.Value) else selected == o.Value
local h = rowHeight(o)
local b = Create.New("TextButton", {
Size = UDim2.new(1, 0, 0, h),
BackgroundTransparency = if isSelected then 0 else 1,
BorderSizePixel = 0,
AutoButtonColor = false,
Text = "",
Parent = self._list,
})
Create.New("UICorner", { CornerRadius = UDim.new(0, 7), Parent = b })
w:_bind(b, { BackgroundColor3 = "AccentSoft" })
local left = 8
if o.Image then
local image = Create.New("ImageLabel", {
Size = UDim2.fromOffset(18, 18),
Position = UDim2.fromOffset(8, math.floor(h / 2)),
AnchorPoint = Vector2.new(0, 0.5),
BackgroundTransparency = 1,
Image = tostring(o.Image),
Parent = b,
})
image.ImageTransparency = if o.Locked then 0.55 else 0
left = 34
elseif o.Icon then
local ic = Icon.new(w, o.Icon, {
Size = UDim2.fromOffset(15, 15),
Position = UDim2.fromOffset(9, math.floor(h / 2)),
AnchorPoint = Vector2.new(0, 0.5),
Parent = b,
})
Icon.setColor(ic, w.Theme:Get(o.Locked and "TextDisabled" or (isSelected and "Accent" or "TextSecondary")))
left = 32
end
local right = if isSelected or o.Locked then 24 else 8
local label = Create.New("TextLabel", {
Size = UDim2.new(1, -left - right, 0, if o.Description then 20 else h),
Position = UDim2.fromOffset(left, if o.Description then 5 else 0),
BackgroundTransparency = 1,
Font = w.Fonts.Regular,
TextSize = w.Tokens:Get("FontBody"),
TextXAlignment = Enum.TextXAlignment.Left,
TextTruncate = Enum.TextTruncate.AtEnd,
Text = self:_listLabel(o),
Parent = b,
})
w:_bind(
label,
{ TextColor3 = if o.Locked then "TextDisabled" elseif isSelected then "Text" else "TextSecondary" }
)
if o.Description then
local desc = Create.New("TextLabel", {
Size = UDim2.new(1, -left - right, 0, 17),
Position = UDim2.fromOffset(left, 24),
BackgroundTransparency = 1,
Font = w.Fonts.Regular,
TextSize = w.Tokens:Get("FontSmall"),
TextXAlignment = Enum.TextXAlignment.Left,
TextTruncate = Enum.TextTruncate.AtEnd,
Text = tostring(o.Description),
Parent = b,
})
w:_bind(desc, { TextColor3 = o.Locked and "TextDisabled" or "TextTertiary" })
end
if isSelected then
local check = Icon.new(w, "check", {
Size = UDim2.fromOffset(12, 12),
Position = UDim2.new(1, -8, 0.5, 0),
AnchorPoint = Vector2.new(1, 0.5),
Parent = b,
})
Icon.setColor(check, w.Theme:Get("Accent"))
elseif o.Locked then
local lock = Icon.new(w, "lock", {
Size = UDim2.fromOffset(13, 13),
Position = UDim2.new(1, -8, 0.5, 0),
AnchorPoint = Vector2.new(1, 0.5),
Parent = b,
})
Icon.setColor(lock, w.Theme:Get("TextDisabled"))
end
b.MouseEnter:Connect(function()
if not isSelected then
b.BackgroundTransparency = 0
b.BackgroundColor3 = w.Theme:Get("ControlHover")
end
end)
b.MouseLeave:Connect(function()
b.BackgroundTransparency = if isSelected then 0 else 1
end)
b.MouseEnter:Connect(function()
if self._dragSelecting and self.Multi and not self._dragVisited[o.Value] then
self._dragVisited[o.Value] = true
self:_select(o)
end
end)
b.InputBegan:Connect(function(input)
if
self.DragSelect
and self.Multi
and (
input.UserInputType == Enum.UserInputType.MouseButton1
or input.UserInputType == Enum.UserInputType.Touch
)
then
self._dragSelecting = true
self._dragVisited = { [o.Value] = true }
self._skipClickOption = o
self:_select(o)
end
end)
b.MouseButton1Click:Connect(function()
if self._skipClickOption == o then
self._skipClickOption = nil
return
end
self:_select(o)
end)
end
if #filtered == 0 then
local empty = Create.New("TextLabel", {
Size = UDim2.new(1, 0, 0, ROW_HEIGHT),
BackgroundTransparency = 1,
Font = w.Fonts.Regular,
TextSize = w.Tokens:Get("FontSmall"),
Text = "No matches",
Parent = self._list,
})
w:_bind(empty, { TextColor3 = "TextTertiary" })
end
self:_resizePopup(filtered)
end
function Dropdown:_clearPopupRefs()
if self._popupSearchConn then
self._popupSearchConn:Disconnect()
self._popupSearchConn = nil
end
if self._popupInputEnded then
self._popupInputEnded:Disconnect()
self._popupInputEnded = nil
end
self._dragSelecting = false
self._dragVisited = nil
self._skipClickOption = nil
self._search = nil
self._list = nil
end
function Dropdown:Open()
if self._window.Sound then
self._window.Sound:Play("Open")
end
if self.Style == "Segmented" then
return self
end
if self._popup then
return self
end
local filtered = self:_filteredOptions()
local size = self:_popupMetrics(filtered)
local handle
local function dismissed()
self._popup = nil
self:_clearPopupRefs()
if self._arrow then
self._arrow.Rotation = 0
end
if self._button then
self._button.BackgroundColor3 = self._window.Theme:Get("ControlInset")
end
if self._stroke then
self._stroke.Color = self._window.Theme:Get("BorderSubtle")
end
end
if self._window.Device.Layout == "Drawer" then
handle = Sheet.open(self._window, math.min(440, size.Y), { OnDismiss = dismissed })
else
handle = Popover.open(self._window, self._button, size, { OnDismiss = dismissed, Corner = 8 })
end
self._popup = handle
self._popupInputEnded = self._window.Input.Ended:Connect(function(input)
if
input.UserInputType == Enum.UserInputType.MouseButton1
or input.UserInputType == Enum.UserInputType.Touch
then
self._dragSelecting = false
self._dragVisited = nil
self._skipClickOption = nil
end
end)
self:_buildPopup(handle.Frame)
self._arrow.Rotation = 180
self._button.BackgroundColor3 = self._window.Theme:Get("ControlHover")
self._stroke.Color = self._window.Theme:Get("AccentBorder")
return self
end
function Dropdown:Close()
if self._popup then
local h = self._popup
self._popup = nil
self:_clearPopupRefs()
h:Dismiss()
end
if self._arrow then
self._arrow.Rotation = 0
end
if self._popupInputEnded then
self._popupInputEnded:Disconnect()
self._popupInputEnded = nil
end
return self
end
function Dropdown:SetOptions(list, silent)
self._options = normalize(list or {})
self:_applyOptionMetadata()
local current = self:GetValue()
if self.Multi then
local kept = {}
if self.MultiValueMode == "Map" then
for value, selected in current or {} do
if selected == true and findOption(self._options, value) then
kept[value] = true
end
end
else
for _, value in current or {} do
if findOption(self._options, value) then
table.insert(kept, value)
end
end
end
self:SetValue(kept, true)
else
local exists = findOption(self._options, current) ~= nil
if not exists and current ~= nil then
self:SetValue(if self.AllowNone then nil else (self._options[1] and self._options[1].Value or nil), true)
end
end
if self.Style == "Segmented" and self._segmentHost then
local host = self._valueHost
self._segmentHost:Destroy()
self._segmentHost = nil
self._segments = nil
self:_mountSegmented(host)
else
self:_rebuildPopup()
end
self:_render(self:GetValue())
return self
end
function Dropdown:Refresh(list)
if list ~= nil then
return self:SetOptions(list)
end
if self.Source then
self:RefreshSource()
else
self:_rebuildPopup()
end
return self
end
function Dropdown:AddOption(o)
local n = normalize({ o })[1]
if n then
table.insert(self._options, n)
self:_applyOptionMetadata()
end
self:_rebuildPopup()
return self
end
function Dropdown:SetValues(values, silent)
return self:SetOptions(values, silent)
end
function Dropdown:AddValues(values)
local additions
if type(values) == "table" and values.Value ~= nil then
additions = { normalizeOption(values) }
elseif type(values) == "table" then
additions = normalize(values)
else
additions = { normalizeOption(values) }
end
for _, option in additions do
local existing = findOption(self._options, option.Value)
if existing then
for key, value in option do
existing[key] = value
end
else
table.insert(self._options, option)
end
end
self:_applyOptionMetadata()
self:_rebuildPopup()
self:_render(self:GetValue())
return self
end
function Dropdown:RemoveOption(value)
for i = #self._options, 1, -1 do
if self._options[i].Value == value then
table.remove(self._options, i)
end
end
return self:SetOptions(self._options)
end
function Dropdown:SetDisabledValues(values)
self.DisabledValues = values or {}
for _, option in self._options do
option.Locked = contains(self.DisabledValues, option.Value)
end
self:_rebuildPopup()
return self
end
function Dropdown:AddDisabledValues(values)
local additions = if type(values) == "table" then values else { values }
local merged = table.clone(self.DisabledValues)
for _, value in additions do
if value ~= nil and not contains(merged, value) then
table.insert(merged, value)
end
end
return self:SetDisabledValues(merged)
end
function Dropdown:SetValueDisabled(value, disabled, reason)
local option = findOption(self._options, value)
if not option then
return false
end
option.Locked = disabled == true
option.LockedReason = reason or option.LockedReason
self:_rebuildPopup()
return self
end
function Dropdown:SetValueImage(value, image)
local option = findOption(self._options, value)
if not option then
return false
end
option.Image = image
self.ValueImages[value] = image
self:_rebuildPopup()
return self
end
function Dropdown:SetValueImages(images)
self.ValueImages = table.clone(images or {})
for _, option in self._options do
option.Image = self.ValueImages[option.Value]
end
self:_rebuildPopup()
return self
end
function Dropdown:AddValueImages(images)
for value, image in images or {} do
self.ValueImages[value] = image
local option = findOption(self._options, value)
if option then
option.Image = image
end
end
self:_rebuildPopup()
return self
end
function Dropdown:SetDragSelect(enabled)
self.DragSelect = enabled == true
if not self.DragSelect then
self._dragSelecting = false
self._dragVisited = nil
self._skipClickOption = nil
end
return self
end
function Dropdown:GetActiveValues(countOnly)
local current = self:GetValue()
if self.Multi then
local values = table.clone(type(current) == "table" and current or {})
return if countOnly then self:_selectionCount(values) else values
end
if countOnly then
return if current == nil then 0 else 1
end
return current
end
function Dropdown:SetMaxVisibleRows(count)
self.MaxVisibleRows = math.max(1, math.floor(tonumber(count) or self.MaxVisibleRows))
self:_resizePopup()
return self
end
function Dropdown:SetFormatters(displayFormatter, listFormatter)
self.FormatDisplayValue = displayFormatter
self.FormatListValue = listFormatter
self:_render(self:GetValue())
self:_rebuildPopup()
return self
end
function Dropdown:Destroy()
self:Close()
Base.Destroy(self)
end
function Dropdown:_applyValueTokens()
if self._button then
self._button.Size = UDim2.new(1, 0, 0, self._window.Tokens:Get("FieldHeight"))
self._valueLabel.TextSize = self._window.Tokens:Get("FontBody")
end
if self._segmentHost then
self._segmentHost.Size = UDim2.new(1, 0, 0, self._window.Tokens:Get("FieldHeight"))
for _, b in self._segments or {} do
b.TextSize = self._window.Tokens:Get("FontSmall")
end
end
end
return Dropdown
end

__modules["controls/Image"] = function()
local Create = __require("runtime/Create")
local Base = __require("controls/Base")
local Image = setmetatable({}, { __index = Base })
Image.__index = Image
function Image.new(section, options)
options = options or {}
local self = setmetatable({}, Image)
self.Image = options.Image or ""
self.Height = math.max(64, tonumber(options.Height) or 160)
self.ScaleType = options.ScaleType or Enum.ScaleType.Fit
self.Caption = options.Caption
self.Tint = options.Tint or options.ImageColor3 or Color3.new(1, 1, 1)
self.Transparency = math.clamp(tonumber(options.Transparency or options.ImageTransparency) or 0, 0, 1)
self.BackgroundTransparency = math.clamp(tonumber(options.BackgroundTransparency) or 0, 0, 1)
self.RectOffset = options.RectOffset or options.ImageRectOffset or Vector2.new()
self.RectSize = options.RectSize or options.ImageRectSize or Vector2.new()
Base.init(self, section, "Image", options, { Stateful = false, Default = nil, Layout = "Stacked" })
return Base.finish(self)
end
function Image:_measure()
local t = self._window.Tokens
return t:Get("ControlHeight") + self.Height + (self.Caption and 28 or 10) + (self.Description and 12 or 0)
end
function Image:_mountValue(host)
local w = self._window
local t = w.Tokens
self._image = Create.New("ImageLabel", {
Size = UDim2.new(1, 0, 0, self.Height),
BackgroundTransparency = 0,
BorderSizePixel = 0,
Image = self.Image,
ScaleType = self.ScaleType,
ImageColor3 = self.Tint,
ImageTransparency = self.Transparency,
BackgroundTransparency = self.BackgroundTransparency,
ImageRectOffset = self.RectOffset,
ImageRectSize = self.RectSize,
Parent = host,
})
Create.New("UICorner", { CornerRadius = UDim.new(0, t:Get("FieldRadius")), Parent = self._image })
local s = Create.New("UIStroke", { Thickness = 1, Transparency = 0.58, Parent = self._image })
w:_bind(s, { Color = "BorderSubtle" })
w:_bind(self._image, { BackgroundColor3 = "ControlInset" })
self._caption = Create.New("TextLabel", {
Size = UDim2.new(1, 0, 0, 20),
Position = UDim2.fromOffset(0, self.Height + 6),
BackgroundTransparency = 1,
Text = tostring(self.Caption or ""),
Visible = self.Caption ~= nil,
Font = w.Fonts.Regular,
TextSize = t:Get("FontSmall"),
TextXAlignment = Enum.TextXAlignment.Left,
Parent = host,
})
w:_bind(self._caption, { TextColor3 = "TextTertiary" })
end
function Image:_applyValueTokens()
if self._valueHost then
self._valueHost.Size =
UDim2.new(1, -self._window.Tokens:Get("ControlPadding") * 2, 0, self.Height + (self.Caption and 26 or 0))
end
if self._image then
self._image.Size = UDim2.new(1, 0, 0, self.Height)
end
if self._caption then
self._caption.Position = UDim2.fromOffset(0, self.Height + 6)
end
end
function Image:SetImage(value)
self.Image = value or ""
if self._image then
self._image.Image = self.Image
end
return self
end
function Image:SetCaption(value)
self.Caption = value
if self._caption then
self._caption.Text = tostring(value or "")
self._caption.Visible = value ~= nil
end
if self._mounted then
self:_applyTokens()
end
return self
end
function Image:SetHeight(value)
self.Height = math.max(64, tonumber(value) or self.Height)
if self._mounted then
self:_applyTokens()
end
return self
end
function Image:SetTint(value)
if typeof(value) ~= "Color3" then
error("[BobloUI] Image:SetTint expects Color3.", 2)
end
self.Tint = value
if self._image then
self._image.ImageColor3 = value
end
return self
end
function Image:SetTransparency(value, background)
self.Transparency = math.clamp(tonumber(value) or self.Transparency, 0, 1)
if background ~= nil then
self.BackgroundTransparency = math.clamp(tonumber(background) or self.BackgroundTransparency, 0, 1)
end
if self._image then
self._image.ImageTransparency = self.Transparency
self._image.BackgroundTransparency = self.BackgroundTransparency
end
return self
end
function Image:SetRect(offset, size)
if typeof(offset) ~= "Vector2" or typeof(size) ~= "Vector2" then
error("[BobloUI] Image:SetRect expects Vector2 offset and size.", 2)
end
self.RectOffset = offset
self.RectSize = size
if self._image then
self._image.ImageRectOffset = offset
self._image.ImageRectSize = size
end
return self
end
function Image:SetScaleType(scaleType)
self.ScaleType = scaleType or Enum.ScaleType.Fit
if self._image then
self._image.ScaleType = self.ScaleType
end
return self
end
return Image
end

__modules["controls/Keybind"] = function()
local Create = __require("runtime/Create")
local Base = __require("controls/Base")
local Keybind = setmetatable({}, { __index = Base })
Keybind.__index = Keybind
local MODIFIERS = {
Ctrl = { Enum.KeyCode.LeftControl, Enum.KeyCode.RightControl },
Shift = { Enum.KeyCode.LeftShift, Enum.KeyCode.RightShift },
Alt = { Enum.KeyCode.LeftAlt, Enum.KeyCode.RightAlt },
Meta = { Enum.KeyCode.LeftMeta, Enum.KeyCode.RightMeta },
}
local MODIFIER_ORDER = { "Ctrl", "Shift", "Alt", "Meta" }
local MODIFIER_ALIAS = {
Control = "Ctrl",
LeftControl = "Ctrl",
RightControl = "Ctrl",
LeftShift = "Shift",
RightShift = "Shift",
LeftAlt = "Alt",
RightAlt = "Alt",
LeftMeta = "Meta",
RightMeta = "Meta",
}
local function keyName(key)
if typeof(key) == "EnumItem" then
return key.Name
end
if type(key) == "table" then
return key.Key
end
return tostring(key or "None")
end
local function enumKey(name)
if typeof(name) == "EnumItem" then
return name
end
if type(name) == "string" then
return Enum.KeyCode[name] or Enum.UserInputType[name]
end
return nil
end
local function normalizeModifiers(modifiers)
local present = {}
for _, modifier in modifiers or {} do
local name = if typeof(modifier) == "EnumItem" then modifier.Name else tostring(modifier)
name = MODIFIER_ALIAS[name] or name
if MODIFIERS[name] then
present[name] = true
end
end
local out = {}
for _, name in MODIFIER_ORDER do
if present[name] then
table.insert(out, name)
end
end
return out
end
local function chordText(value)
local parts = {}
for _, modifier in normalizeModifiers(type(value) == "table" and value.Modifiers or {}) do
table.insert(parts, modifier)
end
table.insert(parts, keyName(value))
return table.concat(parts, " + ")
end
local function containsKey(list, key)
for _, candidate in list or {} do
if candidate == key or keyName(candidate) == keyName(key) then
return true
end
end
return false
end
function Keybind.new(section, options)
options = options or {}
local self = setmetatable({}, Keybind)
self.Mode = options.Mode or (type(options.Default) == "table" and options.Default.Mode) or "Toggle"
self._actionCallback = options.Callback or options.Clicked
self.CustomModes = options.CustomModes or options.Modes or {}
self.AllowedModes = table.clone(options.AllowedModes or { "Toggle", "Hold", "Always" })
for mode in self.CustomModes do
if not table.find(self.AllowedModes, mode) then
table.insert(self.AllowedModes, mode)
end
end
if not table.find(self.AllowedModes, self.Mode) then
error(`[BobloUI] keybind mode "{self.Mode}" is not allowed.`, 3)
end
self.Blacklist = options.Blacklist or options.Blacklisted or {}
self.Whitelist = options.Whitelist or options.Whitelisted
self.ModifierBlacklist = options.ModifierBlacklist or options.BlacklistModifiers or options.BlacklistedModifiers
self.ModifierWhitelist = options.ModifierWhitelist or options.WhitelistedModifiers
self.ExactModifiers = options.ExactModifiers == true
self.WaitForCallback = options.WaitForCallback == true
self._callbackBusy = false
self.Mobile = options.Mobile ~= false
self.MobileText = options.MobileText or options.Title
self.NoUI = options.NoUI == true
self._attached = options.AttachTo
local syncToggle = if options.SyncToggle ~= nil then options.SyncToggle else options.SyncToggleState
self.SyncToggle = if syncToggle == nil
then self._attached and self._attached.Type == "Toggle"
else syncToggle == true
self._binding = nil
self._capturing = false
local default = options.Default
local stored
if type(default) == "table" then
stored = {
Key = keyName(default.Key or Enum.KeyCode.E),
Mode = default.Mode or self.Mode,
Modifiers = normalizeModifiers(default.Modifiers or options.Modifiers or options.DefaultModifiers),
}
else
stored = {
Key = keyName(default or Enum.KeyCode.E),
Mode = self.Mode,
Modifiers = normalizeModifiers(options.Modifiers or options.DefaultModifiers),
}
end
local baseOptions = table.clone(options)
baseOptions.Callback = nil
if self.NoUI or (section._window.Device.Class == "Phone" and baseOptions.Visible == nil) then
baseOptions.Visible = false
end
Base.init(self, section, "Keybind", baseOptions, { Stateful = true, Default = stored, Adaptive = true })
local handle = Base.finish(self)
if options.ChangedCallback then
handle:OnChanged(options.ChangedCallback)
end
return handle
end
function Keybind:_mountValue(host)
local w = self._window
local t = w.Tokens
self._button = Create.New("TextButton", {
Size = UDim2.new(1, 0, 0, t:Get("FieldHeight")),
Position = UDim2.new(0, 0, 0.5, 0),
AnchorPoint = Vector2.new(0, 0.5),
BorderSizePixel = 0,
AutoButtonColor = false,
Text = "",
Font = w.Fonts.Medium,
TextSize = t:Get("FontSmall"),
Parent = host,
})
Create.New("UICorner", { CornerRadius = UDim.new(0, t:Get("FieldRadius")), Parent = self._button })
self._stroke = Create.New("UIStroke", {
Thickness = 1,
Transparency = 0.45,
LineJoinMode = Enum.LineJoinMode.Round,
Parent = self._button,
})
w:_bind(self._stroke, { Color = "BorderSubtle" })
w:_bind(self._button, { BackgroundColor3 = "ControlInset", TextColor3 = "TextSecondary" })
self._janitor:Add(self._button.MouseEnter:Connect(function()
self._button.BackgroundColor3 = w.Theme:Get("SurfaceHover")
end))
self._janitor:Add(self._button.MouseLeave:Connect(function()
if not self._capturing then
self._button.BackgroundColor3 = w.Theme:Get("ControlInset")
end
end))
self._janitor:Add(self._button.MouseButton1Click:Connect(function()
if not self:IsDisabled() then
self:Capture()
end
end))
self:_rebind()
end
function Keybind:_render(value)
if type(value) == "table" then
self.Mode = value.Mode or self.Mode
end
if self._button then
self._button.Text = if self._capturing then "Press a key…" else `{chordText(value)}  ·  {self.Mode}`
self._button.BackgroundColor3 = self._window.Theme:Get(self._capturing and "AccentSoft" or "ControlInset")
self._stroke.Color = self._window.Theme:Get(self._capturing and "AccentBorder" or "BorderSubtle")
self:_rebind()
end
end
function Keybind:_dispatch(active)
if self.WaitForCallback and self._callbackBusy then
return
end
local function dispatch()
local attached = self._attached
if attached and not attached._destroyed then
if self.SyncToggle and attached.SetValue then
attached:SetValue(active)
elseif active and attached.Click then
attached:Click()
end
end
if self._actionCallback then
self._actionCallback(active, self)
end
end
if self.WaitForCallback then
self._callbackBusy = true
end
local ok, err = xpcall(dispatch, debug.traceback)
self._callbackBusy = false
if not ok then
warn(err)
end
end
function Keybind:_rebind()
if self._binding then
self._janitor:Release("keybinding")
self._binding:Destroy()
self._binding = nil
end
local value = self:GetValue()
if not self._mounted or type(value) ~= "table" then
return
end
local key = enumKey(value.Key)
local modifiers = normalizeModifiers(value.Modifiers)
if not key or not self:_keyAllowed(key) or not self:_modifiersAllowed(modifiers) then
return
end
self._binding = self._window.Input:BindKey(self.Id or tostring(self), key, value.Mode or self.Mode, function(active)
self:_dispatch(active)
end, {
Modifiers = modifiers,
ExactModifiers = self.ExactModifiers,
ModeHandler = self.CustomModes[value.Mode or self.Mode],
})
self._janitor:Add(self._binding, "Destroy", "keybinding")
end
function Keybind:_capturedModifiers(primary)
local out = {}
for _, name in MODIFIER_ORDER do
for _, key in MODIFIERS[name] do
if key ~= primary and self._window.Input:IsKeyDown(key) then
table.insert(out, name)
break
end
end
end
return out
end
function Keybind:_keyAllowed(key)
if self.Whitelist and not containsKey(self.Whitelist, key) then
return false
end
return not containsKey(self.Blacklist, key)
end
function Keybind:_modifiersAllowed(modifiers)
local normalized = normalizeModifiers(modifiers)
local allowed = if self.ModifierWhitelist ~= nil then normalizeModifiers(self.ModifierWhitelist) else nil
local denied = normalizeModifiers(self.ModifierBlacklist)
for _, modifier in normalized do
if allowed and not table.find(allowed, modifier) then
return false
end
if table.find(denied, modifier) then
return false
end
end
return true
end
function Keybind:Capture()
if self._capturing then
return self
end
self._capturing = true
self:_render(self:GetValue())
local arm
arm = function()
local cancel = self._window.Input:CaptureNextKey(function(key)
self._janitor:Release("capture")
if self._destroyed then
return
end
if key == Enum.KeyCode.Escape then
self._capturing = false
self:_render(self:GetValue())
return
end
if MODIFIER_ALIAS[key.Name] then
arm()
return
end
if not self:_keyAllowed(key) then
arm()
return
end
local modifiers = self:_capturedModifiers(key)
if not self:_modifiersAllowed(modifiers) then
arm()
return
end
self._capturing = false
local value = table.clone(self:GetValue() or {})
value.Key = key.Name
value.Mode = self.Mode
value.Modifiers = modifiers
self:SetValue(value)
end, function()
if self._destroyed then
return
end
self._capturing = false
self:_render(self:GetValue())
end)
self._janitor:Add(cancel, nil, "capture")
end
arm()
return self
end
function Keybind:Cancel()
if self._capturing then
self._janitor:Remove("capture")
self._capturing = false
self:_render(self:GetValue())
end
return self
end
function Keybind:SetMode(mode)
if not table.find(self.AllowedModes, mode) then
error(`[BobloUI] keybind mode "{mode}" is not allowed.`, 2)
end
self.Mode = mode
local value = table.clone(self:GetValue() or {})
value.Mode = mode
return self:SetValue(value)
end
function Keybind:SetKey(key, modifiers)
local resolved = enumKey(key)
if not resolved or not self:_keyAllowed(resolved) then
return false
end
local value = table.clone(self:GetValue() or {})
value.Key = resolved.Name
if modifiers ~= nil then
local normalized = normalizeModifiers(modifiers)
if not self:_modifiersAllowed(normalized) then
return false
end
value.Modifiers = normalized
end
self:SetValue(value)
return self
end
function Keybind:SetModifiers(modifiers)
local normalized = normalizeModifiers(modifiers)
if not self:_modifiersAllowed(normalized) then
return false
end
local value = table.clone(self:GetValue() or {})
value.Modifiers = normalized
return self:SetValue(value)
end
function Keybind:GetModifiers()
return normalizeModifiers((self:GetValue() or {}).Modifiers)
end
function Keybind:Attach(control, syncToggle)
self._attached = control
self.SyncToggle = if syncToggle == nil then control and control.Type == "Toggle" else syncToggle == true
return self
end
function Keybind:Trigger()
if self._binding and not self:IsDisabled() then
self._binding:Trigger()
end
return self
end
function Keybind:IsActive()
return self._binding and self._binding.Active or false
end
function Keybind:Focus()
return self:Capture()
end
function Keybind:_applyValueTokens()
if self._button then
self._button.Size = UDim2.new(1, 0, 0, self._window.Tokens:Get("FieldHeight"))
self._button.TextSize = self._window.Tokens:Get("FontSmall")
end
end
return Keybind
end

__modules["controls/Paragraph"] = function()
local Create = __require("runtime/Create")
local Base = __require("controls/Base")
local Paragraph = setmetatable({}, { __index = Base })
Paragraph.__index = Paragraph
function Paragraph.new(section, options)
options = options or {}
local self = setmetatable({}, Paragraph)
self.Content = options.Content or ""
self.Variant = options.Variant or "Default"
self.RichText = options.RichText == true
self.DoesWrap = if options.DoesWrap ~= nil then options.DoesWrap ~= false else options.Wrap ~= false
self.TextSize = tonumber(options.Size)
Base.init(self, section, "Paragraph", options, { Stateful = false, Persist = false })
self._window.Registry:Update(self, {
Title = self:_resolve((self.Title and self.Title ~= "") and self.Title or self.Content),
Description = self:_resolve(self.Content),
})
return Base.finish(self)
end
function Paragraph:_mount()
if self._mounted or self._destroyed then
return
end
self._mounted = true
local w = self._window
self._root = Create.New("Frame", {
Size = UDim2.new(1, 0, 0, 0),
AutomaticSize = Enum.AutomaticSize.Y,
BackgroundTransparency = if self.Variant == "Default" then 1 else 0,
BorderSizePixel = 0,
LayoutOrder = self._order,
Parent = self._section._content,
})
self._janitor:Add(self._root)
if self.Variant ~= "Default" then
Create.New("UICorner", { CornerRadius = UDim.new(0, w.Tokens:Get("ControlRadius")), Parent = self._root })
local token = if self.Variant == "Info"
then "AccentSoft"
elseif self.Variant == "Warning" then "SurfaceHover"
elseif self.Variant == "Danger" then "SurfaceHover"
else "Control"
w:_bind(self._root, { BackgroundColor3 = token })
local stripe = Create.New("Frame", {
Size = UDim2.fromOffset(3, 18),
Position = UDim2.new(0, 0, 0, 10),
BorderSizePixel = 0,
Parent = self._root,
})
Create.New("UICorner", { CornerRadius = UDim.new(1, 0), Parent = stripe })
w:_bind(stripe, {
BackgroundColor3 = if self.Variant == "Info"
then "Info"
elseif self.Variant == "Warning" then "Warning"
else "Error",
})
end
self._padding = Create.New("UIPadding", { Parent = self._root })
self._layout = Create.List(3)
self._layout.Parent = self._root
if self.Title and self.Title ~= "" then
self._titleLabel = Create.New("TextLabel", {
Size = UDim2.new(1, 0, 0, 20),
BackgroundTransparency = 1,
Font = w.Fonts.Medium,
TextSize = w.Tokens:Get("FontBody"),
TextXAlignment = Enum.TextXAlignment.Left,
Text = self:_resolve(self.Title),
RichText = self.RichText,
Parent = self._root,
})
w:_bind(self._titleLabel, { TextColor3 = "Text" })
end
self._content = Create.New("TextLabel", {
Size = UDim2.new(1, 0, 0, 0),
AutomaticSize = Enum.AutomaticSize.Y,
BackgroundTransparency = 1,
Font = w.Fonts.Regular,
TextSize = self.TextSize or w.Tokens:Get("FontSmall"),
TextWrapped = self.DoesWrap,
RichText = self.RichText,
TextXAlignment = Enum.TextXAlignment.Left,
TextYAlignment = Enum.TextYAlignment.Top,
Text = self:_resolve(self.Content),
Parent = self._root,
})
w:_bind(self._content, { TextColor3 = "TextSecondary" })
if w.Interactions and (self._tooltip or self._contextMenu or self.Id) then
self._janitor:Add(w.Interactions:Attach(self, self._root, self._tooltip, self._contextMenu))
end
self:_applyTokens()
self:_applyVisible()
self:_applyDisabled()
end
function Paragraph:_applyTokens()
if not self._root then
return
end
local t = self._window.Tokens
if self._padding then
local p = math.max(6, t:Get("SectionPadding") - 4)
self._padding.PaddingTop = UDim.new(0, p)
self._padding.PaddingBottom = UDim.new(0, p)
self._padding.PaddingLeft = UDim.new(0, p)
self._padding.PaddingRight = UDim.new(0, p)
end
if self._titleLabel then
self._titleLabel.TextSize = t:Get("FontBody")
end
if self._content then
self._content.TextSize = self.TextSize or t:Get("FontSmall")
end
end
function Paragraph:_refreshText()
if self._titleLabel then
self._titleLabel.Text = self:_resolve(self.Title or "")
end
if self._content then
self._content.Text = self:_resolve(self.Content)
end
self._window.Registry:Update(self, {
Title = self:_resolve((self.Title and self.Title ~= "") and self.Title or self.Content),
Description = self:_resolve(self.Content),
Path = `{self:_resolve(self._section._tab.Title)} -> {self:_resolve(self._section.Title or "Default")}`,
})
end
function Paragraph:SetContent(v)
self.Content = v or ""
if self._content then
self._content.Text = self:_resolve(self.Content)
end
local fields = { Description = self:_resolve(self.Content) }
if not self.Title or self.Title == "" then
fields.Title = self:_resolve(self.Content)
end
self._window.Registry:Update(self, fields)
return self
end
function Paragraph:SetRichText(enabled)
self.RichText = enabled == true
if self._titleLabel then
self._titleLabel.RichText = self.RichText
end
if self._content then
self._content.RichText = self.RichText
end
return self
end
function Paragraph:SetWrap(enabled)
self.DoesWrap = enabled ~= false
if self._content then
self._content.TextWrapped = self.DoesWrap
end
return self
end
function Paragraph:SetSize(size)
if size ~= nil and type(size) ~= "number" then
error("[BobloUI] Paragraph:SetSize expects number or nil.", 2)
end
self.TextSize = size
if self._content then
self._content.TextSize = size or self._window.Tokens:Get("FontSmall")
end
return self
end
return Paragraph
end

__modules["controls/Passthrough"] = function()
local Base = __require("controls/Base")
local Passthrough = setmetatable({}, { __index = Base })
Passthrough.__index = Passthrough
function Passthrough.new(section, options)
options = options or {}
if typeof(options.Instance) ~= "Instance" or not options.Instance:IsA("GuiObject") then
error("[BobloUI] AddPassthrough requires Instance = GuiObject.", 3)
end
local self = setmetatable({}, Passthrough)
self.Height = math.max(1, tonumber(options.Height) or options.Instance.Size.Y.Offset or 40)
self.Fill = options.Fill ~= false
self.Clone = options.Clone == true
self.DestroyInstance = options.DestroyInstance ~= false
self._sourceInstance = options.Instance
self._contentInstance = if self.Clone then options.Instance:Clone() else options.Instance
self._originalParent = options.Instance.Parent
Base.init(self, section, "Passthrough", options, { Stateful = false, Persist = false, Layout = "Stacked" })
return Base.finish(self)
end
function Passthrough:_measure()
local t = self._window.Tokens
return t:Get("ControlHeight") + self.Height + (self.Description and 12 or 0) + 10
end
function Passthrough:_mountValue(host)
self._contentInstance.Parent = host
if self.Fill then
self._contentInstance.Size = UDim2.new(1, 0, 0, self.Height)
end
end
function Passthrough:_releaseContent()
local content = self._contentInstance
if not content then
return
end
if self.Clone or self.DestroyInstance then
content:Destroy()
else
content.Parent = self._originalParent
end
self._contentInstance = nil
end
function Passthrough:_applyValueTokens()
if self._valueHost then
self._valueHost.Size = UDim2.new(1, -self._window.Tokens:Get("ControlPadding") * 2, 0, self.Height)
end
if self.Fill and self._contentInstance then
self._contentInstance.Size = UDim2.new(1, 0, 0, self.Height)
end
end
function Passthrough:SetHeight(height)
self.Height = math.max(1, tonumber(height) or self.Height)
if self._mounted then
self:_applyTokens()
end
return self
end
function Passthrough:SetInstance(instance, clone)
if typeof(instance) ~= "Instance" or not instance:IsA("GuiObject") then
error("[BobloUI] Passthrough:SetInstance expects GuiObject.", 2)
end
self:_releaseContent()
if clone ~= nil then
self.Clone = clone == true
end
self._sourceInstance = instance
self._originalParent = instance.Parent
self._contentInstance = if self.Clone then instance:Clone() else instance
if self._valueHost then
self:_mountValue(self._valueHost)
end
return self
end
function Passthrough:GetContentInstance()
return self._contentInstance
end
function Passthrough:Destroy()
self:_releaseContent()
Base.Destroy(self)
end
return Passthrough
end

__modules["controls/Progress"] = function()
local Create = __require("runtime/Create")
local Base = __require("controls/Base")
local Progress = setmetatable({}, { __index = Base })
Progress.__index = Progress
function Progress.new(section, options)
options = options or {}
local self = setmetatable({}, Progress)
self.Min = tonumber(options.Min) or 0
self.Max = tonumber(options.Max) or 100
if self.Max <= self.Min then
self.Max = self.Min + 1
end
self.Suffix = options.Suffix or "%"
self.Format = options.Format
self.ShowValue = options.ShowValue ~= false
self.Indeterminate = options.Indeterminate == true
local d = tonumber(options.Default)
if d == nil then
d = self.Min
end
d = math.clamp(d, self.Min, self.Max)
Base.init(self, section, "Progress", options, { Stateful = true, Default = d, Layout = "Stacked" })
return Base.finish(self)
end
function Progress:_format(v)
if self.Format then
return self.Format(v)
end
return tostring(math.floor(v * 100 + 0.5) / 100) .. self.Suffix
end
function Progress:SetValue(v, silent)
v = math.clamp(tonumber(v) or self.Min, self.Min, self.Max)
return Base.SetValue(self, v, silent)
end
function Progress:_mountValue(host)
local w = self._window
local t = w.Tokens
self._valueLabel = Create.New("TextLabel", {
Size = UDim2.fromOffset(84, 18),
Position = UDim2.new(1, 0, 0, -t:Get("ControlHeight") + 2),
AnchorPoint = Vector2.new(1, 0),
BackgroundTransparency = 1,
Font = w.Fonts.Medium,
TextSize = t:Get("FontSmall"),
TextXAlignment = Enum.TextXAlignment.Right,
Visible = self.ShowValue,
Parent = host,
})
w:_bind(self._valueLabel, { TextColor3 = "TextSecondary" })
self._track = Create.New("Frame", {
Size = UDim2.new(1, -4, 0, 6),
Position = UDim2.new(0, 2, 0.5, 5),
AnchorPoint = Vector2.new(0, 0.5),
BorderSizePixel = 0,
ClipsDescendants = true,
Parent = host,
})
Create.New("UICorner", { CornerRadius = UDim.new(1, 0), Parent = self._track })
w:_bind(self._track, { BackgroundColor3 = "SurfaceInset" })
self._fill = Create.New("Frame", { Size = UDim2.fromScale(0, 1), BorderSizePixel = 0, Parent = self._track })
Create.New("UICorner", { CornerRadius = UDim.new(1, 0), Parent = self._fill })
w:_bind(self._fill, { BackgroundColor3 = "Accent" })
self:_render(self:GetValue())
if self.Indeterminate then
self:_startIndeterminate()
end
end
function Progress:_startIndeterminate()
if self._indeterminateTask then
return
end
self._indeterminateTask = task.spawn(function()
while not self._destroyed and self.Indeterminate do
if self._fill then
self._fill.Size = UDim2.fromScale(0.28, 1)
self._fill.Position = UDim2.fromScale(-0.28, 0)
local tween = self._window.Motion:Tween(
self._fill,
TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
{ Position = UDim2.fromScale(1, 0) }
)
if tween then
tween.Completed:Wait()
else
task.wait(0.8)
end
else
task.wait(0.1)
end
end
self._indeterminateTask = nil
end)
self._janitor:Add(self._indeterminateTask, nil, "indeterminate")
end
function Progress:SetIndeterminate(v)
self.Indeterminate = v == true
if self.Indeterminate then
self:_startIndeterminate()
else
self._janitor:Remove("indeterminate")
self._indeterminateTask = nil
self:_render(self:GetValue())
end
return self
end
function Progress:_render(v)
if self._valueLabel then
self._valueLabel.Text = self:_format(v)
end
if self._fill and not self.Indeterminate then
local a = math.clamp((v - self.Min) / (self.Max - self.Min), 0, 1)
self._fill.Position = UDim2.new()
self._fill.Size = UDim2.fromScale(a, 1)
end
end
function Progress:_applyValueTokens()
if self._valueLabel then
self._valueLabel.TextSize = self._window.Tokens:Get("FontSmall")
end
end
return Progress
end

__modules["controls/Slider"] = function()
local Create = __require("runtime/Create")
local Base = __require("controls/Base")
local Icon = __require("primitives/Icon")
local Slider = setmetatable({}, { __index = Base })
Slider.__index = Slider
function Slider.new(section, options)
if type(options.Min) ~= "number" or type(options.Max) ~= "number" then
error("[BobloUI] AddSlider requires Min and Max numbers.", 3)
end
local self = setmetatable({}, Slider)
self.Min = options.Min
self.Max = options.Max
self.Step = options.Step or 1
self.Precision = if options.Precision ~= nil then options.Precision else options.Rounding
self.Prefix = options.Prefix or ""
self.Suffix = options.Suffix or ""
self.Format = options.Format or options.FormatDisplayValue
self.ValueInput = options.ValueInput ~= false
self.AllowRightClickInput = options.AllowRightClickInput == true
self.FloatingValue = options.FloatingValue == true
self.Compact = options.Compact == true
self.HideMax = options.HideMax ~= false
self.IconFrom = options.IconFrom
self.IconTo = options.IconTo
local d = options.Default
if d == nil then
d = self.Min
end
d = math.clamp(d, self.Min, self.Max)
Base.init(self, section, "Slider", options, {
Stateful = true,
Default = d,
Layout = if self.Compact then nil else "Stacked",
})
return Base.finish(self)
end
function Slider:_format(v)
if self.Format then
return tostring(self.Format(v))
end
local value
if self.Precision then
value = string.format("%." .. self.Precision .. "f", v)
else
value = tostring(v)
end
local maximum = if self.Precision
then string.format("%." .. self.Precision .. "f", self.Max)
else tostring(self.Max)
local range = if self.HideMax then value else `{value} / {maximum}`
return self.Prefix .. range .. self.Suffix
end
function Slider:_normalize(v)
v = tonumber(v) or self.Min
v = math.clamp(v, self.Min, self.Max)
v = math.round((v - self.Min) / self.Step) * self.Step + self.Min
return math.clamp(v, self.Min, self.Max)
end
function Slider:_parseInput(text)
text = tostring(text or "")
if self.Prefix ~= "" and string.sub(text, 1, #self.Prefix) == self.Prefix then
text = string.sub(text, #self.Prefix + 1)
end
if self.Suffix ~= "" and string.sub(text, -#self.Suffix) == self.Suffix then
text = string.sub(text, 1, #text - #self.Suffix)
end
text = string.match(text, "^%s*([^/]+)") or text
return tonumber(string.match(text, "^%s*(.-)%s*$"))
end
function Slider:SetValue(v, silent)
return Base.SetValue(self, self:_normalize(v), silent)
end
function Slider:_mountValue(host)
local w = self._window
local t = w.Tokens
self._valueBox = Create.New("TextBox", {
Size = UDim2.fromOffset(if self.Compact then 92 else 72, 24),
Position = if self.Compact
then UDim2.new(1, 0, 0, 0)
else UDim2.new(1, 0, 0, -t:Get("ControlHeight") + (self.Description and -5 or 2)),
AnchorPoint = Vector2.new(1, 0),
BackgroundTransparency = 1,
BorderSizePixel = 0,
ClearTextOnFocus = false,
Text = self:_format(self:GetValue()),
TextEditable = self.ValueInput,
Font = w.Fonts.Medium,
TextSize = t:Get("FontSmall"),
TextXAlignment = Enum.TextXAlignment.Right,
Parent = host,
})
w:_bind(self._valueBox, { TextColor3 = "TextSecondary" })
local leftInset = if self.IconFrom then 20 else 2
local rightInset = if self.IconTo then 20 else 2
if self.IconFrom then
self._fromIcon = Icon.new(w, self.IconFrom, {
Size = UDim2.fromOffset(14, 14),
Position = UDim2.new(0, 0, 0.5, 5),
AnchorPoint = Vector2.new(0, 0.5),
Parent = host,
})
Icon.setColor(self._fromIcon, w.Theme:Get("TextTertiary"))
end
if self.IconTo then
self._toIcon = Icon.new(w, self.IconTo, {
Size = UDim2.fromOffset(14, 14),
Position = UDim2.new(1, 0, 0.5, 5),
AnchorPoint = Vector2.new(1, 0.5),
Parent = host,
})
Icon.setColor(self._toIcon, w.Theme:Get("TextTertiary"))
end
self._track = Create.New("Frame", {
Size = UDim2.new(1, -leftInset - rightInset, 0, t:Get("SliderTrack")),
Position = UDim2.new(0, leftInset, 0.5, 5),
AnchorPoint = Vector2.new(0, 0.5),
BorderSizePixel = 0,
Parent = host,
})
Create.New("UICorner", { CornerRadius = UDim.new(1, 0), Parent = self._track })
local trackStroke = Create.New("UIStroke", { Thickness = 1, Transparency = 0.76, Parent = self._track })
w:_bind(trackStroke, { Color = "BorderSubtle" })
w:_bind(self._track, { BackgroundColor3 = "SurfaceInset" })
self._fill = Create.New("Frame", { Size = UDim2.fromScale(0, 1), BorderSizePixel = 0, Parent = self._track })
Create.New("UICorner", { CornerRadius = UDim.new(1, 0), Parent = self._fill })
w:_bind(self._fill, { BackgroundColor3 = "Accent" })
self._knob = Create.New("Frame", {
Size = UDim2.fromOffset(t:Get("SliderKnob"), t:Get("SliderKnob")),
Position = UDim2.new(0, 0, 0.5, 0),
AnchorPoint = Vector2.new(0.5, 0.5),
BorderSizePixel = 0,
ZIndex = 3,
Parent = self._track,
})
Create.New("UICorner", { CornerRadius = UDim.new(1, 0), Parent = self._knob })
Create.New("UIStroke", { Thickness = 1, Color = Color3.new(1, 1, 1), Transparency = 0.42, Parent = self._knob })
w:_bind(self._knob, { BackgroundColor3 = "Accent" })
if self.FloatingValue then
self._bubble = Create.New("TextLabel", {
Size = UDim2.fromOffset(64, 24),
Position = UDim2.new(0, 0, 0.5, -18),
AnchorPoint = Vector2.new(0.5, 1),
BackgroundTransparency = 0,
BorderSizePixel = 0,
Visible = false,
Font = w.Fonts.Medium,
TextSize = t:Get("FontCaption"),
ZIndex = 6,
Parent = self._track,
})
Create.New("UICorner", { CornerRadius = UDim.new(0, 6), Parent = self._bubble })
local bubbleStroke = Create.New("UIStroke", {
Thickness = 1,
Transparency = 0.38,
LineJoinMode = Enum.LineJoinMode.Round,
Parent = self._bubble,
})
w:_bind(self._bubble, { BackgroundColor3 = "SurfaceRaised", TextColor3 = "Text" })
w:_bind(bubbleStroke, { Color = "Border" })
end
local hit = Create.New("TextButton", {
Size = UDim2.new(1, 0, 0, 30),
Position = UDim2.new(0, 0, 0.5, 0),
AnchorPoint = Vector2.new(0, 0.5),
BackgroundTransparency = 1,
Text = "",
ZIndex = 4,
Parent = self._track,
})
self._janitor:Add(hit.InputBegan:Connect(function(i)
if self:IsDisabled() then
return
end
if i.UserInputType ~= Enum.UserInputType.MouseButton1 and i.UserInputType ~= Enum.UserInputType.Touch then
return
end
local page = self._section._tab._page
local oldScroll = page and page.ScrollingEnabled
if i.UserInputType == Enum.UserInputType.Touch and page then
page.ScrollingEnabled = false
end
if self._bubble then
self._bubble.Visible = true
end
local function at(pos)
local a = (pos.X - self._track.AbsolutePosition.X) / math.max(1, self._track.AbsoluteSize.X)
self:SetValue(self.Min + math.clamp(a, 0, 1) * (self.Max - self.Min))
end
at(i.Position)
w.Input:CapturePointer(self, i, function(m)
at(m.Position)
end, function()
if page and oldScroll ~= nil then
page.ScrollingEnabled = oldScroll
end
if self._bubble then
self._bubble.Visible = false
end
end)
end))
if self.ValueInput or self.AllowRightClickInput then
self._janitor:Add(self._valueBox.FocusLost:Connect(function()
local parsed = self:_parseInput(self._valueBox.Text)
if parsed == nil then
self:_render(self:GetValue())
else
self:SetValue(parsed)
end
if not self.ValueInput then
self._valueBox.TextEditable = false
end
end))
end
if self.AllowRightClickInput then
self._janitor:Add(self._valueBox.InputBegan:Connect(function(input)
if input.UserInputType ~= Enum.UserInputType.MouseButton2 or self:IsDisabled() then
return
end
self._valueBox.TextEditable = true
self._valueBox:CaptureFocus()
self._valueBox.CursorPosition = #self._valueBox.Text + 1
end))
end
end
function Slider:_applyDisabled()
Base._applyDisabled(self)
if self._valueBox then
self._valueBox.TextEditable = not self._disabled and self.ValueInput
end
end
function Slider:_render(v)
if not self._fill then
return
end
local a = math.clamp((v - self.Min) / math.max(0.000001, self.Max - self.Min), 0, 1)
self._fill.Size = UDim2.fromScale(a, 1)
self._knob.Position = UDim2.fromScale(a, 0.5)
if self._bubble then
self._bubble.Position = UDim2.new(a, 0, 0.5, -18)
self._bubble.Text = self:_format(v)
end
if not self._valueBox:IsFocused() then
self._valueBox.Text = self:_format(v)
end
end
function Slider:_applyValueTokens()
if self._track then
local leftInset = if self.IconFrom then 20 else 2
local rightInset = if self.IconTo then 20 else 2
self._track.Size = UDim2.new(1, -leftInset - rightInset, 0, self._window.Tokens:Get("SliderTrack"))
local n = self._window.Tokens:Get("SliderKnob")
self._knob.Size = UDim2.fromOffset(n, n)
self._valueBox.TextSize = self._window.Tokens:Get("FontSmall")
end
end
function Slider:SetMin(v)
self.Min = v
if self.Max < self.Min then
self.Max = self.Min
end
self:SetValue(self:GetValue(), true)
return self
end
function Slider:SetMax(v)
self.Max = v
if self.Min > self.Max then
self.Min = self.Max
end
self:SetValue(self:GetValue(), true)
return self
end
function Slider:SetStep(v)
self.Step = math.max(0.000001, v)
self:SetValue(self:GetValue(), true)
return self
end
function Slider:SetPrefix(value)
self.Prefix = tostring(value or "")
self:_render(self:GetValue())
return self
end
function Slider:SetSuffix(value)
self.Suffix = tostring(value or "")
self:_render(self:GetValue())
return self
end
return Slider
end

__modules["controls/Status"] = function()
local Create = __require("runtime/Create")
local Base = __require("controls/Base")
local Status = setmetatable({}, { __index = Base })
Status.__index = Status
local TOKENS = {
Neutral = "TextSecondary",
Success = "Success",
Warning = "Warning",
Error = "Error",
Info = "Info",
Pending = "Warning",
}
function Status.new(section, options)
local self = setmetatable({}, Status)
self.Status = options.Status or "Neutral"
self.Pulse = options.Pulse == true
Base.init(
self,
section,
"Status",
options,
{ Stateful = options.Id ~= nil, Default = options.Value, Persist = false, Adaptive = true }
)
if not options.Id then
self._value = options.Value
end
return Base.finish(self)
end
function Status:_mountValue(host)
local w = self._window
self._statusWrap = Create.New("Frame", {
AutomaticSize = Enum.AutomaticSize.X,
Size = UDim2.new(0, 0, 1, 0),
Position = UDim2.new(1, 0, 0, 0),
AnchorPoint = Vector2.new(1, 0),
BackgroundTransparency = 1,
Parent = host,
})
local layout = Create.New("UIListLayout", {
FillDirection = Enum.FillDirection.Horizontal,
HorizontalAlignment = Enum.HorizontalAlignment.Right,
VerticalAlignment = Enum.VerticalAlignment.Center,
Padding = UDim.new(0, 8),
Parent = self._statusWrap,
})
self._dot = Create.New(
"Frame",
{ Size = UDim2.fromOffset(7, 7), BorderSizePixel = 0, LayoutOrder = 1, Parent = self._statusWrap }
)
Create.New("UICorner", { CornerRadius = UDim.new(1, 0), Parent = self._dot })
w:_bind(self._dot, {
BackgroundColor3 = function(palette)
return palette[TOKENS[self.Status] or "TextSecondary"]
end,
})
self._valueLabel = Create.New("TextLabel", {
AutomaticSize = Enum.AutomaticSize.X,
Size = UDim2.new(0, 0, 1, 0),
BackgroundTransparency = 1,
Font = w.Fonts.Medium,
TextSize = w.Tokens:Get("FontSmall"),
TextXAlignment = Enum.TextXAlignment.Left,
Text = "",
LayoutOrder = 2,
Parent = self._statusWrap,
})
w:_bind(self._valueLabel, { TextColor3 = "TextSecondary" })
self:SetStatus(self.Status)
if self.Pulse and w.Motion:IsEnabled("Controls") then
local tw = w.Motion:Tween(
self._dot,
TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
{ BackgroundTransparency = 0.65 }
)
if tw then
self._janitor:Add(tw)
end
end
end
function Status:_render(v)
if self._valueLabel then
self._valueLabel.Text = tostring(v or "")
end
end
function Status:SetStatus(s)
self.Status = s
if self._dot then
self._dot.BackgroundColor3 = self._window.Theme:Get(TOKENS[s] or "TextSecondary")
end
return self
end
function Status:_applyValueTokens()
if self._valueLabel then
self._valueLabel.TextSize = self._window.Tokens:Get("FontSmall")
end
end
return Status
end

__modules["controls/TextField"] = function()
local Create = __require("runtime/Create")
local Base = __require("controls/Base")
local TextField = setmetatable({}, { __index = Base })
TextField.__index = TextField
function TextField.new(section, options)
local self = setmetatable({}, TextField)
local default = options.Default
if default == nil then
default = if options.Numeric == true then 0 else ""
end
self.Placeholder = options.Placeholder or ""
self.Numeric = options.Numeric == true
self.MaxLength = options.MaxLength
self.Multiline = options.Multiline == true
self.Height = math.max(34, tonumber(options.Height) or (self.Multiline and 110 or 0))
self.ClearOnFocus = options.ClearOnFocus == true or options.ClearTextOnFocus == true
self.ClearTextOnBlur = options.ClearTextOnBlur == true
self.AllowEmpty = if options.AllowEmpty ~= nil then options.AllowEmpty ~= false else not self.Numeric
self.EmptyReset = if options.EmptyReset ~= nil then options.EmptyReset else (self.Numeric and 0 or default)
self.Validate = options.Validate or options.VerifyValue
self.CommitOn = options.CommitOn
or if options.Finished == true then "Enter" elseif options.Finished == false then "Change" else "FocusLost"
self._error = nil
Base.init(self, section, "Input", options, {
Stateful = true,
Default = default,
Adaptive = true,
Layout = if self.Multiline then "Stacked" else nil,
})
return Base.finish(self)
end
function TextField:_measure()
if self.Multiline then
local t = self._window.Tokens
return t:Get("ControlHeight") + self.Height + 10 + (self.Description and 12 or 0)
end
return Base._measure(self)
end
function TextField:_mountValue(host)
local w = self._window
local t = w.Tokens
self._box = Create.New("TextBox", {
Size = UDim2.new(1, 0, 0, if self.Multiline then self.Height else t:Get("FieldHeight")),
Position = UDim2.new(0, 0, 0.5, 0),
AnchorPoint = Vector2.new(0, 0.5),
BackgroundTransparency = 0,
BorderSizePixel = 0,
ClearTextOnFocus = self.ClearOnFocus,
MultiLine = self.Multiline,
PlaceholderText = self.Placeholder,
Text = tostring(self:GetValue() or ""),
Font = w.Fonts.Regular,
TextSize = t:Get("FontBody"),
TextXAlignment = Enum.TextXAlignment.Left,
TextYAlignment = if self.Multiline then Enum.TextYAlignment.Top else Enum.TextYAlignment.Center,
Parent = host,
})
Create.New("UICorner", { CornerRadius = UDim.new(0, t:Get("FieldRadius")), Parent = self._box })
Create.New("UIPadding", { PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10), Parent = self._box })
self._stroke = Create.New("UIStroke", { Thickness = 1, Transparency = 0.45, Parent = self._box })
w:_bind(self._stroke, { Color = "BorderSubtle" })
w:_bind(self._box, { BackgroundColor3 = "ControlInset", TextColor3 = "Text", PlaceholderColor3 = "TextTertiary" })
if self.CommitOn == "Change" then
self._janitor:Add(self._box:GetPropertyChangedSignal("Text"):Connect(function()
if not self._suppressCommit then
self:_commit()
end
end))
end
self._janitor:Add(self._box.Focused:Connect(function()
self._stroke.Color = w.Theme:Get("AccentBorder")
self._stroke.Transparency = 0
if w.Device.Layout == "Drawer" then
task.defer(function()
self:Reveal()
end)
end
end))
self._janitor:Add(self._box.FocusLost:Connect(function(enter)
self._stroke.Color = w.Theme:Get("BorderSubtle")
self._stroke.Transparency = 0.45
if self.CommitOn == "FocusLost" or (self.CommitOn == "Enter" and enter) then
self:_commit()
end
if self.ClearTextOnBlur then
self._suppressCommit = true
self._box.Text = ""
self._suppressCommit = false
end
end))
end
function TextField:_commit()
local text = self._box.Text
if self.MaxLength and #text > self.MaxLength then
text = string.sub(text, 1, self.MaxLength)
self._box.Text = text
end
if text == "" then
if self.AllowEmpty then
self:SetError(nil)
self:SetValue("")
return
end
local reset = self.EmptyReset
text = tostring(if reset == nil then (self.Numeric and 0 or "") else reset)
self._box.Text = text
end
local value = if self.Numeric then tonumber(text) else text
if self.Numeric and value == nil then
self:SetError("Enter a number")
self:_render(self:GetValue())
return
end
if self.Validate then
local ok, message = self.Validate(value)
if not ok then
self:SetError(message or "Invalid value")
return
end
end
self:SetError(nil)
self:SetValue(value)
end
function TextField:_render(v)
if self._box then
if not self._box:IsFocused() then
self._box.Text = tostring(v or "")
end
self._box.BackgroundColor3 = self._window.Theme:Get(self._error and "AccentSoft" or "ControlInset")
if self._error then
self._stroke.Color = self._window.Theme:Get("Error")
self._stroke.Transparency = 0
end
end
end
function TextField:Focus()
if self._box then
self._box:CaptureFocus()
end
return self
end
function TextField:Blur()
if self._box then
self._box:ReleaseFocus()
end
return self
end
function TextField:Clear()
if self.AllowEmpty then
return self:SetValue("")
end
return self:SetValue(self.EmptyReset)
end
function TextField:SetAllowEmpty(enabled, emptyReset)
self.AllowEmpty = enabled ~= false
if emptyReset ~= nil then
self.EmptyReset = emptyReset
end
if not self.AllowEmpty and self:GetValue() == "" then
self:SetValue(self.EmptyReset)
end
return self
end
function TextField:SetError(text)
self._error = text
self:_render(self:GetValue())
return self
end
function TextField:_applyDisabled()
Base._applyDisabled(self)
if self._box then
self._box.TextEditable = not self._disabled
end
end
function TextField:_applyValueTokens()
if self._valueHost and self.Multiline then
self._valueHost.Size = UDim2.new(1, -self._window.Tokens:Get("ControlPadding") * 2, 0, self.Height)
end
if self._box then
self._box.Size =
UDim2.new(1, 0, 0, if self.Multiline then self.Height else self._window.Tokens:Get("FieldHeight"))
self._box.TextSize = self._window.Tokens:Get("FontBody")
end
end
return TextField
end

__modules["controls/Toggle"] = function()
local Create = __require("runtime/Create")
local Base = __require("controls/Base")
local Icon = __require("primitives/Icon")
local Toggle = setmetatable({}, { __index = Base })
Toggle.__index = Toggle
function Toggle:AddKeybind(options)
options = table.clone(options or {})
options.AttachTo = self
if options.SyncToggle == nil then
options.SyncToggle = true
end
return __require("controls/Keybind").new(self._section, options)
end
function Toggle.new(section, options)
local self = setmetatable({}, Toggle)
self.Style = options.Style or (if section._window._minimal then "Checkbox" else "Switch")
Base.init(self, section, "Toggle", options, { Stateful = true, Default = options.Default == true })
return Base.finish(self)
end
function Toggle:_mountValue(host)
local w = self._window
local t = w.Tokens
local checkbox = self.Style == "Checkbox"
self._button = Create.New("TextButton", {
Size = if checkbox then UDim2.fromOffset(20, 20) else UDim2.fromOffset(34, 18),
Position = UDim2.new(1, 0, 0.5, 0),
AnchorPoint = Vector2.new(1, 0.5),
BorderSizePixel = 0,
AutoButtonColor = false,
Text = "",
Parent = host,
})
Create.New(
"UICorner",
{ CornerRadius = if checkbox then UDim.new(0, 5) else UDim.new(1, 0), Parent = self._button }
)
self._stroke = Create.New("UIStroke", { Thickness = 1, Transparency = 0.45, Parent = self._button })
w:_bind(self._stroke, { Color = "BorderStrong" })
w:_bind(self._button, { BackgroundColor3 = "SurfaceInset" })
if checkbox then
self._check = Icon.new(w, "check", {
Size = UDim2.fromOffset(12, 12),
Position = UDim2.fromScale(0.5, 0.5),
AnchorPoint = Vector2.new(0.5, 0.5),
Visible = false,
Parent = self._button,
})
Icon.setColor(self._check, w.Theme:Get("TextOnAccent"))
else
self._knob = Create.New("Frame", {
Size = UDim2.fromOffset(12, 12),
Position = UDim2.new(0, 3, 0.5, 0),
AnchorPoint = Vector2.new(0, 0.5),
BorderSizePixel = 0,
Parent = self._button,
})
Create.New("UICorner", { CornerRadius = UDim.new(1, 0), Parent = self._knob })
w:_bind(self._knob, { BackgroundColor3 = "TextTertiary" })
end
self._janitor:Add(self._button.MouseButton1Click:Connect(function()
if not self:IsDisabled() then
self:Flip()
end
end))
if w._minimal then
self._root.Active = true
self._janitor:Add(self._root.InputBegan:Connect(function(input)
if
self:IsDisabled()
or (
input.UserInputType ~= Enum.UserInputType.MouseButton1
and input.UserInputType ~= Enum.UserInputType.Touch
)
then
return
end
local point = input.Position
local buttonPos, buttonSize = self._button.AbsolutePosition, self._button.AbsoluteSize
if
point.X >= buttonPos.X
and point.X <= buttonPos.X + buttonSize.X
and point.Y >= buttonPos.Y
and point.Y <= buttonPos.Y + buttonSize.Y
then
return
end
self:Flip()
end))
end
end
function Toggle:_render(value)
if not self._button then
return
end
local on = value == true
local w = self._window
self._button.BackgroundColor3 = w.Theme:Get(if on then "Accent" else "SurfaceInset")
self._stroke.Color = w.Theme:Get(if on then "AccentBorder" else "BorderSubtle")
self._stroke.Transparency = if on then 0.2 else 0.45
if self.Style == "Checkbox" then
if self._check then
self._check.Visible = on
end
elseif self._knob then
self._knob.BackgroundColor3 = w.Theme:Get(if on then "TextOnAccent" else "TextSecondary")
w.Motion:Tween(
self._knob,
"Fast",
{ Position = if on then UDim2.new(1, -15, 0.5, 0) else UDim2.new(0, 3, 0.5, 0) }
)
end
end
function Toggle:Flip()
if self._window.Sound then
self._window.Sound:Play("Toggle")
end
return self:SetValue(not self:GetValue())
end
return Toggle
end

__modules["controls/Video"] = function()
local Create = __require("runtime/Create")
local Base = __require("controls/Base")
local Video = setmetatable({}, { __index = Base })
Video.__index = Video
function Video.new(section, options)
options = options or {}
local self = setmetatable({}, Video)
self.Video = options.Video or ""
self.Looped = options.Looped == true
self.Playing = options.Playing == true
self.Volume = math.clamp(tonumber(options.Volume) or 0.5, 0, 1)
self.Height = math.max(80, tonumber(options.Height) or 180)
Base.init(self, section, "Video", options, { Stateful = false, Persist = false, Layout = "Stacked" })
return Base.finish(self)
end
function Video:_measure()
local t = self._window.Tokens
return t:Get("ControlHeight") + self.Height + (self.Description and 12 or 0) + 10
end
function Video:_mountValue(host)
local w = self._window
self._video = Create.New("VideoFrame", {
Size = UDim2.new(1, 0, 0, self.Height),
BackgroundTransparency = 0,
BorderSizePixel = 0,
Video = self.Video,
Looped = self.Looped,
Playing = self.Playing,
Volume = self.Volume,
Parent = host,
})
Create.New("UICorner", {
CornerRadius = UDim.new(0, w.Tokens:Get("FieldRadius")),
Parent = self._video,
})
local stroke = Create.New("UIStroke", {
Thickness = 1,
Transparency = 0.5,
LineJoinMode = Enum.LineJoinMode.Round,
Parent = self._video,
})
w:_bind(self._video, { BackgroundColor3 = "ControlInset" })
w:_bind(stroke, { Color = "BorderSubtle" })
self._janitor:Add(self._video.InputBegan:Connect(function(input)
if
not self:IsDisabled()
and (
input.UserInputType == Enum.UserInputType.MouseButton1
or input.UserInputType == Enum.UserInputType.Touch
)
then
self:SetPlaying(not self._video.Playing)
end
end))
end
function Video:SetVideo(value)
self.Video = value or ""
if self._video then
self._video.Video = self.Video
end
return self
end
function Video:SetLooped(looped)
self.Looped = looped == true
if self._video then
self._video.Looped = self.Looped
end
return self
end
function Video:SetPlaying(playing)
self.Playing = playing == true
if self._video then
self._video.Playing = self.Playing
end
return self
end
function Video:SetVolume(volume)
self.Volume = math.clamp(tonumber(volume) or self.Volume, 0, 1)
if self._video then
self._video.Volume = self.Volume
end
return self
end
function Video:Play()
return self:SetPlaying(true)
end
function Video:Pause()
return self:SetPlaying(false)
end
function Video:SetHeight(height)
self.Height = math.max(80, tonumber(height) or self.Height)
if self._mounted then
self:_applyTokens()
end
return self
end
function Video:_applyValueTokens()
if self._valueHost then
self._valueHost.Size = UDim2.new(1, -self._window.Tokens:Get("ControlPadding") * 2, 0, self.Height)
end
if self._video then
self._video.Size = UDim2.new(1, 0, 0, self.Height)
end
end
return Video
end

__modules["controls/Viewport"] = function()
local Create = __require("runtime/Create")
local Base = __require("controls/Base")
local Viewport = setmetatable({}, { __index = Base })
Viewport.__index = Viewport
local function bounds(object)
if object:IsA("Model") then
local ok, cf, size = pcall(object.GetBoundingBox, object)
if ok then
return cf, size
end
end
if object:IsA("BasePart") then
return object.CFrame, object.Size
end
return CFrame.new(), Vector3.new(4, 4, 4)
end
function Viewport.new(section, options)
options = options or {}
if typeof(options.Object) ~= "Instance" then
error("[BobloUI] AddViewport requires Object = Instance.", 3)
end
if options.Camera ~= nil and (typeof(options.Camera) ~= "Instance" or not options.Camera:IsA("Camera")) then
error("[BobloUI] AddViewport Camera must be a Camera instance.", 3)
end
local self = setmetatable({}, Viewport)
self.Object = options.Object
self.Clone = options.Clone ~= false
self.DestroyObject = options.DestroyObject == true
self.Camera = options.Camera
self.Interactive = options.Interactive == true
self.AutoFocus = options.AutoFocus ~= false
self.Height = math.max(80, tonumber(options.Height) or 200)
self._yaw = 35
self._pitch = -18
self._distance = 8
Base.init(self, section, "Viewport", options, { Stateful = false, Persist = false, Layout = "Stacked" })
return Base.finish(self)
end
function Viewport:_measure()
local t = self._window.Tokens
return t:Get("ControlHeight") + self.Height + (self.Description and 12 or 0) + 10
end
function Viewport:_mountValue(host)
local w = self._window
local t = w.Tokens
self._viewport = Create.New("ViewportFrame", {
Size = UDim2.new(1, 0, 0, self.Height),
BackgroundTransparency = 0,
BorderSizePixel = 0,
Ambient = Color3.fromRGB(160, 160, 160),
LightColor = Color3.new(1, 1, 1),
LightDirection = Vector3.new(-1, -1, -1),
Parent = host,
})
Create.New("UICorner", { CornerRadius = UDim.new(0, t:Get("FieldRadius")), Parent = self._viewport })
local stroke = Create.New("UIStroke", {
Thickness = 1,
Transparency = 0.5,
LineJoinMode = Enum.LineJoinMode.Round,
Parent = self._viewport,
})
w:_bind(self._viewport, { BackgroundColor3 = "ControlInset" })
w:_bind(stroke, { Color = "BorderSubtle" })
self._world = Create.New("WorldModel", { Parent = self._viewport })
self._cameraOwned = self.Camera == nil
self._cameraOriginalParent = self.Camera and self.Camera.Parent or nil
self._camera = self.Camera or Instance.new("Camera")
self._camera.Parent = self._viewport
self._viewport.CurrentCamera = self._camera
self:_setWorldObject(self.Object)
if self.AutoFocus then
self:Focus()
end
self._janitor:Add(self._viewport.InputBegan:Connect(function(input)
if not self.Interactive or self:IsDisabled() then
return
end
if
input.UserInputType ~= Enum.UserInputType.MouseButton1
and input.UserInputType ~= Enum.UserInputType.Touch
then
return
end
local start = input.Position
local yaw, pitch = self._yaw, self._pitch
w.Input:CapturePointer(self, input, function(move)
local delta = move.Position - start
self._yaw = yaw - delta.X * 0.35
self._pitch = math.clamp(pitch - delta.Y * 0.25, -80, 80)
self:_updateCamera()
end, function()
if self.Callback then
pcall(self.Callback, self)
end
end)
end))
self._janitor:Add(self._viewport.InputChanged:Connect(function(input)
if self.Interactive and input.UserInputType == Enum.UserInputType.MouseWheel then
self._distance = math.clamp(self._distance - input.Position.Z, 1.5, 80)
self:_updateCamera()
end
end))
end
function Viewport:_releaseRenderObject()
if self._renderObject then
if self.Clone or self.DestroyObject then
self._renderObject:Destroy()
else
self._renderObject.Parent = self._objectOriginalParent
end
self._renderObject = nil
end
self._objectOriginalParent = nil
end
function Viewport:_setWorldObject(object, clone)
self:_releaseRenderObject()
if clone ~= nil then
self.Clone = clone == true
end
self.Object = object
self._objectOriginalParent = if self.Clone then nil else object.Parent
self._renderObject = if self.Clone then object:Clone() else object
self._renderObject.Parent = self._world
end
function Viewport:_updateCamera()
if not self._camera then
return
end
local focus = self._focus or Vector3.new()
local rotation = CFrame.Angles(math.rad(self._pitch), math.rad(self._yaw), 0)
local offset = rotation:VectorToWorldSpace(Vector3.new(0, 0, self._distance))
self._camera.CFrame = CFrame.lookAt(focus + offset, focus)
end
function Viewport:Focus()
if not self._renderObject then
return self
end
local cf, size = bounds(self._renderObject)
self._focus = cf.Position
local radius = math.max(size.X, size.Y, size.Z) * 0.5
local fov = math.rad((self._camera and self._camera.FieldOfView or 40) * 0.5)
self._distance = math.max(1.5, radius / math.max(0.1, math.tan(fov)) * 1.25)
self:_updateCamera()
return self
end
function Viewport:SetObject(object, clone)
if typeof(object) ~= "Instance" then
error("[BobloUI] Viewport:SetObject expects Instance.", 2)
end
if self._world then
self:_setWorldObject(object, clone)
if self.AutoFocus then
self:Focus()
end
else
self.Object = object
if clone ~= nil then
self.Clone = clone == true
end
end
return self
end
function Viewport:SetCamera(camera)
if typeof(camera) ~= "Instance" or not camera:IsA("Camera") then
error("[BobloUI] Viewport:SetCamera expects Camera.", 2)
end
if self._camera then
if self._cameraOwned then
self._camera:Destroy()
else
self._camera.Parent = self._cameraOriginalParent
end
end
self.Camera = camera
self._cameraOwned = false
self._cameraOriginalParent = camera.Parent
self._camera = camera
if self._viewport then
camera.Parent = self._viewport
self._viewport.CurrentCamera = camera
end
return self
end
function Viewport:SetInteractive(interactive)
self.Interactive = interactive == true
return self
end
function Viewport:SetHeight(height)
self.Height = math.max(80, tonumber(height) or self.Height)
if self._mounted then
self:_applyTokens()
end
return self
end
function Viewport:_applyValueTokens()
if self._valueHost then
self._valueHost.Size = UDim2.new(1, -self._window.Tokens:Get("ControlPadding") * 2, 0, self.Height)
end
if self._viewport then
self._viewport.Size = UDim2.new(1, 0, 0, self.Height)
end
end
function Viewport:Destroy()
self:_releaseRenderObject()
if self._camera then
if self._cameraOwned then
self._camera:Destroy()
else
self._camera.Parent = self._cameraOriginalParent
end
self._camera = nil
end
Base.Destroy(self)
end
return Viewport
end

__modules["init"] = function()
local Env = __require("runtime/Env")
local Janitor = __require("runtime/Janitor")
local Util = __require("runtime/Util")
local Typography = __require("runtime/Typography")
local Tokens = __require("kernel/Tokens")
local Theme = __require("kernel/Theme")
local Device = __require("kernel/Device")
local Layer = __require("kernel/Layer")
local Store = __require("kernel/Store")
local Registry = __require("kernel/Registry")
local Input = __require("kernel/Input")
local Motion = __require("kernel/Motion")
local Locale = __require("kernel/Locale")
local Window = __require("shell/Window")
local Favorites = __require("services/Favorites")
local Config = __require("services/Config")
local Search = __require("services/Search")
local Commands = __require("services/Commands")
local Notify = __require("services/Notify")
local Dialog = __require("services/Dialog")
local Palette = __require("services/Palette")
local Interactions = __require("services/Interactions")
local Build = __require("schema/Build")
local Icon = __require("primitives/Icon")
local Dark = __require("themes/Dark")
local Light = __require("themes/Light")
local Settings = __require("services/Settings")
local Sound = __require("services/Sound")
local Navigation = __require("services/Navigation")
local Loading = __require("services/Loading")
local HUD = __require("services/HUD")
local Cursor = __require("services/Cursor")
local Overlays = __require("services/Overlays")
local ThemeManager = __require("services/ThemeManager")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local BobloUI = {}
BobloUI.Version = "0.11.5-beta.1"
BobloUI.ApiLevel = 11
BobloUI.Env = Env
BobloUI.Icon = Icon
BobloUI.Sources = {}
function BobloUI.Source(getter, signals)
if type(getter) ~= "function" then
error("[BobloUI] Source requires a getter function.", 2)
end
return { Get = getter, Signals = signals or {} }
end
function BobloUI.Sources.Players(options)
options = options or {}
return {
Get = function()
local out = {}
for _, player in Players:GetPlayers() do
if options.IncludeLocalPlayer ~= false or player ~= Players.LocalPlayer then
table.insert(out, {
Value = if options.ReturnPlayer then player else player.Name,
Title = options.UseUsername and player.Name or player.DisplayName,
Description = if player.DisplayName ~= player.Name then "@" .. player.Name else nil,
Icon = options.Icon,
})
end
end
table.sort(out, function(a, b)
return string.lower(a.Title) < string.lower(b.Title)
end)
return out
end,
Signals = { Players.PlayerAdded, Players.PlayerRemoving },
}
end
local REGISTRY_KEY = "__BobloUI"
local function globalRegistry()
local existing = Env.Globals[REGISTRY_KEY]
if type(existing) == "table" and type(existing.Instances) == "table" then
return existing
end
local created = { Instances = {} }
Env.Globals[REGISTRY_KEY] = created
return created
end
local function evict(id)
local r = globalRegistry()
local previous = r.Instances[id]
if not previous then
return
end
r.Instances[id] = nil
local ok, err = pcall(function()
previous:Unload()
end)
if not ok then
warn(`[BobloUI] previous window "{id}" failed to unload ({err}); sweeping GUIs.`)
Layer.SweepOrphans(id)
end
end
local WINDOW_OPTIONS = {
"Id",
"Singleton",
"Title",
"Subtitle",
"Icon",
"Theme",
"Accent",
"Density",
"Scale",
"Size",
"Presentation",
"MinSize",
"Locale",
"ToggleKey",
"ToggleUIKeybind",
"ShowText",
"ConfigFolder",
"ThemeFolder",
"AutoLoadTheme",
"AutoLoad",
"ReducedMotion",
"HighContrast",
"Settings",
"RememberGeometry",
"KeyboardNavigation",
"SoundEnabled",
"SoundVolume",
"Sounds",
"OnUnload",
"SidebarHidden",
"SidebarWidth",
"EnableSidebarResize",
"Compact",
"DisableSearch",
"SearchbarSize",
"GlobalSearch",
"ShowMobileButtons",
"MobileButtonsSide",
"EnableCompacting",
"DisableCompactingSnap",
"SidebarCompacted",
"MinContainerWidth",
"MinSidebarWidth",
"SidebarCompactWidth",
"SidebarCollapseThreshold",
"CompactWidthActivation",
"TabSwipeOffset",
"TabSwipeFrom",
"Font",
"Animations",
"CornerRadius",
"FooterHeight",
"FooterText",
"Opacity",
"BackgroundImage",
"BackgroundImageTransparency",
"RestoreButton",
"TabTransition",
"WindowAnimation",
"TabTransitionTime",
"NotificationPosition",
"Watermark",
"KeybindHUD",
"CustomCursor",
}
local function checkOptions(options)
if type(options) ~= "table" then
error("[BobloUI] CreateWindow expects an options table.", 3)
end
if type(options.Title) ~= "string" then
error("[BobloUI] CreateWindow: Title is required and must be a string.", 3)
end
if options.Presentation ~= nil and options.Presentation ~= "Standard" and options.Presentation ~= "Minimal" then
error("[BobloUI] Presentation must be 'Standard' or 'Minimal'.", 3)
end
for key in options do
if not table.find(WINDOW_OPTIONS, key) then
local suggestion = Util.suggest(tostring(key), WINDOW_OPTIONS)
local hint = if suggestion then ' Did you mean "' .. suggestion .. '"?' else ""
warn(
`[BobloUI] CreateWindow: unknown option "{key}".{hint}\nValid options: {table.concat(
WINDOW_OPTIONS,
", "
)}`
)
end
end
end
local function normalizeBundledTheme(name, theme)
if name ~= "Midnight" and name ~= "OLED" then
return name
end
if theme and table.find(theme:List(), name) then
return name
end
return "Dark"
end
function BobloUI:CreateWindow(options)
checkOptions(options)
local id = options.Id or Util.slug(options.Title)
if not options.Id then
warn(`[BobloUI] CreateWindow: no Id given, using "{id}" from Title. Set Id explicitly.`)
end
local singleton = options.Singleton ~= false
if singleton then
evict(id)
end
local janitor = Janitor.new(`Window[{id}]`)
local device = Device.new()
janitor:Add(device)
local tokens = Tokens.new(
options.Density
or (options.Compact and "Compact")
or (options.Presentation == "Minimal" and "Compact")
or "Comfortable",
device.Class,
options.Presentation == "Minimal"
)
janitor:Add(tokens)
local theme = Theme.new({
Palettes = { Dark = Dark, Light = Light },
Accent = options.Accent,
})
janitor:Add(theme)
local requestedTheme = options.Theme
local initialTheme = normalizeBundledTheme(requestedTheme or "Dark", theme)
if not table.find({ "Dark", "Light" }, initialTheme) then
initialTheme = "Dark"
end
theme:Set(initialTheme)
if options.HighContrast then
theme:SetHighContrast(true)
end
local input = Input.new()
janitor:Add(input)
local layers = Layer.new(id, input, theme)
janitor:Add(layers)
local state = Store.new()
janitor:Add(state)
local registry = Registry.new()
janitor:Add(registry)
local motion = Motion.new()
janitor:Add(motion)
if options.ReducedMotion then
motion:SetEnabled(false)
end
local locale = Locale.new(options.Locale or "en")
janitor:Add(locale)
locale:Register("en", {
["search.placeholder"] = "Search controls or type > for commands",
["common.cancel"] = "Cancel",
["common.confirm"] = "Confirm",
["settings.title"] = "Settings",
["settings.description"] = "Interface, profiles and accessibility",
["nav.system"] = "System",
["settings.appearance"] = "Appearance",
["settings.appearanceDesc"] = "Theme, scale, density and language",
["settings.theme"] = "Theme",
["settings.accent"] = "Accent color",
["settings.scale"] = "UI scale",
["settings.density"] = "Density",
["settings.language"] = "Language",
["settings.reducedMotion"] = "Reduced motion",
["settings.highContrast"] = "High contrast",
["settings.keyboardNavigation"] = "Keyboard / gamepad navigation",
["settings.uiSounds"] = "UI sounds",
["settings.soundVolume"] = "UI sound volume",
["settings.themeEditor"] = "Advanced theme editor",
["settings.themeEditorDesc"] = "Override any core interface color",
["settings.theme.reset"] = "Reset custom theme",
["settings.theme.export"] = "Export theme",
["settings.theme.import"] = "Import theme",
["settings.window"] = "Window",
["settings.lockWindow"] = "Lock window position",
["settings.rememberGeometry"] = "Remember size and position",
["settings.resetLayout"] = "Reset window layout",
["settings.resetAll"] = "Reset all controls",
["settings.configs"] = "Config profiles",
["settings.config.name"] = "Profile name",
["settings.config.profile"] = "Selected profile",
["settings.config.save"] = "Save profile",
["settings.config.load"] = "Load profile",
["settings.config.autoload"] = "Auto-load profile",
["settings.config.duplicate"] = "Duplicate profile",
["settings.config.rename"] = "Rename profile",
["settings.config.delete"] = "Delete profile",
["settings.config.export"] = "Export profile",
["settings.config.import"] = "Import profile",
["settings.config.paste"] = "Paste exported JSON",
["settings.config.disabled"] = "Set ConfigFolder in CreateWindow to enable persistent profiles.",
["settings.favorites"] = "Favorites",
["settings.favorites.empty"] = "No favorites yet. Right-click or long-press a control to pin it.",
["settings.keybinds"] = "Keybind manager",
["settings.keybinds.empty"] = "No keybind controls in this hub.",
["settings.open"] = "Open",
["settings.removeFavorite"] = "Remove from Favorites",
["settings.save"] = "Save",
["settings.load"] = "Load",
["settings.set"] = "Set",
["settings.duplicate"] = "Duplicate",
["settings.rename"] = "Rename",
["settings.delete"] = "Delete",
["settings.export"] = "Export",
["settings.import"] = "Import",
["settings.reset"] = "Reset",
["settings.saved"] = "Profile saved",
["settings.autoloadSet"] = "Auto-load updated",
["settings.copied"] = "Copied to clipboard",
["settings.resetDone"] = "Theme reset",
})
locale:Register("ru", {
["search.placeholder"] = "Поиск функций или > для команд",
["common.cancel"] = "Отмена",
["common.confirm"] = "Подтвердить",
["settings.title"] = "Настройки",
["settings.description"] = "Интерфейс, профили и доступность",
["nav.system"] = "Система",
["settings.appearance"] = "Внешний вид",
["settings.appearanceDesc"] = "Тема, масштаб, плотность и язык",
["settings.theme"] = "Тема",
["settings.accent"] = "Цвет акцента",
["settings.scale"] = "Масштаб UI",
["settings.density"] = "Плотность",
["settings.language"] = "Язык",
["settings.reducedMotion"] = "Меньше анимаций",
["settings.highContrast"] = "Высокий контраст",
["settings.keyboardNavigation"] = "Навигация клавиатурой / геймпадом",
["settings.uiSounds"] = "Звуки интерфейса",
["settings.soundVolume"] = "Громкость интерфейса",
["settings.themeEditor"] = "Редактор темы",
["settings.themeEditorDesc"] = "Изменение основных цветов интерфейса",
["settings.window"] = "Окно",
["settings.lockWindow"] = "Заблокировать окно",
["settings.rememberGeometry"] = "Запоминать размер и позицию",
["settings.resetLayout"] = "Сбросить расположение",
["settings.resetAll"] = "Сбросить все функции",
["settings.configs"] = "Профили",
["settings.config.name"] = "Имя профиля",
["settings.config.profile"] = "Выбранный профиль",
["settings.config.disabled"] = "Укажите ConfigFolder, чтобы включить сохранение профилей.",
["settings.favorites"] = "Избранное",
["settings.favorites.empty"] = "Избранного пока нет.",
["settings.keybinds"] = "Горячие клавиши",
["settings.keybinds.empty"] = "В хабе нет горячих клавиш.",
["settings.open"] = "Открыть",
["settings.save"] = "Сохранить",
["settings.load"] = "Загрузить",
["settings.set"] = "Назначить",
["settings.duplicate"] = "Копировать",
["settings.rename"] = "Переименовать",
["settings.delete"] = "Удалить",
["settings.export"] = "Экспорт",
["settings.import"] = "Импорт",
["settings.reset"] = "Сбросить",
["settings.copied"] = "Скопировано",
["settings.saved"] = "Профиль сохранён",
})
locale:Register("es", {
["search.placeholder"] = "Buscar controles o usar > para comandos",
["common.cancel"] = "Cancelar",
["common.confirm"] = "Confirmar",
["settings.title"] = "Ajustes",
["settings.description"] = "Interfaz, perfiles y accesibilidad",
["nav.system"] = "Sistema",
["settings.appearance"] = "Apariencia",
["settings.theme"] = "Tema",
["settings.accent"] = "Color de acento",
["settings.scale"] = "Escala de UI",
["settings.density"] = "Densidad",
["settings.language"] = "Idioma",
["settings.reducedMotion"] = "Movimiento reducido",
["settings.highContrast"] = "Alto contraste",
["settings.keyboardNavigation"] = "Navegación con teclado / mando",
["settings.uiSounds"] = "Sonidos de interfaz",
["settings.soundVolume"] = "Volumen de interfaz",
["settings.window"] = "Ventana",
["settings.configs"] = "Perfiles",
["settings.favorites"] = "Favoritos",
["settings.keybinds"] = "Atajos",
["settings.open"] = "Abrir",
["settings.save"] = "Guardar",
["settings.load"] = "Cargar",
["settings.reset"] = "Restablecer",
})
local window = Window.new({
Id = id,
Janitor = janitor,
Theme = theme,
Tokens = tokens,
Device = device,
Layers = layers,
Fonts = Typography.Prepare(Tokens.Fonts),
State = state,
Registry = registry,
Input = input,
Motion = motion,
Locale = locale,
}, options)
window.Version = BobloUI.Version
window.ApiLevel = BobloUI.ApiLevel
window.Singleton = singleton
window.CustomControls = BobloUI.CustomControls
window.State = state
window.Registry = registry
window.Input = input
window.Motion = motion
window.Locale = locale
if options.Font then
window:SetFont(options.Font)
end
if options.Animations then
window:SetAnimations(options.Animations)
end
local favorites = Favorites.new(registry)
janitor:Add(favorites)
window.Favorites = favorites
local search = Search.new(window)
janitor:Add(search)
window.Search = search
local commands = Commands.new(window)
janitor:Add(commands)
window.Commands = commands
local notify = Notify.new(window, options.NotificationPosition)
janitor:Add(notify)
window.Notify = notify
local dialog = Dialog.new(window)
janitor:Add(dialog)
window.Dialog = dialog
local config = nil
if options.ConfigFolder then
config = Config.new(window, options.ConfigFolder)
janitor:Add(config)
window.Config = config
end
local interactions = Interactions.new(window)
janitor:Add(interactions)
window.Interactions = interactions
local palette = Palette.new(window, search, commands)
janitor:Add(palette)
window.Palette = palette
local sound = Sound.new(window, options)
janitor:Add(sound)
window.Sound = sound
local navigation = Navigation.new(window, options.KeyboardNavigation ~= false)
janitor:Add(navigation)
window.Navigation = navigation
local loading = Loading.new(window)
janitor:Add(loading)
window.Loading = loading
local hud = HUD.new(window)
janitor:Add(hud)
window.HUD = hud
local cursor = Cursor.new(window)
janitor:Add(cursor)
window.Cursor = cursor
local overlays = Overlays.new(window)
janitor:Add(overlays)
window.Overlays = overlays
local themeManager = ThemeManager.new(window, options.ThemeFolder or options.ConfigFolder or id)
janitor:Add(themeManager)
window.ThemeManager = themeManager
if
requestedTheme
and requestedTheme ~= "Dark"
and requestedTheme ~= "Light"
and requestedTheme ~= "Midnight"
and requestedTheme ~= "OLED"
then
local loaded, loadError = themeManager:Load(requestedTheme)
if not loaded then
warn(`[BobloUI] custom theme "{requestedTheme}" could not be loaded: {loadError}`)
end
elseif requestedTheme == nil and options.AutoLoadTheme ~= false and themeManager:GetDefault() then
themeManager:LoadDefault()
end
local settings = nil
if options.Settings ~= false then
settings = Settings.new(window, options)
janitor:Add(settings)
window.Settings = settings
end
function window:OpenSettings()
if settings then
settings:Open()
end
return self
end
local unloaded = false
function window:SetTheme(name)
theme:Set(normalizeBundledTheme(name, theme))
return self
end
function window:SetAccent(colour)
theme:SetAccent(colour)
return self
end
function window:SetThemeToken(token, value)
theme:SetToken(token, value)
return self
end
function window:SetHighContrast(enabled)
theme:SetHighContrast(enabled)
return self
end
function window:RegisterTheme(name, palette)
theme:Register(name, palette)
return self
end
function window:SaveCustomTheme(name, palette)
return themeManager:SaveCustomTheme(name, palette)
end
function window:DeleteCustomTheme(name)
return themeManager:DeleteCustomTheme(name)
end
function window:ReloadCustomThemes()
return themeManager:ReloadCustomThemes()
end
function window:SetThemeFolder(folder)
return themeManager:SetFolder(folder)
end
function window:ListCustomThemes()
return themeManager:ListCustomThemes()
end
function window:LoadCustomTheme(name)
return themeManager:Load(name)
end
function window:SetDefaultTheme(name)
return themeManager:SetDefault(name)
end
function window:GetDefaultTheme()
return themeManager:GetDefault()
end
function window:LoadDefaultTheme()
return themeManager:LoadDefault()
end
function window:SetDensity(density)
tokens:SetDensity(density)
return self
end
function window:SetScale(scale)
local root = self:GetInstance()
local uiScale = root:FindFirstChildOfClass("UIScale")
if not uiScale then
uiScale = Instance.new("UIScale")
uiScale.Parent = root
end
self._scale = math.clamp(scale, 0.5, 2)
uiScale.Scale = self._scale
if self._applyGeometry then
self:_applyGeometry()
end
if self._scheduleSectionLayouts then
self:_scheduleSectionLayouts()
end
return self
end
function window:GetScale()
return self._scale or 1
end
function window:ExportTheme(copy)
local raw = HttpService:JSONEncode(theme:Export())
if copy then
Env.SetClipboard(raw)
end
return raw
end
function window:ImportTheme(raw)
local data = raw
if type(raw) == "string" then
local ok, res = pcall(HttpService.JSONDecode, HttpService, raw)
if not ok then
return false, res
end
data = res
end
if type(data) == "table" and data.Theme then
data = table.clone(data)
data.Theme = normalizeBundledTheme(data.Theme, theme)
end
return theme:Import(data)
end
function window:SetLocale(name)
locale:Set(name)
for _, tab in self._tabs do
if tab._refreshLocale then
tab:_refreshLocale()
end
end
for _, entry in registry:Entries() do
if entry.Handle and entry.Handle._refreshText then
entry.Handle:_refreshText()
end
end
if self._refreshFooterText then
self:_refreshFooterText()
end
search:Reindex()
return self
end
function window:SetReducedMotion(reduced)
motion:SetEnabled(not reduced)
return self
end
function window:SetKeyboardNavigation(enabled)
navigation:SetEnabled(enabled)
return self
end
function window:SetUISounds(enabled)
sound:SetEnabled(enabled)
return self
end
function window:SetSoundVolume(volume)
sound:SetVolume(volume)
return self
end
function window:RegisterSound(name, spec)
sound:Register(name, spec)
return self
end
function window:PlaySound(name, override)
return sound:Play(name, override)
end
function window:ShowLoading(options)
return loading:Show(options)
end
function window:HideLoading()
loading:Hide()
return self
end
function window:SetWatermark(spec)
hud:SetWatermark(spec)
return self
end
function window:SetKeybindHUD(enabled)
hud:SetKeybindHUD(enabled)
return self
end
function window:SetCustomCursor(enabled, options)
cursor:SetEnabled(enabled, options)
return self
end
function window:SetNotificationPosition(position)
notify:SetPosition(position)
return self
end
function window:AddDraggableLabel(...)
return overlays:AddLabel(...)
end
function window:AddDraggableButton(...)
return overlays:AddButton(...)
end
function window:AddDraggableMenu(...)
return overlays:AddMenu(...)
end
function window:AddDialog(id, dialogOptions)
if type(id) == "table" then
dialogOptions = id
else
dialogOptions = table.clone(dialogOptions or {})
dialogOptions.Id = id
end
return dialog:Custom(dialogOptions)
end
function window:OpenSearch(query)
palette:Open(query or "", "search")
return self
end
function window:OpenCommands()
palette:Open("> ", "commands")
return self
end
function window:Build(schema)
return Build.Run(self, schema)
end
function window:OnUnload(fn)
return self.Unloading:Connect(fn)
end
function window:IsUnloaded()
return unloaded
end
commands:Register({
Id = "ui.toggle",
Title = "Toggle UI",
Keywords = { "show", "hide" },
Callback = function()
window:Toggle()
end,
})
commands:Register({
Id = "ui.theme",
Title = "Toggle light/dark theme",
Keywords = { "theme", "dark", "light" },
Callback = function()
local target = theme:Counterpart()
if target and target ~= theme:Current() then
window:SetTheme(target)
end
end,
})
commands:Register({
Id = "ui.settings",
Title = "Open settings",
Keywords = { "settings", "preferences", "config" },
Callback = function()
window:OpenSettings()
end,
})
commands:Register({
Id = "ui.reset",
Title = "Reset UI layout",
Keywords = { "reset", "layout", "window" },
Callback = function()
window:ResetGeometry()
end,
})
commands:Register({
Id = "ui.unload",
Title = "Unload UI",
Keywords = { "close", "destroy" },
Callback = function()
window:Unload()
end,
})
local toggleKey = options.ToggleUIKeybind
if toggleKey == nil then
toggleKey = options.ToggleKey
end
if toggleKey == nil then
toggleKey = Enum.KeyCode.RightShift
end
if type(toggleKey) == "string" then
local wanted = string.lower(toggleKey)
local resolved = nil
for _, candidate in Enum.KeyCode:GetEnumItems() do
if string.lower(candidate.Name) == wanted then
resolved = candidate
break
end
end
if not resolved then
error(`[BobloUI] ToggleUIKeybind/ToggleKey "{toggleKey}" is not a valid Enum.KeyCode.`, 2)
end
toggleKey = resolved
end
if toggleKey ~= false then
if typeof(toggleKey) ~= "EnumItem" or toggleKey.EnumType ~= Enum.KeyCode then
error("[BobloUI] ToggleUIKeybind/ToggleKey must be a string, Enum.KeyCode, or false.", 2)
end
janitor:Add(input:BindKey("__window_toggle", toggleKey, "Toggle", function()
if not unloaded then
window:Toggle()
end
end))
end
if options.Scale then
window:SetScale(options.Scale)
end
if options.Watermark then
window:SetWatermark(options.Watermark)
end
if options.KeybindHUD then
window:SetKeybindHUD(true)
end
if options.CustomCursor then
window:SetCustomCursor(true, type(options.CustomCursor) == "table" and options.CustomCursor or nil)
end
if options.OnUnload then
window:OnUnload(options.OnUnload)
end
if singleton then
globalRegistry().Instances[id] = window
end
local baseDestroy = Window.Destroy
function window:Unload()
if unloaded then
return
end
unloaded = true
self.Unloading:Fire()
if config and config:GetAutoLoad() then
pcall(function()
config:Save(config:GetAutoLoad())
end)
end
layers:DismissAll()
baseDestroy(self)
janitor:Destroy()
local r = globalRegistry()
if r.Instances[id] == self then
r.Instances[id] = nil
end
end
if config and options.AutoLoad then
local ok, err = config:LoadAuto()
if not ok and err ~= "no autoload" then
warn(`[BobloUI] autoload failed: {err}`)
end
end
return window
end
BobloUI.CustomControls = {}
function BobloUI:RegisterControl(name, factory)
if type(name) ~= "string" or type(factory) ~= "function" then
error("[BobloUI] RegisterControl(name,factory) expects string/function.", 2)
end
self.CustomControls[name] = factory
return self
end
function BobloUI:GetWindow(id)
return globalRegistry().Instances[id]
end
function BobloUI:ListWindows()
local ids = Util.keys(globalRegistry().Instances)
table.sort(ids)
return ids
end
function BobloUI:SweepOrphans(id)
return Layer.SweepOrphans(id)
end
return BobloUI
end

__modules["kernel/Device"] = function()
local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")
local Signal = __require("runtime/Signal")
local Janitor = __require("runtime/Janitor")
local Device = {}
Device.__index = Device
Device.Breakpoints = {
Drawer = 700,
Rail = 1100,
}
local DEBOUNCE = 0.1
local function layoutFor(width: number): string
if width < Device.Breakpoints.Drawer then
return "Drawer"
elseif width < Device.Breakpoints.Rail then
return "Rail"
end
return "Wide"
end
local function classFor(width: number): string
local touch = UserInputService.TouchEnabled
local keyboard = UserInputService.KeyboardEnabled
if touch and not keyboard then
return if width < Device.Breakpoints.Drawer then "Phone" else "Tablet"
end
return "Desktop"
end
function Device.new()
local self = setmetatable({
Changed = Signal.new("Device.Changed"),
Viewport = Vector2.new(1280, 720),
Layout = "Wide",
Class = "Desktop",
Orientation = "Landscape",
IsTouch = UserInputService.TouchEnabled,
Insets = { Top = 0, Right = 0, Bottom = 0, Left = 0 },
KeyboardHeight = 0,
_janitor = Janitor.new("Device"),
_pending = nil,
}, Device)
self:_recompute(true)
self:_connect()
return self
end
function Device:_camera(): Camera?
return workspace.CurrentCamera
end
function Device:_readInsets()
local top, bottom = 0, 0
local left, right = 0, 0
local ok, topLeft, bottomRight = pcall(function()
return GuiService:GetGuiInset()
end)
if ok and topLeft then
top = topLeft.Y
left = topLeft.X
if bottomRight then
bottom = bottomRight.Y
right = bottomRight.X
end
end
local okTopbar, topbar = pcall(function()
return GuiService.TopbarInset
end)
if okTopbar and typeof(topbar) == "Rect" then
top = math.max(top, topbar.Min.Y)
end
return { Top = top, Right = right, Bottom = bottom, Left = left }
end
function Device:_recompute(silent: boolean?)
local camera = self:_camera()
local viewport = camera and camera.ViewportSize or self.Viewport
if viewport.X <= 0 or viewport.Y <= 0 then
return
end
local changed = {}
local function set(key, value)
if self[key] ~= value then
self[key] = value
changed[key] = true
end
end
set("Viewport", viewport)
set("Layout", layoutFor(viewport.X))
set("Class", classFor(viewport.X))
set("Orientation", if viewport.Y > viewport.X then "Portrait" else "Landscape")
set("IsTouch", UserInputService.TouchEnabled)
local insets = self:_readInsets()
local current = self.Insets
if
insets.Top ~= current.Top
or insets.Bottom ~= current.Bottom
or insets.Left ~= current.Left
or insets.Right ~= current.Right
then
self.Insets = insets
changed.Insets = true
end
local keyboardHeight = 0
if UserInputService.OnScreenKeyboardVisible then
keyboardHeight = UserInputService.OnScreenKeyboardSize.Y
end
set("KeyboardHeight", keyboardHeight)
if silent then
return
end
if next(changed) then
self.Changed:Fire(self, changed)
end
end
function Device:_schedule()
if self._pending then
return
end
self._pending = task.delay(DEBOUNCE, function()
self._pending = nil
self:_recompute()
end)
self._janitor:Add(self._pending, nil, "pendingRecompute")
end
function Device:_connect()
local janitor = self._janitor
local function watchCamera(camera: Camera?)
janitor:Remove("cameraViewport")
if not camera then
return
end
janitor:Add(
camera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
self:_schedule()
end),
nil,
"cameraViewport"
)
end
watchCamera(self:_camera())
janitor:Add(workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
watchCamera(self:_camera())
self:_schedule()
end))
janitor:Add(GuiService:GetPropertyChangedSignal("TopbarInset"):Connect(function()
self:_schedule()
end))
janitor:Add(UserInputService:GetPropertyChangedSignal("OnScreenKeyboardVisible"):Connect(function()
self:_recompute()
end))
janitor:Add(UserInputService:GetPropertyChangedSignal("OnScreenKeyboardSize"):Connect(function()
self:_recompute()
end))
end
function Device:SafeArea(): (Vector2, Vector2)
local insets = self.Insets
local position = Vector2.new(insets.Left, insets.Top)
local size = Vector2.new(
math.max(0, self.Viewport.X - insets.Left - insets.Right),
math.max(0, self.Viewport.Y - insets.Top - insets.Bottom)
)
return position, size
end
function Device:Destroy()
self._janitor:Destroy()
self.Changed:Destroy()
end
return Device
end

__modules["kernel/Input"] = function()
local UserInputService = game:GetService("UserInputService")
local Signal = __require("runtime/Signal")
local Janitor = __require("runtime/Janitor")
local Input = {}
Input.__index = Input
local function isPointerStart(i)
return i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch
end
local function isPointerMove(i)
return i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch
end
local function matchesCapturedPointer(capture, input, moving)
local captured = capture and capture.Input
if not captured then
return false
end
if captured.UserInputType == Enum.UserInputType.Touch then
return input == captured
end
if captured.UserInputType == Enum.UserInputType.MouseButton1 then
return input.UserInputType
== (if moving then Enum.UserInputType.MouseMovement else Enum.UserInputType.MouseButton1)
end
return false
end
local function eventKey(i)
return if i.KeyCode ~= Enum.KeyCode.Unknown then i.KeyCode else i.UserInputType
end
local MODIFIER_KEYS = {
Ctrl = { Enum.KeyCode.LeftControl, Enum.KeyCode.RightControl },
Shift = { Enum.KeyCode.LeftShift, Enum.KeyCode.RightShift },
Alt = { Enum.KeyCode.LeftAlt, Enum.KeyCode.RightAlt },
Meta = { Enum.KeyCode.LeftMeta, Enum.KeyCode.RightMeta },
}
function Input.new()
local self = setmetatable({
Began = Signal.new("Input.Began"),
Changed = Signal.new("Input.Changed"),
Ended = Signal.new("Input.Ended"),
_janitor = Janitor.new("Input"),
_capture = nil,
_keybinds = {},
_nextCapture = nil,
}, Input)
self._janitor:Add(UserInputService.InputBegan:Connect(function(i, p)
self:_began(i, p)
end))
self._janitor:Add(UserInputService.InputChanged:Connect(function(i, p)
self:_changed(i, p)
end))
self._janitor:Add(UserInputService.InputEnded:Connect(function(i, p)
self:_ended(i, p)
end))
return self
end
function Input:_began(i, processed)
if self._nextCapture then
local capture = self._nextCapture
local key = if i.KeyCode ~= Enum.KeyCode.Unknown
then i.KeyCode
elseif i.UserInputType ~= Enum.UserInputType.MouseMovement then i.UserInputType
else nil
if key then
self._nextCapture = nil
capture.Callback(key)
return
end
end
local typing = UserInputService:GetFocusedTextBox() ~= nil
local keyboard = i.KeyCode ~= Enum.KeyCode.Unknown
if not typing and (not processed or keyboard) then
local key = eventKey(i)
local list = self._keybinds[key]
if list then
for _, h in table.clone(list) do
if h.Enabled then
h:_press()
end
end
end
end
self.Began:Fire(i, processed)
end
function Input:_changed(i, processed)
if self._capture and isPointerMove(i) and matchesCapturedPointer(self._capture, i, true) then
local c = self._capture
if c.Changed then
c.Changed(i)
end
end
self.Changed:Fire(i, processed)
end
function Input:_ended(i, processed)
if self._capture and matchesCapturedPointer(self._capture, i, false) then
local c = self._capture
self._capture = nil
if c.Ended then
c.Ended(i)
end
end
local key = eventKey(i)
local list = self._keybinds[key]
if list then
for _, h in table.clone(list) do
if h.Enabled then
h:_release()
end
end
end
self.Ended:Fire(i, processed)
end
function Input:CapturePointer(owner, input, onChanged, onEnded)
if not isPointerStart(input) then
return false
end
if self._capture and self._capture.Ended then
pcall(self._capture.Ended, input, true)
end
self._capture = { Owner = owner, Input = input, Changed = onChanged, Ended = onEnded }
return true
end
function Input:CancelCapture(owner)
if self._capture and (not owner or self._capture.Owner == owner) then
local c = self._capture
self._capture = nil
if c.Ended then
c.Ended(nil, true)
end
end
end
function Input:AttachDrag(gui, onDelta, enabledFn)
local janitor = Janitor.new("Input.Drag")
local startPos
janitor:Add(gui.InputBegan:Connect(function(i)
if not isPointerStart(i) then
return
end
if enabledFn and not enabledFn() then
return
end
startPos = i.Position
self:CapturePointer(gui, i, function(move)
onDelta(move.Position - startPos, move)
end, function()
startPos = nil
end)
end))
return janitor
end
function Input:IsKeyDown(key)
if typeof(key) ~= "EnumItem" then
return false
end
if key.EnumType == Enum.KeyCode then
return UserInputService:IsKeyDown(key)
end
local ok, result = pcall(UserInputService.IsMouseButtonPressed, UserInputService, key)
return ok and result == true
end
function Input:CaptureNextKey(callback, onCancel)
if type(callback) ~= "function" then
error("[BobloUI] CaptureNextKey expects a callback.", 2)
end
if self._nextCapture then
local previous = self._nextCapture
self._nextCapture = nil
if previous.OnCancel then
pcall(previous.OnCancel)
end
end
local capture = { Callback = callback, OnCancel = onCancel }
self._nextCapture = capture
local alive = true
return function()
if not alive then
return
end
alive = false
if self._nextCapture == capture then
self._nextCapture = nil
if capture.OnCancel then
pcall(capture.OnCancel)
end
end
end
end
function Input:_modifierDown(name)
local keys = MODIFIER_KEYS[name]
if not keys then
return false
end
for _, key in keys do
if UserInputService:IsKeyDown(key) then
return true
end
end
return false
end
function Input:_modifiersMatch(required, exact)
local wanted = {}
for _, name in required or {} do
wanted[name] = true
if not self:_modifierDown(name) then
return false
end
end
if exact then
for name in MODIFIER_KEYS do
if not wanted[name] and self:_modifierDown(name) then
return false
end
end
end
return true
end
function Input:BindKey(id, key, mode, callback, options)
mode = mode or "Toggle"
options = options or {}
local handle = {
Id = id,
Key = key,
Mode = mode,
Callback = callback,
Enabled = true,
Active = mode == "Always",
_toggle = false,
_input = self,
Modifiers = options.Modifiers or {},
ExactModifiers = options.ExactModifiers == true,
ModeHandler = options.ModeHandler,
}
function handle:_press(force)
if not force and not self._input:_modifiersMatch(self.Modifiers, self.ExactModifiers) then
return
end
if self.Mode == "Hold" then
self.Active = true
self.Callback(true)
elseif self.Mode == "Toggle" then
self._toggle = not self._toggle
self.Active = self._toggle
self.Callback(self.Active)
elseif self.Mode == "Always" then
self.Active = true
self.Callback(true)
elseif self.ModeHandler then
local handler = self.ModeHandler
local result
if type(handler) == "function" then
result = handler("Press", self.Active, self)
elseif type(handler) == "table" and type(handler.Press) == "function" then
result = handler.Press(self.Active, self)
end
if result ~= nil then
self.Active = result == true
end
self.Callback(self.Active)
end
end
function handle:_release()
if self.Mode == "Hold" and self.Active then
self.Active = false
self.Callback(false)
elseif self.ModeHandler then
local handler = self.ModeHandler
local result
if type(handler) == "function" then
result = handler("Release", self.Active, self)
elseif type(handler) == "table" and type(handler.Release) == "function" then
result = handler.Release(self.Active, self)
end
if result ~= nil then
self.Active = result == true
self.Callback(self.Active)
end
end
end
function handle:SetActive(active, fire)
self.Active = active == true
self._toggle = self.Active
if fire ~= false then
self.Callback(self.Active)
end
return self
end
function handle:Trigger()
self:_press(true)
if self.Mode == "Hold" then
self:_release()
end
return self
end
function handle:Destroy()
local list = self._input._keybinds[self.Key]
if list then
local p = table.find(list, self)
if p then
table.remove(list, p)
end
end
end
local list = self._keybinds[key] or {}
self._keybinds[key] = list
table.insert(list, handle)
return handle
end
function Input:Destroy()
self:CancelCapture()
if self._nextCapture then
local capture = self._nextCapture
self._nextCapture = nil
if capture.OnCancel then
pcall(capture.OnCancel)
end
end
for _, list in self._keybinds do
for _, h in list do
h.Enabled = false
end
end
self._keybinds = {}
self._janitor:Destroy()
self.Began:Destroy()
self.Changed:Destroy()
self.Ended:Destroy()
end
return Input
end

__modules["kernel/Layer"] = function()
local CollectionService = game:GetService("CollectionService")
local Create = __require("runtime/Create")
local Janitor = __require("runtime/Janitor")
local Signal = __require("runtime/Signal")
local Env = __require("runtime/Env")
local Layer = {}
Layer.__index = Layer
Layer.Tag = "BobloUI"
local ORDER = {
Root = 100,
Overlay = 200,
Toast = 300,
}
function Layer.new(windowId: string, input, theme)
local self = setmetatable({
DismissedTop = Signal.new("Layer.DismissedTop"),
_janitor = Janitor.new("Layer"),
_windowId = windowId,
_theme = theme,
_stack = {},
_guis = {},
}, Layer)
local parent = Env.GetGuiParent()
for name, order in ORDER do
local gui = Create.New("ScreenGui", {
Name = `BobloUI.{name}.{windowId}`,
DisplayOrder = order,
ResetOnSpawn = false,
IgnoreGuiInset = true,
ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
AutoLocalize = false,
})
gui:SetAttribute("BobloWindowId", windowId)
CollectionService:AddTag(gui, Layer.Tag)
Env.Protect(gui)
gui.Parent = parent
self[name] = gui
self._guis[name] = gui
self._janitor:Add(gui)
end
if input then
self._janitor:Add(input.Began:Connect(function(key, processed)
if key.KeyCode == Enum.KeyCode.Escape and #self._stack > 0 then
self:DismissTop()
end
end))
end
return self
end
function Layer:Push(options)
options = options or {}
local depth = #self._stack + 1
local baseZ = depth * 10
local janitor = Janitor.new(`Layer.Push[{depth}]`)
local handle = {
Depth = depth,
_janitor = janitor,
_layer = self,
_dismissed = false,
_onDismiss = options.OnDismiss,
}
local scrimColour = options.ScrimColour or (if self._theme then self._theme:Get("Scrim") else Color3.new(0, 0, 0))
local scrimTransparency = 1
if options.Scrim then
if options.ScrimTransparency ~= nil then
scrimTransparency = math.clamp(options.ScrimTransparency, 0, 1)
elseif self._theme then
scrimTransparency = self._theme:Get("ScrimTransparency")
else
scrimTransparency = 0.5
end
end
local catcher = Create.New("TextButton", {
Name = "Catcher",
Size = UDim2.fromScale(1, 1),
BackgroundColor3 = scrimColour,
BackgroundTransparency = scrimTransparency,
BorderSizePixel = 0,
AutoButtonColor = false,
Text = "",
ZIndex = baseZ,
Parent = self.Overlay,
})
janitor:Add(catcher)
if options.Scrim and self._theme then
if options.ScrimColour == nil then
local colourBinding = self._theme:Bind(catcher, "BackgroundColor3", "Scrim")
janitor:Add(function()
self._theme:Unbind(colourBinding)
end)
end
if options.ScrimTransparency == nil then
local alphaBinding = self._theme:Bind(catcher, "BackgroundTransparency", "ScrimTransparency")
janitor:Add(function()
self._theme:Unbind(alphaBinding)
end)
end
end
janitor:Add(catcher.MouseButton1Click:Connect(function()
if not options.Modal then
handle:Dismiss()
end
end))
local container = Create.New("Frame", {
Name = "Container",
Size = UDim2.fromScale(1, 1),
BackgroundTransparency = 1,
ZIndex = baseZ + 1,
Parent = self.Overlay,
})
janitor:Add(container)
handle.Catcher = catcher
handle.Container = container
function handle:Dismiss()
if self._dismissed then
return
end
self._dismissed = true
local stack = self._layer._stack
local position = table.find(stack, self)
if position then
table.remove(stack, position)
end
if self._onDismiss then
local ok, err = pcall(self._onDismiss)
if not ok then
warn(`[BobloUI] Layer OnDismiss failed: {err}`)
end
end
self._janitor:Destroy()
end
function handle:IsOpen(): boolean
return not self._dismissed
end
table.insert(self._stack, handle)
return handle
end
function Layer:DismissTop()
local top = self._stack[#self._stack]
if top then
top:Dismiss()
self.DismissedTop:Fire(top)
end
end
function Layer:DismissAll()
for index = #self._stack, 1, -1 do
self._stack[index]:Dismiss()
end
self._stack = {}
end
function Layer:StackDepth(): number
return #self._stack
end
function Layer.SweepOrphans(windowId: string?)
local removed = 0
for _, gui in CollectionService:GetTagged(Layer.Tag) do
if not windowId or gui:GetAttribute("BobloWindowId") == windowId then
pcall(function()
gui:Destroy()
end)
removed += 1
end
end
return removed
end
function Layer:Destroy()
self:DismissAll()
self._janitor:Destroy()
self.DismissedTop:Destroy()
end
return Layer
end

__modules["kernel/Locale"] = function()
local Signal = __require("runtime/Signal")
local Locale = {}
Locale.__index = Locale
function Locale.new(initial)
return setmetatable(
{ Changed = Signal.new("Locale.Changed"), _name = initial or "en", _locales = { en = {} } },
Locale
)
end
function Locale:Register(name, dict)
self._locales[name] = table.clone(dict or {})
end
function Locale:Add(name, dict)
local target = self._locales[name] or {}
self._locales[name] = target
for k, v in dict do
target[k] = v
end
end
function Locale:Set(name)
if not self._locales[name] then
warn(`[BobloUI] locale "{name}" is not registered.`)
end
if self._name ~= name then
self._name = name
self.Changed:Fire(name)
end
end
function Locale:Get()
return self._name
end
function Locale:List()
local out = {}
for name in self._locales do
table.insert(out, name)
end
table.sort(out)
return out
end
function Locale:T(key, vars)
local dict = self._locales[self._name] or {}
local fallback = self._locales.en or {}
local text = dict[key] or fallback[key] or key
if vars then
for k, v in vars do
text = string.gsub(text, "{" .. k .. "}", tostring(v))
end
end
return text
end
function Locale:Resolve(value)
if type(value) == "string" and string.sub(value, 1, 1) == "@" then
return self:T(string.sub(value, 2))
end
return value
end
function Locale:Destroy()
self.Changed:Destroy()
self._locales = {}
end
return Locale
end

__modules["kernel/Motion"] = function()
local TweenService = game:GetService("TweenService")
local Janitor = __require("runtime/Janitor")
local Motion = {}
Motion.__index = Motion
function Motion.new()
return setmetatable({
Enabled = true,
_categories = { Window = true, Tabs = true, Controls = true },
_active = setmetatable({}, { __mode = "k" }),
_janitor = Janitor.new("Motion"),
}, Motion)
end
Motion.Presets = {
Fast = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
Normal = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
Slow = TweenInfo.new(0.28, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
}
function Motion:SetEnabled(v)
self.Enabled = v == true
return self
end
function Motion:SetCategory(category, enabled)
if self._categories[category] == nil then
error(`[BobloUI] unknown motion category "{category}".`, 2)
end
self._categories[category] = enabled ~= false
return self
end
function Motion:IsEnabled(category)
return self.Enabled and (category == nil or self._categories[category] ~= false)
end
function Motion:Cancel(instance)
local tween = self._active[instance]
if tween then
self._active[instance] = nil
pcall(function()
tween:Cancel()
end)
end
return self
end
function Motion:Tween(instance, info, props, category)
self:Cancel(instance)
if not self:IsEnabled(category or "Controls") then
for k, v in props do
instance[k] = v
end
return nil
end
if type(info) == "string" then
info = Motion.Presets[info] or Motion.Presets.Normal
end
info = info or Motion.Presets.Normal
local tween = TweenService:Create(instance, info, props)
self._active[instance] = tween
tween.Completed:Once(function()
if self._active[instance] == tween then
self._active[instance] = nil
end
end)
tween:Play()
return tween
end
function Motion:Destroy()
for _, t in self._active do
pcall(function()
t:Cancel()
end)
end
self._active = {}
self._janitor:Destroy()
end
return Motion
end

__modules["kernel/Registry"] = function()
local Signal = __require("runtime/Signal")
local Registry = {}
Registry.__index = Registry
function Registry.new()
return setmetatable({
Added = Signal.new("Registry.Added"),
Updated = Signal.new("Registry.Updated"),
Removed = Signal.new("Registry.Removed"),
_byId = {},
_entries = {},
_anon = 0,
}, Registry)
end
function Registry:AssertAvailable(id, level)
if id and self._byId[id] then
local old = self._byId[id]
error(`[BobloUI] duplicate Id "{id}". First registered at {old.Path or old.Type or "unknown"}.`, level or 2)
end
return true
end
function Registry:Add(handle, meta)
meta = meta or {}
local id = meta.Id or handle.Id
self:AssertAvailable(id, 2)
local key = id
if not key then
self._anon += 1
key = `__anon_{self._anon}`
end
local entry = {
Key = key,
Id = id,
Handle = handle,
Type = meta.Type or handle.Type,
Title = meta.Title or handle.Title or "",
Description = meta.Description or "",
Keywords = meta.Keywords or {},
Tab = meta.Tab,
Section = meta.Section,
Path = meta.Path,
Persist = meta.Persist == true,
Hidden = false,
}
self._entries[key] = entry
if id then
self._byId[id] = entry
end
handle._registryKey = key
self.Added:Fire(entry)
return entry
end
function Registry:Get(id)
local e = self._byId[id]
return e and e.Handle or nil
end
function Registry:GetEntry(id)
return self._byId[id]
end
function Registry:Has(id)
return self._byId[id] ~= nil
end
function Registry:Update(handle, fields)
local e = self._entries[handle._registryKey or handle.Id]
if not e then
return
end
for k, v in fields do
e[k] = v
end
self.Updated:Fire(e, fields)
end
function Registry:Remove(handleOrId)
local e
if type(handleOrId) == "string" then
e = self._byId[handleOrId] or self._entries[handleOrId]
else
e = self._entries[handleOrId._registryKey or handleOrId.Id]
end
if not e then
return
end
self._entries[e.Key] = nil
if e.Id then
self._byId[e.Id] = nil
end
self.Removed:Fire(e)
end
function Registry:Entries()
local out = {}
for _, e in self._entries do
table.insert(out, e)
end
return out
end
function Registry:GetPersistable()
local out = {}
for _, e in self._entries do
if e.Id and e.Persist and e.Handle and not e.Handle._destroyed then
table.insert(out, e)
end
end
return out
end
function Registry:Destroy()
self.Added:Destroy()
self.Updated:Destroy()
self.Removed:Destroy()
self._byId = {}
self._entries = {}
end
return Registry
end

__modules["kernel/Store"] = function()
local Signal = __require("runtime/Signal")
local Util = __require("runtime/Util")
local Store = {}
Store.__index = Store
local MAX_CASCADE = 64
local function equal(a, b, seen)
local kindA = typeof(a)
if kindA ~= typeof(b) then
return false
end
if type(a) == "table" and type(b) == "table" then
seen = seen or {}
local matches = seen[a]
if matches and matches[b] then
return true
end
if not matches then
matches = {}
seen[a] = matches
end
matches[b] = true
for key, value in a do
if not equal(value, b[key], seen) then
return false
end
end
for key in b do
if a[key] == nil then
return false
end
end
return true
end
if rawequal(a, b) then
return true
end
if kindA == "Color3" then
return a.R == b.R and a.G == b.G and a.B == b.B
end
if kindA == "Vector2" or kindA == "Vector3" or kindA == "UDim2" or kindA == "CFrame" then
return a == b
end
return a == b
end
local function originOwner(origin)
if type(origin) == "table" and origin.Source ~= nil then
return origin.Source
end
return origin
end
local function isCascadeError(value)
return type(value) == "table" and value.__boblouiStateCascade == true
end
local function preserveCascadeTrace(value)
if isCascadeError(value) then
return value
end
return debug.traceback(value)
end
local function appendChain(chain, id)
local nextChain = table.create(#(chain or {}) + 1)
for index, key in chain or {} do
nextChain[index] = key
end
table.insert(nextChain, id)
return nextChain
end
function Store.new()
return setmetatable({
Changed = Signal.new("State.Changed"),
_values = {},
_present = {},
_snapshots = {},
_defaults = {},
_defaultPresent = {},
_watchers = {},
_manyById = {},
_manyPending = {},
_manyOrder = {},
_manyCalled = {},
_batchDepth = 0,
_pending = {},
_pendingOrder = {},
_queue = {},
_queueHead = 1,
_draining = false,
_activeChain = nil,
_trackers = {},
_cascadeFailure = nil,
_destroyed = false,
}, Store)
end
function Store:Get(id)
for _, tracker in self._trackers do
if not tracker.Seen[id] then
tracker.Seen[id] = true
table.insert(tracker.Ordered, id)
end
end
return self._values[id]
end
function Store:Has(id)
return self._present[id] == true
end
function Store:Snapshot()
return Util.deepCopy(self._values)
end
function Store:SetDefault(id, value)
if not self._defaultPresent[id] then
self._defaults[id] = Util.deepCopy(value)
self._defaultPresent[id] = true
end
if not self._present[id] then
self._values[id] = Util.deepCopy(value)
self._snapshots[id] = Util.deepCopy(self._values[id])
self._present[id] = true
end
return self._values[id]
end
function Store:_raiseCascade(chain)
local failure = {
__boblouiStateCascade = true,
Message = `[BobloUI] State cascade exceeded {MAX_CASCADE} updates: {table.concat(chain, " -> ")}. Check recursive watchers.`,
}
self._cascadeFailure = failure
error(failure, 0)
end
function Store:_enqueue(change)
table.insert(self._queue, change)
end
function Store:_markMany(id, origin, chain)
local bucket = self._manyById[id]
if not bucket then
return
end
local owner = originOwner(origin)
for _, group in table.clone(bucket) do
local ownerMatches = group.Owner ~= nil and (group.Owner == origin or group.Owner == owner)
if group.Alive and not self._manyCalled[group] and not ownerMatches then
group.ChangedId = id
group.Origin = origin
group.Chain = chain
if not self._manyPending[group] then
self._manyPending[group] = true
table.insert(self._manyOrder, group)
end
end
end
end
function Store:_dispatch(change)
local id = change.id
self._activeChain = change.chain
local bucket = self._watchers[id]
if bucket then
local copy = table.clone(bucket)
local owner = originOwner(change.origin)
for _, watcher in copy do
local ownerMatches = watcher.Owner ~= nil and (watcher.Owner == change.origin or watcher.Owner == owner)
if table.find(bucket, watcher) and not ownerMatches then
local ok, err =
xpcall(watcher.Fn, preserveCascadeTrace, change.newValue, change.oldValue, id, change.origin)
if not ok then
if isCascadeError(err) then
error(err, 0)
end
warn(`[BobloUI] State watcher "{id}" failed:\n{err}`)
end
if self._cascadeFailure then
error(self._cascadeFailure, 0)
end
end
end
end
self:_markMany(id, change.origin, change.chain)
self.Changed:Fire(id, change.newValue, change.oldValue, change.origin)
if self._cascadeFailure then
error(self._cascadeFailure, 0)
end
self._activeChain = nil
end
function Store:_flushMany()
local groups = self._manyOrder
self._manyOrder = {}
for _, group in groups do
self._manyPending[group] = nil
if group.Alive and not self._manyCalled[group] then
self._manyCalled[group] = true
local snapshot = {}
for _, id in group.Ids do
snapshot[id] = self:Get(id)
end
self._activeChain = group.Chain
local ok, err = xpcall(group.Fn, preserveCascadeTrace, snapshot, group.ChangedId, group.Origin)
self._activeChain = nil
if not ok then
if isCascadeError(err) then
error(err, 0)
end
warn(`[BobloUI] State WatchMany failed:\n{err}`)
end
if self._cascadeFailure then
error(self._cascadeFailure, 0)
end
end
end
end
function Store:_drain()
if self._draining then
return
end
self._draining = true
self._manyCalled = {}
self._cascadeFailure = nil
local ok, err = xpcall(function()
while true do
while self._queueHead <= #self._queue do
local change = self._queue[self._queueHead]
self._queueHead += 1
self:_dispatch(change)
end
if #self._manyOrder == 0 then
break
end
self:_flushMany()
end
end, preserveCascadeTrace)
self._draining = false
self._activeChain = nil
self._queue = {}
self._queueHead = 1
self._manyPending = {}
self._manyOrder = {}
self._manyCalled = {}
self._cascadeFailure = nil
if not ok then
if isCascadeError(err) then
error(err.Message, 2)
end
error(err, 2)
end
end
function Store:Set(id, value, origin)
if self._destroyed then
error("[BobloUI] State store is destroyed.", 2)
end
if type(id) ~= "string" or id == "" then
error("[BobloUI] State:Set requires a non-empty string id.", 2)
end
local chain = appendChain(self._activeChain, id)
if #chain > MAX_CASCADE then
self:_raiseCascade(chain)
end
local oldValue = if self._present[id] then self._snapshots[id] else nil
if self._present[id] and equal(oldValue, value) then
return false
end
local storedValue = Util.deepCopy(value)
self._values[id] = storedValue
self._snapshots[id] = Util.deepCopy(storedValue)
self._present[id] = true
local change = {
id = id,
oldValue = oldValue,
newValue = storedValue,
origin = origin,
chain = chain,
}
if self._batchDepth > 0 then
local pending = self._pending[id]
if pending then
pending.newValue = storedValue
pending.origin = origin
pending.chain = chain
else
self._pending[id] = change
table.insert(self._pendingOrder, id)
end
else
self:_enqueue(change)
self:_drain()
end
return true
end
function Store:Update(id, fn, origin)
if type(fn) ~= "function" then
error("[BobloUI] State:Update expects a function.", 2)
end
return self:Set(id, fn(self:Get(id)), origin)
end
function Store:Reset(id, origin)
if not self._defaultPresent[id] then
return false
end
return self:Set(id, Util.deepCopy(self._defaults[id]), origin)
end
function Store:Watch(id, fn, owner)
if type(fn) ~= "function" then
error("[BobloUI] State:Watch expects a function.", 2)
end
local bucket = self._watchers[id]
if not bucket then
bucket = {}
self._watchers[id] = bucket
end
local watcher = { Fn = fn, Owner = owner }
table.insert(bucket, watcher)
local alive = true
return function()
if not alive then
return
end
alive = false
local current = self._watchers[id]
if current then
local position = table.find(current, watcher)
if position then
table.remove(current, position)
end
if #current == 0 then
self._watchers[id] = nil
end
end
end
end
function Store:WatchMany(ids, fn, owner)
if type(ids) ~= "table" or type(fn) ~= "function" then
error("[BobloUI] State:WatchMany expects an id array and a function.", 2)
end
local unique = {}
local ordered = {}
for _, id in ids do
if type(id) ~= "string" or id == "" then
error("[BobloUI] State:WatchMany ids must be non-empty strings.", 2)
end
if not unique[id] then
unique[id] = true
table.insert(ordered, id)
end
end
local group = { Ids = ordered, Fn = fn, Owner = owner, Alive = true }
for _, id in ordered do
local bucket = self._manyById[id]
if not bucket then
bucket = {}
self._manyById[id] = bucket
end
table.insert(bucket, group)
end
return function()
if not group.Alive then
return
end
group.Alive = false
self._manyPending[group] = nil
for _, id in ordered do
local bucket = self._manyById[id]
if bucket then
local position = table.find(bucket, group)
if position then
table.remove(bucket, position)
end
if #bucket == 0 then
self._manyById[id] = nil
end
end
end
end
end
function Store:_flushBatch()
local pending = self._pending
local order = self._pendingOrder
self._pending = {}
self._pendingOrder = {}
for _, id in order do
local change = pending[id]
if change and not equal(change.oldValue, change.newValue) then
self:_enqueue(change)
end
end
self:_drain()
end
function Store:Batch(fn)
if type(fn) ~= "function" then
error("[BobloUI] State:Batch expects a function.", 2)
end
self._batchDepth += 1
local ok, result = xpcall(fn, preserveCascadeTrace)
self._batchDepth -= 1
if not ok and isCascadeError(result) then
if self._batchDepth == 0 then
self._pending = {}
self._pendingOrder = {}
end
error(result.Message, 2)
end
if self._batchDepth == 0 then
self:_flushBatch()
end
if not ok then
error(result, 2)
end
return result
end
function Store:Track(predicate)
if type(predicate) ~= "function" then
error("[BobloUI] State:Track expects a function.", 2)
end
local tracker = { Seen = {}, Ordered = {} }
table.insert(self._trackers, tracker)
local ok, result = xpcall(predicate, preserveCascadeTrace, self)
table.remove(self._trackers)
if not ok then
if isCascadeError(result) then
error(result.Message, 2)
end
error(`[BobloUI] dependency predicate failed:\n{result}`, 2)
end
return tracker.Ordered, result
end
function Store:Destroy()
if self._destroyed then
return
end
self._destroyed = true
self.Changed:Destroy()
self._values = {}
self._present = {}
self._snapshots = {}
self._defaults = {}
self._defaultPresent = {}
self._watchers = {}
self._manyById = {}
self._manyPending = {}
self._manyOrder = {}
self._pending = {}
self._pendingOrder = {}
self._queue = {}
self._trackers = {}
end
return Store
end

__modules["kernel/Theme"] = function()
local Signal = __require("runtime/Signal")
local Util = __require("runtime/Util")
local Theme = {}
Theme.__index = Theme
function Theme.new(options)
options = options or {}
local self = setmetatable({
Changed = Signal.new("Theme.Changed"),
_palettes = {},
_meta = {},
_recent = {},
_name = nil,
_base = nil,
_resolved = nil,
_accent = options.Accent,
_overrides = {},
_highContrast = false,
_bindings = {},
_free = {},
_dropped = 0,
}, Theme)
if options.Palettes then
for name, palette in options.Palettes do
self:Register(name, palette)
end
end
return self
end
function Theme:Register(name: string, palette)
palette = table.clone(palette)
if palette.ScrimTransparency == nil then
palette.ScrimTransparency = 0.52
end
self._meta[name] = {
Appearance = (palette.Appearance == "Dark" or palette.Appearance == "Light") and palette.Appearance or nil,
Pair = type(palette.Pair) == "string" and palette.Pair or nil,
}
palette.Appearance = nil
palette.Pair = nil
self._palettes[name] = palette
if self._name == name then
self:_resolve()
self:_apply()
end
end
function Theme:GetRegistered(name)
local palette = self._palettes[name]
return palette and table.clone(palette) or nil
end
function Theme:Unregister(name)
if name == self._name then
error("[BobloUI] cannot unregister the active theme.", 2)
end
self._palettes[name] = nil
self._meta[name] = nil
for polarity, remembered in self._recent do
if remembered == name then
self._recent[polarity] = nil
end
end
return self
end
function Theme:List(): { string }
local names = Util.keys(self._palettes)
table.sort(names)
return names
end
function Theme:Current(): string?
return self._name
end
function Theme:Polarity(name: string?): string?
local key = name or self._name
local palette = self._palettes[key]
if not palette then
return nil
end
local meta = self._meta[key]
if meta and meta.Appearance then
return meta.Appearance
end
return if Util.luminance(palette.Canvas) < 0.5 then "Dark" else "Light"
end
function Theme:Counterpart(): string?
local current = self._name
if not current then
return nil
end
local target = if self:Polarity(current) == "Dark" then "Light" else "Dark"
local meta = self._meta[current]
if meta and meta.Pair and self._palettes[meta.Pair] and self:Polarity(meta.Pair) == target then
return meta.Pair
end
local remembered = self._recent[target]
if remembered and self._palettes[remembered] and self:Polarity(remembered) == target then
return remembered
end
if self._palettes[target] and self:Polarity(target) == target then
return target
end
for _, candidate in self:List() do
if self:Polarity(candidate) == target then
return candidate
end
end
return current
end
function Theme:RecentByPolarity(): { [string]: string }
return table.clone(self._recent)
end
function Theme:RememberPolarity(polarity: string, name: string)
if polarity ~= "Dark" and polarity ~= "Light" then
return self
end
if self._palettes[name] and self:Polarity(name) == polarity then
self._recent[polarity] = name
end
return self
end
function Theme:_resolve()
local base = self._palettes[self._name]
if not base then
error(`[BobloUI] theme "{tostring(self._name)}" is not registered`, 2)
end
local palette = table.clone(base)
if self._accent ~= nil then
palette.Accent = self._accent
end
for token, value in self._overrides do
if value ~= nil then
palette[token] = value
end
end
palette.ScrimTransparency = math.clamp(tonumber(palette.ScrimTransparency) or 0.52, 0, 1)
if self._highContrast then
local dark = Util.luminance(palette.Canvas) < 0.5
if dark then
palette.Text = Color3.new(1, 1, 1)
palette.TextSecondary = Color3.fromRGB(214, 218, 225)
palette.BorderSubtle = Color3.fromRGB(58, 64, 74)
palette.Border = Color3.fromRGB(78, 85, 97)
else
palette.Text = Color3.new(0, 0, 0)
palette.TextSecondary = Color3.fromRGB(48, 54, 64)
palette.BorderSubtle = Color3.fromRGB(190, 196, 205)
palette.Border = Color3.fromRGB(160, 168, 179)
end
end
local accentChanged = self._accent ~= nil or self._overrides.Accent ~= nil
local surfaceChanged = self._overrides.Surface ~= nil or self._overrides.Background ~= nil
local function derived(name, fallback, force)
if self._overrides[name] ~= nil then
return self._overrides[name]
end
if not force and base[name] ~= nil then
return base[name]
end
return fallback
end
local mixBase = palette.Surface or palette.Background
palette.AccentHover = derived("AccentHover", Util.lighten(palette.Accent, 0.12), accentChanged)
palette.AccentPressed = derived("AccentPressed", Util.darken(palette.Accent, 0.12), accentChanged)
palette.AccentSoft = derived("AccentSoft", palette.Accent:Lerp(mixBase, 0.90), accentChanged or surfaceChanged)
palette.AccentMuted = derived("AccentMuted", palette.Accent:Lerp(mixBase, 0.72), accentChanged or surfaceChanged)
palette.AccentBorder = derived(
"AccentBorder",
palette.Accent:Lerp(palette.Border or mixBase, 0.48),
accentChanged or self._overrides.Border ~= nil or self._highContrast
)
palette.AccentGlow = derived(
"AccentGlow",
palette.Accent:Lerp(palette.Canvas or mixBase, 0.58),
accentChanged or self._overrides.Canvas ~= nil
)
palette.SurfaceSheen = derived(
"SurfaceSheen",
mixBase:Lerp(palette.Text, 0.07),
surfaceChanged or self._overrides.Text ~= nil or self._highContrast
)
palette.AccentButton = derived("AccentButton", palette.Accent:Lerp(mixBase, 0.50), accentChanged or surfaceChanged)
palette.AccentButtonHover =
derived("AccentButtonHover", palette.Accent:Lerp(mixBase, 0.40), accentChanged or surfaceChanged)
palette.AccentButtonPressed =
derived("AccentButtonPressed", palette.Accent:Lerp(mixBase, 0.58), accentChanged or surfaceChanged)
palette.ErrorHover = derived("ErrorHover", Util.lighten(palette.Error, 0.08), self._overrides.Error ~= nil)
palette.ErrorPressed = derived("ErrorPressed", Util.darken(palette.Error, 0.05), self._overrides.Error ~= nil)
local compatibilityAccentText = self._overrides.AccentText
or (if not accentChanged then base.TextOnAccent or base.AccentText else nil)
palette.TextOnAccent =
derived("TextOnAccent", compatibilityAccentText or Util.contrastText(palette.Accent), accentChanged)
palette.TextOnAccentButton =
derived("TextOnAccentButton", Util.contrastText(palette.AccentButton), accentChanged or surfaceChanged)
palette.TextOnSuccess = derived("TextOnSuccess", Util.contrastText(palette.Success), self._overrides.Success ~= nil)
palette.TextOnWarning = derived("TextOnWarning", Util.contrastText(palette.Warning), self._overrides.Warning ~= nil)
palette.TextOnError = derived("TextOnError", Util.contrastText(palette.Error), self._overrides.Error ~= nil)
palette.TextOnInfo = derived("TextOnInfo", Util.contrastText(palette.Info), self._overrides.Info ~= nil)
palette.AccentText = palette.TextOnAccent
self._base = base
self._resolved = palette
end
function Theme:Palette()
return table.clone(self._resolved)
end
function Theme:Get(token): any
if type(token) == "function" then
return token(self._resolved)
end
local value = self._resolved[token]
if value == nil then
local suggestion = Util.suggest(token, Util.keys(self._resolved))
local hint = if suggestion then ` Did you mean "{suggestion}"?` else ""
error(`[BobloUI] unknown theme token "{token}".{hint}`, 2)
end
return value
end
function Theme:Set(name: string)
if not self._palettes[name] then
local suggestion = Util.suggest(name, self:List())
local hint = if suggestion then ` Did you mean "{suggestion}"?` else ""
error(`[BobloUI] theme "{name}" is not registered.{hint}`, 2)
end
if self._name == name then
return
end
self._name = name
local polarity = self:Polarity(name)
if polarity then
self._recent[polarity] = name
end
self:_resolve()
self:_apply()
self.Changed:Fire(name)
end
function Theme:SetAccent(colour: Color3?)
self._accent = colour
self:_resolve()
self:_apply()
self.Changed:Fire(self._name)
end
function Theme:SetToken(token, value)
if self._resolved and self._resolved[token] == nil then
error(`[BobloUI] cannot override unknown theme token "{tostring(token)}".`, 2)
end
local expected = self._resolved and typeof(self._resolved[token])
if value ~= nil and typeof(value) ~= expected then
error(`[BobloUI] Theme:SetToken expects {tostring(expected)} or nil for "{tostring(token)}".`, 2)
end
if token == "ScrimTransparency" and value ~= nil then
value = math.clamp(value, 0, 1)
end
self._overrides[token] = value
self:_resolve()
self:_apply()
self.Changed:Fire(self._name)
return self
end
function Theme:GetOverrides()
return table.clone(self._overrides)
end
function Theme:ResetToken(token)
return self:SetToken(token, nil)
end
function Theme:ResetOverrides()
self._overrides = {}
self:_resolve()
self:_apply()
self.Changed:Fire(self._name)
return self
end
function Theme:SetHighContrast(enabled)
enabled = enabled == true
if self._highContrast == enabled then
return self
end
self._highContrast = enabled
self:_resolve()
self:_apply()
self.Changed:Fire(self._name)
return self
end
function Theme:IsHighContrast()
return self._highContrast
end
function Theme:Export()
local data = { Theme = self._name, HighContrast = self._highContrast, Overrides = {} }
if self._accent then
data.Accent = "#" .. self._accent:ToHex()
end
for token, value in self._overrides do
if typeof(value) == "Color3" then
data.Overrides[token] = "#" .. value:ToHex()
elseif type(value) == "number" then
data.Overrides[token] = value
end
end
return data
end
function Theme:Import(data)
if type(data) ~= "table" then
return false, "theme import expects table"
end
if data.Theme and self._palettes[data.Theme] then
self._name = data.Theme
end
self._accent = nil
if type(data.Accent) == "string" then
local ok, c = pcall(Color3.fromHex, string.gsub(data.Accent, "#", ""))
if ok then
self._accent = c
end
end
self._overrides = {}
for token, value in data.Overrides or {} do
if self._resolved[token] ~= nil and type(value) == "string" and typeof(self._resolved[token]) == "Color3" then
local ok, c = pcall(Color3.fromHex, string.gsub(value, "#", ""))
if ok then
self._overrides[token] = c
end
elseif self._resolved[token] ~= nil and type(value) == "number" and type(self._resolved[token]) == "number" then
self._overrides[token] = if token == "ScrimTransparency" then math.clamp(value, 0, 1) else value
end
end
self._highContrast = data.HighContrast == true
self:_resolve()
self:_apply()
self.Changed:Fire(self._name)
return true
end
function Theme:Bind(instance: Instance, property: string, token): number
local binding = { instance = instance, property = property, token = token }
local slot = table.remove(self._free)
if slot then
self._bindings[slot] = binding
else
table.insert(self._bindings, binding)
slot = #self._bindings
end
if self._resolved then
instance[property] = self:Get(token)
end
return slot
end
function Theme:BindMany(instance: Instance, map: { [string]: any }): { number }
local handles = {}
for property, token in map do
table.insert(handles, self:Bind(instance, property, token))
end
return handles
end
function Theme:Unbind(handle)
if type(handle) == "table" then
for _, single in handle do
self:Unbind(single)
end
return
end
if self._bindings[handle] then
self._bindings[handle] = false
table.insert(self._free, handle)
end
end
function Theme:_apply()
local bindings = self._bindings
local dropped = 0
for slot = 1, #bindings do
local binding = bindings[slot]
if binding then
local ok = pcall(function()
binding.instance[binding.property] = self:Get(binding.token)
end)
if not ok then
bindings[slot] = false
table.insert(self._free, slot)
dropped += 1
end
end
end
self._dropped += dropped
if dropped > 0 then
warn(`[BobloUI] Theme dropped {dropped} binding(s) to destroyed instances.`)
end
end
function Theme:BindingCount(): number
local n = 0
for _, binding in self._bindings do
if binding then
n += 1
end
end
return n
end
function Theme:Destroy()
self._bindings = {}
self._free = {}
self.Changed:Destroy()
end
return Theme
end

__modules["kernel/Tokens"] = function()
local Signal = __require("runtime/Signal")
local Tokens = {}
Tokens.__index = Tokens
Tokens.MinTapTarget = 42
local function enumFont(name, fallback)
for _, item in Enum.Font:GetEnumItems() do
if item.Name == name then
return item
end
end
return fallback
end
Tokens.Fonts = {
Regular = enumFont("BuilderSans", Enum.Font.Gotham),
Medium = enumFont("BuilderSansMedium", Enum.Font.GothamMedium),
Bold = enumFont("BuilderSansBold", Enum.Font.GothamBold),
Heavy = enumFont("BuilderSansExtraBold", Enum.Font.GothamBold),
}
Tokens.Profiles = {
Comfortable = {
ControlHeight = 47,
ControlPadding = 13,
ControlRadius = 8,
FieldHeight = 34,
FieldRadius = 8,
RowGap = 2,
SectionGap = 14,
ColumnGap = 14,
TwoColumnMinWidth = 586,
MinSectionWidth = 286,
ControlStackBreakpoint = 300,
ControlGridMinWidth = 600,
SectionPadding = 12,
PagePadding = 20,
HeaderHeight = 56,
SidebarWidth = 168,
RailWidth = 54,
NavItemHeight = 38,
FontCaption = 11,
FontSmall = 12,
FontBody = 14,
FontTitle = 15,
FontHeading = 18,
FontDisplay = 21,
IconSm = 14,
IconMd = 18,
CornerSm = 7,
CornerMd = 10,
CornerLg = 14,
Stroke = 1,
SliderTrack = 4,
SliderKnob = 12,
},
Compact = {
ControlHeight = 40,
ControlPadding = 10,
ControlRadius = 9,
FieldHeight = 31,
FieldRadius = 7,
RowGap = 0,
SectionGap = 10,
ColumnGap = 12,
TwoColumnMinWidth = 546,
MinSectionWidth = 267,
ControlStackBreakpoint = 282,
ControlGridMinWidth = 560,
SectionPadding = 9,
PagePadding = 18,
HeaderHeight = 50,
SidebarWidth = 158,
RailWidth = 50,
NavItemHeight = 35,
FontCaption = 10,
FontSmall = 11,
FontBody = 13,
FontTitle = 14,
FontHeading = 18,
FontDisplay = 20,
IconSm = 14,
IconMd = 18,
CornerSm = 7,
CornerMd = 10,
CornerLg = 15,
Stroke = 1,
SliderTrack = 4,
SliderKnob = 10,
},
Touch = {
ControlHeight = 48,
ControlPadding = 13,
ControlRadius = 11,
FieldHeight = 38,
FieldRadius = 9,
RowGap = 0,
SectionGap = 15,
ColumnGap = 14,
TwoColumnMinWidth = 626,
MinSectionWidth = 306,
ControlStackBreakpoint = 324,
ControlGridMinWidth = 640,
SectionPadding = 14,
PagePadding = 14,
HeaderHeight = 54,
SidebarWidth = 238,
RailWidth = 60,
NavItemHeight = 48,
FontCaption = 11,
FontSmall = 13,
FontBody = 15,
FontTitle = 16,
FontHeading = 20,
FontDisplay = 22,
IconSm = 17,
IconMd = 21,
CornerSm = 8,
CornerMd = 12,
CornerLg = 17,
Stroke = 1,
SliderTrack = 5,
SliderKnob = 16,
},
}
function Tokens.new(density: string?, deviceClass: string?, minimal: boolean?)
local self = setmetatable({
Changed = Signal.new("Tokens.Changed"),
_density = density or "Comfortable",
_deviceClass = deviceClass or "Desktop",
_minimal = minimal == true,
_values = {},
}, Tokens)
self:_recompute()
return self
end
function Tokens:_effectiveDensity()
if self._deviceClass == "Phone" and self._density == "Comfortable" then
return "Touch"
end
return self._density
end
function Tokens:_recompute()
local profile = Tokens.Profiles[self:_effectiveDensity()] or Tokens.Profiles.Comfortable
local values = table.clone(profile)
if self._deviceClass == "Phone" then
values.ControlHeight = math.max(values.ControlHeight, Tokens.MinTapTarget)
values.NavItemHeight = math.max(values.NavItemHeight, Tokens.MinTapTarget)
values.FieldHeight = math.max(values.FieldHeight, 34)
end
if self._minimal then
values.ControlHeight = math.max(44, values.ControlHeight)
values.PagePadding = 8
values.SectionGap = 8
values.RowGap = 4
values.SectionPadding = 0
values.HeaderHeight = 46
end
self._values = values
end
function Tokens:Get(key)
local value = self._values[key]
if value == nil then
error(`[BobloUI] unknown token "{key}"`, 2)
end
return value
end
function Tokens:All()
return table.clone(self._values)
end
function Tokens:GetDensity()
return self._density
end
function Tokens:SetDensity(density)
if not Tokens.Profiles[density] then
error(`[BobloUI] unknown density "{density}". Valid: Comfortable, Compact, Touch`, 2)
end
if self._density == density then
return
end
self._density = density
self:_recompute()
self.Changed:Fire(self)
end
function Tokens:SetDeviceClass(deviceClass)
if self._deviceClass == deviceClass then
return
end
self._deviceClass = deviceClass
local before = self._values
self:_recompute()
for key, value in self._values do
if before[key] ~= value then
self.Changed:Fire(self)
return
end
end
end
function Tokens:Destroy()
self.Changed:Destroy()
end
return Tokens
end

__modules["primitives/Badge"] = function()
local Create = __require("runtime/Create")
local Badge = {}
local BG = { Neutral = "SurfaceSecondary", Info = "Info", Success = "Success", Warning = "Warning", Danger = "Error" }
local FG = {
Neutral = "TextSecondary",
Info = "TextOnInfo",
Success = "TextOnSuccess",
Warning = "TextOnWarning",
Danger = "TextOnError",
}
function Badge.new(window, text, style, parent)
style = style or "Neutral"
local label = Create.New("TextLabel", {
AutomaticSize = Enum.AutomaticSize.XY,
BackgroundTransparency = 0,
Text = string.upper(text or ""),
Font = window.Fonts.Bold,
TextSize = window.Tokens:Get("FontCaption"),
Parent = parent,
})
Create.New("UIPadding", {
PaddingLeft = UDim.new(0, 7),
PaddingRight = UDim.new(0, 7),
PaddingTop = UDim.new(0, 3),
PaddingBottom = UDim.new(0, 3),
Parent = label,
})
Create.New("UICorner", { CornerRadius = UDim.new(1, 0), Parent = label })
window:_bind(label, { BackgroundColor3 = BG[style] or BG.Neutral, TextColor3 = FG[style] or FG.Neutral })
return label
end
return Badge
end

__modules["primitives/Icon"] = function()
local Create = __require("runtime/Create")
local Lucide = __require("primitives/Lucide")
local Icon = {
Registry = {},
Aliases = {
close = "x",
dashboard = "layout-dashboard",
home = "house",
player = "user",
visuals = "eye",
reset = "rotate-ccw",
shop = "shopping-cart",
game = "gamepad-2",
magic = "wand-sparkles",
},
FallbackAliases = {
accessibility = "settings",
["app-window"] = "panel",
["audio-lines"] = "controls",
blend = "palette",
["chevron-down"] = "chevron_down",
["chevron-right"] = "chevron_right",
["chevron-up"] = "chevron_up",
["circle-check"] = "check",
["circle-question-mark"] = "info",
["circle-x"] = "close",
["file-pen"] = "edit",
["folder-cog"] = "folder",
["folder-open"] = "folder",
languages = "globe",
["layout-template"] = "layout",
["list-check"] = "list",
["loader-circle"] = "progress",
["mouse-pointer-2"] = "controls",
paintbrush = "palette",
["panel-left"] = "panel",
pipette = "palette",
["rotate-ccw"] = "reset",
["rows-3"] = "list",
["settings-2"] = "settings",
["square-round-corner"] = "panel",
["sun-medium"] = "moon",
["sun-moon"] = "moon",
["swatch-book"] = "palette",
["text-cursor-input"] = "edit",
["triangle-alert"] = "info",
["volume-2"] = "controls",
x = "close",
["zoom-in"] = "plus",
},
Count = Lucide.Count,
Source = Lucide.Source,
}
local function normalizeName(name)
if type(name) ~= "string" then
return name
end
return string.gsub(string.lower(name), "[%s_]+", "-")
end
function Icon.Register(name, value)
Icon.Registry[normalizeName(name)] = value
end
function Icon.RegisterAlias(alias, name)
alias = normalizeName(alias)
name = normalizeName(name)
if type(alias) ~= "string" or type(name) ~= "string" then
error("[BobloUI] Icon.RegisterAlias expects two strings.", 2)
end
Icon.Aliases[alias] = name
return Icon
end
function Icon.SetSpritesheets(first, second)
return Lucide.SetSpritesheets(first, second)
end
function Icon.SetAtlasUrls(first, second)
return Lucide.SetAtlasUrls(first, second)
end
function Icon.GetAtlasUrls()
return Lucide.GetAtlasUrls()
end
function Icon.Prepare()
return Lucide.Prepare()
end
function Icon.Retry()
return Lucide.Retry()
end
function Icon.GetStatus()
return Lucide.GetStatus()
end
function Icon.GetSpritesheets()
return Lucide.GetSpritesheets()
end
function Icon.ResetSpritesheets()
return Lucide.ResetSpritesheets()
end
function Icon.List()
return table.clone(Lucide.Icons)
end
function Icon.Has(name)
local normalized = normalizeName(name)
if type(normalized) ~= "string" then
return false
end
if Icon.Registry[normalized] ~= nil then
return true
end
return Lucide.Has(Icon.Aliases[normalized] or normalized)
end
local function copyLayoutProps(props)
local allowed = {
Name = true,
Size = true,
Position = true,
AnchorPoint = true,
Parent = true,
LayoutOrder = true,
ZIndex = true,
Visible = true,
Rotation = true,
}
local out = { BackgroundTransparency = 1, BorderSizePixel = 0 }
for key, value in props or {} do
if allowed[key] then
out[key] = value
end
end
return out
end
local function tag(instance)
instance:SetAttribute("BobloIconPart", true)
return instance
end
local function bindPart(window, instance, token)
if instance:IsA("UIStroke") then
window:_bind(instance, { Color = token or "TextSecondary" })
elseif instance:IsA("ImageLabel") or instance:IsA("ImageButton") then
window:_bind(instance, { ImageColor3 = token or "TextSecondary" })
elseif instance:IsA("TextLabel") or instance:IsA("TextButton") then
window:_bind(instance, { TextColor3 = token or "TextSecondary" })
else
window:_bind(instance, { BackgroundColor3 = token or "TextSecondary" })
end
end
local function part(window, parent, props, token)
props = props or {}
props.BorderSizePixel = 0
props.Parent = parent
local item = tag(Create.New("Frame", props))
bindPart(window, item, token)
return item
end
local function rounded(window, parent, props, radius, token)
local item = part(window, parent, props, token)
Create.New(
"UICorner",
{ CornerRadius = UDim.new(radius == 1 and 1 or 0, radius == 1 and 0 or (radius or 2)), Parent = item }
)
return item
end
local function line(window, parent, x, y, width, height, rotation, token)
local item = rounded(window, parent, {
Size = UDim2.fromOffset(width, height),
Position = UDim2.new(0.5, x, 0.5, y),
AnchorPoint = Vector2.new(0.5, 0.5),
Rotation = rotation or 0,
}, 1, token)
return item
end
local function outline(window, parent, props, radius, token, thickness)
props = props or {}
props.BackgroundTransparency = 1
props.BorderSizePixel = 0
props.Parent = parent
local item = tag(Create.New("Frame", props))
Create.New(
"UICorner",
{ CornerRadius = UDim.new(radius == 1 and 1 or 0, radius == 1 and 0 or (radius or 2)), Parent = item }
)
local stroke = tag(Create.New("UIStroke", { Thickness = thickness or 1.3, Transparency = 0.04, Parent = item }))
bindPart(window, stroke, token)
return item
end
local function dot(window, parent, x, y, size, token)
return rounded(window, parent, {
Size = UDim2.fromOffset(size or 3, size or 3),
Position = UDim2.new(0.5, x, 0.5, y),
AnchorPoint = Vector2.new(0.5, 0.5),
}, 1, token)
end
local Draw = {}
Draw.dashboard = function(window, root)
for _, p in { { -4.5, -4.5 }, { 4.5, -4.5 }, { -4.5, 4.5 }, { 4.5, 4.5 } } do
rounded(window, root, {
Size = UDim2.fromOffset(6, 6),
Position = UDim2.new(0.5, p[1], 0.5, p[2]),
AnchorPoint = Vector2.new(0.5, 0.5),
}, 2)
end
end
Draw["layout-dashboard"] = Draw.dashboard
Draw.home = Draw.dashboard
Draw.user = function(window, root)
rounded(
window,
root,
{ Size = UDim2.fromOffset(7, 7), Position = UDim2.new(0.5, 0, 0.5, -4.5), AnchorPoint = Vector2.new(0.5, 0.5) },
1
)
rounded(
window,
root,
{ Size = UDim2.fromOffset(14, 7), Position = UDim2.new(0.5, 0, 0.5, 5), AnchorPoint = Vector2.new(0.5, 0.5) },
4
)
end
Draw.player = Draw.user
Draw.eye = function(window, root)
local ring = tag(Create.New("Frame", {
Size = UDim2.fromOffset(16, 10),
Position = UDim2.fromScale(0.5, 0.5),
AnchorPoint = Vector2.new(0.5, 0.5),
BackgroundTransparency = 1,
BorderSizePixel = 0,
Parent = root,
}))
Create.New("UICorner", { CornerRadius = UDim.new(1, 0), Parent = ring })
local stroke = tag(Create.New("UIStroke", { Thickness = 1.4, Transparency = 0.05, Parent = ring }))
bindPart(window, stroke)
rounded(
window,
root,
{ Size = UDim2.fromOffset(4.5, 4.5), Position = UDim2.fromScale(0.5, 0.5), AnchorPoint = Vector2.new(0.5, 0.5) },
1
)
end
Draw.visuals = Draw.eye
Draw.settings = function(window, root)
local ring = tag(Create.New("Frame", {
Size = UDim2.fromOffset(9, 9),
Position = UDim2.fromScale(0.5, 0.5),
AnchorPoint = Vector2.new(0.5, 0.5),
BackgroundTransparency = 1,
BorderSizePixel = 0,
Parent = root,
}))
Create.New("UICorner", { CornerRadius = UDim.new(1, 0), Parent = ring })
local stroke = tag(Create.New("UIStroke", { Thickness = 1.5, Parent = ring }))
bindPart(window, stroke)
for _, r in { 0, 45, 90, 135 } do
line(window, root, 0, 0, 16, 2, r)
end
local cover = rounded(
window,
root,
{ Size = UDim2.fromOffset(7, 7), Position = UDim2.fromScale(0.5, 0.5), AnchorPoint = Vector2.new(0.5, 0.5) },
1,
"Sidebar"
)
cover:SetAttribute("BobloIconMask", true)
local inner = rounded(
window,
root,
{ Size = UDim2.fromOffset(3, 3), Position = UDim2.fromScale(0.5, 0.5), AnchorPoint = Vector2.new(0.5, 0.5) },
1
)
end
Draw.search = function(window, root)
local ring = tag(Create.New("Frame", {
Size = UDim2.fromOffset(10, 10),
Position = UDim2.new(0.5, -2, 0.5, -2),
AnchorPoint = Vector2.new(0.5, 0.5),
BackgroundTransparency = 1,
BorderSizePixel = 0,
Parent = root,
}))
Create.New("UICorner", { CornerRadius = UDim.new(1, 0), Parent = ring })
local stroke = tag(Create.New("UIStroke", { Thickness = 1.4, Transparency = 0.04, Parent = ring }))
bindPart(window, stroke)
line(window, root, 5, 5, 6, 1.5, 45)
end
Draw.close = function(window, root)
line(window, root, 0, 0, 13, 1.6, 45)
line(window, root, 0, 0, 13, 1.6, -45)
end
Draw.menu = function(window, root)
for _, y in { -5, 0, 5 } do
line(window, root, 0, y, 15, 1.6, 0)
end
end
Draw.chevron_down = function(window, root)
line(window, root, -3, 0, 7, 1.5, 45)
line(window, root, 3, 0, 7, 1.5, -45)
end
Draw.chevron_right = function(window, root)
line(window, root, 0, -3, 7, 1.5, 45)
line(window, root, 0, 3, 7, 1.5, -45)
end
Draw.chevron_up = function(window, root)
line(window, root, -3, 0, 7, 1.5, -45)
line(window, root, 3, 0, 7, 1.5, 45)
end
Draw.check = function(window, root)
line(window, root, -3, 1, 6, 1.6, 45)
line(window, root, 3, -1, 10, 1.6, -45)
end
Draw.plus = function(window, root)
line(window, root, 0, 0, 13, 1.5, 0)
line(window, root, 0, 0, 13, 1.5, 90)
end
Draw.minus = function(window, root)
line(window, root, 0, 0, 13, 1.5, 0)
end
Draw.moon = function(window, root)
local ring = tag(Create.New("Frame", {
Size = UDim2.fromOffset(14, 14),
Position = UDim2.fromScale(0.5, 0.5),
AnchorPoint = Vector2.new(0.5, 0.5),
BackgroundTransparency = 1,
BorderSizePixel = 0,
Parent = root,
}))
Create.New("UICorner", { CornerRadius = UDim.new(1, 0), Parent = ring })
local stroke = tag(Create.New("UIStroke", { Thickness = 1.4, Transparency = 0.04, Parent = ring }))
bindPart(window, stroke)
local mask = rounded(
window,
root,
{ Size = UDim2.fromOffset(11, 11), Position = UDim2.new(0.5, 3, 0.5, -3), AnchorPoint = Vector2.new(0.5, 0.5) },
1,
"Canvas"
)
mask:SetAttribute("BobloIconMask", true)
end
Draw.palette = Draw.moon
Draw.command = function(window, root)
for _, p in { { -4, -4 }, { 4, -4 }, { -4, 4 }, { 4, 4 } } do
local ring = tag(Create.New("Frame", {
Size = UDim2.fromOffset(6, 6),
Position = UDim2.new(0.5, p[1], 0.5, p[2]),
AnchorPoint = Vector2.new(0.5, 0.5),
BackgroundTransparency = 1,
BorderSizePixel = 0,
Parent = root,
}))
Create.New("UICorner", { CornerRadius = UDim.new(1, 0), Parent = ring })
local s = tag(Create.New("UIStroke", { Thickness = 1.2, Parent = ring }))
bindPart(window, s)
end
line(window, root, 0, -4, 8, 1.2, 0)
line(window, root, 0, 4, 8, 1.2, 0)
line(window, root, -4, 0, 8, 1.2, 90)
line(window, root, 4, 0, 8, 1.2, 90)
end
Draw.star = function(window, root)
line(window, root, 0, 0, 14, 1.4, 0)
line(window, root, 0, 0, 14, 1.4, 90)
line(window, root, 0, 0, 9, 1.2, 45)
line(window, root, 0, 0, 9, 1.2, -45)
end
Draw.copy = function(window, root)
local a = tag(Create.New("Frame", {
Size = UDim2.fromOffset(10, 10),
Position = UDim2.new(0.5, -2, 0.5, 2),
AnchorPoint = Vector2.new(0.5, 0.5),
BackgroundTransparency = 1,
BorderSizePixel = 0,
Parent = root,
}))
Create.New("UICorner", { CornerRadius = UDim.new(0, 2), Parent = a })
local sa = tag(Create.New("UIStroke", { Thickness = 1.2, Parent = a }))
bindPart(window, sa)
local b = tag(Create.New("Frame", {
Size = UDim2.fromOffset(10, 10),
Position = UDim2.new(0.5, 2, 0.5, -2),
AnchorPoint = Vector2.new(0.5, 0.5),
BackgroundTransparency = 1,
BorderSizePixel = 0,
Parent = root,
}))
Create.New("UICorner", { CornerRadius = UDim.new(0, 2), Parent = b })
local sb = tag(Create.New("UIStroke", { Thickness = 1.2, Parent = b }))
bindPart(window, sb)
end
Draw.reset = function(window, root)
local ring = tag(Create.New("Frame", {
Size = UDim2.fromOffset(13, 13),
Position = UDim2.fromScale(0.5, 0.5),
AnchorPoint = Vector2.new(0.5, 0.5),
BackgroundTransparency = 1,
BorderSizePixel = 0,
Parent = root,
}))
Create.New("UICorner", { CornerRadius = UDim.new(1, 0), Parent = ring })
local st = tag(Create.New("UIStroke", { Thickness = 1.3, Transparency = 0.05, Parent = ring }))
bindPart(window, st)
local mask = rounded(
window,
root,
{ Size = UDim2.fromOffset(7, 5), Position = UDim2.new(0.5, 5, 0.5, -5), AnchorPoint = Vector2.new(0.5, 0.5) },
1,
"SurfaceRaised"
)
mask:SetAttribute("BobloIconMask", true)
line(window, root, 4, -5, 6, 1.4, 0)
line(window, root, 2, -3, 5, 1.4, 90)
end
Draw.info = function(window, root)
local ring = tag(Create.New("Frame", {
Size = UDim2.fromOffset(15, 15),
Position = UDim2.fromScale(0.5, 0.5),
AnchorPoint = Vector2.new(0.5, 0.5),
BackgroundTransparency = 1,
BorderSizePixel = 0,
Parent = root,
}))
Create.New("UICorner", { CornerRadius = UDim.new(1, 0), Parent = ring })
local s = tag(Create.New("UIStroke", { Thickness = 1.3, Parent = ring }))
bindPart(window, s)
rounded(
window,
root,
{ Size = UDim2.fromOffset(1.8, 6), Position = UDim2.new(0.5, 0, 0.5, 2), AnchorPoint = Vector2.new(0.5, 0.5) },
1
)
rounded(
window,
root,
{ Size = UDim2.fromOffset(2, 2), Position = UDim2.new(0.5, 0, 0.5, -4), AnchorPoint = Vector2.new(0.5, 0.5) },
1
)
end
Draw.lock = function(window, root)
local body = rounded(
window,
root,
{ Size = UDim2.fromOffset(12, 9), Position = UDim2.new(0.5, 0, 0.5, 3), AnchorPoint = Vector2.new(0.5, 0.5) },
2
)
local shackle = tag(Create.New("Frame", {
Size = UDim2.fromOffset(8, 8),
Position = UDim2.new(0.5, 0, 0.5, -3),
AnchorPoint = Vector2.new(0.5, 0.5),
BackgroundTransparency = 1,
BorderSizePixel = 0,
Parent = root,
}))
Create.New("UICorner", { CornerRadius = UDim.new(1, 0), Parent = shackle })
local st = tag(Create.New("UIStroke", { Thickness = 1.4, Parent = shackle }))
bindPart(window, st)
local mask = part(
window,
root,
{ Size = UDim2.fromOffset(10, 5), Position = UDim2.new(0.5, 0, 0.5, 1), AnchorPoint = Vector2.new(0.5, 0.5) },
"Canvas"
)
mask:SetAttribute("BobloIconMask", true)
end
Draw.image = function(window, root)
local frame = tag(Create.New("Frame", {
Size = UDim2.fromOffset(16, 13),
Position = UDim2.fromScale(0.5, 0.5),
AnchorPoint = Vector2.new(0.5, 0.5),
BackgroundTransparency = 1,
BorderSizePixel = 0,
Parent = root,
}))
Create.New("UICorner", { CornerRadius = UDim.new(0, 2), Parent = frame })
local st = tag(Create.New("UIStroke", { Thickness = 1.2, Parent = frame }))
bindPart(window, st)
rounded(
window,
root,
{ Size = UDim2.fromOffset(3, 3), Position = UDim2.new(0.5, 4, 0.5, -3), AnchorPoint = Vector2.new(0.5, 0.5) },
1
)
line(window, root, -3, 3, 8, 1.3, -35)
line(window, root, 3, 3, 7, 1.3, 35)
end
Draw.code = function(window, root)
line(window, root, -4, 0, 7, 1.5, -45)
line(window, root, -4, 0, 7, 1.5, 45)
line(window, root, 4, 0, 7, 1.5, 45)
line(window, root, 4, 0, 7, 1.5, -45)
end
Draw.progress = function(window, root)
local track = rounded(
window,
root,
{ Size = UDim2.fromOffset(16, 5), Position = UDim2.fromScale(0.5, 0.5), AnchorPoint = Vector2.new(0.5, 0.5) },
1,
"TextDisabled"
)
local fill = rounded(
window,
root,
{ Size = UDim2.fromOffset(9, 5), Position = UDim2.new(0.5, -3.5, 0.5, 0), AnchorPoint = Vector2.new(0.5, 0.5) },
1,
"TextSecondary"
)
end
Draw.layout = function(window, root)
outline(window, root, {
Size = UDim2.fromOffset(16, 15),
Position = UDim2.fromScale(0.5, 0.5),
AnchorPoint = Vector2.new(0.5, 0.5),
}, 2)
line(window, root, -3.5, 0, 1.3, 13, 0)
line(window, root, 3.5, -2.5, 6, 1.3, 0)
end
Draw.columns = Draw.layout
Draw.panel = Draw.layout
Draw["sliders-horizontal"] = function(window, root)
for _, item in { { -5, -3 }, { 0, 3 }, { 5, -2 } } do
line(window, root, 0, item[1], 16, 1.3, 0)
dot(window, root, item[2], item[1], 4)
end
end
Draw.sliders = Draw["sliders-horizontal"]
Draw.controls = Draw["sliders-horizontal"]
Draw["toggle-right"] = function(window, root)
outline(window, root, {
Size = UDim2.fromOffset(18, 10),
Position = UDim2.fromScale(0.5, 0.5),
AnchorPoint = Vector2.new(0.5, 0.5),
}, 1)
dot(window, root, 4, 0, 6, "Accent")
end
Draw.toggle = Draw["toggle-right"]
Draw.keyboard = function(window, root)
outline(window, root, {
Size = UDim2.fromOffset(17, 12),
Position = UDim2.fromScale(0.5, 0.5),
AnchorPoint = Vector2.new(0.5, 0.5),
}, 3)
for _, x in { -5, -1.7, 1.7, 5 } do
dot(window, root, x, -2, 1.8)
end
line(window, root, 0, 3, 9, 1.5, 0)
end
Draw.bell = function(window, root)
outline(window, root, {
Size = UDim2.fromOffset(12, 13),
Position = UDim2.new(0.5, 0, 0.5, -1),
AnchorPoint = Vector2.new(0.5, 0.5),
}, 6)
line(window, root, 0, 5.5, 15, 1.4, 0)
dot(window, root, 0, 8, 2.5)
end
Draw.notifications = Draw.bell
Draw.shield = function(window, root)
line(window, root, -5, -5, 9, 1.4, -22)
line(window, root, 5, -5, 9, 1.4, 22)
line(window, root, -4, 3, 10, 1.4, 58)
line(window, root, 4, 3, 10, 1.4, -58)
line(window, root, 0, 7, 4, 1.4, 0)
end
Draw.security = Draw.shield
Draw["shopping-cart"] = function(window, root)
line(window, root, -6, -5, 5, 1.4, 0)
line(window, root, -5, -1, 11, 1.4, 76)
line(window, root, 2, 1, 12, 1.4, 0)
line(window, root, 7, -2, 7, 1.4, 74)
dot(window, root, -1, 6, 3)
dot(window, root, 6, 6, 3)
end
Draw.shop = Draw["shopping-cart"]
Draw.cart = Draw["shopping-cart"]
Draw.gamepad = function(window, root)
outline(window, root, {
Size = UDim2.fromOffset(18, 12),
Position = UDim2.fromScale(0.5, 0.5),
AnchorPoint = Vector2.new(0.5, 0.5),
}, 6)
line(window, root, -4, 0, 6, 1.4, 0)
line(window, root, -4, 0, 6, 1.4, 90)
dot(window, root, 4, -1.5, 2.5)
dot(window, root, 6.5, 1.5, 2.5)
end
Draw.game = Draw.gamepad
Draw.users = function(window, root)
dot(window, root, -2.5, -4, 6)
dot(window, root, 5, -2.5, 4.5)
rounded(window, root, {
Size = UDim2.fromOffset(11, 6),
Position = UDim2.new(0.5, -2.5, 0.5, 4.5),
AnchorPoint = Vector2.new(0.5, 0.5),
}, 4)
rounded(window, root, {
Size = UDim2.fromOffset(7, 4),
Position = UDim2.new(0.5, 5, 0.5, 4),
AnchorPoint = Vector2.new(0.5, 0.5),
}, 3)
end
Draw.team = Draw.users
Draw.globe = function(window, root)
outline(window, root, {
Size = UDim2.fromOffset(16, 16),
Position = UDim2.fromScale(0.5, 0.5),
AnchorPoint = Vector2.new(0.5, 0.5),
}, 1)
line(window, root, 0, 0, 14, 1.2, 0)
outline(window, root, {
Size = UDim2.fromOffset(7, 16),
Position = UDim2.fromScale(0.5, 0.5),
AnchorPoint = Vector2.new(0.5, 0.5),
}, 1, nil, 1.1)
end
Draw.world = Draw.globe
Draw.database = function(window, root)
for _, y in { -5, 0, 5 } do
outline(window, root, {
Size = UDim2.fromOffset(15, 6),
Position = UDim2.new(0.5, 0, 0.5, y),
AnchorPoint = Vector2.new(0.5, 0.5),
}, 1, nil, 1.2)
end
end
Draw.storage = Draw.database
Draw.folder = function(window, root)
outline(window, root, {
Size = UDim2.fromOffset(17, 12),
Position = UDim2.new(0.5, 0, 0.5, 2),
AnchorPoint = Vector2.new(0.5, 0.5),
}, 2)
line(window, root, -4, -5.5, 7, 1.5, 0)
line(window, root, -7, -3.5, 4, 1.4, 90)
end
Draw.files = Draw.folder
Draw.save = function(window, root)
outline(window, root, {
Size = UDim2.fromOffset(15, 16),
Position = UDim2.fromScale(0.5, 0.5),
AnchorPoint = Vector2.new(0.5, 0.5),
}, 2)
outline(window, root, {
Size = UDim2.fromOffset(8, 5),
Position = UDim2.new(0.5, 0, 0.5, -5),
AnchorPoint = Vector2.new(0.5, 0.5),
}, 1, nil, 1.1)
outline(window, root, {
Size = UDim2.fromOffset(9, 6),
Position = UDim2.new(0.5, 0, 0.5, 4),
AnchorPoint = Vector2.new(0.5, 0.5),
}, 1, nil, 1.1)
end
local function drawTransfer(window, root, direction)
line(window, root, 0, direction * -2, 12, 1.5, 90)
line(window, root, -2.5, direction * 2, 7, 1.5, direction == 1 and -45 or 45)
line(window, root, 2.5, direction * 2, 7, 1.5, direction == 1 and 45 or -45)
line(window, root, 0, direction * 7, 15, 1.4, 0)
end
Draw.download = function(window, root)
drawTransfer(window, root, 1)
end
Draw.upload = function(window, root)
drawTransfer(window, root, -1)
end
Draw.trash = function(window, root)
outline(window, root, {
Size = UDim2.fromOffset(11, 13),
Position = UDim2.new(0.5, 0, 0.5, 2),
AnchorPoint = Vector2.new(0.5, 0.5),
}, 2)
line(window, root, 0, -6, 16, 1.4, 0)
line(window, root, 0, -8, 6, 1.4, 0)
line(window, root, -2, 2, 7, 1.1, 90)
line(window, root, 2, 2, 7, 1.1, 90)
end
Draw["trash-2"] = Draw.trash
Draw.delete = Draw.trash
Draw.pencil = function(window, root)
line(window, root, 0, 0, 17, 2.1, -45)
line(window, root, -6, 6, 5, 1.4, 45)
line(window, root, 6, -6, 4, 1.4, 45)
end
Draw.edit = Draw.pencil
Draw.list = function(window, root)
for _, y in { -5, 0, 5 } do
dot(window, root, -6.5, y, 2.5)
line(window, root, 2, y, 11, 1.4, 0)
end
end
Draw.grid = Draw.dashboard
Draw.layers = function(window, root)
for _, y in { -4, 0, 4 } do
line(window, root, -4, y, 9, 1.3, -28)
line(window, root, 4, y, 9, 1.3, 28)
end
end
Draw.stack = Draw.layers
Draw.terminal = function(window, root)
outline(window, root, {
Size = UDim2.fromOffset(18, 14),
Position = UDim2.fromScale(0.5, 0.5),
AnchorPoint = Vector2.new(0.5, 0.5),
}, 2)
line(window, root, -4, -1, 6, 1.4, 45)
line(window, root, -4, 3, 6, 1.4, -45)
line(window, root, 3.5, 4, 6, 1.4, 0)
end
Draw.console = Draw.terminal
Draw.monitor = function(window, root)
outline(window, root, {
Size = UDim2.fromOffset(18, 12),
Position = UDim2.new(0.5, 0, 0.5, -2),
AnchorPoint = Vector2.new(0.5, 0.5),
}, 2)
line(window, root, 0, 5, 7, 1.4, 90)
line(window, root, 0, 8, 10, 1.4, 0)
end
Draw.desktop = Draw.monitor
Draw.smartphone = function(window, root)
outline(window, root, {
Size = UDim2.fromOffset(10, 18),
Position = UDim2.fromScale(0.5, 0.5),
AnchorPoint = Vector2.new(0.5, 0.5),
}, 2)
dot(window, root, 0, 6, 1.8)
end
Draw.mobile = Draw.smartphone
Draw.package = function(window, root)
line(window, root, -4, -5, 9, 1.4, -28)
line(window, root, 4, -5, 9, 1.4, 28)
line(window, root, -4, 0, 9, 1.4, 28)
line(window, root, 4, 0, 9, 1.4, -28)
line(window, root, -7, 1, 11, 1.4, 90)
line(window, root, 7, 1, 11, 1.4, 90)
line(window, root, 0, 4, 9, 1.4, 90)
end
Draw.box = Draw.package
Draw.wrench = function(window, root)
line(window, root, 0, 1, 15, 2.3, -45)
outline(window, root, {
Size = UDim2.fromOffset(6, 6),
Position = UDim2.new(0.5, 5, 0.5, -5),
AnchorPoint = Vector2.new(0.5, 0.5),
}, 1, nil, 1.3)
dot(window, root, -5.5, 6.5, 3)
end
Draw.tools = Draw.wrench
Draw.zap = function(window, root)
line(window, root, 2, -5, 11, 1.7, -60)
line(window, root, 0, 0, 8, 1.7, 0)
line(window, root, -2, 5, 11, 1.7, -60)
end
Draw.lightning = Draw.zap
Draw.activity = function(window, root)
line(window, root, -6, 1, 6, 1.4, 0)
line(window, root, -3, -1, 7, 1.4, 62)
line(window, root, 0, 0, 11, 1.4, -72)
line(window, root, 4, 1, 8, 1.4, 55)
line(window, root, 7, 1, 4, 1.4, 0)
end
Draw.pulse = Draw.activity
Draw.play = function(window, root)
line(window, root, -3, -5, 12, 1.7, 90)
line(window, root, 2, -2.5, 11, 1.7, 28)
line(window, root, 2, 2.5, 11, 1.7, -28)
end
Draw.run = Draw.play
Draw.sparkles = Draw.star
Draw.magic = Draw.star
Draw["refresh-cw"] = Draw.reset
Draw.refresh = Draw.reset
Draw["shield-check"] = function(window, root)
Draw.shield(window, root)
line(window, root, -2, 1, 4, 1.4, 45, "Accent")
line(window, root, 2, 0, 7, 1.4, -45, "Accent")
end
function Icon.setColor(instance, color)
if not instance then
return
end
local function apply(item)
if item:GetAttribute("BobloIconMask") then
return
end
if item:GetAttribute("BobloIconPart") then
if item:IsA("UIStroke") then
item.Color = color
elseif item:IsA("ImageLabel") or item:IsA("ImageButton") then
item.ImageColor3 = color
elseif item:IsA("TextLabel") or item:IsA("TextButton") then
item.TextColor3 = color
elseif item:IsA("GuiObject") then
item.BackgroundColor3 = color
end
end
end
apply(instance)
for _, item in instance:GetDescendants() do
apply(item)
end
end
local function createImage(window, asset, name, props)
local imageProps = table.clone(props)
imageProps.BackgroundTransparency = 1
imageProps.BorderSizePixel = 0
imageProps.Image = if type(asset) == "table" then asset.Url or asset.Image else asset
if type(asset) == "table" then
imageProps.ImageRectOffset = asset.ImageRectOffset
imageProps.ImageRectSize = asset.ImageRectSize
end
local image = tag(Create.New("ImageLabel", imageProps))
image:SetAttribute("BobloIconName", name)
image:SetAttribute("BobloIconSource", if type(asset) == "table" then "Lucide" else "Custom")
bindPart(window, image)
return image
end
function Icon.Resolve(name)
local normalized = normalizeName(name)
if type(normalized) ~= "string" then
return nil
end
local resolved = Icon.Aliases[normalized] or normalized
return Lucide.GetAsset(resolved)
end
function Icon.new(window, name, props)
props = props or {}
local normalized = normalizeName(name)
local underscored = type(normalized) == "string" and string.gsub(normalized, "-", "_") or normalized
local custom = Icon.Registry[name] or Icon.Registry[normalized] or Icon.Registry[underscored]
if
type(custom) == "string"
and (string.find(custom, "rbxasset://", 1, true) or string.find(custom, "rbxassetid://", 1, true))
then
return createImage(window, custom, normalized, props)
end
if type(custom) == "table" and type(custom.Url or custom.Image) == "string" then
return createImage(window, custom, normalized, props)
end
if type(custom) == "function" then
local root = Create.New("Frame", copyLayoutProps(props))
root:SetAttribute("BobloIconName", normalized)
root:SetAttribute("BobloIconSource", "Custom")
custom(window, root)
return root
end
if type(custom) == "string" then
local textProps = table.clone(props)
textProps.BackgroundTransparency = 1
textProps.Text = custom
textProps.Font = window.Fonts.Medium
textProps.TextSize = textProps.TextSize or window.Tokens:Get("FontTitle")
local label = tag(Create.New("TextLabel", textProps))
bindPart(window, label)
return label
end
local asset = Icon.Resolve(normalized)
if asset then
return createImage(window, asset, asset.IconName, props)
end
local fallbackName = Icon.FallbackAliases[normalized] or normalized
local fallbackUnderscored = type(fallbackName) == "string" and string.gsub(fallbackName, "-", "_") or fallbackName
local drawer = Draw[name]
or Draw[normalized]
or Draw[underscored]
or Draw[fallbackName]
or Draw[fallbackUnderscored]
if drawer then
local root = Create.New("Frame", copyLayoutProps(props))
root:SetAttribute("BobloIconName", normalized)
root:SetAttribute("BobloIconSource", "Fallback")
drawer(window, root)
return root
end
local root = Create.New("Frame", copyLayoutProps(props))
root:SetAttribute("BobloIconName", normalized or "unknown")
root:SetAttribute("BobloIconSource", "Fallback")
Draw.star(window, root)
return root
end
return Icon
end

__modules["primitives/Lucide"] = function()
local Env = __require("runtime/Env")
local Lucide = {}
local DEFAULT_URLS = {
"https://raw.githubusercontent.com/bobloscript/BobloUI/main/dist/assets/bobloui/lucide-1.png",
"https://raw.githubusercontent.com/bobloscript/BobloUI/main/dist/assets/bobloui/lucide-2.png",
}
local CACHE = {
"BobloUI/assets/lucide-e8b0019-1.png",
"BobloUI/assets/lucide-e8b0019-2.png",
}
local EXPECTED = {
{ Bytes = 484530, Width = 1024, Height = 1024 },
{ Bytes = 53088, Width = 512, Height = 512 },
}
local icons = {
{
"align-vertical-distribute-center",
"chevron-down",
"list-restart",
"table-cells-split",
"gavel",
"dna-off",
"refresh-ccw-dot",
"venus",
"bean",
"circle-question-mark",
"folder-code",
"bolt",
"heater",
"feather",
"align-horizontal-distribute-center",
"grip-vertical",
"pill-bottle",
"person-standing",
"badge-swiss-franc",
"between-horizontal-end",
"file-braces-corner",
"rotate-cw",
"house-plus",
"bus-front",
"shield-ellipsis",
"between-vertical-end",
"globe-lock",
"tags",
"concierge-bell",
"bookmark-minus",
"file-down",
"picture-in-picture",
"messages-square",
"scissors",
"file-check-corner",
"phone-call",
"anchor",
"hand-helping",
"text-wrap",
"birdhouse",
"wifi-off",
"cloud-alert",
"message-square",
"cloud-download",
"folder-plus",
"cctv-off",
"mirror-round",
"user-round",
"pointer",
"between-horizontal-start",
"chevrons-up-down",
"brush",
"message-circle-more",
"parentheses",
"book-up-2",
"flame",
"chevrons-up",
"square-dashed",
"square-mouse-pointer",
"superscript",
"signal",
"wifi-cog",
"hexagon",
"navigation-2-off",
"eye-off",
"arrows-up-from-line",
"file-code-corner",
"square-centerline-dashed-horizontal",
"panels-right-bottom",
"scaling",
"hash",
"arrow-left-from-line",
"ship",
"ticket-percent",
"calendar-clock",
"x",
"non-binary",
"voicemail",
"presentation",
"tree-palm",
"badge",
"captions-off",
"align-vertical-justify-center",
"download",
"mouse-right",
"lens-convex",
"focus",
"diamond-percent",
"arrow-big-up",
"volume-x",
"mouse-pointer-click",
"origami",
"hard-drive",
"grid-2x2-x",
"package-minus",
"cloud",
"pipette",
"corner-left-down",
"badge-cent",
"cloud-lightning",
"user-round-pen",
"arrow-left-to-line",
"book-open-text",
"monitor-cloud",
"parking-meter",
"cat",
"heart-handshake",
"dam",
"trees",
"ham",
"circle-pause",
"chess-king",
"bean-off",
"rat",
"separator-horizontal",
"ambulance",
"signal-zero",
"citrus",
"phone-missed",
"calendar-off",
"chart-column",
"battery-medium",
"square-minus",
"star-check",
"decimals-arrow-left",
"folder-output",
"menu",
"image-down",
"terminal",
"angry",
"circle-dot-dashed",
"medal",
"cake-slice",
"git-graph",
"armchair",
"tickets",
"qr-code",
"copy",
"goal",
"trending-down",
"creative-commons",
"ev-charger",
"user-star",
"road",
"nfc",
"align-center-horizontal",
"car",
"notebook-tabs",
"ear",
"videotape",
"sun-moon",
"chart-scatter",
"podium",
"toolbox",
"calendar",
"calendar-cog",
"gallery-horizontal",
"clipboard-x",
"list-sort-ascending",
"book-open",
"circle-pile",
"rectangle-ellipsis",
"badge-plus",
"badge-info",
"file-headphone",
"bow-arrow",
"clipboard-pen-line",
"user-round-key",
"folder-search",
"utensils-crossed",
"arrow-up",
"arrow-up-from-dot",
"align-vertical-justify-start",
"layers-minus",
"pause",
"shrub",
"flag",
"biceps-flexed",
"align-horizontal-distribute-end",
"donut",
"calendar-plus-2",
"move-vertical",
"file-pen-line",
"badge-russian-ruble",
"radius",
"pilcrow",
"corner-left-up",
"georgian-lari",
"cable",
"book-user",
"square-arrow-down",
"circle-plus",
"view",
"cctv",
"circle-arrow-left",
"square-off",
"octagon-alert",
"panel-bottom-dashed",
"book-a",
"align-end-vertical",
"thumbs-up",
"globe",
"rabbit",
"layers-plus",
"banknote-arrow-down",
"message-square-off",
"dice-4",
"message-circle-x",
"folder-x",
"message-circle-warning",
"map",
"move",
"arrow-up-left",
"award",
"arrow-down-wide-narrow",
"unfold-horizontal",
"lens-concave",
"motorbike",
"music-4",
"shield-x",
"file-volume",
"disc-3",
"file-signal",
"columns-4",
"archive-x",
"square-dashed-kanban",
"mouse-pointer-2",
"clock-arrow-up",
"clock-fading",
"pencil-sparkles",
"vegan",
"star-plus",
"message-circle-plus",
"fast-forward",
"user-pen",
"chess-knight",
"wifi-pen",
"files",
"send-to-back",
"alarm-clock",
"shopping-basket",
"send",
"brush-cleaning",
"skip-back",
"book-audio",
"file-scan",
"message-square-dashed",
"chevrons-left",
"umbrella",
"skip-forward",
"clipboard-copy",
"map-pin-off",
"arrow-up-from-line",
"circle-chevron-up",
"circle-small",
"align-vertical-space-between",
"lamp-desk",
"circle-arrow-up",
"zap",
"beaker",
"paintbrush",
"broccoli",
"chevron-up",
"pen-tool",
"database-check",
"form",
"pencil-ruler",
"dna",
"arrow-big-down-dash",
"chart-area",
"bug-off",
"card-sim",
"map-pin-search",
"eye-dashed",
"ellipse",
"spell-check",
"popcorn",
"blocks",
"washing-machine",
"microchip",
"badge-minus",
"cloud-sun",
"circle",
"shield-alert",
"map-minus",
"separator-vertical",
"scan-square",
"ampersands",
"user-search",
"fence",
"square-user-round",
"sunrise",
"strikethrough",
"calendar-days",
"folder-bookmark",
"banknote-arrow-up",
"dollar-sign",
"message-square-quote",
"list-minus",
"cloud-hail",
"eye-closed",
"app-window-mac",
"ellipsis",
"copy-check",
"satellite",
"bookmark-plus",
"folder-key",
"coffee",
"circle-power",
"hourglass",
"tickets-plane",
"folder-git",
"bomb",
"layers-2",
"battery-full",
"user-minus",
"chart-gantt",
"folder-tree",
"command",
"badge-dollar-sign",
"align-start-vertical",
"briefcase-conveyor-belt",
"message-circle-question-mark",
"bluetooth-off",
"square-square",
"cannabis",
"book",
"grip-horizontal",
"circle-minus",
"audio-waveform",
"moon-star",
"arrow-down-narrow-wide",
"database-backup",
"wand",
"receipt-turkish-lira",
"calendar-minus-2",
"copy-minus",
"folder-input",
"book-image",
"mouse-left",
"tag-plus",
"shirt",
"server-off",
"move-up",
"plug-2",
"chess-rook",
"brackets",
"calendar-heart",
"list-ordered",
"star-x",
"mic-off",
"arrow-big-left",
"square-split-horizontal",
"clover",
"sun-snow",
"sofa",
"funnel-x",
"clock-2",
"calendar-fold",
"fish-off",
"baby",
"database-x",
"fold-vertical",
"hop",
"paperclip",
"cigarette",
"minus",
"smile-plus",
"diamond-plus",
"file-chart-column",
"triangle-dashed",
"git-pull-request-closed",
"badge-check",
"zoom-out",
"zoom-in",
"zodiac-virgo",
"plug-zap",
"heading-4",
"chess-queen",
"graduation-cap",
"grid-3x2",
"zodiac-sagittarius",
"list-music",
"square-dashed-bottom-code",
"clock-7",
"ethernet-port",
"scan-text",
"file-up",
"shower-head",
"equal-not",
"zodiac-pisces",
"move-down",
"clock-arrow-down",
"ticket-slash",
"ruler",
"tornado",
"zodiac-libra",
"circle-user-round",
"zodiac-leo",
"zodiac-gemini",
"list-filter",
"map-pin-check",
"egg-off",
"square-kanban",
"cog",
"dog",
"folder-closed",
"swords",
"spotlight",
"panel-right-dashed",
"zodiac-aries",
"paper-bag",
"truck-electric",
"zodiac-aquarius",
"check-line",
"save",
"bubbles",
"bot",
"chart-bar-increasing",
"x-line-top",
"trash-2",
"air-vent",
"swiss-franc",
"dot",
"sprout",
"worm",
"file-symlink",
"clipboard-paste",
"chevron-last",
"book-heart",
"workflow",
"circle-parking",
"globe-check",
"cloud-check",
"panel-left",
"circle-chevron-right",
"wine-off",
"wine",
"squares-unite",
"arrow-down-up",
"git-fork",
"forward",
"brain-circuit",
"between-vertical-start",
"database",
"panel-right",
"wind-arrow-down",
"message-square-diff",
"popsicle",
"log-out",
"git-branch-plus",
"clipboard-minus",
"file-text",
"wifi-sync",
"bell-off",
"wifi-high",
"table-rows-split",
"milk-off",
"tv-minimal",
"cloud-upload",
"banknote",
"wifi",
"webcam-off",
"drumstick",
"wheat-off",
"calendar-search",
"wheat",
"weight-tilde",
"bell-ring",
"circle-chevron-left",
"weight",
"arrow-down",
"arrow-up-down",
"folder-dot",
"fingerprint-pattern",
"folder-up",
"whole-word",
"monitor",
"disc-2",
"trending-up-down",
"webcam",
"user-shield",
"waypoints",
"tv-minimal-play",
"circle-stop",
"align-vertical-space-around",
"waves-vertical",
"waves-ladder",
"waves-horizontal",
"arrow-big-down",
"circle-parking-off",
"calendar-x-2",
"user-plus",
"move-diagonal-2",
"bandage",
"gallery-horizontal-end",
"panel-top-dashed",
"octagon-minus",
"waves-arrow-down",
"tram-front",
"watch",
"indian-rupee",
"wand-sparkles",
"audio-lines",
"wallpaper",
"wallet-minimal",
"wallet-cards",
"flip-vertical-2",
"rocket",
"wallet",
"ear-off",
"vote",
"save-check",
"volume-off",
"shield-half",
"printer",
"megaphone-off",
"volume-1",
"arrow-big-right",
"section",
"file-clock",
"volume",
"toy-brick",
"square-chevron-down",
"dice-1",
"drill",
"app-window",
"shield-check",
"hand-metal",
"volleyball",
"spell-check-2",
"umbrella-off",
"video",
"list-plus",
"sun-dim",
"rotate-ccw-key",
"vibrate",
"chart-pie",
"venus-and-mars",
"cloud-backup",
"copy-slash",
"wind",
"vault",
"layout-panel-left",
"badge-x",
"circle-percent",
"van",
"circle-arrow-out-down-right",
"square-x",
"italic",
"chart-column-increasing",
"utility-pole",
"step-forward",
"utensils",
"a-arrow-down",
"container",
"sticker",
"users-round",
"users",
"user-x",
"user-round-x",
"user-round-search",
"log-in",
"import",
"badge-turkish-lira",
"square-terminal",
"file-music",
"mic-vocal",
"beef",
"route-off",
"file-user",
"user-round-cog",
"square-radical",
"user-round-check",
"image-upscale",
"book-type",
"smile",
"signpost-big",
"user-round-arrow-left",
"cloudy",
"user-lock",
"square-percent",
"user-key",
"navigation-off",
"arrow-left",
"car-taxi-front",
"square-play",
"sparkle",
"chevrons-right-left",
"user",
"map-pin-plus",
"upload",
"unplug",
"square-code",
"unlink",
"university",
"square-pause",
"align-end-horizontal",
"ungroup",
"equal",
"megaphone",
"calendar-x",
"unfold-vertical",
"lamp-ceiling",
"egg",
"undo-2",
"undo",
"underline",
"circle-pound-sterling",
"video-off",
"japanese-yen",
"type-outline",
"fuel",
"file-search-corner",
"library",
"file-terminal",
"circle-chevron-down",
"accessibility",
"folder-lock",
"square-library",
"amphora",
"turntable",
"tally-2",
"turkish-lira",
"truck",
"trophy",
"gamepad-directional",
"sheet",
"circle-check-big",
"triangle-alert",
"triangle",
"map-pinned",
"corner-down-left",
"circuit-board",
"trending-up",
"train-front-tunnel",
"tree-deciduous",
"school",
"folder-open-dot",
"book-dashed",
"transgender",
"chevron-left",
"bluetooth",
"tree-pine",
"receipt-indian-rupee",
"monitor-stop",
"traffic-cone",
"tractor",
"tower-control",
"replace-all",
"touchpad-off",
"flask-conical",
"touchpad",
"funnel",
"square-star",
"folder-sync",
"torus",
"zodiac-ophiuchus",
"tool-case",
"toilet",
"arrow-up-narrow-wide",
"fishing-hook",
"text-quote",
"toggle-left",
"timer-reset",
"frame",
"calendar-arrow-down",
"clock-12",
"star-minus",
"radar",
"timer",
"images",
"lollipop",
"book-text",
"timeline",
"lamp-floor",
"file-plus-corner",
"image",
"ticket-x",
"badge-euro",
"bike",
"squares-exclude",
"list-checks",
"send-horizontal",
"dices",
"panel-left-dashed",
"thermometer-sun",
"thermometer-snowflake",
"option",
"banknote-check",
"scroll-text",
"server-plus",
"thermometer",
"theater",
"message-circle-off",
"toggle-right",
"pc-case",
"ferris-wheel",
"camera-off",
"text-cursor-input",
"text-cursor",
"info",
"text-align-justify",
"text-align-end",
"group",
"text-align-center",
"battery",
"test-tubes",
"tent-tree",
"test-tube-diagonal",
"rectangle-horizontal",
"bug",
"tent",
"telescope",
"bitcoin",
"lamp",
"battery-plus",
"database-search",
"tangent",
"file-diff",
"phone-off",
"link",
"tally-3",
"spline-pointer",
"circle-alert",
"axis-3d",
"shell",
"tag",
"binoculars",
"tablets",
"tablet-smartphone",
"screen-share",
"rose",
"table-properties",
"mail-minus",
"table-of-contents",
"table-columns-split",
"table-cells-merge",
"table-2",
"clipboard-pen",
"bottle-wine",
"alarm-clock-off",
"table",
"list",
"syringe",
"square-arrow-right",
"rotate-ccw-clock",
"badge-pound-sterling",
"bookmark-check",
"switch-camera",
"wrench-off",
"square-arrow-out-down-left",
"a-arrow-up",
"clock-check",
"sunset",
"sun-medium",
"vibrate-off",
"mail-check",
"zodiac-cancer",
"file-chart-column-increasing",
"file-code",
"subscript",
"chart-column-big",
"stretch-vertical",
"stretch-horizontal",
"cassette-tape",
"battery-low",
"monitor-pause",
"stone",
"signpost",
"image-plus",
"calendar-arrow-up",
"landmark",
"fish-symbol",
"sticky-note-x",
"loader",
"bold",
"dice-2",
"file-type",
"clipboard-clock",
"beer",
"lectern",
"chart-bar-stacked",
"file-check",
"git-pull-request-create",
"binary",
"move-diagonal",
"sticky-note-check",
"door-closed",
"sticky-note",
"layout-template",
"stethoscope",
"step-back",
"star-off",
"bookmark-off",
"hand-heart",
"scroll",
"scan-qr-code",
"message-square-check",
"star",
"stamp",
"squirrel",
"brain",
"folder",
"squircle",
"snail",
"key",
"clock-11",
"earth-lock",
"ticket-plus",
"arrow-up-0-1",
"bell-electric",
"square-user",
"heading",
"book-open-check",
"panel-top-close",
"lasso-select",
"move-left",
"square-stack",
"square-split-vertical",
"square-slash",
"bus",
"square-sigma",
"bed-single",
"chart-no-axes-gantt",
"file-spreadsheet",
"square-scissors",
"clipboard-list",
"square-round-corner",
"contact-round",
"leaf",
"keyboard-off",
"square-plus",
"file-badge",
"battery-warning",
"mail-question-mark",
"arrow-down-from-line",
"briefcase",
"biohazard",
"rectangle-circle",
"braces",
"scale-3d",
"panel-top-bottom-dashed",
"mail-x",
"square-dashed-mouse-pointer",
"user-cog",
"lock-open",
"square-pilcrow",
"pizza",
"list-indent-decrease",
"arrow-up-wide-narrow",
"square-pi",
"clock-5",
"mouse-pointer",
"rotate-ccw",
"align-horizontal-justify-center",
"database-arrow-down",
"antenna",
"memory-stick",
"scan-eye",
"square-parking",
"square-check",
"heart-plus",
"receipt-russian-ruble",
"map-pin-minus-inside",
"git-merge",
"gallery-vertical-end",
"square-m",
"hand-coins",
"zodiac-capricorn",
"wifi-low",
"square-equal",
"clock",
"file-pen",
"git-compare-arrows",
"cloud-sun-rain",
"align-horizontal-justify-start",
"square-dot",
"square-divide",
"square-arrow-right-enter",
"calendar-plus",
"square-bottom-dashed-scissors",
"arrow-down-z-a",
"bath",
"square-dashed-bottom",
"unlink-2",
"square-chevron-up",
"pin",
"folder-check",
"square-chevron-left",
"book-key",
"ribbon",
"microwave",
"saudi-riyal",
"gallery-vertical",
"square-chart-gantt",
"square-centerline-dashed-vertical",
"square-dashed-text",
"map-pin-pen",
"move-up-left",
"square-asterisk",
"folder-heart",
"square-arrow-up-right",
"shield-cog-corner",
"circle-play",
"arrow-up-a-z",
"square-arrow-right-exit",
"square-dashed-top-solid",
"square-arrow-out-up-right",
"square-arrow-out-up-left",
"circle-ellipsis",
"swatch-book",
"receipt-cent",
"spool",
"folder-archive",
"folder-symlink",
"columns-3",
"ban",
"message-square-x",
"paint-roller",
"soup",
"archive",
"square-arrow-down-right",
"construction",
"building-2",
"circle-slash-2",
"package",
"cake",
"cloud-rain",
"chart-bar",
"square",
"wrench",
"spray-can",
"sport-shoe",
"smartphone",
"flag-triangle-right",
"receipt-euro",
"speech",
"bell",
"speaker",
"sparkles",
"music-3",
"chart-bar-big",
"user-check",
"proportions",
"spade",
"plane",
"webhook-off",
"carrot",
"square-arrow-left",
"file-cog",
"circle-dashed",
"solar-panel",
"soap-dispenser-droplet",
"snowflake",
"mailbox",
"squares-subtract",
"smartphone-nfc",
"chevrons-left-right-ellipsis",
"split",
"list-sort-descending",
"sliders-vertical",
"forklift",
"sliders-horizontal",
"alarm-clock-minus",
"heart-x",
"eraser",
"book-marked",
"package-search",
"bluetooth-connected",
"rotate-ccw-square",
"chart-no-axes-column",
"cannabis-off",
"folder-kanban",
"message-square-plus",
"mars-stroke",
"skull",
"siren",
"signature",
"file-box",
"signal-medium",
"paint-bucket",
"glass-water",
"signal-low",
"glasses",
"piggy-bank",
"maximize-2",
"cuboid",
"cloud-off",
"check-check",
"activity",
"axe",
"plane-takeoff",
"sigma",
"cloud-rain-wind",
"flower",
"expand",
"copy-x",
"file-axis-3d",
"radical",
"chart-column-decreasing",
"shrimp",
"bug-play",
"align-vertical-distribute-start",
"highlighter",
"waves-arrow-up",
"tally-5",
"shopping-bag",
"ship-wheel",
"shield-user",
"circle-divide",
"shield-question-mark",
"shield-plus",
"shield-off",
"life-buoy",
"hard-hat",
"shield-keyhole",
"volume-2",
"battery-charging",
"russian-ruble",
"square-arrow-up-left",
"brick-wall-shield",
"footprints",
"shield-cog",
"building",
"shield-ban",
"shield",
"shelving-unit",
"tag-x",
"book-alert",
"link-2",
"astroid",
"bell-minus",
"image-up",
"closed-caption",
"drum",
"arrow-up-z-a",
"sun",
"share",
"shapes",
"file-key",
"settings-2",
"settings",
"scissors-line-dashed",
"server-crash",
"server-cog",
"server",
"ticket-check",
"combine",
"search-x",
"search-slash",
"mountain",
"mars",
"picture-in-picture-2",
"radio-off",
"flower-2",
"search-code",
"squares-intersect",
"search-alert",
"search",
"keyboard-music",
"star-half",
"screen-share-off",
"code-xml",
"pencil-line",
"mails",
"brain-cog",
"tablet",
"loader-circle",
"pi",
"trash",
"book-down",
"hdmi-port",
"scan-search",
"case-upper",
"circle-fading-arrow-up",
"redo",
"croissant",
"move-down-right",
"scan-face",
"barcode",
"scan-box",
"scan-barcode",
"bed",
"scan",
"divide",
"grape",
"remove-formatting",
"party-popper",
"file-chart-pie",
"save-plus",
"file-braces",
"dice-6",
"save-off",
"blender",
"image-minus",
"zap-off",
"square-check-big",
"satellite-dish",
"sandwich",
"salad",
"laptop-minimal",
"sailboat",
"monitor-check",
"map-pin-minus",
"file-minus-corner",
"chart-spline",
"message-square-more",
"rows-4",
"chart-candlestick",
"rows-3",
"arrow-down-a-z",
"rows-2",
"router",
"move-horizontal",
"file-sliders",
"frown",
"route",
"cup-soda",
"rewind",
"rotate-cw-fading-clock",
"sword",
"rotate-3d",
"roller-coaster",
"earth",
"slice",
"dice-3",
"milk",
"mouse-pointer-ban",
"crown",
"circle-slash",
"circle-star",
"rotate-cw-square",
"atom",
"package-x",
"bed-double",
"list-chevrons-up-down",
"circle-dot",
"file-exclamation-point",
"hand-fist",
"message-circle-code",
"folder-git-2",
"message-square-code",
"reply",
"towel-rack",
"replace",
"arrow-big-left-dash",
"repeat-off",
"dumbbell",
"repeat-2",
"repeat-1",
"repeat",
"scale",
"regex",
"flashlight",
"panel-top-open",
"refrigerator",
"refresh-cw-off",
"notebook",
"redo-2",
"refresh-cw",
"square-menu",
"brick-wall",
"monitor-smartphone",
"laptop",
"scan-line",
"clock-4",
"square-arrow-up",
"book-minus",
"file-question-mark",
"rectangle-vertical",
"rectangle-goggles",
"save-pen",
"arrow-down-to-line",
"receipt-swiss-franc",
"refresh-ccw",
"venetian-mask",
"calendar-check-2",
"receipt-japanese-yen",
"spline",
"banknote-x",
"git-pull-request-create-arrow",
"pound-sterling",
"circle-check",
"ratio",
"rainbow",
"phone",
"radio-receiver",
"radio",
"radiation",
"timer-off",
"arrow-big-right-dash",
"quote",
"pyramid",
"puzzle",
"backpack",
"projector",
"list-check",
"printer-check",
"power-off",
"mic-signal",
"arrow-down-right",
"power",
"receipt",
"wifi-zero",
"folder-minus",
"list-collapse",
"plus",
"plug",
"image-off",
"play-off",
"play",
"plane-landing",
"pin-off",
"square-chevron-right",
"mail-search",
"pill",
"bone-fracture",
"microscope",
"pilcrow-left",
"pickaxe",
"piano",
"tally-1",
"ampersand",
"ad",
"shopping-cart",
"align-vertical-justify-end",
"phone-incoming",
"alarm-smoke",
"phone-forwarded",
"file-input",
"clock-8",
"hand-grab",
"cloud-cog",
"blend",
"hd",
"radio-tower",
"list-tree",
"droplet",
"grid-2x2",
"eye",
"phi",
"percent",
"banana",
"gpu",
"pentagon",
"pencil-off",
"circle-equal",
"delete",
"pen-off",
"pen-line",
"headset",
"text-initial",
"arrow-up-right",
"move-right",
"leafy-green",
"message-square-dot",
"file-chart-line",
"columns-3-cog",
"parasol",
"calendar-minus",
"minimize-2",
"panels-left-bottom",
"panel-top",
"cone",
"panel-right-open",
"file-image",
"panel-right-close",
"palette",
"barrel",
"gallery-thumbnails",
"panel-left-right-dashed",
"cpu",
"panel-left-open",
"thumbs-down",
"merge",
"hamburger",
"bird",
"hat-glasses",
"code",
"helicopter",
"panel-bottom-close",
"panel-bottom",
"panda",
"file-video-camera",
"paintbrush-vertical",
"kanban",
"bone",
"apple",
"rocking-chair",
"bot-off",
"package-plus",
"package-open",
"diameter",
"circle-arrow-out-up-left",
"package-2",
"cable-car",
"arrow-down-left",
"square-activity",
"orbit",
"cigarette-off",
"omega",
"message-circle",
"circle-arrow-out-up-right",
"locate-fixed",
"octagon-pause",
"fold-horizontal",
"shovel",
"calendar-1",
"cloud-moon",
"square-arrow-out-down-right",
"nut-off",
"clock-plus",
"circle-euro",
"cloud-snow",
"anvil",
"arrow-big-up-dash",
"nut",
"notepad-text-dashed",
"notepad-text",
"list-video",
"monitor-off",
"newspaper",
"chevrons-down-up",
"clipboard-plus",
"circle-x",
"list-end",
"network",
"navigation-2",
"chevrons-right",
"navigation",
"message-square-reply",
"corner-down-right",
"music-2",
"summary",
"lamp-wall-down",
"move-up-right",
"paw-print",
"ellipsis-vertical",
"globe-off",
"square-stop",
"arrow-up-1-0",
"align-horizontal-justify-end",
"scan-heart",
"align-vertical-distribute-end",
"heart-crack",
"airplay",
"move-down-left",
"move-3d",
"message-square-share",
"monitor-x",
"bell-check",
"database-minus",
"square-pen",
"mouse-off",
"lasso",
"dice-5",
"octagon",
"ticket",
"moon",
"monitor-up",
"train-front",
"bookmark",
"monitor-speaker",
"album",
"monitor-play",
"chart-bar-decreasing",
"database-plus",
"calendar-sync",
"funnel-plus",
"store",
"circle-arrow-down",
"notebook-pen",
"egg-fried",
"message-circle-heart",
"monitor-dot",
"corner-right-up",
"monitor-cog",
"ruler-dimension-line",
"user-round-plus",
"panel-left-close",
"milestone",
"pilcrow-right",
"user-round-minus",
"mic-audio-lines",
"mic",
"mail-plus",
"case-sensitive",
"message-square-warning",
"message-square-text",
"mouse-pointer-2-off",
"drone",
"slash",
"message-square-lock",
"aperture",
"arrow-right-left",
"message-square-heart",
"vector-square",
"circle-gauge",
"gem",
"check",
"text-search",
"arrow-down-to-dot",
"monitor-down",
"message-circle-dashed",
"chef-hat",
"message-circle-check",
"meh",
"file-archive",
"signal-high",
"inbox",
"flip-horizontal-2",
"maximize",
"image-play",
"align-horizontal-space-between",
"kayak",
"calendar-check",
"database-zap",
"droplets",
"calendar-range",
"map-pin-x-inside",
"map-pin-x",
"layout-list",
"file-search",
"heart",
"alarm-clock-plus",
"circle-dollar-sign",
"usb",
"house",
"receipt-pound-sterling",
"file-digit",
"map-pin",
"id-card",
"mouse",
"minimize",
"mail",
"magnet",
"circle-arrow-right",
"logs",
"book-x",
"mirror-rectangular",
"lock-keyhole-open",
"lock-keyhole",
"lock",
"headphone-off",
"asterisk",
"calculator",
"octagon-x",
"languages",
"locate",
"alarm-clock-check",
"guitar",
"loader-pinwheel",
"beer-off",
"scooter",
"square-parking-off",
"notebook-text",
"arrow-right-to-line",
"ticket-minus",
"tally-4",
"zodiac-taurus",
"list-indent-increase",
"door-open",
"flag-triangle-left",
"grid-3x3",
"file",
"keyboard",
"pocket-knife",
"book-copy",
"castle",
"car-front",
"clock-alert",
"reply-all",
"cloud-moon-rain",
"clipboard-type",
"list-chevrons-down-up",
"list-todo",
"printer-x",
"link-2-off",
"list-start",
"line-style",
"a-large-small",
"line-squiggle",
"line-dot-right-horizontal",
"map-plus",
"lightbulb",
"ligature",
"library-big",
"database-arrow-up",
"arrow-right-from-line",
"flame-kindling",
"square-power",
"layout-panel-top",
"bring-to-front",
"layout-grid",
"layout-freeform",
"bell-plus",
"layout-dashboard",
"layers",
"laugh",
"folders",
"mail-warning",
"book-plus",
"land-plot",
"lamp-wall-up",
"chevrons-left-right",
"chart-line",
"file-lock",
"cast",
"circle-fading-plus",
"clock-10",
"undo-dot",
"target",
"list-filter-plus",
"key-square",
"drama",
"file-type-corner",
"baseline",
"martini",
"contrast",
"joystick",
"candy-off",
"iteration-cw",
"book-check",
"iteration-ccw",
"book-lock",
"inspection-panel",
"briefcase-medical",
"calendars",
"text-align-start",
"infinity",
"hop-off",
"warehouse",
"sticky-notes",
"drafting-compass",
"save-all",
"id-card-lanyard",
"ice-cream-cone",
"ice-cream-bowl",
"house-wifi",
"house-plug",
"fishing-rod",
"book-headphones",
"credit-card",
"house-heart",
"hotel",
"hospital",
"shredder",
"panel-bottom-open",
"heart-pulse",
"heart-off",
"heart-minus",
"balloon",
"map-pin-plus-inside",
"bookmark-x",
"badge-question-mark",
"pen",
"file-stack",
"candy-cane",
"heading-6",
"heading-5",
"gamepad-2",
"heading-3",
"heading-2",
"heading-1",
"haze",
"shield-minus",
"circle-off",
"dessert",
"eclipse",
"church",
"hard-drive-upload",
"cylinder",
"badge-japanese-yen",
"hard-drive-download",
"receipt-text",
"handbag",
"hand-platter",
"hand",
"hammer",
"file-output",
"disc-album",
"grip",
"arrow-down-0-1",
"captions",
"flashlight-off",
"grid-2x2-check",
"philippine-peso",
"badge-alert",
"globe-x",
"folder-pen",
"cross",
"git-pull-request-draft",
"chevron-right",
"sticky-note-minus",
"square-arrow-down-left",
"share-2",
"git-merge-conflict",
"git-compare",
"git-commit-vertical",
"git-commit-horizontal",
"clipboard",
"git-branch",
"chess-pawn",
"gift",
"briefcase-business",
"ghost",
"message-circle-reply",
"gauge",
"triangle-right",
"folder-clock",
"gamepad",
"fullscreen",
"type",
"webhook",
"folder-search-2",
"align-horizontal-distribute-start",
"folder-root",
"folder-open",
"pointer-off",
"turtle",
"camera",
"compass",
"folder-cog",
"git-pull-request",
"bluetooth-searching",
"arrow-up-to-line",
"squircle-dashed",
"clock-3",
"badge-percent",
"shuffle",
"flask-round",
"flask-conical-off",
"grid-2x2-plus",
"flag-off",
"box",
"fish",
"clock-1",
"file-heart",
"fire-extinguisher",
"space",
"film",
"file-x-corner",
"file-x",
"corner-up-left",
"clock-6",
"zodiac-scorpio",
"key-round",
"headphones",
"tv",
"contact",
"file-play",
"rss",
"file-minus",
"at-sign",
"map-pin-check-inside",
"sticky-note-off",
"music",
"handshake",
"fan",
"circle-user",
"copy-plus",
"factory",
"external-link",
"shrink",
"euro",
"equal-approximately",
"search-check",
"clipboard-check",
"columns-2",
"droplet-off",
"cloud-sync",
"align-center-vertical",
"dock",
"disc",
"diff",
"cloud-fog",
"mosque",
"diamond-minus",
"map-pin-house",
"package-check",
"chevron-first",
"pencil",
"component",
"list-x",
"currency",
"crosshair",
"corner-up-right",
"crop",
"clock-arrow-left",
"corner-right-down",
"copyright",
"badge-indian-rupee",
"copyleft",
"redo-dot",
"cookie",
"align-start-horizontal",
"chart-column-stacked",
"file-plus",
"git-pull-request-arrow",
"computer",
"decimals-arrow-right",
"bell-dot",
"folder-down",
"coins",
"club",
"align-horizontal-space-around",
"door-closed-locked",
"cloud-drizzle",
"diamond",
"blinds",
"clock-arrow-right",
"clock-9",
"book-search",
"git-branch-minus",
"clapperboard",
"recycle",
"mountain-snow",
"luggage",
"circle-arrow-out-down-left",
"bot-message-square",
"phone-outgoing",
"smartphone-charging",
"chevrons-down",
"train-track",
"chess-bishop",
"cherry",
"sticky-note-plus",
"chart-no-axes-column-increasing",
"chart-no-axes-column-decreasing",
"chart-network",
"chart-no-axes-combined",
"metronome",
"case-lower",
"arrow-down-1-0",
"caravan",
"candy",
"arrow-left-right",
"lightbulb-off",
"panels-top-left",
"beef-off",
"locate-off",
"annoyed",
"test-tube",
"brick-wall-fire",
"cooking-pot",
"boxes",
"boom-box",
"book-up",
"laptop-minimal-check",
"mail-open",
"square-function",
"baggage-claim",
"variable",
"arrow-right",
"archive-restore",
},
{ "", "" },
{
[48] = {
{ 1, { 24, 24 }, { 150, 25 } },
{ 1, { 24, 24 }, { 275, 350 } },
{ 1, { 24, 24 }, { 400, 650 } },
{ 1, { 24, 24 }, { 975, 725 } },
{ 1, { 24, 24 }, { 175, 750 } },
{ 1, { 24, 24 }, { 300, 500 } },
{ 1, { 24, 24 }, { 450, 850 } },
{ 2, { 24, 24 }, { 200, 100 } },
{ 1, { 24, 24 }, { 75, 325 } },
{ 1, { 24, 24 }, { 275, 400 } },
{ 1, { 24, 24 }, { 400, 500 } },
{ 1, { 24, 24 }, { 75, 375 } },
{ 1, { 24, 24 }, { 50, 925 } },
{ 1, { 24, 24 }, { 825, 25 } },
{ 1, { 24, 24 }, { 25, 100 } },
{ 1, { 24, 24 }, { 150, 800 } },
{ 1, { 24, 24 }, { 650, 600 } },
{ 1, { 24, 24 }, { 375, 850 } },
{ 1, { 24, 24 }, { 325, 50 } },
{ 1, { 24, 24 }, { 125, 300 } },
{ 1, { 24, 24 }, { 650, 200 } },
{ 1, { 24, 24 }, { 400, 925 } },
{ 1, { 24, 24 }, { 775, 225 } },
{ 1, { 24, 24 }, { 0, 525 } },
{ 1, { 24, 24 }, { 975, 450 } },
{ 1, { 24, 24 }, { 75, 350 } },
{ 1, { 24, 24 }, { 525, 425 } },
{ 1, { 24, 24 }, { 950, 775 } },
{ 1, { 24, 24 }, { 425, 325 } },
{ 1, { 24, 24 }, { 325, 175 } },
{ 1, { 24, 24 }, { 300, 550 } },
{ 1, { 24, 24 }, { 775, 475 } },
{ 1, { 24, 24 }, { 750, 375 } },
{ 1, { 24, 24 }, { 700, 675 } },
{ 1, { 24, 24 }, { 500, 350 } },
{ 1, { 24, 24 }, { 300, 925 } },
{ 1, { 24, 24 }, { 75, 125 } },
{ 1, { 24, 24 }, { 875, 100 } },
{ 1, { 24, 24 }, { 825, 950 } },
{ 1, { 24, 24 }, { 350, 100 } },
{ 2, { 24, 24 }, { 275, 100 } },
{ 1, { 24, 24 }, { 575, 150 } },
{ 1, { 24, 24 }, { 775, 350 } },
{ 1, { 24, 24 }, { 475, 250 } },
{ 1, { 24, 24 }, { 0, 900 } },
{ 1, { 24, 24 }, { 525, 75 } },
{ 1, { 24, 24 }, { 325, 800 } },
{ 2, { 24, 24 }, { 25, 225 } },
{ 1, { 24, 24 }, { 925, 350 } },
{ 1, { 24, 24 }, { 100, 325 } },
{ 1, { 24, 24 }, { 625, 25 } },
{ 1, { 24, 24 }, { 175, 350 } },
{ 1, { 24, 24 }, { 500, 600 } },
{ 1, { 24, 24 }, { 800, 425 } },
{ 1, { 24, 24 }, { 475, 25 } },
{ 1, { 24, 24 }, { 850, 50 } },
{ 1, { 24, 24 }, { 600, 50 } },
{ 1, { 24, 24 }, { 975, 575 } },
{ 1, { 24, 24 }, { 725, 825 } },
{ 1, { 24, 24 }, { 900, 775 } },
{ 1, { 24, 24 }, { 825, 625 } },
{ 2, { 24, 24 }, { 350, 25 } },
{ 1, { 24, 24 }, { 0, 975 } },
{ 1, { 24, 24 }, { 800, 375 } },
{ 1, { 24, 24 }, { 75, 750 } },
{ 1, { 24, 24 }, { 200, 125 } },
{ 1, { 24, 24 }, { 425, 425 } },
{ 1, { 24, 24 }, { 925, 600 } },
{ 1, { 24, 24 }, { 925, 300 } },
{ 1, { 24, 24 }, { 425, 925 } },
{ 1, { 24, 24 }, { 625, 350 } },
{ 1, { 24, 24 }, { 50, 225 } },
{ 1, { 24, 24 }, { 700, 725 } },
{ 1, { 24, 24 }, { 975, 850 } },
{ 1, { 24, 24 }, { 275, 275 } },
{ 2, { 24, 24 }, { 350, 50 } },
{ 1, { 24, 24 }, { 625, 550 } },
{ 2, { 24, 24 }, { 25, 275 } },
{ 1, { 24, 24 }, { 775, 500 } },
{ 2, { 24, 24 }, { 50, 50 } },
{ 1, { 24, 24 }, { 250, 125 } },
{ 1, { 24, 24 }, { 275, 300 } },
{ 1, { 24, 24 }, { 75, 100 } },
{ 1, { 24, 24 }, { 50, 750 } },
{ 1, { 24, 24 }, { 475, 675 } },
{ 1, { 24, 24 }, { 125, 900 } },
{ 1, { 24, 24 }, { 600, 300 } },
{ 1, { 24, 24 }, { 700, 100 } },
{ 1, { 24, 24 }, { 100, 150 } },
{ 2, { 24, 24 }, { 250, 75 } },
{ 1, { 24, 24 }, { 525, 625 } },
{ 1, { 24, 24 }, { 200, 975 } },
{ 1, { 24, 24 }, { 675, 300 } },
{ 1, { 24, 24 }, { 275, 675 } },
{ 1, { 24, 24 }, { 925, 275 } },
{ 1, { 24, 24 }, { 100, 625 } },
{ 1, { 24, 24 }, { 550, 700 } },
{ 1, { 24, 24 }, { 750, 25 } },
{ 1, { 24, 24 }, { 250, 100 } },
{ 1, { 24, 24 }, { 375, 350 } },
{ 2, { 24, 24 }, { 125, 125 } },
{ 1, { 24, 24 }, { 0, 275 } },
{ 1, { 24, 24 }, { 100, 375 } },
{ 1, { 24, 24 }, { 275, 850 } },
{ 1, { 24, 24 }, { 775, 450 } },
{ 1, { 24, 24 }, { 550, 50 } },
{ 1, { 24, 24 }, { 225, 750 } },
{ 1, { 24, 24 }, { 300, 475 } },
{ 2, { 24, 24 }, { 0, 100 } },
{ 1, { 24, 24 }, { 50, 900 } },
{ 1, { 24, 24 }, { 450, 225 } },
{ 1, { 24, 24 }, { 400, 225 } },
{ 1, { 24, 24 }, { 100, 300 } },
{ 1, { 24, 24 }, { 975, 325 } },
{ 1, { 24, 24 }, { 900, 500 } },
{ 1, { 24, 24 }, { 175, 25 } },
{ 1, { 24, 24 }, { 850, 600 } },
{ 1, { 24, 24 }, { 0, 675 } },
{ 1, { 24, 24 }, { 975, 275 } },
{ 1, { 24, 24 }, { 100, 450 } },
{ 1, { 24, 24 }, { 200, 400 } },
{ 1, { 24, 24 }, { 225, 175 } },
{ 1, { 24, 24 }, { 750, 800 } },
{ 1, { 24, 24 }, { 650, 950 } },
{ 1, { 24, 24 }, { 25, 750 } },
{ 1, { 24, 24 }, { 50, 850 } },
{ 1, { 24, 24 }, { 650, 450 } },
{ 1, { 24, 24 }, { 600, 400 } },
{ 1, { 24, 24 }, { 925, 825 } },
{ 1, { 24, 24 }, { 50, 150 } },
{ 1, { 24, 24 }, { 50, 600 } },
{ 1, { 24, 24 }, { 775, 325 } },
{ 1, { 24, 24 }, { 475, 75 } },
{ 1, { 24, 24 }, { 825, 125 } },
{ 1, { 24, 24 }, { 25, 200 } },
{ 1, { 24, 24 }, { 975, 875 } },
{ 1, { 24, 24 }, { 575, 700 } },
{ 1, { 24, 24 }, { 75, 675 } },
{ 1, { 24, 24 }, { 425, 525 } },
{ 2, { 24, 24 }, { 125, 0 } },
{ 1, { 24, 24 }, { 575, 200 } },
{ 1, { 24, 24 }, { 200, 625 } },
{ 2, { 24, 24 }, { 250, 25 } },
{ 1, { 24, 24 }, { 700, 625 } },
{ 1, { 24, 24 }, { 650, 525 } },
{ 1, { 24, 24 }, { 125, 0 } },
{ 1, { 24, 24 }, { 175, 400 } },
{ 1, { 24, 24 }, { 575, 600 } },
{ 1, { 24, 24 }, { 600, 225 } },
{ 2, { 24, 24 }, { 75, 225 } },
{ 1, { 24, 24 }, { 700, 950 } },
{ 1, { 24, 24 }, { 600, 25 } },
{ 1, { 24, 24 }, { 975, 300 } },
{ 1, { 24, 24 }, { 975, 925 } },
{ 1, { 24, 24 }, { 500, 75 } },
{ 1, { 24, 24 }, { 250, 300 } },
{ 1, { 24, 24 }, { 375, 550 } },
{ 1, { 24, 24 }, { 425, 275 } },
{ 1, { 24, 24 }, { 375, 675 } },
{ 1, { 24, 24 }, { 75, 400 } },
{ 1, { 24, 24 }, { 400, 275 } },
{ 1, { 24, 24 }, { 650, 650 } },
{ 1, { 24, 24 }, { 25, 325 } },
{ 1, { 24, 24 }, { 125, 225 } },
{ 1, { 24, 24 }, { 250, 600 } },
{ 1, { 24, 24 }, { 75, 425 } },
{ 1, { 24, 24 }, { 525, 175 } },
{ 2, { 24, 24 }, { 175, 75 } },
{ 1, { 24, 24 }, { 875, 50 } },
{ 2, { 24, 24 }, { 125, 150 } },
{ 1, { 24, 24 }, { 225, 100 } },
{ 1, { 24, 24 }, { 75, 225 } },
{ 1, { 24, 24 }, { 25, 150 } },
{ 1, { 24, 24 }, { 475, 550 } },
{ 1, { 24, 24 }, { 725, 500 } },
{ 1, { 24, 24 }, { 450, 975 } },
{ 1, { 24, 24 }, { 900, 0 } },
{ 1, { 24, 24 }, { 25, 400 } },
{ 1, { 24, 24 }, { 0, 125 } },
{ 1, { 24, 24 }, { 175, 625 } },
{ 1, { 24, 24 }, { 75, 475 } },
{ 1, { 24, 24 }, { 950, 225 } },
{ 1, { 24, 24 }, { 0, 850 } },
{ 1, { 24, 24 }, { 350, 25 } },
{ 1, { 24, 24 }, { 325, 950 } },
{ 1, { 24, 24 }, { 675, 575 } },
{ 1, { 24, 24 }, { 725, 50 } },
{ 1, { 24, 24 }, { 125, 800 } },
{ 1, { 24, 24 }, { 500, 50 } },
{ 1, { 24, 24 }, { 425, 75 } },
{ 1, { 24, 24 }, { 800, 700 } },
{ 1, { 24, 24 }, { 350, 325 } },
{ 2, { 24, 24 }, { 50, 250 } },
{ 1, { 24, 24 }, { 500, 100 } },
{ 1, { 24, 24 }, { 450, 200 } },
{ 1, { 24, 24 }, { 700, 850 } },
{ 1, { 24, 24 }, { 400, 775 } },
{ 1, { 24, 24 }, { 600, 600 } },
{ 1, { 24, 24 }, { 475, 0 } },
{ 1, { 24, 24 }, { 50, 75 } },
{ 1, { 24, 24 }, { 875, 925 } },
{ 1, { 24, 24 }, { 450, 500 } },
{ 1, { 24, 24 }, { 525, 750 } },
{ 1, { 24, 24 }, { 450, 575 } },
{ 1, { 24, 24 }, { 100, 275 } },
{ 1, { 24, 24 }, { 975, 150 } },
{ 1, { 24, 24 }, { 550, 250 } },
{ 1, { 24, 24 }, { 350, 750 } },
{ 1, { 24, 24 }, { 750, 175 } },
{ 1, { 24, 24 }, { 375, 725 } },
{ 1, { 24, 24 }, { 925, 175 } },
{ 1, { 24, 24 }, { 925, 250 } },
{ 1, { 24, 24 }, { 25, 275 } },
{ 1, { 24, 24 }, { 25, 300 } },
{ 1, { 24, 24 }, { 125, 150 } },
{ 2, { 24, 24 }, { 125, 75 } },
{ 1, { 24, 24 }, { 150, 875 } },
{ 1, { 24, 24 }, { 725, 425 } },
{ 1, { 24, 24 }, { 850, 325 } },
{ 1, { 24, 24 }, { 775, 650 } },
{ 1, { 24, 24 }, { 375, 500 } },
{ 1, { 24, 24 }, { 400, 400 } },
{ 1, { 24, 24 }, { 675, 200 } },
{ 1, { 24, 24 }, { 575, 175 } },
{ 1, { 24, 24 }, { 75, 150 } },
{ 1, { 24, 24 }, { 625, 900 } },
{ 1, { 24, 24 }, { 575, 575 } },
{ 1, { 24, 24 }, { 725, 0 } },
{ 1, { 24, 24 }, { 675, 50 } },
{ 1, { 24, 24 }, { 475, 750 } },
{ 2, { 24, 24 }, { 275, 25 } },
{ 1, { 24, 24 }, { 925, 700 } },
{ 1, { 24, 24 }, { 450, 650 } },
{ 1, { 24, 24 }, { 850, 0 } },
{ 2, { 24, 24 }, { 25, 200 } },
{ 1, { 24, 24 }, { 375, 250 } },
{ 2, { 24, 24 }, { 250, 125 } },
{ 1, { 24, 24 }, { 275, 600 } },
{ 1, { 24, 24 }, { 950, 450 } },
{ 1, { 24, 24 }, { 50, 50 } },
{ 1, { 24, 24 }, { 625, 800 } },
{ 1, { 24, 24 }, { 925, 475 } },
{ 1, { 24, 24 }, { 200, 325 } },
{ 1, { 24, 24 }, { 700, 750 } },
{ 1, { 24, 24 }, { 425, 50 } },
{ 1, { 24, 24 }, { 750, 125 } },
{ 1, { 24, 24 }, { 250, 850 } },
{ 1, { 24, 24 }, { 25, 600 } },
{ 2, { 24, 24 }, { 25, 150 } },
{ 1, { 24, 24 }, { 675, 775 } },
{ 1, { 24, 24 }, { 625, 75 } },
{ 1, { 24, 24 }, { 275, 800 } },
{ 1, { 24, 24 }, { 50, 250 } },
{ 1, { 24, 24 }, { 150, 500 } },
{ 1, { 24, 24 }, { 200, 475 } },
{ 1, { 24, 24 }, { 200, 0 } },
{ 1, { 24, 24 }, { 850, 175 } },
{ 1, { 24, 24 }, { 300, 350 } },
{ 2, { 24, 24 }, { 300, 100 } },
{ 1, { 24, 24 }, { 125, 275 } },
{ 1, { 24, 24 }, { 700, 500 } },
{ 1, { 24, 24 }, { 225, 300 } },
{ 1, { 24, 24 }, { 150, 475 } },
{ 1, { 24, 24 }, { 600, 625 } },
{ 1, { 24, 24 }, { 200, 575 } },
{ 1, { 24, 24 }, { 625, 300 } },
{ 1, { 24, 24 }, { 500, 725 } },
{ 1, { 24, 24 }, { 275, 525 } },
{ 1, { 24, 24 }, { 0, 225 } },
{ 1, { 24, 24 }, { 475, 125 } },
{ 1, { 24, 24 }, { 125, 400 } },
{ 1, { 24, 24 }, { 125, 450 } },
{ 1, { 24, 24 }, { 175, 900 } },
{ 1, { 24, 24 }, { 100, 725 } },
{ 1, { 24, 24 }, { 425, 400 } },
{ 1, { 24, 24 }, { 600, 875 } },
{ 1, { 24, 24 }, { 900, 375 } },
{ 1, { 24, 24 }, { 225, 225 } },
{ 2, { 24, 24 }, { 0, 325 } },
{ 1, { 24, 24 }, { 575, 550 } },
{ 1, { 24, 24 }, { 75, 275 } },
{ 1, { 24, 24 }, { 175, 550 } },
{ 1, { 24, 24 }, { 50, 625 } },
{ 1, { 24, 24 }, { 525, 875 } },
{ 1, { 24, 24 }, { 425, 650 } },
{ 1, { 24, 24 }, { 875, 525 } },
{ 1, { 24, 24 }, { 825, 550 } },
{ 1, { 24, 24 }, { 125, 75 } },
{ 2, { 24, 24 }, { 0, 250 } },
{ 1, { 24, 24 }, { 800, 50 } },
{ 1, { 24, 24 }, { 950, 650 } },
{ 1, { 24, 24 }, { 950, 725 } },
{ 1, { 24, 24 }, { 825, 825 } },
{ 1, { 24, 24 }, { 225, 325 } },
{ 1, { 24, 24 }, { 500, 400 } },
{ 1, { 24, 24 }, { 75, 300 } },
{ 1, { 24, 24 }, { 200, 600 } },
{ 1, { 24, 24 }, { 925, 200 } },
{ 1, { 24, 24 }, { 500, 550 } },
{ 1, { 24, 24 }, { 400, 325 } },
{ 1, { 24, 24 }, { 125, 700 } },
{ 1, { 24, 24 }, { 175, 50 } },
{ 1, { 24, 24 }, { 375, 450 } },
{ 1, { 24, 24 }, { 200, 550 } },
{ 1, { 24, 24 }, { 675, 675 } },
{ 1, { 24, 24 }, { 275, 225 } },
{ 1, { 24, 24 }, { 175, 725 } },
{ 1, { 24, 24 }, { 725, 25 } },
{ 1, { 24, 24 }, { 300, 375 } },
{ 1, { 24, 24 }, { 850, 150 } },
{ 1, { 24, 24 }, { 850, 975 } },
{ 1, { 24, 24 }, { 275, 625 } },
{ 1, { 24, 24 }, { 50, 400 } },
{ 1, { 24, 24 }, { 500, 525 } },
{ 1, { 24, 24 }, { 275, 125 } },
{ 2, { 24, 24 }, { 50, 175 } },
{ 1, { 24, 24 }, { 175, 425 } },
{ 1, { 24, 24 }, { 800, 125 } },
{ 1, { 24, 24 }, { 525, 225 } },
{ 1, { 24, 24 }, { 200, 150 } },
{ 1, { 24, 24 }, { 175, 0 } },
{ 1, { 24, 24 }, { 325, 200 } },
{ 1, { 24, 24 }, { 425, 675 } },
{ 1, { 24, 24 }, { 175, 275 } },
{ 1, { 24, 24 }, { 675, 900 } },
{ 1, { 24, 24 }, { 300, 275 } },
{ 1, { 24, 24 }, { 375, 125 } },
{ 1, { 24, 24 }, { 175, 775 } },
{ 1, { 24, 24 }, { 550, 125 } },
{ 1, { 24, 24 }, { 50, 275 } },
{ 1, { 24, 24 }, { 800, 350 } },
{ 1, { 24, 24 }, { 250, 25 } },
{ 1, { 24, 24 }, { 225, 550 } },
{ 2, { 24, 24 }, { 50, 275 } },
{ 1, { 24, 24 }, { 725, 575 } },
{ 1, { 24, 24 }, { 150, 400 } },
{ 1, { 24, 24 }, { 175, 575 } },
{ 1, { 24, 24 }, { 225, 675 } },
{ 1, { 24, 24 }, { 250, 225 } },
{ 1, { 24, 24 }, { 650, 500 } },
{ 1, { 24, 24 }, { 750, 950 } },
{ 1, { 24, 24 }, { 675, 750 } },
{ 1, { 24, 24 }, { 800, 600 } },
{ 1, { 24, 24 }, { 975, 200 } },
{ 1, { 24, 24 }, { 375, 875 } },
{ 1, { 24, 24 }, { 300, 325 } },
{ 1, { 24, 24 }, { 525, 0 } },
{ 1, { 24, 24 }, { 175, 375 } },
{ 1, { 24, 24 }, { 450, 600 } },
{ 1, { 24, 24 }, { 900, 725 } },
{ 1, { 24, 24 }, { 675, 450 } },
{ 1, { 24, 24 }, { 200, 50 } },
{ 1, { 24, 24 }, { 725, 850 } },
{ 1, { 24, 24 }, { 50, 675 } },
{ 1, { 24, 24 }, { 675, 975 } },
{ 1, { 24, 24 }, { 850, 625 } },
{ 1, { 24, 24 }, { 450, 475 } },
{ 1, { 24, 24 }, { 275, 425 } },
{ 1, { 24, 24 }, { 200, 350 } },
{ 1, { 24, 24 }, { 175, 700 } },
{ 1, { 24, 24 }, { 325, 25 } },
{ 1, { 24, 24 }, { 100, 675 } },
{ 1, { 24, 24 }, { 550, 350 } },
{ 1, { 24, 24 }, { 925, 75 } },
{ 1, { 24, 24 }, { 850, 375 } },
{ 1, { 24, 24 }, { 525, 125 } },
{ 1, { 24, 24 }, { 375, 750 } },
{ 1, { 24, 24 }, { 975, 500 } },
{ 1, { 24, 24 }, { 675, 125 } },
{ 1, { 24, 24 }, { 575, 275 } },
{ 2, { 24, 24 }, { 25, 100 } },
{ 1, { 24, 24 }, { 725, 225 } },
{ 1, { 24, 24 }, { 225, 125 } },
{ 2, { 24, 24 }, { 375, 50 } },
{ 2, { 24, 24 }, { 400, 25 } },
{ 2, { 24, 24 }, { 425, 0 } },
{ 1, { 24, 24 }, { 350, 900 } },
{ 1, { 24, 24 }, { 425, 550 } },
{ 1, { 24, 24 }, { 325, 300 } },
{ 1, { 24, 24 }, { 375, 575 } },
{ 1, { 24, 24 }, { 225, 725 } },
{ 2, { 24, 24 }, { 50, 350 } },
{ 1, { 24, 24 }, { 475, 575 } },
{ 1, { 24, 24 }, { 675, 850 } },
{ 1, { 24, 24 }, { 150, 550 } },
{ 1, { 24, 24 }, { 250, 575 } },
{ 1, { 24, 24 }, { 800, 575 } },
{ 1, { 24, 24 }, { 450, 425 } },
{ 1, { 24, 24 }, { 550, 875 } },
{ 1, { 24, 24 }, { 325, 500 } },
{ 2, { 24, 24 }, { 75, 325 } },
{ 1, { 24, 24 }, { 300, 850 } },
{ 1, { 24, 24 }, { 50, 650 } },
{ 1, { 24, 24 }, { 925, 900 } },
{ 1, { 24, 24 }, { 825, 525 } },
{ 1, { 24, 24 }, { 950, 950 } },
{ 2, { 24, 24 }, { 125, 275 } },
{ 1, { 24, 24 }, { 125, 550 } },
{ 2, { 24, 24 }, { 150, 250 } },
{ 2, { 24, 24 }, { 175, 225 } },
{ 1, { 24, 24 }, { 575, 475 } },
{ 1, { 24, 24 }, { 375, 700 } },
{ 1, { 24, 24 }, { 475, 350 } },
{ 1, { 24, 24 }, { 850, 700 } },
{ 1, { 24, 24 }, { 700, 50 } },
{ 1, { 24, 24 }, { 225, 575 } },
{ 1, { 24, 24 }, { 425, 475 } },
{ 1, { 24, 24 }, { 775, 900 } },
{ 1, { 24, 24 }, { 950, 550 } },
{ 1, { 24, 24 }, { 375, 825 } },
{ 2, { 24, 24 }, { 250, 150 } },
{ 1, { 24, 24 }, { 875, 350 } },
{ 2, { 24, 24 }, { 100, 50 } },
{ 2, { 24, 24 }, { 275, 125 } },
{ 1, { 24, 24 }, { 525, 100 } },
{ 1, { 24, 24 }, { 500, 850 } },
{ 1, { 24, 24 }, { 150, 375 } },
{ 1, { 24, 24 }, { 125, 375 } },
{ 1, { 24, 24 }, { 400, 200 } },
{ 2, { 24, 24 }, { 375, 25 } },
{ 2, { 24, 24 }, { 0, 75 } },
{ 1, { 24, 24 }, { 75, 0 } },
{ 1, { 24, 24 }, { 850, 825 } },
{ 1, { 24, 24 }, { 75, 725 } },
{ 1, { 24, 24 }, { 900, 600 } },
{ 2, { 24, 24 }, { 25, 350 } },
{ 1, { 24, 24 }, { 575, 300 } },
{ 1, { 24, 24 }, { 550, 150 } },
{ 1, { 24, 24 }, { 225, 400 } },
{ 1, { 24, 24 }, { 275, 200 } },
{ 2, { 24, 24 }, { 50, 325 } },
{ 1, { 24, 24 }, { 475, 200 } },
{ 1, { 24, 24 }, { 550, 400 } },
{ 1, { 24, 24 }, { 525, 200 } },
{ 1, { 24, 24 }, { 425, 775 } },
{ 1, { 24, 24 }, { 175, 475 } },
{ 2, { 24, 24 }, { 100, 275 } },
{ 2, { 24, 24 }, { 75, 300 } },
{ 1, { 24, 24 }, { 775, 825 } },
{ 1, { 24, 24 }, { 150, 125 } },
{ 1, { 24, 24 }, { 850, 100 } },
{ 1, { 24, 24 }, { 600, 325 } },
{ 1, { 24, 24 }, { 500, 25 } },
{ 1, { 24, 24 }, { 50, 375 } },
{ 1, { 24, 24 }, { 50, 725 } },
{ 1, { 24, 24 }, { 325, 875 } },
{ 2, { 24, 24 }, { 150, 225 } },
{ 1, { 24, 24 }, { 225, 875 } },
{ 1, { 24, 24 }, { 875, 400 } },
{ 1, { 24, 24 }, { 825, 250 } },
{ 1, { 24, 24 }, { 25, 900 } },
{ 1, { 24, 24 }, { 575, 125 } },
{ 1, { 24, 24 }, { 525, 350 } },
{ 2, { 24, 24 }, { 225, 150 } },
{ 1, { 24, 24 }, { 225, 200 } },
{ 2, { 24, 24 }, { 325, 50 } },
{ 1, { 24, 24 }, { 875, 825 } },
{ 1, { 24, 24 }, { 475, 650 } },
{ 2, { 24, 24 }, { 150, 25 } },
{ 1, { 24, 24 }, { 125, 600 } },
{ 1, { 24, 24 }, { 0, 375 } },
{ 2, { 24, 24 }, { 175, 200 } },
{ 2, { 24, 24 }, { 175, 175 } },
{ 1, { 24, 24 }, { 675, 150 } },
{ 2, { 24, 24 }, { 25, 325 } },
{ 1, { 24, 24 }, { 0, 550 } },
{ 2, { 24, 24 }, { 0, 350 } },
{ 2, { 24, 24 }, { 75, 275 } },
{ 1, { 24, 24 }, { 175, 250 } },
{ 1, { 24, 24 }, { 200, 450 } },
{ 2, { 24, 24 }, { 50, 300 } },
{ 1, { 24, 24 }, { 75, 200 } },
{ 1, { 24, 24 }, { 100, 200 } },
{ 1, { 24, 24 }, { 350, 550 } },
{ 1, { 24, 24 }, { 225, 650 } },
{ 1, { 24, 24 }, { 775, 150 } },
{ 2, { 24, 24 }, { 375, 0 } },
{ 1, { 24, 24 }, { 825, 325 } },
{ 1, { 24, 24 }, { 425, 375 } },
{ 2, { 24, 24 }, { 100, 25 } },
{ 2, { 24, 24 }, { 150, 200 } },
{ 2, { 24, 24 }, { 275, 0 } },
{ 2, { 24, 24 }, { 200, 150 } },
{ 2, { 24, 24 }, { 175, 0 } },
{ 1, { 24, 24 }, { 150, 525 } },
{ 1, { 24, 24 }, { 0, 175 } },
{ 2, { 24, 24 }, { 225, 125 } },
{ 2, { 24, 24 }, { 250, 100 } },
{ 2, { 24, 24 }, { 275, 75 } },
{ 1, { 24, 24 }, { 250, 0 } },
{ 1, { 24, 24 }, { 500, 175 } },
{ 1, { 24, 24 }, { 550, 25 } },
{ 2, { 24, 24 }, { 0, 225 } },
{ 1, { 24, 24 }, { 400, 750 } },
{ 1, { 24, 24 }, { 125, 250 } },
{ 1, { 24, 24 }, { 400, 525 } },
{ 1, { 24, 24 }, { 250, 950 } },
{ 1, { 24, 24 }, { 375, 800 } },
{ 2, { 24, 24 }, { 325, 25 } },
{ 2, { 24, 24 }, { 50, 25 } },
{ 2, { 24, 24 }, { 350, 0 } },
{ 1, { 24, 24 }, { 325, 675 } },
{ 2, { 24, 24 }, { 75, 250 } },
{ 1, { 24, 24 }, { 75, 250 } },
{ 2, { 24, 24 }, { 100, 225 } },
{ 2, { 24, 24 }, { 150, 175 } },
{ 2, { 24, 24 }, { 175, 150 } },
{ 1, { 24, 24 }, { 675, 225 } },
{ 1, { 24, 24 }, { 675, 650 } },
{ 2, { 24, 24 }, { 125, 200 } },
{ 1, { 24, 24 }, { 625, 200 } },
{ 2, { 24, 24 }, { 200, 125 } },
{ 1, { 24, 24 }, { 600, 750 } },
{ 2, { 24, 24 }, { 275, 50 } },
{ 1, { 24, 24 }, { 950, 475 } },
{ 1, { 24, 24 }, { 700, 575 } },
{ 1, { 24, 24 }, { 750, 350 } },
{ 2, { 24, 24 }, { 325, 0 } },
{ 1, { 24, 24 }, { 150, 100 } },
{ 1, { 24, 24 }, { 400, 975 } },
{ 1, { 24, 24 }, { 450, 400 } },
{ 2, { 24, 24 }, { 225, 100 } },
{ 2, { 24, 24 }, { 25, 0 } },
{ 1, { 24, 24 }, { 800, 725 } },
{ 1, { 24, 24 }, { 625, 175 } },
{ 1, { 24, 24 }, { 825, 0 } },
{ 1, { 24, 24 }, { 150, 75 } },
{ 1, { 24, 24 }, { 475, 925 } },
{ 1, { 24, 24 }, { 850, 125 } },
{ 2, { 24, 24 }, { 0, 300 } },
{ 1, { 24, 24 }, { 625, 850 } },
{ 2, { 24, 24 }, { 50, 125 } },
{ 2, { 24, 24 }, { 100, 200 } },
{ 1, { 24, 24 }, { 425, 625 } },
{ 1, { 24, 24 }, { 750, 900 } },
{ 1, { 24, 24 }, { 525, 800 } },
{ 2, { 24, 24 }, { 150, 150 } },
{ 1, { 24, 24 }, { 625, 0 } },
{ 2, { 24, 24 }, { 225, 75 } },
{ 1, { 24, 24 }, { 550, 175 } },
{ 1, { 24, 24 }, { 125, 625 } },
{ 2, { 24, 24 }, { 125, 250 } },
{ 2, { 24, 24 }, { 0, 275 } },
{ 1, { 24, 24 }, { 300, 725 } },
{ 1, { 24, 24 }, { 275, 100 } },
{ 1, { 24, 24 }, { 425, 250 } },
{ 2, { 24, 24 }, { 50, 225 } },
{ 1, { 24, 24 }, { 400, 250 } },
{ 1, { 24, 24 }, { 900, 700 } },
{ 1, { 24, 24 }, { 225, 775 } },
{ 1, { 24, 24 }, { 250, 350 } },
{ 2, { 24, 24 }, { 75, 200 } },
{ 1, { 24, 24 }, { 825, 800 } },
{ 2, { 24, 24 }, { 100, 175 } },
{ 1, { 24, 24 }, { 0, 0 } },
{ 1, { 24, 24 }, { 300, 450 } },
{ 1, { 24, 24 }, { 775, 850 } },
{ 2, { 24, 24 }, { 175, 100 } },
{ 2, { 24, 24 }, { 150, 125 } },
{ 2, { 24, 24 }, { 225, 50 } },
{ 2, { 24, 24 }, { 50, 200 } },
{ 2, { 24, 24 }, { 75, 175 } },
{ 1, { 24, 24 }, { 850, 225 } },
{ 1, { 24, 24 }, { 375, 625 } },
{ 1, { 24, 24 }, { 300, 75 } },
{ 1, { 24, 24 }, { 975, 625 } },
{ 1, { 24, 24 }, { 50, 800 } },
{ 1, { 24, 24 }, { 625, 500 } },
{ 1, { 24, 24 }, { 400, 25 } },
{ 1, { 24, 24 }, { 375, 950 } },
{ 1, { 24, 24 }, { 425, 450 } },
{ 2, { 24, 24 }, { 200, 50 } },
{ 1, { 24, 24 }, { 850, 725 } },
{ 2, { 24, 24 }, { 225, 25 } },
{ 1, { 24, 24 }, { 450, 550 } },
{ 1, { 24, 24 }, { 500, 0 } },
{ 1, { 24, 24 }, { 950, 525 } },
{ 1, { 24, 24 }, { 775, 675 } },
{ 2, { 24, 24 }, { 250, 0 } },
{ 1, { 24, 24 }, { 75, 650 } },
{ 2, { 24, 24 }, { 75, 150 } },
{ 1, { 24, 24 }, { 575, 975 } },
{ 2, { 24, 24 }, { 100, 125 } },
{ 1, { 24, 24 }, { 750, 425 } },
{ 1, { 24, 24 }, { 300, 0 } },
{ 1, { 24, 24 }, { 200, 375 } },
{ 1, { 24, 24 }, { 925, 650 } },
{ 1, { 24, 24 }, { 725, 750 } },
{ 1, { 24, 24 }, { 0, 625 } },
{ 2, { 24, 24 }, { 200, 75 } },
{ 1, { 24, 24 }, { 200, 875 } },
{ 2, { 24, 24 }, { 200, 25 } },
{ 2, { 24, 24 }, { 225, 0 } },
{ 1, { 24, 24 }, { 700, 825 } },
{ 2, { 24, 24 }, { 0, 200 } },
{ 2, { 24, 24 }, { 50, 150 } },
{ 1, { 24, 24 }, { 625, 925 } },
{ 1, { 24, 24 }, { 75, 50 } },
{ 2, { 24, 24 }, { 75, 125 } },
{ 1, { 24, 24 }, { 300, 525 } },
{ 1, { 24, 24 }, { 725, 375 } },
{ 1, { 24, 24 }, { 525, 50 } },
{ 2, { 24, 24 }, { 100, 100 } },
{ 1, { 24, 24 }, { 875, 150 } },
{ 1, { 24, 24 }, { 450, 375 } },
{ 2, { 24, 24 }, { 200, 0 } },
{ 2, { 24, 24 }, { 150, 50 } },
{ 2, { 24, 24 }, { 0, 175 } },
{ 1, { 24, 24 }, { 325, 350 } },
{ 2, { 24, 24 }, { 125, 175 } },
{ 1, { 24, 24 }, { 150, 850 } },
{ 2, { 24, 24 }, { 100, 75 } },
{ 1, { 24, 24 }, { 525, 400 } },
{ 1, { 24, 24 }, { 725, 150 } },
{ 1, { 24, 24 }, { 75, 950 } },
{ 1, { 24, 24 }, { 550, 325 } },
{ 1, { 24, 24 }, { 225, 425 } },
{ 1, { 24, 24 }, { 50, 0 } },
{ 1, { 24, 24 }, { 150, 750 } },
{ 1, { 24, 24 }, { 825, 725 } },
{ 1, { 24, 24 }, { 100, 100 } },
{ 2, { 24, 24 }, { 25, 125 } },
{ 1, { 24, 24 }, { 900, 825 } },
{ 2, { 24, 24 }, { 50, 100 } },
{ 2, { 24, 24 }, { 75, 75 } },
{ 2, { 24, 24 }, { 125, 25 } },
{ 1, { 24, 24 }, { 250, 675 } },
{ 1, { 24, 24 }, { 600, 800 } },
{ 1, { 24, 24 }, { 275, 375 } },
{ 2, { 24, 24 }, { 50, 75 } },
{ 2, { 24, 24 }, { 150, 0 } },
{ 1, { 24, 24 }, { 975, 125 } },
{ 1, { 24, 24 }, { 0, 750 } },
{ 1, { 24, 24 }, { 25, 650 } },
{ 2, { 24, 24 }, { 75, 50 } },
{ 2, { 24, 24 }, { 25, 25 } },
{ 2, { 24, 24 }, { 75, 25 } },
{ 1, { 24, 24 }, { 750, 625 } },
{ 1, { 24, 24 }, { 100, 800 } },
{ 1, { 24, 24 }, { 350, 125 } },
{ 2, { 24, 24 }, { 25, 50 } },
{ 1, { 24, 24 }, { 200, 425 } },
{ 1, { 24, 24 }, { 125, 325 } },
{ 2, { 24, 24 }, { 25, 75 } },
{ 1, { 24, 24 }, { 875, 425 } },
{ 1, { 24, 24 }, { 900, 250 } },
{ 2, { 24, 24 }, { 50, 0 } },
{ 2, { 24, 24 }, { 0, 25 } },
{ 2, { 24, 24 }, { 0, 0 } },
{ 1, { 24, 24 }, { 850, 475 } },
{ 1, { 24, 24 }, { 975, 950 } },
{ 1, { 24, 24 }, { 750, 150 } },
{ 1, { 24, 24 }, { 950, 975 } },
{ 1, { 24, 24 }, { 425, 500 } },
{ 1, { 24, 24 }, { 625, 950 } },
{ 1, { 24, 24 }, { 825, 100 } },
{ 1, { 24, 24 }, { 925, 975 } },
{ 2, { 24, 24 }, { 100, 300 } },
{ 1, { 24, 24 }, { 900, 975 } },
{ 1, { 24, 24 }, { 925, 950 } },
{ 1, { 24, 24 }, { 0, 300 } },
{ 1, { 24, 24 }, { 100, 775 } },
{ 1, { 24, 24 }, { 875, 900 } },
{ 1, { 24, 24 }, { 975, 900 } },
{ 1, { 24, 24 }, { 900, 950 } },
{ 1, { 24, 24 }, { 575, 350 } },
{ 1, { 24, 24 }, { 375, 175 } },
{ 1, { 24, 24 }, { 300, 400 } },
{ 1, { 24, 24 }, { 975, 650 } },
{ 1, { 24, 24 }, { 500, 775 } },
{ 1, { 24, 24 }, { 875, 975 } },
{ 1, { 24, 24 }, { 400, 600 } },
{ 1, { 24, 24 }, { 775, 300 } },
{ 1, { 24, 24 }, { 0, 475 } },
{ 1, { 24, 24 }, { 950, 900 } },
{ 1, { 24, 24 }, { 825, 200 } },
{ 1, { 24, 24 }, { 825, 50 } },
{ 1, { 24, 24 }, { 425, 575 } },
{ 1, { 24, 24 }, { 900, 925 } },
{ 1, { 24, 24 }, { 175, 175 } },
{ 1, { 24, 24 }, { 0, 425 } },
{ 1, { 24, 24 }, { 850, 750 } },
{ 1, { 24, 24 }, { 725, 325 } },
{ 1, { 24, 24 }, { 975, 425 } },
{ 1, { 24, 24 }, { 475, 325 } },
{ 1, { 24, 24 }, { 500, 700 } },
{ 1, { 24, 24 }, { 950, 850 } },
{ 1, { 24, 24 }, { 975, 825 } },
{ 1, { 24, 24 }, { 250, 925 } },
{ 1, { 24, 24 }, { 50, 325 } },
{ 1, { 24, 24 }, { 600, 775 } },
{ 1, { 24, 24 }, { 775, 625 } },
{ 1, { 24, 24 }, { 925, 875 } },
{ 1, { 24, 24 }, { 800, 975 } },
{ 1, { 24, 24 }, { 475, 625 } },
{ 1, { 24, 24 }, { 950, 925 } },
{ 1, { 24, 24 }, { 675, 550 } },
{ 1, { 24, 24 }, { 775, 75 } },
{ 1, { 24, 24 }, { 450, 125 } },
{ 1, { 24, 24 }, { 950, 825 } },
{ 1, { 24, 24 }, { 925, 850 } },
{ 1, { 24, 24 }, { 275, 725 } },
{ 1, { 24, 24 }, { 775, 975 } },
{ 1, { 24, 24 }, { 800, 950 } },
{ 1, { 24, 24 }, { 100, 850 } },
{ 1, { 24, 24 }, { 825, 925 } },
{ 1, { 24, 24 }, { 150, 250 } },
{ 1, { 24, 24 }, { 850, 900 } },
{ 1, { 24, 24 }, { 975, 775 } },
{ 1, { 24, 24 }, { 900, 850 } },
{ 1, { 24, 24 }, { 600, 700 } },
{ 1, { 24, 24 }, { 75, 450 } },
{ 1, { 24, 24 }, { 950, 800 } },
{ 1, { 24, 24 }, { 750, 975 } },
{ 1, { 24, 24 }, { 325, 125 } },
{ 1, { 24, 24 }, { 750, 275 } },
{ 1, { 24, 24 }, { 200, 200 } },
{ 1, { 24, 24 }, { 125, 650 } },
{ 1, { 24, 24 }, { 800, 925 } },
{ 1, { 24, 24 }, { 350, 500 } },
{ 1, { 24, 24 }, { 950, 300 } },
{ 1, { 24, 24 }, { 775, 275 } },
{ 1, { 24, 24 }, { 875, 850 } },
{ 1, { 24, 24 }, { 575, 900 } },
{ 1, { 24, 24 }, { 500, 150 } },
{ 1, { 24, 24 }, { 350, 0 } },
{ 1, { 24, 24 }, { 575, 825 } },
{ 1, { 24, 24 }, { 975, 750 } },
{ 1, { 24, 24 }, { 425, 25 } },
{ 1, { 24, 24 }, { 775, 925 } },
{ 1, { 24, 24 }, { 825, 875 } },
{ 1, { 24, 24 }, { 625, 750 } },
{ 1, { 24, 24 }, { 600, 725 } },
{ 1, { 24, 24 }, { 900, 800 } },
{ 1, { 24, 24 }, { 675, 400 } },
{ 1, { 24, 24 }, { 925, 775 } },
{ 1, { 24, 24 }, { 950, 750 } },
{ 1, { 24, 24 }, { 700, 975 } },
{ 1, { 24, 24 }, { 725, 950 } },
{ 1, { 24, 24 }, { 500, 200 } },
{ 1, { 24, 24 }, { 100, 400 } },
{ 1, { 24, 24 }, { 100, 0 } },
{ 1, { 24, 24 }, { 850, 850 } },
{ 1, { 24, 24 }, { 200, 850 } },
{ 1, { 24, 24 }, { 750, 925 } },
{ 1, { 24, 24 }, { 600, 900 } },
{ 1, { 24, 24 }, { 550, 775 } },
{ 1, { 24, 24 }, { 0, 350 } },
{ 1, { 24, 24 }, { 350, 150 } },
{ 1, { 24, 24 }, { 825, 850 } },
{ 2, { 24, 24 }, { 0, 375 } },
{ 1, { 24, 24 }, { 750, 750 } },
{ 1, { 24, 24 }, { 25, 0 } },
{ 1, { 24, 24 }, { 700, 25 } },
{ 1, { 24, 24 }, { 925, 750 } },
{ 1, { 24, 24 }, { 725, 925 } },
{ 2, { 24, 24 }, { 175, 125 } },
{ 1, { 24, 24 }, { 700, 375 } },
{ 2, { 24, 24 }, { 225, 175 } },
{ 1, { 24, 24 }, { 600, 250 } },
{ 1, { 24, 24 }, { 400, 450 } },
{ 1, { 24, 24 }, { 800, 850 } },
{ 1, { 24, 24 }, { 300, 300 } },
{ 1, { 24, 24 }, { 850, 800 } },
{ 1, { 24, 24 }, { 875, 775 } },
{ 1, { 24, 24 }, { 0, 575 } },
{ 1, { 24, 24 }, { 250, 150 } },
{ 1, { 24, 24 }, { 150, 975 } },
{ 1, { 24, 24 }, { 925, 725 } },
{ 1, { 24, 24 }, { 750, 700 } },
{ 1, { 24, 24 }, { 500, 500 } },
{ 1, { 24, 24 }, { 350, 200 } },
{ 1, { 24, 24 }, { 700, 325 } },
{ 1, { 24, 24 }, { 150, 725 } },
{ 1, { 24, 24 }, { 650, 975 } },
{ 1, { 24, 24 }, { 125, 925 } },
{ 1, { 24, 24 }, { 100, 350 } },
{ 1, { 24, 24 }, { 600, 200 } },
{ 1, { 24, 24 }, { 475, 400 } },
{ 1, { 24, 24 }, { 650, 50 } },
{ 1, { 24, 24 }, { 350, 75 } },
{ 1, { 24, 24 }, { 175, 850 } },
{ 1, { 24, 24 }, { 375, 225 } },
{ 1, { 24, 24 }, { 475, 375 } },
{ 1, { 24, 24 }, { 675, 275 } },
{ 1, { 24, 24 }, { 450, 0 } },
{ 1, { 24, 24 }, { 375, 775 } },
{ 1, { 24, 24 }, { 750, 875 } },
{ 1, { 24, 24 }, { 125, 675 } },
{ 1, { 24, 24 }, { 975, 675 } },
{ 1, { 24, 24 }, { 250, 775 } },
{ 1, { 24, 24 }, { 800, 825 } },
{ 1, { 24, 24 }, { 850, 775 } },
{ 1, { 24, 24 }, { 950, 675 } },
{ 1, { 24, 24 }, { 300, 200 } },
{ 1, { 24, 24 }, { 900, 75 } },
{ 1, { 24, 24 }, { 575, 800 } },
{ 1, { 24, 24 }, { 875, 500 } },
{ 1, { 24, 24 }, { 300, 800 } },
{ 1, { 24, 24 }, { 875, 750 } },
{ 1, { 24, 24 }, { 675, 925 } },
{ 1, { 24, 24 }, { 700, 900 } },
{ 1, { 24, 24 }, { 450, 75 } },
{ 1, { 24, 24 }, { 725, 200 } },
{ 1, { 24, 24 }, { 725, 875 } },
{ 1, { 24, 24 }, { 925, 550 } },
{ 1, { 24, 24 }, { 975, 50 } },
{ 1, { 24, 24 }, { 325, 375 } },
{ 1, { 24, 24 }, { 575, 250 } },
{ 1, { 24, 24 }, { 950, 875 } },
{ 1, { 24, 24 }, { 175, 125 } },
{ 1, { 24, 24 }, { 275, 150 } },
{ 1, { 24, 24 }, { 925, 675 } },
{ 1, { 24, 24 }, { 350, 625 } },
{ 1, { 24, 24 }, { 125, 350 } },
{ 1, { 24, 24 }, { 275, 925 } },
{ 1, { 24, 24 }, { 575, 450 } },
{ 1, { 24, 24 }, { 250, 900 } },
{ 1, { 24, 24 }, { 650, 925 } },
{ 1, { 24, 24 }, { 700, 875 } },
{ 1, { 24, 24 }, { 750, 825 } },
{ 1, { 24, 24 }, { 550, 0 } },
{ 1, { 24, 24 }, { 775, 800 } },
{ 1, { 24, 24 }, { 25, 375 } },
{ 1, { 24, 24 }, { 0, 600 } },
{ 1, { 24, 24 }, { 625, 250 } },
{ 1, { 24, 24 }, { 800, 775 } },
{ 1, { 24, 24 }, { 600, 100 } },
{ 1, { 24, 24 }, { 825, 750 } },
{ 1, { 24, 24 }, { 350, 400 } },
{ 1, { 24, 24 }, { 225, 800 } },
{ 1, { 24, 24 }, { 925, 100 } },
{ 1, { 24, 24 }, { 900, 675 } },
{ 1, { 24, 24 }, { 700, 150 } },
{ 1, { 24, 24 }, { 175, 225 } },
{ 1, { 24, 24 }, { 600, 475 } },
{ 1, { 24, 24 }, { 0, 250 } },
{ 1, { 24, 24 }, { 275, 250 } },
{ 1, { 24, 24 }, { 400, 50 } },
{ 1, { 24, 24 }, { 675, 625 } },
{ 1, { 24, 24 }, { 0, 500 } },
{ 1, { 24, 24 }, { 475, 875 } },
{ 1, { 24, 24 }, { 300, 900 } },
{ 1, { 24, 24 }, { 525, 550 } },
{ 1, { 24, 24 }, { 600, 925 } },
{ 2, { 24, 24 }, { 125, 100 } },
{ 1, { 24, 24 }, { 900, 175 } },
{ 1, { 24, 24 }, { 950, 625 } },
{ 1, { 24, 24 }, { 525, 725 } },
{ 1, { 24, 24 }, { 550, 500 } },
{ 1, { 24, 24 }, { 275, 50 } },
{ 1, { 24, 24 }, { 975, 600 } },
{ 1, { 24, 24 }, { 200, 500 } },
{ 1, { 24, 24 }, { 500, 650 } },
{ 1, { 24, 24 }, { 475, 850 } },
{ 1, { 24, 24 }, { 125, 25 } },
{ 1, { 24, 24 }, { 275, 500 } },
{ 1, { 24, 24 }, { 0, 200 } },
{ 1, { 24, 24 }, { 675, 425 } },
{ 1, { 24, 24 }, { 975, 400 } },
{ 1, { 24, 24 }, { 650, 900 } },
{ 1, { 24, 24 }, { 825, 700 } },
{ 1, { 24, 24 }, { 150, 825 } },
{ 1, { 24, 24 }, { 800, 500 } },
{ 1, { 24, 24 }, { 325, 750 } },
{ 1, { 24, 24 }, { 775, 175 } },
{ 1, { 24, 24 }, { 325, 600 } },
{ 1, { 24, 24 }, { 800, 750 } },
{ 1, { 24, 24 }, { 975, 0 } },
{ 2, { 24, 24 }, { 200, 200 } },
{ 2, { 24, 24 }, { 300, 75 } },
{ 1, { 24, 24 }, { 900, 650 } },
{ 1, { 24, 24 }, { 625, 100 } },
{ 1, { 24, 24 }, { 875, 0 } },
{ 1, { 24, 24 }, { 900, 50 } },
{ 1, { 24, 24 }, { 200, 525 } },
{ 1, { 24, 24 }, { 75, 75 } },
{ 1, { 24, 24 }, { 925, 625 } },
{ 1, { 24, 24 }, { 950, 600 } },
{ 1, { 24, 24 }, { 650, 850 } },
{ 1, { 24, 24 }, { 50, 500 } },
{ 1, { 24, 24 }, { 950, 575 } },
{ 1, { 24, 24 }, { 100, 175 } },
{ 1, { 24, 24 }, { 325, 75 } },
{ 1, { 24, 24 }, { 650, 875 } },
{ 2, { 24, 24 }, { 25, 175 } },
{ 1, { 24, 24 }, { 725, 800 } },
{ 1, { 24, 24 }, { 575, 675 } },
{ 1, { 24, 24 }, { 475, 425 } },
{ 1, { 24, 24 }, { 775, 750 } },
{ 1, { 24, 24 }, { 225, 250 } },
{ 1, { 24, 24 }, { 725, 600 } },
{ 1, { 24, 24 }, { 525, 600 } },
{ 1, { 24, 24 }, { 650, 700 } },
{ 1, { 24, 24 }, { 300, 625 } },
{ 1, { 24, 24 }, { 875, 650 } },
{ 1, { 24, 24 }, { 900, 625 } },
{ 1, { 24, 24 }, { 575, 950 } },
{ 1, { 24, 24 }, { 250, 825 } },
{ 1, { 24, 24 }, { 200, 950 } },
{ 1, { 24, 24 }, { 975, 550 } },
{ 1, { 24, 24 }, { 250, 650 } },
{ 1, { 24, 24 }, { 550, 950 } },
{ 1, { 24, 24 }, { 450, 950 } },
{ 1, { 24, 24 }, { 375, 300 } },
{ 1, { 24, 24 }, { 125, 175 } },
{ 1, { 24, 24 }, { 625, 875 } },
{ 1, { 24, 24 }, { 550, 975 } },
{ 1, { 24, 24 }, { 675, 825 } },
{ 1, { 24, 24 }, { 700, 800 } },
{ 1, { 24, 24 }, { 0, 650 } },
{ 1, { 24, 24 }, { 875, 800 } },
{ 1, { 24, 24 }, { 925, 375 } },
{ 1, { 24, 24 }, { 500, 975 } },
{ 1, { 24, 24 }, { 525, 375 } },
{ 1, { 24, 24 }, { 850, 75 } },
{ 1, { 24, 24 }, { 600, 150 } },
{ 1, { 24, 24 }, { 175, 200 } },
{ 1, { 24, 24 }, { 800, 325 } },
{ 1, { 24, 24 }, { 750, 450 } },
{ 1, { 24, 24 }, { 800, 675 } },
{ 1, { 24, 24 }, { 50, 175 } },
{ 1, { 24, 24 }, { 825, 675 } },
{ 1, { 24, 24 }, { 375, 375 } },
{ 1, { 24, 24 }, { 50, 475 } },
{ 1, { 24, 24 }, { 250, 425 } },
{ 1, { 24, 24 }, { 800, 400 } },
{ 1, { 24, 24 }, { 450, 100 } },
{ 1, { 24, 24 }, { 250, 475 } },
{ 1, { 24, 24 }, { 350, 250 } },
{ 1, { 24, 24 }, { 875, 725 } },
{ 2, { 24, 24 }, { 400, 0 } },
{ 1, { 24, 24 }, { 925, 575 } },
{ 1, { 24, 24 }, { 975, 525 } },
{ 1, { 24, 24 }, { 475, 975 } },
{ 1, { 24, 24 }, { 0, 875 } },
{ 1, { 24, 24 }, { 900, 400 } },
{ 1, { 24, 24 }, { 650, 825 } },
{ 1, { 24, 24 }, { 150, 275 } },
{ 1, { 24, 24 }, { 675, 800 } },
{ 1, { 24, 24 }, { 700, 775 } },
{ 1, { 24, 24 }, { 875, 300 } },
{ 1, { 24, 24 }, { 450, 150 } },
{ 2, { 24, 24 }, { 150, 75 } },
{ 1, { 24, 24 }, { 650, 625 } },
{ 1, { 24, 24 }, { 750, 725 } },
{ 1, { 24, 24 }, { 450, 800 } },
{ 2, { 24, 24 }, { 125, 225 } },
{ 1, { 24, 24 }, { 100, 475 } },
{ 1, { 24, 24 }, { 775, 725 } },
{ 1, { 24, 24 }, { 375, 475 } },
{ 1, { 24, 24 }, { 125, 525 } },
{ 1, { 24, 24 }, { 825, 650 } },
{ 1, { 24, 24 }, { 875, 600 } },
{ 1, { 24, 24 }, { 900, 575 } },
{ 1, { 24, 24 }, { 475, 600 } },
{ 1, { 24, 24 }, { 800, 800 } },
{ 1, { 24, 24 }, { 500, 950 } },
{ 1, { 24, 24 }, { 75, 550 } },
{ 1, { 24, 24 }, { 525, 950 } },
{ 1, { 24, 24 }, { 350, 700 } },
{ 1, { 24, 24 }, { 550, 900 } },
{ 1, { 24, 24 }, { 650, 275 } },
{ 1, { 24, 24 }, { 575, 875 } },
{ 1, { 24, 24 }, { 0, 75 } },
{ 1, { 24, 24 }, { 100, 875 } },
{ 1, { 24, 24 }, { 275, 550 } },
{ 1, { 24, 24 }, { 175, 300 } },
{ 1, { 24, 24 }, { 850, 350 } },
{ 1, { 24, 24 }, { 200, 250 } },
{ 1, { 24, 24 }, { 500, 825 } },
{ 1, { 24, 24 }, { 50, 550 } },
{ 1, { 24, 24 }, { 325, 250 } },
{ 1, { 24, 24 }, { 200, 700 } },
{ 1, { 24, 24 }, { 950, 175 } },
{ 1, { 24, 24 }, { 900, 200 } },
{ 1, { 24, 24 }, { 650, 800 } },
{ 1, { 24, 24 }, { 725, 725 } },
{ 1, { 24, 24 }, { 800, 650 } },
{ 1, { 24, 24 }, { 675, 175 } },
{ 1, { 24, 24 }, { 875, 575 } },
{ 1, { 24, 24 }, { 775, 425 } },
{ 1, { 24, 24 }, { 600, 350 } },
{ 1, { 24, 24 }, { 900, 550 } },
{ 1, { 24, 24 }, { 575, 375 } },
{ 1, { 24, 24 }, { 750, 500 } },
{ 1, { 24, 24 }, { 825, 275 } },
{ 1, { 24, 24 }, { 400, 375 } },
{ 1, { 24, 24 }, { 300, 425 } },
{ 1, { 24, 24 }, { 550, 75 } },
{ 1, { 24, 24 }, { 25, 25 } },
{ 1, { 24, 24 }, { 0, 325 } },
{ 1, { 24, 24 }, { 475, 775 } },
{ 1, { 24, 24 }, { 950, 500 } },
{ 1, { 24, 24 }, { 275, 450 } },
{ 1, { 24, 24 }, { 625, 275 } },
{ 1, { 24, 24 }, { 175, 650 } },
{ 1, { 24, 24 }, { 100, 650 } },
{ 1, { 24, 24 }, { 725, 125 } },
{ 1, { 24, 24 }, { 450, 825 } },
{ 1, { 24, 24 }, { 275, 325 } },
{ 1, { 24, 24 }, { 500, 925 } },
{ 1, { 24, 24 }, { 100, 425 } },
{ 1, { 24, 24 }, { 100, 75 } },
{ 1, { 24, 24 }, { 975, 25 } },
{ 2, { 24, 24 }, { 300, 50 } },
{ 1, { 24, 24 }, { 825, 900 } },
{ 1, { 24, 24 }, { 650, 775 } },
{ 1, { 24, 24 }, { 725, 700 } },
{ 1, { 24, 24 }, { 800, 625 } },
{ 1, { 24, 24 }, { 100, 550 } },
{ 1, { 24, 24 }, { 825, 600 } },
{ 1, { 24, 24 }, { 850, 575 } },
{ 1, { 24, 24 }, { 875, 550 } },
{ 1, { 24, 24 }, { 50, 975 } },
{ 1, { 24, 24 }, { 650, 325 } },
{ 1, { 24, 24 }, { 925, 500 } },
{ 2, { 24, 24 }, { 300, 25 } },
{ 1, { 24, 24 }, { 300, 100 } },
{ 1, { 24, 24 }, { 800, 550 } },
{ 1, { 24, 24 }, { 575, 925 } },
{ 1, { 24, 24 }, { 400, 125 } },
{ 1, { 24, 24 }, { 675, 250 } },
{ 1, { 24, 24 }, { 425, 975 } },
{ 1, { 24, 24 }, { 25, 500 } },
{ 1, { 24, 24 }, { 500, 900 } },
{ 1, { 24, 24 }, { 750, 675 } },
{ 1, { 24, 24 }, { 550, 850 } },
{ 1, { 24, 24 }, { 725, 975 } },
{ 1, { 24, 24 }, { 450, 25 } },
{ 1, { 24, 24 }, { 800, 250 } },
{ 1, { 24, 24 }, { 150, 175 } },
{ 1, { 24, 24 }, { 250, 175 } },
{ 1, { 24, 24 }, { 475, 525 } },
{ 1, { 24, 24 }, { 600, 125 } },
{ 1, { 24, 24 }, { 700, 125 } },
{ 1, { 24, 24 }, { 250, 75 } },
{ 1, { 24, 24 }, { 975, 700 } },
{ 1, { 24, 24 }, { 625, 775 } },
{ 1, { 24, 24 }, { 675, 725 } },
{ 1, { 24, 24 }, { 150, 700 } },
{ 1, { 24, 24 }, { 725, 675 } },
{ 1, { 24, 24 }, { 700, 700 } },
{ 1, { 24, 24 }, { 725, 650 } },
{ 1, { 24, 24 }, { 825, 575 } },
{ 1, { 24, 24 }, { 850, 550 } },
{ 1, { 24, 24 }, { 750, 650 } },
{ 1, { 24, 24 }, { 850, 950 } },
{ 1, { 24, 24 }, { 550, 200 } },
{ 1, { 24, 24 }, { 450, 925 } },
{ 1, { 24, 24 }, { 475, 900 } },
{ 1, { 24, 24 }, { 675, 475 } },
{ 1, { 24, 24 }, { 875, 225 } },
{ 1, { 24, 24 }, { 800, 450 } },
{ 1, { 24, 24 }, { 425, 850 } },
{ 1, { 24, 24 }, { 650, 250 } },
{ 1, { 24, 24 }, { 500, 875 } },
{ 1, { 24, 24 }, { 825, 775 } },
{ 1, { 24, 24 }, { 550, 825 } },
{ 1, { 24, 24 }, { 425, 950 } },
{ 1, { 24, 24 }, { 950, 75 } },
{ 1, { 24, 24 }, { 625, 975 } },
{ 1, { 24, 24 }, { 650, 725 } },
{ 1, { 24, 24 }, { 0, 725 } },
{ 1, { 24, 24 }, { 550, 675 } },
{ 1, { 24, 24 }, { 450, 625 } },
{ 1, { 24, 24 }, { 475, 50 } },
{ 1, { 24, 24 }, { 800, 900 } },
{ 1, { 24, 24 }, { 175, 875 } },
{ 1, { 24, 24 }, { 875, 375 } },
{ 2, { 24, 24 }, { 100, 0 } },
{ 1, { 24, 24 }, { 325, 150 } },
{ 1, { 24, 24 }, { 525, 450 } },
{ 1, { 24, 24 }, { 850, 525 } },
{ 1, { 24, 24 }, { 25, 550 } },
{ 1, { 24, 24 }, { 625, 50 } },
{ 1, { 24, 24 }, { 475, 825 } },
{ 1, { 24, 24 }, { 525, 250 } },
{ 1, { 24, 24 }, { 325, 825 } },
{ 1, { 24, 24 }, { 950, 425 } },
{ 1, { 24, 24 }, { 400, 0 } },
{ 1, { 24, 24 }, { 375, 975 } },
{ 1, { 24, 24 }, { 400, 950 } },
{ 1, { 24, 24 }, { 0, 400 } },
{ 1, { 24, 24 }, { 775, 600 } },
{ 1, { 24, 24 }, { 325, 475 } },
{ 1, { 24, 24 }, { 350, 600 } },
{ 1, { 24, 24 }, { 975, 350 } },
{ 1, { 24, 24 }, { 750, 475 } },
{ 1, { 24, 24 }, { 525, 325 } },
{ 1, { 24, 24 }, { 525, 825 } },
{ 1, { 24, 24 }, { 625, 225 } },
{ 1, { 24, 24 }, { 500, 300 } },
{ 1, { 24, 24 }, { 575, 775 } },
{ 1, { 24, 24 }, { 275, 175 } },
{ 1, { 24, 24 }, { 575, 425 } },
{ 2, { 24, 24 }, { 325, 75 } },
{ 1, { 24, 24 }, { 850, 675 } },
{ 1, { 24, 24 }, { 700, 650 } },
{ 1, { 24, 24 }, { 725, 625 } },
{ 1, { 24, 24 }, { 750, 600 } },
{ 1, { 24, 24 }, { 625, 400 } },
{ 1, { 24, 24 }, { 775, 575 } },
{ 1, { 24, 24 }, { 300, 825 } },
{ 1, { 24, 24 }, { 300, 775 } },
{ 1, { 24, 24 }, { 100, 750 } },
{ 1, { 24, 24 }, { 575, 50 } },
{ 1, { 24, 24 }, { 125, 975 } },
{ 1, { 24, 24 }, { 900, 450 } },
{ 1, { 24, 24 }, { 325, 275 } },
{ 1, { 24, 24 }, { 925, 425 } },
{ 1, { 24, 24 }, { 25, 225 } },
{ 1, { 24, 24 }, { 950, 400 } },
{ 1, { 24, 24 }, { 975, 375 } },
{ 1, { 24, 24 }, { 275, 875 } },
{ 1, { 24, 24 }, { 650, 225 } },
{ 1, { 24, 24 }, { 550, 375 } },
{ 1, { 24, 24 }, { 350, 975 } },
{ 1, { 24, 24 }, { 375, 400 } },
{ 1, { 24, 24 }, { 750, 575 } },
{ 1, { 24, 24 }, { 450, 875 } },
{ 1, { 24, 24 }, { 800, 875 } },
{ 1, { 24, 24 }, { 575, 750 } },
{ 1, { 24, 24 }, { 625, 700 } },
{ 1, { 24, 24 }, { 550, 275 } },
{ 1, { 24, 24 }, { 600, 850 } },
{ 1, { 24, 24 }, { 575, 225 } },
{ 1, { 24, 24 }, { 450, 675 } },
{ 1, { 24, 24 }, { 550, 600 } },
{ 1, { 24, 24 }, { 425, 350 } },
{ 1, { 24, 24 }, { 225, 450 } },
{ 1, { 24, 24 }, { 175, 500 } },
{ 1, { 24, 24 }, { 425, 900 } },
{ 1, { 24, 24 }, { 100, 225 } },
{ 1, { 24, 24 }, { 825, 375 } },
{ 1, { 24, 24 }, { 50, 350 } },
{ 1, { 24, 24 }, { 675, 375 } },
{ 1, { 24, 24 }, { 25, 625 } },
{ 1, { 24, 24 }, { 275, 575 } },
{ 1, { 24, 24 }, { 950, 25 } },
{ 1, { 24, 24 }, { 575, 525 } },
{ 1, { 24, 24 }, { 300, 600 } },
{ 1, { 24, 24 }, { 275, 825 } },
{ 1, { 24, 24 }, { 775, 550 } },
{ 1, { 24, 24 }, { 975, 975 } },
{ 1, { 24, 24 }, { 825, 500 } },
{ 1, { 24, 24 }, { 225, 25 } },
{ 1, { 24, 24 }, { 900, 425 } },
{ 1, { 24, 24 }, { 650, 175 } },
{ 1, { 24, 24 }, { 925, 400 } },
{ 1, { 24, 24 }, { 950, 375 } },
{ 1, { 24, 24 }, { 875, 450 } },
{ 1, { 24, 24 }, { 450, 900 } },
{ 1, { 24, 24 }, { 325, 975 } },
{ 1, { 24, 24 }, { 800, 100 } },
{ 1, { 24, 24 }, { 225, 975 } },
{ 1, { 24, 24 }, { 350, 950 } },
{ 1, { 24, 24 }, { 400, 900 } },
{ 1, { 24, 24 }, { 525, 650 } },
{ 1, { 24, 24 }, { 525, 775 } },
{ 1, { 24, 24 }, { 375, 925 } },
{ 1, { 24, 24 }, { 775, 775 } },
{ 1, { 24, 24 }, { 375, 150 } },
{ 1, { 24, 24 }, { 950, 200 } },
{ 1, { 24, 24 }, { 600, 425 } },
{ 1, { 24, 24 }, { 900, 475 } },
{ 1, { 24, 24 }, { 225, 475 } },
{ 1, { 24, 24 }, { 525, 975 } },
{ 1, { 24, 24 }, { 150, 325 } },
{ 1, { 24, 24 }, { 775, 100 } },
{ 1, { 24, 24 }, { 575, 725 } },
{ 1, { 24, 24 }, { 625, 675 } },
{ 1, { 24, 24 }, { 550, 800 } },
{ 1, { 24, 24 }, { 175, 100 } },
{ 1, { 24, 24 }, { 775, 525 } },
{ 1, { 24, 24 }, { 425, 875 } },
{ 2, { 24, 24 }, { 250, 50 } },
{ 1, { 24, 24 }, { 325, 225 } },
{ 1, { 24, 24 }, { 850, 450 } },
{ 1, { 24, 24 }, { 550, 925 } },
{ 1, { 24, 24 }, { 25, 350 } },
{ 1, { 24, 24 }, { 700, 250 } },
{ 1, { 24, 24 }, { 850, 425 } },
{ 1, { 24, 24 }, { 250, 400 } },
{ 1, { 24, 24 }, { 950, 350 } },
{ 1, { 24, 24 }, { 300, 975 } },
{ 1, { 24, 24 }, { 900, 350 } },
{ 1, { 24, 24 }, { 400, 875 } },
{ 1, { 24, 24 }, { 350, 925 } },
{ 1, { 24, 24 }, { 475, 800 } },
{ 1, { 24, 24 }, { 925, 925 } },
{ 1, { 24, 24 }, { 175, 75 } },
{ 1, { 24, 24 }, { 550, 725 } },
{ 1, { 24, 24 }, { 600, 675 } },
{ 1, { 24, 24 }, { 625, 650 } },
{ 1, { 24, 24 }, { 300, 50 } },
{ 1, { 24, 24 }, { 675, 600 } },
{ 1, { 24, 24 }, { 750, 300 } },
{ 1, { 24, 24 }, { 750, 525 } },
{ 1, { 24, 24 }, { 825, 450 } },
{ 1, { 24, 24 }, { 650, 475 } },
{ 1, { 24, 24 }, { 225, 50 } },
{ 1, { 24, 24 }, { 800, 475 } },
{ 1, { 24, 24 }, { 700, 600 } },
{ 2, { 24, 24 }, { 200, 175 } },
{ 1, { 24, 24 }, { 125, 775 } },
{ 1, { 24, 24 }, { 650, 400 } },
{ 1, { 24, 24 }, { 300, 950 } },
{ 1, { 24, 24 }, { 325, 925 } },
{ 1, { 24, 24 }, { 550, 450 } },
{ 1, { 24, 24 }, { 425, 825 } },
{ 1, { 24, 24 }, { 400, 850 } },
{ 1, { 24, 24 }, { 500, 750 } },
{ 1, { 24, 24 }, { 600, 650 } },
{ 1, { 24, 24 }, { 750, 775 } },
{ 1, { 24, 24 }, { 575, 500 } },
{ 1, { 24, 24 }, { 625, 625 } },
{ 1, { 24, 24 }, { 25, 425 } },
{ 1, { 24, 24 }, { 550, 575 } },
{ 1, { 24, 24 }, { 725, 525 } },
{ 1, { 24, 24 }, { 825, 425 } },
{ 1, { 24, 24 }, { 850, 400 } },
{ 1, { 24, 24 }, { 925, 800 } },
{ 1, { 24, 24 }, { 150, 50 } },
{ 1, { 24, 24 }, { 0, 50 } },
{ 1, { 24, 24 }, { 600, 825 } },
{ 1, { 24, 24 }, { 50, 125 } },
{ 1, { 24, 24 }, { 250, 975 } },
{ 1, { 24, 24 }, { 25, 75 } },
{ 1, { 24, 24 }, { 275, 950 } },
{ 1, { 24, 24 }, { 175, 675 } },
{ 1, { 24, 24 }, { 125, 575 } },
{ 1, { 24, 24 }, { 925, 50 } },
{ 1, { 24, 24 }, { 500, 225 } },
{ 1, { 24, 24 }, { 300, 150 } },
{ 1, { 24, 24 }, { 550, 425 } },
{ 1, { 24, 24 }, { 375, 900 } },
{ 1, { 24, 24 }, { 275, 775 } },
{ 1, { 24, 24 }, { 750, 75 } },
{ 1, { 24, 24 }, { 250, 700 } },
{ 1, { 24, 24 }, { 50, 775 } },
{ 1, { 24, 24 }, { 350, 875 } },
{ 1, { 24, 24 }, { 400, 825 } },
{ 1, { 24, 24 }, { 150, 225 } },
{ 1, { 24, 24 }, { 400, 550 } },
{ 1, { 24, 24 }, { 425, 800 } },
{ 1, { 24, 24 }, { 525, 700 } },
{ 1, { 24, 24 }, { 675, 0 } },
{ 1, { 24, 24 }, { 800, 0 } },
{ 1, { 24, 24 }, { 625, 600 } },
{ 1, { 24, 24 }, { 650, 575 } },
{ 1, { 24, 24 }, { 275, 700 } },
{ 1, { 24, 24 }, { 900, 875 } },
{ 1, { 24, 24 }, { 325, 0 } },
{ 1, { 24, 24 }, { 225, 925 } },
{ 1, { 24, 24 }, { 200, 825 } },
{ 1, { 24, 24 }, { 200, 900 } },
{ 1, { 24, 24 }, { 550, 300 } },
{ 1, { 24, 24 }, { 625, 125 } },
{ 1, { 24, 24 }, { 825, 400 } },
{ 1, { 24, 24 }, { 125, 425 } },
{ 1, { 24, 24 }, { 425, 700 } },
{ 1, { 24, 24 }, { 950, 275 } },
{ 1, { 24, 24 }, { 975, 250 } },
{ 1, { 24, 24 }, { 400, 350 } },
{ 1, { 24, 24 }, { 350, 850 } },
{ 1, { 24, 24 }, { 200, 650 } },
{ 1, { 24, 24 }, { 400, 800 } },
{ 1, { 24, 24 }, { 675, 525 } },
{ 1, { 24, 24 }, { 375, 25 } },
{ 1, { 24, 24 }, { 350, 575 } },
{ 1, { 24, 24 }, { 450, 750 } },
{ 1, { 24, 24 }, { 600, 175 } },
{ 1, { 24, 24 }, { 475, 725 } },
{ 1, { 24, 24 }, { 900, 900 } },
{ 1, { 24, 24 }, { 625, 475 } },
{ 1, { 24, 24 }, { 25, 925 } },
{ 1, { 24, 24 }, { 375, 75 } },
{ 1, { 24, 24 }, { 600, 375 } },
{ 1, { 24, 24 }, { 750, 0 } },
{ 1, { 24, 24 }, { 25, 950 } },
{ 1, { 24, 24 }, { 625, 575 } },
{ 1, { 24, 24 }, { 550, 650 } },
{ 1, { 24, 24 }, { 650, 550 } },
{ 1, { 24, 24 }, { 400, 475 } },
{ 1, { 24, 24 }, { 725, 475 } },
{ 1, { 24, 24 }, { 100, 900 } },
{ 1, { 24, 24 }, { 0, 450 } },
{ 1, { 24, 24 }, { 125, 100 } },
{ 1, { 24, 24 }, { 650, 675 } },
{ 1, { 24, 24 }, { 150, 350 } },
{ 1, { 24, 24 }, { 875, 325 } },
{ 1, { 24, 24 }, { 900, 300 } },
{ 1, { 24, 24 }, { 750, 50 } },
{ 1, { 24, 24 }, { 375, 275 } },
{ 1, { 24, 24 }, { 975, 225 } },
{ 1, { 24, 24 }, { 525, 25 } },
{ 1, { 24, 24 }, { 275, 0 } },
{ 1, { 24, 24 }, { 875, 625 } },
{ 1, { 24, 24 }, { 225, 950 } },
{ 1, { 24, 24 }, { 550, 100 } },
{ 1, { 24, 24 }, { 275, 900 } },
{ 1, { 24, 24 }, { 325, 775 } },
{ 1, { 24, 24 }, { 350, 300 } },
{ 1, { 24, 24 }, { 100, 950 } },
{ 1, { 24, 24 }, { 350, 825 } },
{ 1, { 24, 24 }, { 575, 325 } },
{ 1, { 24, 24 }, { 575, 850 } },
{ 1, { 24, 24 }, { 400, 150 } },
{ 1, { 24, 24 }, { 325, 400 } },
{ 1, { 24, 24 }, { 725, 775 } },
{ 1, { 24, 24 }, { 450, 725 } },
{ 1, { 24, 24 }, { 650, 75 } },
{ 1, { 24, 24 }, { 650, 25 } },
{ 1, { 24, 24 }, { 225, 500 } },
{ 1, { 24, 24 }, { 225, 0 } },
{ 1, { 24, 24 }, { 125, 125 } },
{ 1, { 24, 24 }, { 425, 750 } },
{ 1, { 24, 24 }, { 500, 675 } },
{ 1, { 24, 24 }, { 475, 700 } },
{ 1, { 24, 24 }, { 250, 800 } },
{ 1, { 24, 24 }, { 175, 950 } },
{ 1, { 24, 24 }, { 675, 500 } },
{ 1, { 24, 24 }, { 125, 500 } },
{ 1, { 24, 24 }, { 475, 225 } },
{ 1, { 24, 24 }, { 75, 600 } },
{ 1, { 24, 24 }, { 625, 425 } },
{ 1, { 24, 24 }, { 700, 475 } },
{ 1, { 24, 24 }, { 775, 400 } },
{ 1, { 24, 24 }, { 650, 0 } },
{ 1, { 24, 24 }, { 725, 450 } },
{ 1, { 24, 24 }, { 900, 225 } },
{ 1, { 24, 24 }, { 775, 0 } },
{ 1, { 24, 24 }, { 900, 275 } },
{ 1, { 24, 24 }, { 775, 875 } },
{ 1, { 24, 24 }, { 800, 225 } },
{ 1, { 24, 24 }, { 175, 975 } },
{ 1, { 24, 24 }, { 700, 525 } },
{ 1, { 24, 24 }, { 400, 425 } },
{ 1, { 24, 24 }, { 500, 450 } },
{ 1, { 24, 24 }, { 600, 975 } },
{ 1, { 24, 24 }, { 150, 150 } },
{ 1, { 24, 24 }, { 100, 50 } },
{ 1, { 24, 24 }, { 925, 450 } },
{ 1, { 24, 24 }, { 125, 50 } },
{ 1, { 24, 24 }, { 250, 725 } },
{ 1, { 24, 24 }, { 50, 25 } },
{ 1, { 24, 24 }, { 350, 800 } },
{ 1, { 24, 24 }, { 425, 725 } },
{ 1, { 24, 24 }, { 875, 250 } },
{ 1, { 24, 24 }, { 850, 300 } },
{ 1, { 24, 24 }, { 325, 100 } },
{ 1, { 24, 24 }, { 175, 600 } },
{ 1, { 24, 24 }, { 600, 950 } },
{ 1, { 24, 24 }, { 625, 525 } },
{ 1, { 24, 24 }, { 550, 475 } },
{ 1, { 24, 24 }, { 525, 275 } },
{ 1, { 24, 24 }, { 300, 875 } },
{ 1, { 24, 24 }, { 875, 950 } },
{ 1, { 24, 24 }, { 775, 375 } },
{ 1, { 24, 24 }, { 875, 275 } },
{ 2, { 24, 24 }, { 0, 50 } },
{ 1, { 24, 24 }, { 225, 275 } },
{ 1, { 24, 24 }, { 925, 225 } },
{ 1, { 24, 24 }, { 0, 100 } },
{ 1, { 24, 24 }, { 975, 175 } },
{ 1, { 24, 24 }, { 425, 175 } },
{ 1, { 24, 24 }, { 150, 625 } },
{ 1, { 24, 24 }, { 575, 0 } },
{ 1, { 24, 24 }, { 475, 450 } },
{ 1, { 24, 24 }, { 900, 750 } },
{ 1, { 24, 24 }, { 475, 175 } },
{ 1, { 24, 24 }, { 600, 575 } },
{ 1, { 24, 24 }, { 500, 325 } },
{ 1, { 24, 24 }, { 525, 575 } },
{ 1, { 24, 24 }, { 225, 900 } },
{ 1, { 24, 24 }, { 675, 100 } },
{ 1, { 24, 24 }, { 250, 875 } },
{ 1, { 24, 24 }, { 850, 500 } },
{ 2, { 24, 24 }, { 100, 150 } },
{ 1, { 24, 24 }, { 525, 675 } },
{ 1, { 24, 24 }, { 500, 625 } },
{ 1, { 24, 24 }, { 700, 550 } },
{ 2, { 24, 24 }, { 150, 100 } },
{ 1, { 24, 24 }, { 700, 425 } },
{ 1, { 24, 24 }, { 600, 525 } },
{ 1, { 24, 24 }, { 625, 450 } },
{ 1, { 24, 24 }, { 50, 525 } },
{ 1, { 24, 24 }, { 825, 300 } },
{ 1, { 24, 24 }, { 850, 275 } },
{ 1, { 24, 24 }, { 600, 550 } },
{ 1, { 24, 24 }, { 800, 25 } },
{ 1, { 24, 24 }, { 625, 825 } },
{ 1, { 24, 24 }, { 150, 950 } },
{ 1, { 24, 24 }, { 200, 25 } },
{ 1, { 24, 24 }, { 250, 50 } },
{ 1, { 24, 24 }, { 175, 925 } },
{ 2, { 24, 24 }, { 300, 0 } },
{ 1, { 24, 24 }, { 575, 100 } },
{ 1, { 24, 24 }, { 150, 775 } },
{ 1, { 24, 24 }, { 500, 125 } },
{ 1, { 24, 24 }, { 850, 925 } },
{ 1, { 24, 24 }, { 200, 75 } },
{ 1, { 24, 24 }, { 200, 925 } },
{ 1, { 24, 24 }, { 550, 550 } },
{ 1, { 24, 24 }, { 475, 150 } },
{ 1, { 24, 24 }, { 600, 500 } },
{ 1, { 24, 24 }, { 700, 400 } },
{ 1, { 24, 24 }, { 750, 100 } },
{ 1, { 24, 24 }, { 925, 525 } },
{ 1, { 24, 24 }, { 350, 650 } },
{ 1, { 24, 24 }, { 700, 200 } },
{ 1, { 24, 24 }, { 800, 300 } },
{ 1, { 24, 24 }, { 525, 475 } },
{ 1, { 24, 24 }, { 25, 125 } },
{ 1, { 24, 24 }, { 75, 925 } },
{ 1, { 24, 24 }, { 300, 250 } },
{ 1, { 24, 24 }, { 75, 700 } },
{ 1, { 24, 24 }, { 725, 100 } },
{ 1, { 24, 24 }, { 25, 525 } },
{ 1, { 24, 24 }, { 150, 925 } },
{ 1, { 24, 24 }, { 125, 950 } },
{ 1, { 24, 24 }, { 325, 700 } },
{ 1, { 24, 24 }, { 700, 175 } },
{ 1, { 24, 24 }, { 75, 900 } },
{ 1, { 24, 24 }, { 75, 25 } },
{ 1, { 24, 24 }, { 75, 575 } },
{ 2, { 24, 24 }, { 175, 50 } },
{ 1, { 24, 24 }, { 725, 275 } },
{ 1, { 24, 24 }, { 825, 475 } },
{ 1, { 24, 24 }, { 325, 525 } },
{ 1, { 24, 24 }, { 100, 975 } },
{ 1, { 24, 24 }, { 625, 375 } },
{ 1, { 24, 24 }, { 450, 700 } },
{ 1, { 24, 24 }, { 400, 725 } },
{ 1, { 24, 24 }, { 500, 575 } },
{ 1, { 24, 24 }, { 725, 350 } },
{ 1, { 24, 24 }, { 325, 325 } },
{ 1, { 24, 24 }, { 800, 275 } },
{ 1, { 24, 24 }, { 400, 100 } },
{ 1, { 24, 24 }, { 350, 775 } },
{ 1, { 24, 24 }, { 950, 125 } },
{ 1, { 24, 24 }, { 925, 150 } },
{ 1, { 24, 24 }, { 875, 200 } },
{ 1, { 24, 24 }, { 325, 650 } },
{ 1, { 24, 24 }, { 175, 150 } },
{ 1, { 24, 24 }, { 425, 125 } },
{ 1, { 24, 24 }, { 325, 850 } },
{ 1, { 24, 24 }, { 675, 350 } },
{ 1, { 24, 24 }, { 975, 100 } },
{ 1, { 24, 24 }, { 25, 50 } },
{ 1, { 24, 24 }, { 75, 875 } },
{ 1, { 24, 24 }, { 150, 900 } },
{ 1, { 24, 24 }, { 375, 50 } },
{ 1, { 24, 24 }, { 675, 700 } },
{ 1, { 24, 24 }, { 675, 875 } },
{ 1, { 24, 24 }, { 550, 625 } },
{ 1, { 24, 24 }, { 225, 75 } },
{ 1, { 24, 24 }, { 825, 975 } },
{ 1, { 24, 24 }, { 850, 875 } },
{ 2, { 24, 24 }, { 0, 400 } },
{ 1, { 24, 24 }, { 525, 525 } },
{ 1, { 24, 24 }, { 100, 700 } },
{ 1, { 24, 24 }, { 25, 850 } },
{ 1, { 24, 24 }, { 200, 750 } },
{ 1, { 24, 24 }, { 300, 575 } },
{ 1, { 24, 24 }, { 900, 125 } },
{ 1, { 24, 24 }, { 275, 975 } },
{ 1, { 24, 24 }, { 375, 100 } },
{ 1, { 24, 24 }, { 575, 25 } },
{ 1, { 24, 24 }, { 225, 350 } },
{ 1, { 24, 24 }, { 75, 625 } },
{ 1, { 24, 24 }, { 800, 525 } },
{ 1, { 24, 24 }, { 350, 375 } },
{ 1, { 24, 24 }, { 450, 250 } },
{ 1, { 24, 24 }, { 700, 350 } },
{ 1, { 24, 24 }, { 300, 750 } },
{ 1, { 24, 24 }, { 725, 550 } },
{ 1, { 24, 24 }, { 825, 225 } },
{ 1, { 24, 24 }, { 325, 725 } },
{ 1, { 24, 24 }, { 850, 200 } },
{ 1, { 24, 24 }, { 0, 25 } },
{ 1, { 24, 24 }, { 875, 175 } },
{ 1, { 24, 24 }, { 900, 150 } },
{ 1, { 24, 24 }, { 950, 150 } },
{ 1, { 24, 24 }, { 925, 125 } },
{ 1, { 24, 24 }, { 975, 75 } },
{ 1, { 24, 24 }, { 100, 925 } },
{ 1, { 24, 24 }, { 250, 525 } },
{ 1, { 24, 24 }, { 275, 25 } },
{ 1, { 24, 24 }, { 875, 25 } },
{ 1, { 24, 24 }, { 875, 700 } },
{ 1, { 24, 24 }, { 275, 750 } },
{ 1, { 24, 24 }, { 250, 275 } },
{ 1, { 24, 24 }, { 350, 675 } },
{ 1, { 24, 24 }, { 375, 650 } },
{ 1, { 24, 24 }, { 200, 225 } },
{ 1, { 24, 24 }, { 400, 625 } },
{ 1, { 24, 24 }, { 425, 600 } },
{ 1, { 24, 24 }, { 525, 500 } },
{ 1, { 24, 24 }, { 700, 225 } },
{ 1, { 24, 24 }, { 550, 525 } },
{ 1, { 24, 24 }, { 50, 425 } },
{ 1, { 24, 24 }, { 725, 300 } },
{ 1, { 24, 24 }, { 775, 250 } },
{ 1, { 24, 24 }, { 50, 575 } },
{ 1, { 24, 24 }, { 150, 450 } },
{ 1, { 24, 24 }, { 125, 725 } },
{ 1, { 24, 24 }, { 600, 0 } },
{ 1, { 24, 24 }, { 600, 75 } },
{ 1, { 24, 24 }, { 350, 350 } },
{ 2, { 24, 24 }, { 175, 25 } },
{ 1, { 24, 24 }, { 775, 950 } },
{ 1, { 24, 24 }, { 600, 450 } },
{ 1, { 24, 24 }, { 25, 975 } },
{ 1, { 24, 24 }, { 0, 800 } },
{ 1, { 24, 24 }, { 500, 375 } },
{ 1, { 24, 24 }, { 350, 50 } },
{ 1, { 24, 24 }, { 850, 250 } },
{ 1, { 24, 24 }, { 275, 475 } },
{ 1, { 24, 24 }, { 125, 875 } },
{ 1, { 24, 24 }, { 375, 200 } },
{ 1, { 24, 24 }, { 175, 825 } },
{ 1, { 24, 24 }, { 400, 75 } },
{ 1, { 24, 24 }, { 200, 800 } },
{ 1, { 24, 24 }, { 200, 275 } },
{ 1, { 24, 24 }, { 250, 750 } },
{ 1, { 24, 24 }, { 300, 225 } },
{ 1, { 24, 24 }, { 475, 100 } },
{ 1, { 24, 24 }, { 975, 800 } },
{ 1, { 24, 24 }, { 300, 700 } },
{ 1, { 24, 24 }, { 950, 50 } },
{ 2, { 24, 24 }, { 25, 300 } },
{ 1, { 24, 24 }, { 950, 700 } },
{ 1, { 24, 24 }, { 25, 775 } },
{ 1, { 24, 24 }, { 625, 725 } },
{ 1, { 24, 24 }, { 650, 350 } },
{ 1, { 24, 24 }, { 675, 325 } },
{ 1, { 24, 24 }, { 700, 300 } },
{ 1, { 24, 24 }, { 750, 250 } },
{ 1, { 24, 24 }, { 800, 200 } },
{ 1, { 24, 24 }, { 75, 800 } },
{ 1, { 24, 24 }, { 300, 175 } },
{ 1, { 24, 24 }, { 550, 225 } },
{ 1, { 24, 24 }, { 825, 175 } },
{ 1, { 24, 24 }, { 875, 125 } },
{ 1, { 24, 24 }, { 900, 100 } },
{ 1, { 24, 24 }, { 525, 900 } },
{ 1, { 24, 24 }, { 575, 625 } },
{ 1, { 24, 24 }, { 125, 850 } },
{ 1, { 24, 24 }, { 175, 800 } },
{ 1, { 24, 24 }, { 200, 775 } },
{ 1, { 24, 24 }, { 200, 175 } },
{ 1, { 24, 24 }, { 225, 850 } },
{ 1, { 24, 24 }, { 250, 250 } },
{ 1, { 24, 24 }, { 375, 0 } },
{ 1, { 24, 24 }, { 575, 650 } },
{ 1, { 24, 24 }, { 600, 275 } },
{ 1, { 24, 24 }, { 400, 175 } },
{ 1, { 24, 24 }, { 375, 600 } },
{ 1, { 24, 24 }, { 400, 575 } },
{ 1, { 24, 24 }, { 275, 650 } },
{ 1, { 24, 24 }, { 450, 525 } },
{ 1, { 24, 24 }, { 475, 500 } },
{ 1, { 24, 24 }, { 500, 475 } },
{ 1, { 24, 24 }, { 575, 400 } },
{ 1, { 24, 24 }, { 900, 525 } },
{ 1, { 24, 24 }, { 525, 150 } },
{ 1, { 24, 24 }, { 775, 25 } },
{ 1, { 24, 24 }, { 525, 300 } },
{ 1, { 24, 24 }, { 575, 75 } },
{ 1, { 24, 24 }, { 700, 275 } },
{ 1, { 24, 24 }, { 325, 450 } },
{ 1, { 24, 24 }, { 100, 250 } },
{ 1, { 24, 24 }, { 725, 250 } },
{ 1, { 24, 24 }, { 750, 550 } },
{ 1, { 24, 24 }, { 775, 200 } },
{ 1, { 24, 24 }, { 825, 150 } },
{ 1, { 24, 24 }, { 800, 175 } },
{ 1, { 24, 24 }, { 0, 950 } },
{ 1, { 24, 24 }, { 25, 825 } },
{ 1, { 24, 24 }, { 375, 425 } },
{ 1, { 24, 24 }, { 125, 825 } },
{ 1, { 24, 24 }, { 75, 175 } },
{ 1, { 24, 24 }, { 250, 325 } },
{ 1, { 24, 24 }, { 825, 75 } },
{ 1, { 24, 24 }, { 325, 625 } },
{ 1, { 24, 24 }, { 325, 900 } },
{ 1, { 24, 24 }, { 275, 75 } },
{ 1, { 24, 24 }, { 475, 475 } },
{ 1, { 24, 24 }, { 25, 875 } },
{ 1, { 24, 24 }, { 475, 300 } },
{ 1, { 24, 24 }, { 650, 300 } },
{ 1, { 24, 24 }, { 175, 450 } },
{ 1, { 24, 24 }, { 725, 900 } },
{ 1, { 24, 24 }, { 850, 650 } },
{ 1, { 24, 24 }, { 650, 750 } },
{ 1, { 24, 24 }, { 800, 150 } },
{ 1, { 24, 24 }, { 875, 75 } },
{ 1, { 24, 24 }, { 925, 25 } },
{ 1, { 24, 24 }, { 950, 0 } },
{ 1, { 24, 24 }, { 400, 300 } },
{ 1, { 24, 24 }, { 0, 925 } },
{ 1, { 24, 24 }, { 350, 275 } },
{ 1, { 24, 24 }, { 75, 850 } },
{ 1, { 24, 24 }, { 350, 175 } },
{ 1, { 24, 24 }, { 100, 825 } },
{ 1, { 24, 24 }, { 400, 700 } },
{ 1, { 24, 24 }, { 200, 725 } },
{ 2, { 24, 24 }, { 0, 125 } },
{ 1, { 24, 24 }, { 450, 450 } },
{ 1, { 24, 24 }, { 225, 700 } },
{ 1, { 24, 24 }, { 500, 425 } },
{ 2, { 24, 24 }, { 75, 100 } },
{ 2, { 24, 24 }, { 100, 250 } },
{ 1, { 24, 24 }, { 900, 25 } },
{ 1, { 24, 24 }, { 150, 0 } },
{ 1, { 24, 24 }, { 925, 0 } },
{ 1, { 24, 24 }, { 75, 825 } },
{ 1, { 24, 24 }, { 950, 325 } },
{ 2, { 24, 24 }, { 0, 150 } },
{ 1, { 24, 24 }, { 425, 150 } },
{ 1, { 24, 24 }, { 500, 250 } },
{ 1, { 24, 24 }, { 375, 525 } },
{ 1, { 24, 24 }, { 625, 325 } },
{ 1, { 24, 24 }, { 150, 300 } },
{ 1, { 24, 24 }, { 300, 25 } },
{ 1, { 24, 24 }, { 750, 850 } },
{ 1, { 24, 24 }, { 250, 450 } },
{ 1, { 24, 24 }, { 50, 300 } },
{ 1, { 24, 24 }, { 975, 475 } },
{ 1, { 24, 24 }, { 725, 175 } },
{ 1, { 24, 24 }, { 775, 125 } },
{ 1, { 24, 24 }, { 300, 650 } },
{ 1, { 24, 24 }, { 50, 825 } },
{ 1, { 24, 24 }, { 50, 450 } },
{ 1, { 24, 24 }, { 125, 750 } },
{ 1, { 24, 24 }, { 375, 325 } },
{ 1, { 24, 24 }, { 225, 625 } },
{ 1, { 24, 24 }, { 200, 675 } },
{ 1, { 24, 24 }, { 775, 700 } },
{ 1, { 24, 24 }, { 250, 625 } },
{ 1, { 24, 24 }, { 350, 525 } },
{ 1, { 24, 24 }, { 325, 550 } },
{ 1, { 24, 24 }, { 650, 125 } },
{ 1, { 24, 24 }, { 175, 525 } },
{ 2, { 24, 24 }, { 25, 375 } },
{ 1, { 24, 24 }, { 50, 950 } },
{ 1, { 24, 24 }, { 300, 675 } },
{ 2, { 24, 24 }, { 125, 50 } },
{ 1, { 24, 24 }, { 325, 425 } },
{ 1, { 24, 24 }, { 850, 25 } },
{ 1, { 24, 24 }, { 875, 475 } },
{ 1, { 24, 24 }, { 75, 775 } },
{ 1, { 24, 24 }, { 125, 200 } },
{ 1, { 24, 24 }, { 400, 675 } },
{ 1, { 24, 24 }, { 700, 925 } },
{ 1, { 24, 24 }, { 825, 350 } },
{ 1, { 24, 24 }, { 750, 225 } },
{ 1, { 24, 24 }, { 0, 825 } },
{ 1, { 24, 24 }, { 100, 575 } },
{ 1, { 24, 24 }, { 150, 600 } },
{ 1, { 24, 24 }, { 25, 800 } },
{ 1, { 24, 24 }, { 150, 675 } },
{ 1, { 24, 24 }, { 475, 950 } },
{ 1, { 24, 24 }, { 225, 600 } },
{ 1, { 24, 24 }, { 350, 475 } },
{ 1, { 24, 24 }, { 525, 850 } },
{ 1, { 24, 24 }, { 675, 25 } },
{ 1, { 24, 24 }, { 650, 100 } },
{ 1, { 24, 24 }, { 775, 50 } },
{ 1, { 24, 24 }, { 150, 575 } },
{ 1, { 24, 24 }, { 100, 25 } },
{ 1, { 24, 24 }, { 250, 550 } },
{ 1, { 24, 24 }, { 350, 450 } },
{ 1, { 24, 24 }, { 450, 350 } },
{ 1, { 24, 24 }, { 425, 300 } },
{ 1, { 24, 24 }, { 750, 400 } },
{ 1, { 24, 24 }, { 725, 75 } },
{ 1, { 24, 24 }, { 350, 725 } },
{ 1, { 24, 24 }, { 950, 250 } },
{ 1, { 24, 24 }, { 250, 375 } },
{ 1, { 24, 24 }, { 450, 775 } },
{ 1, { 24, 24 }, { 475, 275 } },
{ 1, { 24, 24 }, { 225, 825 } },
{ 1, { 24, 24 }, { 350, 425 } },
{ 1, { 24, 24 }, { 450, 325 } },
{ 1, { 24, 24 }, { 625, 150 } },
{ 1, { 24, 24 }, { 500, 275 } },
{ 1, { 24, 24 }, { 25, 675 } },
{ 1, { 24, 24 }, { 700, 75 } },
{ 1, { 24, 24 }, { 25, 725 } },
{ 1, { 24, 24 }, { 150, 200 } },
{ 1, { 24, 24 }, { 50, 700 } },
{ 1, { 24, 24 }, { 500, 800 } },
{ 1, { 24, 24 }, { 250, 500 } },
{ 1, { 24, 24 }, { 0, 150 } },
{ 1, { 24, 24 }, { 225, 375 } },
{ 1, { 24, 24 }, { 800, 75 } },
{ 1, { 24, 24 }, { 750, 200 } },
{ 1, { 24, 24 }, { 450, 300 } },
{ 1, { 24, 24 }, { 0, 775 } },
{ 1, { 24, 24 }, { 300, 125 } },
{ 1, { 24, 24 }, { 325, 575 } },
{ 1, { 24, 24 }, { 675, 75 } },
{ 1, { 24, 24 }, { 25, 700 } },
{ 1, { 24, 24 }, { 50, 100 } },
{ 1, { 24, 24 }, { 150, 650 } },
{ 1, { 24, 24 }, { 450, 275 } },
{ 1, { 24, 24 }, { 650, 150 } },
{ 1, { 24, 24 }, { 250, 200 } },
{ 1, { 24, 24 }, { 0, 700 } },
{ 1, { 24, 24 }, { 100, 600 } },
{ 1, { 24, 24 }, { 25, 450 } },
{ 1, { 24, 24 }, { 50, 875 } },
{ 1, { 24, 24 }, { 700, 0 } },
{ 1, { 24, 24 }, { 550, 750 } },
{ 1, { 24, 24 }, { 700, 450 } },
{ 1, { 24, 24 }, { 750, 325 } },
{ 1, { 24, 24 }, { 425, 225 } },
{ 1, { 24, 24 }, { 175, 325 } },
{ 1, { 24, 24 }, { 925, 325 } },
{ 1, { 24, 24 }, { 525, 925 } },
{ 1, { 24, 24 }, { 100, 525 } },
{ 2, { 24, 24 }, { 75, 0 } },
{ 1, { 24, 24 }, { 425, 200 } },
{ 1, { 24, 24 }, { 450, 175 } },
{ 1, { 24, 24 }, { 675, 950 } },
{ 1, { 24, 24 }, { 75, 525 } },
{ 1, { 24, 24 }, { 100, 500 } },
{ 1, { 24, 24 }, { 125, 475 } },
{ 1, { 24, 24 }, { 25, 575 } },
{ 1, { 24, 24 }, { 725, 400 } },
{ 1, { 24, 24 }, { 75, 500 } },
{ 1, { 24, 24 }, { 50, 200 } },
{ 1, { 24, 24 }, { 150, 425 } },
{ 1, { 24, 24 }, { 350, 225 } },
{ 1, { 24, 24 }, { 25, 250 } },
{ 1, { 24, 24 }, { 950, 100 } },
{ 1, { 24, 24 }, { 900, 325 } },
{ 1, { 24, 24 }, { 425, 0 } },
{ 1, { 24, 24 }, { 75, 975 } },
{ 1, { 24, 24 }, { 25, 175 } },
{ 1, { 24, 24 }, { 875, 875 } },
{ 1, { 24, 24 }, { 425, 100 } },
{ 1, { 24, 24 }, { 225, 525 } },
{ 1, { 24, 24 }, { 25, 475 } },
{ 1, { 24, 24 }, { 200, 300 } },
{ 1, { 24, 24 }, { 450, 50 } },
{ 1, { 24, 24 }, { 650, 375 } },
{ 1, { 24, 24 }, { 650, 425 } },
{ 1, { 24, 24 }, { 875, 675 } },
{ 1, { 24, 24 }, { 225, 150 } },
{ 2, { 24, 24 }, { 25, 250 } },
{ 1, { 24, 24 }, { 200, 100 } },
{ 1, { 24, 24 }, { 100, 125 } },
},
},
}
local iconIndices: { string } = icons[1]
local idIndices: { string } = icons[2]
local iconRegistry: { [number]: { number | { number } } } = icons[3]
local nameToIndex = {}
for index, name in iconIndices do
nameToIndex[name] = index
end
Lucide.Icons = iconIndices
Lucide.Count = #iconIndices
Lucide.Source = "lucide-roblox-direct@e8b0019"
local atlasUrls = table.clone(DEFAULT_URLS)
local status = "Idle"
local lastError = nil
local provider = "GitHubLocal"
local warned = false
local bypassCache = false
local function uint32(data, offset)
local a, b, c, d = string.byte(data, offset, offset + 3)
if not d then
return nil
end
return a * 16777216 + b * 65536 + c * 256 + d
end
local function validatePng(data, index)
local expected = EXPECTED[index]
if type(data) ~= "string" or #data ~= expected.Bytes then
return false
end
if string.sub(data, 1, 8) ~= "\137PNG\r\n\26\n" or string.sub(data, 13, 16) ~= "IHDR" then
return false
end
return uint32(data, 17) == expected.Width and uint32(data, 21) == expected.Height
end
local function fallback(message)
status = "Fallback"
lastError = message
if not warned then
warn(`[BobloUI] Lucide atlas unavailable ({message}); using asset-free fallback icons.`)
warned = true
end
return false
end
local function ensureCacheFolders()
if not Env.FS then
return false
end
for _, folder in { "BobloUI", "BobloUI/assets" } do
if not Env.FS.IsFolder(folder) and not Env.FS.MakeFolder(folder) then
return false
end
end
return true
end
local function loadSheet(index)
local path = CACHE[index]
local contents = if not bypassCache and Env.FS.IsFile(path) then Env.FS.Read(path) else nil
if not validatePng(contents, index) then
local downloaded, httpError = Env.HttpGet(atlasUrls[index])
if not validatePng(downloaded, index) then
return nil, httpError or "downloaded atlas failed PNG validation"
end
if not Env.FS.Write(path, downloaded) then
return nil, "cannot write the atlas cache"
end
end
local asset = Env.GetCustomAsset(path)
if not asset then
return nil, "custom asset registration failed"
end
return asset, nil
end
function Lucide.Prepare(force)
if status == "Ready" and not force then
return true
end
if status == "Fallback" and not force then
return false
end
if status == "Preparing" then
return false
end
if force then
idIndices[1], idIndices[2] = "", ""
status = "Idle"
lastError = nil
warned = false
end
if not Env.FS or not Env.Capabilities.CustomAsset then
return fallback("executor has no filesystem/custom-asset API")
end
if not ensureCacheFolders() then
return fallback("cannot create the atlas cache folder")
end
status = "Preparing"
for index = 1, 2 do
local asset, loadError = loadSheet(index)
if not asset then
idIndices[1], idIndices[2] = "", ""
return fallback(`sheet {index}: {loadError or "unknown error"}`)
end
idIndices[index] = asset
end
status = "Ready"
lastError = nil
provider = "GitHubLocal"
bypassCache = false
return true
end
function Lucide.Retry()
return Lucide.Prepare(true)
end
local function clearCache()
if not Env.FS then
return
end
for _, path in CACHE do
if Env.FS.IsFile(path) then
Env.FS.Delete(path)
end
end
end
function Lucide.SetAtlasUrls(first, second)
for index, value in { first, second } do
if type(value) ~= "string" or not string.match(value, "^https://") then
error(`[BobloUI] Icon.SetAtlasUrls argument {index} must be an HTTPS URL.`, 2)
end
end
atlasUrls[1], atlasUrls[2] = first, second
bypassCache = true
clearCache()
return Lucide.Retry()
end
function Lucide.GetAtlasUrls()
return { atlasUrls[1], atlasUrls[2] }
end
function Lucide.SetSpritesheets(first, second)
if type(first) ~= "string" or first == "" or type(second) ~= "string" or second == "" then
error("[BobloUI] Icon.SetSpritesheets expects two custom asset strings.", 2)
end
idIndices[1], idIndices[2] = first, second
status = "Ready"
lastError = nil
provider = "Manual"
return Lucide.GetSpritesheets()
end
function Lucide.GetSpritesheets()
return { idIndices[1], idIndices[2] }
end
function Lucide.ResetSpritesheets()
atlasUrls[1], atlasUrls[2] = DEFAULT_URLS[1], DEFAULT_URLS[2]
provider = "GitHubLocal"
bypassCache = true
clearCache()
Lucide.Prepare(true)
return Lucide.GetSpritesheets()
end
function Lucide.GetStatus()
return {
State = status,
Provider = provider,
Error = lastError,
Urls = Lucide.GetAtlasUrls(),
Ready = status == "Ready",
}
end
function Lucide.Has(name)
return type(name) == "string" and nameToIndex[name] ~= nil
end
function Lucide.GetAsset(name: string)
local size = 48
local iconIndex = nameToIndex[name]
if not iconIndex then
return nil
end
if not Lucide.Prepare() then
return nil
end
local currentDifference = math.huge
local currentSize = size
for registrySize, _ in iconRegistry do
local diff = math.abs(size - registrySize)
if diff < currentDifference then
currentDifference = diff
currentSize = registrySize
end
end
local icon = iconRegistry[currentSize][iconIndex]
if icon then
return {
IconName = name,
Url = idIndices[icon[1]],
ImageRectSize = Vector2.new(icon[2][1], icon[2][2]),
ImageRectOffset = Vector2.new(icon[3][1], icon[3][2]),
}
end
return nil
end
return Lucide
end

__modules["primitives/Popover"] = function()
local Surface = __require("primitives/Surface")
local Popover = {}
function Popover.open(window, anchor, size, options)
options = options or {}
local handle = window.Layers:Push({ Scrim = false, Modal = false, OnDismiss = options.OnDismiss })
local currentSize = Vector2.new(math.max(1, size.X), math.max(1, size.Y))
local frame = Surface.new(window, {
Name = "Popover",
Size = UDim2.fromOffset(currentSize.X, currentSize.Y),
BorderSizePixel = 0,
Parent = handle.Container,
}, {
Token = "SurfaceRaised",
StrokeToken = "Border",
StrokeTransparency = 0.42,
Corner = options.Corner or window.Tokens:Get("CornerMd"),
})
frame.ZIndex = handle.Depth * 10 + 2
local function place()
if not anchor or not anchor.Parent then
handle:Dismiss()
return
end
local pos, asz = anchor.AbsolutePosition, anchor.AbsoluteSize
local safePos, safeSize = window.Device:SafeArea()
local minX = safePos.X + 8
local maxX = math.max(minX, safePos.X + safeSize.X - currentSize.X - 8)
local minY = safePos.Y + 8
local maxY = safePos.Y + safeSize.Y - currentSize.Y - 8
local x = math.clamp(pos.X, minX, maxX)
local below = pos.Y + asz.Y + 5
local y
if below + currentSize.Y <= safePos.Y + safeSize.Y - 8 then
y = below
else
y = math.max(minY, pos.Y - currentSize.Y - 5)
end
frame.Position = UDim2.fromOffset(x, math.min(y, maxY))
end
place()
local c1 = anchor:GetPropertyChangedSignal("AbsolutePosition"):Connect(place)
local c2 = anchor:GetPropertyChangedSignal("AbsoluteSize"):Connect(place)
local c3 = window.Device.Changed:Connect(place)
local oldDismiss = handle.Dismiss
function handle:SetSize(newSize)
if self._dismissed then
return self
end
currentSize = Vector2.new(math.max(1, newSize.X), math.max(1, newSize.Y))
frame.Size = UDim2.fromOffset(currentSize.X, currentSize.Y)
place()
return self
end
function handle:Reposition()
if not self._dismissed then
place()
end
return self
end
function handle:GetSize()
return currentSize
end
function handle:Dismiss()
if self._dismissed then
return
end
c1:Disconnect()
c2:Disconnect()
c3:Disconnect()
oldDismiss(self)
end
handle.Frame = frame
return handle
end
return Popover
end

__modules["primitives/Scroller"] = function()
local Create = __require("runtime/Create")
local Scroller = {}
function Scroller.new(window, props)
props = props or {}
props.BackgroundTransparency = props.BackgroundTransparency or 1
props.BorderSizePixel = 0
props.CanvasSize = props.CanvasSize or UDim2.new()
props.AutomaticCanvasSize = props.AutomaticCanvasSize or Enum.AutomaticSize.Y
props.ScrollingDirection = props.ScrollingDirection or Enum.ScrollingDirection.Y
props.ScrollBarThickness = props.ScrollBarThickness or 4
local frame = Create.New("ScrollingFrame", props)
window:_bind(frame, { ScrollBarImageColor3 = "BorderStrong" })
return frame
end
return Scroller
end

__modules["primitives/Sheet"] = function()
local Create = __require("runtime/Create")
local Surface = __require("primitives/Surface")
local Sheet = {}
function Sheet.open(window, height, options)
options = options or {}
local requestedHeight = height
local handle = window.Layers:Push({
Scrim = true,
ScrimTransparency = options.ScrimTransparency,
Modal = options.Modal == true,
OnDismiss = options.OnDismiss,
})
local function metrics()
local safePos, safeSize = window.Device:SafeArea()
local keyboard = window.Device.KeyboardHeight or 0
local usableH = math.max(120, safeSize.Y - keyboard)
local h = math.min(requestedHeight or math.floor(usableH * 0.6), math.floor(usableH * 0.82))
return safePos, safeSize, usableH, h
end
local safePos, safeSize, usableH, h = metrics()
local frame = Surface.new(window, {
Name = "Sheet",
Size = UDim2.fromOffset(math.max(1, safeSize.X - 12), h),
Position = UDim2.fromOffset(safePos.X + 6, safePos.Y + usableH - 6),
AnchorPoint = Vector2.new(0, 1),
BorderSizePixel = 0,
Parent = handle.Container,
}, {
Token = "SurfaceRaised",
StrokeToken = "Border",
StrokeTransparency = 0.42,
Corner = window.Tokens:Get("CornerLg"),
})
frame.ZIndex = handle.Depth * 10 + 2
local grab = Create.New("TextButton", {
Size = UDim2.fromOffset(64, 22),
Position = UDim2.new(0.5, 0, 0, 0),
AnchorPoint = Vector2.new(0.5, 0),
BackgroundTransparency = 1,
BorderSizePixel = 0,
Text = "",
Parent = frame,
})
local bar = Create.New("Frame", {
Size = UDim2.fromOffset(32, 3),
Position = UDim2.new(0.5, 0, 0, 7),
AnchorPoint = Vector2.new(0.5, 0),
BorderSizePixel = 0,
Parent = grab,
})
Create.New("UICorner", { CornerRadius = UDim.new(1, 0), Parent = bar })
window:_bind(bar, { BackgroundColor3 = "Border" })
local function layout()
if not frame.Parent then
return
end
local p, s, u, hh = metrics()
frame.Size = UDim2.fromOffset(math.max(1, s.X - 12), hh)
frame.Position = UDim2.fromOffset(p.X + 6, p.Y + u - 6)
end
local conn = window.Device.Changed:Connect(layout)
local oldDismiss = handle.Dismiss
local dragStart
local dragConn = grab.InputBegan:Connect(function(input)
if
input.UserInputType ~= Enum.UserInputType.Touch
and input.UserInputType ~= Enum.UserInputType.MouseButton1
then
return
end
dragStart = input.Position
window.Input:CapturePointer(handle, input, function(move)
local dy = math.max(0, move.Position.Y - dragStart.Y)
local p, s, u = metrics()
frame.Position = UDim2.fromOffset(p.X + 6, p.Y + u - 6 + dy)
end, function(move, cancelled)
local dy = move and math.max(0, move.Position.Y - dragStart.Y) or 0
if not cancelled and dy > 60 then
handle:Dismiss()
else
layout()
end
end)
end)
function handle:SetHeight(newHeight)
requestedHeight = newHeight
layout()
return self
end
function handle:Dismiss()
if self._dismissed then
return
end
window.Input:CancelCapture(self)
conn:Disconnect()
dragConn:Disconnect()
oldDismiss(self)
end
handle.Frame = frame
return handle
end
return Sheet
end

__modules["primitives/Spinner"] = function()
local TweenService = game:GetService("TweenService")
local Create = __require("runtime/Create")
local Spinner = {}
function Spinner.new(window, parent, size)
local label = Create.New("TextLabel", {
Size = UDim2.fromOffset(size or 16, size or 16),
BackgroundTransparency = 1,
Text = window.Motion and not window.Motion.Enabled and "…" or "◌",
Font = window.Fonts.Bold,
TextSize = size or 16,
Parent = parent,
})
window:_bind(label, { TextColor3 = "Text" })
if not window.Motion or window.Motion.Enabled then
local tween = TweenService:Create(
label,
TweenInfo.new(0.8, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1),
{ Rotation = 360 }
)
tween:Play()
label.Destroying:Once(function()
pcall(function()
tween:Cancel()
end)
end)
end
return label
end
return Spinner
end

__modules["primitives/Surface"] = function()
local Create = __require("runtime/Create")
local Surface = {}
function Surface.new(window, props, options)
props = props or {}
options = options or {}
local frame = Create.New(options.ClassName or "Frame", props)
if options.Corner ~= false then
Create.New(
"UICorner",
{ CornerRadius = UDim.new(0, options.Corner or window.Tokens:Get("CornerMd")), Parent = frame }
)
end
if options.Stroke ~= false then
local stroke = Create.New("UIStroke", {
Thickness = options.StrokeThickness or window.Tokens:Get("Stroke"),
Transparency = if options.StrokeTransparency == nil then 0.18 else options.StrokeTransparency,
LineJoinMode = Enum.LineJoinMode.Round,
ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
Parent = frame,
})
window:_bind(stroke, { Color = options.StrokeToken or "BorderSubtle" })
end
window:_bind(frame, { BackgroundColor3 = options.Token or "Surface" })
if options.Sheen then
local sheen = Create.New("Frame", {
Name = "InnerSheen",
Size = UDim2.new(1, -4, 0, 1),
Position = UDim2.fromOffset(2, 1),
BackgroundTransparency = options.SheenTransparency or 0.38,
BorderSizePixel = 0,
ZIndex = (props.ZIndex or 1) + 1,
Parent = frame,
})
window:_bind(sheen, { BackgroundColor3 = "SurfaceSheen" })
end
return frame
end
return Surface
end

__modules["runtime/Create"] = function()
local Create = {}
function Create.Apply(instance: Instance, props: { [string]: any }?): Instance
if not props then
return instance
end
for key, value in props do
if key ~= "Parent" then
if key == "Font" and typeof(value) == "Font" then
instance.FontFace = value
else
instance[key] = value
end
end
end
return instance
end
function Create.New(className: string, props: { [string]: any }?, children: { Instance }?): any
local instance = Instance.new(className)
Create.Apply(instance, props)
if children then
for _, child in children do
child.Parent = instance
end
end
if props and props.Parent then
instance.Parent = props.Parent
end
return instance
end
function Create.Corner(radius: number): UICorner
return Create.New("UICorner", { CornerRadius = UDim.new(0, radius) })
end
function Create.Stroke(thickness: number, transparency: number?): UIStroke
return Create.New("UIStroke", {
Thickness = thickness,
Transparency = transparency or 0,
ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
})
end
function Create.Padding(top: number, right: number?, bottom: number?, left: number?): UIPadding
local r = right or top
local b = bottom or top
local l = left or r
return Create.New("UIPadding", {
PaddingTop = UDim.new(0, top),
PaddingRight = UDim.new(0, r),
PaddingBottom = UDim.new(0, b),
PaddingLeft = UDim.new(0, l),
})
end
function Create.List(gap: number, direction: Enum.FillDirection?, props: { [string]: any }?): UIListLayout
local layout = Create.New("UIListLayout", {
Padding = UDim.new(0, gap),
FillDirection = direction or Enum.FillDirection.Vertical,
SortOrder = Enum.SortOrder.LayoutOrder,
})
return Create.Apply(layout, props) :: any
end
function Create.SizeConstraint(min: Vector2?, max: Vector2?): UISizeConstraint
return Create.New("UISizeConstraint", {
MinSize = min or Vector2.zero,
MaxSize = max or Vector2.new(math.huge, math.huge),
})
end
function Create.Scale(scale: number): UIScale
return Create.New("UIScale", { Scale = scale })
end
return Create
end

__modules["runtime/Dependency"] = function()
local Dependency = {}
local function updateRegistry(owner, ids, requirement)
if owner.Id and owner._window and owner._window.Registry then
owner._window.Registry:Update(owner, {
DependencyIds = ids,
Requirement = requirement,
})
end
end
function Dependency.Bind(owner, spec, kind)
if spec == nil then
return
end
local window = owner._window
local janitor = owner._janitor
local slot = `container_dependency_{kind}`
local function apply(result)
local enabled = result == true
if kind == "visible" then
owner._dependencyVisible = enabled
owner:_applyContainerState()
else
owner._dependencyEnabled = enabled
owner:_applyContainerState()
end
end
if type(spec) == "table" then
local ids = {}
local requirements = {}
for id, wanted in spec do
table.insert(ids, id)
table.insert(requirements, id .. " = " .. tostring(wanted))
end
updateRegistry(owner, ids, table.concat(requirements, ", "))
local function evaluate()
for id, wanted in spec do
if window.State:Get(id) ~= wanted then
apply(false)
return
end
end
apply(true)
end
janitor:Add(window.State:WatchMany(ids, evaluate), nil, slot)
evaluate()
elseif type(spec) == "function" then
local function retrack()
janitor:Remove(slot)
local ids, result = window.State:Track(spec)
updateRegistry(owner, ids, #ids > 0 and table.concat(ids, ", ") or nil)
if #ids == 0 then
warn(
`[BobloUI] {owner.Type or "container"} "{owner.Id or owner.Title or "anonymous"}" dependency tracked 0 State:Get calls. The predicate must read at least one value from this Store.`
)
end
local unsubscribe = {}
for _, id in ids do
table.insert(unsubscribe, window.State:Watch(id, retrack, owner))
end
janitor:Add(function()
for _, callback in unsubscribe do
callback()
end
end, nil, slot)
apply(result == true)
end
retrack()
else
error(`[BobloUI] {kind} dependency must be a table or function.`, 3)
end
end
return Dependency
end

__modules["runtime/Env"] = function()
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local Env = {}
local function tryGlobal(name: string): any?
local sources = {}
local ok, genv = pcall(function()
return getgenv()
end)
if ok and type(genv) == "table" then
table.insert(sources, genv)
end
local ok2, fenv = pcall(function()
return getfenv(0)
end)
if ok2 and type(fenv) == "table" then
table.insert(sources, fenv)
end
table.insert(sources, _G)
for _, source in sources do
local found, value = pcall(function()
return source[name]
end)
if found and value ~= nil then
return value
end
end
return nil
end
Env.IsStudio = RunService:IsStudio()
do
local ok, genv = pcall(function()
return getgenv()
end)
Env.Globals = (ok and type(genv) == "table") and genv or {}
Env.HasSharedGlobals = ok and type(genv) == "table"
end
do
local identify = tryGlobal("identifyexecutor") or tryGlobal("getexecutorname")
local name = nil
if identify then
local ok, result = pcall(identify)
if ok and type(result) == "string" then
name = result
end
end
Env.Executor = name or (Env.IsStudio and "Roblox Studio" or "Unknown")
end
local writefile = tryGlobal("writefile")
local readfile = tryGlobal("readfile")
local isfile = tryGlobal("isfile")
local isfolder = tryGlobal("isfolder")
local makefolder = tryGlobal("makefolder")
local listfiles = tryGlobal("listfiles")
local delfile = tryGlobal("delfile")
local hasFilesystem = writefile ~= nil and readfile ~= nil and isfile ~= nil and isfolder ~= nil and makefolder ~= nil
Env.FS = if hasFilesystem
then {
Read = function(path: string): string?
local ok, contents = pcall(readfile, path)
return if ok then contents else nil
end,
Write = function(path: string, contents: string): boolean
return (pcall(writefile, path, contents))
end,
Delete = function(path: string): boolean
if not delfile then
return false
end
return (pcall(delfile, path))
end,
List = function(path: string): { string }
if not listfiles then
return {}
end
local ok, entries = pcall(listfiles, path)
return if ok and type(entries) == "table" then entries else {}
end,
IsFile = function(path: string): boolean
local ok, result = pcall(isfile, path)
return ok and result == true
end,
IsFolder = function(path: string): boolean
local ok, result = pcall(isfolder, path)
return ok and result == true
end,
MakeFolder = function(path: string): boolean
return (pcall(makefolder, path))
end,
}
else nil
local requestFunction = tryGlobal("request") or tryGlobal("http_request") or tryGlobal("httprequest")
if not requestFunction then
local syn = tryGlobal("syn")
if type(syn) == "table" then
requestFunction = syn.request
end
end
if not requestFunction then
local http = tryGlobal("http")
if type(http) == "table" then
requestFunction = http.request
end
end
local customAsset = tryGlobal("getcustomasset") or tryGlobal("getsynasset")
if not customAsset then
local syn = tryGlobal("syn")
if type(syn) == "table" then
customAsset = syn.getcustomasset or syn.get_custom_asset
end
end
function Env.HttpGet(url: string): (string?, string?)
if type(requestFunction) == "function" then
local ok, response = pcall(requestFunction, {
Url = url,
Method = "GET",
Headers = {
["Cache-Control"] = "no-cache",
},
})
if ok and type(response) == "table" then
local status = tonumber(response.StatusCode or response.Status)
local body = response.Body or response.body
if type(body) == "string" and (status == nil or (status >= 200 and status < 300)) then
return body, nil
end
return nil, `HTTP {status or "request failed"}`
end
end
local ok, body = pcall(function()
return game:HttpGet(url, true)
end)
if ok and type(body) == "string" then
return body, nil
end
local studioOk, studioBody = pcall(function()
return HttpService:GetAsync(url, true)
end)
if studioOk and type(studioBody) == "string" then
return studioBody, nil
end
local reason = if not studioOk then studioBody else body
return nil, tostring(reason or "HTTP request failed")
end
function Env.GetCustomAsset(path: string): string?
if type(customAsset) ~= "function" then
return nil
end
local ok, result = pcall(customAsset, path)
if not ok or type(result) ~= "string" or result == "" then
return nil
end
return result
end
local setclipboard = tryGlobal("setclipboard") or tryGlobal("toclipboard")
local getclipboard = tryGlobal("getclipboard") or tryGlobal("fromclipboard")
function Env.SetClipboard(text: string): boolean
if not setclipboard then
return false
end
return (pcall(setclipboard, text))
end
function Env.GetClipboard(): string?
if not getclipboard then
return nil
end
local ok, value = pcall(getclipboard)
if not ok or value == nil then
return nil
end
return tostring(value)
end
local gethui = tryGlobal("gethui")
local protectGui = tryGlobal("protect_gui")
if not protectGui then
local syn = tryGlobal("syn")
if type(syn) == "table" then
protectGui = syn.protect_gui
end
end
local cachedParent: Instance? = nil
function Env.GetGuiParent(): Instance
if cachedParent and cachedParent.Parent ~= nil then
return cachedParent
end
if gethui then
local ok, hidden = pcall(gethui)
if ok and typeof(hidden) == "Instance" then
cachedParent = hidden
return hidden
end
end
local ok, coreGui = pcall(function()
local service = game:GetService("CoreGui")
local probe = Instance.new("Folder")
probe.Parent = service
probe:Destroy()
return service
end)
if ok and coreGui then
cachedParent = coreGui
return coreGui
end
local playerGui = Players.LocalPlayer:FindFirstChildOfClass("PlayerGui")
or Players.LocalPlayer:WaitForChild("PlayerGui")
cachedParent = playerGui
return playerGui
end
function Env.Protect(gui: Instance)
if protectGui then
pcall(protectGui, gui)
end
end
Env.Capabilities = {
Filesystem = Env.FS ~= nil,
Http = requestFunction ~= nil or not Env.IsStudio,
CustomAsset = customAsset ~= nil,
HiddenUI = gethui ~= nil,
ProtectGui = protectGui ~= nil,
Clipboard = setclipboard ~= nil,
ClipboardRead = getclipboard ~= nil,
SharedGlobals = Env.HasSharedGlobals,
}
function Env.Describe(): string
local flags = {}
for name, enabled in Env.Capabilities do
if enabled then
table.insert(flags, name)
end
end
table.sort(flags)
local list = if #flags > 0 then table.concat(flags, ", ") else "none"
return `{Env.Executor} [{list}]`
end
return Env
end

__modules["runtime/Janitor"] = function()
local Janitor = {}
Janitor.__index = Janitor
local function cleanupOne(object: any, method: any)
if method ~= nil then
if type(method) == "function" then
method(object)
else
local fn = object[method]
if fn then
fn(object)
end
end
return
end
local kind = typeof(object)
if kind == "function" then
object()
elseif kind == "RBXScriptConnection" then
object:Disconnect()
elseif kind == "thread" then
pcall(task.cancel, object)
elseif kind == "Instance" then
if object:IsA("Tween") then
object:Cancel()
end
object:Destroy()
elseif kind == "table" then
local fn = object.Destroy or object.Disconnect or object.Cleanup
if fn then
fn(object)
end
end
end
function Janitor.new(name: string?)
return setmetatable({
_name = name or "Janitor",
_items = {},
_indexed = {},
_destroyed = false,
}, Janitor)
end
function Janitor.is(value): boolean
return type(value) == "table" and getmetatable(value) == Janitor
end
function Janitor:Add(object: any, method: any?, index: any?)
if self._destroyed then
cleanupOne(object, method)
return object
end
if index ~= nil then
self:Remove(index)
end
local entry = { object = object, method = method, index = index }
table.insert(self._items, entry)
if index ~= nil then
self._indexed[index] = entry
end
return object
end
function Janitor:AddJanitor(child, index: any?)
return self:Add(child, "Destroy", index)
end
function Janitor:Get(index: any): any?
local entry = self._indexed[index]
return entry and entry.object or nil
end
function Janitor:Remove(index: any)
local entry = self._indexed[index]
if not entry then
return
end
self._indexed[index] = nil
local position = table.find(self._items, entry)
if position then
table.remove(self._items, position)
end
local ok, err = pcall(cleanupOne, entry.object, entry.method)
if not ok then
warn(`[BobloUI] {self._name}: cleanup of "{tostring(index)}" failed: {err}`)
end
end
function Janitor:Release(index: any): any?
local entry = self._indexed[index]
if not entry then
return nil
end
self._indexed[index] = nil
local position = table.find(self._items, entry)
if position then
table.remove(self._items, position)
end
return entry.object
end
function Janitor:LinkToInstance(instance: Instance)
return self:Add(instance.Destroying:Connect(function()
self:Destroy()
end))
end
function Janitor:IsEmpty(): boolean
return #self._items == 0
end
function Janitor:Cleanup()
local items = self._items
self._items = {}
self._indexed = {}
for index = #items, 1, -1 do
local entry = items[index]
local ok, err = pcall(cleanupOne, entry.object, entry.method)
if not ok then
warn(`[BobloUI] {self._name}: cleanup failed: {err}`)
end
end
end
function Janitor:Destroy()
if self._destroyed then
return
end
self._destroyed = true
self:Cleanup()
end
return Janitor
end

__modules["runtime/RuntimeManifest"] = function()
return {
["Common"] = {
["Id"] = "string?",
["Title"] = "string?",
["Description"] = "string?",
["Keywords"] = "table?",
["Badge"] = "string?",
["Disabled"] = "boolean|string?",
["Visible"] = "boolean?",
["VisibleWhen"] = "table|function?",
["EnabledWhen"] = "table|function?",
["IgnoreConfig"] = "boolean?",
["Order"] = "number?",
["Callback"] = "function?",
["Tooltip"] = "string|function?",
["ContextMenu"] = "table?",
["Adaptive"] = "boolean?",
["Icon"] = "string?",
["IconColor"] = "string|Color3?",
},
["Components"] = {
["Button"] = {
["Method"] = "AddButton",
["Options"] = {
["Text"] = "string?",
["Variant"] = "string?",
["Confirm"] = "string?",
["Risky"] = "boolean?",
["DoubleClick"] = "boolean?",
["DoubleClickWindow"] = "number?",
["SubButtons"] = "table?",
["Actions"] = "table?",
},
["Required"] = { "Title" },
["Stateful"] = false,
},
["Toggle"] = {
["Method"] = "AddToggle",
["Options"] = { ["Default"] = "boolean?", ["Style"] = "string?" },
["Required"] = { "Title" },
["Stateful"] = true,
},
["Slider"] = {
["Method"] = "AddSlider",
["Options"] = {
["Min"] = "number",
["Max"] = "number",
["Default"] = "number?",
["Step"] = "number?",
["Precision"] = "number?",
["Rounding"] = "number?",
["Prefix"] = "string?",
["Suffix"] = "string?",
["Format"] = "function?",
["FormatDisplayValue"] = "function?",
["ValueInput"] = "boolean?",
["AllowRightClickInput"] = "boolean?",
["FloatingValue"] = "boolean?",
["Compact"] = "boolean?",
["HideMax"] = "boolean?",
["IconFrom"] = "string?",
["IconTo"] = "string?",
},
["Required"] = { "Title", "Min", "Max" },
["Stateful"] = true,
},
["Dropdown"] = {
["Method"] = "AddDropdown",
["Options"] = {
["Options"] = "table?",
["Values"] = "table?",
["Default"] = "any?",
["Multi"] = "boolean?",
["MultiValueMode"] = "string?",
["Map"] = "boolean?",
["ReturnMap"] = "boolean?",
["Searchable"] = "boolean?",
["AllowNone"] = "boolean?",
["AllowNull"] = "boolean?",
["Max"] = "number?",
["Placeholder"] = "string?",
["Style"] = "string?",
["Source"] = "any?",
["MaxVisibleRows"] = "number?",
["MaxVisibleDropdownItems"] = "number?",
["DragSelect"] = "boolean?",
["DisabledValues"] = "table?",
["ValueImages"] = "table?",
["Images"] = "table?",
["FormatDisplayValue"] = "function?",
["FormatListValue"] = "function?",
["FormatValue"] = "function?",
["FormatOption"] = "function?",
},
["Required"] = { "Title" },
["Stateful"] = true,
},
["Input"] = {
["Method"] = "AddInput",
["Options"] = {
["Default"] = "string|number?",
["Placeholder"] = "string?",
["Numeric"] = "boolean?",
["MaxLength"] = "number?",
["Multiline"] = "boolean?",
["ClearOnFocus"] = "boolean?",
["ClearTextOnFocus"] = "boolean?",
["ClearTextOnBlur"] = "boolean?",
["AllowEmpty"] = "boolean?",
["EmptyReset"] = "string|number?",
["Validate"] = "function?",
["VerifyValue"] = "function?",
["Finished"] = "boolean?",
["CommitOn"] = "string?",
["Height"] = "number?",
},
["Required"] = { "Title" },
["Stateful"] = true,
},
["Keybind"] = {
["Method"] = "AddKeybind",
["Options"] = {
["Default"] = "any?",
["Mode"] = "string?",
["AllowedModes"] = "table?",
["Blacklist"] = "table?",
["Blacklisted"] = "table?",
["Whitelist"] = "table?",
["Whitelisted"] = "table?",
["Modifiers"] = "table?",
["DefaultModifiers"] = "table?",
["ModifierWhitelist"] = "table?",
["WhitelistedModifiers"] = "table?",
["ModifierBlacklist"] = "table?",
["BlacklistModifiers"] = "table?",
["BlacklistedModifiers"] = "table?",
["ExactModifiers"] = "boolean?",
["CustomModes"] = "table?",
["Modes"] = "table?",
["AttachTo"] = "any?",
["SyncToggle"] = "boolean?",
["SyncToggleState"] = "boolean?",
["WaitForCallback"] = "boolean?",
["ChangedCallback"] = "function?",
["Clicked"] = "function?",
["NoUI"] = "boolean?",
["Mobile"] = "boolean?",
["MobileText"] = "string?",
},
["Required"] = { "Title" },
["Stateful"] = true,
},
["ColorPicker"] = {
["Method"] = "AddColorPicker",
["Options"] = {
["Default"] = "Color3?",
["Alpha"] = "boolean?",
["DefaultAlpha"] = "number?",
["Presets"] = "table?",
},
["Required"] = { "Title" },
["Stateful"] = true,
},
["Paragraph"] = {
["Method"] = "AddParagraph",
["Options"] = {
["Content"] = "string?",
["Variant"] = "string?",
["RichText"] = "boolean?",
["DoesWrap"] = "boolean?",
["Wrap"] = "boolean?",
["Size"] = "number?",
},
["Required"] = {},
["Stateful"] = false,
},
["Divider"] = {
["Method"] = "AddDivider",
["Options"] = {
["Text"] = "string?",
["Margin"] = "number?",
["MarginTop"] = "number?",
["MarginBottom"] = "number?",
},
["Required"] = {},
["Stateful"] = false,
},
["Status"] = {
["Method"] = "AddStatus",
["Options"] = { ["Value"] = "any?", ["Status"] = "string?", ["Pulse"] = "boolean?" },
["Required"] = { "Title" },
["Stateful"] = true,
},
["Progress"] = {
["Method"] = "AddProgress",
["Options"] = {
["Min"] = "number?",
["Max"] = "number?",
["Default"] = "number?",
["Suffix"] = "string?",
["ShowValue"] = "boolean?",
["Indeterminate"] = "boolean?",
["Format"] = "function?",
},
["Required"] = { "Title" },
["Stateful"] = true,
},
["Code"] = {
["Method"] = "AddCode",
["Options"] = {
["Code"] = "string?",
["Content"] = "string?",
["Language"] = "string?",
["Height"] = "number?",
["Copy"] = "boolean?",
},
["Required"] = {},
["Stateful"] = false,
},
["Image"] = {
["Method"] = "AddImage",
["Options"] = {
["Image"] = "string",
["Height"] = "number?",
["Caption"] = "string?",
["ScaleType"] = "EnumItem?",
["Tint"] = "Color3?",
["ImageColor3"] = "Color3?",
["Transparency"] = "number?",
["ImageTransparency"] = "number?",
["BackgroundTransparency"] = "number?",
["RectOffset"] = "Vector2?",
["RectSize"] = "Vector2?",
["ImageRectOffset"] = "Vector2?",
["ImageRectSize"] = "Vector2?",
},
["Required"] = { "Image" },
["Stateful"] = false,
},
["Passthrough"] = {
["Method"] = "AddPassthrough",
["Options"] = {
["Instance"] = "Instance",
["Height"] = "number?",
["Fill"] = "boolean?",
["Clone"] = "boolean?",
["DestroyInstance"] = "boolean?",
},
["Required"] = { "Instance" },
["Stateful"] = false,
},
["Viewport"] = {
["Method"] = "AddViewport",
["Options"] = {
["Object"] = "Instance",
["Clone"] = "boolean?",
["DestroyObject"] = "boolean?",
["Camera"] = "Instance?",
["Interactive"] = "boolean?",
["AutoFocus"] = "boolean?",
["Height"] = "number?",
},
["Required"] = { "Object" },
["Stateful"] = false,
},
["Video"] = {
["Method"] = "AddVideo",
["Options"] = {
["Video"] = "string",
["Looped"] = "boolean?",
["Playing"] = "boolean?",
["Volume"] = "number?",
["Height"] = "number?",
},
["Required"] = { "Video" },
["Stateful"] = false,
},
},
}
end

__modules["runtime/Signal"] = function()
local Signal = {}
Signal.__index = Signal
local Connection = {}
Connection.__index = Connection
function Connection:Disconnect()
if not self.Connected then
return
end
self.Connected = false
local signal = self._signal
signal._dirty = true
if signal._depth == 0 then
signal:_compact()
end
end
Connection.Destroy = Connection.Disconnect
function Signal.new(name: string?)
return setmetatable({
_name = name or "Signal",
_conns = {},
_depth = 0,
_dirty = false,
}, Signal)
end
function Signal.is(value): boolean
return type(value) == "table" and getmetatable(value) == Signal
end
function Signal:_compact()
local kept = {}
for _, conn in self._conns do
if conn.Connected then
table.insert(kept, conn)
end
end
self._conns = kept
self._dirty = false
end
function Signal:Connect(fn)
if type(fn) ~= "function" then
error(`[BobloUI] {self._name}:Connect expects a function, got {typeof(fn)}`, 2)
end
local conn = setmetatable({
Connected = true,
_fn = fn,
_signal = self,
}, Connection)
table.insert(self._conns, conn)
return conn
end
function Signal:Once(fn)
local conn
conn = self:Connect(function(...)
conn:Disconnect()
fn(...)
end)
return conn
end
function Signal:Fire(...)
local conns = self._conns
local count = #conns
if count == 0 then
return
end
self._depth += 1
for index = 1, count do
local conn = conns[index]
if conn and conn.Connected then
local ok, err = xpcall(conn._fn, debug.traceback, ...)
if not ok then
warn(`[BobloUI] error in {self._name} handler:\n{err}`)
end
end
end
self._depth -= 1
if self._depth == 0 and self._dirty then
self:_compact()
end
end
function Signal:Wait()
local co = coroutine.running()
local conn
conn = self:Connect(function(...)
conn:Disconnect()
task.spawn(co, ...)
end)
return coroutine.yield()
end
function Signal:DisconnectAll()
for _, conn in self._conns do
conn.Connected = false
end
self._conns = {}
self._dirty = false
end
function Signal:GetConnectionCount(): number
local n = 0
for _, conn in self._conns do
if conn.Connected then
n += 1
end
end
return n
end
Signal.Destroy = Signal.DisconnectAll
return Signal
end

__modules["runtime/Typography"] = function()
local HttpService = game:GetService("HttpService")
local Env = __require("runtime/Env")
local Typography = {}
local BASE_URL = "https://raw.githubusercontent.com/bobloscript/BobloUI/main/dist/assets/bobloui/fonts/"
local CACHE_ROOT = "BobloUI/assets/fonts"
local FAMILY_PATH = CACHE_ROOT .. "/Figtree.font"
local FACES = {
{ Key = "Regular", File = "Figtree-Regular.ttf", Bytes = 57504, Weight = 400, Enum = Enum.FontWeight.Regular },
{ Key = "Medium", File = "Figtree-Medium.ttf", Bytes = 57316, Weight = 500, Enum = Enum.FontWeight.Medium },
{ Key = "Bold", File = "Figtree-Bold.ttf", Bytes = 57672, Weight = 700, Enum = Enum.FontWeight.Bold },
{ Key = "Heavy", File = "Figtree-ExtraBold.ttf", Bytes = 57928, Weight = 800, Enum = Enum.FontWeight.ExtraBold },
}
local status = "Idle"
local lastError = nil
local preparedFonts = nil
local warned = false
local function fallback(fonts, message)
status = "Fallback"
lastError = message
preparedFonts = table.clone(fonts)
if not warned then
warn(`[BobloUI] Figtree unavailable ({message}); using BuilderSans fallback.`)
warned = true
end
return table.clone(preparedFonts)
end
local function ensureFolders()
if not Env.FS then
return false
end
for _, folder in { "BobloUI", "BobloUI/assets", CACHE_ROOT } do
if not Env.FS.IsFolder(folder) and not Env.FS.MakeFolder(folder) then
return false
end
end
return true
end
local function validFont(data, expectedBytes)
if type(data) ~= "string" or #data ~= expectedBytes then
return false
end
local signature = string.sub(data, 1, 4)
return signature == "\0\1\0\0" or signature == "OTTO"
end
local function loadFace(face)
local path = CACHE_ROOT .. "/" .. face.File
local contents = if Env.FS.IsFile(path) then Env.FS.Read(path) else nil
if not validFont(contents, face.Bytes) then
local downloaded, httpError = Env.HttpGet(BASE_URL .. face.File)
if not validFont(downloaded, face.Bytes) then
return nil, httpError or `{face.File} failed font validation`
end
if not Env.FS.Write(path, downloaded) then
return nil, `cannot write {face.File} to the font cache`
end
end
local asset = Env.GetCustomAsset(path)
if not asset then
return nil, `custom asset registration failed for {face.File}`
end
return asset, nil
end
function Typography.Prepare(fallbackFonts)
if preparedFonts then
return table.clone(preparedFonts)
end
if not Env.FS or not Env.Capabilities.CustomAsset then
return fallback(fallbackFonts, "executor has no filesystem/custom-asset API")
end
if not ensureFolders() then
return fallback(fallbackFonts, "cannot create the font cache folder")
end
status = "Preparing"
local familyFaces = {}
for _, face in FACES do
local asset, loadError = loadFace(face)
if not asset then
return fallback(fallbackFonts, loadError or "font face preparation failed")
end
table.insert(familyFaces, {
name = face.Key,
weight = face.Weight,
style = "normal",
assetId = asset,
})
end
local encoded = HttpService:JSONEncode({ name = "Figtree", faces = familyFaces })
if not Env.FS.Write(FAMILY_PATH, encoded) then
return fallback(fallbackFonts, "cannot write the Figtree family file")
end
local familyAsset = Env.GetCustomAsset(FAMILY_PATH)
if not familyAsset then
return fallback(fallbackFonts, "custom family registration failed")
end
local ok, fonts = pcall(function()
local out = {}
for _, face in FACES do
out[face.Key] = Font.new(familyAsset, face.Enum, Enum.FontStyle.Normal)
end
return out
end)
if not ok then
return fallback(fallbackFonts, tostring(fonts))
end
preparedFonts = fonts
status = "Ready"
lastError = nil
return table.clone(preparedFonts)
end
function Typography.GetStatus()
return status, lastError
end
return Typography
end

__modules["runtime/Util"] = function()
local Util = {}
function Util.assign(target: { [any]: any }, ...): { [any]: any }
for index = 1, select("#", ...) do
local source = select(index, ...)
if source then
for key, value in source do
target[key] = value
end
end
end
return target
end
function Util.copy(source: { [any]: any }): { [any]: any }
return table.clone(source)
end
function Util.deepCopy(source: any, seen: { [any]: any }?): any
if type(source) ~= "table" then
return source
end
seen = seen or {}
if seen[source] ~= nil then
return seen[source]
end
local out = {}
seen[source] = out
for key, value in source do
out[key] = Util.deepCopy(value, seen)
end
return out
end
function Util.keys(source: { [any]: any }): { any }
local out = {}
for key in source do
table.insert(out, key)
end
return out
end
function Util.lerp(from: number, to: number, alpha: number): number
return from + (to - from) * alpha
end
function Util.round(value: number, step: number?): number
local increment = step or 1
return math.round(value / increment) * increment
end
function Util.trim(text: string): string
local trimmed = text:gsub("^%s+", "")
trimmed = trimmed:gsub("%s+$", "")
return trimmed
end
function Util.startsWith(text: string, prefix: string): boolean
return text:sub(1, #prefix) == prefix
end
function Util.slug(text: string): string
local out = text:lower()
out = out:gsub("[^%w%.%-_]+", "-")
out = out:gsub("%-+", "-")
out = out:gsub("^%-+", "")
out = out:gsub("%-+$", "")
return out ~= "" and out or "untitled"
end
function Util.levenshtein(a: string, b: string): number
if a == b then
return 0
end
local lenA, lenB = #a, #b
if lenA == 0 then
return lenB
end
if lenB == 0 then
return lenA
end
local previous = table.create(lenB + 1)
for j = 0, lenB do
previous[j + 1] = j
end
for i = 1, lenA do
local current = table.create(lenB + 1)
current[1] = i
local charA = a:byte(i)
for j = 1, lenB do
local cost = if charA == b:byte(j) then 0 else 1
current[j + 1] = math.min(current[j] + 1, previous[j + 1] + 1, previous[j] + cost)
end
previous = current
end
return previous[lenB + 1]
end
function Util.suggest(word: string, candidates: { string }): string?
local lowered = word:lower()
local best, bestDistance = nil, math.huge
local limit = math.max(2, math.floor(#word / 3))
for _, candidate in candidates do
local distance = Util.levenshtein(lowered, candidate:lower())
if distance < bestDistance then
best, bestDistance = candidate, distance
end
end
if best and bestDistance <= limit then
return best
end
return nil
end
function Util.hex(value: string): Color3
return Color3.fromHex(value)
end
function Util.toHex(colour: Color3): string
return "#" .. colour:ToHex()
end
function Util.mix(from: Color3, to: Color3, alpha: number): Color3
return from:Lerp(to, alpha)
end
function Util.lighten(colour: Color3, amount: number): Color3
return colour:Lerp(Color3.new(1, 1, 1), amount)
end
function Util.darken(colour: Color3, amount: number): Color3
return colour:Lerp(Color3.new(0, 0, 0), amount)
end
local function linearChannel(channel: number): number
if channel <= 0.04045 then
return channel / 12.92
end
return ((channel + 0.055) / 1.055) ^ 2.4
end
function Util.luminance(colour: Color3): number
return 0.2126 * linearChannel(colour.R) + 0.7152 * linearChannel(colour.G) + 0.0722 * linearChannel(colour.B)
end
function Util.contrastRatio(first: Color3, second: Color3): number
local a = Util.luminance(first)
local b = Util.luminance(second)
local lighter = math.max(a, b)
local darker = math.min(a, b)
return (lighter + 0.05) / (darker + 0.05)
end
function Util.contrastText(background: Color3): Color3
local dark = Color3.new(0, 0, 0)
local light = Color3.new(1, 1, 1)
return if Util.contrastRatio(background, dark) >= Util.contrastRatio(background, light) then dark else light
end
function Util.now(): number
return os.clock()
end
return Util
end

__modules["runtime/Validate"] = function()
local Manifest = __require("runtime/RuntimeManifest")
local Util = __require("runtime/Util")
local Validate = {}
local Components = Manifest.Components or Manifest
local Common = Manifest.Common or {}
local function optionsFor(spec)
local options = {}
for key, value in Common do
options[key] = value
end
for key, value in spec.Options or {} do
options[key] = value
end
return options
end
local function matches(value, spec)
if value == nil then
return string.find(spec, "?", 1, true) ~= nil or spec == "any?"
end
if string.find(spec, "any", 1, true) then
return true
end
for part in string.gmatch(spec, "[^|]+") do
part = string.gsub(part, "%?", "")
if part == "string" and type(value) == "string" then
return true
elseif part == "number" and type(value) == "number" then
return true
elseif part == "boolean" and type(value) == "boolean" then
return true
elseif part == "function" and type(value) == "function" then
return true
elseif part == "table" and type(value) == "table" then
return true
elseif part == "Color3" and typeof(value) == "Color3" then
return true
elseif part == "Vector2" and typeof(value) == "Vector2" then
return true
elseif part == "Instance" and typeof(value) == "Instance" then
return true
elseif part == "EnumItem" and typeof(value) == "EnumItem" then
return true
end
end
return false
end
function Validate.Collect(typeName, options, path)
local errors = {}
local spec = Components[typeName]
path = path or typeName
if not spec then
return { `{path}: unknown control type "{typeName}"` }
end
if type(options) ~= "table" then
return { `{path}: expected an options table` }
end
if typeName == "Dropdown" and options.Options == nil and options.Values == nil and options.Source == nil then
table.insert(errors, `{path}: requires Options, Values, or Source`)
end
local available = optionsFor(spec)
local names = {}
for k in available do
table.insert(names, k)
end
table.sort(names)
for _, key in spec.Required or {} do
if options[key] == nil then
table.insert(errors, `{path}.{key}: required option is missing`)
end
end
for key, value in options do
local expected = available[key]
if not expected then
local suggestion = Util.suggest(tostring(key), names)
local hint = if suggestion then ` Did you mean "{suggestion}"?` else ""
table.insert(errors, `{path}.{tostring(key)}: unknown option.{hint}`)
elseif not matches(value, expected) then
table.insert(errors, `{path}.{key}: expected {expected}, got {typeof(value)}`)
end
end
return errors
end
function Validate.Control(typeName, options)
local spec = Components[typeName]
if not spec then
error(`[BobloUI] unknown control type "{typeName}".`, 3)
end
if type(options) ~= "table" then
error(`[BobloUI] {spec.Method} expects an options table.`, 3)
end
if typeName == "Dropdown" and options.Options == nil and options.Values == nil and options.Source == nil then
error("[BobloUI] AddDropdown requires Options, Values, or Source.", 3)
end
for _, key in spec.Required or {} do
if options[key] == nil then
error(`[BobloUI] {spec.Method}: required option "{key}" is missing.`, 3)
end
end
local available = optionsFor(spec)
local names = {}
for k in available do
table.insert(names, k)
end
table.sort(names)
for key, value in options do
local expected = available[key]
if not expected then
local suggestion = Util.suggest(tostring(key), names)
local hint = if suggestion then ' Did you mean "' .. suggestion .. '"?' else ""
warn(`[BobloUI] {spec.Method}: unknown option "{key}".{hint}\nValid options: {table.concat(names, ", ")}`)
elseif not matches(value, expected) then
error(`[BobloUI] {spec.Method}: option "{key}" expected {expected}, got {typeof(value)}.`, 3)
end
end
return options
end
return Validate
end

__modules["schema/Build"] = function()
local Manifest = __require("runtime/RuntimeManifest")
local Validate = __require("runtime/Validate")
local Build = {}
local Components = Manifest.Components or Manifest
local TAB_KEYS = {
Id = true,
Title = true,
Description = true,
Icon = true,
Order = true,
Badge = true,
Group = true,
Visible = true,
VisibleWhen = true,
EnabledWhen = true,
Disabled = true,
Locked = true,
LockedReason = true,
Sections = true,
Controls = true,
}
local SECTION_KEYS = {
Id = true,
Title = true,
Description = true,
Icon = true,
Collapsible = true,
Collapsed = true,
Column = true,
Span = true,
Layout = true,
Visible = true,
Controls = true,
}
local function unknownKeys(value, allowed, path, errors)
for key in value do
if not allowed[key] then
table.insert(errors, `{path}.{tostring(key)}: unknown field`)
end
end
end
local function validateControl(control, path, errors)
if type(control) ~= "table" then
table.insert(errors, path .. " must be a table")
return
end
if type(control.Type) ~= "string" or not Components[control.Type] then
table.insert(errors, path .. `.Type "{tostring(control.Type)}" is unknown`)
return
end
local options = {}
for k, v in control do
if k ~= "Type" then
options[k] = v
end
end
for _, err in Validate.Collect(control.Type, options, path) do
table.insert(errors, err)
end
end
local function validate(schema)
local errors = {}
if type(schema) ~= "table" then
return { "schema must be a table" }
end
unknownKeys(schema, { Tabs = true }, "schema", errors)
if type(schema.Tabs) ~= "table" then
table.insert(errors, "schema.Tabs must be an array")
return errors
end
for ti, tab in schema.Tabs do
local tp = `Tabs[{ti}]`
if type(tab) ~= "table" then
table.insert(errors, tp .. " must be a table")
continue
end
unknownKeys(tab, TAB_KEYS, tp, errors)
if type(tab.Title) ~= "string" then
table.insert(errors, tp .. ".Title must be a string")
end
if tab.Id ~= nil and type(tab.Id) ~= "string" then
table.insert(errors, tp .. ".Id must be a string")
end
if tab.Controls ~= nil and type(tab.Controls) ~= "table" then
table.insert(errors, tp .. ".Controls must be an array")
else
for ci, control in tab.Controls or {} do
validateControl(control, `{tp}.Controls[{ci}]`, errors)
end
end
if tab.Sections ~= nil and type(tab.Sections) ~= "table" then
table.insert(errors, tp .. ".Sections must be an array")
else
for si, section in tab.Sections or {} do
local sp = `{tp}.Sections[{si}]`
if type(section) ~= "table" then
table.insert(errors, sp .. " must be a table")
continue
end
unknownKeys(section, SECTION_KEYS, sp, errors)
if section.Column ~= nil and section.Column ~= 1 and section.Column ~= 2 then
table.insert(errors, sp .. ".Column must be 1 or 2")
end
if section.Span ~= nil and section.Span ~= "Auto" and section.Span ~= 1 and section.Span ~= 2 then
table.insert(errors, sp .. ".Span must be Auto, 1, or 2")
end
if
section.Layout ~= nil
and section.Layout ~= "Stack"
and section.Layout ~= "Grid"
and section.Layout ~= "Auto"
then
table.insert(errors, sp .. ".Layout must be Stack, Grid, or Auto")
end
if section.Controls ~= nil and type(section.Controls) ~= "table" then
table.insert(errors, sp .. ".Controls must be an array")
else
for ci, control in section.Controls or {} do
validateControl(control, `{sp}.Controls[{ci}]`, errors)
end
end
end
end
end
return errors
end
function Build.Validate(schema)
return validate(schema)
end
function Build.Run(window, schema)
local errors = validate(schema)
if #errors > 0 then
error("[BobloUI] UI:Build validation failed:\n - " .. table.concat(errors, "\n - "), 2)
end
local handles = {}
local function createControl(container, desc)
local spec = Components[desc.Type]
local method = spec.Method
local options = {}
for k, v in desc do
if k ~= "Type" then
options[k] = v
end
end
local h = container[method](container, options)
if h.Id then
handles[h.Id] = h
end
return h
end
for _, td in schema.Tabs do
local tab = window:AddTab({
Id = td.Id,
Title = td.Title,
Description = td.Description,
Icon = td.Icon,
Order = td.Order,
Badge = td.Badge,
Group = td.Group,
Visible = td.Visible,
Locked = td.Locked,
LockedReason = td.LockedReason,
})
if tab.Id then
handles[tab.Id] = tab
end
for _, cd in td.Controls or {} do
createControl(tab, cd)
end
for _, sd in td.Sections or {} do
local section = tab:AddSection({
Id = sd.Id,
Title = sd.Title,
Description = sd.Description,
Icon = sd.Icon,
Collapsible = sd.Collapsible,
Collapsed = sd.Collapsed,
Column = sd.Column,
Span = sd.Span,
Layout = sd.Layout,
Visible = sd.Visible,
VisibleWhen = sd.VisibleWhen,
EnabledWhen = sd.EnabledWhen,
Disabled = sd.Disabled,
})
if section.Id then
handles[section.Id] = section
end
for _, cd in sd.Controls or {} do
createControl(section, cd)
end
end
end
return handles
end
return Build
end

__modules["services/Commands"] = function()
local Commands = {}
Commands.__index = Commands
function Commands.new(window)
return setmetatable({ _window = window, _commands = {} }, Commands)
end
function Commands:Register(c)
if type(c) ~= "table" or type(c.Id) ~= "string" or type(c.Title) ~= "string" or type(c.Callback) ~= "function" then
error("[BobloUI] Commands:Register requires Id, Title, Callback.", 2)
end
self._commands[c.Id] = c
return c
end
function Commands:Unregister(id)
self._commands[id] = nil
end
function Commands:Run(id)
local c = self._commands[id]
if not c then
return false
end
if c.EnabledWhen and not c.EnabledWhen(self._window.State) then
return false
end
local ok, err = xpcall(c.Callback, debug.traceback)
if not ok then
warn(`[BobloUI] command "{id}" failed:\n{err}`)
end
return ok
end
function Commands:List()
local o = {}
for _, c in self._commands do
table.insert(o, c)
end
table.sort(o, function(a, b)
return a.Title < b.Title
end)
return o
end
function Commands:Query(text)
local q = string.lower(text or "")
local o = {}
for _, c in self._commands do
local hay = string.lower(c.Title .. " " .. table.concat(c.Keywords or {}, " "))
if q == "" or string.find(hay, q, 1, true) then
table.insert(
o,
{ Kind = "Command", Id = c.Id, Title = c.Title, Icon = c.Icon, Callback = c.Callback, Command = c }
)
end
end
table.sort(o, function(a, b)
return a.Title < b.Title
end)
return o
end
function Commands:Destroy()
self._commands = {}
end
return Commands
end

__modules["services/Config"] = function()
local HttpService = game:GetService("HttpService")
local Signal = __require("runtime/Signal")
local Util = __require("runtime/Util")
local Storage = __require("services/Storage")
local Env = __require("runtime/Env")
local Config = {}
Config.__index = Config
local CURRENT = 1
local function serialize(value, seen)
local kind = typeof(value)
if kind == "Color3" then
return { __type = "Color3", Hex = value:ToHex() }
end
if kind == "Vector2" then
return { __type = "Vector2", X = value.X, Y = value.Y }
end
if kind == "Vector3" then
return { __type = "Vector3", X = value.X, Y = value.Y, Z = value.Z }
end
if kind == "UDim" then
return { __type = "UDim", Scale = value.Scale, Offset = value.Offset }
end
if kind == "UDim2" then
return {
__type = "UDim2",
XS = value.X.Scale,
XO = value.X.Offset,
YS = value.Y.Scale,
YO = value.Y.Offset,
}
end
if kind == "EnumItem" then
return { __type = "EnumItem", Enum = tostring(value.EnumType), Name = value.Name }
end
if type(value) == "table" then
seen = seen or {}
if seen[value] then
error("[BobloUI] Config cannot serialize a cyclic table.", 0)
end
seen[value] = true
local out = {}
for key, child in value do
out[key] = serialize(child, seen)
end
seen[value] = nil
return out
end
if type(value) == "number" or type(value) == "string" or type(value) == "boolean" or value == nil then
return value
end
return tostring(value)
end
local function deserialize(value)
if type(value) ~= "table" then
return value
end
if value.__type == "Color3" then
local ok, colour = pcall(Color3.fromHex, value.Hex)
return if ok then colour else Color3.new(1, 1, 1)
end
if value.__type == "Vector2" then
return Vector2.new(value.X or 0, value.Y or 0)
end
if value.__type == "Vector3" then
return Vector3.new(value.X or 0, value.Y or 0, value.Z or 0)
end
if value.__type == "UDim" then
return UDim.new(value.Scale or 0, value.Offset or 0)
end
if value.__type == "UDim2" then
return UDim2.new(value.XS or 0, value.XO or 0, value.YS or 0, value.YO or 0)
end
if value.__type == "EnumItem" then
local enumName = string.match(value.Enum or "", "Enum%.(.+)")
local enumType = enumName and Enum[enumName]
return if enumType then enumType[value.Name] else value.Name
end
local out = {}
for key, child in value do
out[key] = deserialize(child)
end
return out
end
local function decode(raw, label)
local ok, data = pcall(HttpService.JSONDecode, HttpService, raw)
if not ok or type(data) ~= "table" then
return nil, `{label or "config"} is not a valid JSON object`
end
return data
end
local function serviceValue(service, getter, defaultValue)
if service ~= nil then
local value = getter(service)
if value ~= nil then
return value
end
end
return defaultValue
end
function Config.new(window, folder)
local self = setmetatable({
Saved = Signal.new("Config.Saved"),
Loaded = Signal.new("Config.Loaded"),
_window = window,
_storage = Storage.new(folder),
_folder = folder,
_migrations = {},
_pending = {},
_orphans = {},
_ignored = {},
_pendingCollapsed = {},
_autoload = nil,
}, Config)
self._registryConn = window.Registry.Added:Connect(function(entry)
if entry.Id and self._pending[entry.Id] ~= nil then
local value = self._pending[entry.Id]
self._pending[entry.Id] = nil
self._orphans[entry.Id] = nil
window.State:Set(entry.Id, value, { Source = "CONFIG", Silent = false })
end
if entry.Id and self._pendingCollapsed[entry.Id] ~= nil and entry.Handle and entry.Handle.SetCollapsed then
local value = self._pendingCollapsed[entry.Id]
self._pendingCollapsed[entry.Id] = nil
entry.Handle:SetCollapsed(value)
end
end)
local autoload = self._storage:Read("autoload.txt")
if autoload and autoload ~= "" then
self._autoload = autoload
end
return self
end
function Config:SetFolder(folder)
self._folder = folder
self._storage = Storage.new(folder)
local autoload = self._storage:Read("autoload.txt")
self._autoload = if autoload and autoload ~= "" then autoload else nil
return self
end
function Config:_file(name)
return `configs/{name}.json`
end
function Config:_ensureConfigDir()
if Env.FS and not Env.FS.IsFolder(self._storage.Root .. "/configs") then
Env.FS.MakeFolder(self._storage.Root .. "/configs")
end
end
function Config:List()
local out = {}
local entries = if Env.FS then Env.FS.List(self._storage.Root .. "/configs") else self._storage:List()
for _, path in entries do
local name = string.match(path, "([^/\\]+)%.json$")
if name and name ~= "autoload" then
table.insert(out, name)
end
end
table.sort(out)
return out
end
function Config:SetIgnored(id, value)
self._ignored[id] = value == true
return self
end
function Config:_existingEnvelope(name)
local raw = self._storage:Read(self:_file(name))
if not raw then
return {}
end
local data, err = decode(raw, "existing config")
if not data then
return nil, err
end
return data
end
function Config:Save(name)
if type(name) ~= "string" or name == "" then
return false, "invalid name"
end
self:_ensureConfigDir()
local envelope, existingError = self:_existingEnvelope(name)
if not envelope then
return false, existingError
end
local existingValues = if type(envelope.values) == "table" then envelope.values else {}
local values = {}
for id, rawValue in existingValues do
if not self._window.Registry:Has(id) then
values[id] = rawValue
end
end
local okValues, valuesError = xpcall(function()
for _, entry in self._window.Registry:GetPersistable() do
if not self._ignored[entry.Id] then
values[entry.Id] = serialize(entry.Handle:GetValue())
end
end
for id, value in self._orphans do
if values[id] == nil then
values[id] = serialize(value)
end
end
end, debug.traceback)
if not okValues then
return false, valuesError
end
local collapsed = {}
for _, tab in self._window._tabs or {} do
for _, section in tab._sections or {} do
if section.Id then
collapsed[section.Id] = section.Collapsed == true
end
end
end
local geometry = nil
if self._window.GetRememberGeometry and self._window:GetRememberGeometry() then
geometry = self._window:GetGeometry()
end
local themeData = nil
if self._window.Theme.Export ~= nil then
themeData = self._window.Theme:Export()
end
local scale = 1
if self._window.GetScale ~= nil then
scale = self._window:GetScale()
end
local locale = "en"
if self._window.Locale ~= nil then
locale = self._window.Locale:Get()
end
local favorites = {}
if self._window.Favorites ~= nil then
favorites = self._window.Favorites:List()
end
local reducedMotion = false
if self._window.Motion ~= nil then
reducedMotion = not self._window.Motion.Enabled
end
local keyboardNavigation = serviceValue(self._window.Navigation, function(service)
return service:IsEnabled()
end, true)
local uiSounds = serviceValue(self._window.Sound, function(service)
return service:IsEnabled()
end, true)
local soundVolume = serviceValue(self._window.Sound, function(service)
return service:GetVolume()
end, 1)
local meta = if type(envelope.meta) == "table" then Util.deepCopy(envelope.meta) else {}
meta.theme = self._window.Theme:Current()
meta.themeData = themeData
meta.accent = serialize(self._window.Theme:Get("Accent"))
meta.density = self._window.Tokens:GetDensity()
meta.scale = scale
meta.locale = locale
meta.favorites = favorites
meta.collapsed = collapsed
meta.geometry = serialize(geometry)
meta.reducedMotion = reducedMotion
meta.keyboardNavigation = keyboardNavigation
meta.uiSounds = uiSounds
meta.soundVolume = soundVolume
envelope["$schema"] = CURRENT
envelope.name = name
envelope.library = "BobloUI"
envelope.libraryVersion = self._window.Version
envelope.savedAt = os.time()
envelope.values = values
envelope.meta = meta
local ok, json = pcall(HttpService.JSONEncode, HttpService, envelope)
if not ok then
return false, json
end
local wrote = self._storage:Write(self:_file(name), json)
if wrote then
self.Saved:Fire(name)
end
return wrote, if wrote then nil else "write failed"
end
function Config:Load(name)
local raw = self._storage:Read(self:_file(name))
if not raw then
return false, "config not found"
end
local data, decodeError = decode(raw)
if not data then
return false, decodeError
end
if data.values ~= nil and type(data.values) ~= "table" then
return false, "invalid config: values must be an object"
end
local version = tonumber(data["$schema"]) or 0
if version < CURRENT then
self._storage:Write(self:_file(name) .. ".bak", raw)
while version < CURRENT do
local migration = self._migrations[version]
if not migration then
return false, `[BobloUI] missing config migration {version} -> {version + 1}.`
end
local okMigration, result = xpcall(migration, debug.traceback, data)
if not okMigration then
return false, result
end
data = result or data
version += 1
data["$schema"] = version
end
end
self._pending = {}
self._orphans = {}
self._window.State:Batch(function()
for id, rawValue in data.values or {} do
local value = deserialize(rawValue)
if self._window.Registry:Has(id) then
self._window.State:Set(id, value, { Source = "CONFIG" })
else
self._pending[id] = value
self._orphans[id] = value
end
end
end)
local meta = if type(data.meta) == "table" then data.meta else {}
if meta.themeData and self._window.ImportTheme then
pcall(function()
self._window:ImportTheme(meta.themeData)
end)
elseif meta.theme then
pcall(function()
self._window:SetTheme(meta.theme)
end)
end
if meta.accent and not meta.themeData then
pcall(function()
self._window:SetAccent(deserialize(meta.accent))
end)
end
if meta.density then
pcall(function()
self._window:SetDensity(meta.density)
end)
end
if meta.scale and self._window.SetScale then
pcall(function()
self._window:SetScale(meta.scale)
end)
end
if meta.locale and self._window.SetLocale then
pcall(function()
self._window:SetLocale(meta.locale)
end)
end
if self._window.Favorites and type(meta.favorites) == "table" then
self._window.Favorites:Set(meta.favorites)
end
if meta.reducedMotion ~= nil and self._window.SetReducedMotion then
pcall(function()
self._window:SetReducedMotion(meta.reducedMotion == true)
end)
end
if meta.keyboardNavigation ~= nil and self._window.SetKeyboardNavigation then
pcall(function()
self._window:SetKeyboardNavigation(meta.keyboardNavigation ~= false)
end)
end
if meta.uiSounds ~= nil and self._window.SetUISounds then
pcall(function()
self._window:SetUISounds(meta.uiSounds ~= false)
end)
end
if meta.soundVolume ~= nil and self._window.SetSoundVolume then
pcall(function()
self._window:SetSoundVolume(meta.soundVolume)
end)
end
if type(meta.collapsed) == "table" then
for id, value in meta.collapsed do
local section = self._window:Get(id)
if section and section.SetCollapsed then
section:SetCollapsed(value == true)
else
self._pendingCollapsed[id] = value == true
end
end
end
if meta.geometry and self._window.GetRememberGeometry and self._window:GetRememberGeometry() then
local geometry = deserialize(meta.geometry)
if type(geometry) == "table" then
if geometry.Size then
self._window:SetSize(geometry.Size)
end
if geometry.Position then
self._window:SetPosition(geometry.Position)
end
if geometry.Scale then
self._window:SetScale(geometry.Scale)
end
if geometry.Locked ~= nil then
self._window:SetLocked(geometry.Locked)
end
if geometry.SidebarWidth and self._window.SetSidebarWidth then
self._window:SetSidebarWidth(geometry.SidebarWidth)
end
if geometry.SidebarHidden ~= nil and self._window.SetSidebarHidden then
self._window:SetSidebarHidden(geometry.SidebarHidden)
end
if geometry.Compact ~= nil and self._window.SetCompact then
self._window:SetCompact(geometry.Compact)
end
if geometry.SidebarCompacted ~= nil and self._window.SetSidebarCompacted then
self._window:SetSidebarCompacted(geometry.SidebarCompacted)
end
end
end
self.Loaded:Fire(name)
return true
end
function Config:Delete(name)
local raw = self._storage:Read(self:_file(name))
local deleted = self._storage:Delete(self:_file(name))
if deleted and self._autoload == name then
if not self._storage:Write("autoload.txt", "") then
if raw ~= nil then
self._storage:Write(self:_file(name), raw)
end
return false, "autoload update failed"
end
self._autoload = nil
end
return deleted, if deleted then nil else "delete failed"
end
function Config:Rename(fromName, toName)
if type(fromName) ~= "string" or fromName == "" or type(toName) ~= "string" or toName == "" then
return false, "invalid name"
end
if fromName == toName then
return true
end
local raw = self._storage:Read(self:_file(fromName))
if not raw then
return false, "not found"
end
if self._storage:Exists(self:_file(toName)) then
return false, "destination exists"
end
if not self._storage:Write(self:_file(toName), raw) then
return false, "write failed"
end
local updatesAutoload = self._autoload == fromName
if updatesAutoload and not self._storage:Write("autoload.txt", toName) then
self._storage:Delete(self:_file(toName))
return false, "autoload update failed"
end
if not self._storage:Delete(self:_file(fromName)) then
self._storage:Delete(self:_file(toName))
if updatesAutoload then
self._storage:Write("autoload.txt", fromName)
end
return false, "delete failed"
end
if updatesAutoload then
self._autoload = toName
end
return true
end
function Config:Duplicate(fromName, toName)
local raw = self._storage:Read(self:_file(fromName))
if not raw then
return false, "not found"
end
return self._storage:Write(self:_file(toName), raw)
end
function Config:Export(name)
local raw = self._storage:Read(self:_file(name))
if raw then
Env.SetClipboard(raw)
end
return raw
end
function Config:Import(json, name)
if type(name) ~= "string" or name == "" then
return false, "invalid name"
end
local data = decode(json, "import")
if not data then
return false, "invalid json"
end
if data.values ~= nil and type(data.values) ~= "table" then
return false, "invalid config: values must be an object"
end
self:_ensureConfigDir()
return self._storage:Write(self:_file(name), json)
end
function Config:SetAutoLoad(name)
if name == "" then
name = nil
end
if self._storage:Write("autoload.txt", name or "") then
self._autoload = name
else
warn("[BobloUI] failed to update config autoload pointer.")
end
return self
end
function Config:GetAutoLoad()
return self._autoload
end
function Config:LoadAuto()
if self._autoload then
return self:Load(self._autoload)
end
return false, "no autoload"
end
function Config:RegisterMigration(fromVersion, toVersion, callback)
if toVersion ~= fromVersion + 1 then
error("[BobloUI] config migrations must be linear (N -> N+1).", 2)
end
self._migrations[fromVersion] = callback
return self
end
function Config:Destroy()
if self._registryConn then
self._registryConn:Disconnect()
end
self.Saved:Destroy()
self.Loaded:Destroy()
self._pending = {}
self._orphans = {}
self._pendingCollapsed = {}
end
return Config
end

__modules["services/Cursor"] = function()
local UserInputService = game:GetService("UserInputService")
local Create = __require("runtime/Create")
local Cursor = {}
Cursor.__index = Cursor
function Cursor.new(window)
return setmetatable({ _window = window, _enabled = false, _root = nil, _conn = nil, _oldMouseIcon = nil }, Cursor)
end
function Cursor:SetEnabled(enabled, options)
enabled = enabled == true
if enabled == self._enabled then
return self
end
self._enabled = enabled
if not enabled then
if self._conn then
self._conn:Disconnect()
self._conn = nil
end
if self._root then
self._root:Destroy()
self._root = nil
end
if self._oldMouseIcon ~= nil then
UserInputService.MouseIconEnabled = self._oldMouseIcon
self._oldMouseIcon = nil
end
return self
end
if self._window.Device.Class == "Phone" then
self._enabled = false
return self
end
options = options or {}
self._oldMouseIcon = UserInputService.MouseIconEnabled
UserInputService.MouseIconEnabled = false
local w = self._window
self._root = Create.New("Frame", {
Size = UDim2.fromOffset(options.Size or 10, options.Size or 10),
AnchorPoint = Vector2.new(0.5, 0.5),
BackgroundTransparency = 0,
BorderSizePixel = 0,
ZIndex = 9999,
Parent = w.Layers.Overlay,
})
Create.New("UICorner", { CornerRadius = UDim.new(1, 0), Parent = self._root })
w:_bind(self._root, { BackgroundColor3 = options.Token or "Accent" })
local pos = UserInputService:GetMouseLocation()
self._root.Position = UDim2.fromOffset(pos.X, pos.Y)
self._conn = UserInputService.InputChanged:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseMovement and self._root then
self._root.Position = UDim2.fromOffset(input.Position.X, input.Position.Y)
end
end)
return self
end
function Cursor:IsEnabled()
return self._enabled
end
function Cursor:Destroy()
self:SetEnabled(false)
end
return Cursor
end

__modules["services/Dialog"] = function()
local TextService = game:GetService("TextService")
local Create = __require("runtime/Create")
local Signal = __require("runtime/Signal")
local Janitor = __require("runtime/Janitor")
local Surface = __require("primitives/Surface")
local Sheet = __require("primitives/Sheet")
local Icon = __require("primitives/Icon")
local DialogSection = __require("services/DialogSection")
local Dialog = {}
Dialog.__index = Dialog
function Dialog.new(window)
return setmetatable({ _window = window, _open = {} }, Dialog)
end
function Dialog:_width()
return math.max(240, math.min(392, self._window.Device.Viewport.X - 32))
end
function Dialog:_measure(text, width)
if not text or text == "" then
return 0
end
local w = self._window
local ok, size = pcall(function()
if typeof(w.Fonts.Regular) == "Font" then
local params = Instance.new("GetTextBoundsParams")
params.Text = tostring(text)
params.Size = w.Tokens:Get("FontBody")
params.Width = width
params.Font = w.Fonts.Regular
return TextService:GetTextBoundsAsync(params)
end
return TextService:GetTextSize(
tostring(text),
w.Tokens:Get("FontBody"),
w.Fonts.Regular,
Vector2.new(width, 1000)
)
end)
return if ok then math.max(18, size.Y) else 36
end
function Dialog:_surface(height, onDismiss, options)
options = options or {}
local w = self._window
if w.Device.Layout == "Drawer" then
local h = Sheet.open(w, height, { OnDismiss = onDismiss, Modal = options.OutsideClickDismiss ~= true })
return h, h.Frame
end
local safeHeight = math.max(1, math.min(height, math.max(1, w.Device.Viewport.Y - 32)))
local h = w.Layers:Push({
Scrim = true,
ScrimTransparency = options.ScrimTransparency,
Modal = options.OutsideClickDismiss ~= true,
OnDismiss = onDismiss,
})
local frame = Surface.new(w, {
Size = UDim2.fromOffset(self:_width(), safeHeight),
Position = UDim2.fromScale(0.5, 0.5),
AnchorPoint = Vector2.new(0.5, 0.5),
BorderSizePixel = 0,
ClipsDescendants = true,
Parent = h.Container,
}, {
Token = "SurfaceRaised",
StrokeToken = "Border",
StrokeTransparency = 0.40,
Corner = w.Tokens:Get("CornerLg"),
})
frame.ZIndex = h.Depth * 10 + 3
return h, frame
end
function Dialog:_title(parent, text, icon, colorToken, titleColor)
local w = self._window
local iconHost = Create.New("Frame", {
Size = UDim2.fromOffset(28, 28),
Position = UDim2.fromOffset(16, 11),
BorderSizePixel = 0,
Parent = parent,
})
Create.New("UICorner", { CornerRadius = UDim.new(0, 8), Parent = iconHost })
local iconStroke = Create.New("UIStroke", { Thickness = 1, Transparency = 0.58, Parent = iconHost })
w:_bind(iconHost, { BackgroundColor3 = "SurfaceInset" })
w:_bind(iconStroke, { Color = "BorderSubtle" })
local glyph = Icon.new(w, icon or "info", {
Size = UDim2.fromOffset(15, 15),
Position = UDim2.fromScale(0.5, 0.5),
AnchorPoint = Vector2.new(0.5, 0.5),
Parent = iconHost,
})
Icon.setColor(glyph, w.Theme:Get(colorToken or "Accent"))
local title = Create.New("TextLabel", {
Size = UDim2.new(1, -66, 0, 24),
Position = UDim2.fromOffset(52, 14),
BackgroundTransparency = 1,
Font = w.Fonts.Bold,
TextSize = w.Tokens:Get("FontTitle"),
TextXAlignment = Enum.TextXAlignment.Left,
Text = text or "",
Parent = parent,
})
if typeof(titleColor) == "Color3" then
title.TextColor3 = titleColor
else
w:_bind(title, { TextColor3 = "Text" })
end
return title
end
function Dialog:_button(parent, text, primary, danger, callback, options)
options = options or {}
local w = self._window
local bg = if danger and primary then "Error" elseif primary then "AccentButton" else "ControlInset"
local fg = if danger and primary then "TextOnError" elseif primary then "TextOnAccentButton" else "TextSecondary"
local hoverBg = if danger and primary then "ErrorHover" elseif primary then "AccentButtonHover" else "ControlHover"
local pressedBg = if danger and primary
then "ErrorPressed"
elseif primary then "AccentButtonPressed"
else "ControlPressed"
local full = options.FullWidth == true
local b = Create.New("TextButton", {
AutomaticSize = if full then Enum.AutomaticSize.None else Enum.AutomaticSize.X,
Size = if full then UDim2.new(1, 0, 0, 34) else UDim2.new(0, 0, 0, 34),
BackgroundTransparency = 0,
BorderSizePixel = 0,
AutoButtonColor = false,
Text = if full then tostring(text) else "  " .. tostring(text) .. "  ",
TextXAlignment = if full then Enum.TextXAlignment.Left else Enum.TextXAlignment.Center,
Font = w.Fonts.Medium,
TextSize = w.Tokens:Get("FontBody"),
Parent = parent,
})
if full then
Create.New("UIPadding", {
PaddingLeft = UDim.new(0, if options.Icon then 36 else 11),
PaddingRight = UDim.new(0, 11),
Parent = b,
})
if options.Icon then
local glyph = Icon.new(w, options.Icon, {
Size = UDim2.fromOffset(15, 15),
Position = UDim2.fromOffset(-25, 17),
AnchorPoint = Vector2.new(0, 0.5),
Parent = b,
})
Icon.setColor(glyph, w.Theme:Get(fg))
end
end
Create.New("UICorner", { CornerRadius = UDim.new(0, w.Tokens:Get("FieldRadius")), Parent = b })
local stroke = Create.New("UIStroke", { Thickness = 1, Transparency = 0.58, Parent = b })
w:_bind(
stroke,
{ Color = if danger and primary then "ErrorHover" elseif primary then "AccentBorder" else "BorderSubtle" }
)
w:_bind(b, { BackgroundColor3 = bg, TextColor3 = fg })
local hovered = false
local pressed = false
local function refresh()
if b.Parent then
b.BackgroundColor3 = w.Theme:Get(if pressed then pressedBg elseif hovered then hoverBg else bg)
end
end
b.MouseEnter:Connect(function()
hovered = true
refresh()
end)
b.MouseLeave:Connect(function()
hovered = false
pressed = false
refresh()
end)
b.MouseButton1Down:Connect(function()
pressed = true
refresh()
end)
b.MouseButton1Up:Connect(function()
pressed = false
refresh()
end)
local themeConnection = w.Theme.Changed:Connect(refresh)
b.Destroying:Connect(function()
themeConnection:Disconnect()
end)
b.MouseButton1Click:Connect(callback)
return b
end
function Dialog:_make(options, kind)
options = options or {}
local w = self._window
local resultSignal = Signal.new("Dialog.Resolved")
local resultHandle = { Resolved = resultSignal, _resolved = false, _result = nil }
local width = self:_width()
local contentHeight = self:_measure(options.Content or "", width - 32)
local titleY = 14
local contentY = 44
local afterContent = contentY + contentHeight
if contentHeight == 0 then
afterContent = 43
end
local inputY = afterContent + (kind == "Prompt" and 12 or 0)
local buttonsY = if kind == "Prompt" then inputY + 34 + 16 else afterContent + 16
local height = math.max(kind == "Prompt" and 184 or 138, buttonsY + 34 + 14)
local layerHandle, frame
local function removeOpen()
local p = table.find(self._open, resultHandle)
if p then
table.remove(self._open, p)
end
end
local function dismissed()
if not resultHandle._resolved then
resultHandle._resolved = true
resultHandle._result = nil
resultSignal:Fire(nil)
removeOpen()
end
end
layerHandle, frame = self:_surface(height, dismissed, options)
resultHandle._layer = layerHandle
local defaultIcon = if kind == "Prompt"
then "text-cursor-input"
elseif kind == "Confirm" then "circle-question-mark"
elseif options.Danger then "triangle-alert"
else "info"
self:_title(frame, options.Title or "", options.Icon or defaultIcon, options.Danger and "Error" or "Accent")
if contentHeight > 0 then
local content = Create.New("TextLabel", {
Size = UDim2.new(1, -32, 0, contentHeight),
Position = UDim2.fromOffset(16, contentY),
BackgroundTransparency = 1,
Font = w.Fonts.Regular,
TextSize = w.Tokens:Get("FontBody"),
TextWrapped = true,
TextXAlignment = Enum.TextXAlignment.Left,
TextYAlignment = Enum.TextYAlignment.Top,
Text = options.Content or "",
Parent = frame,
})
w:_bind(content, { TextColor3 = "TextSecondary" })
end
local input = nil
if kind == "Prompt" then
input = Create.New("TextBox", {
Size = UDim2.new(1, -32, 0, 34),
Position = UDim2.fromOffset(16, inputY),
BackgroundTransparency = 0,
BorderSizePixel = 0,
ClearTextOnFocus = false,
PlaceholderText = options.Placeholder or "",
Text = options.Default or "",
Font = w.Fonts.Regular,
TextSize = w.Tokens:Get("FontBody"),
TextXAlignment = Enum.TextXAlignment.Left,
Parent = frame,
})
Create.New("UICorner", { CornerRadius = UDim.new(0, w.Tokens:Get("FieldRadius")), Parent = input })
Create.New("UIPadding", { PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10), Parent = input })
local stroke = Create.New("UIStroke", { Thickness = 1, Transparency = 0.54, Parent = input })
w:_bind(stroke, { Color = "BorderSubtle" })
w:_bind(input, { BackgroundColor3 = "ControlInset", TextColor3 = "Text", PlaceholderColor3 = "TextTertiary" })
input.Focused:Connect(function()
stroke.Transparency = 0.08
stroke.Color = w.Theme:Get("AccentBorder")
end)
input.FocusLost:Connect(function()
stroke.Transparency = 0.54
stroke.Color = w.Theme:Get("BorderSubtle")
end)
end
local function resolve(v)
if resultHandle._resolved then
return
end
resultHandle._resolved = true
resultHandle._result = v
resultSignal:Fire(v)
removeOpen()
layerHandle:Dismiss()
end
function resultHandle:Resolve(v)
resolve(v)
end
function resultHandle:Close()
resolve(nil)
end
function resultHandle:IsOpen()
return not self._resolved and layerHandle:IsOpen()
end
function resultHandle:Await()
if self._resolved then
return self._result
end
return self.Resolved:Wait()
end
function resultHandle:Destroy()
self:Close()
self.Resolved:Destroy()
end
local buttons = Create.New("Frame", {
Size = UDim2.new(1, -32, 0, 34),
Position = UDim2.fromOffset(16, buttonsY),
BackgroundTransparency = 1,
Parent = frame,
})
Create.List(7, Enum.FillDirection.Horizontal, { HorizontalAlignment = Enum.HorizontalAlignment.Right }).Parent =
buttons
if kind == "Alert" then
self:_button(buttons, options.Button or "OK", true, options.Danger == true, function()
resolve(true)
end)
elseif kind == "Confirm" then
self:_button(buttons, options.Cancel or "Cancel", false, false, function()
resolve(false)
end)
self:_button(buttons, options.Confirm or "Confirm", true, options.Danger == true, function()
resolve(true)
end)
else
self:_button(buttons, options.Cancel or "Cancel", false, false, function()
resolve(nil)
end)
self:_button(buttons, options.Confirm or "OK", true, false, function()
resolve(input.Text)
end)
end
table.insert(self._open, resultHandle)
return resultHandle
end
function Dialog:Alert(o)
return self:_make(o, "Alert")
end
function Dialog:Confirm(o)
return self:_make(o, "Confirm")
end
function Dialog:Prompt(o)
return self:_make(o, "Prompt")
end
function Dialog:Choice(options)
options = options or {}
local choices = options.Choices or {}
local w = self._window
local result = Signal.new("Dialog.Choice")
local handle = { Resolved = result, _resolved = false, _result = nil }
local rowHeight, gap = 34, 6
local maxListHeight = math.max(34, math.min(274, w.Device.Viewport.Y - 150))
local naturalHeight = #choices * rowHeight + math.max(0, #choices - 1) * gap
local listHeight = math.min(maxListHeight, math.max(rowHeight, naturalHeight))
local height = 50 + listHeight + 16
local layer, frame
local function resolve(v)
if handle._resolved then
return
end
handle._resolved = true
handle._result = v
result:Fire(v)
if layer then
layer:Dismiss()
end
end
layer, frame = self:_surface(height, function()
resolve(nil)
end)
self:_title(frame, options.Title or "Choose", options.Icon or "list-check", "Accent")
local scroll = naturalHeight > listHeight
local list
if scroll then
list = Create.New("ScrollingFrame", {
Size = UDim2.new(1, -32, 0, listHeight),
Position = UDim2.fromOffset(16, 50),
BackgroundTransparency = 1,
BorderSizePixel = 0,
CanvasSize = UDim2.new(),
AutomaticCanvasSize = Enum.AutomaticSize.Y,
ScrollingDirection = Enum.ScrollingDirection.Y,
ScrollBarThickness = 2,
Parent = frame,
})
w:_bind(list, { ScrollBarImageColor3 = "BorderStrong" })
else
list = Create.New("Frame", {
Size = UDim2.new(1, -32, 0, listHeight),
Position = UDim2.fromOffset(16, 50),
BackgroundTransparency = 1,
Parent = frame,
})
end
Create.List(gap).Parent = list
for _, choice in choices do
self:_button(
list,
choice.Text or tostring(choice.Value),
choice.Primary == true,
choice.Danger == true,
function()
resolve(choice.Value)
end,
{ FullWidth = true, Icon = choice.Icon }
)
end
function handle:Resolve(v)
resolve(v)
end
function handle:Close()
resolve(nil)
end
function handle:IsOpen()
return not self._resolved and layer:IsOpen()
end
function handle:Await()
if self._resolved then
return self._result
end
return self.Resolved:Wait()
end
function handle:Destroy()
self:Close()
self.Resolved:Destroy()
end
return handle
end
function Dialog:Custom(options)
options = options or {}
local w = self._window
local j = Janitor.new("Dialog.Custom")
local handle = { _buttons = {}, _closed = false, _result = nil, Closed = Signal.new("Dialog.Custom.Closed") }
j:Add(handle.Closed)
local layer, frame
local function removeOpen()
local position = table.find(self._open, handle)
if position then
table.remove(self._open, position)
end
end
local function dismissed()
if handle._closed then
return
end
handle._closed = true
handle.Result = handle._result
handle.Closed:Fire(handle._result)
removeOpen()
j:Destroy()
end
layer, frame = self:_surface(options.Height or 380, dismissed, options)
handle._layer = layer
handle._frame = frame
handle._title =
self:_title(frame, options.Title or "", options.Icon or "layout-template", "Accent", options.TitleColor)
local descriptionHeight = self:_measure(options.Description or "", self:_width() - 32)
local contentTop = if descriptionHeight > 0 then 53 + descriptionHeight else 48
handle._description = Create.New("TextLabel", {
Size = UDim2.new(1, -32, 0, descriptionHeight),
Position = UDim2.fromOffset(16, 45),
BackgroundTransparency = 1,
Font = w.Fonts.Regular,
TextSize = w.Tokens:Get("FontBody"),
TextWrapped = true,
TextXAlignment = Enum.TextXAlignment.Left,
TextYAlignment = Enum.TextYAlignment.Top,
Text = tostring(options.Description or ""),
Visible = descriptionHeight > 0,
Parent = frame,
})
if typeof(options.DescriptionColor) == "Color3" then
handle._description.TextColor3 = options.DescriptionColor
else
w:_bind(handle._description, { TextColor3 = "TextSecondary" })
end
local footerHeight = 50
local content = Create.New("ScrollingFrame", {
Size = UDim2.new(1, -32, 1, -(contentTop + footerHeight)),
Position = UDim2.fromOffset(16, contentTop),
BackgroundTransparency = 1,
BorderSizePixel = 0,
AutomaticCanvasSize = Enum.AutomaticSize.Y,
CanvasSize = UDim2.new(),
ScrollBarThickness = 2,
Parent = frame,
})
w:_bind(content, { ScrollBarImageColor3 = "BorderStrong" })
handle._content = content
local function reflowDescription(text)
local height = self:_measure(text or "", self:_width() - 32)
handle._description.Text = tostring(text or "")
handle._description.Visible = height > 0
handle._description.Size = UDim2.new(1, -32, 0, height)
local top = if height > 0 then 53 + height else 48
content.Position = UDim2.fromOffset(16, top)
content.Size = UDim2.new(1, -32, 1, -(top + footerHeight))
end
Create.List(w.Tokens:Get("RowGap")).Parent = content
local section = DialogSection.new(w, content, j)
handle.Section = section
local footer = Create.New("Frame", {
Size = UDim2.new(1, -32, 0, 34),
Position = UDim2.new(0, 16, 1, -42),
BackgroundTransparency = 1,
Parent = frame,
})
Create.List(7, Enum.FillDirection.Horizontal, { HorizontalAlignment = Enum.HorizontalAlignment.Right }).Parent =
footer
handle._footer = footer
local function refreshButton(entry)
if not entry or not entry.Button then
return
end
local unavailable = entry.Disabled or entry.Waiting
entry.Button.Active = not unavailable
entry.Button.TextTransparency = if unavailable then 0.48 else 0
entry.Button.BackgroundTransparency = if unavailable then 0.42 else 0
end
function handle:AddFooterButton(id, spec)
if type(id) ~= "string" or id == "" or type(spec) ~= "table" then
error("[BobloUI] Dialog:AddFooterButton expects id and options table.", 2)
end
self:RemoveFooterButton(id)
local variant = spec.Variant or (spec.Primary and "Primary") or (spec.Danger and "Destructive") or "Secondary"
local primary = variant == "Primary" or variant == "Destructive"
local danger = variant == "Destructive" or variant == "Danger"
local entry = {
Id = id,
Spec = spec,
Disabled = spec.Disabled == true,
Waiting = (tonumber(spec.WaitTime) or 0) > 0,
}
entry.Button = self._dialog:_button(footer, spec.Title or spec.Text or id, primary, danger, function()
if entry.Disabled or entry.Waiting or self._closed then
return
end
if spec.Callback then
local ok, result = xpcall(spec.Callback, debug.traceback, self, section)
if not ok then
warn(result)
return
end
if result == false then
return
end
end
if spec.Close ~= false and options.AutoDismiss ~= false then
self:Close(id)
end
end)
entry.Button.LayoutOrder = tonumber(spec.Order) or 0
self._buttons[id] = entry
refreshButton(entry)
local waitTime = math.max(0, tonumber(spec.WaitTime) or 0)
if waitTime > 0 then
entry.Progress = Create.New("Frame", {
Size = UDim2.fromScale(0, 1),
BackgroundTransparency = 0.7,
BorderSizePixel = 0,
Parent = entry.Button,
})
Create.New("UICorner", {
CornerRadius = UDim.new(0, w.Tokens:Get("FieldRadius")),
Parent = entry.Progress,
})
w:_bind(entry.Progress, { BackgroundColor3 = "Accent" })
w.Motion:Tween(entry.Progress, TweenInfo.new(waitTime, Enum.EasingStyle.Linear), {
Size = UDim2.fromScale(1, 1),
})
j:Add(task.delay(waitTime, function()
if not self._closed and self._buttons[id] == entry then
entry.Waiting = false
if entry.Progress then
entry.Progress:Destroy()
entry.Progress = nil
end
refreshButton(entry)
end
end))
end
return self
end
function handle:RemoveFooterButton(id)
local entry = self._buttons[id]
if entry then
self._buttons[id] = nil
entry.Button:Destroy()
end
return self
end
function handle:SetButtonDisabled(id, disabled)
local entry = self._buttons[id]
if not entry then
return false
end
entry.Disabled = disabled == true
refreshButton(entry)
return self
end
function handle:SetButtonOrder(id, order)
local entry = self._buttons[id]
if not entry then
return false
end
entry.Button.LayoutOrder = tonumber(order) or 0
return self
end
function handle:SetTitle(text)
self._title.Text = tostring(text or "")
return self
end
function handle:SetDescription(text)
reflowDescription(text)
return self
end
function handle:Close(result)
self._result = result
if self._layer:IsOpen() then
self._layer:Dismiss()
end
return self
end
function handle:Dismiss()
return self:Close(nil)
end
function handle:IsOpen()
return not self._closed and self._layer:IsOpen()
end
function handle:Destroy()
return self:Close(nil)
end
function handle:Await()
if self._closed then
return self.Result
end
return self.Closed:Wait()
end
handle._dialog = self
local footerButtons = options.FooterButtons
if type(footerButtons) == "table" then
for id, spec in footerButtons do
handle:AddFooterButton(tostring(id), spec)
end
else
for index, spec in options.Buttons or { { Text = "Close" } } do
handle:AddFooterButton(spec.Id or `Button{index}`, spec)
end
end
if options.Build then
options.Build(section, handle)
end
table.insert(self._open, handle)
return handle
end
function Dialog:Destroy()
for _, d in table.clone(self._open) do
if d:IsOpen() then
d:Close()
end
end
self._open = {}
end
return Dialog
end

__modules["services/DialogSection"] = function()
local Button = __require("controls/Button")
local Toggle = __require("controls/Toggle")
local Slider = __require("controls/Slider")
local Dropdown = __require("controls/Dropdown")
local TextField = __require("controls/TextField")
local Keybind = __require("controls/Keybind")
local ColorPicker = __require("controls/ColorPicker")
local Paragraph = __require("controls/Paragraph")
local Divider = __require("controls/Divider")
local Status = __require("controls/Status")
local Progress = __require("controls/Progress")
local Code = __require("controls/Code")
local Image = __require("controls/Image")
local Passthrough = __require("controls/Passthrough")
local Viewport = __require("controls/Viewport")
local Video = __require("controls/Video")
local DialogSection = {}
DialogSection.__index = DialogSection
function DialogSection.new(window, parent, janitor)
local fakeTab = { Id = "__dialog", Title = "Dialog", _page = parent, Select = function() end }
return setmetatable({
_window = window,
_content = parent,
_mounted = true,
_janitor = janitor,
_tab = fakeTab,
_controls = {},
Title = "Dialog",
}, DialogSection)
end
function DialogSection:_registerControl(c)
table.insert(self._controls, c)
end
function DialogSection:_removeControl(c)
local p = table.find(self._controls, c)
if p then
table.remove(self._controls, p)
end
self:_refreshSeparators()
end
function DialogSection:_controlParent()
return self._content
end
function DialogSection:_refreshSeparators()
local visible = {}
for _, control in self._controls do
if control._root and control._root.Visible then
table.insert(visible, control)
end
end
for i, control in visible do
if control._separator then
control._separator.Visible = i < #visible
end
end
end
function DialogSection:AddButton(o)
return Button.new(self, o)
end
function DialogSection:AddToggle(o)
return Toggle.new(self, o)
end
function DialogSection:AddSlider(o)
return Slider.new(self, o)
end
function DialogSection:AddDropdown(o)
return Dropdown.new(self, o)
end
function DialogSection:AddInput(o)
return TextField.new(self, o)
end
function DialogSection:AddKeybind(o)
return Keybind.new(self, o)
end
function DialogSection:AddColorPicker(o)
return ColorPicker.new(self, o)
end
function DialogSection:AddParagraph(o)
return Paragraph.new(self, o)
end
function DialogSection:AddDivider(o)
return Divider.new(self, o or {})
end
function DialogSection:AddStatus(o)
return Status.new(self, o)
end
function DialogSection:AddProgress(o)
return Progress.new(self, o)
end
function DialogSection:AddCode(o)
return Code.new(self, o)
end
function DialogSection:AddImage(o)
return Image.new(self, o)
end
function DialogSection:AddPassthrough(o)
return Passthrough.new(self, o)
end
function DialogSection:AddViewport(o)
return Viewport.new(self, o)
end
function DialogSection:AddVideo(o)
return Video.new(self, o)
end
function DialogSection:SetCollapsed()
return self
end
return DialogSection
end

__modules["services/Favorites"] = function()
local Signal = __require("runtime/Signal")
local Favorites = {}
Favorites.__index = Favorites
function Favorites.new(registry)
return setmetatable({ Changed = Signal.new("Favorites.Changed"), _registry = registry, _set = {} }, Favorites)
end
function Favorites:Add(id)
if type(id) == "string" and not self._set[id] then
self._set[id] = true
self.Changed:Fire(id, true)
end
return self
end
function Favorites:Remove(id)
if self._set[id] then
self._set[id] = nil
self.Changed:Fire(id, false)
end
return self
end
function Favorites:Toggle(id)
if self._set[id] then
return self:Remove(id)
else
return self:Add(id)
end
end
function Favorites:Has(id)
return self._set[id] == true
end
function Favorites:List()
local o = {}
for id in self._set do
table.insert(o, id)
end
table.sort(o)
return o
end
function Favorites:Set(ids)
self._set = {}
for _, id in ids or {} do
if type(id) == "string" then
self._set[id] = true
end
end
self.Changed:Fire(nil, nil)
end
function Favorites:Destroy()
self.Changed:Destroy()
self._set = {}
end
return Favorites
end

__modules["services/HUD"] = function()
local Create = __require("runtime/Create")
local Janitor = __require("runtime/Janitor")
local HUD = {}
HUD.__index = HUD
local function keyText(value)
if type(value) ~= "table" then
return tostring(value or "None")
end
local parts = {}
for _, modifier in value.Modifiers or {} do
table.insert(parts, tostring(modifier))
end
table.insert(parts, tostring(value.Key or "None"))
return table.concat(parts, " + ")
end
function HUD.new(window)
local self = setmetatable({
_window = window,
_janitor = Janitor.new("HUD"),
_watermark = nil,
_keybind = nil,
_watermarkSpec = nil,
_keybindEnabled = false,
_alive = true,
}, HUD)
self._janitor:Add(task.spawn(function()
while self._alive do
self:_refresh()
task.wait(0.25)
end
end))
return self
end
function HUD:_ensureWatermark()
if self._watermark then
return
end
local w = self._window
self._watermark = Create.New("TextLabel", {
AutomaticSize = Enum.AutomaticSize.XY,
Position = UDim2.fromOffset(12, w.Device.Insets.Top + 12),
BackgroundTransparency = 0,
BorderSizePixel = 0,
Font = w.Fonts.Medium,
TextSize = w.Tokens:Get("FontSmall"),
Text = "",
Parent = w.Layers.Toast,
})
Create.New("UICorner", { CornerRadius = UDim.new(0, 7), Parent = self._watermark })
Create.New("UIPadding", {
PaddingTop = UDim.new(0, 6),
PaddingBottom = UDim.new(0, 6),
PaddingLeft = UDim.new(0, 9),
PaddingRight = UDim.new(0, 9),
Parent = self._watermark,
})
local s = Create.New("UIStroke", { Thickness = 1, Transparency = 0.5, Parent = self._watermark })
w:_bind(self._watermark, { BackgroundColor3 = "SurfaceRaised", TextColor3 = "TextSecondary" })
w:_bind(s, { Color = "Border" })
end
function HUD:SetWatermark(spec)
if spec == false or spec == nil then
if self._watermark then
self._watermark:Destroy()
self._watermark = nil
end
self._watermarkSpec = nil
return self
end
self._watermarkSpec = spec
self:_ensureWatermark()
self:_refresh()
return self
end
function HUD:_ensureKeybind()
if self._keybind then
return
end
local w = self._window
self._keybind = Create.New("Frame", {
Size = UDim2.fromOffset(230, 0),
AutomaticSize = Enum.AutomaticSize.Y,
Position = UDim2.new(0, 12, 1, -12),
AnchorPoint = Vector2.new(0, 1),
BackgroundTransparency = 0,
BorderSizePixel = 0,
Parent = w.Layers.Toast,
})
Create.New("UICorner", { CornerRadius = UDim.new(0, 8), Parent = self._keybind })
Create.New("UIPadding", {
PaddingTop = UDim.new(0, 8),
PaddingBottom = UDim.new(0, 8),
PaddingLeft = UDim.new(0, 10),
PaddingRight = UDim.new(0, 10),
Parent = self._keybind,
})
self._keyLayout = Create.List(4)
self._keyLayout.Parent = self._keybind
local s = Create.New("UIStroke", { Thickness = 1, Transparency = 0.5, Parent = self._keybind })
w:_bind(self._keybind, { BackgroundColor3 = "SurfaceRaised" })
w:_bind(s, { Color = "Border" })
end
function HUD:SetKeybindHUD(enabled)
self._keybindEnabled = enabled == true
if self._keybindEnabled then
self:_ensureKeybind()
elseif self._keybind then
self._keybind:Destroy()
self._keybind = nil
end
return self
end
function HUD:_refresh()
local w = self._window
if self._watermark and self._watermarkSpec then
local text = if type(self._watermarkSpec) == "function"
then select(2, pcall(self._watermarkSpec))
else self._watermarkSpec
self._watermark.Text = tostring(text or "")
end
if self._keybindEnabled then
self:_ensureKeybind()
for _, child in self._keybind:GetChildren() do
if child:IsA("GuiObject") then
child:Destroy()
end
end
for _, entry in w.Registry:Entries() do
local h = entry.Handle
if entry.Type == "Keybind" and h and not h._destroyed then
local v = h:GetValue()
local mobileAction = w.Device.Class == "Phone" and h.Mobile ~= false
local row = Create.New(if mobileAction then "TextButton" else "TextLabel", {
Size = UDim2.new(1, 0, 0, 20),
BackgroundTransparency = if mobileAction then 0.82 else 1,
BorderSizePixel = 0,
AutoButtonColor = if mobileAction then false else nil,
Font = w.Fonts.Regular,
TextSize = w.Tokens:Get("FontSmall"),
TextXAlignment = Enum.TextXAlignment.Left,
Text = `{h.MobileText or h.Title or entry.Id}   [{keyText(v)}]`,
Parent = self._keybind,
})
w:_bind(row, {
TextColor3 = h:IsActive() and "Accent" or "TextSecondary",
BackgroundColor3 = "ControlHover",
})
if mobileAction then
Create.New("UICorner", { CornerRadius = UDim.new(0, 6), Parent = row })
Create.New("UIPadding", {
PaddingLeft = UDim.new(0, 6),
PaddingRight = UDim.new(0, 6),
Parent = row,
})
row.MouseButton1Click:Connect(function()
h:Trigger()
end)
end
end
end
end
end
function HUD:Destroy()
self._alive = false
self._janitor:Destroy()
if self._watermark then
self._watermark:Destroy()
end
if self._keybind then
self._keybind:Destroy()
end
end
return HUD
end

__modules["services/Interactions"] = function()
local Create = __require("runtime/Create")
local Janitor = __require("runtime/Janitor")
local Popover = __require("primitives/Popover")
local Sheet = __require("primitives/Sheet")
local Icon = __require("primitives/Icon")
local Env = __require("runtime/Env")
local Interactions = {}
Interactions.__index = Interactions
local function longestLine(text)
local longest = 0
for _, line in string.split(tostring(text), "\n") do
longest = math.max(longest, #line)
end
return longest
end
function Interactions.new(window)
return setmetatable({ _window = window, _tooltip = nil, _menu = nil, _touchInfo = nil }, Interactions)
end
function Interactions:_hideTooltip()
if self._tooltip then
self._tooltip:Destroy()
self._tooltip = nil
end
end
function Interactions:_showTooltip(root, text)
self:_hideTooltip()
if not root or not root.Parent then
return
end
local w = self._window
local raw = tostring(text)
local width = math.clamp(longestLine(raw) * 6 + 16, 88, 260)
local label = Create.New("TextLabel", {
AutomaticSize = Enum.AutomaticSize.Y,
Size = UDim2.fromOffset(width, 0),
BackgroundTransparency = 0,
BorderSizePixel = 0,
Text = w.Locale:Resolve(raw),
TextWrapped = true,
Font = w.Fonts.Regular,
TextSize = w.Tokens:Get("FontSmall"),
TextXAlignment = Enum.TextXAlignment.Left,
TextYAlignment = Enum.TextYAlignment.Top,
Parent = w.Layers.Overlay,
ZIndex = 999,
})
Create.New("UIPadding", {
PaddingTop = UDim.new(0, 5),
PaddingBottom = UDim.new(0, 5),
PaddingLeft = UDim.new(0, 7),
PaddingRight = UDim.new(0, 7),
Parent = label,
})
Create.New("UICorner", { CornerRadius = UDim.new(0, 6), Parent = label })
local stroke = Create.New("UIStroke", { Thickness = 1, Transparency = 0.46, Parent = label })
w:_bind(stroke, { Color = "Border" })
w:_bind(label, { BackgroundColor3 = "SurfaceRaised", TextColor3 = "TextSecondary" })
task.defer(function()
if not label.Parent then
return
end
local p = root.AbsolutePosition
local a = root.AbsoluteSize
local safePos, safeSize = w.Device:SafeArea()
local x =
math.clamp(p.X, safePos.X + 8, math.max(safePos.X + 8, safePos.X + safeSize.X - label.AbsoluteSize.X - 8))
local below = p.Y + a.Y + 5
local y = below
if below + label.AbsoluteSize.Y > safePos.Y + safeSize.Y - 8 then
y = math.max(safePos.Y + 8, p.Y - label.AbsoluteSize.Y - 5)
end
label.Position = UDim2.fromOffset(x, y)
end)
self._tooltip = label
end
function Interactions:_showTouchInfo(text)
if self._touchInfo then
self._touchInfo:Dismiss()
self._touchInfo = nil
end
local w = self._window
local height = math.min(220, 106 + math.ceil(#tostring(text) / 48) * 18)
local h = Sheet.open(w, height, {
OnDismiss = function()
self._touchInfo = nil
end,
})
self._touchInfo = h
local label = Create.New("TextLabel", {
Size = UDim2.new(1, -32, 1, -40),
Position = UDim2.fromOffset(16, 24),
BackgroundTransparency = 1,
Text = tostring(text),
TextWrapped = true,
Font = w.Fonts.Regular,
TextSize = w.Tokens:Get("FontBody"),
TextXAlignment = Enum.TextXAlignment.Left,
TextYAlignment = Enum.TextYAlignment.Top,
Parent = h.Frame,
})
w:_bind(label, { TextColor3 = "TextSecondary" })
end
function Interactions:OpenMenu(anchor, items)
if self._menu then
self._menu:Dismiss()
self._menu = nil
end
if #items == 0 then
return
end
local w = self._window
local maxLen = 0
for _, item in items do
maxLen = math.max(maxLen, #tostring(item.Text or item.Title or "Action"))
end
local width = math.clamp(maxLen * 7 + 52, 176, 250)
local rowH = 31
local height = 12 + #items * rowH + math.max(0, #items - 1) * 2
local h = if w.Device.Layout == "Drawer"
then Sheet.open(w, math.min(360, 24 + #items * 38), {
OnDismiss = function()
self._menu = nil
end,
})
else Popover.open(w, anchor, Vector2.new(width, height), {
OnDismiss = function()
self._menu = nil
end,
Corner = 8,
})
self._menu = h
local top = if w.Device.Layout == "Drawer" then 20 else 6
local list = Create.New("Frame", {
Size = UDim2.new(1, -12, 1, -top - 6),
Position = UDim2.fromOffset(6, top),
BackgroundTransparency = 1,
Parent = h.Frame,
})
Create.List(2).Parent = list
for _, item in items do
local b = Create.New("TextButton", {
Size = UDim2.new(1, 0, 0, rowH),
BackgroundTransparency = 1,
BorderSizePixel = 0,
AutoButtonColor = false,
Text = "",
Parent = list,
})
Create.New("UICorner", { CornerRadius = UDim.new(0, 7), Parent = b })
w:_bind(b, { BackgroundColor3 = "ControlHover" })
local offset = 10
if item.Icon then
local icon = Icon.new(
w,
item.Icon,
{ Size = UDim2.fromOffset(14, 14), Position = UDim2.fromOffset(9, 8), Parent = b }
)
Icon.setColor(icon, w.Theme:Get(item.Danger and "Error" or "TextTertiary"))
offset = 30
end
local label = Create.New("TextLabel", {
Size = UDim2.new(1, -offset - 8, 1, 0),
Position = UDim2.fromOffset(offset, 0),
BackgroundTransparency = 1,
Font = w.Fonts.Regular,
TextSize = w.Tokens:Get("FontBody"),
TextXAlignment = Enum.TextXAlignment.Left,
Text = w.Locale:Resolve(item.Text or item.Title or "Action"),
Parent = b,
})
w:_bind(label, { TextColor3 = item.Danger and "Error" or "TextSecondary" })
b.MouseEnter:Connect(function()
b.BackgroundTransparency = 0
label.TextColor3 = w.Theme:Get(item.Danger and "Error" or "Text")
end)
b.MouseLeave:Connect(function()
b.BackgroundTransparency = 1
label.TextColor3 = w.Theme:Get(item.Danger and "Error" or "TextSecondary")
end)
b.MouseButton1Click:Connect(function()
h:Dismiss()
local ok, err = xpcall(item.Callback or function() end, debug.traceback)
if not ok then
warn(`[BobloUI] context action failed:\n{err}`)
end
end)
end
end
function Interactions:Attach(control, root, tooltip, userMenu)
local j = Janitor.new("Control.Interactions")
local hoverToken = 0
local w = self._window
local function tooltipText()
local v = type(tooltip) == "function" and tooltip() or tooltip
if v == nil then
return nil
end
local kind = type(v)
if kind == "function" or kind == "table" or kind == "userdata" or kind == "thread" then
return nil
end
return w.Locale:Resolve(tostring(v))
end
if tooltip and w.Device.Class ~= "Phone" then
j:Add(root.MouseEnter:Connect(function()
hoverToken += 1
local token = hoverToken
j:Add(task.delay(0.4, function()
local tip = tooltipText()
if tip and token == hoverToken and root.Parent then
self:_showTooltip(root, tip)
end
end))
end))
j:Add(root.MouseLeave:Connect(function()
hoverToken += 1
self:_hideTooltip()
end))
elseif tooltip then
local info = Create.New("TextButton", {
Size = UDim2.fromOffset(20, 20),
Position = UDim2.new(0.6, -24, 0, 9),
AnchorPoint = Vector2.new(1, 0),
BackgroundTransparency = 1,
Text = "",
ZIndex = 3,
Parent = root,
})
local icon = Icon.new(w, "info", {
Size = UDim2.fromOffset(14, 14),
Position = UDim2.fromScale(0.5, 0.5),
AnchorPoint = Vector2.new(0.5, 0.5),
Parent = info,
})
Icon.setColor(icon, w.Theme:Get("TextSecondary"))
j:Add(info.MouseButton1Click:Connect(function()
local tip = tooltipText()
if tip then
self:_showTouchInfo(tip)
end
end))
end
local function items()
local out = {}
for _, x in userMenu or {} do
table.insert(out, x)
end
if control.Reset and control._stateful then
table.insert(out, {
Text = "Reset to default",
Icon = "reset",
Callback = function()
control:Reset()
end,
})
end
if control.CopyValue and control._stateful then
table.insert(out, {
Text = "Copy value",
Icon = "copy",
Callback = function()
control:CopyValue()
end,
})
end
if control.PasteValue and control._stateful and Env.Capabilities.ClipboardRead then
table.insert(out, {
Text = "Paste value",
Icon = "copy",
Callback = function()
local ok, err = control:PasteValue()
if not ok and w.Notify then
w.Notify:Push({ Title = "Paste failed", Content = tostring(err), Variant = "Warning" })
end
end,
})
end
if control.Id and w.Favorites then
table.insert(out, {
Text = w.Favorites:Has(control.Id) and "Remove from Favorites" or "Add to Favorites",
Icon = "star",
Callback = function()
w.Favorites:Toggle(control.Id)
end,
})
end
return out
end
j:Add(root.InputBegan:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton2 then
self:OpenMenu(root, items())
elseif input.UserInputType == Enum.UserInputType.Touch then
local active = true
local start = input.Position
local token = task.delay(0.6, function()
if active and root.Parent then
self:OpenMenu(root, items())
end
end)
j:Add(token)
local conn
conn = input.Changed:Connect(function()
if (input.Position - start).Magnitude > 12 then
active = false
end
if
input.UserInputState == Enum.UserInputState.End
or input.UserInputState == Enum.UserInputState.Cancel
then
active = false
if conn then
conn:Disconnect()
end
end
end)
j:Add(conn)
end
end))
return j
end
function Interactions:Destroy()
self:_hideTooltip()
if self._menu then
self._menu:Dismiss()
end
if self._touchInfo then
self._touchInfo:Dismiss()
end
end
return Interactions
end

__modules["services/Loading"] = function()
local Create = __require("runtime/Create")
local Janitor = __require("runtime/Janitor")
local Icon = __require("primitives/Icon")
local DialogSection = __require("services/DialogSection")
local Loading = {}
Loading.__index = Loading
function Loading.new(window)
return setmetatable({ _window = window, _handle = nil }, Loading)
end
function Loading:Show(options)
options = options or {}
if self._handle then
self._handle:Dismiss()
self._handle = nil
end
local w = self._window
local j = Janitor.new("Loading.Handle")
local hasContent = options.Build ~= nil or options.Sidebar == true or options.ShowSidebar ~= nil
local availableWidth = math.max(240, w.Device.Viewport.X - 32)
local panelWidth =
math.max(240, math.min(tonumber(options.WindowWidth) or (if hasContent then 620 else 420), availableWidth))
local sideBySide = hasContent and panelWidth >= 500
local desiredHeight = if not hasContent then 180 elseif sideBySide then 300 else 460
local panelHeight = math.min(
math.max(180, tonumber(options.WindowHeight) or desiredHeight),
math.max(180, w.Device.Viewport.Y - 32)
)
local mainWidth = if sideBySide
then math.clamp(
tonumber(options.ContentWidth)
or (tonumber(options.SidebarWidth) and panelWidth - tonumber(options.SidebarWidth) - 10)
or math.floor(panelWidth * 0.58),
240,
panelWidth - 150
)
else panelWidth
local initialIcon = options.LoadingIcon or options.Icon
local layer = w.Layers:Push({
Scrim = true,
ScrimTransparency = options.ScrimTransparency,
Modal = true,
OnDismiss = function()
self._handle = nil
j:Destroy()
end,
})
local panel = Create.New("Frame", {
Size = UDim2.fromOffset(panelWidth, panelHeight),
Position = UDim2.fromScale(0.5, 0.5),
AnchorPoint = Vector2.new(0.5, 0.5),
BorderSizePixel = 0,
Parent = layer.Container,
})
Create.New("UICorner", { CornerRadius = UDim.new(0, w.Tokens:Get("CornerLg")), Parent = panel })
local stroke = Create.New("UIStroke", { Thickness = 1, Transparency = 0.35, Parent = panel })
w:_bind(panel, { BackgroundColor3 = "SurfaceRaised" })
w:_bind(stroke, { Color = "Border" })
local title = Create.New("TextLabel", {
Size = UDim2.fromOffset(mainWidth - (initialIcon and 64 or 32), 24),
Position = UDim2.fromOffset(initialIcon and 48 or 16, 16),
BackgroundTransparency = 1,
Font = w.Fonts.Bold,
TextSize = w.Tokens:Get("FontHeading"),
TextXAlignment = Enum.TextXAlignment.Left,
Text = options.Title or "Loading",
Parent = panel,
})
w:_bind(title, { TextColor3 = "Text" })
local loadingIcon = nil
if initialIcon then
loadingIcon = Icon.new(w, initialIcon, {
Size = UDim2.fromOffset(20, 20),
Position = UDim2.fromOffset(16, 18),
Parent = panel,
})
Icon.setColor(loadingIcon, w.Theme:Get("Accent"))
end
local status = Create.New("TextLabel", {
Size = UDim2.fromOffset(mainWidth - 32, 20),
Position = UDim2.fromOffset(16, 48),
BackgroundTransparency = 1,
Font = w.Fonts.Regular,
TextSize = w.Tokens:Get("FontBody"),
TextWrapped = true,
TextXAlignment = Enum.TextXAlignment.Left,
TextYAlignment = Enum.TextYAlignment.Top,
Text = options.Message or options.Status or "Preparing…",
Parent = panel,
})
w:_bind(status, { TextColor3 = "TextSecondary" })
local description = Create.New("TextLabel", {
Size = UDim2.fromOffset(mainWidth - 32, 30),
Position = UDim2.fromOffset(16, 70),
BackgroundTransparency = 1,
Font = w.Fonts.Regular,
TextSize = w.Tokens:Get("FontSmall"),
TextWrapped = true,
TextXAlignment = Enum.TextXAlignment.Left,
TextYAlignment = Enum.TextYAlignment.Top,
Text = options.Description or "",
Visible = options.Description ~= nil and options.Description ~= "",
Parent = panel,
})
w:_bind(description, { TextColor3 = "TextTertiary" })
local track = Create.New("Frame", {
Size = UDim2.fromOffset(mainWidth - 32, 6),
Position = UDim2.fromOffset(16, 108),
BorderSizePixel = 0,
Parent = panel,
})
Create.New("UICorner", { CornerRadius = UDim.new(1, 0), Parent = track })
w:_bind(track, { BackgroundColor3 = "ControlInset" })
local fill = Create.New(
"Frame",
{ Size = UDim2.fromScale(math.clamp(options.Progress or 0, 0, 1), 1), BorderSizePixel = 0, Parent = track }
)
Create.New("UICorner", { CornerRadius = UDim.new(1, 0), Parent = fill })
w:_bind(fill, { BackgroundColor3 = "Accent" })
local step = Create.New("TextLabel", {
Size = UDim2.fromOffset(mainWidth - 32, 18),
Position = UDim2.fromOffset(16, 122),
BackgroundTransparency = 1,
Font = w.Fonts.Regular,
TextSize = w.Tokens:Get("FontSmall"),
TextXAlignment = Enum.TextXAlignment.Right,
Text = "",
Parent = panel,
})
w:_bind(step, { TextColor3 = "TextTertiary" })
local actions = Create.New("Frame", {
Size = UDim2.fromOffset(mainWidth - 32, 30),
Position = UDim2.fromOffset(16, 144),
BackgroundTransparency = 1,
Parent = panel,
})
local list = Create.List(6, Enum.FillDirection.Horizontal, { HorizontalAlignment = Enum.HorizontalAlignment.Right })
list.Parent = actions
local h = {
_layer = layer,
_service = self,
Frame = panel,
_title = title,
_status = status,
_description = description,
_fill = fill,
_step = step,
_actions = actions,
_icon = loadingIcon,
_janitor = j,
_steps = options.Steps or {},
_currentStep = tonumber(options.CurrentStep) or 0,
_totalSteps = math.max(1, tonumber(options.TotalSteps) or math.max(1, #(options.Steps or {}))),
_dismissed = false,
_iconSpinToken = 0,
_loadingIconTweenTime = math.max(0, tonumber(options.LoadingIconTweenTime) or 0),
_loadingIconColor = options.LoadingIconColor,
_sideBySide = sideBySide,
_mainWidth = mainWidth,
_panelWidth = panelWidth,
}
local function restartIconSpin(handle)
handle._iconSpinToken += 1
local token = handle._iconSpinToken
if not handle._icon then
return
end
handle._icon.Rotation = 0
local seconds = handle._loadingIconTweenTime
if seconds <= 0 then
return
end
task.spawn(function()
while not handle._dismissed and handle._iconSpinToken == token and handle._icon and handle._icon.Parent do
handle._icon.Rotation = 0
w.Motion:Tween(
handle._icon,
TweenInfo.new(seconds, Enum.EasingStyle.Linear),
{ Rotation = 360 },
"Controls"
)
task.wait(seconds)
end
end)
end
if hasContent then
local divider = Create.New("Frame", {
Size = if sideBySide then UDim2.new(0, 1, 1, -24) else UDim2.new(1, -24, 0, 1),
Position = if sideBySide then UDim2.fromOffset(mainWidth, 12) else UDim2.fromOffset(12, 184),
BorderSizePixel = 0,
Parent = panel,
})
w:_bind(divider, { BackgroundColor3 = "BorderSubtle" })
local sidebar = Create.New("ScrollingFrame", {
Size = if sideBySide
then UDim2.new(1, -(mainWidth + 18), 1, -24)
else UDim2.new(1, -24, 0, math.max(48, panelHeight - 204)),
Position = if sideBySide then UDim2.fromOffset(mainWidth + 10, 12) else UDim2.fromOffset(12, 196),
BackgroundTransparency = 1,
BorderSizePixel = 0,
AutomaticCanvasSize = Enum.AutomaticSize.Y,
CanvasSize = UDim2.new(),
ScrollBarThickness = 2,
Parent = panel,
})
Create.List(w.Tokens:Get("RowGap")).Parent = sidebar
h._divider = divider
h._sidebarHost = sidebar
h.Sidebar = DialogSection.new(w, sidebar, j)
h.Section = h.Sidebar
if options.Build then
options.Build(h.Sidebar, h)
end
end
function h:SetTitle(text)
self._title.Text = tostring(text or "")
return self
end
function h:SetStatus(text)
self._status.Text = tostring(text or "")
return self
end
function h:SetMessage(text)
return self:SetStatus(text)
end
function h:SetDescription(text)
local value = tostring(text or "")
self._description.Text = value
self._description.Visible = value ~= ""
return self
end
function h:SetProgress(value)
self._fill.Size = UDim2.fromScale(math.clamp(tonumber(value) or 0, 0, 1), 1)
return self
end
function h:SetStep(current, total, text)
if text then
self:SetStatus(text)
end
local c = tonumber(current) or 0
local t = math.max(1, tonumber(total) or 1)
self._currentStep = c
self._totalSteps = t
self._step.Text = `{c} / {t}`
if not text and self._steps[c] then
self:SetStatus(self._steps[c])
end
self:SetProgress(c / t)
return self
end
function h:SetSteps(steps)
self._steps = steps or {}
return self
end
function h:SetCurrentStep(current, text)
return self:SetStep(current, self._totalSteps, text)
end
function h:SetTotalSteps(total)
return self:SetStep(self._currentStep, total)
end
function h:SetIcon(icon)
if self._icon then
self._icon:Destroy()
self._icon = nil
end
if icon then
self._icon = Icon.new(w, icon, {
Size = UDim2.fromOffset(20, 20),
Position = UDim2.fromOffset(16, 18),
Parent = self.Frame,
})
Icon.setColor(
self._icon,
if typeof(self._loadingIconColor) == "Color3" then self._loadingIconColor else w.Theme:Get("Accent")
)
end
local width = if self._sideBySide
and self._sidebarHost
and not self._sidebarVisible
then self._panelWidth
else self._mainWidth
self._title.Position = UDim2.fromOffset(self._icon and 48 or 16, 16)
self._title.Size = UDim2.fromOffset(width - (self._icon and 64 or 32), 24)
restartIconSpin(self)
return self
end
function h:SetLoadingIcon(icon)
return self:SetIcon(icon)
end
function h:SetLoadingIconTweenTime(seconds)
self._loadingIconTweenTime = math.max(0, tonumber(seconds) or 0)
restartIconSpin(self)
return self
end
function h:SetLoadingIconColor(color)
self._loadingIconColor = color
if self._icon then
Icon.setColor(self._icon, if typeof(color) == "Color3" then color else w.Theme:Get("Accent"))
end
return self
end
function h:ShowSidebarPage(visible)
if not self._sidebarHost then
return false
end
visible = visible ~= false
self._sidebarVisible = visible
self._sidebarHost.Visible = visible
self._divider.Visible = visible
local width = if self._sideBySide and not visible then self._panelWidth else self._mainWidth
self._title.Size = UDim2.fromOffset(width - (self._icon and 64 or 32), 24)
self._status.Size = UDim2.fromOffset(width - 32, 20)
self._description.Size = UDim2.fromOffset(width - 32, 30)
self._fill.Parent.Size = UDim2.fromOffset(width - 32, 6)
self._step.Size = UDim2.fromOffset(width - 32, 18)
self._actions.Size = UDim2.fromOffset(width - 32, 30)
return self
end
function h:ShowErrorPage(visible)
self._errorVisible = visible ~= false
self._fill.BackgroundColor3 = w.Theme:Get(self._errorVisible and "Error" or "Accent")
self._actions.Visible = self._errorVisible
return self
end
function h:SetErrorMessage(message)
self:SetStatus(message)
self:ShowErrorPage(true)
return self
end
function h:SetErrorButtons(buttons)
for _, child in self._actions:GetChildren() do
if child:IsA("GuiObject") then
child:Destroy()
end
end
for _, spec in buttons or {} do
local b = Create.New("TextButton", {
AutomaticSize = Enum.AutomaticSize.X,
Size = UDim2.new(0, 0, 1, 0),
BackgroundTransparency = 0,
BorderSizePixel = 0,
Text = "  " .. tostring(spec.Text or "Retry") .. "  ",
Font = w.Fonts.Medium,
TextSize = w.Tokens:Get("FontSmall"),
Parent = self._actions,
})
Create.New("UICorner", { CornerRadius = UDim.new(0, 7), Parent = b })
w:_bind(b, {
BackgroundColor3 = spec.Danger and "Error" or "ControlInset",
TextColor3 = spec.Danger and "TextOnError" or "Text",
})
b.MouseButton1Click:Connect(function()
if spec.Callback then
pcall(spec.Callback)
end
end)
end
return self
end
function h:SetError(message, buttons)
self:SetErrorMessage(message)
self:SetErrorButtons(buttons)
return self
end
function h:Dismiss()
if self._dismissed then
return
end
self._dismissed = true
self._iconSpinToken += 1
self._layer:Dismiss()
end
function h:Destroy()
self:Dismiss()
end
function h:Continue()
self:Dismiss()
end
if hasContent then
h:ShowSidebarPage(options.ShowSidebar ~= false)
end
if options.LoadingIconColor ~= nil then
h:SetLoadingIconColor(options.LoadingIconColor)
end
if options.LoadingIconTweenTime ~= nil then
h:SetLoadingIconTweenTime(options.LoadingIconTweenTime)
end
if options.CurrentStep ~= nil or options.TotalSteps ~= nil then
h:SetStep(h._currentStep, h._totalSteps)
end
self._handle = h
return h
end
function Loading:Hide()
if self._handle then
self._handle:Dismiss()
self._handle = nil
end
end
function Loading:Destroy()
self:Hide()
end
return Loading
end

__modules["services/Navigation"] = function()
local UserInputService = game:GetService("UserInputService")
local Create = __require("runtime/Create")
local Navigation = {}
Navigation.__index = Navigation
local NAV_TYPES =
{ Button = true, Toggle = true, Slider = true, Dropdown = true, Input = true, Keybind = true, ColorPicker = true }
local function isNavKey(k)
return k == Enum.KeyCode.Tab
or k == Enum.KeyCode.DPadDown
or k == Enum.KeyCode.DPadUp
or k == Enum.KeyCode.DPadLeft
or k == Enum.KeyCode.DPadRight
end
function Navigation.new(window, enabled)
local self =
setmetatable({ _window = window, _enabled = enabled ~= false, _focused = nil, _stroke = nil }, Navigation)
self._conn = window.Input.Began:Connect(function(input, processed)
self:_input(input, processed)
end)
self._removed = window.Registry.Removed:Connect(function(entry)
if self._focused and entry.Handle == self._focused then
self:Clear()
end
end)
return self
end
function Navigation:SetEnabled(enabled)
self._enabled = enabled ~= false
if not self._enabled then
self:Clear()
end
return self
end
function Navigation:IsEnabled()
return self._enabled
end
function Navigation:_entries()
local w = self._window
local active = w._active
if not active then
return {}
end
local list = {}
for _, entry in w.Registry:Entries() do
local h = entry.Handle
if
NAV_TYPES[entry.Type]
and h
and not h._destroyed
and entry.Tab == active.Id
and (not h.IsVisible or h:IsVisible())
and (not h.IsDisabled or not h:IsDisabled())
then
table.insert(list, entry)
end
end
table.sort(list, function(a, b)
local ha, hb = a.Handle, b.Handle
local sa, sb = ha._section, hb._section
local ao = (sa and sa._order or 0) * 10000 + (ha._order or 0)
local bo = (sb and sb._order or 0) * 10000 + (hb._order or 0)
if ao == bo then
return tostring(a.Title) < tostring(b.Title)
end
return ao < bo
end)
return list
end
function Navigation:_drawFocus(handle)
if self._stroke then
self._stroke:Destroy()
self._stroke = nil
end
local root = handle and handle:GetInstance()
if not root then
return
end
self._stroke = Create.New("UIStroke", {
Name = "BobloUIKeyboardFocus",
Thickness = 1.5,
Transparency = 0.04,
ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
Parent = root,
})
self._window:_bind(self._stroke, { Color = "Accent" })
end
function Navigation:Focus(handle)
if not handle or handle._destroyed then
return self
end
self._focused = handle
if handle.Reveal then
handle:Reveal()
end
task.defer(function()
if self._focused == handle and not handle._destroyed then
self:_drawFocus(handle)
end
end)
return self
end
function Navigation:GetFocused()
return self._focused
end
function Navigation:Clear()
self._focused = nil
if self._stroke then
self._stroke:Destroy()
self._stroke = nil
end
return self
end
function Navigation:Move(delta)
local entries = self:_entries()
if #entries == 0 then
return self
end
local index = 0
for i, e in entries do
if e.Handle == self._focused then
index = i
break
end
end
if index == 0 then
index = delta < 0 and (#entries + 1) or 0
end
index = ((index - 1 + delta) % #entries) + 1
return self:Focus(entries[index].Handle)
end
function Navigation:Activate()
local h = self._focused
if not h or h._destroyed or (h.IsDisabled and h:IsDisabled()) then
return self
end
if h.Type == "Button" and h.Click then
h:Click()
elseif h.Type == "Toggle" and h.Flip then
h:Flip()
elseif h.Type == "Dropdown" and h.Open then
h:Open()
elseif h.Type == "Input" and h.Focus then
h:Focus()
elseif h.Type == "Keybind" and h.Capture then
h:Capture()
elseif h.Type == "ColorPicker" and h.Open then
h:Open()
end
return self
end
function Navigation:_stepSlider(dir)
local h = self._focused
if not h or h.Type ~= "Slider" then
return false
end
local step = tonumber(h.Step) or 1
h:SetValue((tonumber(h:GetValue()) or 0) + step * dir)
return true
end
function Navigation:_input(input, processed)
if not self._enabled or not self._window:IsVisible() then
return
end
if UserInputService:GetFocusedTextBox() then
return
end
local k = input.KeyCode
if k == Enum.KeyCode.Tab then
local backwards = self._window.Input:IsKeyDown(Enum.KeyCode.LeftShift)
or self._window.Input:IsKeyDown(Enum.KeyCode.RightShift)
self:Move(backwards and -1 or 1)
return
end
if processed then
return
end
if k == Enum.KeyCode.DPadDown then
self:Move(1)
return
end
if k == Enum.KeyCode.DPadUp then
self:Move(-1)
return
end
if k == Enum.KeyCode.Left or k == Enum.KeyCode.DPadLeft then
if self:_stepSlider(-1) then
return
end
end
if k == Enum.KeyCode.Right or k == Enum.KeyCode.DPadRight then
if self:_stepSlider(1) then
return
end
end
if
k == Enum.KeyCode.Return
or k == Enum.KeyCode.KeypadEnter
or k == Enum.KeyCode.Space
or k == Enum.KeyCode.ButtonA
then
self:Activate()
return
end
if k == Enum.KeyCode.Escape or k == Enum.KeyCode.ButtonB then
self:Clear()
end
end
function Navigation:Destroy()
self:Clear()
if self._conn then
self._conn:Disconnect()
end
if self._removed then
self._removed:Disconnect()
end
end
return Navigation
end

__modules["services/Notify"] = function()
local Create = __require("runtime/Create")
local Janitor = __require("runtime/Janitor")
local Icon = __require("primitives/Icon")
local Notify = {}
Notify.__index = Notify
local TOK = { Default = "Accent", Success = "Success", Warning = "Warning", Error = "Error", Loading = "Info" }
local GLYPH = {
Default = "bell",
Success = "circle-check",
Warning = "triangle-alert",
Error = "circle-x",
Loading = "loader-circle",
}
local function normalizeOptions(options)
local out = table.clone(options or {})
if out.Content == nil and out.Description ~= nil then
out.Content = out.Description
end
if out.Image == nil then
out.Image = out.BigImage or out.BigIcon
end
if out.Color == nil then
out.Color = out.AccentColor or out.IconColor
end
if out.ContentColor == nil and out.DescriptionColor ~= nil then
out.ContentColor = out.DescriptionColor
end
if out.Sound == nil and out.SoundId ~= nil then
out.Sound = out.SoundId
end
if out.SoundOptions == nil and out.Volume ~= nil then
out.SoundOptions = { Volume = out.Volume }
end
if out.Duration == nil then
if out.Persist == true then
out.Duration = 0
elseif out.Time ~= nil then
out.Duration = out.Time
end
end
if out.Steps ~= nil and out.Progress == nil then
local total = math.max(1, tonumber(out.Steps) or 1)
out.Progress = math.max(0, tonumber(out.CurrentStep) or 0) / total
end
return out
end
function Notify.new(window, position)
local self = setmetatable({
_window = window,
_items = {},
_queue = {},
_host = nil,
_janitor = Janitor.new("Notify"),
_position = position or "BottomRight",
}, Notify)
self:_ensureHost()
self._janitor:Add(window.Device.Changed:Connect(function()
self:_applyLayout()
end))
self._janitor:Add(window.Theme.Changed:Connect(function()
self:_refreshTheme()
end))
return self
end
function Notify:_ensureHost()
if self._host and self._host.Parent then
return
end
local w = self._window
self._host = Create.New("Frame", { Name = "Notifications", BackgroundTransparency = 1, Parent = w.Layers.Toast })
self._layout = Create.List(8)
self._layout.Parent = self._host
self:_applyLayout()
end
function Notify:_applyLayout()
if not self._host then
return
end
local w = self._window
local mobile = w.Device.Layout == "Drawer"
if mobile then
self._host.Size = UDim2.new(1, -16, 0, math.min(500, w.Device.Viewport.Y - 24))
if string.sub(self._position, 1, 6) == "Bottom" then
self._host.Position = UDim2.new(0, 8, 1, -(w.Device.Insets.Bottom + 8))
self._host.AnchorPoint = Vector2.new(0, 1)
self._layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
else
self._host.Position = UDim2.fromOffset(8, w.Device.Insets.Top + 8)
self._host.AnchorPoint = Vector2.new(0, 0)
self._layout.VerticalAlignment = Enum.VerticalAlignment.Top
end
else
self._host.Size = UDim2.fromOffset(320, 560)
local pos = self._position
if pos == "TopLeft" then
self._host.Position = UDim2.fromOffset(14, 14)
self._host.AnchorPoint = Vector2.new(0, 0)
self._layout.VerticalAlignment = Enum.VerticalAlignment.Top
elseif pos == "TopRight" then
self._host.Position = UDim2.new(1, -14, 0, 14)
self._host.AnchorPoint = Vector2.new(1, 0)
self._layout.VerticalAlignment = Enum.VerticalAlignment.Top
elseif pos == "BottomLeft" then
self._host.Position = UDim2.new(0, 14, 1, -14)
self._host.AnchorPoint = Vector2.new(0, 1)
self._layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
else
self._host.Position = UDim2.new(1, -14, 1, -14)
self._host.AnchorPoint = Vector2.new(1, 1)
self._layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
end
end
end
function Notify:SetPosition(position)
self._position = position or "BottomRight"
self:_applyLayout()
return self
end
function Notify:GetPosition()
return self._position
end
function Notify:_refreshTheme()
for _, item in self._items do
local color = typeof(item.Color) == "Color3" and item.Color
or self._window.Theme:Get(TOK[item.Variant] or "Accent")
if item._rail then
item._rail.BackgroundColor3 = color
end
if item._variantIcon then
Icon.setColor(item._variantIcon, color)
end
end
end
function Notify:_mount(item)
local w = self._window
local j = Janitor.new("Notification")
item._janitor = j
local hasActions = item.Actions and #item.Actions > 0
local hasProgress = item.Progress ~= nil
local imageBlock = item.Image and 88 or 0
local height = 66 + imageBlock + (hasActions and 34 or 0) + (hasProgress and 9 or 0)
local frame = Create.New(
"Frame",
{ Size = UDim2.new(1, 0, 0, height), BackgroundTransparency = 0, BorderSizePixel = 0, Parent = self._host }
)
Create.New("UICorner", { CornerRadius = UDim.new(0, w.Tokens:Get("CornerMd")), Parent = frame })
local stroke = Create.New("UIStroke", { Thickness = 1, Transparency = 0.44, Parent = frame })
w:_bind(frame, { BackgroundColor3 = "SurfaceRaised" })
w:_bind(stroke, { Color = "Border" })
j:Add(frame)
local rail = Create.New("Frame", {
Size = UDim2.fromOffset(3, 32),
Position = UDim2.fromOffset(0, 17),
BorderSizePixel = 0,
Parent = frame,
})
Create.New("UICorner", { CornerRadius = UDim.new(1, 0), Parent = rail })
local iconHost = Create.New("Frame", {
Size = UDim2.fromOffset(28, 28),
Position = UDim2.fromOffset(11, 10),
BorderSizePixel = 0,
Parent = frame,
})
Create.New("UICorner", { CornerRadius = UDim.new(0, 8), Parent = iconHost })
local iconStroke = Create.New("UIStroke", { Thickness = 1, Transparency = 0.58, Parent = iconHost })
w:_bind(iconHost, { BackgroundColor3 = "SurfaceInset" })
w:_bind(iconStroke, { Color = "BorderSubtle" })
local function renderVariantIcon()
if item._variantIcon then
item._variantIcon:Destroy()
end
item._variantIcon = Icon.new(w, item.Icon or GLYPH[item.Variant] or GLYPH.Default, {
Size = UDim2.fromOffset(15, 15),
Position = UDim2.fromScale(0.5, 0.5),
AnchorPoint = Vector2.new(0.5, 0.5),
Parent = iconHost,
})
local color = typeof(item.Color) == "Color3" and item.Color or w.Theme:Get(TOK[item.Variant] or "Accent")
rail.BackgroundColor3 = color
Icon.setColor(item._variantIcon, color)
end
renderVariantIcon()
item._title = Create.New("TextLabel", {
Size = UDim2.new(1, -76, 0, 20),
Position = UDim2.fromOffset(48, 8),
BackgroundTransparency = 1,
Font = w.Fonts.Medium,
TextSize = w.Tokens:Get("FontBody"),
TextXAlignment = Enum.TextXAlignment.Left,
Text = item.Title or "",
Parent = frame,
})
w:_bind(item._title, { TextColor3 = "Text" })
if typeof(item.TitleColor) == "Color3" then
item._title.TextColor3 = item.TitleColor
end
item._content = Create.New("TextLabel", {
Size = UDim2.new(1, -76, 0, 28),
Position = UDim2.fromOffset(48, 29),
BackgroundTransparency = 1,
Font = w.Fonts.Regular,
TextSize = w.Tokens:Get("FontSmall"),
TextWrapped = true,
TextXAlignment = Enum.TextXAlignment.Left,
TextYAlignment = Enum.TextYAlignment.Top,
Text = item.Content or "",
Parent = frame,
})
w:_bind(item._content, { TextColor3 = "TextSecondary" })
if typeof(item.ContentColor) == "Color3" then
item._content.TextColor3 = item.ContentColor
end
if item.Image then
item._image = Create.New("ImageLabel", {
Size = UDim2.new(1, -26, 0, 78),
Position = UDim2.fromOffset(13, 60),
BackgroundTransparency = 0,
BorderSizePixel = 0,
Image = tostring(item.Image),
ScaleType = item.ImageScaleType or Enum.ScaleType.Crop,
Parent = frame,
})
Create.New("UICorner", { CornerRadius = UDim.new(0, 8), Parent = item._image })
w:_bind(item._image, { BackgroundColor3 = "ControlInset" })
end
if hasProgress then
local track = Create.New("Frame", {
Size = UDim2.new(1, -26, 0, 3),
Position = UDim2.new(0, 13, 1, -7),
BorderSizePixel = 0,
BackgroundTransparency = 0,
Parent = frame,
})
Create.New("UICorner", { CornerRadius = UDim.new(1, 0), Parent = track })
w:_bind(track, { BackgroundColor3 = "ControlInset" })
item._progressFill = Create.New("Frame", {
Size = UDim2.new(math.clamp(tonumber(item.Progress) or 0, 0, 1), 0, 1, 0),
BorderSizePixel = 0,
Parent = track,
})
Create.New("UICorner", { CornerRadius = UDim.new(1, 0), Parent = item._progressFill })
w:_bind(item._progressFill, { BackgroundColor3 = "Accent" })
end
local close = Create.New("TextButton", {
Size = UDim2.fromOffset(26, 26),
Position = UDim2.new(1, -5, 0, 5),
AnchorPoint = Vector2.new(1, 0),
BackgroundTransparency = 1,
BorderSizePixel = 0,
AutoButtonColor = false,
Text = "",
Parent = frame,
})
local closeIcon = Icon.new(w, "close", {
Size = UDim2.fromOffset(12, 12),
Position = UDim2.fromScale(0.5, 0.5),
AnchorPoint = Vector2.new(0.5, 0.5),
Parent = close,
})
Icon.setColor(closeIcon, w.Theme:Get("TextTertiary"))
j:Add(close.MouseEnter:Connect(function()
Icon.setColor(closeIcon, w.Theme:Get("Text"))
end))
j:Add(close.MouseLeave:Connect(function()
Icon.setColor(closeIcon, w.Theme:Get("TextTertiary"))
end))
j:Add(close.MouseButton1Click:Connect(function()
item:Dismiss()
end))
item._rail = rail
item._renderIcon = renderVariantIcon
if hasActions then
local row = Create.New("Frame", {
Size = UDim2.new(1, -26, 0, 28),
Position = UDim2.fromOffset(13, 66 + imageBlock),
BackgroundTransparency = 1,
Parent = frame,
})
Create.List(6, Enum.FillDirection.Horizontal, { HorizontalAlignment = Enum.HorizontalAlignment.Right }).Parent =
row
for _, action in item.Actions do
local b = Create.New("TextButton", {
AutomaticSize = Enum.AutomaticSize.X,
Size = UDim2.new(0, 0, 1, 0),
BackgroundTransparency = 0,
BorderSizePixel = 0,
AutoButtonColor = false,
Text = "  " .. (action.Text or "Action") .. "  ",
Font = w.Fonts.Medium,
TextSize = w.Tokens:Get("FontSmall"),
Parent = row,
})
Create.New("UICorner", { CornerRadius = UDim.new(0, 7), Parent = b })
w:_bind(b, { BackgroundColor3 = "ControlInset", TextColor3 = "TextSecondary" })
j:Add(b.MouseEnter:Connect(function()
b.BackgroundColor3 = w.Theme:Get("ControlHover")
b.TextColor3 = w.Theme:Get("Text")
end))
j:Add(b.MouseLeave:Connect(function()
b.BackgroundColor3 = w.Theme:Get("ControlInset")
b.TextColor3 = w.Theme:Get("TextSecondary")
end))
j:Add(b.MouseButton1Click:Connect(function()
local ok, err = xpcall(action.Callback or function() end, debug.traceback)
if not ok then
warn(err)
end
end))
end
end
if item.Sound and w.Sound then
w.Sound:Play(item.Sound, item.SoundOptions)
end
if item.Duration and item.Duration > 0 then
j:Add(task.delay(item.Duration, function()
item:Dismiss()
end))
end
end
function Notify:Push(options)
options = normalizeOptions(options)
local item = {
Title = options.Title or "Notification",
Content = options.Content or "",
Variant = options.Variant or "Default",
Icon = options.Icon,
Image = options.Image,
ImageScaleType = options.ImageScaleType,
Color = options.Color,
TitleColor = options.TitleColor,
ContentColor = options.ContentColor,
Sound = options.Sound,
SoundOptions = options.SoundOptions,
Actions = options.Actions,
Steps = math.max(0, tonumber(options.Steps) or 0),
CurrentStep = math.max(0, tonumber(options.CurrentStep) or 0),
Progress = if options.Progress ~= nil then options.Progress else if tonumber(options.Steps) then 0 else nil,
Duration = if options.Duration == nil then 4 else options.Duration,
_service = self,
_dismissed = false,
}
function item:Update(o)
if self._dismissed then
return self
end
o = normalizeOptions(o)
local hadImage = self.Image ~= nil
local hadActions = self.Actions and #self.Actions > 0 or false
local hadProgress = self.Progress ~= nil
for k, v in o do
self[k] = v
end
local hasImage = self.Image ~= nil
local hasActions = self.Actions and #self.Actions > 0 or false
local hasProgress = self.Progress ~= nil
if
hadImage ~= hasImage
or hadActions ~= hasActions
or hadProgress ~= hasProgress
or o.Actions ~= nil
or o.Duration ~= nil
or o.Sound ~= nil
then
if self._janitor then
self._janitor:Destroy()
self._service:_mount(self)
end
return self
end
if self._title then
self._title.Text = self.Title or ""
self._content.Text = self.Content or ""
self._renderIcon()
self._title.TextColor3 = if typeof(self.TitleColor) == "Color3"
then self.TitleColor
else self._service._window.Theme:Get("Text")
self._content.TextColor3 = if typeof(self.ContentColor) == "Color3"
then self.ContentColor
else self._service._window.Theme:Get("TextSecondary")
if self._image then
self._image.Image = tostring(self.Image or "")
self._image.ScaleType = self.ImageScaleType or Enum.ScaleType.Crop
end
if self._progressFill and self.Progress ~= nil then
self._progressFill.Size = UDim2.new(math.clamp(tonumber(self.Progress) or 0, 0, 1), 0, 1, 0)
end
end
return self
end
function item:SetImage(image, scaleType)
if self._dismissed then
return self
end
self.Image = image
if scaleType ~= nil then
self.ImageScaleType = scaleType
end
if self._janitor then
self._janitor:Destroy()
self._service:_mount(self)
end
return self
end
function item:SetColors(accent, title, content)
self.Color = accent
self.TitleColor = title
self.ContentColor = content
if self._title then
self._renderIcon()
self._title.TextColor3 = if typeof(title) == "Color3"
then title
else self._service._window.Theme:Get("Text")
self._content.TextColor3 = if typeof(content) == "Color3"
then content
else self._service._window.Theme:Get("TextSecondary")
end
return self
end
function item:SetProgress(value)
self.Progress = math.clamp(tonumber(value) or 0, 0, 1)
if self._progressFill then
self._progressFill.Size = UDim2.new(self.Progress, 0, 1, 0)
end
return self
end
function item:ChangeTitle(title)
return self:Update({ Title = title })
end
function item:ChangeDescription(description)
return self:Update({ Content = description })
end
function item:ChangeStep(step, total)
self.CurrentStep = math.max(0, tonumber(step) or 0)
if total ~= nil then
self.Steps = math.max(0, tonumber(total) or 0)
end
return self:SetProgress(if self.Steps > 0 then self.CurrentStep / self.Steps else 0)
end
function item:SetStep(step, total)
return self:ChangeStep(step, total)
end
function item:Dismiss()
if self._dismissed then
return
end
self._dismissed = true
local p = table.find(self._service._items, self)
if p then
table.remove(self._service._items, p)
end
if self._janitor then
self._janitor:Destroy()
end
self._service:_drain()
end
function item:Destroy()
self:Dismiss()
end
if #self._items < 4 then
table.insert(self._items, item)
self:_mount(item)
else
table.insert(self._queue, item)
end
return item
end
function Notify:_drain()
while #self._items < 4 and #self._queue > 0 do
local item = table.remove(self._queue, 1)
if not item._dismissed then
table.insert(self._items, item)
self:_mount(item)
end
end
end
function Notify:Destroy()
for i = #self._items, 1, -1 do
self._items[i]:Dismiss()
end
self._queue = {}
self._janitor:Destroy()
if self._host then
self._host:Destroy()
self._host = nil
end
end
return Notify
end

__modules["services/Overlays"] = function()
local Create = __require("runtime/Create")
local Janitor = __require("runtime/Janitor")
local Icon = __require("primitives/Icon")
local Overlays = {}
Overlays.__index = Overlays
function Overlays.new(window)
return setmetatable({ _window = window, _janitor = Janitor.new("Overlays"), _items = {} }, Overlays)
end
function Overlays:_handle(root, janitor)
local service = self
local handle = { Root = root, _janitor = janitor, _service = service, _destroyed = false }
function handle:SetVisible(visible)
self.Root.Visible = visible ~= false
return self
end
function handle:SetPosition(position)
if typeof(position) ~= "UDim2" then
error("[BobloUI] overlay:SetPosition expects UDim2.", 2)
end
self.Root.Position = position
return self
end
function handle:GetInstance()
return self.Root
end
function handle:Destroy()
if self._destroyed then
return
end
self._destroyed = true
local position = table.find(self._service._items, self)
if position then
table.remove(self._service._items, position)
end
self._service._janitor:Release(self)
self._janitor:Destroy()
end
table.insert(self._items, handle)
self._janitor:Add(handle, "Destroy", handle)
return handle
end
function Overlays:_drag(handle, gui)
local start
handle._janitor:Add(self._window.Input:AttachDrag(gui, function(delta)
if start then
handle.Root.Position =
UDim2.new(start.X.Scale, start.X.Offset + delta.X, start.Y.Scale, start.Y.Offset + delta.Y)
end
end, function()
start = handle.Root.Position
return true
end))
end
function Overlays:_surface(options)
options = options or {}
local w = self._window
local root = Create.New("Frame", {
AutomaticSize = Enum.AutomaticSize.XY,
Active = true,
Position = options.Position or UDim2.fromOffset(14, w.Device.Insets.Top + 14),
BackgroundTransparency = tonumber(options.Transparency) or 0.08,
BorderSizePixel = 0,
Visible = options.Visible ~= false,
ZIndex = tonumber(options.ZIndex) or 20,
Parent = w.Layers.Toast,
})
Create.New("UICorner", { CornerRadius = UDim.new(0, tonumber(options.CornerRadius) or 8), Parent = root })
local stroke = Create.New("UIStroke", {
Thickness = 1,
Transparency = 0.42,
LineJoinMode = Enum.LineJoinMode.Round,
Parent = root,
})
w:_bind(root, { BackgroundColor3 = options.BackgroundToken or "SurfaceRaised" })
w:_bind(stroke, { Color = options.BorderToken or "Border" })
local janitor = Janitor.new("Overlay")
janitor:Add(root)
return root, janitor
end
function Overlays:AddLabel(text, icon, iconPosition)
local options = if type(text) == "table" then text else { Text = text, Icon = icon, IconPosition = iconPosition }
local root, janitor = self:_surface(options)
local hasIcon = options.Icon ~= nil
local label = Create.New("TextLabel", {
AutomaticSize = Enum.AutomaticSize.XY,
BackgroundTransparency = 1,
Font = self._window.Fonts.Medium,
TextSize = self._window.Tokens:Get("FontSmall"),
Text = tostring(options.Text or ""),
Parent = root,
})
Create.New("UIPadding", {
PaddingTop = UDim.new(0, 7),
PaddingBottom = UDim.new(0, 7),
PaddingLeft = UDim.new(0, hasIcon and 30 or 10),
PaddingRight = UDim.new(0, hasIcon and 30 or 10),
Parent = label,
})
self._window:_bind(label, { TextColor3 = "TextSecondary" })
if hasIcon then
local right = options.IconPosition == "Right"
local glyph = Icon.new(self._window, options.Icon, {
Size = UDim2.fromOffset(14, 14),
Position = if right then UDim2.new(1, -9, 0.5, 0) else UDim2.new(0, 9, 0.5, 0),
AnchorPoint = if right then Vector2.new(1, 0.5) else Vector2.new(0, 0.5),
Parent = root,
})
Icon.setColor(glyph, self._window.Theme:Get("Accent"))
end
local handle = self:_handle(root, janitor)
handle.Label = label
function handle:SetText(value)
self.Label.Text = tostring(value or "")
return self
end
self:_drag(handle, root)
return handle
end
function Overlays:AddButton(text, callback, options)
if type(text) == "table" then
options = text
callback = options.Callback
text = options.Text or options.Title
end
options = options or {}
local root, janitor = self:_surface(options)
local button = Create.New("TextButton", {
AutomaticSize = Enum.AutomaticSize.XY,
BackgroundTransparency = 1,
BorderSizePixel = 0,
AutoButtonColor = false,
Font = self._window.Fonts.Medium,
TextSize = self._window.Tokens:Get("FontSmall"),
Text = tostring(text or "Action"),
Parent = root,
})
Create.New("UIPadding", {
PaddingTop = UDim.new(0, 8),
PaddingBottom = UDim.new(0, 8),
PaddingLeft = UDim.new(0, options.Icon and 32 or 11),
PaddingRight = UDim.new(0, 11),
Parent = button,
})
self._window:_bind(button, { TextColor3 = "Text" })
if options.Icon then
local glyph = Icon.new(self._window, options.Icon, {
Size = UDim2.fromOffset(14, 14),
Position = UDim2.new(0, 10, 0.5, 0),
AnchorPoint = Vector2.new(0, 0.5),
Parent = root,
})
Icon.setColor(glyph, self._window.Theme:Get("Accent"))
end
local handle = self:_handle(root, janitor)
handle.Button = button
function handle:SetText(value)
self.Button.Text = tostring(value or "")
return self
end
janitor:Add(button.MouseButton1Click:Connect(function()
if callback then
local ok, err = xpcall(callback, debug.traceback, handle)
if not ok then
warn(err)
end
end
end))
self:_drag(handle, root)
return handle
end
function Overlays:AddMenu(title, options)
options = options or {}
local root, janitor = self:_surface(options)
root.AutomaticSize = Enum.AutomaticSize.None
root.Size = options.Size or UDim2.fromOffset(260, 180)
local header = Create.New("TextButton", {
Size = UDim2.new(1, 0, 0, 34),
BackgroundTransparency = 0.45,
BorderSizePixel = 0,
AutoButtonColor = false,
Text = tostring(title or options.Title or "Menu"),
Font = self._window.Fonts.Medium,
TextSize = self._window.Tokens:Get("FontBody"),
TextXAlignment = Enum.TextXAlignment.Left,
Parent = root,
})
Create.New("UIPadding", { PaddingLeft = UDim.new(0, 11), PaddingRight = UDim.new(0, 11), Parent = header })
self._window:_bind(header, { BackgroundColor3 = "SurfaceInset", TextColor3 = "Text" })
local content = Create.New("Frame", {
Size = UDim2.new(1, -16, 1, -50),
Position = UDim2.fromOffset(8, 42),
BackgroundTransparency = 1,
Parent = root,
})
Create.List(6).Parent = content
local handle = self:_handle(root, janitor)
handle.Header = header
handle.Content = content
function handle:SetTitle(value)
self.Header.Text = tostring(value or "")
return self
end
self:_drag(handle, header)
return handle
end
function Overlays:Destroy()
for _, handle in table.clone(self._items) do
handle:Destroy()
end
self._janitor:Destroy()
end
return Overlays
end

__modules["services/Palette"] = function()
local Create = __require("runtime/Create")
local Surface = __require("primitives/Surface")
local Icon = __require("primitives/Icon")
local Palette = {}
Palette.__index = Palette
local MAX_ROWS = 7
local ROW_HEIGHT = 44
local SEARCH_HEIGHT = 42
local TOP_PAD = 10
local LIST_TOP = 60
local FOOTER_HEIGHT = 24
local function paletteWidth(window)
local configured = window._searchbarSize
if type(configured) == "number" then
return math.min(math.max(280, configured), window.Device.Viewport.X - 32)
end
if typeof(configured) == "UDim2" then
return math.min(
math.max(280, window.Device.Viewport.X * configured.X.Scale + configured.X.Offset),
window.Device.Viewport.X - 32
)
end
return math.min(520, window.Device.Viewport.X - 32)
end
function Palette.new(window, search, commands)
local self = setmetatable({
_window = window,
_search = search,
_commands = commands,
_handle = nil,
_mode = "search",
_results = {},
_rows = {},
_selected = 0,
}, Palette)
self._inputConn = window.Input.Began:Connect(function(i, processed)
if self._handle then
if i.KeyCode == Enum.KeyCode.Escape then
self:Close()
return
end
if i.KeyCode == Enum.KeyCode.Up then
self:_move(-1)
return
end
if i.KeyCode == Enum.KeyCode.Down then
self:_move(1)
return
end
if i.KeyCode == Enum.KeyCode.Return or i.KeyCode == Enum.KeyCode.KeypadEnter then
self:_activateSelected()
return
end
end
if processed then
return
end
if
i.KeyCode == Enum.KeyCode.K
and (window.Input:IsKeyDown(Enum.KeyCode.LeftControl) or window.Input:IsKeyDown(Enum.KeyCode.RightControl))
then
self:Open("")
end
end)
return self
end
function Palette:_desktopHeight(rowCount, empty)
if empty then
return 112
end
return LIST_TOP + rowCount * ROW_HEIGHT + FOOTER_HEIGHT + 8
end
function Palette:_applySize(rowCount, empty)
if not self._frame then
return
end
local w = self._window
if w.Device.Layout == "Drawer" then
self._frame.Size = UDim2.new(1, -12, 1, -72)
self._frame.Position = UDim2.fromOffset(6, 60)
return
end
local width = paletteWidth(w)
local height = math.min(404, self:_desktopHeight(rowCount, empty))
self._frame.Size = UDim2.fromOffset(width, height)
self._frame.Position = UDim2.fromScale(0.5, 0.18)
end
function Palette:Open(query, mode)
if self._window._disableSearch and mode ~= "commands" then
return self
end
if self._handle then
self:Close()
end
self._mode = mode or "search"
local w = self._window
local handle = w.Layers:Push({
Scrim = true,
Modal = false,
OnDismiss = function()
self._search:CancelPending()
self._handle = nil
self._box = nil
self._list = nil
self._frame = nil
self._results = {}
self._rows = {}
self._selected = 0
end,
})
self._handle = handle
local drawer = w.Device.Layout == "Drawer"
local frame = Surface.new(w, {
Size = if drawer then UDim2.new(1, -12, 1, -72) else UDim2.fromOffset(paletteWidth(w), 112),
Position = if drawer then UDim2.fromOffset(6, 60) else UDim2.fromScale(0.5, 0.18),
AnchorPoint = if drawer then Vector2.new(0, 0) else Vector2.new(0.5, 0),
BorderSizePixel = 0,
Parent = handle.Container,
}, {
Token = "SurfaceRaised",
StrokeToken = "Border",
StrokeTransparency = 0.40,
Corner = w.Tokens:Get("CornerLg"),
})
frame.ZIndex = handle.Depth * 10 + 3
self._frame = frame
local field = Create.New("Frame", {
Size = UDim2.new(1, -20, 0, SEARCH_HEIGHT),
Position = UDim2.fromOffset(10, TOP_PAD),
BackgroundTransparency = 0,
BorderSizePixel = 0,
Parent = frame,
})
Create.New("UICorner", { CornerRadius = UDim.new(0, w.Tokens:Get("FieldRadius")), Parent = field })
local fieldStroke = Create.New("UIStroke", { Thickness = 1, Transparency = 0.48, Parent = field })
w:_bind(field, { BackgroundColor3 = "ControlInset" })
w:_bind(fieldStroke, { Color = "BorderSubtle" })
local searchIcon =
Icon.new(w, "search", { Size = UDim2.fromOffset(16, 16), Position = UDim2.fromOffset(12, 13), Parent = field })
Icon.setColor(searchIcon, w.Theme:Get("TextTertiary"))
local esc = Create.New("TextLabel", {
Size = UDim2.fromOffset(34, 22),
Position = UDim2.new(1, -9, 0.5, 0),
AnchorPoint = Vector2.new(1, 0.5),
BackgroundTransparency = 0,
BorderSizePixel = 0,
Text = "ESC",
Font = w.Fonts.Medium,
TextSize = w.Tokens:Get("FontCaption"),
Parent = field,
})
Create.New("UICorner", { CornerRadius = UDim.new(0, 6), Parent = esc })
w:_bind(esc, { BackgroundColor3 = "SurfaceSecondary", TextColor3 = "TextTertiary" })
self._box = Create.New("TextBox", {
Size = UDim2.new(1, -82, 1, 0),
Position = UDim2.fromOffset(36, 0),
BackgroundTransparency = 1,
BorderSizePixel = 0,
ClearTextOnFocus = false,
PlaceholderText = w.Locale:T("search.placeholder"),
Text = query or "",
Font = w.Fonts.Regular,
TextSize = w.Tokens:Get("FontBody"),
TextXAlignment = Enum.TextXAlignment.Left,
Parent = field,
})
w:_bind(self._box, { TextColor3 = "Text", PlaceholderColor3 = "TextTertiary" })
self._box.Focused:Connect(function()
fieldStroke.Transparency = 0.08
fieldStroke.Color = w.Theme:Get("AccentBorder")
end)
self._box.FocusLost:Connect(function()
fieldStroke.Transparency = 0.48
fieldStroke.Color = w.Theme:Get("BorderSubtle")
end)
self._list = Create.New("Frame", {
Size = UDim2.new(1, -20, 1, -LIST_TOP - FOOTER_HEIGHT),
Position = UDim2.fromOffset(10, LIST_TOP),
BackgroundTransparency = 1,
Parent = frame,
})
Create.List(0).Parent = self._list
self._footer = Create.New("TextLabel", {
Size = UDim2.new(1, -24, 0, FOOTER_HEIGHT),
Position = UDim2.new(0, 12, 1, -FOOTER_HEIGHT - 2),
BackgroundTransparency = 1,
Font = w.Fonts.Regular,
TextSize = w.Tokens:Get("FontCaption"),
TextXAlignment = Enum.TextXAlignment.Left,
Text = "UP/DOWN  Navigate     ENTER  Open     ESC  Close",
Parent = frame,
})
w:_bind(self._footer, { TextColor3 = "TextTertiary" })
self._box:GetPropertyChangedSignal("Text"):Connect(function()
self:_scheduleRefresh()
end)
self._box:CaptureFocus()
self:_refresh()
return self
end
function Palette:_collect()
local w = self._window
local text = self._box.Text
if string.sub(text, 1, 1) == ">" or self._mode == "commands" then
return self._commands:Query(string.gsub(text, "^>%s*", ""))
end
if string.sub(text, 1, 1) == "@" then
local q = string.lower(string.gsub(text, "^@%s*", ""))
local results = {}
for _, tab in w._tabs do
local shown = w.Locale:Resolve(tab.Title)
if q == "" or string.find(string.lower(shown), q, 1, true) then
table.insert(results, { Kind = "Tab", Title = shown, Handle = tab, Path = "Tab" })
end
end
return results
end
if string.sub(text, 1, 1) == "#" then
local q = string.lower(string.gsub(text, "^#%s*", ""))
local results = {}
if w.Config then
for _, name in w.Config:List() do
if q == "" or string.find(string.lower(name), q, 1, true) then
table.insert(results, { Kind = "Config", Title = name, Id = name, Path = "Config profile" })
end
end
end
return results
end
if string.sub(text, 1, 1) == "*" then
local q = string.lower(string.gsub(text, "^%*%s*", ""))
local results = {}
for _, id in w.Favorites:List() do
local h = w:Get(id)
if h then
local title = w.Locale:Resolve(h.Title or id)
if q == "" or string.find(string.lower(title), q, 1, true) then
table.insert(results, { Kind = "Favorite", Title = title, Handle = h, Path = "Favorite" })
end
end
end
return results
end
return self._search:Query(text)
end
function Palette:_scheduleRefresh()
if not self._box then
return
end
local text = self._box.Text
local prefix = string.sub(text, 1, 1)
if self._mode == "commands" or prefix == ">" or prefix == "@" or prefix == "#" or prefix == "*" then
self._search:CancelPending()
self:_refresh()
return
end
self._search:QueryDebounced(text, function(results)
if self._box and self._box.Text == text then
self:_refresh(results)
end
end)
end
function Palette:_emptyState(text)
local w = self._window
local title = Create.New("TextLabel", {
Size = UDim2.new(1, 0, 0, 22),
BackgroundTransparency = 1,
Font = w.Fonts.Medium,
TextSize = w.Tokens:Get("FontBody"),
TextXAlignment = Enum.TextXAlignment.Left,
Text = if text == "" then "Search controls" else "No results",
Parent = self._list,
})
w:_bind(title, { TextColor3 = if text == "" then "TextSecondary" else "Text" })
local hint = Create.New("TextLabel", {
Size = UDim2.new(1, 0, 0, 20),
BackgroundTransparency = 1,
Font = w.Fonts.Regular,
TextSize = w.Tokens:Get("FontSmall"),
TextXAlignment = Enum.TextXAlignment.Left,
Text = if text == ""
then "Type a control, > command, @ tab, # config, or * favorite"
else "Try another name or use > @ # *",
Parent = self._list,
})
w:_bind(hint, { TextColor3 = "TextTertiary" })
end
function Palette:_refresh(precomputed)
if not self._list then
return
end
for _, c in self._list:GetChildren() do
if c:IsA("GuiObject") then
c:Destroy()
end
end
local w = self._window
local raw = precomputed or self:_collect()
self._results = {}
self._rows = {}
self._selected = 0
for i = 1, math.min(MAX_ROWS, #raw) do
self._results[i] = raw[i]
end
local empty = #self._results == 0
self._footer.Visible = not empty
self:_applySize(#self._results, empty)
if empty then
self:_emptyState(self._box.Text)
return
end
for index, r in self._results do
local b = Create.New("TextButton", {
Size = UDim2.new(1, 0, 0, ROW_HEIGHT),
BackgroundTransparency = 1,
BorderSizePixel = 0,
AutoButtonColor = false,
Text = "",
Parent = self._list,
})
Create.New("UICorner", { CornerRadius = UDim.new(0, w.Tokens:Get("FieldRadius")), Parent = b })
w:_bind(b, { BackgroundColor3 = "AccentSoft" })
local title = Create.New("TextLabel", {
Size = UDim2.new(1, -82, 0, 21),
Position = UDim2.fromOffset(10, 4),
BackgroundTransparency = 1,
Font = w.Fonts.Medium,
TextSize = w.Tokens:Get("FontBody"),
TextXAlignment = Enum.TextXAlignment.Left,
Text = r.Title,
Parent = b,
})
w:_bind(title, { TextColor3 = "Text" })
local path = Create.New("TextLabel", {
Size = UDim2.new(1, -82, 0, 15),
Position = UDim2.fromOffset(10, 24),
BackgroundTransparency = 1,
Font = w.Fonts.Regular,
TextSize = w.Tokens:Get("FontCaption"),
TextXAlignment = Enum.TextXAlignment.Left,
Text = (r.Hidden and r.Requirement and ((r.Path or "") .. " · requires: " .. r.Requirement))
or r.Path
or (r.Kind == "Command" and "Command" or ""),
Parent = b,
})
w:_bind(path, { TextColor3 = "TextTertiary" })
local kind = Create.New("TextLabel", {
AutomaticSize = Enum.AutomaticSize.X,
Size = UDim2.new(0, 0, 0, 20),
Position = UDim2.new(1, -10, 0.5, 0),
AnchorPoint = Vector2.new(1, 0.5),
BackgroundTransparency = 1,
Font = w.Fonts.Medium,
TextSize = w.Tokens:Get("FontCaption"),
Text = string.upper(r.Kind or "CONTROL"),
Parent = b,
})
w:_bind(kind, { TextColor3 = "TextTertiary" })
self._rows[index] = b
b.MouseEnter:Connect(function()
self:_select(index)
end)
b.MouseButton1Click:Connect(function()
self:_activate(r)
end)
end
self:_select(1)
end
function Palette:_select(index)
if #self._rows == 0 then
self._selected = 0
return
end
index = ((index - 1) % #self._rows) + 1
self._selected = index
for i, row in self._rows do
if row.Parent then
row.BackgroundTransparency = if i == index then 0 else 1
end
end
end
function Palette:_move(delta)
if #self._rows == 0 then
return
end
self:_select((self._selected > 0 and self._selected or 1) + delta)
end
function Palette:_activate(r)
if not r then
return
end
local w = self._window
if r.Kind == "Command" then
self._commands:Run(r.Id)
elseif r.Kind == "Config" and w.Config then
w.Config:Load(r.Id)
elseif r.Kind == "Tab" then
r.Handle:Select()
elseif r.Kind == "Favorite" and r.Handle then
r.Handle:Reveal()
elseif r.Hidden and r.DependencyIds and r.DependencyIds[1] then
local dep = w.Registry:Get(r.DependencyIds[1])
if dep and dep.Reveal then
dep:Reveal()
end
elseif r.Handle and r.Handle.Reveal then
r.Handle:Reveal()
end
self:Close()
end
function Palette:_activateSelected()
if self._selected > 0 then
self:_activate(self._results[self._selected])
end
end
function Palette:Close()
self._search:CancelPending()
if self._handle then
local h = self._handle
self._handle = nil
h:Dismiss()
end
self._box = nil
self._list = nil
self._frame = nil
self._footer = nil
self._results = {}
self._rows = {}
self._selected = 0
end
function Palette:Destroy()
self:Close()
if self._inputConn then
self._inputConn:Disconnect()
end
end
return Palette
end

__modules["services/Search"] = function()
local Search = {}
Search.__index = Search
local EXCLUDED_TYPES = {
Section = true,
Tab = true,
Divider = true,
}
local function lower(value)
return string.lower(tostring(value or ""))
end
local function subsequence(query, text)
local queryIndex = 1
for index = 1, #text do
if string.sub(text, index, index) == string.sub(query, queryIndex, queryIndex) then
queryIndex += 1
if queryIndex > #query then
return true
end
end
end
return false
end
function Search.new(window)
local self = setmetatable({
_window = window,
_registry = window.Registry,
_index = {},
_byKey = {},
_debounceGeneration = 0,
_debounceThread = nil,
_destroyed = false,
}, Search)
self._addedConnection = self._registry.Added:Connect(function(entry)
self:_upsert(entry)
end)
self._updatedConnection = self._registry.Updated:Connect(function(entry)
self:_upsert(entry)
end)
self._removedConnection = self._registry.Removed:Connect(function(entry)
self:_remove(entry)
end)
self:Reindex()
return self
end
function Search:_remove(entry)
local key = entry and entry.Key
local record = key and self._byKey[key]
if not record then
return
end
self._byKey[key] = nil
local position = table.find(self._index, record)
if position then
table.remove(self._index, position)
end
end
function Search:_upsert(entry)
if not entry or EXCLUDED_TYPES[entry.Type] then
self:_remove(entry)
return
end
local record = self._byKey[entry.Key]
if not record then
record = { Key = entry.Key }
self._byKey[entry.Key] = record
table.insert(self._index, record)
end
record.Entry = entry
record.Id = lower(entry.Id)
record.Title = lower(entry.Title)
record.Description = lower(entry.Description)
record.Path = lower(entry.Path)
record.Keywords = {}
for _, keyword in entry.Keywords or {} do
table.insert(record.Keywords, lower(keyword))
end
end
function Search:_score(record, query)
local entry = record.Entry
local score = 0
if record.Id == query then
score = 1000
elseif string.sub(record.Title, 1, #query) == query then
score = 800
elseif string.find(record.Title, query, 1, true) then
score = 600
end
for _, keyword in record.Keywords do
if keyword == query then
score = math.max(score, 500)
elseif string.sub(keyword, 1, #query) == query then
score = math.max(score, 400)
end
end
if string.find(record.Description, query, 1, true) then
score = math.max(score, 200)
end
if string.find(record.Path, query, 1, true) then
score = math.max(score, 150)
end
if score == 0 and #query > 1 and subsequence(query, record.Title) then
score = 80
end
if self._window.Favorites and entry.Id and self._window.Favorites:Has(entry.Id) then
score += 60
end
if entry.Hidden then
score -= 200
end
return score
end
function Search:Query(text)
local query = lower(text)
local results = {}
for _, record in self._index do
local entry = record.Entry
local handle = entry.Handle
local activeOnly = self._window._globalSearch == false
local tab = handle and handle._section and handle._section._tab
if activeOnly and tab ~= nil and tab ~= self._window._active then
continue
end
local score
if query == "" then
score = if self._window.Favorites and entry.Id and self._window.Favorites:Has(entry.Id) then 100 else 0
else
score = self:_score(record, query)
end
if score > 0 then
table.insert(results, {
Kind = "Control",
Id = entry.Id,
Title = entry.Title,
Path = entry.Path or "",
Description = entry.Description,
Score = score,
Hidden = entry.Hidden,
Handle = entry.Handle,
Type = entry.Type,
DependencyIds = entry.DependencyIds,
Requirement = entry.Requirement,
})
end
end
table.sort(results, function(a, b)
if a.Score == b.Score then
return tostring(a.Title) < tostring(b.Title)
end
return a.Score > b.Score
end)
local out = {}
for index = 1, math.min(12, #results) do
out[index] = results[index]
end
return out
end
function Search:QueryDebounced(text, callback, delay)
if type(callback) ~= "function" then
error("[BobloUI] Search:QueryDebounced expects a callback.", 2)
end
self:CancelPending()
self._debounceGeneration += 1
local generation = self._debounceGeneration
self._debounceThread = task.delay(tonumber(delay) or 0.075, function()
if self._destroyed or generation ~= self._debounceGeneration then
return
end
self._debounceThread = nil
callback(self:Query(text))
end)
return generation
end
function Search:CancelPending()
self._debounceGeneration += 1
if self._debounceThread then
pcall(task.cancel, self._debounceThread)
self._debounceThread = nil
end
return self
end
function Search:Reveal(id)
local handle = self._registry:Get(id)
if handle and handle.Reveal then
handle:Reveal()
return true
end
return false
end
function Search:Reindex()
self._index = {}
self._byKey = {}
for _, entry in self._registry:Entries() do
self:_upsert(entry)
end
return self
end
function Search:Destroy()
if self._destroyed then
return
end
self._destroyed = true
self:CancelPending()
for _, connection in { self._addedConnection, self._updatedConnection, self._removedConnection } do
if connection then
connection:Disconnect()
end
end
self._index = {}
self._byKey = {}
end
return Search
end

__modules["services/Settings"] = function()
local Env = __require("runtime/Env")
local Settings = {}
Settings.__index = Settings
local THEME_COLOR_TOKENS = {
"Canvas",
"Background",
"Sidebar",
"Surface",
"SurfaceRaised",
"SurfaceInset",
"SurfaceSecondary",
"SurfaceHover",
"SurfaceActive",
"Control",
"ControlHover",
"ControlPressed",
"ControlInset",
"BorderSubtle",
"Border",
"BorderStrong",
"Text",
"TextSecondary",
"TextTertiary",
"TextDisabled",
"Success",
"Warning",
"Error",
"Info",
"Scrim",
}
local function clearSection(section)
for _, control in table.clone(section._controls or {}) do
control:Destroy()
end
end
local function serviceValue(service, getter, defaultValue)
if service ~= nil then
local value = getter(service)
if value ~= nil then
return value
end
end
return defaultValue
end
function Settings.new(window, options)
local self = setmetatable(
{ _window = window, _options = options or {}, _mounted = false, _refreshing = false, _tokenControls = {} },
Settings
)
window._settingsService = self
return self
end
function Settings:_profileOptions()
local list = self._window.Config and self._window.Config:List() or {}
if #list == 0 then
return { "Default" }
end
return list
end
function Settings:_refreshProfiles()
if self._profileDrop then
self._profileDrop:SetOptions(self:_profileOptions())
end
end
function Settings:_refreshFavorites()
if not self._favoritesSection or self._refreshing then
return
end
self._refreshing = true
clearSection(self._favoritesSection)
local ids = self._window.Favorites:List()
if #ids == 0 then
self._favoritesSection:AddParagraph({ Content = "@settings.favorites.empty" })
else
for _, id in ids do
local handle = self._window:Get(id)
if handle and not handle._destroyed then
self._favoritesSection:AddButton({
Title = handle.Title or id,
Text = "@settings.open",
Variant = "Ghost",
Callback = function()
handle:Reveal()
end,
ContextMenu = {
{
Text = "@settings.removeFavorite",
Callback = function()
self._window.Favorites:Remove(id)
end,
},
},
})
end
end
end
self._refreshing = false
end
function Settings:_refreshKeybinds()
if not self._keybindSection or self._refreshing then
return
end
self._refreshing = true
clearSection(self._keybindSection)
local n = 0
for _, entry in self._window.Registry:Entries() do
if
entry.Type == "Keybind"
and entry.Handle
and not entry.Handle._destroyed
and not string.match(entry.Id or "", "^__settings")
then
n += 1
local h = entry.Handle
local current = h:GetValue()
local key = (type(current) == "table" and current.Key) or "None"
self._keybindSection:AddButton({
Title = h.Title or entry.Id,
Text = tostring(key),
Variant = "Ghost",
Callback = function()
h:Reveal()
task.defer(function()
h:Capture()
end)
end,
})
end
end
if n == 0 then
self._keybindSection:AddParagraph({ Content = "@settings.keybinds.empty" })
end
self._refreshing = false
end
function Settings:_buildConfig(section)
local w = self._window
if not w.Config then
section:AddParagraph({ Variant = "Info", Content = "@settings.config.disabled" })
return
end
self._profileName = section:AddInput({
Id = "__settings.configName",
Title = "@settings.config.name",
Icon = "file-pen",
Default = "Default",
IgnoreConfig = true,
Adaptive = true,
})
self._profileDrop = section:AddDropdown({
Id = "__settings.configProfile",
Title = "@settings.config.profile",
Icon = "folder-open",
Options = self:_profileOptions(),
Default = self:_profileOptions()[1],
AllowNone = true,
IgnoreConfig = true,
Adaptive = true,
})
local function chosen()
return self._profileDrop:GetValue() or self._profileName:GetValue() or "Default"
end
section:AddButton({
Title = "@settings.config.save",
Icon = "save",
Text = "@settings.save",
Variant = "Primary",
Callback = function()
local ok, err = w.Config:Save(self._profileName:GetValue() or chosen())
if ok then
self:_refreshProfiles()
w.Notify:Push({ Title = w.Locale:T("settings.saved"), Variant = "Success" })
else
w.Notify:Push({ Title = tostring(err), Variant = "Error" })
end
end,
})
section:AddButton({
Title = "@settings.config.load",
Icon = "folder-open",
Text = "@settings.load",
Callback = function()
local ok, err = w.Config:Load(chosen())
if not ok then
w.Notify:Push({ Title = tostring(err), Variant = "Error" })
end
end,
})
section:AddButton({
Title = "@settings.config.autoload",
Icon = "circle-check",
Text = "@settings.set",
Callback = function()
w.Config:SetAutoLoad(chosen())
w.Notify:Push({ Title = w.Locale:T("settings.autoloadSet"), Variant = "Success" })
end,
})
section:AddButton({
Title = "@settings.config.duplicate",
Icon = "copy",
Text = "@settings.duplicate",
Callback = function()
task.spawn(function()
local name =
w.Dialog:Prompt({ Title = w.Locale:T("settings.config.duplicate"), Placeholder = "Copy" }):Await()
if name and name ~= "" then
w.Config:Duplicate(chosen(), name)
self:_refreshProfiles()
end
end)
end,
})
section:AddButton({
Title = "@settings.config.rename",
Icon = "file-pen",
Text = "@settings.rename",
Callback = function()
task.spawn(function()
local name =
w.Dialog:Prompt({ Title = w.Locale:T("settings.config.rename"), Default = chosen() }):Await()
if name and name ~= "" then
w.Config:Rename(chosen(), name)
self:_refreshProfiles()
end
end)
end,
})
section:AddButton({
Title = "@settings.config.delete",
Icon = "trash-2",
Text = "@settings.delete",
Variant = "Danger",
Callback = function()
task.spawn(function()
if
w.Dialog
:Confirm({ Title = w.Locale:T("settings.config.delete"), Content = chosen(), Danger = true })
:Await()
then
w.Config:Delete(chosen())
self:_refreshProfiles()
end
end)
end,
})
section:AddButton({
Title = "@settings.config.export",
Icon = "upload",
Text = "@settings.export",
Callback = function()
local raw = w.Config:Export(chosen())
if raw then
w.Notify:Push({ Title = w.Locale:T("settings.copied"), Variant = "Success" })
end
end,
})
section:AddButton({
Title = "@settings.config.import",
Icon = "download",
Text = "@settings.import",
Callback = function()
task.spawn(function()
local raw = w.Dialog
:Prompt({
Title = w.Locale:T("settings.config.import"),
Content = w.Locale:T("settings.config.paste"),
Placeholder = "{...}",
})
:Await()
if raw and raw ~= "" then
local name =
w.Dialog:Prompt({ Title = w.Locale:T("settings.config.name"), Default = "Imported" }):Await()
if name then
local ok, err = w.Config:Import(raw, name)
if ok then
self:_refreshProfiles()
else
w.Notify:Push({ Title = tostring(err), Variant = "Error" })
end
end
end
end)
end,
})
end
function Settings:_syncAppearance()
if not self._mounted then
return
end
local w = self._window
if self._themeControl then
self._themeControl:SetOptions(w.Theme:List())
self._themeControl:SetValue(w.Theme:Current(), true)
end
if self._accentControl then
self._accentControl:SetValue(w.Theme:Get("Accent"), true)
end
if self._scaleControl then
self._scaleControl:SetValue(math.floor((w:GetScale() or 1) * 100 + 0.5), true)
end
if self._radiusControl then
self._radiusControl:SetValue(
serviceValue(w, function(window)
if window.GetCornerRadius ~= nil then
return window:GetCornerRadius()
end
return nil
end, 0),
true
)
end
if self._densityControl then
self._densityControl:SetValue(w.Tokens:GetDensity(), true)
end
if self._localeControl then
self._localeControl:SetOptions(w.Locale:List())
self._localeControl:SetValue(w.Locale:Get(), true)
end
if self._motionControl then
self._motionControl:SetValue(not w.Motion.Enabled, true)
end
if self._contrastControl then
self._contrastControl:SetValue(w.Theme:IsHighContrast(), true)
end
if self._navigationControl and w.Navigation then
self._navigationControl:SetValue(w.Navigation:IsEnabled(), true)
end
if self._sidebarControl and w.IsSidebarHidden then
self._sidebarControl:SetValue(w:IsSidebarHidden(), true)
end
if self._opacityControl and w.GetWindowOpacity then
self._opacityControl:SetValue(math.floor(w:GetWindowOpacity() * 100 + 0.5), true)
end
if self._cursorControl and w.Cursor then
self._cursorControl:SetValue(w.Cursor:IsEnabled(), true)
end
if self._soundsControl and w.Sound then
self._soundsControl:SetValue(w.Sound:IsEnabled(), true)
end
if self._soundVolumeControl and w.Sound then
self._soundVolumeControl:SetValue(math.floor(w.Sound:GetVolume() * 100 + 0.5), true)
end
for token, control in self._tokenControls do
if control and not control._destroyed then
control:SetValue(w.Theme:Get(token), true)
end
end
if self._scrimTransparencyControl and not self._scrimTransparencyControl._destroyed then
self._scrimTransparencyControl:SetValue(math.floor(w.Theme:Get("ScrimTransparency") * 100 + 0.5), true)
end
end
function Settings:_ensureMounted()
if self._mounted then
return self
end
self._mounted = true
local w = self._window
local tab = w:AddTab({
Id = "__bobloui_settings",
Title = "@settings.title",
Description = "@settings.description",
Icon = "settings-2",
Group = "@nav.system",
Order = 999,
_system = true,
})
self.Tab = tab
local appearance = tab:AddSection({
Id = "__settings.appearance",
Title = "@settings.appearance",
Description = "@settings.appearanceDesc",
Icon = "palette",
Span = "Auto",
})
self._themeControl = appearance:AddDropdown({
Id = "__settings.theme",
Title = "@settings.theme",
Icon = "swatch-book",
Options = w.Theme:List(),
Default = w.Theme:Current(),
IgnoreConfig = true,
FormatDisplayValue = function(value)
local polarity = w.Theme:Polarity(value)
if not polarity or value == polarity then
return value
end
return `{value} · {polarity}`
end,
Callback = function(v)
w:SetTheme(v)
end,
})
self._accentControl = appearance:AddColorPicker({
Id = "__settings.accent",
Title = "@settings.accent",
Icon = "pipette",
Default = w.Theme:Get("Accent"),
IgnoreConfig = true,
Callback = function(v)
local c = type(v) == "table" and v.Color or v
if typeof(c) == "Color3" then
w:SetAccent(c)
end
end,
})
self._scaleControl = appearance:AddSlider({
Id = "__settings.scale",
Title = "@settings.scale",
Icon = "zoom-in",
Min = 70,
Max = 140,
Step = 5,
Default = math.floor((w._scale or 1) * 100 + 0.5),
Suffix = "%",
IgnoreConfig = true,
Callback = function(v)
w:SetScale(v / 100)
end,
})
self._radiusControl = appearance:AddSlider({
Id = "__settings.radius",
Title = "Window corner radius",
Icon = "square-round-corner",
Min = 0,
Max = 28,
Step = 1,
Default = serviceValue(w, function(window)
if window.GetCornerRadius ~= nil then
return window:GetCornerRadius()
end
return nil
end, 0),
Suffix = " px",
IgnoreConfig = true,
Callback = function(v)
if w.SetCornerRadius then
w:SetCornerRadius(v)
end
end,
})
self._densityControl = appearance:AddDropdown({
Id = "__settings.density",
Title = "@settings.density",
Icon = "rows-3",
Options = { "Compact", "Comfortable", "Touch" },
Default = w.Tokens:GetDensity(),
IgnoreConfig = true,
Callback = function(v)
w:SetDensity(v)
end,
})
self._localeControl = appearance:AddDropdown({
Id = "__settings.locale",
Title = "@settings.language",
Icon = "languages",
Options = w.Locale:List(),
Default = w.Locale:Get(),
IgnoreConfig = true,
Callback = function(v)
w:SetLocale(v)
end,
})
self._motionControl = appearance:AddToggle({
Id = "__settings.motion",
Title = "@settings.reducedMotion",
Icon = "accessibility",
Default = not w.Motion.Enabled,
IgnoreConfig = true,
Callback = function(v)
w:SetReducedMotion(v)
end,
})
self._contrastControl = appearance:AddToggle({
Id = "__settings.contrast",
Title = "@settings.highContrast",
Icon = "sun-medium",
Default = w.Theme:IsHighContrast(),
IgnoreConfig = true,
Callback = function(v)
w:SetHighContrast(v)
end,
})
self._navigationControl = appearance:AddToggle({
Id = "__settings.navigation",
Title = "@settings.keyboardNavigation",
Icon = "keyboard",
Default = serviceValue(w.Navigation, function(service)
return service:IsEnabled()
end, true),
IgnoreConfig = true,
Callback = function(v)
w:SetKeyboardNavigation(v)
end,
})
self._soundsControl = appearance:AddToggle({
Id = "__settings.sounds",
Title = "@settings.uiSounds",
Icon = "volume-2",
Default = serviceValue(w.Sound, function(service)
return service:IsEnabled()
end, true),
IgnoreConfig = true,
Callback = function(v)
w:SetUISounds(v)
end,
})
self._soundVolumeControl = appearance:AddSlider({
Id = "__settings.soundVolume",
Title = "@settings.soundVolume",
Icon = "audio-lines",
Min = 0,
Max = 100,
Step = 5,
Default = serviceValue(w.Sound, function(service)
local volume = service:GetVolume()
if volume ~= nil then
return math.floor(volume * 100 + 0.5)
end
return nil
end, 100),
Suffix = "%",
IgnoreConfig = true,
VisibleWhen = function(State)
return State:Get("__settings.sounds") ~= false
end,
Callback = function(v)
w:SetSoundVolume(v / 100)
end,
})
local editor = tab:AddSection({
Id = "__settings.themeEditor",
Title = "@settings.themeEditor",
Description = "@settings.themeEditorDesc",
Icon = "paintbrush",
Collapsible = true,
Collapsed = true,
Span = "Auto",
})
for _, token in THEME_COLOR_TOKENS do
local name = token
self._tokenControls[name] = editor:AddColorPicker({
Id = "__settings.token." .. name,
Title = name,
Default = w.Theme:Get(name),
IgnoreConfig = true,
Callback = function(v)
local c = type(v) == "table" and v.Color or v
if typeof(c) == "Color3" then
w.Theme:SetToken(name, c)
end
end,
})
end
self._scrimTransparencyControl = editor:AddSlider({
Id = "__settings.token.ScrimTransparency",
Title = "Scrim transparency",
Description = "Opacity of the backdrop behind dialogs and sheets",
Min = 0,
Max = 100,
Step = 1,
Default = math.floor(w.Theme:Get("ScrimTransparency") * 100 + 0.5),
Suffix = "%",
IgnoreConfig = true,
Callback = function(value)
w.Theme:SetToken("ScrimTransparency", value / 100)
end,
})
editor:AddButton({
Title = "@settings.theme.reset",
Icon = "rotate-ccw",
Text = "@settings.reset",
Callback = function()
w.Theme:ResetOverrides()
w:SetAccent(nil)
w.Notify:Push({ Title = w.Locale:T("settings.resetDone"), Variant = "Success" })
end,
})
editor:AddButton({
Title = "@settings.theme.export",
Icon = "upload",
Text = "@settings.export",
Callback = function()
w:ExportTheme(true)
w.Notify:Push({ Title = w.Locale:T("settings.copied"), Variant = "Success" })
end,
})
editor:AddButton({
Title = "@settings.theme.import",
Icon = "download",
Text = "@settings.import",
Callback = function()
task.spawn(function()
local raw =
w.Dialog:Prompt({ Title = w.Locale:T("settings.theme.import"), Placeholder = "{...}" }):Await()
if raw then
local ok, err = w:ImportTheme(raw)
if not ok then
w.Notify:Push({ Title = tostring(err), Variant = "Error" })
end
end
end)
end,
})
editor:AddButton({
Title = "Save custom theme",
Icon = "save",
Text = "Save as…",
Callback = function()
task.spawn(function()
local name = w.Dialog
:Prompt({
Title = "Save custom theme",
Content = "Use letters, numbers, dots, dashes or underscores.",
Placeholder = "MyTheme",
})
:Await()
if name and name ~= "" then
local ok, err = w:SaveCustomTheme(name)
w.Notify:Push({
Title = if ok then `Saved theme {name}` else "Theme was not saved",
Content = if ok then "It is now available in the theme list." else tostring(err),
Variant = if ok then "Success" else "Error",
})
end
end)
end,
})
editor:AddButton({
Title = "Use current theme by default",
Icon = "pin",
Text = "Set default",
Callback = function()
local ok, err = w:SetDefaultTheme(w.Theme:Current())
w.Notify:Push({
Title = if ok then "Default theme updated" else "Default was not changed",
Content = if ok then w.Theme:Current() else tostring(err),
Variant = if ok then "Success" else "Error",
})
end,
})
editor:AddButton({
Title = "Delete current custom theme",
Icon = "trash-2",
Text = "Delete",
Variant = "Danger",
Confirm = "Delete the selected custom theme? Built-in Dark and Light cannot be deleted.",
Callback = function()
local name = w.Theme:Current()
local ok, err = w:DeleteCustomTheme(name)
w.Notify:Push({
Title = if ok then `Deleted theme {name}` else "Theme was not deleted",
Content = if ok then "Dark is active now." else tostring(err),
Variant = if ok then "Success" else "Error",
})
end,
})
local windowSec = tab:AddSection({
Id = "__settings.window",
Title = "@settings.window",
Icon = "app-window",
Span = "Auto",
})
windowSec:AddToggle({
Id = "__settings.lock",
Title = "@settings.lockWindow",
Icon = "lock",
Default = w:IsLocked(),
IgnoreConfig = true,
Callback = function(v)
w:SetLocked(v)
end,
})
windowSec:AddToggle({
Id = "__settings.remember",
Title = "@settings.rememberGeometry",
Icon = "save",
Default = w:GetRememberGeometry(),
IgnoreConfig = true,
Callback = function(v)
w:SetRememberGeometry(v)
end,
})
windowSec:AddToggle({
Id = "__settings.sidebar",
Title = "Hide sidebar",
Icon = "panel-left",
Default = serviceValue(w, function(window)
if window.IsSidebarHidden ~= nil then
return window:IsSidebarHidden()
end
return nil
end, false),
IgnoreConfig = true,
Callback = function(v)
if w.SetSidebarHidden then
w:SetSidebarHidden(v)
end
end,
})
self._opacityControl = windowSec:AddSlider({
Id = "__settings.opacity",
Title = "Window opacity",
Icon = "blend",
Min = 35,
Max = 100,
Step = 5,
Default = serviceValue(w, function(window)
if window.GetWindowOpacity ~= nil then
local opacity = window:GetWindowOpacity()
if opacity ~= nil then
return math.floor(opacity * 100 + 0.5)
end
end
return nil
end, 100),
Suffix = "%",
IgnoreConfig = true,
Callback = function(v)
if w.SetWindowOpacity then
w:SetWindowOpacity(v / 100)
end
end,
})
self._cursorControl = windowSec:AddToggle({
Id = "__settings.cursor",
Title = "Custom cursor",
Icon = "mouse-pointer-2",
Default = serviceValue(w.Cursor, function(cursor)
return cursor:IsEnabled()
end, false),
IgnoreConfig = true,
Callback = function(v)
if w.SetCustomCursor then
w:SetCustomCursor(v)
end
end,
})
windowSec:AddDropdown({
Id = "__settings.notifyPosition",
Title = "Notification position",
Icon = "bell",
Options = { "BottomRight", "BottomLeft", "TopRight", "TopLeft" },
Default = serviceValue(w.Notify, function(notify)
return notify:GetPosition()
end, "BottomRight"),
IgnoreConfig = true,
Callback = function(v)
if w.SetNotificationPosition then
w:SetNotificationPosition(v)
end
end,
})
windowSec:AddButton({
Title = "@settings.resetLayout",
Icon = "rotate-ccw",
Text = "@settings.reset",
Callback = function()
w:ResetGeometry()
end,
})
windowSec:AddButton({
Title = "@settings.resetAll",
Icon = "trash-2",
Text = "@settings.reset",
Variant = "Danger",
Confirm = "Reset every saved control to its default value?",
Callback = function()
w:ResetAll()
end,
})
local config = tab:AddSection({
Id = "__settings.configs",
Title = "@settings.configs",
Icon = "folder-cog",
Collapsible = true,
Collapsed = false,
Span = "Auto",
})
self:_buildConfig(config)
self._favoritesSection = tab:AddSection({
Id = "__settings.favorites",
Title = "@settings.favorites",
Icon = "star",
Collapsible = true,
Collapsed = false,
Span = "Auto",
})
self._keybindSection = tab:AddSection({
Id = "__settings.keybinds",
Title = "@settings.keybinds",
Icon = "keyboard",
Collapsible = true,
Collapsed = false,
Span = "Auto",
})
self:_refreshFavorites()
self:_refreshKeybinds()
self._favConn = w.Favorites.Changed:Connect(function()
task.defer(function()
self:_refreshFavorites()
end)
end)
self._regAdd = w.Registry.Added:Connect(function(entry)
if entry.Type == "Keybind" then
task.defer(function()
self:_refreshKeybinds()
end)
end
end)
self._regRemove = w.Registry.Removed:Connect(function(entry)
if entry.Type == "Keybind" then
task.defer(function()
self:_refreshKeybinds()
end)
end
end)
if w.Config then
self._savedConn = w.Config.Saved:Connect(function()
self:_refreshProfiles()
end)
end
self._themeConn = w.Theme.Changed:Connect(function()
task.defer(function()
self:_syncAppearance()
end)
end)
self._tokensConn = w.Tokens.Changed:Connect(function()
task.defer(function()
self:_syncAppearance()
end)
end)
self._localeConn = w.Locale.Changed:Connect(function()
task.defer(function()
self:_syncAppearance()
end)
end)
self:_syncAppearance()
return self
end
function Settings:RefreshThemeOptions()
if self._themeControl and not self._themeControl._destroyed then
self._themeControl:SetOptions(self._window.Theme:List(), true)
self._themeControl:SetValue(self._window.Theme:Current(), true)
end
return self
end
function Settings:Open()
self:_ensureMounted()
if self.Tab then
self.Tab:Select()
end
return self
end
function Settings:Destroy()
for _, c in
{
self._favConn,
self._regAdd,
self._regRemove,
self._savedConn,
self._themeConn,
self._tokensConn,
self._localeConn,
}
do
if c then
c:Disconnect()
end
end
end
return Settings
end

__modules["services/Sound"] = function()
local SoundService = game:GetService("SoundService")
local Janitor = __require("runtime/Janitor")
local Sound = {}
Sound.__index = Sound
local function normalize(spec)
if type(spec) == "string" or type(spec) == "number" then
return { Id = tostring(spec), Volume = 0.35, PlaybackSpeed = 1 }
end
if type(spec) ~= "table" then
return nil
end
return {
Id = tostring(spec.Id or spec.SoundId or ""),
Volume = math.clamp(tonumber(spec.Volume) or 0.35, 0, 10),
PlaybackSpeed = math.clamp(tonumber(spec.PlaybackSpeed or spec.Speed) or 1, 0.1, 4),
}
end
local function assetId(id)
if id == "" then
return ""
end
if string.match(id, "^rbxassetid://") or string.match(id, "^https?://") then
return id
end
if tonumber(id) then
return "rbxassetid://" .. id
end
return id
end
function Sound.new(window, options)
local self = setmetatable({
_window = window,
_enabled = options.SoundEnabled ~= false,
_volume = math.clamp(tonumber(options.SoundVolume) or 1, 0, 1),
_sounds = {},
_janitor = Janitor.new("Sound"),
}, Sound)
for name, spec in options.Sounds or {} do
self:Register(name, spec)
end
return self
end
function Sound:Register(name, spec)
if type(name) ~= "string" or name == "" then
error("[BobloUI] Sound:Register requires a non-empty name.", 2)
end
local normalized = normalize(spec)
if not normalized or normalized.Id == "" then
error(`[BobloUI] Sound:Register "{name}" requires Id/SoundId.`, 2)
end
self._sounds[name] = normalized
return self
end
function Sound:Unregister(name)
self._sounds[name] = nil
return self
end
function Sound:SetEnabled(enabled)
self._enabled = enabled ~= false
return self
end
function Sound:IsEnabled()
return self._enabled
end
function Sound:SetVolume(volume)
self._volume = math.clamp(tonumber(volume) or 1, 0, 1)
return self
end
function Sound:GetVolume()
return self._volume
end
function Sound:Play(name, override)
if not self._enabled then
return nil
end
local base = self._sounds[name]
if
not base
and (
type(name) == "number"
or (
type(name) == "string"
and (
tonumber(name) ~= nil
or string.match(name, "^rbxassetid://") ~= nil
or string.match(name, "^https?://") ~= nil
)
)
)
then
base = normalize(name)
end
if not base then
return nil
end
local spec = { Id = base.Id, Volume = base.Volume, PlaybackSpeed = base.PlaybackSpeed }
if type(override) == "table" then
if override.Volume ~= nil then
spec.Volume = math.clamp(tonumber(override.Volume) or spec.Volume, 0, 10)
end
if override.PlaybackSpeed ~= nil then
spec.PlaybackSpeed = math.clamp(tonumber(override.PlaybackSpeed) or spec.PlaybackSpeed, 0.1, 4)
end
end
local s = Instance.new("Sound")
s.Name = "BobloUI_" .. name
s.SoundId = assetId(spec.Id)
s.Volume = spec.Volume * self._volume
s.PlaybackSpeed = spec.PlaybackSpeed
s.Parent = SoundService
local conn
conn = s.Ended:Connect(function()
if conn then
conn:Disconnect()
conn = nil
end
if s.Parent then
s:Destroy()
end
end)
self._janitor:Add(s)
local ok = pcall(function()
s:Play()
end)
if not ok then
s:Destroy()
return nil
end
task.delay(12, function()
if s.Parent and not s.IsPlaying then
s:Destroy()
end
end)
return s
end
function Sound:Destroy()
self._sounds = {}
self._janitor:Destroy()
end
return Sound
end

__modules["services/Storage"] = function()
local Env = __require("runtime/Env")
local Storage = {}
Storage.__index = Storage
local MEMORY = {}
local function ensure(path)
if not Env.FS then
return
end
local acc = ""
for part in string.gmatch(path, "[^/]+") do
acc = if acc == "" then part else acc .. "/" .. part
if not Env.FS.IsFolder(acc) then
Env.FS.MakeFolder(acc)
end
end
end
function Storage.new(folder)
local root = `BobloUI/{folder or "Default"}`
ensure(root)
return setmetatable({ Root = root, Memory = not Env.FS }, Storage)
end
function Storage:_path(name)
return self.Root .. "/" .. name
end
function Storage:Read(name)
local p = self:_path(name)
if Env.FS then
return Env.FS.Read(p)
end
return MEMORY[p]
end
function Storage:Write(name, data)
local p = self:_path(name)
if Env.FS then
ensure(self.Root)
return Env.FS.Write(p, data)
end
MEMORY[p] = data
return true
end
function Storage:Delete(name)
local p = self:_path(name)
if Env.FS then
return Env.FS.Delete(p)
end
MEMORY[p] = nil
return true
end
function Storage:Exists(name)
local p = self:_path(name)
return Env.FS and Env.FS.IsFile(p) or MEMORY[p] ~= nil
end
function Storage:List()
local out = {}
if Env.FS then
for _, p in Env.FS.List(self.Root) do
local n = string.match(p, "([^/\\]+)$")
if n then
table.insert(out, n)
end
end
else
local prefix = self.Root .. "/"
for p in MEMORY do
if string.sub(p, 1, #prefix) == prefix then
table.insert(out, string.sub(p, #prefix + 1))
end
end
end
table.sort(out)
return out
end
return Storage
end

__modules["services/ThemeManager"] = function()
local HttpService = game:GetService("HttpService")
local Storage = __require("services/Storage")
local ThemeManager = {}
ThemeManager.__index = ThemeManager
local REQUIRED_COLOR_TOKENS = {
"Canvas",
"Background",
"Sidebar",
"Surface",
"SurfaceRaised",
"SurfaceInset",
"SurfaceSecondary",
"SurfaceHover",
"SurfaceActive",
"Control",
"ControlHover",
"ControlPressed",
"ControlInset",
"BorderSubtle",
"Border",
"BorderStrong",
"Text",
"TextSecondary",
"TextTertiary",
"TextDisabled",
"Accent",
"Success",
"Warning",
"Error",
"Info",
"Scrim",
}
local BASE_TOKEN_SET = { ScrimTransparency = true }
for _, token in REQUIRED_COLOR_TOKENS do
BASE_TOKEN_SET[token] = true
end
local function validName(name)
return type(name) == "string" and name ~= "" and string.match(name, "^[A-Za-z0-9_.%-]+$") ~= nil
end
local function encodePalette(palette)
local out = {}
for token, value in palette or {} do
if BASE_TOKEN_SET[token] and typeof(value) == "Color3" then
out[token] = "#" .. value:ToHex()
elseif token == "ScrimTransparency" and type(value) == "number" then
out[token] = value
elseif (token == "Appearance" or token == "Pair") and type(value) == "string" then
out[token] = value
end
end
return out
end
local function decodePalette(palette)
local out = {}
for token, value in palette or {} do
if BASE_TOKEN_SET[token] and type(value) == "string" then
local ok, color = pcall(Color3.fromHex, string.gsub(value, "#", ""))
if ok then
out[token] = color
end
elseif token == "ScrimTransparency" and type(value) == "number" then
out[token] = value
elseif (token == "Appearance" or token == "Pair") and type(value) == "string" then
out[token] = value
end
end
if out.ScrimTransparency == nil then
out.ScrimTransparency = 0.52
end
return out
end
local function validatePalette(palette)
if type(palette) ~= "table" then
return false, "palette must be a table"
end
for _, token in REQUIRED_COLOR_TOKENS do
if typeof(palette[token]) ~= "Color3" then
return false, `palette token "{token}" must be Color3`
end
end
if palette.ScrimTransparency == nil then
palette.ScrimTransparency = 0.52
elseif type(palette.ScrimTransparency) ~= "number" then
return false, 'palette token "ScrimTransparency" must be number'
end
palette.ScrimTransparency = math.clamp(palette.ScrimTransparency, 0, 1)
if palette.Appearance ~= nil and palette.Appearance ~= "Dark" and palette.Appearance ~= "Light" then
return false, 'palette token "Appearance" must be "Dark" or "Light"'
end
if palette.Pair ~= nil and type(palette.Pair) ~= "string" then
return false, 'palette token "Pair" must be a string'
end
return true
end
function ThemeManager.new(window, folder)
local self = setmetatable({
_window = window,
_storage = Storage.new((folder or window.Id or "Default") .. "/themes"),
_custom = {},
_default = nil,
}, ThemeManager)
self:ReloadCustomThemes()
self:_loadDefaultMarker()
self:_loadAppearanceMarker()
self:_watchTheme()
return self
end
function ThemeManager:_loadAppearanceMarker()
local raw = self._storage:Read("appearance.json")
if type(raw) ~= "string" or raw == "" then
return self
end
local ok, data = pcall(HttpService.JSONDecode, HttpService, raw)
if not ok or type(data) ~= "table" then
return self
end
local theme = self._window.Theme
for _, polarity in { "Dark", "Light" } do
if type(data[polarity]) == "string" then
theme:RememberPolarity(polarity, data[polarity])
end
end
return self
end
function ThemeManager:_saveAppearanceMarker()
local recent = self._window.Theme:RecentByPolarity()
local ok, raw = pcall(HttpService.JSONEncode, HttpService, recent)
if ok then
self._storage:Write("appearance.json", raw)
end
return self
end
function ThemeManager:_watchTheme()
local theme = self._window.Theme
if theme and theme.Changed then
self._appearanceConn = theme.Changed:Connect(function()
self:_saveAppearanceMarker()
end)
end
return self
end
function ThemeManager:_loadDefaultMarker()
local default = self._storage:Read("default.txt")
if default == "Dark" or default == "Light" or self._custom[default] then
self._default = default
elseif default and default ~= "" then
self._storage:Write("default.txt", "")
end
return self._default
end
function ThemeManager:_file(name)
return name .. ".json"
end
function ThemeManager:_refreshSettings()
local settings = self._window.Settings
if settings and settings.RefreshThemeOptions then
settings:RefreshThemeOptions()
end
end
function ThemeManager:SetFolder(folder)
if type(folder) ~= "string" or folder == "" then
return false, "theme folder must be a non-empty string"
end
self._storage = Storage.new(folder .. "/themes")
self._default = nil
self:ReloadCustomThemes()
self:_loadDefaultMarker()
self:_loadAppearanceMarker()
return true
end
function ThemeManager:SaveCustomTheme(name, palette)
if not validName(name) then
return false, "theme name may contain only A-Z, a-z, 0-9, _, ., -"
end
if name == "Dark" or name == "Light" then
return false, "built-in themes cannot be overwritten"
end
palette = palette or self._window.Theme:Palette()
local valid, validationError = validatePalette(palette)
if not valid then
return false, validationError
end
local payload = { Name = name, Palette = encodePalette(palette), SavedAt = os.time() }
local ok, raw = pcall(HttpService.JSONEncode, HttpService, payload)
if not ok then
return false, raw
end
if not self._storage:Write(self:_file(name), raw) then
return false, "write failed"
end
local decoded = decodePalette(payload.Palette)
self._custom[name] = decoded
self._window.Theme:Register(name, decoded)
self:_refreshSettings()
return true
end
function ThemeManager:DeleteCustomTheme(name)
if not self._custom[name] then
return false, "theme not found"
end
if self._window.Theme:Current() == name then
local polarity = self._window.Theme:Polarity(name)
self._window.Theme:Set(if polarity == "Light" then "Light" else "Dark")
end
if not self._storage:Delete(self:_file(name)) then
return false, "delete failed"
end
self._custom[name] = nil
self._window.Theme:Unregister(name)
if self._default == name then
self:SetDefault(nil)
end
self:_refreshSettings()
return true
end
function ThemeManager:ReloadCustomThemes()
local previous = self._custom
local active = self._window.Theme:Current()
for name in previous do
if self._window.Theme:Current() ~= name then
pcall(function()
self._window.Theme:Unregister(name)
end)
end
end
self._custom = {}
for _, path in self._storage:List() do
local name = string.match(path, "([^/\\]+)%.json$")
if name then
local raw = self._storage:Read(self:_file(name))
local ok, data = pcall(HttpService.JSONDecode, HttpService, raw or "")
if ok and type(data) == "table" and type(data.Palette) == "table" then
local palette = decodePalette(data.Palette)
if validatePalette(palette) then
self._custom[name] = palette
self._window.Theme:Register(name, palette)
end
end
end
end
if previous[active] and not self._custom[active] then
self._window.Theme:Set("Dark")
self._window.Theme:Unregister(active)
if self._default == active then
self:SetDefault(nil)
end
end
self:_refreshSettings()
return self:ListCustomThemes()
end
function ThemeManager:ListCustomThemes()
local out = {}
for name in self._custom do
table.insert(out, name)
end
table.sort(out)
return out
end
function ThemeManager:Load(name)
if name ~= "Dark" and name ~= "Light" and not self._custom[name] then
return false, "theme not found"
end
self._window.Theme:Set(name)
return true
end
function ThemeManager:ApplyTheme(name)
return self:Load(name)
end
function ThemeManager:GetCustomTheme(name)
local palette = self._custom[name]
return palette and table.clone(palette) or nil
end
function ThemeManager:SetDefault(name)
if name ~= nil and name ~= "Dark" and name ~= "Light" and not self._custom[name] then
return false, "theme not found"
end
if not self._storage:Write("default.txt", name or "") then
return false, "write failed"
end
self._default = name
return true
end
function ThemeManager:SaveDefault(name)
return self:SetDefault(name)
end
function ThemeManager:GetDefault()
return self._default
end
function ThemeManager:LoadDefault()
if not self._default then
return false, "no default theme"
end
if not self._window.Theme:GetRegistered(self._default) then
self:SetDefault(nil)
return false, "default theme is no longer available"
end
self._window.Theme:Set(self._default)
return true
end
function ThemeManager:Destroy()
if self._appearanceConn then
self._appearanceConn:Disconnect()
self._appearanceConn = nil
end
self._custom = {}
end
return ThemeManager
end

__modules["shell/Minimal"] = function()
local Create = __require("runtime/Create")
local Icon = __require("primitives/Icon")
local Popover = __require("primitives/Popover")
local Minimal = {}
function Minimal:_buildMinimal()
self._minimalMenuButton = Create.New("TextButton", {
Name = "MinimalTabs",
Size = UDim2.fromOffset(36, 40),
Position = UDim2.new(1, -50, 0.5, 0),
AnchorPoint = Vector2.new(1, 0.5),
BackgroundTransparency = 1,
BorderSizePixel = 0,
Text = "",
AutoButtonColor = false,
Visible = false,
Parent = self._header,
})
self._minimalChevron = Icon.new(self, "chevron_down", {
Size = UDim2.fromOffset(17, 17),
Position = UDim2.fromScale(0.5, 0.5),
AnchorPoint = Vector2.new(0.5, 0.5),
Parent = self._minimalMenuButton,
})
Icon.setColor(self._minimalChevron, self.Theme:Get("TextSecondary"))
self._janitor:Add(self.Theme.Changed:Connect(function()
Icon.setColor(self._minimalChevron, self.Theme:Get("TextSecondary"))
end))
self._janitor:Add(self._minimalMenuButton.MouseButton1Click:Connect(function()
self:_openMinimalMenu()
end))
self._janitor:Add(function()
if self._minimalMenuHandle then
self._minimalMenuHandle:Dismiss()
end
end)
end
function Minimal:_refreshMinimalMenu()
if not self._minimalMenuButton then
return
end
local count = 0
for _, tab in self._tabs do
if tab._button.Visible then
count += 1
end
end
self._minimalMenuButton.Visible = count > 1
if self._minimalMenuHandle then
self._minimalMenuHandle:Dismiss()
self._minimalMenuHandle = nil
end
end
function Minimal:_openMinimalMenu()
if self._minimalMenuHandle then
self._minimalMenuHandle:Dismiss()
self._minimalMenuHandle = nil
return
end
local tabs = {}
for _, tab in self._tabs do
if tab._button.Visible then
table.insert(tabs, tab)
end
end
if #tabs < 2 then
return
end
local height = math.min(#tabs * 44 + 8, 264)
local handle = Popover.open(self, self._minimalMenuButton, Vector2.new(220, height), {
OnDismiss = function()
self._minimalMenuHandle = nil
end,
})
self._minimalMenuHandle = handle
local list = Create.New("ScrollingFrame", {
Name = "MinimalTabList",
Size = UDim2.fromScale(1, 1),
BackgroundTransparency = 1,
BorderSizePixel = 0,
ScrollBarThickness = 3,
ScrollingDirection = Enum.ScrollingDirection.Y,
CanvasSize = UDim2.new(),
AutomaticCanvasSize = Enum.AutomaticSize.Y,
Parent = handle.Frame,
})
Create.New("UIPadding", {
PaddingTop = UDim.new(0, 4),
PaddingBottom = UDim.new(0, 4),
PaddingLeft = UDim.new(0, 4),
PaddingRight = UDim.new(0, 4),
Parent = list,
})
Create.List(0).Parent = list
for index, tab in tabs do
local label = self.Locale:Resolve(tab.Title)
if tab.Locked then
label = label .. "  · locked"
end
local item = Create.New("TextButton", {
Name = `Tab_{tab.Id}`,
Size = UDim2.new(1, 0, 0, 44),
LayoutOrder = index,
BackgroundTransparency = if tab == self._active then 0.7 else 1,
BorderSizePixel = 0,
AutoButtonColor = false,
Text = "  " .. label,
TextXAlignment = Enum.TextXAlignment.Left,
TextSize = self.Tokens:Get("FontBody"),
Font = self.Fonts.Medium,
Parent = list,
})
Create.New("UICorner", { CornerRadius = UDim.new(0, 7), Parent = item })
self:_bind(item, {
BackgroundColor3 = "AccentSoft",
TextColor3 = if tab.Locked then "TextTertiary" else "Text",
})
item.MouseButton1Click:Connect(function()
handle:Dismiss()
tab:Select()
end)
end
end
function Minimal:_applyMinimalLayout()
self._navToggle.Visible = false
self._navPanel.Visible = false
self._sidebarButton.Visible = false
self._searchButton.Visible = false
self._themeButton.Visible = false
self._minimizeButton.Visible = false
self._subtitleLabel.Visible = false
self._topbarExtras.Visible = false
self._footer.Visible = false
self._grip.Visible = false
self._content.Size = UDim2.fromScale(1, 1)
self._content.Position = UDim2.new()
self:_applyMinimalTokens()
self:_applyGeometry()
self:_refreshMinimalMenu()
end
function Minimal:_applyMinimalTokens()
local headerHeight = self.Tokens:Get("HeaderHeight")
self._header.Size = UDim2.new(1, 0, 0, headerHeight)
self._body.Size = UDim2.new(1, 0, 1, -headerHeight)
self._body.Position = UDim2.fromOffset(0, headerHeight)
self._rootStroke.Thickness = self.Tokens:Get("Stroke")
self._titleLabel.TextSize = self.Tokens:Get("FontTitle")
self._titleLabel.Position = UDim2.fromOffset(52, 0)
self._titleLabel.Size = UDim2.new(1, -148, 1, 0)
self:_applyCornerRadius()
for _, tab in self._tabs do
tab:_applyTokens()
end
self:_scheduleSectionLayouts()
end
function Minimal:_syncMinimalHeight()
if not self._minimal or self._destroying then
return
end
local _, safeSize = self.Device:SafeArea()
local scale = math.max(0.01, self._scale or 1)
local maxHeight = math.max(88, safeSize.Y / scale - 16)
if self._size.Y.Offset > 0 then
maxHeight = math.min(maxHeight, math.max(88, self._size.Y.Offset))
else
maxHeight = math.min(maxHeight, math.max(220, safeSize.Y / scale * 0.72))
end
local contentHeight = 54
if self._active and self._active._sectionHost then
contentHeight = math.max(contentHeight, self._active._sectionHost.Size.Y.Offset + 16)
end
local height = math.clamp(self.Tokens:Get("HeaderHeight") + contentHeight, 88, maxHeight)
if math.abs(self._root.Size.Y.Offset - height) >= 1 then
self._root.Size = UDim2.fromOffset(self._root.Size.X.Offset, height)
end
end
return Minimal
end

__modules["shell/Row"] = function()
local Create = __require("runtime/Create")
local Janitor = __require("runtime/Janitor")
local Dependency = __require("runtime/Dependency")
local Button = __require("controls/Button")
local Toggle = __require("controls/Toggle")
local Slider = __require("controls/Slider")
local Dropdown = __require("controls/Dropdown")
local TextField = __require("controls/TextField")
local Keybind = __require("controls/Keybind")
local ColorPicker = __require("controls/ColorPicker")
local Paragraph = __require("controls/Paragraph")
local Divider = __require("controls/Divider")
local Status = __require("controls/Status")
local Progress = __require("controls/Progress")
local Code = __require("controls/Code")
local Image = __require("controls/Image")
local Passthrough = __require("controls/Passthrough")
local Viewport = __require("controls/Viewport")
local Video = __require("controls/Video")
local Row = {}
Row.__index = Row
function Row.new(section, options)
options = options or {}
if options.Id then
section._window.Registry:AssertAvailable(options.Id, 3)
end
local self = setmetatable({
_section = section,
_window = section._window,
_tab = section._tab,
_janitor = Janitor.new("Row"),
_controls = {},
_cells = {},
_mounted = false,
_destroyed = false,
Columns = math.clamp(tonumber(options.Columns) or 2, 1, 4),
Gap = tonumber(options.Gap) or section._window.Tokens:Get("ColumnGap"),
Title = options.Title or section.Title,
Type = "Row",
Id = options.Id,
_manualVisible = options.Visible ~= false,
_dependencyVisible = true,
_manualEnabled = not (options.Disabled == true or type(options.Disabled) == "string"),
_dependencyEnabled = true,
_parentEnabled = true,
}, Row)
section._janitor:Add(self, "Destroy", self)
if self.Id then
self._window.Registry:Add(self, {
Id = self.Id,
Type = "Row",
Title = self.Title or "Row",
Tab = self._tab.Id,
Section = section.Title,
Path = `{self._tab.Title} -> {section.Title or "Default"}`,
Persist = false,
})
end
section:_registerControl(self)
Dependency.Bind(self, options.VisibleWhen, "visible")
Dependency.Bind(self, options.EnabledWhen, "enabled")
if section._mounted then
self:_mount()
end
return self
end
function Row:_mount()
if self._mounted then
return
end
self._mounted = true
self._root = Create.New("Frame", {
Name = "ControlRow",
Size = UDim2.new(1, 0, 0, 0),
AutomaticSize = Enum.AutomaticSize.Y,
BackgroundTransparency = 1,
LayoutOrder = 0,
Visible = self:IsVisible(),
Parent = self._section:_controlParent(self),
})
self._janitor:Add(self._root)
self._layout = Create.List(self.Gap, Enum.FillDirection.Horizontal)
self._layout.VerticalAlignment = Enum.VerticalAlignment.Top
self._layout.Parent = self._root
for _, control in self._controls do
control:_mount()
end
self:_applyContainerState()
end
function Row:_newCell()
local index = #self._cells + 1
if index > self.Columns then
error(`[BobloUI] Row supports at most {self.Columns} controls. Create another row or increase Columns.`, 3)
end
local gap = self.Gap
local width = 1 / self.Columns
local offset = -gap * (self.Columns - 1) / self.Columns
local cell = Create.New("Frame", {
Name = "Cell" .. index,
Size = UDim2.new(width, offset, 0, 0),
AutomaticSize = Enum.AutomaticSize.Y,
BackgroundTransparency = 1,
LayoutOrder = index,
Parent = self._root,
})
table.insert(self._cells, cell)
return cell
end
function Row:_controlParent(control)
if control._rowCell and control._rowCell.Parent then
return control._rowCell
end
local cell = self:_newCell()
control._rowCell = cell
return cell
end
function Row:_registerControl(control)
table.insert(self._controls, control)
if control._setContainerEnabled then
control:_setContainerEnabled(self:IsEnabled())
end
if self._mounted then
control:_mount()
end
end
function Row:_removeControl(control)
local p = table.find(self._controls, control)
if p then
table.remove(self._controls, p)
end
if control._rowCell then
local c = control._rowCell
control._rowCell = nil
local cp = table.find(self._cells, c)
if cp then
table.remove(self._cells, cp)
end
c:Destroy()
end
end
function Row:_refreshSeparators()
for _, c in self._controls do
if c._separator then
c._separator.Visible = false
end
end
end
function Row:SetCollapsed()
return self
end
function Row:AddButton(o)
return Button.new(self, o)
end
function Row:AddToggle(o)
return Toggle.new(self, o)
end
function Row:AddSlider(o)
return Slider.new(self, o)
end
function Row:AddDropdown(o)
return Dropdown.new(self, o)
end
function Row:AddInput(o)
return TextField.new(self, o)
end
function Row:AddKeybind(o)
return Keybind.new(self, o)
end
function Row:AddColorPicker(o)
return ColorPicker.new(self, o)
end
function Row:AddParagraph(o)
return Paragraph.new(self, o)
end
function Row:AddDivider(o)
return Divider.new(self, o or {})
end
function Row:AddStatus(o)
return Status.new(self, o)
end
function Row:AddProgress(o)
return Progress.new(self, o)
end
function Row:AddCode(o)
return Code.new(self, o)
end
function Row:AddImage(o)
return Image.new(self, o)
end
function Row:AddPassthrough(o)
return Passthrough.new(self, o)
end
function Row:AddViewport(o)
return Viewport.new(self, o)
end
function Row:AddVideo(o)
return Video.new(self, o)
end
function Row:SetVisible(visible)
self._manualVisible = visible == true
self:_applyContainerState()
return self
end
function Row:IsVisible()
return self._manualVisible and self._dependencyVisible
end
function Row:SetEnabled(enabled)
self._manualEnabled = enabled ~= false
self:_applyContainerState()
return self
end
function Row:IsEnabled()
return self._parentEnabled and self._manualEnabled and self._dependencyEnabled
end
function Row:_setContainerEnabled(enabled)
self._parentEnabled = enabled ~= false
self:_applyContainerState()
return self
end
function Row:_applyContainerState()
if self._root then
self._root.Visible = self:IsVisible()
end
local enabled = self:IsEnabled()
for _, control in self._controls do
if control._setContainerEnabled then
control:_setContainerEnabled(enabled)
end
end
if self._section and self._section._refreshSeparators then
self._section:_refreshSeparators()
end
end
function Row:Reset()
for _, c in self._controls do
if c.Reset then
c:Reset()
end
end
return self
end
function Row:Destroy()
if self._destroyed then
return
end
self._destroyed = true
self._section._janitor:Release(self)
for _, c in table.clone(self._controls) do
c:Destroy()
end
self._janitor:Destroy()
self._window.Registry:Remove(self)
self._section:_removeControl(self)
end
return Row
end

__modules["shell/Section"] = function()
local Create = __require("runtime/Create")
local Janitor = __require("runtime/Janitor")
local Dependency = __require("runtime/Dependency")
local Surface = __require("primitives/Surface")
local Icon = __require("primitives/Icon")
local Button = __require("controls/Button")
local Toggle = __require("controls/Toggle")
local Slider = __require("controls/Slider")
local Dropdown = __require("controls/Dropdown")
local TextField = __require("controls/TextField")
local Keybind = __require("controls/Keybind")
local ColorPicker = __require("controls/ColorPicker")
local Paragraph = __require("controls/Paragraph")
local Divider = __require("controls/Divider")
local Status = __require("controls/Status")
local Progress = __require("controls/Progress")
local Code = __require("controls/Code")
local Image = __require("controls/Image")
local Passthrough = __require("controls/Passthrough")
local Viewport = __require("controls/Viewport")
local Video = __require("controls/Video")
local Row = __require("shell/Row")
local TabBox = __require("shell/TabBox")
local Section = {}
Section.__index = Section
function Section.new(tab, options)
options = options or {}
if options.Id then
tab._window.Registry:AssertAvailable(options.Id, 3)
end
local order = #tab._sections + 1
local column = options.Column == 2 and 2 or 1
local span = options.Span or "Auto"
if span ~= "Auto" and span ~= 1 and span ~= 2 then
error("[BobloUI] Section Span must be 'Auto', 1, or 2.", 3)
end
local layout = options.Layout or "Stack"
if layout ~= "Stack" and layout ~= "Grid" and layout ~= "Auto" then
error("[BobloUI] Section Layout must be 'Stack', 'Grid', or 'Auto'.", 3)
end
local self = setmetatable({
Id = options.Id,
Title = options.Title,
Description = options.Description,
Icon = options.Icon or "layers",
Collapsible = options.Collapsible == true,
Collapsed = options.Collapsed == true,
Column = column,
Span = span,
Layout = layout,
_columnExplicit = options.Column ~= nil,
_effectiveContentLayout = nil,
_order = order,
_implicit = options._implicit == true,
_tab = tab,
_window = tab._window,
_janitor = Janitor.new(`Section[{options.Title or "Default"}]`),
_controls = {},
_mounted = false,
_manualVisible = options.Visible ~= false,
_dependencyVisible = true,
_manualEnabled = not (options.Disabled == true or type(options.Disabled) == "string"),
_dependencyEnabled = true,
_parentEnabled = true,
}, Section)
tab._janitor:Add(self, "Destroy", self)
table.insert(tab._sections, self)
if self.Id then
self._window.Registry:Add(self, {
Id = self.Id,
Type = "Section",
Title = self.Title or "Section",
Tab = tab.Id,
Path = tab.Title,
Persist = false,
})
end
self._janitor:Add(self._window.Tokens.Changed:Connect(function()
if self._mounted then
self:_applyTokens()
end
end))
self._janitor:Add(self._window.Theme.Changed:Connect(function()
if self._sectionIcon then
Icon.setColor(self._sectionIcon, self._window.Theme:Get("Accent"))
end
end))
Dependency.Bind(self, options.VisibleWhen, "visible")
Dependency.Bind(self, options.EnabledWhen, "enabled")
if tab._mounted then
self:_mount()
end
tab:_scheduleSectionLayout()
return self
end
function Section:_mount()
if self._mounted then
return
end
self._mounted = true
local w = self._window
local t = w.Tokens
self._root = Surface.new(w, {
Name = "Section",
Size = UDim2.new(1, 0, 0, 0),
AutomaticSize = Enum.AutomaticSize.Y,
BorderSizePixel = 0,
LayoutOrder = self._order,
Visible = self._manualVisible and self._dependencyVisible,
Parent = self._tab:_sectionParent(self.Column),
}, {
Token = if self._implicit or w._minimal then "Canvas" else "Surface",
Stroke = not self._implicit and not w._minimal,
StrokeToken = "Border",
StrokeTransparency = 0.3,
Corner = if self._implicit or w._minimal then 0 else t:Get("CornerMd"),
Sheen = false,
})
self._janitor:Add(self._root)
if w._minimal then
self._root.BackgroundTransparency = 1
end
self._janitor:Add(self._root:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
if not self._destroyed then
self:_updateContentLayout()
self:_updateAdaptiveControls()
self._tab:_scheduleSectionLayout()
end
end))
local pad = if self._implicit then 0 else t:Get("SectionPadding")
self._padding = Create.New("UIPadding", {
PaddingTop = UDim.new(0, pad),
PaddingBottom = UDim.new(0, pad),
PaddingLeft = UDim.new(0, pad),
PaddingRight = UDim.new(0, pad),
Parent = self._root,
})
self._rootLayout = Create.List(if self._implicit then t:Get("RowGap") elseif w._minimal then 6 else 12)
self._rootLayout.Parent = self._root
if not self._implicit and self.Title then
local headerClass = if self.Collapsible then "TextButton" else "Frame"
self._header = Create.New(headerClass, {
Name = "SectionHeader",
Size = UDim2.new(1, 0, 0, if w._minimal then 28 elseif self.Description then 52 else 42),
BackgroundTransparency = if w._minimal then 1 else 0.28,
BorderSizePixel = 0,
Text = headerClass == "TextButton" and "" or nil,
AutoButtonColor = headerClass == "TextButton" and false or nil,
Parent = self._root,
})
if w._minimal then
self._header.Visible = self.Collapsible
end
Create.New("UICorner", { CornerRadius = UDim.new(0, math.max(6, t:Get("CornerSm"))), Parent = self._header })
self._headerStroke = Create.New("UIStroke", {
Thickness = 1,
Transparency = 0.5,
LineJoinMode = Enum.LineJoinMode.Round,
Parent = self._header,
})
w:_bind(self._header, { BackgroundColor3 = "SurfaceRaised" })
w:_bind(self._headerStroke, { Color = "BorderSubtle" })
if w._minimal then
self._headerStroke.Enabled = false
end
self._headerAccent = Create.New("Frame", {
Name = "AccentRail",
Size = UDim2.fromOffset(3, 18),
Position = UDim2.new(0, 0, 0.5, 0),
AnchorPoint = Vector2.new(0, 0.5),
BorderSizePixel = 0,
Parent = self._header,
})
Create.New("UICorner", { CornerRadius = UDim.new(1, 0), Parent = self._headerAccent })
w:_bind(self._headerAccent, { BackgroundColor3 = "Accent" })
if w._minimal then
self._headerAccent.Visible = false
end
self._sectionIconHost = Create.New("Frame", {
Name = "IconTile",
Size = UDim2.fromOffset(28, 28),
Position = UDim2.new(0, 8, 0.5, 0),
AnchorPoint = Vector2.new(0, 0.5),
BorderSizePixel = 0,
Parent = self._header,
})
Create.New("UICorner", { CornerRadius = UDim.new(0, 8), Parent = self._sectionIconHost })
local iconStroke =
Create.New("UIStroke", { Thickness = 1, Transparency = 0.62, Parent = self._sectionIconHost })
w:_bind(self._sectionIconHost, { BackgroundColor3 = "AccentSoft" })
w:_bind(iconStroke, { Color = "AccentBorder" })
self._sectionIcon = Icon.new(w, self.Icon, {
Size = UDim2.fromOffset(15, 15),
Position = UDim2.fromScale(0.5, 0.5),
AnchorPoint = Vector2.new(0.5, 0.5),
Parent = self._sectionIconHost,
})
Icon.setColor(self._sectionIcon, w.Theme:Get("Accent"))
if w._minimal then
self._sectionIconHost.Visible = false
end
self._title = Create.New("TextLabel", {
Size = UDim2.new(1, if self.Collapsible then -82 else -50, 0, if self.Description then 20 else 42),
Position = UDim2.fromOffset(44, if self.Description then 5 else 0),
BackgroundTransparency = 1,
Font = w.Fonts.Medium,
TextSize = t:Get("FontTitle"),
TextXAlignment = Enum.TextXAlignment.Left,
Text = w.Locale:Resolve(self.Title),
Parent = self._header,
})
w:_bind(self._title, { TextColor3 = "Text" })
if w._minimal then
self._title.Position = UDim2.fromOffset(4, 0)
self._title.Size = UDim2.new(1, if self.Collapsible then -38 else -4, 1, 0)
self._title.TextSize = t:Get("FontSmall")
end
if self.Description then
self._desc = Create.New("TextLabel", {
Size = UDim2.new(1, if self.Collapsible then -82 else -50, 0, 16),
Position = UDim2.fromOffset(44, 27),
BackgroundTransparency = 1,
Font = w.Fonts.Regular,
TextSize = t:Get("FontSmall"),
TextXAlignment = Enum.TextXAlignment.Left,
TextTruncate = Enum.TextTruncate.AtEnd,
Text = w.Locale:Resolve(self.Description),
Parent = self._header,
})
w:_bind(self._desc, { TextColor3 = "TextTertiary" })
if w._minimal then
self._desc.Visible = false
end
end
if self.Collapsible then
self._chevronBack = Create.New("Frame", {
Name = "ChevronTile",
Size = UDim2.fromOffset(26, 26),
Position = UDim2.new(1, -7, 0.5, 0),
AnchorPoint = Vector2.new(1, 0.5),
BorderSizePixel = 0,
BackgroundTransparency = 0.32,
Parent = self._header,
})
Create.New("UICorner", { CornerRadius = UDim.new(0, 7), Parent = self._chevronBack })
w:_bind(self._chevronBack, { BackgroundColor3 = "ControlHover" })
self._chevron = Icon.new(w, "chevron_down", {
Size = UDim2.fromOffset(15, 15),
Position = UDim2.fromScale(0.5, 0.5),
AnchorPoint = Vector2.new(0.5, 0.5),
Parent = self._chevronBack,
})
self._chevron.Rotation = if self.Collapsed then -90 else 0
self._janitor:Add(self._header.MouseEnter:Connect(function()
w.Motion:Tween(self._header, "Fast", { BackgroundTransparency = 0.12 })
w.Motion:Tween(self._headerStroke, "Fast", { Transparency = 0.46 })
end))
self._janitor:Add(self._header.MouseLeave:Connect(function()
w.Motion:Tween(self._header, "Fast", { BackgroundTransparency = 0.28 })
w.Motion:Tween(self._headerStroke, "Fast", { Transparency = 0.7 })
end))
self._janitor:Add(self._header.MouseButton1Click:Connect(function()
self:SetCollapsed(not self.Collapsed)
end))
end
end
self._content = Create.New("Frame", {
Name = "Controls",
Size = UDim2.new(1, 0, 0, 0),
AutomaticSize = Enum.AutomaticSize.Y,
BackgroundTransparency = 1,
Visible = not self.Collapsed,
Parent = self._root,
})
self:_updateContentLayout(true)
for _, control in self._controls do
control:_mount()
end
self:_reparentControls()
self:_applyContainerState()
end
function Section:_applyMinimalHeader(multiple)
if not self._header then
return
end
local shown = multiple or self.Collapsible
if self._header.Visible ~= shown then
self._header.Visible = shown
end
end
function Section:_wantedContentLayout()
if self._window._minimal then
return "Stack"
end
if self.Layout == "Stack" or self.Layout == "Grid" then
return self.Layout
end
if not self._root then
return "Stack"
end
local scale = math.max(0.01, self._window._scale or 1)
return (self._root.AbsoluteSize.X / scale) >= self._window.Tokens:Get("ControlGridMinWidth") and "Grid" or "Stack"
end
function Section:_measureControlLayout()
if not self._root or self._root.AbsoluteSize.X <= 0 then
return "Inline"
end
local scale = math.max(0.01, self._window._scale or 1)
local width = self._root.AbsoluteSize.X / scale
if not self._implicit then
width -= self._window.Tokens:Get("SectionPadding") * 2
end
if self._effectiveContentLayout == "Grid" then
width = (width - self._window.Tokens:Get("ColumnGap")) / 2
end
return width < self._window.Tokens:Get("ControlStackBreakpoint") and "Stacked" or "Inline"
end
function Section:_controlLayout()
return self._adaptiveControlLayout or "Inline"
end
function Section:_updateAdaptiveControls(force)
local layout = self:_measureControlLayout()
if not force and self._adaptiveControlLayout == layout then
return
end
self._adaptiveControlLayout = layout
for _, control in self._controls do
if control._adaptive and control._updateResponsiveLayout then
control:_updateResponsiveLayout()
end
end
end
function Section:_destroyGridColumns()
for _, col in self._gridColumns or {} do
if col and col.Parent then
col:Destroy()
end
end
self._gridColumns = nil
self._gridLayouts = nil
end
function Section:_buildGridColumns()
if self._gridColumns then
return
end
local gap = self._window.Tokens:Get("ColumnGap")
self._gridColumns = {}
self._gridLayouts = {}
for i = 1, 2 do
local col = Create.New("Frame", {
Name = "ControlColumn" .. i,
Size = UDim2.new(0.5, -gap / 2, 0, 0),
AutomaticSize = Enum.AutomaticSize.Y,
Position = if i == 1 then UDim2.new(0, 0, 0, 0) else UDim2.new(0.5, gap / 2, 0, 0),
BackgroundTransparency = 1,
Parent = self._content,
})
local layout = Create.List(self._window.Tokens:Get("RowGap"))
layout.Parent = col
self._gridColumns[i] = col
self._gridLayouts[i] = layout
end
end
function Section:_reparentControls()
if not self._content then
return
end
if self._effectiveContentLayout == "Grid" then
self:_buildGridColumns()
local visibleIndex = 0
for _, control in self._controls do
if control._root then
visibleIndex += 1
control._root.Parent = self._gridColumns[((visibleIndex - 1) % 2) + 1]
end
end
else
for _, control in self._controls do
if control._root then
control._root.Parent = self._content
end
end
end
self:_refreshSeparators()
end
function Section:_updateContentLayout(force)
if not self._content then
return
end
local wanted = self:_wantedContentLayout()
if not force and self._effectiveContentLayout == wanted then
self:_updateAdaptiveControls()
return
end
for _, control in self._controls do
if control._root then
control._root.Parent = self._content
end
end
if self._contentLayout then
self._contentLayout:Destroy()
self._contentLayout = nil
end
self:_destroyGridColumns()
self._effectiveContentLayout = wanted
if wanted == "Grid" then
self:_buildGridColumns()
else
self._contentLayout = Create.List(self._window.Tokens:Get("RowGap"))
self._contentLayout.Parent = self._content
end
self:_reparentControls()
self:_updateAdaptiveControls(true)
end
function Section:_controlParent(control)
if not self._content then
return nil
end
if self._effectiveContentLayout == "Grid" then
self:_buildGridColumns()
local index = table.find(self._controls, control) or #self._controls
return self._gridColumns[((math.max(1, index) - 1) % 2) + 1]
end
return self._content
end
function Section:_applyTokens()
if not self._mounted then
return
end
local t = self._window.Tokens
local pad = if self._implicit then 0 else t:Get("SectionPadding")
local u = UDim.new(0, pad)
if self._padding then
self._padding.PaddingTop = u
self._padding.PaddingBottom = u
self._padding.PaddingLeft = u
self._padding.PaddingRight = u
end
if self._rootLayout then
self._rootLayout.Padding =
UDim.new(0, if self._implicit then t:Get("RowGap") elseif self._window._minimal then 6 else 12)
end
if self._contentLayout then
self._contentLayout.Padding = UDim.new(0, t:Get("RowGap"))
end
for _, layout in self._gridLayouts or {} do
layout.Padding = UDim.new(0, t:Get("RowGap"))
end
self:_updateContentLayout()
self:_updateAdaptiveControls(true)
if self._title then
self._title.TextSize = t:Get(if self._window._minimal then "FontSmall" else "FontTitle")
end
if self._desc then
self._desc.TextSize = t:Get("FontSmall")
end
if self._header then
self._header.Size = UDim2.new(1, 0, 0, if self._window._minimal then 28 elseif self.Description then 52 else 42)
end
end
function Section:_refreshSeparators()
local groups = {}
for _, control in self._controls do
if control._separator and control._root and control._root.Visible then
local parent = control._root.Parent
groups[parent] = groups[parent] or {}
table.insert(groups[parent], control)
end
end
for _, visible in groups do
for i, control in visible do
control._separator.Visible = i < #visible
end
end
end
function Section:_registerControl(c)
table.insert(self._controls, c)
if c._setContainerEnabled then
c:_setContainerEnabled(self:IsEnabled())
end
if self._mounted then
task.defer(function()
if not self._destroyed then
self:_reparentControls()
self:_updateAdaptiveControls()
end
end)
end
end
function Section:_removeControl(c)
local p = table.find(self._controls, c)
if p then
table.remove(self._controls, p)
end
if self._mounted then
self:_reparentControls()
else
self:_refreshSeparators()
end
end
function Section:_createControl(factory, options)
options = options or {}
if options.Id then
self._window.Registry:AssertAvailable(options.Id, 3)
end
return factory.new(self, options)
end
function Section:AddCustom(name, o)
o = o or {}
if o.Id then
self._window.Registry:AssertAvailable(o.Id, 3)
end
local factory = self._window.CustomControls and self._window.CustomControls[name]
if not factory then
error(`[BobloUI] unknown custom control "{tostring(name)}".`, 2)
end
return factory(self, o)
end
function Section:AddButton(o)
return self:_createControl(Button, o)
end
function Section:AddToggle(o)
return self:_createControl(Toggle, o)
end
function Section:AddSlider(o)
return self:_createControl(Slider, o)
end
function Section:AddDropdown(o)
return self:_createControl(Dropdown, o)
end
function Section:AddInput(o)
return self:_createControl(TextField, o)
end
function Section:AddKeybind(o)
return self:_createControl(Keybind, o)
end
function Section:AddColorPicker(o)
return self:_createControl(ColorPicker, o)
end
function Section:AddParagraph(o)
return self:_createControl(Paragraph, o)
end
function Section:AddDivider(o)
return self:_createControl(Divider, o)
end
function Section:AddStatus(o)
return self:_createControl(Status, o)
end
function Section:AddProgress(o)
return self:_createControl(Progress, o)
end
function Section:AddCode(o)
return self:_createControl(Code, o)
end
function Section:AddImage(o)
return self:_createControl(Image, o)
end
function Section:AddPassthrough(o)
return self:_createControl(Passthrough, o)
end
function Section:AddViewport(o)
return self:_createControl(Viewport, o)
end
function Section:AddVideo(o)
return self:_createControl(Video, o)
end
function Section:AddRow(o)
return self:_createControl(Row, o)
end
function Section:AddTabBox(o)
return self:_createControl(TabBox, o)
end
function Section:_refreshLocale()
if self._title then
self._title.Text = self._window.Locale:Resolve(self.Title or "")
end
if self._desc then
self._desc.Text = self._window.Locale:Resolve(self.Description or "")
end
if self.Id then
self._window.Registry:Update(self, {
Title = self._window.Locale:Resolve(self.Title or "Section"),
Path = self._window.Locale:Resolve(self._tab.Title),
})
end
for _, control in self._controls do
if control._refreshText then
control:_refreshText()
end
end
end
function Section:SetTitle(t)
self.Title = t
if self._title then
self._title.Text = self._window.Locale:Resolve(t or "")
end
if self.Id then
self._window.Registry:Update(self, { Title = self._window.Locale:Resolve(t or "Section") })
end
return self
end
function Section:SetIcon(icon)
self.Icon = icon or "layers"
if self._sectionIcon then
self._sectionIcon:Destroy()
self._sectionIcon = nil
end
if self._sectionIconHost then
self._sectionIcon = Icon.new(self._window, self.Icon, {
Size = UDim2.fromOffset(15, 15),
Position = UDim2.fromScale(0.5, 0.5),
AnchorPoint = Vector2.new(0.5, 0.5),
Parent = self._sectionIconHost,
})
Icon.setColor(self._sectionIcon, self._window.Theme:Get("Accent"))
end
return self
end
function Section:SetSpan(span)
if span ~= "Auto" and span ~= 1 and span ~= 2 then
error("[BobloUI] Section:SetSpan expects 'Auto', 1, or 2.", 2)
end
self.Span = span
self._tab:_scheduleSectionLayout()
return self
end
function Section:SetLayout(layout)
if layout ~= "Stack" and layout ~= "Grid" and layout ~= "Auto" then
error("[BobloUI] Section:SetLayout expects 'Stack', 'Grid', or 'Auto'.", 2)
end
self.Layout = layout
self:_updateContentLayout(true)
return self
end
function Section:Reset()
for _, control in self._controls do
if control.Reset then
control:Reset()
end
end
return self
end
function Section:SetVisible(v)
self._manualVisible = v == true
self:_applyContainerState()
return self
end
function Section:IsVisible()
return self._manualVisible and self._dependencyVisible
end
function Section:SetEnabled(enabled)
self._manualEnabled = enabled ~= false
self:_applyContainerState()
return self
end
function Section:IsEnabled()
return self._parentEnabled and self._manualEnabled and self._dependencyEnabled
end
function Section:_setContainerEnabled(enabled)
self._parentEnabled = enabled ~= false
self:_applyContainerState()
return self
end
function Section:_applyContainerState()
local visible = self._manualVisible and self._dependencyVisible
local enabled = self._parentEnabled and self._manualEnabled and self._dependencyEnabled
if self._root then
self._root.Visible = visible
end
for _, control in self._controls do
if control._setContainerEnabled then
control:_setContainerEnabled(enabled)
end
end
if self.Id then
self._window.Registry:Update(self, { Hidden = not visible, Disabled = not enabled })
end
self._tab:_scheduleSectionLayout()
end
function Section:SetCollapsed(v)
self.Collapsed = v == true
if self._content then
self._content.Visible = not self.Collapsed
end
if self._chevron then
self._chevron.Rotation = if self.Collapsed then -90 else 0
end
self._tab:_scheduleSectionLayout()
return self
end
function Section:GetInstance()
return self._root
end
function Section:Destroy()
if self._destroyed then
return
end
self._destroyed = true
self._tab._janitor:Release(self)
if self.Id then
self._window.Registry:Remove(self)
end
local p = table.find(self._tab._sections, self)
if p then
table.remove(self._tab._sections, p)
end
for _, control in table.clone(self._controls) do
control:Destroy()
end
self._janitor:Destroy()
if not self._tab._destroyed then
self._tab:_scheduleSectionLayout()
end
end
return Section
end

__modules["shell/Tab"] = function()
local Create = __require("runtime/Create")
local Janitor = __require("runtime/Janitor")
local Util = __require("runtime/Util")
local Section = __require("shell/Section")
local Icon = __require("primitives/Icon")
local Badge = __require("primitives/Badge")
local New = Create.New
local Tab = {}
Tab.__index = Tab
function Tab.new(window, options)
local self = setmetatable({
Id = options.Id or Util.slug(options.Title),
Title = options.Title,
Description = options.Description,
Icon = options.Icon,
Badge = options.Badge,
Group = options.Group,
Locked = options.Locked == true,
LockedReason = options.LockedReason,
Order = options.Order or (#window._tabs + 1),
_window = window,
_janitor = Janitor.new(`Tab[{options.Title}]`),
_mounted = false,
_selected = false,
_sections = {},
_defaultSection = nil,
_twoColumn = false,
_layoutPending = false,
}, Tab)
window._janitor:Add(self, "Destroy", self)
local tokens = window.Tokens
local button = New("TextButton", {
Name = `Nav_{self.Id}`,
Size = UDim2.new(1, 0, 0, tokens:Get("NavItemHeight")),
BackgroundTransparency = 1,
AutoButtonColor = false,
Text = "",
LayoutOrder = window:_navLayoutOrder(self.Group, self.Order),
Visible = options.Visible ~= false,
Parent = window._navList,
})
New("UICorner", { CornerRadius = UDim.new(0, tokens:Get("CornerSm")), Parent = button })
local indicator = New("Frame", {
Name = "Indicator",
Size = UDim2.fromOffset(3, 20),
Position = UDim2.new(0, 0, 0.5, 0),
AnchorPoint = Vector2.new(0, 0.5),
BorderSizePixel = 0,
Visible = false,
Parent = button,
})
New("UICorner", { CornerRadius = UDim.new(1, 0), Parent = indicator })
window:_bind(indicator, { BackgroundColor3 = "Accent" })
self._indicator = indicator
self._janitor:Add(button)
local avatarBack = New("Frame", {
Name = "IconTile",
Size = UDim2.fromOffset(26, 26),
Position = UDim2.new(0, 6, 0.5, 0),
AnchorPoint = Vector2.new(0, 0.5),
BorderSizePixel = 0,
BackgroundTransparency = 0.82,
Parent = button,
})
New("UICorner", { CornerRadius = UDim.new(0, 7), Parent = avatarBack })
local avatarStroke = New("UIStroke", { Thickness = 1, Transparency = 0.68, Parent = avatarBack })
window:_bind(avatarBack, { BackgroundColor3 = "AccentSoft" })
window:_bind(avatarStroke, { Color = "AccentBorder" })
local avatarProps = {
Name = "Avatar",
Size = UDim2.fromOffset(tokens:Get("IconMd"), tokens:Get("IconMd")),
Position = UDim2.fromScale(0.5, 0.5),
AnchorPoint = Vector2.new(0.5, 0.5),
Parent = avatarBack,
}
local avatar = Icon.new(window, options.Icon or "star", avatarProps)
local label = New("TextLabel", {
Name = "Label",
Size = UDim2.new(1, -48, 1, 0),
Position = UDim2.new(0, 40, 0, 0),
BackgroundTransparency = 1,
Font = window.Fonts.Medium,
TextSize = tokens:Get("FontBody"),
TextXAlignment = Enum.TextXAlignment.Left,
TextTruncate = Enum.TextTruncate.AtEnd,
Text = window.Locale:Resolve(options.Title),
Parent = button,
})
window:_bind(button, { BackgroundColor3 = "SurfaceHover" })
window:_bind(label, { TextColor3 = "TextSecondary" })
self._button = button
self._avatarBack = avatarBack
self._avatarStroke = avatarStroke
self._avatar = avatar
self._label = label
self._badge = nil
if options.Badge then
self:SetBadge(options.Badge)
end
self._janitor:Add(button.MouseEnter:Connect(function()
self:_applyNavVisual(true)
end))
self._janitor:Add(button.MouseLeave:Connect(function()
self:_applyNavVisual(false)
end))
self._janitor:Add(button.MouseButton1Click:Connect(function()
if self.Locked then
if window.Notify then
window.Notify:Push({
Title = self.Title,
Content = self.LockedReason or "This tab is locked",
Variant = "Warning",
Duration = 3,
})
end
return
end
self:Select()
end))
self._page = New("ScrollingFrame", {
Name = `Page_{self.Id}`,
Size = UDim2.fromScale(1, 1),
BackgroundTransparency = 1,
BorderSizePixel = 0,
Visible = false,
CanvasSize = UDim2.new(),
AutomaticCanvasSize = Enum.AutomaticSize.Y,
ScrollingDirection = Enum.ScrollingDirection.Y,
ScrollBarThickness = 4,
ScrollBarImageTransparency = 0.4,
ClipsDescendants = true,
Parent = window._content,
})
self._janitor:Add(self._page)
self._pagePadding = New("UIPadding", {
PaddingTop = UDim.new(0, tokens:Get("PagePadding")),
PaddingBottom = UDim.new(0, tokens:Get("PagePadding")),
PaddingLeft = UDim.new(0, 0),
PaddingRight = UDim.new(0, 0),
Parent = self._page,
})
self._introHeight = if window._minimal then 0 elseif self.Description then 54 else 46
local pagePadding = tokens:Get("PagePadding")
self._pageIntro = New("Frame", {
Name = "PageIntro",
Size = UDim2.new(1, -(pagePadding * 2), 0, self._introHeight),
Position = UDim2.fromOffset(pagePadding, 0),
BackgroundTransparency = 1,
Parent = self._page,
})
self._pageIntro.Visible = not window._minimal
self._pageIconBack = New("Frame", {
Name = "PageIconTile",
Size = UDim2.fromOffset(34, 34),
Position = UDim2.fromOffset(0, 0),
BorderSizePixel = 0,
Parent = self._pageIntro,
})
New("UICorner", { CornerRadius = UDim.new(0, 10), Parent = self._pageIconBack })
local pageIconStroke = New("UIStroke", { Thickness = 1, Transparency = 0.55, Parent = self._pageIconBack })
window:_bind(self._pageIconBack, { BackgroundColor3 = "AccentSoft" })
window:_bind(pageIconStroke, { Color = "AccentBorder" })
self._pageIcon = Icon.new(window, options.Icon or "star", {
Name = "PageIcon",
Size = UDim2.fromOffset(18, 18),
Position = UDim2.fromScale(0.5, 0.5),
AnchorPoint = Vector2.new(0.5, 0.5),
Parent = self._pageIconBack,
})
Icon.setColor(self._pageIcon, window.Theme:Get("Accent"))
self._pageTitle = New("TextLabel", {
Size = UDim2.new(1, -46, 0, 22),
Position = UDim2.fromOffset(46, 0),
BackgroundTransparency = 1,
Font = window.Fonts.Bold,
TextSize = tokens:Get("FontHeading"),
TextXAlignment = Enum.TextXAlignment.Left,
Text = window.Locale:Resolve(self.Title),
Parent = self._pageIntro,
})
window:_bind(self._pageTitle, { TextColor3 = "Text" })
if self.Description then
self._pageDescription = New("TextLabel", {
Size = UDim2.new(1, -46, 0, 16),
Position = UDim2.fromOffset(46, 26),
BackgroundTransparency = 1,
Font = window.Fonts.Regular,
TextSize = tokens:Get("FontSmall"),
TextXAlignment = Enum.TextXAlignment.Left,
Text = window.Locale:Resolve(self.Description),
Parent = self._pageIntro,
})
window:_bind(self._pageDescription, { TextColor3 = "TextTertiary" })
end
self._sectionHost = New("Frame", {
Name = "SectionHost",
Size = UDim2.new(1, -(pagePadding * 2), 0, 0),
Position = UDim2.fromOffset(pagePadding, self._introHeight),
AutomaticSize = Enum.AutomaticSize.None,
BackgroundTransparency = 1,
ClipsDescendants = true,
Parent = self._page,
})
self._emptyState = New("TextLabel", {
Name = "EmptyState",
Size = UDim2.new(1, -(pagePadding * 2), 0, 54),
Position = UDim2.fromOffset(pagePadding, self._introHeight + 24),
BackgroundTransparency = 1,
Font = window.Fonts.Regular,
TextSize = tokens:Get("FontBody"),
TextXAlignment = Enum.TextXAlignment.Center,
TextYAlignment = Enum.TextYAlignment.Center,
TextWrapped = true,
Text = "Nothing here yet",
Visible = false,
Parent = self._page,
})
window:_bind(self._emptyState, { TextColor3 = "TextTertiary" })
self._column1 = New("Frame", {
Name = "Column1",
Size = UDim2.new(1, 0, 0, 0),
Position = UDim2.fromOffset(0, 0),
AutomaticSize = Enum.AutomaticSize.Y,
BackgroundTransparency = 1,
Parent = self._sectionHost,
})
self._column2 = New("Frame", {
Name = "Column2",
Size = UDim2.new(1, 0, 0, 0),
Position = UDim2.fromOffset(0, 0),
AutomaticSize = Enum.AutomaticSize.Y,
BackgroundTransparency = 1,
Visible = false,
Parent = self._sectionHost,
})
self._column1Layout = Create.List(tokens:Get("SectionGap"))
self._column1Layout.Parent = self._column1
self._column2Layout = Create.List(tokens:Get("SectionGap"))
self._column2Layout.Parent = self._column2
self._janitor:Add(self._sectionHost:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
self:_scheduleSectionLayout()
end))
window:_bind(self._page, { ScrollBarImageColor3 = "BorderStrong" })
return self
end
function Tab:_ensureMounted()
self._mounted = true
for _, section in self._sections do
if not section._mounted then
section:_mount()
end
end
if self._emptyState then
self._emptyState.Visible = #self._sections == 0
end
end
function Tab:_applyTokens()
local t = self._window.Tokens
local pagePadding = t:Get("PagePadding")
if self._window._minimal then
self._introHeight = 0
end
if self._pagePadding then
self._pagePadding.PaddingTop = UDim.new(0, pagePadding)
self._pagePadding.PaddingBottom = UDim.new(0, pagePadding)
self._pagePadding.PaddingLeft = UDim.new(0, 0)
self._pagePadding.PaddingRight = UDim.new(0, 0)
end
if self._pageIntro then
self._pageIntro.Position = UDim2.fromOffset(pagePadding, 0)
self._pageIntro.Size = UDim2.new(1, -(pagePadding * 2), 0, self._introHeight)
end
if self._sectionHost then
self._sectionHost.Position = UDim2.fromOffset(pagePadding, self._introHeight)
self._sectionHost.Size = UDim2.new(1, -(pagePadding * 2), 0, 0)
end
if self._emptyState then
self._emptyState.Position =
UDim2.fromOffset(pagePadding, self._introHeight + (if self._window._minimal then 0 else 24))
self._emptyState.Size = UDim2.new(1, -(pagePadding * 2), 0, 54)
self._emptyState.TextSize = t:Get("FontBody")
end
if self._pageTitle then
self._pageTitle.TextSize = t:Get("FontHeading")
end
if self._avatar then
self._avatar.Size = UDim2.fromOffset(t:Get("IconMd"), t:Get("IconMd"))
end
if self._pageDescription then
self._pageDescription.TextSize = t:Get("FontSmall")
end
if self._column1Layout then
self._column1Layout.Padding = UDim.new(0, t:Get("SectionGap"))
end
if self._column2Layout then
self._column2Layout.Padding = UDim.new(0, t:Get("SectionGap"))
end
for _, section in self._sections do
if section._applyTokens then
section:_applyTokens()
end
end
self:_scheduleSectionLayout()
end
function Tab:_sectionParent(column)
return self._sectionHost
end
function Tab:_scheduleSectionLayout()
if self._layoutPending or self._destroyed then
return
end
self._layoutPending = true
local thread = task.defer(function()
self._layoutPending = false
if not self._destroyed then
self:_applySectionLayout(self._window._layout)
end
end)
self._janitor:Add(thread, nil, "sectionLayoutTask")
end
function Tab:_applySectionLayout(layout)
if not self._sectionHost or not self._sectionHost.Parent then
return
end
local t = self._window.Tokens
local scale = math.max(0.01, self._window._scale or 1)
local available = math.floor((self._sectionHost.AbsoluteSize.X / scale) + 0.5)
if available <= 0 then
available = math.max(0, math.floor((self._page.AbsoluteSize.X / scale) - (t:Get("PagePadding") * 2) + 0.5))
end
local edgeInset = 1
local layoutWidth = math.max(1, available - edgeInset * 2)
local gap = t:Get("ColumnGap")
local minWidth = t:Get("MinSectionWidth")
local twoColumn = (layout ~= "Drawer" and not self._window._minimal)
and layoutWidth >= math.max(t:Get("TwoColumnMinWidth"), minWidth * 2 + gap)
self._twoColumn = twoColumn
if self._column1 then
self._column1.Visible = false
end
if self._column2 then
self._column2.Visible = false
end
local visible = {}
for _, section in self._sections do
if section._root and section:IsVisible() then
section._root.Parent = self._sectionHost
table.insert(visible, section)
end
end
if self._window._minimal then
for _, section in visible do
section:_applyMinimalHeader(#visible > 1)
end
end
local function heightOf(section)
local physical = (section._root and section._root.AbsoluteSize.Y or scale)
return math.max(1, math.floor((physical / scale) + 0.5))
end
if not twoColumn then
local y = edgeInset
for _, sec in visible do
sec._root.Size = UDim2.fromOffset(layoutWidth, 0)
sec._root.Position = UDim2.fromOffset(edgeInset, y)
y += heightOf(sec) + gap
end
self._sectionHost.Size = UDim2.new(1, -(t:Get("PagePadding") * 2), 0, math.max(0, y - gap + edgeInset))
if self._window._minimal and self._selected then
self._window:_syncMinimalHeight()
end
return
end
local leftWidth = math.max(1, math.floor((layoutWidth - gap) / 2))
local rightWidth = math.max(1, layoutWidth - gap - leftWidth)
local y = edgeInset
local index = 1
while index <= #visible do
local first = visible[index]
local firstFull = first.Span == 2 or (first.Span == "Auto" and #visible == 1)
if firstFull then
first._root.Size = UDim2.fromOffset(layoutWidth, 0)
first._root.Position = UDim2.fromOffset(edgeInset, y)
y += heightOf(first) + gap
index += 1
else
local second = visible[index + 1]
local secondFull = second and (second.Span == 2)
first._root.Size = UDim2.fromOffset(leftWidth, 0)
first._root.Position = UDim2.fromOffset(edgeInset, y)
local rowHeight = heightOf(first)
if second and not secondFull then
second._root.Size = UDim2.fromOffset(rightWidth, 0)
second._root.Position = UDim2.fromOffset(edgeInset + leftWidth + gap, y)
rowHeight = math.max(rowHeight, heightOf(second))
index += 2
else
index += 1
end
y += rowHeight + gap
end
end
self._sectionHost.Size = UDim2.new(1, -(t:Get("PagePadding") * 2), 0, math.max(0, y - gap + edgeInset))
if self._window._minimal and self._selected then
self._window:_syncMinimalHeight()
end
end
function Tab:AddSection(options)
options = options or {}
if not options.Title and not options._implicit then
error("[BobloUI] AddSection requires Title.", 2)
end
local section = Section.new(self, options)
if self._emptyState then
self._emptyState.Visible = false
end
return section
end
function Tab:_default()
if not self._defaultSection then
self._defaultSection = Section.new(self, { _implicit = true })
end
return self._defaultSection
end
function Tab:AddCustom(name, o)
return self:_default():AddCustom(name, o)
end
function Tab:AddButton(o)
return self:_default():AddButton(o)
end
function Tab:AddToggle(o)
return self:_default():AddToggle(o)
end
function Tab:AddSlider(o)
return self:_default():AddSlider(o)
end
function Tab:AddDropdown(o)
return self:_default():AddDropdown(o)
end
function Tab:AddInput(o)
return self:_default():AddInput(o)
end
function Tab:AddKeybind(o)
return self:_default():AddKeybind(o)
end
function Tab:AddColorPicker(o)
return self:_default():AddColorPicker(o)
end
function Tab:AddParagraph(o)
return self:_default():AddParagraph(o)
end
function Tab:AddDivider(o)
return self:_default():AddDivider(o)
end
function Tab:AddStatus(o)
return self:_default():AddStatus(o)
end
function Tab:AddProgress(o)
return self:_default():AddProgress(o)
end
function Tab:AddCode(o)
return self:_default():AddCode(o)
end
function Tab:AddImage(o)
return self:_default():AddImage(o)
end
function Tab:AddPassthrough(o)
return self:_default():AddPassthrough(o)
end
function Tab:AddViewport(o)
return self:_default():AddViewport(o)
end
function Tab:AddVideo(o)
return self:_default():AddVideo(o)
end
function Tab:AddRow(o)
return self:_default():AddRow(o or {})
end
function Tab:AddTabBox(o)
return self:_default():AddTabBox(o or {})
end
function Tab:Select()
self._window:_selectTab(self)
return self
end
function Tab:IsSelected(): boolean
return self._selected
end
function Tab:_applyNavVisual(hover: boolean)
if not self._button then
return
end
self._navHover = hover == true
local selected = self._selected
self._window.Motion:Tween(self._button, "Fast", {
BackgroundTransparency = if selected then 0.56 elseif hover then 0.76 else 1,
}, "Tabs")
if self._avatarBack then
self._window.Motion:Tween(self._avatarBack, "Fast", {
BackgroundTransparency = if selected then 0.4 elseif hover then 0.68 else 0.82,
}, "Tabs")
end
if self._avatarStroke then
self._window.Motion:Tween(self._avatarStroke, "Fast", {
Transparency = if selected then 0.22 elseif hover then 0.48 else 0.68,
}, "Tabs")
end
end
function Tab:_setSelected(selected: boolean)
self._selected = selected
self._page.Visible = selected
if self._indicator then
self._indicator.Visible = selected
end
self:_applyNavVisual(self._navHover == true)
local theme = self._window.Theme
self._label.TextColor3 = theme:Get(if selected then "Text" else "TextSecondary")
Icon.setColor(self._avatar, theme:Get(if selected then "Accent" else "TextSecondary"))
if self._pageIcon then
Icon.setColor(self._pageIcon, theme:Get("Accent"))
end
if selected then
self:_ensureMounted()
end
end
function Tab:_refreshLocale()
local shown = self._window.Locale:Resolve(self.Title)
self._label.Text = shown
if self._pageTitle then
self._pageTitle.Text = shown
end
if self._pageDescription then
self._pageDescription.Text = self._window.Locale:Resolve(self.Description or "")
end
if self._window.Registry then
self._window.Registry:Update(self, { Title = shown, Path = shown })
end
for _, section in self._sections do
if section._refreshLocale then
section:_refreshLocale()
end
end
if self._selected then
self._window:_refreshHeaderTitle()
end
self._window:_refreshGroups()
end
function Tab:SetGroup(group)
self.Group = group
if self._button then
self._button.LayoutOrder = self._window:_navLayoutOrder(group, self.Order)
end
self._window:_refreshGroups()
return self
end
function Tab:SetTitle(title: string)
self.Title = title
local shown = self._window.Locale:Resolve(title)
self._label.Text = shown
if self._pageTitle then
self._pageTitle.Text = shown
end
if self._window.Registry then
self._window.Registry:Update(self, { Title = shown, Path = shown })
end
if self._selected then
self._window:_refreshHeaderTitle()
end
return self
end
function Tab:SetDescription(description: string?)
self.Description = description
if self._pageDescription then
self._pageDescription:Destroy()
self._pageDescription = nil
end
self._introHeight = if self._window._minimal then 0 elseif description then 54 else 46
local pagePadding = self._window.Tokens:Get("PagePadding")
if self._pageIntro then
self._pageIntro.Size = UDim2.new(1, -(pagePadding * 2), 0, self._introHeight)
self._pageIntro.Position = UDim2.fromOffset(pagePadding, 0)
end
if self._sectionHost then
self._sectionHost.Position = UDim2.fromOffset(pagePadding, self._introHeight)
self._sectionHost.Size = UDim2.new(1, -(pagePadding * 2), 0, 0)
end
if self._emptyState then
self._emptyState.Position =
UDim2.fromOffset(pagePadding, self._introHeight + (if self._window._minimal then 0 else 24))
self._emptyState.Size = UDim2.new(1, -(pagePadding * 2), 0, 54)
end
self:_scheduleSectionLayout()
if description and self._pageIntro then
self._pageDescription = New("TextLabel", {
Size = UDim2.new(1, -46, 0, 16),
Position = UDim2.fromOffset(46, 26),
BackgroundTransparency = 1,
Font = self._window.Fonts.Regular,
TextSize = self._window.Tokens:Get("FontSmall"),
TextXAlignment = Enum.TextXAlignment.Left,
Text = self._window.Locale:Resolve(description),
Parent = self._pageIntro,
})
self._window:_bind(self._pageDescription, { TextColor3 = "TextTertiary" })
end
return self
end
function Tab:SetIcon(icon)
self.Icon = icon
if self._avatar then
self._avatar:Destroy()
end
local t = self._window.Tokens
local props = {
Name = "Avatar",
Size = UDim2.fromOffset(t:Get("IconMd"), t:Get("IconMd")),
Position = UDim2.fromScale(0.5, 0.5),
AnchorPoint = Vector2.new(0.5, 0.5),
Parent = self._avatarBack or self._button,
}
self._avatar = Icon.new(self._window, icon or "star", props)
if self._pageIcon then
self._pageIcon:Destroy()
self._pageIcon = nil
end
if self._pageIconBack then
self._pageIcon = Icon.new(self._window, icon or "star", {
Name = "PageIcon",
Size = UDim2.fromOffset(18, 18),
Position = UDim2.fromScale(0.5, 0.5),
AnchorPoint = Vector2.new(0.5, 0.5),
Parent = self._pageIconBack,
})
end
self:_setSelected(self._selected)
self._window:_applyLayout(self._window._layout, true)
return self
end
function Tab:SetBadge(text)
self.Badge = text
if self._badge then
self._badge:Destroy()
self._badge = nil
end
if text then
self._badge = Badge.new(self._window, text, "Neutral", self._button)
self._badge.Position = UDim2.new(1, -8, 0.5, 0)
self._badge.AnchorPoint = Vector2.new(1, 0.5)
self._badge.Visible = self._window._layout ~= "Rail"
end
return self
end
function Tab:SetVisible(visible: boolean)
self._button.Visible = visible
if not visible and self._selected then
if self._window._minimal then
self:_setSelected(false)
end
self._window:_selectFirstVisible()
end
if self._window._minimal then
self._window:_refreshMinimalMenu()
end
return self
end
function Tab:SetLocked(locked, reason)
self.Locked = locked == true
if reason ~= nil then
self.LockedReason = reason
end
if self._label then
self._label.TextTransparency = if self.Locked then 0.38 else 0
end
if self.Locked and self._selected then
if self._window._minimal then
self:_setSelected(false)
end
self._window:_selectFirstVisible()
end
if self._window._minimal then
self._window:_refreshMinimalMenu()
end
return self
end
function Tab:IsLocked()
return self.Locked == true
end
function Tab:GetInstance(): Instance
return self._page
end
function Tab:Destroy()
if self._destroyed then
return
end
self._destroyed = true
local window = self._window
window._janitor:Release(self)
if window.Registry then
window.Registry:Remove(self)
end
local position = table.find(window._tabs, self)
if position then
table.remove(window._tabs, position)
end
local wasSelected = self._selected
self._janitor:Destroy()
if wasSelected and not window._destroying then
window:_selectFirstVisible()
end
if window._minimal and not window._destroying then
window:_refreshMinimalMenu()
end
end
return Tab
end

__modules["shell/TabBox"] = function()
local Create = __require("runtime/Create")
local Janitor = __require("runtime/Janitor")
local Dependency = __require("runtime/Dependency")
local Button = __require("controls/Button")
local Toggle = __require("controls/Toggle")
local Slider = __require("controls/Slider")
local Dropdown = __require("controls/Dropdown")
local TextField = __require("controls/TextField")
local Keybind = __require("controls/Keybind")
local ColorPicker = __require("controls/ColorPicker")
local Paragraph = __require("controls/Paragraph")
local Divider = __require("controls/Divider")
local Status = __require("controls/Status")
local Progress = __require("controls/Progress")
local Code = __require("controls/Code")
local Image = __require("controls/Image")
local Passthrough = __require("controls/Passthrough")
local Viewport = __require("controls/Viewport")
local Video = __require("controls/Video")
local TabBox = {}
TabBox.__index = TabBox
local SubTab = {}
SubTab.__index = SubTab
function SubTab.new(box, options)
local self = setmetatable({
Id = options.Id or string.lower(string.gsub(options.Title, "%s+", "-")),
Title = options.Title,
_options = options,
_box = box,
_window = box._window,
_tab = box._tab,
_janitor = Janitor.new("SubTab"),
_controls = {},
_mounted = false,
_destroyed = false,
}, SubTab)
box._janitor:Add(self, "Destroy", self)
return self
end
function SubTab:_mount()
if self._mounted or self._destroyed or not self._box._mounted then
return
end
self._mounted = true
local w = self._window
self._button = Create.New("TextButton", {
AutomaticSize = Enum.AutomaticSize.X,
Size = UDim2.new(0, 0, 1, 0),
BackgroundTransparency = 1,
BorderSizePixel = 0,
AutoButtonColor = false,
Text = "  " .. self.Title .. "  ",
Font = w.Fonts.Medium,
TextSize = w.Tokens:Get("FontSmall"),
Parent = self._box._bar,
})
Create.New("UICorner", { CornerRadius = UDim.new(0, 7), Parent = self._button })
w:_bind(self._button, { BackgroundColor3 = "AccentSoft", TextColor3 = "TextSecondary" })
self._page = Create.New("Frame", {
Size = UDim2.new(1, 0, 0, 0),
AutomaticSize = Enum.AutomaticSize.Y,
BackgroundTransparency = 1,
Visible = false,
Parent = self._box._content,
})
self._layout = Create.List(w.Tokens:Get("RowGap"))
self._layout.Parent = self._page
self._janitor:Add(self._button.MouseButton1Click:Connect(function()
self._box:Select(self.Id)
end))
for _, c in self._controls do
c:_mount()
end
self:_refreshSeparators()
end
function SubTab:_controlParent()
return self._page
end
function SubTab:_registerControl(c)
table.insert(self._controls, c)
if c._setContainerEnabled then
c:_setContainerEnabled(self._box:IsEnabled())
end
if self._mounted then
c:_mount()
self:_refreshSeparators()
end
end
function SubTab:_removeControl(c)
local p = table.find(self._controls, c)
if p then
table.remove(self._controls, p)
end
self:_refreshSeparators()
end
function SubTab:_refreshSeparators()
local v = {}
for _, c in self._controls do
if c._root and c._root.Visible then
table.insert(v, c)
end
end
for i, c in v do
if c._separator then
c._separator.Visible = i < #v
end
end
end
function SubTab:SetCollapsed(v)
if not v then
self._box:Select(self.Id)
end
return self
end
function SubTab:AddButton(o)
return Button.new(self, o)
end
function SubTab:AddToggle(o)
return Toggle.new(self, o)
end
function SubTab:AddSlider(o)
return Slider.new(self, o)
end
function SubTab:AddDropdown(o)
return Dropdown.new(self, o)
end
function SubTab:AddInput(o)
return TextField.new(self, o)
end
function SubTab:AddKeybind(o)
return Keybind.new(self, o)
end
function SubTab:AddColorPicker(o)
return ColorPicker.new(self, o)
end
function SubTab:AddParagraph(o)
return Paragraph.new(self, o)
end
function SubTab:AddDivider(o)
return Divider.new(self, o or {})
end
function SubTab:AddStatus(o)
return Status.new(self, o)
end
function SubTab:AddProgress(o)
return Progress.new(self, o)
end
function SubTab:AddCode(o)
return Code.new(self, o)
end
function SubTab:AddImage(o)
return Image.new(self, o)
end
function SubTab:AddPassthrough(o)
return Passthrough.new(self, o)
end
function SubTab:AddViewport(o)
return Viewport.new(self, o)
end
function SubTab:AddVideo(o)
return Video.new(self, o)
end
function SubTab:Destroy()
if self._destroyed then
return
end
self._destroyed = true
for _, c in table.clone(self._controls) do
c:Destroy()
end
self._janitor:Destroy()
end
function TabBox.new(section, options)
options = options or {}
if options.Id then
section._window.Registry:AssertAvailable(options.Id, 3)
end
local self = setmetatable({
_section = section,
_window = section._window,
_tab = section._tab,
_janitor = Janitor.new("TabBox"),
_tabs = {},
_active = nil,
_mounted = false,
_destroyed = false,
Title = options.Title or section.Title,
Type = "TabBox",
Id = options.Id,
_manualVisible = options.Visible ~= false,
_dependencyVisible = true,
_manualEnabled = not (options.Disabled == true or type(options.Disabled) == "string"),
_dependencyEnabled = true,
_parentEnabled = true,
}, TabBox)
section._janitor:Add(self, "Destroy", self)
if self.Id then
self._window.Registry:Add(self, {
Id = self.Id,
Type = "TabBox",
Title = self.Title or "TabBox",
Tab = self._tab.Id,
Section = section.Title,
Path = `{self._tab.Title} -> {section.Title or "Default"}`,
Persist = false,
})
end
section:_registerControl(self)
Dependency.Bind(self, options.VisibleWhen, "visible")
Dependency.Bind(self, options.EnabledWhen, "enabled")
if section._mounted then
self:_mount()
end
return self
end
function TabBox:_mount()
if self._mounted or self._destroyed then
return
end
self._mounted = true
local w = self._window
local t = w.Tokens
self._root = Create.New("Frame", {
Name = "TabBox",
Size = UDim2.new(1, 0, 0, 0),
AutomaticSize = Enum.AutomaticSize.Y,
BackgroundTransparency = 1,
Visible = self:IsVisible(),
Parent = self._section:_controlParent(self),
})
self._janitor:Add(self._root)
local rootLayout = Create.List(8)
rootLayout.Parent = self._root
self._bar = Create.New(
"Frame",
{ Size = UDim2.new(1, 0, 0, 32), BackgroundTransparency = 0, BorderSizePixel = 0, Parent = self._root }
)
Create.New("UICorner", { CornerRadius = UDim.new(0, t:Get("FieldRadius")), Parent = self._bar })
w:_bind(self._bar, { BackgroundColor3 = "ControlInset" })
local l = Create.List(4, Enum.FillDirection.Horizontal)
l.VerticalAlignment = Enum.VerticalAlignment.Center
l.Parent = self._bar
Create.New("UIPadding", { PaddingLeft = UDim.new(0, 4), PaddingRight = UDim.new(0, 4), Parent = self._bar })
self._content = Create.New("Frame", {
Size = UDim2.new(1, 0, 0, 0),
AutomaticSize = Enum.AutomaticSize.Y,
BackgroundTransparency = 1,
Parent = self._root,
})
for _, tab in self._tabs do
tab:_mount()
end
if self._active then
self:Select(self._active.Id)
elseif self._tabs[1] then
self:Select(self._tabs[1].Id)
end
self:_applyContainerState()
end
function TabBox:AddTab(options)
if type(options) ~= "table" or type(options.Title) ~= "string" then
error("[BobloUI] TabBox:AddTab requires Title.", 2)
end
local id = options.Id or string.lower(string.gsub(options.Title, "%s+", "-"))
for _, existing in self._tabs do
if existing.Id == id then
error(`[BobloUI] duplicate TabBox tab Id "{id}".`, 2)
end
end
local tab = SubTab.new(self, options)
table.insert(self._tabs, tab)
if self._mounted then
tab:_mount()
end
if not self._active then
self._active = tab
if self._mounted then
self:Select(tab.Id)
end
end
return tab
end
function TabBox:Select(id)
for _, tab in self._tabs do
local active = tab.Id == id
if tab._page then
tab._page.Visible = active
end
if tab._button then
tab._button.BackgroundTransparency = if active then 0 else 1
tab._button.TextColor3 = self._window.Theme:Get(if active then "Text" else "TextSecondary")
end
if active then
self._active = tab
end
end
return self
end
function TabBox:_refreshSeparators() end
function TabBox:SetVisible(visible)
self._manualVisible = visible == true
self:_applyContainerState()
return self
end
function TabBox:IsVisible()
return self._manualVisible and self._dependencyVisible
end
function TabBox:SetEnabled(enabled)
self._manualEnabled = enabled ~= false
self:_applyContainerState()
return self
end
function TabBox:IsEnabled()
return self._parentEnabled and self._manualEnabled and self._dependencyEnabled
end
function TabBox:_setContainerEnabled(enabled)
self._parentEnabled = enabled ~= false
self:_applyContainerState()
return self
end
function TabBox:_applyContainerState()
if self._root then
self._root.Visible = self:IsVisible()
end
local enabled = self:IsEnabled()
for _, tab in self._tabs do
for _, control in tab._controls do
if control._setContainerEnabled then
control:_setContainerEnabled(enabled)
end
end
end
if self._section and self._section._refreshSeparators then
self._section:_refreshSeparators()
end
end
function TabBox:Reset()
for _, tab in self._tabs do
for _, c in tab._controls do
if c.Reset then
c:Reset()
end
end
end
return self
end
function TabBox:Destroy()
if self._destroyed then
return
end
self._destroyed = true
self._section._janitor:Release(self)
for _, tab in table.clone(self._tabs) do
tab:Destroy()
end
self._janitor:Destroy()
self._window.Registry:Remove(self)
self._section:_removeControl(self)
end
return TabBox
end

__modules["shell/Window"] = function()
local Create = __require("runtime/Create")
local Signal = __require("runtime/Signal")
local Util = __require("runtime/Util")
local Tab = __require("shell/Tab")
local WindowChrome = __require("shell/WindowChrome")
local WindowLayout = __require("shell/WindowLayout")
local Minimal = __require("shell/Minimal")
local New = Create.New
local Window = {}
Window.__index = Window
for name, method in pairs(WindowChrome) do
Window[name] = method
end
for name, method in pairs(WindowLayout) do
Window[name] = method
end
for name, method in pairs(Minimal) do
Window[name] = method
end
function Window.new(context, options)
local self = setmetatable({
Id = context.Id,
Title = options.Title,
Subtitle = options.Subtitle,
Icon = options.Icon,
Theme = context.Theme,
Tokens = context.Tokens,
Device = context.Device,
Layers = context.Layers,
Fonts = context.Fonts,
State = context.State,
Registry = context.Registry,
Input = context.Input,
Motion = context.Motion,
Locale = context.Locale,
Unloading = Signal.new("Window.Unloading"),
_janitor = context.Janitor,
_tabs = {},
_active = nil,
_layout = nil,
_minimal = options.Presentation == "Minimal",
_drawer = nil,
_visible = true,
_size = options.Size
or (if options.Presentation == "Minimal" then UDim2.fromOffset(340, 0) else UDim2.fromOffset(720, 480)),
_minSize = options.MinSize
or (if options.Presentation == "Minimal" then Vector2.new(280, 88) else Vector2.new(500, 340)),
_themeHandles = {},
_groups = {},
_groupSeq = 0,
_locked = false,
_scale = options.Scale or 1,
_rememberGeometry = options.RememberGeometry ~= false,
_sidebarHidden = options.SidebarHidden == true,
_minContainerWidth = math.max(
if options.Presentation == "Minimal" then 280 else 320,
tonumber(options.MinContainerWidth) or (if options.Presentation == "Minimal" then 280 else 500)
),
_minSidebarWidth = math.max(96, tonumber(options.MinSidebarWidth) or 120),
_sidebarCompactWidth = math.max(48, tonumber(options.SidebarCompactWidth) or context.Tokens:Get("RailWidth")),
_sidebarCollapseThreshold = math.max(320, tonumber(options.SidebarCollapseThreshold) or 700),
_compactWidthActivation = math.max(360, tonumber(options.CompactWidthActivation) or 1100),
_enableCompacting = options.EnableCompacting ~= false,
_disableCompactingSnap = options.DisableCompactingSnap == true,
_sidebarCompacted = options.SidebarCompacted == true,
_sidebarWidth = math.max(
math.max(96, tonumber(options.MinSidebarWidth) or 120),
tonumber(options.SidebarWidth) or context.Tokens:Get("SidebarWidth")
),
_sidebarResizeEnabled = options.EnableSidebarResize ~= false,
_disableSearch = options.DisableSearch == true,
_searchbarSize = options.SearchbarSize,
_globalSearch = options.GlobalSearch ~= false,
_showMobileButtons = options.ShowMobileButtons ~= false,
_mobileButtonsSide = options.MobileButtonsSide or "Center",
_cornerRadius = options.CornerRadius or context.Tokens:Get("CornerLg"),
_footerHeight = math.max(26, math.floor(tonumber(options.FooterHeight) or 28)),
_footerTextValue = options.FooterText,
_windowOpacity = math.clamp(tonumber(options.Opacity) or 1, 0.25, 1),
_tabTransition = options.TabTransition or {
Style = "Slide",
Duration = tonumber(options.TabTransitionTime) or 0.12,
Offset = tonumber(options.TabSwipeOffset) or 10,
Direction = options.TabSwipeFrom or "Right",
},
_windowAnimation = options.WindowAnimation or { Style = "Slide", Duration = 0.12, Offset = 8 },
_animationFlags = { Window = true, Tabs = true, Controls = true },
_visibilityToken = 0,
_topbarItems = {},
_restoreSpec = options.RestoreButton,
_showText = options.ShowText or "Show BobloUI",
_showTextExplicit = options.ShowText ~= nil,
_restoreMode = if options.ShowMobileButtons == false and options.RestoreButton == nil
then "Never"
elseif options.RestoreButton == false then "Never"
elseif type(options.RestoreButton) == "table" and options.RestoreButton.Enabled == false then "Never"
elseif options.RestoreButton ~= nil then (
(type(options.RestoreButton) == "table" and options.RestoreButton.Mode) or "Always"
)
else "Always",
_backgroundImageSource = options.BackgroundImage,
_backgroundImageTransparency = options.BackgroundImageTransparency,
}, Window)
self:_build()
self:_applyLayout(self:_responsiveLayout(), true)
self._janitor:Add(self.Device.Changed:Connect(function(device, changed)
if changed.Layout then
self:_applyLayout(self:_responsiveLayout())
end
if changed.Class then
self.Tokens:SetDeviceClass(device.Class)
end
if changed.Viewport or changed.Insets then
self:_applyGeometry()
self:_refreshRestoreButton()
end
if changed.Class then
self:_refreshRestoreButton()
end
end))
self._janitor:Add(self.Tokens.Changed:Connect(function()
self:_applyTokens()
end))
self._janitor:Add(self.Theme.Changed:Connect(function()
self:_flashThemeSwap()
self:_refreshChromeIcons()
for _, tab in self._tabs do
tab:_setSelected(tab._selected)
end
end))
self._janitor:Add(self.Input.Began:Connect(function(input, processed)
if processed or self._layout ~= "Drawer" or input.UserInputType ~= Enum.UserInputType.Touch then
return
end
local start = input.Position
local dx = 0
if not self._drawer and start.X <= 24 then
self.Input:CapturePointer(self, input, function(move)
dx = move.Position.X - start.X
end, function()
if dx > 60 then
self:OpenDrawer()
end
end)
elseif self._drawer then
self.Input:CapturePointer(self, input, function(move)
dx = move.Position.X - start.X
end, function()
if dx < -60 then
self:CloseDrawer()
end
end)
end
end))
return self
end
function Window:_responsiveLayout()
if self._minimal then
return "Minimal"
end
local width = self.Device.Viewport.X
if width < self._sidebarCollapseThreshold then
return "Drawer"
end
if self._sidebarCompacted then
return "Rail"
end
if self._enableCompacting and not self._disableCompactingSnap and width < self._compactWidthActivation then
return "Rail"
end
return "Wide"
end
function Window:_bind(instance: Instance, map: { [string]: any })
local handles = self.Theme:BindMany(instance, map)
local released = false
local destroying
local function release()
if released then
return
end
released = true
self.Theme:Unbind(handles)
if destroying then
destroying:Disconnect()
end
self._janitor:Release(release)
end
destroying = instance.Destroying:Connect(release)
self._janitor:Add(release, nil, release)
return handles
end
function Window:_build()
local tokens = self.Tokens
self._root = New("Frame", {
Name = "Window",
Size = self._size,
Position = UDim2.fromScale(0.5, 0.5),
AnchorPoint = Vector2.new(0.5, 0.5),
BorderSizePixel = 0,
ClipsDescendants = true,
Parent = self.Layers.Root,
})
self._janitor:Add(self._root)
self._rootCorner = New("UICorner", { CornerRadius = UDim.new(0, self._cornerRadius), Parent = self._root })
self._rootStroke = New("UIStroke", {
Thickness = tokens:Get("Stroke"),
LineJoinMode = Enum.LineJoinMode.Round,
ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
Parent = self._root,
})
self:_bind(self._root, { BackgroundColor3 = "Canvas" })
self._backgroundImage = New("ImageLabel", {
Name = "BackgroundImage",
Size = UDim2.fromScale(1, 1),
BackgroundTransparency = 1,
BorderSizePixel = 0,
Image = "",
ImageTransparency = 1,
ScaleType = Enum.ScaleType.Crop,
Visible = false,
ZIndex = 1,
Parent = self._root,
})
self._backgroundImageCorner = New("UICorner", {
CornerRadius = UDim.new(0, self._cornerRadius),
Parent = self._backgroundImage,
})
self._rootStroke.Transparency = 0.25
self:_bind(self._rootStroke, { Color = "BorderStrong" })
self:_buildHeader()
self:_buildBody()
self:_buildFooter()
self:_buildResizeGrip()
if self._minimal then
self:_buildMinimal()
end
self:SetWindowOpacity(self._windowOpacity)
if self._backgroundImageSource then
self:SetBackgroundImage(self._backgroundImageSource, self._backgroundImageTransparency)
end
self._flash = New("Frame", {
Name = "ThemeFlash",
Size = UDim2.fromScale(1, 1),
BackgroundTransparency = 1,
BorderSizePixel = 0,
ZIndex = 50,
Visible = false,
Parent = self._root,
})
self._flashCorner = New("UICorner", {
CornerRadius = UDim.new(0, self._cornerRadius),
Parent = self._flash,
})
self._janitor:Add(self._flash)
self._restoreButton = New("TextButton", {
Name = "Restore",
Size = UDim2.fromOffset(132, 32),
Position = UDim2.new(0.5, 0, 0, math.max(12, self.Device.Insets.Top + 10)),
AnchorPoint = Vector2.new(0.5, 0),
BackgroundTransparency = 0.12,
BorderSizePixel = 0,
AutoButtonColor = false,
Text = self._showText,
Font = self.Fonts.Medium,
TextSize = self.Tokens:Get("FontSmall"),
Visible = false,
ZIndex = 1000,
Parent = self.Layers.Toast,
})
self._restoreCorner =
New("UICorner", { CornerRadius = UDim.new(0, self.Tokens:Get("CornerMd")), Parent = self._restoreButton })
local restoreStroke = New("UIStroke", { Thickness = 1, Transparency = 0.55, Parent = self._restoreButton })
self:_bind(self._restoreButton, { BackgroundColor3 = "SurfaceRaised", TextColor3 = "Text" })
self:_bind(restoreStroke, { Color = "Border" })
self._janitor:Add(self._restoreButton.MouseButton1Click:Connect(function()
self:Show()
end))
self:SetRestoreButton(self._restoreSpec)
end
function Window:_ensureGroupHeader(group)
if not group or group == "" then
return nil
end
local existing = self._groups[group]
if existing then
return existing
end
self._groupSeq += 1
local index = self._groupSeq
local t = self.Tokens
local root = New("Frame", {
Name = "Group_" .. tostring(index),
Size = UDim2.new(1, -12, 0, 24),
BackgroundTransparency = 1,
LayoutOrder = index * 1000,
Parent = self._navList,
})
local accent = New("Frame", {
Name = "Accent",
Size = UDim2.fromOffset(3, 3),
Position = UDim2.new(0, 4, 0.5, 0),
AnchorPoint = Vector2.new(0, 0.5),
BorderSizePixel = 0,
Parent = root,
})
New("UICorner", { CornerRadius = UDim.new(1, 0), Parent = accent })
self:_bind(accent, { BackgroundColor3 = "AccentMuted" })
local label = New("TextLabel", {
Name = "Label",
Size = UDim2.new(1, -14, 1, 0),
Position = UDim2.fromOffset(14, 0),
BackgroundTransparency = 1,
Font = self.Fonts.Bold,
TextSize = t:Get("FontCaption"),
TextXAlignment = Enum.TextXAlignment.Left,
Text = string.upper(self.Locale:Resolve(group)),
Parent = root,
})
self:_bind(label, { TextColor3 = "TextTertiary" })
existing = { Index = index, Root = root, Label = label, Title = group }
self._groups[group] = existing
return existing
end
function Window:_navLayoutOrder(group, order)
local g = self:_ensureGroupHeader(group)
return (g and g.Index * 1000 or 0) + (order or 1)
end
function Window:_refreshGroups()
for _, g in self._groups do
if g.Label then
g.Label.Text = string.upper(self.Locale:Resolve(g.Title))
g.Label.Visible = true
if g.Root then
g.Root.Visible = self._layout ~= "Rail"
end
end
end
end
function Window:AddTab(options)
if type(options) ~= "table" or type(options.Title) ~= "string" then
error("[BobloUI] AddTab requires a table with a Title string.", 2)
end
local id = options.Id or Util.slug(options.Title)
if self.Registry then
self.Registry:AssertAvailable(id, 2)
end
for _, existing in self._tabs do
if existing.Id == id then
error(`[BobloUI] duplicate tab Id "{id}". Tab ids must be unique per window.`, 2)
end
end
local tab = Tab.new(self, options)
table.insert(self._tabs, tab)
if self.Registry then
self.Registry:Add(tab, { Id = id, Type = "Tab", Title = options.Title, Path = options.Title, Persist = false })
end
if not self._active and tab._button.Visible then
self:_selectTab(tab)
else
tab:_setSelected(false)
end
self:_applyLayout(self._layout, true)
if self._minimal then
self:_refreshMinimalMenu()
end
if not options._system and self._settingsService and not self._settingsService._mounted then
self._settingsService:_ensureMounted()
end
return tab
end
function Window:Get(id: string)
return self.Registry and self.Registry:Get(id) or nil
end
function Window:GetTab(id: string)
for _, tab in self._tabs do
if tab.Id == id then
return tab
end
end
return nil
end
function Window:_selectTab(tab)
if tab.Locked then
if self.Notify then
self.Notify:Push({
Title = tab.Title,
Content = tab.LockedReason or "This tab is locked",
Variant = "Warning",
Duration = 3,
})
end
return
end
if self._active == tab then
return
end
if self._active then
self._active:_setSelected(false)
end
self._active = tab
tab:_setSelected(true)
local tr = self._tabTransition or {}
if tab._page and self._animationFlags.Tabs ~= false and tr.Style ~= "None" then
local offset = tonumber(tr.Offset) or 10
local dir = string.lower(tostring(tr.Direction or "Right"))
local x, y = 0, 0
if dir == "left" then
x = -offset
elseif dir == "up" or dir == "top" then
y = -offset
elseif dir == "down" or dir == "bottom" then
y = offset
else
x = offset
end
tab._page.Position = UDim2.fromOffset(x, y)
self.Motion:Tween(
tab._page,
TweenInfo.new(tonumber(tr.Duration) or 0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
{ Position = UDim2.new() },
"Tabs"
)
end
self:_refreshHeaderTitle()
if self._minimal then
self:_refreshMinimalMenu()
self:_scheduleSectionLayouts()
end
self:CloseDrawer()
end
function Window:_selectFirstVisible()
self._active = nil
for _, tab in self._tabs do
if tab._button.Visible and not tab.Locked then
self:_selectTab(tab)
return
end
end
if self._minimal then
self:_syncMinimalHeight()
end
end
function Window:GetInstance(): Instance
return self._root
end
function Window:Destroy()
if self._destroyed then
return
end
self._destroyed = true
self._destroying = true
self:CloseDrawer()
for _, tab in table.clone(self._tabs) do
tab:Destroy()
end
self._tabs = {}
self._active = nil
self.Unloading:Destroy()
end
return Window
end

__modules["shell/WindowChrome"] = function()
local Create = __require("runtime/Create")
local Icon = __require("primitives/Icon")
local New = Create.New
local WindowChrome = {}
local FADE_TIME = 0.12
local function addToolbarStroke(window, button)
local stroke = New("UIStroke", { Thickness = 1, Transparency = 0.72, Parent = button })
window:_bind(stroke, { Color = "BorderSubtle" })
return stroke
end
local function drawToolbarIcon(window, parent, name, size)
local glyph = Icon.new(window, name, {
Size = UDim2.fromOffset(size or 16, size or 16),
Position = UDim2.fromScale(0.5, 0.5),
AnchorPoint = Vector2.new(0.5, 0.5),
Parent = parent,
})
Icon.setColor(glyph, window.Theme:Get("TextSecondary"))
return glyph
end
local function drawSearchIcon(window, parent)
return drawToolbarIcon(window, parent, "search", 16)
end
local function drawThemeIcon(window, parent)
return drawToolbarIcon(window, parent, "sun-moon", 17)
end
function WindowChrome:_buildHeader()
local tokens = self.Tokens
self._header = New("Frame", {
Name = "Header",
Size = UDim2.new(1, 0, 0, tokens:Get("HeaderHeight")),
BorderSizePixel = 0,
Parent = self._root,
})
self._headerCorner = New("UICorner", {
CornerRadius = UDim.new(0, self._cornerRadius),
Parent = self._header,
})
self:_bind(self._header, { BackgroundColor3 = "Canvas" })
self._headerLine = New("Frame", {
Name = "Divider",
Size = UDim2.new(1, 0, 0, 1),
Position = UDim2.new(0, 0, 1, -1),
BorderSizePixel = 0,
Parent = self._header,
})
self._headerLine.BackgroundTransparency = 0.35
self:_bind(self._headerLine, { BackgroundColor3 = "BorderSubtle" })
self._navToggle = New("TextButton", {
Name = "NavToggle",
Size = UDim2.fromOffset(32, 32),
Position = UDim2.new(0, 8, 0.5, 0),
AnchorPoint = Vector2.new(0, 0.5),
BackgroundTransparency = 1,
AutoButtonColor = false,
Text = "",
Visible = false,
Parent = self._header,
})
drawToolbarIcon(self, self._navToggle, "menu", 17)
self._janitor:Add(self._navToggle.MouseButton1Click:Connect(function()
self:OpenDrawer()
end))
self._brandMark = New("Frame", {
Name = "BrandMark",
Size = UDim2.fromOffset(28, 28),
Position = UDim2.new(0, 14, 0.5, 0),
AnchorPoint = Vector2.new(0, 0.5),
BorderSizePixel = 0,
Parent = self._header,
})
New("UICorner", { CornerRadius = UDim.new(0, 8), Parent = self._brandMark })
local brandStroke = New("UIStroke", { Thickness = 1, Transparency = 0.46, Parent = self._brandMark })
self:_bind(self._brandMark, { BackgroundColor3 = "AccentSoft" })
self:_bind(brandStroke, { Color = "AccentBorder" })
self._brandDot = New("Frame", {
Name = "StatusDot",
Size = UDim2.fromOffset(5, 5),
Position = UDim2.new(1, -1, 0, 1),
AnchorPoint = Vector2.new(1, 0),
BorderSizePixel = 0,
Parent = self._brandMark,
})
New("UICorner", { CornerRadius = UDim.new(1, 0), Parent = self._brandDot })
self:_bind(self._brandDot, { BackgroundColor3 = "Accent" })
if self.Icon then
self._brandGlyph = Icon.new(self, self.Icon, {
Size = UDim2.fromOffset(15, 15),
Position = UDim2.fromScale(0.5, 0.5),
AnchorPoint = Vector2.new(0.5, 0.5),
Parent = self._brandMark,
})
Icon.setColor(self._brandGlyph, self.Theme:Get("Accent"))
else
self._brandGlyph = New("TextLabel", {
Size = UDim2.fromScale(1, 1),
BackgroundTransparency = 1,
Font = self.Fonts.Bold,
TextSize = 14,
Text = self.Title:sub(1, 1):upper(),
Parent = self._brandMark,
})
self:_bind(self._brandGlyph, { TextColor3 = "Accent" })
end
self._titleLabel = New("TextLabel", {
Name = "Title",
Size = UDim2.new(1, -176, 0, 18),
Position = UDim2.new(0, 52, 0, 9),
BackgroundTransparency = 1,
Font = self.Fonts.Bold,
TextSize = tokens:Get("FontTitle"),
TextXAlignment = Enum.TextXAlignment.Left,
TextTruncate = Enum.TextTruncate.AtEnd,
Text = self.Title,
Parent = self._header,
})
self:_bind(self._titleLabel, { TextColor3 = "Text" })
self._subtitleLabel = New("TextLabel", {
Name = "Subtitle",
Size = UDim2.new(1, -176, 0, 14),
Position = UDim2.new(0, 52, 0, 29),
BackgroundTransparency = 1,
Font = self.Fonts.Regular,
TextSize = tokens:Get("FontSmall"),
TextXAlignment = Enum.TextXAlignment.Left,
TextTruncate = Enum.TextTruncate.AtEnd,
Text = self.Subtitle or "",
Visible = self.Subtitle ~= nil,
Parent = self._header,
})
self:_bind(self._subtitleLabel, { TextColor3 = "TextSecondary" })
self._topbarExtras = New("Frame", {
Name = "TopbarExtras",
Size = UDim2.fromOffset(230, 30),
Position = UDim2.new(1, -188, 0.5, 0),
AnchorPoint = Vector2.new(1, 0.5),
BackgroundTransparency = 1,
Visible = false,
Parent = self._header,
})
local topbarLayout = Create.List(
5,
Enum.FillDirection.Horizontal,
{ HorizontalAlignment = Enum.HorizontalAlignment.Right, VerticalAlignment = Enum.VerticalAlignment.Center }
)
topbarLayout.Parent = self._topbarExtras
self._sidebarButton = New("TextButton", {
Name = "SidebarToggle",
Size = UDim2.fromOffset(30, 30),
Position = UDim2.new(1, -152, 0.5, 0),
AnchorPoint = Vector2.new(1, 0.5),
BackgroundTransparency = 0.82,
AutoButtonColor = false,
Text = "",
Parent = self._header,
})
New("UICorner", { CornerRadius = UDim.new(0, tokens:Get("CornerSm")), Parent = self._sidebarButton })
addToolbarStroke(self, self._sidebarButton)
self:_bind(self._sidebarButton, { BackgroundColor3 = "ControlHover" })
local sidebarIcon = Icon.new(self, "menu", {
Size = UDim2.fromOffset(16, 16),
Position = UDim2.fromScale(0.5, 0.5),
AnchorPoint = Vector2.new(0.5, 0.5),
Parent = self._sidebarButton,
})
Icon.setColor(sidebarIcon, self.Theme:Get("TextSecondary"))
self._janitor:Add(self._sidebarButton.MouseEnter:Connect(function()
self._sidebarButton.BackgroundTransparency = 0.48
end))
self._janitor:Add(self._sidebarButton.MouseLeave:Connect(function()
self._sidebarButton.BackgroundTransparency = 0.82
end))
self._janitor:Add(self._sidebarButton.MouseButton1Click:Connect(function()
if self._layout == "Drawer" then
self:OpenDrawer()
else
self:ToggleSidebar()
end
end))
self._searchButton = New("TextButton", {
Name = "Search",
Size = UDim2.fromOffset(30, 30),
Position = UDim2.new(1, -116, 0.5, 0),
AnchorPoint = Vector2.new(1, 0.5),
BackgroundTransparency = 0.82,
AutoButtonColor = false,
Text = "",
Visible = not self._disableSearch,
Parent = self._header,
})
New("UICorner", { CornerRadius = UDim.new(0, tokens:Get("CornerSm")), Parent = self._searchButton })
addToolbarStroke(self, self._searchButton)
self:_bind(self._searchButton, { BackgroundColor3 = "ControlHover" })
drawSearchIcon(self, self._searchButton)
self._janitor:Add(self._searchButton.MouseEnter:Connect(function()
self._searchButton.BackgroundTransparency = 0.48
end))
self._janitor:Add(self._searchButton.MouseLeave:Connect(function()
self._searchButton.BackgroundTransparency = 0.82
end))
self._janitor:Add(self._searchButton.MouseButton1Click:Connect(function()
if self.OpenSearch then
self:OpenSearch()
end
end))
self._themeButton = New("TextButton", {
Name = "Theme",
Size = UDim2.fromOffset(30, 30),
Position = UDim2.new(1, -80, 0.5, 0),
AnchorPoint = Vector2.new(1, 0.5),
BackgroundTransparency = 0.82,
AutoButtonColor = false,
Text = "",
Parent = self._header,
})
New("UICorner", { CornerRadius = UDim.new(0, tokens:Get("CornerSm")), Parent = self._themeButton })
addToolbarStroke(self, self._themeButton)
self:_bind(self._themeButton, { BackgroundColor3 = "ControlHover" })
drawThemeIcon(self, self._themeButton)
self._janitor:Add(self._themeButton.MouseEnter:Connect(function()
self._themeButton.BackgroundTransparency = 0.48
end))
self._janitor:Add(self._themeButton.MouseLeave:Connect(function()
self._themeButton.BackgroundTransparency = 0.82
end))
self._janitor:Add(self._themeButton.MouseButton1Click:Connect(function()
if self.SetTheme then
local target = self.Theme:Counterpart()
if target and target ~= self.Theme:Current() then
self:SetTheme(target)
end
end
end))
self._minimizeButton = New("TextButton", {
Name = "Minimize",
Size = UDim2.fromOffset(30, 30),
Position = UDim2.new(1, -44, 0.5, 0),
AnchorPoint = Vector2.new(1, 0.5),
BackgroundTransparency = 0.86,
AutoButtonColor = false,
Text = "",
Parent = self._header,
})
New("UICorner", { CornerRadius = UDim.new(0, tokens:Get("CornerSm")), Parent = self._minimizeButton })
addToolbarStroke(self, self._minimizeButton)
drawToolbarIcon(self, self._minimizeButton, "minus", 15)
self:_bind(self._minimizeButton, { BackgroundColor3 = "ControlHover" })
self._janitor:Add(self._minimizeButton.MouseEnter:Connect(function()
self._minimizeButton.BackgroundTransparency = 0.48
end))
self._janitor:Add(self._minimizeButton.MouseLeave:Connect(function()
self._minimizeButton.BackgroundTransparency = 0.86
end))
self._janitor:Add(self._minimizeButton.MouseButton1Click:Connect(function()
self:Minimize()
end))
self._closeButton = New("TextButton", {
Name = "Close",
Size = UDim2.fromOffset(32, 32),
Position = UDim2.new(1, -8, 0.5, 0),
AnchorPoint = Vector2.new(1, 0.5),
BackgroundTransparency = 0.88,
AutoButtonColor = false,
Text = "",
Parent = self._header,
})
New("UICorner", { CornerRadius = UDim.new(0, tokens:Get("CornerSm")), Parent = self._closeButton })
addToolbarStroke(self, self._closeButton)
drawToolbarIcon(self, self._closeButton, "x", 16)
self:_bind(self._closeButton, { BackgroundColor3 = "ControlHover" })
self._closeButton.BackgroundTransparency = 0.88
self._janitor:Add(self._closeButton.MouseEnter:Connect(function()
self._closeButton.BackgroundTransparency = 0.48
end))
self._janitor:Add(self._closeButton.MouseLeave:Connect(function()
self._closeButton.BackgroundTransparency = 0.88
end))
self._janitor:Add(self._closeButton.MouseButton1Click:Connect(function()
self:Hide()
end))
self:_attachDrag(self._header)
end
function WindowChrome:_buildFooter()
self._footer = New("Frame", {
Name = "Footer",
Size = UDim2.new(1, 0, 0, self._footerHeight),
Position = UDim2.new(0, 0, 1, -self._footerHeight),
BorderSizePixel = 0,
Parent = self._root,
})
self._footerCorner = New("UICorner", {
CornerRadius = UDim.new(0, self._cornerRadius),
Parent = self._footer,
})
self:_bind(self._footer, { BackgroundColor3 = "Canvas" })
self._footerLine = New("Frame", {
Name = "Divider",
Size = UDim2.new(1, 0, 0, 1),
Position = UDim2.new(0, 0, 0, 0),
BorderSizePixel = 0,
Parent = self._footer,
})
self._footerLine.BackgroundTransparency = 0.45
self:_bind(self._footerLine, { BackgroundColor3 = "BorderSubtle" })
self._footerText = New("TextLabel", {
Name = "FooterText",
Size = UDim2.new(1, -112, 1, 0),
Position = UDim2.fromOffset(12, 0),
BackgroundTransparency = 1,
Font = self.Fonts.Regular,
TextSize = self.Tokens:Get("FontCaption"),
TextXAlignment = Enum.TextXAlignment.Left,
TextTruncate = Enum.TextTruncate.AtEnd,
Text = "",
Parent = self._footer,
})
self:_bind(self._footerText, { TextColor3 = "TextTertiary" })
self._footerHint = New("TextLabel", {
Name = "ResizeHint",
Size = UDim2.fromOffset(52, self._footerHeight),
Position = UDim2.new(1, -42, 0, 0),
AnchorPoint = Vector2.new(1, 0),
BackgroundTransparency = 1,
Font = self.Fonts.Medium,
TextSize = self.Tokens:Get("FontCaption"),
TextXAlignment = Enum.TextXAlignment.Right,
Text = "Resize",
Parent = self._footer,
})
self:_bind(self._footerHint, { TextColor3 = "TextSecondary" })
self:_refreshFooterText()
end
function WindowChrome:_refreshFooterText()
if self._footerText then
self._footerText.Text = if self._footerTextValue == nil
then ""
else self.Locale:Resolve(tostring(self._footerTextValue))
end
end
function WindowChrome:SetFooterText(text)
self._footerTextValue = if text == nil or text == false then nil else tostring(text)
self:_refreshFooterText()
return self
end
function WindowChrome:GetFooterText()
return self._footerTextValue
end
function WindowChrome:_refreshChromeIcons()
if self._brandGlyph and not self._brandGlyph:IsA("TextLabel") then
Icon.setColor(self._brandGlyph, self.Theme:Get("Accent"))
end
end
function WindowChrome:_refreshHeaderTitle()
if self._layout == "Drawer" and self._active then
self._titleLabel.Text = self.Locale:Resolve(self._active.Title)
else
self._titleLabel.Text = self.Title
end
end
function WindowChrome:_flashThemeSwap()
local flash = self._flash
if not flash or not flash.Parent then
return
end
flash.BackgroundColor3 = self.Theme:Get("Canvas")
flash.BackgroundTransparency = 0.55
flash.Visible = true
local tween = self.Motion:Tween(flash, TweenInfo.new(FADE_TIME), { BackgroundTransparency = 1 }, "Window")
if tween then
tween.Completed:Once(function()
flash.Visible = false
end)
else
flash.Visible = false
end
end
function WindowChrome:_refreshTopbarLayout()
if not self._topbarExtras or not self._titleLabel then
return
end
if self._minimal then
self._topbarExtras.Visible = false
self._titleLabel.Size = UDim2.new(1, -148, 1, 0)
return
end
local count = 0
for _, item in self._topbarItems do
if item.Instance and item.Instance.Parent then
count += 1
end
end
local visible = count > 0 and self._layout ~= "Drawer" and self._root.AbsoluteSize.X >= 680
self._topbarExtras.Visible = visible
local titleLeft = if self._layout == "Drawer" then 48 else 52
local reserve = if visible then 414 else 184
self._titleLabel.Size = UDim2.new(
1,
-titleLeft - reserve,
0,
if self._subtitleLabel.Visible then 20 else self.Tokens:Get("HeaderHeight")
)
end
function WindowChrome:AddTopbarButton(options)
options = options or {}
local w = self
local item = { Id = options.Id or tostring(#self._topbarItems + 1), _window = self }
local b = New("TextButton", {
AutomaticSize = if options.Text then Enum.AutomaticSize.X else Enum.AutomaticSize.None,
Size = if options.Text then UDim2.fromOffset(0, 28) else UDim2.fromOffset(28, 28),
BackgroundTransparency = 0.82,
BorderSizePixel = 0,
AutoButtonColor = false,
Text = options.Text and ("  " .. tostring(options.Text) .. "  ") or "",
Font = self.Fonts.Medium,
TextSize = self.Tokens:Get("FontCaption"),
LayoutOrder = options.Order or #self._topbarItems + 1,
Parent = self._topbarExtras,
})
New("UICorner", { CornerRadius = UDim.new(0, self.Tokens:Get("CornerSm")), Parent = b })
self:_bind(b, { BackgroundColor3 = "ControlHover", TextColor3 = "TextSecondary" })
if options.Icon and not options.Text then
item.Icon = Icon.new(self, options.Icon, {
Size = UDim2.fromOffset(15, 15),
Position = UDim2.fromScale(0.5, 0.5),
AnchorPoint = Vector2.new(0.5, 0.5),
Parent = b,
})
Icon.setColor(item.Icon, self.Theme:Get("TextSecondary"))
end
self._janitor:Add(b.MouseButton1Click:Connect(function()
if options.Callback then
local ok, err = xpcall(options.Callback, debug.traceback, item)
if not ok then
warn(err)
end
end
end))
item.Instance = b
function item:SetText(text)
b.Text = "  " .. tostring(text or "") .. "  "
return self
end
function item:SetVisible(v)
b.Visible = v == true
return self
end
function item:Destroy()
if b and b.Parent then
b:Destroy()
end
local p = table.find(w._topbarItems, self)
if p then
table.remove(w._topbarItems, p)
end
w:_refreshTopbarLayout()
end
table.insert(self._topbarItems, item)
self:_refreshTopbarLayout()
return item
end
function WindowChrome:AddTopbarTag(options)
if type(options) == "string" then
options = { Text = options }
end
options = options or {}
local item = { Id = options.Id or tostring(#self._topbarItems + 1) }
local label = New("TextLabel", {
AutomaticSize = Enum.AutomaticSize.X,
Size = UDim2.fromOffset(0, 24),
BackgroundTransparency = 0,
BorderSizePixel = 0,
Text = "  " .. tostring(options.Text or "") .. "  ",
Font = self.Fonts.Medium,
TextSize = self.Tokens:Get("FontCaption"),
LayoutOrder = options.Order or #self._topbarItems + 1,
Parent = self._topbarExtras,
})
New("UICorner", { CornerRadius = UDim.new(1, 0), Parent = label })
self:_bind(
label,
{ BackgroundColor3 = options.Token or "AccentSoft", TextColor3 = options.TextToken or "TextSecondary" }
)
item.Instance = label
function item:SetText(text)
label.Text = "  " .. tostring(text or "") .. "  "
return self
end
function item:SetVisible(v)
label.Visible = v == true
return self
end
function item:Destroy()
if label.Parent then
label:Destroy()
end
local p = table.find(self._window and self._window._topbarItems or {}, self)
if p and self._window then
table.remove(self._window._topbarItems, p)
self._window:_refreshTopbarLayout()
end
end
item._window = self
table.insert(self._topbarItems, item)
self:_refreshTopbarLayout()
return item
end
function WindowChrome:SetWindowOpacity(opacity)
self._windowOpacity = math.clamp(tonumber(opacity) or 1, 0.25, 1)
local tr = 1 - self._windowOpacity
for _, obj in { self._root, self._header, self._navPanel, self._content, self._footer } do
if obj then
obj.BackgroundTransparency = tr
end
end
return self
end
function WindowChrome:GetWindowOpacity()
return self._windowOpacity
end
function WindowChrome:SetBackgroundImage(image, transparency, surfaceOpacity)
if not self._backgroundImage then
return self
end
if not image or image == "" then
self._backgroundImage.Visible = false
self._backgroundImage.Image = ""
return self
end
self._backgroundImage.Image = tostring(image)
self._backgroundImage.ImageTransparency = math.clamp(tonumber(transparency) or 0.18, 0, 1)
self._backgroundImage.Visible = true
if surfaceOpacity ~= nil then
self:SetWindowOpacity(surfaceOpacity)
elseif self._windowOpacity >= 0.999 then
self:SetWindowOpacity(0.9)
end
return self
end
function WindowChrome:SetTabTransition(options)
self._tabTransition = options or { Style = "None" }
return self
end
function WindowChrome:SetWindowAnimation(options)
self._windowAnimation = options or { Style = "None" }
return self
end
function WindowChrome:SetAnimations(options, transitionTime, swipeOffset, swipeFrom)
options = options or {}
if options.ToggleWindow ~= nil then
options.Window = options.ToggleWindow
end
if options.TabSwitch ~= nil then
options.Tabs = options.TabSwitch
end
if options.Groupbox ~= nil or options.Dropdown ~= nil or options.KeyPicker ~= nil then
options.Controls = options.Groupbox ~= false and options.Dropdown ~= false and options.KeyPicker ~= false
end
if options.All ~= nil then
local enabled = options.All ~= false
self._animationFlags.Window = enabled
self._animationFlags.Tabs = enabled
self._animationFlags.Controls = enabled
self.Motion:SetCategory("Window", enabled)
self.Motion:SetCategory("Tabs", enabled)
self.Motion:SetCategory("Controls", enabled)
end
if options.Window ~= nil then
self._animationFlags.Window = options.Window ~= false
self.Motion:SetCategory("Window", options.Window ~= false)
end
if options.Tabs ~= nil then
self._animationFlags.Tabs = options.Tabs ~= false
self.Motion:SetCategory("Tabs", options.Tabs ~= false)
end
if options.Controls ~= nil then
self._animationFlags.Controls = options.Controls ~= false
self.Motion:SetCategory("Controls", options.Controls ~= false)
end
if transitionTime ~= nil or swipeOffset ~= nil or swipeFrom ~= nil then
local transition = table.clone(self._tabTransition or {})
transition.Duration = tonumber(transitionTime) or transition.Duration
transition.Offset = tonumber(swipeOffset) or transition.Offset
transition.Direction = swipeFrom or transition.Direction
self:SetTabTransition(transition)
end
return self
end
function WindowChrome:SetAnimationEnabled(component, enabled)
if component == "All" then
return self:SetAnimations({ All = enabled })
end
if self._animationFlags[component] == nil then
error("[BobloUI] animation component must be Window, Tabs, Controls, or All.", 2)
end
return self:SetAnimations({ [component] = enabled })
end
function WindowChrome:_shouldShowRestoreButton()
if not self._showMobileButtons and self.Device.IsTouch then
return false
end
if self._restoreMode == "Never" then
return false
end
if self._restoreMode == "Always" then
return true
end
if self._restoreMode == "Mobile" then
return self.Device.IsTouch == true
end
if self._restoreMode == "Auto" then
return true
end
return false
end
function WindowChrome:_refreshRestoreButton()
local b = self._restoreButton
if not b then
return
end
b.Visible = (not self._visible) and self:_shouldShowRestoreButton()
end
function WindowChrome:SetRestoreButton(options)
if options == false then
self._restoreSpec = false
self._restoreMode = "Never"
self:_refreshRestoreButton()
return self
end
options = options or {}
self._restoreSpec = options
local b = self._restoreButton
if not b then
return self
end
if options.Enabled == false then
self._restoreMode = "Never"
elseif options.Mode then
self._restoreMode = options.Mode
elseif next(options) ~= nil then
self._restoreMode = "Always"
elseif self._restoreMode == nil then
self._restoreMode = "Always"
end
local custom = next(options) ~= nil
if custom and options.Size then
local size = options.Size
if typeof(size) == "Vector2" then
b.Size = UDim2.fromOffset(size.X, size.Y)
elseif typeof(size) == "UDim2" then
b.Size = size
end
elseif not custom then
b.Size = UDim2.fromOffset(132, 32)
end
if custom and options.Position and typeof(options.Position) == "UDim2" then
b.Position = options.Position
b.AnchorPoint = options.AnchorPoint or b.AnchorPoint
elseif not custom then
if self._mobileButtonsSide == "Left" then
b.Position = UDim2.new(0, 12, 0, math.max(12, self.Device.Insets.Top + 10))
b.AnchorPoint = Vector2.new(0, 0)
elseif self._mobileButtonsSide == "Right" then
b.Position = UDim2.new(1, -12, 0, math.max(12, self.Device.Insets.Top + 10))
b.AnchorPoint = Vector2.new(1, 0)
else
b.Position = UDim2.new(0.5, 0, 0, math.max(12, self.Device.Insets.Top + 10))
b.AnchorPoint = Vector2.new(0.5, 0)
end
end
if self._restoreIcon then
self._restoreIcon:Destroy()
self._restoreIcon = nil
end
if custom and options.Icon then
b.Text = ""
self._restoreIcon = Icon.new(self, options.Icon, {
Size = UDim2.fromOffset(18, 18),
Position = UDim2.fromScale(0.5, 0.5),
AnchorPoint = Vector2.new(0.5, 0.5),
Parent = b,
})
Icon.setColor(self._restoreIcon, self.Theme:Get("Text"))
else
b.Text = tostring((custom and options.Text) or self._showText)
end
local c = self._restoreCorner or b:FindFirstChildOfClass("UICorner")
if c then
if custom and options.Shape == "Circle" then
c.CornerRadius = UDim.new(1, 0)
elseif custom and options.Shape == "Square" then
c.CornerRadius = UDim.new(0, 3)
else
c.CornerRadius = UDim.new(0, self.Tokens:Get("CornerMd"))
end
end
self._janitor:Remove("restoreDrag")
local allowDrag = (not custom and true) or options.Draggable ~= false
if allowDrag then
local base = b.Position
self._janitor:Add(
self.Input:AttachDrag(b, function(delta)
b.Position = UDim2.new(base.X.Scale, base.X.Offset + delta.X, base.Y.Scale, base.Y.Offset + delta.Y)
end, function()
if self._visible then
return false
end
base = b.Position
return true
end),
"Destroy",
"restoreDrag"
)
end
self:_refreshRestoreButton()
return self
end
function WindowChrome:SetShowText(text)
self._showTextExplicit = text ~= nil
self._showText = tostring(text or "Show BobloUI")
if self._restoreButton and not self._restoreIcon then
self._restoreButton.Text = self._showText
end
return self
end
function WindowChrome:_animatedPosition(base, offset)
local style = (self._windowAnimation and self._windowAnimation.Style) or "None"
if style == "SlideLeft" then
return UDim2.new(base.X.Scale, base.X.Offset - offset, base.Y.Scale, base.Y.Offset)
elseif style == "SlideRight" then
return UDim2.new(base.X.Scale, base.X.Offset + offset, base.Y.Scale, base.Y.Offset)
elseif style == "SlideUp" then
return UDim2.new(base.X.Scale, base.X.Offset, base.Y.Scale, base.Y.Offset - offset)
else
return UDim2.new(base.X.Scale, base.X.Offset, base.Y.Scale, base.Y.Offset + offset)
end
end
function WindowChrome:Show()
self._visibilityToken += 1
local token = self._visibilityToken
self._visible = true
local root = self._root
local target = self._hiddenRestPosition or root.Position
self._hiddenRestPosition = nil
root.Visible = true
if self._restoreButton then
self._restoreButton.Visible = false
end
local spec = self._windowAnimation or {}
if self._layout ~= "Drawer" and self._animationFlags.Window ~= false and spec.Style ~= "None" then
local offset = tonumber(spec.Offset) or 8
root.Position = self:_animatedPosition(target, offset)
self.Motion:Tween(
root,
TweenInfo.new(tonumber(spec.Duration) or 0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
{ Position = target },
"Window"
)
else
root.Position = target
end
return self
end
function WindowChrome:Hide()
if not self._visible then
return self
end
self._visibilityToken += 1
local token = self._visibilityToken
self._visible = false
self:CloseDrawer()
local root = self._root
local target = root.Position
self._hiddenRestPosition = target
local spec = self._windowAnimation or {}
if self._layout ~= "Drawer" and self._animationFlags.Window ~= false and spec.Style ~= "None" then
local tween = self.Motion:Tween(
root,
TweenInfo.new(tonumber(spec.Duration) or 0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
{ Position = self:_animatedPosition(target, tonumber(spec.Offset) or 8) },
"Window"
)
if tween then
tween.Completed:Once(function()
if self._visibilityToken == token and not self._visible then
root.Visible = false
root.Position = target
self:_refreshRestoreButton()
end
end)
else
root.Visible = false
root.Position = target
self:_refreshRestoreButton()
end
else
root.Visible = false
self:_refreshRestoreButton()
end
return self
end
function WindowChrome:Toggle()
if self._visible then
self:Hide()
else
self:Show()
end
return self
end
function WindowChrome:IsVisible(): boolean
return self._visible
end
function WindowChrome:SetTitle(title: string)
self.Title = title
if self._brandGlyph and self._brandGlyph:IsA("TextLabel") then
self._brandGlyph.Text = title:sub(1, 1):upper()
end
self:_refreshHeaderTitle()
return self
end
function WindowChrome:SetIcon(icon)
self.Icon = icon
if self._brandGlyph then
self._brandGlyph:Destroy()
self._brandGlyph = nil
end
if not self._brandMark then
return self
end
if icon then
self._brandGlyph = Icon.new(self, icon, {
Size = UDim2.fromOffset(15, 15),
Position = UDim2.fromScale(0.5, 0.5),
AnchorPoint = Vector2.new(0.5, 0.5),
Parent = self._brandMark,
})
Icon.setColor(self._brandGlyph, self.Theme:Get("Accent"))
else
self._brandGlyph = New("TextLabel", {
Size = UDim2.fromScale(1, 1),
BackgroundTransparency = 1,
Font = self.Fonts.Bold,
TextSize = 14,
Text = self.Title:sub(1, 1):upper(),
Parent = self._brandMark,
})
self:_bind(self._brandGlyph, { TextColor3 = "Accent" })
end
self:_refreshChromeIcons()
return self
end
function WindowChrome:SetSubtitle(text: string?)
self.Subtitle = text
self._subtitleLabel.Text = text or ""
self._subtitleLabel.Visible = text ~= nil and self._layout ~= "Drawer" and not self._minimal
self:_applyTokens()
return self
end
return WindowChrome
end

__modules["shell/WindowLayout"] = function()
local Create = __require("runtime/Create")
local New = Create.New
local WindowLayout = {}
local DRAWER_TIME = 0.18
function WindowLayout:_buildBody()
local tokens = self.Tokens
self._body = New("Frame", {
Name = "Body",
Size = UDim2.new(1, 0, 1, -(tokens:Get("HeaderHeight") + self._footerHeight)),
Position = UDim2.new(0, 0, 0, tokens:Get("HeaderHeight")),
BackgroundTransparency = 1,
Parent = self._root,
})
self._navPanel = New("Frame", {
Name = "Nav",
Size = UDim2.new(0, self._sidebarWidth, 1, 0),
BorderSizePixel = 0,
Parent = self._body,
})
self:_bind(self._navPanel, { BackgroundColor3 = "Sidebar" })
self._navLine = New("Frame", {
Name = "Divider",
Size = UDim2.new(0, 1, 1, 0),
Position = UDim2.new(1, -1, 0, 0),
BorderSizePixel = 0,
Parent = self._navPanel,
})
self._navLine.BackgroundTransparency = 0.45
self:_bind(self._navLine, { BackgroundColor3 = "BorderSubtle" })
self._sidebarGrip = New("TextButton", {
Name = "SidebarResizeGrip",
Size = UDim2.new(0, 8, 1, 0),
Position = UDim2.new(1, -4, 0, 0),
BackgroundTransparency = 1,
BorderSizePixel = 0,
AutoButtonColor = false,
Text = "",
ZIndex = 8,
Parent = self._navPanel,
})
self._janitor:Add(self._sidebarGrip.InputBegan:Connect(function(input)
if
not self._sidebarResizeEnabled
or self._layout ~= "Wide"
or self._sidebarHidden
or (
input.UserInputType ~= Enum.UserInputType.MouseButton1
and input.UserInputType ~= Enum.UserInputType.Touch
)
then
return
end
local start = input.Position
local width = self._sidebarWidth
self.Input:CapturePointer(self._sidebarGrip, input, function(move)
self:SetSidebarWidth(width + (move.Position.X - start.X) / math.max(0.01, self._scale or 1))
end, function() end)
end))
self._navList = New("Frame", {
Name = "NavList",
Size = UDim2.fromScale(1, 1),
BackgroundTransparency = 1,
Parent = self._navPanel,
})
New("UIPadding", {
PaddingTop = UDim.new(0, 12),
PaddingLeft = UDim.new(0, 8),
PaddingRight = UDim.new(0, 8),
Parent = self._navList,
})
Create.List(4).Parent = self._navList
self._content = New("Frame", {
Name = "Content",
Size = UDim2.new(1, -self._sidebarWidth, 1, 0),
Position = UDim2.new(0, self._sidebarWidth, 0, 0),
BackgroundTransparency = 0,
BorderSizePixel = 0,
ClipsDescendants = true,
Parent = self._body,
})
self:_bind(self._content, { BackgroundColor3 = "Canvas" })
self._janitor:Add(self._content:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
self:_scheduleSectionLayouts()
end))
end
function WindowLayout:_buildResizeGrip()
self._grip = New("TextButton", {
Name = "ResizeGrip",
Size = UDim2.fromOffset(32, self._footerHeight - 4),
Position = UDim2.new(1, -4, 0.5, 0),
AnchorPoint = Vector2.new(1, 0.5),
BackgroundTransparency = 1,
BorderSizePixel = 0,
AutoButtonColor = false,
Text = "",
ZIndex = 5,
Parent = self._footer,
})
New("UICorner", { CornerRadius = UDim.new(0, 6), Parent = self._grip })
self:_bind(self._grip, { BackgroundColor3 = "ControlHover" })
local glyph = New("Frame", {
Name = "CornerGlyph",
Size = UDim2.fromOffset(18, 18),
Position = UDim2.fromScale(0.5, 0.5),
AnchorPoint = Vector2.new(0.5, 0.5),
BackgroundTransparency = 1,
Parent = self._grip,
})
for index, spec in
{
{ Length = 12, Position = UDim2.fromOffset(10, 10) },
{ Length = 8, Position = UDim2.fromOffset(12, 12) },
{ Length = 4, Position = UDim2.fromOffset(14, 14) },
}
do
local line = New("Frame", {
Name = `GripLine{index}`,
Size = UDim2.fromOffset(spec.Length, 2),
Position = spec.Position,
AnchorPoint = Vector2.new(0.5, 0.5),
Rotation = -45,
BorderSizePixel = 0,
Parent = glyph,
})
New("UICorner", { CornerRadius = UDim.new(1, 0), Parent = line })
self:_bind(line, { BackgroundColor3 = "TextSecondary" })
end
self._janitor:Add(self._grip.MouseEnter:Connect(function()
self._grip.BackgroundTransparency = 0.8
end))
self._janitor:Add(self._grip.MouseLeave:Connect(function()
self._grip.BackgroundTransparency = 1
end))
self._janitor:Add(self._grip.InputBegan:Connect(function(input)
if self._layout == "Drawer" or self._locked then
return
end
if
input.UserInputType ~= Enum.UserInputType.MouseButton1
and input.UserInputType ~= Enum.UserInputType.Touch
then
return
end
local startPosition = input.Position
local scale = math.max(0.01, self._scale or 1)
local startSize = self._root.AbsoluteSize / scale
self.Input:CapturePointer(self._grip, input, function(move)
local delta = (move.Position - startPosition) / scale
local _, safeSize = self.Device:SafeArea()
local maxWidth = math.max(320, (safeSize.X - 40) / scale)
local maxHeight = math.max(260, (safeSize.Y - 40) / scale)
local minWidth = math.min(math.max(self._minSize.X, self._minContainerWidth), maxWidth)
local minHeight = math.min(self._minSize.Y, maxHeight)
local width = math.clamp(startSize.X + delta.X, minWidth, maxWidth)
local height = math.clamp(startSize.Y + delta.Y, minHeight, maxHeight)
self._size = UDim2.fromOffset(width, height)
if self._layout ~= "Drawer" then
self._root.Size = self._size
end
self:_scheduleSectionLayouts()
end, function()
self:_scheduleSectionLayouts()
end)
end))
end
function WindowLayout:_attachDrag(handle: GuiObject)
local startPosition
local dragJanitor = self.Input:AttachDrag(handle, function(delta)
if not startPosition then
return
end
local proposed = UDim2.new(
startPosition.X.Scale,
startPosition.X.Offset + delta.X,
startPosition.Y.Scale,
startPosition.Y.Offset + delta.Y
)
self._root.Position = self:_clampDragPosition(proposed)
end, function()
if self._layout == "Drawer" or self._locked then
return false
end
self.Motion:Cancel(self._root)
startPosition = self._root.Position
return true
end)
self._janitor:Add(dragJanitor)
end
function WindowLayout:_clampDragPosition(position: UDim2): UDim2
local safePosition, safeSize = self.Device:SafeArea()
local viewport = self.Device.Viewport
local size = self._root.AbsoluteSize
local anchor = self._root.AnchorPoint
local desiredX = position.X.Scale * viewport.X + position.X.Offset
local desiredY = position.Y.Scale * viewport.Y + position.Y.Offset
local minX = safePosition.X + size.X * anchor.X
local maxX = safePosition.X + safeSize.X - size.X * (1 - anchor.X)
local minY = safePosition.Y + size.Y * anchor.Y
local maxY = safePosition.Y + safeSize.Y - size.Y * (1 - anchor.Y)
local clampedX = if minX <= maxX then math.clamp(desiredX, minX, maxX) else safePosition.X + safeSize.X / 2
local clampedY = if minY <= maxY then math.clamp(desiredY, minY, maxY) else safePosition.Y + safeSize.Y / 2
return UDim2.new(
position.X.Scale,
position.X.Offset + clampedX - desiredX,
position.Y.Scale,
position.Y.Offset + clampedY - desiredY
)
end
function WindowLayout:_scheduleSectionLayouts()
if self._sectionLayoutPending or self._destroying then
return
end
self._sectionLayoutPending = true
local thread = task.defer(function()
self._sectionLayoutPending = false
if self._destroying then
return
end
for _, tab in self._tabs do
tab:_applySectionLayout(self._layout)
end
if self._minimal then
self:_syncMinimalHeight()
end
end)
self._janitor:Add(thread, nil, "sectionLayoutsTask")
end
function WindowLayout:_applyLayout(layout: string, initial: boolean?)
if self._layout == layout and not initial then
return
end
self._layout = layout
if self._minimal then
self:_applyMinimalLayout()
return
end
if not initial then
self.Layers:DismissAll()
end
self:CloseDrawer()
local drawerMode = layout == "Drawer"
local railMode = layout == "Rail"
self._navToggle.Visible = drawerMode
self._sidebarButton.Visible = true
self._grip.Visible = not drawerMode and not self._locked
if self._footer then
self._footer.Visible = not drawerMode
end
self._navPanel.Visible = not drawerMode and not self._sidebarHidden
if self._sidebarGrip then
self._sidebarGrip.Visible = self._sidebarResizeEnabled and layout == "Wide" and not self._sidebarHidden
end
self._subtitleLabel.Visible = self.Subtitle ~= nil and not drawerMode
if self._navList.Parent ~= self._navPanel then
self._navList.Parent = self._navPanel
end
self:_refreshGroups()
for _, tab in self._tabs do
tab:_applySectionLayout(layout)
tab._label.Visible = not railMode and not self._sidebarHidden
if tab._badge then
tab._badge.Visible = not railMode and not self._sidebarHidden
end
if tab._avatarBack then
tab._avatarBack.Position = if railMode then UDim2.fromScale(0.5, 0.5) else UDim2.new(0, 6, 0.5, 0)
tab._avatarBack.AnchorPoint = if railMode then Vector2.new(0.5, 0.5) else Vector2.new(0, 0.5)
end
end
self:_applyTokens()
self:_applyGeometry()
self:_refreshHeaderTitle()
self:_refreshTopbarLayout()
end
function WindowLayout:_applyTokens()
if self._minimal then
self:_applyMinimalTokens()
return
end
local tokens = self.Tokens
local layout = self._layout
local drawerMode = layout == "Drawer"
local railMode = layout == "Rail"
local navWidth = if self._sidebarHidden and not drawerMode
then 0
elseif railMode then self._sidebarCompactWidth
else self._sidebarWidth
local headerHeight = tokens:Get("HeaderHeight")
self._header.Size = UDim2.new(1, 0, 0, headerHeight)
self._body.Size = UDim2.new(1, 0, 1, -(headerHeight + self._footerHeight))
self._body.Position = UDim2.new(0, 0, 0, headerHeight)
if self._footer then
self._footer.Size = UDim2.new(1, 0, 0, self._footerHeight)
self._footer.Position = UDim2.new(0, 0, 1, -self._footerHeight)
end
self:_applyCornerRadius()
self._titleLabel.TextSize = tokens:Get("FontTitle")
self._subtitleLabel.TextSize = tokens:Get("FontSmall")
if self._footerHint then
self._footerHint.TextSize = tokens:Get("FontCaption")
end
if self._footerText then
self._footerText.TextSize = tokens:Get("FontCaption")
end
self._rootStroke.Thickness = tokens:Get("Stroke")
local titleLeft = if drawerMode then 48 else 52
self._brandMark.Visible = not drawerMode
self._titleLabel.Position = UDim2.new(0, titleLeft, 0, if self._subtitleLabel.Visible then 9 else 0)
self._titleLabel.Size = UDim2.new(1, -titleLeft - 184, 0, if self._subtitleLabel.Visible then 20 else headerHeight)
self._subtitleLabel.Position = UDim2.new(0, titleLeft, 0, 29)
if drawerMode then
self._content.Size = UDim2.fromScale(1, 1)
self._content.Position = UDim2.new()
else
self._navPanel.Size = UDim2.new(0, navWidth, 1, 0)
self._content.Size = UDim2.new(1, -navWidth, 1, 0)
self._content.Position = UDim2.new(0, navWidth, 0, 0)
end
for _, g in self._groups do
if g.Label then
g.Label.TextSize = tokens:Get("FontCaption")
end
end
for _, tab in self._tabs do
tab:_applyTokens()
tab._button.Size = UDim2.new(1, 0, 0, tokens:Get("NavItemHeight"))
tab._label.TextSize = tokens:Get("FontBody")
end
self:_refreshTopbarLayout()
self:_scheduleSectionLayouts()
end
function WindowLayout:_applyGeometry()
if self._minimal then
self._root.AnchorPoint = Vector2.new(0.5, 0.5)
local _, safeSize = self.Device:SafeArea()
local scale = math.max(0.01, self._scale or 1)
local width = math.min(math.max(1, self._size.X.Offset), math.max(1, safeSize.X / scale - 16))
self._root.Size = UDim2.fromOffset(width, self._root.Size.Y.Offset)
self:_syncMinimalHeight()
self:_scheduleSectionLayouts()
return
end
if self._layout == "Drawer" then
local position, size = self.Device:SafeArea()
self._root.AnchorPoint = Vector2.new(0, 0)
self._root.Position = UDim2.fromOffset(position.X, position.Y)
self._root.Size = UDim2.fromOffset(size.X, size.Y)
else
self._root.AnchorPoint = Vector2.new(0.5, 0.5)
if self._root.Position.X.Scale == 0 then
self._root.Position = UDim2.fromScale(0.5, 0.5)
end
local _, safeSize = self.Device:SafeArea()
local scale = math.max(0.01, self._scale or 1)
local maxWidth = math.max(self._minContainerWidth, (safeSize.X - 40) / scale)
local maxHeight = math.max(260, (safeSize.Y - 40) / scale)
self._root.Size =
UDim2.fromOffset(math.min(self._size.X.Offset, maxWidth), math.min(self._size.Y.Offset, maxHeight))
end
self:_refreshTopbarLayout()
self:_scheduleSectionLayouts()
end
function WindowLayout:OpenDrawer()
if self._drawer or self._layout ~= "Drawer" then
return
end
local tokens = self.Tokens
local width = math.min(self._sidebarWidth, self.Device.Viewport.X - 60)
local handle = self.Layers:Push({
Scrim = true,
OnDismiss = function()
self._drawer = nil
if self._navList and self._navList.Parent ~= self._navPanel then
self._navList.Parent = self._navPanel
end
end,
})
local panel = New("Frame", {
Name = "Drawer",
Size = UDim2.new(0, width, 1, 0),
Position = UDim2.fromOffset(-width, 0),
BorderSizePixel = 0,
Parent = handle.Container,
})
self:_bind(panel, { BackgroundColor3 = "Sidebar" })
self._navList.Parent = panel
self.Motion:Tween(panel, TweenInfo.new(DRAWER_TIME, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
Position = UDim2.fromOffset(0, 0),
}, "Window")
self._drawer = handle
end
function WindowLayout:CloseDrawer()
if self._drawer then
self._drawer:Dismiss()
self._drawer = nil
end
end
function WindowLayout:SetLocked(locked)
self._locked = locked == true
if self._grip then
self._grip.Visible = not self._locked and self._layout ~= "Drawer" and not self._minimal
end
if self._footerHint then
self._footerHint.Visible = not self._locked and self._layout ~= "Drawer" and not self._minimal
end
return self
end
function WindowLayout:IsLocked()
return self._locked == true
end
function WindowLayout:SetRememberGeometry(enabled)
self._rememberGeometry = enabled ~= false
return self
end
function WindowLayout:GetRememberGeometry()
return self._rememberGeometry
end
function WindowLayout:SetSidebarHidden(hidden)
self._sidebarHidden = hidden == true
self:_applyLayout(self._layout, true)
return self
end
function WindowLayout:IsSidebarHidden()
return self._sidebarHidden == true
end
function WindowLayout:ToggleSidebar()
return self:SetSidebarHidden(not self._sidebarHidden)
end
function WindowLayout:SetSidebarWidth(width)
if type(width) ~= "number" then
error("[BobloUI] Window:SetSidebarWidth expects number.", 2)
end
local scale = math.max(0.01, self._scale or 1)
local rootWidth = self._root.AbsoluteSize.X / scale
if rootWidth < 320 then
rootWidth = math.max(self._minContainerWidth, self._size.X.Offset)
end
local maxWidth = math.max(self._minSidebarWidth, math.min(420, rootWidth - 260))
self._sidebarWidth = math.clamp(math.floor(width + 0.5), self._minSidebarWidth, maxWidth)
self:_applyTokens()
return self
end
function WindowLayout:GetSidebarWidth()
return self._sidebarWidth
end
function WindowLayout:SetSidebarResizeEnabled(enabled)
self._sidebarResizeEnabled = enabled ~= false
if self._sidebarGrip then
self._sidebarGrip.Visible = self._sidebarResizeEnabled and self._layout == "Wide" and not self._sidebarHidden
end
return self
end
function WindowLayout:SetCompact(enabled)
self.Tokens:SetDensity(if enabled then "Compact" else "Comfortable")
return self
end
function WindowLayout:IsCompact()
return self.Tokens:GetDensity() == "Compact"
end
function WindowLayout:SetSidebarCompacted(enabled)
self._sidebarCompacted = enabled == true
self:_applyLayout(self:_responsiveLayout(), true)
return self
end
function WindowLayout:IsSidebarCompacted()
return self._sidebarCompacted == true
end
function WindowLayout:SetResponsiveThresholds(options)
options = options or {}
if options.MinContainerWidth ~= nil then
self._minContainerWidth = math.max(320, tonumber(options.MinContainerWidth) or self._minContainerWidth)
end
if options.MinSidebarWidth ~= nil then
self._minSidebarWidth = math.max(96, tonumber(options.MinSidebarWidth) or self._minSidebarWidth)
end
if options.SidebarCompactWidth ~= nil then
self._sidebarCompactWidth = math.max(48, tonumber(options.SidebarCompactWidth) or self._sidebarCompactWidth)
end
if options.SidebarCollapseThreshold ~= nil then
self._sidebarCollapseThreshold =
math.max(320, tonumber(options.SidebarCollapseThreshold) or self._sidebarCollapseThreshold)
end
if options.CompactWidthActivation ~= nil then
self._compactWidthActivation =
math.max(360, tonumber(options.CompactWidthActivation) or self._compactWidthActivation)
end
if options.EnableCompacting ~= nil then
self._enableCompacting = options.EnableCompacting ~= false
end
if options.DisableCompactingSnap ~= nil then
self._disableCompactingSnap = options.DisableCompactingSnap == true
end
self:_applyLayout(self:_responsiveLayout(), true)
return self
end
function WindowLayout:SetSearchEnabled(enabled)
self._disableSearch = enabled == false
if self._searchButton then
self._searchButton.Visible = not self._disableSearch and not self._minimal
end
return self
end
function WindowLayout:SetGlobalSearch(enabled)
self._globalSearch = enabled ~= false
return self
end
function WindowLayout:SetSearchbarSize(size)
if size ~= nil and type(size) ~= "number" and typeof(size) ~= "UDim2" then
error("[BobloUI] Window:SetSearchbarSize expects number, UDim2, or nil.", 2)
end
self._searchbarSize = size
return self
end
function WindowLayout:SetTabSwipe(offset, from)
local transition = table.clone(self._tabTransition or {})
transition.Offset = math.max(0, tonumber(offset) or tonumber(transition.Offset) or 10)
transition.Direction = from or transition.Direction or "Right"
return self:SetTabTransition(transition)
end
function WindowLayout:SetFont(font)
local previous = self.Fonts
local nextFonts
if type(font) == "table" then
nextFonts = {
Regular = font.Regular or previous.Regular,
Medium = font.Medium or font.Regular or previous.Medium,
Bold = font.Bold or font.Medium or font.Regular or previous.Bold,
Heavy = font.Heavy or font.Bold or font.Medium or font.Regular or previous.Heavy,
}
else
local resolved = font
if type(font) == "string" then
local ok, enum = pcall(function()
return Enum.Font[font]
end)
resolved = if ok then enum else nil
end
local isEnumFont = typeof(resolved) == "EnumItem" and resolved.EnumType == Enum.Font
if not isEnumFont and typeof(resolved) ~= "Font" then
error("[BobloUI] Window:SetFont expects Enum.Font, Font, font name, or font table.", 2)
end
nextFonts = { Regular = resolved, Medium = resolved, Bold = resolved, Heavy = resolved }
end
local function matches(instance, candidate)
if typeof(candidate) == "Font" then
local current = instance.FontFace
return current.Family == candidate.Family
and current.Weight == candidate.Weight
and current.Style == candidate.Style
end
return instance.Font == candidate
end
local function apply(instance, value)
if typeof(value) == "Font" then
instance.FontFace = value
else
instance.Font = value
end
end
self.Fonts = nextFonts
for _, screen in { self.Layers.Root, self.Layers.Overlay, self.Layers.Toast } do
for _, instance in screen:GetDescendants() do
if instance:IsA("TextLabel") or instance:IsA("TextButton") or instance:IsA("TextBox") then
local replacement = nextFonts.Regular
for _, key in { "Regular", "Medium", "Bold", "Heavy" } do
if matches(instance, previous[key]) then
replacement = nextFonts[key]
break
end
end
apply(instance, replacement)
end
end
end
return self
end
function WindowLayout:GetFont()
return table.clone(self.Fonts)
end
function WindowLayout:SetCornerRadius(radius)
if type(radius) == "boolean" then
radius = if radius then self.Tokens:Get("CornerLg") else 0
end
if type(radius) ~= "number" then
error("[BobloUI] Window:SetCornerRadius expects number.", 2)
end
self._cornerRadius = math.max(0, math.floor(radius + 0.5))
self:_applyCornerRadius()
return self
end
function WindowLayout:_applyCornerRadius()
local value = UDim.new(0, self._cornerRadius)
for _, corner in
{
self._rootCorner,
self._headerCorner,
self._footerCorner,
self._backgroundImageCorner,
self._flashCorner,
}
do
if corner then
corner.CornerRadius = value
end
end
end
function WindowLayout:SetRounded(enabled)
return self:SetCornerRadius(enabled and self.Tokens:Get("CornerLg") or 0)
end
function WindowLayout:GetCornerRadius()
return self._cornerRadius
end
function WindowLayout:SetSize(size)
if typeof(size) == "Vector2" then
size = UDim2.fromOffset(size.X, size.Y)
end
if typeof(size) ~= "UDim2" then
error("[BobloUI] Window:SetSize expects UDim2 or Vector2.", 2)
end
self._size = size
if self._minimal then
self:_applyGeometry()
return self
end
if self._layout ~= "Drawer" then
self._root.Size = size
end
self:_scheduleSectionLayouts()
return self
end
function WindowLayout:SetPosition(position)
if typeof(position) ~= "UDim2" then
error("[BobloUI] Window:SetPosition expects UDim2.", 2)
end
self._root.Position = position
return self
end
function WindowLayout:GetGeometry()
return {
Size = self._size,
Position = self._root.Position,
Scale = self._scale,
Locked = self._locked,
Remember = self._rememberGeometry,
SidebarWidth = self._sidebarWidth,
SidebarHidden = self._sidebarHidden,
Compact = self:IsCompact(),
SidebarCompacted = self:IsSidebarCompacted(),
}
end
function WindowLayout:ResetGeometry()
self._size = if self._minimal then UDim2.fromOffset(340, 0) else UDim2.fromOffset(720, 480)
self._root.Position = UDim2.fromScale(0.5, 0.5)
if self._layout ~= "Drawer" then
if self._minimal then
self:_applyGeometry()
else
self._root.Size = self._size
end
end
self:SetScale(1)
self:SetLocked(false)
self:SetCompact(false)
self:SetSidebarCompacted(false)
self:SetSidebarWidth(self.Tokens:Get("SidebarWidth"))
self:SetSidebarHidden(false)
return self
end
function WindowLayout:Minimize()
return self:Hide()
end
function WindowLayout:Restore()
return self:Show()
end
function WindowLayout:ResetAll()
self.State:Batch(function()
for _, entry in self.Registry:GetPersistable() do
if entry.Id then
self.State:Reset(entry.Id, { Source = "RESET" })
end
end
end)
return self
end
return WindowLayout
end

__modules["themes/Dark"] = function()
local hex = Color3.fromHex
return {
Canvas = hex("#070A0D"),
Background = hex("#070A0D"),
Sidebar = hex("#090D11"),
Surface = hex("#0E141A"),
SurfaceRaised = hex("#121A21"),
SurfaceInset = hex("#090F14"),
SurfaceSecondary = hex("#151D25"),
SurfaceHover = hex("#18222C"),
SurfaceActive = hex("#1D2934"),
Control = hex("#10171E"),
ControlHover = hex("#18222B"),
ControlPressed = hex("#202C37"),
ControlInset = hex("#0A1016"),
BorderSubtle = hex("#202A34"),
Border = hex("#2C3946"),
BorderStrong = hex("#3B4B5B"),
Text = hex("#F4F6F8"),
TextSecondary = hex("#B3BDC9"),
TextTertiary = hex("#7D8997"),
TextDisabled = hex("#4E5965"),
Accent = hex("#8172F2"),
Success = hex("#55D89A"),
Warning = hex("#F2B84B"),
Error = hex("#F06469"),
Info = hex("#58B9FF"),
Scrim = hex("#050608"),
ScrimTransparency = 0.52,
}
end

__modules["themes/Light"] = function()
local hex = Color3.fromHex
return {
Canvas = hex("#F5F6F8"),
Background = hex("#F5F6F8"),
Sidebar = hex("#F8F9FB"),
Surface = hex("#FFFFFF"),
SurfaceRaised = hex("#FFFFFF"),
SurfaceInset = hex("#F1F3F6"),
SurfaceSecondary = hex("#F0F2F5"),
SurfaceHover = hex("#E9ECF1"),
SurfaceActive = hex("#E1E5EB"),
Control = hex("#F8F9FB"),
ControlHover = hex("#F2F4F7"),
ControlPressed = hex("#EAEDF2"),
ControlInset = hex("#FFFFFF"),
BorderSubtle = hex("#E7EAF0"),
Border = hex("#DDE2E9"),
BorderStrong = hex("#C8D0DB"),
Text = hex("#15181D"),
TextSecondary = hex("#586372"),
TextTertiary = hex("#7F8998"),
TextDisabled = hex("#AAB2BE"),
Accent = hex("#6E5DE7"),
Success = hex("#169D63"),
Warning = hex("#B77A09"),
Error = hex("#D84A50"),
Info = hex("#147FBE"),
Scrim = hex("#15181D"),
ScrimTransparency = 0.58,
}
end

return __require("init")