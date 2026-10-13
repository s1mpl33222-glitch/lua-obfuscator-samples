repeat task.wait() until game:IsLoaded()
getgenv().ScriptBloxReporter = "proj_761cfae4482a"

local KeySystem = {
    Services = {
        Players = game:GetService("Players"),
        CoreGui = game:GetService("CoreGui"),
        TweenService = game:GetService("TweenService"),
        UserInputService = game:GetService("UserInputService"),
    },
    Config = {
        Name = "ZeroPointKeySystem",
        Folder = "ZeroPoint",
        KeyFile = "ZeroPoint/FlowAuthKey.txt",
        Loader = "https://flowauth.net/v1/loaders/d898da8eb28122b7dfaf89b20f926d54.lua",
        LinkvertiseLink = "https://flowauth.net/reward/d898da8eb28122b7dfaf89b20f926d54",
        WorkInkLink = "https://flowauth.net/reward/d898da8eb28122b7dfaf89b20f926d54",
        LootLabsLink = "https://flowauth.net/reward/d898da8eb28122b7dfaf89b20f926d54",
        DiscordInvite = "https://discord.gg/Nk44e68bmn",
        Games = {
            [66654135] = {
                FFA = false,
            },
            [10539411000] = {
                FFA = false,
            },
            [10563114921] = { -- Steal An Egg
                FFA = false,
            },
            [7326934954] = {
                FFA = false,
            },
            [383310974] = {
                FFA = true,
            },
            [10035204815] = {
                FFA = true,
            },
            [994732206] = {
                FFA = true,
            },
        },
    },
    State = {
        Busy = false,
        SavedKey = nil,
        SavedKeyMessage = nil,
    },
    UI = {},
    Functions = {},
}

KeySystem.Services.Player = KeySystem.Services.Players.LocalPlayer

function KeySystem.Functions.GetGuiParent()
    if type(gethui) == "function" then
        local Success, Result = pcall(gethui)
        if Success and typeof(Result) == "Instance" then
            return Result
        end
    end
    return KeySystem.Services.CoreGui
end

function KeySystem.Functions.GetGameData()
    return KeySystem.Config.Games[game.GameId] or KeySystem.Config.Games[game.PlaceId]
end

function KeySystem.Functions.IsFreeScript()
    local GameData = KeySystem.Functions.GetGameData()
    if not GameData then
        return false
    end
    return GameData.FFA == true
end

function KeySystem.Functions.CleanKey(Key)
    if type(Key) ~= "string" then
        return ""
    end
    local Cleaned = Key:match("^%s*(.-)%s*$")
    return Cleaned
end

function KeySystem.Functions.Destroy()
    if KeySystem.UI.ScreenGui then
        KeySystem.UI.ScreenGui:Destroy()
        KeySystem.UI.ScreenGui = nil
    end
end

function KeySystem.Functions.SaveKey(Key)
    if type(writefile) ~= "function" then
        return false
    end
    if type(makefolder) == "function" then
        if type(isfolder) == "function" then
            local Success, Exists = pcall(isfolder, KeySystem.Config.Folder)
            if not Success or not Exists then
                pcall(makefolder, KeySystem.Config.Folder)
            end
        else
            pcall(makefolder, KeySystem.Config.Folder)
        end
    end
    local Success = pcall(writefile, KeySystem.Config.KeyFile, Key)
    return Success
end

function KeySystem.Functions.ReadKey()
    if type(readfile) ~= "function" then
        return nil
    end
    if type(isfile) == "function" then
        local Success, Exists = pcall(isfile, KeySystem.Config.KeyFile)
        if not Success or not Exists then
            return nil
        end
    end
    local Success, Result = pcall(readfile, KeySystem.Config.KeyFile)
    if not Success or type(Result) ~= "string" then
        return nil
    end
    local Key = KeySystem.Functions.CleanKey(Result)
    if Key == "" then
        return nil
    end
    return Key
end

