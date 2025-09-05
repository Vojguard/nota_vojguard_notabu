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
            },
            {
                name = "retreatPosition",
				variableType = "expression",
				componentType = "editBox",
				defaultValue = "",
            }
        }
    }
end

function getMetalInArea(area)
    --inspired from Sensors.nota_krejci_exam.GetMetalInArea() but changed some params and data
    local features = Spring.GetFeaturesInSphere(area[1], area[2], area[3], area[4])
	local total = 0
	for _, featureID in ipairs(features) do
		local remainingMetal, _ = Spring.GetFeatureResources(featureID)
		total = total + remainingMetal
	end
	return total
end

function Reset(self)
    self.orderGiven = nil
end

function Run(self, units, parameter)
    local farkID = parameter.farkID

    if farkID == nil then
		return SUCCESS
	end

    if Spring.ValidUnitID(farkID) then
        local reclaimArea = parameter.reclaimPosition:AsSpringVector()
        local retreatPos = parameter.retreatPosition:AsSpringVector()
        reclaimArea[4] = parameter.reclaimRadius
        local metal = getMetalInArea(reclaimArea)
        local dangerCounter = Sensors.nota_vojguard_notabu.SurroundingsDangerCounter(farkID, reclaimArea[4] * 2, true)
        
        if dangerCounter > 0 then
            Spring.GiveOrderToUnit(farkID, CMD.STOP, {}, {})
            Spring.GiveOrderToUnit(farkID, CMD.MOVE, {retreatPos[1], retreatPos[2], retreatPos[3]}, {"shift"})
            return SUCCESS
        end
        if metal == 0 then
            return SUCCESS
        end
        if self.orderGiven == nil then
            Spring.GiveOrderToUnit(farkID, CMD.STOP, {}, {})
            Spring.GiveOrderToUnit(farkID, CMD.RECLAIM, reclaimArea, {})
            self.orderGiven = true
        end
    else
        return SUCCESS
    end
    return RUNNING
    
end
