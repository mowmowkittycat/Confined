local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local class = require(ReplicatedStorage.Shared.class)
local component = require(ReplicatedStorage.Shared.component)

local activeButton = "start"

local viewButton, buttons = component("viewButton", class(function(self, object)
	self.part = object ---@type Part

	function self:Init()
		
	end

	function self:Activate()
		activeButton = self.part.Name

	end

	function self:Cleanup()
		
	end

	return self
end))

local module = {
	viewButton,
	buttons
}

return module