function KeySystem.Functions.CopyLink(Link, Button)
    if type(setclipboard) ~= "function" then
        if KeySystem.UI.Status then
            KeySystem.UI.Status.Text = "Clipboard is not supported."
            KeySystem.UI.Status.TextColor3 = Color3.fromRGB(255, 50, 50)
        end
        return
    end
    if not Link or Link == "" then
        if KeySystem.UI.Status then
            KeySystem.UI.Status.Text = "Link is not configured."
            KeySystem.UI.Status.TextColor3 = Color3.fromRGB(255, 50, 50)
        end
        return
    end
    local OriginalText = Button.Text
    setclipboard(Link)
    Button.Text = "Link Copied"
    task.delay(1.5, function()
        if Button and Button.Parent then
            Button.Text = OriginalText
        end
    end)
end

function KeySystem.Functions.SetStatus(Message, IsError)
    if KeySystem.UI.ScreenGui and KeySystem.UI.Status then
        KeySystem.UI.Status.Text = Message
        KeySystem.UI.Status.TextColor3 = IsError and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(127, 127, 127)
    end
end

function KeySystem.Functions.GetErrorMessage(Error)
    local Message = tostring(Error)
    local Errors = {
        {"invalid_key", "Invalid key or wrong FlowAuth project."},
        {"key_revoked", "This key has been revoked."},
        {"key_paused", "This key is paused."},
        {"key_expired", "This key has expired. Get a new key."},
        {"hwid_mismatch", "This key belongs to another device. Request an HWID reset."},
        {"blacklisted", "Access is blocked. Contact support."},
        {"premium_required", "This script requires a FlowAuth project key."},
        {"key_required", "Enter a FlowAuth project key."},
        {"no_script_for_game", "No published FlowAuth script matches this game."},
        {"instance_limit_reached", "This key has reached its active execution limit."},
        {"incompatible_executor", "Update your executor; FlowAuth requires compatible functions."},
        {"payload_too_large", "The protected script is too large. Contact support."},
        {"nonce_reused", "The loader session expired. Try again."},
        {"challenge_rejected", "The loader session was rejected. Try again."},
    }
    for _, Entry in next, Errors do
        if Message:find(Entry[1], 1, true) then
            return Entry[2]
        end
    end
    return "FlowAuth could not finish loading. Check your executor console."
end

function KeySystem.Functions.LoadGameScript(Key)
    local GameData = KeySystem.Functions.GetGameData()
    if not GameData then
        return false, "This game is not supported."
    end
    Key = KeySystem.Functions.CleanKey(Key)
    if Key == "" and not GameData.FFA then
        return false, "Enter a FlowAuth project key."
    end
    local Credential = Key ~= "" and Key or nil
    local Environment = type(getgenv) == "function" and getgenv() or _G
    local Success, Error = pcall(function()
        local Source = game:HttpGet(GameData.Loader or KeySystem.Config.Loader)
        if type(Source) ~= "string" or Source == "" then
            error("Empty FlowAuth loader response.", 0)
        end
        local Loader, CompileError = loadstring(Source)
        if type(Loader) ~= "function" then
            error(CompileError or "Invalid FlowAuth loader response.", 0)
        end
        script_key = Credential
        Environment.script_key = Credential
        _G.script_key = Credential
        Loader(Credential)
    end)
    if script_key == Credential then
        script_key = nil
    end
    if Environment.script_key == Credential then
        Environment.script_key = nil
    end
    if _G.script_key == Credential then
        _G.script_key = nil
    end
    if not Success then
        local Details = tostring(Error)
        if Credential then
            local Pattern = Credential:gsub("(%W)", "%%%1")
            Details = Details:gsub(Pattern, "[redacted]")
        end
        warn("[Zero Point] FlowAuth loader error: " .. Details)
        return false, KeySystem.Functions.GetErrorMessage(Error)
    end
    return true
end

