local ReplicatedStorage = game:GetService("ReplicatedStorage")

local React = require(ReplicatedStorage.Packages.React)
local ReactRodux = require(ReplicatedStorage.Packages.ReactRodux)
local Sift = require(ReplicatedStorage.Packages.Sift)
local e = React.createElement

local inventorySelectors = require(ReplicatedStorage.shared.selectors.inventory)

local Food = require(script.food)

function Inventory()
	local inventory = ReactRodux.useSelector(inventorySelectors.selectLocalInventory)

	local food = Sift.Dictionary.map(inventory, function(amount, foodType)
		return e(Food, { foodType = foodType, amount = amount })
	end)

	return e("Frame", {
		AutomaticSize = Enum.AutomaticSize.XY,
		AnchorPoint = Vector2.new(0.5, 1),
		Position = UDim2.fromScale(0.5, 1),
		BackgroundTransparency = 1,
	}, {
		Layout = e("UIListLayout", {
			Padding = UDim.new(0, 10),
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			FillDirection = Enum.FillDirection.Horizontal,
		}),
		e(React.Fragment, nil, food),
	})
end

return Inventory
