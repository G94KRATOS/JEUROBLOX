local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local DataStoreService = game:GetService("DataStoreService")
local HttpService = game:GetService("HttpService")

local Config = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("GameConfig"))

local remotes = ReplicatedStorage:FindFirstChild("AnimeEggRemotes") or Instance.new("Folder")
remotes.Name = "AnimeEggRemotes"
remotes.Parent = ReplicatedStorage

local notifyRemote = remotes:FindFirstChild("Notify") or Instance.new("RemoteEvent")
notifyRemote.Name = "Notify"
notifyRemote.Parent = remotes

local shopRemote = remotes:FindFirstChild("ShopAction") or Instance.new("RemoteEvent")
shopRemote.Name = "ShopAction"
shopRemote.Parent = remotes

local requestState = remotes:FindFirstChild("RequestState") or Instance.new("RemoteFunction")
requestState.Name = "RequestState"
requestState.Parent = remotes

local store = DataStoreService:GetDataStore("AnimeEggHeist_V1")
local playerData = {}
local bases = {}
local world

local function notify(player, message, kind)
	if player and player.Parent == Players then
		notifyRemote:FireClient(player, message, kind or "Info")
	end
end

local function makePart(parent, name, size, cframe, color, material, transparency)
	local p = Instance.new("Part")
	p.Name = name
	p.Anchored = true
	p.Size = size
	p.CFrame = cframe
	p.Color = color
	p.Material = material or Enum.Material.SmoothPlastic
	p.Transparency = transparency or 0
	p.TopSurface = Enum.SurfaceType.Smooth
	p.BottomSurface = Enum.SurfaceType.Smooth
	p.Parent = parent
	return p
end

local function makeCylinder(parent, name, size, cframe, color, material)
	local p = makePart(parent, name, size, cframe, color, material)
	p.Shape = Enum.PartType.Cylinder
	return p
end

local function makeBillboard(parent, text, color, size, studsOffset)
	local gui = Instance.new("BillboardGui")
	gui.Name = "Billboard"
	gui.Size = size or UDim2.fromOffset(220, 60)
	gui.StudsOffset = studsOffset or Vector3.new(0, 4, 0)
	gui.AlwaysOnTop = true
	gui.MaxDistance = 130
	gui.Parent = parent

	local label = Instance.new("TextLabel")
	label.Size = UDim2.fromScale(1, 1)
	label.BackgroundTransparency = 1
	label.Text = text
	label.TextColor3 = color or Color3.new(1, 1, 1)
	label.TextStrokeTransparency = 0.55
	label.TextScaled = true
	label.Font = Enum.Font.GothamBlack
	label.Parent = gui
	return label
end

local function makePrompt(parent, action, object)
	local prompt = Instance.new("ProximityPrompt")
	prompt.ActionText = action
	prompt.ObjectText = object
	prompt.HoldDuration = 0.35
	prompt.MaxActivationDistance = 12
	prompt.RequiresLineOfSight = false
	prompt.Parent = parent
	return prompt
end

local function makeTree(parent, pos, blossomColor)
	makePart(parent, "Trunk", Vector3.new(2.4, 13, 2.4), CFrame.new(pos + Vector3.new(0, 6.5, 0)), Color3.fromRGB(92, 61, 43), Enum.Material.Wood)
	for _, off in ipairs({
		Vector3.new(0, 14, 0),
		Vector3.new(3.5, 12, 0),
		Vector3.new(-3.5, 12, 1),
		Vector3.new(0, 12, 3.5),
	}) do
		local crown = makePart(parent, "Blossom", Vector3.new(8, 8, 8), CFrame.new(pos + off), blossomColor, Enum.Material.SmoothPlastic)
		crown.Shape = Enum.PartType.Ball
	end
end

local function makeCactus(parent, pos)
	local green = Color3.fromRGB(70, 132, 77)
	makePart(parent, "Cactus", Vector3.new(3, 12, 3), CFrame.new(pos + Vector3.new(0, 6, 0)), green, Enum.Material.SmoothPlastic)
	makePart(parent, "CactusArm", Vector3.new(6, 2.5, 2.5), CFrame.new(pos + Vector3.new(2.2, 7, 0)), green, Enum.Material.SmoothPlastic)
	makePart(parent, "CactusTip", Vector3.new(2.5, 5, 2.5), CFrame.new(pos + Vector3.new(4.5, 9, 0)), green, Enum.Material.SmoothPlastic)
end

