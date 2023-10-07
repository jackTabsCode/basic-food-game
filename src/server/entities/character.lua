local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local FoodTypes = require(ReplicatedStorage.shared.types.food)
local foodSettings = require(ReplicatedStorage.shared.settings.food)

local pickupFoodEvent = ReplicatedStorage.shared.events.pickupFood
local consumeFoodEvent = ReplicatedStorage.shared.events.consumeFood
local equipFoodEvent = ReplicatedStorage.shared.events.equipFood
local unequipFoodEvent = ReplicatedStorage.shared.events.unequipFood

local Maid = require(ReplicatedStorage.Packages.Maid)
local t = require(ReplicatedStorage.Packages.t)

local store = require(script.Parent.Parent.store)
local selectHunger = require(ReplicatedStorage.shared.selectors.hunger).selectHunger
local selectInventory = require(ReplicatedStorage.shared.selectors.inventory).selectInventory

local CharacterEntity = {}
CharacterEntity.__index = CharacterEntity

function CharacterEntity.new(host: Player, model: Model, onDied: () -> nil)
	local self = setmetatable({}, CharacterEntity)

	self.host = host
	self.model = model

	self.humanoid = model:WaitForChild("Humanoid", 10) :: Humanoid | nil
	self.rootPart = model:WaitForChild("HumanoidRootPart", 10) :: BasePart | nil
	if not self.humanoid then
		error(`CharacterEntity could not validate {model.Name}`, 2)
	end

	self.tools = {}

	self.maid = Maid.new()

	self.maid:giveTask(self.humanoid.Died:Connect(onDied))

	self.maid:giveTask(RunService.Heartbeat:Connect(function()
		self:Heartbeat()
	end))

	self.maid:giveTask(pickupFoodEvent.OnServerEvent:Connect(function(player, food)
		if player.Name ~= self.host.Name or not t.instanceIsA("BasePart")(food) or not food:HasTag("food") then
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
			username = self.host.Name,
			foodType = foodType,
		})
	end))

	self.maid:giveTask(consumeFoodEvent.OnServerEvent:Connect(function(player, foodType)
		if player.Name ~= self.host.Name or not t.keyOf(foodSettings)(foodType) then
			return
		end

		local inventory = selectInventory(player.Name)(store:getState())
		local food = inventory[foodType]
		if food.amount <= 0 or not food.equipped then
			return
		end

		store:dispatch({
			type = "inventory/foodConsumed",
			username = self.host.Name,
			foodType = foodType,
		})
	end))

	self.maid:giveTask(equipFoodEvent.OnServerEvent:Connect(function(player, foodType)
		if player.Name ~= self.host.Name or not t.keyOf(foodSettings)(foodType) then
			return
		end

		local inventory = selectInventory(player.Name)(store:getState())
		local food = inventory[foodType]
		if food.amount <= 0 or food.equipped then
			return
		end

		store:dispatch({
			type = "inventory/foodEquipped",
			username = self.host.Name,
			foodType = foodType,
		})
	end))

	self.maid:giveTask(unequipFoodEvent.OnServerEvent:Connect(function(player, foodType)
		if player.Name ~= self.host.Name or not t.keyOf(foodSettings)(foodType) then
			return
		end

		local inventory = selectInventory(player.Name)(store:getState())
		local food = inventory[foodType]
		if food.amount <= 0 or not food.equipped then
			return
		end

		store:dispatch({
			type = "inventory/foodUnequipped",
			username = self.host.Name,
			foodType = foodType,
		})
	end))

	self.maid:giveTask(store.changed:connect(function(newState, oldState)
		local newHunger = selectHunger(self.host.Name)(newState)
		local oldHunger = selectHunger(self.host.Name)(oldState)

		if newHunger ~= oldHunger then
			self:HungerChanged(newHunger)
		end

		local newInventory = selectInventory(self.host.Name)(newState)
		local oldInventory = selectInventory(self.host.Name)(oldState)

		for foodType, food in pairs(newInventory) do
			local newAmount = food.amount
			local oldAmount = oldInventory[foodType] and oldInventory[foodType].amount or 0

			local newEquipped = food.equipped
			local oldEquipped = oldInventory[foodType] and oldInventory[foodType].equipped or false

			if newAmount > oldAmount and oldAmount == 0 then
				self:CreateTool(foodType)
			elseif newAmount < oldAmount and newAmount == 0 then
				self:DestroyTool(foodType)
			end

			if newEquipped and not oldEquipped then
				self.humanoid:EquipTool(self.tools[foodType])
			elseif not newEquipped and oldEquipped then
				self.humanoid:UnequipTools()
			end
		end
	end))

	self.lastHungerDeplete = os.clock()

	store:dispatch({
		type = "character/spawned",
		username = self.host.Name,
	})

	return self
end

function CharacterEntity:CreateTool(foodType: FoodTypes.FoodType)
	local tool = Instance.new("Tool")
	tool.ManualActivationOnly = true
	tool.CanBeDropped = false
	tool.Name = foodType

	local foodPart = ReplicatedStorage.food[foodType]:Clone()
	foodPart.Parent = tool
	foodPart.Name = "Handle"

	tool.Parent = self.host.Backpack
	self.tools[foodType] = tool
end

function CharacterEntity:DestroyTool(foodType: FoodTypes.FoodType)
	local tool = self.host.Backpack:FindFirstChild(foodType)
	if tool then
		tool:Destroy()
		self.tools[foodType] = nil
	end
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
		username = self.host.Name,
	})
end

function CharacterEntity:Destroy()
	self.maid:destroy()

	store:dispatch({
		type = "character/died",
		username = self.host.Name,
	})
end

return CharacterEntity
