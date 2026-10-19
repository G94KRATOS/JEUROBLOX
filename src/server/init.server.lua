local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DataStoreService = game:GetService("DataStoreService")
local HttpService = game:GetService("HttpService")

local Config = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("GameConfig"))
local WorldBuilder = require(script:WaitForChild("WorldBuilder"))

local remotes = ReplicatedStorage:FindFirstChild("AnimeEggRemotes") or Instance.new("Folder")
remotes.Name = "AnimeEggRemotes"
remotes.Parent = ReplicatedStorage

local notifyRemote = remotes:FindFirstChild("Notify") or Instance.new("RemoteEvent")
notifyRemote.Name = "Notify"
notifyRemote.Parent = remotes

local shopRemote = remotes:FindFirstChild("ShopAction") or Instance.new("RemoteEvent")
shopRemote.Name = "ShopAction"
shopRemote.Parent = remotes

local hatchRemote = remotes:FindFirstChild("HatchEffect") or Instance.new("RemoteEvent")
hatchRemote.Name = "HatchEffect"
hatchRemote.Parent = remotes

local requestState = remotes:FindFirstChild("RequestState") or Instance.new("RemoteFunction")
requestState.Name = "RequestState"
requestState.Parent = remotes

local store = DataStoreService:GetDataStore("AnimeEggHeist_Naruto_V2")
local okBuild, builtOrError = pcall(WorldBuilder.Build, Config)
if not okBuild then
	warn("[AnimeEggHeist] WorldBuilder crashed:", builtOrError)

	local debugPlatform = Instance.new("Part")
	debugPlatform.Name = "WORLD_BUILD_ERROR"
	debugPlatform.Anchored = true
	debugPlatform.Size = Vector3.new(120, 4, 120)
	debugPlatform.Position = Vector3.new(0, 0, 0)
	debugPlatform.Color = Color3.fromRGB(255, 70, 70)
	debugPlatform.Material = Enum.Material.Neon
	debugPlatform.Parent = workspace

	local board = Instance.new("BillboardGui")
	board.Size = UDim2.fromOffset(700, 180)
	board.StudsOffset = Vector3.new(0, 10, 0)
	board.AlwaysOnTop = true
	board.Parent = debugPlatform

	local message = Instance.new("TextLabel")
	message.Size = UDim2.fromScale(1, 1)
	message.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	message.BackgroundTransparency = 0.1
	message.TextColor3 = Color3.new(1, 1, 1)
	message.TextWrapped = true
	message.TextScaled = true
	message.Font = Enum.Font.GothamBold
	message.Text = "WORLD BUILDER ERROR\n" .. tostring(builtOrError)
	message.Parent = board

	error(builtOrError)
end

local built = builtOrError
local bases = built.Bases
local eggs = built.Eggs
local gates = built.Gates or {}

local playerData = {}
local random = Random.new()

local function notify(player, message, kind)
	if player and player.Parent == Players then
		notifyRemote:FireClient(player, tostring(message), kind or "Info")
	end
end

local function rarityData(rarity)
	return Config.Rarities[rarity] or Config.Rarities.Common
end

local function computeIncome(player)
	local data = playerData[player]
	if not data then return 0 end

	local total = 0
	for _, hero in ipairs(data.Heroes) do
		total += rarityData(hero.Rarity).Income
	end

	return math.floor(total * Config.GetIncomeMultiplier(data.BaseLevel))
end

local WORLD_STYLES = {
	Naruto = {Body = Color3.fromRGB(79, 96, 87), Accent = Color3.fromRGB(255, 111, 57), Hair = Color3.fromRGB(45, 45, 49)},
	OnePiece = {Body = Color3.fromRGB(72, 108, 142), Accent = Color3.fromRGB(61, 181, 255), Hair = Color3.fromRGB(65, 47, 36)},
	DragonBall = {Body = Color3.fromRGB(225, 118, 46), Accent = Color3.fromRGB(255, 190, 54), Hair = Color3.fromRGB(35, 38, 44)},
	DemonSlayer = {Body = Color3.fromRGB(69, 96, 77), Accent = Color3.fromRGB(255, 78, 95), Hair = Color3.fromRGB(38, 40, 44)},
	JJK = {Body = Color3.fromRGB(57, 59, 73), Accent = Color3.fromRGB(160, 86, 255), Hair = Color3.fromRGB(42, 43, 49)},
	Bleach = {Body = Color3.fromRGB(225, 228, 235), Accent = Color3.fromRGB(93, 213, 255), Hair = Color3.fromRGB(35, 36, 42)},
	AOT = {Body = Color3.fromRGB(94, 104, 89), Accent = Color3.fromRGB(221, 110, 67), Hair = Color3.fromRGB(61, 45, 39)},
}

