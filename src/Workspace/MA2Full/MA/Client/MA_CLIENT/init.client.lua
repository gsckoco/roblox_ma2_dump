local Desk = script.Desk.Value
local Events = Desk.Events
local Screens = script.Screens.Value
local ViewController = require(script.ViewController)
local Mouse = game.Players.LocalPlayer:GetMouse()
local UIS = game:GetService("UserInputService")

local screenTable = {}

for _, screen in pairs(Screens:GetChildren()) do
	screenTable[screen.Name] = ViewController.new(screen, "Main")
end
	
Desk.Events.Pools.Effects.OpenEffectWizard.Event:Connect(function(effectId)
	screenTable["ScreenB"]:openEffectWizard(effectId)
end)


do
	local attributes = {}
	local currentCatagory = ""
	local currentPage = 0
	
	local Encoders = {}
	local currentEncoder = nil
	local encoderDirection = nil
	
	UIS.InputEnded:Connect(function(input, robloxEvent)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			currentEncoder = nil
			encoderDirection = nil
			UIS.MouseBehavior = Enum.MouseBehavior.Default
		end
	end)
	
	UIS.InputChanged:Connect(function(input, robloxEvent)
		if input.UserInputType == Enum.UserInputType.MouseMovement and currentEncoder then
			--print(input.Delta)
			encoderDirection = math.abs(input.Delta.X) > math.abs(input.Delta.Y)
			if currentCatagory and attributes[currentCatagory][(currentPage * 4) + currentEncoder] then
				if encoderDirection then
					Events.Patch.UpdateValue:FireServer(attributes[currentCatagory][(currentPage * 4) + currentEncoder], 5 * math.sign(input.Delta.X))
				else
					Events.Patch.UpdateValue:FireServer(attributes[currentCatagory][(currentPage * 4) + currentEncoder], 1 * math.sign(input.Delta.Y))
				end
			end
		end
	end)
	
	for k, v in pairs(Desk.Encoders:GetChildren()) do
		local encGui = script.Encoders:Clone()
		encGui.Adornee = v
		encGui.Parent = script
		encGui.Name = v.Name
		
		
		encGui.Button.MouseButton1Down:Connect(function()
			currentEncoder = k
			UIS.MouseBehavior = Enum.MouseBehavior.LockCurrentPosition
		end)
		encGui.Button.MouseButton1Up:Connect(function()
			currentEncoder = nil
			UIS.MouseBehavior = Enum.MouseBehavior.Default
		end)
		
		table.insert(Encoders, encGui)
	end
	
	
	local EncoderGui = script.EncoderGui
	
	EncoderGui.Adornee = Desk.Body.EncoderScreen
	
	local encoderGroupButton = EncoderGui.Main.Groups.TextButton
	encoderGroupButton.Parent = script
	local values = {}
	local function update()
		if currentCatagory == "" or attributes[currentCatagory] == nil then
			for _, v in pairs(EncoderGui.Main.Values:GetChildren()) do
				v.Attribute.Text = ""
				v.Value.Text = ""
			end
		else
			for k, v in pairs(EncoderGui.Main.Values:GetChildren()) do
				if attributes[currentCatagory][(currentPage * 4) + k] then
					v.Attribute.Text = attributes[currentCatagory][k]
					v.Value.Text = values[currentCatagory][attributes[currentCatagory][k]]
				else
					v.Attribute.Text = ""
					v.Value.Text = ""
				end
			end
		end
	end
	
	Desk.Events.Patch.UpdateValue.OnClientEvent:Connect(function(newValues)
		values = newValues
		update()
		--print(game:GetService("HttpService"):JSONEncode(newValues))
	end)
	
	Events.Patch.SelectFixture.OnClientEvent:Connect(function(_, newAttributes)
		-- Update encoder group
		for _, v in pairs(EncoderGui.Main.Groups:GetChildren()) do
			if not v:IsA("UIGridLayout") then
				v:Destroy()
			end
		end
		
		attributes = newAttributes
		
		for k, _ in pairs(attributes) do
			local newButton = encoderGroupButton:Clone()
			newButton.Parent = EncoderGui.Main.Groups
			newButton.Text = string.upper(k)
			newButton.Name = k
			
			newButton.MouseButton1Down:Connect(function()
				currentCatagory = k
				update()
			end)
		end
		if not attributes[currentCatagory] then currentCatagory = "" update() end
	end)
end