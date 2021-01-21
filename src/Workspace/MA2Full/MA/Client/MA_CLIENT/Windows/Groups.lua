local view = {}
view.__index = view

--[[
	Example view controller
--]]

-- View globals (e.g. Minimum size, Maximum size, Display Name)
view.globals = {
	minimumSize = Vector2.new(4,2); -- 1,1 is the smallest any view can be
	sizeMultiple = 2;
	displayName = "Groups"
}



-- Create new view frame
function view.new(position, size)
	
	local self = setmetatable({}, view)
	
	self.position = {x = position.X, y = position.Y}
	self.size = {x = size.X, y = size.Y}
	self.frame = script.Groups:Clone()
	self.dragButton = self.frame.Main
	self.resizeButton = self.frame.Resize
	
	self.offset = 0
	
	local player = game.Players.LocalPlayer
	
	self.buttons = {}
	self.groups = {}
	self.groupMap = {}
	
	return self
	
end

local Events = script.Parent.Parent.Desk.Value.Events

function view:redraw()
	local buttons = ((self.size.x/2) * (self.size.y/2)) - 1
	local difference = buttons - #self.buttons
	--print(difference)
	if difference > 0 then
		for i=1, difference do
			local button = script.PoolButton:Clone()
			button.Parent = self.frame.Buttons
			
			button.MouseButton1Click:Connect(function()
				Events.Pools.Groups.SelectGroup:FireServer(tonumber(button.Number.Text))
			end)
			
			button.MouseButton2Click:Connect(function()
				-- Create group
				print("Store group")
				Events.Pools.Groups.StoreGroup:FireServer(tonumber(button.Number.Text), "Group " .. button.Number.Text, {255, 255, 255})
			end)
			
			table.insert(self.buttons, button)
		end
	else
		for i=1, math.abs(difference) do
			self.buttons[#self.buttons]:Destroy()
			table.remove(self.buttons,#self.buttons)
		end
	end
	for k, button in pairs(self.buttons) do
		local id = k+(self.offset*(buttons))
		button.LayoutOrder = k
		button.Number.Text = id
		button.SelectedFrame.Visible = false
		button.GroupName.Text = "EMPTY"
		button.GroupName.TextColor3 = Color3.fromRGB(102, 102, 102)
		if self.groupMap[tonumber(id)] then
			local curGroup = self.groupMap[tonumber(id)]
			button.GroupName.Text = curGroup.groupName
			button.GroupName.TextColor3 = Color3.fromRGB(255, 255, 255)
			
			if curGroup.selected then
				-- 0, 29, 65
				button.ImageColor3 = Color3.fromRGB(0, 29, 65)
			else
				-- 53, 53, 61
				button.ImageColor3 = Color3.fromRGB(53, 53, 61)
			end
		end
	end
end

function view:init()
	
	-- Bind all functions in here.
	-- E.g. Clicking on certain buttons.
	
	local desk = script.Parent.Parent.Desk.Value
	
	
	self.dragButton.MouseButton2Click:Connect(function()
		self.frame:Destroy()
		self = nil
	end)
	
	self.dragButton.ImageLabel.MouseWheelForward:Connect(function()
		if self.offset > 0 then
			self.offset = self.offset - 1
		end
		self:redraw()
	end)
	
	self.dragButton.ImageLabel.MouseWheelBackward:Connect(function()
		self.offset = self.offset + 1
		self:redraw()
	end)
	
	Events.Pools.Groups.GetGroups.OnClientEvent:Connect(function(groups)
		self.groups = groups
		for _, v in pairs(self.groups) do
			self.groupMap[tonumber(v.groupId)] = v
		end
		self:redraw()
	end)
	
	self:redraw()
	
end
function view:onResize()
	self:redraw()
end


return view
