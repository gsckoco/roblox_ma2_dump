local module = {}

local Libraries = script.Parent.Parent.Libraries


local services = require(Libraries.ServiceHandler)

local Desk = script.Parent.Parent.Desk.Value

local logHistory = {}

function module.Start()
	-- On Service start
	Desk.Events.System.SendLog.OnServerEvent:Connect(function(plr,scriptName,logMessage)
		local message = scriptName.." ---> "..logMessage
		table.insert(logHistory,message)
		print(message)
	end)
	function Desk.Events.System.GetLogs.OnServerInvoke()
		return logHistory
	end
end

return module
