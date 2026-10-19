local Lighting = game:GetService("Lighting")
local Terrain = workspace.Terrain

local ArtPass = {}

local function part(parent, name, size, cf, color, material, transparency, studs)
	local p = Instance.new("Part")
	p.Name = name
	p.Anchored = true
	p.Size = size
	p.CFrame = cf
	p.Color = color
	p.Material = material or Enum.Material.SmoothPlastic
	p.Transparency = transparency or 0
	p.TopSurface = studs and Enum.SurfaceType.Studs or Enum.SurfaceType.Smooth
	p.BottomSurface = Enum.SurfaceType.Smooth
	p.Parent = parent
	return p
end

local function ball(parent, name, size, pos, color, material)
	local p = part(parent, name, Vector3.new(size, size, size), CFrame.new(pos), color, material)
	p.Shape = Enum.PartType.Ball
	return p
end

local function billboard(parent, text, color, width, height, offset)
	local gui = Instance.new("BillboardGui")
	gui.Size = UDim2.fromOffset(width or 220, height or 54)
	gui.StudsOffset = offset or Vector3.new(0, 5, 0)
	gui.AlwaysOnTop = true
	gui.MaxDistance = 220
	gui.Parent = parent

	local label = Instance.new("TextLabel")
	label.Size = UDim2.fromScale(1, 1)
	label.BackgroundTransparency = 1
	label.Text = text
	label.TextColor3 = color or Color3.new(1,1,1)
	label.TextStrokeColor3 = Color3.fromRGB(20,20,20)
	label.TextStrokeTransparency = 0.25
	label.TextScaled = true
	label.Font = Enum.Font.GothamBlack
	label.Parent = gui
	return label
end

local function fence(parent, origin, length, axis, color)
	local spacing = 10
	local count = math.floor(length / spacing)
	for i = 0, count do
		local offset = -length/2 + i * spacing
		local pos = origin + (axis == "X" and Vector3.new(offset, 3, 0) or Vector3.new(0, 3, offset))
		part(parent, "FencePost", Vector3.new(1.6, 6, 1.6), CFrame.new(pos), Color3.fromRGB(87, 58, 40), Enum.Material.Wood)
	end
	for _, y in ipairs({2.2, 4.4}) do
		local size = axis == "X" and Vector3.new(length, 1.1, 0.9) or Vector3.new(0.9, 1.1, length)
		part(parent, "FenceRail", size, CFrame.new(origin + Vector3.new(0,y,0)), color or Color3.fromRGB(160, 88, 44), Enum.Material.Wood)
	end
end

local function torii(parent, center, accent, scale)
	scale = scale or 1
	local wood = Color3.fromRGB(202, 52, 48)
	part(parent, "ToriiLeft", Vector3.new(3*scale, 20*scale, 3*scale), CFrame.new(center + Vector3.new(-9*scale, 10*scale, 0)), wood, Enum.Material.Wood)
	part(parent, "ToriiRight", Vector3.new(3*scale, 20*scale, 3*scale), CFrame.new(center + Vector3.new(9*scale, 10*scale, 0)), wood, Enum.Material.Wood)
	part(parent, "ToriiBeam", Vector3.new(25*scale, 3*scale, 4*scale), CFrame.new(center + Vector3.new(0, 19*scale, 0)), wood, Enum.Material.Wood)
	part(parent, "ToriiCap", Vector3.new(30*scale, 2*scale, 3*scale), CFrame.new(center + Vector3.new(0, 22*scale, 0)), accent or Color3.fromRGB(255,211,88), Enum.Material.Neon)
end

local function sakuraTree(parent, pos, scale)
	scale = scale or 1
	part(parent, "Trunk", Vector3.new(3*scale, 15*scale, 3*scale), CFrame.new(pos + Vector3.new(0,7.5*scale,0)), Color3.fromRGB(105,71,52), Enum.Material.Wood)
	for _, off in ipairs({
		Vector3.new(0,16,0),
		Vector3.new(5,14,1),
		Vector3.new(-5,14,-1),
		Vector3.new(1,14,5),
		Vector3.new(-1,15,-5),
	}) do
		ball(parent, "Sakura", 9*scale, pos + off*scale, Color3.fromRGB(255,142,202), Enum.Material.SmoothPlastic)
	end