function KeySystem.Functions.Launch(Key)
    if KeySystem.State.Busy then
        return
    end
    Key = KeySystem.Functions.CleanKey(Key)
    if Key == "" and not KeySystem.Functions.IsFreeScript() then
        KeySystem.Functions.SetStatus("Please enter a FlowAuth key.", true)
        return
    end
    KeySystem.State.Busy = true
    local ScreenGui = KeySystem.UI.ScreenGui
    if ScreenGui then
        ScreenGui.Enabled = false
    end
    local Returned, Message = KeySystem.Functions.LoadGameScript(Key)
    KeySystem.State.Busy = false
    if not Returned then
        if ScreenGui and ScreenGui.Parent then
            ScreenGui.Enabled = true
        end
        KeySystem.Functions.SetStatus(Message, true)
        return
    end
    if Key ~= "" then
        KeySystem.Functions.SaveKey(Key)
    end
    KeySystem.Functions.Destroy()
end

function KeySystem.Functions.SubmitKey()
    if KeySystem.State.Busy or not KeySystem.UI.ScreenGui then
        return
    end
    local Key = KeySystem.Functions.CleanKey(KeySystem.UI.KeyBox.Text)
    KeySystem.UI.KeyBox.Text = Key
    KeySystem.Functions.Launch(Key)
end

function KeySystem.Functions.MakeDraggable(Object, Handle)
    local UserInputService = KeySystem.Services.UserInputService
    local Dragging = false
    local DragInput
    local DragStart
    local StartPosition

    local function Update(Input)
        local Delta = Input.Position - DragStart
        Object.Position = UDim2.new(
            StartPosition.X.Scale,
            StartPosition.X.Offset + Delta.X,
            StartPosition.Y.Scale,
            StartPosition.Y.Offset + Delta.Y
        )
    end

    Handle.Active = true

    Handle.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            DragStart = Input.Position
            StartPosition = Object.Position

            Input.Changed:Connect(function()
                if Input.UserInputState == Enum.UserInputState.End then
                    Dragging = false
                end
            end)
        end
    end)

    Handle.InputChanged:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
            DragInput = Input
        end
    end)

    UserInputService.InputChanged:Connect(function(Input)
        if Dragging and Input == DragInput then
            Update(Input)
        end
    end)
end

