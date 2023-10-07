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
			inventory[foodType] = 0
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
					[action.foodType] = value[action.foodType] + 1,
				})
			end
			return value
		end)
	end,

	["inventory/foodConsumed"] = function(state: StateTypes.InventoryState, action: ActionTypes.FoodConsumedAction)
		return Sift.Dictionary.map(state, function(value, key)
			if key == action.username then
				return Sift.Dictionary.merge(value, {
					[action.foodType] = value[action.foodType] - 1,
				})
			end
			return value
		end)
	end,
})

return inventoryReducer
