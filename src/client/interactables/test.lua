local ReplicatedStorage = game:GetService("ReplicatedStorage")

local class = require(ReplicatedStorage.Shared.class)

return class(function(self, part: Instance)
	
	self.instance = part
	
	function self:Interact() 
		print("test")
		print(self.instance.Name)
	end
end)

