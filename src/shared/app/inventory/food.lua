local ContextActionService = game:GetService("ContextActionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local React = require(ReplicatedStorage.Packages.React)
local e = React.createElement

local FoodTypes = require(ReplicatedStorage.shared.types.food)
local foodSettings = require(ReplicatedStorage.shared.settings.food)

local equipFoodEvent = ReplicatedStorage.shared.events.equipFood
local unequipFoodEvent = ReplicatedStorage.shared.events.unequipFood
local consumeFoodEvent = ReplicatedStorage.shared.events.consumeFood

type Props = {
	foodType: FoodTypes.FoodType,
	amount: number,
	equipped: boolean,
}

function Food(props: Props)
	local settings = foodSettings[props.foodType]

	React.useEffect(function()
		if props.equipped then
			ContextActionService:BindAction("consume", function(_, inputState)
				if inputState == Enum.UserInputState.Begin then
					consumeFoodEvent:FireServer(props.foodType)
				end
			end, false, Enum.UserInputType.MouseButton1)
		end

		return function()
			ContextActionService:UnbindAction("consume")
		end
	end, { props.equipped })

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
