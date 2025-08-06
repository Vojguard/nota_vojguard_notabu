local sensorInfo = {
	name = "ReturnStrongpoints",
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
	local strongpoints = {}
    for corIdx = 1, #corridor, 1 do
		if corridor[corIdx].isStrongpoint then
			strongpoints[#strongpoints + 1] = corridor[corIdx]
		end
	end
    return strongpoints
end