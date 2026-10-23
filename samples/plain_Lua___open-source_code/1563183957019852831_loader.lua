-- Aspects Studio Release Loader
-- The original obfuscated Lua source is stored unchanged in 17 release parts.
-- Downloading these parts does not execute them; the final loadstring call does.
local BASE = "https://raw.githubusercontent.com/TalionAspect/Aspects-Studio-Release/main/release/"
local PARTS = 17
local PART_SIZE = 256000
local LAST_PART_SIZE = 36548
local TOTAL_SIZE = 4132548

local sourceParts = table.create(PARTS)
for i = 1, PARTS do
    local filename = string.format("part%02d.txt", i)
    local url = BASE .. filename
    local ok, contents = pcall(function()
        return game:HttpGet(url)
    end)
    if not ok or type(contents) ~= "string" then
        error("Aspects Studio: failed to download " .. filename .. ": " .. tostring(contents), 0)
    end
    local expected = i == PARTS and LAST_PART_SIZE or PART_SIZE
    if #contents ~= expected then
        error("Aspects Studio: unexpected size in " .. filename .. " (" .. tostring(#contents) .. " bytes)", 0)
    end
    sourceParts[i] = contents
end

local source = table.concat(sourceParts)
if #source ~= TOTAL_SIZE then
    error("Aspects Studio: incomplete release download", 0)
end

local chunk, err = loadstring(source)
if not chunk then
    error("Aspects Studio: compile failed: " .. tostring(err), 0)
end
return chunk()
