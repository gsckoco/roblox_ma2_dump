local module = {}

local Libraries = script.Parent.Parent:WaitForChild("Libraries")
local Fixture = require(Libraries.System:FindFirstChild("Fixture"))
local DMX = require(Libraries.System:FindFirstChild("DMXOutput"))
local Profiles = script.Parent.Parent.Profiles
local Desk = script.Parent.Parent.Desk.Value
local Services = require(Libraries.ServiceHandler)

local debug_Mode = false

local function dPrint(...)
	if debug_Mode then print(...) end
end

local self = {}

self.patch = {}
self.selection = {}
self.selectionCache = {}
self.selectedAttributesCache = {}
--


local function isInTable(tbl, value)
	for k, v in pairs(tbl) do
		if value == v then
			return true
		end
	end
	return false
end

function module.Start()
	-- On Service start
	module.RDMPatch(game.ServerScriptService.RDM:WaitForChild("RDM1").Value) -- In future move this into some settings page and not have it automatic.
	module.GetAllAttributes()
	-- Bind all events
	Desk.Events.Patch.SelectFixture.OnServerEvent:Connect(function(player, fixture, instance)
		module.Select(fixture, instance)
		module.UpdateClientSelection()
	end)
	
	Desk.Events.Patch.UpdateValue.OnServerEvent:Connect(function(player, attribute, value)
		for i=1, #self.selectionCache do
			local v = self.selectionCache[i]
			v.object.incrementValue(attribute, value)
		end
		Desk.Events.Patch.UpdateValue:FireAllClients(module.GetValuesForAttributes())
	end)
	
	Desk.Events.Patch.GetPatch.OnServerInvoke = function()
		return self.patch
	end
	
	Desk.Events.Patch.GetSelection.OnServerInvoke = function()
		return self.selection
	end
	
	Desk.Events.Patch.GetSelectedAttributes.OnServerInvoke = function()
		return module.GetAttributesFromSelection()
	end
	
	Desk.Events.Patch.GetAllAttributes.OnServerInvoke = function()
		return module.GetAllAttributes()
	end
	
end

function module.UpdateClientSelection()
	Desk.Events.Patch.SelectFixture:FireAllClients(self.selection, module.GetAttributesFromSelection())
	Desk.Events.Patch.UpdateValue:FireAllClients(module.GetValuesForAttributes())
end

function module.GetValuesForAttributes()
	local values = {}
	for k, v in pairs(self.selectedAttributesCache) do
		if values[k] == nil then
			values[k] = {}
		end
		for _, attribute in pairs(v) do
			for _, instance in pairs(self.selectionCache) do
				if instance.object.map[attribute] then
					if values[k][attribute] == nil then
						values[k][attribute] = instance.object.map[attribute].__value
					end
					if values[k][attribute] > instance.object.map[attribute].__value then
						values[k][attribute] = instance.object.map[attribute].__value
					end
				end
			end
		end
	end
	
	return values
end

function module.GetAllAttributes()
	local capabilities = {}
	
	for _, v in pairs(self.patch) do
		local fixturePersonality = require(script.Parent.Parent.Profiles:FindFirstChild(v.fixtureType):FindFirstChild(v.fixtureMode))
		for _, module in pairs(fixturePersonality.modules) do
			for _, attribute in pairs(module.attributes) do
				if attribute.attType == "SHUTTER/MAINTENANCE" then
					continue
				end
				if not capabilities[attribute.attType] then
					capabilities[attribute.attType] = {}
				end
				if not isInTable(capabilities[attribute.attType], attribute.attribute) then
					table.insert(capabilities[attribute.attType], attribute.attribute)
				end
			end
		end
	end
	
	return capabilities
end

function module.GetAttributesFromSelection()
	local selection = module.GetSelection(true)
	
	local capabilities = {}
	
	for _, v in pairs(selection) do
		for _, attribute in pairs(v.object.attributes) do
			if attribute.attType == "SHUTTER/MAINTENANCE" then
				continue
			end
			if not capabilities[attribute.attType] then
				capabilities[attribute.attType] = {}
			end
			if not isInTable(capabilities[attribute.attType], attribute.attribute) then
				table.insert(capabilities[attribute.attType], attribute.attribute)
			end
		end
	end
	self.selectedAttributesCache = capabilities
	return capabilities
end

function module.GetSelection(fixtureObject)
	if fixtureObject then
		local selection = {}
		for _, v in pairs(self.selection) do
			local id = string.split(v, ".")
			table.insert(selection, { fixture = tonumber(id[1]), instance = tonumber(id[2]), object = self.patch[tonumber(id[1])]:getInstance(tonumber(id[2])) } )
		end
		return selection
	end
	
	return self.selection
end

function module.GetFixtures()
	return self.patch
end

function module.GetInstance(fId, instanceId)
	local selection = {}
	local f = self.patch[fId]
	if f then
		if instanceId == 0 then
			for _, v in pairs(f:getInstances()) do
				table.insert(v, selection)
			end
		else
			table.insert(selection, f:getInstance(instanceId))
		end
	end
	
	return selection
end

function module.Select(fixture, instance, selected)
	local instance = instance or 1
	
	if selected ~= nil then
		print(fixture .. "." .. instance, selected)
		if selected == true then
			if not isInTable(self.selection, fixture .. "." .. instance) then
				table.insert(self.selection, fixture .. "." .. instance)
			end
		else
			for k, v in pairs(self.selection) do
				if v == fixture .. "." .. instance then
					table.remove(self.selection, k)
					self.selectionCache = module.GetSelection(true)
					return
				end
			end
		end
		
		self.selectionCache = module.GetSelection(true)
		
		return
	end
	
	for k, v in pairs(self.selection) do
		if v == fixture .. "." .. instance then
			table.remove(self.selection, k)
			self.selectionCache = module.GetSelection(true)
			return
		end
	end
	table.insert(self.selection, fixture .. "." .. instance)
	self.selectionCache = module.GetSelection(true)
end

function module.RDMPatch(RDMServer)
	local RDMPatch = {}
	local rdmFixtures = RDMServer.RDM.GetFixtures:Invoke()
	for _, v in pairs(rdmFixtures) do
		-- startAddress, universe, fixtureType, fixtureMode
		local universe = DMX.getUniverseFromOutput(v[2])
		if universe then
			local fixture = Profiles:FindFirstChild(v[3])
			if fixture and fixture:FindFirstChild(v[4]) then
				local newFx = Fixture.new({Universe = universe, Address = v[1]}, require(fixture:FindFirstChild(v[4])), v[3])
				newFx.fixtureType = v[3]
				newFx.fixtureMode = v[4]
				
				dPrint("Patched: ", unpack(v))
				table.insert(self.patch, newFx)
			end
		end
	end
end

return module
