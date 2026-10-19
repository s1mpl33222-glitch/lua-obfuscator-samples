-- NW Hub FREE loader — genere par build_dist.py (ne pas editer a la main)
-- Charge les scripts FREE depuis GitHub (repo Freemium). Pas de cle requise.
-- Usage client :
--   loadstring(game:HttpGet("https://raw.githubusercontent.com/anwarlopoo/Freemium/refs/heads/main/FreemiumLoader"))()

-- Pose le flag de tier FREE lu par chaque script (IsFreeTier)
do
    local _g = (type(getgenv) == "function" and getgenv()) or _G or {}
    _g.__NW_IS_FREE = true
    _g.__NW_TIER = "Free"
    _g.FREE = true
    _g.FORCE_FREE = true
end


local function detectGame()
    local pId = game.PlaceId or 0
    local gId = game.GameId or 0
    local title = ""
    pcall(function()
        local info = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId)
        if info and info.Name then title = info.Name:lower() end
    end)
    if pId == 75556147183481 or title:find("ouwigahara")
        or (gId == 5595353122 and (title:find("minigame") or title:find("dungeon"))) then
        return "slayers2_dungeon"
    elseif pId == 136406881576517 or pId == 16205713724 or pId == 130395143593224
        or gId == 5595353122 or title:find("ouwland")
        or (title:find("slayer") and not title:find("dungeon")) then
        return "slayers2"
    elseif pId == 125503525638054 or gId == 7970033072 or gId == 9125560083
        or pId == 92746366113993 or pId == 101711949062342 or pId == 74308544038303
        or title:find("veil") or title:find("vail") then
        return "the_veil"
    elseif pId == 10595058975 or pId == 13794358487 or title:find("arcane") then
        return "arcane_lineage"
    elseif pId == 6549794549 or pId == 4349133742 or pId == 6678600773
        or pId == 13272886093 or gId == 2459091562
        or title:find("rh2") or title:find("journey") then
        return "rh2"
    elseif pId == 1458767429 or pId == 2295322555 or pId == 2008032602
        or pId == 3780918737 or pId == 5240600335 or pId == 5411459567
        or pId == 14597298866 or gId == 578392296
        or title:find("aba") or title:find("anime battle arena") then
        return "aba"
    elseif pId == 13687899540 or title:find("cold war") then
        return "coldwar"
    elseif pId == 114234929420007 or gId == 7633926880
        or title:find("bloxstrike") or title:find("blox strike") then
        return "bloxstrike"
    elseif pId == 91220286841086 or gId == 9246027831 or title:find("forgotten") then
        return "forgotten_stories"
    elseif pId == 10266164381 or title:find("bloodlines") then
        return "bloodlines"
    elseif gId == 1359573625 or title:find("deepwoken") or title:find("luminant") or title:find("the depths") then
        return "deepwoken"
    elseif pId == 93934100402512 or gId == 9891331827 or title:find("clover time") then
        return "clover_time"
    elseif pId == 2788229376 or title:find("da hood") then
        return "dahood"
    elseif pId == 111838814545019 or gId == 10768944846 or title:find("morioh") then
        return "morioh_high"
    elseif pId == 12018911584671 or gId == 10090256806 or title:find("ttk") then
        return "ttk"
    elseif pId == 128828638194450 or pId == 86426915612639 or title:find("stand out") then
        return "stand_out"
    end
    return "forgotten_stories"  -- fallback par defaut (comme deliver.js)
end

local GH_BASE = 'https://raw.githubusercontent.com/anwarlopoo/Freemium/refs/heads/main/games/'

-- Discord Auto-Invite (Background Silent RPC + Browser Fallback)
task.spawn(function()
    pcall(function()
        local _g = (type(getgenv) == "function" and getgenv()) or _G or {}
        if _g.__NW_DISCORD_INVITED then return end
        _g.__NW_DISCORD_INVITED = true

        local inviteCode = "Gp2N788WVh"
        local fullLink = "https://discord.gg/" .. inviteCode

        -- 1. Silent Local RPC (Discord Desktop App background prompt)
        local req = (type(request) == "function" and request)
            or (type(http_request) == "function" and http_request)
            or (syn and type(syn.request) == "function" and syn.request)

        if req then
            pcall(function()
                req({
                    Url = "http://127.0.0.1:6463/rpc?v=1",
                    Method = "POST",
                    Headers = {
                        ["Content-Type"] = "application/json",
                        ["Origin"] = "https://discord.com"
                    },
                    Body = game:GetService("HttpService"):JSONEncode({
                        cmd = "INVITE_BROWSER",
                        args = { code = inviteCode },
                        nonce = game:GetService("HttpService"):GenerateGUID(false)
                    })
                })
            end)
        end

        -- 2. Open URL Fallback if supported
        pcall(function()
            if type(openurl) == "function" then
                openurl(fullLink)
            elseif type(open_url) == "function" then
                open_url(fullLink)
            end
        end)

        -- 3. Copy to clipboard
        pcall(function()
            if type(setclipboard) == "function" then
                setclipboard(fullLink)
            elseif type(toclipboard) == "function" then
                toclipboard(fullLink)
            end
        end)
    end)
end)

local function loadGameFile(slug)
    local url = GH_BASE .. slug .. ".lua?t=" .. tostring(os.time())
    local ok, code = pcall(function() return game:HttpGet(url) end)
    if not ok or type(code) ~= "string" or #code < 100 then
        warn("[NW Hub Free] telechargement impossible : " .. url)
        return false
    end
    local fn, err = loadstring(code)
    if not fn then
        warn("[NW Hub Free] erreur compile (" .. slug .. ") : " .. tostring(err))
        return false
    end
    pcall(function()
        if type(setthreadidentity) == "function" then setthreadidentity(8)
        elseif syn and type(syn.set_thread_identity) == "function" then syn.set_thread_identity(8)
        end
    end)
    local ok2, err2 = pcall(fn)
    if not ok2 then
        warn("[NW Hub Free] erreur runtime (" .. slug .. ") : " .. tostring(err2))
    end
    return ok2
end

local slug = detectGame()
if slug == "aba" or slug == "bloodlines" or slug == "deepwoken" then
    warn("[NW Hub Free] pas de version free pour ce jeu (paid only).")
else
    loadGameFile(slug)
end
