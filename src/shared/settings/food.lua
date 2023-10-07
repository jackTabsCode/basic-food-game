--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local FoodTypes = require(ReplicatedStorage.shared.types.food)

local foodSettings: { [FoodTypes.FoodType]: FoodTypes.FoodSettings } = {
	["apple"] = {
		displayName = "Apple",
		hunger = 12,
	},
	["orange"] = {
		displayName = "Orange",
		hunger = 10,
	},
}

return foodSettings
