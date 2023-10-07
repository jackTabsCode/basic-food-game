local ReplicatedStorage = game:GetService("ReplicatedStorage")

local React = require(ReplicatedStorage.Packages.React)
local e = React.createElement

local FoodTypes = require(ReplicatedStorage.shared.types.food)
local foodSettings = require(ReplicatedStorage.shared.settings.food)

local equipFoodEvent = ReplicatedStorage.shared.events.equipFood
local unequipFoodEvent = ReplicatedStorage.shared.events.unequipFood

type Props = {
	foodType: FoodTypes.FoodType,
	amount: number,
	equipped: boolean,
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
			if props.amount <= 0 then
				return
			end

			if props.equipped then
				unequipFoodEvent:FireServer(props.foodType)
			else
				equipFoodEvent:FireServer(props.foodType)
			end
		end,
	})
end

return Food
