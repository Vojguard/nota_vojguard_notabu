local sensorInfo = {
	name = "Battleposition",
	desc = "Returns a normalized vector between the bases",
	author = "Vojguard",
	date = "2025-08-13",
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

return function(corridor, offset)
	local battleline = Sensors.nota_vojguard_notabu.Battleline(corridor)
    if battleline ~= nil then
        local battlevec = Sensors.nota_vojguard_notabu.Battlevector(corridor)
		local perp = Vec3(-battlevec.z, battlevec.y, battlevec.x)
        local battleposition = battleline - (battlevec * offset)
		if (Script.LuaUI('exampleDebug_update')) then
				Script.LuaUI.exampleDebug_update(
					offset,
					{
						startPos = battleposition + perp * 500,
						endPos = battleposition - perp * 500
					}

				)
		end
        return battleposition
    end
    return nil
end