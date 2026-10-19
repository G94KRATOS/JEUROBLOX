local RunService = game:GetService("RunService")

local HeroFactory = {}

local WORLD_STYLE = {
	Naruto = {
		Body = Color3.fromRGB(225, 105, 43),
		Secondary = Color3.fromRGB(35, 52, 77),
		Hair = Color3.fromRGB(242, 196, 61),
		Skin = Color3.fromRGB(239, 194, 158),
		Feature = "Headband",
	},
	OnePiece = {
		Body = Color3.fromRGB(205, 62, 51),
		Secondary = Color3.fromRGB(48, 91, 157),
		Hair = Color3.fromRGB(45, 38, 34),
		Skin = Color3.fromRGB(235, 188, 148),
		Feature = "Hat",
	},
	DragonBall = {
		Body = Color3.fromRGB(230, 111, 38),
		Secondary = Color3.fromRGB(46, 75, 154),
		Hair = Color3.fromRGB(244, 205, 63),
		Skin = Color3.fromRGB(238, 190, 147),
		Feature = "Spikes",
	},
	DemonSlayer = {
		Body = Color3.fromRGB(46, 96, 79),
		Secondary = Color3.fromRGB(30, 34, 40),
		Hair = Color3.fromRGB(50, 43, 43),
		Skin = Color3.fromRGB(239, 198, 162),
		Feature = "Katana",
	},
	JJK = {
		Body = Color3.fromRGB(47, 51, 65),
		Secondary = Color3.fromRGB(92, 70, 141),
		Hair = Color3.fromRGB(220, 225, 232),
		Skin = Color3.fromRGB(239, 197, 164),
		Feature = "Blindfold",
	},
	Bleach = {
		Body = Color3.fromRGB(34, 36, 41),
		Secondary = Color3.fromRGB(232, 235, 240),
		Hair = Color3.fromRGB(221, 113, 45),
		Skin = Color3.fromRGB(239, 197, 161),
		Feature = "Sword",
	},
	AOT = {
		Body = Color3.fromRGB(93, 111, 84),
		Secondary = Color3.fromRGB(74, 54, 42),
		Hair = Color3.fromRGB(61, 48, 41),
		Skin = Color3.fromRGB(234, 186, 148),
		Feature = "Blades",
	},
}

