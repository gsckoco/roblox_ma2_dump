local module = {}

local Libraries = script.Parent.Parent.Libraries
local Effect, EffectInformation, EffectRunner = unpack(require(Libraries:FindFirstChild("Effects")))
local Desk = script.Parent.Parent.Desk.Value

local self = {runner = nil}

function module.Start()
	-- On Service start
	self.runner = EffectRunner()
	
	Desk.Events.Pools.Effects.GetEffects.OnServerEvent:Connect(function(plr)
		print(self.runner.effects)
		print(self.runner.runningEffects)
		Desk.Events.Pools.Effects.GetEffects:FireAllClients("1", "2")	
	end)
	
	Desk.Events.Pools.Effects.CreateEffect.OnServerEvent:Connect(function(plr, effectId, data)
		print(game:GetService("HttpService"):JSONEncode(data))
		--[[
		[{"Wave":"Sine","Once":false,"Groups":"3","Attribute":"COLORYELLOW","Phase":["6","360"],"Close":"X","Blocks":"","Direction":"Forward","Wings":"2","Bpm":"6"}]
		]]
		--[[
		{
			attribute = "String"; -- Name of capability
			mode = "String"; -- Abs or Rel
			form = "String"; -- Name of function in effectWaves
			direction = "forward"; -- forward, backwards or bounce
			speed = 60.0; -- Speed in BPM
			low = 0;
			high = 100;
			
			groups = 0;
			wings = 0;
			blocks = 0;
		
			direction = 1; -- or -1
			phase = {0, 360}; -- From too
			width = 100; -- Percentage
			
			-- Running effect inserted stuff
			--formFunction = function;
			--dif = high - low;
		}
		
		[{
			"Wave":"Sine",
			"Groups":"0",
			"Low":"0",
			"High":"255",
			"Attribute":"intensity",
			"Phase":["0"," 360"],
			"Close":"X",
			"Blocks":"0",
			"Direction":"Fwr. Bounce",
			"Wings":"2",
			"Bpm":"60"
		}]
		
		]]
		local layers = {}
		for _, v in pairs(data) do
			local newLayer = {
				
				attribute = v.Attribute or "intensity"; -- Name of capability
				mode = "Abs"; -- Abs or Rel
				form = v.Wave or "Sine"; -- Name of function in effectWaves
				direction = v.Direction == "Forward" and "forward" or v.Direction == "Reverse" and "backwards" or v.Direction == "Fwr. Bounce" and "bounce"; -- forward, backwards or bounce
				speed = tonumber(v.Bpm) or 60; -- Speed in BPM
				low = tonumber(v.Low) or 0;
				high = tonumber(v.High) or 255;
				
				groups = tonumber(v.Groups) or 0;
				wings = tonumber(v.Wings) or 0;
				blocks = tonumber(v.Blocks) or 0;
				
				phase = {tonumber(v.Phase[1]) or 0, tonumber(v.Phase[2])}; -- From too
				width = 100; -- Percentage
				
			}
			table.insert(layers, newLayer)
		end
		
		local newEffect = module.NewEffect(false, layers)
		module.AddEffect(newEffect, effectId)
	end)
	
	local newEffect = module.NewEffect(false, {
		
		{
			attribute = "COLORRED"; -- Name of capability
			mode = "Abs"; -- Abs or Rel
			form = "Phase1"; -- Name of function in effectWaves
			direction = "forward"; -- forward, backwards or bounce
			speed = 128.0/5; -- Speed in BPM
			low = 0;
			high = 255;
			
			groups = 0;
			wings = 0;
			blocks = 0;
		
			direction = 1; -- or -1
			phase = {0, 360}; -- From too
			width = 100; -- Percentage
			
			-- Running effect inserted stuff
			--formFunction = function;
			--dif = high - low;
		};
		{
			attribute = "COLORGREEN"; -- Name of capability
			mode = "Abs"; -- Abs or Rel
			form = "Phase2"; -- Name of function in effectWaves
			direction = "forward"; -- forward, backwards or bounce
			speed = 128.0/5; -- Speed in BPM
			low = 0;
			high = 255;
			
			groups = 0;
			wings = 0;
			blocks = 0;
		
			direction = 1; -- or -1
			phase = {0, 360}; -- From too
			width = 100; -- Percentage
			
			-- Running effect inserted stuff
			--formFunction = function;
			--dif = high - low;
		};
		{
			attribute = "COLORBLUE"; -- Name of capability
			mode = "Abs"; -- Abs or Rel
			form = "Phase3"; -- Name of function in effectWaves
			direction = "forward"; -- forward, backwards or bounce
			speed = 128.0/5; -- Speed in BPM
			low = 0;
			high = 255;
			
			groups = 0;
			wings = 0;
			blocks = 0;
		
			direction = 1; -- or -1
			phase = {0, 360}; -- From too
			width = 100; -- Percentage
			
			-- Running effect inserted stuff
			--formFunction = function;
			--dif = high - low;
		};
		
	})
	
	local newEffect2 = module.NewEffect(false, {
		
		{
			attribute = "intensity"; -- Name of capability
			mode = "Abs"; -- Abs or Rel
			form = "Phase3"; -- Name of function in effectWaves
			direction = "forward"; -- forward, backwards or bounce
			speed = 128.0/5; -- Speed in BPM
			low = 0;
			high = 255;
			
			groups = 0;
			wings = 0;
			blocks = 12;
		
			direction = 1; -- or -1
			phase = {0,360}; -- From too
			width = 100; -- Percentage
			
			-- Running effect inserted stuff
			--formFunction = function;
			--dif = high - low;
		};
		{
			attribute = "TILT"; -- Name of capability
			mode = "Abs"; -- Abs or Rel
			form = "Ramp"; -- Name of function in effectWaves
			direction = "forward"; -- forward, backwards or bounce
			speed = 128.0/5; -- Speed in BPM
			low = 65;
			high = 85;
			
			groups = 0;
			wings = 0;
			blocks = 12;
		
			direction = 1; -- or -1
			phase = {0,360}; -- From too
			width = 100; -- Percentage
			
			-- Running effect inserted stuff
			--formFunction = function;
			--dif = high - low;
		};
		
	})
	local patchService = require(script.Parent.Parent.Libraries.ServiceHandler).getService("PatchService")
	
	local newId = module.AddEffect(newEffect, 1)
	local newId2 = module.AddEffect(newEffect2, 2)
	local patch = patchService.GetFixtures()
	local megapointes = {}
	local jdcs = {}
	local strips = {
		
	}
	--[[
	-- 1 25 49
	for _, v in pairs(patch[1]:getInstances()) do
		table.insert(strips, v)
	end
	for _, v in pairs(patch[25]:getInstances()) do
		table.insert(strips, v)
	end
	for _, v in pairs(patch[49]:getInstances()) do
		table.insert(strips, v)
	end]]
	for _, v in pairs(patchService.GetFixtures()) do
		if v.fixtureType == "JDC1" then
			table.insert(jdcs, v:getInstance(2))
			table.insert(jdcs, v:getInstance(3))
			table.insert(jdcs, v:getInstance(4))
			table.insert(jdcs, v:getInstance(5))
			table.insert(jdcs, v:getInstance(6))
			table.insert(jdcs, v:getInstance(7))
			
			table.insert(jdcs, v:getInstance(8))
			table.insert(jdcs, v:getInstance(9))
			table.insert(jdcs, v:getInstance(10))
			table.insert(jdcs, v:getInstance(11))
			table.insert(jdcs, v:getInstance(12))
			table.insert(jdcs, v:getInstance(13))
			--v:getInstance().setValue("intensity", 255)
			v:getInstance().setValue("TILT", -90)
		elseif v.fixtureType == "Megapointe" then
			table.insert(megapointes, v:getInstance())
		end
	end
	
	--module.RunEffect(newId, strips)
	--module.RunEffect(newId2, megapointes)
end

function module.AddEffect(effect, effectId)
	local id = self.runner.addEffect(effect, effectId)
	Desk.Events.Pools.Effects.GetEffects:FireAllClients()
	return id
end

function module.NewEffect(...)
	return Effect.new(...)
end

--[[function module.AddEffect(effect)
	self.runner.addEffect(effect)
end]]

function module.RunEffect(effectId, instances)
	self.runner.runEffect(effectId, instances)
	Desk.Events.Pools.Effects.GetEffects:FireAllClients()
end

return module
