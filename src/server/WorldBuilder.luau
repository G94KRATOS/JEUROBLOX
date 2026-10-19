local Lighting = game:GetService("Lighting")
local Terrain = workspace.Terrain

local WorldBuilder = {}

local function makePart(parent, name, size, cf, color, material, transparency)
	local p = Instance.new("Part")
	p.Name = name
	p.Anchored = true
	p.Size = size
	p.CFrame = cf
	p.Color = color
	p.Material = material or Enum.Material.SmoothPlastic
	p.Transparency = transparency or 0
	p.TopSurface = Enum.SurfaceType.Smooth
	p.BottomSurface = Enum.SurfaceType.Smooth
	p.Parent = parent
	return p
end

local function makeBall(parent, name, diameter, position, color, material)
	local p = makePart(parent, name, Vector3.new(diameter, diameter, diameter), CFrame.new(position), color, material)
	p.Shape = Enum.PartType.Ball
	return p
end

local function makeCylinder(parent, name, size, cf, color, material)
	local p = makePart(parent, name, size, cf * CFrame.Angles(0, 0, math.rad(90)), color, material)
	p.Shape = Enum.PartType.Cylinder
	return p
end

local function addPointLight(parent, color, range, brightness)
	local light = Instance.new("PointLight")
	light.Color = color
	light.Range = range or 14
	light.Brightness = brightness or 1
	light.Parent = parent
	return light
end

local function addBillboard(parent, value, color, width, height, offset, strokeColor)
	local gui = Instance.new("BillboardGui")
	gui.Size = UDim2.fromOffset(width or 240, height or 60)
	gui.StudsOffset = offset or Vector3.new(0, 5, 0)
	gui.AlwaysOnTop = true
	gui.MaxDistance = 260
	gui.Parent = parent

	local label = Instance.new("TextLabel")
	label.Name = "Label"
	label.Size = UDim2.fromScale(1, 1)
	label.BackgroundTransparency = 1
	label.Text = value
	label.TextColor3 = color or Color3.new(1, 1, 1)
	label.TextStrokeColor3 = strokeColor or Color3.fromRGB(35, 35, 35)
	label.TextStrokeTransparency = 0.2
	label.TextScaled = true
	label.Font = Enum.Font.GothamBlack
	label.Parent = gui
	return label
end

local function addPrompt(parent, actionText, objectText, hold)
	local prompt = Instance.new("ProximityPrompt")
	prompt.ActionText = actionText
	prompt.ObjectText = objectText
	prompt.HoldDuration = hold or 0.4
	prompt.MaxActivationDistance = 12
	prompt.RequiresLineOfSight = false
	prompt.KeyboardKeyCode = Enum.KeyCode.E
	prompt.Parent = parent
	return prompt
end

local function japaneseRoof(parent, center, width, depth, y, roofColor)
	local left = makePart(
		parent,
		"RoofLeft",
		Vector3.new(width / 2 + 3, 1.5, depth + 5),
		CFrame.new(center + Vector3.new(-width / 4, y, 0)) * CFrame.Angles(0, 0, math.rad(-18)),
		roofColor,
		Enum.Material.Slate
	)
	local right = makePart(
		parent,
		"RoofRight",
		Vector3.new(width / 2 + 3, 1.5, depth + 5),
		CFrame.new(center + Vector3.new(width / 4, y, 0)) * CFrame.Angles(0, 0, math.rad(18)),
		roofColor,
		Enum.Material.Slate
	)
	left.CanCollide = false
	right.CanCollide = false

	makePart(parent, "RoofRidge", Vector3.new(2.2, 2.2, depth + 7), CFrame.new(center + Vector3.new(0, y + 2.2, 0)), roofColor, Enum.Material.Slate)
end

local function japaneseHouse(parent, position, bodyColor, roofColor, accentColor, scale)
	scale = scale or 1
	local width = 24 * scale
	local depth = 18 * scale
	local height = 13 * scale

	makePart(parent, "HouseBody", Vector3.new(width, height, depth), CFrame.new(position + Vector3.new(0, height / 2, 0)), bodyColor, Enum.Material.WoodPlanks)
	makePart(parent, "HouseFoundation", Vector3.new(width + 3, 1.2, depth + 3), CFrame.new(position + Vector3.new(0, 0.6, 0)), Color3.fromRGB(117, 100, 82), Enum.Material.Slate)
	makePart(parent, "Door", Vector3.new(5 * scale, 8 * scale, 0.7), CFrame.new(position + Vector3.new(0, 4 * scale, -depth / 2 - 0.4)), Color3.fromRGB(82, 54, 40), Enum.Material.Wood)

	for _, x in ipairs({-7, 7}) do
		local window = makePart(parent, "Window", Vector3.new(4.4 * scale, 4.4 * scale, 0.5), CFrame.new(position + Vector3.new(x * scale, 7 * scale, -depth / 2 - 0.5)), Color3.fromRGB(174, 225, 238), Enum.Material.Glass, 0.25)
		addPointLight(window, accentColor, 8, 0.35)
	end

	japaneseRoof(parent, position, width, depth, height + 2.5 * scale, roofColor)
	makePart(parent, "AccentBeam", Vector3.new(width - 2, 0.7, 0.7), CFrame.new(position + Vector3.new(0, height - 2, -depth / 2 - 0.6)), accentColor, Enum.Material.Neon)