local HERO_OVERRIDES = {
	-- Shinobi world
	["Kakashi"] = {Body=Color3.fromRGB(73,95,78),Secondary=Color3.fromRGB(45,55,65),Hair=Color3.fromRGB(205,211,218),Skin=Color3.fromRGB(231,188,155),Feature="Mask"},
	["Gaara"] = {Body=Color3.fromRGB(122,70,56),Secondary=Color3.fromRGB(93,63,54),Hair=Color3.fromRGB(168,58,43),Skin=Color3.fromRGB(230,184,154),Feature="Headband"},
	["Itachi"] = {Body=Color3.fromRGB(35,37,43),Secondary=Color3.fromRGB(181,45,54),Hair=Color3.fromRGB(28,30,34),Skin=Color3.fromRGB(230,184,154),Feature="Headband"},
	["Naruto Sage"] = {Body=Color3.fromRGB(231,111,35),Secondary=Color3.fromRGB(42,53,72),Hair=Color3.fromRGB(244,202,58),Skin=Color3.fromRGB(239,194,158),Feature="Headband"},
	["Six Paths Naruto"] = {Body=Color3.fromRGB(244,214,103),Secondary=Color3.fromRGB(44,50,59),Hair=Color3.fromRGB(248,216,71),Skin=Color3.fromRGB(241,199,162),Feature="Spikes"},
	["Madara"] = {Body=Color3.fromRGB(104,41,45),Secondary=Color3.fromRGB(54,37,41),Hair=Color3.fromRGB(28,29,33),Skin=Color3.fromRGB(229,182,151),Feature="Spikes"},

	-- Pirate world
	["Nami"] = {Body=Color3.fromRGB(77,151,199),Secondary=Color3.fromRGB(235,230,212),Hair=Color3.fromRGB(223,112,45),Skin=Color3.fromRGB(237,188,149),Feature="Hat"},
	["Sanji"] = {Body=Color3.fromRGB(43,47,56),Secondary=Color3.fromRGB(60,67,78),Hair=Color3.fromRGB(225,191,83),Skin=Color3.fromRGB(237,189,149),Feature="Hat"},
	["Zoro"] = {Body=Color3.fromRGB(57,124,77),Secondary=Color3.fromRGB(39,45,46),Hair=Color3.fromRGB(92,174,91),Skin=Color3.fromRGB(232,185,146),Feature="Sword"},
	["Ace"] = {Body=Color3.fromRGB(198,86,45),Secondary=Color3.fromRGB(46,49,57),Hair=Color3.fromRGB(31,32,35),Skin=Color3.fromRGB(231,179,139),Feature="Hat"},
	["Law"] = {Body=Color3.fromRGB(59,69,85),Secondary=Color3.fromRGB(227,225,216),Hair=Color3.fromRGB(30,31,34),Skin=Color3.fromRGB(230,183,146),Feature="Hat"},
	["Shanks"] = {Body=Color3.fromRGB(153,47,49),Secondary=Color3.fromRGB(42,44,49),Hair=Color3.fromRGB(156,45,43),Skin=Color3.fromRGB(231,181,144),Feature="Sword"},
	["Luffy Gear 4"] = {Body=Color3.fromRGB(193,49,49),Secondary=Color3.fromRGB(38,40,46),Hair=Color3.fromRGB(29,30,34),Skin=Color3.fromRGB(231,178,139),Feature="Hat"},
	["Luffy Gear 5"] = {Body=Color3.fromRGB(237,237,231),Secondary=Color3.fromRGB(186,186,181),Hair=Color3.fromRGB(245,245,240),Skin=Color3.fromRGB(235,187,147),Feature="Spikes"},

	-- Saiyan world
	["Vegeta"] = {Body=Color3.fromRGB(43,70,155),Secondary=Color3.fromRGB(235,236,239),Hair=Color3.fromRGB(245,205,64),Skin=Color3.fromRGB(235,184,143),Feature="Spikes"},
	["Goku Super Saiyan"] = {Body=Color3.fromRGB(231,111,36),Secondary=Color3.fromRGB(49,77,157),Hair=Color3.fromRGB(247,211,66),Skin=Color3.fromRGB(237,187,145),Feature="Spikes"},
	["Broly"] = {Body=Color3.fromRGB(83,158,88),Secondary=Color3.fromRGB(107,67,143),Hair=Color3.fromRGB(222,232,90),Skin=Color3.fromRGB(222,169,126),Feature="Spikes"},
	["Gohan Beast"] = {Body=Color3.fromRGB(94,78,146),Secondary=Color3.fromRGB(47,49,58),Hair=Color3.fromRGB(229,232,239),Skin=Color3.fromRGB(237,188,148),Feature="Spikes"},
	["Ultra Instinct Goku"] = {Body=Color3.fromRGB(59,63,71),Secondary=Color3.fromRGB(42,45,52),Hair=Color3.fromRGB(207,214,222),Skin=Color3.fromRGB(238,189,147),Feature="Spikes"},

	-- Demon slayer world
	["Tanjiro"] = {Body=Color3.fromRGB(46,103,78),Secondary=Color3.fromRGB(31,35,41),Hair=Color3.fromRGB(88,43,42),Skin=Color3.fromRGB(237,191,156),Feature="Katana"},
	["Zenitsu"] = {Body=Color3.fromRGB(229,164,48),Secondary=Color3.fromRGB(246,232,180),Hair=Color3.fromRGB(235,193,63),Skin=Color3.fromRGB(238,194,159),Feature="Katana"},
	["Giyu"] = {Body=Color3.fromRGB(48,87,125),Secondary=Color3.fromRGB(115,55,52),Hair=Color3.fromRGB(36,39,44),Skin=Color3.fromRGB(235,188,153),Feature="Katana"},
	["Rengoku"] = {Body=Color3.fromRGB(239,225,187),Secondary=Color3.fromRGB(196,56,45),Hair=Color3.fromRGB(239,198,66),Skin=Color3.fromRGB(238,192,155),Feature="Katana"},
	["Akaza"] = {Body=Color3.fromRGB(180,103,124),Secondary=Color3.fromRGB(77,104,165),Hair=Color3.fromRGB(194,78,89),Skin=Color3.fromRGB(231,174,149),Feature="Spikes"},
	["Yoriichi"] = {Body=Color3.fromRGB(120,48,50),Secondary=Color3.fromRGB(38,40,46),Hair=Color3.fromRGB(75,38,38),Skin=Color3.fromRGB(232,184,150),Feature="Katana"},

	-- Cursed world
	["Gojo"] = {Body=Color3.fromRGB(45,49,61),Secondary=Color3.fromRGB(24,26,31),Hair=Color3.fromRGB(226,232,240),Skin=Color3.fromRGB(239,196,163),Feature="Blindfold"},
	["Awakened Gojo"] = {Body=Color3.fromRGB(225,229,236),Secondary=Color3.fromRGB(67,177,226),Hair=Color3.fromRGB(241,244,248),Skin=Color3.fromRGB(240,198,165),Feature="Blindfold"},
	["Sukuna"] = {Body=Color3.fromRGB(59,55,64),Secondary=Color3.fromRGB(170,63,73),Hair=Color3.fromRGB(225,121,130),Skin=Color3.fromRGB(229,176,150),Feature="Spikes"},
	["Megumi"] = {Body=Color3.fromRGB(48,53,66),Secondary=Color3.fromRGB(31,34,41),Hair=Color3.fromRGB(31,34,38),Skin=Color3.fromRGB(236,190,157),Feature="Spikes"},
	["Nobara"] = {Body=Color3.fromRGB(60,62,70),Secondary=Color3.fromRGB(122,79,48),Hair=Color3.fromRGB(181,111,60),Skin=Color3.fromRGB(239,194,160),Feature="Sword"},
	["Toji"] = {Body=Color3.fromRGB(42,47,50),Secondary=Color3.fromRGB(58,68,70),Hair=Color3.fromRGB(31,33,36),Skin=Color3.fromRGB(226,176,142),Feature="Sword"},

	-- Soul world
	["Ichigo"] = {Body=Color3.fromRGB(32,34,39),Secondary=Color3.fromRGB(232,235,239),Hair=Color3.fromRGB(226,121,49),Skin=Color3.fromRGB(238,192,156),Feature="Sword"},
	["Aizen"] = {Body=Color3.fromRGB(232,231,219),Secondary=Color3.fromRGB(78,66,57),Hair=Color3.fromRGB(121,80,53),Skin=Color3.fromRGB(235,189,155),Feature="Sword"},
	["Kenpachi"] = {Body=Color3.fromRGB(37,39,44),Secondary=Color3.fromRGB(230,231,226),Hair=Color3.fromRGB(31,32,35),Skin=Color3.fromRGB(221,168,136),Feature="Spikes"},
	["True Bankai Ichigo"] = {Body=Color3.fromRGB(24,26,31),Secondary=Color3.fromRGB(195,45,52),Hair=Color3.fromRGB(38,39,43),Skin=Color3.fromRGB(236,189,154),Feature="Sword"},

	-- Titan world
	["Levi"] = {Body=Color3.fromRGB(79,96,77),Secondary=Color3.fromRGB(72,53,42),Hair=Color3.fromRGB(30,32,35),Skin=Color3.fromRGB(232,184,150),Feature="Blades"},
	["Mikasa"] = {Body=Color3.fromRGB(75,91,76),Secondary=Color3.fromRGB(148,47,51),Hair=Color3.fromRGB(37,38,42),Skin=Color3.fromRGB(235,187,151),Feature="Blades"},
	["Attack Titan Eren"] = {Body=Color3.fromRGB(183,111,88),Secondary=Color3.fromRGB(96,54,47),Hair=Color3.fromRGB(65,45,38),Skin=Color3.fromRGB(207,135,105),Feature="Spikes"},
	["Armored Titan"] = {Body=Color3.fromRGB(191,157,119),Secondary=Color3.fromRGB(214,194,154),Hair=Color3.fromRGB(216,194,139),Skin=Color3.fromRGB(205,158,121),Feature="Spikes"},
	["Founding Titan"] = {Body=Color3.fromRGB(137,91,82),Secondary=Color3.fromRGB(82,61,58),Hair=Color3.fromRGB(76,55,50),Skin=Color3.fromRGB(197,139,117),Feature="Spikes"},
}


