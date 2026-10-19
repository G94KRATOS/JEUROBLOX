local Lighting = game:GetService("Lighting")

local WorldBuilder = {}

local function part(parent, name, size, cf, color, material, transparency)
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

local function wedge(parent, name, size, cf, color, material, transparency)
	local p = Instance.new("WedgePart")
	p.Name = name
	p.Anchored = true
	p.Size = size
	p.CFrame = cf
	p.Color = color
	p.Material = material or Enum.Material.SmoothPlastic
	p.Transparency = transparency or 0
	p.Parent = parent
	return p
end

local function ball(parent, name, diameter, pos, color, material, transparency)
	local p = part(parent, name, Vector3.new(diameter, diameter, diameter), CFrame.new(pos), color, material, transparency)
	p.Shape = Enum.PartType.Ball
	return p
end

local function cylinder(parent, name, diameter, height, cf, color, material, transparency)
	local p = part(parent, name, Vector3.new(height, diameter, diameter), cf * CFrame.Angles(0, 0, math.rad(90)), color, material, transparency)
	p.Shape = Enum.PartType.Cylinder
	return p
end

local function pointLight(parent, color, range, brightness)
	local l = Instance.new("PointLight")
	l.Color = color
	l.Range = range or 14
	l.Brightness = brightness or 1
	l.Parent = parent
	return l
end

local function floatingLabel(parent, value, color, width, height, offset, maxDistance)
	local gui = Instance.new("BillboardGui")
	gui.Size = UDim2.fromOffset(width or 220, height or 50)
	gui.StudsOffset = offset or Vector3.new(0, 5, 0)
	gui.AlwaysOnTop = false
	gui.MaxDistance = maxDistance or 120
	gui.Parent = parent

	local label = Instance.new("TextLabel")
	label.Name = "Label"
	label.Size = UDim2.fromScale(1, 1)
	label.BackgroundTransparency = 1
	label.Text = value
	label.TextColor3 = color or Color3.new(1, 1, 1)
	label.TextStrokeColor3 = Color3.fromRGB(25, 25, 30)
	label.TextStrokeTransparency = 0.2
	label.TextScaled = true
	label.Font = Enum.Font.GothamBlack
	label.Parent = gui
	return label
end

local function surfaceLabel(parent, face, value, color, background)
	local gui = Instance.new("SurfaceGui")
	gui.Face = face
	gui.AlwaysOnTop = false
	gui.LightInfluence = 0
	gui.Parent = parent

	local frame = Instance.new("Frame")
	frame.Size = UDim2.fromScale(1, 1)
	frame.BackgroundColor3 = background or Color3.fromRGB(28, 31, 38)
	frame.BackgroundTransparency = 0.08
	frame.Parent = gui

	local label = Instance.new("TextLabel")
	label.Name = "Label"
	label.Size = UDim2.new(1, -16, 1, -12)
	label.Position = UDim2.fromOffset(8, 6)
	label.BackgroundTransparency = 1
	label.Text = value
	label.TextColor3 = color or Color3.new(1, 1, 1)
	label.TextScaled = true
	label.Font = Enum.Font.GothamBlack
	label.TextStrokeTransparency = 0.8
	label.Parent = frame
	return label
end

local function prompt(parent, action, object, hold)
	local p = Instance.new("ProximityPrompt")
	p.ActionText = action
	p.ObjectText = object
	p.HoldDuration = hold or 0.4
	p.MaxActivationDistance = 12
	p.RequiresLineOfSight = false
	p.KeyboardKeyCode = Enum.KeyCode.E
	p.Parent = parent
	return p
end

local function addHighlight(parent, color)
	local h = Instance.new("Highlight")
	h.FillColor = color
	h.FillTransparency = 0.75
	h.OutlineColor = color
	h.OutlineTransparency = 0.08
	h.DepthMode = Enum.HighlightDepthMode.Occluded
	h.Parent = parent
	return h
end

local function lowFence(parent, center, length, alongX, color)
	local wood = color or Color3.fromRGB(132, 77, 45)
	local posts = math.max(2, math.floor(length / 10))
	for i = 0, posts do
		local offset = -length / 2 + i * (length / posts)
		local pos = center + (alongX and Vector3.new(offset, 2.2, 0) or Vector3.new(0, 2.2, offset))
		part(parent, "FencePost", Vector3.new(1.2, 4.4, 1.2), CFrame.new(pos), wood, Enum.Material.Wood)
	end
	for _, y in ipairs({1.4, 3.1}) do
		local size = alongX and Vector3.new(length, 0.7, 0.6) or Vector3.new(0.6, 0.7, length)
		part(parent, "FenceRail", size, CFrame.new(center + Vector3.new(0, y, 0)), wood, Enum.Material.Wood)
	end
end

local function streetLamp(parent, pos, color)
	part(parent, "LampPost", Vector3.new(0.55, 9, 0.55), CFrame.new(pos + Vector3.new(0, 4.5, 0)), Color3.fromRGB(57, 61, 69), Enum.Material.Metal)
	local head = part(parent, "LampHead", Vector3.new(2.8, 1.8, 2.8), CFrame.new(pos + Vector3.new(0, 9.3, 0)), color, Enum.Material.Neon)
	pointLight(head, color, 18, 1.4)
end

