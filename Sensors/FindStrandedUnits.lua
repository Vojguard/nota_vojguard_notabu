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

return function(dropZone)
	local dropZoneCenter = dropZone.center
	local strandedUnits = {}
	local allMyUnits = Spring.GetTeamUnits(Spring.GetLocalTeamID())
	for _, myUnit in ipairs(allMyUnits) do
		local myUnitDefID = Spring.GetUnitDefID(myUnit)
    	if UnitDefs[myUnitDefID].cantBeTransported == false then
			local basePointX, basePointY, basePointZ = Spring.GetUnitPosition(myUnit)
			local unitPosVec = Vec3(basePointX, basePointY, basePointZ)
			local unitDist = unitPosVec:Distance(dropZoneCenter)
			if unitDist > dropZone.radius then
      			table.insert(strandedUnits, myUnit)
			end
    	end
  	end

	table.sort(strandedUnits, function(a,b)
		local aX, aY, aZ = Spring.GetUnitPosition(a)
		local aPV = Vec3(aX, aY, aZ)
		local bX, bY, bZ = Spring.GetUnitPosition(b)
		local bPV = Vec3(bX, bY, bZ)
		return aPV:Distance(dropZoneCenter) < bPV:Distance(dropZoneCenter)
	end)

	return strandedUnits
end