function getInfo()
	return {
		onNoUnits = SUCCESS, -- instant success
		tooltip = "Move following the corridor",
		parameterDefs = {
			{ 
				name = "corridor", -- array of the points in the corridor
				variableType = "expression",
				componentType = "editBox",
				defaultValue = "",
			},
			{
				name = "cautionRange",
				variableType = "expression",
				componentType = "editBox",
				defaultValue = "10"
			},
		}
	}
end

function Run(self, units, parameter)
	local corridor = parameter.corridor -- array of Vec3
	local cautionRange = parameter.cautionRange
	
	-- pick the spring command implementing the move
	local cmdFightID = CMD.FIGHT
	local cmdMoveID = CMD.MOVE

	
	for idx, unitID in ipairs(units) do

        local unitPosX, unitPosY, unitPosZ = Spring.GetUnitPosition(unitID)
        local unitPosVec = Vec3(unitPosX, unitPosY, unitPosZ)

        -- check if unit has command queue
        local hasCmdQueue = Spring.GetUnitCommands(unitID, 1)[1] ~= nil

        if not hasCmdQueue then
			local closestPoint = #corridor
			local corridorPoint = corridor[closestPoint].position
			
			-- find nearest point
			for i=#corridor - 1, 1, -1 do
				local nextPoint = corridor[i].position
				if (unitPosVec:Distance(nextPoint) < unitPosVec:Distance(corridorPoint)) then
					corridorPoint = nextPoint
					closestPoint = i
				else break end
			end
			
			if Sensors.nota_vojguard_notabu.SurroundingsDangerCounter(unitID, cautionRange) > 0 and closestPoint > 1 then
				closestPoint = closestPoint - 1
			end
            -- give order queue to move in the corridor through its points
            for j=closestPoint, #corridor do
				corridorPoint = corridor[j].position				
                Spring.GiveOrderToUnit(unitID, cmdMoveID, corridorPoint:AsSpringVector(), {"shift"})
            end
        end
    end
		
    return RUNNING
end