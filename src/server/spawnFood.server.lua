local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local Sift = require(ReplicatedStorage.Packages.Sift)
local foodSettings = require(ReplicatedStorage.shared.settings.food)

local baseplate = Workspace.Baseplate

local foodTypes = Sift.Dictionary.keys(foodSettings)

function spawnFood()
	local foodType = foodTypes[math.random(1, #foodTypes)]
	local settings = foodSettings[foodType]

	local part = ReplicatedStorage.food[foodType]:Clone() :: BasePart

	local location = baseplate.Position
		+ Vector3.new(
			math.random(-baseplate.Size.X / 2, baseplate.Size.X / 2),
			15,
			math.random(-baseplate.Size.Z / 2, baseplate.Size.Z / 2)
		)

	part.CFrame = CFrame.new(location)

	local proximityPrompt = Instance.new("ProximityPrompt")
	proximityPrompt.ObjectText = settings.displayName
	proximityPrompt.ActionText = "Pick Up"
	proximityPrompt.Exclusivity = Enum.ProximityPromptExclusivity.OneGlobally
	proximityPrompt.Parent = part

	part:AddTag("food")

	part.Parent = Workspace
end

for _ = 1, 100 do
	spawnFood()
end
