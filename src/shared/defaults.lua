local ReplicatedStorage = game:GetService("ReplicatedStorage")

local SharedState = require(ReplicatedStorage.shared.types.state)

local character: SharedState.Character = {
	hunger = 100,
}

return {
	character = character,
}
