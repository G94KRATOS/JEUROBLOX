local Config = {}

Config.GameName = "Anime Capsule Heist"
Config.StartingCoins = 250
Config.StartingSpeed = 0
Config.BaseCount = 8
Config.MaxHeroes = 12
Config.MaxPlayers = 8
Config.CapsuleStealHold = 0.65

Config.SpeedRewards = {
	Naruto = 5,
	OnePiece = 12,
	DragonBall = 28,
	DemonSlayer = 60,
	JJK = 130,
	Bleach = 280,
	AOT = 600,
}

Config.Rarities = {
	Common = { Color = Color3.fromRGB(210, 214, 222), Income = 5 },
	Rare = { Color = Color3.fromRGB(68, 164, 255), Income = 15 },
	Epic = { Color = Color3.fromRGB(176, 78, 255), Income = 50 },
	Legendary = { Color = Color3.fromRGB(255, 185, 52), Income = 150 },
	Mythic = { Color = Color3.fromRGB(255, 71, 112), Income = 500 },
	Secret = { Color = Color3.fromRGB(60, 255, 204), Income = 2200 },
}

Config.Worlds = {
	{
		Key = "Naruto",
		IncomeMultiplier = 1,
		Name = "Naruto Shippuden",
		DisplayName = "SHINOBI WORLD",
		RequiredSpeed = 0,
		CenterZ = 165,
		Accent = Color3.fromRGB(255, 111, 57),
		GroundColor = Color3.fromRGB(101, 190, 88),
		EggRespawn = 8,
		Heroes = {
			{ Name = "Iruka", Rarity = "Common", Weight = 20 },
			{ Name = "Kiba", Rarity = "Common", Weight = 18 },
			{ Name = "Shino", Rarity = "Common", Weight = 16 },
			{ Name = "Rock Lee", Rarity = "Rare", Weight = 13 },
			{ Name = "Neji", Rarity = "Rare", Weight = 10 },
			{ Name = "Temari", Rarity = "Rare", Weight = 7 },
			{ Name = "Kakashi", Rarity = "Epic", Weight = 5.5 },
			{ Name = "Gaara", Rarity = "Epic", Weight = 4.5 },
			{ Name = "Itachi", Rarity = "Legendary", Weight = 2.6 },
			{ Name = "Naruto Sage", Rarity = "Legendary", Weight = 1.8 },
			{ Name = "Madara", Rarity = "Mythic", Weight = 0.8 },
			{ Name = "Six Paths Naruto", Rarity = "Secret", Weight = 0.3 },
		},
	},
	{
		Key = "OnePiece",
		IncomeMultiplier = 2.5,
		Name = "One Piece",
		DisplayName = "PIRATE SEAS",
		RequiredSpeed = 100,
		CenterZ = 445,
		Accent = Color3.fromRGB(61, 181, 255),
		GroundColor = Color3.fromRGB(226, 199, 119),
		EggRespawn = 10,
		Heroes = {
			{ Name = "Usopp", Rarity = "Common", Weight = 22 },
			{ Name = "Nami", Rarity = "Common", Weight = 18 },
			{ Name = "Sanji", Rarity = "Rare", Weight = 16 },
			{ Name = "Zoro", Rarity = "Rare", Weight = 14 },
			{ Name = "Ace", Rarity = "Epic", Weight = 10 },
			{ Name = "Law", Rarity = "Epic", Weight = 8 },
			{ Name = "Shanks", Rarity = "Legendary", Weight = 5.5 },
			{ Name = "Luffy Gear 4", Rarity = "Legendary", Weight = 3.6 },
			{ Name = "Blackbeard", Rarity = "Mythic", Weight = 1.8 },
			{ Name = "Luffy Gear 5", Rarity = "Secret", Weight = 1.1 },
		},
	},
	{
		Key = "DragonBall",
		IncomeMultiplier = 6,
		Name = "Dragon Ball",
		DisplayName = "SAIYAN WASTES",
		RequiredSpeed = 350,
		CenterZ = 725,
		Accent = Color3.fromRGB(255, 190, 54),
		GroundColor = Color3.fromRGB(203, 149, 80),
		EggRespawn = 11,
		Heroes = {
			{ Name = "Krillin", Rarity = "Common", Weight = 19 },
			{ Name = "Piccolo", Rarity = "Rare", Weight = 18 },
			{ Name = "Future Trunks", Rarity = "Rare", Weight = 15 },
			{ Name = "Vegeta", Rarity = "Epic", Weight = 14 },
			{ Name = "Goku Super Saiyan", Rarity = "Epic", Weight = 12 },
			{ Name = "Broly", Rarity = "Legendary", Weight = 8 },
			{ Name = "Gohan Beast", Rarity = "Legendary", Weight = 6 },
			{ Name = "Beerus", Rarity = "Mythic", Weight = 4.5 },
			{ Name = "Ultra Instinct Goku", Rarity = "Secret", Weight = 3.5 },
		},
	},
	{
		Key = "DemonSlayer",
		IncomeMultiplier = 15,
		Name = "Demon Slayer",
		DisplayName = "DEMON FOREST",
		RequiredSpeed = 750,
		CenterZ = 1005,
		Accent = Color3.fromRGB(255, 78, 95),
		GroundColor = Color3.fromRGB(54, 93, 67),
		EggRespawn = 12,
		Heroes = {
			{ Name = "Inosuke", Rarity = "Common", Weight = 18 },
			{ Name = "Zenitsu", Rarity = "Rare", Weight = 18 },
			{ Name = "Tanjiro", Rarity = "Rare", Weight = 16 },
			{ Name = "Giyu", Rarity = "Epic", Weight = 14 },
			{ Name = "Rengoku", Rarity = "Epic", Weight = 12 },
			{ Name = "Akaza", Rarity = "Legendary", Weight = 8 },
			{ Name = "Muzan", Rarity = "Mythic", Weight = 7 },
			{ Name = "Yoriichi", Rarity = "Secret", Weight = 7 },
		},
	},
	{
		Key = "JJK",
		IncomeMultiplier = 35,
		Name = "Jujutsu Kaisen",
		DisplayName = "CURSED CITY",
		RequiredSpeed = 1500,
		CenterZ = 1285,
		Accent = Color3.fromRGB(160, 86, 255),
		GroundColor = Color3.fromRGB(78, 82, 92),
		EggRespawn = 13,
		Heroes = {
			{ Name = "Nobara", Rarity = "Common", Weight = 16 },
			{ Name = "Megumi", Rarity = "Rare", Weight = 18 },
			{ Name = "Nanami", Rarity = "Rare", Weight = 15 },
			{ Name = "Toji", Rarity = "Epic", Weight = 14 },
			{ Name = "Yuta", Rarity = "Epic", Weight = 12 },
			{ Name = "Gojo", Rarity = "Legendary", Weight = 10 },
			{ Name = "Sukuna", Rarity = "Mythic", Weight = 9 },
			{ Name = "Awakened Gojo", Rarity = "Secret", Weight = 6 },
		},
	},
	{
		Key = "Bleach",
		IncomeMultiplier = 80,
		Name = "Bleach",
		DisplayName = "SOUL CITADEL",
		RequiredSpeed = 3000,
		CenterZ = 1565,
		Accent = Color3.fromRGB(93, 213, 255),
		GroundColor = Color3.fromRGB(226, 229, 234),
		EggRespawn = 14,
		Heroes = {
			{ Name = "Renji", Rarity = "Rare", Weight = 18 },
			{ Name = "Rukia", Rarity = "Rare", Weight = 17 },
			{ Name = "Byakuya", Rarity = "Epic", Weight = 16 },
			{ Name = "Kenpachi", Rarity = "Epic", Weight = 15 },
			{ Name = "Ichigo", Rarity = "Legendary", Weight = 12 },
			{ Name = "Aizen", Rarity = "Legendary", Weight = 10 },
			{ Name = "True Bankai Ichigo", Rarity = "Mythic", Weight = 8 },
			{ Name = "Yhwach", Rarity = "Secret", Weight = 4 },
		},
	},
	{
		Key = "AOT",
		IncomeMultiplier = 180,
		Name = "Attack on Titan",
		DisplayName = "TITAN DISTRICT",
		RequiredSpeed = 6000,
		CenterZ = 1845,
		Accent = Color3.fromRGB(221, 110, 67),
		GroundColor = Color3.fromRGB(130, 135, 116),
		EggRespawn = 15,
		Heroes = {
			{ Name = "Jean", Rarity = "Rare", Weight = 17 },
			{ Name = "Sasha", Rarity = "Rare", Weight = 16 },
			{ Name = "Mikasa", Rarity = "Epic", Weight = 16 },
			{ Name = "Levi", Rarity = "Epic", Weight = 15 },
			{ Name = "Armored Titan", Rarity = "Legendary", Weight = 12 },
			{ Name = "War Hammer Titan", Rarity = "Legendary", Weight = 10 },
			{ Name = "Attack Titan Eren", Rarity = "Mythic", Weight = 9 },
			{ Name = "Founding Titan", Rarity = "Secret", Weight = 5 },
		},
	},
}

