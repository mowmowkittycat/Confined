local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")

local class = require(ReplicatedStorage.Shared.class)
local lang = require(ReplicatedStorage.Lang.sectionOne)
local component = require(ReplicatedStorage.Shared.component)
local events = require(ReplicatedStorage.Shared.events)
local interactables = require(StarterPlayer.StarterPlayerScripts.Client.interactables)

export type interactable = {
	Init: () -> nil,
	instance: BasePart,
	ClickDetector: ClickDetector,
}

local interactable, count = component("interactable", class(function(self: interactable) 

	function self:Init()
		self.ClickDetector = Instance.new("ClickDetector")
		self.ClickDetector.Parent = self.instance
		self.ClickDetector.CursorIcon = "none"
		self.ClickDetector.MaxActivationDistance = 100
		local interact = self.instance:GetAttribute("interact")
		if not (interact) then self=nil end
		if not (interactables[interact]) then self=nil end
		self.interactClass = interactables[interact](self.instance)

		
		
		self.hasHover = false
		self.ClickDetector.MouseHoverEnter:Connect(function() self:Hover() end)
		self.ClickDetector.MouseHoverLeave:Connect(function() self:HoverLeave() end)
		self.ClickDetector.MouseClick:Connect(function() self:Interact() end)
		events.createInteractClick:Connect(function(item)
			if not (self.hasHover) then return end
			if not (self.interactClass.itemInteract) then return end
			self.interactClass.item = item
			self:Interact()
		end)
	end

	function self:Hover()
		self.hasHover = true
		if (self.instance:GetAttribute("hoverText")) then
			events.interactHover:Fire(lang.interactable[self.instance:GetAttribute("hoverText")])
		end
		

	end

	function self:HoverLeave()
		self.hasHover = false
		if (self.instance:GetAttribute("hoverText")) then
			events.interactHoverEnd:Fire(lang.interactable[self.instance:GetAttribute("hoverText")])
		end
	end

	function self:Interact()
			self.interactClass:Interact()
			self.interactClass.item = nil
		if not (self.interactClass) then self = nil end

		
		
	end


end))

return { 
	interactable,
	interactables = count,
}