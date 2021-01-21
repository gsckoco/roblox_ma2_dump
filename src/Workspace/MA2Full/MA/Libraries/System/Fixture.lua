local fixture = {}
fixture.__index = fixture

function copy(inTable, outTable) -- Not deep copy
	for k,v in pairs(inTable) do
		outTable[k] = v
	end
	return outTable
end

function decimalToMsbLsb(value) -- Value is 0 - 1
	local byte2 = bit32.extract(65535*value,0,16)
	local msb = bit32.extract(byte2,8,16)
	local lsb = bit32.extract(byte2,0,8)
	return msb, lsb
end

function msbLsbToDecimal(msb,lsb)
	local value = bit32.lshift(msb,8)
	value = bit32.replace(value,lsb,0,8)
	return value
end

function toByte(value, min, max)
	local dif = max-min
	local val = value-min
	
	return val/dif
end
-- patch = {Universe: Table, Address: Int}
function fixture.new(patch, personality, name)
	local newFixture = setmetatable({}, fixture)
	newFixture.person = personality
	newFixture.name = name
	newFixture.instances = {}
	newFixture.__type = "fixture"
	for _,instance in pairs(personality.instances) do
		local module = newFixture.person.modules[instance.moduleType]
		local newInstance = {name=instance.name, attributes = {}, map = {}}
		newInstance.name = instance.moduleType
		newInstance.__type = "instance"
		
		function newInstance.setValue(attribute, value)
			if newInstance.map[attribute] then
				newInstance.map[attribute].value = value
				--print(attribute, value, patch.Universe.id, patch.Address)
			end
		end
		
		function newInstance.incrementValue(attribute, value)
			if newInstance.map[attribute] then
				newInstance.map[attribute].value = newInstance.map[attribute].__value + value
			end
		end
		
		function newInstance.getValue(attribute)
			return newInstance.map[attribute] and newInstance.map[attribute].value or 0
		end
		
		for _,attribute in pairs(module.attributes) do
			local newAttribute = setmetatable(copy(attribute, {__value = 0}),{__newindex = function(tbl, index, value)
				if index == "value" then
					local value = value >= attribute.max and attribute.max or value <= attribute.min and attribute.min or value
					if tbl.fine then
						local msb, lsb = decimalToMsbLsb(toByte(value, attribute.min or 0, attribute.max or 255))
						patch.Universe.Values[(patch.Address-1) + tbl.coarse] = math.floor(msb)
						patch.Universe.Values[(patch.Address-1) + tbl.fine] = math.floor(lsb)
					else
						patch.Universe.Values[(patch.Address-1) + tbl.coarse] = math.floor(toByte(value, attribute.min or 0, attribute.max or 255)*255)
					end
					tbl.__value = value
					return tbl.__value
				else
					return
				end
			end})
			
			if newAttribute.fine then
				newAttribute.fine = newAttribute.fine + (instance.patch-1)
			end
			newAttribute.coarse = newAttribute.coarse + (instance.patch-1)
			newAttribute.value = newAttribute.default or 0
			
			newInstance.map[newAttribute.attribute] = newAttribute
			
			table.insert(newInstance.attributes,newAttribute)
		end
		table.insert(newFixture.instances, newInstance)
	end
	return newFixture
end

--- Set value of attribute in a certain instance.
-- @param instance Defaults to 1. Selects a certain instance to change attribute values off. <Int>
-- @param attribute Selects attribute of same name. <String>
-- @param value The desired value you want to set. <Number>
function fixture:setValue(instance, attribute, value)
	instance = instance~= nil and instance or 1
	for i=1,#self.instances[instance].attributes do
		local att = self.instances[instance].attributes[i]
		if att.attribute == attribute then
			att.value = value
			break
		end
	end
end

--- Set value of attribute at index.
-- @param instance Defaults to 1. Selects a certain instance to change attribute values off. <Int>
-- @param index Selects attribute at index. <Int>
-- @param value The desired value you want to set. <Number>
function fixture:setValueByAttributeIndex(instance, index, value)
	instance = instance~= nil and instance or 1
	self.instances[instance].attributes[index].value = value
end

--- Get all possible capabilties of attribute if multi-option attribute (e.g. Colour wheels, shutters) at index
-- @param instance Defaults to 1. Selects a certain instance to change attribute values off. <Int>
-- @param index Selects attribute at index. <Int>
function fixture:getCapabilities(instance, index)
	instance = instance~= nil and instance or 1
	if type(self.instances[instance].attributes[index].attribute) == "table" then
		return self.instances[instance].attributes[index].attribute
	end
	return nil
end

--- Returns the instance object.
-- @param instance Defaults to 1. Selects a certain instance to change attribute values off. <Int>
function fixture:getInstance(instance)
	instance = instance~= nil and instance or 1
	return self.instances[instance] or self.instances[1]
end

--- Returns all instance objects.
function fixture:getInstances()
	return self.instances
end




return fixture