local function part(parent, name, size, cf, color, material, transparency)
	local p = Instance.new("Part")
	p.Name = name
	p.Anchored = true
	p.CanCollide = false
	p.CanTouch = false
	p.CanQuery = false
	p.CastShadow = true
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
	p.CanCollide = false
	p.CanTouch = false
	p.CanQuery = false
	p.CastShadow = true
	p.Size = size
	p.CFrame = cf
	p.Color = color
	p.Material = material or Enum.Material.SmoothPlastic
	p.Transparency = transparency or 0
	p.Parent = parent
	return p
end

local function ball(parent, name, diameter, cf, color, material, transparency)
	local p = part(parent, name, Vector3.new(diameter, diameter, diameter), cf, color, material, transparency)
	p.Shape = Enum.PartType.Ball
	return p
end

local function cylinder(parent, name, diameter, height, cf, color, material, transparency)
	local p = part(parent, name, Vector3.new(height, diameter, diameter), cf * CFrame.Angles(0, 0, math.rad(90)), color, material, transparency)
	p.Shape = Enum.PartType.Cylinder
	return p
end

local function billboard(parent, hero, rarityColor)
	local gui = Instance.new("BillboardGui")
	gui.Name = "HeroBillboard"
	gui.Size = UDim2.fromOffset(190, 48)
	gui.StudsOffset = Vector3.new(0, 7.1, 0)
	gui.AlwaysOnTop = false
	gui.MaxDistance = 90
	gui.Parent = parent

	local name = Instance.new("TextLabel")
	name.Size = UDim2.new(1, 0, 0.58, 0)
	name.BackgroundTransparency = 1
	name.Text = hero.Name
	name.TextColor3 = Color3.fromRGB(255, 255, 255)
	name.TextStrokeColor3 = Color3.fromRGB(20, 22, 26)
	name.TextStrokeTransparency = 0.18
	name.TextScaled = true
	name.Font = Enum.Font.GothamBlack
	name.Parent = gui

	local rarity = Instance.new("TextLabel")
	rarity.Position = UDim2.new(0, 0, 0.58, 0)
	rarity.Size = UDim2.new(1, 0, 0.42, 0)
	rarity.BackgroundTransparency = 1
	rarity.Text = hero.Rarity
	rarity.TextColor3 = rarityColor
	rarity.TextStrokeColor3 = Color3.fromRGB(20, 22, 26)
	rarity.TextStrokeTransparency = 0.25
	rarity.TextScaled = true
	rarity.Font = Enum.Font.GothamBold
	rarity.Parent = gui
