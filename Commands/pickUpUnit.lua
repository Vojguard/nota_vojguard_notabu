function getInfo()
	return {
		onNoUnits = SUCCESS, -- instant success
		tooltip = "Pick (load) a single unit",
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
    --[[ if #passenger > 1 then
        Logger.warn("notabu.pickUpUnit", "To many units to pick")
        return FAILURE
    end]]

	local allLoaded = true
	-- pick the spring command implementing the unit loading
	local cmdID = CMD.LOAD_UNITS
	for i=1, #units do
    	local transporting = #Spring.GetUnitIsTransporting(units[i])
    	if transporting < 1 then
			allLoaded = false
        	Spring.GiveOrderToUnit(units[i], cmdID, {passenger[i]}, {})
		end
	end

	if allLoaded then
        return SUCCESS
    else
        return RUNNING
    end
end