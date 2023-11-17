local ContentProvider = game:GetService("ContentProvider")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local cutscenes = {}
local cutsceneFolder = game.Workspace:WaitForChild("Cutscenes")
local events = require(ReplicatedStorage.Shared.events)

for i, instance in pairs(cutsceneFolder:GetDescendants()) do
	instance.Transparency = 1
end

for i, instance in pairs(cutsceneFolder:GetChildren()) do
	if (cutscenes[instance.Name] ~= nil) then continue end
	local array = { instance }
	local tempInstance = instance
	for i, v in pairs(instance:GetDescendants()) do
		table.insert(array,tempInstance:GetChildren()[1])
		tempInstance = tempInstance:GetChildren()[1]
	end

	cutscenes[instance.Name] = array
end

function playCutscene(cutscene: string, reverese: boolean)
	if (reverese == nil) then reverese = false end
	if (cutscenes[cutscene] == nil) then return end
	local Camera = game.Workspace.CurrentCamera
	events.cutsceneStart:Fire(cutscene)
	for i,v in pairs(cutscenes[cutscene]) do
		if (reverese == true) then
			if (i == 1) then continue end
			i = (#cutscenes[cutscene] - (i-1))
			
		end
		local tweenPart: BasePart = cutscenes[cutscene][i]
		local tweenTime = 0.5
		if (tweenPart:GetAttribute("tweenTime") ~= nil) then tweenTime = tweenPart:GetAttribute("tweenTime") end
		local tweenInfo = TweenInfo.new(tweenTime)
		local tween = TweenService:Create(Camera, tweenInfo, { CFrame = tweenPart.CFrame})
		tween:Play()
		repeat task.wait() until (tween.PlaybackState ~= Enum.PlaybackState.Playing)
	end
	events.cutsceneStop:Fire(cutscene)
end

return {
	cutscenes = cutscenes,
	playCutscene = playCutscene
}