local Players = game:GetService("Players")
local store = require(script.Parent.store)

print(store:getState())

Players.PlayerAdded:Connect(function(player)
	store:dispatch({
		type = "players/joined",
		username = player.Name,
	})
end)
