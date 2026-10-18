-- This file was generated at discord.gg/syncrypt

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
Players = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local t1 = {
	["ApiUrl"] = "https://fourhub-api.vercel.app",
	["Logo"] = "rbxassetid://123035506495251",
	["DiscordUrl"] = "https://discord.gg/cUwR4tUJv3",
	["PremiumUrl"] = "https://fourhub13.vercel.app/fourpremium.json",
	["ScriptUrl"] = "https://fourhub13.vercel.app/NAGI1171.lua",
	["KeyFolder"] = "FourHub",
	["KeyFile"] = "FourHub/savedkey.txt",
	["ExpiryFile"] = "FourHub/key_expiry.txt",
	["KeyDuration"] = 86400
}
local syn_ = syn
if syn_ then
    syn_ = syn.request
end
if not syn_ then
    syn_ = http

    if syn_ then
        syn_ = http.request
    end

    syn_ = syn_ or (http_request or request)
end
local UserId = Players.UserId
UserId = tostring(UserId)
local function parent(p1)
    local isfile_ = isfile

    if not isfile_ then
        return isfile_
    end

    isfile_ = isfile(p1)

    return isfile_
end
local function v11(p2)
    if p2.lifetime then
        return "Lifetime access"
    else
        if p2.expiresAt then
            local v12 = p2.expiresAt - os.time()

            v12 = math.max(0, v12)

            local v13 = v12 / 86400

            v13 = math.floor(v13)
            v12 = v12 % 86400 / 3600
            v12 = math.floor(v12)

            return string.format("%d days, %d hours remaining", v13, v12)
        else
            return "Active subscription"
        end

        return
    end
end
local function v14()
    local function v15()
        return game:HttpGetAsync(t1.PremiumUrl)
    end

    local result

    v15, result = pcall(v15)

    if not (v15 and result) then
        return {
			["active"] = false,
			["unavailable"] = true
		}
    end

    v15 = function()
        return HttpService:JSONDecode(result)
    end
    v15, result = pcall(v15)

    if not v15 or type(result) ~= "table" then
        return {
			["active"] = false,
			["unavailable"] = true
		}
    end

    v15 = result[UserId]

    if type(v15) ~= "table" and true or v15.premium ~= true then
        return {
			["active"] = false
		}
    end

    result = tonumber(v15.expiresAt)

    local v17 = v15.plan == "lifetime" or v15.plan == "Lifetime"
    local v18 = not v17

    if not v18 then
        return v18 and {
			["active"] = false,
			["expired"] = true,
			["plan"] = v15.plan or "expired"
		} or {
			["active"] = true,
			["plan"] = v15.plan or "premium",
			["expiresAt"] = result,
			["lifetime"] = v17
		}
    end

    v18 = not result or result <= os.time()

    return v18 and {
		["active"] = false,
		["expired"] = true,
		["plan"] = v15.plan or "expired"
	} or {
		["active"] = true,
		["plan"] = v15.plan or "premium",
		["expiresAt"] = result,
		["lifetime"] = v17
	}
end
local function v19(_)

    if type(loadstring) ~= "function" then
        return false, "loadstring is unavailable"
    end
