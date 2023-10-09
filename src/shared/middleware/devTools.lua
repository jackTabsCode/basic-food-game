local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Sift = require(ReplicatedStorage.Packages.Sift)

local event = ReplicatedStorage:FindFirstChild("REFLEX_DEVTOOLS") :: RemoteEvent?

function devToolsMiddleware(nextDispatch, store)
	return function(action)
		local result = nextDispatch(action)
		if RunService:IsStudio() and event then
			local tab = {
				name = action.type,
				args = Sift.Dictionary.values(Sift.Dictionary.filter(action, function(_, key)
					return key ~= "type"
				end)),
				state = store:getState(),
			}
			event:FireServer(tab)
		end
		return result
	end
end

return devToolsMiddleware