local HERO_STYLES = {
	Iruka = {Body = Color3.fromRGB(88, 111, 88), Accent = Color3.fromRGB(119, 82, 56), Hair = Color3.fromRGB(67, 49, 38)},
	Kiba = {Body = Color3.fromRGB(98, 105, 112), Accent = Color3.fromRGB(199, 59, 59), Hair = Color3.fromRGB(74, 54, 43)},
	Shino = {Body = Color3.fromRGB(76, 86, 67), Accent = Color3.fromRGB(78, 86, 63), Hair = Color3.fromRGB(36, 38, 41)},
	["Rock Lee"] = {Body = Color3.fromRGB(55, 132, 70), Accent = Color3.fromRGB(236, 127, 55), Hair = Color3.fromRGB(31, 34, 35)},
	Neji = {Body = Color3.fromRGB(224, 219, 196), Accent = Color3.fromRGB(98, 108, 125), Hair = Color3.fromRGB(53, 50, 48)},
	Temari = {Body = Color3.fromRGB(92, 97, 126), Accent = Color3.fromRGB(233, 206, 92), Hair = Color3.fromRGB(224, 198, 106)},
	Kakashi = {Body = Color3.fromRGB(65, 89, 100), Accent = Color3.fromRGB(36, 45, 55), Hair = Color3.fromRGB(203, 208, 212)},
	Gaara = {Body = Color3.fromRGB(126, 74, 58), Accent = Color3.fromRGB(180, 54, 47), Hair = Color3.fromRGB(170, 61, 43)},
	Itachi = {Body = Color3.fromRGB(42, 43, 49), Accent = Color3.fromRGB(197, 48, 57), Hair = Color3.fromRGB(35, 35, 39)},
	["Naruto Sage"] = {Body = Color3.fromRGB(231, 112, 39), Accent = Color3.fromRGB(250, 184, 54), Hair = Color3.fromRGB(243, 202, 64)},
	Madara = {Body = Color3.fromRGB(111, 45, 47), Accent = Color3.fromRGB(204, 54, 65), Hair = Color3.fromRGB(37, 34, 36)},
	["Six Paths Naruto"] = {Body = Color3.fromRGB(245, 218, 118), Accent = Color3.fromRGB(255, 243, 176), Hair = Color3.fromRGB(244, 214, 75)},
}

local function makePart(parent, name, size, cf, color, material, transparency)
	local part = Instance.new("Part")
	part.Name = name
	part.Anchored = true
	part.Size = size
	part.CFrame = cf
	part.Color = color
	part.Material = material or Enum.Material.SmoothPlastic
	part.Transparency = transparency or 0
	part.TopSurface = Enum.SurfaceType.Smooth
	part.BottomSurface = Enum.SurfaceType.Smooth
	part.Parent = parent
	return part
end

local function billboard(parent, value, color, offset)
	local gui = Instance.new("BillboardGui")
	gui.Size = UDim2.fromOffset(180, 52)
	gui.StudsOffset = offset or Vector3.new(0, 5, 0)
	gui.AlwaysOnTop = true
	gui.MaxDistance = 120
	gui.Parent = parent

	local label = Instance.new("TextLabel")
	label.Size = UDim2.fromScale(1, 1)
	label.BackgroundTransparency = 1
	label.Text = value
	label.TextColor3 = color
	label.TextStrokeColor3 = Color3.fromRGB(25, 25, 25)
	label.TextStrokeTransparency = 0.2
	label.TextScaled = true
	label.Font = Enum.Font.GothamBlack
	label.Parent = gui
	return label
end

local function heroStandCFrame(base, index)
	return base.StandPositions[index] or CFrame.new(base.Position + Vector3.new(0, 3, 5))
end

