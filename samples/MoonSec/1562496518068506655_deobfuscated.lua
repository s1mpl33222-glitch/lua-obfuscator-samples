function __secureeq(p1, p2)
	local n1 = 0
	local n2 = 0

	pcall(function()
		n1 = #p1
		n2 = #p2
	end)

	return p1 == p2 and (p1 == p2 and (p2 == p1 and (n1 - n2 == n2 - n1 and n1 - n2 == n2 - n1)))
end

zbIFIUAFCLlW = {}

if _ ~= "discord.gg/gQEH2uZxUk" then
	return
end
