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
	elseif feature == "Blades" then
		for _, x in ipairs({-2.25, 2.25}) do
			part(model, "Blade", Vector3.new(0.35 * scale, 4.6 * scale, 0.22 * scale), base * CFrame.new(x * scale, 2.5 * scale, 0) * CFrame.Angles(0, 0, math.rad(x < 0 and 8 or -8)), Color3.fromRGB(204, 214, 222), Enum.Material.Metal)
		end
	end
end

function HeroFactory.Create(hero, rarityColor, scale)
	scale = scale or 1
	local style = WORLD_STYLE[hero.WorldKey] or WORLD_STYLE.Naruto

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
	part(model, "BootL", Vector3.new(1.3 * scale, 0.75 * scale, 1.7 * scale), CFrame.new(-0.8 * scale, 0.45 * scale, -0.2 * scale), Color3.fromRGB(36, 38, 44), Enum.Material.Leather)
	part(model, "BootR", Vector3.new(1.3 * scale, 0.75 * scale, 1.7 * scale), CFrame.new(0.8 * scale, 0.45 * scale, -0.2 * scale), Color3.fromRGB(36, 38, 44), Enum.Material.Leather)

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
