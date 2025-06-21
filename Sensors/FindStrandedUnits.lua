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
	local strandedUnits = {}
	local allMyUnits = Spring.GetTeamUnits(Spring.GetLocalTeamID())
	for _, myUnit in ipairs(allMyUnits) do
		local myUnitDefID = Spring.GetUnitDefID(myUnit)
    	if UnitDefs[myUnitDefID].isGroundUnit == true and UnitDefs[myUnitDefID].cantBeTransported == false then
      	table.insert(strandedUnits, myUnit)
    	end
  	end
	return strandedUnits
end