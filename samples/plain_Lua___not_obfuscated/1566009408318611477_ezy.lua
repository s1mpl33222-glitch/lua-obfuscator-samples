local httpService = game:GetService("HttpService")
local teleportService = game:GetService("TeleportService")
local userInputService = game:GetService("UserInputService")
local coreGui = game:GetService("CoreGui")
local marketplaceService = game:GetService("MarketplaceService")
local v1 = 2
local floor = math.floor
local v2 = 0
local v3 = {}
local char = string.char
local remove = table.remove
local random = math.random
local v4 = {}
local count = 0

while true do
  count = 1 + count

  if not (count <= 256) then
    break
  end

  local v5 = count
  v4[v5] = v5
end

while true do
  local v6 = remove(v4, (random(1, #v4)))
  v3[v6] = char(v6 - 1)

  if #v4 == 0 then
    break
  end
end

local v7 = {}

local function f1()
  if #v7 == 0 then
    v2 = (v2 * 213 + 27552854471197) % 35184372088832

    while true do
      v1 = v1 * 201 % 257

      if v1 ~= 1 then
        break
      end
    end

    local v8 = v1 % 32
    local v9 = floor(v2 / 2 ^ (13 - (v1 - v8) / 32)) % 4294967296 / 2 ^ v8
    local v10 = floor(v9 % 1 * 4294967296) + floor(v9)
    local v11 = v10 % 65536
    local v12 = (v10 - v11) / 65536
    v7 = { v11 % 256, (v11 - v11 % 256) / 256, v12 % 256, (v12 - v12 % 256) / 256 }
  end

  local v13 = #v7
  local v14 = v7[v13]
  v7[v13] = nil
  return v14
end

local v15 = {}
local v16 = setmetatable({}, { __index = v15, __metatable = nil })

local function f2(index, key)
  if v15[key] then
    return key
  else
    v7 = {}
    local text = ""
    v2 = key % 35184372088832
    v1 = key % 255 + 2
    v15[key] = ""
    local v17 = 204
    local v18 = #index
    local count2 = 0

    while true do
      count2 = 1 + count2

      if not (count2 <= v18) then
        break
      end

      v17 = (string.byte(index, count2) + f1() + v17) % 256
      text = text .. v3[v17 + 1]
    end

    v15[key] = text
    return key
  end
end

local v19 = game
f2("\190\18\191^\189(\173", 22126428612671)
local players = v19:GetService("Players")
local v20 = game
f2(")\11\159\11R\1\15\157Jg5", 32235748178594)
local virtualUser = v20:GetService("VirtualUser")
local localPlayer = players.LocalPlayer

f2(
  "\128١uC\224O\211\15\139~\t\133\1654\188\217y\r\1339\203M\19\154\141\209>0\163\191\129^\205\212\225Ƞ\177=\234\222>yVlX\251\136\159e\194\133\132A\164j\189\238[W\127\206Ƶr\6\182It\133\225\240\31",
  4982196996368
)

local v21 = {
  [82554996468034] = function()
    loadstring(game:HttpGet("https://gist.githubusercontent.com/EzySc/63f458a1b796081ee79014f442ae0f72/raw/EzyScriptPickAxe"))()
  end,
  [74218191398494] = function()
    loadstring(game:HttpGet("https://gist.githubusercontent.com/EzySc/05655cb94ab07389a10101fe74596c5d/raw/EzyScriptBike"))()
  end,
  [88730406335204] = function()
    loadstring(game:HttpGet("https://gist.githubusercontent.com/EzySc/fd7aa525c0def5e39ae67b514094e928/raw/EzyScriptScrappy"))()
  end,
  [79541556269616] = function()
    loadstring(game:HttpGet(v16[f2(
      '\1561\12\31\127\167\154\250T\133\183\193\243\150̓\195|\t\193\132\127\0A\226󂻘"\30\131\1273ߑ\176\141\5\24\140\252T.\144:m,\185wT7\165\213\232\189}gPOG\2552ς{\226jEUL\244\180\28\148\227\3C\21ǌv\178\21\164\197\127\149\133\15\175N\168\222',
      4828406859976
    )]))()
  end,
  [83038462357724] = function()
    loadstring(game:HttpGet("https://gist.githubusercontent.com/EzySc/bcc57bf32c471d19ee2a4b3b75a1b7e7/raw/EzySriptDig"))()
  end,
  [76427490154192] = function()
    loadstring(game:HttpGet("https://gist.githubusercontent.com/EzySc/7129156f68a1093dd9b1e97d2e2076cb/raw/EzyMount"))()
  end,
}

local v22 = syn and syn.request or http and http.request or http_request
  or fluxus and fluxus.request or request

local function f3(text2)
  local v23 = not text2
  local v24, v25, jsonDecode, v26

  if v23 or text2 == "" then
    return false, "ENTER A KEY FIRST."
  elseif text2 == "Arc" then
    return true, "DEVELOPER BYPASS GRANTED!"
  else
    v24 = "https://ezyscript-8957a-default-rtdb.asia-southeast1.firebasedatabase.app/"
      .. "/keys/" .. text2 .. ".json"

    local v27
    v27, v25 = pcall(function() return game:HttpGet(v24) end)

    if not v27 then
      return false, "COULD NOT REACH SERVER."
    elseif v25 == "null" then
      return false, "INVALID KEY."
    else
      jsonDecode = nil

      if not pcall(function() jsonDecode = httpService:JSONDecode(v25) end) or not jsonDecode then
        return false, "INVALID KEY FORMAT."
      end

      if os.time() > jsonDecode.expiry then
        return false, "KEY EXPIRED."
      end

      v26 = tostring(localPlayer.UserId)

      if jsonDecode.used == true and jsonDecode.usedBy ~= v26 then
        return false, "KEY USED BY ANOTHER ACCOUNT."
      end

      if jsonDecode.used ~= true then
        if v22 then
          pcall(function()
            v22({
              Url = v24,
              Method = "PATCH",
              Headers = { ["Content-Type"] = "application/json" },
              Body = httpService:JSONEncode({ used = true, usedBy = v26 }),
            })
          end)
        end
      end

      return true, "ACCESS GRANTED!"
    end
  end
end

local playerGui

if pcall(function() return gethui() end) and gethui() then
  playerGui = gethui()
elseif pcall(function() return coreGui end) and coreGui then
  playerGui = coreGui
else
  playerGui = localPlayer:WaitForChild("PlayerGui")
end

if playerGui:FindFirstChild("EzyKeyPanel") then
  playerGui.EzyKeyPanel:Destroy()
end

local ezyKeyPanel = Instance.new("ScreenGui")
ezyKeyPanel.Name = "EzyKeyPanel"
ezyKeyPanel.ResetOnSpawn = false
ezyKeyPanel.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ezyKeyPanel.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 260, 0, 190)
frame.Position = UDim2.new(0.5, -130, 0.5, -95)
frame.BackgroundColor3 = Color3.fromHex("#0f0f0f")
frame.BackgroundTransparency = 0.1
frame.BorderSizePixel = 0
frame.Active = true
frame.Parent = ezyKeyPanel

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 8)
uiCorner.Parent = frame

local uiStroke = Instance.new("UIStroke")
uiStroke.Color = Color3.fromRGB(255, 255, 255)
uiStroke.Thickness = 1
uiStroke.Transparency = 0.3
uiStroke.Parent = frame

local frame2 = Instance.new("Frame")
frame2.Size = UDim2.new(1, 0, 0, 35)
frame2.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame2.BackgroundTransparency = 0.5
frame2.BorderSizePixel = 0
frame2.Parent = frame

local uiCorner2 = Instance.new("UICorner")
uiCorner2.CornerRadius = UDim.new(0, 8)
uiCorner2.Parent = frame2

local textLabel = Instance.new("TextLabel")
textLabel.Size = UDim2.new(1, -20, 1, 0)
textLabel.Position = UDim2.new(0, 12, 0, 0)
textLabel.BackgroundTransparency = 1
textLabel.Text = "EZY SCRIPT - LOGIN"
textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
textLabel.Font = Enum.Font.GothamBold
textLabel.TextSize = 14
textLabel.TextXAlignment = Enum.TextXAlignment.Left
textLabel.Parent = frame2

local textBox = Instance.new("TextBox")
textBox.Size = UDim2.new(1, -24, 0, 36)
textBox.Position = UDim2.new(0, 12, 0, 50)
textBox.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
textBox.BackgroundTransparency = 0.5
textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
textBox.PlaceholderText = "PASTE KEY HERE"
textBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
textBox.Font = Enum.Font.Gotham
textBox.TextSize = 12
textBox.ClearTextOnFocus = true
textBox.Parent = frame

Instance.new("UICorner", textBox).CornerRadius = UDim.new(0, 4)

local uiStroke2 = Instance.new("UIStroke")
uiStroke2.Color = Color3.fromRGB(255, 255, 255)
uiStroke2.Thickness = 1
uiStroke2.Transparency = 0.5
uiStroke2.Parent = textBox

local function makeTextButton(text3, udim, p1, frame3)
  local textButton = Instance.new("TextButton")
  textButton.Size = UDim2.new(0, p1, 0, 30)
  textButton.Position = udim
  textButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
  textButton.BackgroundTransparency = 0.5
  textButton.Text = text3
  textButton.TextColor3 = Color3.fromRGB(255, 255, 255)
  textButton.Font = Enum.Font.GothamBold
  textButton.TextSize = 12
  textButton.Parent = frame3

  local uiCorner3 = Instance.new("UICorner")
  uiCorner3.CornerRadius = UDim.new(0, 4)
  uiCorner3.Parent = textButton

  local uiStroke3 = Instance.new("UIStroke")
  uiStroke3.Color = Color3.fromRGB(255, 255, 255)
  uiStroke3.Thickness = 1
  uiStroke3.Transparency = 0.5
  uiStroke3.Parent = textButton

  return textButton
end

f2("e>\183\8\177\227\177", 26644907978871)
local udim2 = UDim2
f2("6c\136", 10706433774457)
local v28 = makeTextButton("GET KEY", udim2.new(0, 12, 0, 95), 110, frame)
local v29 = makeTextButton("SUBMIT", UDim2.new(0, 138, 0, 95), 110, frame)

local textLabel2 = Instance.new("TextLabel")
textLabel2.Size = UDim2.new(1, -24, 0, 30)
textLabel2.Position = UDim2.new(0, 12, 0, 140)
textLabel2.BackgroundTransparency = 1
textLabel2.Text = "WAITING FOR KEY..."
textLabel2.TextColor3 = Color3.fromRGB(200, 200, 200)
textLabel2.Font = Enum.Font.Gotham
textLabel2.TextSize = 11
textLabel2.TextWrapped = true
textLabel2.Parent = frame

local v30 = false
local v31, v32

frame.InputBegan:Connect(function(input)
  if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
    f2("\155sFΌ+\224]", 11148771267655)
    local position = input.Position
    f2("\185\18\16\245\252D\137\24", 11567813825802)
    local position2 = frame.Position
    v30 = true
    v31 = position
    v32 = position2
  end
end)

userInputService.InputEnded:Connect(function(input2)
  if input2.UserInputType == Enum.UserInputType.MouseButton1
    or input2.UserInputType == Enum.UserInputType.Touch then
    v30 = false
  end
end)

userInputService.InputChanged:Connect(function(input3)
  if v30
    and (input3.UserInputType == Enum.UserInputType.MouseMovement
      or input3.UserInputType == Enum.UserInputType.Touch) then
    local v33 = input3.Position - v31

    frame.Position = UDim2.new(
      v32.X.Scale, v32.X.Offset + v33.X, v32.Y.Scale, v32.Y.Offset + v33.Y
    )
  end
end)

v28.MouseButton1Click:Connect(function()
  if setclipboard then
    setclipboard("https://ezysc.github.io/Ezyscript/")
    textLabel2.TextColor3 = Color3.fromRGB(100, 255, 100)
    textLabel2.Text = "LINK COPIED! PASTE IT IN YOUR BROWSER."
  else
    textLabel2.TextColor3 = Color3.fromRGB(255, 100, 100)
    textLabel2.Text = "EXECUTOR CANNOT COPY. GO TO: https://ezysc.github.io/Ezyscript/"
  end
end)

v29.MouseButton1Click:Connect(function()
  v29.Text = "CHECKING..."
  v29.Active = false

  local v34, text4 = f3(textBox.Text)

  local playerGui2, f4, f5, f6, v35, gotham, backgroundColor3, textButton2, frame4, uiScale,
    textButton3, textButton4, scrollingFrame, scrollingFrame2, v36, v37, f7, scale, frame5, v38,
    v39

  if v34 then
    textLabel2.TextColor3 = Color3.fromRGB(100, 255, 100)
    textLabel2.Text = text4

    task.wait(0.6)
    v35 = v21[game.PlaceId]

    if not v35 then
      localPlayer:Kick("Not Supported Game")
      return
    end

    ezyKeyPanel:Destroy()
    gotham = Enum.Font.Gotham

    if pcall(function() return gethui() end) and gethui() then
      playerGui2 = gethui()
    elseif pcall(function() return coreGui end) and coreGui then
      playerGui2 = coreGui
    else
      playerGui2 = localPlayer:WaitForChild("PlayerGui")
    end

    if playerGui2:FindFirstChild("EzyScriptPanel") then
      playerGui2.EzyScriptPanel:Destroy()
    end

    local ezyScriptPanel = Instance.new("ScreenGui")
    ezyScriptPanel.Name = "EzyScriptPanel"
    ezyScriptPanel.ResetOnSpawn = false
    ezyScriptPanel.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ezyScriptPanel.Parent = playerGui2

    local v40 = {
      Color3.fromHex("#0f0f0f"), Color3.fromHex("#48335b"), Color3.fromHex("#212121"),
      Color3.fromHex("#4b5d75"), Color3.fromHex("#aeaeae"), Color3.fromHex("#c5823e"),
      Color3.fromHex("#424663"), Color3.fromHex("#583344"), Color3.fromHex("#335853"),
      Color3.fromHex("#2f657a"),
    }

    backgroundColor3 = v40[1]

    textButton2 = Instance.new("TextButton")
    textButton2.Size = UDim2.new(0, 45, 0, 45)
    textButton2.Position = UDim2.new(0, 15, 0.4, 0)
    textButton2.BackgroundColor3 = backgroundColor3
    textButton2.BackgroundTransparency = 0
    textButton2.Text = "EZY"
    textButton2.TextColor3 = Color3.fromRGB(255, 255, 255)
    textButton2.Font = Enum.Font.GothamBold
    textButton2.TextSize = 14
    textButton2.Visible = false
    textButton2.Parent = ezyScriptPanel

    local uiCorner4 = Instance.new("UICorner")
    uiCorner4.CornerRadius = UDim.new(0, 8)
    uiCorner4.Parent = textButton2

    local uiStroke4 = Instance.new("UIStroke")
    uiStroke4.Color = Color3.fromRGB(255, 255, 255)
    uiStroke4.Thickness = 1
    uiStroke4.Transparency = 0.5
    uiStroke4.Parent = textButton2

    frame4 = Instance.new("Frame")
    frame4.Size = UDim2.new(0, 240, 0, 320)
    frame4.Position = UDim2.new(0, 15, 0.3, 0)
    frame4.BackgroundColor3 = backgroundColor3
    frame4.BackgroundTransparency = 0.1
    frame4.BorderSizePixel = 0
    frame4.Active = true
    frame4.Parent = ezyScriptPanel

    uiScale = Instance.new("UIScale")
    uiScale.Scale = 1
    uiScale.Parent = frame4

    local uiCorner5 = Instance.new("UICorner")
    uiCorner5.CornerRadius = UDim.new(0, 8)
    uiCorner5.Parent = frame4

    local uiStroke5 = Instance.new("UIStroke")
    uiStroke5.Color = Color3.fromRGB(255, 255, 255)
    uiStroke5.Thickness = 1
    uiStroke5.Transparency = 0.3
    uiStroke5.Parent = frame4

    local frame6 = Instance.new("Frame")
    frame6.Size = UDim2.new(1, 0, 0, 35)
    frame6.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    frame6.BackgroundTransparency = 0.5
    frame6.BorderSizePixel = 0
    frame6.Parent = frame4

    local uiCorner6 = Instance.new("UICorner")
    uiCorner6.CornerRadius = UDim.new(0, 8)
    uiCorner6.Parent = frame6

    local textLabel3 = Instance.new("TextLabel")
    textLabel3.Size = UDim2.new(1, -40, 1, 0)
    textLabel3.Position = UDim2.new(0, 12, 0, 0)
    textLabel3.BackgroundTransparency = 1
    textLabel3.Text = "EZY SCRIPT"
    textLabel3.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel3.Font = Enum.Font.GothamBold
    textLabel3.TextSize = 14
    textLabel3.TextXAlignment = Enum.TextXAlignment.Left
    textLabel3.Parent = frame6

    local textButton5 = Instance.new("TextButton")
    textButton5.Size = UDim2.new(0, 24, 0, 24)
    textButton5.Position = UDim2.new(1, -30, 0, 5)
    textButton5.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    textButton5.Text = "−"
    textButton5.TextColor3 = Color3.fromRGB(255, 255, 255)
    textButton5.Font = Enum.Font.Code
    textButton5.TextSize = 18
    textButton5.Parent = frame6

    local uiCorner7 = Instance.new("UICorner")
    uiCorner7.CornerRadius = UDim.new(0, 4)
    uiCorner7.Parent = textButton5

    textButton5.MouseButton1Click:Connect(function()
      frame4.Visible = false
      textButton2.Visible = true
    end)

    textButton2.MouseButton1Click:Connect(function()
      frame4.Visible = true
      textButton2.Visible = false
    end)

    local frame7 = Instance.new("Frame")
    frame7.Size = UDim2.new(1, 0, 0, 25)
    frame7.Position = UDim2.new(0, 0, 0, 35)
    frame7.BackgroundTransparency = 1
    frame7.Parent = frame4

    textButton3 = Instance.new("TextButton")
    textButton3.Size = UDim2.new(0.5, 0, 1, 0)
    textButton3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    textButton3.BackgroundTransparency = 0.1
    textButton3.Text = "MAIN"
    textButton3.TextColor3 = Color3.fromRGB(0, 0, 0)
    textButton3.Font = Enum.Font.GothamBold
    textButton3.TextSize = 11
    textButton3.Parent = frame7

    textButton4 = Instance.new("TextButton")
    textButton4.Size = UDim2.new(0.5, 0, 1, 0)
    textButton4.Position = UDim2.new(0.5, 0, 0, 0)
    textButton4.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    textButton4.BackgroundTransparency = 0.5
    textButton4.Text = "SETTINGS"
    textButton4.TextColor3 = Color3.fromRGB(200, 200, 200)
    textButton4.Font = Enum.Font.GothamBold
    textButton4.TextSize = 11
    textButton4.Parent = frame7

    scrollingFrame = Instance.new("ScrollingFrame")
    scrollingFrame.Size = UDim2.new(1, -16, 1, -115)
    scrollingFrame.Position = UDim2.new(0, 8, 0, 65)
    scrollingFrame.BackgroundTransparency = 1
    scrollingFrame.ScrollBarThickness = 2
    scrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
    scrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    scrollingFrame.Parent = frame4

    local uiListLayout = Instance.new("UIListLayout")
    uiListLayout.Padding = UDim.new(0, 6)
    uiListLayout.Parent = scrollingFrame

    scrollingFrame2 = Instance.new("ScrollingFrame")
    scrollingFrame2.Size = UDim2.new(1, -16, 1, -115)
    scrollingFrame2.Position = UDim2.new(0, 8, 0, 65)
    scrollingFrame2.BackgroundTransparency = 1
    scrollingFrame2.ScrollBarThickness = 2
    scrollingFrame2.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
    scrollingFrame2.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scrollingFrame2.CanvasSize = UDim2.new(0, 0, 0, 0)
    scrollingFrame2.Visible = false
    scrollingFrame2.Parent = frame4

    textButton3.MouseButton1Click:Connect(function()
      scrollingFrame.Visible = true
      scrollingFrame2.Visible = false

      textButton3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
      textButton3.TextColor3 = Color3.fromRGB(0, 0, 0)
      textButton3.BackgroundTransparency = 0.1

      textButton4.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
      textButton4.TextColor3 = Color3.fromRGB(200, 200, 200)
      textButton4.BackgroundTransparency = 0.5
    end)

    textButton4.MouseButton1Click:Connect(function()
      scrollingFrame.Visible = false
      scrollingFrame2.Visible = true

      textButton4.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
      textButton4.TextColor3 = Color3.fromRGB(0, 0, 0)
      textButton4.BackgroundTransparency = 0.1

      textButton3.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
      textButton3.TextColor3 = Color3.fromRGB(200, 200, 200)
      textButton3.BackgroundTransparency = 0.5
    end)

    v36 = {}

    function f4(text5, parent)
      local frame8 = Instance.new("Frame")
      frame8.Size = UDim2.new(1, -4, 0, 30)
      frame8.BackgroundTransparency = 1
      frame8.Parent = parent

      local textButton6 = Instance.new("TextButton")
      textButton6.Size = UDim2.new(1, 0, 1, 0)
      textButton6.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
      textButton6.BackgroundTransparency = 0.5
      textButton6.Text = text5
      textButton6.TextColor3 = Color3.fromRGB(255, 255, 255)
      textButton6.Font = gotham
      textButton6.TextSize = 12
      textButton6.Parent = frame8

      local uiCorner8 = Instance.new("UICorner")
      uiCorner8.CornerRadius = UDim.new(0, 4)
      uiCorner8.Parent = textButton6

      local uiStroke6 = Instance.new("UIStroke")
      uiStroke6.Color = Color3.fromRGB(255, 255, 255)
      uiStroke6.Thickness = 1
      uiStroke6.Transparency = 0.5
      uiStroke6.Parent = textButton6

      table.insert(v36, textButton6)
      return textButton6, uiStroke6, frame8
    end

    f2("'\131\23]m\29\177\15\253\243_\184", 22435538872527)

    local textLabel4 = Instance.new("TextLabel")
    textLabel4.Size = UDim2.new(1, -4, 0, 30)
    textLabel4.BackgroundTransparency = 1
    textLabel4.Text = "DETECTED: " .. string.upper("Unknown Game")
    textLabel4.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel4.Font = Enum.Font.GothamBold
    textLabel4.TextSize = 11
    textLabel4.TextWrapped = true
    textLabel4.Parent = scrollingFrame

    v37, v172, v173 = f4("SCRIPT AUTO-LOADED", scrollingFrame)
    v37.TextColor3 = Color3.fromRGB(100, 255, 100)

    task.spawn(function()
      local v41, v42 = pcall(v35)

      if v41 then
        print("[EZY SCRIPT] Unknown Game script successfully loaded.")
      else
        warn("EzyScript Auto-Load Error: ", v42)
        v37.Text = "ERROR LOADING SCRIPT"
        v37.TextColor3 = Color3.fromRGB(255, 100, 100)
      end
    end)

    function f7(p2)
      backgroundColor3 = p2
      frame4.BackgroundColor3 = p2
      textButton2.BackgroundColor3 = p2
    end

    local uiListLayout2 = Instance.new("UIListLayout")
    uiListLayout2.Padding = UDim.new(0, 5)
    uiListLayout2.SortOrder = Enum.SortOrder.LayoutOrder
    uiListLayout2.Parent = scrollingFrame2

    local textLabel5 = Instance.new("TextLabel")
    textLabel5.Size = UDim2.new(1, 0, 0, 20)
    textLabel5.BackgroundTransparency = 1
    textLabel5.Text = "SELECT THEME (COLOR):"
    textLabel5.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel5.Font = Enum.Font.GothamBold
    textLabel5.TextSize = 12
    textLabel5.LayoutOrder = 1
    textLabel5.Parent = scrollingFrame2

    local frame9 = Instance.new("Frame")
    frame9.Size = UDim2.new(1, 0, 0, 65)
    frame9.BackgroundTransparency = 1
    frame9.LayoutOrder = 2
    frame9.Parent = scrollingFrame2

    local uiGridLayout = Instance.new("UIGridLayout")
    uiGridLayout.CellSize = UDim2.new(0, 25, 0, 25)
    uiGridLayout.CellPadding = UDim2.new(0, 10, 0, 5)
    uiGridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    uiGridLayout.Parent = frame9

    for index2, value in ipairs(v40) do
      local v43 = value

      local textButton7 = Instance.new("TextButton")
      textButton7.BackgroundColor3 = v43
      textButton7.Text = ""
      textButton7.Parent = frame9

      local uiCorner9 = Instance.new("UICorner")
      uiCorner9.CornerRadius = UDim.new(0, 6)
      uiCorner9.Parent = textButton7

      local uiStroke7 = Instance.new("UIStroke")
      uiStroke7.Color = Color3.fromRGB(255, 255, 255)
      uiStroke7.Thickness = 1
      uiStroke7.Parent = textButton7

      textButton7.MouseButton1Click:Connect(function() f7(v43) end)
    end

    local textLabel6 = Instance.new("TextLabel")
    textLabel6.Size = UDim2.new(1, 0, 0, 20)
    textLabel6.BackgroundTransparency = 1
    textLabel6.Text = "SELECT GUI SCALE:"
    textLabel6.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel6.Font = Enum.Font.GothamBold
    textLabel6.TextSize = 12
    textLabel6.LayoutOrder = 3
    textLabel6.Parent = scrollingFrame2

    local frame10 = Instance.new("Frame")
    frame10.Size = UDim2.new(1, 0, 0, 60)
    frame10.BackgroundTransparency = 1
    frame10.LayoutOrder = 4
    frame10.Parent = scrollingFrame2

    local uiGridLayout2 = Instance.new("UIGridLayout")
    uiGridLayout2.CellSize = UDim2.new(0.3, 0, 0, 25)
    uiGridLayout2.CellPadding = UDim2.new(0, 5, 0, 5)
    uiGridLayout2.Parent = frame10

    local v44 = { "50%", "75%", "100%", "125%", "150%" }
    scale = 1

    local ezyConfirmPopup = Instance.new("ScreenGui")
    ezyConfirmPopup.Name = "EzyConfirmPopup"
    ezyConfirmPopup.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ezyConfirmPopup.Parent = playerGui2

    frame5 = Instance.new("Frame")
    frame5.Size = UDim2.new(0, 220, 0, 100)
    frame5.AnchorPoint = Vector2.new(0.5, 0.5)
    frame5.Position = UDim2.new(0.5, 0, 0.5, 0)
    frame5.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    frame5.BorderSizePixel = 0
    frame5.Visible = false
    frame5.Parent = ezyConfirmPopup

    local uiCorner10 = Instance.new("UICorner")
    uiCorner10.CornerRadius = UDim.new(0, 8)
    uiCorner10.Parent = frame5

    local uiStroke8 = Instance.new("UIStroke")
    uiStroke8.Color = Color3.fromRGB(255, 255, 255)
    uiStroke8.Thickness = 1
    uiStroke8.Parent = frame5

    local textLabel7 = Instance.new("TextLabel")
    textLabel7.Size = UDim2.new(1, 0, 0, 40)
    textLabel7.BackgroundTransparency = 1
    textLabel7.Text = "KEEP THIS SCALE?"
    textLabel7.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel7.Font = Enum.Font.GothamBold
    textLabel7.TextSize = 14
    textLabel7.Parent = frame5

    function f5(text6, position3, backgroundColor32)
      local textButton8 = Instance.new("TextButton")
      textButton8.Size = UDim2.new(0.4, 0, 0, 30)
      textButton8.Position = position3
      textButton8.BackgroundColor3 = backgroundColor32
      textButton8.Text = text6
      textButton8.TextColor3 = Color3.fromRGB(255, 255, 255)
      textButton8.Font = Enum.Font.GothamBold
      textButton8.TextSize = 12
      textButton8.Parent = frame5

      local uiCorner11 = Instance.new("UICorner")
      uiCorner11.CornerRadius = UDim.new(0, 4)
      uiCorner11.Parent = textButton8

      return textButton8
    end

    local v45 = f5("SAVE", UDim2.new(0.07, 0, 0.5, 0), Color3.fromRGB(50, 150, 50))
    local v46 = f5("REVERT", UDim2.new(0.53, 0, 0.5, 0), Color3.fromRGB(150, 50, 50))
    v38 = nil

    for index3, value2 in ipairs({ 0.5, 0.75, 1, 1.25, 1.5 }) do
      local scale2 = value2

      f4(v44[index3], frame10).MouseButton1Click:Connect(function()
        uiScale.Scale = scale2
        frame5.Visible = true

        if v38 then
          task.cancel(v38)
        end

        v38 = task.delay(5, function()
          uiScale.Scale = scale
          frame5.Visible = false
        end)
      end)
    end

    v45.MouseButton1Click:Connect(function()
      scale = uiScale.Scale
      frame5.Visible = false

      if v38 then
        task.cancel(v38)
      end
    end)

    v46.MouseButton1Click:Connect(function()
      uiScale.Scale = scale
      frame5.Visible = false

      if v38 then
        task.cancel(v38)
      end
    end)

    local v47, v48
    v39, v48, v47 = f4("FONT WEIGHT: REGULAR", scrollingFrame2)

    v47.Size = UDim2.new(1, -4, 0, 30)
    v47.LayoutOrder = 5

    v39.MouseButton1Click:Connect(function()
      if gotham == Enum.Font.Gotham then
        gotham = Enum.Font.GothamBold
        v39.Text = "FONT WEIGHT: BOLD"
      else
        gotham = Enum.Font.Gotham
        v39.Text = "FONT WEIGHT: REGULAR"
      end

      for index4, value3 in ipairs(v36) do
        value3.Font = gotham
      end
    end)

    local v49, v50, v51 = f4("REJOIN SERVER", scrollingFrame2)

    v51.Size = UDim2.new(1, -4, 0, 30)
    v51.LayoutOrder = 6

    v49.MouseButton1Click:Connect(function()
      teleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, localPlayer)
    end)

    local v52, v53, v54 = f4("JOIN LOW SERVER", scrollingFrame2)

    v54.Size = UDim2.new(1, -4, 0, 30)
    v54.LayoutOrder = 7

    v52.MouseButton1Click:Connect(function()
      local v55 = "https://games.roblox.com/v1/games/" .. game.PlaceId
        .. "/servers/Public?sortOrder=Asc&limit=100"

      local v56, v57 = pcall(function() return game:HttpGet(v55) end)

      if v56 and v57 then
        local jsonDecode2 = httpService:JSONDecode(v57)

        if jsonDecode2 and jsonDecode2.data then
          for index5, value4 in ipairs(jsonDecode2.data) do
            if value4.playing < value4.maxPlayers and value4.id ~= game.JobId then
              teleportService:TeleportToPlaceInstance(game.PlaceId, value4.id, localPlayer)
              return
            end
          end
        end

        teleportService:Teleport(game.PlaceId, localPlayer)
        return
      end

      teleportService:Teleport(game.PlaceId, localPlayer)
    end)

    function f6(p3)
      local v58 = false
      local inputBegan = p3.InputBegan
      local v59, v60

      inputBegan:Connect(function(p4)
        if p4.UserInputType == Enum.UserInputType.MouseButton1
          or p4.UserInputType == Enum.UserInputType.Touch then
          f2("\212\11\200.8yIX", 3401673983536)
          local position4 = p4.Position
          f2("\177肚\204\27\143\254", 34519689690826)
          local position5 = p3.Position
          v58 = true
          v59 = position4
          v60 = position5
        end
      end)

      userInputService.InputEnded:Connect(function(input4)
        if input4.UserInputType == Enum.UserInputType.MouseButton1
          or input4.UserInputType == Enum.UserInputType.Touch then
          v58 = false
        end
      end)

      userInputService.InputChanged:Connect(function(input5)
        if v58
          and (input5.UserInputType == Enum.UserInputType.MouseMovement
            or input5.UserInputType == Enum.UserInputType.Touch) then
          local v61 = input5.Position - v59
          local scale3 = p3 == textButton2 and 1 or uiScale.Scale

          p3.Position = UDim2.new(
            v60.X.Scale, v60.X.Offset + v61.X / scale3, v60.Y.Scale,
            v60.Y.Offset + v61.Y / scale3
          )
        end
      end)
    end

    f6(frame4)
    f6(textButton2)

    localPlayer.Idled:Connect(function()
      virtualUser:CaptureController()
      virtualUser:ClickButton2(Vector2.new())
    end)

    return
  end

  textLabel2.TextColor3 = Color3.fromRGB(255, 100, 100)
  textLabel2.Text = text4

  v29.Text = "SUBMIT"
  v29.Active = true
end)