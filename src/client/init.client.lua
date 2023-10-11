local RunService = game:GetService("RunService")


local viewButton, buttons = require(script.viewButtons)


while buttons == nil do wait() end
for _, button in pairs(buttons) do
	print(button)
	button:actiavte()
end
