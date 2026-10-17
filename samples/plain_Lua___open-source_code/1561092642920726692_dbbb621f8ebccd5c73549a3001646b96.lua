-- NoskillhubV2 — CatHub loader (v1, engine 5).
-- This file loads your script; it does not contain it. The script is
-- encrypted, delivered per load, and only ever runs inside Roblox.
-- The engine that does the work is downloaded once and kept next to this
-- script in the executor workspace — loading from the URL again is always
-- safe and always picks up an update.

-- Per-script config for the engine:
--   [1] protocol  [2] engine version  [3] loader id  [4] origin
--   [5] label     [6] key system on/off
local DATA = {1, 5, "dbbb621f8ebccd5c73549a3001646b96", "https://cathub.fr",
  "NoskillhubV2", 0, "cathub_v1"}
local ORIGIN, ENGINE = DATA[4], DATA[2]

-- Where the engine is cached, how big a cached copy has to be to be
-- believed, and the operator escape hatch that forces a re-download
-- without an engine release: set _G.cathub_cache = "?v=2" (or anything)
-- before running the loader.
local FOLDER = "cathub_v1"
local FILE = "engine-" .. tostring(ENGINE) .. ".lua"
local MINBYTES = 4096
local SUFFIX = ""
if type(_G) == "table" and type(_G.cathub_cache) == "string" then SUFFIX = _G.cathub_cache end

local function say(message)
  pcall(function() print("[cathub] " .. tostring(DATA[5]) .. ": " .. tostring(message)) end)
end

local function stop(message)
  say("loader stopped: " .. tostring(message))
  return nil
end

-- 1. Roblox client gate (short form) ---------------------------------------
-- Enough to refuse a browser, a shell and a hooked runtime BEFORE anything
-- is fetched; the engine repeats the full version (services, LocalPlayer,
-- Studio) once it runs.
if not pcall(function()
  if type(game) ~= "userdata" and type(game) ~= "table" then error("no game") end
  if type(typeof) == "function" and typeof(game) ~= "Instance" then error("not an Instance") end
  if type(game.GetService) ~= "function" then error("no services") end
  if type(loadstring) ~= "function" then error("no loadstring") end
end) then
  return stop("this is not a Roblox client")
end

-- A loadstring wrapper reports the chunk it was written in; running through
-- it would show the engine AND the script in clear.
if type(debug) == "table" and type(debug.info) == "function" then
  local okSource, source = pcall(debug.info, loadstring, "s")
  if okSource and type(source) == "string" then
    local first = string.sub(source, 1, 1)
    if first == "@" or first == "=" then
      return stop("loadstring has been replaced — this loader refuses to run hooked")
    end
  end
end

-- 2. transport for the engine only ----------------------------------------
local function fetch(url)
  if type(game.HttpGet) == "function" then
    local ok, body = pcall(function() return game:HttpGet(url) end)
    if ok and type(body) == "string" and #body > 0 then return body end
  end
  if type(request) == "function" then
    local ok, res = pcall(request, { Url = url, Method = "GET" })
    if ok and type(res) == "table" and type(res.Body) == "string" then return res.Body end
  end
  if type(syn) == "table" and type(syn.request) == "function" then
    local ok, res = pcall(syn.request, { Url = url, Method = "GET" })
    if ok and type(res) == "table" and type(res.Body) == "string" then return res.Body end
  end
  return nil
end

-- 3. the engine: from the cache when it is there AND usable, from the
-- network otherwise. A cached file is never trusted blindly: it has to be
-- long enough and it has to COMPILE, or it is thrown away and re-fetched.
local engine = nil
if type(readfile) == "function" then
  local okRead, data = pcall(readfile, FOLDER .. "/" .. FILE)
  if okRead and type(data) == "string" and #data >= MINBYTES then
    local cached = loadstring(data)
    if cached ~= nil then engine = cached end
  end
end

if engine == nil then
  -- The stub asks BOTH paths: /load/ is what the site hands out now, and
  -- /v1/loaders/ is the one that has been proxied the longest — a project
  -- created while /load/ was not proxied yet still loads.
  local source = fetch(ORIGIN .. "/load/init-" .. tostring(ENGINE) .. ".lua" .. SUFFIX)
  if type(source) ~= "string" or #source < MINBYTES then
    source = fetch(ORIGIN .. "/v1/loaders/init-" .. tostring(ENGINE) .. ".lua" .. SUFFIX)
  end
  if type(source) ~= "string" or #source < MINBYTES then
    return stop("could not download the loader engine — is HTTP enabled in your executor?")
  end
  local chunk = loadstring(source)
  if chunk == nil then
    return stop("the loader engine did not compile")
  end
  -- Best effort, never fatal: an executor with no filesystem simply fetches
  -- the engine again next time.
  if type(writefile) == "function" then
    pcall(makefolder, FOLDER)
    pcall(writefile, FOLDER .. "/" .. FILE, source)
  end
  engine = chunk
end

-- 4. run the engine on this script ----------------------------------------
-- The arguments given to THIS chunk travel with the call: a player who
-- writes loadstring(game:HttpGet(url))("XXXX-...") hands the key over
-- without touching the global environment at all.
return engine(DATA, ...)
