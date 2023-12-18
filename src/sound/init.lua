local ReplicatedStorage = game:GetService("ReplicatedStorage")
local soundlist = require(script.soundlist)

local sounds = {}

for i, sound in pairs(soundlist) do
	sounds[i] = Instance.new("Sound")
	sounds[i].SoundId = "rbxassetid://".. sound.id
	sounds[i].Parent = ReplicatedStorage
end

print(sounds)

function getSound(sound: string)
	return sounds[sound]
end


return { 
	getSound = getSound
}