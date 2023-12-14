local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local StarterPlayer = game:GetService("StarterPlayer")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Roact = require(ReplicatedStorage.Packages.roact)
local events = require(ReplicatedStorage.Shared.events)



local interactHover = Roact.Component:extend("interactHover")


type state = {
	currentTitle: string,
	currentTween: Tween,
	active: boolean
}

function interactHover:init()
	self.hoverLabel = Roact.createRef();
	local state: state;
	state = {
		currentTitle = "",
		currentTween = nil,
		active = false,
	}
	self.connection = RunService.Heartbeat:Connect(function()
		if not (self.hoverLabel:getValue()) then return end
		local mousepos = UserInputService:GetMouseLocation()
		self.hoverLabel:getValue().Position = UDim2.fromOffset(mousepos.X + 15,mousepos.Y)
	end)
	events.interactHover:Connect(function(interactName)
		self.hoverLabel:getValue().Text = interactName
		state.currentTitle = interactName

		if (state.active) then return end
		if (state.currentTween) then
			if not (state.currentTween.PlaybackState == Enum.PlaybackState.Completed) then 
				state.currentTween:Pause()
				state.currentTween:Destroy()
			end 
		end
		local tween = TweenService:Create(self.hoverLabel:getValue(), TweenInfo.new(0.2), { TextTransparency = 0, TextStrokeTransparency = 0.5 })
		tween:Play()
		state.currentTween = tween
		state.active = true
		
	end)

	events.interactHoverEnd:Connect(function(interactName)
		if (self.hoverLabel:getValue().Text ~= interactName and state.active == true) then return end
		if (state.currentTween) then
			if not (state.currentTween.PlaybackState == Enum.PlaybackState.Completed) then 
				state.currentTween:Pause()
				state.currentTween:Destroy()
			end
		end
		local tween = TweenService:Create(self.hoverLabel:getValue(), TweenInfo.new(0.2), { TextTransparency = 1, TextStrokeTransparency = 1 })
		tween:Play()
		state.currentTween = tween
		state.active = false
	
	end)
end

function interactHover:render()
	return Roact.createElement("TextLabel", {
		[Roact.Ref] = self.hoverLabel,
		Text = "",
		TextSize = 11,
		TextColor3 = Color3.fromRGB(245, 245, 245),
		TextStrokeColor3 = Color3.fromRGB(0,0,0),
		TextXAlignment = Enum.TextXAlignment.Left,
		TextStrokeTransparency = 1,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ZIndex = 20,
		TextTransparency =  1,


	}, {})

end

function interactHover:willUnmount()
	self.connection:Disconnect();
end

return interactHover