local function tree(parent, pos, foliage, scale)
	scale = scale or 1
	part(parent, "Trunk", Vector3.new(2.6 * scale, 13 * scale, 2.6 * scale), CFrame.new(pos + Vector3.new(0, 6.5 * scale, 0)), Color3.fromRGB(93, 64, 46), Enum.Material.Wood)
	for _, off in ipairs({
		Vector3.new(0, 14, 0),
		Vector3.new(4.8, 12.5, 0),
		Vector3.new(-4.8, 12.5, 1),
		Vector3.new(1, 12.5, 4.8),
		Vector3.new(-1, 13, -4.8),
	}) do
		local crown = ball(parent, "Leaves", 8.5 * scale, pos + off * scale, foliage, Enum.Material.Grass)
		crown.CanCollide = false
	end
end

local function palm(parent, pos, scale)
	scale = scale or 1
	local trunk = part(parent, "PalmTrunk", Vector3.new(2.2 * scale, 16 * scale, 2.2 * scale), CFrame.new(pos + Vector3.new(0, 8 * scale, 0)) * CFrame.Angles(0, 0, math.rad(6)), Color3.fromRGB(121, 83, 49), Enum.Material.Wood)
	for i = 1, 7 do
		local angle = math.rad((i - 1) * (360 / 7))
		part(
			parent,
			"PalmLeaf",
			Vector3.new(1.4 * scale, 0.6 * scale, 10 * scale),
			CFrame.new(pos + Vector3.new(math.cos(angle) * 3.6 * scale, 16 * scale, math.sin(angle) * 3.6 * scale)) * CFrame.Angles(math.rad(15), -angle, math.rad(12)),
			Color3.fromRGB(59, 153, 73),
			Enum.Material.Grass
		)
	end
	trunk.CanCollide = true
end

local function bamboo(parent, pos, height)
	height = height or 18
	local green = Color3.fromRGB(59, 127, 70)
	part(parent, "Bamboo", Vector3.new(1.15, height, 1.15), CFrame.new(pos + Vector3.new(0, height / 2, 0)), green, Enum.Material.Wood)
	for y = 4, height - 2, 4 do
		cylinder(parent, "BambooRing", 1.5, 0.28, CFrame.new(pos + Vector3.new(0, y, 0)), Color3.fromRGB(76, 151, 82), Enum.Material.SmoothPlastic)
	end
end

local function rock(parent, pos, size, color)
	local r = part(parent, "Rock", size, CFrame.new(pos) * CFrame.Angles(math.rad(8), math.rad(18), math.rad(5)), color or Color3.fromRGB(103, 95, 84), Enum.Material.Rock)
	return r
end

local function crystal(parent, pos, color, scale)
	scale = scale or 1
	local c = part(parent, "Crystal", Vector3.new(3 * scale, 12 * scale, 3 * scale), CFrame.new(pos + Vector3.new(0, 6 * scale, 0)) * CFrame.Angles(0, 0, math.rad(18)), color, Enum.Material.Neon)
	c.CanCollide = false
	pointLight(c, color, 13 * scale, 0.9)
	return c
end

local function portalGate(parent, z, world, index)
	local gate = Instance.new("Model")
	gate.Name = world.Key .. "_Gate"
	gate.Parent = parent

	local dark = Color3.fromRGB(33, 36, 44)
	local accent = world.Accent
	part(gate, "PillarL", Vector3.new(9, 30, 9), CFrame.new(-27, 15, z), dark, Enum.Material.Slate)
	part(gate, "PillarR", Vector3.new(9, 30, 9), CFrame.new(27, 15, z), dark, Enum.Material.Slate)
	part(gate, "TopBeam", Vector3.new(63, 7, 10), CFrame.new(0, 30, z), dark, Enum.Material.Slate)

	part(gate, "AccentL", Vector3.new(1.4, 24, 1.4), CFrame.new(-27, 15, z - 4.6), accent, Enum.Material.Neon)
	part(gate, "AccentR", Vector3.new(1.4, 24, 1.4), CFrame.new(27, 15, z - 4.6), accent, Enum.Material.Neon)
	part(gate, "AccentTop", Vector3.new(54, 1.4, 1.4), CFrame.new(0, 30, z - 5), accent, Enum.Material.Neon)

	local sign = part(gate, "WorldSign", Vector3.new(38, 8, 1), CFrame.new(0, 25, z - 5.6), Color3.fromRGB(246, 247, 250), Enum.Material.SmoothPlastic)
	surfaceLabel(sign, Enum.NormalId.Front, world.DisplayName .. "\n" .. world.RequiredSpeed .. " SPEED", accent, Color3.fromRGB(245, 246, 249))

	local trigger = part(gate, "GateTrigger", Vector3.new(320, 18, 6), CFrame.new(0, 9, z + 2), accent, Enum.Material.ForceField, 1)
	trigger.CanCollide = false

	for i = -2, 2 do
		local beam = part(gate, "EnergyBar", Vector3.new(4, 0.45, 2.5), CFrame.new(i * 8, 16 + math.abs(i) * 2.1, z + 1.1) * CFrame.Angles(0, 0, math.rad(i * 7)), accent, Enum.Material.Neon, 0.2)
		beam.CanCollide = false
	end

	return {
		WorldKey = world.Key,
		RequiredSpeed = world.RequiredSpeed,
		Trigger = trigger,
		ReturnCFrame = CFrame.new(0, 5, z - 12),
		Index = index,
	}
end