end

local function makeSakura(parent, position, scale)
	scale = scale or 1
	makePart(parent, "SakuraTrunk", Vector3.new(3 * scale, 15 * scale, 3 * scale), CFrame.new(position + Vector3.new(0, 7.5 * scale, 0)), Color3.fromRGB(111, 76, 56), Enum.Material.Wood)

	local blossom = Color3.fromRGB(255, 154, 211)
	local offsets = {
		Vector3.new(0, 16, 0),
		Vector3.new(5, 14, 1),
		Vector3.new(-5, 14, -1),
		Vector3.new(2, 14, 5),
		Vector3.new(-2, 15, -5),
	}
	for _, offset in ipairs(offsets) do
		local crown = makeBall(parent, "SakuraBlossom", 9 * scale, position + offset * scale, blossom, Enum.Material.SmoothPlastic)
		crown.CanCollide = false
	end
end

local function makePine(parent, position, scale)
	scale = scale or 1
	makePart(parent, "PineTrunk", Vector3.new(2.4 * scale, 12 * scale, 2.4 * scale), CFrame.new(position + Vector3.new(0, 6 * scale, 0)), Color3.fromRGB(91, 67, 48), Enum.Material.Wood)
	for level = 1, 3 do
		local diameter = (14 - level * 2) * scale
		local crown = makeBall(parent, "PineCrown", diameter, position + Vector3.new(0, (10 + level * 4) * scale, 0), Color3.fromRGB(60, 126, 73), Enum.Material.Grass)
		crown.Size = Vector3.new(diameter, diameter * 0.7, diameter)
		crown.CanCollide = false
	end
end

local function makeLantern(parent, position)
	makePart(parent, "LanternPost", Vector3.new(0.8, 8, 0.8), CFrame.new(position + Vector3.new(0, 4, 0)), Color3.fromRGB(73, 51, 39), Enum.Material.Wood)
	local lamp = makePart(parent, "LanternLamp", Vector3.new(3, 3.6, 3), CFrame.new(position + Vector3.new(0, 8.2, 0)), Color3.fromRGB(255, 194, 96), Enum.Material.Neon)
	addPointLight(lamp, lamp.Color, 15, 1.5)
	makePart(parent, "LanternCap", Vector3.new(4, 0.7, 4), CFrame.new(position + Vector3.new(0, 10.2, 0)), Color3.fromRGB(50, 51, 58), Enum.Material.Slate)
end

local function makeFence(parent, center, length, alongX)
	local wood = Color3.fromRGB(153, 91, 52)
	local spacing = 9
	local count = math.floor(length / spacing)
	for i = 0, count do
		local offset = -length / 2 + i * spacing
		local pos = center + (alongX and Vector3.new(offset, 2.7, 0) or Vector3.new(0, 2.7, offset))
		makePart(parent, "FencePost", Vector3.new(1.2, 5.4, 1.2), CFrame.new(pos), wood, Enum.Material.Wood)
	end

	for _, y in ipairs({1.7, 3.5}) do
		local size = alongX and Vector3.new(length, 0.8, 0.7) or Vector3.new(0.7, 0.8, length)
		makePart(parent, "FenceRail", size, CFrame.new(center + Vector3.new(0, y, 0)), wood, Enum.Material.Wood)
	end
end

local function makeTorii(parent, center, scale)
	scale = scale or 1
	local red = Color3.fromRGB(202, 49, 47)
	local dark = Color3.fromRGB(56, 49, 50)
	makePart(parent, "ToriiLeft", Vector3.new(3 * scale, 23 * scale, 3 * scale), CFrame.new(center + Vector3.new(-10 * scale, 11.5 * scale, 0)), red, Enum.Material.Wood)
	makePart(parent, "ToriiRight", Vector3.new(3 * scale, 23 * scale, 3 * scale), CFrame.new(center + Vector3.new(10 * scale, 11.5 * scale, 0)), red, Enum.Material.Wood)
	makePart(parent, "ToriiBeam", Vector3.new(28 * scale, 3 * scale, 4 * scale), CFrame.new(center + Vector3.new(0, 21 * scale, 0)), red, Enum.Material.Wood)
	makePart(parent, "ToriiTop", Vector3.new(34 * scale, 2 * scale, 4.5 * scale), CFrame.new(center + Vector3.new(0, 24 * scale, 0)), dark, Enum.Material.Slate)
