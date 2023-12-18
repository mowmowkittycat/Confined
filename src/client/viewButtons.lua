local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer

local Objects = ReplicatedStorage:FindFirstChild("Objects")

local class = require(ReplicatedStorage.Shared.class)
local component = require(ReplicatedStorage.Shared.component)
local events = require(ReplicatedStorage.Shared.events)
local cutscenes = require(StarterPlayer.StarterPlayerScripts.Client.cutscenes)

local lang = require(ReplicatedStorage.Lang).getLang()
local sound = require(ReplicatedStorage.Sound)

local activeButton: viewButton = nil;
local canActivate = true
local viewedButtons = {}

export type viewButton = {
	Init: () -> nil,
	Cleanup: () -> nil,
	Activate: () -> nil,
	Hover: (Player) -> nil,
	HoverLeave: (Player) -> nil,
	instance: BasePart,
	isActive: boolean,
	ClickDetector: ClickDetector,
	Text: Part,
}


local function typewrite(object, text)
	object.Text = ""
	for char in string.gmatch(text, utf8.charpattern) do
		object.Text = object.Text .. char
		wait(0.02)
	end
end

local viewButton, buttons: { viewButton } = component("viewButton", class(function(self: viewButton)

	function self:Init()
		self.isActive = true;
		self.hasHover = false;
		self.hoverAttempt = 0;
		self.Text = nil;

		self.ClickDetector = Instance.new("ClickDetector")
		self.ClickDetector.Parent = self.instance
		self.ClickDetector.CursorIcon = "none"
		self.ClickDetector.MaxActivationDistance = 1000

		self.ClickDetector.MouseHoverEnter:Connect(function() self:Hover() end)
		self.ClickDetector.MouseHoverLeave:Connect(function() self:HoverLeave() end)
		self.ClickDetector.MouseClick:Connect(function() self:Activate() end)


	end

	function self:TweenToButton()
		local Camera = game.Workspace.CurrentCamera
		local tweenInfo = TweenInfo.new(self.instance:GetAttribute("tweenTime") or 0.5)
		local tween = TweenService:Create(Camera, tweenInfo, { CFrame =  self.instance.CFrame })
		tween:Play()
		
		tween.Completed:Connect(function()
			wait()
			canActivate = true
		end)
	end

	function self:Activate()
		if (canActivate == false) then return end
		canActivate = false
		if (not viewedButtons[self.instance.Name]) then
			viewedButtons[self.instance.Name] = true
			if (lang.viewButton[self.instance.Name]) then
				events.changeSubtitle:Fire(lang.viewButton[self.instance.Name].Subtitle)
			end
		else
			events.changeSubtitle:Fire("")
		end
		
		if (activeButton ~= nil) then
			if (activeButton.instance.Parent == self.instance) then
				if (activeButton.instance:GetAttribute("cutscene") == nil) then

					if (self.instance:GetAttribute("cutscene") ~= nil) then
						local cutscene = self.instance:GetAttribute("cutscene")
						local tweenPart = cutscenes.getLastScene(cutscene)
						local Camera = game.Workspace.CurrentCamera
						local tweenInfo = TweenInfo.new(self.instance:GetAttribute("tweenTime") or 0.5)
						local tween = TweenService:Create(Camera, tweenInfo, { CFrame =  tweenPart.CFrame })
						tween:Play()
					else 
						self:TweenToButton()
					end
				else
					local cutscene = activeButton.instance:GetAttribute("cutscene")
					cutscenes.playCutscene(cutscene, true)
					self:TweenToButton()
				end
			else
				sound.getSound("buttonClick"):Play()
				if (self.instance:GetAttribute("cutscene") ~= nil) then
					local cutscene = self.instance:GetAttribute("cutscene")
					cutscenes.playCutscene(cutscene)
				else 
					self:TweenToButton()
				end
			end
		else 
			sound.getSound("buttonClick"):Play()
			if (self.instance:GetAttribute("cutscene") ~= nil) then
				local cutscene = self.instance:GetAttribute("cutscene")
				cutscenes.playCutscene(cutscene)
			else 
				self:TweenToButton()
			end
		end

		

		canActivate = true





		activeButton = self
		if (self.Text ~= nil) then
			self.Text:Destroy()
			self.Text = nil
		end
		if (self.hasHover) then self.hasHover = false end

		reloadViewButtons()
		

	end

	function self:Hover()
		if (self.isActive == false) then return end
		if (self.Text ~= nil) then
			self.hoverAttempt += 1
			local attempt = self.hoverAttempt
			while (self.Text ~= nil) do
				wait()
				if (attempt ~= self.hoverAttempt) then
					return
				end
			end
		end
		if (self.instance:GetAttribute("sound")) then 
			sound.getSound(self.instance:GetAttribute("sound")):Play()
		else 
			sound.getSound("buttonHover"):Play()
		end
		self.hoverAttempt = 0
		self.hasHover = true
		TweenService:Create(self.instance, TweenInfo.new(0.2), { Transparency = 0.4 } ):Play()

		self.Text = Objects:FindFirstChild("Text"):Clone()
		if (self.Text ~= nil) then
			self.Text.Parent = self.instance
			self.Text.CFrame = self.instance.CFrame
			self.Text.Position = Vector3.new(self.instance.Position.X, self.instance.Position.Y + (self.instance.Size.Y * 1.1), self.Text.Position.Z)
			if (self.instance:GetAttribute("side") == 1) then
				local add = self.instance.CFrame.RightVector * ( ((self.Text.Size.X * 1.2) / 2 ) + (self.instance.Size.X / 2))
				self.Text.Position = Vector3.new(self.instance.Position.X, self.instance.Position.Y, self.Text.Position.Z)
				self.Text.Position += add
			elseif (self.instance:GetAttribute("side") == 2) then
				self.Text.Position = Vector3.new(self.instance.Position.X, self.instance.Position.Y - (self.instance.Size.Y * 1.1), self.Text.Position.Z)
			elseif (self.instance:GetAttribute("side") == 3) then
				local add = self.instance.CFrame.RightVector * ( ((self.Text.Size.X * 1.2) / 2 ) + (self.instance.Size.X / 2))
				self.Text.Position = Vector3.new(self.instance.Position.X, self.instance.Position.Y, self.Text.Position.Z)
				self.Text.Position -= add
			end
			

			local textValue: TextLabel = self.Text:FindFirstChild("UI"):FindFirstChild("Text")

			local tween = TweenService:Create(textValue, TweenInfo.new(0.2), { BackgroundTransparency = 0.4 } )
			tween:Play()
			TweenService:Create(textValue, TweenInfo.new(0.2), { TextTransparency = 0 } ):Play()


			tween.Completed:Connect(function()
				if (self.isActive) then return end
				self.instance.Transparency = 1
			end)


			local titleLang = lang.viewButton[self.instance.Name].HoverTitle

			typewrite(textValue, titleLang)

		end

	end

	function self:HoverLeave()
		self.hoverAttempt = 0
		if (self.hasHover == false) then return end
		if (self.Text == nil) then return end
		self.hasHover = false

		if (canActivate == true) then TweenService:Create(self.instance, TweenInfo.new(0.2), { Transparency = 0.5 } ):Play() end


		local textValue: TextLabel = self.Text:FindFirstChild("UI"):FindFirstChild("Text")

		local tween = TweenService:Create(textValue, TweenInfo.new(0.3), { BackgroundTransparency = 1 } )

		tween:Play()
		TweenService:Create(textValue, TweenInfo.new(0.2), { TextTransparency = 1 } ):Play()

		tween.Completed:Connect(function()
			self.Text:Destroy()
			self.Text = nil
		end)
		tween.Completed:Connect(function()
			if (self.isActive) then return end
			self.instance.Transparency = 1
		end)

	end

	function self:Cleanup()

	end

	return self
end))



function reloadViewButtons()

	for i, button: viewButton in pairs(buttons) do
		button.isActive = false
		button.instance.Transparency = 1
	end
	if (activeButton == nil) then return end
	for i, child in pairs(activeButton.instance:GetChildren()) do 
		if (child:HasTag("viewButton") == false) then continue end

		local button = buttons[child]

		if (button == nil) then continue end

		button.isActive = true
		button.instance.Transparency = 0.5
	end

end

function goBack()
	if (activeButton.instance:GetAttribute("cantBack") == true) then return end
	local lastButton = buttons[activeButton.instance.Parent]

	if (lastButton == nil) then return end


	lastButton:Activate()

end








local module = {
	viewButton = viewButton,
	buttons = buttons,
	reloadViewButtons = reloadViewButtons,
	goBack = goBack,
}

return module