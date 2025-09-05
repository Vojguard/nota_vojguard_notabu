local sensorInfo = {
	name = "GroupSurroundingsDangerCounter",
	desc = "Call SurroundingsDangerCounter for a group of units",
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


return function(unitIDs, cautionRange, first, shikaPos)
    local shikaDanger = false
    if shikaPos ~= nil then

    end
	for _, unitID in ipairs(unitIDs) do
        if Spring.ValidUnitID(unitID) then
            local unitPosX, unitPosY, unitPosZ = Spring.GetUnitPosition(unitID)
            local unitPos = Vec3(unitPosX,unitPosY,unitPosZ)
            
            local shikaDanger = false
            if shikaPos ~= nil then
                if unitPos:Distance(shikaPos) < 900 then
                    shikaDanger = true
                end
            end

            local dangerCounter = Sensors.nota_vojguard_notabu.SurroundingsDangerCounter(unitID, cautionRange, first)

            if dangerCounter > 0 or shikaDanger then
                return true
            end
        end
    end
    return false
end