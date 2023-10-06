local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Rodux = require(ReplicatedStorage.Packages.Rodux)

local commonReducers = {
	players = require(script.players),
}

return commonReducers
