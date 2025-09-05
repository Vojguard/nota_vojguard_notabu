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
		return FAILURE
	end

    if Spring.ValidUnitID(farkID) then
        local reclaimArea = parameter.reclaimPosition:AsSpringVector()
        reclaimArea[4] = parameter.reclaimRadius
        local metal = getMetalInArea(reclaimArea)

        if self.orderGiven == nil then
            if metal > 0 then
                Spring.GiveOrderToUnit(farkID, CMD.RECLAIM, reclaimArea, {})
                self.orderGiven = true
            else
                Spring.GiveOrderToUnit(farkID, CMD.MOVE, reclaimArea, {})
                self.orderGiven = true
            end
        end
    else
        return SUCCESS
    end
    return RUNNING
    
end
