local URL = "https://playful-scripts.lovable.app/api/public/loader/e93b874c-ffde-4155-965d-209d695cd739"
local function run(k) loadstring(game:HttpGet(URL .. "?key=" .. game:GetService("HttpService"):UrlEncode(k)))() end
local parent = (typeof(gethui) == "function" and gethui()) or game:WaitForChild("CoreGui")
local gui = Instance.new("ScreenGui") gui.Name = "TQ_KEY" gui.ResetOnSpawn = false gui.Parent = parent
local frame = Instance.new("Frame") frame.Size = UDim2.new(0, 280, 0, 130) frame.Position = UDim2.new(0.5, -140, 0.4, 0) frame.BackgroundColor3 = Color3.fromRGB(10, 10, 10) frame.BorderSizePixel = 0 frame.Active = true frame.Draggable = true frame.Parent = gui
local title = Instance.new("TextLabel") title.Size = UDim2.new(1, 0, 0, 34) title.BackgroundTransparency = 1 title.Text = "TQ | ادخل المفتاح" title.TextColor3 = Color3.fromRGB(0, 255, 140) title.TextSize = 16 title.Font = Enum.Font.GothamBold title.Parent = frame
local box = Instance.new("TextBox") box.Size = UDim2.new(1, -24, 0, 30) box.Position = UDim2.new(0, 12, 0, 44) box.BackgroundColor3 = Color3.fromRGB(25, 25, 25) box.TextColor3 = Color3.fromRGB(255, 255, 255) box.PlaceholderText = "المفتاح هنا" box.Text = "" box.Font = Enum.Font.Gotham box.TextSize = 14 box.Parent = frame
local btn = Instance.new("TextButton") btn.Size = UDim2.new(1, -24, 0, 30) btn.Position = UDim2.new(0, 12, 0, 84) btn.BackgroundColor3 = Color3.fromRGB(0, 170, 110) btn.TextColor3 = Color3.fromRGB(0, 0, 0) btn.Text = "تشغيل" btn.Font = Enum.Font.GothamBold btn.TextSize = 14 btn.Parent = frame
local function go() if box.Text ~= "" then local k = box.Text gui:Destroy() run(k) end end
btn.MouseButton1Click:Connect(go)
box.FocusLost:Connect(function(enter) if enter then go() end end)