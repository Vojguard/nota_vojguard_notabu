function getInfo()
	return {
		onNoUnits = SUCCESS, -- instant success
		tooltip = "Move each unit to a platform",
		parameterDefs = {
			{ 
				name = "unitsToLoad", -- relative formation
				variableType = "expression",
				componentType = "editBox",
				defaultValue = "",
			},
		}
	}
end

function Run(self, units, parameter)
	local passengers = parameter.unitsToLoad
	
	-- pick the spring command implementing the unit loading
	local cmdID = CMD.LOAD_UNITS
	
    local numUnits = #Spring.GetUnitIsTransporting(units[1])
    if numUnits < #passengers then
        Spring.GiveOrderToUnit(units[1], cmdID, {passengers[numUnits + 1]}, {})
        return RUNNING
    else
        return SUCCESS
    end
end