local function makeKiosk(parent, pos, title, accent)
	local model = Instance.new("Model")
	model.Name = title .. "_Kiosk"
	model.Parent = parent
	part(model, "Body", Vector3.new(32, 16, 24), CFrame.new(pos + Vector3.new(0, 8, 0)), Color3.fromRGB(238, 240, 245), Enum.Material.SmoothPlastic)
	part(model, "Roof", Vector3.new(38, 3, 30), CFrame.new(pos + Vector3.new(0, 17, 0)), Color3.fromRGB(42, 45, 54), Enum.Material.Slate)
	part(model, "Glow", Vector3.new(34, 0.6, 2), CFrame.new(pos + Vector3.new(0, 14, -12.2)), accent, Enum.Material.Neon)
	local sign = part(model, "Sign", Vector3.new(20, 6, 1), CFrame.new(pos + Vector3.new(0, 10, -12.6)), Color3.fromRGB(31, 34, 42), Enum.Material.SmoothPlastic)
	surfaceLabel(sign, Enum.NormalId.Front, title, accent, Color3.fromRGB(31, 34, 42))
	return model
end

local function makeBase(parent, index, center, accent)
	local model = Instance.new("Model")
	model.Name = "PlayerBase_" .. index
	model.Parent = parent

	local floor = part(model, "Floor", Vector3.new(48, 1, 40), CFrame.new(center), Color3.fromRGB(85, 177, 79), Enum.Material.Grass)
	floor.TopSurface = Enum.SurfaceType.Smooth
	part(model, "Foundation", Vector3.new(50, 0.8, 42), CFrame.new(center - Vector3.new(0, 0.7, 0)), Color3.fromRGB(90, 95, 101), Enum.Material.Slate)
	part(model, "BackWall", Vector3.new(48, 8, 1), CFrame.new(center + Vector3.new(0, 4, 20)), Color3.fromRGB(226, 221, 205), Enum.Material.Concrete)
	part(model, "BackAccent", Vector3.new(46, 0.7, 1.4), CFrame.new(center + Vector3.new(0, 7.4, 19.6)), accent, Enum.Material.Neon)

	lowFence(model, center + Vector3.new(-24, 0, 0), 40, false)
	lowFence(model, center + Vector3.new(24, 0, 0), 40, false)

	local sign = part(model, "BaseSign", Vector3.new(22, 6, 0.8), CFrame.new(center + Vector3.new(0, 4.2, 19.2)), Color3.fromRGB(31, 34, 42), Enum.Material.SmoothPlastic)
	local signLabel = surfaceLabel(sign, Enum.NormalId.Front, "BASE LIBRE", accent, Color3.fromRGB(31, 34, 42))

	local deposit = part(model, "Deposit", Vector3.new(14, 0.55, 9), CFrame.new(center + Vector3.new(0, 0.9, -14)), accent, Enum.Material.Neon, 0.1)
	floatingLabel(deposit, "DEPOT", Color3.new(1,1,1), 90, 24, Vector3.new(0, 1.6, 0), 45)

	local training = part(model, "TrainingPad", Vector3.new(13, 0.55, 9), CFrame.new(center + Vector3.new(-15, 0.9, -2)), Color3.fromRGB(67, 198, 255), Enum.Material.Neon, 0.08)
	for x = -4, 4, 2 do
		part(model, "TreadLine", Vector3.new(0.45, 0.12, 8), CFrame.new(training.Position + Vector3.new(x, 0.4, 0)), Color3.fromRGB(232, 250, 255), Enum.Material.Neon)
	end
	floatingLabel(training, "SPEED", Color3.fromRGB(78, 205, 255), 100, 24, Vector3.new(0, 1.7, 0), 45)

	local baseTerminal = part(model, "BaseTerminal", Vector3.new(5, 5, 5), CFrame.new(center + Vector3.new(15, 2.7, -5)), Color3.fromRGB(46, 49, 58), Enum.Material.Metal)
	part(model, "BaseTerminalGlow", Vector3.new(4, 0.35, 4), baseTerminal.CFrame * CFrame.new(0, 2.7, 0), accent, Enum.Material.Neon)
	local basePrompt = prompt(baseTerminal, "AMELIORER", "Base")
	floatingLabel(baseTerminal, "BASE", accent, 90, 22, Vector3.new(0, 4, 0), 45)

	local trainTerminal = part(model, "TrainTerminal", Vector3.new(5, 5, 5), CFrame.new(center + Vector3.new(15, 2.7, 3)), Color3.fromRGB(46, 49, 58), Enum.Material.Metal)
	part(model, "TrainTerminalGlow", Vector3.new(4, 0.35, 4), trainTerminal.CFrame * CFrame.new(0, 2.7, 0), Color3.fromRGB(67, 198, 255), Enum.Material.Neon)
	local trainingPrompt = prompt(trainTerminal, "AMELIORER", "Speed")
	floatingLabel(trainTerminal, "TAPIS", Color3.fromRGB(67, 198, 255), 90, 22, Vector3.new(0, 4, 0), 45)

	local shieldTerminal = part(model, "ShieldTerminal", Vector3.new(5, 5, 5), CFrame.new(center + Vector3.new(-15, 2.7, 10)), Color3.fromRGB(46, 49, 58), Enum.Material.Metal)
	part(model, "ShieldTerminalGlow", Vector3.new(4, 0.35, 4), shieldTerminal.CFrame * CFrame.new(0, 2.7, 0), Color3.fromRGB(94, 226, 255), Enum.Material.Neon)
	local shieldPrompt = prompt(shieldTerminal, "ACTIVER", "Bouclier")
	floatingLabel(shieldTerminal, "SHIELD", Color3.fromRGB(94, 226, 255), 90, 22, Vector3.new(0, 4, 0), 45)

	local heroFolder = Instance.new("Folder")
	heroFolder.Name = "Heroes"
	heroFolder.Parent = model

	local standPositions = {}
	for row = 0, 2 do
		for col = 0, 3 do
			local x = -12 + col * 8
			local z = 5 + row * 5
			cylinder(model, "HeroStand", 5.8, 0.8, CFrame.new(center + Vector3.new(x, 0.9, z)), Color3.fromRGB(214, 212, 204), Enum.Material.Concrete)
			table.insert(standPositions, CFrame.new(center + Vector3.new(x, 3.1, z)))
		end
	end

	local shieldWalls = {
		part(model, "ShieldFront", Vector3.new(48, 12, 0.7), CFrame.new(center + Vector3.new(0, 6, -20)), Color3.fromRGB(83, 220, 255), Enum.Material.ForceField, 1),
		part(model, "ShieldBack", Vector3.new(48, 12, 0.7), CFrame.new(center + Vector3.new(0, 6, 20)), Color3.fromRGB(83, 220, 255), Enum.Material.ForceField, 1),
		part(model, "ShieldLeft", Vector3.new(0.7, 12, 40), CFrame.new(center + Vector3.new(-24, 6, 0)), Color3.fromRGB(83, 220, 255), Enum.Material.ForceField, 1),
		part(model, "ShieldRight", Vector3.new(0.7, 12, 40), CFrame.new(center + Vector3.new(24, 6, 0)), Color3.fromRGB(83, 220, 255), Enum.Material.ForceField, 1),
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
		TrainingPrompt = trainingPrompt,
		ShieldPrompt = shieldPrompt,
		ShieldWalls = shieldWalls,
		HeroFolder = heroFolder,
		StandPositions = standPositions,
	}
