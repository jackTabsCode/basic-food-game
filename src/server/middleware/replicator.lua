local ReplicatedStorage = game:GetService("ReplicatedStorage")

local event = ReplicatedStorage.shared.events.dispatchAction

function replicatorMiddleware(nextDispatch)
	return function(action)
		local result = nextDispatch(action)
		event:FireAllClients(action)
		return result
	end
end

return replicatorMiddleware
