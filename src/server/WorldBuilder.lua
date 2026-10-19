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

local function ball(parent, name, size, pos, color, material)
	local p = part(parent, name, Vector3.new(size,size,size), CFrame.new(pos), color, material)
	p.Shape = Enum.PartType.Ball
	return p
end

local function billboard(parent, value, color, width, height, offset)
	local gui = Instance.new("BillboardGui")
	gui.Size = UDim2.fromOffset(width or 220, height or 50)
	gui.StudsOffset = offset or Vector3.new(0,5,0)
	gui.AlwaysOnTop = true
	gui.MaxDistance = 220
	gui.Parent = parent

	local label = Instance.new("TextLabel")
	label.Name = "Label"
	label.Size = UDim2.fromScale(1,1)
	label.BackgroundTransparency = 1
	label.Text = value
	label.TextColor3 = color or Color3.new(1,1,1)
	label.TextStrokeColor3 = Color3.fromRGB(30,30,30)
	label.TextStrokeTransparency = 0.18
	label.TextScaled = true
	label.Font = Enum.Font.GothamBlack
	label.Parent = gui
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

local function cylinder(parent, name, diameter, height, cf, color, material)
	local p = part(parent, name, Vector3.new(height, diameter, diameter), cf * CFrame.Angles(0,0,math.rad(90)), color, material)
	p.Shape = Enum.PartType.Cylinder
	return p
end

local function fence(parent, center, length, alongX)
	local wood = Color3.fromRGB(150,86,48)
	local posts = math.floor(length/8)
	for i=0,posts do
		local offset = -length/2 + i*(length/posts)
		local pos = center + (alongX and Vector3.new(offset,2.6,0) or Vector3.new(0,2.6,offset))
		part(parent,"FencePost",Vector3.new(1.1,5.2,1.1),CFrame.new(pos),wood,Enum.Material.Wood)
	end
	for _,y in ipairs({1.6,3.4}) do
		local size = alongX and Vector3.new(length,0.8,0.7) or Vector3.new(0.7,0.8,length)
		part(parent,"FenceRail",size,CFrame.new(center+Vector3.new(0,y,0)),wood,Enum.Material.Wood)
	end
end

local function tree(parent, pos, pink)
	part(parent,"Trunk",Vector3.new(3,14,3),CFrame.new(pos+Vector3.new(0,7,0)),Color3.fromRGB(104,72,50),Enum.Material.Wood)
	local c = pink and Color3.fromRGB(255,145,205) or Color3.fromRGB(70,145,78)
	for _,off in ipairs({Vector3.new(0,15,0),Vector3.new(5,13,0),Vector3.new(-5,13,1),Vector3.new(0,13,5),Vector3.new(0,14,-5)}) do
		local crown = ball(parent,"Leaves",9,pos+off,c,Enum.Material.SmoothPlastic)
		crown.CanCollide = false
	end
end

local function lantern(parent,pos)
	part(parent,"LanternPost",Vector3.new(0.8,8,0.8),CFrame.new(pos+Vector3.new(0,4,0)),Color3.fromRGB(77,54,40),Enum.Material.Wood)
	local lamp = part(parent,"Lantern",Vector3.new(3,3,3),CFrame.new(pos+Vector3.new(0,8.2,0)),Color3.fromRGB(255,194,88),Enum.Material.Neon)
	local light = Instance.new("PointLight")
	light.Color = lamp.Color
	light.Range = 14
	light.Brightness = 1.2
	light.Parent = lamp
end