end

local function eggShrine(parent, world, pos, index)
	local model = Instance.new("Model")
	model.Name = world.Key .. "_Egg_" .. index
	model.Parent = parent

	local accent = world.Accent
	cylinder(model, "Pedestal", 13, 3.5, CFrame.new(pos), Color3.fromRGB(57, 61, 69), Enum.Material.Slate)
	cylinder(model, "Ring", 15, 0.55, CFrame.new(pos + Vector3.new(0, 2.1, 0)), accent, Enum.Material.Neon, 0.04)

	local egg = part(model, "Egg", Vector3.new(6.2, 8.4, 6.2), CFrame.new(pos + Vector3.new(0, 7, 0)), Color3.fromRGB(239, 241, 247), Enum.Material.SmoothPlastic)
	egg.Shape = Enum.PartType.Ball
	egg.CanCollide = false
	pointLight(egg, accent, 18, 2)
	addHighlight(egg, accent)

	local pr = prompt(egg, "VOLER", "Oeuf " .. world.DisplayName, 0.55)
	floatingLabel(egg, "OEUF", accent, 90, 24, Vector3.new(0, 5.8, 0), 70)

	return {
		WorldKey = world.Key,
		RequiredSpeed = world.RequiredSpeed,
		Respawn = world.EggRespawn,
		Model = model,
		Egg = egg,
		Prompt = pr,
		Accent = accent,
	}
end

local function basicHouse(parent, pos, accent, scale)
	scale = scale or 1
	local w, d, h = 24 * scale, 18 * scale, 13 * scale
	part(parent, "HouseBody", Vector3.new(w, h, d), CFrame.new(pos + Vector3.new(0, h / 2, 0)), Color3.fromRGB(232, 214, 182), Enum.Material.WoodPlanks)
	part(parent, "HouseBase", Vector3.new(w + 3, 0.8, d + 3), CFrame.new(pos + Vector3.new(0, 0.4, 0)), Color3.fromRGB(101, 94, 83), Enum.Material.Slate)
	part(parent, "Roof", Vector3.new(w + 5, 2, d + 5), CFrame.new(pos + Vector3.new(0, h + 2, 0)), Color3.fromRGB(56, 60, 68), Enum.Material.Slate)
	part(parent, "RoofGlow", Vector3.new(w + 1, 0.6, d + 1), CFrame.new(pos + Vector3.new(0, h + 3.1, 0)), accent, Enum.Material.Neon, 0.1)
	part(parent, "Door", Vector3.new(5, 8, 0.7), CFrame.new(pos + Vector3.new(0, 4, -d / 2 - 0.4)), Color3.fromRGB(78, 52, 39), Enum.Material.Wood)
end

local function ninjaWorld(parent, world)
	local z = world.CenterZ
	for _, info in ipairs({
		{Vector3.new(-88, 1, z - 70), 1.0},
		{Vector3.new(-52, 1, z - 28), 0.9},
		{Vector3.new(-92, 1, z + 38), 1.05},
		{Vector3.new(55, 1, z - 66), 0.95},
		{Vector3.new(94, 1, z - 15), 1.0},
		{Vector3.new(58, 1, z + 55), 1.05},
	}) do
		basicHouse(parent, info[1], world.Accent, info[2])
	end
	for _, p in ipairs({
		Vector3.new(-130,1,z-85),Vector3.new(130,1,z-80),Vector3.new(-125,1,z+15),
		Vector3.new(126,1,z+20),Vector3.new(-120,1,z+90),Vector3.new(118,1,z+95),
	}) do
		tree(parent, p, Color3.fromRGB(255, 145, 203), 1)
	end

	-- Training yard.
	local yard = part(parent, "TrainingYard", Vector3.new(62, 0.7, 50), CFrame.new(-78, 1.1, z + 82), Color3.fromRGB(151, 112, 71), Enum.Material.Ground)
	lowFence(parent, Vector3.new(-78,1,z+57), 62, true)
	lowFence(parent, Vector3.new(-78,1,z+107), 62, true)
	for _, x in ipairs({-15, 0, 15}) do
		part(parent, "TrainingPost", Vector3.new(3, 11, 3), CFrame.new(-78 + x, 6, z + 82), Color3.fromRGB(102, 69, 47), Enum.Material.Wood)
	end

	-- Hokage-like tower.
	for level = 1, 4 do
		local d = 34 - (level - 1) * 4
		cylinder(parent, "VillageTower", d, 8, CFrame.new(82, 6 + (level - 1) * 8, z + 72), Color3.fromRGB(223, 203, 172), Enum.Material.Brick)
		cylinder(parent, "VillageTowerRoof", d + 7, 2, CFrame.new(82, 11 + (level - 1) * 8, z + 72), Color3.fromRGB(184, 58, 50), Enum.Material.Slate)
	end
