local sensorInfo = {
	name = "LineFormation",
	desc = "Return definition of the formaiton based on name key",
	author = "Vojguard",
	date = "2025-04-16",
	license = "notAlicense",
}

local EVAL_PERIOD_DEFAULT = -1 -- instant, no caching

function getInfo()
	return {
		period = EVAL_PERIOD_DEFAULT
	}
end

return function()
	local positions = {
        [1] = Vec3(1,0,0), [11] = Vec3(-1,0,0),
        [2] = Vec3(2,0,0), [12] = Vec3(-2,0,0),
        [3] = Vec3(3,0,0), [13] = Vec3(-3,0,0),
        [4] = Vec3(4,0,0), [14] = Vec3(-4,0,0),
        [5] = Vec3(5,0,0), [15] = Vec3(-5,0,0),
        [6] = Vec3(6,0,0), [16] = Vec3(-6,0,0),
        [7] = Vec3(7,0,0), [17] = Vec3(-7,0,0),
        [8] = Vec3(8,0,0), [18] = Vec3(-8,0,0),
        [9] = Vec3(9,0,0), [19] = Vec3(-9,0,0),
        [10] = Vec3(10,0,0), [20] = Vec3(-10,0,0),

    }
	
	return positions
end