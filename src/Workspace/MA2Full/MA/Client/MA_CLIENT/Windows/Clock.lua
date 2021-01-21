local view = {}
view.__index = view

--[[
	Example view controller
--]]

-- View globals (e.g. Minimum size, Maximum size, Display Name)
view.globals = {
	minimumSize = Vector2.new(2,2); -- 1,1 is the smallest any view can be
	sizeMultiple = 1;
	displayName = "Clock"
}

-- Create new view frame
function view.new(position, size)
	
	local self = setmetatable({}, view)
	
	self.position = {x = position.X, y = position.Y}
	self.size = {x = size.X, y = size.Y}
	self.frame = script.Clock:Clone()
	self.dragButton = self.frame.Main
	self.resizeButton = self.frame.Resize
	
	self.executors = {}
	
	return self
	
end

function view:init()
	
	-- Bind all functions in here.
	-- E.g. Clicking on certain buttons.
	
	game:GetService("RunService").Stepped:Connect(function()
		self:redraw()
	end)
	
	
	self.dragButton.MouseButton2Click:Connect(function()
		self.frame:Destroy()
		self = nil
	end)
	
	self:redraw()
	
end

function view:redraw()
	local curTime = os.date("*t", tick())
	self.frame.TextLabel.Text = string.format("%02d:%02d:%02d", curTime.hour, curTime.min, curTime.sec)
end

function view:onResize()
	self:redraw()
end


return view
