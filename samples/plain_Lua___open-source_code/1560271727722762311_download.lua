local Junkie = loadstring(game:HttpGet("https://jnkie.com/sdk/library.lua"))()
Junkie.service = "Vyrnox Hub"
Junkie.identifier = "1107901"
Junkie.provider = "P1"

local result = (function()
 getgenv().UI_CLOSED = false

 local Players = game:GetService("Players")
 local CoreGui = game:GetService("CoreGui")

 local ObsidianRepo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
 local Library = loadstring(game:HttpGet(ObsidianRepo .. "Library.lua"))()

 local KEY_FILE = "verified_key.txt"

 local function FSSupported()
  return type(writefile) == "function"
   and type(readfile) == "function"
   and type(isfile) == "function"
   and type(delfile) == "function"
 end

 local function SaveVerifiedKey(key)
  if FSSupported() then pcall(writefile, KEY_FILE, key) end
 end

 local function LoadVerifiedKey()
  if not FSSupported() then return nil end
  local ok, content = pcall(readfile, KEY_FILE)
  if ok and type(content) == "string" and content ~= "" then
   return content
  end
  return nil
 end

 local function ClearSavedKey()
  if FSSupported() then pcall(delfile, KEY_FILE) end
 end

 local UI_CLOSED = false
 local KeyValue = ""

 local Window = Library:CreateWindow({
  Title = "Vyrnox Hub",
  Footer = "Key System",
  Icon = "rbxassetid://101275391050007",
  Center = true,
  AutoShow = true,
  Size = UDim2.fromOffset(500, 300),
  TabPadding = 8,
  MenuFadeTime = 0.15,
 })

 local Tab = Window:AddTab("Key", "rbxassetid://117047144730308")
 local Group = Tab:AddLeftGroupbox("Verification", "rbxassetid://84528813312016")

 local function CloseLibrary()
  pcall(function() if Library.Unload then Library:Unload() end end)
  pcall(function() if Library.Destroy then Library:Destroy() end end)
  pcall(function() if Window.Close then Window:Close() end end)
 end

 pcall(function()
  if Library.OnUnload then
   Library:OnUnload(function() UI_CLOSED = true end)
  end
 end)

 task.spawn(function()
  task.wait(0.5)
  local gui = Library.ScreenGui or Library.Gui or Library.GUI
  if not gui then
   for _, child in ipairs(CoreGui:GetChildren()) do
    if child:IsA("ScreenGui") and child.Name:lower():find("obsidian") then
     gui = child
     break
    end
   end
  end
  if gui then
   gui.AncestryChanged:Connect(function(_, parent)
    if not parent then UI_CLOSED = true end
   end)
  end
 end)

 local function FinishSuccess(key, message)
  getgenv().SCRIPT_KEY = key

  Library:Notify({
   Title = "Key System",
   Description = message or "Key Verified",
   Time = 4,
  })

  task.delay(1.2, function()
   CloseLibrary()
   UI_CLOSED = true
  end)
 end

 Group:AddInput("KeyInput", {
  Text = "License Key",
  Default = "",
  Placeholder = "VYRNOX-",
  Callback = function(v) KeyValue = v or "" end,
 })

 Group:AddButton({
  Text = "Get Link",
  Func = function()
   local ok, link = pcall(function() return Junkie.get_key_link() end)
   if not ok or not link then
    Library:Notify({ Title = "Key System", Description = "System not initialized", Time = 3 })
    return
   end

   if type(setclipboard) == "function" then
    pcall(setclipboard, link)
    Library:Notify({ Title = "Key System", Description = "Link copied to clipboard!", Time = 3 })
   else
    Library:Notify({ Title = "Key System", Description = "Get link: " .. link, Time = 10 })
   end
  end,
 })

 Group:AddButton({
  Text = "Verify Key",
  Func = function()
   local key = (KeyValue or ""):gsub("%s+", "")
   if key == "" then
    Library:Notify({ Title = "Key System", Description = "Please enter a key", Time = 4 })
    return
   end

   Library:Notify({ Title = "Key System", Description = "Verifying...", Time = 3 })

   local ok, res = pcall(function() return Junkie.check_key(key) end)

   if ok and res and res.valid then
    SaveVerifiedKey(key)
    FinishSuccess(key, "Key verified!")
   else
    Library:Notify({ Title = "Key System", Description = "Invalid key", Time = 4 })
   end
  end,
 })

 task.spawn(function()
  task.wait(0.3)

  local savedKey = LoadVerifiedKey()
  local keyToCheck = savedKey or getgenv().SCRIPT_KEY or ""

  local ok, res = pcall(function() return Junkie.check_key(keyToCheck) end)

  if not (ok and res and res.valid) then
   if savedKey and res and not res.key_valid then
    ClearSavedKey()
   end
   return
  end

  if res.message == "KEYLESS" then
   FinishSuccess("KEYLESS", "Keyless Mode")
   return
  end

  if res.message == "KEY_VALID" then
   if not savedKey and keyToCheck ~= "" then SaveVerifiedKey(keyToCheck) end
   FinishSuccess(keyToCheck, "Key Verified")
   return
  end
 end)

 while not UI_CLOSED do
  task.wait(0.1)
 end

 return getgenv().SCRIPT_KEY
end)()

