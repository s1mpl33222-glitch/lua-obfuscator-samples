if not game:IsLoaded() then
    game.Loaded:Wait()
end
task.wait(math.random())
local function trim(v)
    return tostring(v or ""):match("^%s*(.-)%s*$") or ""
end
local function envOf(fn, ...)
    if type(fn) ~= "function" then
        return nil
    end
    local ok, env = pcall(fn, ...)
    return ok and type(env) == "table" and env or nil
end
local genv = envOf(getgenv)
local cenv = envOf(getfenv, 1)
local function pick(...)
    for _, key in ipairs({...}) do
        if cenv and cenv[key] ~= nil then
            return cenv[key]
        end
        if rawget(_G, key) ~= nil then
            return rawget(_G, key)
        end
        if genv and genv[key] ~= nil then
            return genv[key]
        end
    end
end
local function setKey(key)
    key = trim(key)
    if key == "" then
        return
    end
    script_key, SCRIPT_KEY = key, key
    _G.script_key, _G.SCRIPT_KEY = key, key
    if genv then
        genv.script_key, genv.SCRIPT_KEY = key, key
    end
end
local routes = {
    [9910245722] = { "Iron Soul", "https://api.luarmor.net/files/v4/loaders/0de1739d889135c1773d384915f4fd2c.lua" },
    [7856269159] = { "Anime Overload", "https://api.luarmor.net/files/v4/loaders/e6153c73e2d96eb2d2d95cc9eb9bd94b.lua" },
    [97365843755210] = { "Cut Grass For Brainrots", "https://api.luarmor.net/files/v4/loaders/52f46b7e492243b23953d2c7611e1c44.lua" },
    [124473577469410] = { "Be a Lucky Block", "https://api.luarmor.net/files/v4/loaders/eb83fa1cc2d982f694566e45ad865313.lua" },
    [82397737462020] = { "Shrink for Brainrot", "https://api.luarmor.net/files/v4/loaders/3a4dea3e62ef5f49d0301fcadcb796e5.lua" },
    [7798947148] = { "Anime Final Quest", "https://api.luarmor.net/files/v4/loaders/992facee57df35654157a7d040aa16fd.lua" },
    [77393318863643] = { "Aura Ascension Ahh game", "https://api.jnkie.com/api/v1/luascripts/public/6a5f9cea79d13310ce5e282d6b13a4ea81c63b565a488719070775678cffc6a2/download" },
    [105626692504093] = { "Be a Brainrot", "https://api.luarmor.net/files/v4/loaders/2467a31cffe47ea62651b0f9197a8100.lua" },
    [8966502575] = { "Anime Reversal", "https://api.luarmor.net/files/v4/loaders/58879df88706f269e7562629f08404c3.lua" },
    [112259901434347] = { "+1 Speed be a Lucky Block!", "https://api.luarmor.net/files/v4/loaders/d0f4c13d54d518c47c4e06d2fe8ba534.lua"},
    [9802644580] = { "Summon Heroes", "https://api.luarmor.net/files/v4/loaders/4736e7dbf7040c8cbf738f5a7c465f88.lua"},
    [8937254139] = { "Dungeon Hunters", "https://api.luarmor.net/files/v4/loaders/96a47eae49cdce186b82f27466a233db.lua"},
    [9833422940] = { "Unbox a Factory", "https://api.luarmor.net/files/v4/loaders/a974d391286695dcf54c134194860bee.lua"},
    [9073513091] = { "Anime Apocalypse", "https://api.luarmor.net/files/v4/loaders/63f05e6d8ec9ff5cdb72620492a06b7b.lua"}, 
    [7395930870] = { "Sell Lemons", "https://api.luarmor.net/files/v4/loaders/3c2ec80af6a8711959a6ed553c5ccc18.lua"},
    [10032271327] = { "Anime World Fighters", "https://api.luarmor.net/files/v4/loaders/87e72a93771433a6438c356156ad2ed0.lua"},
    [138064211947107] = { "Unbox a Car", "https://api.luarmor.net/files/v4/loaders/a974d391286695dcf54c134194860bee.lua" },
    [9610561918] = { "Knife Farm", "https://api.luarmor.net/files/v4/loaders/ad5cca7cb4a373b3f12a55e1a974247e.lua" },
    [10004244222] = { "Kick a Lucky Block", "https://api.luarmor.net/files/v4/loaders/3ef6c0d255ef20d5c9ea2416d784c1ab.lua" },
    [9792947201] = { "Slime RNG", "https://api.luarmor.net/files/v4/loaders/0910ebdb1ba97ae86eee29570e60cf26.lua"},
    [10016841656] = { "Noob Tower Defense", "https://api.luarmor.net/files/v4/loaders/b83acbbb777878cbf813d68fb39ca95e.lua"},
    [6409513651] = { "Anime Warrior III", "https://api.luarmor.net/files/v4/loaders/7c5ad6d6d9907dc52339b6992c69929f.lua"},
    [10039338037] = { "Build A Ring Farm", "https://api.luarmor.net/files/v4/loaders/0c4926532de4a165261afd5cdef461e8.lua"},
    [9348272796] = { "SZA", "https://api.luarmor.net/files/v4/loaders/d3544bfeec41edddd5cc82b4719bebae.lua"},
    [7585079192] = { "Anime Story 2", "https://api.luarmor.net/files/v4/loaders/156058325b61d2eacbcafe87692a3044.lua"},
    [10093833731] = { "Broken Blade", "https://api.luarmor.net/files/v4/loaders/5c76434a4aa3e7d8622e184fa1d6e41d.lua"},
    [10148434559] = { "Lucky Block Rush", "https://api.luarmor.net/files/v4/loaders/e699fbd6839cb21f99b02581984e0a26.lua"},
    [10168229420] = { "My Gaming Cafe", "https://api.luarmor.net/files/v4/loaders/3cfc9a4071ec2b161c47af08d8aebe7f.lua"},
    [102072869879193] = { "Anime Astral", "https://api.luarmor.net/files/v4/loaders/7b467e6a99e8940a14f8638da5114d52.lua"},
    [8356066619] = { "Anime Squadron", "https://api.luarmor.net/files/v4/loaders/96c0cb77113aab1b03c99efd25e8b0a9.lua"},
    [10200395747] = { "Grow a Garden 2", "https://api.luarmor.net/files/v4/loaders/06c27f35842892f540c47c5b829cde13.lua"},
    [9826885587] = { "Evomon", "https://api.luarmor.net/files/v4/loaders/1840c1cc0b9aa949a220c8527299cc3b.lua"},
    [10204207151] = { "Catch a Brainrot", "https://api.luarmor.net/files/v4/loaders/c9199c243c613cae48ca8a4299d3cbf7.lua"},
    [7613921865] = { "Anime Expedition", "https://api.luarmor.net/files/v4/loaders/e83ca399ed2633554a17157256aa1585.lua"},
    [10131390815] = { "Throw a Coin", "https://api.luarmor.net/files/v4/loaders/a12724e45b05d6690e5f90dc8af3b04f.lua"},
    [8841437826] = { "Capybara vs Plants", "https://api.luarmor.net/files/v4/loaders/c53989dbfca7cf13ed1f68ab6d1004d3.lua"},
    [8959257868] = { "Unscathed", "https://api.luarmor.net/files/v4/loaders/a6e61ca4414fe2b647decfd15ba78b8e.lua"},
    [10563114921] = { "Steal an Egg", "https://api.luarmor.net/files/v4/loaders/7fb1c81c3290b809288aaf7dd506d623.lua"},
    [8946565814] = { "Anime Origins", "https://api.luarmor.net/files/v4/loaders/05896c9352e9012134fc50b5b9db861b.lua"},
    [10298144467] = { "Roll Anime to Fight", "https://api.luarmor.net/files/v4/loaders/f9e382fc1380a83c36a1e10011a6f255.lua"},
    [9656201728] = { "Dungeon Lootr", "https://api.luarmor.net/files/v4/loaders/6e344151f2440716fab4e4a087a7daa5.lua"},
    [10690360998] = { "JFA", "https://api.luarmor.net/files/v4/loaders/4d677b22c6acf84ad7354ece8cab8de2.lua"},
    [10708913337] = { "Anime Dice", "https://api.luarmor.net/files/v4/loaders/beeeb19d139976ac429a3ebaf38d88e8.lua"},
    [116497287371701] = { "Karinderya", "https://api.luarmor.net/files/v4/loaders/1edcc1aa4e7cd4d137c69228e9301a84.lua"},
    [10035204815] = { "Ride a Pet", "https://api.luarmor.net/files/v4/loaders/df9f4efd600221f1930a04f8ab326cde.lua"},
    [66654135] = { "MM2", "https://api.luarmor.net/files/v4/loaders/2d6756855863a3cff2c0e6dc1a320623.lua"},
    [5595353122] = { "SLAYERS2", "https://api.luarmor.net/files/v4/loaders/5ed558182d7b3bc1772eec45f3e83a05.lua"},
    [10684750879] = { "+1 Forge", "https://api.luarmor.net/files/v4/loaders/c49060195467cf727328a178ecd94584.lua"},
    [10759638075] = { "Pet Universe", "https://api.luarmor.net/files/v4/loaders/f16b079f183570896c0e4bb095f25e89.lua"},
    [10155360168] = { "Illegal Soccer", "https://api.luarmor.net/files/v4/loaders/fadb19f4ac7cb61b1527be73e1992bee.lua"},
    [10765288803] = { "Break and Steal", "https://api.luarmor.net/files/v4/loaders/9655f4e0174d8608140d22f1acb2931c.lua"},
    [10512942223] = { "Anime Zero", "https://api.luarmor.net/files/v4/loaders/6e4d96f0ec529cffb225b243bfa37321.lua"},
    [994732206] = { "Blox Fruits", "https://api.luarmor.net/files/v4/loaders/14f1758320ac081ba08c39c26e67ebda.lua"},
}
local route = routes[game.PlaceId] or routes[game.GameId]
if not route then
    return
end
setKey(pick("script_key", "SCRIPT_KEY"))
local scriptId = route[2]:match("/loaders/([%w]+)%.lua")
if scriptId then
    _G.LUARMOR_SCRIPT_ID, _G.BIGFROOT_LUARMOR_SCRIPT_ID = scriptId, scriptId
    if genv then
        genv.LUARMOR_SCRIPT_ID, genv.BIGFROOT_LUARMOR_SCRIPT_ID = scriptId, scriptId
    end
end
local state = (genv and genv.BigFrootLoaderState) or { loaded = {} }
if genv then
    genv.BigFrootLoaderState = state
end
if state.loaded[route[1]] then
    return
end
state.loaded[route[1]] = true
local ok, src = pcall(game.HttpGet, game, route[2])
if ok and src and pcall(loadstring(src)) then
    return
end
state.loaded[route[1]] = nil
