function getInfo()
	return {
		onNoUnits = SUCCESS, -- instant success
		tooltip = "Pick (load) a unit",
		parameterDefs = {
			{ 
				name = "unitToPick", -- relative formation
				variableType = "expression",
				componentType = "editBox",
				defaultValue = "",
			},
		}
	}
end

function Run(self, units, parameter)
	local passenger = parameter.unitToPick
    if #passenger > 1 then
        Logger.warn("notabu.pickUpUnit", "To many units to pick")
        return FAILURE
    end

	-- pick the spring command implementing the unit loading
	local cmdID = CMD.LOAD_UNITS
	
    local numUnits = #Spring.GetUnitIsTransporting(units[1])
    if numUnits < 1 then
        Spring.GiveOrderToUnit(units[1], cmdID, {passenger}, {})
        return RUNNING
    else
        return SUCCESS
    end
end