function getInfo()
	return {
		onNoUnits = SUCCESS, -- instant success
		tooltip = "Drop the unit in the area",
		parameterDefs = {
			{ 
				name = "dropArea", -- relative formation
				variableType = "expression",
				componentType = "editBox",
				defaultValue = "",
			},
		}
	}
end

function Run(self, units, parameter)
	local dropZone = parameter.dropArea
	
	-- pick the spring command implementing the unit unloading
    local allUnloaded = true
    for i,unit in ipairs(units) do
        local transporting = #Spring.GetUnitIsTransporting(unit)
        if transporting > 0 then
            allUnloaded = false
            local commandQueue = Spring.GetUnitCommands(unit)
            if #commandQueue < 1 then 
                Spring.GiveOrderToUnit(unit, CMD.UNLOAD_UNITS, {dropZone.center.x, dropZone.center.y, dropZone.center.z, dropZone.radius}, {})
            end            
        end
    end
    
    if allUnloaded then
        return SUCCESS
    else
        return RUNNING
    end
end