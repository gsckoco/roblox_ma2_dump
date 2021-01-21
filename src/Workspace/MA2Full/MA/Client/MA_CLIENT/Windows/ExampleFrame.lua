local view = {}
view.__index = view

--[[
	Example view controller
--]]

-- View globals (e.g. Minimum size, Maximum size, Display Name)
view.globals = {
	minimumSize = Vector2.new(4,2); -- 1,1 is the smallest any view can be
	sizeMultiple = 2;
	displayName = "Example Frame"
}

-- Create new view frame
function view.new(position, size)
	
	local self = setmetatable({}, view)
	
	self.position = {x = position.X, y = position.Y}
	self.size = {x = size.X, y = size.Y}
	self.frame = script.Frame:Clone()
	self.dragButton = self.frame.Main
	self.resizeButton = self.frame.Resize
	
	return self
	
end

function view:init()
	
	-- Bind all functions in here.
	-- E.g. Clicking on certain buttons.
	
	self.dragButton.MouseButton2Click:Connect(function()
		self.frame:Destroy()
		self = nil
	end)
	
end

function view:setSize(newSize)
	if (newSize.X >= self.globals.minimumSize.X and newSize.Y >= self.globals.minimumSize.Y) then
		if self.globals.maximumSize and (newSize.X <= self.globals.maximumSize.X and newSize.Y <= self.globals.maximumSize.Y) then
			self.size = newSize
			return true
		else
			return true
		end
	end
	return false
end

function view:onResize()
	
end


return view
