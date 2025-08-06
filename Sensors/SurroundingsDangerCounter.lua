local sensorInfo = {
	name = "SurroundingsDangerCounter",
	desc = "Danger level with ration ally/enemy",
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


return function(unitID, cautionRange)
	local myTeam = 0
    local unitPosX, unitPosY, unitPosZ = Spring.GetUnitPosition(unitID)
	local unitsAround = Spring.GetUnitsInSphere(unitPosX, unitPosY, unitPosZ, cautionRange)
	local dangerCounter = 0
	for _, uID in ipairs(unitsAround) do
		local unitTeam = Spring.GetUnitTeam(uID)
		if Spring.AreTeamsAllied(myTeam, unitTeam) then
			dangerCounter = dangerCounter - 1
		else
			dangerCounter = dangerCounter + 1
		end
	end
    return dangerCounter
end