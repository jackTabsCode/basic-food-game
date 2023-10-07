local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Rodux = require(ReplicatedStorage.Packages.Rodux)
local Sift = require(ReplicatedStorage.Packages.Sift)

local ActionTypes = require(ReplicatedStorage.shared.types.actions)
local StateTypes = require(ReplicatedStorage.shared.types.state)

local foodSettings = require(ReplicatedStorage.shared.settings.food)

local characterReducer = Rodux.createReducer({}, {
	["character/spawned"] = function(state: StateTypes.CharacterState, action: ActionTypes.PlayerJoinedAction)
		return Sift.Dictionary.merge(state, {
			[action.username] = {
				hunger = 100,
			},
		})
	end,

	["character/died"] = function(state: StateTypes.CharacterState, action: ActionTypes.PlayerLeftAction)
		return Sift.Dictionary.filter(state, function(_, key)
			return key ~= action.username
		end)
	end,

	["character/hungerDepleted"] = function(state: StateTypes.CharacterState, action: ActionTypes.HungerDepletedAction)
		return Sift.Dictionary.map(state, function(value, key)
			if key == action.username then
				return {
					hunger = value.hunger - 1,
				}
			end
			return value
		end)
	end,

	["inventory/foodConsumed"] = function(state: StateTypes.CharacterState, action: ActionTypes.FoodConsumedAction)
		local settings = foodSettings[action.foodType]

		return Sift.Dictionary.map(state, function(value, key)
			if key == action.username then
				return {
					hunger = math.min(100, value.hunger + settings.hunger),
				}
			end
			return value
		end)
	end,
})

return characterReducer
