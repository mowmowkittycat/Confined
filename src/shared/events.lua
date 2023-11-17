local Signal = require(game.ReplicatedStorage.Packages.goodsignal)

local events = {
	-- (viewButton) -> void
	["viewButtonActivate"] = Signal.new(),
	-- (string) -> void
	["itemAdded"] = Signal.new(),
	-- (string) -> void
	["itemRemoved"] = Signal.new(),
	-- (string) -> void
	["itemAmountChange"] = Signal.new(),
	-- (string) -> void
	["cutsceneStart"] = Signal.new(),
	-- (string) -> void
	["cutsceneStop"] = Signal.new()



}

return events

