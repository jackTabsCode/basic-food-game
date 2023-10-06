export type Character = {
	hunger: number,
}

export type CharacterState = { [string]: Character }

export type PlayersState = {
	character: CharacterState,
}

export type CommonState = {
	players: PlayersState,
}

return {}
