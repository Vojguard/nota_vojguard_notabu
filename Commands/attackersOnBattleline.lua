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
    local strongpointRange = 700

    if #unitIDs == 0 then
        return SUCCESS
    end

    for _, unitID in ipairs(unitIDs) do
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

            if death then
                Spring.GiveOrderToUnit(unitID, CMD.STOP, {}, {})
                Spring.GiveOrderToUnit(unitID, CMD.MOVE, {retreatPos[1], retreatPos[2], retreatPos[3]}, {"shift"})
            end
            Spring.GiveOrderToUnit(unitID, CMD.STOP, {}, {})
            Spring.GiveOrderToUnit(unitID, CMD.MOVE, {battlePos[1], battlePos[2], battlePos[3]}, {"shift"})
        end
    end
    return SUCCESS
end
