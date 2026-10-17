<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8">
    <link rel="icon" href="/favicon.ico">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>raw.deobfuscated.luau</title>


    <script>
      window.registerPastefyPlugin = [
        {"config": {"name":"ads","frontend":{"folder":"frontend","entrypoint":"plugin.js"},"listed":false}, "entrypoint": "/assets/plugins/ads/plugin.js"},

      ]
    </script>

    <script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js?client=ca-pub-7136454966632869" crossorigin="anonymous"></script><script async src="https://www.googletagmanager.com/gtag/js?id=G-E3MH99413M"></script><script>window.dataLayer = window.dataLayer || []; function gtag(){dataLayer.push(arguments);} gtag('js', new Date()); gtag('config', 'G-E3MH99413M');</script>

    <meta name="description" content="View &quot;raw.deobfuscated.luau&quot; by @xuijii on Pastefy." /><meta name="author" content="xuijii (@xuijii)" /><link rel="canonical" href="https://pastefy.app/GhKS0szv" /><meta property="og:site_name" content="Pastefy" /><meta property="og:type" content="article" /><meta property="og:title" content="raw.deobfuscated.luau" /><meta property="og:description" content="View &quot;raw.deobfuscated.luau&quot; by @xuijii on Pastefy." /><meta property="og:url" content="https://pastefy.app/GhKS0szv" /><meta property="og:image" content="https://pastefy.app/GhKS0szv/thumbnail.png" /><meta property="article:author" content="https://pastefy.app/@xuijii" /><meta name="twitter:card" content="summary_large_image" /><meta name="twitter:title" content="raw.deobfuscated.luau" /><meta name="twitter:description" content="View &quot;raw.deobfuscated.luau&quot; by @xuijii on Pastefy." /><meta name="twitter:url" content="https://pastefy.app/GhKS0szv" /><meta name="twitter:image" content="https://pastefy.app/GhKS0szv/thumbnail.png" /><meta name="twitter:creator" content="@xuijii" />
    <script type="module" crossorigin src="/assets/index-xKWWSADt.js"></script>
    <link rel="stylesheet" crossorigin href="/assets/index-l0xM8UnQ.css">
  </head>
  <body>
    <div id="app"><main id="seo-content"><h1 title="paste-title">raw.deobfuscated.luau</h1><p>By <a href="https://pastefy.app/@xuijii">xuijii (@xuijii)</a></p><p>View and share code snippets on Pastefy.</p><pre><code>-- Deobfuscated by deobf (dynamic trace)
-- source: input.lua
-- NOTE: reconstructed from observed behaviour; branches that were not taken
--       during the trace are missing and conditions are only noted in comments.
-- run status: finished
-- 1327 statements recorded in 0.41s

