local ReplicatedStorage = game:GetService("ReplicatedStorage")

local React = require(ReplicatedStorage.Packages.React)
local ReactRodux = require(ReplicatedStorage.Packages.ReactRodux)
local e = React.createElement

local hungerSelectors = require(script.Parent.Parent.selectors.hunger)

function Hud()
	local hunger = ReactRodux.useSelector(hungerSelectors.selectLocalHunger)

	return e("ScreenGui", {
		ResetOnSpawn = false,
		IgnoreGuiInset = true,
	}, {
		TextLabel = e("TextLabel", {
			AutomaticSize = Enum.AutomaticSize.XY,
			Position = UDim2.fromScale(0.5, 0.5),
			Text = tostring(hunger),
			TextSize = 48,
		}),
	})
end

return Hud
