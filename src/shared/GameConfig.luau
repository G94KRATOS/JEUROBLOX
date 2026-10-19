local Config = {}

Config.GameName = "Anime Egg Heist"
Config.StartingCoins = 250
Config.StartingSpeed = 0
Config.BaseCount = 8
Config.MaxHeroes = 12

Config.Rarities = {
	Common = { Color = Color3.fromRGB(210, 214, 222), Income = 5 },
	Rare = { Color = Color3.fromRGB(68, 164, 255), Income = 15 },
	Epic = { Color = Color3.fromRGB(176, 78, 255), Income = 50 },
	Legendary = { Color = Color3.fromRGB(255, 185, 52), Income = 150 },
	Mythic = { Color = Color3.fromRGB(255, 71, 112), Income = 500 },
	Secret = { Color = Color3.fromRGB(60, 255, 204), Income = 2200 },
}

Config.NarutoWorld = {
	Name = "Naruto Shippuden",
	DisplayName = "SHINOBI WORLD",
	RequiredSpeed = 0,
	EggRespawn = 8,
	Heroes = {
		{ Name = "Iruka", Rarity = "Common", Weight = 22 },
		{ Name = "Kiba", Rarity = "Common", Weight = 22 },
		{ Name = "Shino", Rarity = "Common", Weight = 18 },
		{ Name = "Rock Lee", Rarity = "Rare", Weight = 13 },
		{ Name = "Neji", Rarity = "Rare", Weight = 10 },
		{ Name = "Temari", Rarity = "Rare", Weight = 7 },
		{ Name = "Kakashi", Rarity = "Epic", Weight = 3.5 },
		{ Name = "Gaara", Rarity = "Epic", Weight = 2.5 },
		{ Name = "Itachi", Rarity = "Legendary", Weight = 1.1 },
		{ Name = "Naruto Sage", Rarity = "Legendary", Weight = 0.6 },
		{ Name = "Madara", Rarity = "Mythic", Weight = 0.22 },
		{ Name = "Six Paths Naruto", Rarity = "Secret", Weight = 0.08 },
	},
}

Config.FutureWorlds = {
	{ Name = "Pirate World", InspiredBy = "One Piece", RequiredSpeed = 100 },
	{ Name = "Energy World", InspiredBy = "Dragon Ball", RequiredSpeed = 350 },
	{ Name = "Demon Blade World", InspiredBy = "Demon Slayer", RequiredSpeed = 750 },
	{ Name = "Cursed World", InspiredBy = "Jujutsu Kaisen", RequiredSpeed = 1500 },
	{ Name = "Soul World", InspiredBy = "Bleach", RequiredSpeed = 3000 },
	{ Name = "Titan World", InspiredBy = "Attack on Titan", RequiredSpeed = 6000 },
}

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

function Config.GetTrainingGain(trainingLevel)
	return math.max(1, math.floor(1.6 ^ (math.max(1, trainingLevel) - 1)))
end

function Config.RollNarutoHero(random)
	random = random or Random.new()
	local total = 0
	for _, hero in ipairs(Config.NarutoWorld.Heroes) do
		total += hero.Weight
	end

	local roll = random:NextNumber(0, total)
	local cursor = 0
	for _, hero in ipairs(Config.NarutoWorld.Heroes) do
		cursor += hero.Weight
		if roll <= cursor then
			return {
				Name = hero.Name,
				Rarity = hero.Rarity,
			}
		end
	end

	local fallback = Config.NarutoWorld.Heroes[1]
	return { Name = fallback.Name, Rarity = fallback.Rarity }
end

return Config
