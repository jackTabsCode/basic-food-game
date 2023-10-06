local ReplicatedStorage = game:GetService("ReplicatedStorage")

local SharedState = require(ReplicatedStorage.shared.types.state)

function selectHunger(name: string)
	return function(state: SharedState.CommonState)
		return state.players.character[name].hunger
	end
end

return selectHunger