end

local function pine(parent, pos, color, scale)
	scale = scale or 1
	part(parent, "PineTrunk", Vector3.new(2.8*scale, 12*scale, 2.8*scale), CFrame.new(pos + Vector3.new(0,6*scale,0)), Color3.fromRGB(90,66,48), Enum.Material.Wood)
	for i = 0, 2 do
		local y = 11 + i*4
		local cone = Instance.new("Part")
		cone.Name = "PineCrown"
		cone.Anchored = true
		cone.Shape = Enum.PartType.Ball
		cone.Size = Vector3.new((13-i*2)*scale, (7+i)*scale, (13-i*2)*scale)
		cone.CFrame = CFrame.new(pos + Vector3.new(0,y*scale,0))
		cone.Color = color
		cone.Material = Enum.Material.SmoothPlastic
		cone.Parent = parent
	end
end

local function crystal(parent, pos, color, scale)
	scale = scale or 1
	local c = part(parent, "Crystal", Vector3.new(3*scale, 13*scale, 3*scale), CFrame.new(pos + Vector3.new(0,6.5*scale,0))*CFrame.Angles(0,0,math.rad(18)), color, Enum.Material.Neon)
	c.CanCollide = false
end

local function cactus(parent, pos, scale)
	scale = scale or 1
	local green = Color3.fromRGB(77, 151, 82)
	part(parent, "CactusBody", Vector3.new(3*scale, 13*scale, 3*scale), CFrame.new(pos + Vector3.new(0,6.5*scale,0)), green, Enum.Material.SmoothPlastic)
	part(parent, "CactusArm", Vector3.new(7*scale, 2.5*scale, 2.5*scale), CFrame.new(pos + Vector3.new(2.8*scale,7*scale,0)), green, Enum.Material.SmoothPlastic)
	part(parent, "CactusTip", Vector3.new(2.5*scale, 6*scale, 2.5*scale), CFrame.new(pos + Vector3.new(5.1*scale,9*scale,0)), green, Enum.Material.SmoothPlastic)
end

local function lantern(parent, pos, accent)
	part(parent, "LanternPost", Vector3.new(0.7,8,0.7), CFrame.new(pos + Vector3.new(0,4,0)), Color3.fromRGB(69,51,44), Enum.Material.Wood)
	local lamp = part(parent, "Lantern", Vector3.new(3,3,3), CFrame.new(pos + Vector3.new(0,8,0)), accent, Enum.Material.Neon)
	local light = Instance.new("PointLight")
	light.Color = accent
	light.Brightness = 1.3
	light.Range = 14
	light.Parent = lamp
end

local function dojo(parent, center, accent)
	part(parent, "DojoBody", Vector3.new(34,14,24), CFrame.new(center + Vector3.new(0,7,0)), Color3.fromRGB(241,221,186), Enum.Material.WoodPlanks)
	part(parent, "Roof1", Vector3.new(42,2,30), CFrame.new(center + Vector3.new(0,15,0)), Color3.fromRGB(58,67,74), Enum.Material.Slate)
	part(parent, "Roof2", Vector3.new(30,2,22), CFrame.new(center + Vector3.new(0,19,0)), Color3.fromRGB(50,58,66), Enum.Material.Slate)
	part(parent, "Door", Vector3.new(8,10,1), CFrame.new(center + Vector3.new(0,5,-12.6)), Color3.fromRGB(77,47,36), Enum.Material.Wood)
	part(parent, "DojoTrim", Vector3.new(36,0.6,1), CFrame.new(center + Vector3.new(0,12,-12.6)), accent, Enum.Material.Neon)
	local anchor = part(parent, "DojoSign", Vector3.new(1,1,1), CFrame.new(center + Vector3.new(0,17,-14)), accent, Enum.Material.Neon, 1)
	billboard(anchor, "ANIME DOJO", accent, 220, 44, Vector3.new())
