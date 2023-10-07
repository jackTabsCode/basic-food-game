local ReplicatedStorage = game:GetService("ReplicatedStorage")

local React = require(ReplicatedStorage.Packages.React)
local e = React.createElement

local Hunger = require(script.Parent.hunger)
local Inventory = require(script.Parent.inventory)

function Hud()
	return e("ScreenGui", {
		ResetOnSpawn = false,
		IgnoreGuiInset = true,
	}, {
		Hunger = e(Hunger),
		Inventory = e(Inventory),
	})
end

return Hud
