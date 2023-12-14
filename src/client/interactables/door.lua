local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local class = require(ReplicatedStorage.Shared.class)
local events = require(ReplicatedStorage.Shared.events)
local lang = require(ReplicatedStorage.Lang.sectionOne)

return class(function(self, part: Instance)

	self.instance = part
	local hoverText = self.instance:GetAttribute("hoverText")
	if (hoverText) then
		self.initialText = hoverText
	end 
	self.canInteract = true;
	self.positions = {}
	self.positions[0] = part:Clone()
	self.positions[1] = part:FindFirstChild("2"):Clone()
	self.position = 0
	part:FindFirstChild("2"):Destroy()
	
	function self:Interact()
		if (self.canInteract) then
			self.position = (self.position + 1) % 2
			local tween = TweenService:Create(self.instance, TweenInfo.new(0.5), {CFrame = self.positions[self.position].CFrame})
			self.canInteract = false
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
	end
end)

