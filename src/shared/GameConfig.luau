local Config = {}

Config.GameName = "ANIME EGG HEIST"
Config.StartingCoins = 300
Config.StartingSpeed = 0
Config.MaxPets = 12
Config.BaseCount = 7

Config.Rarities = {
	Common = {
		Color = Color3.fromRGB(175, 184, 197),
		Income = 4,
	},
	Rare = {
		Color = Color3.fromRGB(76, 170, 255),
		Income = 10,
	},
	Epic = {
		Color = Color3.fromRGB(177, 86, 255),
		Income = 28,
	},
	Legendary = {
		Color = Color3.fromRGB(255, 188, 55),
		Income = 85,
	},
	Mythic = {
		Color = Color3.fromRGB(255, 75, 116),
		Income = 240,
	},
	Secret = {
		Color = Color3.fromRGB(82, 255, 213),
		Income = 750,
	},
}

Config.PetNames = {
	Common = {"Leaf Rookie", "Spirit Scout", "Street Ninja"},
	Rare = {"Thunder Ronin", "Crimson Mage", "Aqua Fighter"},
	Epic = {"Void Samurai", "Frost Shinobi", "Phantom Archer"},
	Legendary = {"Sun Emperor", "Storm Captain", "Golden Blade"},
	Mythic = {"Dragon Sage", "Celestial Reaper", "Demon Prince"},
	Secret = {"Eclipse King", "Infinity Hero", "Cosmic Sovereign"},
}

Config.Zones = {
	{
		Name = "Blossom Village",
		Z = 145,
		RequiredSpeed = 0,
		FloorColor = Color3.fromRGB(94, 164, 92),
		Accent = Color3.fromRGB(255, 129, 188),
		SkyColor = Color3.fromRGB(255, 189, 220),
		Rarities = {
			{Rarity = "Common", Weight = 72},
			{Rarity = "Rare", Weight = 24},
			{Rarity = "Epic", Weight = 4},
		},
	},
	{
		Name = "Sunscorch Desert",
		Z = 335,
		RequiredSpeed = 75,
		FloorColor = Color3.fromRGB(194, 145, 76),
		Accent = Color3.fromRGB(255, 192, 70),
		SkyColor = Color3.fromRGB(255, 218, 159),
		Rarities = {
			{Rarity = "Common", Weight = 36},
			{Rarity = "Rare", Weight = 46},
			{Rarity = "Epic", Weight = 16},
			{Rarity = "Legendary", Weight = 2},
		},
	},
	{
		Name = "Frost Kingdom",
		Z = 525,
		RequiredSpeed = 250,
		FloorColor = Color3.fromRGB(126, 177, 202),
		Accent = Color3.fromRGB(107, 225, 255),
		SkyColor = Color3.fromRGB(191, 238, 255),
		Rarities = {
			{Rarity = "Rare", Weight = 43},
			{Rarity = "Epic", Weight = 43},
			{Rarity = "Legendary", Weight = 13},
			{Rarity = "Mythic", Weight = 1},
		},
	},
	{
		Name = "Inferno Citadel",
		Z = 715,
		RequiredSpeed = 700,
		FloorColor = Color3.fromRGB(75, 61, 65),
		Accent = Color3.fromRGB(255, 92, 44),
		SkyColor = Color3.fromRGB(218, 89, 64),
		Rarities = {
			{Rarity = "Epic", Weight = 45},
			{Rarity = "Legendary", Weight = 43},
			{Rarity = "Mythic", Weight = 11},
			{Rarity = "Secret", Weight = 1},
		},
	},
	{
		Name = "Celestial Rift",
		Z = 905,
		RequiredSpeed = 1800,
		FloorColor = Color3.fromRGB(42, 37, 79),
		Accent = Color3.fromRGB(143, 104, 255),
		SkyColor = Color3.fromRGB(118, 96, 210),
		Rarities = {
			{Rarity = "Legendary", Weight = 58},
			{Rarity = "Mythic", Weight = 37},
			{Rarity = "Secret", Weight = 5},
		},
	},
}

Config.BaseUpgradeBaseCost = 600
Config.TrainingUpgradeBaseCost = 450

function Config.GetBaseUpgradeCost(level)
	return math.floor(Config.BaseUpgradeBaseCost * (1.85 ^ math.max(0, level - 1)))
end

function Config.GetTrainingUpgradeCost(level)
	return math.floor(Config.TrainingUpgradeBaseCost * (1.7 ^ math.max(0, level - 1)))
end

function Config.GetIncomeMultiplier(baseLevel)
	return 1 + ((baseLevel - 1) * 0.25)
end

function Config.GetTrainingGain(trainingLevel)
	return math.max(1, trainingLevel)
end

return Config