end
parent = function()
    local readfile_ = readfile
    local result, ok, result2

    if not readfile_ then
        if readfile_ then
            readfile_, result = pcall(readfile, t1.KeyFile)
            ok, result2 = pcall(readfile, t1.ExpiryFile)
            result2 = tonumber(result2)

            if readfile_ then
                if not ok then
                    if ok then
                        return result, result2
                    else
                        return nil
                    end

                    return
                end

                if result then
                    ok = result ~= ""

                    if not ok then
                        if ok then
                            return result, result2
                        else
                            return nil
                        end

                        return
                    end

                    if result2 then
                        ok = os.time() < result2
                    else
                        ok = result2
                    end
                else
                    ok = result
                end
            else
                ok = readfile_
            end

            if ok then
                return result, result2
            else
                return nil
            end

            return
        else
            return nil
        end

        return
    end

    readfile_ = parent(t1.KeyFile)

    if not readfile_ then
        if readfile_ then
            readfile_, result = pcall(readfile, t1.KeyFile)
            ok, result2 = pcall(readfile, t1.ExpiryFile)
            result2 = tonumber(result2)

            if readfile_ then
                if not ok then
                    if ok then
                        return result, result2
                    else
                        return nil
                    end

                    return
                end

                if result then
                    ok = result ~= ""

                    if not ok then
                        if ok then
                            return result, result2
                        else
                            return nil
                        end

                        return
                    end

                    if result2 then
                        ok = os.time() < result2
                    else
                        ok = result2
                    end
                else
                    ok = result
                end
            else
                ok = readfile_
            end

            if ok then
                return result, result2
            else
                return nil
            end

            return
        else
            return nil
        end

        return
    end

    readfile_ = parent(t1.ExpiryFile)

    if readfile_ then
        readfile_, result = pcall(readfile, t1.KeyFile)
        ok, result2 = pcall(readfile, t1.ExpiryFile)
        result2 = tonumber(result2)

        if readfile_ then
            if not ok then
                if ok then
                    return result, result2
                else
                    return nil
                end

                return
            end

            if result then
                ok = result ~= ""

                if not ok then
                    if ok then
                        return result, result2
                    else
                        return nil
                    end

                    return
                end

                if result2 then
                    ok = os.time() < result2
                else
                    ok = result2
                end
            else
                ok = result
            end
        else
            ok = readfile_
        end

        if ok then
            return result, result2
        else
            return nil
        end

        return
    else
        return nil
    end
end
local v25
HttpService = function(p3)
    if not syn_ then
        return false, "Executor does not support HTTP requests"
    end
    local v26 = tostring(p3):gsub("%s+", "")
    local v27
    local function v28()
        local t2 = {
			["key"] = v27,
			["hwid"] = UserId
		}

        return syn_({
			["Url"] = t1.ApiUrl .. "/api/validate",
			["Method"] = "POST",
			["Headers"] = {
				["Content-Type"] = "application/json"
			},
			["Body"] = HttpService:JSONEncode(t2)
		})
    end
    v27 = v26
    v26, v28 = pcall(v28)
    if not (v26 and (v28 and v28.Body)) then
        return false, "Failed to connect to authentication server"
    end
    local data
    v26 = function()
        data = HttpService:JSONDecode(v28.Body)
    end
    data = nil
    pcall(v26)
    v26 = data
    if v26 then
        v26 = data.valid
    end
    if v26 then
        v25(v27, data.remaining_seconds)

        return true, data.message or "Authenticated successfully!", data
    end
    v26 = false
    v28 = data
    if not v28 then
        return v26, v28 or "Invalid or expired key!", data
    end
    v28 = data.message

    return v26, v28 or "Invalid or expired key!", data
end
v25 = function(p4, p5)
    local writefile_ = writefile

    if writefile_ then
        writefile_ = makefolder
    end

    if not writefile_ then
        return false
    end

    pcall(makefolder, t1.KeyFolder)
    writefile_ = tonumber(p5) or t1.KeyDuration

    local ok = pcall(writefile, t1.KeyFile, tostring(p4):gsub("%s+", ""))

    if not ok then
        return ok
    end

    ok = pcall

    local writefile_2 = writefile
    local ExpiryFile = t1.ExpiryFile

    writefile_ = os.time() + writefile_
    ok = ok(writefile_2, ExpiryFile, (tostring(writefile_)))

    return ok
