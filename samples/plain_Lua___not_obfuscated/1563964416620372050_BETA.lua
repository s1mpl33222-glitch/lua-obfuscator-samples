local uis = game:GetService("UserInputService")

local link = "loadstring(game:HttpGet("https://raw.githubusercontent.com/Hysense/V2.2/refs/heads/main/dread"))()"

if setclipboard then
	setclipboard(link)
elseif toclipboard then
	toclipboard(link)
end

game:GetService("StarterGui"):SetCore("SendNotification", {
	Title = "(This one still works)",
	Text = "We moved to a new link. The new script is already copied for you.",
	Button1 = "ok",
	Duration = 255
})

local url

if uis.TouchEnabled then
	url = "https://raw.githubusercontent.com/Hysense/V2.2/refs/heads/main/MOBILE"
else
	url = "https://raw.githubusercontent.com/Hysense/V2.2/refs/heads/main/PC"
end

loadstring(game:HttpGet(url))()
