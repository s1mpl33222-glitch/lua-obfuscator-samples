local key = script_key
if type(key) ~= "string" or not key:match("^%x+$") or (#key ~= 12 and #key ~= 32) then error("Invalid script key") end
return loadstring(game:HttpGet("https://code-cloak-workshop.lovable.app/api/public/scripts/012e5ad761aa418e994c16493446c113?key=" .. key))()