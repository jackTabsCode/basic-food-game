local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local FoodTypes = require(ReplicatedStorage.shared.types.food)

local pickupFoodEvent = ReplicatedStorage.shared.events.pickupFood

local Maid = require(ReplicatedStorage.Packages.Maid)
local t = require(ReplicatedStorage.Packages.t)

local store = require(script.Parent.Parent.store)
local selectHunger = require(ReplicatedStorage.shared.selectors.hunger).selectHunger

local CharacterEntity = {}
CharacterEntity.__index = CharacterEntity

function CharacterEntity.new(model: Model, onDied: () -> nil)
	local self = setmetatable({}, CharacterEntity)

	self.model = model

	self.humanoid = model:WaitForChild("Humanoid", 10) :: Humanoid | nil
	self.rootPart = model:WaitForChild("HumanoidRootPart", 10) :: BasePart | nil
	if not self.humanoid then
		error(`CharacterEntity could not validate {model.Name}`, 2)
	end

	self.maid = Maid.new()

	self.maid:giveTask(self.humanoid.Died:Connect(onDied))

	self.maid:giveTask(RunService.Heartbeat:Connect(function()
		self:Heartbeat()
	end))
	self.maid:giveTask(pickupFoodEvent.OnServerEvent:Connect(function(player, food)
		if player.Name ~= self.model.Name or not t.instanceIsA("BasePart")(food) or not food:HasTag("food") then
			return
		end

		local foodType = food.Name :: FoodTypes.FoodType

		local foodPos = food.Position
		local rootPos = self.rootPart.Position

		if (foodPos - rootPos).Magnitude > 10 then
			return
		end

		food:Destroy()

		store:dispatch({
			type = "inventory/foodAdded",
			username = self.model.Name,
			foodType = foodType,
		})
	end))

	self.maid:giveTask(store.changed:connect(function(newState, oldState)
		local newHunger = selectHunger(self.model.Name)(newState)
		local oldHunger = selectHunger(self.model.Name)(oldState)

		if newHunger ~= oldHunger then
			self:HungerChanged(newHunger)
		end
	end))

	self.lastHungerDeplete = os.clock()

	store:dispatch({
		type = "character/spawned",
		username = self.model.Name,
	})

	return self
end

function CharacterEntity:HungerChanged(hunger: number)
	if hunger <= 0 then
		self.humanoid:TakeDamage(100)
	end
end

function CharacterEntity:Heartbeat()
	if not self.model or os.clock() - self.lastHungerDeplete < 1 then
		return
	end

	self.lastHungerDeplete = os.clock()

	store:dispatch({
		type = "character/hungerDepleted",
		username = self.model.Name,
	})
end

function CharacterEntity:Destroy()
	self.maid:destroy()

	store:dispatch({
		type = "character/died",
		username = self.model.Name,
	})
end

return CharacterEntity
