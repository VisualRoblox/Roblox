-- ایجاد رابط کاربری
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local rootPart = character:WaitForChild("HumanoidRootPart")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AmirFpsGui"
screenGui.Parent = player:WaitForChild("PlayerGui")

-- دکمه باز و بسته کردن پنل
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 150, 0, 50)
toggleButton.Position = UDim2.new(0.5, -75, 0, 10)
toggleButton.Text = "Open Panel"
toggleButton.Parent = screenGui

-- پنل اصلی
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 150)
frame.Position = UDim2.new(0.5, -100, 0.5, -75)
frame.Visible = false
frame.Parent = screenGui

-- عنوان پنل
local title = Instance.new("TextLabel")
title.Text = "FLASH HUB"
title.Size = UDim2.new(1, 0, 0, 30)
title.Parent = frame

-- دکمه قفل کردن
local lockButton = Instance.new("TextButton")
lockButton.Size = UDim2.new(0, 120, 0, 40)
lockButton.Position = UDim2.new(0.5, -60, 0.5, -20)
lockButton.Text = "Lock Player"
lockButton.Parent = frame

-- منطق اسکریپت
local isLocked = false

toggleButton.MouseButton1Click:Connect(function()
	frame.Visible = not frame.Visible
end)

lockButton.MouseButton1Click:Connect(function()
	isLocked = not isLocked
	rootPart.Anchored = isLocked
	
	if isLocked then
		lockButton.Text = "Unlock Player"
	else
		lockButton.Text = "Lock Player"
	end
end)
