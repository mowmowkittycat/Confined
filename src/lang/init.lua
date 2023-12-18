local ReplicatedStorage = game:GetService("ReplicatedStorage")

local env = require(ReplicatedStorage.env)


local exports = {}
local langFiles = {}


for i, child in pairs(script:GetChildren()) do
	if (not child:IsA("ModuleScript")) then return end
	
	langFiles[child.Name] = require(child)
end


exports.getLang = function() 
	return langFiles[env.levelName]
end


return exports