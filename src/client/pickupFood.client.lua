local ProximityPromptService = game:GetService("ProximityPromptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local FoodTypes = require(ReplicatedStorage.shared.types.food)
local foodSettings = require(ReplicatedStorage.shared.settings.food)

local pickupFoodEvent = ReplicatedStorage.shared.events.pickupFood

ProximityPromptService.PromptTriggered:Connect(function(prompt)
	local food = prompt.Parent
	if not food:HasTag("food") then
		return
	end

	local foodType = food.Name :: FoodTypes.FoodType

	local settings = foodSettings[foodType]
	if not settings then
		return
	end

	pickupFoodEvent:FireServer(food)
end)