end

local function pirateWorld(parent, world)
	local z = world.CenterZ
	local water = Color3.fromRGB(54, 167, 221)
	part(parent, "SeaLeft", Vector3.new(75, 1.2, 210), CFrame.new(-112, 0.5, z), water, Enum.Material.Glass, 0.08)
	part(parent, "SeaRight", Vector3.new(75, 1.2, 210), CFrame.new(112, 0.5, z), water, Enum.Material.Glass, 0.08)
	for _, x in ipairs({-130, 130}) do
		for dz = -85, 85, 42 do
			palm(parent, Vector3.new(x, 1, z + dz), 0.9)
		end
	end
	-- Dock.
	part(parent, "Dock", Vector3.new(58, 1, 42), CFrame.new(-90, 1.5, z + 42), Color3.fromRGB(132, 86, 50), Enum.Material.WoodPlanks)
	for dx = -24, 24, 12 do
		part(parent, "DockPost", Vector3.new(2, 8, 2), CFrame.new(-90 + dx, 4, z + 25), Color3.fromRGB(92, 61, 42), Enum.Material.Wood)
	end
	-- Stylized ship.
	local ship = Instance.new("Model")
	ship.Name = "PirateShip"
	ship.Parent = parent
	part(ship, "Hull", Vector3.new(60, 10, 22), CFrame.new(-105, 7, z + 54), Color3.fromRGB(105, 61, 42), Enum.Material.WoodPlanks)
	wedge(ship, "Bow", Vector3.new(18, 10, 22), CFrame.new(-66, 7, z + 54) * CFrame.Angles(0, math.rad(90), 0), Color3.fromRGB(105, 61, 42), Enum.Material.WoodPlanks)
	part(ship, "Mast", Vector3.new(2, 40, 2), CFrame.new(-105, 26, z + 54), Color3.fromRGB(82, 55, 38), Enum.Material.Wood)
	part(ship, "Sail", Vector3.new(2, 26, 22), CFrame.new(-104, 28, z + 54), Color3.fromRGB(244, 240, 220), Enum.Material.Fabric)
	local sailSign = part(ship, "SailMark", Vector3.new(1, 10, 10), CFrame.new(-102.8, 29, z + 54), Color3.fromRGB(30, 33, 38), Enum.Material.SmoothPlastic)
	sailSign.Shape = Enum.PartType.Ball
	for i = 1, 10 do
		local px = 54 + (i % 5) * 8
		local pz = z - 75 + math.floor(i / 5) * 24
		cylinder(parent, "Barrel", 4, 5, CFrame.new(px, 3, pz), Color3.fromRGB(112, 73, 44), Enum.Material.Wood)
	end
end

local function dragonWorld(parent, world)
	local z = world.CenterZ
	for i = 1, 18 do
		local side = i % 2 == 0 and -1 or 1
		local x = side * (58 + (i % 4) * 20)
		local zz = z - 95 + ((i * 31) % 190)
		rock(parent, Vector3.new(x, 5 + (i % 3) * 3, zz), Vector3.new(10 + (i % 4) * 4, 10 + (i % 3) * 6, 10 + (i % 5) * 3), Color3.fromRGB(145, 101, 66))
	end
	for i = 1, 5 do
		local x = -95 + i * 38
		local r = rock(parent, Vector3.new(x, 28 + (i % 2) * 8, z + 70), Vector3.new(12, 8, 12), Color3.fromRGB(132, 92, 62))
		r.CanCollide = false
	end
	-- Capsule building.
	local capsule = Instance.new("Model")
	capsule.Name = "CapsuleLab"
	capsule.Parent = parent
	cylinder(capsule, "LabBody", 34, 26, CFrame.new(-92, 14, z + 30), Color3.fromRGB(232, 234, 240), Enum.Material.SmoothPlastic)
	ball(capsule, "LabDome", 30, Vector3.new(-92, 30, z + 30), Color3.fromRGB(109, 193, 236), Enum.Material.Glass, 0.12)
	part(capsule, "LabDoor", Vector3.new(1, 9, 8), CFrame.new(-78, 6, z + 30), world.Accent, Enum.Material.Neon)
	for _, x in ipairs({-70, 0, 70}) do
		local orb = ball(parent, "EnergyOrb", 8, Vector3.new(x, 12, z - 62), x == 0 and Color3.fromRGB(130, 216, 255) or world.Accent, Enum.Material.Neon, 0.05)
		pointLight(orb, orb.Color, 22, 1.6)
	end
end