local function makeCrystal(parent, pos, color, scale)
	scale = scale or 1
	local c = makePart(parent, "Crystal", Vector3.new(2.4 * scale, 10 * scale, 2.4 * scale), CFrame.new(pos + Vector3.new(0, 5 * scale, 0)) * CFrame.Angles(0, 0, math.rad(18)), color, Enum.Material.Neon)
	c.CanCollide = false
end

local function makeRock(parent, pos, color, scale)
	local r = makePart(parent, "Rock", Vector3.new(7 * scale, 5 * scale, 6 * scale), CFrame.new(pos + Vector3.new(0, 2.5 * scale, 0)) * CFrame.Angles(math.rad(8), math.rad(20), math.rad(7)), color, Enum.Material.Slate)
	r.Shape = Enum.PartType.Block
end

local function createGuardian(parent, pos, accent)
	local model = Instance.new("Model")
	model.Name = "AnimeGuardian"
	model.Parent = parent
	local body = makePart(model, "Body", Vector3.new(6, 8, 4), CFrame.new(pos + Vector3.new(0, 5, 0)), Color3.fromRGB(38, 40, 54), Enum.Material.SmoothPlastic)
	local head = makePart(model, "Head", Vector3.new(5, 5, 5), CFrame.new(pos + Vector3.new(0, 11, 0)), Color3.fromRGB(245, 205, 169), Enum.Material.SmoothPlastic)
	head.Shape = Enum.PartType.Ball
	local hair = makePart(model, "Hair", Vector3.new(5.7, 2.2, 5.7), CFrame.new(pos + Vector3.new(0, 13.1, 0)), accent, Enum.Material.Neon)
	hair.Shape = Enum.PartType.Ball
	makePart(model, "Aura", Vector3.new(8, 0.4, 8), CFrame.new(pos + Vector3.new(0, 0.25, 0)), accent, Enum.Material.Neon, 0.25)
	makeBillboard(body, "GUARDIAN", accent, UDim2.fromOffset(140, 34), Vector3.new(0, 8, 0))
end

