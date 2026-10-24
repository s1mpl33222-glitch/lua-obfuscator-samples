local HttpGet = (syn and syn.request and function(u)
  local r = syn.request({Url=u, Method='GET', Headers={['X-Client']='executor'}})
  return r and r.Body
end) or (http and http.request and function(u)
  local r = http.request({Url=u, Method='GET', Headers={['X-Client']='executor'}})
  return r and r.Body
end) or (request and function(u)
  local r = request({Url=u, Method='GET', Headers={['X-Client']='executor'}})
  return r and (r.Body or r.body)
end) or (game and function(u)
  return game:HttpGet(u)
end)
if not HttpGet then error("no http") end
local url = "https://luacode.net/raw/9sjq2j33ug8fjs687mrc"
local src = HttpGet(url)
local function hub_compile(src, label)
  label = label or "hub"
  if type(src) ~= "string" or #src < 12 then
    error(label .. ": bad or empty response")
  end
  if src:sub(1, 1) == "<" then
    error(label .. ": got HTML, not Lua")
  end
  local fn, err
  if loadstring then
    fn, err = loadstring(src)
  else
    fn, err = load(src, label, "t")
  end
  if not fn then
    error(label .. ": " .. tostring(err))
  end
  return fn
end
return hub_compile(src, "script")()
