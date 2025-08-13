local sensorInfo = {
	name = "Battleposition",
	desc = "Returns a normalized vector between the bases",
	author = "Vojguard",
	date = "2025-08-13",
	license = "notAlicense",
}


local EVAL_PERIOD_DEFAULT = -1 -- instant, no caching

function getInfo()
	return {
		period = EVAL_PERIOD_DEFAULT
	}
end

return function(corridor, offset)
	local battleline = Sensors.nota_vojguard_notabu.Battleline(corridor)
    if battleline ~= nil then
        local conflictPoint = battleline['conflict']
        local battlevec = Sensors.nota_vojguard_notabu.Battlevector(corridor)
        local battleposition = conflictPoint - (battlevec * offset)
        return battleposition
    end
    return nil
end