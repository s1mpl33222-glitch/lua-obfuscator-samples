local http = game:GetService("HttpService")
-- yes yiu can change the fonturl just be sure it leads to a direct ttf/otf file 
if not isfile("starborn.ttf") then
    writefile("starborn.ttf", game:HttpGet("https://granny.anondrop.net/uploads/6c2505542959f371/Starborn.ttf"))
end
-- same with weight and style but know what you're doing
writefile("starborn.json", http:JSONEncode({
    name = "Starborn",
    faces = {{name="Regular", weight=400, style="normal", assetId=getcustomasset("starborn.ttf")}}
}))

local myfont = Font.new(getcustomasset("starborn.json"))

-- the roblox icon font we gotta leave alone (this is typically used for textlabels describing images so removing would turn images into texts)
local badfont = tostring(Font.new("rbxasset://LuaPackages/Packages/_Index/BuilderIcons/BuilderIcons/BuilderIcons.json"))

local function donttouch(this)
    if this.TextStrokeTransparency ~= 1 then return false end
    local cur = tostring(this.FontFace)
    return cur == badfont or string.find(cur, "BuilderIcons")
end

local function changeit(txt)
    if txt:IsA("TextLabel") or txt:IsA("TextButton") or txt:IsA("TextBox") then
        if not donttouch(txt) then
            txt.FontFace = myfont
        end
    end
end

-- do everything that exists right now
for _, v in pairs(game:GetDescendants()) do
    spawn(function() changeit(v) end)
end

-- new stuff
game.DescendantAdded:Connect(function(obj)
    spawn(function() changeit(obj) end)
end)

function ln()
    return "made by lady noire"
end