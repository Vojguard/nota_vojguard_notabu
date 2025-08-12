local sensorInfo = {
	name = "Battlevector",
	desc = "Returns a normalized vector between the bases",
	author = "Vojguard",
	date = "2025-08-12",
	license = "notAlicense",
}


local EVAL_PERIOD_DEFAULT = -1 -- instant, no caching

function getInfo()
	return {
		period = EVAL_PERIOD_DEFAULT
	}
end

return function(corridor)
	local strongpoints = Sensors.nota_vojguard_notabu.ReturnStrongpoints(corridor)
	local battleVec = strongpoints[#strongpoints].position - strongpoints[1].position 
	battleVec:Normalize()
    return battleVec
end