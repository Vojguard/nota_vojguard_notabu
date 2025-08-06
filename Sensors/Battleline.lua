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


return function(corridor)
	local strongpoints = Sensors.nota_vojguard_notabu.ReturnStrongpoints(corridor)
    for spIdx = 1, #strongpoints, 1 do
		local strongpointPos = strongpoints[spIdx].position
		local units = Sensors.nota_vojguard_notabu.EnemyUnitsInArea(strongpointPos, 1500)
		if #units > 0 then
			local upX, upY, upZ = Spring.GetUnitPosition(units[1])
        	local closestUnit = Vec3(upX, upY, upZ)
			for unIdx = 1, #units, 1 do
				local unitPosX, unitPosY, unitPosZ = Spring.GetUnitPosition(units[unIdx])
        		local unitPosVec = Vec3(unitPosX, unitPosY, unitPosZ)

				if (strongpointPos:Distance(closestUnit) > strongpointPos:Distance(unitPosVec)) then
					closestUnit = unitPosVec
				end
			end
			local battleVec = closestUnit - strongpointPos
			local battleline = {
				['start'] = closestUnit + Vec3(-battleVec.x, battleVec.y, battleVec.z),
				['end'] = closestUnit + Vec3(battleVec.x, battleVec.y, -battleVec.z)
			}
			if (Script.LuaUI('exampleDebug_update')) then
				Script.LuaUI.exampleDebug_update(
					spIdx,
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