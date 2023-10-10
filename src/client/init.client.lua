local RunService = game:GetService("RunService")
local viewButtons = require(script.viewButtons)


while viewButtons.buttons == nil do wait() end
for _, button in pairs(viewButtons.buttons) do
	print(button)
	button:actiavte()
end