local function rollRarity(zone)
	local total = 0
	for _, entry in ipairs(zone.Rarities) do
		total += entry.Weight
	end
	local roll = math.random() * total
	local running = 0
	for _, entry in ipairs(zone.Rarities) do
		running += entry.Weight
		if roll <= running then
			return entry.Rarity
		end
	end
	return zone.Rarities[#zone.Rarities].Rarity
end

local function randomPetName(rarity)
	local names = Config.PetNames[rarity]
	return names[math.random(1, #names)]
end

local function getPlayerFromUserId(userId)
	for _, p in ipairs(Players:GetPlayers()) do
		if p.UserId == userId then
			return p
		end
	end
	return nil
end

local function updateWalkSpeed(player)
	local data = playerData[player]
	if not data then return end
	local character = player.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	local speedValue = player:FindFirstChild("leaderstats") and player.leaderstats:FindFirstChild("Speed")
	if humanoid and speedValue then
		humanoid.WalkSpeed = math.clamp(16 + math.sqrt(speedValue.Value) * 0.34, 16, 58)
	end
end

local function currentIncome(player)
	local data = playerData[player]
	if not data then return 0 end
	local total = 0
	for _, pet in ipairs(data.Pets) do
		local rarity = Config.Rarities[pet.Rarity]
		if rarity then
			total += rarity.Income
		end
	end
	return math.floor(total * Config.GetIncomeMultiplier(data.BaseLevel))
end

local function petSlotCFrame(base, index)
	local col = (index - 1) % 4
	local row = math.floor((index - 1) / 4)
	local x = -12 + col * 8
	local z = 4 + row * 8
	return CFrame.new(base.Position + Vector3.new(x, 3.6, z))
end

local function clearCarryVisual(player)
	local character = player.Character
	if character then
		local old = character:FindFirstChild("CarriedAnimeEgg")
		if old then old:Destroy() end
	end
end

local function setCarry(player, eggData)
	local data = playerData[player]
	if not data or data.Carry then return false end
	data.Carry = eggData
	player:SetAttribute("CarryingEgg", eggData.Name)
	player:SetAttribute("CarryingRarity", eggData.Rarity)

	local character = player.Character
	local root = character and character:FindFirstChild("HumanoidRootPart")
	if root then
		local egg = Instance.new("Part")
		egg.Name = "CarriedAnimeEgg"
		egg.Shape = Enum.PartType.Ball
		egg.Size = Vector3.new(4.2, 5.4, 4.2)
		egg.Color = Config.Rarities[eggData.Rarity].Color
		egg.Material = Enum.Material.SmoothPlastic
		egg.CanCollide = false
		egg.Massless = true
		egg.CFrame = root.CFrame * CFrame.new(0, 2.5, -3)
		egg.Parent = character

		local weld = Instance.new("WeldConstraint")
		weld.Part0 = root
		weld.Part1 = egg
		weld.Parent = egg

		local light = Instance.new("PointLight")
		light.Color = egg.Color
		light.Range = 10
		light.Brightness = 1.5
		light.Parent = egg
	end
	return true
end

local function removeCarry(player)
	local data = playerData[player]
	if data then data.Carry = nil end
	player:SetAttribute("CarryingEgg", "")
	player:SetAttribute("CarryingRarity", "")
	clearCarryVisual(player)
end

local createPetVisual

local function removePetById(owner, petId)
	local data = playerData[owner]
	if not data then return nil end
	for i, pet in ipairs(data.Pets) do
		if pet.Id == petId then
			table.remove(data.Pets, i)
			local base = data.BaseIndex and bases[data.BaseIndex]
			if base and base.PetFolder then
				local model = base.PetFolder:FindFirstChild(petId)
				if model then model:Destroy() end
			end
			for index, remaining in ipairs(data.Pets) do
				if base then
					local model = base.PetFolder:FindFirstChild(remaining.Id)
					if model and model.PrimaryPart then
						model:PivotTo(petSlotCFrame(base, index))
					end
				end
			end
			player:SetAttribute("PetCount", #data.Pets)
			player:SetAttribute("IncomePerSecond", currentIncome(owner))
			return pet
		end
	end
	return nil
end

createPetVisual = function(owner, pet, index)
	local data = playerData[owner]
	if not data or not data.BaseIndex then return end
	local base = bases[data.BaseIndex]
	if not base then return end

	local model = Instance.new("Model")
	model.Name = pet.Id
	model:SetAttribute("PetId", pet.Id)
	model:SetAttribute("OwnerUserId", owner.UserId)
	model:SetAttribute("Rarity", pet.Rarity)
	model.Parent = base.PetFolder

	local rarityColor = Config.Rarities[pet.Rarity].Color
	local cf = petSlotCFrame(base, index)

	local root = makePart(model, "Root", Vector3.new(3.5, 4.2, 2.4), cf, Color3.fromRGB(42, 43, 57), Enum.Material.SmoothPlastic)
	local head = makePart(model, "Head", Vector3.new(3.4, 3.4, 3.4), cf * CFrame.new(0, 3.6, 0), Color3.fromRGB(244, 204, 170), Enum.Material.SmoothPlastic)
	head.Shape = Enum.PartType.Ball
	local hair = makePart(model, "Hair", Vector3.new(3.8, 1.7, 3.8), cf * CFrame.new(0, 5.05, 0), rarityColor, Enum.Material.Neon)
	hair.Shape = Enum.PartType.Ball
	makePart(model, "Aura", Vector3.new(5, 0.25, 5), cf * CFrame.new(0, -2, 0), rarityColor, Enum.Material.Neon, 0.15)
	model.PrimaryPart = root

	local label = makeBillboard(root, pet.Name .. "\n" .. pet.Rarity .. "  $" .. Config.Rarities[pet.Rarity].Income .. "/s", rarityColor, UDim2.fromOffset(170, 52), Vector3.new(0, 5.8, 0))
	label.TextScaled = false
	label.TextSize = 14

	local stealPrompt = makePrompt(root, "VOLER", pet.Name)
	stealPrompt.Triggered:Connect(function(thief)
		if thief == owner then
			notify(thief, "C'est ton propre héros.", "Info")
			return
		end
		local thiefData = playerData[thief]
		if not thiefData or thiefData.Carry then
			notify(thief, "Tu portes déjà quelque chose.", "Error")
			return
		end
		if #thiefData.Pets >= Config.MaxPets then
			notify(thief, "Ta base est pleine.", "Error")
			return
		end

		local stolen = removePetById(owner, pet.Id)
		if stolen then
			stolen.StolenFrom = owner.Name
			setCarry(thief, stolen)
			notify(thief, "Tu as volé " .. stolen.Name .. " ! Ramène-le à ta base.", "Success")
			notify(owner, thief.Name .. " a volé " .. stolen.Name .. " !", "Danger")
		end
	end)
end

local function addPet(player, pet)
	local data = playerData[player]
	if not data then return false end
	if #data.Pets >= Config.MaxPets then
		notify(player, "Ta base est pleine. Améliore ou vole moins !", "Error")
		return false
	end
	if not pet.Id then
		pet.Id = HttpService:GenerateGUID(false)
	end
	table.insert(data.Pets, pet)
	createPetVisual(player, pet, #data.Pets)
	player:SetAttribute("PetCount", #data.Pets)
	player:SetAttribute("IncomePerSecond", currentIncome(player))
	return true
end

local function createBase(index, position)
	local model = Instance.new("Model")
	model.Name = "PlayerBase_" .. index
	model.Parent = world

	local accentColors = {
		Color3.fromRGB(255, 93, 117),
		Color3.fromRGB(255, 173, 76),
		Color3.fromRGB(253, 226, 87),
		Color3.fromRGB(83, 226, 151),
		Color3.fromRGB(73, 174, 255),
		Color3.fromRGB(173, 103, 255),
		Color3.fromRGB(255, 100, 214),
	}
	local accent = accentColors[index] or Color3.new(1, 1, 1)

	makePart(model, "Floor", Vector3.new(38, 1, 34), CFrame.new(position), Color3.fromRGB(28, 30, 41), Enum.Material.SmoothPlastic)
	makePart(model, "BackWall", Vector3.new(38, 10, 1), CFrame.new(position + Vector3.new(0, 5, 16)), Color3.fromRGB(20, 21, 31), Enum.Material.SmoothPlastic)
	makePart(model, "AccentStrip", Vector3.new(36, 0.4, 1.2), CFrame.new(position + Vector3.new(0, 9, 15.4)), accent, Enum.Material.Neon)

	for _, x in ipairs({-18.3, 18.3}) do
		makePart(model, "SideGlow", Vector3.new(0.4, 0.3, 32), CFrame.new(position + Vector3.new(x, 0.7, 0)), accent, Enum.Material.Neon)
	end

	local signAnchor = makePart(model, "SignAnchor", Vector3.new(1, 1, 1), CFrame.new(position + Vector3.new(0, 8, 15)), accent, Enum.Material.Neon, 1)
	local signLabel = makeBillboard(signAnchor, "BASE LIBRE", accent, UDim2.fromOffset(230, 52), Vector3.new(0, 2.4, 0))

	local drop = makePart(model, "DropZone", Vector3.new(12, 0.7, 8), CFrame.new(position + Vector3.new(0, 0.9, -12)), accent, Enum.Material.Neon, 0.12)
	makeBillboard(drop, "DEPOSE ICI", Color3.new(1, 1, 1), UDim2.fromOffset(150, 32), Vector3.new(0, 2, 0))

	local train = makePart(model, "TrainingPad", Vector3.new(11, 0.7, 7), CFrame.new(position + Vector3.new(-12, 0.9, -2)), Color3.fromRGB(57, 210, 255), Enum.Material.Neon, 0.08)
	for i = -4, 4, 2 do
		makePart(model, "TreadLine", Vector3.new(0.35, 0.1, 6), CFrame.new(position + Vector3.new(-12 + i * 0.7, 1.3, -2)), Color3.fromRGB(224, 250, 255), Enum.Material.Neon)
	end
	makeBillboard(train, "TAPIS SPEED", Color3.fromRGB(120, 228, 255), UDim2.fromOffset(150, 34), Vector3.new(0, 2.2, 0))

	local baseTerminal = makePart(model, "BaseUpgrade", Vector3.new(4, 5, 4), CFrame.new(position + Vector3.new(11, 2.8, -5)), accent, Enum.Material.Metal)
	makeBillboard(baseTerminal, "UPGRADE BASE", accent, UDim2.fromOffset(145, 32), Vector3.new(0, 4, 0))
	local basePrompt = makePrompt(baseTerminal, "AMELIORER", "Base")

	local trainTerminal = makePart(model, "TrainUpgrade", Vector3.new(4, 5, 4), CFrame.new(position + Vector3.new(11, 2.8, 3)), Color3.fromRGB(72, 202, 255), Enum.Material.Metal)
	makeBillboard(trainTerminal, "UPGRADE SPEED", Color3.fromRGB(113, 227, 255), UDim2.fromOffset(155, 32), Vector3.new(0, 4, 0))
	local trainPrompt = makePrompt(trainTerminal, "AMELIORER", "Tapis")

	local petFolder = Instance.new("Folder")
	petFolder.Name = "Pets"
	petFolder.Parent = model

	local base = {
		Index = index,
		Model = model,
		Position = position,
		Accent = accent,
		Owner = nil,
		SignLabel = signLabel,
		DropZone = drop,
		TrainingPad = train,
		BasePrompt = basePrompt,
		TrainPrompt = trainPrompt,
		PetFolder = petFolder,
	}
	bases[index] = base

	drop.Touched:Connect(function(hit)
		local character = hit.Parent
		local player = character and Players:GetPlayerFromCharacter(character)
		if not player or base.Owner ~= player then return end
		local data = playerData[player]
		if not data or not data.Carry then return end

		local pet = data.Carry
		if #data.Pets >= Config.MaxPets then
			notify(player, "Ta base est pleine.", "Error")
			return
		end
		removeCarry(player)
		addPet(player, pet)
		notify(player, pet.Name .. " est maintenant dans ta base !", "Success")
	end)

	return base
end

local function claimBase(player)
	for _, base in ipairs(bases) do
		if not base.Owner then
			base.Owner = player
			playerData[player].BaseIndex = base.Index
			base.SignLabel.Text = player.DisplayName:upper() .. "\nBASE " .. base.Index
			base.SignLabel.TextColor3 = base.Accent
			player:SetAttribute("BaseIndex", base.Index)
			return base
		end
	end
	return nil
end

local function createNest(zone, zoneIndex, position, nestIndex)
	local model = Instance.new("Model")
	model.Name = "Nest_" .. zoneIndex .. "_" .. nestIndex
	model.Parent = world

	local ring = makeCylinder(model, "NestRing", Vector3.new(2, 11, 11), CFrame.new(position) * CFrame.Angles(0, 0, math.rad(90)), Color3.fromRGB(101, 70, 44), Enum.Material.Wood)
	ring.CanCollide = false

	local egg = makePart(model, "Egg", Vector3.new(5.5, 7, 5.5), CFrame.new(position + Vector3.new(0, 4.5, 0)), Color3.new(1,1,1), Enum.Material.SmoothPlastic)
	egg.Shape = Enum.PartType.Ball
	egg.CanCollide = false
	local light = Instance.new("PointLight")
	light.Range = 14
	light.Brightness = 2
	light.Parent = egg

	local prompt = makePrompt(egg, "VOLER L'OEUF", zone.Name)
	local currentEgg

	local function refreshEgg()
		local rarity = rollRarity(zone)
		currentEgg = {
			Id = HttpService:GenerateGUID(false),
			Name = randomPetName(rarity),
			Rarity = rarity,
			Zone = zone.Name,
		}
		local color = Config.Rarities[rarity].Color
		egg.Color = color
		light.Color = color
		prompt.ObjectText = rarity .. " Egg"
		egg.Transparency = 0
		prompt.Enabled = true
	end
	refreshEgg()

	prompt.Triggered:Connect(function(player)
		local data = playerData[player]
		if not data then return end
		if data.Carry then
			notify(player, "Tu portes déjà un oeuf.", "Error")
			return
		end
		local speed = player:FindFirstChild("leaderstats") and player.leaderstats:FindFirstChild("Speed")
		if not speed or speed.Value < zone.RequiredSpeed then
			notify(player, "Il te faut " .. zone.RequiredSpeed .. " Speed pour cette zone.", "Error")
			return
		end
		if not prompt.Enabled then return end

		local captured = currentEgg
		prompt.Enabled = false
		egg.Transparency = 1
		setCarry(player, captured)
		notify(player, captured.Rarity .. " ! Ramène " .. captured.Name .. " à ta base.", "Success")

		task.delay(7 + zoneIndex * 2, function()
			if egg.Parent then refreshEgg() end
		end)
	end)
end

local function createZone(zone, index)
	local z = zone.Z
	local zoneModel = Instance.new("Model")
	zoneModel.Name = zone.Name
	zoneModel.Parent = world

	makePart(zoneModel, "ZoneFloor", Vector3.new(190, 2, 170), CFrame.new(0, 0, z), zone.FloorColor, Enum.Material.SmoothPlastic)
	makePart(zoneModel, "CenterPath", Vector3.new(34, 0.4, 170), CFrame.new(0, 1.2, z), Color3.fromRGB(46, 48, 58), Enum.Material.Slate)

	for _, x in ipairs({-94, 94}) do
		makePart(zoneModel, "Border", Vector3.new(2, 3, 170), CFrame.new(x, 2, z), zone.Accent, Enum.Material.Neon, 0.15)
	end

	local gateZ = z - 87
	makePart(zoneModel, "GateLeft", Vector3.new(7, 20, 7), CFrame.new(-22, 10, gateZ), Color3.fromRGB(28, 30, 40), Enum.Material.Slate)
	makePart(zoneModel, "GateRight", Vector3.new(7, 20, 7), CFrame.new(22, 10, gateZ), Color3.fromRGB(28, 30, 40), Enum.Material.Slate)
	makePart(zoneModel, "GateTop", Vector3.new(51, 5, 7), CFrame.new(0, 20, gateZ), zone.Accent, Enum.Material.Neon)

	local gateAnchor = makePart(zoneModel, "GateSign", Vector3.new(1,1,1), CFrame.new(0, 18, gateZ), zone.Accent, Enum.Material.Neon, 1)
	makeBillboard(gateAnchor, zone.Name:upper() .. "\n" .. zone.RequiredSpeed .. " SPEED", Color3.new(1,1,1), UDim2.fromOffset(290, 75), Vector3.new(0, 2, 0))

	local barrier = makePart(zoneModel, "SpeedGate", Vector3.new(44, 18, 2), CFrame.new(0, 9, gateZ + 1), zone.Accent, Enum.Material.ForceField, 0.82)
	barrier.CanCollide = false
	barrier.Touched:Connect(function(hit)
		local player = hit.Parent and Players:GetPlayerFromCharacter(hit.Parent)
		if not player then return end
		local speed = player:FindFirstChild("leaderstats") and player.leaderstats:FindFirstChild("Speed")
		if speed and speed.Value < zone.RequiredSpeed then
			local root = hit.Parent:FindFirstChild("HumanoidRootPart")
			if root then
				root.CFrame = CFrame.new(0, 5, gateZ - 10)
			end
			notify(player, "Zone verrouillée : " .. zone.RequiredSpeed .. " Speed requis.", "Error")
		end
	end)

	local random = Random.new(9000 + index)
	for i = 1, 16 do
		local x = random:NextNumber(-80, 80)
		if math.abs(x) < 25 then x += (x >= 0 and 32 or -32) end
		local zz = z + random:NextNumber(-72, 72)
		local pos = Vector3.new(x, 1.2, zz)
		if index == 1 then
			makeTree(zoneModel, pos, Color3.fromRGB(255, 137 + random:NextInteger(0, 45), 204))
		elseif index == 2 then
			if i % 2 == 0 then makeCactus(zoneModel, pos) else makeRock(zoneModel, pos, Color3.fromRGB(130, 91, 58), random:NextNumber(0.7, 1.3)) end
		elseif index == 3 then
			makeCrystal(zoneModel, pos, Color3.fromRGB(102, 224, 255), random:NextNumber(0.7, 1.3))
		elseif index == 4 then
			makeRock(zoneModel, pos, Color3.fromRGB(70, 49, 49), random:NextNumber(0.8, 1.5))
			if i % 3 == 0 then makeCrystal(zoneModel, pos + Vector3.new(5,0,0), Color3.fromRGB(255, 79, 40), 0.8) end
		else
			makeCrystal(zoneModel, pos, Color3.fromRGB(169, 111, 255), random:NextNumber(0.8, 1.5))
		end
	end

	local nestPositions = {
		Vector3.new(-52, 2, z - 15),
		Vector3.new(0, 2, z + 25),
		Vector3.new(52, 2, z - 15),
	}
	for nestIndex, pos in ipairs(nestPositions) do
		createNest(zone, index, pos, nestIndex)
		createGuardian(zoneModel, pos + Vector3.new(0, 0, 14), zone.Accent)
	end
end

local function buildWorld()
	local old = workspace:FindFirstChild("AnimeEggWorld")
	if old then old:Destroy() end

	world = Instance.new("Model")
	world.Name = "AnimeEggWorld"
	world.Parent = workspace

	workspace.FallenPartsDestroyHeight = -80

	Lighting.Brightness = 2.3
	Lighting.ClockTime = 14.5
	Lighting.Ambient = Color3.fromRGB(95, 95, 120)
	Lighting.OutdoorAmbient = Color3.fromRGB(120, 125, 150)
	Lighting.EnvironmentDiffuseScale = 0.55
	Lighting.EnvironmentSpecularScale = 0.75

	local bloom = Lighting:FindFirstChild("AnimeBloom") or Instance.new("BloomEffect")
	bloom.Name = "AnimeBloom"
	bloom.Intensity = 0.55
	bloom.Size = 30
	bloom.Threshold = 1.1
	bloom.Parent = Lighting

	local color = Lighting:FindFirstChild("AnimeColor") or Instance.new("ColorCorrectionEffect")
	color.Name = "AnimeColor"
	color.Saturation = 0.12
	color.Contrast = 0.08
	color.Brightness = 0.02
	color.Parent = Lighting

	makePart(world, "Ocean", Vector3.new(520, 3, 1200), CFrame.new(0, -8, 450), Color3.fromRGB(43, 111, 155), Enum.Material.Glass, 0.2)
	makePart(world, "HubFloor", Vector3.new(230, 2, 190), CFrame.new(0, 0, -55), Color3.fromRGB(36, 39, 52), Enum.Material.Slate)
	makePart(world, "MainRoad", Vector3.new(32, 1.5, 1020), CFrame.new(0, 0.8, 430), Color3.fromRGB(39, 41, 51), Enum.Material.Asphalt)

	for z = -120, 990, 18 do
		makePart(world, "RoadLight", Vector3.new(27, 0.15, 0.6), CFrame.new(0, 1.65, z), Color3.fromRGB(139, 93, 255), Enum.Material.Neon, 0.2)
	end

	local titleAnchor = makePart(world, "TitleAnchor", Vector3.new(1,1,1), CFrame.new(0, 15, -125), Color3.new(1,1,1), Enum.Material.Neon, 1)
	makeBillboard(titleAnchor, "ANIME EGG HEIST\nSTEAL • HATCH • EARN • UPGRADE", Color3.fromRGB(226, 195, 255), UDim2.fromOffset(420, 100), Vector3.new(0,0,0))

	local basePositions = {
		Vector3.new(-86, 1.1, -100),
		Vector3.new(-43, 1.1, -100),
		Vector3.new(0, 1.1, -100),
		Vector3.new(43, 1.1, -100),
		Vector3.new(86, 1.1, -100),
		Vector3.new(-86, 1.1, -52),
		Vector3.new(86, 1.1, -52),
	}
	for index, pos in ipairs(basePositions) do
		createBase(index, pos)
	end

	local spawn = Instance.new("SpawnLocation")
	spawn.Name = "MainSpawn"
	spawn.Size = Vector3.new(14, 1, 14)
	spawn.CFrame = CFrame.new(0, 3, -40)
	spawn.Anchored = true
	spawn.Neutral = true
	spawn.Color = Color3.fromRGB(143, 93, 255)
	spawn.Material = Enum.Material.Neon
	spawn.Parent = world

	for _, zone in ipairs(Config.Zones) do
		createZone(zone, _)
	end
end

local function buyUpgrade(player, upgradeType)
	local data = playerData[player]
	if not data then return end
	local coins = player:FindFirstChild("leaderstats") and player.leaderstats:FindFirstChild("Coins")
	if not coins then return end

	if upgradeType == "Base" then
		local cost = Config.GetBaseUpgradeCost(data.BaseLevel)
		if coins.Value < cost then
			notify(player, "Il te faut $" .. cost .. ".", "Error")
			return
		end
		coins.Value -= cost
		data.BaseLevel += 1
		player:SetAttribute("BaseLevel", data.BaseLevel)
		player:SetAttribute("IncomePerSecond", currentIncome(player))
		notify(player, "Base niveau " .. data.BaseLevel .. " ! Revenus améliorés.", "Success")
	elseif upgradeType == "Training" then
		local cost = Config.GetTrainingUpgradeCost(data.TrainingLevel)
		if coins.Value < cost then
			notify(player, "Il te faut $" .. cost .. ".", "Error")
			return
		end
		coins.Value -= cost
		data.TrainingLevel += 1
		player:SetAttribute("TrainingLevel", data.TrainingLevel)
		notify(player, "Tapis niveau " .. data.TrainingLevel .. " !", "Success")
	end
end

local function setupBasePrompts()
	for _, base in ipairs(bases) do
		base.BasePrompt.Triggered:Connect(function(player)
			if base.Owner == player then buyUpgrade(player, "Base") end
		end)
		base.TrainPrompt.Triggered:Connect(function(player)
			if base.Owner == player then buyUpgrade(player, "Training") end
		end)
	end
end

local function serialize(player)
	local data = playerData[player]
	if not data then return nil end
	local stats = player:FindFirstChild("leaderstats")
	return {
		Coins = stats and stats.Coins.Value or Config.StartingCoins,
		Speed = stats and stats.Speed.Value or Config.StartingSpeed,
		BaseLevel = data.BaseLevel,
		TrainingLevel = data.TrainingLevel,
		Pets = data.Pets,
	}
end

local function savePlayer(player)
	local payload = serialize(player)
	if not payload then return end
	pcall(function()
		store:SetAsync("u_" .. player.UserId, payload)
	end)
end

local function loadPlayer(player)
	local result
	pcall(function()
		result = store:GetAsync("u_" .. player.UserId)
	end)
	return result
end

local function setupPlayer(player)
	local saved = loadPlayer(player) or {}

	local stats = Instance.new("Folder")
	stats.Name = "leaderstats"
	stats.Parent = player

	local coins = Instance.new("IntValue")
	coins.Name = "Coins"
	coins.Value = tonumber(saved.Coins) or Config.StartingCoins
	coins.Parent = stats

	local speed = Instance.new("IntValue")
	speed.Name = "Speed"
	speed.Value = tonumber(saved.Speed) or Config.StartingSpeed
	speed.Parent = stats

	playerData[player] = {
		BaseIndex = nil,
		BaseLevel = tonumber(saved.BaseLevel) or 1,
		TrainingLevel = tonumber(saved.TrainingLevel) or 1,
		Pets = type(saved.Pets) == "table" and saved.Pets or {},
		Carry = nil,
	}

	player:SetAttribute("BaseLevel", playerData[player].BaseLevel)
	player:SetAttribute("TrainingLevel", playerData[player].TrainingLevel)
	player:SetAttribute("PetCount", #playerData[player].Pets)
	player:SetAttribute("IncomePerSecond", 0)
	player:SetAttribute("CarryingEgg", "")
	player:SetAttribute("CarryingRarity", "")

	local base = claimBase(player)
	if not base then
		notify(player, "Serveur plein : aucune base libre.", "Error")
		return
	end

	for index, pet in ipairs(playerData[player].Pets) do
		if index > Config.MaxPets then break end
		if not pet.Id then pet.Id = HttpService:GenerateGUID(false) end
		createPetVisual(player, pet, index)
	end
	player:SetAttribute("IncomePerSecond", currentIncome(player))

	player.CharacterAdded:Connect(function(character)
		local humanoid = character:WaitForChild("Humanoid")
		task.wait(0.25)
		updateWalkSpeed(player)
		if playerData[player] and playerData[player].Carry then
			removeCarry(player)
			notify(player, "Tu as perdu ce que tu transportais.", "Error")
		end
		humanoid.Died:Connect(function()
			if playerData[player] and playerData[player].Carry then
				removeCarry(player)
			end
		end)
	end)

	speed.Changed:Connect(function()
		updateWalkSpeed(player)
	end)

	task.delay(1.5, function()
		notify(player, "Ta base est prête. Va voler un oeuf dans Blossom Village !", "Success")
	end)
end

shopRemote.OnServerEvent:Connect(function(player, action)
	if action == "Base" or action == "Training" then
		buyUpgrade(player, action)
	end
end)

requestState.OnServerInvoke = function(player)
	local data = playerData[player]
	if not data then return {} end
	return {
		BaseUpgradeCost = Config.GetBaseUpgradeCost(data.BaseLevel),
		TrainingUpgradeCost = Config.GetTrainingUpgradeCost(data.TrainingLevel),
		MaxPets = Config.MaxPets,
	}
end

buildWorld()
setupBasePrompts()

Players.PlayerAdded:Connect(setupPlayer)
for _, player in ipairs(Players:GetPlayers()) do
	task.spawn(setupPlayer, player)
end

Players.PlayerRemoving:Connect(function(player)
	savePlayer(player)
	local data = playerData[player]
	if data and data.BaseIndex and bases[data.BaseIndex] then
		local base = bases[data.BaseIndex]
		base.Owner = nil
		base.SignLabel.Text = "BASE LIBRE"
		for _, child in ipairs(base.PetFolder:GetChildren()) do
			child:Destroy()
		end
	end
	playerData[player] = nil
end)

task.spawn(function()
	while true do
		task.wait(1)
		for player, data in pairs(playerData) do
			if player.Parent == Players then
				local stats = player:FindFirstChild("leaderstats")
				if stats then
					local income = currentIncome(player)
					player:SetAttribute("IncomePerSecond", income)
					stats.Coins.Value += income
				end
			end
		end
	end
end)

task.spawn(function()
	while true do
		task.wait(0.6)
		for player, data in pairs(playerData) do
			local base = data.BaseIndex and bases[data.BaseIndex]
			local character = player.Character
			local root = character and character:FindFirstChild("HumanoidRootPart")
			local stats = player:FindFirstChild("leaderstats")
			if base and root and stats then
				local localPos = base.TrainingPad.CFrame:PointToObjectSpace(root.Position)
				if math.abs(localPos.X) <= 6 and math.abs(localPos.Z) <= 4.5 and math.abs(localPos.Y) <= 6 then
					stats.Speed.Value += Config.GetTrainingGain(data.TrainingLevel)
				end
			end
		end
	end
end)

game:BindToClose(function()
	for _, player in ipairs(Players:GetPlayers()) do
		savePlayer(player)
	end
	task.wait(1)
end)

print(Config.GameName .. " loaded")
