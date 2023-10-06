local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local SharedState = require(ReplicatedStorage.shared.types.state)

local defaults = require(ReplicatedStorage.shared.defaults)

function selectCharacter(name: string)
	return function(state: SharedState.CommonState)
		return if state.players.character[name] then state.players.character[name] else defaults.character
	end
end

function selectHunger(name: string)
	return function(state: SharedState.CommonState)
		return selectCharacter(name)(state).hunger
	end
end

function selectLocalHunger(state: SharedState.CommonState)
	return selectHunger(Players.LocalPlayer.Name)(state)
end

return {
	selectHunger = selectHunger,
	selectLocalHunger = selectLocalHunger,
}
