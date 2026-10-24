local aetheriumToken = "13f1f0b314e2deaddad561c8ac41387550ba2284674c097f29be5965914d8fc8"
local sourceUrl = "https://saffronscripts.xyz/api/free-source?token=" .. aetheriumToken
local source = game:HttpGet(sourceUrl)
if type(source) ~= "string" or source == "" then error("Aetherium loader returned no source") end
local execute, compileError = loadstring(source)
if type(execute) ~= "function" then error(compileError or "Aetherium loader could not compile the source") end
execute()