do ("JNKIE Loader - Unauthorized tampering or debugging of protected scripts is strictly prohibited and may result in a global blacklist from JNKIE protected scripts."):sub(1,1);local k=getgenv().SCRIPT_KEY or SCRIPT_KEY;local m="Could not load the script. Check your internet connection and try again later.";local function v(h)warn(h);task.spawn(function()pcall(function()game:GetService("Players").LocalPlayer:Kick(h)end);task.wait();pcall(function()local p=game:GetService("CoreGui").RobloxPromptGui.promptOverlay.ErrorPrompt;p.TitleFrame.ErrorTitle.Text="JNKIE";p.MessageArea.ErrorFrame.ErrorMessage.Text=h end)end)end;local r=(type(syn)=="table" and type(syn.request)=="function" and syn.request)or(type(request)=="function" and request)or(type(http_request)=="function" and http_request)or(type(http)=="table" and type(http.request)=="function" and http.request);if type(k)~="string" then v("No key provided. Get a key from the script provider, enter it, then try again.");return end;if type(r)~="function" then warn(m);return end;local function q(o)local d,a,x;task.spawn(function()a,x=pcall(r,o);d=true end);local s=os.clock();repeat task.wait()until d or os.clock()-s>15;if not d then return false,nil end;return a,x end;local a,x=q({Url="https://api.jnkie.com/api/v1/luascripts/delivery/b3eb88f529415bf4ba11197f32d533a0c8dc6dcb906154978e9f420de39f345e?v=2&errors=text",Method="POST",Headers={["Content-Type"]="text/plain"},Body=k});local h=a and type(x)=="table" and type(x.Body)=="string" and(x.StatusCode==400 or x.StatusCode==401 or x.StatusCode==403)and x.Body;if h then local c,n=h:match("^([^\r\n]+)\n([^\r\n]+)$");c=c or h;if#c<=75 and(c=="LDR-DENIED"or c:match("^LDR%-DENIED:[A-Z_]+$"))then if not n or#n>512 then n=m;if k==""or k:match("^%s*$")then n="No key provided. Get a key from the script provider, enter it, then try again." end end;v(n.." ("..c..")");return end end;if a and type(x)=="table" and x.StatusCode==200 and type(x.Body)=="string" and (string.sub(x.Body,1,8)=="https://") then a,x=q({Url=x.Body,Method="GET"})end;if a and type(x)=="table" and(x.StatusCode==302 or x.StatusCode==303)then local h=x.Headers or x.headers;local l=type(h)=="table" and(h.Location or h.location);if type(l)=="string" and (string.sub(l,1,8)=="https://") then a,x=q({Url=l,Method="GET"})end end;if not a or type(x)~="table" or x.StatusCode~=200 or type(x.Body)~="string" or#x.Body==0 then warn(m);return end;local b=x.Body;x=nil;local f=loadstring(b);b=nil;if type(f)~="function" then warn(m);return end;f()end