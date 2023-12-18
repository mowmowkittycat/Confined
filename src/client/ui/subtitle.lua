local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")

local Roact = require(ReplicatedStorage.Packages.roact)
local events = require(ReplicatedStorage.Shared.events)


local Subtitle = Roact.Component:extend("Subtitle")

function Subtitle:init()
	self.TextLabel = Roact.createRef();
	self.subtitle = nil;

	self.subtitleListener =  events.changeSubtitle:Connect(function(subtitle)
		local text = self.TextLabel:getValue()
		text.Text = ""
		self.subtitle = subtitle
		for char in string.gmatch(subtitle, utf8.charpattern) do
			if (self.subtitle ~= subtitle) then return end
			text.Text = text.Text .. char
			task.wait(0.02)
		end
		
	end)



end

function Subtitle:willUnmount()
	self.subtitleListener:Disconnect();
end


function Subtitle:render()
	return Roact.createElement("TextLabel", {
		[Roact.Ref] = self.TextLabel,
		Font = Enum.Font.SourceSans,
		TextSize = 50,
		TextColor3 = Color3.fromRGB(255,255,255),
		TextStrokeColor3 = Color3.fromRGB(0,0,0),
		TextStrokeTransparency = 0.2,
		TextWrapped = true,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.fromScale(1,1),

	})

end

return Subtitle