end

local function blockTemple(parent, center, bodyColor, accent)
	for i = 0, 4 do
		local size = 52 - i*8
		part(parent, "TempleTier", Vector3.new(size, 5, size), CFrame.new(center + Vector3.new(0,2.5+i*5,0)), bodyColor, Enum.Material.Sandstone)
	end
	part(parent, "TempleDoor", Vector3.new(10,16,2), CFrame.new(center + Vector3.new(0,8,-27)), accent, Enum.Material.Neon)
end

local function giantGuardian(parent, center, name, mainColor, accent, weapon)
	local m = Instance.new("Model")
	m.Name = "Giant_" .. name
	m.Parent = parent
	local skin = Color3.fromRGB(244,204,170)
	local legL = part(m, "LegL", Vector3.new(7,18,7), CFrame.new(center + Vector3.new(-5,9,0)), Color3.fromRGB(38,46,64), Enum.Material.SmoothPlastic)
	local legR = part(m, "LegR", Vector3.new(7,18,7), CFrame.new(center + Vector3.new(5,9,0)), Color3.fromRGB(38,46,64), Enum.Material.SmoothPlastic)
	local torso = part(m, "Torso", Vector3.new(19,22,10), CFrame.new(center + Vector3.new(0,27,0)), mainColor, Enum.Material.SmoothPlastic)
	local head = ball(m, "Head", 14, center + Vector3.new(0,45,0), skin, Enum.Material.SmoothPlastic)
	local hair = ball(m, "Hair", 15.5, center + Vector3.new(0,50,0), accent, Enum.Material.Neon)
	hair.Size = Vector3.new(15.5,8,15.5)
	part(m, "ArmL", Vector3.new(6,20,6), CFrame.new(center + Vector3.new(-13,28,0))*CFrame.Angles(0,0,math.rad(-12)), skin, Enum.Material.SmoothPlastic)
	part(m, "ArmR", Vector3.new(6,20,6), CFrame.new(center + Vector3.new(13,28,0))*CFrame.Angles(0,0,math.rad(12)), skin, Enum.Material.SmoothPlastic)
	part(m, "Aura", Vector3.new(34,0.6,34), CFrame.new(center + Vector3.new(0,0.4,0)), accent, Enum.Material.Neon, 0.18)
	for i = 1, 8 do
		local angle = math.rad(i*45)
		local orb = ball(m, "AuraOrb", 2.8, center + Vector3.new(math.cos(angle)*19, 8+i%3*4, math.sin(angle)*19), accent, Enum.Material.Neon)
		orb.CanCollide = false
	end
	if weapon == "Sword" then
		part(m, "SwordBlade", Vector3.new(2.5,30,1), CFrame.new(center + Vector3.new(18,27,-3))*CFrame.Angles(0,0,math.rad(-25)), Color3.fromRGB(235,247,255), Enum.Material.Neon)
		part(m, "SwordHandle", Vector3.new(4,8,2.5), CFrame.new(center + Vector3.new(13,16,-3))*CFrame.Angles(0,0,math.rad(-25)), Color3.fromRGB(43,37,55), Enum.Material.Metal)
	end
	local tag = part(m, "Tag", Vector3.new(1,1,1), CFrame.new(center + Vector3.new(0,58,0)), accent, Enum.Material.Neon, 1)
	billboard(tag, name:upper(), accent, 260, 56, Vector3.new())
end

