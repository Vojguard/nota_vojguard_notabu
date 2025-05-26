local sensorInfo = {
	name = "FindStrandedUnits",
	desc = "Find units to save",
	author = "Vojguard",
	date = "2025-05-26",
	license = "notAlicense",
}

local EVAL_PERIOD_DEFAULT = -1 -- instant, no caching

function getInfo()
	return {
		period = EVAL_PERIOD_DEFAULT
	}
end

return function()

end