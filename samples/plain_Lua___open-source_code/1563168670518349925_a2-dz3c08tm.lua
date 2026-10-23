-- A2 LuaDrop protected loader
local HS = game:GetService("HttpService")
local GEN = (getgenv and getgenv()) or _G
GEN.__A2_KEYS = GEN.__A2_KEYS or {}
local req = (request or http_request or (syn and syn.request) or (fluxus and fluxus.request))
if not req then error("Executor tidak mendukung request().") end
local FILE = "A2KEY_a2-dz3c08tm_lua.txt"
local function loadSaved() if GEN.__A2_KEYS["a2-dz3c08tm.lua"] then return GEN.__A2_KEYS["a2-dz3c08tm.lua"] end; if isfile and readfile then local ok,v = pcall(function() return isfile(FILE) and readfile(FILE) or nil end); if ok and v and #v > 0 then return v end end end
local function save(k) GEN.__A2_KEYS["a2-dz3c08tm.lua"] = k; if writefile then pcall(writefile, FILE, k or "") end end
local function forget() GEN.__A2_KEYS["a2-dz3c08tm.lua"] = nil; if delfile then pcall(delfile, FILE) elseif writefile then pcall(writefile, FILE, "") end end
local function post(tbl) return req({Url="https://scrip-a2.netlify.app/loader/a2-dz3c08tm.lua", Method="POST", Headers={["Content-Type"]="application/json"}, Body=HS:JSONEncode(tbl)}) end
local function check(k)
  local r = post({key=k, check=true})
  if not r then return false, "Gagal konek ke server" end
  local ok, d = pcall(function() return HS:JSONDecode(r.Body) end)
  if r.StatusCode == 200 and ok and d.ok then return true, d.expiresAt end
  if r.StatusCode == 410 then return false, "Key sudah kedaluwarsa, ambil key baru" end
  if r.StatusCode == 429 then return false, "Terlalu banyak percobaan, tunggu 1 menit" end
  return false, "Key salah"
end
local function left(iso)
  if not iso then return "Permanen" end
  local y,mo,d,h,mi,se = tostring(iso):match("(%d+)-(%d+)-(%d+)T(%d+):(%d+):(%d+)")
  if not y then return tostring(iso) end
  local t = os.time({year=y,month=mo,day=d,hour=h,min=mi,sec=se}) - os.time(os.date("!*t"))
  if t <= 0 then return "Habis" end
  local dd, hh, mm = math.floor(t/86400), math.floor(t%86400/3600), math.floor(t%3600/60)
  if dd > 0 then return dd.." hari "..hh.." jam" end
  return hh.." jam "..mm.." menit"
end
local function gui(msg)
  local p = game:GetService("Players").LocalPlayer
  local g = Instance.new("ScreenGui"); g.Name="A2KeyPrompt"; g.ResetOnSpawn=false
  pcall(function() g.Parent=game:GetService("CoreGui") end); if not g.Parent then g.Parent=p:WaitForChild("PlayerGui") end
  local f=Instance.new("Frame",g); f.Size=UDim2.fromOffset(360,270); f.Position=UDim2.fromScale(.5,.5); f.AnchorPoint=Vector2.new(.5,.5); f.BackgroundColor3=Color3.fromRGB(15,18,30); Instance.new("UICorner",f).CornerRadius=UDim.new(0,12)
  local function lbl(y,h,txt,sz,col) local l=Instance.new("TextLabel",f); l.Size=UDim2.new(1,-24,0,h); l.Position=UDim2.fromOffset(12,y); l.BackgroundTransparency=1; l.Text=txt; l.TextColor3=col or Color3.fromRGB(220,230,255); l.TextSize=sz; l.TextWrapped=true; return l end
  local function btn(y,txt,col) local b=Instance.new("TextButton",f); b.Size=UDim2.new(1,-24,0,34); b.Position=UDim2.fromOffset(12,y); b.Text=txt; b.TextSize=14; b.TextColor3=Color3.new(1,1,1); b.BackgroundColor3=col; Instance.new("UICorner",b).CornerRadius=UDim.new(0,8); return b end
  lbl(8,30,"A2HUB • Key System",18)
  local status = lbl(38,22,msg or "1. Copy link → ambil key  2. Tempel key → Verifikasi",12,Color3.fromRGB(160,175,210))
  local box=Instance.new("TextBox",f); box.Size=UDim2.new(1,-24,0,38); box.Position=UDim2.fromOffset(12,66); box.PlaceholderText="Tempel key di sini (A2HUB-...)"; box.Text=""; box.ClearTextOnFocus=false; box.TextSize=14; Instance.new("UICorner",box).CornerRadius=UDim.new(0,8)
  local verify = btn(114,"Verifikasi Key",Color3.fromRGB(40,160,90))
  local copyB = btn(156,"Copy Link Ambil Key",Color3.fromRGB(70,90,200))
  local close = btn(198,"Tutup",Color3.fromRGB(80,40,50))
  lbl(238,24,"Link: Safelinku • key otomatis tersimpan",11,Color3.fromRGB(120,130,160))
  copyB.MouseButton1Click:Connect(function()
    local done = false
    if setclipboard then done = pcall(setclipboard, "https://scrip-a2.netlify.app/safelinku?script=a2-dz3c08tm.lua") elseif toclipboard then done = pcall(toclipboard, "https://scrip-a2.netlify.app/safelinku?script=a2-dz3c08tm.lua") end
    status.Text = done and "✓ Link disalin! Buka di browser untuk ambil key" or ("Salin manual: ".."https://scrip-a2.netlify.app/safelinku?script=a2-dz3c08tm.lua")
    status.TextColor3 = Color3.fromRGB(120,200,255)
  end)
  local result, busy = nil, false
  verify.MouseButton1Click:Connect(function()
    if busy then return end
    local k = (box.Text or ""):gsub("%s+","")
    if #k == 0 then status.Text = "Tempel key dulu"; return end
    busy = true; status.Text = "Memverifikasi..."; status.TextColor3 = Color3.fromRGB(220,220,120)
    local ok, info = check(k)
    if ok then
      status.Text = "✓ Key valid • Sisa durasi: "..left(info); status.TextColor3 = Color3.fromRGB(90,255,150)
      verify.Text = "✓ Terverifikasi"; task.wait(1.5); result = k
    else
      status.Text = "✗ "..tostring(info); status.TextColor3 = Color3.fromRGB(255,110,110); busy = false
    end
  end)
  close.MouseButton1Click:Connect(function() result = false end)
  repeat task.wait() until result ~= nil
  g:Destroy(); return result
end
local accessKey = loadSaved()
local note
if accessKey then
  local ok, info = check(accessKey)
  if not ok then forget(); accessKey = nil; note = "Key lama: "..tostring(info) end
end
if not accessKey then accessKey = gui(note) end
if not accessKey then return end
save(accessKey)
local r = post({key=accessKey})
if not r or r.StatusCode ~= 200 then forget(); error("Key tidak valid / kedaluwarsa, execute ulang untuk ambil key baru.") end
local run = loadstring(r.Body); if not run then error("Payload Lua tidak valid") end
return run()
