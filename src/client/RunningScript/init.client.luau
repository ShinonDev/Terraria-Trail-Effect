local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local baseSpeed = humanoid.WalkSpeed
local maxSpeed = 50
local accelerationRate = 2
local decelerationRate = 1

local isRunning = false

function increaseSpeed()
	if isRunning and humanoid.MoveDirection.Magnitude > 0 then
		humanoid.WalkSpeed = math.min(humanoid.WalkSpeed + accelerationRate, maxSpeed)
		task.wait(0.1)
		increaseSpeed()
	end
end

function decreaseSpeed()
	if not isRunning then
		humanoid.WalkSpeed = math.max(humanoid.WalkSpeed - decelerationRate, baseSpeed)
		task.wait(0.1)
		decreaseSpeed()
	end
end

UserInputService.InputBegan:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.LeftShift then
		isRunning = true
		increaseSpeed()
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.LeftShift then
		isRunning = false
		decreaseSpeed()
	end
end)
