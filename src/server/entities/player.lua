local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Maid = require(ReplicatedStorage.Packages.Maid)

local store = require(script.Parent.Parent.store)

local CharacterEntity = require(script.Parent.character)

local PlayerEntity = {}
PlayerEntity.__index = PlayerEntity

function PlayerEntity.new(player: Player)
	local self = setmetatable({}, PlayerEntity)

	self.player = player
	self.maid = Maid.new()

	self.maid:giveTask(player.CharacterAdded:Connect(function(model)
		self.character = CharacterEntity.new(player, model, function()
			self:CharacterDied()
		end)
	end))

	store:dispatch({
		type = "players/joined",
		username = player.Name,
	})

	return self
end

function PlayerEntity:CharacterDied()
	if self.character then
		self.character:Destroy()
		self.character = nil
	end
end

function PlayerEntity:Destroy()
	self.maid:destroy()

	store:dispatch({
		type = "players/left",
		username = self.player.Name,
	})
end

return PlayerEntity