local function torii(parent,pos,scale)
	scale = scale or 1
	local red = Color3.fromRGB(202,48,43)
	part(parent,"ToriiL",Vector3.new(3*scale,22*scale,3*scale),CFrame.new(pos+Vector3.new(-10*scale,11*scale,0)),red,Enum.Material.Wood)
	part(parent,"ToriiR",Vector3.new(3*scale,22*scale,3*scale),CFrame.new(pos+Vector3.new(10*scale,11*scale,0)),red,Enum.Material.Wood)
	part(parent,"ToriiBeam",Vector3.new(28*scale,3*scale,4*scale),CFrame.new(pos+Vector3.new(0,20*scale,0)),red,Enum.Material.Wood)
	part(parent,"ToriiTop",Vector3.new(34*scale,2*scale,4.5*scale),CFrame.new(pos+Vector3.new(0,23*scale,0)),Color3.fromRGB(54,50,52),Enum.Material.Slate)
end

local function house(parent,pos,accent,scale)
	scale = scale or 1
	local w,d,h = 24*scale,18*scale,13*scale
	part(parent,"House",Vector3.new(w,h,d),CFrame.new(pos+Vector3.new(0,h/2,0)),Color3.fromRGB(235,211,171),Enum.Material.WoodPlanks)
	part(parent,"Foundation",Vector3.new(w+3,1,d+3),CFrame.new(pos+Vector3.new(0,0.5,0)),Color3.fromRGB(110,100,86),Enum.Material.Slate)
	part(parent,"Door",Vector3.new(5*scale,8*scale,0.8),CFrame.new(pos+Vector3.new(0,4*scale,-d/2-0.4)),Color3.fromRGB(83,54,39),Enum.Material.Wood)
	part(parent,"Roof",Vector3.new(w+6,2,d+6),CFrame.new(pos+Vector3.new(0,h+2,0)),Color3.fromRGB(60,64,72),Enum.Material.Slate)
	part(parent,"RoofCap",Vector3.new(w+1,1.2,d+1),CFrame.new(pos+Vector3.new(0,h+4,0)),accent,Enum.Material.Neon)
	for _,x in ipairs({-7,7}) do
		part(parent,"Window",Vector3.new(4,4,0.5),CFrame.new(pos+Vector3.new(x*scale,7*scale,-d/2-0.5)),Color3.fromRGB(165,224,241),Enum.Material.Glass,0.2)
	end
end

local function trainingGround(parent,pos)
	local g=part(parent,"TrainingGround",Vector3.new(62,1,52),CFrame.new(pos),Color3.fromRGB(151,111,69),Enum.Material.Sand)
	g.TopSurface=Enum.SurfaceType.Studs
	fence(parent,pos+Vector3.new(0,0,-26),62,true)
	fence(parent,pos+Vector3.new(0,0,26),62,true)
	fence(parent,pos+Vector3.new(-31,0,0),52,false)
	fence(parent,pos+Vector3.new(31,0,0),52,false)
	for _,x in ipairs({-15,0,15}) do
		part(parent,"TrainingLog",Vector3.new(3,12,3),CFrame.new(pos+Vector3.new(x,6,7)),Color3.fromRGB(111,76,50),Enum.Material.Wood)
		local t=cylinder(parent,"Target",8,1,CFrame.new(pos+Vector3.new(x,8,-10)),Color3.fromRGB(235,226,206),Enum.Material.Wood)
		t.CanCollide=false
	end
end