end
syn_ = function()
    local v35 = v14()

    if v35.active then
        return {
			["granted"] = true,
			["source"] = "premium",
			["plan"] = v35.plan,
			["expiresAt"] = v35.expiresAt,
			["lifetime"] = v35.lifetime
		}
    else
        local v36, v37 = parent()

        if v36 and v37 then
            v35 = v37 - os.time()

            local v38 = v35 / 3600

            v38 = math.floor(v38)
            v35 = v35 % 3600 / 60
            v35 = math.floor(v35)

            return {
				["granted"] = true,
				["source"] = "key",
				["plan"] = "free",
				["key"] = v36,
				["expiresAt"] = v37,
				["remainingFormatted"] = string.format("%02dh %02dm remaining", v38, v35),
				["lifetime"] = false
			}
        else
            return {
				["granted"] = false,
				["reason"] = v35.expired and "Premium expired" or "Access required"
			}
        end

        return
    end
end
parent = CoreGui:FindFirstChild("FourHubLoader")
if not parent then
    parent = Instance.new("ScreenGui")
    parent.Name = "FourHubLoader"
    parent.ResetOnSpawn = false
    parent.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    parent.Parent = CoreGui
    CoreGui = Instance.new("Frame")
    CoreGui.Name = "Window"
    CoreGui.Size = UDim2.new(0, 460, 0, 400)
    CoreGui.Position = UDim2.new(0.5, -230, 0.5, -200)
    CoreGui.BackgroundColor3 = Color3.fromRGB(7, 17, 34)
    CoreGui.BorderSizePixel = 0
    CoreGui.Active = true
    CoreGui.Parent = parent
    Instance.new("UICorner", CoreGui).CornerRadius = UDim.new(0, 14)
    v14 = Instance.new("UIStroke", CoreGui)
    v14.Color = Color3.fromRGB(55, 166, 239)
    v14.Transparency = 0.25
    v14.Thickness = 1.5
    v14 = Instance.new("Frame", CoreGui)
    v14.Size = UDim2.new(1, 0, 0, 4)
    v14.BackgroundColor3 = Color3.fromRGB(91, 214, 255)
    v14.BorderSizePixel = 0
    Instance.new("UICorner", v14).CornerRadius = UDim.new(0, 14)
    v14 = Instance.new("ImageLabel", CoreGui)
    v14.Size = UDim2.new(0, 42, 0, 42)
    v14.Position = UDim2.new(0, 18, 0, 12)
    v14.BackgroundTransparency = 1
    v14.Image = t1.Logo
    v14.ScaleType = Enum.ScaleType.Fit
    Instance.new("UICorner", v14).CornerRadius = UDim.new(1, 0)
    v14 = Instance.new("TextLabel", CoreGui)
    v14.Size = UDim2.new(1, -260, 0, 24)
    v14.Position = UDim2.new(0, 68, 0, 14)
    v14.BackgroundTransparency = 1
    v14.Text = "FOURHUB / ACCESS"
    v14.Font = Enum.Font.GothamBold
    v14.TextSize = 16
    v14.TextXAlignment = Enum.TextXAlignment.Left
    v14.TextColor3 = Color3.fromRGB(225, 246, 255)
    v14 = Instance.new("TextLabel", CoreGui)
    v14.Size = UDim2.new(1, -260, 0, 18)
    v14.Position = UDim2.new(0, 68, 0, 36)
    v14.BackgroundTransparency = 1
    v14.Text = "\240\159\148\144 Secure Gateway"
    v14.Font = Enum.Font.Gotham
    v14.TextSize = 11
    v14.TextXAlignment = Enum.TextXAlignment.Left
    v14.TextColor3 = Color3.fromRGB(137, 169, 199)
    v14 = Instance.new("TextButton", CoreGui)
    v14.Size = UDim2.new(0, 28, 0, 28)
    v14.Position = UDim2.new(1, -38, 0, 14)
    v14.BackgroundColor3 = Color3.fromRGB(18, 42, 70)
    v14.Text = "X"
    v14.Font = Enum.Font.GothamBold
    v14.TextSize = 12
    v14.TextColor3 = Color3.fromRGB(191, 222, 241)
    v14.AutoButtonColor = false
    Instance.new("UICorner", v14).CornerRadius = UDim.new(0, 8)
    v14.MouseEnter:Connect(function()
        v14.BackgroundColor3 = Color3.fromRGB(185, 28, 28)
    end)
    v14.MouseLeave:Connect(function()
        v14.BackgroundColor3 = Color3.fromRGB(18, 42, 70)
    end)
    v14.MouseButton1Click:Connect(function()
        parent:Destroy()
    end)
    v14 = Instance.new("ImageLabel", CoreGui)
    v14.Size = UDim2.new(0, 34, 0, 34)
    v14.Position = UDim2.new(1, -80, 0, 12)
    v14.BackgroundColor3 = Color3.fromRGB(13, 39, 65)
    local UserId2 = Players.UserId
    v14.Image = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(UserId2) .. "&w=150&h=150"
    v14.ScaleType = Enum.ScaleType.Crop
    Instance.new("UICorner", v14).CornerRadius = UDim.new(1, 0)
    v14 = Instance.new("UIStroke", v14)
    v14.Color = Color3.fromRGB(56, 189, 248)
    v14.Thickness = 1
    v14 = Instance.new("TextLabel", CoreGui)
    v14.Size = UDim2.new(0, 110, 0, 34)
    v14.Position = UDim2.new(1, -195, 0, 12)
    v14.BackgroundTransparency = 1
    v14.Text = Players.DisplayName
    v14.Font = Enum.Font.GothamBold
    v14.TextSize = 12
    v14.TextXAlignment = Enum.TextXAlignment.Right
    v14.TextColor3 = Color3.fromRGB(211, 235, 249)
    Players = Instance.new("TextLabel", CoreGui)
    Players.Size = UDim2.new(1, -40, 0, 34)
    Players.Position = UDim2.new(0, 20, 0, 72)
    Players.BackgroundColor3 = Color3.fromRGB(10, 31, 54)
    Players.Text = "\240\159\148\142 Checking your access..."
    Players.Font = Enum.Font.GothamSemibold
    Players.TextSize = 12
    Players.TextXAlignment = Enum.TextXAlignment.Left
    Players.TextColor3 = Color3.fromRGB(139, 225, 255)
    Instance.new("UICorner", Players).CornerRadius = UDim.new(0, 7)
    Instance.new("UIPadding", Players).PaddingLeft = UDim.new(0, 12)
    v14 = Instance.new("Frame", CoreGui)
    v14.Size = UDim2.new(1, -40, 0, 68)
    v14.Position = UDim2.new(0, 20, 0, 116)
    v14.BackgroundColor3 = Color3.fromRGB(10, 31, 54)
    v14.BorderSizePixel = 0
    Instance.new("UICorner", v14).CornerRadius = UDim.new(0, 8)
    UserId2 = Instance.new("TextLabel", v14)
    UserId2.Size = UDim2.new(1, -22, 0, 23)
    UserId2.Position = UDim2.new(0, 11, 0, 8)
    UserId2.BackgroundTransparency = 1
    UserId2.Text = "\226\173\144 Checking subscription..."
    UserId2.Font = Enum.Font.GothamBold
    UserId2.TextSize = 13
    UserId2.TextXAlignment = Enum.TextXAlignment.Left
    UserId2.TextColor3 = Color3.fromRGB(139, 225, 255)
    v14 = Instance.new("TextLabel", v14)
    v14.Size = UDim2.new(1, -22, 0, 20)
    v14.Position = UDim2.new(0, 11, 0, 35)
    v14.BackgroundTransparency = 1
    v14.Text = "Loading account details..."
    v14.Font = Enum.Font.Gotham
    v14.TextSize = 11
    v14.TextXAlignment = Enum.TextXAlignment.Left
    v14.TextColor3 = Color3.fromRGB(139, 169, 199)
    local TextBox = Instance.new("TextBox", CoreGui)
    TextBox.Size = UDim2.new(1, -145, 0, 38)
    TextBox.Position = UDim2.new(0, 20, 0, 198)
    TextBox.BackgroundColor3 = Color3.fromRGB(11, 27, 48)
    TextBox.BorderSizePixel = 0
    TextBox.ClearTextOnFocus = false
    TextBox.PlaceholderText = "Paste your 24-hour key here"
    TextBox.PlaceholderColor3 = Color3.fromRGB(107, 139, 169)
    TextBox.Text = ""
    TextBox.TextColor3 = Color3.fromRGB(56, 189, 248)
    TextBox.Font = Enum.Font.Gotham
    TextBox.TextSize = 12
    Instance.new("UICorner", TextBox).CornerRadius = UDim.new(0, 7)
    local TextButton = Instance.new("TextButton", CoreGui)
    TextButton.Size = UDim2.new(0, 100, 0, 38)
    TextButton.Position = UDim2.new(1, -120, 0, 198)
    TextButton.BackgroundColor3 = Color3.fromRGB(37, 139, 204)
    TextButton.Text = "VERIFY"
    TextButton.Font = Enum.Font.GothamBold
    TextButton.TextSize = 12
    TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextButton.AutoButtonColor = false
    Instance.new("UICorner", TextButton).CornerRadius = UDim.new(0, 7)
    local TextButton2 = Instance.new("TextButton", CoreGui)
    TextButton2.Size = UDim2.new(0.5, -26, 0, 36)
    TextButton2.Position = UDim2.new(0, 20, 0, 248)
    TextButton2.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
    TextButton2.Text = "\240\159\146\172 DISCORD"
    TextButton2.Font = Enum.Font.GothamBold
    TextButton2.TextSize = 11
    TextButton2.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextButton2.AutoButtonColor = false
    Instance.new("UICorner", TextButton2).CornerRadius = UDim.new(0, 7)
    local TextButton3 = Instance.new("TextButton", CoreGui)
    TextButton3.Size = UDim2.new(0.5, -26, 0, 36)
    TextButton3.Position = UDim2.new(0.5, 6, 0, 248)
    TextButton3.BackgroundColor3 = Color3.fromRGB(18, 65, 94)
    TextButton3.Text = "\240\159\148\145 GET DAILY KEY"
    TextButton3.Font = Enum.Font.GothamBold
    TextButton3.TextSize = 11
    TextButton3.TextColor3 = Color3.fromRGB(220, 247, 255)
    TextButton3.AutoButtonColor = false
    Instance.new("UICorner", TextButton3).CornerRadius = UDim.new(0, 7)
    local TextButton4 = Instance.new("TextButton", CoreGui)
    TextButton4.Size = UDim2.new(1, -40, 0, 42)
    TextButton4.Position = UDim2.new(0, 20, 0, 298)
    TextButton4.BackgroundColor3 = Color3.fromRGB(31, 118, 92)
    TextButton4.Text = "\240\159\154\128 EXECUTE SCRIPT"
    TextButton4.Font = Enum.Font.GothamBold
    TextButton4.TextSize = 13
    TextButton4.TextColor3 = Color3.fromRGB(226, 255, 239)
    TextButton4.AutoButtonColor = false
    TextButton4.Visible = false
    Instance.new("UICorner", TextButton4).CornerRadius = UDim.new(0, 8)
    local TextLabel = Instance.new("TextLabel", CoreGui)
    TextLabel.Size = UDim2.new(1, -40, 0, 22)
    TextLabel.Position = UDim2.new(0, 20, 0, 365)
    TextLabel.BackgroundTransparency = 1
    TextLabel.Text = "FourHub Subscription System \226\128\162 2026"
    TextLabel.Font = Enum.Font.Gotham
    TextLabel.TextSize = 10
    TextLabel.TextXAlignment = Enum.TextXAlignment.Center
    TextLabel.TextColor3 = Color3.fromRGB(91, 124, 153)
    TextLabel = Instance.new("Frame", CoreGui)
    TextLabel.Size = UDim2.new(1, 0, 1, 0)
    TextLabel.Position = UDim2.new(0, 0, 0, 0)
    TextLabel.BackgroundColor3 = Color3.fromRGB(7, 17, 34)
    TextLabel.ZIndex = 10
    Instance.new("UICorner", TextLabel).CornerRadius = UDim.new(0, 14)
    local ImageLabel = Instance.new("ImageLabel", TextLabel)
    ImageLabel.Size = UDim2.new(0, 64, 0, 64)
    ImageLabel.Position = UDim2.new(0.5, -32, 0.5, -45)
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.Image = t1.Logo
    ImageLabel.ZIndex = 11
    Instance.new("UICorner", ImageLabel).CornerRadius = UDim.new(1, 0)
    local TextLabel2 = Instance.new("TextLabel", TextLabel)
    TextLabel2.Size = UDim2.new(1, 0, 0, 30)
    TextLabel2.Position = UDim2.new(0, 0, 0.5, 30)
    TextLabel2.BackgroundTransparency = 1
    TextLabel2.Text = "Connecting to FourHub..."
    TextLabel2.Font = Enum.Font.GothamBold
    TextLabel2.TextSize = 13
    TextLabel2.TextColor3 = Color3.fromRGB(139, 225, 255)
    TextLabel2.ZIndex = 11
    local tween = TweenService:Create(ImageLabel, TweenInfo.new(1.8, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), {
		["Rotation"] = 360
	})
    tween:Play()
    local u49 = false
    local Position
    local Position2
    CoreGui.InputBegan:Connect(function(input)
        if not (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            return
        end

        u49 = true
        Position = input.Position
        Position2 = CoreGui.Position
        input.Changed:Connect(function()
            if input.UserInputState ~= Enum.UserInputState.End then
                return
            end

            u49 = false
        end)
    end)
    CoreGui = function(input)
        local v52 = u49

        if v52 then
            v52 = input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch
        end

        if not v52 then
            return
        end

        v52 = input.Position - Position
        CoreGui.Position = UDim2.new(Position2.X.Scale, Position2.X.Offset + v52.X, Position2.Y.Scale, Position2.Y.Offset + v52.Y)
    end
    v11 = function()
        local remainingFormatted = syn_()

        if not remainingFormatted.granted then
            UserId2.Text = "\240\159\148\146 ACCESS REQUIRED"
            v14.Text = "No active subscription found on this account."
            UserId2.TextColor3 = Color3.fromRGB(255, 190, 122)
            Players.Text = "\240\159\146\161 Complete a checkpoint or enter key below."
            Players.TextColor3 = Color3.fromRGB(255, 190, 122)
            TextBox.Visible = true
            TextButton.Visible = true
            TextButton2.Visible = true
            TextButton3.Visible = true
            TextButton4.Visible = false

            return
        end

        local v54 = UserId2
        local upper = string.upper
        local plan = remainingFormatted.plan or "Active"

        v54.Text = "\226\173\144 " .. upper((tostring(plan))) .. " ACCESS"
        v54 = v14
        upper = "Text"
        plan = remainingFormatted.source == "premium"

        if plan then
            plan = v11({
				["lifetime"] = remainingFormatted.lifetime,
				["expiresAt"] = remainingFormatted.expiresAt
			})
        end

        if plan then
            v54[upper] = plan
            UserId2.TextColor3 = Color3.fromRGB(139, 255, 194)
            Players.Text = "\226\156\133 Access verified. Ready to launch."
            Players.TextColor3 = Color3.fromRGB(139, 255, 194)
            TextBox.Visible = false
            TextButton.Visible = false
            TextButton2.Visible = false
            TextButton3.Visible = false
            TextButton4.Visible = true

            return
        end

        remainingFormatted = remainingFormatted.remainingFormatted or "Key active for 24h"
        plan = tostring(remainingFormatted)
        v54[upper] = plan
        UserId2.TextColor3 = Color3.fromRGB(139, 255, 194)
        Players.Text = "\226\156\133 Access verified. Ready to launch."
        Players.TextColor3 = Color3.fromRGB(139, 255, 194)
        TextBox.Visible = false
        TextButton.Visible = false
        TextButton2.Visible = false
        TextButton3.Visible = false
        TextButton4.Visible = true
    end
    UserInputService.InputChanged:Connect(CoreGui)
    UserInputService = function()
        TextButton4.Active = false
        TextButton4.Text = "\226\143\179 LOADING SCRIPT..."
        Players.Text = "\226\154\153\239\184\143 Executing your script Rivals..."
        Players.TextColor3 = Color3.fromRGB(139, 255, 194)
        task.spawn(function()
            local t3, v58 = v19(t1.ScriptUrl)
            if t3 then
                Players.Text = "\226\156\133 Script loaded successfully."
                TextButton4.Text = "\226\156\133 SCRIPT ACTIVE"
                task.wait(1)
                parent:Destroy()

                return
            else
                Players.Text = "\226\157\140 Load failed: " .. tostring(v58)
                Players.TextColor3 = Color3.fromRGB(255, 133, 151)
                TextButton4.Active = true
                TextButton4.Text = "\240\159\148\129 RETRY SCRIPT"

                return
            end
        end)
    end
    TextButton.MouseButton1Click:Connect(function()
        local v59 = TextBox.Text:gsub("%s+", "")

        if v59 == "" then
            Players.Text = "\226\154\160\239\184\143 Please enter a key."
            Players.TextColor3 = Color3.fromRGB(255, 133, 151)

            return
        end
    end)
    TextBox.FocusLost:Connect(function(enterPressed)
        if not enterPressed then
            return
        end

        TextButton:Activate()
    end)
    TextButton3.MouseButton1Click:Connect(function()
        local v60 = t1.ApiUrl .. "/api/hub?hwid=" .. UserId

        if setclipboard then
            setclipboard(v60)
            Players.Text = "\240\159\148\145 Portal link copied to clipboard!"

            return
        else
            Players.Text = "\240\159\148\145 Copy link: " .. v60

            return
        end
    end)
    TextButton2.MouseButton1Click:Connect(function()
        if setclipboard then
            setclipboard(t1.DiscordUrl)
            Players.Text = "\240\159\146\172 Discord link copied to clipboard!"

            return
        else
            Players.Text = "\240\159\146\172 Link: " .. t1.DiscordUrl

            return
        end
    end)
    TextButton4.MouseButton1Click:Connect(function()
        if not syn_().granted then
            return
        end

        UserInputService()
    end)
    task.spawn(function()
        for _, v in ipairs({
			"Initializing FourHub...",
			"Checking Premium database...",
			"Verifying device license...",
			"Finalizing access..."
		}) do
            TextLabel2.Text = v
            task.wait(0.4)
        end

        v11()

        local v63 = TweenService
        local v64 = TextLabel
        local tweenInfo = TweenInfo.new(0.5)

        v63.Create(v63, v64, tweenInfo, {
			["BackgroundTransparency"] = 1
		}):Play()
        TweenService:Create(ImageLabel, TweenInfo.new(0.5), {
			["ImageTransparency"] = 1
		}):Play()
        TweenService:Create(TextLabel2, TweenInfo.new(0.5), {
			["TextTransparency"] = 1
		}):Play()
        task.wait(0.5)
        TextLabel:Destroy()
    end)

    return
end
parent.Enabled = true
Players = parent:FindFirstChild("Window")
if not Players then
    return
end
Players.Visible = true
