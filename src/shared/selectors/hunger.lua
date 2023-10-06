local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local SharedState = require(ReplicatedStorage.shared.types.state)

local selectCharacter = require(script.Parent.character).selectCharacter

function selectHunger(name: string)
	return function(state: SharedState.CommonState)
		local character = selectCharacter(name)(state)
		return if character then character.hunger else 0
	end
end

function selectLocalHunger(state: SharedState.CommonState)
	return selectHunger(Players.LocalPlayer.Name)(state)
end

return {
	selectHunger = selectHunger,
	selectLocalHunger = selectLocalHunger,
}
