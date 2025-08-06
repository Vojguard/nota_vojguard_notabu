local sensorInfo = {
	name = "EnemyUnitsInArea",
	desc = "Return a table of enemies in an area",
	author = "Vojguard",
	date = "2025-08-06",
	license = "notAlicense",
}

local EVAL_PERIOD_DEFAULT = -1 -- instant, no caching

function getInfo()
	return {
		period = EVAL_PERIOD_DEFAULT
	}
end


return function(position, range)
    local myTeam = 0
	local unitsInRange = Spring.GetUnitsInSphere(position.x, position.y, position.z, range)
    local enemies = {}
	for _, uID in ipairs(unitsInRange) do
		local unitTeam = Spring.GetUnitTeam(uID)
		if not Spring.AreTeamsAllied(myTeam, unitTeam) then
			enemies[#enemies + 1] = uID
		end
	end
    return enemies
end