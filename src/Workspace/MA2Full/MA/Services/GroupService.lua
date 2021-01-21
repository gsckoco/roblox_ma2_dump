local module = {}

local Libraries = script.Parent.Parent.Libraries

local groups = {}

local services = require(Libraries.ServiceHandler)
local patchService = services.getService("PatchService")
local Desk = script.Parent.Parent.Desk.Value

function module.Start()
	-- On Service start
	Desk.Events.Pools.Groups.SelectGroup.OnServerEvent:Connect(function(p, groupId)
		groups[groupId].selected = not groups[groupId].selected
		module.SelectGroup(groupId)
		module.SendClientGroups()
	end)
	Desk.Events.Pools.Groups.GetGroups.OnServerEvent:Connect(function(p)
		module.SendClientGroups()
	end)
	Desk.Events.Pools.Groups.StoreGroup.OnServerEvent:Connect(function(p, groupId, groupName, groupColour)
		print("Crate group", groupId, groupName, groupColour)
		module.CreateGroup(groupId, groupName, groupColour)
	end)
end

function module.CreateGroup(groupId, groupName, groupColour, selection)
	if selection and type(selection) == "table" then
		-- Do nothing. Selection already provided
	else
		selection = patchService.GetSelection()
	end
	local newSelection = {}
	
	for _, v in pairs(selection) do
		table.insert(newSelection, v)
	end
	
	local newGroup = {
		groupId = groupId;
		groupName = groupName;
		groupColour = groupColour;
		selection = newSelection;
		
		selected = false;
	}
	
	groups[groupId] = newGroup
	
	module.SendClientGroups()
end

function module.SendClientGroups()
	local sortedGroups = {}
	
	for _, v in pairs(groups) do
		table.insert(sortedGroups, v)
	end
	
	Desk.Events.Pools.Groups.GetGroups:FireAllClients(sortedGroups)
end
--[[
function module.UpdateGroupSelection()
	--.Select(fixture, instance)
	local sortedGroups = {}
	
	for _, v in pairs(groups) do
		table.insert(sortedGroups, v)
	end
	
	table.sort(sortedGroups, function(a, b)
		return b.selected
	end)
	
	for _, v in pairs(sortedGroups) do
		--print(v.selected)
		for _, fixture in pairs(v.selection) do
			local id = string.split(fixture,".")
			patchService.Select(id[1], id[2], v.selected)
		end
		print(game:GetService("HttpService"):JSONEncode(v.selection))
	end
	
	patchService.UpdateClientSelection()
end
]]

function module.SelectGroup(groupId)
	local v = groups[groupId]
	for _, fixture in pairs(v.selection) do
		local id = string.split("" .. fixture, ".")
		patchService.Select(id[1], id[2], v.selected)
	end
	patchService.UpdateClientSelection()
end

return module
