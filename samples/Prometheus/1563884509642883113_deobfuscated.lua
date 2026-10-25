-- This file was generated at discord.gg/syncrypt

local lib = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
local v2 = lib:CreateWindow({
	Name = "Key System",
	LoadingTitle = "Loading...",
	LoadingSubtitle = "by idk",
	Theme = "Default",
	DisableRayfieldPrompts = false,
	DisableBuildWarnings = false
})
local Authentication = v2:CreateTab("Authentication", 4483345998)
local s1 = ""

Authentication.CreateButton(Authentication, {
	Name = "Get Key",
	Callback = function()
		setclipboard("https://subnise.com/link/SHorY")
		lib:Notify({
			Title = "Copied!",
			Content = "Complete the link to get your key.",
			Duration = 5,
			Image = 4483345998
		})
	end
})

local t1 = {
	Name = "Enter Key",
	PlaceholderText = "Enter your key here",
	RemoveTextAfterFocusLost = false,
	Callback = function(p1)
		s1 = p1
	end
}

Authentication.CreateInput(Authentication, t1)

local t2 = {
	Name = "Verify Key",
	Callback = function()
		local v7 = lib

		v7.Notify(v7, {
			Title = "Checking...",
			Content = "Verifying your key...",
			Duration = 2,
			Image = 4483345998
		})

		local ok, result = pcall(function()
			return game:HttpGet("https://pastebin.com/raw/PV9L5d33")
		end)

		if ok and result then
			if s1 == string.gsub(result, "%s+", "") then
				lib:Notify({
					Title = "Success!",
					Content = "Valid key! Loading...",
					Duration = 3,
					Image = 4483345998
				})
				task.wait(1)
				loadstring(game:HttpGet("https://raw.githubusercontent.com/MoziIOnTop/MoziIHub/refs/heads/main/SABScript"))()
				v2:Close()
				lib:Destroy()

				return
			else
				lib:Notify({
					Title = "Error",
					Content = "Invalid key!",
					Duration = 5,
					Image = 4483345998
				})

				return
			end
		else
			lib:Notify({
				Title = "Error",
				Content = "Failed to connect to server.",
				Duration = 5,
				Image = 4483345998
			})
		end
	end
}

Authentication.CreateButton(Authentication, t2)
