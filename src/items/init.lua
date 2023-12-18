local ReplicatedStorage = game:GetService("ReplicatedStorage")

local env = require(ReplicatedStorage.env)


local exports = {}
local itemFiles = {}


for i, child in pairs(script:GetChildren()) do
	if (not child:IsA("ModuleScript")) then return end
	
	itemFiles[child.Name] = require(child)
end


exports.getItems = function() 
	return itemFiles[env.levelName]
end


return exports