end

local function makeRamenShop(parent, center)
	local body = Color3.fromRGB(244, 203, 133)
	local red = Color3.fromRGB(205, 50, 45)
	japaneseHouse(parent, center, body, Color3.fromRGB(60, 63, 70), red, 1.1)
	local sign = makePart(parent, "RamenSign", Vector3.new(13, 4, 1), CFrame.new(center + Vector3.new(0, 11, -11)), red, Enum.Material.SmoothPlastic)
	local gui = Instance.new("SurfaceGui")
	gui.Face = Enum.NormalId.Front
	gui.Parent = sign
	local t = Instance.new("TextLabel")
	t.Size = UDim2.fromScale(1, 1)
	t.BackgroundTransparency = 1
	t.Text = "RAMEN"
	t.TextColor3 = Color3.fromRGB(255, 239, 187)
	t.TextScaled = true
	t.Font = Enum.Font.GothamBlack
	t.Parent = gui
end

local function makeTrainingGround(parent, center)
	local ground = makePart(parent, "TrainingGround", Vector3.new(62, 0.7, 52), CFrame.new(center), Color3.fromRGB(153, 114, 69), Enum.Material.Ground)
	ground.TopSurface = Enum.SurfaceType.Studs
	makeFence(parent, center + Vector3.new(0, 0.3, -26), 62, true)
	makeFence(parent, center + Vector3.new(0, 0.3, 26), 62, true)
	makeFence(parent, center + Vector3.new(-31, 0.3, 0), 52, false)
	makeFence(parent, center + Vector3.new(31, 0.3, 0), 52, false)

	for _, x in ipairs({-15, 0, 15}) do
		makePart(parent, "TrainingLog", Vector3.new(3, 12, 3), CFrame.new(center + Vector3.new(x, 6, 8)), Color3.fromRGB(112, 77, 52), Enum.Material.Wood)
		local target = makeCylinder(parent, "Target", Vector3.new(1, 8, 8), CFrame.new(center + Vector3.new(x, 8, -10)), Color3.fromRGB(235, 228, 209), Enum.Material.Wood)
		target.CanCollide = false
		local ring = makeCylinder(parent, "TargetRing", Vector3.new(1.2, 4.5, 4.5), target.CFrame * CFrame.new(-0.6, 0, 0), Color3.fromRGB(204, 58, 55), Enum.Material.Neon)
		ring.CanCollide = false
	end
end

local function makeVillageTower(parent, center)
	for level = 1, 4 do
		local radius = 18 - (level - 1) * 2
		local y = 6 + (level - 1) * 9
		makeCylinder(parent, "TowerBody", Vector3.new(8, radius * 2, radius * 2), CFrame.new(center + Vector3.new(0, y, 0)), Color3.fromRGB(227, 203, 164), Enum.Material.Brick)
		makeCylinder(parent, "TowerRoof", Vector3.new(2, (radius + 4) * 2, (radius + 4) * 2), CFrame.new(center + Vector3.new(0, y + 5, 0)), Color3.fromRGB(180, 55, 48), Enum.Material.Slate)
	end
	local anchor = makePart(parent, "TowerSign", Vector3.new(1, 1, 1), CFrame.new(center + Vector3.new(0, 43, 0)), Color3.new(1,1,1), Enum.Material.Neon, 1)
	addBillboard(anchor, "HOKAGE TOWER", Color3.fromRGB(255, 217, 95), 260, 52, Vector3.new())
end

local function makeMonumentFaces(parent, cliffCenter)
	local names = {"FIRE", "LEAF", "WILL", "HERO"}
	for i = 1, 4 do
		local x = -54 + (i - 1) * 36
		local center = cliffCenter + Vector3.new(x, 26 + (i % 2) * 4, -2)
		local head = makeBall(parent, "StoneFace", 24, center, Color3.fromRGB(112, 107, 96), Enum.Material.Rock)
		head.Size = Vector3.new(22, 28, 10)
		local nose = makePart(parent, "StoneNose", Vector3.new(4, 4, 7), CFrame.new(center + Vector3.new(0, -1, -6)), Color3.fromRGB(124, 118, 105), Enum.Material.Rock)
		local brow = makePart(parent, "StoneBrow", Vector3.new(14, 3, 3), CFrame.new(center + Vector3.new(0, 5, -5)), Color3.fromRGB(94, 91, 84), Enum.Material.Rock)
		brow.CanCollide = false
		addBillboard(head, names[i], Color3.fromRGB(231, 222, 195), 120, 28, Vector3.new(0, 16, 0))
	end
end