end

local function addAura(model, root, color, rarity, scale)
	local ring = cylinder(model, "AuraRing", 6.3 * scale, 0.18, root.CFrame * CFrame.new(0, 0.22, 0), color, Enum.Material.Neon, 0.42)
	ring.CastShadow = false

	if rarity == "Legendary" or rarity == "Mythic" or rarity == "Secret" then
		for i = 1, 5 do
			local angle = math.rad((i - 1) * 72)
			local orb = ball(
				model,
				"AuraOrb",
				0.65 * scale,
				root.CFrame * CFrame.new(math.cos(angle) * 3.1 * scale, 2 + (i % 2) * 0.8, math.sin(angle) * 3.1 * scale),
				color,
				Enum.Material.Neon,
				0.16
			)
			orb.CastShadow = false
		end
	end
end

local function addHairSpikes(model, cf, color, scale)
	for i = 0, 7 do
		local angle = math.rad(i * 45)
		local spike = wedge(
			model,
			"HairSpike",
			Vector3.new(1.0 * scale, 2.8 * scale, 1.5 * scale),
			cf * CFrame.Angles(0, angle, 0) * CFrame.new(0, 1.0 * scale, -1.6 * scale) * CFrame.Angles(math.rad(-18), 0, 0),
			color,
			Enum.Material.SmoothPlastic
		)
		spike.CastShadow = true
	end
end

