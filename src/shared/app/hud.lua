local ReplicatedStorage = game:GetService("ReplicatedStorage")

local React = require(ReplicatedStorage.Packages.React)
local e = React.createElement

local Hunger = require(script.Parent.hunger)

function Hud()
	return e("ScreenGui", {
		ResetOnSpawn = false,
		IgnoreGuiInset = true,
	}, {
		Hunger = e(Hunger),
	})
end

return Hud