function KeySystem.Functions.CreateGui()
    local GuiParent = KeySystem.Functions.GetGuiParent()
    local OldGui = GuiParent:FindFirstChild(KeySystem.Config.Name)

    if OldGui then
        OldGui:Destroy()
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = KeySystem.Config.Name
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = GuiParent
    KeySystem.UI.ScreenGui = ScreenGui

    local Background = Instance.new("Frame")
    Background.Name = "Background"
    Background.AnchorPoint = Vector2.new(0.5, 0.5)
    Background.Position = UDim2.fromScale(0.5, 0.5)
    Background.Size = UDim2.fromOffset(520, 340)
    Background.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    Background.BorderSizePixel = 0
    Background.Parent = ScreenGui
    KeySystem.UI.Background = Background

    local DragArea = Instance.new("Frame")
    DragArea.Name = "DragArea"
    DragArea.BackgroundTransparency = 1
    DragArea.BorderSizePixel = 0
    DragArea.Position = UDim2.fromOffset(0, 0)
    DragArea.Size = UDim2.new(1, -48, 0, 49)
    DragArea.ZIndex = 2
    DragArea.Active = true
    DragArea.Parent = Background
    KeySystem.UI.DragArea = DragArea

    KeySystem.Functions.MakeDraggable(Background, DragArea)

    local BackgroundCorner = Instance.new("UICorner")
    BackgroundCorner.CornerRadius = UDim.new(0, 4)
    BackgroundCorner.Parent = Background

    local BackgroundStroke = Instance.new("UIStroke")
    BackgroundStroke.Color = Color3.fromRGB(40, 40, 40)
    BackgroundStroke.Thickness = 1
    BackgroundStroke.Parent = Background

    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.fromOffset(0, 0)
    Title.Size = UDim2.fromOffset(155, 48)
    Title.Font = Enum.Font.GothamBlack
    Title.Text = "Zero Point"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 20
    Title.TextXAlignment = Enum.TextXAlignment.Center
    Title.Parent = Background

    local SectionTitle = Instance.new("TextLabel")
    SectionTitle.Name = "SectionTitle"
    SectionTitle.BackgroundTransparency = 1
    SectionTitle.Position = UDim2.fromOffset(171, 0)
    SectionTitle.Size = UDim2.new(1, -226, 0, 48)
    SectionTitle.Font = Enum.Font.GothamBlack
    SectionTitle.Text = "Authentication"
    SectionTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    SectionTitle.TextSize = 16
    SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
    SectionTitle.Parent = Background

    local TopDivider = Instance.new("Frame")
    TopDivider.Name = "TopDivider"
    TopDivider.Position = UDim2.fromOffset(0, 48)
    TopDivider.Size = UDim2.new(1, 0, 0, 1)
    TopDivider.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    TopDivider.BorderSizePixel = 0
    TopDivider.Parent = Background

    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Position = UDim2.fromOffset(0, 49)
    Sidebar.Size = UDim2.fromOffset(155, 269)
    Sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = Background

    local SidebarDivider = Instance.new("Frame")
    SidebarDivider.Name = "SidebarDivider"
    SidebarDivider.Position = UDim2.fromOffset(155, 0)
    SidebarDivider.Size = UDim2.new(0, 1, 1, -21)
    SidebarDivider.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    SidebarDivider.BorderSizePixel = 0
    SidebarDivider.Parent = Background

    local SidebarLabel = Instance.new("TextLabel")
    SidebarLabel.Name = "SidebarLabel"
    SidebarLabel.BackgroundTransparency = 1
    SidebarLabel.Position = UDim2.fromOffset(12, 12)
    SidebarLabel.Size = UDim2.new(1, -24, 0, 18)
    SidebarLabel.Font = Enum.Font.GothamBlack
    SidebarLabel.Text = "MENU"
    SidebarLabel.TextColor3 = Color3.fromRGB(127, 127, 127)
    SidebarLabel.TextSize = 11
    SidebarLabel.TextXAlignment = Enum.TextXAlignment.Left
    SidebarLabel.Parent = Sidebar

    local ActivePage = Instance.new("Frame")
    ActivePage.Name = "ActivePage"
    ActivePage.Position = UDim2.fromOffset(8, 40)
    ActivePage.Size = UDim2.new(1, -16, 0, 36)
    ActivePage.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    ActivePage.BorderSizePixel = 0
    ActivePage.Parent = Sidebar

    local ActivePageCorner = Instance.new("UICorner")
    ActivePageCorner.CornerRadius = UDim.new(0, 4)
    ActivePageCorner.Parent = ActivePage

    local ActiveAccent = Instance.new("Frame")
    ActiveAccent.Name = "Accent"
    ActiveAccent.Position = UDim2.fromOffset(0, 6)
    ActiveAccent.Size = UDim2.fromOffset(3, 24)
    ActiveAccent.BackgroundColor3 = Color3.fromRGB(255, 20, 147)
    ActiveAccent.BorderSizePixel = 0
    ActiveAccent.Parent = ActivePage

    local ActiveAccentCorner = Instance.new("UICorner")
    ActiveAccentCorner.CornerRadius = UDim.new(1, 0)
    ActiveAccentCorner.Parent = ActiveAccent

    local ActivePageText = Instance.new("TextLabel")
    ActivePageText.Name = "Text"
    ActivePageText.BackgroundTransparency = 1
    ActivePageText.Position = UDim2.fromOffset(14, 0)
    ActivePageText.Size = UDim2.new(1, -20, 1, 0)
    ActivePageText.Font = Enum.Font.GothamBlack
    ActivePageText.Text = "Key System"
    ActivePageText.TextColor3 = Color3.fromRGB(255, 255, 255)
    ActivePageText.TextSize = 13
    ActivePageText.TextXAlignment = Enum.TextXAlignment.Left
    ActivePageText.Parent = ActivePage

    local SidebarHint = Instance.new("TextLabel")
    SidebarHint.Name = "SidebarHint"
    SidebarHint.AnchorPoint = Vector2.new(0, 1)
    SidebarHint.Position = UDim2.new(0, 12, 1, -12)
    SidebarHint.Size = UDim2.new(1, -24, 0, 34)
    SidebarHint.BackgroundTransparency = 1
    SidebarHint.Font = Enum.Font.GothamBlack
    SidebarHint.Text = "Secure access\nfor Zero Point"
    SidebarHint.TextColor3 = Color3.fromRGB(127, 127, 127)
    SidebarHint.TextSize = 11
    SidebarHint.TextWrapped = true
    SidebarHint.TextXAlignment = Enum.TextXAlignment.Left
    SidebarHint.TextYAlignment = Enum.TextYAlignment.Bottom
    SidebarHint.Parent = Sidebar

    local Description = Instance.new("TextLabel")
    Description.Name = "Description"
    Description.BackgroundTransparency = 1
    Description.Position = UDim2.fromOffset(171, 66)
    Description.Size = UDim2.new(1, -187, 0, 24)
    Description.Font = Enum.Font.GothamBlack
    Description.Text = KeySystem.Functions.IsFreeScript() and "Keyless access. Click Load Script to retry." or "Enter your FlowAuth key to continue."
    Description.TextColor3 = Color3.fromRGB(255, 255, 255)
    Description.TextTransparency = 0.5
    Description.TextSize = 12
    Description.TextXAlignment = Enum.TextXAlignment.Left
    Description.Parent = Background

    local KeyBox = Instance.new("TextBox")
    KeyBox.Name = "KeyBox"
    KeyBox.Position = UDim2.fromOffset(171, 102)
    KeyBox.Size = UDim2.new(1, -187, 0, 40)
    KeyBox.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    KeyBox.BorderSizePixel = 0
    KeyBox.ClearTextOnFocus = false
    KeyBox.MultiLine = false
    KeyBox.Font = Enum.Font.GothamBlack
    KeyBox.PlaceholderText = "Enter key..."
    KeyBox.PlaceholderColor3 = Color3.fromRGB(127, 127, 127)
    KeyBox.Text = KeySystem.State.SavedKey or ""
    KeyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    KeyBox.TextSize = 14
    KeyBox.TextXAlignment = Enum.TextXAlignment.Left
    KeyBox.Parent = Background
    KeySystem.UI.KeyBox = KeyBox

    local KeyPadding = Instance.new("UIPadding")
    KeyPadding.PaddingLeft = UDim.new(0, 12)
    KeyPadding.PaddingRight = UDim.new(0, 12)
    KeyPadding.Parent = KeyBox

    local KeyCorner = Instance.new("UICorner")
    KeyCorner.CornerRadius = UDim.new(0, 4)
    KeyCorner.Parent = KeyBox

    local KeyStroke = Instance.new("UIStroke")
    KeyStroke.Color = Color3.fromRGB(40, 40, 40)
    KeyStroke.Thickness = 1
    KeyStroke.Parent = KeyBox

    local Submit = Instance.new("TextButton")
    Submit.Name = "Submit"
    Submit.Position = UDim2.fromOffset(171, 156)
    Submit.Size = UDim2.new(1, -187, 0, 36)
    Submit.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Submit.BorderSizePixel = 0
    Submit.AutoButtonColor = false
    Submit.Font = Enum.Font.GothamBlack
    Submit.Text = "Load Script"
    Submit.TextColor3 = Color3.fromRGB(15, 15, 15)
    Submit.TextSize = 14
    Submit.Parent = Background
    KeySystem.UI.Submit = Submit

    local SubmitCorner = Instance.new("UICorner")
    SubmitCorner.CornerRadius = UDim.new(0, 4)
    SubmitCorner.Parent = Submit

    local SubmitStroke = Instance.new("UIStroke")
    SubmitStroke.Color = Color3.fromRGB(255, 255, 255)
    SubmitStroke.Thickness = 1
    SubmitStroke.Parent = Submit

    local GetKey = Instance.new("TextButton")
    GetKey.Name = "GetKey"
    GetKey.Position = UDim2.fromOffset(171, 206)
    GetKey.Size = UDim2.fromOffset(77, 36)
    GetKey.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    GetKey.BorderSizePixel = 0
    GetKey.AutoButtonColor = false
    GetKey.Font = Enum.Font.GothamBlack
    GetKey.Text = "Linkvertise"
    GetKey.TextColor3 = Color3.fromRGB(255, 255, 255)
    GetKey.TextSize = 12
    GetKey.Parent = Background
    KeySystem.UI.GetKey = GetKey

    local GetKeyCorner = Instance.new("UICorner")
    GetKeyCorner.CornerRadius = UDim.new(0, 4)
    GetKeyCorner.Parent = GetKey

    local GetKeyStroke = Instance.new("UIStroke")
    GetKeyStroke.Color = Color3.fromRGB(40, 40, 40)
    GetKeyStroke.Thickness = 1
    GetKeyStroke.Parent = GetKey

    local WorkInk = Instance.new("TextButton")
    WorkInk.Name = "WorkInk"
    WorkInk.Position = UDim2.fromOffset(256, 206)
    WorkInk.Size = UDim2.fromOffset(77, 36)
    WorkInk.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    WorkInk.BorderSizePixel = 0
    WorkInk.AutoButtonColor = false
    WorkInk.Font = Enum.Font.GothamBlack
    WorkInk.Text = "Work.ink"
    WorkInk.TextColor3 = Color3.fromRGB(255, 255, 255)
    WorkInk.TextSize = 12
    WorkInk.Parent = Background
    KeySystem.UI.WorkInk = WorkInk

    local WorkInkCorner = Instance.new("UICorner")
    WorkInkCorner.CornerRadius = UDim.new(0, 4)
    WorkInkCorner.Parent = WorkInk

    local WorkInkStroke = Instance.new("UIStroke")
    WorkInkStroke.Color = Color3.fromRGB(40, 40, 40)
    WorkInkStroke.Thickness = 1
    WorkInkStroke.Parent = WorkInk

    local LootLabs = Instance.new("TextButton")
    LootLabs.Name = "LootLabs"
    LootLabs.Position = UDim2.fromOffset(341, 206)
    LootLabs.Size = UDim2.fromOffset(77, 36)
    LootLabs.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    LootLabs.BorderSizePixel = 0
    LootLabs.AutoButtonColor = false
    LootLabs.Font = Enum.Font.GothamBlack
    LootLabs.Text = "LootLabs"
    LootLabs.TextColor3 = Color3.fromRGB(255, 255, 255)
    LootLabs.TextSize = 12
    LootLabs.Parent = Background
    KeySystem.UI.LootLabs = LootLabs

    local LootLabsCorner = Instance.new("UICorner")
    LootLabsCorner.CornerRadius = UDim.new(0, 4)
    LootLabsCorner.Parent = LootLabs

    local LootLabsStroke = Instance.new("UIStroke")
    LootLabsStroke.Color = Color3.fromRGB(40, 40, 40)
    LootLabsStroke.Thickness = 1
    LootLabsStroke.Parent = LootLabs

    local Discord = Instance.new("TextButton")
    Discord.Name = "Discord"
    Discord.Position = UDim2.fromOffset(426, 206)
    Discord.Size = UDim2.fromOffset(77, 36)
    Discord.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Discord.BorderSizePixel = 0
    Discord.AutoButtonColor = false
    Discord.Font = Enum.Font.GothamBlack
    Discord.Text = "Discord"
    Discord.TextColor3 = Color3.fromRGB(255, 255, 255)
    Discord.TextSize = 12
    Discord.Parent = Background
    KeySystem.UI.Discord = Discord

    local DiscordCorner = Instance.new("UICorner")
    DiscordCorner.CornerRadius = UDim.new(0, 4)
    DiscordCorner.Parent = Discord

    local DiscordStroke = Instance.new("UIStroke")
    DiscordStroke.Color = Color3.fromRGB(40, 40, 40)
    DiscordStroke.Thickness = 1
    DiscordStroke.Parent = Discord

    local BottomDivider = Instance.new("Frame")
    BottomDivider.Name = "BottomDivider"
    BottomDivider.Position = UDim2.fromOffset(0, 318)
    BottomDivider.Size = UDim2.new(1, 0, 0, 1)
    BottomDivider.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    BottomDivider.BorderSizePixel = 0
    BottomDivider.Parent = Background

    local Status = Instance.new("TextLabel")
    Status.Name = "Status"
    Status.BackgroundTransparency = 1
    Status.Position = UDim2.fromOffset(171, 258)
    Status.Size = UDim2.new(1, -187, 0, 36)
    Status.TextWrapped = true
    Status.TextYAlignment = Enum.TextYAlignment.Top
    Status.Font = Enum.Font.GothamBlack
    Status.Text = KeySystem.State.SavedKeyMessage or ""
    Status.TextColor3 = KeySystem.State.SavedKeyMessage and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(127, 127, 127)
    Status.TextSize = 12
    Status.TextXAlignment = Enum.TextXAlignment.Left
    Status.Parent = Background
    KeySystem.UI.Status = Status

    local Close = Instance.new("TextButton")
    Close.Name = "Close"
    Close.AnchorPoint = Vector2.new(1, 0)
    Close.Position = UDim2.new(1, -9, 0, 9)
    Close.Size = UDim2.fromOffset(30, 30)
    Close.BackgroundTransparency = 1
    Close.Font = Enum.Font.GothamBlack
    Close.Text = "X"
    Close.TextColor3 = Color3.fromRGB(255, 255, 255)
    Close.TextTransparency = 0.5
    Close.TextSize = 20
    Close.Parent = Background
    KeySystem.UI.Close = Close

    Submit.MouseButton1Click:Connect(KeySystem.Functions.SubmitKey)

    GetKey.MouseButton1Click:Connect(function()
        KeySystem.Functions.CopyLink(KeySystem.Config.LinkvertiseLink, GetKey)
    end)

    WorkInk.MouseButton1Click:Connect(function()
        KeySystem.Functions.CopyLink(KeySystem.Config.WorkInkLink, WorkInk)
    end)

    LootLabs.MouseButton1Click:Connect(function()
        KeySystem.Functions.CopyLink(KeySystem.Config.LootLabsLink, LootLabs)
    end)

    Discord.MouseButton1Click:Connect(function()
        KeySystem.Functions.CopyLink(KeySystem.Config.DiscordInvite, Discord)
    end)

    KeyBox.FocusLost:Connect(function(EnterPressed)
        if EnterPressed then
            KeySystem.Functions.SubmitKey()
        end
    end)

    Submit.MouseEnter:Connect(function()
        KeySystem.Services.TweenService:Create(Submit, TweenInfo.new(0.12), {
            BackgroundColor3 = Color3.fromRGB(255, 20, 147),
            TextColor3 = Color3.fromRGB(255, 255, 255),
        }):Play()
    end)

    Submit.MouseLeave:Connect(function()
        KeySystem.Services.TweenService:Create(Submit, TweenInfo.new(0.12), {
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            TextColor3 = Color3.fromRGB(15, 15, 15),
        }):Play()
    end)

    GetKey.MouseEnter:Connect(function()
        KeySystem.Services.TweenService:Create(GetKey, TweenInfo.new(0.12), {
            BackgroundColor3 = Color3.fromRGB(35, 35, 35),
        }):Play()
    end)

    GetKey.MouseLeave:Connect(function()
        KeySystem.Services.TweenService:Create(GetKey, TweenInfo.new(0.12), {
            BackgroundColor3 = Color3.fromRGB(25, 25, 25),
        }):Play()
    end)

    WorkInk.MouseEnter:Connect(function()
        KeySystem.Services.TweenService:Create(WorkInk, TweenInfo.new(0.12), {
            BackgroundColor3 = Color3.fromRGB(35, 35, 35),
        }):Play()
    end)

    WorkInk.MouseLeave:Connect(function()
        KeySystem.Services.TweenService:Create(WorkInk, TweenInfo.new(0.12), {
            BackgroundColor3 = Color3.fromRGB(25, 25, 25),
        }):Play()
    end)

    LootLabs.MouseEnter:Connect(function()
        KeySystem.Services.TweenService:Create(LootLabs, TweenInfo.new(0.12), {
            BackgroundColor3 = Color3.fromRGB(35, 35, 35),
        }):Play()
    end)

    LootLabs.MouseLeave:Connect(function()
        KeySystem.Services.TweenService:Create(LootLabs, TweenInfo.new(0.12), {
            BackgroundColor3 = Color3.fromRGB(25, 25, 25),
        }):Play()
    end)

    Discord.MouseEnter:Connect(function()
        KeySystem.Services.TweenService:Create(Discord, TweenInfo.new(0.12), {
            BackgroundColor3 = Color3.fromRGB(35, 35, 35),
        }):Play()
    end)

    Discord.MouseLeave:Connect(function()
        KeySystem.Services.TweenService:Create(Discord, TweenInfo.new(0.12), {
            BackgroundColor3 = Color3.fromRGB(25, 25, 25),
        }):Play()
    end)

    Close.MouseButton1Click:Connect(KeySystem.Functions.Destroy)

    Close.MouseEnter:Connect(function()
        KeySystem.Services.TweenService:Create(Close, TweenInfo.new(0.12), {
            TextColor3 = Color3.fromRGB(255, 50, 50),
            TextTransparency = 0,
        }):Play()
    end)

    Close.MouseLeave:Connect(function()
        KeySystem.Services.TweenService:Create(Close, TweenInfo.new(0.12), {
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextTransparency = 0.5,
        }):Play()
    end)
