local module = {}

local Libraries = script.Parent.Parent.Libraries
local Effect, sequenceRunner = unpack(require(Libraries:FindFirstChild("Sequences")))

local self = {}

function module.Start()
	-- On Service start
	self.runner = sequenceRunner()
end

function module.AddSequence(...)
	self.runner.addSequence(...)
end

function module.RunSequence(SequenceId)
	self.runner.runSequence(SequenceId)
end

return module
