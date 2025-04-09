local sensorInfo = {
	name = "FormationDefinitions",
	desc = "Return definition of the formaiton based on name key",
	author = "Vojguard",
	date = "2025-04-09",
	license = "notAlicense",
}

local EVAL_PERIOD_DEFAULT = -1 -- instant, no caching

function getInfo()
	return {
		period = EVAL_PERIOD_DEFAULT
	}
end

-- @description return stuctured description of the formation
-- @argument formationName [string] name of the formaiton
return function(unitsToFormations)
	local formationUnits = {}

	for i = 1, #unitsToFormations do
		local unitID = unitsToFormations[i]
		formationUnits[unitID] = i
	end

	return formationUnits
end