-- This file was generated at discord.gg/syncrypt

local v1
if tick() < 1763809636.9279 then
	v1 = tick() > 1763204836.9279
else
	v1 = false
end
if v1 then
	print(1763809636.9279 - tick())

	if getgenv().BSF then
		warn("Already Executed!")

		return
	end

	return
else
	warn("do not.")

	return
end