local function makeStatue(parent, center, name, outfit, accent, hairColor)
	local model = Instance.new("Model")
	model.Name = name .. "Statue"
	model.Parent = parent

	makePart(model, "LegL", Vector3.new(5, 17, 5), CFrame.new(center + Vector3.new(-4, 8.5, 0)), Color3.fromRGB(47, 50, 61), Enum.Material.SmoothPlastic)
	makePart(model, "LegR", Vector3.new(5, 17, 5), CFrame.new(center + Vector3.new(4, 8.5, 0)), Color3.fromRGB(47, 50, 61), Enum.Material.SmoothPlastic)
	makePart(model, "Torso", Vector3.new(15, 19, 8), CFrame.new(center + Vector3.new(0, 24, 0)), outfit, Enum.Material.SmoothPlastic)
	makePart(model, "ArmL", Vector3.new(4.5, 18, 4.5), CFrame.new(center + Vector3.new(-10, 25, 0)) * CFrame.Angles(0, 0, math.rad(-14)), Color3.fromRGB(239, 196, 160), Enum.Material.SmoothPlastic)
	makePart(model, "ArmR", Vector3.new(4.5, 18, 4.5), CFrame.new(center + Vector3.new(10, 25, 0)) * CFrame.Angles(0, 0, math.rad(14)), Color3.fromRGB(239, 196, 160), Enum.Material.SmoothPlastic)
	local head = makeBall(model, "Head", 12, center + Vector3.new(0, 39, 0), Color3.fromRGB(239, 196, 160), Enum.Material.SmoothPlastic)
	local hair = makeBall(model, "Hair", 13, center + Vector3.new(0, 43, 0), hairColor, Enum.Material.SmoothPlastic)
	hair.Size = Vector3.new(13, 7, 13)
	local aura = makePart(model, "Aura", Vector3.new(28, 0.4, 28), CFrame.new(center + Vector3.new(0, 0.3, 0)), accent, Enum.Material.Neon, 0.22)
	addPointLight(aura, accent, 24, 2)

	local tag = makePart(model, "Tag", Vector3.new(1,1,1), CFrame.new(center + Vector3.new(0, 51, 0)), accent, Enum.Material.Neon, 1)
	addBillboard(tag, name, accent, 230, 48, Vector3.new())
	return model
end

