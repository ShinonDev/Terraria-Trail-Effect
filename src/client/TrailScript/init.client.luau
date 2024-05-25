local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")

local MAX_CHARACTERS = 10
local MAX_SPEED = 16
local SPAWNRATE = 0.01
local characters = {}

local character = Players.LocalPlayer.Character or Players.LocalPlayer.CharacterAdded:Wait()
local humanoid = character.Humanoid

local function characterTrail()
	local clone

	if
		#characters < MAX_CHARACTERS
		and humanoid.WalkSpeed >= MAX_SPEED * 2
		and humanoid.MoveDirection.Magnitude > 0
	then
		local folder = Instance.new("Folder")
		folder.Parent = workspace

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
				clonedLimb.Transparency = 0.7
				clonedLimb.Color = Color3.fromHSV(0, 0, 1)

				for _, trash in clonedLimb:GetChildren() do
					trash:Destroy()
				end

				local goal = {}
				goal.Transparency = 1

				local tweenInfo = TweenInfo.new(
					MAX_CHARACTERS * SPAWNRATE * 7, -- Time (duration of the tween)
					Enum.EasingStyle.Linear, -- Easing style of the tween
					Enum.EasingDirection.InOut, -- Easing direction of the tween
					0, -- Number of times to repeat (-1 for infinite)
					false, -- Reverses tween after completion
					0 -- Delay time before tween starts
				)

				local tween = TweenService:Create(clonedLimb, tweenInfo, goal)

				tween:Play()
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
