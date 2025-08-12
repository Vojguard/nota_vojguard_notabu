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
	
	-- pick the spring command implementing the move
	local cmdMoveID = CMD.MOVE

    local conflictPoint = Sensors.nota_vojguard_notabu.Battleline(corridor)['conflict']
    local battlevec = Sensors.nota_vojguard_notabu.Battlevector(corridor)

    if conflictPoint ~= nil then
	

	    for idx, unitID in ipairs(units) do

            local unitPosX, unitPosY, unitPosZ = Spring.GetUnitPosition(unitID)
            local unitPosVec = Vec3(unitPosX, unitPosY, unitPosZ)

            local pointToMove = conflictPoint - (battlevec * distance)
            Spring.GiveOrderToUnit(unitID, cmdMoveID, pointToMove:AsSpringVector(), {})

        end
    end
		
    return RUNNING
end