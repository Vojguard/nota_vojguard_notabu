local sensorInfo = {
	name = "GetMyUnits",
	desc = "Return my units",
	author = "Vojguard",
	date = "2025-08-25",
	license = "notAlicense",
}
 
local EVAL_PERIOD_DEFAULT = -1 -- instant, no caching
local MY_TEAM_ID = 0

function getInfo()
	return {
		period = EVAL_PERIOD_DEFAULT
	}
end

return function(unitName)
    local myUnits = Spring.GetTeamUnits(MY_TEAM_ID)
    local myUnitsFinal = {}
    for _, unitID in pairs(myUnits) do
        local unitDefID = Spring.GetUnitDefID(unitID)
        if not UnitDefs[unitDefID].isBuilding then
            if unitName ~= nil then
                if UnitDefs[unitDefID].name == unitName then
                    myUnitsFinal[#myUnitsFinal + 1] = unitID
                end
            else
                myUnitsFinal[#myUnitsFinal + 1] = unitID
            end
        end
    end
    return myUnitsFinal
end