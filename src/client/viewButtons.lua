local ReplicatedStorage = game:GetService("ReplicatedStorage")

local class = require(ReplicatedStorage.Shared.class)
local component = require(ReplicatedStorage.Shared.component)

local activeButton = "start"

local viewButton = component("viewButton", class(function(self, object)
	self.part = object

	function self:Init()
		print("fuck u")
		print(self)
	end

	function self:Cleanup()
		print("fuck u 2")
		print(self)
	end

	return self
end))





local buttons = {}





local module = {
	viewButton,
	buttons
}

return module