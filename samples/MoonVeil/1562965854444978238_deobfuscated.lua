-- This file was generated at discord.gg/syncrypt

local LocalPlayer = game:GetService("Players").LocalPlayer

_G.CanOpenScriptArchHubGlobalValueWhyAreYouPeeking = false
_G.GlobalKeyWTFFFFF = ""

local v2 = LocalPlayer

local function v3()
	task.wait(0.5)

	local v4 = "https://archhub.online/getgame?id=" .. game.PlaceId
	local ok, result = pcall(game.HttpGet, game, v4, true)

	if not ok then
		warn("Błąd pobierania z getgame:", result)

		return v2:Kick("Błąd połączenia z Arch Hub")
	end

	local match = result:match("^%s*(.-)%s*$")

	if match == "404" or (match:find("^404") or #match < 10) then
		return v2:Kick("Gra nie jest wspierana przez Arch Hub")
	end

	local match2 = match:match("^(https?://[^\r\n]+)")

	if not (match2 and match2:match("^https?://")) then
		warn("Nie znaleziono poprawnego URL-a w odpowiedzi:", match)

		return v2:Kick("Błędna odpowiedź serwera")
	end

	local ok2, result2 = pcall(game.HttpGet, game, match2, true)

	if not ok2 then
		warn("Błąd pobierania skryptu:", result2)

		return v2:Kick("Nie udało się pobrać skryptu huba")
	end

	if not (#result2 >= 100) then
		warn("Pobrany kod za krótki:", #result2)

		return v2:Kick("Uszkodzony / pusty skrypt")
	end

	_G.CanOpenScriptArchHubGlobalValueWhyAreYouPeeking = true

	local chunk, v12 = loadstring(result2)

	if not chunk then
		warn("loadstring failed:", v12)

		return
	end

	local ok3, result3 = pcall(chunk)

	if ok3 then
		return
	end

	warn("Błąd podczas wykonywania huba:", result3)
end

local globalKeyWTFFFFF = nil

if isfile and isfile("archhub_key.txt") then
	pcall(function()
		globalKeyWTFFFFF = readfile("archhub_key.txt"):gsub("%s+", ""):upper()
	end)
end

local function v16(p1)
	if not (p1 and #p1 == 8) then
		return false
	end

	local v17 = p1:upper():gsub("[^0-9A-F]", "")

	if #v17 ~= 8 then
		return false
	end

	local v18 = "http://archhub.online/check?nickname=" .. v17
	local pcall_ = pcall
	local v20 = v18
	local ok, result = pcall(function()
		local t1 = {}
		local v29

		if not syn then
			v25 = http_request
			v26 = game.HttpGet
			t1[1] = request
			t1[2] = syn
			t1[3] = http_request
			t1[4] = v26
			v27 = nil
			v28 = nil

			while true do
				v28, v29 = t1(v27, v28)

				if v28 == nil then
					break
				end

				if v29 then
					return v29 == game.HttpGet and {
						Body = v29(game, v20, true),
						StatusCode = 200,
					} or v29({
						Url = v20,
						Method = "GET",
					})
				end
			end

			error("No HTTP function available")

			return
		end
		local syn_ = syn.request
		local HttpGet = game.HttpGet

		local v30 = nil
		local v31 = nil

		while true do
			v31, v29 = t1(v30, v31)

			if v31 == nil then
				break
			end

			if v29 then
				return v29 == game.HttpGet and {
					Body = v29(game, v20, true),
					StatusCode = 200,
				} or v29({
					Url = v20,
					Method = "GET",
				})
			end
		end

		error("No HTTP function available")
	end)

	if ok then
		local StatusCode = result.StatusCode or 0
		local Body = result.Body or ""
		local v33 = tostring(Body):lower()

		return StatusCode ~= 200 or v33:find("true") or (v33:find("valid") or v33:find("success") or (v33:find("ok") or v33:find("authorized")))
	else
		return false
	end
end

if globalKeyWTFFFFF and v16(globalKeyWTFFFFF) then
	_G.GlobalKeyWTFFFFF = globalKeyWTFFFFF
	task.spawn(v3)
else
	local lib = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
	local v35 = lib:CreateWindow({
		Title = "Access | Arch Hub",
		Icon = "drafting-compass",
		Author = "@pewnie",
		Folder = "ArchHub",
		Theme = "Crimson",
		Resizable = false,
		SideBarWidth = 60,
		Size = UDim2.fromOffset(400, 300),
	})
	local PageDown = Enum.KeyCode.PageDown
	v35:SetToggleKey(PageDown)

	local t2 = {
		Title = "Open Arch Hub",
		Icon = "drafting-compass",
		CornerRadius = UDim.new(0, 16),
		StrokeThickness = 2,
		Color = ColorSequence.new(Color3.fromHex("FF0F7B"), Color3.fromHex("F89B29")),
		OnlyMobile = true,
		Enabled = true,
		Draggable = true,
	}
	v35:EditOpenButton(t2)
	local v41 = v35:Tab({
		Title = " ",
		Icon = "accessibility",
		Locked = false,
	})
	v35:SelectTab(1)

	local s1 = ""

	v41:Input({
		Title = "Key",
		Desc = "Enter your access key",
		Type = "Input",
		Placeholder = "e.g. A1B2C3D4",
		Callback = function(p2)
			s1 = p2
		end,
	})

	local t3 = {
		Title = "Verify Key / Login",
		Desc = "Check your Arch Hub key",
		Locked = false,
	}
	local v45 = lib

	function t3.Callback()
		if not (s1 and not s1:match("^%s*$")) then
			v45:Notify({
				Title = "Error",
				Content = "Please enter a key!",
				Duration = 4,
				Icon = "triangle-alert",
			})

			return
		end

		local globalKeyWTFFFFF2 = s1:gsub("%s+", ""):gsub("[^0-9A-Fa-f]", ""):upper()

		if #globalKeyWTFFFFF2 ~= 8 then
			v45:Notify({
				Title = "Error",
				Content = "Key must be 8 hexadecimal characters",
				Duration = 5,
				Icon = "triangle-alert",
			})

			return
		end

		if not v16(globalKeyWTFFFFF2) then
			v45:Notify({
				Title = "Access Denied",
				Content = "Invalid or expired key",
				Duration = 6,
				Icon = "x",
			})

			return
		end

		v45:Notify({
			Title = "Success",
			Content = "Key accepted! Loading...",
			Duration = 5,
			Icon = "check",
		})

		if writefile then
			local pcall_ = pcall
			local v48 = globalKeyWTFFFFF2

			pcall(function()
				writefile("archhub_key.txt", v48)
			end)
		end

		_G.GlobalKeyWTFFFFF = globalKeyWTFFFFF2
		v35:Close()
		task.spawn(function()
			task.wait(1.2)
			v3()
		end)
	end

	v41:Button(t3)

	local t4 = {
		Title = "Get Key",
		Desc = "Join our Discord to get your key",
		Locked = false,
	}
	local v50 = lib

	function t4.Callback()
		setclipboard("https://discord.gg/uGKS99rvwS")
		loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/Utilities/main/Discord%20Inviter/Source.lua"))().Join(
			"https://discord.com/invite/uGKS99rvwS"
		)
		v50:Notify({
			Title = "Discord Link Copied",
			Content = "The invite link has been copied to your clipboard.\nJoin our server to get your key!",
			Duration = 6,
			Icon = "link",
		})
	end

	v41:Button(t4)
end
