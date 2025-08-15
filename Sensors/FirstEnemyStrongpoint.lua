local sensorInfo = {
	name = "FindFirstEnemyStrongpoint",
	desc = "Return Strongpoints in given corridor",
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


return function(corridor)
    local myTeam = 0
    for corIdx = 1, #corridor, 1 do
        local point = corridor[corIdx]
		if point.isStrongpoint then
            if point.ownerAllyID ~= myTeam then
			    return point
            end
		end
	end
    return nil
end