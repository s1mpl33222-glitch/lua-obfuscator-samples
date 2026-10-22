--[[

               %%%%%%%%%             %%%%%%%%            
            %%%%%%%%%##%%%         %%%%%%%%%%%%          
           %%%%%%                          %%%%%         
          %%%#                               %%%%        
         %%%         ::::::::::::::-           %#%       
         %%    ::::::::::::::::::::::::::       ##       
            :::::::::::::::::::::::::::::::::            
         :::-----:::::::::::::::::::::::::---::          
       ---:........:--::::::::::::::::........:---       
     --:..............--:::::::::::..............:-      
    --.................:-::::::::......::-:........--    
   --.........+%%%%%%=...-::::-:....+%%%%%%#*-......--   
  --:.......-%%%%%%%***:.--:::-...:#%%%%%%#+*#-.....---  
 --=:.:::..-%%%%%%%%**#+.:-::::..:+%%%%%%%%%%%+.....:-:- 
---=:::::::=%%%%%%%%%%%=.:-::--.::-%%%%%%%%%%*:.....--:: 
---=-:::::::*%%%%%%%%%+..---:--::::-*%%%%%%#-.......=-::-
---==::::::::-*%%%%%*:..-=-----=::::::::::::......:=-::::
----==-::::::::::::....-=-------=-:::::::::::....-=----::
---====+-:::::::::..:==-----------=-::::::::.::==-------:
---=======++=----=++=----------------==+++++==+**=-----::
---=============-----------------------------==%%%=----- 
 --=============----------------------------=#%+-------- 
  --==================-------------------=#%*=---------  
  ---======*##+=========------------=+*%#+=-----------   
    --========+*#%##**++====+++*##%#*+=-------------:    
     ---===========++*********++======-------------      
       ---===============================---------       
         ---=============================-------         
            ----========================-----            
               ------===============-----                
                     --------------=                     

                           _       _           _  _   
 _ __ ___  ___ _ __   __ _(_)_ __ | |_  __   _| || |  
| '_ ` _ \/ __| '_ \ / _` | | '_ \| __| \ \ / / || |_ 
| | | | | \__ \ |_) | (_| | | | | | |_   \ V /|__   _|
|_| |_| |_|___/ .__/ \__,_|_|_| |_|\__|   \_/    |_|  
              |_|                                     

              hello skid, shit code hey?
--]]

--// Store key for Luarmor \\--
local RemoveKeyFromEnv = function()
    getgenv().script_key = nil
    shared.script_key    = nil
    script_key           = nil
    used_saved_key       = nil
end

local SetKeyToShared = function(newKey, isSaved)
    RemoveKeyFromEnv()

    script_key = newKey
    used_saved_key = isSaved
end

--// luarmor sdk \\--
local KEY_VALID         = "KEY_VALID"

local LuarmorApiErrors = {
    SECURITY_ERROR      = true,
    TIME_ERROR          = true,
    UNKNOWN_ERROR       = true,
    SCRIPT_ID_INVALID   = true,
    SCRIPT_ID_INCORRECT = true,
    INVALID_EXECUTOR    = true
}

--// Script Variables \\--
local KeyFolder = "mspaint"
local KeyFile = KeyFolder .. "/key.txt"
local TosFile = KeyFolder .. "/tos.txt"

local LoaderId = "002c19202c9946e6047b0c6e0ad51f84"
local LoaderScript = "https://api.luarmor.net/files/v4/loaders/" .. LoaderId .. ".lua"

--// Luarmor SDK API \\--
local LuarmorAPI = (loadstring(game:HttpGet("https://sdkapi-public.luarmor.net/library.lua")) :: any)();
LuarmorAPI.script_id = LoaderId;

--// Load function \\--
local cloneref = (cloneref or clonereference or function(...) return (...) end)

--// Language \\--
local LanguageHelper = {}; do
    local HttpService = cloneref(game:GetService("HttpService"))
    local LocalizationService = cloneref(game:GetService("LocalizationService"))

    local Translations = nil
    local FetchJson = function(path)
        local Success, Result = pcall(function()
            return HttpService:JSONDecode(game:HttpGet("https://raw.githubusercontent.com/mspaint-cc/translations/refs/heads/main/" .. path .. ".json"))
        end)

        return if Success and typeof(Result) == "table" then Result else nil
    end

    local ResolveLanguage = function(languageMap, language)
        local ExactData = languageMap[language]
        if ExactData and not ExactData.Default then return language end

        local MainLanguage, Locale = unpack(language:split("-"))
        local LanguageData = languageMap[MainLanguage]
        if not LanguageData then return "en" end
        if not LanguageData.Default then return MainLanguage end

        if Locale and typeof(LanguageData[Locale]) == "table" then
            return MainLanguage .. "-" .. Locale
        end

        return MainLanguage .. "-" .. LanguageData.Default
    end

    local LoadTranslations = function()
        local ReadSuccess, SavedLanguage = pcall(readfile, "mspaint/language.txt")
        local Language = if ReadSuccess and typeof(SavedLanguage) == "string" then string.lower((SavedLanguage:gsub("%s+", ""))) else ""

        if Language == "" then
            Language = string.lower(LocalizationService.SystemLocaleId)
            if Language:match("^en%-") then return {} end
        end

        if Language == "en" then return {} end

        local LanguageMap = FetchJson("Languages")
        if not LanguageMap then return {} end

        Language = ResolveLanguage(LanguageMap, Language)
        if Language == "en" then return {} end

        return FetchJson("translations/" .. Language:gsub("%-", "/")) or {}
    end

    LanguageHelper.GetTranslation = function(self, key)
        if not Translations then Translations = LoadTranslations() end

        local Translation = Translations[key]
        return if typeof(Translation) == "string" and Translation ~= "" then Translation else key
    end

    LanguageHelper.GetTranslationFormatted = function(self, key, ...)
        local Success, Formatted = pcall(string.format, self:GetTranslation(key), ...)
        return if Success then Formatted else string.format(key, ...)
    end
end

local LoadScript = function()
    local KickPlayer = false

    local env = getgenv()
    local _, executor = pcall(identifyexecutor)

    if env.Cobalt then
        KickPlayer = true
    end

    if env.SimpleSpy then
        KickPlayer = true
    end

    if env.oh then
        KickPlayer = true
    end
    
    if env.gethsfuncs or _G.moduleData then
        KickPlayer = true
    end

    if executor ~= "Velocity" and (env.globalcontainer or _G.globalcontainer) then
        KickPlayer = true
    end

    if KickPlayer == true then
        local Players = cloneref(game:GetService("Players"))
        Players.LocalPlayer:Kick(LanguageHelper:GetTranslation("Please rejoin and don't run any development tool, this prevented you a ban."))
        return
    end

    loadstring(game:HttpGet(LoaderScript))()
end

--// Key Helper Functions \\--
local TrimKey = function(key)
    if typeof(key) ~= "string" then return nil end

    local Trimmed = key:match("^%s*(.-)%s*$")
    if Trimmed == "" or #Trimmed < 32 then return nil end

    return Trimmed
end

local GetStatusCode = function(status)
    if typeof(status) ~= "table" then return "" end
    return tostring(status.code or "")
end

local GetStatusErrorMessage = function(status)
    local Code = GetStatusCode(status)
    local ErrorMessages = {
        ["KEY_EXPIRED"]     = LanguageHelper:GetTranslation("The key expired. You need to re-new your key."),
        ["KEY_HWID_LOCKED"] = LanguageHelper:GetTranslation("The key is locked to a different HWID. Reset your HWID using the user dashboard."),
        ["KEY_INCORRECT"]   = LanguageHelper:GetTranslation("The key is invalid/deleted."),
        ["KEY_INVALID"]     = LanguageHelper:GetTranslation("The key is invalid/deleted."),
        ["KEY_BANNED"]      = LanguageHelper:GetTranslation("This key is blacklisted.")
    }

    if ErrorMessages[Code] then
        return ErrorMessages[Code]
    end

    if typeof(status) == "table" and typeof(status.message) == "string" and status.message ~= "" then
        return status.message
    end

    return LanguageHelper:GetTranslationFormatted("Failed to verify the key: %s", Code)
end

--// Check saved key from UI \\--
local HasAcceptedTos = pcall(function() assert(isfile(TosFile)) end)
local PendingTos = false

local saved_key_invalid; do
    if not script_key then
        pcall(function()
            if not isfile(KeyFile) then return end
            SetKeyToShared(readfile(KeyFile), true)
        end)
    end

    local TrimmedKey = TrimKey(script_key or shared.script_key or getgenv().script_key)
    if TrimmedKey then
        if used_saved_key == true then
            local Status = LuarmorAPI.check_key(TrimmedKey)
            local StatusCode = GetStatusCode(Status)

            if StatusCode == KEY_VALID then
                used_saved_key = true
            else
                saved_key_invalid = GetStatusErrorMessage(Status)

                if not LuarmorApiErrors[StatusCode] and StatusCode ~= "KEY_HWID_LOCKED" then
                    pcall(delfile, KeyFile)
                end

                TrimmedKey = nil
            end
        end

        if TrimmedKey then
            SetKeyToShared(TrimmedKey, used_saved_key)

            if HasAcceptedTos then
                LoadScript()
                return
            end

            PendingTos = true
        end
    end
end

--// Key UI \\--
local AssetName = "mspaint_ud"
local NotifyTitle = "mspaint"

local KeyLibrary = (loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/main/Library.lua")) :: any)()
local Options = KeyLibrary.Options
local Toggles = KeyLibrary.Toggles

KeyLibrary.ImageManager.AddAsset(AssetName, 95816097006870, "https://raw.githubusercontent.com/mspaint-cc/assets/refs/heads/main/icon.png")
local Window = KeyLibrary:CreateWindow({
    Title = "mspaint v4",
    
    Center = true,
    AutoShow = true,
    Resizable = false,
    
    ShowCustomCursor = false,
    
    NotifySide = "Right",
    
    TabPadding = 2,
    MenuFadeTime = 0,

    Icon = KeyLibrary.ImageManager.GetAsset("mspaint_ud"),
    Footer = LanguageHelper:GetTranslation("Key System"),

    GlobalSearch = false,
    Size = UDim2.fromOffset(625, 300)
})

--// Saved key deleted warning \\--
if typeof(saved_key_invalid) == "string" then
    KeyLibrary:Notify({
        Title = NotifyTitle,
        Description = saved_key_invalid,
        Time = 15
    })

	saved_key_invalid = nil
end

--// UI Functions \\--
local setclipboard = setclipboard or function(msg)
    if typeof(msg) ~= "string" then return end

    KeyLibrary:Notify({
        Title = NotifyTitle,
        Description = LanguageHelper:GetTranslationFormatted("Failed to set clipboard:\n%s", tostring(msg)),
        Time = 10
    })

    return false
end

local CreateButton = function(GroupBox, Text, Color, Url, Func)
    return GroupBox:AddButton({
        Text = string.format("<font color='%s'>%s</font>", Color, Text),
        Func = function()
            local data = setclipboard(Url)
            if data ~= false then
                KeyLibrary:Notify({
                    Title = NotifyTitle,
                    Description = LanguageHelper:GetTranslationFormatted("Copied <font color='%s' weight='900'>%s</font> link to clipboard.", Color, Text),
                })
            end

            if typeof(Func) == "function" then
                Func()
            end
        end
    })
end

--// Key Tab \\--
local KeyTab = Window:AddKeyTab(LanguageHelper:GetTranslation("Key")); do
    KeyTab:AddLabel({
        Text = LanguageHelper:GetTranslation("mspaint key"),
        DoesWrap = true,
        Size = 30,
    })

    KeyTab:AddLabel({
        Text = LanguageHelper:GetTranslation("Thank you for supporting mspaint!\nYour support helps us make awesome features!"),
        DoesWrap = true,
        Size = 16,
    })

    KeyTab:AddKeyBox(function(receivedKey)
        local TrimmedKey = TrimKey(receivedKey)
        if not TrimmedKey then
            KeyLibrary:Notify({
                Title = NotifyTitle,
                Description = LanguageHelper:GetTranslation("You have provided an invalid key!")
            })

            return
        end

        local Status = LuarmorAPI.check_key(TrimmedKey)
        if GetStatusCode(Status) ~= KEY_VALID then
            KeyLibrary:Notify({
                Title = NotifyTitle,
                Description = GetStatusErrorMessage(Status)
            })

            return
        end

        SetKeyToShared(TrimmedKey)

        pcall(function()
            if not isfolder(KeyFolder) then
                makefolder(KeyFolder)
            end

            writefile(KeyFile, TrimmedKey)
        end)

        KeyLibrary:Unload()
        task.wait()
        task.spawn(LoadScript)
    end)

    KeyTab:AddLabel({
        Text = LanguageHelper:GetTranslation("Lost? Go to the <font color='rgb(255, 215, 0)'><b>Premium</b></font> or <font color='rgb(173, 216, 230)'><b>Freemium</b></font> tab."),
        DoesWrap = true,
        Size = 14,
    })
end;

--// Premium Tab \\--
local PremiumTab = Window:AddTab(LanguageHelper:GetTranslation("Premium"), "crown"); do
    PremiumTab:UpdateWarningBox({
        Title = LanguageHelper:GetTranslation("Purchase"),
        Text = LanguageHelper:GetTranslation("If you want to <b>skip ads</b> and <b>unlock all features</b> instantly, you can buy <font color='rgb(255, 215, 0)'><b>premium</b></font> through the <b>official shop</b> or any <b>trusted reseller</b>."),
        IsNormal = true,
        Visible = true,
        LockSize = true
    })

    local OfficialGroupBox = PremiumTab:AddLeftGroupbox(LanguageHelper:GetTranslation("Official Shop")); do
        CreateButton(OfficialGroupBox, LanguageHelper:GetTranslation("Monthly"), "rgb(96, 165, 250)", "https://shop.mspaint.cc/product/mspaint-30-days-key")
        CreateButton(OfficialGroupBox, LanguageHelper:GetTranslation("Lifetime"), "rgb(255, 215, 0)", "https://shop.mspaint.cc/product/mspaint-lifetime-key")
    end

    local ResellersGroupBox = PremiumTab:AddRightGroupbox(LanguageHelper:GetTranslation("Resellers and Guide")); do
        CreateButton(ResellersGroupBox, LanguageHelper:GetTranslation("Trusted Resellers"), "rgb(52, 211, 153)", "https://docs.mspaint.cc/purchase/getting_started")
        CreateButton(ResellersGroupBox, LanguageHelper:GetTranslation("Guide"), "rgb(255, 255, 255)", "https://docs.mspaint.cc/purchase/getting_started")
    end
end;

--// Freemium Tab \\--
local FreemiumTab = Window:AddTab(LanguageHelper:GetTranslation("Freemium"), "key"); do
    FreemiumTab:UpdateWarningBox({
        Title = LanguageHelper:GetTranslation("Information"),
        Text = LanguageHelper:GetTranslation("Before starting, any type of <b>VPN/ad-blocker/bypasser</b> must be <b>disabled</b> to continue. You will <b>receive a temporary blacklist</b> from Luarmor for <b>any bypass attempt</b>!"),
        IsNormal = true,
        Visible = true,
        LockSize = true
    })

    local KeyGroupBox = FreemiumTab:AddLeftGroupbox(LanguageHelper:GetTranslation("Key")); do
        CreateButton(KeyGroupBox, "Linkvertise", "rgb(255,129,19)", "https://www.mspaint.cc/key")
        -- CreateButton(KeyGroupBox, "work.ink", "rgb(1,153,115)", "https://www.mspaint.cc/key")
        CreateButton(KeyGroupBox, LanguageHelper:GetTranslation("Key Tutorial"), "rgb(255,255,255)", "https://docs.mspaint.cc/key-system")
    end

    local HelpGroupBox = FreemiumTab:AddRightGroupbox(LanguageHelper:GetTranslation("Help")); do
        CreateButton(HelpGroupBox, LanguageHelper:GetTranslation("Join Discord"), "rgb(114,137,218)", "https://discord.gg/mspaint", function(...)
            local success, _err = pcall(function(...)
                local DiscordInviter = (loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/Discord-Inviter/refs/heads/main/init.luau")) :: any)()
                DiscordInviter:Join("discord.gg/mspaint")
            end)

            if not success then
                KeyLibrary:Notify({
                    Title = NotifyTitle,
                    Description = LanguageHelper:GetTranslationFormatted("Failed to join the <font color='%s' weight='900'>%s</font> server.", "rgb(114,137,218)", "Discord")
                })
            end
        end)
    end
end;

--// Settings Tab \\--
local SettingsTab = Window:AddTab(LanguageHelper:GetTranslation("Settings"), "settings"); do
    local MenuGroupBox = SettingsTab:AddLeftGroupbox(LanguageHelper:GetTranslation("Menu Options"), "settings"); do
        MenuGroupBox:AddLabel(LanguageHelper:GetTranslation("Menu keybind")):AddKeyPicker("MenuKeybind", { 
            Default = "RightShift", 
            NoUI = true, 
            Text = LanguageHelper:GetTranslation("Menu keybind")
        })

        MenuGroupBox:AddButton(LanguageHelper:GetTranslation("Unload"), function()  
            RemoveKeyFromEnv()
            KeyLibrary:Unload()
        end)
    end

    KeyLibrary.ToggleKeybind = Options.MenuKeybind
end

--// mspaint tos \\--
if not HasAcceptedTos then
    local Dialog = Window:AddDialog("TosDialog", {
        Title = LanguageHelper:GetTranslation("Terms of Service"),
        Description = LanguageHelper:GetTranslation("To continue, you need to agree to our <b>Terms of Service</b> and <b>Privacy Policy</b>.") .. "\n<font size=\"12\">mspaint.cc/tos • mspaint.cc/privacy</font>",

        AutoDismiss = false,
        OutsideClickDismiss = false,

        FooterButtons = {
            Unload = {
                Title = LanguageHelper:GetTranslation("Unload"),
                Variant = "Secondary",
                Order = 1,
                Callback = function()
                    RemoveKeyFromEnv()
                    KeyLibrary:Unload()
                end
            },
            CopyLink = {
                Title = LanguageHelper:GetTranslation("Copy Link"),
                Variant = "Secondary",
                Order = 2,
                Callback = function()
                    if setclipboard("https://www.mspaint.cc/tos") == false then return end

                    KeyLibrary:Notify({
                        Title = NotifyTitle,
                        Description = LanguageHelper:GetTranslation("Copied Terms of Service link to clipboard.")
                    })
                end
            },
            Continue = {
                Title = LanguageHelper:GetTranslation("Continue"),
                Variant = "Primary",
                Order = 3,
                Callback = function(Dialog)
                    pcall(function()
                        if not isfolder(KeyFolder) then
                            makefolder(KeyFolder)
                        end

                        writefile(TosFile, "true")
                    end)

                    Dialog:Dismiss()
                    if PendingTos then
						KeyLibrary:Unload()
						task.wait()
                        task.spawn(LoadScript)
                    end
                end
            }
        }
    })

    Dialog:SetButtonDisabled("Continue", true)

    local UpdateContinue = function()
        local AcceptedTos         = Toggles.TosAccept and Toggles.TosAccept.Value
        local AcceptedNoDevTools  = Toggles.TosNoDevTools and Toggles.TosNoDevTools.Value
        local AcceptedNoReverse   = Toggles.TosNoReverseEngineering and Toggles.TosNoReverseEngineering.Value
        Dialog:SetButtonDisabled("Continue", not (AcceptedTos and AcceptedNoDevTools and AcceptedNoReverse))
    end

    local AddSpace = function()
        local Spacer = Instance.new("Frame")
        Spacer.BackgroundTransparency = 1
        Spacer.BorderSizePixel = 0
        Spacer.Size = UDim2.fromScale(1, 1)

        Dialog:AddUIPassthrough("TosSpacer2", {
            Height = 5,
            Instance = Spacer
        })
    end

    Dialog:AddToggle("TosAccept", {
        Text = LanguageHelper:GetTranslation("I accept the ToS and Privacy Policy"),
        Default = false,
        Callback = UpdateContinue
    })

    AddSpace()

    Dialog:AddToggle("TosNoDevTools", {
        Text = LanguageHelper:GetTranslation("I accept to not run development tools<br/>when using mspaint"),
        Default = false,
        Callback = UpdateContinue
    })

    AddSpace()

    Dialog:AddToggle("TosNoReverseEngineering", {
        Text = LanguageHelper:GetTranslation("I accept that I will not attempt to<br/>reverse engineer mspaint"),
        Default = false,
        Callback = UpdateContinue
    })
end