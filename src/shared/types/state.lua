export type CharacterState = { [string]: {
	hunger: number,
} }

export type PlayersState = {
	character: CharacterState,
}

export type CommonState = {
	players: PlayersState,
}

return {}
