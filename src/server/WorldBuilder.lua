local Lighting = game:GetService("Lighting")
local Terrain = workspace.Terrain

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

	local wood = Color3.fromRGB(142, 83, 44)
	local woodDark = Color3.fromRGB(82, 55, 39)
	local machineDark = Color3.fromRGB(38, 42, 50)
	local grass = Color3.fromRGB(108, 215, 80)

	-- Bright fenced tycoon plot, closer to modern simulator composition.
	local floor = part(model, "Floor", Vector3.new(58, 0.8, 50), CFrame.new(center), grass, Enum.Material.Grass)
	floor.TopSurface = Enum.SurfaceType.Smooth
	part(model, "PlotBase", Vector3.new(60, 0.7, 52), CFrame.new(center - Vector3.new(0,0.75,0)), Color3.fromRGB(94, 99, 102), Enum.Material.Concrete)

	-- Full wooden perimeter with a wide front entrance.
	lowFence(model, center + Vector3.new(-29, 0, 0), 50, false, wood)
	lowFence(model, center + Vector3.new(29, 0, 0), 50, false, wood)
	lowFence(model, center + Vector3.new(0, 0, 25), 58, true, wood)
	lowFence(model, center + Vector3.new(-21, 0, -25), 16, true, wood)
	lowFence(model, center + Vector3.new(21, 0, -25), 16, true, wood)

	-- Entrance posts + player sign.
	for _,x in ipairs({-11,11}) do
		part(model,"EntrancePost",Vector3.new(2.4,8,2.4),CFrame.new(center+Vector3.new(x,4,-25)),woodDark,Enum.Material.Wood)
		part(model,"EntranceCap",Vector3.new(3.2,0.8,3.2),CFrame.new(center+Vector3.new(x,8.4,-25)),accent,Enum.Material.Neon,0.18)
	end
	local sign = part(model, "BaseSign", Vector3.new(18, 4.4, 0.7), CFrame.new(center + Vector3.new(0, 7, -25)), Color3.fromRGB(248, 245, 234), Enum.Material.SmoothPlastic)
	local signLabel = surfaceLabel(sign, Enum.NormalId.Front, "BASE LIBRE", Color3.fromRGB(35,38,44), Color3.fromRGB(248,245,234))
	part(model,"SignAccent",Vector3.new(15,0.35,0.25),CFrame.new(center+Vector3.new(0,5.2,-25.45)),accent,Enum.Material.Neon,0.18)

	-- Back collection machine: recognizable simulator silhouette with screen and antennae.
	local machine = Instance.new("Model")
	machine.Name = "BaseMachine"
	machine.Parent = model
	part(machine,"MachineBody",Vector3.new(22,12,8),CFrame.new(center+Vector3.new(0,6.4,19)),machineDark,Enum.Material.Metal)
	part(machine,"MachineTop",Vector3.new(24,2,10),CFrame.new(center+Vector3.new(0,13.4,19)),Color3.fromRGB(64,69,78),Enum.Material.Metal)
	part(machine,"MachineScreen",Vector3.new(10,6,0.45),CFrame.new(center+Vector3.new(0,7,14.8)),Color3.fromRGB(87,194,255),Enum.Material.Glass,0.12)
	part(machine,"MachineScreenGlow",Vector3.new(7,0.4,0.15),CFrame.new(center+Vector3.new(0,4.8,14.5)),accent,Enum.Material.Neon,0.12)
	for _,x in ipairs({-7,7}) do
		part(machine,"Antenna",Vector3.new(0.8,8,0.8),CFrame.new(center+Vector3.new(x,18,19)),woodDark,Enum.Material.Metal)
		ball(machine,"AntennaLamp",2.2,center+Vector3.new(x,22.2,19),accent,Enum.Material.Neon,0.1)
	end

	-- Deposit pad directly in front of the machine.
	cylinder(model, "DepositBase", 13, 0.8, CFrame.new(center + Vector3.new(0,1,-10)), Color3.fromRGB(62,66,74), Enum.Material.Metal)
	local deposit = cylinder(model, "Deposit", 10, 0.28, CFrame.new(center + Vector3.new(0,1.55,-10)), accent, Enum.Material.Neon, 0.18)
	floatingLabel(deposit, "DEPOT", Color3.new(1,1,1), 72, 20, Vector3.new(0,1.5,0), 32)

	-- Speed station.
	part(model,"SpeedMachine",Vector3.new(12,7,7),CFrame.new(center+Vector3.new(-20,3.8,-3)),machineDark,Enum.Material.Metal)
	part(model,"SpeedScreen",Vector3.new(8,3.6,0.35),CFrame.new(center+Vector3.new(-20,4.2,-6.6)),Color3.fromRGB(66,194,255),Enum.Material.Glass,0.14)
	local training = part(model,"TrainingPad",Vector3.new(14,0.35,8),CFrame.new(center+Vector3.new(-20,1,-12)),Color3.fromRGB(69,190,238),Enum.Material.Glass,0.18)
	for z=-3,3,1.5 do
		part(model,"SpeedStripe",Vector3.new(11,0.07,0.25),CFrame.new(center+Vector3.new(-20,1.3,-12+z)),Color3.fromRGB(220,248,255),Enum.Material.Neon,0.3)
	end

	-- Upgrade terminals.
	local function terminal(name, pos, color, actionText, objectText)
		local body=part(model,name,Vector3.new(5,6,5),CFrame.new(center+pos),machineDark,Enum.Material.Metal)
		part(model,name.."Screen",Vector3.new(3.4,2.6,0.35),body.CFrame*CFrame.new(0,0.5,-2.65),color,Enum.Material.Glass,0.14)
		part(model,name.."Light",Vector3.new(3.8,0.25,3.8),body.CFrame*CFrame.new(0,3.1,0),color,Enum.Material.Neon,0.18)
		return body,prompt(body,actionText,objectText)
	end
	local baseTerminal, basePrompt = terminal("BaseTerminal",Vector3.new(20,3.2,-8),accent,"AMELIORER","Base")
	local trainTerminal, trainingPrompt = terminal("TrainTerminal",Vector3.new(20,3.2,0),Color3.fromRGB(65,194,255),"AMELIORER","Speed")
	local shieldTerminal, shieldPrompt = terminal("ShieldTerminal",Vector3.new(20,3.2,8),Color3.fromRGB(82,225,242),"ACTIVER","Bouclier")

	-- 12 hero stands arranged like showroom slots along the sides/back.
	local heroFolder=Instance.new("Folder")
	heroFolder.Name="Heroes"
	heroFolder.Parent=model
	local standPositions={}
	local standCoords={
		{-20,8},{-12,8},{-4,8},{4,8},{12,8},{20,8},
		{-20,15},{-12,15},{-4,15},{4,15},{12,15},{20,15},
	}
	for _,coord in ipairs(standCoords) do
		local x,z=coord[1],coord[2]
		cylinder(model,"HeroStand",5.4,0.75,CFrame.new(center+Vector3.new(x,1.15,z)),Color3.fromRGB(220,216,203),Enum.Material.Concrete)
		cylinder(model,"HeroStandRing",4.2,0.18,CFrame.new(center+Vector3.new(x,1.62,z)),accent,Enum.Material.Neon,0.35)
		table.insert(standPositions,CFrame.new(center+Vector3.new(x,1.55,z)))
	end

	-- Small decorative crates/planters so the base does not feel empty.
	for _,p in ipairs({Vector3.new(-24,1,20),Vector3.new(24,1,20)}) do
		part(model,"Crate",Vector3.new(5,5,5),CFrame.new(center+p+Vector3.new(0,2.5,0)),Color3.fromRGB(154,102,58),Enum.Material.WoodPlanks)
	end

	local shieldWalls={
		part(model,"ShieldFront",Vector3.new(58,13,0.6),CFrame.new(center+Vector3.new(0,6.5,-25)),Color3.fromRGB(83,220,255),Enum.Material.ForceField,1),
		part(model,"ShieldBack",Vector3.new(58,13,0.6),CFrame.new(center+Vector3.new(0,6.5,25)),Color3.fromRGB(83,220,255),Enum.Material.ForceField,1),
		part(model,"ShieldLeft",Vector3.new(0.6,13,50),CFrame.new(center+Vector3.new(-29,6.5,0)),Color3.fromRGB(83,220,255),Enum.Material.ForceField,1),
		part(model,"ShieldRight",Vector3.new(0.6,13,50),CFrame.new(center+Vector3.new(29,6.5,0)),Color3.fromRGB(83,220,255),Enum.Material.ForceField,1),
	}
	for _,wallPart in ipairs(shieldWalls) do wallPart.CanCollide=false end

	return {
		Index=index,Model=model,Position=center,Accent=accent,SignLabel=signLabel,
		Deposit=deposit,TrainingPad=training,BasePrompt=basePrompt,TrainingPrompt=trainingPrompt,
		ShieldPrompt=shieldPrompt,ShieldWalls=shieldWalls,HeroFolder=heroFolder,StandPositions=standPositions,
	}
