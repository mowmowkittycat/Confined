local ReplicatedStorage = game:GetService("ReplicatedStorage")

local events = require(ReplicatedStorage.Shared.events)

local exports = {}

export type inventorySlot = {
	item: string,
	amount: number
}

local inventory: { inventorySlot } = { }

exports.getItem = function(string: string): ( inventorySlot, number )
	for i, v in pairs(inventory) do
		if (v == string) then
			return v, i
		end
	end
	return nil, -1
end

exports.hasItem = function(string: string, amount: number): boolean
	if (amount == nil) then amount = 1 end
	local item, _ = exports.getItem(string)
	if (item == nil) then return false end
	if (item.amount < amount) then return false end
	return true

end

exports.getItems = function(): { inventorySlot }
	return table.clone(inventory)
end

exports.giveItem = function(string: string, amount: number): boolean
	if (amount == nil) then amount = 1 end
	local item, _ = exports.getItem(string)
	if (item == nil) then
		table.insert(inventory, {item =  string, amount = amount})
		events.itemAdded:Fire(string)
		return true
	end
	item.amount += amount
	events.itemAmountChange:Fire(string)

	return true

end

exports.removeItem = function(string: string, amount: number): boolean
	local item, i = exports.getItem(string)
	if (item == nil) then return false end
	if (amount == nil) then
		table.remove(inventory, i)
		events.itemRemoved:Fire(string)
		return true
	end
	item.amount -= amount

	if (item.amount <= 0) then
		table.remove(inventory,i)
	end
	events.itemAmountChange:Fire(string)

	return true

end

exports.giveItem("wrench",3)
exports.giveItem("test",5)

return exports

