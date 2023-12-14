local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local class = require(ReplicatedStorage.Shared.class)
local events = require(ReplicatedStorage.Shared.events)
local inventory = require(ReplicatedStorage.Shared.inventory)
local lang = require(ReplicatedStorage.Lang.sectionOne)

return class(function(self, part: Instance)
	

	self.instance = part
	self.amount = self.instance:GetAttribute("amount")
	if not (self.amount) then self.amount = 1 end
	self.item = self.instance:GetAttribute("item")
	if not (self.item) then self:Destroy() end

	function self:Destroy() 
		self.instance:Destroy()
		self = nil
	end

	function self:Interact()
		inventory.giveItem(self.item, self.amount)
		self:Destroy()
		events.interactHover:Fire("")

	end
	


end)