local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local class = require(ReplicatedStorage.Shared.class)
local component = require(ReplicatedStorage.Shared.component)

local activeButton = "start"

local viewButton, buttons = component("viewButton", class(function(self, object)
	self.part = object ---@type Part

	function self:Init()
		self.part.Parent = workspace
		print(self)
	end

	function self:Activate()
		activeButton = self.part.Name

	end

	function self:Cleanup()
		print("fuck u 2")
		print(self)
	end

	return self
end))
while Players.LocalPlayer.Character == nil do wait() end

print(buttons)








local module = {
	viewButton,
	buttons
}

return module