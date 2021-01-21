local view = {}
local UserInputService = game:GetService("UserInputService")

view.__index = view

--[[
	Example view controller
--]]

-- View globals (e.g. Minimum size, Maximum size, Display Name)
view.globals = {
	minimumSize = Vector2.new(4,2); -- 1,1 is the smallest any view can be
	sizeMultiple = 1;
	displayName = "Fixtures"
}

-- Create new view frame
function view.new(position, size)
	
	local self = setmetatable({}, view)
	
	self.position = {x = position.X, y = position.Y}
	self.size = {x = size.X, y = size.Y}
	self.frame = script.Fixtures:Clone()
	self.dragButton = self.frame.Main
	self.resizeButton = self.frame.Resize
	
	self.fixtures = {}
	self.selection = {}
	
	self.selectionMap = {}
	
	self.rows = {}
	self.allRows = {}
	
	return self
	
end

local Events = script.Parent.Parent.Desk.Value.Events

function view:init()
	
	-- Bind all functions in here.
	-- E.g. Clicking on certain buttons.
	
	self.fixtures = Events.Patch.GetPatch:InvokeServer()
	self.selection = Events.Patch.GetSelection:InvokeServer()
	
	Events.Patch.SelectFixture.OnClientEvent:Connect(function(selection)
		self.selection = selection
		self:updateSelection()
	end)
	
	self.dragButton.MouseButton2Click:Connect(function()
		self.frame:Destroy()
		self = nil
	end)
	
	self:updateSelection()
	
	self:redraw()
	
end

function view:updateSelection()
	for k, _ in pairs(self.selectionMap) do
		self.selectionMap[k] = nil
	end
	
	for i = 1, #self.selection do
		local v = self.selection[i]
		self.selectionMap[v] = true
	end
	
	for _, v in pairs(self.allRows) do
		if self.selectionMap[v.Name] then
			v.BackgroundColor3 = Color3.fromRGB(0, 29, 65)
		else
			v.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
		end
	end
end

function view:updateSize()
	local size = 0
	for _, v in pairs(self.rows) do
		size += v.Size.Y.Offset 
	end
	print(size, #self.rows)
	self.frame.ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, size)
end

function view:redraw()
	for k, v in pairs(self.rows) do
		v:Destroy()
	end
	self.rows = {}
	local count = 0
	for k, v in pairs(self.fixtures) do
		local row = script.Fixture:Clone()
		row.Name = k .. ".1"
		row.FID.Text = k
		row.FName.Text = v.name
		row.Parent = self.frame.ScrollingFrame
		
		if self.selectionMap[k .. ".1"] then
			row.BackgroundColor3 = Color3.fromRGB(0, 29, 65)
		end
		
		-- 35, 35, 40
		--  0, 29, 65
		
		local open = false
		
		row.MouseButton1Click:Connect(function()
			-- fixture, instance
			if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
				for instanceId, _ in pairs(v.instances) do
					Events.Patch.SelectFixture:FireServer(k, instanceId)
				end
			else
				Events.Patch.SelectFixture:FireServer(k, 1)
			end
		end)
		
		row.MouseButton2Click:Connect(function()
			local size = #v.instances + 1
			
			open = not open
			
			if open then
				row.Size = UDim2.new(1, 0, 0, 50 * size )
			else
				row.Size = UDim2.new(1, 0, 0, 50)
			end
			
			self:updateSize()
		end)
		
		table.insert(self.rows, row)
		table.insert(self.allRows, row)
		for instanceId, instance in pairs(v.instances) do
			local instanceRow = script.Instance:Clone()
			instanceRow.Name = k .. "." .. instanceId
			instanceRow.FID.Text = k .. "." .. instanceId
			instanceRow.FName.Text = instance.name
			
			if self.selectionMap[k .. "." .. instanceId] then
				instanceRow.BackgroundColor3 = Color3.fromRGB(0, 29, 65)
			end
			
			instanceRow.MouseButton1Click:Connect(function()
				-- fixture, instance
				Events.Patch.SelectFixture:FireServer(k, instanceId)
			end)
			
			instanceRow.Parent = row.Instances
			
			table.insert(self.allRows, instanceRow)
		end
	end
	--self.frame.ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 50 * count)
	self:updateSize()
end

function view:onResize()
	self:redraw()
end


return view
