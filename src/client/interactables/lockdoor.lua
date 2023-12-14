local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local class = require(ReplicatedStorage.Shared.class)
local events = require(ReplicatedStorage.Shared.events)
local lang = require(ReplicatedStorage.Lang.sectionOne)
local inventory = require(ReplicatedStorage.Shared.inventory)

return class(function(self, part: Instance)

	self.instance = part
	self.itemInteract = true
	self.hoverText = self.instance:GetAttribute("hoverText")
	if (self.hoverText) then
		self.initialText = self.hoverText.. "-lock"
		self.instance:SetAttribute("hoverText", self.initialText)
	end 
	self.canInteract = true;
	self.positions = {}
	self.positions[0] = part:Clone()
	self.positions[1] = part:FindFirstChild("2"):Clone()
	self.position = 0
	self.unlocked =  false
	part:FindFirstChild("2"):Destroy()
	
	function self:Interact()
		if (not self.unlocked) then
			if not (self.item) then return end
			if (self.item ~= self.instance:GetAttribute("key")) then return end
			if not (inventory.removeItem(self.item, 1)) then return end
			self.unlocked = true
			self.initialText = self.hoverText
			self.itemInteract = false
		end
		if not(self.canInteract) then return end
		self.canInteract = false

		self.position = (self.position + 1) % 2
		local tween = TweenService:Create(self.instance, TweenInfo.new(0.5), {CFrame = self.positions[self.position].CFrame})
		tween:Play()
		tween.Completed:Connect(function()
			self.canInteract = true
		end)
		if (self.initialText) then
			local hoverText = self.initialText
			local prevHoverText = self.initialText
			if (self.position ~= 0) then hoverText = hoverText .. "-close" end
			if (self.position == 0) then prevHoverText = prevHoverText .. "-close" end
			self.instance:SetAttribute("hoverText", hoverText)
			events.interactHoverEnd:Fire(lang.interactable[prevHoverText])
			events.interactHover:Fire(lang.interactable[hoverText])
		end

	end
end)

