local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Rodux = require(ReplicatedStorage.Packages.Rodux)

local playersReducer = Rodux.combineReducers({
	character = require(script.character),
	inventory = require(script.inventory),
})

return playersReducer
