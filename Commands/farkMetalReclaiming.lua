--inspired by Commands.nota_sirwok_exam.reclaimMetal()
function getInfo()
    return {
        tooltip = "Collect metal at battleposition",
        parameterDefs = {
            { 
                name = "farkID",
                variableType = "expression",
                componentType = "editBox",
                defaultValue = "",
            },
            { 
                name = "reclaimPosition",
                variableType = "expression",
                componentType = "editBox",
                defaultValue = "",
            },
            { 
                name = "reclaimRadius",
                variableType = "expression",
                componentType = "editBox",
                defaultValue = "200",
            }
        }
    }
end

function Reset(self)
    self.orderGiven = nil
end

function Run(self, units, parameter)
    local farkID = parameter.farkID
    local unitPosX, _, unitPosZ = Spring.GetUnitPosition(farkID)

    if farkID == nil then
		return FAILURE
	end

    if Spring.ValidUnitID(farkID) then
        local reclaimArea = parameter.reclaimPosition:AsSpringVector()
        local reclaimPos = Vec3(reclaimArea[1],reclaimArea[2], reclaimArea[3])
        reclaimArea[4] = parameter.reclaimRadius
        local metal = Sensors.nota_vojguard_notabu.GetMetalInArea(reclaimArea)

        if metal == 0 then
            return SUCCESS
        end

        if self.orderGiven == nil then
            Spring.GiveOrderToUnit(farkID, CMD.RECLAIM, reclaimArea, {})
            self.orderGiven = true 
        end
        
    else
        return SUCCESS
    end
    return RUNNING
    
end
