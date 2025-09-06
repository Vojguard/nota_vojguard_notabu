local sensorInfo = {
	name = "GetMetalInArea",
	desc = "Return metal amount in area",
	author = "Vojguard",
	date = "2025-08-25",
	license = "notAlicense",
}
 
local EVAL_PERIOD_DEFAULT = -1 -- instant, no caching
local MY_TEAM_ID = 0

function getInfo()
	return {
		period = EVAL_PERIOD_DEFAULT
	}
end

return function(area)
    local features = Spring.GetFeaturesInSphere(area[1], area[2], area[3], area[4])
	local total = 0
	for _, featureID in ipairs(features) do
		local remainingMetal, _ = Spring.GetFeatureResources(featureID)
		total = total + remainingMetal
	end
	return total
end