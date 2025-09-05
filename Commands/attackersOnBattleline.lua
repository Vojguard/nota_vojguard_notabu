--inspired by Commands.nota_sirwok_exam.GetSafeAttackPosition()
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
            },
            {
                name = "cautionRange",
                variableType = "number",
                componentType = "editBox",
                defaultValue = "300"
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
    local battlePos = parameter.battlePosition:AsSpringVector()
    local retreatPos = parameter.retreatPosition:AsSpringVector()
    local strongpointPos = parameter.closestStrongpoint
    local strongpointRange = 900
    local caution = parameter.cautionRange
    local formOffset = parameter.formationOffset

    local battlePosVec = Vec3(battlePos[1],battlePos[2], battlePos[3])
    local retreatPosVec = Vec3(retreatPos[1], retreatPos[2], retreatPos[3])
    local battlevec = battlePosVec - retreatPosVec
    battlevec:Normalize()
    local perp = Vec3(-battlevec.z, battlevec.y, battlevec.x)
    local finalPosVec = Vec3(0,0,0)
    local death = false

    if #unitIDs == 0 then
        return SUCCESS
    end

    for _, unitID in ipairs(unitIDs) do
        if Spring.ValidUnitID(unitID) then
            local unitPosX, unitPosY, unitPosZ = Spring.GetUnitPosition(unitID)
            local unitPos = Vec3(unitPosX,unitPosY,unitPosZ)
                 
            local dangerCounter = Sensors.nota_vojguard_notabu.SurroundingsDangerCounter(unitID, caution, false)
            if dangerCounter > 0 or unitPos:Distance(strongpointPos) < strongpointRange then
                death = true
                break
            end
        end
    end

    if death then
        finalPosVec = retreatPosVec
    else
        finalPosVec = battlePosVec
    end

    for i, unitID in ipairs(unitIDs) do
        if Spring.ValidUnitID(unitID) then
            local unitPosX, unitPosY, unitPosZ = Spring.GetUnitPosition(unitID)
            local unitPos = Vec3(unitPosX,unitPosY,unitPosZ)            
            local thisBattlePos = finalPosVec + (perp * (formOffset * (i - 1)) * ((-1) ^ i))

            Spring.GiveOrderToUnit(unitID, CMD.STOP, {}, {})
            Spring.GiveOrderToUnit(unitID, CMD.MOVE, thisBattlePos:AsSpringVector(), {"shift"})
        end
    end

    for _, unitID in ipairs(unitIDs) do
        if Spring.ValidUnitID(unitID) then
            local unitPosX, unitPosY, unitPosZ = Spring.GetUnitPosition(unitID)
            if math.abs(unitPosX - finalPosVec.x) < 200 and math.abs(unitPosZ - finalPosVec.z) < 200 then
                return SUCCESS
            end
        end
    end

    return RUNNING
end
