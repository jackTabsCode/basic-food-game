local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local store = require(script.Parent.store)

local selectPlayer = require(ReplicatedStorage.shared.selectors.player).selectPlayer

local PlayerEntity = require(script.Parent.entities.player)
local entities: { [string]: typeof(PlayerEntity) } = {}

function playerAdded(player: Player)
	entities[player.Name] = PlayerEntity.new(player)
end

function playerRemoving(player: Player)
	local entity = entities[player.Name]
	if entity then
		entity:Destroy()
		entities[player.Name] = nil
	end
end

Players.PlayerAdded:Connect(playerAdded)
Players.PlayerRemoving:Connect(playerRemoving)

for _, player in pairs(Players:GetPlayers()) do
	local state = store:getState()
	local playerExists = selectPlayer(player.Name)(state)

	if not playerExists then
		playerAdded(player)
	end
end
