----inspired by Commands.nota_sirwok_exam.GroupAttackEnemyUnit()
function getInfo()
	return {
		parameterDefs = {
			{ 
				name = "unitIDs",
				variableType = "expression",
				componentType = "editBox",
				defaultValue = "",
			},
			{ 
				name = "positionToSiege",
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
    local unitIDs = parameter.unitIDs
    local posToSiege = parameter.positionToSiege

	if posToSiege == nil then
		return SUCCESS
	end

	if not self.init then
        for _, unitID in pairs(unitIDs) do
            if Spring.ValidUnitID(unitID) then
			    Spring.GiveOrderToUnit(unitID, CMD.FIRE_STATE,0, {})
                Spring.GiveOrderToUnit(unitID, CMD.ATTACK,posToSiege, {"shift"})
            end
        end
		self.init = true
	end

	return SUCCESS
end