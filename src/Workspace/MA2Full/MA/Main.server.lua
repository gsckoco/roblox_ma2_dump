-- MA2 main

-- Libraries
local Libraries = script.Parent.Libraries
local DMX = require(Libraries.System:FindFirstChild("DMXOutput"))
local Fixture = require(Libraries.System:FindFirstChild("Fixture"))
local WL = require(Libraries:FindFirstChild("Whitelist"))
local ServiceHandler = require(Libraries:FindFirstChild("ServiceHandler"))
local desk = script.Parent.Desk
desk.Value = script.Parent.Parent

local master = script.Parent.Info.Master.Value

local Services = {}

-- Constants
local NUM_OF_UNIVERSES = 4

-- Events

game.Players.PlayerAdded:Connect(function(player)
	if WL(player.UserId) then 
		local thing = script.Parent.Client.MA_CLIENT:Clone()
		thing.Desk.Value = master or desk.Value
		thing.Screens.Value = desk.Value.Screens
		thing.Parent = player.PlayerGui
	end
end)

wait(2)

-- Init DMX

local outputs = DMX.getOutputs()

for i=1, NUM_OF_UNIVERSES do
	DMX.newUniverse(i,outputs[i])
end

for _, v in pairs(desk.Value.MANet:GetChildren()) do
	local MANetNode = v.Value
	for _, output in pairs(MANetNode.Output:GetChildren()) do
		if output.Value then
			DMX.newUniverse(nil, output.Value)
		end
	end
end

ServiceHandler.startService(script.Parent.Services.PatchService)
-- TODO fix order crap stuff so it boots in order. Patch service always first
for _, v in pairs(script.Parent.Services:GetChildren()) do
	ServiceHandler.startService(v)
end

local patch = ServiceHandler.getService("PatchService")
local effects = ServiceHandler.getService("EffectService")

script.Parent.Parent = game.ServerScriptService