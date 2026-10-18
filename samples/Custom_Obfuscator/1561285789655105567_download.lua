-- JUNKIE DASHBOARD: paste this WHOLE file into UI Source.
-- Paste OrginHub_WindUI_Fixed.lua into Original Code / Script of the SAME script.
-- This file only collects the key. Junkie validates it before Original Code runs.
-- Keep your scripts in Original Code, inside Config.Scripts -> Source.

local Config = {
    Title = "OrginHub",
    ServiceId = 101227,
    Identifier = "4815",
    Provider = "OrginHubProvider",
}

local environment = type(getgenv) == "function" and getgenv() or _G
environment.SCRIPT_KEY = nil
environment.UI_CLOSED = false

local previous = environment.OrginHubJunkieKeyUI
if type(previous) == "table" and type(previous.Destroy) == "function" then
    pcall(previous.Destroy)
end
environment.UI_CLOSED = false

local function importLibrary(url, name)
    assert(type(loadstring) == "function", name .. ": loadstring is unavailable.")
    local source = game:HttpGet(url)
    assert(type(source) == "string" and source ~= "", name .. ": empty download.")
    assert(not source:match("^%s*<"), name .. ": expected Lua, received HTML.")
    local chunk, issue = loadstring(source)
    assert(type(chunk) == "function", name .. ": " .. tostring(issue))
    local result = chunk()
    assert(type(result) == "table", name .. ": invalid library response.")
    return result
end

local loaded, WindUI = pcall(importLibrary,
    "https://github.com/Footagesus/WindUI/releases/latest/download/main.lua", "WindUI")
if not loaded then
    environment.UI_CLOSED = true
    warn("[OrginHub] Could not open the key interface. Please run the loader again.")
    return
end