-- [deobf] folded 0 repeated calls into 0 helper functions and 4 unrolled runs into loops
local Players = game:GetService(&quot;Players&quot;)
local TweenService = game:GetService(&quot;TweenService&quot;)
local UserInputService = game:GetService(&quot;UserInputService&quot;)
local RunService = game:GetService(&quot;RunService&quot;)
local ContentProvider = game:GetService(&quot;ContentProvider&quot;)
local ReplicatedStorage = game:GetService(&quot;ReplicatedStorage&quot;)
local PlayerGui = Players.LocalPlayer:WaitForChild(&quot;PlayerGui&quot;)
local BW_UI = PlayerGui:FindFirstChild(&quot;BW_UI&quot;)
BW_UI:Destroy()
local NX_HUB_UI = PlayerGui:FindFirstChild(&quot;NX_HUB_UI&quot;)
NX_HUB_UI:Destroy()
local NX_ShootBtn = PlayerGui:FindFirstChild(&quot;NX_ShootBtn&quot;)
NX_ShootBtn:Destroy()
local NX_FOV = PlayerGui:FindFirstChild(&quot;NX_FOV&quot;)
NX_FOV:Destroy()
local Modules = ReplicatedStorage:WaitForChild(&quot;Modules&quot;)
local Packages = Modules:WaitForChild(&quot;Packages&quot;)
local lastModules = Packages:WaitForChild(&quot;lastModules&quot;)
local sleitnick_net020 = lastModules:FindFirstChild(&quot;<a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="cdbea1a8a4b9a3a4aea692a3a8b98dfde3ffe3fd">[email&#160;protected]</a>&quot;)
sleitnick_net020.net:FindFirstChild(&quot;RE/GunRemote&quot;)
local NX_FOV2 = Instance.new(&quot;ScreenGui&quot;)
NX_FOV2.ResetOnSpawn = false
NX_FOV2.IgnoreGuiInset = true
NX_FOV2.Name = &quot;NX_FOV&quot;
NX_FOV2.DisplayOrder = 400
NX_FOV2.Parent = PlayerGui
local FOVCircle = Instance.new(&quot;Frame&quot;)
FOVCircle.AnchorPoint = Vector2.new(0.5, 0.5)
FOVCircle.Name = &quot;FOVCircle&quot;
FOVCircle.Position = UDim2.new(0.5, 0, 0.5, 0)
FOVCircle.Visible = false
FOVCircle.BackgroundTransparency = 1
FOVCircle.BorderSizePixel = 0
FOVCircle.Size = UDim2.fromOffset(240, 240)
FOVCircle.Parent = NX_FOV2
local UIStroke = Instance.new(&quot;UIStroke&quot;)
UIStroke.Thickness = 1.5
UIStroke.Transparency = 0.15
UIStroke.Color = Color3.fromRGB(49, 93, 156)
UIStroke.Parent = FOVCircle
local UICorner = Instance.new(&quot;UICorner&quot;)
UICorner.CornerRadius = UDim.new(1, 0)
UICorner.Parent = FOVCircle
local players = Players:GetPlayers()

for i, v in ipairs(players) do
	local BillboardGui = Instance.new(&quot;BillboardGui&quot;)
	BillboardGui.Name = &quot;NX_ESP_&quot; .. v.Name
	BillboardGui.AlwaysOnTop = true
	BillboardGui.ResetOnSpawn = false
	BillboardGui.Size = UDim2.new(0, 40, 0, 54)
	BillboardGui.StudsOffsetWorldSpace = Vector3.new(0, 2.5999999046325684, 0)
	BillboardGui.LightInfluence = 0
	BillboardGui.MaxDistance = 1500
	BillboardGui.Adornee = nil
	BillboardGui.Enabled = false
	BillboardGui.Parent = PlayerGui
	local Box = Instance.new(&quot;Frame&quot;)
	Box.Name = &quot;Box&quot;
	Box.BackgroundTransparency = 1
	Box.Size = UDim2.new(0, 24, 0, 34)
	Box.Position = UDim2.new(0.5, -12, 0.5, -17)
	Box.Visible = false
	Box.Parent = BillboardGui
	local UIStroke2 = Instance.new(&quot;UIStroke&quot;)
	UIStroke2.Color = Color3.fromRGB(49, 93, 156)
	UIStroke2.Thickness = 1
	UIStroke2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	UIStroke2.Parent = Box
	local Name = Instance.new(&quot;TextLabel&quot;)
	Name.Name = &quot;Name&quot;
	Name.BackgroundTransparency = 1
	Name.Size = UDim2.new(1, 0, 0, 12)
	Name.Position = UDim2.new(0, 0, 1, -14)
	Name.Font = Enum.Font.GothamBold
	Name.TextSize = 10
	Name.TextColor3 = Color3.fromRGB(255, 255, 255)
	Name.TextStrokeTransparency = 0
	Name.TextStrokeColor3 = Color3.new(0, 0, 0)
	Name.Text = v.Name
	Name.Visible = false
	Name.Parent = BillboardGui
	local HP_BG = Instance.new(&quot;Frame&quot;)
	HP_BG.Name = &quot;HP_BG&quot;
	HP_BG.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
	HP_BG.BorderSizePixel = 0
	HP_BG.Size = UDim2.new(1, 0, 0, 3)
	HP_BG.Position = UDim2.new(0, 0, 1, -3)
	HP_BG.Visible = false
	HP_BG.Parent = BillboardGui
	local UICorner2 = Instance.new(&quot;UICorner&quot;)
	UICorner2.CornerRadius = UDim.new(1, 0)
	UICorner2.Parent = HP_BG
	local HP_Fill = Instance.new(&quot;Frame&quot;)
	HP_Fill.Name = &quot;HP_Fill&quot;
	HP_Fill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
	HP_Fill.BorderSizePixel = 0
	HP_Fill.Size = UDim2.new(1, 0, 1, 0)
	HP_Fill.Parent = HP_BG
	local UICorner3 = Instance.new(&quot;UICorn</code></pre><h2>Tags</h2></main></div>

    <script data-cfasync="false" src="/cdn-cgi/scripts/5c5dd728/cloudflare-static/email-decode.min.js"></script><script>console.log(`┌────────────────────────────────────────────┐
│•••              pastefy.ts                 │
├─┬──────────────────────────────────────────┤
│1│const GH = "github.com/interaapps/pastefy"│
│2│const dev = new AwesomeDeveloper("You")   │
│3│                                          │
│4│const repo = dev.pull(GH)                 │
│5│                                          │
│6│repo.commit("Awesome improvements")       │
│7│repo.like()                               │
└─┴──────────────────────────────────────────┘`)</script>
    
  </body>
</html>
