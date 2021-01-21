local view = {}
view.__index = view

--[[
	Example view controller
--]]

-- View globals (e.g. Minimum size, Maximum size, Display Name)
view.globals = {
	minimumSize = Vector2.new(2,2); -- 1,1 is the smallest any view can be
	sizeMultiple = 2;
	displayName = "Executors"
}

-- Create new view frame
function view.new(position, size)
	
	local self = setmetatable({}, view)
	
	self.position = {x = position.X, y = position.Y}
	self.size = {x = size.X, y = size.Y}
	self.frame = script.Executors:Clone()
	self.dragButton = self.frame.Main
	self.resizeButton = self.frame.Resize
	
	self.executors = {}
	
	return self
	
end

function view:init()
	
	-- Bind all functions in here.
	-- E.g. Clicking on certain buttons.
	
	self.dragButton.MouseButton2Click:Connect(function()
		self.frame:Destroy()
		self = nil
	end)
	
	self:redraw()
	
end

function view:redraw()
	local amount = (self.size.x/2)
	local difference = amount - #self.executors
	--print(difference)
	if difference > 0 then
		for i=1, difference do
			local button = script.E1:Clone()
			button.Parent = self.frame.Executors
			table.insert(self.executors, button)
		end
	else
		for i=1, math.abs(difference) do
			self.executors[#self.executors]:Destroy()
			table.remove(self.executors,#self.executors)
		end
	end
	for i=1,#self.executors do
		local x = self.executors[i]
		x.Position = UDim2.new(0,(i-1) * 100,0,50)
		x.Title.ID.Text = i
		x.Name = "E" .. i
		x.Title.Title.Text = ""
		for _,v in pairs(x.Sequence:GetChildren()) do
			v.RowName.Text = ""
		end
		for _,v in pairs(x.Virtual.Buttons:GetChildren()) do
			v.Text = ""
		end
	end
end

function view:onResize()
	self:redraw()
end


return view
