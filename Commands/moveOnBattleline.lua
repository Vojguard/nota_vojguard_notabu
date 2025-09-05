function getInfo()
	return {
		tooltip = "Move at a safe distance from battleline",
		parameterDefs = {
            { 
                name = "unitIDs",
                variableType = "expression",
                componentType = "editBox",
                defaultValue = "",
            },
            {
                name = "battlePosition",
				variableType = "expression",
				componentType = "editBox",
				defaultValue = "",
            },
			{
				name = "battleVector",
				variableType = "expression",
				componentType = "editBox",
				defaultValue = "",
			},
            {
                name = "formationOffset",
                variableType = "number",
                componentType = "editBox",
                defaultValue = "50"
            }
		}
	}
end

function Run(self, units, parameter)
    local unitIDs = parameter.unitIDs

	if unitIDs == nil then
		return FAILURE
	end

    local battlePos = parameter.battlePosition:AsSpringVector()
	local battleVec = parameter.battleVector:AsSpringVector()
    local formOffset = parameter.formationOffset

    local battlePosVec = Vec3(battlePos[1],battlePos[2], battlePos[3])
    local battlevec = Vec3(battleVec[1],battleVec[2], battleVec[3])
    battlevec:Normalize()
    local perp = Vec3(-battlevec.z, battlevec.y, battlevec.x)

    for i, unitID in ipairs(unitIDs) do
        if Spring.ValidUnitID(unitID) then
            local unitPosX, unitPosY, unitPosZ = Spring.GetUnitPosition(unitID)
            local unitPos = Vec3(unitPosX,unitPosY,unitPosZ)            
            local thisBattlePos = battlePosVec + (perp * (formOffset * (i - 1)) * ((-1) ^ i))

            Spring.GiveOrderToUnit(unitID, CMD.STOP, {}, {})
            Spring.GiveOrderToUnit(unitID, CMD.MOVE, thisBattlePos:AsSpringVector(), {})
        end
    end

    for _, unitID in ipairs(unitIDs) do
        if Spring.ValidUnitID(unitID) then
            local unitPosX, unitPosY, unitPosZ = Spring.GetUnitPosition(unitID)
            if math.abs(unitPosX - battlePosVec.x) < 100 and math.abs(unitPosZ - battlePosVec.z) < 100 then
                return SUCCESS
            end
        end
    end
    return RUNNING
end