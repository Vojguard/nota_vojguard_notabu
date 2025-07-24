local sensorInfo = {
	name = "GetAllyUnits",
	desc = "Return units from each ally",
	author = "Vojguard",
	date = "2025-07-23",
	license = "notAlicense",
}

local EVAL_PERIOD_DEFAULT = -1 -- instant, no caching
local MY_TEAM_ID = 0

function getInfo()
	return {
		period = EVAL_PERIOD_DEFAULT
	}
end

return function()
    local teams = Spring.GetTeamList()
    local allies = {}
    for _, teamID in pairs(teams) do
        if teamID ~= MY_TEAM_ID and Spring.AreTeamsAllied(MY_TEAM_ID, teamID) then
            allies[#allies + 1] = teamID
        end
    end
    local allyUnits = {}
    for _, teamID  in pairs(allies) do
        local thisAllyUnits = {}
        local teamUnits = Spring.GetTeamUnits(teamID)
        for _, unitID in pairs(teamUnits) do
            local unitDefID = Spring.GetUnitDefID(unitID)
            if not UnitDefs[unitDefID].isBuilding then
                thisAllyUnits[#thisAllyUnits + 1] = unitID
            end
        end
        allyUnits[teamID] = thisAllyUnits
    end
    return allyUnits
end

