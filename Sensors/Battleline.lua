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
	local radius = 750
	local basePos = corridor[1].position
    for corIdx = 1, #corridor, 1 do
		local corPos = corridor[corIdx].position
		local units = Sensors.nota_vojguard_notabu.EnemyUnitsInArea(corPos, radius)
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
			local battleVec = Sensors.nota_vojguard_notabu.Battlevector(corridor)
			local perp = Vec3(-battleVec.z, battleVec.y, battleVec.x)
			local conflictPoint = positionProjection(closestUnit, perp, basePos, battleVec)
			conflictPoint.y = closestUnit.y
			if (Script.LuaUI('exampleDebug_update')) then
				Script.LuaUI.exampleDebug_update(
					corIdx,
					{
						startPos = conflictPoint - battleVec * 1000,
						endPos = conflictPoint + battleVec * 100
					}

				)
				Script.LuaUI.exampleDebug_update(
					'battle',
					{
						startPos = conflictPoint + perp * radius,
						endPos = conflictPoint - perp * radius
					}

				)
			end
			return conflictPoint
		end
	end
	return corridor[#corridor].position
end