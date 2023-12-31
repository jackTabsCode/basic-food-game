local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Rodux = require(ReplicatedStorage.Packages.Rodux)

local sharedReducers = require(ReplicatedStorage.shared.reducers)

local clientReducers = Rodux.combineReducers(sharedReducers)

local store = Rodux.Store.new(clientReducers, nil, {
	require(ReplicatedStorage.shared.middleware.logger),
	require(ReplicatedStorage.shared.middleware.devTools),
})

return store
