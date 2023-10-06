local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local SharedState = require(ReplicatedStorage.shared.types.state)

local defaults = require(ReplicatedStorage.shared.defaults)

function selectCharacter(name: string)
	return function(state: SharedState.CommonState)
		return state.players.character[name]
	end
end

return {
	selectCharacter = selectCharacter,
}
