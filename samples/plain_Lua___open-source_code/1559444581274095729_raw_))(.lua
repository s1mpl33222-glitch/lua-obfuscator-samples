--// TOOLS HUB - FIX FAVORITAR ☆ + ANIMAÇÕES FIX + 64 SCRIPTS + CONFIRMAÇÃO FECHAR (otavivio2)
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
for _,v in pairs(playerGui:GetChildren()) do if v.Name=="ToolsHub" or v.Name=="KeySystem" then v:Destroy() end end

local SAVE_KEY_FILE = "ToolsHub_SavedKey.txt"
local SAVE_FAV_FILE = "ToolsHub_Favorites.txt"
local DISCORD_LINK = "https://discord.gg/ehQY7dhSB"
local linkKeyURL = "https://loot-link.com/s?OraK8OiL"
local validKeys = {["KEY-PERM-FOR-1000-FIRTS-PLAYERS"]=true,["KEY-ADMIN-QUEL-DIGZ-DEVS-ADMS"]=true}

local HUB_CODE = [====[
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
if playerGui:FindFirstChild("ToolsHub") then playerGui.ToolsHub:Destroy() end
local ACCENT = Color3.fromRGB(168, 85, 247)
local TEXT = Color3.fromRGB(240, 240, 245)
local MUTED = Color3.fromRGB(150, 150, 165)
local DISCORD_LINK = "https://discord.gg/ehQY7dhSB"
local SAVE_FAV_FILE = "ToolsHub_Favorites.txt"
local favorites = {}
pcall(function() if isfile and isfile(SAVE_FAV_FILE) then local d=readfile(SAVE_FAV_FILE) if d and d~="" then favorites=HttpService:JSONDecode(d) end end end)
local function saveFavorites() pcall(function() if writefile then writefile(SAVE_FAV_FILE, HttpService:JSONEncode(favorites)) end end) end
local function copyDiscord() if setclipboard then setclipboard(DISCORD_LINK) end end

local Scripts = {
    {name="🛡️ PAINEL ADMIN V2 [DELTA]", url="https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source", cat="Universal"},
    {name="Infinite Yield - Admin", url="https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source", cat="Universal"},
    {name="HitBox Expander", url="https://scriptblox.com/raw/HITBOX-EXPANDER_750", cat="Universal"},
    {name="Wallhop", url="https://scriptblox.com/raw/Universal-Script-Wallhop-Script-244193", cat="Universal"},
    {name="ESP Team Color", url="https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source", cat="Universal"},
    {name="Shaders", url="https://gist.githubusercontent.com/otavivio2/2706a1c5dee9aa9a5d97448047f8d5c2/raw/", cat="Universal"},
    {name="Smooth Graphics", url="https://gist.githubusercontent.com/otavivio2/8a17a59624f6a0cb8518ae0d11b203c7/raw/", cat="Universal"},
    {name="Shift Lock", url="https://pastebin.com/raw/CjNsnSDy", cat="Universal"},
    {name="Noclip", url="https://gist.githubusercontent.com/otavivio2/9dfc94a31fe937a668a051c62160d62f/raw", cat="Universal"},
    {name="Fly V3", url="https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt", cat="Universal"},
    {name="🔪 MM2 KRISIS HUB [OP NOVO]", url="https://raw.githubusercontent.com/Krisis-Scripts/MM2/refs/heads/main/KrisisHub", cat="Início"},
    {name="MM2 Vertex", url="https://raw.smokingscripts.org/vertex.lua", cat="Início"},
    {name="DOORS FourHub", url="https://raw.githubusercontent.com/jokerbiel13/FourHub/refs/heads/main/Doors.lua", cat="Início"},
    {name="DOORS ShadowHub", url="https://shadowhub.pro/api/shadow", cat="Início"},
    {name="DOORS Fable Hub", url="https://raw.githubusercontent.com/Havickzi/Rocket-script/refs/heads/main/Fable_Hub.lua", cat="Início"},
    {name="Pressure ROSHAN", url="https://raw.githubusercontent.com/ROSHANDVS2/ROSHAN-NEW-SCRIPT/refs/heads/main/PRESSURE-SCRIPT-LOADER-.lua", cat="Início"},
    {name="Pressure Spider Hub", url="https://raw.githubusercontent.com/SpiderScriptRB/Pressure/refs/heads/main/Protected_1550309234935669.txt", cat="Início"},
    {name="Pressure Fire Hub", url="https://raw.githubusercontent.com/InfernusScripts/Fire-Hub/main/Loader", cat="Início"},
    {name="Piggy Veno Hub", url="https://raw.githubusercontent.com/totallynothimplayz/Jd/refs/heads/main/Veno%20Hub", cat="Início"},
    {name="Piggy Item Finder", url="https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source", cat="Início"},
    {name="Jailbreak Tase Hub", url="https://raw.githubusercontent.com/banibacks20001/Tase-Hub/3e55f2c331f411250d26f73324e3d45cb7ee9ba5/Tase-Hub.lua", cat="Início"},
    {name="Adopt Me! Zeke Hub", url="https://zekehub.com/scripts/Loader.lua", cat="Início"},
    {name="Pet Simulator 99", url="https://raw.githubusercontent.com/SlamminPig/6FootScripts/main/Scripts/PetSimulator99.lua", cat="Início"},
    {name="Murderers vs Sheriffs Duels", url="https://raw.githubusercontent.com/iDepHub/iDepHub-DMVS/refs/heads/main/Duels.lua", cat="Início"},
    {name="Arsenal Hitbox", url="https://scriptblox.com/raw/HITBOX-EXPANDER_750", cat="Início"},
    {name="BedWars Vape", url="https://raw.githubusercontent.com/VapeVoidware/vapevoidware/main/NewMainScript.lua", cat="Início"},
    {name="Evade [KEY]", url="https://raw.githubusercontent.com/marcelosero7-cyber/Algolevade/refs/heads/main/obfuscated.lua%20(15).txt", cat="Início"},
    {name="Mad City [KEY]", url="https://raw.githubusercontent.com/devforroblox/rubyhubv2util/refs/heads/main/arv2", cat="Início"},
    {name="Anime Adventures", url="https://pastebin.com/raw/g7RFNhYY", cat="Início"},
    {name="Anime Defenders [KEY]", url="https://pastefy.app/I3MovqNs/raw", cat="Início"},
    {name="Gym League Chaos Hub", url="https://rawscripts.net/raw/Universal-Script-Chaos-Hub-Universal-15-supported-games-78651", cat="Início"},
    {name="Build a Boat AutoFarm", url="https://raw.githubusercontent.com/scarabhub/buildaboatAutoFarm/refs/heads/main/main.lua", cat="Início"},
    {name="Natural Disaster Survival", url="https://raw.githubusercontent.com/zeroidxx/axe-hub/refs/heads/main/axehub%20nds.txt", cat="Início"},
    {name="Theme Park Tycoon 2", url="https://pastebin.ai/raw/xmDHQQLFC", cat="Início"},
    {name="Flee the Facility", url="https://raw.githubusercontent.com/ghostofcelleron/Celeron/refs/heads/main/Flee%20The%20Facility%20(OS)", cat="Início"},
    {name="Prison Life GoyHub", url="https://raw.githubusercontent.com/xyqvt/goyhub/refs/heads/main/prisonlife", cat="Início"},
    {name="Vehicle Tycoon", url="https://raw.githubusercontent.com/Bjkefe2/myhub/main/BJKEFE2hUB", cat="Início"},
    {name="Steal an Egg", url="https://raw.githubusercontent.com/ClouthubOnTop/Loader/main/main.lua", cat="Início"},
    {name="EB do Delta", url="https://api.jnkie.com/api/v1/loaders/public/ed39c2433d9562d5f7ace2a1d9ffdc25165172506c33862b9282330584a8fa58/download", cat="Início"},
    {name="Blox Fruits Speed Hub X", url="https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua", cat="Início"},
    {name="99 Nights", url="https://pastebin.com/raw/LPbPPNpC", cat="Início"},
    {name="Blade Ball Lunar", url="https://raw.githubusercontent.com/mzkv/LUNAR/refs/heads/main/BladeBall", cat="Início"},
    {name="Rivals Z3US", url="https://raw.githubusercontent.com/blackowl1231/Z3US/refs/heads/main/main.lua", cat="Início"},
    {name="Brookhaven Base", url="https://raw.githubusercontent.com/realgengar/Main/refs/heads/main/base.lua", cat="Início"},
    {name="Fisch Speed Hub X", url="https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua", cat="Início"},
    {name="Loomian Legacy", url="https://raw.githubusercontent.com/Introvert1337/Releases/master/LoomianLegacyX.lua", cat="Início"},
    {name="Entry Point Parmesan Hub", url="https://raw.githubusercontent.com/RawParmesan/Parmesan-Hub/main/Loader", cat="Início"},
    {name="The Wild West", url="https://raw.githubusercontent.com/olympokram/new/refs/heads/main/Scripts/tww.lua", cat="Início"},
    {name="World of Stands Shar", url="https://raw.githubusercontent.com/lobox920/Shar-Script/main/World%20of%20Stands.lua", cat="Início"},
    {name="Shar Loader", url="https://raw.githubusercontent.com/lobox920/Shar-Script/main/loader.lua", cat="Início"},
    {name="Sol's RNG BeeconHub", url="https://raw.githubusercontent.com/BaconBossScript/BeeconHub/main/BeeconHub", cat="Início"},
    {name="Dungeon RNG Lomu Hub", url="https://raw.githubusercontent.com/notyourfavorite1/lomuhubmain/refs/heads/main/mainV2.5.lua", cat="Início"},
    {name="Treasure Quest 6Foot", url="https://raw.githubusercontent.com/SlamminPig/6FootScripts/main/Scripts/TreasureQuest.lua", cat="Início"},
    {name="Adventure Up!", url="https://pastebin.com/raw/7b9WgNYr", cat="Início"},
    {name="Fantastic Frontier", url="https://raw.githubusercontent.com/x7dJJ9vnFH23/Maintained-Fun/main/FUNC/NewLoader.lua", cat="Início"},
    {name="Slap Tower 4 Obf", url="https://github.com/contateste8/SlapTower4/raw/refs/heads/main/SlapTower4Obf.txt", cat="Início"},
    {name="Tower Hell SprinHub", url="https://raw.githubusercontent.com/dqvh/dqvh/main/SprinHub", cat="Início"},
    {name="Slap Tower 1 Thinking", url="https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source", cat="Início"},
    {name="DUELS Zxxnxgz Loader", url="https://raw.githubusercontent.com/vl5613580-arch/zxxnxgz/main/loader.lua", cat="Início"},
    {name="+1 Loot To Forge", url="https://pastebin.ai/raw/fvdvvx4RE", cat="Início"},
    {name="Steal ASMR", url="https://pastebin.ai/raw/b8vweFMiP", cat="Início"},
    {name="Cook An Animal", url="https://pastebin.ai/raw/TTyXX0rFo", cat="Início"},
    {name="Punch Aura", url="https://pastefy.app/q3DwR4qd/raw", cat="Início"},
    {name="Grow a Chicken Fighter", url="https://pastebin.ai/raw/684ZxaqEt", cat="Início"},
    {name="Draw Me", url="https://ancestrychanged.fun/loader.lua", cat="Início"},
}

local gui = Instance.new("ScreenGui") gui.Name="ToolsHub" gui.ResetOnSpawn=false gui.IgnoreGuiInset=true gui.DisplayOrder=999 gui.Parent=playerGui
local function corner(o,r) local c=Instance.new("UICorner") c.CornerRadius=UDim.new(0,r) c.Parent=o return c end
local function stroke(o,color,t) local s=Instance.new("UIStroke") s.Color=color s.Transparency=t or 0.6 s.Thickness=1 s.Parent=o return s end
local function label(p,t,s,c,b) local l=Instance.new("TextLabel") l.BackgroundTransparency=1 l.Text=t l.TextSize=s l.TextColor3=c or TEXT l.Font=b and Enum.Font.GothamBold or Enum.Font.Gotham l.Parent=p return l end
local function tween(obj, props, time, style) TweenService:Create(obj, TweenInfo.new(time or 0.2, style or Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play() end

local main = Instance.new("Frame") main.Name="Main" main.Size=UDim2.fromOffset(560, 360) main.Position=UDim2.new(0.5, -280, 0.5, -180) main.BackgroundColor3=Color3.new(0, 0, 0) main.BackgroundTransparency=0.2 main.BorderSizePixel=0 main.Parent=gui corner(main, 16) stroke(main, ACCENT, 0.5)
main.BackgroundTransparency=1 tween(main, {BackgroundTransparency=0.2}, 0.3)

local top = Instance.new("Frame") top.Size=UDim2.new(1, 0, 0, 50) top.BackgroundTransparency=1 top.Parent=main top.Active=true
local logo = Instance.new("Frame") logo.Size=UDim2.fromOffset(26, 26) logo.Position=UDim2.fromOffset(16, 12) logo.BackgroundColor3=ACCENT logo.Parent=top corner(logo, 8)
local title = label(top, "Tools Hub", 17, TEXT, true) title.Position=UDim2.fromOffset(52, 8) title.Size=UDim2.fromOffset(200, 20) title.TextXAlignment=Enum.TextXAlignment.Left
local ver = label(top, "64 scripts • otavivio2", 12, MUTED) ver.Position=UDim2.fromOffset(52, 27) ver.Size=UDim2.fromOffset(200, 14) ver.TextXAlignment=Enum.TextXAlignment.Left
local closeBtn = Instance.new("TextButton") closeBtn.Size=UDim2.fromOffset(30, 30) closeBtn.Position=UDim2.new(1, -46, 0, 10) closeBtn.BackgroundColor3=Color3.fromRGB(60, 20, 20) closeBtn.Text="×" closeBtn.TextColor3=TEXT closeBtn.TextSize=20 closeBtn.Font=Enum.Font.GothamBold closeBtn.Parent=top corner(closeBtn, 8)
local minBtn = Instance.new("TextButton") minBtn.Size=UDim2.fromOffset(30, 30) minBtn.Position=UDim2.new(1, -82, 0, 10) minBtn.BackgroundColor3=Color3.fromRGB(40, 40, 50) minBtn.Text="–" minBtn.TextColor3=TEXT minBtn.TextSize=20 minBtn.Font=Enum.Font.GothamBold minBtn.Parent=top corner(minBtn, 8)

local dragging, startPos, startInput
top.InputBegan:Connect(function(input) if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then dragging=true startInput=input.Position startPos=main.Position end end)
top.InputEnded:Connect(function() dragging=false end)
UIS.InputChanged:Connect(function(input) if dragging and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then local d=input.Position-startInput main.Position=UDim2.new(startPos.X.Scale, startPos.X.Offset+d.X, startPos.Y.Scale, startPos.Y.Offset+d.Y) end end)

local side = Instance.new("Frame") side.Position=UDim2.fromOffset(12, 56) side.Size=UDim2.new(0, 150, 1, -68) side.BackgroundTransparency=1 side.Parent=main Instance.new("UIListLayout", side).Padding=UDim.new(0, 6)
local content = Instance.new("Frame") content.Position=UDim2.fromOffset(172, 56) content.Size=UDim2.new(1, -184, 1, -68) content.BackgroundColor3=Color3.fromRGB(255, 255, 255) content.BackgroundTransparency=0.95 content.Parent=main corner(content, 12)
local tabs, pages, refreshFuncs = {}, {}, {}

local function execScript(data) copyDiscord() task.spawn(function() pcall(function() loadstring(game:HttpGet(data.url))() end) end) end
local function selectTab(name) for n, btn in pairs(tabs) do local active=(n==name) tween(btn, {BackgroundTransparency=active and 0.85 or 1}, 0.15) btn.TextColor3=active and TEXT or MUTED pages[n].Visible=active end end

local function makeTab(name, filter)
    local btn = Instance.new("TextButton") btn.Size=UDim2.new(1,0,0,38) btn.BackgroundColor3=ACCENT btn.BackgroundTransparency=1 btn.Text=" "..name btn.TextXAlignment=Enum.TextXAlignment.Left btn.TextColor3=MUTED btn.TextSize=14 btn.Font=Enum.Font.GothamMedium btn.Parent=side corner(btn,10)
    btn.MouseEnter:Connect(function() if not pages[name].Visible then tween(btn, {BackgroundTransparency=0.9}, 0.1) end end)
    btn.MouseLeave:Connect(function() if not pages[name].Visible then tween(btn, {BackgroundTransparency=1}, 0.1) end end)
    local page = Instance.new("Frame") page.Size=UDim2.fromScale(1,1) page.BackgroundTransparency=1 page.Visible=false page.Parent=content
    local search = Instance.new("TextBox") search.Size=UDim2.new(1,-16,0,26) search.Position=UDim2.fromOffset(8,8) search.BackgroundColor3=Color3.fromRGB(20,15,30) search.Text="" search.PlaceholderText="🔍 Pesquisar 64..." search.PlaceholderColor3=MUTED search.TextColor3=TEXT search.Font=Enum.Font.Gotham search.TextSize=12 search.Parent=page corner(search,8)
    local scroll = Instance.new("ScrollingFrame") scroll.Position=UDim2.fromOffset(8,42) scroll.Size=UDim2.new(1,-16,1,-50) scroll.BackgroundTransparency=1 scroll.ScrollBarThickness=3 scroll.CanvasSize=UDim2.new(0,0,0,0) scroll.Parent=page
    local grid = Instance.new("UIGridLayout") grid.CellSize=UDim2.new(0.5,-4,0,48) grid.CellPadding=UDim2.fromOffset(6,6) grid.Parent=scroll

    local function refresh()
        for _,c in ipairs(scroll:GetChildren()) do if c:IsA("Frame") then c:Destroy() end end
        local q=string.lower(search.Text)
        for _,s in ipairs(Scripts) do
            if filter(s) then
                if q=="" or string.find(string.lower(s.name), q,1,true) then
                    local card=Instance.new("Frame") card.BackgroundColor3=Color3.fromRGB(30,20,45) card.Parent=scroll corner(card,8) stroke(card,ACCENT,0.8)
                    -- anim de entrada
                    card.BackgroundTransparency=1 tween(card, {BackgroundTransparency=0}, 0.25)

                    local nl=label(card, s.name, 8, TEXT, true) nl.Position=UDim2.fromOffset(6,4) nl.Size=UDim2.new(1,-30,0,28) nl.TextXAlignment=Enum.TextXAlignment.Left nl.TextWrapped=true nl.ZIndex=2

                    -- BOTAO PRINCIPAL (ATRAS)
                    local b=Instance.new("TextButton") b.Name="MainBtn" b.Size=UDim2.new(1,0,1,0) b.BackgroundTransparency=1 b.Text="" b.ZIndex=1 b.Parent=card
                    b.MouseEnter:Connect(function() tween(card, {BackgroundColor3=Color3.fromRGB(50,30,80)}, 0.15) end)
                    b.MouseLeave:Connect(function() tween(card, {BackgroundColor3=Color3.fromRGB(30,20,45)}, 0.15) end)
                    b.MouseButton1Click:Connect(function() tween(card, {BackgroundColor3=ACCENT}, 0.08) task.wait(0.08) tween(card, {BackgroundColor3=Color3.fromRGB(30,20,45)}, 0.12) execScript(s) end)

                    -- BOTAO FAVORITO (NA FRENTE - ZINDEX 3)
                    local fav=Instance.new("TextButton") fav.Name="FavBtn" fav.Position=UDim2.new(1,-24,0,4) fav.Size=UDim2.fromOffset(20,20) fav.BackgroundColor3=Color3.fromRGB(60,40,90) fav.Text=favorites[s.name] and "★" or "☆" fav.TextColor3=Color3.fromRGB(255,220,100) fav.Font=Enum.Font.GothamBold fav.TextSize=12 fav.ZIndex=3 fav.Parent=card corner(fav,6)
                    fav.MouseEnter:Connect(function() tween(fav, {BackgroundColor3=Color3.fromRGB(80,60,120)}, 0.1) end)
                    fav.MouseLeave:Connect(function() tween(fav, {BackgroundColor3=Color3.fromRGB(60,40,90)}, 0.1) end)
                    fav.MouseButton1Click:Connect(function()
                        -- toggle
                        if favorites[s.name] then favorites[s.name]=nil else favorites[s.name]=true end
                        saveFavorites()
                        -- anim pulinho
                        tween(fav, {Size=UDim2.fromOffset(24,24)}, 0.08)
                        task.wait(0.08)
                        tween(fav, {Size=UDim2.fromOffset(20,20)}, 0.08)
                        -- ATUALIZA TODAS AS ABAS
                        for _,fn in pairs(refreshFuncs) do fn() end
                    end)
                end
            end
        end
        scroll.CanvasSize=UDim2.new(0,0,0,grid.AbsoluteContentSize.Y+10)
    end

    search:GetPropertyChangedSignal("Text"):Connect(refresh)
    grid:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() scroll.CanvasSize=UDim2.new(0,0,0,grid.AbsoluteContentSize.Y+10) end)
    tabs[name]=btn pages[name]=page refreshFuncs[name]=refresh
    btn.MouseButton1Click:Connect(function() selectTab(name) refresh() end)
    refresh()
end

makeTab("Início", function(s) return true end)
makeTab("Universais", function(s) return s.cat=="Universal" end)
makeTab("Favoritos ☆", function(s) return favorites[s.name] end)

local btnOutros = Instance.new("TextButton") btnOutros.Size=UDim2.new(1,0,0,38) btnOutros.BackgroundColor3=ACCENT btnOutros.BackgroundTransparency=1 btnOutros.Text=" Outros" btnOutros.TextXAlignment=Enum.TextXAlignment.Left btnOutros.TextColor3=MUTED btnOutros.TextSize=14 btnOutros.Font=Enum.Font.GothamMedium btnOutros.Parent=side corner(btnOutros,10)
local outrosPage = Instance.new("Frame") outrosPage.Size=UDim2.fromScale(1,1) outrosPage.BackgroundTransparency=1 outrosPage.Visible=false outrosPage.Parent=content
local h = label(outrosPage, "Outros", 18, TEXT, true) h.Position=UDim2.fromOffset(12,10) h.Size=UDim2.new(1,-24,0,22) h.TextXAlignment=Enum.TextXAlignment.Left
local card = Instance.new("Frame") card.Position=UDim2.fromOffset(12,40) card.Size=UDim2.new(1,-24,0,70) card.BackgroundColor3=Color3.fromRGB(30,20,45) card.Parent=outrosPage corner(card,10) stroke(card,ACCENT,0.7)
local avatar = Instance.new("ImageLabel") avatar.Position=UDim2.fromOffset(8,8) avatar.Size=UDim2.fromOffset(54,54) avatar.BackgroundTransparency=1 avatar.Parent=card corner(avatar,27)
local disp = label(card, player.DisplayName, 13, TEXT, true) disp.Position=UDim2.fromOffset(72,8) disp.Size=UDim2.new(1,-80,0,18) disp.TextXAlignment=Enum.TextXAlignment.Left
local user = label(card, "@"..player.Name.." • otavivio2", 11, MUTED) user.Position=UDim2.fromOffset(72,26) user.Size=UDim2.new(1,-80,0,14) user.TextXAlignment=Enum.TextXAlignment.Left
local role = label(card, "👑 Criador Tools Hub", 10, ACCENT, true) role.Position=UDim2.fromOffset(72,42) role.Size=UDim2.new(1,-80,0,14) role.TextXAlignment=Enum.TextXAlignment.Left
pcall(function() avatar.Image=Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100) end)
local discordBox = Instance.new("TextBox") discordBox.Position=UDim2.fromOffset(12,120) discordBox.Size=UDim2.new(1,-24,0,30) discordBox.BackgroundColor3=Color3.fromRGB(20,15,30) discordBox.Text=DISCORD_LINK discordBox.TextColor3=TEXT discordBox.Font=Enum.Font.Gotham discordBox.TextSize=11 discordBox.TextEditable=false discordBox.Parent=outrosPage corner(discordBox,8)
local copyBtn = Instance.new("TextButton") copyBtn.Position=UDim2.fromOffset(12,158) copyBtn.Size=UDim2.new(1,-24,0,36) copyBtn.BackgroundColor3=ACCENT copyBtn.Text="📋 COPIAR DISCORD" copyBtn.TextColor3=TEXT copyBtn.Font=Enum.Font.GothamBold copyBtn.TextSize=13 copyBtn.Parent=outrosPage corner(copyBtn,10)
copyBtn.MouseButton1Click:Connect(function() copyDiscord() copyBtn.Text="✅ COPIADO!" task.wait(1.5) copyBtn.Text="📋 COPIAR DISCORD" end)
tabs["Outros"]=btnOutros pages["Outros"]=outrosPage
btnOutros.MouseButton1Click:Connect(function() selectTab("Outros") end)
selectTab("Início")

local pill = Instance.new("Frame") pill.Name="Minimized" pill.Size=UDim2.fromOffset(190, 42) pill.Position=UDim2.new(0.5, -95, 0, 20) pill.BackgroundColor3=Color3.new(0, 0, 0) pill.BackgroundTransparency=0.2 pill.BorderSizePixel=0 pill.Visible=false pill.Parent=gui corner(pill, 21) stroke(pill, ACCENT, 0.5)
local handle = Instance.new("TextButton") handle.Size=UDim2.fromOffset(44, 42) handle.BackgroundTransparency=1 handle.Text="+" handle.TextColor3=ACCENT handle.TextSize=24 handle.Font=Enum.Font.GothamBold handle.Parent=pill
local pillLogo = Instance.new("Frame") pillLogo.Size=UDim2.fromOffset(20, 20) pillLogo.Position=UDim2.fromOffset(56, 11) pillLogo.BackgroundColor3=ACCENT pillLogo.Parent=pill corner(pillLogo, 6)
local openBtn = Instance.new("TextButton") openBtn.Position=UDim2.fromOffset(82, 0) openBtn.Size=UDim2.new(1, -90, 1, 0) openBtn.BackgroundTransparency=1 openBtn.Text="Tools Hub" openBtn.TextColor3=TEXT openBtn.TextSize=15 openBtn.Font=Enum.Font.GothamMedium openBtn.TextXAlignment=Enum.TextXAlignment.Left openBtn.Parent=pill
local dragging2, startPos2, startInput2
handle.InputBegan:Connect(function(input) if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then dragging2=true startInput2=input.Position startPos2=pill.Position end end)
handle.InputEnded:Connect(function() dragging2=false end)
UIS.InputChanged:Connect(function(input) if dragging2 and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then local d=input.Position-startInput2 pill.Position=UDim2.new(startPos2.X.Scale, startPos2.X.Offset+d.X, startPos2.Y.Scale, startPos2.Y.Offset+d.Y) end end)

local confirmBg = Instance.new("Frame") confirmBg.Name="ConfirmBg" confirmBg.Size=UDim2.fromScale(1,1) confirmBg.BackgroundColor3=Color3.new(0,0,0) confirmBg.BackgroundTransparency=0.5 confirmBg.Visible=false confirmBg.Parent=gui
local confirmFrame = Instance.new("Frame") confirmFrame.Size=UDim2.fromOffset(300, 140) confirmFrame.Position=UDim2.new(0.5,-150,0.5,-70) confirmFrame.BackgroundColor3=Color3.fromRGB(20,15,30) confirmFrame.Parent=confirmBg corner(confirmFrame,12) stroke(confirmFrame, ACCENT, 0.6)
local confirmTitle = label(confirmFrame, "Fechar o Hub?", 16, TEXT, true) confirmTitle.Position=UDim2.fromOffset(0,12) confirmTitle.Size=UDim2.new(1,0,0,20) confirmTitle.TextXAlignment=Enum.TextXAlignment.Center
local confirmDesc = label(confirmFrame, "Você realmente quer fechar o hub?\nObs: isso vai fechar e parar tudo!", 12, MUTED) confirmDesc.Position=UDim2.fromOffset(12,36) confirmDesc.Size=UDim2.new(1,-24,0,40) confirmDesc.TextXAlignment=Enum.TextXAlignment.Center
local yesBtn = Instance.new("TextButton") yesBtn.Size=UDim2.fromOffset(120,32) yesBtn.Position=UDim2.fromOffset(16,96) yesBtn.BackgroundColor3=Color3.fromRGB(200,50,50) yesBtn.Text="SIM, FECHAR" yesBtn.TextColor3=TEXT yesBtn.Font=Enum.Font.GothamBold yesBtn.TextSize=11 yesBtn.Parent=confirmFrame corner(yesBtn,8)
local noBtn = Instance.new("TextButton") noBtn.Size=UDim2.fromOffset(120,32) noBtn.Position=UDim2.fromOffset(164,96) noBtn.BackgroundColor3=Color3.fromRGB(50,50,60) noBtn.Text="CANCELAR" noBtn.TextColor3=TEXT noBtn.Font=Enum.Font.GothamBold noBtn.TextSize=11 noBtn.Parent=confirmFrame corner(noBtn,8)
noBtn.MouseButton1Click:Connect(function() confirmBg.Visible=false end)
yesBtn.MouseButton1Click:Connect(function() tween(main, {BackgroundTransparency=1}, 0.2) task.wait(0.2) gui:Destroy() end)
minBtn.MouseButton1Click:Connect(function() tween(main, {BackgroundTransparency=1}, 0.15) task.wait(0.15) main.Visible=false pill.Visible=true pill.BackgroundTransparency=1 tween(pill, {BackgroundTransparency=0.2}, 0.2) end)
openBtn.MouseButton1Click:Connect(function() tween(pill, {BackgroundTransparency=1}, 0.15) task.wait(0.15) pill.Visible=false main.Visible=true main.BackgroundTransparency=1 tween(main, {BackgroundTransparency=0.2}, 0.2) end)
closeBtn.MouseButton1Click:Connect(function() confirmBg.Visible=true confirmFrame.Size=UDim2.fromOffset(280,130) tween(confirmFrame, {Size=UDim2.fromOffset(300,140)}, 0.2, Enum.EasingStyle.Back) end)
]====]

if isfile and isfile(SAVE_KEY_FILE) then local ok,s = pcall(function() return readfile(SAVE_KEY_FILE):gsub("^%s+",""):gsub("%s+$","") end) if ok and validKeys[s] then local f=loadstring(HUB_CODE) if f then f() return end end end
local ACCENT = Color3.fromRGB(168, 85, 247) local TEXT = Color3.fromRGB(240,240,245)
local function corner(o,r) local c=Instance.new("UICorner") c.CornerRadius=UDim.new(0,r) c.Parent=o return c end
local function stroke(o,color,t) local s=Instance.new("UIStroke") s.Color=color s.Transparency=t or 0.6 s.Thickness=1 s.Parent=o return s end
local keyGui = Instance.new("ScreenGui") keyGui.Name="KeySystem" keyGui.ResetOnSpawn=false keyGui.IgnoreGuiInset=true keyGui.DisplayOrder=9999 keyGui.Parent=playerGui
local keyMain = Instance.new("Frame", keyGui) keyMain.Size=UDim2.fromOffset(400, 280) keyMain.Position=UDim2.new(0.5,-200,0.5,-140) keyMain.BackgroundColor3=Color3.new(0,0,0) keyMain.BackgroundTransparency=0.2 keyMain.BorderSizePixel=0 keyMain.Active=true keyMain.Draggable=true keyMain.Parent=keyGui corner(keyMain,16) stroke(keyMain,ACCENT,0.5)
local input = Instance.new("TextBox", keyMain) input.Size=UDim2.new(1,-32,0,38) input.Position=UDim2.fromOffset(16,60) input.BackgroundColor3=Color3.fromRGB(255,255,255) input.BackgroundTransparency=0.95 input.PlaceholderText="Enter Key..." input.Text="" input.Font=Enum.Font.Gotham input.TextSize=14 input.TextColor3=Color3.new(0,0,0) input.Parent=keyMain corner(input,10)
local function makeBtn(txt,pos,color) local b=Instance.new("TextButton") b.Size=UDim2.fromOffset(170,36) b.Position=pos b.BackgroundColor3=color b.Text=txt b.Font=Enum.Font.GothamBold b.TextSize=13 b.TextColor3=TEXT b.Parent=keyMain corner(b,10) return b end
local getKey = makeBtn("Get Key",UDim2.fromOffset(16,130),Color3.fromRGB(50,50,60))
local checkKey = makeBtn("Check Key",UDim2.fromOffset(214,130),ACCENT)
getKey.MouseButton1Click:Connect(function() if setclipboard then setclipboard(linkKeyURL) end end)
checkKey.MouseButton1Click:Connect(function() local k=input.Text:gsub("^%s+",""):gsub("%s+$","") if validKeys[k] then if writefile then pcall(function() writefile(SAVE_KEY_FILE,k) end) end keyGui:Destroy() local f=loadstring(HUB_CODE) if f then f() end end end)