local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Config = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("GameConfig"))

local oldMap = workspace:FindFirstChild("AnimeEggMap")
if oldMap then
	oldMap:Destroy()
end

local map = Instance.new("Model")
map.Name = "AnimeEggMap"
map.Parent = workspace

local function makePart(name, size, position, color, material)
	local part = Instance.new("Part")
	part.Name = name
	part.Anchored = true
	part.Size = size
	part.Position = position
	part.Color = color
	part.Material = material or Enum.Material.SmoothPlastic
	part.TopSurface = Enum.SurfaceType.Smooth
	part.BottomSurface = Enum.SurfaceType.Smooth
	part.Parent = map
	return part
end

makePart("MainIsland", Vector3.new(130, 4, 130), Vector3.new(0, 0, 0), Color3.fromRGB(28, 30, 40), Enum.Material.Slate)
makePart("CenterPlaza", Vector3.new(50, 1, 50), Vector3.new(0, 2.5, 0), Color3.fromRGB(60, 50, 90), Enum.Material.SmoothPlastic)

for i = 1, 28 do
	local angle = math.rad((i - 1) * (360 / 28))
	local x = math.cos(angle) * 28
	local z = math.sin(angle) * 28
	makePart("NeonTile_" .. i, Vector3.new(3, 0.5, 3), Vector3.new(x, 3.1, z), Color3.fromRGB(165, 90, 255), Enum.Material.Neon)
end

local baseColors = {
	Color3.fromRGB(255, 90, 90),
	Color3.fromRGB(255, 176, 70),
	Color3.fromRGB(255, 230, 85),
	Color3.fromRGB(80, 220, 130),
	Color3.fromRGB(75, 170, 255),
	Color3.fromRGB(188, 100, 255),
}

for i = 1, Config.BaseCount do
	local angle = math.rad((i - 1) * (360 / Config.BaseCount))
	local radius = 50
	local x = math.cos(angle) * radius
	local z = math.sin(angle) * radius
	local color = baseColors[i] or Color3.fromRGB(255, 255, 255)

	makePart("Base_" .. i, Vector3.new(23, 1, 19), Vector3.new(x, 3, z), Color3.fromRGB(40, 42, 55), Enum.Material.SmoothPlastic)
	makePart("BaseGlow_" .. i, Vector3.new(19, 0.3, 15), Vector3.new(x, 3.7, z), color, Enum.Material.Neon)

	local sign = makePart("BaseSign_" .. i, Vector3.new(10, 5, 1), Vector3.new(x, 7, z), Color3.fromRGB(22, 23, 31), Enum.Material.SmoothPlastic)
	sign.CFrame = CFrame.lookAt(sign.Position, Vector3.new(0, sign.Position.Y, 0))

	local gui = Instance.new("SurfaceGui")
	gui.Face = Enum.NormalId.Front
	gui.Parent = sign

	local label = Instance.new("TextLabel")
	label.Size = UDim2.fromScale(1, 1)
	label.BackgroundTransparency = 1
	label.Text = "BASE " .. i
	label.TextColor3 = color
	label.TextScaled = true
	label.Font = Enum.Font.GothamBold
	label.Parent = gui
end

makePart("EggPedestal", Vector3.new(12, 3, 12), Vector3.new(0, 4.5, 0), Color3.fromRGB(20, 21, 30), Enum.Material.Marble)

local egg = makePart("MysteryEgg", Vector3.new(5, 7, 5), Vector3.new(0, 9, 0), Color3.fromRGB(255, 235, 255), Enum.Material.SmoothPlastic)
egg.Shape = Enum.PartType.Ball
egg.CanCollide = false

local glow = Instance.new("PointLight")
glow.Color = Color3.fromRGB(190, 110, 255)
glow.Range = 18
glow.Brightness = 3
glow.Parent = egg

local prompt = Instance.new("ProximityPrompt")
prompt.ActionText = "Ramasser"
prompt.ObjectText = "Oeuf mystere"
prompt.HoldDuration = 0.4
prompt.MaxActivationDistance = 12
prompt.Parent = egg

local available = true
prompt.Triggered:Connect(function(player)
	if not available then return end
	available = false
	egg.Transparency = 1
	prompt.Enabled = false

	local stats = player:FindFirstChild("leaderstats")
	if stats then
		local eggs = stats:FindFirstChild("Eggs")
		local coins = stats:FindFirstChild("Coins")
		if eggs then eggs.Value += Config.EggReward end
		if coins then coins.Value += Config.CoinReward end
	end

	task.wait(Config.EggRespawnSeconds)
	egg.Transparency = 0
	prompt.Enabled = true
	available = true
end)

local spawn = Instance.new("SpawnLocation")
spawn.Name = "MainSpawn"
spawn.Size = Vector3.new(8, 1, 8)
spawn.Position = Vector3.new(0, 4, 36)
spawn.Anchored = true
spawn.Neutral = true
spawn.Color = Color3.fromRGB(118, 86, 255)
spawn.Material = Enum.Material.Neon
spawn.Parent = map

Players.PlayerAdded:Connect(function(player)
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player

	local coins = Instance.new("IntValue")
	coins.Name = "Coins"
	coins.Value = Config.StartingCoins
	coins.Parent = leaderstats

	local eggs = Instance.new("IntValue")
	eggs.Name = "Eggs"
	eggs.Value = Config.StartingEggs
	eggs.Parent = leaderstats
end)

print(Config.GameName .. " server loaded")
