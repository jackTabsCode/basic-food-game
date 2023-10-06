function loggerMiddleware(nextDispatch, store)
	return function(action)
		local result = nextDispatch(action)
		print("action dispatched", action)
		print("new state", store:getState())
		return result
	end
end

return loggerMiddleware
