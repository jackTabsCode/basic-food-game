local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Rodux = require(ReplicatedStorage.Packages.Rodux)
local Sift = require(ReplicatedStorage.Packages.Sift)

local ActionTypes = require(ReplicatedStorage.shared.types.actions)
local StateTypes = require(ReplicatedStorage.shared.types.state)

local foodSettings = require(ReplicatedStorage.shared.settings.food)

local inventoryReducer = Rodux.createReducer({}, {
	["character/spawned"] = function(state: StateTypes.InventoryState, action: ActionTypes.PlayerJoinedAction)
		local inventory = {}
		Sift.Dictionary.map(foodSettings, function(_, foodType)
			inventory[foodType] = {
				amount = 0,
				equipped = false,
			}
		end)

		return Sift.Dictionary.merge(state, {
			[action.username] = inventory,
		})
	end,

	["character/died"] = function(state: StateTypes.InventoryState, action: ActionTypes.PlayerLeftAction)
		return Sift.Dictionary.filter(state, function(_, key)
			return key ~= action.username
		end)
	end,

	["inventory/foodAdded"] = function(state: StateTypes.InventoryState, action: ActionTypes.FoodAddedAction)
		return Sift.Dictionary.map(state, function(value, key)
			if key == action.username then
				return Sift.Dictionary.merge(value, {
					[action.foodType] = {
						amount = value[action.foodType].amount + 1,
						equipped = value[action.foodType].equipped,
					},
				})
			end
			return value
		end)
	end,

	["inventory/foodConsumed"] = function(state: StateTypes.InventoryState, action: ActionTypes.FoodConsumedAction)
		return Sift.Dictionary.map(state, function(value, key)
			if key == action.username then
				return Sift.Dictionary.merge(value, {
					[action.foodType] = {
						amount = value[action.foodType].amount - 1,
						equipped = value[action.foodType].amount - 1 > 0 and value[action.foodType].equipped or false,
					},
				})
			end
			return value
		end)
	end,

	["inventory/foodEquipped"] = function(state: StateTypes.InventoryState, action: ActionTypes.FoodEquippedAction)
		return Sift.Dictionary.map(state, function(value, key)
			if key == action.username then
				return Sift.Dictionary.map(value, function(food, foodType)
					return Sift.Dictionary.merge(food, {
						equipped = action.foodType == foodType,
					})
				end)
			end
			return value
		end)
	end,

	["inventory/foodUnequipped"] = function(state: StateTypes.InventoryState, action: ActionTypes.FoodUnequippedAction)
		return Sift.Dictionary.map(state, function(value, key)
			if key == action.username then
				return Sift.Dictionary.map(value, function(food)
					return Sift.Dictionary.merge(food, {
						equipped = false,
					})
				end)
			end
			return value
		end)
	end,
})

return inventoryReducer
