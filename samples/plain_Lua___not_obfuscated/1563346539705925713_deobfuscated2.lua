-- This file was generated at discord.gg/syncrypt

Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Rayfield_ = Rayfield
local t1 = {
	Name = "+1 Backflip Keyboard Escape",
	LoadingTitle = "KhSaeedHub",
	LoadingSubtitle = "Please, Join discord for more scripts!",
	ConfigurationSaving = {
		Enabled = true,
		FolderName = KhSaeedHub,
		FileName = "KhSaeedHub"
	},
	Discord = {
		Enabled = true,
		Invite = "37xqzu6eBF",
		RememberJoins = true
	},
	KeySystem = false,
	KeySettings = {
		Title = "KhSaeedHub",
		Subtitle = "Thank you for your support!",
		Note = "https://khsaeedhub.vercel.app/",
		FileName = "KhSaeedHub",
		SaveKey = true,
		GrabKeyFromSite = true,
		Key = { "https://khsaeedhub.vercel.app/api/key/raw/" }
	}
}

Window = Rayfield_:CreateWindow(t1)
Tab = Window:CreateTab("Main")
Section = Tab:CreateSection("Win 🏆 World 1")

local Tab_ = Tab

Button = Tab_.CreateButton(Tab_, {
	Name = "Win (Stage 20)",
	Callback = function()
		getWin(20)
	end
})
Toggle = Tab:CreateToggle({
	Name = "Auto Win (Stage 20)",
	CurrentValue = false,
	Flag = "Toggle",
	Callback = function(p1)
		Win2 = p1

		function get2()
			if Win2 then
				getWin(20)
				task.delay(0.15, get2)
			end
		end

		get2()
	end
})
Section = Tab:CreateSection("Win 🏆 World 2")

local Tab_2 = Tab

Button = Tab_2.CreateButton(Tab_2, {
	Name = "Win (Stage 10)",
	Callback = function()
		getWin(10)
	end
})
Toggle = Tab:CreateToggle({
	Name = "Auto Win (Stage 10)",
	CurrentValue = false,
	Flag = "Toggle",
	Callback = function(p2)
		Win1 = p2

		function get1()
			if Win1 then
				getWin(10)
				task.delay(0.15, get1)
			end
		end

		get1()
	end
})
Section = Tab:CreateSection("Rebirth ♻️")
Button = Tab:CreateButton({
	Name = "Rebirth",
	Callback = function()
		getRebirth()
	end
})

local Tab_3 = Tab

Toggle = Tab_3.CreateToggle(Tab_3, {
	Name = "Auto Rebirth",
	CurrentValue = false,
	Flag = "Toggle",
	Callback = function(p3)
		Rebirth = p3
		RebirthHeart = game:GetService("RunService").Heartbeat:Connect(function()
			local Rebirth_ = Rebirth

			if not Rebirth_ then
				if Rebirth_ then
					getRebirth()
				else
					RebirthHeart:Disconnect()
				end

				return
			end

			Rebirth_ = game:GetService("Players").LocalPlayer.Character

			if Rebirth_ then
				getRebirth()
			else
				RebirthHeart:Disconnect()
			end
		end)
	end
})
Section = Tab:CreateSection("")
Section = Tab:CreateSection("")
Tab = Window:CreateTab("Win")
Section = Tab:CreateSection("Win 🏆 (All Worlds)")

local Tab_4 = Tab

Button = Tab_4.CreateButton(Tab_4, {
	Name = "Stage 20",
	Callback = function()
		getWin(20)
	end
})

local Tab_5 = Tab

Button = Tab_5.CreateButton(Tab_5, {
	Name = "Stage 19",
	Callback = function()
		getWin(19)
	end
})

local Tab_6 = Tab

Button = Tab_6.CreateButton(Tab_6, {
	Name = "Stage 18",
	Callback = function()
		getWin(18)
	end
})
Button = Tab:CreateButton({
	Name = "Stage 17",
	Callback = function()
		getWin(17)
	end
})

local Tab_7 = Tab

Button = Tab_7.CreateButton(Tab_7, {
	Name = "Stage 16",
	Callback = function()
		getWin(16)
	end
})
Button = Tab:CreateButton({
	Name = "Stage 15",
	Callback = function()
		getWin(15)
	end
})

