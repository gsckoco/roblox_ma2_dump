local module = {}

module.services = {}

function module.startService(service)
	if module.services[service.Name] then return end
	local ok, err = pcall(function()
		local loadedService = require(service)
		loadedService.Start()
		module.services[service.Name] = loadedService
	end)
	if not ok then
		print(err)
	else
		print("Successfully loaded " .. service.Name)
	end
end

function module.getService(serviceName) 
	return module.services[serviceName]
end

return module
