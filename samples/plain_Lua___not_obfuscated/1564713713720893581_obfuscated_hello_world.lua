local _0xA = {72,101,108,108,111,32,87,111,114,108,100}
local _0xB = function(t)
	local _0xC = {}
	for _0xD = 1, #t do
		_0xC[_0xD] = string.char((t[_0xD] + 7) % 256 - 7 % 256 + (0 * _0xD))
	end
	return table.concat(_0xC)
end
local _0xE = (function() return print end)()
_0xE(_0xB(_0xA))