local function setShieldVisual(base, enabled)
	for _, wall in ipairs(base.ShieldWalls) do
		wall.Transparency = enabled and 0.58 or 1
	end
	base.IsShielded = enabled
end

local function updatePlayerAttributes(player)
	local data = playerData[player]
	if not data then return end

	player:SetAttribute("BaseIndex", data.BaseIndex or 0)
	player:SetAttribute("BaseLevel", data.BaseLevel)
	player:SetAttribute("TrainingLevel", data.TrainingLevel)
	player:SetAttribute("HeroCount", #data.Heroes)
	player:SetAttribute("IncomePerSecond", computeIncome(player))
	player:SetAttribute("CarryingName", data.Carry and data.Carry.Name or "")
	player:SetAttribute("CarryingRarity", data.Carry and data.Carry.Rarity or "")
end

local function updateWalkSpeed(player)
	local stats = player:FindFirstChild("leaderstats")
	local speed = stats and stats:FindFirstChild("Speed")
	local character = player.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	if speed and humanoid then
		humanoid.WalkSpeed = math.clamp(16 + math.sqrt(speed.Value) * 0.42, 16, 54)
	end
end

local function clearCarryVisual(player)
	local character = player.Character
	if not character then return end
	local old = character:FindFirstChild("CarriedObject")
	if old then old:Destroy() end
end

local function createCarryVisual(player, carry)
	clearCarryVisual(player)

	local character = player.Character
	local root = character and character:FindFirstChild("HumanoidRootPart")
	if not root then return end

	local model = Instance.new("Model")
	model.Name = "CarriedObject"
	model.Parent = character

	local rarity = rarityData(carry.Rarity)
	local main = Instance.new("Part")
	main.Name = "Carry"
	main.Shape = carry.Source == "Egg" and Enum.PartType.Ball or Enum.PartType.Block
	main.Size = carry.Source == "Egg" and Vector3.new(4.6, 5.7, 4.6) or Vector3.new(4.2, 5.2, 3)
	main.Color = rarity.Color
	main.Material = Enum.Material.SmoothPlastic
	main.CanCollide = false
	main.Massless = true
	main.CFrame = root.CFrame * CFrame.new(0, 2.2, -3.1)
	main.Parent = model

	local weld = Instance.new("WeldConstraint")
	weld.Part0 = root
	weld.Part1 = main
	weld.Parent = main

	local light = Instance.new("PointLight")
	light.Color = rarity.Color
	light.Brightness = 1.7
	light.Range = 11
	light.Parent = main

	billboard(main, carry.Name .. "\n" .. carry.Rarity, rarity.Color, Vector3.new(0, 4.2, 0))
	model.PrimaryPart = main
end

local function setCarry(player, item)
	local data = playerData[player]
	if not data or data.Carry then return false end

	data.Carry = item
	updatePlayerAttributes(player)
	createCarryVisual(player, item)
	return true
end

local function clearCarry(player)
	local data = playerData[player]
	if data then data.Carry = nil end
	updatePlayerAttributes(player)
	clearCarryVisual(player)
end

local function createHeroVisual(owner, hero, index)
	local data = playerData[owner]
	if not data or not data.BaseIndex then return end

	local base = bases[data.BaseIndex]
	if not base then return end

	local style = HERO_STYLES[hero.Name] or WORLD_STYLES[hero.WorldKey] or {
		Body = Color3.fromRGB(75, 82, 99),
		Accent = rarityData(hero.Rarity).Color,
		Hair = Color3.fromRGB(42, 43, 47),
	}
	local rarity = rarityData(hero.Rarity)
	local cf = heroStandCFrame(base, index)

	local model = Instance.new("Model")
	model.Name = hero.Id
	model:SetAttribute("HeroId", hero.Id)
	model:SetAttribute("OwnerUserId", owner.UserId)
	model:SetAttribute("Rarity", hero.Rarity)
	model.Parent = base.HeroFolder

	local scale = hero.Rarity == "Secret" and 1.25 or hero.Rarity == "Mythic" and 1.15 or 1
	local root = makePart(model, "Root", Vector3.new(3.8 * scale, 4.7 * scale, 2.7 * scale), cf, style.Body, Enum.Material.SmoothPlastic)
	local legs = {
		makePart(model, "LegL", Vector3.new(1.5 * scale, 3.2 * scale, 1.6 * scale), cf * CFrame.new(-1, -3.5 * scale, 0), Color3.fromRGB(43, 46, 54), Enum.Material.SmoothPlastic),
		makePart(model, "LegR", Vector3.new(1.5 * scale, 3.2 * scale, 1.6 * scale), cf * CFrame.new(1, -3.5 * scale, 0), Color3.fromRGB(43, 46, 54), Enum.Material.SmoothPlastic),
	}
	for _, leg in ipairs(legs) do leg.CanCollide = false end

	local head = makePart(model, "Head", Vector3.new(3.2 * scale, 3.2 * scale, 3.2 * scale), cf * CFrame.new(0, 4.1 * scale, 0), Color3.fromRGB(239, 198, 165), Enum.Material.SmoothPlastic)
	head.Shape = Enum.PartType.Ball
	head.CanCollide = false

	local hair = makePart(model, "Hair", Vector3.new(3.6 * scale, 1.5 * scale, 3.6 * scale), cf * CFrame.new(0, 5.5 * scale, 0), style.Hair, Enum.Material.SmoothPlastic)
	hair.Shape = Enum.PartType.Ball
	hair.CanCollide = false

	local band = makePart(model, "Headband", Vector3.new(3.4 * scale, 0.65 * scale, 3.45 * scale), cf * CFrame.new(0, 4.8 * scale, -0.15), style.Accent, Enum.Material.Metal)
	band.CanCollide = false

	makePart(model, "Aura", Vector3.new(6.5 * scale, 0.25, 6.5 * scale), cf * CFrame.new(0, -5.1 * scale, 0), rarity.Color, Enum.Material.Neon, 0.16)

	if hero.Rarity == "Legendary" or hero.Rarity == "Mythic" or hero.Rarity == "Secret" then
		for i = 1, 6 do
			local angle = math.rad(i * 60)
			local orb = makePart(
				model,
				"AuraOrb",
				Vector3.new(0.8 * scale, 0.8 * scale, 0.8 * scale),
				cf * CFrame.new(math.cos(angle) * 4.2 * scale, 1 + (i % 2) * 2, math.sin(angle) * 4.2 * scale),
				rarity.Color,
				Enum.Material.Neon,
				0.05
			)
			orb.Shape = Enum.PartType.Ball
			orb.CanCollide = false
		end
	end

	model.PrimaryPart = root
	billboard(root, hero.Name .. "\n" .. hero.Rarity .. "  $" .. rarity.Income .. "/s", rarity.Color, Vector3.new(0, 6.6 * scale, 0))

	local prompt = Instance.new("ProximityPrompt")
	prompt.ActionText = "VOLER"
	prompt.ObjectText = hero.Name
	prompt.HoldDuration = 1
	prompt.MaxActivationDistance = 10
	prompt.RequiresLineOfSight = false
	prompt.Parent = root

	prompt.Triggered:Connect(function(thief)
		if thief == owner then
			notify(thief, "C'est ton héros.", "Info")
			return
		end

		local thiefData = playerData[thief]
		local ownerData = playerData[owner]
		if not thiefData or not ownerData then return end
		if thiefData.Carry then
			notify(thief, "Tu portes déjà quelque chose.", "Error")
			return
		end

		local ownerBase = ownerData.BaseIndex and bases[ownerData.BaseIndex]
		if ownerBase and ownerBase.IsShielded then
			notify(thief, "Le bouclier de cette base est actif.", "Error")
			return
		end

		if #thiefData.Heroes >= Config.MaxHeroes then
			notify(thief, "Ta base est pleine.", "Error")
			return
		end

		local removed
		for i, candidate in ipairs(ownerData.Heroes) do
			if candidate.Id == hero.Id then
				removed = table.remove(ownerData.Heroes, i)
				break
			end
		end
		if not removed then return end

		model:Destroy()
		for i, remaining in ipairs(ownerData.Heroes) do
			local existing = ownerBase.HeroFolder:FindFirstChild(remaining.Id)
			if existing and existing.PrimaryPart then
				existing:PivotTo(heroStandCFrame(ownerBase, i))
			end
		end

		removed.Source = "StolenHero"
		setCarry(thief, removed)
		updatePlayerAttributes(owner)
		notify(thief, "Tu as volé " .. removed.Name .. " ! Ramène-le à ta base.", "Success")
		notify(owner, thief.DisplayName .. " vole " .. removed.Name .. " !", "Danger")
	end)
end

local function addHero(player, hero)
	local data = playerData[player]
	if not data then return false end
	if #data.Heroes >= Config.MaxHeroes then
		notify(player, "Ta base est pleine.", "Error")
		return false
	end

	hero.Id = hero.Id or HttpService:GenerateGUID(false)
	hero.Source = nil
	table.insert(data.Heroes, hero)
	createHeroVisual(player, hero, #data.Heroes)
	updatePlayerAttributes(player)
	return true
end

local function claimBase(player)
	for _, base in ipairs(bases) do
		if not base.Owner then
			base.Owner = player
			base.SignLabel.Text = player.DisplayName:upper() .. "\nBASE " .. base.Index
			base.SignLabel.TextColor3 = base.Accent
			return base
		end
	end
	return nil
end

local function releaseBase(player)
	local data = playerData[player]
	if not data or not data.BaseIndex then return end

	local base = bases[data.BaseIndex]
	if not base then return end

	base.Owner = nil
	base.SignLabel.Text = "BASE LIBRE"
	base.IsShielded = false
	base.ShieldReadyAt = 0
	setShieldVisual(base, false)
	for _, child in ipairs(base.HeroFolder:GetChildren()) do
		child:Destroy()
	end
end

local function buyUpgrade(player, kind)
	local data = playerData[player]
	local stats = player:FindFirstChild("leaderstats")
	local coins = stats and stats:FindFirstChild("Coins")
	if not data or not coins then return end

	if kind == "Base" then
		local cost = Config.GetBaseUpgradeCost(data.BaseLevel)
		if coins.Value < cost then
			notify(player, "Il te faut $" .. cost .. ".", "Error")
			return
		end
		coins.Value -= cost
		data.BaseLevel += 1
		notify(player, "Base niveau " .. data.BaseLevel .. " : revenus augmentés.", "Success")
	elseif kind == "Training" then
		local cost = Config.GetTrainingUpgradeCost(data.TrainingLevel)
		if coins.Value < cost then
			notify(player, "Il te faut $" .. cost .. ".", "Error")
			return
		end
		coins.Value -= cost
		data.TrainingLevel += 1
		notify(player, "Tapis Speed niveau " .. data.TrainingLevel .. ".", "Success")
	end

	updatePlayerAttributes(player)
end

local function activateShield(player)
	local data = playerData[player]
	if not data or not data.BaseIndex then return end
	local base = bases[data.BaseIndex]
	if base.Owner ~= player then return end

	local now = os.clock()
	local readyAt = base.ShieldReadyAt or 0
	if now < readyAt then
		notify(player, "Bouclier disponible dans " .. math.ceil(readyAt - now) .. "s.", "Error")
		return
	end

	base.ShieldReadyAt = now + Config.ShieldCooldown
	setShieldVisual(base, true)
	player:SetAttribute("ShieldActive", true)
	notify(player, "Bouclier actif pendant " .. Config.ShieldDuration .. " secondes.", "Success")

	task.delay(Config.ShieldDuration, function()
		if base.Owner == player then
			setShieldVisual(base, false)
			player:SetAttribute("ShieldActive", false)
			notify(player, "Bouclier désactivé.", "Info")
		end
	end)
end

for _, base in ipairs(bases) do
	base.BasePrompt.Triggered:Connect(function(player)
		if base.Owner == player then
			buyUpgrade(player, "Base")
		end
	end)

	base.TrainingPrompt.Triggered:Connect(function(player)
		if base.Owner == player then
			buyUpgrade(player, "Training")
		end
	end)

	base.ShieldPrompt.Triggered:Connect(function(player)
		if base.Owner == player then
			activateShield(player)
		end
	end)

	base.Deposit.Touched:Connect(function(hit)
		local character = hit.Parent
		local player = character and Players:GetPlayerFromCharacter(character)
		if not player or base.Owner ~= player then return end

		local data = playerData[player]
		if not data or not data.Carry then return end
		if #data.Heroes >= Config.MaxHeroes then
			notify(player, "Ta base est pleine.", "Error")
			return
		end

		local hero = data.Carry
		clearCarry(player)
		local added = addHero(player, hero)
		if added then
			hatchRemote:FireClient(player, hero.Name, hero.Rarity, rarityData(hero.Rarity).Color)
			notify(player, hero.Name .. " rejoint ta base !", "Success")
		end
	end)
end

for index, eggInfo in ipairs(eggs) do
	local available = true

	local function showEgg()
		available = true
		eggInfo.Egg.Transparency = 0
		eggInfo.Prompt.Enabled = true
	end

	eggInfo.Prompt.Triggered:Connect(function(player)
		if not available then return end

		local data = playerData[player]
		if not data then return end
		if data.Carry then
			notify(player, "Tu portes déjà quelque chose.", "Error")
			return
		end
		if #data.Heroes >= Config.MaxHeroes then
			notify(player, "Ta base est pleine.", "Error")
			return
		end

		local stats = player:FindFirstChild("leaderstats")
		local speed = stats and stats:FindFirstChild("Speed")
		local required = eggInfo.RequiredSpeed or 0
		if not speed or speed.Value < required then
			notify(player, "Il te faut " .. required .. " Speed pour voler cet œuf.", "Error")
			return
		end

		available = false
		eggInfo.Prompt.Enabled = false
		eggInfo.Egg.Transparency = 1

		local rolled = Config.RollWorldHero(eggInfo.WorldKey, random)
		rolled.Id = HttpService:GenerateGUID(false)
		rolled.Source = "Egg"
		setCarry(player, rolled)

		local world = Config.GetWorld(eggInfo.WorldKey)
		local worldName = world and world.DisplayName or "WORLD"
		notify(player, rolled.Rarity .. " - " .. rolled.Name .. " ! Retourne à ta base.", "Success")

		task.delay((eggInfo.Respawn or 10) + (index % 3), function()
			if eggInfo.Egg and eggInfo.Egg.Parent then
				showEgg()
			end
		end)
	end)
end

local gateDebounce = {}
for _, gate in ipairs(gates) do
	gate.Trigger.Touched:Connect(function(hit)
		local character = hit.Parent
		local player = character and Players:GetPlayerFromCharacter(character)
		if not player then return end

		local key = tostring(player.UserId) .. ":" .. gate.WorldKey
		if gateDebounce[key] then return end
		gateDebounce[key] = true

		local stats = player:FindFirstChild("leaderstats")
		local speed = stats and stats:FindFirstChild("Speed")
		if speed and speed.Value < gate.RequiredSpeed then
			local root = character:FindFirstChild("HumanoidRootPart")
			if root then
				root.CFrame = gate.ReturnCFrame
			end
			local world = Config.GetWorld(gate.WorldKey)
			notify(player, (world and world.DisplayName or gate.WorldKey) .. " : " .. gate.RequiredSpeed .. " Speed requis.", "Error")
		end

		task.delay(0.8, function()
			gateDebounce[key] = nil
		end)
	end)
end

local function loadData(player)
	local saved
	pcall(function()
		saved = store:GetAsync("u_" .. player.UserId)
	end)
	return type(saved) == "table" and saved or {}
end

local function serialize(player)
	local data = playerData[player]
	local stats = player:FindFirstChild("leaderstats")
	if not data or not stats then return nil end

	local heroes = {}
	for _, hero in ipairs(data.Heroes) do
		table.insert(heroes, {
			Id = hero.Id,
			Name = hero.Name,
			Rarity = hero.Rarity,
			WorldKey = hero.WorldKey,
		})
	end

	return {
		Coins = stats.Coins.Value,
		Speed = stats.Speed.Value,
		BaseLevel = data.BaseLevel,
		TrainingLevel = data.TrainingLevel,
		Heroes = heroes,
	}
end

local function saveData(player)
	local payload = serialize(player)
	if not payload then return end
	pcall(function()
		store:SetAsync("u_" .. player.UserId, payload)
	end)
end

local function setupPlayer(player)
	if playerData[player] then return end
	local saved = loadData(player)

	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player

	local coins = Instance.new("IntValue")
	coins.Name = "Coins"
	coins.Value = tonumber(saved.Coins) or Config.StartingCoins
	coins.Parent = leaderstats

	local speed = Instance.new("IntValue")
	speed.Name = "Speed"
	speed.Value = tonumber(saved.Speed) or Config.StartingSpeed
	speed.Parent = leaderstats

	local heroes = type(saved.Heroes) == "table" and saved.Heroes or {}
	while #heroes > Config.MaxHeroes do
		table.remove(heroes)
	end

	playerData[player] = {
		BaseIndex = nil,
		BaseLevel = tonumber(saved.BaseLevel) or 1,
		TrainingLevel = tonumber(saved.TrainingLevel) or 1,
		Heroes = heroes,
		Carry = nil,
	}

	local base = claimBase(player)
	if not base then
		notify(player, "Serveur plein : aucune base libre.", "Error")
		return
	end

	playerData[player].BaseIndex = base.Index
	base.ShieldReadyAt = 0
	setShieldVisual(base, false)

	for index, hero in ipairs(heroes) do
		hero.Id = hero.Id or HttpService:GenerateGUID(false)
		createHeroVisual(player, hero, index)
	end

	player:SetAttribute("ShieldActive", false)
	updatePlayerAttributes(player)

	player.CharacterAdded:Connect(function(character)
		local humanoid = character:WaitForChild("Humanoid")
		task.wait(0.35)

		if base.Owner == player then
			character:PivotTo(CFrame.new(base.Position + Vector3.new(0, 4, -12)))
		end

		updateWalkSpeed(player)

		if playerData[player] and playerData[player].Carry then
			clearCarry(player)
			notify(player, "Tu as perdu ce que tu transportais.", "Error")
		end

		humanoid.Died:Connect(function()
			if playerData[player] and playerData[player].Carry then
				clearCarry(player)
			end
		end)
	end)

	speed.Changed:Connect(function()
		updateWalkSpeed(player)
	end)

	task.delay(1.5, function()
		if player.Parent == Players then
			notify(player, "Ta base est prête. Traverse la porte et vole un ŒUF NINJA !", "Success")
		end
	end)
end

shopRemote.OnServerEvent:Connect(function(player, action)
	if action == "Base" or action == "Training" then
		buyUpgrade(player, action)
	elseif action == "Shield" then
		activateShield(player)
	end
end)

requestState.OnServerInvoke = function(player)
	local data = playerData[player]
	if not data then return {} end

	return {
		BaseUpgradeCost = Config.GetBaseUpgradeCost(data.BaseLevel),
		TrainingUpgradeCost = Config.GetTrainingUpgradeCost(data.TrainingLevel),
		BaseLevel = data.BaseLevel,
		TrainingLevel = data.TrainingLevel,
		MaxHeroes = Config.MaxHeroes,
		Heroes = data.Heroes,
		Income = computeIncome(player),
	}
end

Players.PlayerAdded:Connect(setupPlayer)
for _, player in ipairs(Players:GetPlayers()) do
	task.spawn(setupPlayer, player)
end

Players.PlayerRemoving:Connect(function(player)
	saveData(player)
	clearCarryVisual(player)
	releaseBase(player)
	playerData[player] = nil
end)

task.spawn(function()
	while true do
		task.wait(1)
		for player, data in pairs(playerData) do
			if player.Parent == Players then
				local stats = player:FindFirstChild("leaderstats")
				if stats then
					stats.Coins.Value += computeIncome(player)
				end
				updatePlayerAttributes(player)
			end
		end
	end
end)

task.spawn(function()
	while true do
		task.wait(0.65)
		for player, data in pairs(playerData) do
			local base = data.BaseIndex and bases[data.BaseIndex]
			local character = player.Character
			local root = character and character:FindFirstChild("HumanoidRootPart")
			local stats = player:FindFirstChild("leaderstats")

			if base and root and stats then
				local localPos = base.TrainingPad.CFrame:PointToObjectSpace(root.Position)
				if math.abs(localPos.X) <= 6.5 and math.abs(localPos.Z) <= 4.5 and math.abs(localPos.Y) <= 6 then
					stats.Speed.Value += Config.GetTrainingGain(data.TrainingLevel)
				end
			end
		end
	end
end)

game:BindToClose(function()
	for _, player in ipairs(Players:GetPlayers()) do
		saveData(player)
	end
	task.wait(1)
end)

print(Config.GameName .. " - polished hub + Naruto world loaded")
