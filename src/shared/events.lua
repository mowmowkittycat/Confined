local Signal = require(game.ReplicatedStorage.Packages.goodsignal)

local events = {
	-- (viewButton) -> void
	["viewButtonActivate"] = Signal.new(),
	-- (string) -> void
	["itemAdded"] = Signal.new(),
	-- (string) -> void
	["itemRemoved"] = Signal.new(),



}

return events

