function getInfo()
	return {
		onNoUnits = SUCCESS, -- instant success
		tooltip = "Move each unit to a platform",
		parameterDefs = {
			{ 
				name = "platforms", -- array of the platforms
				variableType = "expression",
				componentType = "editBox",
				defaultValue = "",
			},
		}
	}
end

function Run(self, units, parameter)
	local hills = parameter.platforms -- array of Vec3
	
	if (#units > #hills) then
		Logger.warn("formation.move", "Your formation size [" .. #formation .. "] is smaller than needed for given count of units [" .. #units .. "] in this group.") 
		return FAILURE
	end
	
	-- pick the spring command implementing the move
	local cmdID = CMD.MOVE
	
	for i=1, #units do
		local thisUnitWantedPosition = hills[i]
        Spring.GiveOrderToUnit(units[i], cmdID, thisUnitWantedPosition:AsSpringVector(), {})
    end
		
    return RUNNING
end