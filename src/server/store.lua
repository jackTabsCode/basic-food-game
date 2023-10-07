local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Rodux = require(ReplicatedStorage.Packages.Rodux)

local sharedReducers = require(ReplicatedStorage.shared.reducers)

local serverReducers = Rodux.combineReducers(sharedReducers)

local store = Rodux.Store.new(serverReducers, nil, {
	--require(ReplicatedStorage.shared.middleware.logger),
	require(script.Parent.middleware.replicator),
})

return store