local function demonWorld(parent, world)
	local z = world.CenterZ
	for row = 0, 3 do
		for col = 0, 5 do
			local x = -130 + col * 52
			local zz = z - 90 + row * 58 + (col % 2) * 10
			for k = 0, 2 do
				bamboo(parent, Vector3.new(x + k * 4, 1, zz + k * 3), 16 + (k % 2) * 4)
			end
		end
	end
	for dz = -88, 88, 24 do
		streetLamp(parent, Vector3.new(-24, 1, z + dz), Color3.fromRGB(255, 120, 93))
		streetLamp(parent, Vector3.new(24, 1, z + dz), Color3.fromRGB(255, 120, 93))
	end
	-- Temple.
	part(parent, "Temple", Vector3.new(54, 18, 38), CFrame.new(88, 10, z + 55), Color3.fromRGB(229, 210, 177), Enum.Material.WoodPlanks)
	part(parent, "TempleRoof", Vector3.new(64, 4, 48), CFrame.new(88, 21, z + 55), Color3.fromRGB(68, 52, 58), Enum.Material.Slate)
	part(parent, "TempleGlow", Vector3.new(56, 0.8, 2), CFrame.new(88, 18, z + 35.5), world.Accent, Enum.Material.Neon)
	local moon = ball(parent, "CrimsonMoon", 34, Vector3.new(-105, 45, z + 80), Color3.fromRGB(255, 100, 100), Enum.Material.Neon, 0.12)
	moon.CanCollide = false
	pointLight(moon, moon.Color, 60, 1.8)
end

local function cursedWorld(parent, world)
	local z = world.CenterZ
	for _, x in ipairs({-112, -76, 76, 112}) do
		for row = 0, 2 do
			local h = 26 + ((row + math.abs(x)) % 3) * 10
			part(parent, "CityBuilding", Vector3.new(28, h, 38), CFrame.new(x, h / 2 + 1, z - 70 + row * 72), Color3.fromRGB(76, 81, 92), Enum.Material.Concrete)
			part(parent, "CityGlass", Vector3.new(24, h - 6, 0.6), CFrame.new(x, h / 2 + 1, z - 89 + row * 72), Color3.fromRGB(85, 159, 201), Enum.Material.Glass, 0.35)
		end
	end
	for i = 1, 10 do
		local side = i % 2 == 0 and -1 or 1
		crystal(parent, Vector3.new(side * (36 + (i % 4) * 13), 1, z - 85 + i * 18), world.Accent, 0.65 + (i % 3) * 0.18)
	end
	-- School.
	part(parent, "JujutsuSchool", Vector3.new(70, 22, 46), CFrame.new(0, 12, z + 72), Color3.fromRGB(56, 60, 69), Enum.Material.Brick)
	part(parent, "SchoolRoof", Vector3.new(78, 3, 54), CFrame.new(0, 24, z + 72), Color3.fromRGB(34, 37, 44), Enum.Material.Slate)
	part(parent, "SchoolGateGlow", Vector3.new(22, 0.7, 1), CFrame.new(0, 12, z + 48.5), world.Accent, Enum.Material.Neon)
end

local function soulWorld(parent, world)
	local z = world.CenterZ
	for _, x in ipairs({-120, -82, 82, 120}) do
		part(parent, "WhiteWall", Vector3.new(22, 24, 52), CFrame.new(x, 12, z + (x % 2 == 0 and 55 or -55)), Color3.fromRGB(236, 239, 244), Enum.Material.Marble)
		part(parent, "SpiritTrim", Vector3.new(18, 0.7, 48), CFrame.new(x, 23.6, z + (x % 2 == 0 and 55 or -55)), world.Accent, Enum.Material.Neon, 0.12)
	end
	-- Senkaimon-inspired gate.
	part(parent, "SpiritGateL", Vector3.new(8, 38, 8), CFrame.new(-27, 19, z + 68), Color3.fromRGB(239, 240, 242), Enum.Material.Marble)
	part(parent, "SpiritGateR", Vector3.new(8, 38, 8), CFrame.new(27, 19, z + 68), Color3.fromRGB(239, 240, 242), Enum.Material.Marble)
	part(parent, "SpiritGateTop", Vector3.new(62, 7, 9), CFrame.new(0, 38, z + 68), Color3.fromRGB(239, 240, 242), Enum.Material.Marble)
	part(parent, "SpiritPortal", Vector3.new(43, 25, 1), CFrame.new(0, 17, z + 67.5), world.Accent, Enum.Material.ForceField, 0.55)
	for _, x in ipairs({-125, 125}) do
		for dz = -82, 82, 42 do
			crystal(parent, Vector3.new(x, 1, z + dz), Color3.fromRGB(98, 221, 255), 0.9)
		end
	end
end

local function titanWorld(parent, world)
	local z = world.CenterZ
	local stone = Color3.fromRGB(150, 145, 126)
	part(parent, "InnerWall", Vector3.new(300, 55, 14), CFrame.new(0, 27, z + 105), stone, Enum.Material.Brick)
	part(parent, "InnerGateL", Vector3.new(52, 48, 18), CFrame.new(-48, 24, z + 94), stone, Enum.Material.Brick)
	part(parent, "InnerGateR", Vector3.new(52, 48, 18), CFrame.new(48, 24, z + 94), stone, Enum.Material.Brick)
	for _, x in ipairs({-112, -74, 74, 112}) do
		for row = 0, 2 do
			local zz = z - 80 + row * 58
			part(parent, "DistrictHouse", Vector3.new(28, 18, 34), CFrame.new(x, 10, zz), Color3.fromRGB(205, 193, 165), Enum.Material.Brick)
			wedge(parent, "DistrictRoof", Vector3.new(17, 8, 38), CFrame.new(x - 8, 23, zz) * CFrame.Angles(0, math.rad(90), 0), Color3.fromRGB(94, 65, 55), Enum.Material.Slate)
			wedge(parent, "DistrictRoof", Vector3.new(17, 8, 38), CFrame.new(x + 8, 23, zz) * CFrame.Angles(0, math.rad(-90), 0), Color3.fromRGB(94, 65, 55), Enum.Material.Slate)
		end
	end
	-- Titan landmark.
	local titan = Instance.new("Model")
	titan.Name = "TitanLandmark"
	titan.Parent = parent
	part(titan, "LegL", Vector3.new(8, 32, 8), CFrame.new(-8, 16, z + 76), Color3.fromRGB(204, 122, 92), Enum.Material.SmoothPlastic)
	part(titan, "LegR", Vector3.new(8, 32, 8), CFrame.new(8, 16, z + 76), Color3.fromRGB(204, 122, 92), Enum.Material.SmoothPlastic)
	part(titan, "Torso", Vector3.new(30, 34, 16), CFrame.new(0, 48, z + 76), Color3.fromRGB(211, 126, 95), Enum.Material.SmoothPlastic)
	ball(titan, "Head", 20, Vector3.new(0, 76, z + 76), Color3.fromRGB(225, 156, 118), Enum.Material.SmoothPlastic)
	addHighlight(titan, world.Accent)