local function makeBase(parent, index, center, accent)
	local model = Instance.new("Model")
	model.Name = "PlayerBase_" .. index
	model.Parent = parent

	local floor = makePart(model, "Floor", Vector3.new(44, 1, 36), CFrame.new(center), Color3.fromRGB(88, 192, 76), Enum.Material.Grass)
	floor.TopSurface = Enum.SurfaceType.Studs

	local back = makePart(model, "BackWall", Vector3.new(44, 9, 1.2), CFrame.new(center + Vector3.new(0, 4.5, 18)), Color3.fromRGB(246, 220, 173), Enum.Material.Brick)
	makePart(model, "BackTrim", Vector3.new(44, 0.8, 1.5), CFrame.new(center + Vector3.new(0, 8.5, 17.6)), accent, Enum.Material.Neon)

	makeFence(model, center + Vector3.new(-22, 0.2, 0), 36, false)
	makeFence(model, center + Vector3.new(22, 0.2, 0), 36, false)

	local signAnchor = makePart(model, "SignAnchor", Vector3.new(1,1,1), CFrame.new(center + Vector3.new(0, 10.5, 17)), accent, Enum.Material.Neon, 1)
	local signLabel = addBillboard(signAnchor, "BASE LIBRE", accent, 230, 50, Vector3.new())

	local deposit = makePart(model, "Deposit", Vector3.new(13, 0.7, 8), CFrame.new(center + Vector3.new(0, 0.9, -12.5)), accent, Enum.Material.Neon, 0.08)
	addBillboard(deposit, "DEPOSE L'OEUF", Color3.new(1,1,1), 160, 30, Vector3.new(0, 2.5, 0))

	local training = makePart(model, "TrainingPad", Vector3.new(12, 0.7, 8), CFrame.new(center + Vector3.new(-14, 0.9, -1)), Color3.fromRGB(67, 200, 255), Enum.Material.Neon, 0.05)
	for x = -4, 4, 2 do
		makePart(model, "TreadLine", Vector3.new(0.5, 0.15, 7), CFrame.new(training.Position + Vector3.new(x, 0.45, 0)), Color3.fromRGB(230, 250, 255), Enum.Material.Neon)
	end
	addBillboard(training, "SPEED", Color3.fromRGB(86, 215, 255), 110, 28, Vector3.new(0, 2.4, 0))

	local baseTerminal = makePart(model, "BaseTerminal", Vector3.new(4.5, 5.5, 4.5), CFrame.new(center + Vector3.new(14, 3, -5)), accent, Enum.Material.Metal)
	local basePrompt = addPrompt(baseTerminal, "AMELIORER", "Base")
	addBillboard(baseTerminal, "UPGRADE", accent, 120, 28, Vector3.new(0, 4.2, 0))

	local trainTerminal = makePart(model, "TrainTerminal", Vector3.new(4.5, 5.5, 4.5), CFrame.new(center + Vector3.new(14, 3, 3)), Color3.fromRGB(67, 200, 255), Enum.Material.Metal)
	local trainPrompt = addPrompt(trainTerminal, "AMELIORER", "Speed")
	addBillboard(trainTerminal, "TAPIS", Color3.fromRGB(67, 200, 255), 110, 28, Vector3.new(0, 4.2, 0))

	local shieldTerminal = makePart(model, "ShieldTerminal", Vector3.new(4.5, 5.5, 4.5), CFrame.new(center + Vector3.new(-14, 3, 9)), Color3.fromRGB(120, 230, 255), Enum.Material.Metal)
	local shieldPrompt = addPrompt(shieldTerminal, "ACTIVER", "Bouclier")
	addBillboard(shieldTerminal, "SHIELD", Color3.fromRGB(120, 230, 255), 110, 28, Vector3.new(0, 4.2, 0))

	local heroFolder = Instance.new("Folder")
	heroFolder.Name = "Heroes"
	heroFolder.Parent = model

	local standPositions = {}
	for row = 0, 2 do
		for col = 0, 3 do
			local x = -12 + col * 8
			local z = 5 + row * 5
			local stand = makeCylinder(model, "HeroStand", Vector3.new(1, 6, 6), CFrame.new(center + Vector3.new(x, 0.9, z)), Color3.fromRGB(227, 220, 204), Enum.Material.Concrete)
			table.insert(standPositions, CFrame.new(center + Vector3.new(x, 3.2, z)))
		end
	end

	local shieldWalls = {
		makePart(model, "ShieldFront", Vector3.new(44, 12, 1), CFrame.new(center + Vector3.new(0, 6, -18)), Color3.fromRGB(88, 226, 255), Enum.Material.ForceField, 1),
		makePart(model, "ShieldBack", Vector3.new(44, 12, 1), CFrame.new(center + Vector3.new(0, 6, 18)), Color3.fromRGB(88, 226, 255), Enum.Material.ForceField, 1),
		makePart(model, "ShieldLeft", Vector3.new(1, 12, 36), CFrame.new(center + Vector3.new(-22, 6, 0)), Color3.fromRGB(88, 226, 255), Enum.Material.ForceField, 1),
		makePart(model, "ShieldRight", Vector3.new(1, 12, 36), CFrame.new(center + Vector3.new(22, 6, 0)), Color3.fromRGB(88, 226, 255), Enum.Material.ForceField, 1),
	}
	for _, wall in ipairs(shieldWalls) do
		wall.CanCollide = false
	end

	return {
		Index = index,
		Model = model,
		Position = center,
		Accent = accent,
		SignLabel = signLabel,
		Deposit = deposit,
		TrainingPad = training,
		BasePrompt = basePrompt,
		TrainingPrompt = trainPrompt,
		ShieldPrompt = shieldPrompt,
		ShieldWalls = shieldWalls,
		HeroFolder = heroFolder,
		StandPositions = standPositions,
	}
end

local function makeEggShrine(parent, position, index, accent)
	local model = Instance.new("Model")
	model.Name = "EggShrine_" .. index
	model.Parent = parent

	local pedestal = makeCylinder(model, "Pedestal", Vector3.new(4, 13, 13), CFrame.new(position), Color3.fromRGB(114, 105, 93), Enum.Material.Slate)
	local ring = makeCylinder(model, "GlowRing", Vector3.new(0.7, 15, 15), CFrame.new(position + Vector3.new(0, 2.4, 0)), accent, Enum.Material.Neon)
	ring.Transparency = 0.08

	local egg = makePart(model, "Egg", Vector3.new(6, 8, 6), CFrame.new(position + Vector3.new(0, 7, 0)), Color3.fromRGB(235, 238, 244), Enum.Material.SmoothPlastic)
	egg.Shape = Enum.PartType.Ball
	egg.CanCollide = false
	addPointLight(egg, accent, 18, 2)

	local prompt = addPrompt(egg, "VOLER", "Oeuf Ninja", 0.55)
	addBillboard(egg, "OEUF NINJA", accent, 160, 32, Vector3.new(0, 6, 0))

	return {
		Model = model,
		Egg = egg,
		Prompt = prompt,
		Accent = accent,
	}
end

