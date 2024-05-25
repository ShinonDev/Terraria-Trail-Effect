local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local Camera = game.Workspace.CurrentCamera

local MAX_CHARACTERS = 10
local MAX_SPEED = 16
local SPAWNRATE = 0.01
local characters = {}
local hue = 0
local bool = true
local movementSpeed = -1
local movementDirection = Vector3.new(0, 0, -1)

local CloneFolder = Instance.new("Folder")
CloneFolder.Parent = workspace
CloneFolder.Name = "Clones"

local function onCharacterAdded(character)
	local humanoid = character.Humanoid

	local function characterTrail()
		local clone

		if
			#characters < MAX_CHARACTERS
			-- and humanoid.WalkSpeed >= MAX_SPEED * 2
			-- and humanoid.MoveDirection.Magnitude > 0
		then
			if bool then
				if hue >= 1 then
					bool = false
				end

				hue = hue + 0.05
			else
				if hue <= 0.2 then
					bool = true
				end
				hue = hue - 0.05
			end

			local rainbow = Color3.fromHSV(hue, 0.6, 1)

			local folder = Instance.new("Model")
			folder.Parent = CloneFolder
			folder.Name = "Clone"

			for _, limb in character:GetDescendants() do
				if limb:IsA("MeshPart") then
					local clonedLimb = limb:Clone()
					clonedLimb.Parent = folder
					clonedLimb.CanCollide = false
					clonedLimb.CastShadow = false
					clonedLimb.CanTouch = false
					clonedLimb.CanQuery = false
					clonedLimb.Anchored = true
					clonedLimb.Material = Enum.Material.ForceField
					clonedLimb.Transparency = 1
					-- limb.Transparency = 1
					clonedLimb.Color = rainbow

					for _, trash in clonedLimb:GetChildren() do
						trash:Destroy()
					end

					local goal = {}
					goal.Transparency = 0.7

					local tweenInfo = TweenInfo.new(
						MAX_CHARACTERS * SPAWNRATE * 7 / 2, -- Time (duration of the tween)
						Enum.EasingStyle.Linear, -- Easing style of the tween
						Enum.EasingDirection.InOut, -- Easing direction of the tween
						0, -- Number of times to repeat (-1 for infinite)
						true, -- Reverses tween after completion
						0 -- Delay time before tween starts
					)

					local tween = TweenService:Create(clonedLimb, tweenInfo, goal)

					tween:Play()

					local goal2 = {}
					goal2.Color = Color3.fromHSV(0, 0.0, 1)

					local tweenInfo2 = TweenInfo.new(
						MAX_CHARACTERS * SPAWNRATE * 7 * 1.2, -- Time (duration of the tween)
						Enum.EasingStyle.Linear, -- Easing style of the tween
						Enum.EasingDirection.InOut, -- Easing direction of the tween
						0, -- Number of times to repeat (-1 for infinite)
						false, -- Reverses tween after completion
						0 -- Delay time before tween starts
					)

					local tween2 = TweenService:Create(clonedLimb, tweenInfo2, goal2)

					tween2:Play()

					local cameraDirection = Camera.CFrame.LookVector

					local partFacingDirection = clonedLimb.CFrame.LookVector
					local localDirection =
						character:FindFirstChild("HumanoidRootPart").CFrame:VectorToWorldSpace(movementDirection)

					local newPosition = clonedLimb.Position - (cameraDirection * movementSpeed)
					local newPositionFromPart = clonedLimb.Position + (localDirection * movementSpeed)

					local goal3 = {}
					goal3.Position = newPositionFromPart

					local tween3 = TweenService:Create(clonedLimb, tweenInfo2, goal3)

					tween3:Play()
				end
			end

			table.insert(characters, folder)
		else
			clone = table.remove(characters, 1)
			Debris:AddItem(clone, MAX_CHARACTERS * SPAWNRATE / 2)
		end
	end

	while task.wait(MAX_CHARACTERS * SPAWNRATE / 4) do
		characterTrail()
	end
end

Players.LocalPlayer.CharacterAdded:Connect(onCharacterAdded)

if Players.LocalPlayer.Character then
	onCharacterAdded(Players.LocalPlayer.Character)
end
