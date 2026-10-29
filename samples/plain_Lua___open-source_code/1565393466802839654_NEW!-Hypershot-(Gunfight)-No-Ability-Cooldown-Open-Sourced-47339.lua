for _, v in next, getgc(true) do -- you can use require too, ReplicatedStorage.Abilities.Modules But this one is more simple
	if typeof(v) == 'table' and rawget(v, 'CD') then
		rawset(v, 'CD', 0)
	end
end