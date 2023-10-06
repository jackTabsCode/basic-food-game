local ReplicatedStorage = game:GetService("ReplicatedStorage")

local store = require(script.Parent:WaitForChild("store"))
local event = ReplicatedStorage.shared.events.dispatchAction

event.OnClientEvent:Connect(function(action)
	store:dispatch(action)
end)
