local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")

local VisualController = {}

local WHITE = Color3.fromRGB(255,255,255)

local function ensureSpeedBlur()
	local blur = Lighting:FindFirstChild("LocalSpeedBlur")
	if blur and blur:IsA("BlurEffect") then
		return blur
	end
	blur = Instance.new("BlurEffect")
	blur.Name = "LocalSpeedBlur"
	blur.Size = 0
	blur.Parent = Lighting
	return blur
end

local function ensureTrail(character)
	local root = character:WaitForChild("HumanoidRootPart", 5)
	if not root then return nil end

	local old = root:FindFirstChild("AnimeSpeedTrail")
	if old and old:IsA("Trail") then
		return old
	end

	local a0 = Instance.new("Attachment")
	a0.Name = "AnimeTrailA0"
	a0.Position = Vector3.new(-1.4, -1.5, 1.2)
	a0.Parent = root

	local a1 = Instance.new("Attachment")
	a1.Name = "AnimeTrailA1"
	a1.Position = Vector3.new(1.4, -1.5, 1.2)
	a1.Parent = root

	local trail = Instance.new("Trail")
	trail.Name = "AnimeSpeedTrail"
	trail.Attachment0 = a0
	trail.Attachment1 = a1
	trail.Enabled = false
	trail.FaceCamera = true
	trail.LightEmission = 0.65
	trail.Lifetime = 0.14
	trail.MinLength = 0.2
	trail.Color = ColorSequence.new(Color3.fromRGB(90, 202, 255), Color3.fromRGB(238, 248, 255))
	trail.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.55),
		NumberSequenceKeypoint.new(1, 1),
	})
	trail.WidthScale = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.55),
		NumberSequenceKeypoint.new(1, 0),
	})
	trail.Parent = root
	return trail
end

local function findNearestWorld(root, Config)
	if not root or root.Position.Z < 25 then return nil end
	local best
	local bestDistance = math.huge
	for _, world in ipairs(Config.Worlds) do
		local d = math.abs(root.Position.Z - world.CenterZ)
		if d < bestDistance then
			bestDistance = d
			best = world
		end
	end
	if bestDistance <= 145 then return best end
	return nil
end

function VisualController.Start(player, Config)
	local blur = ensureSpeedBlur()
	local trackedCapsules = {}
	local trackedEnergy = {}
	local baseTint = WHITE

	local function scanWorld()
		table.clear(trackedCapsules)
		table.clear(trackedEnergy)

		local world = workspace:FindFirstChild("AnimeEggWorld")
		if not world then return end

		for _, obj in ipairs(world:GetDescendants()) do
			if obj:IsA("BasePart") then
				if obj.Name == "CapsuleCore" then
					trackedCapsules[obj] = {
						CFrame = obj.CFrame,
						Size = obj.Size,
						Seed = math.random() * math.pi * 2,
					}
				elseif obj.Name == "EnergyBar" then
					trackedEnergy[obj] = math.random() * math.pi * 2
				end
			end
		end

		world.DescendantAdded:Connect(function(obj)
			if not obj:IsA("BasePart") then return end
			if obj.Name == "CapsuleCore" then
				trackedCapsules[obj] = {
					CFrame = obj.CFrame,
					Size = obj.Size,
					Seed = math.random() * math.pi * 2,
				}
			elseif obj.Name == "EnergyBar" then
				trackedEnergy[obj] = math.random() * math.pi * 2
			end
		end)
	end

	task.defer(scanWorld)
	workspace.ChildAdded:Connect(function(child)
		if child.Name == "AnimeEggWorld" then
			task.delay(0.5, scanWorld)
		end
	end)

	local currentTrail
	local function onCharacter(character)
		currentTrail = ensureTrail(character)
	end

	if player.Character then
		task.spawn(onCharacter, player.Character)
	end
	player.CharacterAdded:Connect(onCharacter)

	local smoothFov = 70
	RunService.RenderStepped:Connect(function(dt)
		local t = os.clock()

		for core, data in pairs(trackedCapsules) do
			if not core.Parent then
				trackedCapsules[core] = nil
			else
				local pulse = 1 + math.sin(t * 2.3 + data.Seed) * 0.035
				core.Size = data.Size * pulse
				core.CFrame = data.CFrame * CFrame.new(0, math.sin(t * 1.9 + data.Seed) * 0.22, 0)
				local light = core:FindFirstChildOfClass("PointLight")
				if light then
					light.Brightness = 1.35 + math.sin(t * 2.3 + data.Seed) * 0.3
				end
			end
		end

		for bar, seed in pairs(trackedEnergy) do
			if not bar.Parent then
				trackedEnergy[bar] = nil
			else
				bar.Transparency = 0.22 + (math.sin(t * 2 + seed) + 1) * 0.09
			end
		end

		local character = player.Character
		local root = character and character:FindFirstChild("HumanoidRootPart")
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")
		local stats = player:FindFirstChild("leaderstats")
		local speedStat = stats and stats:FindFirstChild("Speed")
		local numericSpeed = speedStat and speedStat.Value or 0
		local moving = humanoid and humanoid.MoveDirection.Magnitude > 0.05

		local targetFov = 70
		if moving then
			targetFov += math.clamp(math.sqrt(numericSpeed) * 0.13, 0, 11)
		end
		if (player:GetAttribute("CarryingName") or "") ~= "" then
			targetFov += 1.5
		end

		smoothFov += (targetFov - smoothFov) * math.min(1, dt * 7)
		local camera = workspace.CurrentCamera
		if camera then
			camera.FieldOfView = smoothFov
		end

		blur.Size = moving and math.clamp((smoothFov - 70) * 0.12, 0, 1.4) or 0
		if currentTrail then
			currentTrail.Enabled = moving and numericSpeed >= 350
		end

		local color = Lighting:FindFirstChild("AnimeColor")
		if color and color:IsA("ColorCorrectionEffect") then
			local zone = findNearestWorld(root, Config)
			local targetTint = zone and WHITE:Lerp(zone.Accent, 0.035) or baseTint
			color.TintColor = color.TintColor:Lerp(targetTint, math.min(1, dt * 2.5))
		end
	end)
end

return VisualController
