local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local Camera = game.Workspace.CurrentCamera

local MAX_CHARACTERS = 10
local SPAWNRATE = 0.01
local MOVEMENT_SPEED = -1
local MOVEMENT_DIRECTION = Vector3.new(0, 0, -1)

local function onCharacterAdded(character)
	local cloneFolder = Instance.new("Folder")
	cloneFolder.Parent = workspace
	cloneFolder.Name = "Clone_" .. character.Name

	local humanoid = character:WaitForChild("Humanoid")
	local characters = {}
	local hue = 0
	local increasingHue = true
	local dead = false

	local function onDeath()
		cloneFolder:Destroy()
		dead = true
	end

	humanoid.Died:Once(onDeath)

	local function characterTrail()
		if #characters < MAX_CHARACTERS then
			if increasingHue then
				hue = hue + 0.05
				if hue >= 1 then
					increasingHue = false
				end
			else
				hue = hue - 0.05
				if hue <= 0.2 then
					increasingHue = true
				end
			end

			local rainbowColor = Color3.fromHSV(hue, 0.6, 1)

			local modelClone = Instance.new("Model")
			modelClone.Parent = cloneFolder
			modelClone.Name = "Clone_" .. character.Name

			for _, limb in ipairs(character:GetDescendants()) do
				if limb:IsA("MeshPart") then
					local clonedLimb = limb:Clone()
					clonedLimb:ClearAllChildren()
					clonedLimb.Parent = modelClone
					clonedLimb.CanCollide = false
					clonedLimb.CastShadow = false
					clonedLimb.CanTouch = false
					clonedLimb.CanQuery = false
					clonedLimb.Anchored = false
					clonedLimb.TextureID = ""
					clonedLimb.Material = Enum.Material.ForceField
					clonedLimb.Transparency = 1
					clonedLimb.Color = rainbowColor

					local fadeTweenInfo = TweenInfo.new(
						MAX_CHARACTERS * SPAWNRATE * 7 / 2,
						Enum.EasingStyle.Linear,
						Enum.EasingDirection.InOut,
						0,
						true,
						0
					)
					local fadeGoal = { Transparency = 0 }
					local fadeTween = TweenService:Create(clonedLimb, fadeTweenInfo, fadeGoal)

					local colorTweenInfo = TweenInfo.new(
						MAX_CHARACTERS * SPAWNRATE * 7 * 1.2,
						Enum.EasingStyle.Linear,
						Enum.EasingDirection.InOut,
						0,
						false,
						0
					)
					local colorGoal = { Color = Color3.fromHSV(0, 0.0, 1) }
					local colorTween = TweenService:Create(clonedLimb, colorTweenInfo, colorGoal)

					local cameraDirection = Camera.CFrame.LookVector
					local rootPart = character:FindFirstChild("HumanoidRootPart")
					local localDirection = rootPart.CFrame:VectorToWorldSpace(MOVEMENT_DIRECTION)
					local newPosition = clonedLimb.Position - (cameraDirection * MOVEMENT_SPEED)
					local positionGoal = { Position = newPosition }
					local positionTween = TweenService:Create(clonedLimb, colorTweenInfo, positionGoal)

					fadeTween:Play()
					colorTween:Play()
					positionTween:Play()
				end
			end

			table.insert(characters, modelClone)
		else
			local oldestClone = table.remove(characters, 1)
			Debris:AddItem(oldestClone, MAX_CHARACTERS * SPAWNRATE / 2)
		end
	end

	while not dead do
		task.wait(MAX_CHARACTERS * SPAWNRATE / 4)
		characterTrail()
	end
end

Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(onCharacterAdded)
end)

for _, player in Players:GetPlayers() do
	if player.Name == Players.LocalPlayer.Name then
		player.CharacterAdded:Connect(onCharacterAdded)
	end
end
