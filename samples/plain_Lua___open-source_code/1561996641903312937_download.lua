local Junkie = loadstring(game:HttpGet("https://jnkie.com/sdk/library.lua"))()
Junkie.service = "AdmScript"
Junkie.identifier = "1110415"
Junkie.provider = "KeySystem"

local result = (function()
    getgenv().UI_CLOSED = false
    local Players = game:GetService("Players")
    local TweenService = game:GetService("TweenService")
    local UserInputService = game:GetService("UserInputService")
    
    local Colors = {
        background = Color3.fromRGB(15, 15, 15),
        surface = Color3.fromRGB(25, 25, 25),
        primary = Color3.fromRGB(80, 80, 80),
        success = Color3.fromRGB(0, 150, 0),
        error = Color3.fromRGB(150, 0, 0),
        text = Color3.fromRGB(255, 255, 255)
    }

    local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
    ScreenGui.Name = "JunkieKeyUI"
    ScreenGui.ResetOnSpawn = false

    local MainFrame = Instance.new("Frame", ScreenGui)
    MainFrame.Size = UDim2.new(0, 300, 0, 150)
    MainFrame.Position = UDim2.new(0.5, -150, 0.5, -75)
    MainFrame.BackgroundColor3 = Colors.background
    MainFrame.BorderSizePixel = 0
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)

    local Title = Instance.new("TextLabel", MainFrame)
    Title.Size = UDim2.new(1, 0, 0, 30)
    Title.BackgroundTransparency = 1
    Title.Text = "@sakatoshi | telegram"
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 14
    Title.TextColor3 = Colors.text

    local KeyBox = Instance.new("TextBox", MainFrame)
    KeyBox.Size = UDim2.new(0, 260, 0, 35)
    KeyBox.Position = UDim2.new(0, 20, 0, 45)
    KeyBox.BackgroundColor3 = Colors.surface
    KeyBox.PlaceholderText = "Enter key..."
    KeyBox.Text = ""
    KeyBox.Font = Enum.Font.Code
    KeyBox.TextSize = 14
    KeyBox.TextColor3 = Colors.text
    KeyBox.BorderSizePixel = 0
    Instance.new("UICorner", KeyBox).CornerRadius = UDim.new(0, 4)

    local VerifyBtn = Instance.new("TextButton", MainFrame)
    VerifyBtn.Size = UDim2.new(0, 260, 0, 35)
    VerifyBtn.Position = UDim2.new(0, 20, 0, 95)
    VerifyBtn.BackgroundColor3 = Colors.primary
    VerifyBtn.Text = "VERIFY"
    VerifyBtn.Font = Enum.Font.GothamBold
    VerifyBtn.TextSize = 14
    VerifyBtn.TextColor3 = Colors.text
    VerifyBtn.BorderSizePixel = 0
    Instance.new("UICorner", VerifyBtn).CornerRadius = UDim.new(0, 4)

    VerifyBtn.MouseButton1Click:Connect(function()
        local key = KeyBox.Text
        VerifyBtn.Text = "CHECKING..."
        
        local result = Junkie.check_key(key)
        
        if result and result.valid then
            VerifyBtn.Text = "GRANTED"
            VerifyBtn.BackgroundColor3 = Colors.success
            task.wait(0.5)
            getgenv().SCRIPT_KEY = key
            getgenv().UI_CLOSED = true
            ScreenGui:Destroy()
        else
            VerifyBtn.Text = "INVALID"
            VerifyBtn.BackgroundColor3 = Colors.error
            task.wait(1)
            VerifyBtn.Text = "VERIFY"
            VerifyBtn.BackgroundColor3 = Colors.primary
        end
    end)

    while not getgenv().UI_CLOSED do
        task.wait(0.1)
    end
    return getgenv().SCRIPT_KEY
end)()

do ("JNKIE Loader - Unauthorized tampering or debugging of protected scripts is strictly prohibited and may result in a global blacklist from JNKIE protected scripts."):sub(1,1);local k=getgenv().SCRIPT_KEY or SCRIPT_KEY;local m="Could not load the script. Check your internet connection and try again later.";local function v(h)warn(h);task.spawn(function()pcall(function()game:GetService("Players").LocalPlayer:Kick(h)end);task.wait();pcall(function()local p=game:GetService("CoreGui").RobloxPromptGui.promptOverlay.ErrorPrompt;p.TitleFrame.ErrorTitle.Text="JNKIE";p.MessageArea.ErrorFrame.ErrorMessage.Text=h end)end)end;local r=(type(syn)=="table" and type(syn.request)=="function" and syn.request)or(type(request)=="function" and request)or(type(http_request)=="function" and http_request)or(type(http)=="table" and type(http.request)=="function" and http.request);if type(k)~="string" then v("No key provided. Get a key from the script provider, enter it, then try again.");return end;if type(r)~="function" then warn(m);return end;local function q(o)local d,a,x;task.spawn(function()a,x=pcall(r,o);d=true end);local s=os.clock();repeat task.wait()until d or os.clock()-s>15;if not d then return false,nil end;return a,x end;local a,x=q({Url="https://api.jnkie.com/api/v1/luascripts/delivery/7236d59863566683efab08e4aa1395ad3e67ce2c8c29662e447ac67c5cfe9734?v=2&errors=text",Method="POST",Headers={["Content-Type"]="text/plain"},Body=k});local h=a and type(x)=="table" and type(x.Body)=="string" and(x.StatusCode==400 or x.StatusCode==401 or x.StatusCode==403)and x.Body;if h then local c,n=h:match("^([^\r\n]+)\n([^\r\n]+)$");c=c or h;if#c<=75 and(c=="LDR-DENIED"or c:match("^LDR%-DENIED:[A-Z_]+$"))then if not n or#n>512 then n=m;if k==""or k:match("^%s*$")then n="No key provided. Get a key from the script provider, enter it, then try again." end end;v(n.." ("..c..")");return end end;if a and type(x)=="table" and x.StatusCode==200 and type(x.Body)=="string" and string.sub(x.Body,1,22)=="https://cdn.jnkie.com/" then a,x=q({Url=x.Body,Method="GET"})end;if a and type(x)=="table" and(x.StatusCode==302 or x.StatusCode==303)then local h=x.Headers or x.headers;local l=type(h)=="table" and(h.Location or h.location);if type(l)=="string" and string.sub(l,1,22)=="https://cdn.jnkie.com/" then a,x=q({Url=l,Method="GET"})end end;if not a or type(x)~="table" or x.StatusCode~=200 or type(x.Body)~="string" or#x.Body==0 then warn(m);return end;local b=x.Body;x=nil;local f=loadstring(b);b=nil;if type(f)~="function" then warn(m);return end;f()end