Config.WorldByKey = {}
for _, world in ipairs(Config.Worlds) do
	Config.WorldByKey[world.Key] = world
end

Config.NarutoWorld = Config.Worlds[1]
Config.FutureWorlds = {}
for index = 2, #Config.Worlds do
	local world = Config.Worlds[index]
	table.insert(Config.FutureWorlds, {
		Name = world.DisplayName,
		InspiredBy = world.Name,
		RequiredSpeed = world.RequiredSpeed,
	})
end

Config.BaseUpgradeBaseCost = 600
Config.TrainingUpgradeBaseCost = 450
Config.ShieldDuration = 20
Config.ShieldCooldown = 60

function Config.GetBaseUpgradeCost(level)
	return math.floor(Config.BaseUpgradeBaseCost * (1.8 ^ math.max(0, level - 1)))
end

function Config.GetTrainingUpgradeCost(level)
	return math.floor(Config.TrainingUpgradeBaseCost * (1.7 ^ math.max(0, level - 1)))
end

function Config.GetIncomeMultiplier(baseLevel)
	return 1 + ((math.max(1, baseLevel) - 1) * 0.25)
end

function Config.GetHeroIncome(hero)
	local rarity = Config.Rarities[hero.Rarity] or Config.Rarities.Common
	local world = Config.GetWorld(hero.WorldKey) or Config.NarutoWorld
	local worldMultiplier = world.IncomeMultiplier or 1
	return math.max(1, math.floor(rarity.Income * worldMultiplier))