local function recolorExisting(world)
	local hub = world:FindFirstChild("HubFloor")
	if hub then
		hub.Color = Color3.fromRGB(83, 186, 76)
		hub.Material = Enum.Material.Grass
		hub.TopSurface = Enum.SurfaceType.Studs
	end
	local road = world:FindFirstChild("MainRoad")
	if road then
		road.Color = Color3.fromRGB(206, 193, 161)
		road.Material = Enum.Material.Sand
	end
	local ocean = world:FindFirstChild("Ocean")
	if ocean then
		ocean.Color = Color3.fromRGB(77, 173, 220)
		ocean.Transparency = 0.08
	end

	for _, base in ipairs(world:GetChildren()) do
		if base:IsA("Model") and string.find(base.Name, "PlayerBase_") then
			local floor = base:FindFirstChild("Floor")
			if floor then
				floor.Color = Color3.fromRGB(104, 198, 86)
				floor.Material = Enum.Material.Grass
				floor.TopSurface = Enum.SurfaceType.Studs
			end
			local back = base:FindFirstChild("BackWall")
			if back then
				back.Color = Color3.fromRGB(244, 214, 161)
				back.Material = Enum.Material.Brick
			end
		end
	end

	for _, zone in ipairs(world:GetChildren()) do
		if zone:IsA("Model") then
			local floor = zone:FindFirstChild("ZoneFloor")
			if floor then
				floor.TopSurface = Enum.SurfaceType.Studs
			end
		end
	end
end

