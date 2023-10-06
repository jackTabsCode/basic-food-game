export type HungerRegeneratedAction = {
	type: "character/hungerRegenerated",
	username: string,
	amount: number,
}

export type HungerDepletedAction = {
	type: "character/hungerDepleted",
	username: string,
}

export type PlayerJoinedAction = {
	type: "players/joined",
	username: string,
}

export type PlayerLeftAction = {
	type: "players/left",
	username: string,
}

return {}
