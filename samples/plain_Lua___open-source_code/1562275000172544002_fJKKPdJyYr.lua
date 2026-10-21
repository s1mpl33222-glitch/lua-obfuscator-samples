local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local FileName = "ssssshirt.png"
local ImageURL = "https://files.catbox.moe/d04sn5.png"

if not isfile(FileName) then
    writefile(FileName, game:HttpGet(ImageURL))
end

local Asset = getcustomasset(FileName)

local function ApplyShirt(Character)
    local Shirt = Character:FindFirstChildOfClass("ShirtGraphic")

    if not Shirt then
        Shirt = Instance.new("ShirtGraphic")
        Shirt.Name = "Shirt Graphic"
        Shirt.Parent = Character
    end

    Shirt.Graphic = Asset

    Shirt:GetPropertyChangedSignal("Graphic"):Connect(function()
        if Shirt.Graphic ~= Asset then
            Shirt.Graphic = Asset
        end
    end)
end

LocalPlayer.CharacterAdded:Connect(ApplyShirt)

if LocalPlayer.Character then
    ApplyShirt(LocalPlayer.Character)
end