end

local function eggShrine(parent, world, pos, index)
	local model = Instance.new("Model")
	model.Name = world.Key .. "_Capsule_" .. index
	model.Parent = parent

	local accent = world.Accent
	local dark = Color3.fromRGB(39, 43, 52)
	local metal = Color3.fromRGB(83, 89, 101)

	-- Raised steal-machine platform.
	cylinder(model, "Platform", 18, 1.3, CFrame.new(pos), Color3.fromRGB(94, 96, 99), Enum.Material.Concrete)
	cylinder(model, "PlatformInset", 14.8, 0.35, CFrame.new(pos + Vector3.new(0, 0.85, 0)), dark, Enum.Material.Metal)
	cylinder(model, "PlatformRing", 12.8, 0.18, CFrame.new(pos + Vector3.new(0, 1.15, 0)), accent, Enum.Material.Neon, 0.18)

	-- Capsule shell: dark top/bottom + glass chamber.
	cylinder(model, "CapsuleBase", 10.8, 2.4, CFrame.new(pos + Vector3.new(0, 2.6, 0)), dark, Enum.Material.Metal)
	local glass = cylinder(model, "CapsuleGlass", 9.5, 8.4, CFrame.new(pos + Vector3.new(0, 7.8, 0)), Color3.fromRGB(188, 232, 255), Enum.Material.Glass, 0.6)
	glass.CastShadow = false
	cylinder(model, "CapsuleTop", 10.8, 2.0, CFrame.new(pos + Vector3.new(0, 12.8, 0)), metal, Enum.Material.Metal)
	cylinder(model, "CapsuleTopRing", 9.2, 0.28, CFrame.new(pos + Vector3.new(0, 13.85, 0)), accent, Enum.Material.Neon, 0.12)

	-- World silhouette inside the pod.
	local core = ball(model, "CapsuleCore", 4.8, CFrame.new(pos + Vector3.new(0, 8.0, 0)), accent, Enum.Material.ForceField, 0.2)
	core.CanCollide = false
	pointLight(core, accent, 18, 1.6)
	addHighlight(core, accent)

	-- Simple character silhouette gives the pod a visible reward target.
	local silhouette = Instance.new("Model")
	silhouette.Name = "PreviewSilhouette"
	silhouette.Parent = model
	part(silhouette, "PreviewTorso", Vector3.new(2.6, 3.1, 1.5), CFrame.new(pos + Vector3.new(0, 8.2, -0.2)), Color3.fromRGB(47, 51, 60), Enum.Material.SmoothPlastic, 0.18)
	part(silhouette, "PreviewLegL", Vector3.new(0.8, 2.2, 0.8), CFrame.new(pos + Vector3.new(-0.65, 5.6, -0.2)), Color3.fromRGB(39, 43, 51), Enum.Material.SmoothPlastic, 0.18)
	part(silhouette, "PreviewLegR", Vector3.new(0.8, 2.2, 0.8), CFrame.new(pos + Vector3.new(0.65, 5.6, -0.2)), Color3.fromRGB(39, 43, 51), Enum.Material.SmoothPlastic, 0.18)
	ball(silhouette, "PreviewHead", 2.25, CFrame.new(pos + Vector3.new(0, 10.8, -0.2)), Color3.fromRGB(57, 61, 70), Enum.Material.SmoothPlastic, 0.16)

	-- Side power columns.
	for _, x in ipairs({-7.5, 7.5}) do
		part(model, "PowerColumn", Vector3.new(2.1, 10.5, 2.1), CFrame.new(pos + Vector3.new(x, 6.3, 0)), dark, Enum.Material.Metal)
		part(model, "PowerStrip", Vector3.new(0.35, 7.5, 0.45), CFrame.new(pos + Vector3.new(x, 6.4, -1.08)), accent, Enum.Material.Neon, 0.16)
		ball(model, "PowerOrb", 1.8, CFrame.new(pos + Vector3.new(x, 12.1, 0)), accent, Enum.Material.Neon, 0.08)
	end

	local pr = prompt(core, "VOLER", "Capsule " .. world.DisplayName, 0.65)
	floatingLabel(core, "CAPSULE", Color3.fromRGB(255,255,255), 110, 24, Vector3.new(0, 7.8, 0), 75)

	return {
		WorldKey = world.Key,
		RequiredSpeed = world.RequiredSpeed,
		Respawn = world.EggRespawn,
		Model = model,
		Egg = core,
		Prompt = pr,
		Accent = accent,
		VisualParts = model:GetDescendants(),
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
	local z=world.CenterZ
	local wood=Color3.fromRGB(145,84,45)
	local sand=Color3.fromRGB(207,191,154)

	-- Central village lane and two fenced activity pens.
	part(parent,"NinjaLane",Vector3.new(42,0.35,218),CFrame.new(0,1.35,z),sand,Enum.Material.Concrete)
	for _,x in ipairs({-24,24}) do
		part(parent,"NinjaLaneEdge",Vector3.new(1.2,0.2,218),CFrame.new(x,1.55,z),Color3.fromRGB(133,126,112),Enum.Material.Concrete)
	end

	lowFence(parent,Vector3.new(-92,1,z-20),110,false,wood)
	lowFence(parent,Vector3.new(-132,1,z-75),80,true,wood)
	lowFence(parent,Vector3.new(-132,1,z+35),80,true,wood)
	lowFence(parent,Vector3.new(92,1,z-20),110,false,wood)
	lowFence(parent,Vector3.new(132,1,z-75),80,true,wood)
	lowFence(parent,Vector3.new(132,1,z+35),80,true,wood)

	-- Dense village silhouettes.
	for _,info in ipairs({
		{-118,-62,1.2},{-82,-68,0.95},{-118,-8,1.0},{-78,18,1.15},{-120,62,0.9},
		{118,-58,1.15},{82,-70,0.95},{118,-4,1.0},{82,26,1.1},{120,66,0.95},
	}) do
		basicHouse(parent,Vector3.new(info[1],1,z+info[2]),world.Accent,info[3])
	end

	-- Sakura rows frame the lane.
	for dz=-90,90,36 do
		tree(parent,Vector3.new(-42,1,z+dz),Color3.fromRGB(242,139,191),0.78)
		tree(parent,Vector3.new(42,1,z+dz),Color3.fromRGB(242,139,191),0.78)
	end

	-- Ramen kiosk.
	local ramen=Instance.new("Model")
	ramen.Name="RamenShop"
	ramen.Parent=parent
	part(ramen,"Body",Vector3.new(24,11,16),CFrame.new(-104,6,z+82),Color3.fromRGB(230,197,145),Enum.Material.WoodPlanks)
	part(ramen,"Roof",Vector3.new(29,2,21),CFrame.new(-104,12.5,z+82),Color3.fromRGB(53,57,64),Enum.Material.Slate)
	local ramenSign=part(ramen,"Sign",Vector3.new(14,4,0.6),CFrame.new(-104,9,z+73.6),Color3.fromRGB(195,55,47),Enum.Material.SmoothPlastic)
	surfaceLabel(ramenSign,Enum.NormalId.Front,"RAMEN",Color3.fromRGB(255,236,185),Color3.fromRGB(195,55,47))

	-- Training pen with targets.
	local yard=part(parent,"TrainingYard",Vector3.new(72,0.55,58),CFrame.new(102,1.2,z+70),Color3.fromRGB(148,108,68),Enum.Material.Ground)
	lowFence(parent,Vector3.new(102,1,z+41),72,true,wood)
	lowFence(parent,Vector3.new(102,1,z+99),72,true,wood)
	for _,x in ipairs({82,102,122}) do
		part(parent,"TrainingPost",Vector3.new(3,12,3),CFrame.new(x,6,z+70),Color3.fromRGB(104,70,48),Enum.Material.Wood)
		cylinder(parent,"Target",8,0.8,CFrame.new(x,8,z+54),Color3.fromRGB(238,229,210),Enum.Material.Wood)
	end

	-- Big ninja landmark at the back gives the same "giant thing in the zone" readability as popular simulator maps.
	local landmark=Instance.new("Model")
	landmark.Name="NinjaLandmark"
	landmark.Parent=parent
	part(landmark,"LegL",Vector3.new(7,22,7),CFrame.new(-12,12,z+94),Color3.fromRGB(51,55,63),Enum.Material.SmoothPlastic)
	part(landmark,"LegR",Vector3.new(7,22,7),CFrame.new(12,12,z+94),Color3.fromRGB(51,55,63),Enum.Material.SmoothPlastic)
	part(landmark,"Torso",Vector3.new(31,28,13),CFrame.new(0,36,z+94),Color3.fromRGB(228,111,47),Enum.Material.SmoothPlastic)
	ball(landmark,"Head",18,Vector3.new(0,60,z+94),Color3.fromRGB(238,193,157),Enum.Material.SmoothPlastic)
	ball(landmark,"Hair",20,Vector3.new(0,68,z+94),Color3.fromRGB(238,197,64),Enum.Material.SmoothPlastic)
	part(landmark,"Headband",Vector3.new(20,4,19),CFrame.new(0,63,z+94),Color3.fromRGB(55,82,109),Enum.Material.Metal)
	addHighlight(landmark,world.Accent)

	-- Hokage-style stacked tower in opposite corner.
	for level=1,4 do
		local d=36-(level-1)*4
		cylinder(parent,"VillageTower",d,8,CFrame.new(-105,6+(level-1)*8,z+104),Color3.fromRGB(224,203,169),Enum.Material.Brick)
		cylinder(parent,"VillageTowerRoof",d+8,2,CFrame.new(-105,11+(level-1)*8,z+104),Color3.fromRGB(181,55,48),Enum.Material.Slate)
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
	-- Organic terrain shell hides the rectangular playfield and gives modern depth/shadows.
	for z = minZ - 10, maxZ + 10, 72 do
		for _, side in ipairs({-1, 1}) do
			local x = side * 184
			local variant = math.floor((z - minZ) / 72) % 4
			local radius = 32 + variant * 4
			Terrain:FillBall(Vector3.new(x, 24 + variant * 3, z), radius, Enum.Material.Rock)
			Terrain:FillBall(Vector3.new(x - side * 12, 42 + variant * 2, z + 18), radius * 0.72, Enum.Material.Rock)
			Terrain:FillBall(Vector3.new(x - side * 19, 56 + variant, z - 12), radius * 0.45, Enum.Material.Grass)

			-- Foreground rocks and trees break the terrain silhouette.
			if variant % 2 == 0 then
				rock(world, Vector3.new(side * 153, 8, z + 10), Vector3.new(16, 16, 19), Color3.fromRGB(96, 87, 76))
				tree(world, Vector3.new(side * 145, 1, z - 20), Color3.fromRGB(58, 119, 67), 1.0)
			end
		end
	end

	for x = -150, 150, 45 do
		Terrain:FillBall(Vector3.new(x, 27, minZ - 8), 34, Enum.Material.Rock)
		Terrain:FillBall(Vector3.new(x, 27, maxZ + 8), 34, Enum.Material.Rock)
	end
end

local function addWorldTerrain(worldConfig)
	local z = worldConfig.CenterZ
	local key = worldConfig.Key

	if key == "Naruto" then
		for _, side in ipairs({-1,1}) do
			for dz = -90, 90, 55 do
				Terrain:FillBall(Vector3.new(side * 142, 10, z + dz), 23, Enum.Material.Grass)
			end
		end
	elseif key == "OnePiece" then
		for _, side in ipairs({-1,1}) do
			for dz = -88, 88, 44 do
				Terrain:FillBall(Vector3.new(side * 138, 2, z + dz), 19, Enum.Material.Sand)
			end
		end
	elseif key == "DragonBall" then
		for _, side in ipairs({-1,1}) do
			for dz = -90, 90, 48 do
				Terrain:FillBall(Vector3.new(side * 132, 12 + ((dz + 90) % 3) * 4, z + dz), 22, Enum.Material.Sandstone)
			end
		end
	elseif key == "DemonSlayer" then
		for _, side in ipairs({-1,1}) do
			for dz = -90, 90, 42 do
				Terrain:FillBall(Vector3.new(side * 136, 8, z + dz), 21, Enum.Material.Grass)
			end
		end
	elseif key == "JJK" then
		for _, side in ipairs({-1,1}) do
			Terrain:FillBlock(CFrame.new(side * 151, 5, z), Vector3.new(18, 12, 220), Enum.Material.Rock)
		end
	elseif key == "Bleach" then
		for _, side in ipairs({-1,1}) do
			for dz = -85, 85, 55 do
				Terrain:FillBall(Vector3.new(side * 142, 7, z + dz), 18, Enum.Material.Rock)
			end
		end
	elseif key == "AOT" then
		for _, side in ipairs({-1,1}) do
			for dz = -92, 92, 46 do
				Terrain:FillBall(Vector3.new(side * 140, 9, z + dz), 23, Enum.Material.Grass)
			end
		end
	end
end

local function makeBench(parent, pos, rotation)
	local cf = CFrame.new(pos) * CFrame.Angles(0, math.rad(rotation or 0), 0)
	part(parent, "BenchSeat", Vector3.new(8, 0.8, 2.2), cf * CFrame.new(0, 2.3, 0), Color3.fromRGB(115, 78, 52), Enum.Material.Wood)
	part(parent, "BenchBack", Vector3.new(8, 3.2, 0.7), cf * CFrame.new(0, 3.5, 0.9), Color3.fromRGB(115, 78, 52), Enum.Material.Wood)
	for _, x in ipairs({-3,3}) do
		part(parent, "BenchLeg", Vector3.new(0.7, 2.2, 0.7), cf * CFrame.new(x, 1.1, 0), Color3.fromRGB(55, 59, 66), Enum.Material.Metal)
	end
end

local function makePlanter(parent, pos, foliage)
	cylinder(parent, "HubPlanter", 9, 1.4, CFrame.new(pos + Vector3.new(0,0.8,0)), Color3.fromRGB(94, 98, 104), Enum.Material.Concrete)
	ball(parent, "HubBush", 7.2, pos + Vector3.new(0,4,0), foliage or Color3.fromRGB(72,136,75), Enum.Material.Grass)
end

local function makeHubMonument(parent, center)
	local stone = Color3.fromRGB(88, 93, 103)
	cylinder(parent, "MonumentBase", 34, 2.2, CFrame.new(center + Vector3.new(0,1.1,0)), stone, Enum.Material.Concrete)
	cylinder(parent, "MonumentStep", 26, 1.1, CFrame.new(center + Vector3.new(0,2.7,0)), Color3.fromRGB(128,132,140), Enum.Material.Concrete)
	cylinder(parent, "MonumentBasin", 20, 2, CFrame.new(center + Vector3.new(0,4,0)), Color3.fromRGB(49,54,63), Enum.Material.Metal)
	local water = cylinder(parent, "MonumentWater", 16, 0.35, CFrame.new(center + Vector3.new(0,5.1,0)), Color3.fromRGB(92,194,235), Enum.Material.Glass, 0.2)
	pointLight(water, Color3.fromRGB(104,205,255), 18, 0.8)

	part(parent, "MonumentSpire", Vector3.new(3, 14, 3), CFrame.new(center + Vector3.new(0,12,0)), stone, Enum.Material.Metal)
	local orb = ball(parent, "MonumentCore", 7, center + Vector3.new(0,20,0), Color3.fromRGB(152,100,255), Enum.Material.Glass, 0.08)
	pointLight(orb, orb.Color, 24, 1.4)
	addHighlight(orb, orb.Color)
end

local function decorateHub(parent)
	-- Stone border strips keep the grass/path transition crisp.
	for _, x in ipairs({-23,23}) do
		part(parent, "HubPathBorder", Vector3.new(1.5,0.25,280), CFrame.new(x,1.55,-180), Color3.fromRGB(137,139,143), Enum.Material.Concrete)
	end

	-- Plaza radial details and seating.
	for i=0,7 do
		local a=math.rad(i*45)
		local px=math.cos(a)*54
		local pz=-235+math.sin(a)*54
		makePlanter(parent, Vector3.new(px,1,pz), i%2==0 and Color3.fromRGB(89,150,84) or Color3.fromRGB(177,104,157))
	end
	for _, item in ipairs({
		{Vector3.new(-42,1,-236),90},{Vector3.new(42,1,-236),-90},
		{Vector3.new(-34,1,-282),180},{Vector3.new(34,1,-282),180},
	}) do
		makeBench(parent,item[1],item[2])
	end

	-- A restrained entrance arch, replacing giant floating scenery.
	local archZ=-42
	part(parent,"HubArchL",Vector3.new(5,23,5),CFrame.new(-28,12,archZ),Color3.fromRGB(54,58,67),Enum.Material.Metal)
	part(parent,"HubArchR",Vector3.new(5,23,5),CFrame.new(28,12,archZ),Color3.fromRGB(54,58,67),Enum.Material.Metal)
	part(parent,"HubArchTop",Vector3.new(61,5,6),CFrame.new(0,23,archZ),Color3.fromRGB(54,58,67),Enum.Material.Metal)
	part(parent,"HubArchAccent",Vector3.new(48,0.45,0.6),CFrame.new(0,22.8,archZ-3.1),Color3.fromRGB(255,211,82),Enum.Material.Neon,0.18)
	local archSign=part(parent,"HubArchSign",Vector3.new(26,5.5,0.6),CFrame.new(0,18.3,archZ-3.2),Color3.fromRGB(243,244,247),Enum.Material.SmoothPlastic)
	surfaceLabel(archSign,Enum.NormalId.Front,"ANIME WORLDS",Color3.fromRGB(42,45,54),Color3.fromRGB(243,244,247))
end

local function configureLighting()
	Lighting.ClockTime = 13.2
	Lighting.Brightness = 2.8
	Lighting.ExposureCompensation = 0.02
	Lighting.Ambient = Color3.fromRGB(118, 124, 138)
	Lighting.OutdoorAmbient = Color3.fromRGB(172, 178, 190)
	Lighting.EnvironmentDiffuseScale = 0.55
	Lighting.EnvironmentSpecularScale = 0.75

	for _, name in ipairs({"AnimeBloom", "AnimeColor", "AnimeAtmosphere", "AnimeSunRays", "AnimeDOF"}) do
		local old = Lighting:FindFirstChild(name)
		if old then old:Destroy() end
	end

	local bloom = Instance.new("BloomEffect")
	bloom.Name = "AnimeBloom"
	bloom.Intensity = 0.08
	bloom.Size = 12
	bloom.Threshold = 1.8
	bloom.Parent = Lighting

	local color = Instance.new("ColorCorrectionEffect")
	color.Name = "AnimeColor"
	color.Saturation = 0.12
	color.Contrast = 0.06
	color.Brightness = -0.01
	color.Parent = Lighting

	local atmosphere = Instance.new("Atmosphere")
	atmosphere.Name = "AnimeAtmosphere"
	atmosphere.Density = 0.16
	atmosphere.Offset = 0.05
	atmosphere.Color = Color3.fromRGB(213, 228, 244)
	atmosphere.Decay = Color3.fromRGB(122, 145, 170)
	atmosphere.Glare = 0.04
	atmosphere.Haze = 0.28
	atmosphere.Parent = Lighting

	local rays = Instance.new("SunRaysEffect")
	rays.Name = "AnimeSunRays"
	rays.Intensity = 0.035
	rays.Spread = 0.7
	rays.Parent = Lighting

	local dof = Instance.new("DepthOfFieldEffect")
	dof.Name = "AnimeDOF"
	dof.FocusDistance = 85
	dof.InFocusRadius = 70
	dof.NearIntensity = 0
	dof.FarIntensity = 0.07
	dof.Parent = Lighting

	local oldClouds = Terrain:FindFirstChild("AnimeClouds")
	if oldClouds then oldClouds:Destroy() end
	local clouds = Instance.new("Clouds")
	clouds.Name = "AnimeClouds"
	clouds.Cover = 0.22
	clouds.Density = 0.28
	clouds.Color = Color3.fromRGB(255, 255, 255)
	clouds.Parent = Terrain
end

function WorldBuilder.Build(Config)
	local old = workspace:FindFirstChild("AnimeEggWorld")
	if old then old:Destroy() end
	local baseplate = workspace:FindFirstChild("Baseplate")
	if baseplate then baseplate:Destroy() end
	Terrain:Clear()

	configureLighting()

	local world = Instance.new("Model")
	world.Name = "AnimeEggWorld"
	world.Parent = workspace

	-- Continuous rock underlay so there are no open gaps between themed worlds.
	part(world, "WorldUnderlay", Vector3.new(320, 4, 2325), CFrame.new(0, -3, 825), Color3.fromRGB(74, 70, 65), Enum.Material.Rock)

	local minZ = -340
	local maxZ = 1995
	decorateBoundary(world, minZ, maxZ)

	-- Hub inspired by modern simulator flow: bright lawn, fenced plots, central steal lane.
	local hubFloor=part(world,"HubFloor",Vector3.new(320,4,290),CFrame.new(0,-1,-185),Color3.fromRGB(101,205,78),Enum.Material.Grass)
	hubFloor.TopSurface=Enum.SurfaceType.Smooth
	local hubRoad=part(world,"HubRoad",Vector3.new(46,0.55,300),CFrame.new(0,1.2,-180),Color3.fromRGB(210,196,165),Enum.Material.Concrete)
	hubRoad.TopSurface=Enum.SurfaceType.Smooth

	-- Wood fences define the lane like a polished steal/simulator map.
	for _,x in ipairs({-27,27}) do
		lowFence(world,Vector3.new(x,1,-178),276,false,Color3.fromRGB(148,86,46))
	end

	-- Central machine/landmark near spawn rather than a formal plaza.
	local hubMachine=Instance.new("Model")
	hubMachine.Name="HubEggMachine"
	hubMachine.Parent=world
	part(hubMachine,"MachineBase",Vector3.new(30,3,24),CFrame.new(0,2,-250),Color3.fromRGB(45,49,57),Enum.Material.Metal)
	part(hubMachine,"MachineBody",Vector3.new(24,18,18),CFrame.new(0,12,-250),Color3.fromRGB(58,63,73),Enum.Material.Metal)
	part(hubMachine,"MachineScreen",Vector3.new(12,10,0.6),CFrame.new(0,12,-259.2),Color3.fromRGB(76,185,245),Enum.Material.Glass,0.12)
	local question=part(hubMachine,"Question",Vector3.new(6,8,0.35),CFrame.new(0,12,-259.6),Color3.fromRGB(240,244,250),Enum.Material.Neon,0.12)
	part(hubMachine,"MachineRoof",Vector3.new(29,2,23),CFrame.new(0,22,-250),Color3.fromRGB(31,34,41),Enum.Material.Metal)
	for _,x in ipairs({-9,9}) do
		part(hubMachine,"Antenna",Vector3.new(1,10,1),CFrame.new(x,28,-250),Color3.fromRGB(31,34,41),Enum.Material.Metal)
		ball(hubMachine,"AntennaGlow",2.6,Vector3.new(x,33.4,-250),Color3.fromRGB(154,98,255),Enum.Material.Neon,0.08)
	end

	-- Shop/Index as small side machines rather than bulky modern kiosks.
	makeKiosk(world,Vector3.new(-72,1,-250),"SHOP",Color3.fromRGB(72,216,98))
	makeKiosk(world,Vector3.new(72,1,-250),"INDEX",Color3.fromRGB(70,167,245))

	for z=-315,-55,34 do
		streetLamp(world,Vector3.new(-34,1,z),Color3.fromRGB(255,211,138))
		streetLamp(world,Vector3.new(34,1,z),Color3.fromRGB(255,211,138))
	end

	-- Trees and props fill dead space between bases and cliffs.
	for _,p in ipairs({
		Vector3.new(-150,1,-304),Vector3.new(150,1,-304),Vector3.new(-150,1,-236),Vector3.new(150,1,-236),
		Vector3.new(-150,1,-168),Vector3.new(150,1,-168),Vector3.new(-150,1,-100),Vector3.new(150,1,-100),
	}) do
		tree(world,p,Color3.fromRGB(235,147,194),0.9)
	end
	for _,p in ipairs({Vector3.new(-55,1,-294),Vector3.new(55,1,-294),Vector3.new(-55,1,-72),Vector3.new(55,1,-72)}) do
		makeBench(world,p,p.X<0 and 90 or -90)
	end

	-- Eight bases integrated into the hub.
	local colors = {
		Color3.fromRGB(255, 91, 103), Color3.fromRGB(255, 160, 60), Color3.fromRGB(255, 216, 65), Color3.fromRGB(76, 222, 103),
		Color3.fromRGB(62, 178, 255), Color3.fromRGB(137, 92, 255), Color3.fromRGB(235, 81, 207), Color3.fromRGB(77, 218, 213),
	}
	local bases = {}
	local baseZs = {-300, -230, -160, -90}
	for i, z in ipairs(baseZs) do
		table.insert(bases, makeBase(world, i, Vector3.new(-112, 1, z), colors[i]))
	end
	for i, z in ipairs(baseZs) do
		local idx = i + 4
		table.insert(bases, makeBase(world, idx, Vector3.new(112, 1, z), colors[idx]))
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

		addWorldTerrain(worldConfig)

		local gateZ = z - 126
		table.insert(gates, portalGate(world, gateZ, worldConfig, index))

		local builder = WORLD_BUILDERS[worldConfig.Key]
		if builder then
			builder(world, worldConfig)
		end

		for capsuleIndex, x in ipairs({-48, 0, 48}) do
			table.insert(eggs, eggShrine(world, worldConfig, Vector3.new(x, 2.8, z + 78), capsuleIndex))
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
