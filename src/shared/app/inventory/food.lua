local ContextActionService = game:GetService("ContextActionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

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
		BackgroundColor3 = props.equipped and Color3.new(1, 1, 1) or Color3.fromRGB(163, 162, 165),
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
	}, {
		Tooltip = e("TextLabel", {
			Text = "Click to Use",
			BackgroundTransparency = 0.5,
			Position = UDim2.new(0.5, 0, 0, -20),
			AnchorPoint = Vector2.new(0.5, 1),
			Size = UDim2.fromOffset(0, 20),
			AutomaticSize = Enum.AutomaticSize.X,
			Visible = props.equipped,
			TextSize = 14,
		}),
	})
end

return Food
