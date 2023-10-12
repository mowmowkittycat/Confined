local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")


local viewButtons = require(script.viewButtons)


Players.LocalPlayer.CharacterAdded:Connect(function(character)
	wait()
	local Camera = workspace.CurrentCamera
	Camera.CameraType = Enum.CameraType.Scriptable
	Camera.FieldOfView = 90

	while (viewButtons.buttons == nil) do wait() end
	local firstButton: viewButtons.viewButton = viewButtons.buttons[game.Workspace:FindFirstChild("Buttons"):GetChildren()[1]]
	Camera.CFrame = firstButton.instance.CFrame
	firstButton:Activate()

end)





UserInputService.InputBegan:Connect(function(input: InputObject)
	if (input.KeyCode == Enum.KeyCode.S) then
		print(viewButtons)
		viewButtons.goBack()
	end
end)