local Tab_8 = Tab

Button = Tab_8.CreateButton(Tab_8, {
	Name = "Stage 14",
	Callback = function()
		getWin(14)
	end
})
Button = Tab:CreateButton({
	Name = "Stage 13",
	Callback = function()
		getWin(13)
	end
})

local Tab_9 = Tab

Button = Tab_9.CreateButton(Tab_9, {
	Name = "Stage 12",
	Callback = function()
		getWin(12)
	end
})

local Tab_10 = Tab

Button = Tab_10.CreateButton(Tab_10, {
	Name = "Stage 11",
	Callback = function()
		getWin(11)
	end
})

local Tab_11 = Tab

Button = Tab_11.CreateButton(Tab_11, {
	Name = "Stage 10",
	Callback = function()
		getWin(10)
	end
})
Button = Tab:CreateButton({
	Name = "Stage 9",
	Callback = function()
		getWin(9)
	end
})
Button = Tab:CreateButton({
	Name = "Stage 8",
	Callback = function()
		getWin(8)
	end
})

local Tab_12 = Tab

Button = Tab_12.CreateButton(Tab_12, {
	Name = "Stage 7",
	Callback = function()
		getWin(7)
	end
})

local Tab_13 = Tab

Button = Tab_13.CreateButton(Tab_13, {
	Name = "Stage 6",
	Callback = function()
		getWin(6)
	end
})

local Tab_14 = Tab

Button = Tab_14.CreateButton(Tab_14, {
	Name = "Stage 5",
	Callback = function()
		getWin(5)
	end
})

local Tab_15 = Tab

Button = Tab_15.CreateButton(Tab_15, {
	Name = "Stage 4",
	Callback = function()
		getWin(4)
	end
})

local Tab_16 = Tab

Button = Tab_16.CreateButton(Tab_16, {
	Name = "Stage 3",
	Callback = function()
		getWin(3)
	end
})

local Tab_17 = Tab

Button = Tab_17.CreateButton(Tab_17, {
	Name = "Stage 2",
	Callback = function()
		getWin(2)
	end
})

local Tab_18 = Tab

Button = Tab_18.CreateButton(Tab_18, {
	Name = "Stage 1",
	Callback = function()
		getWin(1)
	end
})
Section = Tab:CreateSection("")
Section = Tab:CreateSection("")
Tab = Window:CreateTab("Credits", 14848261712)
Section = Tab:CreateSection("Credits to: KhSaeedHub")

local Tab_19 = Tab

Button = Tab_19.CreateButton(Tab_19, {
	Name = "RScripts Profile",
	Callback = function()
		setclipboard("https://rscripts.net/@KhSaeed90")
		Rayfield:Notify({
			Title = "Link is copied",
			Content = "Check RScripts profile page for more Scripts!",
			Duration = 5,
			Image = 14848261712
		})
	end
})

local Tab_20 = Tab

Button = Tab_20.CreateButton(Tab_20, {
	Name = "Scriptblox Profile",
	Callback = function()
		setclipboard("https://scriptblox.com/u/KhSaeed90")
		Rayfield:Notify({
			Title = "Link is copied",
			Content = "Check ScriptBlox profile page for more Scripts!",
			Duration = 5,
			Image = 14848261712
		})
	end
})

local Tab_21 = Tab

Button = Tab_21.CreateButton(Tab_21, {
	Name = "Discord Server",
	Callback = function()
		setclipboard("https://controlc.com/5572471c")
		Rayfield:Notify({
			Title = "Link is copied",
			Content = "Join discord server for more Scripts!",
			Duration = 5,
			Image = 14848261712
		})
	end
})

function getWin(p4)
	game:GetService("Players").LocalPlayer.Character:PivotTo(CFrame.new(workspace.Worlds["World" .. workspace:GetAttribute("ActiveWorldId")].GiveWins["Stage" .. p4]:GetPivot().Position + Vector3.new(0, 10, 0)))
end
function getRebirth()
	Progress = game:GetService("Players").LocalPlayer.PlayerGui.GUI.Frames.Rebirth.Bar.Progress

	if not (Progress.Size.X.Scale < 1) then
		game:GetService("ReplicatedStorage").Events.Rebirth.Request:InvokeServer()
	end
end
