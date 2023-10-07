local ReplicatedStorage = game:GetService("ReplicatedStorage")

local React = require(ReplicatedStorage.Packages.React)
local e = React.createElement

local FoodTypes = require(ReplicatedStorage.shared.types.food)
local foodSettings = require(ReplicatedStorage.shared.settings.food)

local consumeFoodEvent = ReplicatedStorage.shared.events.consumeFood

type Props = {
	foodType: FoodTypes.FoodType,
	amount: number,
}

function Food(props: Props)
	local settings = foodSettings[props.foodType]

	return e("TextButton", {
		Size = UDim2.fromOffset(0, 50),
		AutomaticSize = Enum.AutomaticSize.X,
		Text = `{settings.displayName} ({props.amount})`,
		TextSize = 18,
		TextWrapped = true,
		Visible = props.amount > 0,
		[React.Event.Activated] = function()
			consumeFoodEvent:FireServer(props.foodType)
		end,
	})
end

return Food