function WorldBuilder.Build(Config)
	local old = workspace:FindFirstChild("AnimeEggWorld")
	if old then
		old:Destroy()
	end

	Terrain:Clear()

	local world = Instance.new("Model")
	world.Name = "AnimeEggWorld"
	world.Parent = workspace

	workspace.FallenPartsDestroyHeight = -100

	Lighting.ClockTime = 13.7
	Lighting.Brightness = 2.8
	Lighting.Ambient = Color3.fromRGB(145, 148, 158)
	Lighting.OutdoorAmbient = Color3.fromRGB(185, 190, 202)
	Lighting.EnvironmentDiffuseScale = 0.5
	Lighting.EnvironmentSpecularScale = 0.7

	for _, effectName in ipairs({"AnimeBloom", "AnimeColor", "AnimeAtmosphere", "AnimeSunRays"}) do
		local existing = Lighting:FindFirstChild(effectName)
		if existing then existing:Destroy() end
	end

	local bloom = Instance.new("BloomEffect")
	bloom.Name = "AnimeBloom"
	bloom.Intensity = 0.3
	bloom.Size = 24
	bloom.Threshold = 1.5
	bloom.Parent = Lighting

	local correction = Instance.new("ColorCorrectionEffect")
	correction.Name = "AnimeColor"
	correction.Saturation = 0.18
	correction.Contrast = 0.05
	correction.Brightness = 0.03
	correction.Parent = Lighting

	local atmosphere = Instance.new("Atmosphere")
	atmosphere.Name = "AnimeAtmosphere"
	atmosphere.Density = 0.16
	atmosphere.Offset = 0.1
	atmosphere.Color = Color3.fromRGB(208, 230, 255)
	atmosphere.Decay = Color3.fromRGB(123, 159, 191)
	atmosphere.Haze = 0.55
	atmosphere.Glare = 0.06
	atmosphere.Parent = Lighting

	local rays = Instance.new("SunRaysEffect")
	rays.Name = "AnimeSunRays"
	rays.Intensity = 0.07
	rays.Spread = 0.7
	rays.Parent = Lighting

	local clouds = Instance.new("Clouds")
	clouds.Cover = 0.27
	clouds.Density = 0.32
	clouds.Color = Color3.fromRGB(255, 255, 255)
	clouds.Parent = Terrain

	-- Terrain: large continuous hub + shinobi world.
	Terrain:FillBlock(CFrame.new(0, -4, -125), Vector3.new(300, 10, 230), Enum.Material.Grass)
	Terrain:FillBlock(CFrame.new(0, -4, 145), Vector3.new(300, 10, 360), Enum.Material.Grass)
	Terrain:FillBlock(CFrame.new(0, -5, 350), Vector3.new(300, 12, 70), Enum.Material.Rock)

	-- Hills and mountain walls.
	for _, info in ipairs({
		{Vector3.new(-145, 25, 130), 48},
		{Vector3.new(145, 25, 130), 48},
		{Vector3.new(-148, 35, 260), 60},
		{Vector3.new(148, 35, 260), 60},
		{Vector3.new(-105, 42, 360), 65},
		{Vector3.new(105, 42, 360), 65},
		{Vector3.new(0, 52, 380), 85},
	}) do
		Terrain:FillBall(info[1], info[2], Enum.Material.Rock)
		Terrain:FillBall(info[1] + Vector3.new(0, info[2] * 0.12, 0), info[2] * 0.92, Enum.Material.Grass)
	end

	-- River with two bridges.
	Terrain:FillBlock(CFrame.new(72, -1, 160), Vector3.new(22, 5, 300), Enum.Material.Water)
	for _, z in ipairs({85, 230}) do
		makePart(world, "BridgeDeck", Vector3.new(34, 1.2, 16), CFrame.new(72, 2.2, z), Color3.fromRGB(144, 92, 54), Enum.Material.WoodPlanks)
		for x = 58, 86, 7 do
			makePart(world, "BridgeRailPost", Vector3.new(0.7, 4, 0.7), CFrame.new(x, 4, z - 7), Color3.fromRGB(94, 61, 43), Enum.Material.Wood)
			makePart(world, "BridgeRailPost", Vector3.new(0.7, 4, 0.7), CFrame.new(x, 4, z + 7), Color3.fromRGB(94, 61, 43), Enum.Material.Wood)
		end
		makePart(world, "BridgeRail", Vector3.new(34, 0.6, 0.6), CFrame.new(72, 5.4, z - 7), Color3.fromRGB(94, 61, 43), Enum.Material.Wood)
		makePart(world, "BridgeRail", Vector3.new(34, 0.6, 0.6), CFrame.new(72, 5.4, z + 7), Color3.fromRGB(94, 61, 43), Enum.Material.Wood)
	end

	-- Main roads.
	local hubRoad = makePart(world, "HubRoad", Vector3.new(38, 0.5, 205), CFrame.new(0, 1, -118), Color3.fromRGB(216, 200, 166), Enum.Material.Sand)
	hubRoad.TopSurface = Enum.SurfaceType.Studs
	local villageRoad = makePart(world, "VillageRoad", Vector3.new(34, 0.5, 365), CFrame.new(0, 1, 150), Color3.fromRGB(201, 187, 158), Enum.Material.Sand)
	villageRoad.TopSurface = Enum.SurfaceType.Studs

	for z = -210, 320, 15 do
		makePart(world, "RoadStoneL", Vector3.new(2.2, 0.3, 8), CFrame.new(-18.2, 1.25, z), Color3.fromRGB(129, 121, 107), Enum.Material.Slate)
		makePart(world, "RoadStoneR", Vector3.new(2.2, 0.3, 8), CFrame.new(18.2, 1.25, z), Color3.fromRGB(129, 121, 107), Enum.Material.Slate)
	end

	-- Hub header and decoration.
	local hubAnchor = makePart(world, "HubTitle", Vector3.new(1,1,1), CFrame.new(0, 18, -214), Color3.new(1,1,1), Enum.Material.Neon, 1)
	addBillboard(hubAnchor, "ANIME EGG HEIST", Color3.fromRGB(255, 221, 78), 430, 78, Vector3.new())
	makeTorii(world, Vector3.new(0, 1, -20), 1.25)

	for _, pos in ipairs({
		Vector3.new(-125, 1, -190), Vector3.new(125, 1, -190),
		Vector3.new(-125, 1, -125), Vector3.new(125, 1, -125),
		Vector3.new(-125, 1, -60), Vector3.new(125, 1, -60),
	}) do
		makeSakura(world, pos, 0.9)
	end

	for z = -205, -35, 24 do
		makeLantern(world, Vector3.new(-25, 1, z))
		makeLantern(world, Vector3.new(25, 1, z))
	end

	local baseColors = {
		Color3.fromRGB(255, 92, 103),
		Color3.fromRGB(255, 160, 60),
		Color3.fromRGB(255, 217, 67),
		Color3.fromRGB(76, 222, 103),
		Color3.fromRGB(62, 178, 255),
		Color3.fromRGB(137, 92, 255),
		Color3.fromRGB(235, 81, 207),
		Color3.fromRGB(77, 218, 213),
	}

	local bases = {}
	local baseZs = {-190, -145, -100, -55}
	for i, z in ipairs(baseZs) do
		table.insert(bases, makeBase(world, i, Vector3.new(-92, 1, z), baseColors[i]))
	end
	for i, z in ipairs(baseZs) do
		local index = i + 4
		table.insert(bases, makeBase(world, index, Vector3.new(92, 1, z), baseColors[index]))
	end

	-- Village gate.
	local gateModel = Instance.new("Model")
	gateModel.Name = "KonohaGate"
	gateModel.Parent = world
	makePart(gateModel, "GateTowerLeft", Vector3.new(20, 26, 18), CFrame.new(-31, 13, 5), Color3.fromRGB(223, 197, 153), Enum.Material.Brick)
	makePart(gateModel, "GateTowerRight", Vector3.new(20, 26, 18), CFrame.new(31, 13, 5), Color3.fromRGB(223, 197, 153), Enum.Material.Brick)
	japaneseRoof(gateModel, Vector3.new(-31, 0, 5), 23, 20, 29, Color3.fromRGB(72, 75, 82))
	japaneseRoof(gateModel, Vector3.new(31, 0, 5), 23, 20, 29, Color3.fromRGB(72, 75, 82))
	makePart(gateModel, "GateBeam", Vector3.new(44, 5, 8), CFrame.new(0, 24, 5), Color3.fromRGB(190, 53, 48), Enum.Material.Wood)
	local gateSign = makePart(gateModel, "GateSign", Vector3.new(22, 7, 1), CFrame.new(0, 24, 0.5), Color3.fromRGB(67, 61, 55), Enum.Material.Wood)
	local surface = Instance.new("SurfaceGui")
	surface.Face = Enum.NormalId.Front
	surface.Parent = gateSign
	local gateText = Instance.new("TextLabel")
	gateText.Size = UDim2.fromScale(1,1)
	gateText.BackgroundTransparency = 1
	gateText.Text = "NARUTO SHIPPUDEN"
	gateText.TextColor3 = Color3.fromRGB(255, 221, 104)
	gateText.TextScaled = true
	gateText.Font = Enum.Font.GothamBlack
	gateText.Parent = surface

	-- Dense village buildings.
	local houses = {
		{Vector3.new(-58,1,48), Color3.fromRGB(238,211,167), Color3.fromRGB(65,69,77), Color3.fromRGB(210,64,53), 1.0},
		{Vector3.new(-96,1,84), Color3.fromRGB(232,205,166), Color3.fromRGB(72,67,71), Color3.fromRGB(255,183,64), 0.9},
		{Vector3.new(-58,1,126), Color3.fromRGB(225,213,178), Color3.fromRGB(59,68,73), Color3.fromRGB(79,178,255), 1.05},
		{Vector3.new(-101,1,162), Color3.fromRGB(238,215,176), Color3.fromRGB(71,66,72), Color3.fromRGB(218,81,65), 0.95},
		{Vector3.new(-54,1,208), Color3.fromRGB(231,205,168), Color3.fromRGB(68,72,80), Color3.fromRGB(151,88,255), 1.1},
		{Vector3.new(53,1,48), Color3.fromRGB(237,210,168), Color3.fromRGB(65,69,77), Color3.fromRGB(255,122,77), 0.95},
		{Vector3.new(105,1,82), Color3.fromRGB(233,207,169), Color3.fromRGB(75,68,73), Color3.fromRGB(77,208,135), 1.0},
		{Vector3.new(53,1,132), Color3.fromRGB(236,210,174), Color3.fromRGB(64,71,79), Color3.fromRGB(225,71,90), 1.05},
		{Vector3.new(103,1,180), Color3.fromRGB(232,208,173), Color3.fromRGB(70,67,75), Color3.fromRGB(68,175,255), 0.92},
	}
	for _, h in ipairs(houses) do
		japaneseHouse(world, h[1], h[2], h[3], h[4], h[5])
	end

	makeRamenShop(world, Vector3.new(63, 1, 92))
	makeTrainingGround(world, Vector3.new(-78, 1.2, 95))
	makeVillageTower(world, Vector3.new(-82, 1, 252))

	-- Park and foliage.
	for _, pos in ipairs({
		Vector3.new(-122,1,34), Vector3.new(-125,1,135), Vector3.new(-120,1,225),
		Vector3.new(122,1,38), Vector3.new(123,1,142), Vector3.new(120,1,250),
		Vector3.new(-36,1,63), Vector3.new(37,1,171), Vector3.new(-38,1,237),
	}) do
		makeSakura(world, pos, 0.9 + math.random() * 0.25)
	end

	for _, pos in ipairs({
		Vector3.new(-132,1,280), Vector3.new(-105,1,307), Vector3.new(115,1,302),
		Vector3.new(135,1,260), Vector3.new(-126,1,195), Vector3.new(132,1,205),
	}) do
		makePine(world, pos, 1.0)
	end

	-- Egg shrine: three clear steal targets.
	local shrineFloor = makePart(world, "EggShrineFloor", Vector3.new(100, 1, 72), CFrame.new(0, 1.2, 282), Color3.fromRGB(116, 106, 92), Enum.Material.Slate)
	shrineFloor.TopSurface = Enum.SurfaceType.Studs
	makeTorii(world, Vector3.new(0, 1, 247), 0.95)

	local eggs = {
		makeEggShrine(world, Vector3.new(-30, 3, 285), 1, Color3.fromRGB(73, 175, 255)),
		makeEggShrine(world, Vector3.new(0, 3, 295), 2, Color3.fromRGB(182, 86, 255)),
		makeEggShrine(world, Vector3.new(30, 3, 285), 3, Color3.fromRGB(255, 181, 54)),
	}

	makeStatue(world, Vector3.new(-79, 1, 292), "NINJA HERO", Color3.fromRGB(234, 119, 32), Color3.fromRGB(255, 173, 48), Color3.fromRGB(244, 196, 53))
	makeStatue(world, Vector3.new(79, 1, 292), "NINJA RIVAL", Color3.fromRGB(49, 70, 112), Color3.fromRGB(113, 108, 255), Color3.fromRGB(35, 38, 48))

	-- Mountain monument.
	local cliff = makePart(world, "MonumentCliff", Vector3.new(190, 70, 18), CFrame.new(0, 32, 350), Color3.fromRGB(106, 103, 96), Enum.Material.Rock)
	makeMonumentFaces(world, cliff.Position + Vector3.new(0, 0, -10))

	local worldTitle = makePart(world, "WorldTitle", Vector3.new(1,1,1), CFrame.new(0, 36, 34), Color3.new(1,1,1), Enum.Material.Neon, 1)
	addBillboard(worldTitle, "SHINOBI WORLD", Color3.fromRGB(255, 212, 75), 340, 72, Vector3.new())

	local spawn = Instance.new("SpawnLocation")
	spawn.Name = "MainSpawn"
	spawn.Anchored = true
	spawn.Neutral = true
	spawn.Size = Vector3.new(14, 1, 14)
	spawn.CFrame = CFrame.new(0, 3, -205)
	spawn.Color = Color3.fromRGB(72, 215, 91)
	spawn.Material = Enum.Material.Neon
	spawn.Parent = world
	addBillboard(spawn, "SPAWN", Color3.fromRGB(255,255,255), 100, 26, Vector3.new(0,2.5,0))

	return {
		World = world,
		Bases = bases,
		Eggs = eggs,
		Spawn = spawn,
	}
end

return WorldBuilder