local function addFeature(model, feature, base, style, scale)
	if feature == "Headband" then
		part(model, "Headband", Vector3.new(3.6 * scale, 0.55 * scale, 3.45 * scale), base * CFrame.new(0, 5.65 * scale, -0.1), style.Secondary, Enum.Material.Metal)
		part(model, "HeadbandPlate", Vector3.new(1.65 * scale, 0.7 * scale, 0.18 * scale), base * CFrame.new(0, 5.65 * scale, -1.78 * scale), Color3.fromRGB(175, 185, 194), Enum.Material.Metal)
	elseif feature == "Hat" then
		cylinder(model, "HatBrim", 5.4 * scale, 0.38 * scale, base * CFrame.new(0, 6.75 * scale, 0), Color3.fromRGB(221, 176, 75), Enum.Material.Fabric)
		cylinder(model, "HatCrown", 3.7 * scale, 1.5 * scale, base * CFrame.new(0, 7.35 * scale, 0), Color3.fromRGB(221, 176, 75), Enum.Material.Fabric)
		part(model, "HatBand", Vector3.new(0.35 * scale, 3.8 * scale, 3.8 * scale), base * CFrame.new(0, 7.05 * scale, 0) * CFrame.Angles(0, 0, math.rad(90)), Color3.fromRGB(171, 50, 46), Enum.Material.SmoothPlastic)
	elseif feature == "Spikes" then
		addHairSpikes(model, base * CFrame.new(0, 6.5 * scale, 0), style.Hair, scale)
	elseif feature == "Katana" or feature == "Sword" then
		part(model, "SwordBlade", Vector3.new(0.45 * scale, 6.2 * scale, 0.22 * scale), base * CFrame.new(2.45 * scale, 2.8 * scale, 0) * CFrame.Angles(0, 0, math.rad(-10)), Color3.fromRGB(210, 220, 230), Enum.Material.Metal)
		part(model, "SwordHandle", Vector3.new(0.75 * scale, 1.8 * scale, 0.55 * scale), base * CFrame.new(2.7 * scale, -0.2 * scale, 0), style.Secondary, Enum.Material.Wood)
	elseif feature == "Blindfold" then
		part(model, "Blindfold", Vector3.new(3.3 * scale, 0.72 * scale, 0.35 * scale), base * CFrame.new(0, 5.35 * scale, -1.62 * scale), Color3.fromRGB(20, 22, 27), Enum.Material.Fabric)
	elseif feature == "Mask" then
		part(model, "FaceMask", Vector3.new(3.2 * scale, 1.2 * scale, 0.35 * scale), base * CFrame.new(0, 6.7 * scale, -1.55 * scale), Color3.fromRGB(35, 39, 47), Enum.Material.Fabric)
		part(model, "ForeheadBand", Vector3.new(3.5 * scale, 0.6 * scale, 0.35 * scale), base * CFrame.new(0, 8.05 * scale, -1.55 * scale), Color3.fromRGB(70, 87, 109), Enum.Material.Fabric)
	elseif feature == "Blades" then
		for _, x in ipairs({-2.25, 2.25}) do
			part(model, "Blade", Vector3.new(0.35 * scale, 4.6 * scale, 0.22 * scale), base * CFrame.new(x * scale, 2.5 * scale, 0) * CFrame.Angles(0, 0, math.rad(x < 0 and 8 or -8)), Color3.fromRGB(204, 214, 222), Enum.Material.Metal)
		end
	end
end

