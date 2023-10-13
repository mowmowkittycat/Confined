local Workspace = game:GetService("Workspace")
local GuiService = game:GetService("GuiService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Camera = Workspace.CurrentCamera

local Roact = require(ReplicatedStorage.Packages.roact)

local Scale = Roact.PureComponent:extend("Scale")

function Scale:init()
	self:update()

	self.Listener = Camera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
		self:update()
	end)
end

function Scale:update()
	local currentSize = self.props.Size
	local viewportSize = Camera.ViewportSize

	self:setState({
		Scale = 1 / math.max(
			currentSize.X / viewportSize.X,
			currentSize.Y / viewportSize.Y
		)
	})
end

function Scale:willUnmount()
	self.Listener:Disconnect()
end

function Scale:render()
	return Roact.createElement("UIScale", {
		Scale = self.state.Scale * self.props.Scale
	})
end

Scale.defaultProps = {
	Scale = 1
}

return Scale