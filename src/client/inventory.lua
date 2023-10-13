local ReplicatedStorage = game:GetService("ReplicatedStorage")

local events = require(ReplicatedStorage.Shared.events)

local inventory = {}

return {
	hasItem = function(string: string): boolean
		for i, v in pairs(inventory) do
			if (v == string) then return true end
		end
		return false
	end,
	getItems = function(string: string): { string }
		return table.clone(inventory)
	end,
	giveItem = function(string: string): boolean
		for i, v in pairs(inventory) do
			if (v == string) then return false end
		end
		table.insert(inventory, string)
		events.itemAdded:Fire(string)
		return true
	end,
	removeItem = function(string: string): boolean
		for i, v in pairs(inventory) do
			if (v == string) then
				table.remove(inventory, i)
				events.itemRemoved:Fire(string)
				return true
			end
		end
		return false
	end,

}



