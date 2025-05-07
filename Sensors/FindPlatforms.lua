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


return function(threshold)
    local hills = {}
    local X = Game.mapSizeX
    local Z = Game.mapSizeZ
    local minHeight, maxHeight = Spring.GetGroundExtremes()
    if maxHeight ~= nil then
        local heighPoints = {}
        local idx = 1
        for i=1, X, 10 do
            for j=1, Z, 10 do
                local h = Spring.GetGroundHeight(i, j)
                if h >= maxHeight then
                    local point = Vec3(i, h, j)
                    local close = false
                    for _, p in ipairs(hills) do
                        if point:Distance(p) <= threshold then
                            close = true
                        end
                    end
                    if close == false then
                        hills[idx] = Vec3(i, h, j)
                        idx = idx + 1
                    end
                end
            end
        end
    end
    return hills
end