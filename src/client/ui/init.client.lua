local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.Packages.roact)
local Subtitle = require(script.subtitle)
local Scale = require(script.uiScale)

local app = Roact.createElement("ScreenGui", {
	IgnoreGuiInset = true
}, {
	Frame = Roact.createElement("Frame", {
			Size=UDim2.fromOffset(1920,1080),
			AnchorPoint = Vector2.new(0.5,0.5),
			Position = UDim2.fromScale(0.5,0.5),
			BackgroundTransparency = 1,
			BorderSizePixel = 0
		},
		{
			Scale = Roact.createElement(Scale, {
				Size = Vector2.new(1920,1080),
				Scale = 1,
			}),
			Frame = Roact.createElement("Frame", {
				Size = UDim2.fromOffset(1000,200),
				AnchorPoint = Vector2.new(0.5,0.5),
				Position = UDim2.fromScale(0.5,0.8),
				BackgroundTransparency = 1,
				BorderSizePixel = 0

			}, {
				Subtitle = Roact.createElement(Subtitle),
			})
			
		}
	),

})

Roact.mount(app, Players.LocalPlayer.PlayerGui, "ScreenGui")