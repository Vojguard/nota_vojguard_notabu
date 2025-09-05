local sensorInfo = {
	name = "ReturnFirstEnemyShika",
	desc = "Return the position of the first enemy shika in the given corridor",
	author = "Vojguard",
	date = "2025-09-05",
	license = "notAlicense",
}

local EVAL_PERIOD_DEFAULT = -1 -- instant, no caching

function getInfo()
	return {
		period = EVAL_PERIOD_DEFAULT
	}
end


return function(corridor)
	local myTeam = 0
	local strongpoints = Sensors.nota_vojguard_notabu.ReturnStrongpoints(corridor)
	for _, sp in ipairs(strongpoints) do
		if sp.ownerAllyID ~= myTeam then
			local shika = Sensors.nota_vojguard_notabu.FindEnemyShika(sp.position)
			if shika ~= nil then
				return shika
			end
		end
	end
	return nil
end