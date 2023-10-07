local FoodTypes = require(script.Parent.food)

export type HungerDepletedAction = {
	type: "character/hungerDepleted",
	username: string,
}

export type FoodAddedAction = {
	type: "inventory/foodAdded",
	username: string,
	foodType: FoodTypes.FoodType,
}
export type FoodConsumedAction = {
	type: "inventory/foodConsumed",
	username: string,
	foodType: FoodTypes.FoodType,
}

export type FoodEquippedAction = {
	type: "inventory/foodEquipped",
	username: string,
	foodType: FoodTypes.FoodType,
}
export type FoodUnequippedAction = {
	type: "inventory/foodUnequipped",
	username: string,
	foodType: FoodTypes.FoodType,
}

export type PlayerJoinedAction = {
	type: "players/joined",
	username: string,
}
export type PlayerLeftAction = {
	type: "players/left",
	username: string,
}

export type CharacterSpawnedAction = {
	type: "character/spawned",
	username: string,
}
export type CharacterDiedAction = {
	type: "character/died",
	username: string,
}

return {}
