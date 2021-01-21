local view = {}
view.__index = view

local Events = script.Parent.Parent.Desk.Value.Events
--[[
	Example view controller
--]]

-- View globals (e.g. Minimum size, Maximum size, Display Name)
view.globals = {
	minimumSize = Vector2.new(4,2); -- 1,1 is the smallest any view can be
	sizeMultiple = 2;
	displayName = "Effects"
}

-- Create new view frame
function view.new(position, size)
	
	local self = setmetatable({}, view)
	
	self.position = {x = position.X, y = position.Y}
	self.size = {x = size.X, y = size.Y}
	self.frame = script.Effects:Clone()
	self.dragButton = self.frame.Main
	self.resizeButton = self.frame.Resize
	
	self.offset = 0
	
	local player = game.Players.LocalPlayer
	
	self.buttons = {}
	self.effects = {}
	self.runningEffects = {}
	
	return self
	
end

function view:redraw()
	local buttons = ((self.size.x/2) * (self.size.y/2)) - 1
	local difference = buttons - #self.buttons
	--print(difference)
	if difference > 0 then
		for i=1, difference do
			local button = script.PoolButton:Clone()
			button.Parent = self.frame.Buttons
			table.insert(self.buttons, button)
		end
	else
		for i=1, math.abs(difference) do
			self.buttons[#self.buttons]:Destroy()
			table.remove(self.buttons,#self.buttons)
		end
	end
	for i=1, #self.buttons do
		local button = self.buttons[i]
		button.LayoutOrder = i
		button.Number.Text = i+(self.offset*(buttons))
		button.SelectedFrame.Visible = false
		button.effectName.Text = "EMPTY"
		button.effectName.TextColor3 = Color3.fromRGB(102, 102, 102)
		
		local effect = self.effects[i+(self.offset*(buttons))]
		
		button.MouseButton1Down:Connect(function()
			
		end)
		
		button.MouseButton2Down:Connect(function()
			Events.Pools.Effects.OpenEffectWizard:Fire(i+(self.offset*(buttons)))
		end)
	end
end

function view:init()
	
	-- Bind all functions in here.
	-- E.g. Clicking on certain buttons.
	
	
	Events.Pools.Effects.GetEffects.OnClientEvent:Connect(function(effects, runningEffects)
		self.effects = effects
		self.runningEffects = runningEffects
		
		print(effects, runningEffects)
		
		--print(game:GetService("HttpService"):JSONEncode(effects))
		--print(game:GetService("HttpService"):JSONEncode(runningEffects))
		
		self:redraw()
	end)
	
	Events.Pools.Effects.GetEffects:FireServer()
	
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
	
	self:redraw()
	
end
function view:onResize()
	self:redraw()
end


return view
