local sensorInfo = {
	name = "PositionsDistance",
	desc = "Return the distance between two positions",
	author = "Vojguard",
	date = "2025-09-08",
	license = "notAlicense",
}

local EVAL_PERIOD_DEFAULT = -1 -- instant, no caching

function getInfo()
	return {
		period = EVAL_PERIOD_DEFAULT
	}
end

return function(posA, posB)
    return posA:Distance(posB)
end