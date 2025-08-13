function getInfo()
	return {
		onNoUnits = SUCCESS, -- instant success
		tooltip = "Move at a safe distance from battleline",
		parameterDefs = {
            { 
				name = "corridor", -- array of the points in the corridor
				variableType = "expression",
				componentType = "editBox",
				defaultValue = "",
			},
			{ 
				name = "distance",
				variableType = "expression",
				componentType = "editBox",
				defaultValue = "",
			},
		}
	}
end

function Run(self, units, parameter)
	local distance = parameter.distance
    local corridor = parameter.corridor
	
	if #units < 1 then
		return SUCCESS
	end

	-- pick the spring command implementing the move
	local cmdMoveID = CMD.MOVE

	local pointToMove = Sensors.nota_vojguard_notabu.Battleposition(corridor, distance)
	if pointToMove ~= nil then
		for idx, unitID in ipairs(units) do

    	    local unitPosX, unitPosY, unitPosZ = Spring.GetUnitPosition(unitID)
    	    local unitPosVec = Vec3(unitPosX, unitPosY, unitPosZ)
        
        	Spring.GiveOrderToUnit(unitID, cmdMoveID, pointToMove:AsSpringVector(), {})
		end
		return RUNNING
    end	
    return SUCCESS
end