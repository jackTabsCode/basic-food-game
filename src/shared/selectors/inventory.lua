local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local SharedState = require(ReplicatedStorage.shared.types.state)

function selectInventory(name: string)
	return function(state: SharedState.CommonState)
		local inventory = state.players.inventory[name]
		return inventory or {}
	end
end

function selectLocalInventory(state: SharedState.CommonState)
	return selectInventory(Players.LocalPlayer.Name)(state)
end

return {
	selectInventory = selectInventory,
	selectLocalInventory = selectLocalInventory,
}
