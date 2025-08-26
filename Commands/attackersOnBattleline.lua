local commandInfo = {}

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
                name = "battlePosition",
				variableType = "expression",
				componentType = "editBox",
				defaultValue = "",
            },
            {
                name = "retreatPosition",
				variableType = "expression",
				componentType = "editBox",
				defaultValue = "",
            },
            {
                name = "closestStrongpoint",
                variableType = "expression",
                componentType = "editBox",
                defaultValue = ""
            }
        }
    }
end

function Run(self, units, parameter)
    local unitIDs = parameter.unitIDs
    local battlePos = parameter.battlePosition:AsSpringVector()
    local retreatPos = parameter.retreatPosition:AsSpringVector()
    local strongpointPos = parameter.closestStrongpoint
    local strongpointRange = 900

    local battlePosVec = Vec3(battlePos[1],battlePos[2], battlePos[3])
    local retreatPosVec = Vec3(retreatPos[1], retreatPos[2], retreatPos[3])
    local battlevec = battlePosVec - retreatPosVec
    battlevec:Normalize()
    local perp = Vec3(-battlevec.z, battlevec.y, battlevec.x)
    

    if #unitIDs == 0 then
        return SUCCESS
    end

    for i, unitID in ipairs(unitIDs) do
        if Spring.ValidUnitID(unitID) then
            local unitPosX, unitPosY, unitPosZ = Spring.GetUnitPosition(unitID)
            local unitPos = Vec3(unitPosX,unitPosY,unitPosZ)
            local dangerCounter = Sensors.nota_vojguard_notabu.SurroundingsDangerCounter(unitID, 300, false)
            local death = false

            if dangerCounter > 0 then
                death = true
            end
            if unitPos:Distance(strongpointPos) < strongpointRange then
                death = true
            end

            local thisRetreatPos = battlePosVec + (perp * (100 * (i - 1)))

            if death then
                Spring.GiveOrderToUnit(unitID, CMD.STOP, {}, {})
                Spring.GiveOrderToUnit(unitID, CMD.MOVE, thisRetreatPos:AsSpringVector(), {"shift"})
            end
            
            local thisBattlePos = battlePosVec + (perp * (100 * (i - 1)))

            Spring.GiveOrderToUnit(unitID, CMD.STOP, {}, {})
            Spring.GiveOrderToUnit(unitID, CMD.MOVE, thisBattlePos:AsSpringVector(), {"shift"})
        end
    end
    return SUCCESS
end
