local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local React = require(ReplicatedStorage.Packages.React)
local store = require(script.Parent:WaitForChild("store"))
local e = React.createElement

local ReactRodux = require(ReplicatedStorage.Packages.ReactRodux)

local Hud = require(script.hud)

function App()
	return e(ReactRodux.Provider, {
		store = store,
	}, {
		Hud = e(Hud),
	})
end

return App