end

function KeySystem.Functions.Start()
    local GameData = KeySystem.Functions.GetGameData()

    if not GameData then
        warn("[Zero Point] This game is not supported.")
        return
    end

    local Environment = type(getgenv) == "function" and getgenv() or _G
    local ProvidedKey = KeySystem.Functions.CleanKey(script_key)

    if ProvidedKey == "" then
        ProvidedKey = KeySystem.Functions.CleanKey(Environment.script_key)
    end

    if ProvidedKey == "" then
        ProvidedKey = KeySystem.Functions.CleanKey(_G.script_key)
    end

    local SavedKey = not GameData.FFA and KeySystem.Functions.ReadKey() or nil
    KeySystem.State.SavedKey = ProvidedKey ~= "" and ProvidedKey or SavedKey

    if ProvidedKey ~= "" or SavedKey or GameData.FFA then
        local Returned, Message = KeySystem.Functions.LoadGameScript(KeySystem.State.SavedKey)

        if Returned then
            if KeySystem.State.SavedKey and KeySystem.State.SavedKey ~= "" then
                KeySystem.Functions.SaveKey(KeySystem.State.SavedKey)
            end
            return
        end

        KeySystem.State.SavedKeyMessage = Message
    end

    KeySystem.Functions.CreateGui()
end

KeySystem.Functions.Start()

pcall(function()
    loadstring(game:HttpGet("https://scriptblox.com/ingest/client.lua"))()
end)