local function statue(parent,pos,name,body,accent,hairColor)
	local m=Instance.new("Model")
	m.Name=name.."Statue"
	m.Parent=parent
	part(m,"LegL",Vector3.new(5,17,5),CFrame.new(pos+Vector3.new(-4,8.5,0)),Color3.fromRGB(45,48,58),Enum.Material.SmoothPlastic)
	part(m,"LegR",Vector3.new(5,17,5),CFrame.new(pos+Vector3.new(4,8.5,0)),Color3.fromRGB(45,48,58),Enum.Material.SmoothPlastic)
	part(m,"Torso",Vector3.new(15,19,8),CFrame.new(pos+Vector3.new(0,24,0)),body,Enum.Material.SmoothPlastic)
	part(m,"ArmL",Vector3.new(4.5,18,4.5),CFrame.new(pos+Vector3.new(-10,25,0))*CFrame.Angles(0,0,math.rad(-12)),Color3.fromRGB(239,197,165),Enum.Material.SmoothPlastic)
	part(m,"ArmR",Vector3.new(4.5,18,4.5),CFrame.new(pos+Vector3.new(10,25,0))*CFrame.Angles(0,0,math.rad(12)),Color3.fromRGB(239,197,165),Enum.Material.SmoothPlastic)
	local head=ball(m,"Head",12,pos+Vector3.new(0,39,0),Color3.fromRGB(239,197,165),Enum.Material.SmoothPlastic)
	local hair=ball(m,"Hair",13,pos+Vector3.new(0,43,0),hairColor,Enum.Material.SmoothPlastic)
	hair.Size=Vector3.new(13,7,13)
	part(m,"Aura",Vector3.new(28,0.4,28),CFrame.new(pos+Vector3.new(0,0.4,0)),accent,Enum.Material.Neon,0.18)
	local tag=part(m,"Tag",Vector3.new(1,1,1),CFrame.new(pos+Vector3.new(0,51,0)),accent,Enum.Material.Neon,1)
	billboard(tag,name,accent,230,48,Vector3.new())
end

local function makeBase(parent,index,center,accent)
	local m=Instance.new("Model")
	m.Name="PlayerBase_"..index
	m.Parent=parent

	local floor=part(m,"Floor",Vector3.new(44,1,36),CFrame.new(center),Color3.fromRGB(88,195,76),Enum.Material.Grass)
	floor.TopSurface=Enum.SurfaceType.Studs
	part(m,"BackWall",Vector3.new(44,9,1),CFrame.new(center+Vector3.new(0,4.5,18)),Color3.fromRGB(245,219,170),Enum.Material.Brick)
	part(m,"Accent",Vector3.new(44,0.7,1.2),CFrame.new(center+Vector3.new(0,8.4,17.6)),accent,Enum.Material.Neon)
	fence(m,center+Vector3.new(-22,0,0),36,false)
	fence(m,center+Vector3.new(22,0,0),36,false)

	local signAnchor=part(m,"SignAnchor",Vector3.new(1,1,1),CFrame.new(center+Vector3.new(0,10.5,17)),accent,Enum.Material.Neon,1)
	local signLabel=billboard(signAnchor,"BASE LIBRE",accent,220,46,Vector3.new())

	local deposit=part(m,"Deposit",Vector3.new(13,0.7,8),CFrame.new(center+Vector3.new(0,0.9,-12)),accent,Enum.Material.Neon,0.08)
	billboard(deposit,"DEPOSE ICI",Color3.new(1,1,1),140,28,Vector3.new(0,2.3,0))

	local training=part(m,"TrainingPad",Vector3.new(12,0.7,8),CFrame.new(center+Vector3.new(-14,0.9,-1)),Color3.fromRGB(70,202,255),Enum.Material.Neon,0.05)
	for x=-4,4,2 do
		part(m,"TreadLine",Vector3.new(0.45,0.14,7),CFrame.new(training.Position+Vector3.new(x,0.45,0)),Color3.fromRGB(232,250,255),Enum.Material.Neon)
	end
	billboard(training,"SPEED",Color3.fromRGB(85,216,255),110,26,Vector3.new(0,2.2,0))

	local bt=part(m,"BaseTerminal",Vector3.new(4.5,5.5,4.5),CFrame.new(center+Vector3.new(14,3,-5)),accent,Enum.Material.Metal)
	local bp=prompt(bt,"AMELIORER","Base")
	billboard(bt,"UPGRADE",accent,110,26,Vector3.new(0,4,0))

	local tt=part(m,"TrainTerminal",Vector3.new(4.5,5.5,4.5),CFrame.new(center+Vector3.new(14,3,3)),Color3.fromRGB(70,202,255),Enum.Material.Metal)
	local tp=prompt(tt,"AMELIORER","Speed")
	billboard(tt,"TAPIS",Color3.fromRGB(70,202,255),100,26,Vector3.new(0,4,0))

	local st=part(m,"ShieldTerminal",Vector3.new(4.5,5.5,4.5),CFrame.new(center+Vector3.new(-14,3,9)),Color3.fromRGB(105,232,255),Enum.Material.Metal)
	local sp=prompt(st,"ACTIVER","Bouclier")
	billboard(st,"SHIELD",Color3.fromRGB(105,232,255),100,26,Vector3.new(0,4,0))

	local heroFolder=Instance.new("Folder")
	heroFolder.Name="Heroes"
	heroFolder.Parent=m

	local standPositions={}
	for row=0,2 do
		for col=0,3 do
			local x=-12+col*8
			local z=5+row*5
			cylinder(m,"HeroStand",6,1,CFrame.new(center+Vector3.new(x,0.9,z)),Color3.fromRGB(225,218,203),Enum.Material.Concrete)
			table.insert(standPositions,CFrame.new(center+Vector3.new(x,3.2,z)))
		end
	end

	local shieldWalls={
		part(m,"ShieldFront",Vector3.new(44,12,1),CFrame.new(center+Vector3.new(0,6,-18)),Color3.fromRGB(88,226,255),Enum.Material.ForceField,1),
		part(m,"ShieldBack",Vector3.new(44,12,1),CFrame.new(center+Vector3.new(0,6,18)),Color3.fromRGB(88,226,255),Enum.Material.ForceField,1),
		part(m,"ShieldLeft",Vector3.new(1,12,36),CFrame.new(center+Vector3.new(-22,6,0)),Color3.fromRGB(88,226,255),Enum.Material.ForceField,1),
		part(m,"ShieldRight",Vector3.new(1,12,36),CFrame.new(center+Vector3.new(22,6,0)),Color3.fromRGB(88,226,255),Enum.Material.ForceField,1),
	}
	for _,w in ipairs(shieldWalls) do w.CanCollide=false end

	return {
		Index=index,Model=m,Position=center,Accent=accent,SignLabel=signLabel,
		Deposit=deposit,TrainingPad=training,BasePrompt=bp,TrainingPrompt=tp,
		ShieldPrompt=sp,ShieldWalls=shieldWalls,HeroFolder=heroFolder,StandPositions=standPositions,
	}
