local ReplicatedStorage = game:GetService("ReplicatedStorage")

local React = require(ReplicatedStorage.Packages.React)
local ReactRodux = require(ReplicatedStorage.Packages.ReactRodux)
local e = React.createElement

local hungerSelectors = require(ReplicatedStorage.shared.selectors.hunger)

function Hunger()
	local hunger = ReactRodux.useSelector(hungerSelectors.selectLocalHunger)

	return e("TextLabel", {
		AutomaticSize = Enum.AutomaticSize.XY,
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.fromScale(0, 1),
		Text = `Hunger: {hunger}%`,
		TextSize = 36,
	})
end

return Hunger
