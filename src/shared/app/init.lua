local ReplicatedStorage = game:GetService("ReplicatedStorage")

local React = require(ReplicatedStorage.Packages.React)
local e = React.createElement

local ReactRodux = require(ReplicatedStorage.Packages.ReactRodux)

local Hud = require(script.hud)

function App(props: { store: any })
	return e(ReactRodux.Provider, {
		store = props.store,
	}, {
		Hud = e(Hud),
	})
end

return App
