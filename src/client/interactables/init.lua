
exports = {}


for i, child in pairs(script:GetChildren()) do
	if (not child:IsA("ModuleScript")) then return end
	exports[child.Name] = require(child)
end

return exports