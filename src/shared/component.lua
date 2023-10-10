local CollectionService = game:GetService("CollectionService")

return function(tag, class)

	local members = {}

	if class.Init == nil then class.Init = function() end end
	if class.Cleanup == nil then class.Cleanup = function() end end

	local tagAdded = function(object)
		if object:IsA("BasePart") == false then return end
		local component = class(object)
		members[object] = component
		members[object]:Init()
	end

	local tagRemoved = function(object)
		if object:IsA("BasePart") == false then return end

		members[object]:Cleanup();

		if members[object] ~= nil then members[object] = nil end
	end

	CollectionService:GetInstanceAddedSignal(tag):Connect(tagAdded)
	CollectionService:GetInstanceRemovedSignal(tag):Connect(tagRemoved)

	for _, object in pairs(CollectionService:GetTagged(tag)) do
		tagAdded(object)
	end

	return class
end