end

local WORLD_BUILDERS = {
	Naruto = ninjaWorld,
	OnePiece = pirateWorld,
	DragonBall = dragonWorld,
	DemonSlayer = demonWorld,
	JJK = cursedWorld,
	Bleach = soulWorld,
	AOT = titanWorld,
}

local function decorateBoundary(world, minZ, maxZ)
	local wallColor = Color3.fromRGB(88, 77, 67)
	part(world, "WestBoundary", Vector3.new(18, 68, maxZ - minZ), CFrame.new(-170, 31, (minZ + maxZ) / 2), wallColor, Enum.Material.Rock)
	part(world, "EastBoundary", Vector3.new(18, 68, maxZ - minZ), CFrame.new(170, 31, (minZ + maxZ) / 2), wallColor, Enum.Material.Rock)
	part(world, "SouthBoundary", Vector3.new(340, 68, 18), CFrame.new(0, 31, minZ), wallColor, Enum.Material.Rock)
	part(world, "NorthBoundary", Vector3.new(340, 68, 18), CFrame.new(0, 31, maxZ), wallColor, Enum.Material.Rock)

	for z = minZ + 30, maxZ - 30, 80 do
		for _, x in ipairs({-157, 157}) do
			rock(world, Vector3.new(x, 42 + (math.abs(z) % 3) * 4, z), Vector3.new(30, 35, 34), Color3.fromRGB(98, 86, 75))
			tree(world, Vector3.new(x > 0 and 145 or -145, 1, z + 18), Color3.fromRGB(64, 123, 69), 1.1)
		end
	end
end

local function configureLighting()
	Lighting.ClockTime = 14.2
	Lighting.Brightness = 2.4
	Lighting.ExposureCompensation = 0.05
	Lighting.Ambient = Color3.fromRGB(118, 124, 138)
	Lighting.OutdoorAmbient = Color3.fromRGB(172, 178, 190)
	Lighting.EnvironmentDiffuseScale = 0.55
	Lighting.EnvironmentSpecularScale = 0.75

	for _, name in ipairs({"AnimeBloom", "AnimeColor", "AnimeAtmosphere", "AnimeSunRays"}) do
		local old = Lighting:FindFirstChild(name)
		if old then old:Destroy() end
	end

	local bloom = Instance.new("BloomEffect")
	bloom.Name = "AnimeBloom"
	bloom.Intensity = 0.18
	bloom.Size = 18
	bloom.Threshold = 1.4
	bloom.Parent = Lighting

	local color = Instance.new("ColorCorrectionEffect")
	color.Name = "AnimeColor"
	color.Saturation = 0.12
	color.Contrast = 0.04
	color.Brightness = 0.02
	color.Parent = Lighting

	local atmosphere = Instance.new("Atmosphere")
	atmosphere.Name = "AnimeAtmosphere"
	atmosphere.Density = 0.16
	atmosphere.Offset = 0.05
	atmosphere.Color = Color3.fromRGB(213, 228, 244)
	atmosphere.Decay = Color3.fromRGB(122, 145, 170)
	atmosphere.Glare = 0.04
	atmosphere.Haze = 0.5
	atmosphere.Parent = Lighting

	local rays = Instance.new("SunRaysEffect")
	rays.Name = "AnimeSunRays"
	rays.Intensity = 0.04
	rays.Spread = 0.7
	rays.Parent = Lighting
end