function HeroFactory.Create(hero, rarityColor, scale)
	scale = scale or 1
	local style = HERO_OVERRIDES[hero.Name] or WORLD_STYLE[hero.WorldKey] or WORLD_STYLE.Naruto

	local model = Instance.new("Model")
	model.Name = "Hero_" .. tostring(hero.Name)
	model:SetAttribute("WorldKey", hero.WorldKey or "Naruto")
	model:SetAttribute("Rarity", hero.Rarity or "Common")
	model:SetAttribute("HeroName", hero.Name or "Hero")

	local root = part(model, "Root", Vector3.new(1, 1, 1), CFrame.new(), Color3.new(1,1,1), Enum.Material.SmoothPlastic, 1)
	root.CastShadow = false
	model.PrimaryPart = root

	-- Layered body proportions instead of a single block.
	part(model, "LegL", Vector3.new(1.15 * scale, 3.0 * scale, 1.25 * scale), CFrame.new(-0.8 * scale, 1.8 * scale, 0), style.Secondary, Enum.Material.Fabric)
	part(model, "LegR", Vector3.new(1.15 * scale, 3.0 * scale, 1.25 * scale), CFrame.new(0.8 * scale, 1.8 * scale, 0), style.Secondary, Enum.Material.Fabric)
	part(model, "BootL", Vector3.new(1.3 * scale, 0.75 * scale, 1.7 * scale), CFrame.new(-0.8 * scale, 0.45 * scale, -0.2 * scale), Color3.fromRGB(36, 38, 44), Enum.Material.Fabric)
	part(model, "BootR", Vector3.new(1.3 * scale, 0.75 * scale, 1.7 * scale), CFrame.new(0.8 * scale, 0.45 * scale, -0.2 * scale), Color3.fromRGB(36, 38, 44), Enum.Material.Fabric)

	part(model, "Torso", Vector3.new(3.9 * scale, 3.8 * scale, 2.0 * scale), CFrame.new(0, 4.8 * scale, 0), style.Body, Enum.Material.Fabric)
	part(model, "Vest", Vector3.new(3.45 * scale, 2.5 * scale, 2.18 * scale), CFrame.new(0, 5.0 * scale, 0), style.Secondary, Enum.Material.Fabric, 0.05)
	part(model, "Belt", Vector3.new(4.0 * scale, 0.45 * scale, 2.12 * scale), CFrame.new(0, 3.5 * scale, 0), rarityColor, Enum.Material.SmoothPlastic, 0.08)

	for _, x in ipairs({-2.5, 2.5}) do
		part(model, x < 0 and "ArmL" or "ArmR", Vector3.new(1.0 * scale, 3.5 * scale, 1.0 * scale), CFrame.new(x * scale, 4.9 * scale, 0) * CFrame.Angles(0, 0, math.rad(x < 0 and -6 or 6)), style.Skin, Enum.Material.SmoothPlastic)
		part(model, x < 0 and "GloveL" or "GloveR", Vector3.new(1.15 * scale, 1.1 * scale, 1.15 * scale), CFrame.new(x * scale, 3.0 * scale, 0), style.Secondary, Enum.Material.Fabric)
	end

	ball(model, "Head", 3.0 * scale, CFrame.new(0, 7.6 * scale, 0), style.Skin, Enum.Material.SmoothPlastic)
	ball(model, "HairCap", 3.25 * scale, CFrame.new(0, 8.4 * scale, 0.1 * scale), style.Hair, Enum.Material.SmoothPlastic)
	part(model, "HairCut", Vector3.new(3.5 * scale, 1.8 * scale, 3.4 * scale), CFrame.new(0, 7.55 * scale, 0.55 * scale), style.Skin, Enum.Material.SmoothPlastic)

	-- Eyes and face add readability at close range.
	for _, x in ipairs({-0.55, 0.55}) do
		part(model, "Eye", Vector3.new(0.34 * scale, 0.18 * scale, 0.12 * scale), CFrame.new(x * scale, 7.72 * scale, -1.49 * scale), Color3.fromRGB(28, 31, 38), Enum.Material.SmoothPlastic)
	end

	addFeature(model, style.Feature, CFrame.new(), style, scale)
	addAura(model, root, rarityColor, hero.Rarity, scale)
	billboard(root, hero, rarityColor)

	return model
end

function HeroFactory.CreateFollower(player, hero, rarityColor)
	local model = HeroFactory.Create(hero, rarityColor, 0.9)
	model.Name = "FollowingHero"
	model.Parent = workspace

	local root = model.PrimaryPart
	if not root then
		model:Destroy()
		return nil
	end

	local current = CFrame.new()
	local initialized = false
	local alive = true

	local connection
	connection = RunService.Heartbeat:Connect(function(dt)
		if not alive or not model.Parent then
			if connection then connection:Disconnect() end
			return
		end

		local character = player.Character
		local playerRoot = character and character:FindFirstChild("HumanoidRootPart")
		if not playerRoot then return end

		local offset = playerRoot.CFrame:VectorToWorldSpace(Vector3.new(4.3, -2.9, 6.4))
		local targetPosition = playerRoot.Position + offset
		local facing = Vector3.new(playerRoot.Position.X, targetPosition.Y, playerRoot.Position.Z)
		local target = CFrame.lookAt(targetPosition, facing)

		if not initialized or (current.Position - targetPosition).Magnitude > 45 then
			current = target
			initialized = true
		else
			local alpha = 1 - math.exp(-dt * 7)
			current = current:Lerp(target, alpha)
		end

		local bob = math.sin(os.clock() * 4) * 0.12
		model:PivotTo(current * CFrame.new(0, bob, 0))
	end)

	model.Destroying:Connect(function()
		alive = false
		if connection then
			connection:Disconnect()
			connection = nil
		end
	end)

	return model
end

return HeroFactory
