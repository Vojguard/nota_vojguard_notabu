local sensorInfo = {
	name = "FindEnemyShika",
	desc = "Return Shika position at given strongpoint",
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

return function(strongpoint)
    local myTeam = 0
    local unitsAtStrongpoint = Spring.GetUnitsInSphere(strongpoint.x,  strongpoint.y,  strongpoint.z,  200)
    for _, unitID in ipairs(unitsAtStrongpoint) do
        local unitDef = Spring.GetUnitDefID(unitID)
        if unitDef ~= nil then
            local unitName = UnitDefs[unitDef].name
            if unitName == "shika" then
                local unitTeam = Spring.GetUnitTeam(unitID)
                if not Spring.AreTeamsAllied(myTeam, unitTeam) then
                    local unitPosX, unitPosY, unitPosZ = Spring.GetUnitPosition(unitID)
                    return Vec3(unitPosX, unitPosY, unitPosZ)
                end
            end
        end
    end
    return nil
end