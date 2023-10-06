local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Reflex = require(ReplicatedStorage.Packages.Reflex)
local SharedState = require(ReplicatedStorage.shared.types.state)

local selectCharacter = require(script.Parent.character).selectCharacter

function selectPlayer(name: string)
	return Reflex.createSelector(selectCharacter(name), function(character: SharedState.Character)
		if not character then
			return nil
		end
		return {
			character = character,
		}
	end)
end

return {
	selectPlayer = selectPlayer,
}
