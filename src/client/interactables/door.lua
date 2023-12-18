local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local class = require(ReplicatedStorage.Shared.class)
local events = require(ReplicatedStorage.Shared.events)
local lang = require(ReplicatedStorage.Lang).getLang()
local sound = require(ReplicatedStorage.Sound)

return class(function(self, part: Instance)

	self.instance = part
	self.hoverText = {}
	self.hoverText[0] = self.instance:GetAttribute("hoverText")
	if (self.hoverText[0]) then
		self.hoverText[1] = self.instance:GetAttribute("hoverText") .. "-close"
	end 
	self.canInteract = true;
	self.positions = {}
	self.positions[0] = part:Clone()
	self.positions[1] = part:FindFirstChild("2"):Clone()
	self.sound = {}
	self.sound[0] = "doorClose"
	self.sound[1] = "doorOpen"
	self.position = 0
	part:FindFirstChild("2"):Destroy()
	
	function self:Interact()
		if (self.canInteract) then
			self.position = (self.position + 1) % 2
			sound.getSound(self.sound[self.position]):Play()
			local tween = TweenService:Create(self.instance, TweenInfo.new(0.5), {CFrame = self.positions[self.position].CFrame})
			self.canInteract = false
			tween:Play()
			tween.Completed:Connect(function()
				self.canInteract = true
			end)
			if (self.hoverText[0]) then
				local hoverText = self.hoverText[self.position]
				self.instance:SetAttribute("hoverText", hoverText)
			end
		end
	end
end)