function ArtPass.Apply(world, Config)
	local previous = world:FindFirstChild("Polish")
	if previous then previous:Destroy() end

	recolorExisting(world)

	Lighting.ClockTime = 13.2
	Lighting.Brightness = 3
	Lighting.Ambient = Color3.fromRGB(155,155,165)
	Lighting.OutdoorAmbient = Color3.fromRGB(185,190,205)

	local atmosphere = Lighting:FindFirstChild("AnimeAtmosphere") or Instance.new("Atmosphere")
	atmosphere.Name = "AnimeAtmosphere"
	atmosphere.Density = 0.18
	atmosphere.Offset = 0.1
	atmosphere.Color = Color3.fromRGB(210,231,255)
	atmosphere.Decay = Color3.fromRGB(120,160,205)
	atmosphere.Glare = 0.08
	atmosphere.Haze = 0.7
	atmosphere.Parent = Lighting

	local rays = Lighting:FindFirstChild("AnimeSunRays") or Instance.new("SunRaysEffect")
	rays.Name = "AnimeSunRays"
	rays.Intensity = 0.08
	rays.Spread = 0.75
	rays.Parent = Lighting

	local bloom = Lighting:FindFirstChild("AnimeBloom")
	if bloom then
		bloom.Intensity = 0.28
		bloom.Size = 24
		bloom.Threshold = 1.6
	end
	local color = Lighting:FindFirstChild("AnimeColor")
	if color then
		color.Saturation = 0.2
		color.Contrast = 0.04
		color.Brightness = 0.04
	end

	local clouds = Terrain:FindFirstChildOfClass("Clouds") or Instance.new("Clouds")
	clouds.Cover = 0.28
	clouds.Density = 0.3
	clouds.Color = Color3.fromRGB(255,255,255)
	clouds.Parent = Terrain

	local polish = Instance.new("Model")
	polish.Name = "Polish"
	polish.Parent = world

	-- Arena walls similar to bright tycoon maps
	local wallColor = Color3.fromRGB(222, 167, 107)
	part(polish, "LeftArenaWall", Vector3.new(8,42,1120), CFrame.new(-118,20,410), wallColor, Enum.Material.Brick)
	part(polish, "RightArenaWall", Vector3.new(8,42,1120), CFrame.new(118,20,410), wallColor, Enum.Material.Brick)
	part(polish, "BackArenaWall", Vector3.new(244,42,8), CFrame.new(0,20,-147), wallColor, Enum.Material.Brick)
	part(polish, "LeftTrim", Vector3.new(1.2,2,1120), CFrame.new(-113.7,41,410), Color3.fromRGB(83,227,102), Enum.Material.Neon)
	part(polish, "RightTrim", Vector3.new(1.2,2,1120), CFrame.new(113.7,41,410), Color3.fromRGB(83,227,102), Enum.Material.Neon)

	-- Hub pens and decor
	fence(polish, Vector3.new(0,1.5,-140), 220, "X", Color3.fromRGB(185,89,44))
	for _, x in ipairs({-104,-62,-20,22,64,106}) do
		lantern(polish, Vector3.new(x,1,-20), Color3.fromRGB(255,219,111))
	end
	torii(polish, Vector3.new(0,1,42), Color3.fromRGB(255,219,103), 1.15)
	dojo(polish, Vector3.new(-76,1,-8), Color3.fromRGB(255,105,165))

	-- Bright path edges
	for z = -40, 980, 28 do
		part(polish, "PathEdgeL", Vector3.new(1,0.25,16), CFrame.new(-18,1.7,z), Color3.fromRGB(255,255,255), Enum.Material.Neon, 0.08)
		part(polish, "PathEdgeR", Vector3.new(1,0.25,16), CFrame.new(18,1.7,z), Color3.fromRGB(255,255,255), Enum.Material.Neon, 0.08)
	end

	-- Biome landmark set
	local landmarks = {
		{z=145, color=Color3.fromRGB(255,125,191), name="SAKURA RONIN", kind="sakura"},
		{z=335, color=Color3.fromRGB(255,188,58), name="SUN TITAN", kind="desert"},
		{z=525, color=Color3.fromRGB(92,217,255), name="FROST EMPEROR", kind="ice"},
		{z=715, color=Color3.fromRGB(255,81,48), name="INFERNO SHOGUN", kind="fire"},
		{z=905, color=Color3.fromRGB(161,96,255), name="COSMIC SOVEREIGN", kind="cosmic"},
	}

	for index, data in ipairs(landmarks) do
		local z = data.z
		if data.kind == "sakura" then
			for _, x in ipairs({-85,-64,62,84}) do sakuraTree(polish, Vector3.new(x,1,z + (x%2==0 and 35 or -32)), 1.05) end
			torii(polish, Vector3.new(0,1,z-58), data.color, 0.9)
			dojo(polish, Vector3.new(72,1,z+45), data.color)
		elseif data.kind == "desert" then
			blockTemple(polish, Vector3.new(74,1,z+35), Color3.fromRGB(207,150,76), data.color)
			for _, x in ipairs({-88,-68,70,90}) do cactus(polish, Vector3.new(x,1,z + math.random(-55,55)), 1.15) end
		elseif data.kind == "ice" then
			for _, x in ipairs({-86,-70,72,88}) do
				pine(polish, Vector3.new(x,1,z + math.random(-55,55)), Color3.fromRGB(71,124,136), 1.1)
				crystal(polish, Vector3.new(x + (x<0 and 8 or -8),1,z + math.random(-45,45)), data.color, 1)
			end
			part(polish, "IceCastle", Vector3.new(34,24,28), CFrame.new(76,13,z+38), Color3.fromRGB(188,231,244), Enum.Material.Ice, 0.08)
		elseif data.kind == "fire" then
			for _, x in ipairs({-88,-72,74,90}) do
				local rock = part(polish, "VolcanicRock", Vector3.new(12,math.random(14,25),12), CFrame.new(x,8,z+math.random(-55,55))*CFrame.Angles(math.rad(8),math.rad(math.random(0,90)),0), Color3.fromRGB(55,48,52), Enum.Material.Slate)
				part(polish, "LavaCore", Vector3.new(5,0.5,5), rock.CFrame * CFrame.new(0,rock.Size.Y/2+0.3,0), data.color, Enum.Material.Neon)
			end
			torii(polish, Vector3.new(0,1,z-58), data.color, 0.95)
		else
			for _, x in ipairs({-88,-70,70,88}) do
				crystal(polish, Vector3.new(x,1,z+math.random(-60,60)), data.color, 1.4)
				for h=1,3 do
					local orb = ball(polish, "CosmicOrb", 5+h, Vector3.new(x,8+h*7,z+math.random(-30,30)), Color3.fromRGB(120+h*25,80+h*18,255), Enum.Material.Neon)
					orb.CanCollide = false
				end
			end
		end

		giantGuardian(polish, Vector3.new(78,1,z-18), data.name, Color3.fromRGB(43,48,67), data.color, "Sword")

		local title = part(polish, "BiomeTitle", Vector3.new(1,1,1), CFrame.new(0,18,z-65), data.color, Enum.Material.Neon, 1)
		billboard(title, Config.Zones[index].Name:upper(), data.color, 360, 74, Vector3.new())
	end
end

return ArtPass
