--inspired by Commands.nota_sirwok_exam.spySeekShika()
function getInfo()
	return {
		onNoUnits = SUCCESS, -- instant success
		tooltip = "infiltrate enemy strongpoint",
		parameterDefs = {
			{ 
				name = "infiltratorID",
				variableType = "expression",
				componentType = "editBox",
				defaultValue = "",
			},
            {
                name = "corridor",
				variableType = "expression",
				componentType = "editBox",
				defaultValue = "",
            },
			{
				name = "infiltrationPosition",
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
	local infilPos = parameter.infiltrationPosition
	local shika = Sensors.nota_vojguard_notabu.ReturnFirstEnemyShika(parameter.corridor)
    local spyID = parameter.infiltratorID
	if spyID == nil then
		return FAILURE
	end

	if not Spring.ValidUnitID(spyID) then
		return FAILURE
	end

    local x,y,z = Spring.GetUnitPosition(spyID)

	if math.abs(infilPos.x - x) < 200 and math.abs(infilPos.z - z) < 200 then
		return SUCCESS
	end

    if shika ~= nil then
        Spring.GiveOrderToUnit(spyID, CMD.STOP,{},{})
        Spring.GiveOrderToUnit(spyID, CMD.MOVE,{shika.x + 300,shika.y,shika.z -300},{})
		return SUCCESS
	end
	if not self.init then
		Spring.GiveOrderToUnit(spyID, CMD.MOVE,{infilPos.x,infilPos.y,infilPos.z},{})
		self.init = true
	end
	return RUNNING
end