end

local function eggShrine(parent,pos,index,accent)
	local m=Instance.new("Model")
	m.Name="EggShrine_"..index
	m.Parent=parent
	cylinder(m,"Pedestal",13,4,CFrame.new(pos),Color3.fromRGB(111,102,91),Enum.Material.Slate)
	local glow=cylinder(m,"GlowRing",15,0.7,CFrame.new(pos+Vector3.new(0,2.3,0)),accent,Enum.Material.Neon)
	glow.Transparency=0.08
	local egg=part(m,"Egg",Vector3.new(6,8,6),CFrame.new(pos+Vector3.new(0,7,0)),Color3.fromRGB(239,241,246),Enum.Material.SmoothPlastic)
	egg.Shape=Enum.PartType.Ball
	egg.CanCollide=false
	local light=Instance.new("PointLight")
	light.Color=accent
	light.Range=18
	light.Brightness=2
	light.Parent=egg
	local pr=prompt(egg,"VOLER","Oeuf Ninja",0.55)
	billboard(egg,"OEUF NINJA",accent,155,30,Vector3.new(0,6,0))
	return {Model=m,Egg=egg,Prompt=pr,Accent=accent}
end

function WorldBuilder.Build(Config)
	local old=workspace:FindFirstChild("AnimeEggWorld")
	if old then old:Destroy() end
	local bp=workspace:FindFirstChild("Baseplate")
	if bp then bp:Destroy() end

	local world=Instance.new("Model")
	world.Name="AnimeEggWorld"
	world.Parent=workspace
	Lighting.ClockTime=13.5
	Lighting.Brightness=2.7
	Lighting.Ambient=Color3.fromRGB(150,153,162)
	Lighting.OutdoorAmbient=Color3.fromRGB(190,195,205)

	-- Guaranteed visible land. No Terrain API is used here so the map cannot disappear because of terrain/cloud errors.
	local hubFloor=part(world,"HubFloor",Vector3.new(300,4,230),CFrame.new(0,-1,-125),Color3.fromRGB(102,207,84),Enum.Material.Grass)
	hubFloor.TopSurface=Enum.SurfaceType.Studs
	local villageFloor=part(world,"VillageFloor",Vector3.new(300,4,370),CFrame.new(0,-1,175),Color3.fromRGB(104,202,84),Enum.Material.Grass)
	villageFloor.TopSurface=Enum.SurfaceType.Studs

	-- Canyon boundary and mountain backdrop.
	for _,x in ipairs({-150,150}) do
		part(world,"SideCliff",Vector3.new(18,55,610),CFrame.new(x,25,75),Color3.fromRGB(118,91,66),Enum.Material.Rock)
	end
	part(world,"BackCliff",Vector3.new(300,70,24),CFrame.new(0,33,365),Color3.fromRGB(110,104,94),Enum.Material.Rock)

	-- River, roads and bridges.
	part(world,"River",Vector3.new(24,1.5,310),CFrame.new(72,0.6,170),Color3.fromRGB(61,173,222),Enum.Material.Glass,0.08)
	for _,z in ipairs({85,230}) do
		part(world,"Bridge",Vector3.new(34,1.2,16),CFrame.new(72,2,z),Color3.fromRGB(145,91,52),Enum.Material.WoodPlanks)
		fence(world,Vector3.new(72,2.2,z-8),34,true)
		fence(world,Vector3.new(72,2.2,z+8),34,true)
	end

	local hubRoad=part(world,"HubRoad",Vector3.new(38,0.5,215),CFrame.new(0,1.25,-120),Color3.fromRGB(218,201,166),Enum.Material.Sand)
	hubRoad.TopSurface=Enum.SurfaceType.Studs
	local villageRoad=part(world,"VillageRoad",Vector3.new(34,0.5,370),CFrame.new(0,1.25,175),Color3.fromRGB(207,190,159),Enum.Material.Sand)
	villageRoad.TopSurface=Enum.SurfaceType.Studs

	for z=-210,340,18 do
		part(world,"RoadEdgeL",Vector3.new(2,0.3,9),CFrame.new(-18,1.5,z),Color3.fromRGB(128,120,107),Enum.Material.Slate)
		part(world,"RoadEdgeR",Vector3.new(2,0.3,9),CFrame.new(18,1.5,z),Color3.fromRGB(128,120,107),Enum.Material.Slate)
	end

	-- Hub title and entrance.
	local titleAnchor=part(world,"HubTitle",Vector3.new(1,1,1),CFrame.new(0,20,-215),Color3.new(1,1,1),Enum.Material.Neon,1)
	billboard(titleAnchor,"ANIME EGG HEIST",Color3.fromRGB(255,221,70),420,72,Vector3.new())
	torii(world,Vector3.new(0,1,-20),1.25)

	for _,z in ipairs({-205,-175,-145,-115,-85,-55}) do
		lantern(world,Vector3.new(-25,1,z))
		lantern(world,Vector3.new(25,1,z))
	end
	for _,pos in ipairs({Vector3.new(-130,1,-190),Vector3.new(130,1,-190),Vector3.new(-130,1,-110),Vector3.new(130,1,-110),Vector3.new(-130,1,-35),Vector3.new(130,1,-35)}) do
		tree(world,pos,true)
	end

	-- 8 player bases.
	local colors={
		Color3.fromRGB(255,90,101),Color3.fromRGB(255,160,60),Color3.fromRGB(255,215,65),Color3.fromRGB(76,222,103),
		Color3.fromRGB(62,178,255),Color3.fromRGB(137,92,255),Color3.fromRGB(235,81,207),Color3.fromRGB(77,218,213),
	}
	local bases={}
	local zs={-190,-145,-100,-55}
	for i,z in ipairs(zs) do
		table.insert(bases,makeBase(world,i,Vector3.new(-92,1,z),colors[i]))
	end
	for i,z in ipairs(zs) do
		local idx=i+4
		table.insert(bases,makeBase(world,idx,Vector3.new(92,1,z),colors[idx]))
	end

	-- Naruto village gate.
	part(world,"GateTowerL",Vector3.new(20,27,18),CFrame.new(-31,13.5,8),Color3.fromRGB(224,198,153),Enum.Material.Brick)
	part(world,"GateTowerR",Vector3.new(20,27,18),CFrame.new(31,13.5,8),Color3.fromRGB(224,198,153),Enum.Material.Brick)
	part(world,"GateRoofL",Vector3.new(27,3,25),CFrame.new(-31,29,8),Color3.fromRGB(62,65,72),Enum.Material.Slate)
	part(world,"GateRoofR",Vector3.new(27,3,25),CFrame.new(31,29,8),Color3.fromRGB(62,65,72),Enum.Material.Slate)
	part(world,"GateBeam",Vector3.new(44,5,8),CFrame.new(0,24,8),Color3.fromRGB(190,53,48),Enum.Material.Wood)
	local gateSign=part(world,"GateSign",Vector3.new(25,7,1),CFrame.new(0,24,3.5),Color3.fromRGB(66,61,56),Enum.Material.Wood)
	local sg=Instance.new("SurfaceGui")
	sg.Face=Enum.NormalId.Front
	sg.Parent=gateSign
	local st=Instance.new("TextLabel")
	st.Size=UDim2.fromScale(1,1)
	st.BackgroundTransparency=1
	st.Text="NARUTO SHIPPUDEN"
	st.TextColor3=Color3.fromRGB(255,221,105)
	st.TextScaled=true
	st.Font=Enum.Font.GothamBlack
	st.Parent=sg

	-- Village buildings.
	local buildings={
		{Vector3.new(-58,1,50),Color3.fromRGB(215,66,53),1.0},{Vector3.new(-102,1,82),Color3.fromRGB(255,180,65),0.95},
		{Vector3.new(-58,1,128),Color3.fromRGB(74,180,255),1.05},{Vector3.new(-101,1,170),Color3.fromRGB(210,75,60),0.95},
		{Vector3.new(-55,1,215),Color3.fromRGB(153,90,255),1.1},{Vector3.new(54,1,50),Color3.fromRGB(255,123,78),0.95},
		{Vector3.new(105,1,84),Color3.fromRGB(78,208,135),1.0},{Vector3.new(54,1,136),Color3.fromRGB(226,72,90),1.05},
		{Vector3.new(103,1,185),Color3.fromRGB(70,176,255),0.95},{Vector3.new(55,1,225),Color3.fromRGB(255,190,66),1.05},
	}
	for _,b in ipairs(buildings) do house(world,b[1],b[2],b[3]) end

	-- Ramen shop sign.
	house(world,Vector3.new(65,1,95),Color3.fromRGB(210,54,47),1.1)
	local ramen=part(world,"RamenSign",Vector3.new(14,4,1),CFrame.new(65,12,84),Color3.fromRGB(205,48,43),Enum.Material.SmoothPlastic)
	local rg=Instance.new("SurfaceGui")
	rg.Face=Enum.NormalId.Front
	rg.Parent=ramen
	local rt=Instance.new("TextLabel")
	rt.Size=UDim2.fromScale(1,1)
	rt.BackgroundTransparency=1
	rt.Text="RAMEN"
	rt.TextColor3=Color3.fromRGB(255,238,184)
	rt.TextScaled=true
	rt.Font=Enum.Font.GothamBlack
	rt.Parent=rg

	trainingGround(world,Vector3.new(-78,1.2,98))

	-- Village tower.
	for level=1,4 do
		local size=34-(level-1)*4
		cylinder(world,"TowerTier",size,8,CFrame.new(-82,6+(level-1)*9,255),Color3.fromRGB(229,204,166),Enum.Material.Brick)
		cylinder(world,"TowerRoof",size+8,2,CFrame.new(-82,11+(level-1)*9,255),Color3.fromRGB(181,55,48),Enum.Material.Slate)
	end
	local hokage=part(world,"TowerLabel",Vector3.new(1,1,1),CFrame.new(-82,45,255),Color3.new(1,1,1),Enum.Material.Neon,1)
	billboard(hokage,"HOKAGE TOWER",Color3.fromRGB(255,216,88),250,48,Vector3.new())

	-- Dense foliage.
	for _,pos in ipairs({
		Vector3.new(-125,1,35),Vector3.new(-125,1,140),Vector3.new(-120,1,230),
		Vector3.new(125,1,40),Vector3.new(125,1,145),Vector3.new(120,1,250),
		Vector3.new(-38,1,65),Vector3.new(39,1,173),Vector3.new(-40,1,242),
		Vector3.new(122,1,300),Vector3.new(-120,1,305),
	}) do tree(world,pos,true) end

	-- Egg sanctuary.
	local shrine=part(world,"EggShrineFloor",Vector3.new(105,1,76),CFrame.new(0,1.2,290),Color3.fromRGB(116,106,92),Enum.Material.Slate)
	shrine.TopSurface=Enum.SurfaceType.Studs
	torii(world,Vector3.new(0,1,250),0.95)

	local eggs={
		eggShrine(world,Vector3.new(-30,3,292),1,Color3.fromRGB(72,174,255)),
		eggShrine(world,Vector3.new(0,3,302),2,Color3.fromRGB(182,86,255)),
		eggShrine(world,Vector3.new(30,3,292),3,Color3.fromRGB(255,181,54)),
	}
	statue(world,Vector3.new(-82,1,294),"NINJA HERO",Color3.fromRGB(234,117,32),Color3.fromRGB(255,173,48),Color3.fromRGB(244,198,55))
	statue(world,Vector3.new(82,1,294),"NINJA RIVAL",Color3.fromRGB(50,70,111),Color3.fromRGB(113,108,255),Color3.fromRGB(35,38,48))

	-- Monument faces.
	for i=1,4 do
		local x=-54+(i-1)*36
		local head=ball(world,"StoneFace",24,Vector3.new(x,45,351),Color3.fromRGB(116,111,100),Enum.Material.Rock)
		head.Size=Vector3.new(22,28,10)
		part(world,"StoneNose",Vector3.new(4,4,7),CFrame.new(x,44,344),Color3.fromRGB(128,121,108),Enum.Material.Rock)
	end

	local villageTitle=part(world,"VillageTitle",Vector3.new(1,1,1),CFrame.new(0,38,42),Color3.new(1,1,1),Enum.Material.Neon,1)
	billboard(villageTitle,"SHINOBI WORLD",Color3.fromRGB(255,211,72),340,68,Vector3.new())

	local spawn=Instance.new("SpawnLocation")
	spawn.Name="MainSpawn"
	spawn.Anchored=true
	spawn.Neutral=true
	spawn.Size=Vector3.new(14,1,14)
	spawn.CFrame=CFrame.new(0,3,-205)
	spawn.Color=Color3.fromRGB(72,216,84)
	spawn.Material=Enum.Material.Neon
	spawn.Parent=world

	return {World=world,Bases=bases,Eggs=eggs,Spawn=spawn}
end

return WorldBuilder
