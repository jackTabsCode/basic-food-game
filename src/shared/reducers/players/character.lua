local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Rodux = require(ReplicatedStorage.Packages.Rodux)
local Sift = require(ReplicatedStorage.Packages.Sift)

local StateTypes = require(ReplicatedStorage.shared.types.state)
type CharacterState = StateTypes.CharacterState

local Actions = require(ReplicatedStorage.shared.actions)

local needsReducer = Rodux.createReducer({}, {
	["players/joined"] = function(state: CharacterState, action: Actions.PlayerJoinedAction)
		return Sift.Dictionary.merge(state, {
			[action.username] = {
				hunger = 100,
			},
		})
	end,

	["players/left"] = function(state: CharacterState, action: Actions.PlayerLeftAction)
		return Sift.Dictionary.filter(state, function(_, key)
			return key ~= action.username
		end)
	end,
	["character/hungerDepleted"] = function(state: CharacterState, action: Actions.HungerDepletedAction)
		return Sift.Dictionary.map(state, function(value, key)
			if key == action.username then
				return {
					hunger = value.hunger - 1,
				}
			end
			return value
		end)
	end,

	["character/hungerRegenerated"] = function(state: CharacterState, action: Actions.HungerRegeneratedAction)
		return Sift.Dictionary.map(state, function(value, key)
			if key == action.username then
				return {
					hunger = value.hunger + action.amount,
				}
			end
			return value
		end)
	end,
})

return needsReducer
