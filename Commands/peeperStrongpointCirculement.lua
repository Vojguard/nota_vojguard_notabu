function getInfo()
	return {
		onNoUnits = SUCCESS, -- instant success
		tooltip = "Circulete around strongpoint",
		parameterDefs = {
			{ 
				name = "peeperID",
				variableType = "expression",
				componentType = "editBox",
				defaultValue = "",
			},
            {
                name = "corridor",
				variableType = "expression",
				componentType = "editBox",
				defaultValue = "",
            }
		}
	}
end

function Reset(self)
	self.init = false
end

function Run(self, units, parameter)
    local strongpoint = Sensors.nota_vojguard_notabu.FirstEnemyStrongpoint(parameter.corridor)
    local peepID = parameter.peeperID
	if peepID == nil then
		return FAILURE
	end

	if not Spring.ValidUnitID(peepID) then
		return FAILURE
	end

    local x,y,z = Spring.GetUnitPosition(peepID)

    if strongpoint ~= nil then
        Spring.GiveOrderToUnit(peepID, CMD.STOP,{},{})
        Spring.GiveOrderToUnit(peepID, CMD.MOVE,{strongpoint.x - 150,strongpoint.y,strongpoint.z + 150},{"shift"})
		Spring.GiveOrderToUnit(peepID, CMD.MOVE,{strongpoint.x - 900,strongpoint.y,strongpoint.z + 900},{"shift"})
		return SUCCESS
	end
	return RUNNING
end