function WorldBuilder.Build(Config)
	local old = workspace:FindFirstChild("AnimeEggWorld")
	if old then old:Destroy() end
	local baseplate = workspace:FindFirstChild("Baseplate")
	if baseplate then baseplate:Destroy() end

	configureLighting()

	local world = Instance.new("Model")
	world.Name = "AnimeEggWorld"
	world.Parent = workspace

	-- Continuous rock underlay so there are no open gaps between themed worlds.
	part(world, "WorldUnderlay", Vector3.new(320, 4, 2325), CFrame.new(0, -3, 825), Color3.fromRGB(74, 70, 65), Enum.Material.Rock)

	local minZ = -340
	local maxZ = 1995
	decorateBoundary(world, minZ, maxZ)

	-- Hub foundation and plaza.
	local hubFloor = part(world, "HubFloor", Vector3.new(320, 4, 290), CFrame.new(0, -1, -185), Color3.fromRGB(83, 174, 83), Enum.Material.Grass)
	local hubRoad = part(world, "HubRoad", Vector3.new(40, 0.6, 300), CFrame.new(0, 1.3, -180), Color3.fromRGB(216, 206, 183), Enum.Material.Concrete)
	local plaza = cylinder(world, "CentralPlaza", 105, 1.2, CFrame.new(0, 1.2, -235), Color3.fromRGB(201, 204, 210), Enum.Material.Concrete)
	part(world, "PlazaRing", Vector3.new(110, 0.4, 110), CFrame.new(0, 1.1, -235), Color3.fromRGB(255, 255, 255), Enum.Material.SmoothPlastic, 1)

	local core = ball(world, "HubCore", 17, Vector3.new(0, 13, -235), Color3.fromRGB(141, 95, 255), Enum.Material.Neon, 0.04)
	pointLight(core, core.Color, 40, 2.2)
	addHighlight(core, core.Color)
	local titleAnchor = part(world, "HubTitleAnchor", Vector3.new(1,1,1), CFrame.new(0, 27, -235), Color3.new(1,1,1), Enum.Material.Neon, 1)
	floatingLabel(titleAnchor, "ANIME EGG HEIST", Color3.fromRGB(255, 230, 94), 420, 70, Vector3.new(), 220)

	makeKiosk(world, Vector3.new(-67, 1, -250), "SHOP", Color3.fromRGB(72, 216, 74))
	makeKiosk(world, Vector3.new(67, 1, -250), "INDEX", Color3.fromRGB(67, 174, 255))

	for z = -315, -35, 28 do
		streetLamp(world, Vector3.new(-24, 1, z), Color3.fromRGB(255, 222, 148))
		streetLamp(world, Vector3.new(24, 1, z), Color3.fromRGB(255, 222, 148))
	end

	for _, p in ipairs({
		Vector3.new(-145,1,-300),Vector3.new(145,1,-300),Vector3.new(-145,1,-220),Vector3.new(145,1,-220),
		Vector3.new(-145,1,-135),Vector3.new(145,1,-135),Vector3.new(-145,1,-55),Vector3.new(145,1,-55),
	}) do
		tree(world, p, Color3.fromRGB(255, 157, 208), 0.95)
	end

	-- Eight bases integrated into the hub.
	local colors = {
		Color3.fromRGB(255, 91, 103), Color3.fromRGB(255, 160, 60), Color3.fromRGB(255, 216, 65), Color3.fromRGB(76, 222, 103),
		Color3.fromRGB(62, 178, 255), Color3.fromRGB(137, 92, 255), Color3.fromRGB(235, 81, 207), Color3.fromRGB(77, 218, 213),
	}
	local bases = {}
	local baseZs = {-300, -230, -160, -90}
	for i, z in ipairs(baseZs) do
		table.insert(bases, makeBase(world, i, Vector3.new(-105, 1, z), colors[i]))
	end
	for i, z in ipairs(baseZs) do
		local idx = i + 4
		table.insert(bases, makeBase(world, idx, Vector3.new(105, 1, z), colors[idx]))
	end

	-- Continuous avenue and all seven worlds.
	local eggs = {}
	local gates = {}
	for index, worldConfig in ipairs(Config.Worlds) do
		local z = worldConfig.CenterZ
		local floor = part(world, worldConfig.Key .. "_Floor", Vector3.new(320, 3, 238), CFrame.new(0, -0.5, z), worldConfig.GroundColor, Enum.Material.Grass)
		if worldConfig.Key == "OnePiece" then floor.Material = Enum.Material.Sand end
		if worldConfig.Key == "DragonBall" then floor.Material = Enum.Material.Sandstone end
		if worldConfig.Key == "DemonSlayer" then floor.Material = Enum.Material.Ground end
		if worldConfig.Key == "JJK" then floor.Material = Enum.Material.Concrete end
		if worldConfig.Key == "Bleach" then floor.Material = Enum.Material.Marble end
		if worldConfig.Key == "AOT" then floor.Material = Enum.Material.Cobblestone end

		local road = part(world, worldConfig.Key .. "_Road", Vector3.new(36, 0.5, 236), CFrame.new(0, 1.2, z), worldConfig.Key == "Bleach" and Color3.fromRGB(245,245,248) or Color3.fromRGB(207, 199, 183), worldConfig.Key == "JJK" and Enum.Material.Concrete or Enum.Material.Concrete)
		road.TopSurface = Enum.SurfaceType.Smooth

		local gateZ = z - 126
		table.insert(gates, portalGate(world, gateZ, worldConfig, index))

		local builder = WORLD_BUILDERS[worldConfig.Key]
		if builder then
			builder(world, worldConfig)
		end

		for eggIndex, x in ipairs({-28, 28}) do
			table.insert(eggs, eggShrine(world, worldConfig, Vector3.new(x, 2.8, z + 78), eggIndex))
		end

		local worldTitle = part(world, worldConfig.Key .. "_TitleAnchor", Vector3.new(1,1,1), CFrame.new(0, 28, z - 80), Color3.new(1,1,1), Enum.Material.Neon, 1)
		floatingLabel(worldTitle, worldConfig.DisplayName, worldConfig.Accent, 330, 60, Vector3.new(), 180)
	end

	-- Spawn.
	local spawn = Instance.new("SpawnLocation")
	spawn.Name = "MainSpawn"
	spawn.Anchored = true
	spawn.Neutral = true
	spawn.Size = Vector3.new(14, 1, 14)
	spawn.CFrame = CFrame.new(0, 3, -305)
	spawn.Color = Color3.fromRGB(72, 216, 84)
	spawn.Material = Enum.Material.Neon
	spawn.Parent = world

	return {
		World = world,
		Bases = bases,
		Eggs = eggs,
		Gates = gates,
		Spawn = spawn,
	}
end

return WorldBuilder