end

function Config.GetCaptureSpeedReward(worldKey)
	return Config.SpeedRewards[worldKey] or 5
end

function Config.GetReturnBonus(hero)
	return math.max(25, Config.GetHeroIncome(hero) * 8)
end

function Config.GetTrainingGain(trainingLevel)
	return math.max(1, math.floor(1.6 ^ (math.max(1, trainingLevel) - 1)))
end

function Config.GetWorld(key)
	return Config.WorldByKey[key]
end

function Config.RollWorldHero(key, random)
	local world = Config.GetWorld(key) or Config.NarutoWorld
	random = random or Random.new()

	local total = 0
	for _, hero in ipairs(world.Heroes) do
		total += hero.Weight
	end

	local roll = random:NextNumber(0, total)
	local cursor = 0
	for _, hero in ipairs(world.Heroes) do
		cursor += hero.Weight
		if roll <= cursor then
			return {
				Name = hero.Name,
				Rarity = hero.Rarity,
				WorldKey = world.Key,
			}
		end
	end

	local fallback = world.Heroes[1]
	return {
		Name = fallback.Name,
		Rarity = fallback.Rarity,
		WorldKey = world.Key,
	}
end

function Config.RollNarutoHero(random)
	return Config.RollWorldHero("Naruto", random)
end

return Config