local Creator = WindUI.Creator
local guiParent = WindUI.ScreenGui and WindUI.ScreenGui.Parent
local surfaces = {}
for _, name in ipairs({ "ScreenGui", "NotificationGui", "DropdownGui", "TooltipGui" }) do
    local surface = WindUI[name]
    if surface then
        surface.Enabled = false
        surfaces[#surfaces + 1] = surface
    end
end
local connections = {}
local gui, selectedKey
local done, disposed, requestingLink = false, false, false
local sdk
local controller = {}
environment.OrginHubJunkieKeyUI = controller

local function connect(signal, callback)
    local connection = signal:Connect(callback)
    connections[#connections + 1] = connection
    return connection
end
local function finish(key)
    if done then return end
    selectedKey = key
    done = true
end
function controller.Destroy()
    finish(nil)
end
local function cleanup()
    if disposed then return end
    disposed = true
    for _, connection in ipairs(connections) do connection:Disconnect() end
    if gui then pcall(function() gui:Destroy() end) end
    for _, surface in ipairs(surfaces) do pcall(function() surface:Destroy() end) end
    if Creator and type(Creator.DisconnectAll) == "function" then pcall(Creator.DisconnectAll) end
    if environment.OrginHubJunkieKeyUI == controller then environment.OrginHubJunkieKeyUI = nil end
end

local function openKeyUI()
    local Players = game:GetService("Players")
    guiParent = guiParent or Players.LocalPlayer:WaitForChild("PlayerGui")
    local white = Color3.fromRGB(255, 255, 255)
    local muted = Color3.fromRGB(161, 161, 170)
    local family = Creator and Creator.Font or "rbxassetid://12187365364"
    local regular = Font.new(family, Enum.FontWeight.Regular)
    local medium = Font.new(family, Enum.FontWeight.Medium)
    local semibold = Font.new(family, Enum.FontWeight.SemiBold)

    local function new(class, parent, properties)
        local object = Instance.new(class)
        for key, value in pairs(properties or {}) do object[key] = value end
        object.Parent = parent
        return object
    end
    local function round(parent, radius, properties)
        properties.Parent = parent
        if Creator and type(Creator.NewRoundFrame) == "function" then
            return Creator.NewRoundFrame(radius, "Squircle", properties)
        end
        properties.BackgroundTransparency = 1
        properties.Image = "rbxassetid://89641024074289"
        properties.ScaleType = Enum.ScaleType.Slice
        properties.SliceCenter = Rect.new(460, 460, 460, 460)
        properties.SliceScale = radius / 310
        return new("ImageLabel", parent, properties)
    end
    local function label(parent, name, text, x, y, width, height, size, color, font)
        return new("TextLabel", parent, {
            Name = name, BackgroundTransparency = 1, Text = text,
            Position = UDim2.fromOffset(x, y), Size = UDim2.fromOffset(width, height),
            FontFace = font or regular, TextSize = size, TextColor3 = color or white,
            TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Center,
            ZIndex = 5,
        })
    end
    local function icon(parent, name, x, y, size)
        if not Creator or type(Creator.Icon) ~= "function" then return end
        local ok, data = pcall(Creator.Icon, name)
        if not ok or type(data) ~= "table" or not data[1] then return end
        local image = new("ImageLabel", parent, {
            BackgroundTransparency = 1, Image = data[1], ImageColor3 = muted,
            Position = UDim2.fromOffset(x, y), Size = UDim2.fromOffset(size, size), ZIndex = 5,
        })
        if type(data[2]) == "table" then
            image.ImageRectSize = data[2].ImageRectSize or Vector2.new(0, 0)
            image.ImageRectOffset = data[2].ImageRectPosition or Vector2.new(0, 0)
        end
    end

    gui = new("ScreenGui", guiParent, {
        Name = "OrginHub_KeyUI", ResetOnSpawn = false, IgnoreGuiInset = true,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling, DisplayOrder = 10000,
    })
    connect(gui.Destroying, function() finish(nil) end)
    local holder = new("Frame", gui, {
        Name = "KeyDialog", BackgroundTransparency = 1, AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(430, 264),
    })
    local scale = new("UIScale", holder, { Scale = 1 })
    local panel = round(holder, 26, {
        Name = "Panel", Size = UDim2.fromScale(1, 1),
        ImageColor3 = Color3.fromRGB(16, 16, 16), ZIndex = 2,
    })
    icon(panel, "door-open", 20, 19, 24)
    label(panel, "Title", Config.Title, 58, 17, 300, 28, 20, white, semibold)
    local note = label(panel, "Note", "Enter your key to continue.\nKeyless service: enter KEYLESS.",
        20, 59, 390, 48, 18, muted, medium)
    note.TextWrapped = true
    local input = round(panel, 11, {
        Name = "Input", Position = UDim2.fromOffset(20, 122), Size = UDim2.fromOffset(390, 42),
        ImageColor3 = Color3.fromRGB(32, 32, 32), ZIndex = 3,
    })
    icon(input, "key", 14, 12, 18)
    local keyBox = new("TextBox", input, {
        Name = "KeyInput", BackgroundTransparency = 1, Text = "", PlaceholderText = "Enter Key",
        Position = UDim2.fromOffset(44, 0), Size = UDim2.new(1, -58, 1, 0),
        TextSize = 17, FontFace = regular, TextColor3 = white, PlaceholderColor3 = muted,
        TextXAlignment = Enum.TextXAlignment.Left, ClearTextOnFocus = false, ZIndex = 6,
    })
    local status = label(panel, "Status", "", 20, 173, 390, 18, 13, muted, regular)
    status.TextTruncate = Enum.TextTruncate.AtEnd

    local function button(name, title, iconName, x, width, color)
        local surface = round(panel, 11, {
            Name = name, Position = UDim2.fromOffset(x, 202), Size = UDim2.fromOffset(width, 42),
            ImageColor3 = color, ZIndex = 3,
        })
        icon(surface, iconName, 12, 12, 18)
        local text = label(surface, "Label", title, 35, 0, width - 44, 42, 17, white, semibold)
        text.TextXAlignment = Enum.TextXAlignment.Center
        local hit = new("TextButton", surface, {
            Name = "Action", Text = "", BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1), AutoButtonColor = false, ZIndex = 7,
        })
        return hit, text
    end
    local exit = button("Exit", "Exit", "log-out", 20, 90, Color3.fromRGB(23, 23, 23))
    local getKey, getKeyText = button("GetKey", "Get key", "key", 120, 132, Color3.fromRGB(30, 30, 30))
    local submit = button("Submit", "Submit", "arrow-right", 262, 148, Color3.fromRGB(82, 82, 91))

    local function submitKey()
        if done then return end
        local candidate = keyBox.Text:match("^%s*(.-)%s*$")
        if candidate == "" then
            status.Text = "Enter your key first."
            return
        end
        -- Submit to Junkie's protected loader; do not consume one-time keys here.
        finish(candidate)
    end
    connect(exit.Activated, function() finish(nil) end)
    connect(submit.Activated, submitKey)
    connect(keyBox.FocusLost, function(enterPressed)
        if enterPressed then submitKey() end
    end)
    connect(getKey.Activated, function()
        if done or requestingLink then return end
        requestingLink = true
        getKey.Active = false
        getKeyText.Text = "Wait..."
        status.Text = "Getting your key link..."
        task.spawn(function()
            local ok, link = pcall(function()
                if not sdk then
                    local candidate = importLibrary("https://jnkie.com/sdk/library.lua", "Junkie")
                    assert(type(candidate.get_key_link) == "function", "get_key_link is unavailable.")
                    candidate.service = Config.ServiceId
                    candidate.identifier = Config.Identifier
                    candidate.provider = Config.Provider
                    sdk = candidate
                end
                return sdk.get_key_link()
            end)
            if done then return end
            requestingLink = false
            getKey.Active = true
            getKeyText.Text = "Get key"
            if not ok or type(link) ~= "string" then
                status.Text = "Could not get a key link. Try again."
                return
            end
            link = link:match("^%s*(.-)%s*$")
            if not link:match("^https?://[^%s]+$") then
                status.Text = "The key service returned an invalid link."
                return
            end
            local copied = type(setclipboard) == "function" and pcall(setclipboard, link)
            if copied then
                status.Text = "Key link copied. Paste it into your browser."
            else
                print("[OrginHub] Get your key: " .. link)
                status.Text = "Your key link is in the F9 console."
            end
        end)
    end)

    local cameraConnection
    local function fit()
        if done or not workspace.CurrentCamera then return end
        local viewport = workspace.CurrentCamera.ViewportSize
        scale.Scale = math.min(1, math.max(0.1, (viewport.X - 24) / 430),
            math.max(0.1, (viewport.Y - 24) / 264))
    end
    local function watchCamera()
        if cameraConnection then cameraConnection:Disconnect() end
        if workspace.CurrentCamera then
            cameraConnection = connect(workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"), fit)
        end
        fit()
    end
    connect(workspace:GetPropertyChangedSignal("CurrentCamera"), watchCamera)
    watchCamera()
end

local opened, issue = pcall(openKeyUI)
if not opened then
    environment.UI_CLOSED = true
    finish(nil)
    cleanup()
    warn("[OrginHub] Could not open the key interface: " .. tostring(issue))
    return
end

-- This wait must stay at the TOP LEVEL. Junkie must not run before input.
repeat task.wait() until done
cleanup()
if not selectedKey then
    environment.UI_CLOSED = true
    return
end
environment.SCRIPT_KEY = selectedKey
environment.UI_CLOSED = false
-- UI Source ends. Junkie authenticates and then runs Original Code.

do ("JNKIE Loader - Unauthorized tampering or debugging of protected scripts is strictly prohibited and may result in a global blacklist from JNKIE protected scripts."):sub(1,1);local k=getgenv().SCRIPT_KEY or SCRIPT_KEY;local m="Could not load the script. Check your internet connection and try again later.";local function v(h)warn(h);task.spawn(function()pcall(function()game:GetService("Players").LocalPlayer:Kick(h)end);task.wait();pcall(function()local p=game:GetService("CoreGui").RobloxPromptGui.promptOverlay.ErrorPrompt;p.TitleFrame.ErrorTitle.Text="JNKIE";p.MessageArea.ErrorFrame.ErrorMessage.Text=h end)end)end;local r=(type(syn)=="table" and type(syn.request)=="function" and syn.request)or(type(request)=="function" and request)or(type(http_request)=="function" and http_request)or(type(http)=="table" and type(http.request)=="function" and http.request);if type(k)~="string" then v("No key provided. Get a key from the script provider, enter it, then try again.");return end;if type(r)~="function" then warn(m);return end;local function q(o)local d,a,x;task.spawn(function()a,x=pcall(r,o);d=true end);local s=os.clock();repeat task.wait()until d or os.clock()-s>15;if not d then return false,nil end;return a,x end;local a,x=q({Url="https://api.jnkie.com/api/v1/luascripts/delivery/0a830bbd49d971ead679990c033421624aafe6d222598324675a46ab7338aa2d?v=2&errors=text",Method="POST",Headers={["Content-Type"]="text/plain"},Body=k});local h=a and type(x)=="table" and type(x.Body)=="string" and(x.StatusCode==400 or x.StatusCode==401 or x.StatusCode==403)and x.Body;if h then local c,n=h:match("^([^\r\n]+)\n([^\r\n]+)$");c=c or h;if#c<=75 and(c=="LDR-DENIED"or c:match("^LDR%-DENIED:[A-Z_]+$"))then if not n or#n>512 then n=m;if k==""or k:match("^%s*$")then n="No key provided. Get a key from the script provider, enter it, then try again." end end;v(n.." ("..c..")");return end end;if a and type(x)=="table" and x.StatusCode==200 and type(x.Body)=="string" and (string.sub(x.Body,1,8)=="https://") then a,x=q({Url=x.Body,Method="GET"})end;if a and type(x)=="table" and(x.StatusCode==302 or x.StatusCode==303)then local h=x.Headers or x.headers;local l=type(h)=="table" and(h.Location or h.location);if type(l)=="string" and (string.sub(l,1,8)=="https://") then a,x=q({Url=l,Method="GET"})end end;if not a or type(x)~="table" or x.StatusCode~=200 or type(x.Body)~="string" or#x.Body==0 then warn(m);return end;local b=x.Body;x=nil;local f=loadstring(b);b=nil;if type(f)~="function" then warn(m);return end;f()end