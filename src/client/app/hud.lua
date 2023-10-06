local ReplicatedStorage = game:GetService("ReplicatedStorage")

local React = require(ReplicatedStorage.Packages.React)
local ReactRodux = require(ReplicatedStorage.Packages.ReactRodux)
local e = React.createElement

local selectLocalHunger = require(script.Parent.Parent.selectors.hunger)

function Hud()
	local hunger = ReactRodux.useSelector(selectLocalHunger)

	return e("ScreenGui", {}, {
		e("TextLabel", {
			AutomaticSize = Enum.AutomaticSize.XY,
			Position = UDim2.fromScale(0.5, 0.5),
			Text = tostring(hunger),
			TextSize = 48,
		}),
	})
end

return Hud
