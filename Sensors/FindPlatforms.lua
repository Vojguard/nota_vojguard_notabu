local sensorInfo = {
	name = "FindPlatforms",
	desc = "Finding platforms",
	author = "Vojguard",
	date = "2025-04-30",
	license = "notAlicense",
}

local EVAL_PERIOD_DEFAULT = -1 -- instant, no caching

function getInfo()
	return {
		period = EVAL_PERIOD_DEFAULT
	}
end

return function()
    local hills = {}
    local X = Game.mapSizeX / 64
    local Z = Game.mapSizeZ / 64
    local maxHeight = Spring.GetGroundExtremes[2]
    local idx = 1
    for i=1, X do
        for j=1, Z do
            local h = Spring.GetGroundHeight(i * 64, j * 64)
            if h >= maxHeight do                
                hills[idx] = (x = i * 64,z = j * 64)
            end
        end
    end
    return heights
end