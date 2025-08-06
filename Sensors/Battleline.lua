local sensorInfo = {
	name = "Battleline",
	desc = "Calculate battleline",
	author = "Vojguard",
	date = "2025-08-06",
	license = "notAlicense",
}

-- get madatory module operators
VFS.Include("modules.lua") -- modules table
VFS.Include(modules.attach.data.path .. modules.attach.data.head) -- attach lib module

-- get other madatory dependencies
attach.Module(modules, "message") -- communication backend load

local EVAL_PERIOD_DEFAULT = -1 -- instant, no caching

function getInfo()
	return {
		period = EVAL_PERIOD_DEFAULT
	}
end

-- return a projection of the enemy position on the battlevec (intersection of two perpendicular vectors)
function positionProjection(enemyPos, perpVec, basePos, battleVec) 
    local dx = basePos.x - enemyPos.x
    local dz = basePos.z - enemyPos.z

    local det = perpVec.x * battleVec.z - perpVec.z * battleVec.x

    local t = (dx * battleVec.z - dz * battleVec.x) / det
    return {
        x = enemyPos.x + t * perpVec.x,
		y = 0,
        z = enemyPos.z + t * perpVec.z
    }
end

return function(corridor)
	local strongpoints = Sensors.nota_vojguard_notabu.ReturnStrongpoints(corridor)
	local basePos = strongpoints[1].position
    for spIdx = 1, #strongpoints, 1 do
		local strongpointPos = strongpoints[spIdx].position
		local units = Sensors.nota_vojguard_notabu.EnemyUnitsInArea(strongpointPos, 1500)
		if #units > 0 then
			local upX, upY, upZ = Spring.GetUnitPosition(units[1])
        	local closestUnit = Vec3(upX, upY, upZ)
			for unIdx = 1, #units, 1 do
				local unitPosX, unitPosY, unitPosZ = Spring.GetUnitPosition(units[unIdx])
        		local unitPosVec = Vec3(unitPosX, unitPosY, unitPosZ)

				if (basePos:Distance(closestUnit) > basePos:Distance(unitPosVec)) then
					closestUnit = unitPosVec
				end
			end
			-- vector between both bases
			local battleVec = strongpoints[#strongpoints].position - strongpoints[1].position 
			battleVec:Normalize()
			local perp = Vec3(-battleVec.z, battleVec.y, battleVec.x)
			local conflictPoint = positionProjection(closestUnit, perp, basePos, battleVec)
			conflictPoint.y = closestUnit.y
			local battleline = {
				['start'] = conflictPoint + perp * 500,
				['conflict'] = conflictPoint,
				['end'] = conflictPoint - perp * 500
			}
			if (Script.LuaUI('exampleDebug_update')) then
				Script.LuaUI.exampleDebug_update(
					spIdx,
					{
						startPos = conflictPoint - battleVec * 1000,
						endPos = conflictPoint + battleVec * 100
					}

				)
				Script.LuaUI.exampleDebug_update(
					'battle',
					{
						startPos = battleline['start'],
						endPos = battleline['end']
					}

				)
			end
			return battleline
		end
	end
	return nil
end