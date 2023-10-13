local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")

local Roact = require(ReplicatedStorage.Packages.roact)
local events = require(ReplicatedStorage.Shared.events)
local lang = require(ReplicatedStorage.Lang.sectionOne)

local Subtitle = Roact.Component:extend("Subtitle")

local viewedButtons = {};
local currentButton = nil;


function Subtitle:init()
	self.TextLabel = Roact.createRef();

	self.buttonListener = events.viewButtonActivate:Connect(function(viewButton)
		if (lang[viewButton.instance.Name] == nil) then return end
		if (viewedButtons[viewButton.instance.Name] ~= nil) then
			if (currentButton == nil) then self.TextLabel:getValue().Text = "" end
			return
		end

		currentButton = viewButton.instance.Name
		
		viewedButtons[viewButton.instance.Name] = true

		local text = self.TextLabel:getValue()
		text.Text = ""
		for char in string.gmatch(lang[viewButton.instance.Name].Subtitle, utf8.charpattern) do
			if (currentButton ~= viewButton.instance.Name) then return end
			text.Text = text.Text .. char
			task.wait(0.02)
		end
		currentButton = nil;
	end)


end

function Subtitle:willUnmount()
	self.buttonListener:Disconnect();
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