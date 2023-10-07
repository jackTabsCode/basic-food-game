local FoodTypes = require(script.Parent.food)

export type Character = {
	hunger: number,
}

export type Inventory = {
	[FoodTypes.FoodType]: {
		amount: number,
		equipped: boolean,
	},
}

export type CharacterState = { [string]: Character }
export type InventoryState = { [string]: Inventory }

export type PlayersState = {
	character: CharacterState,
	inventory: InventoryState,
}

export type CommonState = {
	players: PlayersState,
}

return {}
