local DMX = {
	Universes = {};
	Outputs = {}
}

function DMX.newUniverse(id, output)
	local universe = {Output = output, Values = nil, __values = {}, id = id}
	universe.Values = setmetatable({},{__newindex = function(tbl, index, value)
		if universe.Output ~= nil and universe.Output:IsA("Model") then
			universe.__values[index] = value
			universe.Output:FindFirstChild("Byte".. string.format("%03d",index)).Value = value
		end
	end})
	for i=1,512 do
		universe.Values[i] = 0
		universe.__values[i] = 0
	end
	if id == nil then
		table.insert(DMX.Universes, universe)
	else
		DMX.Universes[id] = universe
	end
end

function DMX.setChannelValue(id, address, value)
	DMX.Universes[id].Values[address] = value
end

function DMX.getOutputs()
	DMX.Outputs = {}
	for _, v in pairs(script.Parent.Parent.Parent.DMXOutput:GetChildren()) do
		table.insert(DMX.Outputs, v.Value)
	end
	return DMX.Outputs
end

function DMX.getUniverseFromOutput(output)
	for _, v in pairs(DMX.Universes) do
		if v.Output == output then
			return v
		end
	end
end

function DMX.setOutput(id, output)
	DMX.Universes[id] = game.ReplicatedStorage.Network:FindFirstChild(output)
end

return DMX