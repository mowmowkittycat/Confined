local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")

local Roact = require(ReplicatedStorage.Packages.roact)
local events = require(ReplicatedStorage.Shared.events)
local items = require(ReplicatedStorage.Items.sectionOne)
local inventory = require(StarterPlayer.StarterPlayerScripts.Client.inventory)

local Inventory = Roact.Component:extend("Inventory")


function Inventory:init(props)
	self:setState(inventory.getItems());

	events.itemAdded:Connect(self:setState(inventory.getItems()))
	events.itemRemoved:Connect(self:setState(inventory.getItems()))
end


function Inventory:willUnmount()

end

function Inventory:render()

	local inventoryElements = {}

	local connection
	local itemRefs = {}


	for i, v: inventory.inventorySlot in self.state do
		itemRefs[i] = Roact.createRef();
		local position = UDim2.new(0.5,0,0,((i-1)*75) + 15);
		local parent;
		inventoryElements[i] = Roact.createElement("ImageLabel", {
			Image = "http://www.roblox.com/asset/?id=".. items[v.item].Image,
			Size = UDim2.fromOffset(50,50),
			AnchorPoint = Vector2.new(0.5,0,5),
			Position = position,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ZIndex = 10;
			[Roact.Ref] = itemRefs[i],
			[Roact.Event.InputBegan] = function(_, input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					if not connection then
						local mousepos = UserInputService:GetMouseLocation() - Vector2.new(0, GuiService:GetGuiInset().Y)
						itemRefs[i]:getValue().Position = UDim2.fromOffset(mousepos.X,mousepos.Y)
						parent = itemRefs[i]:getValue().Parent
						itemRefs[i]:getValue().Parent = itemRefs[i]:getValue().Parent.Parent.Parent.Parent:FindFirstChild("NoScaleFrame")
						itemRefs[i]:getValue().ZIndex = 11;
						connection = RunService.Heartbeat:Connect(function()
							local mousepos = UserInputService:GetMouseLocation() - Vector2.new(0, GuiService:GetGuiInset().Y)
							itemRefs[i]:getValue().Position = UDim2.fromOffset(mousepos.X,mousepos.Y)
							print("test")
						end)
					end
				end
				
			end,
			[Roact.Event.InputEnded] = function(_, input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					if connection then
						connection:Disconnect()
						connection = nil;
						itemRefs[i]:getValue().Position = position
						itemRefs[i]:getValue().Parent = parent
						print("test")
						itemRefs[i]:getValue().ZIndex = 10;
					end
				end
				
			end


		}, {
			Roact.createElement("TextLabel", {
				Text = "x".. v.amount,
				AnchorPoint = Vector2.new(0.5,0.5),
				Position = UDim2.new(0.9,0,1,0),
				TextSize = 13,
				TextColor3 = Color3.fromRGB(245, 245, 245),
				TextStrokeColor3 = Color3.fromRGB(0,0,0);
				TextStrokeTransparency = 0.5,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ZIndex = 10,
			},{})

		})
		
		
	end

	
	return Roact.createElement("Frame", {
		Size = UDim2.fromOffset(300,800),
		AnchorPoint = Vector2.new(0,0.5),
		Position = UDim2.new(0,-200,0.5,0),
		BackgroundColor3 = Color3.fromRGB(0,0,0),
		BackgroundTransparency = 0.7,
		BorderSizePixel = 0,

	}, 
	{
		Roact.createElement("Frame", {
			Size = UDim2.fromOffset(100,750),
			AnchorPoint = Vector2.new(1,0),
			Position = UDim2.new(1,0,0,25),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,

		}, inventoryElements),
		Roact.createElement("UICorner", {
			CornerRadius = UDim.new(0,12)
		}, {})
	})
end

return Inventory;