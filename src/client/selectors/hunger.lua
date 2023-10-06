local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local SharedState = require(ReplicatedStorage.shared.types.state)

local selectHunger = require(ReplicatedStorage.shared.selectors.hunger)

function selectLocalHunger(state: SharedState.CommonState)
	return selectHunger(Players.LocalPlayer.Name)(state)
end

return selectLocalHunger
