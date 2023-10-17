local ReplicatedStorage = game:GetService("ReplicatedStorage")

local SharedState = require(ReplicatedStorage.shared.types.state)

local roselect = require(ReplicatedStorage.shared.vendor.roselect)
local selectCharacter = require(script.Parent.character).selectCharacter

function selectPlayer(name: string)
	return roselect.createSelector(selectCharacter(name), function(character: SharedState.Character)
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
