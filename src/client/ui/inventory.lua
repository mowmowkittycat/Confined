local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")


local Roact = require(ReplicatedStorage.Packages.roact)
local events = require(ReplicatedStorage.Shared.events)
local state = require(ReplicatedStorage.Shared.state)
local items = require(ReplicatedStorage.Items.sectionOne)
local inventory = require(ReplicatedStorage.Shared.inventory)

local Inventory = Roact.Component:extend("Inventory")

local isHeld = false

function Inventory:init(props)

	local resetState = function() 
		self:setState(inventory.getItems()) 
	end
	events.itemAdded:Connect(resetState)
	events.itemRemoved:Connect(resetState)
	events.itemAmountChange:Connect(resetState)

	resetState()

	self.itemRefs = {}
end


function Inventory:willUnmount()

end

function Inventory:render()

	

	local inventoryElements = {}

	for i, v: inventory.inventorySlot in pairs(inventory:getItems()) do
		if not self.itemRefs[i] then self.itemRefs[i] = Roact.createRef() end
		local position = UDim2.new(0.5,0,0,((i-1)*75) + 15);
		local parent;
		inventoryElements[i] = Roact.createElement("ImageLabel", {
			Image = "http://www.roblox.com/asset/?id=".. items[v.item].Image,
			Size = UDim2.fromOffset(50,50),
			AnchorPoint = Vector2.new(0.5,0.5),
			Position = position,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ZIndex = 10;
			[Roact.Ref] = self.itemRefs[i],
			[Roact.Event.InputBegan] = function(_, input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					if not self.connection then
						local mousepos = UserInputService:GetMouseLocation()
						self.itemRefs[i]:getValue().Position = UDim2.fromOffset(mousepos.X,mousepos.Y)
						parent = self.itemRefs[i]:getValue().Parent
						self.itemRefs[i]:getValue().Parent = self.itemRefs[i]:getValue().Parent.Parent.Parent.Parent:FindFirstChild("NoScaleFrame")
						self.itemRefs[i]:getValue().ZIndex = 11;
						self.connection = RunService.Heartbeat:Connect(function()
							mousepos = UserInputService:GetMouseLocation()
							self.itemRefs[i]:getValue().Position = UDim2.fromOffset(mousepos.X,mousepos.Y)
						end)
						isHeld = true
						events.interactHover:Fire("")
					end
				end
				
			end,
			[Roact.Event.InputEnded] = function(_, input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					if self.connection then
						self.connection:Disconnect()
						self.connection = nil;
						self.itemRefs[i]:getValue().Position = position
						self.itemRefs[i]:getValue().Parent = parent
						self.itemRefs[i]:getValue().ZIndex = 10;
						isHeld = false
						events.createInteractClick:Fire(v.item)
					end
				end
				
			end,
			[Roact.Event.MouseEnter] = function()
				if (isHeld) then return end
				events.interactHover:Fire(items[v.item].Name)
			end,
			[Roact.Event.MouseLeave] = function()
				if (isHeld) then return end
				events.interactHoverEnd:Fire(items[v.item].Name)
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